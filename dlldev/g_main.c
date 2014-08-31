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
=============
ExitLevel

When the intermission has been exited, the server is either killed
or moved to a new level based on the "nextmap" cvar

=============
*/

void ExitLevel( void ) {
	int i;
	gclient_t *gcl;
	client_t *cl;
	extlevel.levelLoadRetries = 8;
	extlevel.LevelExitFrame = level.framenum;

	if(*g_votedMapName->string){
		if(*g_votedGametype->string)
			Cbuf_AddText( EXEC_NOW, va("set g_gametype %s; map %s; set g_votedGametype \"\"; set g_votedMapName \"\"\n", g_votedGametype->string, g_votedMapName->string));
		else
			Cbuf_AddText( EXEC_NOW, va("map %s; set g_votedMapName \"\"\n", g_votedMapName->string));
	}else{
		Cbuf_AddText( EXEC_NOW, "map_rotate\n" );
	}

	// reset all the scores so we don't enter the intermission again
	level.teamScores[TEAM_RED] = 0;
	level.teamScores[TEAM_BLUE] = 0;
	for ( i = 0 ; i < level.maxclients ; i++ ) {
		gcl = &level.clients[i];
		cl = &svs.clients[i];
		if ( gcl->pers.connected != CON_CONNECTED ) {
			continue;
		}
		gcl->pers.scoreboard.score = 0;
		// change all client states to connecting, so the early players into the
		// next level will know the others aren't done reconnecting
		if(cl->netchan.remoteAddress.type != NA_BOT)
			gcl->pers.connected = CON_CONNECTING;
	}
	G_LogPrintf( "ExitLevel: executed\n" );
}

