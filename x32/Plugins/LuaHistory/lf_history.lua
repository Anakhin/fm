local LFHistory = "a745761d-42b5-4e67-83da-f07af367ae86"
local function LFH_exist() return Plugin.Exist(LFHistory) end
local function LFH_run(key) Plugin.Menu(LFHistory) Keys(key) end

Macro {
  description="LuaFAR History: commands";
  area="Shell"; key="AltF8";
  condition=LFH_exist; action=function() LFH_run"1" end;
}

Macro {
  description="LuaFAR History: view/edit";
  area="Shell Editor Viewer"; key="AltF11";
  condition=LFH_exist; action=function() LFH_run"2" end;
}

Macro {
  description="LuaFAR History: folders";
  area="Shell"; key="AltF12";
  condition=LFH_exist; action=function() LFH_run"3" end;
}
