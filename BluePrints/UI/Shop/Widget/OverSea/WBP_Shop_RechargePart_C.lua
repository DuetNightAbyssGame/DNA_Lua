--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Shop_RechargePart_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:InitContent(Params, PopupData, Owner)
    self.ShopItemId = Params.ShopItemId
    local ShopItemData = DataMgr.ShopItem[self.ShopItemId]
    assert(ShopItemData, "未找到商品数据:"..self.ShopItemId)
    self.Text_RechargeTitle:SetText(string.format(GText("UI_Shop_JP_Phoxene"), ShopItemData.TypeNum))
    local Icon = ItemUtils.GetItemIcon(ShopItemData.TypeId, ShopItemData.ItemType)
    self.Image_Icon:SetBrushResourceObject(Icon)
end


return M
