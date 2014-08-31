/*
===========================================================================
Copyright (C) 1999-2005 Id Software, Inc.

This file is part of Quake III Arena source code.

Quake III Arena source code is free software; you can redistribute it
and/or modify it under the terms of the GNU General Public License as
published by the Free Software Foundation; either version 2 of the License,
or (at your option) any later version.

Quake III Arena source code is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Quake III Arena source code; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
===========================================================================
*/

short   ShortSwap (short l)
{
	byte    b1,b2;

	b1 = l&255;
	b2 = (l>>8)&255;

	return (b1<<8) + b2;
}

short	ShortNoSwap (short l)
{
	return l;
}

int    LongSwap (int l)
{
	byte    b1,b2,b3,b4;

	b1 = l&255;
	b2 = (l>>8)&255;
	b3 = (l>>16)&255;
	b4 = (l>>24)&255;

	return ((int)b1<<24) + ((int)b2<<16) + ((int)b3<<8) + b4;
}

int	LongNoSwap (int l)
{
	return l;
}



int tolower( int c ) {
	if ( c >= 'A' && c <= 'Z' ) {
		c += 'a' - 'A';
	}
	return c;
}


int toupper( int c ) {
	if ( c >= 'a' && c <= 'z' ) {
		c += 'A' - 'a';
	}
	return c;
}


int Q_isprint( int c )
{
	if ( c >= 0x20 && c <= 0x7E )
		return ( 1 );
	return ( 0 );
}

int Q_islower( int c )
{
	if (c >= 'a' && c <= 'z')
		return ( 1 );
	return ( 0 );
}

int Q_isupper( int c )
{
	if (c >= 'A' && c <= 'Z')
		return ( 1 );
	return ( 0 );
}

int Q_isalpha( int c )
{
	if ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z'))
		return ( 1 );
	return ( 0 );
}

qboolean Q_isanumber( const char *s )
{
	char *p;

	if( *s == '\0' )
		return qfalse;

	strtod( s, &p );

	return *p == '\0';
}

qboolean Q_isintegral( float f )
{
	return (int)f == f;
}

qboolean Q_isprintstring( char* s ){
    char* a = s;
    while( *a ){
        if ( *a < 0x20 || *a > 0x7E ) return 0;
        a++;
    }
    return 1;
}






#ifdef _MSC_VER
/*
=============
Q_vsnprintf
 
Special wrapper function for Microsoft's broken _vsnprintf() function.
MinGW comes with its own snprintf() which is not broken.
=============
*/

int Q_vsnprintf(char *str, size_t size, const char *format, va_list ap)
{
	int retval;
	
	retval = _vsnprintf(str, size, format, ap);

	if(retval < 0 || retval == size)
	{
		// Microsoft doesn't adhere to the C99 standard of vsnprintf,
		// which states that the return value must be the number of
		// bytes written if the output string had sufficient length.
		//
		// Obviously we cannot determine that value from Microsoft's
		// implementation, so we have no choice but to return size.
		
		str[size - 1] = '\0';
		return size;
	}
	
	return retval;
}
#endif

/*
=============
Q_strncpyz
 
Safe strncpy that ensures a trailing zero
=============
*/
void Q_strncpyz( char *dest, const char *src, int destsize ) {

	if (!dest ) {
	    Com_Error( ERR_FATAL, "Q_strncpyz: NULL dest" );
	}
	if ( !src ) {
		Com_Error( ERR_FATAL, "Q_strncpyz: NULL src" );
	}
	if ( destsize < 1 ) {
		Com_Error(ERR_FATAL,"Q_strncpyz: destsize < 1" ); 
	}

	strncpy( dest, src, destsize-1 );
  dest[destsize-1] = 0;
}


int Q_stricmpn (const char *s1, const char *s2, int n) {
	int		c1, c2;

        if ( s1 == NULL ) {
           if ( s2 == NULL )
             return 0;
           else
             return -1;
        }
        else if ( s2==NULL )
          return 1;


	
	do {
		c1 = *s1++;
		c2 = *s2++;

		if (!n--) {
			return 0;		// strings are equal until end point
		}
		
		if (c1 != c2) {
			if (c1 >= 'a' && c1 <= 'z') {
				c1 -= ('a' - 'A');
			}
			if (c2 >= 'a' && c2 <= 'z') {
				c2 -= ('a' - 'A');
			}
			if (c1 != c2) {
				return c1 < c2 ? -1 : 1;
			}
		}
	} while (c1);
	
	return 0;		// strings are equal
}

int Q_strncmp (const char *s1, const char *s2, int n) {
	int		c1, c2;
	
	do {
		c1 = *s1++;
		c2 = *s2++;

		if (!n--) {
			return 0;		// strings are equal until end point
		}
		
		if (c1 != c2) {
			return c1 < c2 ? -1 : 1;
		}
	} while (c1);
	
	return 0;		// strings are equal
}

int Q_stricmp (const char *s1, const char *s2) {
	return (s1 && s2) ? Q_stricmpn (s1, s2, 99999) : -1;
}


char *Q_strlwr( char *s1 ) {
    char	*s;

    s = s1;
	while ( *s ) {
		*s = tolower(*s);
		s++;
	}
    return s1;
}

char *Q_strupr( char *s1 ) {
    char	*s;

    s = s1;
	while ( *s ) {
		*s = toupper(*s);
		s++;
	}
    return s1;
}

/*
=============
Q_bstrcpy

Same like strcpy but it does always a byte wise copying so source and destiantion can overlap
Use is to fix up a problem with Info_SetValueForKey() which happened on some newer machines
=============
*/


void Q_bstrcpy(char* dest, char* src){

    while(*src)
        *dest++ = *src++;

    *dest = 0;
}




// never goes past bounds or leaves without a terminating 0
void Q_strcat( char *dest, int size, const char *src ) {
	int		l1;

	l1 = strlen( dest );
	if ( l1 >= size ) {
		Com_Error( ERR_FATAL, "Q_strcat: already overflowed" );
	}
	Q_strncpyz( dest + l1, src, size - l1 );
}


/*
=============
Q_strlcat

Same like strcat but with an additional copylimit parameter
=============
*/
void Q_strlcat( char *dest, size_t size, const char *src, int cpylimit) {

	int		l1;

	l1 = strlen( dest );
	if ( l1 >= size ) {
		return;
//		Com_Error( ERR_FATAL, "Q_strlcat: already overflowed" );
	}

	if(cpylimit >= (size - l1) || cpylimit < 1){
		cpylimit = size - l1 -1;
	}

	memcpy( dest + l1, src, cpylimit);
	dest[l1 + cpylimit] = 0;
}

/*
=============
Q_strrepl
=============
*/
void Q_strnrepl( char *dest, size_t size, const char *src, const char* find, const char* replacement) {

    char* new;
    *dest = 0;

    int findlen = strlen(find);

    while((new = strstr(src, find)) != NULL){
        Q_strlcat(dest, size, src, new - src);
        Q_strlcat(dest, size, replacement, 0);
        src = &new[findlen];
    }
    Q_strlcat(dest, size, src, 0);
}


/*
* Find the first occurrence of find in s.
*/
const char *Q_stristr( const char *s, const char *find)
{
  char c, sc;
  size_t len;

  if ((c = *find++) != 0)
  {
    if (c >= 'a' && c <= 'z')
    {
      c -= ('a' - 'A');
    }
    len = strlen(find);
    do
    {
      do
      {
        if ((sc = *s++) == 0)
          return NULL;
        if (sc >= 'a' && sc <= 'z')
        {
          sc -= ('a' - 'A');
        }
      } while (sc != c);
    } while (Q_stricmpn(s, find, len) != 0);
    s--;
  }
  return s;
}


int  Q_strichr( const char *s, char find)
{
  char sc;
  int i = 0;

    if (find >= 'a' && find <= 'z')
    {
      find -= ('a' - 'A');
    }

    while(qtrue)
    {
        if ((sc = *s++) == 0)
          return -1;

        if(sc >= 'a' && sc <= 'z')
        {
          sc -= ('a' - 'A');
        }
        if(sc == find)
            return i;

        i++;
    }

    return -1;
}




int Q_PrintStrlen( const char *string ) {
	int			len;
	const char	*p;

	if( !string ) {
		return 0;
	}

	len = 0;
	p = string;
	while( *p ) {
		if( Q_IsColorString( p ) ) {
			p += 2;
			continue;
		}
		p++;
		len++;
	}

	return len;
}


char *Q_CleanStr( char *string ) {
	char*	d;
	char*	s;
	int		c;

	s = string;
	d = string;
	while ((c = *s) != 0 ) {
		if ( Q_IsColorString( s ) ) {
			s++;
		}		
		else if ( c >= 0x20 && c <= 0xFE ) {
			*d++ = c;
		}
		s++;
	}
	*d = '\0';

	return string;
}

int Q_CountChar(const char *string, char tocount)
{
	int count;
	
	for(count = 0; *string; string++)
	{
		if(*string == tocount)
			count++;
	}
	
	return count;
}

int QDECL Com_sprintf(char *dest, int size, const char *fmt, ...)
{
	int		len;
	va_list		argptr;

	va_start (argptr,fmt);
	len = Q_vsnprintf(dest, size, fmt, argptr);
	va_end (argptr);

	if(len >= size)
		Com_Printf("Com_sprintf: Output length %d too short, require %d bytes.\n", size, len + 1);
	
	return len;
}


/*
============
va

does a varargs printf into a temp buffer, so I don't need to have
varargs versions of all text functions.
============
*/
char	* QDECL va( char *format, ... ) {
	va_list		argptr;
	static char string[2][32000]; // in case va is called by nested functions
	static int	index = 0;
	char		*buf;

	buf = string[index & 1];
	index++;

	va_start (argptr, format);
	Q_vsnprintf (buf, sizeof(*string), format, argptr);
	va_end (argptr);

	return buf;
}

/*
============
Com_TruncateLongString

Assumes buffer is atleast TRUNCATE_LENGTH big
============
*/
void Com_TruncateLongString( char *buffer, const char *s )
{
	int length = strlen( s );

	if( length <= TRUNCATE_LENGTH )
		Q_strncpyz( buffer, s, TRUNCATE_LENGTH );
	else
	{
		Q_strncpyz( buffer, s, ( TRUNCATE_LENGTH / 2 ) - 3 );
		Q_strcat( buffer, TRUNCATE_LENGTH, " ... " );
		Q_strcat( buffer, TRUNCATE_LENGTH, s + length - ( TRUNCATE_LENGTH / 2 ) + 3 );
	}
}



/*
=====================================================================

  INFO STRINGS

=====================================================================
*/

/*
===================
Info_RemoveKey
===================
*/
void Info_RemoveKey( char *s, const char *key ) {
	char	*start;
	char	pkey[MAX_INFO_KEY];
	char	value[MAX_INFO_VALUE];
	char	*o;

	if ( strlen( s ) >= MAX_INFO_STRING ) {
		Com_Printf(  "Error: Info_RemoveKey: oversize infostring" );
	}

	if (strchr (key, '\\')) {
		return;
	}

	while (1)
	{
		start = s;
		if (*s == '\\')
			s++;
		o = pkey;
		while (*s != '\\')
		{
			if (!*s)
				return;
			*o++ = *s++;
		}
		*o = 0;
		s++;

		o = value;
		while (*s != '\\' && *s)
		{
			if (!*s)
				return;
			*o++ = *s++;
		}
		*o = 0;

		if (!strcmp (key, pkey) )
		{
			Q_bstrcpy(start, s);	// remove this part - Bugfix using Q_bstrcpy() instaed strcpy()
			return;
		}

		if (!*s)
			return;
	}

}


/*
===================
BigInfo_RemoveKey
===================
*/
void BigInfo_RemoveKey( char *s, const char *key ) {
	char	*start;
	char	pkey[BIG_INFO_KEY];
	char	value[BIG_INFO_VALUE];
	char	*o;

	if ( strlen( s ) >= BIG_INFO_STRING ) {
		Com_Printf(  "Error: BigInfo_RemoveKey: oversize infostring" );
	}

	if (strchr (key, '\\')) {
		return;
	}

	while (1)
	{
		start = s;
		if (*s == '\\')
			s++;
		o = pkey;
		while (*s != '\\')
		{
			if (!*s)
				return;
			*o++ = *s++;
		}
		*o = 0;
		s++;

		o = value;
		while (*s != '\\' && *s)
		{
			if (!*s)
				return;
			*o++ = *s++;
		}
		*o = 0;

		if (!strcmp (key, pkey) )
		{
			Q_bstrcpy(start, s);	// remove this part - Bugfix using Q_bstrcpy() instaed strcpy()
			return;
		}

		if (!*s)
			return;
	}

}


/*
===============
Info_ValueForKey

Searches the string for the given
key and returns the associated value, or an empty string.
FIXME: overflow check?
===============
*/
char *Info_ValueForKey( const char *s, const char *key ) {
	char	pkey[BIG_INFO_KEY];
	static	char value[2][BIG_INFO_VALUE];	// use two buffers so compares
						// work without stomping on each other
	static	int	valueindex = 0;
	char	*o;
	
	if ( !s || !key ) {
		return "";
	}

	if ( strlen( s ) >= BIG_INFO_STRING ) {
		Com_Printf(  "Error: Info_ValueForKey: oversize infostring" );
	}

	valueindex ^= 1;
	if (*s == '\\')
		s++;
	while (1)
	{
		o = pkey;
		while (*s != '\\')
		{
			if (!*s)
				return "";
			*o++ = *s++;
		}
		*o = 0;
		s++;

		o = value[valueindex];

		while (*s != '\\' && *s)
		{
			*o++ = *s++;
		}
		*o = 0;

		if (!Q_stricmp (key, pkey) )
			return value[valueindex];

		if (!*s)
			break;
		s++;
	}

	return "";
}

/*
==================
Info_SetValueForKey

Changes or adds a key/value pair
==================
*/
void Info_SetValueForKey( char *s, const char *key, const char *value ) {
	char	newi[MAX_INFO_STRING];

	if ( strlen( s ) >= MAX_INFO_STRING ) {
		Com_Printf(  "Error: Info_SetValueForKey: oversize infostring" );
	}

	if (strchr (key, '\\') || strchr (value, '\\'))
	{
		Com_Printf("Error: Can't use keys or values with a \\\n");
		return;
	}

	if (strchr (key, ';') || strchr (value, ';'))
	{
		Com_Printf("Error: Can't use keys or values with a semicolon\n");
		return;
	}

	if (strchr (key, '\"') || strchr (value, '\"'))
	{
		Com_Printf("Error: Can't use keys or values with a \"\n");
		return;
	}

	Info_RemoveKey (s, key);
	if (!value || !strlen(value))
		return;

	Com_sprintf (newi, sizeof(newi), "\\%s\\%s", key, value);

	if (strlen(newi) + strlen(s) > MAX_INFO_STRING)
	{
		Com_Printf( "Error: Info string length exceeded\n");
		return;
	}

	strcat (newi, s);
	strcpy (s, newi);
}



/*
==================
Info_SetValueForKey

Changes or adds a key/value pair
==================
*/
void BigInfo_SetValueForKey( char *s, const char *key, const char *value ) {
	char	newi[BIG_INFO_STRING];

	if ( strlen( s ) >= BIG_INFO_STRING ) {
		Com_Printf(  "Error: Info_SetValueForKey: oversize infostring" );
	}

	if (strchr (key, '\\') || strchr (value, '\\'))
	{
		Com_Printf("Error: Can't use keys or values with a \\\n");
		return;
	}

	if (strchr (key, ';') || strchr (value, ';'))
	{
		Com_Printf("Error: Can't use keys or values with a semicolon\n");
		return;
	}

	if (strchr (key, '\"') || strchr (value, '\"'))
	{
		Com_Printf("Error: Can't use keys or values with a \"\n");
		return;
	}

	BigInfo_RemoveKey (s, key);
	if (!value || !strlen(value))
		return;

	Com_sprintf (newi, sizeof(newi), "\\%s\\%s", key, value);

	if (strlen(newi) + strlen(s) > BIG_INFO_STRING)
	{
		Com_Printf( "Error: Info string length exceeded\n");
		return;
	}

	strcat (newi, s);
	strcpy (s, newi);
}


/*
============
Cmd_Argv
============
*/
static	int	cmd_argc;
static	char	*cmd_argv[MAX_STRING_TOKENS];	// points into cmd_tokenized

/*
============
Cmd_Argc_sv	Returns count of commandline arguments
============
*/
int	Cmd_Argc_sv( void ) {
	__asm__ (
	"mov	0x8879a40,%%eax			\n\t"
	"mov	0x8879a84(,%%eax,4), %%eax	\n\t"
	:"=a" (cmd_argc));
	return cmd_argc;
}

/*
============
Cmd_Argc	Returns count of commandline arguments
============
*/
int	Cmd_Argc( void ) {
	__asm__ (
	"mov	0x88799a0,%%eax			\n\t"
	"mov	0x88799e4(,%%eax,4), %%eax	\n\t"
	:"=a" (cmd_argc));
	return cmd_argc;
}


/*
============
Cmd_Argv	Returns commandline argument by number
============
*/

char	*Cmd_Argv_sv( int arg ) {
__asm__ (
	"mov	0x8879a40,%%eax			\n\t"
	"mov    $0x822be98,%%edx		\n\t"
	"cmpl   %%ecx,0x8879a84(,%%eax,4)	\n\t"
	"jle	notfound_sv			\n\t"
	"mov    0x8879aa4(,%%eax,4),%%eax	\n\t"
	"lea	(%%eax,%%ecx,4),%%edx		\n\t"
	"mov    0x4(%%eax),%%edx		\n\t"
	"lea	(%%eax,%%ecx,4),%%edx		\n\t"
	"mov	(%%edx),%%edx			\n\t"
	"notfound_sv:				\n\t"
	"					\n\t"
	:"=d" (*cmd_argv)
	:"c" (arg)
	:"eax"					);
	return (*cmd_argv);
}

/*
============
SV_Cmd_ArgvBuffer

The interpreted versions use this because
they can't have pointers returned to them
============
*/
void	SV_Cmd_ArgvBuffer( int arg, char *buffer, int bufferLength ) {
	Q_strncpyz( buffer, Cmd_Argv_sv(arg), bufferLength );
}


/*
============
Cmd_Argv	Returns commandline argument by number
============
*/

char	*Cmd_Argv( int arg ) {
__asm__ (
	"mov	0x88799a0,%%eax			\n\t"
	"mov    $0x00,%%edx			\n\t"
	"cmpl   %%ecx,0x88799e4(,%%eax,4)	\n\t"
	"jle	notfound			\n\t"
	"mov    0x8879a04(,%%eax,4),%%eax	\n\t" //?
	"lea	(%%eax,%%ecx,4),%%edx		\n\t"
	"mov	(%%edx),%%edx			\n\t"
	"notfound:				\n\t"
	"					\n\t"
	:"=d" (*cmd_argv)
	:"c" (arg)
	:"eax"					);
	if(*cmd_argv == NULL)
	    return "";

	else return (*cmd_argv);
}

/*
============
Cmd_Args

Returns a single string containing argv(1) to argv(argc()-1)
============
*/
char	*Cmd_Args_sv( void ) {
	static	char		cmd_args[MAX_STRING_CHARS];
	int		i;
	cmd_argc = Cmd_Argc_sv();
	cmd_args[0] = 0;
	for ( i = 1 ; i < cmd_argc ; i++ ) {
		strcat( cmd_args, Cmd_Argv_sv(i) );
		if ( i != cmd_argc-1 ) {
			strcat( cmd_args, " " );
		}
	}

	return cmd_args;
}

/*
============
Cmd_Argvs

Returns a single string containing argv(int arg) to argv(argc()-arg)
============
*/
char	*Cmd_Argsv_sv( int arg ) {
	static	char		cmd_args[MAX_STRING_CHARS];
	int		i;
	cmd_argc = Cmd_Argc_sv();
	cmd_args[0] = 0;
	for ( i = arg ; i < cmd_argc ; i++ ) {
		strcat( cmd_args, Cmd_Argv_sv(i) );
		if ( i != cmd_argc-1 ) {
			strcat( cmd_args, " " );
		}
	}

	return cmd_args;
}


/*
============
Cmd_Args

Returns a single string containing argv(arg) to argv(argc()-1)
============
*//*
char *Cmd_ArgsFrom( int arg ) {
	static	char		cmd_args[BIG_INFO_STRING];
	int		i;

	cmd_args[0] = 0;
	if (arg < 0)
		arg = 0;
	for ( i = arg ; i < cmd_argc ; i++ ) {
		strcat( cmd_args, cmd_argv[i] );
		if ( i != cmd_argc-1 ) {
			strcat( cmd_args, " " );
		}
	}

	return cmd_args;
}
*/
/*
============
Cmd_ArgsBuffer

The interpreted versions use this because
they can't have pointers returned to them
============
*//*
void	Cmd_ArgsBuffer( char *buffer, int bufferLength ) {
	Q_strncpyz( buffer, Cmd_Args(), bufferLength );
}
*/

/*
===============
SV_ExpandNewlines

Converts newlines to "\n" so a line prints nicer
===============
*/
char	*SV_ExpandNewlines( char *in ) {
	static	char	string[1024];
	int		l;

	l = 0;
	while ( *in && l < sizeof(string) - 3 ) {
		if ( *in == '\n' ) {
			string[l++] = '\\';
			string[l++] = 'n';
		} else {
			string[l++] = *in;
		}
		in++;
	}
	string[l] = 0;

	return string;
}



/*
=================
Search the memory given by buffer pointer for a set of patterns limited by memsize
Special feature: Don't care characters
=================
*/
//Pattern search function begin
patternseek_t	patternseek(unsigned const char *patternarray, int sizeofarray, unsigned const char *buffer, unsigned int memsize)
{
    unsigned char c1, c2;
    patternseek_t z;
    unsigned const char *s1 = patternarray;
    unsigned const char *s2 = buffer;
    char dontcare=0x66;
    int i;
    int j;


    if ( patternarray == NULL || buffer == NULL) {

	z.end = NULL;
	z.start = NULL;
	return z;
    }

   for(i=0, j=0 ; j < memsize; i++, j++){

        if(i >= sizeofarray){
            z.start = (s2-i+1);
            z.end = (s2+1);
            return z;
        }

	c1 = *s1++;
	c2 = *s2++;

	if(c1 == dontcare){
	    continue;
	} else if (c1 != c2){
	    s1 = patternarray;
	    i=0;
	    continue;
	}
   }//end for
   z.end = NULL;
   z.start = NULL;
   return z;
}
//Pattern search end


/*
============
Q_strchrrepl
Parses the string for a given char and replace it with a replacement char
============
*/
void Q_strchrrepl(char *string, char torepl, char repl){
    for(;*string != 0x00;string++){
	if(*string == torepl){
	    *string = repl;
	}
    }
}


//============================================================================

void Info_Print( const char *s ) {
	char	key[BIG_INFO_KEY];
	char	value[BIG_INFO_VALUE];
	char	*o;
	int		l;

	if (*s == '\\')
		s++;
	while (*s)
	{
		o = key;
		while (*s && *s != '\\')
			*o++ = *s++;

		l = o - key;
		if (l < 20)
		{
			Com_Memset (o, ' ', 20-l);
			key[20] = 0;
		}
		else
			*o = 0;
		Com_Printf ("%s ", key);

		if (!*s)
		{
			Com_Printf ("MISSING VALUE\n");
			return;
		}

		o = value;
		s++;
		while (*s && *s != '\\')
			*o++ = *s++;
		*o = 0;

		if (*s)
			s++;
		Com_Printf ("%s\n", value);
	}
}


/*****************************************************
*** Parsing files ***
*****************************************************/
static qboolean parse_inquotes = qfalse;
static char* parse_lastpos;

void Com_ParseReset(){

    parse_inquotes = qfalse;
    parse_lastpos = NULL;
}

char* Com_ParseGetToken(char* line){

    if(parse_lastpos == line){

        if(parse_inquotes){//In case we are inside quotes step until the end quote forward

            do{
                line++;
            }while(*line != '"' && *line != ';' && *line != '\n' && *line != '\0');

            parse_inquotes = qfalse;
        }

        while(*line != ' '){
            if(*line == '\0' || *line == '\n'){
                parse_inquotes = qfalse;
                parse_lastpos = NULL;
                return NULL;
            }
            line++;
        }


    }

    while(*line == ' ' || *line == ';'){
        if(*line == '\0' || *line == '\n'){
            parse_inquotes = qfalse;
            parse_lastpos = NULL;
            return NULL;
        }
        line++;
    }

    if(*line == '"'){ //Check if the next token is the beginning of a quoted string
        parse_inquotes = qtrue;
        line++;	//Move over the quotes character to the 1st real character
    }


    if(*line == '\0' || *line == '\n'){
        parse_inquotes = qfalse;
        parse_lastpos = NULL;
        return NULL;
    }

    parse_lastpos = line;
    return line;
}


int Com_ParseTokenLength(char* token){
    if(token == NULL) return 0;

    char* pos = token;
    int i = 0;
    if(parse_inquotes){//In case we are inside quotes
        while(*pos != '"' && *pos != ';' && *pos != '\n' && *pos != '\0'){
            pos++;
            i++;
        }

    }else{//Default case

        while(*pos != ' ' && *pos != ';' && *pos != '\n' && *pos != '\0'){
            pos++;
            i++;
        }
    }
    return i;
}



qboolean isNumeric(const char* string, int size){
    const char* ptr;
    int i;

    if(size > 0){ //If we have given a length compare the whole string

        for(i = 0, ptr = string; i < size; i++, ptr++){
            if(i == 0 && *ptr == '-') continue;
            if(*ptr < '0' || *ptr > '9') return qfalse;
        }

    } else { //Search until the 1st space otherwise or null otherwise

        for(i = 0, ptr = string; *ptr != ' '; i++, ptr++){
            if(i == 0 && *ptr == '-') continue;
            if(!*ptr && i > 0 && ptr[-1] != '-') return qtrue;
            if(*ptr < '0' || *ptr > '9') return qfalse;
        }
    }

    return qtrue;
}



/*
=====================================================================

 Functions to operate onto a stack in lifo mode

=====================================================================
*/

void stack_init(void *array[], size_t size){
    array[0] = (void*)((size_t)array+size );	//Moving the stackpointer in array[0] to top of stack
}

qboolean stack_push(void *array[], int size, void* pointer){
        void** base;

        if(array[0] == &array[1]) return qfalse;	//Stackoverflow
        array[0] -= sizeof(void*);

        base = *array;
        *base = pointer;
        return qtrue;
}

void* stack_pop(void *array[], int size){

    void** base;

    if(array[0] < (void*)((size_t)array+size )){
        base = *array;
        array[0] += sizeof(void*);
        return *base;
    }
    return NULL;	//Stack reached bottom
}


/*
=====================================================================

  Writing XML STRINGS

=====================================================================
*/

typedef struct{
    int		parents;
    qboolean	last;
    void *stack[48];
    char *buffer;
    size_t buffersize;
}xml_t;

/*
==================
XML_Init

Changes or adds a key/value pair
==================
*/

void XML_Init( xml_t *base, char *s, int size) {
	Com_Memset(base,0,sizeof(xml_t));
	base->buffer = s;
	base->buffersize = size;
	stack_init(base->stack,sizeof(base->stack));
	if ( 256 > size ) {
		Com_Printf(  "Error: XML_Init: too small infostring" );
	}
	Q_strncpyz(s,"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n\0",size);
}


/*
==================
XML_Escape
Changes or adds a key/value pair
==================
*/
void XML_Escape( char* buffer, size_t size, const char* string){
	int i;

	for(i = 7; i < size && *string != 0; i++, string++){

	    switch(*string){

                case '<':
                    strcpy(buffer, "&lt;");
                    buffer += 4;
                    break;
                case '>':
                    strcpy(buffer, "&gt;");
                    buffer += 4;
                    break;
                case '&':
                    strcpy(buffer, "&amp;");
                    buffer += 5;
                    break;
                case '"':
                    strcpy(buffer, "&quot;");
                    buffer += 6;
                    break;
                default:
                    *buffer = *string;
                    buffer++;
            }
        }
        *buffer = 0;
}




/*
==================
XML_OpenTag

Changes or adds a key/value pair
==================
*/
qboolean QDECL XML_OpenTag( xml_t *base, char* root, int count,... ) {

	char* key;
	char* value;
	char* s = base->buffer;
	size_t size = base->buffersize;
	char buffer[1024];
	char smallbuff[128];
	int i;

	buffer[0] = 0;
	Com_Memset(&smallbuff[1],' ',base->parents*6);
	smallbuff[0] = '\n';
	smallbuff[base->parents*6] = 0;
	Q_strcat(s,size,smallbuff);
	Com_sprintf(buffer,sizeof(buffer),"<%s ",root);
	if(!stack_push(base->stack,sizeof(base->stack),&s[strlen(s)+1])){
		XML_Init(base, s, size);
		return qfalse;
	}

	Q_strcat(s,size,buffer);
	va_list argptr;
	va_start(argptr, count);
	for(i=0;i < count;i++){
	    key = va_arg(argptr, char*);
	    value = va_arg(argptr, char*);
	    XML_Escape(smallbuff,sizeof(smallbuff),value);
	    Com_sprintf(buffer,sizeof(buffer),"%s=\"%s\" ",key,smallbuff);
	    Q_strcat(s,size,buffer);
	}
	va_end(argptr);
	Q_strcat(s,size,">\0");
	base->parents++;
	base->last = qtrue;
	return qtrue;
}

/*
==================
XML_CloseTag

Changes or adds a key/value pair
==================
*/
void XML_CloseTag(xml_t *base) {

	char buffer[256];
	char outbuffer[256];
	char preoffset[128];
	int i;
	char* s = base->buffer;
	size_t size = base->buffersize;
	char*	root;
	char*	stringptr = buffer;

	base->parents--;
	Com_Memset(&preoffset[1],' ',base->parents*6);
	preoffset[base->parents*6] = 0;
	preoffset[(base->parents*6)+1] = 0;

	root = stack_pop(base->stack,sizeof(base->stack));
	for(i=0 ;*root != ' ' && *root != 0 && i < sizeof(buffer); stringptr++, root++, i++) *stringptr = *root;
	*stringptr = 0;
	if(base->last){
		Com_sprintf(outbuffer,sizeof(outbuffer),"</%s>",buffer);
	}else{
		Com_sprintf(outbuffer,sizeof(outbuffer),"\n%s</%s>",&preoffset[1],buffer);
	}

	Q_strcat(s,size,outbuffer);
	base->last = qfalse;
}

//====================================================================

/*
==================
Com_CharIsOneOfCharset
==================
*/
static qboolean Com_CharIsOneOfCharset( char c, char *set )
{
	int i;

	for( i = 0; i < strlen( set ); i++ )
	{
		if( set[ i ] == c )
			return qtrue;
	}

	return qfalse;
}

/*
==================
Com_SkipCharset
==================
*/
char *Com_SkipCharset( char *s, char *sep )
{
	char	*p = s;

	while( p )
	{
		if( Com_CharIsOneOfCharset( *p, sep ) )
			p++;
		else
			break;
	}

	return p;
}

/*
==================
Com_SkipTokens
==================
*/
char *Com_SkipTokens( char *s, int numTokens, char *sep )
{
	int		sepCount = 0;
	char	*p = s;

	while( sepCount < numTokens )
	{
		if( Com_CharIsOneOfCharset( *p++, sep ) )
		{
			sepCount++;
			while( Com_CharIsOneOfCharset( *p, sep ) )
				p++;
		}
		else if( *p == '\0' )
			break;
	}

	if( sepCount == numTokens )
		return p;
	else
		return s;
}



char* Q_BitConv(int val){

	int i, j;
	static char buf[39];
	memset(buf,'?',sizeof(buf));

	for(j = 0, i = 38; i >= 0; i--){

		if((i+1) % 5 == 0 && i != 38 && i != 0){
			buf[i] = ' ';
		}else if(val & 1 << j){
			buf[i] = '1';
			j++;
		}else{
			buf[i] = '0';
			j++;
		}
	}
	buf[39] = 0;
	return buf;
}
