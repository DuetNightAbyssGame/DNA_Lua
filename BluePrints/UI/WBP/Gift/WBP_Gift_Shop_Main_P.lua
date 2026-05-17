--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Gift_Shop_Main_P_C

local M = Class({"BluePrints.UI.Shop.WBP_Shop_Base_New_C"})

M._components = {"BluePrints.UI.WBP.Gift.WBP_Gift_Shop_Main_BaseView"}

---仅初始化lua变量时使用，千万不要有控件操作！！
-- function M:Initialize(Initializer)
-- end

function M:Construct()
end

-- 空接口：防止父类同名方法被 AssembleComponents 包装调用（由组件提供真实实现）
function M:OnLoaded(...)
    return
end

function M:InitShopTabInfo(MainTabIdx, SubTabIdx, ShopType)
    return
end

function M:OnMainTabChanged(TabWidget)
    return
end

function M:OnSubTabChanged(TabWidget)
    return
end

function M:OnClickFilterOwned()
    return
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    return
end
-- 键盘按键处理（不改基类，仅在礼物商店内映射）
function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = false
    if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
        -- 组件合并函数可能不返回值，容错处理
        IsHandled = self:OnGamePadDown(InKeyName) or false
    else
        if InKeyName == "Escape" then
            self:CloseSelf()
            IsHandled = true
        elseif InKeyName == "Q" then
            local prevIdx = (self.ShopTab and (self.ShopTab.GetCurrentTabIndex and self.ShopTab:GetCurrentTabIndex())) or (self.ShopTab and self.ShopTab.CurrentTab)
            if self.ShopTab and self.ShopTab.TabToLeft then
                self.ShopTab:TabToLeft()
                IsHandled = true
            end
            local nowIdx = (self.ShopTab and (self.ShopTab.GetCurrentTabIndex and self.ShopTab:GetCurrentTabIndex())) or (self.ShopTab and self.ShopTab.CurrentTab)
            if prevIdx and nowIdx and prevIdx ~= nowIdx then
                self:FocusListAfterRefresh(0.12)
            end
        elseif InKeyName == "E" then
            local prevIdx = (self.ShopTab and (self.ShopTab.GetCurrentTabIndex and self.ShopTab:GetCurrentTabIndex())) or (self.ShopTab and self.ShopTab.CurrentTab)
            if self.ShopTab and self.ShopTab.TabToRight then
                self.ShopTab:TabToRight()
                IsHandled = true
            end
            local nowIdx = (self.ShopTab and (self.ShopTab.GetCurrentTabIndex and self.ShopTab:GetCurrentTabIndex())) or (self.ShopTab and self.ShopTab.CurrentTab)
            if prevIdx and nowIdx and prevIdx ~= nowIdx then
                self:FocusListAfterRefresh(0.12)
            end
        elseif InKeyName == "A" then
            local prevIdx = self.Common_Toggle_TabGroup_PC and self.Common_Toggle_TabGroup_PC.CurrentTab
            if self.Common_Toggle_TabGroup_PC and self.Common_Toggle_TabGroup_PC.TabToLeft then
                self.Common_Toggle_TabGroup_PC:TabToLeft()
                IsHandled = true
            end
            local nowIdx = self.Common_Toggle_TabGroup_PC and self.Common_Toggle_TabGroup_PC.CurrentTab
            if prevIdx and nowIdx and prevIdx ~= nowIdx then
                self:FocusListAfterRefresh(0.12)
            end
        elseif InKeyName == "D" then
            local prevIdx = self.Common_Toggle_TabGroup_PC and self.Common_Toggle_TabGroup_PC.CurrentTab
            if self.Common_Toggle_TabGroup_PC and self.Common_Toggle_TabGroup_PC.TabToRight then
                self.Common_Toggle_TabGroup_PC:TabToRight()
                IsHandled = true
            end
            local nowIdx = self.Common_Toggle_TabGroup_PC and self.Common_Toggle_TabGroup_PC.CurrentTab
            if prevIdx and nowIdx and prevIdx ~= nowIdx then
                self:FocusListAfterRefresh(0.12)
            end
        end
    end
    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

-- 手柄按键处理（与主商城绑定一致：肩键切主页签，扳机切子页签，B关闭，X切换筛选）
function M:OnGamePadDown(InKeyName)
    local IsEventHandled = false
    if InKeyName == "Gamepad_LeftTrigger" or InKeyName == "Gamepad_RightTrigger" then
        local prevIdx = self.Common_Toggle_TabGroup_PC and self.Common_Toggle_TabGroup_PC.CurrentTab
        if self.Common_Toggle_TabGroup_PC and self.Common_Toggle_TabGroup_PC.Handle_KeyEventOnGamePad then
            IsEventHandled = self.Common_Toggle_TabGroup_PC:Handle_KeyEventOnGamePad(InKeyName)
        end
        local nowIdx = self.Common_Toggle_TabGroup_PC and self.Common_Toggle_TabGroup_PC.CurrentTab
        if prevIdx and nowIdx and prevIdx ~= nowIdx then
            self:FocusListAfterRefresh(0.12)
        end
    elseif InKeyName == "Gamepad_FaceButton_Right" then
        if not UIManager(self):GetUIObj("CommonDialog") then
            self:CloseSelf()
        end
        IsEventHandled = true
    elseif InKeyName == "Gamepad_RightShoulder" or InKeyName == "Gamepad_LeftShoulder" then
        local prevIdx = (self.ShopTab and (self.ShopTab.GetCurrentTabIndex and self.ShopTab:GetCurrentTabIndex())) or (self.ShopTab and self.ShopTab.CurrentTab)
        if self.ShopTab and self.ShopTab.Handle_KeyEventOnGamePad then
            IsEventHandled = self.ShopTab:Handle_KeyEventOnGamePad(InKeyName)
        end
        local nowIdx = (self.ShopTab and (self.ShopTab.GetCurrentTabIndex and self.ShopTab:GetCurrentTabIndex())) or (self.ShopTab and self.ShopTab.CurrentTab)
        if prevIdx and nowIdx and prevIdx ~= nowIdx then
            self:FocusListAfterRefresh(0.12)
        end
    elseif InKeyName == "Gamepad_FaceButton_Left" then
        if self.Gift_ShopTarget and self.Gift_ShopTarget.OnClick_Change then
            self.Gift_ShopTarget:OnClick_Change()
        end
        IsEventHandled = true
    elseif InKeyName == UIConst.GamePadKey.SpecialRight then
        self:OnClick_Desc()
    else
        -- 与通用商城一致：将未在上方处理的按键交由 Common_Tab 处理，
        -- 其中包含右摇杆聚焦到资源栏的逻辑（RightThumb -> FocusToResource）
        if self.Common_Tab and self.Common_Tab.Handle_KeyEventOnGamePad then
            IsEventHandled = self.Common_Tab:Handle_KeyEventOnGamePad(InKeyName)
        elseif self.ShopTab and self.ShopTab.Handle_KeyEventOnGamePad then
            -- 兜底：如果Common_Tab未初始化，仍尝试交给ShopTab处理
            IsEventHandled = self.ShopTab:Handle_KeyEventOnGamePad(InKeyName)
        end
    end
    return IsEventHandled
end

function M:OnAnimationFinished(InAnimation)
    return
end

function M:CloseSelf()
    return
end

function M:InitPayGiftPage(ShopItemsData)
    return
end

-- 覆写：礼物商店按 GiftSubTabId 枚举并刷新详情

-- function M:Tick(MyGeometry, InDeltaTime)
-- end
function M:UpdateShopDetail(GiftSubTabId)
    return
end
-- function M:Destruct()
-- end
function M:OnFocusReceived()
    ScreenPrint("asa")
end

function M:SetFocus_Lua()
    -- 礼包页：直接取第一个子页聚焦其列表；无条目则聚焦该页面
    if self.CurSubTabMap and self.CurSubTabMap.TabType == "Pack" then
        local widget = self.Group_PayGift:GetChildAt(0)
        local list = widget.List_PayGift
        if list:GetNumItems() > 0 then
            list:NavigateToIndex(0)
            list:SetFocus()
            return
        else
            widget:SetFocus()

            return
        end

        -- 普通商品页：有条目则聚焦第一个商品，否则聚焦到页面
        if self.List_Item:GetNumItems() > 0 then
            self.List_Item:NavigateToIndex(0)
            self.List_Item:SetFocus()
        else
            self:SetFocus()
        end
    end
end
-- 系统聚焦回调时需要的默认目标：礼包页返回礼包列表，否则返回普通商品列表
function M:BP_GetDesiredFocusTarget()
    if self.CurSubTabMap and self.CurSubTabMap.TabType == "Pack" then
        local widget = self.Group_PayGift:GetChildAt(0)
        local list = widget.List_PayGift
        if list:GetNumItems() > 0 then
            return list
        else
            return widget
        end
    end
    return self.List_Item
end

AssembleComponents(M)
return M
