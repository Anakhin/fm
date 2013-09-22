local ALT_HISTORY = "FF8FC1AE-0F35-4134-9BAB-56D71B1D47B9"

Macro {
  area="Dialog"; key="AltF11"; flags="DisableOutput"; description="Alternative file view history"; action = function()
if not Plugin.Call(ALT_HISTORY, 2) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Dialog"; key="AltF12"; flags="DisableOutput"; description="Alternative folders history"; action = function()
if not Plugin.Call(ALT_HISTORY, 3) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Dialog"; key="AltF8"; flags="DisableOutput"; description="Alternative commands history"; action = function()
if not Plugin.Call(ALT_HISTORY, 1) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Dialog"; key="CtrlShiftX"; flags="DisableOutput"; description="Alternative history: xlat filter"; action = function()
if Dlg.Id == "86ED68B6-7C55-4B2D-AEEB-E354B5F04CA9" then Plugin.Call(ALT_HISTORY, 255) else Keys('Xlat') end
  end;
}

Macro {
  area="Editor"; key="AltF11"; flags="DisableOutput"; description="Alternative file view history"; action = function()
if not Plugin.Call(ALT_HISTORY, 2) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Editor"; key="AltF12"; flags="DisableOutput"; description="Alternative folders history"; action = function()
if not Plugin.Call(ALT_HISTORY, 3) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Editor"; key="CtrlAltF11"; flags="DisableOutput"; description="Standard file view history"; action = function()
Keys("AltF11")
  end;
}

Macro {
  area="Info"; key="AltF11"; flags="DisableOutput"; description="Alternative file view history"; action = function()
if not Plugin.Call(ALT_HISTORY, 2) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Info"; key="AltF12"; flags="DisableOutput"; description="Alternative folders history"; action = function()
if not Plugin.Call(ALT_HISTORY, 3) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Info"; key="AltF8"; flags="DisableOutput"; description="Alternative commands history"; action = function()
if not Plugin.Call(ALT_HISTORY, 1) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Info"; key="CtrlAltF11"; flags="DisableOutput"; description="Standard file view history"; action = function()
Keys("AltF11")
  end;
}

Macro {
  area="Info"; key="CtrlAltF12"; flags="DisableOutput"; description="Standard folders history"; action = function()
Keys("AltF12")
  end;
}

Macro {
  area="Info"; key="CtrlAltF8"; flags="DisableOutput"; description="Go to or Standard commands history"; action = function()
Keys("AltF8")
  end;
}

Macro {
  area="Info"; key="CtrlSpace"; flags="DisableOutput"; description="Alternative history: list of filtered commands"; action = function()
if not Plugin.Call(ALT_HISTORY, 4) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Qview"; key="AltF11"; flags="DisableOutput"; description="Alternative file view history"; action = function()
if not Plugin.Call(ALT_HISTORY, 2) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Qview"; key="AltF12"; flags="DisableOutput"; description="Alternative folders history"; action = function()
if not Plugin.Call(ALT_HISTORY, 3) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Qview"; key="AltF8"; flags="DisableOutput"; description="Alternative commands history"; action = function()
if not Plugin.Call(ALT_HISTORY, 1) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Qview"; key="CtrlAltF11"; flags="DisableOutput"; description="Standard file view history"; action = function()
Keys("AltF11")
  end;
}

Macro {
  area="Qview"; key="CtrlAltF12"; flags="DisableOutput"; description="Standard folders history"; action = function()
Keys("AltF12")
  end;
}

Macro {
  area="Qview"; key="CtrlAltF8"; flags="DisableOutput"; description="Go to or Standard commands history"; action = function()
Keys("AltF8")
  end;
}

Macro {
  area="Qview"; key="CtrlSpace"; flags="DisableOutput"; description="Alternative history: list of filtered commands"; action = function()
if not Plugin.Call(ALT_HISTORY, 4) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Shell"; key="AltF11"; flags="DisableOutput"; description="Alternative file view history"; action = function()
if not Plugin.Call(ALT_HISTORY, 2) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Shell"; key="AltF12"; flags="DisableOutput"; description="Alternative folders history"; action = function()
if not Plugin.Call(ALT_HISTORY, 3) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Shell"; key="AltF8"; flags="DisableOutput"; description="Alternative commands history"; action = function()
if not Plugin.Call(ALT_HISTORY, 1) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Shell"; key="CtrlAltF11"; flags="DisableOutput"; description="Standard file view history"; action = function()
Keys("AltF11")
  end;
}

Macro {
  area="Shell"; key="CtrlAltF12"; flags="DisableOutput"; description="Standard folders history"; action = function()
Keys("AltF12")
  end;
}

Macro {
  area="Shell"; key="CtrlAltF8"; flags="DisableOutput"; description="Standard commands history"; action = function()
Keys("AltF8")
  end;
}

Macro {
  area="Shell"; key="CtrlSpace"; flags="DisableOutput"; description="Alternative history: list of filtered commands"; action = function()
if not Plugin.Call(ALT_HISTORY, 4) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Tree"; key="AltF11"; flags="DisableOutput"; description="Alternative file view history"; action = function()
if not Plugin.Call(ALT_HISTORY, 2) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Tree"; key="AltF12"; flags="DisableOutput"; description="Alternative folders history"; action = function()
if not Plugin.Call(ALT_HISTORY, 3) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Tree"; key="AltF8"; flags="DisableOutput"; description="Alternative commands history"; action = function()
if not Plugin.Call(ALT_HISTORY, 1) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Tree"; key="CtrlAltF11"; flags="DisableOutput"; description="Standard file view history"; action = function()
Keys("AltF11")
  end;
}

Macro {
  area="Tree"; key="CtrlAltF12"; flags="DisableOutput"; description="Standard folders history"; action = function()
Keys("AltF12")
  end;
}

Macro {
  area="Tree"; key="CtrlAltF8"; flags="DisableOutput"; description="Standard commands history"; action = function()
Keys("AltF8")
  end;
}

Macro {
  area="Tree"; key="CtrlSpace"; flags="DisableOutput"; description="Alternative history: list of filtered commands"; action = function()
if not Plugin.Call(ALT_HISTORY, 4) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Viewer"; key="AltF11"; flags="DisableOutput"; description="Alternative file view history"; action = function()
if not Plugin.Call(ALT_HISTORY, 2) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Viewer"; key="AltF12"; flags="DisableOutput"; description="Alternative folders history"; action = function()
if not Plugin.Call(ALT_HISTORY, 3) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Viewer"; key="AltF8"; flags="DisableOutput"; description="Alternative commands history"; action = function()
if not Plugin.Call(ALT_HISTORY, 1) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Viewer"; key="CtrlAltF11"; flags="DisableOutput"; description="Standard file view history"; action = function()
Keys("AltF11")
  end;
}

Macro {
  area="Editor"; key="AltF8"; flags="DisableOutput"; description="Alternative commands history"; action = function()
    if not Plugin.Call(ALT_HISTORY, 1) then Keys(AKey(2)) end
  end;
}
