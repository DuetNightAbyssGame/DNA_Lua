local OpenDetectiveAnswerUINode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseQuestNode')

function OpenDetectiveAnswerUINode:Init()
    self.AnswerId = 0
    self.AutoOpenDetectiveGameUI = false
end

function OpenDetectiveAnswerUINode:Execute()
    if (self.AnswerId == 0) then
        return
    end
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    UIManager:LoadUINew("ReasoningItemInformation", self.AnswerId, "DetectiveAnswer", nil, nil, self.AutoOpenDetectiveGameUI)
end

return OpenDetectiveAnswerUINode