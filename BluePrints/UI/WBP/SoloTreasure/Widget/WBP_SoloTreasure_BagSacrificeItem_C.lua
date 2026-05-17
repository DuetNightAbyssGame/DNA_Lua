--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_SoloTreasure_BagSacrificeItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:Init(Num)
    self.Num = Num
    self.Text_Num:SetText(self.Num)
    self.bEnough = false
    --self:PlayAnimation(self.Normal) 
end

function M:UpdateProgressNum(Progress)
    if Progress >= self.Num and not self.bEnough then
        self.bEnough = true
        self:StopAnimation(self.Select_In)
        self:PlayAnimation(self.Select_In)
        self:BindToAnimationFinished(self.Select_In, function ()
            self:UnbindAllFromAnimationFinished(self.Select_In)
            self:PlayAnimation(self.Select)
        end)
        return
    end
    if Progress < self.Num and self.bEnough then
        self.bEnough = false
        self:StopAnimation(self.Select_In)
        self:PlayAnimationReverse(self.Select_In)
        self:BindToAnimationFinished(self.Select_In, function ()
            self:UnbindAllFromAnimationFinished(self.Select_In)
            self:PlayAnimation(self.Normal)
        end)
    end
end

function M:CloseSelf()
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
end

return M