/*
===========================================================================
Copyright (C) 1999-2005 Id Software, Inc.

This file is part of Quake III Arena source code.

Quake III Arena source code is free software; you can redistribute it
and/or modify it under the terms of the GNU General Public License as
published by the Free Software Foundation; either version 2 of the License,
or (at your option) any later version.

Quake III Arena source code is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Quake III Arena source code; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
===========================================================================

===============================================================================

OPERATOR CONSOLE ONLY COMMANDS

These commands can only be entered from stdin or by a remote operator datagram
===============================================================================
*/


void	Cmd_AddServerCommand(const char* cmdname, xcommand_t function){

    char *cmdmem = &CmdMemory[CmdCount*40];
    char *cmdmem2 = &CmdMemory[CmdCount*40+20];
    if(CmdCount*40 > sizeof(CmdMemory)){
        Com_Printf("Too many commands\n");
        return;
    }

    Cmd_PrefCmd(cmdname,(int*)0x8110a20,cmdmem2);
    Cmd_AddCmd(cmdname,function,cmdmem);

    CmdCount++;

}

typedef enum {
    SAY_CHAT,
    SAY_CONSOLE,
    SAY_SCREEN
} consaytype_t;

/*
==================
SV_BroadcastSay
==================
*/
static void SV_BroadcastSay_f(){
	char	*p;
	char	text[1024];

	// make sure server is running
	if ( !com_sv_running->integer ) {
		Com_Printf( "Server is not running.\n" );
		return;
	}

	if(svse.authserver.state < CA_CONNECTED){
		if(sv_authorizemode->integer != 1){
			Com_Printf( "Error: This command requires cvar: sv_authorizemode 1\n" );
		}else{
			Com_Printf( "Error: This command requires that this server is probably connected to the EUID server\n" );
		}
	}

	if ( Cmd_Argc_sv () < 2 ) {
		Com_Printf( "Usage: command text... \n" );
		return;
	}

	*text = 0;
	p = Cmd_Args_sv();
	if ( *p == '"' ) {
		p++;
		p[strlen(p)-1] = 0;
	}

	Q_strncpyz(text, p, sizeof(text));

	SV_SendBroadcastMessage(text);
	SV_SendServerCommand(NULL, "h \"^5Broadcast:^7 %s\"", text);
}

/*
==================
SV_ConSay
==================
*/
static void SV_ConSay(client_t *cl, consaytype_t contype) {
	char	*p;
	char	text[1024];

	// make sure server is running
	if ( !com_sv_running->integer ) {
		Com_Printf( "Server is not running.\n" );
		return;
	}

	if ( Cmd_Argc_sv () < 2 ) {
		Com_Printf( "Usage: command text... \n" );
		return;
	}
	*text = 0;
	if(cl){
	    if(contype == SAY_CHAT){
		strcpy (text, "^5Server^7->^5PM: ^7");
	    }else{
		strcpy (text, "^5PM: ^7");
	    }
	    p = Cmd_Argsv_sv(2);
	}else{
	    if(contype == SAY_CHAT){
		strcpy (text, "^2Server: ^7");
	    }
	    p = Cmd_Args_sv();
	}
	if ( *p == '"' ) {
		p++;
		p[strlen(p)-1] = 0;
	}

	strcat(text, p);

	switch(contype){

	case SAY_CHAT:
		SV_SendServerCommand(cl, "h \"%s\"", text);
	break;
	case SAY_CONSOLE:
		SV_SendServerCommand(cl, "e \"%s\"", text);
	break;
	case SAY_SCREEN:
		SV_SendServerCommand(cl, "c \"%s\"", text);
	break;
	}
}


/*
==================
SV_GetPlayerByHandle

Returns the player with player id or name from Cmd_Argv(1)
==================
*/
typedef struct{
	int uid;
	client_t *cl;
}clanduid_t;




static clanduid_t SV_GetPlayerByHandle( void ) {
	clanduid_t	cl;
	int			i;
	char		*s;
	char		cleanName[64];

	cl.uid = 0;
	cl.cl = NULL;

	// make sure server is running
	if ( !com_sv_running->integer ) {
		return cl;
	}

	if ( Cmd_Argc_sv() < 2 ) {
		Com_Printf( "No player specified.\n" );
		return cl;
	}

	s = Cmd_Argv_sv(1);


        if((s[0] == '@' || s[0] == 'u') && isNumeric(&s[1], 0)){

		cl.uid = atoi(&s[1]);
		if(cl.uid < 1){
			cl.uid = 0;
			Com_Printf("Invalid UID specified.\n");
			return cl;
		}

        }else{

        //    cl = SV_GetPlayerByHandle();

		cl.cl = NULL;

		// Check whether this is a numeric player handle
		for(i = 0; s[i] >= '0' && s[i] <= '9'; i++);
	
		if(!s[i])
		{
			int plid = atoi(s);

			// Check for numeric playerid match
			if(plid >= 0 && plid < sv_maxclients->integer)
			{
				cl.cl = &svs.clients[plid];
			
				if(!cl.cl->state)
					cl.cl = NULL;
			}
		}
		if(!cl.cl){
			// check for a name match
			for ( i=0, cl.cl=svs.clients ; i < sv_maxclients->integer ; i++, cl.cl++ ) {
				if ( !cl.cl->state ) {
					continue;
				}
				if ( !Q_stricmp( cl.cl->name, s ) ) {
					break;
				}

				Q_strncpyz( cleanName, cl.cl->name, sizeof(cleanName) );
				Q_CleanStr( cleanName );
				if ( !Q_stricmp( cleanName, s ) ) {
					break;
				}
			}
			if(i == sv_maxclients->integer){
				Com_Printf( "Player %s is not on the server\n", s );
				cl.cl = NULL;
				return cl;
			}
		}

                cl.uid = svse.extclients[cl.cl-svs.clients].uid;
        }

        if(!cl.cl && cl.uid > 0){ //See whether this player is currently onto server
            for(i = 0, cl.cl=svs.clients; i < sv_maxclients->integer; i++, cl.cl++){
                if(cl.cl->state && cl.uid == svse.extclients[i].uid){
                    break;
                }
            }
            if(i == sv_maxclients->integer)
                cl.cl = NULL;
        }

	return cl;
}

/*
==================
SV_GetPlayerByNum

Returns the player with idnum from Cmd_Argv(1)
==================
*/
static client_t *SV_GetPlayerByNum( void ) {
	client_t	*cl;
	int			i;
	int			idnum;
	char		*s;

	// make sure server is running
	if ( !com_sv_running->integer ) {
		return NULL;
	}

	if ( Cmd_Argc_sv() < 2 ) {
		Com_Printf( "No player specified.\n" );
		return NULL;
	}

	s = Cmd_Argv_sv(1);

	for (i = 0; s[i]; i++) {
		if (s[i] < '0' || s[i] > '9') {
			Com_Printf( "Bad slot number: %s\n", s);
			return NULL;
		}
	}
	idnum = atoi( s );
	if ( idnum < 0 || idnum >= sv_maxclients->integer ) {
		Com_Printf( "Bad client slot: %i\n", idnum );
		return NULL;
	}

	cl = &svs.clients[idnum];
	if ( !cl->state ) {
		Com_Printf( "Client %i is not active\n", idnum );
		return NULL;
	}
	return cl;
}


/*
==================
SV_ConSayChat_f
==================
*/

static void SV_ConSayChat_f(void) {
    SV_ConSay(NULL,SAY_CHAT);
}

/*
==================
SV_ConSayConsole_f
==================
*/

static void SV_ConSayConsole_f(void) {
    SV_ConSay(NULL,SAY_CONSOLE);
}

/*
==================
SV_ConSayScreen_f
==================
*/

static void SV_ConSayScreen_f(void) {
    SV_ConSay(NULL,SAY_SCREEN);
}

/*
==================
SV_ConTell
==================
*/

static void SV_ConTell( consaytype_t contype) {

    client_t *cl;

    if ( Cmd_Argc_sv() < 3 ) {
	Com_Printf( "1. Usage: tellcommand clientnumber text... \n2. Usage: tellcommand \"client by name\" text...\n" );
	return;
    }
    cl = SV_GetPlayerByHandle().cl;

    if(cl != NULL){
        SV_ConSay(cl,contype);
    }
}

/*
==================
SV_ConTellScreen_f
==================
*/
static void SV_ConTellScreen_f(void) {
    SV_ConTell(SAY_SCREEN);
}

/*
==================
SV_ConTellConsole_f
==================
*/
static void SV_ConTellConsole_f(void) {
    SV_ConTell(SAY_CONSOLE);
}

/*
==================
SV_ConTellChat_f
==================
*/
static void SV_ConTellChat_f(void) {
    SV_ConTell(SAY_CHAT);
}


/*
===========
SV_DumpUser_f

Examine all a users info strings FIXME: move to game
===========
*/

#define MAX_NICKNAMES 6

static void SV_DumpUser_f( void ) {
	clanduid_t	cl;
	int		clientNum;
	char		*guid;
	extclient_t	*pbcl;
	char infostring[MAX_INFO_STRING];

	// make sure server is running
	if ( !com_sv_running->integer ) {
		Com_Printf( "Server is not running.\n" );
		return;
	}

	if ( Cmd_Argc_sv() != 2 ) {
		Com_Printf ("Usage: dumpuser <userid>\n");
		return;
	}

	guid = SV_IsGUID(Cmd_Argv_sv(1));
	if(guid){
		cl.cl = NULL;
		cl.uid = 0;
	}else{
		cl = SV_GetPlayerByHandle();
		if ( !cl.uid && !cl.cl ) {
			return;
		}
	}

	Com_Printf( "\nuserinfo\n" );
	Com_Printf( "----------------------------------------------------\n" );

	if(cl.cl){

		Info_Print( cl.cl->userinfo );

		Com_Printf ("pbguid               %s\n", cl.cl->pbguid );

	        clientNum = cl.cl - svs.clients;
	        pbcl=&svse.extclients[clientNum];

		switch(pbcl->authentication){
		    case 1:
			Com_Printf ("authentication       %s\n", AUTHORIZE_SERVER_NAME);
		    break;
		    case 0:
			Com_Printf ("authentication       %s timed out\n", AUTHORIZE_SERVER_NAME);
		    break;
		    case -1:
			Com_Printf ("authentication       punkbuster hw or N/A\n");
		    break;
		    default:
			Com_Printf ("authentication       unknown\n");
		}
		if(pbcl->OS == 'M'){
			Com_Printf ("OperatingSystem      Mac OS X\n");
		}else if(pbcl->OS == 'W'){
			Com_Printf ("OperatingSystem      Windows\n");
		}else{
			Com_Printf ("OperatingSystem      Unknown\n");
		}
		if(pbcl->uid > 0){
			Com_Printf ("PlayerUID            %i\n",pbcl->uid);
		}else{
			Com_Printf ("PlayerUID            N/A\n");
		}

		if(pbcl->uid <= 0)
			return;
        } else {
		Com_Printf("Player is not on server.\n");
        }


	Com_Printf( "\nExtended info\n" );
	Com_Printf( "----------------------------------------------------\n" );

	if(cl.uid || guid){

		*infostring = 0;
		if(cl.uid)
			Info_SetValueForKey( infostring, "UID", va("%i",cl.uid));
		
		else
			Info_SetValueForKey( infostring, "GUID", guid);
		
		if(svse.cmdInvoker.currentCmdInvoker)
			CL_AddReliableCommand(&svse.authserver, va("getUserinfo Ticket %i \"%s\"", svs.clients[svse.cmdInvoker.clientnum].challenge+QT_CMDQUERY, infostring));
		else
			CL_AddReliableCommand(&svse.authserver, va("getUserinfo Ticket %i \"%s\"", -1, infostring));

		Com_DPrintf("Query sent:\n");
		
	}else{
		Com_Printf("N/A\n");
	}
}

/*
================
SV_Status_f
================
*/
static void SV_Status_f( void ) {
	int			i, j, l;
	client_t	*cl;
	gclient_t	*gclient;
	const char		*s;
	int			ping;

	// make sure server is running
	if ( !com_sv_running->integer ) {
		Com_Printf( "Server is not running.\n" );
		return;
	}

	Com_Printf ("map: %s\n", sv_mapname->string );

	Com_Printf ("num score ping guid                             name            lastmsg address               qport rate\n");
	Com_Printf ("--- ----- ---- -------------------------------- --------------- ------- --------------------- ----- -----\n");

	for (i=0,cl=svs.clients, gclient = level.clients; i < sv_maxclients->integer ; i++, cl++, gclient++)
	{
		if (!cl->state)
			continue;
		Com_Printf ("%3i ", i);
		Com_Printf ("%5i ", gclient->pers.scoreboard.score);
		if (cl->state == CS_CONNECTED)
			Com_Printf ("CNCT ");
		else if (cl->state == CS_ZOMBIE)
			Com_Printf ("ZMBI ");
		else if (cl->state == CS_PRIMED)
			Com_Printf ("PRIM ");
		else
		{
			ping = cl->ping < 9999 ? cl->ping : 9999;
			Com_Printf ("%4i ", ping);
		}

		Com_Printf ("%s", cl->pbguid );

		l = 33 - strlen(cl->pbguid);
		j = 0;
		
		do
		{
			Com_Printf (" ");
			j++;
		} while(j < l);

		Com_Printf ("%s", cl->name);
		
		// TTimo adding a ^7 to reset the color
		// NOTE: colored names in status breaks the padding (WONTFIX)
		Com_Printf ("^7");
		l = 16 - Q_PrintStrlen(cl->name);
		j = 0;
		
		do
		{
			Com_Printf (" ");
			j++;
		} while(j < l);

		Com_Printf ("%7i ", svs.time - cl->lastPacketTime );

		s = NET_AdrToString( cl->netchan.remoteAddress );
		Com_Printf ("%s", s);
		l = 21 - strlen(s);
		j = 0;
		
		do
		{
			Com_Printf(" ");
			j++;
		} while(j < l);
		
		Com_Printf ("%6i", cl->netchan.qport);

		Com_Printf (" %5i ", cl->rate);

		Com_Printf ("\n");
	}
	Com_Printf ("\n");
}

void QDECL Cmd_PrintAdministrativeLog( const char *fmt, ... ) {

	Sys_EnterCriticalSection(5);

	va_list		argptr;
	char		msg[MAXPRINTMSG];
	char		inputmsg[MAXPRINTMSG];
	struct tm 	*newtime;
	char*		ltime;

        // logfile
	if ( com_logfile && com_logfile->integer && !loadconfigfiles) {
        // TTimo: only open the qconsole.log if the filesystem is in an initialized state
        //   also, avoid recursing in the qconsole.log opening (i.e. if fs_debug is on)

	    va_start (argptr,fmt);
	    Q_vsnprintf (inputmsg, sizeof(inputmsg), fmt, argptr);
	    va_end (argptr);

	    newtime = localtime( &realtime );
	    ltime = asctime( newtime );
	    ltime[strlen(ltime)-1] = 0;

	    if ( !adminlogfile && FS_Initialized()) {

			adminlogfile = FS_FOpenFileAppend( "adminactions.log" );
			// force it to not buffer so we get valid
			if ( adminlogfile ){
				FS_ForceFlush(adminlogfile);
				FS_Write(va("\nLogfile opened on %s\n\n", ltime), strlen(va("\nLogfile opened on %s\n\n", ltime)), adminlogfile);
			}
	    }

	    if ( adminlogfile && FS_Initialized()) {
		Com_sprintf(msg, sizeof(msg), "%s - Admin %i with %i power %s\n", ltime, svse.cmdInvoker.currentCmdInvoker, svse.cmdInvoker.currentCmdPower, inputmsg);
	    	FS_Write(msg, strlen(msg), adminlogfile);
	    }

	}
	Sys_LeaveCriticalSection(5);
}


/*
============
Cmd_RemoteSetAdmin_f
============
*/

static void Cmd_RemoteSetAdmin_f() {

    adminPower_t *admin;
    adminPower_t *this;
    int power;
    int uid;

    if(sv_authorizemode->integer != 1){
        Com_Printf( "Command not available while server is not running in sv_authorizemode = 1\n" );
        return;
    }

    if ( Cmd_Argc_sv() != 3 || atoi(Cmd_Argv_sv(2)) < 1 || atoi(Cmd_Argv_sv(2)) > 100) {
        Com_Printf( "Usage: setAdmin <user (online-playername | online-playerslot | uid @number)> <power ([1,100])>\n" );
        return;
    }

    power = atoi(Cmd_Argv_sv(2));

    uid = SV_GetPlayerByHandle().uid;
    if(!uid){
        Com_Printf("No such player\n");
        return;
    }

    NV_ProcessBegin();
    for(admin = svse.adminPower ; admin ; admin = admin->next){
        if(admin->uid == uid){
            if(admin->power != power){
                admin->power = power;

                Com_Printf( "Admin power changed for: uid: %i to level: %i\n", uid, power);
                Cmd_PrintAdministrativeLog( "changed power of admin with uid: %i to new power: %i", uid, power);
            }
            NV_ProcessEnd();
            return;
        }
    }

    this = Z_Malloc(sizeof(adminPower_t));
    if(this){
        this->uid = uid;
        this->power = power;
        this->next = svse.adminPower;
        svse.adminPower = this;
        Com_Printf( "Admin added: uid: %i level: %i\n", uid, power);
        Cmd_PrintAdministrativeLog( "added a new admin with uid: %i and power: %i", uid, power);
    }
    NV_ProcessEnd();
}




/*
============
Cmd_RemoteUnsetAdmin_f
============
*/

static void Cmd_RemoteUnsetAdmin_f() {


    if(sv_authorizemode->integer != 1){
        Com_Printf( "Command not available while server is not running in sv_authorizemode = 1\n" );
        return;
    }

    adminPower_t *admin, **this;
    int uid;

    if (Cmd_Argc_sv() != 2) {
        Com_Printf( "Usage: unsetAdmin <user (online-playername | online-playerslot | uid @number)>\n" );
        return;
    }

    uid = SV_GetPlayerByHandle().uid;
    if(!uid){
        Com_Printf("No such player\n");
        return;
    }

    NV_ProcessBegin();
    for(this = &svse.adminPower, admin = *this; admin ; admin = *this){

        if(admin->uid == uid){
            *this = admin->next;
            Z_Free(admin);
            NV_ProcessEnd();
            Com_Printf( "User removed: uid: %i\n", uid);
            Cmd_PrintAdministrativeLog( "removed admin with uid: %i", uid);
            return;
        }
        this = &admin->next;
    }
    Com_Printf( "Error: No such User\n");
    NV_ProcessEnd();
}




/*
============
Cmd_RemoteSetPermission_f
Changes minimum-PowerLevel of a command
============
*/

static void Cmd_RemoteSetPermission_f() {

    if(sv_authorizemode->integer != 1){
        Com_Printf( "Command not available while server is not running in sv_authorizemode = 1\n" );
        return;
    }

    if ( Cmd_Argc_sv() != 3 || atoi(Cmd_Argv_sv(2)) < 1 || atoi(Cmd_Argv_sv(2)) > 100) {
	Com_Printf( "Usage: setCmdMinPower <command> <minpower ([1,100])>\n" );
	return;
    }
    NV_ProcessBegin();
    SV_RemoteCmdSetPower(Cmd_Argv_sv(1), atoi(Cmd_Argv_sv(2)));
    Cmd_PrintAdministrativeLog( "changed required power of cmd: %s to new power: %s", Cmd_Argv_sv(1), Cmd_Argv_sv(2));
    NV_ProcessEnd();
}

/*
============
Cmd_RemoteListAdmin_f
============
*/

static void Cmd_RemoteListAdmin_f() {

    adminPower_t *admin;
    int i;

    for(i = 0, admin = svse.adminPower ; admin ; i++, admin = admin->next){
                Com_Printf( "Admin : uid: %i to: level: %i\n", admin->uid, admin->power);
    }
    Com_Printf( "%i registered Admins\n", i);
}



/*
============
Cmd_List_f
============
*/
void Cmd_List_f( void ) {
	cmd_function_t  *cmd;
	int i;
	char            *match;

	if ( Cmd_Argc() > 1 ) {
		match = Cmd_Argv( 1 );
	} else {
		match = NULL;
	}
	
	i = 0;
	for ( cmd = cmd_functions ; cmd ; cmd = cmd->next ) {
		if ( (match && !Com_Filter( match, cmd->name, qfalse )) || svse.cmdInvoker.currentCmdPower < cmd->minPower) {
			continue;
		}
		Com_Printf( "%s\n", cmd->name );
		i++;
	}
	Com_Printf( "%i commands\n", i );
}


/*
============
Cmd_UnbanPlayer_f
============
*/

static void Cmd_UnbanPlayer_f() {

    char* guid;
    int uid;
    qboolean ubanstatus;
    ipBanList_t *thisipban;
    int i;


    if ( Cmd_Argc_sv() < 2) {
        if(sv_authorizemode->integer == 1)
            Com_Printf( "Usage: unban <@uid>\n" );
        else
            Com_Printf( "Usage: unban <guid>\n" );

        return;
    }

    guid = SV_IsGUID(Cmd_Argv_sv(1));
    if(guid){
        uid = 0;
        ubanstatus = SV_RemoveBan(uid, guid, NULL);
    }else{
        uid = SV_GetPlayerByHandle().uid;
        if(uid < 1){
            Com_Printf("Error: This player can not be unbanned, no such player\n");
            return;
        }
        ubanstatus = SV_RemoveBan(uid, NULL, NULL);
        SV_SendBroadcastUnban(uid, svse.cmdInvoker.currentCmdInvoker);
    }

    if(!ubanstatus){
        Com_Printf("Error: Tried to unban a player who is not actually banned\n");
        return;
    }

    for(thisipban = &svse.ipBans[0], i = 0; i < 1024; thisipban++, i++){
        if(uid == thisipban->uid){
            Com_Memset(thisipban,0,sizeof(ipBanList_t));
        }
    }
}



/*
============
Cmd_BanPlayer_f
============
*/

static void Cmd_BanPlayer_f() {

    int i;
    char* guid = NULL;
    clanduid_t cl = { 0 };
    char banreason[256];

    if(!Q_stricmp(Cmd_Argv(0), "bpermban") && svse.authserver.state < CA_CONNECTED){
        if(sv_authorizemode->integer != 1){
            Com_Printf( "Error: This command requires cvar: sv_authorizemode 1\n" );
        }else{
            Com_Printf( "Error: This command requires that this server is probably connected to the EUID server\n" );
        }
        return;
    }

    if ( Cmd_Argc_sv() < 3) {
        if(Q_stricmp(Cmd_Argv(0), "banUser") || Q_stricmp(Cmd_Argv(0), "banClient")){
            if(Cmd_Argc_sv() < 2){
                if(sv_authorizemode->integer == 1)
                    Com_Printf( "Usage: banUser <online-playername | online-playerslot | @uid>\n" );
                else
                    Com_Printf( "Usage: banUser <online-playername | online-playerslot | guid>\n" );

                return;
            }

        }else{
            if(sv_authorizemode->integer == 1)
                if(!Q_stricmp(Cmd_Argv(0), "bpermban")){
                    Com_Printf( "Usage: bpermban <online-playername | online-playerslot | @uid> <Reason for this ban (max 126 chars)>\n" );
                }else{
                    Com_Printf( "Usage: permban <online-playername | online-playerslot | @uid> <Reason for this ban (max 126 chars)>\n" );
                }
            else
                Com_Printf( "Usage: permban <online-playername | online-playerslot | guid> <Reason for this ban (max 126 chars)>\n" );

            return;
        }
    }

    if(sv_authorizemode->integer != 1){

        guid = SV_IsGUID(Cmd_Argv_sv(1));

        if(!guid){
            cl = SV_GetPlayerByHandle();
            if(!cl.cl){
                Com_Printf("Error: This player can not be banned, no such player\n");
                return;
            }else{
                guid = &cl.cl->pbguid[24];
            }
        }

    }else{
        cl = SV_GetPlayerByHandle();
        if(!cl.uid){
            Com_Printf("Error: This player can not be banned, no such player or he is not indentified yet\n");
            return;
        }
    }

    banreason[0] = 0;
    if ( Cmd_Argc_sv() > 2) {
        for(i = 2; Cmd_Argc_sv() > i ;i++){
            Q_strcat(banreason,256,Cmd_Argv_sv(i));
            Q_strcat(banreason,256," ");
        }
    }else{
        Q_strncpyz(banreason, "The admin has no reason given", 256);
    }

    if(strlen(banreason) > 126){
        Com_Printf("Error: You have exceeded the maximum allowed length of 126 for the reason\n");
        return;
    }

        if(cl.cl){
            //Banning
            SV_AddBan(cl.uid, svse.cmdInvoker.currentCmdInvoker, guid, cl.cl->name, (time_t)-1, banreason);
            if(cl.uid > 0 && !Q_stricmp(Cmd_Argv(0), "bpermban")){
                SV_SendBroadcastPermban(cl.uid, svse.cmdInvoker.currentCmdInvoker, banreason, cl.cl->name);
            }
            //Messages and kick
            if(sv_authorizemode->integer == 1){
                Com_Printf( "Banrecord added for player: %s uid: %i\n", cl.cl->name, cl.uid);
                Cmd_PrintAdministrativeLog( "banned player: %s uid: %i with the following reason: %s", cl.cl->name, cl.uid, banreason);
                SV_DropClient(cl.cl, va("You have got a permanent ban onto this gameserver\nYour ban will %s expire\nYour UID is: %i    Banning admin UID is: %i\nReason for this ban:\n%s",
                    "never", cl.uid, svse.cmdInvoker.currentCmdInvoker, banreason));

            }else{
                Com_Printf( "Banrecord added for player: %s guid: %s\n", cl.cl->name, cl.cl->pbguid);
                Cmd_PrintAdministrativeLog( "banned player: %s guid: %s with the following reason: %s", cl.cl->name, cl.cl->pbguid, banreason);
                SV_DropClient(cl.cl, va("You have got a permanent ban onto this gameserver\nYour GUID is: %s    Banning admin UID is: %i\nReason for this ban:\n%s",
                    cl.cl->pbguid, svse.cmdInvoker.currentCmdInvoker, banreason));
            }

        }else{
            //Banning
            SV_AddBan(cl.uid, svse.cmdInvoker.currentCmdInvoker, guid, "N/A", (time_t)-1, banreason);
            if(cl.uid > 0 && !Q_stricmp(Cmd_Argv(0), "bpermban")){
                SV_SendBroadcastPermban(cl.uid, svse.cmdInvoker.currentCmdInvoker, banreason, "N/A");
            }
            //Messages
            if(sv_authorizemode->integer == 1){
                Com_Printf( "Banrecord added for uid: %i\n", cl.uid);
                Cmd_PrintAdministrativeLog( "banned player uid: %i with the following reason: %s", cl.uid, banreason);
            }else{
                Com_Printf( "Banrecord added for guid: %s\n", guid);
                Cmd_PrintAdministrativeLog( "banned player guid: %s with the following reason: %s", guid, banreason);
            }
        }
}






/*
============
Cmd_TempBanPlayer_f
============
*/

static void Cmd_TempBanPlayer_f() {

    ipBanList_t *thisipban;
    int i;
    clanduid_t cl = { 0 };
    char banreason[256];
    int duration = 0;
    char endtime[32];
    char* temp;
    time_t aclock;
    time(&aclock);
    int length;
    char buff[8];
    char *guid = NULL;

    if(!Q_stricmp(Cmd_Argv(0), "btempban") && svse.authserver.state < CA_CONNECTED){
        if(sv_authorizemode->integer != 1){
            Com_Printf( "Error: This command requires cvar: sv_authorizemode 1\n" );
        }else{
            Com_Printf( "Error: This command requires that this server is probably connected to the EUID server\n" );
        }
        return;
    }

    if ( Cmd_Argc_sv() < 4) {

        if(!Q_stricmp(Cmd_Argv(0), "btempban")){
            Com_Printf( "Usage: btempban <online-playername | online-playerslot | @uid> <\"m\"inutes | \"h\"ours | \"d\"ays (example1: 5h   example2: 40m)>  <Reason for this ban (max 126 chars)>\n" );
        }else{
            if(sv_authorizemode->integer == 1)
                Com_Printf( "Usage: tempban <online-playername | online-playerslot | @uid> <\"m\"inutes | \"h\"ours | \"d\"ays (example1: 5h   example2: 40m)>  <Reason for this ban (max 126 chars)>\n" );
            else
                Com_Printf( "Usage: tempban <online-playername | online-playerslot | guid> <\"m\"inutes | \"h\"ours | \"d\"ays (example1: 5h   example2: 40m)>  <Reason for this ban (max 126 chars)>\n" );
        }
        return;
    }

    //Get user
    cl = SV_GetPlayerByHandle();
    if(sv_authorizemode->integer != 1){

        guid = SV_IsGUID(Cmd_Argv_sv(1));

        if(!guid){
            cl = SV_GetPlayerByHandle();
            if(!cl.cl){
                Com_Printf("Error: This player can not be banned, no such player\n");
                return;
            }else{
                guid = &cl.cl->pbguid[24];
            }
        }

    }else{
        cl = SV_GetPlayerByHandle();
        if(!cl.uid){
            Com_Printf("Error: This player can not be banned, no such player or he is not indentified yet\n");
            return;
        }
    }


    length = strlen(Cmd_Argv_sv(2));
    if(length > 7){
        Com_Printf("Error: Did not got a valid bantime\n");
        return;
    }


    if(Cmd_Argv_sv(2)[length-1] == 'm'){
        if(isNumeric(Cmd_Argv_sv(2),length-1)){
            Q_strncpyz(buff,Cmd_Argv_sv(2),length);
            duration = atoi(buff);
        }

    }else if(Cmd_Argv_sv(2)[length-1] == 'h'){
        if(isNumeric(Cmd_Argv_sv(2),length-1)){
            Q_strncpyz(buff,Cmd_Argv_sv(2),length);
            duration = (atoi(buff) * 60);
        }
    }else if(Cmd_Argv_sv(2)[length-1] == 'd'){
        if(isNumeric(Cmd_Argv_sv(2),length-1)){
            Q_strncpyz(buff,Cmd_Argv_sv(2),length);
            duration = (atoi(buff) * 24 * 60);
        }
    }
    if(duration < 1){
        Com_Printf("Error: Did not got a valid bantime\n");
        return;
    }
    if(duration > 60*24*30){
        Com_Printf("Error: Can not issue a temporarely ban that last longer than 30 days\n");
        return;
    }

    banreason[0] = 0;
    for(i = 3; Cmd_Argc_sv() > i ;i++){
        Q_strcat(banreason,256,Cmd_Argv_sv(i));
        Q_strcat(banreason,256," ");
    }
    if(strlen(banreason) > 126){
        Com_Printf("Error: You have exceeded the maximum allowed length of 126 for the reason\n");
        return;
    }


    if(sv_authorizemode->integer == 1){//Just for the case this ban has got shortened more then the ip-banduration
            for(thisipban = &svse.ipBans[0], i = 0; i < 1024; thisipban++, i++){
                if(cl.uid == thisipban->uid){
                    Com_Memset(thisipban,0,sizeof(ipBanList_t));
                }
            }
    }

        time_t expire = (aclock+(time_t)(duration*60));
        temp = ctime(&expire);
        temp[strlen(temp)-1] = 0;
        Q_strncpyz(endtime, temp, sizeof(endtime));

        if(cl.cl){

            SV_AddBan(cl.uid, svse.cmdInvoker.currentCmdInvoker, guid, cl.cl->name, expire, banreason);
            if(cl.uid  > 0 && !Q_stricmp(Cmd_Argv(0), "btempban")){
                SV_SendBroadcastTempban(cl.uid, svse.cmdInvoker.currentCmdInvoker, banreason, Cmd_Argv_sv(2), cl.cl->name);
            }

            if(sv_authorizemode->integer == 1){

                Com_Printf( "Banrecord added for player: %s uid: %i\n", cl.cl->name, cl.uid);
                Cmd_PrintAdministrativeLog( "temporarily banned player: %s uid: %i until %s with the following reason: %s", cl.cl->name, cl.uid, endtime, banreason);
                SV_DropClient(cl.cl, va("You have got a temporarily ban onto this gameserver\nYour ban will expire on: %s UTC\nYour UID is: %i    Banning admin UID is: %i\nReason for this ban:\n%s",
                    endtime, cl.uid, svse.cmdInvoker.currentCmdInvoker, banreason));

            }else{
                Com_Printf( "Banrecord added for player: %s guid: %s\n", cl.cl->name, cl.cl->pbguid);
                Cmd_PrintAdministrativeLog( "temporarily banned player: %s guid: %s until %s with the following reason: %s", cl.cl->name, cl.cl->pbguid, endtime, banreason);
                SV_DropClient(cl.cl, va("You have got a temporarily ban onto this gameserver\nYour ban will expire on: %s UTC\nYour GUID is: %s    Banning admin UID is: %i\nReason for this ban:\n%s",
                    endtime, cl.cl->pbguid, svse.cmdInvoker.currentCmdInvoker, banreason));
            }

        }else{

            SV_AddBan(cl.uid, svse.cmdInvoker.currentCmdInvoker, guid, "N/A", expire, banreason);
            if(cl.uid  > 0 && !Q_stricmp(Cmd_Argv(0), "btempban")){
                SV_SendBroadcastTempban(cl.uid, svse.cmdInvoker.currentCmdInvoker, banreason, Cmd_Argv_sv(2), "N/A");
            }

            if(sv_authorizemode->integer == 1){
                Com_Printf( "Banrecord added for uid: %i\n", cl.uid);
                Cmd_PrintAdministrativeLog( "temporarily banned player uid: %i until %s with the following reason: %s", cl.uid, endtime, banreason);

            }else{
                Com_Printf( "Banrecord added for guid: %s\n", guid);
                Cmd_PrintAdministrativeLog( "temporarily banned player guid: %s until %s with the following reason: %s", guid, endtime, banreason);
            }
        }
}






/*
============
Cmd_KickPlayer_f
============
*/

static void Cmd_KickPlayer_f() {

    int i;
    clanduid_t cl;
    char kickreason[256];

    if ( Cmd_Argc_sv() < 2) {
        Com_Printf( "Usage: kick < user (online-playername | online-playerslot | uid (@#  or  u#)) > <Reason for this kick (max 126 chars) (optional)>\n" );
        return;
    }

    cl = SV_GetPlayerByHandle();
    if(!cl.cl){
            Com_Printf("Error: This player is not online and can not be kicked\n");
            return;
    }

    kickreason[0] = 0;
    if ( Cmd_Argc_sv() > 2) {
        for(i = 2; Cmd_Argc_sv() > i ;i++){
            Q_strcat(kickreason,256,Cmd_Argv_sv(i));
            Q_strcat(kickreason,256," ");
        }
    }else{
        Q_strncpyz(kickreason, "The admin has no reason given", 256);
    }
    if(strlen(kickreason) >= 256 ){
        Com_Printf("Error: You have exceeded the maximum allowed length of 126 for the reason\n");
        return;
    }
    if(sv_authorizemode->integer == 1){
        if(cl.uid){
            Com_Printf( "Player kicked: %s ^7uid: %i\nReason: %s", cl.cl->name, cl.uid, kickreason);
            Cmd_PrintAdministrativeLog( "kicked player: %s uid: %i with the following reason: %s", cl.cl->name, cl.uid, kickreason);
        }else{
            Com_Printf( "Player kicked: %s ^7uid: N/A\nReason: %s", cl.cl->name, kickreason);
            Cmd_PrintAdministrativeLog( "kicked player: %s unknown uid with the following reason: %s", cl.cl->name, kickreason);
        }
    }else{
        Com_Printf( "Player kicked: %s ^7guid: %s\nReason: %s", cl.cl->name, cl.cl->pbguid, kickreason);
        Cmd_PrintAdministrativeLog( "kicked player: %s guid: %s with the following reason: %s", cl.cl->name, cl.cl->pbguid, kickreason);
    }
    SV_DropClient(cl.cl, va("Player kicked:\nAdmin UID is: %i\nReason for this kick:\n%s",
         svse.cmdInvoker.currentCmdInvoker, kickreason));
}

/*
================
SV_DumpBanlist_f
================
*/

void SV_DumpBanlist_f(){
    SV_DumpBanlist();
}



/*
================
SV_MiniStatus_f
================
*/
static void SV_MiniStatus_f( void ) {
	int			i, j, l;
	client_t	*cl;
	gclient_t	*gclient;
	extclient_t	*excl;
	const char	*s;
	int		ping;

	// make sure server is running
	if ( !com_sv_running->integer ) {
		Com_Printf( "Server is not running.\n" );
		return;
	}

	Com_Printf ("map: %s\n", sv_mapname->string );

	Com_Printf ("num score ping uid      name                             address               OS  authstate(debug)\n");

	Com_Printf ("--- ----- ---- -------- -------------------------------- --------------------- --- ----------------\n");
	for (i=0,cl=svs.clients,excl=svse.extclients, gclient = level.clients ; i < sv_maxclients->integer ; i++,cl++,excl++, gclient++)
	{
		if (!cl->state)
			continue;
		Com_Printf ("%3i ", i);
		Com_Printf ("%5i ", gclient->pers.scoreboard.score);
		if (cl->state == CS_CONNECTED)
			Com_Printf ("CNCT ");
		else if (cl->state == CS_ZOMBIE)
			Com_Printf ("ZMBI ");
		else if (cl->state == CS_PRIMED)
			Com_Printf ("PRIM ");
		else
		{
			ping = cl->ping < 9999 ? cl->ping : 9999;
			Com_Printf ("%4i ", ping);
		}


		if(excl->uid > 0){
			Com_Printf ("%8i ", excl->uid );
		}else{
			Com_Printf ("     N/A ");
		}

		Com_Printf ("%s", cl->name);
		
		// TTimo adding a ^7 to reset the color
		// NOTE: colored names in status breaks the padding (WONTFIX)
		Com_Printf ("^7");
		l = 33 - Q_PrintStrlen(cl->name);
		j = 0;
		
		do
		{
			Com_Printf (" ");
			j++;
		} while(j < l);

		s = NET_AdrMaskToString( cl->netchan.remoteAddress );
		Com_Printf ("%s", s);
		l = 22 - strlen(s);
		j = 0;
		
		do
		{
			Com_Printf(" ");
			j++;
		} while(j < l);

		switch(excl->OS){
			case 'M':
				Com_Printf ("Mac ");
				break;
			case 'W':
				Com_Printf ("Win ");
				break;
			default:
				Com_Printf ("N/A ");
		}
		switch(excl->authstate){
			case CAU_NEEDHWINFO:
				Com_Printf ("Need HW-Info");
				break;
			case CAU_GOTGUIDHWINFO:
				Com_Printf ("Got Guid and HW-Info");
				break;
			case CAU_REQUESTEDUID:
				Com_Printf ("Awaiting UID");
				break;		//Do nothing, just wait
			case CAU_GOTUID:
				Com_Printf ("Got UID");
				break;
			case CAU_REQUESTEDUSERINFO:
				Com_Printf ("Awaiting Userinfo");
				break;		//Do nothing, just wait
			case CAU_GOTUSERINFO:
				Com_Printf ("Got Userinfo");
				break;
			case CAU_GUIDUPDATED:
				Com_Printf ("GUID Updated");
				break;
			case CAU_FINISHED:
				Com_Printf ("Done");
				break;
			default:
				Com_Printf ("?");
		}
		Com_Printf ("\n");
	}
}


/*
==================
SV_Heartbeat_f

Also called by SV_DropClient, SV_DirectConnect, and SV_SpawnServer
==================
*/
void SV_Heartbeat_f( void ) {
	svse.nextHeartbeatTime = -9999999;
}


/*
============
Cmd_ExecuteTranslatedCommand_f
============
*/

static void Cmd_ExecuteTranslatedCommand_f(){

    int i;
    char outstr[128];

    char *cmdname = Cmd_Argv_sv(0);
    char *cmdstring = NULL;
    char *tmp;

    for(i=0; i < MAX_TRANSCMDS; i++){
        if(!Q_stricmp(cmdname, svse.translatedCmd[i].cmdname)){
            cmdname = svse.translatedCmd[i].cmdname;
            cmdstring = svse.translatedCmd[i].cmdargument;
            break;
        }
    }
    if(!cmdstring) return;

    tmp = outstr;
    i = 1;
    while(*cmdstring){
        if(*cmdstring == '$'){
            if(!Q_strncmp(cmdstring, "$uid", 4)){
                Com_sprintf(tmp, sizeof(outstr) - (tmp - outstr), "%i", svse.cmdInvoker.currentCmdInvoker);
                tmp += strlen(tmp);
                cmdstring += 4;
            }else if(!Q_strncmp(cmdstring, "$clnum", 6)){
                Com_sprintf(tmp, sizeof(outstr) - (tmp - outstr), "%i", svse.cmdInvoker.clientnum);
                tmp += strlen(tmp);
                cmdstring += 6;
            }else if(!Q_strncmp(cmdstring, "$pow", 4)){
                Com_sprintf(tmp, sizeof(outstr) - (tmp - outstr), "%i", svse.cmdInvoker.currentCmdPower);
                tmp += strlen(tmp);
                cmdstring += 4;
            }else if(!Q_strncmp(cmdstring, "$arg", 4)){
                if(!*Cmd_Argv_sv(i)){
                    Com_Printf("Not enought arguments to this command\n");
                    return;
                }
                if(strchr(Cmd_Argv_sv(i), ';')){
                    return;
                }
                Com_sprintf(tmp, sizeof(outstr) - (tmp - outstr), "%s", Cmd_Argv_sv(i));
                cmdstring += 4;
                tmp += strlen(tmp);
                i++;
            }
        }

        *tmp = *cmdstring;
        cmdstring++;
        tmp++;

    }

    *tmp = 0;
    Com_DPrintf("String to Execute: %s\n", outstr);
    Cbuf_AddText(EXEC_NOW, outstr);
}



/*
============
Cmd_AddTranslatedCommand_f
============
*/

static void Cmd_AddTranslatedCommand_f() {

    char *cmdname;
    char *string;
    int free;
    int i;

    if ( Cmd_Argc_sv() != 3) {
        Com_Printf( "Usage: addCommand <commandname> <\"string to execute\"> String can contain: $uid $clnum $pow $arg\n" );
        return;
    }

    cmdname = Cmd_Argv_sv(1);
    string = Cmd_Argv_sv(2);

    for(i=0, free = -1; i < MAX_TRANSCMDS; i++){
        if(!Q_stricmp(cmdname, svse.translatedCmd[i].cmdname)){
            Com_Printf("This command is already defined\n");
            return;
        }
        if(!*svse.translatedCmd[i].cmdname){
            free = i;
        }

    }
    if(free == -1){
        Com_Printf("Exceeded limit of custom commands\n");
        return;
    }

    Q_strncpyz(svse.translatedCmd[free].cmdname, cmdname, sizeof(svse.translatedCmd[free].cmdname));
    Q_strncpyz(svse.translatedCmd[free].cmdargument, string, sizeof(svse.translatedCmd[free].cmdargument));

    Cmd_AddServerCommand (svse.translatedCmd[free].cmdname, Cmd_ExecuteTranslatedCommand_f);

    Com_Printf("Added custom command: %s -> %s\n", svse.translatedCmd[free].cmdname, svse.translatedCmd[free].cmdargument);

}



static void Cmd_DisplayUIDSVConStatus_f(){
	Com_Printf("Connection status to UID server:\n");
	Com_Printf("State:                      %i\n", svse.authserver.state);
	Com_Printf("Remote connect address:     %s\n", NET_AdrToString(svse.authserver.connectAddress));
	Com_Printf("Last packet time:           %i\n", svse.authserver.lastPacketTime);
	Com_Printf("Last packet sent time:      %i\n", svse.authserver.lastPacketSentTime);
	Com_Printf("Connection timeout counter: %i\n", svs.time - svse.authserver.connectionTimeout);
	Com_Printf("Reliable sequence:          %i\n", svse.authserver.reliableSequence);
	Com_Printf("Reliable acknowledge:       %i\n", svse.authserver.reliableAcknowledge);
	Com_Printf("Reliable sent:              %i\n", svse.authserver.reliableSent);
	Com_Printf("Message Acknowledge:        %i\n", svse.authserver.messageAcknowledge);
	Com_Printf("Server message sequence:    %i\n", svse.authserver.serverMessageSequence);
	Com_Printf("Server command sequence:    %i\n", svse.authserver.serverCommandSequence);
}




/*
====================
SV_StopRecording_f

stop recording a demo
====================
*/
void SV_StopRecord_f( void ) {

	clanduid_t cl;
	int i;

	if ( Cmd_Argc() != 2) {
		Com_Printf( "stoprecord <client>\n" );
		return;
	}

	if(!Q_stricmp(Cmd_Argv( 1 ), "all"))
	{
		for(i = 0, cl.cl = svs.clients; i < sv_maxclients->integer; i++, cl.cl++)
		{
			if(cl.cl->demorecording)
				SV_StopRecord(cl.cl);
		}
		return;
	}


	cl = SV_GetPlayerByHandle();
	if(!cl.cl){
		Com_Printf("Error: This player is not online and can not be recorded\n");
		return;
	}
	SV_StopRecord(cl.cl);
}


/*
====================
SV_Record_f

record <demoname>

Begins recording a demo from the current position
====================
*/
//static char demoName[MAX_QPATH];        // compiler bug workaround
void SV_Record_f( void ) {

	char* s;
	clanduid_t cl;
	int i;

	if ( Cmd_Argc() > 3 || Cmd_Argc() < 2) {
		Com_Printf( "record <client> <demoname>\n" );
		return;
	}

	if ( Cmd_Argc() == 3 ) {
		s = Cmd_Argv( 2 );
	} else {
		s = NULL;
	}

	if(!Q_stricmp(Cmd_Argv( 1 ), "all"))
	{
		for(i = 0, cl.cl = svs.clients; i < sv_maxclients->integer; i++, cl.cl++)
		{
			if(cl.cl->state == CS_ACTIVE && !cl.cl->demorecording)
				SV_RecordClient(cl.cl, s);
		}
		return;
	}

	cl = SV_GetPlayerByHandle();
	if(!cl.cl){
		Com_Printf("Error: This player is not online and can not be recorded\n");
		return;
	}
	SV_RecordClient(cl.cl, s);
}

/*
void test(){
	int i;
	msg_t msg;
	byte msgBuf[1024];
	byte* bbyte;
	int dword;
	Com_Memset(msgBuf, 0, sizeof(msgBuf));
	MSG_Init(&msg, msgBuf, sizeof(msgBuf));
	MSG_WriteBits(&msg, 2, 3);
	MSG_WriteBits(&msg, 2, 7);
	MSG_WriteBits(&msg, 3, 15);
	MSG_WriteBits(&msg, 7, 12);
	MSG_WriteBit0(&msg);
	MSG_WriteBits(&msg, 1, 3);
//	MSG_WriteLong(&msg, 0xffffffff);
//	MSG_WriteBit0(&msg);
//	MSG_WriteBit0(&msg);
//	MSG_WriteBit0(&msg);
//	MSG_WriteBit0(&msg);

//	msg.data[4] = 0xFF;
//	msg.data[5] = 0xFF;
//	msg.data[6] = 0x7F;
//	msg.data[7] = 0xFF;


//    for(i = 0; i < 16; i++){
//	MSG_WriteBit0(&msg);
//	MSG_WriteBits(&msg, 0, 1);
	bbyte = &msg.data[0];
	dword = *(int*)bbyte;
	Com_Printf("%s\n", Q_BitConv(dword));
	bbyte = &msg.data[4];
	dword = *(int*)bbyte;
	Com_Printf("%s\n", Q_BitConv(dword));
	Com_Printf("CurSize: %i, Bit %i\n", msg.cursize, msg.bit);
//    }

}
*/


void SV_AddOperatorCommandsCallback(){
	static qboolean	initialized;

	if ( initialized ) {
		return;
	}
	initialized = qtrue;
        CmdCount = 0;
	Cmd_AddServerCommand ("stoprecord", SV_StopRecord_f);
	Cmd_AddServerCommand ("record", SV_Record_f);
	Cmd_AddServerCommand ("broadcast", SV_BroadcastSay_f);
	Cmd_AddServerCommand ("heartbeat", SV_Heartbeat_f);
	Cmd_AddServerCommand ("dumpbanlist", SV_DumpBanlist_f);
	Cmd_AddServerCommand ("kick", Cmd_KickPlayer_f);
	Cmd_AddServerCommand ("clientkick", Cmd_KickPlayer_f);
	Cmd_AddServerCommand ("onlykick", Cmd_KickPlayer_f);
	Cmd_AddServerCommand ("unban", Cmd_UnbanPlayer_f);
	Cmd_AddServerCommand ("unbanUser", Cmd_UnbanPlayer_f);
	Cmd_AddServerCommand ("permban", Cmd_BanPlayer_f);
	Cmd_AddServerCommand ("tempban", Cmd_TempBanPlayer_f);
	Cmd_AddServerCommand ("bpermban", Cmd_BanPlayer_f);
	Cmd_AddServerCommand ("btempban", Cmd_TempBanPlayer_f);
	Cmd_AddServerCommand ("banUser", Cmd_BanPlayer_f);
	Cmd_AddServerCommand ("banClient", Cmd_BanPlayer_f);
	Cmd_AddServerCommand ("ministatus", SV_MiniStatus_f);
	Cmd_AddServerCommand ("writenvcfg", NV_WriteConfig);
	Cmd_AddServerCommand ("setAdmin", Cmd_RemoteSetAdmin_f);
	Cmd_AddServerCommand ("unsetAdmin", Cmd_RemoteUnsetAdmin_f);
	Cmd_AddServerCommand ("setCmdMinPower", Cmd_RemoteSetPermission_f);
	Cmd_AddServerCommand ("adminlist", Cmd_RemoteListAdmin_f);
	Cmd_AddServerCommand ("say", SV_ConSayChat_f);
	Cmd_AddServerCommand ("consay", SV_ConSayConsole_f);
	Cmd_AddServerCommand ("screensay", SV_ConSayScreen_f);
	Cmd_AddServerCommand ("tell", SV_ConTellChat_f);
	Cmd_AddServerCommand ("contell", SV_ConTellConsole_f);
	Cmd_AddServerCommand ("screentell", SV_ConTellScreen_f);
	Cmd_AddServerCommand ("dumpuser", SV_DumpUser_f);
	Cmd_AddServerCommand ("status", SV_Status_f);
	Cmd_AddServerCommand ("pbinfo", PBInfoPrint_f);
	Cmd_AddServerCommand ("addCommand", Cmd_AddTranslatedCommand_f);
	Cmd_AddServerCommand ("UidSvConStatus", Cmd_DisplayUIDSVConStatus_f);
}




