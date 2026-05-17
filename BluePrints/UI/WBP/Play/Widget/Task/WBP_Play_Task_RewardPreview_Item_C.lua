--
-- DESCRIPTION
-- 活动系统新手任务奖励预览View （PC、移动端公用）
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local M = Class("BluePrints.UI.BP_UIState_C")

function M:OnListItemObjectSet(Content)
    self.Parent = Content.Parent
    self.Index = Content.Index
    self.PhaseId = Content.PhaseId
    self.RewardPreview = Content.RewardPreview
    self:InitPreRewardView()
end

function M:InitPreRewardView()
    self.Text_TitleNum:SetText(string.format(GText("UI_GameEvent_StarterQuest_Phase"), self.Index))
    local RewardContentList = {}
    local function FillWithRewardData(RewardInfo)
        if RewardInfo then
            local RewardObject = {}
            RewardObject.Id = RewardInfo.Id
            RewardObject.Icon = ItemUtils.GetItemIconPath(RewardInfo.Id, RewardInfo.Type)
            RewardObject.ParentWidget = self
            RewardObject.ItemType = RewardInfo.Type
            RewardObject.Rarity = RewardInfo.Rarity or 1
            RewardObject.IsShowDetails = true
            RewardObject.UIName = "Play_Task_RewardPreview"
            RewardObject.HandleMouseDown = true
            if RewardInfo.Quantity then
                if #RewardInfo.Quantity > 1 then
                    RewardObject.Count = RewardInfo.Quantity[1]
                    RewardObject.MaxCount = RewardInfo.Quantity[2]
                else
                    RewardObject.Count = RewardInfo.Quantity[1]
                end
            end
            table.insert(RewardContentList, RewardObject)
        end
    end
    local PreViewReward = self.RewardPreview or DataMgr.CommonQuestPhase[self.PhaseId].RewardPreview
    local AllRewardList = RewardUtils:GetRewardViewInfoById(PreViewReward)

    -- table.sort(AllRewardList,function(A, B)
    --     if A.Rarity == B.Rarity then
    --         if TypeSort[A.Type] and TypeSort[B.Type] then
    --             if TypeSort[A.Type] == TypeSort[B.Type] then
    --                 return A.Id < B.Id
    --             end
    --             return TypeSort[A.Type] < TypeSort[B.Type]
    --         end
    --         return A.Id < B.Id
    --     end
    --     return A.Rarity > B.Rarity
    -- end)

    if (type(AllRewardList) == "table") then
        for i, v in ipairs(AllRewardList) do
            FillWithRewardData(v)
        end
    else
        FillWithRewardData(AllRewardList)
    end

    if (#RewardContentList == 0) then
        self.Wrap_RewardBox:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    else
        self.Wrap_RewardBox:ClearChildren()
        for Index, v in ipairs(RewardContentList) do
            local Widget = UIManager(self):_CreateWidgetNew("ComItemUniversalS")
            if Widget then 
                self.Wrap_RewardBox:AddChild(Widget)
                Widget:Init(v)
                Widget:BindEvents(self,{
                    OnMenuOpenChanged = self.OnStuffMenuOpenChanged,
                })
            end
        end 
        self.Wrap_RewardBox:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    end
end
function M:OnStuffMenuOpenChanged(bIsOpen)
    if (UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad) then
        return
    end
    if (bIsOpen) then
        self.Parent:UpdatKeyDisplay("RewardWidget")
    else
        self.Parent:UpdatKeyDisplay("SelfWidget")
    end
end
function M:OnFocusReceived(MyGeometry, InFocusEvent)
    local FocusWidget = self.Wrap_RewardBox:GetChildAt(0)
    if FocusWidget then
        FocusWidget:SetFocus()
        return UIUtils.Handle
    end
    return UIUtils.Unhandled
end
return M