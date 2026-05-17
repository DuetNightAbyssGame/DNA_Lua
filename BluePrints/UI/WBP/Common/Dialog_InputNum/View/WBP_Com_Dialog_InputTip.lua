-- WBP_Com_Dialog_InputTip.lua
require "UnLua"

local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

-- 配置常量
local CONST = {
    STATE_EMPTY = 0,   -- 空态（无提示）
    STATE_SHOW  = 1,   -- 显示态（有提示）
}

function M:Construct()
    if self.WS_Type then
        self.WS_Type:SetActiveWidgetIndex(CONST.STATE_EMPTY)
    end
    self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.bIsTipShowing = false
end

---显示提示
---@param Msg string 文本内容
---@param IsError boolean 是否是错误(红色)
function M:ShowMessage(Msg, IsError)
    if self.Text_Tip then 
        self.Text_Tip:SetText(GText(Msg))
    end

    if IsError then
        if self.BG_Tip and self.BG_Color_Red then
            self.BG_Tip:SetColorAndOpacity(self.BG_Color_Red)
        end
        if self.Text_Tip and self.Text_Color_Red then
            self.Text_Tip:SetColorAndOpacity(self.Text_Color_Red)
        end
    else
        if self.BG_Tip and self.BG_Color_Yellow then
            self.BG_Tip:SetColorAndOpacity(self.BG_Color_Yellow)
        end
        if self.Text_Tip and self.Text_Color_Yellow then
            self.Text_Tip:SetColorAndOpacity(self.Text_Color_Yellow)
        end
    end

    if self.WS_Type then
        self.WS_Type:SetActiveWidgetIndex(CONST.STATE_SHOW)
    end

    self.bIsTipShowing = true

    if self.Tips_In then
        self:StopAllAnimations()
        self:PlayAnimation(self.Tips_In)
    end
end

---隐藏提示（回到空态）
function M:HideMessage()
    if not self.bIsTipShowing then
        return
    end
    self.bIsTipShowing = false

    if self.Tips_Out then
        self:StopAllAnimations()
        self:PlayAnimation(self.Tips_Out)
    else
        if self.WS_Type then
            self.WS_Type:SetActiveWidgetIndex(CONST.STATE_EMPTY)
        end
    end

    if not self.Tips_Out and self.WS_Type then
        self.WS_Type:SetActiveWidgetIndex(CONST.STATE_EMPTY)
    end
end

--- 动画结束回调
function M:OnAnimationFinished(InAnimation)
    if InAnimation == self.Tips_Out then
        if self.WS_Type then
            self.WS_Type:SetActiveWidgetIndex(CONST.STATE_EMPTY)
        end
    end
end

function M:Destruct()
end

return M