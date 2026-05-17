require "UnLua"
local ForgeConst = require "Blueprints.UI.Forge.ForgeConst"

local M={
}
--输入设备切换
function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    DebugPrint("WBP_Forging_Convert_Main_GamePadCompoment:OnUpdateUIStyleByInputTypeChange")
        if (CurInputDevice == ECommonInputType.Gamepad) then
        self.WBP_Forging_Convert_PopUp_Choose:InitGamePadView()
        self:InitGamePadView()
    else
        self.WBP_Forging_Convert_PopUp_Choose:InitKeyboardView()
        self:InitKeyboardView()
    end
end

--从其他界面回来恢复一下聚焦
function M:ReceiveEnterState(StackAction)
    ScreenPrint("WBP_Forging_Convert_Main_GamePadCompoment:ReceiveEnterState"..StackAction)
    if StackAction == 1 and self.IsGamePad then
        --self:SetFocus_Lua()
    end
end
function M:InitKeyboardView()
    self.IsGamePad = false
    self.WBP_Forging_Convert.Group_Key:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.WBP_Forging_Convert.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WBP_Forging_Convert.KeyText:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:InitGamePadView()
    self.IsGamePad = true
    if not self.IsFirstInit then
        self:FirstInitgamePadView()
        self.IsFirstInit = true
    end
    self.WBP_Forging_Convert.Group_Key:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
    self.WBP_Forging_Convert.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.WBP_Forging_Convert.KeyText:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.WBP_Forging_Convert.WBP_Com_BtnText01_1:SetGamePadImg("Y")
end
-- 初始化GamePadView
function M:FirstInitgamePadView()
    self.WBP_Forging_Convert.WBP_Com_KeyImg:CreateGamepadKey("X")
    self.WBP_Forging_Convert.KeyText:CreateGamepadKey("LS")
end
-- 默认聚焦起点
function M:SetFocus_Lua()
    if self.WBP_Forging_Convert_PopUp_Choose:GetVisibility() == UE4.ESlateVisibility.Visible then
        local Popup = self.WBP_Forging_Convert_PopUp_Choose
        if Popup.CurSelectedContent then
             Popup.List_Item:BP_SetItemSelection(Popup.CurSelectedContent, true)
             Popup.List_Item:SetFocus()
        else
             Popup.List_Item:NavigateToIndex(0)
             Popup.List_Item:SetFocus()
        end
    else
        if self.CurListItem then
            local Index = self.EMList:GetIndexForItem(self.CurListItem)
            if Index >= 0 then
                self.EMList:NavigateToIndex(Index)
                self.EMList:SetFocus()
            else
                self.EMList:NavigateToIndex(0)
                self.EMList:SetFocus()
            end
        else
            self.EMList:NavigateToIndex(0)
            self.EMList:SetFocus()
        end
        self:EnterState_Normal()
    end
end

function M:UpdateGamepadBottomKeyInfo(KeyInfoTypeList)
    local KeyInfo = {}
    for Index, Value in ipairs(KeyInfoTypeList) do 
        table.insert(KeyInfo, self.GamepadKeyCofig[Value])
    end

    self.Com_Tab:UpdateBottomKeyInfo(KeyInfo)
end

function M:EnterState_Normal()
    self:UpdateGamepadBottomKeyInfo({ForgeConst.BottomKeyTypes.BottomKey_Back})
end

function M:EnterState_Choose()
    self:UpdateGamepadBottomKeyInfo({ForgeConst.BottomKeyTypes.BottomKey_Confirm, ForgeConst.BottomKeyTypes.BottomKey_Back})
end

function M:UpdateGamePadUIOnTipsChanged(bIsOpen)
    if not self.IsGamePad then return end
    
    if self.Com_Tab then
        if self.Com_Tab.SetBottomKeyInfoVisible then
            self.Com_Tab:SetBottomKeyInfoVisible(not bIsOpen)
        end
        if self.Com_Tab.UpdateUIStyleInPlatform then
            self.Com_Tab:UpdateUIStyleInPlatform(not bIsOpen)
        end
    end

    if self.WBP_Forging_Convert then
         local Visibility = not bIsOpen and UIConst.VisibilityOp.HitTestInvisible or UIConst.VisibilityOp.Collapsed
         if self.WBP_Forging_Convert.WBP_Com_KeyImg then
             self.WBP_Forging_Convert.WBP_Com_KeyImg:SetVisibility(Visibility)
         end
         if self.WBP_Forging_Convert.KeyText then
             self.WBP_Forging_Convert.KeyText:SetVisibility(Visibility)
         end
    end
end

function M:UpdateGamePadUIOnConvertAnim(bIsPlaying)
    if not self.IsGamePad then return end
    if self.WBP_Forging_Convert then
        local Visibility = not bIsPlaying and UIConst.VisibilityOp.HitTestInvisible or UIConst.VisibilityOp.Collapsed
        if self.WBP_Forging_Convert.WBP_Com_KeyImg then
            self.WBP_Forging_Convert.WBP_Com_KeyImg:SetVisibility(Visibility)
        end
        if self.WBP_Forging_Convert.KeyText then
            self.WBP_Forging_Convert.KeyText:SetVisibility(Visibility)
        end
        if self.WBP_Forging_Convert.WBP_Com_BtnText01_1 then
            self.WBP_Forging_Convert.WBP_Com_BtnText01_1:SetVisibility(Visibility)
        end
    end
    if bIsPlaying then
        if self and self.bIsFocusable then
            UIUtils.HideNavigateWidgetTemporarily(0.8)--播动画时隐藏手柄光标
        end
    end
end

function M:CloseItemDetailsWidget(bIsClosed)
    self:ShowItemDetailsPanel(not bIsClosed)
    local RootWidget = self
    if(RootWidget and RootWidget.bIsFocusable)then
        RootWidget:SetFocus()
    end
end

function M:Handle_KeyDownOnGamePad(KeyName)
    if self.bItemDetailsShowed then
        if KeyName == UIConst.GamePadKey.FaceButtonRight then
            self:ShowItemDetailsPanel(false)
            return true
        end
        return false
    end

    if self.WBP_Forging_Convert.WBP_Com_Slider:GetVisibility() == UE4.ESlateVisibility.Visible then
        if self.WBP_Forging_Convert.WBP_Com_Slider:Handle_KeyDownEventOnGamePad(KeyName) then
            return true
        end
    end

    if self.Com_Tab:Handle_KeyEventOnGamePad_KeyDown(KeyName) then
        return true
    end
    if KeyName ==UIConst.GamePadKey.FaceButtonLeft then
        if self.WBP_Forging_Convert_PopUp_Choose:GetVisibility() ~= UE4.ESlateVisibility.Visible then
            self:ShowChooseUI(self.WBP_Forging_Convert.MergeTbl)
            if self.WBP_Forging_Convert_PopUp_Choose and self.WBP_Forging_Convert_PopUp_Choose.InitGamePadView then
                self.WBP_Forging_Convert_PopUp_Choose:InitGamePadView()
            end
        else
            if self.WBP_Forging_Convert_PopUp_Choose.SetDefaultMaterialFocus then
                self.WBP_Forging_Convert_PopUp_Choose:SetDefaultMaterialFocus()
            end
        end
        return true
    elseif KeyName == UIConst.GamePadKey.FaceButtonTop then
        if self.WBP_Forging_Convert_PopUp_Choose:GetVisibility() ~= UE4.ESlateVisibility.Visible then
            self.WBP_Forging_Convert:OnClearAllClicked()
        end
        return true
    elseif KeyName ==UIConst.GamePadKey.FaceButtonRight then
        self:OnReturnKeyDown()
        return true
    elseif KeyName == UIConst.GamePadKey.LeftThumb then
        if self.CurFocusedItem then
            self:OnEMListItemClicked(self.CurFocusedItem)
            self:RefreshItemDetails(self.CurFocusedItem)
        end
        return true
    end
    return false
end

function M:OnGamepadReturnKeyDown()
    
end

function M:Handle_KeyUpOnGamePad(KeyName)
    if self.WBP_Forging_Convert.WBP_Com_Slider:GetVisibility() == UE4.ESlateVisibility.Visible then
        if self.WBP_Forging_Convert.WBP_Com_Slider:Handle_KeyUpEventOnGamePad(KeyName) then
            return true
        end
    end
    return false
end

function M:Create_GetReplyOnBack()
    return function()
        if self.CurListItem then
            local Index = self.EMList:GetIndexForItem(self.CurListItem)
            if Index >= 0 then
                self.EMList:NavigateToIndex(Index)
            else
                self.EMList:NavigateToIndex(0)
            end
        else
            self.EMList:NavigateToIndex(0)
        end
        return UE4.UWidgetBlueprintLibrary.SetUserFocus(UE4.UWidgetBlueprintLibrary.Handled(), self.EMList)
    end
end

return M
