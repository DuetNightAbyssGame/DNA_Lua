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

function View:InitView(ChessDatas)
    self:InitListItem(ChessDatas)
    self.Panel_Detail:InitView()

    if not UIUtils.IsGamepadInput() then
        self:AddTimer(0.1, function()
            self:SelectChessItem(ChessDatas[1].Id)
        end, nil, nil, nil, true)
    end

    self:InitEvents()
    EventManager:AddEvent(EventID.OnAutoChessEquipChange, self, self.OnChessEquipChanged)
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "AutoChessMonsterPage", nil)
end

function View:InitEvents()
    self.OnMonsterItemClickedCallback = nil
end

function View:OnPagePoped()
    AudioManager(self):SetEventSoundParam(self, "AutoChessMonsterPage", {ToEnd = 1})
    Model:DecreaseMonsterReddotById()
    self:HorizontalListViewResize_TearDown()
end

function View:GetDefaultControllerFSMState()
    return AutoChessConst.FSMStates.MonsterPage_Main
end

function View:InitListItem(ChessDatas)
    for Index, ChessData in ipairs(ChessDatas) do
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        Obj.Data = ChessData
        Obj.OnBtnClickedCallback = function(ChessId)
            self:SelectChessItem(ChessId)
            if self.OnMonsterItemClickedCallback then
                self.OnMonsterItemClickedCallback[2](self.OnMonsterItemClickedCallback[1], ChessId)
            end
        end
        Obj.OnFocusReceivedCallback = function(ChessId)
            if UIUtils.IsGamepadInput() then
                self:SelectChessItem(ChessId)
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

function View:SelectChessItem(ChessId)
    local ChessData = Model:GetMonsterInfoByCombatId(ChessId)
    local NewEntry = self:GetChessItemEntryByChessId(ChessId)
    if self.CurrentShowChessId then
        if self.CurrentShowChessId == ChessId then
            return
        end
        local OldItem = self:GetChessItemByChessId(self.CurrentShowChessId)
        if OldItem then 
            OldItem.IsSelected = false
        end

        local OldEntry = self:GetChessItemEntryByChessId(self.CurrentShowChessId)
        if OldEntry then
            OldEntry:SetSelected(false)
        end
    end

    NewEntry:SetSelected(true)
    NewEntry:SetIsNew(false)
    self:ShowChessDetails(ChessData)
    self.CurrentShowChessId = ChessData.Id
end

function View:ShowChessDetails(ChessData)
    self.Panel_Detail:RefreshDetails(ChessData)
    self:PlayAnimation(self.Change)
end

-- 当怪物装备变化时，更新界面信息
function View:OnChessEquipChanged(ChessId, EquipId)
    local NewEquipInfo = Model:GetMonsterEquipInfo(ChessId)
    local NewChessData = Model:GetMonsterInfoByCombatId(ChessId)
    local ItemNum = self.List_Item:GetNumItems()
    for Index = 1, ItemNum do
        local Item = self.List_Item:GetItemAt(Index)
        if Item then
            Item.Data.EquipItems = NewEquipInfo
            break
        end
    end
    local Entry = self:GetChessItemEntryByChessId(ChessId)
    if Entry then
        Entry:UpdateEquipInfo(NewEquipInfo)
    end

    -- 更新Detail面板
    if self.CurrentShowChessId == ChessId then
        self.Panel_Detail:RefreshDetails(NewChessData)
    end
end

function View:GetChessItemByChessId(ChessId)
    local AllListItems = self.List_Item:GetListItems()
    for _, Item in ipairs(AllListItems) do 
        if not Item.IsEmpty then
            if Item.Data.Id == ChessId then
                return Item
            end
        end
    end
end

function View:GetChessItemEntryByChessId(ChessId)
    local AllDisplayedEntries = self.List_Item:GetDisplayedEntryWidgets()
    for _, Entry in pairs(AllDisplayedEntries) do 
        if Entry.Content.Data.Id == ChessId then
            return Entry
        end
    end

    return nil
end

function View:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = false
    if UIUtils.IsGamepadInput() then
        IsHandled = self:Handle_KeyDownOnGamePad(InKeyName)
    else
        IsHandled = self:Handle_KeyDownOnKeyboard(InKeyName)
    end

    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function View:Handle_KeyDownOnKeyboard(InKeyName)
    local IsHandled = false
    return IsHandled
end

function View:Handle_KeyDownOnGamePad(InKeyName)
    local IsHandled = false
    if InKeyName == Const.GamepadFaceButtonUp then
        if self.CurrentShowChessId then
            self:OpenChooseEquipPage(self.CurrentShowChessId)
            IsHandled = true
        end
    end

    return IsHandled
end

function View:OpenChooseEquipPage(ChessId)
    local ChessData = Model:GetMonsterInfoByCombatId(ChessId)
    UIManager(self):LoadUINew("AutoChessChooseEquip", ChessData, self)
    CommonUtils:CloseGuideTouchIfExist(self)
end


AssembleComponents(View)
return View