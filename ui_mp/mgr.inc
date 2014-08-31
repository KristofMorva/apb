// Menu
itemDef
{
	style			WINDOW_STYLE_FILLED
	rect			20 35 600 15
	backcolor		0.2 0.2 0.2 0.5
	visible			1
	decoration
}

// Probably can be merged!
// "wait" is the delay between two scriptMenuResponses
#define menuButton(id, title, newmenu) \
itemDef \
{ \
	exp				text("@APB_"title"_" + dvarString("lang")) \
	type			ITEM_TYPE_BUTTON \
	style			WINDOW_STYLE_FILLED \
	rect			(20 + id * 100) 37 98 13 0 0 \
	backcolor		0 0 0 0.9 \
	textfont		UI_FONT_OBJECTIVE \
	textalign		ITEM_ALIGN_LEFT \
	textalignx		3 \
	textaligny		12.5 \
	textscale		0.25 \
	forecolor		0.8 0.8 0.8 1 \
	visible			1 \
	mouseEnter		{ show "mainbutton"title } \
	mouseExit		{ hide "mainbutton"title } \
	action			{ close self; execNow "wait 250"; open newmenu } \
} \
itemDef \
{ \
	name			"mainbutton"title \
	exp				text("@APB_"title"_" + dvarString("lang")) \
	style			WINDOW_STYLE_FILLED \
	rect			(20 + id * 100) 37 98 13 0 0 \
	backcolor		0.15 0.15 0.15 1 \
	textfont		UI_FONT_OBJECTIVE \
	textalign		ITEM_ALIGN_LEFT \
	textalignx		3 \
	textaligny		12.5 \
	textscale		0.25 \
	forecolor		0.9 0.9 0.9 1 \
	visible			0 \
	decoration \
}

#define menuPos(id, title) \
itemDef \
{ \
	exp				text("@APB_"title"_" + dvarString("lang")) \
	style			WINDOW_STYLE_FILLED \
	rect			(20 + id * 100) 37 98 13 0 0 \
	backcolor		0.1 0.1 0.1 1 \
	textfont		UI_FONT_OBJECTIVE \
	textalign		ITEM_ALIGN_LEFT \
	textalignx		3 \
	textaligny		12.5 \
	textscale		0.25 \
	forecolor		0.8 0.8 0.2 1 \
	visible			1 \
	decoration \
}