local M = Class({ 
    "BluePrints.Common.TimerMgr", 
    "BluePrints.Common.DelayFrameComponent"
})

function M:TryGetTalkTask()
    local FlowAsset = self:GetFlowAsset()
    return FlowAsset.TalkTask
end

function M:TryGetFlowGraphComponent()
    local TalkTask = self:TryGetTalkTask()
    return TalkTask.DialogueFlowGraphComponent
end

function M:TryGetRecordComponent()
    local TalkTask = self:TryGetTalkTask()
    return TalkTask.DialogueRecordComponent
end

return M