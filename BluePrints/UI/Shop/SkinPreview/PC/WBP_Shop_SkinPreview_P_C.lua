require "UnLua"

---@type WBP_Shop_SkinPreview_P_C
local M = Class("BluePrints.UI.Shop.SkinPreview.WBP_Shop_SkinPreview_Base_C")

function M:Construct()
    M.Super.Construct(self)


    --- 手柄设置
    self.Btn_Function:SetDefaultGamePadImg("A")
    self.Com_Hint:SetDefaultGamePadImg("A")
    -- Tab的BottomKey信息
    self.MenuKeyInfoList = {
        GamePadInfoList =  {
            {Type="Img", ImgShortPath="Menu",}
        },
        Desc = GText("UI_CTL_ExplainSet")
    }
    self.ReplayKeyInfoList = {
        KeyInfoList = {
            {Type="Text", Text = CommonUtils:GetKeyText(self.RKey), ClickCallback=self.OnReplayGesture, Owner=self},
        },
        GamePadInfoList =  {
            {Type="Img", ImgShortPath="Y",}
        },
        Desc = GText("UI_Replay"),
        bLongPress = false
    }
    self.RideKeyInfoList = {
        KeyInfoList = {
            {Type="Text", Text = CommonUtils:GetKeyText(self.RKey), ClickCallback=self.OnRideMount, Owner=self},
        },
        GamePadInfoList =  {
            {Type="Img", ImgShortPath="Y",}
        },
        Desc = GText("UI_CTL_Ride"),
        bLongPress = false
    }
    self.ESCKeyInfoList = {
        KeyInfoList = {
            {Type="Text", Text=CommonUtils:GetKeyText(EKeys.Escape.KeyName), ClickCallback=self.CloseSelf, Owner=self},
        },
        GamePadInfoList =  {
            {Type="Img", ImgShortPath="B", ClickCallback=self.CloseSelf, Owner=self}
        },
        Desc = GText("UI_BACK"),
    }
    self.HideUI_KeyInfoList = {
        KeyInfoList = {
            {Type="Text", Text=CommonUtils:GetKeyText("U"), ClickCallback=self.OnHideUIKeyDown, Owner=self},
        },
        GamePadInfoList =  {
            {Type="Img", ImgShortPath="X"}
        },
        Desc = GText("UI_Dye_HideUI")
    }
    self.ZoomKeyInfoList = {
        KeyInfoList = {
            {Type="Text", Text = CommonUtils:GetKeyText(self.ZoomKey), Owner=self},
        },
        GamePadInfoList =  {
            {Type="Or"},
            GamePadSubKeyInfoList = {
                {Type="Img", ImgShortPath="LT", Owner=self},
                {Type="Img", ImgShortPath="RT", Owner=self}
            }
        },
        Desc = GText("UI_Dye_Zoom"),
        bLongPress = false
    }
    self.RightThumbstickAnalogBottomKeyInfoList = {
        GamePadInfoList =  {
            {Type="Img", ImgShortPath="RH",}
        },
        Desc = GText("UI_CTL_RotatePreview"),
    }
    --#region折扣券相关
    self.DiscountConfirmKeyInfoList = {
        GamePadInfoList =  {
            {Type="Img", ImgShortPath="A"}
        },
        Desc = GText("UI_Tips_Ensure"),
    }
    self.DiscountCheckDetailsKeyInfoList = {
        GamePadInfoList =  {
            {Type="Img", ImgShortPath="X"}
        },
        Desc = GText("UI_Controller_CheckDetails"),
    }
    --#endregion
    self.Key_GamePad_L:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "Left",
            },
        },
    })
    self.Key_GamePad_R:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "Right",
            },
        },
    })
    self.Key_Preview:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "Y",
            },
        },
    })
    self.Key_Dye_GamePad:CreateSubKeyDesc({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "View",
            },
        },
        Type = "Img",
        Desc = GText("UI_SkinPreview_Dye")
    })
    self.Key_BtnChoose:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "LS",
            },
        },
    })
    self.Key_LevelUp:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "LS",
            },
        },
    })
    self.Key_GamePad_L:SetVisibility(ESlateVisibility.Collapsed)
    self.Key_GamePad_R:SetVisibility(ESlateVisibility.Collapsed)
    self.Key_Preview:SetVisibility(ESlateVisibility.Collapsed)
    self.Gift_GamePad:SetVisibility(ESlateVisibility.Collapsed)
end

function M:InitKeySetting()
    M.Super.InitKeySetting(self)

    self.BottomKeyInfo = {}
    table.insert(self.BottomKeyInfo,self.MenuKeyInfoList)
    table.insert(self.BottomKeyInfo, self.ReplayKeyInfoList)
    table.insert(self.BottomKeyInfo,self.HideUI_KeyInfoList)
    table.insert(self.BottomKeyInfo,self.ZoomKeyInfoList)
    table.insert(self.BottomKeyInfo,self.RightThumbstickAnalogBottomKeyInfoList)
    table.insert(self.BottomKeyInfo,self.ESCKeyInfoList)
    self.Tab_Skin:UpdateBottomKeyInfo(self.BottomKeyInfo)
end

function M:UpdateUI()
    M.Super.UpdateUI(self)

    -- 更新手柄UI
    if self.IsGamepadInput then
        self.Key_GamePad_L:SetVisibility((self.bFirst or self.ShopItemData.SinglePreview) and ESlateVisibility.Collapsed or ESlateVisibility.SelfHitTestInvisible)
        self.Key_GamePad_R:SetVisibility((self.bLast or self.ShopItemData.SinglePreview) and ESlateVisibility.Collapsed or ESlateVisibility.SelfHitTestInvisible)
        if self.ShopItemData.SuitRewardId then
            self.Tab_Skin:UpdateSingleBottomKeyInfo(1, self.MenuKeyInfoList)
            self.Tab_Skin:SetSingleBottomKeyInfoVisibility(1, ESlateVisibility.SelfHitTestInvisible)
            self.Key_Preview:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.Btn_Preview:SetVisibility(ESlateVisibility.Collapsed)
        else
            self.Tab_Skin:UpdateSingleBottomKeyInfo(1, {})
            self.Tab_Skin:SetSingleBottomKeyInfoVisibility(1, ESlateVisibility.Collapsed)
            self.Key_Preview:SetVisibility(ESlateVisibility.Collapsed)
        end
        if self.ShopItemData.ItemType == "Skin" or self.ShopItemData.ItemType == "WeaponSkin" then
            self.Key_Dye_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        else
            self.Key_Dye_GamePad:SetVisibility(ESlateVisibility.Collapsed)
        end
        if self.BtnChooseGiftEnable then
            self.Gift_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        else
            self.Gift_GamePad:SetVisibility(ESlateVisibility.Collapsed)
        end

        -- self.Com_Hint.WS_Lock:SetActiveWidgetIndex(1)
        if self.EnableDrag == false then
            self:HideDragKey(true)
        else
            self:HideDragKey(false)
        end
    end

    if self.ActorController.ArmoryHelper.EnableCameraScrolling == false or self.EnableMouseWheel == false then
        self:HideZoomKey(true)
    else
        self:HideZoomKey(false)
    end
end

function M:UpdateReplayTips()
    self.Btn_Selective.OnClicked:Add(self, self.OnClickDyeingPreview)
    if self.ShopItemData.ItemType == "Resource" or self.ShopItemData.ItemType == "Mount" then
        self.KeyDownEvents[self.GamePadOpenSuitKey] = self.OnRKeyDown
        self:HideReplayKey(false)
    else
        self.KeyDownEvents[self.GamePadOpenSuitKey] = self.OnClickSuitPreview
        self:HideReplayKey(true)
    end
end

--- 输入模式切换
function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    M.Super.OnUpdateUIStyleByInputTypeChange(self,CurInputDevice, CurGamepadName)
    self.IsGamepadInput = CurInputDevice == ECommonInputType.Gamepad
    if self.ActorController.ArmoryHelper.EnableCameraScrolling == false or self.EnableMouseWheel == false then
        self:HideZoomKey(true)
    else
        self:HideZoomKey(false)
    end
    if self.ShopItemData.ItemType ~= "Resource" and self.ShopItemData.ItemType ~= "Mount" then
        self:HideReplayKey(true)
    else
        self:HideReplayKey(false)
    end
    self.WS_Btn_Dye:SetActiveWidgetIndex(self.IsGamepadInput and 1 or 0)
    if (self.IsGamepadInput) then
        -- 解锁条件
        -- self.Com_Hint.WS_Lock:SetActiveWidgetIndex(1)
        -- 有套装内容
        if self.ShopItemData.SuitRewardId then
            self.Tab_Skin:UpdateSingleBottomKeyInfo(1, self.MenuKeyInfoList)
            self.Key_Preview:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.Btn_Preview:SetVisibility(ESlateVisibility.Collapsed)
        else
            self.Tab_Skin:UpdateSingleBottomKeyInfo(1, {})
        end
        -- 武器皮肤和角色皮肤显示染色按键
        if self.ShopItemData.ItemType == "WeaponSkin" or self.ShopItemData.ItemType == "Skin" then
            self.Key_Dye_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        else
            self.Key_Dye_GamePad:SetVisibility(ESlateVisibility.Collapsed)
        end
        -- 左右箭头按键
        if (not self.bFirst and not self.ShopItemData.SinglePreview) then self.Key_GamePad_L:SetVisibility(ESlateVisibility.SelfHitTestInvisible) end
        if (not self.bLast and not self.ShopItemData.SinglePreview) then self.Key_GamePad_R:SetVisibility(ESlateVisibility.SelfHitTestInvisible) end
        -- 选择送礼对象按键
        if self.BtnChooseGiftEnable then
            self.Gift_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        else
            self.Gift_GamePad:SetVisibility(ESlateVisibility.Collapsed)
        end
        -- 旋转预览按键
        if self.EnableDrag == false then
            self:HideDragKey(true)
        else
            self:HideDragKey(false)
        end
        self.Key_LevelUp:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        -- self.Com_Hint.WS_Lock:SetActiveWidgetIndex(0)
        -- 非手柄输入时，隐藏手柄按键
        if self.ShopItemData.SuitRewardId then
            self.Key_Preview:SetVisibility(ESlateVisibility.Collapsed)
            self.Btn_Preview:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
        self.Key_GamePad_L:SetVisibility(ESlateVisibility.Collapsed)
        self.Key_GamePad_R:SetVisibility(ESlateVisibility.Collapsed)
        self.Key_Preview:SetVisibility(ESlateVisibility.Collapsed)
        self.Gift_GamePad:SetVisibility(ESlateVisibility.Collapsed)
        self.Key_LevelUp:SetVisibility(ESlateVisibility.Collapsed)
    end
end

-- 进入选择折扣券模式
function M:EnterSelectDiscountMode()
    self.BottomKeyInfo_BeforeSelectDiscount = self.Tab_Skin.ConfigData and self.Tab_Skin.ConfigData.BottomKeyInfo
    if UIUtils.IsGamepadInput() then
        self.Gift_GamePad:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Tab_Change:ForceHideGamePadKey(true)
        self.Tab_Change:UpdateGamePadKey()
        self.Key_GamePad_L:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Key_GamePad_R:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.WS_Btn_Dye:SetActiveWidgetIndex(0)
        self.Key_Preview:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Btn_Function:SetGamepadIconVisibility(false)
        self.Tab_Skin.WBP_Com_Tab_ResourceBar:HideGamePadKey(true)
        self.Key_LevelUp:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
    self.InSelectDiscountMode = true
end

function M:ExitSelectDiscountMode()
    if(self.BottomKeyInfo_BeforeSelectDiscount)then
        local KeyInfo = self.BottomKeyInfo_BeforeSelectDiscount
        self.BottomKeyInfo_BeforeSelectDiscount = nil
        self.Tab_Skin:UpdateBottomKeyInfo(KeyInfo)
    end
    if UIUtils.IsGamepadInput() then
        if self.BtnChooseGiftEnable then
            self.Gift_GamePad:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        end
        self.Tab_Change:ForceHideGamePadKey(false)
        self.Tab_Change:UpdateGamePadKey()
        self.Key_GamePad_L:SetVisibility((self.bFirst or self.ShopItemData.SinglePreview) and UIConst.VisibilityOp["Collapsed"] or UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Key_GamePad_R:SetVisibility((self.bLast or self.ShopItemData.SinglePreview) and UIConst.VisibilityOp["Collapsed"] or UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.WS_Btn_Dye:SetActiveWidgetIndex(1)
        self.Key_Preview:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Btn_Function:SetGamepadIconVisibility(true)
        self.Tab_Skin.WBP_Com_Tab_ResourceBar:HideGamePadKey(false)
        self.Key_LevelUp:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    end
    self.InSelectDiscountMode = false
end

function M:TipsStateChangedCallback(Data, bIsOpen)
    if UIUtils.IsGamepadInput() then
        if bIsOpen then
            local KeyInfo = {}
            table.insert(KeyInfo, self.ESCKeyInfoList)
            self.Tab_Skin:UpdateBottomKeyInfo(KeyInfo)
        else
            local DiscountKeyInfo = {}
            table.insert(DiscountKeyInfo, self.DiscountCheckDetailsKeyInfoList)
            table.insert(DiscountKeyInfo, self.DiscountConfirmKeyInfoList)
            table.insert(DiscountKeyInfo, self.ESCKeyInfoList)
            self.Tab_Skin:UpdateBottomKeyInfo(DiscountKeyInfo)
        end
    end
end

function M:ItemTipsStateChangedCallback(Data, bIsOpen)
    if UIUtils.IsGamepadInput() then
        if bIsOpen then
            local KeyInfo = {}
            self.Tab_Skin:UpdateBottomKeyInfo(KeyInfo)
        else
            local DiscountKeyInfo = {}
            if Data and Data.IsVoucher then
                table.insert(DiscountKeyInfo, self.DiscountCheckDetailsKeyInfoList)
            end
            table.insert(DiscountKeyInfo, self.DiscountConfirmKeyInfoList)
            table.insert(DiscountKeyInfo, self.ESCKeyInfoList)
            self.Tab_Skin:UpdateBottomKeyInfo(DiscountKeyInfo)
        end
    end
end

function M:ItemFocusReceivedCallback(Data)
    if UIUtils.IsGamepadInput() then
        if Data and Data.IsVoucher then
            local DiscountKeyInfo = {}
            table.insert(DiscountKeyInfo, self.DiscountCheckDetailsKeyInfoList)
            table.insert(DiscountKeyInfo, self.DiscountConfirmKeyInfoList)
            table.insert(DiscountKeyInfo, self.ESCKeyInfoList)
            self.Tab_Skin:UpdateBottomKeyInfo(DiscountKeyInfo)
        else
            local DiscountKeyInfo = {}
            table.insert(DiscountKeyInfo, self.DiscountConfirmKeyInfoList)
            table.insert(DiscountKeyInfo, self.ESCKeyInfoList)
            self.Tab_Skin:UpdateBottomKeyInfo(DiscountKeyInfo)
        end
    end
end

function M:HideDragKey(IsHidden)
    if IsHidden then
        self.Tab_Skin:UpdateSingleBottomKeyInfo(5, {})
        self.Tab_Skin:SetSingleBottomKeyInfoVisibility(5, ESlateVisibility.Collapsed)
    else
        self.Tab_Skin:UpdateSingleBottomKeyInfo(5, self.RightThumbstickAnalogBottomKeyInfoList)
        self.Tab_Skin:SetSingleBottomKeyInfoVisibility(5, ESlateVisibility.SelfHitTestInvisible)
    end
end

function M:HideZoomKey(IsHidden)
    if IsHidden then
        self.Tab_Skin:UpdateSingleBottomKeyInfo(4, {})
        self.Tab_Skin:SetSingleBottomKeyInfoVisibility(4, ESlateVisibility.Collapsed)
    else
        self.Tab_Skin:UpdateSingleBottomKeyInfo(4, self.ZoomKeyInfoList)
        self.Tab_Skin:SetSingleBottomKeyInfoVisibility(4, ESlateVisibility.SelfHitTestInvisible)
    end
end

function M:HideReplayKey(IsHidden)
    if IsHidden then
        self.Tab_Skin:UpdateSingleBottomKeyInfo(2, {})
        self.Tab_Skin:SetSingleBottomKeyInfoVisibility(2, ESlateVisibility.Collapsed)
    else
        self.Tab_Skin:UpdateSingleBottomKeyInfo(2, {})
        if self.ShopItemData.ItemType == "Mount" then
            self.Tab_Skin:UpdateSingleBottomKeyInfo(2, self.RideKeyInfoList)
        elseif self.ShopItemData.TypeId then
            local ResourceData = DataMgr.Resource[self.ShopItemData.TypeId]
            if ResourceData then
                if ResourceData.ResourceSType == "GestureItem" then
                    self.Tab_Skin:UpdateSingleBottomKeyInfo(2, self.ReplayKeyInfoList)
                -- elseif ResourceData.ResourceSType == "MountItem" then
                --     self.Tab_Skin:UpdateSingleBottomKeyInfo(2, self.RideKeyInfoList)
                end
            end
        end
        self.Tab_Skin:SetSingleBottomKeyInfoVisibility(2, ESlateVisibility.SelfHitTestInvisible)
    end
end

return M