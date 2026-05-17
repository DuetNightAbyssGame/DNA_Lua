-- -- DESCRIPTION
-- --
-- -- @COMPANY **
-- -- @AUTHOR **
-- -- @DATE ${date} ${time}
-- --
-- require "UnLua"
-- local TimeUtils = require("Utils.TimeUtils")
-- ---@type WBP_Play_Daily_P_C
-- local M = Class({ "BluePrints.UI.BP_UIState_C" })

-- local TypeSort = {
--     Char = 1,
--     Weapon = 2,
--     Mod = 3,
--     Draft = 4,
--     Reward = 5,
--     Resource = 6,
-- }
-- function M:Construct()
--     M.Super.Construct(self)
--     self:AddDispatcher(EventID.DailyProgressRewardChange, self, self.OnDailyProgressRewardChange)
--     self:AddDispatcher(EventID.AllRewardDailyTask, self, self.OnAllRewardDailyTask)
--     self:AddDispatcher(EventID.DailyRefreshDailyTask, self, self.OnDailyRefreshDailyTask)
--     self:AddDispatcher(EventID.DailyTaskRewardChange, self, self.OnDailyTaskRewardChange)
--     self:AddDispatcher(EventID.AllDailyTaskRewardKey, self, self.OnAllDailyTaskRewardKey)

--     self:AddDispatcher(EventID.EntryReceiveEnterState,self,self.OnEntryReceiveEnterState)

--     -- EventManager:AddEvent(EventID.DailyProgressRewardChange, self, self.OnDailyProgressRewardChange)
--     -- EventManager:AddEvent(EventID.AllRewardDailyTask, self, self.OnAllRewardDailyTask)
--     -- EventManager:AddEvent(EventID.DailyRefreshDailyTask, self, self.OnDailyRefreshDailyTask)
--     -- EventManager:AddEvent(EventID.DailyTaskRewardChange, self, self.OnDailyTaskRewardChange)
--     -- EventManager:AddEvent(EventID.AllDailyTaskRewardKey, self, self.OnAllDailyTaskRewardKey)

--     local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
--     self.UIManager = GameInstance:GetGameUIManager()
--     self:AddInputMethodChangedListen()
--     self:InitDailyGoalTask()
--     self.Btn_Reward:BindEventOnClicked(self, self.ClaimAllTaskRewards)
--     self.Btn_Reward:SetText(GText("UI_BattlePass_ClaimAll"))
--     if (self:IsExistTimer("UpdateTimeContent")) then
--         self:RemoveTimer("UpdateTimeContent")
--     end
--     self:UpdateTimeCountDown()
--     self:AddTimer(1.0, self.UpdateTimeCountDown, true, 0, "UpdateTimeContent", true)
--     self.Mobile = CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile"
--     self.Gamepad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad

--     self.List_Task:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
--     self.List_Task:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
--     self.List_Task:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
--     self.List_Task:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
-- end

-- function M:OnEntryReceiveEnterState(StackAction)
--     if StackAction == 1 then
--         self:InitDailyGoalTask()
--         self:SetNavigateToIndex()
--     end
-- end

-- -- 初始化每日任务列表
-- function M:InitDailyGoalTask()
--     local PlayerAvatar = GWorld:GetAvatar()
--     if not PlayerAvatar then return end
--     self.PlayerAvatar = PlayerAvatar

--     self:RefresDailyGoalTask()
--     self:RefreshProgress()
--     self:SetBtn_RewardState()

-- end

-- function M:SetBtn_RewardState()
--     if self:HasClaimableTaskReward() then
--         self.Btn_Reward:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--     else
--         self.Btn_Reward:SetVisibility(UE4.ESlateVisibility.Collapsed)
--     end
--     self:UpdateUIStyleInPlatform()
-- end

-- function M:RefreshProgress()
--     self.Progress:RefreshProgress(self)
--     self.Activation.Text_Num:SetText( self.PlayerAvatar.CurrentTaskProgress)
--     self.Activation.Text_Activation:SetText(GText("UI_DailyGoal_Activeness"))
-- end

-- function M:RefresDailyGoalTask()
--     self.List_Task:ClearListItems()
--     local TaskList = {}
--     for _, Task in pairs(self.PlayerAvatar.DailyTasks) do
--         table.insert(TaskList, DataMgr.DailyGoalTask[Task.DailyGoalTaskId])
--     end

--     -- 任务排序逻辑
--     table.sort(TaskList, function(a, b)
--         local TaskDataA = self.PlayerAvatar.DailyTasks[a.DailyGoalTaskId]
--         local TaskDataB = self.PlayerAvatar.DailyTasks[b.DailyGoalTaskId]

--         local StateA = TaskDataA and TaskDataA.State or 2
--         local StateB = TaskDataB and TaskDataB.State or 2

--         local Priority = {
--             [2] = CommonConst.DailyTaskState.Doing,    -- 最优先
--             [1] = CommonConst.DailyTaskState.Complete, -- 第二优先
--             [3] = CommonConst.DailyTaskState.GetReward -- 最低优先
--         }

--         local PriorityA = Priority[StateA] or 2
--         local PriorityB = Priority[StateB] or 2

--         if PriorityA ~= PriorityB then
--             return PriorityA < PriorityB
--         end

--         if (a.JumpUIId ~= nil) ~= (b.JumpUIId ~= nil) then
--             return a.JumpUIId ~= nil
--         end

--         return a.DailyGoalTaskId < b.DailyGoalTaskId
--     end)

--     -- 创建任务内容项并添加到列表
--     for _, Task in ipairs(TaskList) do
--         local Content = NewObject(UIUtils.GetCommonItemContentClass())
--         Content.DailyGoalTaskId = Task.DailyGoalTaskId
--         Content.DailyTasktDes = Task.DailyTasktDes
--         Content.JumpUIId = Task.JumpUIId
--         Content.QuestReward = Task.QuestReward
--         Content.Target = Task.Target
--         Content.TargetId = Task.TargetId
--         Content.Parent = self
--         self.List_Task:AddItem(Content)
--     end


-- end

-- function M:SetNavigateToIndex()
--     -- self:AddTimer(0.01, function()
        
--     -- end, false, 0, "Play_Daily_List_Task")
--     self.List_Task:NavigateToIndex(0)
-- end


-- -- 检查是否有可领取的任务奖励
-- function M:HasClaimableTaskReward()
--     local PlayerAvatar = GWorld:GetAvatar()
--     if not PlayerAvatar then return false end

--     local DailyTaskServerData = PlayerAvatar.DailyTasks
--     local DailyTaskProgressState = PlayerAvatar.DailyTaskProgress

--     -- 是否有可领取的奖励
--     for _, TaskData in pairs(DailyTaskServerData) do
--         if TaskData.State == CommonConst.DailyTaskState.Complete then
--             return true
--         end
--     end

--     for _, ProgressState in pairs(DailyTaskProgressState) do
--         if ProgressState == CommonConst.DailyTaskState.Complete then
--             return true
--         end
--     end

--     return false
-- end

-- -- 一键领取所有任务奖励
-- function M:ClaimAllTaskRewards()
--     local PlayerAvatar = GWorld:GetAvatar()
--     if not PlayerAvatar then return false end
--     PlayerAvatar:GetAllRewardDailyTask()
-- end

-- -- 任务进度奖励变更回调
-- function M:OnDailyProgressRewardChange(TargetProgress, Rewards)
--     self:RefreshProgress()
--     self:SetBtn_RewardState()
--     self.UIManager:LoadUINew("GetItemPage", nil, nil, nil, Rewards)
-- end

-- -- 一键领取所有奖励回调
-- function M:OnAllRewardDailyTask(Rewards)
--     self:RefresDailyGoalTask()
--     self:RefreshProgress()
--     self:SetBtn_RewardState()
--     self.UIManager:LoadUINew("GetItemPage", nil, nil, nil, Rewards)
-- end

-- --每日任务刷新回调
-- function M:OnDailyRefreshDailyTask()
--     local Params = {}
--     local UI = UIManager(self):ShowCommonPopupUI(100177, Params)
--     self:AddTimer(0.01, function()
--         self:InitDailyGoalTask()
--     end, false, 0, "OnDailyRefreshDailyTask")
--     --self:InitDailyGoalTask()
-- end

-- function M:OnDailyTaskRewardChange(DailyTaskId,Rewards)
--     self:RefresDailyGoalTask()
--     self:RefreshProgress()
--     self:SetBtn_RewardState()
--     self.UIManager:LoadUINew("GetItemPage", nil, nil, nil, Rewards)
-- end
-- -- 更新时间倒计时
-- function M:UpdateTimeCountDown()
--     self.LeftTimeDict = TimeUtils.TimestampNextClock(CommonConst.GAME_REFRESH_HMS[1])
--     local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(self.LeftTimeDict)
--     self.Refresh_Time:SetTimeText(GText("UI_DailyGoal_RemainTime"), RemainTimeDict)
-- end

-- function M:OnAllDailyTaskRewardKey()
--     if  self:HasClaimableTaskReward() then  self:ClaimAllTaskRewards() end
-- end

-- function M:RewardView()
--     local GoalRewards = {}
--     self.DataMap = {}
--     local PlayerAvatar = GWorld:GetAvatar()
--     if not PlayerAvatar then return end
--     local key = nil
--     local maxLv = nil
--     local prevLv = nil     -- 记录上一个 lv

--     local SortedKeys = {}
--     for lv in pairs(DataMgr.DailyGoalReward) do
--         table.insert(SortedKeys, lv)
--     end

--     table.sort(SortedKeys) -- 默认升序

--     for _, lv in pairs(SortedKeys) do
--         -- 记录最大的等级
--         if not maxLv or lv > maxLv then
--             maxLv = lv
--         end

--         if lv == PlayerAvatar.DailyInitLevel then
--             key = lv
--             break
--         elseif lv > PlayerAvatar.DailyInitLevel then
--             key = prevLv
--             break
--         end

--         -- 记录上一个 lv
--         prevLv = lv
--     end

--     if not key then
--         key = maxLv
--     end

--     local DailyGoalReward = DataMgr.DailyGoalReward[key]
--     for _, ItemData in pairs(DailyGoalReward) do
--         table.insert(GoalRewards, ItemData)
--     end
--     local SortFunc = function(A, B)
--         if A.Rarity == B.Rarity then
--             if TypeSort[A.ItemType] and TypeSort[B.ItemType] then
--                 if TypeSort[A.ItemType] == TypeSort[B.ItemType] then
--                     return A.ItemId < B.ItemId
--                 end
--                 return TypeSort[A.ItemType] < TypeSort[B.ItemType]
--             end
--             return A.ItemId < B.ItemId
--         end
--         return A.Rarity > B.Rarity
--     end

--     for _, Data in ipairs(GoalRewards) do
--         local RewardInfo = DataMgr.Reward[Data.ActivenessReward]
--         if RewardInfo then
--             local Ids = RewardInfo.Id
--             local RewardCount = RewardInfo.Count
--             local TableName = RewardInfo.Type
--             local RewardList = {}
--             for i = 1, #Ids do
--                 local ItemData = {}
--                 ItemData.ItemId = Ids[i]
--                 ItemData.Count = RewardUtils:GetCount(RewardCount[i])
--                 ItemData.Icon = ItemUtils.GetItemIconPath(ItemData.ItemId, TableName[i])
--                 ItemData.Rarity = ItemUtils.GetItemRarity(ItemData.ItemId, TableName[i])
--                 ItemData.ItemType = TableName[i]
--                 table.insert(RewardList, ItemData)
--             end

--             table.sort(RewardList, SortFunc)

--             if not self.DataMap[Data.RequiredActiveness] then
--                 self.DataMap[Data.RequiredActiveness] = {}
--             end

--             self.DataMap[Data.RequiredActiveness] = RewardList
--         end
--     end

--     local Params = {}
--     Params.DataMap = self.DataMap
--     local UI = UIManager(self):ShowCommonPopupUI(100181, Params)
-- end

-- function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
--     if (CurInputDevice == ECommonInputType.Touch) then
--         -- 触控模式即默认样式，不需要刷新
--         return
--     end
--     --- 输入设备切换通知
--     local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
--     if not IsUseKeyAndMouse and (self:HasFocusedDescendants() or self:HasAnyUserFocus()) then
--         self:SetNavigateToIndex()
--         self.Btn_Reward:SetGamePadImg("Y")
--         self.Btn_Reward:SetGamePadVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
--     else
--         self:UpdateUIStyleInPlatform()
--     end

--     self.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
-- end

-- function M:SwitchIn()
--     self:UpdateUIStyleInPlatform()
-- end

-- function M:UpdateUIStyleInPlatform()
--     if not UIUtils.IsGamepadInput() then
--         -- 隐藏手柄奖励按钮
--         self.Btn_Reward:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])

--         if UIUtils.HasAnyFocus(self) then
--             local StyleOfPlay = UIManager(self):GetUIObj("StyleOfPlay")

--             -- 处理 BottomKeyInfo 逻辑
--             local BottomKeyInfo = {
--                 { KeyInfoList = { { Type = "Text", Text = "Esc", Owner = self } }, Desc = GText("UI_BACK"), bLongPress = false }
--             }

--             if self:HasClaimableTaskReward() then
--                 table.insert(BottomKeyInfo, 1, {
--                     KeyInfoList = { { Type = "Text", Text = "Space", Owner = self } },
--                     Desc = GText("UI_BattlePass_ClaimAll"),
--                     bLongPress = false
--                 })
--             end

--             -- 确保 StyleOfPlay 存在才调用 UpdateOtherPageTab
--             if StyleOfPlay then
--                 StyleOfPlay:UpdateOtherPageTab(BottomKeyInfo)
--             end
--         end
--     end
--     -- 处理手柄 UI 显示
--     if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
--         self.Btn_Reward:SetGamePadImg("Y")
--         self.Btn_Reward:SetGamePadVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
--     end
-- end

-- return M
