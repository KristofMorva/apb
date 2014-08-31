#include common_scripts\utility;

main()
{
if(getDvar("r_reflectionProbeGenerate")=="1"||!isDefined(level.script))
return;

maps\mp\mp_apb_waterfront_fx::main();

level._effects["lighthaze"]=loadFx("apb/lighthaze");
level._effects["red_smoke"]=loadFx("apb/red_smoke");
level._effects["glass_112_128"]=loadFx("apb/glass_break_112_128");
level._effects["glass_190_32"]=loadFx("apb/glass_break_190_32");
level._effects["glass_190_62"]=loadFx("apb/glass_break_190_62");
level._effects["glass_62_32"]=loadFx("apb/glass_break_62_32");
level._effects["glass_64_64"]=loadFx("apb/glass_break_64_64");
level._effects["glass_254_32"]=loadFx("apb/glass_break_254_32");
level._effects["glass_254_62"]=loadFx("apb/glass_break_254_62");

maps\mp\_load::main();








preCacheShader("sun");
preCacheShader("sun_flare_icbm");















__v0=getstructarray("effect","targetname");__c0=__v0.size;if(__c0){for(__i0=0;__i0<__c0;__i0++)
{
__e0=__v0[__i0];if(!isDefined(__e0.angles))
{
__e0.angles=(90,0,0);
}
playFx(level._effects[__e0.script_fxid],__e0.origin,anglesToforward(__e0.angles),anglesToUp(__e0.angles));
}__i0=undefined;}__c0=undefined;__v0=undefined;


__v1=getEntArray("glass","targetname");__c1=__v1.size;if(__c1){for(__i1=0;__i1<__c1;__i1++)
{
__e1=__v1[__i1];__e1 setCanDamage(true);

pieces=getEntArray(__e1.target,"targetname");

trigger=0;
broken=1;
if(pieces[0].classname=="script_brushmodel")
{
broken=0;
trigger=1;
}

if(pieces.size==2)
{
pieces[trigger].glass=__e1;
pieces[trigger]thread glass_trigger_idle();
}

__e1.broken=pieces[broken];
__e1.broken hide();
__e1.broken notSolid();

__e1.fxAngles[0]=(0,0,0);
__e1.fxAngles[1]=(0,0,0);
if(isDefined(__e1.script_angles))
{
__e1.fxAngles[0]=__e1.script_angles;
__e1.fxAngles[1]=__e1.script_angles;
}
__e1.fxAngles[0]=anglesToForward(__e1.fxAngles[0]);
__e1.fxAngles[1]=anglesToUp(__e1.fxAngles[1]);

__e1 thread glass_idle();
}__i1=undefined;}__c1=undefined;__v1=undefined;


__v2=getEntArray("elevator","targetname");__c2=__v2.size;if(__c2){for(__i2=0;__i2<__c2;__i2++)
{
__e2=__v2[__i2];__e2.positions=[];
__e2.status="up";
__e2.cool=true;

__v3=getEntArray(__e2.target,"targetname");__c3=__v3.size;if(__c3){for(__i3=0;__i3<__c3;__i3++)
{
__e3=__v3[__i3];if(__e3.classname=="trigger_use_touch")
{
__e3.master=__e2;
__e3 thread elevator_listen();
}
else
{
__e2.positions[__e3.script_noteworthy]=__e3.origin;
}
}__i3=undefined;}__c3=undefined;__v3=undefined;
}__i2=undefined;}__c2=undefined;__v2=undefined;
}

elevator_listen()
{
while(true)
{
self waittill("trigger");
if(self.master.cool&&self.script_noteworthy!=self.master.status)
{
self.master.cool=false;
self.master moveTo(self.master.positions[self.script_noteworthy],10,1,1);
self.master.status=self.script_noteworthy;
self.master playSound("LiftStart");
wait 1;
self.master playLoopSound("LiftMove");
wait 8;
self.master stopLoopSound();
self.master playSound("LiftStop");
wait 2;
self.master.cool=true;
}
}
}

glass_idle()
{
while(true)
{
self.damage=0;
while(self.damage<=60)
{
if(self.damage>=30)
{
self hide();
self.broken show();
}
self waittill("damage",dmg);
self.damage+=dmg;
}
playFx(level._effects["glass_"+self.script_fxid],self.origin,self.fxAngles[0],self.fxAngles[1]);
self playSound("veh_glass_break_large");
self hide();
self notSolid();
self.broken hide();
wait 60;
self show();
self solid();
}
}

glass_trigger_idle()
{
while(true)
{
self waittill("trigger",player);
if(self.glass.damage>=30)
{
if(player getVelocity()[0]>200)
{
self.glass notify("damage",100);
}
}
}
}












































































































