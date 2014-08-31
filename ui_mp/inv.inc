#include "ui_mp/items.inc"

#define weapon(id, index, rid) \
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		50 (50 + 35 * id) 302 32 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	backcolor	0.8 0.8 0 1 \
	visible		when(dvarInt("weaponid") > 0 && dvarInt("weaponid") == dvarInt(weaptype + ((dvarInt("invpage") - 1) * 11 + rid))) \
	decoration \
} \
itemDef \
{ \
	exp			text(tableLookUp("mp/weaponTable.csv", 0, dvarInt(weaptype + ((dvarInt("invpage") - 1) * 11 + rid)), 2)) \
	type		ITEM_TYPE_BUTTON \
	textfont	UI_FONT_NORMAL \
	style		WINDOW_STYLE_FILLED \
	textstyle	ITEM_TEXTSTYLE_SHADOWED \
	rect		50 (50 + 35 * id) 300 30 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	textalign	ITEM_ALIGN_LEFT \
	textscale	0.4 \
	textaligny	19 \
	textalignx	74 \
	forecolor	0.8 0.8 0.8 1 \
	backcolor	0.1 0.1 0.1 1 \
	border		1 \
	bordercolor	0.15 0.15 0.15 1 \
	visible		when(dvarInt(weaptype + ((dvarInt("invpage") - 1) * 11 + rid)) != 0) \
	mouseEnter { play "mouse_over" } \
	action \
	{ \
		play "mouse_click"; \
		scriptMenuResponse weaptype":"index; \
	} \
} \
itemDef \
{ \
	exp			text(int(dvarInt(weaptype + ((dvarInt("invpage") - 1) * 11 + rid) + "_time") / 1440) + " " + locString("@APB_DAY_REMAINING_" + dvarString("lang"))) \
	textfont	UI_FONT_NORMAL \
	textstyle	ITEM_TEXTSTYLE_SHADOWED \
	rect		60 (50 + 35 * id) 300 30 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	textalign	ITEM_ALIGN_LEFT \
	textscale	0.2 \
	textaligny	28 \
	textalignx	67 \
	forecolor	0.5 0.5 0.5 1 \
	visible		when(dvarInt(weaptype + ((dvarInt("invpage") - 1) * 11 + rid)) != 0 && dvarInt(weaptype + ((dvarInt("invpage") - 1) * 11 + rid) + "_time") > 0 && dvarInt(weaptype + ((dvarInt("invpage") - 1) * 11 + rid) + "_time") >= 1440) \
	decoration \
} \
itemDef \
{ \
	exp			text(int(dvarInt(weaptype + ((dvarInt("invpage") - 1) * 11 + rid) + "_time") / 60) + " " + locString("@APB_HOUR_REMAINING_" + dvarString("lang"))) \
	textfont	UI_FONT_NORMAL \
	textstyle	ITEM_TEXTSTYLE_SHADOWED \
	rect		60 (50 + 35 * id) 300 30 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	textalign	ITEM_ALIGN_LEFT \
	textscale	0.2 \
	textaligny	28 \
	textalignx	67 \
	forecolor	0.5 0.5 0.5 1 \
	visible		when(dvarInt(weaptype + ((dvarInt("invpage") - 1) * 11 + rid)) != 0 && dvarInt(weaptype + ((dvarInt("invpage") - 1) * 11 + rid) + "_time") > 0 && dvarInt(weaptype + ((dvarInt("invpage") - 1) * 11 + rid) + "_time") < 1440 && dvarInt(weaptype + ((dvarInt("invpage") - 1) * 11 + rid) + "_time") >= 60) \
	decoration \
} \
itemDef \
{ \
	exp			text(int(dvarInt(weaptype + ((dvarInt("invpage") - 1) * 11 + rid) + "_time")) + " " + locString("@APB_MIN_REMAINING_" + dvarString("lang"))) \
	textfont	UI_FONT_NORMAL \
	textstyle	ITEM_TEXTSTYLE_SHADOWED \
	rect		60 (50 + 35 * id) 300 30 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	textalign	ITEM_ALIGN_LEFT \
	textscale	0.2 \
	textaligny	28 \
	textalignx	67 \
	forecolor	0.5 0.5 0.5 1 \
	visible		when(dvarInt(weaptype + ((dvarInt("invpage") - 1) * 11 + rid)) != 0 && dvarInt(weaptype + ((dvarInt("invpage") - 1) * 11 + rid) + "_time") > 0 && dvarInt(weaptype + ((dvarInt("invpage") - 1) * 11 + rid) + "_time") < 60) \
	decoration \
} \
itemDef \
{ \
	style			WINDOW_STYLE_SHADER \
	rect			0 0 0 0 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	exp				rect X(55 + 16 * (2 - tableLookUp("mp/weaponTable.csv", 0, dvarInt(weaptype + ((dvarInt("invpage") - 1) * 11 + rid)), 4))) \
	exp				rect Y(50 + 35 * id + 8 * (2 - tableLookUp("mp/weaponTable.csv", 0, dvarInt(weaptype + ((dvarInt("invpage") - 1) * 11 + rid)), 5))) \
	exp				rect W(tableLookUp("mp/weaponTable.csv", 0, dvarInt(weaptype + ((dvarInt("invpage") - 1) * 11 + rid)), 4) * 32) \
	exp				rect H(tableLookUp("mp/weaponTable.csv", 0, dvarInt(weaptype + ((dvarInt("invpage") - 1) * 11 + rid)), 5) * 16) \
	exp material	(tableLookUp("mp/weaponTable.csv", 0, dvarInt(weaptype + ((dvarInt("invpage") - 1) * 11 + rid)), 3)) \
	visible			when(dvarInt(weaptype + ((dvarInt("invpage") - 1) * 11 + rid)) != 0) \
	decoration \
} \
itemDef \
{ \
	style			WINDOW_STYLE_SHADER \
	rect			322 (52 + 35 * id) 28 28 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	background		"equipped" \
	visible			when(dvarInt(weaptype"id") == dvarInt(weaptype + ((dvarInt("invpage") - 1) * 11 + rid))) \
	decoration \
}

#define weaponStat(id, txt) \
itemDef \
{ \
	exp			text("@APB_STAT_"txt"_" + dvarString("lang")) \
	textfont	UI_FONT_NORMAL \
	style		WINDOW_STYLE_FILLED \
	textstyle	ITEM_TEXTSTYLE_SHADOWED \
	rect		395 (140 + id * 15) 50 14 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	textalign	ITEM_ALIGN_RIGHT \
	textscale	0.25 \
	forecolor	0.8 0.8 0.6 1 \
	visible		1 \
	decoration \
} \
itemDef \
{ \
	style			WINDOW_STYLE_FILLED \
	rect			448 (129 + id * 15) 102 12 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	backcolor		0.3 0.3 0.3 1 \
	border			1 \
	bordercolor		0.5 0.5 0.5 1 \
	visible			1 \
	decoration \
} \
itemDef \
{ \
	style			WINDOW_STYLE_FILLED \
	rect			450 (131 + id * 15) 100 10 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	exp				rect W(tableLookUp("mp/weaponTable.csv", 0, dvarInt("weaponid"), 6 + id)) \
	backcolor		0.75 0.5 0 1 \
	visible			1 \
	decoration \
} \
itemDef \
{ \
	style			WINDOW_STYLE_SHADER \
	rect			450 (130 + id * 15) 100 10 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	exp				rect W(tableLookUp("mp/weaponTable.csv", 0, dvarInt("weaponid"), 6 + id)) \
	background		"line_horizontal" \
	forecolor		1 1 1 0.5 \
	visible			1 \
	decoration \
}

#define class(id, title, do, tierid) \
itemDef \
{ \
	exp			text("> " + locString("@APB_"title"_" + dvarString("lang")) + tierid) \
	type		ITEM_TYPE_BUTTON \
	textfont	UI_FONT_NORMAL \
	style		WINDOW_STYLE_FILLED \
	rect		355 (290 + id * 20) 240 15 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	textstyle	ITEM_TEXTSTYLE_SHADOWED \
	textalign	ITEM_ALIGN_LEFT \
	textalignx	5 \
	textaligny	13 \
	textscale	0.25 \
	forecolor	0.75 0.75 0.75 1 \
	backcolor	0.05 0.05 0.05 1 \
	visible		1 \
	mouseEnter { play "mouse_over" } \
	action { do; } \
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

// Perk background
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

// Pages
itemDef
{
	style		WINDOW_STYLE_FILLED
	rect		45 438 310 32
	backcolor	0.15 0.15 0.15 1
	visible		1
	decoration
}
itemDef
{
	type		ITEM_TYPE_BUTTON
	exp			text("@APB_PREVPAGE_" + dvarString("lang"))
	rect		45 438 155 32
	textstyle	ITEM_TEXTSTYLE_NORMAL
	textalign	ITEM_ALIGN_LEFT
	textalignx	5
	textaligny	23
	textscale	0.3
	forecolor	1 1 1 1
	visible		1
	action		{ scriptMenuResponse "prevpage" }
}
itemDef
{
	type		ITEM_TYPE_BUTTON
	exp			text("@APB_NEXTPAGE_" + dvarString("lang"))
	rect		200 438 155 32
	textstyle	ITEM_TEXTSTYLE_NORMAL
	textalign	ITEM_ALIGN_RIGHT
	textalignx	-5
	textaligny	23
	textscale	0.3
	forecolor	1 1 1 1
	visible		1
	action		{ scriptMenuResponse "nextpage" }
}

// Weapon classes + Perk tiers
class(0, "INV_WEAPON_PRIMARY", close self; open "inv", "")
class(1, "INV_WEAPON_SECONDARY", close self; open "inv2", "")
class(2, "INV_WEAPON_OFFHAND", close self; open "inv3", "")
class(3, "CLASS_PLAYER", setDvar invtier "green"; close self; open "invperk", " #1")
class(4, "CLASS_PLAYER", setDvar invtier "red"; close self; open "invperk", " #2")
class(5, "CLASS_PLAYER", setDvar invtier "blue"; close self; open "invperk", " #3")

// Weapon name
itemDef
{
	exp			text(tableLookUp("mp/weaponTable.csv", 0, dvarString("weaponid"), 2))
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

// Modifier #1
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			360 85 24 24 0 0
	exp material	("specialty_" + dvarString("mod1"))
	visible			1
	mouseEnter { show modtext1 }
	mouseExit { hide modtext1 }
}

// Modifier #2
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			390 85 24 24 0 0
	exp material	("specialty_" + dvarString("mod2"))
	visible			1
	mouseEnter { show modtext2 }
	mouseExit { hide modtext2 }
}

// Modifier #3
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			420 85 24 24 0 0
	exp material	("specialty_" + dvarString("mod3"))
	visible			1
	mouseEnter { show modtext3 }
	mouseExit { hide modtext3 }
}

// Modifier description #1
itemDef
{
	name		"modtext1"
	exp			text("@APB_MOD_" + tableLookUp("mp/modTable.csv", 1, dvarString("mod1"), 4) + "_" + dvarString("lang"))
	textfont	UI_FONT_NORMAL
	style		WINDOW_STYLE_FILLED
	textstyle	ITEM_TEXTSTYLE_NORMAL
	rect		370 100 70 15 0 0
	textalign	ITEM_ALIGN_LEFT
	textalignx	2
	textaligny	12
	textscale	0.25
	forecolor	0 0 0 1
	backcolor	0.85 0.5 0 1
	border		1
	bordercolor	0.1 0.1 0.1 1
	visible		0
	decoration
}

// Modifier description #2
itemDef
{
	name		"modtext2"
	exp			text("@APB_MOD_" + tableLookUp("mp/modTable.csv", 1, dvarString("mod2"), 4) + "_" + dvarString("lang"))
	textfont	UI_FONT_NORMAL
	style		WINDOW_STYLE_FILLED
	textstyle	ITEM_TEXTSTYLE_NORMAL
	rect		400 100 70 15 0 0
	textalign	ITEM_ALIGN_LEFT
	textalignx	2
	textaligny	12
	textscale	0.25
	forecolor	0 0 0 1
	backcolor	0.85 0.5 0 1
	border		1
	bordercolor	0.1 0.1 0.1 1
	visible		0
	decoration
}

// Modifier description #3
itemDef
{
	name		"modtext3"
	exp			text("@APB_MOD_" + tableLookUp("mp/modTable.csv", 1, dvarString("mod3"), 4) + "_" + dvarString("lang"))
	textfont	UI_FONT_NORMAL
	style		WINDOW_STYLE_FILLED
	textstyle	ITEM_TEXTSTYLE_NORMAL
	rect		430 100 70 15 0 0
	textalign	ITEM_ALIGN_LEFT
	textalignx	2
	textaligny	12
	textscale	0.25
	forecolor	0 0 0 1
	backcolor	0.85 0.5 0 1
	border		1
	bordercolor	0.1 0.1 0.1 1
	visible		0
	decoration
}

// Weapon statistics
weaponStat(0, "ACCURACY")
weaponStat(1, "DAMAGE")
weaponStat(2, "RANGE")
weaponStat(3, "RATE")
weaponStat(4, "MOBILITY")

// Ammo type
itemDef
{
	exp			text("@APB_AMMO_" + tableLookUp("mp/weaponTable.csv", 0, dvarInt("weaponid"), 16) + "_" + dvarString("lang"))
	textfont	UI_FONT_NORMAL
	style		WINDOW_STYLE_FILLED
	textstyle	ITEM_TEXTSTYLE_NORMAL
	rect		360 215 228 30
	textalign	ITEM_ALIGN_LEFT
	textalignx	32
	textaligny	23
	textscale	0.4
	forecolor	1 1 1 1
	backcolor	0.2 0.2 0.2 0.5
	border		1
	bordercolor	0.25 0.25 0.25 1
	visible		1
	decoration
}
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			362 216 30 30
	exp material	("ammo_" + tableLookUp("mp/weaponTable.csv", 0, dvarInt("weaponid"), 16))
	visible			when(dvarBool("weaponid"))
	decoration
}

// Change button
APBBUTTON(393, 260, 80, "CHANGE", scriptMenuResponse change, when(dvarInt("weaponid") == dvarInt(weaptype"id")), "0")
APBBUTTON(477, 260, 80, "DELETE", scriptMenuResponse del, when(dvarInt("weaponid") == dvarInt(weaptype"id") || dvarInt("weaponid") == defaultID), "1")