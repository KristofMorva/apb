///////////////////////////////////////////////////////////
//            APB Mod - Morva 'iCore' Kristóf            //
//                moddb.com/members/icore                //
//    Using without permission is strictly forbidden!    //
//     Data stealing is rated as a criminal offence!     //
///////////////////////////////////////////////////////////

main()
{
	// Breachable doors
	all = getEntArray("breach", "targetname");
	c = all.size;
	if (c)
	{
		level.effects["breach"] = loadFX("apb/breach");
		level.effects["breachMetal"] = loadFX("apb/breach_metal");

		foreach (e as all;;+c)
		{
			e.triggers = getEntArray(e.target, "targetname");
			foreach (t as e.triggers;;+)
			{
				t.door = e;
				t.bomb = getEnt(t.target, "targetname");
				t.bomb hide();
				t thread waitBreach();
			}
		}
	}

	// Fire extinguishers
	all = getEntArray("fire_ext", "targetname");
	c = all.size;
	if (c)
	{
		level.effects["fireExt"] = loadFX("apb/fireext");

		foreach (e as all;;+c)
		{
			e setCanDamage(true);
			e thread waitExt();
		}
	}

	// Boards
	all = getEntArray("board", "targetname");
	c = all.size;
	if (c)
	{
		level.effects["boardCrash"] = loadFX("apb/boardcrack");

		foreach (e as all;;+c)
		{
			e setCanDamage(true);
			e thread waitBoard();
		}
	}

	// Explodeable barrels
	all = getEntArray("explodable_barrel", "targetname");
	c = all.size;
	if (c)
	{
		level.effects["explode"] = loadFX("props/barrelExp");
		level.effects["burn_start"] = loadFX("props/barrel_ignite");
		level.effects["burn"] = loadFX("props/barrel_fire_top");
		precacheModel("com_barrel_piece");
		//precacheModel("com_barrel_piece2"); // Comment out back if have free xmodels
		level.barrelExplodingThisFrame = false;

		foreach (e as all;;+c)
		{
			e setCanDamage(true);
			e.realModel = e.model;
			e.clip = getEnt(e.target, "targetname");
			e thread waitBarrel();
		}
	}

	// Doors
	all = getEntArray("door_trigger", "targetname");
	c = all.size;
	if (c)
	{
		level.door_wait = 5;
		level.door_rotate = 2;
		foreach (e as all;;+c)
		{
			e thread door();
		}
	}

	// Predefined sinus values ~ not sure if better this way or not
	level.sin[0] = 0;
	level.sin[1] = 0.0174524;
	level.sin[2] = 0.0348995;
	level.sin[3] = 0.052336;
	level.sin[4] = 0.0697565;
	level.sin[5] = 0.0871557;
	level.sin[6] = 0.104528;
	level.sin[7] = 0.121869;
	level.sin[8] = 0.139173;
	level.sin[9] = 0.156434;
	level.sin[10] = 0.173648;
	level.sin[11] = 0.190809;
	level.sin[12] = 0.207912;
	level.sin[13] = 0.224951;
	level.sin[14] = 0.241922;
	level.sin[15] = 0.258819;
	level.sin[16] = 0.275637;
	level.sin[17] = 0.292372;
	level.sin[18] = 0.309017;
	level.sin[19] = 0.325568;
	level.sin[20] = 0.34202;
	level.sin[21] = 0.358368;
	level.sin[22] = 0.374607;
	level.sin[23] = 0.390731;
	level.sin[24] = 0.406737;
	level.sin[25] = 0.422618;
	level.sin[26] = 0.438371;
	level.sin[27] = 0.45399;
	level.sin[28] = 0.469472;
	level.sin[29] = 0.48481;
	level.sin[30] = 0.5;
	level.sin[31] = 0.515038;
	level.sin[32] = 0.529919;
	level.sin[33] = 0.544639;
	level.sin[34] = 0.559193;
	level.sin[35] = 0.573576;
	level.sin[36] = 0.587785;
	level.sin[37] = 0.601815;
	level.sin[38] = 0.615662;
	level.sin[39] = 0.62932;
	level.sin[40] = 0.642788;
	level.sin[41] = 0.656059;
	level.sin[42] = 0.669131;
	level.sin[43] = 0.681998;
	level.sin[44] = 0.694658;
	level.sin[45] = 0.707107;
	level.sin[46] = 0.71934;
	level.sin[47] = 0.731354;
	level.sin[48] = 0.743145;
	level.sin[49] = 0.75471;
	level.sin[50] = 0.766044;
	level.sin[51] = 0.777146;
	level.sin[52] = 0.788011;
	level.sin[53] = 0.798635;
	level.sin[54] = 0.809017;
	level.sin[55] = 0.819152;
	level.sin[56] = 0.829038;
	level.sin[57] = 0.838671;
	level.sin[58] = 0.848048;
	level.sin[59] = 0.857167;
	level.sin[60] = 0.866025;
	level.sin[61] = 0.87462;
	level.sin[62] = 0.882948;
	level.sin[63] = 0.891007;
	level.sin[64] = 0.898794;
	level.sin[65] = 0.906308;
	level.sin[66] = 0.913545;
	level.sin[67] = 0.920505;
	level.sin[68] = 0.927184;
	level.sin[69] = 0.93358;
	level.sin[70] = 0.939693;
	level.sin[71] = 0.945519;
	level.sin[72] = 0.951057;
	level.sin[73] = 0.956305;
	level.sin[74] = 0.961262;
	level.sin[75] = 0.965926;
	level.sin[76] = 0.970296;
	level.sin[77] = 0.97437;
	level.sin[78] = 0.978148;
	level.sin[79] = 0.981627;
	level.sin[80] = 0.984808;
	level.sin[81] = 0.987688;
	level.sin[82] = 0.990268;
	level.sin[83] = 0.992546;
	level.sin[84] = 0.994522;
	level.sin[85] = 0.996195;
	level.sin[86] = 0.997564;
	level.sin[87] = 0.99863;
	level.sin[88] = 0.999391;
	level.sin[89] = 0.999848;
	level.sin[90] = 1;

	// Trains
	all = getEntArray("metro", "targetname");
	c = all.size;
	if (c)
	{
		foreach (e as all;;+c)
		{
			e.trigger = getEnt("metro" + e.script_noteworthy + "_trigger", "targetname");
			e.trigger enableLinkTo();
			e.trigger linkTo(e);
			e thread metroDamage();

			e.clip = getEnt("metro" + e.script_noteworthy + "_clip", "targetname"); // Maybe try LinkTo()-ing these somehow?
			e.tOrigin = e.origin;
			e playLoopSound("Train"); // TODO: Different for stop/start
			e.stop = false; // Stopped
			e thread moveMetroPoint(getEnt(e.target, "targetname"));
		}
	}
}

door()
{
	parts = getEntArray(self.target, "targetname");

	c = parts.size;
	foreach (e as parts;;+c)
	{
		e.isRotating = isDefined(e.script_noteworthy) && e.script_noteworthy == "rotate";
		if (!e.isRotating)
		{
			e.pos = e.origin;
		}

		temp = getEntArray(e.target, "targetname");
		foreach (f as temp;;+)
		{
			if (f.classname == "script_origin")
			{
				if (!e.isRotating)
				{
					e.pos2 = f.origin;
				}
				else
				{
					e linkTo(f); // temp[i]?
					e.rotator = f;
				}
			}
			else
			{
				f linkTo(e);
			}
		}
	}

	while (true)
	{
		self waittill("trigger");
		foreach (e as parts;;+c)
		{
			if (!e.isRotating)
				e moveTo(e.pos2, 1, 0.1, 0.1);
			else
				e.rotator rotateYaw(e.angles[2] + 90, level.door_rotate);
		}
		self playSound("DoorOpen");
		wait level.door_wait;
		foreach (e as parts;;+c)
		{
			if (!e.isRotating)
				e moveTo(e.pos, 1, 0.1, 0.1);
			else
				e.rotator rotateYaw(e.angles[2] - 90, level.door_rotate);
		}
		self playSound("DoorClose");
		wait 1;
	}
}

metroDamage()
{
	while (true)
	{
		self.trigger waittill("trigger", p);
		if (!self.stop)
		{
			p suicide(); // TODO: Check metro kill
		}
	}
}

// No idea how to do the math properly!
// Also place stops far from turns.
moveMetroPoint(next)
{
	&METRO_ACCTIME = 0.5; // It is the acc/dec time, under which the player won't be damaged

	if (self.tOrigin[0] == next.origin[0] || self.tOrigin[1] == next.origin[1])
	{
		if (self.tOrigin[0] == next.origin[0])
			time = abs(self.tOrigin[1] - next.origin[1]) / 1000;
		else // if (self.tOrigin[1] == next.origin[1])
			time = abs(self.tOrigin[0] - next.origin[0]) / 1000;

		if (time)
		{
			// TODO: Maybe set more time due to acc/dec!
			if (isDefined(next.script_timer))
			{
				if (self.stop)
				{
					self moveMetro(next.origin, time, 2, 2);
					wait METRO_ACCTIME;
					time -= METRO_ACCTIME;
					self.stop = false;
				}
				else
					self moveMetro(next.origin, time, 0, 2);

				wait time - METRO_ACCTIME;
				self.stop = true;
				wait METRO_ACCTIME + next.script_timer;
			}
			else
			{
				if (self.stop)
				{
					self moveMetro(next.origin, time, 2);
					wait METRO_ACCTIME;
					time -= METRO_ACCTIME;
					self.stop = false;
				}
				else
					self moveMetro(next.origin, time);

				wait time;
			}
		}
	}
	else
	{
		a = self.angles;
		p = next.origin - self.tOrigin;

		q = (p[0] > 0 && p[1] > 0) || (p[0] < 0 && p[1] < 0);
		r = next.script_turningdir == "right";
		rev = q == r;
		if (rev)
			o = (next.origin[0], self.tOrigin[1], self.tOrigin[2]);
		else
			o = (self.tOrigin[0], next.origin[1], self.tOrigin[2]);

		if (q)
		{
			x = p[0];
			y = -1 * p[1];
		}
		else
		{
			x = -1 * p[0];
			y = p[1];
		}

		if (r)
		{
			s = -1;
			x *= -1;
			y *= -1;
		}
		else
		{
			s = 1;
		}
		for (i = 2; i <= 90; i += 2)
		{
			if (rev)
				to = o + (x * level.sin[90 - i], y * level.sin[i], 0);
			else
				to = o + (x * level.sin[i], y * level.sin[90 - i], 0);

			rto = a + (0, i * s, 0);

			self moveMetro(to, 0.1);
			self rotateMetro(rto, 0.1);

			wait 0.1;
		}
	}
	self.tOrigin = next.origin; // moveTo won't arrive exactly where it should

	if (isDefined(next.target))
		self thread moveMetroPoint(getEnt(next.target, "targetname"));
}

moveMetro(origin, time, acc, dec)
{
	if (!isDefined(acc))
		acc = 0;

	if (!isDefined(dec))
		dec = 0;

	self moveTo(origin, time, acc, dec);
	self.clip moveTo(origin, time, acc, dec);
}

rotateMetro(angle, time)
{
	self rotateTo(angle, time);
	self.clip rotateTo(angle - (0, 90, 0), time);
}

respawn()
{
	wait 110; // 120
	delay = true;
	while (delay)
	{
		wait 10;
		delay = false;
		foreach (p as level.allActivePlayers;;level.allActiveCount)
		{
			if (distanceSquared(self.origin, p.origin) < 1048576) // 1024 squared
			{
				delay = true;
				break;
			}
		}
	}
}

waitBarrel()
{
	while (true)
	{
		self.damageTaken = 0;
		self damageBarrel();
		self respawn();
		self setModel(self.realModel);
		self.clip solid();
	}
}

damageBarrel()
{
	self endon("exploding");

	while (self.damageTaken < 150)
	{
		self waittill("damage", amount, attacker, dir, vec, type);
		if (type != "MOD_MELEE" && type != "MOD_IMPACT")
		{
			self.attacker = attacker;

			if (level.barrelExplodingThisFrame)
				wait randomFloat(1);

			if (!self.damageTaken)
				self thread burnBarrel();

			self.damageTaken += amount;
		}
	}
}

burnBarrel()
{
	playFX(level.effects["burn_start"], self.origin);

	for (i = 0; self.damageTaken < 150; i++)
	{
		playFX(level.effects["burn"], self.origin + (0, 0, 44));

		if (!(i % 20))
		{
			self.damageTaken += 10 + randomFloat(10);
		}
		wait 0.05;
	}

	self notify("exploding");

	self playSound("explo_metal_rand");

	playFX(level.effects["explode"], self.origin + (0, 0, 4));
	physicsExplosionSphere(self.origin + (0, 0, 4), 100, 80, 1);

	level.barrelExplodingThisFrame = true;

	self.clip notsolid();

	if (isDefined(self.attacker))
		self radiusDamage(self.origin + (0, 0, 30), 250, 250, 1, self.attacker);
	else
		self radiusDamage(self.origin + (0, 0, 30), 250, 250, 1);

	//if (randomInt(2))
		self setModel("com_barrel_piece");
	//else
		//self setModel("com_barrel_piece2");

	wait 0.05;
	level.barrelExplodingThisFrame = false;
}

waitBreach()
{
	while (true)
	{
		self waittill("trigger", player);
		self.bomb show();
		foreach (t as self.door.triggers;;+)
		{
			t.origin -= (0, 0, 256);
		}
		wait 1;
		self.door playSound("ui_mp_suitcasebomb_timer");
		wait 1;
		self.door playSound("ui_mp_suitcasebomb_timer");
		wait 1;

		self.bomb hide();
		self.door notSolid();
		self.door hide();
		playFX(level.effects["breachMetal"], self.door.origin, self.door.angles);
		playFX(level.effects["breachMetal"], self.door.origin, self.door.angles * -1);
		playFX(level.effects["breach"], self.door.origin);

		if (isDefined(player))
			self radiusDamage(self.bomb.origin, 128, 200, 50, player);
		else
			self radiusDamage(self.bomb.origin, 128, 200, 50);

		physicsExplosionSphere(self.door.origin, 160, 0, 2);
		self.door playSound("breach");
		self respawn();
		self.door show();
		self.door solid();
		foreach (t as self.door.triggers;;+)
		{
			t.origin += (0, 0, 256);
		}
	}
}

// TODO: Broken model
waitExt()
{
	self.maxhp = 20;
	self.hp = self.maxhp;
	self.middle = self.origin + (0, 0, 8);
	while (true)
	{
		self waittill("damage", dmg, player);
		self.hp -= dmg;
		if (self.hp <= 0)
		{
			// setModel(broken)
			playFX(level.effects["fireExt"], self.middle, self.script_angles); // angles for example: 0 1 0 = -90 degrees

			if (isDefined(player))
				self radiusDamage(self.middle, 64, 200, 50, player);
			else
				self radiusDamage(self.middle, 64, 200, 50);

			physicsExplosionSphere(self.middle, 96, 0, 1.5);
			self playSound("fireext");
			self playSound("stream");
			self respawn();
			// setModel(original)
			self.hp = self.maxhp;
		}
	}
}

waitBoard()
{
	self.maxhp = 200;
	self.hp = self.maxhp;
	while (true)
	{
		self waittill("damage", dmg);
		self.hp -= dmg;
		if (self.hp <= 0)
		{
			playFX(level.effects["boardCrash"], self.origin);
			self playSound("BoardCrash");
			self hide();
			self notSolid();
			self respawn();
			self show();
			self solid();
			self.hp = self.maxhp;
		}
	}
}