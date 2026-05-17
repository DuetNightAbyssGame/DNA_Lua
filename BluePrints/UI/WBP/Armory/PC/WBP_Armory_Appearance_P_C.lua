--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Armory_Appearance_P_C|WBP_Armory_Appearance_Base_C
local M = Class("BluePrints.UI.WBP.Armory.Appearance.WBP_Armory_Appearance_Base_C")

--function M:Initialize(Initializer)
--end

function M:Construct()
    M.Super.Construct(self)
end

function M:Init(Params)
    M.Super.Init(self,Params)
    self._OnAddedToFocusPath = Params.OnAddedToFocusPath
    self._OnRemovedFromFocusPath = Params.OnRemovedFromFocusPath
    self:InitNavigationRules()
end

function M:InitNavigationRules()
    local Grid = {
        {self.Char_Skin,        self.Hair_Skin,             self.SettlementAction_Skin},
        {self.Char_Skin,        self.Cap_Skin,              self.Head_Skin},
        {self.Face_Skin,        self.Back_Skin,            self.Tail_Skin},
        {self.Waist_Skin,        self.FX_Teleport_Skin,          self.FX_Footprint_Skin},
        {self.FX_Body_Skin,self.FX_PlungingATK_Skin,          self.FX_HelixLeap_Skin},
        {self.FX_Dead_Skin,},
    }
    local MaxCol = #Grid[1]
    local MaxRow = #Grid
    local Dirs = {{1,0},{0,1},{0,-1},{-1,0}}
    local NavDir = {EUINavigation.Down,EUINavigation.Right,EUINavigation.Left,EUINavigation.Up}
    local Row = 0
    local Col = 0
    local EDir = 0
    for i, GridRow in ipairs(Grid) do
        for j, Widget in ipairs(GridRow) do
            for index, Dir in ipairs(Dirs) do
                Row = i + Dir[1]
                Col = j + Dir[2]
                EDir = NavDir[index]
                if(Row <= 0 or Row > MaxRow)then
                    Widget:SetNavigationRuleBase(EDir, EUINavigationRule.Stop)
                elseif(Col <= 0)then
                    Widget:SetNavigationRuleBase(EDir, EUINavigationRule.Escape)
                elseif(Col > MaxCol)then
                    Widget:SetNavigationRuleBase(EDir, EUINavigationRule.Stop)
                elseif(Grid[Row][Col])then
                    Widget:SetNavigationRuleExplicit(EDir, Grid[Row][Col])
                else
                    Widget:SetNavigationRuleBase(EDir, EUINavigationRule.Stop)
                end
            end
        end
    end
    self.Char_Skin:SetNavigationRuleExplicit(EUINavigation.Right, self.Hair_Skin)
end

function M:OnTabLeftKeyDown()
    --self:TabToLeft()
end

function M:OnTabRightKeyDown()
    --self:TabToRight()
end

function M:OnAddedToFocusPath()
    if(self._OnAddedToFocusPath)then
        self._OnAddedToFocusPath(self.Parent,self)
    end
end

function M:OnRemovedFromFocusPath()
    if(self._OnRemovedFromFocusPath)then
        self._OnRemovedFromFocusPath(self.Parent,self)
    end
end

function M:OnParentKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if(InKeyName == Const.GamepadRightThumbstick  and self.Plan_Char:IsVisible())then
        return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self.Plan_Char),true
    end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if(self.WS_State:GetActiveWidgetIndex() == 0)then
        return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self.CurrentFocusedWidget or self.Char_Skin)
    else
        return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self.CurrentFocusedWidget or self.Weapon_Skin)
    end
end

function M:OnAccessoryItemContentCreated(Content)
    Content.OnAddedToFocusPath = function(_self,Content)
        self.CurrentFocusedWidget = Content.Entry
        self.EMScrollBox:ScrollWidgetIntoView(self.CurrentFocusedWidget)
    end
end

function M:OnSkinItemContentCreated(Content)
    Content.OnAddedToFocusPath = function(_self,Content)
        self.CurrentFocusedWidget = Content.Widget
        self.EMScrollBox:ScrollWidgetIntoView(self.CurrentFocusedWidget)
    end
end


return M
