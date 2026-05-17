local SetTimeOfDayNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseQuestNode')

function SetTimeOfDayNode:Init()
    self.TargetTime = 0
    self.NeedLerp = false
    self.LerpTime = 0
end

function SetTimeOfDayNode:Execute()
    if not (self.EnvironmentManager and IsValid(self.EnvironmentManager)) then
        local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
        self.EnvironmentManager = UE4.UGameplayStatics.GetActorOfClass(Player,UE4.AEnvironmentManager:StaticClass()) 
    end
    self.EnvironmentManager:SetTimeOfDay(self.TargetTime, true, ESetTODReason.DesignSet, self.NeedLerp, self.LerpTime)
end

return SetTimeOfDayNode