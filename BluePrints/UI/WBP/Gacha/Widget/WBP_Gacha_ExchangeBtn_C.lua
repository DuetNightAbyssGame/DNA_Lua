--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Gacha_ExchangeBtn_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Btn_Click.OnClicked:Add(self, self.OnItemClick)
    self.Btn_Click.OnHovered:Add(self, self.OnItemHovered)
    self.Btn_Click.OnUnhovered:Add(self, self.OnItemUnhovered)
    self.Btn_Click.OnPressed:Add(self, self.OnItemOnPressed)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:SetIsForbidden(bForbidden)
    self.bForbidden = bForbidden
    if bForbidden then
        self:PlayAnimation(self.Forbidden)
    end
end

function M:OnItemClick()
    if self.bForbidden then
        return
    end
    self:PlayAnimation(self.Click)
end

function M:OnItemHovered()
    if self.bForbidden then
        return
    end
    self:PlayAnimation(self.Hover)
end

function M:OnItemUnhovered()
    if self.bForbidden then
        return
    end
    if self.bCanReceive then
        self:PlayAnimation(self.Reward_Normal)
    else
        self:PlayAnimation(self.Unhover)
    end
end

function M:OnItemOnPressed()
    if self.bForbidden then
        return
    end
    if self.bSelected then
        return
    end
    self:PlayAnimation(self.Press)
end

return M
