Macro {
  area="Editor"; key="CtrlShiftD"; flags=""; action = function()
    local date = mf.date("%Y.%m0.%d")
    editor.InsertText(-1, date) 
  end;
}

Macro {
  area="Editor"; key="CtrlShiftT"; flags=""; action = function()
    local date = mf.date("%H:%M:%S")
    editor.InsertText(-1, date) 
  end;
}
