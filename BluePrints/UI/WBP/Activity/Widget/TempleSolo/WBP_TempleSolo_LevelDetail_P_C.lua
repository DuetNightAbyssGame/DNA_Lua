--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_Temple_Solo_LevelDetail_P_C
local M = Class({"Blueprints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.TempleEventType = nil
    self.TextName = nil
    self.Level = 1
    self.IsHardMode = false
    self.TempleId = nil
    self.CurrentSelectTabContent = nil
    self.EventId = 108001
    self.TempleTypeId2Items = {}
    self.TempleId2Items = {}

    self:SetFocus()
    self:InitCommonTab()
    self:InitListTab()
    self:BindButtonPerformances()
    self:PlayAnimation(self.In)
    self.Reward:InitController()
    self.Reward.Owner = self

    self.Reward.Text_Reward:SetText(GText("UI_TempleEvent_RewardProgress"))
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self:AddInputMethodChangedListen()
    end

    if not ReddotManager.GetTreeNode("TempleSoloEventReward") then
		ReddotManager.AddNodeEx("TempleSoloEventReward")
	end
	ReddotManager.AddListenerEx("TempleSoloEventReward",self,self.RefreshReddot)
end

function M:Destruct()
    self:UnbindButtonPerformances()
    ReddotManager.RemoveListener("TempleSoloEventReward",self)
end

function M:BindButtonPerformances()
    self.Reward.Btn_Click.OnClicked:Add(self, self.Reward.OnClicked)
    self.Btn_Start.Btn_Click.OnClicked:Add(self, self.GoToTemple)
    self.List_Tab.BP_OnItemSelectionChanged:Add(self, self.OnTabSelectionChanged)
end

function M:UnbindButtonPerformances()
    self.Reward.Btn_Click.OnClicked:Clear()
    self.Btn_Start.Btn_Click.OnClicked:Clear()
end

function M:AddInputMethodChangedListen()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice) 
    end
end

function M:RemoveInputMethodChangedListen()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice) 
    end
end

function M:InitCommonTab()
    self.Tab:Init(
        {
           DynamicNode = {"Back", "BottomKey"},
           BottomKeyInfo = {},
           TitleName = GText("Event_Title_108001"),
           StyleName = "Text", OwnerPanel = self, 
           BottomKeyInfo = {
               {
                    KeyInfoList = {{Type="Text", Text="Esc", ClickCallback = self.CloseSelf, Owner = self}},
                    GamePadInfoList = {{Type="Img", ImgShortPath="B"}},
                    Desc = GText("UI_BACK")
               },
               {
                    GamePadInfoList = {{Type="Img", ImgShortPath="RV"}},
                    Desc = GText("UI_Controller_Slide")
               }
           },
           BackCallback = self.CloseSelf,
        })

    local DeviceType = CommonUtils.GetDeviceTypeByPlatformName(self)
    if DeviceType ~= "Mobile" then
        self.Controller_L:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "LT"
                }
            }
        })

        self.Controller_R:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "RT"
                }
            }
        })
    end
end

function M:InitListTab()
    self.List_Tab:ClearListItems()
    self.List_Tab:DisableScroll(true)

    local TempleEventType = DataMgr.TempleEventType
    for i, v in pairs(TempleEventType) do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.TempleTypeId = i
        Content.EventId = v.EventId
        Content.TempleTypeName = v.TempleTypeName
        Content.GUIPath = v.GUIPath
        Content.Parent = self
        Content.NormalStar, Content.MaxNormalStar, Content.HardStar, Content.MaxHardStar = self:GetTempleTypeFinished(i)
        Content.ParentWidget = self
        Content.Index = self.List_Tab:GetNumItems() + 1
        self.List_Tab:AddItem(Content)
        if not self.TextName then
            -- self.TempleEventType = i
            self.TextName = v.TempleTypeName
        end
        self.TempleTypeId2Items[i] = Content
    end
    self:AddTimer(0.01, function()
        local TargetTypeId, TargetTempleId = self:GetFirstUnfinishedSubTabIndex()
        local Item = self.TempleTypeId2Items[TargetTypeId] or self.List_Tab:GetItemAt(0)
        if Item then
            self:OnTabItemClicked(Item, TargetTempleId)
        end
    end)
end

function M:InitListSubTab(TargetTempleId)
    self.List_SubTab:ClearListItems()
    self.List_SubTab:DisableScroll(true)
    local TempleEventLevel = DataMgr.TempleEventLevel
    local ValidTemples = {}
    for i, v in pairs(TempleEventLevel) do
        if v.TempleTypeId == self.TempleEventType then
            table.insert(ValidTemples, {
                TempleId = i,
                Data = v
            })
        end
    end
    
    table.sort(ValidTemples, function(a, b)
        return a.TempleId < b.TempleId
    end)
    
    self.TempleId2Items = {}
    for Index, temple in ipairs(ValidTemples) do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.TempleId = temple.TempleId
        Content.TempleTypeId = temple.Data.TempleTypeId
        Content.IsHardMode = temple.Data.IsHardMode
        Content.Level = Index
        Content.Parent = self
        Content.EventId = self.EventId
        Content.Index = Index
        self.List_SubTab:AddItem(Content)
        self.TempleId2Items[temple.TempleId] = Content
    end

    if not TargetTempleId then
        TargetTempleId = self:GetTargetSubTabIndex(self.TempleId2Items)
    end

    self:AddTimer(0.02,function()
        local Item = self.TempleId2Items[TargetTempleId] or self.List_SubTab:GetItemAt(0)
        if Item then
            self:OnSubTabItemClicked(Item, true)
        end
    end)
end

function M:InitDetail(TempleId, Level, IsHardMode)
    self.Name.Text_Name:SetText(GText(self.TextName))
    self.Name.Text_Num:SetText(Level)
    self.Name.Text_Difficulty:SetText(IsHardMode and GText("UI_TempleEvent_HardMode") or GText("UI_TempleEvent_NormalMode"))
    self.Text_Title_Description:SetText(GText("UI_TempleEvent_LevelDes"))
    self.Text_Description01:SetText(GText("UI_TEMPLE_"..TempleId))
    self.Text_Description02:SetText(GText("UI_TEMPLE_DES_"..TempleId))
    
    if self.EMScrollBox_0 then
        self.EMScrollBox_0:ScrollToStart()
        -- self.EMScrollBox_0:SetScrollBarVisibility(ESlateVisibility.Visable)
    end

    -- 设置星级信息
    local TempleInfo = DataMgr.Temple[TempleId]
    local Avatar = GWorld:GetAvatar()
    local CurrentStar = 0
    if Avatar and Avatar.Temple[self.EventId] and Avatar.Temple[self.EventId].FinishStars[TempleId] then
        CurrentStar = Avatar.Temple[self.EventId].FinishStars[TempleId]
    end
    local TextRule2 = ""
    if TempleInfo.SucRule == "Time" or TempleInfo.SucRule == "CountDown" then
        TextRule2 = "SECONDS"
    elseif TempleInfo.SucRule == "Score" then
        TextRule2 = "SCORE"
    elseif TempleInfo.SucRule == "Collect" then
        TextRule2 = "COUNT"
    end
    self.Text_Title_Rule:SetText(GText("UI_TempleEvent_LevelRule"))
    self.WBox_Rule:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Text_Title_Target:SetText(GText("UI_TempleEvent_LevelTarget"))
    self.Text_Progress:SetText(CurrentStar.."/"..(#TempleInfo.RatingRange or 0))
    for i = 1, 3 do
        local TextInfo = ""
        local Target = TempleInfo.RatingRange[i]
        if Target == nil then
            self["Target0"..i]:SetVisibility(UE4.ESlateVisibility.Collapsed)
            goto continue
        elseif Target == 0 then
            TextInfo = GText("UI_TEMPLE_SUCRULE_ZERO")
        else
            if TempleInfo.SucRule == "CountDown" and TempleInfo.UIShowType and TempleInfo.UIShowType > 0 then
                TextInfo = string.format(GText("UI_TEMPLE_SUCRULE_COUNTDOWN_" .. TempleInfo.UIShowType), 100 - Target)
            elseif TextRule2 == "SCORE" or TextRule2 == "COUNT" then
                TextInfo = GText("UI_TEMPLE_SUCRULE_" .. string.upper(TempleInfo.SucRule)) .. Target
            else
                TextInfo = GText("UI_TEMPLE_SUCRULE_" .. string.upper(TempleInfo.SucRule)) .. Target .. GText("UI_TEMPLE_MEASURE_" .. TextRule2)
            end
        end
        self["Target0"..i]:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self["Target0"..i].Text_Target:SetText(TextInfo)
        if i <= CurrentStar then
            self["Target0"..i].WS_Type:SetActiveWidgetIndex(1)
        else
            self["Target0"..i].WS_Type:SetActiveWidgetIndex(0)
        end
        ::continue::
    end

    -- 特殊机制标签
    local Rule = {}
    local DungeonInfo = DataMgr.Dungeon[TempleId]
    if DungeonInfo.FbdRule then
        for key, value in pairs(DungeonInfo.FbdRule) do
            table.insert(Rule, {
                RuleId = key,
                RuleValue = value,
                RuleText = GText("UI_TEMPLE_RULE_" .. key)
            })
        end
    end
    if #Rule == 0 then
        self.Panel_Rule:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        self.Panel_Rule:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.WBox_Rule:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        for i = 1, 4 do
            if Rule[i] then
                self["Rule_"..i]:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                self["Rule_"..i].Text_Rule:SetText(Rule[i].RuleText)
            else
                self["Rule_"..i]:SetVisibility(UE4.ESlateVisibility.Collapsed)
            end
        end
    end

    local Star = nil
    local Star_Empty = nil
    if IsHardMode then
        local ButtonIconPath_Star = '/Game/UI/Texture/Dynamic/Atlas/Activity/Temple/Solo/T_Activity_Temple_Solo_Star_Challenge.T_Activity_Temple_Solo_Star_Challenge'
        Star = LoadObject(ButtonIconPath_Star)
        local ButtonIconPath_Empty = '/Game/UI/Texture/Dynamic/Atlas/Activity/Temple/Solo/T_Activity_Temple_Solo_Star_Challenge_Empty.T_Activity_Temple_Solo_Star_Challenge_Empty'
        Star_Empty = LoadObject(ButtonIconPath_Empty)
    else
        local ButtonIconPath_Star = '/Game/UI/Texture/Dynamic/Atlas/Activity/Temple/Solo/T_Activity_Temple_Solo_Star.T_Activity_Temple_Solo_Star'
        Star = LoadObject(ButtonIconPath_Star)
        local ButtonIconPath_Empty = '/Game/UI/Texture/Dynamic/Atlas/Activity/Temple/Solo/T_Activity_Temple_Solo_Star_Empty.T_Activity_Temple_Solo_Star_Empty'
        Star_Empty = LoadObject(ButtonIconPath_Empty)
    end
    for i = 1, 3 do
        self["Target0"..i].Image_Star:SetBrushFromTexture(Star)
        self["Target0"..i].Image_Empty:SetBrushFromTexture(Star_Empty)
    end

    self:CheckTempleState()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (InKeyName == "Escape" or InKeyName == "Gamepad_FaceButton_Right") then
        IsEventHandled = true
        self:CloseSelf()
    elseif (InKeyName == "Gamepad_FaceButton_Left") then
        self:GoToTemple()
        IsEventHandled = true
    elseif (InKeyName == "Gamepad_LeftTrigger") then
        self:SwitchSubTab(-1)
        IsEventHandled = true
    elseif (InKeyName == "Gamepad_RightTrigger") then
        self:SwitchSubTab(1)
        IsEventHandled = true
    elseif (InKeyName == "Gamepad_FaceButton_Top") then
        self.Reward:OnClicked()
        IsEventHandled = true
    end
    if IsEventHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local AddOffset = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 5
    
    if InKeyName == "Gamepad_RightY" then
        local CurScrollOffset = self.EMScrollBox_0:GetScrollOffset()
        local ScrollOffset = 
            math.clamp(CurScrollOffset - AddOffset,0, self.EMScrollBox_0:GetScrollOffsetOfEnd())
        self.EMScrollBox_0:SetScrollOffset(ScrollOffset)
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnTabItemClicked(Item, TargetTempleId)
    if self.TempleEventType == Item.TempleTypeId then return end
    if self.CurrentSelectTabContent then
        local CurWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Tab, self.List_Tab:GetIndexForItem(self.CurrentSelectTabContent))
        CurWidget:SetSelected(false)
    end
    self.CurrentSelectTabContent = Item
    local CurWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Tab, self.List_Tab:GetIndexForItem(self.CurrentSelectTabContent))
    if CurWidget then
        CurWidget:SetSelected(true)
    else
        -- 从副本返回时，控件创建有延迟
        -- self:AddTimer(0.02, function()
        --     local CurWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Tab, self.List_Tab:GetIndexForItem(self.CurrentSelectTabContent))
        --     if CurWidget then
        --         CurWidget:SetSelected(true)
        --     end
        -- end)

        local Content = self.List_Tab:GetItemAt(Item.Index - 1)
        Content.DelaySelected = true
    end

    -- 切换bg
    if self.BG then
        self.BG:PlayAnimation(self.BG.Out)
    end
    if Item.TempleTypeId == 1080011 then
        self.WS_BG:SetActiveWidgetIndex(0)
        AudioManager(self):PlayUISound(self, "event:/ui/activity/lingniao_sub_anim_3", nil, nil)
        self.BG = self.BG_01
    elseif Item.TempleTypeId == 1080012 then
        self.WS_BG:SetActiveWidgetIndex(1)
        AudioManager(self):PlayUISound(self, "event:/ui/activity/lingniao_sub_anim_1", nil, nil)
        self.BG = self.BG_02
    elseif Item.TempleTypeId == 1080013 then
        self.WS_BG:SetActiveWidgetIndex(2)
        AudioManager(self):PlayUISound(self, "event:/ui/activity/lingniao_sub_anim_2", nil, nil)
        self.BG = self.BG_03
    end

    self.TempleEventType = Item.TempleTypeId
    self.TextName = Item.TempleTypeName
    self.TempleId = nil
    self:InitListSubTab(TargetTempleId)
    self:PlayAnimation(self.Change_2)
    self:PlayBGAnimations()
    
    AudioManager(self):PlayUISound(nil, "event:/ui/activity/lingniao_btn_click_level_01", nil, nil)
end

function M:OnSubTabItemClicked(Item, NotPlaySound)
    if self.TempleId == Item.TempleId then 
        return 
    end
    if self.CurrentSelectSubTabContent then
        local CurWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_SubTab, self.List_SubTab:GetIndexForItem(self.CurrentSelectSubTabContent))
        if CurWidget then
            CurWidget:SetSelected(false)
        end
    end
    self.CurrentSelectSubTabContent = Item
    local CurWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_SubTab, self.List_SubTab:GetIndexForItem(self.CurrentSelectSubTabContent))
    if CurWidget then
        CurWidget:SetSelected(true)
    else
        local Content = self.List_SubTab:GetItemAt(Item.Index - 1)
        Content.DelaySelected = true
    end

    self.TempleId = Item.TempleId
    self:InitDetail(Item.TempleId, Item.Level, Item.IsHardMode)
    self:PlayAnimation(self.Change)
    if not NotPlaySound then
        AudioManager(self):PlayUISound(nil, "event:/ui/activity/lingniao_btn_click_level_02", nil, nil)
    end
end

function M:ChangeListSubTab()
end

function M:ChangeListTab()
end

function M:GoToTemple()
    AudioManager(self):PlayUISound(nil, "event:/ui/activity/large_btn_click", nil, nil)
    -- 进副本前缓存相关信息，用于退出副本时弹出此界面
    local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
    local CurTabIndex = 1
    if ActivityMain then
        CurTabIndex = ActivityMain.CurTabId
    end
    local ExitDungeonInfo = {
        Type = "Temple",
        CurTabIndex = CurTabIndex,
    }
    GWorld.GameInstance:SetExitDungeonData(ExitDungeonInfo)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:EnterEventDungeon(nil, self.TempleId, nil,  108001)
    end
end

function M:GetTempleTypeFinished(TempleTypeId)
    local NormalStar, MaxNormalStar, HardStar, MaxHardStar = 0, 0, 0, 0
    local TempleEventInfo = DataMgr.TempleEventLevel
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    for TempleId, Value in pairs(TempleEventInfo) do
        if Value.TempleTypeId == TempleTypeId then
            if Value.IsHardMode then
                MaxHardStar = MaxHardStar + 3
                HardStar = HardStar + (Avatar.Temple[self.EventId] and Avatar.Temple[self.EventId].FinishStars[TempleId] or 0)
            else
                MaxNormalStar = MaxNormalStar + 3
                NormalStar = NormalStar + (Avatar.Temple[self.EventId] and Avatar.Temple[self.EventId].FinishStars[TempleId] or 0)
            end
        end
    end
    return NormalStar, MaxNormalStar, HardStar, MaxHardStar
end

function M:CheckTempleState()
    local TempleLevelConf = DataMgr.TempleEventLevel[self.TempleId]
    if not TempleLevelConf then return end
    local UnlockTime = TempleLevelConf.UnlockDate
    if UnlockTime and UnlockTime > TimeUtils.NowTime() then
        -- local RestTime = TimeUtils.TimeToStr(UnlockTime - TimeUtils.NowTime())
        local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle1(UnlockTime)
        local Text = string.format(GText("UI_TempleEvent_Lock_Time"), RemainTimeDict)
        self.Btn_Start.Text_Lock:SetText(Text)
        -- self.Btn_Start.WorldText_Lock:SetText(EnText("UI_TempleEvent_Lock_Time"))
        self.Btn_Start.WS_Type:SetActiveWidgetIndex(1)
        self.ChekcTempleStateTimer = self:AddTimer(1, function()
            self:CheckTempleState()
        end)
        return false
    elseif not self:CheckPreDungeonPass(TempleLevelConf.PreDungeon) then
        self.Btn_Start.Text_Lock:SetText(GText("UI_TempleEvent_Lock_Progress"))
        self.Btn_Start.WorldText_Lock:SetText(EnText("UI_TempleEvent_Lock_Progress"))
        self.Btn_Start.WS_Type:SetActiveWidgetIndex(1)
        return false
    else
        self.Btn_Start.Text:SetText(GText("UI_TempleEvent_EntryLevel"))
        self.Btn_Start.WorldText:SetText(EnText("UI_TempleEvent_EntryLevel"))
        self.Btn_Start.WS_Type:SetActiveWidgetIndex(0)
        
        self:AddDelayFrameFunc(function()
            local Item = self.TempleId2Items[self.TempleId]
            if Item then
                local Entry = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_SubTab, Item.Index - 1)
                if Entry and Entry.State == "Lock" then
                    Entry:SetState()
                end
            end
        end, 3)
        return true
    end
end

function M:CheckPreDungeonPass(PreDungeon)
    if not PreDungeon then
        return true
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    local Dungeon = Avatar.Dungeons[PreDungeon]
    if not Dungeon then
        return false
    end
    -- local IsPass = Dungeon.IsPass
    local Star = Avatar.Temple[self.EventId].FinishStars[PreDungeon]
    return Star >= CommonConst.TemplePassNeedStar
end

function M:CloseSelf()
    if not self.IsClosing then
        self:PlayAnimation(self.Out)
        self.IsClosing = true
    end
    EventManager:FireEvent(EventID.OnActivityEntryShowVisible)
end

function M:OnAnimationFinished(Animation)
    if Animation == self.Out then
        self:Close()
    end
end

-- gamepad --
function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    --- 输入设备切换通知
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        return
    elseif CurInputDevice == ECommonInputType.Touch then
        return
    end
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if (IsUseKeyAndMouse) then
        self:GamepadToPC()
    else
        self:PCToGamepad()
    end
    self.CurInputDeviceType = CurInputDevice
end

function M:PCToGamepad()
    self:AddTimer(0.01, function()
        -- 设置List_Tab为导航边界
        self.List_Tab:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
        self.List_Tab:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
        self.List_Tab:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
        self.List_Tab:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
        
        -- 设置焦点到第一个Tab项
        local FirstTabWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Tab, 0)
        if FirstTabWidget then
            FirstTabWidget:SetFocus()
        else
            self.List_Tab:SetFocus()
        end
    end)
    self.Controller_L:SetVisibility(UE4.ESlateVisibility.Visible)
    self.Controller_R:SetVisibility(UE4.ESlateVisibility.Visible)
    self.Btn_Start.Controller:SetVisibility(UE4.ESlateVisibility.Visible)
    self.Reward.Controller:SetVisibility(UE4.ESlateVisibility.Visible)

    if self.EMScrollBox_0 then
        self.EMScrollBox_0:SetScrollBarVisibility(ESlateVisibility.Visable)  -- 显示滚动条
        self.EMScrollBox_0:SetControlScrollbarInside(false)
    end
end

function M:GamepadToPC()
    if self.Controller_L then
        self.Controller_L:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Controller_R:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Btn_Start.Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Reward.Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    if self.EMScrollBox_0 then
        self.EMScrollBox_0:SetControlScrollbarInside(true)
        self.EMScrollBox_0:SetScrollBarVisibility(ESlateVisibility.Collapsed)  -- 显示滚动条
    end
end

function M:OnTabSelectionChanged(SelectedItem, bIsSelected)
    if bIsSelected and SelectedItem then
        -- local ItemWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Tab, self.List_Tab:GetIndexForItem(SelectedItem))
        -- if ItemWidget then
            self:OnTabItemClicked(SelectedItem)
        -- end
    end
end

--

function M:SwitchSubTab(Direction)
    local ItemCount = self.List_SubTab:GetNumItems()
    if ItemCount <= 1 then
        return
    end

    local CurrentIndex = 0
    for i = 0, ItemCount - 1 do
        local Item = self.List_SubTab:GetItemAt(i)
        if Item and Item.TempleId == self.TempleId then
            CurrentIndex = i
            break
        end
    end
    
    local NewIndex = CurrentIndex + Direction
    if NewIndex < 0 then
        NewIndex = ItemCount - 1  -- 循环到最后一个
    elseif NewIndex >= ItemCount then
        NewIndex = 0  -- 循环到第一个
    end
    
    local TargetItem = self.List_SubTab:GetItemAt(NewIndex)
    if TargetItem then
        self:OnSubTabItemClicked(TargetItem)
    end
end

function M:SetBGColor(Color)
    self.Name.Text_Name:SetColorAndOpacity(self.Name["Title_"..Color])
    self.Name.Text_Num:SetColorAndOpacity(self.Name["Title_"..Color]) 
    self.Name.Text_Difficulty:SetColorAndOpacity(self.Name["SubTitle_"..Color])
    self.Name.Square01:SetColorAndOpacity(self.Name["Square_"..Color])
    self.Name.Square02:SetColorAndOpacity(self.Name["Square_"..Color])

    self.Text_Title_Description:SetColorAndOpacity(self["Title_"..Color])
    self.Text_Description01:SetColorAndOpacity(self["Content_"..Color])
    self.Text_Description02:SetColorAndOpacity(self["Content_"..Color])

    self.Text_Title_Rule:SetColorAndOpacity(self["Title_"..Color])

    self.Text_Title_Target:SetColorAndOpacity(self["Title_"..Color])
    self.Text_Progress:SetColorAndOpacity(self["Title_"..Color])
    for i = 1, 3 do
        self["Target0"..i].Text_Target:SetColorAndOpacity(self["Target0"..i]["Text_"..Color])
    end

    for i = 1, 4 do
        self["Rule_"..i].Text_Rule:SetColorAndOpacity(self["Rule_"..i]["Color_"..Color])
    end

    self.Btn_Start.Text:SetColorAndOpacity(self.Btn_Start["Text_"..Color])
    self.Btn_Start.Text_Lock:SetColorAndOpacity(self.Btn_Start["Text_"..Color])
    self.Btn_Start.Star_L_Lock:SetColorAndOpacity(self.Btn_Start["Star_"..Color])
    self.Btn_Start.Star_R_Lock:SetColorAndOpacity(self.Btn_Start["Star_"..Color])
    self.Btn_Start.Star_L:SetColorAndOpacity(self.Btn_Start["Star_"..Color])
    self.Btn_Start.Star_R:SetColorAndOpacity(self.Btn_Start["Star_"..Color])

    self.BG_SubTab:SetColorAndOpacity(self["BG_List_"..Color])

    self.Btn_Start.BG_Hover:SetColorAndOpacity(self.Btn_Start["Star_"..Color])
end

function M:PlayBGAnimations()
    local BG = self.BG
    if not (BG and BG.In and BG.Loop) then return end

    BG:StopAllAnimations()
    if BG.Loop then  BG:UnbindAllFromAnimationFinished(BG.Loop)  end
    if BG.Loop_2 then BG:UnbindAllFromAnimationFinished(BG.Loop_2) end
    BG:UnbindAllFromAnimationFinished(BG.In)

    BG:BindToAnimationFinished(BG.In, { self, function()
        if BG ~= self.BG then return end
        if BG.Loop then BG:PlayAnimation(BG.Loop) end
        if BG.Loop_2 then BG:PlayAnimation(BG.Loop_2) end
    end })

    BG:BindToAnimationFinished(BG.Loop, { self, function()
        if BG ~= self.BG then return end
        BG:PlayAnimation(BG.Loop)
    end })

    if BG.Loop_2 then
        BG:BindToAnimationFinished(BG.Loop_2, { self, function()
            if BG ~= self.BG then return end
            BG:PlayAnimation(BG.Loop_2)
        end })
    end

    BG:PlayAnimation(BG.In)
end

function M:GetRewards(Content)
    local Avatar = GWorld:GetAvatar()
    local Temple = Avatar.Temple
    local TempleRewardId = Content.ConfigData.ItemId
    if Avatar then
        local Callback = function(ErrCode, Ret)
            Content.ConfigData.CanReceive = false
            Content.ConfigData.RewardsGot = true
            Content.SelfWidget:RefreshBtn(ErrCode == 0)
            Content.SelfWidget:RefreshReddotInfo()
            Content.Owner:RealRefreshListRewardInfo(Content.ConfigData.Type)
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Ret, false, nil, nil, false)
        end
        Avatar:TempleGetReward(TempleRewardId, Callback)
    end
end

function M:GetAllRewards(Content)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local function CallBack(ErrCode, Ret)
            local HaveReWardToGet = false
            for i = 0,Content.SelfWidget.List_Item:GetNumItems() - 1 do
                local Item = Content.SelfWidget.List_Item:GetItemAt(i)
                if Item.ConfigData.CanReceive == true then
                    Item.ConfigData.CanReceive = false
                    Item.ConfigData.RewardsGot = true
                end
                if Item.SelfWidget then
                    Item.SelfWidget:RefreshBtn(Item.ConfigData.RewardsGot)
                end
            end
            Content.SelfWidget:RefreshBtnGetAll(Content.SelfWidget)
            Content.SelfWidget:RefreshReddotInfo()
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Ret, false, nil, nil, false)
        end
        local IsHardMode = Content.IsHardMode
        Avatar:TempleGetAllModeReward(108001, IsHardMode, CallBack)
    end
end

function M:RefreshReddot()
    local Node = ReddotManager.GetTreeNode("TempleSoloEventReward")
	if not Node then
		self.Reward.Reddot:SetVisibility(ESlateVisibility.Collapsed)
		return
	end
	if Node.Count and Node.Count > 0 then
		self.Reward.Reddot:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	else
		self.Reward.Reddot:SetVisibility(ESlateVisibility.Collapsed)
	end
end

function M:GetFirstUnfinishedSubTabIndex()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    if not Avatar.Temple[self.EventId] then return end

    local TempleData = {}
    for TempleId, Data in pairs(DataMgr.TempleEventLevel) do
        table.insert(TempleData, { TempleId = TempleId, Data = Data })
    end
    table.sort(TempleData, function(a, b)
        return a.TempleId < b.TempleId
    end)

    local TargetTempleTypeId, TargetTempleId = 0, 0

    for Index = 0, 2 do
        local TabItem = self.List_Tab:GetItemAt(Index)
        for _, Item in pairs(TempleData) do 
            if Item.Data.TempleTypeId == TabItem.TempleTypeId then
                local MaxStar = Avatar.Temple[self.EventId].FinishStars[Item.TempleId] or 0
                if MaxStar < 3 then
                    local UnlockTime = Item.Data.UnlockDate
                    if UnlockTime and UnlockTime > TimeUtils.NowTime() then
                        break
                    end
                    TargetTempleTypeId = Item.Data.TempleTypeId
                    TargetTempleId = Item.TempleId
                    return TargetTempleTypeId, TargetTempleId
                end
            end
        end
    end
    return TargetTempleTypeId, TargetTempleId
end

function M:GetTargetSubTabIndex(Items)
    local TempleData = {}
    for TempleId, Data in pairs(Items) do
        table.insert(TempleData, { TempleId = TempleId, Data = Data })
    end
    table.sort(TempleData, function(a, b)
        return a.TempleId < b.TempleId
    end)
    local TargetTempleId = 0
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    if not Avatar.Temple[self.EventId] then return end
    for Index, Data in pairs(TempleData) do
        local MaxStar = Avatar.Temple[self.EventId].FinishStars[Data.TempleId] or 0
        if MaxStar < 3 then
            TargetTempleId = Data.TempleId
            return TargetTempleId
        end
    end
end

return M
