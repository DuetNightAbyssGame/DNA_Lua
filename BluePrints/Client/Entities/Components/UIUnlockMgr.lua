-- UI解锁管理组件
-- 提供接口见@1,@2,@3
local Component = {}

function Component:EnterWorld()
    if not self.bUIUnlockMgrInitialized then
        self:Init()
    end
end

function Component:Init()
    self.bUIUnlockMgrInitialized = true
    self.bEndNormalUnlockUITask=true
    self.ConditionFirstMetEvents = {}
    self.ConditionMetCache = {}
    self.FirstTimeUnlockUIQueue = {}
    self.FirstTimeUnlockSubUIQueue={}
    self.CacheUnlockRuleIdsArray = TSet("") -- 一次解锁队列时缓存的解锁ID，并不是全部已解锁ID的缓存，已解锁的缓存见self.ConditionMetCache
    self.HasBindUIUnlockRules = {}
    self.BindUIUnlockKeys = {}

    self.bInRegion_UIUnlock = false
    self.bInLoading_UIUnlock = false
    self.bInDeliverBlack_UIUnlock = false
    self.bInImmersiveTalk_UIUnlock = false
    self.bCrackUnlockAllSystems = false
    self.bGMHideUnlockPopup = false
    self.CrackedUnlockSystems = {}
    self.DelegateKey_UIUnlock = 0

    -- self:InitUIUnlockInfos()
    self:BindUIUnlockDelegates()
    self:AddListenEvents()
end

function Component:LeaveWorld()
	self.logger.info("UIUnlockMgr LeaveWorld")
    EventManager:RemoveEvent(EventID.EnterRegion, self)
    EventManager:RemoveEvent(EventID.ExitRegion, self)
    EventManager:RemoveEvent(EventID.InLoading, self)
    ---交给AfterLoadingMgr驱动
	--EventManager:RemoveEvent(EventID.CloseLoading, self)
    EventManager:RemoveEvent(EventID.OnLoginSuccess, self)
    EventManager:RemoveEvent(EventID.OnLevelDeliverBlackCurtainStart, self)
    EventManager:RemoveEvent(EventID.OnLevelDeliverBlackCurtainEnd, self)
    EventManager:RemoveEvent(EventID.EnterImmersiveTalk, self)
    EventManager:RemoveEvent(EventID.LeaveImmersiveTalk, self)
    self:UnBindAllOnUIFirstUnlockAnimation()
end

-- function Component:InitUIUnlockInfos()
--      DataMgr.UIUnlockRule = DataMgr.UIUnlockRule

--     if not  DataMgr.UIUnlockRule then
--         DebugPrint("@@@ UIUnlockMgr load UIUnlockRule failed")
--     end
-- end

-- 对外提供的接口@1，用于订阅UI首次解锁的通知。
-- 调用此接口会在UIUnlockRuledId对应的解锁条件满足时回调Callback
-- Callback无需形参
-- 返回Key，类型为int, 用于UnBind
function Component:BindOnUIFirstTimeUnlock(UIUnlockRuleId, Callback)
    local UnlockInfo = DataMgr.UIUnlockRule[UIUnlockRuleId]
    local ConditionId = UnlockInfo.ConditionId

    self.ConditionFirstMetEvents[ConditionId] = self.ConditionFirstMetEvents[ConditionId] or {}
    local Events = self.ConditionFirstMetEvents[ConditionId]
    self.DelegateKey_UIUnlock = self.DelegateKey_UIUnlock + 1
    Events[self.DelegateKey_UIUnlock] = Callback

    return self.DelegateKey_UIUnlock 
end

-- 与接口@1对应，用于UnBind，请传入Bind时返回的key
function Component:UnBindOnUIFirstTimeUnlock(UIUnlockRuleId, Key)
    local UnlockInfo = DataMgr.UIUnlockRule[UIUnlockRuleId]
    local ConditionId = UnlockInfo.ConditionId
    self.ConditionFirstMetEvents[ConditionId] = self.ConditionFirstMetEvents[ConditionId] or {}
    local Events = self.ConditionFirstMetEvents[ConditionId]
    Events[Key] = nil
end

-- 对外提供的接口@2，用于查询UIUnlockRuleId对应的ConditionId是否满足
-- 提供的Callback应有一个形参，类型为bool,表示解锁结果, true对应已解锁, false对应未解锁
-- 解锁条件可参考UIUnlockRule表
function Component:CheckUIUnlocked(UIUnlockRuleId, bShowFailed)
    if not UIUnlockRuleId then return true end --条件id都没有，每条件应该是true
    if self.bCrackUnlockAllSystems then
        return true
    elseif self.CrackedUnlockSystems[UIUnlockRuleId] then 
        return true
    end
    return self:CheckUIUnlocked_Internal(UIUnlockRuleId, bShowFailed)
end

-- 对外提供的接口@3，用于查询UIUnlockRuleId对应的OpenConditionId是否满足
-- 解锁条件可参考UIUnlockRule表
function Component:CheckSystemUICanOpen(UIUnlockRuleId)
    local UIUnlockInfo =  DataMgr.UIUnlockRule[UIUnlockRuleId]
    local FailedIdIndex={}
    if (not UIUnlockInfo or UIUnlockInfo.OpenConditionId == nil) then
        return true
    end

    local Avatar, UIOpenConditionId = GWorld:GetAvatar(), UIUnlockInfo.OpenConditionId
    for Index, Id in pairs(UIOpenConditionId) do
        if not ConditionUtils.CheckCondition(Avatar, Id) then
            table.insert(FailedIdIndex,Index) 
        end
    end
    return #FailedIdIndex==0,FailedIdIndex
end

function Component:CheckUIUnlocked_Internal(UIUnlockRuleId,bShowFailed)
    local UIUnlockInfo =  DataMgr.UIUnlockRule[UIUnlockRuleId]
    -- 若该规则不在表中，视为满足规则。
    if not UIUnlockInfo then
        GWorld.logger.error("@@@ 所查询解锁的UIUnlockRuleId不在表内:" .. tostring(UIUnlockRuleId))
        return false
    end

    --默认不显示
    bShowFailed = bShowFailed or false
    local Res = self:CheckSystemUnlocked(UIUnlockRuleId)
    if not Res then
        ConditionUtils:CheckShowFailed(UIUnlockInfo.ConditionId,false,bShowFailed)
    end
    return Res
end

-- 对外提供的接口@3，提供系统通用解锁表现,目前仅包含播放系统解锁动效逻辑
function Component:OnSystemFirstTimeUnlock(UIUnlockRuleId)
    local SystemInfo =  DataMgr.UIUnlockRule[UIUnlockRuleId]
    if SystemInfo.UnlockPopupType=="Light" then
        table.insert(self.FirstTimeUnlockSubUIQueue,UIUnlockRuleId)
    else
        table.insert(self.FirstTimeUnlockUIQueue,UIUnlockRuleId)
    end
 DebugPrint("@@@UIUnlockMgr OnSystemFirstTimeUnlock",UIUnlockRuleId)
    self:TryStartUIUnlockTask()

    -- 有系统首次解锁时，刷新主界面右上角功能入口列表
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local BattleMainUI = UIManager:GetUIObj("BattleMain")
    if BattleMainUI then
        BattleMainUI:InitBtnList()
    end
end

function Component:AddListenEvents()
    EventManager:AddEvent(EventID.EnterRegion, self, self.OnEnterRegion_UIUnlockMgr)
    EventManager:AddEvent(EventID.ExitRegion, self, self.OnExitRegion_UIUnlockMgr)
    EventManager:AddEvent(EventID.InLoading, self, self.InLoading_UIUnlockMgr)
    ---交给AfterLoadingMgr驱动
    --EventManager:AddEvent(EventID.CloseLoading, self, self.HandleCloseLoadingEvent)
    --EventManager:AddEvent(EventID.EnterDungeon, self, self.OnEnterDungeon_UIUnlockMgr)
    --EventManager:AddEvent(EventID.ExitDungeon, self, self.OnExitDungeon_UIUnlockMgr)
    EventManager:AddEvent(EventID.OnLevelDeliverBlackCurtainStart, self, self.OnLevelDeliverBlackCurtainStart)
    EventManager:AddEvent(EventID.OnLevelDeliverBlackCurtainEnd, self, self.OnLevelDeliverBlackCurtainEnd)
    EventManager:AddEvent(EventID.EnterImmersiveTalk, self, self.OnEnterImmersiveTalk)
    EventManager:AddEvent(EventID.LeaveImmersiveTalk, self, self.OnLeaveImmersiveTalk)
end

function Component:OnEnterRegion_UIUnlockMgr()
    DebugPrint("@@@UIUnlockMgrEnterRegion")
    self.bInRegion_UIUnlock = true
    self:TryStartUIUnlockTask()
end

function Component:OnExitRegion_UIUnlockMgr()
    DebugPrint("@@@UIUnlockMgr ExitRegion")
    self.bInRegion_UIUnlock = false
end

function Component:InLoading_UIUnlockMgr()
    DebugPrint("@@@UIUnlockMgr InLoading")
    self.bInLoading_UIUnlock = true
end

---交给AfterLoadingMgr驱动
function Component:HandleCloseLoadingEvent_WhileSystemUnlock()
    DebugPrint("@@@UIUnlockMgr CloseLoading")
    self.bInLoading_UIUnlock = false
    self:TryStartUIUnlockTask()
    ---结束loading自动执行GM指令
    if GWorld.IsDev then
		GWorld.GameInstance:GetAvatar():AutoExecuteGM()
	end
end

function Component:OnLevelDeliverBlackCurtainStart()
    DebugPrint("@@@UIUnlockMgr Begin LevelDeliverBlack ")
    self.bInDeliverBlack_UIUnlock = true
end

function Component:OnLevelDeliverBlackCurtainEnd()
    DebugPrint("@@@UIUnlockMgr End LevelDeliverBlack ")
    self.bInDeliverBlack_UIUnlock = false
    self:TryStartUIUnlockTask()
end

function Component:OnEnterImmersiveTalk()
    DebugPrint("@@@UIUnlockMgr OnEnterImmersiveTalk")
    self.bInImmersiveTalk_UIUnlock = true
end

function Component:OnLeaveImmersiveTalk()
    DebugPrint("@@@UIUnlockMgr OnLeaveImmersiveTalk")
    self.bInImmersiveTalk_UIUnlock = false 
    self:TryStartUIUnlockTask()
end


function Component:CheckCanStartUnlockTask()
     local Avatar = GWorld:GetAvatar()
     if Avatar then
        self.bInRegion_UIUnlock=Avatar:IsInBigWorld()
        DebugPrint("@@@UIUnlockMgr UseAvatar InBigWorld")
    end
    DebugPrint("@@@UIUnlockMgr CheckCanStartUnlockTask",self.bInRegion_UIUnlock, not self.bInLoading_UIUnlock, not self.bInDeliverBlack_UIUnlock, not self.bInImmersiveTalk_UIUnlock)
    return (self.bInRegion_UIUnlock) and (not self.bInLoading_UIUnlock) and (not self.bInDeliverBlack_UIUnlock) and (not self.bInImmersiveTalk_UIUnlock)
end

function Component:HasUIUnlockTask()
    local bRes = not IsEmptyTable(self.FirstTimeUnlockUIQueue)
    DebugPrint("@@@UIUnlockMgr Check HasUIUnlockTask",bRes)
    return bRes
end

function Component:TryStartUIUnlockTask()
    DebugPrint("@@@UIUnlockMgr TryStartUIUnlockTask",self:CheckCanStartUnlockTask())
    if not self:CheckCanStartUnlockTask() then
        return
    end

    local Key,UIUnlockRuleId = next(self.FirstTimeUnlockUIQueue)
    if not UIUnlockRuleId then
        if not self.bEndNormalUnlockUITask  then
            local SystemUnlockGuideWidget = UIManager(GWorld.GameInstance):GetUIObj("SystemUnlockGuide")
            if SystemUnlockGuideWidget then
                SystemUnlockGuideWidget:Close()
            end
            DebugPrint("@@@UIUnlockMgr End ShowNormal UIUnlockGuide")
            for _, Value in pairs(self.FirstTimeUnlockSubUIQueue) do
                self.CacheUnlockRuleIdsArray:Add(Value)
            end
            self:EndUIUnlockTask()
        end
        Key,UIUnlockRuleId = next(self.FirstTimeUnlockSubUIQueue)
        if not self.bHasFireEvent then
            EventManager:FireEvent(EventID.OnSystemUnlockWorkingEnd)
            self.bHasFireEvent=true
        end
    else
        self.bEndNormalUnlockUITask=false
        self.bHasNoramUIUnlockTask=true
        self.bHasFireEvent=false
        EventManager:FireEvent(EventID.OnSystemUnlockWorkingStart)
        self:OnSystemFirstTimeUnlock_Internal(UIUnlockRuleId,function()
            self.FirstTimeUnlockUIQueue[Key] = nil 
            self.bUnlockTaskWorking = false
            self.CacheUnlockRuleIdsArray:Add(UIUnlockRuleId)
            self:TryStartUIUnlockTask()
        end)
        return
    end
    if not UIUnlockRuleId then
       if not self.bHasNoramUIUnlockTask and not self.bEndSubUnlockUITask then
            self:EndUIUnlockTask()
        end
        self.bHasNoramUIUnlockTask=false
        self.bEndSubUnlockUITask=true
        self.bHasFireEvent=false
        UIManager(GWorld.GameInstance):UnLoadUINew("SubSystemUnlock")
        self:RemoveSubsystemUIFromParent()
    else
        self.bEndSubUnlockUITask=false
        self:OnSystemFirstTimeUnlock_Internal(UIUnlockRuleId,function()
            --如果当前正处于不能执行的状态，暂时中断，等下次尝试继续弹FirstTimeUnlockSubUIQueue内容
            if not self:CheckCanStartUnlockTask() then
                return
            end
            self.FirstTimeUnlockSubUIQueue[Key] = nil
            self.bUnlockTaskWorking = false
            if not self.bHasNoramUIUnlockTask and not self.bEndSubUnlockUITask then
                self.CacheUnlockRuleIdsArray:Add(UIUnlockRuleId)
            end
            self:TryStartUIUnlockTask()
        end)
    end
end

function Component:RemoveSubsystemUIFromParent()
    local BattleMainUI = UIManager(GWorld.GameInstance):GetUIObj("BattleMain")
    if BattleMainUI ~= nil and BattleMainUI.Pos_SubSystemUnlock ~= nil then
        BattleMainUI.Pos_SubSystemUnlock:ClearChildren()
        BattleMainUI.Pos_SubSystemUnlock:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function Component:EndUIUnlockTask()
    --因表现问题，认为当Normal类型解锁显示完后就完成
    DebugPrint("@@@UIUnlockMgr EndUIUnlockTask")
    self.bUnlockTaskWorking = false
    self.bEndNormalUnlockUITask=true
    if self.CacheUnlockRuleIdsArray:Num() < 1 then
        DebugPrint("@@@UIUnlockMgr EndUIUnlockTask self.CacheUnlockRuleIdsArray:Num() <1")
        return
    end

    -- 有系统首次解锁时，刷新主界面右上角功能入口列表
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local BattleMainUI = UIManager:GetUIObj("BattleMain")
    if BattleMainUI then
        BattleMainUI:InitBtnList()
    end
    -- 发送Task处理完成通知（预留功能
    if self.CacheUnlockRuleIdsArray:Num() > 0 then
        DebugPrint("@@@UIUnlockMgr EndUIUnlockTask",self.CacheUnlockRuleIdsArray:Num())
        DebugPrintTable(self.CacheUnlockRuleIdsArray:ToTable())
        EventManager:FireEvent(EventID.OnSystemUnlockEnding, self.CacheUnlockRuleIdsArray)
    end

    self.CacheUnlockRuleIdsArray = TArray("")
    if self.OnEndUIUnlockTaskOnceDelegate then 
    end
end

function Component:OnSystemFirstTimeUnlock_Internal(UIUnlockRuleId, OnFinishedCallback)
    DebugPrint("@@@UIUnlockMgr OnSystemFirstTimeUnlock_Internal ",UIUnlockRuleId)
    OnFinishedCallback = OnFinishedCallback or function() end
    local SystemInfo =  DataMgr.UIUnlockRule[UIUnlockRuleId]
    if not SystemInfo then
        DebugPrint("@@@UIUnlockMgr No System info found in MainUI.xlsx, UIUnlockRuleId", UIUnlockRuleId)
        OnFinishedCallback()
        return
    end

    -- 若隐藏解锁表现，则直接返回
    if SystemInfo.IsHideUnlockPopup == 1 or self.bGMHideUnlockPopup then
        DebugPrint("@@@UIUnlockMgr 隐藏UI解锁表现", UIUnlockRuleId)
        OnFinishedCallback()
        return
    end

    if SystemInfo.UnlockPopupType == "Light" then
        self:ShowSubSystemUnlockUI(SystemInfo, OnFinishedCallback)
    elseif SystemInfo.UnlockPopupType == "Normal" then
        self:ShowSystemUnlockUI(SystemInfo, OnFinishedCallback)
    else
        self:ShowSystemUnlockUI(SystemInfo, OnFinishedCallback)
    end
end

function Component:ShowSystemUnlockUI(SystemInfo, OnFinishedCallback)
    local UIName = "SystemUnlockGuide"
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local SystemUnlockGuideUI = UIManager:GetUIObj(UIName)
    if not SystemUnlockGuideUI then
        SystemUnlockGuideUI = UIManager:LoadUINew(UIName)
    end

    if not SystemUnlockGuideUI then
        DebugPrint("@@@UIUnlockMgr Load SystemUnlockGuide UI failed, UIUnlockRuleId", SystemInfo.UIUnlockRuleId)
        OnFinishedCallback()
        return
    end

    SystemUnlockGuideUI:BindOnOutAnimationFinished(OnFinishedCallback)
    SystemUnlockGuideUI:OnWorking(SystemInfo)
end

function Component:ShowSubSystemUnlockUI(SystemInfo, OnFinishedCallback)
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local BattleMainUI = UIManager:GetUIObj("BattleMain")
    local UnlockUI, IsAlreadyAddToBattleMain = nil, false
    if BattleMainUI ~= nil and BattleMainUI.Pos_SubSystemUnlock ~= nil then
        UnlockUI = BattleMainUI.Pos_SubSystemUnlock:GetChildAt(0)
        if (UnlockUI) then
            IsAlreadyAddToBattleMain = true
        end
    end

    if not UnlockUI then
        UnlockUI = UIManager:GetUIObj("SubSystemUnlock")
    end

    if not UnlockUI then
        UnlockUI = UIManager:LoadUINew("SubSystemUnlock")
    end

    if not UnlockUI then
        OnFinishedCallback()
        return
    end

    if BattleMainUI ~= nil and BattleMainUI.Pos_SubSystemUnlock ~= nil then
        if (not IsAlreadyAddToBattleMain) then
            BattleMainUI.Pos_SubSystemUnlock:AddChildToOverlay(UnlockUI)
            BattleMainUI.Pos_SubSystemUnlock:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        else
            -- 已经处于HUD界面上了，需要在这一步隐藏一下互斥的UI
            local SystemUIConfig = DataMgr.SystemUI["SubSystemUnlock"]
            UIManager:AddUIToStateTagsCluster(SystemUIConfig.StateTag, "SubSystemUnlock", true)
            local NormalStateSubTag, SpecialUINameList = UIManager:GetSubTagInNormalState("SubSystemUnlock")
            UIManager:HandleUIWidgetsVisibilityByUIShow("SubSystemUnlock", UnlockUI, NormalStateSubTag, SpecialUINameList)
        end
        UnlockUI:OnWorking(SystemInfo, function()
            self:ShowEnd()
            OnFinishedCallback()
        end)
    else 
        self:ShowEnd()
        OnFinishedCallback()
    end
end

function Component:ShowEnd()
    local SystemUIConfig = DataMgr.SystemUI["SubSystemUnlock"]
    if (SystemUIConfig) then
        UIManager(self):HandleUIWidgetsVisibilityByUIHide("SubSystemUnlock", "SubSystemUnlock", SystemUIConfig.StateTag)
    end
end

function Component:BindUIUnlockDelegates()
    DebugPrint("@@@UIUnlockMgr UIUnlockMgr BindUIUnlockDelegates")
    if self.bHasBindUIUnlockDelegates then
        return
    end
    self.bHasBindUIUnlockDelegates = true
    EventManager:AddEvent(EventID.OnLoginSuccess, self, self.UIUnlockMgrOnLoginSuccess)
end

function Component:UIUnlockMgrOnLoginSuccess()
    self:BindAllOnUIFirstUnlockAnimation()
end

function Component:BindAllOnUIFirstUnlockAnimation()
    if  DataMgr.UIUnlockRule then
        for _,Info in pairs( DataMgr.UIUnlockRule) do
            local UIUnlockRuleId = Info.UIUnlockRuleId
            local bHasBind = self.HasBindUIUnlockRules[UIUnlockRuleId]
            if (not bHasBind) then
                self.HasBindUIUnlockRules[UIUnlockRuleId] = true
                local Key = self:BindOnUIFirstTimeUnlock(UIUnlockRuleId, function()
                    self:OnSystemFirstTimeUnlock(UIUnlockRuleId)
                end)
                table.insert(self.BindUIUnlockKeys, {Key = Key, UIUnlockRuleId = UIUnlockRuleId})
            end
        end
    end
end

function Component:UnBindAllOnUIFirstUnlockAnimation()
    for _, Info in pairs(self.BindUIUnlockKeys or {}) do
        self:UnBindOnUIFirstTimeUnlock(Info.UIUnlockRuleId, Info.Key)
    end
end

function Component:UIUnlockMgrOnConditionComplete(ConditionId)
    DebugPrint("@@@ UIUnlockMgr Received Condition Completed ", ConditionId)
    if self.ConditionMetCache[ConditionId] then
        DebugPrint("UIUnlockMgrOnConditionComplete: 系统解锁收到了同一Condition的多次完成通知: "..ConditionId) 
        return
    end
    if self.ConditionFirstMetEvents[ConditionId] then
        for _, cb in pairs(self.ConditionFirstMetEvents[ConditionId]) do
            if cb then
                cb()
            end
        end
        DebugPrint("@@@ UIUnlockMgr ConditionFirestMetEvents Complete", ConditionId)
    end
    -- Clear
    self.ConditionFirstMetEvents[ConditionId] = nil

    -- Client caching
    self.ConditionMetCache[ConditionId] = true
end

function Component:_OnPropChangeSystemStates(keys)
    local System = keys[1]
    if System then
        print(_G.LogTag, "_OnPropChangeSystemStates", System, self.SystemStates[System])
    end
    if self:CheckSystemUnlocked(System) then
        local UIUnlockInfo = DataMgr.UIUnlockRule[System]
        if UIUnlockInfo then
            self:UIUnlockMgrOnConditionComplete(UIUnlockInfo.ConditionId)
        end
    end
end

function Component:CheckSystemUnlocked(System)
    local State = self.SystemStates[System]
    return State == 1
end

return Component
