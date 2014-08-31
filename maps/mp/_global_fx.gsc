





#include common_scripts\utility;
#include maps\mp\_utility;


main()
{

level._effect=[];

randomStartDelay=randomFloatRange(-20,-15);


global_FX("barrel_fireFX_origin","fire/firelp_barrel_pm",randomStartDelay,"fire_barrel_small");



global_FX("ch_streetlight_02_FX_origin","misc/lighthaze",randomStartDelay);


global_FX("me_streetlight_01_FX_origin","misc/lighthaze_bog_a",randomStartDelay);


global_FX("ch_street_light_01_on","misc/light_glow_white",randomStartDelay);


global_FX("highway_lamp_post","misc/lighthaze_villassault",randomStartDelay);


global_FX("cs_cargoship_spotlight_on_FX_origin","misc/lighthaze",randomStartDelay);


global_FX("me_dumpster_fire_FX_origin","fire/firelp_med_pm_nodistort",randomStartDelay,"fire_dumpster_medium");


global_FX("com_tires_burning01_FX_origin","fire/tire_fire_med",randomStartDelay);


global_FX("icbm_powerlinetower_FX_origin","misc/power_tower_light_red_blink",randomStartDelay);


global_FX("insects_FX_origin","misc/insects_carcass_flies",randomStartDelay);
global_FX("amb_dust_hangar_FX_origin","dust/amb_dust_hangar",randomStartDelay);
global_FX("stream_FX_origin","apb/stream",randomStartDelay);
global_FX("ch_streetlight_01_FX_origin","misc/light_glow_white",randomStartDelay);
global_FX("ch_industrial_light_01_on_FX_origin","misc/lighthaze",randomStartDelay);

global_FX("dust200_FX_origin","dust/room_dust_200_blend",randomStartDelay);
global_FX("cargosteam_FX_origin","smoke/cargo_steam",randomStartDelay);
global_FX("vehicle_burn_FX_origin","fire/firelp_med_pm_nodistort",randomStartDelay,"fire_dumpster_medium");


ents=getEntArray("fx_runner","targetname");
__c0=ents.size;if(__c0){for(__i0=0;__i0<__c0;__i0++)
{
__e0=ents[__i0];__e0 global_FX_create(__e0.script_fxid,randomStartDelay,__e0.script_soundalias);
}__i0=undefined;}__c0=undefined;
}

global_FX(targetname,fxFile,delay,soundalias)
{
ents=getStructArray(targetname,"targetname");
if(isDefined(ents))
{
__c1=ents.size;if(__c1){for(__i1=0;__i1<__c1;__i1++)
{
ents[__i1] global_FX_create(fxFile,delay,soundalias);
}__i1=undefined;}__c1=undefined;
}
}

global_FX_create(fxFile,delay,soundalias)
{
if(!isDefined(level._effect[fxFile]))
level._effect[fxFile]=loadFx(fxFile);

if(!isDefined(self.angles))
self.angles=(0,0,0);

ent=createOneshotEffect(fxFile);
ent.v["origin"]=self.origin;
ent.v["angles"]=self.angles;
ent.v["fxid"]=fxFile;
ent.v["delay"]=delay;
if(isDefined(soundalias))
{
ent.v["soundalias"]=soundalias;
}
}