--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local WBP_CommonToastScreenMiddleText_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_CommonToastScreenMiddleText_C:Construct()
    --self.ShowText = ""
    --self.LastTime = 0.5
    --self.FadeOutType = 1
    --self.BindFlag = false
end

function WBP_CommonToastScreenMiddleText_C:InitWidget(...)
    local a, b, c = ...
    if (type(a) == "string") then
        self.ShowText = a
        self.LastTime = b
    elseif (type(b) == "string") then
        self.FadeOutType = a
        self.ShowText = b
        self.LastTime = c
    else
        self.ShowText = "请填写文本内容"
    end
end

function WBP_CommonToastScreenMiddleText_C:RefreshShowText(newText)
    self.ShowText = newText
    self:PlayAnimAndCollapsed()
end

function WBP_CommonToastScreenMiddleText_C:WhenPlayAnimFinished()
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Parent:ReduceSubUI()
end

function WBP_CommonToastScreenMiddleText_C:PlayAnimAndCollapsed()
    self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Text_Toast:SetText(self.ShowText)
    local animationName = "FadeOut"
    if (self.FadeOutType==1) then
        animationName = "FadeOut"
    else
        animationName = "FadeOut02"
    end
    local AnimObj = self:GetAnimationByName(animationName)
    self:PlayAnimation(AnimObj)
    if not self.BindFlag then
        self:BindToAnimationFinished(AnimObj, {self, self.WhenPlayAnimFinished})
        self.BindFlag = true
    end
end

function WBP_CommonToastScreenMiddleText_C:Close()
    self.BindFlag = false
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Super.Close(self)
end

return WBP_CommonToastScreenMiddleText_C