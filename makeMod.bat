del games_mp.log
del console_mp.log
del missingasset.csv
del mod.ff

xcopy animtrees ..\..\raw\animtrees /SY
xcopy ui_mp ..\..\raw\ui_mp /SY
xcopy ui ..\..\raw\ui /SY
xcopy mp ..\..\raw\mp /SY
xcopy maps ..\..\raw\maps /SY
xcopy english ..\..\raw\english /SY
xcopy soundaliases ..\..\raw\soundaliases /SY
xcopy shock ..\..\raw\shock /SY
xcopy weapons ..\..\raw\weapons /SY
xcopy xmodel ..\..\raw\xmodel /SY
xcopy ..\map_source\mp_apb_waterfront.map ..\map_source\prefabs\apb /SY
xcopy ..\map_source\mp_apb_social.map ..\map_source\prefabs\apb /SY
copy /Y mod.csv ..\..\zone_source
copy /Y -mod.csv ..\..\zone_source\english\assetlist
cd ..\..\bin
linker_pc.exe -language english -compress -cleanup mod
cd ..\mods\apb
copy ..\..\zone\english\mod.ff
::linker_pc.exe -language english -compress -cleanup mp_apb_waterfront
::cd ..\usermaps\mp_apb_waterfront
::copy ..\..\zone\english\mp_apb_waterfront.ff

makeGSC.bat