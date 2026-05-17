require "UnLua"
require "Utils"
require "DataMgr"
require "Const"
local GMVariable = require "BluePrints.UI.GMInterface.GMVariable"
local PickupUseComponent = {}
-- 这里注册拾取检测函数
-- PickupUseComponent["xxxx"](self, params)
function PickupUseComponent:BatteryExceedMaxDropNum(Owner)
	-- DebugPrint("ZJT_ 11111 BatteryExceedMaxDropNum ", Owner:GetName())
	if not (IsDedicatedServer(Owner) or IsStandAlone(Owner)) then
		return
	end
	local GameState = UE4.UGameplayStatics.GetGameState(Owner)
    if GameState ~= nil and GameState.BatteryToTalNum > 0 then
		GameState.BatteryToTalNum = GameState.BatteryToTalNum - 1
	end
end

function PickupUseComponent:PostInitBattery(Owner)
	-- DebugPrint("ZJT_ PostInitBattery ",Owner:GetName())
	if not (IsDedicatedServer(Owner) or IsStandAlone(Owner)) then
		return
	end
	local GameState = UE4.UGameplayStatics.GetGameState(Owner)
    if (GameState ~= nil) then
		GameState.BatteryToTalNum = GameState.BatteryToTalNum + 1
	end
end

--- 判断当前要拾取的掉落物是否满足条件，防止一次拾取很
--- 多个掉落物，效果却是只增加一次，因此每新增一个掉落物类型都需要添加其
--- 判断函数和拾取效果函数
function PickupUseComponent:CanBePickedUpHp(Character, Owner, ...)
	return Owner:HandleCombatConditionResult(Character, ...)
end

function PickupUseComponent:CalcPickUpHpUseParam(Character, Owner, ...)
	if DataMgr.Drop[Owner.UnitId].IsPercentage == 1 then
		Owner.UseParam = Owner.UseParam / 100  * Character:GetAttr("MaxHp")
	end
	return Owner.UseParam
end

function PickupUseComponent:CanBePickedUpGetResource(Character, Owner, ...)
	return Owner:HandleCombatConditionResult(Character, ...)
end

function PickupUseComponent:CanBePickedUpBattery(Character,Owner, ...)
	-- DebugPrint("ZJT_ CanBePickedUpBattery ",Owner:GetName())
	local Num = Character.BatteryNum
	local Result = true
	if not Num or Num >= Const.MaxBatteryOneChar then
		Result = false
	end
	return Owner:HandleCombatConditionResult(Character, ...) and Result
end

function PickupUseComponent:CanBePickedUpCrackKey(Character,Owner, ...)
	local Num = Character.CrackKeyNum
	local Result = true
	if not Num or Num >= Const.MaxCrackKeyOneChar then
		Result = false
	end
	return Owner:HandleCombatConditionResult(Character, ...) and Result
end

function PickupUseComponent:CanBePickedUpSp(Character, Owner, ...)
	return Owner:HandleCombatConditionResult(Character, ...)
end

function PickupUseComponent:CanBePickedUpAmmo(Character, Owner, ...)
	-- local Res, Tag = Owner:IsCanCombatCondition(Character, ...)
	-- Owner:JumpEffect(Res)
	-- return Res
	return Owner:HandleCombatConditionResult(Character)
end

function PickupUseComponent:CanBePickedUpGetMod(Character, Owner, ...)
	return Owner:HandleCombatConditionResult(Character, ...)
end
function PickupUseComponent:CanBePickedUpGetWeapon(Character, Owner, ...)
	return Owner:HandleCombatConditionResult(Character, ...)
end
function PickupUseComponent:CanBePickedUpReward(Character, Owner, ...)
	return Owner:HandleCombatConditionResult(Character, ...)
end
function PickupUseComponent:CanBePickedUpSurvival(Character, Owner, ...)
	return Owner:HandleCombatConditionResult(Character, ...)
end


function PickupUseComponent:RecoverHp(Character, Owner)
	if Character:IsDead() then
		return
	end
	if type(Owner.UseParam) == "number" then
		self:HandleRealPickupUseEffect(Character, Owner)
		if GMVariable.EnableShowBillboard then
			Character.JumpWordComponent:TryToShowJumpWord(UE4.FVector(0, 0, 0), nil, "Cure", Owner.UseParam, 0, Character.Eid, "", TArray(FName), TMap(FName, FRateStructFowShow))
		end
	end
end

function PickupUseComponent:RecoverSp(Character, Owner)
	if Character:IsDead() then
		return
	end
	if type(Owner.UseParam) == "number" then
		self:HandleRealPickupUseEffect(Character, Owner)
	end
end

function PickupUseComponent:HandleRealPickupUseEffect(Character, Owner)
	local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(Character, 0)
	if PlayerCharacter:IsRobot() then
		return
	end
	PlayerCharacter:RealPickupUseEffect(Character.Eid, Owner.UnitId, 1, Owner:GetTransform(), Owner.Eid, Owner.bExtra)
end

function PickupUseComponent:RecoverAmmo(Character, Owner)
	if Character:IsDead() then
		return
	end
	if type(Owner.UseParam) == "number" then
		self:HandleRealPickupUseEffect(Character, Owner)
	end
end

function PickupUseComponent:GetResource(Character, Owner)
	if Character:IsDead() then
		return
	end
	if not DataMgr.Resource[Owner.UseParam] then
		return
	end
	self:HandleRealPickupUseEffect(Character, Owner)
end

function PickupUseComponent:GetReward(Character, Owner)
	if Character:IsDead() then
		return
	end
	self:HandleRealPickupUseEffect(Character, Owner)
end

function PickupUseComponent:GetMod(Character, Owner)
	if Character:IsDead() then
		return
	end
	self:HandleRealPickupUseEffect(Character, Owner)
end

function PickupUseComponent:GetWeapon(Character, Owner) 
	if Character:IsDead() then
		return
	end
	self:HandleRealPickupUseEffect(Character, Owner)
end

function PickupUseComponent:RecoverSurvival(Character, Owner)
	self:HandleRealPickupUseEffect(Character, Owner)
end

function PickupUseComponent:PickUpBattery(Character, Owner)
	self:HandleRealPickupUseEffect(Character, Owner)
end

function PickupUseComponent:PickUpCrackKey(Character, Owner)
	self:HandleRealPickupUseEffect(Character, Owner)
end

function PickupUseComponent:CanBePickedUpExcavationItem(Character, Owner, ...)
	-- DebugPrint("ZJT_ CanBePickedUpExcavationItem ", Owner:GetName())
	return Owner:HandleCombatConditionResult(Character, ...)
end


function PickupUseComponent:PickUpExcavationItem(Character, Owner)
	self:HandleRealPickupUseEffect(Character, Owner)
end

function PickupUseComponent.GetExcavationItemCount(ItemId)
	local DropData = DataMgr.Drop[ItemId]
	if not DropData then
		return nil
	end
	return DropData.UseParam
end

-- function PickupUseComponent:IsCanCombatCondition(Character, Owner, ...)
-- 	local ConditionId = DataMgr.Drop[Owner.UnitId].CombatConditionId
-- 	local Tag
-- 	if DataMgr.Drop[Owner.UnitId].Tag then
-- 		Tag = DataMgr.Drop[Owner.UnitId].Tag[#DataMgr.Drop[Owner.UnitId].Tag]
-- 	end
-- 	if not ConditionId then
-- 		return true, Tag
-- 	end
-- 	return Battle(Character):CheckConditionNew(ConditionId, Character), Tag
-- end


function PickupUseComponent:CanBePickedUpUseSkillEffect(Character, Owner, ...)
	return Owner:HandleCombatConditionResult(Character, ...)
end

function PickupUseComponent:TempleAddScore(Character,Owner)
	local GameMode = UE4.UGameplayStatics.GetGameMode(Owner)
	local DropData = DataMgr.Drop[Owner.UnitId]
	if GameMode and DropData and DropData.UseParam then
		GameMode:TriggerDungeonComponentFun("AddToScore",DropData.UseParam)
	end
	return true
end

function PickupUseComponent:CanBePickedUpTempleAddScore(Character,Owner)
	local GameState = UGameplayStatics.GetGameState(Character)
	return GameState and GameState.GameModeType == 'Temple'
end

-- function PickupUseComponent:JumpEffect(Res, Owner)
-- 	if not Res and not Owner.IsJumping and Owner.ProjectileMovementComponent.Velocity == FVector(0,0,0) then
-- 		Owner.ProjectileMovementComponent.InitialSpeed = 100.0
-- 		Owner.ProjectileMovementComponent.MaxSpeed = 1000.0
-- 		Owner.ProjectileMovementComponent.Velocity = Owner:GetActorUpVector()  * 300
-- 		Owner.ProjectileMovementComponent.bRotationFollowsVelocity = false
-- 		Owner.ProjectileMovementComponent:SetUpdatedComponent(Owner.SphereComponent)
-- 		Owner.ProjectileMovementComponent:Activate(true)
-- 		Owner.IsJumping = true
-- 	end
-- end

-- function PickupUseComponent:HandleCombatConditionResult(Character, Owner, ...)
-- 	local Res, Tag = Owner:IsCanCombatCondition(Character, ...)
-- 	if Character:IsMainPlayer() then
-- 		self:JumpEffect(Res, Owner)
-- 	end
-- 	return Res
-- end

function PickupUseComponent:UseSkillEffect(Character, Owner)
	if Character:IsDead() then return end
	self:HandleRealPickupUseEffect(Character, Owner)
end

-- 这里注册拾取使用函数
PickupUseComponent.CanBePickedUpFuncMap = {
	["RecoverHp"] = PickupUseComponent.CanBePickedUpHp,
	["RecoverSp"] = PickupUseComponent.CanBePickedUpSp,
	["RecoverAmmo"] = PickupUseComponent.CanBePickedUpAmmo,
	["GetReward"] = PickupUseComponent.CanBePickedUpReward,
	["RecoverSurvival"] = PickupUseComponent.CanBePickedUpSurvival,
	["PickUpBattery"] = PickupUseComponent.CanBePickedUpBattery,
	["PickUpCrackKey"] = PickupUseComponent.CanBePickedUpCrackKey,
	["GetMod"] = PickupUseComponent.CanBePickedUpGetMod,
	["GetWeapon"] = PickupUseComponent.CanBePickedUpGetWeapon,
	["PickUpExcavationItem"] = PickupUseComponent.CanBePickedUpExcavationItem,
	["GetResource"] = PickupUseComponent.CanBePickedUpGetResource,
	["UseSkillEffect"] = PickupUseComponent.CanBePickedUpUseSkillEffect,
	["TempleAddScore"] = PickupUseComponent.CanBePickedUpTempleAddScore,
}
 -- 初始化某个物品拾取效果函数
PickupUseComponent.UseEffectTypeFuncMap = {
	["RecoverHp"] = PickupUseComponent.RecoverHp,
	["RecoverSp"] = PickupUseComponent.RecoverSp,
	["RecoverAmmo"] = PickupUseComponent.RecoverAmmo,
	["GetReward"] = PickupUseComponent.GetReward,
	["RecoverSurvival"] = PickupUseComponent.RecoverSurvival,
	["PickUpBattery"] = PickupUseComponent.PickUpBattery,
	["PickUpCrackKey"] = PickupUseComponent.PickUpCrackKey,
	["PickUpExcavationItem"] = PickupUseComponent.PickUpExcavationItem,
	["GetMod"] = PickupUseComponent.GetMod,
	["GetWeapon"] = PickupUseComponent.GetWeapon,
	["GetResource"] = PickupUseComponent.GetResource,
	["UseSkillEffect"] = PickupUseComponent.UseSkillEffect,
	["TempleAddScore"] = PickupUseComponent.TempleAddScore,
}

-------------- 计算使用效果 -------------
PickupUseComponent.CalcUseEffectTypeFuncMap = {
	["RecoverHp"] = PickupUseComponent.CalcPickUpHpUseParam,
}

-- 初始化完成后调用
PickupUseComponent.PostInitFuncMap = {
	["PickUpBattery"] = PickupUseComponent.PostInitBattery,
}
-- 因为超出最大数量而被销毁时调用
PickupUseComponent.ExceedMaxDropNumFuncMap = {
	["PickUpBattery"] = PickupUseComponent.BatteryExceedMaxDropNum,
}
-- 客户端获取物品数量
PickupUseComponent.ClientGetItemCountFuncMap = {
	["PickUpExcavationItem"] = PickupUseComponent.GetExcavationItemCount,
}

-- 客户端获取对应武器ID
PickupUseComponent.ClientGetWeaponId = {
	["GetWeaponId"] = PickupUseComponent.GetExcavationItemCount,
}
----------  拾取使用效果函数结束  --------
return PickupUseComponent