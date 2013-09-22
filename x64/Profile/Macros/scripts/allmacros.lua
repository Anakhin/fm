Macro {
  area="Editor"; key="CtrlAltF8"; flags=""; description="Go to position"; action = function()
    Keys("AltF8") 
  end;
}

Macro {
  area="Editor"; key="CtrlG"; flags=""; action = function()
    Keys("AltF8") 
  end;
}

NoMacro {
  area="Editor"; key="ShiftTab"; flags=""; description="Tabulate selection leftward"; action = function()
    Keys("AltU")
  end;

}

NoMacro {
  area="Editor"; key="Tab"; flags="EVSelection"; description="Tabulate selection rightward"; action = function()
    Keys("AltI")
  end;
}


Macro {
  area="Shell"; key="AltShiftF7"; flags=""; action = function()

    local folders = {"c:\\_other", mf.date("%Y"), mf.date("%Y.%m0.%d")}
    local full    = ""

    for i, path in ipairs(folders) do 
      
      if  full ~= "" then
        full = full .. "\\"
      end
      
      full = full .. path

      if not mf.fexist(full) then
        Keys("F7") 
        print(path) 
        Keys("Enter") 
      end

      if not Panel.SetPath(0, full) then
        return
      end

    end

  end;
}

Macro {
  area="Shell"; key="BS"; flags="EmptyCommandLine"; action = function()
    Keys("CtrlPgUp") 
  end;
}

Macro {
  area="Shell"; key="Ctrl/"; flags=""; action = function()

    while APanel.Folder and not APanel.Eof do
      Keys("Down") end

  end;
}

NoMacro {
  area="Shell"; key="Ctrl="; flags=""; action = function()
    Keys("F11 f Enter") 
  end;
}

Macro {
  area="Shell"; key="CtrlK"; flags=""; action = function()
    Keys("F9 c t") 
  end;
}

Macro {
  area="Shell"; key="CtrlShift"; flags=""; action = function()

    local dot = mf.rindex(PPanel.Current, ".", 0)
    if (PPanel.Current ~= "..")  and (APanel.Current ~= "..") and  (dot ~= -1) then 
      local newName = mf.substr(PPanel.Current, 0, dot) .. ".srt"
      Keys("F6")
      print(newName);
    end

  end;
}

Macro {
  area="Shell"; key="CtrlShiftF6"; flags=""; description="Temp rename"; action = function()
    if APanel.Current ~= ".." then
      Keys("ShiftF6 End ! Enter")
    end 
  end;
}

Macro {
  area="Shell"; key="CtrlShiftR"; flags=""; action = function()
    Keys("F11 d F4") 
  end;
}

Macro {
  area="Shell"; key="CtrlShiftX"; flags="NotEmptyCommandLine"; action = function()
    Keys("XLat") 
  end;
}

Macro {
  area="Shell"; key="CtrlShiftY"; flags=""; action = function()
    Keys("F11 o v") 
  end;
}


Macro {
  area="Shell"; key="Del"; flags="EmptyCommandLine"; action = function()
    Keys("F8") 
  end;
}

Macro {
  area="Shell Info QView Tree"; key="Esc"; flags="EmptyCommandLine"; action = function()
    Keys("CtrlO") 
  end;
}

Macro {
  area="Shell"; key="ShiftF7"; flags=""; action = function()

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
  area="Shell"; key="Space"; flags="EmptyCommandLine"; action = function()
    Keys("Ins") 
  end;
}


Macro {
  area="Viewer"; key="CtrlAltF8"; flags=""; description="Go to"; action = function()
    Keys("AltF8") 
  end;
}

Macro {
  area="Editor Shell"; key="ShiftF4"; flags=""; description="Shift-F4 current"; action = function()
    local name = nil
    if Area.Shell and not APanel.Folder then
      name = APanel.Current
    end
    if Area.Editor then
      name = Editor.FileName
    end
    Keys('ShiftF4')
    if name and Area.Dialog then
      Keys('ShiftHome'); print(name); Keys('Home ShiftEnd')
    end
  end
}

Macro {
  area="Editor"; key="CtrlShift8"; flags=""; description=""; action = function()
    Keys("AltShiftF9 AltO Enter") 
  end;
}
