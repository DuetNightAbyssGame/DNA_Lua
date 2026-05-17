--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_AccessoryDrop_Coin_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
-- function M:Initialize(Initializer)
-- end

-- function M:Construct()
-- end

-- function M:Tick(MyGeometry, InDeltaTime)
-- end

-- function M:Destruct()
-- end

function M:InitView(AccessDropConfig, AccessoryDrop)
    local OwnBoxCoinAmount = self:GetBoxCoinCount(AccessDropConfig.BoxCoinId)

    local RecourceConfig = DataMgr.Resource[AccessDropConfig.BoxCoinId]
    self.Text_Num:SetText(OwnBoxCoinAmount)
    self.Text_Coin:SetText(GText(RecourceConfig.ResourceName))
    self.Icon_Coin:SetBrushResourceObject(LoadObject(RecourceConfig.Icon))
end

function M:GetBoxCoinCount(BoxCoinId)
    local BoxCoin = GWorld:GetAvatar().Resources[BoxCoinId]
    return BoxCoin and BoxCoin.Count or 0
end

return M
