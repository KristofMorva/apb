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
cvar_t	*sv_fps = NULL;			// time rate for running non-clients
cvar_t	*sv_timeout;			// seconds without any message
cvar_t	*sv_zombietime;			// seconds to sink messages after disconnect
cvar_t	*sv_rconPassword;		// password for remote server commands
cvar_t	*sv_privatePassword;		// password for the privateClient slots
cvar_t	*sv_allowDownload;
cvar_t	*sv_maxclients;

cvar_t	*sv_privateClients;		// number of clients reserved for password
cvar_t	*sv_hostname;

cvar_t	*sv_reconnectlimit;		// minimum seconds between connect messages
cvar_t	*sv_showloss;			// report when usercmds are lost
cvar_t	*sv_padPackets;			// add nop bytes to messages
cvar_t	*sv_killserver;			// menu system can set to 1 to shut server down
cvar_t	*sv_mapname;
cvar_t	*sv_mapChecksum;
cvar_t	*sv_serverid;
cvar_t	*sv_minRate;
cvar_t	*sv_maxRate;*/
/*
cvar_t	*sv_minPing;
cvar_t	*sv_maxPing;
cvar_t	*sv_gametype;
cvar_t	*sv_pure;
cvar_t	*sv_floodProtect;
cvar_t	*sv_lanForceRate; // dedicated 1 (LAN) server forces local client rates to 99999 (bug #491)
#ifndef STANDALONE
cvar_t	*sv_strictAuth;
#endif
cvar_t	*sv_banFile;

serverBan_t serverBans[SERVER_MAXBANS];
int serverBansCount = 0;
*/

cvar_t	*sv_master[MAX_MASTER_SERVERS];	// master server ip address
cvar_t	*g_mapstarttime;
cvar_t	*sv_uptime;

/*
=============================================================================

EVENT MESSAGES

=============================================================================
*/

void SV_DumpReliableCommands( client_t *client, const char* cmd) {

	if(!com_developer || com_developer->integer < 2)
		return;


	char msg[1040];

	Com_sprintf(msg, sizeof(msg), "Cl: %i, Seq: %i, Time: %i, NotAck: %i, Len: %i, Msg: %s\n", 
		client - svs.clients, client->reliableSequence, svs.time ,client->reliableSequence - client->reliableAcknowledge, strlen(cmd), cmd);

	Sys_EnterCriticalSection(5);

	if ( com_logfile && com_logfile->integer ) {
    // TTimo: only open the qconsole.log if the filesystem is in an initialized state
    //   also, avoid recursing in the qconsole.log opening (i.e. if fs_debug is on)
	    if ( !reliabledump && FS_Initialized()) {
			struct tm *newtime;
			time_t aclock;

			time( &aclock );
			newtime = localtime( &aclock );

			reliabledump = FS_FOpenFileWrite( "reliableCmds.log" );

			if ( com_logfile->integer > 1 && reliabledump) {
				// force it to not buffer so we get valid
				// data even if we are crashing
				FS_ForceFlush(reliabledump);
			}
			if ( reliabledump ) FS_Write(va("\nLogfile opened on %s\n", asctime( newtime )), strlen(va("\nLogfile opened on %s\n", asctime( newtime ))), reliabledump);
	    }
	    if ( reliabledump && FS_Initialized()) {
		FS_Write(msg, strlen(msg), reliabledump);
	    }
	}
	Sys_LeaveCriticalSection(5);
}


/*
======================
SV_AddServerCommand

The given command will be transmitted to the client, and is guaranteed to
not have future snapshot_t executed before it is executed
======================
*/
void SV_AddServerCommand( client_t *client, int type, const char *cmd ) {



	SV_DumpReliableCommands( client, cmd);
	SV_AddServerCommand_old(client, type, cmd);
	return;




	int index, i;

	if(client->canNotReliable)
		return;
		
	if(client->state < CS_CONNECTED)
		return;

	if( ! *cmd )
		return;

//	extclient_t* extcl = &svse.extclients[ client - svs.clients ];
	client->reliableSequence++;
	
//	extcl->reliableSequence++;
//	Com_PrintNoRedirect("CMD: %i ^5%s\n", client->reliableSequence - client->reliableAcknowledge, cmd);
	// if we would be losing an old command that hasn't been acknowledged,
	// we must drop the connection
	// we check == instead of >= so a broadcast print added by SV_DropClient()
	// doesn't cause a recursive drop client
	if ( client->reliableSequence - client->reliableAcknowledge == MAX_RELIABLE_COMMANDS + 1 ) {

		Com_PrintNoRedirect("Client: %i Reliable commandbuffer overflow\n", client - svs.clients);
		Com_PrintNoRedirect( "Client lost reliable commands\n");
		Com_PrintNoRedirect( "===== pending server commands =====\n" );
		for ( i = client->reliableAcknowledge + 1 ; i <= client->reliableSequence ; i++ ) {
//			Com_DPrintNoRedirect( "cmd %5d: %s\n", i, extcl->reliableCommands[ i & (MAX_RELIABLE_COMMANDS-1) ].command );
			Com_PrintNoRedirect( "cmd %5d: %s\n", i, client->reliableCommands[ i & (MAX_RELIABLE_COMMANDS-1) ].command );
		}

		Com_PrintNoRedirect("cmd: %s\n", cmd);
		Com_PrintNoRedirect( "====================================\n" );
		SV_DropClient( client, "Server command overflow" );
		return;

	}
	index = client->reliableSequence & ( MAX_RELIABLE_COMMANDS - 1 );


//	MSG_WriteReliableCommandToBuffer(cmd, extcl->reliableCommands[ index ].command, sizeof( extcl->reliableCommands[ index ].command ));
//	extcl->reliableCommands[ index ].cmdTime = svs.time;
//	extcl->reliableCommands[ index ].cmdType = 1;

	MSG_WriteReliableCommandToBuffer(cmd, client->reliableCommands[ index ].command, sizeof( client->reliableCommands[ index ].command ));
	client->reliableCommands[ index ].cmdTime = svs.time;
	client->reliableCommands[ index ].cmdType = 1;

	SV_DumpReliableCommands( client, cmd);
}


/*
=================
SV_SendServerCommand

Sends a reliable command string to be interpreted by 
the client game module: "cp", "print", "chat", etc
A NULL client will broadcast to all clients
=================
*/
/*known stuff
"t \" ==  open callvote screen
"h \" ==  chat
"c \" ==  print bold to players screen
"e \" ==  print to players console
*/
void QDECL SV_SendServerCommand(client_t *cl, const char *fmt, ...) {
	va_list		argptr;
	byte		message[MAX_MSGLEN];
	client_t	*client;
	int		j;

	va_start (argptr,fmt);
	Q_vsnprintf ((char *)message, sizeof(message), fmt,argptr);
	va_end (argptr);

	if ( strlen ((char *)message) > 1022 ) {
		return;
	}

	if ( cl != NULL ){
		SV_AddServerCommand_old(cl, 0, (char *)message );
		return;
	}

	// hack to echo broadcast prints to console
	if ( !strncmp( (char *)message, "say", 3) ) {
		Com_Printf("broadcast: %s\n", SV_ExpandNewlines((char *)message) );
	}

	// send the data to all relevent clients
	for (j = 0, client = svs.clients; j < sv_maxclients->integer; j++, client++) {
		if ( client->state < CS_PRIMED ) {
			continue;
		}
		SV_AddServerCommand_old(client, 0, (char *)message );
	}
}


/*
==============================================================================

CONNECTIONLESS COMMANDS

==============================================================================
*/
/*
typedef struct leakyBucket_s leakyBucket_t;
struct leakyBucket_s {
	netadrtype_t	type;

	union {
		byte	_4[4];
		byte	_6[16];
	} ipv;

	int						lastTime;
	signed char		burst;

	long					hash;

	leakyBucket_t *prev, *next;
};

// This is deliberately quite large to make it more of an effort to DoS
#define MAX_BUCKETS			16384
#define MAX_HASHES			1024

static leakyBucket_t buckets[ MAX_BUCKETS ];
static leakyBucket_t *bucketHashes[ MAX_HASHES ];
*/
/*
================
SVC_HashForAddress
================
*//*
static long SVC_HashForAddress( netadr_t address ) {
	byte 		*ip = NULL;
	size_t	size = 0;
	int			i;
	long		hash = 0;

	switch ( address.type ) {
		case NA_IP:  ip = address.ip;  size = 4; break;
		case NA_IP6: ip = address.ip6; size = 16; break;
		default: break;
	}

	for ( i = 0; i < size; i++ ) {
		hash += (long)( ip[ i ] ) * ( i + 119 );
	}

	hash = ( hash ^ ( hash >> 10 ) ^ ( hash >> 20 ) );
	hash &= ( MAX_HASHES - 1 );

	return hash;
}
*/
/*
================
SVC_BucketForAddress

Find or allocate a bucket for an address
================
*//*
static leakyBucket_t *SVC_BucketForAddress( netadr_t address, int burst, int period ) {
	leakyBucket_t	*bucket = NULL;
	int						i;
	long					hash = SVC_HashForAddress( address );
	int						now = Sys_Milliseconds();

	for ( bucket = bucketHashes[ hash ]; bucket; bucket = bucket->next ) {
		switch ( bucket->type ) {
			case NA_IP:
				if ( memcmp( bucket->ipv._4, address.ip, 4 ) == 0 ) {
					return bucket;
				}
				break;

			case NA_IP6:
				if ( memcmp( bucket->ipv._6, address.ip6, 16 ) == 0 ) {
					return bucket;
				}
				break;

			default:
				break;
		}
	}

	for ( i = 0; i < MAX_BUCKETS; i++ ) {
		int interval;

		bucket = &buckets[ i ];
		interval = now - bucket->lastTime;

		// Reclaim expired buckets
		if ( bucket->lastTime > 0 && ( interval > ( burst * period ) ||
					interval < 0 ) ) {
			if ( bucket->prev != NULL ) {
				bucket->prev->next = bucket->next;
			} else {
				bucketHashes[ bucket->hash ] = bucket->next;
			}
			
			if ( bucket->next != NULL ) {
				bucket->next->prev = bucket->prev;
			}

			Com_Memset( bucket, 0, sizeof( leakyBucket_t ) );
		}

		if ( bucket->type == NA_BAD ) {
			bucket->type = address.type;
			switch ( address.type ) {
				case NA_IP:  Com_Memcpy( bucket->ipv._4, address.ip, 4 );   break;
				case NA_IP6: Com_Memcpy( bucket->ipv._6, address.ip6, 16 ); break;
				default: break;
			}

			bucket->lastTime = now;
			bucket->burst = 0;
			bucket->hash = hash;

			// Add to the head of the relevant hash chain
			bucket->next = bucketHashes[ hash ];
			if ( bucketHashes[ hash ] != NULL ) {
				bucketHashes[ hash ]->prev = bucket;
			}

			bucket->prev = NULL;
			bucketHashes[ hash ] = bucket;

			return bucket;
		}
	}

	// Couldn't allocate a bucket for this address
	return NULL;
}
*/
/*
================
SVC_RateLimit
================
*//*
static qboolean SVC_RateLimit( leakyBucket_t *bucket, int burst, int period ) {
	if ( bucket != NULL ) {
		int now = Sys_Milliseconds();
		int interval = now - bucket->lastTime;
		int expired = interval / period;
		int expiredRemainder = interval % period;

		if ( expired > bucket->burst ) {
			bucket->burst = 0;
			bucket->lastTime = now;
		} else {
			bucket->burst -= expired;
			bucket->lastTime = now - expiredRemainder;
		}

		if ( bucket->burst < burst ) {
			bucket->burst++;

			return qfalse;
		}
	}

	return qtrue;
}
*/
/*
================
SVC_RateLimitAddress

Rate limit for a particular address
================
*//*
static qboolean SVC_RateLimitAddress( netadr_t from, int burst, int period ) {
	leakyBucket_t *bucket = SVC_BucketForAddress( from, burst, period );

	return SVC_RateLimit( bucket, burst, period );
}
*/
/*
================
SVC_Status

Responds with all the info that qplug or qspy can see about the server
and all connected players.  Used for getting detailed information after
the simple info query.
================
*/
void SVC_Status( netadr_t from ) {
	char player[1024];
	char status[MAX_MSGLEN];
	int i;
	client_t    *cl;
	gclient_t *gclient;
	int statusLength;
	int playerLength;
	char infostring[MAX_INFO_STRING];
//	static leakyBucket_t bucket;


	// Prevent using getstatus as an amplifier
/*	if ( SVC_RateLimitAddress( from, 10, 1000 ) ) {
		Com_DPrintf( "SVC_Status: rate limit from %s exceeded, dropping request\n",
			NET_AdrToString( from ) );
		return;
	}*/

	// Allow getstatus to be DoSed relatively easily, but prevent
	// excess outbound bandwidth usage when being flooded inbound
/*	if ( SVC_RateLimit( &bucket, 10, 100 ) ) {
		Com_DPrintf( "SVC_Status: rate limit exceeded, dropping request\n" );
		return;
	}*/

	if(strlen(Cmd_Argv_sv(1)) > 128)
		return;

	strcpy( infostring, Cvar_InfoString( 0, (CVAR_SERVERINFO | CVAR_NORESTART)) );
	// echo back the parameter to status. so master servers can use it as a challenge
	// to prevent timed spoofed reply packets that add ghost servers
	Info_SetValueForKey( infostring, "challenge", Cmd_Argv_sv( 1 ) );

	if(*g_password->string)
	    Info_SetValueForKey( infostring, "pswrd", "1");

	Info_SetValueForKey( infostring, "type", va("%i", sv_authorizemode->integer));
	// add "demo" to the sv_keywords if restricted

	status[0] = 0;
	statusLength = 0;

	for ( i = 0, gclient = level.clients ; i < sv_maxclients->integer ; i++, gclient++ ) {
		cl = &svs.clients[i];
		if ( cl->state >= CS_CONNECTED ) {
			Com_sprintf( player, sizeof( player ), "%i %i \"%s\"\n",
						 gclient->pers.scoreboard.score, cl->ping, cl->name );
			playerLength = strlen( player );
			if ( statusLength + playerLength >= sizeof( status ) ) {
				break;      // can't hold any more
			}
			strcpy( status + statusLength, player );
			statusLength += playerLength;
		}
	}
	NET_OutOfBandPrint( NS_SERVER, from, "statusResponse\n%s\n%s", infostring, status );
}


/*
================
SVC_Info

Responds with a short info message that should be enough to determine
if a user is interested in a server to do a full status
================
*/
void SVC_Info( netadr_t from ) {
	int		i, count, humans;
	char	infostring[MAX_INFO_STRING];

	/*
	 * Check whether Cmd_Argv(1) has a sane length. This was not done in the original Quake3 version which led
	 * to the Infostring bug discovered by Luigi Auriemma. See http://aluigi.altervista.org/ for the advisory.
	 */

	// A maximum challenge length of 128 should be more than plenty.
	if(strlen(Cmd_Argv_sv(1)) > 128)
		return;

	// don't count privateclients
	count = humans = 0;
	for ( i = 0 ; i < sv_maxclients->integer ; i++ ) {
		if ( svs.clients[i].state >= CS_CONNECTED ) {
			count++;
			if (svs.clients[i].netchan.remoteAddress.type != NA_BOT) {
				humans++;
			}
		}
	}

	infostring[0] = 0;

	// echo back the parameter to status. so servers can use it as a challenge
	// to prevent timed spoofed reply packets that add ghost servers
	Info_SetValueForKey( infostring, "challenge", Cmd_Argv_sv(1) );

	//Info_SetValueForKey( infostring, "gamename", com_gamename->string );

	Info_SetValueForKey(infostring, "protocol", "6");

	Info_SetValueForKey( infostring, "hostname", sv_hostname->string );
	Info_SetValueForKey( infostring, "type", va("%i", sv_authorizemode->integer));
	Info_SetValueForKey( infostring, "mapname", sv_mapname->string );
	Info_SetValueForKey( infostring, "clients", va("%i", count) );
//	Info_SetValueForKey(infostring, "g_humanplayers", va("%i", humans));
	Info_SetValueForKey( infostring, "sv_maxclients", va("%i", sv_maxclients->integer - sv_privateClients->integer ) );
	Info_SetValueForKey( infostring, "gametype", sv_gametype->string );
	Info_SetValueForKey( infostring, "pure", va("%i", sv_pure->boolean ) );
        if(*g_password->string)
	    Info_SetValueForKey( infostring, "pswrd", "1");
	else
	    Info_SetValueForKey( infostring, "pswrd", "0");

        if(g_cvar_valueforkey("scr_team_fftype")){
	    Info_SetValueForKey( infostring, "ff", va("%i", g_cvar_valueforkey("scr_team_fftype")));
	}

        if(g_cvar_valueforkey("scr_game_allowkillcam")){
	    Info_SetValueForKey( infostring, "ki", "1");
	}

        if(g_cvar_valueforkey("scr_hardcore")){
	    Info_SetValueForKey( infostring, "hc", "1");
	}

        if(g_cvar_valueforkey("scr_oldschool")){
	    Info_SetValueForKey( infostring, "od", "1");
	}
	Info_SetValueForKey( infostring, "hw", "1");

        if(fs_game->string[0] == '\0' || sv_showasranked->boolean){
	    Info_SetValueForKey( infostring, "mod", "0");
	}else{
	    Info_SetValueForKey( infostring, "mod", "1");
	}
	Info_SetValueForKey( infostring, "voice", va("%i", sv_voice->boolean ) );
	Info_SetValueForKey( infostring, "pb", va("%i", sv_punkbuster->boolean) );
	if( sv_maxPing->integer ) {
		Info_SetValueForKey( infostring, "sv_maxPing", va("%i", sv_maxPing->integer) );
	}

	if( fs_game->string[0] != '\0' ) {
		Info_SetValueForKey( infostring, "game", fs_game->string );
	}

	NET_OutOfBandPrint( NS_SERVER, from, "infoResponse\n%s", infostring );
}


/*
================
SVC_FlushRedirect

================
*/
static void SV_FlushRedirect( char *outputbuf ) {
	NET_OutOfBandPrint( NS_SERVER, svse.redirectAddress, "print\n%s", outputbuf );
}

/*
===============
SVC_RemoteCommand

An rcon packet arrived from the network.
Shift down the remaining args
Redirect all printfs
===============
*/
static void SVC_RemoteCommand( netadr_t from, msg_t *msg ) {
	qboolean	valid;
	char		remaining[1024];
	// TTimo - scaled down to accumulate, but not overflow anything network wise, print wise etc.
	// (OOB messages are the bottleneck here)
	char		sv_outputbuf[SV_OUTPUTBUF_LENGTH];
	char *cmd_aux;

	// Prevent using rcon as an amplifier and make dictionary attacks impractical
/*	if ( SVC_RateLimitAddress( from, 10, 1000 ) ) {
		Com_DPrintf( "SVC_RemoteCommand: rate limit from %s exceeded, dropping request\n",
			NET_AdrToString( from ) );
		return;
	}*/

	if ( !strlen( sv_rconPassword->string ) || strcmp (Cmd_Argv_sv(1), sv_rconPassword->string) ) {
//		static leakyBucket_t bucket;

		// Make DoS via rcon impractical
/*		if ( SVC_RateLimit( &bucket, 10, 1000 ) ) {
			Com_DPrintf( "SVC_RemoteCommand: rate limit exceeded, dropping request\n" );
			return;
		}*/
		valid = qfalse;
		Com_Printf ("Bad rcon from %s: %s\n", NET_AdrToString (from), Cmd_Argsv_sv(2) );
	} else {
		valid = qtrue;
		Com_Printf ("Rcon from %s: %s\n", NET_AdrToString (from), Cmd_Argsv_sv(2) );
	}

	// start redirecting all print outputs to the packet
	svse.redirectAddress = from;
	Com_BeginRedirect (sv_outputbuf, SV_OUTPUTBUF_LENGTH, SV_FlushRedirect);

	if ( strlen( sv_rconPassword->string) < 8 ) {
		Com_Printf ("No rconpassword set on server or password is not long enough.\n");
	} else if ( !valid ) {
		Com_Printf ("Bad rconpassword.\n");
	} else {
		// https://zerowing.idsoftware.com/bugzilla/show_bug.cgi?id=543
		// get the command directly, "rcon <pass> <command>" to avoid quoting issues
		// extract the command by walking
		// since the cmd formatting can fuckup (amount of spaces), using a dumb step by step parsing
		cmd_aux = Cmd_Argsv_sv(2);
		while(cmd_aux[0]==' ')
			cmd_aux++;
		
		Q_strncpyz( remaining, cmd_aux, sizeof(remaining));
		
		Cmd_ExecuteSingleCommand(0,0,remaining);

		if(!Q_stricmpn(remaining, "pb_sv_", 6)) PbServerForceProcess();
	}
	Com_EndRedirect ();
}

/*
=================
SV_ConnectionlessPacket

A connectionless packet has four leading 0xff
characters to distinguish it from a game channel.
Clients that are in the game can still send
connectionless packets.
=================
*/
void SV_ConnectionlessPacket( netadr_t from, msg_t *msg ) {
	char	*s;
	char	*c;
	int	clnum;
	int	i;
	client_t *cl;

	MSG_BeginReading( msg );
	MSG_ReadLong( msg );		// skip the -1 marker

	if (!Q_strncmp("PB_", (char *) &msg->data[4], 3)) {
		//pb_sv_process here
		if(msg->data[7] == 0x43 || msg->data[7] == 0x31 || msg->data[7] == 0x4a)
		    return;

		for ( i = 0, clnum = -1, cl = svs.clients ; i < sv_maxclients->integer ; i++, cl++ ){
			if ( !NET_CompareBaseAdr( from, cl->netchan.remoteAddress ) )	continue;
			if(cl->netchan.remoteAddress.port != from.port) continue;
			clnum = i;
			break;
		}
		PbSvAddEvent(13, clnum, msg->cursize-4, (char *)&msg->data[4]);
		return;
	}

	s = MSG_ReadStringLine( msg );
	SV_Cmd_TokenizeString( s );

	c = Cmd_Argv_sv(0);
	Com_DPrintf ("SV packet %s : %s\n", NET_AdrToString(from), c);

	if (!Q_stricmp(c, "connect")) {
//		PbPassConnectString(NET_AdrToString(from), (char*) msg->data);  //Causes SIGSEGV
		SV_DirectConnect( from );
		goto fini;
	} else if (!Q_stricmp(c, "ipAuthorize")) {
		SV_AuthorizeIpPacket( from );
		goto fini;
	} else if (!Q_stricmp(c, "stats")) {
		SV_ReceiveStats(from, msg);
		goto fini;
        } else if (!Q_stricmp(c, "rcon")) {
		SVC_RemoteCommand( from, msg );
		goto fini;
	} else if (!Q_stricmp(c, "getchallenge")) {
		SV_GetChallenge(from);
		goto fini;
	// challenge from the server we are connecting to
	} else if (!Q_stricmp( c, "challengeResponse" )) {
		CL_ChallengeResponse( from , CL_AddrToServer(from));
		goto fini;
	// server connection
	} else if ( !Q_stricmp( c, "connectResponse" ) ) {
		CL_ConnectResponse( from , CL_AddrToServer(from));
		goto fini;
	}

        if(!isQuerylimited(from)){
            if (!Q_stricmp(c, "getinfo")) {
		SVC_Info( from );
	    }else if (!Q_stricmp(c, "getstatus")) {
		SVC_Status( from );
	    }else if (!Q_stricmp(c, "disconnect")) {
		CL_DisconnectPacket(from, CL_AddrToServer(from));

	    }else{
		Com_DPrintf ("bad connectionless packet from %s\n", NET_AdrToString (from));
	    }
	}
	fini:
	SV_Cmd_EndTokenizeString();
	return;
}




//============================================================================

/*
=================
SV_ReadPackets
=================
*/
void SV_PacketEvent( netadr_t from, msg_t *msg ) {
	int i;
	client_t    *cl;
	short qport;

	// check for connectionless packet (0xffffffff) first
	if ( msg->cursize >= 4 && *(int *)msg->data == -1 ) {
		SV_ConnectionlessPacket( from, msg );
		return;
	}

	SV_ResetSekeletonCache();

	// read the qport out of the message so we can fix up
	// stupid address translating routers

	seqclient_t* clq = CL_AddrToServer(from);
	if(clq)
	{
		CL_ReadPacket( clq ,msg );
		return;
	}

	MSG_BeginReading( msg );
	MSG_ReadLong( msg );           // sequence number
	qport = MSG_ReadShort( msg );  // & 0xffff;

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
			Com_Printf( "SV_PacketEvent: fixing up a translated port\n" );
			cl->netchan.remoteAddress.port = from.port;
		}
		// make sure it is a valid, in sequence packet
		if ( Netchan_Process( &cl->netchan, msg ) ) {
			// zombie clients still need to do the Netchan_Process
			// to make sure they don't need to retransmit the final
			// reliable message, but they don't do any other processing
			cl->serverId = MSG_ReadByte( msg );
			cl->messageAcknowledge = MSG_ReadLong( msg );

			if(cl->messageAcknowledge < 0){
				Com_Printf("Invalid reliableAcknowledge message from %s - reliableAcknowledge is %i\n", cl->name, cl->reliableAcknowledge);
				return;
			}
			cl->reliableAcknowledge = MSG_ReadLong( msg );

			if((cl->reliableSequence - cl->reliableAcknowledge) > (MAX_RELIABLE_COMMANDS - 1)){
				Com_Printf("Out of range reliableAcknowledge message from %s - reliableSequence is %i, reliableAcknowledge is %i\n",
				cl->name, cl->reliableSequence, cl->reliableAcknowledge);
				cl->reliableAcknowledge = cl->reliableSequence;
				return;
			}
			SV_Netchan_Decode(cl, &msg->data[msg->readcount], msg->cursize - msg->readcount);
			if ( cl->state != CS_ZOMBIE ) {
				cl->lastPacketTime = svs.time;  // don't timeout
				if(msg->cursize > 2000){
					//This will fix up a buffer overflow.
					//CoD4's message Decompress-function has no buffer overrun check
					//Because the compression algorith is very poor this is already sufficent
					Com_Printf("Oversize message received from: %s\n", cl->name);
					SV_DropClient(cl, "Oversize client message");
				}

//				SV_DumpCommands(cl, msg->data, msg->cursize, qtrue);
				SV_ExecuteClientMessage( cl, msg );
			}
		}
		return;
	}
	// if we received a sequenced packet from an address we don't recognize,
	// send an out of band disconnect packet to it
	NET_OutOfBandPrint( NS_SERVER, from, "disconnect" );
}




/*
==============================================================================

MASTER SERVER FUNCTIONS

==============================================================================
*/

/*
================
SV_MasterHeartbeat

Send a message to the masters every few minutes to
let it know we are alive, and log information.
We will also have a heartbeat sent when a server
changes from empty to non-empty, and full to non-full,
but not on every player enter or exit.
================
*/
#define PORT_MASTER 20810
#define MASTER_SERVER_NAME "cod4master.activision.com"
#define MASTER_SERVER_NAME2 "cod4master.iceops.in"
#define HEARTBEAT_FOR_MASTER "flatline"
#define	HEARTBEAT_MSEC	180*1000
void SV_MasterHeartbeat(const char *message)
{
	static netadr_t	adr[MAX_MASTER_SERVERS][2]; // [2] for v4 and v6 address for the same address string.
	int			i;
	int			res;
	int			netenabled;

	netenabled = net_enabled->integer;

	// "dedicated 1" is for lan play, "dedicated 2" is for inet public play
	if (com_dedicated->integer != 2 || !(netenabled & (NET_ENABLEV4 | NET_ENABLEV6)))
		return;		// only dedicated servers send heartbeats

	// if not time yet, don't send anything
	if ( svs.time < svse.nextHeartbeatTime )
		return;

	svse.nextHeartbeatTime = svs.time + HEARTBEAT_MSEC;

	// send to group masters
	for (i = 0; i < MAX_MASTER_SERVERS; i++)
	{
		if(!sv_master[i]->string[0])
			continue;

		// see if we haven't already resolved the name
		// resolving usually causes hitches on win95, so only
		// do it when needed
		if(sv_master[i]->modified || (adr[i][0].type == NA_BAD && adr[i][1].type == NA_BAD))
		{
			sv_master[i]->modified = qfalse;
			
			if(netenabled & NET_ENABLEV4)
			{
				Com_Printf("Resolving %s (IPv4)\n", sv_master[i]->string);
				res = NET_StringToAdr(sv_master[i]->string, &adr[i][0], NA_IP);

				if(res == 2)
				{
					// if no port was specified, use the default master port
					adr[i][0].port = BigShort(PORT_MASTER);
				}
				
				if(res)
					Com_Printf( "%s resolved to %s\n", sv_master[i]->string, NET_AdrToString(adr[i][0]));
				else
					Com_Printf( "%s has no IPv4 address.\n", sv_master[i]->string);
			}
			
			if(netenabled & NET_ENABLEV6)
			{
				Com_Printf("Resolving %s (IPv6)\n", sv_master[i]->string);
				res = NET_StringToAdr(sv_master[i]->string, &adr[i][1], NA_IP6);

				if(res == 2)
				{
					// if no port was specified, use the default master port
					adr[i][1].port = BigShort(PORT_MASTER);
				}
				
				if(res)
					Com_Printf( "%s resolved to %s\n", sv_master[i]->string, NET_AdrToString(adr[i][1]));
				else
					Com_Printf( "%s has no IPv6 address.\n", sv_master[i]->string);
			}

			if(adr[i][0].type == NA_BAD && adr[i][1].type == NA_BAD)
			{
				// if the address failed to resolve, clear it
				// so we don't take repeated dns hits
				Com_Printf("Couldn't resolve address: %s\n", sv_master[i]->string);
				Cvar_SetString(sv_master[i], "");
				sv_master[i]->modified = qfalse;
				continue;
			}
		}


		Com_Printf ("Sending heartbeat to %s\n", sv_master[i]->string );

		// this command should be changed if the server info / status format
		// ever incompatably changes

		if(adr[i][0].type != NA_BAD)
			NET_OutOfBandPrint( NS_SERVER, adr[i][0], "heartbeat %s\n", message);
		if(adr[i][1].type != NA_BAD)
			NET_OutOfBandPrint( NS_SERVER, adr[i][1], "heartbeat %s\n", message);
	}
}

/*
=================
SV_MasterShutdown

Informs all masters that this server is going down
=================
*/
void SV_MasterShutdown( void ) {
	// send a hearbeat right now
	svse.nextHeartbeatTime = -9999;
	SV_MasterHeartbeat(HEARTBEAT_FOR_MASTER);

	// send it again to minimize chance of drops
	svse.nextHeartbeatTime = -9999;
	SV_MasterHeartbeat(HEARTBEAT_FOR_MASTER);

	// when the master tries to poll the server, it won't respond, so
	// it will be removed from the list
}


void SV_ShutdownCallback(void){
    SV_MasterShutdown();

}

/*
=============================================================================

Writing the serverstatus out to a XML-File.
This can be usefull to display serverinfo on a website

=============================================================================
*/

void	serverStatus_WriteCvars(cvar_t const* cvar, void *var ){
    xml_t *xmlbase = var;

    if(cvar->flags & (CVAR_SERVERINFO | CVAR_NORESTART)){
        XML_OpenTag(xmlbase,"Data",2, "Name",cvar->name, "Value",Cvar_DisplayableValue(cvar));
        XML_CloseTag(xmlbase);
    }
}

void	serverStatus_Write(){

    xml_t xmlbase;
    char outputbuffer[32768];
    int i, c;
    client_t    *cl;
    extclient_t	*excl;
    gclient_t	*gclient;
    char	score[16];
    char	team[4];
    char	kills[16];
    char	deaths[16];
    char	assists[16];
    char	teamname[32];
    char	cid[4];
    char *timestr = ctime(&realtime);
    timestr[strlen(timestr)-1]= 0;

    if(!*sv_statusfile->string) return;

    XML_Init(&xmlbase,outputbuffer,sizeof(outputbuffer));
    XML_OpenTag(&xmlbase,"B3Status",1,"Time",timestr);

        XML_OpenTag(&xmlbase,"Game",9,"CapatureLimit","", "FragLimit","", "Map",sv_mapname->string, "MapTime","", "Name","cod4", "RoundTime","", "Rounds","", "TimeLimit","", "Type",g_gametype->string);
            Cvar_ForEach(serverStatus_WriteCvars,&xmlbase);
        XML_CloseTag(&xmlbase);

        for ( i = 0, c = 0, cl = svs.clients; i < sv_maxclients->integer ; cl++, i++ ) {
            if ( cl->state >= CS_CONNECTED ) c++;
        }
        XML_OpenTag(&xmlbase, "Clients", 1, "Total",va("%i",c));

            for ( i = 0, cl = svs.clients, excl = svse.extclients, gclient = level.clients; i < sv_maxclients->integer ; i++, cl++, excl++, gclient++ ) {
                if ( cl->state >= CS_CONNECTED ){

                        Com_sprintf(cid,sizeof(cid),"%i", i);

                        if(cl->state == CS_ACTIVE){


                            Com_sprintf(team,sizeof(team),"%i", gclient->sess.sessionTeam);
                            Com_sprintf(score,sizeof(score),"%i", gclient->pers.scoreboard.score);
                            Com_sprintf(kills,sizeof(kills),"%i", gclient->pers.scoreboard.kills);
                            Com_sprintf(deaths,sizeof(deaths),"%i", gclient->pers.scoreboard.deaths);
                            Com_sprintf(assists,sizeof(assists),"%i", gclient->pers.scoreboard.assists);

                            switch(gclient->sess.sessionTeam){

                                case TEAM_RED:
                                    if(!Q_strncmp(g_TeamName_Axis->string,"MPUI_SPETSNAZ", 13))
                                        Q_strncpyz(teamname, "Spetsnaz", 32);
                                    else if(!Q_strncmp(g_TeamName_Axis->string,"MPUI_OPFOR", 10))
                                        Q_strncpyz(teamname, "Opfor", 32);
                                    else
                                        Q_strncpyz(teamname, g_TeamName_Axis->string, 32);

                                    break;

                                case TEAM_BLUE:
                                    if(!Q_strncmp(g_TeamName_Allies->string,"MPUI_MARINES", 12))
                                        Q_strncpyz(teamname, "Marines", 32);
                                    else if(!Q_strncmp(g_TeamName_Allies->string,"MPUI_SAS", 8))
                                        Q_strncpyz(teamname, "S.A.S.", 32);
                                    else
                                        Q_strncpyz(teamname, g_TeamName_Allies->string,32);

                                    break;

                                case TEAM_FREE:
                                    Q_strncpyz(teamname, "Free",32);
                                    break;
                                case TEAM_SPECTATOR:
                                    Q_strncpyz(teamname, "Spectator", 32);
                                    break;
                                default:
                                    *teamname = 0;
                            }
                        }else{
                            *team = 0;
                            *score = 0;
                            *kills = 0;
                            *deaths = 0;
                            *assists = 0;
                            if(cl->state == CS_CONNECTED){
                                Q_strncpyz(teamname, "Connecting...", 32);
                            }else{
                                Q_strncpyz(teamname, "Loading...", 32);
                            }
                        }

                        XML_OpenTag(&xmlbase, "Client", 12, "CID",cid, "ColorName",cl->name, "DBID",va("%i", excl->uid), "IP",NET_AdrToStringShort(cl->netchan.remoteAddress), "PBID",cl->pbguid, "Score",score, "Kills",kills, "Deaths",deaths, "Assists",assists, "Team",team, "TeamName", teamname, "Updated", timestr);
                        XML_CloseTag(&xmlbase);
                }
            }

        XML_CloseTag(&xmlbase);
    XML_CloseTag(&xmlbase);

    FS_SV_WriteFile(sv_statusfile->string, outputbuffer, strlen(outputbuffer));

}


void SV_InitCallback(){
	int index;
	client_t *cl;

	time(&realtime);
	char *timestr = ctime(&realtime);
	timestr[strlen(timestr)-1]= 0;

	ModStats = Cvar_RegisterBool("ModStats", qtrue, CVAR_ARCHIVE, "Flag whether to use stats of mod (when running a mod) or to use stats of the Cod4 coregame");
	sv_authorizemode = Cvar_RegisterInt("sv_authorizemode", 2, -1, 2, CVAR_ARCHIVE, "How to authorize clients, 0=acceptall(No GUIDs) 1=usinghardwareids 2=accept no one with invalid GUID");
	sv_showasranked = Cvar_RegisterBool("sv_showasranked", qfalse, CVAR_ARCHIVE, "List the server in serverlist of ranked servers even when it is modded");
	sv_statusfile = Cvar_RegisterString("sv_statusfilename", "serverstatus.xml", CVAR_ARCHIVE, "Filename to write serverstatus to disk");
	g_mapstarttime = Cvar_RegisterString("g_mapStartTime", "", CVAR_SERVERINFO | CVAR_ROM, "Time when current map has started");
	Cvar_SetString(g_mapstarttime, timestr);
	g_allowConsoleSay = Cvar_RegisterBool("g_allowConsoleSay", qtrue, CVAR_ARCHIVE, "Flag whether to allow chat from ingame console");
	g_friendlyPlayerCanBlock = Cvar_RegisterBool("g_friendlyPlayerCanBlock", qfalse, CVAR_ARCHIVE, "Flag whether friendly players can block each other");
	sv_uptime = Cvar_RegisterString("uptime", "", CVAR_SERVERINFO | CVAR_ROM, "Time the server is running since last restart");
	sv_autodemorecord = Cvar_RegisterBool("sv_autodemorecord", qfalse, CVAR_ARCHIVE, "Automatically start from each connected client a demo. This facility will works if sv_authorizemode is 1.");

	sv_master[0] = Cvar_RegisterString("sv_master1", MASTER_SERVER_NAME, CVAR_ROM, "Default masterserver name");
	sv_master[1] = Cvar_RegisterString("sv_master2", "", CVAR_ARCHIVE, "A masterserver name");
	sv_master[2] = Cvar_RegisterString("sv_master3", "", CVAR_ARCHIVE, "A masterserver name");
	sv_master[3] = Cvar_RegisterString("sv_master4", "", CVAR_ARCHIVE, "A masterserver name");
	sv_master[4] = Cvar_RegisterString("sv_master5", "", CVAR_ARCHIVE, "A masterserver name");
	sv_master[5] = Cvar_RegisterString("sv_master6", MASTER_SERVER_NAME2, CVAR_ARCHIVE, "A masterserver name");

	sv_streamServer[0] = Cvar_RegisterString("sv_streamServer1", "", CVAR_ARCHIVE, "A StreamServer name");
	sv_streamServer[1] = Cvar_RegisterString("sv_streamServer2", "", CVAR_ARCHIVE, "A StreamServer name");
	sv_streamServer[2] = Cvar_RegisterString("sv_streamServer3", "", CVAR_ARCHIVE, "A StreamServer name");
	sv_streamServer[3] = Cvar_RegisterString("sv_streamServer4", "", CVAR_ARCHIVE, "A StreamServer name");
	sv_streamServer[4] = Cvar_RegisterString("sv_streamServer5", "", CVAR_ARCHIVE, "A StreamServer name");
	sv_streamServer[5] = Cvar_RegisterString("sv_streamServer6", "", CVAR_ARCHIVE, "A StreamServer name");


	for(index = 0; index < MAX_MASTER_SERVERS; index++){

		if(*sv_streamServer[index]->string){
			NET_StringToAdr(sv_streamServer[index]->string, &sv_streamServerAddr[index], NA_IP);
		}else{
			Com_Memset(&sv_streamServerAddr[index], 0, sizeof(netadr_t));
		}
	}

	Init_CallVote();
	extlevel.levelLoadRetries = 0;
	SV_RemoveAllBots();
	SV_ReloadBanlist();
	SV_RemoteCmdInit();
	NV_LoadConfig();

	if(sv_authorizemode->integer == 1){
		return;
        }

	for(index = 0, cl = svs.clients; index < sv_maxclients->integer; index++, cl++)
	{
		if(cl->state < CS_CONNECTED)
			continue;

		if(CL_IsBanned(0, cl->pbguid, cl->netchan.remoteAddress)){
			SV_DropClient(cl, "Prior kick/ban");
		}
	}

}

void SV_FrameCallback(){
    static int nextsecond;
    static int nexttensec;
    static int nextsecret;
/*
    for(i=0; i < sv_maxclients->integer; i++){
	if(SV_GentityNum(i)->s.solid){
		Com_Printf("Solid: %i\n", i);
	}
        SV_GentityNum(i)->s.solid = 0;
//        SV_GentityNum(i)->r.bmodel = 0;
//        SV_GentityNum(i)->r.contents &= ~CONTENTS_BODY;
    }

*/

    if(svs.time > 0x6fff0fff){		//23 days are over, we have to kill the server to prevent unusual things from happening like RDDoS filter will go in non working state
        Com_Quit_f();
    }

    if( svs.time > nextsecond){	//This runs each second
	nextsecond = svs.time+1000;
	SV_MasterHeartbeat("COD-4");
	time(&realtime);		//Update each second servertime with realtime

	if(svs.time > nexttensec){	//This runs each 10 seconds
		nexttensec = svs.time+10000;
		pbsvstats();

		int d, h, m;
		int uptime;

		uptime = (int)(svs.time / 1000);

		d = uptime/(60*60*24);
		uptime = uptime%(60*60*24);
		h = uptime/(60*60);
		uptime = uptime%(60*60);
		m = uptime/60;

		if(h < 4)
			Cvar_SetString(sv_uptime, va("%i minutes", m));
		else if(d < 3)
			Cvar_SetString(sv_uptime, va("%i hours", h));
		else
			Cvar_SetString(sv_uptime, va("%i days", d));

		serverStatus_Write();

		if(svs.time > nextsecret){
			nextsecret = svs.time+80000;
			Com_RandomBytes((byte*)&svse.secret,sizeof(int));
		}
	}

	if(extlevel.levelLoadRetries > 0 && extlevel.LevelExitFrame < level.framenum){	//Fix up a corrupted map_rotation
		extlevel.levelLoadRetries--;
		if(extlevel.levelLoadRetries == 0){
			Com_PrintWarning("sv_maprotation is entirely corrupted. Trying a default map\nThis is the last attempt");
			Cbuf_AddText(EXEC_NOW,"map mp_crash");
		}else{
			Com_PrintWarning("sv_maprotation contains an error. Location is prior: %s\n", Cvar_GetVariantString("sv_maprotationcurrent"));
			Cbuf_AddText(EXEC_NOW,"map_rotate");
		}
	}
//	Com_Printf("svs.time: %i  level.time: %i\n", svs.time, level.time);
//        Com_Printf("ADDR: %p  ADDR: %p  Size: %i\n",&test->ping, &test2->messageSize, sizeof(clientSnapshot_t));
/*	test++;*/
/*	int i;
	for(i = 0; i < 33; i++)
	{
		Com_Printf("%d  ", sv.gameClients[0].ImTooLazy3[i]);
	}
	Com_Printf("\n");*/
//	Com_Printf("Origin: %f %f %f\n", sv.gameClients[0].origin[0], sv.gameClients[0].origin[1], sv.gameClients[0].origin[2]);
//	Com_Printf("Velocity: %f %f %f\n", sv.gameClients[0].velocity[0], sv.gameClients[0].velocity[1], sv.gameClients[0].velocity[2]);
//	Com_Printf("Angle: %f %f %f\n", sv.gameClients[0].viewangles[0], sv.gameClients[0].viewangles[1], sv.gameClients[0].viewangles[2]);
	CL_Connect(&svse.authserver);
	CL_Connect(&svse.scrMaster);
    }
    CL_WritePacket( &svse.authserver );
    CL_WritePacket( &svse.scrMaster );
}


/*
===================
SV_CalcPings

Updates the cl->ping variables
===================
*/
void SV_CalcPings( void ) {
	int i, j;
	client_t    *cl;
	int total, count;
	int delta;

	for ( i = 0 ; i < sv_maxclients->integer ; i++ ) {
		cl = &svs.clients[i];

		if ( cl->state != CS_ACTIVE ) {
			cl->ping = -1;
			continue;
		}
		if ( !cl->gentity ) {
			cl->ping = -1;
			continue;
		}
		if ( cl->netchan.remoteAddress.type == NA_BOT ) {
			cl->ping = 0;
			cl->lastPacketTime = svs.time;
			continue;
		}

		total = 0;
		count = 0;
		for ( j = 0 ; j < PACKET_BACKUP ; j++ ) {
			if ( cl->frames[j].messageAcked <= 0 ) {
				continue;
			}
			delta = cl->frames[j].messageAcked - cl->frames[j].messageSent;
			count++;
			total += delta;
		}
		if ( !count ) {
			cl->ping = 999;
		} else {
			cl->ping = total / count;
			if ( cl->ping > 999 ) {
				cl->ping = 999;
			}
		}
	}
}

/*
===============
SV_GetConfigstring

===============
*/
void SV_GetConfigstring( int index, char *buffer, int bufferSize ) {

	short strIndex;
	char* cs;

	if ( bufferSize < 1 ) {
		Com_Error( ERR_DROP, "SV_GetConfigstring: bufferSize == %i", bufferSize );
	}
	if ( index < 0 || index >= MAX_CONFIGSTRINGS ) {
		Com_Error( ERR_DROP, "SV_GetConfigstring: bad index %i\n", index );
	}
	strIndex = sv.configstringIndex[index];

	cs = SL_ConvertToString(strIndex);

	Q_strncpyz( buffer, cs, bufferSize );
}

typedef struct{
    int index;
    char* string;
    int unk1;
    int unk2;
}unkGameState_t;

#define unkGameStateStr (unkGameState_t*)UNKGAMESTATESTR_ADDR
#define UNKGAMESTATESTR_ADDR (0x826f260)
/*
===============

===============
*/

void SV_WriteGameState( msg_t* msg, client_t* cl ) {

	char* cs;
	int i, ebx, edi, esi, var_03, clnum;
	entityState_t nullstate, *base;
	snapshotInfo_t snapInfo;
	unkGameState_t *gsbase = unkGameStateStr;
	unkGameState_t *gsindex;
	short strindex;

	MSG_WriteByte( msg, svc_gamestate );
	MSG_WriteLong( msg, cl->reliableSequence );
	MSG_WriteByte( msg, svc_configstring );

	for ( esi = 0, edi = 0, var_03 = 0 ; esi < MAX_CONFIGSTRINGS ; esi++) {

		strindex = sv.configstringIndex[esi];
		gsindex = &gsbase[var_03];

		if(gsindex->index != esi){

			if(strindex != sv.unkConfigIndex)
				edi++;

			continue;
		}

		cs = SL_ConvertToString(strindex);

		if(gsindex->index > 820){
			if(Q_stricmp(gsindex->string, cs))
			{
				edi++;
			}
		}else{
			if(strcmp(gsindex->string, cs))
			{
				edi++;
			}
		}
		var_03++;
	}
	MSG_WriteShort(msg, edi);

	for ( ebx = 0, edi = -1, var_03 = 0 ; ebx < MAX_CONFIGSTRINGS ; ebx++) {

		gsindex = &gsbase[var_03];
		strindex = sv.configstringIndex[ebx];

		if(gsindex->index == ebx){
					//ebx and gsindex->index are equal
			var_03++;

			cs = SL_ConvertToString(strindex);

			if(ebx > 820){
				if(!Q_stricmp(gsindex->string, cs))
				{
					continue;
				}
			}else{
				if(!strcmp(gsindex->string, cs))
				{
					continue;
				}
			}

			if(sv.unkConfigIndex == strindex)
			{
				MSG_WriteBit0(msg);
				MSG_WriteBits(msg, gsindex->index, 12);
				MSG_WriteBigString(msg, "");
				edi = ebx;
				continue;
			}
		}

		strindex = sv.configstringIndex[ebx];
		if(sv.unkConfigIndex != strindex)
		{
			if(edi+1 == ebx){

				MSG_WriteBit1(msg);

			}else{

				MSG_WriteBit0(msg);
				MSG_WriteBits(msg, ebx, 12);
			}
			
			// APB
			/*if(ebx == 1) {
				char newstring[MAX_STRING_CHARS];
				Q_strnrepl(newstring, sizeof(newstring), SL_ConvertToString(strindex), "../../", "");
				MSG_WriteBigString(msg, newstring);
			}
			else {
				MSG_WriteBigString(msg, SL_ConvertToString(strindex));
			}*/
			MSG_WriteBigString(msg, SL_ConvertToString(strindex));
		}
	}
	Com_Memset( &nullstate, 0, sizeof( nullstate ) );
	clnum = cl - svs.clients;

	// baselines
	for ( i = 0; i < MAX_GENTITIES ; i++ ) {
		base = &sv.svEntities[i].baseline;
		if ( !base->number ) {
			continue;
		}
		MSG_WriteByte( msg, svc_baseline );

		snapInfo.clnum = clnum;
		snapInfo.cl = NULL;
		snapInfo.var_01 = 0xFFFFFFFF;
		snapInfo.var_02 = qtrue;

		MSG_WriteDeltaEntity( &snapInfo, msg, 0, &nullstate, base, qtrue );
	}
	
	MSG_WriteByte( msg, svc_EOF );
}


void SV_GetServerStaticHeader(){
	archivedSnapshot.var_04 = svsHeader.var_01;
	archivedSnapshot.var_02 = svsHeader.var_03;
	archivedSnapshot.var_03 = svsHeader.var_04;
}
