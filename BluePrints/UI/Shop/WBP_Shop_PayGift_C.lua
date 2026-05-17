--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Shop_PayGift_P_C
local M = Class({"BluePrints.UI.BP_UIState_C"})
M._components = {
    "BluePrints.UI.UI_PC.Common.HorizontalListViewResizeComp",
}
---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self:AddInputMethodChangedListen()
    self.List_PayGift.OnCreateEmptyContent:Bind(self, function(self)
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.ShopId = nil
        return Content
    end)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
    self:HorizontalListViewResize_TearDown()
end

function M:InitPayGiftInfo(ShopItemsData)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self.List_PayGift:ClearListItems()
    for _, v in ipairs(ShopItemsData) do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.ItemData = v
        if ShopUtils:GetShopItemPurchaseLimit(v.ItemId) ~= 0 or Avatar:CheckShopItemSoldOutDisplay(v.ItemId) then
            self.List_PayGift:AddItem(Content)
        end
    end

    if self.List_PayGift:GetNumItems()>0 then
        self.List_PayGift:RequestFillEmptyContent()
        self.List_PayGift:RequestPlayEntriesAnim()
        local ShopMain = UIManager(self):GetUIObj("ShopMain")
        if (ShopMain and (ShopMain:HasAnyFocus() or ShopMain:HasFocusedDescendants())) and not (CommonUtils:IfExistSystemGuideUI(self)) then
            self:AddTimer(0.01, function ()
                self.List_PayGift:SetFocus()
            end)
        end
    end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    if CurInputDevice == ECommonInputType.Gamepad then
        local ShopMain = UIManager(self):GetUIObj("ShopMain")
        if ((ShopMain and ShopMain:HasAnyFocus()) or self:HasFocusedDescendants()) and not (CommonUtils:IfExistSystemGuideUI(self)) then
            self.List_PayGift:SetFocus()
        end
    end
end

AssembleComponents(M)
return M
