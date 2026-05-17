--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local BP_AirWallBox_C = Class({
    "BluePrints.Item.BP_CombatItemBase_C",
})

-- function BP_AirWallBox_C:ReceiveTick(DeltaSeconds)
--     self.Overridden.ReceiveTick(self, DeltaSeconds)

--     if self.OutWallTimeTable ~= nil then
--         for OtherActor, Time in pairs(self.OutWallTimeTable) do
--             if Time >= 15 then
--                 local bFilterActor = not OtherActor.bInPool and OtherActor.IsDead and not OtherActor:IsDead() and OtherActor.InitSuccess
--                 if OtherActor ~= nil and OtherActor.IsRealMonster and OtherActor:IsRealMonster() and bFilterActor then
--                     DebugPrint(OtherActor:GetName().." Huaxu region dungeon AirDoorBoxOutCheck time out and kill")
--                     Battle(OtherActor):BattleOnDead(OtherActor.Eid, OtherActor.Eid, 0, EDeathReason.StuckInWall)
--                 end
--                 self.OutWallTimeTable[OtherActor] = nil
--             else
--                 Time = Time + DeltaSeconds
--                 self.OutWallTimeTable[OtherActor] = Time
--             end
--         end
--     end
-- end

function BP_AirWallBox_C:ReceiveBeginPlay()
    BP_AirWallBox_C.Super.ReceiveBeginPlay(self)
    EventManager:AddEvent(EventID.OnLevelDeliverBlackCurtainEnd, self, self.CloseLoading)
    EventManager:AddEvent(EventID.CloseLoading, self, self.CloseLoading)

    local GameState = UGameplayStatics.GetGameState(self)
    local IsInDungeon = GameState and GameState:IsInDungeon()
    if GameState and IsInDungeon and URuntimeCommonFunctionLibrary.IsWorldCompositionEnabled(self) and self.OutAirWallCheckBox then
        DebugPrint(self:GetName().." @gulinan Start Huaxu region dungeon AirDoorBoxOutCheck")
        GameState.CheckOutAirDoorBoxTransform = self.OutAirWallCheckBox:K2_GetComponentToWorld()
        GameState.CheckOutAirBoxLocal = self.OutAirWallCheckBox.BoxExtent * self:GetActorScale3D()
        -- DebugPrint("@gulinan AirDoorBoxOutCheck: "..tostring(GameState.CheckOutAirBoxLocal.X).." "..tostring(GameState.CheckOutAirBoxLocal.Y).." "..tostring(GameState.CheckOutAirBoxLocal.Z))
        if Const.bOutAirWallBoxCheckRangeVisualDebug then
            UE4.UKismetSystemLibrary.DrawDebugBox(self, GameState.CheckOutAirDoorBoxTransform.Translation, GameState.CheckOutAirBoxLocal, FLinearColor(255,0,0), self.OutAirWallCheckBox:K2_GetComponentRotation(), 6000, 20)
        end
    end
end

function BP_AirWallBox_C:ReceiveEndPlay()
    EventManager:RemoveEvent(EventID.OnLevelDeliverBlackCurtainEnd, self)
    EventManager:RemoveEvent(EventID.CloseLoading, self)

end

function BP_AirWallBox_C:OnRep_Size()
    self:SetBoxExtent(self.Size)
end

function BP_AirWallBox_C:AuthorityInitInfo(Info)
    BP_AirWallBox_C.Super.AuthorityInitInfo(self, Info)
    if not self.BpBorn then
        self.Size = Info.Creator.TriggerBoxContent
        self:SetBoxExtent(Info.Creator.TriggerBoxContent, Info.Creator.TriggerTipsBoxContent)
    end
end

function BP_AirWallBox_C:CommonInitInfo(Info)
    BP_AirWallBox_C.Super.CommonInitInfo(self, Info)
    local DynamicEffectId = self.UnitParams["DynamicEffectId"]
    local ConstantEffectId = self.UnitParams["ConstantEffectId"]
    if not DynamicEffectId or not ConstantEffectId then
        return
    end
    local DynamicEffect = DataMgr.VisualEffect[DynamicEffectId].EffectParam.color
    local ConstantEffect = DataMgr.VisualEffect[ConstantEffectId].EffectParam.color

    local DynamicColor = FLinearColor(DynamicEffect[1], DynamicEffect[2], DynamicEffect[3], DynamicEffect[4])
    self.ApproachEffect:GetMaterials():GetRef(1):SetVectorParameterValue("Color", DynamicColor)
    
    local ConstantColor = FLinearColor(ConstantEffect[1], ConstantEffect[2], ConstantEffect[3], ConstantEffect[4])
    self.ResidentEffect:GetMaterials():GetRef(1):SetVectorParameterValue("MainTexColor", ConstantColor)
end

function BP_AirWallBox_C:SetBoxExtent_Multicast(Size)
    local targetVector = FVector(0,0,0)
    if Size ~= nil then
        targetVector.X = self:GetScale(Size.X)
        targetVector.Y = self:GetScale(Size.Y)
        targetVector.Z = self:GetScale(Size.Z) / 2
    end
    if self.Type == 2 then
        targetVector.Z = self:GetScale(Size.Z)
    else
        targetVector.Z = self:GetScale(Size.Z) / 2
    end
    self:SetActorScale(targetVector)
    if self.EMAutoGenerateModifier then
        self.EMAutoGenerateModifier:SpawnAllModifiers()
    end
end

function BP_AirWallBox_C:GetScale(Length)
    if Length < 0 then
        Length = 0
    else
        Length = Length / 100
    end
    return Length
end


function BP_AirWallBox_C:CloseLoading()
    if self.EMAutoGenerateModifier then
        self:AddTimer(1.5,function()
            self.EMAutoGenerateModifier:RefreshNavmodifier()
        end)  
    end
end




return BP_AirWallBox_C
