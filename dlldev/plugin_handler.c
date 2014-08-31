

typedef struct{
    void (*OnInit)();
    void (*OnExitLevel)();
    void (*OnFrame)();
    void (*OnSVInit)();
}pluginWrapper_t;

pluginWrapper_t pluginFunctions;

void Plugin_Init()
{
  void *lib_handle;

  lib_handle = dlopen("./cod4_plugins.so", RTLD_LAZY);
  if (!lib_handle){
      Com_DPrintf("Can not load cod4_plugins.so\n");
      return;
  }

  pluginFunctions.OnInit = dlsym(lib_handle, "OnInit");
  pluginFunctions.OnExitLevel = dlsym(lib_handle, "OnExitLevel");
  pluginFunctions.OnFrame = dlsym(lib_handle, "OnFrame");
  pluginFunctions.OnSVInit = dlsym(lib_handle, "OnSVInit");

  Com_Printf("Loaded plugins\n");

  if(pluginFunctions.OnInit) pluginFunctions.OnInit();
}
