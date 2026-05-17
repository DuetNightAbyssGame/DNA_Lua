local SplineMoveFinishNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')

-- 玩家沿CinemaMoveSpline移动至终点节点
function SplineMoveFinishNode:Init()
    self.SplineActorIndex = 0
end

function SplineMoveFinishNode:Execute(Callback)
    self.Callback = Callback
    local GameInstance = GWorld.GameInstance
    DebugPrint("SplineMoveFinishNode ",GameInstance)
    self.CinemaMoveSpline = URuntimeCommonFunctionLibrary.FindCinemaMoveSplineByIndex(self.SplineActorIndex,GameInstance)
    if not IsValid(self.CinemaMoveSpline) then
        GWorld.logger.error("SplineMoveFinishNode:Execute, CinemaMoveSpline not found!, SplineActorIndex: "..tostring(self.SplineActorIndex))
        Callback()
        return
    end
    self.bEventExecuted = false
    self.CinemaMoveSpline:BindEventOnEndBoxOverlap(function()
        if not self.bEventExecuted then
            self.bEventExecuted = true
            Callback()
        end
    end)
end

function SplineMoveFinishNode:Stop()
    self:Clear()
end

function SplineMoveFinishNode:Clear()
    if IsValid(self.CinemaMoveSpline) then
        self.CinemaMoveSpline:ClearEventOnEndBoxOverlap()
    end
    self.CinemaMoveSpline = nil
    self.bEventExecuted = false
end

return SplineMoveFinishNode