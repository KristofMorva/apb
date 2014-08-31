















CodeCallback_StartGameType()
{

if((!isDefined(level.gametypestarted)||!level.gametypestarted)&&isDefined(level.script))
{
[[level.callbackStartGameType]]();

level.gametypestarted=true;
}
}















CodeCallback_PlayerConnect()
{
self endon("disconnect");
[[level.callbackPlayerConnect]]();
}






CodeCallback_PlayerDisconnect()
{
self notify("disconnect",self.origin,self.angles);
[[level.callbackPlayerDisconnect]]();
}





CodeCallback_PlayerDamage(eInflictor,eAttacker,iDamage,iDFlags,sMeansOfDeath,sWeapon,vPoint,vDir,sHitLoc,timeOffset)
{
self endon("disconnect");
[[level.callbackPlayerDamage]](eInflictor,eAttacker,iDamage,iDFlags,sMeansOfDeath,sWeapon,vPoint,vDir,sHitLoc,timeOffset);
}





CodeCallback_PlayerKilled(eInflictor,eAttacker,iDamage,sMeansOfDeath,sWeapon,vDir,sHitLoc,timeOffset,deathAnimDuration)
{
self endon("disconnect");
[[level.callbackPlayerKilled]](eInflictor,eAttacker,iDamage,sMeansOfDeath,sWeapon,vDir,sHitLoc,timeOffset,deathAnimDuration);
}





CodeCallback_PlayerLastStand(eInflictor,eAttacker,iDamage,sMeansOfDeath,sWeapon,vDir,sHitLoc,timeOffset,deathAnimDuration)
{
}






SetupCallbacks()
{
SetDefaultCallbacks();


level.iDFLAGS_RADIUS=1;
level.iDFLAGS_NO_ARMOR=2;
level.iDFLAGS_NO_KNOCKBACK=4;
level.iDFLAGS_PENETRATION=8;
level.iDFLAGS_NO_TEAM_PROTECTION=16;
level.iDFLAGS_NO_PROTECTION=32;
level.iDFLAGS_PASSTHRU=64;
}





SetDefaultCallbacks()
{
level.callbackStartGameType=maps\mp\gametypes\apb::Callback_StartGameType;
level.callbackPlayerConnect=maps\mp\gametypes\apb::Callback_PlayerConnect;
level.callbackPlayerDisconnect=maps\mp\gametypes\apb::Callback_PlayerDisconnect;
level.callbackPlayerDamage=maps\mp\gametypes\apb::Callback_PlayerDamage;
level.callbackPlayerKilled=maps\mp\gametypes\apb::Callback_PlayerKilled;
}




AbortLevel()
{
printLn("Aborting level - gametype is not supported");

level.callbackStartGameType=::callbackVoid;
level.callbackPlayerConnect=::callbackVoid;
level.callbackPlayerDisconnect=::callbackVoid;
level.callbackPlayerDamage=::callbackVoid;
level.callbackPlayerKilled=::callbackVoid;
level.callbackPlayerLastStand=::callbackVoid;

setDvar("g_gametype","apb");

exitLevel(false);
}



callbackVoid()
{
}





CodeCallback_PlayerSayAll(msg)
{
self[[level.callbackPlayerSay]](msg);
}