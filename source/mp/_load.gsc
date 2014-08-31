#include common_scripts\utility;

main(bScriptgened, bCSVgened, bsgenabled)
{
	// Default structs
	struct_class_init();

	// Effects
	level.createFXent = [];
	thread maps\mp\_createfx::fx_init();
	thread maps\mp\_global_fx::main();

	// APB Interactive elements
	maps\mp\_interactive::main();
}

// It is called due to effects, but millions of functions are linking
// to each other so I won't be able to clean them too
script_gen_dump(){}