






init()
{
precacheShader("damage_feedback");

level thread onPlayerConnect();
}

onPlayerConnect()
{
while(true)
{
level waittill("connecting",player);

player.hud_damagefeedback=newClientHudElem(player);
player.hud_damagefeedback.horzAlign="center";
player.hud_damagefeedback.vertAlign="middle";
player.hud_damagefeedback.x=-12;
player.hud_damagefeedback.y=-12;
player.hud_damagefeedback.alpha=0;
player.hud_damagefeedback.archived=true;
player.hud_damagefeedback setShader("damage_feedback",24,48);
}
}

updateDamageFeedback()
{
if(!isPlayer(self))
return;

self playLocalSound("MP_hit_alert");

self.hud_damagefeedback.alpha=1;
self.hud_damagefeedback fadeOverTime(1);
self.hud_damagefeedback.alpha=0;
}