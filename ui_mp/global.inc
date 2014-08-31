// Some of the functions can be optimalized probably, like closeButton and POP.

#define buttonAlign HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN

#define BUTTONBODY(x, y, w, title, act, vis, id, ext) \
itemDef \
{ \
	name		"button_"id \
	style		WINDOW_STYLE_FILLED \
	rect		(x - 2) (y - 2) (w + 2) 20 buttonAlign \
	forecolor	1 1 1 0.85 \
	exp			text("@APB_" + title + "_" + dvarString("lang")) \
	type		ITEM_TYPE_BUTTON \
	textfont	UI_FONT_NORMAL \
	textstyle	ITEM_TEXTSTYLE_SHADOWED \
	textalign	ITEM_ALIGN_CENTER \
	textscale	0.3 \
	textaligny	15.5 \
	border		1 \
	bordercolor	0 0 0 1 \
	background	"button" \
	backcolor	0.5 0.5 0.5 1 \
	visible		vis \
	ext \
	mouseEnter \
	{ \
		play "mouse_over"; \
		setcolor backcolor 0.66 0.66 0.66 1; \
	} \
	mouseExit \
	{ \
		setcolor backcolor 0.5 0.5 0.5 1; \
	} \
	action \
	{ \
		act \
	} \
}

#define BUTTONFADE(x, y, w, cond) \
itemDef \
{ \
	type			ITEM_TYPE_BUTTON \
	style			WINDOW_STYLE_FILLED \
	rect			x y w 18 buttonAlign \
	backcolor		0 0 0 0.5 \
	visible			cond \
}

// These 3 should be replaced with 'act' buttons
#define NEWBUTTON_ON(x, y, w, title, response) \
BUTTONBODY(x, y, w, title, scriptMenuResponse response;, 1, "0", ;)

#define NEWBUTTON(x, y, w, title, response, cond) \
BUTTONBODY(x, y, w, title, scriptMenuResponse response;, 1, "0", ;) \
BUTTONFADE(x, y, w, cond)

#define APBBUTTON_ON(x, y, w, title, response, id) \
BUTTONBODY(x, y, w, title, scriptMenuResponse response;, 1, id, ;)

#define APBBUTTON_CMD_ON(x, y, w, title, act) \
BUTTONBODY(x, y, w, title, act, 1, "0", ;)

#define APBBUTTON_CMD(x, y, w, title, act, id) \
BUTTONBODY(x, y, w, title, act, 1, id, ;)

#define APBBUTTON_EXT(x, y, w, title, act, id, ext) \
BUTTONBODY(x, y, w, title, act, 1, id, ext)

#define APBBUTTON(x, y, w, title, act, cond, id) \
BUTTONBODY(x, y, w, title, act, 1, id, ;) \
BUTTONFADE(x, y, w, cond)

#define APBBUTTON_HIDDEN(x, y, w, title, act, vis, id) \
BUTTONBODY(x, y, w, title, act, vis, id, ;)

#define APBBUTTON_HIDDEN_EXT(x, y, w, title, act, vis, id, ext) \
BUTTONBODY(x, y, w, title, act, vis, id, ext)

// for APBBUTTON_VIS we don't need to put when() when pass
// vis or cond, because that's integrated here! It can be
// simplified this way for all the button types in the
// future, but here is was required due to vis && cond
#define APBBUTTON_VIS(x, y, w, title, act, cond, vis, id) \
BUTTONBODY(x, y, w, title, act, when(vis), id, ;) \
BUTTONFADE(x, y, w, when((vis) && (cond)))

/*#define APBBUTTON_VIS_EXT(x, y, w, title, act, cond, vis, id, ext) \
BUTTONBODY(x, y, w, title, act, vis, id, ext) \
BUTTONFADE(x, y, w, cond)*/

#define IMGBUTTON(x, y, img, response, id) \
IMGBUTTON_FULL(x, y, img, scriptMenuResponse response, 16, 0.5 0.5 0.5, 0.66 0.66 0.66, 1, id)

#define IMGBUTTON_VIS(x, y, img, response, vis, id) \
IMGBUTTON_FULL(x, y, img, scriptMenuResponse response, 16, 0.5 0.5 0.5, 0.66 0.66 0.66, vis, id)

#define IMGBUTTON_SIZE(x, y, img, do, w, id) \
IMGBUTTON_FULL(x, y, img, do, w, 0.5 0.5 0.5, 0.66 0.66 0.66, 1, id)

#define IMGBUTTON_HID(x, y, img, response, cond, id) \
IMGBUTTON_FULL(x, y, img, scriptMenuResponse response, 16, 0.5 0.5 0.5, 0.66 0.66 0.66, 1, id) \
IMGBUTTON_FADE(x, y, 16, cond)

#define IMGBUTTON_RED(x, y, img, response, cond, id) \
IMGBUTTON_FULL(x, y, img, scriptMenuResponse response, 16, 0.8 0 0, 1 0 0, 1, id) \
IMGBUTTON_FADE(x, y, 16, cond)

#define IMGBUTTON_SIZE_HID(x, y, img, do, w, cond, col1, col2, id) \
IMGBUTTON_FULL(x, y, img, do, w, col1, col2, vis, id) \
IMGBUTTON_FADE(x, y, w, cond)

#define IMGBUTTON_FULL(x, y, img, do, w, col1, col2, vis, id) \
itemDef \
{ \
	name			"imgbtn"id \
	type			ITEM_TYPE_BUTTON \
	style			WINDOW_STYLE_FILLED \
	rect			(x - 2) (y - 2) (w + 2) 18 buttonAlign \
	border			1 \
	bordersize		1 \
	bordercolor		0 0 0 1 \
	background		"button" \
	backcolor		col1 1 \
	visible			vis \
	mouseEnter \
	{ \
		play "mouse_over"; \
		setcolor backcolor col2 1; \
	} \
	mouseExit \
	{ \
		setcolor backcolor col1 1; \
	} \
	action \
	{ \
		do; \
	} \
} \
itemDef \
{ \
	style			WINDOW_STYLE_SHADER \
	rect			x y w 16 buttonAlign \
	background 		img \
	visible			vis \
	decoration \
}

#define IMGBUTTON_FADE(x, y, w, cond) \
itemDef \
{ \
	type			ITEM_TYPE_BUTTON \
	style			WINDOW_STYLE_FILLED \
	rect			x y w 16 buttonAlign \
	backcolor		0 0 0 0.5 \
	visible			cond \
}

#define APBPOPUP_EXT(menutitle, esc, title, body, ext) \
name			menutitle \
rect			0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
focuscolor		1 1 1 1 \
blurWorld		4 \
style			WINDOW_STYLE_EMPTY \
onESC \
{ \
	esc \
	close self; \
} \
itemDef \
{ \
	type			ITEM_TYPE_BUTTON \
	style			WINDOW_STYLE_FILLED \
	rect			0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	backcolor		0.4 0.4 0.4 0.5 \
	visible			1 \
} \
itemDef \
{ \
	style			WINDOW_STYLE_FILLED \
	rect			220 190 200 100 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	backcolor		0.1 0.1 0.1 0.75 \
	visible			1 \
	decoration \
} \
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		220 190 200 20 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	backcolor	0 0 0 0.75 \
	visible		1 \
	decoration \
} \
itemDef \
{ \
	style			WINDOW_STYLE_FILLED \
	rect			340 190 80 20 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	background		"title_arrows" \
	backcolor		1 1 1 1 \
	visible			1 \
	decoration \
} \
itemDef \
{ \
	exp			text("@APB_"title"_" + dvarString("lang")) \
	textfont	UI_FONT_NORMAL \
	style		WINDOW_STYLE_FILLED \
	textstyle	ITEM_TEXTSTYLE_SHADOWED \
	rect		220 190 200 20 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	textalign	ITEM_ALIGN_LEFT \
	textscale	0.4 \
	textaligny	20 \
	textalignx	5 \
	forecolor	1 1 1 1 \
	visible		1 \
	decoration \
} \
itemDef \
{ \
	exp			text(body) \
	textfont	UI_FONT_NORMAL \
	textstyle	ITEM_TEXTSTYLE_SHADOWED \
	rect		220 210 190 50 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	textalign	ITEM_ALIGN_LEFT \
	textscale	0.25 \
	textaligny	15 \
	textalignx	5 \
	forecolor	1 1 1 0.8 \
	visible		1 \
	autowrapped \
	decoration \
} \
ext

#define APBPOPUP(menutitle, esc, title, body, btn1title, btn1cmd, btn2title, btn2cmd) \
APBPOPUP_EXT(menutitle, esc, title, body, \
			APBBUTTON_CMD(330, 265, 80, btn1title, btn1cmd, "0") \
			APBBUTTON_CMD(230, 265, 80, btn2title, btn2cmd, "1") \
)

#define APBPOPUP_INPUT(menutitle, title, body, inputtext, inputdvar) \
name			menutitle \
rect			0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
focuscolor		1 1 1 1 \
blurWorld		4 \
style			WINDOW_STYLE_EMPTY \
onOpen \
{ \
	setfocus message; \
} \
onESC \
{ \
	close self; \
} \
itemDef \
{ \
	type			ITEM_TYPE_BUTTON \
	style			WINDOW_STYLE_FILLED \
	rect			0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	backcolor		0.4 0.4 0.4 0.5 \
	visible			1 \
} \
itemDef \
{ \
	style			WINDOW_STYLE_FILLED \
	rect			220 190 200 100 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	backcolor		0.1 0.1 0.1 0.75 \
	visible			1 \
	decoration \
} \
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		220 190 200 20 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	backcolor	0 0 0 0.75 \
	visible		1 \
	decoration \
} \
itemDef \
{ \
	style			WINDOW_STYLE_FILLED \
	rect			340 190 80 20 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	background		"title_arrows" \
	backcolor		1 1 1 1 \
	visible			1 \
	decoration \
} \
itemDef \
{ \
	exp			text("@APB_"title"_" + dvarString("lang")) \
	textfont	UI_FONT_NORMAL \
	style		WINDOW_STYLE_FILLED \
	textstyle	ITEM_TEXTSTYLE_SHADOWED \
	rect		220 190 200 20 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	textalign	ITEM_ALIGN_LEFT \
	textscale	0.4 \
	textaligny	20 \
	textalignx	5 \
	forecolor	1 1 1 1 \
	visible		1 \
	decoration \
} \
itemDef \
{ \
	exp			text(body) \
	textfont	UI_FONT_NORMAL \
	style		WINDOW_STYLE_FILLED \
	textstyle	ITEM_TEXTSTYLE_SHADOWED \
	rect		220 210 200 50 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	textalign	ITEM_ALIGN_LEFT \
	textscale	0.25 \
	textaligny	15 \
	textalignx	5 \
	forecolor	1 1 1 0.8 \
	visible		1 \
	decoration \
} \
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		222 233 196 18 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	backcolor	0.3 0.3 0.3 0.75 \
	border		1 \
	bordercolor	0 0 0 1 \
	visible		1 \
	decoration \
} \
itemDef \
{ \
	name			message \
	type			ITEM_TYPE_EDITFIELD \
	exp				text(locString("@APB_"inputtext"_" + dvarString("lang")) + ": ") \
	dvar			inputdvar \
	rect			220 235 200 14 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	textalignx		5 \
	textaligny		13 \
	maxchars		15 \
	maxpaintchars	15 \
	textalign		ITEM_ALIGN_LEFT \
	textfont		UI_FONT_NORMAL \
	textscale		0.25 \
	forecolor		0.9 0.9 0.9 1 \
	style			WINDOW_STYLE_FILLED \
	visible			1 \
	accept \
	{ \
		exec "setfromdvar info "inputdvar; \
		scriptMenuResponse inputdvar; \
		close self; \
	} \
} \
APBBUTTON_CMD(330, 265, 80, "OK", exec "setfromdvar info "inputdvar; scriptMenuResponse inputdvar; close self;, "0") \
APBBUTTON_CMD(230, 265, 80, "CANCEL", close self;, "1")

#define closeButton(x, y, visArg, actionArg, extArg) \
itemDef \
{ \
	style			WINDOW_STYLE_EMPTY \
	rect			x y 18 18 buttonAlign \
	border			1 \
	bordersize		1 \
	bordercolor		0 0 0 1 \
	visible			visArg \
	extArg \
	decoration \
} \
itemDef \
{ \
	name			"imgdefaultclose" \
	style			WINDOW_STYLE_FILLED \
	rect			(x + 2) (y + 2) 16 16 buttonAlign \
	background		"button" \
	backcolor		0.8 0 0 1 \
	visible			visArg \
	extArg \
	decoration \
} \
itemDef \
{ \
	type		ITEM_TYPE_BUTTON \
	style		WINDOW_STYLE_FILLED \
	rect		(x + 2) (y + 2) 16 16 buttonAlign \
	visible		visArg \
	extArg \
	mouseEnter \
	{ \
		play "mouse_over"; \
		setitemcolor imgdefaultclose backcolor 1 0 0 1; \
	} \
	mouseExit \
	{ \
		setitemcolor imgdefaultclose backcolor 0.8 0 0 1; \
	} \
	action \
	{ \
		actionArg; \
	} \
} \
itemDef \
{ \
	style			WINDOW_STYLE_FILLED \
	rect			(x + 2) (y + 2) 16 16 buttonAlign \
	background		"x" \
	backcolor		1 1 1 1 \
	visible			visArg \
	extArg \
	decoration \
}


// Popup, used with show-hide.
#define POP(nameArg, msgArg, titleArg, descArg, inputArg) \
itemDef \
{ \
	type			ITEM_TYPE_BUTTON \
	group			nameArg \
	style			WINDOW_STYLE_FILLED \
	rect			0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	backcolor		0.4 0.4 0.4 0.5 \
	visible			0 \
} \
itemDef \
{ \
	group			nameArg \
	style			WINDOW_STYLE_FILLED \
	rect			220 190 200 100 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	backcolor		0.1 0.1 0.1 0.75 \
	visible			0 \
	decoration \
} \
itemDef \
{ \
	group		nameArg \
	style		WINDOW_STYLE_FILLED \
	rect		220 190 200 20 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	backcolor	0 0 0 0.75 \
	visible		0 \
	decoration \
} \
itemDef \
{ \
	group			nameArg \
	style			WINDOW_STYLE_FILLED \
	rect			340 190 80 20 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	background		"title_arrows" \
	backcolor		1 1 1 1 \
	visible			0 \
	decoration \
} \
itemDef \
{ \
	group		nameArg \
	exp			text("@APB_"titleArg"_" + dvarString("lang")) \
	textfont	UI_FONT_NORMAL \
	style		WINDOW_STYLE_FILLED \
	textstyle	ITEM_TEXTSTYLE_SHADOWED \
	rect		220 190 200 20 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	textalign	ITEM_ALIGN_LEFT \
	textscale	0.4 \
	textaligny	20 \
	textalignx	5 \
	forecolor	1 1 1 1 \
	visible		0 \
	decoration \
} \
itemDef \
{ \
	group		nameArg \
	exp			text("@APB_"descArg"_" + dvarString("lang")) \
	textfont	UI_FONT_NORMAL \
	style		WINDOW_STYLE_FILLED \
	textstyle	ITEM_TEXTSTYLE_SHADOWED \
	rect		220 210 200 50 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	textalign	ITEM_ALIGN_LEFT \
	textscale	0.25 \
	textaligny	15 \
	textalignx	5 \
	forecolor	1 1 1 0.8 \
	visible		0 \
	decoration \
} \
itemDef \
{ \
	group		nameArg \
	style		WINDOW_STYLE_FILLED \
	rect		222 233 196 18 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	backcolor	0.3 0.3 0.3 0.75 \
	border		1 \
	bordercolor	0 0 0 1 \
	visible		0 \
	decoration \
} \
itemDef \
{ \
	group			nameArg \
	name			msgArg \
	type			ITEM_TYPE_EDITFIELD \
	exp				text(locString("@APB_"inputArg"_" + dvarString("lang")) + ": ") \
	dvar			nameArg \
	rect			220 235 200 14 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	textalignx		5 \
	textaligny		13 \
	maxchars		15 \
	maxpaintchars	15 \
	textalign		ITEM_ALIGN_LEFT \
	textfont		UI_FONT_NORMAL \
	textscale		0.25 \
	forecolor		0.9 0.9 0.9 1 \
	style			WINDOW_STYLE_FILLED \
	visible			0 \
	accept \
	{ \
		execNow "setfromdvar info "nameArg; \
		scriptMenuResponse nameArg; \
		hide nameArg; \
	} \
} \
APBBUTTON_HIDDEN_EXT(330, 265, 80, "OK", execNow "setfromdvar info "nameArg; scriptMenuResponse nameArg; hide nameArg;, 0, nameArg"0", group nameArg) \
APBBUTTON_HIDDEN_EXT(230, 265, 80, "CANCEL", hide nameArg;, 0, nameArg"1", group nameArg)