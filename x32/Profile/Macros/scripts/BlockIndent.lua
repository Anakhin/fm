-- Translated to Lua/LuaFAR by Shmuel Zeigerman, 2011-02-26.

--[[
    Block Indent plugin for FAR Manager
    Copyright (C) 2001 Alex Yaroslavsky

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
--]]
----------------------------------------------------------------------------

local F = far.Flags

local function Indent (IndentByTabSize, Forward)
  local ei = editor.GetInfo()

  local IndentStr = IndentByTabSize and '\t' or ' '
  local IndentSize = IndentByTabSize and ei.TabSize or 1

  local line = ei.CurLine
  local loop
  if ei.BlockType ~= F.BTYPE_NONE then
    local egs = editor.GetString()
    if egs.SelStart ~= 0 then
      loop = true
      line = ei.BlockStartLine
    end
  end

  editor.UndoRedo(nil, F.EUR_BEGIN)
  for CurLine = line, ei.TotalLines do
    editor.SetPosition(nil, CurLine, 1)
    local egs = editor.GetString()
    if loop and (egs.SelStart == 0 or (egs.SelEnd ~= -1 and egs.SelStart > egs.SelEnd)) then
      break
    end
    local j = egs.StringText:find("[^ \t]")
    if j and (j > 1 or Forward) then
      local DestPos = editor.RealToTab(nil, nil, j) - 1
      local x = math.floor(DestPos / IndentSize)
      if Forward then x = x + 1
      elseif DestPos % IndentSize == 0 then x = x - 1
      end
      editor.SetString(nil, nil, IndentStr:rep(x)..egs.StringText:sub(j), egs.StringEOL)
    end
    if not loop then break end
  end

  editor.SetPosition(nil, ei.CurLine, ei.CurPos, nil, ei.TopScreenLine,
                     ei.LeftPos, ei.Overtype)
  editor.UndoRedo(nil, F.EUR_END)
end

Macro {
  area="Editor"; key="Tab"; flags="EVSelection"; description="Indent right by tab size";
  action = function() Indent(true, true) end;
}

Macro {
  area="Editor"; key="ShiftTab"; flags="EVSelection"; description="Indent left by tab size";
  action = function() Indent(true, false) end;
}

Macro {
  area="Editor"; key="None"; flags="EVSelection"; description="Indent right by space";
  action = function() Indent(false, true) end;
}

Macro {
  area="Editor"; key="None"; flags="EVSelection"; description="Indent left by space";
  action = function() Indent(false, false) end;
}
