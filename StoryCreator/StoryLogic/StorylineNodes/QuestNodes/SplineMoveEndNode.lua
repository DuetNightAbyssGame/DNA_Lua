local SplineMoveEndNode = Class('StoryCreator.StoryLogic.StorylineNodes.Questline.QuestNode')

-- CinemaMoveSpline关闭节点
function SplineMoveEndNode:Init()
    self.SplineActorIndex = 0
    self.ExitBlendTime = 0.5
end

function SplineMoveEndNode:Start(Context)
    local GameInstance = GWorld.GameInstance
    DebugPrint("SplineMoveEndNode ",GameInstance)
    local CinemaMoveSpline = URuntimeCommonFunctionLibrary.FindCinemaMoveSplineByIndex(self.SplineActorIndex, GameInstance)
    if not IsValid(CinemaMoveSpline) then
        GWorld.logger.error("SplineMoveEndNode:Start, CinemaMoveSpline not found!, SplineActorIndex: "..tostring(self.SplineActorIndex))
        self:Finish()
        return
    end
    CinemaMoveSpline:SplineEnd(self.ExitBlendTime)
    self:Finish()
end

return SplineMoveEndNode