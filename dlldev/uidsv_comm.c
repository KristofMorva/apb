/*
===========================================================================

Return to Castle Wolfenstein multiplayer GPL Source Code
Copyright (C) 1999-2010 id Software LLC, a ZeniMax Media company. 

This file is part of the Return to Castle Wolfenstein multiplayer GPL Source Code (RTCW MP Source Code).  

RTCW MP Source Code is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

RTCW MP Source Code is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with RTCW MP Source Code.  If not, see <http://www.gnu.org/licenses/>.

In addition, the RTCW MP Source Code is also subject to certain additional terms. You should have received a copy of these additional terms immediately following the terms and conditions of the GNU General Public License which accompanied the RTCW MP Source Code.  If not, please request a copy in writing from id Software at the address below.

If you have questions concerning this license or the applicable additional terms, you may contact in writing id Software LLC, c/o ZeniMax Media Inc., Suite 120, Rockville, Maryland 20850 USA.

===========================================================================
*/


/*
=======================================================================

CLIENT SIDE NETCHAN COMMUNICATION

=======================================================================
*/


//seqclient_t

/*
==============
CL_Netchan_Encode

	// first 12 bytes of the data are always:
	long serverId;
	long messageAcknowledge;
	long reliableAcknowledge;

==============
*/


static void CL_Netchan_Encode( seqclient_t* clq, byte *data, int cursize ){

	int i, index, sindex;
	byte key, *string, *secret;

	if( !cursize - CL_ENCODE_START)

	secret = (byte *)clq->encryptionKey;
	string = (byte *)clq->serverCommands[ clq->serverCommandSequence & ( MAX_RELIABLE_COMMANDS - 1 ) ];

	key = clq->svchallenge ^ clq->clchallenge ^ clq->messageAcknowledge ^ clq->serverId;
	for ( i = CL_ENCODE_START, index = 0, sindex = 0; i < cursize; i++ ) {
		// modify the key with the last received now acknowledged server command
		if ( !string[index] ) {
			index = 0;
		}

		if ( !secret[sindex] ) {
			sindex = 0;
		}

		key ^= secret[sindex];
		key ^= string[index] << ( (i - CL_ENCODE_START) & 1 );
		// encode the data with this key
		data[i] ^= key;

		index++;
		sindex++;
	}
}


/*
	sha256 = Com_SHA256(client->lastClientCommandString);

	if(Q_strncmp(sha256, client->lastEncryptSha, 64)){
		Q_strncpyz(client->lastEncryptSha, sha256, sizeof(client->lastEncryptSha));
		for(i = 0; i < sizeof(client->lastEncryptSha) - 1; i++){
			client->encryptionKey[i] ^= client->lastEncryptSha[i];
		}
	}
*/

/*
==============
CL_Netchan_Decode

	// first four bytes of the data are always:
	long reliableAcknowledge;

==============
*/
static void CL_Netchan_Decode( seqclient_t *clq, byte *data, int cursize) {
	long i, index, sindex;
	byte key, *string, *secret;

	if( !(cursize - CL_DECODE_START)) return;

	secret = (byte *)clq->decryptionKey;
	string = (byte *)clq->reliableCommands[ clq->reliableAcknowledge & ( MAX_RELIABLE_COMMANDS - 1 ) ];

	// xor the client challenge with the netchan sequence number (need something that changes every message)
	key = clq->svchallenge ^ clq->clchallenge ^ clq->netchan.incomingSequence;

	for ( i = CL_DECODE_START, index = 0, sindex = 0; i < cursize; i++ ) {
		// modify the key with the last sent and with this message acknowledged client command
		if ( !secret[sindex] ) {
			sindex = 0;
		}
		if ( !string[index] ) {
			index = 0;
		}

		key ^= secret[sindex];
		key ^= string[index] << ( (i+8) & 1 );
		// decode the data with this key
		data[i] ^= key;

		index++;
		sindex++;
	}
}

/*
=================
CL_Netchan_TransmitNextFragment
=================
*/
void CL_Netchan_TransmitNextFragment( netchan_t *chan ) {
	Netchan_TransmitNextFragment( chan );
}

/*
================
CL_Netchan_Transmit
================
*/
void CL_Netchan_Transmit( seqclient_t *clq, byte* data, int cursize ) {

	CL_Netchan_Encode( clq, data, cursize );
	Netchan_Transmit( &clq->netchan, cursize, data );
}



/*
================
CL_AddrToServer
================
*/

seqclient_t* CL_AddrToServer(netadr_t from){

	seqclient_t *clq;

	// if not from our server, ignore it
	if ( NET_CompareAdr( from, svse.authserver.connectAddress ) ) {
		clq = &svse.authserver;
	}else if( NET_CompareAdr( from, svse.scrMaster.connectAddress ) ) {
		clq = &svse.scrMaster;
	}else{
		clq = NULL;
	}
	return clq;
}


/*
=======================================================================

CLIENT (RELIABLE) COMMAND COMMUNICATION

=======================================================================
*/

/*
===================
CL_WritePacket

Create and send the command packet to the server
Including both the reliable commands and the usercmds

During normal gameplay, a client packet will contain something like:

4	sequence number
2	qport
4	serverid
4	acknowledged sequence number
4	clc.serverCommandSequence
<optional reliable commands>
1	clc_move or clc_moveNoDelta
1	command count
<count * usercmds>


This function gets called each frame
===================
*/


void CL_WritePacket( seqclient_t* clq ) {
	msg_t buf;
	byte data[MAX_MSGLEN];
	int i;

	if(clq->state < CA_CONNECTED)
		return;

	if(clq->reliableSequence == clq->reliableAcknowledge){
		if(clq->lastPacketTime + HEARTBEAT_TIME < svs.time){
			CL_AddReliableCommand( clq, "heartbeat");
		}
		clq->connectionTimeout = svs.time;
		return;
	}
	if(clq->reliableSent != clq->reliableAcknowledge){

		if(clq->lastPacketSentTime + NEXT_RELIABLE_TIME > svs.time){
			return;
		}
		if(clq->connectionTimeout && clq->connectionTimeout + CONNECTION_TIMEOUT < svs.time){
		//Disconnect from server
			Com_Printf("UIDServer connection timed out. Trying to reconnect. RelAck: %i Seq: %i\n", clq->reliableAcknowledge, clq->reliableSent);
			clq->state = CA_CHALLENGING;
			return;
		}
	}
	MSG_Init( &buf, data, sizeof( data ) );
	// write the current serverId so the server
	// can tell if this is from the current gameState
	MSG_WriteByte( &buf, clq->serverId );
	// write the last message we received, which can
	// be used for delta compression, and is also used
	// to tell if we dropped a gamestate
	MSG_WriteLong( &buf, clq->serverMessageSequence );

	// write the last reliable message we received
	MSG_WriteLong( &buf, clq->serverCommandSequence );
	
	// write any unacknowledged clientCommands
	// NOTE TTimo: if you verbose this, you will see that there are quite a few duplicates
	// typically several unacknowledged cp or userinfo commands stacked up
	for ( i = clq->reliableAcknowledge + 1 ; i <= clq->reliableSequence ; i++ ) {
		MSG_WriteByte( &buf, clc_clientCommand );
		MSG_WriteLong( &buf, i );
		MSG_WriteString( &buf, clq->reliableCommands[ i & ( MAX_RELIABLE_COMMANDS - 1 ) ] );
	}

	clq->lastPacketSentTime = svs.time;

	clq->reliableSent = clq->reliableSequence;
	if(!clq->connectionTimeout)
		clq->connectionTimeout = svs.time;

	MSG_WriteByte( &buf, clc_EOF);
	Huff_Compress( &buf, 9);
	CL_Netchan_Transmit( clq, buf.data, buf.cursize);

	// clients never really should have messages large enough
	// to fragment, but in case they do, fire them all off
	// at once
	// TTimo: this causes a packet burst, which is bad karma for winsock
	// added a WARNING message, we'll see if there are legit situations where this happens
	while ( clq->netchan.unsentFragments ) {
		CL_Netchan_TransmitNextFragment( &clq->netchan );
	}
}

/*
===================
CL_SendMessage

Create and send simple unreliable messages
Usage is to acknowledge a previous received reliable message
===================
*/
void CL_SendMessage( seqclient_t* clq, msg_t *msg ) {
	msg_t buf;
	byte data[MAX_MSGLEN];
	int i;

	if(clq->state < CA_CONNECTED)
		return;

	MSG_Init( &buf, data, sizeof( data ) );
	// write the current serverId so the server
	// can tell if this is from the current gameState
	MSG_WriteByte( &buf, clq->serverId );

	// write the last message we received, which can
	// be used for delta compression, and is also used
	// to tell if we dropped a gamestate
	MSG_WriteLong( &buf, clq->serverMessageSequence );

	// write the last reliable message we received
	MSG_WriteLong( &buf, clq->serverCommandSequence );

	if( msg->cursize + 2 > buf.maxsize - buf.cursize ){
		Com_Error(ERR_DROP, "CL_SendMessage: MSG Oversize message\n");
		return;
	}

	for(i = 0; i < msg->cursize; i++){
		MSG_WriteByte( &buf, MSG_ReadByte(msg));
	}

	MSG_WriteByte( &buf, clc_EOF);

	clq->lastPacketSentTime = svs.time;
	Huff_Compress( &buf, 9);

	CL_Netchan_Transmit( clq, buf.data, buf.cursize);
}


/*
======================
CL_AddReliableCommand

The given command will be transmitted to the server, and is gauranteed to
not have future usercmd_t executed before it is executed
======================
*/
void CL_AddReliableCommand( seqclient_t* clq, const char *cmd ) {
	int index;

	if(clq->state < CA_CONNECTED)
		return;

	// if we would be losing an old command that hasn't been acknowledged,
	// we must drop the connection
	if ( clq->reliableSequence - clq->reliableAcknowledge > MAX_RELIABLE_COMMANDS ) {
		CL_Disconnect( clq, disconnect_reconnect );
		return;
	}
	clq->reliableSequence++;
	index = clq->reliableSequence & ( MAX_RELIABLE_COMMANDS - 1 );
	Q_strncpyz( clq->reliableCommands[ index ], cmd, sizeof( clq->reliableCommands[ index ] ) );
}

/*
======================
CL_ChangeReliableCommand
For what is this ?
======================
*/
void CL_ChangeReliableCommand( seqclient_t* clq ) {
	int index, l;

	index = clq->reliableSequence & ( MAX_RELIABLE_COMMANDS - 1 );
	l = strlen( clq->reliableCommands[ index ] );
	if ( l >= MAX_MSGLEN - 1 ) {
		l = MAX_MSGLEN - 2;
	}
	clq->reliableCommands[ index ][ l ] = '\n';
	clq->reliableCommands[ index ][ l + 1 ] = '\0';
}

/*
======================
CL_Disconnect

Disconnect client from UserIDServer
======================
*/

void CL_Disconnect( seqclient_t* clq, disconnectType_t type ){

	int i;

	clq->reliableSequence = clq->reliableAcknowledge;	//Clear out all remaining commands

	CL_AddReliableCommand( clq, "disconnect" );
	for(i = 0; i < 6; i++)
		CL_WritePacket( clq );
	
	if(type == disconnect_neverreconnect)
		clq->state = CA_DISCONNECTED;
	else
		clq->state = CA_CHALLENGING;
}

/*
===================
CL_DisconnectPacket

Sometimes the server can drop the client and the netchan based
disconnect can be lost.  If the client continues to send packets
to the server, the server will send out of band disconnect packets
to the client so it doesn't have to wait for the full timeout period.
===================
*/
void CL_DisconnectPacket( netadr_t from , seqclient_t *clq) {

	if(!clq)
	    return;

	if ( clq->state < CA_CONNECTED ) {
		return;
	}


	// if we have received packets within three seconds, ignore (it might be a malicious spoof)
	// NOTE TTimo:
	// there used to be a  clc.lastPacketTime = cls.realtime; line in CL_PacketEvent before calling CL_ConnectionLessPacket
	// therefore .. packets never got through this check, clients never disconnected
	// switched the clc.lastPacketTime = cls.realtime to happen after the connectionless packets have been processed
	// you still can't spoof disconnects, cause legal netchan packets will maintain realtime - lastPacketTime below the threshold

	if( !clq->connectionTimeout || svs.time - clq->connectionTimeout < 6000 ){
		return;
	}
	// drop the connection
	Com_Printf( "Server disconnected for unknown reason\n" );
	clq->state = CA_CHALLENGING;
}

/*
=====================
CL_ParseCommandString

Command strings are just saved off until cgame asks for them
when it transitions a snapshot
=====================
*/
void CL_ParseCommandString( seqclient_t* clq, msg_t *msg ) {

	char    *s;
	int seq;
	int index;
	msg_t returnmsg;
	byte buf[4];

	seq = MSG_ReadLong( msg );
	s = MSG_ReadString( msg );

	MSG_Init(&returnmsg, buf, sizeof(buf));
	MSG_WriteByte(&returnmsg, clc_nop);

	// see if we have already executed stored it off
	if ( clq->serverCommandSequence >= seq ) {
		CL_SendMessage(clq, &returnmsg);
		return;
	}
	clq->connectionTimeout = 0;
	clq->serverCommandSequence = seq;

	index = seq & ( MAX_RELIABLE_COMMANDS - 1 );
	Q_strncpyz( clq->serverCommands[ index ], s, sizeof( clq->serverCommands[ index ] ) );

	if(!clq->commandHandler(s))
		CL_SendMessage(clq, &returnmsg);

}

/*
=================
CL_ParseMessage

Reads the message content we received from UIDServer
=================
*/

void	CL_ParseMessage( seqclient_t* clq, msg_t *msg){

	int cmd;
	static int parseErrorCount;
	//
	// parse the message
	//
	while ( 1 ) {
		if ( msg->readcount > msg->cursize ) {
			Com_Printf("CL_ParseServerMessage: read past end of server message\n" );
			CL_Disconnect( clq, disconnect_reconnect );
			return;
		}
		cmd = MSG_ReadByte( msg );

		if ( cmd == svc_EOF ) {
			break;
		}
		// other commands
		switch ( cmd ) {
		default:
			Com_Printf( "Server: %s: CL_ParseServerMessage: Illegible server message %d\n", NET_AdrToString(clq->netchan.remoteAddress), cmd );

			MSG_BeginReading(msg);

			Com_Printf("Servermessage Seq: %i, ", MSG_ReadLong(msg));
			Com_Printf("RelAck: %i, ", MSG_ReadLong(msg));

			parseErrorCount++;
			if(parseErrorCount > 40){
				CL_Disconnect( clq, disconnect_reconnect );
				parseErrorCount = 0;
			}
			return;
		case svc_nop:
			break;
		case svc_serverCommand:
			CL_ParseCommandString( clq, msg );
			break;
		}
	}
}

/*
=================
CL_ReadPacket
=================
*/
void CL_ReadPacket( seqclient_t* clq, msg_t *msg ) {
	int previousReliableAck;

	if(!clq)
		return;

	if(clq->state != CA_CONNECTED)
		return;

	MSG_BeginReading( msg );

	if ( !Netchan_Process( &clq->netchan, msg ) ) {
		return;     // out of order, duplicated, etc
	}
	clq->lastPacketTime = svs.time;
	previousReliableAck = clq->reliableAcknowledge;

	clq->reliableAcknowledge = MSG_ReadLong( msg );
	if(clq->reliableAcknowledge < clq->reliableSequence - MAX_RELIABLE_COMMANDS){
		Com_Printf("Out of range reliableAcknowledge message from Authserver - reliableSequence is %i, reliableAcknowledge is %i\n",
		clq->reliableSequence, clq->reliableAcknowledge);
		clq->reliableAcknowledge = clq->reliableSequence;
		return;
	}

	CL_Netchan_Decode(clq, &msg->data[msg->readcount], msg->cursize - msg->readcount);
	// track the last message received so it can be returned in
	// client messages, allowing the server to detect a dropped
	// gamestate
	Huff_Decompress( msg, msg->readcount);
	CL_ParseMessage( clq, msg );
	if(msg->overflowed){
		Com_DPrintf("Ignoring illegible message\n");
		clq->reliableAcknowledge = previousReliableAck;
	}
	return;
}


/*
=================
SV_AuthserverConnect()

Resend a connect message if the last one has timed out
=================
*/

void	CL_Connect(seqclient_t* clq){

	int port;
	char info[MAX_INFO_STRING];
	char key[20];

	// resend if we haven't gotten a reply yet
	if ( clq->state != CA_CONNECTING && clq->state != CA_CHALLENGING ) {
		return;
	}

	if (realtime - clq->connectTime < RETRANSMIT_TIMEOUT ) {
		return;
	}

	if(clq->connectPacketCount > 24){
		clq->connectTime += 600;
		clq->connectPacketCount = 0;
		Com_Printf("UID-Server connection failed/timed out\n");
		return;
	}
	clq->connectTime = realtime; // for retransmit requests
	Q_strncpyz(key, clq->connectKey, 18);

	switch ( clq->state ) {
	case CA_CHALLENGING:
		// requesting a challenge
		if(!clq->clchallenge){
			Com_RandomBytes((byte*)&clq->clchallenge, sizeof(int));
		}

		if(!clq->connectPacketCount)
			Com_Printf("Connecting to EUID-Server:\n");

		if(clq->connectAddress.type == NA_IP)
			port = net_port->integer;
		else if(clq->connectAddress.type == NA_IP6)
			port = net_port6->integer;
		else return;

		NET_OutOfBandPrint( NS_CLIENT, clq->connectAddress, "getchallenge %s %i %i" , key, port, clq->clchallenge);
		Com_Printf("  Awaiting Challenge...%d\n", clq->connectPacketCount);
		break;

	case CA_CONNECTING:
		// sending back the challenge
		info[0] = 0;
		Info_SetValueForKey( info, "protocol", va( "%i", AUTHSERVER_PROTOCOL_VERSION ));
		Info_SetValueForKey( info, "qport", va( "%i", (signed short)qport->integer ));
		Info_SetValueForKey( info, "challenge", va( "%i", clq->svchallenge ));

		NET_OutOfBandPrint( NS_CLIENT, clq->connectAddress, "connect %s %i \"%s\"", key, clq->clchallenge, info);
		Com_Printf("  Awaiting Connection...%d\n", clq->connectPacketCount);
		break;

	default:
		Com_Error( ERR_FATAL, "CL_CheckForResend: bad cls.state" );
	}
	clq->connectPacketCount++;
}


/*
=================
CL_ChallengeResponse

The UIDServer responded with a challenge
=================
*/

void CL_ChallengeResponse( netadr_t from, seqclient_t *clq ){

	if(!clq)
	    return;

	// challenge from the server we are connecting to
	if ( clq->state != CA_CHALLENGING ) {
		Com_Printf( "Unwanted challenge response received.  Ignored.\n" );
		return;
	}

	if(atoi(Cmd_Argv_sv(1)) != clq->clchallenge){
		Com_Printf( "Bad challenge from: %s.  Ignored.\n" , NET_AdrToString(from));
		return;
	}

	if(atoi(Cmd_Argv_sv(2)) == 0){
		Com_Printf( "%s sent message: %s\n", NET_AdrToString(from), Cmd_Argv_sv(3));
		return;
	}

	// start sending connect request packets instead of challenge request packets
	clq->svchallenge = atoi(Cmd_Argv_sv(2));
	clq->state = CA_CONNECTING;
	clq->connectPacketCount = 0;
	clq->connectTime = -99999;
}


/*
=================
CL_ConnectResponse

The UIDServer responded with a sucessful connection message
=================
*/

void CL_ConnectResponse( netadr_t from, seqclient_t *clq){

	char	*key;

	if(!clq)
	    return;

	// server connection
	if ( clq->state >= CA_CONNECTED ) {
		Com_Printf( "Dup connect received.  Ignored.\n" );
		return;
	}
	if ( clq->state != CA_CONNECTING ) {
		Com_Printf( "connectResponse packet while not connecting.  Ignored.\n" );
		return;
	}
	if(atoi(Cmd_Argv_sv(1)) != clq->clchallenge){
		Com_Printf( "Bad challenge from server.  Ignored.\n" );
		return;

	}
	if(atoi(Cmd_Argv_sv(2)) == 0){
		Com_Printf( "Server sent message: %s\n", Cmd_Argv_sv(3));
		if(strstr(Cmd_Argv_sv(3), "protocol")){
			clq->state = CA_DISCONNECTED;
		}else if(strstr(Cmd_Argv_sv(3), "bad challenge")){
			clq->state = CA_CHALLENGING;
		}
		return;
	}
	// init the netchan queue
	Netchan_Setup( NS_CLIENT, &clq->netchan, from, qport->integer,
		clq->unsentBuffer, sizeof(clq->unsentBuffer),
		clq->fragmentBuffer, sizeof(clq->fragmentBuffer));

	clq->connectPacketCount = 0;
	clq->state = CA_CONNECTED;
	clq->lastPacketSentTime = 0;
	clq->lastPacketTime = 0;
	clq->reliableSequence = 0;
	clq->reliableAcknowledge = 0;
	clq->reliableSent = 0;
	clq->serverId = 0;
	clq->connectionTimeout = 0;
	clq->messageAcknowledge = 0;
	clq->serverMessageSequence = 0;
	clq->serverCommandSequence = 0;
	clq->connectTime = svs.time;
	Com_Memset(clq->serverCommands, 0, sizeof(clq->serverCommands));
	for(key = clq->connectKey; *key != '-' && *key != 0; key++){}
		
	if(*key != '-'){
		Com_Printf("Bad Key, can't connect\n");
		clq->state = CA_DISCONNECTED;
		return;
	}
	key++;
	key += 10;
	if(strlen(key) != 18){
		Com_Printf("Bad Key, can't connect\n");
		clq->state = CA_DISCONNECTED;
		return;
	}

	Q_strncpyz(clq->encryptionKey, key, sizeof(clq->encryptionKey));
	Q_strncpyz(clq->decryptionKey, key, sizeof(clq->decryptionKey));
	Com_Memset(clq->serverCommands, 0, sizeof(clq->serverCommands));

	clq->state = CA_CONNECTED;
	Com_Printf("Connected.\n");
}