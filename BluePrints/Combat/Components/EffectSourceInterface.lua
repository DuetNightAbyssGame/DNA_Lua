
require "UnLua"
local SkillUtils = require "Utils.SkillUtils"
-- 1.角色
-- 2.武器
-- 3.创生物
-- 4.状态
local Component = Class({
    "BluePrints.Combat.Components.CampComponent",
    "BluePrints.Combat.Components.EffectSourceAttrLogic",
    "BluePrints.Combat.Components.EffectSourceAttrOperate",
    "BluePrints.Common.TimerMgr",
})

function Component:GetEid()
    return self:GetEid_Lua()
end

function Component:GetEid_Lua()
    return self.Eid
end

function Component:OnDead_Lua(...)
    self:OnDead(...)
end

--function Component:OnDead(...)
--    if self:IsCharacter() then
--        self.Overridden.OnDead(self, ...)
--    end
--end

-- function Component:SetDead(IsDead)
--     self.Overridden.SetDead(self, IsDead)
-- end

-- function Component:IsDead()
--     return self.Overridden.IsDead(self)
-- end


-- function Component:SetInvincible(Invincible)
--     self.bIsInvincible = Invincible
--     local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
--     local UIManager = GameInstance:GetGameUIManager()
--     if UIManager then
--         local BossBloodUI = UIManager:GetUI("BossBlood")
--         if BossBloodUI and self == BossBloodUI.Owner then
--             BossBloodUI:UpdateBossInvincibleState(Invincible)
--         end
--     end

--     if (IsValid(self.BillboardComponent)) then
--         self.BillboardComponent:RefreshInvincibleState(Invincible)
--     end
-- end

-- function Component:IsInvincible(Source)
--     return self.bIsInvincible or false
-- end

-- function Component:Check()
--     return self.bIsInvincible or false
-- end

-- function Component:SetSuperArmor(IsSuperArmor)
--     self.Overridden.SetSuperArmor(self, IsSuperArmor)
-- end

-- function Component:IsSuperArmor()
--     return self.Overridden.IsSuperArmor(self)
-- end

-- function Component:SetTNCannotReduce(CannotReduce)
--     self.Overridden.SetTNCannotReduce(self, CannotReduce)
-- end

-- function Component:IsTNCannotReduce()
--     return self.Overridden.IsTNCannotReduce(self)
-- end

function Component:GetLevelTable()
    if self.IsCharacter and self:IsCharacter() then
        return DataMgr.LevelUp
    else
        return DataMgr.WeaponLevelUp
    end
end

function Component:SetLevel(Level)
    if Level == nil then return end
    local LevelUpTable = self:GetLevelTable()
    local LevelUpInfo = LevelUpTable[Level]
    if LevelUpInfo == nil then return end
    self:SetAttr("Level", Level)
end

--function Component:ForbidHitStop_Lua(Forbidden)
--    if Forbidden then
--        if self.ResetHitStopTimer then
--            self:ResetHitStop()
--        end
--    end
--    self.ForbiddenHitStop = Forbidden
--end
--
--function Component:ApplyHitStop(Duration, Dilation)
--    
--    if self.ForbiddenHitStop then
--        return
--    end
--    -- PrintTable({ApplyHitStop=Duration})
--    if self.ResetHitStopTimer then
--        self:RemoveTimer(self.ResetHitStopTimer)
--        self.ResetHitStopTimer = nil
--    end
--    self.InHitStop = true -- 这个没法重入，暂时先不管
--    self:SetTimeDilation(Dilation)
--    self.ResetHitStopTimer = self:AddTimer(Duration, self.ResetHitStop, false, 0, nil, false)
--end
--
--function Component:ResetHitStop()
--    -- PrintTable({ResetHitStop=1})
--    self:RemoveTimer(self.ResetHitStopTimer)
--    self.ResetHitStopTimer = nil
--    self.InHitStop = false
--    local TimeDilation = self.BuffTimeDilation or 1
--    self:SetTimeDilation(TimeDilation)
--end

-- function Component:SetTimeDilation_Lua(Dilation, ForceSet)
--     if not ForceSet then
--         Dilation = Dilation * self:GetBuffTimeDilation()
--     end

--     local Last = self:GetCanNotChangeTimeDilation()
--     self:SetCanNotChangeTimeDilation(false)
--     self:SetTimeDilation(Dilation)
--     self:SetCanNotChangeTimeDilation(Last)
-- end

-- function Component:GetTimeDilation_Lua(bIgnoreBuffTimeDilation)
--     local CustomTimeDilation = self.CustomTimeDilation or 1
--     if bIgnoreBuffTimeDilation then
--         return CustomTimeDilation / self:GetBuffTimeDilation()
--     end
--     return CustomTimeDilation
-- end

-- function Component:SetTimeDilation(Dilation)
--     if self.CanNotChangeTimeDilation then
--         return
--     end
--     self.CustomTimeDilation = Dilation
    
--     local FXComp = self.FXComponent
--     if FXComp then
--         FXComp:SetEffectDilation(Dilation)
--     end

--     local AllChildActors = TArray(AActor)

--     self:GetAttachedActors(AllChildActors, true)
--     for k,v in pairs(AllChildActors) do
--         if v.SetTimeDilation then
--             v:SetTimeDilation(Dilation)
--         else
--             v.CustomTimeDilation = Dilation
--         end
--     end

--     self:SetDanmakuDilation(Dilation)
-- end

--function Component:SetBuffTimeDilation(BuffTimeDilation)
--    if self.BuffTimeDilation == BuffTimeDilation then
--        return
--    end
--    self.BuffTimeDilation = BuffTimeDilation
--    if self.InHitStop then
--        return
--    end
--    self:SetTimeDilation(self.BuffTimeDilation)
--end

function Component:SetTimeDilationByBattle(TimeDilation, bPause)
    if not bPause then
        self:SetCanNotChangeTimeDilation(false)
        if self:IsPlayer() then
            self:RemoveDisableInputTag("BattlePause")
        end
    end
    -- local Weapon = self.GetCurrentWeapon and self:GetCurrentWeapon() or nil
    self:SetTimeDilation(TimeDilation, true)
    if bPause then
        self:SetCanNotChangeTimeDilation(true)
        if self:IsPlayer() then
            self:AddDisableInputTag("BattlePause")
            self:ClearInputCache()
        end
    end
    if self.PassiveEffects then
        for _, PassiveEffect in pairs(self.PassiveEffects) do
            PassiveEffect.CustomTimeDilation = TimeDilation
        end
    end
    Battle(self).CustomTimeDilation = TimeDilation
end

-- 受击特效是否可以播放
-- function Component:HitFxCanShow()
--     if not self.FXComponent then
--         return false
--     end
--     -- 怪物、魅影、召唤物
--     if self:IsMonster() then
--         if self.FXComponent:GetFXPriorityShow(EFXPriorityType.MonsterHit) then
--             return true
--         else
--             return false
--         end
--     -- 联机队友先和怪物用一个
--     elseif self:IsPlayer() and not self:IsMainPlayer() then
--         if self.FXComponent:GetFXPriorityShow(EFXPriorityType.MonsterHit) then
--             return true
--         else
--             return false
--         end
--     -- 主角
--     elseif self:IsMainPlayer() then
--         if self.FXComponent:GetFXPriorityShow(EFXPriorityType.PlayerHit) then
--             return true
--         else
--             return false
--         end
--     end
--     return true
-- end

-- function Component:ApplyHitPerformFX(Source, Content, HitData)
    -- if not self:HitFxCanShow() then
    --     return
    -- end

    -- local WeaponFXGroupName = Content.WeaponFXGroupName
    -- local HitFXId = Content.FXId
    -- local IsFaceToChar = Content.IsFaceToChar
    -- local FxRotator = Content.FxRotator
    -- local HitLocation = HitData.HitLocation or FVector(0, 0, 0)
    -- local HitCollisionName = HitData.HitCollisionName
    -- local IsUseParentScale = HitData.IsUseParentScale
    -- local DestructablePartEid = HitData.DestructablePartEid
    -- local FXSource = nil
    -- local SoundID = nil
    -- local VisualEffect = DataMgr.VisualEffect[HitFXId]
    -- if VisualEffect then
    --     SoundID = VisualEffect.SoundID
    -- end
    -- if Source then
    --     local Root = Source:GetRootSource()
    --     if Root.GetFXQualityBias then
    --         local FXShow, FXQualityBias = Root:GetFXQualityBias()
    --         if not FXShow or FXQualityBias == -1 then
    --             return
    --         end
    --     end
    -- end
    -- if self:IsDead() and (self.DeadEffectIsPlayed or (self.HasBodyAccessories and self:HasBodyAccessories() and self.PlayBodyAccessoryEffect)) then
    --     -- print("PlayDeadEffect not Hit")
    --     return
    -- end
    -- if WeaponFXGroupName and Source then
    --     FXSource = Source:GetCurrentWeapon().FXComponent
    -- end
    
    -- local SocketName = self:GetClosetSocket(Source, self, HitCollisionName, DestructablePartEid)
    
    -- if not (SocketName and self.FXComponent) then
    --     return
    -- end
    -- local LocalRotator = self:CalcRotatorOffset(Source, SocketName, IsFaceToChar, FxRotator, WeaponFXGroupName)
    
    -- if WeaponFXGroupName then
    --     self.FXComponent:PlayGroupFX(WeaponFXGroupName, false, self.Mesh, nil, SocketName, "", HitLocation, LocalRotator, Const.OneVector, nil, false, FXSource, IsUseParentScale, false, 0)
    --     return
    -- end
    -- local NewEffectParam = {}
    -- NewEffectParam.socket = SocketName
    -- NewEffectParam.Location = {HitLocation.X, HitLocation.Y, HitLocation.Z}
    -- if LocalRotator then
    --     NewEffectParam.Rotation = {LocalRotator.Roll, LocalRotator.Pitch, LocalRotator.Yaw}
    -- end
    -- NewEffectParam.SaveLocation = HitData.SaveLocation
    -- NewEffectParam.UseAbsoluteLocation = HitData.UseAbsoluteLocation
    -- NewEffectParam.NotAttached = HitData.NotAttached
    -- NewEffectParam.SoundID = SoundID
    -- NewEffectParam.IsUseParentScale = IsUseParentScale
    -- NewEffectParam.FXSource = Source
    -- self.FXComponent:PlayEffectByIDParams(HitFXId, NewEffectParam)
-- end

-- function Component:CalcRotatorOffset(Source, SocketName, IsFaceToChar, FxRotator, UseWeaponFx)
--     if not IsFaceToChar then 
--         return FxRotator
--     end
--     if not FxRotator then 
--         FxRotator = FRotator(0,0,0)
--     else
--         FxRotator = FRotator(FxRotator[1], FxRotator[2], FxRotator[3])
--     end
--     local Transform = self.Mesh:GetSocketTransform(SocketName, UE4.ERelativeTransformSpace.RTS_World)
--     -- local Rot = FRotator(0,0,0):ToQuat()
--     -- Transform.Rotation = Rot
--     local InverseTrans = Transform:Inverse()
--     local CharLoc = Source:K2_GetActorLocation()

--     local CharToSoc = CharLoc - Transform.Translation
--     local FaceToCharRot = CharToSoc:ToRotator()
--     local FaceToCharTrans = UE4.UKismetMathLibrary.MakeTransform(FVector(0, 0, 0), FRotator(0, FaceToCharRot.Yaw, 0), UE4.FVector(1, 1, 1))
--     local LocalTransform = UE4.UKismetMathLibrary.MakeTransform(FVector(0, 0, 0), FxRotator, UE4.FVector(1, 1, 1))
--     local RelativeTransform = LocalTransform * FaceToCharTrans  * InverseTrans
--     -- if not UseWeaponFx then 
--     --     RelativeTransform = RelativeTransform * Transform
--     -- end
--     -- local Rot = InverseTrans.Rotation:ToRotator()
--     return RelativeTransform.Rotation:ToRotator()
-- end

-- 播放音效
-- function Component:ApplyHitPerformSe(Source, Content, ExtraParams)
--     -- self 是 Monster
--     -- Source 是 Player
--     -- local SocketName = self:GetClosetSocket(Source, self)

--     -- 播放 Id 的声音
--     if IsDedicatedServer(self) then
--         return
--     end
--     DebugPrint("HYY ApplyHitPerformSe", Content.SEId)
--     local SEId = Content.SEId
--     if SEId and DataMgr.SoundEffect[SEId] then
--         local IdSource = self

--         local PlaySoundParams = {}
--         PlaySoundParams.KeyValueGroups = ExtraParams and ExtraParams.KeyValueGroups
--         DebugPrint("HYY", SaveLocation)
--         PlaySoundParams.SaveLocation = ExtraParams and ExtraParams.SaveLocation
--         PlaySoundParams.MeleeHitLevel = Content.MeleeHitLevel

--         -- 怪物召唤物 机关召唤物 子弹 都取 GetRootSource
--         local SourceOwner = Source.GetRootSource and Source:GetRootSource()
--         if self:IsMonster() and SourceOwner:IsMainPlayer() then
--             if ExtraParams and ExtraParams.IsCrit then
--                 PlaySoundParams.IsCrit = ExtraParams.IsCrit
--             end
--             if self:IsDead() then
--                 PlaySoundParams.IsDead = true
--             end
--             PlaySoundParams.KeyValueGroups = PlaySoundParams.KeyValueGroups or {}
--         end
-- 		AudioManager(self):PlayFMODSoundByID(IdSource, SEId, Source, nil, PlaySoundParams)
--     end
-- end

function Component:ApplyHitPerformLiftHeight(Source, Content)
    if not Content.LiftHeight or not Content.LiftTime then
        return
    end
    if not self.GetMovementComponent then
        return
    end
    if self:GetMovementComponent().MovementMode == EMovementMode.MOVE_None then
        -- 可能在RagDoll或者一些奇怪的状态下 先不进入了
        return
    end
    if self:GetMovementComponent().MovementMode == EMovementMode.MOVE_Flying then
        return
    end
    self:GetMovementComponent():SetMovementMode(EMovementMode.MOVE_Flying)
    self.LiftHeightDuration = Content.LiftTime
    self.LiftHeightDeltaValue = Content.LiftHeight / Content.LiftTime
    -- self.CacheInfos["LiftHeightDuration"] = Content.LiftTime
    -- self.CacheInfos["LiftHeightDeltaValue"] = Content.LiftHeight / Content.LiftTime
    self:GetMovementComponent().bSkipLaunchSetFalling = true
end

-- function Component:TickLiftHeight(DeltaSeconds)
--     if not self.CacheInfos["LiftHeightDuration"] or 
--     self.CacheInfos["LiftHeightDuration"] <= 0 then
--         return
--     end
--     self:GetMovementComponent().bSkipLaunchSetFalling = true
--     self.CacheInfos["LiftHeightDuration"] = self.CacheInfos["LiftHeightDuration"] - DeltaSeconds
--     self:K2_SetActorLocation(FVector(self:K2_GetActorLocation().X, self:K2_GetActorLocation().Y, self:K2_GetActorLocation().Z + self.CacheInfos["LiftHeightDeltaValue"] * DeltaSeconds), false, nil, false)
--     if self.CacheInfos["LiftHeightDuration"] <= 0 then
--         self:GetMovementComponent():SetMovementMode(self:GetMovementComponent().DefaultLandMovementMode)
--     end
-- end

--function Component:GetClosetSocket(Source, Target, HitCollisionName, DestructablePartEid)
--    local MinDistanceSocket = ""
--    local MinDistance = -1
--    local CharModelComp = Target.GetCharModelComponent and Target:GetCharModelComponent() or nil
--    if Target:IsCombatItemBase() and (not Target.GetCurrentModelInfo or not Target:GetCurrentModelInfo()) then
--        return nil
--    elseif not CharModelComp or not CharModelComp:GetCurrentModelInfo() then
--        return nil
--    end
--    local ModelInfo = CharModelComp and CharModelComp:GetCurrentModelInfo() or Target:GetCurrentModelInfo()
--    local HitSocketName
--    if DestructablePartEid then
--        local DestructablePart = Battle(self):GetEntity(DestructablePartEid)
--        if DestructablePart then
--            local PartId = DestructablePart.PartId
--            HitSocketName = "DestructablePart"..PartId
--        end
--    end
--    if ModelInfo.HitCapsules and HitSocketName and ModelInfo.HitCapsules[HitSocketName] then
--        return ModelInfo.HitCapsules[HitSocketName]
--    elseif ModelInfo.HitCapsules and HitCollisionName and ModelInfo.HitCapsules[HitCollisionName] then
--        return ModelInfo.HitCapsules[HitCollisionName]
--    end
--    local HitSockets = ModelInfo.DamageFXSockets
--    if not HitSockets then
--        return nil
--    end
--    local CauserLocation = Source:K2_GetActorLocation()
--    for i, v in pairs(HitSockets) do
--        local SocketLocation = Target.Mesh:GetSocketLocation(v)
--        local NowDistance = (SocketLocation - CauserLocation):Size()
--        if MinDistance == -1 or NowDistance < MinDistance then
--            MinDistance = NowDistance
--            MinDistanceSocket = v
--        end
--    end
--    return MinDistanceSocket
--end

-- function Component:OnDamaged(DamageEvent)
--     self.Overridden.OnDamaged(self, DamageEvent)
-- end

-- function Component:OnHealed(DamageEvent)
--     self.Overridden.OnHealed(self, DamageEvent)
-- end

-- function Component:OnBreakCountDown()
--     self.Overridden.OnBreakCountDown(self)
-- end

-- function Component:ShowDamage(DamageEvent)
--     -- self.Overridden.ShowDamage(self, DamageEvent)
-- end

-- function Component:ShowHeal(HealEvent)
-- end

function Component:GetMaxBloodVolume()
    return self:GetAttr("MaxHp")
end

function Component:GetCurrentBloodVolume()
    return self:GetAttr("Hp")
end

-- function Component:GetSummonsList(SummonId, MonsterType, MechanismType)
--     local SummonList = TArray(0)
--     local AllSummonEid = self:GetAllDirectorSummon():ToTable()
--     for _,Eid in pairs(AllSummonEid) do
--         local Summon = Battle(self):GetEntity(Eid)
--         if Summon and Summon.UnitId == SummonId then
--             if MonsterType and Summon:IsMonster() then
--                 SummonList:Add(Eid)
--             end
--             if MechanismType and Summon:IsMechanismSummon() then
--                 SummonList:Add(Eid)
--             end
--         end
--     end
--     return SummonList
-- end

-- function Component:GetObjType()
--     return EObjType.DefaultObjType
-- end

function Component:SetAttrByAttrData(RealAttrName, AttrData, RateIndex, ModId, ModLevel,ReverseValue)
    if AttrData.Rate then
        local FinalRate
        if(type(AttrData.Rate) == "string") then
            AttrData = SkillUtils.GrowProxyBySkillLevel('Mod', ModId, tonumber(ModLevel), AttrData)
            FinalRate = AttrData.Rate
        else
            FinalRate = AttrData.Rate + (AttrData.LevelGrow or 0) * ModLevel
        end
        if ReverseValue then
            FinalRate = -FinalRate
        end
        DebugPrint("Rate:", FinalRate)
        FinalRate = FinalRate + self:GetRateAttr(RealAttrName, "Mod", RateIndex)
        self:SetRateAttr(RealAttrName, "Mod", RateIndex, FinalRate)
    end
    if AttrData.Value then
        local FinalValue
        if(type(AttrData.Value) == "string") then
            AttrData = SkillUtils.GrowProxyBySkillLevel('Mod', ModId, tonumber(ModLevel), AttrData)
            FinalValue = AttrData.Value
        else
            FinalValue = AttrData.Value + (AttrData.LevelGrow or 0) * ModLevel
        end
        if ReverseValue then
            FinalValue = -FinalValue
        end
        DebugPrint("Value:", FinalValue)
        FinalValue = FinalValue + self:GetAddAttr(RealAttrName, "Mod")
        self:SetAddAttr(RealAttrName, "Mod", FinalValue)
    end
end

function Component:SetAttrByMod(ModId, ModLevel,ReverseValue)
    if not ModLevel then
        ModLevel = 0 --没给mod等级就默认0级
    end
    local ModData = DataMgr.Mod[ModId]
    local AddAttrs = ModData.AddAttrs
    if AddAttrs then
        for Index, AttrData in pairs(AddAttrs) do
            local UniqueId = table.concat({"Mod:[",ModId,"]AddAttrs:[",Index,"]"})

            local AttrName = AvatarUtils:GetAttrNameFromAttrData(AttrData, UniqueId)
            
            if AttrName == 'ATK' then
                for _AttrName, _ in pairs(DataMgr.Attribute) do
                    -- CommonConst.RateIndex.GlobalATK 总攻击力乘区
                    local RealAttrName = "ATK_" .. _AttrName
                    self:SetAttrByAttrData(RealAttrName, AttrData, CommonConst.RateIndex.GlobalATK, ModId, ModLevel,ReverseValue)
                end
            else
                -- CommonConst.RateIndex.Default 默认乘区
                self:SetAttrByAttrData(AttrName, AttrData, CommonConst.RateIndex.Default, ModId, ModLevel,ReverseValue)
            end
            local FuncName = "On".. AttrName.."ChangedByMod"
            if self[FuncName] then 
                self[FuncName](self)
            end

            self:UpdateDamageRateAttr(AttrName)
            self:SetAllWeaponModifier(AttrName)
        end
    end
    self:CalcATK()
end

-- 这个函数不能删，表格里有用到
function Component:GetCurrentWeaponAttr(AttrName, DefaultValue)
    if self.GetCurrentWeapon then
        local Weapon = self:GetCurrentWeapon()
        if Weapon then
            return Weapon:GetAttr(AttrName) or DefaultValue
        end
    end
    return DefaultValue
end

function Component:OnDropDistanceChangedByMod()
    if self.InteractiveTriggerComponent then
        self:SetInteractiveTriggerDistance(self:GetAttr("DropDistance"))
    end
end

function Component:GetEMObject(EMObjectClassName)
    local EMObject = self.Overridden.GetEMObject(self, EMObjectClassName)
    return EMObject
end

return Component
