--
-- DESCRIPTION
-- 单人工会选关View （PC、移动端公用）
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local M = {}

function M:CheckDungeonCondition(DungeonId)
    local RaidDungeon = DataMgr.RaidDungeon[DungeonId]
    local TargetUnixTime = RaidDungeon.UnlockDate
    return (TargetUnixTime == nil or TimeUtils.NowTime() >= TargetUnixTime)
end

function M:GetRaidSeasons()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return nil 
    end
    local CurrentRaidSeasonId = Avatar.CurrentRaidSeasonId
    return Avatar.RaidSeasons[CurrentRaidSeasonId]
end



return M