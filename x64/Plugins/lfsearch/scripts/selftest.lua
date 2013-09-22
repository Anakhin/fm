-- coding: utf-8
-- started: 2009-12-04 by Shmuel Zeigerman

local F = far.Flags
local SavedData
local abc_utf8 = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюя"

local function OpenHelperEditor()
  local ret = editor.Editor ("__tmp__.tmp", nil, nil,nil,nil,nil,
              {EF_NONMODAL=1, EF_IMMEDIATERETURN=1, EF_CREATENEW=1})
  assert (ret == F.EEC_MODIFIED, "could not open file")
end

local function CloseHelperEditor()
  editor.Quit()
  far.AdvControl("ACTL_COMMIT")
end

local function ProtectedError(msg, level)
  _Plugin.History:setfield("main", SavedData) -- restore the history
  CloseHelperEditor()
  error(msg, level)
end

local function ProtectedAssert(condition, msg)
  if not condition then ProtectedError(msg or "assertion failed") end
end

local function GetEditorText()
  local t = {}
  editor.SetPosition(nil, 1, 1)
  for i=1, editor.GetInfo().TotalLines do
    t[i] = editor.GetString(nil, i, 2)
  end
  return table.concat(t, "\r")
end

local function SetEditorText(str)
  editor.SetPosition(nil,1,1)
  for i=1, editor.GetInfo().TotalLines do
    editor.DeleteString()
  end
  editor.InsertText(nil, str)
end

local function AssertEditorText(ref, msg)
  ProtectedAssert(GetEditorText() == ref, msg)
end

local function RunOneTest (lib, op, data, refFound, refReps)
  data.sRegexLib = lib
  editor.SetPosition(nil, data.CurLine or 1, data.CurPos or 1)
  local nFound, nReps = EditorAction(op, data)
  if nFound ~= refFound or nReps ~= refReps then
    ProtectedError(
      "nFound="        .. nFound..
      "; refFound="    .. refFound..
      "; nReps="       .. nReps..
      "; refReps="     .. refReps..
      "; sRegexLib="   .. tostring(data.sRegexLib)..
      "; bCaseSens="   .. tostring(data.bCaseSens)..
      "; bRegExpr="    .. tostring(data.bRegExpr)..
      "; bWholeWords=" .. tostring(data.bWholeWords)..
      "; bExtended="   .. tostring(data.bExtended)..
      "; bSearchBack=" .. tostring(data.bSearchBack)..
      "; sScope="      .. tostring(data.sScope)..
      "; sOrigin="     .. tostring(data.sOrigin)
    )
  end
end

local function test_Switches (lib)
  SetEditorText("line1\rline2\rline3\rline4\r")
  local dt = { CurLine=2, CurPos=2 }
  local lua0, lua1
  if lib == "lua" then lua0, lua1 = 0, 1 else lua0, lua1 = 1, 0 end

  for k1=lua1,1 do dt.bCaseSens   = (k1==1)
  for k2=0,1    do dt.bRegExpr    = (k2==1)
  for k3=0,lua0 do dt.bWholeWords = (k3==1)
  for k4=0,lua0 do dt.bExtended   = (k4==1)
  for k5=0,1    do dt.bSearchBack = (k5==1)
  for k6=0,1    do dt.sOrigin     = (k6==1 and "scope" or nil)
    local bEnable
    ---------------------------------
    dt.sSearchPat = "a"
    RunOneTest(lib, "test:search", dt, 0, 0)
    RunOneTest(lib, "test:count",  dt, 0, 0)
    ---------------------------------
    dt.sSearchPat = "line"
    bEnable = dt.bRegExpr or not dt.bWholeWords
    RunOneTest(lib, "test:search", dt, bEnable and 1 or 0, 0)
    RunOneTest(lib, "test:count",  dt, bEnable and (dt.sOrigin=="scope" and 4 or
               dt.bSearchBack and 1 or 2) or 0, 0)
    ---------------------------------
    dt.sSearchPat = "LiNe"
    bEnable = (dt.bRegExpr or not dt.bWholeWords) and not dt.bCaseSens
    RunOneTest(lib, "test:search", dt, bEnable and 1 or 0, 0)
    RunOneTest(lib, "test:count",  dt, bEnable and (dt.sOrigin=="scope" and 4 or
               dt.bSearchBack and 1 or 2) or 0, 0)
    ---------------------------------
    dt.sSearchPat = "."
    bEnable = dt.bRegExpr
    RunOneTest(lib, "test:search", dt, bEnable and 1 or 0, 0)
    RunOneTest(lib, "test:count", dt, bEnable and (dt.sOrigin=="scope" and 20 or
      dt.bSearchBack and 6 or 14) or 0, 0)
    ---------------------------------
    dt.sSearchPat = " . "
    bEnable = dt.bRegExpr and dt.bExtended
    RunOneTest(lib, "test:search", dt, bEnable and 1 or 0, 0)
    RunOneTest(lib, "test:count", dt, bEnable and (dt.sOrigin=="scope" and 20 or
      dt.bSearchBack and 6 or 14) or 0, 0)
    ---------------------------------
  end end end end end end
end

local function test_LineFilter (lib)
  SetEditorText("line1\rline2\rline3\r")
  local dt = { sSearchPat="line" }

  RunOneTest(lib, "test:search", dt, 1, 0)
  RunOneTest(lib, "test:count",  dt, 3, 0)

  dt.bAdvanced = true
  dt.sFilterFunc = "  "
  RunOneTest(lib, "test:search", dt, 1, 0)
  RunOneTest(lib, "test:count",  dt, 3, 0)

  dt.sFilterFunc = "return"
  RunOneTest(lib, "test:search", dt, 1, 0)
  RunOneTest(lib, "test:count",  dt, 3, 0)

  dt.sFilterFunc = " return true "
  RunOneTest(lib, "test:search", dt, 0, 0)
  RunOneTest(lib, "test:count",  dt, 0, 0)

  dt.sFilterFunc = "return n == 2"
  RunOneTest(lib, "test:search", dt, 1, 0)
  RunOneTest(lib, "test:count",  dt, 2, 0)

  dt.sFilterFunc = "return not rex.find(s, '[13]')"
  RunOneTest(lib, "test:search", dt, 1, 0)
  RunOneTest(lib, "test:count",  dt, 2, 0)

  dt.sInitFunc = "Var1,Var2 = 'line2','line3'"
  dt.sFilterFunc = "return not(s==Var1 or s==Var2)"
  dt.sFinalFunc = "assert(Var1=='line2')"
  RunOneTest(lib, "test:search", dt, 1, 0)
  RunOneTest(lib, "test:count",  dt, 2, 0)

  dt.sInitFunc = nil
  dt.sFinalFunc = "assert(Var1==nil)"
  RunOneTest(lib, "test:search", dt, 0, 0)
  RunOneTest(lib, "test:count",  dt, 0, 0)
end

local function test_Replace (lib)
  for k=0,1 do
  -- test "user choice function"
    SetEditorText("line1\rline2\rline3\r")
    local dt = { sSearchPat=".", sReplacePat="$0", bRegExpr=true,
      bConfirmReplace=true, bSearchBack = (k==1), sOrigin = "scope" }
    for i,ch in ipairs {"yes","all","no","cancel"} do
      local cnt = 0
      dt.fUserChoiceFunc = function() cnt=cnt+1; return ch end
      RunOneTest(lib, "test:replace", dt,
        ch=="cancel" and 1 or 15, (ch=="yes" or ch=="all") and 15 or 0)
      ProtectedAssert(
        (ch=="yes" or ch=="no") and cnt==15 or
        (ch=="all" or ch=="cancel") and cnt==1)
    end

    -- test empty replace
    dt = { sSearchPat="l", sReplacePat="", bSearchBack = (k==1),
      sOrigin = "scope" }
    SetEditorText("line1\rline2\rline3\r")
    RunOneTest(lib, "test:replace", dt, 3, 3)
    AssertEditorText("ine1\rine2\rine3\r")

    -- test empty replace with cyrillic characters
    if not (lib=="pcre" and k==1) then
      dt = { sSearchPat="с", sReplacePat="", bSearchBack = (k==1),
        sOrigin = "scope" }
      SetEditorText("строка1\rстрока2\rстрока3\r")
      RunOneTest(lib, "test:replace", dt, 3, 3)
      AssertEditorText("трока1\rтрока2\rтрока3\r")
    end

    -- test replace of empty match
    if not (lib=="pcre" and k==1) then
      dt = { sSearchPat=(lib=="lua" and ".-" or ".*?"), sReplacePat="-", bSearchBack = (k==1),
        sOrigin = "scope", bRegExpr=true }
      SetEditorText("строка1\rстрока2\r")
      RunOneTest(lib, "test:replace", dt, 17, 17)
      AssertEditorText("-с-т-р-о-к-а-1-\r-с-т-р-о-к-а-2-\r-")
    end

    -- test non-empty replace
    dt = { sSearchPat="l", sReplacePat="LL", bSearchBack = (k==1),
      sOrigin = "scope" }
    SetEditorText("line1\rline2\rline3\r")
    RunOneTest(lib, "test:replace", dt, 3, 3)
    AssertEditorText("LLine1\rLLine2\rLLine3\r")

    -- test replace from cursor
    dt = { sSearchPat="l", sReplacePat="LL", CurPos=2, bSearchBack = (k==1) }
    SetEditorText("line1\rline2\rline3\r")
    if dt.bSearchBack then
      RunOneTest(lib, "test:replace", dt, 1, 1)
      AssertEditorText("LLine1\rline2\rline3\r")
    else
      RunOneTest(lib, "test:replace", dt, 2, 2)
      AssertEditorText("line1\rLLine2\rLLine3\r")
    end

    -- test submatches (captures)
    dt = { sSearchPat="(.)(.)(.)(.)(.)(.)(.)(.)(.)(.)(.)(.)(.)(.)(.)",
           sReplacePat="-$F-$E-$D-$C-$B-$A-$9-$8-$7-$6-$5-$4-$3-$2-$1-$0-",
           bRegExpr=true }
    dt.bSearchBack = (k==1)
    dt.sOrigin = "scope"
    local subj = "abcdefghijklmno1234"
    SetEditorText(subj)
    RunOneTest(lib, "test:replace", dt, 1, 1)
    AssertEditorText(dt.bSearchBack and
      "abcd-4-3-2-1-o-n-m-l-k-j-i-h-g-f-e-efghijklmno1234-" or
      "-o-n-m-l-k-j-i-h-g-f-e-d-c-b-a-abcdefghijklmno-1234")

    -- test escaped dollar and backslash
    dt = { sSearchPat="abc", sReplacePat=[[$0\$0\t\\t]], bRegExpr=true }
    dt.bSearchBack = (k==1)
    dt.sOrigin = "scope"
    SetEditorText("abc")
    RunOneTest(lib, "test:replace", dt, 1, 1)
    AssertEditorText("abc$0\t\\t")
  end

  -- test escape sequences in replace pattern
  local dt = { sSearchPat="b", sReplacePat=[[\a\e\f\n\r\t]], bRegExpr=true }
  for i=0,127 do dt.sReplacePat = dt.sReplacePat .. ("\\x%x"):format(i) end
  SetEditorText("abc")
  RunOneTest(lib, "test:replace", dt, 1, 1)
  local result = "a\7\27\12\13\13\9"
  for i=0,127 do result = result .. string.char(i) end
  result = result:gsub("\10", "\13", 1) .. "c"
  AssertEditorText(result)

  -- test text case modifiers
  dt = { sSearchPat="abAB",
    sReplacePat=[[\l$0 \u$0 \L$0\E $0 \U$0\E $0 \L\u$0\E \U\l$0\E \L\U$0\E$0\E]],
    bRegExpr=true }
  SetEditorText("abAB")
  RunOneTest(lib, "test:replace", dt, 1, 1)
  AssertEditorText("abAB AbAB abab abAB ABAB abAB Abab aBAB ABABabab")

  -- test counter
  dt = { sSearchPat=".+", sReplacePat=[[\R$0]], bRegExpr=true }
  SetEditorText("a\rb\rc\rd\re\rf\rg\rh\ri\rj\r")
  RunOneTest(lib, "test:replace", dt, 10, 10)
  AssertEditorText("1a\r2b\r3c\r4d\r5e\r6f\r7g\r8h\r9i\r10j\r")
  --------
  dt.sReplacePat=[[\R{-5}$0]]
  SetEditorText("a\rb\rc\rd\re\rf\rg\rh\ri\rj\r")
  RunOneTest(lib, "test:replace", dt, 10, 10)
  AssertEditorText("-5a\r-4b\r-3c\r-2d\r-1e\r0f\r1g\r2h\r3i\r4j\r")
  --------
  dt.sReplacePat=[[\R{5,3}$0]]
  SetEditorText("a\rb\rc\rd\re\rf\rg\rh\ri\rj\r")
  RunOneTest(lib, "test:replace", dt, 10, 10)
  AssertEditorText("005a\r006b\r007c\r008d\r009e\r010f\r011g\r012h\r013i\r014j\r")

  -- test replace in selection
  dt = { sSearchPat="in", sReplacePat="###", sScope="block" }
  SetEditorText("line1\rline2\rline3\rline4\r")
  editor.Select(nil, "BTYPE_STREAM",2,1,-1,2)
  RunOneTest(lib, "test:replace", dt, 2, 2)
  AssertEditorText("line1\rl###e2\rl###e3\rline4\r")
  --------
  dt = { sSearchPat=".+", sReplacePat="###", sScope="block", bRegExpr=true }
  SetEditorText("line1\rline2\rline3\rline4\r")
  editor.Select(nil, "BTYPE_COLUMN",2,2,2,2)
  RunOneTest(lib, "test:replace", dt, 2, 2)
  AssertEditorText("line1\rl###e2\rl###e3\rline4\r")

  -- test "function mode"
  dt = { sSearchPat="(.)(.)(.)(.)(.)(.)(.)(.)(.)", bRepIsFunc=true,
         bRegExpr=true,
         sReplacePat = "V=(V or 1)*3; return V..t[9]..t[8]..t[7]..t[6]..t[5]..t[4]..t[3]..t[2]..t[1]"
  }
  SetEditorText("abcdefghiabcdefghiabcdefghi")
  RunOneTest(lib, "test:replace", dt, 3, 3)
  AssertEditorText("3ihgfedcba9ihgfedcba27ihgfedcba")
  --------
  dt.sSearchPat = ".+"
  dt.sReplacePat = (lib == "lua")
    and [[return t[0] .. '--' .. rex.match(t[0], '%d%d')]]
    or  [[return t[0] .. '--' .. rex.match(t[0], '\\d\\d')]]
  RunOneTest(lib, "test:replace", dt, 1, 1)
  AssertEditorText("3ihgfedcba9ihgfedcba27ihgfedcba--27")
  --------
  dt.sSearchPat = ".+"
  dt.sReplacePat = nil
  RunOneTest(lib, "test:replace", dt, 1, 0)
  --------
  dt.sReplacePat = ""
  RunOneTest(lib, "test:replace", dt, 1, 0)
  --------
  dt.sReplacePat = "return false"
  RunOneTest(lib, "test:replace", dt, 1, 0)

  -- test replace patterns containing \n or \r
  local dt = { sSearchPat=".", sReplacePat="a\rb", bRegExpr=true }
  dt.sOrigin = "scope"
  for k=0,1 do
    dt.bSearchBack = (k==1)
    SetEditorText("L1\rL2\r")
    RunOneTest(lib, "test:replace", dt, 4, 4)
    AssertEditorText("a\rba\rb\ra\rba\rb\r")
  end

  -- test "Delete empty line"
  local dt = { sSearchPat=".*a.*", sReplacePat="", bRegExpr=true }
  dt.sOrigin = "scope"
  dt.bDelEmptyLine = true
  for k=0,1 do
    dt.bSearchBack = (k==1)
    SetEditorText("foo1\rbar1\rfoo2\rbar2\rfoo3\rbar3\r")
    RunOneTest(lib, "test:replace", dt, 3, 3)
    AssertEditorText("foo1\rfoo2\rfoo3\r")
  end
  for k=0,1 do
    dt.bSearchBack = (k==1)
    SetEditorText("bar1\rbar2\rbar3\r")
    RunOneTest(lib, "test:replace", dt, 3, 3)
    AssertEditorText("")
  end
  dt.sScope = "block"
  for k=0,1 do
    dt.bSearchBack = (k==1)
    SetEditorText("foo1\rbar1\rfoo2\rbar2\rfoo3\rbar3\rfoo4\rbar4\r")
    editor.Select(nil, "BTYPE_STREAM",3,1,-1,4)
    RunOneTest(lib, "test:replace", dt, 2, 2)
    AssertEditorText("foo1\rbar1\rfoo2\rfoo3\rfoo4\rbar4\r")
  end
  -- bug discovered 2011-09-26 -------------------------------------------------
  local dt = { sSearchPat=".+", sReplacePat="$0\n", bRegExpr=true }
  dt.sOrigin = "scope"
  dt.bDelEmptyLine = true
  for k=0,1 do
    dt.bSearchBack = (k==1)
    SetEditorText("foo1\rfoo2\rfoo3\r")
    RunOneTest(lib, "test:replace", dt, 3, 3)
    AssertEditorText("foo1\r\rfoo2\r\rfoo3\r\r")
  end
  ------------------------------------------------------------------------------
end

local function test_Encodings (lib)
  local dt = { bRegExpr=true }
  dt.sSearchPat = (lib == "lua") and "%w+" or "\\w+"
  --------
  SetEditorText(abc_utf8)
  dt.sReplacePat = ""
  RunOneTest(lib, "test:replace", dt, 1, 1)
  AssertEditorText("")
  --------
  SetEditorText(abc_utf8)
  dt.sReplacePat = "\\L$0"
  RunOneTest(lib, "test:replace", dt, 1, 1)
  local s = GetEditorText()
  ProtectedAssert(s:sub(1,33)==s:sub(34))
  --------
  SetEditorText(abc_utf8)
  dt.sReplacePat = "\\U$0"
  RunOneTest(lib, "test:replace", dt, 1, 1)
  local s = GetEditorText()
  ProtectedAssert(s:sub(1,33)==s:sub(34))
  --------
end

local function test_bug_20090208 (lib)
  local dt = { bRegExpr=true, sReplacePat="\n$0", sScope="block" }
  dt.sSearchPat = (lib == "lua") and "%w+" or "\\w+"
  SetEditorText(("my table\r"):rep(5))
  editor.Select(nil, "BTYPE_STREAM",2,1,-1,2)
  RunOneTest(lib, "test:replace", dt, 4, 4)
  AssertEditorText("my table\r\rmy \rtable\r\rmy \rtable\rmy table\rmy table\r")
end

local function test_bug_20100802 (lib)
  local dt = { sOrigin="scope", bRegExpr=true, sReplacePat="" }
  for k = 0, 1 do
    dt.bSearchBack = (k == 1)

    SetEditorText("line1\rline2\r")
    dt.sSearchPat = "^."
    RunOneTest(lib, "test:replace", dt, 2, 2)
    AssertEditorText("ine1\rine2\r")

    SetEditorText("line1\rline2\r")
    dt.sSearchPat = ".$"
    RunOneTest(lib, "test:replace", dt, 2, 2)
    AssertEditorText("line\rline\r")
  end
end

local function test_EmptyMatch (lib)
  local dt = { bRegExpr=true, sReplacePat="-" }
  dt.sSearchPat = (lib == "lua") and ".-" or ".*?"
  SetEditorText(("line1\rline2\r"))
  RunOneTest(lib, "test:replace", dt, 13, 13)
  AssertEditorText("-l-i-n-e-1-\r-l-i-n-e-2-\r-")

  dt.sSearchPat, dt.sReplacePat = ".*", "1. $0"
  SetEditorText(("line1\rline2\r"))
  RunOneTest(lib, "test:replace", dt, 3, 3)
  AssertEditorText("1. line1\r1. line2\r1. ")
end

local function test_Anchors (lib)
  local dt = { bRegExpr=true, sOrigin="scope" }
  SetEditorText("line\rline\r")
  for k1 = 0, 1 do dt.sSearchPat = (k1 == 0) and "^." or ".$"
  for k2 = 0, 1 do dt.bSearchBack = (k2 == 1)
    RunOneTest(lib, "test:count", dt, 2, 0)
  end end
end

local function test_bug1_20111114 (lib)
  SetEditorText("Д121") -- 1-st char takes 2 bytes in UTF-8

  local dt = { sSearchPat="1", sOrigin="cursor", CurPos=3 }
  RunOneTest(lib, "test:search", dt, 1, 0)
  local info, SI = editor.GetInfo(), editor.GetString()
  ProtectedAssert(info.CurPos == 5)
  ProtectedAssert(SI.SelStart == 4)
  ProtectedAssert(SI.SelEnd == 4)

  dt.CurPos = 1
  RunOneTest(lib, "test:count", dt, 2, 0)
end

local function test_bug2_20111114 (lib)
  SetEditorText("Д121") -- 1-st char takes 2 bytes in UTF-8

  local dt = { sSearchPat="1", sOrigin="cursor", sScope="block", CurPos=3 }
  editor.Select(nil, "BTYPE_STREAM",1,1,4,1)
  RunOneTest(lib, "test:search", dt, 1, 0)
  local info, SI = editor.GetInfo(), editor.GetString()
  ProtectedAssert(info.CurPos == 5)
  ProtectedAssert(SI.SelStart == 4)
  ProtectedAssert(SI.SelEnd == 4)

  dt.CurPos = 1
  editor.Select(nil, "BTYPE_STREAM",1,1,3,1)
  RunOneTest(lib, "test:count", dt, 1, 0)

  editor.Select(nil, "BTYPE_STREAM",1,1,4,1)
  RunOneTest(lib, "test:count", dt, 2, 0)
end

local function test_bug_20120301 (lib)
  SetEditorText("-\tabc")
  local dt = { sSearchPat="abc", sReplacePat="", sScope="block" }
  local pos = editor.RealToTab(nil, 1, 3)
  editor.Select(nil, "BTYPE_COLUMN", 1, pos, 3, 1)
  RunOneTest(lib, "test:replace", dt, 1, 1)
end

local function test1 (lib)
  OpenHelperEditor()
  test_Switches     (lib)
  test_LineFilter   (lib)
  test_Replace      (lib)
  test_Encodings    (lib)
  test_Anchors      (lib)
  test_EmptyMatch   (lib)
  test_bug_20090208 (lib)
  test_bug_20100802 (lib)
  test_bug1_20111114(lib)
  test_bug2_20111114(lib)
  test_bug_20120301 (lib)
  CloseHelperEditor()
end

do
  local libs = ...
  if type(libs) ~= "table" then libs = {...} end
  SavedData = _Plugin.History:field("main")
  for _,lib in ipairs(libs) do
    test1(lib)
  end
  _Plugin.History:setfield("main", SavedData) -- restore the history
  far.Message("All tests OK", "LuaFAR Search")
end

