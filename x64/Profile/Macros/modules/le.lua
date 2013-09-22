-- modded by John Doe: http://forum.farmanager.com/viewtopic.php?p=107251#p107251
--                     http://forum.farmanager.com/viewtopic.php?p=108182#p108182
--                     http://forum.farmanager.com/viewtopic.php?p=109359#p109359

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

F1         Show this help
F3         Show some function info
Shift+F3   Show some function info (LuaJIT required)
F4         Edit selected object
Del        Delete selected object
Ins        Add an object to current table
Ctrl+F     Show/hide functions
Ctrl+M     Show metatable

]]
local omit = {}
local brkeys = {}

-- if LuaJIT is used, maybe we can show some more function info
if jit then
table.insert(brkeys, 	{BreakKey = 'Shift+F3',	action = function(obj, key, kpath)
		if key ~= nil and type(obj[key]) == 'function' then
			process(jit.util.funcinfo(obj[key]), 'jit.util.funcinfo: ' .. kpath)
		end
	end})
end

-- format values for menu items and message boxes
local function valfmt(val, edit)
	local t = type(val)
	if t == 'string' then
		return (edit and ('%q'):format(val) or '"' ..  val .. '"'), t
	elseif t == 'number' then
		return (edit and '0x%x --[[ %s ]]' or '0x%08x (%s)'):format(val, val), t
	end
	return tostring(val), t
end

-- make menu item for far.Menu(...)
local function makeItem(key, sval, vt)
        return {
                text    = ('%-30s│%-8s│%-25s'):format(valfmt(key), vt, sval),
                key     = key
	}
end

-- create sorted menu items with associated keys
local function makeMenuItems(obj)
	local items = {}

	-- grab all 'real' keys
	for key in pairs(obj) do
		local sval, vt = valfmt(obj[key])
		if not omit[vt] then
			table.insert(items, makeItem(key, sval, vt))
		end
	end

	-- Far uses some properties that in fact are functions in obj.properties
	-- but they logically belong to the object itself. It's all Lua magic ;)
	if type(obj.properties) == 'table' and not rawget(obj, 'properties') then
		for key in pairs(obj.properties) do
			local sval, vt = valfmt(obj[key])
			if not omit[vt] then
				table.insert(items, makeItem(key, sval, vt))
			end
		end
	end

	table.sort(items, function(v1, v2) return v1.text < v2.text end)

	return items
end

-- edit or remove object at obj[key]
local function editValue(obj, key, title, del)
	if del then
		if 1 == msgbox('REMOVE: ' .. title, ('%s is a %s, do you want to remove it?'):format(valfmt(key), type(obj[key]):upper()), 0x40001) then
			obj[key] = nil
		end
	else
		local v, t = valfmt(obj[key], true)
		if t == 'table' or t == 'function' then v = '' end
		local sval = prompt('EDIT: ' .. title, ('%s is a %s, type new value as Lua code'):format(valfmt(key), t:upper()), 0x11, v, 'edit.' .. title)
		if sval and #sval > 0 then
			obj[key] = loadstring('return ' .. sval)()
		end
	end
end

-- add new element to obj
local function insertValue(obj, title)
	local args = prompt('INSERT: ' .. title, 'type the key and value comma separated as Lua code', 0x11, nil, 'insert.' .. title)
	if args and #args > 0 then
		local k, v = loadstring('return ' .. args)()
		obj[k] = v
	end
end

-- show a menu whose items are associated with the members of given object
local function process(obj, title)
  title = title or ""
	local items, mprops = {}, {Id = uuid, Flags = 0x14, Bottom = 'F1, F3, F4, Del, Ctrl+M'}
	local otype = type(obj)
	local item, index


	-- some member types, need specific behavior:
	-- tables are submenus

	-- functions can be called
	if otype == 'function' then
		local args = prompt('CALL: ' .. title .. '(...)', 'Type arguments as Lua code or leave empty:', 0x11, nil, 'args.' .. title)
		if args then
			-- overwrite the function object with its return values
			obj = {pcall(obj, loadstring('return ' .. args)())}
			title = '{pcall(' .. title .. ')}'
		else
			return
		end

	-- other values are simply displayed in a message box
	elseif otype ~= 'table' then
		msgbox(title, valfmt(obj), nil)
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
				item.action(obj, key, (title .. '.' .. tostring(key)))
			end
		end
		-- until the user is bored and goes back ;)
	until not item
end

brkeys = {

  {BreakKey = 'Alt+F3',	action = function(obj, key, kpath)
		if key ~= nil and type(obj[key]) == 'function' then
			process(getfenv(obj[key]), 'getfenv: ' .. kpath)
		end
	end},

	{BreakKey = 'F3',	action = function(obj, key, kpath)
		if key ~= nil and type(obj[key]) == 'function' then
			process(debug.getinfo(obj[key]), 'debug.getinfo: ' .. kpath)
		end
	end},

	{BreakKey = 'F4',	action = function(obj, key, kpath)
		return key ~= nil and editValue(obj, key, kpath)
	end},

	{BreakKey = 'Ctrl+F',	action = function()
		omit['function'] = (not omit['function'])
	end},

	{BreakKey = 'Ctrl+M',	action = function(obj, key, kpath)
		return key ~= nil and process(debug.getmetatable(obj[key]), 'METATABLE: ' .. kpath)
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
