--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_OnlineTime_Reward_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})
local EnumPlayerSignRewardState = require "Blueprints.UI.WBP.Activity.ActivityUtils".EnumPlayerSignRewardState
local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"

function M:OnListItemObjectSet(Content)
    self.ParentWidget = Content.ParentWidget
    self.ProgressBar:SetPercent(0)
    self.TargetProgress = Content.TargetProgress or 0
    self.Progress = Content.Progress or -1
    self.PreProgress = Content.PreProgress or 0
    self.NextProgress = Content.NextProgress or 0
    self.Text_Num:SetText(self.TargetProgress)
    self.RewardState = Content.RewardState
    self.EventId = Content.EventId
    self.CommonQuestId = Content.CommonQuestId
    self.Btn_Area.OnClicked:Clear()
    self:InitState()
    self.Item_Reward:Init(Content)
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
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, nil, self, true, false, false, nil)
        end
        self.ParentWidget:UpdatePage()
        ActivityReddotHelper.RefreshReddotNode(self.EventId)
    end
    Avatar:CommonQuestActivityGetReward(Cb,self.EventId, self.CommonQuestId)
	AudioManager(self):PlayUISound(self, "event:/ui/activity/gerengonghuizhan_small_btn_click", nil, nil)
end

function M:InitState()
    if self.Progress >= self.TargetProgress then
        local Avatar = GWorld:GetAvatar()
        if not Avatar then return end
        if Avatar.CommonQuestActivity and Avatar.CommonQuestActivity[self.EventId] and Avatar.CommonQuestActivity[self.EventId][self.CommonQuestId] then
            if Avatar.CommonQuestActivity[self.EventId][self.CommonQuestId].RewardsGot then
                self:PlayAnimation(self.Got)
                self.State = "Got"
            else
                self:PlayAnimation(self.Available)
                self.State = "Available"
                self.Btn_Area.OnClicked:Add(self, self.OnReceiveRewardClicked)
            end
        end
    else
        self:PlayAnimation(self.Normal)
        self.State = "Normal"
    end

    -- 设置进度条
    -- 中点即为目标进度
    if self.Progress >= (self.NextProgress + self.TargetProgress)/2 then
        self.ProgressBar:SetPercent(1)
    elseif self.PreProgress == 0 then
        -- 第一个目标
        local Percent = self.Progress / self.TargetProgress / 2
        self.ProgressBar:SetPercent(Percent)
    elseif self.Progress <= (self.PreProgress + self.TargetProgress)/2 then
        self.ProgressBar:SetPercent(0)
    else
        -- 尴尬的进度条，卡在上一个和下一个进度之间
        if self.Progress > self.TargetProgress then
            local Percent = (self.Progress - self.TargetProgress) / (self.NextProgress - self.TargetProgress) + 0.5
            self.ProgressBar:SetPercent(Percent)
        else
            local Percent = (self.Progress - self.PreProgress) / (self.TargetProgress - self.PreProgress) - 0.5
            self.ProgressBar:SetPercent(Percent)
        end
    end
end

function M:BP_GetDesiredFocusTarget()
    return self.Item_Reward
end

return M