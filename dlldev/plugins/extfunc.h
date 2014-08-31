//typedef void (__stdcall *tSV_ConnectionlessPacket)( netadr_t, msg_t*);
//tSV_ConnectionlessPacket SV_ConnectionlessPacket = (tSV_ConnectionlessPacket)(0x8177c52);


typedef void (__stdcall *tSys_ThreadInit)( void );
tSys_ThreadInit Sys_ThreadInit = (tSys_ThreadInit)(0x81d6c00);

typedef void (__stdcall *tSys_ThreadMain)( void );
tSys_ThreadMain Sys_ThreadMain = (tSys_ThreadMain)(0x8140f5c);

typedef void (__stdcall *tCom_InitParse)( void );
tCom_InitParse Com_InitParse = (tCom_InitParse)(0x81a7a78);

typedef jmp_buf* (__stdcall *tSys_GetValue)( int );
tSys_GetValue Sys_GetValue = (tSys_GetValue)(0x8140e9c);

typedef void (__stdcall *tSys_Error)( const char *error);
tSys_Error Sys_Error = (tSys_Error)(0x81d5a14);

typedef qboolean (__stdcall *tPbServerInitialize)(void);
tPbServerInitialize PbServerInitialize = (tPbServerInitialize)(0x810ecde);

typedef void (__stdcall *tPbServerProcessEvents)(void);
tPbServerProcessEvents PbServerProcessEvents = (tPbServerProcessEvents)(0x810ef08);

typedef const char* (__stdcall *tPbAuthClient)( const char* NETAdrString, qboolean cl_punkbuster, const char* pbguid);
tPbAuthClient PbAuthClient = (tPbAuthClient)(0x810e47a);

typedef void (__stdcall *tPbPassConnectString)( const char* NETAdrString, const char* connectstring);
tPbPassConnectString PbPassConnectString = (tPbPassConnectString)(0x810e47a);

typedef void (__stdcall *tPbSvAddEvent)( int event_type, int clientnum, int sizeofstring, char* string);
tPbSvAddEvent PbSvAddEvent = (tPbSvAddEvent)(0x810ea20);

typedef void (__stdcall *tCom_Frame)(void);
tCom_Frame Com_Frame = (tCom_Frame)(0x8123f66);

typedef void (__stdcall *tSL_Init)(void);
tSL_Init SL_Init = (tSL_Init)(0x8150928);

typedef void (__stdcall *tSwap_Init)(void);
tSwap_Init Swap_Init = (tSwap_Init)(0x81aa7b6);

typedef void (__stdcall *tCbuf_Init)(void);
tCbuf_Init Cbuf_Init = (tCbuf_Init)(0x81110bc);

typedef void (__stdcall *tCmd_Init)(void);
tCmd_Init Cmd_Init = (tCmd_Init)(0x8111730);

typedef void (__stdcall *tCom_InitCvars)(void);
tCom_InitCvars Com_InitCvars = (tCom_InitCvars)(0x8121cb6);

typedef void (__stdcall *tCSS_InitConstantConfigStrings)(void);
tCSS_InitConstantConfigStrings CSS_InitConstantConfigStrings = (tCSS_InitConstantConfigStrings)(0x8185a72);

typedef void (__stdcall *tMem_Init)(void);
tMem_Init Mem_Init = (tMem_Init)(0x81a75e6);

typedef void (__stdcall *tDB_SetInitializing)(qboolean);
tDB_SetInitializing DB_SetInitializing = (tDB_SetInitializing)(0x820337c);

typedef int (__stdcall *tSys_Milliseconds)(void);
tSys_Milliseconds Sys_Milliseconds = (tSys_Milliseconds)(0x81d6fca);

typedef void (__stdcall *tMem_BeginAlloc)(const char*, qboolean);
tMem_BeginAlloc Mem_BeginAlloc = (tMem_BeginAlloc)(0x81a74d0);

typedef void (__stdcall *tFS_InitFilesystem)(void);
tFS_InitFilesystem FS_InitFilesystem = (tFS_InitFilesystem)(0x818e980);

typedef void (__stdcall *tCon_InitChannels)(void);
tCon_InitChannels Con_InitChannels = (tCon_InitChannels)(0x82096be);

typedef void (__stdcall *tLiveStorage_Init)(void);
tLiveStorage_Init LiveStorage_Init = (tLiveStorage_Init)(0x81d77ce);

typedef void (__stdcall *tCom_InitPlayerProfiles)(qboolean);
tCom_InitPlayerProfiles Com_InitPlayerProfiles = (tCom_InitPlayerProfiles)(0x81d77ce);

typedef void (__stdcall *tCbuf_Execute)(int, int);
tCbuf_Execute Cbuf_Execute = (tCbuf_Execute)(0x8111f3c);

typedef void (__stdcall *tCbuf_ExecuteBuffer)(int, int, char* buf);
tCbuf_ExecuteBuffer Cbuf_ExecuteBuffer = (tCbuf_ExecuteBuffer)(0x81120ae);

typedef void (__stdcall *tCbuf_AddText)(int dummy, const char* text);
tCbuf_AddText Cbuf_AddText = (tCbuf_AddText)(0x8110ff8);

typedef void (__stdcall *tSEH_UpdateLanguageInfo)(void);
tSEH_UpdateLanguageInfo SEH_UpdateLanguageInfo = (tSEH_UpdateLanguageInfo)(0x8180432);

typedef void (__stdcall *tCom_InitHunkMemory)(void);
tCom_InitHunkMemory Com_InitHunkMemory = (tCom_InitHunkMemory)(0x8197174);

typedef void (__stdcall *tHunk_InitDebugMemory)(void);
tHunk_InitDebugMemory Hunk_InitDebugMemory = (tHunk_InitDebugMemory)(0x819752a);

typedef void (__stdcall *tCom_ServerPacketEvent)(void);
tCom_ServerPacketEvent Com_ServerPacketEvent = (tCom_ServerPacketEvent)(0x8122166);

typedef void (__stdcall *tCmd_AddCommand)(const char* cmdname, xcommand_t function, char *staticmemory[20]);
tCmd_AddCommand Cmd_AddCommand = (tCmd_AddCommand)(0x81116b4);

typedef void (__stdcall *tCom_WriteConfig_f)(void);
tCom_WriteConfig_f Com_WriteConfig_f = (tCom_WriteConfig_f)(0x8122e82);

typedef void (__stdcall *tCom_WriteDefaults_f)(void);
tCom_WriteDefaults_f Com_WriteDefaults_f = (tCom_WriteDefaults_f)(0x8123bae);

typedef void (__stdcall *tSys_Init)(void);
tSys_Init Sys_Init = (tSys_Init)(0x81d4f04);

//Netchan and MSG
typedef void (__stdcall *tNetchan_Init)(short int qport);
tNetchan_Init Netchan_Init = (tNetchan_Init)(0x813b680);

//typedef qboolean (__stdcall *tNetchan_Process)(netchan_t* , msg_t*);
//tNetchan_Process Netchan_Process = (tNetchan_Process)(0x813c318);

typedef void (__stdcall *tSV_Netchan_Decode)(client_t*, unsigned char* data, int remaining);
tSV_Netchan_Decode SV_Netchan_Decode = (tSV_Netchan_Decode)(0x8178c60);

typedef void (__stdcall *tSV_Netchan_AddOOBProfilePacket)( int );
tSV_Netchan_AddOOBProfilePacket SV_Netchan_AddOOBProfilePacket = (tSV_Netchan_AddOOBProfilePacket)(0x8178d64);

typedef char* (__stdcall *tMSG_Init)( msg_t *buf, byte *data, int length);
tMSG_Init MSG_Init = (tMSG_Init)(0x8131200);

typedef char* (__stdcall *tMSG_ReadString)( msg_t *msg);
tMSG_ReadString MSG_ReadString = (tMSG_ReadString)(0x81310d6);

typedef char* (__stdcall *tMSG_ReadStringLine)( msg_t *msg);
tMSG_ReadStringLine MSG_ReadStringLine = (tMSG_ReadStringLine)(0x8130f92);

typedef int (__stdcall *tMSG_ReadLong)( msg_t *msg);
tMSG_ReadLong MSG_ReadLong = (tMSG_ReadLong)(0x813099a);

typedef int (__stdcall *tMSG_ReadShort)( msg_t *msg);
tMSG_ReadShort MSG_ReadShort = (tMSG_ReadShort)(0x8130920);

typedef int (__stdcall *tMSG_ReadByte)( msg_t *msg);
tMSG_ReadByte MSG_ReadByte = (tMSG_ReadByte)(0x81308d8);

typedef int (__stdcall *tMSG_ReadData)( msg_t *msg, const void* data, int length);
tMSG_ReadData MSG_ReadData = (tMSG_ReadData)(0x8130bc2);

typedef void (__stdcall *tMSG_BeginReading)( msg_t *msg);
tMSG_BeginReading MSG_BeginReading = (tMSG_BeginReading)(0x81305c6);

typedef void (__stdcall *tMSG_WriteLong)( msg_t *msg, int c);
tMSG_WriteLong MSG_WriteLong = (tMSG_WriteLong)(0x81308aa);

typedef void (__stdcall *tMSG_WriteShort)( msg_t *msg, int c);
tMSG_WriteShort MSG_WriteShort = (tMSG_WriteShort)(0x813087c);

typedef void (__stdcall *tMSG_WriteData)( msg_t *msg, const void* data, int length);
tMSG_WriteData MSG_WriteData = (tMSG_WriteData)(0x8130c88);

typedef void (__stdcall *tSV_ExecuteClientMessage)(client_t*, msg_t*);
tSV_ExecuteClientMessage SV_ExecuteClientMessage = (tSV_ExecuteClientMessage)(0x8172990);

typedef void (__stdcall *tScr_InitVariables)(void);			//VM
tScr_InitVariables Scr_InitVariables = (tScr_InitVariables)(0x815288a);

typedef void (__stdcall *tScr_Init)(void);			//VM_Init
tScr_Init Scr_Init = (tScr_Init)(0x815d8e2);

typedef void (__stdcall *tScr_Settings)(int, int);
tScr_Settings Scr_Settings = (tScr_Settings)(0x815cf90);

typedef void (__stdcall *tXAnimInit)(void);
tXAnimInit XAnimInit = (tXAnimInit)(0x81b649c);

typedef void (__stdcall *tDObjInit)(void);
tDObjInit DObjInit = (tDObjInit)(0x81acb00);

typedef void (__stdcall *tSV_ResetSekeletonCache)(void);
tSV_ResetSekeletonCache SV_ResetSekeletonCache = (tSV_ResetSekeletonCache)(0x817c602);

typedef void (__stdcall *tSV_Init)(void);
tSV_Init SV_Init = (tSV_Init)(0x817306c);

//typedef void (__stdcall *tNet_Init)(void);
//tNet_Init Net_Init = (tNet_Init)(0x81d69b6);

typedef qboolean (__stdcall *tDB_ModFileExists)(void);
tDB_ModFileExists DB_ModFileExists = (tDB_ModFileExists)(0x8204470);

typedef void (__stdcall *tDB_LoadXAssets)(XZoneInfo*, unsigned int assetscount, int);
tDB_LoadXAssets DB_LoadXAssets = (tDB_LoadXAssets)(0x8205e86);

typedef void (__stdcall *tCom_DvarDump)(int, int);
tCom_DvarDump Com_DvarDump = (tCom_DvarDump)(0x8126764);

typedef void (__stdcall *tMem_EndAlloc)(const char*, int);
tMem_EndAlloc Mem_EndAlloc = (tMem_EndAlloc)(0x81a750a);

typedef void (__stdcall *tCom_ErrorCleanup)(void);
tCom_ErrorCleanup Com_ErrorCleanup = (tCom_ErrorCleanup)(0x8123c86);

typedef void (__stdcall *tScr_Cleanup)(void);
tScr_Cleanup Scr_Cleanup = (tScr_Cleanup)(0x815cf84);

typedef void (__stdcall *tSys_EnterCriticalSection)(int);
tSys_EnterCriticalSection Sys_EnterCriticalSection = (tSys_EnterCriticalSection)(0x81d6be4);

typedef void (__stdcall *tSys_LeaveCriticalSection)(int);
tSys_LeaveCriticalSection Sys_LeaveCriticalSection = (tSys_LeaveCriticalSection)(0x81d6bc8);

typedef void (__stdcall *tGScr_Shutdown)(void);
tGScr_Shutdown GScr_Shutdown = (tGScr_Shutdown)(0x80bf610);

typedef void (__stdcall *tHunk_ClearTempMemory)(void);
tHunk_ClearTempMemory Hunk_ClearTempMemory = (tHunk_ClearTempMemory)(0x81968a8);

typedef void (__stdcall *tHunk_ClearTempMemoryHigh)(void);
tHunk_ClearTempMemoryHigh Hunk_ClearTempMemoryHigh = (tHunk_ClearTempMemoryHigh)(0x81968b8);

typedef void (__stdcall *tSV_Shutdown)(const char* reason);
tSV_Shutdown SV_Shutdown = (tSV_Shutdown)(0x817452e);

typedef void (__stdcall *tCom_Close)(void);
tCom_Close Com_Close = (tCom_Close)(0x8121b82);

typedef void (__stdcall *tSV_UpdateLastTimeMasterServerCommunicated)(netadr_t from);
tSV_UpdateLastTimeMasterServerCommunicated SV_UpdateLastTimeMasterServerCommunicated = (tSV_UpdateLastTimeMasterServerCommunicated)(0x816f0a6);

typedef void (__stdcall *tFS_Shutdown)(qboolean);
tFS_Shutdown FS_Shutdown = (tFS_Shutdown)(0x818733a);

typedef void (__stdcall *tFS_ShutdownIwdPureCheckReferences)(void);
tFS_ShutdownIwdPureCheckReferences FS_ShutdownIwdPureCheckReferences = (tFS_ShutdownIwdPureCheckReferences)(0x81866b6);

typedef void (__stdcall *tFS_ShutdownServerIwdNames)(void);
tFS_ShutdownServerIwdNames FS_ShutdownServerIwdNames = (tFS_ShutdownServerIwdNames)(0x8186cfe);

typedef void (__stdcall *tFS_ShutdownServerReferencedIwds)(void);
tFS_ShutdownServerReferencedIwds FS_ShutdownServerReferencedIwds = (tFS_ShutdownServerReferencedIwds)(0x818789c);

typedef void (__stdcall *tFS_ShutdownServerReferencedFFs)(void);
tFS_ShutdownServerReferencedFFs FS_ShutdownServerReferencedFFs = (tFS_ShutdownServerReferencedFFs)(0x8187850);

typedef void (__stdcall *tG_LogPrintf)( const char *text);
tG_LogPrintf G_LogPrintf = (tG_LogPrintf)(0x80b43c4);

typedef void (QDECL *tCom_Error)( int level, const char *error, ...);
tCom_Error Com_Error = (tCom_Error)(0x812257c);

//typedef void (__stdcall *tSys_SendPacket)( int, const void*, netadr_t);
//tSys_SendPacket Sys_SendPacket = (tSys_SendPacket)(0x81d6248);

//typedef qboolean (__stdcall *tSys_GetPacket)( netadr_t*, msg_t*);
//tSys_GetPacket Sys_GetPacket = (tSys_GetPacket)(0x81d6354);

//typedef qboolean (__stdcall *tNET_StringToAdr)( const char*, netadr_t* );
//tNET_StringToAdr NET_StringToAdr = (tNET_StringToAdr)(0x813b1e8);

typedef qboolean (__regparm1 *tIs_Banned)(const char* guid);
tIs_Banned Is_Banned = (tIs_Banned)(0x816ece4);

typedef void (__stdcall *tSV_GameSendServerCommand)(int clientnum, int svscmd_type, const char *text);
tSV_GameSendServerCommand SV_GameSendServerCommand = (tSV_GameSendServerCommand)(0x817ce42);

typedef void (__stdcall *tSV_SetConfigstring)(int index, const char *text);
tSV_SetConfigstring SV_SetConfigstring = (tSV_SetConfigstring)(0x8173fda);

typedef void (__stdcall *tSV_AddServerCommand)(client_t *client,int unkownzeroorone, const char *);
tSV_AddServerCommand SV_AddServerCommand = (tSV_AddServerCommand)(0x817664c);

//typedef qboolean (__stdcall *tSys_IsLANAddress)(netadr_t adr);
//tSys_IsLANAddress Sys_IsLANAddress = (tSys_IsLANAddress)(0x81d60f8);

typedef void (__stdcall *tSV_DropClient)(client_t* drop, const char* reason);
tSV_DropClient SV_DropClient = (tSV_DropClient)(0x8170a26);

typedef qboolean (__stdcall *tSV_BanClient)( unsigned int *clientstatusptr);
tSV_BanClient SV_BanClient = (tSV_BanClient)(0x8171410);



typedef void (__stdcall *tCmd_TokenizeString)(const char* string);
tCmd_TokenizeString Cmd_TokenizeString = (tCmd_TokenizeString)(0x811142c);

typedef void (__stdcall *tSV_Cmd_TokenizeString)(const char* string);
tSV_Cmd_TokenizeString SV_Cmd_TokenizeString = (tSV_Cmd_TokenizeString)(0x811139c);

typedef void (__stdcall *tCmd_EndTokenizeString)();
tCmd_EndTokenizeString Cmd_EndTokenizeString = (tCmd_EndTokenizeString)(0x8110d54);

typedef void (__stdcall *tSV_Cmd_EndTokenizeString)();
tSV_Cmd_EndTokenizeString SV_Cmd_EndTokenizeString = (tSV_Cmd_EndTokenizeString)(0x8110d8c);



typedef void (__stdcall *tCmd_AddCmd)( const char* cmdname, xcommand_t function, char *memory); //wtf for what IW ?
tCmd_AddCmd Cmd_AddCmd = (tCmd_AddCmd)(0x8110ec2);

typedef void (__stdcall *tCmd_PrefCmd)( const char* cmdname, int *ptrtoquitestrangefunction, char *memory); //wtf for what IW ?
tCmd_PrefCmd Cmd_PrefCmd = (tCmd_PrefCmd)(0x81116b4);

typedef void (__stdcall *tCmd_tellsay)();
tCmd_tellsay Cmd_tellsay = (tCmd_tellsay)(0x816d4ce);

typedef sharedEntity_t* (__stdcall *tSV_GentityNum)(int clnum);
tSV_GentityNum SV_GentityNum = (tSV_GentityNum)(0x817c586);

typedef void (__stdcall *tSV_FreeClientScriptId)(client_t *cl);
tSV_FreeClientScriptId SV_FreeClientScriptId = (tSV_FreeClientScriptId)(0x8175c5e);

//typedef void (__stdcall *tSV_UserinfoChanged)(client_t *cl);
//tSV_UserinfoChanged SV_UserinfoChanged = (tSV_UserinfoChanged)(0x81703d6);


typedef short (__stdcall *tScr_AllocArray)();
tScr_AllocArray Scr_AllocArray = (tScr_AllocArray)(0x8153cca);

//Check for ban or PunkBuster is turned on at client

typedef const char* (__stdcall *tClientConnect)(int clnum, short clscriptid);  //Something simular to VM_Call
tClientConnect ClientConnect = (tClientConnect)(0x80a83d4);

//typedef void (__stdcall *tSV_ReceiveStats)(netadr_t from, msg_t *msg);
//tSV_ReceiveStats SV_ReceiveStats = (tSV_ReceiveStats)(0x816ef32);

typedef void (__stdcall *tG_Say)(gentity_t *ent, gentity_t *other, int mode, const char *message);
tG_Say G_Say = (tG_Say)(0x80ae962);
/*
typedef void (__stdcall *tCom_BeginRedirect)(char *buffer, int buffersize, void ( *flush )( char* ) );
tCom_BeginRedirect Com_BeginRedirect = (tCom_BeginRedirect)(0x81218a0);

typedef void (__stdcall *tCom_EndRedirect)();
tCom_EndRedirect Com_EndRedirect = (tCom_EndRedirect)(0x81218ce);
*/

typedef void (__stdcall *tPbCapatureConsoleOutput)(char *msg, int size);
tPbCapatureConsoleOutput PbCapatureConsoleOutput = (tPbCapatureConsoleOutput)(0x810e66a);

typedef void (__stdcall *tCmd_ExecuteSingleCommand)(int unk, int unk2, const char *cmd );
tCmd_ExecuteSingleCommand Cmd_ExecuteSingleCommand = (tCmd_ExecuteSingleCommand)(0x8111bea);

typedef void (__stdcall *tPbServerForceProcess)();
tPbServerForceProcess PbServerForceProcess = (tPbServerForceProcess)(0x810ee36);


qboolean isQuerylimited(netadr_t from){
qboolean al;
    __asm__ (
	"push   %%ecx				\n\t"
	"mov    0x13ed89dc,%%eax		\n\t"
	"mov    0x0c(%%eax),%%edx		\n\t"
	"lea    0x08(%%ebp),%%eax		\n\t"
	"mov	$0x8175f94,%%ecx		\n\t"
	"call   *%%ecx				\n\t"
	"pop    %%ecx				\n\t"
	:"=al"(al)
	);
	return al;
}


typedef void* (__stdcall *tHunk_AllocateTempMemory)(int size);
tHunk_AllocateTempMemory Hunk_AllocateTempMemory = (tHunk_AllocateTempMemory)(0x8196fea);

typedef void (__stdcall *tHunk_FreeTempMemory)(void *buffer);
tHunk_FreeTempMemory Hunk_FreeTempMemory = (tHunk_FreeTempMemory)(0x81969d4);

typedef void* (__stdcall *tZ_Malloc)( int size);
tZ_Malloc Z_Malloc = (tZ_Malloc)(0x8196d6e);

#define Z_Free free

typedef int (__stdcall *tCom_Filter)( char* filter, char *name, int casesensitive);
tCom_Filter Com_Filter = (tCom_Filter)(0x819837e);


/*typedef cvar_t* (__stdcall *tCvar_SetBool)(cvar_bool_t *var_name,int var_value);
tCvar_SetBool Cvar_SetBool = (tCvar_SetBool)(0x81a20c4); Does not work like expected !
*/

//G_Say 80ae962