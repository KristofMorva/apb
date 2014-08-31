#define BANLIST_DEFAULT_SIZE sizeof(banList_t)*128

cvar_t *banlist;

static int current_banlist_size;
static int current_banindex;


qboolean SV_OversizeBanlistAlign(){

    banList_t *new_blist;
    int newSize;

    if(current_banlist_size <= (current_banindex + 1) * sizeof(banList_t)){//Memory extension
        newSize = current_banlist_size + current_banlist_size / 4;
        new_blist = realloc(svse.banList, newSize);
        if(new_blist){
            svse.banList = new_blist;
            current_banlist_size = newSize;

        }else{
            Com_PrintError("Could not allocate enougth memory to extend the size of banlist. Failed to add new bans\n");
            return qfalse;
        }
    }
    return qtrue;
}



qboolean SV_ParseBanlist(char* line, time_t aclock){
    banList_t *this;
    int playeruid = 0;
    int adminuid = 0;
    time_t expire = 0;
    char reason[128];
    char guid[9];
    guid[8] = 0;
    char playername[MAX_NAME_LENGTH];
    int i;

    playeruid = atoi(Info_ValueForKey(line, "uid"));
    adminuid = atoi(Info_ValueForKey(line, "auid"));
    expire = atoi(Info_ValueForKey(line, "exp"));
    Q_strncpyz(reason, Info_ValueForKey(line, "rsn"), sizeof(reason));
    Q_strncpyz(guid, Info_ValueForKey(line, "guid"), sizeof(guid));
    Q_strncpyz(playername, Info_ValueForKey(line, "nick"), sizeof(guid));

    if(expire < aclock && expire != (time_t)-1){
            return qtrue;
    }
    this = svse.banList;
    if(!this)
        return qfalse;

    if(playeruid){
        for(i = 0; i < current_banindex; this++, i++){
            if(this->playeruid == playeruid){
                Com_Printf("Error: This player with UID: %i is already banned onto this server\n",playeruid);
                return qfalse;
            }
        }
    }else if(guid[7]){
        for(i = 0; i < current_banindex; this++, i++){
            if(!Q_stricmp(this->pbguid, guid)){
                Com_Printf("Error: This player with GUID: %s is already banned onto this server\n",guid);
                return qfalse;
            }
        }
    }else{
        return qfalse; //Bad entry: No Id
    }

    if(!SV_OversizeBanlistAlign())
        return qfalse;

    this = &svse.banList[current_banindex];

    this->playeruid = playeruid;
    this->adminuid = adminuid;
    this->expire = expire;
    Q_strncpyz(this->reason, reason, sizeof(this->reason));
    Q_strncpyz(this->pbguid, guid, sizeof(this->pbguid));
    Q_strncpyz(this->playername, playername, sizeof(this->playername));
    current_banindex++; //Rise the array index
    return qtrue;
}

void SV_LoadBanlist(){
    time_t aclock;
    time(&aclock);
    char buf[256];
    buf[0] = 0;
    fileHandle_t file;
    int read;
    int error;
    int i;

    FS_SV_FOpenFileRead(banlist->string,&file);
    if(!file){
        Com_DPrintf("SV_ReadBanlist: Can not open %s for reading\n",banlist->string);
        return;
    }

    for(i = 0, error = 0 ;error < 32 ;i++){

        read = FS_ReadLine(buf,sizeof(buf),file);
        if(read == 0){
            Com_Printf("%i lines parsed from %s, %i errors occured\n",i,banlist->string,error);
            FS_FCloseFile(file);
            return;
        }
        if(read == -1){
            Com_Printf("Can not read from %s\n",banlist->string);
            FS_FCloseFile(file);
            return;
        }
        if(!*buf || *buf == '/' || *buf == '\n'){
            continue;
        }
        if(!SV_ParseBanlist(buf, aclock)) error++; //Executes the function given as argument in execute
    }
    Com_PrintWarning("More than 32 errors occured by reading from %s\n",banlist->string);
    FS_FCloseFile(file);
}


void SV_WriteBanlist(){

    banList_t *this;
    time_t aclock;
    time(&aclock);
    fileHandle_t file;
    char infostring[1024];
    int i;

    file = FS_SV_FOpenFileWrite(va("%s.tmp", banlist->string));
    if(!file){
        Com_PrintError("SV_WriteBanlist: Can not open %s for writing\n",banlist->string);
        return;
    }

    this = svse.banList;
    if(!this)
        return;

    for(i = 0 ; i < current_banindex; this++, i++){

        if(this->expire == (time_t)-1 || this->expire > aclock){

            *infostring = 0;
            if(this->playeruid > 0){
                Info_SetValueForKey(infostring, "uid", va("%i", this->playeruid));
            }else if(this->pbguid[7]){
                Info_SetValueForKey(infostring, "guid", this->pbguid);
            }else{
                continue;
            }
            Info_SetValueForKey(infostring, "nick", this->playername);
            Info_SetValueForKey(infostring, "rsn", this->reason);
            Info_SetValueForKey(infostring, "exp", va("%i", this->expire));
            Info_SetValueForKey(infostring, "auid", va("%i", this->adminuid));
            Q_strcat(infostring, sizeof(infostring), "\\\n");
            FS_Write(infostring,strlen(infostring),file);
        }
    }
    FS_FCloseFile(file);
    FS_SV_HomeCopyFile(va("%s.tmp", banlist->string) ,banlist->string);
//    FS_SV_Rename(va("%s.tmp", banlist->string),banlist->string);
}


char* SV_PlayerBannedByip(netadr_t netadr){	//Gets called in SV_DirectConnect
    ipBanList_t *this;
    int i;

    for(this = &svse.ipBans[0], i = 0; i < 1024; this++, i++){

        if(NET_CompareBaseAdr(netadr, this->remote)){

            if(svs.time < this->timeout){

                if(this->expire == -1){
                    return va("\nEnforcing prior ban\nPermanent ban issued onto this gameserver\nYou will be never allowed to join this gameserver again\n Your UID is: %i    Banning admin UID is: %i\nReason for this ban:\n%s\n",
                    this->uid,this->adminuid,this->banmsg);

                }else{

                    int remaining = (int)(this->expire-realtime); //in seconds
                    int d = remaining/(60*60*24);
                    remaining = remaining%(60*60*24);
                    int h = remaining/(60*60);
                    remaining = remaining%(60*60);
                    int m = remaining/60;

                    return va("\nEnforcing prior kick/ban\nTemporary ban issued onto this gameserver\nYou are not allowed to rejoin this gameserver for another\n %i days %i hours %i minutes\n Your UID is: %i    Banning admin UID is: %i\nReason for this ban:\n%s\n",
                    d,h,m,this->uid,this->adminuid,this->banmsg);
                }


            }
        }
    }
    return NULL;
}




//duration is in minutes
void SV_PlayerAddBanByip(netadr_t remote, char *reason, int uid, int adminuid, int expire){		//Gets called by future implemented ban-commands and if a prior ban got enforced again - This function can also be used to unset bans by setting 0 bantime

    ipBanList_t *list;
    int i;
    int oldest =	0;
    int oldestTime = 0x7fffffff;
    int duration;

    for(list = &svse.ipBans[0], i = 0; i < 1024; list++, i++){	//At first check whether we have already an entry for this player
        if(NET_CompareBaseAdr(remote, list->remote)){
            break;
        }
	if (list->servertime < oldestTime) {
		oldestTime = list->servertime;
		oldest = i;
	}
    }

    if(i == 1024){
	 list = &svse.ipBans[oldest];
    }
    list->remote = remote;

    Q_strncpyz(list->banmsg, reason, 128);

    list->expire = expire;
    list->uid = uid;
    list->adminuid = adminuid;

    duration = expire - realtime;
    if(duration > 8*60 || expire == -1)
        duration = 8*60;	//Don't ban IPs for more than 8 minutes as they can be shared (Carrier-grade NAT)

    list->servertime = svs.time;

    list->timeout = svs.time+(duration*1000);
    if(list->timeout < 0)
	list->timeout = 0x70000000;

}


char* CL_IsBanned(int uid, char* pbguid, netadr_t addr){
    banList_t *this;
    int i;

    this = svse.banList;
    if(!this)
        return NULL;

    for(i = 0 ; i < current_banindex; this++, i++){

        if(uid && this->playeruid == uid){

            if(this->expire == (time_t)-1){
                SV_PlayerAddBanByip(addr, this->reason, this->playeruid , this->adminuid, -1);
                return va("\nEnforcing prior ban\nPermanent ban issued onto this gameserver\nYou will be never allowed to join this gameserver again\n Your UID is: %i    Banning admin UID is: %i\nReason for this ban:\n%s\n",
                this->playeruid,this->adminuid,this->reason);
            }

            if(this->expire > realtime){

		int remaining = (int)(this->expire - realtime);
                SV_PlayerAddBanByip(addr, this->reason, this->playeruid, this->adminuid, this->expire);
		int d = remaining/(60*60*24);
		remaining = remaining%(60*60*24);
		int h = remaining/(60*60);
		remaining = remaining%(60*60);
		int m = remaining/60;

                return va("\nEnforcing prior kick/ban\nTemporary ban issued onto this gameserver\nYou are not allowed to rejoin this gameserver for another\n %i days %i hours %i minutes\n Your UID is: %i    Banning admin UID is: %i\nReason for this ban:\n%s\n",
                d,h,m,this->playeruid,this->adminuid,this->reason);
            }
        }else if(pbguid && !Q_strncmp(this->pbguid, &pbguid[24], 8)){

            if(this->expire == (time_t)-1){
                return va("Permanent ban issued onto this gameserver\nYou will be never allowed to join this gameserver again\n Your GUID is: %s\nReason for this ban:\n%s\n",
                this->pbguid, this->reason);
            }

            if(this->expire > realtime){

		int remaining = (int)(this->expire - realtime);
		int d = remaining/(60*60*24);
		remaining = remaining%(60*60*24);
		int h = remaining/(60*60);
		remaining = remaining%(60*60);
		int m = remaining/60;

                return va("Temporary ban issued onto this gameserver\nYou are not allowed to rejoin this gameserver for another\n %i days %i hours %i minutes\n Your GUID is: %s\nReason for this ban:\n%s\n",
                d,h,m, this->pbguid, this->reason);
            }

        }
    }
    return NULL;

}

void SV_InitBanlist(){

    Com_Memset(svse.ipBans,0,sizeof(svse.ipBans));
    banlist = Cvar_RegisterString("banlistfile", "banlist.dat", CVAR_INIT, "Name of the file which holds the banlist");
    current_banlist_size = BANLIST_DEFAULT_SIZE;
    current_banindex = 0;
    svse.banList = realloc(NULL, current_banlist_size);//Test for NULL ?
    if(svse.banList){
        SV_LoadBanlist();
    }else{
        Com_PrintError("Failed to allocate memory for the banlist. Banlist is disabled\n");
    }
}

qboolean  SV_ReloadBanlist(){

    banList_t *this;

    this = svse.banList;
    if(!this)
        return qfalse;

    Com_Memset(this, 0, current_banlist_size);
    current_banindex = 0; //Reset the index!

    SV_LoadBanlist();

    this = svse.banList;
    if(!this)
        return qfalse;

    else
        return qtrue;
}




qboolean SV_AddBan(int uid, int auid, char* guid, char* name, time_t expire, char* banreason){

    if(!SV_OversizeBanlistAlign())
        return qfalse;

    banList_t *this;
    int i;


    this = svse.banList;
    if(!this)
        return qfalse;

    int type;

    if(uid > 0){
        type = 0;
    }else if(guid && strlen(guid) == 8){
        type = 1;
    }else{
        return qfalse;
    }

    if(!SV_ReloadBanlist())
        return qfalse;

    for(i = 0 ; i < current_banindex; this++, i++){
        switch(type)
        {
            case 0:
                if(uid != this->playeruid)
                    continue;

            break;
            case 1:
                if(Q_stricmp(guid, this->pbguid))
                    continue;
        }
        break;
    }
    if(i == current_banindex){
        current_banindex++; //Rise the array index

    }else{
        if(type == 0){
            Com_Printf( "Modifying banrecord for player uid: %i\n", uid);
            Cmd_PrintAdministrativeLog( "modified banrecord of player uid: %i:", uid);
        }else{
            Com_Printf( "Modifying banrecord for player guid: %s\n", guid);
            Cmd_PrintAdministrativeLog( "modified banrecord of player guid: %s:", guid);
        }
    }

    this->playeruid = uid;
    this->adminuid = auid;
    this->expire = expire;

    if(banreason)
        Q_strncpyz(this->reason, banreason, sizeof(this->reason));
    else
        *this->reason = 0;

    if(guid && type)
        Q_strncpyz(this->pbguid, guid, sizeof(this->pbguid));
    else
        *this->pbguid = 0;

    if(name)
        Q_strncpyz(this->playername, name, sizeof(this->playername));
    else
        *this->playername = 0;

    SV_WriteBanlist();
    return qtrue;
}


qboolean SV_RemoveBan(int uid, char* guid, char* name){

    banList_t *this;
    int i;
    int type;
    qboolean succ = qfalse;
    char* printguid;
    char* banreason;
    char* printnick;
    ipBanList_t *thisipban;

    if(uid > 0){
        type = 0;
    }else if(strlen(guid) == 8){
        type = 1;
    }else if(strlen(name) > 2){
        type = 2;
    }else{
        return qfalse;
    }

    this = svse.banList;
    if(!this)
        return qfalse;

    if(!SV_ReloadBanlist())
        return qfalse;

    for(i = 0 ; i < current_banindex; this++, i++)
    {
        switch(type)
        {
                case 0:
                    if(uid != this->playeruid)
                        continue;

                    break;
                case 1:
                    if(Q_stricmp(guid, this->pbguid))
                        continue;

                    break;
                case 2:
                    if(!Q_stricmp(name, this->playername))
                        continue;
        }
        this->expire = (time_t) 0;
        succ = qtrue;

        if(!*this->pbguid){
            printguid = "N/A";
        }else{
            printguid = this->pbguid;
        }

        if(!*this->reason){
            banreason = "N/A";
        }else{
            banreason = this->reason;
        }

        if(!*this->playername){
            printnick = "N/A";
        }else{
            printnick = this->playername;
        }

        if(this->playeruid > 0){
            for(thisipban = &svse.ipBans[0], i = 0; i < 1024; thisipban++, i++){
                if(uid == thisipban->uid){
                    Com_Memset(thisipban,0,sizeof(ipBanList_t));
                }
            }
        }

        Com_Printf("Removing ban for Nick: %s, UID: %i, GUID: %s, Banreason: %s\n", printnick, this->playeruid, printguid, banreason);
        Cmd_PrintAdministrativeLog("Removing ban for Nick: %s, UID: %i, GUID: %s, Banreason: %s\n", printnick, this->playeruid, printguid, banreason);
    }
    if(succ)
        SV_WriteBanlist();

    return succ;
}



void SV_DumpBanlist(){

    banList_t *this;
    time_t aclock;
    time(&aclock);
    int i, k;
    char *timestr;

    this = svse.banList;
    if(!this)
        return;

    for(i = 0, k = 0; i < current_banindex; this++, i++){

        if(this->expire == (time_t)-1 || this->expire > aclock){

            k++;

            if(this->expire == (time_t)-1){
                timestr = "Never";
            }else{
                timestr = ctime(&this->expire);
                timestr[strlen(timestr) -1] = 0;
            }

            Com_Printf("%i uid: %i; nick: %s; guid: %s; adminuid: %i; expire: %s; reason: %s\n", i, this->playeruid, this->playername, this->pbguid, this->adminuid, timestr, this->reason);
        }
    }
    Com_Printf("%i Active bans\n", k);
}