local CLIP_COPY_ID = "FA871763-7379-4CB4-BDB0-E4EF6FB0B524"
 
local function Cond()
  local REALNAMES = 0x20
  return
    Plugin.Exist(CLIP_COPY_ID)
    and (not APanel.Plugin or band(APanel.OPIFlags,REALNAMES))
end
 
local Copy,Cut,Paste,Shortcut="1","2","3","4" --commands
 
local function ClipCopy(cmd)
    if Plugin.Menu(CLIP_COPY_ID) then
        Keys(cmd)
    end
end
 
local Panels = "Shell Tree Search"
 
Macro { description="ClipCopy: Copy";
    area=Panels; key="CtrlShiftC";
    condition=Cond; action=function() ClipCopy(Copy) end;
}
 
Macro { description="ClipCopy: Cut";
    area=Panels; key="CtrlShiftX";
    condition=Cond; action=function() ClipCopy(Cut) end;
}
 
Macro { description="ClipCopy: Paste";
    area=Panels; key="CtrlShiftV";
    condition=Cond; action=function() ClipCopy(Paste) end;
}
 
Macro { description="ClipCopy: Shortcut";
    area=Panels; key="CtrlShiftL";
    condition=Cond; action=function() ClipCopy(Shortcut) end;
}
