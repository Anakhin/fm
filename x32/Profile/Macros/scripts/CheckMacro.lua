Macro { description="Check macro in editor; prompt for Reload/Execute";
  area="Editor"; key="CtrlEnter"; filemask="*.lua";
  action=function()
    local EditorInfo = editor.GetInfo()
    local info = editor.GetSelection() 
                 or {StartLine=1,EndLine=EditorInfo.TotalLines}
    local str = {}
    for ii=info.StartLine,info.EndLine do
      local cur=editor.GetString(-1,ii)
      str[ii]=cur.StringText:sub(cur.SelStart~=0 and cur.SelStart or 1,
                                 cur.SelEnd~=0 and cur.SelEnd or -1)
    end
    local f,Err = loadstring(table.concat(str,"\n",info.StartLine,info.EndLine))
    if Err then
      far.Message(Err,"Error",nil,"lw")
    else
      if EditorInfo.BlockType~=far.Flags.BTYPE_NONE then far.MacroPost("Keys'Tab'") end
      local ans = far.Message("Syntax is Ok","Macro","Reload &All;&Execute;")
      if ans==2 then
        f()
      elseif ans==1 then
        if band(EditorInfo.CurState,far.Flags.ECSTATE_SAVED)==0 then editor.SaveFile(); end
        if Area.Editor then far.MacroLoadAll() end --если при сохранении не возникло вопросов
      end
    end
  end;
}
