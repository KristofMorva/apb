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

#define MAX_DEMOFILE_HANDLES MAX_CLIENTS


static fileHandleData_t demofsh[MAX_DEMOFILE_HANDLES];


int FS_DemoWrite( const void *buffer, int len, fileHandle_t h );
fileHandle_t FS_FOpenDemoFileWrite( const char *filename );
qboolean FS_FCloseDemoFile( fileHandle_t f );
qboolean FS_DemoFileExists( const char *file );

/*
====================
SV_WriteDemoArchive

Addional demo data InfinityWards has added that contains players position and viewangle
The only intention i maybe that the player self can create a demo with higher FPS-rate than server provides
====================
*/

void SV_WriteDemoArchive(msg_t *msg, client_t *client){

	int archiveIndex;
	playerState_t *ps = SV_GameClientNum(client - svs.clients);
	vec3_t nullvec = {0, 0, 0};

	MSG_WriteByte(msg, 1);

	archiveIndex = client->demoArchiveIndex % 256;
	MSG_WriteLong(msg, archiveIndex);
	MSG_WriteVector(msg, ps->origin);

	MSG_WriteVector(msg, nullvec);
	MSG_WriteLong(msg, 0); //Velocity

	MSG_WriteLong(msg, 0);
	MSG_WriteLong(msg, ps->commandTime);
	MSG_WriteVector(msg, ps->viewangles);
	client->demoArchiveIndex++;

}



/*
====================
SV_WriteDemoMessageForClient

Dumps the current net message, prefixed by the length
====================
*/


void SV_WriteDemoMessageForClient( byte *data, int dataLen, client_t *client ){

	int len, swlen;
	byte bufData[64];
	msg_t msg;

	MSG_Init(&msg, bufData, sizeof(bufData));

	

	SV_WriteDemoArchive(&msg, client);

	MSG_WriteByte(&msg, 0);

	// write the packet sequence
	len = client->netchan.outgoingSequence;
	swlen = LittleLong( len );
	MSG_WriteLong(&msg, swlen);

	// skip the packet sequencing information
	swlen = LittleLong( dataLen );

	MSG_WriteLong(&msg, swlen);
	FS_DemoWrite( msg.data, msg.cursize, client->demofile );

	FS_DemoWrite( data, dataLen, client->demofile );
//	Com_DPrintf("Writing: %i bytes of demodata\n", dataLen+ msg.cursize);
}


/*
====================
SV_StopRecord

stop recording a demo
====================
*/
void SV_StopRecord( client_t *cl ) {
	int len;

	if ( !cl->demorecording ) {
		Com_Printf( "Not recording a demo.\n" );
		return;
	}
	// finish up
	len = -1;

	FS_DemoWrite( &len, 4, cl->demofile );
	FS_DemoWrite( &len, 4, cl->demofile );

	FS_FCloseDemoFile( cl->demofile );
	cl->demofile = 0;
	cl->demorecording = qfalse;
	Com_Printf( "Stopped demo for: %s\n", cl->name);
}

/*
==================
SV_DemoFilename
==================
*/
void SV_DemoFilename( int number, const char* basename, char *fileName ) {
	int a,b,c,d;

	if ( number < 0 || number > 9999 ) {
		Com_sprintf( fileName, MAX_OSPATH, "demo9999.tga" );
		return;
	}

	a = number / 1000;
	number -= a * 1000;
	b = number / 100;
	number -= b * 100;
	c = number / 10;
	number -= c * 10;
	d = number;

	Com_sprintf( fileName, MAX_OSPATH, "%s%i%i%i%i", basename, a, b, c, d );
}

/*
====================
SV_RecordClient

Begins recording a demo from the current position
====================
*/

void SV_RecordClient( client_t* cl, char* basename ) {
	char name[MAX_OSPATH];
	byte bufData[MAX_MSGLEN];
	msg_t msg;
	int len, compLen, swlen;
	char demoName[MAX_QPATH];

	if ( cl->demorecording ) {
		Com_Printf( "Already recording.\n" );
		return;
	}

	if ( cl->state != CS_ACTIVE ) {
		Com_Printf( "Client must be in a level to record.\n" );
		return;
	}

	int number;

	if(!basename)
	{
		basename = "demo";
	}

	// scan for a free demo name
	for ( number = 0 ; number <= 9999 ; number++ ) {
		SV_DemoFilename( number, basename, demoName );
		Com_sprintf( name, sizeof( name ), "demos/%s.dm_%d", demoName, 1 );

		if ( !FS_DemoFileExists( name ) ) {
			break;  // file doesn't exist
		}
	}

	// open the demo file

	Com_Printf( "recording to %s.\n", name );
	cl->demofile = FS_FOpenDemoFileWrite( name );
	if ( !cl->demofile ) {
		Com_Printf( "ERROR: couldn't open.\n" );
		return;
	}
	cl->demorecording = qtrue;
	Q_strncpyz( cl->demoName, demoName, sizeof( cl->demoName ) );

	// don't start saving messages until a non-delta compressed message is received
	cl->demowaiting = qtrue;

	// write out the gamestate message
	MSG_Init( &msg, bufData, sizeof( bufData ) );

	// NOTE, MRE: all server->client messages now acknowledge
	MSG_WriteLong( &msg, cl->lastClientCommand );

	SV_WriteGameState(&msg, cl);

	// write the client num
	MSG_WriteLong( &msg, cl - svs.clients );
	// write the checksum feed
	MSG_WriteLong( &msg, sv.checksumFeed );

	// finished writing the client packet
	MSG_WriteByte( &msg, svc_EOF );

	*(int32_t*)0x13f39080 = *(int32_t*)msg.data;
	compLen = 4 + MSG_WriteBitsCompress( 0, msg.data + 4 ,(byte*)0x13f39084 ,msg.cursize - 4);

	len = 0;
	FS_DemoWrite( &len, 1, cl->demofile );

	// write it to the demo file

	// write the packet sequence
	len = cl->netchan.outgoingSequence;
	swlen = LittleLong( len );
	FS_DemoWrite( &swlen, 4, cl->demofile );

	len = LittleLong( compLen );
	FS_DemoWrite( &len, 4, cl->demofile );
	FS_DemoWrite((byte*)0x13f39080, compLen, cl->demofile );
	cl->demoMaxDeltaFrames = 1;
	cl->demoDeltaFrameCount = 0;

	// the rest of the demo file will be copied from net messages
}


/*
====================
SV_DemoSystemShutdown

stop recording of all demos
====================
*/
void SV_DemoSystemShutdown( ) {

	client_t *cl;
	int i;

	for(i = 0, cl = svs.clients; i < sv_maxclients->integer; i++, cl++)
	{
		if(cl->demorecording && !cl->demowaiting)
			SV_StopRecord(cl);
	}
}




static fileHandle_t	FS_HandleForDemoFile(void) {
	int		i;

	for ( i = 1 ; i < MAX_DEMOFILE_HANDLES ; i++ ) {
		if ( demofsh[i].handleFiles.file.o == NULL ) {
			return i;
		}
	}
	Com_Error( ERR_DROP, "FS_HandleForFile: none free" );
	return 0;
}

static FILE	*FS_DemoFileForHandle( fileHandle_t f ) {
	if ( f < 0 || f > MAX_DEMOFILE_HANDLES ) {
		Com_Error( ERR_DROP, "FS_FileForHandle: out of range" );
	}
	if ( !demofsh[f].handleFiles.file.o ) {
		Com_Error( ERR_DROP, "FS_FileForHandle: NULL" );
	}
	
	return demofsh[f].handleFiles.file.o;
}


/*
================
FS_DemoFileExists

Tests if the file exists in the current gamedir, this DOES NOT
search the paths.  This is to determine if opening a file to write
(which always goes into the current gamedir) will cause any overwrites.
NOTE TTimo: this goes with FS_FOpenFileWrite for opening the file afterwards
================
*/
qboolean FS_DemoFileExists( const char *file )
{
	FILE *f;
	char *testpath;

	testpath = FS_BuildOSPath( fs_homepath->string, file, "" );
	testpath[strlen(testpath)-1] = '\0';

	f = fopen( testpath, "rb" );
	if (f) {
		fclose( f );
		return qtrue;
	}
	return qfalse;
}


/*
==============
FS_FCloseDemoFile

If the FILE pointer is an open pak file, leave it open.

For some reason, other dll's can't just cal fclose()
on files returned by FS_FOpenFile...
==============
*/
qboolean FS_FCloseDemoFile( fileHandle_t f ) {
	// we didn't find it as a pak, so close it as a unique file
	if (demofsh[f].handleFiles.file.o) {
	    fclose (demofsh[f].handleFiles.file.o);
	    Com_Memset( &demofsh[f], 0, sizeof( demofsh[f] ) );
	    return qtrue;
	}
	Com_Memset( &demofsh[f], 0, sizeof( demofsh[f] ) );
	return qfalse;
}


/*
===========
FS_FOpenDemoFileWrite

===========
*/
fileHandle_t FS_FOpenDemoFileWrite( const char *filename ) {
	char *ospath;
	fileHandle_t	f;

	if ( !fs_searchpaths ) {
		Com_Error( ERR_FATAL, "Filesystem call made without initialization" );
	}

	ospath = FS_BuildOSPath( fs_homepath->string, filename, "" );
	ospath[strlen(ospath)-1] = '\0';

	f = FS_HandleForDemoFile();
	demofsh[f].zipFile = qfalse;

	if ( fs_debug->boolean ) {
		Com_Printf( "FS_SV_FOpenDemoFileWrite: %s\n", ospath );
	}

	if( FS_CreatePath( ospath ) ) {
		return 0;
	}

	demofsh[f].handleFiles.file.o = fopen( ospath, "wb" );

	Q_strncpyz( demofsh[f].name, filename, sizeof( demofsh[f].name ) );

	demofsh[f].handleSync = qfalse;
	if (!demofsh[f].handleFiles.file.o) {
		f = 0;
	}
	return f;
}

/*
=================
FS_DemoWrite

Properly handles partial writes
=================
*/
int FS_DemoWrite( const void *buffer, int len, fileHandle_t h ) {
	int		block, remaining;
	int		written;
	byte	*buf;
	int		tries;
	FILE	*f;

	if ( !h ) {
		return 0;
	}

	f = FS_DemoFileForHandle(h);
	buf = (byte *)buffer;

	remaining = len;
	tries = 0;
	while (remaining) {
		block = remaining;
		written = fwrite (buf, 1, block, f);
		if (written == 0) {
			if (!tries) {
				tries = 1;
			} else {
				Com_Printf( "FS_DemoWrite: 0 bytes written\n" );
				return 0;
			}
		}

		if (written == -1) {
			Com_Printf( "FS_DemoWrite: -1 bytes written\n" );
			return 0;
		}

		remaining -= written;
		buf += written;
	}
	if ( demofsh[h].handleSync ) {
		fflush( f );
	}

	return len;
}
