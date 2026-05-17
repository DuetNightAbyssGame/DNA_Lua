local ServerMonsterSpawn = require "BluePrints.DungeonObject.DungeonComponent.ServerMonsterSpawn"

local ServerMonsterSpawnManager = DungeonClass.Class()

ServerMonsterSpawnManager.__Name__ = "ServerMonsterSpawnManager"

ServerMonsterSpawnManager.__Component__ = {
}

function ServerMonsterSpawnManager:BeginPlay()
	self.MonsterSpawnMap = {}
	self.MonsterSpawnHandlerMap = {}
end

function ServerMonsterSpawnManager:EndPlay()
	self.MonsterSpawnMap = {}
	for _, Handler in pairs(self.MonsterSpawnHandlerMap) do
		self:RemoveTimer(Handler)
	end
	self.MonsterSpawnHandlerMap = {}
end

function ServerMonsterSpawnManager:AddTimerHandlerToMap(UnitSpawnId, Handler)
	self.MonsterSpawnHandlerMap[UnitSpawnId] = Handler
end

function ServerMonsterSpawnManager:ServerTriggerCreateMonsterSpawn(UnitSpawnIdTable, OnlyRelation)
    print("ServerTriggerCreateMonsterSpawn", UnitSpawnIdTable, OnlyRelation)
	for _, UnitSpawnId in pairs(UnitSpawnIdTable) do
		self:CreateSingleMonsterSpawn(UnitSpawnId, OnlyRelation)
	end
	self:NotifyGameModeDungeonEvent("ServerTriggerCreateMonsterSpawn", UnitSpawnIdTable, OnlyRelation)
end

function ServerMonsterSpawnManager:ServerTriggerDestroyMonsterSpawn(UnitSpawnIdTable)
    for _, UnitSpawnId in pairs(UnitSpawnIdTable) do
        self:DestroySingleMonsterSpawn(UnitSpawnId)
    end
	self:NotifyGameModeDungeonEvent("ServerTriggerDestroyMonsterSpawn", UnitSpawnIdTable)
end

function ServerMonsterSpawnManager:ServerTriggerDestroyAll(UnitSpawnIdTable, NormalDeath)
    for _, UnitSpawnId in pairs(UnitSpawnIdTable) do
        self:DestroyAllSingleMonsterSpawn(UnitSpawnId, NormalDeath)
    end
	self:NotifyGameModeDungeonEvent("ServerTriggerDestroyAllMonsterSpawn", UnitSpawnIdTable, NormalDeath)
end

function ServerMonsterSpawnManager:ServerTriggerPauseMonsterSpawn(UnitSpawnIdTable)
    for _, UnitSpawnId in pairs(UnitSpawnIdTable) do
        self:PauseSingleMonsterSpawn(UnitSpawnId)
    end
    self:NotifyGameModeDungeonEvent("ServerTriggerPauseAllMonsterSpawn", UnitSpawnIdTable)
end

function ServerMonsterSpawnManager:ServerTriggerResumeMonsterSpawn(UnitSpawnIdTable)
    for _, UnitSpawnId in pairs(UnitSpawnIdTable) do
        self:ResumeSingleMonsterSpawn(UnitSpawnId)
    end
    self:NotifyGameModeDungeonEvent("ServerTriggerResumeAllMonsterSpawn", UnitSpawnIdTable)
end

function ServerMonsterSpawnManager:CreateSingleMonsterSpawn(UnitSpawnId, OnlyRelation)
	if self.MonsterSpawnMap[UnitSpawnId] then
		return
	end
	print("ServerMonsterSpawnManager:CreateSingleMonsterSpawn", UnitSpawnId, OnlyRelation)
	local NewServerMonsterSpawn = ServerMonsterSpawn()
	self.MonsterSpawnMap[UnitSpawnId] = NewServerMonsterSpawn
	NewServerMonsterSpawn:InitMonsterSpawn(UnitSpawnId, OnlyRelation, self)
end

function ServerMonsterSpawnManager:DestroySingleMonsterSpawn(UnitSpawnId)
    local MonsterSpawn = self.MonsterSpawnMap[UnitSpawnId]
    if not MonsterSpawn then
        return
    end
    MonsterSpawn:TriggerDestroy(true, true)
end

function ServerMonsterSpawnManager:DestroyAllSingleMonsterSpawn(UnitSpawnId, NormalDeath)
    local MonsterSpawn = self.MonsterSpawnMap[UnitSpawnId]
    if not MonsterSpawn then
        return
    end
	-- 对于Server，规则要销毁
    MonsterSpawn:TriggerDestroy(true, true)
end

function ServerMonsterSpawnManager:PauseSingleMonsterSpawn(UnitSpawnId)
    local MonsterSpawn = self.MonsterSpawnMap[UnitSpawnId]
    if not MonsterSpawn then
        return
    end
    MonsterSpawn:TriggerPause()
end

function ServerMonsterSpawnManager:ResumeSingleMonsterSpawn(UnitSpawnId)
    local MonsterSpawn = self.MonsterSpawnMap[UnitSpawnId]
    if not MonsterSpawn then
        return
    end
    MonsterSpawn:TriggerResume()
end

function ServerMonsterSpawnManager:RealDestroyMonsterSpawn(UnitSpawnId)
    local MonsterSpawnHandler = self.MonsterSpawnHandlerMap[UnitSpawnId]
    if MonsterSpawnHandler then
        self:RemoveTimer(MonsterSpawnHandler)
    end
    self.MonsterSpawnMap[UnitSpawnId] = nil
end

function ServerMonsterSpawnManager:DungeonMonsterDead(MonsterInfo)
	print("ServerMonsterSpawnManager:DungeonMonsterDead", MonsterInfo.CreatorId)
    -- hack一下，测试用
    -- MonsterInfo.CreatorId = 9170001
    local MonsterSpawn = self.MonsterSpawnMap[MonsterInfo.CreatorId]
    if not MonsterSpawn then
        return
    end
    MonsterSpawn:TriggerMonsterDead(MonsterInfo)
end

function ServerMonsterSpawnManager:OnNotifyServerDungeonEvent_MultiInfoResChange(UnitSpawnId, MultiInfoRes)
	print("ServerMonsterSpawnManager:OnNotifyServerDungeonEvent_MultiInfoResChange UnitSpawnId:", UnitSpawnId, "MultiInfoRes:", MultiInfoRes)
    local MonsterSpawn = self.MonsterSpawnMap[UnitSpawnId]
    if not MonsterSpawn then
        return
    end
    MonsterSpawn:OnReceiveMultiInfoRes(MultiInfoRes)
end

function ServerMonsterSpawnManager:DebugPrint(Str, UnitSpawnId)
	print("[ServerMonsterSpawnLog] UnitSpawnId: "..UnitSpawnId.." "..Str)
end

DungeonClass.AssembleComponents(ServerMonsterSpawnManager)
return ServerMonsterSpawnManager