local Component = {}

function Component:ReceiveBeginPlay()
end

function Component:OnCharacterReady()    
    self.RecoverMontageName = "Interactive_01_Montage"
    
    -- self:AddDispatcher(EventID.CharDie,self,self.OnTeammateDie)
    -- self:AddDispatcher(EventID.CharRecover,self,self.OnTeammateRecovery)
end

-- function Component:OnTeammateDie(TargetEid)
--     self.Teammate = Battle(self):GetEntity(TargetEid)
--     if self.Eid ~= TargetEid and self:IsMainPlayer() then
--         if self.Teammate:IsPhantom() then
--             local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
--         elseif self.Teammate:IsPlayer() then 
--             -- UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, 'BATTLE_RECOVERY_TEAMMATEDEAD')
--             UIManager(self):ShowUITip(UIConst.Tip_CommonTop, string.format(GText("BATTLE_RECOVERY_TEAMMATEDEAD"), self.Teammate:GetNickName()))
--         end
--     end
-- end

-- function Component:OnTeammateRecovery(TargetEid)
--     self.Teammate = Battle(self):GetEntity(TargetEid)
--     if self.Eid == TargetEid and not self:IsMainPlayer() then 
--         if self.Teammate:IsPhantom() then 
--             -- UIManager(self):LoadUI(UIConst.COMMONSCREENTOAST, "CommonScreenToast", UIConst.ZORDER_FOR_COMMON_TIP, 'Phantom ' .. Tip, 1.5)
--             UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, 'BATTLE_RECOVERY_TEAMMATERECOVERY')
--         elseif self.Teammate:IsPlayer() then
--             local GameState = UE4.UGameplayStatics.GetGameState(self)
--             for key,value in pairs(GameState.PlayerArray) do
--                 if value == self.Teammate.PlayerState then
--                     -- UIManager(self):LoadUI(UIConst.COMMONSCREENTOAST, "CommonScreenToast", UIConst.ZORDER_FOR_COMMON_TIP, 'Player'..key..Tip, 1.5)
--                     UIManager(self):ShowUITip(UIConst.Tip_CommonTop, string.format(GText("BATTLE_RECOVERY_TEAMMATERECOVERY"), self.Teammate:GetNickName()))
--                 end
--             end
--         end
--     end
-- end

-- function Component:InitRecoveryData(GameMode)
--     self.CurRecoverySpeed = 0           -- 角色被复活的速度
--     self.RecoveryValue = 0              -- 角色被复活的进度百分比
--     self.bIsWaitingRecover = false      -- 角色是否在等待复活
--     self.bIsRealDead = false            -- 角色是否已经真正死亡
--     self.EnterDyingTimestamp = nil      -- 角色进入濒死状态的时间戳
--     self.DyingDuration = nil            -- 角色濒死持续时间， 在被复活时不会累计 
--     self.HaveDyingCountDown = self:CheckHaveDyingCountDown() 

--     self.RecoverMontageName = "Interactive_01_Montage"
--     self.RecovererList = {}

--     if self:IsPlayer() then 
--         self:InitPlayerRecoveryData()
--     elseif self:IsPhantom() then 
--         self:InitPhantomRecoveryData()
--     end
-- end 

-- function Component:InitPlayerRecoveryData()
--     local RecoveryData = DataMgr.PlayerRotationRates
--     self.PlayerRecoverySpeed = RecoveryData["RecoverySpeed"].ParamentValue[1] or 0
--     self.MaxRecoveringPlayer = RecoveryData["MaxRecoveringPlayer"].ParamentValue[1] or 0
--     self.MaxDyingTime = RecoveryData["MaxDyingTime"].ParamentValue[1] or 0
--     self.CanRecoveryDelayTime = RecoveryData["CanRecoveryDelayTime"].ParamentValue[1] or 0
-- end

-- function Component:InitPhantomRecoveryData()
--     self:InitPlayerRecoveryData()
--     if self.IsHostage then 
--         self.MaxDyingTime = 15  -- 人质的最大濒死时间，写死
--     end
-- end

-- function Component:ReceiveTick(DeltaSeconds)
--     if not self.InitSuccess then return end
--     if (not self.bIsWaitingRecover) then return end

--     if IsAuthority(self) then 
--         self:ServerTick(DeltaSeconds)
--     else 
--         self:ClientTick(DeltaSeconds)
--     end
-- end

function Component:UpdateRecoveryValue(DeltaSeconds)
    if self.CurRecoverySpeed > 0 then 
        self.RecoveryValue = math.min(self.RecoveryValue + self.CurRecoverySpeed * DeltaSeconds, Const.MaxRecoverValue)
    else
        self.RecoveryValue = 0
        if self.DyingDuration then 
            self.DyingDuration = self.DyingDuration + DeltaSeconds
        end
    end
end

-- function Component:ServerTick(DeltaSeconds)    
--     if self.DyingDuration and self.DyingDuration >= self.MaxDyingTime then 
--         self:TriggerRealDie()
--         return 
--     end 

--     if not self:IsRealDead() then 
--         self:UpdateRecoveryValue(DeltaSeconds)

--         -- DebugPrint("Tianyi@ Server Tick Value = " .. self.RecoveryValue .. " Eid = " .. self.Eid)
--         if self.RecoveryValue >= Const.MaxRecoverValue then
--             self:TryEnterRecovery()  
--         end
--     end
-- end

-- function Component:ClientTick(DeltaSeconds)
--     if self.DyingDuration and self.DyingDuration >= self.MaxDyingTime then 
--         self:TriggerRealDie() 
--         return 
--     end

--     if not self:IsRealDead() then 
--         self:UpdateRecoveryValue(DeltaSeconds)
--     end
-- end


-- 尝试进入濒死状态
-- function Component:TryEnterDying()
--     DebugPrint("Tianyi@ TryEnterDying, Eid = " .. self.Eid)
-- 	-- EventManager:FireEvent(EventID.ChangePhantomGuideState, "Dead", self.Eid)
--     self:AddTimer_Combat(self.CanRecoveryDelayTime or 1, self.RealEnterDying, false, 0, "RealEnterDyingTimer")
-- end

-- 进入濒死状态, Server&Client
-- function Component:RealEnterDying()
--     local CanRecovery = self:CheckCanRecovery()
--     if not CanRecovery and not self.HaveDyingCountDown then    -- 如果有濒死时间，在复活次数用完后要等倒计时
--         self:TriggerRealDie()
--         return 
--     end

--     -- 记录一个进入濒死状态的时间戳
--     self.bIsWaitingRecover = true
--     self.EnterDyingTimestamp = UE4.UGameplayStatics.GetRealTimeSeconds(self)

--     self.CurRecoverySpeed = 0
--     self.RecoveryValue = 0

--     if self.HaveDyingCountDown then 
--         self.DyingDuration = 0
--     end

--     self.RecovererList = {}
--     self:OnRealEnterDying() -- 通知一下角色，可以做额外逻辑了
-- end

-- 结束濒死状态，进入真正死亡
-- function Component:TriggerRealDie()
--     -- 如果是玩家，复活次数用完，进关卡结算
--     self:TryLeaveDying()
--     self:OnRealDie()
    -- if self:IsPlayer() then
        -- self:TryLeaveDying()
        -- DebugPrint("Tianyi@ Player real die, Eid = " .. self.Eid)
        -- if IsAuthority(self) then 
        --     local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        --     GameMode:TriggerPlayerFailed({self:GetController().AvatarId})
        -- end 

    -- 如果是魅影，在大世界走销毁逻辑，不然就躺在地上
    -- elseif self:IsPhantom() then 
        -- DebugPrint("Tianyi@ Phantom real die, Eid = " .. self.Eid)
        -- -- 服务端初始化复活次数
	    -- local Avatar = GWorld:GetAvatar()
        -- -- 魅影在区域中死亡后直接销毁
	    -- if Avatar and Avatar:IsRealInBigWorld() and not Avatar:IsInHardBoss() then 
        --     local DiscardPlayRate = 1
        --     self:PhantomDiscard(DiscardPlayRate, 0, false)
        --     if IsAuthority(self) then 
        --         self:AddTimer_Combat(0.4/DiscardPlayRate, function() self:EMActorDestroy(EDestroyReason.PhantomDieInRegion) end, false, 0, "DestroyPhantomTimer", false)
        --     end
        -- else 
        --     if IsAuthority(self) then 
        --         if self.IsHostage then -- 如果是人质死亡，通知一下GameMode
        --             local GameMode = UGameplayStatics.GetGameMode(self)      
        --             if GameMode then    
        --                 GameMode:TriggerDungeonComponentFun("OnHostageDie", self)
        --             end
        --         end
        --     end
        -- end
    -- end
    
--     self.bIsRealDead = true
-- end

-- 复活读秒完成，开始复活流程调用
function Component:TryEnterRecovery()
    local Reason = nil  -- 目前多人复活规则并没有定，所以复活理由只能有一个
    local Recoverer = nil 
    if self:IsPhantom() then -- 魅影默认可以自救
        Recoverer = self 
        Reason = UE4.ERecoverReason.RecoverReason_SelfRecover
    end

    -- 寻找除魅影自救以外的复活者
    for Id, RecoveryInfo in pairs(self.RecovererList) do 
        if self:IsPhantom() and Id == self.Eid then goto continue end 
        
        local _Recoverer = Battle(self):GetEntity(Id)
        if _Recoverer then                 
            Recoverer = _Recoverer
            Reason = RecoveryInfo.Reason
        end
        ::continue::
    end      

    if Recoverer and Reason then 
        Recoverer:OnRecoverOtherSuccess(self, Reason) 
        Battle(self):Recovery(self.Eid)
        self:OnRecoverSuccess(Reason) 
    end
end

-- 清空角色的复活者列表
function Component:ClearRecovererList()
    if self.RecovererList then 
        for Id, RecoveryInfo in pairs(self.RecovererList) do 
            local Recoverer = Battle(self):GetEntity(Id)
            if Recoverer then                 
                -- 维护一下救助者的救助对象列表
                self:RefreshRecovererInfo(Recoverer, nil)
                self:UnbindTeamRecoveryEffect(Id)
                self.RecovererList[Id] = nil
            end
        end   
    end

    self.RecovererList = {}
end

-- 离开濒死状态时调用
-- function Component:TryLeaveDying() 
--     DebugPrint("Tianyi@ Player Leave Dying, Eid = " .. self.Eid)
--     self:ClearRecovererList()
--     self:RemoveTimer("RealEnterDyingTimer")
--     self.bIsWaitingRecover = false
--     self.EnterDyingTimestamp = nil 
--     self.DyingDuration = nil
--     self.RecoveryValue = 0
--     self.CurRecoverySpeed = 0
--     EventManager:FireEvent(EventID.ChangePhantomGuideState, "Alive", self.Eid)
--     EventManager:FireEvent(EventID.ChangePhantomRecoverCount)
-- end

-- function Component:AddTeamRecovery(Recoverer, RecoverSpeed, Reason)
--     if self:CheckCanRecovery() then
--         self.RecovererList[Recoverer.Eid] = {
--             RecoverSpeed = RecoverSpeed, 
--             Reason = Reason
--         }

--         -- 维护一下救助者的救助对象列表
--         self:RefreshRecovererInfo(Recoverer, RecoverSpeed)
--         self:CalcRecoverySpeed()
--         -- DebugPrint("Tianyi@ AddTeamRecovery, RecoveerId = " .. Recoverer.Eid .. " Speed = " .. RecoverSpeed)     

--         if self.CurRecoverySpeed <= 0 then 
--             self:TryEnterRecovery()
--             return
--         end
--     end
-- end

-- function Component:RemoveTeamRecovery(Recoverer)
--     if self.RecovererList[Recoverer.Eid] then 
--         DebugPrint("Tianyi@ RemoveTeamRecovery, RecoveerId = " .. Recoverer.Eid .. " Speed = " .. self.RecovererList[Recoverer.Eid].RecoverSpeed)
--         self.CurRecoverySpeed = math.max(self.CurRecoverySpeed - self.RecovererList[Recoverer.Eid].RecoverSpeed, 0)
--         self:UnbindTeamRecoveryEffect(Recoverer.Eid)
--         self.RecovererList[Recoverer.Eid] = nil
        
--         -- 维护一下救助者的救助对象列表
--         self:RefreshRecovererInfo(Recoverer, nil)
--     end
-- end

function Component:BindTeamReocveryEffect(RecovererEid, EffectId) 
    if not (IsStandAlone(self) or IsClient(self)) then return end  
    if self.RecovererList[RecovererEid] then 
        self.RecovererList[RecovererEid].RecoveryEffectCreatureId = EffectId  
        self.RecovererList[RecovererEid].RecoveryEffectCreature = self:CreateEffectCreature(EffectId, FTransform(), true, "Root")
    end
end

function Component:UnbindTeamRecoveryEffect(RecovererEid)
    if not (IsStandAlone(self) or IsClient(self)) then return end  
    if self.RecovererList[RecovererEid] and self.RecovererList[RecovererEid].RecoveryEffectCreature then 
        local RecoveryEffectCreature = self.RecovererList[RecovererEid].RecoveryEffectCreature
        RecoveryEffectCreature:OnCharRecovery()
        self.RecovererList[RecovererEid].RecoveryEffectCreatureId = nil  
        self.RecovererList[RecovererEid].RecoveryEffectCreature = nil
    end
end

-- 真正死亡
-- function Component:IsRealDead()
--     -- return not self:CheckCanRecovery() and self:GetCharacterTag() == "Dead"
--     return self.bIsRealDead
-- end

-- 濒死， 还可以复活
-- function Component:IsNearDying()
--     return self:CheckCanRecovery() and self:GetCharacterTag() == "Dead"
-- end

-- 是否正在被复活
-- function Component:IsInRecovering()
--     return next(self.RecovererList) and self.CurRecoverySpeed > 0
-- end

-- 是否正在播放死亡蒙太奇
-- function Component:IsWaitingForRecover()
--     return self.bIsWaitingRecover
-- end

-- 是否正在被队友复活
-- function Component:IsRecoveredByOther(RecovererEid)
--     for Eid, _ in pairs(self.RecovererList) do
--         if RecovererEid and (Eid ~= self.Eid and Eid ~= RecovererEid) then 
--             return true
--         elseif not RecovererEid and (Eid ~= self.Eid) then 
--             return true
--         end 
--     end

--     return false
-- end

-- 是否正在自救
-- function Component:IsRecoveredBySelf()
--     return self.RecovererList and self.RecovererList[self.Eid]
-- end

-- 得到当前复活百分比
-- function Component:GetRecoveryPercent()
--     return self.RecoveryValue or 0
-- end

-- 如果有濒死计时，返回濒死剩余时间
-- function Component:GetDyingLeftTime()
--     if self.HaveDyingCountDown then 
--         return self.MaxDyingTime - self.DyingDuration
--     else
--         return nil
--     end
-- end


function Component:RefreshRecovererInfo(Recoverer, RecoverSpeed) 
    Recoverer.RecoverTargets = Recoverer.RecoverTargets or {}
    Recoverer.RecoverTargets[self.Eid] = RecoverSpeed

    if not next(Recoverer.RecoverTargets) then 
        DebugPrint("Tianyi@ 救助者: " .. Recoverer.Eid .. '不再救助对象')
        Recoverer.IsRecoveringOthers = false
    else 
        DebugPrint("Tianyi@ 救助者: " .. Recoverer.Eid .. '正在救助对象')
        Recoverer.IsRecoveringOthers = true
    end
end

function Component:CalcRecoverySpeed()
    local Speed = 0
    for _, RecoveryInfo in pairs(self.RecovererList) do 
        if RecoveryInfo.RecoverSpeed <= 0 then 
            self.CurRecoverySpeed = -1 
            return
        end
        Speed = Speed + RecoveryInfo.RecoverSpeed
    end

    self.CurRecoverySpeed = Speed
end

-- 判断自己能否复活目标
function Component:CheckCanRecoverOther(Target, Reason)
    if not Reason or Reason == UE4.ERecoverReason.RecoverReason_NoReason then 
        return true 
    end
    
    if Reason == UE4.ERecoverReason.RecoverReason_TeammateRecover then 
        local TargetCanRecover = Target:CheckCanRecovery()
        if Target:IsPlayer() then     -- 如果是玩家，只有在自救时，队友才能复活
            return (TargetCanRecover and Target:IsRecoveredBySelf() and not Target:IsRecoveringByOther(self.Eid))
        elseif Target:IsPhantom() then 
            return (TargetCanRecover and not Target:IsRecoveringByOther(self.Eid))
        end
    elseif Reason == UE4.ERecoverReason.RecoverReason_SkillEffect then 
        if not self:CheckCanSkillRecoverTarget(Target.Eid) then 
            DebugPrint("Tianyi@ Run out of SkillRecoverTargetCount") 
            return false 
        end
    end

    return true
end

-- 被成功复活时调用
function Component:OnRecoverSuccess(Reason)
    if Reason ~= UE4.ERecoverReason.RecoverReason_SkillEffect then    
        self:AddRecoveryCount(1)
    end
end

-- 参与复活其他单位成功时调用, 服务端客户端都会走
function Component:OnRecoverOtherSuccess(Target, Reason)
    DebugPrint("Tianyi@ " .. self:GetName() .. " 参与复活目标: " .. Target:GetName() .. " 成功, Reason = " .. Reason)
    if Reason == UE4.ERecoverReason.RecoverReason_SelfRecover then
    elseif Reason == UE4.ERecoverReason.RecoverReason_TeammateRecover then    
    elseif Reason == UE4.ERecoverReason.RecoverReason_SkillEffect then    
        self:AddSkillRecoverTarget(Target.Eid)
        DebugPrint("Tianyi@ Recover " .. Target:GetName() .. " Success! SkillRecoverTime was cost")
    end

    -- 服务端触发成就
    if IsStandAlone(self) or IsDedicatedServer(self) then
        local RootSource = self:GetRootSource()
        if IsValid(RootSource) and RootSource:IsPlayer() and Reason ~= UE4.ERecoverReason.RecoverReason_SelfRecover then 
            RootSource.BattleAchievement:OnRecoverTeammate(Target)
        end
    end
end

-- C++暴露接口部分
------------------------------- 

-- function Component:GetPlayerRecoverySpeed()
--     return self.PlayerRecoverySpeed
-- end

function Component:GetCanRecover(PlayerId)
    return self:CheckCanRecovery()
end

function Component:GetCurRecoveryUIName()
    local RespawnRuleName = self:GetCurRespawnRuleName()
    local RespawnRule = DataMgr.RespawnRule[RespawnRuleName]
    -- "None"不显示UI
    if RespawnRule and RespawnRule.RecoverUI and RespawnRule.RecoverUI == "None" then
        return nil
    end

    return RespawnRule and RespawnRule.RecoverUI or "BattleResurgence"
end

--客户端复活时的交互蒙太奇
function Component:ClientPlayAnimOnRecoverInteractive(TargetEid, RecoverInteractiveState)
    --TODO 特效没接
    if RecoverInteractiveState == 0 then
        -- self.DeadPlayer = Battle(self):GetEntity(TargetEid)
        --self.DeadPlayer = self.Owner
        --if not IsAuthority(self) or IsStandAlone(self) then
        --    self.PlayerFXObject = self.FXComponent:PlayEffectByIDParams(self.PlayerFXId)
        --    self.MonsterFXObject = self.DeadPlayer.FXComponent:PlayEffectByIDParams(self.MonsterFXId)
        --end
        -- self.RecoverInteractiveComponent:OnStartInteractive(self, self.RecoverMontageName)


        self.WaitCallBack = true
        self:SetEnterInteractive(true, self.RecoverMontageName, self.InteractiveTag)


        --self.RecoverInteractiveComponent:OnStartInteractive(Battle(self):GetEntity(TargetEid), self.RecoverMontageName)
    elseif RecoverInteractiveState == 2 then
        -- self.DeadPlayer = nil
        --if not IsAuthority(self) or IsStandAlone(self) then
        --    self.PlayerFXObject:K2_DestroyComponent(self)
        --    self.MonsterFXObject:K2_DestroyComponent(self)
        --end
        --self.RecoverInteractiveComponent:OnEndInteractive(Battle(self):GetEntity(TargetEid), self.RecoverMontageName)
        -- self.RecoverInteractiveComponent:OnEndInteractive(self, self.RecoverMontageName)

        self:SetEnterInteractive(false, self.RecoverMontageName)
    end
end

return Component