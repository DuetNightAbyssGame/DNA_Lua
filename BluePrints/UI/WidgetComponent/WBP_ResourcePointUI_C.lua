--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local WBP_ResourcePointUI_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_ResourcePointUI_C:InitConfig(Owner)
    self.StyleNodeName = "Blood_Shield"

    local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.BgWidget)
    -- self.ProgressBarLength = CanvasSlot:GetSize().X - 2
    -- self.ProgressBarHeight = CanvasSlot:GetSize().Y - 2
    -- self.LastCharEsValue = 100
    -- self.LastCharHpValue = 100
    -- 初始化资源点倒计时UI
    self[self.StyleNodeName]:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.RootWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.RootWidget:SetRenderOpacity(0.0)
    self.Owner = Owner
end

function WBP_ResourcePointUI_C:CheckIsShowByType(StyleNodeName)
    if (self[StyleNodeName] == nil) then
        return false
    end

    if not self.bCanShow then
        return true
    end

    return self.RootWidget:GetRenderOpacity() >= 1.0 and self[StyleNodeName]:GetRenderOpacity() >= 1.0 and self:GetVisibility() == UE4.ESlateVisibility.SelfHitTestInvisible
end

function WBP_ResourcePointUI_C:AdaptShieldBarAndBloodBar(ShieldTotalPercent, BloodTotalPercent, MaxBloodValue, NowBloodValue, MaxShieldValue, NowShieldValue, IsNeedShowBillboard)
end

function WBP_ResourcePointUI_C:ReceiveSetVisibility()
    self.Overridden.ReceiveSetVisibility(self)
end

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

return WBP_ResourcePointUI_C
