/*
===========================================================================

Return to Castle Wolfenstein multiplayer GPL Source Code
Copyright (C) 1999-2010 id Software LLC, a ZeniMax Media company. 

This file is part of the Return to Castle Wolfenstein multiplayer GPL Source Code (RTCW MP Source Code).  

RTCW MP Source Code is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

RTCW MP Source Code is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with RTCW MP Source Code.  If not, see <http://www.gnu.org/licenses/>.

In addition, the RTCW MP Source Code is also subject to certain additional terms. You should have received a copy of these additional terms immediately following the terms and conditions of the GNU General Public License which accompanied the RTCW MP Source Code.  If not, please request a copy in writing from id Software at the address below.

If you have questions concerning this license or the applicable additional terms, you may contact in writing id Software LLC, c/o ZeniMax Media Inc., Suite 120, Rockville, Maryland 20850 USA.

===========================================================================
*/

#define NEXT_RELIABLE_TIME 366
#define CONNECTION_TIMEOUT 20000
#define AUTHSERVER_PROTOCOL_VERSION 11
#define RETRANSMIT_TIMEOUT 3
#define HEARTBEAT_TIME 2000000


typedef enum {
	CA_DISCONNECTED,    // not talking to a server
	CA_CHALLENGING,     // sending challenge packets to the server
	CA_CONNECTING,      // sending request packets to the server
	CA_CONNECTED       // netchan_t established, getting gamestate
} connstate_t;

enum {
	QT_AUTHINFO,
	QT_CMDQUERY
};


#define ENCRYPTIONKEY_LEN 65

typedef struct seqclient_s{
	connstate_t	state;
	netchan_t	netchan;
	netadr_t	connectAddress;
	int		clchallenge;
	int		svchallenge;
	int		connectPacketCount;
	int		lastPacketSentTime;                 // for retransmits during connection
	int		lastPacketTime;                     // for timeouts
	int		connectionTimeout;
	int		connectTime;                        // for connection retransmits
	// these are our reliable messages that go to the server
	int		reliableSequence;
	int		reliableAcknowledge;                // the last one the server has executed
	int		reliableSent;                       // Last reliable message the server has sent
	// TTimo - NOTE: incidentally, reliableCommands[0] is never used (always start at reliableAcknowledge+1)
	char		reliableCommands[MAX_RELIABLE_COMMANDS][MAX_TOKEN_CHARS];

	int		messageAcknowledge;
	int		serverId;
	// server message (unreliable) and command (reliable) sequence
	// numbers are NOT cleared at level changes, but continue to
	// increase as long as the connection is valid

	// message sequence is used by both the network layer and the
	// delta compression layer
	int		serverMessageSequence;
	// reliable messages received from server
	int		serverCommandSequence;
	char		serverCommands[MAX_RELIABLE_COMMANDS][MAX_TOKEN_CHARS];
	char		encryptionKey[ENCRYPTIONKEY_LEN];
	char		lastEncryptSha[65];
	char		decryptionKey[ENCRYPTIONKEY_LEN];
	char		lastDecryptSha[65];
	byte		unsentBuffer[NETCHAN_UNSENTBUFFER_SIZE];
	byte		fragmentBuffer[MAX_MSGLEN];
	char		connectKey[36];
	qboolean (*commandHandler)( char* s);
}seqclient_t;

typedef enum{
	disconnect_neverreconnect,
	disconnect_reconnect
}disconnectType_t;

void CL_SendMessage( seqclient_t* clq, msg_t *msg );

void CL_AddReliableCommand( seqclient_t* clq, const char *cmd );

void CL_ChangeReliableCommand( seqclient_t* clq );

void CL_Disconnect( seqclient_t* clq, disconnectType_t type );

qboolean CL_ExecuteAuthserverCommand(char* cmd);

void SV_SendBroadcastMessage( const char *message);

void SV_SendBroadcastTempban( int uid, int auid, const char *reason, const char *duration, const char* name);

void SV_SendBroadcastPermban( int uid, int auid, const char *reason, const char* name);

void SV_SendBroadcastUnban( int uid, int auid );

#define CLIENT_TIMEOUT 5 //How many attempts we give him time to provide the desired hardware GUIDs
#define MASTER_TIMEOUT 120*1000
//#define PBCLIENT_AUTH_FAILED_WIN "\n^7Authorization failed:\nYour Key Code is in use or invalid and one of this is true:\n\n1. Your computer has no harddiskdrive\n2. You use a RAID system\n3. You are unlucky... Try again\n\nAs we couldn't determine who you are you have been rejected from this server. If you can't solve this problem by reconnecting you will have to buy a ^2valid Key Code ^7to play onto this server.\nIf you own already a valid Key Code, your Key Code is in use"
#define PBCLIENT_AUTH_FAILED_WIN "EXE_ERR_CDKEY_IN_USE"
#define AUTH_FAILED_MASTER "EXE_ERR_CDKEY_IN_USE"
#define PBCLIENT_AUTH_FAILED_MAC "\n^7Authorization failed:\nYour Key Code is in use or invalid and you are using a Mac.\nWe couldn't determine who you are so you have been rejected from server.\nTo be able to play onto this server you will have to either\nbuy a ^2valid Key Code ^7or\n using Windows instead Mac OS X.\nIf you have already a valid Key Code, your Key Code is in use"
#define PBCLIENT_AWAIT_AUTH "^5Awaiting authorization..."
#define PBCLIENT_AUTH_SUCCESS1 "^2Authorization Sucessfull\n^2You are player number"
#define PBCLIENT_AUTH_SUCCESS2 "^2Your server assigned GUID is:"