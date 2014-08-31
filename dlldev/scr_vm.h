#define SCRSTRUCT_ADDR 0x895bf08

//Real types unknown

typedef byte PrecacheEntry[8192];
typedef unsigned int sval_u;

/**************** Additional *************************/

typedef enum{
    SCR_CB_NEW_SAY,
    SCR_CB_NEW_SEQMSG,
    SCR_CB_NEW_SEQPLAYERMSG
}script_CallBacks_new_t;

int script_CallBacks_new[8];
qboolean say_forwardAll;


typedef struct{
	char lastCommand[32];
	int lastTicket;
	char recvData[MAX_TOKEN_CHARS];
	char sendData[MAX_TOKEN_CHARS];
}scrMasterCommBuff_t;

scrMasterCommBuff_t scrCommBuff;



void QDECL Scr_PrintScriptRuntimeWarning(const char* fmt,...);


typedef void (__stdcall *tScr_InitVariables)(void);			//VM
tScr_InitVariables Scr_InitVariables = (tScr_InitVariables)(0x815288a);

typedef void (__stdcall *tScr_Init)(void);			//VM_Init
tScr_Init Scr_Init = (tScr_Init)(0x815d8e2);

typedef void (__stdcall *tScr_Settings)(int, int, int);
tScr_Settings Scr_Settings = (tScr_Settings)(0x815cf90);

typedef void (__stdcall *tScr_AddEntity)(sharedEntity_t* ent);
tScr_AddEntity Scr_AddEntity = (tScr_AddEntity)(0x80c7770);

typedef void (__stdcall *tScr_Cleanup)(void);
tScr_Cleanup Scr_Cleanup = (tScr_Cleanup)(0x815cf84);

typedef void (__stdcall *tGScr_Shutdown)(void);
tGScr_Shutdown GScr_Shutdown = (tGScr_Shutdown)(0x80bf610);

typedef short (__stdcall *tScr_AllocArray)();
tScr_AllocArray Scr_AllocArray = (tScr_AllocArray)(0x8153cca);

typedef int (__stdcall *tScr_GetNumParam)( void );
tScr_GetNumParam Scr_GetNumParam = (tScr_GetNumParam)(0x815d01e);

typedef int (__stdcall *tScr_GetInt)( unsigned int );
tScr_GetInt Scr_GetInt = (tScr_GetInt)(0x8160fee);

typedef float (__stdcall *tScr_GetFloat)( unsigned int );
tScr_GetFloat Scr_GetFloat = (tScr_GetFloat)(0x816094c);

typedef char* (__stdcall *tScr_GetString)( unsigned int );
tScr_GetString Scr_GetString = (tScr_GetString)(0x8160932);


//Not known what it does, Not a valid return value
//typedef const char* (__stdcall *tScr_GetConstString)( unsigned int );
//tScr_GetConstString Scr_GetConstString = (tScr_GetConstString)(0x816074c);

typedef unsigned int (__stdcall *tScr_GetType)( unsigned int );
tScr_GetType Scr_GetType = (tScr_GetType)(0x815f7c8);

typedef void (__stdcall *tScr_GetVector)( unsigned int, vec3_t* );
tScr_GetVector Scr_GetVector = (tScr_GetVector)(0x815ffe6);

typedef void (__stdcall *tScr_Error)( const char *string);
tScr_Error Scr_Error = (tScr_Error)(0x815e9f4);

typedef void (__stdcall *tScr_ObjectError)( const char *string);
tScr_ObjectError Scr_ObjectError = (tScr_ObjectError)(0x815f134);

typedef void (__stdcall *tScr_AddInt)(int value);
tScr_AddInt Scr_AddInt = (tScr_AddInt)(0x815f01a);

typedef void (__stdcall *tScr_AddFloat)(float);
tScr_AddFloat Scr_AddFloat = (tScr_AddFloat)(0x815ef9a);

typedef void (__stdcall *tScr_AddBool)(qboolean);
tScr_AddBool Scr_AddBool = (tScr_AddBool)(0x815eac6);

typedef void (__stdcall *tScr_AddString)(const char *string);
tScr_AddString Scr_AddString = (tScr_AddString)(0x815ec68);

typedef void (__stdcall *tScr_AddUndefined)(void);
tScr_AddUndefined Scr_AddUndefined = (tScr_AddUndefined)(0x815eea2);

typedef void (__stdcall *tScr_AddArray)( void );
tScr_AddArray Scr_AddArray = (tScr_AddArray)(0x815d5c0);

typedef void (__stdcall *tScr_MakeArray)( void );
tScr_MakeArray Scr_MakeArray = (tScr_MakeArray)(0x815ed8a);

typedef void (__stdcall *tScr_Notify)( gentity_t*, unsigned short, unsigned int);
tScr_Notify Scr_Notify = (tScr_Notify)(0x80c7604);

typedef void (__stdcall *tScr_NotifyNum)( int, unsigned int, unsigned int, unsigned int);
tScr_NotifyNum Scr_NotifyNum = (tScr_NotifyNum)(0x815e762);

/*Not working :(
typedef void (__stdcall *tScr_PrintPrevCodePos)( int printDest, const char* unk, qboolean unk2 );
tScr_PrintPrevCodePos Scr_PrintPrevCodePos = (tScr_PrintPrevCodePos)(0x814ef6e);
*/

typedef int (__stdcall *tScr_GetFunctionHandle)( const char* scriptName, const char* labelName);
tScr_GetFunctionHandle Scr_GetFunctionHandle = (tScr_GetFunctionHandle)(0x814c1b4);

typedef short (__stdcall *tScr_ExecEntThread)( gentity_t* ent, int callbackHook, unsigned int numArgs);
tScr_ExecEntThread Scr_ExecEntThread = (tScr_ExecEntThread)(0x80c765c);

typedef short (__stdcall *tScr_ExecThread)( int callbackHook, unsigned int numArgs);
tScr_ExecThread Scr_ExecThread = (tScr_ExecThread)(0x8165032);

typedef void (__stdcall *tScr_FreeThread)( short threadId);
tScr_FreeThread Scr_FreeThread = (tScr_FreeThread)(0x815d062);

typedef unsigned int (__stdcall *tScr_CreateCanonicalFilename)( const char* name );
tScr_CreateCanonicalFilename Scr_CreateCanonicalFilename = (tScr_CreateCanonicalFilename)(0x81516ee);
//Unknown real returntype
typedef unsigned int (__stdcall *tFindVariable)( unsigned int, unsigned int );
tFindVariable FindVariable = (tFindVariable)(0x81542d4);

typedef void (__stdcall *tSL_RemoveRefToString)( unsigned int );
tSL_RemoveRefToString SL_RemoveRefToString = (tSL_RemoveRefToString)(0x8150e24);

typedef unsigned int (__stdcall *tFindObject)( unsigned int );
tFindObject FindObject = (tFindObject)(0x8152294);

typedef unsigned int (__stdcall *tGetNewVariable)( unsigned int, unsigned int );
tGetNewVariable GetNewVariable = (tGetNewVariable)(0x81545ce);

//typedef const char* (__stdcall *tSL_ConvertToString)( unsigned int );
//tSL_ConvertToString SL_ConvertToString = (tSL_ConvertToString)(0x8150340);

typedef void * (__stdcall *tTempMalloc)( int );
tTempMalloc TempMalloc = (tTempMalloc)(0x8151dce);

typedef void (__stdcall *tScriptParse)( sval_u* , byte);
tScriptParse ScriptParse = (tScriptParse)(0x816b5da);

typedef unsigned int (__stdcall *tGetObjectA)( unsigned int );
tGetObjectA GetObjectA = (tGetObjectA)(0x8154046);

typedef unsigned int (__stdcall *tGetVariable)( unsigned int, unsigned int );
tGetVariable GetVariable = (tGetVariable)(0x815540a);

typedef void (__stdcall *tScriptCompile)( sval_u, unsigned int, unsigned int, PrecacheEntry*, int);
tScriptCompile ScriptCompile = (tScriptCompile)(0x81491d8);

typedef void* (__stdcall *tScr_AddSourceBuffer)( const char*, const char*, const char*, byte );
tScr_AddSourceBuffer Scr_AddSourceBuffer = (tScr_AddSourceBuffer)(0x814fbac);

typedef void (__stdcall *tScr_InitAllocNode)( void );
tScr_InitAllocNode Scr_InitAllocNode = (tScr_InitAllocNode)(0x814fea6);

typedef void (__stdcall *tScr_BeginLoadScripts)( void );
tScr_BeginLoadScripts Scr_BeginLoadScripts = (tScr_BeginLoadScripts)(0x814c266);

typedef void (__stdcall *tScr_SetClassMap)( unsigned int );
tScr_SetClassMap Scr_SetClassMap = (tScr_SetClassMap)(0x8153a3a);

typedef void (__stdcall *tGScr_AddFieldsForEntity)( void );
tGScr_AddFieldsForEntity GScr_AddFieldsForEntity = (tGScr_AddFieldsForEntity)(0x80c7808);

typedef void (__stdcall *tGScr_AddFieldsForHudElems)( void );
tGScr_AddFieldsForHudElems GScr_AddFieldsForHudElems = (tGScr_AddFieldsForHudElems)(0x808db80);

typedef void (__stdcall *tGScr_AddFieldsForRadiant)( void );
tGScr_AddFieldsForRadiant GScr_AddFieldsForRadiant = (tGScr_AddFieldsForRadiant)(0x80c77ec);

typedef void (__stdcall *tScr_EndLoadScripts)( void );
tScr_EndLoadScripts Scr_EndLoadScripts = (tScr_EndLoadScripts)(0x814bcee);

qboolean Scr_PlayerSay(gentity_t*, const char* text);

void* Scr_GetFunction(char** v_functionName, qboolean* v_developer);

void* Player_GetMethod(char** v_functionName);

//int GScr_LoadScriptAndLabel(const char* scriptName, const char* labelName, qboolean mandatory );

void GScr_LoadGameTypeScript(void);

unsigned int Scr_LoadScript(const char* scriptname, PrecacheEntry *precache, int iarg_02);

void QDECL Scr_PrintScriptRuntimeWarning(const char *fmt, ...);

qboolean Scr_ExecuteMasterResponse(char* s);