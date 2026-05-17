--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Battle_LinenUltiSkill_C
local M = Class("BluePrints.UI.UI_PC.Battle.ExclusiveSkill.Base.Battle_Skill_UI_Base")

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end



function M:OnLoaded(OwnerPlayer, Params)
    -- DebugPrint("gmy@Battle_LinenUltiSkill_PC M:OnLoaded")
    self:StopAllAnimations()
    
    self.Super.OnLoaded(self)
    self.OwnerPlayer = OwnerPlayer
    self:PlayAnimation(self.Fade_In)
end

function M:RemoveSelf()
    -- DebugPrint("gmy@Battle_LinenUltiSkill_PC M:RemoveSelf")
    self:StopAllAnimations()
    
    self:PlayAnimation(self.Fade_Out)
    local EndTime = self.Fade_Out:GetEndTime()
    self:AddTimer(EndTime, function()
        self:Close()
    end, false, 0, "OutAnimFinished")
end


return M
