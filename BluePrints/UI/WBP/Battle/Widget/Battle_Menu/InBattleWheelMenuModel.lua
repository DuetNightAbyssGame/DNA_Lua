
--- @class InBattleWheelMenuModel :Model
local M = Class({"BluePrints.Common.MVC.Model", "BluePrints.UI.BP_EMUserWidgetUtils_C"})

-- 道具槽状态
local BattlePropSlotState = {Default = "Default", Using = "Using"}
-- 限制最多同时使用一个道具的类型
local LimitMaxOneUseResourceType = {GestureItem = true, MountItem = true, BattleItem = true}

function M:Init()
    M.Super.Init(self)
    self.BattlePropSlotState = BattlePropSlotState
    self.LimitMaxOneUseResourceType = LimitMaxOneUseResourceType
    self.SlotState = {}
    self.bInit = true
    self:InitEvents()
end

function M:InitEvents()
    self:AddDispatcher(EventID.OnMainCharacterBeginPlay, self, self.OnMainCharacterBeginPlay)
end

function M:OnMainCharacterBeginPlay()
    DebugPrint("lgc@InBattleWheelMenuModel:OnMainCharacterBeginPlay")
    self:Destory()
end

function M:UpdateInBattleWheelPropUseData(UseResourceId, ForceSetUsing)
    DebugPrint("lgc@InBattleWheelMenuModel:UpdateInBattleWheelPropUseData", UseResourceId, ForceSetUsing)
    if not self.bInit then self:Init() end
    local Avatar = GWorld:GetAvatar()
    local TargetState = nil
    if self.SlotState[UseResourceId] == BattlePropSlotState.Using then
        TargetState = BattlePropSlotState.Default
    elseif self.SlotState[UseResourceId] == BattlePropSlotState.Default then
        TargetState = BattlePropSlotState.Using
    else
        TargetState = BattlePropSlotState.Default
    end
    if ForceSetUsing == true then
        TargetState = BattlePropSlotState.Using
    elseif ForceSetUsing == false then
        TargetState = BattlePropSlotState.Default
    end
    if self.SlotState[UseResourceId] == BattlePropSlotState.Default then
        local CurrentResourceType = DataMgr.Resource[UseResourceId].ResourceSType
        if LimitMaxOneUseResourceType[CurrentResourceType] then
            for ResourceId, SlotState in pairs(self.SlotState) do
                if ResourceId ~= UseResourceId and self.SlotState[ResourceId] ~= BattlePropSlotState.Default then
                    local OtherResource = DataMgr.Resource[ResourceId]
                    if OtherResource and OtherResource.ResourceSType == CurrentResourceType then
                        self.SlotState[ResourceId] = BattlePropSlotState.Default
                    end
                end
            end
        end
    end
    self.SlotState[UseResourceId] = TargetState
end

function M:Destory()
    self.bInit = false
    self.SlotState = nil
    self:RemoveEvents()
    M.Super.Destory(self)
end

function M:RemoveEvents()
    self:RemoveDispatcher(EventID.OnMainCharacterBeginPlay, self, self.OnMainCharacterBeginPlay)
end

return M
