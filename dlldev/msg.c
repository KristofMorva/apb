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


static huffman_t		msgHuff;

static qboolean			msgInit = qfalse;

int pcount[256];

static char bigstring[MAX_MSGLEN];

/*
==============================================================================

			MESSAGE IO FUNCTIONS

Handles byte ordering and avoids alignment errors
==============================================================================
*/

int oldsize = 0;

void MSG_initHuffman();



void MSG_Init( msg_t *buf, byte *data, int length ) {
	if (!msgInit) {
		MSG_initHuffman();
	}
	Com_Memset (buf, 0, sizeof(*buf));
	buf->data = data;
	buf->maxsize = length;
}

void MSG_Clear( msg_t *buf ) {
	buf->cursize = 0;
	buf->overflowed = qfalse;
	buf->bit = 0;					//<- in bits
}


void MSG_BeginReading( msg_t *msg ) {
	msg->overflowed = qfalse;
	msg->readcount = 0;
	msg->bit = 0;
}

void MSG_Copy(msg_t *buf, byte *data, int length, msg_t *src)
{
	if (length < src->cursize) {
		Com_Error( ERR_DROP, "MSG_Copy: can't copy into a smaller msg_t buffer");
	}
	Com_Memcpy(buf, src, sizeof(msg_t));
	buf->data = data;
	Com_Memcpy(buf->data, src->data, src->cursize);
}


//================================================================================

//
// writing functions
//


void MSG_WriteByte( msg_t *msg, int c ) {
#ifdef PARANOID
	if (c < 0 || c > 255)
		Com_Error (ERR_FATAL, "MSG_WriteByte: range error");
#endif
	byte* dst;

	if ( msg->maxsize - msg->cursize < 1 ) {
		msg->overflowed = qtrue;
		return;
	}
	dst = (byte*)&msg->data[msg->cursize];
	*dst = c;
	msg->cursize += sizeof(byte);
}


void MSG_WriteShort( msg_t *msg, int c ) {
#ifdef PARANOID
	if (c < ((short)0x8000) || c > (short)0x7fff)
		Com_Error (ERR_FATAL, "MSG_WriteShort: range error");
#endif
	signed short* dst;

	if ( msg->maxsize - msg->cursize < 2 ) {
		msg->overflowed = qtrue;
		return;
	}
	dst = (short*)&msg->data[msg->cursize];
	*dst = c;
	msg->cursize += sizeof(short);
}

void MSG_WriteLong( msg_t *msg, int c ) {
	int32_t *dst;

	if ( msg->maxsize - msg->cursize < 4 ) {
		msg->overflowed = qtrue;
		return;
	}
	dst = (int32_t*)&msg->data[msg->cursize];
	*dst = c;
	msg->cursize += sizeof(int32_t);
}

void MSG_WriteData( msg_t *buf, const void *data, int length ) {
	int i;
	for(i=0; i < length; i++){
		MSG_WriteByte(buf, ((byte*)data)[i]);
	}
}

void MSG_WriteString( msg_t *sb, const char *s ) {
	if ( !s ) {
		MSG_WriteData( sb, "", 1 );
	} else {
		int l;
		char string[MAX_STRING_CHARS];

		l = strlen( s );
		if ( l >= MAX_STRING_CHARS ) {
			Com_Printf( "MSG_WriteString: MAX_STRING_CHARS" );
			MSG_WriteData( sb, "", 1 );
			return;
		}
		Q_strncpyz( string, s, sizeof( string ) );

		MSG_WriteData( sb, string, l + 1 );
	}
}

void MSG_WriteBigString( msg_t *sb, const char *s ) {
	if ( !s ) {
		MSG_WriteData( sb, "", 1 );
	} else {
		int l;
		char string[BIG_INFO_STRING];

		l = strlen( s );
		if ( l >= BIG_INFO_STRING ) {
			Com_Printf( "MSG_WriteString: BIG_INFO_STRING" );
			MSG_WriteData( sb, "", 1 );
			return;
		}
		Q_strncpyz( string, s, sizeof( string ) );

		MSG_WriteData( sb, string, l + 1 );
	}
}

void MSG_WriteVector( msg_t *msg, vec3_t c ) {
	vec_t *dst;

	if ( msg->maxsize - msg->cursize < 12 ) {
		msg->overflowed = qtrue;
		return;
	}
	dst = (vec_t*)&msg->data[msg->cursize];
	dst[0] = c[0];
	dst[1] = c[1];
	dst[2] = c[2];
	msg->cursize += sizeof(vec3_t);
}


void MSG_WriteBit0( msg_t* msg )
{
	if(!((byte)msg->bit & 7)){
		if(msg->maxsize <= msg->cursize){
			msg->overflowed = qtrue;
			return;
		}
		msg->bit = msg->cursize*8;
		msg->data[msg->cursize] = 0;
		msg->cursize ++;
	}
	msg->bit++;
	return;
}

/*
void MSG_WriteBits(msg_t* msg, int value, int numBits )
{
	int		put;
	int		fraction;

	// check if the number of bits is valid
	if ( numBits == 0 || numBits < -31 || numBits > 32 ) {
		Com_Error( ERR_FATAL, "MSG_WriteBits: bad numBits %i", numBits );
	}

	// check for value overflows
	// this should be an error really, as it can go unnoticed and cause either bandwidth or corrupted data transmitted
	if ( numBits != 32 ) {
		if ( numBits > 0 ) {
			if ( value > ( 1 << numBits ) - 1 ) {
				Com_PrintWarning( "MSG_WriteBits: value overflow %d %d", value, numBits );
			} else if ( value < 0 ) {
				Com_PrintWarning( "MSG_WriteBits: value overflow %d %d", value, numBits );
			}
		} else {
			int r = 1 << ( - 1 - numBits );
			if ( value > r - 1 ) {
				Com_PrintWarning( "MSG_WriteBits: value overflow %d %d", value, numBits );
			} else if ( value < -r ) {
				Com_PrintWarning( "MSG_WriteBits: value overflow %d %d", value, numBits );
			}
		}
	}

	if ( numBits < 0 ) {
		numBits = -numBits;
	}

	// check for msg overflow
	if ( msg->maxsize - msg->cursize < 4 ) {
		msg->overflowed = qtrue;
		return;
	}

	// write the bits
	while( numBits ) {
//		if ( msg->bit == 0 ) {
		if ((msg->bit & 7) == 0 ) {
			msg->data[msg->cursize] = 0;
			msg->cursize++;
		}
		put = 8 - (msg->bit & 7);
		if ( put > numBits ) {
			put = numBits;
		}
		fraction = value & ( ( 1 << put ) - 1 );
		msg->data[msg->cursize - 1] |= fraction << (msg->bit & 7);
		numBits -= put;
		value >>= put;
		msg->bit = ( msg->bit + put )*//* & 7*/;
	/*}
}*/


//============================================================

//
// reading functions
//

// returns -1 if no more characters are available

int MSG_ReadByte( msg_t *msg ) {
	byte	*c;

	if ( msg->readcount+sizeof(byte) > msg->cursize ) {
		msg->readcount += sizeof(byte);
		return -1;
	}
	c = &msg->data[msg->readcount];

	msg->readcount += sizeof(byte);
	return *c;
}

int MSG_ReadShort( msg_t *msg ) {
	signed short	*c;

	if ( msg->readcount+sizeof(short) > msg->cursize ) {
		msg->readcount += sizeof(short);
		return -1;
	}	
	c = (short*)&msg->data[msg->readcount];

	msg->readcount += sizeof(short);
	return *c;
}

int MSG_ReadLong( msg_t *msg ) {
	int32_t		*c;

	if ( msg->readcount+sizeof(int32_t) > msg->cursize ) {
		msg->readcount += sizeof(int32_t);
		return -1;
	}	
	c = (int32_t*)&msg->data[msg->readcount];

	msg->readcount += sizeof(int32_t);
	return *c;

}


char *MSG_ReadString( msg_t *msg ) {
	int l,c;

	l = 0;
	do {
		c = MSG_ReadByte( msg );      // use ReadByte so -1 is out of bounds
		if ( c == -1 || c == 0 ) {
			break;
		}
		// translate all fmt spec to avoid crash bugs
		if ( c == '%' ) {
			c = '.';
		}
		bigstring[l] = c;
		l++;
	} while ( l < sizeof( bigstring ) - 1 );

	bigstring[l] = 0;

	return bigstring;
}

char *MSG_ReadStringLine( msg_t *msg ) {
	int		l,c;

	l = 0;
	do {
		c = MSG_ReadByte(msg);		// use ReadByte so -1 is out of bounds
		if (c == -1 || c == 0 || c == '\n') {
			break;
		}
		// translate all fmt spec to avoid crash bugs
		if ( c == '%' ) {
			c = '.';
		}
		bigstring[l] = c;
		l++;
	} while (l < sizeof(bigstring)-1);
	
	bigstring[l] = 0;
	
	return bigstring;
}

void MSG_ReadData( msg_t *msg, void *data, int len ) {
	int		i;

	for (i=0 ; i<len ; i++) {
		((byte *)data)[i] = MSG_ReadByte (msg);
	}
}

void MSG_ClearLastReferencedEntity( msg_t *msg ) {
	msg->lastRefEntity = -1;
}








int msg_hData[256] = {
250315,			// 0
41193,			// 1
6292,			// 2
7106,			// 3
3730,			// 4
3750,			// 5
6110,			// 6
23283,			// 7
33317,			// 8
6950,			// 9
7838,			// 10
9714,			// 11
9257,			// 12
17259,			// 13
3949,			// 14
1778,			// 15
8288,			// 16
1604,			// 17
1590,			// 18
1663,			// 19
1100,			// 20
1213,			// 21
1238,			// 22
1134,			// 23
1749,			// 24
1059,			// 25
1246,			// 26
1149,			// 27
1273,			// 28
4486,			// 29
2805,			// 30
3472,			// 31
21819,			// 32
1159,			// 33
1670,			// 34
1066,			// 35
1043,			// 36
1012,			// 37
1053,			// 38
1070,			// 39
1726,			// 40
888,			// 41
1180,			// 42
850,			// 43
960,			// 44
780,			// 45
1752,			// 46
3296,			// 47
10630,			// 48
4514,			// 49
5881,			// 50
2685,			// 51
4650,			// 52
3837,			// 53
2093,			// 54
1867,			// 55
2584,			// 56
1949,			// 57
1972,			// 58
940,			// 59
1134,			// 60
1788,			// 61
1670,			// 62
1206,			// 63
5719,			// 64
6128,			// 65
7222,			// 66
6654,			// 67
3710,			// 68
3795,			// 69
1492,			// 70
1524,			// 71
2215,			// 72
1140,			// 73
1355,			// 74
971,			// 75
2180,			// 76
1248,			// 77
1328,			// 78
1195,			// 79
1770,			// 80
1078,			// 81
1264,			// 82
1266,			// 83
1168,			// 84
965,			// 85
1155,			// 86
1186,			// 87
1347,			// 88
1228,			// 89
1529,			// 90
1600,			// 91
2617,			// 92
2048,			// 93
2546,			// 94
3275,			// 95
2410,			// 96
3585,			// 97
2504,			// 98
2800,			// 99
2675,			// 100
6146,			// 101
3663,			// 102
2840,			// 103
14253,			// 104
3164,			// 105
2221,			// 106
1687,			// 107
3208,			// 108
2739,			// 109
3512,			// 110
4796,			// 111
4091,			// 112
3515,			// 113
5288,			// 114
4016,			// 115
7937,			// 116
6031,			// 117
5360,			// 118
3924,			// 119
4892,			// 120
3743,			// 121
4566,			// 122
4807,			// 123
5852,			// 124
6400,			// 125
6225,			// 126
8291,			// 127
23243,			// 128
7838,			// 129
7073,			// 130
8935,			// 131
5437,			// 132
4483,			// 133
3641,			// 134
5256,			// 135
5312,			// 136
5328,			// 137
5370,			// 138
3492,			// 139
2458,			// 140
1694,			// 141
1821,			// 142
2121,			// 143
1916,			// 144
1149,			// 145
1516,			// 146
1367,			// 147
1236,			// 148
1029,			// 149
1258,			// 150
1104,			// 151
1245,			// 152
1006,			// 153
1149,			// 154
1025,			// 155
1241,			// 156
952,			// 157
1287,			// 158
997,			// 159
1713,			// 160
1009,			// 161
1187,			// 162
879,			// 163
1099,			// 164
929,			// 165
1078,			// 166
951,			// 167
1656,			// 168
930,			// 169
1153,			// 170
1030,			// 171
1262,			// 172
1062,			// 173
1214,			// 174
1060,			// 175
1621,			// 176
930,			// 177
1106,			// 178
912,			// 179
1034,			// 180
892,			// 181
1158,			// 182
990,			// 183
1175,			// 184
850,			// 185
1121,			// 186
903,			// 187
1087,			// 188
920,			// 189
1144,			// 190
1056,			// 191
3462,			// 192
2240,			// 193
4397,			// 194
12136,			// 195
7758,			// 196
1345,			// 197
1307,			// 198
3278,			// 199
1950,			// 200
886,			// 201
1023,			// 202
1112,			// 203
1077,			// 204
1042,			// 205
1061,			// 206
1071,			// 207
1484,			// 208
1001,			// 209
1096,			// 210
915,			// 211
1052,			// 212
995,			// 213
1070,			// 214
876,			// 215
1111,			// 216
851,			// 217
1059,			// 218
805,			// 219
1112,			// 220
923,			// 221
1103,			// 222
817,			// 223
1899,			// 224
1872,			// 225
976,			// 226
841,			// 227
1127,			// 228
956,			// 229
1159,			// 230
950,			// 231
7791,			// 232
954,			// 233
1289,			// 234
933,			// 235
1127,			// 236
3207,			// 237
1020,			// 238
927,			// 239
1355,			// 240
768,			// 241
1040,			// 242
745,			// 243
952,			// 244
805,			// 245
1073,			// 246
740,			// 247
1013,			// 248
805,			// 249
1008,			// 250
796,			// 251
996,			// 252
1057,			// 253
11457,			// 254
13504,			// 255
};




byte* MSG_ReadBitsCompress(const byte* input, byte* outputBuf, int readsize){

    readsize = readsize * 8;
    byte *outptr = outputBuf;

    int get;
    int offset;
    int i;

    if(readsize <= 0){
        return NULL;
    }

    for(offset = 0, i= 0; readsize > offset; i++){
        Huff_offsetReceive(/*msgHuff.decompressor.tree*/ *((node_t**)(0x89297e8)), &get, (byte*)input, &offset);
        *outptr = (byte)get;
        outptr++;
    }
    return (byte*)(outptr - outputBuf);
}



void MSG_initHuffman() {
	int i,j;

	msgInit = qtrue;
	Huff_Init(&msgHuff);
	for(i=0;i<256;i++) {
		for (j=0;j<msg_hData[i];j++) {
			Huff_addRef(&msgHuff.compressor,	(byte)i);			// Do update
			Huff_addRef(&msgHuff.decompressor,	(byte)i);			// Do update
		}
	}
}

/*
void MSG_NUinitHuffman() {
	byte	*data;
	int		size, i, ch;
	int		array[256];

	msgInit = qtrue;

	Huff_Init(&msgHuff);
	// load it in
	size = FS_ReadFile( "netchan/netchan.bin", (void **)&data );

	for(i=0;i<256;i++) {
		array[i] = 0;
	}
	for(i=0;i<size;i++) {
		ch = data[i];
		Huff_addRef(&msgHuff.compressor,	ch);			// Do update
		Huff_addRef(&msgHuff.decompressor,	ch);			// Do update
		array[ch]++;
	}
	Com_Printf("msg_hData {\n");
	for(i=0;i<256;i++) {
		if (array[i] == 0) {
			Huff_addRef(&msgHuff.compressor,	i);			// Do update
			Huff_addRef(&msgHuff.decompressor,	i);			// Do update
		}
		Com_Printf("%d,			// %d\n", array[i], i);
	}
	Com_Printf("};\n");
	FS_FreeFile( data );
	Cbuf_AddText( "condump dump.txt\n" );
}
*/

//===========================================================================



void MSG_WriteDeltaEntity(snapshotInfo_t* snap, msg_t* msg, int time, entityState_t* from, entityState_t* to, int arg_6){

    if(!to){
	MSG_WriteEntityIndex(snap, msg, from->number, 0x0a);
	MSG_WriteBit1(msg);
	return;
    }

    if( to->number < 64 && !g_friendlyPlayerCanBlock->boolean && OnSameTeam( &g_entities[to->number], &g_entities[snap->clnum]))
        to->solid = 1;



__asm__ __volatile__(
"	push   %edi\n"
"	push   %esi\n"
"	push   %ebx\n"
"	sub    $0x5c,%esp\n"

"	mov    0x18(%ebp),%eax\n"
"	mov    0x4(%eax),%edx\n"
"	mov    $0x11,%eax\n"
"	cmp    $0x11,%edx\n"
"	cmovle %edx,%eax\n"
"	shl    $0x3,%eax\n"
"	mov    0x82293c0(%eax),%edx\n"
"	mov    %edx,-0x40(%ebp)\n"
"	mov    0x82293c4(%eax),%eax\n"
"	mov    %eax,-0x38(%ebp)\n"
"	mov    0xc(%ebp),%eax\n"
"	mov    %eax,(%esp)\n"
"	mov    $0x81305fe, %eax\n"
"	call   *%eax\n"
"	mov    -0x38(%ebp),%eax\n"
"	test   %eax,%eax\n"
"	jle    MSG_WriteDeltaEntity_loc2\n"
"	mov    -0x40(%ebp),%edi\n"
"	movl   $0x0,-0x34(%ebp)\n"
"	movl   $0x0,-0x3c(%ebp)\n"

"MSG_WriteDeltaEntity_loc6:\n"
"	mov    0x4(%edi),%eax\n"
"	mov    0x8(%edi),%edx\n"
"	mov    0x14(%ebp),%ecx\n"
"	add    %eax,%ecx\n"
"	mov    0x18(%ebp),%esi\n"
"	add    %eax,%esi\n"
"	mov    (%ecx),%eax\n"
"	mov    %eax,-0x48(%ebp)\n"
"	mov    (%esi),%ebx\n"
"	cmp    %ebx,%eax\n"
"	je     MSG_WriteDeltaEntity_loc3\n"
"	add    $0x64,%edx\n"

"	test   %edx,%edx\n"
"	je     MSG_WriteDeltaEntity_case_0_13\n"
"	cmp    $0xd,%edx\n"
"	je     MSG_WriteDeltaEntity_case_0_13\n"

"	cmp    $0x5,%edx\n"
"	je     MSG_WriteDeltaEntity_case_5\n"
"	cmp    $0x8,%edx\n"
"	je     MSG_WriteDeltaEntity_case_8to10\n"
"	cmp    $0x9,%edx\n"
"	je     MSG_WriteDeltaEntity_case_8to10\n"
"	cmp    $0xa,%edx\n"
"	je     MSG_WriteDeltaEntity_case_8to10\n"

"	jmp    MSG_WriteDeltaEntity_case_default\n"





"MSG_WriteDeltaEntity_loc9:\n"
"	movl   $0xa,0xc(%esp)\n"
"	mov    0x18(%ebp),%edx\n"
"	mov    (%edx),%eax\n"
"	mov    %eax,0x8(%esp)\n"
"	mov    0xc(%ebp),%eax\n"
"	mov    %eax,0x4(%esp)\n"
"	mov    0x8(%ebp),%edx\n"
"	mov    %edx,(%esp)\n"
"	mov    $0x813de54, %eax\n"
"	call   *%eax\n"
"	mov    0xc(%ebp),%eax\n"
"	mov    %eax,(%esp)\n"
"	mov    $0x81306a4, %eax\n"
"	call   *%eax\n"
"	mov    0xc(%ebp),%edx\n"
"	mov    %edx,(%esp)\n"
"	mov    $0x81306a4, %eax\n"
"	call   *%eax\n"




"MSG_WriteDeltaEntity_loc11:\n"
"	mov    0xc(%ebp),%eax\n"
"	mov    %eax,(%esp)\n"
"	mov    $0x81305fe, %eax\n"
"	call   *%eax\n"
"	jmp    MSG_WriteDeltaEntity_term\n"




"MSG_WriteDeltaEntity_case_default:\n"
"	addl   $0x1,-0x34(%ebp)\n"
"	mov    -0x34(%ebp),%edx\n"
"	mov    %edx,-0x3c(%ebp)\n"
"	mov    %edx,%eax\n"
"	cmp    %eax,-0x38(%ebp)\n"
"	jle    MSG_WriteDeltaEntity_loc5\n"

"MSG_WriteDeltaEntity_loc7:\n"
"	add    $0x10,%edi\n"
"	jmp    MSG_WriteDeltaEntity_loc6\n"






"MSG_WriteDeltaEntity_case_5:\n"
"	mov    $0x51eb851f,%esi\n"
"	mov    -0x48(%ebp),%eax\n"
"	imul   %esi\n"
"	mov    %edx,%ecx\n"
"	sar    $0x5,%ecx\n"
"	mov    -0x48(%ebp),%eax\n"
"	sar    $0x1f,%eax\n"
"	sub    %eax,%ecx\n"
"	mov    %ebx,%eax\n"
"	imul   %esi\n"
"	sar    $0x5,%edx\n"
"	mov    %ebx,%eax\n"
"	sar    $0x1f,%eax\n"
"	sub    %eax,%edx\n"
"	xor    %eax,%eax\n"
"	cmp    %edx,%ecx\n"
"	sete   %al\n"

"MSG_WriteDeltaEntity_loc10:\n"
"	test   %eax,%eax\n"
"	je     MSG_WriteDeltaEntity_case_default\n"

"MSG_WriteDeltaEntity_loc3:\n"
"	addl   $0x1,-0x34(%ebp)\n"
"	mov    -0x34(%ebp),%eax\n"
"	cmp    %eax,-0x38(%ebp)\n"
"	jg     MSG_WriteDeltaEntity_loc7\n"

"MSG_WriteDeltaEntity_loc5:\n"
"	mov    -0x3c(%ebp),%eax\n"
"	test   %eax,%eax\n"
"	jne    MSG_WriteDeltaEntity_loc8\n"

"MSG_WriteDeltaEntity_loc2:\n"
"	mov    0x1c(%ebp),%eax\n"
"	test   %eax,%eax\n"
"	jne    MSG_WriteDeltaEntity_loc9\n"
"	jmp    MSG_WriteDeltaEntity_term\n"












"MSG_WriteDeltaEntity_case_8to10:\n"
"	flds   0x8209e08\n"
"	flds   (%ecx)\n"
"	fadd   %st(1),%st\n"
"	fnstcw -0x14(%ebp)\n"
"	movzwl -0x14(%ebp),%eax\n"
"	and    $0xf3,%ah\n"
"	or     $0x4,%ah\n"
"	mov    %ax,-0x12(%ebp)\n"
"	fldcw  -0x12(%ebp)\n"
"	frndint \n"
"	fxch   %st(1)\n"
"	fldcw  -0x14(%ebp)\n"
"	fadds  (%esi)\n"
"	fnstcw -0x12(%ebp)\n"
"	movzwl -0x12(%ebp),%eax\n"
"	and    $0xf3,%ah\n"
"	or     $0x4,%ah\n"
"	mov    %ax,-0x14(%ebp)\n"
"	fldcw  -0x14(%ebp)\n"
"	frndint \n"
"	fxch   %st(1)\n"
"	fldcw  -0x12(%ebp)\n"
"	fstpl  -0x28(%ebp)\n"
"	fldl   -0x28(%ebp)\n"
"	fnstcw -0x2a(%ebp)\n"
"	movzwl -0x2a(%ebp),%eax\n"
"	mov    $0xc,%ah\n"
"	mov    %ax,-0x2c(%ebp)\n"
"	fldcw  -0x2c(%ebp)\n"
"	fistpl -0x30(%ebp)\n"
"	fldcw  -0x2a(%ebp)\n"
"	mov    -0x30(%ebp),%edx\n"
"	fstpl  -0x28(%ebp)\n"
"	fldl   -0x28(%ebp)\n"
"	fldcw  -0x2c(%ebp)\n"
"	fistpl -0x30(%ebp)\n"
"	fldcw  -0x2a(%ebp)\n"
"	mov    -0x30(%ebp),%eax\n"
"	cmp    %eax,%edx\n"
"	sete   %al\n"
"	movzbl %al,%eax\n"
"	jmp    MSG_WriteDeltaEntity_loc10\n"



"MSG_WriteDeltaEntity_case_0_13:\n"
"	flds   0x8224f7c\n"
"	flds   (%ecx)\n"
"	fmul   %st(1),%st\n"
"	flds   0x8209e08\n"
"	fadd   %st,%st(1)\n"
"	fxch   %st(1)\n"
"	fstps  -0x44(%ebp)\n"
"	fxch   %st(1)\n"
"	movss  -0x44(%ebp),%xmm0\n"
"	cvttss2si %xmm0,%edx\n"
"	fmuls  (%esi)\n"
"	faddp  %st,%st(1)\n"
"	fstps  -0x44(%ebp)\n"
"	movss  -0x44(%ebp),%xmm0\n"
"	cvttss2si %xmm0,%eax\n"
"	cmp    %dx,%ax\n"
"	sete   %al\n"
"	movzbl %al,%eax\n"
"	jmp    MSG_WriteDeltaEntity_loc10\n"












"MSG_WriteDeltaEntity_loc8:\n"
"	movl   $0xa,0xc(%esp)\n"
"	mov    0x18(%ebp),%edx\n"
"	mov    (%edx),%eax\n"
"	mov    %eax,0x8(%esp)\n"
"	mov    0xc(%ebp),%eax\n"
"	mov    %eax,0x4(%esp)\n"
"	mov    0x8(%ebp),%edx\n"
"	mov    %edx,(%esp)\n"
"	mov    $0x813de54, %eax\n"
"	call   *%eax\n"
"	mov    0xc(%ebp),%eax\n"
"	mov    %eax,(%esp)\n"
"	mov    $0x81306a4, %eax\n"
"	call   *%eax\n"
"	mov    0xc(%ebp),%edx\n"
"	mov    %edx,(%esp)\n"
"	mov    $0x81306dc, %eax\n"
"	call   *%eax\n"
"	mov    -0x38(%ebp),%eax\n"
"	mov    %eax,(%esp)\n"
"	mov    $0x8130500, %eax\n"
"	call   *%eax\n"
"	mov    %eax,0x8(%esp)\n"
"	mov    -0x3c(%ebp),%edx\n"
"	mov    %edx,0x4(%esp)\n"
"	mov    0xc(%ebp),%eax\n"
"	mov    %eax,(%esp)\n"
"	mov    $0x813061c, %eax\n"
"	call   *%eax\n"
"	mov    -0x3c(%ebp),%eax\n"
"	test   %eax,%eax\n"
"	jle    MSG_WriteDeltaEntity_loc11\n"
"	xor    %ebx,%ebx\n"

"MSG_WriteDeltaEntity_loc12:\n"
"	movl   $0x0,0x10(%esp)\n"
"	mov    %ebx,0xc(%esp)\n"
"	mov    -0x40(%ebp),%edx\n"
"	mov    %edx,0x8(%esp)\n"
"	mov    0x18(%ebp),%eax\n"
"	mov    %eax,0x4(%esp)\n"
"	mov    0x14(%ebp),%edx\n"
"	mov    %edx,(%esp)\n"
"	mov    0x10(%ebp),%ecx\n"
"	mov    0xc(%ebp),%edx\n"
"	mov    0x8(%ebp),%eax\n"
"	mov    $0x813e22a, %esi\n"
"	call   *%esi\n"
"	add    $0x1,%ebx\n"
"	addl   $0x10,-0x40(%ebp)\n"
"	cmp    %ebx,-0x3c(%ebp)\n"
"	jne    MSG_WriteDeltaEntity_loc12\n"
"	jmp    MSG_WriteDeltaEntity_loc11\n"


"MSG_WriteDeltaEntity_term:\n"
"	add    $0x5c,%esp\n"
"	pop    %ebx\n"
"	pop    %esi\n"
"	pop    %edi\n");

}
