local M = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')

function M:Init()
    self.FadeInSeconds = 0
    self.FadeOutSeconds = 0
    self.DurationSeconds = 0
    self.IsStandAlone = false

    self.BlackScreenHandle = nil
    self.BlackScreenDurationHandle = nil
end

function M:Execute(Callback)
    self.DurationSeconds = math.max(0.01, self.DurationSeconds)

    self.BlackScreenHandle = UIManager():ShowCommonBlackScreen({
        InAnimationPlayTime = self.FadeInSeconds,
        InAnimationObj = self,
        InAnimationCallback = function()
            self.BlackScreenDurationHandle = GWorld.GameInstance:AddTimer(self.DurationSeconds, function()
                UIManager():HideCommonBlackScreen(self.BlackScreenHandle)
            end)
        end,

        OutAnimationPlayTime = self.FadeOutSeconds,
        OutAnimationObj = self,
        OutAnimationCallback = function()
            if (not self.IsStandAlone) then
                Callback()
            end
        end
    })

    if (self.IsStandAlone) then
        Callback()
    end
end

function M:Clear()
    if (not self.IsStandAlone) then
        UIManager():CloseCommonBlackScreenWithoutCB(self.BlackScreenHandle)
        GWorld.GameInstance:RemoveTimer(self.BlackScreenDurationHandle)
    end
end

return M
