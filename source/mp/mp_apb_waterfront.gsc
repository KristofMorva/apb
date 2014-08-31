#include common_scripts\utility;

main()
{
	if (getDvar("r_reflectionProbeGenerate") == "1" || !isDefined(level.script))
		return;

	maps\mp\mp_apb_waterfront_fx::main();

	level._effects["lighthaze"] = loadFx("apb/lighthaze");
	level._effects["red_smoke"] = loadFx("apb/red_smoke");
	level._effects["glass_112_128"] = loadFx("apb/glass_break_112_128");
	level._effects["glass_190_32"] = loadFx("apb/glass_break_190_32");
	level._effects["glass_190_62"] = loadFx("apb/glass_break_190_62");
	level._effects["glass_62_32"] = loadFx("apb/glass_break_62_32");
	level._effects["glass_64_64"] = loadFx("apb/glass_break_64_64");
	level._effects["glass_254_32"] = loadFx("apb/glass_break_254_32");
	level._effects["glass_254_62"] = loadFx("apb/glass_break_254_62");

	maps\mp\_load::main();

	/*game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";*/

	preCacheShader("sun");
	preCacheShader("sun_flare_icbm");

	//level waittill("begin");

	//thread metro();
	//thread doors_init();
	//thread billboard();

	// Radios
	/*foreach (r as getEntArray("radio", "targetname"))
	{
		// play local sound <radios_array[i].script_sound> at pos <radios_array[i].origin>
		// wait <length of music>
	}*/

	// Effects
	foreach (e as getstructarray("effect", "targetname"))
	{
		if (!isDefined(e.angles))
		{
			e.angles = (90, 0, 0);
		}
		playFx(level._effects[e.script_fxid], e.origin, anglesToforward(e.angles), anglesToUp(e.angles));
	}

	// Glasses
	foreach (g as getEntArray("glass", "targetname"))
	{
		g setCanDamage(true);

		pieces = getEntArray(g.target, "targetname");

		trigger = 0;
		broken = 1;
		if (pieces[0].classname == "script_brushmodel")
		{
			broken = 0;
			trigger = 1;
		}

		if (pieces.size == 2)
		{
			pieces[trigger].glass = g;
			pieces[trigger] thread glass_trigger_idle();
		}

		g.broken = pieces[broken];
		g.broken hide();
		g.broken notSolid();

		g.fxAngles[0] = (0, 0, 0);
		g.fxAngles[1] = (0, 0, 0);
		if (isDefined(g.script_angles))
		{
			g.fxAngles[0] = g.script_angles;
			g.fxAngles[1] = g.script_angles;
		}
		g.fxAngles[0] = anglesToForward(g.fxAngles[0]);
		g.fxAngles[1] = anglesToUp(g.fxAngles[1]);

		g thread glass_idle();
	}

	// Elevators
	foreach (e as getEntArray("elevator", "targetname"))
	{
		e.positions = [];
		e.status = "up";
		e.cool = true;

		foreach (o as getEntArray(e.target, "targetname"))
		{
			if (o.classname == "trigger_use_touch")
			{
				o.master = e;
				o thread elevator_listen();
			}
			else
			{
				e.positions[o.script_noteworthy] = o.origin;
			}
		}
	}
}

elevator_listen()
{
	while (true)
	{
		self waittill("trigger");
		if (self.master.cool && self.script_noteworthy != self.master.status)
		{
			self.master.cool = false;
			self.master moveTo(self.master.positions[self.script_noteworthy], 10, 1, 1);
			self.master.status = self.script_noteworthy;
			self.master playSound("LiftStart");
			wait 1;
			self.master playLoopSound("LiftMove");
			wait 8;
			self.master stopLoopSound();
			self.master playSound("LiftStop");
			wait 2;
			self.master.cool = true;
		}
	}
}

glass_idle()
{
	while (true)
	{
		self.damage = 0;
		while (self.damage <= 60)
		{
			if (self.damage >= 30)
			{
				self hide();
				self.broken show();
			}
			self waittill("damage", dmg);
			self.damage += dmg;
		}
		playFx(level._effects["glass_" + self.script_fxid], self.origin, self.fxAngles[0], self.fxAngles[1]);
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
	while (true)
	{
		self waittill("trigger", player);
		if (self.glass.damage >= 30)
		{
			if (player getVelocity()[0] > 200)
			{
				self.glass notify("damage", 100);
			}
		}
	}
}

/*billboard()
{
	board_idle = 5;
	board_turn = 2;
	board_acc = 0.3;
	board_dec = 0.3;

	pieces = getEntArray("billboard_turn", "targetname");

	while (true)
	{
		for (i = 0; i < pieces.size; i++)
		{
			pieces[i] rotateYaw(pieces[i].angles[2] + 180, board_turn, board_acc, board_dec);
		}
		wait board_turn + board_idle;
	}
}

metro()
{
	METRO_TIME = 10;
	METRO_WAIT = 5;
	METRO_ACC = 3;
	METRO_DEC = 3;

	m = getEnt("metro", "targetname");
	m_hurt = getEnt("metro_hurt", "targetname");
	m_jump = getEnt("metro_nojump", "targetname");
	m_goto = getEnt("metro_goto", "targetname");
	m_goto2 = getEnt("metro_goto2", "targetname");

	m2 = getEnt("metro_2", "targetname");
	m2_hurt = getEnt("metro_2_hurt", "targetname");
	m2_jump = getEnt("metro_2_nojump", "targetname");
	m2_goto = getEnt("metro_2_goto", "targetname");
	m2_goto2 = getEnt("metro_2_goto2", "targetname");

	m_hurt enableLinkTo();
	m_hurt linkTo(m);
	m_jump enableLinkTo();
	m_jump linkTo(m);
	m_hurt thread metro_damage(METRO_TIME, METRO_WAIT, METRO_ACC, METRO_DEC);
	m_jump thread metro_jump();

	m2_hurt enableLinkTo();
	m2_hurt linkTo(m2);
	m2_jump enableLinkTo();
	m2_jump linkTo(m2);
	m2_hurt thread metro_damage(METRO_TIME, METRO_WAIT, METRO_ACC, METRO_DEC);
	m2_jump thread metro_jump();

	while (true)
	{
		m moveTo(m_goto.origin, METRO_TIME, METRO_ACC, METRO_DEC);
		m2 moveTo(m2_goto2.origin, METRO_TIME, METRO_ACC, METRO_DEC);
		wait METRO_TIME + METRO_WAIT;

		m moveTo(m_goto2.origin, METRO_TIME, METRO_ACC, METRO_DEC);
		m2 moveTo(m2_goto.origin, METRO_TIME, METRO_ACC, METRO_DEC);
		wait METRO_TIME + METRO_WAIT;
	}
}

metro_damage(METRO_TIME, METRO_WAIT, METRO_ACC, METRO_DEC)
{
	ent = spawn("script_origin", (0, 0, 0));

	while (true)
	{
		wait METRO_ACC;

		self useBy(ent);
		self.active = true;

		wait METRO_TIME - METRO_ACC - METRO_DEC;

		self useBy(ent);
		self.active = false;

		wait METRO_DEC + METRO_WAIT;
	}
}

metro_jump()
{
	while (true)
	{
		self waittill("trigger", player);
		player thread checkJump(self);
		wait 0.05;
	}
}

checkJump(trigger)
{
	self allowJump(false);
	while (true)
	{
		printLn(self getVelocity());
		if (!self isTouching(trigger))
		{
			self allowJump(true);
			return;
		}
		wait 0.05;
	}
}*/