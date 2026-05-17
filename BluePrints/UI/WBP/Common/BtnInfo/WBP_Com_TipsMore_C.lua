--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local M = Class({"BluePrints.Common.TimerMgr","BluePrints.UI.BP_EMUserWidget_C"})

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()
    self.bIsStretch = false
    -- self:ChangeSizeBoxSize()
    -- self:SetWidgetOpacity(0)
    self.VisibilityType = self:GetVisibility()
    self:SetVisibility(UE4.ESlateVisibility.Visible)

    self:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
    self:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    self:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
end

function M:InitMessage(MessageContent)
    if MessageContent then
        self:SetText(MessageContent)
    end
    -- self:AddTimer(0.02 * UE4.UGameplayStatics.GetGlobalTimeDilation(self),function() self:SetWidgetOpacity(1) end)
end

-- 填充文字
function M:SetText(Text)
    self.Text_Guide:SetText(Text)
end

-- 控件自适应
function M:ChangeSizeBoxSize(MaxLength)
    self.MaxLength = MaxLength or self.MaxLength
    local BubbleSizeBoxSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Panel_Text)
    local OldSize = BubbleSizeBoxSlot:GetSize()
    local NewSize = UE4.FVector2D(self.MaxLength, OldSize.Y)
    BubbleSizeBoxSlot:SetSize(NewSize)
    local TextGuideSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Text_Guide)
    TextGuideSlot:SetSize(UE4.FVector2D(NewSize.X-10, TextGuideSlot:GetSize().Y))
end

-- 计算控件的大小
function M:GetTextRealSize()
    self.Text_Guide:ForceLayoutPrepass()
    local final_size = self:TextSizeWithOffsets()-- + self.Arrow_Bubble:GetDesiredSize() todo
    return final_size
end

function M:TextSizeWithOffsets()
    -- self.Panel_Bubble:ForceLayoutPrepass()
    -- local final_size = self.Panel_Bubble:GetDesiredSize() + UE4.FVector2D(100,20)
    -- UEPrint(self.Panel_Bubble:GetDesiredSize())
    self.Text_Guide:ForceLayoutPrepass()
    local final_size = self.Text_Guide:GetDesiredSize()
    -- if self.bIsStretch then
    --     final_size.X = self.MaxLength
    -- end
    final_size = final_size + UE4.FVector2D(100,100)
    return final_size
end

-- 设置显示隐藏
function M:SetWidgetOpacity(Opacity)
    self:SetRenderOpacity(Opacity)
end

return M
