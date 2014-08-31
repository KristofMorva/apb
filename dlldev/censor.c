#include <stdio.h>
#include <stdlib.h>
#include <string.h>


char* CharConv(char *output, char *string,int size)
{
	char *ret = output;
	if(!output || !string) return NULL;
	if(size < strlen(string)){
	    Com_Error(ERR_FATAL,"CharConv: buffer overflow");
	    return NULL;
	}
	for( ; *string != 0; string++){
		switch(*string){
			case 'A':
			case '4':
			case '@':
				*output='a';
				break;
			case 'B':
				*output='b';
				break;
			case 'C':
			case '(':
				*output='c';
				break;
			case 'D':
			case ')':
				*output='d';
				break;
			case 'E':
			case '3':
				*output='e';
				break;
			case 'F':
				*output='f';
				break;
			case 'G':
				*output='g';
				break;
			case 'H':
				*output='h';
				break;
			case 'I':
			case '1':
			case '|':
			case '!':
				*output='i';
				break;
			case 'J':
				*output='j';
				break;
			case 'K':
				*output='k';
				break;
			case 'L':
				*output='l';
				break;
			case 'M':
				*output='m';
				break;
			case 'N':
				*output='n';
				break;
			case 'O':
			case '0':
				*output='o';
				break;
			case 'P':
				*output='p';
				break;
			case 'Q':
				*output='q';
				break;
			case 'R':
				*output='r';
				break;
			case 'S':
			case '5':
			case '$':
				*output='s';
				break;
			case 'T':
				*output='t';
				break;
			case 'U':
				*output='u';
				break;
			case 'V':
				*output='v';
				break;
			case 'W':
				*output='w';
				break;
			case 'X':
				*output='x';
				break;
			case 'Y':
				*output='y';
				break;
			case 'Z':
				*output='z';
				break;
			case '.':
			case ',':
			case '-':
			case '_':
				continue;
			default:
				*output=*string;
				break;
		}
		output++;
	}
	*output=0;
	return ret;
}




void G_SayCensor_Init()
{
	fileHandle_t file;
	int read;
	badwordsList_t *this;
	qboolean exactmatch;
	char buff[24];
	char line[24];
	char* linept;
	register int i=0;

        FS_SV_FOpenFileRead("badwords.txt",&file);
        if(!file){
            Com_DPrintf("censor_init: Can not open badwords.txt for reading\n");
            return;
        }
        for(i = 0; ;i++){
            read = FS_ReadLine(buff,sizeof(buff),file);

            if(read == 0){
                Com_Printf("%i lines parsed from badwords.txt\n",i);
                FS_FCloseFile(file);
                return;
            }
            if(read == -1){
                Com_Printf("Can not read from badwords.txt\n");
                FS_FCloseFile(file);
                return;
            }

            Q_strncpyz(line,buff,sizeof(line));
            linept = line;

            if(*linept == '#'){
                exactmatch = qtrue;
                linept++;
            }else{
                exactmatch = qfalse;
            }

            this = Z_Malloc(sizeof(badwordsList_t));
            if(this){
                this->next = svse.badwords;
                this->exactmatch = exactmatch;
                Q_strncpyz(this->word,linept,strlen(linept));
                svse.badwords = this;
            }
        }
}

char* censor_ignoreMultiple(char *output, char *string, size_t size)
{
	if(!output || !string) return NULL;
	if(size < strlen(string)){
	    Com_Error(ERR_FATAL,"censor_ignoreMultiple: buffer overflow");
	    return NULL;
	}

	char *ret = output;

	for(; *string; output++){
		*output = *string;
		do{
		    string++;
		}while(*output == *string && *string);
	}
	*output=0;
	return ret;
}


char* G_SayCensor(char *msg)
{
	char token2[1024];
	char token[1024];
	badwordsList_t *this;
	char* ret = msg;

	while(1){
		msg = Com_ParseGetToken(msg);
		if(msg==NULL)
			break;

		int size = Com_ParseTokenLength(msg);
		Q_strncpyz(token,msg,size+1);
		Q_CleanStr(token);
		CharConv(token2,token,sizeof(token2));//	'clear' token
		censor_ignoreMultiple(token,token2,sizeof(token));

		for(this = svse.badwords ; this ; this = this->next){
			if(this->exactmatch){
				if(!Q_stricmp(token2,this->word)){
					memset(msg,'*',size);
					break;
				}
			}else{
				if(strstr(token,this->word)!=NULL){
					memset(msg,'*',size);
					break;
				}
			}
		}
	}
	return ret;
}