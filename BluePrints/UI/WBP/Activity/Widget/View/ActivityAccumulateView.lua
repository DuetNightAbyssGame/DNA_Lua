--
-- DESCRIPTION
-- 活动系统累计目标View （PC、移动端公用）
-- @COMPANY **
-- @AUTHOR **AYF
-- @DATE ${date} ${time}
--

require "UnLua"
-- local ActivityUtils = require "BluePrints.UI.WBP.Activity.ActivityUtils"
-- local ActivityCommon = require "BluePrints.UI.WBP.Activity.ActivityCommon"
-- local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"

local M = Class()
local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"
local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"

function M:PlayFadeIn()
    -- 播放入场动画
    self:PlayAnimation(self.In)
end

function M:PlayFadeOut(IsRemoveFromParent)
    -- 播放退场动画
    self:PlayAnimation(self.Out)
    if (IsRemoveFromParent) then
        self:BindToAnimationFinished(self.Out, {self, self.RemoveFromParent})
    end
end

function M:HidePage(IsNeedPlayOutAnim)
    if (IsNeedPlayOutAnim) then
        self:PlayFadeOut()
    end
    self:SetVisibility(UIConst.VisibilityOp["Collapsed"])
end

function M:ShowPage(IsNeedPlayInAnim)
    if (IsNeedPlayInAnim) then
        self:PlayFadeIn()
    end
    self:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
end

function M:IsPageInVisible()
    return self:IsVisible()
end

function M:CalcCurrentMaxProgress(MaxProgressType)
    local TargetEventInfo = DataMgr.AccumulateTargetEvent[self.EventId]
    local EventInfo = DataMgr.EventMain[self.EventId]
    if not TargetEventInfo or not EventInfo then
        return 0
    end

    local StartTime = EventInfo.EventStartTime - 5 * 60 * 60
    local CurrentTime = TimeUtils.NowTime()
    local LimitList = TargetEventInfo.MaxProgressNum
    if type(LimitList) ~= "table" or #LimitList == 0 then
        return 0
    end

    local PeriodSeconds
    if MaxProgressType == "Week" then
        PeriodSeconds = 7 * 24 * 60 * 60
    else
        PeriodSeconds = 24 * 60 * 60
    end

    -- 当前是第几个周期（从 1 开始）
    local Delta = (CurrentTime or 0) - (StartTime or 0)
    if Delta < 0 then Delta = 0 end
    local PeriodIndex = math.floor(Delta / PeriodSeconds) + 1

    local MaxProgress = 0

    -- 若活动周期超出配置长度，取最后一个限制值
    if PeriodIndex > #LimitList then
        MaxProgress = LimitList[#LimitList]
    else
        MaxProgress = LimitList[PeriodIndex]
    end

    return MaxProgress
end

function M:InitRewards()
    if not self.QuestPhaseId then return end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    self.RewardList = {}
    self.List_Reward:ClearListItems()
    self.List_Reward:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

    -- 初始化普通奖励
    local CommonQuestDetail = DataMgr.CommonQuestDetail
    local RewardsList = {}
    for i, v in pairs(CommonQuestDetail) do
        if v.EventId == self.EventId and v.QuestPhaseId == self.QuestPhaseId then
            table.insert(RewardsList, v)
        end
    end

    table.sort(RewardsList, function(A, B)
        return A.Target < B.Target
    end)

    for Index = 1, #RewardsList - 1  do
        local QuestReward = RewardsList[Index] and RewardsList[Index].QuestReward
        local RewardId = QuestReward[1]
        local Rewards = DataMgr.Reward[RewardId]
        if Rewards then
            local RewardIds = Rewards.Id
            local RewardCounts = Rewards.Count
            local RewardTypes = Rewards.Type
            for i = 1, #RewardIds do
                local ItemId = RewardIds[i]
                local Count = RewardUtils:GetCount(RewardCounts[i])
                local Icon = ItemUtils.GetItemIcon(ItemId, RewardTypes[i])
                local Rarity = ItemUtils.GetItemRarity(ItemId, RewardTypes[i])
                local ItemType = RewardTypes[i]
                local RewardContent = {
                    Id = ItemId,
                    Type = ItemType,
                    ItemCount = Count,
                    Icon = Icon,
                    Rarity = Rarity,
                    TargetProgress = RewardsList[Index].Target,
                    PreProgress = Index == 1 and 0 or RewardsList[Index -1].Target,
                    NextProgress = RewardsList[Index + 1] and RewardsList[Index + 1].Target or 0,
                    Index = Index,
                    QuestId = RewardsList[Index].QuestId,
                    QuestPhaseId = RewardsList[Index].QuestPhaseId,
                }
                table.insert(self.RewardList, RewardContent)
                break -- 只显示第一个奖励物品
            end
        end
    end

    for _, ItemInfo in pairs(self.RewardList) do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.Id = ItemInfo.Id
        Content.Icon = ItemUtils.GetItemIconPath(ItemInfo.Id, ItemInfo.Type)
        Content.ParentWidget = self
        Content.ItemType = ItemInfo.Type
        Content.Count = ItemInfo.ItemCount
        Content.Rarity = ItemInfo.Rarity or 1
        Content.IsShowDetails = true
        Content.Progress = self.Progress
        Content.TargetProgress = ItemInfo.TargetProgress
        Content.PreProgress = ItemInfo.PreProgress
        Content.NextProgress = ItemInfo.NextProgress
        Content.NotInteractive = false
        -- Content.UIName = "Acitivity"
        Content.IsShowDetails = true
        Content.EventId = self.EventId
        Content.QuestId = ItemInfo.QuestId
        Content.QuestPhaseId = ItemInfo.QuestPhaseId
        Content.CommonQuestId = RewardsList[ItemInfo.Index].QuestId
        Content.OnMenuOpenChangedEvents = 
        {
            Obj = self,
            Callback = self.ItemMenuAnchorChanged
        }
        Content.Index = ItemInfo.Index
        Content.HandleMouseDown = true
        Content.bHasGot = Avatar.CommonQuestActivity[self.EventId] and Avatar.CommonQuestActivity[self.EventId][RewardsList[ItemInfo.Index].QuestId] and
            Avatar.CommonQuestActivity[self.EventId][RewardsList[ItemInfo.Index].QuestId].RewardsGot
        Content.bCanGet = not Content.bHasGot and self.Progress >= ItemInfo.TargetProgress
        self.List_Reward:AddItem(Content)

        if ItemInfo.TargetProgress <= self.Progress then
            self.ScrollIndex = math.max(self.ScrollIndex or 0, ItemInfo.Index - 1)
        end
    end

    -- 初始化最终奖励
    local SPReward = RewardsList[#RewardsList] and  RewardsList[#RewardsList].QuestReward
    local SpRewardId = SPReward[1]
    local SpRewards = DataMgr.Reward[SpRewardId]
    if SpRewards then
        self.SPRewardList = {}
        local RewardIds = SpRewards.Id
        local RewardCounts = SpRewards.Count
        local RewardTypes = SpRewards.Type
        for Index = 1, #RewardIds do
            local ItemId = RewardIds[Index]
            local Count = RewardUtils:GetCount(RewardCounts[Index])
            local Icon = ItemUtils.GetItemIcon(ItemId, RewardTypes[Index])
            local Rarity = ItemUtils.GetItemRarity(ItemId, RewardTypes[Index])
            local ItemType = RewardTypes[Index]
            local RewardContent = {
                Id = ItemId,
                Type = ItemType,
                ItemCount = Count,
                Icon = Icon,
                Rarity = Rarity,
                TargetProgress = RewardsList[#RewardsList].Target,
                PreProgress = RewardsList[#RewardsList - 1] and RewardsList[#RewardsList - 1].Target or 0,
                NextProgress = 0,
                QuestId = RewardsList[#RewardsList].QuestId,
                Index = #self.RewardList + 1,
            }
            table.insert(self.SPRewardList, RewardContent)
        end
    end
    self.Reward_Sp:Init(self.SPRewardList, self, self.Progress)

    self:AddDelayFrameFunc(function()
        self.List_Reward:ScrollIndexIntoView(self.ScrollIndex or 0)
    end, 1)
end

function M:InitUIInfo()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    self.FocusWidgetName = "CheckRewardView"
    local TargetDes = DataMgr.AccumulateTargetEvent[self.EventId].TargetDes
    self.Text_Time:SetText(GText(TargetDes))
    local MaxProgressType = DataMgr.AccumulateTargetEvent[self.EventId].MaxProgressType
    self.Num_Time:SetText(self.Progress)
    if not MaxProgressType then
        self.Text_Limit:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Num_Limit:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Num_Now:SetVisibility(UE4.ESlateVisibility.Collapsed)
    elseif MaxProgressType == "Day" then
        self.Text_Limit:SetText(GText("UI_Event_DailyTargetMaximum"))
        local CurrentLimit = self:CalcCurrentMaxProgress(MaxProgressType)
        self.Num_Limit:SetText(CurrentLimit)
        self.Num_Now:SetText(Avatar.CommonQuestBases[self.EventId].AccumulateTarget)
    elseif MaxProgressType == "Week" then
        self.Text_Limit:SetText(GText("UI_Event_WeeklyTargetMaximum"))
        local CurrentLimit = self:CalcCurrentMaxProgress(MaxProgressType)
        self.Num_Limit:SetText(CurrentLimit)
        self.Num_Now:SetText(Avatar.CommonQuestBases[self.EventId].AccumulateTarget)
    end
    local EventInfo = DataMgr.EventMain[self.EventId]
    self.Title.Text_Title:SetText(GText(EventInfo.EventName))
    self.Text_ActivityDesc:SetText(GText(EventInfo.EventDes))
    self.Text_ActivityDesc_White:SetText(GText(EventInfo.EventDes))

    self.ActivityEndTime = EventInfo.EventEndTime
    self:InitTimeInfo()

    self:RefreshBtnGot()

    if self:IsPrerequisiteSatisfied() then
        self.WS_Btn:SetActiveWidgetIndex(0)
        self.Btn_Goto.Text_Button:SetText(GText("UI_Event_AccumulateTargetEvent_Jump"))
    else
        self.WS_Btn:SetActiveWidgetIndex(1)
        self.Com_Hint.WidgetSwitcher_State:SetActiveWidgetIndex(2)
        local PageConfigData = self:GetPageConfigData()
        self.Com_Hint.Text_Hint_Locked:SetText(GText(PageConfigData.JumpUnlockTips))
        self.Btn_Goto.Button_Area.OnClicked:Clear()
    end
end

function M:InitTimeInfo()
    if self.ActivityEndTime ~= nil and self.Activity_Time then
        ActivityUtils.RefreshLeftTime(self, self.Activity_Time)
        self:AddTimer(1.0, ActivityUtils.RefreshLeftTime, true, 0, "RefreshLeftTime", true, self.Activity_Time)
    else
        ActivityUtils.SetLeftTimeView(self.Activity_Time, true)
    end
end

function M:GetAllReward()
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
        self:UpdatePage()
        self.Btn_Reward:SetVisibility(UE4.ESlateVisibility.Collapsed)
        ActivityReddotHelper.RefreshReddotNode(self.EventId)
    end
    Avatar:CommonQuestActivityGetPhaseReward(Cb,self.EventId, self.QuestPhaseId)
end

function M:GotoClick()
    if (self.ParentWidget and type(self.ParentWidget.CheckIsInCloseSelfState) == "function") then
        if (self.ParentWidget:CheckIsInCloseSelfState()) then
            return
        end
    end
    if (self.IsInStuffViewMode) then
        return
    end
    local PageConfigData = self:GetPageConfigData()
    PageJumpUtils:JumpToTargetPageByJumpId(PageConfigData.JumpUIId)
end

-- 是否满足前置任务
function M:IsPrerequisiteSatisfied()
    local IsLock = false
    local PlayerAvatar = GWorld:GetAvatar()
    local PageConfigData = self:GetPageConfigData()
	if (PlayerAvatar and PageConfigData and PageConfigData.JumpUnlockCondition) then
		if (not ConditionUtils.CheckCondition(PlayerAvatar, PageConfigData.JumpUnlockCondition)) then
            IsLock = true
		end
	end
	return not IsLock
end

function M:RefreshBtnGot()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end

    if Avatar:CheckCommonQuestActivityHasRewardToGet(self.EventId, self.QuestPhaseId) then
        self.Btn_Reward:SetVisibility(UE4.ESlateVisibility.Visible)
    else
        self.Btn_Reward:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self.Btn_Reward.Text_Button:SetText(GText("UI_Event_AccumulateTargetEvent_ClaimAll"))
    self.Btn_Reward:SetGamePadImg("Y")
end

return M