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


// nothing outside the Cvar_*() functions should modify these fields!

typedef enum{
    CVAR_BOOL,
    CVAR_FLOAT,
    CVAR_VEC2,
    CVAR_VEC3,
    CVAR_VEC4,
    CVAR_INT,
    CVAR_ENUM,
    CVAR_STRING,
    CVAR_COLOR
}cvarType_t;



typedef struct{
	char *name;
	char *description;
	short int flags;
	byte type;
	byte modified;
	union{
		float floatval;
		int value;
		int integer;
		char* string;
		byte boolean;
		vec3_t vec3;
		vec4_t vec4;
	};
	union{
		float latchedfloatval;
		int latchedinteger;
		char* latchedstring;
		byte latchedboolean;
		vec3_t vec3_latched;
		vec4_t vec4_latched;
	};
	union{
		float resetfloatval;
		int resetinteger;
		char* resetstring;
		byte resetboolean;
		vec3_t vec3_reset;
		vec4_t vec4_reset;
	};
	int min;
	int max;
	int unknown3;
	int unknown4;
} cvar_t;


//Defines Cvarrelated functions inside executable file
typedef cvar_t* (__stdcall *tCvar_RegisterString)(const char *var_name, const char *var_value, int flags, const char *var_description);
tCvar_RegisterString Cvar_RegisterString = (tCvar_RegisterString)(0x81a2944);

typedef cvar_t* (__stdcall *tCvar_RegisterBool)(const char *var_name, qboolean var_value, int flags, const char *var_description);
tCvar_RegisterBool Cvar_RegisterBool = (tCvar_RegisterBool)(0x81a2d94);

typedef cvar_t* (__stdcall *tCvar_RegisterInt)(const char *var_name, int var_value, int min_value, int max_value, int flags, const char *var_description);
tCvar_RegisterInt Cvar_RegisterInt = (tCvar_RegisterInt)(0x81a2cc6);

typedef void (__stdcall *tCvar_SetInt)(cvar_t const* var, int val);
tCvar_SetInt Cvar_SetInt = (tCvar_SetInt)(0x81a20c4);

typedef void (__stdcall *tCvar_SetString)(cvar_t const* var, char const* string);
tCvar_SetString Cvar_SetString = (tCvar_SetString)(0x81a14fa);

typedef void (__stdcall *tCvar_Set_f)(void);
tCvar_Set_f Cvar_Set_f = (tCvar_Set_f)(0x8127a80);

typedef void (__stdcall *tCvar_SetS_f)(void);
tCvar_SetS_f Cvar_SetS_f = (tCvar_SetS_f)(0x8127ce8);

typedef void (__stdcall *tCvar_Toggle_f)(void);
tCvar_Toggle_f Cvar_Toggle_f = (tCvar_Toggle_f)(0x8126f5c);

typedef void (__stdcall *tCvar_TogglePrint_f)(void);
tCvar_TogglePrint_f Cvar_TogglePrint_f = (tCvar_TogglePrint_f)(0x8126f66);

typedef void (__stdcall *tCvar_SetA_f)(void);
tCvar_SetA_f Cvar_SetA_f = (tCvar_SetA_f)(0x8127c7c);

typedef void (__stdcall *tCvar_SetFromCvar_f)(void);
tCvar_SetFromCvar_f Cvar_SetFromCvar_f = (tCvar_SetFromCvar_f)(0x812746a);

typedef void (__stdcall *tCvar_SetFromLocalizedStr_f)(void);
tCvar_SetFromLocalizedStr_f Cvar_SetFromLocalizedStr_f = (tCvar_SetFromLocalizedStr_f)(0x8127842);

typedef void (__stdcall *tCvar_SetToTime_f)(void);
tCvar_SetToTime_f Cvar_SetToTime_f = (tCvar_SetToTime_f)(0x81273aa);

typedef void (__stdcall *tCvar_Reset_f)(void);
tCvar_Reset_f Cvar_Reset_f = (tCvar_Reset_f)(0x8127356);

typedef void (__stdcall *tCvar_List_f)(void);
tCvar_List_f Cvar_List_f = (tCvar_List_f)(0x8127306);

typedef void (__stdcall *tCvar_Dump_f)(void);
tCvar_Dump_f Cvar_Dump_f = (tCvar_Dump_f)(0x81272d2);

typedef void (__stdcall *tCvar_RegisterBool_f)(void);
tCvar_RegisterBool_f Cvar_RegisterBool_f = (tCvar_RegisterBool_f)(0x8126fc6);

typedef void (__stdcall *tCvar_RegisterInt_f)(void);
tCvar_RegisterInt_f Cvar_RegisterInt_f = (tCvar_RegisterInt_f)(0x81276aa);

typedef void (__stdcall *tCvar_RegisterFloat_f)(void);
tCvar_RegisterFloat_f Cvar_RegisterFloat_f = (tCvar_RegisterFloat_f)(0x812751a);

typedef void (__stdcall *tCvar_SetU_f)(void);
tCvar_SetU_f Cvar_SetU_f = (tCvar_SetU_f)(0x8127d54);

typedef int (__stdcall *tg_cvar_valueforkey)(char* key);
tg_cvar_valueforkey g_cvar_valueforkey = (tg_cvar_valueforkey)(0x819e90a);

typedef char* (__stdcall *tCvar_InfoString)(int unk, int bit);
tCvar_InfoString Cvar_InfoString = (tCvar_InfoString)(0x81264f4);

typedef void (__stdcall *tCvar_ForEach)(void (*callback)(cvar_t const*, void* passedhere), void* passback);
tCvar_ForEach Cvar_ForEach = (tCvar_ForEach)(0x819f328);

typedef char* (__stdcall *tCvar_DisplayableValue)(cvar_t const*);
tCvar_DisplayableValue Cvar_DisplayableValue = (tCvar_DisplayableValue)(0x819e2ac);

typedef char* (__stdcall *tCvar_GetVariantString)(const char* name);
tCvar_GetVariantString Cvar_GetVariantString = (tCvar_GetVariantString)(0x819e8cc);



//defines Cvarflags
#define	CVAR_ARCHIVE		1	// set to cause it to be saved to vars.rc
								// used for system variables, not for player
								// specific configurations
#define	CVAR_USERINFO		2	// sent to server on connect or change
#define	CVAR_SERVERINFO		4	// sent in response to front end requests
#define	CVAR_SYSTEMINFO		8	// these cvars will be duplicated on all clients
#define	CVAR_INIT			16	// don't allow change from console at all,
								// but can be set from the command line
#define	CVAR_LATCH			32	// will only change when C code next does
								// a Cvar_Get(), so it can't be changed
								// without proper initialization.  modified
								// will be set, even though the value hasn't
								// changed yet
#define	CVAR_ROM			64	// display only, cannot be set by user at all
#define	CVAR_USER_CREATED	128	// created by a set command
#define	CVAR_TEMP			256	// can be set even when cheats are disabled, but is not archived
#define CVAR_CHEAT			512	// can not be changed if cheats are disabled
#define CVAR_NORESTART		1024	// do not clear when a cvar_restart is issued








//This defines Cvars directly related to executable file
#define getcvaradr(adr) ((cvar_t*)(*(int*)(adr)))

#define sv_mapname getcvaradr(0x13ed8974)
#define sv_maxclients getcvaradr(0x13ed8960)
#define com_sv_running getcvaradr(0x88a61a8)
#define sv_reconnectlimit getcvaradr(0x13ed896c)
#define sv_minPing getcvaradr(0x13ed8980)
#define sv_maxPing getcvaradr(0x13ed8984)
#define sv_maxRate getcvaradr(0x13ed897c)
#define sv_privatePassword getcvaradr(0x13ed898c)
#define sv_privateClients getcvaradr(0x13ed8964)
#define sv_hostname getcvaradr(0x13ed8968)
#define g_gametype getcvaradr(0x84bcfe0)
#define sv_gametype getcvaradr(0x13ed89bc)
#define sv_pure getcvaradr(0x13ed89d0)
#define sv_voice getcvaradr(0x13ed8a08)
#define sv_fps getcvaradr(0x13ed8950)
#define g_password getcvaradr(0x84bcfe4)
#define fs_game getcvaradr(0x13f9da18)
#define fs_debug getcvaradr(0x13f9da00)
#define fs_basepath getcvaradr(0x13f9da08)
#define fs_homepath getcvaradr(0x13f9da04)
#define sv_punkbuster getcvaradr(0x13ed89cc)
#define com_developer getcvaradr(0x88a6184)
#define useFastfiles getcvaradr(0x88a6170)
#define com_logfile getcvaradr(0x88a61b0)
#define com_developer_script getcvaradr(0x88a6188)
#define sv_packet_info getcvaradr(0x13ed89f0)
#define sv_rconPassword getcvaradr(0x13ed8994)
#define com_dedicated getcvaradr(0x84bcfec)
#define sv_padPackets getcvaradr(0x13ed8970)
#define sv_allowDownload getcvaradr(0x13ed8990)
#define sv_wwwDownload getcvaradr(0x13ed8a18)
#define sv_wwwBaseURL getcvaradr(0x13ed8a1c)
#define sv_wwwDlDisconnected getcvaradr(0x13ed8a20)

#define g_TeamName_Allies getcvaradr(0x84bd090)
#define g_TeamName_Axis getcvaradr(0x84bd094)
//#define com_playerProfile getcvaradr(0x88e7394)

#define g_allowVote getcvaradr(0x84bd05c)
#define sv_serverid getcvaradr(0x13ed8978)
#define sv_mapRotation getcvaradr(0x13ed89f8)
#define sv_floodProtect getcvaradr(0x13ed89e4)

//Local Cvars defined for DLL only
static	cvar_t		*ModStats;
static	cvar_t		*sv_authorizemode;
static	cvar_t		*sv_showasranked;
static	cvar_t		*sv_statusfile;
static	cvar_t		*net_enabled;
cvar_t		*net_port;
cvar_t		*net_port6;
cvar_t		*net_ip;
cvar_t		*net_ip6;
cvar_t		*g_friendlyPlayerCanBlock;
cvar_t		*sv_autodemorecord;
cvar_t		*sv_demoCompletedCmd;