local TalkTriggerComponent = require("BluePrints.Story.Talk.Component.TalkTriggerComponent")
---@class DailyTalkModel :Model
local M = Class("BluePrints.Common.MVC.Model")
function M:Init()
    M.Super.Init(self)
    self.DailyTalkNpc = {}
end

function M:Destory()
    self.DailyTalkNpc = nil
    M.Super.Destory(self)
end

--- @return boolean
function M:CheckDailyTalkUnFinish(TalkTriggerId)
    local DailyTalk = DataMgr.DailyTalk[TalkTriggerId]
    if not DailyTalk then return false end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local DailyTalks = Avatar.DailyTalks
    return not DailyTalks[TalkTriggerId]
end

--- 检查当前Npc是否有未领取的奖励
function M:CheckCanDailyTalkReward(NpcId)
    local DailyTalkNpc = DataMgr.DailyTalkNpc
    if not DailyTalkNpc then return end
    local NpcTrigger = DailyTalkNpc[NpcId]
    if not NpcTrigger then return end
    for _, TriggerId in ipairs(NpcTrigger) do
        if self:CheckDailyTalkUnFinish(TriggerId) and TalkTriggerComponent:CheckCondition(TriggerId) then
            return true
        end
    end
    return false
end

--- 检查当前Npc是否有奖励对话
function M:CheckHasDailyTalkReward(NpcId)
    DebugPrint("DailyTalkController CheckHasDailyTalkReward", NpcId, DataMgr.DailyTalkNpc[NpcId])
    local DailyTalkNpc = DataMgr.DailyTalkNpc
    if not DailyTalkNpc then return end
    local NpcTrigger = DailyTalkNpc[NpcId]
    if not NpcTrigger then return end
    return #NpcTrigger > 0
end

function M:RegisterNpc(NpcId, InteractiveComponent)
    if not self.DailyTalkNpc then return end
    self.DailyTalkNpc[NpcId] = InteractiveComponent
end

function M:CheckNeedTick()
    if table.isempty(self.DailyTalkNpc) then
        return false
    else
        return true
    end
end

return M