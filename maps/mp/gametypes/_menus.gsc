








init()
{






game["menu_mix"]="mix";
game["menu_group"]="group";
game["menu_dress"]="dress";
game["menu_ammo"]="ammo";
game["menu_chat"]="chat";
game["menu_weapons"]="weapons";
game["menu_inv"]="inv";
game["menu_inv2"]="inv2";
game["menu_inv3"]="inv3";
game["menu_invperk"]="invperk";


game["menu_mods"]="mods";



game["menu_cmd"]="cmd";

game["menu_camo"]="camo";
game["menu_stat"]="stat";
game["menu_groupmgr"]="groupmgr";
game["menu_teammgr"]="teammgr";
game["menu_friendmgr"]="friendmgr";
game["menu_clanmgr"]="clanmgr";
game["menu_tutorial"]="tutorial";
game["menu_progress"]="progress";
game["menu_class"]="class";
game["menu_mail"]="mail";
game["menu_login"]="login";
game["menu_profile"]="profile";
game["menu_studio"]="studio";
game["menu_composer"]="composer";
game["menu_warzone"]="warzone";
game["menu_treasury"]="treasury";
game["menu_map"]="map";
game["menu_backpack"]="backpack";
game["menu_servers"]="servers";
game["menu_puzzle"]="puzzle";



preCacheMenu(game["menu_mix"]);
preCacheMenu(game["menu_group"]);
preCacheMenu(game["menu_dress"]);
preCacheMenu(game["menu_ammo"]);
preCacheMenu(game["menu_chat"]);
preCacheMenu(game["menu_weapons"]);
preCacheMenu(game["menu_inv"]);
preCacheMenu(game["menu_inv2"]);
preCacheMenu(game["menu_inv3"]);
preCacheMenu(game["menu_invperk"]);


preCacheMenu(game["menu_mods"]);



preCacheMenu(game["menu_cmd"]);

preCacheMenu(game["menu_camo"]);
preCacheMenu(game["menu_stat"]);
preCacheMenu(game["menu_groupmgr"]);
preCacheMenu(game["menu_teammgr"]);
preCacheMenu(game["menu_friendmgr"]);
preCacheMenu(game["menu_clanmgr"]);
preCacheMenu(game["menu_tutorial"]);
preCacheMenu(game["menu_progress"]);
preCacheMenu(game["menu_class"]);
preCacheMenu(game["menu_mail"]);
preCacheMenu(game["menu_login"]);
preCacheMenu(game["menu_profile"]);
preCacheMenu(game["menu_studio"]);
preCacheMenu(game["menu_composer"]);
preCacheMenu(game["menu_warzone"]);
preCacheMenu(game["menu_treasury"]);
preCacheMenu(game["menu_map"]);
preCacheMenu(game["menu_backpack"]);
preCacheMenu(game["menu_servers"]);
preCacheMenu(game["menu_puzzle"]);




level thread onPlayerConnect();
}

onPlayerConnect()
{
while(true)
{
level waittill("connecting",player);
player thread onMenuResponse();
}
}




onMenuResponse()
{
self endon("disconnect");

while(true)
{
self waittill("menuresponse",menu,response);


if(response=="back"){
self closeMenus();
}
else if(response=="intro")
{

if(!level.developer)
{
self setStat(3155,4);
}
}
else if(menu==game["menu_mix"])
{
if(!isDefined(self.mix))
continue;

if(self.mix=="faction")
{
if(isDefined(self.info["faction"])||!isDefined(self.info["pass"])||response=="-1")
continue;

fact=int(response);
if(fact==1||fact==2)
{

if(!level.developer)
self setStat(3154,fact);


self.info["faction"]=fact;
__v0=level.info;__c0=level.infoCount+1;for(__i0=1;__i0<__c0;__i0++)
{
__e0=__v0[__i0];if(!isDefined(self.info[__e0["name"]]))
{
if(__e0["type"]=="int")
self.info[__e0["name"]]=0;
else
 self.info[__e0["name"]]="";
}
}__i0=undefined;__c0=undefined;__v0=undefined;










self setDefaultTheme();

self setClientDvars(
"themes",1,
"theme","Default",
"temp_count",0
);





sql_exec("INSERT INTO themes (name, theme) VALUES ('"+self.showname+"', '"+level.defaultTheme+"')");


self login();





self maps\mp\gametypes\apb::joinTeam();
}
}
else if(self.mix=="language")
{
if(response=="-1"&&!isDefined(self.info["lang"]))
continue;

lang=int(response);
if(lang>=0&&lang<level.langs.size)
{
self.lang=level.langs[lang];
self.info["lang"]=lang;


if(!level.developer)
self setStat(3153,lang);

self setClientDvar("lang",self.lang);

if(!isDefined(self.info["faction"]))
{
self maps\mp\gametypes\apb::openMixMenu("terms");
}
else
{


self openMenu(game["menu_class"]);
}
}
else if(isDefined(self.lang))
{
self openMenu(game["menu_class"]);
}
}
else if(self.mix=="found")
{
if(isDefined(self.item))
{
self.item=undefined;
self closeMenu();


if(isDefined(self.invited))
{
p=self.invited;
if(!isDefined(p.group)||(isDefined(p.groupleader)&&level.groups[p.group].team.size<4))
{
self inviteHUD(p.showname+" "+level.s["INVITE_BODY_"+self.lang]);

}
}
else if(isDefined(self.claninvited))
{
x=sql_query_first("SELECT clan FROM members WHERE name = '"+self.claninvited+"' AND rank != 0");
if(isDefined(x))
{
self inviteHUD(self.claninvited+" "+level.s["INVITE_BODY_CLAN_"+self.lang]+": "+x);

}
}


self maps\mp\gametypes\apb::menuStatus(false);

}
}











































else if(self.mix=="terms")
{
if(response=="1"&&!isDefined(self.online))
{
self maps\mp\gametypes\apb::openMixMenu("faction");
}
}
else if(self.mix=="bug")
{
if(isDefined(self.online))
{
if(response=="1")
{
sub=self getUserInfo("info");
msg=self getUserInfo("info2");
if(sub!=""&&msg!="")
{
self closeMenus();

sql_exec("INSERT INTO bugs (name, subject, msg, time) VALUES ('"+self.showname+"', '"+sql_escape(sub)+"', '"+sql_escape(msg)+"', "+getRealTime()+")");
}
else
{
self setClientDvar("error",level.s["fillall_"+self.lang]);
}
}
else
{
self setClientDvar("error","");
self closeMenus();
self openMenu(game["menu_class"]);
}
}
}
else if(self.mix=="set")
{
if(self.online)
{
if(response=="-1")
{
self closeMenu();
self openMenu(game["menu_class"]);
continue;
}
switch(self getUserInfo("info"))
{
case"gmt":
gmt=int(response)-14;
if(gmt>=-13&&gmt<=13)
{
self.info["gmt"]=gmt;
self maps\mp\gametypes\apb::getTimeZone();
self maps\mp\gametypes\apb::getCurTime(getRealTime());


}
else
{
self closeMenu();
}
break;
case"format":
format=int(response);
if(format>=1&&format<=4)
{
self.info["format"]=format;
self setClientDvar("format",level.format[format]);
self maps\mp\gametypes\apb::getCurTime(getRealTime());


}
else
{
self closeMenu();
}
break;
case"date":
date=int(response);
if(date>=1&&date<=11)
{
self.info["date"]=date;
self setClientDvar("date",level.date[date]);


}
else
{
self closeMenu();
}
break;
}
}
}
}
else if(!isDefined(self.online))
{
if(menu==game["menu_login"])
{
if(response=="reg")
{
name=self getUserInfo("info");
pass=self getUserInfo("info2");
inv=self getUserInfo("info3");
if(inv!="")
inv=playerName(toLower(inv));
else
 inv="";

lower=toLower(name);

if(lower.size<3||!validName(lower))
{
self setClientDvar("error",level.s["INVALIDREGNAME_"+self.lang]+"!");
}

else if(playerExists(lower))
{
self setClientDvar("error",level.s["TAKENNAME_"+self.lang]+"!");
}
else if(pass.size<3)
{
self setClientDvar("error",level.s["INVALIDREGPASS_"+self.lang]+"!");
}

else if(!isDefined(inv))
{
self setClientDvar("error",level.s["INVALIDINV_"+self.lang]+"!");
}
else
{











level.online[name]=self;
self.info["pass"]=pass;
self.info["inv"]=inv;
self.info["format"]=3;
self.info["date"]=10;
self.info["gmt"]=1;
self.info["money"]=500;
self.info["maxweapons"]=14;
self.info["maxmods"]=14;
self.info["maxinv"]=14;

self.friends=[];
self.showname=name;
self.lowername=lower;
self setClientDvars(
"showname",name,
"g_scriptMainMenu",game["menu_mix"]
);


































self maps\mp\gametypes\apb::dress(false);
self maps\mp\gametypes\apb::openMixMenu("language");

}
}
else if(response=="1")
{
lower=toLower(self getUserInfo("info"));
name=playerName(lower);



if(isDefined(name)){


pass=self getUserInfo("info2");
x=sql_fetch(sql_query("SELECT "+level.infocols+", status, timestamp FROM players WHERE name = '"+name+"'"));

if(pass==x[0]){
time=getRealTime();
xs=x.size;
if(x[xs-2]=="Offline"||int(x[xs-1])<time-60)
{

level.online[name]=self;
self.showname=name;
self.lowername=lower;


self.info["pass"]=pass;

for(i=2;i<=level.infoCount;i++){



if(level.info[i]["type"]=="int")
self.info[level.info[i]["name"]]=int(x[i-1]);
else
 self.info[level.info[i]["name"]]=x[i-1];

}








































self.friends=[];




x=sql_query("SELECT friend FROM friends WHERE name = '"+name+"'");
for(i=0;true;i++)
{

source=sql_fetch(x);
if(isDefined(source))
self.friends[i]=source[0];
else
 break;
}


self setClientDvar("temp_count",self.friends.size);


self.themes=[];
self.themeList=[];




x=sql_query("SELECT theme FROM themes WHERE name = '"+name+"'");
for(i=0;true;i++)
{

source=sql_fetch(x);
if(isDefined(source))
{
p=strTok(source[0],":");
self.themes[i]=spawnStruct();
self.themes[i].name=p[0];
self.themeList[p[0]]=i;
p=strTok(p[1],"|");
for(j=0;j<8;j++)
{
self.themes[i].tracks[j]=spawnStruct();
q=strTok(p[j],"-");
self.themes[i].tracks[j].type=q[0];
q=strTok(q[1],",");
self.themes[i].tracks[j].nodes=[];
for(k=0;k<32;k++)
{
if(q[k]!=" ")
{
self.themes[i].tracks[j].nodes[k]=int(q[k]);
}
}
}
}
else
{
break;
}
}


self setClientDvars(
"themes",self.themes.size,
"theme",self.themes[self.info["theme"]].name
);



















self.lang=level.langs[self.info["lang"]];
self setClientDvar("lang",self.lang);


if(self.info["reptime"]+1200>time)
{
rep=self.info["rep"]/10000;
self.prestige=int(rep);
self.reputation=rep-self.prestige;
}

self login();


self thread maps\mp\gametypes\apb::joinTeam();
}
else
{
self setClientDvar("error",level.s["LOGGEDIN_"+self.lang]);
}
}
else
{
self setClientDvar("error",level.s["WRONGLOGIN_"+self.lang]+"!");
}


}
else
{
self setClientDvar("error",level.s["WRONGLOGIN_"+self.lang]+"!");
}
}
self setClientDvar("fade",0);
}
}
else
{
if(menu==game["menu_map"])
{
if(response=="close")
{
if(!isDefined(self.respawnData))
{
self closeMenu();
}
}
else
{
id=int(response);
if(isDefined(self.respawnData)&&isDefined(self.respawnData[id]))
{
self.spawn=self.respawnData[id];
}
}
}
else if(response=="map")
{
if(!isDefined(self.respawnData))
{
self setClientDvars(
"death_x","",
"respawn_objs",0,
"respawn_points",0,
"respawn_x",0,
"respawn_y",0
);
}
}
else if(response=="stat")
{
if(self.hadMission)
{
self maps\mp\gametypes\apb::stat();
}
}

else if(response=="a")
{
if(level.developer&&!isDefined(self.missionId))
{
self maps\mp\gametypes\_rank::giveStanding(10000);
self maps\mp\gametypes\apb::giveMoney(50000);


}
}
else if(isSubStr(response,"bot:"))
{
if(level.developer)
{

response=getSubStr(response,4);
if(isDefined(level.online["bot0"]))
level.online["bot0"]inviteGroup("bot"+response,false);
}
}
else if(response=="code")
{
c=genCode();
sql_exec("INSERT INTO premium (code, item, value) VALUES ('"+c+"', 'PR', 1000)");
self iPrintLn("^6Generated premium code: "+c);
}
else if(response=="find")
{
p=self;
r=randomInt(100);
p.item=false;
while(!p.item)
{
if(r<30)
{

p.item=true;
r=randomIntRange(1,1000);
p maps\mp\gametypes\apb::giveMoney(r);
p setClientDvars(
"found_prize","cash",
"found_key","$"+r
);
}
else if(r<60)
{

a=[];
size=0;
__v1=level.ammos;__c1=level.ammoCount+1;for(j=1;j<__c1;j++)
{
if(p.info["ammo_"+__v1[j].name]<__v1[j].max)
{
a[size]=j;
size++;
}
}j=undefined;__c1=undefined;__v1=undefined;
if(size)
{
p.item=true;


g=level.ammos[a[randomInt(size)]];

r=randomIntRange(1,int(level.ammos[g].max/10));
if(p.info["ammo_"+g.name]+r>g.max)
{
r=g.max-p.info["ammo_"+g.name];
}

p.info["ammo_"+g.name]+=r;
p setClientDvars(
"found_prize","ammo_"+g.name,
"found_key",r+" "+level.s["AMMO_"+g.title+"_"+p.lang]
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
__v2=level.weaps;__c2=level.weaponCount+1;for(j=1;j<__c2;j++)
{
__e2=__v2[j];if(__e2.group=="0"&&p.rating>=__e2.rating&&p.roleLevel[__e2.roleType]>=__e2.roleLevel)
{
a[size]=j;
size++;
}
}j=undefined;__c2=undefined;__v2=undefined;
if(size)
{
w=a[randomInt(size)];
p.item=p maps\mp\gametypes\_menus::giveWeap(w,false);


if(p.item)
{
p setClientDvars(
"found_prize",level.weaps[w].image,
"found_key",level.weaps[w].name
);
}
}

if(!p.item)
r=30;
}
else if(r<92)
{

if(p.weapons.size<p.info["maxweapons"])
{
a=[];
size=0;
__v3=level.weaps;__c3=level.weaponCount+1;for(j=1;j<__c3;j++)
{
if(__v3[j].group=="1"&&!isDefined(p.wID[j]))
{
a[size]=j;
size++;
}
}j=undefined;__c3=undefined;__v3=undefined;
if(size)
{
p.item=true;
rid=a[randomInt(a.size)];
w=level.weaps[rid];

wid=p.weapons.size+1;
p.weapons[wid]["id"]=rid;
p.weapons[wid]["type"]=w.type;
p.weapons[wid]["time"]=0;
p.weapons[wid]["camo"]=0;
p.weapons[wid]["mod"]=w.mod;
p.wID[rid]=wid;

sql_exec("INSERT INTO weapons (name, weapon, mods) VALUES ('"+p.showname+"', "+rid+", "+p.weapons[wid]["mod"]+")");

count=1;
for(j=1;j<p.weapons.size;j++)
{
if(p.weapons[j]["type"]==p.weapons[wid]["type"])
{
count++;
}
}
p setClientDvars(
w.type+count,rid,
"hasweapon"+rid,1,
"found_prize",w.image,
"found_key",w.name
);
}
}

if(!p.item)
r=60;
}
else if(r<94)
{

d=p.inv.size;
if(p.info["maxinv"]>d)
{
p.item=true;
c=randomInt(level.camoCount-1)+1;
sql_exec("INSERT INTO inv (name, item, itemtype) VALUES ('"+p.showname+"', 'camo', "+c+")");
p.inv[d]=spawnStruct();
p.inv[d].id=int(sql_query_first("SELECT COALESCE(MAX(invid), 0) FROM inv WHERE name = '"+p.showname+"'"));
p.inv[d].item="camo";
p.inv[d].itemtype=c;
p setClientDvars(
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

d=p.inv.size;
if(p.info["maxinv"]>d)
{
p.item=true;
c=randomInt(level.toolCount);
e=level.tools[c].types[randomInt(level.tools[c].types.size)];
sql_exec("INSERT INTO inv (name, item, itemtype) VALUES ('"+p.showname+"', '"+level.tools[c].name+"', "+e+")");
p.inv[d]=spawnStruct();
p.inv[d].id=int(sql_query_first("SELECT COALESCE(MAX(invid), 0) FROM inv WHERE name = '"+p.showname+"'"));
p.inv[d].item=level.tools[c].name;
p.inv[d].itemtype=e;
p setClientDvars(
"found_prize","tool_"+level.tools[c].img,
"found_key",level.s[level.tools[c].title+"_"+p.lang]
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
if(p.info["symbols"])
{
g=[];
size=0;
__v4=level.rareSymbols;__c4=level.rareSymbolCount;for(__i4=0;__i4<__c4;__i4++)
{
if(!(level.symbols[__v4[__i4]].value&p.info["symbols"]))
{
g[size]=__v4[__i4];
size++;
}
}__i4=undefined;__c4=undefined;__v4=undefined;
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
p.item=true;
p.info["symbols"]|=level.symbols[rid].value;
p setClientDvars(
"symbols",p.info["symbols"],
"found_prize","locked",
"found_key",level.s["SYMBOL_"+p.lang]+" #"+rid
);
}
else
{
r=94;
}
}

else{

rid=-1;
if(p.info["hats"])
{
g=[];
size=0;
__v5=level.hats;__c5=level.hatCount+1;for(j=1;j<__c5;j++)
{
if(!__v5[j].price&&!(__v5[j].bit&p.info["hats"]))
{
g[size]=j;
size++;
}
}j=undefined;__c5=undefined;__v5=undefined;
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
p.item=true;
p.info["hats"]|=level.hats[rid].bit;
p setClientDvars(
"hasitem_hat_"+rid,"1",
"found_prize","locked",
"found_key","@APB_HAT_"+level.hats[rid].name+"_"+p.lang
);
}
else
{
r=96;
}
}
}
self maps\mp\gametypes\apb::openMixMenu("found");
}

else if(response=="nostat")
{
self maps\mp\gametypes\apb::menuStatus(false);
}
else if(response=="join")
{
if(!isDefined(self.info["faction"]))
continue;

if(self.info["faction"]==1)
{
self[[level.allies]]();
}
else
{
self[[level.axis]]();
}
}

else if(menu==game["menu_progress"])
{

if(response=="close")
{
if(isDefined(self.progressMenu))
{
self.progressMenu=undefined;
self.weaponid=undefined;
}
}
else
{
if(!isDefined(self.progressMenu))
{
self.progressMenu=true;


if(self.info["allrun"]<984252)
self setClientDvar("achievement_sprint_progress",int(self.info["allrun"]/39.37008)+"/25000");
else
 self setClientDvar("achievement_sprint_progress","");

if(self.info["assists"]<100)
self setClientDvar("achievement_assist_progress",self.info["assists"]+"/100");
else
 self setClientDvar("achievement_assist_progress","");

if(self.info["kills"]<10000)
self setClientDvar("achievement_hitman_progress",self.info["kills"]+"/10000");
else
 self setClientDvar("achievement_hitman_progress","");

if(self.info["medals"]<100)
self setClientDvar("achievement_medal_progress",self.info["medals"]+"/100");
else
 self setClientDvar("achievement_medal_progress","");

if(self.info["regenhealth"]<20000)
self setClientDvar("achievement_health_progress",self.info["regenhealth"]+"/20000");
else
 self setClientDvar("achievement_health_progress","");

if(self.info["backupcalled"]<100)
self setClientDvar("achievement_backup_progress",self.info["backupcalled"]+"/100");
else
 self setClientDvar("achievement_backup_progress","");

if(self.info["startedgroups"]<100)
self setClientDvar("achievement_groups_progress",self.info["startedgroups"]+"/100");
else
 self setClientDvar("achievement_groups_progress","");

if(self.info["delivereditems"]<100)
self setClientDvar("achievement_items_progress",self.info["delivereditems"]+"/100");
else
 self setClientDvar("achievement_items_progress","");

if(self.info["missiontime"]<86400)
self setClientDvar("achievement_veteran_progress",maps\mp\gametypes\apb::leftTimeToString(self.info["missiontime"],"nos")+"/24:00");
else
 self setClientDvar("achievement_veteran_progress","");

if(self.info["prestigetime"]<3600)
self setClientDvar("achievement_prestige_progress",maps\mp\gametypes\apb::leftTimeToString(self.info["prestigetime"],"noh")+"/60:00");
else
 self setClientDvar("achievement_prestige_progress","");

if(self.info["mis_win"]<100)
self setClientDvar("achievement_mission_progress",self.info["mis_win"]+"/100");
else
 self setClientDvar("achievement_mission_progress","");


cur=1;
for(i=1;i<=12;i++)
{
id="achievement_"+tableLookup("mp/achievementTable.csv",0,i,1);
if(cur&self.info["achievements"])
self setClientDvar(id,true);
else
 self setClientDvar(id,false);

if(i<12)
cur*=2;
}


__v6=level.roleList;__c6=__v6.size;for(__i6=0;__i6<__c6;__i6++)
{
self maps\mp\gametypes\apb::updateRole(__v6[__i6]);
}__i6=undefined;__c6=undefined;__v6=undefined;
}


self.weaponid=response;
self setClientDvar("weaponid",self.weaponid);












}
}
else if(response=="backup")
{
if(isDefined(self.teamleader))
{
t=level.teams[self.missionTeam];
tc=t.size;
e=level.teams[self.enemyTeam];
ec=e.size;
if(tc<=ec)
{
if(tc==ec)
{
friendThreat=0;
for(__i7=0;__i7<tc;__i7++)
{
friendThreat+=level.threatValue[t[__i7].threat];
}__i7=undefined;
enemyThreat=0;
for(__i8=0;__i8<ec;__i8++)
{
enemyThreat+=level.threatValue[e[__i8].threat];
}__i8=undefined;
if(enemyThreat-friendThreat<tc)
continue;
}
if(isDefined(level.missions[self.missionId].backup))
{
level.missions[self.missionId].backup=undefined;
self setClientDvar("leftinfo","CALL_BACKUP");
level notify("endbackup"+self.missionTeam);
}
else
{
self thread maps\mp\gametypes\apb::backup();
}
}
}
}
else if(response=="invite")
{
self setClientDvar("invite","");
self inviteGroup(self getUserInfo("info"),false);
}
else if(response=="ready")
{
if((level.action||level.tutorial)&&!isDefined(self.missionId)&&isDefined(self.team)&&(self.team=="allies"||self.team=="axis"))
{
self.ready=!self.ready;
if(isDefined(self.group)&&!level.groups[self.group].inMission)
{
maps\mp\gametypes\apb::refreshGroup(self.group);
}
else
{
if(self.ready)
{
self setClientDvars(
"name0","^2"+self.showname,
"status0","ready"
);
level.readyPlayers[self.team][level.readyPlayers[self.team].size]=self;
}
else
{
self setClientDvars(
"name0",self.showname,
"status0","notready"
);
self maps\mp\gametypes\apb::unreadyPlayer();
}

self setClientDvar("ready",self.ready);
}

if(self.ready)
self playLocalSound("Ready");
else
 self playLocalSound("NotReady");
}
}
else if(response=="chat")
{
if(isDefined(self.info["dress"]))
{
self openMenu(game["menu_chat"]);
}
}
else if(response=="point")
{
if(isDefined(self.teamleader))
{
start=self.origin;
switch(self getStance()){
case"prone":
start+=(0,0,11);
break;
case"crouch":
start+=(0,0,40);
break;
case"stand":
start+=(0,0,60);
break;
}


vec=anglesToForward(self getPlayerAngles());
trace=bulletTrace(start,start+(10000*vec[0],10000*vec[1],10000*vec[2]),true,self);
if(trace["fraction"]!=1)
{

start=trace["position"]+(0,0,1);
vec=physicsTrace(start,trace["position"]-(0,0,1000));
if(vec!=start)
{
self thread placePoint(vec);
}
}
}
}
else if(menu==game["menu_stat"])
{
if(isDefined(self.playerStats))
{
id=int(response);

if(id<8)
p=self.clientids["friend"][id];
else
 p=self.clientids["enemy"][id-8];

self maps\mp\gametypes\apb::playerDetails(p);
}
}
else if(menu==game["menu_backpack"])
{
if(response=="setup")
{

c=self.inv.size;
self.bppage=1;
self getBackpack();
self setClientDvars(
"temp_stat",c+"/"+self.info["maxinv"],
"temp_pages",ceil(c/18)
);
}
else if(isDefined(self.bppage))
{
if(response=="clear")
{
self.bppage=undefined;

if(isDefined(self.bpid))
self.bpid=undefined;
}
else if(response=="next")
{
if(self.inv.size>18*self.bppage)
{
self.bppage++;
self getBackpack();

if(isDefined(self.bpid))
self.bpid=undefined;
}
}
else if(response=="prev")
{
if(self.bppage>1)
{
self.bppage--;
self getBackpack();

if(isDefined(self.bpid))
self.bpid=undefined;
}
}
else if(response=="delete")
{
if(isDefined(self.bpid))
{
id=self.bpid+18*(self.bppage-1);

sql_exec("DELETE FROM inv WHERE invid = "+self.inv[id].id);
{__c=self.inv.size-1;if(id==__c){self.inv[id]=undefined;}else{for(__i=__c;__i<__c;__i++){self.inv[__i]=self.inv[__i+1];}}}

if(self.bppage>1&&self.inv.size<18*self.bppage)
self.bppage--;

self getBackpack();
}
}
else if(response=="use")
{
if(isDefined(self.bpid))
{
id=self.bpid+18*(self.bppage-1);
if(isDefined(level.toolsID[self.inv[id].item]))
{
if(level.tools[level.toolsID[self.inv[id].item]].name=="invexp")
{
self.info["maxinv"]+=self.inv[id].itemtype;
self setClientDvar("temp_stat",self.inv.size+"/"+self.info["maxinv"]);
}
else if(level.tools[level.toolsID[self.inv[id].item]].name=="weapexp")
{
self.info["maxweapons"]+=self.inv[id].itemtype;
}
else if(level.tools[level.toolsID[self.inv[id].item]].name=="modexp")
{
self.info["maxmods"]+=self.inv[id].itemtype;
}

sql_exec("DELETE FROM inv WHERE invid = "+self.inv[id].id);
{__c=self.inv.size-1;if(id==__c){self.inv[id]=undefined;}else{for(__i=__c;__i<__c;__i++){self.inv[__i]=self.inv[__i+1];}}}

self.bpid=undefined;
if(self.bppage>1&&self.inv.size<18*self.bppage)
self.bppage--;

self getBackpack();
}
}
}
else
{
id=int(response);
realid=id+18*(self.bppage-1);
if(isDefined(self.inv[realid]))
{
self.bpid=id;
self setClientDvar("temp_bool",isDefined(level.toolsID[self.inv[realid].item]));
}
}
}
}
else if(menu==game["menu_puzzle"])
{
if(isDefined(self.puzzle))
{
if(response=="close")
{
self notify("endpuzzle");
}
else if(response=="turn")
{
self.puzzle.turn*=-1;

if(self.puzzle.turn==1)
self setClientDvar("temp","");
else
 self setClientDvar("temp","2");
}
}
}
else if(menu==game["menu_tutorial"])
{
if(response=="gotut")
{
x=sql_query("SELECT ip, count_all, count_max FROM servers WHERE gamemode = 'tutorial' AND heartbeat >= "+(getRealTime()-60));
max=0;
ip="";
for(i=0;true;i++)
{
s=sql_fetch(x);
if(isDefined(s))
{
c=int(s[2])-int(s[1]);
if(c>max)
{
ip=s[0];
max=c;
}
}
else
{
break;
}
}

self closeMenus();
if(max)
self maps\mp\gametypes\apb::clientExec("disconnect; connect "+ip);
else
 self newMessage("^1"+level.s["NO_TUT_DISTRICT_"+self.lang]+"!");
}
else if(level.tutorial)
{
if(response=="next")
{
if(!isDefined(self.tut))
{
self.tut=2;
self setClientDvar("tutid",2);
}
else if(self.tut==2)
{
self closeMenus();
}
else if(self.tut==6)
{
self closeMenus();
self notify("tut_beginmission");
}
else if(self.tut==10)
{

self closeMenu();
self openMenu(game["menu_servers"]);
}
else
{
self.tut++;
self setClientDvar("tutid",self.tut);
}
}
}
}
else if(menu==game["menu_servers"])
{
if(response=="query")
{
self refreshServers();
}
else if(response=="connect")
{
if(isDefined(self.serverID))
{
self closeMenus();
self maps\mp\gametypes\apb::clientExec("disconnect; connect "+self.serverlist[self.serverID]);
}
}
else if(response=="close")
{
if(!isDefined(self.tut)||self.tut!=10)
{
self.serverlist=undefined;
self.serverID=undefined;
self.serverFilter=undefined;
}
}
else if(isSubStr(response,"filter:"))
{
f=getSubStr(response,7);

if(isDefined(level.gamemodes[f]))
self.serverFilter=f;
else
 self.serverFilter=undefined;

self refreshServers();
}
else if(isDefined(self.serverlist))
{
id=int(response);
if(isDefined(self.serverlist[id]))
{
self.serverID=id;
}
}
}
else if(menu==game["menu_mail"])
{
if(response=="query")
{
self.pageindex=0;
self.weaponid=undefined;
self setClientDvars(
"pageindex",0,
"weaponid","-1"
);

x=sql_query("SELECT sender, subject, body, attachment, date, read FROM msg WHERE name = '"+self.showname+"'");
for(i=0;true;i++)
{
s=sql_fetch(x);
if(isDefined(s))
{
self.messages[i]["sender"]=s[0];
self.messages[i]["subject"]=s[1];
self.messages[i]["body"]=s[2];
self.messages[i]["attachment"]=s[3];
self.messages[i]["date"]=int(s[4]);
self.messages[i]["read"]=int(s[5]);
}
else
{
break;
}
}


if(isDefined(self.messages))
self queryMails();
else
 self setClientDvar("mails",0);


















}
else if(response=="clear")
{
self.pageindex=undefined;
self.weaponid=undefined;
self.messages=undefined;
}
else if(response=="send")
{
to=self getUserInfo("info");
sub=self getUserInfo("info2");
body=self getUserInfo("info3");
if(to.size&&sub.size&&body.size)
{
to=playerName(toLower(to));
if(isDefined(to)&&to!=self.showname)
{

date=getRealTime();



sql_exec("INSERT INTO msg (name, sender, subject, body, date, msgid) VALUES ('"+to+"', '"+self.showname+"', '"+sql_escape(sub)+"', '"+sql_escape(body)+"', "+date+", (SELECT COUNT(*) FROM msg WHERE name = '"+to+"'))");
self setClientDvars(
"done",1,
"error","",
"mail_to","",
"mail_subject","",
"mail_body",""
);
self closeMenus();















}
else
{
self setClientDvar("error","NOUSER");
}
}
else
{
self setClientDvar("error","NOFILL");
}
self setClientDvar("fade",0);
}
else if(isDefined(self.messages))
{
if(response=="getatt")
{
id=self.pageindex*10+self.weaponid;
if(isDefined(self.messages[id])&&self.messages[id]["attachment"]!="0")
{
key=getSubStr(self.messages[id]["attachment"],0,2);
value=int(getSubStr(self.messages[id]["attachment"],2));
valid=false;
switch(key)
{
case"WE":
valid=self giveWeap(value);
break;
}
if(valid)
{
self.messages[id]["attachment"]="0";
self setClientDvar("message"+self.weaponid+"_attachment","");
sql_exec("UPDATE msg SET attachment = '0' WHERE name = '"+self.showname+"' AND msgid = "+id+"");
}
}
}
else if(response=="next")
{
if(self.messages.size>(self.pageindex+1)*10)
{
self.pageindex++;
self.weaponid=undefined;
self setClientDvars(
"pageindex",self.pageindex,
"weaponid","-1"
);
self queryMails();
}
}
else if(response=="prev")
{
if(self.pageindex)
{
self.pageindex--;
self.weaponid=undefined;
self setClientDvars(
"pageindex",self.pageindex,
"weaponid","-1"
);
self queryMails();
}
}
else if(response=="reply")
{
id=self.pageindex*10+self.weaponid;
if(isDefined(isDefined(self.messages[id])))
{
if(getSubStr(self.messages[id]["subject"],0,4)=="RE: ")
sub="";
else
 sub="RE: ";

self setClientDvars(
"mail_to",self.messages[id]["sender"],
"mail_subject",sub+self.messages[id]["subject"]
);
}
}
else if(response=="del")
{
id=self.pageindex*10+self.weaponid;
if(isDefined(self.messages[id]))
{

if(!self.messages[id]["read"])
self.newmails--;

sql_exec("DELETE FROM msg WHERE name = '"+self.showname+"' AND msgid = "+id);
if(self.messages.size==1)
{
self.messages=[];
}
else
{
{__c=self.messages.size-1;if(id==__c){self.messages[id]=undefined;}else{for(__i=__c;__i<__c;__i++){self.messages[__i]=self.messages[__i+1];}}}
sql_exec("UPDATE msg SET msgid = msgid - 1 WHERE name = '"+self.showname+"' AND msgid > "+id);
}
if(id==self.messages.size&&!(self.messages.size%10)&&self.pageindex==int(self.messages.size/10))
{
if(self.pageindex)
{
self.pageindex--;
self.weaponid=0;
self setClientDvars(
"pageindex",self.pageindex,
"weaponid",0
);
}
else
{
self.weaponid=undefined;
self setClientDvar("weaponid","-1");
}
}
else if(self.weaponid)
{
self.weaponid--;
self setClientDvar("weaponid",self.weaponid);
}

self queryMails();


c=self.messages.size;
self setClientDvars(
"allmails",c,
"newmails",self.newmails,
"message"+c+"_sender","",
"message"+c+"_subject","",
"message"+c+"_body","",
"message"+c+"_attachment","",
"message"+c+"_date","",
"message"+c+"_read",""
);
}
}
else
{
index=int(response);
id=self.pageindex*10+index;
if(isDefined(self.messages[id])&&(!isDefined(self.weaponid)||self.weaponid!=index))
{
self.weaponid=index;
self setClientDvar("weaponid",index);
if(!self.messages[id]["read"])
{
self.messages[id]["read"]=1;
self setClientDvar("message"+index+"_read",1);
self.newmails--;
self setClientDvar("newmails",self.newmails);
sql_exec("UPDATE msg SET read = 1 WHERE name = '"+self.showname+"' AND msgid = "+id);

}
}
}
}
}
else if(menu==game["menu_studio"])
{
if(response=="setup")
{
self.weaponid=0;
self setClientDvars(
"weaponid",0,
"save","",
"studio_theme_active",self.info["theme"]
);
__v9=self.themes;__c9=__v9.size;for(i=0;i<__c9;i++)
{
self setClientDvars(
"studio_theme"+i,__v9[i].name,
"studio_theme"+i+"_time",self themeLength(i)
);
}i=undefined;__c9=undefined;__v9=undefined;
}
else if(response=="setupcomposer")
{
self.studio["cur"]=1;
self.studio["cell"]=0;
self.studio["track1"]=[];
self.studio["track1_type"]="8bit";
self.studio["track1_sound"]=true;
self setClientDvars(
"studio_cell","",
"studio_cur_instrument",level.themes["8bit"]["title"],
"studio_cur_rows",level.themes["8bit"]["rows"],
"studio_cur_track",1,
"studio_track1_sound",1,
"studio_track2_sound",1,
"studio_track3_sound",1,
"studio_track4_sound",1,
"studio_track5_sound",1,
"studio_track6_sound",1
);
for(i=0;i<32;i++)
{
self setClientDvar("studio_node"+i,"");
}
}
else if(response=="delete")
{
c=self.themes.size;
if(isDefined(self.weaponid)&&self.weaponid>=0&&self.weaponid<c&&self.info["theme"]!=self.weaponid)
{
self.themeList[self.themes[self.weaponid].name]=undefined;

sql_exec("DELETE FROM themes WHERE name = '"+self.showname+"' AND themeid = "+self.weaponid);
if(self.weaponid!=c-1)
{
for(i=self.weaponid;i<c-1;i++)
{
self.themes[i]=self.themes[i+1];
self setClientDvars(
"studio_theme"+i,self.themes[i].name,
"studio_theme"+i+"_time",themeLength(i),
"themes",c
);
}
sql_exec("UPDATE themes SET themeid = themeid - 1 WHERE name = '"+self.showname+"' AND themeid > "+self.weaponid);
}
c--;
self.themes[c]=undefined;
if(self.info["theme"]>self.weaponid)
{
self.info["theme"]--;
self setClientDvar("studio_theme_active",self.info["theme"]);


}
self setClientDvars(
"studio_theme"+c,"",
"studio_theme"+c+"_time","",
"themes",c,
"weaponid",0
);



self.weaponid=0;
}
}
else if(response=="default")
{
if(isDefined(self.weaponid)&&self.weaponid>=0&&self.weaponid<self.themes.size&&self.info["theme"]!=self.weaponid)
{
self.info["theme"]=self.weaponid;
self setClientDvars(
"studio_theme_active",self.info["theme"],
"theme",self.themes[self.info["theme"]].name
);
self playLocalSound("Change");


}
}
else if(response=="load")
{
if(isDefined(self.weaponid)&&self.weaponid>=0&&self.weaponid<self.themes.size)
{
id=self.weaponid;
for(i=0;i<8;i++)
{
t="track"+(i+1);
self.studio[t]=[];
self.studio[t+"_type"]=self.themes[id].tracks[i].type;
self.studio[t+"_sound"]=true;
for(j=0;j<32;j++)
{
if(isDefined(self.themes[id].tracks[i].nodes[j]))
{
self.studio[t][j]=self.themes[id].tracks[i].nodes[j];

if(!i)
{
self setClientDvar("studio_node"+j,self.studio[t][j]);
}
}
else if(!i)
{
self setClientDvar("studio_node"+j,"");
}
}
}
self.studio["cur"]=1;
self.studio["cell"]=0;
self setClientDvars(
"save",self.themes[id].name,
"studio_cell","",
"studio_cur_instrument",level.themes[self.themes[id].tracks[0].type]["title"],
"studio_cur_rows",level.themes[self.themes[id].tracks[0].type]["rows"],
"studio_cur_track",1,
"studio_theme_active",self.info["theme"],
"studio_track1_sound",1,
"studio_track2_sound",1,
"studio_track3_sound",1,
"studio_track4_sound",1,
"studio_track5_sound",1,
"studio_track6_sound",1
);
}
}
else
{
id=int(response);
if(id>=0&&id<self.themes.size)
{
self.weaponid=id;
self setClientDvar("weaponid",id);
}
}
}
else if(menu==game["menu_composer"])
{
if(isDefined(self.studio))
{
if(response=="clear")
{
self notify("studio_stop");
self.studio=undefined;
}
else if(response=="play")
{
if(isDefined(self.studio["paused"]))
{
self.studio["paused"]=undefined;
}
else
{
self notify("studio_stop");
self.studio["cell"]=0;
}
self thread playStudio();
}
else if(response=="pause")
{
self.studio["paused"]=true;
self notify("studio_stop");
}
else if(response=="stop")
{
self notify("studio_stop");
self.studio["cell"]=0;
self setClientDvar("studio_cell","");
}
else if(response=="save")
{
name=self getUserInfo("info");

exists=isDefined(self.themeList[name]);
c=self.themes.size;
if(name!=""&&name.size<=15&&(c<8||exists))
{
if(!exists)
{
id=c;
self.themeList[name]=id;
self.themes[id]=spawnStruct();
self.themes[id].name=name;
self setClientDvars(
"studio_theme"+id,name,
"themes",id+1
);
}
else
{
id=self.themeList[name];
}
for(j=0;j<8;j++)
{
t="track"+(j+1);
self.themes[id].tracks[j]=spawnStruct();
if(isDefined(self.studio[t+"_type"]))
{
self.themes[id].tracks[j].type=self.studio[t+"_type"];
self.themes[id].tracks[j].nodes=[];
for(k=0;k<32;k++)
{
if(isDefined(self.studio[t][k]))
{
self.themes[id].tracks[j].nodes[k]=self.studio[t][k];
}
}
}
else
{
self.themes[id].tracks[j].type="8bit";
self.themes[id].tracks[j].nodes=[];
}
}
self setClientDvar("studio_theme"+id+"_time",self themeLength(id));


s=name+":";
for(j=0;j<8;j++)
{
if(j)
s+="|";

s+=self.themes[id].tracks[j].type+"-";
for(k=0;k<32;k++)
{
if(k)
s+=",";

if(isDefined(self.themes[id].tracks[j].nodes[k]))
s+=self.themes[id].tracks[j].nodes[k];
else
 s+=" ";
}
}
if(exists)
sql_exec("UPDATE themes SET theme = '"+s+"' WHERE name = '"+self.showname+"' AND themeid = "+id);
else
 sql_exec("INSERT INTO themes (name, theme, themeid) VALUES ('"+self.showname+"', '"+s+"', "+id+")");


}
}
else if(isDefined(level.themes[response]))
{
self setClientDvars(
"studio_cur_instrument",level.themes[response]["title"],
"studio_cur_rows",level.themes[response]["rows"]
);
self.studio["track"+self.studio["cur"]+"_type"]=response;
}
else if(isSubStr(response,"sound:"))
{
id=int(getSubStr(response,6));
if(id>=1&&id<=6)
{
elem="track"+id+"_sound";

if(isDefined(self.studio[elem]))
self.studio[elem]=!self.studio[elem];
else
 self.studio[elem]=0;

self setClientDvar("studio_"+elem,self.studio[elem]);
}
}
else if(isSubStr(response,"track:"))
{
id=int(getSubStr(response,6));
if(id>=1&&id<=6&&id!=self.studio["cur"])
{
self.studio["cur"]=id;
self setClientDvar("studio_cur_track",id);
if(!isDefined(self.studio["track"+id]))
{
self.studio["track"+id]=[];
self.studio["track"+id+"_type"]="8bit";
self setClientDvars(
"studio_cur_instrument",level.themes["8bit"]["title"],
"studio_cur_rows",level.themes["8bit"]["rows"]
);

if(!isDefined(self.studio["track"+id+"_sound"]))
self.studio["track"+id+"_sound"]=1;

for(i=0;i<32;i++)
{
self setClientDvar("studio_node"+i,"");
}
}
else
{
self setClientDvars(
"studio_cur_instrument",level.themes[self.studio["track"+id+"_type"]]["title"],
"studio_cur_rows",level.themes[self.studio["track"+id+"_type"]]["rows"]
);
for(i=0;i<32;i++)
{
if(isDefined(self.studio["track"+id][i]))
self setClientDvar("studio_node"+i,self.studio["track"+id][i]);
else
 self setClientDvar("studio_node"+i,"");
}
}
}
}
else
{
row=int(response);
if(row>=0&&row<level.themes[self.studio["track"+self.studio["cur"]+"_type"]]["rows"])
{
col=int(self getUserInfo("info"));
if(col==32)
{
if(row>=0&&row<level.themes[self.studio["track"+self.studio["cur"]+"_type"]]["rows"])
{
id="theme_"+self.studio["track"+self.studio["cur"]+"_type"]+"_"+row;
self playLocalSound(id);
maps\mp\gametypes\apb::addClearTheme(id);
}
}
else if(col>=0&&col<32)
{
if(isDefined(self.studio["track"+self.studio["cur"]][col])&&self.studio["track"+self.studio["cur"]][col]==row)
{
self.studio["track"+self.studio["cur"]][col]=undefined;
self setClientDvar("studio_node"+col,"");
}
else
{
self.studio["track"+self.studio["cur"]][col]=row;
self setClientDvar("studio_node"+col,row);
}
}
}
}
}
}
else if(menu==game["menu_groupmgr"])
{
if(isDefined(self.group))
{
if(response=="kick")
{
if(isDefined(self.groupmgrid)&&isDefined(self.groupleader))
{
id=self.groupmgrid;


t=level.groups[self.group].team;
c=t.size;
if(id>=0&&id<c&&t[id]!=self)
{
k=t[id];


for(__i10=0;__i10<c;__i10++)
{
__e10=t[__i10];if(k==__e10)
k newMessage("^2"+level.s["YOU_KICKED_FROM_GROUP_"+k.lang]+"!");
else
 __e10 newMessage("^2"+k.showname+" "+level.s["KICKED_FROM_GROUP_"+__e10.lang]+"!");
}__i10=undefined;


if(c>2)
{
t maps\mp\gametypes\apb::quitGroup();
{__c=level.groups[self.group].team.size-1;if(id!=__c)level.groups[self.group].team[id]=level.groups[self.group].team[__c];level.groups[self.group].team[__c]=undefined;}
if(!isDefined(self.missionId))
{
maps\mp\gametypes\apb::refreshGroup(self.group);
}
}
else
{
maps\mp\gametypes\apb::abandonGroup(self.group);
}
self closeMenus();
self.groupmgrid=undefined;
}
}
}
else if(response=="leave")
{
g=self.group;
t=level.groups[g].team;
c=t.size;
if(c>2)
{
{__c=level.groups[g].team.size;if(__c>1){for(i=0;i<__c;i++){if(level.groups[g].team[i]==self){last=__c-1;if(i<last)level.groups[g].team[i]=level.groups[g].team[last];level.groups[g].team[last]=undefined;break;}}}else{level.groups[g].team=[];}}
if(isDefined(self.groupleader))
{
self.groupleader=undefined;
r=0;
for(i=1;i<c;i++)
{
if(t[i].rating>t[r].rating)
{
r=i;
}
}
level.groups[g].leader=t[r];
t[r].groupleader=true;
t[r]setClientDvar("inviting",1);
}

if(isDefined(self.missionId))
maps\mp\gametypes\apb::refreshTeam(self.missionTeam);
else
 maps\mp\gametypes\apb::refreshGroup(self.group);

for(i=1;i<c;i++)
{
t newMessage("^2"+self.showname+" "+level.s["LEFT_GROUP_"+t.lang]+"!");
}
self newMessage("^2"+level.s["YOU_LEFT_GROUP_"+self.lang]+"!");
self maps\mp\gametypes\apb::quitGroup();
}
else
{
maps\mp\gametypes\apb::abandonGroup(self.group);
}
self closeMenus();
self.groupmgrid=undefined;
}
else if(response=="setleader")
{
if(isDefined(self.groupleader))
{
id=self.groupmgrid;
g=self.group;
t=level.groups[g].team;
c=t.size;
if(id>=0&&id<c&&t[id]!=self)
{
x=t[id];
self.groupleader=undefined;
self setClientDvar("inviting",0);
x.groupleader=true;
x setClientDvar("inviting",1);
level.groups[g].leader=x;

if(isDefined(self.missionId))
maps\mp\gametypes\apb::refreshTeam(self.missionTeam);
else
 maps\mp\gametypes\apb::refreshGroup(self.group);

for(i=0;i<c;i++)
{
__e11=t[i];if(__e11==self)
__e11 newMessage("^2"+level.s["YOU_NOT_GROUP_LEADER_"+__e11.lang]+"!");
else if(i==id)
__e11 newMessage("^2"+level.s["YOU_GROUP_LEADER_"+__e11.lang]+"!");
else
 __e11 newMessage("^2"+x.showname+" "+level.s["NEW_GROUP_LEADER_"+__e11.lang]+"!");
}i=undefined;
self closeMenus();
self.groupmgrid=undefined;
}
}
}
else if(response=="addasfriend")
{
if(isDefined(self.group)&&isDefined(level.groups[self.group].team[self.groupmgrid]))
{
self addFriend(level.groups[self.group].team[self.groupmgrid].showname);
}
}
else if(response=="clear")
{
self.groupmgrid=undefined;
}
else
{
t=level.groups[self.group].team;
c=t.size;
id=int(response);
if(id>=0&&id<c)
{
self.groupmgrid=id;
self setClientDvars(
"groupId",id,
"right",isDefined(self.groupleader)&&self.groupmgrid!=self.groupId
);
}
}
}
else
{
self setClientDvar("right",0);
}
}
else if(menu==game["menu_teammgr"])
{
if(isDefined(self.missionId))
{
if(response=="kick")
{
if(isDefined(self.teammgrid)&&isDefined(self.teamleader))
{
id=self.teammgrid;


t=level.teams[self.missionTeam];
c=t.size;
if(id>=0&&id<c&&t[id]!=self)
{
k=t[id];


__c12=t.size;for(__i12=0;__i12<__c12;__i12++)
{
__e12=t[__i12];if(k==__e12)
k newMessage("^5"+level.s["YOU_KICKED_FROM_TEAM_"+k.lang]+"!");
else
 __e12 newMessage("^5"+k.showname+" "+level.s["KICKED_FROM_TEAM_"+__e12.lang]+"!");
}__i12=undefined;__c12=undefined;


k maps\mp\gametypes\apb::kickTeam();
{__c=level.teams[self.missionTeam].size-1;if(id==__c){level.teams[self.missionTeam][id]=undefined;}else{for(__i=__c;__i<__c;__i++){level.teams[self.missionTeam][__i]=level.teams[self.missionTeam][__i+1];}}}
{__c=level.missions[self.missionId].all.size;if(__c>1){for(i=0;i<__c;i++){if(level.missions[self.missionId].all[i]==self){last=__c-1;if(i<last)level.missions[self.missionId].all[i]=level.missions[self.missionId].all[last];level.missions[self.missionId].all[last]=undefined;break;}}}else{level.missions[self.missionId].all=[];}}
level.missions[self.missionId].allCount--;
maps\mp\gametypes\apb::refreshTeam(self.missionTeam);

self closeMenus();
self.teammgrid=undefined;
}
}
}
else if(response=="setleader")
{
if(isDefined(self.teamleader))
{
id=self.teammgrid;
t=level.teams[self.missionTeam];
c=t.size;
if(id>=0&&id<c&&t[id]!=self)
{
l=t[id];
self.teamleader=undefined;
l.teamleader=true;

maps\mp\gametypes\apb::refreshTeam(self.missionTeam);

for(i=0;i<c;i++)
{
__e13=t[i];if(__e13==self)
__e13 newMessage("^5"+level.s["YOU_NOT_TEAM_LEADER_"+__e13.lang]+"!");
else if(i==id)
__e13 newMessage("^5"+level.s["YOU_TEAM_LEADER_"+__e13.lang]+"!");
else
 __e13 newMessage("^5"+l.showname+" "+level.s["NEW_TEAM_LEADER_"+__e13.lang]+"!");
}i=undefined;
self closeMenus();
self.teammgrid=undefined;
}
}
}
else if(response=="addasfriend")
{
if(isDefined(self.missionId)&&isDefined(level.teams[self.missionTeam][self.teammgrid]))
{
self addFriend(level.teams[self.missionTeam][self.teammgrid].showname);
}
}
else if(response=="clear")
{
self.teammgrid=undefined;
}
else
{
id=int(response);
t=level.teams[self.missionTeam];
c=t.size;
if(id>=0&&id<c)
{
self.teammgrid=id;
self setClientDvars(
"teamid",id,
"right",isDefined(self.teamleader)&&self.teammgrid!=self.teamId
);
}
}
}
else
{
self setClientDvar("right",0);
}
}
else if(menu==game["menu_friendmgr"])
{
if(response=="addfriend")
{
self addFriend(playerName(toLower(self getUserInfo("info"))));
}
else if(response=="delete")
{
if(!isDefined(self.friendid))
continue;

sql_exec("DELETE FROM friends WHERE name = '"+self.showname+"' AND friendid = "+self.friendid);
c=self.friends.size;
if(c>1)
{
last=c-1;
if(self.friendid!=last)
{
for(i=self.friendid;i<last;i++)
{
self.friends[i]=self.friends[i+1];
self setClientDvars(
"temp"+i,self.friends[i],
"temp"+i+"_type",checkStatus(self.friends[i])
);
}
sql_exec("UPDATE friends SET friendid = friendid - 1 WHERE name = '"+self.showname+"' AND friendid > "+self.friendid);
}
self.friends[last]=undefined;
self setClientDvars(
"temp_count",last,
"friendid",0,
"temp"+last,"",
"temp"+last+"_type",""
);
self.friendid=0;
}
else
{
self.friends=[];
self setClientDvars(
"temp_count",0,
"friendid","",
"temp0","",
"temp0_status",""
);
self.friendid=undefined;
}


}
else if(response=="invitegroup")
{
if(!isDefined(self.friendid))
continue;

self inviteGroup(self.friends[self.friendid]);
}
else if(response=="clear")
{
if(isDefined(self.friendid))
{
self.friendid=undefined;
}
}
else if(response=="setup")
{
c=self.friends.size;
if(c)
{
self setClientDvar("friendid",0);
self.friendid=0;
if(c){__v14=self.friends;for(i=0;i<c;i++)
{
self setClientDvars(
"temp"+i,__v14[i],
"temp"+i+"_type",checkStatus(__v14[i])
);
}i=undefined;__v14=undefined;}
}
}
else
{
id=int(response);
if(id>=0&&id<self.friends.size)
{
self setClientDvar("friendid",id);
self.friendid=id;
}
}
}
else if(menu==game["menu_warzone"]||menu==game["menu_clanmgr"]||menu==game["menu_treasury"])
{











if(isDefined(self.ownClan))
{
clan=self.ownClan;
rank=5;
}
else
{

clan="";
rank=0;

x=sql_fetch(sql_query("SELECT clan, rank FROM members WHERE name = '"+self.showname+"'"));
if(isDefined(x))
{
clan=x[0];
rank=int(x[1]);
if(rank==5)
self.ownClan=clan;
}
}

if(menu==game["menu_clanmgr"])
{
if(clan!="")
{
if(response=="setup")
{
self refreshClan(clan,rank);
}
else if(isDefined(self.clanid))
{
if(response=="kick")
{

if(self.clanlist[self.clanid].name!=self.showname&&rank>=2&&rank>self.clanlist[self.clanid].rank&&int(sql_query_first("SELECT EXISTS(SELECT * FROM members WHERE name = '"+self.clanlist[self.clanid].name+"' AND clan = '"+clan+"')"))){
sql_exec("DELETE FROM members WHERE name = '"+self.clanlist[self.clanid].name+"'");
self refreshClan(clan,rank);




















}
}
else if(response=="quit")
{

if(rank==5){
self.ownClan=undefined;
sql_exec("DELETE FROM don WHERE clan = '"+clan+"'");
sql_exec("DELETE FROM members WHERE clan = '"+clan+"'");
sql_exec("DELETE FROM clans WHERE clan = '"+clan+"'");
}
else
{
sql_exec("DELETE FROM members WHERE name = '"+self.showname+"'");
}

self setClientDvars(
"clan","",
"clanid",""
);


self clearClanMgr();
}
else if(response=="invitegroup")
{
self inviteGroup(self.clanlist[self.clanid].name);
}
else if(response=="addasfriend")
{
self addFriend(self.clanlist[self.clanid].name);
}
else if(response=="inviteclan")
{
if(level.tutorial)
continue;

if(rank>=1)
{
name=self getUserInfo("info");

inv=playerName(toLower(name));
if(isDefined(inv)&&isDefined(level.online[inv]))
{
if(self.showname!=inv)
{
u=level.online[inv];
if(u.team==self.team)
{
if(u.spawned)
{
if(!int(sql_query_first("SELECT EXISTS(SELECT * FROM members WHERE name = '"+inv+"')")))
{
if(!isDefined(u.invited)&&!isDefined(u.claninvited))
{
u.claninvited=self.showname;
if(!isDefined(u.missionId)&&!isDefined(self.missionId))
{
if(self.ready)
self maps\mp\gametypes\apb::unreadyPlayer();

self newMessage("^2"+level.s["YOUINVITED_"+self.lang]+": "+inv);
u inviteHUD(self.showname+" "+level.s["INVITE_BODY_CLAN_"+u.lang]);


}
else
{
self newMessage("^1"+level.s["USERINMISSION_"+self.lang]+"!");
}
}
else
{
self newMessage("^1"+level.s["USERINVITED_"+self.lang]+"!");
}
}
else
{
self newMessage("^1"+level.s["USERHASCLAN_"+self.lang]+"!");
}
}
else
{
self newMessage("^1"+level.s["USERNOTSPAWNED_"+self.lang]+"!");
}
}
else
{
self newMessage("^1"+level.s["ANOTHERTEAM_"+self.lang]+"!");
}
}
else
{
self newMessage("^1"+level.s["INVITE_YOURSELF_"+self.lang]+"!");
}
}
else
{
self newMessage("^1"+name+" "+level.s["NOT_ONLINE_"+self.lang]+"!");
}
}
else
{
self newMessage("^1"+level.s["NOT_CLANLEADER_"+self.lang]+"!");
}

self closeMenus();
}
else if(response=="clear")
{
self clearClanMgr();
}
else if(response=="nextpage")
{
t=(self.clanpage+1)*26;
c=self.clanlist.size;
if(t<c)
{
self.clanid=0;
self.clanpage++;
self setClientDvars(
"clanpage",self.clanpage,
"clanid",0
);
for(i=0;i<26;i++)
{
if(t<c)
{
r=self.clanlist[t];
self setClientDvars(
"temp"+i,r.name,
"temp"+i+"_type",r.rank,
"temp"+i+"_type2",r.status
);
t++;
}
else
{
self setClientDvars(
"temp"+i,"",
"temp"+i+"_type","",
"temp"+i+"_type2",""
);
}
}
}
}
else if(response=="prevpage")
{
if(self.clanpage)
{
self.clanid=0;
self.clanpage--;
self setClientDvars(
"clanpage",self.clanpage,
"clanid",0
);
t=self.clanpage*26;
for(i=0;i<26;i++)
{
r=self.clanlist[t];
self setClientDvars(
"temp"+i,r.name,
"temp"+i+"_type",r.rank,
"temp"+i+"_type2",r.status
);
t++;
}
}
}
else if(isSubStr(response,"setrank:"))
{
newrank=int(getSubStr(response,8));
oldrank=sql_query_first("SELECT rank FROM members WHERE name = '"+self.clanlist[self.clanid].name+"' AND clan = '"+clan+"'");

if(isDefined(oldrank)&&rank>=3&&newrank>=0&&newrank<rank&&int(oldrank)<rank){
sql_exec("UPDATE members SET rank = "+newrank+" WHERE name = '"+self.clanlist[self.clanid].name+"'");
self.clanlist[self.clanid].rank=newrank;
self setClientDvar("temp"+(self.clanid%26)+"_type",newrank);
}
}
else
{
id=int(response);
if(id>=0&&id<self.clanlist.size)
{
self setClientDvar("clanid",id);
self.clanid=id+self.clanpage*26;
}
}
}
}
else if(response=="create")
{
clan=self getUserInfo("info");

if(clan.size)
{
if(!validName(clan,true))
{
self newMessage("^1"+level.s["INVALIDNAME_"+self.lang]+"!");
self closeMenus();
}
else
{
if(!int(sql_query_first("SELECT EXISTS(SELECT * FROM clans WHERE clan = '"+clan+"')")))
{

sql_exec("INSERT INTO clans (clan) VALUES ('"+clan+"')");
sql_exec("INSERT INTO members (name, clan, rank) VALUES ('"+self.showname+"', '"+clan+"', 5)");
self setClientDvars(
"clanid",0,
"clan",clan,
"clanrank",5,
"clan0",self.showname,
"clan0_rank",5,
"clan0_status",level.server
);
self.clanid=0;
self.clanpage=0;
self.clanlist[0]=spawnStruct();
self.clanlist[0].name=self.showname;
self.clanlist[0].rank=5;
}
else
{
self newMessage("^1"+level.s["CLAN_EXISTS_"+self.lang]+"!");
}
}
}
}
}
else if(clan!="")
{
if(menu==game["menu_warzone"])
{
if(response=="setup")
{
if(isDefined(self.group)&&isClanGroup(self.group))
self refreshWarZone();
else
 self setClientDvar("error",level.s["NO_CLANTEAM_"+self.lang]);

self refreshWarStats(clan);
}
else if(response=="challenge")
{
if(isDefined(level.online[self.warlist[self.warid]])&&canChallenge(self,level.online[self.warlist[self.warid]]))
{

self closeMenus();
self newMessage("^5"+level.s["YOU_CHALLENGED_"+self.lang]+": "+level.online[self.warlist[self.warid]].showname);
level.online[self.warlist[self.warid]].challenged=self;
level.online[self.warlist[self.warid]] inviteHUD(self.showname+" "+level.s["CHALLENGED_YOU_"+level.online[self.warlist[self.warid]].lang]);

}
else
{
self refreshWarZone(clan);
}
}
else if(isDefined(self.warid))
{
if(response=="clear")
{
t=self.warlist.size;
for(i=0;i<t;i++)
{
self setClientDvars(
"warid","",
"war"+i,"",
"war"+i+"_type","",
"war"+i+"_status","",
"war"+i+"_leader",""
);
}

if(isDefined(self.wars))
{
self.wars=undefined;
self setClientDvar("stat_wars","");
}
self.warid=undefined;
self.warlist=undefined;
}
else
{
id=int(response);
if(id>=0&&id<self.warlist.size)
{
self setClientDvar("warid",id);
self.warid=id;
}
}
}
}
else
{

if(response=="setup")
{
self.trepage=0;
self refreshTreasury(clan,rank>=4);
}
else if(response=="nextpage")
{
if((self.trepage+1)*16<int(sql_query_first("SELECT COUNT(*) FROM don WHERE clan = '"+clan+"'")))
{
self.trepage++;
self refreshTreasury(clan,rank>=4);
}
}
else if(response=="prevpage")
{
if(self.trepage)
{
self.trepage--;
self refreshTreasury(clan,rank>=4);
}
}
else if(response=="buycolor")
{
if(isDefined(self.clancol))
{
c=sql_fetch(sql_query("SELECT cash - 500000, color FROM clans WHERE clan = '"+clan+"'"));
if(self.clancol!=int(c[1])&&int(c[0])>=0)
{
sql_exec("UPDATE clans SET cash = "+c[0]+", color = "+self.clancol+" WHERE clan = '"+clan+"'");
self setClientDvars(
"weaponid",c[0],
"clan_color",self.clancol
);
}
}
}
else if(response=="buyrank")
{
c=sql_fetch(sql_query("SELECT cash, rank FROM clans WHERE clan = '"+clan+"'"));
r=int(c[1]);
m=int(c[0])-level.clanRanks[r];
if(r!=level.maxClanRank&&m>=0)
{
r++;
sql_exec("UPDATE clans SET cash = "+m+", rank = "+r+" WHERE clan = '"+clan+"'");
self setClientDvars(
"weaponid",m,
"clan_rank",r
);


if(isDefined(self.missionId))
{
id=self.clientid;
r=r+"_"+self.team;
__v15=level.teams[self.missionTeam];__c15=__v15.size;if(__c15){for(__i15=0;__i15<__c15;__i15++)
{
__v15[__i15].playerStats[id].clan_crank=r;
}__i15=undefined;}__c15=undefined;__v15=undefined;
__v16=level.teams[self.enemyTeam];__c16=__v16.size;if(__c16){for(__i16=0;__i16<__c16;__i16++)
{
__v16[__i16].playerStats[id].clan_crank=r;
}__i16=undefined;}__c16=undefined;__v16=undefined;
}
}
}
else if(response=="clear")
{
if(isDefined(self.trepage))
self.trepage=undefined;
if(isDefined(self.clancol))
self.clancol=undefined;
}
else if(response=="pay")
{
c=int(self getUserInfo("info"));
if(c&&c<=self.info["money"])
{
self maps\mp\gametypes\apb::giveMoney(c*-1);
sql_exec("UPDATE clans SET cash = cash + "+c+" WHERE clan = '"+clan+"'");
sql_exec("INSERT INTO don (name, cash, time, clan) VALUES ('"+self.showname+"', "+c+", "+getRealTime()+", '"+clan+"')");
self refreshTreasury(clan,rank>=4);
}
}
else if(isSubStr(response,"col:"))
{
c=int(getSubStr(response,4));
if(c==1||c==2||c==3||c==4||c==5||c==6||c==8)
{
self.clancol=c;
}
}
}
}
}
else if(menu==game["menu_chat"])
{
if(response=="send")
{
self setClientDvar("cmd","");
self maps\mp\gametypes\apb::Callback_PlayerSay(self getUserInfo("info"));
}

else if(self.info["admin"])
{
if(response=="spectator")
{
if(4&self.info["admin"]&&!isDefined(self.missionId)&&!self.ready&&!isDefined(self.group))
{
if(self.sessionstate=="spectator")
{

self maps\mp\gametypes\apb::joinTeam();
}
else
{
self moveToSpectator();
}
}
}
else if(response=="bug")
{
if(8&self.info["admin"])
{
self.bugpage=0;
self queryBugs();
self.bugCount=int(sql_query_first("SELECT COUNT(*) FROM bugs"));
self setClientDvars(
"bugs",self.bugCount,
"bugpage",0
);
}
}
else if(response=="players")
{
if(2&self.info["admin"])
{
self refreshPlayerList();
}
}
else if(isDefined(self.players))
{
switch(response)
{
case"nochat":
self.players=undefined;
self.playerid=undefined;
break;
case"spectate":
p=self.players[self.playerid];


if(isDefined(p)&&p!=self){
if(p.spawned)
{
if(self.sessionstate!="spectator")
self moveToSpectator();

self.spectatorclient=p getEntityNumber();
self closeMenus();
}
}
else
 self refreshPlayerList();
break;
case"kick":
p=self.players[self.playerid];

if(isDefined(p))
{

p setClientDvar("kicked",self getUserInfo("info"));
p maps\mp\gametypes\apb::clientExec("disconnect");
}
else
 self refreshPlayerList();
break;
case"kill":
p=self.players[self.playerid];

if(isDefined(p))
{
if(p.spawned)
p suicide();
}
else
 self refreshPlayerList();
break;
default:
id=int(response);
if(id>=0&&id<self.players.size)
self.playerid=id;
else
 self refreshPlayerList();
break;
}
}
else if(isDefined(self.bugs))
{
if(response=="bugnext")
{
if(self.bugCount>(self.bugpage+1)*10)
{
self.bugpage++;
self.bugid=undefined;
self setClientDvars(
"bugid","",
"bugpage",self.bugpage
);
self queryBugs();
}
}
else if(response=="bugprev")
{
if(self.bugpage)
{
self.bugpage--;
self.bugid=undefined;
self setClientDvars(
"bugid","",
"bugpage",self.bugpage
);
self queryBugs();
}
}
else if(response=="nochat")
{
self.bugpage=undefined;
self.bugs=undefined;
self.bugid=undefined;
self setClientDvar("bugid","");
}
else if(response=="accept")
{
if(isDefined(self.bugid))
{
sql_exec("UPDATE bugs SET status = 0 WHERE bugid = "+self.bugs[self.bugid]);
self queryBugs();
}
}
else if(response=="delete")
{
if(isDefined(self.bugid))
{
sql_exec("DELETE FROM bugs WHERE bugid = "+self.bugs[self.bugid]);
self.bugpage=0;
self.bugid=undefined;
self setClientDvars(
"bugid","",
"bugpage",0
);
self queryBugs();
}
}
else
{
id=int(response);
if(id>=0&&self.bugCount>self.bugpage*10+id)
{
self.bugid=id;
self setClientDvar("bugid",id);
}
}
}







}
}
else if(menu==game["menu_class"])
{
if(response=="playmusic")
{
if(isDefined(self.weaponid))
{
id=int(self.weaponid);
if(id>=0&&id<20)
{
if(isDefined(self.playing))
{
self notify("stopmusic");
self stopLocalSound("music"+self.playing);
}
self.playing=id;
self thread maps\mp\gametypes\apb::playMusic();
}
}
}
else if(response=="stopmusic")
{
if(isDefined(self.playing))
{
self notify("stopmusic");
self stopLocalSound("music"+self.playing);
self maps\mp\gametypes\apb::clearMusic();
}
}
else if(isSubStr(response,"music:"))
{
id=getSubStr(response,6);
if(id!="")
{
self.weaponid=id;
self setClientDvar("weaponid",self.weaponid);
}
}
else if(isSubStr(response,"musicstatus:"))
{
id=getSubStr(response,12);
if(id=="all"||id=="one"||id=="repeat")
{
self.musicstatus=id;
}
}
else if(response=="language"||response=="set"||response=="bug")
{
if(response=="set")
{
self setClientDvars(
"format",level.format[self.info["format"]],
"date",level.date[self.info["date"]]
);
}
self closeMenus();
self maps\mp\gametypes\apb::openMixMenu(response);
}

else if(response=="change")
{
if(!isDefined(self.weaponid)||!isDefined(self.pageindex))
continue;

id=self.weaponid+self.pageindex*70;
if(isDefined(level.symbols[id])&&self.info["symbol"]!=id&&((!level.symbols[id].rare&&self.rating>=level.symbols[id].value)||(level.symbols[id].rare&&level.symbols[id].value&self.info["symbols"])))
{
self.info["symbol"]=id;
self setClientDvar("symbol",self.info["symbol"]);



}
}
else if(response=="nextpage")
{
if(self.pageindex<=level.symbolPages)
{
self.pageindex++;
self.weaponid=0;
self setClientDvars(
"pageindex",self.pageindex,
"symbolid",0
);
}
}
else if(response=="prevpage")
{
if(self.pageindex)
{
self.pageindex--;
self.weaponid=0;
self setClientDvars(
"pageindex",self.pageindex,
"symbolid",0
);
}
}
else if(response=="startmusic")
{

if(isDefined(self.playing))
self.weaponid=self.playing;
else
 self.weaponid="0";

self setClientDvar("weaponid",self.weaponid);
}
else if(response=="startimage")
{
self.pageindex=0;
self.weaponid=0;
self setClientDvars(
"pageindex",0,
"weaponid",0
);
}
else if(response=="clear")
{
if(isDefined(self.weaponid))
{
self.weaponid=undefined;
self.pageindex=undefined;
}
}
else if(isDefined(self.pageindex))
{
id=int(response);

if(id>=0&&id<70){
self.weaponid=id;
self setClientDvar("symbolid",id);
}
}
}
else if(menu==game["menu_profile"])
{
if(response=="accept")
{
x=int(sql_query_first("SELECT level1 + level2 FROM players WHERE name = '"+self.showname+"'"));
if(x)
{
sql_exec("UPDATE players SET level1 = 0, level2 = 0 WHERE name = '"+self.showname+"'");
self maps\mp\gametypes\apb::giveMoney(x);
self setClientDvars(
"award1",0,
"award2",0
);
self playLocalSound("Coin");
}
}
else
{
self getWeapPerks(self.info["prime"],"primarymod");


x=sql_fetch(sql_query("SELECT level1, level2 FROM players WHERE name = '"+self.showname+"'"));
self setClientDvars(
"referrer",self.info["inv"],
"invited",sql_query_first("SELECT COUNT(*) FROM players WHERE inv = '"+self.showname+"'"),
"award1",x[0],
"award2",x[1],
"mis_win",self.info["mis_win"],
"mis_lose",self.info["mis_lose"],
"mis_tied",self.info["mis_tied"],
"medals",self.info["medals"],
"backupcalled",self.info["backupcalled"],
"kills",self.info["kills"],
"arrests",self.info["arrests"],
"assists",self.info["assists"],
"startedgroups",self.info["startedgroups"],
"allrun",self.info["allrun"],
"regenhealth",self.info["regenhealth"],
"delivereditems",self.info["delivereditems"],
"missiontime",maps\mp\gametypes\apb::leftTimeToString(self.info["missiontime"]),
"prestigetime",maps\mp\gametypes\apb::leftTimeToString(self.info["prestigetime"])
);
}
}
else if(menu==game["menu_ammo"])
{
trig=self touching("ammo");
if(!isDefined(trig))
continue;

if(response=="buy")
{

if(!isDefined(self.weaponid))
continue;

if(!isDefined(level.ammoID[self.weaponid]))
continue;

count=int(self getUserInfo("info"));

if(count)
{
id=level.ammoID[self.weaponid];
allAmmo=count*level.ammos[id].count;
if(self.info["ammo_"+self.weaponid]+allAmmo>level.ammos[id].max)
{
count=int((level.ammos[id].max-self.info["ammo_"+self.weaponid])/level.ammos[id].count);
if(!count)
{
continue;
}
allAmmo=count*level.ammos[id].count;
}
price=count*level.ammos[id].cost;
if(price<=self.info["money"])
{
self maps\mp\gametypes\apb::giveMoney(price*-1);


ammoname="ammo_"+self.weaponid;
self.info[ammoname]+=allAmmo;
self setClientDvar(ammoname,self.info[ammoname]);


self playLocalSound("Coin");
}

}
}
else if(response=="resupply")
{
self maps\mp\gametypes\apb::checkResupply(trig);
}
else
{
self.weaponid=response;
self setClientDvar("weaponid",self.weaponid);
}
}
else if(isSubStr(response,"invite:"))
{
response=getSubStr(response,7);

if(isDefined(self.invited))
{
if(!isDefined(self.missionId))
{
if(response=="1")
{
p=self.invited;
if(isPlayer(p))
{
if(!isDefined(p.group))
{
g=level.groups.size;
level.groups[g]=spawnStruct();
level.groups[g].team[0]=p;
level.groups[g].team[1]=self;
level.groups[g].groupReady=false;
level.groups[g].inMission=false;
level.groups[g].side=self.team;
level.groups[g].leader=p;
p.group=g;
p.groupId=0;
self.group=g;
self.groupId=1;
p.groupleader=true;
self setClientDvar("inviting",0);

if(self.ready)
self maps\mp\gametypes\apb::unreadyPlayer();

if(p.ready)
p maps\mp\gametypes\apb::unreadyPlayer();

maps\mp\gametypes\apb::refreshGroup(self.group);

self.info["startedgroups"]++;
self setClientDvar("startedgroups",self.info["startedgroups"]);



if(self.info["startedgroups"]==100)
self maps\mp\gametypes\apb::giveAchievement("GROUPS");


}
else if(isDefined(p.groupleader))
{
if(level.groups[p.group].team.size<4)
{
self maps\mp\gametypes\apb::joinGroup(p.group);
}
else
{
self newMessage("^1"+level.s["FULLGROUP_"+self.lang]+"!");
}
}
else
{
self newMessage("^1"+level.s["ANOTHERGROUP_"+self.lang]+"!");
}
}
else
{
self newMessage("^1"+level.s["USERQUIT_"+self.lang]+"!");
}
}
else
{
self.invited newMessage("^2"+self.showname+" "+level.s["DECLINE_GROUP_"+self.lang]+"!");
}
}



self.invited=undefined;
}
else if(isDefined(self.claninvited))
{
if(response=="1")
{
x=sql_fetch(sql_query("SELECT clan, rank FROM members WHERE name = '"+self.claninvited+"'"));

if(isDefined(x)&&int(x[1])>=1){
sql_exec("INSERT INTO members (clan, name) VALUES ('"+x[0]+"', '"+self.showname+"')");
self newMessage("^5"+level.s["JOINED_CLAN_"+self.lang]+": "+x[0]+"!");
}
}

self.claninvited=undefined;

}
else if(isDefined(self.challenged))
{
if(!isDefined(self.missionId))
{
if(response=="1")
{
if(canChallenge(self,self.challenged))
{
if(self.team=="allies")
maps\mp\gametypes\apb::newMission(level.groups[self.group].team,level.groups[self.challenged.group].team,true);
else
 maps\mp\gametypes\apb::newMission(level.groups[self.challenged.group].team,level.groups[self.group].team,true);
}
else
{
self newMessage("^1"+level.s["NO_CHALLENGE_"+self.lang]+"!");
self.challenged newMessage("^1"+self.showname+" "+level.s["CANT_CHALLENGE_"+self.lang]+"!");
}
}
else
{
self newMessage("^1"+level.s["DECLINE_CHALLENGE_"+self.lang]+"!");
self.challenged newMessage("^1"+self.showname+" "+level.s["DECLINED_CHALLENGE_"+self.lang]+"!");
}
}

self.challenged=undefined;
}


self setClientDvar("invite_body","");
}
else if(isSubStr(menu,"inv"))
{
trig=self touching("inv");
if(!isDefined(trig))
{
if(!isDefined(self.supplier))
continue;

trig=self.supplier;
}

if(response=="clear")
{
if(isDefined(self.invpage))
{
self.weaponid=undefined;
self.invpage=undefined;
self.invtier=undefined;
}
}
else if(menu==game["menu_invperk"])
{
if(response=="change"||response=="del")
{
if(!isDefined(self.weaponid,self.invpage))
continue;

id=-1;
green=0;
red=0;
blue=0;
__v17=self.perklist;__c17=__v17.size;for(i=0;i<__c17;i++)
{
__e17=__v17[i];if(level.mods[__e17].tier==1)
green++;
else if(level.mods[__e17].tier==2)
red++;
else if(level.mods[__e17].tier==3)
blue++;

if(__e17==self.weaponid)
{
id=i;
break;
}
}i=undefined;__c17=undefined;__v17=undefined;

if(id==-1)
continue;


if(isDefined(self.supplying)&&level.mods[self.perklist[id]].tier==3&&self.perk3=="supplier")
{
self.supplying notify("break");
waittillframeend;
}

if(response=="change")
{
if(level.mods[self.perklist[id]].tier==1)
{
if(self.info["mod_green"]!=self.weaponid)
{
self setClientDvar("greenid",green);
self.info["mod_green"]=self.weaponid;

}
else
{
self setClientDvar("greenid","");
self.info["mod_green"]=0;

}
}
else if(level.mods[self.perklist[id]].tier==2)
{
if(self.info["mod_red"]!=self.weaponid)
{
self setClientDvar("redid",red);
self.info["mod_red"]=self.weaponid;

}
else
{
self setClientDvar("redid","");
self.info["mod_red"]=0;

}
}
else
{
if(self.info["mod_blue"]!=self.weaponid)
{
self setClientDvar("blueid",blue);
self.info["mod_blue"]=self.weaponid;

}
else
{
self setClientDvar("blueid","");
self.info["mod_blue"]=0;

}
}


self maps\mp\gametypes\apb::loadPlayerPerks();





self playLocalSound("Change");
}
else
{

self deletePerk(id);
}

}
else if(isSubStr(response,":"))
{
perk=strTok(response,":");
if(perk.size==2)
{
if(!isDefined(self.invpage))
{
self.invpage=1;
self setClientDvar("invpage",1);
}
self.invtier=perk[0];
self setClientDvar("invtier",self.invtier);

self setCurPerk(perk[0],int(perk[1]));
}
}
else
{
continue;
}
}
else
{
if(response=="change"||response=="del")
{
if(!isDefined(self.weaponid,self.invpage))
continue;








































id=self.wID[self.weaponid];
if(self.weapons[id]["id"]==self.info["prime"]||self.weapons[id]["id"]==self.info["secondary"]||self.weapons[id]["id"]==self.info["offhand"])
{
continue;
}

if(response=="change")
{
if(self.weapons[id]["type"]=="primary")
{
self setClientDvar("primaryid",self.weapons[id]["id"]);
cur=self.primaryWeapon;
self.info["prime"]=self.weaponid;
self.primaryWeapon=level.weaps[self.weaponid].weap;


if(isDefined(self.missionId))
{
id=self.clientid;
a=self getWeapPerkArray(self.info["prime"]);
__v18=level.teams[self.missionTeam];__c18=__v18.size;for(__i18=0;__i18<__c18;__i18++)
{
__v18[__i18].playerStats[id].primary=self.info["prime"];
__v18[__i18].playerStats[id].primaryperks=a;
}__i18=undefined;__c18=undefined;__v18=undefined;
__v19=level.teams[self.enemyTeam];__c19=__v19.size;for(__i19=0;__i19<__c19;__i19++)
{
__v19[__i19].playerStats[id].primary=self.info["prime"];
__v19[__i19].playerStats[id].primaryperks=a;
}__i19=undefined;__c19=undefined;__v19=undefined;
}
}
else if(self.weapons[id]["type"]=="secondary")
{
self setClientDvar("secondaryid",self.weapons[id]["id"]);
cur=self.secondaryWeapon;
self.info["secondary"]=self.weaponid;
self.secondaryWeapon=level.weaps[self.weaponid].weap;

}
else
{
self setClientDvar("offhandid",self.weapons[id]["id"]);
cur=self.offhandWeapon;
self.info["offhand"]=self.weaponid;
self.offhandWeapon=level.weaps[self.weaponid].weap;

}
self setClientDvar(self.weapons[id]["type"],self.weapons[id]["id"]);

self takeWeapon(cur);

self giveWeapon(level.weaps[self.weaponid].weap);
self setWeaponAmmoClip(level.weaps[self.weaponid].weap,0);
self setWeaponAmmoStock(level.weaps[self.weaponid].weap,0);

if(self getCurrentWeapon()=="none")
{
self switchToWeapon(level.weaps[self.weaponid].weap);
}
self playLocalsound("Change");
type[self.weapons[id]["type"]]=true;
self thread maps\mp\gametypes\apb::resupply(type,trig);


}
else if(level.defaultWeapon[self.weapons[id]["type"]]!=self.weapons[id]["id"])
{









self setClientDvar("hasweapon"+self.weapons[id]["id"],0);
sql_exec("DELETE FROM weapons WHERE name = '"+self.showname+"' AND weapon = "+self.weapons[id]["id"]);

self.wID[self.weapons[id]["id"]]=undefined;
type=self.weapons[id]["type"];
typecount=0;
c=self.weapons.size;
__v20=self.weapons;__c20=c+1;for(i=1;i<__c20;i++)
{
if(i!=id&&__v20[i]["type"]==type)
{
typecount++;
self setClientDvar(type+typecount,__v20[i]["id"]);
}
if(i>=id&&i<c)
{
index=i+1;




self.wID[self.weapons[index]["id"]]=i;
self.weapons[i]=self.weapons[index];
}
}i=undefined;__c20=undefined;__v20=undefined;
alltype=typecount+1;
self setClientDvars(
type+alltype,0,
type+alltype+"_time",0
);





self.weapons[c]=undefined;
c--;

if(c==self.invpage*11)
{
self.invpage--;
self setClientDvar("invpage",self.invpage);
}
self setCurWeapon(type,1);






}
}
else if(response=="nextpage")
{

if(!isDefined(self.weaponid,self.invpage))continue;

max=self.invpage*11+1;
c=0;
__v21=self.weapons;__c21=__v21.size+1;for(__i21=1;__i21<__c21;__i21++)
{
if(__v21[__i21]["type"]==level.weaps[self.weaponid].type)
{
c++;
if(c==max)
{
self.invpage++;
self setClientDvar("invpage",self.invpage);
self setCurWeapon(level.weaps[self.weaponid].type,1);
break;
}
}
}__i21=undefined;__c21=undefined;__v21=undefined;
}
else if(response=="prevpage")
{
if(!isDefined(self.weaponid,self.invpage)||self.invpage==1)
continue;

self.invpage--;
self setClientDvar("invpage",self.invpage);
self setCurWeapon(level.weaps[self.weaponid].type,1);
}
else if(isSubStr(response,":"))
{
wpn=strTok(response,":");
if(wpn.size==2)
{
if(!isDefined(self.invpage))
{
self.invpage=1;
self setClientDvar("invpage",1);
}

self setCurWeapon(wpn[0],int(wpn[1]));
}
}
else
{
continue;
}
}
}


















































else if(menu==game["menu_weapons"])
{
if(!isDefined(self touching("weapons")))
continue;

if(response=="buy")
{

if(!isDefined(self.weaponid))
continue;

if(!isDefined(level.weaps[self.weaponid])||level.weaps[self.weaponid].group!="0"||(level.weaps[self.weaponid].team==level.enemy[self.team]))
continue;



if(self.info["money"]>=level.weaps[self.weaponid].price&&self.rating>=level.weaps[self.weaponid].rating&&self.roleLevel[level.weaps[self.weaponid].roleType]>=level.weaps[self.weaponid].roleLevel&&self giveWeap(self.weaponid))
{
self maps\mp\gametypes\apb::giveMoney(level.weaps[self.weaponid].price*-1);
self playLocalSound("Coin");
}
}
else if(isSubStr(response,"type:"))
{
class=getSubStr(response,5);
if(isDefined(level.weapTypes[class]))
{
self.weaponclass=class;
self setClientDvar("weaponclass",self.weaponclass);
c=level.weapTypes[class].size;
for(i=0;i<12;i++)
{
if(i<c)
self setClientDvar("list"+i,level.weapTypes[class][i]);
else
 self setClientDvar("list"+i,"");
}
self.weaponid=level.weapTypes[class][0];
self setClientDvar("weaponid",self.weaponid);

if(level.weaps[self.weaponid].type!="offhand")
{
self getWeapGlobalPerks(self.weaponid,"mod");
}
}
}
else if(response=="close")
{
if(isDefined(self.weaponclass))
{
self.weaponclass=undefined;
}
}
else if(isDefined(self.weaponclass))
{
id=int(response);
if(isDefined(level.weapTypes[self.weaponclass][id]))
{
self.weaponid=level.weapTypes[self.weaponclass][id];
self setClientDvar("weaponid",self.weaponid);

if(level.weaps[self.weaponid].type!="offhand")
{
getWeapGlobalPerks(self.weaponid,"mod");
}
}
}
}
else if(menu==game["menu_mods"])
{
if(!isDefined(self touching("mods")))
continue;

if(response=="buy")
{

if(!isDefined(self.modlistID)||!level.mods[self.modlistID].buyable)
continue;

c=self.perklist.size;

if(self.info["money"]>=level.mods[self.modlistID].price&&self.rating>=level.mods[self.modlistID].rating&&c<self.info["maxmods"]){
valid=true;
__v22=self.perklist;for(__i22=0;__i22<c;__i22++)
{
if(__v22[__i22]==self.modlistID)
{
valid=false;
break;
}
}__i22=undefined;__v22=undefined;
if(valid)
{
sql_exec("INSERT INTO mods (name, perk) VALUES ('"+self.showname+"', "+self.modlistID+")");
self.perklist[c]=self.modlistID;

self maps\mp\gametypes\apb::giveMoney(level.mods[self.modlistID].price*-1);





count=1;
list=self.perklist;
for(__i23=0;__i23<c;__i23++)
{
if(level.mods[list[__i23]].tier==level.mods[list[c]].tier)
{
count++;
}
}__i23=undefined;

self setClientDvars(
getClass(level.mods[list[c]].tier)+count,self.modlistID,
"hasmod"+self.modlistID,1
);
self playLocalSound("Coin");
}
}
}
else if(response=="del")
{
if(!isDefined(self.modlistID))
continue;

id=-1;
__v24=self.perklist;__c24=__v24.size;for(i=0;i<__c24;i++)
{
if(__v24[i]==self.modlistID)
{
id=i;
break;
}
}i=undefined;__c24=undefined;__v24=undefined;

if(id!=-1)
self deletePerk(id);
}
else if(response=="close")
{
if(isDefined(self.modlistID))
self.modlistID=undefined;
}
else
{
id=int(response);
if(isDefined(level.mods[id]))
{
self.modlistID=id;
self setClientDvar("weaponid",self.modlistID);
}
}
}
else if(menu==game["menu_camo"])
{
arsenal=getEnt("arsenal","targetname");
if((isDefined(arsenal)&&!self isTouching(arsenal))||!isDefined(self.camo))
continue;

if(response=="save")
{
self notify("endcamo");
self.camo=undefined;
self.camopage=undefined;
self.camomodel delete();
self closeMenu();
self setClientDvars(
"cg_drawGun",1,
"cg_draw2D",1
);
self show();
self freezeControls(false);
self.spawned=true;
self setOrigin(self.clone.origin);
self setPlayerAngles((0,self.clone.angles[1],0));
self.clone delete();
}
else if(response=="next"||response=="prev")
{
if(response=="next")
{
c=self.weapons.size;
for(i=self.camo+1;i!=self.camo;i++)
{
if(i>c)
{
i=1;
}
if(level.weaps[self.weapons[i]["id"]].hascamo)
{
self.camo=i;
break;
}
}
}

else{
for(i=self.camo-1;i!=self.camo;i--)
{
if(!i)
{
i=self.weapons.size;
}
if(level.weaps[self.weapons[i]["id"]].hascamo)
{
self.camo=i;
break;
}
}
}

self setClientDvars(
"camo",self.weapons[self.camo]["id"],
"camo_skin",self.weapons[self.camo]["camo"]
);
self getWeapPerks(self.weapons[self.camo]["id"],"mod");
self.camomodel.origin=level.camoWeap.origin;
self.camomodel setModel(getWeaponModel(level.weaps[self.weapons[self.camo]["id"]].weap,self.weapons[self.camo]["camo"]));



}
else if(isSubStr(response,"wear:")||isSubStr(response,"action:"))
{
a=strTok(response,":");
if(a.size==2)
{
id=int(a[1]);
if(id>=0&&id<level.camos.size)
{
if(a[0]=="wear")
{
self.camomodel setModel(getWeaponModel(level.weaps[self.weapons[self.camo]["id"]].weap,id));
}

else if(id){
for(i=0;i<self.inv.size;i++)
{
if(self.inv[i].item=="camo"&&self.inv[i].itemtype==id)
{
if(self.weapons[self.camo]["camo"]!=id)
{
sql_exec("DELETE FROM inv WHERE invid = "+self.inv[i].id);
sql_exec("UPDATE weapons SET camo = "+id+" WHERE name = '"+self.showname+"' AND weapon = "+self.weapons[self.camo]["id"]);
{__c=self.inv.size-1;if(i==__c){self.inv[i]=undefined;}else{for(__i=__c;__i<__c;__i++){self.inv[__i]=self.inv[__i+1];}}}
self.weapons[self.camo]["camo"]=id;
self updateCamos();
}
break;
}
}
}
else
{
sql_exec("UPDATE weapons SET camo = 0 WHERE name = '"+self.showname+"' AND weapon = "+self.weapons[self.camo]["id"]);
}
}
}
}
else if(isSubStr(response,"page:"))
{
a=strTok(response,":");
if(a.size==2)
{
id=int(a[1]);
if(id>=1||id<=3)
{
self.camopage=id;
self setClientDvar("page",id);
}
}
}
else if(isSubStr(response,"perk:"))
{
if(!level.weaps[self.weapons[self.camo]["id"]].modplace)
continue;

a=strTok(response,":");
if(a.size!=2)
continue;

if(a[1]=="clear")
{

modid=0;
used=-1;
for(i=0;i<level.perkCount;i++)
{
if(level.perks[level.perkID[i]].id&self.weapons[self.camo]["mod"])
{
modid++;
if(self.camopage==modid)
{
self.weapons[self.camo]["mod"]-=level.perks[level.perkID[i]].id;
break;
}
}
}
}
else
{

id=int(a[1]);




















typecount=0;
valid=-1;
__v25=self.perklist;__c25=__v25.size;if(__c25){for(i=0;i<__c25;i++)
{
if(level.mods[__v25[i]].tier>3)
{
if(id==typecount)
{
valid=i;
break;
}
typecount++;
}
}i=undefined;}__c25=undefined;__v25=undefined;

if(valid==-1)
continue;


if(self.weapons[self.camo]["mod"])
{

used=false;
__v26=self.perklist;__c26=__v26.size;if(__c26){for(__i26=0;__i26<__c26;__i26++)
{
__e26=__v26[__i26];if(level.mods[__e26].tier==level.mods[self.perklist[valid]].tier&&level.perks[level.perkID[level.mods[__e26].wid]].id&self.weapons[self.camo]["mod"])
{
self.weapons[self.camo]["mod"]-=level.perks[level.perkID[level.mods[__e26].wid]].id;
used=true;
break;
}
}__i26=undefined;}__c26=undefined;__v26=undefined;


if(!used)
{
modid=0;
used=-1;
__v27=level.perkID;__c27=level.perkCount;for(__i27=0;__i27<__c27;__i27++)
{
if(level.perks[__v27[__i27]].id&self.weapons[self.camo]["mod"])
{
modid++;
if(self.camopage==modid)
{
self.weapons[self.camo]["mod"]-=level.perks[__v27[__i27]].id;
break;
}
}
}__i27=undefined;__c27=undefined;__v27=undefined;
}
}

self.weapons[self.camo]["mod"]|=level.perks[level.perkID[level.mods[self.perklist[valid]].wid]].id;
}
self maps\mp\gametypes\_weapons::loadWeaponMods(self.camo);
self getWeapPerks(self.weapons[self.camo]["id"],"mod");
sql_exec("UPDATE weapons SET mods = "+self.weapons[self.camo]["mod"]+" WHERE name = '"+self.showname+"' AND weapon = "+self.weapons[self.camo]["id"]);
}
}
else if(menu==game["menu_dress"])
{
if(!isDefined(self.info["dress"]))
continue;

dresser=getEnt("dressing","targetname");
if(isDefined(dresser)&&!self isTouching(dresser))
continue;

if(response=="load")
{
for(i=1;i<=level.hatCount;i++)
{
if(level.hats[i].bit&self.info["hats"])
{
if(self.info["curhat"]==i)
self setClientDvar("hasitem_hat_"+i,2);
else
 self setClientDvar("hasitem_hat_"+i,1);
}
}
}
else if(response=="save")
{
self closeMenu();
self.rotate=undefined;
self setClientDvars(
"cg_thirdPerson",0,
"cg_thirdPersonAngle",0,
"cg_thirdPersonRange",120
);
self show();
self freezeControls(false);
if(isDefined(self.clone))
{
self.spawned=true;
self loadModel();
self setOrigin(self.clone.origin);
self setPlayerAngles((0,self.clone.angles[1],0));
self.clone delete();
}
else
{
self thread maps\mp\gametypes\apb::joinTeam();
}
}
else if(response=="next"||response=="prev")
{
if(response=="next")
{
if(self.info["dress"]==16)
self.info["dress"]=1;
else
 self.info["dress"]++;
}
else
{
if(self.info["dress"]==1)
self.info["dress"]=16;
else
 self.info["dress"]--;
}

self loadModel();


}
else if(response=="left"||response=="right")
{
if(!isDefined(self.rotate))
self.rotate=180;

if(response=="left")
{
if(self.rotate==340)
self.rotate=0;
else
 self.rotate+=20;
}
else
{
if(self.rotate==0)
self.rotate=340;
else
 self.rotate-=20;
}

self setClientDvar("cg_thirdPersonAngle",self.rotate);
}
else if(isSubStr(response,"wear:")||isSubStr(response,"action:")||isSubStr(response,"delete:"))
{
a=strTok(response,":");
if(a.size==3)
{
id=int(a[2]);
switch(a[1])
{
case"hat":
if(isDefined(level.hats[id]))
{
if(a[0]=="wear")
{
self loadModel("hat");
self attach(level.hats[id].model,"j_helmet",true);
}
else if(a[0]=="action")
{
if(self.info["curhat"]==id)
{

self.info["curhat"]=0;
self setClientDvar("hasitem_hat_"+id,"1");
self loadModel();
}
else if(level.hats[id].bit&self.info["hats"])
{

if(self.info["curhat"])
{
self setClientDvar("hasitem_hat_"+self.info["curhat"],"1");
}
self.info["curhat"]=id;
self setClientDvar("hasitem_hat_"+id,"2");
self loadModel();
}
else if(level.hats[id].price&&self.info["money"]>=level.hats[id].price)
{

self maps\mp\gametypes\apb::giveMoney(level.hats[id].price*-1);
self.info["hats"]|=level.hats[id].bit;
self setClientDvar("hasitem_hat_"+id,"1");
}
}

else{
self.info["hats"]-=id;
self setClientDvar("hasitem_hat_"+id,"0");
if(self.info["curhat"]==id)
{
self.info["curhat"]=0;
self loadModel();
}
}
}
break;

}
}
}
}









}
}
}

updateCamos()
{
c=[];
for(i=1;i<level.camoCount;i++)
{
c[i]=0;
}
__v28=self.inv;__c28=__v28.size;if(__c28){for(__i28=0;__i28<__c28;__i28++)
{
if(__v28[__i28].item=="camo")
{
c[__v28[__i28].itemtype]++;
}
}__i28=undefined;}__c28=undefined;__v28=undefined;
for(i=1;i<level.camoCount;i++)
{
self setClientDvar("camo_count"+i,c[i]);
}























id=0;
__v29=self.perklist;__c29=__v29.size;if(__c29){for(__i29=0;__i29<__c29;__i29++)
{
if(level.mods[__v29[__i29]].tier>3)
{
self setClientDvar("weapperk"+id,__v29[__i29]);
id++;
}
}__i29=undefined;}__c29=undefined;__v29=undefined;
}

loadModel(ignoreModel)
{
self detachAll();
self[[game[self.team+"_model"][self.info["dress"]]]]();
if(self.info["curhat"]&&(!isDefined(ignoreModel)||ignoreModel!="hat"))
{
self attach(level.hats[self.info["curhat"]].model,"j_helmet",true);
}
if(isDefined(self.weapon_array_primary))
{
self maps\mp\gametypes\_weapons::stow_on_back();
self maps\mp\gametypes\_weapons::stow_on_hip();
}
}













































































































































































setCurPerk(class,pid)
{
c=self.perklist.size;
if(c)
{
if(class=="green")
type=1;
else if(class=="red")
type=2;
else
 type=3;

id=int(pid);
count=0;
legal=false;
__v30=self.perklist;for(i=0;i<c;i++)
{
if(level.mods[__v30[i]].tier==type)
{
count++;
if(count==id)
{
legal=true;
id=i;
break;
}
}
}i=undefined;__v30=undefined;

if(!legal)
{
self.weaponid=undefined;
self setClientDvar("weaponid",0);
}
else
{
self.weaponid=self.perklist[id];
self setClientDvar("weaponid",self.weaponid);
}
}
else
{
self.weaponid=undefined;
self setClientDvar("weaponid",0);
}
}

setCurWeapon(type,wid)
{
wid+=(self.invpage-1)*11;
count=0;
legal=false;
__v31=self.weapons;__c31=__v31.size+1;for(i=1;i<__c31;i++)
{
if(__v31[i]["type"]==type)
{
count++;
if(count==wid)
{
legal=true;
wid=i;
break;
}
}
}i=undefined;__c31=undefined;__v31=undefined;
if(!legal)
return;

self.weaponid=self.weapons[wid]["id"];
self setClientDvar("weaponid",self.weaponid);

if(self.weapons[wid]["type"]!="offhand")
{
self getWeapPerks(self.weaponid,"mod");











}
}

newMessage(msg)
{
self maps\mp\gametypes\apb::newMessage(msg);
}

login()
{

self setClientDvars(
"name",self.showname,
"tempname",self.tempname,
"showname",self.showname,
"ip",level.ip,
"info","",
"info2","",
"info3","",
"cmd",
"");


self.namelen=strPixLen(self.showname);


if(!isDefined(self.prestige))
{
self.prestige=2;
self.reputation=0.5;
}


if(self.info["admin"])
{

self setClientDvar("admin",self.info["admin"]);
}


if(self.info["inv"]!="")
self.invmoney=0;


self thread maps\mp\gametypes\_weapons::watchWeapons();


if(self.info["premiumtime"]>getRealTime())
self thread maps\mp\gametypes\apb::watchPremium();
else
 self.premium=false;


self maps\mp\gametypes\apb::loadPlayerPerks();
self.perklist=[];
perk=1;
types[1]=0;
types[2]=0;
types[3]=0;
types[4]=0;
types[5]=0;
types[6]=0;
x=sql_query("SELECT perk FROM mods WHERE name = '"+self.showname+"'");
for(i=0;true;i++)
{
perk=sql_fetch(x);
if(isDefined(perk))
{
perk=int(perk[0]);


self.perklist[i]=perk;
types[level.mods[perk].tier]++;

if(level.mods[perk].tier!=4)
{
self setClientDvar("hasmod"+perk,1);

if(level.mods[perk].tier==1)
class="green";
else if(level.mods[perk].tier==2)
class="red";
else if(level.mods[perk].tier==3)
class="blue";
else
 continue;

self setClientDvar(class+types[level.mods[perk].tier],self.perklist[i]);
if(class=="green")
{
if(self.perk1==level.mods[perk].name)
{
self setClientDvar("greenid",types[1]);
}
}
else if(class=="red")
{
if(self.perk2==level.mods[perk].name)
{
self setClientDvar("redid",types[2]);
}
}

else{
if(self.perk3==level.mods[perk].name)
{
self setClientDvar("blueid",types[3]);
}
}
}

}
else
{
break;
}
}

self.inv=[];
x=sql_query("SELECT invid, item, itemtype FROM inv WHERE name = '"+self.showname+"'");
for(i=0;true;i++)
{
y=sql_fetch(x);
if(isDefined(y))
{
self.inv[i]=spawnStruct();
self.inv[i].id=int(y[0]);
self.inv[i].item=y[1];
self.inv[i].itemtype=int(y[2]);
}
else
{
break;
}
}


self.msgs=[];
self.feeds=[];
self.notifies=[];
self.chat=[];

sql_exec("UPDATE players SET status = '"+level.server+"' WHERE name = '"+self.showname+"'");
self.online=true;
}

giveWeap(id,error)
{












type=level.weaps[id].type;

isOffhand=type=="offhand";
if(isOffhand)
time=-1;
else
 time=level.weaps[id].expireTime*86400;

success=false;
if(isDefined(self.wID[id]))
{
if(!isOffhand)
{
success=true;
self.weapons[self.wID[id]]["time"]+=time;
sql_exec("UPDATE weapons SET time = "+self.weapons[self.wID[id]]["time"]+" WHERE name = '"+self.showname+"' AND weapon = "+self.weapons[self.wID[id]]["id"]);



count=1;
for(i=1;i<self.wID[id];i++)
{
if(self.weapons[i]["type"]==type)
{
count++;
}
}

self setClientDvar(type+count+"_time",ceil((self.weapons[self.wID[id]]["time"]-getRealTime())/60));

}
}

else if(self.weapons.size<self.info["maxweapons"]){
success=true;
wid=self.weapons.size+1;
self.weapons[wid]["id"]=id;
self.weapons[wid]["type"]=type;
self.weapons[wid]["camo"]=0;
self.weapons[wid]["mod"]=level.weaps[id].mod;
self.wID[id]=wid;


if(!isOffhand)
{
realtime=time+getRealTime();


}
else
{
realtime=0;
}
self.weapons[wid]["time"]=realtime;
sql_exec("INSERT INTO weapons (name, weapon, mods, time) VALUES ('"+self.showname+"', "+id+", "+self.weapons[wid]["mod"]+", "+self.weapons[wid]["time"]+")");


count=1;

for(i=1;i<wid;i++){
if(self.weapons[i]["type"]==self.weapons[wid]["type"])
{
count++;
}
}
self setClientDvars(
type+count,id,
type+count+"_time",ceil(time/60),
"hasweapon"+id,1
);
}
else if(!isDefined(error)||error)
{
self newMessage("^1"+level.s["FULLINV_"+self.lang]);
}
return success;
}

















































queryMails()
{
c=self.messages.size;
m=c-self.pageindex*10;
if(m>10)
{
m=10;
}
else if(m<10)
{
for(i=m;i<10;i++)
{
self setClientDvars(
"message"+i+"_sender","",
"message"+i+"_subject","",
"message"+i+"_body","",
"message"+i+"_attachment","",
"message"+i+"_date","",
"message"+i+"_read",""
);
}
}

self setClientDvars(
"mails",m,
"allmails",c
);

if(m)
{
for(i=0;i<m;i++)
{
att="";
id=self.pageindex*10+i;
if(self.messages[id]["attachment"]!="0")
{
key=getSubStr(self.messages[id]["attachment"],0,2);
value=int(getSubStr(self.messages[id]["attachment"],2));
switch(key)
{
case"WE":
att=level.weaps[value].name;
break;
}
}

self setClientDvars(
"message"+i+"_sender",self.messages[id]["sender"],
"message"+i+"_subject",self.messages[id]["subject"],
"message"+i+"_body",self.messages[id]["body"],
"message"+i+"_attachment",att,
"message"+i+"_date",unixToString(self.messages[id]["date"],self.info["format"],self.info["date"]),
"message"+i+"_read",self.messages[id]["read"]
);
}
}
}

inArray(array,value)
{
c=array.size;
if(!c)
return false;

for(i=0;i<c;i++)
{
if(array[i]==value)
{
return true;
}
}
return false;
}





checkStatus(name)
{
if(isDefined(level.online[name]))
return level.server;

else return sql_query_first("SELECT status FROM players WHERE name = '"+name+"'");
}

inviteGroup(inv,verified)
{
if(!level.action)
return;

if(isDefined(verified)&&!verified)
{
inv_=playerName(toLower(inv));
if(!isDefined(inv_))
{
self newMessage("^1"+level.s["NOUSER_"+self.lang]+": "+inv+"!");
return;
}
else
{
inv=inv_;
}
}

if(isDefined(level.online[inv]))
{
if(!isDefined(self.group)||(isDefined(self.groupleader)&&level.groups[self.group].team.size<4))
{
if(self.showname!=inv)
{
u=level.online[inv];
if(u.team==self.team)
{
if(u.spawned)
{
if(!isDefined(u.group))
{
if(!isDefined(u.invited)&&!isDefined(u.claninvited))
{
if(!isDefined(u.missionId)&&!isDefined(self.missionId))
{
u.invited=self;
self newMessage("^2"+level.s["YOUINVITED_"+self.lang]+": "+inv);
u inviteHUD(self.showname+" "+level.s["INVITE_BODY_"+u.lang]);


}
else
{
self newMessage("^1"+level.s["USERINMISSION_"+self.lang]+"!");
}
}
else
{
self newMessage("^1"+level.s["USERINVITED_"+self.lang]+"!");
}
}
else
{
self newMessage("^1"+level.s["USERHASGROUP_"+self.lang]+"!");
}
}
else
{
self newMessage("^1"+level.s["USERNOTSPAWNED_"+self.lang]+"!");
}
}
else
{
self newMessage("^1"+level.s["ANOTHERTEAM_"+self.lang]+"!");
}
}
else
{
self newMessage("^1"+level.s["INVITE_YOURSELF_"+self.lang]+"!");
}
}
else if(isDefined(self.group))
{
self newMessage("^1"+level.s["GROUPFULL_"+self.lang]+"!");
}
else
{
self newMessage("^1"+level.s["NOT_GROUPLEADER_"+self.lang]+"!");
}
}
else
{
self newMessage("^1"+inv+" "+level.s["NOT_ONLINE_"+self.lang]+"!");
}

self closeMenus();
}

addFriend(friend)
{
id=self.friends.size;
if(id<28)
{

if(isDefined(friend)&&friend!=self.showname&&!inArray(self.friends,friend)){
self setClientDvars(
"temp"+id,friend,
"temp"+id+"_type",checkStatus(friend),
"temp_count",id+1
);
self.friends[id]=friend;
sql_exec("INSERT INTO friends (name, friend, friendid) VALUES ('"+self.showname+"', '"+friend+"', "+id+")");

self newMessage(friend+" "+level.s["FRIEND_ADDED_"+self.lang]+"!");
}
else
{
self newMessage("^1"+level.s["NO_FRIEND_"+self.lang]+"!");
}
}
else
{
self newMessage("^1"+level.s["FRIEND_LIMIT_"+self.lang]+"!");
}
}

playStudio()
{
self endon("disconnect");
self endon("studio_stop");

for(i=self.studio["cell"];i<32;i++)
{
self.studio["cell"]=i+1;
self setClientDvar("studio_cell",i);
for(t=1;t<=6;t++)
{
if(isDefined(self.studio["track"+t])&&self.studio["track"+t+"_sound"]&&isDefined(self.studio["track"+t][i])&&self.studio["track"+t][i]<level.themes[self.studio["track"+t+"_type"]]["rows"])
{
id="theme_"+self.studio["track"+t+"_type"]+"_"+self.studio["track"+t][i];
self playLocalSound(id);
maps\mp\gametypes\apb::addClearTheme(id);
}
}
wait 0.2;
}
self setClientDvar("studio_cell","");
self.studio["cell"]=0;
}

themeLength(id)
{
for(i=31;i>=0;i--)
{
for(j=0;j<6;j++)
{
if(isDefined(self.themes[id].tracks[j])&&isDefined(self.themes[id].tracks[j].nodes[i]))
{
return(i+1)*0.2;
}
}
}
return 0;
}

placePoint(vec)
{
teamID=self.missionTeam;

if(!isDefined(level.placedPoints[teamID]))
{
thread displacePoints(self.missionId,teamID);
cur=0;
}
else if(level.placedPoints[teamID].size==7)
{
self newMessage("^1"+level.s["TOO_MANY_POINTS_"+self.lang]+"!");
return;
}
else
{
cur=level.placedPoints[teamID].size;
}

self playSound("order");

hud=spawn("script_model",vec);
hud setModel("tag_origin");
hud.angles=(-90,0,0);
hud hide();
hud.teamID=teamID;
hud.missID=self.missionId;
level.placedPoints[teamID][cur]=hud;

__v32=level.teams[teamID];__c32=__v32.size;for(__i32=0;__i32<__c32;__i32++)
{
hud showToPlayer(__v32[__i32]);
}__i32=undefined;__c32=undefined;__v32=undefined;

wait 0.05;


if(isDefined(level.teams[teamID]))
{
__v33=level.teams[teamID];__c33=__v33.size;for(i=0;i<__c33;i++)
{
hud newPlacedHud(__v33[i],i);
}i=undefined;__c33=undefined;__v33=undefined;

playFXOnTag(level.placedPointFX,hud,"tag_origin");
hud thread hidePoint();
}
}

displacePoints(id,teamID)
{
level waittill("endmission"+id);
__v34=level.placedPoints[teamID];__c34=__v34.size;for(__i34=0;__i34<__c34;__i34++)
{
__e34=__v34[__i34];__e34 delete();
__v35=__e34.hud;__c35=__v35.size;for(__i35=0;__i35<__c35;__i35++)
{
__v35[__i35] destroy();
}__i35=undefined;__c35=undefined;__v35=undefined;
}__i34=undefined;__c34=undefined;__v34=undefined;
level.placedPoints[teamID]=undefined;
}

hidePoint()
{
level endon("endmission"+self.missID);
wait 10;
__v36=self.hud;__c36=__v36.size;for(__i36=0;__i36<__c36;__i36++)
{
if(isDefined(__v36[__i36]))
{
__v36[__i36] destroy();
}
}__i36=undefined;__c36=undefined;__v36=undefined;
{__c=level.placedPoints[self.teamID].size;if(__c>1){for(i=0;i<__c;i++){if(level.placedPoints[self.teamID][i]==self){last=__c-1;if(i<last)level.placedPoints[self.teamID][i]=level.placedPoints[self.teamID][last];level.placedPoints[self.teamID][last]=undefined;break;}}}else{level.placedPoints[self.teamID]=[];}}
self delete();
}

newPlacedHud(p,id)
{
if(!isDefined(id))
id=self.hud.size;

self.hud[id]=newClientHudElem(p);
self.hud[id]setShader("placedpoint",8,8);
self.hud[id]setWayPoint(true,"placedpoint");
self.hud[id].alpha=0.75;
self.hud[id].x=self.origin[0];
self.hud[id].y=self.origin[1];
self.hud[id].z=self.origin[2]+32;
self.hud[id].owner=p;
}

delPlacedHud()
{
p=level.placedPoints[self.missionTeam];
if(isDefined(p)&&isDefined(p[0]))
{
__v37=p[0];__c37=__v37.size;for(i=0;i<__c37;i++)
{
__e37=__v37[i];if(__e37.hud[i].owner==self)
{
__c38=p.size;for(__i38=0;__i38<__c38;__i38++)
{
p.hud[i]destroy();
{__c=p.hud.size-1;if(i!=__c)p.hud[i]=p.hud[__c];p.hud[__c]=undefined;}
}__i38=undefined;__c38=undefined;
break;
}
}i=undefined;__c37=undefined;__v37=undefined;
}
}

playerExists(name)
{
return sql_query_first("SELECT EXISTS(SELECT * FROM players WHERE LOWER(name) = '"+name+"')")=="1";
}

playerName(name)
{
if(name=="")
return undefined;

if(level.developer&&isDefined(level.online[name])&&isDefined(level.online[name].isBot))
return name;

return sql_query_first("SELECT name FROM players WHERE LOWER(name) = '"+name+"'");
}

clearClanMgr()
{









self.clanid=undefined;
self.clanpage=undefined;
self.clanlist=undefined;
}

refreshClan(clan,rank)
{
y=sql_query("SELECT name, rank FROM members WHERE clan = '"+clan+"'");

i=0;
while(true)
{
s=sql_fetch(y);
if(isDefined(s))
{
self.clanlist[i]=spawnStruct();
self.clanlist[i].name=s[0];
self.clanlist[i].rank=int(s[1]);
self.clanlist[i].status=checkStatus(s[0]);
if(i<26)
{
self setClientDvars(
"temp"+i,self.clanlist[i].name,
"temp"+i+"_type",self.clanlist[i].rank,
"temp"+i+"_type2",self.clanlist[i].status
);
}
}
else
{
break;
}

i++;
}

self.clanid=0;
self.clanpage=0;
self setClientDvars(
"clanid",0,
"clanpage",0,
"temp_count",i,
"clan",clan,
"clanrank",rank
);
}

isClanGroup(g)
{
c="";
a=level.groups[g].team;
d=a.size;
for(i=0;i<d;i++)
{
if(i)
c+=", ";

c+="'"+a[i].showname+"'";
}i=undefined;
return isDefined(sql_query_first("SELECT EXISTS(SELECT * FROM members WHERE name IN ("+c+") GROUP BY clan HAVING COUNT(*) = "+d+")"));











}

refreshWarZone()
{
if(!isDefined(self.missionId))
{
if(isDefined(self.warlist))
{
count=self.warlist.size;
self.warlist=undefined;
}
else
{
count=0;
}
query="";
__v40=level.groups;__c40=__v40.size;for(i=0;i<__c40;i++)
{
__e40=__v40[i];if(__e40.side!=self.team)
{
c="";
d=__e40.team.size;
__v41=__e40.team;for(j=0;j<d;j++)
{
if(j)
c+=", ";

c+="'"+__v41[j].showname+"'";
}j=undefined;__v41=undefined;
if(query!="")
query+=" UNION ";

query+="SELECT clan, "+i+" FROM members WHERE name IN ("+c+") GROUP BY clan HAVING COUNT(*) = "+d;
}
if(query!="")
{
x=sql_query(query);
for(i=0;true;i++)
{
q=sql_fetch(x);
if(isDefined(q))
{
r=level.groups[int(q[1])];
self.warlist[i]=r.leader.showname;
self setClientDvars(
"war"+i,q[0],
"war"+i+"_type",r.team.size,
"war"+i+"_status",r.inMission,
"war"+i+"_leader",r.leader.showname
);
}
else
{
break;
}
}
}
}i=undefined;__c40=undefined;__v40=undefined;
if(isDefined(self.warlist))
{
self.warid=0;
self setClientDvars(
"error","",
"warid",0,
"wartype",level.groups[self.group].team.size
);
z=self.warlist.size;
}
else
{
self setClientDvar("error",level.s["NO_WARS_"+self.lang]);
z=0;
}

if(z<count)
{
for(i=z;i<count;i++)
{
self setClientDvars(
"war"+i,"",
"war"+i+"_type","",
"war"+i+"_status","",
"war"+i+"_leader",""
);
}
}
}
else
{
self setClientDvar("error",level.s["IN_MISSION_"+self.lang]);
}
}

refreshWarStats(clan)
{
all=int(sql_query_first("SELECT COUNT(*) FROM wars WHERE winner = '"+clan+"' OR loser = '"+clan+"'"));
if(all)
{

self.wars=spawnStruct();
self.wars.count=all;
self.wars.id=0;
self.wars.won=int(sql_query_first("SELECT COUNT(*) FROM wars WHERE winner = '"+clan+"'"));
self.wars.lost=self.wars.count-self.wars.won;
self setClientDvars(
"stat_wars",all,
"stat_id",0,
"stat_won",self.wars.won,
"stat_lost",self.wars.lost
);


x=sql_fetch(sql_query("SELECT winner, loser, type, time, tied, winner0, winner1, winner2, winner3, loser0, loser1, loser2, loser3 FROM wars WHERE winner = '"+clan+"' OR loser = '"+clan+"' ORDER BY time DESC LIMIT 1"));

tied=x[4]=="1";
type=int(x[2]);
if(x[0]==clan)
{
if(!tied)
self setClientDvar("stat_last_result",2);

self setClientDvar("stat_last_enemy",x[1]);

for(i=0;i<type;i++)
{
self setClientDvars(
"stat_last_team"+i,x[5+i],
"stat_last_enemyteam"+i,x[9+i]
);
}
}
else
{
if(!tied)
self setClientDvar("stat_last_result",0);

self setClientDvar("stat_last_enemy",x[0]);

for(i=0;i<type;i++)
{
self setClientDvars(
"stat_last_team"+i,x[9+i],
"stat_last_enemyteam"+i,x[5+i]
);
}
}

if(tied)
self setClientDvar("stat_last_result",1);

self setClientDvars(
"stat_last_type",type,
"stat_last_time",unixToString(int(x[3]),self.info["format"],self.info["date"])
);
}
}

canChallenge(p,q)
{
return isDefined(p.group)&&isDefined(q.group)&&!level.groups[p.group].inMission&&!level.groups[q.group].inMission&&level.groups[p.group].team.size==level.groups[q.group].team.size&&isClanGroup(p.group)&&isClanGroup(q.group);
}

queryBugs()
{
x=sql_query("SELECT bugid, name, subject, msg, status, time FROM bugs ORDER BY bugid DESC LIMIT 10 OFFSET "+(self.bugpage*10));
self.bugs=[];
for(i=0;true;i++)
{
source=sql_fetch(x);
if(isDefined(source))
{
self.bugs[i]=int(source[0]);
self setClientDvars(
"bug"+i,source[0],
"bug"+i+"_player",source[1],
"bug"+i+"_sub",source[2],
"bug"+i+"_msg",source[3],
"bug"+i+"_status",source[4],
"bug"+i+"_time",unixToString(int(source[5]),self.info["format"],self.info["date"])
);
}
else
{
break;
}
}

while(i<10)
{
self setClientDvar("bug"+i,"");
i++;
}
}

refreshTreasury(clan,r)
{
x=sql_query("SELECT name, cash, time FROM don WHERE clan = '"+clan+"' ORDER BY time DESC LIMIT 16 OFFSET "+(self.trepage*16));
self setClientDvars(
"trepage",self.trepage+1,
"trepages",max(ceil(int(sql_query_first("SELECT COUNT(*) FROM don WHERE clan = '"+clan+"'"))/16),1)
);
i=0;
while(true)
{
y=sql_fetch(x);
if(isDefined(y))
{
self setClientDvars(
"don"+i,y[0],
"don"+i+"_cash",y[1],
"don"+i+"_date",unixToString(int(y[2]),self.info["format"],self.info["date"])
);
i++;
}
else break;
}
while(i<16)
{
self setClientDvar("don"+i,"");
i++;
}


if(r)
{

h=sql_fetch(sql_query("SELECT cash, color, rank FROM clans WHERE clan = '"+clan+"'"));
self setClientDvars(
"weaponid",sql_query_first("SELECT COALESCE(SUM(cash), 0) FROM don WHERE clan = '"+clan+"'"),
"available",h[0],
"clan_color",h[1],
"clan_rank",h[2]
);
}
}

touching(type)
{
return maps\mp\gametypes\apb::touching(type);
}

getWeapPerkArray(weap)
{
def=0;
modid=0;

array=[];
if(self.weapons[self.wID[weap]]["mod"])
{
for(i=0;i<level.perkCount;i++)
{
if(level.perks[level.perkID[i]].id&self.weapons[self.wID[weap]]["mod"])
{
array[modid]=level.perkID[i];
modid++;
if(level.perks[level.perkID[i]].id&level.weaps[weap].mod)
{
def++;
}
}
}
}
def+=level.weaps[weap].modplace-modid;
for(i=0;modid<=2;i++)
{
if(i<def)
array[modid]="vacant";
else
 array[modid]="empty";

modid++;
}
return array;
}

getWeapPerks(weap,dvar)
{
def=0;
modid=0;

if(self.weapons[self.wID[weap]]["mod"])
{
for(i=0;i<level.perkCount;i++)
{
if(level.perks[level.perkID[i]].id&self.weapons[self.wID[weap]]["mod"])
{
modid++;
self setClientDvar(dvar+modid,level.perkID[i]);
if(level.perks[level.perkID[i]].id&level.weaps[weap].mod)
{
def++;
}
}
}
}
def+=level.weaps[weap].modplace-modid;
modid++;
for(i=0;modid<=3;i++)
{
if(i<def)
self setClientDvar(dvar+modid,"vacant");
else
 self setClientDvar(dvar+modid,"empty");

modid++;
}
}

getWeapGlobalPerks(weap,dvar)
{
modid=0;
if(level.weaps[weap].mod)
{
for(i=0;i<level.perkCount;i++)
{
if(level.perks[level.perkID[i]].id&level.weaps[weap].mod)
{
modid++;
self setClientDvar(dvar+modid,level.perkID[i]);
}
}
}
modid++;
for(i=0;modid<=3;i++)
{
if(i<level.weaps[weap].modplace)
self setClientDvar(dvar+modid,"vacant");
else
 self setClientDvar(dvar+modid,"empty");

modid++;
}
}

getBackpack()
{
c=min(18*self.bppage,self.inv.size-18*(self.bppage-1));
if(c)
{
for(i=0;i<c;i++)
{
switch(self.inv[i].item)
{
case"camo":
self setClientDvars(
"temp"+i,level.camos[self.inv[i].itemtype].name,
"temp"+i+"_desc",level.s["ITEMDESC_PAINT_"+self.lang],
"temp"+i+"_type","paint",
"temp"+i+"_type2","ui_camoskin_"+level.camos[self.inv[i].itemtype].img
);
break;
case"invexp":
self setClientDvars(
"temp"+i,level.s[level.tools[level.toolsID[self.inv[i].item]].title+"_"+self.lang]+" ("+self.inv[i].itemtype+")",
"temp"+i+"_desc",level.s["ITEMDESC_EXP_INV_"+self.lang],
"temp"+i+"_type","expander",
"temp"+i+"_type2",""
);
break;
case"weapexp":
self setClientDvars(
"temp"+i,level.s[level.tools[level.toolsID[self.inv[i].item]].title+"_"+self.lang]+" ("+self.inv[i].itemtype+")",
"temp"+i+"_desc",level.s["ITEMDESC_EXP_WEAP_"+self.lang],
"temp"+i+"_type","expander",
"temp"+i+"_type2",""
);
break;
case"modexp":
self setClientDvars(
"temp"+i,level.s[level.tools[level.toolsID[self.inv[i].item]].title+"_"+self.lang]+" ("+self.inv[i].itemtype+")",
"temp"+i+"_desc",level.s["ITEMDESC_EXP_MOD_"+self.lang],
"temp"+i+"_type","expander",
"temp"+i+"_type2",""
);
break;
}
}
}
self setClientDvars(
"temp_count",c,
"temp_page",self.bppage
);
}

deletePerk(id)
{
class=getClass(level.mods[self.perklist[id]].tier);







if(level.mods[self.perklist[id]].tier>3)
{
valid=true;
for(i=4;i<=self.weapons.size;i++)
{
if(level.perks[level.perkID[level.mods[self.perklist[id]].wid]].id&self.weapons[i]["mod"])
{
valid=false;
break;
}
}
}
else
{
valid=self.info["mod_"+class]!=self.perklist[id];
}
if(valid)
{

self setClientDvar("hasmod"+self.perklist[id],0);
sql_exec("DELETE FROM mods WHERE name = '"+self.showname+"' AND perk = "+self.perklist[id]);

if(level.mods[self.perklist[id]].tier<=3)
{

tier=level.mods[self.perklist[id]].tier;

typecount=0;
c=self.perklist.size;
__v42=self.perklist;for(i=0;i<c;i++)
{
if(i!=id&&level.mods[__v42[i]].tier==tier)
{
typecount++;
self setClientDvar(class+typecount,__v42[i]);
}
if(i>=id&&i<c-1)
{



self.perklist[i]=self.perklist[i+1];
}
}i=undefined;__v42=undefined;
self setClientDvar(class+(typecount+1),0);

self setCurPerk(class,1);
}
else
{

for(i=id;i<self.perklist.size-1;i++)
{
self.perklist[i]=self.perklist[i+1];
}
}



self.perklist[self.perklist.size-1]=undefined;






}

}


getClass(tier)
{
if(tier==1)
return"green";
else if(tier==2)
return"red";
else if(tier==3)
return"blue";
else if(tier==4)
return"weapon";
else if(tier==5)
return"weapon2";

else return"weapon3";
}

inviteHUD(msg)
{
self setClientDvars(
"invite_delay",getTime()-self.startTime,
"invite_body",
msg+".");
self playLocalSound("Invite");
}

setDefaultTheme()
{

self.themes=[];
self.themeList=[];
p=strTok(level.defaultTheme,":");
self.themes[0]=spawnStruct();
self.themes[0].name=p[0];
self.themeList[p[0]]=0;
p=strTok(p[1],"|");
for(j=0;j<8;j++)
{
self.themes[0].tracks[j]=spawnStruct();
q=strTok(p[j],"-");
self.themes[0].tracks[j].type=q[0];
q=strTok(q[1],",");
self.themes[0].tracks[j].nodes=[];
for(k=0;k<32;k++)
{
if(q[k]!=" ")
{
self.themes[0].tracks[j].nodes[k]=int(q[k]);
}
}
}
}

refreshServers()
{
self.serverlist=[];
self.serverID=undefined;


if(isDefined(self.serverFilter))
filter=" AND gamemode = '"+self.serverFilter+"'";
else
 filter="";

x=sql_query("SELECT ip, name, count_allies, count_axis, count_all, count_max FROM servers WHERE heartbeat >= "+(getRealTime()-60)+filter);
for(i=0;true;i++)
{
s=sql_fetch(x);
if(isDefined(s))
{
self.serverlist[i]=s[0];
self setClientDvars(
"temp"+i,s[0],
"temp"+i+"_name",s[1],
"temp"+i+"_type",s[2],
"temp"+i+"_type2",s[3],
"temp"+i+"_type3",s[4],
"temp"+i+"_type4",s[5]
);
}
else
{
break;
}
}

self setClientDvar("temp_count",self.serverlist.size);
}

closeMenus()
{
self closeMenu();
self closeInGameMenu();
}

genCode()
{
a=level.allowed;
c=a.size;
r="";
for(i=0;i<16;i++)
{
r+=a[randomInt(c)];
}
return r;
}

moveToSpectator()
{
self maps\mp\gametypes\apb::inactive();
maps\mp\gametypes\apb::updateServerStat("count_"+self.team+" = "+level.activeCount[self.team]);






self notify("spawned");
self notify("end_respawn");

self.sessionteam="spectator";
self.sessionstate="spectator";
}

refreshPlayerList()
{
p=level.players;
self.players=p;
c=p.size;
for(i=0;i<c;i++)
{
__e43=p[i];if(isDefined(__e43.team))
{
if(__e43.team=="axis")
self setClientDvar("temp"+i,"^1"+__e43.showname);
else if(__e43.team=="allies")
self setClientDvar("temp"+i,"^2"+__e43.showname);
else
 self setClientDvar("temp"+i,"^7"+__e43.name);
}
else
 self setClientDvar("temp"+i,"^8"+__e43.name);
}i=undefined;
self.playerid=-1;
self setClientDvar("temp_count",c);
}