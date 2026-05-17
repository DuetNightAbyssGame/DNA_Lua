--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_HardBossDgClientEventMananger_C

require "UnLua"

local M = Class({
	"BluePrints.GameMode.ClientEventManager.BP_BaseClientEventManager_C",
})

function M:OnClientInit()
    local DungeonInfo = DataMgr.HardBossDg[GameState(self).DungeonId]
    if DungeonInfo then
        self.HardBossId = DungeonInfo.HardBossId or 0
    end

    self.Overridden.OnClientInit(self)

    self:CheckReconnect()
end

-- 单人进联机梦魇，如果播skillfeature时玩家掉线，ds收不到客户端的回调，导致skillfeature流程无法继续
-- 因此在这里(重连后初始化时)检查是否正处在skillfeature中，如果是则直接通知ds继续流程
function M:CheckReconnect() 
    if not GameState(self).IsPlayingSkillFeature then
        return
    end

    self:AddTimer(3, function()
        local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
        Player.RPCComponent:NotifyServerBossSkillFeatureSequenceFinish(Player.Eid)
        DebugPrint("HardBossDgComponent: CheckReconnect in skillfeature, notify DS to continue.")
    end)
end

return M
