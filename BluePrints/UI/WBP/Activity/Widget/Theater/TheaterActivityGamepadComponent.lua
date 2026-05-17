require "UnLua"

local Component = {}


function Component:InitGamepadIcon()
    if ModController:IsMobile() then
        return
    end
    self.Key_Award:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "Menu"
            }
        }
    })
    self.Key_AwardTitle:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "LS"
            }
        }
    })
    self.Key_ProgressTitle:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "RS"
            }
        }
    })

    self.Btn_Auto:SetGamePadImg("X")
    self.Btn_Delivery:SetGamePadImg("Y")
    self.Tip_Refresh:SetGamePadImg("View")
end

function Component:UpdateGamepadUI(CurInputDevice, CurGamepadName)
    if CurInputDevice == ECommonInputType.Gamepad then
        self:SetGamepadImgVisibility(true, self.bListExpand)
    else
        self:SetGamepadImgVisibility(false, self.bListExpand)
    end
end

function Component:SetGamepadImgVisibility(bVisible, bEnterSelectMode)
    if ModController:IsMobile() then
        return
    end
    local bShowKeyElements = bVisible and not bEnterSelectMode

    local keyElementsVisibility = bShowKeyElements and UIConst.VisibilityOp["SelfHitTestInvisible"] or UIConst.VisibilityOp["Collapsed"]


    local buttonElementsVisibility = bVisible and UIConst.VisibilityOp["SelfHitTestInvisible"] or UIConst.VisibilityOp["Collapsed"]
    
    -- 基础UI元素
    self.Key_Award:SetVisibility(keyElementsVisibility)
    self.Key_AwardTitle:SetVisibility(keyElementsVisibility)
    self.Key_ProgressTitle:SetVisibility(keyElementsVisibility)
    self.Tip_Refresh:SetGamePadVisibility(keyElementsVisibility)
    self.bShowKeyElements = bShowKeyElements
    
    self.Btn_Auto:SetGamePadVisibility(buttonElementsVisibility)
    self.Btn_Delivery:SetGamePadVisibility(buttonElementsVisibility)
end

function Component:UpdateBottomKeyInfo(pattern)
    local BottomKeyInfo = {}
    if pattern == "Default" or pattern == nil then
        BottomKeyInfo = {
            {
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}},
                GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.CloseSelf, Owner=self}},
                Desc=GText("UI_BACK")
            }
        }
    elseif pattern == "FocusItem" then
        BottomKeyInfo = {
            {
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}},
                GamePadInfoList = {{Type="Img", ImgShortPath="A", ClickCallback=self.CloseSelf, Owner=self}},
                Desc=GText("UI_Controller_CheckDetails")
            },
            {
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}},
                GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.CloseSelf, Owner=self}},
                Desc=GText("UI_BACK")
            },
        }
    elseif pattern == "Empty" then
        BottomKeyInfo = {            {
            KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}},
            Desc=GText("UI_BACK")
        }}
    end
    if not ModController:IsMobile() then
        self.Tab:UpdateBottomKeyInfo(BottomKeyInfo)
    end
end

function Component:Handle_OnGamePadDown(KeyName)
    DebugPrint("JLy Handle_OnGamePadDown", KeyName)
    if self.IsSpecialFocus and KeyName ~= "Gamepad_FaceButton_Right" then
        return false
    end
    if KeyName == "Gamepad_FaceButton_Top" then
        self.Btn_Delivery:OnBtnClicked()
        return true
    elseif KeyName == "Gamepad_FaceButton_Left" then
        self.Btn_Auto:OnBtnClicked()
        return true
    elseif KeyName == "Gamepad_FaceButton_Right" then
        if self.bIsFocusInFilter then
            self.bIsFocusInFilter = false
            self.List_Item:SetFocus()
        elseif self.List_Item:HasFocusedDescendants() or self.List_Item:HasAnyUserFocus() or self.bListExpand then
            self.List_Delivery:NavigateToIndex(0)
            self:OnExpandList(false, false)
        elseif self.IsSpecialFocus then
            self.IsSpecialFocus = false
            self:SetGamepadImgVisibility(true)
            self:UpdateBottomKeyInfo()
            self:SetDefaultFocus()
            self.Tip_Award:CloseMenuAnchor()
        elseif self.List_Delivery:HasFocusedDescendants() or self.List_Delivery:HasAnyUserFocus() then
            self:SetDefaultFocus()
        else
            self:CloseSelf()
        end
        return true
    elseif KeyName == "Gamepad_LeftThumbstick" then
        if self.bListExpand then
            self.Filter:SetFocus()
            self.bIsFocusInFilter = true
        else
            self.List_Reward:SetFocus()
            self.LastFocusItem = self.List_Reward
            self.IsSpecialFocus = true
            self:SetGamepadImgVisibility(false)
            self:UpdateBottomKeyInfo("FocusItem")
        end
        return true
    elseif KeyName == "Gamepad_RightThumbstick" then
        if not self.bShowKeyElements then
            return false
        end
        if self.bListExpand then
            return false
        end
        self.ListView_Task:NavigateToIndex(0)
        self.LastFocusItem = self.ListView_Task
        self.IsSpecialFocus = true
        self:SetGamepadImgVisibility(false)
        self:UpdateBottomKeyInfo("FocusItem")
        return true
    elseif KeyName == "Gamepad_Special_Right" then
        if not self.bShowKeyElements then
            return false
        end
        self.Tip_Award:OpenMenuAnchor()
        self.IsSpecialFocus = true
        self:SetGamepadImgVisibility(false)
        self:UpdateBottomKeyInfo()
        return true
    elseif KeyName == "Gamepad_Special_Left" then
        if not self.bShowKeyElements then
            return false
        end
        self.Tip_Refresh:OnBtnClicked()
        return true
    else
        return false
    end
end

function Component:ItemMenuAnchorChanged(bOpen)
    if bOpen then
        self:UpdateBottomKeyInfo("Empty")
    else
        if self.CurInputDevice == ECommonInputType.Gamepad then
            self:UpdateBottomKeyInfo("FocusItem")
        else
            self:UpdateBottomKeyInfo()
        end
    end
end

function Component:SetDefaultFocus()
    if self.bListExpand then
        self.List_Item:SetFocus()
    else
        self.View_left_btns:NavigateToIndex(self.SelectedIndex - 1)
    end
    DebugPrint("JLy SetDefaultFocus", self.bIsFocusInFilter, self.IsSpecialFocus)
    self.bIsFocusInFilter = false
    self.IsSpecialFocus = false
end

return Component