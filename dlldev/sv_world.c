
typedef struct {
//	vec3_t boxmins, boxmaxs;	// enclose the test object along entire move
	vec3_t mins;	//0x00
	vec3_t maxs;	//0x0c size of the moving object
	vec3_t var_01;
	vec3_t start;	//0x24
	vec3_t end;	//0x30
	vec3_t var_02;
	int passEntityNum;  //0x48
	int passOwnerNum;   //0x4c
	int contentmask;    //0x50
	int capsule;
} moveclip_t;






void SV_ClipMoveToEntity(moveclip_t *clip, svEntity_t *entity, trace_t *trace){

	sharedEntity_t *touch;
	int		touchNum;
	float		*origin, *angles;
	vec3_t		mins, maxs;
	float		oldfraction;
	clipHandle_t	clipHandle;

	touchNum = entity - sv.svEntities;

	touch = SV_GentityNum( touchNum );

	if( !(clip->contentmask & touch->r.contents))
		return;

	if ( clip->passEntityNum != ENTITYNUM_NONE ) {

		if( touchNum == clip->passEntityNum )
			return;

		if(touch->r.ownerNum){

			if( touch->r.ownerNum - 1 == clip->passEntityNum )
			    return;


			if( touch->r.ownerNum - 1 == clip->passOwnerNum )
			    return;
		}


		if(clip->passEntityNum < 64 && clip->contentmask & CONTENTS_PLAYERCLIP && !g_friendlyPlayerCanBlock->boolean){
			if(touchNum < 64){
				if(OnSameTeam( &g_entities[clip->passEntityNum], &g_entities[touchNum]))
				    return;
			}else if(touch->r.ownerNum -1 < 64 && touch->r.contents & CONTENTS_PLAYERCLIP){
				if(OnSameTeam( &g_entities[clip->passEntityNum], &g_entities[touch->r.ownerNum -1]))
				    return;
			}
		}
		
/*		if(clip->passEntityNum < 64 && touch->r.ownerNum < 64){
			char temp1[48];
			char temp2[48];
			Q_strncpyz(temp1, Q_BitConv(clip->contentmask), sizeof(temp1));
			Q_strncpyz(temp2, Q_BitConv(touch->r.contents), sizeof(temp2));

			Com_Printf("EntityNum: %i O. EntityNum: %i Content s.: %s Content o.: %s t.: %i owns. %i owno: %i\n", 
			clip->passEntityNum , touchNum, temp1, temp2, OnSameTeam( &g_entities[clip->passEntityNum], &g_entities[touch->r.ownerNum]),clip->passOwnerNum ,touch->r.ownerNum -1);
		}*/
	}


	VectorAdd(touch->r.absmin, clip->mins, mins);
	VectorAdd(touch->r.absmax, clip->maxs, maxs);

	if(CM_TraceBox(clip->start, mins, maxs, trace->fraction))
		return;
	
	if(!touch->r.bmodel)
		clipHandle = CM_TempBoxModel(touch->r.mins, touch->r.maxs, touch->r.contents);
	else
		clipHandle = touch->s.modelindex;

	origin = touch->r.currentOrigin;
	angles = touch->r.currentAngles;

	if ( !touch->r.bmodel ) {
		angles = vec3_origin;   // boxes don't rotate
	}

	oldfraction = trace->fraction;

	CM_TransformedBoxTrace( trace, clip->start, clip->end,
				clip->mins, clip->maxs, clipHandle, clip->contentmask, origin, angles );


	if ( trace->fraction < oldfraction ) {
		trace->var_02 = qtrue;
		trace->entityNum = touch->s.number;
	}

}

