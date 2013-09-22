Macro {
  area="Shell"; key="Ctrl="; flags=""; description="Activate the same folder in the passive panel as in the active panel"; action = function()
    if (panel.SetPanelDirectory(nil,0,panel.GetPanelDirectory(nil,1))) then
      --msgbox("1", APanel.Current, "")
      Panel.SetPos(1, APanel.Current)
    end
  end;
}

