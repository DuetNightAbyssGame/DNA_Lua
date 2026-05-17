local Component = {}

-- function Component:TriggerDead(DamageEvent)
--     local Target = self:GetEntity(DamageEvent.TargetEid)
--     if Target and not Target:IsDead() then
--         self:TriggerBattleEvent(BattleEventName.OnSelfDying, Target, DamageEvent)
--         local SourceEid = DamageEvent.SourceEid
--         local SkillId = DamageEvent.Skill and DamageEvent.Skill.SkillId or 0
--         local DeathReason = EDeathReason.Normal
--         if Target:IsMonster() and Target:HasAnyTags_Table(Target, Const.CaptureMonster, false) then
--             self:CaptureMonster(Target.Eid, SourceEid, SkillId, EDeathReason.Capture)
--         elseif Target:IsCharacter() and (Target:IsEnterPenalizeAfterDeath() or Target.CondemnerEid) then
--             self:EnterBePenalizedState(Target.Eid)
--         else
--             self:BattleOnDead(Target.Eid, SourceEid, SkillId, DeathReason, DamageEvent)
--         end
--     end
-- end

-- function Component:EnterBePenalizedState(TargetEid)
--     local Entity = self:GetEntity(TargetEid)
--     if not Entity then return end
--     Entity:SetDead(true)
--     Entity:CleanHitTimer()
--     Entity:SetCharacterDefeatedTag()
--     self.Result:Add("EnterBePenalizedState", {
--         TargetEid = TargetEid
--     })
-- end

-- function Component:CaptureMonster(TargetEid, KillMineRoleEid, KillMineSkillId, DeathReason)
--     local Entity = self:GetEntity(TargetEid)
--     if not Entity then return end
--     Entity:SetDead(true)
--     Entity:MonsterWaitForCapture(KillMineRoleEid, KillMineSkillId, DeathReason)
--     self.Result:Add("CaptureMonster", {
--         TargetEid = TargetEid,
--         KillMineRoleEid = KillMineRoleEid,
--         KillMineSkillId = KillMineSkillId,
--         DeathReason = DeathReason,
--     })
-- end

function Component:AddCaptureResult(ResultName, TargetEid, KillMineRoleEid, KillMineSkillId, DeathReason)
    self.Result:Add(ResultName, {
        TargetEid = TargetEid,
        KillMineRoleEid = KillMineRoleEid,
        KillMineSkillId = KillMineSkillId,
        DeathReason = DeathReason,
    })
end

function Component:Play_CaptureMonster(Content)
    local Target = self:GetEntity(Content.TargetEid)
    if not Target then return end
    self:CaptureMonster(Content.TargetEid, Content.KillMineRoleEid, Content.KillMineSkillId, Content.DeathReason)
end

function Component:CaptureMonsterSuccess(TargetEid, KillMineRoleEid, KillMineSkillId, DeathReason)
    local Entity = self:GetEntity(TargetEid)
    if not Entity then return end
    Entity:SetDead(true, DeathReason, KillMineRoleEid, KillMineSkillId)
    Entity:CaptureMonsterSuccess(KillMineRoleEid, KillMineSkillId, DeathReason)
    self.Result:Add("CaptureMonsterSuccess", {
        TargetEid = TargetEid,
        KillMineRoleEid = KillMineRoleEid,
        KillMineSkillId = KillMineSkillId,
        DeathReason = DeathReason,
    })
end

function Component:Play_CaptureMonsterSuccess(Content)
    local Target = self:GetEntity(Content.TargetEid)
    if not Target then return end
    self:CaptureMonsterSuccess(Content.TargetEid, Content.KillMineRoleEid, Content.KillMineSkillId, Content.DeathReason)
end

function Component:BattleOnDead_Lua(TargetEid, KillMineRoleEid, KillMineSkillId, DeathReason)
    
    -- if Entity:IsDead() then
    --     return
    -- end
    
    -- DeathReason = DeathReason or EDeathReason.NoReason
    -- self:TriggerBattleEvent(BattleEventName.OnBeforeDead, Entity, DeathReason)

    -- Entity:SetDead(true, DeathReason, KillMineRoleEid, KillMineSkillId)
    -- Entity:OnDead(KillMineRoleEid, KillMineSkillId, DeathReason)
    -- if not bIsDanmakuTarget then
    --     self:TriggerBattleEvent(BattleEventName.OnAfterDead, Entity, KillMineRoleEid, DeathReason)
    -- end

    -- if not bIsDanmakuTarget and (Entity:IsPlayer() or Entity:IsPhantom()) and DeathReason ~= EDeathReason.GMChangeRole then
    --     EventManager:FireEvent(EventID.CharDie, TargetEid)
    --     Entity:ResetCapSize()
    -- end
end

--function Component:Play_Dead(Content)
--    local Target = self:GetEntity(Content.TargetEid)
--    if not Target then
--        PrintTable({CanNotGetTarget=Content.TargetEid})
--        return
--    end
--
--    local TargetEid = Content.TargetEid
--    local bIsDanmakuTarget = self:IsDanmakuCreatureEid(TargetEid)
--    local Entity = bIsDanmakuTarget and self:GetDanmakuCreatureById(TargetEid) or self:GetEntity(TargetEid) 
--    if not Entity then
--        return
--    end
--    
--    local DeathReason = Content.DeathReason or EDeathReason.Normal
--    if DeathReason == EDeathReason.SummonTimeLife then
--        self:TriggerBattleEvent(BattleEventName.OnLifeTimeOver, Entity)
--    end
--
--    Entity:SetDead(true)
--    Entity:OnDead(Content.KillMineRoleEid, Content.KillMineSkillId, DeathReason)
--
--    if not bIsDanmakuTarget and (Entity:IsPlayer() or Entity:IsPhantom()) and DeathReason ~= EDeathReason.GMChangeRole then
--        EventManager:FireEvent(EventID.CharDie, TargetEid)
--        Entity:ResetCapSize()
--    end
--end

-- -- 直接让玩家站起来，不消耗复活次数
-- function Component:QuickRecovery(TargetEid)
--     local Target = self:GetEntity(TargetEid)
--     if not Target then return end 
--     if not Target:IsDead() then return end
    
--     self:QuickRecovery_Impl(Target)
--     self.Result:Add("QuickRecovery", {
--         Eid = Target.Eid,
--     })
-- end

-- function Component:Play_QuickRecovery(Content)
--     local Eid = Content.Eid
--     local Target = self:GetEntity(Eid)
--     if not Target then return end
--     self:QuickRecovery_Impl(Target)
-- end

function Component:QuickRecovery_Impl(Target)
    Target:QuickRecovery()
    -- Target.Super.Recovery(Target)
    -- Target:TryLeaveDying()
    -- Target.PlayerAnimInstance:Montage_Stop(0)
    -- Target:SetCharacterTag("Recovery")
    -- Target:SetCharacterTag("Idle")
    
    -- if Target:IsPlayer() then 
    --     Target:ResetForbidTag("Battle")
    --     Target:OnRecoverDissolve()
    -- end
end

---@param TargetEid number 复活对象
function Component:Recovery(TargetEid)
    local Target = self:GetEntity(TargetEid)
    local Avatar = GWorld:GetAvatar()
    if not Target then return end
    if Avatar and Target and Target:IsMainPlayer() then
        local IsInHomebase = Avatar:GetIsInHome()
        if Target:GetCurRespawnRuleName() == "CommonRegion" and not IsInHomebase then 
            self:RegionTeleportRecovery(Target)
            return
        end
    end
    
    Target:Recovery()
end

---@param TargetEid number 复活对象
---@param Location FTransform 复活位置
---@param DelayTime number 复活延迟
function Component:TeleportRecovery(TargetEid, Location, Rotation, DelayTime)
    local Target = self:GetEntity(TargetEid)
    if not Target or not Target:CheckCanRecovery() then 
        return 
    end

    self:AddTimer(DelayTime, function()
        Target:K2_SetActorLocationAndRotation(Location, Rotation, false, nil, false)
        Target:Recovery()
        self.Result:Add("EntityRecovery", {
            EntityEid = Target.Eid,
        })
    end)
end

function Component:RegionTeleportRecovery(Player)
    Player.IsTeleportRecovery = true
    local UIManager = UIManager(GWorld.GameInstance)
    local Params = {}
    Params.BlackScreenHandle = "Teleport"
    Params.InAnimationObj = self
    Params.InAnimationCallback =  function() 
        Player:QuickRecovery()
        Player:TeleportToCloestTeleportPoint(function() 
            -- self.BlackUI:FadeOut(1) 
            UIManager:HideCommonBlackScreen("Teleport")
            Player.IsTeleportRecovery = false
        end)
    end
    Params.InAnimationPlayTime = 1
    Params.OutAnimationObj = self
    Params.OutAnimationPlayTime = 1
    UIManager:ShowCommonBlackScreen(Params)
    -- Params.OutAnimationCallback = self.CloseBlackScreen
    -- self.BlackUI = UIManager(GWorld.GameInstance):_CreateWidgetNew("TalkBlackScreenBorder")
    -- self.BlackUI:FadeIn(1, {Func = function() 
    --     Player:QuickRecovery()
    --     Player:TeleportToCloestTeleportPoint(function() 
    --         self.BlackUI:FadeOut(1) 
    --         Player.IsTeleportRecovery = false
    --     end)
    -- end, Obj = Player, Params = {}})
end

function Component:Play_EntityRecovery(Content)
    DebugPrint("Tianyi@ Client Play_EntityRecovery")
    local EntityEid = Content.EntityEid
    local Entity = self:GetEntity(EntityEid)
    if not Entity then return end
    self:Recovery(Content.EntityEid)
end

function Component:RecoverOther(RecovererEid, TargetEid, IsBegin, Params, Reason)
    local Recoverer = self:GetEntity(RecovererEid)
    local Target = self:GetEntity(TargetEid)
    local OverrideSpeed = Params.Speed
    local RecoveryEffectCreatureId = Params.RecoveryEffectCreature

    local RecoverSpeed = Target and Target:GetPlayerRecoverySpeed() or nil
    if OverrideSpeed then RecoverSpeed = OverrideSpeed end
    
    if Recoverer and Target and RecoverSpeed then 
        Recoverer = Recoverer:GetRootSource() -- 施加复活效果的对象可能是召唤物，所以要拿到本体
        if not Recoverer then
            return
        end
        -- 判断被复活者能否复活
        if not Target:CheckCanRecovery() then 
            DebugPrint("Tianyi@ " .. Target:GetName() .. " Can not be recovered")
            return 
        end
       
        if IsBegin then
            -- 判断复活者能否执行复活
            if not Recoverer:CheckCanRecoverOther(Target, Reason) then 
                DebugPrint("Tianyi@ Recoverer " .. Recoverer:GetName() .. " can not recover target: " .. Target:GetName())
                return 
            end
            
            -- Target:AddTeamRecovery(Recoverer, RecoverSpeed, Reason)
            Target:AddTeamRecovery(Recoverer.Eid, RecoverSpeed, Reason)
            if RecoveryEffectCreatureId then 
                Target:BindTeamReocveryEffect(RecovererEid, RecoveryEffectCreatureId)
            end
        else
            Target:RemoveTeamRecovery(Recoverer.Eid)
            -- Target:RemoveTeamRecovery(Recoverer)
        end

        self.Result:Add("RecoverOther", {
            RecovererEid = RecovererEid, 
            TargetEid = TargetEid, 
            IsBegin = IsBegin,
            Params = Params,
            Reason = Reason})
    end
end

function Component:Play_RecoverOther(Content)
    DebugPrint("Tianyi@ Client Play_RecoverOther")
    local TargetEid = Content.TargetEid 
    local IsBegin = Content.IsBegin 


    local Target = self:GetEntity(TargetEid)
    if not IsValid(Target) then
        return
    end
    if IsBegin then
        if Target.IsHostage and Target.TriggerRescueTimerFloatVisibility then
            Target:TriggerRescueTimerFloatVisibility(true)
        end
    else
        if Target.IsHostage and Target.TriggerRescueTimerFloatVisibility then
            Target:TriggerRescueTimerFloatVisibility(false)
        end
    end
end

function Component:CaptureMonsterStandUp(TargetEid)
    local Target = self:GetEntity(TargetEid)
    if not Target then
        return
    end
    if not Target:CheckCanRecovery() then
        return
    end
    Target:CaptureMonsterRecover()
    self.Result:Add("CaptureMonsterStandUp", {
        EntityEid = Target.Eid,
    })
end

function Component:Play_CaptureMonsterStandUp(Content)
    local EntityEid = Content.EntityEid
    local Entity = self:GetEntity(EntityEid)
    if not Entity then return end
    self:CaptureMonsterStandUp(Content.EntityEid)
end


return Component