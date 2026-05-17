--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_FloorBox_C
local M = Class()

-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

function M:ReceiveBeginPlay()
    local UIManager= GWorld.GameInstance:GetGameUIManager()
    if not UIManager then
        GWorld.GameInstance:GetSceneManager():AddFoorBox(self)
        return
    end
    local battleMain=UIManager:GetUI('BattleMain')
    if not battleMain then
        GWorld.GameInstance:GetSceneManager():AddFoorBox(self)
        return
    end
    local battleMap=battleMain.Battle_Map or battleMain.Battle_Map_PC
    if battleMap then
        battleMap:AddFloorBox(self)
    else
        GWorld.GameInstance:GetSceneManager():AddFoorBox(self)
        return
    end
    if URuntimeCommonFunctionLibrary.IsWorldCompositionEnabled(self) then
        GWorld.GameInstance:GetSceneManager():AddFoorBox(self)
        -- self:CheckPlayerIn()
    end
end

function M:CheckPlayerIn()
    local Player=UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    if Player and UKismetMathLibrary.IsPointInBoxWithTransform(Player:k2_GetActorLocation(),self:GetTransform(),self.RootComponent.BoxExtent) then
        EventManager:FireEvent(EventID.EnterOrExitFloor,true,self)
    end
end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

function M:EnterOrExitFloor(IsEnter)
    EventManager:FireEvent(EventID.EnterOrExitFloor,IsEnter,self)
end

return M
