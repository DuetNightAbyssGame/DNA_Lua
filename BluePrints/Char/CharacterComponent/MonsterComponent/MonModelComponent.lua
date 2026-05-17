
require "UnLua"

local Component = Class({
    "BluePrints.Char.CharacterComponent.CharModelComponent",
})

function Component:LoadCurrentModel()
    if self:IsMonster() and self.IsFromCache and (not self.ShadowModelId or self.ShadowModelId == 0) then
        -- 缓存池里出来的怪物 不重复执行
        return
    end
    -- Component.Super.LoadCurrentModel(self)
    self:GetCharModelComponent():LoadCurrentModel()
end

-- function Component:GetMonBirthMontagePath(ModelData)
--     local PlayerAnimPath = ModelData.MontageFolder or ""
--     local Prefix = ModelData.MontagePrefix or ""
--     local Path = PlayerAnimPath.."Combat/Hit/"..Prefix.."Birth_Montage".."."..Prefix.."Birth_Montage"
--     return Path
-- end

return Component