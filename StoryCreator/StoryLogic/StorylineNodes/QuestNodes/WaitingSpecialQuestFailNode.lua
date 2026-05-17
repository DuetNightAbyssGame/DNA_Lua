
local WaitingSpecialQuestFailNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')
local ClientEventUtils = require "BluePrints.Common.ClientEvent.ClientEventUtils"

function WaitingSpecialQuestFailNode:Execute(Callback)
    local CurrentEvent = ClientEventUtils:GetCurrentEvent()
    if not CurrentEvent or CurrentEvent.Type ~= "SpecialQuest" then
        local Message = "客户端不存在特殊任务"..
		"\nFileName:"..self.Context.FileName..
		"\nNodeInfo:"..self:ToString()
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.SpecialQuest, "客户端不存在特殊任务", Message)
    end
    local FinishNodeCallback = function ()
        self.Context:AddPayload("SpecialQuestFail", true)
        Callback()
    end
    CurrentEvent:AddFailNodeCallback(self,FinishNodeCallback)
end

function WaitingSpecialQuestFailNode:Clear()
    local CurrentEvent = ClientEventUtils:GetCurrentEvent()
    if CurrentEvent and CurrentEvent.Type == "SpecialQuest" then
        CurrentEvent:RemoveFailNodeCallback(self)
    end
end

return WaitingSpecialQuestFailNode