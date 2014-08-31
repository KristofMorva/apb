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

void SV_CmdSendQuery(client_t *cl, char* string){

//	CL_AddReliableCommand(va("getUserinfo Ticket %i \"%s\"", cl->challenge+QT_CMDQUERY, string));
//	Com_Printf("Query sent:\n");

}



void SV_DumpUserResponse(char* globalUserinfo){

	int j, l, i;
	time_t t1;
	char *nick;

	Com_Printf("UID:                 %s\n", Info_ValueForKey( globalUserinfo, "uid" ));

        Com_Printf("Connections:         %s\n", Info_ValueForKey( globalUserinfo, "connections" ));

	t1 = atoi(Info_ValueForKey( globalUserinfo, "firstseen" ));
        Com_Printf("Firstseen:           %s",ctime(&t1));

	t1 = atoi(Info_ValueForKey( globalUserinfo, "lastseen" ));
        Com_Printf("Lastseen:            %s",ctime(&t1));

        Com_Printf("Current IP:          %s\n", Info_ValueForKey( globalUserinfo, "currentip" ));
        Com_Printf("Previous used IP:    %s\n", Info_ValueForKey( globalUserinfo, "olderip" ));
        Com_Printf("First Server:        %s\n", Info_ValueForKey( globalUserinfo, "firstserver" ));
        Com_Printf("Last Server:         %s\n", Info_ValueForKey( globalUserinfo, "lastserver" ));
	if(atoi(Info_ValueForKey( globalUserinfo, "banduration" )) != 0){
		Com_Printf("Globaly banned user: %i\n", atoi(Info_ValueForKey( globalUserinfo, "banduration" )));
	}else{
		Com_Printf("Globaly banned user: N/A\n");
	}


        Com_Printf("\nRecent used nicknames\n");
        Com_Printf("Name            Last used\n");
        Com_Printf("--------------- ------------------------\n");
        for(i = 0; i < MAX_NICKNAMES ; i++){
            t1 = atoi(Info_ValueForKey( globalUserinfo, va("nicklastused%i", i)));
            if(!t1) continue;
            nick = Info_ValueForKey( globalUserinfo, va("nickname%i", i));
            Com_Printf("%s^7", nick);
            l = 16 - Q_PrintStrlen(nick);
            j = 0;

            do
            {
                Com_Printf (" ");
                j++;
            } while(j < l);

            Com_Printf(ctime(&t1));

        }

	Com_Printf("\n");
}

void SV_PrintQuery(client_t* cl, char* string, void (formatPrint)(char* str)){

	char sv_outputbuf[SV_OUTPUTBUF_LENGTH];

	if(cl){
		svse.redirectClient = cl;
		Com_BeginRedirect(sv_outputbuf, SV_OUTPUTBUF_LENGTH, SV_ReliableSendRedirect);
		formatPrint(string);
		Com_EndRedirect();
	}else{
		formatPrint(string);
	}
}


void SV_SendBroadcastPermban( int uid, int auid, const char *message, const char* name){
    char infostring[MAX_INFO_STRING];
    *infostring = 0;

    Info_SetValueForKey( infostring, "cmd", "ban");
    Info_SetValueForKey( infostring, "reason", message);
    Info_SetValueForKey( infostring, "uid", va("%i", uid));
    Info_SetValueForKey( infostring, "auid", va("%i", auid));
    Info_SetValueForKey( infostring, "name", name);
    CL_AddReliableCommand(&svse.authserver, va("broadcast \"%s\"", infostring));
}
void SV_SendBroadcastTempban( int uid, int auid, const char *message, const char* expire, const char* name){
    char infostring[MAX_INFO_STRING];
    *infostring = 0;

    Info_SetValueForKey( infostring, "cmd", "tempban");
    Info_SetValueForKey( infostring, "reason", message);
    Info_SetValueForKey( infostring, "uid", va("%i", uid));
    Info_SetValueForKey( infostring, "auid", va("%i", auid));
    Info_SetValueForKey( infostring, "name", name);
    Info_SetValueForKey( infostring, "expire", expire);
    CL_AddReliableCommand(&svse.authserver, va("broadcast \"%s\"", infostring));
}


void SV_SendBroadcastUnban( int uid, int auid ){
    char infostring[MAX_INFO_STRING];
    *infostring = 0;

    Info_SetValueForKey( infostring, "cmd", "unban");
    Info_SetValueForKey( infostring, "uid", va("%i", uid));
    Info_SetValueForKey( infostring, "auid", va("%i", auid));
    CL_AddReliableCommand(&svse.authserver, va("broadcast \"%s\"", infostring));
}


void SV_SendBroadcastMessage( const char *message){

    char infostring[MAX_INFO_STRING];
    *infostring = 0;

    Info_SetValueForKey( infostring, "cmd", "msg");

    Info_SetValueForKey( infostring, "bmessage", message);

    CL_AddReliableCommand(&svse.authserver, va("broadcast \"%s\"", infostring));
}