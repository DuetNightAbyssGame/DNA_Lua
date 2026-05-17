local TalkAudioComp_C = require "BluePrints.Story.Talk.Controller.TalkAudioComp"

local M = Class("BluePrints.Story.Talk.Controller.TalkTaskBase")

function M:Start(TalkTaskData, NodeFinished_Callback)
	M.Super.Start(self, TalkTaskData, NodeFinished_Callback)

	self.TalkTaskData = TalkTaskData
	self.NodeFinished_Callback = NodeFinished_Callback

	self.TalkAudioComp = TalkAudioComp_C.New()

    AudioManager(GWorld.GameInstance):AddAuANotifyForbidTag(self.UnitKey)

	local CurrentDialogueData = DataMgr.Dialogue[self.TalkTaskData.FirstDialogueId]
	self:OnPlayingDialogue(CurrentDialogueData)
	self:PlayAudio(CurrentDialogueData, function()
        self:Clear()

        if self.NodeFinished_Callback and self.NodeFinished_Callback[2] then
            local NodeFinished_Obj = self.NodeFinished_Callback[1]
            local NodeFinished_Func = self.NodeFinished_Callback[2]
            NodeFinished_Func(NodeFinished_Obj, self)
        end
	end, IsValid(self.TalkTaskData.AudioAttachActor), nil, nil, self.TalkTaskData.AudioAttachActor)
end

function M:Clear()
    M.Super.Clear(self)

    AudioManager(GWorld.GameInstance):RemoveAuANotifyForbidTag(self.UnitKey)
    self:ClearAudio()
end

function M:OnInterrupted()
	self:Clear()
end

function M:OnPaused()
	self:PauseAudio()
end

function M:OnPauseResumed()
	self:ResumePauseAudio()
end

return M
