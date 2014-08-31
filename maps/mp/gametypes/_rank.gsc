






init()
{
level.maxRank=int(tableLookup("mp/ratingTable.csv",0,"maxrank",1));
level.maxRating=int(tableLookup("mp/ratingTable.csv",0,"maxrating",1));
for(i=0;i<=level.maxRating;i++)
{
level.ranks[i]["min"]=int(tableLookup("mp/ratingTable.csv",0,i,1));
level.ranks[i]["points"]=int(tableLookup("mp/ratingTable.csv",0,i,2));
level.ranks[i]["id"]=tableLookup("mp/ratingTable.csv",0,i,3);
level.ranks[i]["max"]=int(tableLookup("mp/ratingTable.csv",0,i,4));
}
for(i=1;i<=level.maxRank;i++)
{
preCacheShader("rank"+i+"_allies_silver");
preCacheShader("rank"+i+"_axis_silver");




}

level thread onPlayerConnect();
}

onPlayerConnect()
{
while(true)
{
level waittill("connected",player);
player thread onPlayerSpawned();
}
}

padRating(r)
{
r++;

if(r<10)
r="00"+r;
else if(r<100)
r="0"+r;

return r;
}

giveStanding(amount)
{
if(!amount||self.rating==level.maxRating)
return 0;

amount=int(amount*level.prestige[self.prestige]);

if(self.premium)
add=int(amount/2);
else
 add=0;


new=self.info["standing"]+amount+add;
if(new>level.ranks[level.maxRating]["max"])
self.info["standing"]=level.ranks[level.maxRating]["max"];
else
 self.info["standing"]=new;


rating=self getRating();

if(rating>self.rating)
{
backup=level.ranks[self.rating]["id"];
plus=self.rating+1;


new=[];
for(i=plus;i<=rating;i++)
{
w=tableLookup("mp/weaponTable.csv",12,i,2);
if(w!="")
{
new[new.size]=w;
}
}
if(new.size)
{
info=spawnStruct();
info.title=level.s["NEWWEAPON_TITLE_"+self.lang];
info.line=level.s["NEWWEAPON_DESC_"+self.lang]+"\n"+implode(new);
info.icon="newweapon";
info.sound="RewardReceivedWeapon";
self thread maps\mp\gametypes\apb::gameMessage(info);
}



















for(i=plus;i<=rating;i++)
{
w=int(tableLookup("mp/modTable.csv",5,i,0));
if(w)
{
info=spawnStruct();
info.title=level.s["NEWMOD_TITLE_"+self.lang];
info.line=level.s["NEWMOD_DESC_"+self.lang];
info.icon="newmod";
info.sound="RewardReceivedMod";
self thread maps\mp\gametypes\apb::gameMessage(info);
break;
}
}

for(i=plus;i<=rating;i++)
{
w=int(tableLookup("mp/symbolTable.csv",1,i,0));
if(w)
{
info=spawnStruct();
info.title=level.s["NEWSYMBOL_TITLE_"+self.lang];
info.line=level.s["NEWSYMBOL_DESC_"+self.lang];
info.icon="newsymbol";
info.sound="RewardReceivedArt";
self thread maps\mp\gametypes\apb::gameMessage(info);
break;
}
}

self.rating=rating;
self setClientDvars(
"rating",self.rating,
"rating_pad",padRating(self.rating)
);

info=spawnStruct();
info.title=level.s["RATINGUP_TITLE_"+self.lang];
info.line=level.s["RATINGUP_"+self.lang]+": ^3"+(self.rating+1);
info.icon="rating";
self thread maps\mp\gametypes\apb::gameMessage(info);

if(level.ranks[self.rating]["id"]!=backup)
{
rank=level.ranks[self.rating]["id"]+"_"+self.team;

info=spawnStruct();
info.title=level.s["RANKUP_TITLE_"+self.lang];
info.line=level.s["RANK"+level.ranks[self.rating]["id"]+"_"+level.upper[self.team]+"_"+self.lang];
info.icon="rank"+rank+"_silver";
self thread maps\mp\gametypes\apb::gameMessage(info);
self setClientDvars(
"rankicon",rank,
"threat",self.threat
);
if(isDefined(self.missionTeam))
{

__v0=level.teams[self.missionTeam];__c0=__v0.size;for(__i0=0;__i0<__c0;__i0++)
{
__v0[__i0].playerStats[self.clientid].rank=rank;
}__i0=undefined;__c0=undefined;__v0=undefined;
__v1=level.teams[self.enemyTeam];__c1=__v1.size;for(__i1=0;__i1<__c1;__i1++)
{
__v1[__i1].playerStats[self.clientid].rank=rank;
}__i1=undefined;__c1=undefined;__v1=undefined;
}
}
if(isDefined(self.missionTeam))
{
__v2=level.teams[self.missionTeam];__c2=__v2.size;for(__i2=0;__i2<__c2;__i2++)
{
__v2[__i2].playerStats[self.clientid].rating=rating;
}__i2=undefined;__c2=undefined;__v2=undefined;
__v3=level.teams[self.enemyTeam];__c3=__v3.size;for(__i3=0;__i3<__c3;__i3++)
{
__v3[__i3].playerStats[self.clientid].rating=rating;
}__i3=undefined;__c3=undefined;__v3=undefined;
}
}

if(!level.ranks[self.rating]["points"])
self setClientDvar("ratio",1);
else
 self setClientDvar("ratio",(self.info["standing"]-level.ranks[self.rating]["min"])/level.ranks[self.rating]["points"]);

if(isDefined(self.missionTeam))
{
self.stat["standing"]+=amount;

if(self.premium)
self.stat["pstanding"]+=add;

self maps\mp\gametypes\apb::refreshStat("standing","pstanding");
}

return amount+"^3 + "+add+"^7";
}

onPlayerSpawned()
{
self endon("disconnect");

self waittill("spawned_player");

self.rating=self getRating();

self setClientDvars(
"rating",self.rating,
"rating_pad",padRating(self.rating),
"rankicon",level.ranks[self.rating]["id"]+"_"+self.team,
"threat",self.threat
);
if(level.ranks[self.rating]["points"])
self setClientDvar("ratio",(self.info["standing"]-level.ranks[self.rating]["min"])/level.ranks[self.rating]["points"]);
else
 self setClientDvar("ratio",0);

if(!isDefined(self.killfeed))
{
self.killfeed=newClientHudElem(self);
self.killfeed.horzAlign="center";
self.killfeed.vertAlign="middle";
self.killfeed.alignX="center";
self.killfeed.alignY="middle";
self.killfeed.x=0;
self.killfeed.y=100;
self.killfeed.font="default";
self.killfeed.fontscale=2;
self.killfeed.archived=false;
self.killfeed.color=(1,1,1);
}
}

getRating()
{
if(self.info["standing"]==level.ranks[level.maxRating]["max"])
return level.maxRating;

for(i=0;i<=level.maxRating;i++)
{
if(self.info["standing"]<level.ranks[i]["max"])
return i;
}
}


implode(array)
{
c=array.size;
if(!c)
return"";

if(c==1)
return array[0];

s=array[0];
for(i=1;i<c;i++)
{
s+=", "+array[i];
}
return s;
}