execNow "statGetInDvar 3153 ui_stat_lang";
execNowOnDvarIntValue ui_stat_lang 0 "set lang EN";
execNowOnDvarIntValue ui_stat_lang 1 "set lang HU";
execNowOnDvarIntValue ui_stat_lang 2 "set lang PL";
execNowOnDvarIntValue ui_stat_lang 3 "set lang TR";
execNowOnDvarIntValue ui_stat_lang 4 "set lang RS";
execNowOnDvarIntValue ui_stat_lang 5 "set lang CR";
execNowOnDvarIntValue ui_stat_lang 6 "set lang DE";
execNowOnDvarIntValue ui_stat_lang 7 "set lang CZ";
execNowOnDvarIntValue ui_stat_lang 8 "set lang SK";

/*#define loc ("_" + localVarString("lang" + stat(3153)))
setLocalVarString lang0 "EN";
setLocalVarString lang1 "HU";
setLocalVarString lang2 "PL";
setLocalVarString lang3 "TR";
setLocalVarString lang4 "RS";
setLocalVarString lang5 "CR";
setLocalVarString lang6 "DE";
setLocalVarString lang7 "CZ";
setLocalVarString lang8 "SK";*/