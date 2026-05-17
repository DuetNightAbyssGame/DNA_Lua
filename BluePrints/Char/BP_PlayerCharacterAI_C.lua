local EffectResults = require "BluePrints.Combat.BattleLogic.EffectResults"
require "UnLua"

---@class BP_PlayerCharacterAI_C : BP_CharacterBase_C
local BP_PlayerCharacterAI_C = Class({
	"BluePrints.Char.BP_MonsterCharacter_C",
	"BluePrints.Char.CharacterComponent.PlayerCommonInterface",
})

BP_PlayerCharacterAI_C._components = {
    "BluePrints.Char.CharacterComponent.PickupComponent",
    "BluePrints.Char.CharacterComponent.CharacterPickupUseComponent",
    "BluePrints.Char.CharacterComponent.TeamRecoveryComponent",

    -- "BluePrints.Char.CharacterComponent.CameraComponent",
    "BluePrints.Char.CharacterComponent.CamPostProcessMgrComponent",
    "BluePrints.Char.CharacterComponent.AttackInputComponent",
}

-- function BP_PlayerCharacterAI_C:ReceiveBeginPlay()
--     self.Super.ReceiveBeginPlay(self)
-- end

function BP_PlayerCharacterAI_C:Initialize(Initializer)
    BP_PlayerCharacterAI_C.Super.Initialize(self)
    local GameMode = GWorld.GameInstance:GetCurrentGameMode()
    if GameMode.IsAutoBattle then
        print(_G.LogTag,"PlayerCharacterAI Initialize")
    end
    self:InitActionLogicParamas()
end

function BP_PlayerCharacterAI_C:GetDataInfo(RoleId)
    if not RoleId or RoleId == 0 then
        return
    end
    return DataMgr.BattleChar[RoleId]
end

function BP_PlayerCharacterAI_C:PreInitInfo(Info)
    BP_PlayerCharacterAI_C.Super.PreInitInfo(self, Info)
    Info.BT = DataMgr.BattleChar[Info.RoleId].AIBTPath
end

function BP_PlayerCharacterAI_C:AuthorityInitInfo(Info)
    BP_PlayerCharacterAI_C.Super.AuthorityInitInfo(self, Info)
    self:ChangeOwner(self)
end

function BP_PlayerCharacterAI_C:CommonInitInfo(Info)
    BP_PlayerCharacterAI_C.Super.CommonInitInfo(self, Info)
end

function BP_PlayerCharacterAI_C:ClientInitInfo(Info)
    BP_PlayerCharacterAI_C.Super.ClientInitInfo(self, Info)
end

-- function BP_PlayerCharacterAI_C:ReceiveTick(DeltaSeconds)
--     if not self.InitSuccess then
--         return
--     end
--     -- BP_PlayerCharacterAI_C.Super.ReceiveTick(self, DeltaSeconds)
--     -- CallOverridden(self, DeltaSeconds)
--     -- self:StopDodgeWhenTimeOver()
--     -- self:ProcessJumpActionInTick(DeltaSeconds)
-- end

-- function BP_PlayerCharacterAI_C:GetObjType()
--     return EObjType.RobotCharacter
-- end

function BP_PlayerCharacterAI_C:CheckCanPart()
    return true
end

-- function BP_PlayerCharacterAI_C:ServerDoJump(_JumpStage)
--     if (not IsAuthority(self)) then 
--         return  false
--     end
--     if not self:CheckJumpKeyValide()then
--         return false
--     end
--     if self.ClimbMont then 
--         return  false
--     end
--     local TempJumpInfo = EffectResults.Result()
    
--     local JumpStage = _JumpStage

--     if not JumpStage or JumpStage == 0 then 
--         JumpStage = self:CheckJumpStage(TempJumpInfo)
--     end

--     -- if JumpStage == Const.BulletJump then 
--     --     JumpStage = nil 
--     -- end
--     JumpStage = self:CheckBuffForbidenJump(JumpStage)
--     if JumpStage == nil then
--         return false
--     end
--     if JumpStage == Const.BulletJump then
--         if self:CheckSkillInActive(ESkillName.BulletJump) then
--             return false
--         end
--         local CurrentJumpState = self.PlayerAnimInstance.CurrentJumpState
--         local IsMoveOnGround = not self.IsInAir
--         local EnterBulletJumpStage = self:CheckBulletJumpCondition(CurrentJumpState, IsMoveOnGround)
--         if not EnterBulletJumpStage then
--             return false
--         end
--     end
--     local JumpResult = TempJumpInfo:ToEffectStruct()
--     self:ClientJump(JumpStage, JumpResult)
--     return true
-- end

function BP_PlayerCharacterAI_C:CheckJumpStage()
    local CurrentJumpState = self.EMAnimInstance.CurrentJumpState
    local IsMoveOnGround = not self.IsInAir
    local EnterFirstJumpStage = self:CheckFirstJumpCondition(CurrentJumpState, IsMoveOnGround)
    if EnterFirstJumpStage then
        return Const.FirstJump
    end
    local EnterSecondJumpStage = self:CheckSecondJumpCondition(CurrentJumpState, IsMoveOnGround)
    if EnterSecondJumpStage then
        return Const.SecondJump
    end
    return nil
end

function BP_PlayerCharacterAI_C:OnJumpStageChaned(JumpStage)
    if JumpStage == Const.BulletJump then 
        self.BulletJumpCount = self.BulletJumpCount + 1
        self:RealStopSlide(false)
    end
    if self:CharacterInTag("Avoid") then 
        self:StopDodge()
    end

    if self.SlideTime ~= -1 then 
        self.SlideTime = -1 
    end
    self:SetCrouch(false)
    self:SetHoldCrouch(false)
end

-- function BP_PlayerCharacterAI_C:PhantomDodge()
--     if self:CheckSkillInActive(UE4.ESkillName.Avoid) then
--         return false
--     end
--     if not self:CheckCanAvoid()then
--         return false
--     end
--     if self:ReachMaxAvoidTimes() then
--         return false
--     end
--     self:DoDodge()
--     return true
-- end

function BP_PlayerCharacterAI_C:Recovery()
    BP_PlayerCharacterAI_C.Super.Recovery(self)
    -- 退出濒死状态
    self:TryLeaveDying() 
    if IsClient(self) or IsStandAlone(self) then
        self:UseSkill(Const.PlayerRecoverySkill, 0)
    end
end

--function BP_PlayerCharacterAI_C:OnDead(KillMineRoleEid, KillMineSkillId, DeathReason)
--    DebugPrint("Tianyi@ BP_PlayerCharacterAI_C:OnDead")
--
--    -- 魅影并不希望走怪的Ondead，所以直接调CharacterBase的OnDead
--    BP_PlayerCharacterAI_C.Super.Super.OnDead(self, KillMineRoleEid, KillMineSkillId, DeathReason)
--    
--    self:ResetCapSize()
--    self:TryEnterDying()
--    self:StopFire(false, false)
--    self:ShouldEnableHandIk()
--    if (self.BillboardComponent ~= nil) then
--        self.BillboardComponent:CharOnDead()
--    end
--end

-- function BP_PlayerCharacterAI_C:CheckCanRecovery()
--     return true
-- end

function BP_PlayerCharacterAI_C:PhantomBulletJump(Forward)
    self.BulletForward = FVector(Forward.X, Forward.Y, Forward.Z)
    return self:ServerDoJump(Const.BulletJump)
end

function BP_PlayerCharacterAI_C:GetBulletJumpForwardVector()
    if not self.BulletForward then 
        return self:GetActorForwardVector(), self:GetActorRightVector(), self:K2_GetActorRotation()
    end

    local Rotation = self.BulletForward:ToRotator()
    local RightVector = UE4.UKismetMathLibrary.GetRightVector(Rotation)
    return self.BulletForward, RightVector, Rotation
end

function BP_PlayerCharacterAI_C:GetSafeRegionLocation(EnterLocation)
	local Info = {}
    local Avatar = GWorld:GetAvatar()
    local CheckLocation = EnterLocation or self:GetLastSafeLocation()
	if CheckLocation ~= FVector(0,0,0) and self:GetRegionId(CheckLocation) == Avatar.CurrentRegionId then
		Info.RegionId = Avatar.CurrentRegionId
        Info.Location = CheckLocation
		Info.Rotation = self:K2_GetActorRotation()
    else
        Info.RegionId = Avatar:GetLastRegionId()
        Info.Location = Avatar.LastRegionData:GetLocation()
        Info.Rotation = Avatar.LastRegionData:GetRotation()
	end
    DebugPrint("ZJT_ PlayerSyncLocation ", EnterLocation, Info.Location, Info.RegionId, Avatar.CurrentRegionId)
	return Info
end


AssembleComponents(BP_PlayerCharacterAI_C, {"CheckJumpStage","OnJumpStageChaned","GetBulletJumpForwardVector"})
return BP_PlayerCharacterAI_C

