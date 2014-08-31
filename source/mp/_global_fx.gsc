#include common_scripts\utility;
#include maps\mp\_utility;

	// This script automaticly plays a users specified oneshot effect on all prefabs that have the 
	// specified "script_struct" and "targetname" It also excepts angles from the "script_struct" 
	// but will set a default angle of ( 0, 0, 0 ) if none is defined.
	//
	// example of the syntax: 
	// global_FX( "targetname", "fxIDname", "fxFile", "delay" )
	
main()
{
	// We are keeping the globalFX system here, so effects will work in prefabs
	level._effect = [];

	randomStartDelay = randomFloatRange(-20, -15);
	
	//map_source/prefabs/misc_models/com_barrel_fire.map
	global_FX( "barrel_fireFX_origin", "fire/firelp_barrel_pm", randomStartDelay, "fire_barrel_small" );

	//map_source/prefabs/misc_models/ch_street_light_02_on.map
	//prefabs/misc_models/ch_street_wall_light_01_on.map
	global_FX( "ch_streetlight_02_FX_origin", "misc/lighthaze", randomStartDelay );

	//prefabs/misc_models/me_streetlight_on_scaleddown80.map
	global_FX( "me_streetlight_01_FX_origin", "misc/lighthaze_bog_a", randomStartDelay );

	//prefabs\village_assault\misc\lamp_post.map
	global_FX( "ch_street_light_01_on", "misc/light_glow_white", randomStartDelay );

	//prefabs\village_assault\misc\highway_lamp_post.map
	global_FX( "highway_lamp_post", "misc/lighthaze_villassault", randomStartDelay );
	
	//prefabs/misc_models/cs_cargoship_spotlight_on.map
	global_FX( "cs_cargoship_spotlight_on_FX_origin", "misc/lighthaze", randomStartDelay );

	//prefabs/misc_models/me_dumpster_fire.map
	global_FX( "me_dumpster_fire_FX_origin", "fire/firelp_med_pm_nodistort", randomStartDelay, "fire_dumpster_medium" );
 
	//map_source/prefabs/misc_models/com_tires01_burning.map
	global_FX( "com_tires_burning01_FX_origin", "fire/tire_fire_med", randomStartDelay );

	//map_source/prefabs/icbm/icbm_powerlinetower02.map
	global_FX( "icbm_powerlinetower_FX_origin", "misc/power_tower_light_red_blink", randomStartDelay );

	// APB old globalFXs
	global_FX("insects_FX_origin", "misc/insects_carcass_flies", randomStartDelay);
	global_FX("amb_dust_hangar_FX_origin", "dust/amb_dust_hangar", randomStartDelay);
	global_FX("stream_FX_origin", "apb/stream", randomStartDelay);
	global_FX("ch_streetlight_01_FX_origin", "misc/light_glow_white", randomStartDelay);
	global_FX("ch_industrial_light_01_on_FX_origin", "misc/lighthaze", randomStartDelay);
	//global_FX("dust100_FX_origin", "dust/room_dust_100_blend", randomStartDelay);
	global_FX("dust200_FX_origin", "dust/room_dust_200_blend", randomStartDelay);
	global_FX("cargosteam_FX_origin", "smoke/cargo_steam", randomStartDelay);
	global_FX("vehicle_burn_FX_origin", "fire/firelp_med_pm_nodistort", randomStartDelay, "fire_dumpster_medium");

	// APB fx_runner system
	ents = getEntArray("fx_runner", "targetname");
	foreach (e as ents)
	{
		e global_FX_create(e.script_fxid, randomStartDelay, e.script_soundalias);
	}
}

global_FX(targetname, fxFile, delay, soundalias)
{
	ents = getStructArray(targetname, "targetname");
	if (isDefined(ents))
	{
		foreach (e as ents)
		{
			e global_FX_create(fxFile, delay, soundalias);
		}
	}
}

global_FX_create(fxFile, delay, soundalias)
{
	if (!isDefined(level._effect[fxFile]))
		level._effect[fxFile] =	loadFx(fxFile);

	if (!isDefined(self.angles))
		self.angles = (0, 0, 0);

	ent = createOneshotEffect(fxFile);
	ent.v["origin"] = self.origin;
	ent.v["angles"] = self.angles;
	ent.v["fxid"] = fxFile;
	ent.v["delay"] = delay;
	if (isDefined(soundalias))
	{
		ent.v["soundalias"] = soundalias;
	}
}