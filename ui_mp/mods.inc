#include "ui_mp/items.inc"

#define perc(index, weaponid) \
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		50 (50 + 35 * index) 302 32 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	backcolor	0.8 0.8 0 1 \
	visible		when(dvarString("weaponid") == weaponid) \
	decoration \
} \
itemDef \
{ \
	exp			text("@APB_MOD_" + tableLookUp("mp/modTable.csv", 0, weaponid, 3) + "_" + dvarString("lang")) \
	type		ITEM_TYPE_BUTTON \
	textfont	UI_FONT_NORMAL \
	style		WINDOW_STYLE_FILLED \
	textstyle	ITEM_TEXTSTYLE_SHADOWED \
	rect		50 (50 + 35 * index) 300 30 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	textalign	ITEM_ALIGN_LEFT \
	textscale	0.4 \
	textaligny	23 \
	textalignx	35 \
	forecolor	0.8 0.8 0.8 1 \
	backcolor	0.1 0.1 0.1 1 \
	border		1 \
	bordercolor	0.15 0.15 0.15 1 \
	visible		1 \
	mouseEnter { play "mouse_over" } \
	action \
	{ \
		play "mouse_click"; \
		scriptMenuResponse weaponid; \
	} \
} \
itemDef \
{ \
	style			WINDOW_STYLE_SHADER \
	rect			55 (54 + 35 * index) 24 24 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	exp material	("specialty_" + tableLookUp("mp/modTable.csv", 0, weaponid, 1)) \
	visible			1 \
	decoration \
} \
itemDef \
{ \
	style			WINDOW_STYLE_FILLED \
	rect			51 (51 + 35 * index) 300 30 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	backcolor		0 0 0 0.5 \
	visible			when(dvarInt("money") < tableLookUp("mp/modTable.csv", 0, weaponid, 4) || dvarInt("rating") < tableLookUp("mp/modTable.csv", 0, weaponid, 5)) \
	decoration \
} \
itemDef \
{ \
	style			WINDOW_STYLE_SHADER \
	rect			286 (54 + 35 * index) 8 8 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	background		"dollar" \
	visible			1 \
	decoration \
} \
itemDef \
{ \
	exp			text(tableLookUp("mp/modTable.csv", 0, weaponid, 4)) \
	textfont	UI_FONT_NORMAL \
	style		WINDOW_STYLE_FILLED \
	textstyle	ITEM_TEXTSTYLE_SHADOWED \
	rect		295 (53 + 35 * index) 100 10 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	textalign	ITEM_ALIGN_LEFT \
	textaligny	10 \
	textscale	0.2 \
	forecolor	1 1 1 1 \
	visible		when(dvarInt("money") >= tableLookUp("mp/modTable.csv", 0, weaponid, 4)) \
	decoration \
} \
itemDef \
{ \
	exp			text(tableLookUp("mp/modTable.csv", 0, weaponid, 4)) \
	textfont	UI_FONT_NORMAL \
	style		WINDOW_STYLE_FILLED \
	textstyle	ITEM_TEXTSTYLE_SHADOWED \
	rect		295 (53 + 35 * index) 100 10 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	textalign	ITEM_ALIGN_LEFT \
	textaligny	10 \
	textscale	0.2 \
	forecolor	1 0 0 1 \
	visible		when(dvarInt("money") < tableLookUp("mp/modTable.csv", 0, weaponid, 4)) \
	decoration \
} \
itemDef \
{ \
	style			WINDOW_STYLE_SHADER \
	rect			286 (66 + 35 * index) 8 8 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	background		"rating" \
	visible			1 \
	decoration \
} \
itemDef \
{ \
	exp			text(tableLookUp("mp/modTable.csv", 0, weaponid, 5)) \
	textfont	UI_FONT_NORMAL \
	style		WINDOW_STYLE_FILLED \
	textstyle	ITEM_TEXTSTYLE_SHADOWED \
	rect		295 (65 + 35 * index) 100 10 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	textalign	ITEM_ALIGN_LEFT \
	textaligny	10 \
	textscale	0.2 \
	forecolor	1 1 1 1 \
	visible		when(dvarInt("rating") >= tableLookUp("mp/modTable.csv", 0, weaponid, 5)) \
	decoration \
} \
itemDef \
{ \
	exp			text(tableLookUp("mp/modTable.csv", 0, weaponid, 5)) \
	textfont	UI_FONT_NORMAL \
	style		WINDOW_STYLE_FILLED \
	textstyle	ITEM_TEXTSTYLE_SHADOWED \
	rect		295 (65 + 35 * index) 100 10 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	textalign	ITEM_ALIGN_LEFT \
	textaligny	10 \
	textscale	0.2 \
	forecolor	1 0 0 1 \
	visible		when(dvarInt("rating") < tableLookUp("mp/modTable.csv", 0, weaponid, 5)) \
	decoration \
} \
itemDef \
{ \
	style			WINDOW_STYLE_SHADER \
	rect			322 (52 + 35 * index) 28 28 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	background		"equipped" \
	visible			when(dvarBool("hasmod" + weaponid)) \
	decoration \
}

#define class(id, tierid, menu) \
itemDef \
{ \
	exp			text("> " + locSring("@APB_CLASS_PLAYER_" + dvarString("lang")) + " #"tierid) \
	type		ITEM_TYPE_BUTTON \
	textfont	UI_FONT_NORMAL \
	style		WINDOW_STYLE_FILLED \
	textstyle	ITEM_TEXTSTYLE_SHADOWED \
	rect		355 (180 + id * 20) 240 15 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	textalign	ITEM_ALIGN_LEFT \
	textalignx	5 \
	textaligny	13 \
	textscale	0.25 \
	forecolor	0.75 0.75 0.75 1 \
	backcolor	0.05 0.05 0.05 1 \
	visible		1 \
	mouseEnter { play "mouse_over" } \
	action { close self; open menu; } \
}

#define desc(id) \
itemDef \
{ \
	exp			text("@APB_MOD_" + tableLookUp("mp/modTable.csv", 0, dvarString("weaponid"), 3) + "_DESC" + id + "_" + dvarString("lang")) \
	textfont	UI_FONT_NORMAL \
	style		WINDOW_STYLE_FILLED \
	textstyle	ITEM_TEXTSTYLE_SHADOWED \
	rect		365 (80 + id * 15) 50 14 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	textalign	ITEM_ALIGN_LEFT \
	textscale	0.25 \
	visible		1 \
	decoration \
}

#define cur(id) \
itemDef \
{ \
	style			WINDOW_STYLE_FILLED \
	rect			360 (235 + id * 55) 230 50 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	backcolor		0.15 0.15 0.15 0.8 \
	visible			1 \
	decoration \
} \
itemDef \
{ \
	style			WINDOW_STYLE_SHADER \
	rect			365 (240 + id * 55) 40 40 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	exp material	("specialty_" + dvarString("perk" + id)) \
	visible			1 \
	decoration \
} \
itemDef \
{ \
	exp			text("@APB_MOD_" + tableLookUp("mp/modTable.csv", 1, dvarString("perk" + id), 3) + "_" + dvarString("lang")) \
	textfont	UI_FONT_NORMAL \
	style		(410 + id * 55) \
	textstyle	ITEM_TEXTSTYLE_SHADOWED \
	rect		410 (250 + id * 55) 150 20 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	textaligny	20 \
	textalign	ITEM_ALIGN_LEFT \
	textscale	0.45 \
	forecolor	0.8 0.8 0.4 0.9 \
	visible		when (dvarString("perk" + id) != "empty") \
	decoration \
} \
itemDef \
{ \
	exp			text("@APB_MOD_EMPTY_" + dvarString("lang")) \
	textfont	UI_FONT_NORMAL \
	style		(410 + id * 55) \
	textstyle	ITEM_TEXTSTYLE_SHADOWED \
	rect		410 (250 + id * 55) 150 20 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	textaligny	20 \
	textalign	ITEM_ALIGN_LEFT \
	textscale	0.45 \
	forecolor	0.8 0.8 0.4 0.9 \
	visible		when (dvarString("perk" + id) == "empty") \
	decoration \
}

// List background
itemDef
{
	style			WINDOW_STYLE_FILLED
	rect			45 45 310 425 0 0
	backcolor		0.15 0.15 0.15 0.8
	visible			1
	decoration
}

// Detail-top background
itemDef
{
	style			WINDOW_STYLE_FILLED
	rect			355 45 240 35 0 0
	backcolor		0.1 0.1 0.1 0.8
	visible			1
	decoration
}

// Desc background
itemDef
{
	style			WINDOW_STYLE_FILLED
	rect			355 80 240 35 0 0
	backcolor		0.3 0.3 0.3 0.5
	visible			1
	decoration
}

// Detail-bottom background
itemDef
{
	style			WINDOW_STYLE_FILLED
	rect			355 115 240 355 0 0
	backcolor		0.1 0.1 0.1 0.8
	visible			1
	decoration
}

// Current perks title
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			0 7 240 0.5 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN
	origin			355 245
	background		"line_horizontal"
	forecolor		1 1 1 0.85
	visible			1
	decoration
}	
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			20 8 200 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN
	origin			355 245
	background		"line_horizontal"
	forecolor		0.4 0.6 1 0.8
	visible			1
	decoration
}
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			0 29 240 0.5 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN
	origin			355 245
	background		"line_horizontal"
	forecolor		1 1 1 0.85
	visible			1
	decoration
}
itemDef
{
	rect			0 0 240 24 0 0
	origin			355 245
	forecolor		1 1 1 0.8
	exp				text("@APB_CURRENT_PERKS_" + dvarString("lang"));
	textstyle 		ITEM_TEXTSTYLE_SHADOWED
	textfont		UI_FONT_NORMAL
	textscale		TEXTSIZE_DEFAULT
	textAlign		ITEM_ALIGN_MIDDLE_CENTER
	textAlignY		5
	visible 		1
	decoration
}

// Perk classes
class(0, "1", "mods")
class(1, "2", "mods2")
class(2, "3", "mods3")

// Perk descriptions
desc(1)
desc(2)

// Current perks
cur(1)
cur(2)
cur(3)

// Perk name
itemDef
{
	exp			text("@APB_MOD_" + tableLookUp("mp/modTable.csv", 0, dvarString("weaponid"), 3) + "_" + dvarString("lang"))
	textfont	UI_FONT_NORMAL
	style		WINDOW_STYLE_FILLED
	textstyle	ITEM_TEXTSTYLE_SHADOWED
	textalignx	5
	textaligny	25
	rect		355 50 290 20 0 0
	textalign	ITEM_ALIGN_LEFT
	textscale	0.55
	forecolor	1 1 1 1
	visible		1
	decoration
}

// Purchase button
NEWBUTTON(435, 140, 80, "BUY", "buy", when(dvarInt("money") < tableLookUp("mp/modTable.csv", 0, dvarString("weaponid"), 4) || dvarInt("rating") < tableLookUp("mp/modTable.csv", 0, dvarString("weaponid"), 5)))
