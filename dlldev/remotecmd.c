static cvar_t* sv_rconsys;

qboolean SV_RemoteCmdSetPower(const char *cmd_name, int power){

    cmd_function_t *cmd;
    if(!cmd_name) return qfalse;

    for(cmd = cmd_functions ; cmd ; cmd = cmd->next){
        if(!Q_stricmp(cmd_name, cmd->name)){
            if(cmd->minPower != power){
                cmd->minPower = power;
            }
            return qtrue;
        }
    }
    return qfalse;
}


void SV_RemoteCmdInit(){
    sv_rconsys = Cvar_RegisterBool("sv_rconsys", qtrue, CVAR_ARCHIVE, "Disable/enable the internal remote-command-system");
    if(!sv_rconsys->boolean) return;
    cmd_function_t *cmd;
    //Init the permission table with default values
    for(cmd = cmd_functions ; cmd ; cmd = cmd->next) cmd->minPower = 100;
    SV_RemoteCmdSetPower("cmdlist", 1);
    SV_RemoteCmdSetPower("serverinfo", 1);
    SV_RemoteCmdSetPower("systeminfo", 1);
    SV_RemoteCmdSetPower("ministatus", 1);
    svse.cmdInvoker.currentCmdPower = 100; //Set the default to 100 to prevent any blocking on local system. If a command gets remotely executed it will be set temporarely to the expected power
    //Now read the rest from file - Changed this will happen by executing nvconfig.cfg (nonvolatile config)
    svse.cmdSystemInitialized = qtrue;
}




int	Cmd_RemoteCmdGetMinPower(char* cmd_name){

    cmd_function_t *cmd;
    for(cmd = cmd_functions ; cmd ; cmd = cmd->next){
        if(!Q_stricmp(cmd_name,cmd->name)){

                if(!cmd->minPower) return 100;
                else return cmd->minPower;
        }
    }
    return -1; //Don't exist
}


/*
============
SV_RemoteCmdGetClPower
============
*/

int SV_RemoteCmdGetClPower(int clientNum){

    adminPower_t *admin;
    int uid;

    uid = svse.extclients[clientNum].uid;
    if(uid < 1) return 0;

    for(admin = svse.adminPower; admin ; admin = admin->next){

        if(admin->uid == uid){
            return admin->power;
        }
    }
    return 1;
}


/*
============
SV_RemoteCmdGetClPowerByUID
============
*/

int SV_RemoteCmdGetClPowerByUID(int uid){

    adminPower_t *admin;
    if(uid < 1) return 0;

    for(admin = svse.adminPower; admin ; admin = admin->next){

        if(admin->uid == uid){
            return admin->power;
        }
    }
    return 1;
}




/*
=================
SV_ReliableSendRedirect

Sends redirected text of console to client as reliable commands
This is used for RemoteCommand responses while client is connected to server
=================
*/

void SV_ReliableSendRedirect(char *sendbuf){

    int lastlinebreak;
    int remaining = strlen(sendbuf);
    int	maxlength;
    int i;
    char outputbuf[244];

    for(; remaining > 0;){			//We have to split the string into smaller packages of max 240 bytes
						//This function tries to ensure that every package ends on the last possible linebreak for better formating
	maxlength = remaining;

	if(maxlength > 240) maxlength = 240;

	for(lastlinebreak=0 ,i=0; i < maxlength; i++){
	    outputbuf[i] = sendbuf[i];
	    if(outputbuf[i] == '"') outputbuf[i] = 0x27;	//replace all " with ' because no " are accepted
	    if(outputbuf[i] == 0x0a) lastlinebreak = i;		//search for the last linebreak
	}
	if(lastlinebreak > 0){ 
	    i = lastlinebreak;	//found a linebreak and send everything until that position
	    remaining -= i-1;
	    sendbuf += i+1;
	    outputbuf[i+1] = 0x00;
	} else {		//Not a linebreak found send full 240 chars
	    remaining -= i;
	    sendbuf += i;
	    outputbuf[i] = 0x00;
	}
	SV_SendServerCommand(svse.redirectClient, "e \"%s\"", outputbuf);
    }
}


void SV_ExecuteRemoteCmd(int clientnum, const char *msg){
	char sv_outputbuf[SV_OUTPUTBUF_LENGTH];
	char cmd[30];
	char buffer[256];
	int i = 0;
	int j = 0;
	int powercmd;
	int power;

        if(!svse.cmdSystemInitialized){
	    SV_SendServerCommand(svse.redirectClient, "e \"Error: Remote control system is not initialized\n\"");
	    Com_Printf("Error: Remote control system is not initialized\n");
    	    return;
        }


	if(clientnum < 0 || clientnum > 63) return;
	svse.redirectClient = &svs.clients[clientnum];

	while ( msg[i] != ' ' && msg[i] != '\0' && msg[i] != '\n' && i < 32 ){
		i++;
	}
	
	if(i > 29 || i < 3) return;
	Q_strncpyz(cmd,msg,i+1);


	//Prevent buffer overflow as well as prevent the execution of priveleged commands by using seperator characters
	Q_strncpyz(buffer,msg,256);
	Q_strchrrepl(buffer,';','\0');
	Q_strchrrepl(buffer,'\n','\0');
	Q_strchrrepl(buffer,'\r','\0');
	// start redirecting all print outputs to the packet

        power = SV_RemoteCmdGetClPower(clientnum);
        powercmd = Cmd_RemoteCmdGetMinPower(cmd);

	if(powercmd == -1){
            SV_SendServerCommand(svse.redirectClient, "e \"^5Command^2: %s\n^3Command execution failed - Invalid command invoked - Type ^2$cmdlist ^3to get a list of all available commands\"", buffer);
            return;
	}
	if(powercmd > power){
            SV_SendServerCommand(svse.redirectClient, "e \"^5Command^2: %s\n^3Command execution failed - Insufficient power to execute this command.\n^3You need at least ^6%i ^3powerpoints to invoke this command.\n^3Type ^2$cmdlist ^3to get a list of all available commands\"",
            buffer, powercmd);
	    return;
	}

	Com_Printf( "Command execution: %s   Invoked by: %s   InvokerUID: %i Power: %i\n", buffer, svs.clients[clientnum].name, svse.extclients[clientnum].uid, power);
	Com_BeginRedirect(sv_outputbuf, SV_OUTPUTBUF_LENGTH, SV_ReliableSendRedirect);

	i = svse.cmdInvoker.currentCmdPower;
	j = svse.cmdInvoker.currentCmdInvoker;
	svse.cmdInvoker.currentCmdPower = power;
	svse.cmdInvoker.currentCmdInvoker = svse.extclients[clientnum].uid;
	svse.cmdInvoker.clientnum = clientnum;

	Cmd_ExecuteSingleCommand( 0, 0, buffer );

	if(!Q_stricmpn(buffer, "pb_sv_", 6)) PbServerForceProcess();

	SV_SendServerCommand(svse.redirectClient, "e \"^5Command^2: %s\"", buffer);

	svse.cmdInvoker.currentCmdPower = i;
	svse.cmdInvoker.currentCmdInvoker = j;
	svse.cmdInvoker.clientnum = -1;

	Com_EndRedirect();
}


void SV_ExecuteBroadcastedCmd(int uid, const char *msg){

	int i = 0;
	int j = 0;
	int powercmd;
	int power;

	while ( msg[i] != ' ' && msg[i] != '\0' && msg[i] != '\n' && i < 32 ){
		i++;
	}

	char cmd[30];
	char buffer[256];

	if(i > 29 || i < 3) return;
	Q_strncpyz(cmd,msg,i+1);
	//Prevent buffer overflow as well as prevent the execution of priveleged commands by using seperator characters
	Q_strncpyz(buffer,msg,256);
	Q_strchrrepl(buffer,';','\0');
	Q_strchrrepl(buffer,'\n','\0');
	Q_strchrrepl(buffer,'\r','\0');

	if(!uid){
		power = 100;
	}else{
		power = SV_RemoteCmdGetClPowerByUID(uid);
	}
        powercmd = Cmd_RemoteCmdGetMinPower(cmd);


	if(powercmd == -1){
            return;
	}
	if(powercmd > power){
		Com_Printf( "Broadcasted command execution: %s   InvokerUID: %i Power: %i   Insufficient Power\n", buffer, uid, power);
		return;
	}

	Com_Printf( "Broadcasted command execution: %s   Invoked by: BroadcastMessage   InvokerUID: %i Power: %i\n", buffer, uid, power);

	i = svse.cmdInvoker.currentCmdPower;
	j = svse.cmdInvoker.currentCmdInvoker;
	svse.cmdInvoker.currentCmdPower = power;
	svse.cmdInvoker.currentCmdInvoker = uid;
	svse.cmdInvoker.clientnum = -1;

	Cmd_ExecuteSingleCommand( 0, 0, buffer );

	svse.cmdInvoker.currentCmdPower = i;
	svse.cmdInvoker.currentCmdInvoker = j;
	svse.cmdInvoker.clientnum = -1;
}