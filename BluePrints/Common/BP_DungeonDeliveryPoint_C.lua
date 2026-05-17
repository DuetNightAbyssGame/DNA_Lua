--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

---@type BP_DungeonDeliveryPoint_C
local M = Class()

function M:ReceiveBeginPlay()
	GameState(self).DungeonDeliveryPointMap:Add(self.DeliveryPointId, self)

    self.Overridden.ReceiveBeginPlay(self)

    -- self.PointArray 的初始化直接放到蓝图BeginPlay做了

    self.NextAvailableIndex = 1
    self.PlayerToIndex = {}         -- {Eid, Index} 同一个玩家反复用同一个点位
end

function M:GetDeliveryInfo(PlayerEid)
    local Index = self.PlayerToIndex[PlayerEid]
    if not Index then
        if self.NextAvailableIndex > 4 then
            self.NextAvailableIndex = 1
        end
        Index = self.NextAvailableIndex
        self.PlayerToIndex[PlayerEid] = Index
        self.NextAvailableIndex = self.NextAvailableIndex + 1
    end
    local Point = self.PointArray[Index]
    if not Point then
        return nil, nil
    end

    local TargetTransform = Point:K2_GetComponentToWorld()
    return TargetTransform.Translation, TargetTransform.Rotation:ToRotator()
end

return M
