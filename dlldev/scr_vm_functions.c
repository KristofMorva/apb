#include "scr_vm_fs.c"
#include <math.h>
#include <arpa/inet.h>


typedef int scr_entref_t;

/*
============
PlayerCmd_GetUid

Returns the players Uid. Will only work with valid authserver and in sv_authorizemode = 1
Usage: int = self getUid();
============
*/


void PlayerCmd_GetUid(scr_entref_t arg){

    gentity_t* gentity;
    int entityNum;
    int uid;

    if(HIWORD(arg)){

        Scr_ObjectError("Not an entity");

    }else{

        entityNum = LOWORD(arg);
        gentity = &g_entities[entityNum];

        if(!gentity->client){
            Scr_ObjectError(va("Entity: %i is not a player", entityNum));
        }
    }
    if(Scr_GetNumParam()){
        Scr_Error("Usage: self getUid()\n");
    }

    uid = SV_GetUid(entityNum);

    Scr_AddInt(uid);
}


/*
============
PlayerCmd_GetUserinfo

Returns the requested players userinfo value.
Example: name = self getuserinfo("name");
Example: myucvar = self getuserinfo("myucvar");
myucvar has to be set onto the players computer prior with setu myucvar "" so it can be queried in userinfo
The userinfo will automatically update if myucvar changes onto the client computer. This can be used to transfer text from client to server.
Usage: string = self getUserinfo(userinfo key <string>);
============
*/

void PlayerCmd_GetUserinfo(scr_entref_t arg){

    gentity_t* gentity;
    int entityNum;
    client_t *cl;

    if(HIWORD(arg)){

        Scr_ObjectError("Not an entity");

    }else{

        entityNum = LOWORD(arg);
        gentity = &g_entities[entityNum];

        if(!gentity->client){
            Scr_ObjectError(va("Entity: %i is not a player", entityNum));
        }
    }
    if(Scr_GetNumParam() != 1){
        Scr_Error("Usage: self getUserinfo( <string> )\n");
    }

    char* u_key = Scr_GetString(0);

    cl = &svs.clients[entityNum];

    char* value = Info_ValueForKey(cl->userinfo, u_key);

    Scr_AddString(value);
}


/*
============
PlayerCmd_GetPing

Returns the current measured scoreboard ping of this player.
Usage: int = self getPing();
============
*/

void PlayerCmd_GetPing(scr_entref_t arg){

    gentity_t* gentity;
    int entityNum;
    client_t *cl;

    if(HIWORD(arg)){

        Scr_ObjectError("Not an entity");

    }else{

        entityNum = LOWORD(arg);
        gentity = &g_entities[entityNum];

        if(!gentity->client){
            Scr_ObjectError(va("Entity: %i is not a player", entityNum));
        }
    }
    if(Scr_GetNumParam()){
        Scr_Error("Usage: self getPing()\n");
    }

    cl = &svs.clients[entityNum];

    Scr_AddInt(cl->ping);
}




/*
============
GScr_StrTokByPixLen

Returns an array of the string that got sperated in tokens.
It will count the width of given string and will tokenize it so that it will never exceed the given limit.
This function tries to separate the string so that words remains complete
Usage: array = StrTokByPixLen(string <string>, codPixelCount <float>);
============
*/

#define MAX_LINEBREAKS 32

void GScr_StrTokByPixLen(){

    char buffer[2048];
    char *string = buffer;

    if(Scr_GetNumParam() != 2){
        Scr_Error("Usage: StrTokByPixLen(<string>, <float>)");
    }
    char* src = Scr_GetString(0);
    if(!src)
        return;
    else
        Q_strncpyz(buffer, src, sizeof(buffer));

    char* countstring = string;
    char* lastWordSpace = string;

    int lineBreakIndex = 0;

    int lWSHalfPixelCounter = 0;
    int halfPixelCounter = 0;

    int maxHalfPixel = 2.0 * Scr_GetFloat(1);

    Scr_MakeArray();

    while( *countstring ){
        switch(*countstring){

        case '\'':
            halfPixelCounter += 2;
        break;

        case 'i':
        case 'j':
        case 'l':
        case '.':
        case ',':
        case ':':
        case ';':
        case '_':
        case '%':
            halfPixelCounter += 4;
        break;

        case 'f':
        case 'I':
        case '-':
        case '|':
            halfPixelCounter += 5;
        break;

        case 't':
        case 'r':
        case '!':
        case '/':
        case '\\':
        case '"':
            halfPixelCounter += 6;
        break;

        case '(':
        case ')':
        case '[':
        case ']':
            halfPixelCounter += 7;
        break;

        case 'T':
        case '{':
        case '}':
        case '*':
            halfPixelCounter += 8;
        break;

        case 'a':
        case 'c':
        case 'g':
        case 'k':
        case 's':
        case 'v':
        case 'x':
        case 'z':
        case 'F':
        case 'J':
        case 'L':
        case 'Y':
        case 'Z':
            halfPixelCounter += 9;
        break;

        case ' ': /*Save the positions of the last recent wordspacer*/
            lWSHalfPixelCounter = halfPixelCounter;
            lastWordSpace = countstring;
        case 'd':
        case 'h':
        case 'n':
        case 'A':
        case 'P':
        case 'S':
        case 'V':
        case 'X':
        case '?':
            halfPixelCounter += 10;
        break;

        case 'B':
        case 'D':
        case 'G':
        case 'K':
        case 'O':
        case 'Q':
        case 'R':
        case 'U':
        case '0':
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':
        case '8':
        case '9':
        case '$':
        case '<':
        case '>':
        case '=':
        case '+':
        case '^':
        case '~':
            halfPixelCounter += 11;
        break;

        case 'H':
        case 'N':
        case '#':
            halfPixelCounter += 12;
        break;

        case 'w':
        case '&':
            halfPixelCounter += 13;
        break;

        case 'W':
        case 'M':
        case '@':
            halfPixelCounter += 14;
        break;

        case 'm':
            halfPixelCounter += 15;

        default:
            halfPixelCounter += 12;
        }

        if(halfPixelCounter >= maxHalfPixel){
            if(lineBreakIndex >= MAX_LINEBREAKS){
                break; //Cut here - no overrun
            }
            if(lWSHalfPixelCounter >= maxHalfPixel / 3){ //we have a space between words inside the upper half string length
                *lastWordSpace = 0;			//terminate it
                Scr_AddString(string);	//setting the beginning of string in our array
                Scr_AddArray();

                string = &lastWordSpace[1];
                countstring = &lastWordSpace[1];
                lWSHalfPixelCounter = 0;
                halfPixelCounter = 0;

            }else{ 					//we couln't find a space inside the upper half string length
                *countstring = 0;			//Mhh it is complicated to seperate the complete string here. We will just thrash one character
                Scr_AddString(string);
                Scr_AddArray();

                string = &countstring[1];
                countstring = &countstring[1];
                lWSHalfPixelCounter = 0;
                halfPixelCounter = 0;
            }
            lineBreakIndex++;
        }else{
            countstring++;
        }
    }
    if(*string){
        Scr_AddString(string);
        Scr_AddArray();
    }
}



/*
============
GScr_StrTokByLen

Returns an array of the string that got sperated in tokens.
It will count the number of characters of given string and will tokenize it so that it will never exceed the given limit.
This function tries to separate the string so that words remains complete
Usage: array = StrTokByLen(string <string>, maxcharacter count <int>);
============
*/

void GScr_StrTokByLen(){

    char buffer[2048];
    unsigned char lastColor = '7';
    char *outputstr = buffer;

    if(Scr_GetNumParam() != 2){
        Scr_Error("Usage: StrTokByLen(<string>, <int>)");
    }
    char* src = Scr_GetString(0);

    char* inputstr = src;

    int lineBreakIndex = 0;
    int i = 0;
    int j = 0;
    int overflowcnt = 2;
    int lSCounter = 0;
    int lSCounterReal = 0;
    int limit = Scr_GetInt(1);

    Scr_MakeArray();
    outputstr[0] = '^';
    outputstr[1] = lastColor;
    outputstr[2] = 0;


    while( inputstr[i]){

        if(overflowcnt >= (sizeof(buffer) -4)){
            outputstr[i] = 0;
            outputstr[i+1] = 0;
            outputstr[i+2] = 0;
            break;
        }

        if( inputstr[i] == ' '){ /*Save the positions of the last recent wordspacer*/
            lSCounter = i;
            lSCounterReal = j;
        }

        if(inputstr[i] == '^' && inputstr[i+1] >= '0' && inputstr[i+1] <= '9'){
            outputstr[i+2] = inputstr[i];
            i++;
            lastColor = inputstr[i];
            outputstr[i+2] = inputstr[i];
            i++;
            overflowcnt += 2;
            continue;
        }


        if( j >= limit){
            if(lineBreakIndex >= MAX_LINEBREAKS){
                break; //Cut here - no overrun
            }


            if(lSCounterReal >= (limit / 2)){ //we have a space between words inside the upper half string length
                outputstr[lSCounter+2] = 0;
                Scr_AddString(outputstr);	//setting the beginning of string in our array
                Scr_AddArray();

                inputstr = &inputstr[lSCounter+1];
                outputstr = &outputstr[i+3];
                outputstr[0] = '^';
                outputstr[1] = lastColor;
                outputstr[2] = 0;
                overflowcnt += 3;

                lSCounter = 0;
                lSCounterReal = 0;
                i = 0;
                j = 0;

            }else{ 	//we couln't find a space inside the upper half string length
                outputstr[i+2] = 0; //Exception if broken inside colorcode is needed
                Scr_AddString(outputstr);
                Scr_AddArray();

                inputstr = &inputstr[i];
                outputstr = &outputstr[i+3];
                outputstr[0] = '^';
                outputstr[1] = lastColor;
                outputstr[2] = 0;
                overflowcnt += 3;

                lSCounter = 0;
                lSCounterReal = 0;
                i = 0;
                j = 0;
            }
            lineBreakIndex++;
        }else{
            j++;
            outputstr[i+2] = inputstr[i];
            i++;
            overflowcnt++;

        }
    }


    if( outputstr[2] ){
        outputstr[i+2] = 0;
        Scr_AddString(outputstr);
        Scr_AddArray();
    }
}



/*
============
GScr_StrPixLen

This function measures the average length of a given string if it would getting printed
Usage: float = StrPixLen(string <string>);
============
*/

void GScr_StrPixLen(){

    if(Scr_GetNumParam() != 1){
        Scr_Error("Usage: StrPixLen(<string>)");
    }
    char* string = Scr_GetString(0);

    int halfPixelCounter = 0;

    while( *string ){
        switch(*string){

        case '\'':
            halfPixelCounter += 2;
        break;

        case 'i':
        case 'j':
        case 'l':
        case '.':
        case ',':
        case ':':
        case ';':
        case '_':
        case '%':
            halfPixelCounter += 4;
        break;

        case 'f':
        case 'I':
        case '-':
        case '|':
            halfPixelCounter += 5;
        break;

        case 't':
        case 'r':
        case '!':
        case '/':
        case '\\':
        case '"':
            halfPixelCounter += 6;
        break;

        case '(':
        case ')':
        case '[':
        case ']':
            halfPixelCounter += 7;
        break;

        case 'T':
        case '{':
        case '}':
        case '*':
            halfPixelCounter += 8;
        break;

        case 'a':
        case 'c':
        case 'g':
        case 'k':
        case 's':
        case 'v':
        case 'x':
        case 'z':
        case 'F':
        case 'J':
        case 'L':
        case 'Y':
        case 'Z':
            halfPixelCounter += 9;
        break;

        case ' ': /*Save the positions of the last recent wordspacer*/
        case 'd':
        case 'h':
        case 'n':
        case 'A':
        case 'P':
        case 'S':
        case 'V':
        case 'X':
        case '?':
            halfPixelCounter += 10;
        break;

        case 'B':
        case 'D':
        case 'G':
        case 'K':
        case 'O':
        case 'Q':
        case 'R':
        case 'U':
        case '0':
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':
        case '8':
        case '9':
        case '$':
        case '<':
        case '>':
        case '=':
        case '+':
        case '^':
        case '~':
            halfPixelCounter += 11;
        break;

        case 'H':
        case 'N':
        case '#':
            halfPixelCounter += 12;
        break;

        case 'w':
        case '&':
            halfPixelCounter += 13;
        break;

        case 'W':
        case 'M':
        case '@':
            halfPixelCounter += 14;
        break;

        case 'm':
            halfPixelCounter += 15;

        default:
            halfPixelCounter += 12;
        }
        string++;

    }
    float result = (float)halfPixelCounter / 2.0;

    Scr_AddFloat(result);
}


/*
============
GScr_StrColorStrip

Directly cleans the given string from all colorscodes. The original string will be modified!
If it is required that the original string remains you need to create a copy of string prior with copystr()
Usage: void = StrColorStrip(string <string>);
============
*/

void GScr_StrColorStrip(){

    char buffer[2048];

    if(Scr_GetNumParam() != 1){
        Scr_Error("Usage: StrColorStrip(<string>)\n");
    }

    char* string = Scr_GetString(0);

    int i;

    Q_strncpyz(buffer, string, sizeof(buffer));

    for(i=0; buffer[i]; i++){
        if(buffer[i] == '^' && buffer[i+1] >= '0' && buffer[i+1] <= '9'){
            buffer[i+1] = '7';
        }
    }
    Scr_AddString(buffer);
}


/*
============
GScr_StrRepl
This functions finds in a given mainstring all occurrences of a given searchstring and replace those with a given replacementstring
This function returns the resulting string. The mainstring will stay unaffected.

Usage: string = GScr_StrRepl(mainstring <string>, search <string>, replacement <string>);
============
*/

void GScr_StrRepl(){

    char buffer[2048];

    if(Scr_GetNumParam() != 3){
        Scr_Error("Usage: StrReplace(<string>, <string>, <string>)\n");
    }

    char* string = Scr_GetString(0);
    char* find = Scr_GetString(1);
    char* replacement = Scr_GetString(2);

    Q_strnrepl(buffer, sizeof(buffer), string, find, replacement);
    *buffer = 0;

    Scr_AddString(buffer);
}


/*
============
GScr_CopyString

Creates a real copy of the given string and returns the location of the newly created copy
Usage: string = CopyStr(string <string>);
============
*/

void GScr_CopyString(){

    if(Scr_GetNumParam() != 1){
        Scr_Error("Usage: CopyStr(<string>)\n");
    }
    Scr_AddString(Scr_GetString(0));
}



/*
============
GScr_GetRealTime

Returns the current time in seconds since 01/01/2012 UTC
Usage: int = getRealTime();
============
*/

void GScr_GetRealTime(){

    if(Scr_GetNumParam()){
        Scr_Error("Usage: getRealTime()\n");
    }
    Scr_AddInt(realtime - 1325376000);
}






/*
============
GScr_TimeToString

Returns the current unix style time
Usage: string = TimeToString(int <realtime>, int <formattype>)
============
Format types time:
0    none
1    HH:MM 12 hours
2    HH.MM 12 hours
3    HH:MM 24 hours
4    HH.MM 24 hours
5    HH:MM:SS 12 hours
6    HH.MM.SS 12 hours
7    HH:MM:SS 24 hours
8    HH.MM.SS 24 hours

Format types date:
0    none
1    DD.MM.YY
2    DD.MM.YYYY
3    MM.DD.YY
4    MM.DD.YYYY
5    MM/DD/YY
6    MM/DD/YYYY
7    DD.MM
8    MM/DD
*/

void GScr_TimeToString(){
    char timestring[40];
    char* datestring;
    int remaining;
    struct tm *time_s;
    int datetype;
    int timetype;
    int len = 0;

    if(Scr_GetNumParam() != 3){
        Scr_Error("Usage: TimeToString(<realtime>, <timeformattype>, <dateformattype>)\n");
    }
    time_t time = Scr_GetInt(0) + 1325376000;
    datetype = Scr_GetInt(2);
    timetype = Scr_GetInt(1);

    time_s = gmtime( &time );

    switch(timetype)
    {
    case 1:
        Com_sprintf(timestring, sizeof(timestring), "%i:%02i", time_s->tm_hour % 12, time_s->tm_min);
    break;
    case 2:
        Com_sprintf(timestring, sizeof(timestring), "%i.%02i", time_s->tm_hour % 12, time_s->tm_min);
    break;
    case 3:
        Com_sprintf(timestring, sizeof(timestring), "%02i:%02i", time_s->tm_hour, time_s->tm_min);
    break;
    case 4:
        Com_sprintf(timestring, sizeof(timestring), "%02i.%02i", time_s->tm_hour, time_s->tm_min);
    break;
    case 5:
        Com_sprintf(timestring, sizeof(timestring), "%i:%02i:%02i", time_s->tm_hour % 12, time_s->tm_min, time_s->tm_sec);
    break;
    case 6:
        Com_sprintf(timestring, sizeof(timestring), "%i.%02i.%02i", time_s->tm_hour % 12, time_s->tm_min, time_s->tm_sec);
    break;
    case 7:
        Com_sprintf(timestring, sizeof(timestring), "%02i:%02i:%02i", time_s->tm_hour, time_s->tm_min, time_s->tm_sec);
    break;
    case 8:
        Com_sprintf(timestring, sizeof(timestring), "%02i.%02i.%02i", time_s->tm_hour, time_s->tm_min, time_s->tm_sec);
    break;
    default:
        Com_sprintf(timestring, sizeof(timestring), "");
        goto skipspacer;
    }
    len = strlen(timestring);

    timestring[len] = ' ';
    len++;
    timestring[len] = 0;


    skipspacer:

    remaining = sizeof(timestring) - len;

    datestring = &timestring[len];

    switch(datetype)
    {
    case 1:
        Com_sprintf(datestring, remaining, "%02i.%02i.%i", time_s->tm_mday, time_s->tm_mon, time_s->tm_year % 100);
    break;
    case 2:
        Com_sprintf(datestring, remaining, "%02i.%02i.%i", time_s->tm_mday, time_s->tm_mon, time_s->tm_year + 1900);
    break;
    case 3:
        Com_sprintf(datestring, remaining, "%02i.%02i.%i", time_s->tm_mon, time_s->tm_mday,  time_s->tm_year % 100);
    break;
    case 4:
        Com_sprintf(datestring, remaining, "%02i.%02i.%i", time_s->tm_mon, time_s->tm_mday, time_s->tm_year + 1900);
    break;
    case 5:
        Com_sprintf(datestring, remaining, "%02i/%02i/%i", time_s->tm_mon, time_s->tm_mday,  time_s->tm_year % 100);
    break;
    case 6:
        Com_sprintf(datestring, remaining, "%02i/%02i/%i", time_s->tm_mon, time_s->tm_mday, time_s->tm_year + 1900);
    break;
    case 7:
        Com_sprintf(datestring, remaining, "%02i.%02i", time_s->tm_mday, time_s->tm_mon);
    break;
    case 8:
        Com_sprintf(datestring, remaining, "%02i/%02i", time_s->tm_mon, time_s->tm_mday);
    break;
    case 9:
        Com_sprintf(datestring, remaining, "%i.%02i.%02i", time_s->tm_year % 100, time_s->tm_mon, time_s->tm_mday);
    break;
    case 10:
        Com_sprintf(datestring, remaining, "%i.%02i.%02i", time_s->tm_year + 1900, time_s->tm_mon, time_s->tm_mday);
    break;
    case 11:
        Com_sprintf(datestring, remaining, "%i-%02i-%02i", time_s->tm_year + 1900, time_s->tm_mon, time_s->tm_mday);
    break;
    default:
        Com_sprintf(datestring, remaining, "");
    }

    Scr_AddString(timestring);
}


/*
============
GScr_CbufAddText

Execute the given command on server as console command
Usage: void = exec(string <string>);
============
*/

void GScr_CbufAddText(){

    char string[1024];

    if(Scr_GetNumParam() != 1){
        Scr_Error("Usage: exec(<string>)\n");
    }
    Com_sprintf(string, sizeof(string), "%s\n",Scr_GetString(0));
    Cbuf_AddText(EXEC_NOW, string);
}



/*
============
GScr_FS_FOpen

Opens a file(name) inside current FS_GameDir. Mode is selectable. It can be either "read", "write", "append".
It returns on success an integer greater 0. This is the filehandle.
Usage: int = FS_FOpen(string <filename>, string <mode>)
============
*/

void GScr_FS_FOpen(){

    fileHandle_t fh = 0;

    if(Scr_GetNumParam() != 2)
        Scr_Error("Usage: FS_FOpen(<filename>, <mode>)\n");

    char* filename = Scr_GetString(0);
    char* mode = Scr_GetString(1);


    if(!Q_stricmp(mode, "read")){
        fh = Scr_OpenScriptFile( filename, SCR_FH_FILE, FS_READ);
    }else if(!Q_stricmp(mode, "write")){
        fh = Scr_OpenScriptFile( filename, SCR_FH_FILE, FS_WRITE);
    }else if(!Q_stricmp(mode, "append")){
        fh = Scr_OpenScriptFile( filename, SCR_FH_FILE, FS_APPEND);
    }else{
        Scr_Error("FS_FOpen(): invalid mode. Valid modes are: read, write, append\n");
    }

    if(!fh){
            Com_DPrintf("Scr_FS_FOpen() failed\n");
    }
    Scr_AddInt(fh);
}

/*
============
GScr_FS_FClose

Closes an already opened file. Opened files need to be closed after usage
This function returns nothing. It needs a filehandle as argument
Usage: FS_FClose(int <filehandle>)
============
*/

void GScr_FS_FClose(){

    if(Scr_GetNumParam() != 1)
        Scr_Error("Usage: FS_FClose(<filehandle>)\n");

    fileHandle_t fh = Scr_GetInt(0);

    Scr_CloseScriptFile(fh);
}



/*
============
GScr_FS_FCloseAll

Closes all opened files with one call. Opened files need to be closed after usage
This function returns nothing. It needs no arguments
Usage: FS_FCloseAll()
============
*/

void GScr_FS_FCloseAll(){

    int i;

    for(i=0; i < MAX_SCRIPT_FILEHANDLES; i++)
    {
        if(scr_fsh[i].fh)
        {
            Scr_CloseScriptFile(i);
        }
    }
}


/*
============
GScr_FS_TestFile

This function only test whether a filename exists. It must be a file inside the FS_GameDir.
This function returns true if file exists otherwise false.
Usage: FS_TestFile(string <filename>)
============
*/

void GScr_FS_TestFile(){

    int fileExists;

    if(Scr_GetNumParam() != 1)
        Scr_Error("Usage: FS_TestFile(<filename>)\n");

    char* filename = Scr_GetString(0);
    fileExists = FS_FOpenFileRead(filename, NULL);

    if(fileExists == qtrue)
        Scr_AddBool(qtrue);
    else
        Scr_AddBool(qfalse);
}


/*
============
GScr_FS_ReadLine

This function reads a line from opened file and return a string.
This function returns undefined if file can not be read or is at end of file.
Otherwise it just returns the line as string without the terminating \n character
Usage: FS_ReadFile(int <filehandle>)
============
*/

void GScr_FS_ReadLine(){
    char buffer[2048];
    int ret;

    if(Scr_GetNumParam() != 1)
        Scr_Error("Usage: FS_ReadLine(<filehandle>)\n");

    fileHandle_t fh = Scr_GetInt(0);

    *buffer = 0;

    ret = Scr_FS_ReadLine(buffer, sizeof(buffer), fh);
    if(ret < 1 )
        Scr_AddUndefined();

    else if(*buffer == 0)
        Scr_AddString("");

    else{
        int len = strlen(buffer);

        if(buffer[len -1] == '\n')
            buffer[len -1] = 0;

        Scr_AddString(buffer);
    }
}



/*
============
GScr_FS_WriteLine

This function writes/append a line to an opened file.


This function returns "" if file can not be read or is already at end of file.
It returns " " if an empty line got read. Otherwise it just returns the line
Usage: FS_WriteLine(int <filehandle>, string <data>)
============
*/

void GScr_FS_WriteLine(){
    int ret;
    char buffer[2048];

    if(Scr_GetNumParam() != 2)
        Scr_Error("Usage: FS_WriteLine(<filehandle>, <data>)\n");

    fileHandle_t fh = Scr_GetInt(0);
    char* data = Scr_GetString(1);

    Com_sprintf(buffer, sizeof(buffer), "%s\n", data);

    ret = Scr_FS_Write(buffer, strlen(buffer), fh);

    if(!ret)
    {
        Com_DPrintf("^2Scr_FS_WriteLine() failed\n");
        Scr_AddBool(qfalse);
    }else{
        Scr_AddBool(qtrue);
    }
}



/*
============
GScr_FS_Remove

This function deletes a file.

This function returns true on success otherwise it returns false.
Usage: FS_Remove(string <filename>)
============
*/

void GScr_FS_Remove(){
    char filename[MAX_QPATH];

    if(Scr_GetNumParam() != 1)
        Scr_Error("Usage: FS_Delete(<filename>)\n");

    char* qpath = Scr_GetString(0);

    if(!Scr_FS_AlreadyOpened(qpath, filename, sizeof(filename)))
    {
            Scr_Error("FS_Remove: Tried to delete an opened file!\n");
            Scr_AddBool(qfalse);
            return;
    }

    if(FS_HomeRemove(qpath))
    {
        Scr_AddBool(qtrue);

    }else{

        Scr_AddBool(qfalse);
    }
}



/*
============
GScr_FS_InitParamList

Returns a handle to the Parameter list
Usage: int = FS_InitParamList(string <filename>, bool indexed_list)
============
*/

/*
#define MAX_PARAMLISTS 4

void GScr_FS_InitParamList(){

    char* filename;
    qboolean type;
    int i;

    if(Scr_GetNumParam() != 2)
        Scr_Error("FS_InitParamList(string <filename>, bool <indexed_list>)\n");

    filename = Scr_GetString(0);

    type = Scr_GetBool(1);

    //See if we have this list maybe already loaded



    if(scr_fopencount == MAX_SCRIPT_FILEHANDLES -1){
        Scr_Error(va("FS_FOpen(): Exceeded limit of %i opened files\n", MAX_SCRIPT_FILEHANDLES));
    }

    if(Q_stricmp(mode, "read")){
        ret = FS_FOpenFileRead(filename, &fh);
        if(ret == -1){
            Scr_AddInt(0);
        }else{

            Scr_AddScriptFileHandle(fh);
            Scr_AddInt(ret);
        }

    }else if(Q_stricmp(mode, "write")){
        fh = FS_FOpenFileWrite(filename);
        if(fh > 0)
            Scr_AddScriptFileHandle(fh);

        Scr_AddInt(fh);

    }else if(Q_stricmp(mode, "append")){
        fh = FS_FOpenFileAppend(filename);
        if(fh > 0)
            Scr_AddScriptFileHandle(fh);

        Scr_AddInt(fh);

    }else{
        Scr_Error("FS_FOpen(): invalid mode. Valid modes are: read, write, append\n");
    }


    Com_sprintf(buffer, sizeof(buffer), "%s\n", data);


    ret = FS_Write(buffer, strlen(buffer), fh);

    if(!ret)
        Scr_AddBool(qfalse);
    else{
        Scr_AddBool(qtrue);
    }
}

*/

//static int scr_fopencount;
//static int scr_fileHandles[MAX_SCRIPT_FILEHANDLES];

typedef union{
    int step;
    byte cbyte;
}paramlist_index_t;

/*
============
GScr_FS_WriteParamList

Usage: FS_WriteParamList(string <filename>)
============
*/
/*

void GScr_FS_WriteParamList(){
    int ret;
    char buffer[2048];

    if(Scr_GetNumParam() != 2)
        Scr_Error("Usage: FS_WriteLine(<filehandle>, <data>)\n");

    fileHandle_t fh = Scr_GetInt(0);
    char* data = Scr_GetString(1);

    if(fh >= MAX_FILE_HANDLES || fh < 1){
        Scr_Error("FS_ReadLine: Bad filehandle\n");
        return;
    }

    Com_sprintf(buffer, sizeof(buffer), "%s\n", data);


    ret = FS_Write(buffer, strlen(buffer), fh);

    if(!ret)
        Scr_AddBool(qfalse);
    else{
        Scr_AddBool(qtrue);
    }
}


*/




/*
============
GScr_FS_ReadParamList

Usage: FS_ReadParamList(string <filename>)
============
*/



















/*
============
GScr_FS_UnloadParamList

Usage: FS_UnloadParamList(string <filename>)
============
*/







/*
============
GScr_SpawnBot

Usage: entity = AddTestClient()
============
*/

void GScr_SpawnBot(){

	sharedEntity_t *clEnt;

	clEnt = SV_AddBotClient();

	if(clEnt)
		Scr_AddEntity(clEnt);
}

/*
============
GScr_RemoveAllBots

Usage: removeAllTestClients()
============
*/


void GScr_RemoveAllBots(){
	SV_RemoveAllBots();
}

/*
============
GScr_RemoveBot

Usage: entity = removeTestClient()
============
*/

void GScr_RemoveBot(){
	sharedEntity_t *clEnt;
	clEnt = SV_RemoveBot();

	if(clEnt)
		Scr_AddEntity(clEnt);
}




/*
============
GScr_ConnectToMaster

Usage: bool = connectServer(string <address:port>, string <connectkey>)

This function is for sequenced connections only.
It is used to connect to a server.
Address is either a domain name or any ipv4 or ipv6 address.
Connectkey is either just "" or a string of this format:
xxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxxx
1st 4 characters are an index the other 28 characters are the real key
The 1st 12 characters of the real key are only used for challenge and connect requests
The other 16 characters are used for encrypting the established connection - Currently very weak encryption

The index is used on the other other end for faster lookup speed inside a table.
if the key is just "" the following key will be used: 0000-0000000000000000000000000000

On sucessfull resolving of the given address this function will return true - but that doesn't mean the connection is sucessfull
============
*/


void GScr_ConnectToMaster(){

        if(Scr_GetNumParam() != 2)
            Scr_Error("Usage: connectServer(<address:port>, <connectkey>)\n");

	int netenabled = net_enabled->integer;
	int res;

	char* addressAsString = Scr_GetString(0);
	char* connectkey = Scr_GetString(1);


	if(!script_CallBacks_new[SCR_CB_NEW_SEQPLAYERMSG]){
		Scr_Error("ConnectToMaster(): Code callback is not properly initialized: \"maps/mp/gametypes/_callbacksetup::CodeCallback_GotSequencedPlayerMessage\"");
		Scr_AddBool(qfalse);
		return;
	}
	if(!script_CallBacks_new[SCR_CB_NEW_SEQMSG]){
		Scr_Error("ConnectToMaster(): Code callback is not properly initialized: \"maps/mp/gametypes/_callbacksetup::CodeCallback_GotSequencedMessage\"");
		Scr_AddBool(qfalse);
		return;
	}

	if(netenabled & NET_ENABLEV4)
	{
		Com_Printf("Resolving %s (IPv4)\n", addressAsString);
		res = NET_StringToAdr(addressAsString, &svse.scrMaster.connectAddress, NA_IP);
		if(res == 2)
		{
			Com_PrintError("Address contains no port. Can not connect to: %s", addressAsString);
			Scr_AddBool(qfalse);
			return;
		}
		if(res)
			Com_Printf( "%s resolved to %s\n", addressAsString, NET_AdrToString(svse.scrMaster.connectAddress));
		else
			Com_Printf( "%s has no IPv4 address.\n", addressAsString);
	}

	if(netenabled & NET_ENABLEV6 && !res)
	{
		Com_Printf("Resolving %s (IPv6)\n", addressAsString);
		res = NET_StringToAdr(addressAsString, &svse.scrMaster.connectAddress, NA_IP6);

		if(res == 2)
		{
			Com_PrintError("Address contains no port. Can not connect to: %s", addressAsString);
			Scr_AddBool(qfalse);
			return;
		}
		
		if(res)
			Com_Printf( "%s resolved to %s\n", addressAsString, NET_AdrToString(svse.scrMaster.connectAddress));
		else
			Com_Printf( "%s has no IPv6 address.\n", addressAsString);
			Com_PrintError("Couldn't resolve address: %s\n", addressAsString);
			Scr_AddBool(qfalse);
			return;
	}

	svse.scrMaster.state = CA_CHALLENGING; //Fire up check for resent
	svse.scrMaster.commandHandler = Scr_ExecuteMasterResponse;
	
	if(strlen(connectkey) < 2){
		Q_strncpyz(svse.scrMaster.connectKey, "0000-0000000000000000000000000000", sizeof(svse.scrMaster.connectKey));
	}else{
		Q_strncpyz(svse.scrMaster.connectKey, connectkey, sizeof(svse.scrMaster.connectKey));
	}
	Scr_AddBool(qtrue);
}


/*
============
GScr_DisconnectFromMaster

Usage: void = disconnectServer()
============
*/


void GScr_DisconnectFromMaster(){

    if(Scr_GetNumParam()){
        Scr_Error("Usage: disconnectServer()\n");
    }

    CL_Disconnect(&svse.scrMaster, disconnect_neverreconnect);

}

/*
============
GScr_GetConnStatus

Usage: int = getConnStatus()
This function just retrieves the state of the connection
0 = disconnected
1 = challengeing
2 = connecting
3 = connected
============
*/
void GScr_GetConnStatus(){

    if(Scr_GetNumParam()){
        Scr_Error("Usage: getConnStatus()\n");
    }

    Scr_AddInt(svse.scrMaster.state);

}


/*
============
PlayerCmd_TransmitBuffer

Usage: void = self transmitBuffer(string <command>)

This functions sends out the content of the sendDate buffer to the connected server.
It is required that you have build the sendData buffer prior by using one of these two functions:
SetValueForKey() or SetTransmitBuffer()
If you have not build the sendData buffer you will send an empty message which contains only the values:
command; uid; guid; player's challenge

This function will always pass the informations: uid and guid
There is one argument. Command is a string so the server can know what kind of information you send him.
Command is a string so the server can know what you send him.
Ticket is a value that should be always present in the return message from the connected server.
It is used to recognize the player on server so the script can know for which player the message got sent.

If we get any response this will call:
maps/mp/gametypes/_callbacksetup::CodeCallback_GotSequencedPlayerMessage
============
*/

void PlayerCmd_TransmitBuffer(scr_entref_t arg){
    gentity_t* gentity;
    int entityNum;
    int uid;
    char* guid;
    int challenge;

    if(HIWORD(arg)){

        Scr_ObjectError("Not an entity");

    }else{

        entityNum = LOWORD(arg);
        gentity = &g_entities[entityNum];

        if(!gentity->client){
            Scr_ObjectError(va("Entity: %i is not a player", entityNum));
        }
    }

    if(Scr_GetNumParam()){
        Scr_Error("Usage: self transmitBuffer()\n");
    }
    uid = SV_GetUid(entityNum);

    guid = svs.clients[entityNum].pbguid;

    challenge = svs.clients[entityNum].challenge;

    if(guid[32]){
        Info_SetValueForKey(scrCommBuff.sendData, "guid", &guid[24]);
    }
    Info_SetValueForKey(scrCommBuff.sendData, "uid", va("%i", uid));
    Info_SetValueForKey(scrCommBuff.sendData, "Ticket", va("%i", challenge));

    CL_AddReliableCommand(&svse.scrMaster, (const char*)scrCommBuff.sendData);
    *scrCommBuff.sendData = 0; //reset our buffer
}


/*
============
GScr_TransmitBuffer

Usage: void = TransmitBuffer(string <command>)

This functions sends out the content of the sendDate buffer to the connected server.
It is required that you have build the sendData buffer prior by using one of these two functions:
SetValueForKey() or SetTransmitBuffer()
If you have not build the sendData buffer you will send an empty message which contains only the value:
 command

There is one argument. Command is a string so the server can know what kind of information you send him.

If we get any response this will call:
maps/mp/gametypes/_callbacksetup::CodeCallback_GotSequencedMessage
============
*/

void GScr_TransmitBuffer(){

    char* command;
    char transmitBuffer[MAX_INFO_STRING];

    if(Scr_GetNumParam() != 2){
        Scr_Error("Usage: TransmitBuffer(<command>)\n");
    }
    command = Scr_GetString(1);

    Com_sprintf(transmitBuffer, sizeof(transmitBuffer), "%s \"%s\"", command, scrCommBuff.sendData);

    CL_AddReliableCommand(&svse.scrMaster, transmitBuffer);
    *scrCommBuff.sendData = 0; //reset our buffer
}


/*
============
GScr_SetValueForKey

This functions sets a new key and a tied value on the network transmit buffer

Usage: void = setValueForKey(string <key>, string <value>)
============
*/

void GScr_SetValueForKey(){


    if(Scr_GetNumParam() != 2)
        Scr_Error("Usage: setValueForKey(<key>, <value>)\n");

    char* key = Scr_GetString(0);
    char* value = Scr_GetString(1);

    Info_SetValueForKey(scrCommBuff.sendData, key, value);
}


/*
============
GScr_GetValueForKey

This functions retrieves the value for the given key from the current network receive buffer

Usage: string = getValueForKey(string <key>)
============
*/

void GScr_GetValueForKey(){

    char* value;

    if(Scr_GetNumParam() != 1)
        Scr_Error("Usage: getValueForKey( <key> )\n");

    char* key = Scr_GetString(0);

    value = Info_ValueForKey(scrCommBuff.recvData, key);
    Scr_AddString(value);
}



/*
============
GScr_SetTransmitBuffer

Usage: void = setTransmitBuffer(string <value>)

This functions overwrites the network transmit buffer with the given value

WARNING: This function conflict with the functions:
self SeqTransmitBuffer()
self TransmitBuffer()
SetValueForKey()

Never use this functions together!
============
*/

void GScr_SetTransmitBuffer(){

    char* value;

    if(Scr_GetNumParam() != 1)
        Scr_Error("Usage: setTransmitBuffer(<value>)\n");

    value = Scr_GetString(0);

    Q_strncpyz(scrCommBuff.sendData, value, sizeof(scrCommBuff.sendData));
}


/*
============
GScr_GetReceiveBuffer

This functions retrieves the current value of the network receive buffer
Usage: string = getReceiveBuffer()
============
*/

void GScr_GetReceiveBuffer(){

    if(Scr_GetNumParam())
        Scr_Error("Usage: getReceiveBuffer()\n");

    Scr_AddString(scrCommBuff.recvData);

}

/*
============
Global variables and functions for the SQL system.
============
*/

struct substr_s
{
	char* str;
	struct substr_s* next;
};

typedef struct substr_s substr;

struct result_s
{
	substr* data;
	substr* current;
};

typedef struct result_s result;

int UdpSocket;
struct sockaddr_in UdpAddr;
int UdpInitDone = 0;

result* results[64];

void free_substr(substr* pos)
{
	substr* current = pos;
	substr* temp;
	
	while (current)
	{
		temp = current;
		current = temp->next;
		free(temp->str);
		free(temp);
	}
}

substr* split_c(char* str, char del, int* count)
{
	substr* temp;
	substr* current;
	substr* result = NULL;
	
	int pos = -1;
	int len = strlen(str);
	int i;

	*count = 0;
	
	for (i = 0; i <= len; ++i)
	{
		if (i == len || str[i] == del)
		{
			int strLen = i - pos;
			current = (substr*)malloc(sizeof(substr));
			current->str = (char*)malloc(strLen);
			memcpy(current->str, str + pos + 1, strLen - 1);
			current->str[strLen - 1] = 0x0;
			current->next = NULL;
			if (result) temp->next = current;
			else result = current;
			temp = current;
			pos = i;
			++(*count);
		}
	}

	return result;
}

substr* split(char* str, char del)
{
	int i;
	return split_c(str, del, &i);
}

void sql_send(char leading)
{
	if (!UdpInitDone)
	{
		Scr_Error("SQL system is not yet initialized. Please use \"sql_init(<address>, <port>)\" to do so.\n");
		return;
	}
	
	socklen_t addrLen = sizeof(UdpAddr);
	
	char* str = Scr_GetString(0);
	
	char* buf = malloc(strlen(str) + 2);
	buf[0] = leading;
	memcpy(buf + 1, str, strlen(str) + 1);
	if (sendto(UdpSocket, buf, strlen(buf), 0, (struct sockaddr*)&UdpAddr, addrLen) == -1)
	{
		Com_PrintError("Could not send UDP message: %s\n", buf);
		Scr_AddBool(qfalse);
		return;
	}
	Com_Printf("^5SQL message sent: ^7%s\n", buf);
	free(buf);
}

substr* sql_receive()
{
	socklen_t addrLen = sizeof(UdpAddr);
	
	char RecvBuf[8192];
	memset(RecvBuf, 0, 8192);
	if (recvfrom(UdpSocket, RecvBuf, 8192, 0, (struct sockaddr*)&UdpAddr, &addrLen) == -1)
	{
		Com_PrintError("Could not receive packet\n");
		return NULL;
	}
	
	Com_Printf("^5SQL response received: ^7%s\n", RecvBuf);
	
	return strlen(RecvBuf + 1) ? split(RecvBuf + 1, 0x1E) : NULL;
}

/*
============
GScr_SqlInit

Description: This function initializes the SQL system.
Returns: True if the system has been successfully initialized, otherwise false.
Usage: bool = sql_init(string <address>, int <port>)
============
*/

void GScr_SqlInit()
{
	if (UdpInitDone)
	{
		Scr_Error("SQL system is already initialized.\n");
		return;
	}
	
	if (Scr_GetNumParam() != 2)
	{
		Scr_Error("Usage: sql_init(<address>, <port>)\n");
		return;
	}
	
	if ((UdpSocket = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) == -1) {
		Com_PrintError("Could not create socket\n");
		Scr_AddBool(qfalse);
		return;
	}
	
	bzero(&UdpAddr, sizeof(UdpAddr));
	
	UdpAddr.sin_family = AF_INET;
	UdpAddr.sin_port = htons(Scr_GetInt(1));
	
	if (inet_aton(Scr_GetString(0), &UdpAddr.sin_addr) == 0)
	{
		Scr_Error("Invalid address\n");
		return;
	}
	
	Com_Printf("^5SQL system initialized\n");
	UdpInitDone = 1;
	Scr_AddBool(qtrue);
}

/*
============
GScr_SqlRun

Description: This function checks, in the UDP message system is already running.
Usage: bool = sql_run()
============
*/

void GScr_SqlRun()
{
	if (Scr_GetNumParam())
	{
		Scr_Error("Usage: sql_run()\n");
		return;
	}

	Scr_AddBool(UdpInitDone);
}

/*
============
GScr_SqlReset

Description: This function resets the UDP message system.
Usage: void = sql_reset()
============
*/

void GScr_SqlReset()
{
	if (Scr_GetNumParam())
	{
		Scr_Error("Usage: udp_reset()\n");
		return;
	}
	
	if (!UdpInitDone)
	{
		Scr_Error("UDP system is not yet initialized.\n");
		return;
	}
	
	Com_Printf("^5UDP system reset\n");
	close(UdpSocket);
	UdpInitDone = 0;
}

/*
============
GScr_SqlFetch

Description: This function fetches the next record from an SQL query.
Returns: The record as an array of strings.
Usage: array = sql_fetch(int <id>)
============
*/

void GScr_SqlFetch()
{	
	if (Scr_GetNumParam() != 1)
	{
		Scr_Error("Usage: sql_fetch(<id>)\n");
		return;
	}
	
	int id = Scr_GetInt(0);
	result* res = results[id];

	// Two return Separated by iCore
	// No idea how should be handled properly!
	if (!res)
		return;

	if (!res->data)
	{
		free(res);
		results[id] = NULL;
		return;
	}
	
	if (res->current)
	{
		substr* record = split(res->current->str, 0x1F);
		substr* temp_record = record;
		
		Scr_MakeArray();
		
		while (temp_record)
		{
			Scr_AddString(temp_record->str);
			Scr_AddArray();
			temp_record = temp_record->next;
		}
		
		free_substr(record);
		res->current = res->current->next;
	}
	
	if (!res->current)
	{
		free_substr(res->data);
		free(res);
		results[id] = NULL;
	}
}

/*
============
GScr_SqlQuery

Description: This function sends an SQL query and waits for the response.
Returns: True if the query has been executed succesfully, false if an error has occured.
Usage: bool = sql_query(string <message>)
============
*/

void GScr_SqlQuery()
{	
	if (Scr_GetNumParam() != 1)
	{
		Scr_Error("Usage: sql_query(<message>)\n");
		return;
	}
	
	int i;
	for (i = 0; i < 64; i++)
	{
		if (!results[i])
		{
			results[i] = (result*)malloc(sizeof(result));
			break;
		}
	}
	
	if (i == 64)
	{
		Scr_Error("SQL query overflow (64)\n");
		return;
	}
	
	sql_send(0x11);
	results[i]->data = sql_receive();
	results[i]->current = results[i]->data;
	Scr_AddInt(i);
}

/*
============
GScr_SqlQueryFirst

Description: This function sends an SQL query and waits for the response.
Returns: The first column of the first record.
Usage: string = sql_query_first(string <message>)
============
*/

void GScr_SqlQueryFirst()
{
	if (Scr_GetNumParam() != 1)
	{
		Scr_Error("Usage: sql_query_first(<message>)\n");
		return;
	}
	
	sql_send(0x11);
	substr* str = sql_receive();
	if (str)
	{
		Scr_AddString(str->str);
		free(str);
	}
}

/*
============
GScr_SqlExec

Description: This function sends an SQL command.
Returns: True if the query has been executed succesfully, false if an error has occured.
Usage: bool = sql_exec(string <message>)
============
*/

void GScr_SqlExec()
{
	if (Scr_GetNumParam() != 1)
	{
		Scr_Error("Usage: sql_exec(<message>)\n");
		return;
	}
	
	sql_send(0x12);
	Scr_AddBool(qtrue);
}

/*
============
GScr_SqlEscape

Description: Escapes the apostrophes in the given string.
Returns: The resulting string.
Usage: string = sql_escape(string <message>)
============
*/

void GScr_SqlEscape()
{
	if (Scr_GetNumParam() != 1)
	{
		Scr_Error("Usage: sql_escape(<message>)\n");
		return;
	}
	
	char* str = Scr_GetString(0);

	int count;
	int offset = 0;

	substr* pieces = split_c(str, '\'', &count);

	char* new_str = (char*)malloc(strlen(str) + count + 1);
	
	substr* current = pieces;
	while (current)
	{
		int len = strlen(current->str);

		memcpy(new_str + offset, current->str, len);
		offset += len;

		current = current->next;

		if (current)
		{
			new_str[offset] = new_str[offset + 1] = '\'';
			offset += 2;
		}
	}

	new_str[offset] = 0x0;

	Scr_AddString(new_str);
}

/*
============
GScr_ClearConfigstring

It removes the given sound configstring
============
*/

void GScr_ClearConfigstring() {
    if(Scr_GetNumParam() != 1) {
        Scr_Error("Usage: ClearConfigstring(<string>)");
    }
    char* name = Scr_GetString(0);

    char s[MAX_STRING_CHARS];
    int i;

	for (i = 1343; i < 1599; i++) {
		SV_GetConfigstring(i, s, sizeof(s));
		if ( !s[0] ) {
			return;
		}
		if ( !strcmp( s, name ) ) {
			break;
		}
	}
	SV_SetConfigstring(i, "");
}

/*
============
GScr_FirstConfigstring

Returns the first available sound configstring
============
*/

void GScr_FirstConfigstring() {
	char s[MAX_STRING_CHARS];
	int i;
	
	for (i = 1343; i < 1599; i++) {
		SV_GetConfigstring(i, s, sizeof(s));
		if ( !s[0] ) {
			break;
		}
	}
	
	Scr_AddInt(i);
}

/*
============
GScr_SetConfigstring

Sets the given sound configstring
============
*/

void GScr_SetConfigstring() {
    if(Scr_GetNumParam() != 2) {
        Scr_Error("Usage: SetConfigstring(<int>, <string>)");
    }
    int id = Scr_GetInt(0);
    char* value = Scr_GetString(1);

	SV_SetConfigstring(id, value);
}

/*
============
GScr_Pow

Description: Get the nth power of a number.
Returns: The nth power of the given number, where the number is the first, and the "n" is the second parameter.
Usage: float pow(float <base>, float <exp>)
============
*/

void GScr_Pow() {
    if (Scr_GetNumParam() != 2)
    {
        Scr_Error("Usage: pow(<float>, <float>)\n");
        return;
    }

	int p = powf(Scr_GetFloat(0), Scr_GetFloat(1));
    Scr_AddFloat(p);
}

/*
============
GScr_Distance2DSquared

Description: Calculate the squared distance between two points.
Returns: The squared distance between (x, y) and (x2, y2).
Usage: float distance(float <x>, float <y>, float <x2>, float <y2>)
============
*/

void GScr_Distance2DSquared()
{
    if (Scr_GetNumParam() != 4)
    {
        Scr_Error("Usage: distance2DSquared(<float>, <float>, <float>, <float>)\n");
        return;
    }

	Scr_AddFloat(powf(Scr_GetFloat(0) - Scr_GetFloat(2), 2) + powf(Scr_GetFloat(1) - Scr_GetFloat(3), 2));
}

/*
============
GScr_UnixToString

Converts a UNIX time to string in "Date Time" format (instead of "Time Date").
Usage: string = TimeToString(int <realtime>, int <formattype>)
============
Format types time:
0    none
1    HH:MM 12 hours
2    HH.MM 12 hours
3    HH:MM 24 hours
4    HH.MM 24 hours
5    HH:MM:SS 12 hours
6    HH.MM.SS 12 hours
7    HH:MM:SS 24 hours
8    HH.MM.SS 24 hours

Format types date:
0    none
1    DD.MM.YY
2    DD.MM.YYYY
3    MM.DD.YY
4    MM.DD.YYYY
5    MM/DD/YY
6    MM/DD/YYYY
7    DD.MM
8    MM/DD
*/

void GScr_UnixToString() {
    char timestring[40];
    struct tm *time_s;
    int remaining;
    char* datestring;
    int datetype;
    int timetype;
    int len = 0;

    if(Scr_GetNumParam() != 3){
        Scr_Error("Usage: TimeToString(<realtime>, <timeformattype>, <dateformattype>)\n");
    }
    time_t time = Scr_GetInt(0) + 1325376000;
    datetype = Scr_GetInt(2);
    timetype = Scr_GetInt(1);

    time_s = gmtime( &time );

    switch(datetype)
    {
    case 1:
        Com_sprintf(timestring, sizeof(timestring), "%02i.%02i.%i", time_s->tm_mday, time_s->tm_mon + 1, time_s->tm_year % 100);
    break;
    case 2:
        Com_sprintf(timestring, sizeof(timestring), "%02i.%02i.%i", time_s->tm_mday, time_s->tm_mon + 1, time_s->tm_year + 1900);
    break;
    case 3:
        Com_sprintf(timestring, sizeof(timestring), "%02i.%02i.%i", time_s->tm_mon + 1, time_s->tm_mday,  time_s->tm_year % 100);
    break;
    case 4:
        Com_sprintf(timestring, sizeof(timestring), "%02i.%02i.%i", time_s->tm_mon + 1, time_s->tm_mday, time_s->tm_year + 1900);
    break;
    case 5:
        Com_sprintf(timestring, sizeof(timestring), "%02i/%02i/%i", time_s->tm_mon + 1, time_s->tm_mday,  time_s->tm_year % 100);
    break;
    case 6:
        Com_sprintf(timestring, sizeof(timestring), "%02i/%02i/%i", time_s->tm_mon + 1, time_s->tm_mday, time_s->tm_year + 1900);
    break;
    case 7:
        Com_sprintf(timestring, sizeof(timestring), "%02i.%02i", time_s->tm_mday, time_s->tm_mon + 1);
    break;
    case 8:
        Com_sprintf(timestring, sizeof(timestring), "%02i/%02i", time_s->tm_mon + 1, time_s->tm_mday);
    break;
    case 9:
        Com_sprintf(timestring, sizeof(timestring), "%i.%02i.%02i", time_s->tm_year % 100, time_s->tm_mon + 1, time_s->tm_mday);
    break;
    case 10:
        Com_sprintf(timestring, sizeof(timestring), "%i.%02i.%02i", time_s->tm_year + 1900, time_s->tm_mon + 1, time_s->tm_mday);
    break;
    case 11:
        Com_sprintf(timestring, sizeof(timestring), "%i-%02i-%02i", time_s->tm_year + 1900, time_s->tm_mon + 1, time_s->tm_mday);
    break;
    default:
        goto skipspacer;
    }

    len = strlen(timestring);

    timestring[len] = ' ';
    len++;
    timestring[len] = 0;


    skipspacer:
   
    remaining = sizeof(timestring) - len;
    datestring = &timestring[len];

    switch(timetype)
    {
    case 1:
        Com_sprintf(datestring, remaining, "%i:%02i", time_s->tm_hour % 12, time_s->tm_min);
    break;
    case 2:
        Com_sprintf(datestring, remaining, "%i.%02i", time_s->tm_hour % 12, time_s->tm_min);
    break;
    case 3:
        Com_sprintf(datestring, remaining, "%02i:%02i", time_s->tm_hour, time_s->tm_min);
    break;
    case 4:
        Com_sprintf(datestring, remaining, "%02i.%02i", time_s->tm_hour, time_s->tm_min);
    break;
    case 5:
        Com_sprintf(datestring, remaining, "%i:%02i:%02i", time_s->tm_hour % 12, time_s->tm_min, time_s->tm_sec);
    break;
    case 6:
        Com_sprintf(datestring, remaining, "%i.%02i.%02i", time_s->tm_hour % 12, time_s->tm_min, time_s->tm_sec);
    break;
    case 7:
        Com_sprintf(datestring, remaining, "%02i:%02i:%02i", time_s->tm_hour, time_s->tm_min, time_s->tm_sec);
    break;
    case 8:
        Com_sprintf(datestring, remaining, "%02i.%02i.%02i", time_s->tm_hour, time_s->tm_min, time_s->tm_sec);
    break;
    }

    Scr_AddString(timestring);
}


/*
============
GScr_StripColors

Directly cleans the given string from all colorscodes.
Usage: void = StripColors(string <string>);
============
*/

void GScr_StripColors() {

    char buffer[2048];

    if (Scr_GetNumParam() != 1) {
        Scr_Error("Usage: StrColorStrip(<string>)\n");
    }

    char* string = Scr_GetString(0);

    int i;

    Q_strncpyz(buffer, string, sizeof(buffer));

    for (i = 1; buffer[i]; i++) {
        if (buffer[i - 1] == '^' && buffer[i] >= '0' && buffer[i] <= '9') {
            buffer[i] = '^';
        }
    }
    Scr_AddString(buffer);
}

/*
============
GScr_InitServers

Queries APB servers.
Usage: InitServers(<string>, <integer>);
============
*/

/*int ServerSocket;
struct sockaddr_in ServerAddr;
int ServerInitDone = 0;

void GScr_InitServers()
{
	if (ServerInitDone)
	{
		Scr_Error("Server-query system is already initialized.\n");
		return;
	}
	
	if (Scr_GetNumParam() != 2)
	{
		Scr_Error("Usage: initServers(<address>, <port>)\n");
		return;
	}
	
	if ((ServerSocket = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) == -1) {
		Com_PrintError("Could not create socket\n");
		Scr_AddBool(qfalse);
		return;
	}
	
	bzero(&ServerAddr, sizeof(ServerAddr));
	
	ServerAddr.sin_family = AF_INET;
	ServerAddr.sin_port = htons(Scr_GetInt(1));
	
	if (inet_aton(Scr_GetString(0), &ServerAddr.sin_addr) == 0)
	{
		Scr_Error("Invalid address\n");
		return;
	}
	
	Com_Printf("^5Server-query system initialized\n");
	ServerInitDone = 1;
	Scr_AddBool(qtrue);
}*/

/*
============
GScr_GetServers

Queries APB servers.
Usage: array = GetServers();
============
*/

/*void GScr_GetServers()
{
	if (!ServerInitDone)
	{
		Scr_Error("Server-query system is not yet initialized. Please use \"initServers(<address>, <port>)\" to do so.\n");
		return;
	}
	
    if (Scr_GetNumParam() != 0)
    {
        Scr_Error("Usage: GetServers()\n");
    }

	socklen_t addrLen = sizeof(ServerAddr);

	if (sendto(ServerSocket, "report apb", 11, 0, (struct sockaddr*)&ServerAddr, addrLen) == -1)
	{
		Com_PrintError("Could not send UDP message: report apb\n");
		return;
	}
	Com_Printf("^5Server-query sent: ^7report apb\n");

	char RecvBuf[8192];
	memset(RecvBuf, 0, 8192);

	if (recvfrom(ServerSocket, RecvBuf, 8192, 0, (struct sockaddr*)&ServerAddr, &addrLen) == -1)
	{
		Com_PrintError("Could not get UDP message: \n");
		return;
	}

	int count = atoi(RecvBuf);
	Scr_MakeArray();

	int i;
	for (i = 0; i < count; ++i)
	{
		if (recvfrom(ServerSocket, RecvBuf, 8192, 0, (struct sockaddr*)&ServerAddr, &addrLen) == -1)
		{
			Com_PrintError("Could not get UDP message: \n");
			Scr_AddBool(qfalse);
			return;
		}
		Com_Printf("^5Server received: %s\n", RecvBuf);
		Scr_AddString(RecvBuf);
		Scr_AddArray();
	}
}*/

/*
============
GScr_HeartBeat

Forces HeartBeat to master servers
Usage: HeartBeat(<int>, <string>);
============
*/

/*void GScr_HeartBeat()
{
    if (Scr_GetNumParam() != 2)
    {
        Scr_Error("Usage: HeartBeat(<master ID>, <message>)\n");
    }

	svse.forced = Scr_GetInt(0);
	SV_MasterHeartbeat(Scr_GetString(1));
}*/


/*
============
GScr_ValidName

Checks if the string is a valid name (a-zA-Z0-9)
============
*/

void GScr_ValidName() {
    if (Scr_GetNumParam() != 1 && Scr_GetNumParam() != 2) {
        Scr_Error("Usage: ValidName(<string>, [<bool>])");
    }
    char* s = Scr_GetString(0);
    qboolean l;
    if (Scr_GetNumParam() == 2)
    	l = !Scr_GetString(1); // GetBool
    else
    	l = qtrue;

	int c = strlen(s);
	int i;
	for (i = 0; i < c; ++i)
	{
		if ((s[i] < 'a' || s[i] > 'z') && (s[i] < '0' || s[i] > '9') && (s[i] < 'A' || s[i] > 'Z') && (l || s[i] != ' '))
		{
			Scr_AddBool(qfalse);
			return;
		}
	}
	Scr_AddBool(qtrue);
}
