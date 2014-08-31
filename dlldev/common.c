#define	MAX_CONSOLE_LINES	32

#define cvar_modifiedFlags_ADDR 0x1402c060
#define com_codeTimeScale_ADDR 0x88a7238
#define com_frametime_ADDR 0x88a61e0
#define com_lastError_ADDR 0x88a6220
#define com_errorEntered_ADDR 0x88a61f4
#define com_numConsoleLines_ADDR 0x88a7360
#define logfile_ADDR 0x88a6210
#define level_ADDR 0x8370440


#define level (*((level_locals_t*)(level_ADDR)))
#define com_errorEntered *((qboolean*)(com_errorEntered_ADDR))
#define com_frametime *((int*)(com_frametime_ADDR))
#define com_codeTimeScale *((int*)(com_codeTimeScale_ADDR))
#define cvar_modifiedFlags *((int*)(cvar_modifiedFlags_ADDR))
#define com_lastError ((char*)com_lastError_ADDR)

jmp_buf		*abortframe;
int		com_numConsoleLines;
char		*com_consoleLines[MAX_CONSOLE_LINES];
fileHandle_t	logfile;
fileHandle_t	adminlogfile;
fileHandle_t	reliabledump;

qboolean	loadconfigfiles; //Needed for adminlogfile to omit logging of some actions while configfiles are loaded

cvar_t* com_version;
cvar_t* com_shortversion;
cvar_t** com_playerProfile;
cvar_t* com_ansiColor;
//88e7394

//============================================================================

static char	*rd_buffer;
static int	rd_buffersize;
static void	(*rd_flush)( char *buffer );


typedef enum{
    MSG_DEFAULT,
    MSG_NA,	//Not defined
    MSG_WARNING,
    MSG_ERROR,
    MSG_NORDPRINT
}msgtype_t;


void Com_BeginRedirect (char *buffer, int buffersize, void (*flush)( char *) )
{
	if (!buffer || !buffersize || !flush)
		return;
	rd_buffer = buffer;
	rd_buffersize = buffersize;
	rd_flush = flush;

	*rd_buffer = 0;
}

void Com_EndRedirect (void)
{
	if ( rd_flush ) {
		rd_flush(rd_buffer);
	}

	rd_buffer = NULL;
	rd_buffersize = 0;
	rd_flush = NULL;
}

void Com_StopRedirect (void)
{
	rd_flush = NULL;
}

void Com_PrintMessage( int dumbIWvar, char *msg, msgtype_t type) {

	PbCapatureConsoleOutput(msg, MAXPRINTMSG);
	if(dumbIWvar == 6) return;

	Sys_EnterCriticalSection(5);

	if ( rd_buffer && type != MSG_NORDPRINT) {
		if(!rd_flush){
			Sys_LeaveCriticalSection(5);
			return;
		}
		if ((strlen (msg) + strlen(rd_buffer)) > (rd_buffersize - 1)) {
			rd_flush(rd_buffer);
			*rd_buffer = 0;
		}
		Q_strcat(rd_buffer, rd_buffersize, msg);
                // TTimo nooo .. that would defeat the purpose
		//rd_flush(rd_buffer);
		//*rd_buffer = 0;
		Sys_LeaveCriticalSection(5);
		return;
	}
	// echo to dedicated console and early console
	Sys_Print( msg );

	// logfile

	if ( com_logfile && com_logfile->integer ) {
        // TTimo: only open the qconsole.log if the filesystem is in an initialized state
        // also, avoid recursing in the qconsole.log opening (i.e. if fs_debug is on)
	    if ( !logfile && FS_Initialized()) {
			struct tm *newtime;
			time_t aclock;

			time( &aclock );
			newtime = localtime( &aclock );

			logfile = FS_FOpenFileWrite( "qconsole.log" );

			if ( com_logfile->integer > 1 && logfile ) {
				// force it to not buffer so we get valid
				// data even if we are crashing
				FS_ForceFlush(logfile);
			}
			if ( logfile ) FS_Write(va("\nLogfile opened on %s\n", asctime( newtime )), strlen(va("\nLogfile opened on %s\n", asctime( newtime ))), logfile);
	    }
	    if ( logfile && FS_Initialized()) {
	    	FS_Write(msg, strlen(msg), logfile);
	    }
	}
	Sys_LeaveCriticalSection(5);
}

/*
=============
Com_Printf

Both client and server can use this, and it will output
to the apropriate place.

A raw string should NEVER be passed as fmt, because of "%f" type crashers.
=============
*/
void QDECL Com_Printf( const char *fmt, ... ) {
	va_list		argptr;
	char		msg[MAXPRINTMSG];

	va_start (argptr,fmt);
	Q_vsnprintf (msg, sizeof(msg), fmt, argptr);
	va_end (argptr);

        Com_PrintMessage( 0, msg, MSG_DEFAULT);
}


/*
=============
Com_PrintfNoRedirect

This will not print to rcon

A raw string should NEVER be passed as fmt, because of "%f" type crashers.
=============
*/
void QDECL Com_PrintNoRedirect( const char *fmt, ... ) {
	va_list		argptr;
	char		msg[MAXPRINTMSG];

	va_start (argptr,fmt);
	Q_vsnprintf (msg, sizeof(msg), fmt, argptr);
	va_end (argptr);

        Com_PrintMessage( 0, msg, MSG_NORDPRINT);
}


/*
=============
Com_PrintWarning

Server can use this, and it will output
to the apropriate place.

A raw string should NEVER be passed as fmt, because of "%f" type crashers.
=============
*/
void QDECL Com_PrintWarning( const char *fmt, ... ) {
	va_list		argptr;
	char		msg[MAXPRINTMSG];

	memcpy(msg,"^3Warning: ", sizeof(msg));

	va_start (argptr,fmt);
	Q_vsnprintf (&msg[11], (sizeof(msg)-12), fmt, argptr);
	va_end (argptr);

        Com_PrintMessage( 0, msg, MSG_WARNING);
}

/*
=============
Com_PrintError

Server can use this, and it will output
to the apropriate place.

A raw string should NEVER be passed as fmt, because of "%f" type crashers.
=============
*/
void QDECL Com_PrintError( const char *fmt, ... ) {
	va_list		argptr;
	char		msg[MAXPRINTMSG];

	memcpy(msg,"^1Error: ", sizeof(msg));

	va_start (argptr,fmt);
	Q_vsnprintf (&msg[9], (sizeof(msg)-10), fmt, argptr);
	va_end (argptr);

        Com_PrintMessage( 0, msg, MSG_ERROR);
}

/*
================
Com_DPrintf

A Com_Printf that only shows up if the "developer" cvar is set
================
*/
void QDECL Com_DPrintf( const char *fmt, ...) {
	va_list		argptr;
	char		msg[MAXPRINTMSG];
		
	if ( !com_developer || !com_developer->integer ) {
		return;			// don't confuse non-developers with techie stuff...
	}
	
	msg[0] = '^';
	msg[1] = '2';

	va_start (argptr,fmt);	
	Q_vsnprintf (&msg[2], (sizeof(msg)-3), fmt, argptr);
	va_end (argptr);

        Com_PrintMessage( 0, msg, MSG_DEFAULT);
}

/*
================
Com_DPrintNoRedirect

A Com_Printf that only shows up if the "developer" cvar is set
This will not print to rcon
================
*/
void QDECL Com_DPrintNoRedirect( const char *fmt, ... ) {
	va_list		argptr;
	char		msg[MAXPRINTMSG];

	if ( !com_developer || !com_developer->integer ) {
		return;			// don't confuse non-developers with techie stuff...
	}
	
	msg[0] = '^';
	msg[1] = '2';

	va_start (argptr,fmt);	
	Q_vsnprintf (&msg[2], (sizeof(msg)-3), fmt, argptr);
	va_end (argptr);

        Com_PrintMessage( 0, msg, MSG_NORDPRINT);
}


/*
=============
Com_Error_f

Just throw a fatal error to
test error shutdown procedures
=============
*/
static void Com_Error_f (void) {
	if ( Cmd_Argc() > 1 ) {
		Com_Error( ERR_DROP, "Testing drop error" );
	} else {
		Com_Error( ERR_FATAL, "Testing fatal error" );
	}
}


/*
=============
Com_Freeze_f

Just freeze in place for a given number of seconds to test
error recovery
=============
*/
static void Com_Freeze_f (void) {
	float	s;
	int		start, now;

	if ( Cmd_Argc() != 2 ) {
		Com_Printf( "freeze <seconds>\n" );
		return;
	}
	s = atof( Cmd_Argv(1) );

	start = Sys_Milliseconds();

	while ( 1 ) {
		now = Sys_Milliseconds();
		if ( ( now - start ) * 0.001 > s ) {
			break;
		}
	}
}

/*
=================
Com_Crash_f

A way to force a bus error for development reasons
=================
*/
static void Com_Crash_f( void ) {
	* ( int * ) 0 = 0x12345678;
}


/*
==================
Com_RandomBytes

fills string array with len radom bytes, peferably from the OS randomizer
==================
*/
void Com_RandomBytes( byte *string, int len )
{
	int i;

	if( Sys_RandomBytes( string, len ) )
		return;

	Com_Printf( "Com_RandomBytes: using weak randomization\n" );
	for( i = 0; i < len; i++ )
		string[i] = (unsigned char)( rand() % 255 );
}


/*
============
Com_HashKey
============
*/
int Com_HashKey( char *string, int maxlen ) {
	int register hash, i;

	hash = 0;
	for ( i = 0; i < maxlen && string[i] != '\0'; i++ ) {
		hash += string[i] * ( 119 + i );
	}
	hash = ( hash ^ ( hash >> 10 ) ^ ( hash >> 20 ) );
	return hash;
}


/*
===============
Com_StartupVariable

Searches for command line parameters that are set commands.
If match is not NULL, only that cvar will be looked for.
That is necessary because cddir and basedir need to be set
before the filesystem is started, but all other sets should
be after execing the config and default.
===============
*/
void Com_StartupVariable( const char *match ) {
	int		i;
	for (i=0 ; i < com_numConsoleLines ; i++) {
		Cmd_TokenizeString( com_consoleLines[i] );

		if(!match || !strcmp(Cmd_Argv(1), match))
		{
			if ( !strcmp( Cmd_Argv(0), "set" )){
				Cvar_Set_f();
				Cmd_EndTokenizeString();
				continue;
			}else if( !strcmp( Cmd_Argv(0), "seta" ) ) {
				Cvar_SetA_f();
			}
		}
		Cmd_EndTokenizeString();
	}
}




/*
=================
Com_AddStartupCommands

Adds command line parameters as script statements
Commands are seperated by + signs

Returns qtrue if any late commands were added, which
will keep the demoloop from immediately starting
=================
*/
qboolean Com_AddStartupCommands( void ) {
	int		i;
	qboolean	added;
	char		buf[1024];
	added = qfalse;
	// quote every token, so args with semicolons can work
	for (i=0 ; i < com_numConsoleLines ; i++) {
		if ( !com_consoleLines[i] || !com_consoleLines[i][0] ) {
			continue;
		}

		// set commands already added with Com_StartupVariable
		if ( !Q_stricmpn( com_consoleLines[i], "set", 3 )) {
			continue;
		}

		added = qtrue;
		Com_sprintf(buf,sizeof(buf),"%s\n",com_consoleLines[i]);
		Cbuf_ExecuteBuffer( 0,0, buf);
	}

	return added;
}



/*
==================
Com_ParseCommandLine

Break it up into multiple console lines
==================
*/
void Com_ParseCommandLine( char *commandLine ) {
    int inq = 0;
    com_consoleLines[0] = commandLine;
    com_numConsoleLines = 1;

    while ( *commandLine ) {
        if (*commandLine == '"') {
            inq = !inq;
        }
        // look for a + seperating character
        // if commandLine came from a file, we might have real line seperators
        if ( (*commandLine == '+' && !inq) || *commandLine == '\n'  || *commandLine == '\r' ) {
            if ( com_numConsoleLines == MAX_CONSOLE_LINES ) {
                return;
            }
            com_consoleLines[com_numConsoleLines] = commandLine + 1;
            com_numConsoleLines = (com_numConsoleLines)+1;
            *commandLine = 0;
        }
        commandLine++;
    }
}



/*
=============
Com_Quit_f

Both client and server can use this, and it will
do the apropriate things.
=============
*/
void Com_Quit_f( void ) {
	// don't try to shutdown if we are in a recursive error
	Com_Printf("quitting...\n");
	Scr_Cleanup();
	Sys_EnterCriticalSection( 2 );
	GScr_Shutdown();

	if ( !com_errorEntered ) {
		// Some VMs might execute "quit" command directly,
		// which would trigger an unload of active VM error.
		// Sys_Quit will kill this process anyways, so
		// a corrupt call stack makes no difference
		SV_DemoSystemShutdown();
		Hunk_ClearTempMemory();
		Hunk_ClearTempMemoryHigh();
		SV_Shutdown("EXE_SERVERQUIT");
		Com_Close();

		if(logfile) FS_FCloseFile(logfile);
		if(adminlogfile) FS_FCloseFile(adminlogfile);
		if(reliabledump) FS_FCloseFile(reliabledump);

		FS_Shutdown(qtrue);
		FS_ShutdownIwdPureCheckReferences();
		FS_ShutdownServerIwdNames();
		FS_ShutdownServerReferencedIwds();
		FS_ShutdownServerReferencedFFs();
	}
	Sys_Quit ();
}



/*
=================
Com_Init

The games main initialization
=================
*/

void Com_Init(char* commandLine){

    int msec;
    int	qport;
    char* s;

    abortframe = Sys_GetValue(2);
    if(setjmp(*abortframe)){
        Sys_Error(va("Error during Initialization:\n%s\n", com_lastError));
    }
    Com_Printf("%s %s %s %s\n", GAME_STRING,Q3_VERSION,PLATFORM_STRING, __DATE__);

    //Init pointers used in DLL
    com_playerProfile = (cvar_t**)(0x88e7394);

    patch_assets();  //Patch several asset-limits to higher values

    //Com_InitRand();

    SL_Init();

    Swap_Init();

    Cbuf_Init();

    Cmd_Init();

    Com_ParseCommandLine(commandLine);

    Com_StartupVariable(NULL);

    Com_InitCvars();

    Cvar_Init();

    CSS_InitConstantConfigStrings();

    if(useFastfiles->integer){

        Mem_Init();

        DB_SetInitializing( qtrue );

        Com_Printf("begin $init\n");

        msec = Sys_Milliseconds();

        Mem_BeginAlloc("$init", qtrue);
    }

    FS_InitFilesystem();

    Con_InitChannels();

    LiveStorage_Init();

//    Com_InitPlayerProfiles(qfalse); //Doesn't work
    Cbuf_AddText(0, "exec default_mp.cfg\n");
    Cbuf_Execute(0,0); // Always execute after exec to prevent text buffer overflowing

    if(!useFastfiles->integer) SEH_UpdateLanguageInfo();

    Com_InitHunkMemory();

    Hunk_InitDebugMemory();

    cvar_modifiedFlags &= ~CVAR_ARCHIVE;

    com_codeTimeScale = 0x3f800000;

    if (com_developer && com_developer->integer)
    {
        Cmd_AddCommand ("error", Com_Error_f, Z_Malloc(20));
        Cmd_AddCommand ("crash", Com_Crash_f, Z_Malloc(20));
        Cmd_AddCommand ("freeze", Com_Freeze_f, Z_Malloc(20));
    }

    Cmd_AddCommand ("quit", Com_Quit_f,Z_Malloc(20));
//    Cmd_AddCommand ("writeconfig", tCom_WriteConfig_f, Z_Malloc(20));
//    Cmd_AddCommand("writedefaults", tCom_WriteDefaults_f, Z_Malloc(20));

    s = va("%s %s %s %s", GAME_STRING, Q3_VERSION, PLATFORM_STRING, __DATE__ );
    com_version = Cvar_RegisterString ("version", s, CVAR_ROM | CVAR_SERVERINFO , "Game version");
    com_shortversion = Cvar_RegisterString ("shortversion", Q3_VERSION, CVAR_ROM | CVAR_SERVERINFO , "Short game version");
    Cvar_RegisterString ("CoD4-Version by", "IceNinjaman", CVAR_ROM | CVAR_SERVERINFO , "");
    *com_playerProfile = Cvar_RegisterString ("com_playerProfile", " ", CVAR_ROM , "Player profile");
    com_ansiColor = Cvar_RegisterBool ("com_ansiColor", qtrue, CVAR_ARCHIVE , "Use AnsiColors");
    Sys_Init();

    Com_RandomBytes( (byte*)&qport, sizeof(int) );
    Netchan_Init( qport );

    Scr_InitVariables();
    Scr_Init(); //VM_Init

    Scr_Settings(com_logfile->integer || com_developer->integer ,com_developer_script->integer, com_developer->integer);

    XAnimInit();

    DObjInit();

    SV_InitBanlist();
    G_SayCensor_Init();

    SV_Init();


    NET_Init();

    com_frametime = Sys_Milliseconds();

    Com_StartupVariable(NULL);

    if(useFastfiles->integer){
        Mem_EndAlloc("$init", qtrue);
        DB_SetInitializing( qfalse );
        Com_Printf("end $init %d ms\n", Sys_Milliseconds() - msec);

        int XAssetscount;
        XZoneInfo XZoneInfoStack[6];

        XZoneInfoStack[4].fastfile = "localized_common_mp";
        XZoneInfoStack[4].loadpriority = 1;
        XZoneInfoStack[4].notknown = 0;
        XZoneInfoStack[3].fastfile = "common_mp";
        XZoneInfoStack[3].loadpriority = 4;
        XZoneInfoStack[3].notknown = 0;
        XZoneInfoStack[2].fastfile = "ui_mp";
        XZoneInfoStack[2].loadpriority = 8;
        XZoneInfoStack[2].notknown = 0;
        XZoneInfoStack[1].fastfile = "localized_code_post_gfx_mp";
        XZoneInfoStack[1].loadpriority = 0;
        XZoneInfoStack[1].notknown = 0;
        XZoneInfoStack[0].fastfile = "code_post_gfx_mp";
        XZoneInfoStack[0].loadpriority = 2;
        XZoneInfoStack[0].notknown = 0;

        if(DB_ModFileExists()){
            XAssetscount = 6;
            XZoneInfoStack[5].fastfile = "mod"; // APB: ../../mods/apb/apb
            XZoneInfoStack[5].loadpriority = 16;
            XZoneInfoStack[5].notknown = 0;
        }else{
            XAssetscount = 5;
        }
        DB_LoadXAssets(&XZoneInfoStack[0],XAssetscount,0);
    }

//    Plugin_Init();

    Com_DvarDump(6,0);

    Com_Printf("--- Common Initialization Complete ---\n");

    Cbuf_Execute( 0, 0 );

    Com_AddStartupCommands( );

    abortframe = Sys_GetValue(2);
    if(setjmp(*abortframe)){
        Sys_Error(va("Error during Initialization:\n%s\n", com_lastError));
    }
    if(com_errorEntered) Com_ErrorCleanup();


}


/*
========================================================================

EVENT LOOP

========================================================================
*/

#define MAX_QUEUED_EVENTS  256
#define MASK_QUEUED_EVENTS ( MAX_QUEUED_EVENTS - 1 )

static sysEvent_t  eventQueue[ MAX_QUEUED_EVENTS ];
static int         eventHead = 0;
static int         eventTail = 0;

/*
================
Com_QueueEvent

A time of 0 will get the current time
Ptr should either be null, or point to a block of data that can
be freed by the game later.
================
*/
void Com_QueueEvent( int time, sysEventType_t type, int value, int value2, int ptrLength, void *ptr )
{
	sysEvent_t  *ev;

	ev = &eventQueue[ eventHead & MASK_QUEUED_EVENTS ];

	if ( eventHead - eventTail >= MAX_QUEUED_EVENTS )
	{
		Com_Printf("Com_QueueEvent: overflow\n");
		// we are discarding an event, but don't leak memory
		if ( ev->evPtr )
		{
			Z_Free( ev->evPtr );
		}
		eventTail++;
	}

	eventHead++;

	if ( time == 0 )
	{
		time = Sys_Milliseconds();
	}

	ev->evTime = time;
	ev->evType = type;
	ev->evValue = value;
	ev->evValue2 = value2;
	ev->evPtrLength = ptrLength;
	ev->evPtr = ptr;
}

/*
================
Com_GetSystemEvent

================
*/
sysEvent_t Com_GetSystemEvent( void )
{
	sysEvent_t  ev;
	char        *s;

	// return if we have data

	if ( eventHead > eventTail )
	{
		eventTail++;
		return eventQueue[ ( eventTail - 1 ) & MASK_QUEUED_EVENTS ];
	}

	// check for console commands
	s = Sys_ConsoleInput();
	if ( s )
	{
		char  *b;
		int   len;

		len = strlen( s ) + 1;
		b = Z_Malloc( len );
		strcpy( b, s );
		Com_QueueEvent( 0, SE_CONSOLE, 0, 0, len, b );
	}

	// return if we have data
	if ( eventHead > eventTail )
	{
		eventTail++;
		return eventQueue[ ( eventTail - 1 ) & MASK_QUEUED_EVENTS ];
	}

	// create an empty event to return
	memset( &ev, 0, sizeof( ev ) );
	ev.evTime = Sys_Milliseconds();

	return ev;
}


/*
=================
Com_EventLoop

Returns last event time
=================
*/
int Com_EventLoop( void ) {
	sysEvent_t	ev;

	while ( 1 ) {
		ev = Com_GetSystemEvent();

		// if no more events are available
		if ( ev.evType == SE_NONE ) {
			return ev.evTime;
		}


		switch(ev.evType)
		{
			case SE_CONSOLE:
				Cbuf_AddText( 0,(char *)ev.evPtr );
				Cbuf_AddText(0,"\n");
			break;
			default:
				Com_Error( ERR_FATAL, "Com_EventLoop: bad event type %i", ev.evType );
			break;
		}

		// free any block data
		if ( ev.evPtr ) {
			Z_Free( ev.evPtr );
		}
	}

	return 0;	// never reached
}




void Com_FrameCallback(){};


char* SL_ConvertToString(short index){

    char** ptr = (char**)STRBUFFBASEPTR_ADDR;
    char* base = *ptr;
    return &base[ index*12 + 4];

}
