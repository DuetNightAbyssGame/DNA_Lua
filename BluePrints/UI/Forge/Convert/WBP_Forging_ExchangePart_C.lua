--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
---@type WBP_Forging_ExchangePart_C
local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

function M:InitContent(Params, PopupData, Owner)
    DebugPrint("Yihan@ WBP_Forging_ExchangePart_C.InitContent", Params, PopupData.Title, Owner)
    self.Super.InitContent(self, Params, PopupData, Owner)
    self:InitData(Params)
    self:InitCompView()
    self.Owner.Params.AutoFocus = true
end

function M:InitData(Params)
    self.MergeTbl = Params.MergeTbl
    self.ConvertContent = Params.ConvertContent
    self.CurrentCount = Params.CurrentCount
    self.Str = Params.Str
end

function M:InitCompView()
    self:InitText()
    self:InitMaterialCost()
    self:InitConvertResult()
    self:SetTitle()
end

function M:InitText()
    self.TextName:SetText(GText("Draft_Resource_Consume"))
    self.ConverResult:SetText(GText("UI_Convert"))
end

function M:InitMaterialCost()
    local MergeTbl = self.MergeTbl

    self.List_Item_1:ClearListItems()
    for _, Data in ipairs(MergeTbl) do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.Id = Data.ItemId or Data.Id
        Content.UnitId = Data.UnitId
        Content.Icon = Data.Icon
        DebugPrint("Yihan@ WBP_Forging_ExchangePart_C.InitMaterialCost", Content.Id, Content.Icon, Data.ItemType)
        Content.Rarity = Data.Rarity
        Content.ItemType = Data.ItemType
        Content.Count = Data.ChoosedCount * self.CurrentCount
        Content.IsShowDetails = true
        Content.IsSelfDeadWithUpEvent = true
        Content.OnMenuOpenChangedEvents = {Obj = self, Callback = self.OnItemTipsOpenChanged}
        Content.LockType = Data.LockType
        Content.IsLocked = Data.IsLocked
        self.List_Item_1:AddItem(Content)
    end
end

function M:InitConvertResult()
    local ConvertContent = self.ConvertContent
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    DebugPrint("Yihan@ WBP_Forging_ExchangePart_C.InitConvertResult", ConvertContent.ShopItemId, ConvertContent.Icon,Content.ItemType)

    Content.Id = ConvertContent.ShopItemId
    Content.Icon = ConvertContent.Icon
    Content.Rarity = ConvertContent.Rarity
    Content.ItemType = ConvertContent.ItemType
    Content.Count = self.CurrentCount * DataMgr.Convert[ConvertContent.Idx].ProductNum
    Content.IsShowDetails = true
    Content.OnMenuOpenChangedEvents = {Obj = self, Callback = self.OnItemTipsOpenChanged}
    self.WBP_Com_Item_Universal_L_C_0:Init(Content)
end

function M:SetTitle()
    self.RichTextBlock_61:SetText(self.Str, true)
end
--设置通用弹窗默认聚焦的控件
function M:HandleDialogFocused()
    return self
end

function M:InitGamepadView()
    ScreenPrint("Yihan@ WBP_Forging_ExchangePart_C.InitGamepadView")
    if not self.IsInitGamepadView then
        self.IsInitGamepadView = true
        self:FirstInitgamePadView()
    end
end
-- 初始化GamePadView
function M:FirstInitgamePadView()
   self.CheckItemBtnIdx = self.Owner:InitGamepadShortcut({
        KeyInfoList = {{
            Type = "Img",
            ImgShortPath = "LS"
        }},
        Desc = GText("UI_Controller_CheckDetails")
    }, 3)
    self.AKeyIdx = self.Owner:InitGamepadShortcut({
        KeyInfoList = {{
            Type = "Img",
            ImgShortPath = "A"
        }},
        Desc = GText("UI_Controller_CheckDetails")
    }, 1)
    self.Owner:HideGamepadShortcut(self.AKeyIdx)
    self.BKeyIdx = self.Owner:InitGamepadShortcut({
        KeyInfoList = {{
            Type = "Img",
            ImgShortPath = "B"
        }},
        Desc = GText("UI_BACK")
    }, 2)
    self.Owner:HideGamepadShortcut(self.BKeyIdx)
end

function M:ShowChooseShortcuts()
    if self.CheckItemBtnIdx then
        self.Owner:HideGamepadShortcut(self.CheckItemBtnIdx)
    end
    if self.AKeyIdx then
        self.Owner:ShowGamepadShortcut(self.AKeyIdx)
    end
    if self.BKeyIdx then
        self.Owner:ShowGamepadShortcut(self.BKeyIdx)
    end
    self.Owner:SetGamepadBtnKeyVisibility(false)
end

function M:ShowDefaultShortcuts()
    if self.AKeyIdx then
        self.Owner:HideGamepadShortcut(self.AKeyIdx)
    end
    if self.BKeyIdx then
        self.Owner:HideGamepadShortcut(self.BKeyIdx)
    end
    if self.CheckItemBtnIdx then
        self.Owner:ShowGamepadShortcut(self.CheckItemBtnIdx)
    end
    self.Owner:SetGamepadBtnKeyVisibility(true)
end

function M:OnContentKeyDown(MyGeometry,InKeyEvent)
    DebugPrint("Yihan@ WBP_Forging_ExchangePart_C.OnContentKeyDown", InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == UIConst.GamePadKey.LeftThumb then
        self.List_Item_1:NavigateToIndex(0)
        self:ShowChooseShortcuts()
        return true
    elseif InKeyName == UIConst.GamePadKey.FaceButtonRight and self:HasFocusedDescendants() then
        DebugPrint("Yihan@ WBP_Forging_ExchangePart_C OnContentKeyDown Focus")
        self:ShowDefaultShortcuts()
        self.Owner:SetFocus()
        return true
    end
    return false
end

function M:OnItemTipsOpenChanged(bIsOpen, Content)
    if bIsOpen then
        self.Owner:HideAllGamepadShortcut()
        self.Owner:SetGamepadBtnKeyVisibility(false)
    else
        if self:HasFocusedDescendants() then
            self:ShowChooseShortcuts()
        else
            self:ShowDefaultShortcuts()
        end
    end
end
return M
