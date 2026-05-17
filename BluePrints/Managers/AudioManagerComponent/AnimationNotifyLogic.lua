require "DataMgr"

local Component = {}

-- function SplitPlayerInfo(PlayerInfo)
--     if not PlayerInfo then
--         return ""
--     end
--     if string.sub(PlayerInfo, -1) == "_" then
--         return string.sub(PlayerInfo, 1, -2)
--     end
--     return PlayerInfo
-- end

-- function Component:ContactMonsterBirthSoundStringPath(Monster)
--     local MonsterBrithSePath = "event:/sfx/enemy"
--     local MonsterName = self:GetPlayerName(Monster)
--     if MonsterName then
--         MonsterName = string.gsub(MonsterName,"_","/")
--         MonsterBrithSePath = MonsterBrithSePath.."/"..MonsterName
--     end
--     MonsterBrithSePath = MonsterBrithSePath.."/".."vo_combat"
--     return MonsterBrithSePath
-- end

return Component