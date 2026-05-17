--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local CommonConst = require "CommonConst"

local BP_MechanismBase_C = Class({
    "BluePrints.Item.BP_CombatItemBase_C",
})

function BP_MechanismBase_C:AuthorityInitInfo(Info)
    BP_MechanismBase_C.Super.AuthorityInitInfo(self,Info)
    self:SetRewardID()
end

-- function BP_MechanismBase_C:CommonInitInfo(Info)
--     if self.DefaultInteractiveComponent then
--         self.DefaultInteractiveComponent.bCanUsed = false
--         self.DefaultInteractiveComponent.IsDefault = true
--         self.InteractiveComponents:Clear()
--         self.InteractiveComponents:Add(self.DefaultInteractiveComponent)
--         self.ChestInteractiveComponent = self.DefaultInteractiveComponent
--     end
--     BP_MechanismBase_C.Super.CommonInitInfo(self,Info)
-- end

------------------------------------------- 指引 -----------------------------------------------
-- function BP_MechanismBase_C:InitGuideInfo(Info)
--     local GameState = UE4.UGameplayStatics.GetGameState(self)
--     if GameState:CheckNeedGuide(self.UnitId, self.UnitType, self) then
--         GameState:AddGuideEid(self.Eid)
--     end
-- end

-- 放到 GameState:CheckNeedGuide 中去判断
function BP_MechanismBase_C:CustomAddGuideCondition()
    return not self.OpenState
end
-------------------------------------------- 指引end -----------------------------------------------


function BP_MechanismBase_C:BuildRewardInfo(PlayerId)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not GameMode then return end
    local RewardIds = GameMode:GetDropRule(self.UnitId)
    local ExtraInfo = {
        UniqueSign = self.Eid,
        SourceEid = PlayerId,
        ParentEid = self.Eid,
        bRare = false
    }
    if GameMode:IsInRegion() then
        ExtraInfo.WorldRegionEid = self.WorldRegionEid
        ExtraInfo.RegionDataType = self.RegionDataType
        local RewardPosition = self:GetTransform()
        if self.RewardPosition then
            RewardPosition = self.RewardPosition:K2_GetComponentToWorld()
        end
       
    end
    -- ExtraInfo.
    return RewardIds, ExtraInfo
end

function BP_MechanismBase_C:SetRewardID()
    -- local Data = DataMgr.Mechanism[self.UnitId]
    -- local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    -- if Data and Data["RewardId"] then
    --     self.RewardID = Data["RewardId"]
    --     if self.RewardID then
    --         GameMode:InitDropRule(self.UnitId, self.RewardID)
    --     end
    -- end
end

function BP_MechanismBase_C:CreateReward(PlayerId)
    print(_G.LogTag,"LXZ CheckAutoCreateReward CreateReward FALSE", self:CheckAutoCreateReward())
    if not self:CheckAutoCreateReward() then
        print(_G.LogTag,"LXZ CheckAutoCreateReward FALSE")
        return
    end
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then
        local RewardPosition = self:GetTransform()
        if self.RewardPosition then
            RewardPosition = self.RewardPosition:K2_GetComponentToWorld()
        end
        local RewardIds, ExtraInfo = self:BuildRewardInfo(PlayerId)
        -- GameMode:TriggerGenerateReward(RewardIds, CommonConst.RewardReason.Chest, RewardPosition, ExtraInfo)
        GameMode:TriggerRewardEvent(self.UnitId, CommonConst.RewardReason.Chest, RewardPosition, ExtraInfo)
    end
end

function BP_MechanismBase_C:StateCreateReward(PlayerId, NextStateId)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then
        local RewardPosition = self:GetTransform()
        if self.RewardPosition then
            RewardPosition = self.RewardPosition:K2_GetComponentToWorld()
        end
        local RewardIds, ExtraInfo = self:BuildRewardInfo(PlayerId)
        -- GameMode:TriggerGenerateReward(RewardIds, CommonConst.RewardReason.Chest, RewardPosition, ExtraInfo)
        local function CallBack()
            self.CombatStateChangeComponent:TriggerOnEventEnd(NextStateId)
        end
        return GameMode:TriggerRewardEvent(self.UnitId, CommonConst.RewardReason.Chest, RewardPosition, ExtraInfo, CallBack)
    end
    return false
end

function BP_MechanismBase_C:OpenMechanism(PlayerId)
    print(_G.LogTag,"Error: LXZ OpenMechanism not Define in ", self:GetName())
end

function BP_MechanismBase_C:CreateRegionData()
    self.RegionData = {
        CanOpen = self.CanOpen,
        OpenState = self.OpenState,
        StateId = self.StateId,
        IsActive = self.IsActive,
    }
    print(_G.LogTag,"LXZ CreateRegionData", self:GetName(), self.CanOpen, self.StateId)
    local Data = {["CanOpen"] = self.CanOpen,
                 ["OpenState"] = self.OpenState,
                 ["StateId"] = self.StateId,
                 ["IsActive"] = self.IsActive}
    self:UpdateRegionDataByTable(Data)
end

------------------------------空函数占位，防止子类未定义而出错--------------------------
--持续交互时因外力强制中断
function BP_MechanismBase_C:ForceCloseMechanism(PlayerId, IsSuccess)
    self:CloseMechanism(PlayerId, IsSuccess)
end

function BP_MechanismBase_C:CloseMechanism(PlayerId, IsSuccess)
    self:BroadcastCloseMechanism(PlayerId)
end

function BP_MechanismBase_C:BroadcastCloseMechanism_Lua(PlayerId)
end

function BP_MechanismBase_C:BPRecoverSnapShot()
end

function BP_MechanismBase_C:GetCanOpen(PlayerEid)
    
end

function BP_MechanismBase_C:OpenUI(PlayerEid)
    --打开一个UI，在UI关闭时切换至下个状态
end

function BP_MechanismBase_C:EndInteractive(Player)
    self.ChestInteractiveComponent:EndInteractive(Player)
end
------------------------------空函数占位，防止子类未定义而出错 end--------------------------

return BP_MechanismBase_C
