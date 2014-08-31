///////////////////////////////////////////////////////////
//            APB Mod - Morva 'iCore' Kristóf            //
//                   2012 - modbase.hu                   //
//    Using without permission is strictly forbidden!    //
// Information stealing is rated as a criminal offence!! //
///////////////////////////////////////////////////////////

init()
{
	level.maxRank = int(tableLookup("mp/ratingTable.csv", 0, "maxrank", 1));
	level.maxRating = int(tableLookup("mp/ratingTable.csv", 0, "maxrating", 1));
	for (i = 0; i <= level.maxRating; i++)
	{
		level.ranks[i]["min"] = int(tableLookup("mp/ratingTable.csv", 0, i, 1));
		level.ranks[i]["points"] = int(tableLookup("mp/ratingTable.csv", 0, i, 2));
		level.ranks[i]["id"] = tableLookup("mp/ratingTable.csv", 0, i, 3);
		level.ranks[i]["max"] = int(tableLookup("mp/ratingTable.csv", 0, i, 4));
	}
	for (i = 1; i <= level.maxRank; i++)
	{
		preCacheShader("rank" + i + "_allies_silver");
		preCacheShader("rank" + i + "_axis_silver");
		//preCacheShader("rank" + i + "_allies_bronze");
		//preCacheShader("rank" + i + "_axis_bronze");
		//preCacheShader("rank" + i + "_allies_gold");
		//preCacheShader("rank" + i + "_axis_gold");
	}

	level thread onPlayerConnect();
}

onPlayerConnect()
{
	while (true)
	{
		level waittill("connected", player);
		player thread onPlayerSpawned();
	}
}

padRating(r)
{
	r++;

	if (r < 10)
		r = "00" + r;
	else if (r < 100)
		r = "0" + r;

	return r;
}

giveStanding(amount)
{
	if (!amount || self.rating == level.maxRating)
		return 0;

	amount = int(amount * level.prestige[self.prestige]);

	if (self.premium)
		add = int(amount / 2);
	else
		add = 0;

	// Overall standing
	new = self.info["standing"] + amount + add;
	if (new > level.ranks[level.maxRating]["max"])
		self.info["standing"] = level.ranks[level.maxRating]["max"];
	else
		self.info["standing"] = new;

	//self maps\mp\gametypes\apb::setSave("STANDING", self.info["standing"]);
	rating = self getRating();

	if (rating > self.rating)
	{
		backup = level.ranks[self.rating]["id"];
		plus = self.rating + 1;

		// They can jump more ratings too
		new = [];
		for (i = plus; i <= rating; i++)
		{
			w = tableLookup("mp/weaponTable.csv", 12, i, 2);
			if (w != "")
			{
				new[new.size] = w;
			}
		}
		if (new.size)
		{
			info = spawnStruct();
			info.title = level.s["NEWWEAPON_TITLE_" + self.lang];
			info.line = level.s["NEWWEAPON_DESC_" + self.lang] + "\n" + implode(new);
			info.icon = "newweapon";
			info.sound = "RewardReceivedWeapon";
			self thread maps\mp\gametypes\apb::gameMessage(info);
		}
		/*new = [];
		for (i = plus; i <= rating; i++)
		{
			w = tableLookup("mp/camoTable.csv", 3, i, 1);
			if (w != "")
			{
				new[new.size] = w;
			}
		}
		if (new.size)
		{
			info = spawnStruct();
			info.title = level.s["NEWCAMO_TITLE_" + self.lang];
			info.line = level.s["NEWCAMO_DESC_" + self.lang] + "\n" + implode(new);
			info.icon = "newcamo";
			info.sound = "RewardReceivedCamo";
			self thread maps\mp\gametypes\apb::gameMessage(info);
		}*/
		// It can be an enumeration too, if: mod titles are defined in level.s
		for (i = plus; i <= rating; i++)
		{
			w = int(tableLookup("mp/modTable.csv", 5, i, 0));
			if (w)
			{
				info = spawnStruct();
				info.title = level.s["NEWMOD_TITLE_" + self.lang];
				info.line = level.s["NEWMOD_DESC_" + self.lang];
				info.icon = "newmod";
				info.sound = "RewardReceivedMod";
				self thread maps\mp\gametypes\apb::gameMessage(info);
				break;
			}
		}
		// It can be an enumeration too, if: symbols get names
		for (i = plus; i <= rating; i++)
		{
			w = int(tableLookup("mp/symbolTable.csv", 1, i, 0));
			if (w)
			{
				info = spawnStruct();
				info.title = level.s["NEWSYMBOL_TITLE_" + self.lang];
				info.line = level.s["NEWSYMBOL_DESC_" + self.lang];
				info.icon = "newsymbol";
				info.sound = "RewardReceivedArt";
				self thread maps\mp\gametypes\apb::gameMessage(info);
				break;
			}
		}

		self.rating = rating;
		self setClientDvars(
			"rating", self.rating,
			"rating_pad", padRating(self.rating)
		);

		info = spawnStruct();
		info.title = level.s["RATINGUP_TITLE_" + self.lang];
		info.line = level.s["RATINGUP_" + self.lang] + ": ^3" + (self.rating + 1);
		info.icon = "rating";
		self thread maps\mp\gametypes\apb::gameMessage(info);

		if (level.ranks[self.rating]["id"] != backup)
		{
			rank = level.ranks[self.rating]["id"] + "_" + self.team;

			info = spawnStruct();
			info.title = level.s["RANKUP_TITLE_" + self.lang];
			info.line = level.s["RANK" + level.ranks[self.rating]["id"] + "_" + level.upper[self.team] + "_" + self.lang];
			info.icon = "rank" + rank + "_silver"; // + self.threat
			self thread maps\mp\gametypes\apb::gameMessage(info);
			self setClientDvars(
				"rankicon", rank,
				"threat", self.threat
			);
			if (isDefined(self.missionTeam))
			{
				//rank = rank + "_" + self.threat;
				foreach (t as level.teams[self.missionTeam];;+)
				{
					t.playerStats[self.clientid].rank = rank;
				}
				foreach (t as level.teams[self.enemyTeam];;+)
				{
					t.playerStats[self.clientid].rank = rank;
				}
			}
		}
		if (isDefined(self.missionTeam))
		{
			foreach (e as level.teams[self.missionTeam];;+)
			{
				e.playerStats[self.clientid].rating = rating;
			}
			foreach (e as level.teams[self.enemyTeam];;+)
			{
				e.playerStats[self.clientid].rating = rating;
			}
		}
	}
	// Last rank
	if (!level.ranks[self.rating]["points"])
		self setClientDvar("ratio", 1);
	else
		self setClientDvar("ratio", (self.info["standing"] - level.ranks[self.rating]["min"]) / level.ranks[self.rating]["points"]);

	if (isDefined(self.missionTeam))
	{
		self.stat["standing"] += amount;

		if (self.premium)
			self.stat["pstanding"] += add;

		self maps\mp\gametypes\apb::refreshStat("standing", "pstanding");
	}

	return amount + "^3 + " + add + "^7";
}

onPlayerSpawned()
{
	self endon("disconnect");

	self waittill("spawned_player");

	self.rating = self getRating();

	self setClientDvars(
		"rating", self.rating,
		"rating_pad", padRating(self.rating),
		"rankicon", level.ranks[self.rating]["id"] + "_" + self.team, //  + "_" + self.threat
		"threat", self.threat
	);
	if (level.ranks[self.rating]["points"])
		self setClientDvar("ratio", (self.info["standing"] - level.ranks[self.rating]["min"]) / level.ranks[self.rating]["points"]);
	else
		self setClientDvar("ratio", 0);

	if (!isDefined(self.killfeed))
	{
		self.killfeed = newClientHudElem(self);
		self.killfeed.horzAlign = "center";
		self.killfeed.vertAlign = "middle";
		self.killfeed.alignX = "center";
		self.killfeed.alignY = "middle";
		self.killfeed.x = 0;
		self.killfeed.y = 100;
		self.killfeed.font = "default";
		self.killfeed.fontscale = 2;
		self.killfeed.archived = false;
		self.killfeed.color = (1, 1, 1);
	}
}

getRating()
{
	if (self.info["standing"] == level.ranks[level.maxRating]["max"])
		return level.maxRating;

	for (i = 0; i <= level.maxRating; i++)
	{
		if (self.info["standing"] < level.ranks[i]["max"])
			return i;
	}
}

// Implode an array
implode(array)
{
	c = array.size;
	if (!c)
		return "";

	if (c == 1)
		return array[0];

	s = array[0];
	for (i = 1; i < c; i++)
	{
		s += ", " + array[i];
	}
	return s;
}