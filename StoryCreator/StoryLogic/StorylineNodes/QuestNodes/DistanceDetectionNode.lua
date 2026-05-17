
local DistanceDetectionNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')


function DistanceDetectionNode:Init()
    self.PointType1 = "StaticCreator"
    self.PointId1 = 0
    self.PointType2 = "StaticCreator"
    self.PointId2 = 0

    self.Target1 = nil
    self.Target2 = nil
end

function DistanceDetectionNode:Start(QuestLine, InportName)
    if InportName == "Stop" then 
        self:FinishAction()
    else
        self:Execute()
    end
end

function DistanceDetectionNode:Execute()
    self.Widget = UIManager(self):GetUIObj("DungeonCaptureFloat")
    if not self.Widget then
        self.Widget = UIManager(self):LoadUINew("DungeonCaptureFloat")
        if not self.Widget then
            error("距离UI创建失败")
        end
    end
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    if not GameMode then
        return
    end
    if self.PointType1 == "StaticCreator" then
        self.Target1 = GameMode.EMGameState.StaticCreatorMap:Find(self.PointId1)
    elseif self.PointType1 == "ManualItem" then
        self.Target1 = GameMode.EMGameState.ManualActiveCombat:Find(self.PointId1)
    elseif self.PointType1 == "Player" then
        self.Target1 = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    end
    if self.PointType2 == "StaticCreator" then
        self.Target2 = GameMode.EMGameState.StaticCreatorMap:Find(self.PointId2)
    elseif self.PointType2 == "ManualItem" then
        self.Target2 = GameMode.EMGameState.ManualActiveCombat:Find(self.PointId2)
    elseif self.PointType2 == "Player" then
        self.Target2 = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    end

    if not self.Target1 then
        error("未能找到检测点1实体")
    end
    if not self.Target2 then
        error("未能找到检测点2实体")
    end
    self.Widget:RemainingDistance(self.Target1, self.Target2)
end

function DistanceDetectionNode:RemoveWidget()
    if self.Widget then
        self.Widget:EndRemainingDistance()
        self.Widget = nil
    end
end

function DistanceDetectionNode:OnQuestlineFail()
    self:RemoveWidget()
end

function DistanceDetectionNode:OnQuestlineSuccess()
    self:RemoveWidget()
end

function DistanceDetectionNode:FinishAction()
    self:Finish()
end

function DistanceDetectionNode:Clear()
    self:RemoveWidget()
end

return DistanceDetectionNode