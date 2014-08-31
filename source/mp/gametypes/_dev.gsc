///////////////////////////////////////////////////////////
//            APB Mod - Morva 'iCore' Kristóf            //
//                moddb.com/members/icore                //
//    Using without permission is strictly forbidden!    //
//     Data stealing is rated as a criminal offence!     //
///////////////////////////////////////////////////////////

init()
{
	thread addTestClients();
}

addTestClients()
{
	wait 5;

	while (true)
	{
		if (getDvarInt("scr_testclients") > 0)
			break;

		wait 1;
	}

	testclients = getDvarInt("scr_testclients");
	setDvar("scr_testclients", 0);
	for(i = 0; i < testclients; i++)
	{
		ent[i] = addTestClient();

		if (!isDefined(ent[i]))
		{
			printLn("Could not add test client");
			wait 1;
			continue;
		}

		ent[i].isBot = true;
		ent[i] thread TestClient(i);
	}

	thread addTestClients();
}

TestClient(i)
{
	self endon("disconnect");

	while (!isDefined(self.team))
		wait 0.05;

	self.showname = "bot" + i;
	self setClientDvar("showname", self.showname);
	level.online[self.showname] = self;
	self.info["pass"] = "test";
	self.info["format"] = 3;
	self.info["date"] = 10;

	def = "Default:norise-1, , , , , , , ,2, , , , , , ,3, , , , , , , ,4, , , , , , , , |8bit- , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , |8bit- , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , |8bit- , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , |8bit- , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , |8bit- , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , |8bit- , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , |8bit- , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , ";
	self.themes = [];
	self.themeList = [];
	p = strTok(def, ":"); // Name:tracks
	self.themes[0] = spawnStruct();
	self.themes[0].name = p[0];
	self.themeList[p[0]] = 0;
	p = strTok(p[1], "|");
	for (j = 0; j < 8; j++)
	{
		self.themes[0].tracks[j] = spawnStruct();
		q = strTok(p[j], "-");
		self.themes[0].tracks[j].type = q[0];
		q = strTok(q[1], ",");
		self.themes[0].tracks[j].nodes = [];
		for (k = 0; k < 32; k++)
		{
			if (q[k] != " ")
			{
				self.themes[0].tracks[j].nodes[k] = int(q[k]);
			}
		}
	}

	self maps\mp\gametypes\apb::dress(false);
	wait 0.5;
	self.mix = "language";
	self notify("menuresponse", game["menu_mix"], "1");
	wait 0.5;
	self.mix = "faction";
	self notify("menuresponse", game["menu_mix"], (2 - (i % 2)) + "");
	wait 0.5;
	self notify("menuresponse", game["menu_dress"], "save");
	wait 0.5;
	self closeMenu();

	//a = spawn("script_origin", self.origin);
	//self linkTo(a);

	//self thread shootTester();

	//self maps\mp\gametypes\apb::giveStanding(randomInt(3679400));
	//self maps\mp\gametypes\apb::giveMoney(randomInt(100000));

	//self takeAllWeapons();

	while (true)
	{
		wait 0.5;
		self notify("menuresponse", "ingame", "backup");
		wait 0.5;
		self notify("menuresponse", game["menu_class"], "invite:1");
		wait 0.5;
		self notify("menuresponse", "ingame", "ready");
		//self maps\mp\gametypes\_menus::inviteGroup("icore", false);
		/*wait 0.5;
		self giveMaxAmmo(self.primaryWeapon);*/

		/*if (isDefined(self.missionTeam))
		{
			self.teammgrid = level.teams[self.missionTeam].size - 1;
			self notify("menuresponse", "teammgr", "kick");
			wait 0.05;
			self.teammgrid = 0;
			self notify("menuresponse", "teammgr", "kick");
		}*/
	}
}

shootTester()
{
	self endon("disconnect");
	while (isDefined(level.players[0]))
	{
		self setPlayerAngles(vectorToAngles(level.players[0].origin - self.origin));
		wait 0.05;
	}
}