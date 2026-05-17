--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_EditorLevelLoader_C
local M = Class("BluePrints.Common.BP_LevelLoader_C")

-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

function M:ReceiveBeginPlay()
    self.Overridden.ReceiveBeginPlay(self)
    local levelTable=DataMgr.GetLevelLoaderJsonData(self.JsonName)
    self.points=levelTable.points
    self:LevelLoaderReady()
end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

function M:LoadArtLevel(ID,bMakeVisibleAfterLoad,bShouldBlockOnLoad)
end

function M:UnloadArtLevel(ID)
end

function M:SetLevelDoor(door)
end

function M:SetInitTrans(PlayerController)
end

return M
