
local DynamicQuestFailNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')

function DynamicQuestFailNode:Execute(Callback)
    local ClientEventUtils = require "BluePrints.Common.ClientEvent.ClientEventUtils"
    local CurrentEvent =  ClientEventUtils:GetCurrentDoingDynamicEvent()
    assert(CurrentEvent, "客户端不存在动态任务")

    local CompositeCallback = function()
        if (self.UseTalkFadeOut) and (self.TalkFadeOutTime) then
            local TalkContext = GWorld.GameInstance:GetTalkContext()
            if TalkContext then
                local TalkBlackUI = TalkContext:GetSimpleBlackUI()
                if TalkBlackUI then
                    TalkBlackUI:FadeOut(self.TalkFadeOutTime)
                end
            end
        end
    end

    CurrentEvent:TryFinishEvent(false, CompositeCallback)
end

return DynamicQuestFailNode