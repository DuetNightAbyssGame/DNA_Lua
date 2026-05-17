--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "Unlua"

local BP_GuardMech_C = Class({"BluePrints/Item/DefenceCore/BP_DefenceBase_C"})

function BP_GuardMech_C:AuthorityInitInfo(Info)
    BP_GuardMech_C.Super.AuthorityInitInfo(self,Info)

    self.GameMode = UE4.UGameplayStatics.GetGameMode(self)
    self.GuideOrderIndex = self.GameMode:TriggerDungeonComponentFun("RegisterGuideOrder", self.CreatorId)  -- GuideOrderIndex 从1开始计数

    self.bGuardSuccess = false
    self.InteractiveType = Const.PressInteractive -- 长按维修用
    -- TestScene用
    -- self:AddTimer(1,function()
    --     self:ChangeState("Manual", 0,1310672)
    -- end)
    -- self:AddTimer(10,function()
    --     -- self.ChestInteractiveComponent.MontageName=nil
    --     -- self.ChestInteractiveComponent.InteractiveTag =nil
    --     self:ChangeState("Manual", 0,1310677)
    -- end)
end

function BP_GuardMech_C:CommonInitInfo(Info)
    BP_GuardMech_C.Super.CommonInitInfo(self, Info)
    self.MaxTime = self.UnitParams["MaxTime"]
    self.ReduceTime = self.UnitParams["ReduceTime"]
    self.CurHP = self:GetAttr("Hp")
    self.MaxHP = self:GetAttr("MaxHp")
    self.RepairSpeed = DataMgr.ExtractionTreasureGuard[self.UnitId].RepairSpeed
    self.RecoverHp = self.RepairSpeed * self.MaxHP
    -- self.ToastCD = DataMgr.GlobalConstant.SoloTreasureGuardToastCD.ConstantValue
    self.bCanShowBloodBar = false
    self.IsInInteractive = false
end

function BP_GuardMech_C:ClientInitInfo(Info)
    BP_GuardMech_C.Super.ClientInitInfo(self, Info)
    if self.Data.BloodUIParmas then

    end
end

function BP_GuardMech_C:ReceiveTick(DeltaSeconds)
    -- DebugPrint("yly     BP_GuardMech_C:ReceiveTick")
    self.Overridden.ReceiveTick(self, DeltaSeconds)
    self:ShowOrHideBloodBar(self.bCanShowBloodBar)
    -- self.ChestInteractiveComponent.bCanUsed = true
    local Hp = self:GetAttr("Hp")
    local MaxHp = self:GetAttr("MaxHp")
    -- DebugPrint("yly     BP_GuardMech_C:Hp = " .. Hp)
    -- DebugPrint("yly     BP_GuardMech_C:MaxHp = " .. MaxHp)
end

function BP_GuardMech_C:ShowOrHideBloodBar(bShow)
    if bShow then
        self:ShowOrHideBillboard(true)
    else
        self:ShowOrHideBillboard(false)
    end
end

--激活表现，IsActive变化说明要播放激活或停止激活时对应的特效
-- function BP_GuardMech_C:OnActiveStateChange()
--     BP_GuardMech_C.Super.OnActiveStateChange(self)
-- end

--激活表现，IsActive变化说明要播放激活或停止激活时对应的特效
function BP_GuardMech_C:OnActiveStateChange()
    BP_GuardMech_C.Super.OnActiveStateChange(self)
    if self.IsActive then
        local GameState = UE4.URuntimeCommonFunctionLibrary.GetCurrentGameState(self)
    end
end

function BP_GuardMech_C:OnActorReady(Info)
    BP_GuardMech_C.Super.OnActorReady(self, Info)
end

function BP_GuardMech_C:OnEnterState(NowStateId)
    self.Overridden.OnEnterState(self, NowStateId)
    if NowStateId == 1310674 then
        if self.IsInInteractive then
            self:CloseMechanism(self.NowPlayerEid)
        end
        self.bGuardSuccess = true
        self.bCanShowBloodBar = false
        self.InteractiveType = Const.ClickInteractive -- 点按打开容器用
        if self.ChestInteractiveComponent then
            self.ChestInteractiveComponent:InitInteractiveComponent(118020)
        end
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        GameState.DefBaseMap:Remove(self.Eid)
        GameState.HatredCombatProp:Remove(self.Eid)
    elseif NowStateId == 1310672 then
        self.bCanShowBloodBar = true
    elseif NowStateId == 1310675 then
        -- 移除指引
        self:RemoveGuideABC()
        -- 领取奖励
        if not self.ServerUniqueId then return end
        if not self.GameMode then
            self.GameMode = UE4.UGameplayStatics.GetGameMode(self)
        end
        if not self.GameMode then return end
        self.GameMode:NotifyServerDungeonEvent("OpenSoloTreasureMechanism", self.ServerUniqueId)
        -- todo: 补全打开逻辑
        UIManager(self):LoadUINew("SoloTreasureBag", self.ServerUniqueId, function()
            DebugPrint("lgc@ SoloTreasureBag AsyncLoaded self.ServerUniqueId =", self.ServerUniqueId)
        end, "Async")
    elseif NowStateId == 1310676 then
        self:RemoveGuideABC()
    elseif NowStateId == 1310677 then
        -- if self.IsInInteractive then
        --     -- self:CloseMechanism(self.NowPlayerEid)
        --     self.ChestInteractiveComponent:EndPressInteractive(Battle(self):GetEntity(self.NowPlayerEid))
        --     self.InteractiveType = Const.ClickInteractive -- 点按打开容器用
        -- end
        local PlayerActor = nil
        if self.NowPlayerEid then
            PlayerActor = Battle(self):GetEntity(self.NowPlayerEid)
        else
            PlayerActor = UGameplayStatics.GetPlayerCharacter(self, 0)
        end
        self.ChestInteractiveComponent:EndPressInteractive(PlayerActor)
        self.InteractiveType = Const.ClickInteractive -- 点按打开容器用
    end
end

function BP_GuardMech_C:OnDamaged(DamageEvent)
    if not IsAuthority(self) then
        return
    end
    BP_GuardMech_C.Super.OnDamaged(self, DamageEvent)

    -- Toast警告提示放在GameMode里处理
    -- toast警告提示
    -- if not self:IsExistTimer("TimerToastCoolDown") then
    --     GameState(self):ShowDungeonToast_Lua("UI_Extraction_TM_35", 2, EToastType.Warning)
    --     self:AddTimer(self.ToastCD + 2, function()
    --         DebugPrint("yly     ToastCoolDown Finished")
    --         self:RemoveTimer("TimerToastCoolDown")
    --     end, false, 0, "TimerToastCoolDown")
    -- end
    self.GameMode:TriggerDungeonComponentFun("OnShowToast", Const.DefenceGameToastType.Damaged)

    local MaxHP = self:GetAttr("MaxHp")
    local CurHP = self:GetAttr("Hp")
    self.CurHP = CurHP

    -- 通知UI刷新HP
    if not self:IsExistTimer("TimerNotifyDamaged") then
        local CurHPPercent = self.CurHP / self.MaxHP
        EventManager:FireEvent(EventID.OnContainerBeAttacked, self.CreatorId, CurHPPercent)
        self:AddTimer(0.5, function()
            DebugPrint("yly     TimerNotifyDamaged")
        end, false, 0, "TimerNotifyDamaged")
    end
end

-- 容器彻底损坏（血量降为0）
function BP_GuardMech_C:OnDead(KillMineRoleEid, KillMineSkillId, DeathReason)
    BP_GuardMech_C.Super.OnDead(self, KillMineRoleEid, KillMineSkillId, DeathReason)
    -- 血量为0，容器损坏不可开启，不可维修，弹警告toast提示
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    GameMode:TriggerMechanism(self.CreatorId, 1310676)
    -- GameState(self):ShowDungeonToast_Lua("UI_Extraction_TM_39", 2, EToastType.Warning)
    -- 容器死亡后销毁
    local function DelayDestroy()
        self:EMActorDestroy(EDestroyReason.MechanismDead)
    end
    self:AddTimer(0.1, DelayDestroy)
    -- 通知UI
    EventManager:FireEvent(EventID.OnContainerDestroyed, self.CreatorId)
end

function BP_GuardMech_C:OnEMActorDestroy(...)
    BP_GuardMech_C.Super.OnEMActorDestroy(self, ...)
end

function BP_GuardMech_C:ActiveOnServer()
    BP_GuardMech_C.Super.ActiveOnServer(self)
end

function BP_GuardMech_C:DeActive()
    BP_GuardMech_C.Super.DeActive(self)
end

-------- 长按交互 -----------
-- 长按触发所需时间
function BP_GuardMech_C:GetNeedLongPressTime()
    return self.MaxTime or 0
end

-- 获取已经长按的进度
function BP_GuardMech_C:GetLongPressedPercent()
    return self.CurPercent or 0
end

function BP_GuardMech_C:GetReduceTime()
	return self.ReduceTime or 0
end

-- 长按中交互选项文本
function BP_GuardMech_C:GetLongPressingText()
    return GText("UI_Extraction_TM_38") -- 维修中
end

function BP_GuardMech_C:OpenMechanism(Eid)
    DebugPrint("yly      BP_GuardMech_C:OpenMechanism")
    local Player = Battle(self):GetEntity(Eid)
    if Player then
        self.ChestInteractiveComponent:OnStartInteractive(Player, self.ChestInteractiveComponent.MontageName, self.Eid)
        -- self:SetActorTickEnabled(true)
        self.IsInInteractive = true
        self.NowPlayerEid = Eid
    end
    if not self:IsExistTimer("TimerAddHp") then
        self:AddTimer(1.0, self.TimerAddHp, true, 0, "TimerAddHp")
    end
end

function BP_GuardMech_C:CloseMechanism(Eid, IsSuccess)
    DebugPrint("yly      BP_GuardMech_C:CloseMechanism")
    local Player = Battle(self):GetEntity(Eid)
    if Player then
        Player.OnInteractiveDelegate:Add(self, self.ChangeToNormalState)
        self.ChestInteractiveComponent:OnEndInteractive(Player, self.ChestInteractiveComponent.MontageName, self.Eid)
        self.IsInInteractive = false
    end
    self:RemoveTimer("TimerAddHp")
end

function BP_GuardMech_C:TimerAddHp()
    if self.IsInInteractive then
        self:AddHp(self.RecoverHp)
        self.CurHP = self:GetAttr("Hp")
        local CurHPPercent = self.CurHP / self.MaxHP
        EventManager:FireEvent(EventID.OnContainerBeRepaired, self.CreatorId, CurHPPercent)
    end
end

function BP_GuardMech_C:ChangeToNormalState(Player)
    Player.OnInteractiveDelegate:Remove(self, self.ChangeToNormalState)
    self:ChangeState("InteractBreak", Player.Eid)
end

-- 确定何时可交互or不可交互
function BP_GuardMech_C:GetCanOpen(PlayerId)
    DebugPrint("yly      BP_GuardMech_C:GetCanOpen")
    if (not self.bGuardSuccess) and (self.CurHP >= self.MaxHP) then
        self.CanOpen = false
        return
    end
    if self.CurHP <= 0 then
        self.CanOpen = false
        return
    end
    self.CanOpen = true
end

function BP_GuardMech_C:RemoveGuideABC()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if GameState then
        GameState:RemoveGuideEid(self.Eid)
    end
end

return BP_GuardMech_C