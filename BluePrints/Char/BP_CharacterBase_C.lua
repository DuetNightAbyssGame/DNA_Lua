--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local EffectResults = require "BluePrints.Combat.BattleLogic.EffectResults"
local EMCache = require "EMCache.EMCache"
local TimeUtils = require "Utils.TimeUtils"
local StoryPlayableUtils = require "BluePrints.Story.StoryPlayableUtils"
local GMVariable = require "BluePrints.UI.GMInterface.GMVariable"
local MiscUtils = require "Utils.MiscUtils"

---@class BP_CharacterBase_C
local BP_CharacterBase_C = Class({
    "BluePrints.Combat.Components.CharacterComponent",
})

BP_CharacterBase_C._components = {
    "BluePrints.Combat.Components.AccessoryComponent",
    "BluePrints.Combat.Components.ActorTypeComponent",
    "BluePrints.Combat.Components.CharacterBattleEventComponent",
    "BluePrints.Combat.Components.EffectCreatureComponent",
    "BluePrints.Combat.Components.PassiveEffectComponent",
    -- "BluePrints.Combat.Components.SkillComponent",
    "BluePrints.Combat.Components.WeaponComponent",
    "BluePrints.Combat.Components.DestructableComponent",
    
    "BluePrints.Char.CharacterComponent.CharacterTagLogic.CharacterTagComponent",
    -- "BluePrints.Char.CharacterComponent.GatherLogicComponent",
    -- "BluePrints.Char.CharacterComponent.GrabLogicComponent",
    "BluePrints.Char.CharacterComponent.ChangeRoleComponent",
    "BluePrints.Char.CharacterComponent.HitLogicComponent",
    "BluePrints.Char.CharacterComponent.TagComponent",
    "BluePrints.Char.CharacterComponent.ActionLogicComponent",
    "BluePrints.Char.CharacterComponent.PhantomComponent",
    
    "BluePrints.Common.DelayFrameComponent",
    "BluePrints.Char.CharacterComponent.CheckOverlapAndPushComponent",
}

function BP_CharacterBase_C:Initialize(Initializer)
    self.StartBulletJumpTime = -1
    self.PrepareIntoBulletJump = -1
    self.LuaTimerHandles = {}
    self.LastZSpeed = 0
    self.WallJumpCount = 0
    self.OriginCapsuleRadius = self.CapsuleComponent:GetUnscaledCapsuleRadius()
    self.OriginHalfHeight = self.CapsuleComponent:GetUnscaledCapsuleHalfHeight()
    self.LastBipHeight = self.Mesh:GetSocketTransform('Bip001', 3)
    self.PlayAddtiveHitTime = 0
    -- self.KawaiiIdMap = {}
    self.HitMontageRule = nil
    rawset(self, "AutoSyncProp", self.AutoSyncProp)
    --self.CapsuleComponent.OnComponentBeginOverlap.Add(self, BP_CharacterBase_C.Test)
    --self.CapsuleComponent.OnComponentHit.Add(self, BP_CharacterBase_C.Test)
end

-- function BP_CharacterBase_C:GetObjType()
--     return EObjType.CharacterBase
-- end

function BP_CharacterBase_C:GetShootingTargets()
    return self.ShootingTargets
end

function BP_CharacterBase_C:ClearShootingTargets()
    self.ShootingTargets:Clear()
end

--function BP_CharacterBase_C:Test(OverlappedComponent, OtherActor,  OtherComp,  OtherBodyIndex,  bFromSweep, SweepResult)
--    print('11111111111111111111111111111')
--end
--function BP_CharacterBase_C:UserConstructionScript()
--end

function BP_CharacterBase_C:ReceiveBeginPlay()
    -- 移到了CharacterInitLogic的OnCharacterReady里面
    -- self.Overridden.ReceiveBeginPlay(self)
	-- self.RelativeMeshTransform = self.Mesh:GetRelativeTransform()
    -- @SnowMoon 监听battle并尝试初始化，如果已经有battle则会成功初始化，否则会等待battle触发场景Actor集体初始化
    EventManager:AddEvent(EventID.OnBattleReady, self, self.OnBattleReady_TryInitCharacterInfo)

    -- self:InitFSM()
    -- --TODO: 这些后面放独立模块 @Tianyi  
    -- self.RecoveryCount = 0
    -- self.RecoveryMaxCount = 0
    -- self.PhantomRecoveryCount = 0 
    -- self.PhantomRecoveryMaxCount = 0
	-- self.RagdollStateType = ERagdollStateType.None

    -- lua 定义，C++定义的初始化放C++
    -- self.WallJumpCount = 0   这几个变量已经没在用了
    -- self.LastZSpeed = nil
    -- self.StartWallJumpTime = 0

    -- self.OriginCapsuleRadius = self.CapsuleComponent:GetUnscaledCapsuleRadius()
    -- self.OriginHalfHeight = self.CapsuleComponent:GetUnscaledCapsuleHalfHeight()

    -- 受击相关
    -- self.CacheInfos = {}
    -- self.HitMontageSuffix = {}
    -- self.HitMonatgeIndex = {}
    -- self.ReplaceHitTypeTable = {}
    -- self.HitTimeMap = {}


    self.LuaTimerHandles = {}
    -- self.OverlapPushCallback = self.OverlapPushCallback or {}

    -- if UGameplayStatics.GetGameInstance(self).ImmersionModel then
    --     self.CapsuleComponent:SetHiddenInGame(true,false)
    -- end

    -- self:SetCharacterTagIdle()

    -- self.CharacterFashion:ReceiveBeginPlay()
    -- self.DodgeInvincebal = true
    --self.IsDestroied = false
end


function BP_CharacterBase_C:OnBattleReady_TryInitCharacterInfo(_Battle)
    if Battle(self) == _Battle then
        self:TryInitCharacterInfo("Battle")
    end
end

-- function BP_CharacterBase_C:InitAttributeFromTable(InitFromAnimInst)
-- end

--function BP_CharacterBase_C:ReceiveEndPlay()
--    EventManager:RemoveEvent(EventID.OnBattleReady, self)
--    if not Battle(self) then
--        return
--    end
--    self:ClearCharacterBattleInfo(false, EDeathReason.NoReason)
--    self:ClearWeapon()
--    self.IsDestroied = true
--end

-- function BP_CharacterBase_C:ReceiveTick(DeltaSeconds)
--     if self:CharacterInTag("Avoid") then 
--         self.DodgeInvincebal = false
--     else
--         self.DodgeInvincebal = true
--     end
-- end


    -- if not self.InitSuccess then  -- C++的Tick已经做了InitSuccess检查
    --     return
    -- end
    -- self.Overridden.ReceiveTick(self, DeltaSeconds)
	-- if self:IsPlayer() or self:IsPhantom() then 
    --     self:ChangeGravityScale()
    -- end
    -- CallOverridden(self, DeltaSeconds)
    
    -- self:Tick_Cpp(DeltaSeconds);
    -- print(_G.LogTag, '22222222222',self:GetFloorInfo().bBlockingHit)
    -- self:CalcAimRotationInTick(DeltaSeconds, Const.AimRotLerpSpeed)
    -- local Movement = self:GetMovementComponent()
    -- self.IsInAir = self:IsCharacterInAir()
    -- if self:IsDying() then
    --     -- 死了
    --     return
    -- end
    -- print('213444444444444444444444444444444444444444444444444', string.find("Idle.OverHeat.OverHeat.OverHeat", 'OverHeat'))
    -- self:CheckAnimGravityScale()
    -- if (self:CharacterInTag("Idle") or self:CharacterInTag("Crouch")) and self.IsInAir then
    --     self:SetCharacterTag("Falling")
    -- end
    -- if self:CharacterInTag("Falling") and (not self.IsInAir) then
    --     self:SetCharacterTagIdle()
    -- end
    -- local Walkable = Movement.CurrentFloor.bBlockingHit and Movement.CurrentFloor.bWalkableFloor 
    -- print('11111111111111111111111111111', self.PlayerAnimInstance.CurrentJumpState, Movement.GravityScale)
    -- print('11111111111111111',self.JumpCount, self.CharacterTag,self.PlayerAnimInstance.CurrentJumpState,self.ImpendingSetted)

    -- if self.PlayerAnimInstance then
    --     self.PlayerAnimInstance.bIsCharacterInBaseMovement = self:IsCharacterInBaseMovement()
    --     if not self.IsInAir and self:JumpLandedCondCheck() and not self:CharacterInTag("Skill") then
    --         self:Landed()
    --     elseif self:CanPlayImpending() then
    --         self:Impending()
    --     end
    -- end
    -- self:CheckSkillFalling()
    -- if self.DuringRagdollHitFly ~= nil then
    --     local Now  = UE4.UGameplayStatics.GetTimeSeconds(self)

    --     if self.RagdollHitFlyCurve then
    --         local InTime = Now - self.DuringRagdollHitFly
    --         local MinTime, MaxTime = self.RagdollHitFlyCurve:GetTimeRange()
    --         if InTime < MaxTime then
    --             local Weight = math.min(math.max(self.RagdollHitFlyCurve:GetFloatValue(InTime), 0), 1)
    --             self.Mesh:SetAllBodiesBelowPhysicsBlendWeight(self.RagdollHitFlyBoneName, Weight)
    --         else
    --             self.PlayerAnimInstance.RagdollHitFly = true
    --         end
    --     end
    -- end
    -- self:TickLiftHeight(DeltaSeconds)
    -- self:LaunchCharacter(FVector(0,0,-1), true, true)
-- end

function BP_CharacterBase_C:GetConstAimRotLerpSpeed_Lua()
    return Const.AimRotLerpSpeed
end

-- function BP_CharacterBase_C:JumpLandedCondCheck()
--     local JumpState = self.PlayerAnimInstance.CurrentJumpState
--     return JumpState ~= Const.NormalState and JumpState ~= Const.Climb 
-- end

-- function BP_CharacterBase_C:CanPlayImpending()
--     if self:CharacterInTag("Slide") then 
--         return false
--     end

--     local CurrentJumpState = self.PlayerAnimInstance.CurrentJumpState
--     return not self.ImpendingSetted and ((CurrentJumpState == Const.NormalState and self:CharacterInTag("Falling"))
--                                         or (CurrentJumpState == Const.JumpFall and not self:CharacterInTag("Skill")))
-- end
-- function BP_CharacterBase_C:CheckSkillFalling()
--     local PlayerAnimInstance = self.PlayerAnimInstance
--     if not PlayerAnimInstance then 
--         return
--     end

--     local CurrentJumpState = PlayerAnimInstance.CurrentJumpState
--     local IsInSkillTag = self:CharacterInTag("Skill")
--     if IsInSkillTag and CurrentJumpState ~= Const.JumpFall and self.IsInAir then
--         self:SetCurrentJumpState(Const.JumpFall)
--         self.JumpCount = UE4.UKismetMathLibrary.Clamp(self.JumpCount, 1, self.JumpCount)
--     elseif IsInSkillTag and CurrentJumpState ~= Const.NormalState and not self.IsInAir then
--         self:SetCurrentJumpState(Const.NormalState)
--         self.JumpCount = 0
--         self.BulletJumpCount = 0
--     end
-- end

-- function BP_CharacterBase_C:CheckAnimGravityScale()
--     self:_CheckAnimGravityScale()
--     local Movement = self:GetMovementComponent()
--     Movement.GravityScale = Movement.GravityScale * (self.BuffGravityScale or 1)
-- end

-- function BP_CharacterBase_C:_CheckAnimGravityScale()
--     local Movement = self:GetMovementComponent()
--     if self.EnableAnimGravity <= 0 then
--         if self:IsMonster() and Movement and self.UsingAnimGravity then
--             Movement.GravityScale = self.OriginGravity
--             self.UsingAnimGravity = false  
--         end
--         return
--     end
--     if self.EnableAnimGravityOnlyInAir and not (self.IsInAir and self:GetVelocity().Z < 0) then
--         return
--     elseif self.EnableAnimGravityOnlyInAir and self.ResetZVelocityWhenShoot and not self.ResetedWhenShoot then
--         -- print('22222222222222222222222222222222222')
--         self:LaunchCharacter(FVector(0,0,0), false, true)
--         self.ResetedWhenShoot = true
--     end

--     Movement.GravityScale = self.AnimGravity

-- end

--function BP_CharacterBase_C:ChangeGravityUseAnim(EnableAnimGravity, GravityScale, bEnableOnlyInAir, bResetZVelocity, bResetXYVelocity)
--    if EnableAnimGravity then 
--        self.EnableAnimGravity = self.EnableAnimGravity + 1
--    else
--        self.EnableAnimGravity = self.EnableAnimGravity - 1
--    end
--
--    if self.EnableAnimGravity < 0 then 
--        self.EnableAnimGravity = 0
--    end
--
--    if self.EnableAnimGravity > 0 then 
--        self.AnimGravity = GravityScale
--        self.EnableAnimGravityOnlyInAir = bEnableOnlyInAir
--        self.ResetZVelocityWhenShoot = bResetZVelocity
--        self.ResetXYVelocityWhenShoot = bResetXYVelocity
--        self.UsingAnimGravity = true
--    else
--        self.AnimGravity = 0
--        self.EnableAnimGravityOnlyInAir = false
--    end
--end

-- function BP_CharacterBase_C:CheckTagForbidInput()
--     -- if self:IsPlayer() then
--     --     if DataMgr.PlayerStateLimit[self.AutoSyncProp.CharacterTag] ~= nil and DataMgr.PlayerStateLimit[self.AutoSyncProp.CharacterTag]["ForbidInput"] then
--     --         return true
--     --     end
--     -- end
--     -- return false
-- 	local CharacterTag = self:GetCharacterTag()
-- 	return DataMgr.PlayerStateLimit[CharacterTag] and DataMgr.PlayerStateLimit[CharacterTag]["ForbidInput"]
-- end

-- function BP_CharacterBase_C:CheckForbidInput()
--     if not self.InitSuccess then
--         return true
--     end
--     if self:CheckStiffForbidInput() then
--         return true
--     end
--     if self:CheckTagForbidInput() then
--         return true
--     end
--     if self:IsPlayer() then
--         return false
--     end
-- end

-- function BP_CharacterBase_C:CheckStiffForbidInput()
--     if self.bStiffForbidInput then
--         return true
--     else
--         return false
--     end
-- end

--function BP_CharacterBase_C:ReceiveActorBeginOverlap(OtherActor)
--end

--function BP_CharacterBase_C:ReceiveActorEndOverlap(OtherActor)
--end


-- 已经挪到C++: ServerTargetFilters_Implementation
--function BP_CharacterBase_C:ServerTaskTargets_Implementation(EffectStruct)
--    local TargetFilterResult = EffectResults.UnpackEffectStruct(EffectStruct)
--    -- if not TargetFilterResult then
--    --     return
--    -- end
--    -- PrintTable({ServerTaskTargets=TargetFilterResult}, 10)
--    local SkillId = TargetFilterResult.SkillId
--
--    local Skill = self:GetSkill(SkillId)
--    if Skill then
--        Skill:SetRunServerSkillEffect(TargetFilterResult)
--    end
--end

--function BP_CharacterBase_C:GetSkillIdBySkillType(SkillId, ReSetPressSkillId)
--    local Skill = self:GetSkill(SkillId)
--    if not Skill then
--        return SkillId
--    end
--    if ReSetPressSkillId == Const.UseOriginSkillId then
--        return SkillId
--    end
--    local _Type = Skill.SkillType
--    if _Type then
--        SkillId = self:GetSkillByType(_Type)
--    end
--    Skill = self:GetSkill(SkillId)
--    if ReSetPressSkillId ~= Const.DefaultResetPressSkillId
--            and Skill.LongPressSkill ~= Const.DefaultResetPressSkillId
--            and Skill.LongPressSkill == ReSetPressSkillId then
--        SkillId = ReSetPressSkillId
--    end
--    return SkillId
--end

-- 直接执行被动效果
--function BP_CharacterBase_C:UseNotExecuteSkill(Skill)
--    -- 只在服务器执行就可以了，不需要广播
--    local ExecutePassiveFunc = Skill.ExecutePassiveFunc
--    if not ExecutePassiveFunc then
--        return
--    end
--    if not self.PassiveEffects or self.PassiveEffects:Num() <= 0 then
--        return
--    end
--
--    self:ClearInputCache()
--    local Found = nil
--    local Func
--    for _, PassiveEffect in pairs(self.PassiveEffects) do
--        if PassiveEffect.PassiveEffectId == ExecutePassiveFunc.Id then
--            Func = PassiveEffect[ExecutePassiveFunc.FuncName]
--            if Func then
--                Func(PassiveEffect)
--                Found = true
--                return
--            else
--                Battle(self):ShowBattleError("UseNotExecuteSkill:被动" .. tostring(PassiveEffect.PassiveEffectId) .. "没有函数：" .. tostring(ExecutePassiveFunc.FuncName))
--            end
--        end
--    end
--    if not Found then
--        Battle(self):ShowBattleError("UseNotExecuteSkill:当前角色没有【" .. ExecutePassiveFunc.Id .. "】号被动效果,函数：" .. tostring(ExecutePassiveFunc.FuncName))
--    end
--end

-- 技能使用条件
--function BP_CharacterBase_C:CheckContSkillCondition(Skill)
--    -- 技能使用条件，只在服务器执行
--    local ContSkillCondition = Skill.ContSkillCondition
--    if not ContSkillCondition then
--        return
--    end
--    if not self.PassiveEffects or self.PassiveEffects:Num() <= 0 then
--        return
--    end
--
--    for _, PassiveEffect in pairs(self.PassiveEffects) do
--        if PassiveEffect.PassiveEffectId == ContSkillCondition.Id then
--            local Func = PassiveEffect[ContSkillCondition.FuncName]
--            if Func then
--                return Func(PassiveEffect)
--            else
--                Battle(self):ShowBattleError("CheckContSkillCondition:被动" .. tostring(PassiveEffect.PassiveEffectId) .. "没有函数：" .. tostring(ContSkillCondition.FuncName))
--            end
--        end
--    end
--    if not Found then
--        Battle(self):ShowBattleError("CheckContSkillCondition:当前角色没有【" .. ContSkillCondition.Id .. "】号被动效果,函数：" .. tostring(ContSkillCondition.FuncName))
--    end
--end

-- 执行被动函数
--function BP_CharacterBase_C:ExecutePassiveFunction(PassiveEffectId, FunctionName)
--    local PassiveEffect = self:GetPassiveEffectById(PassiveEffectId)
--    if not PassiveEffect then
--        Battle(self):ShowBattleError("技能效果ExecutePassiveFunction:当前角色【" .. tostring(self.CurrentRoleId) .. "】没有【" .. tostring(PassiveEffectId) .. "】号被动效果,函数：" .. tostring(FunctionName))
--        return
--    end
--
--    if not FunctionName then
--        Battle(self):ShowBattleError("技能效果ExecutePassiveFunction:没有填写FunctionName")
--        return
--    end
--
--    local Func = PassiveEffect[FunctionName]
--    if not Func then
--        Battle(self):ShowBattleError("技能效果ExecutePassiveFunction:被动【" .. tostring(PassiveEffectId) .. "】没有函数:" .. tostring(FunctionName))
--        return
--    end
--    Func(PassiveEffect)
--end

-- 专门给直接执行被动效果用来设置CD的
function BP_CharacterBase_C:SetSkillCD(Skill, RetCode)
    if self:HandleCheckSkillNodeCondition(RetCode, Skill.SkillId, 0) then
        if not Skill.StopSkillCalcCD then
            self:SetSkillTimestamp(Skill.SkillId, true)
        end
    end
end


-- TODO@gmy: 这部分已经挪到C++，稳定后删除
--function BP_CharacterBase_C:ServerUseSkillLua(SkillId, ReSetPressSkillId, PreTarget)
--    -- 单机或者服务器通用
--
--    local Skill = self:GetSkill(SkillId)
--    if not Skill then
--        return
--    end
--    if Skill.NotExecute then
--        self:UseNotExecuteSkill(Skill)
--        return true
--    end
--
--    -- 服务器再做一遍过滤
--    if not self:CanUseSkill(SkillId) then
--        return 
--    end
--
--    -- 服务器的话，直接Server Stop Skill，单机同理
--    if not self:IsSkillFinished() then
--        local Reason = UE.ESkillStopReason.SkillCancel
--        if self:IsShootingCancelByReload(SkillId) then
--            Reason = UE.ESkillStopReason.ReloadCancel
--        end
--        if self:CheckCanSkillCancel(SkillId) then
--            self:ServerStopSkill(Reason)
--        end
--    end
--    -- 重设技能编号
--    local _SkillId = self:GetSkillIdBySkillType(SkillId, ReSetPressSkillId)
--    if _SkillId ~= SkillId then
--        SkillId = _SkillId
--        -- 服务器再做一遍过滤
--        if not self:CanUseSkill(SkillId) then
--            return
--        end
--    end
--    -- 技能没结束，返回
--    if not self:IsSkillFinished() then
--        return 
--    end
--    -- -- 如果没法（比如子弹不足，能量不足）进入第一个节点，返回
--    -- if not self.SkillTimeLine:CheckFirstNodeCondition(SkillId) then
--    --     return
--    -- end
--
--    -- 1.单机，等同于自己执行
--    -- 2.服务器，服务器先执行再广播
--    local Skill = self:GetSkill(SkillId)
--    self:RealUseSkill(Skill, PreTarget)
--    if not IsStandAlone(self) then
--        self:MulticastUseSkill(SkillId, Skill.NodeStep)
--    end
--    return true
--end

--function BP_CharacterBase_C:IsShootingCancelByReload(SkillId)
--    return self.CurrentSkillId == self:GetSkillByType(UE.ESkillType.Shooting) and (SkillId == self:GetSkillByType(UE.ESkillType.Reload) or SkillId == self:GetSkillByType(UE.ESkillType.ShootingOverheat))
--end

-- TODO@gmy: 这部分已经挪到C++，稳定后删除
--function BP_CharacterBase_C:MulticastUseSkill_Implementation(SkillId, NodeStep)
--    if IsAuthority(self) then
--        return
--    end
--    local Skill = self:GetSkill(SkillId)
--    if not Skill then
--        return
--    end
--    Skill.NodeStep = NodeStep
--    self:RealUseSkill(Skill)
--end

-- TODO@gmy: 这部分已经挪到C++，稳定后删除
--function BP_CharacterBase_C:UseSkill(SkillId, ReSetPressSkillId)
--    local Skill = self:GetSkill(SkillId)
--    if not Skill then
--        return false
--    end
--    if Skill.SkillType == "Passive" then
--        return false
--    end
--    -- 单机
--    if IsStandAlone(self) then
--        -- 不是rpc
--        return self:ServerUseSkillLua(SkillId, ReSetPressSkillId)
--    end
--
--    -- 如果是客户端输入端
--    if IsClient(self) then
--        -- 先做一遍过滤
--        local Skill = self:GetSkill(SkillId)
--        -- 此类技能不需要停止原来的技能，也不需要检查条件
--
--        if Skill.NotExecute then
--            -- 客户端清cache
--            self:ClearInputCache()
--            -- 通知服务器执行，rpc
--            self:ServerUseSkill(SkillId, ReSetPressSkillId)
--        else
--            if not self:CanUseSkill(SkillId) then
--                return false
--            end
--            -- 客户端的话，先同步Stop Skill
--            if not self:IsSkillFinished() then
--                local Reason = UE.ESkillStopReason.SkillCancel
--                if self:IsShootingCancelByReload(SkillId) then
--                    Reason = UE.ESkillStopReason.ReloadCancel
--                end
--                if self:CheckCanSkillCancel(SkillId) then
--                    self:StopSkill(Reason)
--                end
--            end
--            -- 如果技能没结束，也过滤掉
--            if not self:IsSkillFinished() then
--                return false
--            end
--            -- -- 如果没法（比如子弹不足，能量不足）进入第一个节点，客户端返回
--            -- if not self.SkillTimeLine:CheckFirstNodeCondition(SkillId) then
--            --     return false
--            -- end
--            -- 通知服务器执行，rpc
--            self:ServerUseSkill(SkillId, ReSetPressSkillId)
--        end
--    else
--        -- 怪物使用技能
--        -- 服务器的话，执行，不是rpc
--        return self:ServerUseSkillLua(SkillId, ReSetPressSkillId)
--    end
--
--    return true
--end

-- function BP_CharacterBase_C:UseSkillByType(SkillTypeName, OwnerWeapon)
--     if OwnerWeapon == nil then
--         return false
--     end

--     for _, Skill in pairs(self.Skills) do
--         if Skill.Weapon == OwnerWeapon and Skill:GetSkillTypeLua() == SkillTypeName then
--             self:UseSkill(Skill.SkillId)
--             return true
--         end
--     end
--     return false
-- end

-- TODO@gmy: 这部分已经挪到C++，稳定后删除
--function BP_CharacterBase_C:RealUseSkill(Skill, PreTarget)
--	DebugPrint("gmy@BP_CharacterBase_C:RealUseSkill 111")
--    -- 被通知的不需要检查是否可以使用
--    -- 部分逻辑移到了开头，CanUseSkill里面
--    Battle(self):TriggerBattleEvent(BattleEventName.BeforeSkill, self, Skill)
--    local InAvoid = self:CharacterInTag("Avoid")
--    if InAvoid then 
--        self:StopDodge(true, 0)
--    end
--    local SkillId = Skill.SkillId
--    self.CurrentSkillId = SkillId
--    if Skill.SkillType == 'Block' or Skill.SkillType == 'BlockRun'then
--        self.PlayerAnimInstance.IsBlocking = true
--    end
--
--    if self:IsPlayer() or self:IsPhantom() then
--        local WeaponTag = self:ChooseWeaponToUse(Skill)
--        self:ChangeUsingWeaponByType(WeaponTag)
--    end
--
--    if not Skill.StopSkillCalcCD then
--        self:SetSkillTimestamp(SkillId, true)
--    end
--
--    local EnterTag = "Skill"
--   
--    if self:CanInShootingTag(Skill) then 
--        EnterTag = "Shooting"
--    elseif self:CanInRecoveryTag(Skill) then
--        EnterTag = "Recovery"
--    else
--        EnterTag = "Skill"
--    end
--    self:DisableReloadWithoutShoot()
--    if self:IsPlayer() and (IsStandAlone(self) or MiscUtils.IsAutonomousProxy(self)) then 
--        self:ChangeReloadWithoutShoot()
--    end
--    local RotTag = EnterTag 
--    if self:CanInRloadRotTag(Skill) then 
--        RotTag = "Reload"
--    end
--    self:SetCharacterTag(EnterTag)
--    -- local ReloadInAir = RotTag == "Reload" and self.IsInAir
--    -- if not ReloadInAir then 
--    self:SetRotationRate(RotTag)
--    -- end
--    if self:IsPlayer() or self:IsPhantom() then 
--        self:ChangeOrientControll()
--    end
--    self.SkillTimeLine:UseSkill(Skill, PreTarget)
--
--    -- 抛出重新装填事件
--    if(Skill.SkillType == Const.ReloadSkill) then
--        EventManager:FireEvent(EventID.ReloadStart)
--    end
--
--    if Skill.IgnoreTimeDilation then
--        self:SetTimeDilation(1)
--        self:SetCanNotChangeTimeDilation(true)
--    end
--
--    self:UseSkillSetFullBody(Skill)
--    if EnterTag == "Shooting" then
--		local StartShoot = self:CheckWeaponCanRelease()
--        self.PlayerAnimInstance.StartShoot = StartShoot
--        self:ShouldEnableHandIk()
--        local _ = StartShoot and self.PlayerAnimInstance:RemoveHoldHandler()
--    end
--
--    -- 给QA用来查看一下当前使用的技能
--    if self.DebugPrintSkillId then 
--        DebugPrint("Tianyi@ " .. self:GetName() .." 使用了技能: " .. Skill.SkillId)
--    end
--end

-- function BP_CharacterBase_C:ShouldEnableHandIk()
--     if not self.PlayerAnimInstance then 
--         return
--     end

--     if self.LeftHandIkSocketName  == "" or self.LeftHandIkSocketName  == nil or self.LeftHandIkSocketName == "None" then 
--         self.PlayerAnimInstance.EnableHandIk = false
--         return 
--     end
--     self.PlayerAnimInstance.EnableHandIk = self.PlayerAnimInstance:ShouldEnableHandIk()
--     return 
-- end

-- function BP_CharacterBase_C:CheckWeaponCanRelease()
--     if not self.UsingWeapon then 
--         return false
--     end
--     if self:IsFlying() then 
--         return false
--     end
--     return true
-- end

-- function BP_CharacterBase_C:UseSkillSetFullBody(Skill)
    
--     local InShooting = self:CharacterInTag("Shooting")
--     local BlockingMoving = self.PlayerAnimInstance.IsBlocking and self:GetVelocity():Size() ~= 0
--     self.PlayerAnimInstance.FullBody = not InShooting and not BlockingMoving
--     if not Skill.AllowEightOrient then
--         return
--     end
--     self.LockOrient = true
--     if Skill.AllowEightOrient == "OnlyLockOrient" then
--         return
--     end
--     self.PlayerAnimInstance.FullBody = false
-- end

-- function BP_CharacterBase_C:CheckWeaponChangeToNotUltra(WeaponTag)
--     local WeaponChangeTo =  self[WeaponTag.."Weapon"]
--     if not WeaponChangeTo then
--         return true
--     end
--     local IsUltraWeapon = WeaponChangeTo.WeaponId == DataMgr.BattleChar[self.CurrentRoleId].UltraWeapon
--     return not IsUltraWeapon
-- end

--function BP_CharacterBase_C:CanInShootingTag(Skill)
--    local SkillType = Skill.SkillType
--    if not SkillType then 
--        return false
--    end
--    return (SkillType == "Shooting") or (SkillType == "HeavyShooting") or (SkillType == "Reload")
--end

--function BP_CharacterBase_C:CanInRloadRotTag(Skill)
--    local SkillType = Skill.SkillType
--    if not SkillType then 
--        return false
--    end
--    return (SkillType == "Reload")
--end

-- function BP_CharacterBase_C:ChooseWeaponToUse(Skill)
--     if not Skill then
--         return nil
--     end
--     if not self:IsPlayer() and not self:IsPhantom() then 
--         if self:CanInShootingTag(Skill) then 
--             return "Ranged"
--         else
--             return "Melee"
--         end
--     end
--     local SkillWeaponType = Skill.SkillWeaponType
--     if SkillWeaponType == "Melee" or SkillWeaponType == "Ranged" or SkillWeaponType == "Condemn" then 
--         return SkillWeaponType
--     end
--     if SkillWeaponType == "Ultra" then
--         -- self:EquipUltraWeapon()
--         return "Ultra"
--         -- local WeaponId = DataMgr.BattleChar[self.CurrentRoleId].UltraWeapon
--         -- local Weapon = self.Weapons[WeaponId]
--         -- if not Weapon then
--         --      return nil
--         -- end
--         -- if Weapon:HasTag("Melee") then
--         --     return "Melee"
--         -- elseif Weapon:HasTag("Ranged") then
--         --     return "Ranged"
--         -- end
--     end
--     return nil
-- end

-- function BP_CharacterBase_C:SetRotationRate(...)
-- end

function BP_CharacterBase_C:IsSkillFinished()
    return self.SkillTimeLine.SkillFinish
end


function BP_CharacterBase_C:GetDataInfo(RoleId)
    if not RoleId or RoleId == 0 then
        return
    end
    if self:IsPlayer() or self:IsPhantom() then
        return DataMgr.BattleChar[RoleId]
    elseif self:IsAIControlled() then
        return DataMgr.BattleMonster[RoleId]
    end
end

function BP_CharacterBase_C:GetSkillInitInfo(SkillInfos)
    local Res = TArray(FSkillInitInfo)
    if SkillInfos then
        for _, SkillData in ipairs(SkillInfos) do
            local SkillLevel = SkillData.SkillInfo.Level or Const.DefaultSkillLevel
            local SkillGrade = SkillData.SkillInfo.Grade or Const.DefaultSkillGrade
            local SkillInitInfo = FSkillInitInfo()
            SkillInitInfo.SkillId = SkillData.SkillId
            SkillInitInfo.SkillLevel = SkillLevel
            SkillInitInfo.SkillGrade = SkillGrade

            Res:Add(SkillInitInfo)
        end
    end
    return Res
end

-- function BP_CharacterBase_C:AddDefaultSkill()
--     if (self:IsPlayer() or self:IsPhantom()) then
--         self:AddSkill(Const.PlayerRecoverySkill, 1, 0, self.SeqSkills:Num() + 1)
--         self:AddSkill(Const.PlayerCondemnSkill, 1, 0, self.SeqSkills:Num() + 1)
--     end
-- end

-- function BP_CharacterBase_C:GetSeqSkill(Index)
--     if not self.SeqSkills then
--         return 0
--     end
--     local SkillId = self.SeqSkills:Find(Index)
--     if not SkillId then 
--         return 0
--     else
--         return SkillId
--     end
-- end

-- 获取模型的受击死亡相关参数  !!!!!NPC不需要,BP_NPC_C.lua处先临时重写
function BP_CharacterBase_C:GetHitMontageRule()
    if self.HitMontageRule then
        return self.HitMontageRule
    end

    -- 如果在Monster表中有覆盖规则
    if self:IsMonster() then 
        local MonsterData = DataMgr.Monster[self.UnitId]
        if MonsterData and MonsterData.HitMontageRule then 
            self.HitMontageRule = DataMgr.HitMontageData[MonsterData.HitMontageRule]
        end
    end
    
    if not self.HitMontageRule then 
        local ModelData = DataMgr.Model[self.ModelId]
        if ModelData and ModelData.HitMontageRule then 
            self.HitMontageRule = DataMgr.HitMontageData[ModelData.HitMontageRule]
        end
    end

    if not self.HitMontageRule then 
        self.HitMontageRule = DataMgr.Model[self.ModelId]
    end

    return self.HitMontageRule
end

function BP_CharacterBase_C:CheckCanPart()
    -- return self:IsPlayer()
    return self:IsPlayer()
end

function BP_CharacterBase_C:StopMontage()
    if not self.EMAnimInstance then
        return
    end
    self.EMAnimInstance:Montage_Stop(Const.MontageBlendOutTime)
end

function BP_CharacterBase_C:PlayMontageByPath(MontagePath, StopCallback, NoStopMontages, SectionName, bHideUntilLoop)
    local AnimationAsset = LoadObject(MontagePath)
    if not AnimationAsset then
        DebugPrint("Error: Load Montage Failed!!!", MontagePath)
        return nil
    end
    return self:PlayMontageByAsset(AnimationAsset, StopCallback, NoStopMontages, SectionName, bHideUntilLoop)
end

function BP_CharacterBase_C:PlayMontageByAsset(MontageAsset, StopCallback, NoStopMontages, SectionName, bHideUntilLoop)
    if not MontageAsset then return nil end
    if not NoStopMontages then
        self.EMAnimInstance:Montage_Stop(Const.MontageBlendOutTime)
    end
    if StopCallback then
        StopCallback(self)
    end
    self:SetCanExtractZVelocity()
    self:ResetAllCancelTag()

    -- 缓存一下当前播放的蒙太奇
    self.CurrentHitMontage = MontageAsset
    -- DebugPrint("Tianyi@ PlayMontage: " .. MontageAsset:GetName() .. " Section = " .. SectionName)
    local RetVal = self.EMAnimInstance:Montage_Play(MontageAsset, 1.0, UE4.EMontagePlayReturnType.Duration, 0.0, not NoStopMontages), MontageAsset
    if SectionName then 
        self.EMAnimInstance:Montage_JumpToSection(SectionName, MontageAsset)
    end
    
    if bHideUntilLoop then
        self:HideActorBeforeLoop(MontageAsset)
    end

    return RetVal, MontageAsset
end

--StopAllCancelTag
-- function BP_CharacterBase_C:ResetAllCancelTag()
--     self:SetWalkStopAnymation(false)
--     self:SetJumpImediately(false)
--     self:SetSlideImediately(false)
-- end

function BP_CharacterBase_C:GetHitMontageFolderAndPrefix()  --NPC不需要，暂时重写
    local ModelId = self.ModelId
    local ModelData = DataMgr.Model[ModelId]
    --EmptyNpc没有ModelId
    if ModelData ~=nil and ModelData.MontageFolder ~= nil then
        return self:FormatSubFileFolderWithMount(ModelData.MontageFolder), self:FormatPrefixWithMount(ModelData.MontagePrefix)
    else
        return nil, nil
    end
end

function BP_CharacterBase_C:PressSkill1(IsTickUse)
    print("use skill 1")
end

function BP_CharacterBase_C:PressSkill2()
    print("use skill 2")
end

function BP_CharacterBase_C:PressSkill3()
    print("use skill 3")
end

function BP_CharacterBase_C:PressOpenMenu()
    print("use OpenMenu")
end

function BP_CharacterBase_C:SupportSkill()
    print("use skill SupportSkill")
end

function BP_CharacterBase_C:StartHeavyAttack(IsTickUse)
    print("use heavy attack")
end

function BP_CharacterBase_C:CallLanded()
    self:Landed()
end

function BP_CharacterBase_C:Landed()
    if not self.EMAnimInstance then
        return
    end
    if self.EMAnimInstance.CurrentJumpState == Const.Climb then 
        return
    end
    if self:CharacterInTag("Avoid") then 
        return 
    end
    self:ResetJumpState_Cpp() -- 下边SetCharacterTagIdle的时候会去获取DefaultTag，此时如果JumpState不是NormalState，DefaultTag会取falling
    print(_G.LogTag, "CallLandedCallLandedCallLandedCallLanded")
    if not self:CharacterInTag("Slide") and not self.LuaTimerHandles["HitRepel"] then
        if self.EMAnimInstance.FallingSpeed  and self.EMAnimInstance.FallingSpeed < Const.LandHeavySpeed then
            if self:SetCharacterTag("LandHeavy") then
                local LandHeavyTime = DataMgr.PlayerRotationRates["LandHeavyTime"]["ParamentValue"][1]
                self:AddTimer_Combat(LandHeavyTime, self.SetCharacterTagIdle, false, 0, "LandHeavy")
                self.EMAnimInstance.FallingSpeed = 0
            end
        end
        if not self:CharacterInTag("Shooting") and not self:CharacterInTag("Idle") and not self:CharacterInTag("LandHeavy") then 
            self:SetCharacterTagIdle()
        end
    end
    self.JumpCount = 0
    self.BulletJumpCount = 0
    self.AutoSyncProp.IsBulletJumping = false
    self.ImpendingSetted = false
    -- self:SetCurrentJumpState(Const.NormalState)
    local Rotation = self:K2_EMGetActorRotation()
    -- self:K2_SetActorRotation(FRotator(0, Rotation.Yaw, Rotation.Roll), false)
    self:K2_EMSetActorRotation({ Yaw = Rotation.Yaw, Pitch = 0, Roll = Rotation.Roll })
    self.bBulletJumpRotation = false
    self.BulletJumpRotation = nil
    self.LastZSpeed = nil
    if self:IsPlayer() or self:IsPhantom() then 
        self:ChangeOrientControll()
    else
        -- self:GetMovementComponent().bOrientRotationToMovement = true
    end
    
    -- self.StartBulletJumpTime = -1
    -- self.CapsuleComponent:SetCapsuleSize(self.OriginCapsuleRadius, self.OriginHalfHeight, true)
end

function BP_CharacterBase_C:HasMoveInput()
    return self.IsMoveInput
end

-- function BP_CharacterBase_C:GetMeshResource()
--     local ResourceMap = TMap("","")
--     local CloakMeshPath = DataMgr.Model[self.ModelId].CloakMeshPath
--     if CloakMeshPath then 
--         ResourceMap:Add('CloakMesh', '/Game/'..CloakMeshPath)
--     end
--     local BodyMeshPath = DataMgr.Model[self.ModelId].SkeletonMeshPath
--     if BodyMeshPath then 
--         ResourceMap:Add('BodyMesh',  '/Game/'..BodyMeshPath)
--     end

--     local AccessoryMeshPath = DataMgr.Model[self.ModelId].AccessoryMeshPath
--     if AccessoryMeshPath then 
--         ResourceMap:Add('AccessoryMesh',  '/Game/'..AccessoryMeshPath)
--     end
--     -- return ResourceMap
-- end

-- 初始化自身的复活状态
function BP_CharacterBase_C:SetDeathInfo(DeathInfo)
    if DeathInfo and DeathInfo.IsRealDead then
        self:SetDead(true)
    else
        self:SetDead(false)
    end

    if DeathInfo and DeathInfo.RecoveryCount then
        self:SetRecoveryCount(DeathInfo.RecoveryCount)
    end
end

-- 自己能否被复活
function BP_CharacterBase_C:CheckCanRecovery()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not GameMode then
        return true 
    end

    return GameMode:CheckEntityCanRecover(self)
end

function BP_CharacterBase_C:ServerRecoverOther_Impl(TargetEid, IsBegin, Speed, Reason)
    Battle(self):RecoverOther(self.Eid, TargetEid, IsBegin, {Speed = Speed}, Reason)
end


-- 得到剩余复活次数
function BP_CharacterBase_C:GetRemainRecoveryTimes()
    local MaxRecoveryCount = self:GetRecoveryMaxCount()
    local RecoveryCount = self:GetRecoveryCount()
    if MaxRecoveryCount and RecoveryCount then 
        return MaxRecoveryCount - RecoveryCount 
    end

    return 0
end

-- 判断该角色是否拥有濒死倒计时
function BP_CharacterBase_C:CheckHaveDyingCountDown()
	if self:IsPlayer() then 
		if not IsStandAlone(self) then return true end
	elseif self:IsPhantom() then 
		if self.IsHostage == true then return true end
	end
	return false 
end

-----------------------------------


-- 服务器调用
function BP_CharacterBase_C:Recovery(NotRecoverAttr)
    if IsAuthority(self) then 
        if self:IsDead() then
            self:SetDead(false, 0, 0, 0)
            if not NotRecoverAttr then
                self:SetAttr("Hp", self:GetAttr("MaxHp"))
                self:CalcHpPercent()
                self:SetAttr("ES", self:GetAttr("MaxES"))
                self:SetAttr("Sp", self:GetAttr("InitSp"))
                self:RecoveryPassiveEffects()
            end
        end
    else 
        self:SetDead(false, 0, 0, 0)
    end

    self:CommonRecoveryImpl()
    EventManager:FireEvent(EventID.CharRecover, self.Eid)
    Battle(self):TriggerBattleEvent(BattleEventName.OnRecover, self)
    self.Overridden.Recovery(self)  
end

function BP_CharacterBase_C:QuickRecovery(NotRecoverAttr)
    if not self:IsDead() then return end 
    self.Super.Recovery(self, NotRecoverAttr)
    self.EMAnimInstance:Montage_Stop(0)
    self:SetCharacterTag("Recovery")
    self:SetCharacterTag("Idle")
end

-- 复活和快速复活都会调用的公共逻辑
function BP_CharacterBase_C:CommonRecoveryImpl()
    self.AlreadyDead = false
    DebugPrint("Tianyi@ Character Recovered: " .. self:GetName())
    if self:IsPlayer() or self:IsPhantom() then
        self:TryLeaveDying()
        local CharacterFashion = self.CharacterFashion
        if CharacterFashion then
            DebugPrint("Tianyi@ Init AppearanceSuitInfo when Recovery: " .. self:GetName())
            self:InitAppearanceSuit(CharacterFashion.AppearanceSuitInfo)
            local AdditionalFXID = DataMgr.Model[self.ModelId].AdditionalFXID
            if AdditionalFXID then
                CharacterFashion.NiagaraGroup:Clear()
                for _, v in pairs(AdditionalFXID) do
                    -- print("AdditionalFXID", v)
                    local FxObject = self.FXComponent:PlayEffectByID(v)
                    CharacterFashion.NiagaraGroup:Add(v, FxObject)
                end
                CharacterFashion:InitColorsWithInfo()
            end
        else
             DebugPrint("Tianyi@ CharacterFashion is nil when Recovery: " .. self:GetName())
        end

        if MiscUtils.IsAutonomousProxy(self) or IsStandAlone(self) then
            self.DodgeCount = 0
        end
    end
end


-- 设置受击持续时间
function BP_CharacterBase_C:SetHitDurationTime(HitType, HitMontageTime)
    if not HitMontageTime then 
        return 
    end
    if self.LuaTimerHandles[HitType] ~= nil then
        self:RemoveTimer(self.LuaTimerHandles[HitType])
        self.LuaTimerHandles[HitType] = nil
    end
    self.LuaTimerHandles[HitType] = self:AddTimer_Combat(HitMontageTime, self.SetCharacterTagIdle)
end


function BP_CharacterBase_C:PlayHitMontage(HitType, StopCallback, NoStopMontages, SectionName)
    local MontageFolder, MontagePrefix = self:GetHitMontageFolderAndPrefix()
    if MontageFolder ~= nil then
        local HitMontage = MontageFolder.."Combat/Hit/"..MontagePrefix..HitType..Const.MontageSuffix.."."..MontagePrefix..HitType..Const.MontageSuffix
        return self:PlayMontageByPath(HitMontage, StopCallback, NoStopMontages, SectionName)
    end
end

function BP_CharacterBase_C:CheckHitMontage(HitType)
    local MontageFolder, MontagePrefix = self:GetHitMontageFolderAndPrefix()
    if MontageFolder ~= nil then
        local HitMontagePackageName = MontageFolder.."Combat/Hit/"..MontagePrefix..HitType..Const.MontageSuffix
        return UResourceLibrary.CheckResourceExistOnDisk(HitMontagePackageName)
    end
    return false
end

function BP_CharacterBase_C:GetHitFlyCD()
    if self:IsPlayer() then
        return DataMgr.PlayerRotationRates["HitFlyCD"]["ParamentValue"][1]
    else
        return Const.DefaultCD
    end
end

function BP_CharacterBase_C:GetHitRepelCD()
    if self:IsPlayer() then
        return DataMgr.PlayerRotationRates["HitRepelCD"]["ParamentValue"][1]
    else
        return Const.DefaultCD
    end
end

function BP_CharacterBase_C:GetHeavyHitCD()
    if self:IsPlayer() then
        return DataMgr.PlayerRotationRates["HeavyHitCD"]["ParamentValue"][1]
    else
        return Const.DefaultCD
    end
end

function BP_CharacterBase_C:GetBoneHitCD()
    if self:IsPlayer() then
        return DataMgr.PlayerRotationRates["BoneHitCD"]["ParamentValue"][1]
    else
        return Const.DefaultCD
    end
end


function BP_CharacterBase_C:GetCauseHitData(CauseHitId, CauseHitType)
    local CauseHitParam = DataMgr.HitPerformanceData[CauseHitId]
    if not CauseHitParam then return nil end
    if CauseHitType == UE4.ECauseHitType.CauseHitTypeDie then 
        return CauseHitParam.CauseDieParam
    elseif CauseHitType == UE4.ECauseHitType.CauseHitTypeFirst then  
        return CauseHitParam.FirstHitParam
    elseif CauseHitType == UE4.ECauseHitType.CauseHitTypeNormal then 
        return CauseHitParam.CauseHitParam
    end

    return
end


function BP_CharacterBase_C:ApplyGrabHitGetup()
    if self:CharacterInTag("GrabHit") then 
        self:SetCharactertagIdle()
    end
end

function BP_CharacterBase_C:HitFlyDownRestore() 
    -- 角色通过蒙太奇结束通知来设置tag
    if not self:IsPlayer() and self:CharacterInTag("HitFly") then 
        self:SetCharacterTagIdle()
    end

    if self.LuaTimerHandles["HitFlyDown"] ~= nil then
        self:RemoveTimer(self.LuaTimerHandles["HitFlyDown"])
        self.LuaTimerHandles["HitFlyDown"] = nil
    end
    
end

function BP_CharacterBase_C:CheckBuffCanEnterIdleTag(Tag)
    if not self.EMAnimInstance or not self.EMAnimInstance.CheckCanEnterIdleTag then 
        return false
    end
    return self.EMAnimInstance:CheckCanEnterIdleTag(Tag)
end

function BP_CharacterBase_C:SetIdleTag(Tag)
    if not self.EMAnimInstance and not self.EMAnimInstance.SetIdleTag then 
        return 
    end
    self.EMAnimInstance:SetIdleTag(Tag)
end
-- GetIdleTag
function BP_CharacterBase_C:GetIdleTag()
    local AnimInst = self.EMAnimInstance
    if not AnimInst or not AnimInst.IdleTag then 
        return 
    end
    return AnimInst.IdleTag
end

function BP_CharacterBase_C:SetArmoryTag(ArmoryTag, bKeepWeapon, bHideUntilLoop)
    local NoWeaponIdleTag = Const.ArmoryIdleTags[ArmoryTag]
    self.LastArmoryTag = self.ArmoryTag
    self.ArmoryTag = ArmoryTag
    if self.UsingWeapon and ArmoryTag == "None" then 
        self.UsingWeapon:SetWeaponTypeChanged(false)
    end
    if  ArmoryTag and not NoWeaponIdleTag then
        local CurrentUsingWeapon = self.UsingWeapon
        local WeaponIdleTag = Const.ArmoryWeaponIdleTags[ArmoryTag]
        if WeaponIdleTag then
            self:ChangeUsingWeaponByType(Const.ArmoryWeaponIdleTag2WeaponType[WeaponIdleTag])
        else
            self:ChangeUsingWeaponByType(ArmoryTag)
        end
        print(_G.LogTag, "SetArmoryTag", ArmoryTag, self.UsingWeapon)
        if CurrentUsingWeapon ~= self.UsingWeapon then
            self.UsingWeapon:SetWeaponTypeChanged(true)
            self:BindWeaponToHand()
        end
    else
        if (not bKeepWeapon) then 
            self:ChangeUsingWeaponByType(nil)
        end
        self:UnBindWeaponFromHand()
    end
    self.IsEnterArmory = ArmoryTag
    if self.PlayerAnimInstance then 
        self.PlayerAnimInstance.IsEnterArmory = ArmoryTag
        self.PlayerAnimInstance:EnterArmoryIdle()
    end
    if self.IsEnterArmory ~= "None" then 
        self:SetArmoryIdleTag(bHideUntilLoop)
    else
        self:StopArmoryIdle()
    end
end
function BP_CharacterBase_C:PlayShowIdleMontage(IldeTag, bHideUntilLoop)
    local MontageFolder = DataMgr.Model[self.ModelId].MontageFolder
    local MontagePrefix = DataMgr.Model[self.ModelId].MontagePrefix
    MontagePrefix = self:FormatPrefixWithMount(MontagePrefix)
    local MontagePath = MontageFolder .. 'Armory/'..MontagePrefix.. IldeTag .. '_Show_Montage'
    print(_G.LogTag, "PlayShowIdleMontage", MontagePath)
    self:PlayMontageByPath(MontagePath, nil , nil, nil, bHideUntilLoop)
    -- if self.PlayerAnimInstance  then
    --     print(_G.LogTag, "OnMontageEned_Idle  Setted")
    --     self.PlayerAnimInstance.OnMontageBlendingOut:Add(self, self.OnMontageEned_Idle)
    -- end
end

function BP_CharacterBase_C:StopArmoryIdle()
    self:ShouldEnableHandIk()
    if self.EMAnimInstance then
        self.EMAnimInstance:Montage_StopSlotByName(0, "ArmoryIdle")
    end
    -- self:EmptyCurResourceId()
end

function BP_CharacterBase_C:GetUsingWeaponType(AmoryType)
    if not self[AmoryType .. "Weapon"] then
        return Const.ArmoryIdleTags.None
    end
    return self[AmoryType .. "Weapon"]:GetWeaponType()
end

-- function BP_CharacterBase_C:CheckSuperArmorEnterTag(Tag)
--     if not self:IsSuperArmor() then
--         return true
--     end
--     local ChangeInfo = self:GetStateLimitInfo(Tag)
--     if not ChangeInfo then
--         return true
--     end
--     local TagTypeMap = self:GetStateLimitTagTypeMap(ChangeInfo)
--     if TagTypeMap["Hit"] then
--         return false
--     else
--         return true
--     end
-- end

-- function BP_CharacterBase_C:LockCharacterTag(LockTag)
--     if self.LockTag then return end
--     self.LockTag = LockTag
-- end

-- function BP_CharacterBase_C:UnLockCharacterTag(LockTag)
--     if self.LockTag == LockTag then
--         self.LockTag = nil
--     end
-- end

-- function BP_CharacterBase_C:SetCharacterTag(Tag)
--     if self:CheckCanEnterTag(Tag) == false then
--         return false
--     end

--     if self.AutoSyncProp.CharacterTag == Tag then 
--         return true
--     end

--     if self:ShouldResetJump(Tag)then
--         self:ResetJumpState()
--     end

--     self:ApplyLeaveCharacterTag(self.AutoSyncProp.CharacterTag , Tag)
--     self.AutoSyncProp.CharacterTag = Tag
--     if self.PlayerAnimInstance ~= nil then
--         self.PlayerAnimInstance.CharacterTag = Tag
--     end
--     self:ApplyCharacterTag(Tag)
--     if IsValid(self.HollowSphereComponent) then
--         self.HollowSphereComponent:UpdateHollowRadius()
--     end

--     return true
-- end

function BP_CharacterBase_C:CharacterHasAnyTag(Tag)
    local SkillId = self:GetSkillByType(UE.ESkillType.Shooting)
    local Skill = self:GetSkill(SkillId)
    if not Skill then
        return
    end
    local Weapon = Skill.Weapon
    if not Weapon then
        return
    end
    return Weapon:CheckWeaponState(Tag)
end

function BP_CharacterBase_C:ShouldResetJump(Tag)
    return Tag == "HitFly" or Tag == "HeavyHit"
end

function BP_CharacterBase_C:ResetJumpState(KeepJumpCount)
    if not KeepJumpCount then
        self.JumpCount = 0
    end
    self:SetCurrentJumpState(Const.NormalState)
end

function BP_CharacterBase_C:CheckMountCanFly()
    if self.FromOtherWorld then 
        return false
    end
    local Avatar = GWorld:GetAvatar()
    if(not Avatar) then
        return true
    end
    if not self.CurrentMountId then 
        return false
    end
    return Avatar:CheckMountCanFly(self.CurrentMountId)
end

-- function BP_CharacterBase_C:EnterIdleTag()
    -- self:SetHitFlyState(UE4.EHitFlyState.NoHitFly)
    -- if self.Mesh:IsSimulatingPhysics("pelvis") then
    --     self:SetHitFlyState("RagdollFalling")
    --     self:SetCharacterTag("HitFly")
    --     self:BeginRagdollUpdate(true, "pelvis", 0.5, Const.HitFlyHeightMinValue)
    --     return 
    -- end
-- end


-- function BP_CharacterBase_C:DisableReloadWithoutShoot()
--     if self:IsPlayer() and  self.PlayerAnimInstance.ReloadWithoutShoot then 
--         self.PlayerAnimInstance.ReloadWithoutShoot = false
--     end
-- end

-- function BP_CharacterBase_C:EnterHitFlyTag()
--     self:SetHitFlyState("HitFly")
--     self:ResetJumpState()
--     if self.PlayerAnimInstance then
--         self.PlayerAnimInstance.CurrentJumpState = 0
--     end
-- end

-- function BP_CharacterBase_C:LeaveLandHeavyTag(NewTag)
--     self:RemoveTimer("LandHeavy")
-- end

-- function BP_CharacterBase_C:LeaveHitFlyTag(NewTag)
--     self:SetHitFlyState(UE4.EHitFlyState.NoHitFly)

--     if self.LuaTimerHandles["HitFlyDown"] ~= nil then
--         self:RemoveTimer(self.LuaTimerHandles["HitFlyDown"])
--         self.LuaTimerHandles["HitFlyDown"] = nil
--     end

--     if self.CurrentHitMontage and self.PlayerAnimInstance:Montage_IsPlaying(self.CurrentHitMontage) then 
--         self.PlayerAnimInstance:Montage_Stop(0, self.CurrentHitMontage) 
--     end
--     self.CurrentHitMontage = nil
-- end

-- function BP_CharacterBase_C:EnterHeavyHitTag()
--     self:ResetJumpState()
-- end

-- function BP_CharacterBase_C:LeaveHeavyHitTag(NewTag)
--     if self.LuaTimerHandles["HeavyHit"] ~= nil then
--         UE4.UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(self, self.LuaTimerHandles["HeavyHit"])
--         self.LuaTimerHandles["HeavyHit"] = nil
--     end

--     if self.CurrentHitMontage and self.PlayerAnimInstance:Montage_IsPlaying(self.CurrentHitMontage) then 
--         self.PlayerAnimInstance:Montage_Stop(0, self.CurrentHitMontage) 
--     end
--     self.CurrentHitMontage = nil
-- end

-- function BP_CharacterBase_C:LeaveLightHitTag(NewTag)
--     if self.LuaTimerHandles["LightHit"] ~= nil then
--         UE4.UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(self, self.LuaTimerHandles["LightHit"])
--         self.LuaTimerHandles["LightHit"] = nil
--     end

--     if self.CurrentHitMontage and self.PlayerAnimInstance:Montage_IsPlaying(self.CurrentHitMontage) then 
--         self.PlayerAnimInstance:Montage_Stop(0, self.CurrentHitMontage) 
--     end
--     self.CurrentHitMontage = nil
-- end

-- function BP_CharacterBase_C:LeaveLightHitRangedTag(NewTag)
--     if self.LuaTimerHandles["LightHitRanged"] ~= nil then
--         UE4.UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(self, self.LuaTimerHandles["LightHitRanged"])
--         self.LuaTimerHandles["LightHitRanged"] = nil
--     end

--     if self.CurrentHitMontage and self.PlayerAnimInstance:Montage_IsPlaying(self.CurrentHitMontage) then 
--         self.PlayerAnimInstance:Montage_Stop(0, self.CurrentHitMontage) 
--     end
--     self.CurrentHitMontage = nil
-- end

-- function BP_CharacterBase_C:LeaveHitRepelTag(NewTag)
--     if self.LuaTimerHandles["HitRepel"] ~= nil then
--         self:RemoveTimer(self.LuaTimerHandles["HitRepel"])
--         self.LuaTimerHandles["HitRepel"] = nil
--         local ActorMoveComponent = self:GetActorMoveComponent()
--         if not ActorMoveComponent then
--             return
--         end
--         ActorMoveComponent:ClearMoveInfo(ESourceTags.HitRepel)
--     end
-- end

function BP_CharacterBase_C:EnterStunFloatTag()
    -- body
    self:SetRagdollFloating(true)
end

function BP_CharacterBase_C:LeaveStunFloatTag()
    -- body
    self:SetRagdollFloating(false)
end

function BP_CharacterBase_C:MonsterCommonLeaveTag()
end

--
--function BP_CharacterBase_C:StopSkill_Lua(ClientActive, Reason)
--    if self.CurrentSkillId == nil or self.CurrentSkillId == 0 then 
--        return 
--    end
--    if ClientActive == nil then
--        ClientActive = false
--    end
--    if Reason == nil then 
--        Reason = UE.ESkillStopReason.Unknown
--    end
--    self:StopSkill(ClientActive, Reason)
--end

--function BP_CharacterBase_C:RealStopSkill(ClientActive, Reason)
--    if self.FallAttackComp then
--        self.FallAttackComp:RealStopSkill()
--    end
--    local Skill = self:GetSkill(self.CurrentSkillId)
--    if Skill.CancelBlockMove then
--        self.PlayerAnimInstance:ForceToRunloop()
--    end
--    self.LockOrient = false
--    if self:IsPlayer() and (not self:CheckWeaponCanRelease()) then 
--        self.PlayerAnimInstance.StartShoot = false 
--        self:DisableReloadWithoutShoot()
--        self:ShouldEnableHandIk()
--    end
--    self.PlayerAnimInstance.FullBody = not self.PlayerAnimInstance.StartShoot
--    self:StopSkillMontage()
--    self.Overridden.StopSkill(self, ClientActive, Reason)
--
--    local SkillEndEnterTag = DataMgr.Skill[Skill.SkillId][Skill.SkillLevel][Skill.SkillGrade].SkillEndEnterTag
--    
--    -- 尝试进入指定的Tag
--    if not SkillEndEnterTag or not self:SetCharacterTag(SkillEndEnterTag) then 
--        self:SetCharacterTagIdle()
--        self.IsInAir = self:IsCharacterInAir() --这里可能会有IsInAir = ture但是IsCharacterInAir返回false的情况，所以加一次判断
--        self:RecoverLocomotionRotationRate()
--    end
--    
--    --清空本次技能造成的累计仇恨
--    if self:GetCurrentSkill() then
--        self:GetCurrentSkill().HatredAll:Clear()
--    end
--    
--    self.FXComponent:StopSkillFxObjects()
--
--    
--    
--
--    if Skill.StopSkillCalcCD then
--        self:SetSkillTimestamp(self.CurrentSkillId, true)
--    end
--    self.CurrentSkillId = nil
--
--    self.PlayerAnimInstance.IsBlocking = false
--    self.ImpendingSetted = false
--    if not self.IsInAir then
--        self:ResetJumpState_Cpp()
--    end
--
--    if Skill.IgnoreTimeDilation then
--        self:SetCanNotChangeTimeDilation(false)
--        self:ResetHitStop()
--    end
--    self:UnLoadUltraWeaponOnStopSkill(Skill)
--    Skill:SetSkillStopReason(Reason)
--    if Battle(self) then
--        Battle(self):TriggerBattleEvent(BattleEventName.AfterSkill, self, Skill)
--    end
--    Skill.NodeStep = 0
--    Skill:SetSkillStopReason(nil)
--end

--function BP_CharacterBase_C:UnLoadUltraWeaponOnStopSkill(Skill)
--    local WeaponTag = self:ChooseWeaponToUse(Skill)
--    if WeaponTag and WeaponTag == "Ultra" then
--        if self.BuffManager and self.BuffManager.UseSummonWeapon then
--            return
--        else
--            self:DisburdenUltraWeapon()
--        end
--    end
--end

-- function BP_CharacterBase_C:StopSkillMontage()
--     local BlendOutTime = self:GetMontageBlendOutTime()
--     if (self.PlayerAnimInstance and self.PlayerAnimInstance:IsAnyMontagePlaying()) then
--         self.PlayerAnimInstance:Montage_Stop(BlendOutTime)
--     end
-- end

-- function BP_CharacterBase_C:GetMontageBlendOutTime()
--     -- body
--     if self:IsSkillFinished() then 
--         return Const.MontageBlendOutTime
--     end
--     local CurrentNode = self.SkillTimeLine.CurrentSkillNode
--     if not CurrentNode then 
--         return Const.MontageBlendOutTime
--     end
--     local BlendOutTime = CurrentNode.MontageBlendOutTime
--     if not BlendOutTime then 
--         return Const.MontageBlendOutTime
--     end
--     return BlendOutTime

-- end

--function BP_CharacterBase_C:LeaveSkillTag()
    --if not self:IsSkillFinished() then
    --    self:StopSkill()
    --end
    --local CurWeapon = self:GetCurrentWeapon()
    --if not IsValid(CurWeapon) then 
    --    return
    --end
    --if not IsValid(CurWeapon.FXComponent) then 
    --    return  
    --end
    --CurWeapon.FXComponent:DetachNiagaraComponent()
    -- self:GetCurrentWeapon().FXComponent:DetachNiagaraComponent()
--end

-- function BP_CharacterBase_C:LeaveShootingTag(NewTag)
--     if not self:IsSkillFinished() then
--         self:StopSkill()
--     end
--     if not self.PlayerAnimInstance then 
--         return 
--     end
--     self.PlayerAnimInstance:RemoveHoldHandler()
--     self.PlayerAnimInstance:SetKawaiiPhysics(NewTag)
--     -- if self.PlayerAnimInstance then
--     --     self.PlayerAnimInstance.EnableAim = UE4.UKismetMathLibrary.Clamp(self.PlayerAnimInstance.EnableAim - 1,0, 1)
--     -- end
--     if (NewTag == "Crouch") then 
--         self:DisableReloadWithoutShoot()
--     end
--     print(_G.LogTag, "self.PlayerAnimInstance.StartShoot",NewTag, self.PlayerAnimInstance.StartShoot)

--     if NewTag == "Idle" or NewTag == "Shooting" or NewTag == "Falling" then 
--         return 
--     end
--     self.PlayerAnimInstance.StartShoot = false
--     self:DisableReloadWithoutShoot()
--     self:ShouldEnableHandIk()
--     self.PlayerAnimInstance.FullBody = not self.PlayerAnimInstance.StartShoot

--    if self.PlayerAnimInstance then
--         self.PlayerAnimInstance.EnableAim = UE4.UKismetMathLibrary.Clamp(self.PlayerAnimInstance.EnableAim - 1,0, 1)
--     end
-- end

function BP_CharacterBase_C:UpdateBillboardComp_BuffSpecialEffect(ShowHotUI, CharInvisible, InvincibleUI)
    if self.BillBoardComponent then
        self.BillBoardComponent:BuffChange_SpecialEffect(ShowHotUI, CharInvisible, InvincibleUI)
    end
end

--function BP_CharacterBase_C:OnDead(KillMineRoleEid, KillMineSkillId, DeathReason)
--    if not self.InitSuccess then 
--        DebugPrint("Tianyi@ InitSuccess if false")
--        return 
--    end
--
--    if self.AlreadyDead then  
--        DebugPrint("Tianyi@ Already Dead")
--        return 
--    end
--    self:StopAllCurrentMove()
--    self:SetCharacterTag("Dead")
--    self.Overridden.OnDead(self, KillMineRoleEid, KillMineSkillId, DeathReason)   
--    self:RealOnDead(KillMineRoleEid, KillMineSkillId, DeathReason)
--    self.AlreadyDead = true
--end

function BP_CharacterBase_C:OnRealEnterDying()
    if not Battle(self) then return end
    -- 通知UI可以显示复活图标了
    if not IsDedicatedServer(self) then 
        -- EventManager:FireEvent(EventID.CharWaitingResurgence, self.Eid)
        if self:IsMainPlayer() then 
            self:ShowPlayerDeadUI()
        end
    end

    Battle(self):TriggerBattleEvent(BattleEventName.OnTeammateCanRecovery, self)

    if self.IsHostage then -- 如果是人质倒地，通知一下GameMode
        local GameMode = UGameplayStatics.GetGameMode(self)      
        if GameMode then    
            GameMode:TriggerDungeonComponentFun("OnHostageDying", self)
        end
    end
end

-- 离开濒死状态，进入真正死亡阶段
function BP_CharacterBase_C:OnRealDie()

end

function BP_CharacterBase_C:UpdateRecovererInfo(Eid, RecoverySpeed)
    self.RecoverTargets = self.RecoverTargets or {}
    if RecoverySpeed <= 0 then 
        self.RecoverTargets[Eid] = nil
    else
        self.RecoverTargets[Eid] = RecoverySpeed
    end

    if not next(self.RecoverTargets) then 
        DebugPrint("Tianyi@ 救助者: " .. self.Eid .. '不再救助对象')
        self.IsRecoveringOthers = false
    else 
        DebugPrint("Tianyi@ 救助者: " .. self.Eid .. '正在救助对象')
        self.IsRecoveringOthers = true
    end
end

function BP_CharacterBase_C:ClearCharacterBattleInfo(NormalDeath, DeathReason)
    self.BornInfo = nil
    self:DestroyActorOnDead_CPP(NormalDeath, DeathReason)
    self:RemoveAllEffectCreature(NormalDeath)
    self:CancelAFDTransform()
end

function BP_CharacterBase_C:StopFire(bStillHoldFire, OnlyReleaseFire)
end
function BP_CharacterBase_C:ResetIdle()
    if self:IsDead() then 
        return 
    end
    
    self:StopSkill(UE.ESkillStopReason.ActionCancel)
    self:StopFire(false, false)
 
    if self:IsPlayer() then 
        self:StopAllCurrentMove()
        self:StopJump()
        self:SetHoldCrouch(false)
        if self:CharacterInTag("Avoid") then 
            self:StopDodge(true, 0)
        end
        self:RemoveClearInputCache()
	    self:FlushPlayerPressedKeys()
	    self.MoveInputCache:Set(0,0,0)
        self.MoveInput:Set(0,0,0)
        if(self:GetMovementComponent()) then 
            self:GetMovementComponent():ConsumeInputVector()
        end
    end
    self:ResetJumpState_Cpp()
    self:RealStopSlide(false)
	self:ResetCapSize()
    if(self.PlayerAnimInstance) then 
        self.PlayerAnimInstance:ForceToIdle()
    end
    self:GetMovementComponent().bForceStop = true
    self:LaunchCharacter(FVector(0,0,0),true,true)
    if self.LuaTimerHandles then 
        self:RemoveTimer(self.LuaTimerHandles["BulletJump"])
    end
    self:StopInteractive()
	

	self:SetCharacterTagIdle()
	if not self.EMAnimInstance then 
        return 
    end
    local AnimInstance = self.EMAnimInstance
	AnimInstance:StopSkillAnimation()
    AnimInstance:Montage_Stop(0)
    if AnimInstance.ForceToIdle then
        AnimInstance:ForceToIdle()
    end
    if(AnimInstance.RootMotionMode ~= ERootMotionMode.RootMotionFromMontagesOnly) then
        AnimInstance:SetRootMotionMode(ERootMotionMode.RootMotionFromMontagesOnly)
    end
end

function BP_CharacterBase_C:OnTriggerFallingCallable()
    self:ResetIdle()
    self:FinishGather()
    self:DestroyAllCreatures(ECreatureDeathWithCreator.Failing, EDeathReason.CreatureNotDelay)
    self:HandleRemoveBuff(self.Eid, 1)
    self:GetGrabLogicComponent():ReleaseAllGrabTargets()
    
    if self.CurrentSkillId then 
        if self:IsPlayer() then 
            -- TODO: 后续应该会把这种缓存迭代掉
            self["bSkill1LongPress"] = false
            self["bSkill2LongPress"] = false
        end

        -- self:StopSkill()  -- 优化 ResetIdle里调过StopSkill 这里不用调了
        self:ClearInputCache()
    end

    -- 把速度清掉
    self:LaunchCharacter(FVector(0, 0, -100), true, true)
end

function BP_CharacterBase_C:ResetBulletRotation()
    self.bBulletJumpRotation = false
    self.BulletJumpRotation = nil
    self.RecoverPitch = true
end

function BP_CharacterBase_C:CheckCeilingHit(Height)
    local Start = self:K2_GetActorLocation()
    local End = Start + FVector(0, 0, Height + self.CapsuleComponent:GetUnscaledCapsuleHalfHeight())
    local HitResult = FHitResult()
    local bHit = UE4.UKismetSystemLibrary.LineTraceSingle(self, Start, End, ETraceTypeQuery.TraceSkillCreatureBlock, false, nil, 0, HitResult, true)
    return bHit
end


function BP_CharacterBase_C:GetFloorInfo()
    local FindFloorResult = FFindFloorResult()
    self:GetMovementComponent():K2_FindFloor(self.CapsuleComponent:K2_GetComponentLocation(), FindFloorResult)
    return FindFloorResult
end

function BP_CharacterBase_C:GetFloorDist(FindFloorResult)
    local FloorDist = FindFloorResult.FloorDist
    if FindFloorResult.bLineTrace then
        FloorDist = FindFloorResult.LineDist
    end
    return FloorDist
end

-- function BP_CharacterBase_C:IsCharacterOnWalkableGround(FloorInfo)
--     if not FloorInfo then
--         FloorInfo = self:GetFloorInfo()
--     end
--     local HitResult = FloorInfo.HitResult
--     local Actor = HitResult.Actor
--     if Actor and UE4.UKismetSystemLibrary.DoesImplementInterface(Actor, UEffectSourceInterface:StaticClass()) then
--     else
--         return FloorInfo.bBlockingHit
--     end
--     -- PrintTable({Actor=HitResult.Actor})
--     -- return FloorInfo.bBlockingHit
-- end

function BP_CharacterBase_C:IsCharacterWalking()
    return self:GetMovementComponent():IsWalking() and self:GetVelocity():Size2D() ~= 0 and (self:CharacterInTag("Idle") or self:CharacterInTag("Name_None"))
end

function BP_CharacterBase_C:IsCharacterIdling()
    return self:GetMovementComponent():IsWalking() and self:GetVelocity():Size2D() == 0
end

-- function BP_CharacterBase_C:IsCharacterInAir()
--     return self.Overridden.IsCharacterInAir(self)
--     -- local Movement = self:GetMovementComponent()
--     -- local MovementFalling = Movement:IsFalling()
--     -- local CharacterInAir = MovementFalling
--     -- if self.AutoSyncProp.IsSliding or self:CharacterInTag("Avoid") then
--     --     CharacterInAir = not self:IsCharacterOnGround()
--     -- end
--     -- CharacterInAir = (CharacterInAir or self.AutoSyncProp.IsBulletJumping)
--     -- return CharacterInAir
-- end

function BP_CharacterBase_C:IsCharacterInAirAndFalling()
    local Falling = false
    if self.JumpCount == 0 and self:GetMovementComponent():IsFalling() and ((self:GetVelocity().Z >= 0 and self:GetVelocity().Z <= Const.VectorSizeZero)or self:GetVelocity().Z <=0) then
        return true
    end
    -- Falling WhenJump
    if self.LastZSpeed ~= nil then
        -- print('self:GetVelocity().Z ', self.LastZSpeed, self:GetVelocity().Z, self.LastZSpeed * self:GetVelocity().Z)
        Falling = self.LastZSpeed * self:GetVelocity().Z <= 0
        self.LastZSpeed = self:GetVelocity().Z
    end
    if self.LastZSpeed ~= nil and Falling and self:GetMovementComponent():IsFalling() then
        return true
    end
    return false
end

-- Monster的ReceiveSound移到c++，Player的ReceiveSound移到PlayerCharacter
-- function BP_CharacterBase_C:ReceiveSound(SoundSourceLoc, Strength)
--     self.Overridden.ReceiveSound(self, SoundSourceLoc, Strength)
-- end

-- function BP_CharacterBase_C:IsCharacterInBaseMovement()
--     return self.NormalMovementTags:Contains(self.AutoSyncProp.CharacterTag)
-- end

-- function BP_CharacterBase_C:ApplyPush(HitNormalVelocity, InPushFactor, DeltaTime)
--     local TempVelocity = FVector(HitNormalVelocity.X, HitNormalVelocity.Y, HitNormalVelocity.Z)
--     TempVelocity:Normalize()
--     local MinusTempVelocity = self:GetVelocity() -  TempVelocity * TempVelocity:Dot(self:GetVelocity())
--     local FinalLaunchVelocity = MinusTempVelocity + HitNormalVelocity*(1.0/DeltaTime)* InPushFactor
--     FinalLaunchVelocity.Z = 0
--     -- UE4.UKismetSystemLibrary.DrawDebugLine(self, self:K2_GetActorLocation(), self:K2_GetActorLocation()+FinalLaunchVelocity, FLinearColor(0,111,0), 60, 3)
--     -- UE4.UKismetSystemLibrary.DrawDebugLine(self, self:K2_GetActorLocation(), self:K2_GetActorLocation()+self:GetVelocity(), FLinearColor(11,0,1), 60, 3)

--     if self:IsMonster() and FinalLaunchVelocity:Size() > 0 then
--         self:GetMonMoveComp():AIComputeSlipVectorRecursion(HitNormalVelocity, 1, self:Cast(AMonsterCharacter),0)
--         -- self.bBePushed = true
--         -- self.bCanCombinePushedVelocity = true
--         -- self.bInPushingTimer = true
--         self:SetPushEndTimerEvent()
--         -- self:AddTimer(0.5, function() 
--         --     if(IsValid(self)) then
--         --         self.bInPushingTimer = false
--         --     end
--         -- end)
--         self:GetMovementComponent().bSkipLaunchSetFalling = true

--         local GameState = UE4.UGameplayStatics.GetGameState(self)
--         if GameState and GameState.MonsterMoveDebug then
--             UE4.UKismetSystemLibrary.DrawDebugLine(self, self:K2_GetActorLocation(), self:K2_GetActorLocation() + FinalLaunchVelocity, FLinearColor(10, 111, 0), 1, 3)
--         end
--         self:DisableRootMotion(ESourceTags.ApplyPush)
--         -- print('1111111111111111111111111111111111111111111111111zjy',self:GetVelocity(), FinalLaunchVelocity:Size())

--     end
--     print(_G.LogTag, 'ApplyPush', FinalLaunchVelocity:Size())
--     self:MoveSmooth(FinalLaunchVelocity, DeltaTime)
--     -- self:GetVelocity()
-- end

function BP_CharacterBase_C:GetAimRotation()
    return self.AimingRotation
end

-- function BP_CharacterBase_C:CheckWeaponHit(FXGroupNames, DecalGroupNames, PlayInterval, CheckRadius, NormalOffset, NormalToWall, DecalSize, HitWallSe, SoundId)

--     if not self:GetCurrentWeapon() or not self:GetCurrentWeapon():HasTag("Melee") then 
--         return
--     end
--     if self.bWeaponHittedWall and not self.WeaponDecalInfo then 
--         return 
--     end
    
--     if FXGroupNames:Num() == 0 and DecalGroupNames:Num() == 0 then 
--         return 
--     end

--     local Weapon = self:GetCurrentWeapon()
--     local StartPos = Weapon.WeaponMesh:GetSocketLocation("WeaponHitWallBottom")
--     local EndPos = Weapon.WeaponMesh:GetSocketLocation("WeaponHitWallTop")
--     local HitResult1 = FHitResult()
--     -- local HitResult2 = FHitResult()

--     local bHit1 = UE4.UKismetSystemLibrary.SphereTraceSingle(self, StartPos, EndPos, CheckRadius, ETraceTypeQuery.TraceExceptChar, false, nil, 0, HitResult1, true, UE4.FLinearColor(1, 0, 0, 1),UE4.FLinearColor(0, 1, 0, 1),5)
--     -- local bHit2 = UE4.UKismetSystemLibrary.SphereTraceSingle(self, EndPos, StartPos, CheckRadius, ETraceTypeQuery.TraceExceptChar, false, nil, 0, HitResult2, true, UE4.FLinearColor(1, 1, 0, 1),UE4.FLinearColor(0, 1, 0, 1),5)
--     -- Some wall can't be hit by bottom to top
--     local HitResult = HitResult1
--     -- if not HitResult1.bBlockingHit then 
--     --     HitResult = HitResult2
--     -- end


--     if self.WeaponDecalInfo and self.bWeaponHittedWall then
--         local EndWeaponSocketPos = self.WeaponDecalInfo.CurrentWeapon.WeaponMesh:GetSocketLocation("WeaponHitWallTop")
--         -- if HitResult.bBlockingHit then 
--         --      HitPosition = FVector(HitResult.ImpactPoint.X, HitResult.ImpactPoint.Y, HitResult.ImpactPoint.Z)
--         -- end
--         self.WeaponDecalInfo.EndWeaponSocketPos = EndWeaponSocketPos--self.WeaponDecalInfo.CurrentWeapon.WeaponMesh:GetSocketLocation("WeaponHitWallBottom")
--         self:ProjectSocketMove()
--         self:PlayDecalGroup()
--         -- UE4.UKismetSystemLibrary.DrawDebugCylinder(self, self.WeaponDecalInfo.HitPosition , self.WeaponDecalInfo.HitPosition + self.WeaponDecalInfo.MoveDirection*100, 30, 12, FLinearColor(1,0,0), 2, 3)

--         self.WeaponDecalInfo = nil
--         return 
--     end

--     if self.bWeaponHittedWall then 
--         return 
--     end

--     if not HitResult.bBlockingHit  then
--         return
--     end
--     self.bWeaponHittedWall = true
--     if not self.bCouldPlayWeaponHitFx then 
--         return 
--     end
--     local HitPosition = HitResult.ImpactPoint
--     local LocalRotate = FRotator(0,0,0)
--     if NormalToWall then 
--         LocalRotate = FVector(HitResult.ImpactNormal.X, HitResult.ImpactNormal.Y, HitResult.ImpactNormal.Z):ToRotator()
--     end
--     local HitOffset = FVector(HitPosition.X, HitPosition.Y, HitPosition.Z) + HitResult.ImpactNormal * NormalOffset
--     local SurfaceType = UE4.UGameplayStatics.GetSurfaceType(HitResult)
--     if not SurfaceType then 
--         SurfaceType = UE4.EPhysicalSurface.SurfaceType_Default
--     end
--     local FXGroupName = FXGroupNames:Find(SurfaceType) or FXGroupNames:Find(UE4.EPhysicalSurface.SurfaceType_Default)
    
--     if FXGroupName then 
--         Weapon.FXComponent:PlayGroupFX(FXGroupName, false, Weapon.WeaponMesh, nil, "", "", HitOffset, LocalRotate, nil, true)
--     end
--     self.WeaponDecalInfo = {
--         CurrentWeapon = Weapon,
--         HitPosition = FVector(HitPosition.X, HitPosition.Y, HitPosition.Z),
--         StartWeaponSocketPos = Weapon.WeaponMesh:GetSocketLocation("WeaponHitWallTop"),--FVector(HitPosition.X, HitPosition.Y, HitPosition.Z),
--         NormalVector = FVector(HitResult.ImpactNormal.X, HitResult.ImpactNormal.Y, HitResult.ImpactNormal.Z),
--         DecalOwner = self,
--         DecalGroupName = DecalGroupNames:Find(SurfaceType) or DecalGroupNames:Find(UE4.EPhysicalSurface.SurfaceType_Default),
--         DecalSize = FVector(DecalSize.X, DecalSize.Y, DecalSize.Z)
--     }
--     self.bCouldPlayWeaponHitFx = false
--     self:AddTimer(PlayInterval, self.ResetCouldPlay, false, 0, "WeaponHitWall")
--     if HitWallSe == true then
--         local ExtraParams = {}
--         ExtraParams.SaveLocation = HitResult.ImpactPoint
--         local Material = AudioManager(self):GetHitSurfaceMaterial(HitResult)
--         ExtraParams.KeyValueGroups = {["material"] = Material}
--         AudioManager(self):PlayFMODSoundByID(self,SoundId,self,nil,ExtraParams)
--     end
-- end


-- function BP_CharacterBase_C:PlayDecalGroup()
--     local Weapon = self.WeaponDecalInfo.CurrentWeapon
--     if not Weapon or not UE4.UKismetSystemLibrary.IsValid(Weapon) then 
--         return 
--     end
--     if not self.WeaponDecalInfo.DecalGroupName then 
--         return 
--     end
--     HitResult = FHitResult()
--     local StartPos = self:K2_GetActorLocation()
--     local EndPos = StartPos + self:GetActorForwardVector() * 100 -- trace fron 1 meter
--     local bHit = UE4.UKismetSystemLibrary.LineTraceSingle(self, StartPos, EndPos, ETraceTypeQuery.TraceExceptChar, false, nil, 0, HitResult, true)
--     if bHit then 
--         self.WeaponDecalInfo.HitPosition = self:FixUpHitPosition(HitResult)
--     end
--     Weapon.FXComponent:PlayDecalGroupByHit(self.WeaponDecalInfo.DecalGroupName, self.WeaponDecalInfo)
-- end

function BP_CharacterBase_C:GetLittleOffset()
    return Const.LittleOffset
end

-- function BP_CharacterBase_C:FixUpHitPosition(HitResult)
--     local TraceHitPoint = FVector( HitResult.ImpactPoint.X,  HitResult.ImpactPoint.Y,  HitResult.ImpactPoint.Z)
--     local HitToFront = self.WeaponDecalInfo.HitPosition - TraceHitPoint
--     HitToFront:Normalize()
--     if HitToFront:Dot(self:GetActorForwardVector()) <  Const.LittleOffset  then 
--         return self.WeaponDecalInfo.HitPosition
--     end
--     local UpVector = self:GetActorForwardVector():Cross(HitToFront)
--     local FixedDirection = UpVector:Cross(self:GetActorForwardVector())
--     FixedDirection = FixedDirection * (self.WeaponDecalInfo.HitPosition - TraceHitPoint):Dot(FixedDirection)
--     return TraceHitPoint + FixedDirection
-- end

-- function BP_CharacterBase_C:ProjectSocketMove()
--     local MoveDirection = self.WeaponDecalInfo.EndWeaponSocketPos - self.WeaponDecalInfo.StartWeaponSocketPos
--     --UE4.UKismetSystemLibrary.DrawDebugCylinder(self, self.WeaponDecalInfo.StartWeaponSocketPos , self.WeaponDecalInfo.EndWeaponSocketPos, 30, 12, FLinearColor(0,0,1), 2, 3)

--     local PlatNormal = self.WeaponDecalInfo.NormalVector
--     local Projection = MoveDirection + PlatNormal*(MoveDirection:Dot(PlatNormal)*(-1))
--     Projection:Normalize()
--     --UE4.UKismetSystemLibrary.DrawDebugCylinder(self, self.WeaponDecalInfo.HitPosition , self.WeaponDecalInfo.HitPosition + Projection*100, 30, 12, FLinearColor(1,0,0), 2, 3)
--     self.WeaponDecalInfo.MoveDirection = Projection
-- end

-- function BP_CharacterBase_C:ResetCouldPlay()
--     self.bCouldPlayWeaponHitFx = true
--     self.WeaponHittedWall = false
-- end

-- function BP_CharacterBase_C:ForceClearActorHideTag()
--     if not self.HideTags then
--         return
--     end

--     for _, HideTag in pairs(CommonUtils.Keys(self.HideTags)) do
--         self:SetActorHideTag(HideTag, nil)
--     end
-- end

-- function BP_CharacterBase_C:SetActorNoCollisionTag(bNoCollision, Tag)
--     if self.NoneCollisionTags == nil then
--         self.NoneCollisionTags = {}
--     end
--     if bNoCollision then
--         self.NoneCollisionTags[Tag] = 1
--     else
--         self.NoneCollisionTags[Tag] = nil
--     end
--     local bDisable = not IsEmptyTable(self.NoneCollisionTags)
--     self:SetActorEnableCollision(not bDisable)
-- end

-- function BP_CharacterBase_C:SetActorHideTag(HideTag, Invisible, bOnlyCharacter)
--     if self.HideTags == nil then
--         self.HideTags = {}
--     end
--     if Invisible then
--         self.HideTags[HideTag] = 1
--     else
--         self.HideTags[HideTag] = nil
--     end
--     local Hide = not IsEmptyTable(self.HideTags)
--     self:SetActorHiddenInGame(Hide)
--     if bOnlyCharacter then
--         return
--     end
--     if self.IsBoss and (IsClient(self) or IsStandAlone(self)) then
--         local UIManager = GWorld.GameInstance:GetGameUIManager()
--         local BossBloodUI = UIManager:GetUIObj("BossBlood")
--         local Tag = Hide and UE4.ESlateVisibility.Collapsed or UE4.ESlateVisibility.SelfHitTestInvisible
--         if BossBloodUI then
--             BossBloodUI:SetVisibility(Tag)
--             if not Hide and not BossBloodUI.IsResetBossToughness and BossBloodUI.OutHideTag then
--                 BossBloodUI:OutHideTag()
--             end
--         end
--     end
--     self:HideAllAttaches(HideTag, Invisible)
-- end

function BP_CharacterBase_C:GetAllAttaches()
    local Attaches = {}
    if self.Weapons then 
        for _, v in pairs(self.Weapons) do
            table.insert(Attaches, v)
        end
    end

    if self.GetAccessories then 
        for _, v in pairs(self:GetAccessories()) do
            table.insert(Attaches, v)
        end
    end
    
    return Attaches
end

---@param bUnusingInBind boolean @武器用的，是否作用于非当前正在使用但是处于bind下的武器
-- function BP_CharacterBase_C:HideAllAttaches(HideTag, Hidden, bUnusingInBind)
--     self:HideAllWeapons(HideTag, Hidden, bUnusingInBind, false)
--     if self.Accessories then 
--         for _, v in pairs(self.Accessories) do
--             if IsValid(v) then
--                 v:SetActorHideTag(HideTag, Hidden)
--             end
--         end
--     end
--     -- local Attaches = self:GetAllAttaches()
--     -- for _, Attach in pairs(Attaches) do
--     --     if Attach.SetActorHideTag then
--     --         Attach:SetActorHideTag(HideTag, Hidden)
--     --     end
--     -- end
-- end

-- function BP_CharacterBase_C:CanExtractZVelocity()
--     if not self.PlayerAnimInstance then 
--         return false
--     end
--     local JumpOverride = (self.PlayerAnimInstance.CurrentJumpState == Const.Climb) or (self.PlayerAnimInstance.CurrentJumpState == Const.WallJump)
--     local SkillOverride = self:CharacterInTag("Skill") and (self.SkillTimeline.CurrentSkillNode.CanExtractZVelocity)
--     local InteractiveOverride = self:CharacterInTag("Seating") or self:CharacterInTag("Interactive")
--     return JumpOverride or SkillOverride or InteractiveOverride or self.bAlwaysRootMotionZ
-- end

function BP_CharacterBase_C:OnSpawnedByMovieCaptureSequence()
    self.Overridden.OnSpawnedByMovieCaptureSequence(self)
    if self.Weapons then
    for _, Weapon in pairs(self.Weapons) do
        if IsValid(Weapon) then
            Weapon:SetActorHiddenInGame(true)
        end
    end
    end
end

function BP_CharacterBase_C:InitRoleInfo()
    
end

--死亡服务器不进行物理模拟了。
-- function BP_CharacterBase_C:HandleDeadRagdollState(BoneName, GetUpTime)
--     if IsStandAlone(self) == true or IsDedicatedServer(self) == true and IsAuthority(self) ~= true then
--         self:SetSimulatePhysics(true, BoneName)
--         self:BeginRagdollUpdate(true, self.RagdollHitFlyBoneName, GetUpTime, Const.HitFlyHeightMinValue)
--     elseif IsDedicatedServer(self) == true and IsAuthority(self) == true then
--         self.EndRagdollState()
--     end
-- end	

-- function BP_CharacterBase_C:HandleGrabRagdollState(BoneName, GetUpTime)
--     self:SetSimulatePhysics(true, BoneName)
--     self:SetGrabRagdollState(true)
-- end

-- function BP_CharacterBase_C:HandleHitFlyRagdollState(BoneName, GetUpTime)
--     -- if IsAuthority(self) == true then
--     self:SetSimulatePhysics(true, BoneName)
--     self:BeginRagdollUpdate(true, self.RagdollHitFlyBoneName, GetUpTime, Const.HitFlyHeightMinValue)
--     -- else
-- 	-- 	self.Mesh:SetSimulatePhysics(true)
--     --     self.Mesh:SetAllBodiesBelowSimulatePhysics(BoneName, true, false)
--     --     self.Mesh:SetAllBodiesBelowPhysicsBlendWeight(BoneName, 1.0, false, false)
--     --     self:BeginRagdollUpdate(true, self.RagdollHitFlyBoneName, GetUpTime, Const.HitFlyHeightMinValue)
--     -- end
-- end

--分成3种情况， 1、击飞Ragdoll， 2、死亡ragdoll 3、抓取ragdoll。击飞ragdoll的同步方式：有服务器通知落地和结束。2、死亡ragdoll不同步，3、抓取ragdoll同步方式再看
-- function BP_CharacterBase_C:BeginRagdollState(CollisionProfileName, BoneName, AngularDamping, bCapsuleFollow, BlendWeight, GetUpTime, RogdollStateType)
--     -- body
--     -- self.CacheInfos["LiftHeightDuration"] = 0

-- 	if RogdollStateType < self.RagdollStateType then
-- 		return
-- 	end
--     self.RagdollStateType = RogdollStateType

--     self:SaveOriginalCollisionProfileName()
--     if type(CollisionProfileName) == "string" then
--         self.Mesh:SetCollisionProfileName(CollisionProfileName)
--     elseif type(CollisionProfileName) == "table" then
--         for k, v in pairs(CollisionProfileName) do
--             self:SetCollisionType("Mesh", k,  ECollisionResponse["ECR_"..v], false)
--         end
--     else
--         self.Mesh:SetCollisionProfileName(Const.HittedCollisionProfileName)
--     end

--     -- local Movement = self:GetMovementComponent()
--     -- Movement:SetMovementMode(EMovementMode.MOVE_None)
--     if AngularDamping < 0 then
--         self.OriginalAngularDamping =  self.OriginalAngularDamping or self.Mesh:GetAngularDamping()
--         self.Mesh:SetAngularDamping(AngularDamping) 
--     end
	
--     self:SetMeshVisibilityBasedAnimTickOption(EVisibilityBasedAnimTickOption.AlwaysTickPoseAndRefreshBones)
--     if RogdollStateType == CommonConst.RagdollStateHitFly then
--         self:HandleHitFlyRagdollState(BoneName, GetUpTime)
--     elseif RogdollStateType == CommonConst.RagdollStateDead then
--         self:HandleDeadRagdollState(BoneName, GetUpTime)
--     elseif RogdollStateType == CommonConst.RagdollStateGrab then
--         self:HandleGrabRagdollState(BoneName, GetUpTime)
--     end
-- end

-- function BP_CharacterBase_C:SetSimulatePhysics(bEnable,BoneName)
--     if (bEnable == nil) then bEnable = false end
--     if self.EnableSimulatePhysics == bEnable then return end
--     self.EnableSimulatePhysics = bEnable
--     if bEnable then
--         self.Mesh:SetSimulatePhysics(true)
--         self.Mesh:SetAllBodiesBelowSimulatePhysics(BoneName, true)
--         self.Mesh:SetAllBodiesBelowPhysicsBlendWeight(BoneName, 1.0)
--     else
--         self.Mesh:SetSimulatePhysics(false)
--         self.Mesh:SetAllBodiesSimulatePhysics(false)
--     end
-- end

-- function BP_CharacterBase_C:EndRagdollState()
--     -- body
-- 	self.RagdollStateType = -1
--     self:SetSimulatePhysics(false)
-- 	self.Mesh:K2_AttachToComponent(self.CapsuleComponent, "", EAttachmentRule.KeepRelative, EAttachmentRule.KeepRelative, EAttachmentRule.KeepRelative)
-- 	self.Mesh:K2_SetRelativeTransform(self.RelativeMeshTransform, false, nil, true)
    
--     self:EndRagdollUpdate()
--     self:SetMeshVisibilityBasedAnimTickOption(EVisibilityBasedAnimTickOption.AlwaysTickPose)

--     local Movement = self:GetMovementComponent()
--     Movement:SetMovementMode(Movement.DefaultLandMovementMode)

--     self:UseOriginalCollisionProfileName()
-- 	-- if self.OriginalCollisionProfileName == "Custom" then
-- 	-- 	self.OriginalCollisionProfileName = "CharacterMesh"
-- 	-- end
--     -- if self.OriginalCollisionProfileName then
--     --     self.Mesh:SetCollisionProfileName(self.OriginalCollisionProfileName)
--     --     self.OriginalCollisionProfileName = nil
--     -- end
-- 	self:AfterRagdollCollisionUpdate()
--     if self.OriginalAngularDamping then
--         self.Mesh:SetAngularDamping(self.OriginalAngularDamping)
--         self.OriginalAngularDamping = nil
--     end
	
-- end

-- function BP_CharacterBase_C:BeforeRagdollCollisionUpdate()
-- 	self.CapsuleOriginalCollisionResponse = self.CapsuleComponent:GetCollisionResponseToChannel(ECollisionChannel.ECC_Pawn, ECollisionResponse.ECR_OverLap)
-- 	self.CapsuleComponent:SetCollisionResponseToChannel(ECollisionChannel.ECC_Pawn, ECollisionResponse.ECR_OverLap)
-- 	self.CapsuleComponent:SetCollisionResponseToChannel(ECollisionChannel.ECC_GameTraceChannel7, ECollisionResponse.ECR_OverLap)

-- 	self.BlockPlayerOriginalCollisionResponse = self.MonsterBlockPlayer:GetCollisionResponseToChannel(ECollisionChannel.ECC_Pawn, ECollisionResponse.ECR_OverLap)
-- 	self.MonsterBlockPlayer:SetCollisionResponseToChannel(ECollisionChannel.ECC_Pawn, ECollisionResponse.ECR_OverLap)
-- end

-- function BP_CharacterBase_C:AfterRagdollCollisionUpdate()
-- 	if self.CapsuleOriginalCollisionResponse then
--         self.CapsuleComponent:SetCollisionResponseToChannel(ECollisionChannel.ECC_Pawn, self.CapsuleOriginalCollisionResponse)
-- 		self.CapsuleComponent:SetCollisionResponseToChannel(ECollisionChannel.ECC_GameTraceChannel7, self.CapsuleOriginalCollisionResponse)
--         self.CapsuleOriginalCollisionResponse = nil
--     end
-- 	if self.BlockPlayerOriginalCollisionResponse then
-- 		self.MonsterBlockPlayer:SetCollisionResponseToChannel(ECollisionChannel.ECC_Pawn, self.BlockPlayerOriginalCollisionResponse)
--         self.CapsuleOriginalCollisionResponse = nil
--     end
-- end

-- function BP_CharacterBase_C:SetFlyMode(bIsFly)
--     local Movement = self:GetMovementComponent()
--     if bIsFly and not self:IsFlying() then 
--         Movement.bKeepFlyingMode = true
--         Movement:SetMovementMode(UE4.EMovementMode.MOVE_Flying)
--     elseif not bIsFly and self:IsFlying() then 
--         self:SetCurrentJumpState(Const.NormalState)
--         Movement.bKeepFlyingMode = false
--         Movement:SetMovementMode(Movement.DefaultLandMovementMode)
--     end

--     self:SetFlyingMode(bIsFly)
-- end

function BP_CharacterBase_C:CheckIfEffectHitTarget(NotifyName)
    if not self.SkillTimeLine.CurrentSkillNode then
        return false
    end
    local EffectIds = self.SkillTimeLine.CurrentSkillNode:GetEffectIDsByNotifyName(NotifyName)
    for i = 1, #EffectIds do
        local EffectInfo = DataMgr.SkillEffects[EffectIds[i]]
        local TargetEids = EffectInfo.TargetFilter and Battle(self):DoTargetFilter(
                self, nil, DataMgr.SkillEffects[EffectIds[i]].TargetFilter, 
                EffectInfo.AllowSkillRangeModify or false, EffectInfo.AttackRangeType or "", false, 0)
        if TargetEids and TargetEids:Length() > 0 then
            return true
        end
    end
    return false
end

function BP_CharacterBase_C:IsEqualCurrentWeaponAttribute()
    if self:GetCurrentWeapon() == nil then return false end
    local OwnerAttribute = self:GetAttr("Attribute")
    local WeaponAttribute = self:GetCurrentWeapon():GetAttr("Attribute")
    return OwnerAttribute == WeaponAttribute
end

-- function BP_CharacterBase_C:OnRep_CurrentLevelId()
--     local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
--     local SceneMgr
--     if GameInstance and GameInstance.GetSceneManager then
--         SceneMgr = GameInstance:GetSceneManager()
--     end
-- 	if (SceneMgr ~= nil) and SceneMgr:GetLevelLoader() and SceneMgr:GetLevelLoader().LevelPathfinding then
--         if not self:IsPlayer() then
-- 		    SceneMgr:GetLevelLoader().LevelPathfinding:UpdatePathfindingByEid(self.Eid,self.CurrentLevelId,false)
--         elseif MiscUtils.IsAutonomousProxy(self) or IsStandAlone(self) then
--             SceneMgr:GetLevelLoader().LevelPathfinding:UpdateAllPathfinding(self.CurrentLevelId)
--             local Str = ''
--             for _,id in pairs(self.CurrentLevelId:ToTable()) do
--                 Str = Str .. id .. ','
--             end
--             DebugPrint('PlayerCharacter OnRep_CurrentLevelId     Eid:',self.Eid,' LevelId:',Str)
--         end
-- 	end
-- end

function BP_CharacterBase_C:DestroyPlayer()
    self:K2_DestroyActor()
end


function BP_CharacterBase_C:GetBattleCharBodyType()
    local DefaultBodyType = "Girl"

    -- 当前角色ID是否存在
    if not self.CurrentRoleId then
        LogError("GetBattleCharBodyType: CurrentRoleId is nil")
        return DefaultBodyType
    end

    -- 是否有对应角色数据
    local CharData = DataMgr.BattleChar[self.CurrentRoleId]
    if not CharData then
        LogError("GetBattleCharBodyType: No BattleChar found for ID", self.CurrentRoleId)
        return DefaultBodyType
    end

    local BattleCharTags = CharData.BattleCharTag
    if BattleCharTags then
        local BodyTypes = { "Girl", "Boy", "Loli", "Woman", "Man" }
        for _, value in ipairs(BattleCharTags) do
            for _, type in ipairs(BodyTypes) do
                if value == type then
                    return type
                end
            end
        end
    end

    -- 未匹配成功时，返回默认
    return DefaultBodyType
end

-- function BP_CharacterBase_C:CheckBattleCharTag(InTag)
--     local BattleCharTag = nil
-- 	if self:IsPlayer() or self:IsPhantom() then
-- 		BattleCharTag = self.BattleCharInfo.BattleCharTag
-- 	else
-- 		BattleCharTag = DataMgr.Monster[self.UnitId].BattleCharTag
-- 	end
--     if not BattleCharTag then
--         return false
--     end

--     for i = 1, #BattleCharTag do
--         if BattleCharTag[i] == InTag then
--             return true
--         end
--     end

--     return false
-- end

function BP_CharacterBase_C:SetCollisionType_Lua(ComponentName, ChannelIndex, Response,Reset)
    if Reset then
        self[ComponentName]:SetCollisionResponseToAllChannels(ECollisionResponse.ECR_Ignore)
    end
    self[ComponentName]:SetCollisionResponseToChannel(ChannelIndex,Response)
end

function BP_CharacterBase_C:HandleStuck(Hit)
    local ActorLocation = self:K2_GetActorLocation()
    local FixedLocation = ActorLocation + FVector(Hit.Normal.X, Hit.Normal.Y, Hit.Normal.Z) * Hit.PenetrationDepth
    self:K2_SetActorLocation(FixedLocation, false, nil, false)
end

-- function BP_CharacterBase_C:GetCameraComponent()
--     return self:K2_GetRootComponent()
-- end

function BP_CharacterBase_C:AddInteractiveTrigger()
    if self.InteractiveTriggerComponent == nil then
        local BPClass = LoadClass("/Game/BluePrints/Story/Interactive/Base/BP_InteractiveTriggerComponent.BP_InteractiveTriggerComponent")
        self.InteractiveTriggerComponent = self:AddComponentByClass(BPClass, false, FTransform(), false)
        self.InteractiveTriggerComponent:InitOnPlayerPossessed()
        if self.bForbidInteractiveTrigger then --- 避免可能在InteractiveTrigger初始化前就设置了不能触发
            self.InteractiveTriggerComponent:SetIsCanTrigger(false)
        end
    end
end

function BP_CharacterBase_C:GetHeadWidgetComponent()
    return self.HeadWidgetComponent
end

-- NPC名字、区域联机其他玩家头顶名字、魅影气泡使用
function BP_CharacterBase_C:InitHeadWidgetComponent()
    if self.HeadWidgetComponent then
        return
    end

    local HeadUISubsystem = UNpcHeadUISubsystem.GetHeadUISubsystem(self)
    if not HeadUISubsystem then return end
    self.HeadWidgetComponent = HeadUISubsystem:InitHeadWidgetComponent(self)
end

function BP_CharacterBase_C:EnableHeadWidget(WidgetName, bEnable, ...)
    if bEnable then
        self:InitHeadWidgetComponent()
    end
    if self.HeadWidgetComponent then
        if bEnable then
            if self.HeadWidgetComponent:NeedForceInit() then
				self.HeadWidgetComponent:AdjustSelfTransform()
			end
            self.HeadWidgetComponent:EnableWidget(WidgetName, ...)
        else
            self.HeadWidgetComponent:DisableWidget(WidgetName, ...)
        end
    end
end

function BP_CharacterBase_C:SetPlayerMaxMovingSpeed(Rate)
    if Rate < 0 then
        Rate = 0
    end
    if IsAuthority(self) then
        self.SpeedRate = Rate
    end
   self:SetWalkSpeed()
    -- local CrouchDataSpeed = DataMgr.PlayerRotationRates["CrouchWalkSpeed"].ParamentValue[1]
    -- local NormalDataSpeed = DataMgr.PlayerRotationRates["NormalWalkSpeed"].ParamentValue[1]
	-- self.PlayerSlideAtttirbute.NormalWalkSpeed = NormalDataSpeed * Rate
	-- self.PlayerSlideAtttirbute.CrouchWalkSpeed = CrouchDataSpeed * Rate
end

function BP_CharacterBase_C:RecoverPlayerMovingSpeed()
    if IsAuthority(self) then
        self.SpeedRate = 1
    end
    self:SetWalkSpeed()
    -- local CrouchDataSpeed = DataMgr.PlayerRotationRates["CrouchWalkSpeed"].ParamentValue[1]
    -- local NormalDataSpeed = DataMgr.PlayerRotationRates["NormalWalkSpeed"].ParamentValue[1]
    -- self.PlayerSlideAtttirbute.NormalWalkSpeed = NormalDataSpeed
    -- self.PlayerSlideAtttirbute.CrouchWalkSpeed = CrouchDataSpeed
end

function BP_CharacterBase_C:GetMoveRate()
    return self.PlayerSlideAtttirbute.NormalWalkSpeed / DataMgr.PlayerRotationRates["NormalWalkSpeed"].ParamentValue[1]
end

function BP_CharacterBase_C:GetMovingSpeed()
    return self.PlayerSlideAtttirbute.NormalWalkSpeed, self.PlayerSlideAtttirbute.CrouchWalkSpeed
end

-- function BP_CharacterBase_C:SetMaxMovingSpeed(Rate)
--     Rate = math.max(0, Rate)
-- 	self.PlayerSlideAtttirbute.NormalWalkSpeed = DataMgr.PlayerRotationRates["NormalWalkSpeed"].ParamentValue[1] * Rate
-- 	self.PlayerSlideAtttirbute.CrouchWalkSpeed = DataMgr.PlayerRotationRates["CrouchWalkSpeed"].ParamentValue[1] * Rate
--     self:SetWalkSpeed()
-- end

function BP_CharacterBase_C:SetMaxMovingSpeedByInfo(Info)
    self.PlayerSlideAtttirbute.NormalWalkSpeed = Info.NormalWalk
    self.PlayerSlideAtttirbute.CrouchWalkSpeed = Info.CrouchWalk
    self:SetWalkSpeed()
end

function BP_CharacterBase_C:GetMaxMovingSpeedInfo()
    return {
        NormalWalk = self.PlayerSlideAtttirbute.NormalWalkSpeed,
        CrouchWalk = self.PlayerSlideAtttirbute.CrouchWalkSpeed
    }
end

-- function BP_CharacterBase_C:GetFXQualityBias(FXShow, FXQuality)
--     -- body
--     if self.FXQualityBiasTime == nil or self.FXQualityBiasTime < Const.ScalabilityUpdateTime then
--         self:UpdateFXQualitySettings()
--         self.FXQualityBiasTime = Const.ScalabilityUpdateTime
--     end
--     return self.FXShow, self.FXQualityBias
-- end

-- function BP_CharacterBase_C:UpdateFXQualitySettings()
--     -- body
--     local FXShow = true
--     local QualityBias = 0
--     if Const.FriendFXQuality == nil then
--         local TeammateEffects = EMCache:Get("TeammateEffects")
--         if TeammateEffects == nil then
--             TeammateEffects = 2
--         end
--         Const.FriendFXQuality = TeammateEffects
--     end
--     if Const.FriendFXQuality < 2 then
--         local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
--         local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
--         if not self:IsMainPlayer() and not self:IsSummonByMainPlayer() and Player then
--             if self:IsFriend(Player) then
--                 if Const.FriendFXQuality == 1 then
--                     QualityBias = -1
--                 else
--                     FXShow = false
--                 end
--             end
--         end
--     end
--     self.FXShow = FXShow
--     self.FXQualityBias = QualityBias
-- end

function BP_CharacterBase_C:IsSeating()
    return self:GetCharacterTag() == "Seating"
end

function BP_CharacterBase_C:TestEnterTag(TagName)
    DebugPrint(self.Eid .. ' Enter Tag ' .. TagName)
end 

function BP_CharacterBase_C:TestLeaveTag(TagName)
    DebugPrint(self.Eid .. ' Enter Tag ' .. TagName)
end

function BP_CharacterBase_C:HandleCheckSkillNodeCondition(RetCode, SkillId, NodeId)
    if RetCode == ESkillNodeCondRetCode.Success then
        return true
    end

    if RetCode == ESkillNodeCondRetCode.OutOfBullet then
        if self:IsMainPlayer() then
            local Info = DataMgr.SkillNode[NodeId]
            if Info and not self.RangedWeapon:IsAllBulletEnough(Info.CostBullet) then -- 真的缺弹了
                EventManager:FireEvent(EventID.OutOfBullet)
            end
        end
        self.RangedWeapon:SetWeaponState("NoBullet", true)
    elseif RetCode == ESkillNodeCondRetCode.OutOfSp then
        if self:IsMainPlayer() then
            UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, "UI_TIP_MP")
        end
    elseif RetCode == ESkillNodeCondRetCode.OverHeat then
        self.RangedWeapon:SetWeaponState("OverHeat", true)
    end
    return false
end

-- function BP_CharacterBase_C:IsDisableSkillType(SkillType)
--     return self.BuffManager.DisableSkills[SkillType] or false
-- end

function BP_CharacterBase_C:ApplyEnterTag_Lua(NewTag)
    -- DebugPrint("Tianyi@ CharacterBase ApplyEnterTag_Lua " .. NewTag)
    return self:ApplyEnterCharacterTag(NewTag)
end

function BP_CharacterBase_C:ApplyLeaveTag_Lua(OldTag, NewTag)
    -- DebugPrint("Tianyi@ CharacterBase ApplyLeaveTag_Lua")
    return self:ApplyLeaveCharacterTag(OldTag, NewTag)
end

function BP_CharacterBase_C:CanLeaveTag_Lua(TagName)
    return self:CanLeaveCharacterTag(TagName)
end

function BP_CharacterBase_C:EnableTeleport_Lua(State)
    -- 钩锁以及被击飞时屏蔽周本传送
    -- State: true 重置传送， false 屏蔽传送
    if self:IsMainPlayer() then
        local PlayerState = self.PlayerState
        if not PlayerState or PlayerState.ActivatedDungeonDeliveryPointId == -1 then
            return false
        end
        local Tag = self:GetCharacterTag()
        if Tag == "Hook" or Tag == "HitFly" then
            if State == false then
                EventManager:FireEvent(EventID.OnTeleportReady, true)
                DebugPrint("ayff test  : stop teleport due to tag ", Tag)
            elseif State == true then
                EventManager:FireEvent(EventID.OnTeleportReady, false)
                DebugPrint("ayff test  : enable teleport due to tag ", Tag)
            end
        end
    end
    return false
end

--region UStoryPlayableInterface
---@param RotationAngle number
---@param OnStoryActionFinished FOnStoryActionFinished
function BP_CharacterBase_C:RotateOffset(RotationAngle, OnFinished, MontageName, InAddTurnRate)
    if self.EMAnimInstance == nil and self.NpcAnimInstance == nil then
        StoryPlayableUtils:ExecuteStoryDelegate(OnFinished)
        return
    end

    if self.EMAnimInstance then
        if (not self.EMAnimInstance:CanTurnInPlace()) or (math.abs(RotationAngle) < 10) then
            StoryPlayableUtils:ExecuteStoryDelegate(OnFinished)
        else
            self.OnStoryActionFinished = function()
                if self.OnStoryActionFinished then
                    StoryPlayableUtils:ExecuteStoryDelegate(OnFinished)
                end
                self.OnStoryActionFinished = nil
            end
            self:TurnByMotionWarping(RotationAngle,function ()
                StoryPlayableUtils:ExecuteStoryDelegate(OnFinished)
            end, MontageName)
        end
    end
    
    if self.NpcAnimInstance then
        if MontageName and MontageName ~= "None" then
            local ModelId = self:GetCharModelComponent():GetCurrentModelId()
            local ModelData = DataMgr.Model[ModelId]
            local RotateAnimPath = ModelData.MontageFolder or ""
            local Prefix = ModelData.MontagePrefix or ""
            MontageName = RotateAnimPath.."Locomotion/"..Prefix..MontageName.."_Montage."..Prefix..MontageName.."_Montage"
        end

        if (not self.NpcAnimInstance:CanTurnInPlace()) or (math.abs(RotationAngle) < 10) then
            -- self.NpcAnimInstance:ChangeTurnState(false)
            -- if self:GetMovementComponent():IsComponentTickEnabled() then
            --     self:SetNpcMovementTickEnable(false)
            -- end
            StoryPlayableUtils:ExecuteStoryDelegate(OnFinished)
        else
            self.NpcAnimInstance:ChangeTurnState(true)
            if not self:GetMovementComponent():IsComponentTickEnabled() then
                self:SetNpcMovementTickEnable(true)
            end

            if self:GetMovementComponent() and self:GetMovementComponent().LockMovementMode then
                self:GetMovementComponent():LockMovementMode(true, EMovementMode.MOVE_Walking)
            end

            self.OnStoryActionFinished = function()
                if self.OnStoryActionFinished then
                    StoryPlayableUtils:ExecuteStoryDelegate(OnFinished)
                end
                self.OnStoryActionFinished = nil
            end
            self:TurnByMotionWarping(RotationAngle,function ()
                StoryPlayableUtils:ExecuteStoryDelegate(OnFinished)
            end, nil, MontageName, InAddTurnRate)
        end
    end
end

function BP_CharacterBase_C:PlayTalkAction(ActionId, OnFinished, CallbackObj, CallbackFuncName, IsSync, IgnoreBlendInTime)
	-- 偶现 bug 定位
	if (type(OnFinished) == "userdata") then
		assert(OnFinished.Execute ~= nil)
	end
    
	local TalkActionData = DataMgr.TalkAction[ActionId]
	if (TalkActionData == nil) then
		Utils.ScreenPrint("ActionId 不存在:" .. tostring(ActionId))
		StoryPlayableUtils:ExecuteStoryDelegate(OnFinished)
		return 0
	end
    self.MontagesProxy = self.MontagesProxy or {}
    self.ActionGroupProxy = self.ActionGroupProxy or {}

	local MontagePaths = {}
	if TalkActionData.ActionMontage then
        local ActionMontagePath = self:GetTalkActionPath(TalkActionData.MontagePrePath, TalkActionData.ActionMontage)
        local ProxyData = {
            Path = ActionMontagePath,
            Group = "",
            ActionId = ActionId
        }
        table.insert(self.MontagesProxy, ProxyData)
		table.insert(MontagePaths, ActionMontagePath)
	end
	if TalkActionData.EndLoopMontage then
        local EndLoopMontage = self:GetTalkActionPath(TalkActionData.MontagePrePath, TalkActionData.EndLoopMontage)
         local ProxyData = {
            Path = EndLoopMontage,
            Group = "",
            ActionId = ActionId
        }
        table.insert(self.MontagesProxy, ProxyData)
		table.insert(MontagePaths, EndLoopMontage)
	end
	local LoadedCount = 0
	local TotalToLoad = #MontagePaths

    if IsSync then
        for _, MontagePath in pairs(MontagePaths) do
            local MontageAsset = LoadObject(MontagePath)
            local MontageGroupName = ""
            self.ActionGroupProxy[MontagePath] = true
            if IsValid(self.Mesh:GetAnimInstance()) and self.Mesh:GetAnimInstance().GetMontageSlotGroupName then
                MontageGroupName = self.Mesh:GetAnimInstance():GetMontageSlotGroupName(MontageAsset)
            end
            if MontageGroupName ~= "" and self.ActionGroupProxy[MontagePath] == true then
                DebugPrint("LHQ@@@@@PlayTalkAction:", MontagePath, "MontageGroupName:", MontageGroupName,  "UnitId:", self.UnitId)
                self.ActionGroupProxy[MontagePath] = nil
                self:PlayTalkActionInternal(TalkActionData, OnFinished, CallbackObj, CallbackFuncName, IgnoreBlendInTime, MontageGroupName)
            else
                if (IsValid(CallbackObj) and CallbackFuncName) then
                    CallbackObj[CallbackFuncName](CallbackObj)
                    if self.ActionGroupProxy then
                        self.ActionGroupProxy[MontagePath] = nil
                    end
                else
                    StoryPlayableUtils:ExecuteStoryDelegate(OnFinished)
                    if self.ActionGroupProxy then
                        self.ActionGroupProxy[MontagePath] = nil
                    end
                end
            end
        end
    else
        for _, MontagePath in pairs(MontagePaths) do
            self.ActionGroupProxy[MontagePath] = true

            UResourceLibrary.LoadObjectAsync(self, MontagePath, {self, function(_, Montage)
                local MontageGroupName = ""
                local MontageWidget = 0
                local IsLastAnim = true

                if IsValid(self.Mesh:GetAnimInstance()) and self.Mesh:GetAnimInstance().GetMontageSlotGroupName then
                    MontageGroupName = self.Mesh:GetAnimInstance():GetMontageSlotGroupName(Montage)
                    for Index, Data in pairs(self.MontagesProxy) do --保证异步加载的动作顺序
                        if Data and Data.Path ~= MontagePath and Data.ActionId ~= ActionId and Data.Group == MontageGroupName then
                            IsLastAnim = false
                        end

                        if Data and Data.Path == MontagePath then
                            Data.Group = MontageGroupName
                            MontageWidget = Index
                            IsLastAnim = true
                        end
                    end
                end

                LoadedCount = LoadedCount + 1
                if MontageWidget == 0 or IsLastAnim == false then
                    return
                end

                if (LoadedCount == TotalToLoad) then
                    if MontageGroupName ~= "" and self.ActionGroupProxy and self.ActionGroupProxy[MontagePath] == true then
                        self.ActionGroupProxy[MontagePath] = nil
                        DebugPrint("LHQ@@@@@PlayTalkAction:", MontagePath, "MontageGroupName:", MontageGroupName,  "UnitId:", self.UnitId)
                        self:PlayTalkActionInternal(TalkActionData, OnFinished, CallbackObj, CallbackFuncName, IgnoreBlendInTime, MontageGroupName)
                    else
                        if (IsValid(CallbackObj) and CallbackFuncName) then
                            CallbackObj[CallbackFuncName](CallbackObj)
                            if self.ActionGroupProxy then
                                self.ActionGroupProxy[MontagePath] = nil
                            end
                        else
                            StoryPlayableUtils:ExecuteStoryDelegate(OnFinished)
                            if self.ActionGroupProxy then
                                self.ActionGroupProxy[MontagePath] = nil
                            end
                        end
                    end
                end
            end})
        end

        -- self:AsyncLoadAndPlayTalkMontage(MontagePaths, 1, TalkActionData, OnFinished, CallbackObj, CallbackFuncName, IgnoreBlendInTime)
    end

    return 0
end

function BP_CharacterBase_C:AsyncLoadAndPlayTalkMontage(Paths, CurrentIndex, TalkActionData, OnFinished, CallbackObj, CallbackFuncName, IgnoreBlendInTime)
    local count = 0
    for _, v in pairs(Paths) do
        count = count + 1
    end

    if CurrentIndex > count then
        return
    end

    local MontagePath = Paths[CurrentIndex]
    UResourceLibrary.LoadObjectAsync(self, MontagePath, {self, function(_, Montage)
        self.ActionGroupProxy[MontagePath] = true

        local MontageGroupName = ""
        if IsValid(self.Mesh:GetAnimInstance()) and self.Mesh:GetAnimInstance().GetMontageSlotGroupName then
            MontageGroupName = self.Mesh:GetAnimInstance():GetMontageSlotGroupName(Montage)
        end
        if MontageGroupName ~= "" and self.ActionGroupProxy and self.ActionGroupProxy[MontagePath] == true then
            self.ActionGroupProxy[MontagePath] = nil
            DebugPrint("LHQ@@@@@PlayTalkAction:", MontagePath, "MontageGroupName:", MontageGroupName,  "UnitId:", self.UnitId)
            self:PlayTalkActionInternal(TalkActionData, OnFinished, CallbackObj, CallbackFuncName, IgnoreBlendInTime, MontageGroupName)
        else
            if (IsValid(CallbackObj) and CallbackFuncName) then
                CallbackObj[CallbackFuncName](CallbackObj)
                if self.ActionGroupProxy then
                    self.ActionGroupProxy[MontagePath] = nil
                end
            else
                StoryPlayableUtils:ExecuteStoryDelegate(OnFinished)
                if self.ActionGroupProxy then
                    self.ActionGroupProxy[MontagePath] = nil
                end
            end
        end

        self:AsyncLoadAndPlayTalkMontage(Paths, CurrentIndex + 1, TalkActionData, OnFinished, CallbackObj, CallbackFuncName, IgnoreBlendInTime)
    end})
end

function BP_CharacterBase_C:PlayTalkActionInternal(TalkActionData, OnFinished, CallbackObj, CallbackFuncName, IgnoreBlendInTime, MontageGroupName)
    if (TalkActionData == nil) then
		Utils.ScreenPrint("TalkActionData 不存在")
		if (IsValid(CallbackObj) and CallbackFuncName) then
            CallbackObj[CallbackFuncName](CallbackObj)
        else
            StoryPlayableUtils:ExecuteStoryDelegate(OnFinished)
        end
		return
	end

    local BlendInTime = TalkActionData.BlendInTime or 0.5
    if (IgnoreBlendInTime) then
        BlendInTime = 0
    end

    if MontageGroupName == Const.TalkActionMontageGroupName then
        self.CurrentTalkGroupMontageName = TalkActionData.AnimationId
    end

    local BlendOutTime = TalkActionData.BlendOutTime or 0.5
    local PrePath = TalkActionData.MontagePrePath or ""

	if (TalkActionData.EndLoopMontage) then
		local OnBlendOut = function()
			self:PlayTalkMontage(TalkActionData.EndLoopMontage, 0, BlendOutTime,
			                    TalkActionData.EndLoopMontageSection, nil, nil, TalkActionData.bUseIK, PrePath, MontageGroupName)
		end
        local OnCompleted = function()
			self.CurrentTalkGroupMontageName = nil
		end
		self:PlayTalkMontage(TalkActionData.ActionMontage, BlendInTime, BlendOutTime,
                            TalkActionData.MontageSection, OnBlendOut, OnCompleted, TalkActionData.bUseIK, PrePath, MontageGroupName)
        if (IsValid(CallbackObj) and CallbackFuncName) then
            CallbackObj[CallbackFuncName](CallbackObj)
        else
            StoryPlayableUtils:ExecuteStoryDelegate(OnFinished)
        end
	else
		local OnCompleted = function()
			if (TalkActionData.IsSpecialAnim) then
				if (IsValid(CallbackObj) and CallbackFuncName) then
                    CallbackObj[CallbackFuncName](CallbackObj)
                else
                    StoryPlayableUtils:ExecuteStoryDelegate(OnFinished)
                end
			end
		end
		self:PlayTalkMontage(TalkActionData.ActionMontage, BlendInTime, BlendOutTime,
                             TalkActionData.MontageSection, nil, OnCompleted, TalkActionData.bUseIK, PrePath, MontageGroupName)
        if (TalkActionData.IsSpecialAnim == false) then
            if (IsValid(CallbackObj) and CallbackFuncName) then
                CallbackObj[CallbackFuncName](CallbackObj)
            else
                StoryPlayableUtils:ExecuteStoryDelegate(OnFinished)
            end
        end
	end
end

function BP_CharacterBase_C:StopTalkAction(ActionId)
    local TalkActionData = DataMgr.TalkAction[ActionId]
	if TalkActionData == nil then
		return
	end

    local MontagePaths = {}
    if TalkActionData and TalkActionData.ActionMontage then
		table.insert(MontagePaths, self:GetTalkActionPath(TalkActionData.MontagePrePath, TalkActionData.ActionMontage))
	end
	if TalkActionData and TalkActionData.EndLoopMontage then
		table.insert(MontagePaths, self:GetTalkActionPath(TalkActionData.MontagePrePath, TalkActionData.EndLoopMontage))
	end

    for _, MontagePath in pairs(MontagePaths) do
        if self.ActionGroupProxy and self.ActionGroupProxy[MontagePath] then
            self.ActionGroupProxy[MontagePath] = nil
        end
        local Montage = LoadObject(MontagePath)
        if IsValid(self.Mesh:GetAnimInstance()) and self.Mesh:GetAnimInstance().GetMontageSlotGroupName then
            local MontageGroupName = self.Mesh:GetAnimInstance():GetMontageSlotGroupName(Montage)
            self.Mesh:GetAnimInstance():Montage_StopGroupByName(0, MontageGroupName)
        end
    end
end

function BP_CharacterBase_C:StopAllTalkAction()
    self.ActionGroupProxy = nil
    if IsValid(self.Mesh:GetAnimInstance()) then
        self.Mesh:GetAnimInstance():Montage_StopGroupByName(0, "TalkGroup")
        self.Mesh:GetAnimInstance():Montage_StopGroupByName(0, "HeadGroup")
        self.Mesh:GetAnimInstance():Montage_StopGroupByName(0, "DefaultGroup")
    end
end

function BP_CharacterBase_C:PlayTalkMontage(MontageName, BlendInTime, BlendOutTime, StartSec, OnBlendOut, OnCompleted, bUseIK, PrePath, SlotGroupName)
	local MontagePath = self:GetTalkActionPath(PrePath, MontageName)
	local Montage = LoadObject(MontagePath)
	if (Montage == nil) then
		Utils.ScreenPrint("蒙太奇路径不存在" .. MontagePath.."NPC:", self:GetName().."UnitId:", self.UnitId)
		if (OnCompleted) then
			OnCompleted()
		end
		return
	end
    if self:IsNPC() then
       
        if SlotGroupName == "TalkGroup" then
            self:ResetDynamicsWithCurrentMontageSection(MontageName, StartSec)
            self.CurrentAnimationMontageSectionName = MontageName
        end
	    self:SwitchEnableAnimInstanceIK(not bUseIK)
    else
	    self:SwitchEnableAnimInstanceIK(bUseIK)
    end
    
	UTalkFunctionLibrary.SetMontageBlendInTime(Montage, BlendInTime)
	UTalkFunctionLibrary.SetMontageBlendOutTime(Montage, BlendOutTime)
	local PlayParam = {
		StartSec = StartSec,
		OnBlendOut = OnBlendOut,
		OnCompleted = OnCompleted,
		ExcuteFnishOnlyWhenCompelete = true,
        MontageName = MontageName,
        MontageSlotGroupName = SlotGroupName
	}
	MiscUtils.PlayMontageBySkeletaMesh(self, self.Mesh, Montage, PlayParam)
    -- self:AddTimer(0.01, function()
    --     self.Mesh:ResetAnimInstanceDynamics(ETeleportType.ResetPhysics)
    -- end)
    -- self.Mesh:ResetAnimInstanceDynamics(ETeleportType.ResetPhysics)
end
--endregion UStoryPlayableInterface

---@param ActionName FName
---@return FString
function BP_CharacterBase_C:GetTalkActionPath(PrePath, ActionName)
    local MontagePath = ""
    if (ActionName == nil) then
        return MontagePath
    end
    
    local ModelId = self.ModelId
    if self:IsNPC() and DataMgr.Npc[self.UnitId] then
        ModelId = DataMgr.Npc[self.UnitId].ModelId
    end

    local ModelData = DataMgr.Model[ModelId]
    if ModelData == nil then
        ScreenPrint("Model数据为空, 获取动作路径失败, 请检查Model表, ModelId:" .. tostring(self.ModelId).." Obj:", self:GetName())
        return ""
    end

    if PrePath == nil or PrePath == "" then
	    return string.format("%sInteractive/%s%s_Montage", ModelData.MontageFolder, ModelData.MontagePrefix, ActionName)
    else
        return string.format("%s%s/%s%s_Montage", ModelData.MontageFolder, PrePath, ModelData.MontagePrefix, ActionName)
    end
end

function BP_CharacterBase_C:PlayOrStopEmoIdleMontage(IsPlay)
    if IsPlay then
        local ModelId = self:GetCharModelComponent():GetCurrentModelId()
        local ModelData = DataMgr.Model[ModelId]
        local RotateAnimPath = ModelData.MontageFolder or ""
        local Prefix = ModelData.MontagePrefix or ""
        Prefix = self:FormatPrefixWithMount(Prefix)
        local MontagePath = RotateAnimPath.."Interactive/"..Prefix.."Emo_Idle".."_Montage."..Prefix.."Emo_Idle".."_Montage"
        if MontagePath then
            UResourceLibrary.LoadObjectAsync(self, MontagePath, {self, function(_, Montage)
                local PlayParam = {
                }
                MiscUtils.PlayMontageBySkeletaMesh(self, self.Mesh, Montage, PlayParam)
            end})
        end
    else
        local AnimInstance = self.Mesh:GetAnimInstance()
        if AnimInstance then
            AnimInstance:Montage_StopGroupByName(0.5, Const.TalkActionMontageGroupName)
        end
    end
end

function BP_CharacterBase_C:SwitchEnableAnimInstanceIK(bEnable)
    local EMAnimInstance = self.EMAnimInstance
    if EMAnimInstance and EMAnimInstance.SwitchEnableAnimInstanceIK then
        EMAnimInstance:SwitchEnableAnimInstanceIK(bEnable) 
    end

    if self.NpcAnimInstance then
        self.NpcAnimInstance.EnableDataFootIK = bEnable
        DebugPrint("NPC Swich foot ik ", bEnable)
    end     
end

function BP_CharacterBase_C:GetHoldInput(HoldType)
    return self[HoldType]
end

-- 判断是否能进入交互状态
function BP_CharacterBase_C:CanEnterInteractive()
    if self.IsInAir then 
        return false 
    end
    
    if (self:CharacterInTag("Skill") or self:CharacterInTag("Shooting")) and self:IsSafeToCancelSkill() then 
        return self:CheckTagCanEnterTag("Idle", "Interactive")
    end

    if self:CheckCanEnterTag("Interactive") then 
        return true 
    end 

    return false
end

function BP_CharacterBase_C:StartDamageCounter()
    if self.IsCountingDamage then return end
    self:StopDamageCounter()
    Battle(self):RegisterBattleEvent(BattleEventName.Damaged, self, "CountDamageValue")
    self.DpsArr = {}
    self.DpsVal = 0
    self.TotalVal = 0
    self.IsCountingDamage = true


end

function BP_CharacterBase_C:CountDamageValue(TargetEffectSource, DamageEvent, Source, Target)
    local Value = DamageEvent:GetTrueValue()
    local CurTime = os.time()

    if not self.FirstDamageTime or CurTime - (self.LastDamageTime or CurTime) > 3 then
        self.DpsVal = Value
        self.TotalVal = Value
        self.FirstDamageTime = CurTime
    else
        local DmgTotalTime = CurTime - self.FirstDamageTime
        self.TotalVal = self.TotalVal + Value
        if DmgTotalTime >= 1 then 
            self.DpsVal = self.TotalVal / DmgTotalTime
        else
            self.DpsVal = self.TotalVal
        end
    end

    self.LastDamageTime = CurTime
end

function BP_CharacterBase_C:UpdateDamageValue()
    local LeftIndex = 0
    local CurTime = os.time()

    for i = 1, #self.DpsArr do 
        local DpsInfo = self.DpsArr[i]
        if CurTime - DpsInfo.Time > 1 then 
            self.DpsVal = self.DpsVal - DpsInfo.Value
            LeftIndex = i
        else break 
        end
    end

    if LeftIndex == #self.DpsArr then
        self.DpsArr = {}
    elseif LeftIndex > 0 then
        self.DpsArr = table.slice(self.DpsArr, LeftIndex + 1, #self.DpsArr)
    end

end

function BP_CharacterBase_C:StopDamageCounter()
    Battle(self):UnregisterBattleEvent(BattleEventName.Damaged, self, "CountDamageValue")
    self.DpsArr = nil 
    self.DpsVal = nil 
    self.IsCountingDamage = false
end

function BP_CharacterBase_C:GetMaxGatherTime_Lua()
    return Const.GatherMaxTime
end

----------------------------------------------------------------- 缓存池 ----------------------------------------------------------------
function BP_CharacterBase_C:GetConstStandAloneMonsterCanCache()
    return Const.StandAloneMonsterCanCache
end

function BP_CharacterBase_C:GetConstOnlineMonsterCanCache()
    return Const.OnlineMonsterCanCache
end

function BP_CharacterBase_C:IsPhantomDispatching(RoleId)
    DebugPrint("gmy@BP_PhantomCharacter_C BP_PhantomCharacter:IsPhantomDispatching", self.CurrentRoleId)

    local Avatar = GWorld:GetAvatar()
    if Avatar then
        for _, Dispatch in pairs(Avatar.Dispatches) do
            if Dispatch.DispatchCharsList:Length() > 0 then
                for Index, CharUuid in pairs(Dispatch.DispatchCharsList) do
                    local StrUuid = CommonUtils.ObjId2Str(CharUuid)
                    local CharId = self:GetCharIdByCharUuid(StrUuid)
                    DebugPrint("gmy@BP_CharacterBase_C BP_CharacterBase_C:IsPhantomDispatching Info:", Index, StrUuid,CharId)
                    
                    if CharId == RoleId then
                        return true
                    end
                end
            end
        end
    end
    return false
end


function BP_CharacterBase_C:GetCharIdByCharUuid(Uuid)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    for _, Char in pairs(Avatar.Chars) do
        if CommonUtils.ObjId2Str(Char.Uuid) == Uuid then
            return Char.CharId
        end
    end
end

function BP_CharacterBase_C:OnLeaveGesture01_Idle()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    
    DebugPrint("gmy@BP_CharacterBase_C BP_CharacterBase_C:OnLeaveGesture01_Idle", Avatar.IsInRegionOnline)
    
    local MainPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
    if MainPlayer and MainPlayer.Eid ~= self.Eid then
        return
    end

    if Avatar.IsInRegionOnline then
        Avatar:RequestCancelGestureOnline(self)
    end
    
    EventManager:FireEvent(EventID.RequestDeadRegionOnlineItem)--通知UI动作结束
    
    local GameState = UGameplayStatics.GetGameState(self)
    local AvatarEid = CommonUtils.ObjId2Str(Avatar.Eid)
    local UniqueIdList = GameState.PlayerRegionOnlineMechanismMap:Find(AvatarEid)
    if UniqueIdList then
        for i, v in pairs(UniqueIdList.Array) do
            Avatar:RequestDeadRegionOnlineItem(Avatar.CurrentOnlineType, Avatar.Eid, v)
        end
    end
end
----------------------------------------------------------------- 缓存池 ----------------------------------------------------------------

function BP_CharacterBase_C:CheckCanMountInCurrentRegion()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return true --拿不到Avatar时都认为可以上坐骑
    end
    if DataMgr.SubRegion[Avatar.CurrentRegionId] == nil then
        return false
    end
    local FlyLicense = DataMgr.SubRegion[Avatar.CurrentRegionId].FlyLicense
    if not FlyLicense or FlyLicense == -1 then
        return false
    else
        return true
    end
end

AssembleComponents(BP_CharacterBase_C)
return BP_CharacterBase_C
