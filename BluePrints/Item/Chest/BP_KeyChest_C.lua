--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "Unlua"
---@type BP_KeyChest_C
local M = Class("BluePrints.Item.Chest.BP_ChestBase_C")

function M:AuthorityInitInfo(Info)
    M.Super.AuthorityInitInfo(self,Info)
    self.UsePlayerId = 0
    EventManager:AddEvent(EventID.OnResourceDeductSuccess,self,self.OnKeyDeductSuccess)
end

function M:OpenMechanism(PlayerId)
    print(_G.LogTag, "LXZ OpenMechanism", self.OpenState)
    if self.OpenState ~= false then
        return
    end
    local Avatar = GWorld:GetAvatar()
    local GameMode = GWorld.GameInstance:GetCurrentGameMode()
    if Avatar and GameMode then
        self:CreateKeyList()
        self.UsePlayerId = PlayerId
        ------ 明确 打开宝箱扣除道具 RPC
        local RewardIds, ExtraInfo = self:BuildRewardInfo(PlayerId)
        local RewardPosition = self:GetTransform()
        if self.RewardPosition then
            RewardPosition = self.RewardPosition:K2_GetComponentToWorld()
        end
        ExtraInfo.CommonUIConfirmID = self.ChestInteractiveComponent.CommonUIConfirmID
        print(_G.LogTag, "LXZ OpenMechanism")
        GameMode:TriggerRewardEvent(self.UnitId, CommonConst.RewardReason.Chest, RewardPosition, ExtraInfo, function (Rewards, DropRegionDatas)
            EventManager:FireEvent(EventID.OnResourceDeductSuccess, "DeductSuccess", CommonConst.RewardReason.Chest, Rewards, ExtraInfo, RewardPosition, DropRegionDatas)
        end)
    end
end

function M:CreateKeyList()
    self.KeyList = {}
    local InteractiveCondition = self.ChestInteractiveComponent.InteractiveParam.InteractiveCondition
    local ConditionMap = ConditionUtils:GetConditionContent(InteractiveCondition)
    for i, ParamTable in pairs(ConditionMap) do
        if i == "HaveResource" then
            for Idx, Table in pairs(ParamTable) do
                self.KeyList[Table[1]] = Table[2]
            end
        end
    end
end

function M:OnKeyDeductSuccess(Reason, Rewards, ExtraInfo, RewardPosition, RewardDropDatas)
    print(_G.LogTag, "LXZ OnKeyDeductSuccess", self.UsePlayerId)
    if self.UsePlayerId == 0 then
        return
    end
    --涉及到扣除资源，防止扣了钥匙就掉线，确保扣除回调到了再生成奖励
    local Avatar = GWorld:GetAvatar()
    local GameMode = GWorld.GameInstance:GetCurrentGameMode()
    if GameMode and Rewards and Avatar then
        Avatar:HandleRewardInRegion(GameMode, Rewards, RewardPosition, Reason, ExtraInfo, RewardDropDatas)
    end

    self:TriggerSource(0)
    print(_G.LogTag, "LXZ OnKeyDeductSuccess2222", self.UsePlayerId)
    self:ClientPlayAnim(self.UsePlayerId, 0, self.Eid)
    -- 等价于self.OpenState = true
    self:UpdateRegionData("OpenState", true)
    self:DeactiveGuide()

    --根据需求调用，有些机关没有结束交互的流程
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    Player:DeInteractiveMechanism(self.Eid, Player.Eid, nil, true, 0, true)
    AudioManager(self):PlayFMODSound(self, nil, "event:/sfx/common/scene/magic_box")
    EventManager:RemoveEvent(EventID.OnResourceDeductSuccess, self)
    self.UsePlayerId = 0

    if self.NeedDestroy then
        self:AddTimer(3, self.PlayDestroyEffect, false, 0)
    end
end

return M
