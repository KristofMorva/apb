








#include common_scripts\utility;
#include maps\mp\_utility;

init()
{
level.perkCount=int(tableLookup("mp/modTable.csv",0,"weaponmods",1));
level.perks=[];
level.perkID=[];
for(i=0;i<level.perkCount;i++)
{
name=tableLookup("mp/modTable.csv",6,i,1);
level.perks[name]=spawnStruct();
level.perks[name].tier=tableLookup("mp/modTable.csv",6,i,2);
level.perks[name].title=tableLookup("mp/modTable.csv",6,i,3);
level.perks[name].name=name;
level.perks[name].price=int(tableLookup("mp/modTable.csv",6,i,4));
level.perks[name].rating=int(tableLookup("mp/modTable.csv",6,i,5));
level.perks[name].buyable=tableLookup("mp/modTable.csv",6,i,7)=="1";
level.perks[name].perk=tableLookup("mp/modTable.csv",6,i,8);
level.perks[name].id=int(tableLookup("mp/modTable.csv",6,i,9));
level.perks[name].isperk=level.perks[name].perk!="";
level.perkID[i]=name;
}



level.ammo=[];
level.weaps=[];
level.weapID=[];

cashed=[];

level.weaponCount=int(tableLookup("mp/weaponTable.csv",0,"count",1));
for(i=1;i<=level.weaponCount;i++)
{
item=tableLookup("mp/weaponTable.csv",0,i,1)+"_mp";
level.weaps[i]=spawnStruct();

group=tableLookup("mp/weaponTable.csv",0,i,20);
if(group!="")
{























if(!isDefined(level.ammo[item]))
{
level.ammo[item]=tableLookup("mp/weaponTable.csv",0,i,16);
preCacheItem(item);
}


level.weaps[i].weap=item;
level.weaps[i].name=tableLookup("mp/weaponTable.csv",0,i,2);
level.weaps[i].price=int(tableLookup("mp/weaponTable.csv",0,i,11));
level.weaps[i].rating=int(tableLookup("mp/weaponTable.csv",0,i,12));
level.weaps[i].expireTime=int(tableLookup("mp/weaponTable.csv",0,i,13));
level.weaps[i].mod=int(tableLookup("mp/weaponTable.csv",0,i,14));
level.weaps[i].type=tableLookup("mp/weaponTable.csv",0,i,15);
level.weaps[i].image="rotated_"+tableLookup("mp/weaponTable.csv",0,i,17);
level.weaps[i].roleType=tableLookup("mp/weaponTable.csv",0,i,18);
level.weaps[i].roleLevel=int(tableLookup("mp/weaponTable.csv",0,i,19));
level.weaps[i].class=tableLookup("mp/weaponTable.csv",0,i,21);
level.weaps[i].modplace=int(tableLookup("mp/weaponTable.csv",0,i,23));
level.weaps[i].hascamo=tableLookup("mp/weaponTable.csv",0,i,24)=="1";
level.weaps[i].team=tableLookup("mp/weaponTable.csv",0,i,25);

if(group=="0")
level.weapTypes[level.weaps[i].class][int(tableLookup("mp/weaponTable.csv",0,i,22))]=i;
}
level.weaps[i].shader=tableLookup("mp/weaponTable.csv",0,i,3);
level.weaps[i].width=int(tableLookup("mp/weaponTable.csv",0,i,4));
level.weaps[i].height=int(tableLookup("mp/weaponTable.csv",0,i,5));
level.weaps[i].group=group;

if(!isDefined(cashed[level.weaps[i].shader]))
{
preCacheShader(level.weaps[i].shader);
cashed[level.weaps[i].shader]=true;
}





if(!isDefined(level.weaps[i].type)||level.weaps[i].type=="offhand")level.weapID[item]=i;

resetTimeOut();
}
preCacheItem("anim1_mp");


level.bomb="briefcase_bomb_mp";
preCacheItem(level.bomb);


level.fieldSupplier="radar_mp";
preCacheItem(level.fieldSupplier);


level.holdItem="airstrike_mp";
preCacheItem(level.holdItem);







preCacheModel("weapon_rpg7_stow");
precacheShellShock("default");
precacheShellShock("concussion_grenade_mp");
precacheShellShock("frag_grenade_mp");
thread maps\mp\_flashgrenades::main();

level thread onPlayerConnect();



level.tbl_CamoSkin=[];
for(i=0;i<8;i++)
{

level.tbl_CamoSkin[i]["bitmask"]=int(tableLookup("mp/attachmentTable.csv",11,i,10));

level.tbl_WeaponAttachment[i]["bitmask"]=int(tableLookup("mp/attachmentTable.csv",9,i,10));
level.tbl_WeaponAttachment[i]["reference"]=tableLookup("mp/attachmentTable.csv",9,i,4);
resetTimeOut();
}

level.tbl_weaponIDs=[];
for(i=0;i<150;i++)
{
reference_s=tableLookup("mp/statsTable.csv",0,i,4);
if(reference_s!="")
{
level.tbl_weaponIDs[i]["reference"]=reference_s;
level.tbl_weaponIDs[i]["group"]=tablelookup("mp/statstable.csv",0,i,2);
level.tbl_weaponIDs[i]["count"]=int(tablelookup("mp/statstable.csv",0,i,5));
level.tbl_weaponIDs[i]["attachment"]=tablelookup("mp/statstable.csv",0,i,8);
}
}











level.primary_weapon_array=[];
level.side_arm_array=[];
level.grenade_array=[];
level.inventory_array=[];
max_weapon_num=149;
for(i=0;i<max_weapon_num;i++)
{
if(!isdefined(level.tbl_weaponIDs[i])||level.tbl_weaponIDs[i]["group"]=="")
continue;
if(!isdefined(level.tbl_weaponIDs[i])||level.tbl_weaponIDs[i]["reference"]=="")
continue;


weapon_type=level.tbl_weaponIDs[i]["group"];
weapon=level.tbl_weaponIDs[i]["reference"];
attachment=level.tbl_weaponIDs[i]["attachment"];

weapon_class_register(weapon+"_mp",weapon_type);

if(isdefined(attachment)&&attachment!="")
{
attachment_tokens=strtok(attachment," ");
if(isdefined(attachment_tokens))
{
if(attachment_tokens.size==0)
weapon_class_register(weapon+"_"+attachment+"_mp",weapon_type);
else
{

for(k=0;k<attachment_tokens.size;k++)
weapon_class_register(weapon+"_"+attachment_tokens[k]+"_mp",weapon_type);
}
}
}
}
}

onPlayerConnect()
{
while(true)
{
level waittill("connecting",player);
player.usedWeapons=false;
player thread onPlayerSpawned();
}
}

onPlayerSpawned()
{
self endon("disconnect");

for(;;)
{
self waittill("spawned_player");

self.concussionEndTime=0;

self thread updateStowedWeapon();
self thread updateWeaponData();
self thread watchAmmo();
self thread watchFiring();
self thread watchGrenade();
}
}






getDamageableEnts(pos,radius,doLOS,startRadius)
{
ents=[];

if(!isdefined(doLOS))
doLOS=false;

if(!isdefined(startRadius))
startRadius=0;


players=level.players;
for(i=0;i<players.size;i++)
{
if(!isalive(players[i])||players[i].sessionstate!="playing")
continue;

playerpos=players[i].origin+(0,0,32);
dist=distance(pos,playerpos);
if(dist<radius&&(!doLOS||weaponDamageTracePassed(pos,playerpos,startRadius,undefined)))
{
newent=spawnstruct();
newent.isPlayer=true;
newent.isADestructable=false;
newent.entity=players[i];
newent.damageCenter=playerpos;
ents[ents.size]=newent;
}
}


grenades=getentarray("grenade","classname");
for(i=0;i<grenades.size;i++)
{
entpos=grenades[i].origin;
dist=distance(pos,entpos);
if(dist<radius&&(!doLOS||weaponDamageTracePassed(pos,entpos,startRadius,grenades[i])))
{
newent=spawnstruct();
newent.isPlayer=false;
newent.isADestructable=false;
newent.entity=grenades[i];
newent.damageCenter=entpos;
ents[ents.size]=newent;
}
}

destructibles=getentarray("destructible","targetname");
for(i=0;i<destructibles.size;i++)
{
entpos=destructibles[i].origin;
dist=distance(pos,entpos);
if(dist<radius&&(!doLOS||weaponDamageTracePassed(pos,entpos,startRadius,destructibles[i])))
{
newent=spawnstruct();
newent.isPlayer=false;
newent.isADestructable=false;
newent.entity=destructibles[i];
newent.damageCenter=entpos;
ents[ents.size]=newent;
}
}

destructables=getentarray("destructable","targetname");
for(i=0;i<destructables.size;i++)
{
entpos=destructables[i].origin;
dist=distance(pos,entpos);
if(dist<radius&&(!doLOS||weaponDamageTracePassed(pos,entpos,startRadius,destructables[i])))
{
newent=spawnstruct();
newent.isPlayer=false;
newent.isADestructable=true;
newent.entity=destructables[i];
newent.damageCenter=entpos;
ents[ents.size]=newent;
}
}

return ents;
}

weaponDamageTracePassed(from,to,startRadius,ignore)
{
midpos=undefined;

diff=to-from;
if(lengthsquared(diff)<startRadius*startRadius)
midpos=to;
dir=vectornormalize(diff);
midpos=from+(dir[0]*startRadius,dir[1]*startRadius,dir[2]*startRadius);

trace=bullettrace(midpos,to,false,ignore);

return trace["fraction"]==1;
}








damageEnt(eInflictor,eAttacker,iDamage,sMeansOfDeath,sWeapon,damagepos,damagedir)
{
if(self.isPlayer)
{
self.damageOrigin=damagepos;
self.entity thread[[level.callbackPlayerDamage]](
eInflictor,
eAttacker,
iDamage,
0,
sMeansOfDeath,
sWeapon,
damagepos,
damagedir,
"none",

0);
}
else
{

if(self.isADestructable)
return;

self.entity notify("damage",iDamage,eAttacker,(0,0,0),(0,0,0),"mod_explosive","","");
}
}

onWeaponDamage(eInflictor,sWeapon,meansOfDeath,damage)
{
self endon("death");
self endon("disconnect");

switch(sWeapon)
{

case"concussion_grenade_mp":
radius=512;
scale=1-(distance(self.origin,eInflictor.origin)/radius);

if(scale<0)
scale=0;

time=2+(4*scale);

wait(0.05);
self shellShock("concussion_grenade_mp",time);
self.concussionEndTime=getTime()+(time*1000);
break;

default:
maps\mp\gametypes\_shellshock::shellshockOnDamage(meansOfDeath,damage);
break;
}

}




isPrimaryWeapon(weaponname)
{
return isdefined(level.primary_weapon_array[weaponname]);
}
isSideArm(weaponname)
{
return isdefined(level.side_arm_array[weaponname]);
}
isInventory(weaponname)
{
return isdefined(level.inventory_array[weaponname]);
}
isGrenade(weaponname)
{
return isdefined(level.grenade_array[weaponname]);
}
getWeaponClass_array(current)
{
if(isPrimaryWeapon(current))
return level.primary_weapon_array;
else if(isSideArm(current))
return level.side_arm_array;
else if(isGrenade(current))
return level.grenade_array;
else
 return level.inventory_array;
}


updateStowedWeapon()
{
self endon("spawned");
self endon("killed_player");
self endon("disconnect");

detach_all_weapons();

self.tag_stowed_back=undefined;
self.tag_stowed_hip=undefined;




while(true)
{
self waittill("weapon_change",newWeapon);


self.weapon_array_primary=[];
self.weapon_array_sidearm=[];
self.weapon_array_grenade=[];
self.weapon_array_inventory=[];


weaponsList=self GetWeaponsList();
for(idx=0;idx<weaponsList.size;idx++)
{
if(isPrimaryWeapon(weaponsList[idx]))
self.weapon_array_primary[self.weapon_array_primary.size]=weaponsList[idx];
else if(isSideArm(weaponsList[idx]))
self.weapon_array_sidearm[self.weapon_array_sidearm.size]=weaponsList[idx];
else if(isGrenade(weaponsList[idx]))
self.weapon_array_grenade[self.weapon_array_grenade.size]=weaponsList[idx];
else if(isInventory(weaponsList[idx]))
self.weapon_array_inventory[self.weapon_array_inventory.size]=weaponsList[idx];
}

detach_all_weapons();
stow_on_back();
stow_on_hip();
}
}

detach_all_weapons()
{
if(isDefined(self.tag_stowed_back))
{
self detach(self.tag_stowed_back,"tag_stowed_back");
self.tag_stowed_back=undefined;
}
if(isDefined(self.tag_stowed_hip))
{
self detach(getWeaponModel(self.tag_stowed_hip),"tag_stowed_hip_rear");
self.tag_stowed_hip=undefined;
}
}

stow_on_back()
{
current=self getCurrentWeapon();

self.tag_stowed_back=undefined;


if(self hasWeapon("rpg_mp")&&current!="rpg_mp")
{
self.tag_stowed_back="weapon_rpg7_stow";
}
else
{
for(idx=0;idx<self.weapon_array_primary.size;idx++)
{
index_weapon=self.weapon_array_primary[idx];
assertex(isdefined(index_weapon),"Primary weapon list corrupted.");

if(index_weapon==current)
continue;






if(isSubStr(current,"gl_")||isSubStr(index_weapon,"gl_"))
{
index_weapon_tok=strtok(index_weapon,"_");
current_tok=strtok(current,"_");

for(i=0;i<index_weapon_tok.size;i++)
{
if(!isSubStr(current,index_weapon_tok[i])||index_weapon_tok.size!=current_tok.size)
{
i=0;
break;
}
}
if(i==index_weapon_tok.size)
continue;
}


self.tag_stowed_back=getWeaponModel(index_weapon,self.weapons[self.wID[self.info["prime"]]]["camo"]);
}
}

if(!isDefined(self.tag_stowed_back))
return;

self attach(self.tag_stowed_back,"tag_stowed_back",true);
}

stow_on_hip()
{
current=self getCurrentWeapon();

self.tag_stowed_hip=undefined;










for(idx=0;idx<self.weapon_array_inventory.size;idx++)
{
if(self.weapon_array_inventory[idx]==current)
continue;

if(!self GetWeaponAmmoStock(self.weapon_array_inventory[idx]))
continue;

self.tag_stowed_hip=self.weapon_array_inventory[idx];
}

if(!isDefined(self.tag_stowed_hip))
return;

weapon_model=getWeaponModel(self.tag_stowed_hip);
self attach(weapon_model,"tag_stowed_hip_rear",true);
}

stow_inventory(inventories,current)
{

if(isdefined(self.inventory_tag))
{
detach_model=getweaponmodel(self.inventory_tag);
self detach(detach_model,"tag_stowed_hip_rear");
self.inventory_tag=undefined;
}

if(!isdefined(inventories[0])||self GetWeaponAmmoStock(inventories[0])==0)
return;

if(inventories[0]!=current)
{
self.inventory_tag=inventories[0];
weapon_model=getweaponmodel(self.inventory_tag);
self attach(weapon_model,"tag_stowed_hip_rear",true);
}
}

weapon_class_register(weapon,weapon_type)
{
if(isSubstr("weapon_smg weapon_assault weapon_projectile weapon_sniper weapon_shotgun weapon_lmg",weapon_type))
level.primary_weapon_array[weapon]=1;
else if(weapon_type=="weapon_pistol")
level.side_arm_array[weapon]=1;
else if(weapon_type=="weapon_grenade")
level.grenade_array[weapon]=1;
else if(weapon_type=="weapon_explosive")
level.inventory_array[weapon]=1;
else
 assertex(false,"Weapon group info is missing from statsTable for: "+weapon_type);
}




updateWeaponData()
{
self endon("disconnect");
self endon("death");
self endon("spawned_player");

while(true)
{
self waittill("weapon_change",w);

if(w==level.fieldSupplier){
self maps\mp\gametypes\apb::takeSupplier();
self thread newSupplier();
}
else
{
self.currentWeapon=w;

if(w==level.bomb||w==level.holdItem||w=="anim1_mp")
{
self setClientDvar("weaptype","rotated_holditem");
}

else if(w!="none"){
wid=self getWeaponID(w);
self setClientDvar("weaptype",level.weaps[wid].image);
self loadWeaponMods(self.wID[wid]);
}
}
}
}

watchAmmo()
{
self endon("disconnect");
self endon("death");
self endon("spawned_player");

oldclip=-1;
oldstock=-1;
while(true)
{
if(self.currentWeapon!="none")
{
clip=self getWeaponAmmoClip(self.currentWeapon);
stock=self getWeaponAmmoStock(self.currentWeapon);

if(clip!=oldclip)
{
self setClientDvar("weapinfo_clip",clip);
oldclip=clip;
}
if(stock!=oldstock)
{
self setClientDvar("weapinfo_stock",stock);
oldstock=stock;
}
}
wait 0.05;
}
}

watchGrenade()
{
self endon("disconnect");
self endon("death");
self endon("spawned_player");

self.throwingGrenade=false;
while(true)
{
self waittill("grenade_pullback");
self.throwingGrenade=true;
self waittill("grenade_fire",grenade,weaponName);
self.throwingGrenade=false;
self setClientDvar("weapinfo_offhand",self getAmmoCount(weaponName));
ammoname="ammo_"+level.ammo[weaponName];
self.info[ammoname]--;
self setClientDvar(ammoname,self.info[ammoname]);



if(weaponName=="frag_grenade_mp")
{
grenade thread maps\mp\gametypes\_shellshock::grenade_earthQuake();
}
}
}

watchFiring()
{
self endon("disconnect");
self endon("death");
self endon("spawned_player");

while(true)
{
self waittill("begin_firing");
clip=self getWeaponAmmoClip(self.currentWeapon)+1;
self waittill("end_firing");
ammoname="ammo_"+level.ammo[self.currentWeapon];
self.info[ammoname]+=self getWeaponAmmoClip(self.currentWeapon)-clip;
self setClientDvar(ammoname,self.info[ammoname]);


}
}

watchWeapons()
{
self endon("disconnect");




















if(!self.info["prime"])
{
self.info["prime"]=level.defaultWeapon["primary"];
self.info["ammo_rifle"]=level.defaultAmmo["rifle"];
sql_exec("INSERT INTO weapons (name, weapon) VALUES ('"+self.showname+"', "+level.defaultWeapon["primary"]+")");






self.info["secondary"]=level.defaultWeapon["secondary"];
self.info["ammo_pistol"]=level.defaultAmmo["pistol"];
sql_exec("INSERT INTO weapons (name, weapon) VALUES ('"+self.showname+"', "+level.defaultWeapon["secondary"]+")");






self.info["offhand"]=level.defaultWeapon["offhand"];
self.info["ammo_frag"]=level.defaultAmmo["frag"];
sql_exec("INSERT INTO weapons (name, weapon) VALUES ('"+self.showname+"', "+level.defaultWeapon["offhand"]+")");



}








self setClientDvars(
"ammo_rifle",self.info["ammo_rifle"],
"ammo_machinegun",self.info["ammo_machinegun"],
"ammo_pistol",self.info["ammo_pistol"],
"ammo_desert",self.info["ammo_desert"],
"ammo_shotgun",self.info["ammo_shotgun"],
"ammo_sniper",self.info["ammo_sniper"],
"ammo_rocket",self.info["ammo_rocket"],
"ammo_frag",self.info["ammo_frag"],
"ammo_flash",self.info["ammo_flash"],
"ammo_concussion",self.info["ammo_concussion"],
"ammo_nonlethal",self.info["ammo_nonlethal"]
);


time=getRealTime();
types["primary"]=0;
types["secondary"]=0;
types["offhand"]=0;

x=sql_query("SELECT weapon, time, mods, camo FROM weapons WHERE name = '"+self.showname+"'");
for(i=1;true;i++)
{
wpn=sql_fetch(x);
if(isDefined(wpn))
{
self setClientDvar("hasweapon"+wpn[0],1);
self.weapons[i]["id"]=int(wpn[0]);
self.weapons[i]["time"]=int(wpn[1]);
self.weapons[i]["mod"]=int(wpn[2]);
self.weapons[i]["camo"]=int(wpn[3]);
self.weapons[i]["type"]=level.weaps[self.weapons[i]["id"]].type;

self.wID[self.weapons[i]["id"]]=i;

if(self.weapons[i]["type"]=="primary")
{
types["primary"]++;
self setClientDvars("primary"+types["primary"],self.weapons[i]["id"]);

if(self.weapons[i]["time"])
self setClientDvar("primary"+types["primary"]+"_time",ceil((self.weapons[i]["time"]-time)/60));

if(self.info["prime"]==self.weapons[i]["id"])
self setClientDvar("primaryid",self.weapons[i]["id"]);
}
else if(self.weapons[i]["type"]=="secondary")
{
types["secondary"]++;
self setClientDvar("secondary"+types["secondary"],self.weapons[i]["id"]);

if(self.weapons[i]["time"])
self setClientDvar("secondary"+types["secondary"]+"_time",ceil((self.weapons[i]["time"]-time)/60));

if(self.info["secondary"]==self.weapons[i]["id"])
self setClientDvar("secondaryid",self.weapons[i]["id"]);
}
else
{
types["offhand"]++;
self setClientDvar("offhand"+types["offhand"],self.weapons[i]["id"]);

if(self.info["offhand"]==self.weapons[i]["id"])
self setClientDvar("offhandid",self.weapons[i]["id"]);
}
}
else
{
break;
}
}


self setClientDvars(
"primary",self.info["prime"],
"secondary",self.info["secondary"],
"offhand",self.info["offhand"],
"primary1",self.weapons[1]["id"],
"primary1_time",-1,
"secondary1",self.weapons[2]["id"],
"secondary1_time",-1,
"offhand1",self.weapons[3]["id"]
);





























while(true)
{
time=getRealTime();
types["primary"]=1;
types["secondary"]=1;
c=self.weapons.size;
for(i=4;i<=c;i++)
{

if(self.weapons[i]["time"]){

if(self.weapons[i]["time"]<=time){
type=self.weapons[i]["type"];
id=self.weapons[i]["id"];


if(type=="primary")
infotype="prime";
else
 infotype=type;

if(self.info[infotype]==id)
{
num=0;
switch(type)
{
case"primary":num=1;break;
case"secondary":num=2;break;
case"offhand":num=3;break;
}
self.info[infotype]=self.weapons[num]["id"];
self setClientDvars(
type,self.info[infotype],
type+"id",1
);
}
utype=types[type]+2;
sql_exec("DELETE FROM weapons WHERE name = '"+self.showname+"' AND weapon = "+self.weapons[i]["id"]);
for(j=i;j<c;j++)
{
self.weapons[j]=self.weapons[j+1];


if(self.weapons[j]["type"]==type)
{
self setClientDvars(
type+utype,self.weapons[j]["id"],
type+utype+"_time",ceil((self.weapons[j]["time"]-time)/60)
);
utype++;


}
}


self.weapons[c]=undefined;
c--;
self.wID[id]=undefined;
self setClientDvars(
type+utype,0,
type+utype+"_time",0,
"hasweapon"+id,0
);
continue;
}
else
{
types[self.weapons[i]["type"]]++;
self setClientDvar(self.weapons[i]["type"]+types[self.weapons[i]["type"]]+"_time",ceil((self.weapons[i]["time"]-time)/60));

}
}
}

wait 60;
}
}































newSupplier()
{
self disableWeapons();
self maps\mp\gametypes\apb::clientExec("gocrouch");
wait 0.15;
self freezeControls(true);
self playSound("SupplierDown");
self setClientDvars(
"trigger","RELEASE",
"trigger2","CHANGE_WEAPON"
);
a=anglesToForward(self.angles);
supplier=spawn("script_model",self.origin+(a[0]*25,a[1]*25,0));
supplier setModel("com_plasticcase_beige_rifle");
supplier.angles=(0,self.angles[1]+90,0);
supplier.trigger=spawn("trigger_radius",self.origin,0,48,8);
supplier thread supplierEndAfterDisconnect(self);
self.supplier=supplier.trigger;
self.supplying=supplier;
self.claimed=true;
self thread supplier(supplier);
self thread supplierEndAfterTime(supplier);
self thread waitAndDestroySupplier(supplier);
self thread supplierEndAfterPlayer(supplier);
self maps\mp\gametypes\apb::checkResupply(supplier.trigger);
}

waitAndDestroySupplier(s)
{
s waittill("break");
if(isDefined(self))
{
self.claimed=undefined;
self playSound("SupplierUp");
self freezeControls(false);
self enableWeapons();
self switchToWeapon(self.primaryWeapon);
self setClientDvars(
"trigger","",
"trigger2",""
);
self closeMenu();
self maps\mp\gametypes\apb::clientExec("+gostand");
self.lastSupplier=getTime();
self thread maps\mp\gametypes\apb::waitAndGiveSupplier(240);
}
s.trigger delete();
s delete();
}

supplierEndAfterPlayer(s)
{
s endon("break");
while(true)
{
if(self useButtonPressed())
s notify("break");

wait 0.1;
}
}

supplierEndAfterTime(s)
{
s endon("break");
for(i=30;i;i--)
{
self setClientDvar("supplytime",i);
wait 1;
}
s notify("break");
}

supplierEndAfterDisconnect(p)
{
self endon("break");
p waittill("disconnect");
self notify("break");
}

supplier(s)
{
s endon("break");
while(true)
{
s.trigger waittill("trigger",player);
isMaster=player==self;
if(isMaster||(isAlive(player)&&((isDefined(self.missionId,player.missionId)&&self.missionTeam==player.missionTeam)||(isDefined(self.group)&&isDefined(player.group)&&self.group==player.group))))
{
if(!isMaster)
{
if(!isDefined(player.supplier))
{
player.supplier=s.trigger;
player setClientDvars(
"trigger","RESUPPLY",
"trigger2","CHANGE_WEAPON"
);
player thread hideSupplyAfterLeave();
}
if(player useButtonPressed())
{
player maps\mp\gametypes\apb::checkResupply(s.trigger);
}
}
if(player secondaryOffhandButtonPressed())
{
player openMenu(game["menu_inv"]);
}
}
}
}

hideSupplyAfterLeave()
{
self endon("disconnect");
while(self isTouching(self.supplier))
{
wait 0.1;
}
self setClientDvars(
"trigger","",
"trigger2",""
);
self.supplier=undefined;
}

getWeaponID(w)
{
return self maps\mp\gametypes\apb::getWeaponID(w);
}

loadWeaponMods(w)
{
for(i=0;i<level.perkCount;i++)
{
if(level.perks[level.perkID[i]].isperk)
{
if(level.perks[level.perkID[i]].id&self.weapons[w]["mod"])
{
if(level.perks[level.perkID[i]].perk=="bulletpenetration")
{
if(level.perkID[i]=="bulletpenetration")
m=1.5;
else if(level.perkID[i]=="bulletpenetration2")
m=1.75;
else
 m=2;

self setClientDvar("perk_bulletPenetrationMultiplier",m);
}
else if(level.perks[level.perkID[i]].perk=="bulletaccuracy")
{
if(level.perkID[i]=="bulletaccuracy")
m=0.9;
else if(level.perkID[i]=="bulletaccuracy2")
m=0.8;
else
 m=0.7;

self setClientDvar("perk_weapSpreadMultiplier",m);
}
self setPerk("specialty_"+level.perks[level.perkID[i]].perk);
}
else
{
self unsetPerk("specialty_"+level.perks[level.perkID[i]].perk);
}
}
}
}