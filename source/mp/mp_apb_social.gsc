main()
{
	if (getDvar("r_reflectionProbeGenerate") == "1" || !isDefined(level.script))
		return;

	//maps\mp\mp_apb_social_fx::main();

	maps\mp\_load::main();
}