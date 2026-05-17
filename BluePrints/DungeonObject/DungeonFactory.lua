
local DungeonClass = require "BluePrints.DungeonObject.DungeonClass"
local GlobalFunction = require "BluePrints.DungeonObject.GlobalFunction"
local DungeonObjectConst = require "BluePrints.DungeonObject.DungeonObjectConst"

local DungeonFactory = {}

-- 自定义 require
DungeonFactory.CreateDungeon = function(ShortName, Type, Name, Env)
	if not DungeonObjectConst.OpenDungeonObjectsTypes[ShortName] then
		return
	end

	if not Name then
		return
	end

	local Path = "BluePrints.DungeonObject." .. Name .. '.' .. Name
	local ClearPackageFunc = Env and Env.ClearPackageFunc
	DungeonClass.ClearPackageFunc = ClearPackageFunc
	if ClearPackageFunc then
		ClearPackageFunc(Path)
	end
	local Module = require(Path)

	local Value = Module(Type)
	return Value
end

DungeonFactory.CreateServerDungeon = function(Name, Env)
	if not Name then
		return
	end
	return DungeonFactory.CreateDungeon(Name, 'Server', Name, Env)
end

DungeonFactory.CreateDedicatedServerDungeon = function(Name, Env)
	if not Name then
		return
	end
	return DungeonFactory.CreateDungeon(Name, 'DedicatedServer', Name, Env)
end

DungeonFactory.CreateGameModeDungeon = function(Name, Env)
	if not Name then
		return
	end
	return DungeonFactory.CreateDungeon(Name, 'GameMode', Name, Env)
end

DungeonFactory.CreateClientDungeon = function(Name, Env)
	if not Name then
		return
	end
	return DungeonFactory.CreateDungeon(Name, 'Client', Name, Env)
end

-- 设置环境可以访问的外部对象
DungeonFactory.InitEnv = function(Outer)
	for k, v in pairs(Outer) do
		rawset(GlobalFunction, k, v)
	end
end

return DungeonFactory