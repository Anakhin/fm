local selected_cycle = false -- ����������� �������
local function selected_jump( dir )
   for index=APanel.CurPos+dir,(dir>0 and APanel.ItemCount or 1),dir do
      if Panel.Item(0,index,8) then Panel.SetPosIdx(0,index) return end
   end
   if selected_cycle then -- �����������
      Panel.SetPosIdx(0,(dir>0 and 1 or APanel.SelCount),1)
   end
end

Macro { -- ����������� � ����������� ����������
   description="Selected: Goto previous";
   area="Shell Search"; key="AltUp"; flags="Selection";
   action=function() selected_jump(-1) end;
}
Macro { -- ����������� � ���������� ����������
   description="Selected: Goto next";
   area="Shell Search"; key="AltDown"; flags="Selection";
   action=function() selected_jump(1) end;
}
Macro { -- ����������� � ������� ����������
   description="Selected: Goto first";
   area="Shell Search"; key="AltHome"; flags="Selection";
   action=function() Panel.SetPosIdx(0,1,1) end;
}
Macro { -- ����������� � ���������� ����������
   description="Selected: Goto last";
   area="Shell Search"; key="AltEnd"; flags="Selection";
   action=function() Panel.SetPosIdx(0,APanel.SelCount,1) end;
}