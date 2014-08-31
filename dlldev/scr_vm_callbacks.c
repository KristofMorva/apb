//Only CoD4 gamescript callback functions here


qboolean Scr_PlayerSay(gentity_t* from, const char* text){

    int callback;
    int threadId;

    callback = script_CallBacks_new[SCR_CB_NEW_SAY];
    if(!callback){
        return qfalse;
    }
    if(!say_forwardAll)
    {
        if(*text != '/' && *text != '.' && *text != '&')
            return qfalse;

        Scr_AddString(&text[1]);

    }else{
        Scr_AddString(text);
    }

    threadId = Scr_ExecEntThread(from, callback, 1);

    Scr_FreeThread(threadId);

    return qtrue;

}



qboolean Scr_ExecuteMasterResponse(char *s)
{

	char	c[32];
	char	tmp[1024];
	int	i, length, ticket;
	int threadId;
	client_t *cl;
	gentity_t* gentity;
	int callback;

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

	Com_DPrintf ("ScrMaster response: %s\n", c);

	if (!Q_stricmp(c, "disconnect")) {

		if(Cmd_Argv_sv(1))
			Com_Printf("Script connected server dropped connection: %s\n", Cmd_Argv_sv(1));
		else
			Com_Printf("Script connected server dropped connection for unknown reason\n");

		svse.scrMaster.state = CA_CHALLENGING;

	} else if(!Q_stricmp(c, "broadcast")){
		if(s != NULL){
			SV_SendServerCommand(NULL, "h \"^5Broadcast:^7 %s\"", s);
			Com_Printf ("Message broadcast received: %s\n", s);
		}

	} else if(!Q_stricmp(c, "conMessage")){
		if(s != NULL)
			Com_Printf("Script connected server sent message: %s\n", s);

	} else if (*c == '*'){

		Com_RandomBytes((byte *)tmp, sizeof(tmp));
		for(i = 0; i < sizeof(tmp); i++){
			if(tmp[i] == 0 || tmp[i] == '%')
				tmp[i] = '.';
		}
		tmp[sizeof(tmp)] = 0;
		CL_AddReliableCommand(&svse.scrMaster, va("*%s", tmp));
		return qtrue;

	} else { //Nothing predefined ? Call the scriptcallback
		Q_strncpyz(scrCommBuff.lastCommand, c, sizeof(scrCommBuff.lastCommand));
		scrCommBuff.lastTicket = ticket;
		Q_strncpyz((char*)scrCommBuff.recvData, s, sizeof(scrCommBuff.recvData));

		Scr_AddString(c);
		if(ticket){
			for(i = 0, cl = svs.clients; i < sv_maxclients->integer; i++, cl++){
				if(ticket == cl->challenge){
					break;
				}
			}
			if(i != sv_maxclients->integer){
				callback = script_CallBacks_new[SCR_CB_NEW_SEQPLAYERMSG];
				gentity = &g_entities[i];
				threadId = Scr_ExecEntThread(gentity, callback, 1);
				Scr_FreeThread(threadId);
				return qfalse;
			}
		}
		callback = script_CallBacks_new[SCR_CB_NEW_SEQMSG];
		threadId = Scr_ExecThread(callback, 1);
		Scr_FreeThread(threadId);

	}
	return qfalse; //We have not send a response so send a nop-message the server can know that this messages has received
}