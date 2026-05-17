
package.path = package.path .. ";../../../?.lua;../?.lua"

local DungeonFactory = require "DungeonFactory"
-- DungeonClass = require "BluePrints.DungeonObject.DungeonClass"

function Test(SoloTreasure)
	local m = SoloTreasure:CreateMechanism()
	for k,v in pairs(m) do
		print(k,v)
	end

	local m = SoloTreasure:CreateDrop()
	for k,v in pairs(m) do
		print(k,v)
	end
end

-- local SoloTreasure = DungeonFactory.CreateDedicatedServerDungeon("SoloTreasure")
-- SoloTreasure:BeginPlay()
-- Test(SoloTreasure)

local SoloTreasure = DungeonFactory.CreateGameModeDungeon("SoloTreasure")
print(SoloTreasure)
local SoloTreasure1 = DungeonFactory.CreateGameModeDungeon("SoloTreasure")
print(SoloTreasure1)
-- SoloTreasure:BeginPlay()
-- Test(SoloTreasure)

-- local SoloTreasure = DungeonFactory.CreateGameModeDungeon("SoloTreasure")
-- SoloTreasure:BeginPlay()
-- Test(SoloTreasure)

-- os.execute("powershell -Command \"Start-Sleep -Seconds " .. 5 .. "\"")


-- -- 验证代码自热更，在这5秒内，可以修改代码
-- local SoloTreasure = DungeonFactory.CreateServerDungeon("SoloTreasure")
-- SoloTreasure:BeginPlay()

-- Test(SoloTreasure)