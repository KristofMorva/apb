#define SERVER_STRUCT_ADDR 0x13e78d00
#define sv (*((server_t*)(SERVER_STRUCT_ADDR)))

#define SERVERSTATIC_STRUCT_ADDR 0x90b4f80
#define svs (*((serverStatic_t*)(SERVERSTATIC_STRUCT_ADDR)))

#define SERVERHEADER_STRUCT_ADDR 0x13f18f80
#define svsHeader (*((svsHeader_t*)(SERVERHEADER_STRUCT_ADDR)))

#define ARCHIVEDSNAP_STRUCT_ADDR 0x10e98420
#define archivedSnapshot (*((archivedSnapshot_t*)(ARCHIVEDSNAP_STRUCT_ADDR)))

#define SERVERID_ADDR 0x8c51720
#define sv_serverId (*(int*)(SERVERID_ADDR))


typedef enum {
	CS_FREE,		// can be reused for a new connection
	CS_ZOMBIE,		// client has been disconnected, but don't reuse
				// connection for a couple seconds
	CS_CONNECTED,		// has been assigned to a client_t, but no gamestate yet
	CS_PRIMED,		// gamestate has been sent, but client hasn't sent a usercmd
	CS_ACTIVE		// client is fully in game
} clientState_t;


//*******************************************************************************

typedef struct {//(0x2146c);
	playerState_t		ps;			//0x2146c
	int			num_entities;
	int			num_clients;		// (0x2f68)
	int			first_entity;		// (0x2f6c)into the circular sv_packet_entities[]
	int			first_client;
							// the entities MUST be in increasing state number
							// order, otherwise the delta compression will fail
	int			messageSent;		// (0x243e0 | 0x2f74) time the message was transmitted
	int			messageAcked;		// (0x243e4 | 0x2f78) time the message was acked
	int			messageSize;		// (0x243e8 | 0x2f7c)   used to rate drop packets
	int			var_03;
} clientSnapshot_t;//size: 0x2f84


typedef struct {	//Not in use but it is kept here in case SV_CheckforResend will become in use in future
    char	msg[1024];
    netadr_t	destination;
    int		index;
    int		timeout;
}netsendbuffer_t;

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
	int			timeoutCount;		// must timeout a few frames in a row so debugging doesn't break
	int			deltaMessage;		// (0x8) frame last client usercmd message
	qboolean		rateDelayed;		// true if nextSnapshotTime was set based on rate instead of snapshotMsec
	netchan_t		netchan;	//(0x10)
	byte			entityNotSolid[MAX_GENTITIES / 8];//One bit for entity
	byte			entityInvisible[MAX_GENTITIES / 8];//One bit for entity
	fileHandle_t		demofile;
	qboolean		demorecording;
	qboolean		demowaiting;
	char			demoName[MAX_QPATH];
	int			demoArchiveIndex;
	int			demoMaxDeltaFrames;
	int			demoDeltaFrameCount;
	byte			free[1158];

	int			unknownUsercmd1;	//0x63c
	int			unknownUsercmd2;	//0x640
	int			unknownUsercmd3;	//0x644
	int			unknownUsercmd4;	//0x648

	int			var_01;		//0x64c
	char			userinfo[MAX_INFO_STRING];		// name, etc (0x650)
	reliableCommands_t	reliableCommands[MAX_RELIABLE_COMMANDS];	// (0xa50)
	int			reliableSequence;	// (0x20e50)last added reliable message, not necesarily sent or acknowledged yet
	int			reliableAcknowledge;	// (0x20e54)last acknowledged reliable message
	int			reliableSent;		// last sent reliable message, not necesarily acknowledged yet
	int			messageAcknowledge;	// (0x20e5c)
	int			gamestateMessageNum;	// (0x20e60) netchan->outgoingSequence of gamestate
	int			challenge; //0x20e64
//Unknown where the offset error is
	usercmd_t		lastUsercmd;		//(0x20e68)
	int			lastClientCommand;	//(0x20e88) reliable client message sequence
	char			lastClientCommandString[MAX_STRING_CHARS]; //(0x20e8c)
	sharedEntity_t		*gentity;		//(0x2128c)

	char			name[MAX_NAME_LENGTH];	//(0x21290) extracted from userinfo, high bits masked
	int			wwwDl_var01;
	// downloading
	char			downloadName[MAX_QPATH]; //(0x212a4) if not empty string, we are downloading
	fileHandle_t		download;		//(0x212e4) file being downloaded
 	int			downloadSize;		//(0x212e8) total bytes (can't use EOF because of paks)
 	int			downloadCount;		//(0x212ec) bytes sent
	int			downloadClientBlock;	//(0x212f0) last block we sent to the client, awaiting ack
	int			downloadCurrentBlock;	//(0x212f4) current block number
	int			downloadXmitBlock;	//(0x212f8) last block we xmited
	unsigned char		*downloadBlocks[MAX_DOWNLOAD_WINDOW];	//(0x212fc) the buffers for the download blocks
	int			downloadBlockSize[MAX_DOWNLOAD_WINDOW];	//(0x2131c)
	qboolean		downloadEOF;		//(0x2133c) We have sent the EOF block
	int			downloadSendTime;	//(0x21340) time we last got an ack from the client
	char			wwwDownloadURL[MAX_OSPATH]; //(0x21344) URL from where the client should download the current file

	qboolean		wwwDownload;		// (0x21444)
	qboolean		wwwDownloadStarted;	// (0x21448)
	qboolean		wwwDl_var02;		// (0x2144c)
	qboolean		wwwDl_var03;
	int			nextReliableTime;	// (0x21454) svs.time when another reliable command will be allowed
	int			floodprotect;		// (0x21458)
	int			lastPacketTime;		// (0x2145c)svs.time when packet was last received
	int			lastConnectTime;	// (0x21460)svs.time when connection started
	int			nextSnapshotTime;	// (0x21464) send another snapshot when svs.time >= nextSnapshotTime

//Unkown offsets
	int			unknown5;
	clientSnapshot_t	frames[PACKET_BACKUP];	// (0x2146c) updates can be delta'd from here
	int			ping;		//(0x804ec)
	int			rate;		//(0x804f0)		// bytes / second
	int			snapshotMsec;	//(0x804f4)	// requests a snapshot every snapshotMsec unless rate choked
	int			unknown6;
	int			pureAuthentic; 	//(0x804fc)
	byte			unsentBuffer[NETCHAN_UNSENTBUFFER_SIZE]; //(0x80500)
	byte			fragmentBuffer[NETCHAN_FRAGMENTBUFFER_SIZE]; //(0xa0500)
	char			pbguid[33]; //0xa0d00
	short			clscriptid; //0xa0d22
	int			canNotReliable; 
	int			serverId; //0xa0d28
	int			unknown7[2610];
	int			unknowndirectconnect1;//(0xa35f4)
	byte			mutedClients[64];
	byte			hasVoip;//(0xa3638)
	byte			stats[8192];		//(0xa3639)
	byte			receivedstats;		//(0xa5639)
	byte			dummy1;
	byte			dummy2;
} client_t;//0x0a563c

typedef enum {
    UN_VERIFYNAME,
    UN_NEEDUID,
    UN_OK
}username_t;


typedef enum{
	CAU_NEEDHWINFO,
	CAU_GOTGUIDHWINFO,
	CAU_REQUESTEDUID,
	CAU_GOTUID,
	CAU_REQUESTEDUSERINFO,
	CAU_GOTUSERINFO,
	CAU_GUIDUPDATED,
	CAU_FINISHED,
	CAU_BAD
}authorizeState_t;


typedef struct {
int		pbfailcounter;
int		authentication;
authorizeState_t	authstate;
qboolean	playerauthorized;
qboolean	uidRequestSent;
qboolean	userinfoRequestSent;
qboolean	guidupdated;
qboolean	noPb;
username_t	usernamechanged;
int		bantime;
int		clienttimeout;
int		uid;
char		OS;
int		power;
char		originguid[33];
char		hwinfo[662];
char		globalUserinfo[MAX_INFO_STRING];
//reliableCommands_t	reliableCommands[MAX_RELIABLE_COMMANDS];
}extclient_t;


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
} challenge_t;

#define	MAX_MASTER_SERVERS	6	// max recipients for heartbeat packets
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

#define BANLIST_PBGUID_LENGTH 9

typedef struct banList_s {
    time_t	expire;
    int		playeruid;
    int		adminuid;
    char	pbguid[BANLIST_PBGUID_LENGTH];
    char	reason[128];
    char	playername[MAX_NAME_LENGTH];
}banList_t;

typedef struct badwordsList_s {
    struct	badwordsList_s *next;
    qboolean	exactmatch;
    char	word[24];
}badwordsList_t;

typedef struct{
	int		currentCmdPower;			//used to set an execution permissionlevel - Default is 100 but if users execute commands it will be the users level
	int		currentCmdInvoker;			//used to set an Invoker UID - Default is 0 but if users execute commands it will be his own UID
	int		clientnum;
}cmdInvoker_t;

#define MAX_TRANSCMDS 32
typedef struct{
	char cmdname[32];
	char cmdargument[96];
}translatedCmds_t;



#include "uidsv.h"



/*

Some Info:
svs.nextSnapshotEntities 0x13f18f94
svs.numSnapshotEntites 0x13f18f8c
svc_snapshot = 6;
svs.snapflagServerbit 0x13f18f88  //copied from real svs. to something else

*/



typedef struct {
	qboolean	initialized;				// sv_init has completed

	int		time;					// will be strictly increasing across level changes

	int		snapFlagServerBit;			// ^= SNAPFLAG_SERVERCOUNT every SV_SpawnServer()

	client_t	clients[MAX_CLIENTS];				// [sv_maxclients->integer];



	int		numSnapshotEntities;		//0xba0de8c sv_maxclients->integer*PACKET_BACKUP*MAX_PACKET_ENTITIES
	int		numSnapshotClients;
	int		nextSnapshotEntities;		//0xba0de94 next snapshotEntities to use
	int		nextSnapshotClients;
/*	//entityState_t	*snapshotEntities;		// [numSnapshotEntities]
	int		nextHeartbeatTime;
	challenge_t	challenges[MAX_CHALLENGES];	// to prevent invalid IPs from connecting
	netadr_t	redirectAddress;			// for rcon return messages
	netadr_t	authorizeAddress;			// ??? for rcon return messages
	ipBanList_t	ipBans[1024];
	client_t	*redirectClient;		//used for SV_ExecuteRemoteControlCmd()
	cmdInvoker_t	cmdInvoker;
	qboolean	cmdSystemInitialized;
	int		secret;
//	cmdPower_t	cmdPower[MAX_POWERLIST];
	adminPower_t	*adminPower;
	banList_t	*banList;
	badwordsList_t	*badwords;
	translatedCmds_t	translatedCmd[MAX_TRANSCMDS];
	authserver_t	authserver;
	int		authorizeSVChallenge;
//	netsendbuffer_t	resendbuffer[256];*/
} serverStatic_t;


typedef struct {

	extclient_t	extclients[MAX_CLIENTS];				//Extendend custom clientstructure contains additional values about clients
	//int		numSnapshotEntities;		// sv_maxclients->integer*PACKET_BACKUP*MAX_PACKET_ENTITIES
	int		*nextSnapshotEntities;		// next snapshotEntities to use
	int		*nextSnapshotClients;
	//entityState_t	*snapshotEntities;		// [numSnapshotEntities]
	int		nextHeartbeatTime;
	int		feed;
	challenge_t	challenges[MAX_CHALLENGES];	// to prevent invalid IPs from connecting
	netadr_t	redirectAddress;			// for rcon return messages
	netadr_t	authorizeAddress;			// ??? for rcon return messages
	qboolean	serverAuth;
	ipBanList_t	ipBans[1024];
	client_t	*redirectClient;		//used for SV_ExecuteRemoteControlCmd()
	netadr_t	sysauthadr;
	cmdInvoker_t	cmdInvoker;
	qboolean	cmdSystemInitialized;
	int		secret;
//	cmdPower_t	cmdPower[MAX_POWERLIST];
	qboolean	serverBanned;
	adminPower_t	*adminPower;
	banList_t	*banList;
	int		authnum;
	badwordsList_t	*badwords;
	translatedCmds_t	translatedCmd[MAX_TRANSCMDS];
	seqclient_t	authserver;
	seqclient_t	scrMaster; //Used by cod4-script to establish a connection to a remote server
//	netsendbuffer_t	resendbuffer[256];
} serverStaticExt_t;


static		serverStaticExt_t	svse;				// persistant server info across maps


static		time_t realtime;

typedef enum {
	SS_DEAD,			// no map loaded
	SS_LOADING,			// spawning level entities
	SS_GAME				// actively running
} serverState_t;

typedef struct svEntity_s {//Everything is not validated except size
	struct svEntity_s *nextEntityInWorldSector;
	
	entityState_t		baseline;		// 0x04  for delta compression of initial sighting
	int			numClusters;		// if -1, use headnode instead
	int			clusternums[MAX_ENT_CLUSTERS];
	int			lastCluster;		// if all the clusters don't fit in clusternums
	int			areanum, areanum2;
	int			snapshotCounter;	// used to prevent double adding from portal views
	int			unk[11];
} svEntity_t; //size: 0x178



typedef struct {//0x13e78d00
	serverState_t		state;
	int			unknown;
	qboolean		restarting;			// if true, send configstring changes during SS_LOADING
	int			unknown2;// serverId; changes each server start
	int			unknown3;//restartedServerId;	serverId before a map_restart
	int			checksumFeed;// 0x14 the feed key that we use to compute the pure checksum strings
	// https://zerowing.idsoftware.com/bugzilla/show_bug.cgi?id=475
	// the serverId associated with the current checksumFeed (always <= serverId)
/*	int			checksumFeedServerId;	
	int			snapshotCounter;	// incremented for each snapshot built
	int			timeResidual;		// <= 1000 / sv_frame->value
	int			nextFrameTime;		// when time > nextFrameTime, process world
	struct cmodel_s		*models[MAX_MODELS];*/
	byte			unk[0x800];

	short			unkConfigIndex;		//0x13e79518
	short			configstringIndex[MAX_CONFIGSTRINGS]; //(0x13e7951a)

	short			unk3; //0x13e7a82e
	svEntity_t		svEntities[MAX_GENTITIES]; //0x1b30 (0x13e7a830) size: 0x5e000
/*
	char			*entityParsePoint;	// used during game VM init
*/
	// the game virtual machine will update these on init and changes
	sharedEntity_t		*gentities;	//0x5fb30  (0x13ed8830)
	int			gentitySize;	//0x5fb34  (0x13ed8834)
	int			num_entities;		// current number, <= MAX_GENTITIES

	playerState_t		*gameClients;		//0x5fb3c
	int			gameClientSize;		//0x5fb40 (13ed8840)will be > sizeof(playerState_t) due to game private data
/*
	int				restartTime;
	int				time;*/
	
	byte			unk2[92]; //0x5fb44
	int			var_01; //0x5fba0 (0x13ed88a0)
} server_t;


typedef struct{
	int number;
	byte b[0x60];
}clientState_s;



typedef struct{//13F18F80
	client_t		*clients;
	int			time;
	int			snapFlagServerBit;// ^= SNAPFLAG_SERVERCOUNT every SV_SpawnServer()
	int			numSnapshotEntities;	//0x13f18f8c sv_maxclients->integer*PACKET_BACKUP*MAX_PACKET_ENTITIES
	int			numSnapshotClients;
	int			nextSnapshotEntities;	//0x13f18f94 next snapshotEntities to use
	int			nextSnapshotClients;	//0x13f18f98
	entityState_t		*snapshotEntities;	//0x13f18f9c
	clientState_s		*snapshotClients;	//0x13f18fa0
	svEntity_t		*svEntities;		//0x13f18fa4
	int			unkBig[7];
	int			var_01;			//0x13f18fc4
	int			var_02;
	int			var_03;
	int			var_04;			//0x13f18fd0
}svsHeader_t;

typedef struct{
	int			var_01; //0x10e98420
	int			var_02; //0x10e98424
	int			var_03; //0x10e98428
	int			var_04; //0x10e9842c
	int			var_05; //0x10e98430
}archivedSnapshot_t;


typedef struct snapshotInfo_s{
	int clnum;
	client_t* cl;
	int var_01;
	qboolean var_02;
	byte var_03;
}snapshotInfo_t;



int SV_NumForGentity( sharedEntity_t *ent );
sharedEntity_t *SV_GentityNum( int num );
playerState_t *SV_GameClientNum( int num );
svEntity_t  *SV_SvEntityForGentity( sharedEntity_t *gEnt );
sharedEntity_t *SV_GEntityForSvEntity( svEntity_t *svEnt );

//
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

void SV_SendClientGameState(client_t *cl);

qboolean SV_Acceptclient(int);

void QDECL SV_SendServerCommand(client_t *cl, const char *fmt, ...);

void SV_PacketEvent( netadr_t from, msg_t *msg );

void SV_AddServerCommand( client_t *cl, int type, const char *cmd );

void SV_DropClient(client_t *drop, const char* reason);

void SV_ClientEnterWorld(client_t *cl, usercmd_t *cmd);

void Scr_SpawnBot(void);

char*	SV_IsGUID(char* guid);

void Cmd_PrintAdministrativeLog( const char* fmt,...);

void SV_WriteGameState(msg_t*, client_t*);

void SV_GetServerStaticHeader(void);

void SV_WriteDemoMessageForClient( byte *msg, int dataLen, client_t *client );

void SV_StopRecord( client_t *cl );

void SV_RecordClient( client_t* cl, char* basename );

void SV_DemoSystemShutdown( void );






//static qboolean SV_ClientCommand( client_t *cl, msg_t *msg, qboolean inDl);
