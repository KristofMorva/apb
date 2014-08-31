///////////////////////////////////////////////////////////
//            APB Mod - Morva 'iCore' Kristóf            //
//                moddb.com/members/icore                //
//    Using without permission is strictly forbidden!    //
//     Data stealing is rated as a criminal offence!     //
///////////////////////////////////////////////////////////

// TODO: Cleanup this file!

init()
{
	preCacheShader("overlay_low_health");

	level.healthOverlayCutoff = 0.55; // Getting the dvar value directly doesn't work right because it's a client dvar getdvarfloat("hud_healthoverlay_pulseStart");

	regenTime = 5;

	level.playerHealth_RegularRegenDelay = regenTime * 1000;

	level.healthRegenDisabled = (level.playerHealth_RegularRegenDelay <= 0);

	level thread onPlayerConnect();
}

onPlayerConnect()
{
	while (true)
	{
		level waittill("connecting", player);
		player thread onPlayerSpawned();
		player thread onPlayerKilled();
		player thread onJoinedTeam();
		player thread onPlayerDisconnect();
	}
}

onJoinedTeam()
{
	self endon("disconnect");

	while (true)
	{
		self waittill("joined_team");
		self notify("end_healthregen");
	}
}

onPlayerSpawned()
{
	self endon("disconnect");

	while (true)
	{
		self waittill("spawned_player");
		self thread playerHealthRegen();
	}
}

onPlayerKilled()
{
	self endon("disconnect");

	while (true)
	{
		self waittill("killed_player");
		self notify("end_healthregen");
	}
}

onPlayerDisconnect()
{
	self waittill("disconnect");
	self notify("end_healthregen");
}

playerHealthRegen()
{
	self endon("end_healthregen");

	if (self.health <= 0)
	{
		assert(!isAlive(self));
		return;
	}

	maxhealth = self.health;
	oldhealth = maxhealth;
	player = self;
	health_add = 0;

	regenRate = 0.1; // 0.017;
	veryHurt = false;

	player.breathingStopTime = -10000;

	thread playerBreathingSound(maxhealth * 0.35);

	lastSoundTime_Recover = 0;
	hurtTime = 0;
	newHealth = 0;

	while (true)
	{
		wait 0.05;
		if (player.health == maxhealth)
		{
			veryHurt = false;
			self.atBrinkOfDeath = false;

			// APB
			player.attackers = undefined;

			continue;
		}

		if (player.health <= 0)
			return;

		wasVeryHurt = veryHurt;
		ratio = player.health / maxHealth;
		if (ratio <= level.healthOverlayCutoff)
		{
			veryHurt = true;
			self.atBrinkOfDeath = true;
			if (!wasVeryHurt)
			{
				hurtTime = getTime();
			}
		}

		if (player.health >= oldhealth)
		{
			if (getTime() - hurttime < level.playerHealth_RegularRegenDelay)
				continue;

			if (level.healthRegenDisabled)
				continue;

			if (getTime() - lastSoundTime_Recover > level.playerHealth_RegularRegenDelay)
			{
				lastSoundTime_Recover = getTime();
				self playLocalSound("breathing_better");
			}

			if (veryHurt)
			{
				newHealth = ratio;
				if (getTime() > hurtTime + 3000)
					newHealth += regenRate;
			}
			else
				newHealth = 1;

			if (newHealth >= 1)
			{
				newHealth = 1;
			}

			if (newHealth <= 0)
			{
				// Player is dead
				return;
			}

			// APB Begin
			if (player.stun && player.stun < 100)
				player.stun = min(100, player.stun + 5);

			newRegen = int(player.info["regenhealth"] + newHealth * 200 - player.health);

			if (player.info["regenhealth"] < 20000 && newRegen >= 20000)
				player maps\mp\gametypes\apb::giveAchievement("HEALTH");
			//else if (newRegen < 20000)
				//player setClientDvar("achievement_health_progress", newRegen + "/20000");

			player.info["regenhealth"] = newRegen;
			player setClientDvar("regenhealth", player.info["regenhealth"]);
			//player maps\mp\gametypes\apb::setSave("REGENHEALTH", player.info["regenhealth"]);
			//player maps\mp\gametypes\apb::saveStatus();
			// APB End

			player setNormalHealth(newHealth);
			oldhealth = player.health;
			continue;
		}

		oldhealth = player.health;

		health_add = 0;
		hurtTime = getTime();
		player.breathingStopTime = hurtTime + 6000;
	}
}

playerBreathingSound(healthcap)
{
	self endon("end_healthregen");

	wait 2;
	player = self;
	while (true)
	{
		wait 0.2;
		if (player.health <= 0)
			return;

		// Player still has a lot of health so no breathing sound
		if (player.health >= healthcap)
			continue;

		if (level.healthRegenDisabled && getTime() > player.breathingStopTime)
			continue;

		player playLocalSound("breathing_hurt");
		wait .784;
		wait 0.1 + randomFloat(0.8);
	}
}
