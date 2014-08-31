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
along with Foobar; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
===========================================================================
*/
// server.h

//#include "../game/q_shared.h"
//#include "../qcommon/qcommon.h"
//#include "../game/g_public.h"
//#include "../game/bg_public.h"

//=============================================================================

#include <time.h>


#ifndef __stdcall
#define __stdcall __attribute__((stdcall))
#endif

#ifndef QDECL
#define QDECL
#endif

#ifndef __fastcall
#define __fastcall __attribute__((fastcall))
#endif

#ifndef __regparm1
#define __regparm1 __attribute__((regparm(1)))
#endif

#ifndef __regparm2
#define __regparm2 __attribute__((regparm(2)))
#endif

#ifndef __regparm3
#define __regparm3 __attribute__((regparm(3)))
#endif

typedef unsigned 		char byte;
typedef enum {qfalse, qtrue}	qboolean; 

#define	MAX_ENT_CLUSTERS	16
#ifndef STDCALL
#define STDCALL __attribute__((stdcall))
#endif

// MAX_CHALLENGES is made large to prevent a denial
// of service attack that could cycle all of them
// out before legitimate users connected
#define	MAX_CHALLENGES	2048
// Allow a certain amount of challenges to have the same IP address
// to make it a bit harder to DOS one single IP address from connecting
// while not allowing a single ip to grab all challenge resources
#define MAX_CHALLENGES_MULTI (MAX_CHALLENGES / 2)



#define	MAX_STRING_TOKENS	1024	// max tokens resulting from Cmd_TokenizeString
#define	MAX_STRING_CHARS	1024
#define	AUTHORIZE_TIMEOUT	21000
#define	AUTHORIZE_TIMEOUT2	5000
#define DEDICATED

#ifndef Q_vsnprintf
#define Q_vsnprintf vsnprintf
#endif

#ifndef AUTHORIZE_SERVER_NAME
#define	AUTHORIZE_SERVER_NAME	"cod4master.activision.com"
#endif

#ifndef PORT_AUTHORIZE
#define	PORT_AUTHORIZE		20800
#endif

#define	PORT_SERVER		28960

#define CLIENT_BASE_ADDR 0x90b4f8C

#define Q3_VERSION "1.7"
#define GAME_STRING "CoD4 MP"

#define TIME_ADDR 0x90b4f84

#define SERVER_STRUCT_ADDR 0x13ed883c

#define RCON_RETURN_ADDR 0x13e78438

#define	MAX_MSGLEN	0x20000		// max length of a message, which may
#define	MAC_STATIC							// be fragmented into multiple packets

#define MAX_TOKEN_CHARS 1024

#define true '1'
#define false '0'
#define Q_COLOR_ESCAPE	'^'
#define Q_IsColorString(p)	( p && *(p) == Q_COLOR_ESCAPE && *((p)+1) && *((p)+1) != Q_COLOR_ESCAPE )

#define COLOR_BLACK		'0'
#define COLOR_RED		'1'
#define COLOR_GREEN		'2'
#define COLOR_YELLOW	'3'
#define COLOR_BLUE		'4'
#define COLOR_CYAN		'5'
#define COLOR_MAGENTA	'6'
#define COLOR_WHITE		'7'
#define ColorIndex(c)	( ( (c) - '0' ) & 7 )

#define S_COLOR_BLACK	"^0"
#define S_COLOR_RED		"^1"
#define S_COLOR_GREEN	"^2"
#define S_COLOR_YELLOW	"^3"
#define S_COLOR_BLUE	"^4"
#define S_COLOR_CYAN	"^5"
#define S_COLOR_MAGENTA	"^6"
#define S_COLOR_WHITE	"^7"

#define TRUNCATE_LENGTH	64
#define MAXPRINTMSG 4096

#define SV_OUTPUTBUF_LENGTH (2048 - 16)






/*

Some Info:
svs.nextSnapshotEntities 0x13f18f94
svs.numSnapshotEntites 0x13f18f8c
svc_snapshot = 6;
svs.snapflagServerbit 0x13f18f88  //copied from real svs. to something else




*/




// parameters to the main Error routine
typedef enum {
	ERR_FATAL,					// exit the entire game with a popup window
	ERR_DROP,					// print to console and disconnect from game
	ERR_SERVERDISCONNECT,		// don't kill server
	ERR_DISCONNECT,				// client disconnected from the server
	ERR_NEED_CD					// pop up the need-cd dialog
} errorParm_t;

//============================================================================

//
// msg.c
//
typedef struct {
	qboolean	overflowed;		//0x00
	qboolean	readonly;		//0x04
	byte		*data;			//0x08
	int		var_01;			//0x0c
	int		maxsize;		//0x10
	int		cursize;		//0x14
	int		var_02;			//0x18
	int		readcount;		//0x1c
	int		bit;			//0x20	// for bitwise reads and writes
	int		var_03;			//0x24
	int		var_04;			//0x28
} msg_t; //Size: 0x28


/*
==============================================================

NET

==============================================================
*/

#define NET_ENABLEV4            0x01
#define NET_ENABLEV6            0x02
// if this flag is set, always attempt ipv6 connections instead of ipv4 if a v6 address is found.
#define NET_PRIOV6              0x04
// disables ipv6 multicast support if set.
#define NET_DISABLEMCAST        0x08
#define	PORT_ANY		-1

typedef enum {
	NA_BAD = 0,					// an address lookup failed
	NA_BOT,
	NA_LOOPBACK,
	NA_BROADCAST,
	NA_IP,
	NA_IP6,
	NA_MULTICAST6,
	NA_UNSPEC,
	NA_DOWN
} netadrtype_t;

typedef enum {
	NS_CLIENT,
	NS_SERVER
} netsrc_t;

#define NET_ADDRSTRMAXLEN 48	// maximum length of an IPv6 address string including trailing '\0'

typedef struct {
	byte	type;
	byte	scope_id;
	unsigned short	port;
        union{
	    byte	ip[4];
	    byte	ipx[10];
	    byte	ip6[16];
	};
}netadr_t;


void		NET_Init( void );
void		NET_Shutdown( void );
void		NET_Restart_f( void );
void		NET_Config( qboolean enableNetworking );
void		NET_FlushPacketQueue(void);
void		NET_SendPacket (netsrc_t sock, int length, const void *data, netadr_t to);
void		QDECL NET_OutOfBandPrint( netsrc_t net_socket, netadr_t adr, const char *format, ...) __attribute__ ((format (printf, 3, 4)));
void		QDECL NET_OutOfBandData( netsrc_t sock, netadr_t adr, byte *format, int len );

qboolean	NET_CompareAdr (netadr_t a, netadr_t b);
qboolean	NET_CompareBaseAdrMask(netadr_t a, netadr_t b, int netmask);
qboolean	NET_CompareBaseAdr (netadr_t a, netadr_t b);
qboolean	NET_IsLocalAddress (netadr_t adr);
const char	*NET_AdrToString (netadr_t a);
const char	*NET_AdrToStringwPort (netadr_t a);
int		NET_StringToAdr ( const char *s, netadr_t *a, netadrtype_t family);
qboolean	NET_GetLoopPacket (netsrc_t sock, netadr_t *net_from, msg_t *net_message);
void		NET_JoinMulticast6(void);
void		NET_LeaveMulticast6(void);
void		NET_Sleep(int msec);
const char*	NET_AdrToStringShort(netadr_t adr);
const char*	NET_AdrToString(netadr_t adr);
const char*	NET_AdrMaskToString(netadr_t adr);
void		Sys_SendPacket( int length, const void *data, netadr_t to );

qboolean	Sys_StringToAdr( const char *s, netadr_t *a, netadrtype_t family );

//Does NOT parse port numbers, only base addresses.
qboolean	Sys_IsLANAddress (netadr_t adr);
void		Sys_ShowIP(void);


/*
==============================================================

MATHLIB

==============================================================
*/


typedef float vec_t;
typedef vec_t vec2_t[2];
typedef vec_t vec3_t[3];
typedef vec_t vec4_t[4];
typedef vec_t vec5_t[5];

typedef int fixed4_t;
typedef int fixed8_t;
typedef int fixed16_t;




// usercmd_t is sent to the server each client frame
typedef struct usercmd_s {//Not Known
	int			serverTime;
	int			angles[3];
	int 			buttons;
	byte			weapon;           // weapon 
	signed char	forwardmove, rightmove, upmove;
	int			unk[2];
} usercmd_t;



#define	MAX_INFO_STRING		1024
#define	MAX_INFO_KEY		1024
#define	MAX_INFO_VALUE		1024


#define	MAX_STRING_CHARS	1024	// max length of a string passed to Cmd_TokenizeString
#define	MAX_RELIABLE_COMMANDS	128	// max string commands buffered for restransmit
#define	MAX_NAME_LENGTH		16		// max length of a client name
#define	MAX_QPATH		64		// max length of a quake game pathname
#define MAX_DOWNLOAD_WINDOW	8		// max of eight download frames
#define MAX_DOWNLOAD_BLKSIZE	2048	// 2048 byte block chunks

#define	PROTOCOL_VERSION	6
#define	BIG_INFO_STRING		8192  // used for system info key only
#define	BIG_INFO_KEY		8192
#define	BIG_INFO_VALUE		8192

#define	MAX_MAP_AREA_BYTES	32
#define	PACKET_BACKUP		32

#define NETCHAN_UNSENTBUFFER_SIZE 0x20000
#define NETCHAN_FRAGMENTBUFFER_SIZE 0x800

#define LIBRARY_ADDRESS_BY_HANDLE(dlhandle)((NULL == dlhandle) ? NULL :(void*)*(size_t const*)(dlhandle))

#define Com_Memset memset
#define Com_Memcpy memcpy


#include "game.h"
#include "cvar.h"


struct entityState_s;
struct usercmd_s;

typedef struct {
	// sequencing variables
	int			outgoingSequence;
	netsrc_t		sock;
	int			dropped;			// between last packet and previous
	int			incomingSequence;

	//Remote address
	netadr_t		remoteAddress;			// (0x10)
	int			qport;				// qport value to write when transmitting (0x24)

	// incoming fragment assembly buffer
	int			fragmentSequence;
	int			fragmentLength;	
	byte			*fragmentBuffer; // (0x30)
	int			fragmentBufferSize;

	// outgoing fragment buffer
	// we need to space out the sending of large fragmented messages
	qboolean		unsentFragments;
	int			unsentFragmentStart;
	int			unsentLength;
	byte			*unsentBuffer; //(0x44)
	int			unsentBufferSize;
	int			notknown; //(0x4c)
} netchan_t;

typedef enum {
	CS_FREE,		// can be reused for a new connection
	CS_ZOMBIE,		// client has been disconnected, but don't reuse
				// connection for a couple seconds
	CS_CONNECTED,		// has been assigned to a client_t, but no gamestate yet
	CS_PRIMED,		// gamestate has been sent, but client hasn't sent a usercmd
	CS_ACTIVE		// client is fully in game
} clientState_t;



// bit field limits
#define	MAX_STATS				16
#define	MAX_PERSISTANT			16
#define	MAX_POWERUPS			16
#define	MAX_WEAPONS				16		

#define	MAX_PS_EVENTS			2

#define PS_PMOVEFRAMECOUNTBITS	6

#define MAX_MODELS 256
#define MAX_CONFIGSTRINGS 1024
#define GENTITYNUM_BITS 10
#define MAX_GENTITIES (1<<GENTITYNUM_BITS)


//*******************************************************************************

typedef struct {//(0x2146c);
	playerState_t		ps;			//0x2146c
	int			var_01;
	int			num_entities;		// (0x2f68)
	int			first_entity;		// (0x2f6c)into the circular sv_packet_entities[]
	int			var_02;
							// the entities MUST be in increasing state number
							// order, otherwise the delta compression will fail
	int			messageSent;		// (0x243e0 | 0x2f74) time the message was transmitted
	int			messageAcked;		// (0x243e4 | 0x2f78) time the message was acked
	int			messageSize;		// (0x243e8 | 0x2f7c)   used to rate drop packets
} clientSnapshot_t;


typedef struct {	//It is only for timelimited tempbans to prevent happy reconnecting and sitting in server for 2 minutes until player is detected or keep to advertise with playernick while reconnecting
    netadr_t	remote;
    char	banmsg[128];
    int		uid;	//Needed to delete or update bans
    int		timeout;
    int		expire;
    int		servertime;
    int		adminuid;
}ipBanList_t;

struct	sharedEntity_t;


typedef struct client_s {
	clientState_t		state;
	qboolean		rateDelayed;		// true if nextSnapshotTime was set based on rate instead of snapshotMsec
	int			deltaMessage;		// (0x8) frame last client usercmd message
	int			timeoutCount;		// must timeout a few frames in a row so debugging doesn't break
	netchan_t		netchan;	//(0x10)

	int			unknown1[380];	//0x5c

	char			userinfo[MAX_INFO_STRING];		// name, etc (0x650)
	char			reliableCommands[MAX_RELIABLE_COMMANDS][1024];  //(0xa50) Unknown the real size/members here
	int			nc_array_01[255];		//(0x20a50)
	int			nc_var_01;			// (0x20e4c)
	int			reliableSequence;	// (0x20e50)last added reliable message, not necesarily sent or acknowledged yet
	int			reliableAcknowledge;	// (0x20e54)last acknowledged reliable message
	int			reliableSent;		// last sent reliable message, not necesarily acknowledged yet
	int			messageAcknowledge;	// (0x20e5c)
	int			gamestateMessageNum;	// (0x20e60) netchan->outgoingSequence of gamestate
	int			challenge;
//Unknown where the offset error is
	usercmd_t		lastUsercmd;		//(0x20e68)
	int			lastClientCommand;	//(0x20e88) reliable client message sequence
	char			lastClientCommandString[MAX_STRING_CHARS]; //(0x20e8c)
	sharedEntity_t		*gentity;		//(0x2128c)

	char			name[MAX_NAME_LENGTH];	//(0x21290) extracted from userinfo, high bits masked
	int			unknown32;
	// downloading
	char			downloadName[MAX_QPATH]; //(0x212a4) if not empty string, we are downloading
/*	fileHandle_t		download;		// file being downloaded
 	int			downloadSize;		// total bytes (can't use EOF because of paks)
 	int			downloadCount;		// bytes sent
	int			downloadClientBlock;	// last block we sent to the client, awaiting ack
	int			downloadCurrentBlock;	// current block number
	int			downloadXmitBlock;	// last block we xmited
	unsigned char		*downloadBlocks[MAX_DOWNLOAD_WINDOW];	//(0x212fc) the buffers for the download blocks
	int			downloadBlockSize[MAX_DOWNLOAD_WINDOW];	//(0x2131c)
	qboolean		downloadEOF;		// We have sent the EOF block
	int			downloadSendTime;	// time we last got an ack from the client

	
*/
	int			unknown4[88];
	qboolean		wwwDownload;		// (0x21444)
	int			unknown23[3];
	int			nextReliableTime;	// (0x21454) svs.time when another reliable command will be allowed
	int			floodprotect;		// (0x21458)
	int			lastPacketTime;		// (0x2145c)svs.time when packet was last received
	int			lastConnectTime;	// (0x21460)svs.time when connection started
	int			nextSnapshotTime;	// (0x21464) send another snapshot when svs.time >= nextSnapshotTime

//Unkown offsets
	int			unknown5;
	clientSnapshot_t	frames[PACKET_BACKUP];	// (0x2146c) updates can be delta'd from here
	int			unknown43[32];		// (0x8046c)
	int			ping;		//(0x804ec)
	int			rate;		//(0x804f0)		// bytes / second
	int			snapshotMsec;	//(0x804f4)	// requests a snapshot every snapshotMsec unless rate choked
	int			unknown6;
	int			pureAuthentic; 	//(0x804fc)
	byte			unsentBuffer[NETCHAN_UNSENTBUFFER_SIZE]; //(0x80500)
	byte			fragmentBuffer[NETCHAN_FRAGMENTBUFFER_SIZE]; //(0xa0500)
	char			pbguid[33]; //0xa0d00
	short			clscriptid; //0xa0d22
	int			unknown10;
	int			unknownmessagebyte; //0xa0d28
	int			unknown7[2610];
	int			unknowndirectconnect1;//(0xa35f4)
	int			unknown8[16];
	byte			hasVoip;//(0xa3638)
	byte			stats[8192];		//(0xa3639)
	byte			receivedstats;		//(0xa5639)
	byte			dummy1;
	byte			dummy2;
} client_t;

typedef enum {
    UN_VERIFYNAME,
    UN_NEEDUID,
    UN_OK
}username_t;

typedef struct {
int		authentication;
qboolean	alldone;
qboolean	playerauthorized;
qboolean	guidupdated;
username_t	usernamechanged;
int		bantime;
int		clienttimeout;
int		mastertimeout;
int		pbsvslot;
int		uid;
char		OS;
int		power;
char		originguid[33];
} extclient_t;

typedef struct {
	netadr_t		adr;
	int			challenge;
	int			clientChallenge;
	int			time;				// time the last packet was sent to the autherize server
	int			pingTime;			// time the challenge response was sent to client
	int			firstTime;			// time the adr was first used, for authorize timeout checks
	char			pbguid[33];
	qboolean		connected;
	int			ipAuthorize;
	qboolean		wasrefused;
} challenge_t;

#define	MAX_MASTERS	8				// max recipients for heartbeat packets
// this structure will be cleared only when the game dll changes

typedef struct{
int	minPower;
char	command[33];
}cmdPower_t;

typedef struct adminPower_s {
    struct	adminPower_s *next;
    char	name[16];
    int	uid;
    int	power;
}adminPower_t;

typedef struct banList_s {
    struct	banList_s *next;
    time_t	expire;
    int		playeruid;
    int		adminuid;
    char	reason[128];
}banList_t;

typedef struct badwordsList_s {
    struct	badwordsList_s *next;
    qboolean	exactmatch;
    char	word[24];
}badwordsList_t;

typedef struct{
	int		currentCmdPower;			//used to set an execution permissionlevel - Default is 100 but if users execute commands it will be the users level
	int		currentCmdInvoker;			//used to set an execution permissionlevel - Default is 100 but if users execute commands it will be the users level
	int		clientnum;
}cmdInvoker_t;

typedef struct {
	qboolean	initialized;				// sv_init has completed

	int		*time;						// will be strictly increasing across level changes

	int		snapFlagServerBit;			// ^= SNAPFLAG_SERVERCOUNT every SV_SpawnServer()

	client_t	*clients;				// [sv_maxclients->integer];
	extclient_t	extclients[64];				//Extendend custom clientstructure contains additional values about clients
	
	int		numSnapshotEntities;		// sv_maxclients->integer*PACKET_BACKUP*MAX_PACKET_ENTITIES
	int		nextSnapshotEntities;		// next snapshotEntities to use
	//entityState_t	*snapshotEntities;		// [numSnapshotEntities]
	int		nextHeartbeatTime;
	challenge_t	challenges[MAX_CHALLENGES];	// to prevent invalid IPs from connecting
	netadr_t	redirectAddress;			// for rcon return messages
	netadr_t	authorizeAddress;			// ??? for rcon return messages
	netadr_t	authorizeAddress2;
	int		authorizeSVChallenge;
	ipBanList_t	ipBans[1024];
	client_t	*redirectClient;		//used for SV_ExecuteRemoteControlCmd()
	cmdInvoker_t	cmdInvoker;
	qboolean	cmdSystemInitialized;
	int		secret;
//	cmdPower_t	cmdPower[MAX_POWERLIST];
	adminPower_t	*adminPower;
	banList_t	*banList;
	badwordsList_t	*badwords;
//	netsendbuffer_t	resendbuffer[256];
} serverStatic_t;


//static char globalbuffer[8192];

typedef enum {
	SS_DEAD,			// no map loaded
	SS_LOADING,			// spawning level entities
	SS_GAME				// actively running
} serverState_t;


typedef struct svEntity_s {
	struct worldSector_s *worldSector;
	struct svEntity_s *nextEntityInWorldSector;
	
	entityState_t	baseline;		// for delta compression of initial sighting
	int			numClusters;		// if -1, use headnode instead
	int			clusternums[MAX_ENT_CLUSTERS];
	int			lastCluster;		// if all the clusters don't fit in clusternums
	int			areanum, areanum2;
	int			snapshotCounter;	// used to prevent double adding from portal views
} svEntity_t;


#define	MAX_MASTER_SERVERS	5
#define	MAX_REDIRECT_SERVERS	4
#define	MAX_CONNECTWAITTIME	10

#define NYT HMAX                    /* NYT = Not Yet Transmitted */
#define INTERNAL_NODE ( HMAX + 1 )

typedef struct nodetype {
	struct  nodetype *left, *right, *parent; /* tree structure */
	struct  nodetype *next, *prev; /* doubly-linked list */
	struct  nodetype **head; /* highest ranked node in block */
	int weight;
	int symbol;
} node_t;

#define HMAX 256 /* Maximum symbol */

typedef struct {
	int blocNode;
	int blocPtrs;

	node_t*     tree;
	node_t*     lhead;
	node_t*     ltail;
	node_t*     loc[HMAX + 1];
	node_t**    freelist;

	node_t nodeList[768];
	node_t*     nodePtrs[768];
} huff_t;

typedef struct {
	huff_t compressor;
	huff_t decompressor;
} huffman_t;

void    Huff_Compress( msg_t *buf, int offset );
void    Huff_Decompress( msg_t *buf, int offset );
void    Huff_Init( huffman_t *huff );
void    Huff_addRef( huff_t* huff, byte ch );
int     Huff_Receive( node_t *node, int *ch, byte *fin );
void    Huff_transmit( huff_t *huff, int ch, byte *fout );
void    Huff_offsetReceive( node_t *node, int *ch, byte *fin, int *offset );
void    Huff_offsetTransmit( huff_t *huff, int ch, byte *fout, int *offset );
void    Huff_putBit( int bit, byte *fout, int *offset );
int     Huff_getBit( byte *fout, int *offset );

extern huffman_t clientHuffTables;


// sv_client.c
//
void SV_GetChallenge( netadr_t from );

void SV_ChallengeResponse( int );

void SV_PBAuthChallengeResponse( int );

void SV_DirectConnect( netadr_t from );

void SV_Heartbeat_f( void );

//void SV_AuthorizeIpPacket( netadr_t from, const char *argstr, ...);

void SV_ExecuteClientCommand( client_t *cl, const char *s, qboolean clientOK );

void SV_WriteDownloadToClient( client_t *cl , msg_t *msg );

void SV_UserinfoChanged(client_t *cl);

qboolean Sys_RandomBytes( byte* string, int length );

char* Sys_ConsoleInput( void );

qboolean SV_Acceptclient(int);

void QDECL Com_Printf( const char *fmt, ... );

void QDECL Com_DPrintf( const char *fmt, ... );

void Com_BeginRedirect (char *buffer, int buffersize, void (*flush)( char *) );

void Com_EndRedirect (void);

void Sys_Print( const char* msg );

void QDECL SV_SendServerCommand(client_t *cl, const char *fmt, ...);

void SV_PacketEvent( netadr_t from, msg_t *msg );

//void Netchan_Init( int qport );
//void Netchan_Setup( netsrc_t sock, netchan_t *chan, netadr_t adr, int qport );

qboolean Netchan_Transmit( netchan_t *chan, int length, const byte *data );
void Netchan_TransmitNextFragment( netchan_t *chan );

qboolean Netchan_Process( netchan_t *chan, msg_t *msg );

void Plugin_Init(void);