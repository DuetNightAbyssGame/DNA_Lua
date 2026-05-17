--
-- DESCRIPTION
-- 跳转活动通用逻辑 （PC、移动端公用）
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local TimeUtils = require("Utils.TimeUtils")
local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"
local ActivityReddotHelper = require "Blueprints.UI.WBP.Activity.ActivityReddotHelper"
local M = Class()

function M:GetPageName()
    return DataMgr.EventTab[self.ParentTabId].EventTabName
end

function M:GetActivityId()
    return self.CurActivityId
end

function M:GetParentTabId()
    return self.ParentTabId
end

function M:GetPageConfigData()
    return DataMgr.EventPortal[self.CurActivityId]
end

function M:ResetVariable()
    -- 重置一些变量
    self.FocusWidgetName = nil
end

function M:InitPage(ActivityId, ParentTabId, AllActivityId, ParentWidget)
    -- 初始化当前页面的信息
    self.CurActivityId = ActivityId
    self.ParentTabId = ParentTabId
    self.ParentWidget = ParentWidget

    local PlayerAvatar = GWorld:GetAvatar()
    if PlayerAvatar == nil then return end

    local ActivityConfigData = DataMgr.EventMain[self.CurActivityId]
    self.ActivityEndTime = ActivityConfigData.EventEndTime and ActivityConfigData.EventEndTime or ActivityConfigData.PermanenEventTime
    self.RewardEndTime = ActivityConfigData.RewardEndTime
    local PageConfigData = DataMgr.EventPortal[self.CurActivityId]
    self.FinishCondition = ActivityConfigData.EventEndCondition

    -- 刷新静态UI信息
    self:RefreshPageStaticView(ActivityConfigData, PageConfigData, self.ViewInfoBtnClick, self.GoToShopClick, self.GoToTargetPageClick, 
                                self.OnStuffDetailOpenChanged, self.GoToTaskClick, self.GoToMoreClick)
    -- 刷新动态UI信息
    self:RefreshPageDynamicView()

    self.IsComplete = false
    local Avatar = GWorld:GetAvatar()
    if Avatar and self.FinishCondition then
        self.IsComplete = ConditionUtils.CheckCondition(Avatar, self.FinishCondition)
    end
    -- 刷新剩余时间
    self:InitTimeInfo()
    ReddotManager.AddListener("TheaterEventReward",self,self.UpdateTheaterTaskReddot)
    self.ScrollBox_Desc.OnUserScrolled:Add(self, self.OnUserScrolled)
    self.Group_TextScrollTop:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Group_TextScrollBottom:SetVisibility(UIConst.VisibilityOp.Visible)


    self:AddTimer(0.05,function()
        self:OnUserScrolled()
    end, false, 0, "RefreshScrollBoxArrow", true)
end

function M:OnUserScrolled()
    UIUtils.UpdateScrollBoxArrow(self.ScrollBox_Desc, self.List_ArrowTop, self.List_ArrowBottom)
end

function M:CleanSelf(bIsRemoveSelf)
    ReddotManager.RemoveListener("TheaterEventReward",self)
    self:RemoveTimer("RefreshLeftTime")
    if (bIsRemoveSelf) then
        self:RemoveFromParent() 
    end
end

function M:InitTimeInfo()
    if (self.ActivityEndTime ~= nil or self.RewardEndTime ~= nil or self.IsComplete) and self.Activity_Time then
        local bCheckNextDayFiveStamp = true
        ActivityUtils.RefreshLeftTime(self, self.Activity_Time, bCheckNextDayFiveStamp)
        self:AddTimer(1.0, ActivityUtils.RefreshLeftTime, true, 0, "RefreshLeftTime", true, self.Activity_Time, bCheckNextDayFiveStamp)
    else
        ActivityUtils.SetLeftTimeView(self.Activity_Time, true)
    end
end

---------------------------------各种点击事件相关----------------------------------
function M:ViewInfoBtnClick()
    local ActivityConfigData = DataMgr.EventMain[self.CurActivityId]
    if (not ActivityConfigData.EventRule) then
        DebugPrint("ViewInfoBtn Click, EventRule is nil, EventId is", self.CurActivityId)
        return
    end
    local Params = {
        LongText = GText(ActivityConfigData.EventRule),
        ShowBKeyClose = true,
    }
    UIManager(self):ShowCommonPopupUI(100192, Params, self)
end

function M:GoToTargetPageClick()
    if (self.ParentWidget and type(self.ParentWidget.CheckIsInCloseSelfState) == "function") then
        if (self.ParentWidget:CheckIsInCloseSelfState()) then
            DebugPrint("CommonActivityJump= GoToTargetPageClick, ParentWidget is in close self state, So return")
            return
        end
    end
    local PageConfigData = DataMgr.EventPortal[self.CurActivityId]
    if PageConfigData.JumpUIId then
        PageJumpUtils:JumpToTargetPageByJumpId(PageConfigData.JumpUIId)
    else
        local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
        if ActivityMain then
            local JumpPageBG = ActivityMain.WidgetBGAnchor:GetChildAt(0)
            if JumpPageBG then
                JumpPageBG:FocusUI()
            end
        end
    end
end

function M:GoToShopClick()
    if (self.ParentWidget and type(self.ParentWidget.CheckIsInCloseSelfState) == "function") then
        if (self.ParentWidget:CheckIsInCloseSelfState()) then
            DebugPrint("CommonActivityJump= GoToShopClick, ParentWidget is in close self state, So return")
            return
        end
    end
    local PageConfigData = DataMgr.EventPortal[self.CurActivityId]
    if (not PageConfigData.EventShop) then
        return
    end
    PageJumpUtils:JumpToTargetPageByJumpId(PageConfigData.EventShop)
end

-- 目前只有剧院联机活动用了这个活动，不知道怎么统一，先这样写着吧
function M:GoToTaskClick()
    local Params = self:MakeRewardData()
    if not Params then
        DebugPrint("JLY 没有剧院任务数据")
        return
    end
    UIManager(self):ShowCommonPopupUI(100258, Params)
end

function M:MakeRewardData()
    local Avatar = GWorld:GetAvatar()
    local TheaterData = Avatar.TheaterActivity[self.CurActivityId]
    if not TheaterData then
        DebugPrint("JLY 没有剧院任务数据")
        return
    end
    local Params={}
    Params.ConfigData={}
    Params.ConfigData.TabInfo={}
    Params.ConfigData.Items={}
    Params.ConfigData.HasTab=true
    Params.ConfigData.Datas={}

    local TheaterTaskData = DataMgr["TheaterTask"]
    local TabTypes = {
        GText("TheaterOnline_Task_Daily"),
        GText("TheaterOnline_Task_Total"),
    }

    local TabNum = {}

    for i = 1, #TabTypes do
        local TabItem={}
        TabItem.Index = i
        TabItem.Type = i
        TabItem.Title = GText(TabTypes[i])
        TabItem.IsShowIcon = true
        TabItem.ReddotName = "TheaterEventReward"
        table.insert(Params.ConfigData.TabInfo,TabItem)
        local RewardData={}
        RewardData.ShowIcon=false
        RewardData.NowNum = 1
        RewardData.NumMax = 2
        RewardData.ReceiveAllCallBack = self.GetAllRewards
        RewardData.ReceiveAllParam = {Index = i}
        RewardData.Type = TabTypes[i]
        RewardData.Text_Total = string.format(GText("UI_ModGuideBook_Task_Collecting"))
        RewardData.ReceiveButtonText = GText("UI_Archive_CollectionClaimAll")
        RewardData.Items = {}
        Params.ConfigData.Datas[i] = RewardData

        TabNum[i] = {NowNum = 0, NumMax = 0}
    end

    for TaskId, TaskInfo in pairs(TheaterData.Tasks) do
        local TaskData = TheaterTaskData[TaskId]
        if not TaskData then
            goto continue
        end
        local Item={}
        Item.ItemId = TaskId
        local CurrentNum = TaskInfo.Progress
        Item.CanReceive = CurrentNum >= TaskInfo.Target
        Item.Type = TaskData.IsDaily and 1 or 2
        Item.RewardsGot = TaskInfo.RewardsGot
        Item.ReddotName = "TheaterEventReward"
        Item.NotreachText=GText("UI_Archive_CollectionInProgress")
        Item.Hint = TaskData.Des and string.format(GText(TaskData.Des), TaskInfo.Progress.."/"..TaskInfo.Target) or string.format(GText("UI_Archive_CollectionTarget"), TaskInfo.Progress.."/"..TaskInfo.Target)
        Item.Num = TaskInfo.Target
        Item.ReceiveCallBack = self.GetRewards
        Item.ReceiveParm = {RewardModel = self}
        local Rewards={}
        local RewardItemId = TaskData.RewardId
        local RewardInfo = DataMgr.Reward[RewardItemId]
        if RewardInfo then
            local Ids = RewardInfo.Id or {}
            local RewardCount = RewardInfo.Count or {}
            local TableName = RewardInfo.Type or {}
            for i = 1, #Ids do
                local ItemId = Ids[i]
                local Count = RewardUtils:GetCount(RewardCount[i])
                local Rarity = ItemUtils.GetItemRarity(ItemId, TableName[i])
                local ItemType = TableName[i]
                local RewardContent = {
                    ItemType = ItemType,
                    ItemId = ItemId,
                    Count = Count,
                    Rarity = Rarity,
                }
                table.insert(Rewards, RewardContent)
            end
        end
        Item.Rewards=Rewards
        table.insert(Params.ConfigData.Datas[Item.Type].Items,Item)
        TabNum[Item.Type].NowNum = TabNum[Item.Type].NowNum + (Item.CanReceive and 1 or 0)
        TabNum[Item.Type].NumMax = TabNum[Item.Type].NumMax + 1
        ::continue::
    end

    for i = 1, #TabTypes do
        Params.ConfigData.Datas[i].NowNum = TabNum[i].NowNum
        Params.ConfigData.Datas[i].NumMax = TabNum[i].NumMax
    end

    Params.ConfigData.Type=Params.ConfigData.TabInfo[1].Type
    return Params
end

function M:GetAllRewards(ReceiveAllParm)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local Callback = function(Ret, Rewards)
            if Ret == 0 then
                for i = 0,ReceiveAllParm.SelfWidget.List_Item:GetNumItems() - 1 do
                    local Content = ReceiveAllParm.SelfWidget.List_Item:GetItemAt(i)
                    if Content.ConfigData.CanReceive then
                        Content.ConfigData.CanReceive = false
                        Content.ConfigData.RewardsGot = true
                        if Content.SelfWidget then
                            Content.SelfWidget:RefreshBtn(true)
                        end
                    end
                end
                ReceiveAllParm.SelfWidget:RefreshButton(false)
                UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, nil, ReceiveAllParm.SelfWidget, true)
            end
        end
        Avatar:TheaterGetAllTaskReward(ReceiveAllParm.Index == 1, Callback)
    end
end

function M:CheckHaveRewardToGet(TabType)
    if not TabType then
        return false
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    local TheaterData = Avatar.TheaterActivity and Avatar.TheaterActivity[self.CurActivityId]
    if not TheaterData or not TheaterData.Tasks then
        return false
    end
    local TheaterTaskData = DataMgr.TheaterTask
    if not TheaterTaskData then
        return false
    end
    for TaskId, TaskInfo in pairs(TheaterData.Tasks) do
        local TaskData = TheaterTaskData[TaskId]
        if TaskData then
            local ItemType = TaskData.IsDaily and 1 or 2
            if ItemType == TabType and TaskInfo.Progress >= TaskInfo.Target and not TaskInfo.RewardsGot then
                return true
            end
        end
    end
    return false
end

function M.GetRewards(RewardItem,Content)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local Callback = function(Ret, Rewards)
            if Ret == 0 then
                Content.ConfigData.CanReceive = false
                Content.ConfigData.RewardsGot = true
                Content.SelfWidget:RefreshBtn(true)
                Content.Owner:RefreshButton(Content.ConfigData.ReceiveParm.RewardModel:CheckHaveRewardToGet(Content.ConfigData.Type))
                UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function()
                    RewardItem:SetFocus()
                end, RewardItem)
            end
        end
        Avatar:TheaterGetTaskReward(Content.ConfigData.ItemId, Callback)
    end
end

function M:UpdateTheaterTaskReddot()
    local Avatar = GWorld:GetAvatar()
    local TheaterData = Avatar.TheaterActivity[DataMgr.TheaterConstant.EventId.ConstantValue]
    if not TheaterData then
        DebugPrint("JLY 没有剧院任务数据")
        return
    end
    if self.CurActivityId ~= DataMgr.TheaterConstant.EventId.ConstantValue then
        return
    end
    local IsEmpty = true
    for TaskId, TaskInfo in pairs(TheaterData.Tasks) do
        if TaskInfo.Progress >= TaskInfo.Target and not TaskInfo.RewardsGot then
            IsEmpty = false
            break
        end
    end
    if IsEmpty then
        ActivityReddotHelper.TrySubReddotCount(ActivityUtils,self.CurActivityId,"Red")
        self.TaskReddot:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    else
        self.TaskReddot:SetVisibility(UIConst.VisibilityOp["Visible"])
    end
end

function M:GoToMoreClick()
    if (self.CurActivityId == DataMgr.TheaterConstant.EventId.ConstantValue) then
        local Params = {DataMap = {Tabs = {}}}
        local Tabs = {
            [1] = {
                Text = GText("TheaterOnline_Game_Name"),
                TabId = 1,
            },
            [2] = {
                Text = GText("TheaterOnline_Game_Interactor"),
                TabId = 2,
            },
        }
        Params.TabConfigData  = {
            PlatformName = CommonUtils.GetDeviceTypeByPlatformName(self),
            LeftKey = "A",
            RightKey = "D",
            Tabs = Tabs,
            SoundFunc = function ()
                AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_01", nil, nil)
            end
        }


        local TabTypes = {GText("UI_Theater_CommonReward"), GText("UI_Theater_PremiumReward")}
        local DataMap = {}
        for i = 1, #TabTypes do
            local RewardId = DataMgr.TheaterConstant["Reward" .. i].ConstantValue
            local RewardInfo = DataMgr.Reward[RewardId]
            if RewardInfo then
                local Ids = RewardInfo.Id
                local RewardCount = RewardInfo.Count
                local TableName = RewardInfo.Type
                local RewardList = {}
                for j = 1, #Ids do
                    local ItemData = {}
                    ItemData.ItemId = Ids[j]
                    ItemData.Count = RewardUtils:GetCount(RewardCount[j])
                    ItemData.Icon = ItemUtils.GetItemIconPath(ItemData.ItemId, TableName[j])
                    ItemData.Rarity = ItemUtils.GetItemRarity(ItemData.ItemId, TableName[j])
                    ItemData.ItemType = TableName[j]
                    table.insert(RewardList, ItemData)
                end

                if not DataMap[TabTypes[i]] then
                    DataMap[TabTypes[i]] = {}
                end

                DataMap[TabTypes[i]] = RewardList
            end
        end
        Params.DataMap.Tabs[1] = DataMap

        local TheaterDonateStepData = DataMgr.TheaterDonateStep[self.CurActivityId]
        DataMap = {}
        for i = 1, #TheaterDonateStepData do
            local RewardId = TheaterDonateStepData[i].RewardViewId
            local RewardInfo = DataMgr.RewardView[RewardId]
            if RewardInfo then
                local Ids = RewardInfo.Id
                local RewardCount = RewardInfo.Quantity
                local TableName = RewardInfo.Type
                local RewardList = {}
                for j = 1, #Ids do
                    local ItemData = {}
                    ItemData.ItemId = Ids[j]
                    ItemData.Count = RewardUtils:GetCount(RewardCount[j])
                    ItemData.Icon = ItemUtils.GetItemIconPath(ItemData.ItemId, TableName[j])
                    ItemData.Rarity = ItemUtils.GetItemRarity(ItemData.ItemId, TableName[j])
                    ItemData.ItemType = TableName[j]
                    table.insert(RewardList, ItemData)
                end

                local TabType = string.format(GText("TheaterOnline_Donate_Step"), i)
                if not DataMap[TabType] then
                    DataMap[TabType] = {}
                end

                DataMap[TabType] = RewardList
            end
        end
        Params.DataMap.Tabs[2] = DataMap
        UIManager(self):ShowCommonPopupUI(100257, Params)

        return true

    elseif ActivityUtils.IsAccessoryDropActivity(self.CurActivityId) then
        local BPBg = self.ParentWidget.WidgetBGAnchor:GetChildAt(0)
        if BPBg.OpenRewardDetails then
            BPBg:OpenRewardDetails()
        end
    end

    return false
end

return M