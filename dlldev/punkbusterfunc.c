#include "punkbusterfunc.h"
#include "hashgen.c"

pbsventrypoints_t PbCreateExecmemProg() {

	pbsventrypoints_t	i;
	patternseek_t locstart, locend, tmpseek;
	i.pbsvhandle = (int*)*((int*)(0x8879820+0x8));
	i.pbsvbase = LIBRARY_ADDRESS_BY_HANDLE(i.pbsvhandle);
	i.saptr = (int*)(0x8879820+0x150);
	int *ptrofhwid = &i.hwid;
	int *ptrofguid = &i.guid;
	int *ptrofstatus = &i.status;
	int *ptrofos = &i.OS;
	int sizeofpbsv = (dlsym(i.pbsvhandle,"_fini")-i.pbsvbase);
	if(!ptrofpofmade){
		playeroffsetfunc = mmap(NULL, 512, PROT_READ, MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
	}
	if(playeroffsetfunc == MAP_FAILED){
	    perror("mmap() error=");
	    return(i);
	}else{
	    ptrofpofmade = qtrue;
	}
	if(mprotect(playeroffsetfunc,512,PROT_WRITE) != 0){
	    perror("mprotect change memory to writable error");
	    return(i);
	}
	memset(playeroffsetfunc,512,0xc3);
	if(i.pbsvbase == NULL){
	    return(i);
	}
	unsigned char patternstart[] = { 0x8d,0x85,0x66,0x66,0x66,0x66,0x50,0x56,0x68,0x66,0x66,0x66,0x66,0x68,0x66,0x66,0x66,
				    0x66,0x8b,0x45,0x66,0x50,0x8b,0x95,0x66,0x66,0x66,0x66,0xff,0x66 };
	unsigned char patternend[] = { 0x0f,0x84,0x66,0x66 };

	locstart = patternseek(patternstart, sizeof(patternstart), i.pbsvbase, sizeofpbsv);
	locend = patternseek(patternend, sizeof(patternend), locstart.end, sizeofpbsv);
	if(locstart.end == NULL || locend.start == NULL){
	    return(i);
	}
	//Com_Printf("ADDR of HWID: %x\n",locend.start-5);//For DEBUG
	i.execmemaddr = (char*)(playeroffsetfunc+112);
	memcpy(ptrofhwid,(locend.start-5),4);
	memcpy((playeroffsetfunc+128),locstart.end,(locend.start-locstart.end));//For ExecMem
	memcpy((i.execmemaddr),"\x90\x90\x90\x55\x89\xe5\x53\x81\xec\x00\x01\x00\x00\x89",14);//Create stackframe in execmem(push ebp; mov ebp,esp; sub esp,100h)
	tmpseek = patternseek((unsigned char*)"\x8b", sizeof("\x8b"),(playeroffsetfunc+127),(locend.start-locstart.end));
	memcpy((playeroffsetfunc+126),(tmpseek.start+1),2);//(mov e?x,[ebp-?h])
	tmpseek = patternseek((unsigned char*)"\x83\xc4", sizeof("\x83\xc4"),(playeroffsetfunc+128),(locend.start-locstart.end));
	if(tmpseek.start == NULL){
	    return(i);
	}else{
	    memcpy((void*)(tmpseek.start),"\x81\xc4\x00\x01\x00\x00\x89\xd8\x5b\x5d\xc3",11);//Leave stackframe in execmem(add esp,100h;pop ebx; pop ebp; ret)
	}

	unsigned char pattern2[] = { 0x8b,0x83,0x66,0x66,0x66,0x66,0x50,0x83,0xc4,0x66,0x8b,0x83,0x66,0x66,0x66,0x66,
				    0x50,0xe8,0x66,0x66,0x66,0x66,0x83,0xc4,0x66,0x50,0x8d,0x83,0x66,0x66,0x66,0x66,0x50,
				    0x8d,0x83,0x66,0x66,0x66,0x66,0x50,0x8d,0x83,0x66,0x66,0x66,0x66,0x50 };
	tmpseek = patternseek(pattern2, sizeof(pattern2),(i.pbsvbase), sizeofpbsv);
	if(tmpseek.start == NULL){
	    return(i);
	}else{
	    memcpy(ptrofguid,(tmpseek.end-5),4);
	    memcpy(ptrofos,(tmpseek.end-19),4);
	    *ptrofos += 33;
	}
	//Com_Printf("ADDR of GUID: %x\n",tmpseek.start);//For DEBUG
	unsigned char pattern3[] = { 0x8b,0x83 };
	tmpseek = patternseek(pattern3, sizeof(pattern3),(tmpseek.start+2),18);
	if(tmpseek.end == NULL){
	    return(i);
	}else{
	    memcpy(ptrofstatus,(tmpseek.end),4);
	}
	//Com_Printf("ADDR of STATUS: %x\n",tmpseek.end);//For DEBUG
	if(mprotect(playeroffsetfunc,512,PROT_READ | PROT_EXEC) != 0){
	    perror("mprotect change memory to readonly and executable error");
	    return(i);
	}

	i.savesa = *((int*)(0x8879820+0x150));	//copy the Entrypoint of subroutine "sa" needed for detecting updated pbsv.so and loaded function.

	Com_PrintError("PBSV.SO Base addr: %x\n", i.pbsvbase);
	Com_PrintError("BreakPoint addr: %x\n", i.pbsvbase+0x89584);
    return(i);
}


pbsvplayerinfo_t pbgetplayerinfo(int slot){
    pbsvplayerinfo_t	i;
    int			playerptr;
    __asm__ (
	"call	*%%ecx	\n\t"
	:"=a"(playerptr)
	:"a"(slot),"c"(pbsvaddr.execmemaddr)
	:"%edx"
     );
    i.hwid = (char*)(pbsvaddr.hwid+playerptr);
    i.guid = (char*)(pbsvaddr.guid+playerptr);
    i.status = *((pbstatus_t*)(pbsvaddr.status+playerptr));
    i.OS = (char*)(pbsvaddr.OS+playerptr);
    return(i);
}


qboolean checkpbsvmemaddrs(){
    if(*((int*)(0x8879820+0x150)) == 0) return qfalse;
    if(pbsvaddr.savesa != *((int*)(0x8879820+0x150))){
        pbsvaddr = PbCreateExecmemProg();

	if(pbsvaddr.savesa != *((int*)(0x8879820+0x150)) ){
	    return(qfalse);
        }
        pbsvplayerinfo_t	i = pbgetplayerinfo(1);
        pbsvplayerinfo_t	j = pbgetplayerinfo(2);
        pbsvaddr.playermemsize = (j.guid-i.guid);
    }
    return(qtrue);
}

void pbunsetplayer(int slot){
    if(slot > 63 || slot < 0)
	return;
    pbsvplayerinfo_t	i = pbgetplayerinfo(slot);
    Com_Memset((i.guid-33),0,pbsvaddr.playermemsize);
}

void PBInfoPrint_f(){
    int pbsvslot;
    pbsvplayerinfo_t infoplayer;
        for(pbsvslot=0; pbsvslot < 63; pbsvslot++){
	    infoplayer = pbgetplayerinfo(pbsvslot);
	    if(infoplayer.status  == OK){
		Com_Printf("Player %i: PB_HWID: %s\nPB_GUID: %s\n",pbsvslot, infoplayer.hwid,infoplayer.guid);
	    }
	}
}


/*********************************************************************************************/
//		Mandatory functions for PunkBuster operation
/*********************************************************************************************/

int PbSvSendToAddrPort(char* netdest, unsigned short port, int msgsize, char* message){
    char *sourcemsg;
    char msg[256];
    netadr_t netadr;

    __asm("leal -0x836(,%%ebp,1), %%eax\n\t" :"=a"(sourcemsg));

    if(!Q_strncmp(sourcemsg, "PunkBuster Server:", 18)){
        Q_strncpyz(msg, sourcemsg, sizeof(msg));
        if(strstr(msg,"NoGUID*"))		//Prevent telling about Players without GUIDs to streaming-servers
            return 0;

        if(sv_authorizemode->integer < 1 && strstr(msg,"VIOLATION"))	//Prevent streaming of any violations if players can have bad guids
            return 0;
    }

    NET_StringToAdr(va("%s:%i", netdest, port), &netadr, NA_UNSPEC);
    NET_SendPacket(NS_SERVER, msgsize, message, netadr);

    return 0;
}

int PbSvSendToClient(int msgsize, char* message, int clientnum){
    client_t *cl;
    cl = &svs.clients[clientnum];

    if(cl->state >= CS_CONNECTED){

        byte string[MAX_MSGLEN];
        int i;

        // set the OutOfBand header
        string[0] = 0xff;
        string[1] = 0xff;
        string[2] = 0xff;
        string[3] = 0xff;

        if(msgsize +5 >= MAX_MSGLEN){
            Com_PrintWarning("Buffer Overflow in NET_OutOfBandData %i bytes\n", msgsize);
            return 0;
        }

        for ( i = 0; i < msgsize ; i++ ) {
            string[i+4] = message[i];
        }

        NET_SendPacket( NS_SERVER, i+4, string, cl->netchan.remoteAddress );

    }
    return 0;
}


char* PbSvGameQuery(int para_01, char* string){

    int maxclients;
    client_t *cl;
    extclient_t *extcl;
    gclient_t *gclient;
    string[255] = 0;
    int		var_01;
    if(!string) return NULL;
    switch(para_01){
	case 0x65:
            maxclients = sv_maxclients->integer;
	    if(!maxclients) return 0;
	    *string = 0x30;
	    Com_sprintf(string, 255, "%i", maxclients);
	    return 0;

	case 0x66:
	    maxclients = sv_maxclients->integer;
	    var_01 = atoi(string);
	    Com_Memset(string, 0, 0x68);
	    if(var_01 < 0 || var_01 > maxclients) return "PB_Error: Query Failed";
	    cl = &svs.clients[var_01];
	    extcl = &svse.extclients[var_01];

	    if(cl->state < CS_ACTIVE || extcl->noPb) return "PB_Error: Query Failed";
	    Q_strncpyz(string, cl->name, 254);
	    Q_strncpyz(&string[33], cl->pbguid, 221);
	    Q_strncpyz(&string[66], NET_AdrToString(cl->netchan.remoteAddress), 188);
	    return NULL;

	case 0x67:
	    Q_strncpyz(string, Cvar_GetVariantString(string),255);
	    return NULL;

	case 0x72:

	    maxclients = sv_maxclients->integer;
	    *string = 0;
	    var_01 = atoi(string);
	    if(var_01 < 0 || var_01 > maxclients) return "PB_Error: Query Failed";;
	    cl = &svs.clients[var_01];
	    extcl = &svse.extclients[var_01];
	    gclient = &level.clients[para_01];
	    if(cl->state < CS_ACTIVE || extcl->noPb) return "PB_Error: Query Failed";;
	    Com_sprintf(string,255,"ping=%d score=%d", cl->ping, gclient->pers.scoreboard.score);
	    return NULL;

	default:
	    return NULL;
    }
}

