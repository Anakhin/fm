local function LuaExplorer()

eval('@' .. win.GetEnv('FARPROFILE') .. '\\Macros\\lua_explorer.lua')

end

Macro {
  area="Common"; key="CtrlShiftI"; flags="DisableOutput"; description="Lua Explorer"; action = LuaExplorer;
}
