local GameFlowUtils = require("Utils.GameFlowUtils")

local M = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')

function M:Init()
    self.CountdownSeconds = 15
    self.OpenUI = false
    self.Text = ""
    self.RedCountdownSeconds = 5

    self.UI = nil
    self.Callback = nil
end

function M:Execute(Callback)
    self.Callback = Callback

    self.FlowId = GameFlowUtils:AddFlow("StorylineCountdown",
            { GWorld.GameInstance, function(FlowId)
                self:HandleExecuteCountdown()
            end
            }, { GWorld.GameInstance, function(FlowId)
                self:HandleBlockedCountdown()
            end }, { GWorld.GameInstance, function(FlowId)
                self:HandleRemovedCountdown()
            end })
end

function M:Stop()
    self:Clear()
end

function M:Clear()
    self.Callback = nil
    GameFlowUtils:RemoveFlow(self.FlowId)
end

function M:HandleExecuteCountdown()
    if (IsValid(self.UI)) then
        self.UI:SetVisibility(ESlateVisibility.Visible)
        self.UI:ResumeCountdown()
    else
        local UIManager = UIManager(GWorld.GameInstance)
        self.UI = UIManager:_CreateWidgetNew("StorylineCountdown")
        self.UI:Init(self.CountdownSeconds, self.OpenUI, GText(self.Text), self.RedCountdownSeconds, { self, function()
            if (self.Callback) then
                self.Callback()
            end
        end })
    end
end

function M:HandleBlockedCountdown()
    if (IsValid(self.UI)) then
        self.UI:SetVisibility(ESlateVisibility.Collapsed)
        self.UI:PauseCountdown()
    end
end

function M:HandleRemovedCountdown()
    if (IsValid(self.UI)) then
        self.UI:Close()
        self.UI = nil
    end
end

return M
