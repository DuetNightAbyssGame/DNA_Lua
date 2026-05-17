local Component = {}

-- 掉落物处理 Start
--对于掉落物使用对玩家效果变化分为两个函数， 一个是改变玩家身上的值， 一个是改变GameState 上的值
function Component:PickupToRecoverSurvival(PickUpCount,UseFunctionParam)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    GameMode:TriggerDungeonComponentFun("AddSurvivalValue", UseFunctionParam * PickUpCount)
end
--拾取需要缓存结算的奖励
function Component:PickupToGetResource(PickUpCount, ResourceId, DropId, Transform, PickUpEid, bExtra)
    if not DataMgr.Resource[ResourceId]  then
        return
    end
    ---  触发生成资源  ---
    -- local Avatar = GWorld:GetAvatar()
    -- if Avatar then
    --     local ExtraInfo = {UniqueSign = PickUpEid, DropId = DropId, bExtra = bExtra}
    --     Avatar:DealWithResourceFromServer(DropId, ResourceId, CommonConst.RewardReason.PickUp, Transform, ExtraInfo,
    --     function()
    --         self:TriggerPickupSuccessCallback(DropId)
    --     end)
    -- end
    self:PickupTriggerRewardEvent(DropId, Transform, PickUpEid, bExtra, true)
end

function Component:PickupToRecoverHp(PickUpCount, UseFunctionParam, UnitId)
    local DeltaHp = self:_PickupToRecoverHp(PickUpCount, UseFunctionParam, UnitId)

    local PhantomTeammate = self:GetPhantomTeammates()
    for _, Target in pairs(PhantomTeammate) do
        if Target ~= self then
            Target:_PickupToRecoverHp(PickUpCount, UseFunctionParam, UnitId)
        end
    end
end

function Component:_PickupToRecoverHp(PickUpCount, UseFunctionParam, UnitId)
    if DataMgr.Drop[UnitId].IsPercentage == 1 then
        UseFunctionParam = self:GetAttr("MaxHp") * UseFunctionParam / 100
    end
    local DeltaHp = PickUpCount * UseFunctionParam
    self:AddHp(DeltaHp)
    return DeltaHp
end

function Component:PickupToRecoverSp(PickUpCount,UseFunctionParam)
    local DeltaSp = PickUpCount * UseFunctionParam
    self:_PickupToRecoverSp(DeltaSp)

    local PhantomTeammate = self:GetPhantomTeammates()
    for _, Target in pairs(PhantomTeammate) do
        if Target ~= self then
            Target:_PickupToRecoverSp(DeltaSp)
        end
    end
end

--已不再使用，拾取掉落物回蓝的reason由PickUpSp改为了FromSkillEffect
function Component:_PickupToRecoverSp(DeltaSp)
    Battle(self):AddSpToTarget(self, self, DeltaSp, EChangedSpReason.PickUpSp)
end

function Component:PickupToPickUpBattery(PickUpCount, UseFunctionParam)
    -- local LastBatteryNum = self.BatteryNum
    if self.BatteryNum >= Const.MaxBatteryOneChar then return end
    self.BatteryNum = self.BatteryNum + PickUpCount
    if self.BatteryNum >= Const.MaxBatteryOneChar then
        local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        GameMode:TriggerDungeonComponentFun("BatteryFull")
    end

    for i = 1, PickUpCount do
        Battle(self):AddBuffToTarget(self, self, Const.BarriyBuffId, -1)
    end
end

function Component:PickupToPickUpCrackKey(PickUpCount, UseFunctionParam)
    if self.CrackKeyNum >= Const.MaxCrackKeyOneChar then return end
    self.CrackKeyNum = self.CrackKeyNum + PickUpCount
    if self.CrackKeyNum >= Const.MaxCrackKeyOneChar then--TODO:显示指引
        -- local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        -- GameMode:TriggerDungeonComponentFun("CrackKeyFull")
    end

    for i = 1, PickUpCount do
        Battle(self):AddBuffToTarget(self, self, Const.CrackKeyBuffId, -1)
    end
end

function Component:PickupToRecoverAmmo(PickUpCount, UseFunctionParam)
    local Num = PickUpCount * UseFunctionParam
    local BulletNum = self:GetBulletNum()
    if not BulletNum then
        return
    end
    
    self:PickUpBullet(Num, EGetBulletReason.PickBullet)
    
    local PhantomTeammate = self:GetPhantomTeammates()
    for _, Target in pairs(PhantomTeammate) do
        if Target ~= self then
            Target:PickUpBullet(Num, EGetBulletReason.PickBullet)
        end
    end
end

function Component:PickupToGetMod(PickUpCount, ModId, UnitId, Transform, PickUpEid, bExtra)
    -- local Avatar = GWorld:GetAvatar()
    -- if Avatar then
    --     local ExtraInfo = {UniqueSign = PickUpEid, DropId = UnitId, bExtra = bExtra}
    --     Avatar:DealWithModFromServer(ModId,  CommonConst.RewardReason.PickUp, Transform, ExtraInfo,
    --     function()
    --         self:TriggerPickupSuccessCallback(UnitId)
    --     end)
    -- end
    self:PickupTriggerRewardEvent(UnitId, Transform, PickUpEid, bExtra, true)
end

function Component:PickupTriggerRewardEvent(UnitId, Transform, PickUpEid, bExtra, bNeedCallback)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local Pickup = GameMode.EMGameState.CombatItemMap:Find(PickUpEid)
    if not Pickup then
        return
    end
    local ExtraInfo = {UniqueSign = PickUpEid, DropId = UnitId, bExtra = bExtra, SourceEid = self.Eid, WorldRegionEid = Pickup.WorldRegionEid, RegionDataType = Pickup.RegionDataType, UniqueId = Pickup.ServerUniqueId}
    local Callback = bNeedCallback and function ()
        self:TriggerPickupSuccessCallback(UnitId)
    end
    if GameMode:CheckServerDungeonEnable() then
        GameMode:NotifyServerDungeonEventWithCallback(Callback, "TriggerPickupRewardEvent", UnitId, CommonConst.RewardReason.PickUp, ExtraInfo)
    else
        GameMode:TriggerRewardEvent(UnitId, CommonConst.RewardReason.PickUp, Transform, ExtraInfo, Callback)
    end
end

function Component:PickupToUseSkillEffect(PickUpCount, SkillId)
    self:_PickupToUseSkillEffect(SkillId)

    local PhantomTeammate = self:GetPhantomTeammates()
    for _, Target in pairs(PhantomTeammate) do
        if Target ~= self then
            Target:_PickupToUseSkillEffect(SkillId)
        end
    end
end

function Component:_PickupToUseSkillEffect(SkillId)
    -- PrintTable({_PickupToUseSkillEffect=SkillId, self=self})
    Battle(self):ExecuteSkillEffectWithType(self, SkillId, self)
end

function Component:TriggerPickupSuccessCallback(DropId)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not GameMode then return end
    local CallbackMap = GameMode.PickUpSuccessCallback
	if CallbackMap and CallbackMap[DropId] then
		for _,Callback in pairs(CallbackMap[DropId]) do
			Callback()
		end
	end
end

return Component