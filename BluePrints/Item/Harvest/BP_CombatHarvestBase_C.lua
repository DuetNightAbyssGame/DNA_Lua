--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_CombatHarvestBase_C
require "UnLua"

local M = Class("BluePrints/Item/CombatProp/BP_CombatPropBase_C")

function M:AuthorityInitInfo(Info)
    M.Super.AuthorityInitInfo(self, Info)
    self.RareProb = self.UnitParams["RareProb"] or -1
    self.RareRewardId = self.UnitParams["RareRewardId"] or 0
    self.bRare = false
    -- if not Info.State then
    --     --0:未被破坏 1:普通  2:稀有
    --     self:UpdateRegionData("RareType", 0)
    -- end
end

function M:OnToughnessToZero()
    local NextStateId = self.Normal_State_Id
    if math.random() <= self.RareProb then
        NextStateId = self.Rare_State_Id
        if IsAuthority(self) then
            self.bRare = true
            -- local GameMode = UGameplayStatics.GetGameMode(self)
            -- GameMode:DelDropRule(self.UnitId, self.RewardId)
            -- GameMode:AddDropRule(self.UnitId, self.RareRewardId)
        end
        -- self.RewardID = self.RareRewardId
    end
    self:ChangeState("Manual", 0, NextStateId)
end

function M:GetCanOpen(PlayerId)
    self.CanOpen = true
end

function M:OpenMechanism(PlayerId)
    print(_G.LogTag,"LXZ OpenMechanism", self.OpenState)
    if not self.OpenState then
        self:CreateReward(PlayerId)
    end
    self:UpdateRegionData("OpenState", true)
end

function M:CreateReward(PlayerId)
    if not self:CheckAutoCreateReward() then
        return
    end
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then
        local RewardPosition = self:GetTransform()
        local ExtraInfo = {SourceEid = PlayerId, UniqueSign = self.Eid, ParentEid = self.Eid, bRare = self.bRare, WorldRegionEid = self.WorldRegionEid, RegionDataType = self.RegionDataType}
        --todo 目前GameMode Reward结构不支持实例动态Id,临时这样写
        GameMode:TriggerRewardEvent(self.UnitId, CommonConst.RewardReason.Chest, RewardPosition, ExtraInfo)
    end
end

function M:StateCreateReward(PlayerId, NextStateId)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then
        local ExtraInfo = {SourceEid = PlayerId, UniqueSign = self.Eid, ParentEid = self.Eid, bRare = self.bRare, WorldRegionEid = self.WorldRegionEid, RegionDataType = self.RegionDataType}
        local function CallBack()
            self.CombatStateChangeComponent:TriggerOnEventEnd(NextStateId)
        end
        return GameMode:TriggerRewardEvent(self.UnitId, CommonConst.RewardReason.Chest, self:GetTransform(), ExtraInfo, CallBack)
    end
    return false
end

function M:CreateRegionData()
    self.TN = self:GetAttr("TN")
    self.RegionData = {
        StateId = self.StateId,
        IsActive = self.IsActive,
        -- IsRare = self.IsRare,
        -- TN = self.TN
    }
end

function M:RecoverSavedData(DataTable)
    if not DataTable then return end
    for i,v in pairs(DataTable) do
        if self[i] ~= nil then
            self[i] = v
        end
        -- if i == "TN" then
        --     self:SetAttr("TN", v)
        -- end
    end
end

-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

-- function M:ReceiveBeginPlay()
-- end

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

return M
