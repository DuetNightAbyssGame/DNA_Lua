--
-- DESCRIPTION
-- 累充活动SP奖励Item （PC、移动端公用）
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local EnumPlayerSignRewardState = require "Blueprints.UI.WBP.Activity.ActivityUtils".EnumPlayerSignRewardState
local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"

local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:FillWithData(Content)
    self.Content = Content
    self.EventId = Content.EventId
    self.RewardId = Content.RewardId
    self.Index = Content.Index
    self.PrevPoint = Content.PrevPoint
    self.CurrPoint = Content.CurrPoint
    self.NextPoint = Content.NextPoint
    self.ParentWidget = Content.ParentWidget
    self.StuffClickCallback = Content.StuffClickCallback

    self:RefreshDynamic()
    self:UpdateView()

    -- 一些点击相关
    self:RefreshNavigation()
    self:UnBindButtonPerformances()
    self:BindButtonPerformances()
end

function M:RefreshDynamic()
    local PlayerAvatar = GWorld:GetAvatar()
    if not PlayerAvatar or not PlayerAvatar.AccumulateRecharge then return end
    
    local ActivityData = PlayerAvatar.AccumulateRecharge[self.EventId]
    if not ActivityData then return end

    local currentTotalPoint = ActivityData.Score or 0
    local rewardGotList = ActivityData.RewardGot

    self:UpdateProgress(currentTotalPoint)
    self:RefreshState(currentTotalPoint, rewardGotList)
end

function M:GetRewardStuffIndex()
    return self.Index
end

function M:UpdateView()
    local RewardInfo = DataMgr.Reward[self.RewardId]

    if RewardInfo then
        local RewardIds = RewardInfo.Id or {}
        local RewardCounts = RewardInfo.Count or {}
        local RewardTypes = RewardInfo.Type or {}

        for i = 1, #RewardIds do
            local ItemId = RewardIds[i]
            local Count = RewardUtils:GetCount(RewardCounts[i])
            local Icon = ItemUtils.GetItemIconPath(ItemId, RewardTypes[i])
            local Rarity = ItemUtils.GetItemRarity(ItemId, RewardTypes[i])
            local ItemType = RewardTypes[i]
            local RewardObject = {}
            RewardObject.ParentWidget = self
            RewardObject.Id = ItemId
            RewardObject.ItemType = ItemType
            RewardObject.Rarity = Rarity or 1
            RewardObject.Icon = Icon
            RewardObject.Count = Count
            RewardObject.IsShowDetails = true
            RewardObject.HandleMouseDown = true
            RewardObject.bCanGet = self.CurrentState == EnumPlayerSignRewardState.SignedNotRecv
            RewardObject.CanGetStyle = "Gold"
            -- RewardObject.MenuPlacement = EMenuPlacement.MenuPlacement_AboveAnchor
            if i == 1 then
                self.Item_Reward_1:InitData(RewardObject)
                self.Item_Reward_1:InitCompView()
            elseif i == 2 then
                self.Item_Reward_2:InitData(RewardObject)
                self.Item_Reward_2:InitCompView()
            end
        end
    end
    self.Text_c:SetText(self.CurrPoint)
end

function M:UpdateProgress(currentTotalPoint)
    local cur = currentTotalPoint
    local p0 = self.PrevPoint or 0
    local p1 = self.CurrPoint or 0

    local finalPercent = 0
    if cur < p1 then
        finalPercent = (cur - (p0 + (p1 - p0) / 2)) / ((p1 - p0) / 2)
    elseif cur >= p1 then
        finalPercent = 1.0
    end

    if self.ProgressBar then
        self.ProgressBar:SetPercent(math.max(0, math.min(1, finalPercent)))
    end
end

function M:RefreshState(currentTotalPoint, rewardGotList)
    local isReached = currentTotalPoint >= (self.CurrPoint or 0)
    local isClaimed = false
    if rewardGotList then
        for gotIndex, _ in pairs(rewardGotList) do
            if gotIndex == self.Index then
                isClaimed = true
                break
            end
        end
    end

    local state = EnumPlayerSignRewardState.NotSign
    if not isReached then
        state = EnumPlayerSignRewardState.NotSign
    elseif not isClaimed then
        state = EnumPlayerSignRewardState.SignedNotRecv
    else
        state = EnumPlayerSignRewardState.Completed
    end
    
    self.CurrentState = state

    self:StopAllAnimations()
    if state == EnumPlayerSignRewardState.NotSign then
        self:PlayAnimation(self.Normal)
    elseif state == EnumPlayerSignRewardState.SignedNotRecv then
        self:PlayAnimation(self.Available)
    elseif state == EnumPlayerSignRewardState.Completed then
        self:PlayAnimation(self.Got)
    end

    local visibility = (state == EnumPlayerSignRewardState.SignedNotRecv) 
                       and UIConst.VisibilityOp["Visible"] 
                       or UIConst.VisibilityOp["SelfHitTestInvisible"]
    self.Btn_Area:SetVisibility(visibility)
end

function M:RefreshNavigation()
    self.Item_Reward_1:SetNavigationRuleCustom(EUINavigation.Right, {self, function()
        return self.Item_Reward_2
    end})
    self.Item_Reward_2:SetNavigationRuleCustom(EUINavigation.Left, {self, function()
        return self.Item_Reward_1
    end})
end

function M:BindButtonPerformances()
    self.Btn_Area.OnClicked:Add(self, self.OnBtnClicked)
end

function M:UnBindButtonPerformances()
    self.Btn_Area.OnClicked:Clear()
end

function M:OnStuffDetailViewOpenChanged(IsOpened)
    if (type(self.StuffClickCallback) == "function") then
        self.StuffClickCallback(self.ParentWidget, IsOpened, self.Index)
    end
end

function M:OnBtnClicked()
    if self.CurrentState == EnumPlayerSignRewardState.SignedNotRecv then
        local PlayerAvatar = GWorld:GetAvatar()
        if not PlayerAvatar then
            return
        end
        PlayerAvatar:GetCumulativeRechargeReward(function(Ret, Rewards)
            if not ErrorCode:Check(Ret) then
                return
            end
			ActivityUtils.TrySubActivityReddotCommon("Red", self.EventId)
            if self.ParentWidget and self.ParentWidget.RefreshPageDynamicView then
                self.ParentWidget:RefreshPageDynamicView()
            else
                self:RefreshDynamic()
            end
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, Rewards.IsSpPopup)
        end, self.Content.EventId, self.Index)
        AudioManager(self):PlayUISound(self, "event:/ui/activity/gerengonghuizhan_small_btn_click", nil, nil)
    end
end

function M:HideBtn(bHide)
    if (bHide) then
        self.Btn_Item:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    else
        self.Btn_Item:SetVisibility(UIConst.VisibilityOp["Visible"])
    end
end

function M:BP_GetDesiredFocusTarget()
    if self.CurrentState == EnumPlayerSignRewardState.SignedNotRecv then
        return self.Btn_Area
    else
        return self.Item_Reward_1
    end
end

return M