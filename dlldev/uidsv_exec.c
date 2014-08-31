static	cvar_t		*operatorkey;
static	cvar_t		*AuthorizeServername2;

//#include "punkbusterfunc.h"
//#include "hashgen.c"

void updateguid( int clnum, char *md5guid){

    client_t *cl = &svs.clients[clnum];
    extclient_t *pbclient = &svse.extclients[clnum];

    Q_strncpyz(cl->pbguid,md5guid,33);
    pbunsetplayer(clnum);
    Com_Printf("GUID updated for: %s as: %s\n", cl->name, md5guid);
    SV_SendServerCommand(cl,"e \"%s ^7%i\n%s ^7%s\n\"",PBCLIENT_AUTH_SUCCESS1, pbclient->uid,PBCLIENT_AUTH_SUCCESS2,md5guid);
}


void pbsendauthrequest(client_t *cl, extclient_t *pbhwcl){
    char infostring[MAX_INFO_STRING];
    int j, h, n;
    j = h = n = 0;
    char bufferhdd[1024];
    char buffernic[1024];
    int size;

        //Prepare the hwhash string
    size = strlen(pbhwcl->hwinfo);
    while(j < size){ //Check each substring for plausibility and use only the good ones as well as exclude strings based on MAC-Adresses
        if((pbhwcl->hwinfo[j] == 0x73 || pbhwcl->hwinfo[j] == 0x74) && Q_strncmp(&pbhwcl->hwinfo[j+3],"00000000",8)){
		Q_strncpyz(bufferhdd+h,&pbhwcl->hwinfo[j],34);
		h += 33;
	}
	if((pbhwcl->hwinfo[j] == 0x6d) && Q_strncmp(&pbhwcl->hwinfo[j+3],"00000000",8)){
		Q_strncpyz(buffernic+n,&pbhwcl->hwinfo[j],34);
		n += 33;
	}
	j += 33;
    }

    *infostring = 0;
    if(pbhwcl->authentication == 1)
        Info_SetValueForKey( infostring, "pbguid", pbhwcl->originguid);

    Info_SetValueForKey( infostring, "nickname", cl->name);
    Info_SetValueForKey( infostring, "netaddress", NET_AdrToString(cl->netchan.remoteAddress));

    if(n && h){
        Info_SetValueForKey( infostring, "hwhashstrdisk", bufferhdd);
        Info_SetValueForKey( infostring, "hwhashstrnet", buffernic);
    }

    CL_AddReliableCommand(&svse.authserver, va("getUID Ticket %i \"%s\"", cl->challenge, infostring));
    Com_DPrintf("SEND INFO STRING: %s\n",infostring);
}

void pbauthlocal(client_t *cl, extclient_t *pbhwcl, pbsvplayerinfo_t *infoplayer){
    int j, i;
    j = i = 0;
    qboolean nic, hdd;
    nic = hdd = qfalse;
    char buffer[68];

    int size = strlen(infoplayer->hwid);
    if(size > 980){ size = 980;}
    while(j < size && (!nic || !hdd)){ //Check each substring for plausibility and use only the good ones as well as exclude strings based on MAC-Adresses
        if((infoplayer->hwid[j] == 0x73 || infoplayer->hwid[j] == 0x74) && Q_strncmp(&infoplayer->hwid[j+3],"00000000",8) && !hdd){
            Q_strncpyz(buffer+i,&infoplayer->hwid[j],34);
            i += 32;
            hdd = qtrue;
        }
        if((infoplayer->hwid[j] == 0x6d) && Q_strncmp(&infoplayer->hwid[j+3],"00000000",8) && !nic){
            Q_strncpyz(buffer+i,&infoplayer->hwid[j],34);
        i += 32;
        nic = qtrue;
        }
        j += 33;

    }
    updateguid(cl - svs.clients, Com_CreateHash(buffer));
    pbhwcl->authstate = CAU_FINISHED;

}



void getplayerinfo(client_t *cl, extclient_t *pbhwcl){
    char infostring[MAX_INFO_STRING];
    *infostring = 0;

    Info_SetValueForKey( infostring, "uid", va("%i",pbhwcl->uid));

    CL_AddReliableCommand(&svse.authserver, va("getUserinfo Ticket %i \"%s\"", cl->challenge, infostring));
    Com_DPrintf("SEND INFO STRING: %s\n",infostring);
    pbhwcl->userinfoRequestSent = qtrue;
}





void	ProcessPlayerAuth(int clnum){

	pbsvplayerinfo_t infoplayer;
	char *denied;
	client_t *cl = &svs.clients[clnum];
	extclient_t *pbhwcl = &svse.extclients[clnum];
		switch(pbhwcl->authstate){
			case CAU_NEEDHWINFO:

				infoplayer = pbgetplayerinfo(clnum);
				if(infoplayer.status != OK){

					pbhwcl->pbfailcounter++;

					if(pbhwcl->pbfailcounter < 2)
						break;

					if(!level.clients[clnum].freezeControls)
					    Com_Printf("Freeze controls for client %i\n", clnum);

					level.clients[clnum].freezeControls = qtrue;
					SV_SendServerCommand(&svs.clients[clnum], "c \"^2Your controls are frozen because\"");

					if(infoplayer.status == INIT){
						SV_SendServerCommand(&svs.clients[clnum], "c \"^2PunkBuster is not yet initialized.\"");

					}else if(infoplayer.status == UPD){
						SV_SendServerCommand(&svs.clients[clnum], "c \"^2PunkBuster need to be updated.\"");
						SV_SendServerCommand(&svs.clients[clnum], "c \"^2Usually it happens automatically in few minutes\"");
						SV_SendServerCommand(&svs.clients[clnum], "c \"^2if not you have to do it manually.\"");
					}
					break; //Abort if the player has a PB-Client that is not in ready state
				}

				if(level.clients[clnum].freezeControls){
					SV_SendServerCommand(&svs.clients[clnum], "c \"^2Your controls are enabled. Start playing !\"");
					Com_Printf("Enabled controls for client %i\n", clnum);
				}

				level.clients[clnum].freezeControls = qfalse;

				pbhwcl->OS = *infoplayer.OS;

				if(pbhwcl->OS == 'M'){//Case MAC OS X - Extra handling for MAC-Clients
				/*		if(pbhwcl->authentication == -1){					//MAC OS X Clients are free from everything until I find a better idea
						SV_DropClient(cl, PBCLIENT_AUTH_FAILED_MAC);*/
					if(pbhwcl->authentication == 1){					//MAC OS X Clients are free from everything until I find a better idea
						pbhwcl->authstate = CAU_GOTGUIDHWINFO;
					}else{
						pbhwcl->authstate = CAU_FINISHED;
						break;
					}
				}else{	//Windows detected:

					pbhwcl->clienttimeout++; //The number of attempts.

					int j, h, n;
					j = h = n = 0;
					int size;

					if(strlen(infoplayer.hwid) > 65){
					//Test the hwhash string
						size = strlen(infoplayer.hwid);
						if(size > 660) 
							size = 660;
						while(j < size){ //Check each substring for plausibility and use only the good ones as well as exclude strings based on MAC-Adresses
							if((infoplayer.hwid[j] == 0x73 || infoplayer.hwid[j] == 0x74) 
								&& Q_strncmp(&infoplayer.hwid[j+3],"00000000",8)){

								h += 33;
							}
							if((infoplayer.hwid[j] == 0x6d) && Q_strncmp(&infoplayer.hwid[j+3],"00000000",8)){
								n += 33;
							}
							j += 33;
						}
					}
					if(h > 32 && n > 32){ //In case we got valid Harddisk IDs
						pbhwcl->authstate = CAU_GOTGUIDHWINFO;
						Q_strncpyz(pbhwcl->hwinfo, infoplayer.hwid, size+1);
					}else{
						if(pbhwcl->clienttimeout >= CLIENT_TIMEOUT && !pbhwcl->uid){ //SubCase: Timeout - Finish that by either permit the client or kick him

							if(pbhwcl->authentication != 1){
								SV_DropClient(cl, PBCLIENT_AUTH_FAILED_WIN);
								break;
							}else{
								//Got no HW-IDs but a valid CD-KEY
								pbhwcl->authstate = CAU_GOTGUIDHWINFO;
							}
						}else{	//SubCase: Not timed out yet
							//SV_SendServerCommand(cl,"e \"%s \n\"",PBCLIENT_AWAIT_AUTH); //Spam player with awaiting auth messages in console
							if(pbhwcl->clienttimeout & 1){
								pbunsetplayer(clnum); //reset the player on PunkBuster server every 2nd attempt to accelerate this procedure
							}
							break;
						}
					}
				}

			case CAU_GOTGUIDHWINFO:
				pbsendauthrequest(cl, pbhwcl);
				pbhwcl->authstate = CAU_REQUESTEDUID;
				break;
			case CAU_REQUESTEDUID:
				break;		//Do nothing, just wait
			case CAU_GOTUID:
				
				if(pbhwcl->uid == -2){
					SV_DropClient(cl, AUTH_FAILED_MASTER);
					break;
				}else if(pbhwcl->uid == -3){		//Repeat
					pbhwcl->authstate = CAU_GOTGUIDHWINFO;
					break;
				}else{
					denied = CL_IsBanned(pbhwcl->uid, NULL, cl->netchan.remoteAddress);
					if(denied){
						SV_DropClient(cl, denied);
						break;
					}
					Com_Printf("Resolved UID: %i for player %s\n", pbhwcl->uid, cl->name);


					if(pbhwcl->usernamechanged == UN_NEEDUID){
						Com_sprintf(cl->name, 16, "ID_0:%i", pbhwcl->uid);
						Com_sprintf(level.clients[clnum].sess.netname, 16, "ID_0:%i", pbhwcl->uid);
						pbhwcl->usernamechanged = UN_OK;
						Info_SetValueForKey( cl->userinfo, "name", cl->name);
					}
					getplayerinfo(cl, pbhwcl);
					pbhwcl->authstate = CAU_REQUESTEDUSERINFO;
				}
			case CAU_REQUESTEDUSERINFO:
				break;		//Do nothing, just wait
			case CAU_GOTUSERINFO:
				updateguid(clnum, Info_ValueForKey( pbhwcl->globalUserinfo, "guid" ));
				pbhwcl->authstate = CAU_GUIDUPDATED;
				break;
			case CAU_GUIDUPDATED:
				pbhwcl->authstate = CAU_FINISHED;
				break;
			case CAU_FINISHED:
				break;
			default:
				return;
		}

}

qboolean TryInitForAuthserver(){

	AuthorizeServername2 = Cvar_RegisterString("authServerName2", "authorize.iceops.in", CVAR_ARCHIVE, "A secondary authorize servername");

	if(strlen(AuthorizeServername2->string) < 6){
		svse.authserver.connectAddress.type = NA_DOWN;
		return qfalse;
	}

	Com_Printf("Resolving %s\n", AuthorizeServername2->string );
	if ( !NET_StringToAdr( AuthorizeServername2->string, &svse.authserver.connectAddress, NA_IP) ) {
		Com_Printf( "Couldn't resolve address\n" );
		svse.authserver.connectAddress.type = NA_DOWN;
		return qfalse;
	}
	svse.authserver.connectAddress.port = BigShort( PORT_AUTHORIZE );
	Com_Printf("%s resolved to %s\n", AuthorizeServername2->string, NET_AdrToString(svse.authserver.connectAddress));
	svse.authserver.state = CA_CHALLENGING;
	svse.authserver.commandHandler = CL_ExecuteAuthserverCommand;


	operatorkey = Cvar_RegisterString("operatorpass", "", CVAR_ARCHIVE, "Operator Key for Authserver");
	Q_strncpyz(svse.authserver.connectKey, operatorkey->string, sizeof(svse.authserver.connectKey));

	return qtrue;
}




void pbsvstats(){

 if(sv_authorizemode->integer == 1){
  if(checkpbsvmemaddrs()){
    int k;
    client_t *cl;
    extclient_t *pbhwcl;
//    pbsvplayerinfo_t infoplayer;


    if (svse.authserver.connectAddress.type == NA_DOWN) return;

    if (svse.authserver.connectAddress.type == NA_BAD) {
        if(!TryInitForAuthserver()){
            return;
        }
    }

    for(k=0, cl=svs.clients, pbhwcl=svse.extclients; k < sv_maxclients->integer; k++, cl++, pbhwcl++) {
	if(pbhwcl->authstate >= CAU_FINISHED || cl->state != CS_ACTIVE || pbhwcl->noPb){
	    continue;
	//Check for all possible timeouts before everything else
	}else if(svse.authserver.state < CS_CONNECTED){
	
	    if(pbhwcl->authentication == 1){
		pbhwcl->authstate = CAU_FINISHED;
		continue;
	    }
	    //infoplayer = pbgetplayerinfo(k); //-1 translates to real PB_SV-Slot
	    //pbauthlocal(cl, pbhwcl, &infoplayer);
	    continue;

	} else {
		ProcessPlayerAuth(k);
	}
    }//end for loop
//  checkplayerinfo(); //e.g. bans and permissions
  }else{
      sv_authorizemode->integer = 0;
  }//end check pbsvmemaddr
 }//end pbhwauth ?
}//end function


qboolean CL_ExecuteAuthserverCommand( char *s){
	char	c[32];
	char	tmp[1024];
	int	i, length, ticket;
	client_t	*cl;
	char	infostring[MAX_INFO_STRING];
	int uid, auid;

	Com_ParseReset();

	s = Com_ParseGetToken( s );
	if(s == NULL)	return qfalse;

	length = Com_ParseTokenLength( s ) + 1;
	if(length > sizeof(c))
		length = sizeof(c);
	
	Q_strncpyz(c, s, length);

	s = Com_ParseGetToken( s );
	if(s != NULL && !Q_strncmp(s, "Ticket", 6)){
		s = Com_ParseGetToken( s );
		if(s == NULL)	return qfalse;
		Q_strncpyz(tmp, s, Com_ParseTokenLength( s ) + 1 );
		ticket = atoi(tmp);
		s = Com_ParseGetToken( s ); //Set the pointer to the beginning of next token
	}else{
		ticket = 0;
	}

	Com_DPrintf ("UIDServer command: %s\n", c);

	if (!Q_stricmp(c, "disconnect")) {

		if(Cmd_Argv_sv(1))
			Com_Printf("UIDServer dropped connection: %s\n", Cmd_Argv_sv(1));
		else
			Com_Printf("UIDServer dropped connection for unknown reason\n");
		svse.authserver.state = CA_CHALLENGING;

	}else if(!Q_stricmp(c, "broadcast")){
		if(s != NULL){
			SV_SendServerCommand(NULL, "h \"^5Broadcast:^7 %s\"", s);
			Com_Printf ("Message broadcast received: %s\n", s);
		}

	}else if(!Q_stricmp(c, "broadcastTempban")){
		if(s == NULL) return qfalse;

		length = Com_ParseTokenLength(s) + 1;
		if(length > MAX_INFO_STRING)
			length = MAX_INFO_STRING;

		Q_strncpyz(infostring, s, length);

		uid = atoi(Info_ValueForKey(infostring, "uid"));
		auid = atoi(Info_ValueForKey(infostring, "auid"));
		Q_strncpyz(tmp, Info_ValueForKey(infostring, "expire"), sizeof(tmp));
		Com_Printf ("Temp ban broadcast received, uid: %i, admin: %i, expire: %s\n", uid, auid, tmp);
		SV_ExecuteBroadcastedCmd(auid, va("tempban u%i %s %s", uid, tmp, Info_ValueForKey(infostring, "reason")));

	}else if(!Q_stricmp(c, "broadcastPermban")){
		if(s == NULL) return qfalse;

		length = Com_ParseTokenLength(s) + 1;
		if(length > MAX_INFO_STRING)
			length = MAX_INFO_STRING;

		Q_strncpyz(infostring, s, length);

		uid = atoi(Info_ValueForKey(infostring, "uid"));
		auid = atoi(Info_ValueForKey(infostring, "auid"));
		Com_Printf ("Permanent ban broadcast received, uid: %i, admin: %i\n", uid, auid);
		SV_ExecuteBroadcastedCmd(auid, va("permban u%i %s", uid, Info_ValueForKey(infostring, "reason")));

	}else if(!Q_stricmp(c, "broadcastUnban")){
		if(s == NULL) return qfalse;

		length = Com_ParseTokenLength(s) + 1;
		if(length > MAX_INFO_STRING)
			length = MAX_INFO_STRING;

		Q_strncpyz(infostring, s, length);

		uid = atoi(Info_ValueForKey(infostring, "uid"));
		auid = atoi(Info_ValueForKey(infostring, "auid"));
		Com_Printf ("Unban broadcast received, uid: %i, admin: %i\n", uid, auid);
		SV_ExecuteBroadcastedCmd(auid, va("unban u%i", uid));

	}else if(!Q_stricmp(c, "conMessage")){
		if(s != NULL)
			Com_Printf("UIDServer sent message: %s\n", s);

	}else if (!Q_stricmp(c, "uidResponse")) {

		if(s == NULL) return qfalse;

		length = Com_ParseTokenLength(s) + 1;
		if(length > MAX_INFO_STRING)
			length = MAX_INFO_STRING;

		Q_strncpyz(infostring, s, length);


		uid = atoi(Info_ValueForKey(infostring, "uid"));

		for(i = 0, cl = svs.clients; i < sv_maxclients->integer; i++, cl++){
			if(ticket == cl->challenge){
				break;
			}
		}
		if(i == sv_maxclients->integer){
			Com_Printf("Ticket: %i not found\n", ticket);
			return qfalse;
		}

		if(uid == -1){//If error
			Com_Printf("Error resolving UID: Master server made unexpected response\n");
			svse.extclients[i].authstate = CAU_BAD;
		}else{
			if(sv_autodemorecord->boolean && uid > 0)
			{
				SV_RecordClient(cl, va("demo_%i_", uid));
			}
			svse.extclients[i].uid = uid;
			svse.extclients[i].authstate = CAU_GOTUID;
			ProcessPlayerAuth(i);
		}

	} else if (!Q_stricmp(c, "userinfoResponse")) {

		if(s == NULL) return qfalse;

		length = Com_ParseTokenLength(s) + 1;
		if(length > MAX_INFO_STRING)
			length = MAX_INFO_STRING;

		for(i = 0, cl = svs.clients; i < sv_maxclients->integer; i++, cl++){
			if(ticket == cl->challenge+QT_AUTHINFO)
				break;
		}
		if(i < sv_maxclients->integer){

			Q_strncpyz(svse.extclients[i].globalUserinfo, s, length);

			if(strlen(Info_ValueForKey( svse.extclients[i].globalUserinfo, "guid" )) != 32){
				Com_Printf("GUID from MASTER invalid size\n");
				svse.extclients[i].authstate = CAU_BAD;
				return qfalse;
			}else{
				svse.extclients[i].authstate = CAU_GOTUSERINFO;
				ProcessPlayerAuth(i);
			}
			return qfalse;
		}

		for(i = 0, cl = svs.clients; i < sv_maxclients->integer; i++, cl++){
			if(ticket == cl->challenge+QT_CMDQUERY)
				break;
		}
		if(i < sv_maxclients->integer){

			SV_PrintQuery(cl, s, SV_DumpUserResponse);
			return qfalse;
		}else if(ticket == -1){

			SV_PrintQuery(NULL, s, SV_DumpUserResponse);
			return qfalse;
		}

		Com_Printf("Ticket: %i not found\n", ticket);

	} else if (*c == '*'){

		Com_RandomBytes((byte *)tmp, sizeof(tmp));
		for(i = 0; i < sizeof(tmp); i++){
			if(tmp[i] == 0 || tmp[i] == '%')
				tmp[i] = '.';
		}
		tmp[sizeof(tmp)] = 0;
		CL_AddReliableCommand(&svse.authserver, va("*%s", tmp));
		return qtrue;

	} else {
		Com_Printf("UIDServer sent illegible command: %s\n", c);
	}
	return qfalse;
}