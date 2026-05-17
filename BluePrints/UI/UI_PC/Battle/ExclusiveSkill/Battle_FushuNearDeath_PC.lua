require "UnLua"

---@type Battle_ShuimuSkill_PC_C
local M = Class("BluePrints.UI.UI_PC.Battle.ExclusiveSkill.Base.Battle_Skill_UI_Base")

function M:Initialize(Initializer)
    self.Super.Initialize(self)
    self.OwnerPlayer = nil
end

function M:OnLoaded(PlayerCharacter, SpecialUIInfo)
	self.Super.OnLoaded(self, PlayerCharacter, SpecialUIInfo)
    local  Alpha=SpecialUIInfo.FlashLevel or 1
    self:SetAnim(Alpha)
end

function M:SetAnim(Alpha)
   if Alpha==1 then
        self.UsedAnim=self.LV_1
    elseif Alpha==2 then
        self.UsedAnim=self.LV_2
    else
        self.UsedAnim=self.LV_3
    end
    self:PlayAnimation(self.UsedAnim)
end

function M:RemoveSelf()
    --self.Super.RemoveSelf()
    self:BindToAnimationFinished(self.UsedAnim, function ()
        self:UnbindAllFromAnimationFinished(self.UsedAnim)
       self:Close()
    end)
    self:PlayAnimationReverse(self.UsedAnim)
end

return M
