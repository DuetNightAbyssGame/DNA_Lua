--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_OnlineTime_Reward_Sp_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})
local EnumPlayerSignRewardState = require "Blueprints.UI.WBP.Activity.ActivityUtils".EnumPlayerSignRewardState
local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"

function M:Construct()
end

function M:Init(RewardList, ParentWidget)
    self.ParentWidget = ParentWidget
    self.RewardList = {}
    self.RewardList = RewardList
    self.Progress = self.ParentWidget.Progress or 0
    self.EventId = self.ParentWidget.EventId
    self.TargetProgress = RewardList[1].TargetProgress or 0
    self.PreProgress = RewardList[1].PreProgress or 0
    self.NextProgress = 0 -- 默认0
    self.CommonQuestId = RewardList[1].QuestId
    self.Text_Num:SetText(self.TargetProgress)
    self:InitState()
    local Index = 1
    for _, ItemInfo in pairs(self.RewardList) do
        if Index == 3 then break end
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.Id = ItemInfo.Id
        Content.Icon = ItemUtils.GetItemIconPath(ItemInfo.Id, ItemInfo.Type)
        -- Content.ParentWidget = self
        Content.ItemType = ItemInfo.Type
        Content.Count = ItemInfo.ItemCount
        Content.Rarity = ItemInfo.Rarity or 1
        Content.IsShowDetails = true
        Content.NotInteractive = false
        Content.bCanGet = self.State == "Available"
        Content.bHasGot = self.State == "Got"
        -- Content.UIName = "Acitivity"
        -- Content.EventId = self.EventId
        -- Content.CommonQuestId = self.CommonQuestId
        -- Content.Progress = self.Progress
        -- Content.TargetProgress = ItemInfo.TargetProgress
        -- Content.OnMenuOpenChangedEvents = 
        -- {
        --     Obj = self,
        --     Callback = self.ItemMenuAnchorChanged
        -- }
        Content.HandleMouseDown = true
        self["Item_Reward_"..Index]:Init(Content)
        Index = Index + 1
    end

    self:RefreshNavigation()
end

function M:RefreshNavigation()
    self.Item_Reward_1:SetNavigationRuleCustom(EUINavigation.Right, {self, function()
        return self.Item_Reward_2
    end})
    self.Item_Reward_2:SetNavigationRuleCustom(EUINavigation.Left, {self, function()
        return self.Item_Reward_1
    end})
end

function M:InitState()
    self.Btn_Area.OnClicked:Clear()
    if self.Progress >= self.TargetProgress then
        local Avatar = GWorld:GetAvatar()
        if not Avatar then return end
        if Avatar.CommonQuestActivity and Avatar.CommonQuestActivity[self.EventId] and Avatar.CommonQuestActivity[self.EventId][self.CommonQuestId] then
            if Avatar.CommonQuestActivity[self.EventId][self.CommonQuestId].RewardsGot then
                self:PlayAnimation(self.Got)
                self.State = "Got"
                return
            end
        end
        self:PlayAnimation(self.Available)
        self.State = "Available"
        self.Btn_Area.OnClicked:Add(self, self.OnReceiveRewardClicked)
    else
        self:PlayAnimation(self.Normal)
        self.State = "Normal"
    end

    -- 设置进度条
    -- 中点即为目标进度
    if self.Progress >= self.TargetProgress then
        self.ProgressBar:SetPercent(1)
    elseif self.Progress <= (self.PreProgress + self.TargetProgress)/2 then
        self.ProgressBar:SetPercent(0)
    else
        local Percent = (self.Progress - self.PreProgress) / (self.TargetProgress - self.PreProgress) - 0.5
        self.ProgressBar:SetPercent(Percent)
    end
end

function M:OnReceiveRewardClicked()
    -- 领取奖励
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local Cb =  function(Ret, Rewards)
        if Ret and Ret == 0 then
            local RewardList = {}
            local AllRewardType = DataMgr.RewardType
            for Type, _ in pairs(AllRewardType) do
                local CurRewards = Rewards[Type.."s"]
                if not IsEmptyTable(CurRewards) then
                    for Id, Count in pairs(CurRewards) do
                        local ItemId = Id
                        local ItemCount = Count["1"]
                        local ItemRarity = ItemUtils.GetItemRarity(ItemId, Type)
                        local ItemType = Type
                        local RewardContent = {
                            ItemType = ItemType,
                            ItemId = ItemId,
                            Count = ItemCount,
                            Rarity = ItemRarity,
                        }
                        table.insert(RewardList, RewardContent)
                    end
                end
            end
            self.ParentWidget:UpdatePage()
            ActivityReddotHelper.RefreshReddotNode(self.EventId)
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, nil, self, true, false, false, nil)
        end
    end
    Avatar:CommonQuestActivityGetReward(Cb,self.EventId, self.CommonQuestId)
end

function M:BP_GetDesiredFocusTarget()
    return self.Item_Reward_1
end


return M
