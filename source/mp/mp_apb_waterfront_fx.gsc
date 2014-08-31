main()
{
/#
	if (getdvar("clientSideEffects") != "1")
		maps\createfx\mp_apb_waterfront_fx::main();
#/
}

//+ai_shownodes 1 +ai_shownearestnode 64 +g_entinfo 1 +ai_showpaths 1