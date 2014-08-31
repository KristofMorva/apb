// Not sure we will have enough free loc string slot to translate these options.

#undef buttonAlign
#define buttonAlign 0 0

#define TITLE(itemIndex, textArg, visArg) \
itemDef \
{ \
	rect			(SETS_X + 5) (SETS_Y + 2 + itemIndex * 20) 100 20 0 0 \
	exp				text(textArg) \
	textfont		UI_FONT_NORMAL \
	textscale		0.25 \
	textstyle		0 \
	textAlign		ITEM_ALIGN_MIDDLE_RIGHT \
	forecolor		1 1 1 1 \
	visible			visArg \
	decoration \
} \

#define SLIDER(itemIndex, textArg, dvarArg, defaultArg, minArg, maxArg) \
SLIDER_ACT(itemIndex, textArg, dvarArg, defaultArg, minArg, maxArg, ;)

#define SLIDER_ACT(itemIndex, textArg, dvarArg, defaultArg, minArg, maxArg, actionArg) \
TITLE(itemIndex, textArg, 1) \
itemDef \
{ \
	type			ITEM_TYPE_SLIDER \
	dvarfloat		dvarArg defaultArg minArg maxArg \
	rect			(SETS_X + 110) (SETS_Y + 4 + itemIndex * 20) 120 18 0 0 \
	style			WINDOW_STYLE_FILLED \
	visible			1 \
	onFocus \
	{ \
		play "mouse_over"; \
	} \
	action \
	{ \
		play "mouse_click"; \
		actionArg; \
	} \
}

#define LIST(itemIndex, textArg, dvarArg, listTypeArg, listArg) \
LIST_ACT_VIS(itemIndex, textArg, dvarArg, listTypeArg, listArg, ;, 1)

#define LIST_ACT(itemIndex, textArg, dvarArg, listTypeArg, listArg, actionArg) \
LIST_ACT_VIS(itemIndex, textArg, dvarArg, listTypeArg, listArg, actionArg, 1)

#define LIST_VIS(itemIndex, textArg, dvarArg, listTypeArg, listArg, visArg) \
LIST_ACT_VIS(itemIndex, textArg, dvarArg, listTypeArg, listArg, ;, visArg)

#define LIST_ACT_VIS(itemIndex, textArg, dvarArg, listTypeArg, listArg, actionArg, visArg) \
TITLE(itemIndex, textArg, visArg) \
itemDef \
{ \
	type			listTypeArg \
	dvar			dvarArg \
	listArg \
	rect			(SETS_X + 110) (SETS_Y + 2 + itemIndex * 20) 120 20 0 0 \
	textalign		ITEM_ALIGN_MIDDLE_LEFT \
	textscale		0.25 \
	textstyle 		ITEM_TEXTSTYLE_SHADOWED \
	style			WINDOW_STYLE_FILLED \
	visible			visArg \
	onFocus \
	{ \
		play "mouse_over"; \
	} \
	action \
	{ \
		play "mouse_click"; \
		actionArg; \
	} \
}

#define CHECKBOX(itemIndex, textArg, dvarArg, execArg) \
CHECKBOX_ACT_ON(itemIndex, textArg, dvarArg, execArg, ;, 1) \

#define CHECKBOX_ACT(itemIndex, textArg, dvarArg, execArg, actionArg) \
CHECKBOX_ACT_ON(itemIndex, textArg, dvarArg, execArg, actionArg, 1) \

#define CHECKBOX_ON(itemIndex, textArg, dvarArg, execArg, onArg) \
CHECKBOX_ACT_ON(itemIndex, textArg, dvarArg, execArg, ;, onArg) \

/* Using dvarArg in exec is not working */
#define CHECKBOX_ACT_ON(itemIndex, textArg, dvarArg, execArg, actionArg, onArg) \
TITLE(itemIndex, textArg, 1) \
itemDef \
{ \
	type			ITEM_TYPE_BUTTON \
	rect			(SETS_X + 111) (SETS_Y + 6 + itemIndex * 20) 10 10 0 0 \
	style			WINDOW_STYLE_FILLED \
	border			1 \
	bordersize		1 \
	bordercolor		1 1 1 1 \
	visible			1 \
	onFocus \
	{ \
		play "mouse_over"; \
	} \
	action \
	{ \
		play "mouse_click"; \
		execNow execArg; \
		actionArg; \
	} \
} \
itemDef \
{ \
	type			ITEM_TYPE_BUTTON \
	rect			(SETS_X + 114) (SETS_Y + 9 + itemIndex * 20) 6 6 0 0 \
	style			WINDOW_STYLE_FILLED \
	backcolor		1 1 1 1 \
	visible			when(dvarBool(dvarArg) == onArg) \
	decoration \
}

#define BIND(itemIndex, textArg, cmdArg) \
TITLE(itemIndex, textArg, 1) \
itemDef \
{ \
	type			ITEM_TYPE_BIND \
	dvar			cmdArg \
	rect			(SETS_X + 110) (SETS_Y + 2 + itemIndex * 20) 120 20 0 0 \
	textalign		ITEM_ALIGN_MIDDLE_LEFT \
	textscale		0.25 \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	style			WINDOW_STYLE_EMPTY \
	forecolor		1 1 1 1 \
	visible			1 \
	onFocus \
	{ \
		play "mouse_over"; \
		show keyBindStatus; \
	} \
	leaveFocus \
	{ \
		hide keyBindStatus; \
	} \
	action \
	{ \
		play "mouse_click"; \
	} \
}

#define HEAD(itemIndex, textArg) \
itemDef \
{ \
	style			WINDOW_STYLE_FILLED \
	rect			SETS_X (SETS_Y + 21 + itemIndex * 20) 230 1 0 0 \
	exp				text(textArg) \
	textfont		UI_FONT_NORMAL \
	textscale		0.35 \
	textstyle		0 \
	textAlignY		-2 \
	textAlign		ITEM_ALIGN_CENTER \
	forecolor		0.8 0.8 1 1 \
	background		"line_horizontal" \
	backcolor		0.8 0.8 1 1 \
	visible			1 \
	decoration \
}

menuDef
{
	name			main_controls
	focusColor		COLOR_FOCUSED
	fullScreen		0
	blurWorld		4.8
	rect			0 0 640 480
	onClose
	{
		exec "exec apb";
		hide keyBindStatus;
		uiScript openMenuOnDvar cl_ingame 1 class;
	}
	onEsc
	{
		close self;
	}

	// Background button blocker
	itemDef
	{
		type		ITEM_TYPE_BUTTON
		rect		0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
		visible		1
	}

	itemDef
	{
		exp				text("@APB_CONTROLS_" + dvarString("lang"))
		style			WINDOW_STYLE_FILLED
		rect			50 25 540 20
		textstyle		ITEM_TEXTSTYLE_NORMAL
		textfont		UI_FONT_DEFAULT
		textalign		ITEM_ALIGN_LEFT
		textalignx		5
		textaligny		20
		textscale		0.4
		backcolor		0 0 0 1
		forecolor		1 1 1 1
		visible			1
		decoration
	}

	itemDef
	{
		style			WINDOW_STYLE_FILLED
		rect			50 45 540 391
		backcolor		0 0 0 0.85
		visible			1
		decoration
	}

	itemDef
	{
		style			WINDOW_STYLE_FILLED
		rect			50 436 540 24
		backcolor		0.1 0.1 0.1 0.85
		visible			1
		decoration
	}

	#undef SETS_X
	#define SETS_X 75
	#undef SETS_Y
	#define SETS_Y 50

	BIND(0, "@MENU_USE", "+activate")
	CHECKBOX_ACT(1, "@MENU_INVERT_MOUSE", ui_mousePitch, "toggle ui_mousePitch 0 1", uiScript update ui_mousePitch)
	BIND(2, "@MENU_LEAN_LEFT", "+leanleft")
	BIND(3, "@MENU_LEAN_RIGHT", "+leanright")
	BIND(4, "@MENU_LOOK_UP", "+lookup")
	BIND(5, "@MENU_LOOK_DOWN", "+lookdown")
	BIND(6, "@MENU_TURN_LEFT", "+left")
	BIND(7, "@MENU_TURN_RIGHT", "+right")
	BIND(8, "@MENU_MOUSE_LOOK", "+mlook")
	BIND(9, "@MENU_CENTER_VIEW", "centerview")
	CHECKBOX(10, "@MENU_FREE_LOOK", cl_freelook, "toggle cl_freelook 0 1")
	CHECKBOX(11, "@MENU_SMOOTH_MOUSE", m_filter, "toggle m_filter 0 1")
	SLIDER(12, "@MENU_MOUSE_SENSITIVITY", sensitivity, 5, 1, 30)
	BIND(13, "@MENU_TOGGLE_CROUCH", "togglecrouch")
	BIND(14, "@MENU_TOGGLE_PRONE", "toggleprone")

	BIND(15, "@MENU_CROUCH", "+movedown")
	BIND(16, "@MENU_PRONE", "+prone")

	BIND(17, "@MENU_CHANGE_STANCE", "+stance")
	BIND(18, "@MENU_STRAFE", "+strafe")

	#undef SETS_X
	#define SETS_X 325

	BIND(0, "@MENU_FORWARD", "+forward")
	BIND(1, "@MENU_BACKPEDAL", "+back")
	BIND(2, "@MENU_MOVE_LEFT", "+moveleft")
	BIND(3, "@MENU_MOVE_RIGHT", "+moveright")
	BIND(4, "@MENU_STANDJUMP", "+gostand")
	BIND(5, "@MENU_GO_TO_CROUCH", "gocrouch")
	BIND(6, "@MENU_GO_TO_PRONE", "goprone")
	BIND(7, "@MENU_SPRINT", "+sprint")
	BIND(8, "@MENU_ATTACK", "+attack")
	BIND(9, "@MENU_TOGGLE_AIM_DOWN_THE_SIGHT", "+toggleads_throw")
	BIND(10, "@MENU_AIM_DOWN_THE_SIGHT", "+speed_throw")
	BIND(11, "@MENU_MELEE_ATTACK", "+melee")	
	BIND(12, "@MENU_SWITCH_WEAPON", "weapnext")
	BIND(13, "@MENU_RELOAD_WEAPON", "+reload")
	BIND(14, "@MENU_THROW_FRAG_GRENADE", "+frag")
	BIND(15, "@MP_PLACE_WAYPOINTS", "openScriptMenu ingame point")

	APBBUTTON_CMD(54, 439, 120, "BACK", close self, "back")

	itemDef
	{
		name			keyBindStatus
		rect			180 439 1 20
		ownerdraw		UI_KEYBINDSTATUS
		textstyle		ITEM_TEXTSTYLE_SHADOWED
		style			WINDOW_STYLE_EMPTY
		forecolor		0.9 0.9 0.9 1
		textscale		0.3
		textAlignY		16
		textalign		ITEM_ALIGN_MIDDLE_LEFT
		visible			0
		decoration
	}
}

#undef SETS_X
#undef SETS_Y

menuDef
{
	name			main_options
	focusColor		COLOR_FOCUSED
	fullScreen		0
	blurWorld		4.8
	rect			0 0 640 480
	onOpen
	{
		exec "exec settings_graphics";
		execOnDvarFloatValue r_zfeather 0 "set ui_zfeather 0";
		execOnDvarFloatValue r_zfeather 1 "set ui_zfeather 1";
		execOnDvarFloatValue r_depthPrepassModels 1 "set ui_zfeather 2";
	}
	onClose
	{
		execOnDvarIntValue ui_zfeather 0 "set r_zfeather 0; set r_depthPrepassModels 0";
		execOnDvarIntValue ui_zfeather 1 "set r_zfeather 1; set r_depthPrepassModels 0";
		execOnDvarIntValue r_lodScaleRigid 2 "set r_lodScaleSkinned 4; set r_lodBiasSkinned -200; set r_lodBiasRigid -100";
		execOnDvarIntValue r_lodScaleRigid 1 "set r_lodScaleSkinned 1; set r_lodBiasSkinned 0; set r_lodBiasRigid 0";
		setLocalVarBool apply_vid 0;
		setLocalVarBool apply_snd 0;
		hide applies;
		uiScript openMenuOnDvar cl_ingame 1 class;
	}
	onEsc
	{
		close self;
	}

	// Background button blocker
	itemDef
	{
		type		ITEM_TYPE_BUTTON
		rect		0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
		visible		1
	}

	itemDef
	{
		exp				text("@APB_OPTIONS_" + dvarString("lang"))
		style			WINDOW_STYLE_FILLED
		rect			50 25 540 20
		textstyle		ITEM_TEXTSTYLE_NORMAL
		textfont		UI_FONT_DEFAULT
		textalign		ITEM_ALIGN_LEFT
		textalignx		5
		textaligny		20
		textscale		0.4
		backcolor		0 0 0 1
		forecolor		1 1 1 1
		visible			1
		decoration
	}

	itemDef
	{
		style			WINDOW_STYLE_FILLED
		rect			50 45 540 391
		backcolor		0 0 0 0.85
		visible			1
		decoration
	}

	itemDef
	{
		style			WINDOW_STYLE_FILLED
		rect			50 436 540 24
		backcolor		0.1 0.1 0.1 0.85
		visible			1
		decoration
	}

	#define SETS_X 75
	#define SETS_Y 50

	HEAD(0, "@MENU_GRAPHICS")
	LIST_ACT(1, "@MENU_VIDEO_MODE", ui_r_mode, ITEM_TYPE_DVARENUM, dvarEnumList r_mode, setLocalVarBool apply_vid 1)
	CHECKBOX_ACT(2, "@MENU_FULLSCREEN", ui_r_fullscreen, "toggle ui_r_fullscreen 0 1", setLocalVarBool apply_vid 1)
	LIST_ACT(3, "@MENU_SCREEN_REFRESH_RATE", ui_r_displayRefresh, ITEM_TYPE_DVARENUM, dvarEnumList r_displayRefresh, setLocalVarBool apply_vid 1)
	LIST_ACT(4, "@MENU_ASPECT_RATIO", ui_r_aspectratio, ITEM_TYPE_MULTI, dvarStrList { "@MENU_AUTO"; "auto"; "@MENU_STANDARD_4_3"; "standard"; "@MENU_WIDE_16_10"; "wide 16:10"; "@MENU_WIDE_16_9"; "wide 16:9" }, setLocalVarBool apply_vid 1)
	LIST_ACT(5, "@MENU_ANTIALIASING", ui_r_aasamples, ITEM_TYPE_MULTI, dvarFloatList { "@MENU_OFF" 1 "2x" 2 "4x" 4 "8x" 8 "16x" 16 }, setLocalVarBool apply_vid 1)
	SLIDER(6, "@MENU_BRIGHTNESS", r_gamma, 1, 0.5, 3)
	CHECKBOX_ACT(7, "@MENU_SYNC_EVERY_FRAME", ui_r_vsync, "toggle ui_r_vsync 0 1", setLocalVarBool apply_vid 1)
	CHECKBOX(8, "@MENU_OPTIMIZE_FOR_DUAL_VIDEO_CARDS", r_multiGpu, "toggle r_multiGpu 0 1")
	CHECKBOX(9, "@MENU_SHADOWS", sm_enable, "toggle sm_enable 0 1")
	CHECKBOX(10, "@MENU_SPECULAR_MAP", r_specular, "toggle r_specular 0 1")
	CHECKBOX(11, "@MENU_DOF", r_dof_enable, "toggle r_dof_enable 0 1")
	CHECKBOX(12, "@MENU_GLOW", r_glow_allowed, "toggle r_glow_allowed 0 1")
	LIST(13, "@MENU_NUMBER_OF_DYNAMIC_LIGHTS", r_dlightlimit, ITEM_TYPE_MULTI, dvarFloatList { "@MENU_OFF" 0 "@MENU_LOW" 2 "@MENU_NORMAL" 4 })
	CHECKBOX_ACT(14, "@MENU_ZFEATHER_SMOKE", ui_zfeather, "toggle ui_zfeather 0 1", setLocalVarBool apply_vid 1)
	CHECKBOX(15, "@MENU_RAGDOLL", ragdoll_enable, "toggle ragdoll_enable 0 1")
	CHECKBOX(16, "@MENU_BULLET_IMPACTS", fx_marks, "toggle fx_marks 0 1")
	LIST(17, "@MENU_MODEL_DETAIL", r_lodScaleRigid, ITEM_TYPE_MULTI, dvarFloatList { "@MENU_NORMAL" 1 "@MENU_LOW" 2 "@MENU_VERY_LOW" 3 "@MENU_EXTRA_LOW" 4 })
	LIST(18, "@MENU_WATER_DETAIL", r_drawWater, ITEM_TYPE_MULTI, dvarFloatList { "@MENU_NORMAL" 1 "@MENU_LOW" 0 })

	#undef SETS_X
	#define SETS_X 325

	HEAD(0, "@MENU_TEXTURE_SETTINGS")
	LIST_ACT(1, "@MENU_TEXTURE_MIPMAPS", r_texFilterMipMode, ITEM_TYPE_MULTI, dvarStrList { "@MENU_AUTOMATIC"; "Unchanged"; "@MENU_BILINEAR"; "Force Bilinear"; "@MENU_TRILINEAR"; "Force Trilinear"; "@MENU_OFF"; "Force Mipmaps Off" }, setLocalVarBool apply_vid 1)
	SLIDER_ACT(2, "@MENU_TEXTURE_ANISOTROPY", r_texFilterAnisoMin, 1, 1, 16, setLocalVarBool apply_vid 1)
	LIST_ACT(3, "@MENU_TEXTURE_QUALITY", ui_r_picmip_manual, ITEM_TYPE_MULTI, dvarFloatList { "@MENU_AUTOMATIC" 0 "@MENU_MANUAL" 1 }, setLocalVarBool apply_vid 1)
	LIST_ACT_VIS(4, "@MENU_TEXTURE_RESOLUTION", ui_r_picmip, ITEM_TYPE_MULTI, dvarFloatList { "@MENU_LOW" 3 "@MENU_NORMAL" 2 "@MENU_HIGH" 1 "@MENU_EXTRA" 0 }, setLocalVarBool apply_vid 1, when(dvarInt(ui_r_picmip_manual)))
	LIST_ACT_VIS(5, "@MENU_NORMAL_MAP_RESOLUTION", ui_r_picmip_bump, ITEM_TYPE_MULTI, dvarFloatList { "@MENU_LOW" 3 "@MENU_NORMAL" 2 "@MENU_HIGH" 1 "@MENU_EXTRA" 0 }, setLocalVarBool apply_vid 1, when(dvarInt(ui_r_picmip_manual)))
	LIST_ACT_VIS(6, "@MENU_SPECULAR_MAP_RESOLUTION", ui_r_picmip_spec, ITEM_TYPE_MULTI, dvarFloatList { "@MENU_LOW" 3 "@MENU_NORMAL" 2 "@MENU_HIGH" 1 "@MENU_EXTRA" 0 }, setLocalVarBool apply_vid 1, when(dvarInt(ui_r_picmip_manual)))

	#undef SETS_Y
	#define SETS_Y 200

	HEAD(0, "@MENU_SOUND")
	SLIDER(1, "@MENU_MASTER_VOLUME", snd_volume, 0.8, 0.0, 1.0)
	CHECKBOX_ACT(2, "@MENU_SOUND_EQ", ui_snd_enableEq, "toggle ui_snd_enableEq 0 1", setLocalVarBool apply_snd 1)
	LIST_ACT(3, "@MENU_SOUND_QUALITY", ui_snd_khz, ITEM_TYPE_MULTI, dvarFloatList { "@MENU_11KHZ" 11 "@MENU_22KHZ" 22 "@MENU_44KHZ" 44 }, setLocalVarBool apply_snd 1)
	LIST_ACT(4, "@MENU_SPEAKER_CONFIG", ui_outputConfig, ITEM_TYPE_MULTI, dvarStrList { "@MENU_WINDOWS_DEFAULT"; "Windows default"; "@MENU_MONO"; "Mono"; "@MENU_STEREO"; "Stereo"; "@MENU_FOUR_SPEAKERS"; "4 speakers"; "@MENU_FIVE_ONE_SPEAKERS"; "5.1 speakers"; }, setLocalVarBool apply_snd 1)

	#undef SETS_Y
	#define SETS_Y 310

	HEAD(0, "@MENU_GAME_OPTIONS")
	CHECKBOX(1, "@MENU_SHOW_BLOOD", cg_blood, "toggle cg_blood 0 1")
	CHECKBOX_ON(2, "@MENU_ENABLE_CONSOLE", monkeytoy, "toggle monkeytoy 0 1", 0)
	

	APBBUTTON_CMD(54, 439, 120, "BACK", close self, "back")
	APBBUTTON_CMD(180, 439, 80, "LOW", exec "exec settings_low; wait; wait; r_applyPicmip; vid_restart", "low")
	APBBUTTON_CMD(266, 439, 80, "HIGH", exec "exec settings_high; wait; wait; r_applyPicmip; vid_restart", "max")

	#define APPLY(id, visArg, actArg) \
	APBBUTTON_HIDDEN_EXT(466, 439, 120, "SAVE", actArg, visArg, id, group applies)

	APPLY("0", when(localVarBool(apply_vid) == 1 && localVarBool(apply_snd) == 1), execOnDvarStringValue ui_zfeather 0 "set cg_laserLight 0"; execOnDvarStringValue ui_zfeather 1 "set cg_laserLight 1"; exec "exec settings_graphics_set; wait; wait; r_applyPicmip; snd_restart; vid_restart")
	APPLY("1", when(localVarBool(apply_vid) == 1 && localVarBool(apply_snd) == 0), execOnDvarStringValue ui_zfeather 0 "set cg_laserLight 0"; execOnDvarStringValue ui_zfeather 1 "set cg_laserLight 1"; exec "exec settings_graphics_set; wait; wait; r_applyPicmip; vid_restart")
	APPLY("2", when(localVarBool(apply_vid) == 0 && localVarBool(apply_snd) == 1), exec "exec settings_graphics_set; snd_restart")

	// In-mission fade ~ we can't use "cond" in the buttons, because they can be hidden
	itemDef
	{
		type			ITEM_TYPE_BUTTON
		style			WINDOW_STYLE_FILLED
		rect			466 439 120 18 buttonAlign
		backcolor		0 0 0 0.5
		visible			when(dvarBool("mission") == 1 && (localVarBool(apply_vid) == 1 || localVarBool(apply_snd) == 1))
	}
}