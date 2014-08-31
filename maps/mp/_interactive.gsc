






main()
{

all=getEntArray("breach","targetname");
c=all.size;
if(c)
{
level.effects["breach"]=loadFX("apb/breach");
level.effects["breachMetal"]=loadFX("apb/breach_metal");

for(__i0=0;__i0<c;__i0++)
{
__e0=all[__i0];__e0.triggers=getEntArray(__e0.target,"targetname");
__v1=__e0.triggers;__c1=__v1.size;for(__i1=0;__i1<__c1;__i1++)
{
__e1=__v1[__i1];__e1.door=__e0;
__e1.bomb=getEnt(__e1.target,"targetname");
__e1.bomb hide();
__e1 thread waitBreach();
}__i1=undefined;__c1=undefined;__v1=undefined;
}__i0=undefined;
}


all=getEntArray("fire_ext","targetname");
c=all.size;
if(c)
{
level.effects["fireExt"]=loadFX("apb/fireext");

for(__i2=0;__i2<c;__i2++)
{
all[__i2] setCanDamage(true);
all[__i2] thread waitExt();
}__i2=undefined;
}


all=getEntArray("board","targetname");
c=all.size;
if(c)
{
level.effects["boardCrash"]=loadFX("apb/boardcrack");

for(__i3=0;__i3<c;__i3++)
{
all[__i3] setCanDamage(true);
all[__i3] thread waitBoard();
}__i3=undefined;
}


all=getEntArray("explodable_barrel","targetname");
c=all.size;
if(c)
{
level.effects["explode"]=loadFX("props/barrelExp");
level.effects["burn_start"]=loadFX("props/barrel_ignite");
level.effects["burn"]=loadFX("props/barrel_fire_top");
precacheModel("com_barrel_piece");

level.barrelExplodingThisFrame=false;

for(__i4=0;__i4<c;__i4++)
{
__e4=all[__i4];__e4 setCanDamage(true);
__e4.realModel=__e4.model;
__e4.clip=getEnt(__e4.target,"targetname");
__e4 thread waitBarrel();
}__i4=undefined;
}


all=getEntArray("door_trigger","targetname");
c=all.size;
if(c)
{
level.door_wait=5;
level.door_rotate=2;
for(__i5=0;__i5<c;__i5++)
{
all[__i5] thread door();
}__i5=undefined;
}


level.sin[0]=0;
level.sin[1]=0.0174524;
level.sin[2]=0.0348995;
level.sin[3]=0.052336;
level.sin[4]=0.0697565;
level.sin[5]=0.0871557;
level.sin[6]=0.104528;
level.sin[7]=0.121869;
level.sin[8]=0.139173;
level.sin[9]=0.156434;
level.sin[10]=0.173648;
level.sin[11]=0.190809;
level.sin[12]=0.207912;
level.sin[13]=0.224951;
level.sin[14]=0.241922;
level.sin[15]=0.258819;
level.sin[16]=0.275637;
level.sin[17]=0.292372;
level.sin[18]=0.309017;
level.sin[19]=0.325568;
level.sin[20]=0.34202;
level.sin[21]=0.358368;
level.sin[22]=0.374607;
level.sin[23]=0.390731;
level.sin[24]=0.406737;
level.sin[25]=0.422618;
level.sin[26]=0.438371;
level.sin[27]=0.45399;
level.sin[28]=0.469472;
level.sin[29]=0.48481;
level.sin[30]=0.5;
level.sin[31]=0.515038;
level.sin[32]=0.529919;
level.sin[33]=0.544639;
level.sin[34]=0.559193;
level.sin[35]=0.573576;
level.sin[36]=0.587785;
level.sin[37]=0.601815;
level.sin[38]=0.615662;
level.sin[39]=0.62932;
level.sin[40]=0.642788;
level.sin[41]=0.656059;
level.sin[42]=0.669131;
level.sin[43]=0.681998;
level.sin[44]=0.694658;
level.sin[45]=0.707107;
level.sin[46]=0.71934;
level.sin[47]=0.731354;
level.sin[48]=0.743145;
level.sin[49]=0.75471;
level.sin[50]=0.766044;
level.sin[51]=0.777146;
level.sin[52]=0.788011;
level.sin[53]=0.798635;
level.sin[54]=0.809017;
level.sin[55]=0.819152;
level.sin[56]=0.829038;
level.sin[57]=0.838671;
level.sin[58]=0.848048;
level.sin[59]=0.857167;
level.sin[60]=0.866025;
level.sin[61]=0.87462;
level.sin[62]=0.882948;
level.sin[63]=0.891007;
level.sin[64]=0.898794;
level.sin[65]=0.906308;
level.sin[66]=0.913545;
level.sin[67]=0.920505;
level.sin[68]=0.927184;
level.sin[69]=0.93358;
level.sin[70]=0.939693;
level.sin[71]=0.945519;
level.sin[72]=0.951057;
level.sin[73]=0.956305;
level.sin[74]=0.961262;
level.sin[75]=0.965926;
level.sin[76]=0.970296;
level.sin[77]=0.97437;
level.sin[78]=0.978148;
level.sin[79]=0.981627;
level.sin[80]=0.984808;
level.sin[81]=0.987688;
level.sin[82]=0.990268;
level.sin[83]=0.992546;
level.sin[84]=0.994522;
level.sin[85]=0.996195;
level.sin[86]=0.997564;
level.sin[87]=0.99863;
level.sin[88]=0.999391;
level.sin[89]=0.999848;
level.sin[90]=1;


all=getEntArray("metro","targetname");
c=all.size;
if(c)
{
for(__i6=0;__i6<c;__i6++)
{
__e6=all[__i6];__e6.trigger=getEnt("metro"+__e6.script_noteworthy+"_trigger","targetname");
__e6.trigger enableLinkTo();
__e6.trigger linkTo(__e6);
__e6 thread metroDamage();

__e6.clip=getEnt("metro"+__e6.script_noteworthy+"_clip","targetname");
__e6.tOrigin=__e6.origin;
__e6 playLoopSound("Train");
__e6.stop=false;
__e6 thread moveMetroPoint(getEnt(__e6.target,"targetname"));
}__i6=undefined;
}
}

door()
{
parts=getEntArray(self.target,"targetname");

c=parts.size;
for(__i7=0;__i7<c;__i7++)
{
__e7=parts[__i7];__e7.isRotating=isDefined(__e7.script_noteworthy)&&__e7.script_noteworthy=="rotate";
if(!__e7.isRotating)
{
__e7.pos=__e7.origin;
}

temp=getEntArray(__e7.target,"targetname");
__c8=temp.size;for(__i8=0;__i8<__c8;__i8++)
{
__e8=temp[__i8];if(__e8.classname=="script_origin")
{
if(!__e7.isRotating)
{
__e7.pos2=__e8.origin;
}
else
{
__e7 linkTo(__e8);
__e7.rotator=__e8;
}
}
else
{
__e8 linkTo(__e7);
}
}__i8=undefined;__c8=undefined;
}__i7=undefined;

while(true)
{
self waittill("trigger");
for(__i9=0;__i9<c;__i9++)
{
__e9=parts[__i9];if(!__e9.isRotating)
__e9 moveTo(__e9.pos2,1,0.1,0.1);
else
 __e9.rotator rotateYaw(__e9.angles[2]+90,level.door_rotate);
}__i9=undefined;
self playSound("DoorOpen");
wait level.door_wait;
for(__i10=0;__i10<c;__i10++)
{
__e10=parts[__i10];if(!__e10.isRotating)
__e10 moveTo(__e10.pos,1,0.1,0.1);
else
 __e10.rotator rotateYaw(__e10.angles[2]-90,level.door_rotate);
}__i10=undefined;
self playSound("DoorClose");
wait 1;
}
}

metroDamage()
{
while(true)
{
self.trigger waittill("trigger",p);
if(!self.stop)
{
p suicide();
}
}
}



moveMetroPoint(next)
{


if(self.tOrigin[0]==next.origin[0]||self.tOrigin[1]==next.origin[1])
{
if(self.tOrigin[0]==next.origin[0])
time=abs(self.tOrigin[1]-next.origin[1])/1000;

else time=abs(self.tOrigin[0]-next.origin[0])/1000;

if(time)
{

if(isDefined(next.script_timer))
{
if(self.stop)
{
self moveMetro(next.origin,time,2,2);
wait 0.5;
time-=0.5;
self.stop=false;
}
else
 self moveMetro(next.origin,time,0,2);

wait time-0.5;
self.stop=true;
wait 0.5+next.script_timer;
}
else
{
if(self.stop)
{
self moveMetro(next.origin,time,2);
wait 0.5;
time-=0.5;
self.stop=false;
}
else
 self moveMetro(next.origin,time);

wait time;
}
}
}
else
{
a=self.angles;
p=next.origin-self.tOrigin;

q=(p[0]>0&&p[1]>0)||(p[0]<0&&p[1]<0);
r=next.script_turningdir=="right";
rev=q==r;
if(rev)
o=(next.origin[0],self.tOrigin[1],self.tOrigin[2]);
else
 o=(self.tOrigin[0],next.origin[1],self.tOrigin[2]);

if(q)
{
x=p[0];
y=-1*p[1];
}
else
{
x=-1*p[0];
y=p[1];
}

if(r)
{
s=-1;
x*=-1;
y*=-1;
}
else
{
s=1;
}
for(i=2;i<=90;i+=2)
{
if(rev)
to=o+(x*level.sin[90-i],y*level.sin[i],0);
else
 to=o+(x*level.sin[i],y*level.sin[90-i],0);

rto=a+(0,i*s,0);

self moveMetro(to,0.1);
self rotateMetro(rto,0.1);

wait 0.1;
}
}
self.tOrigin=next.origin;

if(isDefined(next.target))
self thread moveMetroPoint(getEnt(next.target,"targetname"));
}

moveMetro(origin,time,acc,dec)
{
if(!isDefined(acc))
acc=0;

if(!isDefined(dec))
dec=0;

self moveTo(origin,time,acc,dec);
self.clip moveTo(origin,time,acc,dec);
}

rotateMetro(angle,time)
{
self rotateTo(angle,time);
self.clip rotateTo(angle-(0,90,0),time);
}

respawn()
{
wait 110;
delay=true;
while(delay)
{
wait 10;
delay=false;
__v11=level.allActivePlayers;__c11=level.allActiveCount;if(__c11){for(__i11=0;__i11<__c11;__i11++)
{

if(distanceSquared(self.origin,__v11[__i11].origin)<1048576){
delay=true;
break;
}
}__i11=undefined;}__c11=undefined;__v11=undefined;
}
}

waitBarrel()
{
while(true)
{
self.damageTaken=0;
self damageBarrel();
self respawn();
self setModel(self.realModel);
self.clip solid();
}
}

damageBarrel()
{
self endon("exploding");

while(self.damageTaken<150)
{
self waittill("damage",amount,attacker,dir,vec,type);
if(type!="MOD_MELEE"&&type!="MOD_IMPACT")
{
self.attacker=attacker;

if(level.barrelExplodingThisFrame)
wait randomFloat(1);

if(!self.damageTaken)
self thread burnBarrel();

self.damageTaken+=amount;
}
}
}

burnBarrel()
{
playFX(level.effects["burn_start"],self.origin);

for(i=0;self.damageTaken<150;i++)
{
playFX(level.effects["burn"],self.origin+(0,0,44));

if(!(i%20))
{
self.damageTaken+=10+randomFloat(10);
}
wait 0.05;
}

self notify("exploding");

self playSound("explo_metal_rand");

playFX(level.effects["explode"],self.origin+(0,0,4));
physicsExplosionSphere(self.origin+(0,0,4),100,80,1);

level.barrelExplodingThisFrame=true;

self.clip notsolid();

if(isDefined(self.attacker))
self radiusDamage(self.origin+(0,0,30),250,250,1,self.attacker);
else
 self radiusDamage(self.origin+(0,0,30),250,250,1);


self setModel("com_barrel_piece");



wait 0.05;
level.barrelExplodingThisFrame=false;
}

waitBreach()
{
while(true)
{
self waittill("trigger",player);
self.bomb show();
__v12=self.door.triggers;__c12=__v12.size;for(__i12=0;__i12<__c12;__i12++)
{
__v12[__i12].origin-=(0,0,256);
}__i12=undefined;__c12=undefined;__v12=undefined;
wait 1;
self.door playSound("ui_mp_suitcasebomb_timer");
wait 1;
self.door playSound("ui_mp_suitcasebomb_timer");
wait 1;

self.bomb hide();
self.door notSolid();
self.door hide();
playFX(level.effects["breachMetal"],self.door.origin,self.door.angles);
playFX(level.effects["breachMetal"],self.door.origin,self.door.angles*-1);
playFX(level.effects["breach"],self.door.origin);

if(isDefined(player))
self radiusDamage(self.bomb.origin,128,200,50,player);
else
 self radiusDamage(self.bomb.origin,128,200,50);

physicsExplosionSphere(self.door.origin,160,0,2);
self.door playSound("breach");
self respawn();
self.door show();
self.door solid();
__v13=self.door.triggers;__c13=__v13.size;for(__i13=0;__i13<__c13;__i13++)
{
__v13[__i13].origin+=(0,0,256);
}__i13=undefined;__c13=undefined;__v13=undefined;
}
}


waitExt()
{
self.maxhp=20;
self.hp=self.maxhp;
self.middle=self.origin+(0,0,8);
while(true)
{
self waittill("damage",dmg,player);
self.hp-=dmg;
if(self.hp<=0)
{

playFX(level.effects["fireExt"],self.middle,self.script_angles);

if(isDefined(player))
self radiusDamage(self.middle,64,200,50,player);
else
 self radiusDamage(self.middle,64,200,50);

physicsExplosionSphere(self.middle,96,0,1.5);
self playSound("fireext");
self playSound("stream");
self respawn();

self.hp=self.maxhp;
}
}
}

waitBoard()
{
self.maxhp=200;
self.hp=self.maxhp;
while(true)
{
self waittill("damage",dmg);
self.hp-=dmg;
if(self.hp<=0)
{
playFX(level.effects["boardCrash"],self.origin);
self playSound("BoardCrash");
self hide();
self notSolid();
self respawn();
self show();
self solid();
self.hp=self.maxhp;
}
}
}