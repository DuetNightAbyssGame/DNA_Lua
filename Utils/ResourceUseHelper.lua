local DummyAvatar = Class()

DummyAvatar._components = {
    "BluePrints.Client.Entities.CommonComponents.ResourceUseComponent",
}

function DummyAvatar:ForceUseItemInBattle(ResourceId)
    local ResourceInfo = DataMgr.Resource[ResourceId]
    local UseBPFunction = ResourceInfo.UseBPFunction
    local PlayAnim = ResourceInfo.PlayAnim
    local PlayArmoryAnim = ResourceInfo.PlayArmoryAnim
    local UseEffectType = ResourceInfo.UseEffectType
    
    local GameInstance = GWorld.GameInstance
    DebugPrint("gmy@ResourceUseHelper DummyAvatar:ForceUseItemInBattle", GWorld:GetMainPlayer())
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(GameInstance, 0)
    local PlayerCharacter = PlayerController:GetMyPawn():Cast(UE4.APlayerCharacter)

    if UseEffectType then
        self["ResourceUseEffect"..UseEffectType](self, ResourceInfo, PlayerCharacter)
    end

    -- 手势动作
    if UseBPFunction or PlayAnim or PlayArmoryAnim then
        PlayerCharacter:InvokeResourceBPFunction(ResourceId)
    end
end

AssembleComponents(DummyAvatar)

return DummyAvatar