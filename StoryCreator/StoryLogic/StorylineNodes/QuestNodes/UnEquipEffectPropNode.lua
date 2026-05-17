
local UnEquipEffectPropNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')

function UnEquipEffectPropNode:Execute(Callback)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    if not Player then
        Callback("Out")
        return
    end
    local ActiveId = Player.ActivePropEffectId
    DebugPrint("lgc@UnEquipEffectPropNode:Execute ActivePropEffectId:", ActiveId)
    if ActiveId == nil or ActiveId == -1 then
        Callback("Out")
        return
    end
    local Avatar = GWorld:GetAvatar(Player)
    if not Avatar then
        Callback("Out")
        return
    end
    Avatar:UseWheelItemInBattle(ActiveId)
    Callback("Out")
end

function UnEquipEffectPropNode:Clear()
end

return UnEquipEffectPropNode