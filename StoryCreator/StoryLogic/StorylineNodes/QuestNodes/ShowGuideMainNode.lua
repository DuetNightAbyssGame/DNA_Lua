local GameFlowUtils = require "Utils.GameFlowUtils"

local ShowGuideMainNode = Class('StoryCreator.StoryLogic.StorylineNodes.Questline.QuestNode')
ShowGuideMainNode._components = {
    "StoryCreator.StoryLogic.StorylineNodes.QuestNodes.GuideNodeComp"
}

function ShowGuideMainNode:Init()
    self.GuideId = 0
end

function ShowGuideMainNode:Start(Context)
    if self.Context.IsFail and UE4.UKismetSystemLibrary.GetFrameCount() == self.Context.FrameCount then
        self:FinishAction()
        return
    end
    DebugPrint("===============ShowGuideMainNode Start===============")
    self.Context = Context
    local GameInstance = GWorld.GameInstance
    DebugPrint(self.GuideId, type(self.GuideId))
    self.GuideId = tonumber(self.GuideId)

    if self.GuideId then
        GameFlowUtils:AddFlow("GuideMain", {
            GWorld.GameInstance, function(_, Flow)
                local UIStateAsyncActionBase = UE4.UUIStateAsyncActionBase.ShowGuideUI(GameInstance, self.GuideId)
                UIStateAsyncActionBase.OnGuideEnd:Add(GameInstance, function ()
                    GameFlowUtils:RemoveFlow(Flow)
                    self:FinishAction()
                end)
            end
        })
        -- self.UIStateAsyncActionBase = UE4.UUIStateAsyncActionBase.ShowGuideUI(GameInstance, self.GuideId)
        -- self.UIStateAsyncActionBase.OnGuideEnd:Add(GameInstance, function () self:FinishAction() end)
    else
        self:FinishAction()
    end
end

function ShowGuideMainNode:FinishAction()
    DebugPrint("===============ShowGuideMainNode End===============")
	self:Finish()
end

function ShowGuideMainNode:Clear()
    if self.UIStateAsyncActionBase and self.UIStateAsyncActionBase.OnGuideEnd:IsBound() then
        self.UIStateAsyncActionBase.OnGuideEnd:Clear()
    end
end

AssembleComponents(ShowGuideMainNode)
return ShowGuideMainNode