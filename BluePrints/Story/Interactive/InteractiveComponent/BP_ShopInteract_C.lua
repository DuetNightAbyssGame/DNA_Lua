--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_ShopInteract_C
local M = Class("BluePrints.Story.Interactive.InteractiveComponent.BP_HomeInteractiveComponent_C")

function M:IsShowInteractiveComp()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return true
    end

    --- 判断UIUnlockRule是否解锁
    local UIUnlockRuleData = DataMgr.UIUnlockRule[self.SystemName]
    if UIUnlockRuleData and not Avatar:CheckUIUnlocked(UIUnlockRuleData.UIUnlockRuleId) then
        return false
    end

    --- 判断UIUnlockRule的OpenConditionId是否解锁
    if UIUnlockRuleData and not Avatar:CheckSystemUICanOpen(UIUnlockRuleData.UIUnlockRuleId) then
        return false
    end
    
    --- 判断SystemUI的CombatconditionIdList是否解锁
    local SystemUIData = DataMgr.SystemUI[self.SystemName]
    if SystemUIData and not UIUtils.CheckSystemCanOpen(SystemUIData) then
        return false
    end

    return true
end

function M:LoadUI()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    local NpcId = self.Owner.NpcId
    local NpcData = DataMgr.Npc[NpcId]
    assert(NpcData, "Npc信息不存在:"..NpcId)
    UIManager:LoadUINew(self.UIName, NpcData.AddonInteract, nil, nil, self.SystemName)
end

return M
