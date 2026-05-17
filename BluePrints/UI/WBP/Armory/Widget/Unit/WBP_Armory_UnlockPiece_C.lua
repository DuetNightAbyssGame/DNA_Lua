--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Armory_UnlockPiece_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})
M._components = {
    "BluePrints.UI.BP_EMUserWidgetUtils_C"
}

function M:Construct()
    self.ItemDetails_MenuAnchor.ParentWidget = self
    self.Key_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    if self.ItemDetails_MenuAnchor then
        self.ItemDetails_MenuAnchor:CloseItemDetailsWidget()
    end
    self.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Add(self,self.OnMenuOpenChanged)
    self:AddInputMethodChangedListen()
    self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType())
end

function M:Destruct()
    self.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Remove(self,self.OnMenuOpenChanged)
end

function M:ShowGamepadKey(bShow)
    if(bShow)then
        self.Key_GamePad:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Key_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:CreateCommonKey(...)
    self.Key_GamePad:CreateCommonKey(...)
end

function M:OnMenuOpenChanged(IsOpen)
    if(IsOpen)then
        AudioManager(self):PlayUISound(self, "event:/ui/common/combat_bag_cell_place_common", nil, nil)
    end
    self:UpdateOpenAnimState(IsOpen)
    if(rawget(self,"_OnMenuOpenChanged"))then
        self._OnMenuOpenChanged(self.Owner,IsOpen)
    end
end

function M:Init(Content)
    rawset(self,"Content",Content)
    rawset(self,"Owner",Content.Owner)
    rawset(self,"_OnMenuOpenChanged",Content.OnMenuOpenChanged)
    rawset(self,"_OnAddedToFocusPath",Content.OnAddedToFocusPath)
    local Count = Content.Count or 0
    local CountNeed = Content.CountNeed or 0

    self.Num_Now:SetText(Content.Count)
    self.Num_Total:SetText(Content.CountNeed)
    if(Count < CountNeed)then
        self.Num_Now:SetColorAndOpacity(self.UnEnoughColor)
    else
        self.Num_Now:SetColorAndOpacity(self.NormalColor)
    end
    self.Icon_Piece:SetBrushResourceObject(LoadObject(Content.IconPath))
    self.ItemDetails_MenuAnchor:InitializeSetUp(self, Content)
    self:UpdateOpenAnimState(false)
end

function M:OnAddedToFocusPath()
    rawset(self,"IsInFocusPath",true)
    self:UpdateGamepadKeyVisibility()
    if(rawget(self,"_OnAddedToFocusPath"))then
        self._OnAddedToFocusPath(self.Owner,self)
    end
end

function M:OnRemovedFromFocusPath()
    rawset(self,"IsInFocusPath",false)
    self:UpdateGamepadKeyVisibility()
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    rawset(self,"IsGamepadInput",CurInputDevice == ECommonInputType.Gamepad)
    self:UpdateGamepadKeyVisibility()
end

function M:UpdateGamepadKeyVisibility()
    if(self.IsGamepadInput)then
        self:ShowGamepadKey(not rawget(self,"IsInFocusPath"))
    else
        self:ShowGamepadKey(false)
    end
end

function M:OnBtnClicked()
    self.ItemDetails_MenuAnchor:OpenItemDetailsWidget(false,self.Content)
end

function M:OnBtnUnhovered()
    if(rawget(self,"IsMenuOpened"))then
        return
    end
    self:PlayAnimationReverse(self.Hover)
end

function M:OnBtnHovered()
    if(rawget(self,"IsMenuOpened"))then
        return
    end
    self:PlayAnimation(self.Hover)
end

function M:OnBtnPressed()
    if(rawget(self,"IsMenuOpened"))then
        return
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Press)
end

function M:OnBtnReleased()
    if(rawget(self,"IsMenuOpened"))then
        return
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
end

function M:UpdateOpenAnimState(IsOpen)
    rawset(self,"IsMenuOpened",IsOpen)
    if(IsOpen)then
        self.Btn_Area:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self:StopAllAnimations()
        self:PlayAnimation(self.Click)
    else
        self:StopAllAnimations()
        self:PlayAnimation(self.Normal)
        self.Btn_Area:SetVisibility(UIConst.VisibilityOp.Visible)
    end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    return  UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self.Btn_Area)
end

AssembleComponents(M)
return M
