--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Gacha_ExchangeBtn_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C", "BluePrints.Common.TimerMgr"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self:SetVisibility(UE4.ESlateVisibility.Visible)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:Open()
    self:StopAllAnimations()
    self:PlayAnimation(self.In)
    self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.bIsOpen = true
end

function M:Close()
    if self.bIsOpen then
        self.bIsOpen = false
        self:StopAllAnimations()
    end
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:Init(Content)
    self.Text_PopUp:SetText(Content.Text)
    self.OnCloseEvent = Content.OnCloseEvent
end

function M:OnAnimationFinished(InAnim)
    if InAnim == self.In then
        self:PlayAnimation(self.Loop, 0, 0)
    elseif InAnim == self.Out then
        self:SetVisibility(UE4.ESlateVisibility.Collapsed)
        if self.OnCloseEvent and self.OnCloseEvent.Callback then
            self.OnCloseEvent.Callback(self.OnCloseEvent.Obj, self.OnCloseEvent.Params)
        end
    end
end

function M:IsOpen()
    return self.bIsOpen
end

return M
