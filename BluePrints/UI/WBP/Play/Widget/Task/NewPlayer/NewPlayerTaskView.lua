--
-- DESCRIPTION
-- 活动系统新手任务View （PC、移动端公用）
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"
local EMCache = require "EMCache.EMCache"
local M = {}
function M:GenerateAllListItem(AllQuestConfigInfo, AllQuestServerInfo, ItemObjClass)
    -- 设置新手任务数据
    self.PlayInAnimation = true
    self:OnSelectChange(nil)
    self.List_Task:ScrollIndexIntoView(0)
    self.List_Task:ClearListItems()
    local AllQuestId = {}
    for k, v in pairs(AllQuestConfigInfo) do
        table.insert(AllQuestId, k)
    end
    local SortFunc = function(CompareA, ComPareB)
        local ConfigDataA = DataMgr.StarterQuestDetail[CompareA]
        local ConfigDataB = DataMgr.StarterQuestDetail[ComPareB]
        local ServerDataA = AllQuestServerInfo[CompareA]
        local ServerDataB = AllQuestServerInfo[ComPareB]
        if (not ServerDataA or not ServerDataB) then
            if (not ConfigDataA.JumpUIId == not ConfigDataB.JumpUIId) then
                return CompareA < ComPareB
            else
                return ConfigDataA.JumpUIId ~= nil
            end
        end
        local FinshNoRecA = ServerDataA:IsComplete() and ServerDataA:CanRecvReward()
        local FinshNoRecB = ServerDataB:IsComplete() and ServerDataB:CanRecvReward()
        local FinishedA = ServerDataA:IsComplete()
        local FinishedB = ServerDataB:IsComplete()

        if (FinshNoRecA == FinshNoRecB and FinshNoRecA) then 
            return CompareA < ComPareB
        else
            if (FinshNoRecA ~= FinshNoRecB) then
                return FinshNoRecA
            else
                if (FinishedA == FinishedB and FinishedA) then
                    return CompareA < ComPareB
                else
                    if (FinishedA ~= FinishedB) then
                        return FinishedB
                    else
                        if (not ConfigDataA.JumpUIId == not ConfigDataB.JumpUIId) then
                            return CompareA < ComPareB
                        else
                            return ConfigDataA.JumpUIId ~= nil
                        end
                    end
                end
            end
        end
    end

    table.sort(AllQuestId, SortFunc)
    -- 填充所有Item表现
    local StartIndex = 0
    for _, QuestId in ipairs(AllQuestId) do
        local QuestConfigData = DataMgr.StarterQuestDetail[QuestId]
        if QuestConfigData then
            local ItemObject = NewObject(ItemObjClass)
            ItemObject.Index = StartIndex
            ItemObject.QuestId = QuestId
            ItemObject.Parent = self
            ItemObject.StartTime = UGameplayStatics.GetTimeSeconds(self)
            self.List_Task:AddItem(ItemObject)
            StartIndex = StartIndex + 1
        end
    end
    self.List_Task:RequestFillEmptyContent()
    self.List_Task:RequestPlayEntriesAnim()
    self:TryNavigateToIndex(0)
end

function M:ReGenerateAllListItem(AllQuestConfigData, AllQuestServerData, ItemObjClass, IsHideGetAllBtn)
    -- 重新生成所有任务状态
    self:GenerateAllListItem(AllQuestConfigData, AllQuestServerData, ItemObjClass)
    -- 刷新一键领取按钮样式
    if (IsHideGetAllBtn) then
        self.Btn_Reward:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    else
        self:RefreshGetAllBtnView(AllQuestServerData) 
    end
end

function M:RefreshItemStyleView(TargetQuestId, QuestConfigData, QuestServerData)
    -- 刷新单个Item表现
    local AllItemCount, CanGetTaskRewardCount = self.List_Task:GetNumItems(), 0
    for i = 0, AllItemCount - 1, 1 do
        local ItemObj = self.List_Task:GetItemAt(i)
        if (ItemObj.OwnerPanel ~= nil) then
            if (ItemObj.QuestId == TargetQuestId) then
                ItemObj.OwnerPanel:RefreshProcessView(QuestConfigData, QuestServerData)
            end
            if (ItemObj.OwnerPanel:IsTaskRewardNotReceive()) then
                CanGetTaskRewardCount = CanGetTaskRewardCount + 1
            end
        end
    end
    if (CanGetTaskRewardCount < 1) then
        self.Btn_Reward:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

function M:RefreshAllItemStyleView(AllQuestConfigData, AllQuestServerData)
    -- 刷新所有Item表现
    local AllItemCount = self.List_Task:GetNumItems()
    for i = 0, AllItemCount - 1, 1 do
        local ItemObj = self.List_Task:GetItemAt(i)
        local QuestServerData = AllQuestServerData[ItemObj.QuestId]
        if (QuestServerData ~= nil) then
            if (ItemObj.OwnerPanel ~= nil) then
                ItemObj.OwnerPanel:RefreshProcessView(AllQuestConfigData[ItemObj.QuestId], QuestServerData)
            end
        end
    end
    self.Btn_Reward:SetVisibility(UIConst.VisibilityOp["Collapsed"])
end

function M:RefreshGetAllBtnView(AllQuestServerData)
    local CanGetTaskRewardCount = 0
    for _, QuestInfo in pairs(AllQuestServerData) do
        if (QuestInfo:CanRecvReward() and QuestInfo:IsComplete()) then
            CanGetTaskRewardCount = CanGetTaskRewardCount + 1
        end
    end
    if (CanGetTaskRewardCount >= 1) then
        self.Btn_Reward:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self.Btn_Reward:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
    self:UpdateUIStyleInPlatform()
end
---------------------------------数据准备----------------------------------
function M:InitQuestData()
    self.PhaseId2TabId = {}              -- PhaseId与TabId对应关系
    self.QuestTabInfo = {}
    self.AllQuestPhaseIdValue = {}
    self.IsCurrentPhaseRedPoint = false
    for k, v in pairs(DataMgr.StarterQuestPhaseMap) do
        table.insert(self.AllQuestPhaseIdValue, k) 
    end
    table.sort(self.AllQuestPhaseIdValue)
    local CurrentPhaseId = EMCache:Get("StarterQuestsCurPhaseId", true)
    for _, PhaseId in ipairs(self.AllQuestPhaseIdValue) do
        self.PlayerPhaseId = PhaseId
        if not CurrentPhaseId or CurrentPhaseId <= PhaseId then
            if not ActivityUtils.CheckIsCurrentStarterQuestAllDone(PhaseId) then
                break
            end
        end
    end
    if self.PlayerPhaseId ~= CurrentPhaseId then
        EMCache:Set("StarterQuestsCurPhaseId", self.PlayerPhaseId, true)
    end
end
function M:RefreshTabItemInfo(CurrentPhaseId)
    local CurrentPhaseIndex = self.PhaseId2TabId[CurrentPhaseId]
    if CurrentPhaseIndex < self.MaxPhaseIndex and ActivityUtils.CheckIsCurrentStarterQuestAllDone(CurrentPhaseId) then 
        self.PlayerPhaseId = CurrentPhaseId + 1
        EMCache:Set("StarterQuestsCurPhaseId", self.PlayerPhaseId, true)
        self:RefreshPhaseIndex(self.PlayerPhaseId)
    elseif (CurrentPhaseId == self.CurPhaseId) then
        -- 如果是当前选中的阶段，则刷新整个列表
        self:ReGenerateAllListItem(self.AllQuestConfigData[self.CurPhaseId], self.AllQuestServerData[self.CurPhaseId], self.TaskObjectClass)
    end
end
function M:FillWithQuestData(PlayerAvatar)
    for PhaseIndex, PhaseId in ipairs(self.AllQuestPhaseIdValue) do
        local ShowTabText = string.format(GText("UI_GameEvent_StarterQuest_Phase"), PhaseIndex)
        local IsLocked = PhaseId > self.PlayerPhaseId
        local LockText = string.format(GText("UI_GameEvent_StarterQuest_UnlockCondition"), PhaseIndex - 1)
        if (self.AllQuestServerData[PhaseId] == nil) then
            self.AllQuestServerData[PhaseId] = {}
        end
        if (self.AllQuestConfigData[PhaseId] == nil) then
            self.AllQuestConfigData[PhaseId] = {}
        end

        local QuestIdValue = DataMgr.StarterQuestPhaseMap[PhaseId]
        for _, v in ipairs(QuestIdValue) do
            local QuestConfigData = DataMgr.StarterQuestDetail[v]
            local QuestServerData = PlayerAvatar.StarterQuests[v]
            -- 检查一下这个阶段的任务是否需要显示红点
            self.AllQuestConfigData[PhaseId][v] = QuestConfigData
            self.AllQuestServerData[PhaseId][v] = QuestServerData
        end
        self.PhaseId2TabId[PhaseId] = PhaseIndex
        if (PhaseIndex == 1) then
            self.CurPhaseId = PhaseId
        end
        table.insert(self.QuestTabInfo, {Text=ShowTabText, PhaseId=PhaseId, IsLocked=IsLocked, LockReasonText=LockText})
    end
end

---------------------------------UI更新----------------------------------
function M:RefreshPhaseIndex(PhaseId)
    if not self.AllQuestConfigData[PhaseId] then 
        return
    end
    local CurrentPhaseIndex = self.PhaseId2TabId[PhaseId]
    if PhaseId > self.PlayerPhaseId then 
        local ShowTextContent = self.QuestTabInfo[CurrentPhaseIndex].LockReasonText or "Not Define!!!!"
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, ShowTextContent)
        return
    end
    self.CurPhaseId = PhaseId
    self.Text_PageTitle:SetText(self.QuestTabInfo[CurrentPhaseIndex].Text)
    -- 刷新新手任务面板
    self:GenerateAllListItem(self.AllQuestConfigData[self.CurPhaseId], self.AllQuestServerData[self.CurPhaseId], self.TaskObjectClass)
    -- 刷新一键领取按钮样式
    self:RefreshGetAllBtnView(self.AllQuestServerData[self.CurPhaseId])
    self:RefreshRightBtnReddot()
    self:SetTabWidgetState(self.Btn_Left, CurrentPhaseIndex > 1)
    self:SetTabWidgetState(self.Btn_Right, CurrentPhaseIndex < self.MaxPhaseIndex)
end
function M:SetForbidKey_Widget(Widget, bOn)
    if bOn then
        EMUIAnimationSubsystem:EMStopAnimation(Widget,Widget.Normal)
        EMUIAnimationSubsystem:EMPlayAnimation(Widget,Widget.Forbidden)
    else
        EMUIAnimationSubsystem:EMStopAnimation(Widget,Widget.Forbidden)
        EMUIAnimationSubsystem:EMPlayAnimation(Widget,Widget.Normal)
    end
end
function M:SetTabWidgetState(Widget, IsNormal, IsKeyWidget, IsGamepad)
    if IsKeyWidget then 
        self:SetForbidKey_Widget(Widget, not IsNormal)
        Widget:SetVisibility(IsGamepad and UIConst.VisibilityOp["Visible"] or UIConst.VisibilityOp["Collapsed"])
    else 
        Widget:ForbidBtn(not IsNormal)
        Widget:SetVisibility(IsNormal and UIConst.VisibilityOp["Visible"] or UIConst.VisibilityOp["HitTestInvisible"])
    end
end
---------------------------------各种点击事件相关----------------------------------
function M:BindAllClickFunction()
    self.Btn_Left.Btn.OnClicked:Add(self, self.OnBtnArrowLeftClicked)
    self.Btn_Right.Btn.OnClicked:Add(self, self.OnBtnArrowRightClicked)
    self.Btn_Reward:SetText(GText("UI_GameEvent_ClaimAll"))
    self.Btn_Reward:BindEventOnClicked(self, self.GetAllRewardBtnClick)
    self.Btn_CheckReward.Text_RewardPreview:SetText(GText("UI_GameEvent_StarterQuest_RewardPreview"))
    self.Btn_CheckReward.Btn_RewardPreview.OnClicked:Add(self, self.PreviewRewardBtnClick)
    ReddotManager.AddListener(self.NodeName,self,self.RefreshRightBtnReddot)
    self:AddDispatcher(EventID.OnUpdateActivityEvent, self, self.OnUpdateActivityByAction)
end
function M:RefreshRightBtnReddot()
    local Node = ReddotManager.GetTreeNode(self.NodeName)
    local IsShowRedDot = Node and Node.Count and Node.Count > 0
    IsShowRedDot = IsShowRedDot and self.CurPhaseId < self.PlayerPhaseId
    self.Right_Reddot:SetVisibility(IsShowRedDot and UIConst.VisibilityOp["Visible"] or UIConst.VisibilityOp["Collapsed"])
end
function M:OnBtnArrowLeftClicked()
    self:RefreshPhaseIndex(self.CurPhaseId - 1)
end
function M:OnBtnArrowRightClicked()
    self:RefreshPhaseIndex(self.CurPhaseId + 1)
end
function M:PreviewRewardBtnClick()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    local SelectWidget = nil
    local Nums = self.List_Task:GetNumItems()
    for Index = 1, Nums do 
        local Item = self.List_Task:GetItemAt(Index)
        local Widget = Item and Item.OwnerPanel
        if Widget then 
            local IsFocusWidget = Widget:HasAnyUserFocus()
            local IsFocusItemReward1 = not IsFocusWidget and Widget.Item_Reward_1:HasAnyUserFocus()
            if IsFocusWidget or IsFocusItemReward1 or Widget.Item_Reward_2:HasAnyUserFocus() then 
                SelectWidget = Widget
                if not IsFocusWidget then 
                    SelectWidget = IsFocusItemReward1 and Widget.Item_Reward_1 or Widget.Item_Reward_2 
                end
                break
            end
        end
    end
    local Params = {CloseBtnCallbackFunction = function() 
        if SelectWidget and SelectWidget.ParentWidget then 
            SelectWidget.ParentWidget:UpdatKeyDisplay("RewardWidget")
        end
    end}
    UIManager(self):ShowCommonPopupUI(100202, Params, self)
end
function M:GetAllRewardBtnClick()
    local PlayerAvatar = GWorld:GetAvatar()
    if not PlayerAvatar then
        return
    end
    PlayerAvatar:GetAllStarterQuest(self.CurPhaseId)
end
return M