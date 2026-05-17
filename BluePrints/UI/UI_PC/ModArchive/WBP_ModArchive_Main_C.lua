require "UnLua"
local EMCache = require "EMCache.EMCache"

local WBP_ModArchive_Main_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_ModArchive_Main_C:Construct()
    self.Btn_Close:Init("Close", self, self.OnCloseBtnClick)
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self.CurInputDeviceType = self.GameInputModeSubsystem:GetCurrentInputType()
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        return
    end
    if self.CurInputDeviceType and self.CurInputDeviceType ~= ECommonInputType.GamePad then
        self:SwitchComKeyTipsState(1)
    else
        self:SwitchComKeyTipsState(3)
    end
end

function WBP_ModArchive_Main_C:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    self.Owner = ...
    DebugPrint("魔之匣 ", self.Owner)
    self.CurTipsIndex = 1
    self.Group_Page:ClearChildren()
    self.IsClosing = false  -- 是否正在关闭
    self.CurTab = 0  -- 当前是第几个Tab
    self.TabMain = {}   -- 存一下123对应的三个界面
    self.MaxPhase = #DataMgr.ModTaskPhase -- 任务页阶段总数
    self.TaskHasReddotIndex = {} -- 任务页哪些阶段应该有红点
    self:RefreshData()  -- 红点和弹窗相关
    AudioManager(self):PlayUISound(self, "event:/ui/common/mozhixia_open", "ModArchiveOpen", nil)

    EventManager:AddEvent(EventID.OnGuideEnd, self, self.OnGuideEnd)

    -- self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
    self:BindToAnimationFinished(self.In, {self, self.OnFirstInFinished})
    self:PlayAnimation(self.In)
    self:InitArchiveTab()  -- 初始化上方Tab

    -- self:InitTaskPanel()  -- 初始化任务页
    -- self.Com_KeyTips:SetVisibility(ESlateVisibility.Collapsed)
    
    self.Text_Title:SetText(GText("MAIN_UI_MODGUIDEBOOK"))

    self:RefreshDot()

    if self.CurInputDeviceType ~= ECommonInputType.GamePad then
        self:BlockAllUIInput(true,"SP_DisplayOnly")
    end

    self:AddTabReddotListen()
end

-- 初始化上方Tab
function WBP_ModArchive_Main_C:InitArchiveTab()
    DebugPrint("zwkk InitArchiveTab")
    local Tabs = {}
    Tabs[1] = {Text = GText("UI_ModGuideBook_Task"), Idx = 1}
    Tabs[2] = {Text = GText("UI_ModGuideBook_Archive_Mod"), Idx = 2}
    -- Tabs[3] = {Text = GText("UI_ModGuideBook_Recommend"), Idx = 3}
    local ConfigData = {
        Owner = self,
        LeftKey = "Q",
        RightKey = "E",
        LeftGamePadKey = "LeftShoulder",
        RightGamePadKey = "RightShoulder",
        ChildWidgetName = "ModArchiveTabSubItem",
        Tabs = Tabs,
        SoundFuncReceiver = self,
        SoundFunc = self.MainTabClickSoundFunc
    }
    self.ModArchive_Tab:Init(ConfigData)
    self.ModArchive_Tab:BindEventOnTabSelected(self, self.OnTabSelected)
    local TabId = self:CheckTabId()
    self.ModArchive_Tab:SelectTab(TabId)
    --self.ModArchive_Tab:PlayAnimation(self.ModArchive_Tab.In)
end

-- 上方Tab点击事件，切换Panel
function WBP_ModArchive_Main_C:OnTabSelected()
    DebugPrint("zwkk OnTabSelected", self.CurTab)
    local NextTab = self.ModArchive_Tab:GetCurrentTabIndex()
    if NextTab ~= self.CurTab then
        DebugPrint("zwkk OnTabSelected111", self.CurTab)
        if self.CurTab == 2 and self.TabMain[2] then
            self.TabMain[2]:PreClose()
        end
        self.CurTab = NextTab
        self:PreSwitchPanel(self.CurTab)
        if self.TabMain[self.CurTab] then
            self.TabMain[self.CurTab]:OnSelected()
        else
            if not self.TabMain[self.CurTab] then
                if self.CurTab == 1 then
                    self:InitTaskPanel()
                elseif self.CurTab == 2 then
                    self:InitArchivePanel()
                elseif self.CurTab == 3 then
                    self:InitRecommendPanel()
                end
            end
        end
        if self.CurTab == 2 and self.TabMain[2] then
            self.TabMain[2]:AddTabReddotListen()
        elseif self.TabMain[2] then
            self.TabMain[2]:RemoveTabReddotListen()
        end
        if self.CurTab == 1 then
            AudioManager(self):PlayUISound(self, "event:/ui/common/mozhixia_state_change_in", nil, nil)
        end
    end
end

-- 初始化任务页
function WBP_ModArchive_Main_C:InitTaskPanel()
    self.TaskPanel = self:CreateWidgetNew("ModArchiveTask")
    self.Group_Page:AddChild(self.TaskPanel)
    local OverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(self.TaskPanel)
    OverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
    OverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
    local Params = {
        Owner = self,
        Index = 1
    }
    self.TaskPanel:OnSelected(Params)
    self.TabMain[1] = self.TaskPanel
end

-- 初始化图鉴页
function WBP_ModArchive_Main_C:InitArchivePanel()
    self.ArchivePanel = self:CreateWidgetNew("ModArchiveArchive")
    self.Group_Page:AddChild(self.ArchivePanel)
    local OverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(self.ArchivePanel)
    OverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
    OverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
    local Params = {
        Owner = self,
        Index = 2
    }
    self.ArchivePanel:OnSelected(Params)
    self.TabMain[2] = self.ArchivePanel
end

-- 初始化推荐页
function WBP_ModArchive_Main_C:InitRecommendPanel()
    self.RecommendPanel = self:CreateWidgetNew("ModArchiveRecommend")
    self.Group_Page:AddChild(self.RecommendPanel)
    local OverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(self.RecommendPanel)
    OverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
    OverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
    local Params = {
        Owner = self,
        Index = 3
    }
    self.RecommendPanel:OnSelected(Params)
    self.TabMain[3] = self.RecommendPanel
end


-- 切页时关掉另外两页的内容
function WBP_ModArchive_Main_C:PreSwitchPanel(Idx)
    for i = 1, 3 do
        if i ~= Idx then
            if self.TabMain[i] then
                self.TabMain[i]:SetVisibility(ESlateVisibility.Collapsed)
                -- self.TabMain[i]:Close()
            end
        end
    end
end

-- 检查手册任务是否全部完成，完成的情况下直接切到图鉴页
function WBP_ModArchive_Main_C:CheckTabId()
    local Data = DataMgr.ModGuideBookTask
    local Avatar = GWorld:GetAvatar()
    for i, v in pairs(Data) do
        DebugPrint("123123456 ", i, v)
        local ModBookQuest = Avatar.ModBookQuests:GetModBookQuest(i)
        if ModBookQuest.IsComplete and not ModBookQuest:IsComplete() then
            return 1
        end
    end
    return 2
end

function WBP_ModArchive_Main_C:OnCloseBtnClick()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_return", nil, nil)
    self:OnClose()
end

-- 将要关闭，播放动画，绑定关闭事件
function WBP_ModArchive_Main_C:OnClose()
    if self.IsClosing then return end
    self.IsClosing = true
    -- if (self.ParentWidget) and (self.ParentWidget.bIsFocusable) and (not self.DontFocusParentWidget)then 
    --     self.ParentWidget:SetFocus() 
    -- end
    self:PlayAnimation(self.Out)
    self:BindToAnimationFinished(self.Out, {self, self.Close})
    AudioManager(self):SetEventSoundParam(self, "ModArchiveOpen", { ToEnd = 1 })
    AudioManager(self):StopSound(self, "ModArchiveOpen")
end

-- 真正关闭
function WBP_ModArchive_Main_C:Close()
    DebugPrint("zwkkk Close")
    if self.TabMain[2] then
        self.TabMain[2]:PreClose()
    end
    EventManager:FireEvent(EventID.OnMainUIReddotUpdate)
    self:RemoveTabReddotListen()
    WBP_ModArchive_Main_C.Super.Close(self)
end

function WBP_ModArchive_Main_C:MainTabClickSoundFunc()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_02", nil, nil)
end


-- 有Tips打开了，设置一些可见性相关
function WBP_ModArchive_Main_C:OnTipsOpenChanged(bIsOpen)
    DebugPrint("zwkkk OnTipsOpenChanged", bIsOpen, self:GetName())
    if not self.CurInputDeviceType or self.CurInputDeviceType ~= ECommonInputType.GamePad then return end
    if bIsOpen then
        self.Com_KeyTips:SetVisibility(ESlateVisibility.Collapsed)
        self.ModArchive_Tab.Key_Left:SetVisibility(ESlateVisibility.Hidden)
        self.ModArchive_Tab.Key_Right:SetVisibility(ESlateVisibility.Hidden)
        -- self:SwitchComKeyTipsState(1)
    else
        self.Com_KeyTips:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.ModArchive_Tab.Key_Left:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.ModArchive_Tab.Key_Right:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        -- self:SwitchComKeyTipsState(2)
    end
end

-- 只隐藏切页键
function WBP_ModArchive_Main_C:HideTabKey(Hide)
    if not self.CurInputDeviceType or self.CurInputDeviceType ~= ECommonInputType.GamePad then return end
    if Hide then
        self.ModArchive_Tab.Key_Left:SetVisibility(ESlateVisibility.Hidden)
        self.ModArchive_Tab.Key_Right:SetVisibility(ESlateVisibility.Hidden)
    else
        self.ModArchive_Tab.Key_Left:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.ModArchive_Tab.Key_Right:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end

-- 全部领取
function WBP_ModArchive_Main_C:OnClickSpace()
    if self.TabMain[self.CurTab] and self.TabMain[self.CurTab].OnSpaceBarKeyDown then
        self.TabMain[self.CurTab]:OnSpaceBarKeyDown()
    end
end

-- In播放结束
function WBP_ModArchive_Main_C:OnFirstInFinished()
    -- self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
    if self.ShouldShowTips and not CommonUtils:IfExistSystemGuideUI(self) then
        self:LoadUINew("ModArchiveUpdateTips", self.TipsModShows, self.TipsModUnlocks, self)
    else
        self.InFinished = true
    end
    -- 刷新一下
    if self.TabMain and self.TabMain[self.CurTab] and self.TabMain[self.CurTab].HasSelected and self.TabMain[self.CurTab].OnMainInFinish then
        self.TabMain[self.CurTab]:OnMainInFinish()
    end
    self:BlockAllUIInput(false)
end

-- 弹出的更新Tips界面结束时
function WBP_ModArchive_Main_C:OnShowTipsClose()
    self.InFinished = true
    self.ShouldShowTips = false
    -- 刷新一下
    if self.TabMain and self.TabMain[self.CurTab] and self.TabMain[self.CurTab].HasSelected and self.TabMain[self.CurTab].OnShowTipsClose then
        self.TabMain[self.CurTab]:OnShowTipsClose()
    end
end

-- 红点和弹窗信息
function WBP_ModArchive_Main_C:RefreshData()
    self.RewardGets = {}  -- 每一个图鉴组是否可领取奖励

    -- 红点相关
    local Avatar = GWorld:GetAvatar()
    local ModBookCompleteConditions = {}
    local PreCompleteConditions = EMCache:Get("ModBookCompleteConditions", true)
    local ModShows = {} -- 应该显示揭晓弹窗的ModIds
    local ModUnlocks = {} -- 应该显示解锁弹窗的ModIds
    local ModBookCanGetRewards = {}
    local ModArchiveNewByViewState = false
    self.ModBookModsViewState = EMCache:Get("ModBookModsViewState", true) -- 每个Mod的查看过的情况
    if not self.ModBookModsViewState then
        self.ModBookModsViewState = {}
    end

    local Data = DataMgr.ModGuideBookArchive
    for i, v in pairs(Data) do
        -- 存已经完成的，1：揭晓条件是否true  2：解锁条件是否true
        if v.ShowCondition and ConditionUtils.CheckCondition(Avatar, v.ShowCondition) then
            --i = tostring(i)
            if not ModBookCompleteConditions[i] then
                ModBookCompleteConditions[i] = {}
            end
            ModBookCompleteConditions[i][1] = true
            ModBookCompleteConditions[i][2] = ModBookCompleteConditions[i][2] or false

            if not PreCompleteConditions or not PreCompleteConditions[i] or not PreCompleteConditions[i][1] then
                for k = 1, #v.ModList do
                    table.insert(ModShows, v.ModList[k])
                end
            end
        end
        if v.UnlockCondition and ConditionUtils.CheckCondition(Avatar, v.UnlockCondition) then
            --i = tostring(i)
            if not ModBookCompleteConditions[i] then
                ModBookCompleteConditions[i] = {}
            end
            ModBookCompleteConditions[i][2] = true
            ModBookCompleteConditions[i][1] = ModBookCompleteConditions[i][1] or false

            if not PreCompleteConditions or not PreCompleteConditions[i] or not PreCompleteConditions[i][2] then
                for k = 1, #v.ModList do
                    table.insert(ModUnlocks, v.ModList[k])
                end
            end
        end

        -- 判断有条件的组中的Mod的New状态，true就是还没点开过
        if v.ShowCondition or v.UnlockCondition then
            if (v.ShowCondition and ConditionUtils.CheckCondition(Avatar, v.ShowCondition)) or (v.UnlockCondition and ConditionUtils.CheckCondition(Avatar, v.UnlockCondition)) then
                --i = tostring(i)
                if not self.ModBookModsViewState[i] then
                    self.ModBookModsViewState[i] = {}
                    for Id = 1, #v.ModList do
                        local ModId = v.ModList[Id]
                        --self.ModBookModsViewState[i][tostring(ModId)] = true
                        self.ModBookModsViewState[i][ModId] = true
                        ModArchiveNewByViewState = true
                    end
                end
            end
        end

        local CanGet = true
        -- 有揭晓条件或解锁条件的，没达成条件不考虑红点
        if (v.ShowCondition and not ConditionUtils.CheckCondition(Avatar, v.ShowCondition)) or (v.UnlockCondition and not ConditionUtils.CheckCondition(Avatar, v.UnlockCondition)) then
            CanGet = false
        else
            for k = 1, #v.ModList do
                local ModId = v.ModList[k]
                if not Avatar.HoldMods[ModId] then
                    CanGet = false
                    break
                end
            end
        end
        if CanGet and Avatar.HoldModRewards[i] then
            CanGet = false
        end
        self.RewardGets[i] = CanGet
        --i = tostring(i)
        ModBookCanGetRewards[i] = CanGet
        if CanGet then
            self.ShowArchiveReddot = true -- 图鉴页红点
        end
    end

    EMCache:Set("ModBookCompleteConditions", ModBookCompleteConditions, true)
    EMCache:Set("ModBookCanGetRewards", ModBookCanGetRewards, true)
    EMCache:Set("ModBookModsViewState", self.ModBookModsViewState, true)
    EMCache:Set("ModArchiveNewByViewState", ModArchiveNewByViewState, true)
    
    -- 新揭晓/新解锁弹窗
    if #ModShows > 0 or #ModUnlocks > 0 then
        -- 加载弹窗
        DebugPrint("加载弹窗 ")
        self.ShouldShowTips = true
        self.TipsModShows = ModShows
        self.TipsModUnlocks = ModUnlocks
    end

end

-- 整合刷新New和红点信息
function WBP_ModArchive_Main_C:RefreshDot()
    self:RefreshNewdot()
    self:RefreshReddot()
end

function WBP_ModArchive_Main_C:RefreshReddot()
    -- 每个Mod组的领奖情况
    local ModBookCanGetRewards = EMCache:Get("ModBookCanGetRewards", true) or {}
    local Groups = DataMgr.ModGuideBookArchive

    local SubTabRed = {}  -- 图鉴页子Tab上哪些该有红点
    local ArchiveTabRed = false -- 图鉴Tab上是否应该有红点
    for i, v in pairs(ModBookCanGetRewards) do
        if v then
            -- 这个组所在的子Tab和主Tab都应该有红点
            DebugPrint("应该有红点 ", tonumber(i))
            local ArchiveId = tonumber(i)
            local TabId = DataMgr.ModGuideBookArchive[ArchiveId].TabId
            SubTabRed[TabId] = true
            ArchiveTabRed = true
        end
    end

    -- 任务页红点判断
    local TaskTabRed = false -- 任务Tab是否有红点
    local ReddotNode = "ModArchive_Task"
    local Avatar = GWorld:GetAvatar()
    self.TaskHasReddotIndex = {}
    ReddotManager.ClearLeafNodeCount(ReddotNode)
    for PhaseId, Info in pairs(DataMgr.ModPhaseId2QuestId) do
        local TaskReddotNum = 0
        local CurPhaseTaskAllComplete = true
        for _, TaskId in pairs(Info) do
            local TaskAvatarInfo = Avatar.ModBookQuests[TaskId]
            if TaskAvatarInfo and TaskAvatarInfo.FinishTime ~= 0 then
                if not TaskAvatarInfo.RewardsGot then
                    -- 该任务已完成但未领奖
                    self.TaskHasReddotIndex[PhaseId] = true
                    TaskTabRed = true
                    TaskReddotNum = TaskReddotNum + 1
                end
            else
                CurPhaseTaskAllComplete = false
            end
        end
        if CurPhaseTaskAllComplete and not Avatar.ModBookQuestPhaseRewardsGot[PhaseId] then
            -- 任务全都完成，但阶段奖励还没领，也应该有红点
            self.TaskHasReddotIndex[PhaseId] = true
            TaskTabRed = true
            TaskReddotNum = TaskReddotNum + 1
        end
        if TaskReddotNum > 0 then
            local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotNode)
            if not CacheDetail then
                CacheDetail = {}
            end
            if not CacheDetail.PhaseId then
                CacheDetail.PhaseId = PhaseId
            end
            ReddotManager.IncreaseLeafNodeCount(ReddotNode, TaskReddotNum, CacheDetail)
        end
    end


    -- Tab红点已由红点树接管

    -- -- 设置总Tab的红点
    -- if ArchiveTabRed then
    --     self.ModArchive_Tab:ShowTabRedDot(2, false, true)
    -- end
    -- if TaskTabRed then
    --     self.ModArchive_Tab:ShowTabRedDot(1, false, true)
    -- else
    --     self.ModArchive_Tab:ShowTabRedDot(1, false, false)
    -- end

    -- -- 设置子Tab的红点
    -- if self.TabMain[2] then
    --     self.TabMain[2]:RefreshTabReddot(SubTabRed)
    -- end
    if self.TabMain[1] then
        self.TabMain[1]:RefreshTabReddot()
    end
end


function WBP_ModArchive_Main_C:RefreshNewdot()
    local ModBookModsViewState = EMCache:Get("ModBookModsViewState", true) or {} -- 每个Mod的查看过的情况
    local ModArchiveNewByViewState = false

    local HasNewTabs = {}  -- 哪些图鉴组应该有New
    local SubTabNew = {}  -- 图鉴页子Tab上哪些该有New
    local MainTabNew = false -- 总Tab上是否应该有New
    for i, v in pairs(ModBookModsViewState) do
        -- i：图鉴组Id   v：这个组里的ModId是否记录为New
        for ModIdString, IsNew in pairs(v) do
            if IsNew then
                DebugPrint("哪个是new ", ModIdString, i)
                -- 这个组（i）应该有New标
                local ArchiveId = tonumber(i)
                HasNewTabs[ArchiveId] = true
                if DataMgr.ModGuideBookArchive[ArchiveId] and DataMgr.ModGuideBookArchive[ArchiveId].TabId then
                    local TabId = DataMgr.ModGuideBookArchive[ArchiveId].TabId
                    if not SubTabNew[TabId] then
                        SubTabNew[TabId] = true
                    end
                    
                    MainTabNew = true
                    ModArchiveNewByViewState = true
                end
            end
        end
    end
    -- -- 设置总Tab的New
    -- if MainTabNew then
    --     self.ModArchive_Tab:ShowTabRedDot(2, true, false)
    -- else
    --     self.ModArchive_Tab:ShowTabRedDot(2, false, false)
    -- end

    -- -- 设置子Tab的New
    -- if self.TabMain[2] then
    --     self.TabMain[2]:RefreshTabNew(SubTabNew)
    -- end

    EMCache:Set("ModArchiveNewByViewState", ModArchiveNewByViewState, true)
end

function WBP_ModArchive_Main_C:AddTabReddotListen()
    -- 任务页红点监听
    local ReddotName = "ModArchive_Task"
    if ReddotName then
        ReddotManager.AddListenerEx(ReddotName, self, function(self, Count, RdType, RdName)
            if Count>0 then
                if RdType == EReddotType.Normal then
                    self.ModArchive_Tab:ShowTabRedDot(1, false, true)
                elseif RdType == EReddotType.New then
                    self.ModArchive_Tab:ShowTabRedDot(1, true, false)
                end
            else
                self.ModArchive_Tab:ShowTabRedDot(1, false, false)
            end
        end)
    end

    -- 图鉴页红点监听
    local ReddotName = "ModArchive_Archive"
    if ReddotName then
        ReddotManager.AddListenerEx(ReddotName, self, function(self, Count, RdType, RdName)
            if Count>0 then
                if RdType == EReddotType.Normal then
                    self.ModArchive_Tab:ShowTabRedDot(2, false, true)
                elseif RdType == EReddotType.New then
                    self.ModArchive_Tab:ShowTabRedDot(2, true, false)
                end
            else
                self.ModArchive_Tab:ShowTabRedDot(2, false, false)
            end
        end)
    end
end

function WBP_ModArchive_Main_C:RemoveTabReddotListen()
    ReddotManager.RemoveListener("ModArchive_Task", self)
    ReddotManager.RemoveListener("ModArchive_Archive", self)
    if self.TabMain and self.TabMain[2] then
        self.TabMain[2]:RemoveTabReddotListen()
    end
end

function WBP_ModArchive_Main_C:OnGuideEnd()
    EventManager:RemoveEvent(EventID.OnGuideEnd, self)
    if self.TabMain and self.TabMain[self.CurTab] and self.TabMain[self.CurTab].OnGuideEnd then
        self.TabMain[self.CurTab]:OnGuideEnd()
    end
end

function WBP_ModArchive_Main_C:Destruct()
    EventManager:RemoveEvent(EventID.OnGuideEnd, self)
    WBP_ModArchive_Main_C.Super.Destruct(self)
end








-- 监听PC/手柄按键
function WBP_ModArchive_Main_C:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        -- DebugPrint("zwk    Key_IsGamepadKey", InKeyName)
        if self.InFinished then
            IsEventHandled = self:Handle_OnGamePadDown(InKeyName)
        end
    else
        if self.InFinished then
            IsEventHandled = self:Handle_OnPCDown(InKeyName)
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

-- PC按键按下
function WBP_ModArchive_Main_C:Handle_OnPCDown(InKeyName)
    -- DebugPrint("zwkkk Handle_OnPCDown",InKeyName )
    if (InKeyName == "Escape") then
        self:OnClose()
        return true
    elseif (InKeyName == "Q") then
        self.ModArchive_Tab:TabToLeft()
        return true
    elseif (InKeyName == "E") then
        self.ModArchive_Tab:TabToRight()
        return true
    end
    return false
end

-- 手柄按键按下
function WBP_ModArchive_Main_C:Handle_OnGamePadDown(InKeyName)
    -- DebugPrint("zwkkk  Handle_OnGamePadDown", InKeyName, self:GetName())
    if (InKeyName == "Gamepad_DPad_Up" or InKeyName == "Gamepad_LeftStick_Up") then

        return true
    elseif (InKeyName == "Gamepad_DPad_Down" or InKeyName == "Gamepad_LeftStick_Down") then

        return true
    elseif (InKeyName == "Gamepad_DPad_Left" or InKeyName == "Gamepad_LeftStick_Left") then

        return true
    elseif (InKeyName == "Gamepad_DPad_Right" or InKeyName == "Gamepad_LeftStick_Right") then

        return true
    elseif (InKeyName == "Gamepad_FaceButton_Top") then

        return true
    elseif (InKeyName == "Gamepad_FaceButton_Left") then
        
        return true
    elseif (InKeyName == "Gamepad_FaceButton_Right") then --返回
        if self.TabMain and self.TabMain[self.CurTab] and self.TabMain[self.CurTab].CurWidget and self.TabMain[self.CurTab].CurWidget.IsSelected then
            return false
        end
        DebugPrint("zwjkl Close")
        self:OnClose()
        return true
    elseif (InKeyName == "Gamepad_LeftShoulder") then -- 左切页
        self.ModArchive_Tab:TabToLeft()
        return true
    elseif (InKeyName == "Gamepad_RightShoulder") then -- 右切页
        self.ModArchive_Tab:TabToRight()
        return true
    end
    return false
end

-- function WBP_ModArchive_Main_C:OnFocusReceived(MyGeometry, InFocusEvent)
--     DebugPrint("zwkkk 0000")
--     -- -- 刷新一下
--     if self.TabMain and self.TabMain[self.CurTab] and self.TabMain[self.CurTab].HasSelected and self.TabMain[self.CurTab].RefreshInfo then
--         self.TabMain[self.CurTab]:RefreshInfo()
--     end
--     return WBP_ModArchive_Main_C.Super.OnFocusReceived(self, MyGeometry, InFocusEvent)
-- end

function WBP_ModArchive_Main_C:ReceiveEnterState(StackAction)
    WBP_ModArchive_Main_C.Super.ReceiveEnterState(self, StackAction)
    DebugPrint("zwkkk ReceiveEnterState", StackAction)
    -- 刷新一下
    if self.TabMain and self.TabMain[self.CurTab] and self.TabMain[self.CurTab].HasSelected and self.TabMain[self.CurTab].RefreshInfo then
        self:RefreshData()
        self:RefreshDot()
        self.TabMain[self.CurTab]:RefreshInfo()
        if self.TabMain[self.CurTab].RefreshLRBtnState then
            self.TabMain[self.CurTab]:RefreshLRBtnState()
        end
    end
end


function WBP_ModArchive_Main_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    DebugPrint("zwkkk   RefreshOpInfoByInputDevice ", CurInputDevice, CurGamepadName)
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        return
    end
    --更新输入模式
    self.CurInputDeviceType = CurInputDevice
    self.CurGamepadName = CurGamepadName
    --更新UI
    self:InitBtnTipsUI()
    -- 切到手柄
    if self.CurInputDeviceType == ECommonInputType.GamePad and self.TabMain and self.TabMain[self.CurTab] and self.TabMain[self.CurTab].OnSwitchToGamepad then
        self.TabMain[self.CurTab]:OnSwitchToGamepad()
    end
end

function WBP_ModArchive_Main_C:InitBtnTipsUI()
    if self.CurInputDeviceType and self.CurInputDeviceType == ECommonInputType.GamePad then
        -- self.Com_KeyTips:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.ModArchive_Tab.Key_Left:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.ModArchive_Tab.Key_Right:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self:SwitchComKeyTipsState(3)
        -- 是第二个页面的话，调一下刷新全部领取状态

    else
        -- self.Com_KeyTips:SetVisibility(ESlateVisibility.Collapsed)
        self:SwitchComKeyTipsState(1)
    end
end

function WBP_ModArchive_Main_C:SwitchComKeyTipsState(Index)
    if self.CurInputDeviceType and self.CurInputDeviceType == ECommonInputType.Touch then
        return
    end
    if not self.Com_KeyTips then return end
    DebugPrint("zwkkjjkk      Index", Index)
    self.CurTipsIndex = Index
    if Index == 1 then
        -- 1 只有ESC键
        local KeyInfo = {
            { 
                KeyInfoList = {{Type = "Text", Text = "Esc", ClickCallback = self.OnClose, Owner = self}},
                Desc = GText("UI_BACK"),
            },
        }
        self.Com_KeyTips:UpdateKeyInfo(KeyInfo)
    elseif Index == 2 then
        -- 2 手柄 "查看详情" + "返回"
        local KeyInfo = {
            { 
                KeyInfoList  = {{Type = "Img", ImgShortPath = "A"}},
                Desc = GText("UI_Controller_CheckDetails"),
            },
            { 
                KeyInfoList  = {{Type = "Img", ImgShortPath = "B"}},
                Desc = GText("UI_BACK"),
            },
        }
        self.Com_KeyTips:UpdateKeyInfo(KeyInfo)
    elseif Index == 3 then
        -- 3 手柄 "选择" + "返回"
        local KeyInfo = {
            { 
                KeyInfoList  = {{Type = "Img", ImgShortPath = "A"}},
                Desc = GText("UI_CTL_Select"),
            },
            { 
                KeyInfoList  = {{Type = "Img", ImgShortPath = "B"}},
                Desc = GText("UI_BACK"),
            },
        }
        self.Com_KeyTips:UpdateKeyInfo(KeyInfo)
    elseif Index == 4 then
        -- 4 键盘 "全部领取" + "返回"
        local KeyInfo = {
            { 
                KeyInfoList  = {{Type = "Text", Text = "Space", ClickCallback = self.OnClickSpace, Owner = self}},
                Desc = GText("UI_CTL_ClaimALL"),
            },
            { 
                KeyInfoList = {{Type = "Text", Text = "Esc", ClickCallback = self.OnClose, Owner = self}},
                Desc = GText("UI_BACK"),
            },
        }
        self.Com_KeyTips:UpdateKeyInfo(KeyInfo)
    elseif Index == 5 then
        -- 5 手柄 "领取奖励" + 选择" + "返回"
        -- 注：现在不显示领取奖励了
        local KeyInfo = {
            -- {
            --     KeyInfoList  = {{Type = "Img", ImgShortPath = "X"}},
            --     Desc = GText("UI_CTL_Claim"),
            -- },
            { 
                KeyInfoList  = {{Type = "Img", ImgShortPath = "A"}},
                Desc = GText("UI_CTL_Select"),
            },
            { 
                KeyInfoList  = {{Type = "Img", ImgShortPath = "B"}},
                Desc = GText("UI_BACK"),
            },
        }
        self.Com_KeyTips:UpdateKeyInfo(KeyInfo)
    elseif Index == 6 then
        -- 6 手柄 "领取奖励" + "返回"
        local KeyInfo = {
            {
                KeyInfoList  = {{Type = "Img", ImgShortPath = "A"}},
                Desc = GText("UI_CTL_Claim"),
            },
            { 
                KeyInfoList  = {{Type = "Img", ImgShortPath = "B"}},
                Desc = GText("UI_BACK"),
            },
        }
        self.Com_KeyTips:UpdateKeyInfo(KeyInfo)
    elseif Index == 7 then
        -- 7 手柄 "返回"
        local KeyInfo = {
            { 
                KeyInfoList  = {{Type = "Img", ImgShortPath = "B"}},
                Desc = GText("UI_BACK"),
            },
        }
        self.Com_KeyTips:UpdateKeyInfo(KeyInfo)
    end
end

return WBP_ModArchive_Main_C
