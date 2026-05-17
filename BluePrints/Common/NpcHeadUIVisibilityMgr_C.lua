require "UnLua"

---@class NpcHeadUIVisibilityMgr : UNpcHeadUIVisibilityMgr
local NpcHeadUIVisibilityMgr = Class("BluePrints.Common.TimerMgr")

function NpcHeadUIVisibilityMgr:OnInitialize()
    EventManager:AddEvent(EventID.OnChangeTaskIndicator, self, self.OnChangeTaskIndicator)
    EventManager:AddEvent(EventID.EnterImmersiveTalk, self, self.OnEnterImmersiveTalk)
    EventManager:AddEvent(EventID.LeaveImmersiveTalk, self, self.OnLeaveImmersiveTalk)
    self.MissionHiddenNpcIds = {}
end

function NpcHeadUIVisibilityMgr:OnDeinitialize()
    EventManager:RemoveEvent(EventID.OnChangeTaskIndicator, self)
    EventManager:RemoveEvent(EventID.EnterImmersiveTalk, self)
    EventManager:RemoveEvent(EventID.LeaveImmersiveTalk, self)
    self.MissionHiddenNpcIds = {}
end

function NpcHeadUIVisibilityMgr:OnEnterImmersiveTalk()
    self:HideAll(true, "ImmersiveTalk")
end

function NpcHeadUIVisibilityMgr:OnLeaveImmersiveTalk()
    self:HideAll(false, "ImmersiveTalk")
end

function NpcHeadUIVisibilityMgr:OnChangeTaskIndicator(InMaps)
    local NewHiddenNpcIds = {}
    if InMaps then
        for _, NpcId in pairs(InMaps) do
            NewHiddenNpcIds[NpcId] = true
        end
    end

    local OldHiddenNpcIds = self.MissionHiddenNpcIds or {}
    for NpcId, _ in pairs(OldHiddenNpcIds) do
        if not NewHiddenNpcIds[NpcId] then
            self:HideNpc(NpcId, false, "Mission")
        end
    end

    for NpcId, _ in pairs(NewHiddenNpcIds) do
        if not OldHiddenNpcIds[NpcId] then
            self:HideNpc(NpcId, true, "Mission")
        end
    end

    self.MissionHiddenNpcIds = NewHiddenNpcIds
end

return NpcHeadUIVisibilityMgr

