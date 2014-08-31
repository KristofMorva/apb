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

cvar_t *g_allowConsoleSay;
cvar_t *sv_streamServer[MAX_MASTER_SERVERS];
netadr_t sv_streamServerAddr[MAX_MASTER_SERVERS];

//AntiDoS
/*
int SV_ChallengeCookies(netadr_t from){
    char string[128];
    int var_01 = svs.time & 0xff000000;
    Com_sprintf(string, sizeof(string), "");
    return var_01;

}
*/
/*
=================
SV_GetChallenge

A "getchallenge" OOB command has been received
Returns a challenge number that can be used
in a subsequent connectResponse command.
We do this to prevent denial of service attacks that
flood the server with invalid connection IPs.  With a
challenge, they must give a valid IP address.

If we are authorizing, a challenge request will cause a packet
to be sent to the authorize server.

When an authorizeip is returned, a challenge response will be
sent to that ip.

ioquake3: we added a possibility for clients to add a challenge
to their packets, to make it more difficult for malicious servers
to hi-jack client connections.
Also, the auth stuff is completely disabled for com_standalone games
as well as IPv6 connections, since there is no way to use the
v4-only auth server for these new types of connections.
=================
*/
void SV_GetChallenge(netadr_t from)
{
	int		i;
	int		oldest;
	int		oldestTime;
	int		oldestClientTime;
	int		clientChallenge;
	challenge_t	*challenge;

	oldest = 0;
	oldestClientTime = oldestTime = 0x7fffffff;

	// see if we already have a challenge for this ip
	challenge = &svse.challenges[0];
	clientChallenge = atoi(Cmd_Argv(1));

	for(i = 0 ; i < MAX_CHALLENGES ; i++, challenge++)
	{
		if(!challenge->connected && NET_CompareAdr(from, challenge->adr))
		{
			if(challenge->time < oldestClientTime)
				oldestClientTime = challenge->time;
			break;
		}
		
		if(challenge->time < oldestTime)
		{
			oldestTime = challenge->time;
			oldest = i;
		}
	}

	if (i == MAX_CHALLENGES)
	{
		// this is the first time this client has asked for a challenge
		challenge = &svse.challenges[oldest];
		challenge->clientChallenge = clientChallenge;
		challenge->adr = from;
		challenge->firstTime = svs.time;
		challenge->connected = qfalse;
		Q_strncpyz(challenge->pbguid, Cmd_Argv_sv(2),33);
		challenge->ipAuthorize = 0;
		challenge->challenge = ( (rand() << 16) ^ rand() ) ^ svs.time;
	}

	challenge->time = svs.time;
	if(svse.authorizeAddress.type == NA_IP && challenge->adr.type == NA_IP && NET_CompareBaseAdr(from, svse.authorizeAddress)){
		NET_OutOfBandPrint( NS_SERVER, svse.authorizeAddress,
			"getIpAuthorize %i %s \"\" 0",challenge->challenge, NET_AdrToStringShort(from));
		return;
	}
	// Drop the authorize stuff if this client is coming in via v6 as the auth server does not support ipv6.
	// Drop also for addresses coming in on local LAN and for stand-alone games independent from id's assets.
	if(challenge->adr.type == NA_IP && svse.authorizeAddress.type != NA_DOWN && !Sys_IsLANAddress(from) && sv_authorizemode->integer != -1)
	{
		// look up the authorize server's IP
		if (svse.authorizeAddress.type == NA_BAD)
		{
			Com_Printf( "Resolving %s\n", AUTHORIZE_SERVER_NAME );
			if (NET_StringToAdr(AUTHORIZE_SERVER_NAME, &svse.authorizeAddress, NA_IP))
			{
				svse.authorizeAddress.port = BigShort( PORT_AUTHORIZE );
				Com_Printf( "%s resolved to %s\n", AUTHORIZE_SERVER_NAME, NET_AdrToString(svse.authorizeAddress));
			}
		}

		// we couldn't contact the auth server, let them in.
		if(svse.authorizeAddress.type == NA_BAD){
			Com_Printf("Couldn't resolve auth server address\n");
			svse.authorizeAddress.type = NA_DOWN;
			return;
                }
		// if they have been challenging for a long time and we
		// haven't heard anything from the authorize server, go ahead and
		// let them in, assuming the id server is down
		else if(svs.time - oldestClientTime > AUTHORIZE_TIMEOUT)
			Com_Printf( "Activisions authorize server timed out\n" );
		else
		{
			// otherwise send their ip to the authorize server
			Com_DPrintf( "sending getIpAuthorize for %s\n", NET_AdrToString( from ));

			// the 0 is for backwards compatibility with obsolete sv_allowanonymous flags
			// getIpAuthorize <challenge> <IP> <game> 0 <auth-flag>
			NET_OutOfBandPrint( NS_SERVER, from, "needcdkey");
			NET_OutOfBandPrint( NS_SERVER, svse.authorizeAddress,
				"getIpAuthorize %i %s \"\" 0 PB \"%s\"",challenge->challenge, NET_AdrToStringShort(from), challenge->pbguid );
			
			return;
		}
	}
	challenge->pingTime = svs.time;
	NET_OutOfBandPrint(NS_SERVER, challenge->adr, "challengeResponse %d %d",
			   challenge->challenge, clientChallenge);
}



/*
====================
SV_AuthorizeIpPacket

A packet has been returned from the authorize server.
If we have a challenge adr for that ip, send the
challengeResponse to it
====================
*/
void SV_AuthorizeIpPacket( netadr_t from ) {
	int	challenge;
	int	i, k;
	char	*s;
	char	*r;
	char	*p;

	if ( !NET_CompareBaseAdr( from, svse.authorizeAddress )) {
		Com_Printf( "SV_AuthorizeIpPacket: not from authorize server\n" );
		return;
	}
	challenge = atoi( Cmd_Argv_sv( 1 ) );

	for (i = 0 ; i < MAX_CHALLENGES ; i++) {
		if ( svse.challenges[i].challenge == challenge ) {
			break;
		}
	}
	if ( i == MAX_CHALLENGES ) {
		Com_Printf( "SV_AuthorizeIpPacket: challenge not found\n" );
		return;
	}
	if(svse.challenges[i].connected){
	    return;
	}
	// send a packet back to the original client
	s = Cmd_Argv_sv( 2 );
	r = Cmd_Argv_sv( 3 );	// reason
	p = Cmd_Argv_sv( 5 );	//pbguid

	if ( !Q_stricmp( s, "demo" ) ) {
		// they are a demo client trying to connect to a real server
		NET_OutOfBandPrint( NS_SERVER, svse.challenges[i].adr, "error\nServer is not a demo server\n" );
		// clear the challenge record so it won't timeout and let them through
		Com_Memset( &svse.challenges[i], 0, sizeof( svse.challenges[i] ) );
		return;
	}
	if ( !Q_stricmp( s, "accept" )) {
		if(Q_stricmp( p, svse.challenges[i].pbguid)){
			NET_OutOfBandPrint( NS_SERVER, svse.challenges[i].adr, "error\nEXE_ERR_BAD_CDKEY");
			Com_Memset( &svse.challenges[i], 0, sizeof( svse.challenges[i] ));
			return;
		}else{
		        NET_OutOfBandPrint( NS_SERVER, svse.challenges[i].adr, "challengeResponse %i", svse.challenges[i].challenge);
		        svse.challenges[i].pingTime = svs.time;
		        NET_OutOfBandPrint( NS_SERVER, svse.challenges[i].adr, "print\n^2Success...");
			svse.challenges[i].ipAuthorize = 1; //CD-KEY was valid
		        return;
		}
	}

	if (!Q_stricmp( s, "deny" )) {

		for(k = 0; k < MAX_MASTER_SERVERS; k++){//Simple deny
			if(sv_streamServerAddr[k].type != NA_IP || from.type != NA_IP) break;
			if(NET_CompareBaseAdrMask(svse.challenges[i].adr, sv_streamServerAddr[k], 24)){
				NET_OutOfBandPrint( NS_SERVER, svse.challenges[i].adr, "error\nEXE_ERR_CDKEY_IN_USE" );
				Com_Memset( &svse.challenges[i], 0, sizeof( svse.challenges[i] ));
				return;
			}
		}

		svse.challenges[i].ipAuthorize = -1;
		if(!Q_stricmp(r, "CLIENT_UNKNOWN_TO_AUTH")){

			NET_OutOfBandPrint( NS_SERVER, svse.challenges[i].adr, "print\nUnkown how to auth client\n");

		} else if(sv_authorizemode->integer < 2) {

		    NET_OutOfBandPrint( NS_SERVER, svse.challenges[i].adr, "print\n^1Failed. ^5Trying something else...");
		    NET_OutOfBandPrint( NS_SERVER, svse.challenges[i].adr, "challengeResponse %i", svse.challenges[i].challenge);
		    svse.challenges[i].pingTime = svs.time;
		    svse.challenges[i].ipAuthorize = -1; //CD-KEY was invalid
		    return;

		} else if(!Q_stricmp(r, "INVALID_CDKEY")){

			NET_OutOfBandPrint( NS_SERVER, svse.challenges[i].adr, "error\n^1Someone is using this CD Key");
		} else if(r){

			NET_OutOfBandPrint( NS_SERVER, svse.challenges[i].adr, "error\n^1Authorization Failed:\n%s\n", r );
		}else{

			NET_OutOfBandPrint( NS_SERVER, svse.challenges[i].adr, "error\n^1Someone is using this CD Key\n" );
		}
		Com_Memset( &svse.challenges[i], 0, sizeof( svse.challenges[i] ) );
		return;
	}

	NET_OutOfBandPrint( NS_SERVER, svse.challenges[i].adr, "print\n^1Someone is using this CD Key\n" );

	if(sv_authorizemode->integer < 2) {
	    NET_OutOfBandPrint( NS_SERVER, svse.challenges[i].adr, "print\n^1Failed. ^5Trying something else...");
	    NET_OutOfBandPrint( NS_SERVER, svse.challenges[i].adr, "challengeResponse %i", svse.challenges[i].challenge);
	    svse.challenges[i].pingTime = svs.time;
	    svse.challenges[i].ipAuthorize = -1; //CD-KEY was invalid
	}else{
	    Com_Memset( &svse.challenges[i], 0, sizeof( svse.challenges[i] ) );
	}

}


/*
==================
SV_DirectConnect

A "connect" OOB command has been received
==================
*/

typedef struct{
int	challengeslot;
int	firsttime;
int	lasttime;
int	attempts;
}connectqueue_t;	//For fair queuing players who wait for an empty slot

#define PB_MESSAGE "PunkBuster Q_strncpyz( userinfo, Cmd_Argv(1), sizeof(userinfo) );Anti-Cheat software must be installed " \
				"and Enabled in order to join this server. An updated game patch can be downloaded from " \
				"www.idsoftware.com"

void SV_DirectConnect( netadr_t from ) {
	char			userinfo[MAX_INFO_STRING];
	int			reconnectTime;
	int			c;
	int			j;
	int			i;
	client_t		*cl, *newcl;
	int			count;
	char			nick[33];
	int			clientNum;
	int			version;
	int			qport;
	int			challenge;
	char			*password;
	const char		*denied;
	const char		*PunkBusterStatus;
	static connectqueue_t	connectqueue[10];

	Q_strncpyz( userinfo, Cmd_Argv_sv(1), sizeof(userinfo) );
	challenge = atoi( Info_ValueForKey( userinfo, "challenge" ) );
	qport = atoi( Info_ValueForKey( userinfo, "qport" ) );
	// see if the challenge is valid
	int		ping;
	for (c=0 ; c < MAX_CHALLENGES ; c++) {
		if (NET_CompareAdr(from, svse.challenges[c].adr)) {
			if ( challenge == svse.challenges[c].challenge ) {
				break;		// good
			}
		}
	}

	if (c == MAX_CHALLENGES || challenge == 0) {
		NET_OutOfBandPrint( NS_SERVER, from, "error\nNo or bad challenge for address.\n" );
		return;
	}

	newcl = NULL;

	// quick reject
	for (j=0, cl=svs.clients ; j < sv_maxclients->integer ; j++, cl++) {

		if ( NET_CompareBaseAdr( from, cl->netchan.remoteAddress ) && (cl->netchan.qport == qport || from.port == cl->netchan.remoteAddress.port )){

			reconnectTime = (svs.time - cl->lastConnectTime);
			if (reconnectTime < (sv_reconnectlimit->integer * 1000)) {
				Com_Printf("%s -> reconnect rejected : too soon\n", NET_AdrToString (from));
				NET_OutOfBandPrint( NS_SERVER, from, "print\nReconnect limit in effect... (%i)\n",
							(sv_reconnectlimit->integer - (reconnectTime / 1000)));
				return;
			}else{
				if(cl->state > CS_ZOMBIE){	//Free up used CGame-Resources first
					SV_FreeClient( cl );
				}
				newcl = cl;
				Com_Printf("reconnected: %s\n", NET_AdrToString(from));
				cl->lastConnectTime = svs.time;
				break;
			}
		}
	}

	// force the IP key/value pair so the game can filter based on ip
	Info_SetValueForKey( userinfo, "ip", NET_AdrToString( from ) );

	if(!newcl && svse.challenges[c].pingTime){
	        ping = ((svs.time) - (svse.challenges[c].pingTime));
        	svse.challenges[c].pingTime = 0;
	
		Com_Printf( "Client %i connecting with %i challenge ping\n", c, ping );
		if ( sv_minPing->integer && ping < sv_minPing->integer ) {
			// don't let them keep trying until they get a big delay
			NET_OutOfBandPrint( NS_SERVER, from, "error\nServer is for high ping players only minping: %i ms but your ping was: %i ms\n",sv_minPing->integer, ping);
			Com_Printf("Client %i rejected on a too low ping\n", c);
			// reset the address otherwise their ping will keep increasing
			// with each connect message and they'd eventually be able to connect
			svse.challenges[c].adr.port = 0;
			Com_Memset( &svse.challenges[c], 0, sizeof( svse.challenges[c] ));
			return;
		}
		if ( sv_maxPing->integer && ping > sv_maxPing->integer ) {
			NET_OutOfBandPrint( NS_SERVER, from, "error\nServer is for low ping players only maxping: %i ms but your ping was: %i ms\n",sv_maxPing->integer, ping);
			Com_Printf("Client %i rejected on a too high ping\n", c);
			Com_Memset( &svse.challenges[c], 0, sizeof( svse.challenges[c] ));
			return;
		}
	}

	Q_strncpyz(nick, Info_ValueForKey( userinfo, "name" ),33);

	denied = SV_PlayerBannedByip(from);
	if(denied){
            NET_OutOfBandPrint( NS_SERVER, from, "error\n%s\n", denied);
	    Com_Memset( &svse.challenges[c], 0, sizeof( svse.challenges[c] ));
	    return;
	}

	if(strlen(svse.challenges[c].pbguid) < 10){
		NET_OutOfBandPrint( NS_SERVER, from, "error\nConnection rejected: No or invalid GUID found/provided.\n" );
		Com_Printf("Rejected a connection: No or invalid GUID found/provided. Length: %i\n",
		strlen(svse.challenges[c].pbguid));
		Com_Memset( &svse.challenges[c], 0, sizeof( svse.challenges[c] ));
		return;
	}
	version = atoi( Info_ValueForKey( userinfo, "protocol" ));
	if ( version != PROTOCOL_VERSION ) {
		NET_OutOfBandPrint( NS_SERVER, from, "error\nServer uses a different protocol version: %i\n You have to install the update to Call of Duty 4  v1.7", PROTOCOL_VERSION );
		Com_Printf("rejected connect from version %i\n", version);
		Com_Memset( &svse.challenges[c], 0, sizeof( svse.challenges[c] ));
		return;
	}
	
	// find a client slot:
	// if "sv_privateClients" is set > 0, then that number
	// of client slots will be reserved for connections that
	// have "password" set to the value of "sv_privatePassword"
	// Info requests will report the maxclients as if the private
	// slots didn't exist, to prevent people from trying to connect
	// to a full server.
	// This is to allow us to reserve a couple slots here on our
	// servers so we can play without having to kick people.

	//Get new slot for client
	// check for privateClient password
	password = Info_ValueForKey( userinfo, "password" );
	if(!newcl){
		if ( !strcmp( password, sv_privatePassword->string ) ) {
			for ( j = 0; j < sv_privateClients->integer ; j++) {
				cl = &svs.clients[j];
				if (cl->state == CS_FREE) {
					newcl = cl;
					break;
				}
			}
		}
	}
	if(*g_password->string && Q_strncmp(g_password->string, password, 32)){
		NET_OutOfBandPrint( NS_SERVER, from, "error\nThis server has set a join-password\n^1Invalid Password\n");
		Com_Printf("Connection rejected from %s - Invalid Password\n", NET_AdrToString(from));
		Com_Memset( &svse.challenges[c], 0, sizeof( svse.challenges[c] ));
		return;
	}
	//Process queue
	for(i = 0 ; i < 10 ; i++){//Purge all older players from queue
	    if(connectqueue[i].lasttime+21 < realtime){
		connectqueue[i].lasttime = 0;
		connectqueue[i].firsttime = 0;
		connectqueue[i].challengeslot = 0;
		connectqueue[i].attempts = 0;
	    }
	}
	for(i = 0 ; i < 10 ; i++){//Move waiting players up in queue if there is a purged slot
	    if(connectqueue[i].lasttime != 0){
		if(connectqueue[i+1].challengeslot == connectqueue[i].challengeslot){
		    connectqueue[i+1].lasttime = 0;
		    connectqueue[i+1].firsttime = 0;
		    connectqueue[i+1].challengeslot = 0;
		    connectqueue[i+1].attempts = 0;
		}
	    }else{
		Com_Memcpy(&connectqueue[i],&connectqueue[i+1],(9-i)*sizeof(connectqueue_t));
	    }
	}
	for(i = 0 ; i < 10 ; i++){//Find highest slot or the one which is already assigned to this player
	    if(connectqueue[i].firsttime == 0 || connectqueue[i].challengeslot == c){
		break;
	    }
	}
	
	if(i == 0 && !newcl){
		for ( j = sv_privateClients->integer; j < sv_maxclients->integer ; j++) {
			cl = &svs.clients[j];
			if (cl->state == CS_FREE) {
				newcl = cl;
				connectqueue[0].lasttime = 0;
				connectqueue[0].firsttime = 0;
				connectqueue[0].challengeslot = 0;
				connectqueue[0].attempts = 0;
				break;
			}
		}
	}

	if ( !newcl ) {
		if(i == 10){
		    NET_OutOfBandPrint( NS_SERVER, from, "error\nServer is full. More than 10 players are in queue.\n" );
		    return;
		}else{
		    NET_OutOfBandPrint( NS_SERVER, from, "print\nServer is full. %i players wait before you.\n",i);
		}
		if(connectqueue[i].attempts > 30){
		    NET_OutOfBandPrint( NS_SERVER, from, "error\nServer is full. %i players wait before you.\n",i);
		    connectqueue[i].attempts = 0;
		}else if(connectqueue[i].attempts > 15 && i > 1){
		    NET_OutOfBandPrint( NS_SERVER, from, "error\nServer is full. %i players wait before you.\n",i);
		    connectqueue[i].attempts = 0;
		}else if(connectqueue[i].attempts > 5 && i > 3){
		    NET_OutOfBandPrint( NS_SERVER, from, "error\nServer is full. %i players wait before you.\n",i);
		    connectqueue[i].attempts = 0;
		}
		if(connectqueue[i].firsttime == 0){
		    connectqueue[i].firsttime = realtime;
		}
		connectqueue[i].attempts++;
		connectqueue[i].lasttime = realtime;
		connectqueue[i].challengeslot = c;
		return;
	}
	//gotnewcl:	
	Com_Memset(newcl, 0x00, sizeof(client_t)); 
	Com_Memset(&svse.extclients[j], 0x00, sizeof(extclient_t));

	svse.extclients[j].authentication = svse.challenges[c].ipAuthorize;
	svse.extclients[j].power = 0; //Sets the default power for the client
	// (build a new connection
	// accept the new client
	// this is the only place a client_t is ever initialized)


        clientNum = newcl - svs.clients;

        if(svse.challenges[c].ipAuthorize == 1){
            Q_strncpyz(svse.extclients[j].originguid,svse.challenges[c].pbguid,33);
        }

        if(sv_authorizemode->integer != 1){
            denied = CL_IsBanned(0, svse.challenges[c].pbguid, from);
            if(denied){
                NET_OutOfBandPrint( NS_SERVER, from, "error\n%s", denied);
		Com_Memset( &svse.challenges[c], 0, sizeof( svse.challenges[c] ));
                connectqueue[i].lasttime = 0;
                connectqueue[i].firsttime = 0;
                connectqueue[i].challengeslot = 0;
		connectqueue[i].attempts = 0;
		return;
            }
            Q_strncpyz(newcl->pbguid,svse.challenges[c].pbguid,33);	// save the pbguid

            if(svse.challenges[c].ipAuthorize != 1 && sv_authorizemode->integer != -1){
                Com_Memset(newcl->pbguid, '0', 8);
            }

        }else{

            char ret[33];
            Com_sprintf(ret,sizeof(ret),"NoGUID*%.2x%.2x%.2x%.2x%.4x",from.ip[0],from.ip[1],from.ip[2],from.ip[3],from.port);
            Q_strncpyz(newcl->pbguid,ret,20);	// save the pbguid
        }

	PunkBusterStatus = PbAuthClient(NET_AdrToString(from), atoi(Info_ValueForKey( userinfo, "cl_punkbuster" )), newcl->pbguid);
	if(PunkBusterStatus){
	    NET_OutOfBandPrint( NS_SERVER, from, "%s", PunkBusterStatus);
	    Com_Memset( &svse.challenges[c], 0, sizeof( svse.challenges[c] ));
	    return;
	}

	// save the userinfo
	Q_strncpyz(newcl->userinfo, userinfo, 1024 );
	// get the game a chance to reject this connection or modify the userinfo

	newcl->unknowndirectconnect1 = 0;	//Whatever it is ???
	newcl->hasVoip = 1;
        newcl->gentity = SV_GentityNum(clientNum);
        newcl->challenge = svse.challenges[c].challenge; 	// save the challenge
        newcl->clscriptid = Scr_AllocArray();

	denied = ClientConnect(clientNum, newcl->clscriptid);

	if ( denied ) {
		NET_OutOfBandPrint( NS_SERVER, from, "error\n%s\n", denied );
		Com_Printf("Game rejected a connection: %s\n", denied);
		SV_FreeClientScriptId(newcl);
		Com_Memset( &svse.challenges[c], 0, sizeof( svse.challenges[c] ));
		return;
	}

	svse.challenges[c].connected = qtrue;
	
	Com_Printf( "Going from CS_FREE to CS_CONNECTED for %s num %i guid %s\n", nick, clientNum, newcl->pbguid);


	// save the addressgamestateMessageNum
	// init the netchan queue
	Netchan_Setup( NS_SERVER, &newcl->netchan, from, qport,
			 newcl->unsentBuffer, sizeof(newcl->unsentBuffer),
			 newcl->fragmentBuffer, sizeof(newcl->fragmentBuffer));

/*	for(index = 0; index < MAX_RELIABLE_COMMANDS; index++ ){
//		if(index < MAX_RELIABLE_COMMANDS / 2){
			cl->reliableCommands[index] = &cl->lowReliableCommands[index & (MAX_RELIABLE_COMMANDS - 1)];
//		} else {
//			cl->reliableCommands[index] = &svse.extclients[j].highReliableCommands[index & (MAX_RELIABLE_COMMANDS - 1)];
//		}
	}*/

	newcl->state = CS_CONNECTED;
	newcl->nextSnapshotTime = svs.time;
	newcl->lastPacketTime = svs.time;
	newcl->lastConnectTime = svs.time;

	SV_UserinfoChanged(newcl);

	// send the connect packet to the client
	if(ModStats->boolean){
	    NET_OutOfBandPrint( NS_SERVER, from, "connectResponse %s", fs_game->string);
	}else{
	    NET_OutOfBandPrint( NS_SERVER, from, "connectResponse");
	}
	// when we receive the first packet from the client, we will
	// notice that it is from a different serverid and that the
	// gamestate message was not just sent, forcing a retransmit
	newcl->gamestateMessageNum = -1; //newcl->gamestateMessageNum = -1;

	if(strstr(Cvar_GetVariantString("noPbGuids"), svse.extclients[j].originguid) && 32 == strlen(svse.extclients[j].originguid)){
		svse.extclients[j].noPb = qtrue;
	}else{
		svse.extclients[j].noPb = qfalse;
	}

	// if this lastPacketTimewas the first client on the server, or the last client
	// the server can hold, send a heartbeat to the master.
	for (j=0, cl=svs.clients, count=0; j < sv_maxclients->integer; j++, cl++) {
		if (cl->state >= CS_CONNECTED ) {
			count++;
		}
	}
	if ( count == 1 || count == sv_maxclients->integer ) {
		SV_Heartbeat_f();
	}
}


void SV_ReceiveStats(netadr_t from, msg_t* msg){

	short qport;
	qport = MSG_ReadShort( msg );// & 0xffff;
	client_t *cl;
	int i;
	byte curstatspacket;
	byte var_02;
	int buffersize;

	// find which client the message is from
	for ( i = 0, cl = svs.clients ; i < sv_maxclients->integer ; i++,cl++ ) {
		if ( cl->state == CS_FREE ) {
			continue;
		}
		if ( !NET_CompareBaseAdr( from, cl->netchan.remoteAddress ) ) {
			continue;
		}

		// it is possible to have multiple clients from a single IP
		// address, so they are differentiated by the qport variable
		if ( cl->netchan.qport != qport ) {
			continue;
		}

		// the IP port can't be used to differentiate them, because
		// some address translating routers periodically change UDP
		// port assignments
		if ( cl->netchan.remoteAddress.port != from.port ) {
			Com_Printf( "SV_ReceiveStats: fixing up a translated port\n" );
			cl->netchan.remoteAddress.port = from.port;
		}

		curstatspacket = MSG_ReadByte(msg);
		if(curstatspacket > 6){
		    Com_Printf("Invalid stat packet %i of stats data\n", curstatspacket);
		    return;
		}
		Com_Printf("Received packet %i of stats data\n", curstatspacket);
		if((curstatspacket+1)*1240 >= sizeof(cl->stats)){
		    buffersize = sizeof(cl->stats)-(curstatspacket*1240);
		}else{
		    buffersize = 1240;
		}
		MSG_ReadData(msg, &cl->stats[1240*curstatspacket], buffersize);

		cl->receivedstats |= (1 << curstatspacket);
		var_02 = cl->receivedstats;
		var_02 = ~var_02;
		var_02 = var_02 & 127;
		cl->lastPacketTime = svs.time;

		NET_OutOfBandPrint( NS_SERVER, from, "statResponse %i", var_02 );
		return;
	}
}



/*
==================
SV_AuthorizeClientDownload
==================
A check for the client download string to prevent unauthorized download of non Cod4-Mod-files
*/
/*
Deactivated - Is handled in binarycode
*/

qboolean SV_AuthorizeClientDownload(char* downloadstr){
int			cl_downloadOffset = 33961;
client_t		*client;
 if((strstr(downloadstr, ".ff") == NULL && strstr(downloadstr, ".iwd") == NULL) || strstr(downloadstr, "..") != NULL){
	//Kick the client if he tried to download illegal stuff from server
	Com_Printf("Downloadrequest has illegal string: %s \n", downloadstr);
	client = (client_t*)((unsigned int*)downloadstr-(unsigned int*)cl_downloadOffset);
	SV_DropClient(client, "Player kicked: Scriptkiddies are not allowed onto this server");
	Com_Printf("Player kicked - Hack attempt detected!\n");
	return (qtrue);
 }else{
	return (qfalse);
 }
}



void G_SayProcess(gentity_t *ent, gentity_t *other, int mode, char *message){	//Called by chat from Binary

	const char* msg = message;

	if(message[0] == 0x15) msg++;

        if(msg[0] == '$'){	//Check for Command-Prefix
	    msg++;
	    SV_ExecuteRemoteCmd(ent->s.number,msg);
	    return;
        }

	if(Scr_PlayerSay(ent, msg)){
		return;
	}

	if(message[0] != 0x15){
		if(!g_allowConsoleSay->boolean) return;
	}else{
		message++;
	}

	G_SayCensor(message);


	G_Say(ent, other, mode, message);

}


/*
=================
SV_UserinfoChanged

Pull specific info from a newly changed userinfo string
into a more C friendly form.
=================
*/
void SV_UserinfoChanged( client_t *cl ) {
	char	*val;
	char	*ip;
	int	i;
	int	len;
	int	clientNum;
	extclient_t* excl;

	// name for C code
	Q_strncpyz( cl->name, Info_ValueForKey (cl->userinfo, "name"), sizeof(cl->name) );
	clientNum = cl-svs.clients;

	excl = &svse.extclients[clientNum];
	if(!Q_isprintstring(cl->name) || strstr(cl->name,"ID_") || strlen(cl->name) < 3){
		if(cl->state == CS_ACTIVE){
			if(!Q_isprintstring(cl->name)) SV_SendServerCommand(cl, "c \"^5Playernames can not contain advanced ASCII-characters\"");
			if(strlen(cl->name) < 3) SV_SendServerCommand(cl, "c \"^5Playernames can not be shorter than 3 characters\"");
		}
		if(excl->uid <= 0){
		    Com_sprintf(cl->name, 16, "ID_UNKNOWN_%i", clientNum);
		    excl->usernamechanged = UN_NEEDUID;
		} else {
		    Com_sprintf(cl->name, 16, "ID_0:%i", excl->uid);
		    excl->usernamechanged = UN_OK;
		}
		Info_SetValueForKey( cl->userinfo, "name", cl->name);
	}else{
	    excl->usernamechanged = UN_VERIFYNAME;
	}
	// rate command
	// if the client is on the same subnet as the server and we aren't running an
	// internet public server, assume they don't need a rate choke
	if ( Sys_IsLANAddress( cl->netchan.remoteAddress )) {
		cl->rate = 1048576;	// lans should not rate limit
	} else {
		val = Info_ValueForKey (cl->userinfo, "rate");
		if (strlen(val)) {
			i = atoi(val);
			cl->rate = i;
			if (cl->rate < 2500) {
				cl->rate = 2500;
			} else if (cl->rate >= 25000) {
				cl->rate = sv_maxRate->integer;
			}
		} else {
			cl->rate = 2500;
		}
	}
	// snaps command
	val = Info_ValueForKey (cl->userinfo, "snaps");
	
	if(strlen(val))
	{
		i = atoi(val);
		
		if(i < 10)
			i = 10;
		else if(i > sv_fps->integer)
			i = sv_fps->integer;
		else if(i == 30)
			i = sv_fps->integer;

		cl->snapshotMsec = 1000 / i;
	}
	else
		cl->snapshotMsec = 50;

	val = Info_ValueForKey(cl->userinfo, "cl_voice");
	cl->hasVoip = atoi(val);

	// TTimo
	// maintain the IP information
	// the banning code relies on this being consistently present
	if( NET_IsLocalAddress(cl->netchan.remoteAddress) )
		ip = "localhost";
	else
		ip = (char*)NET_AdrToString( cl->netchan.remoteAddress );

	val = Info_ValueForKey( cl->userinfo, "ip" );

	if( val[0] )
		len = strlen( ip ) - strlen( val ) + strlen( cl->userinfo );
	else
		len = strlen( ip ) + 4 + strlen( cl->userinfo );

	if( len >= MAX_INFO_STRING )
		SV_DropClient( cl, "userinfo string length exceeded" );
	else
		Info_SetValueForKey( cl->userinfo, "ip", ip );

	cl->wwwDownload = qfalse;
	if(Info_ValueForKey(cl->userinfo, "cl_wwwDownload")) 
		cl->wwwDownload = qtrue;
}


/*
==================
SV_UpdateUserinfo_f
==================
*//*
static void SV_UpdateUserinfo_f( client_t *cl ) {
	Q_strncpyz( cl->userinfo, Cmd_Argv(1), sizeof(cl->userinfo) );

	SV_UserinfoChanged( cl );
	// call prog code to allow overrides
	VM_Call( gvm, GAME_CLIENT_USERINFO_CHANGED, cl - &svs.clients );
}*/


/*
=====================
SV_DropClient

Called when the player is totally leaving the server, either willingly
or unwillingly.  This is NOT called if the entire server is quiting
or crashing -- SV_FinalMessage() will handle that
=====================
*/
void SV_DropClient( client_t *drop, const char *reason ) {
	int i;
	int clientnum;
	char var_01[2];
	const char *dropreason;
	char clientName[16];
	challenge_t *challenge;

	if ( drop->state <= CS_ZOMBIE ) {
		return;     // already dropped
	}

	if(drop->demorecording)
	{
		SV_StopRecord(drop);
	}
	Q_strncpyz(clientName, drop->name, sizeof(clientName));

	SV_FreeClient(drop);

	if ( !drop->gentity ) {
		// see if we already (maybe still ??) have a challenge for this ip
		challenge = &svse.challenges[0];

		for ( i = 0 ; i < MAX_CHALLENGES ; i++, challenge++ ) {
			if ( NET_CompareAdr( drop->netchan.remoteAddress, challenge->adr ) ) {
				challenge->connected = qfalse;
				break;
			}
		}
	}
	clientnum = drop - svs.clients;

	if(!reason)
		reason = "";

	if(!Q_stricmp(reason, "silent")){
		//Just disconnect him and don't tell anyone about it
		Com_Printf("Player %s^7, %i dropped: %s\n", clientName, clientnum, reason);
		drop->state = CS_ZOMBIE;        // become free in a few seconds
		return;
	}


	if(SEH_StringEd_GetString( reason )){
		var_01[0] = 0x14;
		var_01[1] = 0;
	}else{
		var_01[0] = 0;
	}

	if(!Q_stricmp(reason, "EXE_DISCONNECTED")){
		dropreason = "EXE_LEFTGAME";
	} else {
		dropreason = reason;
	}

	// tell everyone why they got dropped
	SV_SendServerCommand(NULL, "%c \"\x15%s^7 %s%s\"\0", 0x65, clientName, var_01, dropreason);

	Com_Printf("Player %s^7, %i dropped: %s\n", clientName, clientnum, dropreason);

	SV_SendServerCommand(NULL, "%c %d", 0x4b, clientnum);

	// add the disconnect command

	drop->reliableSequence = drop->reliableAcknowledge;	//Reset unsentBuffer and Sequence to ommit the outstanding junk from beeing transmitted
	drop->netchan.unsentFragments = qfalse;
//	SV_SendServerCommand( drop, "%c \"%s\" PB\0", 0x77, dropreason);
	SV_AddServerCommand_old( drop, 1, va("%c \"%s\" PB\0", 0x77, dropreason));
	//No zombie state for bots
	if(drop->netchan.remoteAddress.type == NA_BOT){
		drop->state = CS_FREE;  // become free now
		drop->netchan.remoteAddress.type = 0; //Reset the botflag
		Com_DPrintf( "Going to CS_FREE for %s\n", clientName );
	}else{
		drop->state = CS_ZOMBIE;        // become free in a few seconds
		Com_DPrintf( "Going to CS_ZOMBIE for %s\n", clientName );
	}

	// if this was the last client on the server, send a heartbeat
	// to the master so it is known the server is empty
	// send a heartbeat now so the master will get up to date info
	// if there is already a slot for this ip, reuse it
	for ( i = 0 ; i < sv_maxclients->integer ; i++ ) {
		if ( svs.clients[i].state >= CS_CONNECTED ) {
			break;
		}
	}
	if ( i == sv_maxclients->integer ) {
		SV_Heartbeat_f();
	}
}





/*
==================
SV_UserMove

The message usually contains all the movement commands
that were in the last three packets, so that the information
in dropped packets can be recovered.

On very fast clients, there may be multiple usercmd packed into
each of the backup packets.
==================
*/
void SV_UserMove( client_t *cl, msg_t *msg, qboolean delta ) {
	int i, key, clientNum;
	int *ackTime;
	int cmdCount;
	usercmd_t nullcmd;
	usercmd_t cmds[MAX_PACKET_USERCMDS];
	usercmd_t   *cmd, *oldcmd;
	playerState_t *ps;
//	extclient_t *extcl;

	if ( delta ) {
		cl->deltaMessage = cl->messageAcknowledge;
	} else {
		cl->deltaMessage = -1;
	}

	if(cl->reliableSequence - cl->reliableAcknowledge > MAX_PACKET_USERCMDS){
		return;
	}

	cmdCount = MSG_ReadByte( msg );

	if ( cmdCount < 1 ) {
		Com_Printf( "cmdCount < 1\n" );
		return;
	}

	if ( cmdCount > MAX_PACKET_USERCMDS ) {
		Com_Printf( "cmdCount > MAX_PACKET_USERCMDS\n" );
		return;
	}

	clientNum = cl - svs.clients;
//	extcl = &svse.extclients[clientNum];

	// use the checksum feed in the key
	key = sv.checksumFeed;
	// also use the message acknowledge
	key ^= cl->messageAcknowledge;
	// also use the last acknowledged server command in the key
//	key ^= Com_HashKey( extcl->reliableCommands[ cl->reliableAcknowledge & ( MAX_RELIABLE_COMMANDS - 1 ) ].command, 32 );
	key ^= Com_HashKey( cl->reliableCommands[ cl->reliableAcknowledge & ( MAX_RELIABLE_COMMANDS - 1 ) ].command, 32 );


	ps = SV_GameClientNum( clientNum );

	oldcmd = &nullcmd;

	MSG_SetDefaultUserCmd(ps, oldcmd);


	for ( i = 0 ; i < cmdCount ; i++ ) {
		cmd = &cmds[i];
		MSG_ReadDeltaUsercmdKey( msg, key, oldcmd, cmd );
		if( ! BG_IsWeaponValid(ps, cmd->weapon) ){
			cmd->weapon = ps->weapon;
		}
		if( ! BG_IsWeaponValid(ps, cmd->weapon2) ){
			cmd->weapon2 = ps->weapon2;
		}

		oldcmd = cmd;
	}

	cl->unknownUsercmd1 = MSG_ReadLong(msg);
	cl->unknownUsercmd2 = MSG_ReadLong(msg);
	cl->unknownUsercmd3 = MSG_ReadLong(msg);
	cl->unknownUsercmd4 = MSG_ReadLong(msg);

	// save time for ping calculation
	ackTime = &cl->frames[ cl->messageAcknowledge & PACKET_MASK ].messageAcked;
	if(*ackTime <= 0)
		*ackTime = Sys_Milliseconds();

	// TTimo
	// catch the no-cp-yet situation before SV_ClientEnterWorld
	// if CS_ACTIVE, then it's time to trigger a new gamestate emission
	// if not, then we are getting remaining parasite usermove commands, which we should ignore

	if ( sv_pure->integer != 0 && cl->pureAuthentic == 0 /*&& !cl->gotCP*/ ) {
		if ( cl->state == CS_ACTIVE ) {
			// we didn't get a cp yet, don't assume anything and just send the gamestate all over again
			Com_DPrintf( "%s: didn't get cp command, resending gamestate\n", cl->name, cl->state );
			SV_SendClientGameState( cl );
		}
		return;
	}

	// if this is the first usercmd we have received
	// this gamestate, put the client into the world
	if ( cl->state == CS_PRIMED ) {
		SV_ClientEnterWorld( cl, &cmds[0] );
		// the moves can be processed normaly
	}

	// a bad cp command was sent, drop the client
	if ( sv_pure->integer != 0 && cl->pureAuthentic == 0 ) {
		SV_DropClient( cl, "Cannot validate pure client!" );
		return;
	}

	if ( cl->state != CS_ACTIVE ) {
		cl->deltaMessage = -1;
		return;
	}

	// usually, the first couple commands will be duplicates
	// of ones we have previously received, but the servertimes
	// in the commands will cause them to be immediately discarded
	for ( i =  0 ; i < cmdCount ; i++ ) {
		// if this is a cmd from before a map_restart ignore it
		if ( cmds[i].serverTime > cmds[cmdCount - 1].serverTime ) {
			continue;
		}
		// extremely lagged or cmd from before a map_restart
		//if ( cmds[i].serverTime > svs.time + 3000 ) {
		//	continue;
		//}
		// don't execute if this is an old cmd which is already executed
		// these old cmds are included when cl_packetdup > 0
		if ( cmds[i].serverTime <= cl->lastUsercmd.serverTime ) {   // Q3_MISSIONPACK
	//		if ( cmds[i].serverTime > cmds[cmdCount-1].serverTime ) {
			continue;   // from just before a map_restart
		}
		SV_ClientThink( cl, &cmds[ i ] );
	}
}

/*
==================
SV_ClientEnterWorld
==================
*/
void SV_ClientEnterWorld( client_t *client, usercmd_t *cmd ) {
	int clientNum;
	sharedEntity_t *ent;

	Com_DPrintf( "Going from CS_PRIMED to CS_ACTIVE for %s\n", client->name );
	client->state = CS_ACTIVE;

	// set up the entity for the client
	clientNum = client - svs.clients;
	ent = SV_GentityNum( clientNum );
	ent->s.number = clientNum;
	client->gentity = ent;

	client->deltaMessage = -1;
	client->nextSnapshotTime = svs.time;    // generate a snapshot immediately

	if(cmd)
		client->lastUsercmd = *cmd;

	// call the game begin function
	ClientBegin( clientNum );
}


sharedEntity_t* SV_AddBotClient(){

    int i, cntnames, read;
    short qport;
    client_t *cl;
    const char* denied;
    char name[16];
    char botnames[128][16];
    char userinfo[MAX_INFO_STRING];
    netadr_t botnet;
    usercmd_t ucmd;
    fileHandle_t file;

        //Getting a new name for our bot
	FS_SV_FOpenFileRead("botnames.txt", &file);

	if(!file){
		cntnames = 0;
	}else{
		for(cntnames = 0; cntnames < 128; cntnames++){
			read = FS_ReadLine(botnames[cntnames], 16, file);
			if(read <= 0)
				break;
			if(strlen(botnames[cntnames]) < 2)
				break;
		}
		FS_FCloseFile(file);
	}
	if(!cntnames){
		Q_strncpyz(name,va("bot%d", rand() % 9999),sizeof(name));
	}else{
		Q_strncpyz(name,botnames[rand() % cntnames],sizeof(name));
		for(i = 0; i < sizeof(name); i++){
			if(name[i] == '\n')
				name[i] = 0;
		}
	}

//Find a free serverslot for our bot

	for ( i = sv_privateClients->integer; i < sv_maxclients->integer; i++) {
		cl = &svs.clients[i];
		if (cl->state == CS_FREE) {
			break;
		}
	}
	if( i == sv_maxclients->integer )
		return NULL;		//No free slot

//Connect our bot

	Com_RandomBytes((byte*) &qport, sizeof(short));

	*userinfo = 0;

	Info_SetValueForKey( userinfo, "cg_predictItems", "1");
	Info_SetValueForKey( userinfo, "color", "4");
	Info_SetValueForKey( userinfo, "head", "default");
	Info_SetValueForKey( userinfo, "model", "multi");
	Info_SetValueForKey( userinfo, "snaps", "20");
	Info_SetValueForKey( userinfo, "rate", "99999");
	Info_SetValueForKey( userinfo, "name", name);
	Info_SetValueForKey( userinfo, "protocol", va("%i",PROTOCOL_VERSION));
	Info_SetValueForKey( userinfo, "qport", va("%i", qport));

	Com_Memset(&botnet,0,sizeof(botnet));
	botnet.type = NA_BOT;
	Info_SetValueForKey( userinfo, "ip", NET_AdrToString( botnet ) );

	//gotnewcl:	
	Com_Memset(cl, 0x00, sizeof(client_t)); 
	Com_Memset(&svse.extclients[i], 0x00, sizeof(extclient_t));

	svse.extclients[i].authentication = 1;
	svse.extclients[i].power = 0; //Sets the default power for the client
	// (build a new connection
	// accept the new client
	// this is the only place a client_t is ever initialized)
	Q_strncpyz(cl->pbguid,"BOT-Client",33);	// save the pbguid

	// save the userinfo
	Q_strncpyz(cl->userinfo, userinfo, 1024 );

	cl->unknowndirectconnect1 = 0;	//Whatever it is ???
	cl->hasVoip = 0;
        cl->gentity = SV_GentityNum(i);
        cl->clscriptid = Scr_AllocArray();

	denied = ClientConnect(i, cl->clscriptid);
	if ( denied ) {
		Com_Printf("Bot couldn't connect: %s\n", denied);
		SV_FreeClientScriptId(cl);
		return NULL;
	}
	Com_Printf( "Going from CS_FREE to CS_CONNECTED for %s num %i\n", name, i);

	// save the addressgamestateMessageNum
	// init the netchan queue
	Netchan_Setup( NS_SERVER, &cl->netchan, botnet, qport,
			 cl->unsentBuffer, sizeof(cl->unsentBuffer),
			 cl->fragmentBuffer, sizeof(cl->fragmentBuffer));

/*	for(index = 0; index < MAX_RELIABLE_COMMANDS; index++ ){
		if(index < MAX_RELIABLE_COMMANDS / 2){
			cl->reliableCommands[index] = &cl->lowReliableCommands[index & (MAX_RELIABLE_COMMANDS - 1)];
		} else {
			cl->reliableCommands[index] = &svse.extclients[i].highReliableCommands[index & (MAX_RELIABLE_COMMANDS - 1)];
		}
	}
*/
	cl->state = CS_CONNECTED;
	cl->nextSnapshotTime = svs.time;
	cl->lastPacketTime = svs.time;
	cl->lastConnectTime = svs.time;

	SV_UserinfoChanged(cl);
	// when we receive the first packet from the client, we will
	// notice that it is from a different serverid and that the
	// gamestate message was not just sent, forcing a retransmit
	cl->gamestateMessageNum = -1; //newcl->gamestateMessageNum = -1;

	cl->canNotReliable = 1;
        //Let enter our new bot the game

	SV_SendClientGameState(cl);

	Com_Memset(&ucmd, 0, sizeof(ucmd));

	SV_ClientEnterWorld(cl, &ucmd);

	return SV_GentityNum(i);
}


/*
============
SV_RemoveAllBots
============
*/


void SV_RemoveAllBots(){

	int i;
	client_t *cl;

	for(i=0, cl = svs.clients; i < sv_maxclients->integer; i++, cl++){
		if(cl->netchan.remoteAddress.type == NA_BOT){
			SV_DropClient(cl, NULL);
		}
	}
}


/*
============
SV_RemoveBot
============
*/

sharedEntity_t* SV_RemoveBot() {

	int i;
	client_t *cl;

	for(i = 0, cl = svs.clients; i < sv_maxclients->integer; i++, cl++){
		if(cl->netchan.remoteAddress.type == NA_BOT && cl->state > CS_FREE){
			SV_DropClient(cl, "EXE_DISCONNECTED");
			return SV_GentityNum(i);
		}
	}
	return NULL;
}


char* SV_IsGUID(char* GUID){

	int j, k;

	if(strlen(GUID) == 8){
		k = 8;
	}else if(strlen(GUID) == 32){
		k = 32;
	}else{
		return NULL;
	}
	
	

        j = 0;
        while(j < k){
            if(GUID[j] < 0x30 || GUID[j] > 0x66 || (GUID[j] < 0x41 && GUID[j] > 0x39) || (GUID[j] < 0x61 && GUID[j] > 0x46)){
                return NULL;
            }
            j++;
        }
        Q_strlwr(GUID);
        if(k == 8)
            return GUID;
        else
            return &GUID[24];

}


int SV_GetUid(int clnum){

    if(clnum > 63 || clnum < 0)
        return -1;

    extclient_t *excl = &svse.extclients[clnum];
    if(excl->uid < 1)
        return -1;

    return excl->uid;

}



/*
==================
SV_WWWRedirect

Send the client the full url of the http/ftp download server
==================
*/

void SV_WWWRedirect(client_t *cl, msg_t *msg){

    Com_sprintf(cl->wwwDownloadURL, sizeof(cl->wwwDownloadURL), "%s/%s", sv_wwwBaseURL->string, cl->downloadName);

    Com_Printf("Redirecting client '%s' to %s\n", cl->name, cl->wwwDownloadURL);

    cl->wwwDownloadStarted = qtrue;

    MSG_WriteByte(msg, svc_download);
    MSG_WriteLong(msg, -1);
    MSG_WriteString(msg, cl->wwwDownloadURL);
    MSG_WriteLong(msg, cl->downloadSize);
    MSG_WriteLong(msg, (int32_t)sv_wwwDlDisconnected->boolean);

    cl->wwwDl_var01 = qfalse;

    if(cl->download){
        FS_FCloseFile(cl->download);
    }

    cl->download = 0;
    *cl->downloadName = 0;
}


/*
==================
SV_WriteDownloadToClient

Check to see if the client wants a file, open it if needed and start pumping the client
Fill up msg with data
==================
*/

void SV_WriteDownloadToClient( client_t *cl, msg_t *msg ) {
	int curindex;
	int rate;
	int blockspersnap;
	char errorMessage[1024];

	qboolean bTellRate = qfalse; // verbosity

	if ( !*cl->downloadName ) {
		return; // Nothing being downloaded
	}

	if ( cl->wwwDl_var02 ) {
		return;
	}

	if ( !cl->download ) {
		// We open the file here

		// DHM - Nerve
		// CVE-2006-2082
		// validate the download against the list of pak files
		if ( !FS_VerifyPak( cl->downloadName ) ) {
			// will drop the client and leave it hanging on the other side. good for him
			SV_DropClient( cl, "illegal download request" );
			return;
		}

		if ( !sv_allowDownload->integer || ( cl->downloadSize = FS_SV_FOpenFileRead( cl->downloadName, &cl->download ) ) <= 0 ) {
			// cannot auto-download file
			if ( !sv_allowDownload->integer ) {
				Com_Printf( "clientDownload: %d : \"%s\" download disabled", cl - svs.clients, cl->downloadName );

				if ( sv_pure->integer ) {
					Com_sprintf( errorMessage, sizeof( errorMessage ), "EXE_AUTODL_SERVERDISABLED_PURE\x15%s", cl->downloadName );
				} else {
					Com_sprintf( errorMessage, sizeof( errorMessage ), "EXE_AUTODL_SERVERDISABLED\x15%s", cl->downloadName );
				}

			} else {
				Com_Printf( "clientDownload: %d : \"%s\" file not found on server\n", cl - svs.clients, cl->downloadName );
				Com_sprintf( errorMessage, sizeof( errorMessage ), "EXE_AUTODL_FILENOTONSERVER\x15%s", cl->downloadName );
			}
			MSG_WriteByte( msg, svc_download );
			MSG_WriteShort( msg, 0 ); // client is expecting block zero
			MSG_WriteLong( msg, -1 ); // illegal file size
			MSG_WriteString( msg, errorMessage );

			cl->wwwDl_var01 = 0;
			if(cl->download){
				FS_FCloseFile(cl->download);
			}
			cl->download = 0;
			*cl->downloadName = 0;
			return;
		}

		Com_Printf( "clientDownload: %d : begining \"%s\"\n", cl - svs.clients, cl->downloadName );

		if(sv_wwwDownload->boolean && cl->wwwDownload){
			if(cl->wwwDl_var03){
				cl->wwwDl_var03 = 0;
				return;
			}
			SV_WWWRedirect(cl, msg);
			return;
		}

		// Init
		cl->downloadCurrentBlock = cl->downloadClientBlock = cl->downloadXmitBlock = 0;
		cl->downloadCount = 0;
		cl->downloadEOF = qfalse;

		cl->wwwDownloadStarted = 0;

		bTellRate = qtrue;
	}



	while ( cl->downloadCurrentBlock - cl->downloadClientBlock < MAX_DOWNLOAD_WINDOW && cl->downloadSize != cl->downloadCount ) {

		curindex = ( cl->downloadCurrentBlock % MAX_DOWNLOAD_WINDOW );

		// Perform any reads that we need to
		if ( !cl->downloadBlocks[curindex] ) {
			cl->downloadBlocks[curindex] = Z_Malloc( MAX_DOWNLOAD_BLKSIZE);
			if ( !cl->downloadBlocks) {//Crash fix for download subsystem
				SV_DropClient(cl, "Failed to allocate a new chunk of memory for the serverdownloadsystem");
				return;
			}
		}


		cl->downloadBlockSize[curindex] = FS_Read( cl->downloadBlocks[curindex], MAX_DOWNLOAD_BLKSIZE, cl->download );

		if ( cl->downloadBlockSize[curindex] < 0 ) {
			// EOF right now
			cl->downloadCount = cl->downloadSize;
			break;
		}

		cl->downloadCount += cl->downloadBlockSize[curindex];

		// Load in next block
		cl->downloadCurrentBlock++;
	}

	// Check to see if we have eof condition and add the EOF block
	if ( cl->downloadCount == cl->downloadSize && !cl->downloadEOF &&  cl->downloadCurrentBlock - cl->downloadClientBlock < MAX_DOWNLOAD_WINDOW ) {

		cl->downloadBlockSize[cl->downloadCurrentBlock % MAX_DOWNLOAD_WINDOW] = 0;
		cl->downloadCurrentBlock++;

		cl->downloadEOF = qtrue;  // We have added the EOF block
	}

	// Loop up to window size times based on how many blocks we can fit in the
	// client snapMsec and rate

	// based on the rate, how many bytes can we fit in the snapMsec time of the client
	// normal rate / snapshotMsec calculation
	rate = cl->rate;

	// show_bug.cgi?id=509
	// for autodownload, we use a seperate max rate value
	// we do this everytime because the client might change it's rate during the download
	if ( sv_maxRate->integer < rate ) {
		rate = sv_maxRate->integer;
		if ( bTellRate ) {
			Com_Printf( "'%s' downloading at sv_dl_maxrate (%d)\n", cl->name, sv_maxRate->integer );
		}
	} else if ( bTellRate ) {
		Com_Printf( "'%s' downloading at rate %d\n", cl->name, rate );
	}

	if ( !rate ) {
		blockspersnap = 1;
	} else {
		blockspersnap = ( ( rate * cl->snapshotMsec ) / 1000 + MAX_DOWNLOAD_BLKSIZE ) / MAX_DOWNLOAD_BLKSIZE;
	}

	if ( blockspersnap < 0 ) {
		blockspersnap = 1;
	}

	while ( blockspersnap-- ) {

		// Write out the next section of the file, if we have already reached our window,
		// automatically start retransmitting

		if ( cl->downloadClientBlock == cl->downloadCurrentBlock ) {
			return; // Nothing to transmit

		}
		if ( cl->downloadXmitBlock == cl->downloadCurrentBlock ) {
			// We have transmitted the complete window, should we start resending?

			//FIXME:  This uses a hardcoded one second timeout for lost blocks
			//the timeout should be based on client rate somehow
			if ( svs.time - cl->downloadSendTime > 1000 ) {
				cl->downloadXmitBlock = cl->downloadClientBlock;
			} else {
				return;
			}
		}

		// Send current block
		curindex = ( cl->downloadXmitBlock % MAX_DOWNLOAD_WINDOW );

		MSG_WriteByte( msg, svc_download );
		MSG_WriteLong( msg, cl->downloadXmitBlock );

		// block zero is special, contains file size
		if ( cl->downloadXmitBlock == 0 ) {
			MSG_WriteLong( msg, cl->downloadSize );
		}

		MSG_WriteShort( msg, cl->downloadBlockSize[curindex] );

		// Write the block
		if ( cl->downloadBlockSize[curindex] ) {
			MSG_WriteData( msg, cl->downloadBlocks[curindex], cl->downloadBlockSize[curindex] );
		}

		Com_DPrintf( "clientDownload: %d : writing block %d\n", cl - svs.clients, cl->downloadXmitBlock );

		// Move on to the next block
		// It will get sent with next snap shot.  The rate will keep us in line.
		cl->downloadXmitBlock++;

		cl->downloadSendTime = svs.time;
	}
}

/*
void SV_DlBurstFragments(){
    int i;
    client_t* cl;

//        int time;
//        int diff;
//        time = Sys_Milliseconds();


    for(cl = svs.clients, i = 0; i < sv_maxclients->integer; i++, cl++){

        if(*cl->downloadName && cl->download){
            while(SV_Netchan_TransmitNextFragment(cl));
        }
    }

//    diff = Sys_Milliseconds() - time;
//    Com_Printf("Took %i msec\n", diff);
}*/


/*
================
SV_SendClientGameState

Sends the first message from the server to a connected client.
This will be sent on the initial connection and upon each new map load.

It will be resent if the client acknowledges a later message but has
the wrong gamestate.
================
*/
void SV_SendClientGameState( client_t *client ) {
	msg_t msg;
	byte msgBuffer[MAX_MSGLEN];

	while(client->state != CS_FREE && client->netchan.unsentFragments){
		SV_Netchan_TransmitNextFragment(client);
	}
	if(!client->canNotReliable){

		if(client->receivedstats != 127)
		{
			if(!client->receivedstats)
				NET_OutOfBandPrint(NS_SERVER, client->netchan.remoteAddress, "requeststats\n");

			return;
		}

	}else{
		Com_Memset(client->stats, 0, sizeof(client->stats));
		client->receivedstats = 127;
	}

	Com_DPrintf( "SV_SendClientGameState() for %s\n", client->name );
	Com_DPrintf( "Going from CS_CONNECTED to CS_PRIMED for %s\n", client->name );
	client->state = CS_PRIMED;
	client->pureAuthentic = 0;

	// when we receive the first packet from the client, we will
	// notice that it is from a different serverid and that the
	// gamestate message was not just sent, forcing a retransmit
	client->gamestateMessageNum = client->netchan.outgoingSequence;

	MSG_Init( &msg, msgBuffer, sizeof( msgBuffer ) );

	MSG_ClearLastReferencedEntity(&msg);

	// NOTE, MRE: all server->client messages now acknowledge
	// let the client know which reliable clientCommands we have received
	MSG_WriteLong( &msg, client->lastClientCommand );

	// send any server commands waiting to be sent first.
	// we have to do this cause we send the client->reliableSequence
	// with a gamestate and it sets the clc.serverCommandSequence at
	// the client side
	SV_UpdateServerCommandsToClient( client, &msg );

	// send the gamestate
	SV_WriteGameState(&msg, client);

	MSG_WriteLong( &msg, client - svs.clients );

	// write the checksum feed
	MSG_WriteLong( &msg, sv.checksumFeed );
	
	MSG_WriteByte(&msg, svc_EOF);

	// NERVE - SMF - debug info
	Com_DPrintf( "Sending %i bytes in gamestate to client: %i\n", msg.cursize, client - svs.clients );

	// deliver this to the client
	SV_SendMessageToClient( &msg, client );
	SV_GetServerStaticHeader();
}
