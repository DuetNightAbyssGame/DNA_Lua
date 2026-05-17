require "UnLua"

---@type Common_Button_Close_PC_C|Common_Button_PC|WBP_Com_BtnClose_C
local Common_Button_Close_PC = Class("BluePrints.UI.UI_PC.Common.Common_Button.Common_Button_PC")

function Common_Button_Close_PC:Construct()
    self.Super.Construct(self, self.Btn_Close)
end

-- 现在没有动效但是我先写上
function Common_Button_Close_PC:SwitchNormalAnimation()
    self:StopAllAnimations()
    -- self:PlayAnimation(self.UnHover)
    self:PlayAnimation(self.Normal)
end

return Common_Button_Close_PC