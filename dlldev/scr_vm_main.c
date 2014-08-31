typedef struct{
    char* name;
    xfunction_t offset;
    qboolean developer;
}v_function_t;


#define G_SCR_DATA_ADDR (void*)0x8583ba0

v_function_t virtual_functions[ ] = {
	{"createprintchannel", (void*)0x80bf832, 0},
	{"setprintchannel", (void*)0x80bf75c, 0},
	{"print", (void*)0x80bf706, 1},
	{"println", (void*)0x80c267e, 1},
	{"iprintln", (void*)0x80c2b8a, 0},
	{"iprintlnbold", (void*)0x80c2c14, 0},
	{"print3d", (void*)0x80c0c7e, 0},
	{"line", (void*)0x80bac00, 1},
	{"logstring", (void*)0x80bac06, 0},
	{"getent", (void*)0x80c7c72, 0},
	{"getentarray", (void*)0x80c7b44, 0},
	{"spawn", (void*)0x80bf638, 0},
	{"spawnplane", (void*)0x80c0fde, 0},
	{"spawnturret", (void*)0x80c0f52, 0},
	{"precacheturret", (void*)0x80bcd46, 0},
	{"spawnstruct", (void*)0x815f09a, 0},
	{"spawnhelicopter", (void*)0x80c0e54, 0},
	{"assert", (void*)0x80bb0fc, 1},
	{"assertex", (void*)0x80bb2e0, 1},
	{"assertmsg", (void*)0x80bb2b4, 1},
	{"isdefined", (void*)0x80bbf2c, 0},
	{"isstring", (void*)0x80bbf06, 0},
	{"isalive", (void*)0x80bbeaa, 0},
	{"getdvar", (void*)0x80bf5ec, 0},
	{"getdvarint", (void*)0x80bf5a8, 0},
	{"getdvarfloat", (void*)0x80bf56c, 0},
	{"setdvar", (void*)0x80c07ce, 0},
	{"gettime", (void*)0x80bb514, 0},
	{"getentbynum", (void*)0x80bbf96, 0},
	{"getweaponmodel", (void*)0x80bf490, 0},
	{"getanimlength", (void*)0x80bf416, 0},
	{"animhasnotetrack", (void*)0x80bf3aa, 0},
	{"getnotetracktimes", (void*)0x80bf346, 0},
	{"getbrushmodelcenter", (void*)0x80c199a, 0},
	{"objective_add", (void*)0x80c2234, 0},
	{"objective_delete", (void*)0x80c1da4, 0},
	{"objective_state", (void*)0x80c210a, 0},
	{"objective_icon", (void*)0x80be226, 0},
	{"objective_position", (void*)0x80c17ca, 0},
	{"objective_onentity", (void*)0x80c1716, 0},
	{"objective_current", (void*)0x80bef76, 0},
	{"missile_createattractorent", (void*)0x8093486, 0},
	{"missile_createattractororigin", (void*)0x8096c28, 0},
	{"missile_createrepulsorent", (void*)0x8096b5c, 0},
	{"missile_createrepulsororigin", (void*)0x8096a80, 0},
	{"missile_deleteattractor", (void*)0x80933b0, 0},
	{"bullettrace", (void*)0x80c65fa, 0},
	{"bullettracepassed", (void*)0x80bee92, 0},
	{"sighttracepassed", (void*)0x80c0198, 0},
	{"physicstrace", (void*)0x80be7b2, 0},
	{"playerphysicstrace", (void*)0x80c1e6a, 0},
	{"getmovedelta", (void*)0x80bec78, 0},
	{"getangledelta", (void*)0x80bed82, 0},
	{"getnorthyaw", (void*)0x80c1f0e, 0},
	{"randomint", (void*)0x80bec22, 0},
	{"randomfloat", (void*)0x80beb8a, 0},
	{"randomintrange", (void*)0x80bebb6, 0},
	{"randomfloatrange", (void*)0x80beb12, 0},
	{"sin", (void*)0x80beae6, 0},
	{"cos", (void*)0x80beaba, 0},
	{"tan", (void*)0x80bda00, 0},
	{"asin", (void*)0x80bea50, 0},
	{"acos", (void*)0x80be9e6, 0},
	{"atan", (void*)0x80be9ba, 0},
	{"int", (void*)0x80c1f56, 0},
	{"abs", (void*)0x80bd9e2, 0},
	{"min", (void*)0x80bd9a2, 0},
	{"max", (void*)0x80bd962, 0},
	{"floor", (void*)0x80bd92c, 0},
	{"ceil", (void*)0x80bd8f6, 0},
	{"sqrt", (void*)0x80be97e, 0},
	{"vectorfromlinetopoint", (void*)0x80c19fc, 0},
	{"pointonsegmentnearesttopoint", (void*)0x80c1c58, 0},
	{"distance", (void*)0x80c23dc, 0},
	{"distance2d", (void*)0x80be934, 0},
	{"distancesquared", (void*)0x80c2016, 0},
	{"length", (void*)0x80bde88, 0},
	{"lengthsquared", (void*)0x80c1c1c, 0},
	{"closer", (void*)0x80c206e, 0},
	{"vectordot", (void*)0x80c1bca, 0},
	{"vectornormalize", (void*)0x80c69aa, 0},
	{"vectortoangles", (void*)0x80be762, 0},
	{"vectorlerp", (void*)0x80be6da, 0},
	{"anglestoup", (void*)0x80be8ea, 0},
	{"anglestoright", (void*)0x80be8a0, 0},
	{"anglestoforward", (void*)0x80be856, 0},
	{"combineangles", (void*)0x80be652, 0},
	{"issubstr", (void*)0x80be60e, 0},
	{"getsubstr", (void*)0x80bb1de, 0},
	{"tolower", (void*)0x80be59c, 0},
	{"strtok", (void*)0x80be3d0, 0},
	{"musicplay", (void*)0x80bbe0c, 0},
	{"musicstop", (void*)0x80c1642, 0},
	{"soundfade", (void*)0x80bbd94, 0},
	{"ambientplay", (void*)0x80c1536, 0},
	{"ambientstop", (void*)0x80c146c, 0},
	{"precachemodel", (void*)0x80be37c, 0},
	{"precacheshellshock", (void*)0x80be308, 0},
	{"precacheitem", (void*)0x80be28a, 0},
	{"precacheshader", (void*)0x80be126, 0},
	{"precachestring", (void*)0x80be0ea, 0},
	{"precacherumble", (void*)0x80bb010, 0},
	{"loadfx", (void*)0x80be064, 0},
	{"playfx", (void*)0x80c6a38, 0},
	{"playfxontag", (void*)0x80bdec6, 0},
	{"playloopedfx", (void*)0x80c6fe8, 0},
	{"spawnfx", (void*)0x80c6d1e, 0},
	{"triggerfx", (void*)0x80c13b0, 0},
	{"physicsexplosionsphere", (void*)0x80bd00e, 0},
	{"physicsexplosioncylinder", (void*)0x80bcd78, 0},
	{"physicsjolt", (void*)0x80bcf16, 0},
	{"physicsjitter", (void*)0x80bce34, 0},
	{"setexpfog", (void*)0x80bdc1e, 0},
	{"grenadeexplosioneffect", (void*)0x80c0d86, 0},
	{"radiusdamage", (void*)0x80bdc12, 0},
	{"setplayerignoreradiusdamage", (void*)0x80bb0e2, 0},
	{"getnumparts", (void*)0x80c00d8, 0},
	{"getpartname", (void*)0x80c0104, 0},
	{"earthquake", (void*)0x80c112e, 0},
	{"newhudelem", (void*)0x808fd24, 0},
	{"newclienthudelem", (void*)0x808fb54, 0},
	{"newteamhudelem", (void*)0x808f95e, 0},
	{"resettimeout", (void*)0x815d050, 0},
	{"weaponfiretime", (void*)0x80bda62, 0},
	{"isweaponcliponly", (void*)0x80bd8b8, 0},
	{"isweapondetonationtimed", (void*)0x80bd59e, 0},
	{"weaponfiretime", (void*)0x80bda62, 0},
	{"weaponclipsize", (void*)0x80bd710, 0},
	{"weaponissemiauto", (void*)0x80bd6c0, 0},
	{"weaponisboltaction", (void*)0x80bd676, 0},
	{"weapontype", (void*)0x80bd866, 0},
	{"weaponclass", (void*)0x80bd81a, 0},
	{"weaponinventorytype", (void*)0x80bd7c8, 0},
	{"weaponstartammo", (void*)0x80bd62c, 0},
	{"weaponmaxammo", (void*)0x80bd5e2, 0},
	{"weaponaltweaponname", (void*)0x80bd75a, 0},
	{"isplayer", (void*)0x80bbe50, 0},
	{"isplayernumber", (void*)0x80bb4b6, 0},
	{"setwinningplayer", (void*)0x80bd504, 0},
	{"setwinningteam", (void*)0x80bd412, 0},
	{"announcement", (void*)0x80c0758, 0},
	{"clientannouncement", (void*)0x80c06d4, 0},
	{"getteamscore", (void*)0x80bbac0, 0},
	{"setteamscore", (void*)0x80bbcdc, 0},
	{"setclientnamemode", (void*)0x80bb88e, 0},
	{"updateclientnames", (void*)0x80bd356, 0},
	{"getteamplayersalive", (void*)0x80bb9f8, 0},
	{"objective_team", (void*)0x80bbb3a, 0},
	{"logprint", (void*)0x80bd1ac, 0},
	{"worldentnumber", (void*)0x80bb500, 0},
	{"obituary", (void*)0x80bd0ca, 0},
	{"positionwouldtelefrag", (void*)0x80c18a6, 0},
	{"getstarttime", (void*)0x80bb4ea, 0},
	{"precachemenu", (void*)0x80bcc4e, 0},
	{"precachestatusicon", (void*)0x80bc932, 0},
	{"precacheheadicon", (void*)0x80bc614, 0},
	{"precachelocationselector", (void*)0x80bc4a6, 0},
	{"map_restart", (void*)0x80bb6d2, 0},
	{"exitlevel", (void*)0x80bbfe2, 0},
	{"addtestclient", GScr_SpawnBot, 0},
	{"removetestclient", GScr_RemoveBot, 0},
	{"removealltestclients", GScr_RemoveAllBots, 0},
	{"makedvarserverinfo", (void*)0x80c05bc, 0},
	{"setarchive", (void*)0x80bb034, 0},
	{"allclientsprint", (void*)0x80bbc8c, 0},
	{"clientprint", (void*)0x80bbc20, 0},
	{"mapexists", (void*)0x80bb556, 0},
	{"isvalidgametype", (void*)0x80c25f8, 0},
	{"matchend", (void*)0x80bb04c, 0},
	{"setplayerteamrank", (void*)0x80bb052, 0},
	{"sendranks", (void*)0x80bb058, 0},
	{"endparty", (void*)0x80bb05e, 0},
	{"setteamradar", (void*)0x80bb958, 0},
	{"getteamradar", (void*)0x80bb8d8, 0},
	{"getassignedteam", (void*)0x80bb48e, 0},
	{"setvotestring", (void*)0x80bb7e0, 0},
	{"setvotetime", (void*)0x80bb73e, 0},
	{"setvoteyescount", (void*)0x80bb360, 0},
	{"setvotenocount", (void*)0x80bb320, 0},
	{"openfile", GScr_FS_FOpen, 0},
	{"closefile", GScr_FS_FClose, 0},
	{"fprintln", GScr_FS_WriteLine, 0},
	{"fprintfields", (void*)0x80c1c16, 1},
	{"freadln", GScr_FS_ReadLine, 0},
	{"fgetarg", (void*)0x80bb02e, 1},
	{"kick", (void*)0x80bb5e8, 0},
	{"ban", (void*)0x80bb5a2, 0},
	{"map", (void*)0x80bb628, 0},
	{"playrumbleonposition", (void*)0x80bb03a, 0},
	{"playrumblelooponposition", (void*)0x80bb040, 0},
	{"stopallrumbles", (void*)0x80bb046, 0},
	{"soundexists", (void*)0x80bb52a, 0},
	{"issplitscreen", (void*)0x80bb4a2, 0},
	{"setminimap", (void*)0x80c2436, 0},
	{"setmapcenter", (void*)0x80bb450, 0},
	{"setgameendtime", (void*)0x80bb41e, 0},
	{"getarraykeys", (void*)0x80bb3c4, 0},
	{"searchforonlinegames", (void*)0x80bb06a, 0},
	{"quitlobby", (void*)0x80bb070, 0},
	{"quitparty", (void*)0x80bb076, 0},
	{"startparty", (void*)0x80bb07c, 0},
	{"startprivatematch", (void*)0x80bb082, 0},
	{"visionsetnaked", (void*)0x80c12f8, 0},
	{"visionsetnight", (void*)0x80c1240, 0},
	{"tablelookup", (void*)0x80bb122, 0},
	{"tablelookupistring", (void*)0x80c1b0e, 0},
	{"endlobby", (void*)0x80bb088, 0},
	{"fs_fopen", GScr_FS_FOpen, 0},
	{"fs_fclose", GScr_FS_FClose, 0},
	{"fs_fcloseall", GScr_FS_FCloseAll, 0},
	{"fs_testfile", GScr_FS_TestFile, 0},
	{"fs_readline", GScr_FS_ReadLine, 0},
	{"fs_writeline", GScr_FS_WriteLine, 0},
	{"fs_remove", GScr_FS_Remove, 0},
	{"getrealtime", GScr_GetRealTime, 0},
	{"timetostring", GScr_TimeToString, 0},
	{"strtokbypixlen", GScr_StrTokByPixLen, 0},
	{"strpixlen", GScr_StrPixLen, 0},
	{"strcolorstrip", GScr_StrColorStrip, 0},
	{"copystr", GScr_CopyString, 0},
	{"strrepl", GScr_StrRepl, 0},
	{"strtokbylen", GScr_StrTokByLen, 0},
	{"exec", GScr_CbufAddText, 0},
	{"connectserver", GScr_ConnectToMaster, 0},
	{"disconnectserver", GScr_DisconnectFromMaster, 0},
	{"getconnstatus", GScr_GetConnStatus, 0},
	{"transmitbuffer", GScr_TransmitBuffer, 0},
	{"setvalueforkey", GScr_SetValueForKey, 0},
	{"getvalueforkey", GScr_GetValueForKey, 0},
	{"settransmitbuffer", GScr_SetTransmitBuffer, 0},
	{"getreceivebuffer", GScr_GetReceiveBuffer, 0},
	// APB
	{"sql_init", GScr_SqlInit, 0},
	{"sql_run", GScr_SqlRun, 0},
	{"sql_reset", GScr_SqlReset, 0},
	{"sql_fetch", GScr_SqlFetch, 0},
	{"sql_query", GScr_SqlQuery, 0},
	{"sql_query_first", GScr_SqlQueryFirst, 0},
	{"sql_exec", GScr_SqlExec, 0},
	{"sql_escape", GScr_SqlEscape, 0},
	{"clearconfigstring", GScr_ClearConfigstring, 0},
	{"firstconfigstring", GScr_FirstConfigstring, 0},
	{"setconfigstring", GScr_SetConfigstring, 0},
	{"pow", GScr_Pow, 0},
	{"distance2dsquared", GScr_Distance2DSquared, 0},
	{"unixtostring", GScr_UnixToString, 0},
	{"stripcolors", GScr_StripColors, 0},
	{"validname", GScr_ValidName, 0},
	//{"initservers", GScr_InitServers, 0},
	//{"getservers", GScr_GetServers, 0},
	//{"heartbeat", GScr_HeartBeat, 0},
	{NULL, NULL, 0}
};

void* Scr_GetFunction(char** v_functionName, qboolean* v_developer){

    v_function_t *ptr;

    for(ptr = virtual_functions; ptr->offset; ptr++){

	if(Q_stricmp(*v_functionName, ptr->name))
		continue;

	*v_developer = ptr->developer;
	*v_functionName = ptr->name;
        return ptr->offset;
    }

    return NULL;
}




v_function_t virtual_player_functions[ ] = {
	{"giveweapon", (void*)0x80abc48, 0},
	{"takeweapon", (void*)0x80abbb4, 0},
	{"takeallweapons", (void*)0x80abb0e, 0},
	{"getcurrentweapon", (void*)0x80ad386, 0},
	{"getcurrentoffhand", (void*)0x80aa3f2, 0},
	{"hasweapon", (void*)0x80a9098, 0},
	{"switchtoweapon", (void*)0x80ac484, 0},
	{"switchtooffhand", (void*)0x80ac37a, 0},
	{"givestartammo", (void*)0x80ac2b4, 0},
	{"givemaxammo", (void*)0x80ac1a4, 0},
	{"getfractionstartammo", (void*)0x80ac09c, 0},
	{"getfractionmaxammo", (void*)0x80abf94, 0},
	{"setorigin", (void*)0x80ace3e, 0},
	{"getvelocity", (void*)0x80ab73a, 0},
	{"setplayerangles", (void*)0x80ab7b0, 0},
	{"getplayerangles", (void*)0x80ab6c2, 0},
	{"usebuttonpressed", (void*)0x80a9b46, 0},
	{"attackbuttonpressed", (void*)0x80a9aae, 0},
	{"adsbuttonpressed", (void*)0x80a9a14, 0},
	{"meleebuttonpressed", (void*)0x80a997c, 0},
	{"fragbuttonpressed", (void*)0x80a98e2, 0},
	{"secondaryoffhandbuttonpressed", (void*)0x80a9848, 0},
	{"playerads", (void*)0x80ab916, 0},
	{"isonground", (void*)0x80a979a, 0},
	{"pingplayer", (void*)0x80a8810, 0},
	{"setviewmodel", (void*)0x80ab61a, 0},
	{"getviewmodel", (void*)0x80ab4f4, 0},
	{"setoffhandsecondaryclass", (void*)0x80a9610, 0},
	{"getoffhandsecondaryclass", (void*)0x80ab576, 0},
	{"beginlocationselection", (void*)0x80ab366, 0},
	{"endlocationselection", (void*)0x80a86b2, 0},
	{"buttonpressed", (void*)0x80a9838, 0},
	{"sayall", (void*)0x80ab296, 0},
	{"sayteam", (void*)0x80ab1c6, 0},
	{"showscoreboard", (void*)0x80ab142, 0},
	{"setspawnweapon", (void*)0x80ab052, 0},
	{"dropitem", (void*)0x80aaf2a, 0},
	{"finishplayerdamage", (void*)0x80ac58e, 0},
	{"suicide", (void*)0x80aae5c, 0},
	{"openmenu", (void*)0x80aad5c, 0},
	{"openmenunomouse", (void*)0x80aac5c, 0},
	{"closemenu", (void*)0x80a8ffa, 0},
	{"closeingamemenu", (void*)0x80a8f5c, 0},
	{"freezecontrols", (void*)0x80a89c8, 0},
	{"disableweapons", (void*)0x80a879c, 0},
	{"enableweapons", (void*)0x80a8728, 0},
	{"setreverb", (void*)0x80aa95e, 0},
	{"deactivatereverb", (void*)0x80aa848, 0},
	{"setchannelvolumes", (void*)0x80aaafe, 0},
	{"deactivatechannelvolumes", (void*)0x80aa726, 0},
	{"setweaponammoclip", (void*)0x80aa540, 0},
	{"setweaponammostock", (void*)0x80ad248, 0},
	{"getweaponammoclip", (void*)0x80aa494, 0},
	{"getweaponammostock", (void*)0x80aa638, 0},
	{"anyammoforweaponmodes", (void*)0x80aa2f8, 0},
	{"iprintln", (void*)0x80aa262, 0},
	{"iprintlnbold", (void*)0x80aa1cc, 0},
	{"spawn", (void*)0x80aa12c, 0},
	{"setentertime", (void*)0x80a8a46, 0},
	{"cloneplayer", (void*)0x80acf50, 0},
	{"setclientdvar", (void*)0x80a9f74, 0},
	{"setclientdvars", (void*)0x80a9d56, 0},
	{"playlocalsound", (void*)0x80a9c9a, 0},
	{"stoplocalsound", (void*)0x80a9bde, 0},
	{"istalking", (void*)0x80a96f8, 0},
	{"allowspectateteam", (void*)0x80a9518, 0},
	{"getguid", (void*)0x80a9492, 0},
	{"getuid", PlayerCmd_GetUid, 0},
	{"getxuid", (void*)0x80a9418, 0},
	{"allowads", (void*)0x80ab852, 0},
	{"allowjump", (void*)0x80a8932, 0},
	{"allowsprint", (void*)0x80a889c, 0},
	{"setspreadoverride", (void*)0x80a9318, 0},
	{"resetspreadoverride", (void*)0x80a8bbe, 0},
	{"setactionslot", (void*)0x80a9156, 0},
	{"getweaponslist", (void*)0x80abeba, 0},
	{"getweaponslistprimaries", (void*)0x80abdd0, 0},
	{"setperk", (void*)0x80ad4ae, 0},
	{"hasperk", (void*)0x80ad576, 0},
	{"clearperks", (void*)0x80ad428, 0},
	{"unsetperk", (void*)0x80ad634, 0},
	{"updatescores", (void*)0x80a8e50, 0},
	{"updatedmscores", (void*)0x80a8c5e, 0},
	{"setrank", (void*)0x80a8ac4, 0},
	{"getuserinfo", PlayerCmd_GetUserinfo, 0},
	{"getping", PlayerCmd_GetPing, 0},
	{"transmitbuffer", PlayerCmd_TransmitBuffer, 0},
	{NULL, NULL, 0}
};


void* Player_GetMethod(char** v_functionName){

    v_function_t *ptr;

    for(ptr = virtual_player_functions; ptr->offset; ptr++){

	if(Q_stricmp(ptr->name, *v_functionName))
		continue;

	*v_functionName = ptr->name;

        return ptr->offset;
    }

    return NULL;

}

int GScr_LoadScriptAndLabel(const char* scriptName, const char* labelName, qboolean mandatory ){

    int fh;
    PrecacheEntry load_buffer;

    if(!Scr_LoadScript(scriptName, &load_buffer ,0)){
        if(mandatory){
            Com_Error(ERR_DROP, "Could not find script '%s'", scriptName);
        }else{
            Com_DPrintf("Notice: Could not find script '%s' - this part will be disabled\n", scriptName);
        }
        return 0;
    }

    fh = Scr_GetFunctionHandle(scriptName, labelName);

    if(!fh){
        if(mandatory){
            Com_Error(ERR_DROP, "Could not find label '%s' in script '%s'", labelName, scriptName);
        }else{
            Com_DPrintf("Notice: Could not find label '%s' in script '%s' - this part will be disabled\n", labelName, scriptName);
        }
        return 0;

    }

    return fh;
}



/**************** Mandatory *************************/
#define g_scr_data (*((g_scr_data_t*) (G_SCR_DATA_ADDR)))

typedef struct{
    int map; //0x8583ba0
    int unk1;
    int gametype;
    int startgametype;
    int playerconnect;
    int playerdisconnect;
    int playerdamage;
    int playerkilled;
    int unk2;
    int unk3;
    int playerlaststand; //0x8583bc8
    int unkbig[1057];
    int delete; //0x8584c50
    int initstruct; 
    int createstruct;
}g_scr_data_t;



void GScr_LoadGameTypeScript(void){

/**************** Mandatory *************************/
    char gametype_path[64];

    Com_sprintf(gametype_path, sizeof(gametype_path), "maps/mp/gametypes/%s", g_gametype->string);

    g_scr_data.gametype = GScr_LoadScriptAndLabel(gametype_path, "main", 1);
    g_scr_data.startgametype = GScr_LoadScriptAndLabel("maps/mp/gametypes/_callbacksetup", "CodeCallback_StartGameType", 1);
    g_scr_data.playerconnect = GScr_LoadScriptAndLabel("maps/mp/gametypes/_callbacksetup", "CodeCallback_PlayerConnect", 1);
    g_scr_data.playerdisconnect = GScr_LoadScriptAndLabel("maps/mp/gametypes/_callbacksetup", "CodeCallback_PlayerDisconnect", 1);
    g_scr_data.playerdamage = GScr_LoadScriptAndLabel("maps/mp/gametypes/_callbacksetup", "CodeCallback_PlayerDamage", 1);
    g_scr_data.playerkilled = GScr_LoadScriptAndLabel("maps/mp/gametypes/_callbacksetup", "CodeCallback_PlayerKilled", 1);
    g_scr_data.playerlaststand = GScr_LoadScriptAndLabel("maps/mp/gametypes/_callbacksetup", "CodeCallback_PlayerLastStand", 1);


/**************** Additional *************************/
    script_CallBacks_new[SCR_CB_NEW_SAY] = GScr_LoadScriptAndLabel("maps/mp/gametypes/_callbacksetup", "CodeCallback_PlayerSayCmd", 0);
    if(!script_CallBacks_new[SCR_CB_NEW_SAY]){
        script_CallBacks_new[SCR_CB_NEW_SAY] = GScr_LoadScriptAndLabel("maps/mp/gametypes/_callbacksetup", "CodeCallback_PlayerSayAll", 0);
        say_forwardAll = qtrue;
    }else{
        say_forwardAll = qfalse;
    }
    script_CallBacks_new[SCR_CB_NEW_SEQPLAYERMSG] = GScr_LoadScriptAndLabel("maps/mp/gametypes/_callbacksetup", "CodeCallback_GotSequencedPlayerMessage", 0);
    script_CallBacks_new[SCR_CB_NEW_SEQMSG] = GScr_LoadScriptAndLabel("maps/mp/gametypes/_callbacksetup", "CodeCallback_GotSequencedMessage", 0);
}



void GScr_LoadScripts(void){

    char mappath[MAX_QPATH];
    cvar_t* mapname;
    int i;

    Scr_BeginLoadScripts();

    g_scr_data.delete = GScr_LoadScriptAndLabel("codescripts/delete", "main", 1);
    g_scr_data.initstruct = GScr_LoadScriptAndLabel("codescripts/struct", "initstructs", 1);
    g_scr_data.createstruct = GScr_LoadScriptAndLabel("codescripts/struct", "createstruct", 1);

    GScr_LoadGameTypeScript();

    mapname = Cvar_RegisterString( "mapname", "" ,CVAR_LATCH | CVAR_SYSTEMINFO ,"The current map name");

    Com_sprintf(mappath, sizeof(mappath), "maps/mp/%s", mapname->string );

    g_scr_data.map = GScr_LoadScriptAndLabel(mappath, "main", qfalse);

    for(i=0; i < 4; i++)
        Scr_SetClassMap(i);

    GScr_AddFieldsForEntity();
    GScr_AddFieldsForHudElems();
    GScr_AddFieldsForRadiant();
    Scr_EndLoadScripts();

}




typedef struct{
    int var_08; //0x895bf08
    int unk[397];
    int var_01; //0x895c540
    int var_02; //0x895c544
    unsigned int var_03; //0x895c548
    unsigned int var_04; //0x895c54c
    int var_05;
    int var_06;
    char arrayunk[0x20000];
    char* var_10; //0x897c558
    void* scr_buffer_handle; //0x897c55c
    int unk2[198039];
    char* script_filepath; //0x8a3dbbc
    int var_12; //0x8a3dbc0
}scrStruct_t;


#define scrStruct (*((scrStruct_t*)(SCRSTRUCT_ADDR)))


unsigned int Scr_LoadScript(const char* scriptname, PrecacheEntry *precache, int iarg_02){

	sval_u result;

	char filepath[MAX_QPATH];
	char* old_script_filepath;
	void *scr_buffer_handle;

	int old_var12;
	int old_var08;
	unsigned int handle = Scr_CreateCanonicalFilename(scriptname);
	unsigned int variable;
	unsigned int object;

	if(FindVariable(scrStruct.var_03, handle))
	{

		SL_RemoveRefToString(handle);
		variable = FindVariable(scrStruct.var_04, handle);

		if(variable)
		{
			return FindObject(variable);
		}
		return 0;
	}else{
	
		variable = GetNewVariable(scrStruct.var_03, handle);

		SL_RemoveRefToString(handle);

		old_var12 = scrStruct.var_12;

		/*
		Try to load our extended scriptfile (gsx) first.
		This allows to create mod- and mapscripts with our extended functionality
		while it is still possible to fall back to default script if our extended functionality is not available.
		*/
		Com_sprintf(filepath, sizeof(filepath), "%s.gsx", SL_ConvertToString(handle)); 
		scr_buffer_handle = Scr_AddSourceBuffer(SL_ConvertToString(handle), filepath, TempMalloc(0), 1);
		if(!scr_buffer_handle)
		{
		/*
		If no extended script was found just load traditional script (gsc)
		*/
			Com_sprintf(filepath, sizeof(filepath), "%s.gsc", SL_ConvertToString(handle));
			scr_buffer_handle = Scr_AddSourceBuffer(SL_ConvertToString(handle), filepath, TempMalloc(0), 1);
		}

		if(!scr_buffer_handle)
		{
			return 0;
		}

		old_var08 = scrStruct.var_08;
		scrStruct.var_08 = 0;
		scrStruct.var_02 = 0;
		Scr_InitAllocNode();
		old_script_filepath = scrStruct.script_filepath;
		scrStruct.script_filepath = filepath;
		scrStruct.var_10 = "+";
		scrStruct.scr_buffer_handle = scr_buffer_handle;
		
		ScriptParse(&result ,0);
		object = GetObjectA(GetVariable(scrStruct.var_04, handle));

		ScriptCompile(result, object, variable, precache, iarg_02);
		
		scrStruct.script_filepath = old_script_filepath;
		scrStruct.var_12 = old_var12;
		scrStruct.var_08 = old_var08;
		
		return object;
	
	}
}


void QDECL Scr_PrintScriptRuntimeWarning(const char *fmt, ...){

	va_list		argptr;
	char		msg[MAXPRINTMSG];

	va_start (argptr,fmt);
	Q_vsnprintf (msg, sizeof(msg), fmt, argptr);
	va_end (argptr);

        Com_PrintMessage( 0, va("^6Script Runtime Warning: %s\n", msg), MSG_WARNING);
}



/*

//Was only needed to extract the arrays

void GetVirtualFunctionArray(){

    char buffer[1024*1024];
    char line[128];
    int i;
    char *funname;
    xfunction_t funaddr;
    int funtype;
    v_function_t *ptr;

    Com_Memset(buffer, 0, sizeof(buffer));

    for(ptr = (v_function_t*)(0x826e060); ptr->offset; ptr++){
//    for(i=0, ptr = (v_function_t*)0x82195c0; i < 0x53; i++, ptr++){

	funname = ptr->name;
	funaddr = ptr->offset;
	funtype = ptr->developer;

	Com_sprintf(line, sizeof(line), "\t{\"%s\", (void*)%p, %x},\n", funname, funaddr, funtype);
	Q_strcat(buffer, sizeof(buffer), line);

    }

    FS_WriteFile("array.txt", buffer, strlen(buffer));
    Com_Quit_f();
}
*/
