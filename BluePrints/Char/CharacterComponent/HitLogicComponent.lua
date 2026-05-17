
local Component = {}

-- function Component:AddTN(ChangeTN, IgnoreTNCannotReduce)
--     if (not IgnoreTNCannotReduce and self:IsTNCannotReduce()) and ChangeTN < 0 then
--         return
--     end
--     local TN = math.max(0, math.min(self:GetAttr("MaxTN"), self:GetAttr("TN") + ChangeTN))
--     self:SetAttr("TN", TN)
--     --self:GetAttributesSet():OnRep_TN()
-- end

-- function Component:SetBossTNZero()
--     if(self:IsBossMonster() and self:CanApplyToughness())then
--         self:AddTN(-self:GetAttr("TN"))
--         self:BossTNToZeroRecover()
--         self:SetCharacterDefeatedTag()
--     end
-- end

-- function Component:CanCauseMaxHit()
-- 	return self:GetAttr("TN") <= 0 or self:CharacterInTag("Dead")
-- end

-- function Component:IsMaxTN()
--     return self:GetAttr("TN") >= self:GetAttr("MaxTN")
-- end


-- function Component:AddBossTN(ChangeTN, bOnlyEffectiveWhenRecovering, EnableHit, IgnoreTNCannotReduce)
--     --bOnlyEffectiveWhenRecovering为true时仅在韧性回复状态下有效
--     if self:IsBossMonster() and (not bOnlyEffectiveWhenRecovering)then
--         self:AddTN(ChangeTN, IgnoreTNCannotReduce)
--         local TN = self:GetAttr("TN")
--         if TN <= 0 then 
--             self:SwitchToRecoverState(UE4.ETNRecoverState.BossWaitToRecover)
--             self:SetCharacterDefeatedTag()
--         end
--         local Res
--         if EnableHit then
--             Res = self:ApplyEffectHitPerformance_Cpp(nil, UE4.EHitType.LightHit, UE4.ECauseHitType.CauseHitTypeNormal, nil)
--         else
--             if TN <= 0 then
--                 self:OpenRecoverTNTimer()
--             end
--         end
--         Battle(self).Result:Add("AddBossTN", {EnableHit = EnableHit, TargetCurrentTN = TN, ApplySuccess = Res})
--     end
-- end


-- function Component:RecoverToMaxTN()
--     self:AddTN(self:GetAttr("MaxTN"))
--     -- self:RemoveForbidToughnessAndHit()
--     if(self:IsBossMonster())then
--         self:OnBossTNRecoverToMax(self:GetAttr("MaxTN"))
--     end
-- end

-- function Component:StartRecoverTN()
    
--     -- boss在进处刑恢复韧性时，关闭自然恢复
--     if self:IsBossMonster() then
--         -- self:IsExistTimer("BossTNToZeroRecoverStart") or 
--         -- self:IsExistTimer("BossTNToZeroRecoverLoop") then 
--         return 
--     end
    
--     self:AddTimer_Combat(Const.MonsterTNRecoverTickInterival, self.RecoverTN, true, 0, "RecoverTN")
-- end

-- function Component:RecoverTN()
--     self:AddTN(Const.MonsterTNRecoverTickInterival * self:GetAttr("TNRecoverS"))
--     if self:IsMaxTN() then
--         self:DefeatedRecoverToIdle(true)
--         self:RemoveTimer("RecoverTN")
--     end
-- end

-- function Component:BossTNToZeroRecover()
--     local Time = self:GetAttr("TNRecoverTimeZ") or 0
--     -- print(_G.LogTag, "TTT Boss 韧性清零")
--     self:ForbidToughnessAndHit()
--     if Time > 0 then
--         self:AddTimer(Time, self.BossTNToZeroRecoverStart, false, 0, "BossTNToZeroRecoverStart")
--         -- print(_G.LogTag, "TTT Boss 禁止削韧、禁止受击，归零恢复时间为：", Time)
--     else
--         self:BossTNToZeroRecoverStart()
--     end
-- end

-- function Component:BossTNToZeroRecoverStart()
--     if self:IsEnterPenalizeAfterDeath() and self:GetAttr("Hp") <= 0 then 
--         return
--     end
--     local RecoverSpeed = self:GetAttr("BossTNToZeroRecoverSpeed") or 0
--     if RecoverSpeed == 0 then
--         self:RecoverToMaxTN()
--         self:RemoveForbidToughnessAndHit()
--         -- print(_G.LogTag, "TTT Boss 韧性归零恢复速度为0，韧性直接回满，可削韧、受击，当前韧性为：", self:GetAttr("TN"))
--     else
--         -- print(_G.LogTag, "TTT Boss 韧性归零恢复速度为：", RecoverSpeed)
--         self:AddTimer_Combat(Const.BossTNToZeroRecoverTickInterival, self.BossTNToZeroRecoverLoop, true, 0, "BossTNToZeroRecoverLoop")
--         self:OnBossTNRecoverFromZero(self:GetAttr("MaxTN"))
--     end
-- end

-- function Component:BossTNToZeroRecoverLoop()
--     self:AddTN(Const.BossTNToZeroRecoverTickInterival * self:GetAttr("BossTNToZeroRecoverSpeed"))
--     -- print(_G.LogTag, "TTT Boss 韧性归零恢复速度为：", self:GetAttr("BossTNToZeroRecoverSpeed"),"当前韧性为：", self:GetAttr("TN"))
--     if self:IsMaxTN() then
--         self:DefeatedRecoverToIdle(true)
--         self:RemoveTimer("BossTNToZeroRecoverLoop")
--         self:RemoveForbidToughnessAndHit()
--         -- print(_G.LogTag, "TTT Boss 韧性回满，可削韧、受击，当前韧性为：", self:GetAttr("TN"))
--     end
-- end

-- function Component:CleanHitTimer()
--     -- 韧性清零恢复
--     if self:IsBossMonster() then
--         -- self:RemoveTimer("BossTNToZeroRecoverStart")
--         -- self:RemoveTimer("BossTNToZeroRecoverLoop")
--     else
--         self:RemoveTimer("RecoverToMaxTN")
--     end
--     -- 韧性受击恢复
--     -- self:RemoveTimer("StartRecoverTN")
--     -- self:RemoveTimer("RecoverTN")
-- end

-- -- 禁止受击
-- function Component:ForbidToughnessAndHit()
--     self.IsForbidToughness = true
--     self.IsForbidHit = true
-- end

-- -- 恢复受击
-- function Component:RemoveForbidToughnessAndHit()
--     self.IsForbidToughness = false
--     self.IsForbidHit = false
-- end

-- function Component:CanApplyToughness()
--     if self:IsDead() then return false end 
--     return not self.IsForbidToughness
-- end

-- function Component:CanBeHit()
--     return not self.IsForbidHit
-- end

function Component:HasHandlePenalize()
    return self.Data and self.Data.BossPenalize and self.Data.BossPenalize.HandlePenalize and self.Data.BossPenalize.HandlePenalize == 1
end

function Component:HasCannotCondemn()
    return self.Data and self.Data.BossPenalize and self.Data.BossPenalize.CannotCondemn and self.Data.BossPenalize.CannotCondemn == 1
end

function Component:IsEnterPenalizeAfterDeath()
    return self.Data and self.Data.BossPenalize and self.Data.BossPenalize.EnterPenalizeAfterDeath and self.Data.BossPenalize.EnterPenalizeAfterDeath == 1
end

function Component:IsEnterDeathStory()
    return self.Data and self.Data.BossPenalize and self.Data.BossPenalize.PlayStoryAfterDeath and self.Data.BossPenalize.PlayStoryAfterDeath >= 0
end

function Component:IsHpEnterDeathStory()
    if not self:IsEnterDeathStory() then
        return
    end
    local CurrentHp = self:GetAttr("Hp")
    local MaxHp = self:GetAttr("MaxHp")
    return self.Data.BossPenalize.PlayStoryAfterDeath >= (CurrentHp / MaxHp)
end

function Component:IsHpEnterTrueDamage()
    if not self:HasHandlePenalize() or not self:IsInDefeat() then
        return
    end
    if not self.Data or not self.Data.BossPenalize or not self.Data.BossPenalize.MaxHpPercent then
        return
    end
    local CurrentHp = self:GetAttr("Hp")
    local MaxHp = self:GetAttr("MaxHp")
    return self.Data.BossPenalize.MaxHpPercent >= (CurrentHp / MaxHp)
end

function Component:MultiCastSetCharacterTagAfterMaxTN_Implementation(CharacterTag)
    if CharacterTag == "Idle" then
        self.IsBossDefeated = false
        local CondemnPath = self:GetCondemnMontagePath("CondemnEnd_Montage")
        local AnimTime = self:PlayMontageByPath(CondemnPath) or 0
        AnimTime = math.max(0, AnimTime - 0.25)
        if IsAuthority(self) then
            self:SetEnableBeCondemned(ECondemnState.DefeatedEndToIdle)
        end
        self:AddTimer(AnimTime, function() self:SetCharacterTag(CharacterTag) end, false, 0, "DefeatedToIdle")
        if IsClient(self) or IsStandAlone(self) then
            local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
            local UIManager = GameInstance:GetGameUIManager()
            local DefeatedUI = UIManager:GetUIObj("DefeatedInteract")
            if DefeatedUI then
                DefeatedUI:CloseExecuteItem(self)
                self:SetHeightLightTip(false)
            end
        end
    end
end

function Component:DefeatedRecoverToIdle(RecoverMaxTN)
    if not self:CharacterInTag("Defeated") then 
        return 
    end
    self.IsBossDefeated = false
    if self:GetAttr("Hp") > 0 then
        if RecoverMaxTN then
            self:TriggerRecoverMaxTNEvent()
            Battle(self):TriggerBattleEvent(BattleEventName.RecoverMaxTNEvent, self)
            self:MultiCastSetCharacterTagAfterMaxTN("Idle")
        else
            self:MulticastSetCharacterTagOnHitLogic("Idle", false)
        end
        self:RecoverToMaxTN()
    else
		if self:IsEnterDeathStory() then
            self:SendPenalizeStoryEvent()
		else
			Battle(self):BattleOnDead(self.Eid, self.CondemnerEid or 0, 0, EDeathReason.Execute)
		end
    end
    self.CondemnerEid = nil
    self:UseDefeatedCallBack()
    self:EnableToughnessRecover()
end

function Component:GetCondemnMontagePath(CondemnPathSuffix)
    local MontageFolder, MontagePrefix = self:GetHitMontageFolderAndPrefix()
    if MontageFolder then
        local Path = MontageFolder.."Combat/Hit/"..MontagePrefix..CondemnPathSuffix
        return Path
    end
end

function Component:SetCharacterDefeatedTag()
    if not self:HasHandlePenalize() then
        return
    end
    if not self:CharacterInTag("Defeated") then
        self.EnterDefeatedCount = self.EnterDefeatedCount and self.EnterDefeatedCount + 1 or 1
        self:MulticastSetCharacterTagOnHitLogic("Defeated", true)
        local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        if GameMode and self.EnterDefeatedCount == 1 then
            GameMode:TriggerFirstCondemn()
        end
    end
end

function Component:CharQuitHitTag(CombatConditionId, EnterCharacterTag)
    local ChangeInfo = self:GetStateLimitInfo(self.AutoSyncProp.CharacterTag)
    if not ChangeInfo then return end
    local TagTypeMap = self:GetStateLimitTagTypeMap(ChangeInfo)
    if not TagTypeMap["Hit"] then return end
    local TraceInfo="From HitLogicComponent_C:CharQuitHitTag"
    if Battle(self):CheckConditionNew(CombatConditionId, self, nil,TraceInfo) then
        if self.EMAnimInstance then
            self.EMAnimInstance:Montage_Stop(Const.MontageBlendOutTime)
        end
        if EnterCharacterTag == "Defeated" then
            self:SetCharacterDefeatedTag()
        else
            self:MulticastSetCharacterTagOnHitLogic(EnterCharacterTag, false)
        end
    end
end

function Component:QuitDefeatedTag()
    if self:CharacterInTag("Defeated") then
        self:TriggerExecuteCondemnedEvent()
        Battle(self):TriggerBattleEvent(BattleEventName.ExecuteCondemnedEvent, self)
        self:DefeatedRecoverToIdle()
    end
end

function Component:MultiCastPlayCondemnMontage_Implementation()
    if self:IsMonster() then
        self:TriggerBeCondemned()
        Battle(self):TriggerBattleEvent(BattleEventName.BeCondemned, self)
    end
    local CondemnPath = self:GetCondemnMontagePath("Condemn_Montage")
    if not IsAuthority(self) then
        self:PlayMontageByPath(CondemnPath)
    else
        local AnimTime, AnimationAsset = self:PlayMontageByPath(CondemnPath)
        if not AnimationAsset then
            self:QuitDefeatedTag()
            DebugPrint("处刑动画路径文件不存在", CondemnPath)
        else
            local FrameNum = math.floor(AnimationAsset.SequenceLength / (1 / 30) + 0.0001) + 1
            if FrameNum > 61 then
                self:AddTimer(60 / FrameNum * AnimTime, function()
                    if self:GetAttr("Hp") <= 0 then
                        self:QuitDefeatedTag()
                        self:RemoveTimer("QuitDefeatedTag")
                    end
                end)
            end
            local BlendOutTime = AnimationAsset:GetDefaultBlendOutTime() ~= 0 and AnimationAsset:GetDefaultBlendOutTime() or 0.3
            self:AddTimer(AnimTime - BlendOutTime, self.QuitDefeatedTag, false, 0, "QuitDefeatedTag")
        end
    end
end

function Component:PlayEnterCondemnMontage()
    local CondemnPath = self:GetCondemnMontagePath("CondemnStart_Montage")
    local MontageSecond = self:PlayMontageByPath(CondemnPath)
    MontageSecond = self.BattleCharInfo.TNRecoverTimeZ or MontageSecond
    return MontageSecond
end

function Component:EnterDefeatedTag()
	local Movement = self:GetMovementComponent()
    Movement:SetMovementMode(Movement.DefaultLandMovementMode)
	self:TriggerEnterDefeatedEvent()
    Battle(self):TriggerBattleEvent(BattleEventName.EnterDefeatedEvent, self)
    local MontageSecond = self:PlayEnterCondemnMontage()
    if IsAuthority(self) then
        self:SetEnableBeCondemned(not MontageSecond and ECondemnState.AccessEnterDefeated or ECondemnState.CantEnterDefeated)
        if MontageSecond then
            self:AddTimer_Combat(MontageSecond, function() self:SetEnableBeCondemned(ECondemnState.AccessEnterDefeated) end)
        end
    end
    if not (IsClient(self) or IsStandAlone(self)) then
        return
    end
    if not self:HasCannotCondemn() then
        ---@type BP_UIManagerComponent_C
        local DefeatedUI = UIManager(self):GetUIObj("DefeatedInteract")
        if not DefeatedUI then
            DefeatedUI = UIManager(self):LoadUINew("DefeatedInteract")
        end
        DefeatedUI:InitDefeatedCharacter(self)
        self:SetHeightLightTip(true)
    end
    UIManager(self):LoadUINew("ToughnessWeak", self)
    if self.BossBloodUI then
        self.BossBloodUI:ShowToughnessBar(false)
    end
end

function Component:LeaveDefeatedTag()
    if IsAuthority(self) then
        local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        if GameMode then
			for i, PlayerCharacter in pairs(GameMode:GetAllPlayer()) do
                if PlayerCharacter then
                    PlayerCharacter.BattleAchievement:SubmitDamageValueOnLeaveDefeated()
                end
            end
        end
    end
    if not (IsClient(self) or IsStandAlone(self)) then
        return
    end
    if not self:HasCannotCondemn() then
        ---@type BP_UIManagerComponent_C
        ---@type Battle_Execute_PC_C
        local DefeatedUI = UIManager(self):GetUIObj("DefeatedInteract")
        if DefeatedUI then
            DefeatedUI:RemoveExecuteItem(self, "out")
        end
        self:SetHeightLightTip(false)
    end
    if self.BossBloodUI then
        self.BossBloodUI:ShowToughnessBar(true)
    end
end

function Component:SendPenalizeStoryEvent()
    self:SetEnableBeCondemned(ECondemnState.CantEnterDefeated)
    self:PostCustomEvent(self.Data.BossPenalize.StoryEvent)
    self:AddTimer_Combat(1, function() 
        -- self:UnLockCharacterTag("Defeated")
        Battle(self):BattleOnDead(self.Eid, self.CondemnerEid or 0, 0, EDeathReason.Execute)
    end)
    self.CondemnerEid = nil
end

function Component:SetEnableBeCondemned(EnableBeCondemned)
    self.EnableBeCondemned = EnableBeCondemned
end

function Component:GetEnableBeCondemned()
    return self:CharacterInTag("Defeated") and self.EnableBeCondemned == ECondemnState.AccessEnterDefeated
end

function Component:IsCantLeaveDefeated()
    return self:CharacterInTag("Defeated") and not self:IsExistTimer("QuitDefeatedTag") and 
            (self.EnableBeCondemned == ECondemnState.AccessEnterDefeated or self.EnableBeCondemned == ECondemnState.DefeatedStopNotify or self.EnableBeCondemned == ECondemnState.WaitEnterDefeated)
end

function Component:ApplyEffectAddtiveHit(DamageEvent)
    -- Dot类型伤害不触发叠加受击
    if DamageEvent.DamageTag then
        for _, tag in pairs(DamageEvent.DamageTag) do
            if tag == "Dot" then
                return false
            end
        end
    end
    
    local ShoulPlayAdditiveAnim = false
    if self:IsMonster() and not self:IsBossMonster() then 
        -- 技能效果没有填写是轻重或者击飞，有伤害且不是dot，播放叠加受击表现
        if not DamageEvent.CauseHitDamage then 
            ShoulPlayAdditiveAnim = true
        else 
            -- 技能效果填写是轻重或者击飞，且对象还有韧性，有伤害且不是dot，播放叠加受击表现
            local CurTN = self:GetAttr("TN") 
            if CurTN and CurTN > 0 then 
                ShoulPlayAdditiveAnim = true 
            end
        end
    else
        ShoulPlayAdditiveAnim = true 
    end
    
    if ShoulPlayAdditiveAnim then 
        local DamageCauser = Battle(self):GetEntity(DamageEvent.SourceEid)
        DamageCauser = DamageCauser and DamageCauser:GetRootSource()
        return DamageCauser and self:PlayHitAddtiveAnimation(DamageCauser:K2_GetActorLocation())
    else 
        return false 
    end
end

-- function Component:ClearMonsterInfo()
--     self:SetHeightLightTip(false)
-- end

return Component
