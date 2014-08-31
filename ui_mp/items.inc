#include "ui_mp/global.inc"
#include "ui_mp/rankcolor.inc"

// Background + disable menus behind
itemDef
{
	style			WINDOW_STYLE_FILLED
	rect			0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
	backcolor		0 0 0 0.25
	visible			1
}

// Border
itemDef
{
	style			WINDOW_STYLE_EMPTY
	rect			43 8 552 462 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
	backcolor		0 0 0 0.25
	border			1
	bordercolor		0.25 0.25 0.25 0.8
	visible			1
	decoration
}

// Player detail background
itemDef
{
	style			WINDOW_STYLE_FILLED
	rect			45 10 550 35 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
	backcolor		0.2 0.2 0.4 1
	visible			1
	decoration
}
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			45 10 550 35 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
	background		"gradient_bottom"
	forecolor		0 0 0.5 0.5
	visible			1
}

// Player details
// Rank
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			58 11 32 32 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
	exp				material("rank" + dvarString("rankicon") + "_silver")
	visible			when(dvarString("threat") == "silver")
	decoration
}
itemDef
{
	style			WINDOW_STYLE_FILLED
	backcolor		RANK_GOLD
	rect			58 11 32 32 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
	exp				material("rank" + dvarString("rankicon") + "_silver")
	visible			when(dvarString("threat") == "gold")
	decoration
}
itemDef
{
	style			WINDOW_STYLE_FILLED
	backcolor		RANK_BRONZE
	rect			58 11 32 32 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
	exp				material("rank" + dvarString("rankicon") + "_silver")
	visible			when(dvarString("threat") == "bronze")
	decoration
}
// Name
itemDef
{
	exp			text(dvarString("showname"))
	textfont	UI_FONT_NORMAL
	style		WINDOW_STYLE_FILLED
	textstyle	ITEM_TEXTSTYLE_SHADOWED
	rect		100 15 100 15 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
	textalign	ITEM_ALIGN_LEFT
	textaligny	15
	textscale	0.3
	forecolor	1 1 1 1
	visible		1
	decoration
}
// Money
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			100 31 8 8 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
	background		"dollar"
	visible			1
	decoration
}
itemDef
{
	exp			text(dvarString("money"))
	textfont	UI_FONT_NORMAL
	style		WINDOW_STYLE_FILLED
	textstyle	ITEM_TEXTSTYLE_SHADOWED
	rect		109 30 100 10 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
	textalign	ITEM_ALIGN_LEFT
	textaligny	10
	textscale	0.2
	forecolor	1 1 1 1
	visible		1
	decoration
}
// Rating
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			540 18 8 8 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
	background		"rating"
	visible			1
	decoration
}
itemDef
{
	exp			text(dvarString("rating_pad"))
	textfont	UI_FONT_NORMAL
	style		WINDOW_STYLE_FILLED
	textstyle	ITEM_TEXTSTYLE_SHADOWED
	rect		550 30 100 10 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
	textalign	ITEM_ALIGN_LEFT
	textaligny	10
	textscale	0.6
	forecolor	1 1 1 1
	visible		1
	decoration
}