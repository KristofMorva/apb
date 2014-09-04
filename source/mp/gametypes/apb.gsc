///////////////////////////////////////////////////////////
//            APB Mod - Morva 'iCore' Kristóf            //
//                moddb.com/members/icore                //
//    Using without permission is strictly forbidden!    //
//     Data stealing is rated as a criminal offence!     //
///////////////////////////////////////////////////////////

// Many conditions could be defined for social district (searchEnemy, defines, etc),
// but that would make a much uglier source code.

// Some parts of the code are a little unoptimized or not secure, since
// I wasn't that experienced when I started making this mod. Needs review later.

#import mp/_pregsc.gsc

main()
{
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	level.callbackStartGameType = ::Callback_StartGameType;
	level.callbackPlayerConnect = ::Callback_PlayerConnect;
	level.callbackPlayerDisconnect = ::Callback_PlayerDisconnect;
	level.callbackPlayerDamage = ::Callback_PlayerDamage;
	level.callbackPlayerSay = ::Callback_PlayerSay;
	level.callback = ::Callback_PlayerKilled;

	level.script = toLower(getDvar("mapname"));
}

Callback_StartGameType()
{
	setDvar("g_teamname_axis", "^9Criminals");
	setDvar("g_teamname_allies", "^8Enforcers");
	setDvar("sv_floodProtect", 1);
	setDvar("sv_maxRate", 25000);
	setDvar("sv_pure", 1);
	setDvar("g_antilag", 1);
	setDvar("sv_allowAnonymous", 0);
	setDvar("bg_fallDamageMinHeight", 140);
	setDvar("bg_fallDamageMaxHeight", 350);
	setDvar("player_throwbackInnerRadius", 0);
	setDvar("player_throwbackOuterRadius", 0);
	setDvar("player_sprinttime", 6.4);
	setDvar("g_friendlyPlayerCanBlock", 1);
	setDvar("sv_authorizemode", 0); // 1
	setDvar("rcon_password", "testrcon");
	setDvar("sv_wwwDownload", 1);
	setDvar("sv_wwwBaseURL", "http://mezesmadzag.hu"); // fastdl.apbmod.com
	setDvar("sv_master2", "cod4master.akthvision.com"); // master.apbmod.com

	level.social = getDvar("gamemode") == "social";
	level.tutorial = getDvar("gamemode") == "tutorial";
	level.action = getDvar("gamemode") == "action";
	//level.fightclub = getDvar("gamemode") == "fightclub";

	level.gamemodes["social"] = true;
	level.gamemodes["tutorial"] = true;
	level.gamemodes["action"] = true;

	level.teams = [];
	level.missions = [];
	level.placedPoints = [];
	level.players = []; // Not really used, but can be needed later maybe
	level.groups = [];
	level.readyPlayers["allies"] = [];
	level.readyPlayers["axis"] = [];
	level.readyGroups["allies"] = [];
	level.readyGroups["axis"] = [];
	level.activePlayers["allies"] = [];
	level.activePlayers["axis"] = [];
	level.allActivePlayers = [];
	level.activeCount["allies"] = 0;
	level.activeCount["axis"] = 0;
	level.allActiveCount = 0;

	//updateTeamStatus(); // So it is enough to change the arrays on one place when needed

	thread maps\mp\gametypes\_menus::init();
	thread maps\mp\gametypes\_weapons::init();
	thread maps\mp\gametypes\_rank::init();
	thread maps\mp\gametypes\_damagefeedback::init();
	thread maps\mp\gametypes\_healthoverlay::init();
	//thread maps\mp\gametypes\_spawnlogic::init();
	/# thread maps\mp\gametypes\_dev::init(); #/

	/*maps\mp\gametypes\_spawnlogic::placeSpawnPoints("mp_tdm_spawn_allies_start");
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints("mp_tdm_spawn_axis_start");
	maps\mp\gametypes\_spawnlogic::addSpawnPoints("allies", "mp_tdm_spawn");
	maps\mp\gametypes\_spawnlogic::addSpawnPoints("axis", "mp_tdm_spawn");*/

	// Player models
	mptype\mptype_ally_usmc_cqb::precache();
	mptype\mptype_ally_cqb::precache();
	mptype\mptype_ally_sniper::precache();
	mptype\mptype_ally_engineer::precache();
	mptype\mptype_ally_rifleman::precache();
	mptype\mptype_ally_support::precache();
	mptype\mptype_ally_urban_sniper::precache();
	mptype\mptype_ally_urban_support::precache();
	mptype\mptype_ally_urban_assault::precache();
	mptype\mptype_ally_urban_recon::precache();
	mptype\mptype_ally_urban_specops::precache();
	mptype\mptype_ally_woodland_assault::precache();
	mptype\mptype_ally_woodland_recon::precache();
	mptype\mptype_ally_woodland_sniper::precache();
	mptype\mptype_ally_woodland_specops::precache();
	mptype\mptype_ally_woodland_support::precache();
	game["allies_model"][1] = mptype\mptype_ally_usmc_cqb::main; // Price
	game["allies_model"][2] = mptype\mptype_ally_support::main;
	game["allies_model"][3] = mptype\mptype_ally_rifleman::main; // Sapkás
	game["allies_model"][4] = mptype\mptype_ally_engineer::main;
	game["allies_model"][5] = mptype\mptype_ally_cqb::main; // Sapkás
	game["allies_model"][6] = mptype\mptype_ally_urban_sniper::main;
	game["allies_model"][7] = mptype\mptype_ally_urban_support::main; // Sapkás (Kapucnis)
	game["allies_model"][8] = mptype\mptype_ally_urban_assault::main;
	game["allies_model"][9] = mptype\mptype_ally_urban_recon::main; // Sapkás
	game["allies_model"][10] = mptype\mptype_ally_urban_specops::main; // Sapkás
	game["allies_model"][11] = mptype\mptype_ally_woodland_sniper::main;
	game["allies_model"][12] = mptype\mptype_ally_woodland_support::main;
	game["allies_model"][13] = mptype\mptype_ally_woodland_assault::main; // Sapkás
	game["allies_model"][14] = mptype\mptype_ally_woodland_recon::main;
	game["allies_model"][15] = mptype\mptype_ally_woodland_specops::main; // Sapkás
	game["allies_model"][16] = mptype\mptype_ally_sniper::main; // Sapkás

	mptype\mptype_axis_boris::precache();
	mptype\mptype_axis_cqb::precache();
	mptype\mptype_axis_sniper::precache();
	mptype\mptype_axis_engineer::precache();
	mptype\mptype_axis_rifleman::precache();
	mptype\mptype_axis_support::precache();
	mptype\mptype_axis_urban_sniper::precache();
	mptype\mptype_axis_urban_support::precache();
	mptype\mptype_axis_urban_assault::precache();
	mptype\mptype_axis_urban_engineer::precache();
	mptype\mptype_axis_urban_cqb::precache();
	mptype\mptype_axis_woodland_rifleman::precache();
	mptype\mptype_axis_woodland_cqb::precache();
	mptype\mptype_axis_woodland_sniper::precache();
	mptype\mptype_axis_woodland_engineer::precache();
	mptype\mptype_axis_woodland_support::precache();
	game["axis_model"][1] = mptype\mptype_axis_boris::main; // NEW
	game["axis_model"][2] = mptype\mptype_axis_support::main; // Sapkás
	game["axis_model"][3] = mptype\mptype_axis_rifleman::main;
	game["axis_model"][4] = mptype\mptype_axis_engineer::main; // Rossz a j_helmet
	game["axis_model"][5] = mptype\mptype_axis_cqb::main; // Rossz a j_helmet
	game["axis_model"][6] = mptype\mptype_axis_urban_sniper::main; // Sapkás
	game["axis_model"][7] = mptype\mptype_axis_urban_support::main;
	game["axis_model"][8] = mptype\mptype_axis_urban_assault::main;
	game["axis_model"][9] = mptype\mptype_axis_urban_engineer::main;
	game["axis_model"][10] = mptype\mptype_axis_urban_cqb::main;
	game["axis_model"][11] = mptype\mptype_axis_woodland_sniper::main;
	game["axis_model"][12] = mptype\mptype_axis_woodland_support::main;
	game["axis_model"][13] = mptype\mptype_axis_woodland_rifleman::main;
	game["axis_model"][14] = mptype\mptype_axis_woodland_engineer::main;
	game["axis_model"][15] = mptype\mptype_axis_woodland_cqb::main;
	game["axis_model"][16] = mptype\mptype_axis_sniper::main; // Boris (sapkás)

	// Gameplay models
	preCacheModel("tag_origin");
	preCacheModel("com_copypaper_box");
	preCacheModel("com_plasticcase_beige_rifle");
	preCacheModel("com_golden_brick");
	preCacheModel("prop_suitcase_bomb");

	preCacheStatusIcon("hud_status_connecting");

	//preCacheShellShock("water");
	preCacheShellShock("stun");

	preCacheShader("arrestpnt");
	preCacheShader("enemypnt");
	preCacheShader("friendpnt");
	preCacheShader("publicenemypnt");
	preCacheShader("publicfriendpnt");
	preCacheShader("teampublicenemypnt");
	preCacheShader("teampublicfriendpnt");
	preCacheShader("ofpublicenemypnt");
	//preCacheShader("ofpublicfriendpnt");
	preCacheShader("placedpoint");
	preCacheShader("white");
	preCacheShader("black");
	preCacheShader("rating");
	preCacheShader("streak");
	preCacheShader("skull");
	preCacheShader("killbg");
	preCacheShader("medal");
	preCacheShader("3d_vip");
	preCacheShader("3d_enemyvip");
	preCacheShader("3d_free0");
	preCacheShader("3d_free1");
	preCacheShader("3d_free2");
	preCacheShader("3d_free3");
	preCacheShader("3d_defend0");
	preCacheShader("3d_defend1");
	preCacheShader("3d_defend2");
	preCacheShader("3d_defend3");
	preCacheShader("3d_capture0");
	preCacheShader("3d_capture1");
	preCacheShader("3d_capture2");
	preCacheShader("3d_capture3");
	preCacheShader("3d_pickup0");
	preCacheShader("3d_pickup1");
	preCacheShader("3d_pickup2");
	preCacheShader("3d_pickup3");
	preCacheShader("3d_follow0");
	preCacheShader("3d_follow1");
	preCacheShader("3d_follow2");
	preCacheShader("3d_follow3");
	preCacheShader("3d_kill0");
	preCacheShader("3d_kill1");
	preCacheShader("3d_kill2");
	preCacheShader("3d_kill3");
	preCacheShader("3d_kill4");
	preCacheShader("3d_kill5");
	preCacheShader("3d_kill6");
	preCacheShader("3d_kill7");
	preCacheShader("3d_drop0");
	preCacheShader("3d_drop1");
	preCacheShader("3d_enemydrop0");
	preCacheShader("3d_enemydrop1");
	preCacheShader("3d_destroy0");
	preCacheShader("3d_destroy1");
	preCacheShader("3d_destroy2");
	preCacheShader("3d_destroy3");
	preCacheShader("3d_defuse0");
	preCacheShader("3d_defuse1");
	preCacheShader("3d_defuse2");
	preCacheShader("3d_defuse3");
	preCacheShader("3d_plant0");

	for (i = 1; i <= 24; i++)
	{
		preCacheShader("medal_" + tableLookup("mp/medalTable.csv", 0, i, 1));
	}
	for (i = 0; i < 9; i++)
	{
		preCacheShader(tableLookup("mp/roleTable.csv", 0, i, 2));
	}

	// Max player count
	if (level.tutorial)
		level.maxClients = int(getDvarInt("sv_maxclients") / 2);
	else
		level.maxClients = getDvarInt("sv_maxclients");

	// Vendor images
	level.vendorTypes[0] = "weapons";
	level.vendorTypes[1] = "inv";
	level.vendorTypes[2] = "mods";
	level.vendorTypes[3] = "camo";
	level.vendorTypes[4] = "ammo";
	level.vendorTypes[5] = "mail";
	level.vendorTypes[6] = "studio";
	level.vendorTypes[7] = "dress";
	foreach (e in level.vendorTypes; 0; 8)
	{
		preCacheShader("pin_" + e);
	}

	// Default weapons & ammos
	level.defaultWeapon["primary"] = 26;
	level.defaultWeapon["secondary"] = 8;
	level.defaultWeapon["offhand"] = 63;
	level.defaultAmmo["rifle"] = 360;
	level.defaultAmmo["pistol"] = 180;
	level.defaultAmmo["frag"] = 4;

	// SQL Connection
	if (sql_run())
	{
		sql_reset(); // May be needed for map changes!
	}
	sql_init("192.168.1.96", 7425);

	/*level.listIP = "192.168.1.92";
	level.listPort = 6850;
	level.ms = initServers(level.listIP, level.listPort);*/

	// Default values are set for weapons + ammos, because if server crashes, they should be kept at least.
	// TODO: We need a solution for saving all client datas (self.info) if the server crashes.
	sql_exec("CREATE TABLE IF NOT EXISTS players (name varchar(15) PRIMARY KEY NOT NULL, pass varchar(15) NOT NULL, dress int(2) NOT NULL DEFAULT 1, faction int(1) NOT NULL DEFAULT 1, money int(10) NOT NULL DEFAULT 500, symbol int(3) NOT NULL DEFAULT 0, achievements int(5) NOT NULL DEFAULT 0, premiumtime int(6) NOT NULL DEFAULT 0, role_rifle int(6) NOT NULL DEFAULT 0, role_machinegun int(6) NOT NULL DEFAULT 0, role_pistol int(6) NOT NULL DEFAULT 0, role_sniper int(6) NOT NULL DEFAULT 0, role_marksman int(6) NOT NULL DEFAULT 0, role_shotgun int(6) NOT NULL DEFAULT 0, role_rocket int(6) NOT NULL DEFAULT 0, role_grenade int(6) NOT NULL DEFAULT 0, role_nonlethal int(6) NOT NULL DEFAULT 0, mod_green int(2) NOT NULL DEFAULT 0, mod_red int(2) NOT NULL DEFAULT 0, mod_blue int(2) NOT NULL DEFAULT 0, prime int(3) NOT NULL DEFAULT " + level.defaultWeapon["primary"] + ", secondary int(3) NOT NULL DEFAULT " + level.defaultWeapon["secondary"] + ", offhand int(3) NOT NULL DEFAULT " + level.defaultWeapon["offhand"] + ", mis_win int(4) NOT NULL DEFAULT 0, mis_lose int(4) NOT NULL DEFAULT 0, mis_tied int(4) NOT NULL DEFAULT 0, allrun int(9) NOT NULL DEFAULT 0, assists int(6) NOT NULL DEFAULT 0, kills int(6) NOT NULL DEFAULT 0, arrests int(6) NOT NULL DEFAULT 0, stuns int(6) NOT NULL DEFAULT 0, medals int(6) NOT NULL DEFAULT 0, regenhealth int(7) NOT NULL DEFAULT 0, backupcalled int(4) NOT NULL DEFAULT 0, startedgroups int(4) NOT NULL DEFAULT 0, delivereditems int(4) NOT NULL DEFAULT 0, missiontime int(7) NOT NULL DEFAULT 0, prestigetime int(6) NOT NULL DEFAULT 0, standing int(7) NOT NULL DEFAULT 0, lang int(2) NOT NULL DEFAULT 0, ammo_rifle int(5) NOT NULL DEFAULT " + level.defaultAmmo["rifle"] + ", ammo_machinegun int(5) NOT NULL DEFAULT 0, ammo_pistol int(5) NOT NULL DEFAULT " + level.defaultAmmo["pistol"] + ", ammo_desert int(5) NOT NULL DEFAULT 0, ammo_shotgun int(5) NOT NULL DEFAULT 0, ammo_sniper int(5) NOT NULL DEFAULT 0, ammo_rocket int(5) NOT NULL DEFAULT 0, ammo_frag int(5) NOT NULL DEFAULT " + level.defaultAmmo["frag"] + ", ammo_flash int(5) NOT NULL DEFAULT 0, ammo_concussion int(5) NOT NULL DEFAULT 0, ammo_nonlethal int(5) NOT NULL DEFAULT 0, rep int(6) NOT NULL DEFAULT 0, reptime int(10) NOT NULL DEFAULT 0, gmt int(2) NOT NULL DEFAULT '1', format int(2) NOT NULL DEFAULT '3', date int(2) NOT NULL DEFAULT '10', theme int(1) NOT NULL DEFAULT 0, inv varchar(15) NOT NULL DEFAULT '', admin int(10) NOT NULL DEFAULT 0, hats int(10) NOT NULL DEFAULT 0, packs int(10) NOT NULL DEFAULT 0, misc int(10) NOT NULL DEFAULT 0, curhat int(2) NOT NULL DEFAULT 0, curpack int(2) NOT NULL DEFAULT 0, curmisc int(10) NOT NULL DEFAULT 0, status varchar(16) NOT NULL DEFAULT 'Offline', timestamp int(10) NOT NULL DEFAULT NULL, level1 int(10) NOT NULL DEFAULT 0, level2 int(10) NOT NULL DEFAULT 0, maxweapons int(3) NOT NULL DEFAULT 14, maxinv int(3) NOT NULL DEFAULT 14, maxmods int(3) NOT NULL DEFAULT 14, symbols int(10) NOT NULL DEFAULT 0)");
	// , mod1 int(2) NOT NULL DEFAULT 0, mod2 int(2) NOT NULL DEFAULT 0, mod3 int(2) NOT NULL DEFAULT 0, mod4 int(2) NOT NULL DEFAULT 0, mod5 int(2) NOT NULL DEFAULT 0, mod6 int(2) NOT NULL DEFAULT 0, mod7 int(2) NOT NULL DEFAULT 0, mod8 int(2) NOT NULL DEFAULT 0, mod9 int(2) NOT NULL DEFAULT 0, mod10 int(2) NOT NULL DEFAULT 0, mod11 int(2) NOT NULL DEFAULT 0, mod12 int(2) NOT NULL DEFAULT 0, weapon4 int(3) NOT NULL DEFAULT 0, weapon5 int(3) NOT NULL DEFAULT 0, weapon6 int(3) NOT NULL DEFAULT 0, weapon7 int(3) NOT NULL DEFAULT 0, weapon8 int(3) NOT NULL DEFAULT 0, weapon9 int(3) NOT NULL DEFAULT 0, weapon10 int(3) NOT NULL DEFAULT 0, weapon11 int(3) NOT NULL DEFAULT 0, weapon12 int(3) NOT NULL DEFAULT 0, weapon4_time int(6) NOT NULL DEFAULT 0, weapon5_time int(6) NOT NULL DEFAULT 0, weapon6_time int(6) NOT NULL DEFAULT 0, weapon7_time int(6) NOT NULL DEFAULT 0, weapon8_time int(6) NOT NULL DEFAULT 0, weapon9_time int(6) NOT NULL DEFAULT 0, weapon10_time int(6) NOT NULL DEFAULT 0, weapon11_time int(6) NOT NULL DEFAULT 0, weapon12_time int(6) NOT NULL DEFAULT 0
	sql_exec("CREATE TABLE IF NOT EXISTS weapons (weaponid INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(15) NOT NULL, weapon int(3), time int(6) NOT NULL DEFAULT 0, mods int(10) DEFAULT 0, camo int(1) NOT NULL DEFAULT 0, FOREIGN KEY(name) REFERENCES players(name) ON UPDATE CASCADE)");
	sql_exec("CREATE TABLE IF NOT EXISTS mods (modid INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(15) NOT NULL, perk int(3), FOREIGN KEY(name) REFERENCES players(name) ON UPDATE CASCADE)");
	sql_exec("CREATE TABLE IF NOT EXISTS themes (name varchar(15) NOT NULL, theme varchar(1024) NOT NULL, themeid int(1) NOT NULL DEFAULT 0, FOREIGN KEY(name) REFERENCES players(name) ON UPDATE CASCADE)");
	sql_exec("CREATE INDEX IF NOT EXISTS themeid_ ON themes (themeid ASC)");
	sql_exec("CREATE TABLE IF NOT EXISTS msg (name varchar(15) NOT NULL, sender varchar(15) NOT NULL, subject varchar(32) NOT NULL DEFAULT '', body varchar(960) NOT NULL DEFAULT '', attachment varchar(16) NOT NULL DEFAULT '0', date int(10) NOT NULL DEFAULT 0, read int(1) NOT NULL DEFAULT 0, msgid int(3) NOT NULL DEFAULT 0, FOREIGN KEY(name, sender) REFERENCES players(name, name) ON UPDATE CASCADE)");
	sql_exec("CREATE INDEX IF NOT EXISTS msgid_ ON msg (msgid DESC)");
	sql_exec("CREATE TABLE IF NOT EXISTS friends (name varchar(15) NOT NULL, friend varchar(15) NOT NULL, friendid int(3) NOT NULL DEFAULT 0, FOREIGN KEY(name, friend) REFERENCES players(name, name) ON UPDATE CASCADE)");
	sql_exec("CREATE INDEX IF NOT EXISTS friendid_ ON friends (friendid ASC)");
	sql_exec("CREATE TABLE IF NOT EXISTS premium (name varchar(15) DEFAULT NULL, code varchar(16) NOT NULL, item varchar(2) NOT NULL, value int(7) NOT NULL, FOREIGN KEY(name) REFERENCES players(name) ON UPDATE CASCADE)");
	sql_exec("CREATE TABLE IF NOT EXISTS clans (clan varchar(15) PRIMARY KEY NOT NULL, cash int(10) NOT NULL DEFAULT 0, color int(1) NOT NULL DEFAULT 8, rank int(2) NOT NULL DEFAULT 1)");
	sql_exec("CREATE TABLE IF NOT EXISTS members (name varchar(15) NOT NULL, clan varchar(15) NOT NULL, rank int(1) NOT NULL DEFAULT 0, FOREIGN KEY(name) REFERENCES players(name) ON UPDATE CASCADE, FOREIGN KEY(clan) REFERENCES clans(clan) ON UPDATE CASCADE)");
	sql_exec("CREATE TABLE IF NOT EXISTS wars (winner varchar(15) NOT NULL, loser varchar(15) NOT NULL, type int(1) NOT NULL DEFAULT 4, winner0 varchar(15) NOT NULL, winner1 varchar(15) NOT NULL, winner2 varchar(15), winner3 varchar(15), loser0 varchar(15) NOT NULL, loser1 varchar(15) NOT NULL, loser2 varchar(15), loser3 varchar(15), time int(10) NOT NULL, tied int(1) NOT NULL DEFAULT 0, FOREIGN KEY(winner0, winner1, winner2, winner3, loser0, loser1, loser2, loser3) REFERENCES players(name, name, name, name, name, name, name, name) ON UPDATE CASCADE)"); // A clan may be disbanded after a war
	sql_exec("CREATE INDEX IF NOT EXISTS time_ ON wars (time DESC)");
	sql_exec("CREATE TABLE IF NOT EXISTS bugs (bugid INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(15) NOT NULL, subject varchar(32) NOT NULL, msg varchar(960) NOT NULL, status int(1) NOT NULL DEFAULT 1, time int(10) NOT NULL, FOREIGN KEY(name) REFERENCES players(name) ON UPDATE CASCADE)");
	sql_exec("CREATE TABLE IF NOT EXISTS don (donid INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(15) NOT NULL, cash int(10) NOT NULL, time int(10) NOT NULL, clan varchar(15) NOT NULL, FOREIGN KEY(name) REFERENCES players(name) ON UPDATE CASCADE, FOREIGN KEY(clan) REFERENCES clans(clan) ON UPDATE CASCADE)");
	sql_exec("CREATE TABLE IF NOT EXISTS inv (invid INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(15) NOT NULL, item varchar(16) NOT NULL, itemtype varchar(16) NOT NULL DEFAULT '', FOREIGN KEY(name) REFERENCES players(name) ON UPDATE CASCADE)");
	sql_exec("CREATE TABLE IF NOT EXISTS servers (ip varchar(39) PRIMARY KEY, name varchar(15) NOT NULL, heartbeat varchar(16) NOT NULL, count_all INTEGER NOT NULL, count_allies INTEGER NOT NULL, count_axis INTEGER NOT NULL, count_max INTEGER NOT NULL, gamemode varchar(16) NOT NULL)");
	sql_exec("DELETE FROM servers WHERE heartbeat < " + (getRealTime() - 60)); // Clear old servers
	// Bug statuses:
	// 1: New
	// 0: Accepted

	//thread sql_stack();

	// TODO: REMOVE
	/*sql_exec("DELETE FROM clans");
	sql_exec("DELETE FROM members");
	sql_exec("DELETE FROM wars");*/
	/*sql_exec("DELETE FROM msg");
	sql_exec("INSERT INTO clans (clan) VALUES ('LowBots'), ('BOBz')");
	sql_exec("INSERT INTO members (name, clan, rank) VALUES ('bot1', 'BOBz', 4)");
	sql_exec("INSERT INTO members (name, clan) VALUES ('bot3', 'BOBz')");
	sql_exec("INSERT INTO members (name, clan, rank) VALUES ('iCore', 'BOBz', 5)");
	sql_exec("INSERT INTO members (name, clan) VALUES ('bot0', 'LowBots')");
	sql_exec("INSERT INTO members (name, clan) VALUES ('bot2', 'LowBots')");
	sql_exec("INSERT INTO members (name, clan) VALUES ('bot4', 'LowBots')");
	sql_exec("INSERT INTO wars (winner, loser, type, winner0, winner1, winner2, winner3, loser0, loser1, loser2, loser3, time, tied) VALUES ('BOBz', 'LowBots', 4, 'iCore', 'bot11111', 'iii', 'BobiBociTarka', 'bot2', 'bot4', 'mmmmmmmmmmmmmmm', 'KISBOGi', 39355343, 0)");*/

	sql_exec("UPDATE players SET admin = 2147483647 WHERE name = 'iCore'"); // TODO: Comment out later

	// Listen server
	//level.listen = getDvar("dedicated") == "listen server";

	// Server name
	level.server = getDvar("server");
	setDvar("sv_hostname", "^1APB Mod ^7- ^2" + level.server);

	// Developer: setStat cannot be used
	if (getDvarInt("developer_script"))
		level.developer = true;
	else
		level.developer = false;

	// Languages
	level.langs[0] = "EN";
	level.langs[1] = "HU";
	level.langs[2] = "HR";
	level.langs[3] = "TR";
	level.langs[4] = "SR";
	level.langs[5] = "PL";
	level.langs[6] = "DE";
	level.langs[7] = "CS";
	level.langs[8] = "SK";

	// Roles
	level.roleList[0] = "rifle";
	level.roleList[1] = "machinegun";
	level.roleList[2] = "pistol";
	level.roleList[3] = "sniper";
	level.roleList[4] = "marksman";
	level.roleList[5] = "shotgun";
	level.roleList[6] = "rocket";
	level.roleList[7] = "grenade";
	level.roleList[8] = "nonlethal";

	// Time formats (Cannot be localized easily, desc in mix.menu)
	level.format[1] = "HH:MM (12)";
	level.format[2] = "HH.MM (12)";
	level.format[3] = "HH:MM (24)";
	level.format[4] = "HH.MM (24)";

	// Date formats (#SAME#)
	level.date[1] = "DD.MM.YY";
	level.date[2] = "DD.MM.YYYY";
	level.date[3] = "MM.DD.YY";
	level.date[4] = "MM.DD.YYYY";
	level.date[5] = "MM/DD/YY";
	level.date[6] = "MM/DD/YYYY";
	level.date[7] = "DD.MM";
	level.date[8] = "MM/DD";
	level.date[9] = "YY.MM.DD";
	level.date[10] = "YYYY.MM.DD";
	level.date[11] = "YYYY-MM-DD";

	// Default theme
	level.defaultTheme = "Default:norise-0, , , , , , , ,1, , , , , , ,2, , , , , , , ,3, , , , , , , , |8bit- , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , |8bit- , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , |8bit- , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , |8bit- , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , |8bit- , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , |8bit- , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , |8bit- , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , ";

	// Player infos, that will change during gameplay
	level.infocols = "";
	level.infoCount = int(tableLookup("mp/infoTable.csv", 0, "infos", 1));
	for (i = 1; i <= level.infoCount; i++)
	{
		level.info[i]["name"] = tableLookup("mp/infoTable.csv", 0, i, 1);
		level.info[i]["type"] = tableLookup("mp/infoTable.csv", 0, i, 2);
		if (i != 1)
			level.infocols += ", ";

		level.infocols += level.info[i]["name"];
	}

	// Hats
	level.hatCount = int(tableLookup("mp/hatTable.csv", 0, "hatcount", 1));
	level.hats = [];
	count = 1;
	for (i = 1; i <= level.hatCount; i++)
	{
		level.hats[i] = spawnStruct();
		level.hats[i].model = tableLookup("mp/hatTable.csv", 0, "hat" + i, 1);
		level.hats[i].bit = count; // int(tableLookup("mp/hatTable.csv", 0, "hat" + i, 2))
		level.hats[i].price = int(tableLookup("mp/hatTable.csv", 0, "hat" + i, 2));
		level.hats[i].name = tableLookup("mp/hatTable.csv", 0, "hat" + i, 3);
		preCacheModel(level.hats[i].model);
		count *= 2;
	}

	// Backpacks
	level.bpCount = int(tableLookup("mp/hatTable.csv", 0, "bpcount", 1));
	level.bps = [];
	count = 1;
	for (i = 1; i <= level.bpCount; i++)
	{
		level.bps[i] = spawnStruct();
		level.bps[i].model = tableLookup("mp/hatTable.csv", 0, "backpack" + i, 1);
		level.bps[i].bit = count;
		level.bps[i].price = int(tableLookup("mp/hatTable.csv", 0, "backpack" + i, 2));
		preCacheModel(level.bps[i].model);
		count *= 2;
	}

	// Backpacks
	level.miscCount = int(tableLookup("mp/hatTable.csv", 0, "misccount", 1));
	level.miscs = [];
	count = 1;
	for (i = 1; i <= level.miscCount; i++)
	{
		level.miscs[i] = spawnStruct();
		level.miscs[i].model = tableLookup("mp/hatTable.csv", 0, "misc" + i, 1);
		level.miscs[i].bit = count;
		level.miscs[i].price = int(tableLookup("mp/hatTable.csv", 0, "misc" + i, 2));
		preCacheModel(level.miscs[i].model);
		count *= 2;
	}

	// Clan ranks
	level.maxClanRank = int(tableLookup("mp/clanTable.csv", 0, "maxrank", 1));
	level.clanRanks = [];
	for (i = 0; i <= level.maxClanRank; i++)
	{
		level.clanRanks[i] = int(tableLookup("mp/clanTable.csv", 0, i, 1));
	}

	// Music definitions
	level.music[0]["time"] = 100;
	//level.music[0]["artist"] = "";
	level.music[0]["title"] = "Airlift Deploy";
	level.music[1]["time"] = 131;
	//level.music[1]["artist"] = "";
	level.music[1]["title"] = "Airlift Start";
	level.music[2]["time"] = 145;
	//level.music[2]["artist"] = "";
	level.music[2]["title"] = "Airplane Alt";
	level.music[3]["time"] = 228;
	//level.music[3]["artist"] = "";
	level.music[3]["title"] = "Armada Seanprice Church";
	level.music[4]["time"] = 100;
	//level.music[4]["artist"] = "";
	level.music[4]["title"] = "Armada Start";
	level.music[5]["time"] = 211;
	//level.music[5]["artist"] = "";
	level.music[5]["title"] = "Coup Intro";
	level.music[6]["time"] = 103;
	//level.music[6]["artist"] = "";
	level.music[6]["title"] = "ICMB Tension";
	level.music[7]["time"] = 165;
	//level.music[7]["artist"] = "";
	level.music[7]["title"] = "Jeepride Chase";
	level.music[8]["time"] = 134;
	//level.music[8]["artist"] = "";
	level.music[8]["title"] = "Jeepride Defense";
	level.music[9]["time"] = 101;
	//level.music[9]["artist"] = "";
	level.music[9]["title"] = "Jeepride Showdown";
	level.music[10]["time"] = 113;
	//level.music[10]["artist"] = "";
	level.music[10]["title"] = "Launch Action";
	level.music[11]["time"] = 143;
	//level.music[11]["artist"] = "";
	level.music[11]["title"] = "Launch Count";
	level.music[12]["time"] = 196;
	//level.music[12]["artist"] = "";
	level.music[12]["title"] = "Launch Tick";
	level.music[13]["time"] = 117;
	//level.music[13]["artist"] = "";
	level.music[13]["title"] = "Scoutsniper Abandoned";
	level.music[14]["time"] = 119;
	//level.music[14]["artist"] = "";
	level.music[14]["title"] = "Scoutsniper Deadpool";
	level.music[15]["time"] = 138;
	//level.music[15]["artist"] = "";
	level.music[15]["title"] = "Scoutsniper Pripyat";
	level.music[16]["time"] = 117;
	//level.music[16]["artist"] = "";
	level.music[16]["title"] = "Scoutsniper Surrounded";
	level.music[17]["time"] = 122;
	//level.music[17]["artist"] = "";
	level.music[17]["title"] = "Sniperescape Exchange";
	level.music[18]["time"] = 132;
	//level.music[18]["artist"] = "";
	level.music[18]["title"] = "Sniperescape Run";
	level.music[19]["time"] = 224;
	//level.music[19]["artist"] = "";
	level.music[19]["title"] = "Griggs Deep Hard";

	// Themes
	level.themes["8bit"]["rows"] = 9;
	level.themes["8bit"]["title"] = "8Bit";
	level.themes["acguitar"]["rows"] = 15;
	level.themes["acguitar"]["title"] = "Ac Guitar";
	level.themes["acpiano"]["rows"] = 25;
	level.themes["acpiano"]["title"] = "Ac Piano";
	level.themes["bbbass1"]["rows"] = 11;
	level.themes["bbbass1"]["title"] = "BB Bass #1";
	level.themes["bbbass2"]["rows"] = 11;
	level.themes["bbbass2"]["title"] = "BB Bass #2";
	level.themes["bbbass3"]["rows"] = 11;
	level.themes["bbbass3"]["title"] = "BB Bass #3";
	level.themes["bbdrum"]["rows"] = 19;
	level.themes["bbdrum"]["title"] = "BB Drum Kit";
	level.themes["bbguitar1"]["rows"] = 11;
	level.themes["bbguitar1"]["title"] = "BB Guitar #1";
	level.themes["bbguitar2"]["rows"] = 10;
	level.themes["bbguitar2"]["title"] = "BB Guitar #2";
	level.themes["bbguitar3"]["rows"] = 16;
	level.themes["bbguitar3"]["title"] = "BB Guitar #3";
	level.themes["bbguitar4"]["rows"] = 16;
	level.themes["bbguitar4"]["title"] = "BB Guitar #4";
	level.themes["bbguitar5"]["rows"] = 16;
	level.themes["bbguitar5"]["title"] = "BB Guitar #5";
	level.themes["bbstring"]["rows"] = 7;
	level.themes["bbstring"]["title"] = "BB Strings";
	level.themes["dbbass"]["rows"] = 8;
	level.themes["dbbass"]["title"] = "DB Bass";
	level.themes["dbdrum"]["rows"] = 20;
	level.themes["dbdrum"]["title"] = "DB Drum Kit";
	level.themes["dbguitar1"]["rows"] = 3;
	level.themes["dbguitar1"]["title"] = "DB Guitar #1";
	level.themes["dbguitar2"]["rows"] = 4;
	level.themes["dbguitar2"]["title"] = "DB Guitar #2";
	level.themes["dbguitar3"]["rows"] = 13;
	level.themes["dbguitar3"]["title"] = "DB Guitar #3";
	level.themes["dblead"]["rows"] = 9;
	level.themes["dblead"]["title"] = "DB Lead";
	level.themes["dbpad"]["rows"] = 20;
	level.themes["dbpad"]["title"] = "DB Pad";
	level.themes["dbsfx"]["rows"] = 10;
	level.themes["dbsfx"]["title"] = "DB SFX";
	level.themes["eguitar"]["rows"] = 9;
	level.themes["eguitar"]["title"] = "Electric Guitar";
	level.themes["epiano"]["rows"] = 22;
	level.themes["epiano"]["title"] = "Electric Piano";
	level.themes["ekit"]["rows"] = 23;
	level.themes["ekit"]["title"] = "Electro Kit";
	level.themes["rock"]["rows"] = 18;
	level.themes["rock"]["title"] = "Rock Guitar";
	level.themes["rocksolo"]["rows"] = 33;
	level.themes["rocksolo"]["title"] = "Rock Solo";
	level.themes["hh1"]["rows"] = 10;
	level.themes["hh1"]["title"] = "Hip Hop #1";
	level.themes["hh2"]["rows"] = 9;
	level.themes["hh2"]["title"] = "Hip Hop #2";
	level.themes["hh3"]["rows"] = 10;
	level.themes["hh3"]["title"] = "Hip Hop #3";
	level.themes["hh4"]["rows"] = 10;
	level.themes["hh4"]["title"] = "Hip Hop #4";
	level.themes["hh5"]["rows"] = 10;
	level.themes["hh5"]["title"] = "Hip Hop #5";
	level.themes["hh6"]["rows"] = 10;
	level.themes["hh6"]["title"] = "Hip Hop #6";
	level.themes["hh7"]["rows"] = 10;
	level.themes["hh7"]["title"] = "Hip Hop #7";
	level.themes["lbbass"]["rows"] = 10;
	level.themes["lbbass"]["title"] = "LB Bass";
	level.themes["lbclav"]["rows"] = 4;
	level.themes["lbclav"]["title"] = "LB Clav";
	level.themes["lbdrum"]["rows"] = 14;
	level.themes["lbdrum"]["title"] = "LB Drums";
	level.themes["lbguitar1"]["rows"] = 33;
	level.themes["lbguitar1"]["title"] = "LB Guitar #1";
	level.themes["lbguitar2"]["rows"] = 31;
	level.themes["lbguitar2"]["title"] = "LB Guitar #2";
	level.themes["lbvox"]["rows"] = 18;
	level.themes["lbvox"]["title"] = "LB Vox";
	level.themes["nobass"]["rows"] = 6;
	level.themes["nobass"]["title"] = "Noct Bass";
	level.themes["nobees"]["rows"] = 6;
	level.themes["nobees"]["title"] = "Noct Bees";
	level.themes["nodrums"]["rows"] = 26;
	level.themes["nodrums"]["title"] = "Noct Drums";
	level.themes["noorch1"]["rows"] = 4;
	level.themes["noorch1"]["title"] = "Noct Orch #1";
	level.themes["noorch2"]["rows"] = 4;
	level.themes["noorch2"]["title"] = "Noct Orch #2";
	level.themes["noorch3"]["rows"] = 4;
	level.themes["noorch3"]["title"] = "Noct Orch #3";
	level.themes["norise"]["rows"] = 4;
	level.themes["norise"]["title"] = "Noct Rise";
	level.themes["nostring"]["rows"] = 5;
	level.themes["nostring"]["title"] = "Noct Strings";
	level.themes["noarp"]["rows"] = 4;
	level.themes["noarp"]["title"] = "Noct Arp";
	level.themes["stdrum"]["rows"] = 9;
	level.themes["stdrum"]["title"] = "ST Drums";
	level.themes["stharp"]["rows"] = 14;
	level.themes["stharp"]["title"] = "ST Harp";
	level.themes["ststr"]["rows"] = 17;
	level.themes["ststr"]["title"] = "ST Strings";
	level.themes["synth1"]["rows"] = 32;
	level.themes["synth1"]["title"] = "Synth Kit #1";
	level.themes["synth2"]["rows"] = 10;
	level.themes["synth2"]["title"] = "Synth Kit #2";

	level.spawn["allies"] = getEntArray("mp_tdm_spawn_allies_start", "classname");
	level.spawn["axis"] = getEntArray("mp_tdm_spawn_axis_start", "classname");
	level.spawns = getEntArray("mp_tdm_spawn", "classname");

	foreach (e in level.spawn["allies"];;+)
		e placeSpawnpoint();

	foreach (e in level.spawn["axis"];;+)
		e placeSpawnpoint();

	foreach (e in level.spawns;;+)
		e placeSpawnpoint();

	// Currently played themes
	level.lastTheme = 0;
	level.themeID = [];
	level.themeIDList = [];
	thread clearThemes();

	// Public enemies
	level.public["allies"] = [];
	level.public["axis"] = [];

	// Online players
	level.online = [];

	// IP
	level.ip = getDvar("ip") + ":" + getDvar("net_port");

	// Bot count
	if (level.tutorial)
		level.bots = 0;

	// Start clientid
	level.clientid = 0;

	// No player name changing - We should modify it...
	// setClientNameMode("manual_change");

	// Radar
	setMiniMap("compass", 940000000, 940000000, -940000000, -940000000);

	/*// Server ID for time based stats (reputation)
	// (It shows, how many times was the server restarted)
	level.serverid = getDvarInt("apb_serverid") + 1;
	setDvar("apb_serverid", level.serverid);

	// Player stats from 3153 till maxStat
	level.maxStat = int(tableLookup("mp/playerTable.csv", 0, "maxStat", 1));

	// Player accounts
	level.accs = 1;
	level.accList = [];
	for (i = 1; getDvar("apb_acc" + i) != ""; i++)
	{
		level.accs = i;
		a = strTok(getDvar("apb_acc" + i), " ");
		for (i = 0; i < a.size; i++)
		{
			level.accList[a[i]] = true;
		}
	}

	// Premium codes
	level.codes = 1;
	level.codeList = [];
	for (i = 1; getDvar("apb_code" + i) != ""; i++)
	{
		level.codes = i;
		a = strTok(getDvar("apb_code" + i), " ");
		for (i = 0; i < a.size; i++)
		{
			level.codeList[a[i]] = true;
		}
	}*/

	// Premium codes
	/*level.codeList = [];
	if (FS_TestFile("premium.apbs"))
	{
		f = FS_FOpen("premium.apbs", "read");
		for (i = 0; true; i++)
		{
			source = FS_ReadLine(f);
			if (isDefined(source))
				level.codeList[source] = true;
			else
				break;
		}
		FS_FClose(f);
	}*/

	// Strings
	maps\mp\gametypes\_str::main();

	level.s["CLANRANK0_EN"] = &"APB_CLANRANK0_EN";
	level.s["CLANRANK1_EN"] = &"APB_CLANRANK1_EN";
	level.s["CLANRANK2_EN"] = &"APB_CLANRANK2_EN";
	level.s["CLANRANK3_EN"] = &"APB_CLANRANK3_EN";
	level.s["CLANRANK4_EN"] = &"APB_CLANRANK4_EN";
	level.s["CLANRANK5_EN"] = &"APB_CLANRANK5_EN";
	level.s["FEED_ARREST_EN"] = &"APB_FEED_ARREST_EN";
	level.s["FEED_ASSIST_EN"] = &"APB_FEED_ASSIST_EN";
	level.s["FEED_KILL_EN"] = &"APB_FEED_KILL_EN";
	level.s["FEED_TK_EN"] = &"APB_FEED_TK_EN";
	level.s["FEED_STUN_EN"] = &"APB_FEED_STUN_EN";
	level.s["KILLED_BY_EN"] = &"APB_KILLED_BY_EN";
	level.s["SUICIDE_EN"] = &"APB_SUICIDE_EN";

	level.s["CLANRANK0_HU"] = &"APB_CLANRANK0_HU";
	level.s["CLANRANK1_HU"] = &"APB_CLANRANK1_HU";
	level.s["CLANRANK2_HU"] = &"APB_CLANRANK2_HU";
	level.s["CLANRANK3_HU"] = &"APB_CLANRANK3_HU";
	level.s["CLANRANK4_HU"] = &"APB_CLANRANK4_HU";
	level.s["CLANRANK5_HU"] = &"APB_CLANRANK5_HU";
	level.s["FEED_ARREST_HU"] = &"APB_FEED_ARREST_HU";
	level.s["FEED_ASSIST_HU"] = &"APB_FEED_ASSIST_HU";
	level.s["FEED_KILL_HU"] = &"APB_FEED_KILL_HU";
	level.s["FEED_TK_HU"] = &"APB_FEED_TK_HU";
	level.s["FEED_STUN_HU"] = &"APB_FEED_STUN_HU";
	level.s["KILLED_BY_HU"] = &"APB_KILLED_BY_HU";
	level.s["SUICIDE_HU"] = &"APB_SUICIDE_HU";

	level.s["CLANRANK0_HR"] = &"APB_CLANRANK0_HR";
	level.s["CLANRANK1_HR"] = &"APB_CLANRANK1_HR";
	level.s["CLANRANK2_HR"] = &"APB_CLANRANK2_HR";
	level.s["CLANRANK3_HR"] = &"APB_CLANRANK3_HR";
	level.s["CLANRANK4_HR"] = &"APB_CLANRANK4_HR";
	level.s["CLANRANK5_HR"] = &"APB_CLANRANK5_HR";
	level.s["FEED_ARREST_HR"] = &"APB_FEED_ARREST_HR";
	level.s["FEED_ASSIST_HR"] = &"APB_FEED_ASSIST_HR";
	level.s["FEED_KILL_HR"] = &"APB_FEED_KILL_HR";
	level.s["FEED_TK_HR"] = &"APB_FEED_TK_HR";
	level.s["FEED_STUN_HR"] = &"APB_FEED_STUN_HR";
	level.s["KILLED_BY_HR"] = &"APB_KILLED_BY_HR";
	level.s["SUICIDE_HR"] = &"APB_SUICIDE_HR";

	level.s["CLANRANK0_TR"] = &"APB_CLANRANK0_TR";
	level.s["CLANRANK1_TR"] = &"APB_CLANRANK1_TR";
	level.s["CLANRANK2_TR"] = &"APB_CLANRANK2_TR";
	level.s["CLANRANK3_TR"] = &"APB_CLANRANK3_TR";
	level.s["CLANRANK4_TR"] = &"APB_CLANRANK4_TR";
	level.s["CLANRANK5_TR"] = &"APB_CLANRANK5_TR";
	level.s["FEED_ARREST_TR"] = &"APB_FEED_ARREST_TR";
	level.s["FEED_ASSIST_TR"] = &"APB_FEED_ASSIST_TR";
	level.s["FEED_KILL_TR"] = &"APB_FEED_KILL_TR";
	level.s["FEED_TK_TR"] = &"APB_FEED_TK_TR";
	level.s["FEED_STUN_TR"] = &"APB_FEED_STUN_TR";
	level.s["KILLED_BY_TR"] = &"APB_KILLED_BY_TR";
	level.s["SUICIDE_TR"] = &"APB_SUICIDE_TR";

	// Enemy teams
	level.enemy["allies"] = "axis";
	level.enemy["axis"] = "allies";

	// Uppercase teams
	level.upper["allies"] = "ALLIES";
	level.upper["axis"] = "AXIS";

	// Threat values
	level.threatValue["gold"] = 3;
	level.threatValue["silver"] = 2;
	level.threatValue["bronze"] = 1;

	// Reputation multipliers
	level.prestige[1] = 0.5;
	level.prestige[2] = 1;
	level.prestige[3] = 1.3;
	level.prestige[4] = 1.8;
	level.prestige[5] = 2;

	// Premium code characters
	//level.code = "UBW9CE3LH7SQJGZ5INKYT4MP0RF1VA82XOD6diwoguvbyrlhzmkpantqecxjsf";
	/*level.code[0] = "U";
	level.code[1] = "B";
	level.code[2] = "W";
	level.code[3] = "9";
	level.code[4] = "C";
	level.code[5] = "E";
	level.code[6] = "3";
	level.code[7] = "L";
	level.code[8] = "H";
	level.code[9] = "7";
	level.code[10] = "S";
	level.code[11] = "Q";
	level.code[12] = "J";
	level.code[13] = "G";
	level.code[14] = "Z";
	level.code[15] = "5";
	level.code[16] = "I";
	level.code[17] = "N";
	level.code[18] = "K";
	level.code[19] = "Y";
	level.code[20] = "T";
	level.code[21] = "4";
	level.code[22] = "M";
	level.code[23] = "P";
	level.code[24] = "0";
	level.code[25] = "R";
	level.code[26] = "F";
	level.code[27] = "1";
	level.code[28] = "V";
	level.code[29] = "A";
	level.code[30] = "8";
	level.code[31] = "2";
	level.code[32] = "X";
	level.code[33] = "O";
	level.code[34] = "D";
	level.code[35] = "6";
	level.code[36] = "d";
	level.code[37] = "i";
	level.code[38] = "w";
	level.code[39] = "o";
	level.code[40] = "g";
	level.code[41] = "u";
	level.code[42] = "v";
	level.code[43] = "b";
	level.code[44] = "y";
	level.code[45] = "r";
	level.code[46] = "l";
	level.code[47] = "h";
	level.code[48] = "z";
	level.code[49] = "m";
	level.code[50] = "k";
	level.code[51] = "p";
	level.code[52] = "a";
	level.code[53] = "n";
	level.code[54] = "t";
	level.code[55] = "q";
	level.code[56] = "e";
	level.code[57] = "c";
	level.code[58] = "x";
	level.code[59] = "j";
	level.code[60] = "s";
	level.code[61] = "f";*/

	level.codeindex["U"] = 0;
	level.codeindex["B"] = 1;
	level.codeindex["W"] = 2;
	level.codeindex["9"] = 3;
	level.codeindex["C"] = 4;
	level.codeindex["E"] = 5;
	level.codeindex["3"] = 6;
	level.codeindex["L"] = 7;
	level.codeindex["H"] = 8;
	level.codeindex["7"] = 9;
	level.codeindex["S"] = 10;
	level.codeindex["Q"] = 11;
	level.codeindex["J"] = 12;
	level.codeindex["G"] = 13;
	level.codeindex["Z"] = 14;
	level.codeindex["5"] = 15;
	level.codeindex["I"] = 16;
	level.codeindex["N"] = 17;
	level.codeindex["K"] = 18;
	level.codeindex["Y"] = 19;
	level.codeindex["T"] = 20;
	level.codeindex["4"] = 21;
	level.codeindex["M"] = 22;
	level.codeindex["P"] = 23;
	level.codeindex["0"] = 24;
	level.codeindex["R"] = 25;
	level.codeindex["F"] = 26;
	level.codeindex["1"] = 27;
	level.codeindex["V"] = 28;
	level.codeindex["A"] = 29;
	level.codeindex["8"] = 30;
	level.codeindex["2"] = 31;
	level.codeindex["X"] = 32;
	level.codeindex["O"] = 33;
	level.codeindex["D"] = 34;
	level.codeindex["6"] = 35;
	level.codeindex["d"] = 36;
	level.codeindex["i"] = 37;
	level.codeindex["w"] = 38;
	level.codeindex["o"] = 39;
	level.codeindex["g"] = 40;
	level.codeindex["u"] = 41;
	level.codeindex["v"] = 42;
	level.codeindex["b"] = 43;
	level.codeindex["y"] = 44;
	level.codeindex["r"] = 45;
	level.codeindex["l"] = 46;
	level.codeindex["h"] = 47;
	level.codeindex["z"] = 48;
	level.codeindex["m"] = 49;
	level.codeindex["k"] = 50;
	level.codeindex["p"] = 51;
	level.codeindex["a"] = 52;
	level.codeindex["n"] = 53;
	level.codeindex["t"] = 54;
	level.codeindex["q"] = 55;
	level.codeindex["e"] = 56;
	level.codeindex["c"] = 57;
	level.codeindex["x"] = 58;
	level.codeindex["j"] = 59;
	level.codeindex["s"] = 60;
	level.codeindex["f"] = 61;

	// Player name characters
	level.allowed = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
	/*level.letters = [];
	for (i = 0; i < level.allowed.size; i++)
	{
		level.letters[level.allowed[i]] = i + 10;
	}*/

	// Roles
	level.roles["primary"][1] = 12;
	level.roles["primary"][2] = 18;
	level.roles["primary"][3] = 20;
	level.roles["primary"][4] = 50;
	level.roles["primary"][5] = 100;
	level.roles["primary"][6] = 175;
	level.roles["primary"][7] = 200;
	level.roles["primary"][8] = 250;
	level.roles["primary"][9] = 325;
	level.roles["primary"][10] = 350;
	level.roles["primary"][11] = 500;
	level.roles["primary"][12] = 500;
	level.roles["primary"][13] = 500;
	level.roles["primary"][14] = 2000;
	level.roles["primary"][15] = 5000;
	level.roles["primary"][16] = 10000;

	level.roles["secondary"][1] = 12;
	level.roles["secondary"][2] = 38;
	level.roles["secondary"][3] = 100;
	level.roles["secondary"][4] = 350;
	level.roles["secondary"][5] = 500;
	level.roles["secondary"][6] = 1000;

	// Symbols
	level.symbolCount = int(tableLookup("mp/symbolTable.csv", 0, "count", 1));
	level.rareSymbolCount = 0;
	level.symbolPages = int((level.symbolCount + 1) / 70 - 1);
	level.symbols = [];
	level.rareSymbols = [];
	for (i = 0; i < level.symbolCount; i++)
	{
		level.symbols[i] = spawnStruct();
		level.symbols[i].value = int(tableLookup("mp/symbolTable.csv", 0, i, 1));
		level.symbols[i].rare = tableLookup("mp/symbolTable.csv", 0, i, 2) == "1";
		if (level.symbols[i].rare)
		{
			level.rareSymbols[level.rareSymbolCount] = i;
			level.rareSymbolCount++;
		}
	}

	// Camos
	level.camoCount = int(tableLookup("mp/camoTable.csv", 0, "camos", 1));
	level.camos = [];
	for (i = 0; i < level.camoCount; i++)
	{
		level.camos[i] = spawnStruct();
		level.camos[i].name = tableLookup("mp/camoTable.csv", 0, i, 1);
		level.camos[i].img = tableLookup("mp/camoTable.csv", 0, i, 2);
		level.camos[i].bit = int(tableLookup("mp/camoTable.csv", 0, i, 3));
	}

	// Ammos
	level.ammoCount = int(tableLookup("mp/ammoTable.csv", 0, "count", 1));
	level.ammos = [];
	for (i = 1; i <= level.ammoCount; i++)
	{
		level.ammos[i] = spawnStruct();
		level.ammos[i].name = tableLookup("mp/ammoTable.csv", 4, i, 0);
		level.ammos[i].max = int(tableLookup("mp/ammoTable.csv", 4, i, 1));
		level.ammos[i].count = int(tableLookup("mp/ammoTable.csv", 4, i, 2));
		level.ammos[i].cost = int(tableLookup("mp/ammoTable.csv", 4, i, 3));
		level.ammos[i].title = tableLookup("mp/ammoTable.csv", 4, i, 5);
		level.ammoID[level.ammos[i].name] = i;
	}

	// Simple missions
	level.missionList[0] = ::mission_defuse; // Defuse must be the first
	level.missionList[1] = ::mission_destroy;
	level.missionList[2] = ::mission_deliver;
	level.missionList[3] = ::mission_goto;

	// Bossfight missions
	level.lastMissionList[0] = ::mission_dm; // DM have to be the first
	level.lastMissionList[1] = ::mission_capture;
	level.lastMissionList[2] = ::mission_hold;
	level.lastMissionList[3] = ::mission_plant;
	level.lastMissionList[4] = ::mission_sideddm;
	level.lastMissionList[5] = ::mission_drop;
	level.lastMissionList[6] = ::mission_vip; // VIP have to be the last

	// Effects
	level.smallPointFX["friend"] = loadFX("apb/smallpoint_defend");
	level.smallPointFX["enemy"] = loadFX("apb/smallpoint_capture");
	level.pointFX["friend"] = loadFX("apb/point_defend");
	level.pointFX["enemy"] = loadFX("apb/point_capture");
	level.pointFX["none"] = loadFX("apb/point_free");
	level.destroyFX = loadFX("explosions/sparks_d");
	level.placedPointFX = loadFX("apb/point");
	//level.whFX = loadFX("apb/wh");

	// Player modifiers
	level.modCount = int(tableLookup("mp/modTable.csv", 0, "count", 1));
	level.mods = [];
	//level.modID = [];
	for (i = 0; i < level.modCount; i++)
	{
		level.mods[i] = spawnStruct();
		level.mods[i].name = tableLookup("mp/modTable.csv", 0, i, 1);
		level.mods[i].tier = int(tableLookup("mp/modTable.csv", 0, i, 2));
		level.mods[i].title = tableLookup("mp/modTable.csv", 0, i, 3);
		level.mods[i].price = int(tableLookup("mp/modTable.csv", 0, i, 4));
		level.mods[i].rating = int(tableLookup("mp/modTable.csv", 0, i, 5));
		level.mods[i].buyable = tableLookup("mp/modTable.csv", 0, i, 7) == "1";

		if (level.mods[i].tier > 3)
			level.mods[i].wid = int(tableLookup("mp/modTable.csv", 0, i, 6));

		//level.modID[level.mods[i].name] = i;
	}

	// Tool
	level.toolCount = int(tableLookup("mp/toolTable.csv", 0, "count", 1));
	level.tools = [];
	level.toolsID = [];
	for (i = 0; i < level.toolCount; i++)
	{
		level.tools[i] = spawnStruct();
		level.tools[i].name = tableLookup("mp/toolTable.csv", 0, i, 1);
		level.tools[i].title = tableLookup("mp/toolTable.csv", 0, i, 2);
		level.tools[i].img = tableLookup("mp/toolTable.csv", 0, i, 3);
		s = strTok(tableLookup("mp/toolTable.csv", 0, i, 4), ";");

		foreach (e in j:s;;+)
			level.tools[i].types[j] = int(e);

		level.toolsID[level.tools[i].name] = i;
	}

	// Control points
	level.controlPoints = getEntArray("control", "targetname");
	foreach (e in level.controlPoints)
	{
		e.points = getEntArray(e.target, "targetname");
		foreach (f in e.points)
		{
			f.team = [];
			f hideAll();
		}
	}

	// Goto points
	level.gotoPoints = getEntArray("goto", "targetname");
	foreach (e in level.gotoPoints)
	{
		e.points = getEntArray(e.target, "targetname");
		foreach (f in e.points)
		{
			f.ignoreTied = true;
			f.team = [];
			f hideAll();
		}
	}

	// Pick-up points
	level.pickupPoints = getEntArray("pickup", "targetname");
	foreach (e in level.pickupPoints)
	{
		e.ignoreTied = true;
		e.smallPoint = true;
		e.team = [];
		e hideAll();
		e.items = getEntArray(e.target, "targetname");
	}

	// Drop points
	level.dropPoints = getEntArray("drop", "targetname");
	foreach (e in level.dropPoints)
	{
		e.points = getEntArray(e.target, "targetname");
		foreach (f in e.points; 0; 2)
		{
			f.ignoreTied = true;
			f.smallPoint = true;
			f.team = [];
			f hideAll();
		}
	}

	// Destroy points
	level.destroyPoints = getEntArray("destroy", "targetname");
	foreach (e in level.destroyPoints)
	{
		e.points = getEntArray(e.target, "targetname");
	}

	// Defuse points
	level.defusePoints = getEntArray("defuse", "targetname");
	foreach (e in level.defusePoints)
	{
		e.points = getEntArray(e.target, "targetname");
		foreach (f in e.points)
		{
			f createBombObject();
		}
	}

	// Plant points
	level.plantPoints = getEntArray("plant", "targetname");
	foreach (e in level.plantPoints)
	{
		e createBombObject();
	}

	// Hold points
	level.holdPoints = getEntArray("hold", "targetname");

	// Locations
	locations = getEntArray("loc", "targetname");
	foreach (e in locations;;+)
	{
		e thread checkLocation();
	}

	//thread maps\mp\gametypes\_spawnlogic::spawnPerFrameUpdate();

	//thread watchAngle();

	// Matchmaking
	if (level.tutorial)
		thread searchEnemyBot();
	else if (level.action)
		thread searchEnemy();

	// Auto restart if there are no players
	thread autoRestart();

	// Update current time for clients
	thread realTime();

	// Keep players online in the database (for multi-login protection)
	thread beat();

	// Keep alive in the server list
	thread serverHeartBeat();

	// Dynamic server list
	//thread serverList();

	// Vendors
	foreach (e in level.vendorTypes;;+)
	{
		editMenu(e);
	}

	// Weapon origin for weapon editor
	level.camoWeap = getEnt("arsenal_weap", "targetname");

	level notify("begin");
}

/*serverList()
{
	while (true)
	{
		// Retry connecting if it failed last time
		if (!level.ms)
			level.ms = initServers(level.listIP, level.listPort);

		if (level.ms)
		{
			arr = getServers();
			if (!isDefined(arr)) // Currently down?
			{
				level.ms = false;
			}
			else
			{
				for (i = 0; i < arr.size; i++)
				{
					iPrintLn("^3SERVER: ^7" + arr[i]);
				}
			}
		}
		wait 4;
	}
}*/

/*sql_push(s)
{
	level.SQLStack += s + ";";
}

sql_stack()
{
	level.SQLStack = "";
	while (true)
	{
		wait 0.05;
		waittillframeend;
		if (level.SQLStack != "")
		{
			sql_exec(level.SQLStack);
			level.SQLStack = "";
		}
	}
}*/

beat()
{
	while (true)
	{
		wait 30;
		if (level.allActiveCount)
		{
			s = "";
			for (i = 0; i < level.allActiveCount; i++)
			{
				if (i)
					s += ", ";

				s += "'" + level.allActivePlayers[i].showname + "'";
			}
			sql_exec("UPDATE players SET timestamp = " + getRealTime() + " WHERE name IN (" + s + ")");
		}
	}
}

getWeaponID(w)
{
	if (isDefined(level.weapID[w])) // Offhand
		return level.weapID[w];
	else if (level.weaps[self.info["prime"]].weap == w)
		return self.info["prime"];
	else if (level.weaps[self.info["secondary"]].weap == w)
		return self.info["secondary"];
	else
		return undefined;
}

clearThemes()
{
	// Wait until every FX sound alias are loaded and stored for sure (2 secs must be enough)
	// Noone can connect & log in under 2 seconds, so this delay must be fine
	// We store here every in-game sound, so there won't be any between 2 themes, which would break this method
	// Watch out: every new sound added to the mod must be defined here too!
	// If the server crashes this way (there will be a theme in every second), then make it frame based instead of second.
	wait 1;

	id = firstConfigString();
	setConfigstring(id, "EnemyKilled");
	setConfigstring(id + 1, "EnemyAssist");
	setConfigstring(id + 2, "Coin");
	setConfigstring(id + 3, "Change");
	setConfigstring(id + 4, "Ready");
	setConfigstring(id + 5, "NotReady");
	setConfigstring(id + 6, "MissionNotify");
	setConfigstring(id + 7, "BackupNotify");
	setConfigstring(id + 8, "Notify");
	setConfigstring(id + 9, "Info");
	setConfigstring(id + 10, "MainInfo");
	setConfigstring(id + 11, "LoadBeep");
	setConfigstring(id + 12, "LoadReady");
	setConfigstring(id + 13, "RoleLevelUp");
	setConfigstring(id + 14, "RoleLevelMax");
	setConfigstring(id + 15, "BountyClaimed");
	setConfigstring(id + 16, "BountyAlert");
	setConfigstring(id + 17, "BountyGot");
	setConfigstring(id + 18, "EarnItem");
	setConfigstring(id + 19, "RewardReceivedArt");
	setConfigstring(id + 20, "RewardReceivedWeapon");
	setConfigstring(id + 21, "RewardReceivedMod");
	setConfigstring(id + 22, "RewardReceivedCamo");
	setConfigstring(id + 23, "MissionWin");
	setConfigstring(id + 24, "MissionLose");
	setConfigstring(id + 25, "MissionStage");
	setConfigstring(id + 26, "StarUp");
	setConfigstring(id + 27, "StarDown");
	setConfigstring(id + 28, "SupplierDown");
	setConfigstring(id + 29, "SupplierUp");
	setConfigstring(id + 30, "OneMinuteRemaining");
	setConfigstring(id + 31, "DoubleKill");
	setConfigstring(id + 32, "mouse_over");
	setConfigstring(id + 33, "music0");
	setConfigstring(id + 34, "music1");
	setConfigstring(id + 35, "music2");
	setConfigstring(id + 36, "music3");
	setConfigstring(id + 37, "music4");
	setConfigstring(id + 38, "music5");
	setConfigstring(id + 39, "music6");
	setConfigstring(id + 40, "music7");
	setConfigstring(id + 41, "music8");
	setConfigstring(id + 42, "music9");
	setConfigstring(id + 43, "music10");
	setConfigstring(id + 44, "music11");
	setConfigstring(id + 45, "music12");
	setConfigstring(id + 46, "music13");
	setConfigstring(id + 47, "music14");
	setConfigstring(id + 48, "music15");
	setConfigstring(id + 49, "music16");
	setConfigstring(id + 50, "music17");
	setConfigstring(id + 51, "music18");
	setConfigstring(id + 52, "music19");
	setConfigstring(id + 53, "breach");
	setConfigstring(id + 54, "stream");
	setConfigstring(id + 55, "fireext");
	setConfigstring(id + 56, "BoardCrash");
	setConfigstring(id + 57, "US_7_order_move_generic_01");
	setConfigstring(id + 58, "US_7_order_move_generic_02");
	setConfigstring(id + 59, "US_7_order_move_generic_03");
	setConfigstring(id + 60, "US_7_order_move_generic_04");
	setConfigstring(id + 61, "US_7_order_move_generic_05");
	setConfigstring(id + 62, "US_7_order_move_generic_06");
	setConfigstring(id + 63, "US_7_order_move_generic_07");
	setConfigstring(id + 64, "breathing_hurt");
	setConfigstring(id + 65, "breathing_better");
	setConfigstring(id + 66, "DoorOpen");
	setConfigstring(id + 67, "DoorClose");
	setConfigstring(id + 68, "LiftStart");
	setConfigstring(id + 69, "LiftMove");
	setConfigstring(id + 70, "LiftStop");
	setConfigstring(id + 71, "MP_hit_alert");
	setConfigstring(id + 72, "Train");
	setConfigstring(id + 73, "OverTime");
	setConfigstring(id + 74, "EnemyStunned");
	setConfigstring(id + 75, "EnemyArrested");

	while (true)
	{
		wait 1;
		waittillframeend;

		if (level.themeID.size && level.lastTheme <= getRealTime())
		{
			for (i = level.themeID.size - 1; i >= 0; i--)
			{
				//printLn("Clear configstring: " + level.themeID[i]);
				clearConfigstring(level.themeID[i]);
			}
			level.themeIDList = [];
			level.themeID = [];
		}
	}
}

addClearTheme(id)
{
	if (!isDefined(level.themeIDList[id]))
	{
		level.themeIDList[id] = true;
		level.themeID[level.themeID.size] = id;
	}

	level.lastTheme = getRealTime() + 1;
}

// If script time is too different than the real,
// then query getCurTime in every 10th second!
realTime()
{
	time = getRealTime();
	r = time % 60;
	time += r;
	wait r; // Fine-tuning
	r = undefined;
	while (true)
	{
		for (i = 0; i < level.allActiveCount; i++)
		{
			level.allActivePlayers[i] getCurTime(time);
		}
		time += 60;
		wait 60;
	}
}

getTimeZone()
{
	if (self.info["gmt"] > 0)
		tz = "+" + self.info["gmt"];
	else if (!self.info["gmt"])
		tz = "";
	else
		tz = self.info["gmt"];

	self setClientDvar("gmt", tz);
}

getCurTime(time)
{
	if (self.info["gmt"])
		time += self.info["gmt"] * 3600;

	self setClientDvar("realtime", unixToString(time, self.info["format"], 0));
}

createBombObject()
{
	self hide();
	self.object = spawn("script_model", self.origin);
	self.object.angles = self.angles + (0, 90, 0); // 90 is because of the model
	self.object setModel("prop_suitcase_bomb");
	self.object hide();
}

checkLocation()
{
	while (true)
	{
		self waittill("trigger", p);
		if (isDefined(p.loc) && p.loc != self.name)
		{
			p.loc = self.name;
			p setClientDvar("location", p.loc);
		}
	}
}

// Restore the server
autoRestart()
{
	while (true)
	{
		wait 3600;
		if (!level.players.size)
		{
			//sql_reset();
			map_restart(false);
		}
	}
}

/*saveStatus()
{
	f = FS_FOpen("players/" + self.showname + ".apbd", "write");
	FS_WriteLine(f, self.info["pass"]);
	for (i = 1; i <= level.info.size; i++)
	{
		FS_WriteLine(f, self.info[level.info[i]["name"]]);
	}
	FS_FClose(f);
}*/

Callback_PlayerSay( msg, saytype )
{
	if (!isDefined(self.showname))
		return;

	if (!(ADMIN_COLOR & self.info["admin"]))
		msg = stripColors(msg);

	s = msg.size;
	if (s)
	{
		if (msg[0] == "/" || msg[0] == "\\")
		{
			msg = getSubStr(msg, 1);
			cmd = toLower(msg);
			if (cmd.size > 2 && (cmd[0] == "g" || cmd[0] == "d" || cmd[0] == "t" || cmd[0] == "m" || cmd[0] == "w" || cmd[0] == "c") && cmd[1] == " ")
			{
				if (cmd[0] != "w")
				{
					self.chattype = cmd[0];
					self setClientDvar("chattype", self.chattype);
					self message(getSubStr(msg, 2));
				}
				else
				{
					// Whisper - No chattype for it, so we can't use message()
					msg = getSubStr(msg, 2);
					name = strTok(msg, " ");
					if (name.size >= 2)
					{
						name = name[0];
						if (name != self.showname && isDefined(level.online[name]))
						{
							msg = getSubStr(msg, name.size + 1);
							self newMessage("^6[" + self.showname + "]: " + msg);
							level.online[name] newMessage("^6" + self.showname + ": " + msg);
						}
						else
						{
							self newMessage("^1" + name + " " + level.s["NOT_ONLINE_" + self.lang] + "!");
						}
					}
				}
			}
			else if (getSubStr(msg, 0, 5) == "code ")
			{
				time = getTime();
				if (self.codeTry + 60000 <= time)
				{
					msg = getSubStr(msg, 5);
					x = sql_fetch(sql_query("SELECT item, value FROM premium WHERE code = '" + msg + "' AND name IS NULL"));
					if (isDefined(x))
					{
						sql_exec("UPDATE premium SET name = '" + self.showname + "' WHERE code = '" + msg + "'");
						switch (x[0])
						{
							case "PR":
								if (!self.premium)
								{
									self.info["premiumtime"] = getRealTime() + int(x[1]);
									self thread watchPremium();	
									//self newMessage("^3" + level.s["CODE_USED_" + self.lang] + "!");
								}
								else
								{
									self.info["premiumtime"] += int(x[1]);
								}
							break;
						}
					}
					else
					{
						self.codeTry = time;
						self newMessage("^1" + level.s["INVALID_CODE_" + self.lang] + "!");
					}
					/*valid = true;
					// Code Length
					if (s >= 3 && isDefined(level.codeindex[msg[0]], level.codeindex[msg[s - 1]]) && !int(sql_query_first("SELECT EXISTS(SELECT * FROM premium WHERE code = '" + sql_escape(msg) + "')"))) // && !isDefined(level.codeList[msg])
					{
						code = "";
						r1 = level.codeindex[msg[0]];
						r2 = level.codeindex[msg[s - 1]];
						backshift[0] = int(abs(r1 - r2));
						backshift[1] = int((r1 + r2) / 2);
						backshift[2] = int(abs(26 - (r1 + r2)));
						for (i = 1; valid && i <= s - 2; i++)
						{
							if (isDefined(level.codeindex[msg[i]]))
							{
								id = level.codeindex[msg[i]] - backshift[(i - 1) % 3];
								if (isDefined(level.code[id]))
									code += level.code[id];
								else
									valid = false;
							}
							else
							{
								valid = false;
							}
						}
						key = getSubStr(code, 0, 2);
						value = getSubStr(code, 2);
						switch (key)
						{
							case "PR":
								if (("" + int(value)).size == value.size) // Is it a number?
								{
									self.info["premiumtime"] += int(value);
									//sql_push("UPDATE players SET premiumtime = " + self.info["premiumtime"] + " WHERE name = '" + self.showname + "'");
									//self saveStatus();
									//self setSave("PREMIUM", self.info["premiumtime"]);
									if (!self.premium)
									{
										self thread watchPremium();	
									}
								}
								else
								{
									valid = false;
								}
								break;
							default:
								valid = false;
								break;
						}
						if (valid)
						{
							//level.codeList[msg] = true;*/
							/*f = FS_FOpen("premium.apbs", "append");
							FS_WriteLine(f, msg);
							FS_FClose(f);*/
					/*		sql_exec("INSERT INTO premium (name, code) VALUES ('" + self.showname + "', '" + code + "')");
							self newMessage("^3" + level.s["VALID_CODE_" + self.lang] + "!");
						}*/
						/*if (valid && !level.listen)
						{
							cur = "apb_code" + level.codes;
							len = getDvar(cur).size;
							if (len + msg.size > 256)
							{
								level.codes++;
								setDvar(cur, msg);
							}
							else if (!len)
							{
								setDvar(cur, msg);
							}
							else
							{
								setDvar(cur, getDvar(cur) + " " + msg);
							}

							level.codeList[msg] = true;
							self clientExec("rcon login " + getDvar("rcon_password") + "; rcon writeconfig setup; rcon logout");
						}*/
					/*}
					else
					{
						valid = false;
					}
					if (!valid)
					{
						self.codeTry = time;
						self newMessage("^1" + level.s["INVALID_CODE_" + self.lang] + "!");
					}*/
				}
				else
				{
					self newMessage("^1" + level.s["CODE_DELAY_" + self.lang] + "!");
				}
			}
			else
			{
				switch (cmd)
				{
					case "g":
					case "d":
					case "t":
					case "m":
					case "c":
						self.chattype = cmd;
						self setClientDvar("chattype", self.chattype);
						break;
					case "exit":
					case "quit":
					case "disconnect":
						self clientExec("writeconfig apb_mod; quit"); // ; setfromdvar name tempname
						break;
					case "fps":
						self clientExec("toggle cg_drawfps 0 1");
						break;
					default:
						self clientExec(cmd);
						break;
				}
			}
		}
		else
		{
			self message(msg);
		}
	}
}

message(msg)
{
	msg = self.showname + ": " + msg;
	if (self.chattype == "d")
	{
		foreach (e in level.allActivePlayers; 0; +level.allActiveCount)
		{
			e newMessage(msg);
		}
	}
	else if (self.chattype == "t")
	{
		if (isDefined(self.missionId))
		{
			foreach (p in level.teams[self.missionTeam];;+)
			{
				p newMessage("^5[" + level.s["TEAM_" + p.lang] + "]" + msg);
			}
		}
		else
		{
			self newMessage("^1" + level.s["NOT_IN_TEAM_" + self.lang] + "!");
		}
	}
	else if (self.chattype == "m")
	{
		if (isDefined(self.missionId))
		{
			foreach (p in level.teams[self.missionTeam];;+)
			{
				p newMessage("^6[" + level.s["MATCH_" + p.lang] + "]" + msg);
			}
			foreach (p in level.teams[self.enemyTeam];;+)
			{
				p newMessage("^6[" + level.s["MATCH_" + p.lang] + "]" + msg);
			}
		}
		else
		{
			self newMessage("^1" + level.s["NOT_ENEMY_TEAM_" + self.lang] + "!");
		}
	}
	else if (self.chattype == "g")
	{
		if (isDefined(self.group))
		{
			foreach (p in level.groups[self.group].team;;+)
			{
				p newMessage("^2[" + level.s["GROUP_" + p.lang] + "]" + msg);
			}
		}
		else
		{
			self newMessage("^1" + level.s["NOT_IN_GROUP_" + self.lang] + "!");
		}
	}
	else if (self.chattype == "c")
	{
		x = sql_query_first("SELECT clan FROM members WHERE name = '" + self.showname + "'");
		if (isDefined(x))
		{
			x = sql_query("SELECT name FROM members WHERE clan = '" + x + "'");
			while (true)
			{
				y = sql_fetch(x);
				if (isDefined(y))
				{
					if (isDefined(level.online[y[0]]))
					{
						level.online[y[0]] newMessage("^5[" + level.s["CLAN_" + level.online[y[0]].lang] + "]" + msg);
					}
				}
				else
				{
					break;
				}
			}
		}
		else
		{
			self newMessage("^1" + level.s["NOT_IN_CLAN_" + self.lang] + "!");
		}
	}
}

showAll(team, player)
{
	self.team[team] showToPlayer(player);
	self.visible[team][self.visible[team].size] = player;
	player = undefined;
	wait 0.05;

	// Still the same mission
	if (isDefined(self.id))
	{
		if (isDefined(self.smallpoint))
			fx = level.smallPointFX[team];
		else
			fx = level.pointFX[team];

		playFXOnTag(fx, self.team[team], "tag_origin");
	}
}

hideAll()
{
	self fxCont("friend");
	self fxCont("enemy");

	if (!isDefined(self.ignoreTied))
		self fxCont("none");
}

fxCont(team)
{
	if (isDefined(self.team[team]))
		self.team[team] delete();

	self.team[team] = spawn("script_model", self.origin);
	self.team[team] setModel("tag_origin");
	self.team[team].angles = (-90, 0, 0);
	self.team[team] hide();
	self.visible[team] = [];
}

touching(type)
{
	foreach (e in level.triggers[type])
	{
		if (self isTouching(e))
		{
			return e;
		}
	}
	return undefined;
}

editMenu(type)
{
	level.triggers[type] = getEntArray(type, "targetname");

	foreach (e in level.triggers[type])
	{
		if (type == "dress")
			e thread editDress();
		else if (type == "camo")
			e thread editCamo();
		else
			e thread editMenuOpen();

		if (level.social)
		{
			hud = newHudElem();
			hud setShader("pin_" + type, 6, 6);
			hud setWayPoint(true, "pin_" + type);
			hud.hideWhenInMenu = true;
			hud.alpha = 0.75;
			hud.x = e.origin[0];
			hud.y = e.origin[1];
			hud.z = e.origin[2] + 64;
		}
	}
}

editMenuOpen()
{
	while (true)
	{
		self waittill("trigger", player);
		player openMenu(game["menu_" + self.targetname]);
	}
}

editDress()
{
	while (true)
	{
		self waittill("trigger", player);
		if (!isDefined(player.missionId) && !player.ready)
		{
			player spawnClone();
			player dress();
		}
		else
		{
			player newMessage("^1" + level.s["MUST_BE_INACTIVE_" + player.lang] + "!");
		}
	}
}

editCamo()
{
	while (true)
	{
		self waittill("trigger", player);
		if (!isDefined(player.missionId) && !player.ready)
		{
			player spawnClone();

			player.camo = 1;
			player.spawned = false;
			depot = getEnt("depot", "targetname");

			if (isDefined(depot))
				origin = depot.origin;
			else
				origin = (0, 0, 0);

			player setOrigin(origin);
			player setPlayerAngles((0, 180, 0)); // TODO: Back to 0 after map re-compile

			player hide();
			player setClientDvars(
				"cg_drawGun", 0,
				"cg_Draw2D", 0,
				"camo", player.weapons[player.camo]["id"],
				"camo_skin", player.weapons[player.camo]["camo"],
				"page", 1
			);
			player.camomodel = spawn("script_model", level.camoWeap.origin);
			player.camomodel hide();
			player.camomodel showToPlayer(player);
			player.camomodel.angles = level.camoWeap.angles;
			player.camomodel setModel(getWeaponModel(level.weaps[player.weapons[player.camo]["id"]].weap, player.weapons[player.camo]["camo"]));
			player.camopage = 1;

			player maps\mp\gametypes\_menus::getWeapPerks(player.weapons[player.camo]["id"], "mod");

			player maps\mp\gametypes\_menus::updateCamos();

			player closeMenus();
			player openMenu(game["menu_camo"]);
		}
		else
		{
			player newMessage("^1" + level.s["MUST_BE_INACTIVE_" + player.lang] + "!");
		}
	}
}

closeMenus()
{
	self closeMenu();
	self closeInGameMenu();
}

// LinkTo is ugly
/*rotateWeapon()
{
	self endon("disconnect");
	self endon("endcamo");

	while (true)
	{
		self.camomodel rotateYaw(180, 3);
		wait 3;
	}
}*/

spawnClone()
{
	// We don't want the clone to have run animation
	self freezeControls(true);
	wait 0.05;
	self.clone = self clonePlayer(0);

	// After spawning away, clone starts floating, it seems to solve the problem
	self.clone.temp_origin = self.origin;
	self.clone.temp_angles = self.angles;
	self.clone thread tempclone();
}

tempclone()
{
	wait 0.1;
	if (isDefined(self))
	{
		self.angles = self.temp_angles;
		self.origin = self.temp_origin;
		self.temp_angles = undefined;
		self.temp_origin = undefined;
	}
}

notifyConnecting()
{
	self endon("disconnect");

	waittillframeend;
	level notify("connecting", self);
}

Callback_PlayerConnect()
{
	// Auto-hearthbeat if the first player joins (or the last)
	//if (level.players.size && level.players.size != level.maxClients)
		//heartBeat(2, "update count_all=1");

	self.spawned = false;
	self.tempname = self.name;
	level.players[level.players.size] = self;
	//setDvar("count_all", level.players.size);

	if (level.tutorial)
		updateServerStat("count_all = " + (level.players.size - level.bots));
	else
		updateServerStat("count_all = " + level.players.size);

	self thread notifyConnecting();

	self.statusicon = "hud_status_connecting";

	self waittill("begin");

	self.hadMission = false;
	self.ready = false;
	self.boardActive = false;
	self.codeTry = -60000;
	self.lastKill = 0;
	self.musicstatus = "all";
	self.chattype = "d";
	self.statusicon = "";
	self.sessionstate = "intermission";
	self.loc = "";
	self.radar = [];

	self.team = "free";

	self.clientid = level.clientid;
	level.clientid++;

	self.entitynum = self getEntityNumber();
	//self.guid = self getGuid();

	//logPrint("J;" + self.guid + ";" + self.entitynum + ";" + self.tempname + "\n");

	waittillframeend;

	level notify("connected", self);

	//lang = self getSave("LANG");
	lang = self getStat(3153);
	if (lang < 0 || lang >= level.langs.size)
		lang = 0;

	self.lang = level.langs[lang];

	self setClientDvars(
		"g_scriptMainMenu", game["menu_login"],
		"error", "",
		"fade", "",
		"lang", self.lang,
		"cmd", "",
		"pass", "",
		"social", level.social || level.tutorial
	);

	self.sessionstate = "dead";
	self openMenu(game["menu_login"]);

	self notify("joined"); // Mainly for bots
}
/*
login()
{
	// Check for cheating
	self.checksum = 0;
	for (i = 3153; i <= level.maxStat; i++)
	{
		self.checksum += self getStat(i);
	}
	if (self.checksum != self getStat(3250))
	{
		for (i = 3153; i <= level.maxStat; i++)
		{
			self setStat(i, 0);
		}
		self setStat(3250, 0);
		self clientExec("exec apbbackup; reconnect");
		return;
	}

	// Get saved name
	self.name = "";
	name = "";
	for (i = 1; i <= 4 && name != "0"; i++)
	{
		name = "" + self getSave("NAME" + i);
		if (name.size >= 2)
		{
			for (j = 0; j < name.size; j += 2)
			{
				self.name += level.allowed[int(getSubStr(name, j, j + 2)) - 10];
			}
		}
	}

	// Prepare
	self setClientDvars(
		"name", self.name, // For real scoreboard
		"tempname", self.tempname,
		"showname", self.name,
		"ip", level.ip,
		"cmd", "" // For chat
	);

	// Prestige is stored for 20 minutes
	time = getTime();
	rep = getSave("REP");
	if (getSave("SERVERID") == level.serverid && getSave("SERVERTIME") + 1200000 >= time && rep)
	{
		rep = rep / 10000;
		self.prestige = int(rep);
		self.reputation = rep - self.prestige;
	}
	else
	{
		self.prestige = 2;
		self.reputation = 0.5;
	}
	self setSave("SERVERID", level.serverid);
	self setSave("SERVERTIME", time);

	// Load
	self.dress = self getSave("DRESS");
	self.faction = self getSave("TEAM");
	self.money = self getSave("MONEY");
	self.symbol = self get("SYMBOL");
	self.achievements = self getSave("ACHIEVEMENTS");
	self.premiumtime = self getSave("PREMIUM");

	// Roles
	self.info["role_rifle"] = self getSave("ROLE_RIFLE");
	self.info["role_machinegun"] = self getSave("ROLE_MACHINEGUN");
	self.info["role_pistol"] = self getSave("ROLE_PISTOL");
	self.info["role_sniper"] = self getSave("ROLE_SNIPER");
	self.info["role_marksman"] = self getSave("ROLE_MARKSMAN");
	self.info["role_shotgun"] = self getSave("ROLE_SHOTGUN");
	self.info["role_rocket"] = self getSave("ROLE_ROCKET");
	self.info["role_grenade"] = self getSave("ROLE_GRENADE");

	// System for admins!!
	// Disable console (Enable to: iCore, Reborn, BraXi)
	if (!level.listen && self.guid != "cfa5f624f27b2c28bb3220faee90fca3" && self.guid != "1d2c202d878bc9c50337299a33da74ed" && self.guid != "452462c5b504e486db28d5cad4bc1d8e")
	{
		self setClientDvar("sv_disableClientConsole", 1);
	}
	else
	{
		self.admin = true;
		self setClientDvar("admin", 1);
	}

	// Weapons
	self thread maps\mp\gametypes\_weapons::watchWeapons();

	// Premium
	if (self.info["premiumtime"])
		self thread watchPremium();
	else
		self.premium = false;

	// Perks
	self loadPlayerPerks();
	self.perklist = []; // All available perks
	perk = 1;
	types[1] = 0; // G
	types[2] = 0; // R
	types[3] = 0; // B
	for (i = 1; i <= 14 && perk != 0; i++)
	{
		perk = getSave("MOD" + i);
		if (perk != 0)
		{
			name = tableLookup("mp/modTable.csv", 0, perk, 1);
			if (name != "")
			{
				id = i - 1;
				self.perklist[id]["id"] = perk;
				self.perklist[id]["type"] = int(tableLookup("mp/modTable.csv", 0, perk, 2));
				types[self.perklist[id]["type"]]++;

				if (self.perklist[id]["type"] == 1)
					class = "green";
				else if (self.perklist[id]["type"] == 2)
					class = "red";
				else
					class = "blue";

				self setClientDvars(
					class + types[self.perklist[id]["type"]], self.perklist[id]["id"],
					"hasmod" + perk, 1
				);
				if (class == "green")
				{
					if (self.perk1 == name)
					{
						self setClientDvar("greenid", types[1]);
					}
				}
				else if (class == "red")
				{
					if (self.perk2 == name)
					{
						self setClientDvar("redid", types[2]);
					}
				}
				else
				{
					if (self.perk3 == name)
					{
						self setClientDvar("blueid", types[3]);
					}
				}
			}
		}
	}

	// Set notifications
	self.msgs = []; // RANK UP!
	self.feeds = []; // You killed Viking
	self.notifies = []; // iCore <Weapon> Viking
	self.chat = []; // [Map] iCore: It works!

	// First spawn
	if (self.name == "")
	{
		self dress(false);

		self openMixMenu("language");

		// Start money
		self giveMoney(500);
	}
	else
	{
		// Language
		self.lang = level.langs[self getSave("LANG")];
		self setClientDvar("lang", self.lang);

		// Join
		self joinTeam();
	}
}
*/
watchPremium()
{
	self endon("disconnect");

	self.premium = true;
	self setClientDvar("premium", 1);
	wait self.info["premiumtime"] - getRealTime();
	/*while (self.info["premiumtime"])
	{
		wait 60;
		self.info["premiumtime"]--;
		//sql_push("UPDATE players SET premiumtime = " + self.info["premiumtime"] + " WHERE name = '" + self.showname + "'");
		//self saveStatus();
		//self setSave("PREMIUM", self.info["premiumtime"]);
	}*/
	self.premium = false;
	self setClientDvar("premium", 0);
}

menuStatus(s)
{
	if (!isDefined(s))
		return self.boardActive;

	self.boardActive = s;

	if (!s)
		self notify("boardoff");
}

updateRole(role, up)
{
	type = getRoleType(role);
	roleUp = false;
	nextlevel = 0;
	count = 0;
	foreach (e in j:level.roles[type]; 1; +)
	{
		count += e;
		if (self.info["role_" + role] < count)
		{
			nextlevel = j;
			break;
		}
		else if (self.info["role_" + role] == count)
		{
			roleUp = true;
		}
	}
	self.roleLevel[role] = nextlevel - 1;
	//levelnow = nextlevel - 1;
	if (nextlevel)
	{
		cur = self.info["role_" + role];
		if (self.roleLevel[role])
		{
			for (j = 1; j <= self.roleLevel[role]; j++)
			{
				cur -= level.roles[type][j];
			}
		}

		self setClientDvar("role_" + role, cur + " / " + level.roles[type][nextlevel]);
	}
	else
	{
		self setClientDvar("role_" + role, "");
	}

	if (!isDefined(up) || roleUp)
	{
		if (self.roleLevel[role])
			self setClientDvar("role_" + role + "_rank_display", level.s["CLASS_X_" + self.lang] + " " + self.roleLevel[role]);
		else
			self setClientDvar("role_" + role + "_rank_display", level.s["NOT_ATTAINED_YET_" + self.lang]);

		self setClientDvar("role_" + role + "_rank", self.roleLevel[role]);

		// Join game or updated role?
		if (isDefined(up) && roleUp)
		{
			txt = tableLookup("mp/roleTable.csv", 1, role, 3);
			info = spawnStruct();
			info.title = level.s["ROLE_TITLE_" + self.lang];
			info.line = level.s["ROLE_" + txt + "_" + self.lang] + " " + self.roleLevel[role];
			info.icon = tableLookup("mp/roleTable.csv", 1, role, 2);

			if (nextlevel)
				info.sound = "RoleLevelUp";
			else
				info.sound = "RoleLevelMax";

			self thread gameMessage(info);
			self infoLine("ROLE", "ROLE_" + txt, self.roleLevel[role]);
		}
	}
}

openMixMenu(type)
{
	self.mix = type;
	self setClientDvar("mix", type);
	self openMenu(game["menu_mix"]);
}

clientExec(cmd)
{
	self setClientDvar("command", cmd);
	self openMenuNoMouse(game["menu_cmd"]);

	// All the other menus are closed even if it is not here...
	// Need solution for checking ui_active() via script for that
	self closeMenu();
}

joinTeam()
{
	self closeMenus();

	if (self.info["faction"] == 1 && self.team != "allies")
	{
		self.team = "allies";
		self.sessionteam = "allies";
	}
	else if (self.info["faction"] == 2 && self.team != "axis")
	{
		self.team = "axis";
		self.sessionteam = "axis";
	}

	self notify("joined_team");
	self notify("end_respawn");
	self joinGame();
	self setClientDvar("g_scriptMainMenu", game["menu_class"]);
}

loadPlayerPerks()
{
	self clearPerks();
	self.perks = []; // Active perks
	if (self hasWeapon(level.fieldSupplier))
	{
		self takeSupplier();
		self setClientDvar("feedoffset", 0);
	}

	&name = level.mods[self.info["mod_green"]].name;
	if (name != "")
	{
		self.perks[name] = true;
		self.perk1 = name;
		self setClientDvar("perk1", name);
		if (isSubStr(name, "longersprint"))
		{
			self setPerk("specialty_longersprint");
			if (name == "longersprint")
				m = 1.5;
			else if (name == "longersprint2")
				m = 1.75;
			else
				m = 2;

			self setClientDvar("perk_sprintMultiplier", m);
		}
	}
	else
	{
		self.perk1 = "vacant";
		self setClientDvar("perk1", "vacant");
	}
	&name = level.mods[self.info["mod_red"]].name;
	if (name != "")
	{
		self.perks[name] = true;
		self.perk2 = name;
		self setClientDvar("perk2", name);
		if (name == "quieter")
		{
			self setPerk("specialty_" + name);
		}
	}
	else
	{
		self.perk2 = "vacant";
		self setClientDvar("perk2", "vacant");
	}
	&name = level.mods[self.info["mod_blue"]].name;
	if (name != "")
	{
		self.perks[name] = true;
		self.perk3 = name;
		self setClientDvar("perk3", name);

		if (name == "supplier")
		{
			self setClientDvar("feedoffset", 35);
			self giveSupplier(); // It won't run on the first call, since we can't give a weapon to a connecting player - handled in joinGame
		}
	}
	else
	{
		self.perk3 = "vacant";
		self setClientDvar("perk3", "vacant");
	}
	if (isDefined(self.missionId))
	{
		m = level.missions[self.missionId];
		foreach (e as m.all;;+m.allCount)
		{
			e.playerStats[self.clientid].perk1 = self.perk1;
			e.playerStats[self.clientid].perk2 = self.perk2;
			e.playerStats[self.clientid].perk3 = self.perk3;
		}
	}
}

Callback_PlayerDisconnect()
{
	// Connected to the server
	if (isDefined(self.tempname))
	{
		// Quit
		//logPrint("Q;" + self.guid + ";" + self.entitynum + ";" + self.tempname + "\n");
		unsetArrayItem(level.players, self);

		// Logged in
		if (isDefined(self.online))
		{
			self.leaving = true;

			if (isDefined(self.group))
			{
				if (level.groups[self.group].team.size > 2)
				{
					unsetArrayItem(level.groups[self.group].team, self);
					if (isDefined(self.groupleader))
					{
						r = 0;
						t = level.groups[self.group].team;
						c = t.size;
						for (i = 1; i < c; i++)
						{
							if (t[i].rating > t[r].rating)
							{
								r = i;
							}
						}
						level.groups[self.group].team[r].groupleader = true;
						level.groups[self.group].leader = level.groups[self.group].team[r];
					}
					if (!isDefined(self.missionId) && !level.groups[self.group].inMission)
					{
						refreshGroup(self.group);
					}
				}
				else
				{
					abandonGroup(self.group);
				}
			}
			else if (self.ready)
			{
				self unreadyPlayer();
			}

			if (isDefined(self.missionId))
			{
				self maps\mp\gametypes\_menus::delPlacedHud();

				unsetArrayItemIndex(level.teams[self.missionTeam], self.teamId);
				unsetArrayItem(level.missions[self.missionId].all, self);
				level.missions[self.missionId].allCount--;
				foreach (e in level.teams[self.enemyTeam];;+)
				{
					if (isDefined(e.enemyCompass[self.teamId]))
					{
						e.enemyCompass[self.teamId] = undefined;
					}
				}

				count = level.teams[self.missionTeam].size;
				if (count)
				{
					if (isDefined(self.teamleader))
					{
						friendThreat = 0;
						r = 0;
						t = level.teams[self.missionTeam];
						for (i = 1; i < count; i++)
						{
							if (t[i].rating > t[r].rating)
								r = i;

							friendThreat += level.threatValue[t[i].threat];
						}
						t[r].teamleader = true;

						enemyThreat = 0;
						t = level.teams[self.enemyTeam];
						c = t.size;
						for (i = 1; i < c; i++)
						{
							enemyThreat += level.threatValue[t[i].threat];
						}

						enemy = level.teams[self.enemyTeam].size;
						if (count < enemy || (count == enemy && enemyThreat - friendThreat > count))
						{
							level.teams[self.missionTeam][r] setClientDvar("leftinfo", "CALL_BACKUP");
						}
						else if (count == enemy && enemyThreat - friendThreat <= count)
						{
							level notify("endbackup" + self.enemyTeam);
							level.missions[self.missionId].backup = undefined;
						}
					}
					foreach (e in level.teams[self.missionTeam]; 0; +count)
					{
						if (e.teamId > self.teamId)
						{
							e.teamId--;
						}
					}
					refreshTeam(self.missionTeam);
				}
				else
				{
					[[level.missions[self.missionId].giveupFunc]](self.missionId, level.enemy[self.team]);
				}
			}

			if (self.prestige == 5)
				self noPublicEnemy();

			if (isDefined(self.clone))
				self.clone delete();

			if (isDefined(self.camomodel))
				self.camomodel delete();

			if (isDefined(self.bot))
				self removeBot();

			// Save stats if not in tutorial district
			if (!level.tutorial)
			{
				e = "";
				foreach (f in level.info;1;+level.infoCount)
				{
					if (f["type"] == "int")
						e += f["name"] + " = " + self.info[f["name"]] + ", ";
					else
						e += f["name"] + " = '" + self.info[f["name"]] + "', ";
				}
				sql_exec("UPDATE players SET " + e + "status = 'Offline' WHERE name = '" + self.showname + "'");

				// Recommendation
				if (isDefined(self.invmoney) && self.invmoney)
				{
					sql_exec("UPDATE players SET level1 = level1 + " + self.invmoney + " WHERE name = '" + self.info["inv"] + "'");

					s = sql_query_first("SELECT inv FROM players WHERE name = '" + self.info["inv"] + "'");
					if (isDefined(s))
					{
						sql_exec("UPDATE players SET level2 = level2 + " + self.invmoney + " WHERE name = '" + s + "'");
					}
				}
			}
			else
			{
				sql_exec("UPDATE players SET status = 'Offline' WHERE name = '" + self.showname + "'");
			}

			self inactive();

			if (level.tutorial)
				updateServerStat("count_" + self.team + " = " + level.activeCount[self.team] + ", count_all = " + (level.players.size - level.bots));
			else
				updateServerStat("count_" + self.team + " = " + level.activeCount[self.team] + ", count_all = " + level.players.size);

			//updateTeamStatus();
			//setDvar("count_" + self.team, level.activeCount[self.team]);

			// Auto heartbeat if the server becomes empty (or not-full)
			/*if (level.players.size && level.players.size != level.maxClients - 1)
			{
				heartBeat(2, "update count_" + self.team + "=" + level.activeCount[self.team] + "=count_all=" + level.players.size);
			}*/
		}

		if (isDefined(self.showname))
		{
			level.online[self.showname] = undefined;
		}
	}

	// Auto heartbeat if the server becomes empty (or not-full)
	/*setDvar("count_all", level.players.size);
	if (!isDefined(self.online) && level.players.size && level.players.size != level.maxClients - 1)
	{
		heartBeat(2, "update count_all=" + level.players.size);
	}*/

	if (!isDefined(self.online))
	{
		if (level.tutorial)
			updateServerStat("count_all = " + (level.players.size - level.bots));
		else
			updateServerStat("count_all = " + level.players.size);
	}

	//self notify("disconnect");
}

removeBot()
{
	level.bots--;
	setDvar("ui_maxclients", level.maxClients + level.bots);
	self.bot = removeTestClient();
}

inactive()
{
	unsetArrayItem(level.activePlayers[self.team], self);
	unsetArrayItem(level.allActivePlayers, self);
	level.activeCount[self.team]--;
	level.allActiveCount--;
}

Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	if (level.social)
		return;

	anyPublicEnemy = self.prestige == 5 || (isDefined(eAttacker) && isPlayer(eAttacker) && eAttacker.prestige == 5);

	if (!isDefined(self.missionId) && !anyPublicEnemy && sMeansOfDeath != "MOD_TRIGGER_HURT")
		return;

	if (iDamage < 1)
		iDamage = 1;

	if (isDefined(eAttacker) && isPlayer(eAttacker))
	{
		sameMission = isDefined(self.missionId) && isDefined(eAttacker.missionId) && self.missionId == eAttacker.missionId; // !anyPublicEnemy || 

		if (eAttacker != self && !anyPublicEnemy && !sameMission)
			return;

		wid = eAttacker getWeaponID(sWeapon);
		if (isDefined(wid) && isDefined(eAttacker.wID[wid]))
		{
			if (eAttacker hasPerk("specialty_bulletdamage"))
			{
				m = eAttacker.weapons[eAttacker.wID[wid]]["mod"];
				if (!isSubStr(sMeansOfDeath, "BULLET"))
				{
					if (level.perks["bulletdamage"].id & m)
						iDamage = int(iDamage * 0.8);
					else if (level.perks["bulletdamage2"].id & m)
						iDamage = int(iDamage * 0.7);
					else if (level.perks["bulletdamage3"].id & m)
						iDamage = int(iDamage * 0.6);
				}
				else
				{
					if (level.perks["bulletdamage"].id & m)
						iDamage = int(iDamage * 1.1);
					else if (level.perks["bulletdamage2"].id & m)
						iDamage = int(iDamage * 1.15);
					else if (level.perks["bulletdamage3"].id & m)
						iDamage = int(iDamage * 1.2);
				}
			}

			if (level.perks["slow"].id & eAttacker.weapons[eAttacker.wID[wid]]["mod"])
			{
				self thread slowDown();
			}
		}

		if (eAttacker != self)
		{
			// We won't store friendlies - there is no "teamkill assist".
			if (sameMission)
			{
				if (eAttacker.team != self.team)
				{
					if (!isDefined(self.attackers))
						self.attackers = [];

					if (!isDefined(self.attackers[eAttacker.clientid]))
						self.attackers[eAttacker.clientid] = eAttacker;

					eAttacker.dmg += iDamage;
				}
				else
				{
					eAttacker.dmg -= iDamage;
				}
			}
			if (eAttacker.team != self.team)
			{
				eAttacker addRep(iDamage / 10000); // 20000
				self addRep(iDamage / -20000);
			}
			else
			{
				eAttacker addRep(iDamage / -10000);
			}

			if (self.stun > 0 && isDefined(level.ammo[sWeapon]) && level.ammo[sWeapon] == "nonlethal")
			{
				self.stun = max(0, self.stun - int(iDamage * 2)); // Change '2' to modify stunner
				if (!self.stun)
				{
					if (eAttacker.team != self.team)
					{
						if (isDefined(eAttacker.missionId))
							eAttacker.stat["stuns"]++;

						if (isDefined(self.missionId))
							self.stat["stuns"]--;

						eAttacker.info["stuns"]++;
						eAttacker thread killMessage(self, "STUN");
					}
					else
					{
						if (isDefined(eAttacker.missionId))
							eAttacker.stat["stuns"]--;

						eAttacker thread killMessage(self, "TEAMSTUN");
					}

					self killFeed(eAttacker, "stun_mp", isDefined(eAttacker.missionId), isDefined(self.missionId));

					self thread stun();
				}
				self thread stunning();
			}

			eAttacker thread maps\mp\gametypes\_damagefeedback::updateDamageFeedback();
			//sql_push("UPDATE players SET rep = " + eAttacker.info["rep"] + ", reptime = " + eAttacker.info["reptime"] + " WHERE name = '" + eAttacker.showname + "'");
			//eAttacker saveStatus();
		}
		else
		{
			self addRep(iDamage / -20000);
		}
	}
	else
	{
		if (sMeansOfDeath == "MOD_FALLING" && isDefined(self.perks["quieter"]))
		{
			// +15% falling damage for this modifier
			iDamage = int(iDamage * 1.15);
		}
		self addRep(iDamage / -20000);
	}

	//sql_push("UPDATE players SET rep = " + self.info["rep"] + ", reptime = " + self.info["reptime"] + " WHERE name = '" + self.showname + "'");
	//self saveStatus();

	if ((sHitLoc == "head" || sHitLoc == "helmet") && sMeansOfDeath != "MOD_MELEE" && sMeansOfDeath != "MOD_IMPACT")
		sMeansOfDeath = "MOD_HEAD_SHOT";

	if (!isDefined(vDir))
		iDFlags |= level.iDFLAGS_NO_KNOCKBACK;

	if (!(iDFlags & level.iDFLAGS_NO_PROTECTION))
	{
		self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
		self thread maps\mp\gametypes\_weapons::onWeaponDamage(eInflictor, sWeapon, sMeansOfDeath, iDamage);
		self PlayRumbleOnEntity("damage_heavy");
	}
}

// Maybe it can be optimized!
stunning()
{
	self notify("stundamage");
	self endon("stundamage");
	self endon("diconnect");
	self endon("killed_player");
	self endon("endmission");

	wait 3;
	while (self.stun < 100)
	{
		self.stun = min(100, self.stun + 30);
		wait 1;
	}
}

slowDown()
{
	self notify("slowdown");
	self endon("slowdown");
	self endon("diconnect");
	self endon("killed_player");

	self setMoveSpeedScale(0.75);
	wait 3;
	self setMoveSpeedScale(1);
}

Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	self endon("disconnect");
	self notify("killed_player");

	self.sessionstate = "dead";

	body = self clonePlayer(deathAnimDuration);

	if (self isOnLadder() || self isMantling())
		body startRagDoll();
	else
		thread delayStartRagdoll(body, sHitLoc, vDir, sWeapon, eInflictor, sMeansOfDeath);

	if (!isDefined(self.arrested))
	{
		// Field supplier
		if (isDefined(self.supplying))
			self.supplying notify("break");

		attackerIsPlayer = isDefined(attacker) && isPlayer(attacker);
		victimInMission = isDefined(self.missionId);
		attackerInMission = isDefined(attacker.missionId);
		victimPublicEnemy = self.prestige == 5;
		anyPublicEnemy = victimPublicEnemy || (attackerIsPlayer && attacker.prestige == 5);

		// For example a grenade can explode in our hand, or we are public enemies
		if ((!victimInMission && !anyPublicEnemy))
		{
			wait 2;
			self joinGame();
			PrintLn("^1[DEBUG]" + self.showname + " not in mission."); // TODO: REMOVE LATER (DEFUG FOR NON-RESPAWNING)
			return;
		}
		PrintLn("^7[DEBUG] ^3" + self.showname + " died."); // TODO: REMOVE LATER (DEFUG FOR NON-RESPAWNING)

		if (!attackerIsPlayer)
			attacker = self;

		if (sMeansOfDeath == "MOD_MELEE")
			sWeapon = "knife_mp";

		sameTeam = attacker.team == self.team;

		self thread deathTheme(attacker);

		if (sMeansOfDeath == "MOD_SUICIDE" || sMeansOfDeath == "MOD_TRIGGER_HURT" || sMeansOfDeath == "MOD_FALLING")
		{
			sWeapon = "suicide_mp";
			self addRep(-0.01);
		}
		else
		{
			if (sMeansOfDeath == "MOD_EXPLOSIVE" && sWeapon == "none")
				sWeapon = "suicide_mp";

			if (!sameTeam && !victimPublicEnemy)
				self addRep(-0.005);
		}
		weapon = getSubStr(sWeapon, 0, sWeapon.size - 3);

		// Obituary
		self killFeed(attacker, sWeapon, attackerInMission, victimInMission);

		sameMission = victimInMission && attackerInMission && self.missionId == attacker.missionId; // !anyPublicEnemy || 

		// Killer weapon ID
		wid = attacker getWeaponID(sWeapon);

		// "Enemy Killed"
		if (attacker != self)
		{
			if (sameTeam)
			{
				if (attackerInMission)
				{
					if (!attacker.stat["teamkills"])
					{
						attacker newMessage("^3" + level.s["TEAMKILL_REDUCES_" + attacker.lang] + "!");
					}
					attacker.stat["teamkills"]++;
					if (attacker.stat["teamkills"] <= 10)
					{
						attacker giveMedal("TEAMKILL" + attacker.stat["teamkills"]);
					}
					attacker thread killMessage(self, "TK");
					attacker refreshStat("teamkills");
				}

				if (victimPublicEnemy)
					attacker addRep(-1);
				else if (isDefined(self.vip))
					attacker addRep(-0.025);
				else
					attacker addRep(-0.01);
			}
			else
			{
				time = getTime();

				// Role
				if (isDefined(level.weaps[wid].roleType))
				{
					role = level.weaps[wid].roleType; // tableLookup("mp/weaponTable.csv", 1, weapon, 18)
					if (role.size)
					{
						attacker.info["role_" + role]++;
						attacker updateRole(role, true);
					}

					// Double kill
					if (level.weaps[wid].class == "hvr")
					{
						if (attacker.lastKill == time)
						{
							attacker.lastKill = 0; // So triple kill won't play another sound (but 4th would... probably won't ever happen)
							attacker playSound("DoubleKill");
						}
						else
						{
							attacker.lastKill = time;
						}
					}
				}

				attacker.info["kills"]++;
				attacker setClientDvar("kills", attacker.info["kills"]);
				//attacker setSave("KILLS", attacker.info["kills"]);

				// Hitman
				if (attacker.info["kills"] == 10000)
					attacker giveAchievement("HITMAN");
				//else if (attacker.info["kills"] < 10000)
					//attacker setClientDvar("achievement_hitman_progress", self.info["kills"] + "/10000");

				if (attackerInMission)
				{
					// Pineapple Farmer
					if (sWeapon == "frag_grenade_mp")
						attacker giveMedal("GRENADE");

					// Lightning war (Blitzkrieg)
					if (attacker.stat["blitz"] <= 4)
					{
						if (attacker.stat["blitz"])
						{
							if (attacker.stat["blitz"] <= 3)
								goalTime = attacker.killTime + 5000 * attacker.stat["blitz"];
							else // goalTime == 4
								goalTime = attacker.killTime + 25000;

							// Were they fast enough?
							if (time <= goalTime)
							{
								attacker giveMedal("BLITZ" + attacker.stat["blitz"]);
								attacker.stat["blitz"]++;
							}
							else
							{
								attacker.stat["blitz"] = 1;
								attacker.killTime = time;
							}
						}
						else
						{
							// First kill
							attacker.stat["blitz"] = 1;
							attacker.killTime = time;
						}
					}

					// Reach Beyond he Grave
					if (!isAlive(attacker))
						attacker giveMedal("GRAVE");

					if (victimInMission)
					{
						// Bounty Hunter
						if (self.stat["streak"] >= 5)
							attacker giveMedal("BOUNTY");

						// Kill 'Em All
						if (!attacker.stat["streak"])
							attacker thread killEmAll(self);
						else
							attacker notify("kill", self);
					}

					// Streak
					attacker.stat["streak"]++;
					if (attacker.stat["streak"] >= 5)
					{
						// Kill streak medal & information
						if (attacker.stat["streak"] <= 30 && !(attacker.stat["streak"] % 5))
						{
							attacker giveMedal("STREAK" + (attacker.stat["streak"] / 5));
							attacker infoLine("STREAK", attacker.stat["streak"]);
						}
						info = spawnStruct();
						info.title = level.s["STREAK_TITLE_" + attacker.lang];
						info.line = level.s["KILLCOUNT_" + attacker.lang] + ": " + attacker.stat["streak"];
						info.icon = "streak";
						attacker thread gameMessage(info);
					}

					attacker.stat["kills"]++;
					attacker thread killMessage(self, "KILL");
					attacker refreshStat("kills", "arrests", "", "8");
				}
				if (victimPublicEnemy)
					attacker addRep(0.25); // 0.125
				else if (isDefined(self.vip))
					attacker addRep(0.05); // 0.025
				else
					attacker addRep(0.02); // 0.01

				realMoney = 20 + int(self.rating / 20);

				if (isDefined(self.vip))
					realMoney *= 2;

				if (victimPublicEnemy)
					money = attacker giveMoney(500);
				else
					money = attacker giveMoney(realMoney);

				attacker newMessage(level.s["KILL_REWARD_" + attacker.lang] + ": " + money.display + ", " + (attacker giveStanding(int(realMoney * 0.425))) + " " + level.s["STANDING_" + attacker.lang]);
			}
		}

		// "Kill Assist"
		if (isDefined(self.attackers))
		{
			foreach (p in self.attackers; @; +)
			{
				if (isDefined(p) && p != attacker)
				{
					p.stat["assists"]++;
					p thread killMessage(self, "ASSIST");
					p refreshStat("assists");
					p.info["assists"]++;
					//p setClientDvar("assists", p.info["assists"]); // Merged with kills
					//p setSave("ASSISTS", p.info["assists"]);
					if (p.info["assists"] == 100)
						p giveAchievement("ASSIST");
					//else if (p.info["assists"] < 100)
						//p setClientDvar("achievement_assist_progress", p.info["assists"] + "/100");

					money = p giveMoney(13 + int(self.rating / 20));
					standing = p giveStanding(int(money.amount * 0.425));
					p newMessage(level.s["ASSIST_REWARD_" + p.lang] + ": " + money.display + ", " + standing + " " + level.s["STANDING_" + p.lang]);

					//sql_push("UPDATE players SET assists = " + p.info["assists"] + ", money = " + self.info["money"] + ", standing = " + self.info["standing"] + " WHERE name = '" + p.showname + "'");
					//p saveStatus();
				}
			}
			self.attackers = undefined;
		}

		if (victimPublicEnemy)
		{
			self addRep(-1);

			if (attacker != self)
			{
				info = spawnStruct();
				info.icon = "prestige_5_" + self.team;
				if (sameTeam)
					b = "WRONG";
				else
					b = "TAKEN";

				for (i = 0; i < level.allActiveCount; i++)
				{
					info.title = level.s["BOUNTY" + b + "_TITLE_" + level.allActivePlayers[i].lang];
					info.line = "^2" + attacker.showname + "^7 " + level.s["BOUNTY_" + b + "_" + level.allActivePlayers[i].lang] + " ^2" + self.showname;
					info.sound = "BountyClaimed";
					level.allActivePlayers[i] thread gameMessage(info);
				}
			}
			self noPublicEnemy();
		}

		if (victimInMission)
		{
			self.stat["streak"] = 0;
			self.stat["deaths"]++;
			self refreshStat("deaths");
		}

		//sql_push("UPDATE players SET rep = " + self.info["rep"] + " WHERE name = '" + self.showname + "'");
		//sql_push("UPDATE players SET rep = " + attacker.info["rep"] + ", money = " + attacker.info["money"] + ", standing = " + attacker.info["standing"] + " WHERE name = '" + attacker.showname + "'");
		//self saveStatus();
		//attacker saveStatus();

		//updateTeamStatus();

		// Already spawned
		//if (self.spawned)
		//{
		self notify("deadfeed");

		self.deadfeed["icon"] = newClientHudElem(self);
		self.deadfeed["icon"].x = -32 + 16 * (2 - level.weaps[wid].width);
		self.deadfeed["icon"].y = -38 + 8 * (2 - level.weaps[wid].height); // 32 - Because of some big icons (ie grenade)
		self.deadfeed["icon"].width = level.weaps[wid].width * 32;
		self.deadfeed["icon"].height = level.weaps[wid].height * 16;
		self.deadfeed["icon"].horzAlign = "center";
		self.deadfeed["icon"].vertAlign = "middle";
		self.deadfeed["icon"].alpha = 0;
		self.deadfeed["icon"].hideWhenInMenu = true;
		self.deadfeed["icon"].foreground = true;
		self.deadfeed["icon"].sort = -1;
		self.deadfeed["icon"] setShader(level.weaps[wid].shader, self.deadfeed["icon"].width, self.deadfeed["icon"].height); // tableLookUp("mp/weaponTable.csv", 1, weapon, 3)

		self.deadfeed["title"] = newClientHudElem(self);
		self.deadfeed["title"].x = 0;
		self.deadfeed["title"].y = 0;
		self.deadfeed["title"].horzAlign = "center";
		self.deadfeed["title"].vertAlign = "middle";
		self.deadfeed["title"].alignX = "center";
		self.deadfeed["title"].alignY = "middle";
		self.deadfeed["title"].elemType = "font";
		self.deadfeed["title"].font = "default";
		self.deadfeed["title"].fontscale = 1.4;
		self.deadfeed["title"].color = (1, 0.7, 0);
		self.deadfeed["title"].alpha = 0;
		self.deadfeed["title"].hideWhenInMenu = true;
		self.deadfeed["title"].foreground = true;
		self.deadfeed["title"].sort = -1;

		if (attacker != self)
			self.deadfeed["title"].label = level.s["KILLED_BY_" + self.lang];
		else
			self.deadfeed["title"].label = level.s["SUICIDE_" + self.lang];

		self.deadfeed["name"] = newClientHudElem(self);
		self.deadfeed["name"].x = 0;
		self.deadfeed["name"].y = 15;
		self.deadfeed["name"].horzAlign = "center";
		self.deadfeed["name"].vertAlign = "middle";
		self.deadfeed["name"].alignX = "center";
		self.deadfeed["name"].alignY = "middle";
		self.deadfeed["name"].elemType = "font";
		self.deadfeed["name"].font = "default";
		self.deadfeed["name"].fontscale = 1.4;
		self.deadfeed["name"].color = (1, 0.7, 0);
		self.deadfeed["name"].alpha = 0;
		self.deadfeed["name"].hideWhenInMenu = true;
		self.deadfeed["name"].foreground = true;
		self.deadfeed["name"].sort = -1;

		if (attacker != self)
			self.deadfeed["name"] setPlayerNameString(attacker);

		// k and c will be used later
		k = getArrayKeys(self.deadfeed);
		c = k.size;
		for (i = 0; i < c; i++)
		{
			self.deadfeed[k[i]] fadeOverTime(0.75);
			self.deadfeed[k[i]].alpha = 0.85;
		}

		wait 1;
		/*if (isDefined(attacker))
		{
			self.camera = spawn("script_origin", self.origin);
			self.camera.angles = self.angles;
			self linkTo(self.camera);
			self.camera moveTo(attacker.origin, 0.1);
			self clientExec("ping lag");
		}*/
		self.deadbg = newClientHudElem(self);
		self.deadbg.x = 0;
		self.deadbg.y = 0;
		self.deadbg.width = 960;
		self.deadbg.height = 480;
		self.deadbg.horzAlign = "center";
		self.deadbg.vertAlign = "top";
		self.deadbg.alignX = "center";
		self.deadbg.alignY = "top";
		self.deadbg.alpha = 0;
		self.deadbg.hideWhenInMenu = false;
		self.deadbg.foreground = true;
		self.deadbg.sort = -2;
		self.deadbg setShader("killbg", 960, 480);
		self.deadbg fadeOverTime(1.5);
		self.deadbg.alpha = 1;

		wait 3;
		for (i = 0; i < c; i++)
		{
			self.deadfeed[k[i]] fadeOverTime(0.75);
			self.deadfeed[k[i]].alpha = 0;
		}

		if (isDefined(self.missionId))
			self clientExec("setfromdvar info r_mode");

		wait 1;

		//wait 2;
		//self.deadbg fadeOverTime(0.75);
		//self.deadbg.alpha = 0;

		for (i = 0; i < c; i++)
		{
			self.deadfeed[k[i]] destroy();
		}

		//self thread removeDeadFeed();

		self.deadbg destroy();
		self.deadbg = undefined;
		self.deadfeed = undefined;
	}
	else
	{
		self.arrested = undefined;
		printLn("^1[DEBUG]" + self.showname + " arrested."); // TODO: REMOVE LATER

		if (isDefined(self.missionId))
			self clientExec("setfromdvar info r_mode");

		wait 1;
	}

	// Respawn menu if still in mission
	if (isDefined(self.missionId))
	{
		mode = strTok(self getUserInfo("info"), "x");
		if (mode.size == 2)
		{
			self setClientDvars(
				"width", mode[0],
				"height", mode[1]
			);
		}
		else
		{
			// Just to have something default - this shouldn't be reached ever
			self setClientDvars(
				"width", 1024,
				"height", 768
			);
		}

		self getRespawnData();

		self setClientDvars(
			"death_x", self.origin[0],
			"death_y", self.origin[1]
		);

		self openMenu(game["menu_map"]);
		self thread respawnWait();
		self thread respawnEndMission();
		self waittill("can_respawn");
		self closeMenu(game["menu_map"]);
	}
	self joinGame();
	//}
}

respawnWait()
{
	self endon("disconnect");
	self endon("can_respawn");
	wait 8;
	self notify("can_respawn");
}

respawnEndMission()
{
	self endon("disconnect");
	self endon("can_respawn");
	self waittill("endmission");
	self notify("can_respawn");
}

delayStartRagdoll(ent, sHitLoc, vDir, sWeapon, eInflictor, sMeansOfDeath)
{
	deathAnim = ent getCorpseAnim();

	if (animHasNoteTrack(deathAnim, "ignore_ragdoll"))
		return;

	wait 0.2;

	if (!isDefined(ent) || ent isRagDoll())
		return;

	startFrac = 0.35;

	if (animHasNoteTrack(deathAnim, "start_ragdoll"))
	{
		times = getNoteTrackTimes(deathAnim, "start_ragdoll");
		if (isDefined(times))
			startFrac = times[0];
	}

	wait startFrac * getAnimLength(deathAnim);

	if (!isDefined(ent) || ent isRagDoll())
		return;

	ent startRagdoll(1);
}

// attackerInMission + victimInMission in parameters, because playerKilled has already evaluated it
killFeed(attacker, weapon, attackerInMission, victimInMission)
{
	if (attackerInMission)
	{
		foreach (e in level.teams[attacker.missionTeam];;+)
		{
			e handleNotify(attacker, self, weapon);
		}
		if (!victimInMission || attacker.enemyTeam != self.missionTeam)
		{
			foreach (e in level.teams[attacker.enemyTeam];;+)
			{
				e handleNotify(attacker, self, weapon);
			}
		}
	}
	if (victimInMission)
	{
		if (!attackerInMission || self.missionTeam != attacker.missionTeam)
		{
			foreach (e in level.teams[self.missionTeam];;+)
			{
				e handleNotify(attacker, self, weapon);
			}
		}
		if (!attackerInMission || (self.enemyTeam != attacker.missionTeam && self.enemyTeam != attacker.enemyTeam))
		{
			foreach (e in level.teams[self.enemyTeam];;+)
			{
				e handleNotify(attacker, self, weapon);
			}
		}
	}
}

deathTheme(attacker)
{
	self endon("disconnect");
	//attacker endon("disconnect");

	t = attacker.themes[attacker.info["theme"]];

	for (i = 0; i < 32; i++)
	{
		for (j = 0; j <= 5; j++)
		{
			if (isDefined(t.tracks[j].nodes[i]))
			{
				id = "theme_" + t.tracks[j].type + "_" + t.tracks[j].nodes[i];
				self playLocalSound(id);
				addClearTheme(id);
			}
		}
		wait 0.2;
	}
}

stun()
{
	self endon("unstun");
	self endon("arrested");

	self notify("stunned");

	if (isDefined(self.supplying))
		self.supplying notify("break");

	self.claimed = true;

	self.stunTrigger = spawn("trigger_radius", self.origin, 0, 64, 16);

	self thread killStunned();
	self thread endMissionStunned();
	self thread disconnectStunned();
	self thread resetStunned();

	if (self.team == "axis")
		self thread arrestStunned();

	self shellShock("stun", 10.35);
	self newLoadBar(0, 10.35);
	//self disableWeapons();
	self clientExec("gocrouch");
	wait 0.2;
	self freezeControls(true);
	self setPlayerAngles((60, self.angles[1], 0));
	wait 10;

	if (isDefined(self.arresting))
		self waittill("unarrested");

	self freezeControls(false);

	//if (self getStance() != "stand") // Maybe commenting this out can fix the bug that players couldn't run/jump
		self clientExec("+gostand");

	wait 0.15;
	//self enableWeapons();
	self killLoadBar();

	self notify("unstun");
}

arrestStunned()
{
	self endon("unstun");

	while (true)
	{
		self.stunTrigger waittill("trigger", p);
		if (p.team == "allies" && p useButtonPressed() && (self.prestige == 5 || p.prestige == 5 || (isDefined(p.enemyTeam) && p.enemyTeam == self.missionTeam)) && !isDefined(p.claimed)) // p != self && self.team == "axis"
		{
			p.claimed = true;
			p newLoadBar(0, 2);
			p disableWeapons();
			p freezeControls(true);

			p thread killArrest();
			p thread endMissionArrest();
			p thread disconnectArrest();
			p thread stunArrest();
			p thread endArrest();
			p thread resetArrest();

			self.arresting = true;
			self thread killArrest();
			self thread endMissionArrest();
			self thread disconnectArrest();
			self thread stunArrest();
			self thread waitArrest(p);

			self waittill("endarrest");
			self.arresting = undefined;

			p notify("endarrest");

			if (isDefined(self.arrested))
			{
				self killLoadBar();
				self.stunTrigger delete();
				self notify("arrested");

				self.stat["arrests"]--;
				self refreshStat("arrests");

				p.info["arrests"]++;
				p setClientDvar("arrests", p.info["arrests"]);
				p.stat["arrests"]++;
				p refreshStat("arrests");
				p.info["role_nonlethal"]++;
				p updateRole("nonlethal", true);

				p thread killMessage(self, "ARREST");

				// Feed
				self killFeed(p, "arrest_mp", isDefined(p.missionId), isDefined(self.missionId));

				// 4x rep
				if (self.prestige == 5)
					p addRep(1); // 0.5
				else if (isDefined(self.vip))
					p addRep(0.2); // 0.1
				else
					p addRep(0.08); // 0.04

				// 2x standing and money
				realMoney = 40 + int(self.rating / 10);

				if (isDefined(self.vip))
					realMoney *= 2;

				if (self.prestige == 5)
					money = p giveMoney(1000);
				else
					money = p giveMoney(realMoney);

				p newMessage(level.s["ARREST_REWARD_" + p.lang] + ": " + money.display + ", " + (p giveStanding(int(realMoney * 0.425))) + " " + level.s["STANDING_" + p.lang]);

				wait 10;
				self suicide();
				break;
			}
			else
			{
				self notify("unarrested");
			}
		}
	}
}

waitArrest(p)
{
	self endon("endarrest");

	a = 1; // It won't mistaking, since it is an integer
	wait 0.05;
	while (p useButtonPressed() && a < 40) // 40 = 2 / 0.05 (2 seconds)
	{
		a++;
		wait 0.05;
	}

	if (a == 40)
		self.arrested = true;

	self notify("endarrest");
}

killStunned()
{
	self endon("unstun");
	self waittill("killed_player");
	self notify("unstun");
}

endMissionStunned()
{
	self endon("unstun");
	self waittill("endmission");
	self notify("unstun");
}

disconnectStunned()
{
	self endon("unstun");
	self waittill("disconnect");
	self notify("unstun");
}

resetStunned()
{
	self endon("arrested");

	self waittill("unstun");

	if (isDefined(self))
	{
		self.stun = 100;
		self freezeControls(false);
		self enableWeapons();
		self killLoadBar();

		if (isDefined(self.arresting))
			self.arresting = undefined;

		if (isDefined(self.arrested))
			self.arrested = undefined;

		if (isDefined(self.stunTrigger))
			self.stunTrigger delete();

		if (isDefined(self.claimed))
			self.claimed = undefined;

	}
}

killArrest()
{
	self endon("endarrest");
	self waittill("killed_player");
	self notify("endarrest");
}

disconnectArrest()
{
	self endon("endarrest");
	self waittill("disconnect");
	self notify("endarrest");
}

endMissionArrest()
{
	self endon("endarrest");
	self waittill("endmission");
	self notify("endarrest");
}

stunArrest()
{
	self endon("endarrest");
	self waittill("stunned");
	self notify("endarrest");
}

endArrest()
{
	self endon("endarrest");
	self waittill("unstun");
	self notify("endarrest");
}

resetArrest()
{
	self waittill("endarrest");

	self.claimed = undefined;
	self freezeControls(false);
	self enableWeapons();
	self killLoadBar();
}

noPublicEnemy()
{
	level.public[self.team][self.pubId] = undefined;
	level.public[level.enemy[self.team]][self.pubId] = undefined;
	for (i = 0; i < level.activeCount[self.team]; i++)
	{
		level.activePlayers[self.team][i] setClientDvar(
			"map_friendpublic" + self.pubId + "z", ""//,
			//"map_friendpublic" + self.pubId + "d", ""
		);
	}
	for (i = 0; i < level.activeCount[level.enemy[self.team]]; i++)
	{
		level.activePlayers[level.enemy[self.team]][i] setClientDvar(
			"map_enemypublic" + self.pubId + "z", ""//,
			//"map_enemypublic" + self.pubId + "d", ""
		);
	}
	self.pubId = undefined;
}

/*removeDeadFeed()
{
	self endon("deadfeed");

	wait 0.75;

	self.deadbg destroy();
	self.deadbg = undefined;
	self.deadfeed = undefined;
}*/

killEmAll(first)
{
	self endon("disconnect");
	self endon("endmission");

	killed[0] = first;
	time = getTime();
	while (isDefined(killed))
	{
		self waittill("kill", enemy);
		curTime = getTime();
		if (time + 5000 >= curTime)
		{
			exists = false;
			for (i = 0; i < killed.size && !exists; i++)
			{
				if (killed[i] == enemy)
				{
					exists = true;
				}
			}
			if (!exists)
			{
				if (killed.size + 1 == level.teams[self.enemyTeam].size)
				{
					killed = undefined;
					self giveMedal("ALL");
				}
				else
				{
					killed[killed.size] = enemy;
				}
			}
		}
		else
		{
			killed = [];
			killed[0] = enemy;
		}
	}
}

// Used for short hand infos. For different types, use showInfoLine()
infoLine(text, value, id)
{
	// Short hand infos
	if (isDefined(value))
	{
		isString = !int(value);
		for (i = 0; i < level.allActiveCount; i++)
		{
			if (isString)
			{
				val = level.s[value + "_" + level.allActivePlayers[i].lang];

				if (isDefined(id))
				{
					val += " " + id;
				}
			}
			else
			{
				val = value;
			}

			level.allActivePlayers[i] thread showInfoLine(self.showname + " " + level.s["INFO_" + text + "_" + level.allActivePlayers[i].lang] + " " + val);
		}
	}
/*	t = level.teams[self.missionTeam];
	for (i = 0; i < t.size; i++)
	{
		if (isString)
			val = level.s[value + "_" + t[i].lang];
		else
			val = value;

		t[i] thread showInfoLine(self.showname + " " + level.s["INFO_" + text + "_" + t[i].lang] + " " + val);
	}
	t = level.teams[self.enemyTeam];
	for (i = 0; i < t.size; i++)
	{
		if (isString)
			val = level.s[value + "_" + t[i].lang];
		else
			val = value;

		t[i] thread showInfoLine(self.showname + " " + level.s["INFO_" + text + "_" + t[i].lang] + " " + val);
	}*/
}

showInfoLine(txt)
{
	self endon("disconnect");
	self notify("infoline");
	self endon("infoline");

	if (isDefined(self.respawnData))
	{
		self waittill("spawned");

		if (!isDefined(self.missionId))
			return;
	}

	self playLocalSound("Info");
	self setClientDvar("infoline", txt);
	wait 4;
	self setClientDvar("infoline", "");
}

mainLine(text1, text2, sound)
{
	self endon("disconnect");
	self notify("mainline");
	self endon("mainline");

	if (isDefined(self.respawnData))
	{
		self waittill("spawned");

		if (!isDefined(self.missionId))
			return;
	}

	if (!isDefined(text2))
		text2 = "";

	if (!isDefined(sound))
		sound = "MainInfo";

	self playLocalSound(sound);
	self setClientDvar("mainline1", text1);
	self setClientDvar("mainline2", text2);
	wait 4;
	self setClientDvar("mainline1", "");
	self setClientDvar("mainline2", "");
}

boldLine(msg, sound)
{
	self endon("disconnect");
	self notify("boldline");
	self endon("boldline");

	if (isDefined(self.respawnData))
	{
		self waittill("spawned");

		if (!isDefined(self.missionId))
			return;
	}

	if (!isDefined(sound))
		sound = "MainInfo";

	self playLocalSound(sound);
	self setClientDvar("boldline", msg);
	wait 4;
	self setClientDvar("boldline", "");
}

addRep(amount)
{
	if (!amount || (amount > 0 && self.prestige == 5 && self.reputation == 0.99) || (amount < 0 && self.prestige == 1 && !self.reputation))
		return 0;

	new = self.reputation + amount;
	if (new >= 1)
	{
		if (self.prestige == 5 || (self.prestige == 4 && level.tutorial))
		{
			self.reputation = 0.99;
		}
		else
		{
			self.prestige++;
			self playLocalSound("StarUp");
			if (self.prestige == 5)
			{
				// Get pubId
				for (self.pubId = 0; isDefined(level.public[self.team][self.pubId]); self.pubId++){};

				level.public[self.team][self.pubId] = self;
				for (i = 0; i < level.activeCount[level.enemy[self.team]]; i++)
				{
					p = level.activePlayers[level.enemy[self.team]][i];
					if ((!isDefined(self.missionId) || !isDefined(p.missionId) || self.missionTeam != p.enemyTeam) && p.prestige != 5)
					{
						self newPoint("ofpublicenemypnt", "enemy", p);
						p newPoint("publicenemypnt", "enemy", self);
					}
				}
				for (i = 0; i < level.activeCount[self.team]; i++)
				{
					p = level.activePlayers[self.team][i];
					if ((!isDefined(self.missionId) || !isDefined(p.missionId) || self.missionTeam != p.missionTeam) && p.prestige != 5)
					{
						p newPoint("publicfriendpnt", "friend", self);
						//self newPoint("ofpublicfriendpnt", "friend", p);
					}
				}

				info = spawnStruct();
				info.icon = "prestige_5_" + self.team;
				info.sound = "BountyAlert";

				for (i = 0; i < level.allActiveCount; i++)
				{
					if (level.allActivePlayers[i] != self)
					{
						info.title = level.s["BOUNTY_TITLE_" + level.allActivePlayers[i].lang];
						info.line = level.s["BOUNTY_PLACED_" + level.allActivePlayers[i].lang] + ":\n^2" + self.showname;
						level.allActivePlayers[i] thread gameMessage(info);
					}
				}

				info.title = level.s["BOUNTY_TITLE_" + self.lang];
				info.line = level.s["BOUNTY_PLACED_YOU_" + self.lang];
				info.sound = "BountyGot";
				self thread gameMessage(info);

				self thread monitorPrestigeTime();
			}
			self.reputation = new - 1;
		}
	}
	else if (new < 0)
	{
		if (self.prestige == 1)
		{
			self.reputation = 0;
		}
		else
		{
			self playLocalSound("StarDown");
			self.prestige--;
			self.reputation = 1 + new;
		}
	}
	else
	{
		self.reputation = new;
	}

	self setClientDvars(
		"prestige", self.prestige,
		"rep", self.reputation
	);
	self.info["reptime"] = getRealTime();
	self.info["rep"] = int((self.prestige + self.reputation) * 10000);
	//self setSave("REP", int((self.prestige + self.reputation) * 10000));
	//self setSave("SERVERTIME", getTime());
}

giveMedal(big)
{
	type = toLower(big);
	if (isDefined(self.stat["medals"][type]))
		return;

	self.stat["medals"][type] = int(tableLookup("mp/medalTable.csv", 1, type, 3));
	foreach (e in level.teams[self.missionTeam];;+)
	{
		&m = e.playerStats[self.clientid].medals; // Will be modified
		m[m.size] = type;
	}
	foreach (e in level.teams[self.enemyTeam];;+)
	{
		&m = e.playerStats[self.clientid].medals; // Will be modified
		m[m.size] = type;
	}

	s = "MEDAL_" + tableLookup("mp/medalTable.csv", 1, type, 2);
	self newMessage(level.s["MEDAL_EARNED_" + self.lang] + ": " + level.s[s + "_" + self.lang]);
	self infoLine("MEDAL", s);

	if (self.stat["medals"][type] > 0)
	{
		self addRep(0.01); // 0.005

		self.info["medals"]++;
		self setClientDvar("medals", self.info["medals"]);
		//self setSave("MEDALS", self.info["medals"]);
		if (self.info["medals"] == 100)
			self giveAchievement("MEDAL");
		//else if (self.info["medals"] < 100)
			//self setClientDvar("achievement_medal_progress", self.info["medals"] + "/100");
	}
	else
	{
		self addRep(-0.01);
	}

	//sql_push("UPDATE players SET rep = " + self.info["rep"] + ", medals = " + self.info["medals"] + " WHERE name = '" + self.showname + "'");
	//self saveStatus();

	info = spawnStruct();
	info.title = level.s["MEDAL_TITLE_" + self.lang];
	info.line = level.s["MEDAL_" + big + "_" + self.lang];
	info.icon = "medal";
	info.sound = "EarnItem";
	self thread gameMessage(info);
}

refreshStat(type, type2, prefix, extcolor)
{
	if (!isDefined(prefix))
		prefix = "";

	val = prefix + self.stat[type];
	if (isDefined(type2))
	{
		if (!isDefined(extcolor))
			extcolor = "3";

		val += "^" + extcolor + " + " + prefix + self.stat[type2];
	}

	foreach (e in level.teams[self.missionTeam];;+)
	{
		e setClientDvar("ui_friend_" + type + self.teamId, val);
	}
	foreach (e in level.teams[self.enemyTeam];;+)
	{
		e setClientDvar("ui_enemy_" + type + self.teamId, val);
	}
}

quitGroup()
{
	self.group = undefined;
	self.groupleader = undefined;
	self.groupId = undefined;
	self.groupmgrid = undefined;
	self.ready = false;
	self setClientDvars(
		"ready", false,
		"groupId", "",
		"group_count", 0,
		"inviting", 1
	);

	/*for (i = 0; i < 4; i++)
	{
		self setClientDvar("group" + i, ""); // Group menu
	}*/
	if (!isDefined(self.missionId))
	{
		self setClientDvars(
			"name0", self.showname,
			"status0", "notready",
			"leader0", "",
			"leftoffset", 1
		);
		/*for (j = 1; j < 4; j++)
		{
			self setClientDvars(
				"name" + j, "",
				"status" + j, "",
				"leader" + j, ""
			);
		}*/
	}
}

kickTeam()
{
	// Show points (instead of a hideToPlayer...)
	if (isDefined(level.missions[self.missionId].points))
	{
		foreach (q in level.missions[self.missionId].points;;+)
		{
			v = getArrayKeys(q.visible); // Not used only for q.visible
			foreach (e in v)
			{
				q.team[e] hide();
				for (k = 0; k < q.visible[e].size; k++)
				{
					&u = q.visible[e][k]; // Nicer

					if (u == self)
						unsetArrayItemIndex(q.visible[e], k);
					else
						q.team[e] showToPlayer(u);
				}
			}
		}
	}

	self maps\mp\gametypes\_menus::delPlacedHud();

	t = level.teams[self.missionTeam];
	c = t.size;
	te = level.teams[self.enemyTeam];
	ce = te.size;

	leader = 0;
	friendThreat = 0;
	foreach (p in i:t; 0; +c)
	{
		p removeFromRadar("map_friendly" + self.teamId);
		friendThreat += level.threatValue[p.threat];
		if (isDefined(p.teamleader))
		{
			leader = i;
		}
	}

	enemyThreat = 0;
	foreach (e in te; 0; +ce)
	{
		enemyThreat += level.threatValue[e.threat];
	}

	if (c < ce || (c == ce && enemyThreat - friendThreat >= c))
	{
		t[leader] setClientDvar("leftinfo", "CALL_BACKUP");
	}

	self.missionTeam = undefined;
	self killLoadBar();
	self quitTeam();
	self setClientDvars(
		"missionstatus", "LOSE",
		"missionstatus_desc", "KICKED"
	);
	if (isDefined(self.group))
	{
		refreshGroup(self.group);
	}
	/*if (isDefined(self.group))
	{
		if (level.groups[self.group].team.size > 2)
		{
			level.groups[self.group].team = unsetArrayItem(level.groups[self.group].team, self);
			if (isDefined(self.groupleader))
			{
				self.groupleader = undefined;
				r = 0;
				for (i = 1; i < level.groups[self.group].team.size; i++)
				{
					if (level.groups[self.group].team[i].rating > level.groups[self.group].team[r].rating)
					{
						r = i;
					}
				}
				level.groups[self.group].team[r].groupleader = true;
			}
			refreshGroup(self.group);

			for (i = 1; i < level.groups[self.group].team.size; i++)
			{
				level.groups[self.group].team[i] newMessage(self.showname + " " + level.s["KICKED_FROM_GROUP_" + level.groups[self.group].team[i].lang]);
			}
			self newMessage(level.s["YOU_KICKED_FROM_GROUP_" + self.lang]);
			self quitGroup();
		}
	}*/
}

abandonGroup(id)
{
	if (level.groups[id].groupReady)
	{
		unsetArrayItem(level.readyGroups[level.groups[id].side], id);
	}

	foreach (e in level.groups[id].team;;+)
	{
		// Ignore for player disconnect
		if (!isDefined(e.leaving))
		{
			e quitGroup();
			e newMessage("^2" + level.s["GROUP_ABADONED_" + e.lang] + "!");
		}
	}

	last = level.groups.size - 1;
	if (id != last)
	{
		foreach (e in level.groups[last].team;;+)
		{
			e.group = id;
		}
	}
	unsetArrayItemIndex(level.groups, id);
}

refreshTeam(id)
{
	t = level.teams[id];
	e = level.teams[t[0].enemyTeam];
	tsize = t.size;
	esize = e.size;

	foreach (p in i:t; 0; +tsize)
	{
		p.teamId = i;
		p setClientDvars(
			"leftoffset", tsize,
			"ui_friend_count", tsize
		);
		for (j = 0; j < tsize; j++)
		{
			/*if (j < tsize)
			{*/
				q = t[j];

				if (isDefined(q.teamleader))
					leader = "team";
				else if (isDefined(q.groupleader) && isDefined(p.group) && p.group == q.group)
					leader = "group";
				else
					leader = "";

				p setClientDvars(
					"name" + j, "^2" + q.showname,
					"status" + j, "ready",
					"leader" + j, leader,
					"ui_friend_name" + j, q.showname,
					"ui_friend_kills" + j, q.stat["kills"] + "^8 + " + q.stat["assists"],
					"ui_friend_arrests" + j, q.stat["arrests"],
					"ui_friend_deaths" + j, q.stat["deaths"],
					"ui_friend_targets" + j, q.stat["targets"],
					"ui_friend_medals" + j, q.stat["medals"].size,
					"ui_friend_cash" + j, "$" + q.stat["cash"] + "^3 + $" + q.stat["pcash"],
					"ui_friend_standing" + j, q.stat["standing"] + "^3 + " + q.stat["pstanding"],
					"ui_friend_icon" + j, level.ranks[q.rating]["id"] + "_" + q.team,
					"ui_friend_threat" + j, q.threat,
					"team" + j, q.showname // Team menu
				);
			/*}
			else
			{
				p setClientDvars(
					"name" + j, "",
					"status" + j, "",
					"leader" + j, "",
					"ui_friend_name" + j, "",
					"ui_friend_kills" + j, "",
					"ui_friend_arrests" + j, "",
					"ui_friend_deaths" + j, "",
					"ui_friend_targets" + j, "",
					"ui_friend_medals" + j, "",
					"ui_friend_cash" + j, "",
					"ui_friend_standing" + j, "",
					"ui_friend_icon" + j, "",
					"ui_friend_threat" + j, "",
					"map_friendly" + j + "z", "",
					"map_friendly" + j + "d", "",
					"team" + j, ""
				);
			}*/
		}

		p.clientids["friend"] = [];
		p.clientids["enemy"] = [];

		for (j = 0; j < esize; j++)
		{
			p.clientids["enemy"][j] = e[j].clientid;
		}

		for (j = 0; j < tsize; j++)
		{
			p.clientids["friend"][j] = t[j].clientid;
		}
	}
	foreach (p in i:e; 0; +esize)
	{
		p.teamId = i;
		p setClientDvar("ui_enemy_count", tsize);
		for (j = 0; j < tsize; j++)
		{
			/*if (j < tsize)
			{*/
				q = t[j];

				p setClientDvars(
					"ui_enemy_name" + j, q.showname,
					"ui_enemy_kills" + j, q.stat["kills"] + "^8 + " + q.stat["assists"],
					"ui_enemy_arrests" + j, q.stat["arrests"],
					"ui_enemy_deaths" + j, q.stat["deaths"],
					"ui_enemy_targets" + j, q.stat["targets"],
					"ui_enemy_medals" + j, q.stat["medals"].size,
					"ui_enemy_cash" + j, "$" + q.stat["cash"] + "^3 + $" + q.stat["pcash"],
					"ui_enemy_standing" + j, q.stat["standing"] + "^3 + " + q.stat["pstanding"],
					"ui_enemy_icon" + j, level.ranks[q.rating]["id"] + "_" + q.team,
					"ui_enemy_threat" + j, q.threat
				);
			/*}
			else
			{
				p setClientDvars(
					"ui_enemy_name" + j, "",
					"ui_enemy_kills" + j, "",
					"ui_enemy_arrests" + j, "",
					"ui_enemy_deaths" + j, "",
					"ui_enemy_targets" + j, "",
					"ui_enemy_medals" + j, "",
					"ui_enemy_cash" + j, "",
					"ui_enemy_standing" + j, "",
					"ui_enemy_icon" + j, "",
					"ui_enemy_threat" + j, "",
					"map_enemy" + j + "z", "",
					"map_enemy" + j + "d", ""
				);
			}*/
		}

		p.clientids["enemy"] = [];
		p.clientids["friend"] = [];

		for (j = 0; j < tsize; j++)
		{
			p.clientids["enemy"][j] = t[j].clientid;
		}

		for (j = 0; j < esize; j++)
		{
			p.clientids["friend"][j] = e[j].clientid;
		}
	}

	//level.teams[id] = t;
	//level.teams[t[0].enemyTeam] = e;
}

refreshGroup(id)
{
	g = level.groups[id].team;
	gsize = g.size;

	if (!level.groups[id].inMission)
	{
		team = level.groups[id].side;

		wasReady = level.groups[id].groupReady;
		ready = true;
		for (i = 0; i < gsize && ready; i++)
		{
			if (!g[i].ready)
			{
				ready = false;
			}
		}

		if (ready != wasReady)
		{
			level.groups[id].groupReady = ready;

			if (ready)
				level.readyGroups[team][level.readyGroups[team].size] = id;
			else
				unsetArrayItem(level.readyGroups[team], id);
		}
	}
	else
	{
		ready = false;
	}

	foreach (f in i:g; 0; +gsize)
	{
		notInMission = !isDefined(f.missionId);
		if (notInMission)
		{
			f setClientDvars(
				"ready", ready,
				"leftoffset", gsize
			);
		}

		f.groupId = i;
		f setClientDvars(
			"groupId", f.groupId,
			"group_count", gsize
		);

		foreach (h as j:g;;+gsize)
		{
			/*if (j < gsize)
			{*/
				//h = g[j];
				if (notInMission)
				{
					if (!isDefined(h.missionId))
					{
						if (h.ready)
						{
							f setClientDvars(
								"name" + j, "^2" + h.showname,
								"status" + j, "ready"
							);
						}
						else
						{
							f setClientDvars(
								"name" + j, h.showname,
								"status" + j, "notready"
							);
						}
					}
					else
					{
						f setClientDvars(
							"name" + j, h.showname,
							"status" + j, "mission"
						);
					}

					if (isDefined(h.groupleader))
						f setClientDvar("leader" + j, "group");
					else
						f setClientDvar("leader" + j, "");
				}

				f setClientDvar("group" + j, h.showname); // Group menu
			/*}
			else if (notInMission)
			{
				f setClientDvars(
					"name" + j, "",
					"status" + j, "",
					"leader" + j, "",
					"group" + j, ""
				);
			}*/
		}
	}
}

unreadyPlayer()
{
	unsetArrayItem(level.readyPlayers[self.team], self);
}

killMessage(enemy, type)
{
	self endon("disconnect");

	// Show killfeed
	info = spawnStruct();
	info.enemy = enemy.showname;
	info.type = type;
	self.feeds[self.feeds.size] = info;

	if (self.feeds.size == 1)
	{
		if (!isAlive(self))
		{
			info = undefined;
			self waittill("spawned_player");
		}
		self thread startKillMessage(0);
	}
}

handleNotify(attacker, victim, weapon)
{
	s = spawnStruct();
	s.weapon = getSubStr(weapon, 0, weapon.size - 3);
	s.img = level.weaps[attacker getWeaponID(weapon)].shader; // tableLookup("mp/weaponTable.csv", 1, s.weapon, 3)
	s.offset = victim.namelen;
	//s.time = getTime();

	if (attacker != victim)
	{
		if (self.team == attacker.team)
			s.attacker = "^2" + attacker.showname;
		else
			s.attacker = "^1" + attacker.showname;
	}
	else
	{
		s.attacker = "";
	}

	if (self.team == victim.team)
		s.victim = "^2" + victim.showname;
	else
		s.victim = "^1" + victim.showname;

	if (self.notifies.size == 5)
	{
		for (i = 0; i < 4; i++)
		{
			self.notifies[i] = self.notifies[i + 1];
			self setFeed(i);
		}
		self.notifies[4] = s;
	}
	else
	{
		self.notifies[self.notifies.size] = s;

		if (self.notifies.size == 1)
			self thread hideFeed();
	}
	self setFeed(self.notifies.size - 1);
}

setFeed(id)
{
	s = id;
	id++;
	self setClientDvars(
		"feed" + id + "_attacker", self.notifies[s].attacker,
		"feed" + id + "_victim", self.notifies[s].victim,
		"feed" + id + "_weapon", self.notifies[s].weapon,
		"feed" + id + "_img", self.notifies[s].img,
		"feed" + id + "_offset", self.notifies[s].offset
	);
}

hideFeed()
{
	self endon("disconnect");
	self notify("hidefeed");
	self endon("hidefeed");

	//wait 10 - (getTime() - self.notifies[0].time) / 1000;
	wait 10;

	size = self.notifies.size;
	last = size - 1;
	for (i = 0; i < last; i++)
	{
		self.notifies[i] = self.notifies[i + 1];
		self setFeed(i);
	}
	self setClientDvars(
		"feed" + size + "_attacker", "",
		"feed" + size + "_victim", "",
		"feed" + size + "_weapon", "",
		"feed" + size + "_img", "",
		"feed" + size + "_offset", ""
	);
	self.notifies[last] = undefined;

	if (last)
		self thread hideFeed();
}

startKillMessage(id)
{
	self endon("disconnect");

	self.feed["icon"] = newClientHudElem(self);
	self.feed["icon"].x = -12;
	self.feed["icon"].y = 103;
	self.feed["icon"].width = 24;
	self.feed["icon"].height = 24;
	self.feed["icon"].horzAlign = "center";
	self.feed["icon"].vertAlign = "middle";
	self.feed["icon"].alpha = 0;
	self.feed["icon"].hideWhenInMenu = true;

	self.feed["title"] = newClientHudElem(self);
	self.feed["title"].x = 0;
	self.feed["title"].y = 135;
	self.feed["title"].horzAlign = "center";
	self.feed["title"].vertAlign = "middle";
	self.feed["title"].alignX = "center";
	self.feed["title"].alignY = "middle";
	self.feed["title"].elemType = "font";
	self.feed["title"].font = "default";
	self.feed["title"].fontscale = 1.4;
	self.feed["title"].color = (1, 0.7, 0);
	self.feed["title"].alpha = 0;
	self.feed["title"].hideWhenInMenu = true;

	self.feed["name"] = newClientHudElem(self);
	self.feed["name"].x = 0;
	self.feed["name"].y = 150;
	self.feed["name"].horzAlign = "center";
	self.feed["name"].vertAlign = "middle";
	self.feed["name"].alignX = "center";
	self.feed["name"].alignY = "middle";
	self.feed["name"].elemType = "font";
	self.feed["name"].font = "default";
	self.feed["name"].fontscale = 1.4;
	self.feed["name"].color = (1, 1, 1);
	self.feed["name"].alpha = 0;
	self.feed["name"].hideWhenInMenu = true;

	self.feed["icon"] setShader("skull", 24, 24); // TODO: Different for stunning/arresting!
	self.feed["title"].label = level.s["FEED_" + self.feeds[id].type + "_" + self.lang];

	self.feed["name"] setText(self.feeds[id].enemy); // setPlayerNameString(self.feeds[id].enemy) ~ Maybe enemy has disconnected so we can't use it

	if (self.feeds[id].type == "KILL")
		self playLocalSound("EnemyKilled");
	else if (self.feeds[id].type == "ASSIST")
		self playLocalSound("EnemyAssist");
	else if (self.feeds[id].type == "ARREST")
		self playLocalSound("EnemyArrested");

	k = getArrayKeys(self.feed);
	c = k.size;
	for (i = 0; i < c; i++)
	{
		self.feed[k[i]] fadeOverTime(0.25);
		self.feed[k[i]].alpha = 0.85;
	}
	wait 4;
	for (i = 0; i < c; i++)
	{
		self.feed[k[i]] fadeOverTime(0.25);
		self.feed[k[i]].alpha = 0;
	}

	wait 0.25;

	for (i = 0; i < c; i++)
	{
		self.feed[k[i]] destroy();
	}
	self.feed = undefined;

	wait 0.25;

	id++;

	if (self.feeds.size > id)
		self thread startKillMessage(id);
	else
		self.feeds = [];
}

/*getSave(dataName)
{
	return self getStat(int(tableLookup("mp/playerTable.csv", 1, dataName, 0)));
}

setSave(dataName, value)
{
	if (level.listen)
		return;

	data = int(tableLookup("mp/playerTable.csv", 1, dataName, 0));
	self.checksum += (value - self getStat(data));
	self setStat(data, value);
	self setStat(3250, self.checksum);
}

addSave(dataName, value)
{
	self setSave(dataName, self getSave(dataName) + value);
}*/

giveAchievement(type)
{
	small = toLower(type);
	id = int(tableLookup("mp/achievementTable.csv", 1, small, 0));
	if (id & self.info["achievements"])
		return;

	bit = 1;
	for (i = 2; i <= id; i++)
	{
		bit *= 2;
	}
	self.info["achievements"] |= bit;
	/*self setClientDvars(
		"achievement_" + small, true,
		"achievement_" + small + "_progress", ""
	);*/
	//self setSave("ACHIEVEMENTS", self.info["achievements"]);
	//sql_push("UPDATE players SET achievements = " + self.info["achievements"] + " WHERE name = '" + self.showname + "'");
	//self saveStatus();
	self infoLine("ACHIEVEMENT", "ACHIEVEMENT_" + type);

	info = spawnStruct();
	info.title = level.s["ACHIEVEMENT_TITLE_" + self.lang];
	info.line = level.s["ACHIEVEMENT_" + type + "_" + self.lang];
	info.icon = "achievement_" + small;
	info.sound = "EarnItem";
	self thread gameMessage(info);
}

/*updateTeamStatus()
{
	level.activePlayers["allies"] = [];
	level.activePlayers["axis"] = [];
	level.allActivePlayers = [];
	level.activeCount["allies"] = 0;
	level.activeCount["axis"] = 0;
	level.allActiveCount = 0;

	//level.alivePlayers["allies"] = [];
	//level.alivePlayers["axis"] = [];
	//level.allAlivePlayers = [];
	//level.aliveCount["allies"] = 0;
	//level.aliveCount["axis"] = 0;
	//level.allAliveCount = 0;

	for (i = 0; i < level.players.size; i++)
	{
		if (level.players[i].team != "free") // allies, axis, or spectator
		{
			//realTeam = level.players[i].team == "allies" || level.players[i].team == "axis";

			if (level.players[i].spawned)
				level.activePlayers[level.players[i].team][level.activeCount[level.players[i].team]++] = level.players[i];

			level.allActivePlayers[level.allActiveCount++] = level.players[i];

			//if (isAlive(level.players[i]))
			//{
				//if (level.players[i].spawned)
					//level.alivePlayers[level.players[i].team][level.aliveCount[level.players[i].team]++] = level.players[i];

				//level.allAlivePlayers[level.allAliveCouunt++] = level.players[i];
			//}
		}
	}
}*/

/*getSpawnPoint(arr)
{
	p = [];
	for (i = 0; i < arr.size; i++)
	{
		if (!positionWouldTelefrag(arr[i].origin))
		{
			p[p.size] = arr[i];
		}
	}
	if (p.size)
		return p[randomInt(p.size)];
	else
		return arr[randomInt(arr.size)];
}*/

inline getSpawnPoint(arr)
{
	p = [];
	c = arr.size;
	ps = 0;
	for (i = 0; i < c; i++)
	{
		if (!positionWouldTelefrag(arr[i].origin))
		{
			p[ps] = arr[i];
			ps++;
		}
	}
	if (ps)
		spawnPoint = p[randomInt(ps)];
	else
		spawnPoint = arr[randomInt(c)];
}

joinGame()
{
	self endon("disconnect");
	self notify("spawned");
	self notify("end_respawn");

	resetTimeout();
	self stopShellshock();
	self stopRumble("damage_heavy");

	self.statusicon = "";
	self.sessionstate = "playing";
	self.maxhealth = 200;
	self.health = self.maxhealth;
	self.stun = 100;
	self setMoveSpeedScale(1); // Set back to default

	if (isDefined(self.clone))
		self.clone delete();

	if (!self.spawned)
	{
		/*if (!spawnPoints.size)
		{
			spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints(self.team);
			spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(spawnPoints);
		}
		else
		{
			spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnPoints);
		}*/

		// Set player dvars (watching for reconnecters too) - if we get an overflow, move the half of it in the connect part :P
		self setClientDvars(
			"compassSize", 1,
			"ui_hud_obituaries", 0,
			"cg_drawCrosshairNames", 1,
			"cg_drawThroughWalls", 1,
			"cg_cursorHints", 4,
			"cg_overheadRankSize", 0,
			"cg_overheadIconSize", 0,
			"chat_on", 0,
			"money", self.info["money"],
			"mod1", "empty",
			"mod2", "empty",
			"mod3", "empty",
			"ready", 0,
			"items", 0,
			"inviting", 1,
			"compassMaxRange", 2147483647,
			"compassMinRange", 2147483647,
			"line1", "",
			"line2", "",
			"name0", self.showname,
			"status0", "notready",
			"leader0", "",
			"leftoffset", 1,
			"timeleft", "",
			"mission_title", "",
			"mission_desc", "",
			"mission", false,
			"teamid", "",
			"counter1", "",
			"counter2", "",
			"chat1", "",
			"chat2", "",
			"chat3", "",
			"chat4", "",
			"chat5", "",
			"chat6", "",
			"group1", "",
			"group2", "",
			"group3", "",
			"group4", "",
			"prestige", 2,
			"rep", 0.5,
			"tutid", 0,
			"symbol", self.info["symbol"],
			"symbols", self.info["symbols"],
			"leftinfo", "CHANGE_TO_READY",
			"location", "SOCIAL",
			"infoline", "",
			"mainline1", "",
			"mainline2", "",
			"chattype", "d",
			"alert", "",
			"error", "",
			"music_title", "---",
			//"music_time", "[0:00 / 0:00]",
			//"music_rate", 0,
			"music_playing", "",
			"musicstatus", "all",
			"side", self.team,
			"enemy", level.enemy[self.team],
			"ip", level.ip,
			"group_count", 0,
			"team_count", 0
		);
		for (i = 1; i <= 5; i++)
		{
			self setClientDvars(
				"feed" + i + "_attacker", "",
				"feed" + i + "_victim", "",
				"feed" + i + "_weapon", "",
				"feed" + i + "_img", "",
				"feed" + i + "_offset", 0
			);
		}
		for (i = 0; i < 8; i++)
		{
			self setClientDvars(
				"map_obj" + i + "z", "",
				//"map_obj" + i + "d", "",
				//"map_obj" + i + "type", "",
				//"ui_enemy_name" + i, "",
				//"ui_enemy_kills" + i, "",
				//"ui_enemy_assists" + i, "",
				//"ui_enemy_arrests" + i, "",
				//"ui_enemy_deaths" + i, "",
				//"ui_enemy_targets" + i, "",
				//"ui_enemy_medals" + i, "",
				//"ui_enemy_cash" + i, "",
				//"ui_enemy_standing" + i, "",
				//"ui_enemy_icon" + i, "",
				//"ui_enemy_threat" + i, "",
				"map_enemy" + i + "z", ""//,
				//"map_enemy" + i + "d", ""
			);
		}
		for (i = 1; i < 8; i++)
		{
			self setClientDvars(
				//"name" + i, "",
				//"status" + i, "",
				//"leader" + i, "",
				//"team" + i, "",
				"map_friendly" + i + "z", ""//,
				//"map_friendly" + i + "d", ""
			);
		}
		/*for (i = 0; i < 4; i++)
		{
			self setClientDvar("group" + i, "");
		}*/

		if (level.social)
			self setClientDvar("cg_drawFriendlyNames", 1);
		else
			self setClientDvar("cg_drawFriendlyNames", 0);

		if (level.tutorial)
			self setClientDvar("tutid", 1);
		else
			self setClientDvar("tutid", 0);

		// Initialize roles
		foreach (e in level.roleList;;+)
		{
			type = getRoleType(e);
			nextlevel = 0;
			count = 0;
			foreach (f in key:level.roles[type]; 1)
			{
				count += f;
				if (self.info["role_" + e] < count)
				{
					nextlevel = key;
					break;
				}
			}
			self.roleLevel[e] = nextlevel - 1;
		}

		self.startTime = getTime();
		self clientExec("exec apb; setdvartotime time_start"); // rcon login " + getDvar("rcon_password") + "; rcon writeconfig setup; rcon logout

		self queryThreat();
		self getTimeZone();
		self getCurTime(getRealTime());

		if (!isDefined(self.isBot))
			self thread watchMails();

		// Re-save infos
		if (!level.developer)
		{
			self setStat(3153, self.info["lang"]);
			self setStat(3154, self.info["faction"]);
		}

		if (level.action)
			self createPins();

		level.activePlayers[self.team][level.activeCount[self.team]] = self;
		level.activeCount[self.team]++;
		level.allActivePlayers[level.allActiveCount] = self;
		level.allActiveCount++;
		updateServerStat("count_" + self.team + " = " + level.activeCount[self.team]);
		//setDvar("count_" + self.team, level.activeCount[self.team]);
		//heartBeat(2, "update count_" + self.team + "=" + level.activeCount[self.team]);

		self.spawned = true;

		if (level.tutorial && !isDefined(self.isBot))
		{
			level.bots++;
			setDvar("sv_maxclients", level.maxClients + level.bots);
			self.bot = addTestClient();
			self.bot.master = self;
			self.bot thread setupBot();
		}

		self thread monitorPlayer();
	}
	/*else if (!isDefined(self.firstDress))
	{
		self setClientDvar("tutid", 1);
	}*/
	/*else if (isDefined(self.firstDress))
	{
		spawnPoints = getentarray("mp_tdm_spawn_" + self.team + "_start", "classname");

		if (!spawnPoints.size)
		{
			spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints(self.team);
			spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(spawnPoints);
		}
		else
		{
			spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnPoints);
		}
	}
	else
	{
		self setClientDvar("tutid", 1);
		spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints(self.team);
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(spawnPoints);
	}*/

	if (self.info["dress"])
	{
		self maps\mp\gametypes\_menus::loadModel();

		if (isDefined(self.spawn))
		{
			self spawn(self.spawn.origin, self.spawn.angles);
			self.spawn = undefined;
			self.respawnData = undefined;
		}
		else
		{
			// { } brackets needed, getSpawnPoint is inline!
			if (isDefined(self.respawnData) && self.respawnData.size)
			{
				getSpawnPoint(self.respawnData);
			}
			else if (isDefined(self.missionId))
			{
				getSpawnPoint(level.spawns);
			}
			else
			{
				getSpawnPoint(level.spawn[self.team]);
			}

			if (isDefined(self.respawnData))
				self.respawnData = undefined;

			self spawn(spawnPoint.origin, spawnPoint.angles);
		}

		if (isDefined(self.firstDress))
		{
			self.firstDress = undefined;
			self thread delayTutorial();
		}
		else if (level.tutorial)
		{
			self thread delayTutorial();
		}

		self thread watchSprint();
		self giveSupplier();
	}

	self.primaryWeapon = level.weaps[self.info["prime"]].weap; // tableLookup("mp/weaponTable.csv", 0, self.info["prime"], 1) + "_mp"
	self.secondaryWeapon = level.weaps[self.info["secondary"]].weap; // tableLookup("mp/weaponTable.csv", 0, self.info["secondary"], 1) + "_mp"
	self.offhandWeapon = level.weaps[self.info["offhand"]].weap; // tableLookup("mp/weaponTable.csv", 0, self.info["offhand"], 1) + "_mp"

	// It is an M16 - these must have 3*x bullets, else it will be bugged when shooting the last 1 or 2 bullets
	isM16 = level.weaps[self.info["prime"]].image == "rotated_m16";

	self giveWeapon(self.primaryWeapon, self.weapons[self.wID[self.info["prime"]]]["camo"]);
	self giveWeapon(self.secondaryWeapon);
	self giveWeapon(self.offhandWeapon);
	self.currentWeapon = self.primaryWeapon;
	primaryAmmoType = level.ammo[self.primaryWeapon]; // tableLookup("mp/weaponTable.csv", 0, self.info["prime"], 16)
	secondaryAmmoType = level.ammo[self.secondaryWeapon]; // tableLookup("mp/weaponTable.csv", 0, self.info["secondary"], 16)
	offhandAmmoType = level.ammo[self.offhandWeapon]; // tableLookup("mp/weaponTable.csv", 0, self.info["offhand"], 16)
	maxAmmo = isDefined(self.perks["extraammo"]);
	if (maxAmmo)
	{
		primaryAmmoMax = weaponMaxAmmo(self.primaryWeapon);
		secondaryAmmoMax = weaponMaxAmmo(self.secondaryWeapon);
	}
	else
	{
		primaryAmmoMax = weaponStartAmmo(self.primaryWeapon);
		secondaryAmmoMax = weaponStartAmmo(self.secondaryWeapon);
	}

	// Primary
	if (self.info["ammo_" + primaryAmmoType] >= primaryAmmoMax)
	{
		if (maxAmmo)
		{
			self giveMaxAmmo(self.primaryWeapon);
		}
	}
	else
	{
		clipSize = weaponClipSize(self.primaryWeapon);
		if (clipSize <= self.info["ammo_" + primaryAmmoType])
		{
			if (isM16)
			{
				new = self.info["ammo_" + primaryAmmoType] - clipSize;
				self setWeaponAmmoStock(self.primaryWeapon, new - new % 3);
			}
			else
			{
				self setWeaponAmmoStock(self.primaryWeapon, self.info["ammo_" + primaryAmmoType] - clipSize);
			}
		}
		else
		{
			if (isM16)
				self setWeaponAmmoClip(self.primaryWeapon, self.info["ammo_" + primaryAmmoType] - self.info["ammo_" + primaryAmmoType] % 3);
			else
				self setWeaponAmmoClip(self.primaryWeapon, self.info["ammo_" + primaryAmmoType]);

			self setWeaponAmmoStock(self.primaryWeapon, 0);
		}
	}

	// Secondary
	ammo = self.info["ammo_" + secondaryAmmoType];
	if (primaryAmmoType == secondaryAmmoType)
		ammo -= primaryAmmoMax;

	if (ammo >= secondaryAmmoMax)
	{
		if (maxAmmo)
		{
			self giveMaxAmmo(self.secondaryWeapon);
		}
	}
	else
	{
		clipSize = weaponClipSize(self.secondaryWeapon);
		if (clipSize <= ammo)
		{
			self setWeaponAmmoStock(self.secondaryWeapon, ammo - clipSize);
		}
		else
		{
			self setWeaponAmmoClip(self.secondaryWeapon, ammo);
			self setWeaponAmmoStock(self.secondaryWeapon, 0);
		}
	}

	// Offhand
	if (self.info["ammo_" + offhandAmmoType] < weaponStartAmmo(self.offhandWeapon))
	{
		self setWeaponAmmoClip(self.offhandWeapon, self.info["ammo_" + offhandAmmoType]);
	}

	self setClientDvar("weapinfo_offhand", self getAmmoCount(self.offhandWeapon));

	self setSpawnWeapon(self.primaryWeapon);

	waittillframeend;
	self notify("spawned_player");

	//self logString("S " + self.origin[0] + " " + self.origin[1] + " " + self.origin[2]);

	//updateTeamStatus();

	if (!self.info["dress"])
	{
		self.firstDress = true;
		self.info["dress"] = randomIntRange(1, 17);
		self maps\mp\gametypes\_menus::loadModel();

		if (!isDefined(self.isBot))
		{
			sql_exec("INSERT INTO players (name, pass, faction, dress, lang, inv, status, timestamp) VALUES ('" + self.showname + "', '" + self.info["pass"] + "', " + self.info["faction"] + ", " + self.info["dress"] + ", " + self.info["lang"] + ", '" + self.info["inv"] + "', '" + level.server + "', " + getRealTime() + ")");
		}

		//self maps\mp\gametypes\apb::setSave("DRESS", self.info["dress"]);
		wait 0.05;
		self openMenu(game["menu_dress"]);
		//sql_push("UPDATE players SET dress = " + self.info["dress"] + " WHERE name = '" + self.showname + "'");

	}

	// Save every modification
	//self saveStatus();

	// Anim test ~ SP anims are ugly as hell!
	/*self setClientDvar("cg_thirdperson", 1);
	wait 2;
	self giveWeapon("anim1_mp");
	self switchToWeapon("anim1_mp");*/

	//wait 2;
	//self createPuzzle();
}

createPuzzle()
{
	self openMenu(game["menu_puzzle"]);

	// Puzzle!
	self.puzzle = spawnStruct();

	// Generate nodes
	temp = [];
	nodes = [];
	for (i = 0; i < 9; i++)
	{
		if (i < 5) // Put one in every way
		{
			if (i < 3) // At least one in every column (3)
			{
				from = i * 3;
				max = from + 3;
			}
			else // At least one in every row (2)
			{
				from = 9 + (i - 3) * 4;
				max = from + 4;
			}

			id = randomIntRange(from, max);
			temp[id] = true;
			nodes[i] = id;

			// Shake them!
			if (i == 4)
			{
				n = [];
				arr makearray(0, 1, 2, 3, 4);
				c = 5;
				while (c)
				{
					d = randomInt(c);
					c--;
					n[c] = nodes[arr[d]];
					if (d != c)
					{
						arr[d] = arr[c];
					}
					arr[c] = undefined;
				}
				nodes = n;
			}
		}
		else // Put to totally random place
		{
			id = 0; // Declare

			// Generate one row, then one col to avoid disturbance of the bits
			if (i % 2)
			{
				from = 0;
				max = 9;
			}
			else
			{
				from = 9;
				max = 17;
			}

			do
				id = randomIntRange(from, max);
			while (isDefined(temp[id]));

			temp[id] = true;

			// Bits shouldn't be able to go through a node of an other bit, so swap them if it'd happen
			if (id < 9 && id % 3 != 1) // Column, not middle
			{
				for (j = 0; j < i; j++)
				{
					if (nodes[j] < 9 && nodes[j] % 3 == 1) // Middle => Swap
					{
						self setClientDvar("temp" + j, id);
						newid = nodes[j];
						nodes[j] = id;
						id = newid;
						break;
					}
				}
			}
			else if (id >= 9 && id % 4 <= 1) // Row, not middle
			{
				if (id % 4 == 1)
					pair = 2;
				else
					pair = 3;

				for (j = 0; j < i; j++)
				{
					if (nodes[j] >= 9 && nodes[j] % 4 == pair) // Middle => Swap
					{
						self setClientDvar("temp" + j, id);
						newid = nodes[j];
						nodes[j] = id;
						id = newid;
						break;
					}
				}
			}
			nodes[i] = id;
		}

		self setClientDvar("temp" + i, id);
	}

	// Generate bits
	//temp makemap(0:0, 1:1, 2:2, 3:3, 4:4, 5:5, 6:6, 7:7, 8:8, 9:9, 10:10, 11:11);
	//c = 12;
	delay = randomIntRange(20, 30); // 1-1.5s
	for (i = 0; i < 12; i++)
	{
		// Get random ID
		/*d = randomInt(c);
		c--;
		id = temp[d];

		// Remove from array
		if (d != c)
		{
			temp[d] = temp[c];
		}
		temp[c] = undefined;*/

		// Create
		if (i < 9)
			goal = nodes[i];
		else
			goal = randomInt(17);

		self.puzzle.bits[i] = spawnStruct();
		self.puzzle.bits[i].id = i;
		self.puzzle.bits[i].goal = goal;
		self.puzzle.bits[i].dirout = randomInt(2) ? 1 : -1;
		if (goal < 9) // Column
		{
			t = goal % 3;
			if (!t) // Upper column
			{
				self.puzzle.bits[i].dirin = 1;
				self.puzzle.bits[i].timein = 1;
			}
			else if (t == 1) // Lower column
			{
				self.puzzle.bits[i].dirin = randomInt(2) ? 1 : -1;
				self.puzzle.bits[i].timein = 2;
			}
			else // Middle column
			{
				self.puzzle.bits[i].dirin = -1;
				self.puzzle.bits[i].timein = 1;
			}

			t = int(goal / 3) * 80;
			if (self.puzzle.bits[i].dirin == 1) // From above
				self.puzzle.bits[i].pos = 120 + t;
			else // From below
				self.puzzle.bits[i].pos = 1000 - t;
		}
		else // Row
		{
			t = goal % 4;
			if (t == 1 || t == 2) // Left row
			{
				self.puzzle.bits[i].dirin = 1;
				self.puzzle.bits[i].timein = t;
			}
			else // Right row
			{
				self.puzzle.bits[i].dirin = -1;
				self.puzzle.bits[i].timein = 1 + goal % 2;
			}

			t = int((goal - 9) / 4) * 80;
			if (self.puzzle.bits[i].dirin == 1) // From left
				self.puzzle.bits[i].pos = 1320 - t;
			else // From right
				self.puzzle.bits[i].pos = 520 + t;
		}
		self.puzzle.bits[i].timein -= 0.15; // The bit should be stopped before reaching the middle

		// Not 'cur', because the game can be restarted!
		self.puzzle.bits[i].orig = self.puzzle.bits[i].pos + (self.puzzle.bits[i].dirout * -1) * (delay * 0.05 - self.puzzle.bits[i].timein) * 80; // round()?

		if (self.puzzle.bits[i].orig < 0)
			self.puzzle.bits[i].orig += 1440;
		else if (self.puzzle.bits[i].orig >= 1440)
			self.puzzle.bits[i].orig -= 1440;

		//self thread watchPuzzleBit(i);

		// Next bit
		if (i == 9) // Fake bits shouldn't be able to interrupt normal bits
			delay += 41; // 2.05s
		else if (i != 11)
			delay += randomIntRange(11, 20); // 0.55 - 1 sec
	}

	self.puzzle.nodes = nodes;

	self startPuzzle();
}

round(e)
{
	return int(e + 0.5);
}

startPuzzle()
{
	self.puzzle.turn = 1;
	self.puzzle.in = 0;
	self setClientDvars(
		"temp", "", // Angle of the connectors
		"temp_type", "" // Game over
	);

	for (i = 0; i < 9; i++)
	{
		self setClientDvar("temp" + i, self.puzzle.nodes[i]);
	}

	for (i = 0; i < 12; i++)
	{
		self.puzzle.bits[i].cur = self.puzzle.bits[i].orig;
		self thread watchPuzzleBit(i);
	}
}

watchPuzzleBit(id)
{
	self endon("disconnect");
	self endon("endpuzzle");

	e = self.puzzle.bits[id];
	while (true)
	{
		cur = e.cur;
		if (!cur) // Left top corner
		{
			x = 0;
			y = 0;
			onx = e.dirout == 1;

			if (onx)
			{
				if (e.pos < 400)
					to = e.pos;
				else
					to = 400;
			}
			else
			{
				cur = 1440;

				if (e.pos > 1120)
					to = e.pos;
				else
					to = 1120;
			}
		}
		else if (cur == 400) // Right top corner
		{
			x = 400;
			y = 0;
			onx = e.dirout == -1;

			if (onx)
			{
				if (e.pos < 400 && e.pos)
					to = e.pos;
				else
					to = 0;
			}
			else
			{
				if (e.pos > 400 && e.pos < 720)
					to = e.pos;
				else
					to = 720;
			}
		}
		else if (cur == 720) // Bottom right corner
		{
			x = 400;
			y = 320;
			onx = e.dirout == 1;

			if (onx)
			{
				if (e.pos > 720 && e.pos < 1120)
					to = e.pos;
				else
					to = 1120;
			}
			else
			{
				if (e.pos < 720 && e.pos > 400)
					to = e.pos;
				else
					to = 400;
			}
		}
		else if (cur == 1120) // Left bottom corner
		{
			x = 0;
			y = 320;
			onx = e.dirout == -1;

			if (onx)
			{
				if (e.pos < 1120 && e.pos > 720)
					to = e.pos;
				else
					to = 720;
			}
			else
			{
				if (e.pos > 1120 && e.pos < 1440)
					to = e.pos;
				else
					to = 1440;
			}
		}
		else if (cur < 400) // Upper
		{
			x = cur;
			y = 0;
			onx = true;

			if (e.pos < 400 && ((e.dirout == 1 && e.pos > cur) || (e.dirout == -1 && e.pos < cur)))
				to = e.pos;
			else if (e.dirout == 1)
				to = 400;
			else
				to = 0;
		}
		else if (cur < 720) // Right
		{
			x = 400;
			y = cur - 400;
			onx = false;

			if (e.pos < 720 && e.pos > 400 && ((e.dirout == 1 && e.pos > cur) || (e.dirout == -1 && e.pos < cur)))
				to = e.pos;
			else if (e.dirout == 1)
				to = 720;
			else
				to = 400;
		}
		else if (cur < 1120) // Lower
		{
			x = 1120 - cur;
			y = 320;
			onx = true;

			if (e.pos < 1120 && e.pos > 720 && ((e.dirout == 1 && e.pos > cur) || (e.dirout == -1 && e.pos < cur)))
				to = e.pos;
			else if (e.dirout == 1)
				to = 1120;
			else
				to = 720;
		}
		else // Left
		{
			x = 0;
			y = 1440 - cur;
			onx = false;

			if (e.pos < 1440 && e.pos > 1120 && ((e.dirout == 1 && e.pos > cur) || (e.dirout == -1 && e.pos < cur)))
				to = e.pos;
			else if (e.dirout == 1)
				to = 1440;
			else
				to = 1120;
		}

		if (to > 720 || (to == 720 && cur > 720))
			dir = e.dirout * -1;
		else
			dir = e.dirout;

		self setClientDvars(
			"temp" + id + "_type", x,
			"temp" + id + "_type2", y,
			"temp" + id + "_type3", onx, // Move on X or Y
			"temp" + id + "_type4", dir,
			"temp" + id + "_type5", getTime() - self.startTime
		);
		wait abs(cur - to) / 80; // 80e/s

		if (to == 1440)
			to = 0;

		if (e.pos == to)
		{
			self setClientDvars(
				"temp" + id + "_type", onx ? (to < 400 ? to : 1120 - to) : x,
				"temp" + id + "_type2", onx ? y : (to < 720 ? to - 400 : 1440 - to),
				"temp" + id + "_type3", !onx, // Move on X or Y
				"temp" + id + "_type4", e.dirin,
				"temp" + id + "_type5", getTime() - self.startTime
			);
			wait e.timein;

			// Game over
			if ((onx ? 1 : -1) != self.puzzle.turn)
			{
				self setClientDvar("temp_type", e.goal);
				self thread restartPuzzle();
				self notify("endpuzzle");
			}
			else
			{
				self setClientDvars(
					"temp" + id + "_type4", 0,
					"temp" + e.id, "-1"
				);
				// FX?
				if (self.puzzle.in == 8) // It's the 9th ~ Maybe it can be checked without '.in' with '.nodes'
				{
					self closeMenus();
					// WIN
				}
				else
					self.puzzle.in++;
			}
			break;
		}
		else
		{
			self.puzzle.bits[id].cur = to;
		}
	}
}

restartPuzzle()
{
	self endon("disconnect");
	self endon("killed_player");
	//waittillframeend; // Wait until "stoppuzzle" is executed
	wait 1.5;
	self startPuzzle();
}

// For compass points
/*watchAngle()
{
	while (true)
	{
		for (i = 0; i < level.allActivePlayers.size; i++)
		{
			level.allActivePlayers[i] setClientDvar("angle", level.allActivePlayers[i].angles[1]);
		}
		wait 0.05;
	}
}*/

setupBot()
{
	self endon("disconnect");
	self.master endon("disconnect");

	self.isBot = true;
	self.showname = "bot:" + self.master.showname;
	self waittill("joined");

	//self setClientDvar("showname", self.showname);
	//level.online[self.showname] = self;
	self.info["pass"] = "test";

	self maps\mp\gametypes\_menus::setDefaultTheme();

	// We need responses, so bots will have every modifcation too
	self maps\mp\gametypes\apb::dress(false);
	self.lang = level.langs[0];
	self.info["lang"] = 0;
	wait 0.5;
	self.mix = "language";
	self notify("menuresponse", game["menu_mix"], "1");
	wait 0.5;
	self.mix = "faction";
	self notify("menuresponse", game["menu_mix"], ((self.master.info["faction"] % 2) + 1) + ""); // Requires string format
	wait 0.5;
	self notify("menuresponse", game["menu_dress"], "save");
	wait 0.5;
	self closeMenu();
	wait 0.5;
	self notify("menuresponse", "ingame", "ready");
}

// There must be an update in the last minute, otherwise server is dead
serverHeartBeat()
{
	level.lastBeat = getRealTime();
	sql_exec("INSERT OR REPLACE INTO servers (ip, name, heartbeat, count_max, count_all, count_allies, count_axis, gamemode) VALUES ('" + level.ip + "', '" + level.server + "', " + level.lastBeat + ", " + level.maxClients + ", 0, 0, 0, '" + getDvar("gamemode") + "')"); // SQLite
	// sql_exec("INSERT INTO servers (ip, name, heartbeat, count_max) VALUES ('" + level.ip + "', '" + level.server + "', " + level.lastBeat + ", " + level.maxClients) ON DUPLICATE KEY UPDATE name = VALUES (name), heartbeat = VALUES (heartbeat), count_max = VALUES (count_max)"); // MySQL
	while (true)
	{
		wait 60 - (getRealTime() - level.lastBeat); // 60 - time passed due to updateServerStat(), so we'll update in every minute for sure
		if (level.lastBeat + 60 <= getRealTime()) // No update in the last 1 minute
		{
			level.lastBeat = getRealTime();
			sql_exec("UPDATE servers SET heartbeat = " + level.lastBeat + " WHERE ip = '" + level.ip + "'");
		}
	}
}

updateServerStat(value)
{
	level.lastBeat = getRealTime();
	sql_exec("UPDATE servers SET " + value + ", heartbeat = " + level.lastBeat + " WHERE ip = '" + level.ip + "'");
}

getRoleType(role)
{
	if (role == "rifle" || role == "machinegun" || role == "sniper" || role == "marksman" || role == "shotgun" || role == "nonlethal")
		return "primary";
	else
		return "secondary";
}

createPins()
{
	self.pins = [];
	n = 0;
	foreach (e as level.vendorTypes;;+)
	{
		foreach (t as level.triggers[e])
		{
			self.pins[n] = newClientHudElem(self);
			self.pins[n] setShader("pin_" + e, 6, 6);
			self.pins[n] setWayPoint(true, "pin_" + e);
			self.pins[n].hideWhenInMenu = true;
			self.pins[n].alpha = 0.75;
			self.pins[n].x = t.origin[0];
			self.pins[n].y = t.origin[1];
			self.pins[n].z = t.origin[2] + 64;
			n++;
		}
	}
}

destroyPins()
{
	foreach (e as self.pins)
	{
		e destroy();
	}
}

watchMails()
{
	self endon("disconnect");

	while (true)
	{
		self.newmails = int(sql_query_first("SELECT COUNT(*) FROM msg WHERE name = '" + self.showname + "' AND read = 0"));
		self setClientDvar("newmails", self.newmails);
		wait 30;
	}
}

watchSprint()
{
	self endon("disconnect");
	self endon("death");
	self endon("spawned"); // Spectator

	while (true)
	{
		self waittill("sprint_begin");
		self.currentRun = 0;

		self monitorSprint();

		allSprint = self.info["allrun"] + int(sqrt(self.currentRun));
		self.currentRun = undefined;
		//self setSave("SPRINT", int(allSprint));
		if (self.info["allrun"] < 9842519675) // 25 km in inches
		{
			if (allSprint >= 9842519675)
				self giveAchievement("SPRINT");
			//else
				//self setClientDvar("achievement_sprint_progress", int(self.info["allrun"] / 39.3700787) + "/25000");
		}
		self.info["allrun"] = allSprint;
		self setClientDvar("allrun", self.info["allrun"]);
		//sql_push("UPDATE players SET allrun = " + self.info["allrun"] + " WHERE name = '" + self.showname + "'");
		//self saveStatus();
	}
}

monitorSprint()
{
	self endon("disconnect");
	self endon("death");
	self endon("sprint_end");
	self endon("spawned"); // Spectator

	pos = self.origin;
	while (true)
	{
		wait 0.1;
		self.currentRun += distance2DSquared(pos[0], pos[1], self.origin[0], self.origin[1]);
		pos = self.origin;
	}
}

queryThreat()
{
	// Must be defined
	if (isDefined(self.threat))
		hadThreat = self.threat;
	else
		hadThreat = "";

	if (self.info["mis_win"] + self.info["mis_lose"] + self.info["mis_tied"] < 10)
	{
		// Not played enough
		self.threat = "silver";
	}
	else if (!self.info["mis_lose"])
	{
		// All won: couldn't divide by zero
		self.threat = "gold";
	}
	else
	{
		// Normal player
		rate = self.info["mis_win"] / self.info["mis_lose"];
		if (rate < 1.35 && rate > 0.65)
			self.threat = "silver";
		else if (rate >= 1.35)
			self.threat = "gold";
		else
			self.threat = "bronze";
	}
	if (isDefined(self.missionId) && hadThreat != "" && self.threat != hadThreat)
	{
		if (self.threat == "gold")
		{
			self giveAchievement("GOLD");
		}
		self setClientDvar("threat", self.threat);

		foreach (e as level.teams[self.missionTeam];;+)
		{
			e.playerStats[self.clientid].threat = self.threat;
		}
		foreach (e as level.teams[self.enemyTeam];;+)
		{
			e.playerStats[self.clientid].threat = self.threat;
		}
		/*info = spawnStruct();
		info.title = level.s["THREAT_TITLE_" + self.lang];
		info.line = level.s["NEWTHREAT_" + self.lang] + ": " + self.threat;
		info.icon = "rank" + level.ranks[self.rating]["id"] + "_" + self.team;
		self thread gameMessage(info);*/
	}
}

delayTutorial()
{
	self endon("disconnect");

	wait 0.05;
	self openMenu(game["menu_tutorial"]);
}

/*getStringLen(str)
{
	w = 0;
	for (i = 0; i < str.size; i++)
	{
		if (isSubStr("'", str[i]))
			w += 1;
		else if (isSubStr("ijl.,:;_%", str[i]))
			w += 2;
		else if (isSubStr("fI-|", str[i]))
			w += 2.5;
		else if (isSubStr("tr!/\"\\", str[i]))
			w += 3;
		else if (isSubStr("t()[]", str[i]))
			w += 3.5;
		else if (isSubStr("T{}*", str[i]))
			w += 4;
		else if (isSubStr("acgksvxzFJLYZ", str[i]))
			w += 4.5;
		else if (isSubStr("dhnAPSVX? ", str[i]))
			w += 5;
		else if (isSubStr("BDGKOQRU0123456789$<>=+^~", str[i]))
			w += 5.5;
		else if (isSubStr("HN#", str[i]))
			w += 6;
		else if (isSubStr("w&", str[i]))
			w += 6.5;
		else if (isSubStr("WM@", str[i]))
			w += 7;
		else if (isSubStr("m", str[i]))
			w += 7.5;
		else
			w += 5;
	}
	return w;
}*/

dress(menus)
{
	if (isAlive(self))
	{
		self.spawned = false;
		dresser = getEnt("dresser", "targetname");

		if (isDefined(dresser))
			origin = dresser.origin;
		else
			origin = (0, 0, 0);

		self setOrigin(origin);
		self setPlayerAngles((0, 0, 0));
	}
	else
	{
		self spawn(getEnt("dresser", "targetname").origin, (0, 0, 0));
	}
	self setClientDvars(
		"cg_thirdPerson", 1,
		"cg_thirdPersonAngle", 180,
		"cg_thirdPersonRange", 150
	);

	self hide();

	if (!isDefined(menus) || menus)
	{
		self closeMenus();
		self openMenu(game["menu_dress"]);
	}
	else
	{
		// Controls are frozen in editDress()
		self freezeControls(true);
	}
}

giveMoney(amount)
{
	if (!amount)
		return 0;

	if (amount > 0)
	{
		amount = int(amount * level.prestige[self.prestige]);

		if (self.premium)
			add = int(amount / 2);
		else
			add = 0;

		if (isDefined(self.missionId))
		{
			self.stat["cash"] += amount; // Mission cash

			if (self.premium)
				self.stat["pcash"] += add;

			self refreshStat("cash", "pcash", "$");
		}

		//all = amount + add;

		if (isDefined(self.invmoney))
			self.invmoney += amount + add; // Money for inviters

		self.info["money"] += amount + add; // Overall cash
		self setClientDvar("money", self.info["money"]);

		r = spawnStruct();
		r.amount = amount;
		r.display = "$" + amount + "^3 + $" + add + "^7";
		return r;
	}
	else
	{
		self.info["money"] += amount;
		self setClientDvar("money", self.info["money"]);
	}
	//self setSave("MONEY", self.info["money"]);
}

giveStanding(amount)
{
	return self maps\mp\gametypes\_rank::giveStanding(amount);
}

gameMessage(info)
{
	self.msgs[self.msgs.size] = info;
	if (self.msgs.size == 1)
	{
		self thread startGameMessage(0);
	}
}

newMessage(msg)
{
	/*lineCount = int(ceil(msg.size / 44));
	lines = [];
	for (i = 0; i < lineCount; i++)
	{
		lines[i] = getSubStr(msg, i * 44, (i + 1) * 44);
	}*/
	lines = strTokByLen(msg, 44);
	allLines = self.chat.size + lines.size;
	shift = allLines - 6;
	if (shift > 0)
	{
		for (i = shift; i < self.chat.size; i++)
		{
			self.chat[i - shift] = self.chat[i];
			self setMessage(i - shift);
		}
		start = 6 - lines.size;
		for (i = start; i < 6; i++)
		{
			self.chat[i] = lines[i - start];
			self setMessage(i);
		}
	}
	else
	{
		n = self.chat.size; // It is changing in the loop
		for (i = n; i < allLines; i++)
		{
			self.chat[i] = lines[i - n];
			self setMessage(i);
		}
	}

	self iPrintLn("Chat: " + msg);
	self thread showChat();
}

setMessage(id)
{
	self setClientDvar("chat" + (id + 1), self.chat[id]);
}

showChat()
{
	self notify("newmessage");
	self endon("newmessage");
	self endon("disconnect");

	self setClientDvar("chat_on", 1);
	wait 12;
	self setClientDvar("chat_on", 0);
}

startGameMessage(id)
{
	self endon("disconnect");

	while (self.sessionstate != "playing" || self menuStatus())
	{
		if (self.sessionstate != "playing")
			self waittill("spawned_player");

		if (self menuStatus())
			self waittill("boardoff");
	}

	self setClientDvars(
		"msg_body", self.msgs[id].line,
		"msg_title", self.msgs[id].title,
		"msg_image", self.msgs[id].icon
	);

	self setClientDvar("time_delay", getTime() - self.startTime);

	//self clientExec("setdvartotime msgtime");

	/*self.msg["bodybg"] = newClientHudElem(self);
	self.msg["bodybg"].x = -180;
	self.msg["bodybg"].y = -120;
	self.msg["bodybg"].width = 180;
	self.msg["bodybg"].height = 30;
	self.msg["bodybg"].horzAlign = "left";
	self.msg["bodybg"].vertAlign = "bottom";
	self.msg["bodybg"] setShader("black", 180, 30);
	self.msg["bodybg"].alpha = 0.85;
	self.msg["bodybg"].hideWhenInMenu = true;

	self.msg["iconbg"] = newClientHudElem(self);
	self.msg["iconbg"].x = -230;
	self.msg["iconbg"].y = -140;
	self.msg["iconbg"].width = 50;
	self.msg["iconbg"].height = 50;
	self.msg["iconbg"].horzAlign = "left";
	self.msg["iconbg"].vertAlign = "bottom";
	self.msg["iconbg"] setShader("white", 50, 50);
	self.msg["iconbg"].color = (0.25, 0.25, 0.25);
	self.msg["iconbg"].alpha = 0.85;
	self.msg["iconbg"].hideWhenInMenu = true;

	self.msg["icon"] = newClientHudElem(self);
	self.msg["icon"].x = -228;
	self.msg["icon"].y = -138;
	self.msg["icon"].width = 46;
	self.msg["icon"].height = 46;
	self.msg["icon"].horzAlign = "left";
	self.msg["icon"].vertAlign = "bottom";
	self.msg["icon"].alpha = 0.85;
	self.msg["icon"].hideWhenInMenu = true;

	self.msg["titlebg"] = newClientHudElem(self);
	self.msg["titlebg"].x = -180;
	self.msg["titlebg"].y = -140;
	self.msg["titlebg"].width = 180;
	self.msg["titlebg"].height = 20;
	self.msg["titlebg"].horzAlign = "left";
	self.msg["titlebg"].vertAlign = "bottom";
	self.msg["titlebg"] setShader("white", 180, 20);
	self.msg["titlebg"].color = (0.2, 0.4, 0.8);
	self.msg["titlebg"].alpha = 0.85;
	self.msg["titlebg"].hideWhenInMenu = true;

	self.msg["title"] = newClientHudElem(self);
	self.msg["title"].x = -175;
	self.msg["title"].y = -130;
	self.msg["title"].horzAlign = "left";
	self.msg["title"].vertAlign = "bottom";
	self.msg["title"].alignX = "left";
	self.msg["title"].alignY = "middle";
	self.msg["title"].elemType = "font";
	self.msg["title"].font = "default";
	self.msg["title"].fontscale = 1.55;
	self.msg["title"].color = (1, 1, 1);
	self.msg["title"].alpha = 0.85;
	self.msg["title"].hideWhenInMenu = true;

	self.msg["line"] = newClientHudElem(self);
	self.msg["line"].x = -175;
	self.msg["line"].y = -105;
	self.msg["line"].horzAlign = "left";
	self.msg["line"].vertAlign = "bottom";
	self.msg["line"].alignX = "left";
	self.msg["line"].alignY = "middle";
	self.msg["line"].elemType = "font";
	self.msg["line"].font = "default";
	self.msg["line"].fontscale = 1.4;
	self.msg["line"].color = (1, 1, 1);
	self.msg["line"].alpha = 0.85;
	self.msg["line"].hideWhenInMenu = true;

	self.msg["icon"] setShader(self.msgs[id].icon, 46, 46);
	self.msg["title"].label = self.msgs[id].title;
	self.msg["line"] setText(self.msgs[id].line);*/

	wait 0.5;

	if (isDefined(self.msgs[id].sound))
		self playLocalSound(self.msgs[id].sound);
	else
		self playLocalSound("Notify");

	wait 4.5;

	id++;

	if (self.msgs.size > id)
		self thread startGameMessage(id);
	else
		self.msgs = [];
}

// Tutorial matchmaking
searchEnemyBot()
{
	while (true)
	{
		wait 1;

		foreach (e as level.readyPlayers["allies"])
		{
			if (isDefined(e.bot) && isDefined(e.bot.ready))
			{
				allies[0] = e;
				axis[0] = e.bot;
				newMission(allies, axis);
				searchEnemyBot(); // Restart, no more missions in the same time
			}
		}
		foreach (e as level.readyPlayers["axis"])
		{
			if (isDefined(e.bot) && isDefined(e.bot.ready))
			{
				axis[0] = e;
				allies[0] = e.bot;
				newMission(allies, axis);
				searchEnemyBot(); // Restart
			}
		}
	}
}

// Matchmaking
searchEnemy()
{
	while (true)
	{
		wait 2;
		rl = level.readyPlayers["allies"];
		rlg = level.readyGroups["allies"];
		rx = level.readyPlayers["axis"];
		rxg = level.readyGroups["axis"];
		lc = rl.size;
		lg = rlg.size;
		xc = rx.size;
		xg = rxg.size;
		if ((lc || lg) && (xc || xg))
		{
			allies = lc;
			if (lg)
			{
				foreach (e as rlg; 0; +lg)
				{
					allies += level.groups[e].team.size;
				}
			}
			axis = xc;
			if (xg)
			{
				foreach (e as rxg; 0; +xg)
				{
					axis += level.groups[e].team.size;
				}
			}

			if (allies <= 8 && axis <= 8 && abs(allies - axis) <= 1) // (allies == axis || allies - 1 == axis || axis - 1 == allies)
			{
				alliesTeam = rl;
				if (lg)
				{
					foreach (e as rlg; 0; +lg)
					{
						foreach (f as level.groups[e].team;;+)
						{
							alliesTeam[lc] = f;
							lc++;
						}
					}
				}
				axisTeam = rx;
				if (xg)
				{
					foreach (e as rxg; 0; +xg)
					{
						foreach (f as level.groups[e].team;;+)
						{
							axisTeam[xc] = f;
							xc++;
						}
					}
				}
				newMission(alliesTeam, axisTeam);
			}
			else
			{
				allAllies = lc + lg;
				allAxis = xc + xg;

				// Matchmaking with a maximum of two group/player combinations
				opp = spawnStruct();
				zero = false;
				for (i = 0; i < allAllies - 1 || !i; i++)
				{
					if (lc > i)
						firstAllies = rl[i];
					else
						firstAllies = level.groups[rlg[i - lc]].team;

					for (j = i; j < allAllies; j++)
					{
						if (lc > j)
							secondAllies = rl[j];
						else // if (j != i) - must be defined
							secondAllies = level.groups[rlg[j - lc]].team;

						for (k = 0; k < allAxis - 1 || !k; k++)
						{
							if (xc > k)
								firstAxis = rx[k];
							else
								firstAxis = level.groups[rxg[k - xc]].team;

							for (l = k; l < allAxis; l++)
							{
								if (xc > l)
									secondAxis = rx[l];
								else
									secondAxis = level.groups[rxg[l - xc]].team;

								// ALlies
								allies = 0;
								alliesThreat = 0;
								alliesTeam = [];

								if (lc > i)
								{
									alliesTeam[allies] = firstAllies;
									allies++;

									if (firstAllies.threat == "gold")
										alliesThreat += 3;
									else if (firstAllies.threat == "silver")
										alliesThreat += 2;
									else
										alliesThreat++;
								}
								else
								{
									foreach (g as firstAllies;;+)
									{
										alliesTeam[allies] = g;
										allies++;

										if (g.threat == "gold")
											alliesThreat += 3;
										else if (g.threat == "silver")
											alliesThreat += 2;
										else
											alliesThreat++;
									}
								}

								if (i != j)
								{
									if (lc > j)
									{
										alliesTeam[allies] = secondAllies;
										allies++;

										if (secondAllies.threat == "gold")
											alliesThreat += 3;
										else if (secondAllies.threat == "silver")
											alliesThreat += 2;
										else
											alliesThreat++;
									}
									else
									{
										foreach (g as secondAllies;;+)
										{
											alliesTeam[allies] = g;
											allies++;

											if (g.threat == "gold")
												alliesThreat += 3;
											else if (g.threat == "silver")
												alliesThreat += 2;
											else
												alliesThreat++;
										}
									}
								}

								// Axis
								axis = 0;
								axisThreat = 0;
								axisTeam = [];

								if (xc > k)
								{
									axisTeam[axis] = firstAxis;
									axis++;

									if (firstAxis.threat == "gold")
										axisThreat += 3;
									else if (firstAxis.threat == "silver")
										axisThreat += 2;
									else
										axisThreat++;
								}
								else
								{
									foreach (g as firstAxis;;+)
									{
										axisTeam[axis] = g;
										axis++;

										if (g.threat == "gold")
											axisThreat += 3;
										else if (g.threat == "silver")
											axisThreat += 2;
										else
											axisThreat++;
									}
								}

								if (k != l)
								{
									if (xc > l)
									{
										axisTeam[axis] = secondAxis;
										axis++;

										if (secondAxis.threat == "gold")
											axisThreat += 3;
										else if (secondAxis.threat == "silver")
											axisThreat += 2;
										else
											axisThreat++;
									}
									else
									{
										foreach (g as secondAxis;;+)
										{
											axisTeam[axis] = g;
											axis++;

											if (g.threat == "gold")
												axisThreat += 3;
											else if (g.threat == "silver")
												axisThreat += 2;
											else
												axisThreat++;
										}
									}
								}

								// Measuring
								// Player count differences
								diff = abs(axis - allies);
								/*if (axis > allies)
									diff = axis - allies;
								else if (allies > axis)
									diff = allies - axis;
								else
									diff = 0;*/

								if (!diff || (diff == 1 && !zero))
								{
									if (!diff && !zero)
									{
										zero = true;
										opp = spawnStruct();
									}
									threatDiff = abs(alliesThreat - axisThreat);
									all = allies + axis;
									if (!isDefined(opp.count) || all > opp.count || (all == opp.count && threatDiff < opp.diff))
									{
										opp.allies = alliesTeam;
										opp.axis = axisTeam;
										opp.count = all;
										opp.diff = threatDiff;
									}
								}
							}
						}
					}
					resetTimeout();
				}

				if (isDefined(opp.count))
				{
					newMission(opp.allies, opp.axis);
				}
			}
		}
	}
}

newMission(allies, axis, isWar)
{
	missionId = level.missions.size;
	alliessize = allies.size;
	axissize = axis.size;

	// Leaders
	alliesleader = allies[0];
	alliesThreat = 0;
	for (i = 1; i < alliessize; i++)
	{
		p = allies[i];
		if ((isDefined(p.groupleader) && (!isDefined(alliesleader.groupleader) || p.rating > alliesleader.rating)) || (!isDefined(alliesleader.groupleader) && p.rating > alliesleader.rating))
		{
			alliesleader = p;
		}
		alliesThreat += level.threatValue[p.threat];
	}

	axisleader = axis[0];
	axisThreat = 0;
	for (i = 1; i < axissize; i++)
	{
		p = axis[i];
		if ((isDefined(p.groupleader) && (!isDefined(axisleader.groupleader) || p.rating > axisleader.rating)) || (!isDefined(axisleader.groupleader) && p.rating > axisleader.rating))
		{
			axisleader = i;
		}
		alliesThreat += level.threatValue[p.threat];
	}

	// Generate new mission
	level.missions[missionId] = spawnStruct();
	alliesTeam = level.teams.size;
	axisTeam = alliesTeam + 1;
	level.missions[missionId].team["allies"] = alliesTeam;
	level.missions[missionId].team["axis"] = axisTeam;
	level.missions[missionId].currentStage = 0;

	if (level.tutorial)
		level.missions[missionId].stages = 2;
	else
		level.missions[missionId].stages = randomIntRange(4, 7);

	if (isDefined(isWar) && isWar)
	{
		level.missions[missionId].war["allies"] = sql_query_first("SELECT clan FROM members WHERE name = '" + allies[0].showname + "'");
		level.missions[missionId].war["axis"] = sql_query_first("SELECT clan FROM members WHERE name = '" + axis[0].showname + "'");

		// We have to store it here, because maybe any of them quits under the match (allies == axis)
		for (i = 0; i < alliessize; i++)
		{
			level.missions[missionId].war["alliesteam"][i] = allies[i].showname;
			level.missions[missionId].war["axisteam"][i] = axis[i].showname;
		}

		// Alert the district
		foreach (p as level.allActivePlayers; 0; +level.allActiveCount)
		{
			p thread showInfoLine(level.missions[missionId].war["allies"] + " " + level.s["INFO_WAR_" + p.lang] + " " + level.missions[missionId].war["axis"]);
		}
	}
	else if (alliessize < axissize || (alliessize == axissize && axisThreat - alliesThreat > alliessize))
		alliesleader setClientDvar("leftinfo", "CALL_BACKUP");
	else if (axissize < alliessize || (allies.size == axissize && alliesThreat - axisThreat > axissize))
		axisleader setClientDvar("leftinfo", "CALL_BACKUP");

	// Merging allies and axis
	level.missions[missionId].all = allies;
	allCount = alliessize;

	// Stats
	foreach (p as i:allies; 0; +alliessize)
	{
		p.missionTeam = alliesTeam;
		p.enemyTeam = axisTeam;
		p.teamId = i;
		level.teams[alliesTeam][i] = p;

		// Alert
		p thread showAlert(axissize + " " + level.s["ENEMIES_JOINED_" + p.lang] + " " + axisleader.showname, "missionNotify");
	}
	foreach (p as i:axis; 0; +axissize)
	{
		p.missionTeam = axisTeam;
		p.enemyTeam = alliesTeam;
		p.teamId = i;
		level.teams[axisTeam][i] = p;

		level.missions[missionId].all[allCount] = p;
		allCount++;

		// Alert
		p thread showAlert(alliessize + " " + level.s["ENEMIES_JOINED_" + p.lang] + " " + alliesleader.showname, "missionNotify");
	}

	// Prepare variables
	m = level.missions[missionId].all;
	for (i = 0; i < allCount; i++)
	{
		// It is used in joinMission()
		m[i] setClanStat();
	}
	for (i = 0; i < allCount; i++)
	{
		m[i] joinMission(missionId);
	}
	alliesleader.teamleader = true;
	axisleader.teamleader = true;
	level.missions[missionId].allCount = allCount;

	// Statistics, etc
	refreshTeam(alliesTeam);
	refreshTeam(axisTeam);

	// Begin
	thread newObj(missionId);
}

// It can't be in joinMission, because it is used in createPlayerInfo()
setClanStat()
{
	c = sql_fetch(sql_query("SELECT '^' || color || clan, c.rank, m.rank FROM members m JOIN clans c USING (clan) WHERE name = '" + self.showname + "'"));
	if (isDefined(c))
	{
		self.stat["clan"] = c[0];
		self.stat["clan_crank"] = c[1] + "_" + self.team;
		self.stat["clan_mrank"] = c[2];

		ratio = int(sql_query_first("SELECT (SELECT COUNT(*) FROM wars WHERE winner = '" + c[0] + "' AND tied = 0) - (SELECT COUNT(*) FROM wars WHERE loser = '" + c[0] + "' AND tied = 0)"));

		if (!ratio)
			self.stat["clan_threat"] = "silver";
		else if (ratio > 0)
			self.stat["clan_threat"] = "gold";
		else
			self.stat["clan_threat"] = "bronze";
	}
	else if (isDefined(self.stat) && isDefined(self.stat["clan"]))
	{
		self.stat["clan"] = undefined;
		self.stat["clan_crank"] = undefined;
		self.stat["clan_mrank"] = undefined;
		self.stat["clan_threat"] = undefined;
	}
}

showAlert(string, sound)
{
	self notify("alert");
	self endon("alert");
	self endon("disconnect");

	self playLocalSound(sound);
	self setClientDvar("alert", string);
	wait 5;
	self setClientDvar("alert", "");
}

joinMission(missionId)
{
	m = level.missions[missionId];

	self.invited = undefined;
	self setClientDvars(
		"ready", false,
		"mission", true,
		"missionstatus", "PROGRESS",
		"missionstatus_desc", "",
		"leftinfo", "",
		"mvp", "",
		"currentStage", m.currentStage,
		"stages", m.stages
	);
	self.hadMission = true;
	self.enemyCompass = [];
	self.objCompass = [];
	self.stat["name"] = self.showname;
	self.stat["kills"] = 0;
	self.stat["arrests"] = 0;
	self.stat["teamkills"] = 0;
	self.stat["assists"] = 0;
	self.stat["deaths"] = 0;
	self.stat["targets"] = 0;
	self.stat["cash"] = 0;
	self.stat["pcash"] = 0;
	self.stat["standing"] = 0;
	self.stat["pstanding"] = 0;
	self.stat["streak"] = 0;
	self.stat["blitz"] = 0;
	self.stat["stuns"] = 0;

	self.stat["medals"] = [];
	self.dmg = 0;
	self.playerStats = [];
	self.missionId = missionId;

	gps = [];
	if (isDefined(self.group))
	{
		if (!isDefined(gps[self.group]))
		{
			unsetArrayItem(level.readyGroups[self.team], self.group);
			gps[self.group] = true;
		}
	}
	else if (self.ready)
	{
		self unreadyPlayer();
	}
	self.ready = false;

	if (level.action)
		self destroyPins();

	self createPlayerInfo(m.all);
	self thread monitorFire();
	self thread monitorMissionTime();
	self closeMenus();
}

monitorMissionTime()
{
	self endon("disconnect");
	self endon("endmission");

	while (true)
	{
		wait 1;
		self.info["missiontime"]++;
		//self setSave("MISSIONTIME", self.info["missiontime"]);
		self setClientDvar("missiontime", leftTimeToString(self.info["missiontime"]));
		if (self.info["missiontime"] == 86400)
			self giveAchievement("VETERAN");
		//else if (self.info["missiontime"] < 86400)
			//self setClientDvar("achievement_veteran_progress", leftTimeToString(self.info["missiontime"], "nos") + "/24:00");

		//sql_push("UPDATE players SET missiontime = " + self.info["missiontime"] + " WHERE name = '" + self.showname + "'");
		//self saveStatus();
	}
}

monitorPrestigeTime()
{
	self endon("disconnect");
	self endon("killed_player");

	while (true)
	{
		wait 1;
		self.info["prestigetime"]++;
		//self setSave("PRESTIGE", self.info["prestigetime"]);
		self setClientDvar("prestigetime", leftTimeToString(self.info["prestigetime"]));
		if (self.info["prestigetime"] == 3600)
			self giveAchievement("PRESTIGE");
		//else if (self.info["prestigetime"] < 3600)
			//self setClientDvar("achievement_prestige_progress", leftTimeToString(self.info["prestigetime"], "noh") + "/60:00");

		//sql_push("UPDATE players SET prestigetime = " + self.info["prestigetime"] + " WHERE name = '" + self.showname + "'");
		//self saveStatus();
	}
}

createPlayerInfo(p)
{
	foreach (e as p;;+)
	{
		if (e != self)
		{
			if (e.team == self.team)
				img = "friend";
			else
				img = "enemy";

			if (e.prestige != 5)
				self newPoint(img + "pnt", img, e);
		}

		id = e.clientid;
		self.playerStats[id] = spawnStruct();
		self.playerStats[id].perk1 = e.perk1;
		self.playerStats[id].perk2 = e.perk2;
		self.playerStats[id].perk3 = e.perk3;
		self.playerStats[id].name = e.showname;
		self.playerStats[id].primary = e.info["prime"];
		self.playerStats[id].primaryperks = e maps\mp\gametypes\_menus::getWeapPerkArray(e.info["prime"]);
		self.playerStats[id].rating = e.rating;
		self.playerStats[id].rank = level.ranks[e.rating]["id"] + "_" + e.team;
		self.playerStats[id].threat = e.threat;
		self.playerStats[id].medals = [];
		self.playerStats[id].symbol = e.info["symbol"];
		self.playerStats[id].team = e.team;
		if (isDefined(e.stat) && isDefined(e.stat["clan"]))
		{
			self.playerStats[id].clan = e.stat["clan"];
			self.playerStats[id].clan_crank = e.stat["clan_crank"];
			self.playerStats[id].clan_mrank = e.stat["clan_mrank"];
			self.playerStats[id].clan_threat = e.stat["clan_threat"];
		}
	}
}

newPoint(shader, side, follow)
{
	this = newClientHudElem(self);
	this setShader(shader, 4, 4);
	this setWayPoint(true);
	this.alpha = 0.75;
	this.hideWhenInMenu = true;
	this.x = self.origin[0];
	this.y = self.origin[1];
	this.z = self.origin[2];

	self thread watchPos(follow, side, this);
}

newMissionPoint(shader, follow, type)
{
	this = newClientHudElem(self);
	this setShader("3d_" + shader, 4, 4);
	this setWayPoint(true, "3d_" + shader);
	this.alpha = 0.75;
	this.x = self.origin[0];
	this.y = self.origin[1];
	this.z = self.origin[2];

	self thread watchMissionPos(follow, this, type);
}

// If we don't recreate the HUD element, we will get this idiot error:
// NOT DRAWING WITH MATERIAL "%s", because it has a fogable technique.
// If there is a solution, use setShader(shader, 4, 8) instead of this
recreateHeadIcon(icon, shader)
{
	this = newClientHudElem(self);
	this setShader(shader, 4, 4);
	this setWayPoint(true);
	this.alpha = 0.75;
	this.x = icon.x;
	this.y = icon.y;
	this.z = icon.z;

	icon destroy();
	return this;
}

watchMissionPos(follow, headIcon, type)
{
	self endon("disconnect");

	id = level.missions[self.missionId].currentStage;
	while (true)
	{
		wait 0.05;

		// They can't enter into a new mission under one frame
		if (!isDefined(follow) || !isDefined(self) || !isDefined(self.missionId) || level.missions[self.missionId].currentStage != id || (type == "obj" && (!isDefined(follow.objects) || !follow.objects))) // (!isDefined(self.stock) && ...)
			break;

		if (follow.sessionstate == "playing" && self.sessionstate == "playing")
		{
			if (!headIcon.alpha)
				headIcon.alpha = 0.75;

			if (headIcon.x != follow.origin[0])
				headIcon.x = follow.origin[0];

			if (headIcon.y != follow.origin[1])
				headIcon.y = follow.origin[1];

			if (headIcon.z != follow.origin[2] + 64) // Maybe it should depend on getStance?
				headIcon.z = follow.origin[2] + 64;
		}
		else if (headIcon.alpha)
		{
			headIcon.alpha = 0;
		}
	}

	if (isDefined(headIcon))
		headIcon destroy();
}

watchPos(follow, side, headIcon)
{
	self endon("disconnect");

	wasFollowPublicEnemy = follow.prestige == 5;
	wasMasterPublicEnemy = self.prestige == 5;
	wasArrested = isDefined(follow.arrested);
	wasSameMission = isDefined(self.missionId) && isDefined(follow.missionId) && self.missionId == follow.missionId;

	// Check only once
	isFriend = side == "friend";

	while (true)
	{
		wait 0.05;

		inSameMission = isDefined(self.missionId) && isDefined(follow.missionId) && self.missionId == follow.missionId;
		isFollowPublicEnemy = follow.prestige == 5;
		isMasterPublicEnemy = self.prestige == 5;
		isArrested = isDefined(follow.arrested);

		if (
			!isDefined(follow) || 
			!isDefined(self) || 
			(!isFollowPublicEnemy && !isMasterPublicEnemy && !inSameMission) || // (!isFollowPublicEnemy || isFriend)
			(inSameMission && ((!isFriend && isDefined(level.missions[self.missionId].dm)) || isDefined(follow.vip))) || 
			(isFriend && !isFollowPublicEnemy && !inSameMission)
		)
			break;

		if (isArrested)
		{
			if (!wasArrested)
			{
				headIcon = recreateHeadIcon(headIcon, "arrestpnt");
			}
		}
		else if (!wasFollowPublicEnemy && isFollowPublicEnemy)
		{
			if (inSameMission)
				headIcon = recreateHeadIcon(headIcon, "teampublic" + side + "pnt");
			else
				headIcon = recreateHeadIcon(headIcon, "public" + side + "pnt");
		}
		else if ((wasFollowPublicEnemy && !isFollowPublicEnemy) || (wasArrested && !isArrested))
		{
			if (inSameMission)
				headIcon = recreateHeadIcon(headIcon, side + "pnt");
			else
				headIcon = recreateHeadIcon(headIcon, "ofpublicenemypnt");
		}
		else if ((!wasMasterPublicEnemy || wasSameMission) && isMasterPublicEnemy && !inSameMission && !isFriend && !isFollowPublicEnemy)
		{
			headIcon = recreateHeadIcon(headIcon, "ofpublicenemypnt");
		}

		if (follow.sessionstate == "playing" && self.sessionstate == "playing" && (!isDefined(follow.objects) || !follow.objects) && (isFriend || follow sightConeTrace(self getEye(), self) > 0))
		{
			if (!headIcon.alpha)
				headIcon.alpha = 0.75;

			if (headIcon.x != follow.origin[0])
				headIcon.x = follow.origin[0];

			if (headIcon.y != follow.origin[1])
				headIcon.y = follow.origin[1];

			if (headIcon.z != follow.origin[2] + 64) // Maybe it should depend on getStance?
				headIcon.z = follow.origin[2] + 64;
		}
		else if (headIcon.alpha)
		{
			headIcon.alpha = 0;
		}

		wasFollowPublicEnemy = isFollowPublicEnemy;
		wasMasterPublicEnemy = isMasterPublicEnemy;
		wasArrested = isArrested;
		wasSameMission = inSameMission;
	}

	if (isDefined(headIcon))
		headIcon destroy();
}

newObj(id)
{
	// Increase stage
	level.missions[id].currentStage++;
	m = level.missions[id];
	currentStage = m.currentStage;
	lastStage = currentStage == m.stages;

	// For all players
	foreach (p as m.all; 0; +m.allCount)
	{
		for (j = 0; j < 8; j++)
		{
			p setClientDvars(
				"map_obj" + j + "z", ""//,
				//"map_obj" + j + "d", "",
				//"map_obj" + j + "type", ""
			);
		}
		p setClientDvar("currentStage", currentStage);

		// Message
		if (!lastStage)
			p newMessage("^3[" + level.s["MISSION_" + p.lang] + "] " + level.s["MISSION_STAGE_" + p.lang] + " " + currentStage + " / " + level.missions[id].stages);
		else
			p newMessage("^3[" + level.s["MISSION_" + p.lang] + "] " + level.s["FINAL_MISSION_STAGE_" + p.lang]);

		if (currentStage != 1) // Not first stage
		{
			p resetIcons();
			p playLocalSound("MissionStage");
			p thread mainLine(level.s["NEXT_STAGE_" + p.lang] + "!", level.s["NOW_ON_STAGE_" + p.lang] + " " + currentStage);
		}
		p.objIcons = [];
	}

	// Reset map objects
	if (isDefined(m.obj))
		level.missions[id].obj = undefined; // Modifying -> Don't use 'm' pointer

	// New stage
	if (level.tutorial)
	{
		if (!lastStage)
			thread [[level.missionList[0]]](id);
		else
			thread [[level.lastMissionList[0]]](id);
	}
	else
	{
		if (!lastStage)
			thread [[level.missionList[randomInt(level.missionList.size)]]](id);
		else if (level.teams[m.team["allies"]].size > 1 && level.teams[m.team["axis"]].size > 1) // At least 2v2
			thread [[level.lastMissionList[randomInt(level.lastMissionList.size)]]](id);
		else // No VIP mission otherwise
			thread [[level.lastMissionList[randomInt(level.lastMissionList.size - 1)]]](id);
	}
}

killLoadBar()
{
	if (isDefined(self.loadbar))
	{
		self.loadbar destroy();
		self.barbg destroy();
	}
}

loadBar(curTime, id)
{
	self newLoadBar(int(curTime * (100 / level.missions[id].captureTime) + 0.5), level.missions[id].captureTime);
}

newLoadBar(width, time)
{
	self.barbg = newClientHudElem(self);
	self.barbg.x = 268;
	self.barbg.y = 8;
	self.barbg.sort = -2;
	self.barbg.alpha = 0.5;
	self.barbg setShader("black", 104, 13);

	self.loadbar = newClientHudElem(self);
	//self.loadbar reset();
	self.loadbar.x = 270;
	self.loadbar.y = 10;
	self.loadbar.sort = -1;

	if (isDefined(time))
	{
		self.loadbar setShader("white", width, 9);
		self.loadbar scaleOverTime(time, 100, 9);
	}
}

objOnCompass(id, origin, type)
{
	self.objCompass[id] = origin;

	if (type == "plant") // Plant has the same icon as defuse
		self setClientDvar("map_obj" + id + "type", "defuse");
	else
		self setClientDvar("map_obj" + id + "type", type);

	// 3D Icon
	if (!isDefined(self.objIcons[id]))
	{
		self.objIcons[id] = newClientHudElem(self);
		m = self.objIcons[id];
		m.x = origin[0];
		m.y = origin[1];
		m.z = origin[2] + 32;
		m.hideWhenInMenu = true;
	}
	self.objIcons[id] setShader("3d_" + type + id, 4, 4);
	self.objIcons[id] setWayPoint(true, "3d_" + type + id);
}

resetIcons()
{
	foreach (k as self.objIcons; @)
	{
		k destroy();
	}
}

// TODO: Optimize somehow?
monitorPlayer()
{
	self endon("disconnect");

	while (true)
	{
		if (isDefined(self.missionId))
		{
			l = isAlive(self);
			foreach (p as level.teams[self.missionTeam])
			{
				if (p != self)
				{
					if (l)
						p drawOnCompass(self.teamId, self.origin, "friendly");
					else
						p removeFromRadar("map_friendly" + self.teamId);
				}
			}
			foreach (p as i : self.enemyCompass; @k)
			{
				self drawOnCompass(k[i], p, "enemy");
			}
			foreach (p as i : self.objCompass; @k)
			{
				self drawOnCompass(k[i], p, "obj");
			}
		}
		if (self.prestige == 5)
		{
			team = self.team;
			foreach (p as i : level.activePlayers[team]; 0; level.activeCount[team])
			{
				if (p != self)
				{
					p drawOnCompass(i, self.origin, "friendpublic");
				}
			}
			foreach (p as i : level.activePlayers[level.enemy[team]]; 0; level.activeCount[level.enemy[team]])
			{
				p drawOnCompass(i, self.origin, "enemypublic");
			}
		}
		/*if (level.public[self.team].size)
		{
			keys = getArrayKeys(level.public[self.team]);
			for (i = 0; i < keys.size; i++)
			{
				if (level.public[self.team][keys[i]] != self)
				{
					self drawOnCompass(keys[i], level.public[self.team][keys[i]].origin, "friendpublic");
				}
			}
		}
		if (level.public[level.enemy[self.team]].size)
		{
			keys = getArrayKeys(level.public[level.enemy[self.team]]);
			for (i = 0; i < keys.size; i++)
			{
				self drawOnCompass(keys[i], level.public[level.enemy[self.team]][keys[i]].origin, "enemypublic");
			}
		}*/
		// TODO: Kiosks
		wait 0.05;
	}
}

monitorFire()
{
	self endon("disconnect");
	self endon("endmission");

	while (true)
	{
		self.isFiring = false;
		self waittill("begin_firing");
		self.isFiring = true;

		if (!(level.perks["silencer"].id & self.weapons[self.wID[self getWeaponID(self.currentWeapon)]]["mod"]))
		{
			foreach (p as level.teams[self.enemyTeam])
			{
				p thread hidePlayer(self);
			}
		}
		/*if (!isDefined(level.silencerWeapons[self.currentWeapon]))
		{
			for (i = 0; i < level.teams[self.enemyTeam].size; i++)
			{
				level.teams[self.enemyTeam][i] thread hidePlayer(self);
			}
		}*/

		self waittill("end_firing");
	}
}

hidePlayer(enemy)
{
	self endon("disconnect");
	enemy endon("disconnect");
	enemy endon("begin_firing");

	// Always re-store teamId, because it can change
	//id = enemy.teamId;
	while (enemy.isFiring)
	{
		self.enemyCompass[enemy.teamId] = enemy.origin; // id
		wait 0.05;
		//id = enemy.teamId;
	}
	enemy delayHideCompass();
	if (isDefined(self.enemyCompass, enemy.teamId)) // - enemy.teamId
	{
		//id = enemy.teamId;
		self.enemyCompass[enemy.teamId] = undefined; // id
		self setClientDvar(
			"map_enemy" + enemy.teamId + "z", ""//, // id
			//"map_enemy" + id + "d", "" // id
		);
	}
}

delayHideCompass()
{
	self endon("disconnect");
	self endon("endmission");
	self endon("killed_player");

	wait 3;
}

drawOnCompass(id, origin, type)
{
	// dist = distance2D((self.origin[0], self.origin[1], 0), (origin[0], origin[1], 0)) / 80;

	// This way we don't have to divide by 80 and measure square root if the obj is farer than 45
	dist = distance2DSquared(self.origin[0], self.origin[1], origin[0], origin[1]);
	var = "map_" + type + id;
	if (dist <= 19360000) // 55
	{
		if (dist > 12960000) // 45
			dist = 3600; // 45
		else
			dist = sqrt(dist); // / 80

		if (!isDefined(self.radar[var]))
			self.radar[var] = true;

		// No arcus in menu, so we must calculate vectorToAngles here... (+ we can't query angles/origin with menu normally)
		self setClientDvars(
			var + "z", self.angles[1] - vectorToAngles(self.origin - origin)[1], // + 90
			var + "d", dist
		);
	}
	else
	{
		removeFromRadar(var);
	}
}

endMission(id, win, reason)
{
	// Stop everything related to this mission
	level notify("endmission" + id);

	m = level.missions[id];
	allCount = m.allCount;
	all = m.all;

	winner = m.team[win];
	w = level.teams[winner];
	loser = m.team[level.enemy[win]];
	l = level.teams[loser];
	wsize = w.size;
	lsize = l.size;

	// MVP
	mvp = w[0];
	mvpIndex = 0;
	mvpPoint = 0;

	// Merging winners and losers
	// Setting scoreboard titles
	winnerRating = 0;
	winnerScore = 0;
	winnerScores = [];
	foreach (p as i:w;;wsize)
	{
		if (reason == "TIED")
		{
			p playLocalSound("MissionLose");
			p setClientDvar("missionstatus", "TIED");
			p.info["mis_tied"]++;
			p setClientDvar("mis_tied", p.info["mis_tied"]);
			//p setSave("TIED", p.info["mis_tied"]);
		}
		else
		{
			p playLocalSound("MissionWin");
			p setClientDvars(
				"missionstatus", "WIN",
				"missionstatus_desc", "ENEMY_" + reason
			);
			p.info["mis_win"]++;
			p setClientDvar("mis_win", p.info["mis_win"]);
			//p setSave("WIN", p.info["mis_win"]);
			p queryThreat();
			p addRep(0.2); // 0.1

			if (p.info["mis_win"] == 100)
				p giveAchievement("MISSION");
			//else if (p.info["mis_win"] < 100)
				//p setClientDvar("achievement_mission_progress", p.info["mis_win"] + "/100");
		}

		// Scores
		winnerScores[i] = p getAward();
		println("^6[DEBUG] " + p.showname + "'s points: " + winnerScores[i]);
		if (winnerScores[i] > mvpPoint)
		{
			mvp = p;
			mvpPoint = winnerScores[i];
			mvpIndex = i;
		}
		winnerScore += winnerScores[i];
		winnerRating += p.rating;
		resetTimeout();
	}

	loserRating = 0;
	loserScore = 0;
	loserScores = [];
	foreach (p as i:l;;lsize)
	{
		p playLocalSound("MissionLose");
		if (reason == "TIED")
		{
			p setClientDvar("missionstatus", "TIED");
			p.info["mis_tied"]++;
			p setClientDvar("mis_tied", p.info["mis_tied"]);
			//p setSave("TIED", p.info["mis_tied"]);
		}
		else
		{
			p setClientDvars(
				"missionstatus", "LOSE",
				"missionstatus_desc", reason
			);
			p.info["mis_lose"]++;
			p setClientDvar("mis_lose", p.info["mis_lose"]);
			//p setSave("LOSE", p.info["mis_lose"]);
			p queryThreat();
			p addRep(-0.05);
		}

		// Scores
		loserScores[i] = p getAward();
		println("^6[DEBUG] " + p.showname + "'s points: " + loserScores[i]);
		if (loserScores[i] > mvpPoint)
		{
			mvp = p;
			mvpPoint = loserScores[i];
			mvpIndex = i;
		}
		loserScore += loserScores[i];
		loserRating += p.rating;
		resetTimeout();
	}

	/*if (mvp.premium)
		r = randomIntRange(1, 2701);
	else
		r = randomIntRange(1, 1801);

	if (mvp.info["money"] >= r)
	{
		mvp.mvp = r;
		mvp setClientDvar("mvp_price", r);
	}*/

	// Hack to prevent the first gameMessage to slide behind the scoreboard,
	// because stat() can be opened only after the giveStanging calls (which calls gameMessage)
	foreach (p as all; 0; +allCount)
	{
		p menuStatus(true);
	}

	// Manipulating scores based on the ratings and mission participations
	// Loser
	dif = winnerRating - loserRating;
	if (dif > 1000)
	{
		dif = 1000;
	}
	plus = 350 * wsize;
	foreach (p as i:l;;lsize)
	{
		loserScores[i] += (loserScores[i] / loserScore) * plus;
		println("^6[DEBUG] " + p.showname + "'s final: " + loserScores[i]);

		if (loserScores[i] > 2500)
			loserScores[i] = 2500;

		println("^6[DEBUG] " + p.showname + "'s give: " + int((loserScores[i] + dif) / 2));
		p giveStanding(int((loserScores[i] + dif) / 2));
		p giveMoney(int((loserScores[i] + dif * 2) / 2));
	}

	// Winner
	dif = loserRating - winnerRating;
	if (dif > 1000)
	{
		dif = 1000;
	}
	plus = 750 * lsize;
	foreach (p as i:w;;wsize)
	{
		winnerScores[i] += (winnerScores[i] / winnerScore) * plus;
		println("^6[DEBUG] " + p.showname + "'s final: " + winnerScores[i]);

		if (winnerScores[i] > 2500)
			winnerScores[i] = 2500;

		println("^6[DEBUG] " + p.showname + "'s give: " + int(winnerScores[i] + dif));
		p giveStanding(int(winnerScores[i] + dif));
		p giveMoney(int(winnerScores[i] + dif * 2));
	}

	// Removing teams
	abandonTeam(winner);

	if (loser > winner)
		loser--;

	abandonTeam(loser);

	// Groups
	groups = [];

	// Update stats
	foreach (p as all; 0; +allCount)
	{
		friend = 0;
		enemy = 0;

		if (p.team == mvp.team)
			p setClientDvar("mvp", mvpIndex);
		else
			p setClientDvar("mvp", mvpIndex + 8);

		foreach (q as all; 0; +allCount)
		{
			if (p.team == q.team)
			{
				p setClientDvars(
					"ui_friend_cash" + friend, "$" + q.stat["cash"] + "^3 + $" + q.stat["pcash"],
					"ui_friend_standing" + friend, q.stat["standing"] + "^3 + " + q.stat["pstanding"]
				);
				friend++;
			}
			else
			{
				p setClientDvars(
					"ui_enemy_cash" + enemy, "$" + q.stat["cash"] + "^3 + $" + q.stat["pcash"],
					"ui_enemy_standing" + enemy, q.stat["standing"] + "^3 + " + q.stat["pstanding"]
				);
				enemy++;
			}
		}
		if (isDefined(p.group) && !isDefined(groups[p.group]))
		{
			groups[p.group] = true;
		}
		//sql_push("UPDATE players SET money = " + self.info["money"] + ", standing = " + self.info["standing"] + ", rep = " + self.info["rep"] + ", mis_lose = " + self.info["mis_lose"] + ", mis_tied = " + self.info["mis_tied"] + ", mis_win = " + self.info["mis_win"] + " WHERE name = '" + p.showname + "'");
		//p saveStatus();
	}
	// We must use all the .stat variables in the previous loop
	foreach (p as all; 0; +allCount)
	{
		p quitTeam();

		// Find
		if (!level.tutorial)
		{
			if (p.premium)
				r = randomInt(200);
			else
				r = randomInt(300);

			if (r < 100)
			{
				p.item = false;
				while (!p.item)
				{
					if (r < 30)
					{
						// Money
						p.item = true;
						r = randomIntRange(1, 1000);
						p giveMoney(r);
						p setClientDvars(
							"found_prize", "cash",
							"found_key", "$" + r
						);
					}
					else if (r < 60)
					{
						// Ammo
						a = [];
						size = 0;
						foreach (w as j:level.ammos; 1; +level.ammoCount)
						{
							if (p.info["ammo_" +w.name] < w.max)
							{
								a[size] = j;
								size++;
							}
						}
						if (size)
						{
							p.item = true;

							// Get ammunition
							g = level.ammos[a[randomInt(size)]];

							r = randomIntRange(1, int(g.max / 10));
							if (p.info["ammo_" + g.name] + r > g.max)
							{
								r = g.max - p.info["ammo_" + g.name];
							}

							p.info["ammo_" + g.name] += r;
							p setClientDvars(
								"found_prize", "ammo_" + g.name,
								"found_key", r + " " + level.s["AMMO_" + g.title + "_" + p.lang]
							);
						}
						else
						{
							r = 0;
						}
					}
					else if (r < 88)
					{
						// Weapon
						a = [];
						size = 0;
						foreach (w as j:level.weaps; 1; +level.weaponCount)
						{
							if (w.group == "0" && p.rating >= w.rating && p.roleLevel[w.roleType] >= w.roleLevel)
							{
								a[size] = j;
								size++;
							}
						}
						if (size)
						{
							w = a[randomInt(size)];
							p.item = p maps\mp\gametypes\_menus::giveWeap(w, false);

							// If you would get a new weapon, when you already have the max amount of weapons, or you would get a grenade, which you already own, then fail. Sorry.
							if (p.item)
							{
								p setClientDvars(
									"found_prize", level.weaps[w].image,
									"found_key", level.weaps[w].name
								);
							}
						}

						if (!p.item)
							r = 30;
					}
					else if (r < 92)
					{
						// Rare weapon
						if (p.weapons.size < p.info["maxweapons"])
						{
							a = [];
							size = 0;
							foreach (w as j:level.weaps; 1; +level.weaponCount)
							{
								if (w.group == "1" && !isDefined(p.wID[j]))
								{
									a[size] = j;
									size++;
								}
							}
							if (size)
							{
								p.item = true;
								rid = a[randomInt(a.size)];
								w = level.weaps[rid];

								wid = p.weapons.size + 1;
								p.weapons[wid]["id"] = rid;
								p.weapons[wid]["type"] = w.type;
								p.weapons[wid]["time"] = 0;
								p.weapons[wid]["camo"] = 0;
								p.weapons[wid]["mod"] = w.mod;
								p.wID[rid] = wid;

								sql_exec("INSERT INTO weapons (name, weapon, mods) VALUES ('" + p.showname + "', " + rid + ", " + p.weapons[wid]["mod"] + ")");

								count = 1;
								for (j = 1; j < p.weapons.size; j++)
								{
									if (p.weapons[j]["type"] == p.weapons[wid]["type"])
									{
										count++;
									}
								}
								p setClientDvars(
									w.type + count, rid,
									"hasweapon" + rid, 1,
									"found_prize", w.image,
									"found_key", w.name
								);
							}
						}

						if (!p.item)
							r = 60;
					}
					else if (r < 94)
					{
						// Painting
						d = p.inv.size;
						if (p.info["maxinv"] > d)
						{
							p.item = true;
							c = randomInt(level.camoCount - 1) + 1; // We can't find the camo 'None'
							sql_exec("INSERT INTO inv (name, item, itemtype) VALUES ('" + p.showname + "', 'camo', " + c + ")");
							p.inv[d] = spawnStruct();
							p.inv[d].id = int(sql_query_first("SELECT COALESCE(MAX(invid), 0) FROM inv WHERE name = '" + p.showname + "'")); // TODO: Query last id with maybe sql_query_id()? Or make invid start from 0 for every user
							p.inv[d].item = "camo";
							p.inv[d].itemtype = c;
							p setClientDvars(
								"found_prize", "ui_camoskin_" + level.camos[c].img,
								"found_key", level.camos[c].name
							);
						}
						else
						{
							r = 88;
						}
					}
					else if (r < 96)
					{
						// Tool
						d = p.inv.size;
						if (p.info["maxinv"] > d)
						{
							p.item = true;
							c = randomInt(level.toolCount);
							e = level.tools[c].types[randomInt(level.tools[c].types.size)];
							sql_exec("INSERT INTO inv (name, item, itemtype) VALUES ('" + p.showname + "', '" + level.tools[c].name + "', " + e + ")");
							p.inv[d] = spawnStruct();
							p.inv[d].id = int(sql_query_first("SELECT COALESCE(MAX(invid), 0) FROM inv WHERE name = '" + p.showname + "'")); // TODO: Query last id with maybe sql_query_id()?
							p.inv[d].item = level.tools[c].name;
							p.inv[d].itemtype = e;
							p setClientDvars(
								"found_prize", "tool_" + level.tools[c].img,
								"found_key", level.s[level.tools[c].title + "_" + p.lang]
							);
						}
						else
						{
							r = 92; // No use checking painting this time
						}
					}
					else if (r < 98)
					{
						// Symbol
						rid = -1;
						if (p.info["symbols"])
						{
							g = [];
							size = 0;
							foreach (e as level.rareSymbols; 0; +level.rareSymbolCount)
							{
								if (!(level.symbols[e].value & p.info["symbols"]))
								{
									g[size] = e;
									size++;
								}
							}
							if (size)
							{
								rid = g[randomInt(size)];
							}
						}
						else
						{
							rid = level.rareSymbols[randomInt(level.rareSymbolCount)];
						}
						if (rid != -1)
						{
							p.item = true;
							p.info["symbols"] |= level.symbols[rid].value;
							p setClientDvars(
								"symbols", p.info["symbols"],
								"found_prize", "locked",
								"found_key", level.s["SYMBOL_" + p.lang] + " #" + rid
							);
						}
						else
						{
							r = 94;
						}
					}
					else // r == 98 || r == 99
					{
						// Hat
						rid = -1;
						if (p.info["hats"])
						{
							g = [];
							size = 0;
							foreach (e as j:level.hats; 1; +level.hatCount)
							{
								if (!e.price && !(e.bit & p.info["hats"]))
								{
									g[size] = j;
									size++;
								}
							}
							if (size)
							{
								rid = g[randomInt(size)];
							}
						}
						else
						{
							rid = randomIntRange(1, level.hatCount + 1);
						}
						if (rid != -1)
						{
							p.item = true;
							p.info["hats"] |= level.hats[rid].bit;
							p setClientDvars(
								"hasitem_hat_" + rid, "1",
								"found_prize", "locked",
								"found_key", "@APB_HAT_" + level.hats[rid].name + "_" + p.lang
							);
						}
						else
						{
							r = 96;
						}
					}
				}
			}
		}
		else if (!isDefined(p.isBot))
		{
			p thread waitAndRemoveBot();
			p thread showTutAfterStat();
		}
	}

	// Refresh every groups only one time
	foreach (g as getArrayKeys(groups))
	{
		refreshGroup(g); // key is needed here
	}

	if (isDefined(m.war))
	{
		cols = "";
		vals = "";
		all = level.missions[id].war["alliesteam"].size;
		foreach (e as i:m.war[win + "team"]; 0; +all)
		{
			cols += "winner" + i + ", ";
			vals += "'" + e + "', ";
		}
		foreach (e as i:m.war[level.enemy[win] + "team"]; 0; +all)
		{
			cols += "loser" + i + ", ";
			vals += "'" + e + "', ";
		}
		sql_exec("INSERT INTO wars (winner, loser, type, " + cols + "time, tied) VALUES ('" + m.war[win] + "', '" + m.war[level.enemy[win]] + "', " + all + ", " + vals + getRealTime() + ", " + (reason == "TIED") + ")");

		foreach (p as level.allActivePlayers; 0; +level.allActiveCount)
		{
			p thread showInfoLine(m.war[win] + " " + level.s["INFO_DEFEATED_" + p.lang] + " " + m.war[level.enemy[win]]);
		}
	}

	// End mission
	unsetArrayItemIndex(level.missions, id);
}

showTutAfterStat()
{
	self endon("disconnect");

	self waittill("boardoff");
	self.tut = 7;
	self setClientDvar("tutid", 7);
	self openMenu(game["menu_tutorial"]);
}

// Wait until the but quits the mission totally, and then remove him
waitAndRemoveBot()
{
	self endon("disconnect");

	wait 0.05;
	self removeBot();
}

quitTeam()
{
	self setClientDvars(
		"mission", false,
		"teamid", "",
		"line1", "",
		"line2", "",
		"counter1", "",
		"counter1text", "",
		"counter2", "",
		"counter2text", "",
		"leftinfo", "CHANGE_TO_READY"
	);
	self resetIcons();
	self createPins();

	// We don't remove self.teamId, as scoreboard still uses that
	self.stat = undefined;
	self.enemyCompass = undefined;
	self.objIcons = undefined;
	self.teamleader = undefined;
	self.missionId = undefined;
	self.objCompass = undefined;
	self.killTime = undefined;
	self.lastKiller = undefined;
	self.attackers = undefined;
	self.vip = undefined;
	self.clan = undefined;
	//self.dmg = undefined; // "Type undefined is not an int" - I want to make it undefined, bitch -.- / A kurva eget már ebbe...

	// self.group is handled in the caller functions
	if (!isDefined(self.group))
	{
		self setClientDvars(
			"name0", self.showname,
			"status0", "notready",
			"leader0", "",
			"leftoffset", 1
		);
		/*for (j = 1; j < 8; j++)
		{
			self setClientDvars(
				"name" + j, "",
				"leader" + j, "",
				"status" + j, ""
			);
		}*/
	}
	for (j = 0; j < 8; j++)
	{
		removeFromRadar("map_friendly" + j);
		removeFromRadar("map_enemy" + j);
		removeFromRadar("map_obj" + j);
		//self setClientDvar("team" + j, ""); // Team menu
	}
	blockmenu = false;

	/*if (isDefined(self.mvp))
	{
		self openMixMenu("mvp");
		blockmenu = true;
	}
	else */
	if (isDefined(self.item))
	{
		self openMixMenu("found");
		//blockmenu = true;
	}
	else
	{
		if (isDefined(self.invited))
		{
			p = self.invited;
			if (!isDefined(p.group) || (isDefined(p.groupleader) && level.groups[p.group].team.size < 4))
			{
				self maps\mp\gametypes\_menus::inviteHUD(p.showname + " " + level.s["INVITE_BODY_" + self.lang]);
				//self openMenu(game["menu_invite"]);
				//blockmenu = true;
			}
		}
		else if (isDefined(self.claninvited))
		{
			x = sql_query_first("SELECT clan FROM members WHERE name = '" + self.claninvited + "' AND rank != 0");
			if (isDefined(x))
			{
				self maps\mp\gametypes\_menus::inviteHUD(self.claninvited + " " + level.s["INVITE_BODY_CLAN_" + self.lang] + ": " + x);
				//self openMenu(game["menu_invite"]);
				//blockmenu = true;
			}
		}
		self closeMenu();
		self stat();
	}
	/*if (!blockmenu)
	{
		self closeMenu();
		self stat();
	}*/
	if (!isDefined(self.group) || (isDefined(self.groupleader) && level.groups[self.group].team.size < 4))
	{
		foreach (p as level.activePlayers[self.team]; 0; +level.activeCount[self.team])
		{
			if (isDefined(p.invited) && p.invited == self)
			{
				p maps\mp\gametypes\_menus::inviteHUD(self.showname + " " + level.s["INVITE_BODY_" + p.lang]);
				//p openMenu(game["menu_invite"]);
			}
		}
	}
	self notify("endmission");
}

removeFromRadar(id)
{
	if (isDefined(self.radar[id]))
	{
		self.radar[id] = undefined;
		self setClientDvar(
			id + "z", ""
			//id + "d", ""
		);
	}
}

getAward()
{
	// Scores
	medals = 0;
	foreach (e as self.stat["medals"]; @)
	{
		medals += e;
	}

	if (self.stat["arrests"] >= 0)
		arrests = self.stat["arrests"] * 1.5;
	else
		arrests = self.stat["arrests"] * -0.5;

	score = (arrests + self.stat["stuns"] * 0.25 + self.stat["kills"] + self.stat["assists"] * 0.5 + self.stat["deaths"] * -0.5 + self.stat["targets"] * 1.5 + medals * 0.1) * 25 + 1000 / level.teams[self.missionTeam].size + self.dmg / 10;

	// Already punished with the medal
	//if (self.stat["teamkills"])
		//score *= pow(0.85, self.stat["teamkills"]);

	return int(score);
}

playMusic()
{
	self endon("disconnect");
	self endon("stopmusic");

	self setClientDvar("time_delaymusic", getTime() - self.startTime);
	self playLocalSound("music" + self.playing);
	//max = leftTimeToString(level.music[self.playing]["time"], "noh shortm");
	self setClientDvars(
		"music_title", level.music[self.playing]["title"],
		//"music_time", "[0:00 / " + max + "]",
		"music_rate", level.music[self.playing]["time"],
		"music_playing", self.playing
	);
	/*for (i = 1; i <= level.music[self.playing]["time"]; i++)
	{
		wait 1;
		self setClientDvar("music_time", "[" + leftTimeToString(i, "noh shortm") + " / " + max + "]");
	}*/
	wait level.music[self.playing]["time"];
	if (self.musicstatus == "one")
	{
		self clearMusic();
	}
	else
	{
		if (self.musicstatus == "all")
		{
			if (self.playing == 19)
				self.playing = 0;
			else
				self.playing++;
		}
		//self clientExec("setdvartotime music_start");
		self thread playMusic();
	}
}

clearMusic()
{
	self.playing = undefined;
	self setClientDvars(
		"music_title", "---",
		//"music_time", "[0:00 / 0:00]",
		//"music_rate", 0,
		"music_playing", ""
	);
}

/*pow(num, exp)
{
	if (!exp)
		return 1;

	e = num;
	for (i = 1; i < exp; i++)
	{
		e *= num;
	}
	return e;
}*/

stat()
{
	self menuStatus(true);
	self setClientDvar("playerid", self.teamId);
	self playerDetails(self.clientid);
	self openMenu(game["menu_stat"]);
}

/*mergeArrays(array1, array2)
{
	for (i = 0; i < array2.size; i++)
	{
		array1[array1.size + i] = array2[i];
	}
	return array1;
}*/

// Maybe it can use threat... in the future
backup()
{
	missionTeam = self.missionTeam;
	enemyTeam = self.enemyTeam;
	missionId = self.missionId;
	m = level.missions[missionId];
	ta = level.teams[missionTeam];
	ea = level.teams[enemyTeam];

	level endon("endbackup" + missionTeam);

	friend = self.team;
	//enemy = level.enemy[self.team];

	level.missions[missionId].backup = true; // Modified
	self setClientDvar("leftinfo", "SEARCHING");

	// All players
	foreach (p as m.all; 0; +m.allCount)
	{
		p thread mainLine(self.showname + " " + level.s["REQUESTED_BACKUP_" + p.lang]);
	}

	while (true)
	{
		wait 1;
		c = level.readyPlayers[friend].size;
		g = level.readyGroups[friend].size;
		t = ta.size;
		if (c || (g && t < 7))
		{
			e = ea.size;
			ga = level.readyGroups[friend];
			pa = level.readyPlayers[friend];
			if (!c)
			{
				blockbackup = true;
				if (t < e)
				{
					for (i = 0; i < g && blockbackup; i++)
					{
						if (level.groups[ga[i]].team.size == 2)
						{
							blockbackup = false;
						}
					}
				}
				if (blockbackup)
				{
					continue;
				}
			}
			if (c) // Due to 'else'
			{
				dist = distanceSquared(self.origin, pa[0].origin);
				distid = 0;
				for (i = 1; i < c; i++)
				{
					d = distanceSquared(self.origin, pa[i].origin);
					if (d < dist)
					{
						dist = d;
						distid = i;
					}
				}
				p = pa[distid];

				if (p.ready)
					p unreadyPlayer();

				p setClientDvar("leftinfo", "");
				p.missionTeam = missionTeam;
				p.enemyTeam = enemyTeam;
				p.teamId = t;
				p setClanStat();
				newplayers[0] = p;

				// Alert
				leader = "";
				foreach (u as ea;;+e)
				{
					u thread showAlert(p.showname + " " + level.s["JOINED_AGAINST_" + u.lang] + ".", "BackupNotify");

					if (isDefined(u.teamleader))
						leader = u.showname;
				}
				foreach (u as m.all; 0; +m.allCount)
				{
					u thread showAlert(p.showname + " " + level.s["JOINED_YOUR_TEAM_" + u.lang] + ".", "BackupNotify");
					u createPlayerInfo(newplayers);
				}
				p thread showAlert(e + " " + level.s["ENEMIES_JOINED_" + p.lang] + " " + leader, "BackupNotify");

				// Placed points
				if (isDefined(level.placedPoints[missionTeam]))
				{
					foreach (e as level.placedPoints[missionTeam];;+)
					{
						e showToPlayer(p);
						e maps\mp\gametypes\_menus::newPlacedHud(p);
					}
				}

				level.teams[missionTeam][p.teamId] = p;
				level.missions[missionId].all[m.allCount] = p;
				level.missions[missionId].allCount++;
				p joinMission(missionId);
				p [[level.missions[missionId].backupFunc]]();

				self addBackup();
			}
			else
			{
				g = 0;
				ming = 0;
				foreach (q as i:ga;;+)
				{
					z = level.groups[q].team;
					if (z.size == 2)
					{
						p1 = distanceSquared(self.origin, z[0].origin);
						p2 = distanceSquared(self.origin, z[1].origin);
						if (!g)
						{
							g = i;
							if (p1 < p2)
								ming = p1;
							else
								ming = p2;
						}
						else
						{
							if (p1 < p2)
							{
								if (p1 < ming)
								{
									g = i;
									ming = p1;
								}
							}
							else
							{
								if (p2 < ming)
								{
									g = i;
									ming = p2;
								}
							}
						}
					}
				}
				newplayers = level.groups[ga[g]].team;
				unsetArrayItemIndex(level.readyGroups[friend], g);
				// Alert
				leader = "";
				foreach (u as ea;;+e)
				{
					u thread showAlert(newplayers[0].showname + " " + level.s["AND_" + u.lang] + newplayers[1].showname + " " + level.s["JOINED_AGAINST_" + u.lang] + ".", "BackupNotify");

					if (isDefined(u.teamleader))
						leader = u.showname;
				}
				foreach (u as m.all; 0; +m.allCount)
				{
					u thread showAlert(newplayers[0].showname + " " + level.s["AND_" + u.lang] + newplayers[1].showname + " " + level.s["JOINED_YOUR_TEAM_" + u.lang] + ".", "BackupNotify");
					u createPlayerInfo(newplayers);
				}

				foreach (p as newplayers; 0; 2)
				{
					//p = newplayers[i];
					p setClientDvar("leftinfo", "");
					p.missionTeam = missionTeam;
					p.enemyTeam = enemyTeam;
					p.teamId = level.teams[missionTeam].size;
					p thread showAlert(level.teams[enemyTeam].size + " " + level.s["ENEMIES_JOINED_" + p.lang] + " " + leader, "BackupNotify");
					p setClanStat();
					ta[p.teamId] = p;
					level.missions[missionId].all[m.allCount] = p;
					level.missions[missionId].allCount++;
				}
				// We need a new loop, because it needs the players array,
				// which is completed after the end of the previous loop
				// + due to setClanStat()
				foreach (p as newplayers; 0; 2)
				{
					p joinMission(missionId);
					p [[level.missions[missionId].backupFunc]]();
				}

				self addBackup();
			}
			refreshTeam(missionTeam);

			// Using refreshTeam(self.enemyTeam) would be a waste
			foreach (p as newplayers;;+)
			{
				p setClientDvar("ui_enemy_count", e);
				foreach (q as j:ea;;+e)
				{
					/*if (j < e)
					{*/
						//q = ea[j];
						p setClientDvars(
							"ui_enemy_name" + j, q.showname,
							"ui_enemy_kills" + j, q.stat["kills"] + "^8 + " + q.stat["assists"],
							"ui_enemy_arrests" + j, q.stat["arrests"],
							"ui_enemy_deaths" + j, q.stat["deaths"],
							"ui_enemy_targets" + j, q.stat["targets"],
							"ui_enemy_medals" + j, q.stat["medals"].size,
							"ui_enemy_cash" + j, "$" + q.stat["cash"] + "^3 + $" + q.stat["pcash"],
							"ui_enemy_standing" + j, q.stat["standing"] + "^3 + " + q.stat["pstanding"],
							"ui_enemy_icon" + j, level.ranks[q.rating]["id"] + "_" + q.team,
							"ui_enemy_threat" + j, q.threat
						);
					/*}
					else
					{
						p setClientDvars(
							"ui_enemy_name" + j, "",
							"ui_enemy_kills" + j, "",
							"ui_enemy_arrests" + j, "",
							"ui_enemy_deaths" + j, "",
							"ui_enemy_targets" + j, "",
							"ui_enemy_medals" + j, "",
							"ui_enemy_cash" + j, "",
							"ui_enemy_standing" + j, "",
							"ui_enemy_icon" + j, "",
							"ui_enemy_threat" + j, "",
							"map_enemy" + j + "z", "",
							"map_enemy" + j + "d", ""
						);
					}*/
				}
			}
			return;
		}
	}
}

addBackup()
{
	self.info["backupcalled"]++;
	self setClientDvar("backupcalled", self.info["backupcalled"]);
	//self setSave("BACKUP", self.info["backupcalled"]);

	if (self.info["backupcalled"] == 100)
		self giveAchievement("BACKUP");
	//else if (self.info["backupcalled"] < 100)
		//self setClientDvar("achievement_backup_progress", self.info["backupcalled"] + "/100");

	//sql_push("UPDATE players SET backupcalled = " + self.info["backupcalled"] + " WHERE name = '" + self.showname + "'");
	//self saveStatus();
}

/*getModList(id)
{
	modList = [];

	modid = 0;
	if (self.weapons[self.wID[id]]["mod"])
	{
		for (i = 0; i < level.perkCount; i++)
		{
			if (level.perks[level.perkID[i]].id & self.weapons[self.wID[id]]["mod"])
			{
				modList[modid] = level.perks[level.perkID[i]].name;
				modid++;
			}
		}
	}
	for (i = 0; modid < 3; i++)
	{
		if (i < level.weaps[id].modplace)
			modList[modid] = "vacant";
		else
			modList[modid] = "empty";

		modid++;
	}

	return modList;
}*/

playerDetails(p)
{
	s = self.playerStats[p];
	//modList = getModList(s.primary);
	//self maps\mp\gametypes\_menus::getWeapPerks(s.primary, "ui_selected_weapperk"); // Not his weap data is needed
	self setClientDvars(
		"ui_selected_name", s.name,
		"ui_selected_icon", s.rank,
		"ui_selected_threat", s.threat,
		"ui_selected_rating", maps\mp\gametypes\_rank::padRating(s.rating),
		"ui_selected_weapon", tableLookup("mp/weaponTable.csv", 0, s.primary, 2),
		"ui_selected_weapon_icon", tableLookup("mp/weaponTable.csv", 0, s.primary, 3),
		"ui_selected_weapon_width", tableLookup("mp/weaponTable.csv", 0, s.primary, 4),
		"ui_selected_weapon_height", tableLookup("mp/weaponTable.csv", 0, s.primary, 5),
		"ui_selected_weapperk1", s.primaryperks[0],
		"ui_selected_weapperk2", s.primaryperks[1],
		"ui_selected_weapperk3", s.primaryperks[2],
		//"ui_selected_weapperk1", modList[0],
		//"ui_selected_weapperk2", modList[1],
		//"ui_selected_weapperk3", modList[2],
		"ui_selected_perk1", s.perk1,
		"ui_selected_perk2", s.perk2,
		"ui_selected_perk3", s.perk3,
		"ui_selected_symbol", s.symbol,
		"ui_selected_team", s.team
	);
	if (isDefined(s.clan))
	{
		self setClientDvars(
			"ui_selected_clan", s.clan,
			"ui_selected_clan_crank", s.clan_crank,
			"ui_selected_clan_mrank", s.clan_mrank,
			"ui_selected_clan_threat", s.clan_threat
		);
	}
	else
	{
		self setClientDvar("ui_selected_clan", "");
	}

	for (i = 0; i < 13; i++)
	{
		if (i < s.medals.size)
			self setClientDvar("ui_selected_medal" + (i + 1), s.medals[i]);
		else
			self setClientDvar("ui_selected_medal" + (i + 1), "");
	}
}

joinGroup(gid)
{
	t = level.groups[gid].team;
	size = t.size;
	foreach (g as t; 0; +size)
	{
		g newMessage("^2" + self.showname + " " + level.s["JOINED_IN_GROUP_" + g.lang]);
	}

	level.groups[gid].team[size] = self;
	self.group = gid;
	self.groupId = size;

	if (self.ready)
		self unreadyPlayer();

	refreshGroup(gid);
}

abandonTeam(id)
{
	level notify("endbackup" + id);

	// Maybe it could be done with level.teams and level.missions without level.allActivePlayers, but not now...
	lastTeam = level.teams.size - 1;
	foreach (p as level.allActivePlayers; 0; +level.allActiveCount)
	{
		if (!isDefined(p.leaving) && isDefined(p.missionTeam))
		{
			if (p.missionTeam == id)
				p.missionTeam = undefined;
			else if (p.missionTeam == lastTeam)
				p.missionTeam = id;
			else if (p.enemyTeam == id)
				p.enemyTeam = undefined;
			else if (p.enemyTeam == lastTeam)
				p.enemyTeam = id;
		}
	}
	size = level.missions.size;
	for (i = 0; i < size; i++)
	{
		if (i != id)
		{
			if (level.missions[i].team["allies"] == lastTeam)
			{
				level.missions[i].team["allies"] = id;
				break;
			}
			else if (level.missions[i].team["axis"] == lastTeam)
			{
				level.missions[i].team["axis"] = id;
				break;
			}
		}
	}
	unsetArrayItemIndex(level.teams, id);
}

target(count, item)
{
	self.stat["targets"]++;
	self refreshStat("targets");
	money = self giveMoney(30 * count);
	standing = self giveStanding(12 * count);
	self newMessage(level.s["TARGET_REWARD_" + self.lang] + ": " + money.display + ", " + standing + " " + level.s["STANDING_" + self.lang]);

	if (isDefined(item))
	{
		self.info["delivereditems"]++;
		self setClientDvar("delivereditems", self.info["delivereditems"]);
		if (self.info["delivereditems"] == 100)
			self giveAchievement("ITEMS");
		//else if (self.info["delivereditems"] < 100)
			//self setClientDvar("achievement_mission_progress", self.info["delivereditems"] + "/100");
	}

	//sql_push("UPDATE players SET delivereditems = " + self.info["delivereditems"] + ", money = " + self.info["money"] + ", standing = " + self.info["standing"] + " WHERE name = '" + self.showname + "'");
	//self saveStatus();
}

timeLimit(id, max, func)
{
	level endon("endmission" + id);

	time = max;
	while (time)
	{
		wait 1;
		time--;
		//if (time) // Commented out, because we want to have 00:00 too
		//{
			level.missions[id].timeleft = leftTimeToString(time, "noh");
			m = level.missions[id];
			all = m.all;
			allCount = m.allCount;

			foreach (p as all; 0; +allCount)
			{
				p setClientDvar("timeleft", m.timeLeft);
			}
			if (time == 60)
			{
				foreach (p as all; 0; +allCount)
				{
					p thread mainLine(level.s["ONE_MIN_REMAINING_" + p.lang] + "!", "", "OneMinuteRemaining");
				}
			}
			if (isDefined(m.countFuseTime))
			{
				level.missions[id].fuseTime--;

				t = leftTimeToString(m.fuseTime, "noh shortm");
				if (m.fuseTime)
				{
					foreach (p as all; 0; +allCount)
					{
						p setClientDvar("counter1", t);
					}
				}
				else
				{
					level notify("endmission" + id, m.attackTeam);
				}
			}
		//}
	}
	thread [[func]](id);
}

leftTimeToString(left, type)
{
	h = 0; // Must be declared
	s = 0; // Must be declared

	if (!isDefined(type))
		type = "";

	noh = isSubStr(type, "noh");

	if (noh)
	{
		m = int(left / 60);
		s = left % 60;
	}
	else
	{
		h = int(left / 3600);
		m = int((left - h * 3600) / 60);
	}

	if (!isSubStr(type, "shortm") && m < 10)
		m = "0" + m;

	if (isSubStr(type, "nos"))
	{
		if (h < 10)
			h = "0" + h;

		return h + ":" + m;
	}
	else
	{
		if (s < 10)
			s = "0" + s;

		if (noh)
			return m + ":" + s;
		else
			return h + ":" + m + ":" + s;
	}
}

startFlashing()
{
	level endon("endmission" + self.missionId);

	while (self.taker != self.owner)
	{
		self flashing();
	}
}

startSingleFlashing()
{
	level endon("endmission" + self.missionId);

	while (isDefined(self.taker) || (isDefined(self.takers) && self.takers.size))
	{
		self flashing();
	}
}

flashing()
{
	id = self.missionId;

	level endon("endmission" + id);
	self endon("captured");

	// Re-gain players
	foreach (p as level.teams[level.missions[id].team["allies"]];;+)
	{
		p thread flash(self);
	}
	foreach (p as level.teams[level.missions[id].team["axis"]];;+)
	{
		p thread flash(self);
	}

	id = undefined;
	wait 1.5;
}

flash(point)
{
	self endon("disconnect");
	level endon("endmission" + point.missionId);

	&icon = self.objIcons[point.id];

	//point = undefined; // Clear var

	icon fadeOverTime(0.75);
	icon.alpha = 0.15;
	wait 0.75;

	// Condition is needed for singleFlashing
	if (isDefined(icon))
	{
		icon fadeOverTime(0.75);
		icon.alpha = 1;
		wait 0.75;
	}
}

// Resupply
giveSupplier()
{
	if (self.perk3 == "supplier" && !self hasWeapon(level.fieldSupplier))
	{
		// 4 minutes
		if (!isDefined(self.lastSupplier) || self.lastSupplier + 240000 <= getTime())
		{
			self giveWeapon(level.fieldSupplier);
			self setActionSlot(3, "weapon", level.fieldSupplier);
		}
		else
		{
			self thread waitAndGiveSupplier(int((self.lastSupplier + 240000 - getTime()) / 1000 + 1));
		}
	}
}
waitAndGiveSupplier(time)
{
	self endon("disconnect");
	self notify("waitsupply");
	self endon("waitsupply");

	for (i = time; i; i--)
	{
		if (i > 180)
			self setClientDvar("supplytime", 4 + level.s["MIN_" + self.lang]);
		else if (i > 120)
			self setClientDvar("supplytime", 3 + level.s["MIN_" + self.lang]);
		else if (i > 60)
			self setClientDvar("supplytime", 2 + level.s["MIN_" + self.lang]);
		else
			self setClientDvar("supplytime", i);

		wait 1;
	}
	self setClientDvar("supplytime", "");
	self giveSupplier();
}
takeSupplier()
{
	self notify("waitsupply");
	self takeWeapon(level.fieldSupplier);
	self setActionSlot(3, "");
	self setClientDvar("supplytime", "");
}
checkResupply(trig)
{
	if (!isDefined(self.supply))
	{
		if (isDefined(self.perks["extraammo"]))
		{
			primaryAll = weaponMaxAmmo(self.primaryWeapon);
			secondaryAll = weaponMaxAmmo(self.secondaryWeapon);
		}
		else
		{
			primaryAll = weaponStartAmmo(self.primaryWeapon);
			secondaryAll = weaponStartAmmo(self.secondaryWeapon);
		}
		type = [];
		cur = self getWeaponAmmoClip(self.primaryWeapon) + self getWeaponAmmoStock(self.primaryWeapon);
		if (cur != primaryAll && cur < self.info["ammo_" + level.ammo[self.primaryWeapon]])
			type["primary"] = true;
		cur = self getWeaponAmmoClip(self.secondaryWeapon) + self getWeaponAmmoStock(self.secondaryWeapon);
		if (cur != secondaryAll && cur < self.info["ammo_" + level.ammo[self.secondaryWeapon]])
			type["secondary"] = true;
		cur = self getWeaponAmmoClip(self.offhandWeapon);
		if (cur != weaponClipSize(self.offhandWeapon) && cur < self.info["ammo_" + level.ammo[self.offhandWeapon]])
			type["offhand"] = true;

		if (type.size)
		{
			self maps\mp\gametypes\apb::resupply(type, trig);
		}
	}
}
resupply(type, trig)
{
	if (!isDefined(self.supply))
	{
		self.supply = type;
		self newLoadBar();
		self thread supply(getArrayKeys(type)[0], trig);
	}
}
supply(type, trig)
{
	self endon("disconnect");

	wpn = "";
	//wpnid = 0;
	switch (type)
	{
		case "primary":
			wpn = self.primaryWeapon;
			//wpnid = self.info["prime"];
		break;
		case "secondary":
			wpn = self.secondaryWeapon;
			//wpnid = self.info["secondary"];
		break;
		case "offhand":
			wpn = self.offhandWeapon;
			//wpnid = self.info["offhand"];
		break;
	}

	ownAmmo = self.info["ammo_" + level.ammo[wpn]];
	exit = "";
	if (ownAmmo)
	{
		self.loadbar setShader("white", 0, 9);
		offhand = type == "offhand";

		if (!offhand && isDefined(self.perks["extraammo"]))
			maxAmmo = weaponMaxAmmo(wpn);
		else
			maxAmmo = weaponStartAmmo(wpn);

		if (ownAmmo < maxAmmo)
			maxAmmo = ownAmmo;

		clipSize = weaponClipSize(wpn);

		//if (!offhand) // Cannot be used because we will get undefined variable error by the preprocessor for stockSize
		stockSize = maxAmmo - clipSize;

		while (exit == "")
		{
			if (isDefined(trig) && self isTouching(trig) && self.sessionstate == "playing")
			{
				newwpn = "";
				switch (type)
				{
					case "primary":
						newwpn = self.primaryWeapon;
					break;
					case "secondary":
						newwpn = self.secondaryWeapon;
					break;
					case "offhand":
						newwpn = self.offhandWeapon;
					break;
				}
				if (newwpn == wpn)
				{
					wait 1;
					self playLocalSound("LoadBeep");
					if (offhand)
					{
						ammo = self getWeaponAmmoClip(wpn) + 1;
						self setWeaponAmmoClip(wpn, ammo);

						if (ammo == maxAmmo)
							exit = "ok";

						self.loadbar setShader("white", int((ammo / maxAmmo) * 100), 9);
						self setClientDvar("weapinfo_offhand", ammo);
					}
					else if (stockSize <= 0)
					{
						if (type == "primary" && level.weaps[self.info["prime"]].image == "rotated_m16") // M16
							self setWeaponAmmoClip(wpn, maxAmmo - maxAmmo % 3);
						else
							self setWeaponAmmoClip(wpn, maxAmmo);

						self.loadbar setShader("white", 100, 9);
						exit = "ok";
					}
					else
					{
						curClip = self getWeaponAmmoClip(wpn);
						curStock = self getWeaponAmmoStock(wpn);
						left = stockSize - curStock;
						if (!left)
						{
							exit = "ok";
							self setWeaponAmmoClip(wpn, clipSize);
							newClip = clipSize;
							newStock = curStock;
						}
						else
						{
							if (left <= clipSize)
							{
								if (curClip == clipSize)
									exit = "ok";

								newStock = stockSize;
							}
							else
							{
								newStock = curStock + clipSize;
							}

							if (type == "primary" && level.weaps[self.info["prime"]].image == "rotated_m16") // M16
								self setWeaponAmmoStock(wpn, newStock - newStock % 3);
							else
								self setWeaponAmmoStock(wpn, newStock);

							newClip = curClip;
						}
						self.loadbar setShader("white", int(((newStock + newClip) / maxAmmo) * 100), 9);
					}
				}
				else
				{
					exit = "newweapon";
				}
			}
			else
			{
				exit = "break";
			}
		}
	}
	if (exit == "newweapon")
	{
		self.supply[type] = undefined;
		self thread supply(type, trig);
	}
	else if (exit == "break")
	{
		self killLoadBar();
		self.supply = undefined;
	}
	else if (isDefined(self.supply) && self.supply.size > 1)
	{
		self.supply[type] = undefined;
		self thread supply(getArrayKeys(self.supply)[0], trig);
	}
	else
	{
		wait 1;
		self killLoadBar();
		self.supply = undefined;
		self playLocalSound("LoadReady");
	}
}

destroyObject(id)
{
	self.objIcons[id] destroy();
	self.objIcons[id] = undefined;
	self.objCompass[id] = undefined;
	self.radar["map_obj" + id] = undefined;
	self setClientDvar("map_obj" + id + "z", "");
}

averagePos(p)
{
	origin = (0, 0, 0);

	s = p.size;
	foreach (q as p;;+s)
	{
		origin += q.origin;
	}

	return origin / s;
}

// Bomb handles
endPlant()
{
	self.curTime = undefined;
	if (isDefined(self.hasBomb))
	{
		self.hasBomb = undefined;
		self detach("prop_suitcase_bomb", "tag_inhand");
	}
	self notify("nobomb");
	self killLoadBar();
	self unLink();
	self thread takeBomb();
	self switchToWeapon(self.primaryWeapon);
}

giveBomb(point)
{
	self notify("nobomb");
	level endon("endmission" + self.missionId);
	self endon("nobomb");
	self endon("disconnect");

	self loadBar(0, self.missionId);
	self giveWeapon(level.bomb);
	self switchToWeapon(level.bomb);
	self linkTo(point);

	wait 1.3;

	self attach("prop_suitcase_bomb", "tag_inhand", true);
	self.hasBomb = true;
}

takeBomb()
{
	self endon("disconnect");
	self endon("nobomb");

	while (self.currentWeapon == level.bomb && !self.throwingGrenade)
		wait 0.05;

	self takeWeapon(level.bomb);
}

overtimeMessage(id)
{
	// Collect all players
	/*all = level.teams[level.missions[id].team["allies"]];
	for (i = 0; i < level.teams[level.missions[id].team["axis"]].size; i++)
	{
		all[all.size] = level.teams[level.missions[id].team["axis"]][i];
	}*/

	// Notification
	foreach (p as level.missions[id].all; 0; +level.missions[id].allCount)
	{
		p thread boldLine(level.s["OVERTIME_" + p.lang] + "!", "Overtime");
	}
}

getRespawnData()
{
	// Objects and middle point
	a = (0, 0, 0);
	q = [];
	x = 0;
	id = self.missionId;
	if (isDefined(level.missions[id].obj))
	{
		foreach (k as j:level.missions[id].obj; @key; +)
		{
			if (isDefined(k[self.team]))
			{
				a += k["pos"].origin;
				self setClientDvars(
					"respawn_obj" + x + "_x", k["pos"].origin[0],
					"respawn_obj" + x + "_y", k["pos"].origin[1],
					"respawn_obj" + x + "_type", k[self.team]
				);
				q[x] = key[j];
				x++;
			}
		}
	}

	// Get spawnpoints
	self.respawnData = [];
	y = 0;
	if (x)
	{
		a /= x;

		foreach (s as level.spawns;;+)
		{
			allow = false;
			foreach (e as q; 0; +x)
			{
				d = distance2DSquared(
					s.origin[0], s.origin[1],
					level.missions[id].obj[e]["pos"].origin[0], level.missions[id].obj[e]["pos"].origin[1]
				);

				if (d < 9000000) // d < 3000
				{
					allow = false;
					break;
				}

				if (!allow && d < 25000000) // d < 5000
					allow = true;
			}
			if (allow)
			{
				self setClientDvars(
					"respawn_point" + y + "_x", s.origin[0],
					"respawn_point" + y + "_y", s.origin[1]
				);
				self.respawnData[y] = s;
				y++;
			}
		}
	}

	// No optimal points
	if (!y)
	{
		foreach (s as level.spawns;;+)
		{
			if (distance2DSquared(s.origin[0], s.origin[1], self.origin[0], self.origin[1]) < 9000000) // < 3000
			{
				self setClientDvars(
					"respawn_point" + y + "_x", s.origin[0],
					"respawn_point" + y + "_y", s.origin[1]
				);
				self.respawnData[y] = s;
				y++;
			}
		}
	}

	// Clear objects and spawnpoints
	/*for (i = q.size; i < 10; i++)
	{
		self setClientDvars(
			"respawn_obj" + i + "_x", "",
			"respawn_obj" + i + "_y", ""
		);
	}
	for (i = self.respawnData.size; i < 10; i++)
	{
		self setClientDvars(
			"respawn_point" + i + "_x", "",
			"respawn_point" + i + "_y", ""
		);
	}*/

	self setClientDvars(
		"respawn_x", a[0],
		"respawn_y", a[1],
		"respawn_objs", x,
		"respawn_points", y
	);
}

updateRespawnMap(id)
{
	foreach (p as level.missions[id].all; 0; +level.missions[id].allCount)
	{
		if (isDefined(p.respawnData))
		{
			p.spawn = undefined;
			p getRespawnData();

			// Reopen
			p closeMenu(game["menu_map"]);
			p openMenu(game["menu_map"]);
		}
	}
}

//-----------------------------------/
// DELIVER                           /
//-----------------------------------/
mission_deliver(id)
{
	// Generate attackers and defenders
	if (randomInt(2))
		level.missions[id].attackTeam = "allies";
	else
		level.missions[id].attackTeam = "axis";

	m = level.missions[id]; // Pointer for reading
	level.missions[id].defendTeam = level.enemy[m.attackTeam];

	// Get attackers and defenders
	att = level.teams[m.team[m.attackTeam]];
	def = level.teams[m.team[m.defendTeam]];

	// Get the most optimal point
	attOrigin = averagePos(att);
	defOrigin = averagePos(def);
	pnt = level.pickupPoints[0];
	dis = -1;
	foreach (e as level.pickupPoints;;+)
	{
		if (!isDefined(e.occupied))
		{
			defDist = distanceSquared(defOrigin, e.origin);
			attDist = distanceSquared(attOrigin, e.origin);
			newDis = abs(defDist - attDist);
			if (dis == -1 || newDis < dis)
			{
				pnt = e;
				dis = newDis;
			}
		}
	}

	// No more free pick-up points
	// It must be impossible on a completed map
	if (dis == -1)
	{
		level.missions[id].currentStage--;
		thread newObj(id);
		return;
	}

	pnt.occupied = true;
	pnt.id = 0; // Needed for showAll()
	pnt.missionId = id;
	pnt.takers = [];
	pnt thread bePickupPoint();
	level.missions[id].obj[0]["pos"] = pnt;
	level.missions[id].obj[0][m.defendTeam] = "defend";
	level.missions[id].obj[0][m.attackTeam] = "capture";
	items = pnt.items;
	itemc = items.size;
	foreach (e as i:items;;+itemc)
	{
		e.id = i + 1;
		e.missionId = id;
		e thread bePickupItem();
		level.missions[id].obj[e.id]["pos"] = e;
		level.missions[id].obj[e.id][m.attackTeam] = "pickup";
	}

	// Time
	level.missions[id].maxTime = 120 * itemc;
	level.missions[id].captureTime = 5;
	timeString = leftTimeToString(m.maxTime, "noh");

	// All players
	foreach (p as m.all; 0; +m.allCount)
	{
		p.objects = 0;
		p.objIcons = [];
		p setClientDvars(
			"counter1", "0/" + itemc,
			"counter1text", "DELIVERED_ITEMS",
			"timeleft", timeString,
			"mission_title", "DISPATCH",
			"mission_desc", "PICKUP"
		);
	}

	// Show points and items
	foreach (p as att;;+)
	{
		p objOnCompass(0, pnt.origin, "drop");
		pnt thread showAll("enemy", p);

		foreach (e as j:items; 0; +itemc)
		{
			p objOnCompass(j + 1, e.origin, "pickup");
		}
	}
	foreach (p as def;;+)
	{
		p objOnCompass(0, pnt.origin, "defend");
		pnt thread showAll("friend", p);
	}

	point[0] = pnt; // We have to make an array from it for kick
	level.missions[id].allItems = items.size;
	level.missions[id].delivered = 0;
	level.missions[id].backupFunc = ::mission_deliver_backup;
	level.missions[id].giveupFunc = ::mission_deliver_giveup;
	level.missions[id].timeleft = timeString; // For backup
	level.missions[id].points = point; // For kick
	level.missions[id].point = pnt; // For backup (too)
	level.missions[id].items = items;
	thread timeLimit(id, m.maxTime, ::mission_deliver_timelimit);

	updateRespawnMap(id);

	// Save memory by freeing every variable in this function
	thread mission_deliver_end(id);
}

mission_deliver_end(id)
{
	level waittill("endmission" + id, winner, giveup); // attack or defend

	level.missions[id].point.occupied = undefined;
	if (level.missions[id].point.takers.size) // With overtime I think it's impossible... but better keep it here
	{
		foreach (p as level.missions[id].point.takers; @; +)
		{
			p killLoadBar();
		}
	}
	level.missions[id].point.takers = undefined;
	level.missions[id].point.id = undefined;
	level.missions[id].point.missionId = undefined;
	level.missions[id].point hideAll();

	// Reset pick-up objects
	foreach (e as level.missions[id].items;;+)
	{
		if (!isDefined(e.taken))
		{
			e.obj delete();
			e.trigger delete();
		}
		e.id = undefined;
		e.missionId = undefined;
		e.taken = undefined;
		e.put = undefined;
	}

	// Re-get attackers and defenders
	foreach (p as level.missions[id].all; 0; +level.missions[id].allCount)
	{
		p.objects = undefined;
		p setClientDvar("items", 0);
	}

	if (isDefined(giveup))
		endMission(id, winner, "GIVEUP");
	else if (winner == "defend")
		endMission(id, level.missions[id].defendTeam, "COMPLETE");
	else
		thread newObj(id);
}

mission_deliver_giveup(id, team)
{
	level notify("endmission" + id, team, true);
}

mission_deliver_backup()
{
	friend = self.team;
	enemy = level.enemy[self.team];
	m = level.missions[self.missionId];

	self.objects = 0;
	self.objIcons = [];
	if (self.team == m.defendTeam)
	{
		m.point thread showAll("friend", self);
		self objOnCompass(0, m.point.origin, "defend");
	}
	else
	{
		m.point thread showAll("enemy", self);
		self objOnCompass(0, m.point.origin, "capture");
		foreach (e as j:m.items;;+)
		{
			if (!isDefined(e.put))
			{
				if (isDefined(e.taken))
					self newMissionPoint("follow" + e.id, e.taken, "obj");
				else
					self objOnCompass(j + 1, e.origin, "pickup");
			}
		}
	}
	self setClientDvars(
		"timeleft", m.timeleft,
		"counter1", m.delivered + "/" + m.allItems,
		"counter1text", "DELIVERED_ITEMS",
		"mission_title", "DISPATCH",
		"mission_desc", "PICKUP"
	);
}

mission_deliver_timelimit(id)
{
	level endon("endmission" + id);

	// Overtime
	if (level.missions[id].point.takers.size)
	{
		overtimeMessage(id);

		do
			level.missions[id].point waittill("dropped");
		while (level.missions[id].point.takers.size);
	}

	level notify("endmission" + id, "defend");
}

bePickupPoint()
{
	id = self.missionId;
	level endon("endmission" + id);

	while (true)
	{
		self waittill("trigger", p);
		if (isDefined(p.missionId) && p.missionId == id && isAlive(p) && p.team == level.missions[id].attackTeam && p.objects && !isDefined(self.takers[p.clientid]))
		{
			self.takers[p.clientid] = p;
			p loadBar(0, id);
			p thread dropItem(self);
		}
	}
}

watchDropDisconnect(p)
{
	level endon("endmission" + self.missionId);
	self endon("stopdrop");
	p waittill("disconnect");
	self notify("stopdrop");
}

dropItem(point)
{
	id = point.missionId;
	self endon("disconnect");
	level endon("endmission" + id);

	point thread watchDropDisconnect(self); // For overtime
	point thread startSingleFlashing();
	curTime = 0.05;
	wait 0.05;
	while (curTime < level.missions[id].captureTime && self isTouching(point) && isAlive(self))
	{
		curTime += 0.05;
		wait 0.05;
	}

	self killLoadBar();
	point.takers[self.clientid] = undefined;
	//point.curTime = undefined;

	if (curTime == level.missions[id].captureTime && self isTouching(point))
	{
		level.missions[id].delivered += self.objects;
		self target(self.objects, true);
		self.objects = 0;
		self notify("putitem");
		self setClientDvar("items", 0);

		foreach (e as level.missions[id].items;;+)
		{
			if (!isDefined(e.put) && isDefined(e.taken) && e.taken == self)
				e.put = true;
		}
		if (level.missions[id].delivered == level.missions[id].allItems)
		{
			point hideAll();
			foreach (p as level.missions[id].all; 0; +level.missions[id].allCount)
			{
				p destroyObject(0);
				p setClientDvars(
					"counter1", "",
					"counter1text", ""
				);
			}
			level notify("endmission" + id, "attack");
		}
		else
		{
			d = level.missions[id].delivered + "/" + level.missions[id].allItems;
			foreach (p as level.missions[id].all; 0; +level.missions[id].allCount)
			{
				p setClientDvar("counter1", d);
				p thread mainLine(level.s["DELIVERED_ITEMS_" + p.lang] + ": " + d);
			}
		}
	}

	point notify("stopdrop"); // For overtime
}

bePickupItem(origin, angles)
{
	if (!isDefined(origin))
		origin = self.origin;
	if (!isDefined(angles))
		angles = self.angles;

	self.obj = spawn("script_model", origin);
	self.obj setModel("com_copypaper_box");
	self.obj.angles = angles;
	self.trigger = spawn("trigger_radius", origin, 0, 16, 16);

	id = self.missionId;
	while (isDefined(self.trigger))
	{
		self.trigger waittill("trigger", player);
		if (isDefined(player.missionId) && player.missionId == id && player.team == level.missions[id].attackTeam && player useButtonPressed())
		{
			if (!player.objects)
			{
				player thread watchLoseObjects();
				player thread watchLoseObjectsStun();
				player thread watchLoseObjectsDisconnect();
			}

			player.objects++;
			player setClientDvar("items", player.objects);
			self.obj delete();
			self.trigger delete();
			self.taken = player;
			level.missions[self.missionId].obj[self.id] = undefined;

			foreach (e as level.teams[level.missions[id].team[level.missions[id].attackTeam]];;+)
			{
				e destroyObject(self.id);

				if (e != player)
					e newMissionPoint("follow" + (self.id), player, "obj");
			}
		}
	}
}

watchLoseObjects()
{
	self endon("disconnect");
	self endon("putitem");
	self endon("endmission");
	self endon("stunned");

	self waittill("killed_player");
	self dropObjects();
}

watchLoseObjectsStun()
{
	self endon("killed_player");
	self endon("disconnect");
	self endon("putitem");
	self endon("endmission");

	self waittill("stunned");
	self dropObjects();
}

watchLoseObjectsDisconnect()
{
	self endon("killed_player");
	self endon("putitem");
	self endon("endmission");
	self endon("stunned");

	self waittill("disconnect", origin, angles);
	self dropObjects(origin, angles);
}

dropObjects(origin, angles)
{
	// Disconencted
	if (isPlayer(self))
	{
		self.objects = 0;
		self setClientDvar("items", 0);

		origin = self.origin;
		angles = self.angles;
	}


	origin = physicsTrace(origin, origin - (0, 0, 1000));

	att = level.teams[level.missions[self.missionId].team[level.missions[self.missionId].attackTeam]];
	foreach (e as level.missions[self.missionId].items;;+)
	{
		if (!isDefined(e.put) && !isDefined(e.obj) && (!isDefined(e.taken) || e.taken == self)) // Maybe already disconnected = undefined
		{
			level.missions[self.missionId].obj[e.id]["pos"] = e;
			level.missions[self.missionId].obj[e.id][level.missions[self.missionId].attackTeam] = "pickup";
			e.taken = undefined;
			e thread bePickupItem(origin, angles);
			foreach (p as att;;+)
			{
				p objOnCompass(e.id, origin, "pickup");
			}
		}
	}
}

//-----------------------------------/
// GOTO                              /
//-----------------------------------/
mission_goto(id)
{
	// Generate attackers and defenders
	if (randomInt(2))
		level.missions[id].attackTeam = "allies";
	else
		level.missions[id].attackTeam = "axis";

	m = level.missions[id];
	level.missions[id].defendTeam = level.enemy[m.attackTeam];

	// Get attackers and defenders
	att = level.teams[m.team[m.attackTeam]];
	def = level.teams[m.team[m.defendTeam]];

	// Get the most optimal point
	attOrigin = averagePos(att);
	defOrigin = averagePos(def);
	pnt = level.gotoPoints[0];
	dis = -1;
	foreach (e as level.gotoPoints;;+)
	{
		if (!isDefined(e.occupied))
		{
			defDist = distanceSquared(defOrigin, e.origin);
			attDist = distanceSquared(attOrigin, e.origin);
			newDis = abs(defDist - attDist);
			if (dis == -1 || newDis < dis)
			{
				pnt = e;
				dis = newDis;
			}
		}
	}

	// No more free goto points
	// It must be impossible on a completed map
	if (dis == -1)
	{
		level.missions[id].currentStage--;
		thread newObj(id);
		return;
	}

	pnt.occupied = true;
	points = pnt.points;
	pointc = points.size;
	foreach (e as i:points;;+pointc)
	{
		e.id = i;
		e.missionId = id;
		e thread beGotoPoint();
		level.missions[id].obj[i]["pos"] = e;
		level.missions[id].obj[i][m.defendTeam] = "defend";
		level.missions[id].obj[i][m.attackTeam] = "capture";
	}

	// Time
	level.missions[id].maxTime = 120 *pointc;
	level.missions[id].captureTime = 5;
	timeString = leftTimeToString(m.maxTime, "noh");

	// All players
	foreach (p as m.all; 0; +m.allCount)
	{
		p.objIcons = [];
		p setClientDvars(
			"counter1", "0/" + pointc,
			"counter1text", "CAPTURED_POINTS",
			"timeleft", timeString,
			"mission_title", "DISPATCH",
			"mission_desc", "GOTO"
		);
	}

	// Show points
	foreach (p as att;;+)
	{
		foreach (e as j:points; 0; +pointc)
		{
			p objOnCompass(j, e.origin, "capture");
			e thread showAll("enemy", p);
		}
	}
	foreach (p as def;;+)
	{
		foreach (e as j:points; 0; +pointc)
		{
			p objOnCompass(j, e.origin, "defend");
			e thread showAll("friend", p);
		}
	}

	level.missions[id].allItems = points.size;
	level.missions[id].captured = 0;
	level.missions[id].backupFunc = ::mission_goto_backup;
	level.missions[id].giveupFunc = ::mission_goto_giveup;
	level.missions[id].timeleft = timeString; // For backup
	level.missions[id].point = pnt; // For backup and kick too
	level.missions[id].points = points; // For backup and kick too
	thread timeLimit(id, m.maxTime, ::mission_goto_timelimit);

	updateRespawnMap(id);

	// Save memory by freeing every variable in this function
	thread mission_goto_end(id);
}

mission_goto_end(id)
{
	level waittill("endmission" + id, winner, giveup); // attack or defend

	level.missions[id].point.occupied = undefined;
	foreach (p as level.missions[id].points;;+)
	{
		foreach (t as p.takers; @)
		{
			t killLoadBar();
		}
		p.takers = undefined;
		p.curTime = undefined;
		p.id = undefined;
		p.missionId = undefined;
		p hideAll();
	}

	if (isDefined(giveup))
		endMission(id, winner, "GIVEUP");
	else if (winner == "defend")
		endMission(id, level.missions[id].defendTeam, "COMPLETE");
	else
		thread newObj(id);
}

mission_goto_giveup(id, team)
{
	level notify("endmission" + id, team, true);
}

mission_goto_backup()
{
	id = self.missionId;
	m = level.missions[id];

	self.objIcons = [];
	foreach (p as j:m.points;;+)
	{
		if (!isDefined(self.captured))
		{
			if (self.team == level.missions[id].defendTeam)
			{
				p[j] thread showAll("friend", self);
				self objOnCompass(j, p[j].origin, "defend");
			}
			else
			{
				p[j] thread showAll("enemy", self);
				self objOnCompass(j, p[j].origin, "capture");
			}
		}
	}
	self setClientDvars(
		"timeleft", m.timeleft,
		"counter1", level.missions[id].captured + "/" + level.missions[id].allItems,
		"counter1text", "CAPTURED_POINTS",
		"mission_title", "DISPATCH",
		"mission_desc", "GOTO"
	);
}

// No foreach, because we need the key after run
inline anyGotoTakers()
{
	for (a = 0; a < c; a++)
	{
		if (v[a].takers.size)
			break;
	}
}

mission_goto_timelimit(id)
{
	level endon("endmission" + id);

	// Overtime
	v = level.missions[id].points;
	c = v.size;
	anyGotoTakers();
	if (a != c)
	{
		overtimeMessage(id);

		do
		{
			v[a] waittill("blocktake");
			anyGotoTakers();
		}
		while (a != c);
	}

	level notify("endmission" + id, "defend");
}

beGotoPoint()
{
	id = self.missionId;
	level endon("endmission" + id);
	self endon("captured");

	owner = level.missions[id].defendTeam;
	self.takers = [];
	self.curTime = 0;

	while (true)
	{
		self waittill("trigger", player);
		if (isDefined(player.missionId) && player.missionId == id && isAlive(player) && (owner != player.team || self.takers.size))
		{
			if (owner == player.team)
			{
				self notify("blocktake");
				self.curTime = 0;
				foreach (e as self.takers; @;+)
				{
					e killLoadBar();
				}
				self.takers = [];
			}
			else if (!isDefined(self.takers[player.clientid]))
			{
				if (self.takers.size)
				{
					self.takers[player.clientid] = player;
					player loadBar(self.curTime, id);
				}
				else
				{
					br = false;
					foreach (e as level.teams[player.enemyTeam];;+)
					{
						if (isAlive(e) && e isTouching(self))
						{
							br = true;
							break;
						}
					}
					if (!br)
					{
						self.takers[player.clientid] = player;
						player loadBar(self.curTime, id);
						self thread destroying();
					}
				}
			}
		}
		//wait 0.05;
	}
}

destroying()
{
	id = self.missionId;
	m = level.missions[id];
	level endon("endmission" + id);
	self endon("blocktake");

	self thread startSingleFlashing();
	ct = m.captureTime;
	while (self.curTime < ct && self.takers.size)
	{
		count = self.takers.size;
		self.curTime += 0.05 * count;
		wait 0.05;

		// Can't be foreach because of value change
		foreach (p as i:self.takers; @keys; +count)
		{
			if (!isDefined(p) || !p isTouching(self) || !isAlive(p))
			{
				if (isDefined(p))
				{
					p killLoadBar();
				}
				self.takers[keys[i]] = undefined;
			}
		}
		// self.takers is modified
		newcount = self.takers.size;
		if (self.curTime < ct && count != newcount && newcount)
		{
			foreach (p as self.takers; @; +newcount)
			{
				b = p.loadbar;
				b setShader("white", int(self.curTime * (100 / ct) + 0.5), 9);
				b scaleOverTime((ct - self.curTime) / newcount, 100, 9);
			}
		}
	}

	if (self.takers.size)
	{
		foreach (p as self.takers; @; +)
		{
			p killLoadBar();
			p target(1);
		}
		self.takers = [];
		self hideAll();
		foreach (p as m.all; 0; +m.allCount)
		{
			p destroyObject(self.id);
		}

		// Captured
		level.missions[id].captured++;
		if (m.captured == m.allItems)
		{
			foreach (p as m.all; 0; +m.allCount)
			{
				p setClientDvars(
					"counter1", "",
					"counter1text", ""
				);
			}
			level notify("endmission" + id, "attack");
		}
		else
		{
			level.missions[id].obj[self.id] = undefined;
			foreach (p as m.all; 0; +m.allCount)
			{
				p setClientDvar("counter1", m.captured + "/" + m.allItems);
			}
			self notify("captured");
			self.captured = true;
		}
	}
	else
	{
		self.curTime = 0;
	}

	self notify("blocktake"); // Overtime
}

//-----------------------------------/
// CONTROL POINTS                    /
//-----------------------------------/
mission_capture(id)
{
	// Get teams
	m = level.missions[id];
	allies = level.teams[m.team["allies"]];
	axis = level.teams[m.team["axis"]];

	// Get the most optimal point
	alliesOrigin = averagePos(allies);
	axisOrigin = averagePos(axis);
	pnt = level.controlPoints[0];
	dis = -1;
	foreach (e as level.controlPoints;;+)
	{
		if (!isDefined(e.occupied))
		{
			alliesDist = distanceSquared(alliesOrigin, e.origin);
			axisDist = distanceSquared(axisOrigin, e.origin);
			newDis = abs(alliesDist - axisDist);
			if (dis == -1 || newDis < dis)
			{
				pnt = e;
				dis = newDis;
			}
		}
	}

	// No more free capture points
	// It must be impossible on a completed map
	if (dis == -1)
	{
		level.missions[id].currentStage--;
		thread newObj(id);
		return;
	}

	// Set-up point
	pnt.occupied = true;
	points = pnt.points;
	pointc = points.size;
	foreach (e as i:points; 0; +pointc)
	{
		e.id = i;
		e.missionId = id;
		e thread beCapturePoint();
		level.missions[id].obj[i]["pos"] = e;
		level.missions[id].obj[i]["allies"] = "free";
		level.missions[id].obj[i]["axis"] = "free";
	}

	// Time
	level.missions[id].maxTime = 120 * pointc;
	level.missions[id].captureTime = 5;
	timeString = leftTimeToString(m.maxTime, "noh");

	// All players
	foreach (p as level.missions[id].all; 0; +level.missions[id].allCount)
	{
		p.objIcons = [];
		foreach (e as j:points; 0; +pointc)
		{
			p objOnCompass(j, e.origin, "free");
			e thread showAll("none", p);
		}
		p setClientDvars(
			"line1", 0,
			"line2", 0,
			"line1_max", 100,
			"line2_max", 100,
			"timeleft", timeString,
			"mission_title", "TERRITORY",
			"mission_desc", "TERRITORY"
		);
	}
	level.missions[id].score["allies"] = 0;
	level.missions[id].score["axis"] = 0;
	level.missions[id].backupFunc = ::mission_capture_backup;
	level.missions[id].giveupFunc = ::mission_capture_giveup;
	level.missions[id].timeleft = timeString; // For backup
	level.missions[id].point = pnt;
	level.missions[id].points = points; // For backup and kick
	thread timeLimit(id, m.maxTime, ::mission_capture_timelimit);

	updateRespawnMap(id);

	// Save memory by freeing every variable in this function
	thread mission_capture_end(id);
}

mission_capture_end(id)
{
	level waittill("endmission" + id, winner, type);

	level.missions[id].point.occupied = undefined;
	foreach (p as level.missions[id].points;;+)
	{
		foreach (t as p.takers; @)
		{
			t killLoadBar();
		}
		p.takers = undefined;
		p.owner = undefined;
		p.taker = undefined;
		p.curTime = undefined;
		p.id = undefined;
		p.missionId = undefined;
		p hideAll();
	}

	// End
	if (!isDefined(type))
		type = "COMPLETE";

	endMission(id, winner, type);
}

mission_capture_giveup(id, team)
{
	level notify("endmission" + id, team, "GIVEUP");
}

mission_capture_timelimit(id)
{
	level endon("endmission" + id);

	// Overtime
	owned["allies"] = 0;
	owned["axis"] = 0;
	owned["none"] = 0;
	foreach (e as level.missions[id].points;;+)
	{
		owned[e.owner]++;
	}

	if (owned["allies"] != owned["axis"])
	{
		if (owned["allies"] > owned["axis"])
			owner = "allies";
		else
			owner = "axis";

		if (level.missions[id].score[owner] <= level.missions[id].score[level.enemy[owner]])
		{
			overtimeMessage(id);

			while (owned[owner] > owned[level.enemy[owner]])
			{
				level waittill("captured" + id, old, new);
				owned[old]--;
				owned[new]++;
			}
		}
	}

	if (level.missions[id].score["allies"] > level.missions[id].score["axis"])
		level notify("endmission" + id, "allies");
	else if (level.missions[id].score["allies"] < level.missions[id].score["axis"])
		level notify("endmission" + id, "axis");
	else
		level notify("endmission" + id, "allies", "TIED");
}

mission_capture_backup()
{
	friend = self.team;
	enemy = level.enemy[self.team];
	m = level.missions[self.missionId];

	self.objIcons = [];
	foreach (p as j:m.points;;+)
	{
		if (p.owner == friend)
		{
			p thread showAll("friend", self);
			self objOnCompass(j, p.origin, "defend");
		}
		else if (p.owner == enemy)
		{
			p thread showAll("enemy", self);
			self objOnCompass(j, p.origin, "capture");
		}
		else
		{
			p thread showAll("none", self);
			self objOnCompass(j, p.origin, "free");
		}
	}
	self setClientDvars(
		"line1", m.score[friend],
		"line2", m.score[enemy],
		"line1_max", 100,
		"line2_max", 100,
		"timeleft", m.timeleft,
		"mission_title", "TERRITORY",
		"mission_desc", "TERRITORY"
	);
}

beCapturePoint()
{
	id = self.missionId;
	level endon("endmission" + id);

	self.owner = "none";
	self.takers = [];
	self.taker = "none";
	self.curTime = 0;

	while (true)
	{
		self waittill("trigger", player);
		if (isDefined(player.missionId) && player.missionId == id && isAlive(player) && !isDefined(player.claimed))
		{
			if (self.owner != player.team || self.taker != player.team)
			{
				if (self.taker != player.team && self.taker != self.owner)
				{
					self notify("blocktake");
					self.curTime = 0;
					self.taker = self.owner;
					foreach (e as self.takers; @)
					{
						e killLoadBar();
					}
					self.takers = [];
				}
				else if (!isDefined(self.takers[player.clientid]))
				{
					if (self.taker == player.team)
					{
						self.takers[player.clientid] = player;
						player loadBar(self.curTime, self.missionId);
					}
					else
					{
						br = false;
						foreach (e as level.teams[player.enemyTeam];;+)
						{
							if (isAlive(e) && e isTouching(self))
							{
								br = true;
								break;
							}
						}
						if (!br)
						{
							self.taker = player.team;
							self.takers[player.clientid] = player;
							player loadBar(self.curTime, id);
							self thread capturing(player.missionTeam, player.enemyTeam);
						}
					}
				}
			}
		}
	}
}

capturing(friendTeam, enemyTeam)
{
	id = self.missionId;
	level endon("endmission" + id);
	self endon("blocktake");

	captureTime = level.missions[id].captureTime;
	self thread startFlashing();
	while (self.curTime < captureTime && self.takers.size)
	{
		count = self.takers.size;
		self.curTime += 0.05 * count;
		wait 0.05;

		foreach (e as i:self.takers; @keys; +count)
		{
			if (!isDefined(e) || !isAlive(e) || isDefined(e.claimed) || !(e isTouching(self)))
			{
				if (isDefined(e))
				{
					e killLoadBar();
				}
				self.takers[keys[i]] = undefined; // Modified
			}
		}
		// self.takers is modified
		newcount = self.takers.size;
		if (self.curTime < captureTime && count != newcount && newcount)
		{
			foreach (e as self.takers; @; +newcount)
			{
				b = e.loadbar;
				b setShader("white", int(self.curTime * (100 / captureTime) + 0.5), 9);
				b scaleOverTime((captureTime - self.curTime) / newcount, 100, 9);
			}
		}
	}

	self.curTime = 0;
	if (self.takers.size)
	{
		keys = getArrayKeys(self.takers);

		level.missions[id].obj[self.id][self.takers[keys[0]].team] = "defend";
		level.missions[id].obj[self.id][level.enemy[self.takers[keys[0]].team]] = "capture";

		oldowner = self.owner;
		if (self.owner == "none")
		{
			self.owner = self.taker;
			foreach (i as keys;;+) // We already needed the key array above
			{
				self.takers[i] killLoadBar();
				self.takers[i] target(1);
			}
			self.takers = [];
			self thread watchCP();
		}
		else
		{
			self.owner = "none";
			foreach (i as keys;;+)
			{
				self.takers[i].loadbar setShader("white", 0, 9);
				self.takers[i].loadbar scaleOverTime(captureTime, 100, 9);
			}
			self thread capturing(friendTeam, enemyTeam);
		}

		self hideAll();
		foreach (p as level.teams[friendTeam];;+)
		{
			if (self.owner == "none")
			{
				self thread showAll("none", p);
				p objOnCompass(self.id, self.origin, "free");
			}
			else
			{
				self thread showAll("friend", p);
				p objOnCompass(self.id, self.origin, "defend");
			}
		}
		foreach (e as level.teams[enemyTeam];;+)
		{
			if (self.owner == "none")
			{
				self thread showAll("none", e);
				e objOnCompass(self.id, self.origin, "free");
			}
			else
			{
				self thread showAll("enemy", e);
				e objOnCompass(self.id, self.origin, "capture");
			}
		}
		level notify("captured" + id, oldowner, self.owner); // Overtime
	}
	else
	{
		self.taker = self.owner;
	}
}

watchCP()
{
	id = self.missionId;
	level endon("endmission" + id);

	owner = self.owner;
	wait 3;
	while (self.owner == owner)
	{
		level.missions[id].score[self.owner]++;
		if (level.missions[id].score[self.owner] == 100)
		{
			level notify("endmission" + id, self.owner);
			return;
		}
		foreach (t as level.teams[level.missions[id].team[self.owner]];;+)
		{
			t setClientDvar("line1", level.missions[id].score[self.owner]);
		}
		foreach (t as level.teams[level.missions[id].team[level.enemy[self.owner]]];;+)
		{
			t setClientDvar("line2", level.missions[id].score[self.owner]);
		}
		wait 3;
	}
}

//-----------------------------------/
// DEATHMATCH                        /
//-----------------------------------/
mission_dm(id)
{
	m = level.missions[id];
	allies = level.teams[m.team["allies"]];
	axis = level.teams[m.team["axis"]];
	alliessize = allies.size;
	axissize = axis.size;

	// Lives per team
	level.missions[id].lives = alliessize + axissize; // int()

	// Time
	level.missions[id].maxTime = 420;
	timeString = leftTimeToString(m.maxTime, "noh");

	foreach (e as i:axis; 0; +axissize)
	{
		foreach (a as j:allies; 0; +alliessize)
		{
			e newMissionPoint("kill" + j, a, "kill");
			a newMissionPoint("kill" + i, e, "kill");
		}
	}

	// All players
	foreach (p as m.all; 0; +level.missions[id].allCount)
	{
		p.objIcons = [];
		p setClientDvars(
			"line1", 0,
			"line2", 0,
			"line1_max", m.lives,
			"line2_max", m.lives,
			"timeleft", timeString,
			"mission_title", "DM",
			"mission_desc", "DM"
		);
		//level.missions[id].obj[i]["pos"] = p;
		p thread watchDMDie();
		//p thread watchDMDisconnect(id); // No idea why is .obj[] commented out, but till then it is useless
	}
	level.missions[id].score["allies"] = 0;
	level.missions[id].score["axis"] = 0;
	level.missions[id].backupFunc = ::mission_dm_backup;
	level.missions[id].giveupFunc = ::mission_dm_giveup;
	level.missions[id].dm = true; // For removing enemy head points
	level.missions[id].timeleft = timeString; // For backup
	thread timeLimit(id, m.maxTime, ::mission_dm_timelimit);

	updateRespawnMap(id);

	// Save memory by freeing every variable in this function
	thread mission_dm_end(id);
}

mission_dm_end(id)
{
	level waittill("endmission" + id, winner, type);

	if (!isDefined(type))
		type = "COMPLETE";

	endMission(id, winner, type);
}

mission_dm_giveup(id, team)
{
	level notify("endmission" + id, team, "GIVEUP");
}

mission_dm_timelimit(id)
{
	if (level.missions[id].score["allies"] > level.missions[id].score["axis"])
		level notify("endmission" + id, "allies");
	else if (level.missions[id].score["allies"] < level.missions[id].score["axis"])
		level notify("endmission" + id, "axis");
	else
		level notify("endmission" + id, "allies", "TIED");
}

mission_dm_backup()
{
	m = level.missions[self.missionId];
	self.objIcons = [];
	self setClientDvars(
		"line1", m.score[self.team],
		"line2", m.score[level.enemy[self.team]],
		"line1_max", m.lives,
		"line2_max", m.lives,
		"timeleft", m.timeleft,
		"mission_title", "DM",
		"mission_desc", "DM"
	);
}

watchDMDie()
{
	self endon("disconnect");
	self endon("endmission");
	//level endon("endmission" + self.missionId);

	id = self.missionId;
	m = level.missions[id];
	friend = self.team;
	enemy = level.enemy[friend];
	while (true)
	{
		self waittill("killed_player");
		level.missions[id].score[enemy]++; // Modify
		if (m.score[enemy] == m.lives)
		{
			level notify("endmission" + id, enemy);
		}
		else
		{
			foreach (t as level.teams[self.enemyTeam];;+)
			{
				t setClientDvars(
					"line1", m.score[enemy],
					"line2", m.score[friend]
				);
			}
			foreach (t as level.teams[self.missionTeam];;+)
			{
				t setClientDvars(
					"line1", m.score[friend],
					"line2", m.score[enemy]
				);
			}
		}
	}
}

/*watchDMDisconnect(id)
{
	self endon("endmission");
	self waittill("disconnect");
	unsetArrayItemOrdered(level.missions[id].obj, self); // self.missionId is undefined (why?)
}*/

//-----------------------------------/
// SIDED DEATHMATCH                  /
//-----------------------------------/
mission_sideddm(id)
{
	m = level.missions[id];
	allies = level.teams[m.team["allies"]];
	axis = level.teams[m.team["axis"]];
	alliessize = allies.size;
	axissize = axis.size;

	// Lives per team
	level.missions[id].lives = alliessize + axissize; // int()

	// Time
	level.missions[id].maxTime = 420;
	timeString = leftTimeToString(m.maxTime, "noh");

	// All players
	foreach (e as i:axis; 0; +axissize)
	{
		foreach (a as j:allies; 0; +alliessize)
		{
			e newMissionPoint("kill" + j, a, "kill");
			a newMissionPoint("kill" + i, e, "kill");
		}
	}
	foreach (p as m.all; 0; +level.missions[id].allCount)
	{
		p.objIcons = [];
		p setClientDvars(
			"side", m.lives,
			"side_max", m.lives * 2,
			"timeleft", timeString,
			"mission_title", "DM",
			"mission_desc", "DM"
		);
		//level.missions[id].obj[i] = p;
		p thread watchSidedDMDie();
		//p thread watchSidedDMDisconnect(id); // No idea why is obj commented out, but without that it's useless
	}
	level.missions[id].score["allies"] = 0;
	level.missions[id].score["axis"] = 0;
	level.missions[id].backupFunc = ::mission_sideddm_backup;
	level.missions[id].giveupFunc = ::mission_sideddm_giveup;
	level.missions[id].dm = true; // For removing enemy head points
	level.missions[id].timeleft = timeString; // For backup
	thread timeLimit(id, m.maxTime, ::mission_sideddm_timelimit);

	updateRespawnMap(id);

	// Save memory by freeing every variable in this function
	thread mission_sideddm_end(id);
}

mission_sideddm_end(id)
{
	level waittill("endmission" + id, winner, type);

	if (!isDefined(type))
		type = "COMPLETE";

	endMission(id, winner, type);
}

mission_sideddm_giveup(id, team)
{
	level notify("endmission" + id, team, "GIVEUP");
}

mission_sideddm_timelimit(id)
{
	if (level.missions[id].score["allies"] > level.missions[id].score["axis"])
		level notify("endmission" + id, "allies");
	else if (level.missions[id].score["allies"] < level.missions[id].score["axis"])
		level notify("endmission" + id, "axis");
	else
		level notify("endmission" + id, "allies", "TIED");
}

mission_sideddm_backup()
{
	m = level.missions[self.missionId];
	self.objIcons = [];
	self setClientDvars(
		"side", m.lives + (m.score[self.team] - m.score[level.enemy[self.team]]),
		"side_max", m.lives * 2,
		"timeleft", m.timeleft,
		"mission_title", "DM",
		"mission_desc", "DM"
	);
}

watchSidedDMDie()
{
	self endon("disconnect");
	self endon("endmission");
	//level endon("endmission" + self.missionId);

	friend = self.team;
	enemy = level.enemy[friend];
	id = self.missionId;
	m = level.missions[id];
	while (true)
	{
		self waittill("killed_player");
		level.missions[id].score[enemy]++;
		dif = m.score[enemy] - m.score[friend];
		if (dif == m.lives)
		{
			level notify("endmission" + self.missionId, enemy);
		}
		else
		{
			c = m.lives + dif;
			foreach (t as level.teams[self.enemyTeam];;+)
			{
				t setClientDvar("side", c);
			}
			c = m.lives + dif * -1;
			foreach (t as level.teams[self.missionTeam];;+)
			{
				t setClientDvar("side", c);
			}
		}
	}
}

/*watchSidedDMDisconnect(id)
{
	self endon("endmission");
	self waittill("disconnect");
	unsetArrayItemOrdered(level.missions[id].obj, self); // self.missionId
}*/

//-----------------------------------/
// Very Important Personal           /
//-----------------------------------/
mission_vip(id)
{
	// Generate attackers and defenders
	if (randomInt(2))
		level.missions[id].attackTeam = "allies";
	else
		level.missions[id].attackTeam = "axis";

	m = level.missions[id];
	level.missions[id].defendTeam = level.enemy[m.attackTeam];

	def = level.teams[m.team[m.defendTeam]];
	att = level.teams[m.team[m.attackTeam]];

	// Lives
	level.missions[id].vipLives = 3 + int(att.size / 2);
	level.missions[id].attackerLives = m.vipLives * 3;

	// Time
	level.missions[id].maxTime = 180 + att.size * 30;
	timeString = leftTimeToString(m.maxTime, "noh");

	// Get VIP
	defsize = def.size;
	foreach (p as def;;+defsize)
	{
		if (isDefined(p.teamleader))
		{
			level.missions[id].vip = p;
			level.missions[id].obj[0]["pos"] = p;
			level.missions[id].obj[0][m.attackTeam] = "enemyvip";
			level.missions[id].obj[0][m.defendTeam] = "vip";
			break;
		}
	}
	level.missions[id].vip.vip = true;
	level.missions[id].vip thread boldLine(level.s["YOU_ARE_VIP_" + m.vip.lang] + "!");
	level.missions[id].vip thread watchVIPDie();
	level.missions[id].vip thread watchVIPDisconnect();

	foreach (p as att;;+)
	{
		p newMissionPoint("enemyvip", m.vip, "vip");
		p thread watchVIPAttDie();
	}
	foreach (p as def;;+defsize)
	{
		if (p != m.vip)
		{
			p newMissionPoint("vip", m.vip, "vip");
		}
	}

	// All players ~ objOnCompass() needed?
	foreach (p as m.all; 0; +m.allCount)
	{
		p.objIcons = [];
		p setClientDvars(
			"counter1", m.vipLives,
			"counter1text", "VIP_LIVES",
			"counter2", m.attackerLives,
			"counter2text", "ATTACKER_LIVES",
			"timeleft", timeString,
			"mission_title", "VIP",
			"mission_desc", "VIP"
		);
	}
	level.missions[id].backupFunc = ::mission_vip_backup;
	level.missions[id].giveupFunc = ::mission_vip_giveup;
	level.missions[id].timeleft = timeString; // For backup
	thread timeLimit(id, m.maxTime, ::mission_vip_timelimit);

	updateRespawnMap(id);

	// Save memory by freeing every variable in this function
	thread mission_vip_end(id);
}

mission_vip_end(id)
{
	level waittill("endmission" + id, winner, giveup);

	if (isDefined(giveup))
		type = "GIVEUP";
	else
		type = "COMPLETE";

	endMission(id, winner, type);
}

mission_vip_giveup(id, team)
{
	level notify("endmission" + id, team, true);
}

mission_vip_timelimit(id)
{
	level notify("endmission" + id, level.missions[id].defendTeam);
}

mission_vip_backup()
{
	m = level.missions[self.missionId];

	self.objIcons = [];
	self setClientDvars(
		"counter1", m.vipLives,
		"counter1text", "VIP_LIVES",
		"counter2", m.attackerLives,
		"counter2text", "ATTACKER_LIVES",
		"timeleft", m.timeleft,
		"mission_title", "VIP",
		"mission_desc", "VIP"
	);
	if (self.team == m.defendTeam)
	{
		self newMissionPoint("vip", m.vip, "vip");
	}
	else
	{
		self newMissionPoint("enemyvip", m.vip, "vip");
		self thread watchVIPAttDie();
	}
}

watchVIPDie()
{
	self endon("disconnect");
	self endon("endmission");
	//level endon("endmission" + self.missionId);

	id = self.missionId;
	m = level.missions[id];
	while (true)
	{
		self waittill("killed_player");
		level.missions[id].vipLives--;
		if (!m.vipLives)
		{
			level notify("endmission" + id, level.enemy[self.team]);
		}
		else
		{
			foreach (p as m.all; 0; +m.allCount)
			{
				p setClientDvar("counter1", m.vipLives);
			}
		}
	}
}

watchVIPAttDie()
{
	self endon("disconnect");
	self endon("endmission");
	//level endon("endmission" + self.missionId);

	id = self.missionId;
	m = level.missions[id];
	while (true)
	{
		self waittill("killed_player");
		level.missions[id].attackerLives--;
		if (!m.attackerLives)
		{
			level notify("endmission" + id, level.enemy[self.team]);
		}
		else
		{
			foreach (p as m.all; 0; +m.allCount)
			{
				p setClientDvar("counter2", m.attackerLives);
			}
		}
	}
}

watchVIPDisconnect()
{
	self endon("endmission");
	self waittill("disconnect");
	[[level.missions[self.missionId].giveupFunc]](self.missionId, level.enemy[self.team]);
}

//-----------------------------------/
// HOLD                              /
//-----------------------------------/
mission_hold(id)
{
	// Get teams
	m = level.missions[id];
	allies = level.teams[m.team["allies"]];
	axis = level.teams[m.team["axis"]];

	// Get the most optimal point
	alliesOrigin = averagePos(allies);
	axisOrigin = averagePos(axis);
	pnt = level.holdPoints[0];
	dis = -1;
	foreach (p as level.holdPoints;;+)
	{
		if (!isDefined(p.occupied))
		{
			alliesDist = distanceSquared(alliesOrigin, p.origin);
			axisDist = distanceSquared(axisOrigin, p.origin);
			newDis = abs(alliesDist - axisDist);
			if (dis == -1 || newDis < dis)
			{
				pnt = p;
				dis = newDis;
			}
		}
	}

	// No more free pick-up points
	// It must be impossible on a completed map
	if (dis == -1)
	{
		level.missions[id].currentStage--;
		thread newObj(id);
		return;
	}

	// Set-up pick-up point
	pnt.occupied = true;
	pnt.owner = "none";
	pnt.missionId = id;
	pnt thread beHoldItem();
	level.missions[id].obj[0]["pos"] = pnt;
	level.missions[id].obj[0]["allies"] = "pickup";
	level.missions[id].obj[0]["axis"] = "pickup";

	// Time
	level.missions[id].maxTime = 420;
	timeString = leftTimeToString(m.maxTime, "noh");

	// All players ~ missing objOnCompass()?
	foreach (p as m.all; 0; +m.allCount)
	{
		p.objIcons = [];
		p objOnCompass(0, pnt.origin, "pickup");
		p setClientDvars(
			"line1", 0,
			"line2", 0,
			"line1_max", 100,
			"line2_max", 100,
			"timeleft", timeString,
			"mission_title", "HOLD",
			"mission_desc", "HOLD"
		);
	}

	level.missions[id].score["allies"] = 0;
	level.missions[id].score["axis"] = 0;
	level.missions[id].backupFunc = ::mission_hold_backup;
	level.missions[id].giveupFunc = ::mission_hold_giveup;
	level.missions[id].timeleft = timeString; // For backup
	level.missions[id].item = pnt; // For kick (too)
	thread timeLimit(id, m.maxTime, ::mission_hold_timelimit);

	updateRespawnMap(id);

	// Save memory by freeing every variable in this function
	thread mission_hold_end(id);
}

mission_hold_end(id)
{
	level waittill("endmission" + id, winner, type); // attack or defend

	m = level.missions[id];
	foreach (p as m.all; 0; +m.allCount)
	{
		p.objects = undefined;
		p setClientDvar("items", 0);
	}

	// Reset pick-up objects
	if (!isDefined(m.item.taken))
	{
		m.item.obj delete();
		m.item.trigger delete();
	}
	else
	{
		m.item.taken.dump = undefined;
	}
	m.item.owner = undefined;
	m.item.taken = undefined;
	m.item.occupied = undefined;
	m.item.missionId = undefined;

	if (!isDefined(type))
		type = "COMPLETE";

	endMission(id, winner, "COMPLETE");
}

mission_hold_giveup(id, team)
{
	level notify("endmission" + id, team, "GIVEUP");
}

mission_hold_backup()
{
	m = level.missions[self.missionId];

	if (isDefined(m.item.taken))
	{
		if (m.item.taken.team == self.team)
		{
			self newMissionPoint("follow0", m.item.taken, "obj");
		}
		else
		{
			self newMissionPoint("kill0", m.item.taken, "obj");
		}
	}
	else if (m.item.owner == self.team)
	{
		self objOnCompass(0, m.item.origin, "defend");
	}
	else
	{
		self objOnCompass(0, m.item.origin, "pickup");
	}

	self setClientDvars(
		"line1", m.score[self.team],
		"line2", m.score[level.enemy[self.team]],
		"line1_max", 100,
		"line2_max", 100,
		"timeleft", m.timeleft,
		"mission_title", "HOLD",
		"mission_desc", "HOLD"
	);
}

mission_hold_timelimit(id)
{
	level endon("endmission" + id);

	// Overtime
	m = level.missions[id];
	if (m.score["allies"] != m.score["axis"])
	{
		owner = m.item.owner;
		if (m.score[owner] < m.score[level.enemy[owner]])
		{
			overtimeMessage(id);

			do
				level.missions[id].item waittill("change");
			while (owner == m.item.owner && m.score[owner] <= m.score[level.enemy[owner]]);
		}
	}

	if (m.score["allies"] > m.score["axis"])
		level notify("endmission" + id, "allies");
	else if (m.score["allies"] < m.score["axis"])
		level notify("endmission" + id, "axis");
	else
		level notify("endmission" + id, "allies", "TIED");
}

beHoldItem(origin, angles)
{
	if (!isDefined(origin))
		origin = self.origin;
	if (!isDefined(angles))
		angles = self.angles;

	origin += (0, 0, 1.25); // The origin of the model is in its middle
	self.obj = spawn("script_model", origin);
	self.obj setModel("com_golden_brick");
	self.obj.angles = angles;
	self.trigger = spawn("trigger_radius", origin, 0, 16, 16);

	id = self.missionId;
	while (isDefined(self.trigger))
	{
		self.trigger waittill("trigger", player);
		if (isDefined(player.missionId) && player.missionId == id && player useButtonPressed() && !isDefined(player.claimed))
		{
			// Give item
			player.dump["primary"]["clip"] = player getWeaponAmmoClip(player.primaryWeapon);
			player.dump["primary"]["stock"] = player getWeaponAmmoStock(player.primaryWeapon);
			player.dump["secondary"]["clip"] = player getWeaponAmmoClip(player.secondaryWeapon);
			player.dump["secondary"]["stock"] = player getWeaponAmmoStock(player.secondaryWeapon);
			player.dump["offhand"] = player getWeaponAmmoClip(player.offhandWeapon);
			player.dump["current"] = player.currentWeapon;
			player takeAllWeapons();
			player setClientDvar("weapinfo_offhand", 0);
			player giveWeapon(level.holdItem);
			player switchToWeapon(level.holdItem);
			player attach("com_golden_brick", "tag_inhand", true);
			player.objects = true;
			player setClientDvar("items", 1);
			//level.missions[self.missionId].obj[0]["pos"] = player;
			//level.missions[self.missionId].obj[0][player.team] = "follow";
			//level.missions[self.missionId].obj[0][level.enemy[player.team]] = "kill";

			player thread watchLoseObject();
			player thread watchDropObject();
			player thread watchLoseObjectStun();
			player thread watchLoseObjectDisconnect();

			if (self.owner != player.team)
				self thread countHoldTime();

			self.obj delete();
			self.trigger delete();
			self.taken = player;
			self.owner = player.team;

			foreach (t as level.teams[level.missions[id].team[player.team]];;+)
			{
				t destroyObject(0);

				if (t != player)
					t newMissionPoint("follow0", player, "obj");
			}
			foreach (t as level.teams[level.missions[id].team[level.enemy[player.team]]];;+)
			{
				t destroyObject(0);
				t newMissionPoint("kill0", player, "obj");
			}
		}
	}
}

countHoldTime()
{
	id = self.missionId;
	m = level.missions[id];

	self notify("counttime");
	self endon("counttime");
	level endon("endmission" + id);

	while (true)
	{
		wait 2.5;
		level.missions[id].score[self.owner]++;
		if (m.score[self.owner] == 100)
		{
			level notify("endmission" + id, self.owner);
		}
		else
		{
			foreach (t as level.teams[m.team[self.owner]])
			{
				t setClientDvar("line1", m.score[self.owner]);
			}
			foreach (t as level.teams[m.team[level.enemy[self.owner]]])
			{
				t setClientDvar("line2", m.score[self.owner]);
			}
		}
		self notify("change");
	}
}

watchLoseObject()
{
	self endon("disconnect");
	self endon("putitem");
	self endon("endmission");
	self endon("stunned");

	self waittill("killed_player");
	self thread dropObject();
}

watchLoseObjectStun()
{
	self endon("killed_player");
	self endon("disconnect");
	self endon("putitem");
	self endon("endmission");

	self waittill("stunned");
	self thread dropObject();
}

watchLoseObjectDisconnect()
{
	self endon("killed_player");
	self endon("putitem");
	self endon("endmission");
	self endon("stunned");

	self waittill("disconnect", origin, angles);
	self thread dropObject(origin, angles);
}

watchDropObject()
{
	//self endon("disconnect");
	self endon("putitem");
	self endon("endmission");

	while (true)
	{
		wait 0.1;
		if (self attackButtonPressed())
		{
			self takeWeapon(level.holdItem);
			self giveWeapon(self.primaryWeapon, self.weapons[self.wID[self.info["prime"]]]["camo"]);
			self giveWeapon(self.secondaryWeapon);
			self giveWeapon(self.offhandWeapon);
			self setWeaponAmmoClip(self.primaryWeapon, self.dump["primary"]["clip"]);
			self setWeaponAmmoStock(self.primaryWeapon, self.dump["primary"]["stock"]);
			self setWeaponAmmoClip(self.secondaryWeapon, self.dump["secondary"]["clip"]);
			self setWeaponAmmoStock(self.secondaryWeapon, self.dump["secondary"]["stock"]);
			self setWeaponAmmoClip(self.offhandWeapon, self.dump["offhand"]);
			self setClientDvar("weapinfo_offhand", self.dump["offhand"]);
			self.currentWeapon = self.dump["current"];

			if (self.dump["current"] != "none")
				self switchToWeapon(self.dump["current"]);

			self detach("com_golden_brick", "tag_inhand");
			self thread dropObject();
		}
	}
}

dropObject(origin, angles)
{
	self notify("putitem");

	// Not disconnected
	if (isPlayer(self))
	{
		self setClientDvar("items", 0);
		self.objects = undefined;
		self.dump = undefined;

		origin = self.origin;
		angles = self.angles;
	}

	origin = playerPhysicsTrace(origin, origin - (0, 0, 10000));

	m = level.missions[self.missionId];
	m.item.taken = undefined;
	m.item thread beHoldItem(origin, angles);
	//level.missions[self.missionId].obj[0]["pos"] = item;
	//level.missions[self.missionId].obj[0][self.team] = "defend";
	//level.missions[self.missionId].obj[0][level.enemy[self.team]] = "pickup";

	foreach (t as level.teams[m.team[self.team]];;+)
	{
		t objOnCompass(0, origin, "defend");
	}
	foreach (t as level.teams[m.team[level.enemy[self.team]]];;+)
	{
		t objOnCompass(0, origin, "pickup");
	}
}

//-----------------------------------/
// DROP                              /
//-----------------------------------/
mission_drop(id)
{
	// Get teams
	m = level.missions[id];
	allies = level.teams[m.team["allies"]];
	axis = level.teams[m.team["axis"]];

	// Get the most optimal point
	alliesOrigin = averagePos(allies);
	axisOrigin = averagePos(axis);
	pnt = level.dropPoints[0];
	dis = -1;
	foreach (p as level.dropPoints;;+)
	{
		if (!isDefined(p.occupied))
		{
			alliesDist = distanceSquared(alliesOrigin, p.origin);
			axisDist = distanceSquared(axisOrigin, p.origin);
			newDis = abs(alliesDist - axisDist);
			if (dis == -1 || newDis < dis)
			{
				pnt = p;
				dis = newDis;
			}
		}
	}

	// No more free pick-up points
	// It must be impossible on a completed map
	if (dis == -1)
	{
		level.missions[id].currentStage--;
		thread newObj(id);
		return;
	}

	// Randomize drop points
	r = randomInt(2);
	dropPoints["allies"] = pnt.points[r];
	if (r)
		dropPoints["axis"] = pnt.points[0];
	else
		dropPoints["axis"] = pnt.points[1];

	pnt.occupied = true;
	pnt.missionId = id;
	pnt.id = 2; // Should it be 2?
	pnt thread beDropItem();
	dropPoints["allies"].id = 1;
	dropPoints["allies"].missionId = id;
	dropPoints["allies"] thread beDropPoint();
	dropPoints["axis"].id = 2;
	dropPoints["axis"].missionId = id;
	dropPoints["axis"] thread beDropPoint();
	level.missions[id].obj[0]["pos"] = pnt;
	level.missions[id].obj[0]["allies"] = "pickup";
	level.missions[id].obj[0]["axis"] = "pickup";
	level.missions[id].obj[1]["pos"] = dropPoints["allies"];
	level.missions[id].obj[1]["allies"] = "drop";
	level.missions[id].obj[1]["axis"] = "enemydrop";
	level.missions[id].obj[2]["pos"] = dropPoints["axis"];
	level.missions[id].obj[2]["allies"] = "enemydrop";
	level.missions[id].obj[2]["axis"] = "drop";

	// Time
	level.missions[id].maxTime = 500;
	level.missions[id].captureTime = 5;
	timeString = leftTimeToString(m.maxTime, "noh");

	// All players ~ missing objOnCompass() if there are takers?
	foreach (p as m.all; 0; +m.allCount)
	{
		p.objects = false;
		p.objIcons = [];
		p setClientDvars(
			"timeleft", timeString,
			"mission_title", "DROP",
			"mission_desc", "DROP",
			"items", 0
		);
	}

	// Show points and items
	foreach (e as allies;;+)
	{
		e objOnCompass(0, dropPoints["allies"].origin, "drop");
		e objOnCompass(1, dropPoints["axis"].origin, "enemydrop");
		e objOnCompass(2, pnt.origin, "pickup");
		dropPoints["allies"] thread showAll("enemy", e);
		dropPoints["axis"] thread showAll("friend", e);
	}
	foreach (e as axis;;+)
	{
		e objOnCompass(0, dropPoints["allies"].origin, "enemydrop");
		e objOnCompass(1, dropPoints["axis"].origin, "drop");
		e objOnCompass(2, pnt.origin, "pickup");
		dropPoints["axis"] thread showAll("enemy", e);
		dropPoints["allies"] thread showAll("friend", e);
	}

	level.missions[id].backupFunc = ::mission_drop_backup;
	level.missions[id].giveupFunc = ::mission_drop_giveup;
	level.missions[id].timeleft = timeString; // For backup
	level.missions[id].points = dropPoints; // For kick (too)
	level.missions[id].point = pnt; // For backup
	thread timeLimit(id, m.maxTime, ::mission_drop_timelimit);

	updateRespawnMap(id);

	// Save memory by freeing every variable in this function
	thread mission_drop_end(id);
}

mission_drop_end(id)
{
	level waittill("endmission" + id, winner, type); // allies or axis

	// Reset objects
	level.missions[id].points["allies"].id = undefined;
	level.missions[id].points["allies"].missionId = undefined;
	level.missions[id].points["allies"] hideAll();
	level.missions[id].points["axis"].id = undefined;
	level.missions[id].points["axis"].missionId = undefined;
	level.missions[id].points["axis"] hideAll();

	p = level.missions[id].point;
	p.occupied = undefined;
	p.id = undefined;
	p.missionId = undefined;
	if (!isDefined(p.taker))
	{
		p.obj delete();
		p.trigger delete();
	}
	else
	{
		p.taker killLoadBar();
		p.taker = undefined;
		p.put = undefined;
	}

	if (!isDefined(type))
		type = "COMPLETE";

	endMission(id, winner, type);
}

mission_drop_giveup(id, team)
{
	level notify("endmission" + id, team, "GIVEUP");
}

mission_drop_backup()
{
	id = self.missionId;
	m = level.missions[id];

	self.objects = false;
	self.objIcons = [];

	level.missions[id].points[self.team] thread showAll("enemy", self);
	level.missions[id].points[level.enemy[self.team]] thread showAll("friend", self);
	if (self.team == "allies")
	{
		self objOnCompass(0, m.points["allies"].origin, "drop");
		self objOnCompass(1, m.points["axis"].origin, "enemydrop");
	}
	else
	{
		self objOnCompass(1, m.points["allies"].origin, "enemydrop");
		self objOnCompass(0, m.points["axis"].origin, "drop");
	}
	if (isDefined(m.point.taker))
	{
		if (self.team == m.point.taker.team)
			self newMissionPoint("follow0", m.point.taker, "obj");
		else
			self newMissionPoint("pickup0", m.point.taker, "obj");
	}
	else
	{
		self objOnCompass(0, m.point.origin, "pickup");
	}

	self setClientDvars(
		"timeleft", m.timeleft,
		"mission_title", "DROP",
		"mission_desc", "DROP"
	);
}

mission_drop_timelimit(id)
{
	level notify("endmission" + id, "allies", "TIED");
}

beDropPoint()
{
	id = self.missionId;
	level endon("endmission" + id);

	while (true)
	{
		self waittill("trigger", player);
		if (isDefined(player.missionId) && player.missionId == id && isAlive(player) && self == level.missions[id].points[player.team] && player.objects && !isDefined(self.taker) && !isDefined(self.claimed))
		{
			self.taker = player;
			player loadBar(0, id);
			player thread drop();
		}
	}
}

drop()
{
	id = self.missionId;
	m = level.missions[id];
	self endon("disconnect");
	level endon("endmission" + id);

	point = m.points[self.team];
	point thread startSingleFlashing();
	curTime = 0.05;
	wait 0.05;
	while (curTime < m.captureTime && self isTouching(point) && isAlive(self) && !isDefined(self.claimed))
	{
		curTime += 0.05;
		wait 0.05;
	}

	if (curTime == m.captureTime && self isTouching(point) && !isDefined(self.claimed))
	{
		self target(1, true);
		self.objects = false;
		self setClientDvar("items", 0);
		foreach (p as m.all; 0; +m.allCount)
		{
			p destroyObject(0);
			p destroyObject(1);
			p setClientDvars(
				"counter1", "",
				"counter1text", ""
			);
		}
		level notify("endmission" + id, self.team);
	}
	else
	{
		point.taker = undefined;
		point.curTime = undefined;
		self killLoadBar();
	}
}

beDropItem(origin, angles)
{
	if (!isDefined(origin))
		origin = self.origin;
	if (!isDefined(angles))
		angles = self.angles;

	self.obj = spawn("script_model", origin);
	self.obj setModel("com_copypaper_box");
	self.obj.angles = angles;
	self.trigger = spawn("trigger_radius", origin, 0, 16, 16);

	id = self.missionId;
	while (isDefined(self.trigger))
	{
		self.trigger waittill("trigger", player);
		if (isDefined(player.missionId) && player.missionId == id && player useButtonPressed())
		{
			player thread watchPutObject();
			player thread watchPutObjectStun();
			player thread watchPutObjectDisconnect();
			player.objects = true;
			player setClientDvar("items", 1);
			self.obj delete();
			self.trigger delete();
			self.taker = player;
			level.missions[id].obj[0] = undefined;
			//level.missions[self.missionId].obj[0]["pos"] = player;
			//level.missions[self.missionId].obj[0][player.team] = "follow";
			//level.missions[self.missionId].obj[0][level.enemy[player.team]] = "pickup";

			foreach (t as level.teams[level.missions[id].team[player.team]];;+)
			{
				t destroyObject(2);

				if (t != player)
					t newMissionPoint("follow0", player, "obj");
			}
			foreach (t as level.teams[level.missions[id].team[level.enemy[player.team]]];;+)
			{
				t destroyObject(2);
				t newMissionPoint("pickup0", player, "obj");
			}
		}
	}
}

watchPutObject()
{
	self endon("putitem");
	self endon("endmission");

	self waittill("killed_player");
	self thread putObject();
}

watchPutObjectStun()
{
	self endon("putitem");
	self endon("endmission");

	self waittill("stunned");
	self thread putObject();
}

watchPutObjectDisconnect()
{
	self endon("putitem");
	self endon("endmission");

	self waittill("disconnect", origin, angles);
	self putObject(origin, angles);
}

putObject(origin, angles)
{
	self notify("putitem");

	if (isPlayer(self))
	{
		self.objects = false;
		self setClientDvar("items", 0);

		origin = self.origin;
		angles = self.angles;
	}

	id = self.missionId;
	item = level.missions[id].point;

	origin = physicsTrace(origin, origin - (0, 0, 1000));

	item.taker = undefined;
	item thread beDropItem(origin, angles);
	level.missions[id].obj[0]["pos"] = item;
	level.missions[id].obj[0]["allies"] = "pickup";
	level.missions[id].obj[0]["axis"] = "pickup";

	foreach (p as level.missions[id].all; 0; +level.missions[id].allCount)
	{
		p objOnCompass(2, origin, "pickup");
	}
}

//-----------------------------------/
// DESTROY                           /
//-----------------------------------/
mission_destroy(id)
{
	// Generate attackers and defenders
	if (randomInt(2))
		level.missions[id].attackTeam = "allies";
	else
		level.missions[id].attackTeam = "axis";

	m = level.missions[id];
	level.missions[id].defendTeam = level.enemy[m.attackTeam];

	def = level.teams[m.team[m.defendTeam]];
	att = level.teams[m.team[m.attackTeam]];

	// Get the most optimal point
	attOrigin = averagePos(att);
	defOrigin = averagePos(def);
	pnt = level.destroyPoints[0];
	dis = -1;
	foreach (p as level.destroyPoints;;+)
	{
		if (!isDefined(p.occupied))
		{
			defDist = distanceSquared(defOrigin, p.origin);
			attDist = distanceSquared(attOrigin, p.origin);
			newDis = abs(defDist - attDist);
			if (dis == -1 || newDis < dis)
			{
				pnt = p;
				dis = newDis;
			}
		}
	}

	// No more free destroy points
	// It must be impossible on a completed map
	if (dis == -1)
	{
		level.missions[id].currentStage--;
		thread newObj(id);
		return;
	}

	points = pnt.points;
	c = points.size;
	pnt.occupied = true;
	pnt.id = c;
	foreach (p as i:points; 0; +c)
	{
		p show();
		p.id = i;
		p.missionId = id;
		p.destroyed = false;
		p.dmg = 0;
		p setCanDamage(true);
		p thread beDestroyObj();
		level.missions[id].obj[i]["pos"] = p;
		level.missions[id].obj[i][m.attackTeam] = "destroy";
		level.missions[id].obj[i][m.defendTeam] = "defend";
	}

	// Min damage
	level.missions[id].damage = 500;

	// Time
	level.missions[id].maxTime = c * 100;
	timeString = leftTimeToString(m.maxTime, "noh");

	// All players
	foreach (e as j:points;;+c)
	{
		foreach (p as att;;+)
			p objOnCompass(j, e.origin, "destroy");

		foreach (p as def;;+)
			p objOnCompass(j, e.origin, "defend");
	}
	foreach (e as m.all; 0; +m.allCount)
	{
		e setClientDvars(
			"counter1", "0/" + c,
			"counter1text", "DESTROYED_OBJECTS",
			"timeleft", timeString,
			"mission_title", "DESTROY",
			"mission_desc", "DESTROY"
		);
	}

	// Setup
	level.missions[id].destroyed = 0;
	level.missions[id].points = points;
	level.missions[id].point = pnt;
	level.missions[id].pointCount = c;
	level.missions[id].backupFunc = ::mission_destroy_backup;
	level.missions[id].giveupFunc = ::mission_destroy_giveup;
	level.missions[id].timeleft = timeString; // For backup
	thread timeLimit(id, m.maxTime, ::mission_destroy_timelimit);

	updateRespawnMap(id);

	// Save memory by freeing every variable in this function
	thread mission_destroy_end(id);
}

mission_destroy_end(id)
{
	level waittill("endmission" + id, winner, giveup);

	// Restore points
	level.missions[id].point.occupied = undefined;
	foreach (p as level.missions[id].points;;+level.missions[id].pointCount)
	{
		if (p.destroyed)
		{
			p thread waitAndShowModel();
		}
		p.destroyed = undefined;
		p.missionId = undefined;
		p setCanDamage(false);
		//pnt.points[i].dmg = undefined; // undefined is not an int...
	}

	// End
	if (isDefined(giveup))
		endMission(id, winner, "GIVEUP");
	else if (winner == "defend")
		endMission(id, level.missions[id].defendTeam, "COMPLETE");
	else
		thread newObj(id);
}

mission_destroy_giveup(id, team)
{
	level notify("endmission" + id, team, true);
}

mission_destroy_timelimit(id)
{
	level notify("endmission" + id, "defend");
}

mission_destroy_backup()
{
	m = level.missions[self.missionId];
	defender = self.team == m.defendTeam;

	self.objIcons = [];
	c = m.pointCount;
	foreach (p as i:m.points;;+c)
	{
		if (isDefined(p.dmg))
		{
			if (defender)
				self objOnCompass(i, p.origin, "defend");
			else
				self objOnCompass(i, p.origin, "destroy");
		}
	}
	self setClientDvars(
		"counter1", m.destroyed + "/" + c,
		"counter1text", "DESTROYED_OBJECTS",
		"timeleft", m.timeLeft,
		"mission_title", "DESTROY",
		"mission_desc", "DESTROY"
	);
}

beDestroyObj()
{
	id = self.missionId;
	m = level.missions[id];
	level endon("endmission" + id);

	while (true)
	{
		self waittill("damage", damage, attacker);
		if (isDefined(attacker.missionId) && attacker.missionId == id && attacker.team == m.attackTeam)
		{
			self.dmg += damage;
			if (self.dmg >= m.damage)
			{
				attacker target(1);
				level.missions[id].destroyed++;
				playFX(level.destroyFX, self.origin);
				self hide();
				self.destroyed = true;
				level.missions[id].obj[self.id] = undefined;

				if (m.destroyed != m.pointCount)
				{
					//self.dmg = undefined;
					self setCanDamage(false);
					foreach (p as m.all;;+m.allCount)
					{
						p destroyObject(self.id);
						p setClientDvar("counter1", m.destroyed + "/" + m.pointCount);
					}
					break;
				}
				else
				{
					foreach (p as m.all;;+m.allCount)
					{
						p destroyObject(self.id);
						p setClientDvars(
							"counter1", "",
							"counter1text", ""
						);
					}
					level notify("endmission" + id, "attack");
				}
			}
		}
	}
}

waitAndShowModel()
{
	wait 30;

	// It is not shown in a new mission yet
	if (!isDefined(self.destroyed))
		self show();
}

//-----------------------------------/
// DEFUSE                            /
//-----------------------------------/
mission_defuse(id)
{
	m = level.missions[id];
	if (level.tutorial)
	{
		// Make player the attackerin tutorial district
		if (isDefined(level.teams[m.team["allies"]][0].isBot))
			level.missions[id].attackTeam = "axis";
		else
			level.missions[id].attackTeam = "allies";
	}
	else
	{
		// Generate attackers and defenders
		if (randomInt(2))
			level.missions[id].attackTeam = "allies";
		else
			level.missions[id].attackTeam = "axis";
	}

	level.missions[id].defendTeam = level.enemy[m.attackTeam];

	def = level.teams[m.team[m.defendTeam]];
	att = level.teams[m.team[m.attackTeam]];

	// Get the most optimal point
	attOrigin = averagePos(att);
	defOrigin = averagePos(def);
	pnt = level.defusePoints[0];
	dis = -1;
	foreach (p as level.defusePoints;;+)
	{
		if (!isDefined(p.occupied))
		{
			defDist = distanceSquared(defOrigin, p.origin);
			attDist = distanceSquared(attOrigin, p.origin);
			newDis = abs(defDist - attDist);
			if (dis == -1 || newDis < dis)
			{
				pnt = p;
				dis = newDis;
			}
		}
	}

	// No more free defuse points
	// It must be impossible on a completed map
	if (dis == -1)
	{
		level.missions[id].currentStage--;
		thread newObj(id);
		return;
	}

	pnt.occupied = true;
	points = pnt.points;
	c = points.size;
	pnt.id = c;
	foreach (p as i:points;;+c)
	{
		p show();
		p.object show();
		p.id = i;
		p.missionId = id;
		p.destroyed = false;
		p thread beDefuseObj();
		level.missions[id].obj[i]["pos"] = p;
		level.missions[id].obj[i][m.attackTeam] = "defuse";
		level.missions[id].obj[i][m.defendTeam] = "defend";
	}

	// Defuse Time
	level.missions[id].captureTime = 5; // loadBar() needs captureTime

	// Time
	level.missions[id].maxTime = c * 100;
	timeString = leftTimeToString(m.maxTime, "noh");

	// All players
	foreach (p as j:points;;+c)
	{
		foreach (e as att;;+)
		{
			e objOnCompass(j, p.origin, "defuse");
		}
		foreach (e as def;;+)
		{
			e objOnCompass(j, p.origin, "defend");
		}
	}
	foreach (p as m.all;;+m.allCount)
	{
		p setClientDvars(
			"counter1", "0/" + c,
			"counter1text", "DEFUSED_BOMBS",
			"timeleft", timeString,
			"mission_title", "DEFUSE",
			"mission_desc", "DEFUSE"
		);
	}

	// Setup
	level.missions[id].destroyed = 0;
	level.missions[id].points = points;
	level.missions[id].pointsize = c;
	level.missions[id].point = pnt;
	level.missions[id].backupFunc = ::mission_defuse_backup;
	level.missions[id].giveupFunc = ::mission_defuse_giveup;
	level.missions[id].timeleft = timeString; // For backup

	// Tutorial delay
	if (level.tutorial)
		att[0] thread mission_defuse_tutdelay();
	else
		thread timeLimit(id, m.maxTime, ::mission_defuse_timelimit); // Wait till the end

	updateRespawnMap(id);

	// Save memory by freeing every variable in this function
	thread mission_defuse_end(id);
}

mission_defuse_end(id)
{
	level waittill("endmission" + id, winner, giveup);

	// Restore points
	level.missions[id].point.occupied = undefined;
	foreach (p as level.missions[id].points;;+level.missions[id].pointsize)
	{
		if (!p.destroyed)
		{
			p hide();
			p.object hide();
			if (isDefined(p.taker))
			{
				p.taker endPlant();
				p.taker = undefined;
			}
		}
		p.missionId = undefined;
		p.destroyed = undefined;
	}

	// End
	if (isDefined(giveup))
		endMission(id, winner, "GIVEUP");
	else if (winner == "defend")
		endMission(id, level.missions[id].defendTeam, "COMPLETE");
	else
		thread newObj(id);
}

mission_defuse_tutdelay()
{
	self endon("disconnect");

	self.tut = 3;
	self setClientDvar("tutid", 3);
	self openMenu(game["menu_tutorial"]);
	self waittill("tut_beginmission");

	thread timeLimit(self.missionID, level.missions[self.missionID].maxTime, ::mission_defuse_timelimit);
}

mission_defuse_giveup(id, team)
{
	level notify("endmission" + id, team, true);
}

mission_defuse_timelimit(id)
{
	level endon("endmission" + id);

	// Overtime
	over = false;
	foreach (p as i:level.missions[id].points;;+level.missions[id].pointsize)
	{
		if (isDefined(p.taker))
		{
			if (!over)
			{
				overtimeMessage(id);
				over = true;
			}

			p waittill("endplant");
			i = 0;
			continue;
		}
	}

	level notify("endmission" + id, "defend");
}

mission_defuse_backup()
{
	m = level.missions[self.missionId];
	defender = self.team == m.defendTeam;

	self.objIcons = [];
	foreach (p as i:m.points;;+m.pointsize)
	{
		if (isDefined(p.dmg))
		{
			if (defender)
				self objOnCompass(i, p.origin, "defend");
			else
				self objOnCompass(i, p.origin, "defuse");
		}
	}
	self setClientDvars(
		"counter1", m.destroyed + "/" + m.pointsize,
		"counter1text", "DEFUSED_BOMBS",
		"timeleft", m.timeLeft,
		"mission_title", "DEFUSE",
		"mission_desc", "DEFUSE"
	);
}

beDefuseObj()
{
	id = self.missionId;
	level endon("endmission" + id);
	self endon("destroyed");

	while (true)
	{
		self waittill("trigger", player);
		if (!isDefined(self.taker) && player useButtonPressed() && isAlive(player) && isDefined(player.missionId) && player.missionTeam == level.missions[id].team[level.missions[id].attackTeam] && !player.throwingGrenade && !isDefined(self.claimed))
		{
			self.taker = player;
			self.object hide();
			self thread startSingleFlashing();
			player thread defuse(self);
		}
		wait 0.05;
	}
}

defuse(point)
{
	id = point.missionId;
	m = level.missions[id];
	level endon("endmission" + id);

	self thread giveBomb(point);

	// Start after 0.05
	curTime = 0.05;
	wait 0.05;
	while (isDefined(self) && curTime < m.captureTime && self isTouching(point) && isAlive(self) && self useButtonPressed() && !self.throwingGrenade && !isDefined(self.claimed))
	{
		curTime += 0.05;
		wait 0.05;
	}

	if (isDefined(self) && curTime == m.captureTime && self isTouching(point) && isAlive(self) && self useButtonPressed() && !self.throwingGrenade && !isDefined(self.claimed))
	{
		self target(1);
		level.missions[id].destroyed++;
		level.missions[id].obj[point.id] = undefined;

		foreach (p as m.all;;+m.allCount)
		{
			p destroyObject(point.id);
		}
		if (m.destroyed == m.pointsize)
		{
			foreach (p as m.all;;+m.allCount)
			{
				p setClientDvars(
					"counter1", "",
					"counter1text", ""
				);
			}
			level notify("endmission" + id, "attack");
		}
		else
		{
			point.destroyed = true;
			point hide();
			point notify("destroyed");
			d = m.destroyed + "/" + m.pointsize;
			foreach (p as m.all;;+m.allCount)
			{
				p setClientDvar("counter1", d);
				p thread mainLine(level.s["DEFUSED_BOMBS_" + p.lang] + ": " + d);
			}
		}
	}
	else
	{
		point.object show();
	}

	point.taker = undefined;

	if (isDefined(self))
		self endPlant();

	point notify("endplant");
}

//-----------------------------------/
// PLANT                             /
//-----------------------------------/
mission_plant(id)
{
	// Generate attackers and defenders
	if (randomInt(2))
		level.missions[id].attackTeam = "allies";
	else
		level.missions[id].attackTeam = "axis";

	m = level.missions[id];
	level.missions[id].defendTeam = level.enemy[m.attackTeam];

	def = level.teams[m.team[m.defendTeam]];
	att = level.teams[m.team[m.attackTeam]];

	// Get the most optimal point
	attOrigin = averagePos(att);
	defOrigin = averagePos(def);
	pnt = level.plantPoints[0];
	dis = -1;
	foreach (p as level.plantPoints;;+)
	{
		if (!isDefined(p.occupied))
		{
			&defDist = distanceSquared(defOrigin, p.origin);
			&attDist = distanceSquared(attOrigin, p.origin);
			newDis = abs(defDist - attDist);
			if (dis == -1 || newDis < dis)
			{
				pnt = p;
				dis = newDis;
			}
		}
	}

	// No more free defuse points
	// It must be impossible on a completed map
	if (dis == -1)
	{
		level.missions[id].currentStage--;
		thread newObj(id);
		return;
	}

	pnt.occupied = true;
	pnt.owner = m.defendTeam;
	pnt.id = 0; // For flashing
	pnt.missionId = id;
	pnt show();
	pnt.object show();
	pnt thread bePlantObj();
	level.missions[id].obj[0]["pos"] = pnt;
	level.missions[id].obj[0][m.attackTeam] = "defuse";
	level.missions[id].obj[0][m.defendTeam] = "defend";

	// Defuse Time
	level.missions[id].captureTime = 5; // loadBar() needs captureTime
	level.missions[id].fuseTime = 180;

	// Time
	level.missions[id].maxTime = int(m.fuseTime * 2.5);
	timeString = leftTimeToString(m.maxTime, "noh");

	// All players
	foreach (e as att;;+)
	{
		e objOnCompass(0, pnt.origin, "plant");
	}
	foreach (e as def;;+)
	{
		e objOnCompass(0, pnt.origin, "defend");
	}
	foreach (e as m.all;;+m.allCount)
	{
		e setClientDvars(
			"counter1", leftTimeToString(m.fuseTime, "noh shortm"),
			"counter1text", "FUSE_TIME",
			"timeleft", timeString,
			"mission_title", "PLANT",
			"mission_desc", "PLANT"
		);
	}

	// Setup
	level.missions[id].backupFunc = ::mission_plant_backup;
	level.missions[id].giveupFunc = ::mission_plant_giveup;
	level.missions[id].timeleft = timeString; // For backup
	level.missions[id].point = pnt;
	thread timeLimit(id, m.maxTime, ::mission_plant_timelimit);

	updateRespawnMap(id);

	// Save memory by freeing every variable in this function
	thread mission_plant_end(id);
}

mission_plant_end(id)
{
	level waittill("endmission" + id, winner, giveup);

	// Restore points
	p = level.missions[id].point;
	p.occupied = undefined;
	p.missionId = undefined;
	p hide();
	p.object hide();
	if (isDefined(p.taker))
	{
		p.taker endPlant();
		p.taker = undefined;
	}

	// End
	if (isDefined(giveup))
		type = "GIVEUP";
	else
		type = "COMPLETE";

	endMission(id, winner, type);
}

mission_plant_giveup(id, team)
{
	level notify("endmission" + id, team, true);
}

mission_plant_timelimit(id)
{
	level notify("endmission" + id, level.missions[id].defendTeam);
}

mission_plant_backup()
{
	m = level.missions[self.missionId];

	self.objIcons = [];
	if (m.point.owner == self.team)
	{
		self objOnCompass(0, m.point.origin, "defend");
	}
	else
	{
		if (self.team == m.defendTeam)
			self objOnCompass(0, m.point.origin, "defuse");
		else
			self objOnCompass(0, m.point.origin, "plant");
	}
	self setClientDvars(
		"counter1", leftTimeToString(m.fuseTime, "noh shortm"),
		"counter1text", "FUSE_TIME",
		"timeleft", m.timeLeft,
		"mission_title", "PLANT",
		"mission_desc", "PLANT"
	);
}

bePlantObj()
{
	id = self.missionId;
	level endon("endmission" + id);
	self endon("destroyed");

	while (true)
	{
		self waittill("trigger", player);
		if (!isDefined(self.taker) && player useButtonPressed() && isAlive(player) && isDefined(player.missionId) && player.missionId == id && self.owner != player.team && !player.throwingGrenade && !isDefined(player.claimed))
		{
			self.taker = player;
			self.object hide();
			self thread startSingleFlashing();
			player thread plant(self);
		}
		wait 0.05;
	}
}

plant(point)
{
	id = point.missionId;
	m = level.missions[id];
	level endon("endmission" + id);

	self thread giveBomb(point);

	// Start after 0.05
	curTime = 0.05;
	wait 0.05;
	while (isDefined(self) && curTime < id.captureTime && self isTouching(point) && isAlive(self) && self useButtonPressed() && !self.throwingGrenade && !isDefined(self.claimed))
	{
		curTime += 0.05;
		wait 0.05;
	}

	if (isDefined(self) && curTime == m.captureTime && self isTouching(point) && isAlive(self) && self useButtonPressed() && !self.throwingGrenade && !isDefined(self.claimed))
	{
		self target(1);
		point.owner = self.team;
		attacker = self.team == m.attackTeam;
		if (attacker)
			level.missions[id].countFuseTime = true;
		else
			level.missions[id].countFuseTime = undefined;

		foreach (p as level.teams[m.team[m.attackTeam]];;+)
		{
			if (attacker)
				p objOnCompass(0, m.point.origin, "defend");
			else
				p objOnCompass(0, m.point.origin, "plant");
		}
		foreach (p as level.teams[m.team[m.defendTeam]];;+)
		{
			if (attacker)
				p objOnCompass(0, m.point.origin, "defuse");
			else
				p objOnCompass(0, m.point.origin, "defend");
		}

		level.missions[id].obj[0][self.team] = "defend";
		//if (attacker)
			level.missions[id].obj[0][level.enemy[self.team]] = "defuse";
		//else
			//level.missions[point.missionId].obj[0][level.enemy[self.team]] = "plant";
	}

	point.object show();
	point.taker = undefined;
	if (isDefined(self))
	{
		self endPlant();
	}
}