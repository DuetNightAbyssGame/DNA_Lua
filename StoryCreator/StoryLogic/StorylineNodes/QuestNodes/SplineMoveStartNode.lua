local SplineMoveStartNode = Class('StoryCreator.StoryLogic.StorylineNodes.Questline.QuestNode')

-- CinemaMoveSpline启动节点
function SplineMoveStartNode:Init()
    self.SplineActorIndex = 0
    self.WalkType = 0
    self.MoveSpeedRate = 1.0
    self.bEnableCameraSeq = false
    self.bEnableCameraBlend = false
    self.IsTriggerable = false
    self.CanMoveReverse = false
    self.CanExitSpline = false
    self.bStartOverlap = false
    self.StopAtEndPoint = false
end

function SplineMoveStartNode:Start(Context)
    local GameInstance = GWorld.GameInstance
    DebugPrint("SplineMoveStartNode ",GameInstance)
    local CinemaMoveSpline = URuntimeCommonFunctionLibrary.FindCinemaMoveSplineByIndex(self.SplineActorIndex, GameInstance)
    if not IsValid(CinemaMoveSpline) then
        GWorld.logger.error("SplineMoveStartNode:Start, CinemaMoveSpline not found!, SplineActorIndex: "..tostring(self.SplineActorIndex))
        self:Finish()
        return
    end
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    local Res = CinemaMoveSpline:SplineInit(Player, self.WalkType, self.MoveSpeedRate, self.CanMoveReverse, 
                                        self.CanExitSpline, self.IsTriggerable, self.StopAtEndPoint)
    if not Res then
        --曲线初始化失败，退出
        self:Finish()
        return
    end
    CinemaMoveSpline:SplineStart()
    self:Finish()
end

return SplineMoveStartNode