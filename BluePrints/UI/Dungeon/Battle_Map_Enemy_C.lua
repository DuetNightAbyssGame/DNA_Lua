--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type Battle_Map_Enemy_PC_C
local M = Class()

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()
    self.MonsterIcon2EndIcon:Add("/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Enemy.T_Gp_Enemy","/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Enemy_Sleep.T_Gp_Enemy_Sleep")
    self.MonsterIcon2EndIcon:Add("/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Rescue_Elite.T_Gp_Rescue_Elite","/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Rescue_Elite_Sleep.T_Gp_Rescue_Elite_Sleep")
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

return M
