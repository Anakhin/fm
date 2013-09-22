local MBlockEditor = "D82D6847-0C7B-4BF4-9A31-B0B929707854"

Macro {
  area="Editor"; key="Ctrl/"; flags="DisableOutput"; description="Comment selection (auto mode)"; action = function()
    -- Keys("F11 c 3") 
    if not Plugin.Call(MBlockEditor, 3) then Keys(AKey(2)) end
  end;
}

Macro {
  area="Editor"; key="CtrlShift/"; flags="DisableOutput"; description="Uncomment selection"; action = function()
    --Keys("F11 c 4") 
    if not Plugin.Call(MBlockEditor, 4) then Keys(AKey(2)) end
  end;
}
