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

static cvar_t *g_voteTime;
static cvar_t *g_voteBanTime;
cvar_t *g_votedMapName;
cvar_t *g_votedGametype;
static cvar_t *g_voteVoteGametypes;
static cvar_t *g_voteKickMinPlayers;
static cvar_t *g_voteMaxVotes;
static cvar_t *g_voteAllowMaprotate;
static cvar_t *g_voteAllowKick;
static cvar_t *g_voteAllowGametype;
static cvar_t *g_voteAllowMap;
static cvar_t *g_voteAllowRestart;

static int g_voteFlags;

void Init_CallVote(void){

	g_votedMapName = Cvar_RegisterString("g_votedMapName", "", CVAR_ARCHIVE, "Contains the voted mapname");
	g_votedGametype = Cvar_RegisterString("g_votedGametype", "", CVAR_ARCHIVE, "Contains the voted gametype");
	g_voteTime = Cvar_RegisterInt("g_voteTime", 30, 10, 90, CVAR_ARCHIVE, "Duration a called vote is active");
	g_voteBanTime = Cvar_RegisterInt("g_voteBanTime", 15, 1, 240, CVAR_ARCHIVE, "Duration a player is banned after successful votekick");
	g_voteMaxVotes = Cvar_RegisterInt("g_voteMaxVotes", 2, 1, 10, CVAR_ARCHIVE, "How many votes a player can call");
	g_voteVoteGametypes = Cvar_RegisterString("g_voteVoteGametypes", "", CVAR_ARCHIVE, "Contains a list of gametypes that are allowed to vote. Empty list = all");
	g_voteKickMinPlayers = Cvar_RegisterInt("g_voteKickMinPlayers", 5, 0, 14, CVAR_ARCHIVE, "How many active players are needed on server to allow calling a kickvote");
	g_voteAllowMaprotate = Cvar_RegisterBool("g_voteAllowMaprotate", qtrue, CVAR_ARCHIVE, "Allow calling map_rotate votes");
	g_voteAllowKick = Cvar_RegisterBool("g_voteAllowKick", qtrue, CVAR_ARCHIVE, "Allow calling kick votes");
	g_voteAllowGametype = Cvar_RegisterBool("g_voteAllowGametype", qtrue, CVAR_ARCHIVE, "Allow calling gametype votes");
	g_voteAllowMap = Cvar_RegisterInt("g_voteAllowMap", 1, 0, 2, CVAR_ARCHIVE, "Allow calling next map setting votes - 0=disabled, 1=only from rotation, 2=Any map");
	g_voteAllowRestart = Cvar_RegisterBool("g_voteAllowRestart", qtrue, CVAR_ARCHIVE, "Allow calling map restart votes");

	g_voteFlags = 0;
	g_voteFlags |= g_voteAllowRestart->boolean ? VOTEFLAGS_RESTART : 0;
	g_voteFlags |= g_voteAllowGametype->boolean ? VOTEFLAGS_GAMETYPE : 0;
	g_voteFlags |= g_voteAllowMaprotate->boolean ? VOTEFLAGS_NEXTMAP : 0;
	g_voteFlags |= g_voteAllowMap->boolean && g_voteAllowGametype->boolean ? VOTEFLAGS_TYPE : 0;
	g_voteFlags |= g_voteAllowKick->boolean ? VOTEFLAGS_KICK : 0;
	g_voteFlags |= g_voteAllowMap->integer ? VOTEFLAGS_MAP : 0;
	g_voteFlags |= g_voteAllowMap->integer == 2 ? VOTEFLAGS_ANYMAP : 0;
}

/*
==================
Cmd_CallVote_f
==================
*/
void Cmd_CallVote_f( gentity_t *ent ) {
	int i, activePlayers;
	char arg1[MAX_STRING_TOKENS];
	char arg2[MAX_STRING_TOKENS];
	char arg3[MAX_STRING_TOKENS];
	char cleanName[64];    // JPW NERVE
	int mask = 0;

	if ( !g_allowVote->boolean ) {
		SV_GameSendServerCommand( ent - g_entities, 0, va("%c \"GAME_VOTINGNOTENABLED\"\0", 0x65));
		return;
	}
	if ( level.voteTime ) {
		SV_GameSendServerCommand( ent - g_entities, 0, va("%c \"GAME_VOTEALLREADYINPROGRESS\"\0", 0x65));
		return;
	}
	if ( ent->client->pers.voteCount >= g_voteMaxVotes->integer ) {
		SV_GameSendServerCommand( ent - g_entities, 0, va("%c \"You have called too many votes\"\0", 0x65));
		return;
	}
	if ( ent->client->sess.sessionTeam == TEAM_SPECTATOR ) {
		SV_GameSendServerCommand( ent - g_entities, 0, va("%c \"GAME_NOSPECTATORCALLVOTE\"\0", 0x65));
		return;
	}

	// make sure it is a valid command to vote on
	SV_Cmd_ArgvBuffer( 1, arg1, sizeof( arg1 ) );
	SV_Cmd_ArgvBuffer( 2, arg2, sizeof( arg2 ) );
	SV_Cmd_ArgvBuffer( 3, arg3, sizeof( arg3 ) );

	if ( strchr( arg1, ';' ) || strchr( arg2, ';' ) || strchr( arg3, ';' ) ) {
		SV_GameSendServerCommand( ent - g_entities, 0, va("%c \"GAME_INVALIDVOTESTRING\"\0", 0x65));
		return;
	}

	if ( !Q_stricmp( arg1, "map_restart" ) ) {
		mask = VOTEFLAGS_RESTART;
	} else if ( !Q_stricmp( arg1, "map_rotate" ) ) {
		mask = VOTEFLAGS_NEXTMAP;
	} else if ( !Q_stricmp( arg1, "map" ) ) {
		mask = VOTEFLAGS_MAP;
	} else if ( !Q_stricmp( arg1, "typemap" ) ) {
		mask = VOTEFLAGS_TYPE;
	} else if ( !Q_stricmp( arg1, "kick" ) ) {
		mask = VOTEFLAGS_KICK;
	} else if ( !Q_stricmp( arg1, "tempbanuser" ) ) {
		mask = VOTEFLAGS_KICK;
	} else if ( !Q_stricmp( arg1, "g_gametype" ) ) {        // NERVE - SMF
		mask = VOTEFLAGS_GAMETYPE;
// jpw
	} else {
		SV_GameSendServerCommand( ent - g_entities, 0, va("%c \"GAME_INVALIDVOTESTRING\"\0", 0x65));
		SV_GameSendServerCommand( ent - g_entities, 0, va("%c \"GAME_VOTECOMMANDSARE\x15 map_restart, map_rotate, map <mapname>, g_gametype <gametype>, kick <player or clientnum>, typemap <gametype> <map>\"\0", 0x65));
		return;
	}

	if ( !( g_voteFlags & mask ) ) {
		SV_GameSendServerCommand( ent - g_entities, 0, va("%c \"Voting for %s is disabled on this server\"\0", 0x65, arg1 ) );
		return;
	}

	// if there is still a vote to be executed
	if ( level.voteExecuteTime ) {
		level.voteExecuteTime = 0;
		Cbuf_AddText( EXEC_NOW, va( "%s\n", level.voteString ) );
	}

	// special case for g_gametype, check for bad values
	if ( !Q_stricmp( arg1, "typemap" ) ) {
	
		if(*g_voteVoteGametypes->string){
			if(!strstr(g_voteVoteGametypes->string, arg2)){
				SV_GameSendServerCommand( ent - g_entities, 0, va("%c \"Voting for gametype %s is disabled on this server\"\0", 0x65, arg2));
				return;
			}
		}

		for( i = 0; i < g_gametypes->numGametypes; i++){
			if(!Q_stricmp( arg2, g_gametypes->gametype[i].gametypename) )
				break;
		}
		if ( i == g_gametypes->numGametypes) {
			SV_GameSendServerCommand( ent - g_entities, 0, va("%c \"GAME_INVALIDGAMETYPE\"\0", 0x65));
			return;
		}

		if( !(g_voteFlags & VOTEFLAGS_ANYMAP) ){
			if(!strstr(sv_mapRotation->string, va("map %s",arg3))){
				Com_Printf("Debug: %s  %s\n", va("map %s",arg3), sv_mapRotation->string);
				SV_GameSendServerCommand( ent - g_entities, 0, va("%c \"Voting for map %s is disabled on this server\"\0", 0x65));
				return;
			}
		}
		Com_sprintf( level.voteString, sizeof( level.voteString ), "set g_votedGametype %s; set g_votedMapName %s\n", arg2, arg3);
		Com_sprintf( level.voteDisplayString, sizeof( level.voteDisplayString ), "Set next map to: %s and gametype to: \x14%s", arg3, g_gametypes->gametype[i].gametypereadable);
		
	} else if ( !Q_stricmp( arg1, "g_gametype" ) ) {
	
		if(*g_voteVoteGametypes->string){
			if(!strstr(g_voteVoteGametypes->string, arg2)){
				SV_GameSendServerCommand( ent - g_entities, 0, va("%c \"Voting for gametype %s is disabled on this server\"\0", 0x65, arg2));
				return;
			}
		}

		for( i = 0; i < g_gametypes->numGametypes; i++){
			if(!Q_stricmp( arg2, g_gametypes->gametype[i].gametypename) )
				break;
		}
		if ( i == g_gametypes->numGametypes) {
			SV_GameSendServerCommand( ent - g_entities, 0, va("%c \"GAME_INVALIDGAMETYPE\"\0", 0x65));
			return;
		}

		Com_sprintf( level.voteString, sizeof( level.voteString ), "set g_gametype %s; map_restart\n", arg2);
		Com_sprintf( level.voteDisplayString, sizeof( level.voteDisplayString ), "Set gametype to: \x15%s and restart", g_gametypes->gametype[i].gametypename);

	} else if ( !Q_stricmp( arg1, "map_restart" ) ) {
		// NERVE - SMF - do a warmup when we restart maps
		Com_sprintf( level.voteString, sizeof( level.voteString ), "map_restart\n");
		Com_sprintf( level.voteDisplayString, sizeof( level.voteDisplayString ), "Restart current game" );
	} else if ( !Q_stricmp( arg1, "map" ) ) {

		if( !(g_voteFlags & VOTEFLAGS_ANYMAP) ){
			if(!strstr(sv_mapRotation->string, va("map %s", arg2))){
				SV_GameSendServerCommand( ent - g_entities, 0, va("%c \"This server does not allow voting for maps which aren't part of map-rotation\"\0", 0x65));
				return;
			}
		}
		Com_sprintf( level.voteString, sizeof( level.voteString ), "set g_votedMapName %s\n", arg2 );
		Com_sprintf( level.voteDisplayString, sizeof( level.voteDisplayString ), "Set next map to: %s", arg2 );
	} else if ( !Q_stricmp( arg1, "map_rotate" ) ) {

		if(*g_votedMapName->string){
			if(*g_votedGametype->string)
				Com_sprintf( level.voteString, sizeof( level.voteString ), "set g_gametype %s; map %s; set g_votedGametype \"\"; set g_votedMapName \"\"\n", g_votedGametype->string, g_votedMapName->string);
			else
				Com_sprintf( level.voteString, sizeof( level.voteString ), "map %s; set g_votedMapName \"\"\n", g_votedMapName->string);
			//Com_sprintf( s, sizeof( s ), g_votedMapName->string);
		}else{
			Com_sprintf( level.voteString, sizeof( level.voteString ), "map_rotate\n" );
			//Com_sprintf( s, sizeof( s ), g_votedMapName->string);
		}
		Com_sprintf( level.voteDisplayString, sizeof( level.voteDisplayString ), "Switch to next map now");
// JPW NERVE
	} else if ( !Q_stricmp( arg1,"tempbanuser") || !Q_stricmp( arg1,"kick")) {
		int i,kicknum = MAX_CLIENTS;
		for ( i = 0, activePlayers = 0; i < level.maxclients; i++ ) {
			if ( level.clients[i].pers.connected != CON_CONNECTED || level.clients[i].sess.sessionTeam == TEAM_SPECTATOR) {
				continue;
			}
			activePlayers++;
		}
		if(activePlayers < g_voteKickMinPlayers->integer){
			SV_GameSendServerCommand( ent - g_entities, 0, va("%c \"GAME_VOTINGNOTENOUGHPLAYERS\"\0", 0x65));
			return;
		}
		for ( i = 0; i < MAX_CLIENTS; i++ ) {
			if ( level.clients[i].pers.connected != CON_CONNECTED ) {
				continue;
			}
// strip the color crap out
			Q_strncpyz( cleanName, level.clients[i].pers.netname, sizeof( cleanName ) );
			Q_CleanStr( cleanName );
			if ( !Q_stricmp( cleanName, arg2 ) ) {
				kicknum = i;
			}
		}
		Com_sprintf( level.voteDisplayString, sizeof( level.voteDisplayString ), "%s wants kick and tempban: %s", ent->client->pers.netname ,level.clients[kicknum].pers.netname );
		if ( kicknum != MAX_CLIENTS ) { // found a client # to kick, so override votestring with better one
			Com_sprintf( level.voteString, sizeof( level.voteString ),"tempban \"%d\" %im Vote kick; kick \"%d\" Vote kick\n", kicknum, g_voteBanTime->integer, kicknum);
		} else { // if it can't do a name match, don't allow kick (to prevent votekick text spam wars)
			SV_GameSendServerCommand( ent - g_entities, 0, va("%c \"GAME_CLIENTNOTONSERVER\"\0", 0x65));
			return;
		}
// jpw
	} else {
//		Com_sprintf( level.voteString, sizeof( level.voteString ), "%s \"%s\"", arg1, arg2 );
//		Com_sprintf( level.voteDisplayString, sizeof( level.voteDisplayString ), "%s", level.voteString );
	}
	SV_GameSendServerCommand( ent - g_entities, 0, va("%c \"GAME_CALLEDAVOTE\x15%s\"\0", 0x65, ent->client->pers.netname));
	ent->client->pers.voteCount++;

	// start the voting, the caller autoamtically votes yes
	level.voteTime = level.time + 1000*g_voteTime->integer;
	level.voteYes = 1;
	level.voteNo = 0;

	for ( i = 0 ; i < level.maxclients ; i++ ) {
		level.clients[i].ps.eFlags &= ~EF_VOTED;
	}
	ent->client->ps.eFlags |= EF_VOTED;

	SV_SetConfigstring( CS_VOTE_TIME, va( "%i %i", level.voteTime, sv_serverid->integer) );
	SV_SetConfigstring( CS_VOTE_STRING, level.voteDisplayString );
	SV_SetConfigstring( CS_VOTE_YES, va( "%i", level.voteYes ) );
	SV_SetConfigstring( CS_VOTE_NO, va( "%i", level.voteNo ) );
}