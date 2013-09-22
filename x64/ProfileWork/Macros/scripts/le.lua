--[=[ modded by John Doe:
  http://forum.farmanager.com/viewtopic.php?p=107251#p107251
  http://forum.farmanager.com/viewtopic.php?p=108182#p108182
  http://forum.farmanager.com/viewtopic.php?p=109359#p109359
  http://forum.farmanager.com/viewtopic.php?p=109807#p109807
  http://forum.farmanager.com/viewtopic.php?p=109837#p109837
--]=]

--[[
	Lua Explorer

	Explore Lua environment in your Far manager

	Author: Eugen Gez (EGez/http://forum.farmanager.com)
	updates, suggestions, etc.:
	http://forum.farmanager.com/viewtopic.php?f=15&t=7521


	BE CAREFUL:
		calling some functions could cause deadlocks!!!
		you will need to kill far process in such cases

	do not call functions like debug.debug() or io.* functions
	that read from stdin unless you know what you are doing


	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND.
	ANY USE IS AT YOUR OWN RISK.

	Do what you want with this code, but please do not remove this comment
	and write your changes down.


	changes:
	EGez 03.02.13 04:21:56 +0100 - v1.1.2
	* minor changes/corrections

	EGez 14.12.2012 22:04:01 +0100 - v1.1.1
	* quote strings using "%q" instead of own addslashes
	* minor changes/optimisations

	EGez 08.12.2012 13:34:02 +0100 - v1.1
	+ edit/remove/insert objects (F4/Del/Ins)
	+ show function info (F3/Shift+F3)
	+ show/hide functions (Ctrl+F)
	+ show metatable (Ctrl+M)
	+ display numbers as hex and dec
	+ history for input fields
	+ help (F1)
	* minor changes/optimisations/refactoring

	EGez 27.11.2012 20:52:26 +0100 - v1.0
	first release

	todo:
]]

assert(Far, 'This is a LuaMacro for Far manager')

local uuid	= win.Uuid('7646f761-8954-42ca-9cfc-e3f98a1c54d3')
local help	= [[

There are some keys available:

F1              Show this help
F4              Edit selected object
Del             Delete selected object
Ins             Add an object to current table
Ctrl+M          Show metatable
Ctrl+F          Show/hide functions

for functions:

F3              Show some function info
Shift+F3        Show some function info (LuaJIT required)
Alt+F4          Open function definition (if available) in editor
Ctrl+Up         upvalues
Ctrl+Down       environment


Copy to clipboard:

Ctrl+Ins        value
Ctrl+Shift+Ins  key
]]

local omit = {}
local brkeys = {}

-- format values for menu items and message boxes
local function valfmt(val, mode)
	local t = type(val)
	if t == 'string' then
		return (mode=='edit' and ('%q'):format(val) or 
		       (mode~='list' or val=='' or val:match' $') and '"' ..  val .. '"' or
		        val), t
	elseif t == 'number' then
		return (quote4=="edit" and '0x%x --[[ %s ]]' or '0x%08x (%s)'):format(val, val), t
	end
	return tostring(val), t
end

-- make menu item for far.Menu(...)
local key_w = 30
local item_fmt = ('%%-%s.%ss'):format(key_w,key_w)..'%s%-8s │%-25s'
local function makeItem(key, sval, vt)
	local k = valfmt(key,'list')
	local border = k:len()<=key_w and '│' or '…'
	return {
		text    = item_fmt:format(k, border, vt, sval),
		key     = key,
		checked = vt=='table' and '≡'        --⁞≡•·÷»›►
		          or vt=='function' and '˜'  --ᶠ¨˝˜
	}
end

-- create sorted menu items with associated keys
local function makeMenuItems(obj)
	local items = {}

	-- grab all 'real' keys
	for key in pairs(obj) do
		local sval, vt = valfmt(obj[key],'list')
		if not omit[vt] then
			table.insert(items, makeItem(key, sval, vt))
		end
	end

	-- Far uses some properties that in fact are functions in obj.properties
	-- but they logically belong to the object itself. It's all Lua magic ;)

	local success,props = pcall(function()return obj.properties end)
	--if not success then far.Message(props,"Error in __index metamethod",nil,"wl") end
	if type(props) == 'table' and not rawget(obj, 'properties') then
	--if type(obj.properties) == 'table' and not rawget(obj, 'properties') then
		for key in pairs(obj.properties) do
			local sval, vt = valfmt(obj[key],'list')
			if not omit[vt] then
				table.insert(items, makeItem(key, sval, vt))
			end
		end
	end

	table.sort(items, function(v1, v2) return v1.text < v2.text end)

	return items
end

local function luaexp_prompt(Title,Prompt,Src)
	repeat
		local expr = far.InputBox (nil, Title:gsub('&','&&',1), Prompt,
		                           Title, Src, nil, nil, far.Flags.FIB_ENABLEEMPTY)
		if not expr then return end
		local f,err = loadstring('return '..expr)
		if f then
			local res = {pcall(f)}
			if res[1] then	table.remove(res,1);	return res
			else	far.Message(res[2],'Error',nil,'w')
			end
		else
			far.Message(err,'Error in expression',nil,'wl')
		end
	until false
end

-- edit or remove object at obj[key]
local function editValue(obj, key, title, del)
	if del then
		if 1 == msgbox('REMOVE: ' .. title, 
		               ('%s is a %s, do you want to remove it?'):format(valfmt(key), 
		               type(obj[key]):upper()), 
		               0x40001) then
			obj[key] = nil
		end
	else
		local v, t = valfmt(obj[key], "edit")
		if t == 'table' or t == 'function' then	v = ''	end
		local prompt = ('%s is a %s, type new value as Lua code'):format(valfmt(key),t:upper())
		local res = luaexp_prompt('EDIT: ' .. title, prompt, v)
		obj[key] = res and res[1] or obj[key]
	end
end

-- add new element to obj
local function insertValue(obj, title)
	local res = luaexp_prompt('INSERT: ' .. title,
	                          'type the key and value comma separated as Lua code')
	if res then
		local k, v = unpack(res)
		if k~=nil then	obj[k] = v	end
	end
end

-- show a menu whose items are associated with the members of given object
local function process(obj, title)
	title = title or ''
	local items, mprops = {}, {Id = uuid, Flags = 0x14, Bottom = 'F1, F3, F4, Del, Ctrl+M',
	                           Flags={FMENU_SHOWAMPERSAND=1,FMENU_WRAPMODE=1}}--,FMENU_AUTOHIGHLIGHT=1}}
	local otype = type(obj)
	local item, index

	-- some member types, need specific behavior:
	-- tables are submenus

	-- functions can be called
	if otype == 'function' then
		local args = luaexp_prompt('CALL: ' .. title .. '(...)',
		                           'Type arguments as Lua code or leave empty:')
		--far.Show(unpack(args))
		if args then
			-- overwrite the function object with its return values
			local res = {pcall(obj, unpack(args))}
			if res[1] then
				table.remove(res,1)
				obj = res
				title = ('%s(%s)'):format(title,table.concat(args,','))
			else
				far.Message(('function: %s\narguments: %s\n\n%s')
				            :format(title,table.concat(args,','),res[2]),'Error',nil,'wl')
				return
			end
		else
			return
		end

	-- other values are simply displayed in a message box
	elseif otype ~= 'table' then
		local value = valfmt(obj,"view")
		far.Message(value, title:gsub('&','&&',1), nil, value:match'\n' and 'l' or '')
		return
	end


	-- show this menu level again after each return from a submenu/function call ...
	repeat
		items = makeMenuItems(obj)
		mprops.Title = title .. '  (' .. #items .. ')' .. (omit['function'] and '*' or '')

		item, index = far.Menu(mprops, items, brkeys)
		mprops.SelectIndex = index

		-- show submenu/call function ...
		if item then
			local key = item.key or (index > 0 and items[index].key)
			if item.key ~= nil then
				process(obj[key], title .. '.' .. tostring(key))
			elseif item.action then
				if "break"==item.action(obj, key, (title .. '.' .. tostring(key))) then	return	end
			end
		end
		-- until the user is bored and goes back ;)
	until not item
end

local function getAllUpvalues(f)
	local upvalues = {}
	for i=1,1000 do
		local k,v = debug.getupvalue (f, i)
		if not k then	return upvalues, i-1	end
		upvalues[k] = v
	end
end

local function syncUpvalues(f,t,n)
	for i=n,1,-1 do
		local k,v = debug.getupvalue (f, i)
		if t[k]~=v then
			assert(k == debug.setupvalue (f, i, t[k]))
		end
	end
end

local function getAllLocals(level)
	local locals = {}
	for i=1,1000 do
		local k,v = debug.getlocal (level+1, i)
		if not k then	return locals, i-1	end
		locals[k] = v
	end
end

local function syncLocals(level,t,n)
	level = level + 1
	for i=n,1,-1 do
		local k,v = debug.getlocal (level, i)
		if t[k]~=v then
			assert(k == debug.setlocal (level, i, t[k]))
		end
	end
end

local function showLocals(level)
	local shift = 0
	for i = 1,1000 do
		local info = debug.getinfo(i,"f")
		if not info then	break	end
		if info.func==process then	shift = i	end
	end
	if shift>900 then	return	end
	level = level + shift
	local info = debug.getinfo(level,"")
	if not info then	mf.beep() return	end
	local t,n = getAllLocals(level)
	if n>0 then 
		process(t, ('locals [%d]: %s'):format(level-shift,info.name or 'main chunk'))
		syncLocals(level,t,n)
		return "break"
	end
end

brkeys = {
	{BreakKey = 'F9',	action = function(info)
		process(debug.getregistry(), 'debug.getregistry:')
	end},

	{BreakKey = 'Ctrl+1',	action = function()	return showLocals(1)	end},
	{BreakKey = 'Ctrl+2',	action = function()	return showLocals(2)	end},
	{BreakKey = 'Ctrl+3',	action = function()	return showLocals(3)	end},
	{BreakKey = 'Ctrl+4',	action = function()	return showLocals(4)	end},
	{BreakKey = 'Ctrl+5',	action = function()	return showLocals(5)	end},
	{BreakKey = 'Ctrl+6',	action = function()	return showLocals(6)	end},
	{BreakKey = 'Ctrl+7',	action = function()	return showLocals(7)	end},
	{BreakKey = 'Ctrl+8',	action = function()	return showLocals(8)	end},
	{BreakKey = 'Ctrl+9',	action = function()	return showLocals(9)	end},
	{BreakKey = 'Ctrl+0',	action = function()	return showLocals(0)	end},
	{BreakKey = 'Ctrl+G',	action = function()	process(_G,'_G');	return "break"	end},

	{BreakKey = 'Ctrl+Insert',	action = function(obj, key)
		far.CopyToClipboard ((valfmt(obj)))
	end},

	{BreakKey = 'CtrlShift+Insert',	action = function(obj, key)
		far.CopyToClipboard ((valfmt(key)))
	end},

	{BreakKey = 'Ctrl+Up',	action = function(obj, key, kpath)
		local f = obj[key]
		if type(f) == 'function' then
			local t,n = getAllUpvalues(f)
			if n>0 then
				process(t, 'upvalues: ' .. kpath)
				syncUpvalues(f,t,n)
			end
		end
	end},

	{BreakKey = 'Ctrl+Down',	action = function(obj, key, kpath)
		local f = obj[key]; local t = type(f)
		if t=='function' or t=='userdata' or t=='thread' then
			local env = debug.getfenv(f)
			if env~=_G or 1==far.Message('Show global environment?','_G') then
				process(env, 'getfenv: ' .. kpath)
			end
		end
	end},

	{BreakKey = 'Alt+F4',	action = function(obj, key, kpath)
		local f = obj[key]
		if type(f) == 'function' then
			local info = debug.getinfo(f,'S')
			local filename = info.source:match("^@(.+)$")
			if filename then
				editor.Editor(filename,nil,nil,nil,nil,nil,nil,info.linedefined)
			end
		end
	end},

	{BreakKey = 'F3',	action = function(obj, key, kpath)
		local f = obj[key]
		if type(f) == 'function' then
			process(debug.getinfo(f), 'debug.getinfo: ' .. kpath)
		elseif type(f) == 'thread' then
			far.Message(debug.traceback(f,"level 0",0),'debug.traceback: ' .. kpath,nil,"l")
			--far.Show('debug.traceback: ' .. kpath .. debug.traceback(f,", level 0",0))
		end
	end},

	{BreakKey = 'F4',	action = function(obj, key, kpath)
		return key ~= nil and editValue(obj, key, kpath)
	end},

	{BreakKey = 'Ctrl+F',	action = function()
		omit['function'] = (not omit['function'])
	end},

	{BreakKey = 'Ctrl+M',	action = function(obj, key, kpath)
		local mt = key ~= nil and debug.getmetatable(obj[key])
		return mt and process(mt, 'METATABLE: ' .. kpath)
	end},

	{BreakKey = 'DELETE',	action = function(obj, key, kpath)
		return key ~= nil and editValue(obj, key, kpath, true)
	end},

	{BreakKey = 'INSERT',	action = function(obj, key, kpath)
		insertValue(obj, kpath:sub(1, -(#tostring(key) + 2)))
	end},

	{BreakKey = 'F1',	action = function()
		msgbox('Lua Explorer - Help', help, 0x8)
	end},
}

-- if LuaJIT is used, maybe we can show some more function info
if jit then
	table.insert(brkeys, 	{BreakKey = 'Shift+F3',	action = function(obj, key, kpath)
		if key ~= nil and type(obj[key]) == 'function' then
			process(jit.util.funcinfo(obj[key]), 'jit.util.funcinfo: ' .. kpath)
		end
	end})
end

if not Macro then return process end

Macro { description = "Lua Explorer";
	area="Common"; key="CtrlShiftF12"; action=function()
		process(_G,'_G')
		--require"le"(_G,'_G')
	end
}

-- it's possible to call via lm:post, e.g. from user menu:
-- lm:post dofile(win.GetEnv("FARPROFILE")..[[\Macros\scripts\le.lua]])(_G,'_G')
-- lm:post require"le"(_G,'_G')
