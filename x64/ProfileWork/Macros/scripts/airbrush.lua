
local AirBrushPlugId = "9860393A-918D-450f-A3EA-84186F21B0A2"
local AirBrushMenuId = "2C20419A-CBA1-4A15-AB4C-AFF61510DA0C"
 
local function Cond()
  return
    Plugin.Exist(AirBrushPlugId)
end
 
local Diff="d" --commands
 
local function AirBrush(cmd)
    if Plugin.Menu(AirBrushPlugId, AirBrushMenuId) then
      Keys(cmd)
    end
end
 
Macro { description="AirBrush: enable diff mode";
    area="Editor"; key="CtrlI";
    condition=Cond; action=function() AirBrush(Diff) end;
}
