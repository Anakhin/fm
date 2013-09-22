local ALT_HISTORY = "FF8FC1AE-0F35-4134-9BAB-56D71B1D47B9"

Macro {
  area="Dialog"; key="AltF11"; flags="DisableOutput"; description="Alternative file view history";
  action = function()
if not Plugin.Call(ALT_HISTORY, 2) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Dialog"; key="AltF12"; flags="DisableOutput"; description="Alternative folders history";
  action = function()
if not Plugin.Call(ALT_HISTORY, 3) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Dialog"; key="AltF8"; flags="DisableOutput"; description="Alternative commands history";
  action = function()
if not Plugin.Call(ALT_HISTORY, 1) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Dialog"; key="CtrlShiftX"; flags="DisableOutput"; description="Alternative history: xlat filter";
  action = function()
if Dlg.Id == "86ED68B6-7C55-4B2D-AEEB-E354B5F04CA9" then Plugin.Call(ALT_HISTORY, 255) else Keys('Xlat') end
  end;
}

Macro {
  area="Editor"; key="AltF11"; flags="DisableOutput"; description="Alternative file view history";
  action = function()
if not Plugin.Call(ALT_HISTORY, 2) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Editor"; key="AltF12"; flags="DisableOutput"; description="Alternative folders history";
  action = function()
if not Plugin.Call(ALT_HISTORY, 3) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Editor"; key="AltF3"; flags="DisableOutput";
  action = function()
 Keys("F11 e 8") 
  end;
}

Macro {
  area="Editor"; key="AltF8"; flags="DisableOutput"; description="Alternative commands history";
  action = function()
if not Plugin.Call(ALT_HISTORY, 1) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Editor"; key="Ctrl/"; flags="DisableOutput"; description="Comment selection (auto mode)";
  action = function()
Plugin.Call("D82D6847-0C7B-4BF4-9A31-B0B929707854",3)
  end;
}

Macro {
  area="Editor"; key="CtrlAltF11"; flags="DisableOutput"; description="Standard file view history";
  action = function()
Keys("AltF11")
  end;
}

Macro {
  area="Editor"; key="CtrlAltF8"; flags="DisableOutput"; description="Go to position";
  action = function()
 Keys("AltF8") 
  end;
}

Macro {
  area="Editor"; key="CtrlF7"; flags="DisableOutput";
  action = function()
 Keys("F11 e 3") 
  end;
}

Macro {
  area="Editor"; key="CtrlG"; flags="DisableOutput";
  action = function()
 Keys("AltF8") 
  end;
}

Macro {
  area="Editor"; key="CtrlI"; flags="DisableOutput";
  action = function()
 Keys("F11 b d") 
  end;
}

Macro {
  area="Editor"; key="CtrlShift/"; flags="DisableOutput"; description="Uncomment selection";
  action = function()
Plugin.Call("D82D6847-0C7B-4BF4-9A31-B0B929707854",4)
  end;
}

Macro {
  area="Editor"; key="F7"; flags="DisableOutput";
  action = function()
 Keys("F11 e 2") 
  end;
}

Macro {
  area="Editor"; key="ShiftF7"; flags="DisableOutput";
  action = function()
 Keys("F11 e 5") 
  end;
}

Macro {
  area="Editor"; key="ShiftTab"; flags="DisableOutput"; description="Tabulate selection leftward";
  action = function()
Plugin.Call("D82D6847-0C7B-4BF4-9A31-B0B929707854",2)
  end;
}

Macro {
  area="Editor"; key="Tab"; flags="DisableOutput|EVSelection"; description="Tabulate selection rightward";
  action = function()
Plugin.Call("D82D6847-0C7B-4BF4-9A31-B0B929707854",1)
  end;
}

Macro {
  area="Info"; key="AltF11"; flags="DisableOutput"; description="Alternative file view history";
  action = function()
if not Plugin.Call(ALT_HISTORY, 2) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Info"; key="AltF12"; flags="DisableOutput"; description="Alternative folders history";
  action = function()
if not Plugin.Call(ALT_HISTORY, 3) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Info"; key="AltF8"; flags="DisableOutput"; description="Alternative commands history";
  action = function()
if not Plugin.Call(ALT_HISTORY, 1) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Info"; key="CtrlAltF11"; flags="DisableOutput"; description="Standard file view history";
  action = function()
Keys("AltF11")
  end;
}

Macro {
  area="Info"; key="CtrlAltF12"; flags="DisableOutput"; description="Standard folders history";
  action = function()
Keys("AltF12")
  end;
}

Macro {
  area="Info"; key="CtrlAltF8"; flags="DisableOutput"; description="Go to or Standard commands history";
  action = function()
Keys("AltF8")
  end;
}

Macro {
  area="Info"; key="CtrlSpace"; flags="DisableOutput"; description="Alternative history: list of filtered commands";
  action = function()
if not Plugin.Call(ALT_HISTORY, 4) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Qview"; key="AltF11"; flags="DisableOutput"; description="Alternative file view history";
  action = function()
if not Plugin.Call(ALT_HISTORY, 2) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Qview"; key="AltF12"; flags="DisableOutput"; description="Alternative folders history";
  action = function()
if not Plugin.Call(ALT_HISTORY, 3) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Qview"; key="AltF8"; flags="DisableOutput"; description="Alternative commands history";
  action = function()
if not Plugin.Call(ALT_HISTORY, 1) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Qview"; key="CtrlAltF11"; flags="DisableOutput"; description="Standard file view history";
  action = function()
Keys("AltF11")
  end;
}

Macro {
  area="Qview"; key="CtrlAltF12"; flags="DisableOutput"; description="Standard folders history";
  action = function()
Keys("AltF12")
  end;
}

Macro {
  area="Qview"; key="CtrlAltF8"; flags="DisableOutput"; description="Go to or Standard commands history";
  action = function()
Keys("AltF8")
  end;
}

Macro {
  area="Qview"; key="CtrlSpace"; flags="DisableOutput"; description="Alternative history: list of filtered commands";
  action = function()
if not Plugin.Call(ALT_HISTORY, 4) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Shell"; key="AltF11"; flags="DisableOutput"; description="Alternative file view history";
  action = function()
if not Plugin.Call(ALT_HISTORY, 2) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Shell"; key="AltF12"; flags="DisableOutput"; description="Alternative folders history";
  action = function()
if not Plugin.Call(ALT_HISTORY, 3) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Shell"; key="AltF8"; flags="DisableOutput"; description="Alternative commands history";
  action = function()
if not Plugin.Call(ALT_HISTORY, 1) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Shell"; key="AltShiftF7"; flags="DisableOutput";
  action = function()

  local dt   = mf.date("%Y.%m0.%d")
  local begin = "c:\\_Other"
  local full = begin .. "\\" .. dt
  if mf.fexist(full) then
    Panel.SetPath(0, full)
  else 
    if mf.fexist(begin) and Panel.SetPath(0, begin) then  
      Keys("F7") 
      print(dt) 
      Keys("Enter Enter") 
    end 
  end

  end;
}

Macro {
  area="Shell"; key="BS"; flags="DisableOutput|EmptyCommandLine";
  action = function()
 Keys("CtrlPgUp") 
  end;
}

Macro {
  area="Shell"; key="Ctrl'"; flags="DisableOutput";
  action = function()
Keys("CtrlY e d i t : < g Space d i Space . Enter F11 a d")
  end;
}

Macro {
  area="Shell"; key="Ctrl/"; flags="DisableOutput";
  action = function()

  while APanel.Folder and not APanel.Eof do
    Keys("Down") end

  end;
}

Macro {
  area="Shell"; key="Ctrl="; flags="DisableOutput";
  action = function()
 Keys("F11 f Enter") 
  end;
}

Macro {
  area="Shell"; key="CtrlAltF11"; flags="DisableOutput"; description="Standard file view history";
  action = function()
Keys("AltF11")
  end;
}

Macro {
  area="Shell"; key="CtrlAltF12"; flags="DisableOutput"; description="Standard folders history";
  action = function()
Keys("AltF12")
  end;
}

Macro {
  area="Shell"; key="CtrlAltF8"; flags="DisableOutput"; description="Standard commands history";
  action = function()
Keys("AltF8")
  end;
}

Macro {
  area="Shell"; key="CtrlK"; flags="DisableOutput";
  action = function()
 Keys("F9 c t") 
  end;
}

Macro {
  area="Shell"; key="CtrlShift"; flags="DisableOutput";
  action = function()

local dot = mf.rindex(PPanel.Current, ".", 0)
if (PPanel.Current ~= "..")  and (APanel.Current ~= "..") and  (dot ~= -1) then 
  local newName = mf.substr(PPanel.Current, 0, dot) .. ".srt"
  Keys("F6")
  print(newName);
end

  end;
}

Macro {
  area="Shell"; key="CtrlShiftF6"; flags="DisableOutput";
  action = function()
 Keys("ShiftF6 End ! Enter") 
  end;
}

Macro {
  area="Shell"; key="CtrlShiftR"; flags="DisableOutput";
  action = function()
 Keys("F11 d F4") 
  end;
}

Macro {
  area="Shell"; key="CtrlShiftX"; flags="DisableOutput|NotEmptyCommandLine";
  action = function()
 Keys("XLat") 
  end;
}

Macro {
  area="Shell"; key="CtrlShiftY"; flags="DisableOutput";
  action = function()
 Keys("F11 o v") 
  end;
}

Macro {
  area="Shell"; key="CtrlSpace"; flags="DisableOutput"; description="Alternative history: list of filtered commands";
  action = function()
if not Plugin.Call(ALT_HISTORY, 4) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Shell"; key="Del"; flags="EmptyCommandLine";
  action = function()
 Keys("F8") 
  end;
}

Macro {
  area="Shell"; key="Esc"; flags="DisableOutput|EmptyCommandLine";
  action = function()
 Keys("CtrlO") 
  end;
}

Macro {
  area="Shell"; key="ShiftF7"; flags="DisableOutput";
  action = function()

  if not APanel.Plugin then
    local dt=mf.date("%Y.%m0.%d")
    if Panel.FExist(0, dt) ~= 0 then
      Panel.SetPos(0,dt)
    else 
      Keys("F7")
      print(dt)
      Keys("Enter")
    end 
  else 
    Keys("ShiftF7")
  end

  end;
}

Macro {
  area="Shell"; key="Space"; flags="DisableOutput|EmptyCommandLine";
  action = function()
 Keys("Ins") 
  end;
}

Macro {
  area="Tree"; key="AltF11"; flags="DisableOutput"; description="Alternative file view history";
  action = function()
if not Plugin.Call(ALT_HISTORY, 2) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Tree"; key="AltF12"; flags="DisableOutput"; description="Alternative folders history";
  action = function()
if not Plugin.Call(ALT_HISTORY, 3) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Tree"; key="AltF8"; flags="DisableOutput"; description="Alternative commands history";
  action = function()
if not Plugin.Call(ALT_HISTORY, 1) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Tree"; key="CtrlAltF11"; flags="DisableOutput"; description="Standard file view history";
  action = function()
Keys("AltF11")
  end;
}

Macro {
  area="Tree"; key="CtrlAltF12"; flags="DisableOutput"; description="Standard folders history";
  action = function()
Keys("AltF12")
  end;
}

Macro {
  area="Tree"; key="CtrlAltF8"; flags="DisableOutput"; description="Standard commands history";
  action = function()
Keys("AltF8")
  end;
}

Macro {
  area="Tree"; key="CtrlSpace"; flags="DisableOutput"; description="Alternative history: list of filtered commands";
  action = function()
if not Plugin.Call(ALT_HISTORY, 4) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Viewer"; key="AltF11"; flags="DisableOutput"; description="Alternative file view history";
  action = function()
if not Plugin.Call(ALT_HISTORY, 2) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Viewer"; key="AltF12"; flags="DisableOutput"; description="Alternative folders history";
  action = function()
if not Plugin.Call(ALT_HISTORY, 3) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Viewer"; key="AltF8"; flags="DisableOutput"; description="Alternative commands history";
  action = function()
if not Plugin.Call(ALT_HISTORY, 1) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Viewer"; key="CtrlAltF11"; flags="DisableOutput"; description="Standard file view history";
  action = function()
Keys("AltF11")
  end;
}

Macro {
  area="Viewer"; key="CtrlAltF8"; flags="DisableOutput"; description="Go to";
  action = function()
 Keys("AltF8") 
  end;
}

