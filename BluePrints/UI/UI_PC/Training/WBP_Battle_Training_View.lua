require "UnLua"
local UIUtils = require "Utils.UIUtils"
local TrainingConst = require("Blueprints.UI.UI_PC.Training.TrainingConst")

local View = Class({
    "BluePrints.UI.BP_UIState_C",
})

View._components = {
    "BluePrints.UI.UI_PC.Training.WBP_Battle_Training_ControllerView",
}

function View:InitMonsterGallery(OwnerWidget)
    self.Owner = OwnerWidget
    self:InitCallback()
    self.Controller = require "BluePrints.UI.UI_PC.Training.WBP_Battle_Training_Controller"
    self.Controller:RegisterView(self, OwnerWidget)
    local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
    GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice) 
    self:PlayAnimation(self.In)
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "TrainingMain", nil)
end

function View:InitView()
    self.IsClosing = nil
    self.CachedRuleId2ItemData = {}
    self.CachedRuleId2ItemEntry = {}
    self.List_Monster:ClearListItems()

    self.Text_SelectTitle:SetText(GText("UI_DUNGEON_DES_TRAINING_25"))
    self.Text_DetailEmpty:SetText(GText("UI_DUNGEON_DES_TRAINING_26"))
    self.Text_SettingTitle_1:SetText(GText("UI_DUNGEON_DES_TRAINING_32"))
    self.Btn_Confirm:SetText(GText("UI_DUNGEON_DES_TRAINING_42"))
    self.Text_ChooseTitle:SetText(GText("UI_DUNGEON_DES_TRAINING_24"))
    self.Btn_Generate:SetText(GText("UI_DUNGEON_DES_TRAINING_12"))
    self.Text_Filter:SetText(GText("UI_DUNGEON_DES_TRAINING_13"))
    self.Text_MidEmpty:SetText(string.format(GText("UI_DUNGEON_DES_TRAINING_44"), "<Img id=\"Gamepad_FaceButton_Bottom\" height=\"48\" width=\"48\"/>"))

    self.Btn_Confirm:SetGamePadImg(UIConst.GamePadImgKey.RightThumb)
    self.Btn_Generate:SetGamePadImg(UIConst.GamePadImgKey.FaceButtonTop)
    self.Key_SelectTitle:CreateGamepadKey(UIConst.GamePadImgKey.SpecialRight)
    self.Key_SelectTitle:SetVisibility(UE4.ESlateVisibility.Collapsed)

    self.Com_CheckBox:InitGamepadKey("LS")

    -- 绑定按钮事件
    self.Btn_Confirm:BindEventOnClicked(self, self.OnBtnConfirmClicked)
    self.Btn_Generate:BindEventOnClicked(self, self.OnBtnGenerateClicked)
    self.Com_CheckBox:BindEventOnClicked({
        Func = self.OnShowUnlockedMonstersPressed,
        Inst = self,
    })

    -- 初始化数量选择器
    self.Com_Slider:Init(
        {
            MinValue = 1,
            MaxValue = self.Controller:GetMaxSpawnableNum(),
            OwnerPanel = self,
            MinusBtnCallback = self.OnMinusSelectedMonsterNumClicked,
            MinusBtnForbidCallback = function() 
                AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_minus", nil, nil)
            end,

            AddBtnCallback = self.OnAddSelectedMonsterNumClicked,
            AddBtnForbidCallback = function()
                UIManager(self):ShowUITip(UIConst.Tip_CommonToast, string.format(GText("UI_DUNGEON_DES_TRAINING_8"), self.TrainingData.MaxEnemyNum))
            end,
            MaxBtnCallback = self.OnMaxSelectedMonsterNumClicked,
            SliderChangeCallback = self.OnMonsterCheckedNumChanged,
            EnableMaxBtn = true,
            bForbidPressAccelerate = true
        }
    )

    -- 初始化手柄状态机
    self:InitControllerFSM()
    self:InitViewByDeviceType()
    self:ShowMonsterRuleInfoView(nil)
end

function View:InitCallback()
    self.OnIncreaseMonsterGalleryEntryNum = nil
    self.OnDecreaseMonsterGalleryEntryNum = nil
    self.OnMaxMonsterGalleryEntryNum = nil
    self.OnUncheckMonsterGalleryEntry = nil
    self.OnChangeMonsterGalleryEntryNum = nil
    self.OnClearAllSelection = nil
    self.OnMonsterLevelChanged = nil
    self.OnSpawnMonster = nil
    self.OnKillAllMonsters = nil
    self.OnShowUnlockedMonstersCallback = nil
    self.GamepadOnItemHovered = nil
end

function View:InitTab(TabConfigData, OnTabItemSelected)
    TabConfigData.SoundFunc = function()
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_02", nil, nil)
    end
    self.Tab:BindEventOnTabSelected(self.Controller, OnTabItemSelected)
    self.Tab:Init(TabConfigData)
    self.Tab:SelectTab(1)
end

function View:UpdateTabKeyInfos(BottomKeyInfo)
    self.Owner.Tab:UpdateBottomKeyInfo_Quick(BottomKeyInfo)
end

function View:InitMonsterGalleryData(ItemViewDatas)
    self.CachedRuleId2ItemData = {}
    self.CachedRuleId2ItemEntry = {}
    self.List_Item:ClearListItems()
    for Index, Data in ipairs(ItemViewDatas) do
        Data.Owner = self
        Data.OnDeclineClickedCallback = {Inst = self, Func = self.OnItemBtnDeclineClicked}
        Data.OnItemHovered = {Inst = self, Func = self.OnItemHovered}
        self.List_Item:AddItem(Data)
    end
    self.List_Item.OnCreateEmptyContent:Bind(self, function(self)
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        Obj.IsEmpty = true
        return Obj
    end)
    self.List_Item:RequestPlayEntriesAnim()
    self.List_Item:RequestFillEmptyContent()

    if UIUtils.IsGamepadInput() then
        self.ControllerFSM:Enter(TrainingConst.FSMStates.FocusTab)
        self.List_Item:NavigateToIndex(0)
    end
end

function View:RefreshOpInfoByInputDevice()
    self:InitViewByDeviceType()
end

function View:InitViewByDeviceType()
    if UIUtils.IsGamepadInput() then
        self:InitGamepadView()
    elseif UIUtils.IsMobileInput() then
        self:InitMobileView()
    else
        self:InitKeyboardView()
    end
end

function View:InitKeyboardView()
    self.WS:SetActiveWidgetIndex(0)
    self.ControllerFSM:Enter(TrainingConst.FSMStates.Keyboard)
end

function View:InitMobileView()
    self.WS:SetActiveWidgetIndex(0)
end

function View:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
       IsHandled = self:Handle_PreviewKeyDownOnGamePad(InKeyName)
    end
    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function View:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = nil
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsHandled = self:Handle_KeyDownOnGamePad(InKeyName)
    end

    if not IsHandled then
        IsHandled = self.Tab:Handle_KeyEventOnPC(InKeyName)
    end

    if not IsHandled then
        return self.Super.OnKeyDown(self, MyGeometry, InKeyEvent)
    else
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
end

function View:OnKeyUp(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = nil
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsHandled = self:Handle_KeyUpOnGamePad(InKeyName)
    end

    if not IsHandled then
        return self.Super.OnKeyUp(self, MyGeometry, InKeyEvent)
    else
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
end

function View:ShowMonsterRuleInfoView(RuleId)
    self.WS_DetailNormal:SetActiveWidgetIndex(0)
    self.Text_Enemy_NameTitle:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Text_Desc:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    if RuleId then
        self.CurrentSelectedRuleId = RuleId
        self.WS_Detail:SetActiveWidgetIndex(0)
        local MonsterGalleryInfo = DataMgr.GalleryRule[RuleId]
        local MonsterData = DataMgr.Monster[MonsterGalleryInfo.PreferredMonsterId]
        if MonsterData and MonsterGalleryInfo then 
            local MonsterName = GText(MonsterData.UnitName)
            local MonsterDescriptionDetail = GText(MonsterGalleryInfo.DescriptionDetail)
            self.Text_Enemy_NameTitle:SetText(MonsterName)
            self.Text_Desc:SetText(MonsterDescriptionDetail)
            self.ScrollTextDesc:ScrollToStart()
            local Icon = LoadObject(MonsterGalleryInfo.MonsterIcon)
            if Icon then 
                self.Image_MonsterHead:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                self.Image_MonsterHead:SetBrushResourceObject(Icon)
            end
        end
    else
        self.WS_Detail:SetActiveWidgetIndex(1)
        self.CurrentSelectedRuleId = nil
    end
end

function View:ShowLockedInfo()
    self.WS_Detail:SetActiveWidgetIndex(0)
    self.WS_DetailNormal:SetActiveWidgetIndex(1)
    self.Text_Enemy_NameTitle:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Text_Desc:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Text_Enemy_NameTitle:SetText(GText("UI_DUNGEON_DES_TRAINING_43"))
    self.Text_DetailLockTitle:SetText(GText("UI_DUNGEON_DES_TRAINING_9"))
    self.Text_DetailLockDesc:SetText(GText("UI_DUNGEON_DES_TRAINING_34"))
    self.Image_MonsterHead:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

-- 更新已选择数量和滑动条
-- CurrentSelectedNum: 当前选中Item的已选数量
-- MaxSelectableNum: 当前选中Item的最大可选数量
-- TotalSelectedNum: 当前总共已选数量
-- bNotifySlider: 是否需要更新滑动条
function View:UpdateViewBySelectedNum(CurrentSelectedNum, MaxSelectableNum, TotalSelectedNum, bNotifySlider)
    self:UpdateSelectedNum(CurrentSelectedNum, MaxSelectableNum, TotalSelectedNum)
    if bNotifySlider then
        self:UpdateSliderNum(CurrentSelectedNum, MaxSelectableNum)
    end

    if TotalSelectedNum > 0 then
        self.Btn_Confirm:ForbidBtn(false)
        self.Btn_Generate:ForbidBtn(false)
    else
        self.Btn_Confirm:ForbidBtn(true)
        self.Btn_Generate:ForbidBtn(true)
    end
end

function View:UpdateSelectedNum(CurrentSelectedNum, MaxSelectableNum, TotalSelectedNum)
    local MaxSpawnableNum = self.Controller:GetMaxSpawnableNum()
    self.Text_ChooseNum:SetText(CurrentSelectedNum)
    
    if TotalSelectedNum >= MaxSpawnableNum then
        self.Text_SelectNum:SetText(string.format("<W>%d/%d</>", TotalSelectedNum, MaxSpawnableNum))
    else
        self.Text_SelectNum:SetText(string.format("<H>%d/%d</>", TotalSelectedNum, MaxSpawnableNum))
    end
end

function View:UpdateSliderNum(CurrentSelectedNum, MaxSelectableNum)
    self.Com_Slider:SetMinValue(1)
    self.Com_Slider:SetMaxValue(MaxSelectableNum)
    self.Com_Slider:SetValue(CurrentSelectedNum)
    self.Com_Slider:RefreshBaseInfo()
    self.Com_Slider:UpdateSliderAndProgress()
end

function View:GetMonsterGalleryItemData(RuleId)
    if self.CachedRuleId2ItemData[RuleId] and self.CachedRuleId2ItemData[RuleId].RuleId == RuleId then
        return self.CachedRuleId2ItemData[RuleId]
    end

    local AllListItems = self.List_Item:GetListItems()
    for _, Item in pairs(AllListItems) do 
        if Item.RuleId == RuleId then 
            self.CachedRuleId2ItemData[RuleId] = Item
            return Item 
        end
    end

    self.CachedRuleId2ItemData[RuleId] = nil
    return nil 
end

function View:GetMonsterGalleryItemEntry(RuleId)
    if self.CachedRuleId2ItemEntry[RuleId] and self.CachedRuleId2ItemEntry[RuleId].Data.RuleId == RuleId then
        return self.CachedRuleId2ItemEntry[RuleId]
    end

    local AllDisplayedEntries = self.List_Item:GetDisplayedEntryWidgets()
    for _, Item in pairs(AllDisplayedEntries) do 
        if Item.Data.RuleId == RuleId then 
            self.CachedRuleId2ItemEntry[RuleId] = Item
            return Item 
        end
    end

    self.CachedRuleId2ItemEntry[RuleId] = nil
    return nil
end


function View:SelectEntry(Entry, IsSelected)
    Entry:SetSelected(IsSelected)
    if IsSelected then
        self:ShowMonsterRuleInfoView(Entry.Data.RuleId)
    end
end

-- 怪物数量调整
function View:OnMinusSelectedMonsterNumClicked(NewValue)
    if self.OnIncreaseMonsterGalleryEntryNum then
        self.OnIncreaseMonsterGalleryEntryNum(NewValue)
    end
end

function View:OnAddSelectedMonsterNumClicked(NewValue)
    if self.OnDecreaseMonsterGalleryEntryNum then
        self.OnDecreaseMonsterGalleryEntryNum(NewValue)
    end
end

function View:OnMaxSelectedMonsterNumClicked()
    if self.OnMaxMonsterGalleryEntryNum then
        self.OnMaxMonsterGalleryEntryNum()
    end
end

function View:OnItemBtnDeclineClicked(RuleId)
    if not RuleId then return end
    if self.OnUncheckMonsterGalleryEntry then
        self.OnUncheckMonsterGalleryEntry(RuleId)
    end
end

function View:OnItemHovered(RuleId)
    if UIUtils.IsGamepadInput() then
        self.GamepadOnItemHovered(RuleId)
    end
end

-- 怪物等级调整
function View:InitEnemyLevelSetting(CurValue, MaxValue)
    self.Com_NumInput:Init({
        InitValue = CurValue,
        MinValue = 1,
        MaxValue = MaxValue,
        MinusBtnCallback = self.OnMonsterLevelChanged,
        AddBtnCallback = self.OnMonsterLevelChanged,
        MaxBtnCallback = self.OnMonsterLevelChanged,
        InputCallback = self.OnMonsterLevelChanged,
        LeaveFocusWidget = self.MaskLevelSetting,
        OwnerPanel = self,
    })
    self.Com_NumInput:UpdateUIStyleInPlatform(true)
end

function View:OnMonsterLevelChanged(CurNumber, PrevNumber)
    if self.OnMonsterLevelChanged then
        self.OnMonsterLevelChanged(CurNumber, PrevNumber)
    end
end

function View:OnMonsterCheckedNumChanged(NewValue)
    AudioManager(self):PlayUISound(self, "event:/ui/common/slider_value_change", nil, nil)
    if self.OnChangeMonsterGalleryEntryNum then
        self.OnChangeMonsterGalleryEntryNum(NewValue)
    end
end

function View:ClearAllCheckedEntries()
    local AllListItems = self.List_Item:GetListItems()
    for _, Item in pairs(AllListItems) do 
        Item.IsChecked = false
        Item.CheckedNum = 0
    end
    local AllDisplayedEntries = self.List_Item:GetDisplayedEntryWidgets()
    for _, Entry in pairs(AllDisplayedEntries) do 
        Entry:OnItemChecked(false)
    end

    self.List_Monster:ClearListItems()
    self:UpdateViewBySelectedNum(0, self.Controller:GetMaxSpawnableNum(), 0, true)
end

function View:AddNewEntryToCountList(RuleId, Num)
    local MonsterGalleryInfo = DataMgr.GalleryRule[RuleId]
    local MonsterData = DataMgr.Monster[MonsterGalleryInfo.PreferredMonsterId]
    local MonsterName = GText(MonsterData.UnitName)
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.RuleId = RuleId
    Obj.Num = Num
    Obj.Title = MonsterName
    Obj.ColorIndex = self.List_Monster:GetNumItems() % 2
    self.List_Monster:AddItem(Obj)
end

function View:UpdateCountListEntryNum(RuleId, NewNum)
    local AllListItems = self.List_Monster:GetListItems()
    local Num = AllListItems:Length()
    for i = 1, Num do
        local Content = AllListItems:GetRef(i)
        if Content.RuleId == RuleId then 
            Content.Num = NewNum
            local Entry = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Monster, i - 1)
            if Entry then
                Entry:UpdateView(Content)
            end
            break
        end
    end
end

function View:RemoveEntryFromCountList(RuleId)
    local AllListItems = self.List_Monster:GetListItems()
    local Num = AllListItems:Length()
    for i = Num, 1, -1 do
        local Content = AllListItems:GetRef(i)
        if Content.RuleId == RuleId then 
            self.List_Monster:RemoveItem(Content)
            break
        end

        Content.ColorIndex = (Content.ColorIndex + 1) % 2
        local Entry = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Monster, i - 1)
        if Entry then
            Entry:UpdateView(Content)
        end
    end
end

function View:IsCountListScrollable()
    local CurScrollOffset = self.List_Monster:GetScrollOffset()
    local MaxListScrollOffset = UIUtils.GetMaxScrollOffsetOfListView(self.List_Monster)
    return CurScrollOffset < MaxListScrollOffset
end

function View:IsMonsterInfoScrollable()
    local CurScrollOffset = self.ScrollTextDesc:GetScrollOffset()
    return CurScrollOffset < self.ScrollTextDesc:GetScrollOffsetOfEnd()
end

function View:OnBtnConfirmClicked()
    if self.OnClearAllSelection then
        self.OnClearAllSelection()
    end
end

function View:OnBtnKillClicked()
    if self.OnKillAllMonsters then
        self.OnKillAllMonsters()
    end
end

function View:OnBtnGenerateClicked()
    if self.OnSpawnMonster then
        self.OnSpawnMonster()
    end
end

function View:ShowToast(Msg)
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, Msg)
end

function View:OnSpawnedMonster(SpawnedNum)
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, string.format(GText("UI_DUNGEON_DES_TRAINING_5"), SpawnedNum))
    self:ClosePanel()
end

function View:OnKilledMonster()
    self:ClosePanel()
end

function View:GetMaxCheckedNum()
    if self.Controller then
        return self.Controller:GetMaxSpawnableNum()
    end

    return 0
end

function View:SimulateShowUnlockedMonstersPressed()
    local IsChecked = self.Com_CheckBox:IsChecked()
    self.Com_CheckBox:SetIsChecked(not IsChecked)
    self:OnShowUnlockedMonstersPressed(not IsChecked)
end

function View:OnShowUnlockedMonstersPressed(CheckBoxChecked)
    -- 待选列表：点击只显示已解锁 / 全部显示
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    if self.OnShowUnlockedMonstersCallback then
        self.OnShowUnlockedMonstersCallback(CheckBoxChecked)
    end
end

-- 玩家结束机关交互
function View:SetPlayerEndInteractive()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    if PlayerController then
        local PlayerCharacter = PlayerController:GetMyPawn()
        local Eid = PlayerCharacter.MechanismEid
        local Mechanism = Battle(self):GetEntity(Eid)
        if Mechanism then
            Mechanism:EndInteractive(PlayerCharacter, true)
        end
    end
end

function View:ClosePanel()
    self.IsClosing = true
    self:PlayAnimation(self.Out)
    AudioManager(self):SetEventSoundParam(self, "TrainingMain", {ToEnd = 1})
    self:SetPlayerEndInteractive()
    self.Owner:OnRealClose()
end

function View:OnAnimationFinished(Animation)
end



AssembleComponents(View)
return View