














main()
{
maps\mp\gametypes\_callbacksetup::SetupCallbacks();
level.callbackStartGameType=::Callback_StartGameType;
level.callbackPlayerConnect=::Callback_PlayerConnect;
level.callbackPlayerDisconnect=::Callback_PlayerDisconnect;
level.callbackPlayerDamage=::Callback_PlayerDamage;
level.callbackPlayerSay=::Callback_PlayerSay;
level.callback=::Callback_PlayerKilled;

level.script=toLower(getDvar("mapname"));
}

Callback_StartGameType()
{
setDvar("g_teamname_axis","^9Criminals");
setDvar("g_teamname_allies","^8Enforcers");
setDvar("sv_floodProtect",1);
setDvar("sv_maxRate",25000);
setDvar("sv_pure",1);
setDvar("g_antilag",1);
setDvar("sv_allowAnonymous",0);
setDvar("bg_fallDamageMinHeight",140);
setDvar("bg_fallDamageMaxHeight",350);
setDvar("player_throwbackInnerRadius",0);
setDvar("player_throwbackOuterRadius",0);
setDvar("player_sprinttime",6.4);
setDvar("g_friendlyPlayerCanBlock",1);
setDvar("sv_authorizemode",0);
setDvar("rcon_password","testrcon");
setDvar("sv_wwwDownload",1);
setDvar("sv_wwwBaseURL","http://mezesmadzag.hu");
setDvar("sv_master2","cod4master.akthvision.com");

level.social=getDvar("gamemode")=="social";
level.tutorial=getDvar("gamemode")=="tutorial";
level.action=getDvar("gamemode")=="action";


level.gamemodes["social"]=true;
level.gamemodes["tutorial"]=true;
level.gamemodes["action"]=true;

level.teams=[];
level.missions=[];
level.placedPoints=[];
level.players=[];
level.groups=[];
level.readyPlayers["allies"]=[];
level.readyPlayers["axis"]=[];
level.readyGroups["allies"]=[];
level.readyGroups["axis"]=[];
level.activePlayers["allies"]=[];
level.activePlayers["axis"]=[];
level.allActivePlayers=[];
level.activeCount["allies"]=0;
level.activeCount["axis"]=0;
level.allActiveCount=0;



thread maps\mp\gametypes\_menus::init();
thread maps\mp\gametypes\_weapons::init();
thread maps\mp\gametypes\_rank::init();
thread maps\mp\gametypes\_damagefeedback::init();
thread maps\mp\gametypes\_healthoverlay::init();

/#thread maps\mp\gametypes\_dev::init();
#/






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
game["allies_model"][1]=mptype\mptype_ally_usmc_cqb::main;
game["allies_model"][2]=mptype\mptype_ally_support::main;
game["allies_model"][3]=mptype\mptype_ally_rifleman::main;
game["allies_model"][4]=mptype\mptype_ally_engineer::main;
game["allies_model"][5]=mptype\mptype_ally_cqb::main;
game["allies_model"][6]=mptype\mptype_ally_urban_sniper::main;
game["allies_model"][7]=mptype\mptype_ally_urban_support::main;
game["allies_model"][8]=mptype\mptype_ally_urban_assault::main;
game["allies_model"][9]=mptype\mptype_ally_urban_recon::main;
game["allies_model"][10]=mptype\mptype_ally_urban_specops::main;
game["allies_model"][11]=mptype\mptype_ally_woodland_sniper::main;
game["allies_model"][12]=mptype\mptype_ally_woodland_support::main;
game["allies_model"][13]=mptype\mptype_ally_woodland_assault::main;
game["allies_model"][14]=mptype\mptype_ally_woodland_recon::main;
game["allies_model"][15]=mptype\mptype_ally_woodland_specops::main;
game["allies_model"][16]=mptype\mptype_ally_sniper::main;

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
game["axis_model"][1]=mptype\mptype_axis_boris::main;
game["axis_model"][2]=mptype\mptype_axis_support::main;
game["axis_model"][3]=mptype\mptype_axis_rifleman::main;
game["axis_model"][4]=mptype\mptype_axis_engineer::main;
game["axis_model"][5]=mptype\mptype_axis_cqb::main;
game["axis_model"][6]=mptype\mptype_axis_urban_sniper::main;
game["axis_model"][7]=mptype\mptype_axis_urban_support::main;
game["axis_model"][8]=mptype\mptype_axis_urban_assault::main;
game["axis_model"][9]=mptype\mptype_axis_urban_engineer::main;
game["axis_model"][10]=mptype\mptype_axis_urban_cqb::main;
game["axis_model"][11]=mptype\mptype_axis_woodland_sniper::main;
game["axis_model"][12]=mptype\mptype_axis_woodland_support::main;
game["axis_model"][13]=mptype\mptype_axis_woodland_rifleman::main;
game["axis_model"][14]=mptype\mptype_axis_woodland_engineer::main;
game["axis_model"][15]=mptype\mptype_axis_woodland_cqb::main;
game["axis_model"][16]=mptype\mptype_axis_sniper::main;


preCacheModel("tag_origin");
preCacheModel("com_copypaper_box");
preCacheModel("com_plasticcase_beige_rifle");
preCacheModel("com_golden_brick");
preCacheModel("prop_suitcase_bomb");

preCacheStatusIcon("hud_status_connecting");


preCacheShellShock("stun");

preCacheShader("arrestpnt");
preCacheShader("enemypnt");
preCacheShader("friendpnt");
preCacheShader("publicenemypnt");
preCacheShader("publicfriendpnt");
preCacheShader("teampublicenemypnt");
preCacheShader("teampublicfriendpnt");
preCacheShader("ofpublicenemypnt");

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

for(i=1;i<=24;i++)
{
preCacheShader("medal_"+tableLookup("mp/medalTable.csv",0,i,1));
}
for(i=0;i<9;i++)
{
preCacheShader(tableLookup("mp/roleTable.csv",0,i,2));
}


if(level.tutorial)
level.maxClients=int(getDvarInt("sv_maxclients")/2);
else
 level.maxClients=getDvarInt("sv_maxclients");


level.vendorTypes[0]="weapons";
level.vendorTypes[1]="inv";
level.vendorTypes[2]="mods";
level.vendorTypes[3]="camo";
level.vendorTypes[4]="ammo";
level.vendorTypes[5]="mail";
level.vendorTypes[6]="studio";
level.vendorTypes[7]="dress";
__v0=level.vendorTypes;for(__i0=0;__i0<8;__i0++)
{
preCacheShader("pin_"+__v0[__i0]);
}__i0=undefined;__v0=undefined;


level.defaultWeapon["primary"]=26;
level.defaultWeapon["secondary"]=8;
level.defaultWeapon["offhand"]=63;
level.defaultAmmo["rifle"]=360;
level.defaultAmmo["pistol"]=180;
level.defaultAmmo["frag"]=4;


if(sql_run())
{
sql_reset();
}
sql_init("192.168.1.96",7425);







sql_exec("CREATE TABLE IF NOT EXISTS players (name varchar(15) PRIMARY KEY NOT NULL, pass varchar(15) NOT NULL, dress int(2) NOT NULL DEFAULT 1, faction int(1) NOT NULL DEFAULT 1, money int(10) NOT NULL DEFAULT 500, symbol int(3) NOT NULL DEFAULT 0, achievements int(5) NOT NULL DEFAULT 0, premiumtime int(6) NOT NULL DEFAULT 0, role_rifle int(6) NOT NULL DEFAULT 0, role_machinegun int(6) NOT NULL DEFAULT 0, role_pistol int(6) NOT NULL DEFAULT 0, role_sniper int(6) NOT NULL DEFAULT 0, role_marksman int(6) NOT NULL DEFAULT 0, role_shotgun int(6) NOT NULL DEFAULT 0, role_rocket int(6) NOT NULL DEFAULT 0, role_grenade int(6) NOT NULL DEFAULT 0, role_nonlethal int(6) NOT NULL DEFAULT 0, mod_green int(2) NOT NULL DEFAULT 0, mod_red int(2) NOT NULL DEFAULT 0, mod_blue int(2) NOT NULL DEFAULT 0, prime int(3) NOT NULL DEFAULT "+level.defaultWeapon["primary"]+", secondary int(3) NOT NULL DEFAULT "+level.defaultWeapon["secondary"]+", offhand int(3) NOT NULL DEFAULT "+level.defaultWeapon["offhand"]+", mis_win int(4) NOT NULL DEFAULT 0, mis_lose int(4) NOT NULL DEFAULT 0, mis_tied int(4) NOT NULL DEFAULT 0, allrun int(9) NOT NULL DEFAULT 0, assists int(6) NOT NULL DEFAULT 0, kills int(6) NOT NULL DEFAULT 0, arrests int(6) NOT NULL DEFAULT 0, stuns int(6) NOT NULL DEFAULT 0, medals int(6) NOT NULL DEFAULT 0, regenhealth int(7) NOT NULL DEFAULT 0, backupcalled int(4) NOT NULL DEFAULT 0, startedgroups int(4) NOT NULL DEFAULT 0, delivereditems int(4) NOT NULL DEFAULT 0, missiontime int(7) NOT NULL DEFAULT 0, prestigetime int(6) NOT NULL DEFAULT 0, standing int(7) NOT NULL DEFAULT 0, lang int(2) NOT NULL DEFAULT 0, ammo_rifle int(5) NOT NULL DEFAULT "+level.defaultAmmo["rifle"]+", ammo_machinegun int(5) NOT NULL DEFAULT 0, ammo_pistol int(5) NOT NULL DEFAULT "+level.defaultAmmo["pistol"]+", ammo_desert int(5) NOT NULL DEFAULT 0, ammo_shotgun int(5) NOT NULL DEFAULT 0, ammo_sniper int(5) NOT NULL DEFAULT 0, ammo_rocket int(5) NOT NULL DEFAULT 0, ammo_frag int(5) NOT NULL DEFAULT "+level.defaultAmmo["frag"]+", ammo_flash int(5) NOT NULL DEFAULT 0, ammo_concussion int(5) NOT NULL DEFAULT 0, ammo_nonlethal int(5) NOT NULL DEFAULT 0, rep int(6) NOT NULL DEFAULT 0, reptime int(10) NOT NULL DEFAULT 0, gmt int(2) NOT NULL DEFAULT '1', format int(2) NOT NULL DEFAULT '3', date int(2) NOT NULL DEFAULT '10', theme int(1) NOT NULL DEFAULT 0, inv varchar(15) NOT NULL DEFAULT '', admin int(10) NOT NULL DEFAULT 0, hats int(10) NOT NULL DEFAULT 0, packs int(10) NOT NULL DEFAULT 0, misc int(10) NOT NULL DEFAULT 0, curhat int(2) NOT NULL DEFAULT 0, curpack int(2) NOT NULL DEFAULT 0, curmisc int(10) NOT NULL DEFAULT 0, status varchar(16) NOT NULL DEFAULT 'Offline', timestamp int(10) NOT NULL DEFAULT NULL, level1 int(10) NOT NULL DEFAULT 0, level2 int(10) NOT NULL DEFAULT 0, maxweapons int(3) NOT NULL DEFAULT 14, maxinv int(3) NOT NULL DEFAULT 14, maxmods int(3) NOT NULL DEFAULT 14, symbols int(10) NOT NULL DEFAULT 0)");

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
sql_exec("CREATE TABLE IF NOT EXISTS wars (winner varchar(15) NOT NULL, loser varchar(15) NOT NULL, type int(1) NOT NULL DEFAULT 4, winner0 varchar(15) NOT NULL, winner1 varchar(15) NOT NULL, winner2 varchar(15), winner3 varchar(15), loser0 varchar(15) NOT NULL, loser1 varchar(15) NOT NULL, loser2 varchar(15), loser3 varchar(15), time int(10) NOT NULL, tied int(1) NOT NULL DEFAULT 0, FOREIGN KEY(winner0, winner1, winner2, winner3, loser0, loser1, loser2, loser3) REFERENCES players(name, name, name, name, name, name, name, name) ON UPDATE CASCADE)");
sql_exec("CREATE INDEX IF NOT EXISTS time_ ON wars (time DESC)");
sql_exec("CREATE TABLE IF NOT EXISTS bugs (bugid INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(15) NOT NULL, subject varchar(32) NOT NULL, msg varchar(960) NOT NULL, status int(1) NOT NULL DEFAULT 1, time int(10) NOT NULL, FOREIGN KEY(name) REFERENCES players(name) ON UPDATE CASCADE)");
sql_exec("CREATE TABLE IF NOT EXISTS don (donid INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(15) NOT NULL, cash int(10) NOT NULL, time int(10) NOT NULL, clan varchar(15) NOT NULL, FOREIGN KEY(name) REFERENCES players(name) ON UPDATE CASCADE, FOREIGN KEY(clan) REFERENCES clans(clan) ON UPDATE CASCADE)");
sql_exec("CREATE TABLE IF NOT EXISTS inv (invid INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(15) NOT NULL, item varchar(16) NOT NULL, itemtype varchar(16) NOT NULL DEFAULT '', FOREIGN KEY(name) REFERENCES players(name) ON UPDATE CASCADE)");
sql_exec("CREATE TABLE IF NOT EXISTS servers (ip varchar(39) PRIMARY KEY, name varchar(15) NOT NULL, heartbeat varchar(16) NOT NULL, count_all INTEGER NOT NULL, count_allies INTEGER NOT NULL, count_axis INTEGER NOT NULL, count_max INTEGER NOT NULL, gamemode varchar(16) NOT NULL)");
sql_exec("DELETE FROM servers WHERE heartbeat < "+(getRealTime()-60));




















sql_exec("UPDATE players SET admin = 2147483647 WHERE name = 'iCore'");





level.server=getDvar("server");
setDvar("sv_hostname","^1APB Mod ^7- ^2"+level.server);


if(getDvarInt("developer_script"))
level.developer=true;
else
 level.developer=false;


level.langs[0]="EN";
level.langs[1]="HU";
level.langs[2]="HR";
level.langs[3]="TR";
level.langs[4]="SR";
level.langs[5]="PL";
level.langs[6]="DE";
level.langs[7]="CS";
level.langs[8]="SK";


level.roleList[0]="rifle";
level.roleList[1]="machinegun";
level.roleList[2]="pistol";
level.roleList[3]="sniper";
level.roleList[4]="marksman";
level.roleList[5]="shotgun";
level.roleList[6]="rocket";
level.roleList[7]="grenade";
level.roleList[8]="nonlethal";


level.format[1]="HH:MM (12)";
level.format[2]="HH.MM (12)";
level.format[3]="HH:MM (24)";
level.format[4]="HH.MM (24)";


level.date[1]="DD.MM.YY";
level.date[2]="DD.MM.YYYY";
level.date[3]="MM.DD.YY";
level.date[4]="MM.DD.YYYY";
level.date[5]="MM/DD/YY";
level.date[6]="MM/DD/YYYY";
level.date[7]="DD.MM";
level.date[8]="MM/DD";
level.date[9]="YY.MM.DD";
level.date[10]="YYYY.MM.DD";
level.date[11]="YYYY-MM-DD";


level.defaultTheme="Default:norise-0, , , , , , , ,1, , , , , , ,2, , , , , , , ,3, , , , , , , , |8bit- , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , |8bit- , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , |8bit- , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , |8bit- , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , |8bit- , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , |8bit- , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , |8bit- , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , ";


level.infocols="";
level.infoCount=int(tableLookup("mp/infoTable.csv",0,"infos",1));
for(i=1;i<=level.infoCount;i++)
{
level.info[i]["name"]=tableLookup("mp/infoTable.csv",0,i,1);
level.info[i]["type"]=tableLookup("mp/infoTable.csv",0,i,2);
if(i!=1)
level.infocols+=", ";

level.infocols+=level.info[i]["name"];
}


level.hatCount=int(tableLookup("mp/hatTable.csv",0,"hatcount",1));
level.hats=[];
count=1;
for(i=1;i<=level.hatCount;i++)
{
level.hats[i]=spawnStruct();
level.hats[i].model=tableLookup("mp/hatTable.csv",0,"hat"+i,1);
level.hats[i].bit=count;
level.hats[i].price=int(tableLookup("mp/hatTable.csv",0,"hat"+i,2));
level.hats[i].name=tableLookup("mp/hatTable.csv",0,"hat"+i,3);
preCacheModel(level.hats[i].model);
count*=2;
}


level.bpCount=int(tableLookup("mp/hatTable.csv",0,"bpcount",1));
level.bps=[];
count=1;
for(i=1;i<=level.bpCount;i++)
{
level.bps[i]=spawnStruct();
level.bps[i].model=tableLookup("mp/hatTable.csv",0,"backpack"+i,1);
level.bps[i].bit=count;
level.bps[i].price=int(tableLookup("mp/hatTable.csv",0,"backpack"+i,2));
preCacheModel(level.bps[i].model);
count*=2;
}


level.miscCount=int(tableLookup("mp/hatTable.csv",0,"misccount",1));
level.miscs=[];
count=1;
for(i=1;i<=level.miscCount;i++)
{
level.miscs[i]=spawnStruct();
level.miscs[i].model=tableLookup("mp/hatTable.csv",0,"misc"+i,1);
level.miscs[i].bit=count;
level.miscs[i].price=int(tableLookup("mp/hatTable.csv",0,"misc"+i,2));
preCacheModel(level.miscs[i].model);
count*=2;
}


level.maxClanRank=int(tableLookup("mp/clanTable.csv",0,"maxrank",1));
level.clanRanks=[];
for(i=0;i<=level.maxClanRank;i++)
{
level.clanRanks[i]=int(tableLookup("mp/clanTable.csv",0,i,1));
}


level.music[0]["time"]=100;

level.music[0]["title"]="Airlift Deploy";
level.music[1]["time"]=131;

level.music[1]["title"]="Airlift Start";
level.music[2]["time"]=145;

level.music[2]["title"]="Airplane Alt";
level.music[3]["time"]=228;

level.music[3]["title"]="Armada Seanprice Church";
level.music[4]["time"]=100;

level.music[4]["title"]="Armada Start";
level.music[5]["time"]=211;

level.music[5]["title"]="Coup Intro";
level.music[6]["time"]=103;

level.music[6]["title"]="ICMB Tension";
level.music[7]["time"]=165;

level.music[7]["title"]="Jeepride Chase";
level.music[8]["time"]=134;

level.music[8]["title"]="Jeepride Defense";
level.music[9]["time"]=101;

level.music[9]["title"]="Jeepride Showdown";
level.music[10]["time"]=113;

level.music[10]["title"]="Launch Action";
level.music[11]["time"]=143;

level.music[11]["title"]="Launch Count";
level.music[12]["time"]=196;

level.music[12]["title"]="Launch Tick";
level.music[13]["time"]=117;

level.music[13]["title"]="Scoutsniper Abandoned";
level.music[14]["time"]=119;

level.music[14]["title"]="Scoutsniper Deadpool";
level.music[15]["time"]=138;

level.music[15]["title"]="Scoutsniper Pripyat";
level.music[16]["time"]=117;

level.music[16]["title"]="Scoutsniper Surrounded";
level.music[17]["time"]=122;

level.music[17]["title"]="Sniperescape Exchange";
level.music[18]["time"]=132;

level.music[18]["title"]="Sniperescape Run";
level.music[19]["time"]=224;

level.music[19]["title"]="Griggs Deep Hard";


level.themes["8bit"]["rows"]=9;
level.themes["8bit"]["title"]="8Bit";
level.themes["acguitar"]["rows"]=15;
level.themes["acguitar"]["title"]="Ac Guitar";
level.themes["acpiano"]["rows"]=25;
level.themes["acpiano"]["title"]="Ac Piano";
level.themes["bbbass1"]["rows"]=11;
level.themes["bbbass1"]["title"]="BB Bass #1";
level.themes["bbbass2"]["rows"]=11;
level.themes["bbbass2"]["title"]="BB Bass #2";
level.themes["bbbass3"]["rows"]=11;
level.themes["bbbass3"]["title"]="BB Bass #3";
level.themes["bbdrum"]["rows"]=19;
level.themes["bbdrum"]["title"]="BB Drum Kit";
level.themes["bbguitar1"]["rows"]=11;
level.themes["bbguitar1"]["title"]="BB Guitar #1";
level.themes["bbguitar2"]["rows"]=10;
level.themes["bbguitar2"]["title"]="BB Guitar #2";
level.themes["bbguitar3"]["rows"]=16;
level.themes["bbguitar3"]["title"]="BB Guitar #3";
level.themes["bbguitar4"]["rows"]=16;
level.themes["bbguitar4"]["title"]="BB Guitar #4";
level.themes["bbguitar5"]["rows"]=16;
level.themes["bbguitar5"]["title"]="BB Guitar #5";
level.themes["bbstring"]["rows"]=7;
level.themes["bbstring"]["title"]="BB Strings";
level.themes["dbbass"]["rows"]=8;
level.themes["dbbass"]["title"]="DB Bass";
level.themes["dbdrum"]["rows"]=20;
level.themes["dbdrum"]["title"]="DB Drum Kit";
level.themes["dbguitar1"]["rows"]=3;
level.themes["dbguitar1"]["title"]="DB Guitar #1";
level.themes["dbguitar2"]["rows"]=4;
level.themes["dbguitar2"]["title"]="DB Guitar #2";
level.themes["dbguitar3"]["rows"]=13;
level.themes["dbguitar3"]["title"]="DB Guitar #3";
level.themes["dblead"]["rows"]=9;
level.themes["dblead"]["title"]="DB Lead";
level.themes["dbpad"]["rows"]=20;
level.themes["dbpad"]["title"]="DB Pad";
level.themes["dbsfx"]["rows"]=10;
level.themes["dbsfx"]["title"]="DB SFX";
level.themes["eguitar"]["rows"]=9;
level.themes["eguitar"]["title"]="Electric Guitar";
level.themes["epiano"]["rows"]=22;
level.themes["epiano"]["title"]="Electric Piano";
level.themes["ekit"]["rows"]=23;
level.themes["ekit"]["title"]="Electro Kit";
level.themes["rock"]["rows"]=18;
level.themes["rock"]["title"]="Rock Guitar";
level.themes["rocksolo"]["rows"]=33;
level.themes["rocksolo"]["title"]="Rock Solo";
level.themes["hh1"]["rows"]=10;
level.themes["hh1"]["title"]="Hip Hop #1";
level.themes["hh2"]["rows"]=9;
level.themes["hh2"]["title"]="Hip Hop #2";
level.themes["hh3"]["rows"]=10;
level.themes["hh3"]["title"]="Hip Hop #3";
level.themes["hh4"]["rows"]=10;
level.themes["hh4"]["title"]="Hip Hop #4";
level.themes["hh5"]["rows"]=10;
level.themes["hh5"]["title"]="Hip Hop #5";
level.themes["hh6"]["rows"]=10;
level.themes["hh6"]["title"]="Hip Hop #6";
level.themes["hh7"]["rows"]=10;
level.themes["hh7"]["title"]="Hip Hop #7";
level.themes["lbbass"]["rows"]=10;
level.themes["lbbass"]["title"]="LB Bass";
level.themes["lbclav"]["rows"]=4;
level.themes["lbclav"]["title"]="LB Clav";
level.themes["lbdrum"]["rows"]=14;
level.themes["lbdrum"]["title"]="LB Drums";
level.themes["lbguitar1"]["rows"]=33;
level.themes["lbguitar1"]["title"]="LB Guitar #1";
level.themes["lbguitar2"]["rows"]=31;
level.themes["lbguitar2"]["title"]="LB Guitar #2";
level.themes["lbvox"]["rows"]=18;
level.themes["lbvox"]["title"]="LB Vox";
level.themes["nobass"]["rows"]=6;
level.themes["nobass"]["title"]="Noct Bass";
level.themes["nobees"]["rows"]=6;
level.themes["nobees"]["title"]="Noct Bees";
level.themes["nodrums"]["rows"]=26;
level.themes["nodrums"]["title"]="Noct Drums";
level.themes["noorch1"]["rows"]=4;
level.themes["noorch1"]["title"]="Noct Orch #1";
level.themes["noorch2"]["rows"]=4;
level.themes["noorch2"]["title"]="Noct Orch #2";
level.themes["noorch3"]["rows"]=4;
level.themes["noorch3"]["title"]="Noct Orch #3";
level.themes["norise"]["rows"]=4;
level.themes["norise"]["title"]="Noct Rise";
level.themes["nostring"]["rows"]=5;
level.themes["nostring"]["title"]="Noct Strings";
level.themes["noarp"]["rows"]=4;
level.themes["noarp"]["title"]="Noct Arp";
level.themes["stdrum"]["rows"]=9;
level.themes["stdrum"]["title"]="ST Drums";
level.themes["stharp"]["rows"]=14;
level.themes["stharp"]["title"]="ST Harp";
level.themes["ststr"]["rows"]=17;
level.themes["ststr"]["title"]="ST Strings";
level.themes["synth1"]["rows"]=32;
level.themes["synth1"]["title"]="Synth Kit #1";
level.themes["synth2"]["rows"]=10;
level.themes["synth2"]["title"]="Synth Kit #2";

level.spawn["allies"]=getEntArray("mp_tdm_spawn_allies_start","classname");
level.spawn["axis"]=getEntArray("mp_tdm_spawn_axis_start","classname");
level.spawns=getEntArray("mp_tdm_spawn","classname");

__v1=level.spawn["allies"];__c1=__v1.size;for(__i1=0;__i1<__c1;__i1++)
__v1[__i1] placeSpawnpoint();__i1=undefined;__c1=undefined;__v1=undefined;

__v2=level.spawn["axis"];__c2=__v2.size;for(__i2=0;__i2<__c2;__i2++)
__v2[__i2] placeSpawnpoint();__i2=undefined;__c2=undefined;__v2=undefined;

__v3=level.spawns;__c3=__v3.size;for(__i3=0;__i3<__c3;__i3++)
__v3[__i3] placeSpawnpoint();__i3=undefined;__c3=undefined;__v3=undefined;


level.lastTheme=0;
level.themeID=[];
level.themeIDList=[];
thread clearThemes();


level.public["allies"]=[];
level.public["axis"]=[];


level.online=[];


level.ip=getDvar("ip")+":"+getDvar("net_port");


if(level.tutorial)
level.bots=0;


level.clientid=0;





setMiniMap("compass",940000000,940000000,-940000000,-940000000);




















































maps\mp\gametypes\_str::main();

level.s["CLANRANK0_EN"]=&"APB_CLANRANK0_EN";
level.s["CLANRANK1_EN"]=&"APB_CLANRANK1_EN";
level.s["CLANRANK2_EN"]=&"APB_CLANRANK2_EN";
level.s["CLANRANK3_EN"]=&"APB_CLANRANK3_EN";
level.s["CLANRANK4_EN"]=&"APB_CLANRANK4_EN";
level.s["CLANRANK5_EN"]=&"APB_CLANRANK5_EN";
level.s["FEED_ARREST_EN"]=&"APB_FEED_ARREST_EN";
level.s["FEED_ASSIST_EN"]=&"APB_FEED_ASSIST_EN";
level.s["FEED_KILL_EN"]=&"APB_FEED_KILL_EN";
level.s["FEED_TK_EN"]=&"APB_FEED_TK_EN";
level.s["FEED_STUN_EN"]=&"APB_FEED_STUN_EN";
level.s["KILLED_BY_EN"]=&"APB_KILLED_BY_EN";
level.s["SUICIDE_EN"]=&"APB_SUICIDE_EN";

level.s["CLANRANK0_HU"]=&"APB_CLANRANK0_HU";
level.s["CLANRANK1_HU"]=&"APB_CLANRANK1_HU";
level.s["CLANRANK2_HU"]=&"APB_CLANRANK2_HU";
level.s["CLANRANK3_HU"]=&"APB_CLANRANK3_HU";
level.s["CLANRANK4_HU"]=&"APB_CLANRANK4_HU";
level.s["CLANRANK5_HU"]=&"APB_CLANRANK5_HU";
level.s["FEED_ARREST_HU"]=&"APB_FEED_ARREST_HU";
level.s["FEED_ASSIST_HU"]=&"APB_FEED_ASSIST_HU";
level.s["FEED_KILL_HU"]=&"APB_FEED_KILL_HU";
level.s["FEED_TK_HU"]=&"APB_FEED_TK_HU";
level.s["FEED_STUN_HU"]=&"APB_FEED_STUN_HU";
level.s["KILLED_BY_HU"]=&"APB_KILLED_BY_HU";
level.s["SUICIDE_HU"]=&"APB_SUICIDE_HU";

level.s["CLANRANK0_HR"]=&"APB_CLANRANK0_HR";
level.s["CLANRANK1_HR"]=&"APB_CLANRANK1_HR";
level.s["CLANRANK2_HR"]=&"APB_CLANRANK2_HR";
level.s["CLANRANK3_HR"]=&"APB_CLANRANK3_HR";
level.s["CLANRANK4_HR"]=&"APB_CLANRANK4_HR";
level.s["CLANRANK5_HR"]=&"APB_CLANRANK5_HR";
level.s["FEED_ARREST_HR"]=&"APB_FEED_ARREST_HR";
level.s["FEED_ASSIST_HR"]=&"APB_FEED_ASSIST_HR";
level.s["FEED_KILL_HR"]=&"APB_FEED_KILL_HR";
level.s["FEED_TK_HR"]=&"APB_FEED_TK_HR";
level.s["FEED_STUN_HR"]=&"APB_FEED_STUN_HR";
level.s["KILLED_BY_HR"]=&"APB_KILLED_BY_HR";
level.s["SUICIDE_HR"]=&"APB_SUICIDE_HR";

level.s["CLANRANK0_TR"]=&"APB_CLANRANK0_TR";
level.s["CLANRANK1_TR"]=&"APB_CLANRANK1_TR";
level.s["CLANRANK2_TR"]=&"APB_CLANRANK2_TR";
level.s["CLANRANK3_TR"]=&"APB_CLANRANK3_TR";
level.s["CLANRANK4_TR"]=&"APB_CLANRANK4_TR";
level.s["CLANRANK5_TR"]=&"APB_CLANRANK5_TR";
level.s["FEED_ARREST_TR"]=&"APB_FEED_ARREST_TR";
level.s["FEED_ASSIST_TR"]=&"APB_FEED_ASSIST_TR";
level.s["FEED_KILL_TR"]=&"APB_FEED_KILL_TR";
level.s["FEED_TK_TR"]=&"APB_FEED_TK_TR";
level.s["FEED_STUN_TR"]=&"APB_FEED_STUN_TR";
level.s["KILLED_BY_TR"]=&"APB_KILLED_BY_TR";
level.s["SUICIDE_TR"]=&"APB_SUICIDE_TR";


level.enemy["allies"]="axis";
level.enemy["axis"]="allies";


level.upper["allies"]="ALLIES";
level.upper["axis"]="AXIS";


level.threatValue["gold"]=3;
level.threatValue["silver"]=2;
level.threatValue["bronze"]=1;


level.prestige[1]=0.5;
level.prestige[2]=1;
level.prestige[3]=1.3;
level.prestige[4]=1.8;
level.prestige[5]=2;


































































level.codeindex["U"]=0;
level.codeindex["B"]=1;
level.codeindex["W"]=2;
level.codeindex["9"]=3;
level.codeindex["C"]=4;
level.codeindex["E"]=5;
level.codeindex["3"]=6;
level.codeindex["L"]=7;
level.codeindex["H"]=8;
level.codeindex["7"]=9;
level.codeindex["S"]=10;
level.codeindex["Q"]=11;
level.codeindex["J"]=12;
level.codeindex["G"]=13;
level.codeindex["Z"]=14;
level.codeindex["5"]=15;
level.codeindex["I"]=16;
level.codeindex["N"]=17;
level.codeindex["K"]=18;
level.codeindex["Y"]=19;
level.codeindex["T"]=20;
level.codeindex["4"]=21;
level.codeindex["M"]=22;
level.codeindex["P"]=23;
level.codeindex["0"]=24;
level.codeindex["R"]=25;
level.codeindex["F"]=26;
level.codeindex["1"]=27;
level.codeindex["V"]=28;
level.codeindex["A"]=29;
level.codeindex["8"]=30;
level.codeindex["2"]=31;
level.codeindex["X"]=32;
level.codeindex["O"]=33;
level.codeindex["D"]=34;
level.codeindex["6"]=35;
level.codeindex["d"]=36;
level.codeindex["i"]=37;
level.codeindex["w"]=38;
level.codeindex["o"]=39;
level.codeindex["g"]=40;
level.codeindex["u"]=41;
level.codeindex["v"]=42;
level.codeindex["b"]=43;
level.codeindex["y"]=44;
level.codeindex["r"]=45;
level.codeindex["l"]=46;
level.codeindex["h"]=47;
level.codeindex["z"]=48;
level.codeindex["m"]=49;
level.codeindex["k"]=50;
level.codeindex["p"]=51;
level.codeindex["a"]=52;
level.codeindex["n"]=53;
level.codeindex["t"]=54;
level.codeindex["q"]=55;
level.codeindex["e"]=56;
level.codeindex["c"]=57;
level.codeindex["x"]=58;
level.codeindex["j"]=59;
level.codeindex["s"]=60;
level.codeindex["f"]=61;


level.allowed="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";







level.roles["primary"][1]=12;
level.roles["primary"][2]=18;
level.roles["primary"][3]=20;
level.roles["primary"][4]=50;
level.roles["primary"][5]=100;
level.roles["primary"][6]=175;
level.roles["primary"][7]=200;
level.roles["primary"][8]=250;
level.roles["primary"][9]=325;
level.roles["primary"][10]=350;
level.roles["primary"][11]=500;
level.roles["primary"][12]=500;
level.roles["primary"][13]=500;
level.roles["primary"][14]=2000;
level.roles["primary"][15]=5000;
level.roles["primary"][16]=10000;

level.roles["secondary"][1]=12;
level.roles["secondary"][2]=38;
level.roles["secondary"][3]=100;
level.roles["secondary"][4]=350;
level.roles["secondary"][5]=500;
level.roles["secondary"][6]=1000;


level.symbolCount=int(tableLookup("mp/symbolTable.csv",0,"count",1));
level.rareSymbolCount=0;
level.symbolPages=int((level.symbolCount+1)/70-1);
level.symbols=[];
level.rareSymbols=[];
for(i=0;i<level.symbolCount;i++)
{
level.symbols[i]=spawnStruct();
level.symbols[i].value=int(tableLookup("mp/symbolTable.csv",0,i,1));
level.symbols[i].rare=tableLookup("mp/symbolTable.csv",0,i,2)=="1";
if(level.symbols[i].rare)
{
level.rareSymbols[level.rareSymbolCount]=i;
level.rareSymbolCount++;
}
}


level.camoCount=int(tableLookup("mp/camoTable.csv",0,"camos",1));
level.camos=[];
for(i=0;i<level.camoCount;i++)
{
level.camos[i]=spawnStruct();
level.camos[i].name=tableLookup("mp/camoTable.csv",0,i,1);
level.camos[i].img=tableLookup("mp/camoTable.csv",0,i,2);
level.camos[i].bit=int(tableLookup("mp/camoTable.csv",0,i,3));
}


level.ammoCount=int(tableLookup("mp/ammoTable.csv",0,"count",1));
level.ammos=[];
for(i=1;i<=level.ammoCount;i++)
{
level.ammos[i]=spawnStruct();
level.ammos[i].name=tableLookup("mp/ammoTable.csv",4,i,0);
level.ammos[i].max=int(tableLookup("mp/ammoTable.csv",4,i,1));
level.ammos[i].count=int(tableLookup("mp/ammoTable.csv",4,i,2));
level.ammos[i].cost=int(tableLookup("mp/ammoTable.csv",4,i,3));
level.ammos[i].title=tableLookup("mp/ammoTable.csv",4,i,5);
level.ammoID[level.ammos[i].name]=i;
}


level.missionList[0]=::mission_defuse;
level.missionList[1]=::mission_destroy;
level.missionList[2]=::mission_deliver;
level.missionList[3]=::mission_goto;


level.lastMissionList[0]=::mission_dm;
level.lastMissionList[1]=::mission_capture;
level.lastMissionList[2]=::mission_hold;
level.lastMissionList[3]=::mission_plant;
level.lastMissionList[4]=::mission_sideddm;
level.lastMissionList[5]=::mission_drop;
level.lastMissionList[6]=::mission_vip;


level.smallPointFX["friend"]=loadFX("apb/smallpoint_defend");
level.smallPointFX["enemy"]=loadFX("apb/smallpoint_capture");
level.pointFX["friend"]=loadFX("apb/point_defend");
level.pointFX["enemy"]=loadFX("apb/point_capture");
level.pointFX["none"]=loadFX("apb/point_free");
level.destroyFX=loadFX("explosions/sparks_d");
level.placedPointFX=loadFX("apb/point");



level.modCount=int(tableLookup("mp/modTable.csv",0,"count",1));
level.mods=[];

for(i=0;i<level.modCount;i++)
{
level.mods[i]=spawnStruct();
level.mods[i].name=tableLookup("mp/modTable.csv",0,i,1);
level.mods[i].tier=int(tableLookup("mp/modTable.csv",0,i,2));
level.mods[i].title=tableLookup("mp/modTable.csv",0,i,3);
level.mods[i].price=int(tableLookup("mp/modTable.csv",0,i,4));
level.mods[i].rating=int(tableLookup("mp/modTable.csv",0,i,5));
level.mods[i].buyable=tableLookup("mp/modTable.csv",0,i,7)=="1";

if(level.mods[i].tier>3)
level.mods[i].wid=int(tableLookup("mp/modTable.csv",0,i,6));


}


level.toolCount=int(tableLookup("mp/toolTable.csv",0,"count",1));
level.tools=[];
level.toolsID=[];
for(i=0;i<level.toolCount;i++)
{
level.tools[i]=spawnStruct();
level.tools[i].name=tableLookup("mp/toolTable.csv",0,i,1);
level.tools[i].title=tableLookup("mp/toolTable.csv",0,i,2);
level.tools[i].img=tableLookup("mp/toolTable.csv",0,i,3);
s=strTok(tableLookup("mp/toolTable.csv",0,i,4),";");

__c4=s.size;for(j=0;j<__c4;j++)
level.tools[i].types[j]=int(s[j]);j=undefined;__c4=undefined;

level.toolsID[level.tools[i].name]=i;
}


level.controlPoints=getEntArray("control","targetname");
__v5=level.controlPoints;__c5=__v5.size;if(__c5){for(__i5=0;__i5<__c5;__i5++)
{
__e5=__v5[__i5];__e5.points=getEntArray(__e5.target,"targetname");
__v6=__e5.points;__c6=__v6.size;if(__c6){for(__i6=0;__i6<__c6;__i6++)
{
__v6[__i6].team=[];
__v6[__i6] hideAll();
}__i6=undefined;}__c6=undefined;__v6=undefined;
}__i5=undefined;}__c5=undefined;__v5=undefined;


level.gotoPoints=getEntArray("goto","targetname");
__v7=level.gotoPoints;__c7=__v7.size;if(__c7){for(__i7=0;__i7<__c7;__i7++)
{
__e7=__v7[__i7];__e7.points=getEntArray(__e7.target,"targetname");
__v8=__e7.points;__c8=__v8.size;if(__c8){for(__i8=0;__i8<__c8;__i8++)
{
__e8=__v8[__i8];__e8.ignoreTied=true;
__e8.team=[];
__e8 hideAll();
}__i8=undefined;}__c8=undefined;__v8=undefined;
}__i7=undefined;}__c7=undefined;__v7=undefined;


level.pickupPoints=getEntArray("pickup","targetname");
__v9=level.pickupPoints;__c9=__v9.size;if(__c9){for(__i9=0;__i9<__c9;__i9++)
{
__e9=__v9[__i9];__e9.ignoreTied=true;
__e9.smallPoint=true;
__e9.team=[];
__e9 hideAll();
__e9.items=getEntArray(__e9.target,"targetname");
}__i9=undefined;}__c9=undefined;__v9=undefined;


level.dropPoints=getEntArray("drop","targetname");
__v10=level.dropPoints;__c10=__v10.size;if(__c10){for(__i10=0;__i10<__c10;__i10++)
{
__e10=__v10[__i10];__e10.points=getEntArray(__e10.target,"targetname");
__v11=__e10.points;for(__i11=0;__i11<2;__i11++)
{
__e11=__v11[__i11];__e11.ignoreTied=true;
__e11.smallPoint=true;
__e11.team=[];
__e11 hideAll();
}__i11=undefined;__v11=undefined;
}__i10=undefined;}__c10=undefined;__v10=undefined;


level.destroyPoints=getEntArray("destroy","targetname");
__v12=level.destroyPoints;__c12=__v12.size;if(__c12){for(__i12=0;__i12<__c12;__i12++)
{
__v12[__i12].points=getEntArray(__v12[__i12].target,"targetname");
}__i12=undefined;}__c12=undefined;__v12=undefined;


level.defusePoints=getEntArray("defuse","targetname");
__v13=level.defusePoints;__c13=__v13.size;if(__c13){for(__i13=0;__i13<__c13;__i13++)
{
__e13=__v13[__i13];__e13.points=getEntArray(__e13.target,"targetname");
__v14=__e13.points;__c14=__v14.size;if(__c14){for(__i14=0;__i14<__c14;__i14++)
{
__v14[__i14] createBombObject();
}__i14=undefined;}__c14=undefined;__v14=undefined;
}__i13=undefined;}__c13=undefined;__v13=undefined;


level.plantPoints=getEntArray("plant","targetname");
__v15=level.plantPoints;__c15=__v15.size;if(__c15){for(__i15=0;__i15<__c15;__i15++)
{
__v15[__i15] createBombObject();
}__i15=undefined;}__c15=undefined;__v15=undefined;


level.holdPoints=getEntArray("hold","targetname");


locations=getEntArray("loc","targetname");
__c16=locations.size;for(__i16=0;__i16<__c16;__i16++)
{
locations[__i16] thread checkLocation();
}__i16=undefined;__c16=undefined;






if(level.tutorial)
thread searchEnemyBot();
else if(level.action)
thread searchEnemy();


thread autoRestart();


thread realTime();


thread beat();


thread serverHeartBeat();





__v17=level.vendorTypes;__c17=__v17.size;for(__i17=0;__i17<__c17;__i17++)
{
editMenu(__v17[__i17]);
}__i17=undefined;__c17=undefined;__v17=undefined;


level.camoWeap=getEnt("arsenal_weap","targetname");

level notify("begin");
}
















































beat()
{
while(true)
{
wait 30;
if(level.allActiveCount)
{
s="";
for(i=0;i<level.allActiveCount;i++)
{
if(i)
s+=", ";

s+="'"+level.allActivePlayers[i].showname+"'";
}
sql_exec("UPDATE players SET timestamp = "+getRealTime()+" WHERE name IN ("+s+")");
}
}
}

getWeaponID(w)
{

if(isDefined(level.weapID[w]))return level.weapID[w];
else if(level.weaps[self.info["prime"]].weap==w)
return self.info["prime"];
else if(level.weaps[self.info["secondary"]].weap==w)
return self.info["secondary"];
else
 return undefined;
}

clearThemes()
{





wait 1;

id=firstConfigString();
setConfigstring(id,"EnemyKilled");
setConfigstring(id+1,"EnemyAssist");
setConfigstring(id+2,"Coin");
setConfigstring(id+3,"Change");
setConfigstring(id+4,"Ready");
setConfigstring(id+5,"NotReady");
setConfigstring(id+6,"MissionNotify");
setConfigstring(id+7,"BackupNotify");
setConfigstring(id+8,"Notify");
setConfigstring(id+9,"Info");
setConfigstring(id+10,"MainInfo");
setConfigstring(id+11,"LoadBeep");
setConfigstring(id+12,"LoadReady");
setConfigstring(id+13,"RoleLevelUp");
setConfigstring(id+14,"RoleLevelMax");
setConfigstring(id+15,"BountyClaimed");
setConfigstring(id+16,"BountyAlert");
setConfigstring(id+17,"BountyGot");
setConfigstring(id+18,"EarnItem");
setConfigstring(id+19,"RewardReceivedArt");
setConfigstring(id+20,"RewardReceivedWeapon");
setConfigstring(id+21,"RewardReceivedMod");
setConfigstring(id+22,"RewardReceivedCamo");
setConfigstring(id+23,"MissionWin");
setConfigstring(id+24,"MissionLose");
setConfigstring(id+25,"MissionStage");
setConfigstring(id+26,"StarUp");
setConfigstring(id+27,"StarDown");
setConfigstring(id+28,"SupplierDown");
setConfigstring(id+29,"SupplierUp");
setConfigstring(id+30,"OneMinuteRemaining");
setConfigstring(id+31,"DoubleKill");
setConfigstring(id+32,"mouse_over");
setConfigstring(id+33,"music0");
setConfigstring(id+34,"music1");
setConfigstring(id+35,"music2");
setConfigstring(id+36,"music3");
setConfigstring(id+37,"music4");
setConfigstring(id+38,"music5");
setConfigstring(id+39,"music6");
setConfigstring(id+40,"music7");
setConfigstring(id+41,"music8");
setConfigstring(id+42,"music9");
setConfigstring(id+43,"music10");
setConfigstring(id+44,"music11");
setConfigstring(id+45,"music12");
setConfigstring(id+46,"music13");
setConfigstring(id+47,"music14");
setConfigstring(id+48,"music15");
setConfigstring(id+49,"music16");
setConfigstring(id+50,"music17");
setConfigstring(id+51,"music18");
setConfigstring(id+52,"music19");
setConfigstring(id+53,"breach");
setConfigstring(id+54,"stream");
setConfigstring(id+55,"fireext");
setConfigstring(id+56,"BoardCrash");
setConfigstring(id+57,"US_7_order_move_generic_01");
setConfigstring(id+58,"US_7_order_move_generic_02");
setConfigstring(id+59,"US_7_order_move_generic_03");
setConfigstring(id+60,"US_7_order_move_generic_04");
setConfigstring(id+61,"US_7_order_move_generic_05");
setConfigstring(id+62,"US_7_order_move_generic_06");
setConfigstring(id+63,"US_7_order_move_generic_07");
setConfigstring(id+64,"breathing_hurt");
setConfigstring(id+65,"breathing_better");
setConfigstring(id+66,"DoorOpen");
setConfigstring(id+67,"DoorClose");
setConfigstring(id+68,"LiftStart");
setConfigstring(id+69,"LiftMove");
setConfigstring(id+70,"LiftStop");
setConfigstring(id+71,"MP_hit_alert");
setConfigstring(id+72,"Train");
setConfigstring(id+73,"OverTime");
setConfigstring(id+74,"EnemyStunned");
setConfigstring(id+75,"EnemyArrested");

while(true)
{
wait 1;
waittillframeend;

if(level.themeID.size&&level.lastTheme<=getRealTime())
{
for(i=level.themeID.size-1;i>=0;i--)
{

clearConfigstring(level.themeID[i]);
}
level.themeIDList=[];
level.themeID=[];
}
}
}

addClearTheme(id)
{
if(!isDefined(level.themeIDList[id]))
{
level.themeIDList[id]=true;
level.themeID[level.themeID.size]=id;
}

level.lastTheme=getRealTime()+1;
}



realTime()
{
time=getRealTime();
r=time%60;
time+=r;
wait r;
r=undefined;
while(true)
{
for(i=0;i<level.allActiveCount;i++)
{
level.allActivePlayers[i]getCurTime(time);
}
time+=60;
wait 60;
}
}

getTimeZone()
{
if(self.info["gmt"]>0)
tz="+"+self.info["gmt"];
else if(!self.info["gmt"])
tz="";
else
 tz=self.info["gmt"];

self setClientDvar("gmt",tz);
}

getCurTime(time)
{
if(self.info["gmt"])
time+=self.info["gmt"]*3600;

self setClientDvar("realtime",unixToString(time,self.info["format"],0));
}

createBombObject()
{
self hide();
self.object=spawn("script_model",self.origin);
self.object.angles=self.angles+(0,90,0);
self.object setModel("prop_suitcase_bomb");
self.object hide();
}

checkLocation()
{
while(true)
{
self waittill("trigger",p);
if(isDefined(p.loc)&&p.loc!=self.name)
{
p.loc=self.name;
p setClientDvar("location",p.loc);
}
}
}


autoRestart()
{
while(true)
{
wait 3600;
if(!level.players.size)
{

map_restart(false);
}
}
}












Callback_PlayerSay(msg)
{
if(!isDefined(self.showname))
return;

if(!(1&self.info["admin"]))
msg=stripColors(msg);

s=msg.size;
if(s)
{
if(msg[0]=="/"||msg[0]=="\\")
{
msg=getSubStr(msg,1);
cmd=toLower(msg);
if(cmd.size>2&&(cmd[0]=="g"||cmd[0]=="d"||cmd[0]=="t"||cmd[0]=="m"||cmd[0]=="w"||cmd[0]=="c")&&cmd[1]==" ")
{
if(cmd[0]!="w")
{
self.chattype=cmd[0];
self setClientDvar("chattype",self.chattype);
self message(getSubStr(msg,2));
}
else
{

msg=getSubStr(msg,2);
name=strTok(msg," ");
if(name.size>=2)
{
name=name[0];
if(name!=self.showname&&isDefined(level.online[name]))
{
msg=getSubStr(msg,name.size+1);
self newMessage("^6["+self.showname+"]: "+msg);
level.online[name]newMessage("^6"+self.showname+": "+msg);
}
else
{
self newMessage("^1"+name+" "+level.s["NOT_ONLINE_"+self.lang]+"!");
}
}
}
}
else if(getSubStr(msg,0,5)=="code ")
{
time=getTime();
if(self.codeTry+60000<=time)
{
msg=getSubStr(msg,5);
x=sql_fetch(sql_query("SELECT item, value FROM premium WHERE code = '"+msg+"' AND name IS NULL"));
if(isDefined(x))
{
sql_exec("UPDATE premium SET name = '"+self.showname+"' WHERE code = '"+msg+"'");
switch(x[0])
{
case"PR":
if(!self.premium)
{
self.info["premiumtime"]=getRealTime()+int(x[1]);
self thread watchPremium();

}
else
{
self.info["premiumtime"]+=int(x[1]);
}
break;
}
}
else
{
self.codeTry=time;
self newMessage("^1"+level.s["INVALID_CODE_"+self.lang]+"!");
}


























































































}
else
{
self newMessage("^1"+level.s["CODE_DELAY_"+self.lang]+"!");
}
}
else
{
switch(cmd)
{
case"g":
case"d":
case"t":
case"m":
case"c":
self.chattype=cmd;
self setClientDvar("chattype",self.chattype);
break;
case"exit":
case"quit":
case"disconnect":
self clientExec("writeconfig apb_mod; quit");
break;
case"fps":
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
msg=self.showname+": "+msg;
if(self.chattype=="d")
{
__v18=level.allActivePlayers;__c18=level.allActiveCount;for(__i18=0;__i18<__c18;__i18++)
{
__v18[__i18] newMessage(msg);
}__i18=undefined;__c18=undefined;__v18=undefined;
}
else if(self.chattype=="t")
{
if(isDefined(self.missionId))
{
__v19=level.teams[self.missionTeam];__c19=__v19.size;for(__i19=0;__i19<__c19;__i19++)
{
__v19[__i19] newMessage("^5["+level.s["TEAM_"+__v19[__i19].lang]+"]"+msg);
}__i19=undefined;__c19=undefined;__v19=undefined;
}
else
{
self newMessage("^1"+level.s["NOT_IN_TEAM_"+self.lang]+"!");
}
}
else if(self.chattype=="m")
{
if(isDefined(self.missionId))
{
__v20=level.teams[self.missionTeam];__c20=__v20.size;for(__i20=0;__i20<__c20;__i20++)
{
__v20[__i20] newMessage("^6["+level.s["MATCH_"+__v20[__i20].lang]+"]"+msg);
}__i20=undefined;__c20=undefined;__v20=undefined;
__v21=level.teams[self.enemyTeam];__c21=__v21.size;for(__i21=0;__i21<__c21;__i21++)
{
__v21[__i21] newMessage("^6["+level.s["MATCH_"+__v21[__i21].lang]+"]"+msg);
}__i21=undefined;__c21=undefined;__v21=undefined;
}
else
{
self newMessage("^1"+level.s["NOT_ENEMY_TEAM_"+self.lang]+"!");
}
}
else if(self.chattype=="g")
{
if(isDefined(self.group))
{
__v22=level.groups[self.group].team;__c22=__v22.size;for(__i22=0;__i22<__c22;__i22++)
{
__v22[__i22] newMessage("^2["+level.s["GROUP_"+__v22[__i22].lang]+"]"+msg);
}__i22=undefined;__c22=undefined;__v22=undefined;
}
else
{
self newMessage("^1"+level.s["NOT_IN_GROUP_"+self.lang]+"!");
}
}
else if(self.chattype=="c")
{
x=sql_query_first("SELECT clan FROM members WHERE name = '"+self.showname+"'");
if(isDefined(x))
{
x=sql_query("SELECT name FROM members WHERE clan = '"+x+"'");
while(true)
{
y=sql_fetch(x);
if(isDefined(y))
{
if(isDefined(level.online[y[0]]))
{
level.online[y[0]]newMessage("^5["+level.s["CLAN_"+level.online[y[0]].lang]+"]"+msg);
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
self newMessage("^1"+level.s["NOT_IN_CLAN_"+self.lang]+"!");
}
}
}

showAll(team,player)
{
self.team[team]showToPlayer(player);
self.visible[team][self.visible[team].size]=player;
player=undefined;
wait 0.05;


if(isDefined(self.id))
{
if(isDefined(self.smallpoint))
fx=level.smallPointFX[team];
else
 fx=level.pointFX[team];

playFXOnTag(fx,self.team[team],"tag_origin");
}
}

hideAll()
{
self fxCont("friend");
self fxCont("enemy");

if(!isDefined(self.ignoreTied))
self fxCont("none");
}

fxCont(team)
{
if(isDefined(self.team[team]))
self.team[team]delete();

self.team[team]=spawn("script_model",self.origin);
self.team[team]setModel("tag_origin");
self.team[team].angles=(-90,0,0);
self.team[team]hide();
self.visible[team]=[];
}

touching(type)
{
__v23=level.triggers[type];__c23=__v23.size;if(__c23){for(__i23=0;__i23<__c23;__i23++)
{
if(self isTouching(__v23[__i23]))
{
return __v23[__i23];
}
}__i23=undefined;}__c23=undefined;__v23=undefined;
return undefined;
}

editMenu(type)
{
level.triggers[type]=getEntArray(type,"targetname");

__v24=level.triggers[type];__c24=__v24.size;if(__c24){for(__i24=0;__i24<__c24;__i24++)
{
__e24=__v24[__i24];if(type=="dress")
__e24 thread editDress();
else if(type=="camo")
__e24 thread editCamo();
else
 __e24 thread editMenuOpen();

if(level.social)
{
hud=newHudElem();
hud setShader("pin_"+type,6,6);
hud setWayPoint(true,"pin_"+type);
hud.hideWhenInMenu=true;
hud.alpha=0.75;
hud.x=__e24.origin[0];
hud.y=__e24.origin[1];
hud.z=__e24.origin[2]+64;
}
}__i24=undefined;}__c24=undefined;__v24=undefined;
}

editMenuOpen()
{
while(true)
{
self waittill("trigger",player);
player openMenu(game["menu_"+self.targetname]);
}
}

editDress()
{
while(true)
{
self waittill("trigger",player);
if(!isDefined(player.missionId)&&!player.ready)
{
player spawnClone();
player dress();
}
else
{
player newMessage("^1"+level.s["MUST_BE_INACTIVE_"+player.lang]+"!");
}
}
}

editCamo()
{
while(true)
{
self waittill("trigger",player);
if(!isDefined(player.missionId)&&!player.ready)
{
player spawnClone();

player.camo=1;
player.spawned=false;
depot=getEnt("depot","targetname");

if(isDefined(depot))
origin=depot.origin;
else
 origin=(0,0,0);

player setOrigin(origin);
player setPlayerAngles((0,180,0));

player hide();
player setClientDvars(
"cg_drawGun",0,
"cg_Draw2D",0,
"camo",player.weapons[player.camo]["id"],
"camo_skin",player.weapons[player.camo]["camo"],
"page",1
);
player.camomodel=spawn("script_model",level.camoWeap.origin);
player.camomodel hide();
player.camomodel showToPlayer(player);
player.camomodel.angles=level.camoWeap.angles;
player.camomodel setModel(getWeaponModel(level.weaps[player.weapons[player.camo]["id"]].weap,player.weapons[player.camo]["camo"]));
player.camopage=1;

player maps\mp\gametypes\_menus::getWeapPerks(player.weapons[player.camo]["id"],"mod");

player maps\mp\gametypes\_menus::updateCamos();

player closeMenus();
player openMenu(game["menu_camo"]);
}
else
{
player newMessage("^1"+level.s["MUST_BE_INACTIVE_"+player.lang]+"!");
}
}
}

closeMenus()
{
self closeMenu();
self closeInGameMenu();
}














spawnClone()
{

self freezeControls(true);
wait 0.05;
self.clone=self clonePlayer(0);


self.clone.temp_origin=self.origin;
self.clone.temp_angles=self.angles;
self.clone thread tempclone();
}

tempclone()
{
wait 0.1;
if(isDefined(self))
{
self.angles=self.temp_angles;
self.origin=self.temp_origin;
self.temp_angles=undefined;
self.temp_origin=undefined;
}
}

notifyConnecting()
{
self endon("disconnect");

waittillframeend;
level notify("connecting",self);
}

Callback_PlayerConnect()
{




self.spawned=false;
self.tempname=self.name;
level.players[level.players.size]=self;


if(level.tutorial)
updateServerStat("count_all = "+(level.players.size-level.bots));
else
 updateServerStat("count_all = "+level.players.size);

self thread notifyConnecting();

self.statusicon="hud_status_connecting";

self waittill("begin");

self.hadMission=false;
self.ready=false;
self.boardActive=false;
self.codeTry=-60000;
self.lastKill=0;
self.musicstatus="all";
self.chattype="d";
self.statusicon="";
self.sessionstate="intermission";
self.loc="";
self.radar=[];

self.team="free";

self.clientid=level.clientid;
level.clientid++;

self.entitynum=self getEntityNumber();




waittillframeend;

level notify("connected",self);


lang=self getStat(3153);
if(lang<0||lang>=level.langs.size)
lang=0;

self.lang=level.langs[lang];

self setClientDvars(
"g_scriptMainMenu",game["menu_login"],
"error","",
"fade","",
"lang",self.lang,
"cmd","",
"pass","",
"social",level.social||level.tutorial
);

self.sessionstate="dead";
self openMenu(game["menu_login"]);

self notify("joined");
}























































































































































































watchPremium()
{
self endon("disconnect");

self.premium=true;
self setClientDvar("premium",1);
wait self.info["premiumtime"]-getRealTime();








self.premium=false;
self setClientDvar("premium",0);
}

menuStatus(s)
{
if(!isDefined(s))
return self.boardActive;

self.boardActive=s;

if(!s)
self notify("boardoff");
}

updateRole(role,up)
{
type=getRoleType(role);
roleUp=false;
nextlevel=0;
count=0;
__v25=level.roles[type];__c25=__v25.size+1;for(j=1;j<__c25;j++)
{
count+=__v25[j];
if(self.info["role_"+role]<count)
{
nextlevel=j;
break;
}
else if(self.info["role_"+role]==count)
{
roleUp=true;
}
}j=undefined;__c25=undefined;__v25=undefined;
self.roleLevel[role]=nextlevel-1;

if(nextlevel)
{
cur=self.info["role_"+role];
if(self.roleLevel[role])
{
for(j=1;j<=self.roleLevel[role];j++)
{
cur-=level.roles[type][j];
}
}

self setClientDvar("role_"+role,cur+" / "+level.roles[type][nextlevel]);
}
else
{
self setClientDvar("role_"+role,"");
}

if(!isDefined(up)||roleUp)
{
if(self.roleLevel[role])
self setClientDvar("role_"+role+"_rank_display",level.s["CLASS_X_"+self.lang]+" "+self.roleLevel[role]);
else
 self setClientDvar("role_"+role+"_rank_display",level.s["NOT_ATTAINED_YET_"+self.lang]);

self setClientDvar("role_"+role+"_rank",self.roleLevel[role]);


if(isDefined(up)&&roleUp)
{
txt=tableLookup("mp/roleTable.csv",1,role,3);
info=spawnStruct();
info.title=level.s["ROLE_TITLE_"+self.lang];
info.line=level.s["ROLE_"+txt+"_"+self.lang]+" "+self.roleLevel[role];
info.icon=tableLookup("mp/roleTable.csv",1,role,2);

if(nextlevel)
info.sound="RoleLevelUp";
else
 info.sound="RoleLevelMax";

self thread gameMessage(info);
self infoLine("ROLE","ROLE_"+txt,self.roleLevel[role]);
}
}
}

openMixMenu(type)
{
self.mix=type;
self setClientDvar("mix",type);
self openMenu(game["menu_mix"]);
}

clientExec(cmd)
{
self setClientDvar("command",cmd);
self openMenuNoMouse(game["menu_cmd"]);



self closeMenu();
}

joinTeam()
{
self closeMenus();

if(self.info["faction"]==1&&self.team!="allies")
{
self.team="allies";
self.sessionteam="allies";
}
else if(self.info["faction"]==2&&self.team!="axis")
{
self.team="axis";
self.sessionteam="axis";
}

self notify("joined_team");
self notify("end_respawn");
self joinGame();
self setClientDvar("g_scriptMainMenu",game["menu_class"]);
}

loadPlayerPerks()
{
self clearPerks();
self.perks=[];
if(self hasWeapon(level.fieldSupplier))
{
self takeSupplier();
self setClientDvar("feedoffset",0);
}


if(level.mods[self.info["mod_green"]].name!="")
{
self.perks[level.mods[self.info["mod_green"]].name]=true;
self.perk1=level.mods[self.info["mod_green"]].name;
self setClientDvar("perk1",level.mods[self.info["mod_green"]].name);
if(isSubStr(level.mods[self.info["mod_green"]].name,"longersprint"))
{
self setPerk("specialty_longersprint");
if(level.mods[self.info["mod_green"]].name=="longersprint")
m=1.5;
else if(level.mods[self.info["mod_green"]].name=="longersprint2")
m=1.75;
else
 m=2;

self setClientDvar("perk_sprintMultiplier",m);
}
}
else
{
self.perk1="vacant";
self setClientDvar("perk1","vacant");
}

if(level.mods[self.info["mod_red"]].name!="")
{
self.perks[level.mods[self.info["mod_red"]].name]=true;
self.perk2=level.mods[self.info["mod_red"]].name;
self setClientDvar("perk2",level.mods[self.info["mod_red"]].name);
if(level.mods[self.info["mod_red"]].name=="quieter")
{
self setPerk("specialty_"+level.mods[self.info["mod_red"]].name);
}
}
else
{
self.perk2="vacant";
self setClientDvar("perk2","vacant");
}

if(level.mods[self.info["mod_blue"]].name!="")
{
self.perks[level.mods[self.info["mod_blue"]].name]=true;
self.perk3=level.mods[self.info["mod_blue"]].name;
self setClientDvar("perk3",level.mods[self.info["mod_blue"]].name);

if(level.mods[self.info["mod_blue"]].name=="supplier")
{
self setClientDvar("feedoffset",35);
self giveSupplier();
}
}
else
{
self.perk3="vacant";
self setClientDvar("perk3","vacant");
}
if(isDefined(self.missionId))
{
m=level.missions[self.missionId];
__v26=m.all;__c26=m.allCount;for(__i26=0;__i26<__c26;__i26++)
{
__e26=__v26[__i26];__e26.playerStats[self.clientid].perk1=self.perk1;
__e26.playerStats[self.clientid].perk2=self.perk2;
__e26.playerStats[self.clientid].perk3=self.perk3;
}__i26=undefined;__c26=undefined;__v26=undefined;
}
}

Callback_PlayerDisconnect()
{

if(isDefined(self.tempname))
{


{__c=level.players.size;if(__c>1){for(i=0;i<__c;i++){if(level.players[i]==self){last=__c-1;if(i<last)level.players[i]=level.players[last];level.players[last]=undefined;break;}}}else{level.players=[];}}


if(isDefined(self.online))
{
self.leaving=true;

if(isDefined(self.group))
{
if(level.groups[self.group].team.size>2)
{
{__c=level.groups[self.group].team.size;if(__c>1){for(i=0;i<__c;i++){if(level.groups[self.group].team[i]==self){last=__c-1;if(i<last)level.groups[self.group].team[i]=level.groups[self.group].team[last];level.groups[self.group].team[last]=undefined;break;}}}else{level.groups[self.group].team=[];}}
if(isDefined(self.groupleader))
{
r=0;
t=level.groups[self.group].team;
c=t.size;
for(i=1;i<c;i++)
{
if(t[i].rating>t[r].rating)
{
r=i;
}
}
level.groups[self.group].team[r].groupleader=true;
level.groups[self.group].leader=level.groups[self.group].team[r];
}
if(!isDefined(self.missionId)&&!level.groups[self.group].inMission)
{
refreshGroup(self.group);
}
}
else
{
abandonGroup(self.group);
}
}
else if(self.ready)
{
self unreadyPlayer();
}

if(isDefined(self.missionId))
{
self maps\mp\gametypes\_menus::delPlacedHud();

{__c=level.teams[self.missionTeam].size-1;if(self.teamId!=__c)level.teams[self.missionTeam][self.teamId]=level.teams[self.missionTeam][__c];level.teams[self.missionTeam][__c]=undefined;}
{__c=level.missions[self.missionId].all.size;if(__c>1){for(i=0;i<__c;i++){if(level.missions[self.missionId].all[i]==self){last=__c-1;if(i<last)level.missions[self.missionId].all[i]=level.missions[self.missionId].all[last];level.missions[self.missionId].all[last]=undefined;break;}}}else{level.missions[self.missionId].all=[];}}
level.missions[self.missionId].allCount--;
__v27=level.teams[self.enemyTeam];__c27=__v27.size;for(__i27=0;__i27<__c27;__i27++)
{
if(isDefined(__v27[__i27].enemyCompass[self.teamId]))
{
__v27[__i27].enemyCompass[self.teamId]=undefined;
}
}__i27=undefined;__c27=undefined;__v27=undefined;

count=level.teams[self.missionTeam].size;
if(count)
{
if(isDefined(self.teamleader))
{
friendThreat=0;
r=0;
t=level.teams[self.missionTeam];
for(i=1;i<count;i++)
{
if(t[i].rating>t[r].rating)
r=i;

friendThreat+=level.threatValue[t[i].threat];
}
t[r].teamleader=true;

enemyThreat=0;
t=level.teams[self.enemyTeam];
c=t.size;
for(i=1;i<c;i++)
{
enemyThreat+=level.threatValue[t[i].threat];
}

enemy=level.teams[self.enemyTeam].size;
if(count<enemy||(count==enemy&&enemyThreat-friendThreat>count))
{
level.teams[self.missionTeam][r]setClientDvar("leftinfo","CALL_BACKUP");
}
else if(count==enemy&&enemyThreat-friendThreat<=count)
{
level notify("endbackup"+self.enemyTeam);
level.missions[self.missionId].backup=undefined;
}
}
__v28=level.teams[self.missionTeam];for(__i28=0;__i28<count;__i28++)
{
if(__v28[__i28].teamId>self.teamId)
{
__v28[__i28].teamId--;
}
}__i28=undefined;__v28=undefined;
refreshTeam(self.missionTeam);
}
else
{
[[level.missions[self.missionId].giveupFunc]](self.missionId,level.enemy[self.team]);
}
}

if(self.prestige==5)
self noPublicEnemy();

if(isDefined(self.clone))
self.clone delete();

if(isDefined(self.camomodel))
self.camomodel delete();

if(isDefined(self.bot))
self removeBot();


if(!level.tutorial)
{
e="";
__v29=level.info;__c29=level.infoCount+1;for(__i29=1;__i29<__c29;__i29++)
{
__e29=__v29[__i29];if(__e29["type"]=="int")
e+=__e29["name"]+" = "+self.info[__e29["name"]]+", ";
else
 e+=__e29["name"]+" = '"+self.info[__e29["name"]]+"', ";
}__i29=undefined;__c29=undefined;__v29=undefined;
sql_exec("UPDATE players SET "+e+"status = 'Offline' WHERE name = '"+self.showname+"'");


if(isDefined(self.invmoney)&&self.invmoney)
{
sql_exec("UPDATE players SET level1 = level1 + "+self.invmoney+" WHERE name = '"+self.info["inv"]+"'");

s=sql_query_first("SELECT inv FROM players WHERE name = '"+self.info["inv"]+"'");
if(isDefined(s))
{
sql_exec("UPDATE players SET level2 = level2 + "+self.invmoney+" WHERE name = '"+s+"'");
}
}
}
else
{
sql_exec("UPDATE players SET status = 'Offline' WHERE name = '"+self.showname+"'");
}

self inactive();

if(level.tutorial)
updateServerStat("count_"+self.team+" = "+level.activeCount[self.team]+", count_all = "+(level.players.size-level.bots));
else
 updateServerStat("count_"+self.team+" = "+level.activeCount[self.team]+", count_all = "+level.players.size);









}

if(isDefined(self.showname))
{
level.online[self.showname]=undefined;
}
}








if(!isDefined(self.online))
{
if(level.tutorial)
updateServerStat("count_all = "+(level.players.size-level.bots));
else
 updateServerStat("count_all = "+level.players.size);
}


}

removeBot()
{
level.bots--;
setDvar("ui_maxclients",level.maxClients+level.bots);
self.bot=removeTestClient();
}

inactive()
{
{__c=level.activePlayers[self.team].size;if(__c>1){for(i=0;i<__c;i++){if(level.activePlayers[self.team][i]==self){last=__c-1;if(i<last)level.activePlayers[self.team][i]=level.activePlayers[self.team][last];level.activePlayers[self.team][last]=undefined;break;}}}else{level.activePlayers[self.team]=[];}}
{__c=level.allActivePlayers.size;if(__c>1){for(i=0;i<__c;i++){if(level.allActivePlayers[i]==self){last=__c-1;if(i<last)level.allActivePlayers[i]=level.allActivePlayers[last];level.allActivePlayers[last]=undefined;break;}}}else{level.allActivePlayers=[];}}
level.activeCount[self.team]--;
level.allActiveCount--;
}

Callback_PlayerDamage(eInflictor,eAttacker,iDamage,iDFlags,sMeansOfDeath,sWeapon,vPoint,vDir,sHitLoc,psOffsetTime)
{
if(level.social)
return;

anyPublicEnemy=self.prestige==5||(isDefined(eAttacker)&&isPlayer(eAttacker)&&eAttacker.prestige==5);

if(!isDefined(self.missionId)&&!anyPublicEnemy&&sMeansOfDeath!="MOD_TRIGGER_HURT")
return;

if(iDamage<1)
iDamage=1;

if(isDefined(eAttacker)&&isPlayer(eAttacker))
{
sameMission=isDefined(self.missionId)&&isDefined(eAttacker.missionId)&&self.missionId==eAttacker.missionId;

if(eAttacker!=self&&!anyPublicEnemy&&!sameMission)
return;

wid=eAttacker getWeaponID(sWeapon);
if(isDefined(wid)&&isDefined(eAttacker.wID[wid]))
{
if(eAttacker hasPerk("specialty_bulletdamage"))
{
m=eAttacker.weapons[eAttacker.wID[wid]]["mod"];
if(!isSubStr(sMeansOfDeath,"BULLET"))
{
if(level.perks["bulletdamage"].id&m)
iDamage=int(iDamage*0.8);
else if(level.perks["bulletdamage2"].id&m)
iDamage=int(iDamage*0.7);
else if(level.perks["bulletdamage3"].id&m)
iDamage=int(iDamage*0.6);
}
else
{
if(level.perks["bulletdamage"].id&m)
iDamage=int(iDamage*1.1);
else if(level.perks["bulletdamage2"].id&m)
iDamage=int(iDamage*1.15);
else if(level.perks["bulletdamage3"].id&m)
iDamage=int(iDamage*1.2);
}
}

if(level.perks["slow"].id&eAttacker.weapons[eAttacker.wID[wid]]["mod"])
{
self thread slowDown();
}
}

if(eAttacker!=self)
{

if(sameMission)
{
if(eAttacker.team!=self.team)
{
if(!isDefined(self.attackers))
self.attackers=[];

if(!isDefined(self.attackers[eAttacker.clientid]))
self.attackers[eAttacker.clientid]=eAttacker;

eAttacker.dmg+=iDamage;
}
else
{
eAttacker.dmg-=iDamage;
}
}
if(eAttacker.team!=self.team)
{
eAttacker addRep(iDamage/10000);
self addRep(iDamage/-20000);
}
else
{
eAttacker addRep(iDamage/-10000);
}

if(self.stun>0&&isDefined(level.ammo[sWeapon])&&level.ammo[sWeapon]=="nonlethal")
{
self.stun=max(0,self.stun-int(iDamage*2));
if(!self.stun)
{
if(eAttacker.team!=self.team)
{
if(isDefined(eAttacker.missionId))
eAttacker.stat["stuns"]++;

if(isDefined(self.missionId))
self.stat["stuns"]--;

eAttacker.info["stuns"]++;
eAttacker thread killMessage(self,"STUN");
}
else
{
if(isDefined(eAttacker.missionId))
eAttacker.stat["stuns"]--;

eAttacker thread killMessage(self,"TEAMSTUN");
}

self killFeed(eAttacker,"stun_mp",isDefined(eAttacker.missionId),isDefined(self.missionId));

self thread stun();
}
self thread stunning();
}

eAttacker thread maps\mp\gametypes\_damagefeedback::updateDamageFeedback();


}
else
{
self addRep(iDamage/-20000);
}
}
else
{
if(sMeansOfDeath=="MOD_FALLING"&&isDefined(self.perks["quieter"]))
{

iDamage=int(iDamage*1.15);
}
self addRep(iDamage/-20000);
}




if((sHitLoc=="head"||sHitLoc=="helmet")&&sMeansOfDeath!="MOD_MELEE"&&sMeansOfDeath!="MOD_IMPACT")
sMeansOfDeath="MOD_HEAD_SHOT";

if(!isDefined(vDir))
iDFlags|=level.iDFLAGS_NO_KNOCKBACK;

if(!(iDFlags&level.iDFLAGS_NO_PROTECTION))
{
self finishPlayerDamage(eInflictor,eAttacker,iDamage,iDFlags,sMeansOfDeath,sWeapon,vPoint,vDir,sHitLoc,psOffsetTime);
self thread maps\mp\gametypes\_weapons::onWeaponDamage(eInflictor,sWeapon,sMeansOfDeath,iDamage);
self PlayRumbleOnEntity("damage_heavy");
}
}


stunning()
{
self notify("stundamage");
self endon("stundamage");
self endon("diconnect");
self endon("killed_player");
self endon("endmission");

wait 3;
while(self.stun<100)
{
self.stun=min(100,self.stun+30);
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

Callback_PlayerKilled(eInflictor,attacker,iDamage,sMeansOfDeath,sWeapon,vDir,sHitLoc,psOffsetTime,deathAnimDuration)
{
self endon("disconnect");
self notify("killed_player");

self.sessionstate="dead";

body=self clonePlayer(deathAnimDuration);

if(self isOnLadder()||self isMantling())
body startRagDoll();
else
 thread delayStartRagdoll(body,sHitLoc,vDir,sWeapon,eInflictor,sMeansOfDeath);

if(!isDefined(self.arrested))
{

if(isDefined(self.supplying))
self.supplying notify("break");

attackerIsPlayer=isDefined(attacker)&&isPlayer(attacker);
victimInMission=isDefined(self.missionId);
attackerInMission=isDefined(attacker.missionId);
victimPublicEnemy=self.prestige==5;
anyPublicEnemy=victimPublicEnemy||(attackerIsPlayer&&attacker.prestige==5);


if((!victimInMission&&!anyPublicEnemy))
{
wait 2;
self joinGame();
PrintLn("^1[DEBUG]"+self.showname+" not in mission.");
return;
}
PrintLn("^7[DEBUG] ^3"+self.showname+" died.");

if(!attackerIsPlayer)
attacker=self;

if(sMeansOfDeath=="MOD_MELEE")
sWeapon="knife_mp";

sameTeam=attacker.team==self.team;

self thread deathTheme(attacker);

if(sMeansOfDeath=="MOD_SUICIDE"||sMeansOfDeath=="MOD_TRIGGER_HURT"||sMeansOfDeath=="MOD_FALLING")
{
sWeapon="suicide_mp";
self addRep(-0.01);
}
else
{
if(sMeansOfDeath=="MOD_EXPLOSIVE"&&sWeapon=="none")
sWeapon="suicide_mp";

if(!sameTeam&&!victimPublicEnemy)
self addRep(-0.005);
}
weapon=getSubStr(sWeapon,0,sWeapon.size-3);


self killFeed(attacker,sWeapon,attackerInMission,victimInMission);

sameMission=victimInMission&&attackerInMission&&self.missionId==attacker.missionId;


wid=attacker getWeaponID(sWeapon);


if(attacker!=self)
{
if(sameTeam)
{
if(attackerInMission)
{
if(!attacker.stat["teamkills"])
{
attacker newMessage("^3"+level.s["TEAMKILL_REDUCES_"+attacker.lang]+"!");
}
attacker.stat["teamkills"]++;
if(attacker.stat["teamkills"]<=10)
{
attacker giveMedal("TEAMKILL"+attacker.stat["teamkills"]);
}
attacker thread killMessage(self,"TK");
attacker refreshStat("teamkills");
}

if(victimPublicEnemy)
attacker addRep(-1);
else if(isDefined(self.vip))
attacker addRep(-0.025);
else
 attacker addRep(-0.01);
}
else
{
time=getTime();


if(isDefined(level.weaps[wid].roleType))
{
role=level.weaps[wid].roleType;
if(role.size)
{
attacker.info["role_"+role]++;
attacker updateRole(role,true);
}


if(level.weaps[wid].class=="hvr")
{
if(attacker.lastKill==time)
{
attacker.lastKill=0;
attacker playSound("DoubleKill");
}
else
{
attacker.lastKill=time;
}
}
}

attacker.info["kills"]++;
attacker setClientDvar("kills",attacker.info["kills"]);



if(attacker.info["kills"]==10000)
attacker giveAchievement("HITMAN");



if(attackerInMission)
{

if(sWeapon=="frag_grenade_mp")
attacker giveMedal("GRENADE");


if(attacker.stat["blitz"]<=4)
{
if(attacker.stat["blitz"])
{
if(attacker.stat["blitz"]<=3)
goalTime=attacker.killTime+5000*attacker.stat["blitz"];

else goalTime=attacker.killTime+25000;


if(time<=goalTime)
{
attacker giveMedal("BLITZ"+attacker.stat["blitz"]);
attacker.stat["blitz"]++;
}
else
{
attacker.stat["blitz"]=1;
attacker.killTime=time;
}
}
else
{

attacker.stat["blitz"]=1;
attacker.killTime=time;
}
}


if(!isAlive(attacker))
attacker giveMedal("GRAVE");

if(victimInMission)
{

if(self.stat["streak"]>=5)
attacker giveMedal("BOUNTY");


if(!attacker.stat["streak"])
attacker thread killEmAll(self);
else
 attacker notify("kill",self);
}


attacker.stat["streak"]++;
if(attacker.stat["streak"]>=5)
{

if(attacker.stat["streak"]<=30&&!(attacker.stat["streak"]%5))
{
attacker giveMedal("STREAK"+(attacker.stat["streak"]/5));
attacker infoLine("STREAK",attacker.stat["streak"]);
}
info=spawnStruct();
info.title=level.s["STREAK_TITLE_"+attacker.lang];
info.line=level.s["KILLCOUNT_"+attacker.lang]+": "+attacker.stat["streak"];
info.icon="streak";
attacker thread gameMessage(info);
}

attacker.stat["kills"]++;
attacker thread killMessage(self,"KILL");
attacker refreshStat("kills","arrests","","8");
}
if(victimPublicEnemy)
attacker addRep(0.25);
else if(isDefined(self.vip))
attacker addRep(0.05);
else
 attacker addRep(0.02);

realMoney=20+int(self.rating/20);

if(isDefined(self.vip))
realMoney*=2;

if(victimPublicEnemy)
money=attacker giveMoney(500);
else
 money=attacker giveMoney(realMoney);

attacker newMessage(level.s["KILL_REWARD_"+attacker.lang]+": "+money.display+", "+(attacker giveStanding(int(realMoney*0.425)))+" "+level.s["STANDING_"+attacker.lang]);
}
}


if(isDefined(self.attackers))
{
__v30=self.attackers;__c30=__v30.size;__k30=getArrayKeys(__v30);for(__i30=0;__i30<__c30;__i30++)
{
__e30=__v30[__k30[__i30]];if(isDefined(__e30)&&__e30!=attacker)
{
__e30.stat["assists"]++;
__e30 thread killMessage(self,"ASSIST");
__e30 refreshStat("assists");
__e30.info["assists"]++;


if(__e30.info["assists"]==100)
__e30 giveAchievement("ASSIST");



money=__e30 giveMoney(13+int(self.rating/20));
standing=__e30 giveStanding(int(money.amount*0.425));
__e30 newMessage(level.s["ASSIST_REWARD_"+__e30.lang]+": "+money.display+", "+standing+" "+level.s["STANDING_"+__e30.lang]);



}
}__i30=undefined;__k30=undefined;__c30=undefined;__v30=undefined;
self.attackers=undefined;
}

if(victimPublicEnemy)
{
self addRep(-1);

if(attacker!=self)
{
info=spawnStruct();
info.icon="prestige_5_"+self.team;
if(sameTeam)
b="WRONG";
else
 b="TAKEN";

for(i=0;i<level.allActiveCount;i++)
{
info.title=level.s["BOUNTY"+b+"_TITLE_"+level.allActivePlayers[i].lang];
info.line="^2"+attacker.showname+"^7 "+level.s["BOUNTY_"+b+"_"+level.allActivePlayers[i].lang]+" ^2"+self.showname;
info.sound="BountyClaimed";
level.allActivePlayers[i]thread gameMessage(info);
}
}
self noPublicEnemy();
}

if(victimInMission)
{
self.stat["streak"]=0;
self.stat["deaths"]++;
self refreshStat("deaths");
}











self notify("deadfeed");

self.deadfeed["icon"]=newClientHudElem(self);
self.deadfeed["icon"].x=-32+16*(2-level.weaps[wid].width);
self.deadfeed["icon"].y=-38+8*(2-level.weaps[wid].height);
self.deadfeed["icon"].width=level.weaps[wid].width*32;
self.deadfeed["icon"].height=level.weaps[wid].height*16;
self.deadfeed["icon"].horzAlign="center";
self.deadfeed["icon"].vertAlign="middle";
self.deadfeed["icon"].alpha=0;
self.deadfeed["icon"].hideWhenInMenu=true;
self.deadfeed["icon"].foreground=true;
self.deadfeed["icon"].sort=-1;
self.deadfeed["icon"]setShader(level.weaps[wid].shader,self.deadfeed["icon"].width,self.deadfeed["icon"].height);

self.deadfeed["title"]=newClientHudElem(self);
self.deadfeed["title"].x=0;
self.deadfeed["title"].y=0;
self.deadfeed["title"].horzAlign="center";
self.deadfeed["title"].vertAlign="middle";
self.deadfeed["title"].alignX="center";
self.deadfeed["title"].alignY="middle";
self.deadfeed["title"].elemType="font";
self.deadfeed["title"].font="default";
self.deadfeed["title"].fontscale=1.4;
self.deadfeed["title"].color=(1,0.7,0);
self.deadfeed["title"].alpha=0;
self.deadfeed["title"].hideWhenInMenu=true;
self.deadfeed["title"].foreground=true;
self.deadfeed["title"].sort=-1;

if(attacker!=self)
self.deadfeed["title"].label=level.s["KILLED_BY_"+self.lang];
else
 self.deadfeed["title"].label=level.s["SUICIDE_"+self.lang];

self.deadfeed["name"]=newClientHudElem(self);
self.deadfeed["name"].x=0;
self.deadfeed["name"].y=15;
self.deadfeed["name"].horzAlign="center";
self.deadfeed["name"].vertAlign="middle";
self.deadfeed["name"].alignX="center";
self.deadfeed["name"].alignY="middle";
self.deadfeed["name"].elemType="font";
self.deadfeed["name"].font="default";
self.deadfeed["name"].fontscale=1.4;
self.deadfeed["name"].color=(1,0.7,0);
self.deadfeed["name"].alpha=0;
self.deadfeed["name"].hideWhenInMenu=true;
self.deadfeed["name"].foreground=true;
self.deadfeed["name"].sort=-1;

if(attacker!=self)
self.deadfeed["name"]setPlayerNameString(attacker);


k=getArrayKeys(self.deadfeed);
c=k.size;
for(i=0;i<c;i++)
{
self.deadfeed[k[i]]fadeOverTime(0.75);
self.deadfeed[k[i]].alpha=0.85;
}

wait 1;








self.deadbg=newClientHudElem(self);
self.deadbg.x=0;
self.deadbg.y=0;
self.deadbg.width=960;
self.deadbg.height=480;
self.deadbg.horzAlign="center";
self.deadbg.vertAlign="top";
self.deadbg.alignX="center";
self.deadbg.alignY="top";
self.deadbg.alpha=0;
self.deadbg.hideWhenInMenu=false;
self.deadbg.foreground=true;
self.deadbg.sort=-2;
self.deadbg setShader("killbg",960,480);
self.deadbg fadeOverTime(1.5);
self.deadbg.alpha=1;

wait 3;
for(i=0;i<c;i++)
{
self.deadfeed[k[i]]fadeOverTime(0.75);
self.deadfeed[k[i]].alpha=0;
}

if(isDefined(self.missionId))
self clientExec("setfromdvar info r_mode");

wait 1;





for(i=0;i<c;i++)
{
self.deadfeed[k[i]]destroy();
}



self.deadbg destroy();
self.deadbg=undefined;
self.deadfeed=undefined;
}
else
{
self.arrested=undefined;
printLn("^1[DEBUG]"+self.showname+" arrested.");

if(isDefined(self.missionId))
self clientExec("setfromdvar info r_mode");

wait 1;
}


if(isDefined(self.missionId))
{
mode=strTok(self getUserInfo("info"),"x");
if(mode.size==2)
{
self setClientDvars(
"width",mode[0],
"height",mode[1]
);
}
else
{

self setClientDvars(
"width",1024,
"height",768
);
}

self getRespawnData();

self setClientDvars(
"death_x",self.origin[0],
"death_y",self.origin[1]
);

self openMenu(game["menu_map"]);
self thread respawnWait();
self thread respawnEndMission();
self waittill("can_respawn");
self closeMenu(game["menu_map"]);
}
self joinGame();

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

delayStartRagdoll(ent,sHitLoc,vDir,sWeapon,eInflictor,sMeansOfDeath)
{
deathAnim=ent getCorpseAnim();

if(animHasNoteTrack(deathAnim,"ignore_ragdoll"))
return;

wait 0.2;

if(!isDefined(ent)||ent isRagDoll())
return;

startFrac=0.35;

if(animHasNoteTrack(deathAnim,"start_ragdoll"))
{
times=getNoteTrackTimes(deathAnim,"start_ragdoll");
if(isDefined(times))
startFrac=times[0];
}

wait startFrac*getAnimLength(deathAnim);

if(!isDefined(ent)||ent isRagDoll())
return;

ent startRagdoll(1);
}


killFeed(attacker,weapon,attackerInMission,victimInMission)
{
if(attackerInMission)
{
__v31=level.teams[attacker.missionTeam];__c31=__v31.size;for(__i31=0;__i31<__c31;__i31++)
{
__v31[__i31] handleNotify(attacker,self,weapon);
}__i31=undefined;__c31=undefined;__v31=undefined;
if(!victimInMission||attacker.enemyTeam!=self.missionTeam)
{
__v32=level.teams[attacker.enemyTeam];__c32=__v32.size;for(__i32=0;__i32<__c32;__i32++)
{
__v32[__i32] handleNotify(attacker,self,weapon);
}__i32=undefined;__c32=undefined;__v32=undefined;
}
}
if(victimInMission)
{
if(!attackerInMission||self.missionTeam!=attacker.missionTeam)
{
__v33=level.teams[self.missionTeam];__c33=__v33.size;for(__i33=0;__i33<__c33;__i33++)
{
__v33[__i33] handleNotify(attacker,self,weapon);
}__i33=undefined;__c33=undefined;__v33=undefined;
}
if(!attackerInMission||(self.enemyTeam!=attacker.missionTeam&&self.enemyTeam!=attacker.enemyTeam))
{
__v34=level.teams[self.enemyTeam];__c34=__v34.size;for(__i34=0;__i34<__c34;__i34++)
{
__v34[__i34] handleNotify(attacker,self,weapon);
}__i34=undefined;__c34=undefined;__v34=undefined;
}
}
}

deathTheme(attacker)
{
self endon("disconnect");


t=attacker.themes[attacker.info["theme"]];

for(i=0;i<32;i++)
{
for(j=0;j<=5;j++)
{
if(isDefined(t.tracks[j].nodes[i]))
{
id="theme_"+t.tracks[j].type+"_"+t.tracks[j].nodes[i];
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

if(isDefined(self.supplying))
self.supplying notify("break");

self.claimed=true;

self.stunTrigger=spawn("trigger_radius",self.origin,0,64,16);

self thread killStunned();
self thread endMissionStunned();
self thread disconnectStunned();
self thread resetStunned();

if(self.team=="axis")
self thread arrestStunned();

self shellShock("stun",10.35);
self newLoadBar(0,10.35);

self clientExec("gocrouch");
wait 0.2;
self freezeControls(true);
self setPlayerAngles((60,self.angles[1],0));
wait 10;

if(isDefined(self.arresting))
self waittill("unarrested");

self freezeControls(false);


self clientExec("+gostand");

wait 0.15;

self killLoadBar();

self notify("unstun");
}

arrestStunned()
{
self endon("unstun");

while(true)
{
self.stunTrigger waittill("trigger",p);

if(p.team=="allies"&&p useButtonPressed()&&(self.prestige==5||p.prestige==5||(isDefined(p.enemyTeam)&&p.enemyTeam==self.missionTeam))&&!isDefined(p.claimed)){
p.claimed=true;
p newLoadBar(0,2);
p disableWeapons();
p freezeControls(true);

p thread killArrest();
p thread endMissionArrest();
p thread disconnectArrest();
p thread stunArrest();
p thread endArrest();
p thread resetArrest();

self.arresting=true;
self thread killArrest();
self thread endMissionArrest();
self thread disconnectArrest();
self thread stunArrest();
self thread waitArrest(p);

self waittill("endarrest");
self.arresting=undefined;

p notify("endarrest");

if(isDefined(self.arrested))
{
self killLoadBar();
self.stunTrigger delete();
self notify("arrested");

self.stat["arrests"]--;
self refreshStat("arrests");

p.info["arrests"]++;
p setClientDvar("arrests",p.info["arrests"]);
p.stat["arrests"]++;
p refreshStat("arrests");
p.info["role_nonlethal"]++;
p updateRole("nonlethal",true);

p thread killMessage(self,"ARREST");


self killFeed(p,"arrest_mp",isDefined(p.missionId),isDefined(self.missionId));


if(self.prestige==5)
p addRep(1);
else if(isDefined(self.vip))
p addRep(0.2);
else
 p addRep(0.08);


realMoney=40+int(self.rating/10);

if(isDefined(self.vip))
realMoney*=2;

if(self.prestige==5)
money=p giveMoney(1000);
else
 money=p giveMoney(realMoney);

p newMessage(level.s["ARREST_REWARD_"+p.lang]+": "+money.display+", "+(p giveStanding(int(realMoney*0.425)))+" "+level.s["STANDING_"+p.lang]);

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

a=1;
wait 0.05;

while(p useButtonPressed()&&a<40){
a++;
wait 0.05;
}

if(a==40)
self.arrested=true;

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

if(isDefined(self))
{
self.stun=100;
self freezeControls(false);
self enableWeapons();
self killLoadBar();

if(isDefined(self.arresting))
self.arresting=undefined;

if(isDefined(self.arrested))
self.arrested=undefined;

if(isDefined(self.stunTrigger))
self.stunTrigger delete();

if(isDefined(self.claimed))
self.claimed=undefined;

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

self.claimed=undefined;
self freezeControls(false);
self enableWeapons();
self killLoadBar();
}

noPublicEnemy()
{
level.public[self.team][self.pubId]=undefined;
level.public[level.enemy[self.team]][self.pubId]=undefined;
for(i=0;i<level.activeCount[self.team];i++)
{
level.activePlayers[self.team][i]setClientDvar(
"map_friendpublic"+self.pubId+"z",

"");
}
for(i=0;i<level.activeCount[level.enemy[self.team]];i++)
{
level.activePlayers[level.enemy[self.team]][i]setClientDvar(
"map_enemypublic"+self.pubId+"z",

"");
}
self.pubId=undefined;
}












killEmAll(first)
{
self endon("disconnect");
self endon("endmission");

killed[0]=first;
time=getTime();
while(isDefined(killed))
{
self waittill("kill",enemy);
curTime=getTime();
if(time+5000>=curTime)
{
exists=false;
for(i=0;i<killed.size&&!exists;i++)
{
if(killed[i]==enemy)
{
exists=true;
}
}
if(!exists)
{
if(killed.size+1==level.teams[self.enemyTeam].size)
{
killed=undefined;
self giveMedal("ALL");
}
else
{
killed[killed.size]=enemy;
}
}
}
else
{
killed=[];
killed[0]=enemy;
}
}
}


infoLine(text,value,id)
{

if(isDefined(value))
{
isString=!int(value);
for(i=0;i<level.allActiveCount;i++)
{
if(isString)
{
val=level.s[value+"_"+level.allActivePlayers[i].lang];

if(isDefined(id))
{
val+=" "+id;
}
}
else
{
val=value;
}

level.allActivePlayers[i]thread showInfoLine(self.showname+" "+level.s["INFO_"+text+"_"+level.allActivePlayers[i].lang]+" "+val);
}
}




















}

showInfoLine(txt)
{
self endon("disconnect");
self notify("infoline");
self endon("infoline");

if(isDefined(self.respawnData))
{
self waittill("spawned");

if(!isDefined(self.missionId))
return;
}

self playLocalSound("Info");
self setClientDvar("infoline",txt);
wait 4;
self setClientDvar("infoline","");
}

mainLine(text1,text2,sound)
{
self endon("disconnect");
self notify("mainline");
self endon("mainline");

if(isDefined(self.respawnData))
{
self waittill("spawned");

if(!isDefined(self.missionId))
return;
}

if(!isDefined(text2))
text2="";

if(!isDefined(sound))
sound="MainInfo";

self playLocalSound(sound);
self setClientDvar("mainline1",text1);
self setClientDvar("mainline2",text2);
wait 4;
self setClientDvar("mainline1","");
self setClientDvar("mainline2","");
}

boldLine(msg,sound)
{
self endon("disconnect");
self notify("boldline");
self endon("boldline");

if(isDefined(self.respawnData))
{
self waittill("spawned");

if(!isDefined(self.missionId))
return;
}

if(!isDefined(sound))
sound="MainInfo";

self playLocalSound(sound);
self setClientDvar("boldline",msg);
wait 4;
self setClientDvar("boldline","");
}

addRep(amount)
{
if(!amount||(amount>0&&self.prestige==5&&self.reputation==0.99)||(amount<0&&self.prestige==1&&!self.reputation))
return 0;

new=self.reputation+amount;
if(new>=1)
{
if(self.prestige==5||(self.prestige==4&&level.tutorial))
{
self.reputation=0.99;
}
else
{
self.prestige++;
self playLocalSound("StarUp");
if(self.prestige==5)
{

for(self.pubId=0;isDefined(level.public[self.team][self.pubId]);self.pubId++){};

level.public[self.team][self.pubId]=self;
for(i=0;i<level.activeCount[level.enemy[self.team]];i++)
{
p=level.activePlayers[level.enemy[self.team]][i];
if((!isDefined(self.missionId)||!isDefined(p.missionId)||self.missionTeam!=p.enemyTeam)&&p.prestige!=5)
{
self newPoint("ofpublicenemypnt","enemy",p);
p newPoint("publicenemypnt","enemy",self);
}
}
for(i=0;i<level.activeCount[self.team];i++)
{
p=level.activePlayers[self.team][i];
if((!isDefined(self.missionId)||!isDefined(p.missionId)||self.missionTeam!=p.missionTeam)&&p.prestige!=5)
{
p newPoint("publicfriendpnt","friend",self);

}
}

info=spawnStruct();
info.icon="prestige_5_"+self.team;
info.sound="BountyAlert";

for(i=0;i<level.allActiveCount;i++)
{
if(level.allActivePlayers[i]!=self)
{
info.title=level.s["BOUNTY_TITLE_"+level.allActivePlayers[i].lang];
info.line=level.s["BOUNTY_PLACED_"+level.allActivePlayers[i].lang]+":\n^2"+self.showname;
level.allActivePlayers[i]thread gameMessage(info);
}
}

info.title=level.s["BOUNTY_TITLE_"+self.lang];
info.line=level.s["BOUNTY_PLACED_YOU_"+self.lang];
info.sound="BountyGot";
self thread gameMessage(info);

self thread monitorPrestigeTime();
}
self.reputation=new-1;
}
}
else if(new<0)
{
if(self.prestige==1)
{
self.reputation=0;
}
else
{
self playLocalSound("StarDown");
self.prestige--;
self.reputation=1+new;
}
}
else
{
self.reputation=new;
}

self setClientDvars(
"prestige",self.prestige,
"rep",self.reputation
);
self.info["reptime"]=getRealTime();
self.info["rep"]=int((self.prestige+self.reputation)*10000);


}

giveMedal(big)
{
type=toLower(big);
if(isDefined(self.stat["medals"][type]))
return;

self.stat["medals"][type]=int(tableLookup("mp/medalTable.csv",1,type,3));
__v35=level.teams[self.missionTeam];__c35=__v35.size;for(__i35=0;__i35<__c35;__i35++)
{
__e35=__v35[__i35];
__e35.playerStats[self.clientid].medals[__e35.playerStats[self.clientid].medals.size]=type;
}__i35=undefined;__c35=undefined;__v35=undefined;
__v36=level.teams[self.enemyTeam];__c36=__v36.size;for(__i36=0;__i36<__c36;__i36++)
{
__e36=__v36[__i36];
__e36.playerStats[self.clientid].medals[__e36.playerStats[self.clientid].medals.size]=type;
}__i36=undefined;__c36=undefined;__v36=undefined;

s="MEDAL_"+tableLookup("mp/medalTable.csv",1,type,2);
self newMessage(level.s["MEDAL_EARNED_"+self.lang]+": "+level.s[s+"_"+self.lang]);
self infoLine("MEDAL",s);

if(self.stat["medals"][type]>0)
{
self addRep(0.01);

self.info["medals"]++;
self setClientDvar("medals",self.info["medals"]);

if(self.info["medals"]==100)
self giveAchievement("MEDAL");


}
else
{
self addRep(-0.01);
}




info=spawnStruct();
info.title=level.s["MEDAL_TITLE_"+self.lang];
info.line=level.s["MEDAL_"+big+"_"+self.lang];
info.icon="medal";
info.sound="EarnItem";
self thread gameMessage(info);
}

refreshStat(type,type2,prefix,extcolor)
{
if(!isDefined(prefix))
prefix="";

val=prefix+self.stat[type];
if(isDefined(type2))
{
if(!isDefined(extcolor))
extcolor="3";

val+="^"+extcolor+" + "+prefix+self.stat[type2];
}

__v37=level.teams[self.missionTeam];__c37=__v37.size;for(__i37=0;__i37<__c37;__i37++)
{
__v37[__i37] setClientDvar("ui_friend_"+type+self.teamId,val);
}__i37=undefined;__c37=undefined;__v37=undefined;
__v38=level.teams[self.enemyTeam];__c38=__v38.size;for(__i38=0;__i38<__c38;__i38++)
{
__v38[__i38] setClientDvar("ui_enemy_"+type+self.teamId,val);
}__i38=undefined;__c38=undefined;__v38=undefined;
}

quitGroup()
{
self.group=undefined;
self.groupleader=undefined;
self.groupId=undefined;
self.groupmgrid=undefined;
self.ready=false;
self setClientDvars(
"ready",false,
"groupId","",
"group_count",0,
"inviting",1
);





if(!isDefined(self.missionId))
{
self setClientDvars(
"name0",self.showname,
"status0","notready",
"leader0","",
"leftoffset",1
);








}
}

kickTeam()
{

if(isDefined(level.missions[self.missionId].points))
{
__v39=level.missions[self.missionId].points;__c39=__v39.size;for(__i39=0;__i39<__c39;__i39++)
{
__e39=__v39[__i39];v=getArrayKeys(__e39.visible);
__c40=v.size;if(__c40){for(__i40=0;__i40<__c40;__i40++)
{
__e40=v[__i40];__e39.team[__e40]hide();
for(k=0;k<__e39.visible[__e40].size;k++)
{


if(__e39.visible[__e40][k]==self)
{__c=__e39.visible[__e40].size-1;if(k!=__c)__e39.visible[__e40][k]=__e39.visible[__e40][__c];__e39.visible[__e40][__c]=undefined;}
else
 __e39.team[__e40]showToPlayer(__e39.visible[__e40][k]);
}
}__i40=undefined;}__c40=undefined;
}__i39=undefined;__c39=undefined;__v39=undefined;
}

self maps\mp\gametypes\_menus::delPlacedHud();

t=level.teams[self.missionTeam];
c=t.size;
te=level.teams[self.enemyTeam];
ce=te.size;

leader=0;
friendThreat=0;
for(i=0;i<c;i++)
{
__e41=t[i];__e41 removeFromRadar("map_friendly"+self.teamId);
friendThreat+=level.threatValue[__e41.threat];
if(isDefined(__e41.teamleader))
{
leader=i;
}
}i=undefined;

enemyThreat=0;
for(__i42=0;__i42<ce;__i42++)
{
enemyThreat+=level.threatValue[te[__i42].threat];
}__i42=undefined;

if(c<ce||(c==ce&&enemyThreat-friendThreat>=c))
{
t[leader]setClientDvar("leftinfo","CALL_BACKUP");
}

self.missionTeam=undefined;
self killLoadBar();
self quitTeam();
self setClientDvars(
"missionstatus","LOSE",
"missionstatus_desc","KICKED"
);
if(isDefined(self.group))
{
refreshGroup(self.group);
}




























}

abandonGroup(id)
{
if(level.groups[id].groupReady)
{
{__c=level.readyGroups[level.groups[id].side].size;if(__c>1){for(i=0;i<__c;i++){if(level.readyGroups[level.groups[id].side][i]==id){last=__c-1;if(i<last)level.readyGroups[level.groups[id].side][i]=level.readyGroups[level.groups[id].side][last];level.readyGroups[level.groups[id].side][last]=undefined;break;}}}else{level.readyGroups[level.groups[id].side]=[];}}
}

__v43=level.groups[id].team;__c43=__v43.size;for(__i43=0;__i43<__c43;__i43++)
{

__e43=__v43[__i43];if(!isDefined(__e43.leaving))
{
__e43 quitGroup();
__e43 newMessage("^2"+level.s["GROUP_ABADONED_"+__e43.lang]+"!");
}
}__i43=undefined;__c43=undefined;__v43=undefined;

last=level.groups.size-1;
if(id!=last)
{
__v44=level.groups[last].team;__c44=__v44.size;for(__i44=0;__i44<__c44;__i44++)
{
__v44[__i44].group=id;
}__i44=undefined;__c44=undefined;__v44=undefined;
}
{__c=level.groups.size-1;if(id!=__c)level.groups[id]=level.groups[__c];level.groups[__c]=undefined;}
}

refreshTeam(id)
{
t=level.teams[id];
e=level.teams[t[0].enemyTeam];
tsize=t.size;
esize=e.size;

for(i=0;i<tsize;i++)
{
__e45=t[i];__e45.teamId=i;
__e45 setClientDvars(
"leftoffset",tsize,
"ui_friend_count",tsize
);
for(j=0;j<tsize;j++)
{


q=t[j];

if(isDefined(q.teamleader))
leader="team";
else if(isDefined(q.groupleader)&&isDefined(__e45.group)&&__e45.group==q.group)
leader="group";
else
 leader="";

__e45 setClientDvars(
"name"+j,"^2"+q.showname,
"status"+j,"ready",
"leader"+j,leader,
"ui_friend_name"+j,q.showname,
"ui_friend_kills"+j,q.stat["kills"]+"^8 + "+q.stat["assists"],
"ui_friend_arrests"+j,q.stat["arrests"],
"ui_friend_deaths"+j,q.stat["deaths"],
"ui_friend_targets"+j,q.stat["targets"],
"ui_friend_medals"+j,q.stat["medals"].size,
"ui_friend_cash"+j,"$"+q.stat["cash"]+"^3 + $"+q.stat["pcash"],
"ui_friend_standing"+j,q.stat["standing"]+"^3 + "+q.stat["pstanding"],
"ui_friend_icon"+j,level.ranks[q.rating]["id"]+"_"+q.team,
"ui_friend_threat"+j,q.threat,
"team"+j,
q.showname);






















}

__e45.clientids["friend"]=[];
__e45.clientids["enemy"]=[];

for(j=0;j<esize;j++)
{
__e45.clientids["enemy"][j]=e[j].clientid;
}

for(j=0;j<tsize;j++)
{
__e45.clientids["friend"][j]=t[j].clientid;
}
}i=undefined;
for(i=0;i<esize;i++)
{
__e46=e[i];__e46.teamId=i;
__e46 setClientDvar("ui_enemy_count",tsize);
for(j=0;j<tsize;j++)
{


q=t[j];

__e46 setClientDvars(
"ui_enemy_name"+j,q.showname,
"ui_enemy_kills"+j,q.stat["kills"]+"^8 + "+q.stat["assists"],
"ui_enemy_arrests"+j,q.stat["arrests"],
"ui_enemy_deaths"+j,q.stat["deaths"],
"ui_enemy_targets"+j,q.stat["targets"],
"ui_enemy_medals"+j,q.stat["medals"].size,
"ui_enemy_cash"+j,"$"+q.stat["cash"]+"^3 + $"+q.stat["pcash"],
"ui_enemy_standing"+j,q.stat["standing"]+"^3 + "+q.stat["pstanding"],
"ui_enemy_icon"+j,level.ranks[q.rating]["id"]+"_"+q.team,
"ui_enemy_threat"+j,q.threat
);


















}

__e46.clientids["enemy"]=[];
__e46.clientids["friend"]=[];

for(j=0;j<tsize;j++)
{
__e46.clientids["enemy"][j]=t[j].clientid;
}

for(j=0;j<esize;j++)
{
__e46.clientids["friend"][j]=e[j].clientid;
}
}i=undefined;



}

refreshGroup(id)
{
g=level.groups[id].team;
gsize=g.size;

if(!level.groups[id].inMission)
{
team=level.groups[id].side;

wasReady=level.groups[id].groupReady;
ready=true;
for(i=0;i<gsize&&ready;i++)
{
if(!g[i].ready)
{
ready=false;
}
}

if(ready!=wasReady)
{
level.groups[id].groupReady=ready;

if(ready)
level.readyGroups[team][level.readyGroups[team].size]=id;
else
{__c=level.readyGroups[team].size;if(__c>1){for(i=0;i<__c;i++){if(level.readyGroups[team][i]==id){last=__c-1;if(i<last)level.readyGroups[team][i]=level.readyGroups[team][last];level.readyGroups[team][last]=undefined;break;}}}else{level.readyGroups[team]=[];}}
}
}
else
{
ready=false;
}

for(i=0;i<gsize;i++)
{
__e47=g[i];notInMission=!isDefined(__e47.missionId);
if(notInMission)
{
__e47 setClientDvars(
"ready",ready,
"leftoffset",gsize
);
}

__e47.groupId=i;
__e47 setClientDvars(
"groupId",__e47.groupId,
"group_count",gsize
);

for(j=0;j<gsize;j++)
{



__e48=g[j];if(notInMission)
{
if(!isDefined(__e48.missionId))
{
if(__e48.ready)
{
__e47 setClientDvars(
"name"+j,"^2"+__e48.showname,
"status"+j,"ready"
);
}
else
{
__e47 setClientDvars(
"name"+j,__e48.showname,
"status"+j,"notready"
);
}
}
else
{
__e47 setClientDvars(
"name"+j,__e48.showname,
"status"+j,"mission"
);
}

if(isDefined(__e48.groupleader))
__e47 setClientDvar("leader"+j,"group");
else
 __e47 setClientDvar("leader"+j,"");
}

__e47 setClientDvar("group"+j,__e48.showname);










}j=undefined;
}i=undefined;
}

unreadyPlayer()
{
{__c=level.readyPlayers[self.team].size;if(__c>1){for(i=0;i<__c;i++){if(level.readyPlayers[self.team][i]==self){last=__c-1;if(i<last)level.readyPlayers[self.team][i]=level.readyPlayers[self.team][last];level.readyPlayers[self.team][last]=undefined;break;}}}else{level.readyPlayers[self.team]=[];}}
}

killMessage(enemy,type)
{
self endon("disconnect");


info=spawnStruct();
info.enemy=enemy.showname;
info.type=type;
self.feeds[self.feeds.size]=info;

if(self.feeds.size==1)
{
if(!isAlive(self))
{
info=undefined;
self waittill("spawned_player");
}
self thread startKillMessage(0);
}
}

handleNotify(attacker,victim,weapon)
{
s=spawnStruct();
s.weapon=getSubStr(weapon,0,weapon.size-3);
s.img=level.weaps[attacker getWeaponID(weapon)].shader;
s.offset=victim.namelen;


if(attacker!=victim)
{
if(self.team==attacker.team)
s.attacker="^2"+attacker.showname;
else
 s.attacker="^1"+attacker.showname;
}
else
{
s.attacker="";
}

if(self.team==victim.team)
s.victim="^2"+victim.showname;
else
 s.victim="^1"+victim.showname;

if(self.notifies.size==5)
{
for(i=0;i<4;i++)
{
self.notifies[i]=self.notifies[i+1];
self setFeed(i);
}
self.notifies[4]=s;
}
else
{
self.notifies[self.notifies.size]=s;

if(self.notifies.size==1)
self thread hideFeed();
}
self setFeed(self.notifies.size-1);
}

setFeed(id)
{
s=id;
id++;
self setClientDvars(
"feed"+id+"_attacker",self.notifies[s].attacker,
"feed"+id+"_victim",self.notifies[s].victim,
"feed"+id+"_weapon",self.notifies[s].weapon,
"feed"+id+"_img",self.notifies[s].img,
"feed"+id+"_offset",self.notifies[s].offset
);
}

hideFeed()
{
self endon("disconnect");
self notify("hidefeed");
self endon("hidefeed");


wait 10;

size=self.notifies.size;
last=size-1;
for(i=0;i<last;i++)
{
self.notifies[i]=self.notifies[i+1];
self setFeed(i);
}
self setClientDvars(
"feed"+size+"_attacker","",
"feed"+size+"_victim","",
"feed"+size+"_weapon","",
"feed"+size+"_img","",
"feed"+size+"_offset",""
);
self.notifies[last]=undefined;

if(last)
self thread hideFeed();
}

startKillMessage(id)
{
self endon("disconnect");

self.feed["icon"]=newClientHudElem(self);
self.feed["icon"].x=-12;
self.feed["icon"].y=103;
self.feed["icon"].width=24;
self.feed["icon"].height=24;
self.feed["icon"].horzAlign="center";
self.feed["icon"].vertAlign="middle";
self.feed["icon"].alpha=0;
self.feed["icon"].hideWhenInMenu=true;

self.feed["title"]=newClientHudElem(self);
self.feed["title"].x=0;
self.feed["title"].y=135;
self.feed["title"].horzAlign="center";
self.feed["title"].vertAlign="middle";
self.feed["title"].alignX="center";
self.feed["title"].alignY="middle";
self.feed["title"].elemType="font";
self.feed["title"].font="default";
self.feed["title"].fontscale=1.4;
self.feed["title"].color=(1,0.7,0);
self.feed["title"].alpha=0;
self.feed["title"].hideWhenInMenu=true;

self.feed["name"]=newClientHudElem(self);
self.feed["name"].x=0;
self.feed["name"].y=150;
self.feed["name"].horzAlign="center";
self.feed["name"].vertAlign="middle";
self.feed["name"].alignX="center";
self.feed["name"].alignY="middle";
self.feed["name"].elemType="font";
self.feed["name"].font="default";
self.feed["name"].fontscale=1.4;
self.feed["name"].color=(1,1,1);
self.feed["name"].alpha=0;
self.feed["name"].hideWhenInMenu=true;

self.feed["icon"]setShader("skull",24,24);
self.feed["title"].label=level.s["FEED_"+self.feeds[id].type+"_"+self.lang];

self.feed["name"]setText(self.feeds[id].enemy);

if(self.feeds[id].type=="KILL")
self playLocalSound("EnemyKilled");
else if(self.feeds[id].type=="ASSIST")
self playLocalSound("EnemyAssist");
else if(self.feeds[id].type=="ARREST")
self playLocalSound("EnemyArrested");

k=getArrayKeys(self.feed);
c=k.size;
for(i=0;i<c;i++)
{
self.feed[k[i]]fadeOverTime(0.25);
self.feed[k[i]].alpha=0.85;
}
wait 4;
for(i=0;i<c;i++)
{
self.feed[k[i]]fadeOverTime(0.25);
self.feed[k[i]].alpha=0;
}

wait 0.25;

for(i=0;i<c;i++)
{
self.feed[k[i]]destroy();
}
self.feed=undefined;

wait 0.25;

id++;

if(self.feeds.size>id)
self thread startKillMessage(id);
else
 self.feeds=[];
}






















giveAchievement(type)
{
small=toLower(type);
id=int(tableLookup("mp/achievementTable.csv",1,small,0));
if(id&self.info["achievements"])
return;

bit=1;
for(i=2;i<=id;i++)
{
bit*=2;
}
self.info["achievements"]|=bit;







self infoLine("ACHIEVEMENT","ACHIEVEMENT_"+type);

info=spawnStruct();
info.title=level.s["ACHIEVEMENT_TITLE_"+self.lang];
info.line=level.s["ACHIEVEMENT_"+type+"_"+self.lang];
info.icon="achievement_"+small;
info.sound="EarnItem";
self thread gameMessage(info);
}










































































joinGame()
{
self endon("disconnect");
self notify("spawned");
self notify("end_respawn");

resetTimeout();
self stopShellshock();
self stopRumble("damage_heavy");

self.statusicon="";
self.sessionstate="playing";
self.maxhealth=200;
self.health=self.maxhealth;
self.stun=100;
self setMoveSpeedScale(1);

if(isDefined(self.clone))
self.clone delete();

if(!self.spawned)
{











self setClientDvars(
"compassSize",1,
"ui_hud_obituaries",0,
"cg_drawCrosshairNames",1,
"cg_drawThroughWalls",1,
"cg_cursorHints",4,
"cg_overheadRankSize",0,
"cg_overheadIconSize",0,
"chat_on",0,
"money",self.info["money"],
"mod1","empty",
"mod2","empty",
"mod3","empty",
"ready",0,
"items",0,
"inviting",1,
"compassMaxRange",2147483647,
"compassMinRange",2147483647,
"line1","",
"line2","",
"name0",self.showname,
"status0","notready",
"leader0","",
"leftoffset",1,
"timeleft","",
"mission_title","",
"mission_desc","",
"mission",false,
"teamid","",
"counter1","",
"counter2","",
"chat1","",
"chat2","",
"chat3","",
"chat4","",
"chat5","",
"chat6","",
"group1","",
"group2","",
"group3","",
"group4","",
"prestige",2,
"rep",0.5,
"tutid",0,
"symbol",self.info["symbol"],
"symbols",self.info["symbols"],
"leftinfo","CHANGE_TO_READY",
"location","SOCIAL",
"infoline","",
"mainline1","",
"mainline2","",
"chattype","d",
"alert","",
"error","",
"music_title","---",


"music_playing","",
"musicstatus","all",
"side",self.team,
"enemy",level.enemy[self.team],
"ip",level.ip,
"group_count",0,
"team_count",0
);
for(i=1;i<=5;i++)
{
self setClientDvars(
"feed"+i+"_attacker","",
"feed"+i+"_victim","",
"feed"+i+"_weapon","",
"feed"+i+"_img","",
"feed"+i+"_offset",0
);
}
for(i=0;i<8;i++)
{
self setClientDvars(
"map_obj"+i+"z","",













"map_enemy"+i+"z",

"");
}
for(i=1;i<8;i++)
{
self setClientDvars(




"map_friendly"+i+"z",

"");
}





if(level.social)
self setClientDvar("cg_drawFriendlyNames",1);
else
 self setClientDvar("cg_drawFriendlyNames",0);

if(level.tutorial)
self setClientDvar("tutid",1);
else
 self setClientDvar("tutid",0);


__v49=level.roleList;__c49=__v49.size;for(__i49=0;__i49<__c49;__i49++)
{
__e49=__v49[__i49];type=getRoleType(__e49);
nextlevel=0;
count=0;
__v50=level.roles[type];__c50=__v50.size+1;if(__c50!=1){for(key=1;key<__c50;key++)
{
count+=__v50[key];
if(self.info["role_"+__e49]<count)
{
nextlevel=key;
break;
}
}key=undefined;}__c50=undefined;__v50=undefined;
self.roleLevel[__e49]=nextlevel-1;
}__i49=undefined;__c49=undefined;__v49=undefined;

self.startTime=getTime();
self clientExec("exec apb; setdvartotime time_start");

self queryThreat();
self getTimeZone();
self getCurTime(getRealTime());

if(!isDefined(self.isBot))
self thread watchMails();


if(!level.developer)
{
self setStat(3153,self.info["lang"]);
self setStat(3154,self.info["faction"]);
}

if(level.action)
self createPins();

level.activePlayers[self.team][level.activeCount[self.team]]=self;
level.activeCount[self.team]++;
level.allActivePlayers[level.allActiveCount]=self;
level.allActiveCount++;
updateServerStat("count_"+self.team+" = "+level.activeCount[self.team]);



self.spawned=true;

if(level.tutorial&&!isDefined(self.isBot))
{
level.bots++;
setDvar("sv_maxclients",level.maxClients+level.bots);
self.bot=addTestClient();
self.bot.master=self;
self.bot thread setupBot();
}

self thread monitorPlayer();
}

























if(self.info["dress"])
{
self maps\mp\gametypes\_menus::loadModel();

if(isDefined(self.spawn))
{
self spawn(self.spawn.origin,self.spawn.angles);
self.spawn=undefined;
self.respawnData=undefined;
}
else
{

if(isDefined(self.respawnData)&&self.respawnData.size)
{
p=[];c=self.respawnData.size;ps=0;for(i=0;i<c;i++){if(!positionWouldTelefrag(self.respawnData[i].origin)){p[ps]=self.respawnData[i];ps++;}}if(ps)spawnPoint=p[randomInt(ps)];else spawnPoint=self.respawnData[randomInt(c)];
}
else if(isDefined(self.missionId))
{
p=[];c=level.spawns.size;ps=0;for(i=0;i<c;i++){if(!positionWouldTelefrag(level.spawns[i].origin)){p[ps]=level.spawns[i];ps++;}}if(ps)spawnPoint=p[randomInt(ps)];else spawnPoint=level.spawns[randomInt(c)];
}
else
{
p=[];c=level.spawn[self.team].size;ps=0;for(i=0;i<c;i++){if(!positionWouldTelefrag(level.spawn[self.team][i].origin)){p[ps]=level.spawn[self.team][i];ps++;}}if(ps)spawnPoint=p[randomInt(ps)];else spawnPoint=level.spawn[self.team][randomInt(c)];
}

if(isDefined(self.respawnData))
self.respawnData=undefined;

self spawn(spawnPoint.origin,spawnPoint.angles);
}

if(isDefined(self.firstDress))
{
self.firstDress=undefined;
self thread delayTutorial();
}
else if(level.tutorial)
{
self thread delayTutorial();
}

self thread watchSprint();
self giveSupplier();
}

self.primaryWeapon=level.weaps[self.info["prime"]].weap;
self.secondaryWeapon=level.weaps[self.info["secondary"]].weap;
self.offhandWeapon=level.weaps[self.info["offhand"]].weap;


isM16=level.weaps[self.info["prime"]].image=="rotated_m16";

self giveWeapon(self.primaryWeapon,self.weapons[self.wID[self.info["prime"]]]["camo"]);
self giveWeapon(self.secondaryWeapon);
self giveWeapon(self.offhandWeapon);
self.currentWeapon=self.primaryWeapon;
primaryAmmoType=level.ammo[self.primaryWeapon];
secondaryAmmoType=level.ammo[self.secondaryWeapon];
offhandAmmoType=level.ammo[self.offhandWeapon];
maxAmmo=isDefined(self.perks["extraammo"]);
if(maxAmmo)
{
primaryAmmoMax=weaponMaxAmmo(self.primaryWeapon);
secondaryAmmoMax=weaponMaxAmmo(self.secondaryWeapon);
}
else
{
primaryAmmoMax=weaponStartAmmo(self.primaryWeapon);
secondaryAmmoMax=weaponStartAmmo(self.secondaryWeapon);
}


if(self.info["ammo_"+primaryAmmoType]>=primaryAmmoMax)
{
if(maxAmmo)
{
self giveMaxAmmo(self.primaryWeapon);
}
}
else
{
clipSize=weaponClipSize(self.primaryWeapon);
if(clipSize<=self.info["ammo_"+primaryAmmoType])
{
if(isM16)
{
new=self.info["ammo_"+primaryAmmoType]-clipSize;
self setWeaponAmmoStock(self.primaryWeapon,new-new%3);
}
else
{
self setWeaponAmmoStock(self.primaryWeapon,self.info["ammo_"+primaryAmmoType]-clipSize);
}
}
else
{
if(isM16)
self setWeaponAmmoClip(self.primaryWeapon,self.info["ammo_"+primaryAmmoType]-self.info["ammo_"+primaryAmmoType]%3);
else
 self setWeaponAmmoClip(self.primaryWeapon,self.info["ammo_"+primaryAmmoType]);

self setWeaponAmmoStock(self.primaryWeapon,0);
}
}


ammo=self.info["ammo_"+secondaryAmmoType];
if(primaryAmmoType==secondaryAmmoType)
ammo-=primaryAmmoMax;

if(ammo>=secondaryAmmoMax)
{
if(maxAmmo)
{
self giveMaxAmmo(self.secondaryWeapon);
}
}
else
{
clipSize=weaponClipSize(self.secondaryWeapon);
if(clipSize<=ammo)
{
self setWeaponAmmoStock(self.secondaryWeapon,ammo-clipSize);
}
else
{
self setWeaponAmmoClip(self.secondaryWeapon,ammo);
self setWeaponAmmoStock(self.secondaryWeapon,0);
}
}


if(self.info["ammo_"+offhandAmmoType]<weaponStartAmmo(self.offhandWeapon))
{
self setWeaponAmmoClip(self.offhandWeapon,self.info["ammo_"+offhandAmmoType]);
}

self setClientDvar("weapinfo_offhand",self getAmmoCount(self.offhandWeapon));

self setSpawnWeapon(self.primaryWeapon);

waittillframeend;
self notify("spawned_player");





if(!self.info["dress"])
{
self.firstDress=true;
self.info["dress"]=randomIntRange(1,17);
self maps\mp\gametypes\_menus::loadModel();

if(!isDefined(self.isBot))
{
sql_exec("INSERT INTO players (name, pass, faction, dress, lang, inv, status, timestamp) VALUES ('"+self.showname+"', '"+self.info["pass"]+"', "+self.info["faction"]+", "+self.info["dress"]+", "+self.info["lang"]+", '"+self.info["inv"]+"', '"+level.server+"', "+getRealTime()+")");
}


wait 0.05;
self openMenu(game["menu_dress"]);


}












}

createPuzzle()
{
self openMenu(game["menu_puzzle"]);


self.puzzle=spawnStruct();


temp=[];
nodes=[];
for(i=0;i<9;i++)
{

if(i<5){

if(i<3){
from=i*3;
max=from+3;
}

else{
from=9+(i-3)*4;
max=from+4;
}

id=randomIntRange(from,max);
temp[id]=true;
nodes[i]=id;


if(i==4)
{
n=[];
arr=[];arr[0]=0;arr[1]=1;arr[2]=2;arr[3]=3;arr[4]=4;
c=5;
while(c)
{
d=randomInt(c);
c--;
n[c]=nodes[arr[d]];
if(d!=c)
{
arr[d]=arr[c];
}
arr[c]=undefined;
}
nodes=n;
}
}

else{
id=0;


if(i%2)
{
from=0;
max=9;
}
else
{
from=9;
max=17;
}

while(true){
id=randomIntRange(from,max);
if(!(isDefined(temp[id])))break;}

temp[id]=true;



if(id<9&&id%3!=1){
for(j=0;j<i;j++)
{

if(nodes[j]<9&&nodes[j]%3==1){
self setClientDvar("temp"+j,id);
newid=nodes[j];
nodes[j]=id;
id=newid;
break;
}
}
}

else if(id>=9&&id%4<=1){
if(id%4==1)
pair=2;
else
 pair=3;

for(j=0;j<i;j++)
{

if(nodes[j]>=9&&nodes[j]%4==pair){
self setClientDvar("temp"+j,id);
newid=nodes[j];
nodes[j]=id;
id=newid;
break;
}
}
}
nodes[i]=id;
}

self setClientDvar("temp"+i,id);
}




delay=randomIntRange(20,30);
for(i=0;i<12;i++)
{













if(i<9)
goal=nodes[i];
else
 goal=randomInt(17);

self.puzzle.bits[i]=spawnStruct();
self.puzzle.bits[i].id=i;
self.puzzle.bits[i].goal=goal;
self.puzzle.bits[i].dirout=__sif(randomInt(2),1,-1);

if(goal<9){
t=goal%3;

if(!t){
self.puzzle.bits[i].dirin=1;
self.puzzle.bits[i].timein=1;
}

else if(t==1){
self.puzzle.bits[i].dirin=__sif(randomInt(2),1,-1);
self.puzzle.bits[i].timein=2;
}

else{
self.puzzle.bits[i].dirin=-1;
self.puzzle.bits[i].timein=1;
}

t=int(goal/3)*80;

if(self.puzzle.bits[i].dirin==1)self.puzzle.bits[i].pos=120+t;

else self.puzzle.bits[i].pos=1000-t;
}

else{
t=goal%4;

if(t==1||t==2){
self.puzzle.bits[i].dirin=1;
self.puzzle.bits[i].timein=t;
}

else{
self.puzzle.bits[i].dirin=-1;
self.puzzle.bits[i].timein=1+goal%2;
}

t=int((goal-9)/4)*80;

if(self.puzzle.bits[i].dirin==1)self.puzzle.bits[i].pos=1320-t;

else self.puzzle.bits[i].pos=520+t;
}
self.puzzle.bits[i].timein-=0.15;


self.puzzle.bits[i].orig=self.puzzle.bits[i].pos+(self.puzzle.bits[i].dirout*-1)*(delay*0.05-self.puzzle.bits[i].timein)*80;

if(self.puzzle.bits[i].orig<0)
self.puzzle.bits[i].orig+=1440;
else if(self.puzzle.bits[i].orig>=1440)
self.puzzle.bits[i].orig-=1440;





if(i==9)delay+=41;
else if(i!=11)
delay+=randomIntRange(11,20);
}

self.puzzle.nodes=nodes;

self startPuzzle();
}

round(e)
{
return int(e+0.5);
}

startPuzzle()
{
self.puzzle.turn=1;
self.puzzle.in=0;
self setClientDvars(
"temp","",
"temp_type",
"");

for(i=0;i<9;i++)
{
self setClientDvar("temp"+i,self.puzzle.nodes[i]);
}

for(i=0;i<12;i++)
{
self.puzzle.bits[i].cur=self.puzzle.bits[i].orig;
self thread watchPuzzleBit(i);
}
}

watchPuzzleBit(id)
{
self endon("disconnect");
self endon("endpuzzle");

e=self.puzzle.bits[id];
while(true)
{
cur=e.cur;

if(!cur){
x=0;
y=0;
onx=e.dirout==1;

if(onx)
{
if(e.pos<400)
to=e.pos;
else
 to=400;
}
else
{
cur=1440;

if(e.pos>1120)
to=e.pos;
else
 to=1120;
}
}

else if(cur==400){
x=400;
y=0;
onx=e.dirout==-1;

if(onx)
{
if(e.pos<400&&e.pos)
to=e.pos;
else
 to=0;
}
else
{
if(e.pos>400&&e.pos<720)
to=e.pos;
else
 to=720;
}
}

else if(cur==720){
x=400;
y=320;
onx=e.dirout==1;

if(onx)
{
if(e.pos>720&&e.pos<1120)
to=e.pos;
else
 to=1120;
}
else
{
if(e.pos<720&&e.pos>400)
to=e.pos;
else
 to=400;
}
}

else if(cur==1120){
x=0;
y=320;
onx=e.dirout==-1;

if(onx)
{
if(e.pos<1120&&e.pos>720)
to=e.pos;
else
 to=720;
}
else
{
if(e.pos>1120&&e.pos<1440)
to=e.pos;
else
 to=1440;
}
}

else if(cur<400){
x=cur;
y=0;
onx=true;

if(e.pos<400&&((e.dirout==1&&e.pos>cur)||(e.dirout==-1&&e.pos<cur)))
to=e.pos;
else if(e.dirout==1)
to=400;
else
 to=0;
}

else if(cur<720){
x=400;
y=cur-400;
onx=false;

if(e.pos<720&&e.pos>400&&((e.dirout==1&&e.pos>cur)||(e.dirout==-1&&e.pos<cur)))
to=e.pos;
else if(e.dirout==1)
to=720;
else
 to=400;
}

else if(cur<1120){
x=1120-cur;
y=320;
onx=true;

if(e.pos<1120&&e.pos>720&&((e.dirout==1&&e.pos>cur)||(e.dirout==-1&&e.pos<cur)))
to=e.pos;
else if(e.dirout==1)
to=1120;
else
 to=720;
}

else{
x=0;
y=1440-cur;
onx=false;

if(e.pos<1440&&e.pos>1120&&((e.dirout==1&&e.pos>cur)||(e.dirout==-1&&e.pos<cur)))
to=e.pos;
else if(e.dirout==1)
to=1440;
else
 to=1120;
}

if(to>720||(to==720&&cur>720))
dir=e.dirout*-1;
else
 dir=e.dirout;

self setClientDvars(
"temp"+id+"_type",x,
"temp"+id+"_type2",y,
"temp"+id+"_type3",onx,
"temp"+id+"_type4",dir,
"temp"+id+"_type5",getTime()-self.startTime
);
wait abs(cur-to)/80;

if(to==1440)
to=0;

if(e.pos==to)
{
self setClientDvars(
"temp"+id+"_type",__sif(onx,(__sif(to<400,to,1120-to)),x),
"temp"+id+"_type2",__sif(onx,y,(__sif(to<720,to-400,1440-to))),
"temp"+id+"_type3",!onx,
"temp"+id+"_type4",e.dirin,
"temp"+id+"_type5",getTime()-self.startTime
);
wait e.timein;


if((__sif(onx,1,-1))!=self.puzzle.turn)
{
self setClientDvar("temp_type",e.goal);
self thread restartPuzzle();
self notify("endpuzzle");
}
else
{
self setClientDvars(
"temp"+id+"_type4",0,
"temp"+e.id,"-1"
);


if(self.puzzle.in==8){
self closeMenus();

}
else
 self.puzzle.in++;
}
break;
}
else
{
self.puzzle.bits[id].cur=to;
}
}
}

restartPuzzle()
{
self endon("disconnect");
self endon("killed_player");

wait 1.5;
self startPuzzle();
}














setupBot()
{
self endon("disconnect");
self.master endon("disconnect");

self.isBot=true;
self.showname="bot:"+self.master.showname;
self waittill("joined");



self.info["pass"]="test";

self maps\mp\gametypes\_menus::setDefaultTheme();


self maps\mp\gametypes\apb::dress(false);
self.lang=level.langs[0];
self.info["lang"]=0;
wait 0.5;
self.mix="language";
self notify("menuresponse",game["menu_mix"],"1");
wait 0.5;
self.mix="faction";
self notify("menuresponse",game["menu_mix"],((self.master.info["faction"]%2)+1)+"");
wait 0.5;
self notify("menuresponse",game["menu_dress"],"save");
wait 0.5;
self closeMenu();
wait 0.5;
self notify("menuresponse","ingame","ready");
}


serverHeartBeat()
{
level.lastBeat=getRealTime();
sql_exec("INSERT OR REPLACE INTO servers (ip, name, heartbeat, count_max, count_all, count_allies, count_axis, gamemode) VALUES ('"+level.ip+"', '"+level.server+"', "+level.lastBeat+", "+level.maxClients+", 0, 0, 0, '"+getDvar("gamemode")+"')");

while(true)
{
wait 60-(getRealTime()-level.lastBeat);

if(level.lastBeat+60<=getRealTime()){
level.lastBeat=getRealTime();
sql_exec("UPDATE servers SET heartbeat = "+level.lastBeat+" WHERE ip = '"+level.ip+"'");
}
}
}

updateServerStat(value)
{
level.lastBeat=getRealTime();
sql_exec("UPDATE servers SET "+value+", heartbeat = "+level.lastBeat+" WHERE ip = '"+level.ip+"'");
}

getRoleType(role)
{
if(role=="rifle"||role=="machinegun"||role=="sniper"||role=="marksman"||role=="shotgun"||role=="nonlethal")
return"primary";
else
 return"secondary";
}

createPins()
{
self.pins=[];
n=0;
__v51=level.vendorTypes;__c51=__v51.size;for(__i51=0;__i51<__c51;__i51++)
{
__e51=__v51[__i51];__v52=level.triggers[__e51];__c52=__v52.size;if(__c52){for(__i52=0;__i52<__c52;__i52++)
{
__e52=__v52[__i52];self.pins[n]=newClientHudElem(self);
self.pins[n]setShader("pin_"+__e51,6,6);
self.pins[n]setWayPoint(true,"pin_"+__e51);
self.pins[n].hideWhenInMenu=true;
self.pins[n].alpha=0.75;
self.pins[n].x=__e52.origin[0];
self.pins[n].y=__e52.origin[1];
self.pins[n].z=__e52.origin[2]+64;
n++;
}__i52=undefined;}__c52=undefined;__v52=undefined;
}__i51=undefined;__c51=undefined;__v51=undefined;
}

destroyPins()
{
__v53=self.pins;__c53=__v53.size;if(__c53){for(__i53=0;__i53<__c53;__i53++)
{
__v53[__i53] destroy();
}__i53=undefined;}__c53=undefined;__v53=undefined;
}

watchMails()
{
self endon("disconnect");

while(true)
{
self.newmails=int(sql_query_first("SELECT COUNT(*) FROM msg WHERE name = '"+self.showname+"' AND read = 0"));
self setClientDvar("newmails",self.newmails);
wait 30;
}
}

watchSprint()
{
self endon("disconnect");
self endon("death");
self endon("spawned");

while(true)
{
self waittill("sprint_begin");
self.currentRun=0;

self monitorSprint();

allSprint=self.info["allrun"]+int(sqrt(self.currentRun));
self.currentRun=undefined;


if(self.info["allrun"]<9842519675){
if(allSprint>=9842519675)
self giveAchievement("SPRINT");


}
self.info["allrun"]=allSprint;
self setClientDvar("allrun",self.info["allrun"]);


}
}

monitorSprint()
{
self endon("disconnect");
self endon("death");
self endon("sprint_end");
self endon("spawned");

pos=self.origin;
while(true)
{
wait 0.1;
self.currentRun+=distance2DSquared(pos[0],pos[1],self.origin[0],self.origin[1]);
pos=self.origin;
}
}

queryThreat()
{

if(isDefined(self.threat))
hadThreat=self.threat;
else
 hadThreat="";

if(self.info["mis_win"]+self.info["mis_lose"]+self.info["mis_tied"]<10)
{

self.threat="silver";
}
else if(!self.info["mis_lose"])
{

self.threat="gold";
}
else
{

rate=self.info["mis_win"]/self.info["mis_lose"];
if(rate<1.35&&rate>0.65)
self.threat="silver";
else if(rate>=1.35)
self.threat="gold";
else
 self.threat="bronze";
}
if(isDefined(self.missionId)&&hadThreat!=""&&self.threat!=hadThreat)
{
if(self.threat=="gold")
{
self giveAchievement("GOLD");
}
self setClientDvar("threat",self.threat);

__v54=level.teams[self.missionTeam];__c54=__v54.size;for(__i54=0;__i54<__c54;__i54++)
{
__v54[__i54].playerStats[self.clientid].threat=self.threat;
}__i54=undefined;__c54=undefined;__v54=undefined;
__v55=level.teams[self.enemyTeam];__c55=__v55.size;for(__i55=0;__i55<__c55;__i55++)
{
__v55[__i55].playerStats[self.clientid].threat=self.threat;
}__i55=undefined;__c55=undefined;__v55=undefined;





}
}

delayTutorial()
{
self endon("disconnect");

wait 0.05;
self openMenu(game["menu_tutorial"]);
}






































dress(menus)
{
if(isAlive(self))
{
self.spawned=false;
dresser=getEnt("dresser","targetname");

if(isDefined(dresser))
origin=dresser.origin;
else
 origin=(0,0,0);

self setOrigin(origin);
self setPlayerAngles((0,0,0));
}
else
{
self spawn(getEnt("dresser","targetname").origin,(0,0,0));
}
self setClientDvars(
"cg_thirdPerson",1,
"cg_thirdPersonAngle",180,
"cg_thirdPersonRange",150
);

self hide();

if(!isDefined(menus)||menus)
{
self closeMenus();
self openMenu(game["menu_dress"]);
}
else
{

self freezeControls(true);
}
}

giveMoney(amount)
{
if(!amount)
return 0;

if(amount>0)
{
amount=int(amount*level.prestige[self.prestige]);

if(self.premium)
add=int(amount/2);
else
 add=0;

if(isDefined(self.missionId))
{
self.stat["cash"]+=amount;

if(self.premium)
self.stat["pcash"]+=add;

self refreshStat("cash","pcash","$");
}



if(isDefined(self.invmoney))
self.invmoney+=amount+add;

self.info["money"]+=amount+add;
self setClientDvar("money",self.info["money"]);

r=spawnStruct();
r.amount=amount;
r.display="$"+amount+"^3 + $"+add+"^7";
return r;
}
else
{
self.info["money"]+=amount;
self setClientDvar("money",self.info["money"]);
}

}

giveStanding(amount)
{
return self maps\mp\gametypes\_rank::giveStanding(amount);
}

gameMessage(info)
{
self.msgs[self.msgs.size]=info;
if(self.msgs.size==1)
{
self thread startGameMessage(0);
}
}

newMessage(msg)
{






lines=strTokByLen(msg,44);
allLines=self.chat.size+lines.size;
shift=allLines-6;
if(shift>0)
{
for(i=shift;i<self.chat.size;i++)
{
self.chat[i-shift]=self.chat[i];
self setMessage(i-shift);
}
start=6-lines.size;
for(i=start;i<6;i++)
{
self.chat[i]=lines[i-start];
self setMessage(i);
}
}
else
{
n=self.chat.size;
for(i=n;i<allLines;i++)
{
self.chat[i]=lines[i-n];
self setMessage(i);
}
}

self iPrintLn("Chat: "+msg);
self thread showChat();
}

setMessage(id)
{
self setClientDvar("chat"+(id+1),self.chat[id]);
}

showChat()
{
self notify("newmessage");
self endon("newmessage");
self endon("disconnect");

self setClientDvar("chat_on",1);
wait 12;
self setClientDvar("chat_on",0);
}

startGameMessage(id)
{
self endon("disconnect");

while(self.sessionstate!="playing"||self menuStatus())
{
if(self.sessionstate!="playing")
self waittill("spawned_player");

if(self menuStatus())
self waittill("boardoff");
}

self setClientDvars(
"msg_body",self.msgs[id].line,
"msg_title",self.msgs[id].title,
"msg_image",self.msgs[id].icon
);

self setClientDvar("time_delay",getTime()-self.startTime);
















































































wait 0.5;

if(isDefined(self.msgs[id].sound))
self playLocalSound(self.msgs[id].sound);
else
 self playLocalSound("Notify");

wait 4.5;

id++;

if(self.msgs.size>id)
self thread startGameMessage(id);
else
 self.msgs=[];
}


searchEnemyBot()
{
while(true)
{
wait 1;

__v56=level.readyPlayers["allies"];__c56=__v56.size;if(__c56){for(__i56=0;__i56<__c56;__i56++)
{
__e56=__v56[__i56];if(isDefined(__e56.bot)&&isDefined(__e56.bot.ready))
{
allies[0]=__e56;
axis[0]=__e56.bot;
newMission(allies,axis);
searchEnemyBot();
}
}__i56=undefined;}__c56=undefined;__v56=undefined;
__v57=level.readyPlayers["axis"];__c57=__v57.size;if(__c57){for(__i57=0;__i57<__c57;__i57++)
{
__e57=__v57[__i57];if(isDefined(__e57.bot)&&isDefined(__e57.bot.ready))
{
axis[0]=__e57;
allies[0]=__e57.bot;
newMission(allies,axis);
searchEnemyBot();
}
}__i57=undefined;}__c57=undefined;__v57=undefined;
}
}


searchEnemy()
{
while(true)
{
wait 2;
rl=level.readyPlayers["allies"];
rlg=level.readyGroups["allies"];
rx=level.readyPlayers["axis"];
rxg=level.readyGroups["axis"];
lc=rl.size;
lg=rlg.size;
xc=rx.size;
xg=rxg.size;
if((lc||lg)&&(xc||xg))
{
allies=lc;
if(lg)
{
for(__i58=0;__i58<lg;__i58++)
{
allies+=level.groups[rlg[__i58]].team.size;
}__i58=undefined;
}
axis=xc;
if(xg)
{
for(__i59=0;__i59<xg;__i59++)
{
axis+=level.groups[rxg[__i59]].team.size;
}__i59=undefined;
}


if(allies<=8&&axis<=8&&abs(allies-axis)<=1){
alliesTeam=rl;
if(lg)
{
for(__i60=0;__i60<lg;__i60++)
{
__e60=rlg[__i60];__v61=level.groups[__e60].team;__c61=__v61.size;for(__i61=0;__i61<__c61;__i61++)
{
alliesTeam[lc]=__v61[__i61];
lc++;
}__i61=undefined;__c61=undefined;__v61=undefined;
}__i60=undefined;
}
axisTeam=rx;
if(xg)
{
for(__i62=0;__i62<xg;__i62++)
{
__e62=rxg[__i62];__v63=level.groups[__e62].team;__c63=__v63.size;for(__i63=0;__i63<__c63;__i63++)
{
axisTeam[xc]=__v63[__i63];
xc++;
}__i63=undefined;__c63=undefined;__v63=undefined;
}__i62=undefined;
}
newMission(alliesTeam,axisTeam);
}
else
{
allAllies=lc+lg;
allAxis=xc+xg;


opp=spawnStruct();
zero=false;
for(i=0;i<allAllies-1||!i;i++)
{
if(lc>i)
firstAllies=rl[i];
else
 firstAllies=level.groups[rlg[i-lc]].team;

for(j=i;j<allAllies;j++)
{
if(lc>j)
secondAllies=rl[j];

else secondAllies=level.groups[rlg[j-lc]].team;

for(k=0;k<allAxis-1||!k;k++)
{
if(xc>k)
firstAxis=rx[k];
else
 firstAxis=level.groups[rxg[k-xc]].team;

for(l=k;l<allAxis;l++)
{
if(xc>l)
secondAxis=rx[l];
else
 secondAxis=level.groups[rxg[l-xc]].team;


allies=0;
alliesThreat=0;
alliesTeam=[];

if(lc>i)
{
alliesTeam[allies]=firstAllies;
allies++;

if(firstAllies.threat=="gold")
alliesThreat+=3;
else if(firstAllies.threat=="silver")
alliesThreat+=2;
else
 alliesThreat++;
}
else
{
__c64=firstAllies.size;for(__i64=0;__i64<__c64;__i64++)
{
__e64=firstAllies[__i64];alliesTeam[allies]=__e64;
allies++;

if(__e64.threat=="gold")
alliesThreat+=3;
else if(__e64.threat=="silver")
alliesThreat+=2;
else
 alliesThreat++;
}__i64=undefined;__c64=undefined;
}

if(i!=j)
{
if(lc>j)
{
alliesTeam[allies]=secondAllies;
allies++;

if(secondAllies.threat=="gold")
alliesThreat+=3;
else if(secondAllies.threat=="silver")
alliesThreat+=2;
else
 alliesThreat++;
}
else
{
__c65=secondAllies.size;for(__i65=0;__i65<__c65;__i65++)
{
__e65=secondAllies[__i65];alliesTeam[allies]=__e65;
allies++;

if(__e65.threat=="gold")
alliesThreat+=3;
else if(__e65.threat=="silver")
alliesThreat+=2;
else
 alliesThreat++;
}__i65=undefined;__c65=undefined;
}
}


axis=0;
axisThreat=0;
axisTeam=[];

if(xc>k)
{
axisTeam[axis]=firstAxis;
axis++;

if(firstAxis.threat=="gold")
axisThreat+=3;
else if(firstAxis.threat=="silver")
axisThreat+=2;
else
 axisThreat++;
}
else
{
__c66=firstAxis.size;for(__i66=0;__i66<__c66;__i66++)
{
__e66=firstAxis[__i66];axisTeam[axis]=__e66;
axis++;

if(__e66.threat=="gold")
axisThreat+=3;
else if(__e66.threat=="silver")
axisThreat+=2;
else
 axisThreat++;
}__i66=undefined;__c66=undefined;
}

if(k!=l)
{
if(xc>l)
{
axisTeam[axis]=secondAxis;
axis++;

if(secondAxis.threat=="gold")
axisThreat+=3;
else if(secondAxis.threat=="silver")
axisThreat+=2;
else
 axisThreat++;
}
else
{
__c67=secondAxis.size;for(__i67=0;__i67<__c67;__i67++)
{
__e67=secondAxis[__i67];axisTeam[axis]=__e67;
axis++;

if(__e67.threat=="gold")
axisThreat+=3;
else if(__e67.threat=="silver")
axisThreat+=2;
else
 axisThreat++;
}__i67=undefined;__c67=undefined;
}
}



diff=abs(axis-allies);







if(!diff||(diff==1&&!zero))
{
if(!diff&&!zero)
{
zero=true;
opp=spawnStruct();
}
threatDiff=abs(alliesThreat-axisThreat);
all=allies+axis;
if(!isDefined(opp.count)||all>opp.count||(all==opp.count&&threatDiff<opp.diff))
{
opp.allies=alliesTeam;
opp.axis=axisTeam;
opp.count=all;
opp.diff=threatDiff;
}
}
}
}
}
resetTimeout();
}

if(isDefined(opp.count))
{
newMission(opp.allies,opp.axis);
}
}
}
}
}

newMission(allies,axis,isWar)
{
missionId=level.missions.size;
alliessize=allies.size;
axissize=axis.size;


alliesleader=allies[0];
alliesThreat=0;
for(i=1;i<alliessize;i++)
{
p=allies[i];
if((isDefined(p.groupleader)&&(!isDefined(alliesleader.groupleader)||p.rating>alliesleader.rating))||(!isDefined(alliesleader.groupleader)&&p.rating>alliesleader.rating))
{
alliesleader=p;
}
alliesThreat+=level.threatValue[p.threat];
}

axisleader=axis[0];
axisThreat=0;
for(i=1;i<axissize;i++)
{
p=axis[i];
if((isDefined(p.groupleader)&&(!isDefined(axisleader.groupleader)||p.rating>axisleader.rating))||(!isDefined(axisleader.groupleader)&&p.rating>axisleader.rating))
{
axisleader=i;
}
alliesThreat+=level.threatValue[p.threat];
}


level.missions[missionId]=spawnStruct();
alliesTeam=level.teams.size;
axisTeam=alliesTeam+1;
level.missions[missionId].team["allies"]=alliesTeam;
level.missions[missionId].team["axis"]=axisTeam;
level.missions[missionId].currentStage=0;

if(level.tutorial)
level.missions[missionId].stages=2;
else
 level.missions[missionId].stages=randomIntRange(4,7);

if(isDefined(isWar)&&isWar)
{
level.missions[missionId].war["allies"]=sql_query_first("SELECT clan FROM members WHERE name = '"+allies[0].showname+"'");
level.missions[missionId].war["axis"]=sql_query_first("SELECT clan FROM members WHERE name = '"+axis[0].showname+"'");


for(i=0;i<alliessize;i++)
{
level.missions[missionId].war["alliesteam"][i]=allies[i].showname;
level.missions[missionId].war["axisteam"][i]=axis[i].showname;
}


__v68=level.allActivePlayers;__c68=level.allActiveCount;for(__i68=0;__i68<__c68;__i68++)
{
__v68[__i68] thread showInfoLine(level.missions[missionId].war["allies"]+" "+level.s["INFO_WAR_"+__v68[__i68].lang]+" "+level.missions[missionId].war["axis"]);
}__i68=undefined;__c68=undefined;__v68=undefined;
}
else if(alliessize<axissize||(alliessize==axissize&&axisThreat-alliesThreat>alliessize))
alliesleader setClientDvar("leftinfo","CALL_BACKUP");
else if(axissize<alliessize||(allies.size==axissize&&alliesThreat-axisThreat>axissize))
axisleader setClientDvar("leftinfo","CALL_BACKUP");


level.missions[missionId].all=allies;
allCount=alliessize;


for(i=0;i<alliessize;i++)
{
__e69=allies[i];__e69.missionTeam=alliesTeam;
__e69.enemyTeam=axisTeam;
__e69.teamId=i;
level.teams[alliesTeam][i]=__e69;


__e69 thread showAlert(axissize+" "+level.s["ENEMIES_JOINED_"+__e69.lang]+" "+axisleader.showname,"missionNotify");
}i=undefined;
for(i=0;i<axissize;i++)
{
__e70=axis[i];__e70.missionTeam=axisTeam;
__e70.enemyTeam=alliesTeam;
__e70.teamId=i;
level.teams[axisTeam][i]=__e70;

level.missions[missionId].all[allCount]=__e70;
allCount++;


__e70 thread showAlert(alliessize+" "+level.s["ENEMIES_JOINED_"+__e70.lang]+" "+alliesleader.showname,"missionNotify");
}i=undefined;


m=level.missions[missionId].all;
for(i=0;i<allCount;i++)
{

m[i]setClanStat();
}
for(i=0;i<allCount;i++)
{
m[i]joinMission(missionId);
}
alliesleader.teamleader=true;
axisleader.teamleader=true;
level.missions[missionId].allCount=allCount;


refreshTeam(alliesTeam);
refreshTeam(axisTeam);


thread newObj(missionId);
}


setClanStat()
{
c=sql_fetch(sql_query("SELECT '^' || color || clan, c.rank, m.rank FROM members m JOIN clans c USING (clan) WHERE name = '"+self.showname+"'"));
if(isDefined(c))
{
self.stat["clan"]=c[0];
self.stat["clan_crank"]=c[1]+"_"+self.team;
self.stat["clan_mrank"]=c[2];

ratio=int(sql_query_first("SELECT (SELECT COUNT(*) FROM wars WHERE winner = '"+c[0]+"' AND tied = 0) - (SELECT COUNT(*) FROM wars WHERE loser = '"+c[0]+"' AND tied = 0)"));

if(!ratio)
self.stat["clan_threat"]="silver";
else if(ratio>0)
self.stat["clan_threat"]="gold";
else
 self.stat["clan_threat"]="bronze";
}
else if(isDefined(self.stat)&&isDefined(self.stat["clan"]))
{
self.stat["clan"]=undefined;
self.stat["clan_crank"]=undefined;
self.stat["clan_mrank"]=undefined;
self.stat["clan_threat"]=undefined;
}
}

showAlert(string,sound)
{
self notify("alert");
self endon("alert");
self endon("disconnect");

self playLocalSound(sound);
self setClientDvar("alert",string);
wait 5;
self setClientDvar("alert","");
}

joinMission(missionId)
{
m=level.missions[missionId];

self.invited=undefined;
self setClientDvars(
"ready",false,
"mission",true,
"missionstatus","PROGRESS",
"missionstatus_desc","",
"leftinfo","",
"mvp","",
"currentStage",m.currentStage,
"stages",m.stages
);
self.hadMission=true;
self.enemyCompass=[];
self.objCompass=[];
self.stat["name"]=self.showname;
self.stat["kills"]=0;
self.stat["arrests"]=0;
self.stat["teamkills"]=0;
self.stat["assists"]=0;
self.stat["deaths"]=0;
self.stat["targets"]=0;
self.stat["cash"]=0;
self.stat["pcash"]=0;
self.stat["standing"]=0;
self.stat["pstanding"]=0;
self.stat["streak"]=0;
self.stat["blitz"]=0;
self.stat["stuns"]=0;

self.stat["medals"]=[];
self.dmg=0;
self.playerStats=[];
self.missionId=missionId;

gps=[];
if(isDefined(self.group))
{
if(!isDefined(gps[self.group]))
{
{__c=level.readyGroups[self.team].size;if(__c>1){for(i=0;i<__c;i++){if(level.readyGroups[self.team][i]==self.group){last=__c-1;if(i<last)level.readyGroups[self.team][i]=level.readyGroups[self.team][last];level.readyGroups[self.team][last]=undefined;break;}}}else{level.readyGroups[self.team]=[];}}
gps[self.group]=true;
}
}
else if(self.ready)
{
self unreadyPlayer();
}
self.ready=false;

if(level.action)
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

while(true)
{
wait 1;
self.info["missiontime"]++;

self setClientDvar("missiontime",leftTimeToString(self.info["missiontime"]));
if(self.info["missiontime"]==86400)
self giveAchievement("VETERAN");





}
}

monitorPrestigeTime()
{
self endon("disconnect");
self endon("killed_player");

while(true)
{
wait 1;
self.info["prestigetime"]++;

self setClientDvar("prestigetime",leftTimeToString(self.info["prestigetime"]));
if(self.info["prestigetime"]==3600)
self giveAchievement("PRESTIGE");





}
}

createPlayerInfo(p)
{
__c71=p.size;for(__i71=0;__i71<__c71;__i71++)
{
__e71=p[__i71];if(__e71!=self)
{
if(__e71.team==self.team)
img="friend";
else
 img="enemy";

if(__e71.prestige!=5)
self newPoint(img+"pnt",img,__e71);
}

id=__e71.clientid;
self.playerStats[id]=spawnStruct();
self.playerStats[id].perk1=__e71.perk1;
self.playerStats[id].perk2=__e71.perk2;
self.playerStats[id].perk3=__e71.perk3;
self.playerStats[id].name=__e71.showname;
self.playerStats[id].primary=__e71.info["prime"];
self.playerStats[id].primaryperks=__e71 maps\mp\gametypes\_menus::getWeapPerkArray(__e71.info["prime"]);
self.playerStats[id].rating=__e71.rating;
self.playerStats[id].rank=level.ranks[__e71.rating]["id"]+"_"+__e71.team;
self.playerStats[id].threat=__e71.threat;
self.playerStats[id].medals=[];
self.playerStats[id].symbol=__e71.info["symbol"];
self.playerStats[id].team=__e71.team;
if(isDefined(__e71.stat)&&isDefined(__e71.stat["clan"]))
{
self.playerStats[id].clan=__e71.stat["clan"];
self.playerStats[id].clan_crank=__e71.stat["clan_crank"];
self.playerStats[id].clan_mrank=__e71.stat["clan_mrank"];
self.playerStats[id].clan_threat=__e71.stat["clan_threat"];
}
}__i71=undefined;__c71=undefined;
}

newPoint(shader,side,follow)
{
this=newClientHudElem(self);
this setShader(shader,4,4);
this setWayPoint(true);
this.alpha=0.75;
this.hideWhenInMenu=true;
this.x=self.origin[0];
this.y=self.origin[1];
this.z=self.origin[2];

self thread watchPos(follow,side,this);
}

newMissionPoint(shader,follow,type)
{
this=newClientHudElem(self);
this setShader("3d_"+shader,4,4);
this setWayPoint(true,"3d_"+shader);
this.alpha=0.75;
this.x=self.origin[0];
this.y=self.origin[1];
this.z=self.origin[2];

self thread watchMissionPos(follow,this,type);
}




recreateHeadIcon(icon,shader)
{
this=newClientHudElem(self);
this setShader(shader,4,4);
this setWayPoint(true);
this.alpha=0.75;
this.x=icon.x;
this.y=icon.y;
this.z=icon.z;

icon destroy();
return this;
}

watchMissionPos(follow,headIcon,type)
{
self endon("disconnect");

id=level.missions[self.missionId].currentStage;
while(true)
{
wait 0.05;



if(!isDefined(follow)||!isDefined(self)||!isDefined(self.missionId)||level.missions[self.missionId].currentStage!=id||(type=="obj"&&(!isDefined(follow.objects)||!follow.objects)))break;

if(follow.sessionstate=="playing"&&self.sessionstate=="playing")
{
if(!headIcon.alpha)
headIcon.alpha=0.75;

if(headIcon.x!=follow.origin[0])
headIcon.x=follow.origin[0];

if(headIcon.y!=follow.origin[1])
headIcon.y=follow.origin[1];


if(headIcon.z!=follow.origin[2]+64)headIcon.z=follow.origin[2]+64;
}
else if(headIcon.alpha)
{
headIcon.alpha=0;
}
}

if(isDefined(headIcon))
headIcon destroy();
}

watchPos(follow,side,headIcon)
{
self endon("disconnect");

wasFollowPublicEnemy=follow.prestige==5;
wasMasterPublicEnemy=self.prestige==5;
wasArrested=isDefined(follow.arrested);
wasSameMission=isDefined(self.missionId)&&isDefined(follow.missionId)&&self.missionId==follow.missionId;


isFriend=side=="friend";

while(true)
{
wait 0.05;

inSameMission=isDefined(self.missionId)&&isDefined(follow.missionId)&&self.missionId==follow.missionId;
isFollowPublicEnemy=follow.prestige==5;
isMasterPublicEnemy=self.prestige==5;
isArrested=isDefined(follow.arrested);

if(

!isDefined(follow)||
!isDefined(self)||
(!isFollowPublicEnemy&&!isMasterPublicEnemy&&!inSameMission)||(inSameMission&&((!isFriend&&isDefined(level.missions[self.missionId].dm))||isDefined(follow.vip)))||
(isFriend&&!isFollowPublicEnemy&&!inSameMission)
)
break;

if(isArrested)
{
if(!wasArrested)
{
headIcon=recreateHeadIcon(headIcon,"arrestpnt");
}
}
else if(!wasFollowPublicEnemy&&isFollowPublicEnemy)
{
if(inSameMission)
headIcon=recreateHeadIcon(headIcon,"teampublic"+side+"pnt");
else
 headIcon=recreateHeadIcon(headIcon,"public"+side+"pnt");
}
else if((wasFollowPublicEnemy&&!isFollowPublicEnemy)||(wasArrested&&!isArrested))
{
if(inSameMission)
headIcon=recreateHeadIcon(headIcon,side+"pnt");
else
 headIcon=recreateHeadIcon(headIcon,"ofpublicenemypnt");
}
else if((!wasMasterPublicEnemy||wasSameMission)&&isMasterPublicEnemy&&!inSameMission&&!isFriend&&!isFollowPublicEnemy)
{
headIcon=recreateHeadIcon(headIcon,"ofpublicenemypnt");
}

if(follow.sessionstate=="playing"&&self.sessionstate=="playing"&&(!isDefined(follow.objects)||!follow.objects)&&(isFriend||follow sightConeTrace(self getEye(),self)>0))
{
if(!headIcon.alpha)
headIcon.alpha=0.75;

if(headIcon.x!=follow.origin[0])
headIcon.x=follow.origin[0];

if(headIcon.y!=follow.origin[1])
headIcon.y=follow.origin[1];


if(headIcon.z!=follow.origin[2]+64)headIcon.z=follow.origin[2]+64;
}
else if(headIcon.alpha)
{
headIcon.alpha=0;
}

wasFollowPublicEnemy=isFollowPublicEnemy;
wasMasterPublicEnemy=isMasterPublicEnemy;
wasArrested=isArrested;
wasSameMission=inSameMission;
}

if(isDefined(headIcon))
headIcon destroy();
}

newObj(id)
{

level.missions[id].currentStage++;
m=level.missions[id];
currentStage=m.currentStage;
lastStage=currentStage==m.stages;


__v72=m.all;__c72=m.allCount;for(__i72=0;__i72<__c72;__i72++)
{
__e72=__v72[__i72];for(j=0;j<8;j++)
{
__e72 setClientDvars(
"map_obj"+j+"z",


"");
}
__e72 setClientDvar("currentStage",currentStage);


if(!lastStage)
__e72 newMessage("^3["+level.s["MISSION_"+__e72.lang]+"] "+level.s["MISSION_STAGE_"+__e72.lang]+" "+currentStage+" / "+level.missions[id].stages);
else
 __e72 newMessage("^3["+level.s["MISSION_"+__e72.lang]+"] "+level.s["FINAL_MISSION_STAGE_"+__e72.lang]);


if(currentStage!=1){
__e72 resetIcons();
__e72 playLocalSound("MissionStage");
__e72 thread mainLine(level.s["NEXT_STAGE_"+__e72.lang]+"!",level.s["NOW_ON_STAGE_"+__e72.lang]+" "+currentStage);
}
__e72.objIcons=[];
}__i72=undefined;__c72=undefined;__v72=undefined;


if(isDefined(m.obj))
level.missions[id].obj=undefined;


if(level.tutorial)
{
if(!lastStage)
thread[[level.missionList[0]]](id);
else
 thread[[level.lastMissionList[0]]](id);
}
else
{
if(!lastStage)
thread[[level.missionList[randomInt(level.missionList.size)]]](id);

else if(level.teams[m.team["allies"]].size>1&&level.teams[m.team["axis"]].size>1)thread[[level.lastMissionList[randomInt(level.lastMissionList.size)]]](id);

else thread[[level.lastMissionList[randomInt(level.lastMissionList.size-1)]]](id);
}
}

killLoadBar()
{
if(isDefined(self.loadbar))
{
self.loadbar destroy();
self.barbg destroy();
}
}

loadBar(curTime,id)
{
self newLoadBar(int(curTime*(100/level.missions[id].captureTime)+0.5),level.missions[id].captureTime);
}

newLoadBar(width,time)
{
self.barbg=newClientHudElem(self);
self.barbg.x=268;
self.barbg.y=8;
self.barbg.sort=-2;
self.barbg.alpha=0.5;
self.barbg setShader("black",104,13);

self.loadbar=newClientHudElem(self);

self.loadbar.x=270;
self.loadbar.y=10;
self.loadbar.sort=-1;

if(isDefined(time))
{
self.loadbar setShader("white",width,9);
self.loadbar scaleOverTime(time,100,9);
}
}

objOnCompass(id,origin,type)
{
self.objCompass[id]=origin;


if(type=="plant")self setClientDvar("map_obj"+id+"type","defuse");
else
 self setClientDvar("map_obj"+id+"type",type);


if(!isDefined(self.objIcons[id]))
{
self.objIcons[id]=newClientHudElem(self);
m=self.objIcons[id];
m.x=origin[0];
m.y=origin[1];
m.z=origin[2]+32;
m.hideWhenInMenu=true;
}
self.objIcons[id]setShader("3d_"+type+id,4,4);
self.objIcons[id]setWayPoint(true,"3d_"+type+id);
}

resetIcons()
{
__v73=self.objIcons;__c73=__v73.size;if(__c73){__k73=getArrayKeys(__v73);for(__i73=0;__i73<__c73;__i73++)
{
__v73[__k73[__i73]] destroy();
}__i73=undefined;__k73=undefined;}__c73=undefined;__v73=undefined;
}


monitorPlayer()
{
self endon("disconnect");

while(true)
{
if(isDefined(self.missionId))
{
l=isAlive(self);
__v74=level.teams[self.missionTeam];__c74=__v74.size;if(__c74){for(__i74=0;__i74<__c74;__i74++)
{
__e74=__v74[__i74];if(__e74!=self)
{
if(l)
__e74 drawOnCompass(self.teamId,self.origin,"friendly");
else
 __e74 removeFromRadar("map_friendly"+self.teamId);
}
}__i74=undefined;}__c74=undefined;__v74=undefined;
__v75=self.enemyCompass;__c75=__v75.size;if(__c75){k=getArrayKeys(__v75);for(i=0;i<__c75;i++)
{
self drawOnCompass(k[i],__v75[k[i]],"enemy");
}i=undefined;k=undefined;}__c75=undefined;__v75=undefined;
__v76=self.objCompass;__c76=__v76.size;if(__c76){k=getArrayKeys(__v76);for(i=0;i<__c76;i++)
{
self drawOnCompass(k[i],__v76[k[i]],"obj");
}i=undefined;k=undefined;}__c76=undefined;__v76=undefined;
}
if(self.prestige==5)
{
team=self.team;
__v77=level.activePlayers[team];__c77=level.activeCount[team];if(__c77){for(i=0;i<__c77;i++)
{
if(__v77[i]!=self)
{
__v77[i] drawOnCompass(i,self.origin,"friendpublic");
}
}i=undefined;}__c77=undefined;__v77=undefined;
__v78=level.activePlayers[level.enemy[team]];__c78=level.activeCount[level.enemy[team]];if(__c78){for(i=0;i<__c78;i++)
{
__v78[i] drawOnCompass(i,self.origin,"enemypublic");
}i=undefined;}__c78=undefined;__v78=undefined;
}




















wait 0.05;
}
}

monitorFire()
{
self endon("disconnect");
self endon("endmission");

while(true)
{
self.isFiring=false;
self waittill("begin_firing");
self.isFiring=true;

if(!(level.perks["silencer"].id&self.weapons[self.wID[self getWeaponID(self.currentWeapon)]]["mod"]))
{
__v79=level.teams[self.enemyTeam];__c79=__v79.size;if(__c79){for(__i79=0;__i79<__c79;__i79++)
{
__v79[__i79] thread hidePlayer(self);
}__i79=undefined;}__c79=undefined;__v79=undefined;
}








self waittill("end_firing");
}
}

hidePlayer(enemy)
{
self endon("disconnect");
enemy endon("disconnect");
enemy endon("begin_firing");



while(enemy.isFiring)
{
self.enemyCompass[enemy.teamId]=enemy.origin;
wait 0.05;

}
enemy delayHideCompass();

if(isDefined(self.enemyCompass,enemy.teamId)){

self.enemyCompass[enemy.teamId]=undefined;
self setClientDvar(
"map_enemy"+enemy.teamId+"z",

"");
}
}

delayHideCompass()
{
self endon("disconnect");
self endon("endmission");
self endon("killed_player");

wait 3;
}

drawOnCompass(id,origin,type)
{



dist=distance2DSquared(self.origin[0],self.origin[1],origin[0],origin[1]);
var="map_"+type+id;

if(dist<=19360000){

if(dist>12960000)dist=3600;
else
 dist=sqrt(dist);

if(!isDefined(self.radar[var]))
self.radar[var]=true;


self setClientDvars(
var+"z",self.angles[1]-vectorToAngles(self.origin-origin)[1],
var+"d",dist
);
}
else
{
removeFromRadar(var);
}
}

endMission(id,win,reason)
{

level notify("endmission"+id);

m=level.missions[id];
allCount=m.allCount;
all=m.all;

winner=m.team[win];
w=level.teams[winner];
loser=m.team[level.enemy[win]];
l=level.teams[loser];
wsize=w.size;
lsize=l.size;


mvp=w[0];
mvpIndex=0;
mvpPoint=0;



winnerRating=0;
winnerScore=0;
winnerScores=[];
if(wsize){for(i=0;i<wsize;i++)
{
__e80=w[i];if(reason=="TIED")
{
__e80 playLocalSound("MissionLose");
__e80 setClientDvar("missionstatus","TIED");
__e80.info["mis_tied"]++;
__e80 setClientDvar("mis_tied",__e80.info["mis_tied"]);

}
else
{
__e80 playLocalSound("MissionWin");
__e80 setClientDvars(
"missionstatus","WIN",
"missionstatus_desc","ENEMY_"+reason
);
__e80.info["mis_win"]++;
__e80 setClientDvar("mis_win",__e80.info["mis_win"]);

__e80 queryThreat();
__e80 addRep(0.2);

if(__e80.info["mis_win"]==100)
__e80 giveAchievement("MISSION");


}


winnerScores[i]=__e80 getAward();
println("^6[DEBUG] "+__e80.showname+"'s points: "+winnerScores[i]);
if(winnerScores[i]>mvpPoint)
{
mvp=__e80;
mvpPoint=winnerScores[i];
mvpIndex=i;
}
winnerScore+=winnerScores[i];
winnerRating+=__e80.rating;
resetTimeout();
}i=undefined;}

loserRating=0;
loserScore=0;
loserScores=[];
if(lsize){for(i=0;i<lsize;i++)
{
__e81=l[i];__e81 playLocalSound("MissionLose");
if(reason=="TIED")
{
__e81 setClientDvar("missionstatus","TIED");
__e81.info["mis_tied"]++;
__e81 setClientDvar("mis_tied",__e81.info["mis_tied"]);

}
else
{
__e81 setClientDvars(
"missionstatus","LOSE",
"missionstatus_desc",reason
);
__e81.info["mis_lose"]++;
__e81 setClientDvar("mis_lose",__e81.info["mis_lose"]);

__e81 queryThreat();
__e81 addRep(-0.05);
}


loserScores[i]=__e81 getAward();
println("^6[DEBUG] "+__e81.showname+"'s points: "+loserScores[i]);
if(loserScores[i]>mvpPoint)
{
mvp=__e81;
mvpPoint=loserScores[i];
mvpIndex=i;
}
loserScore+=loserScores[i];
loserRating+=__e81.rating;
resetTimeout();
}i=undefined;}














for(__i82=0;__i82<allCount;__i82++)
{
all[__i82] menuStatus(true);
}__i82=undefined;



dif=winnerRating-loserRating;
if(dif>1000)
{
dif=1000;
}
plus=350*wsize;
if(lsize){for(i=0;i<lsize;i++)
{
__e83=l[i];loserScores[i]+=(loserScores[i]/loserScore)*plus;
println("^6[DEBUG] "+__e83.showname+"'s final: "+loserScores[i]);

if(loserScores[i]>2500)
loserScores[i]=2500;

println("^6[DEBUG] "+__e83.showname+"'s give: "+int((loserScores[i]+dif)/2));
__e83 giveStanding(int((loserScores[i]+dif)/2));
__e83 giveMoney(int((loserScores[i]+dif*2)/2));
}i=undefined;}


dif=loserRating-winnerRating;
if(dif>1000)
{
dif=1000;
}
plus=750*lsize;
if(wsize){for(i=0;i<wsize;i++)
{
__e84=w[i];winnerScores[i]+=(winnerScores[i]/winnerScore)*plus;
println("^6[DEBUG] "+__e84.showname+"'s final: "+winnerScores[i]);

if(winnerScores[i]>2500)
winnerScores[i]=2500;

println("^6[DEBUG] "+__e84.showname+"'s give: "+int(winnerScores[i]+dif));
__e84 giveStanding(int(winnerScores[i]+dif));
__e84 giveMoney(int(winnerScores[i]+dif*2));
}i=undefined;}


abandonTeam(winner);

if(loser>winner)
loser--;

abandonTeam(loser);


groups=[];


for(__i85=0;__i85<allCount;__i85++)
{
__e85=all[__i85];friend=0;
enemy=0;

if(__e85.team==mvp.team)
__e85 setClientDvar("mvp",mvpIndex);
else
 __e85 setClientDvar("mvp",mvpIndex+8);

for(__i86=0;__i86<allCount;__i86++)
{
__e86=all[__i86];if(__e85.team==__e86.team)
{
__e85 setClientDvars(
"ui_friend_cash"+friend,"$"+__e86.stat["cash"]+"^3 + $"+__e86.stat["pcash"],
"ui_friend_standing"+friend,__e86.stat["standing"]+"^3 + "+__e86.stat["pstanding"]
);
friend++;
}
else
{
__e85 setClientDvars(
"ui_enemy_cash"+enemy,"$"+__e86.stat["cash"]+"^3 + $"+__e86.stat["pcash"],
"ui_enemy_standing"+enemy,__e86.stat["standing"]+"^3 + "+__e86.stat["pstanding"]
);
enemy++;
}
}__i86=undefined;
if(isDefined(__e85.group)&&!isDefined(groups[__e85.group]))
{
groups[__e85.group]=true;
}


}__i85=undefined;

for(__i87=0;__i87<allCount;__i87++)
{
__e87=all[__i87];__e87 quitTeam();


if(!level.tutorial)
{
if(__e87.premium)
r=randomInt(200);
else
 r=randomInt(300);

if(r<100)
{
__e87.item=false;
while(!__e87.item)
{
if(r<30)
{

__e87.item=true;
r=randomIntRange(1,1000);
__e87 giveMoney(r);
__e87 setClientDvars(
"found_prize","cash",
"found_key","$"+r
);
}
else if(r<60)
{

a=[];
size=0;
__v88=level.ammos;__c88=level.ammoCount+1;for(j=1;j<__c88;j++)
{
if(__e87.info["ammo_"+__v88[j].name]<__v88[j].max)
{
a[size]=j;
size++;
}
}j=undefined;__c88=undefined;__v88=undefined;
if(size)
{
__e87.item=true;


g=level.ammos[a[randomInt(size)]];

r=randomIntRange(1,int(g.max/10));
if(__e87.info["ammo_"+g.name]+r>g.max)
{
r=g.max-__e87.info["ammo_"+g.name];
}

__e87.info["ammo_"+g.name]+=r;
__e87 setClientDvars(
"found_prize","ammo_"+g.name,
"found_key",r+" "+level.s["AMMO_"+g.title+"_"+__e87.lang]
);
}
else
{
r=0;
}
}
else if(r<88)
{

a=[];
size=0;
__v89=level.weaps;__c89=level.weaponCount+1;for(j=1;j<__c89;j++)
{
__e89=__v89[j];if(__e89.group=="0"&&__e87.rating>=__e89.rating&&__e87.roleLevel[__e89.roleType]>=__e89.roleLevel)
{
a[size]=j;
size++;
}
}j=undefined;__c89=undefined;__v89=undefined;
if(size)
{
w=a[randomInt(size)];
__e87.item=__e87 maps\mp\gametypes\_menus::giveWeap(w,false);


if(__e87.item)
{
__e87 setClientDvars(
"found_prize",level.weaps[w].image,
"found_key",level.weaps[w].name
);
}
}

if(!__e87.item)
r=30;
}
else if(r<92)
{

if(__e87.weapons.size<__e87.info["maxweapons"])
{
a=[];
size=0;
__v90=level.weaps;__c90=level.weaponCount+1;for(j=1;j<__c90;j++)
{
if(__v90[j].group=="1"&&!isDefined(__e87.wID[j]))
{
a[size]=j;
size++;
}
}j=undefined;__c90=undefined;__v90=undefined;
if(size)
{
__e87.item=true;
rid=a[randomInt(a.size)];
w=level.weaps[rid];

wid=__e87.weapons.size+1;
__e87.weapons[wid]["id"]=rid;
__e87.weapons[wid]["type"]=w.type;
__e87.weapons[wid]["time"]=0;
__e87.weapons[wid]["camo"]=0;
__e87.weapons[wid]["mod"]=w.mod;
__e87.wID[rid]=wid;

sql_exec("INSERT INTO weapons (name, weapon, mods) VALUES ('"+__e87.showname+"', "+rid+", "+__e87.weapons[wid]["mod"]+")");

count=1;
for(j=1;j<__e87.weapons.size;j++)
{
if(__e87.weapons[j]["type"]==__e87.weapons[wid]["type"])
{
count++;
}
}
__e87 setClientDvars(
w.type+count,rid,
"hasweapon"+rid,1,
"found_prize",w.image,
"found_key",w.name
);
}
}

if(!__e87.item)
r=60;
}
else if(r<94)
{

d=__e87.inv.size;
if(__e87.info["maxinv"]>d)
{
__e87.item=true;
c=randomInt(level.camoCount-1)+1;
sql_exec("INSERT INTO inv (name, item, itemtype) VALUES ('"+__e87.showname+"', 'camo', "+c+")");
__e87.inv[d]=spawnStruct();
__e87.inv[d].id=int(sql_query_first("SELECT COALESCE(MAX(invid), 0) FROM inv WHERE name = '"+__e87.showname+"'"));
__e87.inv[d].item="camo";
__e87.inv[d].itemtype=c;
__e87 setClientDvars(
"found_prize","ui_camoskin_"+level.camos[c].img,
"found_key",level.camos[c].name
);
}
else
{
r=88;
}
}
else if(r<96)
{

d=__e87.inv.size;
if(__e87.info["maxinv"]>d)
{
__e87.item=true;
c=randomInt(level.toolCount);
e=level.tools[c].types[randomInt(level.tools[c].types.size)];
sql_exec("INSERT INTO inv (name, item, itemtype) VALUES ('"+__e87.showname+"', '"+level.tools[c].name+"', "+e+")");
__e87.inv[d]=spawnStruct();
__e87.inv[d].id=int(sql_query_first("SELECT COALESCE(MAX(invid), 0) FROM inv WHERE name = '"+__e87.showname+"'"));
__e87.inv[d].item=level.tools[c].name;
__e87.inv[d].itemtype=e;
__e87 setClientDvars(
"found_prize","tool_"+level.tools[c].img,
"found_key",level.s[level.tools[c].title+"_"+__e87.lang]
);
}
else
{
r=92;
}
}
else if(r<98)
{

rid=-1;
if(__e87.info["symbols"])
{
g=[];
size=0;
__v91=level.rareSymbols;__c91=level.rareSymbolCount;for(__i91=0;__i91<__c91;__i91++)
{
if(!(level.symbols[__v91[__i91]].value&__e87.info["symbols"]))
{
g[size]=__v91[__i91];
size++;
}
}__i91=undefined;__c91=undefined;__v91=undefined;
if(size)
{
rid=g[randomInt(size)];
}
}
else
{
rid=level.rareSymbols[randomInt(level.rareSymbolCount)];
}
if(rid!=-1)
{
__e87.item=true;
__e87.info["symbols"]|=level.symbols[rid].value;
__e87 setClientDvars(
"symbols",__e87.info["symbols"],
"found_prize","locked",
"found_key",level.s["SYMBOL_"+__e87.lang]+" #"+rid
);
}
else
{
r=94;
}
}

else{

rid=-1;
if(__e87.info["hats"])
{
g=[];
size=0;
__v92=level.hats;__c92=level.hatCount+1;for(j=1;j<__c92;j++)
{
if(!__v92[j].price&&!(__v92[j].bit&__e87.info["hats"]))
{
g[size]=j;
size++;
}
}j=undefined;__c92=undefined;__v92=undefined;
if(size)
{
rid=g[randomInt(size)];
}
}
else
{
rid=randomIntRange(1,level.hatCount+1);
}
if(rid!=-1)
{
__e87.item=true;
__e87.info["hats"]|=level.hats[rid].bit;
__e87 setClientDvars(
"hasitem_hat_"+rid,"1",
"found_prize","locked",
"found_key","@APB_HAT_"+level.hats[rid].name+"_"+__e87.lang
);
}
else
{
r=96;
}
}
}
}
}
else if(!isDefined(__e87.isBot))
{
__e87 thread waitAndRemoveBot();
__e87 thread showTutAfterStat();
}
}__i87=undefined;


__v93=getArrayKeys(groups);__c93=__v93.size;if(__c93){for(__i93=0;__i93<__c93;__i93++)
{
refreshGroup(__v93[__i93]);
}__i93=undefined;}__c93=undefined;__v93=undefined;

if(isDefined(m.war))
{
cols="";
vals="";
all=level.missions[id].war["alliesteam"].size;
__v94=m.war[win+"team"];for(i=0;i<all;i++)
{
cols+="winner"+i+", ";
vals+="'"+__v94[i]+"', ";
}i=undefined;__v94=undefined;
__v95=m.war[level.enemy[win]+"team"];for(i=0;i<all;i++)
{
cols+="loser"+i+", ";
vals+="'"+__v95[i]+"', ";
}i=undefined;__v95=undefined;
sql_exec("INSERT INTO wars (winner, loser, type, "+cols+"time, tied) VALUES ('"+m.war[win]+"', '"+m.war[level.enemy[win]]+"', "+all+", "+vals+getRealTime()+", "+(reason=="TIED")+")");

__v96=level.allActivePlayers;__c96=level.allActiveCount;for(__i96=0;__i96<__c96;__i96++)
{
__v96[__i96] thread showInfoLine(m.war[win]+" "+level.s["INFO_DEFEATED_"+__v96[__i96].lang]+" "+m.war[level.enemy[win]]);
}__i96=undefined;__c96=undefined;__v96=undefined;
}


{__c=level.missions.size-1;if(id!=__c)level.missions[id]=level.missions[__c];level.missions[__c]=undefined;}
}

showTutAfterStat()
{
self endon("disconnect");

self waittill("boardoff");
self.tut=7;
self setClientDvar("tutid",7);
self openMenu(game["menu_tutorial"]);
}


waitAndRemoveBot()
{
self endon("disconnect");

wait 0.05;
self removeBot();
}

quitTeam()
{
self setClientDvars(
"mission",false,
"teamid","",
"line1","",
"line2","",
"counter1","",
"counter1text","",
"counter2","",
"counter2text","",
"leftinfo","CHANGE_TO_READY"
);
self resetIcons();
self createPins();


self.stat=undefined;
self.enemyCompass=undefined;
self.objIcons=undefined;
self.teamleader=undefined;
self.missionId=undefined;
self.objCompass=undefined;
self.killTime=undefined;
self.lastKiller=undefined;
self.attackers=undefined;
self.vip=undefined;
self.clan=undefined;



if(!isDefined(self.group))
{
self setClientDvars(
"name0",self.showname,
"status0","notready",
"leader0","",
"leftoffset",1
);








}
for(j=0;j<8;j++)
{
removeFromRadar("map_friendly"+j);
removeFromRadar("map_enemy"+j);
removeFromRadar("map_obj"+j);

}
blockmenu=false;







if(isDefined(self.item))
{
self openMixMenu("found");

}
else
{
if(isDefined(self.invited))
{
p=self.invited;
if(!isDefined(p.group)||(isDefined(p.groupleader)&&level.groups[p.group].team.size<4))
{
self maps\mp\gametypes\_menus::inviteHUD(p.showname+" "+level.s["INVITE_BODY_"+self.lang]);


}
}
else if(isDefined(self.claninvited))
{
x=sql_query_first("SELECT clan FROM members WHERE name = '"+self.claninvited+"' AND rank != 0");
if(isDefined(x))
{
self maps\mp\gametypes\_menus::inviteHUD(self.claninvited+" "+level.s["INVITE_BODY_CLAN_"+self.lang]+": "+x);


}
}
self closeMenu();
self stat();
}





if(!isDefined(self.group)||(isDefined(self.groupleader)&&level.groups[self.group].team.size<4))
{
__v97=level.activePlayers[self.team];__c97=level.activeCount[self.team];for(__i97=0;__i97<__c97;__i97++)
{
__e97=__v97[__i97];if(isDefined(__e97.invited)&&__e97.invited==self)
{
__e97 maps\mp\gametypes\_menus::inviteHUD(self.showname+" "+level.s["INVITE_BODY_"+__e97.lang]);

}
}__i97=undefined;__c97=undefined;__v97=undefined;
}
self notify("endmission");
}

removeFromRadar(id)
{
if(isDefined(self.radar[id]))
{
self.radar[id]=undefined;
self setClientDvar(
id+"z",
""
);
}
}

getAward()
{

medals=0;
__v98=self.stat["medals"];__c98=__v98.size;if(__c98){__k98=getArrayKeys(__v98);for(__i98=0;__i98<__c98;__i98++)
{
medals+=__v98[__k98[__i98]];
}__i98=undefined;__k98=undefined;}__c98=undefined;__v98=undefined;

if(self.stat["arrests"]>=0)
arrests=self.stat["arrests"]*1.5;
else
 arrests=self.stat["arrests"]*-0.5;

score=(arrests+self.stat["stuns"]*0.25+self.stat["kills"]+self.stat["assists"]*0.5+self.stat["deaths"]*-0.5+self.stat["targets"]*1.5+medals*0.1)*25+1000/level.teams[self.missionTeam].size+self.dmg/10;





return int(score);
}

playMusic()
{
self endon("disconnect");
self endon("stopmusic");
self setClientDvar("time_delaymusic",getTime()-self.startTime);
self playLocalSound("music"+self.playing);

self setClientDvars(
"music_title",level.music[self.playing]["title"],

"music_rate",level.music[self.playing]["time"],
"music_playing",self.playing
);





wait level.music[self.playing]["time"];
if(self.musicstatus=="one")
{
self clearMusic();
}
else
{
if(self.musicstatus=="all")
{
if(self.playing==19)
self.playing=0;
else
 self.playing++;
}

self thread playMusic();
}
}

clearMusic()
{
self.playing=undefined;
self setClientDvars(
"music_title","---",


"music_playing",""
);
}














stat()
{
self menuStatus(true);
self setClientDvar("playerid",self.teamId);
self playerDetails(self.clientid);
self openMenu(game["menu_stat"]);
}











backup()
{
missionTeam=self.missionTeam;
enemyTeam=self.enemyTeam;
missionId=self.missionId;
m=level.missions[missionId];
ta=level.teams[missionTeam];
ea=level.teams[enemyTeam];

level endon("endbackup"+missionTeam);

friend=self.team;


level.missions[missionId].backup=true;
self setClientDvar("leftinfo","SEARCHING");


__v99=m.all;__c99=m.allCount;for(__i99=0;__i99<__c99;__i99++)
{
__v99[__i99] thread mainLine(self.showname+" "+level.s["REQUESTED_BACKUP_"+__v99[__i99].lang]);
}__i99=undefined;__c99=undefined;__v99=undefined;

while(true)
{
wait 1;
c=level.readyPlayers[friend].size;
g=level.readyGroups[friend].size;
t=ta.size;
if(c||(g&&t<7))
{
e=ea.size;
ga=level.readyGroups[friend];
pa=level.readyPlayers[friend];
if(!c)
{
blockbackup=true;
if(t<e)
{
for(i=0;i<g&&blockbackup;i++)
{
if(level.groups[ga[i]].team.size==2)
{
blockbackup=false;
}
}
}
if(blockbackup)
{
continue;
}
}

if(c){
dist=distanceSquared(self.origin,pa[0].origin);
distid=0;
for(i=1;i<c;i++)
{
d=distanceSquared(self.origin,pa[i].origin);
if(d<dist)
{
dist=d;
distid=i;
}
}
p=pa[distid];

if(p.ready)
p unreadyPlayer();

p setClientDvar("leftinfo","");
p.missionTeam=missionTeam;
p.enemyTeam=enemyTeam;
p.teamId=t;
p setClanStat();
newplayers[0]=p;


leader="";
for(__i100=0;__i100<e;__i100++)
{
__e100=ea[__i100];__e100 thread showAlert(p.showname+" "+level.s["JOINED_AGAINST_"+__e100.lang]+".","BackupNotify");

if(isDefined(__e100.teamleader))
leader=__e100.showname;
}__i100=undefined;
__v101=m.all;__c101=m.allCount;for(__i101=0;__i101<__c101;__i101++)
{
__e101=__v101[__i101];__e101 thread showAlert(p.showname+" "+level.s["JOINED_YOUR_TEAM_"+__e101.lang]+".","BackupNotify");
__e101 createPlayerInfo(newplayers);
}__i101=undefined;__c101=undefined;__v101=undefined;
p thread showAlert(e+" "+level.s["ENEMIES_JOINED_"+p.lang]+" "+leader,"BackupNotify");


if(isDefined(level.placedPoints[missionTeam]))
{
__v102=level.placedPoints[missionTeam];__c102=__v102.size;for(__i102=0;__i102<__c102;__i102++)
{
__v102[__i102] showToPlayer(p);
__v102[__i102] maps\mp\gametypes\_menus::newPlacedHud(p);
}__i102=undefined;__c102=undefined;__v102=undefined;
}

level.teams[missionTeam][p.teamId]=p;
level.missions[missionId].all[m.allCount]=p;
level.missions[missionId].allCount++;
p joinMission(missionId);
p[[level.missions[missionId].backupFunc]]();

self addBackup();
}
else
{
g=0;
ming=0;
__c103=ga.size;for(i=0;i<__c103;i++)
{
z=level.groups[ga[i]].team;
if(z.size==2)
{
p1=distanceSquared(self.origin,z[0].origin);
p2=distanceSquared(self.origin,z[1].origin);
if(!g)
{
g=i;
if(p1<p2)
ming=p1;
else
 ming=p2;
}
else
{
if(p1<p2)
{
if(p1<ming)
{
g=i;
ming=p1;
}
}
else
{
if(p2<ming)
{
g=i;
ming=p2;
}
}
}
}
}i=undefined;__c103=undefined;
newplayers=level.groups[ga[g]].team;
{__c=level.readyGroups[friend].size-1;if(g!=__c)level.readyGroups[friend][g]=level.readyGroups[friend][__c];level.readyGroups[friend][__c]=undefined;}

leader="";
for(__i104=0;__i104<e;__i104++)
{
__e104=ea[__i104];__e104 thread showAlert(newplayers[0].showname+" "+level.s["AND_"+__e104.lang]+newplayers[1].showname+" "+level.s["JOINED_AGAINST_"+__e104.lang]+".","BackupNotify");

if(isDefined(__e104.teamleader))
leader=__e104.showname;
}__i104=undefined;
__v105=m.all;__c105=m.allCount;for(__i105=0;__i105<__c105;__i105++)
{
__e105=__v105[__i105];__e105 thread showAlert(newplayers[0].showname+" "+level.s["AND_"+__e105.lang]+newplayers[1].showname+" "+level.s["JOINED_YOUR_TEAM_"+__e105.lang]+".","BackupNotify");
__e105 createPlayerInfo(newplayers);
}__i105=undefined;__c105=undefined;__v105=undefined;

for(__i106=0;__i106<2;__i106++)
{

__e106=newplayers[__i106];__e106 setClientDvar("leftinfo","");
__e106.missionTeam=missionTeam;
__e106.enemyTeam=enemyTeam;
__e106.teamId=level.teams[missionTeam].size;
__e106 thread showAlert(level.teams[enemyTeam].size+" "+level.s["ENEMIES_JOINED_"+__e106.lang]+" "+leader,"BackupNotify");
__e106 setClanStat();
ta[__e106.teamId]=__e106;
level.missions[missionId].all[m.allCount]=__e106;
level.missions[missionId].allCount++;
}__i106=undefined;



for(__i107=0;__i107<2;__i107++)
{
newplayers[__i107] joinMission(missionId);
newplayers[__i107][[level.missions[missionId].backupFunc]]();
}__i107=undefined;

self addBackup();
}
refreshTeam(missionTeam);


__c108=newplayers.size;for(__i108=0;__i108<__c108;__i108++)
{
__e108=newplayers[__i108];__e108 setClientDvar("ui_enemy_count",e);
for(j=0;j<e;j++)
{



__e109=ea[j];__e108 setClientDvars(
"ui_enemy_name"+j,__e109.showname,
"ui_enemy_kills"+j,__e109.stat["kills"]+"^8 + "+__e109.stat["assists"],
"ui_enemy_arrests"+j,__e109.stat["arrests"],
"ui_enemy_deaths"+j,__e109.stat["deaths"],
"ui_enemy_targets"+j,__e109.stat["targets"],
"ui_enemy_medals"+j,__e109.stat["medals"].size,
"ui_enemy_cash"+j,"$"+__e109.stat["cash"]+"^3 + $"+__e109.stat["pcash"],
"ui_enemy_standing"+j,__e109.stat["standing"]+"^3 + "+__e109.stat["pstanding"],
"ui_enemy_icon"+j,level.ranks[__e109.rating]["id"]+"_"+__e109.team,
"ui_enemy_threat"+j,__e109.threat
);


















}j=undefined;
}__i108=undefined;__c108=undefined;
return;
}
}
}

addBackup()
{
self.info["backupcalled"]++;
self setClientDvar("backupcalled",self.info["backupcalled"]);


if(self.info["backupcalled"]==100)
self giveAchievement("BACKUP");





}






























playerDetails(p)
{
s=self.playerStats[p];


self setClientDvars(
"ui_selected_name",s.name,
"ui_selected_icon",s.rank,
"ui_selected_threat",s.threat,
"ui_selected_rating",maps\mp\gametypes\_rank::padRating(s.rating),
"ui_selected_weapon",tableLookup("mp/weaponTable.csv",0,s.primary,2),
"ui_selected_weapon_icon",tableLookup("mp/weaponTable.csv",0,s.primary,3),
"ui_selected_weapon_width",tableLookup("mp/weaponTable.csv",0,s.primary,4),
"ui_selected_weapon_height",tableLookup("mp/weaponTable.csv",0,s.primary,5),
"ui_selected_weapperk1",s.primaryperks[0],
"ui_selected_weapperk2",s.primaryperks[1],
"ui_selected_weapperk3",s.primaryperks[2],



"ui_selected_perk1",s.perk1,
"ui_selected_perk2",s.perk2,
"ui_selected_perk3",s.perk3,
"ui_selected_symbol",s.symbol,
"ui_selected_team",s.team
);
if(isDefined(s.clan))
{
self setClientDvars(
"ui_selected_clan",s.clan,
"ui_selected_clan_crank",s.clan_crank,
"ui_selected_clan_mrank",s.clan_mrank,
"ui_selected_clan_threat",s.clan_threat
);
}
else
{
self setClientDvar("ui_selected_clan","");
}

for(i=0;i<13;i++)
{
if(i<s.medals.size)
self setClientDvar("ui_selected_medal"+(i+1),s.medals[i]);
else
 self setClientDvar("ui_selected_medal"+(i+1),"");
}
}

joinGroup(gid)
{
t=level.groups[gid].team;
size=t.size;
for(__i110=0;__i110<size;__i110++)
{
t[__i110] newMessage("^2"+self.showname+" "+level.s["JOINED_IN_GROUP_"+t[__i110].lang]);
}__i110=undefined;

level.groups[gid].team[size]=self;
self.group=gid;
self.groupId=size;

if(self.ready)
self unreadyPlayer();

refreshGroup(gid);
}

abandonTeam(id)
{
level notify("endbackup"+id);


lastTeam=level.teams.size-1;
__v111=level.allActivePlayers;__c111=level.allActiveCount;for(__i111=0;__i111<__c111;__i111++)
{
__e111=__v111[__i111];if(!isDefined(__e111.leaving)&&isDefined(__e111.missionTeam))
{
if(__e111.missionTeam==id)
__e111.missionTeam=undefined;
else if(__e111.missionTeam==lastTeam)
__e111.missionTeam=id;
else if(__e111.enemyTeam==id)
__e111.enemyTeam=undefined;
else if(__e111.enemyTeam==lastTeam)
__e111.enemyTeam=id;
}
}__i111=undefined;__c111=undefined;__v111=undefined;
size=level.missions.size;
for(i=0;i<size;i++)
{
if(i!=id)
{
if(level.missions[i].team["allies"]==lastTeam)
{
level.missions[i].team["allies"]=id;
break;
}
else if(level.missions[i].team["axis"]==lastTeam)
{
level.missions[i].team["axis"]=id;
break;
}
}
}
{__c=level.teams.size-1;if(id!=__c)level.teams[id]=level.teams[__c];level.teams[__c]=undefined;}
}

target(count,item)
{
self.stat["targets"]++;
self refreshStat("targets");
money=self giveMoney(30*count);
standing=self giveStanding(12*count);
self newMessage(level.s["TARGET_REWARD_"+self.lang]+": "+money.display+", "+standing+" "+level.s["STANDING_"+self.lang]);

if(isDefined(item))
{
self.info["delivereditems"]++;
self setClientDvar("delivereditems",self.info["delivereditems"]);
if(self.info["delivereditems"]==100)
self giveAchievement("ITEMS");


}



}

timeLimit(id,max,func)
{
level endon("endmission"+id);

time=max;
while(time)
{
wait 1;
time--;


level.missions[id].timeleft=leftTimeToString(time,"noh");
m=level.missions[id];
all=m.all;
allCount=m.allCount;

for(__i112=0;__i112<allCount;__i112++)
{
all[__i112] setClientDvar("timeleft",m.timeLeft);
}__i112=undefined;
if(time==60)
{
for(__i113=0;__i113<allCount;__i113++)
{
all[__i113] thread mainLine(level.s["ONE_MIN_REMAINING_"+all[__i113].lang]+"!","","OneMinuteRemaining");
}__i113=undefined;
}
if(isDefined(m.countFuseTime))
{
level.missions[id].fuseTime--;

t=leftTimeToString(m.fuseTime,"noh shortm");
if(m.fuseTime)
{
for(__i114=0;__i114<allCount;__i114++)
{
all[__i114] setClientDvar("counter1",t);
}__i114=undefined;
}
else
{
level notify("endmission"+id,m.attackTeam);
}
}

}
thread[[func]](id);
}

leftTimeToString(left,type)
{
h=0;
s=0;

if(!isDefined(type))
type="";

noh=isSubStr(type,"noh");

if(noh)
{
m=int(left/60);
s=left%60;
}
else
{
h=int(left/3600);
m=int((left-h*3600)/60);
}

if(!isSubStr(type,"shortm")&&m<10)
m="0"+m;

if(isSubStr(type,"nos"))
{
if(h<10)
h="0"+h;

return h+":"+m;
}
else
{
if(s<10)
s="0"+s;

if(noh)
return m+":"+s;
else
 return h+":"+m+":"+s;
}
}

startFlashing()
{
level endon("endmission"+self.missionId);

while(self.taker!=self.owner)
{
self flashing();
}
}

startSingleFlashing()
{
level endon("endmission"+self.missionId);

while(isDefined(self.taker)||(isDefined(self.takers)&&self.takers.size))
{
self flashing();
}
}

flashing()
{
id=self.missionId;

level endon("endmission"+id);
self endon("captured");


__v115=level.teams[level.missions[id].team["allies"]];__c115=__v115.size;for(__i115=0;__i115<__c115;__i115++)
{
__v115[__i115] thread flash(self);
}__i115=undefined;__c115=undefined;__v115=undefined;
__v116=level.teams[level.missions[id].team["axis"]];__c116=__v116.size;for(__i116=0;__i116<__c116;__i116++)
{
__v116[__i116] thread flash(self);
}__i116=undefined;__c116=undefined;__v116=undefined;

id=undefined;
wait 1.5;
}

flash(point)
{
self endon("disconnect");
level endon("endmission"+point.missionId);





self.objIcons[point.id] fadeOverTime(0.75);
self.objIcons[point.id].alpha=0.15;
wait 0.75;


if(isDefined(self.objIcons[point.id]))
{
self.objIcons[point.id] fadeOverTime(0.75);
self.objIcons[point.id].alpha=1;
wait 0.75;
}
}


giveSupplier()
{
if(self.perk3=="supplier"&&!self hasWeapon(level.fieldSupplier))
{

if(!isDefined(self.lastSupplier)||self.lastSupplier+240000<=getTime())
{
self giveWeapon(level.fieldSupplier);
self setActionSlot(3,"weapon",level.fieldSupplier);
}
else
{
self thread waitAndGiveSupplier(int((self.lastSupplier+240000-getTime())/1000+1));
}
}
}
waitAndGiveSupplier(time)
{
self endon("disconnect");
self notify("waitsupply");
self endon("waitsupply");

for(i=time;i;i--)
{
if(i>180)
self setClientDvar("supplytime",4+level.s["MIN_"+self.lang]);
else if(i>120)
self setClientDvar("supplytime",3+level.s["MIN_"+self.lang]);
else if(i>60)
self setClientDvar("supplytime",2+level.s["MIN_"+self.lang]);
else
 self setClientDvar("supplytime",i);

wait 1;
}
self setClientDvar("supplytime","");
self giveSupplier();
}
takeSupplier()
{
self notify("waitsupply");
self takeWeapon(level.fieldSupplier);
self setActionSlot(3,"");
self setClientDvar("supplytime","");
}
checkResupply(trig)
{
if(!isDefined(self.supply))
{
if(isDefined(self.perks["extraammo"]))
{
primaryAll=weaponMaxAmmo(self.primaryWeapon);
secondaryAll=weaponMaxAmmo(self.secondaryWeapon);
}
else
{
primaryAll=weaponStartAmmo(self.primaryWeapon);
secondaryAll=weaponStartAmmo(self.secondaryWeapon);
}
type=[];
cur=self getWeaponAmmoClip(self.primaryWeapon)+self getWeaponAmmoStock(self.primaryWeapon);
if(cur!=primaryAll&&cur<self.info["ammo_"+level.ammo[self.primaryWeapon]])
type["primary"]=true;
cur=self getWeaponAmmoClip(self.secondaryWeapon)+self getWeaponAmmoStock(self.secondaryWeapon);
if(cur!=secondaryAll&&cur<self.info["ammo_"+level.ammo[self.secondaryWeapon]])
type["secondary"]=true;
cur=self getWeaponAmmoClip(self.offhandWeapon);
if(cur!=weaponClipSize(self.offhandWeapon)&&cur<self.info["ammo_"+level.ammo[self.offhandWeapon]])
type["offhand"]=true;

if(type.size)
{
self maps\mp\gametypes\apb::resupply(type,trig);
}
}
}
resupply(type,trig)
{
if(!isDefined(self.supply))
{
self.supply=type;
self newLoadBar();
self thread supply(getArrayKeys(type)[0],trig);
}
}
supply(type,trig)
{
self endon("disconnect");

wpn="";

switch(type)
{
case"primary":
wpn=self.primaryWeapon;

break;
case"secondary":
wpn=self.secondaryWeapon;

break;
case"offhand":
wpn=self.offhandWeapon;

break;
}

ownAmmo=self.info["ammo_"+level.ammo[wpn]];
exit="";
if(ownAmmo)
{
self.loadbar setShader("white",0,9);
offhand=type=="offhand";

if(!offhand&&isDefined(self.perks["extraammo"]))
maxAmmo=weaponMaxAmmo(wpn);
else
 maxAmmo=weaponStartAmmo(wpn);

if(ownAmmo<maxAmmo)
maxAmmo=ownAmmo;

clipSize=weaponClipSize(wpn);


stockSize=maxAmmo-clipSize;

while(exit=="")
{
if(isDefined(trig)&&self isTouching(trig)&&self.sessionstate=="playing")
{
newwpn="";
switch(type)
{
case"primary":
newwpn=self.primaryWeapon;
break;
case"secondary":
newwpn=self.secondaryWeapon;
break;
case"offhand":
newwpn=self.offhandWeapon;
break;
}
if(newwpn==wpn)
{
wait 1;
self playLocalSound("LoadBeep");
if(offhand)
{
ammo=self getWeaponAmmoClip(wpn)+1;
self setWeaponAmmoClip(wpn,ammo);

if(ammo==maxAmmo)
exit="ok";

self.loadbar setShader("white",int((ammo/maxAmmo)*100),9);
self setClientDvar("weapinfo_offhand",ammo);
}
else if(stockSize<=0)
{

if(type=="primary"&&level.weaps[self.info["prime"]].image=="rotated_m16")self setWeaponAmmoClip(wpn,maxAmmo-maxAmmo%3);
else
 self setWeaponAmmoClip(wpn,maxAmmo);

self.loadbar setShader("white",100,9);
exit="ok";
}
else
{
curClip=self getWeaponAmmoClip(wpn);
curStock=self getWeaponAmmoStock(wpn);
left=stockSize-curStock;
if(!left)
{
exit="ok";
self setWeaponAmmoClip(wpn,clipSize);
newClip=clipSize;
newStock=curStock;
}
else
{
if(left<=clipSize)
{
if(curClip==clipSize)
exit="ok";

newStock=stockSize;
}
else
{
newStock=curStock+clipSize;
}


if(type=="primary"&&level.weaps[self.info["prime"]].image=="rotated_m16")self setWeaponAmmoStock(wpn,newStock-newStock%3);
else
 self setWeaponAmmoStock(wpn,newStock);

newClip=curClip;
}
self.loadbar setShader("white",int(((newStock+newClip)/maxAmmo)*100),9);
}
}
else
{
exit="newweapon";
}
}
else
{
exit="break";
}
}
}
if(exit=="newweapon")
{
self.supply[type]=undefined;
self thread supply(type,trig);
}
else if(exit=="break")
{
self killLoadBar();
self.supply=undefined;
}
else if(isDefined(self.supply)&&self.supply.size>1)
{
self.supply[type]=undefined;
self thread supply(getArrayKeys(self.supply)[0],trig);
}
else
{
wait 1;
self killLoadBar();
self.supply=undefined;
self playLocalSound("LoadReady");
}
}

destroyObject(id)
{
self.objIcons[id]destroy();
self.objIcons[id]=undefined;
self.objCompass[id]=undefined;
self.radar["map_obj"+id]=undefined;
self setClientDvar("map_obj"+id+"z","");
}

averagePos(p)
{
origin=(0,0,0);

s=p.size;
for(__i117=0;__i117<s;__i117++)
{
origin+=p[__i117].origin;
}__i117=undefined;

return origin/s;
}


endPlant()
{
self.curTime=undefined;
if(isDefined(self.hasBomb))
{
self.hasBomb=undefined;
self detach("prop_suitcase_bomb","tag_inhand");
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
level endon("endmission"+self.missionId);
self endon("nobomb");
self endon("disconnect");

self loadBar(0,self.missionId);
self giveWeapon(level.bomb);
self switchToWeapon(level.bomb);
self linkTo(point);

wait 1.3;

self attach("prop_suitcase_bomb","tag_inhand",true);
self.hasBomb=true;
}

takeBomb()
{
self endon("disconnect");
self endon("nobomb");

while(self.currentWeapon==level.bomb&&!self.throwingGrenade)
wait 0.05;

self takeWeapon(level.bomb);
}

overtimeMessage(id)
{








__v118=level.missions[id].all;__c118=level.missions[id].allCount;for(__i118=0;__i118<__c118;__i118++)
{
__v118[__i118] thread boldLine(level.s["OVERTIME_"+__v118[__i118].lang]+"!","Overtime");
}__i118=undefined;__c118=undefined;__v118=undefined;
}

getRespawnData()
{

a=(0,0,0);
q=[];
x=0;
id=self.missionId;
if(isDefined(level.missions[id].obj))
{
__v119=level.missions[id].obj;__c119=__v119.size;key=getArrayKeys(__v119);for(j=0;j<__c119;j++)
{
__e119=__v119[key[j]];if(isDefined(__e119[self.team]))
{
a+=__e119["pos"].origin;
self setClientDvars(
"respawn_obj"+x+"_x",__e119["pos"].origin[0],
"respawn_obj"+x+"_y",__e119["pos"].origin[1],
"respawn_obj"+x+"_type",__e119[self.team]
);
q[x]=key[j];
x++;
}
}j=undefined;key=undefined;__c119=undefined;__v119=undefined;
}


self.respawnData=[];
y=0;
if(x)
{
a/=x;

__v120=level.spawns;__c120=__v120.size;for(__i120=0;__i120<__c120;__i120++)
{
__e120=__v120[__i120];allow=false;
for(__i121=0;__i121<x;__i121++)
{
d=distance2DSquared(
__e120.origin[0],__e120.origin[1],
level.missions[id].obj[q[__i121]]["pos"].origin[0],level.missions[id].obj[q[__i121]]["pos"].origin[1]
);


if(d<9000000){
allow=false;
break;
}


if(!allow&&d<25000000)allow=true;
}__i121=undefined;
if(allow)
{
self setClientDvars(
"respawn_point"+y+"_x",__e120.origin[0],
"respawn_point"+y+"_y",__e120.origin[1]
);
self.respawnData[y]=__e120;
y++;
}
}__i120=undefined;__c120=undefined;__v120=undefined;
}


if(!y)
{
__v122=level.spawns;__c122=__v122.size;for(__i122=0;__i122<__c122;__i122++)
{
__e122=__v122[__i122];
if(distance2DSquared(__e122.origin[0],__e122.origin[1],self.origin[0],self.origin[1])<9000000){
self setClientDvars(
"respawn_point"+y+"_x",__e122.origin[0],
"respawn_point"+y+"_y",__e122.origin[1]
);
self.respawnData[y]=__e122;
y++;
}
}__i122=undefined;__c122=undefined;__v122=undefined;
}

















self setClientDvars(
"respawn_x",a[0],
"respawn_y",a[1],
"respawn_objs",x,
"respawn_points",y
);
}

updateRespawnMap(id)
{
__v123=level.missions[id].all;__c123=level.missions[id].allCount;for(__i123=0;__i123<__c123;__i123++)
{
__e123=__v123[__i123];if(isDefined(__e123.respawnData))
{
__e123.spawn=undefined;
__e123 getRespawnData();


__e123 closeMenu(game["menu_map"]);
__e123 openMenu(game["menu_map"]);
}
}__i123=undefined;__c123=undefined;__v123=undefined;
}




mission_deliver(id)
{

if(randomInt(2))
level.missions[id].attackTeam="allies";
else
 level.missions[id].attackTeam="axis";

m=level.missions[id];
level.missions[id].defendTeam=level.enemy[m.attackTeam];


att=level.teams[m.team[m.attackTeam]];
def=level.teams[m.team[m.defendTeam]];


attOrigin=averagePos(att);
defOrigin=averagePos(def);
pnt=level.pickupPoints[0];
dis=-1;
__v124=level.pickupPoints;__c124=__v124.size;for(__i124=0;__i124<__c124;__i124++)
{
__e124=__v124[__i124];if(!isDefined(__e124.occupied))
{
defDist=distanceSquared(defOrigin,__e124.origin);
attDist=distanceSquared(attOrigin,__e124.origin);
newDis=abs(defDist-attDist);
if(dis==-1||newDis<dis)
{
pnt=__e124;
dis=newDis;
}
}
}__i124=undefined;__c124=undefined;__v124=undefined;



if(dis==-1)
{
level.missions[id].currentStage--;
thread newObj(id);
return;
}

pnt.occupied=true;
pnt.id=0;
pnt.missionId=id;
pnt.takers=[];
pnt thread bePickupPoint();
level.missions[id].obj[0]["pos"]=pnt;
level.missions[id].obj[0][m.defendTeam]="defend";
level.missions[id].obj[0][m.attackTeam]="capture";
items=pnt.items;
itemc=items.size;
for(i=0;i<itemc;i++)
{
__e125=items[i];__e125.id=i+1;
__e125.missionId=id;
__e125 thread bePickupItem();
level.missions[id].obj[__e125.id]["pos"]=__e125;
level.missions[id].obj[__e125.id][m.attackTeam]="pickup";
}i=undefined;


level.missions[id].maxTime=120*itemc;
level.missions[id].captureTime=5;
timeString=leftTimeToString(m.maxTime,"noh");


__v126=m.all;__c126=m.allCount;for(__i126=0;__i126<__c126;__i126++)
{
__e126=__v126[__i126];__e126.objects=0;
__e126.objIcons=[];
__e126 setClientDvars(
"counter1","0/"+itemc,
"counter1text","DELIVERED_ITEMS",
"timeleft",timeString,
"mission_title","DISPATCH",
"mission_desc","PICKUP"
);
}__i126=undefined;__c126=undefined;__v126=undefined;


__c127=att.size;for(__i127=0;__i127<__c127;__i127++)
{
__e127=att[__i127];__e127 objOnCompass(0,pnt.origin,"drop");
pnt thread showAll("enemy",__e127);

for(j=0;j<itemc;j++)
{
__e127 objOnCompass(j+1,items[j].origin,"pickup");
}j=undefined;
}__i127=undefined;__c127=undefined;
__c129=def.size;for(__i129=0;__i129<__c129;__i129++)
{
def[__i129] objOnCompass(0,pnt.origin,"defend");
pnt thread showAll("friend",def[__i129]);
}__i129=undefined;__c129=undefined;

point[0]=pnt;
level.missions[id].allItems=items.size;
level.missions[id].delivered=0;
level.missions[id].backupFunc=::mission_deliver_backup;
level.missions[id].giveupFunc=::mission_deliver_giveup;
level.missions[id].timeleft=timeString;
level.missions[id].points=point;
level.missions[id].point=pnt;
level.missions[id].items=items;
thread timeLimit(id,m.maxTime,::mission_deliver_timelimit);

updateRespawnMap(id);


thread mission_deliver_end(id);
}

mission_deliver_end(id)
{
level waittill("endmission"+id,winner,giveup);

level.missions[id].point.occupied=undefined;

if(level.missions[id].point.takers.size){
__v130=level.missions[id].point.takers;__c130=__v130.size;__k130=getArrayKeys(__v130);for(__i130=0;__i130<__c130;__i130++)
{
__v130[__k130[__i130]] killLoadBar();
}__i130=undefined;__k130=undefined;__c130=undefined;__v130=undefined;
}
level.missions[id].point.takers=undefined;
level.missions[id].point.id=undefined;
level.missions[id].point.missionId=undefined;
level.missions[id].point hideAll();


__v131=level.missions[id].items;__c131=__v131.size;for(__i131=0;__i131<__c131;__i131++)
{
__e131=__v131[__i131];if(!isDefined(__e131.taken))
{
__e131.obj delete();
__e131.trigger delete();
}
__e131.id=undefined;
__e131.missionId=undefined;
__e131.taken=undefined;
__e131.put=undefined;
}__i131=undefined;__c131=undefined;__v131=undefined;


__v132=level.missions[id].all;__c132=level.missions[id].allCount;for(__i132=0;__i132<__c132;__i132++)
{
__v132[__i132].objects=undefined;
__v132[__i132] setClientDvar("items",0);
}__i132=undefined;__c132=undefined;__v132=undefined;

if(isDefined(giveup))
endMission(id,winner,"GIVEUP");
else if(winner=="defend")
endMission(id,level.missions[id].defendTeam,"COMPLETE");
else
 thread newObj(id);
}

mission_deliver_giveup(id,team)
{
level notify("endmission"+id,team,true);
}

mission_deliver_backup()
{
friend=self.team;
enemy=level.enemy[self.team];
m=level.missions[self.missionId];

self.objects=0;
self.objIcons=[];
if(self.team==m.defendTeam)
{
m.point thread showAll("friend",self);
self objOnCompass(0,m.point.origin,"defend");
}
else
{
m.point thread showAll("enemy",self);
self objOnCompass(0,m.point.origin,"capture");
__v133=m.items;__c133=__v133.size;for(j=0;j<__c133;j++)
{
__e133=__v133[j];if(!isDefined(__e133.put))
{
if(isDefined(__e133.taken))
self newMissionPoint("follow"+__e133.id,__e133.taken,"obj");
else
 self objOnCompass(j+1,__e133.origin,"pickup");
}
}j=undefined;__c133=undefined;__v133=undefined;
}
self setClientDvars(
"timeleft",m.timeleft,
"counter1",m.delivered+"/"+m.allItems,
"counter1text","DELIVERED_ITEMS",
"mission_title","DISPATCH",
"mission_desc","PICKUP"
);
}

mission_deliver_timelimit(id)
{
level endon("endmission"+id);


if(level.missions[id].point.takers.size)
{
overtimeMessage(id);

while(true){
level.missions[id].point waittill("dropped");
if(!(level.missions[id].point.takers.size))break;}
}

level notify("endmission"+id,"defend");
}

bePickupPoint()
{
id=self.missionId;
level endon("endmission"+id);

while(true)
{
self waittill("trigger",p);
if(isDefined(p.missionId)&&p.missionId==id&&isAlive(p)&&p.team==level.missions[id].attackTeam&&p.objects&&!isDefined(self.takers[p.clientid]))
{
self.takers[p.clientid]=p;
p loadBar(0,id);
p thread dropItem(self);
}
}
}

watchDropDisconnect(p)
{
level endon("endmission"+self.missionId);
self endon("stopdrop");
p waittill("disconnect");
self notify("stopdrop");
}

dropItem(point)
{
id=point.missionId;
self endon("disconnect");
level endon("endmission"+id);

point thread watchDropDisconnect(self);
point thread startSingleFlashing();
curTime=0.05;
wait 0.05;
while(curTime<level.missions[id].captureTime&&self isTouching(point)&&isAlive(self))
{
curTime+=0.05;
wait 0.05;
}

self killLoadBar();
point.takers[self.clientid]=undefined;


if(curTime==level.missions[id].captureTime&&self isTouching(point))
{
level.missions[id].delivered+=self.objects;
self target(self.objects,true);
self.objects=0;
self notify("putitem");
self setClientDvar("items",0);

__v134=level.missions[id].items;__c134=__v134.size;for(__i134=0;__i134<__c134;__i134++)
{
__e134=__v134[__i134];if(!isDefined(__e134.put)&&isDefined(__e134.taken)&&__e134.taken==self)
__e134.put=true;
}__i134=undefined;__c134=undefined;__v134=undefined;
if(level.missions[id].delivered==level.missions[id].allItems)
{
point hideAll();
__v135=level.missions[id].all;__c135=level.missions[id].allCount;for(__i135=0;__i135<__c135;__i135++)
{
__v135[__i135] destroyObject(0);
__v135[__i135] setClientDvars(
"counter1","",
"counter1text",""
);
}__i135=undefined;__c135=undefined;__v135=undefined;
level notify("endmission"+id,"attack");
}
else
{
d=level.missions[id].delivered+"/"+level.missions[id].allItems;
__v136=level.missions[id].all;__c136=level.missions[id].allCount;for(__i136=0;__i136<__c136;__i136++)
{
__e136=__v136[__i136];__e136 setClientDvar("counter1",d);
__e136 thread mainLine(level.s["DELIVERED_ITEMS_"+__e136.lang]+": "+d);
}__i136=undefined;__c136=undefined;__v136=undefined;
}
}

point notify("stopdrop");
}

bePickupItem(origin,angles)
{
if(!isDefined(origin))
origin=self.origin;
if(!isDefined(angles))
angles=self.angles;

self.obj=spawn("script_model",origin);
self.obj setModel("com_copypaper_box");
self.obj.angles=angles;
self.trigger=spawn("trigger_radius",origin,0,16,16);

id=self.missionId;
while(isDefined(self.trigger))
{
self.trigger waittill("trigger",player);
if(isDefined(player.missionId)&&player.missionId==id&&player.team==level.missions[id].attackTeam&&player useButtonPressed())
{
if(!player.objects)
{
player thread watchLoseObjects();
player thread watchLoseObjectsStun();
player thread watchLoseObjectsDisconnect();
}

player.objects++;
player setClientDvar("items",player.objects);
self.obj delete();
self.trigger delete();
self.taken=player;
level.missions[self.missionId].obj[self.id]=undefined;

__v137=level.teams[level.missions[id].team[level.missions[id].attackTeam]];__c137=__v137.size;for(__i137=0;__i137<__c137;__i137++)
{
__e137=__v137[__i137];__e137 destroyObject(self.id);

if(__e137!=player)
__e137 newMissionPoint("follow"+(self.id),player,"obj");
}__i137=undefined;__c137=undefined;__v137=undefined;
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

self waittill("disconnect",origin,angles);
self dropObjects(origin,angles);
}

dropObjects(origin,angles)
{

if(isPlayer(self))
{
self.objects=0;
self setClientDvar("items",0);

origin=self.origin;
angles=self.angles;
}


origin=physicsTrace(origin,origin-(0,0,1000));

att=level.teams[level.missions[self.missionId].team[level.missions[self.missionId].attackTeam]];
__v138=level.missions[self.missionId].items;__c138=__v138.size;for(__i138=0;__i138<__c138;__i138++)
{
__e138=__v138[__i138];
if(!isDefined(__e138.put)&&!isDefined(__e138.obj)&&(!isDefined(__e138.taken)||__e138.taken==self)){
level.missions[self.missionId].obj[__e138.id]["pos"]=__e138;
level.missions[self.missionId].obj[__e138.id][level.missions[self.missionId].attackTeam]="pickup";
__e138.taken=undefined;
__e138 thread bePickupItem(origin,angles);
__c139=att.size;for(__i139=0;__i139<__c139;__i139++)
{
att[__i139] objOnCompass(__e138.id,origin,"pickup");
}__i139=undefined;__c139=undefined;
}
}__i138=undefined;__c138=undefined;__v138=undefined;
}




mission_goto(id)
{

if(randomInt(2))
level.missions[id].attackTeam="allies";
else
 level.missions[id].attackTeam="axis";

m=level.missions[id];
level.missions[id].defendTeam=level.enemy[m.attackTeam];


att=level.teams[m.team[m.attackTeam]];
def=level.teams[m.team[m.defendTeam]];


attOrigin=averagePos(att);
defOrigin=averagePos(def);
pnt=level.gotoPoints[0];
dis=-1;
__v140=level.gotoPoints;__c140=__v140.size;for(__i140=0;__i140<__c140;__i140++)
{
__e140=__v140[__i140];if(!isDefined(__e140.occupied))
{
defDist=distanceSquared(defOrigin,__e140.origin);
attDist=distanceSquared(attOrigin,__e140.origin);
newDis=abs(defDist-attDist);
if(dis==-1||newDis<dis)
{
pnt=__e140;
dis=newDis;
}
}
}__i140=undefined;__c140=undefined;__v140=undefined;



if(dis==-1)
{
level.missions[id].currentStage--;
thread newObj(id);
return;
}

pnt.occupied=true;
points=pnt.points;
pointc=points.size;
for(i=0;i<pointc;i++)
{
__e141=points[i];__e141.id=i;
__e141.missionId=id;
__e141 thread beGotoPoint();
level.missions[id].obj[i]["pos"]=__e141;
level.missions[id].obj[i][m.defendTeam]="defend";
level.missions[id].obj[i][m.attackTeam]="capture";
}i=undefined;


level.missions[id].maxTime=120*pointc;
level.missions[id].captureTime=5;
timeString=leftTimeToString(m.maxTime,"noh");


__v142=m.all;__c142=m.allCount;for(__i142=0;__i142<__c142;__i142++)
{
__v142[__i142].objIcons=[];
__v142[__i142] setClientDvars(
"counter1","0/"+pointc,
"counter1text","CAPTURED_POINTS",
"timeleft",timeString,
"mission_title","DISPATCH",
"mission_desc","GOTO"
);
}__i142=undefined;__c142=undefined;__v142=undefined;


__c143=att.size;for(__i143=0;__i143<__c143;__i143++)
{
__e143=att[__i143];for(j=0;j<pointc;j++)
{
__e143 objOnCompass(j,points[j].origin,"capture");
points[j] thread showAll("enemy",__e143);
}j=undefined;
}__i143=undefined;__c143=undefined;
__c145=def.size;for(__i145=0;__i145<__c145;__i145++)
{
__e145=def[__i145];for(j=0;j<pointc;j++)
{
__e145 objOnCompass(j,points[j].origin,"defend");
points[j] thread showAll("friend",__e145);
}j=undefined;
}__i145=undefined;__c145=undefined;

level.missions[id].allItems=points.size;
level.missions[id].captured=0;
level.missions[id].backupFunc=::mission_goto_backup;
level.missions[id].giveupFunc=::mission_goto_giveup;
level.missions[id].timeleft=timeString;
level.missions[id].point=pnt;
level.missions[id].points=points;
thread timeLimit(id,m.maxTime,::mission_goto_timelimit);

updateRespawnMap(id);


thread mission_goto_end(id);
}

mission_goto_end(id)
{
level waittill("endmission"+id,winner,giveup);

level.missions[id].point.occupied=undefined;
__v147=level.missions[id].points;__c147=__v147.size;for(__i147=0;__i147<__c147;__i147++)
{
__e147=__v147[__i147];__v148=__e147.takers;__c148=__v148.size;if(__c148){__k148=getArrayKeys(__v148);for(__i148=0;__i148<__c148;__i148++)
{
__v148[__k148[__i148]] killLoadBar();
}__i148=undefined;__k148=undefined;}__c148=undefined;__v148=undefined;
__e147.takers=undefined;
__e147.curTime=undefined;
__e147.id=undefined;
__e147.missionId=undefined;
__e147 hideAll();
}__i147=undefined;__c147=undefined;__v147=undefined;

if(isDefined(giveup))
endMission(id,winner,"GIVEUP");
else if(winner=="defend")
endMission(id,level.missions[id].defendTeam,"COMPLETE");
else
 thread newObj(id);
}

mission_goto_giveup(id,team)
{
level notify("endmission"+id,team,true);
}

mission_goto_backup()
{
id=self.missionId;
m=level.missions[id];

self.objIcons=[];
__v149=m.points;__c149=__v149.size;for(j=0;j<__c149;j++)
{
__e149=__v149[j];if(!isDefined(self.captured))
{
if(self.team==level.missions[id].defendTeam)
{
__e149[j]thread showAll("friend",self);
self objOnCompass(j,__e149[j].origin,"defend");
}
else
{
__e149[j]thread showAll("enemy",self);
self objOnCompass(j,__e149[j].origin,"capture");
}
}
}j=undefined;__c149=undefined;__v149=undefined;
self setClientDvars(
"timeleft",m.timeleft,
"counter1",level.missions[id].captured+"/"+level.missions[id].allItems,
"counter1text","CAPTURED_POINTS",
"mission_title","DISPATCH",
"mission_desc","GOTO"
);
}











mission_goto_timelimit(id)
{
level endon("endmission"+id);


v=level.missions[id].points;
c=v.size;
for(a=0;a<c;a++){if(v[a].takers.size)break;}
if(a!=c)
{
overtimeMessage(id);

while(true){

v[a]waittill("blocktake");
for(a=0;a<c;a++){if(v[a].takers.size)break;}

if(!(a!=c))break;}
}

level notify("endmission"+id,"defend");
}

beGotoPoint()
{
id=self.missionId;
level endon("endmission"+id);
self endon("captured");

owner=level.missions[id].defendTeam;
self.takers=[];
self.curTime=0;

while(true)
{
self waittill("trigger",player);
if(isDefined(player.missionId)&&player.missionId==id&&isAlive(player)&&(owner!=player.team||self.takers.size))
{
if(owner==player.team)
{
self notify("blocktake");
self.curTime=0;
__v150=self.takers;__c150=__v150.size;__k150=getArrayKeys(__v150);for(__i150=0;__i150<__c150;__i150++)
{
__v150[__k150[__i150]] killLoadBar();
}__i150=undefined;__k150=undefined;__c150=undefined;__v150=undefined;
self.takers=[];
}
else if(!isDefined(self.takers[player.clientid]))
{
if(self.takers.size)
{
self.takers[player.clientid]=player;
player loadBar(self.curTime,id);
}
else
{
br=false;
__v151=level.teams[player.enemyTeam];__c151=__v151.size;for(__i151=0;__i151<__c151;__i151++)
{
if(isAlive(__v151[__i151])&&__v151[__i151] isTouching(self))
{
br=true;
break;
}
}__i151=undefined;__c151=undefined;__v151=undefined;
if(!br)
{
self.takers[player.clientid]=player;
player loadBar(self.curTime,id);
self thread destroying();
}
}
}
}

}
}

destroying()
{
id=self.missionId;
m=level.missions[id];
level endon("endmission"+id);
self endon("blocktake");

self thread startSingleFlashing();
ct=m.captureTime;
while(self.curTime<ct&&self.takers.size)
{
count=self.takers.size;
self.curTime+=0.05*count;
wait 0.05;


__v152=self.takers;keys=getArrayKeys(__v152);for(i=0;i<count;i++)
{
__e152=__v152[keys[i]];if(!isDefined(__e152)||!__e152 isTouching(self)||!isAlive(__e152))
{
if(isDefined(__e152))
{
__e152 killLoadBar();
}
self.takers[keys[i]]=undefined;
}
}i=undefined;keys=undefined;__v152=undefined;

newcount=self.takers.size;
if(self.curTime<ct&&count!=newcount&&newcount)
{
__v153=self.takers;__k153=getArrayKeys(__v153);for(__i153=0;__i153<newcount;__i153++)
{
b=__v153[__k153[__i153]].loadbar;
b setShader("white",int(self.curTime*(100/ct)+0.5),9);
b scaleOverTime((ct-self.curTime)/newcount,100,9);
}__i153=undefined;__k153=undefined;__v153=undefined;
}
}

if(self.takers.size)
{
__v154=self.takers;__c154=__v154.size;__k154=getArrayKeys(__v154);for(__i154=0;__i154<__c154;__i154++)
{
__e154=__v154[__k154[__i154]];__e154 killLoadBar();
__e154 target(1);
}__i154=undefined;__k154=undefined;__c154=undefined;__v154=undefined;
self.takers=[];
self hideAll();
__v155=m.all;__c155=m.allCount;for(__i155=0;__i155<__c155;__i155++)
{
__v155[__i155] destroyObject(self.id);
}__i155=undefined;__c155=undefined;__v155=undefined;


level.missions[id].captured++;
if(m.captured==m.allItems)
{
__v156=m.all;__c156=m.allCount;for(__i156=0;__i156<__c156;__i156++)
{
__v156[__i156] setClientDvars(
"counter1","",
"counter1text",""
);
}__i156=undefined;__c156=undefined;__v156=undefined;
level notify("endmission"+id,"attack");
}
else
{
level.missions[id].obj[self.id]=undefined;
__v157=m.all;__c157=m.allCount;for(__i157=0;__i157<__c157;__i157++)
{
__v157[__i157] setClientDvar("counter1",m.captured+"/"+m.allItems);
}__i157=undefined;__c157=undefined;__v157=undefined;
self notify("captured");
self.captured=true;
}
}
else
{
self.curTime=0;
}

self notify("blocktake");
}




mission_capture(id)
{

m=level.missions[id];
allies=level.teams[m.team["allies"]];
axis=level.teams[m.team["axis"]];


alliesOrigin=averagePos(allies);
axisOrigin=averagePos(axis);
pnt=level.controlPoints[0];
dis=-1;
__v158=level.controlPoints;__c158=__v158.size;for(__i158=0;__i158<__c158;__i158++)
{
__e158=__v158[__i158];if(!isDefined(__e158.occupied))
{
alliesDist=distanceSquared(alliesOrigin,__e158.origin);
axisDist=distanceSquared(axisOrigin,__e158.origin);
newDis=abs(alliesDist-axisDist);
if(dis==-1||newDis<dis)
{
pnt=__e158;
dis=newDis;
}
}
}__i158=undefined;__c158=undefined;__v158=undefined;



if(dis==-1)
{
level.missions[id].currentStage--;
thread newObj(id);
return;
}


pnt.occupied=true;
points=pnt.points;
pointc=points.size;
for(i=0;i<pointc;i++)
{
__e159=points[i];__e159.id=i;
__e159.missionId=id;
__e159 thread beCapturePoint();
level.missions[id].obj[i]["pos"]=__e159;
level.missions[id].obj[i]["allies"]="free";
level.missions[id].obj[i]["axis"]="free";
}i=undefined;


level.missions[id].maxTime=120*pointc;
level.missions[id].captureTime=5;
timeString=leftTimeToString(m.maxTime,"noh");


__v160=level.missions[id].all;__c160=level.missions[id].allCount;for(__i160=0;__i160<__c160;__i160++)
{
__e160=__v160[__i160];__e160.objIcons=[];
for(j=0;j<pointc;j++)
{
__e160 objOnCompass(j,points[j].origin,"free");
points[j] thread showAll("none",__e160);
}j=undefined;
__e160 setClientDvars(
"line1",0,
"line2",0,
"line1_max",100,
"line2_max",100,
"timeleft",timeString,
"mission_title","TERRITORY",
"mission_desc","TERRITORY"
);
}__i160=undefined;__c160=undefined;__v160=undefined;
level.missions[id].score["allies"]=0;
level.missions[id].score["axis"]=0;
level.missions[id].backupFunc=::mission_capture_backup;
level.missions[id].giveupFunc=::mission_capture_giveup;
level.missions[id].timeleft=timeString;
level.missions[id].point=pnt;
level.missions[id].points=points;
thread timeLimit(id,m.maxTime,::mission_capture_timelimit);

updateRespawnMap(id);


thread mission_capture_end(id);
}

mission_capture_end(id)
{
level waittill("endmission"+id,winner,type);

level.missions[id].point.occupied=undefined;
__v162=level.missions[id].points;__c162=__v162.size;for(__i162=0;__i162<__c162;__i162++)
{
__e162=__v162[__i162];__v163=__e162.takers;__c163=__v163.size;if(__c163){__k163=getArrayKeys(__v163);for(__i163=0;__i163<__c163;__i163++)
{
__v163[__k163[__i163]] killLoadBar();
}__i163=undefined;__k163=undefined;}__c163=undefined;__v163=undefined;
__e162.takers=undefined;
__e162.owner=undefined;
__e162.taker=undefined;
__e162.curTime=undefined;
__e162.id=undefined;
__e162.missionId=undefined;
__e162 hideAll();
}__i162=undefined;__c162=undefined;__v162=undefined;


if(!isDefined(type))
type="COMPLETE";

endMission(id,winner,type);
}

mission_capture_giveup(id,team)
{
level notify("endmission"+id,team,"GIVEUP");
}

mission_capture_timelimit(id)
{
level endon("endmission"+id);


owned["allies"]=0;
owned["axis"]=0;
owned["none"]=0;
__v164=level.missions[id].points;__c164=__v164.size;for(__i164=0;__i164<__c164;__i164++)
{
owned[__v164[__i164].owner]++;
}__i164=undefined;__c164=undefined;__v164=undefined;

if(owned["allies"]!=owned["axis"])
{
if(owned["allies"]>owned["axis"])
owner="allies";
else
 owner="axis";

if(level.missions[id].score[owner]<=level.missions[id].score[level.enemy[owner]])
{
overtimeMessage(id);

while(owned[owner]>owned[level.enemy[owner]])
{
level waittill("captured"+id,old,new);
owned[old]--;
owned[new]++;
}
}
}

if(level.missions[id].score["allies"]>level.missions[id].score["axis"])
level notify("endmission"+id,"allies");
else if(level.missions[id].score["allies"]<level.missions[id].score["axis"])
level notify("endmission"+id,"axis");
else
 level notify("endmission"+id,"allies","TIED");
}

mission_capture_backup()
{
friend=self.team;
enemy=level.enemy[self.team];
m=level.missions[self.missionId];

self.objIcons=[];
__v165=m.points;__c165=__v165.size;for(j=0;j<__c165;j++)
{
__e165=__v165[j];if(__e165.owner==friend)
{
__e165 thread showAll("friend",self);
self objOnCompass(j,__e165.origin,"defend");
}
else if(__e165.owner==enemy)
{
__e165 thread showAll("enemy",self);
self objOnCompass(j,__e165.origin,"capture");
}
else
{
__e165 thread showAll("none",self);
self objOnCompass(j,__e165.origin,"free");
}
}j=undefined;__c165=undefined;__v165=undefined;
self setClientDvars(
"line1",m.score[friend],
"line2",m.score[enemy],
"line1_max",100,
"line2_max",100,
"timeleft",m.timeleft,
"mission_title","TERRITORY",
"mission_desc","TERRITORY"
);
}

beCapturePoint()
{
id=self.missionId;
level endon("endmission"+id);

self.owner="none";
self.takers=[];
self.taker="none";
self.curTime=0;

while(true)
{
self waittill("trigger",player);
if(isDefined(player.missionId)&&player.missionId==id&&isAlive(player)&&!isDefined(player.claimed))
{
if(self.owner!=player.team||self.taker!=player.team)
{
if(self.taker!=player.team&&self.taker!=self.owner)
{
self notify("blocktake");
self.curTime=0;
self.taker=self.owner;
__v166=self.takers;__c166=__v166.size;if(__c166){__k166=getArrayKeys(__v166);for(__i166=0;__i166<__c166;__i166++)
{
__v166[__k166[__i166]] killLoadBar();
}__i166=undefined;__k166=undefined;}__c166=undefined;__v166=undefined;
self.takers=[];
}
else if(!isDefined(self.takers[player.clientid]))
{
if(self.taker==player.team)
{
self.takers[player.clientid]=player;
player loadBar(self.curTime,self.missionId);
}
else
{
br=false;
__v167=level.teams[player.enemyTeam];__c167=__v167.size;for(__i167=0;__i167<__c167;__i167++)
{
if(isAlive(__v167[__i167])&&__v167[__i167] isTouching(self))
{
br=true;
break;
}
}__i167=undefined;__c167=undefined;__v167=undefined;
if(!br)
{
self.taker=player.team;
self.takers[player.clientid]=player;
player loadBar(self.curTime,id);
self thread capturing(player.missionTeam,player.enemyTeam);
}
}
}
}
}
}
}

capturing(friendTeam,enemyTeam)
{
id=self.missionId;
level endon("endmission"+id);
self endon("blocktake");

captureTime=level.missions[id].captureTime;
self thread startFlashing();
while(self.curTime<captureTime&&self.takers.size)
{
count=self.takers.size;
self.curTime+=0.05*count;
wait 0.05;

__v168=self.takers;keys=getArrayKeys(__v168);for(i=0;i<count;i++)
{
__e168=__v168[keys[i]];if(!isDefined(__e168)||!isAlive(__e168)||isDefined(__e168.claimed)||!(__e168 isTouching(self)))
{
if(isDefined(__e168))
{
__e168 killLoadBar();
}
self.takers[keys[i]]=undefined;
}
}i=undefined;keys=undefined;__v168=undefined;

newcount=self.takers.size;
if(self.curTime<captureTime&&count!=newcount&&newcount)
{
__v169=self.takers;__k169=getArrayKeys(__v169);for(__i169=0;__i169<newcount;__i169++)
{
b=__v169[__k169[__i169]].loadbar;
b setShader("white",int(self.curTime*(100/captureTime)+0.5),9);
b scaleOverTime((captureTime-self.curTime)/newcount,100,9);
}__i169=undefined;__k169=undefined;__v169=undefined;
}
}

self.curTime=0;
if(self.takers.size)
{
keys=getArrayKeys(self.takers);

level.missions[id].obj[self.id][self.takers[keys[0]].team]="defend";
level.missions[id].obj[self.id][level.enemy[self.takers[keys[0]].team]]="capture";

oldowner=self.owner;
if(self.owner=="none")
{
self.owner=self.taker;
__c170=keys.size;for(__i170=0;__i170<__c170;__i170++)
{
self.takers[keys[__i170]]killLoadBar();
self.takers[keys[__i170]]target(1);
}__i170=undefined;__c170=undefined;
self.takers=[];
self thread watchCP();
}
else
{
self.owner="none";
__c171=keys.size;for(__i171=0;__i171<__c171;__i171++)
{
self.takers[keys[__i171]].loadbar setShader("white",0,9);
self.takers[keys[__i171]].loadbar scaleOverTime(captureTime,100,9);
}__i171=undefined;__c171=undefined;
self thread capturing(friendTeam,enemyTeam);
}

self hideAll();
__v172=level.teams[friendTeam];__c172=__v172.size;for(__i172=0;__i172<__c172;__i172++)
{
__e172=__v172[__i172];if(self.owner=="none")
{
self thread showAll("none",__e172);
__e172 objOnCompass(self.id,self.origin,"free");
}
else
{
self thread showAll("friend",__e172);
__e172 objOnCompass(self.id,self.origin,"defend");
}
}__i172=undefined;__c172=undefined;__v172=undefined;
__v173=level.teams[enemyTeam];__c173=__v173.size;for(__i173=0;__i173<__c173;__i173++)
{
__e173=__v173[__i173];if(self.owner=="none")
{
self thread showAll("none",__e173);
__e173 objOnCompass(self.id,self.origin,"free");
}
else
{
self thread showAll("enemy",__e173);
__e173 objOnCompass(self.id,self.origin,"capture");
}
}__i173=undefined;__c173=undefined;__v173=undefined;
level notify("captured"+id,oldowner,self.owner);
}
else
{
self.taker=self.owner;
}
}

watchCP()
{
id=self.missionId;
level endon("endmission"+id);

owner=self.owner;
wait 3;
while(self.owner==owner)
{
level.missions[id].score[self.owner]++;
if(level.missions[id].score[self.owner]==100)
{
level notify("endmission"+id,self.owner);
return;
}
__v174=level.teams[level.missions[id].team[self.owner]];__c174=__v174.size;for(__i174=0;__i174<__c174;__i174++)
{
__v174[__i174] setClientDvar("line1",level.missions[id].score[self.owner]);
}__i174=undefined;__c174=undefined;__v174=undefined;
__v175=level.teams[level.missions[id].team[level.enemy[self.owner]]];__c175=__v175.size;for(__i175=0;__i175<__c175;__i175++)
{
__v175[__i175] setClientDvar("line2",level.missions[id].score[self.owner]);
}__i175=undefined;__c175=undefined;__v175=undefined;
wait 3;
}
}




mission_dm(id)
{
m=level.missions[id];
allies=level.teams[m.team["allies"]];
axis=level.teams[m.team["axis"]];
alliessize=allies.size;
axissize=axis.size;


level.missions[id].lives=alliessize+axissize;


level.missions[id].maxTime=420;
timeString=leftTimeToString(m.maxTime,"noh");

for(i=0;i<axissize;i++)
{
__e176=axis[i];for(j=0;j<alliessize;j++)
{
__e176 newMissionPoint("kill"+j,allies[j],"kill");
allies[j] newMissionPoint("kill"+i,__e176,"kill");
}j=undefined;
}i=undefined;


__v178=m.all;__c178=level.missions[id].allCount;for(__i178=0;__i178<__c178;__i178++)
{
__e178=__v178[__i178];__e178.objIcons=[];
__e178 setClientDvars(
"line1",0,
"line2",0,
"line1_max",m.lives,
"line2_max",m.lives,
"timeleft",timeString,
"mission_title","DM",
"mission_desc","DM"
);

__e178 thread watchDMDie();

}__i178=undefined;__c178=undefined;__v178=undefined;
level.missions[id].score["allies"]=0;
level.missions[id].score["axis"]=0;
level.missions[id].backupFunc=::mission_dm_backup;
level.missions[id].giveupFunc=::mission_dm_giveup;
level.missions[id].dm=true;
level.missions[id].timeleft=timeString;
thread timeLimit(id,m.maxTime,::mission_dm_timelimit);

updateRespawnMap(id);


thread mission_dm_end(id);
}

mission_dm_end(id)
{
level waittill("endmission"+id,winner,type);

if(!isDefined(type))
type="COMPLETE";

endMission(id,winner,type);
}

mission_dm_giveup(id,team)
{
level notify("endmission"+id,team,"GIVEUP");
}

mission_dm_timelimit(id)
{
if(level.missions[id].score["allies"]>level.missions[id].score["axis"])
level notify("endmission"+id,"allies");
else if(level.missions[id].score["allies"]<level.missions[id].score["axis"])
level notify("endmission"+id,"axis");
else
 level notify("endmission"+id,"allies","TIED");
}

mission_dm_backup()
{
m=level.missions[self.missionId];
self.objIcons=[];
self setClientDvars(
"line1",m.score[self.team],
"line2",m.score[level.enemy[self.team]],
"line1_max",m.lives,
"line2_max",m.lives,
"timeleft",m.timeleft,
"mission_title","DM",
"mission_desc","DM"
);
}

watchDMDie()
{
self endon("disconnect");
self endon("endmission");


id=self.missionId;
m=level.missions[id];
friend=self.team;
enemy=level.enemy[friend];
while(true)
{
self waittill("killed_player");
level.missions[id].score[enemy]++;
if(m.score[enemy]==m.lives)
{
level notify("endmission"+id,enemy);
}
else
{
__v179=level.teams[self.enemyTeam];__c179=__v179.size;for(__i179=0;__i179<__c179;__i179++)
{
__v179[__i179] setClientDvars(
"line1",m.score[enemy],
"line2",m.score[friend]
);
}__i179=undefined;__c179=undefined;__v179=undefined;
__v180=level.teams[self.missionTeam];__c180=__v180.size;for(__i180=0;__i180<__c180;__i180++)
{
__v180[__i180] setClientDvars(
"line1",m.score[friend],
"line2",m.score[enemy]
);
}__i180=undefined;__c180=undefined;__v180=undefined;
}
}
}











mission_sideddm(id)
{
m=level.missions[id];
allies=level.teams[m.team["allies"]];
axis=level.teams[m.team["axis"]];
alliessize=allies.size;
axissize=axis.size;


level.missions[id].lives=alliessize+axissize;


level.missions[id].maxTime=420;
timeString=leftTimeToString(m.maxTime,"noh");


for(i=0;i<axissize;i++)
{
__e181=axis[i];for(j=0;j<alliessize;j++)
{
__e181 newMissionPoint("kill"+j,allies[j],"kill");
allies[j] newMissionPoint("kill"+i,__e181,"kill");
}j=undefined;
}i=undefined;
__v183=m.all;__c183=level.missions[id].allCount;for(__i183=0;__i183<__c183;__i183++)
{
__e183=__v183[__i183];__e183.objIcons=[];
__e183 setClientDvars(
"side",m.lives,
"side_max",m.lives*2,
"timeleft",timeString,
"mission_title","DM",
"mission_desc","DM"
);

__e183 thread watchSidedDMDie();

}__i183=undefined;__c183=undefined;__v183=undefined;
level.missions[id].score["allies"]=0;
level.missions[id].score["axis"]=0;
level.missions[id].backupFunc=::mission_sideddm_backup;
level.missions[id].giveupFunc=::mission_sideddm_giveup;
level.missions[id].dm=true;
level.missions[id].timeleft=timeString;
thread timeLimit(id,m.maxTime,::mission_sideddm_timelimit);

updateRespawnMap(id);


thread mission_sideddm_end(id);
}

mission_sideddm_end(id)
{
level waittill("endmission"+id,winner,type);

if(!isDefined(type))
type="COMPLETE";

endMission(id,winner,type);
}

mission_sideddm_giveup(id,team)
{
level notify("endmission"+id,team,"GIVEUP");
}

mission_sideddm_timelimit(id)
{
if(level.missions[id].score["allies"]>level.missions[id].score["axis"])
level notify("endmission"+id,"allies");
else if(level.missions[id].score["allies"]<level.missions[id].score["axis"])
level notify("endmission"+id,"axis");
else
 level notify("endmission"+id,"allies","TIED");
}

mission_sideddm_backup()
{
m=level.missions[self.missionId];
self.objIcons=[];
self setClientDvars(
"side",m.lives+(m.score[self.team]-m.score[level.enemy[self.team]]),
"side_max",m.lives*2,
"timeleft",m.timeleft,
"mission_title","DM",
"mission_desc","DM"
);
}

watchSidedDMDie()
{
self endon("disconnect");
self endon("endmission");


friend=self.team;
enemy=level.enemy[friend];
id=self.missionId;
m=level.missions[id];
while(true)
{
self waittill("killed_player");
level.missions[id].score[enemy]++;
dif=m.score[enemy]-m.score[friend];
if(dif==m.lives)
{
level notify("endmission"+self.missionId,enemy);
}
else
{
c=m.lives+dif;
__v184=level.teams[self.enemyTeam];__c184=__v184.size;for(__i184=0;__i184<__c184;__i184++)
{
__v184[__i184] setClientDvar("side",c);
}__i184=undefined;__c184=undefined;__v184=undefined;
c=m.lives+dif*-1;
__v185=level.teams[self.missionTeam];__c185=__v185.size;for(__i185=0;__i185<__c185;__i185++)
{
__v185[__i185] setClientDvar("side",c);
}__i185=undefined;__c185=undefined;__v185=undefined;
}
}
}











mission_vip(id)
{

if(randomInt(2))
level.missions[id].attackTeam="allies";
else
 level.missions[id].attackTeam="axis";

m=level.missions[id];
level.missions[id].defendTeam=level.enemy[m.attackTeam];

def=level.teams[m.team[m.defendTeam]];
att=level.teams[m.team[m.attackTeam]];


level.missions[id].vipLives=3+int(att.size/2);
level.missions[id].attackerLives=m.vipLives*3;


level.missions[id].maxTime=180+att.size*30;
timeString=leftTimeToString(m.maxTime,"noh");


defsize=def.size;
for(__i186=0;__i186<defsize;__i186++)
{
__e186=def[__i186];if(isDefined(__e186.teamleader))
{
level.missions[id].vip=__e186;
level.missions[id].obj[0]["pos"]=__e186;
level.missions[id].obj[0][m.attackTeam]="enemyvip";
level.missions[id].obj[0][m.defendTeam]="vip";
break;
}
}__i186=undefined;
level.missions[id].vip.vip=true;
level.missions[id].vip thread boldLine(level.s["YOU_ARE_VIP_"+m.vip.lang]+"!");
level.missions[id].vip thread watchVIPDie();
level.missions[id].vip thread watchVIPDisconnect();

__c187=att.size;for(__i187=0;__i187<__c187;__i187++)
{
att[__i187] newMissionPoint("enemyvip",m.vip,"vip");
att[__i187] thread watchVIPAttDie();
}__i187=undefined;__c187=undefined;
for(__i188=0;__i188<defsize;__i188++)
{
if(def[__i188]!=m.vip)
{
def[__i188] newMissionPoint("vip",m.vip,"vip");
}
}__i188=undefined;


__v189=m.all;__c189=m.allCount;for(__i189=0;__i189<__c189;__i189++)
{
__v189[__i189].objIcons=[];
__v189[__i189] setClientDvars(
"counter1",m.vipLives,
"counter1text","VIP_LIVES",
"counter2",m.attackerLives,
"counter2text","ATTACKER_LIVES",
"timeleft",timeString,
"mission_title","VIP",
"mission_desc","VIP"
);
}__i189=undefined;__c189=undefined;__v189=undefined;
level.missions[id].backupFunc=::mission_vip_backup;
level.missions[id].giveupFunc=::mission_vip_giveup;
level.missions[id].timeleft=timeString;
thread timeLimit(id,m.maxTime,::mission_vip_timelimit);

updateRespawnMap(id);


thread mission_vip_end(id);
}

mission_vip_end(id)
{
level waittill("endmission"+id,winner,giveup);

if(isDefined(giveup))
type="GIVEUP";
else
 type="COMPLETE";

endMission(id,winner,type);
}

mission_vip_giveup(id,team)
{
level notify("endmission"+id,team,true);
}

mission_vip_timelimit(id)
{
level notify("endmission"+id,level.missions[id].defendTeam);
}

mission_vip_backup()
{
m=level.missions[self.missionId];

self.objIcons=[];
self setClientDvars(
"counter1",m.vipLives,
"counter1text","VIP_LIVES",
"counter2",m.attackerLives,
"counter2text","ATTACKER_LIVES",
"timeleft",m.timeleft,
"mission_title","VIP",
"mission_desc","VIP"
);
if(self.team==m.defendTeam)
{
self newMissionPoint("vip",m.vip,"vip");
}
else
{
self newMissionPoint("enemyvip",m.vip,"vip");
self thread watchVIPAttDie();
}
}

watchVIPDie()
{
self endon("disconnect");
self endon("endmission");


id=self.missionId;
m=level.missions[id];
while(true)
{
self waittill("killed_player");
level.missions[id].vipLives--;
if(!m.vipLives)
{
level notify("endmission"+id,level.enemy[self.team]);
}
else
{
__v190=m.all;__c190=m.allCount;for(__i190=0;__i190<__c190;__i190++)
{
__v190[__i190] setClientDvar("counter1",m.vipLives);
}__i190=undefined;__c190=undefined;__v190=undefined;
}
}
}

watchVIPAttDie()
{
self endon("disconnect");
self endon("endmission");


id=self.missionId;
m=level.missions[id];
while(true)
{
self waittill("killed_player");
level.missions[id].attackerLives--;
if(!m.attackerLives)
{
level notify("endmission"+id,level.enemy[self.team]);
}
else
{
__v191=m.all;__c191=m.allCount;for(__i191=0;__i191<__c191;__i191++)
{
__v191[__i191] setClientDvar("counter2",m.attackerLives);
}__i191=undefined;__c191=undefined;__v191=undefined;
}
}
}

watchVIPDisconnect()
{
self endon("endmission");
self waittill("disconnect");
[[level.missions[self.missionId].giveupFunc]](self.missionId,level.enemy[self.team]);
}




mission_hold(id)
{

m=level.missions[id];
allies=level.teams[m.team["allies"]];
axis=level.teams[m.team["axis"]];


alliesOrigin=averagePos(allies);
axisOrigin=averagePos(axis);
pnt=level.holdPoints[0];
dis=-1;
__v192=level.holdPoints;__c192=__v192.size;for(__i192=0;__i192<__c192;__i192++)
{
__e192=__v192[__i192];if(!isDefined(__e192.occupied))
{
alliesDist=distanceSquared(alliesOrigin,__e192.origin);
axisDist=distanceSquared(axisOrigin,__e192.origin);
newDis=abs(alliesDist-axisDist);
if(dis==-1||newDis<dis)
{
pnt=__e192;
dis=newDis;
}
}
}__i192=undefined;__c192=undefined;__v192=undefined;



if(dis==-1)
{
level.missions[id].currentStage--;
thread newObj(id);
return;
}


pnt.occupied=true;
pnt.owner="none";
pnt.missionId=id;
pnt thread beHoldItem();
level.missions[id].obj[0]["pos"]=pnt;
level.missions[id].obj[0]["allies"]="pickup";
level.missions[id].obj[0]["axis"]="pickup";


level.missions[id].maxTime=420;
timeString=leftTimeToString(m.maxTime,"noh");


__v193=m.all;__c193=m.allCount;for(__i193=0;__i193<__c193;__i193++)
{
__e193=__v193[__i193];__e193.objIcons=[];
__e193 objOnCompass(0,pnt.origin,"pickup");
__e193 setClientDvars(
"line1",0,
"line2",0,
"line1_max",100,
"line2_max",100,
"timeleft",timeString,
"mission_title","HOLD",
"mission_desc","HOLD"
);
}__i193=undefined;__c193=undefined;__v193=undefined;

level.missions[id].score["allies"]=0;
level.missions[id].score["axis"]=0;
level.missions[id].backupFunc=::mission_hold_backup;
level.missions[id].giveupFunc=::mission_hold_giveup;
level.missions[id].timeleft=timeString;
level.missions[id].item=pnt;
thread timeLimit(id,m.maxTime,::mission_hold_timelimit);

updateRespawnMap(id);


thread mission_hold_end(id);
}

mission_hold_end(id)
{
level waittill("endmission"+id,winner,type);

m=level.missions[id];
__v194=m.all;__c194=m.allCount;for(__i194=0;__i194<__c194;__i194++)
{
__v194[__i194].objects=undefined;
__v194[__i194] setClientDvar("items",0);
}__i194=undefined;__c194=undefined;__v194=undefined;


if(!isDefined(m.item.taken))
{
m.item.obj delete();
m.item.trigger delete();
}
else
{
m.item.taken.dump=undefined;
}
m.item.owner=undefined;
m.item.taken=undefined;
m.item.occupied=undefined;
m.item.missionId=undefined;

if(!isDefined(type))
type="COMPLETE";

endMission(id,winner,"COMPLETE");
}

mission_hold_giveup(id,team)
{
level notify("endmission"+id,team,"GIVEUP");
}

mission_hold_backup()
{
m=level.missions[self.missionId];

if(isDefined(m.item.taken))
{
if(m.item.taken.team==self.team)
{
self newMissionPoint("follow0",m.item.taken,"obj");
}
else
{
self newMissionPoint("kill0",m.item.taken,"obj");
}
}
else if(m.item.owner==self.team)
{
self objOnCompass(0,m.item.origin,"defend");
}
else
{
self objOnCompass(0,m.item.origin,"pickup");
}

self setClientDvars(
"line1",m.score[self.team],
"line2",m.score[level.enemy[self.team]],
"line1_max",100,
"line2_max",100,
"timeleft",m.timeleft,
"mission_title","HOLD",
"mission_desc","HOLD"
);
}

mission_hold_timelimit(id)
{
level endon("endmission"+id);


m=level.missions[id];
if(m.score["allies"]!=m.score["axis"])
{
owner=m.item.owner;
if(m.score[owner]<m.score[level.enemy[owner]])
{
overtimeMessage(id);

while(true){
level.missions[id].item waittill("change");
if(!(owner==m.item.owner&&m.score[owner]<=m.score[level.enemy[owner]]))break;}
}
}

if(m.score["allies"]>m.score["axis"])
level notify("endmission"+id,"allies");
else if(m.score["allies"]<m.score["axis"])
level notify("endmission"+id,"axis");
else
 level notify("endmission"+id,"allies","TIED");
}

beHoldItem(origin,angles)
{
if(!isDefined(origin))
origin=self.origin;
if(!isDefined(angles))
angles=self.angles;

origin+=(0,0,1.25);
self.obj=spawn("script_model",origin);
self.obj setModel("com_golden_brick");
self.obj.angles=angles;
self.trigger=spawn("trigger_radius",origin,0,16,16);

id=self.missionId;
while(isDefined(self.trigger))
{
self.trigger waittill("trigger",player);
if(isDefined(player.missionId)&&player.missionId==id&&player useButtonPressed()&&!isDefined(player.claimed))
{

player.dump["primary"]["clip"]=player getWeaponAmmoClip(player.primaryWeapon);
player.dump["primary"]["stock"]=player getWeaponAmmoStock(player.primaryWeapon);
player.dump["secondary"]["clip"]=player getWeaponAmmoClip(player.secondaryWeapon);
player.dump["secondary"]["stock"]=player getWeaponAmmoStock(player.secondaryWeapon);
player.dump["offhand"]=player getWeaponAmmoClip(player.offhandWeapon);
player.dump["current"]=player.currentWeapon;
player takeAllWeapons();
player setClientDvar("weapinfo_offhand",0);
player giveWeapon(level.holdItem);
player switchToWeapon(level.holdItem);
player attach("com_golden_brick","tag_inhand",true);
player.objects=true;
player setClientDvar("items",1);




player thread watchLoseObject();
player thread watchDropObject();
player thread watchLoseObjectStun();
player thread watchLoseObjectDisconnect();

if(self.owner!=player.team)
self thread countHoldTime();

self.obj delete();
self.trigger delete();
self.taken=player;
self.owner=player.team;

__v195=level.teams[level.missions[id].team[player.team]];__c195=__v195.size;for(__i195=0;__i195<__c195;__i195++)
{
__e195=__v195[__i195];__e195 destroyObject(0);

if(__e195!=player)
__e195 newMissionPoint("follow0",player,"obj");
}__i195=undefined;__c195=undefined;__v195=undefined;
__v196=level.teams[level.missions[id].team[level.enemy[player.team]]];__c196=__v196.size;for(__i196=0;__i196<__c196;__i196++)
{
__v196[__i196] destroyObject(0);
__v196[__i196] newMissionPoint("kill0",player,"obj");
}__i196=undefined;__c196=undefined;__v196=undefined;
}
}
}

countHoldTime()
{
id=self.missionId;
m=level.missions[id];

self notify("counttime");
self endon("counttime");
level endon("endmission"+id);

while(true)
{
wait 2.5;
level.missions[id].score[self.owner]++;
if(m.score[self.owner]==100)
{
level notify("endmission"+id,self.owner);
}
else
{
__v197=level.teams[m.team[self.owner]];__c197=__v197.size;if(__c197){for(__i197=0;__i197<__c197;__i197++)
{
__v197[__i197] setClientDvar("line1",m.score[self.owner]);
}__i197=undefined;}__c197=undefined;__v197=undefined;
__v198=level.teams[m.team[level.enemy[self.owner]]];__c198=__v198.size;if(__c198){for(__i198=0;__i198<__c198;__i198++)
{
__v198[__i198] setClientDvar("line2",m.score[self.owner]);
}__i198=undefined;}__c198=undefined;__v198=undefined;
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

self waittill("disconnect",origin,angles);
self thread dropObject(origin,angles);
}

watchDropObject()
{

self endon("putitem");
self endon("endmission");

while(true)
{
wait 0.1;
if(self attackButtonPressed())
{
self takeWeapon(level.holdItem);
self giveWeapon(self.primaryWeapon,self.weapons[self.wID[self.info["prime"]]]["camo"]);
self giveWeapon(self.secondaryWeapon);
self giveWeapon(self.offhandWeapon);
self setWeaponAmmoClip(self.primaryWeapon,self.dump["primary"]["clip"]);
self setWeaponAmmoStock(self.primaryWeapon,self.dump["primary"]["stock"]);
self setWeaponAmmoClip(self.secondaryWeapon,self.dump["secondary"]["clip"]);
self setWeaponAmmoStock(self.secondaryWeapon,self.dump["secondary"]["stock"]);
self setWeaponAmmoClip(self.offhandWeapon,self.dump["offhand"]);
self setClientDvar("weapinfo_offhand",self.dump["offhand"]);
self.currentWeapon=self.dump["current"];

if(self.dump["current"]!="none")
self switchToWeapon(self.dump["current"]);

self detach("com_golden_brick","tag_inhand");
self thread dropObject();
}
}
}

dropObject(origin,angles)
{
self notify("putitem");


if(isPlayer(self))
{
self setClientDvar("items",0);
self.objects=undefined;
self.dump=undefined;

origin=self.origin;
angles=self.angles;
}

origin=playerPhysicsTrace(origin,origin-(0,0,10000));

m=level.missions[self.missionId];
m.item.taken=undefined;
m.item thread beHoldItem(origin,angles);




__v199=level.teams[m.team[self.team]];__c199=__v199.size;for(__i199=0;__i199<__c199;__i199++)
{
__v199[__i199] objOnCompass(0,origin,"defend");
}__i199=undefined;__c199=undefined;__v199=undefined;
__v200=level.teams[m.team[level.enemy[self.team]]];__c200=__v200.size;for(__i200=0;__i200<__c200;__i200++)
{
__v200[__i200] objOnCompass(0,origin,"pickup");
}__i200=undefined;__c200=undefined;__v200=undefined;
}




mission_drop(id)
{

m=level.missions[id];
allies=level.teams[m.team["allies"]];
axis=level.teams[m.team["axis"]];


alliesOrigin=averagePos(allies);
axisOrigin=averagePos(axis);
pnt=level.dropPoints[0];
dis=-1;
__v201=level.dropPoints;__c201=__v201.size;for(__i201=0;__i201<__c201;__i201++)
{
__e201=__v201[__i201];if(!isDefined(__e201.occupied))
{
alliesDist=distanceSquared(alliesOrigin,__e201.origin);
axisDist=distanceSquared(axisOrigin,__e201.origin);
newDis=abs(alliesDist-axisDist);
if(dis==-1||newDis<dis)
{
pnt=__e201;
dis=newDis;
}
}
}__i201=undefined;__c201=undefined;__v201=undefined;



if(dis==-1)
{
level.missions[id].currentStage--;
thread newObj(id);
return;
}


r=randomInt(2);
dropPoints["allies"]=pnt.points[r];
if(r)
dropPoints["axis"]=pnt.points[0];
else
 dropPoints["axis"]=pnt.points[1];

pnt.occupied=true;
pnt.missionId=id;
pnt.id=2;
pnt thread beDropItem();
dropPoints["allies"].id=1;
dropPoints["allies"].missionId=id;
dropPoints["allies"]thread beDropPoint();
dropPoints["axis"].id=2;
dropPoints["axis"].missionId=id;
dropPoints["axis"]thread beDropPoint();
level.missions[id].obj[0]["pos"]=pnt;
level.missions[id].obj[0]["allies"]="pickup";
level.missions[id].obj[0]["axis"]="pickup";
level.missions[id].obj[1]["pos"]=dropPoints["allies"];
level.missions[id].obj[1]["allies"]="drop";
level.missions[id].obj[1]["axis"]="enemydrop";
level.missions[id].obj[2]["pos"]=dropPoints["axis"];
level.missions[id].obj[2]["allies"]="enemydrop";
level.missions[id].obj[2]["axis"]="drop";


level.missions[id].maxTime=500;
level.missions[id].captureTime=5;
timeString=leftTimeToString(m.maxTime,"noh");


__v202=m.all;__c202=m.allCount;for(__i202=0;__i202<__c202;__i202++)
{
__e202=__v202[__i202];__e202.objects=false;
__e202.objIcons=[];
__e202 setClientDvars(
"timeleft",timeString,
"mission_title","DROP",
"mission_desc","DROP",
"items",0
);
}__i202=undefined;__c202=undefined;__v202=undefined;


__c203=allies.size;for(__i203=0;__i203<__c203;__i203++)
{
__e203=allies[__i203];__e203 objOnCompass(0,dropPoints["allies"].origin,"drop");
__e203 objOnCompass(1,dropPoints["axis"].origin,"enemydrop");
__e203 objOnCompass(2,pnt.origin,"pickup");
dropPoints["allies"]thread showAll("enemy",__e203);
dropPoints["axis"]thread showAll("friend",__e203);
}__i203=undefined;__c203=undefined;
__c204=axis.size;for(__i204=0;__i204<__c204;__i204++)
{
__e204=axis[__i204];__e204 objOnCompass(0,dropPoints["allies"].origin,"enemydrop");
__e204 objOnCompass(1,dropPoints["axis"].origin,"drop");
__e204 objOnCompass(2,pnt.origin,"pickup");
dropPoints["axis"]thread showAll("enemy",__e204);
dropPoints["allies"]thread showAll("friend",__e204);
}__i204=undefined;__c204=undefined;

level.missions[id].backupFunc=::mission_drop_backup;
level.missions[id].giveupFunc=::mission_drop_giveup;
level.missions[id].timeleft=timeString;
level.missions[id].points=dropPoints;
level.missions[id].point=pnt;
thread timeLimit(id,m.maxTime,::mission_drop_timelimit);

updateRespawnMap(id);


thread mission_drop_end(id);
}

mission_drop_end(id)
{
level waittill("endmission"+id,winner,type);


level.missions[id].points["allies"].id=undefined;
level.missions[id].points["allies"].missionId=undefined;
level.missions[id].points["allies"]hideAll();
level.missions[id].points["axis"].id=undefined;
level.missions[id].points["axis"].missionId=undefined;
level.missions[id].points["axis"]hideAll();

p=level.missions[id].point;
p.occupied=undefined;
p.id=undefined;
p.missionId=undefined;
if(!isDefined(p.taker))
{
p.obj delete();
p.trigger delete();
}
else
{
p.taker killLoadBar();
p.taker=undefined;
p.put=undefined;
}

if(!isDefined(type))
type="COMPLETE";

endMission(id,winner,type);
}

mission_drop_giveup(id,team)
{
level notify("endmission"+id,team,"GIVEUP");
}

mission_drop_backup()
{
id=self.missionId;
m=level.missions[id];

self.objects=false;
self.objIcons=[];

level.missions[id].points[self.team]thread showAll("enemy",self);
level.missions[id].points[level.enemy[self.team]]thread showAll("friend",self);
if(self.team=="allies")
{
self objOnCompass(0,m.points["allies"].origin,"drop");
self objOnCompass(1,m.points["axis"].origin,"enemydrop");
}
else
{
self objOnCompass(1,m.points["allies"].origin,"enemydrop");
self objOnCompass(0,m.points["axis"].origin,"drop");
}
if(isDefined(m.point.taker))
{
if(self.team==m.point.taker.team)
self newMissionPoint("follow0",m.point.taker,"obj");
else
 self newMissionPoint("pickup0",m.point.taker,"obj");
}
else
{
self objOnCompass(0,m.point.origin,"pickup");
}

self setClientDvars(
"timeleft",m.timeleft,
"mission_title","DROP",
"mission_desc","DROP"
);
}

mission_drop_timelimit(id)
{
level notify("endmission"+id,"allies","TIED");
}

beDropPoint()
{
id=self.missionId;
level endon("endmission"+id);

while(true)
{
self waittill("trigger",player);
if(isDefined(player.missionId)&&player.missionId==id&&isAlive(player)&&self==level.missions[id].points[player.team]&&player.objects&&!isDefined(self.taker)&&!isDefined(self.claimed))
{
self.taker=player;
player loadBar(0,id);
player thread drop();
}
}
}

drop()
{
id=self.missionId;
m=level.missions[id];
self endon("disconnect");
level endon("endmission"+id);

point=m.points[self.team];
point thread startSingleFlashing();
curTime=0.05;
wait 0.05;
while(curTime<m.captureTime&&self isTouching(point)&&isAlive(self)&&!isDefined(self.claimed))
{
curTime+=0.05;
wait 0.05;
}

if(curTime==m.captureTime&&self isTouching(point)&&!isDefined(self.claimed))
{
self target(1,true);
self.objects=false;
self setClientDvar("items",0);
__v205=m.all;__c205=m.allCount;for(__i205=0;__i205<__c205;__i205++)
{
__e205=__v205[__i205];__e205 destroyObject(0);
__e205 destroyObject(1);
__e205 setClientDvars(
"counter1","",
"counter1text",""
);
}__i205=undefined;__c205=undefined;__v205=undefined;
level notify("endmission"+id,self.team);
}
else
{
point.taker=undefined;
point.curTime=undefined;
self killLoadBar();
}
}

beDropItem(origin,angles)
{
if(!isDefined(origin))
origin=self.origin;
if(!isDefined(angles))
angles=self.angles;

self.obj=spawn("script_model",origin);
self.obj setModel("com_copypaper_box");
self.obj.angles=angles;
self.trigger=spawn("trigger_radius",origin,0,16,16);

id=self.missionId;
while(isDefined(self.trigger))
{
self.trigger waittill("trigger",player);
if(isDefined(player.missionId)&&player.missionId==id&&player useButtonPressed())
{
player thread watchPutObject();
player thread watchPutObjectStun();
player thread watchPutObjectDisconnect();
player.objects=true;
player setClientDvar("items",1);
self.obj delete();
self.trigger delete();
self.taker=player;
level.missions[id].obj[0]=undefined;




__v206=level.teams[level.missions[id].team[player.team]];__c206=__v206.size;for(__i206=0;__i206<__c206;__i206++)
{
__e206=__v206[__i206];__e206 destroyObject(2);

if(__e206!=player)
__e206 newMissionPoint("follow0",player,"obj");
}__i206=undefined;__c206=undefined;__v206=undefined;
__v207=level.teams[level.missions[id].team[level.enemy[player.team]]];__c207=__v207.size;for(__i207=0;__i207<__c207;__i207++)
{
__v207[__i207] destroyObject(2);
__v207[__i207] newMissionPoint("pickup0",player,"obj");
}__i207=undefined;__c207=undefined;__v207=undefined;
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

self waittill("disconnect",origin,angles);
self putObject(origin,angles);
}

putObject(origin,angles)
{
self notify("putitem");

if(isPlayer(self))
{
self.objects=false;
self setClientDvar("items",0);

origin=self.origin;
angles=self.angles;
}

id=self.missionId;
item=level.missions[id].point;

origin=physicsTrace(origin,origin-(0,0,1000));

item.taker=undefined;
item thread beDropItem(origin,angles);
level.missions[id].obj[0]["pos"]=item;
level.missions[id].obj[0]["allies"]="pickup";
level.missions[id].obj[0]["axis"]="pickup";

__v208=level.missions[id].all;__c208=level.missions[id].allCount;for(__i208=0;__i208<__c208;__i208++)
{
__v208[__i208] objOnCompass(2,origin,"pickup");
}__i208=undefined;__c208=undefined;__v208=undefined;
}




mission_destroy(id)
{

if(randomInt(2))
level.missions[id].attackTeam="allies";
else
 level.missions[id].attackTeam="axis";

m=level.missions[id];
level.missions[id].defendTeam=level.enemy[m.attackTeam];

def=level.teams[m.team[m.defendTeam]];
att=level.teams[m.team[m.attackTeam]];


attOrigin=averagePos(att);
defOrigin=averagePos(def);
pnt=level.destroyPoints[0];
dis=-1;
__v209=level.destroyPoints;__c209=__v209.size;for(__i209=0;__i209<__c209;__i209++)
{
__e209=__v209[__i209];if(!isDefined(__e209.occupied))
{
defDist=distanceSquared(defOrigin,__e209.origin);
attDist=distanceSquared(attOrigin,__e209.origin);
newDis=abs(defDist-attDist);
if(dis==-1||newDis<dis)
{
pnt=__e209;
dis=newDis;
}
}
}__i209=undefined;__c209=undefined;__v209=undefined;



if(dis==-1)
{
level.missions[id].currentStage--;
thread newObj(id);
return;
}

points=pnt.points;
c=points.size;
pnt.occupied=true;
pnt.id=c;
for(i=0;i<c;i++)
{
__e210=points[i];__e210 show();
__e210.id=i;
__e210.missionId=id;
__e210.destroyed=false;
__e210.dmg=0;
__e210 setCanDamage(true);
__e210 thread beDestroyObj();
level.missions[id].obj[i]["pos"]=__e210;
level.missions[id].obj[i][m.attackTeam]="destroy";
level.missions[id].obj[i][m.defendTeam]="defend";
}i=undefined;


level.missions[id].damage=500;


level.missions[id].maxTime=c*100;
timeString=leftTimeToString(m.maxTime,"noh");


for(j=0;j<c;j++)
{
__e211=points[j];__c212=att.size;for(__i212=0;__i212<__c212;__i212++)
att[__i212] objOnCompass(j,__e211.origin,"destroy");__i212=undefined;__c212=undefined;

__c213=def.size;for(__i213=0;__i213<__c213;__i213++)
def[__i213] objOnCompass(j,__e211.origin,"defend");__i213=undefined;__c213=undefined;
}j=undefined;
__v214=m.all;__c214=m.allCount;for(__i214=0;__i214<__c214;__i214++)
{
__v214[__i214] setClientDvars(
"counter1","0/"+c,
"counter1text","DESTROYED_OBJECTS",
"timeleft",timeString,
"mission_title","DESTROY",
"mission_desc","DESTROY"
);
}__i214=undefined;__c214=undefined;__v214=undefined;


level.missions[id].destroyed=0;
level.missions[id].points=points;
level.missions[id].point=pnt;
level.missions[id].pointCount=c;
level.missions[id].backupFunc=::mission_destroy_backup;
level.missions[id].giveupFunc=::mission_destroy_giveup;
level.missions[id].timeleft=timeString;
thread timeLimit(id,m.maxTime,::mission_destroy_timelimit);

updateRespawnMap(id);


thread mission_destroy_end(id);
}

mission_destroy_end(id)
{
level waittill("endmission"+id,winner,giveup);


level.missions[id].point.occupied=undefined;
__v215=level.missions[id].points;__c215=level.missions[id].pointCount;for(__i215=0;__i215<__c215;__i215++)
{
__e215=__v215[__i215];if(__e215.destroyed)
{
__e215 thread waitAndShowModel();
}
__e215.destroyed=undefined;
__e215.missionId=undefined;
__e215 setCanDamage(false);

}__i215=undefined;__c215=undefined;__v215=undefined;


if(isDefined(giveup))
endMission(id,winner,"GIVEUP");
else if(winner=="defend")
endMission(id,level.missions[id].defendTeam,"COMPLETE");
else
 thread newObj(id);
}

mission_destroy_giveup(id,team)
{
level notify("endmission"+id,team,true);
}

mission_destroy_timelimit(id)
{
level notify("endmission"+id,"defend");
}

mission_destroy_backup()
{
m=level.missions[self.missionId];
defender=self.team==m.defendTeam;

self.objIcons=[];
c=m.pointCount;
__v216=m.points;for(i=0;i<c;i++)
{
__e216=__v216[i];if(isDefined(__e216.dmg))
{
if(defender)
self objOnCompass(i,__e216.origin,"defend");
else
 self objOnCompass(i,__e216.origin,"destroy");
}
}i=undefined;__v216=undefined;
self setClientDvars(
"counter1",m.destroyed+"/"+c,
"counter1text","DESTROYED_OBJECTS",
"timeleft",m.timeLeft,
"mission_title","DESTROY",
"mission_desc","DESTROY"
);
}

beDestroyObj()
{
id=self.missionId;
m=level.missions[id];
level endon("endmission"+id);

while(true)
{
self waittill("damage",damage,attacker);
if(isDefined(attacker.missionId)&&attacker.missionId==id&&attacker.team==m.attackTeam)
{
self.dmg+=damage;
if(self.dmg>=m.damage)
{
attacker target(1);
level.missions[id].destroyed++;
playFX(level.destroyFX,self.origin);
self hide();
self.destroyed=true;
level.missions[id].obj[self.id]=undefined;

if(m.destroyed!=m.pointCount)
{

self setCanDamage(false);
__v217=m.all;__c217=m.allCount;for(__i217=0;__i217<__c217;__i217++)
{
__v217[__i217] destroyObject(self.id);
__v217[__i217] setClientDvar("counter1",m.destroyed+"/"+m.pointCount);
}__i217=undefined;__c217=undefined;__v217=undefined;
break;
}
else
{
__v218=m.all;__c218=m.allCount;for(__i218=0;__i218<__c218;__i218++)
{
__v218[__i218] destroyObject(self.id);
__v218[__i218] setClientDvars(
"counter1","",
"counter1text",""
);
}__i218=undefined;__c218=undefined;__v218=undefined;
level notify("endmission"+id,"attack");
}
}
}
}
}

waitAndShowModel()
{
wait 30;


if(!isDefined(self.destroyed))
self show();
}




mission_defuse(id)
{
m=level.missions[id];
if(level.tutorial)
{

if(isDefined(level.teams[m.team["allies"]][0].isBot))
level.missions[id].attackTeam="axis";
else
 level.missions[id].attackTeam="allies";
}
else
{

if(randomInt(2))
level.missions[id].attackTeam="allies";
else
 level.missions[id].attackTeam="axis";
}

level.missions[id].defendTeam=level.enemy[m.attackTeam];

def=level.teams[m.team[m.defendTeam]];
att=level.teams[m.team[m.attackTeam]];


attOrigin=averagePos(att);
defOrigin=averagePos(def);
pnt=level.defusePoints[0];
dis=-1;
__v219=level.defusePoints;__c219=__v219.size;for(__i219=0;__i219<__c219;__i219++)
{
__e219=__v219[__i219];if(!isDefined(__e219.occupied))
{
defDist=distanceSquared(defOrigin,__e219.origin);
attDist=distanceSquared(attOrigin,__e219.origin);
newDis=abs(defDist-attDist);
if(dis==-1||newDis<dis)
{
pnt=__e219;
dis=newDis;
}
}
}__i219=undefined;__c219=undefined;__v219=undefined;



if(dis==-1)
{
level.missions[id].currentStage--;
thread newObj(id);
return;
}

pnt.occupied=true;
points=pnt.points;
c=points.size;
pnt.id=c;
for(i=0;i<c;i++)
{
__e220=points[i];__e220 show();
__e220.object show();
__e220.id=i;
__e220.missionId=id;
__e220.destroyed=false;
__e220 thread beDefuseObj();
level.missions[id].obj[i]["pos"]=__e220;
level.missions[id].obj[i][m.attackTeam]="defuse";
level.missions[id].obj[i][m.defendTeam]="defend";
}i=undefined;


level.missions[id].captureTime=5;


level.missions[id].maxTime=c*100;
timeString=leftTimeToString(m.maxTime,"noh");


for(j=0;j<c;j++)
{
__e221=points[j];__c222=att.size;for(__i222=0;__i222<__c222;__i222++)
{
att[__i222] objOnCompass(j,__e221.origin,"defuse");
}__i222=undefined;__c222=undefined;
__c223=def.size;for(__i223=0;__i223<__c223;__i223++)
{
def[__i223] objOnCompass(j,__e221.origin,"defend");
}__i223=undefined;__c223=undefined;
}j=undefined;
__v224=m.all;__c224=m.allCount;for(__i224=0;__i224<__c224;__i224++)
{
__v224[__i224] setClientDvars(
"counter1","0/"+c,
"counter1text","DEFUSED_BOMBS",
"timeleft",timeString,
"mission_title","DEFUSE",
"mission_desc","DEFUSE"
);
}__i224=undefined;__c224=undefined;__v224=undefined;


level.missions[id].destroyed=0;
level.missions[id].points=points;
level.missions[id].pointsize=c;
level.missions[id].point=pnt;
level.missions[id].backupFunc=::mission_defuse_backup;
level.missions[id].giveupFunc=::mission_defuse_giveup;
level.missions[id].timeleft=timeString;


if(level.tutorial)
att[0]thread mission_defuse_tutdelay();
else
 thread timeLimit(id,m.maxTime,::mission_defuse_timelimit);

updateRespawnMap(id);


thread mission_defuse_end(id);
}

mission_defuse_end(id)
{
level waittill("endmission"+id,winner,giveup);


level.missions[id].point.occupied=undefined;
__v225=level.missions[id].points;__c225=level.missions[id].pointsize;for(__i225=0;__i225<__c225;__i225++)
{
__e225=__v225[__i225];if(!__e225.destroyed)
{
__e225 hide();
__e225.object hide();
if(isDefined(__e225.taker))
{
__e225.taker endPlant();
__e225.taker=undefined;
}
}
__e225.missionId=undefined;
__e225.destroyed=undefined;
}__i225=undefined;__c225=undefined;__v225=undefined;


if(isDefined(giveup))
endMission(id,winner,"GIVEUP");
else if(winner=="defend")
endMission(id,level.missions[id].defendTeam,"COMPLETE");
else
 thread newObj(id);
}

mission_defuse_tutdelay()
{
self endon("disconnect");

self.tut=3;
self setClientDvar("tutid",3);
self openMenu(game["menu_tutorial"]);
self waittill("tut_beginmission");

thread timeLimit(self.missionID,level.missions[self.missionID].maxTime,::mission_defuse_timelimit);
}

mission_defuse_giveup(id,team)
{
level notify("endmission"+id,team,true);
}

mission_defuse_timelimit(id)
{
level endon("endmission"+id);


over=false;
__v226=level.missions[id].points;__c226=level.missions[id].pointsize;for(i=0;i<__c226;i++)
{
if(isDefined(__v226[i].taker))
{
if(!over)
{
overtimeMessage(id);
over=true;
}

__v226[i] waittill("endplant");
i=0;
continue;
}
}i=undefined;__c226=undefined;__v226=undefined;

level notify("endmission"+id,"defend");
}

mission_defuse_backup()
{
m=level.missions[self.missionId];
defender=self.team==m.defendTeam;

self.objIcons=[];
__v227=m.points;__c227=m.pointsize;for(i=0;i<__c227;i++)
{
__e227=__v227[i];if(isDefined(__e227.dmg))
{
if(defender)
self objOnCompass(i,__e227.origin,"defend");
else
 self objOnCompass(i,__e227.origin,"defuse");
}
}i=undefined;__c227=undefined;__v227=undefined;
self setClientDvars(
"counter1",m.destroyed+"/"+m.pointsize,
"counter1text","DEFUSED_BOMBS",
"timeleft",m.timeLeft,
"mission_title","DEFUSE",
"mission_desc","DEFUSE"
);
}

beDefuseObj()
{
id=self.missionId;
level endon("endmission"+id);
self endon("destroyed");

while(true)
{
self waittill("trigger",player);
if(!isDefined(self.taker)&&player useButtonPressed()&&isAlive(player)&&isDefined(player.missionId)&&player.missionTeam==level.missions[id].team[level.missions[id].attackTeam]&&!player.throwingGrenade&&!isDefined(self.claimed))
{
self.taker=player;
self.object hide();
self thread startSingleFlashing();
player thread defuse(self);
}
wait 0.05;
}
}

defuse(point)
{
id=point.missionId;
m=level.missions[id];
level endon("endmission"+id);

self thread giveBomb(point);


curTime=0.05;
wait 0.05;
while(isDefined(self)&&curTime<m.captureTime&&self isTouching(point)&&isAlive(self)&&self useButtonPressed()&&!self.throwingGrenade&&!isDefined(self.claimed))
{
curTime+=0.05;
wait 0.05;
}

if(isDefined(self)&&curTime==m.captureTime&&self isTouching(point)&&isAlive(self)&&self useButtonPressed()&&!self.throwingGrenade&&!isDefined(self.claimed))
{
self target(1);
level.missions[id].destroyed++;
level.missions[id].obj[point.id]=undefined;

__v228=m.all;__c228=m.allCount;for(__i228=0;__i228<__c228;__i228++)
{
__v228[__i228] destroyObject(point.id);
}__i228=undefined;__c228=undefined;__v228=undefined;
if(m.destroyed==m.pointsize)
{
__v229=m.all;__c229=m.allCount;for(__i229=0;__i229<__c229;__i229++)
{
__v229[__i229] setClientDvars(
"counter1","",
"counter1text",""
);
}__i229=undefined;__c229=undefined;__v229=undefined;
level notify("endmission"+id,"attack");
}
else
{
point.destroyed=true;
point hide();
point notify("destroyed");
d=m.destroyed+"/"+m.pointsize;
__v230=m.all;__c230=m.allCount;for(__i230=0;__i230<__c230;__i230++)
{
__e230=__v230[__i230];__e230 setClientDvar("counter1",d);
__e230 thread mainLine(level.s["DEFUSED_BOMBS_"+__e230.lang]+": "+d);
}__i230=undefined;__c230=undefined;__v230=undefined;
}
}
else
{
point.object show();
}

point.taker=undefined;

if(isDefined(self))
self endPlant();

point notify("endplant");
}




mission_plant(id)
{

if(randomInt(2))
level.missions[id].attackTeam="allies";
else
 level.missions[id].attackTeam="axis";

m=level.missions[id];
level.missions[id].defendTeam=level.enemy[m.attackTeam];

def=level.teams[m.team[m.defendTeam]];
att=level.teams[m.team[m.attackTeam]];


attOrigin=averagePos(att);
defOrigin=averagePos(def);
pnt=level.plantPoints[0];
dis=-1;
__v231=level.plantPoints;__c231=__v231.size;for(__i231=0;__i231<__c231;__i231++)
{
__e231=__v231[__i231];if(!isDefined(__e231.occupied))
{


newDis=abs(distanceSquared(defOrigin,__e231.origin)-distanceSquared(attOrigin,__e231.origin));
if(dis==-1||newDis<dis)
{
pnt=__e231;
dis=newDis;
}
}
}__i231=undefined;__c231=undefined;__v231=undefined;



if(dis==-1)
{
level.missions[id].currentStage--;
thread newObj(id);
return;
}

pnt.occupied=true;
pnt.owner=m.defendTeam;
pnt.id=0;
pnt.missionId=id;
pnt show();
pnt.object show();
pnt thread bePlantObj();
level.missions[id].obj[0]["pos"]=pnt;
level.missions[id].obj[0][m.attackTeam]="defuse";
level.missions[id].obj[0][m.defendTeam]="defend";


level.missions[id].captureTime=5;
level.missions[id].fuseTime=180;


level.missions[id].maxTime=int(m.fuseTime*2.5);
timeString=leftTimeToString(m.maxTime,"noh");


__c232=att.size;for(__i232=0;__i232<__c232;__i232++)
{
att[__i232] objOnCompass(0,pnt.origin,"plant");
}__i232=undefined;__c232=undefined;
__c233=def.size;for(__i233=0;__i233<__c233;__i233++)
{
def[__i233] objOnCompass(0,pnt.origin,"defend");
}__i233=undefined;__c233=undefined;
__v234=m.all;__c234=m.allCount;for(__i234=0;__i234<__c234;__i234++)
{
__v234[__i234] setClientDvars(
"counter1",leftTimeToString(m.fuseTime,"noh shortm"),
"counter1text","FUSE_TIME",
"timeleft",timeString,
"mission_title","PLANT",
"mission_desc","PLANT"
);
}__i234=undefined;__c234=undefined;__v234=undefined;


level.missions[id].backupFunc=::mission_plant_backup;
level.missions[id].giveupFunc=::mission_plant_giveup;
level.missions[id].timeleft=timeString;
level.missions[id].point=pnt;
thread timeLimit(id,m.maxTime,::mission_plant_timelimit);

updateRespawnMap(id);


thread mission_plant_end(id);
}

mission_plant_end(id)
{
level waittill("endmission"+id,winner,giveup);


p=level.missions[id].point;
p.occupied=undefined;
p.missionId=undefined;
p hide();
p.object hide();
if(isDefined(p.taker))
{
p.taker endPlant();
p.taker=undefined;
}


if(isDefined(giveup))
type="GIVEUP";
else
 type="COMPLETE";

endMission(id,winner,type);
}

mission_plant_giveup(id,team)
{
level notify("endmission"+id,team,true);
}

mission_plant_timelimit(id)
{
level notify("endmission"+id,level.missions[id].defendTeam);
}

mission_plant_backup()
{
m=level.missions[self.missionId];

self.objIcons=[];
if(m.point.owner==self.team)
{
self objOnCompass(0,m.point.origin,"defend");
}
else
{
if(self.team==m.defendTeam)
self objOnCompass(0,m.point.origin,"defuse");
else
 self objOnCompass(0,m.point.origin,"plant");
}
self setClientDvars(
"counter1",leftTimeToString(m.fuseTime,"noh shortm"),
"counter1text","FUSE_TIME",
"timeleft",m.timeLeft,
"mission_title","PLANT",
"mission_desc","PLANT"
);
}

bePlantObj()
{
id=self.missionId;
level endon("endmission"+id);
self endon("destroyed");

while(true)
{
self waittill("trigger",player);
if(!isDefined(self.taker)&&player useButtonPressed()&&isAlive(player)&&isDefined(player.missionId)&&player.missionId==id&&self.owner!=player.team&&!player.throwingGrenade&&!isDefined(player.claimed))
{
self.taker=player;
self.object hide();
self thread startSingleFlashing();
player thread plant(self);
}
wait 0.05;
}
}

plant(point)
{
id=point.missionId;
m=level.missions[id];
level endon("endmission"+id);

self thread giveBomb(point);


curTime=0.05;
wait 0.05;
while(isDefined(self)&&curTime<id.captureTime&&self isTouching(point)&&isAlive(self)&&self useButtonPressed()&&!self.throwingGrenade&&!isDefined(self.claimed))
{
curTime+=0.05;
wait 0.05;
}

if(isDefined(self)&&curTime==m.captureTime&&self isTouching(point)&&isAlive(self)&&self useButtonPressed()&&!self.throwingGrenade&&!isDefined(self.claimed))
{
self target(1);
point.owner=self.team;
attacker=self.team==m.attackTeam;
if(attacker)
level.missions[id].countFuseTime=true;
else
 level.missions[id].countFuseTime=undefined;

__v235=level.teams[m.team[m.attackTeam]];__c235=__v235.size;for(__i235=0;__i235<__c235;__i235++)
{
if(attacker)
__v235[__i235] objOnCompass(0,m.point.origin,"defend");
else
 __v235[__i235] objOnCompass(0,m.point.origin,"plant");
}__i235=undefined;__c235=undefined;__v235=undefined;
__v236=level.teams[m.team[m.defendTeam]];__c236=__v236.size;for(__i236=0;__i236<__c236;__i236++)
{
if(attacker)
__v236[__i236] objOnCompass(0,m.point.origin,"defuse");
else
 __v236[__i236] objOnCompass(0,m.point.origin,"defend");
}__i236=undefined;__c236=undefined;__v236=undefined;

level.missions[id].obj[0][self.team]="defend";

level.missions[id].obj[0][level.enemy[self.team]]="defuse";


}

point.object show();
point.taker=undefined;
if(isDefined(self))
{
self endPlant();
}
}
__sif(c,y,n){if(c)return y;else return n;}