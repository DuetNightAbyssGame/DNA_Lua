require "UnLua"
local UIUtils = require "Utils.UIUtils"
local Model = require  "BluePrints.UI.AutoChess.AutoChessDataModel"
local AutoChessConst = require "BluePrints.UI.AutoChess.AutoChessConst"
local View = Class({
    "BluePrints.UI.BP_EMUserWidget_C",
    "Blueprints.UI.AutoChess.AutoChessPageInterface",
    "BluePrints.Common.TimerMgr",
})

View._components = {
    "BluePrints.UI.UI_PC.Common.HorizontalListViewResizeComp",
}

function View:InitView(EquipDatas)
    -- 初始化通用排序按钮
    self.Filter:Init(self.ParentWidget, {GText("UI_AutoChess_DefaultSort"), GText("UI_AutoChess_WeaponCost")}, CommonConst.DESC, {
        OnGetBackFocusWidget = function()
            self:SwitchControllerFSMState(AutoChessConst.FSMStates.EquipsPage_Main)
            return self.List_Item
        end
    })
    self.Filter:BindEventOnSelectionsChanged(self, self.OnSortMethodChanged)
    self.Filter:BindEventOnSortTypeChanged(self, self.OnSortMethodChanged)
    self:InitListItem(EquipDatas)
    self.Panel_Detail:InitView()

    local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
    if GameInputModeSubsystem then
        GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    end
    self:RefreshOpInfoByInputDevice()

    if not UIUtils.IsGamepadInput() then
        self:AddTimer(0.1, function()
            self:SelectEquipItem(EquipDatas[1].Id)
        end, nil, nil, nil, true)
    end

    self:InitEvents()
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "AutoChessEquipPage", nil)
end

function View:OnPagePoped()
    AudioManager(self):SetEventSoundParam(self, "AutoChessEquipPage", {ToEnd = 1})
    Model:DecreaseEquipReddotById()
    self:HorizontalListViewResize_TearDown()
end

function View:InitEvents()
    self.OnEquipItemClickedCallback = nil
end

function View:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if self:IsTopPage() then
        if UIUtils.IsGamepadInput() then
            self:InitGamepadView()
        else
            self:InitKeyboardView()
        end
    end
end

function View:GetDefaultControllerFSMState()
    return AutoChessConst.FSMStates.EquipsPage_Main
end

function View:InitGamepadView()
    self.List_Item:SetFocus()
    self.List_Item:NavigateToIndex(0)
end

function View:InitKeyboardView()
end

function View:InitListItem(EquipDatas)
    local CurSortBy, SortType = self.Filter:GetSortInfos()
    local SortedDatas = Model:SortEquipInfos(EquipDatas, CurSortBy, SortType)
    self.List_Item:ClearListItems()
    for _, EquipData in ipairs(EquipDatas) do
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        Obj.Data = EquipData
        Obj.OnBtnClickedCallback = function(EquipId)
            self:SelectEquipItem(EquipId)
            if self.OnEquipItemClickedCallback then
                self.OnEquipItemClickedCallback[2](self.OnEquipItemClickedCallback[1], EquipId)
            end
        end
        Obj.OnFocusReceivedCallback = function(EquipId)
            if UIUtils.IsGamepadInput() then
                self:SelectEquipItem(EquipId)
            end
        end
        self.List_Item:AddItem(Obj)
    end
 
    self.List_Item.OnCreateEmptyContent:Bind(self, function(self)
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        Obj.IsEmpty = true
        return Obj
    end)
    self.List_Item:RequestFillEmptyContent()
    if not UIUtils.IsMobileInput() then
        self:HorizontalListViewResize_SetUp(self.Panel_Content, self.List_Item, 0)
    end
end


function View:SelectEquipItem(EquipId)
    local EquipData = Model:GetEquipInfoByEquipId(EquipId)
    local NewEntry = self:GetEquipItemEntryByEquipId(EquipId)
    if self.CurrentShowEquipId then
        if self.CurrentShowEquipId == EquipId then
            return
        end
        local OldItem = self:GetEquipItemByEquipId(self.CurrentShowEquipId)
        if OldItem then
            OldItem.IsSelected = false
        end
        local OldEntry = self:GetEquipItemEntryByEquipId(self.CurrentShowEquipId)
        if OldEntry then
            OldEntry:SetSelected(false)
        end
    end

    NewEntry:SetIsNew(false)
    NewEntry:SetSelected(true)
    self:ShowEquipDetails(EquipData)
    self.CurrentShowEquipId = EquipData.Id
end

function View:ShowEquipDetails(EquipData)
    self.Panel_Detail:RefreshDetails(EquipData)
    self:PlayAnimation(self.Change)
end

function View:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = false
    if UIUtils.IsGamepadInput() then
        IsHandled = self:Handle_KeyDownOnGamepad(InKeyName)
    else
        IsHandled = self:Handle_KeyDownOnKeyboard(InKeyName)
    end

    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function View:Handle_KeyDownOnGamepad(InKeyName)
    local CurrentState = self:GetControllerFSMState()
    local IsHandled = false
    if CurrentState == AutoChessConst.FSMStates.EquipsPage_Main then
        if InKeyName == Const.GamepadLeftThumbstick then
            self:SwitchControllerFSMState(AutoChessConst.FSMStates.EquipsPage_FocusSort)
            IsHandled = true
        end
    end
    return IsHandled
end

function View:Handle_KeyDownOnKeyboard(InKeyName)
    local IsHandled = false
    return IsHandled
end

-- 手柄端聚焦到通用排序
function View:NavigateToSortFilter(IsEnter)
    if IsEnter then
        self.Filter:SetFocus()
        self.Filter:SetControllerKeyHidden(true)
    else
        self.Filter:SetControllerKeyHidden(false)
    end
end

function View:GetEquipItemByEquipId(EquipId)
    local AllListItems = self.List_Item:GetListItems()
    for _, Item in ipairs(AllListItems) do 
        if not Item.IsEmpty then
            if Item.Data.Id == EquipId then
                return Item
            end
        end
    end
end

function View:GetEquipItemEntryByEquipId(EquipId)
    local AllDisplayedEntries = self.List_Item:GetDisplayedEntryWidgets()
    for _, Entry in pairs(AllDisplayedEntries) do 
        if not Entry.Content.IsEmpty then
            if Entry.Content.Data.Id == EquipId then
                return Entry
            end
        end
    end

    return nil
end

function View:OnSortMethodChanged()
    self:InitListItem(Model:GetEquipsData())
end


AssembleComponents(View)
return View