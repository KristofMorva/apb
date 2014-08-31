#include "ui_mp/items.inc"

#define weapon(id, index, rid) \
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		50 (50 + 35 * id) 302 32 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	backcolor	0.8 0.8 0 1 \
	visible		when(dvarInt("weaponid") > 0 && dvarInt("weaponid") == dvarInt("offhand" + ((dvarInt("invpage") - 1) * 11 + rid))) \
	decoration \
} \
itemDef \
{ \
	exp			text(tableLookUp("mp/weaponTable.csv", 0, dvarInt("offhand" + ((dvarInt("invpage") - 1) * 11 + rid)), 2)) \
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
	visible		when(dvarInt("offhand" + ((dvarInt("invpage") - 1) * 11 + rid)) != 0) \
	mouseEnter { play "mouse_over" } \
	action \
	{ \
		play "mouse_click"; \
		scriptMenuResponse "offhand:"index; \
	} \
} \
itemDef \
{ \
	style			WINDOW_STYLE_SHADER \
	rect			55 (52 + 35 * id) 28 28 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	exp material	(tableLookUp("mp/weaponTable.csv", 0, dvarInt("offhand" + ((dvarInt("invpage") - 1) * 11 + rid)), 3)) \
	visible			when(dvarInt("offhand" + ((dvarInt("invpage") - 1) * 11 + rid)) != 0) \
	decoration \
} \
itemDef \
{ \
	style			WINDOW_STYLE_SHADER \
	rect			322 (52 + 35 * id) 28 28 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	background		"equipped" \
	visible			when(dvarInt("offhandid") == dvarInt("offhand" + ((dvarInt("invpage") - 1) * 11 + rid))) \
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

// Detail background
itemDef
{
	style			WINDOW_STYLE_FILLED
	rect			355 45 240 425 0 0
	backcolor		0.1 0.1 0.1 0.8
	visible			1
	decoration
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

// Description
itemDef
{
	exp			text("@APB_OFFHAND_" + dvarString("weaponid") + "_" + dvarString("lang"))
	textfont	UI_FONT_NORMAL
	style		WINDOW_STYLE_FILLED
	textstyle	ITEM_TEXTSTYLE_SHADOWED
	rect		360 100 230 100 0 0
	textalign	ITEM_ALIGN_LEFT
	textaligny	15
	textscale	0.3
	forecolor	1 1 1 1
	visible		1
	decoration
	autowrapped
}

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
APBBUTTON(477, 260, 80, "DELETE", scriptMenuResponse del, when(dvarInt("weaponid") == dvarInt(weaptype"id") || dvarInt("weaponid") == 63), "1")