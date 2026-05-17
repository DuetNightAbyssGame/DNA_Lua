



local PlayerCameraSightNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')


function PlayerCameraSightNode:Init()
    self.TargetPointName = ""
    self.KeepSightTime = 0
    self.ECameraAxisLockType = "None"
    self.Speed = 1
end

function PlayerCameraSightNode:Execute(Callback)
    DebugPrint("------------ PlayerCameraSightNode ------------------")
	local GameInstance = GWorld.GameInstance
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    local EMGameState = UE4.UGameplayStatics.GetGameState(GameInstance)
	local NewTargetPoint = EMGameState:GetTargetPoint(self.TargetPointName)
    if(NewTargetPoint and Player and Player.StartCameraKeepSightOnActor)then
        local Func = function()
            Callback()
        end
        Player:StartCameraKeepSightOnActor(NewTargetPoint,self.KeepSightTime,self.ECameraAxisLockType,self.Speed,Func)
    else
        print(_G.LogTag, "ERROR: 不存在NewTargetPoint：" .. (self.TargetPointName or "") .. "或PlayerCharacter不可用")
        Callback()
    end
end

return PlayerCameraSightNode
