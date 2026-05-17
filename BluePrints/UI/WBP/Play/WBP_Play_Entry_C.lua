--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"
---@type WBP_Play_Entry_P_C|BP_UIState
local WBP_Play_Entry_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_Play_Entry_C:Initialize(Initializer)
    self.Super.Initialize(self)
    self.CurSubUI = nil
    self.CurTabId = nil
    self.NpcId = 910003
    self.IsNeedPlayNpcAnim = true
    self.RecoveringCamera = false
    self.AllTabInfo = {}
    self.IndexToWidgetName = {}
    self.WidgetNameToIndex = {}
    self.SubUI = {}
    self.DefaultSubUIName = "NewDeputeRoot"
    self.AllExcelTabInfo = {
        DataMgr.PlayTab,
    }
    self.DisplayTeamHeadUIWidgetName = {
        DungeonSelect = 1,
        NewDeputeRoot = 1,
        HardBossMain = 1,
    }
    self.IsKeyEventOnGamePad = true

    local PlayerAvatar = GWorld:GetAvatar()
    if not PlayerAvatar then return false end

    -- 如果新手任务未完成，优先进入 StarterQuest
    if not ActivityUtils.CheckStarterQuestAllDone() then
        self.DefaultSubUIName = "PlayTaskRoot"
        return
    end

    local DailyInitLevel = PlayerAvatar.DailyInitLevel
    -- 查找匹配的等级奖励表
    local TargetLevel = nil
    local maxLevel = nil
    local prevLevel = nil

    for lv, _ in pairs(DataMgr.DailyGoalReward) do
        if not maxLevel or lv > maxLevel then
            maxLevel = lv
        end

        if lv == DailyInitLevel then
            TargetLevel = lv
            break
        elseif lv > DailyInitLevel then
            TargetLevel = prevLevel
            break
        end

        prevLevel = lv
    end

    -- 默认使用最大等级
    if not TargetLevel then
        TargetLevel = maxLevel
    end

    local DailyGoalReward = DataMgr.DailyGoalReward[TargetLevel]
    local IsGetAllDailyReward = true
    for _,DailyData in pairs(DailyGoalReward) do
        local State = PlayerAvatar.DailyTaskProgress[DailyData.RequiredActiveness]
        if State ~= CommonConst.DailyTaskState.GetReward then 
            IsGetAllDailyReward = false
            break
        end
    end
    -- 根据当前任务进度判断默认子界面
    self.DefaultSubUIName = IsGetAllDailyReward and "NewDeputeRoot" or "PlayTaskRoot"
end

function WBP_Play_Entry_C:ReceiveEnterState(StackAction)
    self.Super.ReceiveEnterState(self, StackAction)
    if self.TeamHeadUI then
        self.TeamHeadUI:OnFocusLost()
    end
    -- DebugPrint(DebugTag, LXYTag, "EnterState", StackAction, self.IsInit)
    EventManager:FireEvent(EventID.EntryReceiveEnterState,StackAction)
end

function WBP_Play_Entry_C:ReceiveExitState(StackAction)
    self.Super.ReceiveExitState(self, StackAction)
    -- if StackAction == 1 then

    -- end
     --DebugPrint(DebugTag, LXYTag, "ExitState", StackAction, self.IsInit)
end
function WBP_Play_Entry_C:RecoverCamera()
    if not self.RecoveringCamera then
		self.RecoveringCamera = true
	    if self.IsHome then
	    UIManager(self):SwitchFixedCamera(false, self.NpcId,"StyleOfPlay",self,"StyleOfPlay", 
	    { bDestroyNpc = true, IsHaveInOutAnim = self.IsNeedPlayNpcAnim })
	        self:PlayNPCAnim(21000502)
            self:DoRecoverCamera()
	    else
            if UIManager(self):StateCount() > 1 then
                self.IsNeedPlayNpcAnim = false
            else
                self.IsNeedPlayNpcAnim = true
            end
	        UIManager(self):SwitchUINpcCamera(false, "StyleOfPlay", self.NpcId,
	            { bDestroyNpc = true, IsHaveInOutAnim = self.IsNeedPlayNpcAnim })
             self:DoRecoverCamera()
	    end
    end
end
function WBP_Play_Entry_C:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    if self.Rouge_Points then
        self.Rouge_Points:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self.OpenKey = CommonUtils:GetActionMappingKeyName("OpenPlay")
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "SystemOpenSound", nil)
    self:PlayBaiAnim()
    self:PlayInAnim()
    local DefaultSubUIName = ...
    if DefaultSubUIName then
        self:OpenSubUI(DefaultSubUIName)
    elseif self.DefaultSubUIName then
        self:OpenSubUI(self.DefaultSubUIName)
    end

    local AttachWidget = self:GetAttachWidget()
    if not self.TeamHeadUI then
        self.TeamHeadUI = TeamController:OpenHeadUI(AttachWidget)
        self.TeamHeadUI.OnTeamMainFocusChanged = function(bFocused)
            local Visibility = bFocused and "Collapsed" or "SelfHitTestInvisible"
            local KeyWidgets = {
                self.ComTab.Key_Left,
                self.ComTab.Key_Right,
                self.ComTab.Com_KeyTips.Panel_Key,
                self.ComTab.WBP_Com_Tab_ResourceBar.KeyImg_GamePad,
                self.ComTab.WBP_Com_Tab_ResourceBar.Tip_GamePad.Key,
            }
            if self.CurTabId == "NewDeputeRoot" then
                local DeputeWidget = self.CurSubUI
                if DeputeWidget.DeputeTab:IsVisible() then
                    table.insert(KeyWidgets, DeputeWidget.DeputeTab.Key_Left)
                    table.insert(KeyWidgets, DeputeWidget.DeputeTab.Key_Right)
                end
                table.insert(KeyWidgets, self.ComTab.Group_Chat:GetChildAt(0).WS_Key)
            end
            if self.CurTabId == "DungeonSelect" then
                local DeputeWidget = self.CurSubUI
                if DeputeWidget.Tab_Info:IsVisible() then
                    table.insert(KeyWidgets, DeputeWidget.Tab_Info.Key_Left)
                    table.insert(KeyWidgets, DeputeWidget.Tab_Info.Key_Right)
                end
                table.insert(KeyWidgets, DeputeWidget.Key_More_Gamepad)
                if DeputeWidget.Com_CheckBox_LeftText:IsVisible() then
                    table.insert(KeyWidgets, DeputeWidget.Com_CheckBox_LeftText.Com_KeyImg)
                end
                if DeputeWidget.Button_Multi:IsVisible() then
                    table.insert(KeyWidgets, DeputeWidget.Button_Multi.Key_GamePad)
                end
                if DeputeWidget.Button_Solo:IsVisible() then
                    table.insert(KeyWidgets, DeputeWidget.Button_Solo.Key_GamePad)
                end
                if DeputeWidget.List_Type:IsVisible() then
                    table.insert(KeyWidgets, DeputeWidget.Key_Qa_GamePad)
                    table.insert(KeyWidgets, DeputeWidget.Key_LT)
                    table.insert(KeyWidgets, DeputeWidget.Key_LR)
                end
                if DeputeWidget.DefaultList:IsVisible() then
                    table.insert(KeyWidgets, DeputeWidget.DefaultList.Preview.Panel_Controller)
                end
            end
            if self.CurTabId == "HardBossMain" then
                local DeputeWidget = self.CurSubUI
                if DeputeWidget.HB_Rewards:IsVisible() then
                    table.insert(KeyWidgets, DeputeWidget.Key_Rewards)
                end
                if DeputeWidget.Btn_Enter:IsVisible() then
                    table.insert(KeyWidgets, DeputeWidget.Btn_Enter.Key_GamePad)
                end
            end
            for _, KeyWidget in ipairs(KeyWidgets) do
                KeyWidget:SetVisibility(UIConst.VisibilityOp[Visibility])
            end
        end
        if self.DisplayTeamHeadUIWidgetName[self.CurTabId] then
            self.TeamHeadUI:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        else
            self.TeamHeadUI:SetVisibility(UIConst.VisibilityOp.Collapsed)
            AttachWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end
    -- self:PlayBaiAnim()
end

function WBP_Play_Entry_C:OnHardBossMainReddotChange()
    self:OnReddotChange("HardBossMain")
end

function WBP_Play_Entry_C:OnPlayCommonReddotChange()
    self:OnReddotChange("PlayCommon")
end
function WBP_Play_Entry_C:OnPlayTaskRootReddotChange()
    self:OnReddotChange("PlayTaskRoot")
end
function WBP_Play_Entry_C:OnReddotChange(SystemUIName)
    local Index = self.WidgetNameToIndex[SystemUIName]
    if Index then
        local TreeNode = ReddotManager.GetTreeNode(SystemUIName)
        local Reddot = false
        if TreeNode and TreeNode.Count > 0 then
            Reddot = true
        end

        local Item = self.ComTab.EMScrollBox_TabItem:GetChildAt(math.max(Index - 1, 0))
        if Item and Item.Info.WidgetUIName == SystemUIName then
            if Reddot then
                Item.Reddot:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            else
                Item.Reddot:SetVisibility(UE4.ESlateVisibility.Collapsed)
            end
        end
    end
end

function WBP_Play_Entry_C:PlayBaiAnim(StackAction)

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self:EnableTickWhenPaused(true)
    self.IsHome = Avatar:CheckSubRegionType(nil, CommonConst.SubRegionType.Home)
    if self.IsHome then
        --self:SwitchCamera()
        UIManager(self):SwitchFixedCamera(true,self.NpcId,"StyleOfPlay",self,"StyleOfPlay", 
        { bDestroyNpc = true, IsHaveInOutAnim = self.IsNeedPlayNpcAnim })

        self:PlayNPCAnim(21000501)
    else
        UIManager(self):SwitchUINpcCamera(true, "StyleOfPlay", self.NpcId, { IsHaveInOutAnim = self.IsNeedPlayNpcAnim })
    end
end

function WBP_Play_Entry_C:Construct()
    WBP_Play_Entry_C.Super.Construct(self)
end

function WBP_Play_Entry_C:Destruct()
    if self.CurTabId then
        SystemGuideManager:HideUIEvent(self.CurTabId) --todo 临时处理WidgetUI通知
    end
    --EventManager:FireEvent(EventID.UnLoadUI, "StyleOfPlay")
    AudioManager(self):StopSound(self, "SystemOpenSound")
    self:RecoverCamera()
    self.Super.Destruct(self)
end

function WBP_Play_Entry_C:PlayNPCAnim(NpcAnimId)
    local PlayNPC = UE4.ANpcCharacter.GetNpc(self, self.NpcId)
    if PlayNPC then
        if PlayNPC.NPCNameWidgetComponent then
            local NameWidget = PlayNPC.NPCNameWidgetComponent:GetWidget()
            if NameWidget then
                NameWidget:SetVisibility(UE4.ESlateVisibility.Collapsed)
            end
        end

        -- 隐藏商城白的对话气泡
        if PlayNPC.BubbleWidgetComponent then
            local BubbleWidget = PlayNPC.BubbleWidgetComponent:GetWidget()
            if BubbleWidget then
                BubbleWidget:SetVisibility(UE4.ESlateVisibility.Collapsed)
            end
        end

        -- 播放商城白入场动画
        PlayNPC:PlayUITalkAction(NpcAnimId)
    end
end

function WBP_Play_Entry_C:SwitchCamera(bPlayer)
    local PlayerController = UGameplayStatics.GetPlayerController(self, 0)
    if bPlayer then
        if IsValid(self.CameraHandle) then
            ULTweenBPLibrary.KillIfIsTweening(self, self.CameraHandle)
        end
        ---@type BP_PlayerCharacter_C
        local PlayerCharacter = UGameplayStatics.GetPlayerCharacter(self, 0)
        if PlayerCharacter then
            PlayerCharacter:SetActorHideTag("StyleOfPlay", false)
        end
    else
        ---@type BP_ShopCamera_C
        local ShopCamera = UGameplayStatics.GetActorOfClass(self, self.CameraClass)
        if ShopCamera then
            ShopCamera.Camera:K2_SetRelativeLocation(ShopCamera.DefaultLocation, false, nil, false)
            PlayerController:SetViewTargetWithBlend(ShopCamera, 0, EViewTargetBlendFunction.VTBlend_Linear, 0, false)
            self:MoveCamera(ShopCamera.Camera)
        end
        ---@type BP_PlayerCharacter_C
        local PlayerCharacter = UGameplayStatics.GetPlayerCharacter(self, 0)
        if PlayerCharacter then
            PlayerCharacter:SetActorHideTag("StyleOfPlay", true)
        end
    end
end

---@param Camera UCameraComponent
function WBP_Play_Entry_C:MoveCamera(Camera)
    local StartPosition = Camera.RelativeLocation
    local EndPosition = FVector(0)
    self.CameraHandle = ULTweenBPLibrary.Vector3To(self, { self, function(_, Value)
            Camera:K2_SetRelativeLocation(Value, false, nil, false)
        end },
        StartPosition, EndPosition, 0.5, 0, 17)
end

function WBP_Play_Entry_C:EnableTickWhenPaused(Value)
    local TweenActor = UE4.ALTweenActor.GetLTweenInstance(self:GetWorld())
    if Value then
        if TweenActor then
            TweenActor:SetTickableWhenPaused(true)
        end
        UE4.UGameplayStatics.GetPlayerController(self, 0).bShouldPerformFullTickWhenPaused = true
    else
        if TweenActor then
            TweenActor:SetTickableWhenPaused(false)
        end
        UE4.UGameplayStatics.GetPlayerController(self, 0).bShouldPerformFullTickWhenPaused = false
    end
end

function WBP_Play_Entry_C:PlayInAnim()
    if (self:IsAnimationPlaying(self.In)) then
        return
    end
    self:PlayAnimationForward(self.In)
end

function WBP_Play_Entry_C:OpenSubUI(WidgetUIName)
    local IfInitTab = true
    local IfUseSelectTab = false
    if self.CurrentExcelTabInfo then
        for _, TabInfo in pairs(self.CurrentExcelTabInfo) do
            if TabInfo.WidgetUI == WidgetUIName then
                IfInitTab = false
                IfUseSelectTab = true
            end
        end
    end
    if IfInitTab then
        local Flag = false
        for _, ExcelTabInfo in pairs(self.AllExcelTabInfo) do
            if Flag then
                break
            end
            for _, TabInfo in pairs(ExcelTabInfo) do
                if TabInfo.WidgetUI == WidgetUIName then
                    self.CurrentExcelTabInfo = ExcelTabInfo
                    Flag = true
                    break
                end
            end
        end
        if not Flag then
            self.CurrentExcelTabInfo = nil
            self:RemoveReddotListener()
        end
        IfInitTab = Flag
    end
    if IfInitTab then
        self:InitTabInfo()
        self:AddReddotListener()
        self:SelectTabByWidgetName(WidgetUIName)
        return self:GetSubUIByWidgetName(WidgetUIName)
    else
        if IfUseSelectTab then
            self:SelectTabByWidgetName(WidgetUIName)
            return self:GetSubUIByWidgetName(WidgetUIName)
        else
            return self:RealOpenSubUI({TabId = WidgetUIName})
        end
    end
end

function WBP_Play_Entry_C:InitTabInfo()
    local PlayTab = CommonUtils.Copy(self.CurrentExcelTabInfo)
    self.SortedTabInfo = {}
    for _, TabInfo in pairs(PlayTab) do
        table.insert(self.SortedTabInfo, TabInfo)
    end
    for _, TabInfo in pairs(self.SortedTabInfo) do
        TabInfo.IsLocked = true
        if TabInfo.TabUnlockRuleId then
            local UIUnlockRuleInfo = DataMgr.UIUnlockRule[TabInfo.TabUnlockRuleId]
            local UIUnlockRuleId = UIUnlockRuleInfo.UIUnlockRuleId
            local UIUnlockDesc = UIUnlockRuleInfo.UIUnlockDesc
            TabInfo.LockReasonText = GText(UIUnlockDesc)
            local Avatar = GWorld:GetAvatar()
            if Avatar and UIUnlockRuleId then
                TabInfo.IsLocked = not Avatar:CheckUIUnlocked(UIUnlockRuleId)
            end
        else
            TabInfo.IsLocked = false
        end
    end
    self:FinishInitTab()
end

function WBP_Play_Entry_C:FinishInitTab()
    self:SortTab()
    self:InitSortedTab()
    self:InitCommonTab()
end

function WBP_Play_Entry_C:SortTab()
    table.sort(self.SortedTabInfo, function(a, b)
        if a.IsLocked then
            if b.IsLocked then
                return a.Sequence > b.Sequence
            else
                return false
            end
        else
            if b.IsLocked then
                return true
            else
                return a.Sequence > b.Sequence
            end
        end
    end)
end

function WBP_Play_Entry_C:InitSortedTab()
    self.AllTabInfo = {}
    self.IndexToWidgetName = {}
    self.WidgetNameToIndex = {}
    for Index, TabInfo in pairs(self.SortedTabInfo) do
        local NewTabInfo = {}
        NewTabInfo.WidgetUIName = TabInfo.WidgetUI
        NewTabInfo.Text = GText(TabInfo.TabName)
        NewTabInfo.TabId = TabInfo.WidgetUI
        NewTabInfo.SortId = -Index
        NewTabInfo.Callback = "RealOpenSubUI"
        NewTabInfo.ItemDefaultCapcity = 999
        NewTabInfo.IsLocked = TabInfo.IsLocked
        NewTabInfo.LockReasonText = TabInfo.LockReasonText
        NewTabInfo.IconPath = TabInfo.Icon
        table.insert(self.AllTabInfo, NewTabInfo)
        self.IndexToWidgetName[Index] = TabInfo.WidgetUI
        self.WidgetNameToIndex[TabInfo.WidgetUI] = Index
    end
end

function WBP_Play_Entry_C:AddReddotListener()
    if self.IndexToWidgetName then
        for Index, WidgetName in ipairs(self.IndexToWidgetName) do
            if DataMgr.ReddotNode[WidgetName] then
                ReddotManager.AddListener(WidgetName, self, self["On" .. WidgetName .. "ReddotChange"])
            end
        end
    end
end

function WBP_Play_Entry_C:RemoveReddotListener()
    if self.IndexToWidgetName then
        for Index, WidgetName in ipairs(self.IndexToWidgetName) do
            if DataMgr.ReddotNode[WidgetName] then
                ReddotManager.RemoveListener(WidgetName, self)
            end
        end
    end
end

function WBP_Play_Entry_C:InitCommonTab()
    self.TabConfigData = {
        TitleName = GText("MAIN_UI_PLAY"),
        LeftKey = "Q",
        RightKey = "E",
        Tabs = self.AllTabInfo,
        DynamicNode = { "Back", "ResourceBar", "BottomKey" },
        StyleName = "TextImage",
        OwnerPanel = self,
        BackCallback = self.OnClickBack,
        BottomKeyInfo = {
            {
                KeyInfoList = {{Type = "Text", Text = "Esc", ClickCallback = self.OnClickBack, Owner = self}},
                GamePadInfoList = {{Type = "Img", ImgShortPath = "B"}},
                Desc = GText("UI_BACK"),
                bLongPress = false
            }
        },
        --InfoCallback = self.ShowIntro
    }
    self.ComTab:Init(self.TabConfigData, true)
    self.ComTab:BindEventOnTabSelected(self, self.RealOpenSubUI)

end



function WBP_Play_Entry_C:SelectTabByWidgetName(WidgetName)
    self:SelectTabById(WidgetName)
end

function WBP_Play_Entry_C:SelectTabById(TabId)
    self.ComTab:SelectTabById(TabId)
end

function WBP_Play_Entry_C:SelectTab(Index)
    self.ComTab:SelectTab(Index)
end

function WBP_Play_Entry_C:InitOtherPageTab(TabConfigData, ResoucesTab, DontPlayInAnim, Object, Callback)
    -- if not ResoucesTab then
    --     ResoucesTab = DataMgr.SystemUI["StyleOfPlay"].TabCoin
    -- end
    -- self.ComTab:OverrideTopResource(ResoucesTab)
    if (TabConfigData) then
        TabConfigData.OverridenTopResouces = ResoucesTab or DataMgr.SystemUI["StyleOfPlay"].TabCoin
    end
    self.ComTab:Init(TabConfigData, DontPlayInAnim)
    self.ComTab:BindEventOnTabSelected(Object, Callback)
end

--根据输入更新按键
function WBP_Play_Entry_C:UpdateOtherPageTab(BottomKeyInfo)
    if CommonUtils.GetDeviceTypeByPlatformName() ~= "Mobile" then
        self.ComTab:UpdateBottomKeyInfo(BottomKeyInfo)
    end
end

-- function WBP_Play_Entry_C:InitMainTab()
--     -- self.ComTab:OverrideTopResource()
--     if (self.TabConfigData) then
--         self.TabConfigData.OverridenTopResouces = nil
--     end
--     self.ComTab:Init(self.TabConfigData, true)
--     self.ComTab:BindEventOnTabSelected(self, self.RealOpenSubUI)
-- end

function WBP_Play_Entry_C:GetSubUIByWidgetName(WidgetName)
    if self.SubUI then
        return self.SubUI[WidgetName]
    end
end

function WBP_Play_Entry_C:RealOpenSubUI(WidgetInfo)
    local TabId = WidgetInfo.TabId
    if WidgetInfo.GetTabId then
        TabId = WidgetInfo:GetTabId()
    end
    --region 组队按钮只在部分界面显示
    local AttachWidget = self:GetAttachWidget()
    if self.TeamHeadUI then
        if self.DisplayTeamHeadUIWidgetName[TabId] then
            self.TeamHeadUI:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        else
            self.TeamHeadUI:SetVisibility(UIConst.VisibilityOp.Collapsed)
            AttachWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end
    --endregion
    if self.CurTabId == TabId then
        return self.CurSubUI
    end
    if self.CurTabId ~= nil then
        if self.CurSubUI:IsAnyAnimationPlaying() then
            self.CurSubUI:StopAllAnimations()
        end
        if self.CurSubUI.WBP_Play_PanelBG and self.CurSubUI.WBP_Play_PanelBG:IsAnyAnimationPlaying() then
            self.CurSubUI.WBP_Play_PanelBG:StopAllAnimations()
        end
        self.CurSubUI:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        if (self.CurSubUI.RetainerBox and self.CurSubUI.Panel_Level) then
            self.CurSubUI.Panel_Level:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        end
        -- if self.CurSubUI.RetainerBox_0 and self.CurSubUI.Bg_Group then
        --     self.CurSubUI.Bg_Group:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        -- end

        if self.CurSubUI.SecondaryPageName == TabId then
            self.CurSubUI:PlayAnimationForward(self.CurSubUI.Next)
        elseif self.CurSubUI.Out and self.CurTabId ~= "DungeonSelect" then  --DungeonSelect界面特殊处理 自己播Out
            self.CurSubUI:PlayAnimationForward(self.CurSubUI.Out)
        else
            self.CurSubUI:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        if self.CurSubUI.SwitchOut then
            self.CurSubUI:SwitchOut()
        end

        SystemGuideManager:HideUIEvent(self.CurTabId) --todo 临时处理WidgetUI通知
    end
    local PreTabId = self.CurTabId
    self.CurTabId = TabId
    if self.SubUI[self.CurTabId] == nil then
        local PlayerController = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
        local Player = PlayerController:GetMyPawn()
        local WidgetUIName = self.CurTabId
        if Player.UIModePlatform == "Mobile" then
            if DataMgr.WidgetUI[WidgetUIName .. "Mobile"] then
                WidgetUIName = WidgetUIName .. "Mobile"
            end
        else
            if DataMgr.WidgetUI[WidgetUIName .. "PC"] then
                WidgetUIName = WidgetUIName .. "PC"
            end
        end
        local Widget = self:CreateWidgetNew(WidgetUIName) --DungeonMapSelectPC
        if Widget ~= nil then
            if self.CurTabId == "HardBossMain" then
                self.Group_HardBoss:AddChild(Widget)
                Widget.ParentPanel = self.Group_HardBoss
            elseif self.CurTabId == "PlayCommon" then
                self.Group_Permanent:AddChild(Widget)
                Widget.ParentPanel = self.Group_Permanent
                -- elseif self.CurTabId == "DungeonMapSelect" then   --NewDeputeRoot
                --     self.Group_Play:AddChild(Widget)
                Widget.ParentPanel = self.Group_Play
            elseif self.CurTabId == "NewDeputeRoot" then
                Widget:PlayAnimation(self.In)
                self.Group_Depute:AddChild(Widget)
                Widget.ParentPanel = self.Group_Depute

            elseif self.CurTabId == "PlayTaskRoot" then
                self.Group_Task:AddChild(Widget)
                Widget.ParentPanel = self.Group_Task
            else
                self.Group_Root:AddChild(Widget)
                Widget.ParentPanel = self.Group_Root
            end
            Widget.Root = self
            Widget.WidgetInfo = WidgetInfo
            local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(Widget)
            if CanvasSlot then
                local Anchors = FAnchors()
                Anchors.Minimum = FVector2D(0, 0)
                Anchors.Maximum = FVector2D(1, 1)
                CanvasSlot:SetOffsets(FMargin(0, 0, 0, 0))
                CanvasSlot:SetAnchors(Anchors)
            end
            self.SubUI[self.CurTabId] = Widget
            if Widget.Out then
                Widget:BindToAnimationFinished(Widget.Out, { self, function()
                    Widget:SetVisibility(UE4.ESlateVisibility.Collapsed)
                end
                })
            end
            if Widget.Next and WidgetUIName ~= "RougeMain" then
                Widget:BindToAnimationFinished(Widget.Next, { self, function()
                    Widget:SetVisibility(UE4.ESlateVisibility.Collapsed)
                end
                })
            end
        end
    end
    --这里是因为委托详情也在此ui中挂载 导致手柄聚焦有问题 先这么处理
    -- if self.CurSubUI then
    --     self.CurSubUI:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    -- end

    self.CurSubUI = self.SubUI[self.CurTabId]
    --self.CurSubUI:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])

    if self.CurSubUI:IsAnyAnimationPlaying() then
        self.CurSubUI:StopAllAnimations()
    end
    self.CurSubUI:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    if (self.CurSubUI.RetainerBox and self.CurSubUI.Panel_Level) then
        self.CurSubUI.Panel_Level:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    -- if self.CurSubUI.RetainerBox_0 and self.CurSubUI.Bg_Group then
    --     self.CurSubUI.Bg_Group:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- end
    if self.CurSubUI.SecondaryPageName == PreTabId then
        self.CurSubUI:PlayAnimationForward(self.CurSubUI.Back)
    elseif self.CurSubUI.In then
        self.CurSubUI:PlayAnimationForward(self.CurSubUI.In)
    else
        self.CurSubUI:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end

    self.CurSubUI:SetFocus()
    if self.CurSubUI.SwitchIn then
        self.CurSubUI:SwitchIn()
    end

    SystemGuideManager:ShowUIEvent(self.CurTabId) --todo 临时处理WidgetUI通知
    self:AddTimer(0.01, function()
        if self.CurSubUI:GetVisibility() == UE4.ESlateVisibility.Collapsed then
            self.CurSubUI:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
    end, false)
    return self.CurSubUI
end


function WBP_Play_Entry_C:OnKeyUp(MyGeometry, InKeyEvent)
    local ParentHandled = WBP_Play_Entry_C.Super.OnKeyUp(self, MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == UIConst.GamePadKey.SpecialRight then
        if self.TeamHeadUI and self.TeamHeadUI.DoGamepadBtnRelease then
            self.TeamHeadUI:DoGamepadBtnRelease()
            if not self.TeamHeadUI.bIsFocusable and not TeamController:IsTeamPopupBarOpenInGamepad() then
                self.ComTab:Handle_KeyEventOnGamePad(InKeyName)
                EventManager:FireEvent(EventID.NightBookSpecialRightUp)
            end
        end
    else
        if(InKeyName == self.OpenKey) then
            self.IsCanCloseByHotKey = true
        end
    end
    return ParentHandled
end

function WBP_Play_Entry_C:OnKeyDown(MyGeometry, InKeyEvent)
    if (CommonUtils:IfExistSystemGuideUI(self)) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
     if self.IsOpenSelectLevel then
        return
    end

    local IsEventHandled = false
    if self.CurSubUI and self.CurSubUI.HandleKeyDown then
        IsEventHandled = self.CurSubUI:HandleKeyDown(MyGeometry, InKeyEvent)
    end
    if not IsEventHandled then
        local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
        local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
        if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
            if InKeyName == UIConst.GamePadKey.SpecialRight then
                if self.TeamHeadUI and self.TeamHeadUI.DoGamepadBtnPress then
                    self.TeamHeadUI:DoGamepadBtnPress()
                    IsEventHandled = true
                end
            elseif InKeyName ~= UIConst.GamePadKey.SpecialRight then
                --组队跟tab的说明弹窗打开有冲突，得绕一下放到onkeydown处理
                if self.IsKeyEventOnGamePad then
                    IsEventHandled = self.ComTab:Handle_KeyEventOnGamePad(InKeyName)
                end              
            end
            if InKeyName == UIConst.GamePadKey.FaceButtonRight then
                if self.TeamHeadUI and self.TeamHeadUI.bIsFocusable then
                    local DeputeRoot =  self.Group_Depute:GetChildAt(0)
                    if IsValid(DeputeRoot) and DeputeRoot:IsVisible() then
                        for _, Child in pairs(DeputeRoot.PanelRoot:GetAllChildren()) do
                            if Child:IsVisible() then
                                Child:SetFocus()
                            end
                        end
                    end
                    local HardBossRoot =  self.Group_HardBoss:GetChildAt(0)
                    if IsValid(HardBossRoot) and HardBossRoot:IsVisible() then
                        HardBossRoot.List_Boss:SetFocus()
                    end
                    self.TeamHeadUI.bIsFocusable = false
                    IsEventHandled = true
                end
            end
        else
            if (InKeyName == "Escape") then
                IsEventHandled = true
                self:OnReturnKeyDown()
            elseif (InKeyName == "Q") then
                IsEventHandled = true
                self.ComTab:TabToLeft()
            elseif (InKeyName == "E") then
                IsEventHandled = true
                self.ComTab:TabToRight()
            elseif (InKeyName == self.OpenKey and self.IsCanCloseByHotKey) then
                IsEventHandled = true
                self:OnReturnKeyDown()
            elseif (InKeyName == "SpaceBar") then
                EventManager:FireEvent(EventID.AllDailyTaskRewardKey)
            end
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function WBP_Play_Entry_C:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    if self.CurSubUI and self.CurSubUI.HandlePreviewKeyDown then
        IsEventHandled = self.CurSubUI:HandlePreviewKeyDown(MyGeometry, InKeyEvent)
    end
    if not IsEventHandled then
        local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
        local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
        if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then

        else

        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return WBP_Play_Entry_C.Super.OnPreviewKeyDown(self, MyGeometry, InKeyEvent)
    end
end

function WBP_Play_Entry_C:OnReturnKeyDown()
    UIUtils.PlayCommonBtnSe(self)
    self:OnClickBack()
end

function WBP_Play_Entry_C:OnClickBack()
    if self.TeamHeadUI.bIsFocusable then return end
    if self:IsAnimationPlaying(self.In) then
        return
    end
    self:PlayOutAnim()
end

function WBP_Play_Entry_C:GetAttachWidget()
    local AttachWidget = nil
    if (CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile") then
        AttachWidget = self.ComTab.Panel_Team
    else
        AttachWidget = self.ComTab.Group_Team
    end
    AttachWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    return AttachWidget
end

function WBP_Play_Entry_C:PlayOutAnim()
    if (self:IsAnimationPlaying(self.Out)) then
        return
    end
    AudioManager(self):SetEventSoundParam(self, "SystemOpenSound", { ToEnd = 1 })
    self:BlockAllUIInput(true,"SP_DisplayOnly")
    self:BindToAnimationFinished(self.Out, { self, self.Close })
    if self.CurSubUI then
        if (self.CurSubUI.RetainerBox and self.CurSubUI.Panel_Level) then
            self.CurSubUI.Panel_Level:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        end
        if (self.CurSubUI:IsAnyAnimationPlaying()) then
            self.CurSubUI:StopAllAnimations()
        end
        self.CurSubUI:PlayAnimationForward(self.CurSubUI.Out)
    end
    if (self.IsAddInDeque) then
        self:PlayAnimationForward(self.Out, UIConst.AnimOutSpeedWithPageJump.NormalFastSpeed)
    else
        self:PlayAnimationForward(self.Out)
    end

    local AttachWidget = self:GetAttachWidget()
    if TeamController:GetHeadUI(AttachWidget) and self.TeamHeadUI then
        TeamController:GetHeadUI(AttachWidget):Close()
        AttachWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.TeamHeadUI = nil
    end

    self:RecoverCamera()


    -- 获取上一个栈中的UI
    local UIManager = UIManager(self)
    local PreviousUI = UIManager:GetUnderState()
    if PreviousUI then
        local PreviousUIName = PreviousUI:GetName()
        DebugPrint("JLY 上一个栈的UI是:", PreviousUIName)
        if PreviousUIName == "ActivityMain" then
            EventManager:FireEvent(EventID.OnReturnToActivityEntry)
            EventManager:FireEvent(EventID.OnActivityEntryShowVisible)
        end
    end
end

function WBP_Play_Entry_C:ShowIntro()
    -- 废弃，改成肉鸽的地方手动传入弹窗Id
    -- if self.CurTabId == "HardBossMain" then
    --     UIManager(self):LoadUINew("CommonDialogTip", GText("UI_HardBoss_Detail"), GText("UI_Toast_HardBoss_Detail"))
    -- end
end

function WBP_Play_Entry_C:SetFocus_Lua()
    self.CurSubUI:SetFocus()
end

function WBP_Play_Entry_C:Close()
    if self.SubUI then
        for _, Widget in pairs(self.SubUI) do
            Widget:RemoveFromParent()
        end
    end
    self:RemoveReddotListener()
    -- if self.IsHome then
    --     self:SwitchCamera(true)
    --     self:PlayNPCAnim(21000502)
    -- else
    --     UIManager(self):SwitchUINpcCamera("StyleOfPlay", self.NpcId, {bDestroyNpc=true, IsHaveInOutAnim=self.IsNeedPlayNpcAnim})
    -- end
    UIManager(self):HideNpcActor(false, "StyleOfPlay",self.NpcId)
    local IsNeedRecoverNow = UIManager(self):StateCount() > 1
    if (IsNeedRecoverNow) then
        UIManager(self):HideNpcById(self.NpcId,true, "StyleOfPlay")
    end
    self.Super.Close(self)
end

function WBP_Play_Entry_C:BP_GetDesiredFocusTarget()
    if self.CurSubUI then
        return self.CurSubUI
    else
        return self
    end
end

function WBP_Play_Entry_C:GetCurSubUI()
    return self.CurSubUI
end

return WBP_Play_Entry_C
