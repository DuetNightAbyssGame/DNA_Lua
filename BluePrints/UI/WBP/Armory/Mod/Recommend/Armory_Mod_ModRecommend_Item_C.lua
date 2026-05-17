--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local ModModel = ModController:GetModel()

local RecommendModState = {
    Normal = 0,
    None = 1,
    Equipped = 2
}

---@type WBP_Armory_ModRecommend_Item_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
-- function M:Initialize(Initializer)
-- end

function M:Construct()

end

function M:OnListItemObjectSet(Content)
    self:InitData(Content)
end

function M:InitData(Content)
    self.Content = Content
    self.Data = Content
    local ModInfoContent = NewObject(UIUtils.GetCommonItemContentClass())
    local ModConfig = DataMgr.Mod[Content.ModId]

    ModInfoContent.Id = Content.ModId
    ModInfoContent.Icon = ModConfig.Icon
    ModInfoContent.Rarity = ModConfig.Rarity
    ModInfoContent.ItemType = "Mod"
    ModInfoContent.HandleMouseDown = true
    ModInfoContent.IsShowDetails = true
    self.Item_Mod:Init(ModInfoContent)

    self.Text_Mod:SetText(GText(ModConfig.Name))
    local Rate = Content.Rate * 100 
    Rate = math.floor(Rate * 10) /10 
    self.Text_Num:SetText(GText(Rate .. "%"))

    self.Com_List:BindEventOnClicked(self, self.OnCellClick)
    self.Com_List:SetCanCancelSelection(true)

    if Content.IsSelect then
        self.Com_List:SelectCell()
    else
        self.Com_List:OnCellUnSelect()
    end
    self.CheckBox:SetIsCheckedState(Content.IsSelect)
    self:SetModState()
end

function M:SetModState()
    local SelectBtnState
    if self.Content.IsEquipped then
        -- 持有并装备
        self.RecommendModState = RecommendModState.Equipped
        SelectBtnState = UIConst.VisibilityOp.Collapsed
        self.Text_Equipped:SetText(GText("UI_Bag_Equipped"))
    elseif self.Content.Owned then
        -- 持有但未装备
        self.RecommendModState = RecommendModState.Normal
        SelectBtnState = UIConst.VisibilityOp.Visible
    else
        -- 未持有
        self.RecommendModState = RecommendModState.None
        SelectBtnState = UIConst.VisibilityOp.Collapsed
        self.Text_None:SetText(GText("UI_Mod_Not_Get"))
    end
    self.WS_State:SetActiveWidgetIndex(self.RecommendModState)

    self.Com_List:SetButtonState(SelectBtnState)
end

function M:OnCellClick()
    local IsSelect = self.Com_List.IsSelect
    self.Content.IsSelect = IsSelect
    local SelectChangeCallbackInfo = self.Content.SelectChangeCallbackInfo
    SelectChangeCallbackInfo.Func(SelectChangeCallbackInfo.Obj, IsSelect, self.Content.ModId)

    self.CheckBox:SetIsChecked(IsSelect, true)

end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    if InKeyName == UIConst.GamePadKey.FaceButtonLeft then
        if self.Item_Mod.Item.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor:IsOpen() then

        else
            return UIUtils.Handled
        end
    end

    return UIUtils.UnHandled
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    if InKeyName == UIConst.GamePadKey.FaceButtonLeft then
        if self.Item_Mod.Item.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor:IsOpen() then

        else
            self.Item_Mod:OpenItemMenu()
            self.Item_Mod.Item.ItemDetails_MenuAnchor:SetLastFocusWidget(self)
            return UIUtils.Handled
        end
    end

    return UIUtils.UnHandled
end
-- function M:Tick(MyGeometry, InDeltaTime)
-- end

-- function M:Destruct()
-- end

return M
