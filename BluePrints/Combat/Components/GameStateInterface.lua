--require "UnLua"
local TimeUtils = require "Utils.TimeUtils"
local MiscUtils = require "Utils.MiscUtils"
local GameFlowUtils = require "Utils.GameFlowUtils"

local Component = Class({
    "BluePrints.Common.TimerMgr",
})

function Component:InitGameStateInterface()
    -- 通用事件
    if not IsAuthority(self) then 
        return
    end
	self:RegisterGameModeEvent("OnEnter", self, self.OnEnter)
    self:RegisterGameModeEvent("OnCustomEvent", self, self.OnCustomEvent)
    self:RegisterGameModeEvent("OnPause", self, self.OnPause)
    self:RegisterGameModeEvent("OnBattle", self, self.OnBattle)
    self:RegisterGameModeEvent("OnExit", self, self.OnExit)
    self:RegisterGameModeEvent("OnDisconnect", self, self.OnDisconnect)
end

--No Para GameState收到广播进行分发
function Component:GameModeEvent_Lua(Func, ...)
    local FuncName = Func.."_Lua"
    if self[FuncName] ~= nil then
        DebugPrint ("GameStateInterface 收到Custom事件广播进行转发：", Func)
        self[FuncName](self, ...)
    end
end

function Component:InitTimeCheckMgr()
    -- 定时更新客户端时间
    if IsStandAlone(self) or IsClient(self) then
        self:AddTimer(60, function()
            TimeUtils.RequestSetNowTime()
        end, true, 30, "ClientTimeReset", true)
    end
end

-----------------------GameState Server 接收GameMode的广播-------------
-----------------------GameMode CustomEvent---------------------------
function Component:OnEnter(Eid)
	self:MulticastOnEnter(Eid)
end

function Component:OnExit(EidArr)
    self:MulticastOnExit(EidArr)
end

function Component:OnDisconnect(AvatarEidStr)
    self:MulticastOnDisconnect(AvatarEidStr)
end

function Component:OnCustomEvent(EventName, Channel)
    if Channel == Const.GameModeEventServerClient then
        self:MulticastOnCustomeEvent(EventName)
    end
end

function Component:OnInit()
    self:MulticastGameModeEvent("OnInit")
end

function Component:OnEnd(Result)
    self:MulticastOnEnd(Result)
end

function Component:OnBattle()
    self:MulticastGameModeEvent("OnBattle")
end

function Component:OnPause()
    self:MulticastGameModeEvent("OnPause")
end

function Component:OnAlert()
    self:MulticastGameModeEvent("OnAlert")
end

function Component:OnEnterCommonAlert()
    self:MulticastGameModeEvent("OnEnterCommonAlert")
end

function Component:OnExitCommonAlert()
    self:MulticastGameModeEvent("OnExitCommonAlert")
end

--------------------------------------------------------------
------------------------------------------------------------------------

------------------------------------------------------------------------
----------------------------------UI事件通知-----------------------------

function Component:OnRep_DungeonEvent_Lua()
    if not self.IsCanFreshDungeonEvent then
        DebugPrint ("GameStateInterface  OnRep_DungeonEvent_Lua IsCanFreshDungeonEvent==false")
        return
    end
    if GWorld.GameInstance:IsInTempScene() then
        DebugPrint ("GameStateInterface  OnRep_DungeonEvent_Lua 因为在结算界面而阻断")
        return
    end
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if not Player then 
        DebugPrint ("GameStateInterface  OnRep_DungeonEvent_Lua Player==nil")
        return
    end

    if not self.LastDungeonEvent then self.LastDungeonEvent = {} end
    local DungeonEventNum = self.DungeonEvent:Num()
    DebugPrint ("GameStateInterface  OnRep_DungeonEvent_Lua 收到事件广播, 上一次事件数量："..#self.LastDungeonEvent.."    当前事件数量："..DungeonEventNum)

    self:PrintAllDungeonEvents()

    self:TriggerUpdateDungeonEvent()

    self.LastDungeonEvent = {}
    for i = 1, self.DungeonEvent:Num() do
        local Event = self.DungeonEvent:GetValueByIdx(i-1)
        if Event ~= "" then
            self.LastDungeonEvent[i] = self.DungeonEvent:GetValueByIdx(i-1)
        else
            break
        end
    end
end

function Component:PrintAllDungeonEvents()
    local EventString = ""
    for _, Event in pairs(self.LastDungeonEvent or {}) do
        EventString = EventString..Event..", "
    end
    DebugPrint ("GameStateInterface  OnRep_DungeonEvent_Lua 打印上一次事件内容   "..EventString)

    EventString = ""
    for i = 1, self.DungeonEvent:Num() do
        local Event = self.DungeonEvent:GetValueByIdx(i-1)
        EventString = EventString..Event..", "
    end
    DebugPrint ("GameStateInterface  OnRep_DungeonEvent_Lua 打印当前DungeonEvent内容   "..EventString)
end


function Component:TriggerUpdateDungeonEvent()
    local DungeonEventNum = self.DungeonEvent:Num()
    local IgnoreIdx = 0
    local IgnoreIdxCanChange = true
    local RemoveEvents = {}
    local AddEvents = {}

    DebugPrint("GameStateInterface @@@@@@  此次OnRep收到TriggerUpdateDungeonEvent", IgnoreIdx, self.DungeonEvent:Num())
    -- 数量相同且无增量，只触发最后一个

    if #self.LastDungeonEvent == DungeonEventNum and #self.LastDungeonEvent ~= 0 then
        local HasNewEvent = false
        for i = 1, self.DungeonEvent:Num() do
            local Event = self.DungeonEvent:GetValueByIdx(i-1)
            if Event ~= "" and not CommonUtils.HasValue(self.LastDungeonEvent, Event) then
                HasNewEvent = true
                break
            end
        end
        if not HasNewEvent then
            local LastEvent = self.DungeonEvent:GetValueByIdx(DungeonEventNum - 1)
            self:TriggerAddDungeonEvent(LastEvent)
            return
        end
    end

    for i, Event in pairs(self.LastDungeonEvent or {}) do
        if i <= DungeonEventNum and self.DungeonEvent:GetValueByIdx(i-1) == Event and IgnoreIdxCanChange then
            IgnoreIdx = i
        else
            IgnoreIdxCanChange = false
            table.insert(RemoveEvents, Event)
            -- self:TriggerRemoveDungeonEvent(Event)
        end
    end

    for i = 1, self.DungeonEvent:Num() do
        local Event = self.DungeonEvent:GetValueByIdx(i-1)
        if Event ~= "" and i > IgnoreIdx then
            table.insert(AddEvents, Event)
            -- self:TriggerAddDungeonEvent(Event)
        end
    end

    -- 最后统一处理删除和新增事件
    for i, RemoveEvent in pairs(RemoveEvents) do
        if not CommonUtils.HasValue(AddEvents, RemoveEvent) then 
            self:TriggerRemoveDungeonEvent(RemoveEvent)
        else
            CommonUtils.RemoveValue(AddEvents, RemoveEvent)
        end
    end
    for i, AddEvent in pairs(AddEvents) do
        self:TriggerAddDungeonEvent(AddEvent)
    end
end

function Component:TriggerAddDungeonEvent(Event)
    if Event == "" then
        DebugPrint ("GameStateInterface  TriggerAddDungeonEvent 出现空事件")
        return
    end
    local FuncName = Event.."_Lua"
    DebugPrint ("GameStateInterface  OnRep_DungeonEvent_Lua 收到增量事件：", Event)
    if self[FuncName] ~= nil then
        DebugPrint ("GameStateInterface  OnRep_DungeonEvent_Lua 执行增量事件：", FuncName)
        --self[FuncName](self)
        try{
            exec= function()
                self[FuncName](self)
            end,
            catch = function (err)
                DebugPrint(ErrorTag, "AddDungeonEvent Error! EventName: "..Event.." traceback: ")
                Traceback(ErrorTag, err, false)
            end
        }
    else
        DebugPrint ("GameStateInterface  OnRep_DungeonEvent_Lua 未找到对应的事件：", FuncName)
    end
end

function Component:TriggerRemoveDungeonEvent(Event)
    if Event == "" then
        DebugPrint ("GameStateInterface  TriggerRemoveDungeonEvent 出现空事件")
        return
    end
    local FuncName = "Remove"..Event.."_Lua"
    DebugPrint ("GameStateInterface  OnRep_DungeonEvent_Lua 收到Remove事件：", Event)
    if self[FuncName] ~= nil then
        DebugPrint ("GameStateInterface  OnRep_DungeonEvent_Lua 执行Remove事件：", FuncName)
        --self[FuncName](self)
        try{
            exec= function()
                self[FuncName](self)
            end,
            catch = function (err)
                DebugPrint(ErrorTag, "RemoveDungeonEvent Error! EventName: "..Event.." traceback: ")
                Traceback(ErrorTag, err, false)
            end
        }
    else
        DebugPrint ("GameStateInterface  OnRep_DungeonEvent_Lua 未找到对应的事件：", FuncName)
    end
end

------------------------------------------------------------------------
------------------------------------------------------------------------

-----------------------目前只有单机/联机客户端会走------------------------
-----------------------GameMode 通知 Client ---------------------------------
-- 服务器准备就绪
function Component:OnRep_GameModeReady()
    DebugPrint ("GameStateInterface  Client 收到OnRep_GameModeReady")
    if self.bGameModeReady then
        self:TryEndLoading("GameModeReady")
    end
end

function Component:OnInit_Lua()
    DebugPrint ("GameStateInterface  Client 收到事件OnInit_Lua")
    self:LoadDungeonUI()
    self:InitFbdRule()
    self:TriggerClientEvent("OnClientInit")
    self:CheckPreloadRecordData_Lua()
    -- 单人工会战需要记录一下最大分数
    if self.GameModeType == "SoloRaid" then
        self.SoloRaidHistoryMaxScore = 0
        local Avatar = GWorld:GetAvatar()
        if Avatar and Avatar.RaidSeasons and Avatar.CurrentRaidSeasonId and Avatar.RaidSeasons[Avatar.CurrentRaidSeasonId] then
            self.SoloRaidHistoryMaxScore = Avatar.RaidSeasons[Avatar.CurrentRaidSeasonId]:GetMaxRaidScore()
        end
    end
end

function Component:RemoveOnInit_Lua()
    DebugPrint ("GameStateInterface  Client 收到事件RemoveOnInit_Lua")
    --self:UnloadDungeonUI()        --按理说该卸载，但副本ui可以随着切换World而销毁
    self:ResetFbdRule()
end


function Component:OnBattle_Lua()
end

function Component:OnExit_Lua(Avatars)
    --const TArray<FString>& Avatars
	-- 数据不可靠，感觉没啥用。。
	--local PlayerArray = self.PlayerArray
    --local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
	--local SceneMgrComponent = GameInstance:GetSceneManager()
	--
	--
	--local AEid2PlayerState = {}
	--for _, PlayerState in pairs(PlayerArray) do
	--	local AvatarEidStr = PlayerState.AvatarEidStr
	--	AEid2PlayerState[AvatarEidStr] = PlayerState
	--end
	--
	--local LastPlayerState = nil
	--local MainPlayer = GWorld:GetMainPlayer()
	--for _, AvatarEid in pairs(Avatars) do
	--	local PlayerState = AEid2PlayerState[AvatarEid]
	--	if PlayerState then
    --        if (IsValid(SceneMgrComponent)) then
    --            SceneMgrComponent:UpdateSceneOtherPlayerGuide(PlayerState.Eid, "Exit")
    --        end
	--		local bIsTeammate = self:IsTeammate(PlayerState)
	--
	--		if MainPlayer and MainPlayer.Eid ~= PlayerState.Eid and not bIsTeammate then
	--			LastPlayerState = PlayerState
	--		end
	--	else
	--		assert(false, "gmy@Component:OnExit_Lua no PlayerState data", AvatarEid)
	--	end
	--end
	--
	--if LastPlayerState then
	--	self:DungeonOtherPlayerChange(LastPlayerState, false)
	--end
end

function Component:OnDisconnect_Lua(AvatarEidStr)
    --const FString& AvatarEidStr
end

-- 以下客户端事件暂时注掉，如有需要，可使用
-- function Component:OnAlert_Lua()
-- end

-- function Component:OnEnterCommonAlert_Lua()
-- end

-- function Component:OnExitCommonAlert_Lua()
-- end

-- function Component:OnEnd_Lua(Result)  
-- end

-- function Component:OnDestroy_Lua()
-- end

function Component:OnCustomeEvent_Lua(EventName)
    local FunName = 'On'..EventName..'_Lua'
    DebugPrint ("GameStateInterface 收到事件OnCustomeEvent_Lua：", EventName)
    if self[FunName] ~= nil then
        self[FunName](self)
    end
end

function Component:OnDungeonVoteBegin_Lua()
    EventManager:FireEvent(EventID.OnDungeonVoteBegin, self.VoteValues)
    UIManager(self):LoadUINew("Vote")
end

function Component:OnDungeonOneEnter_Lua(Eid)
	DebugPrint("gmy@Component:OnDungeonOneEnter_Lua", Eid)        
	local PlayerArray = self.PlayerArray
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
	-- local SceneMgrComponent = GameInstance:GetSceneManager()
	-- if (IsValid(SceneMgrComponent)) then
    --     SceneMgrComponent:UpdateSceneOtherPlayerGuide(Eid, "Enter")
    -- end
    
	for _, PlayerState in pairs(PlayerArray) do
		if PlayerState.Eid == Eid then
			-- 不是自己
			local MainPlayer = GWorld:GetMainPlayer()
			if MainPlayer and MainPlayer.Eid ~= Eid then
				self:DungeonOtherPlayerChange(PlayerState, true)
				return
			end
		end
	end
end

--function Component:DungeonOtherPlayerJoin(PlayerState)
--	if IsClient(self) then
--		EventManager:FireEvent(EventID.OnDungeonOtherPlayerJoin, PlayerState)
--
--		local UIObj = UIManager(self):GetUIObj("TeamToast")
--		if UIObj then
--			UIManager(self):UnLoadUINew("TeamToast")
--		end
--		UIManager(self):LoadUINew("TeamToast", PlayerState, true)
--	end
--end

function Component:IsTeammate(PlayerState)
	return TeamController:GetModel():IsTeammateByAvatarEid(PlayerState.AvatarEidStr)
end

function Component:DungeonOtherPlayerChange(PlayerState, bIsIn)
	if IsClient(self) and not self:IsTeammate(PlayerState) then
		local UIObj = UIManager(self):GetUIObj("TeamToast")
		if UIObj then
			UIManager(self):UnLoadUINew("TeamToast")
		end
		UIManager(self):LoadUINew("TeamToast", PlayerState, bIsIn)
	end
end

function Component:RemoveOnDungeonVoteBegin_Lua(Time, NowTimestamp)
    -- EventManager:FireEvent(EventID.OnRepDungeonVoteInterval)
end

---------------------------- 救援玩法DungeonEvent相关 ---------------------------
function Component:RescueCountDownUI_Lua()
    DebugPrint("RescueUI: ShowCountDown")
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
	local UIManager = GameInstance:GetGameUIManager()
	if UIManager ~= nil then
		local CaptureFloat = UIManager:GetUIObj("DungeonCaptureFloat")
		if CaptureFloat == nil then
			CaptureFloat = UIManager:LoadUINew("DungeonCaptureFloat", self.RescueCountDownTime, DataMgr.GlobalConstant.RescueCountdownPoint.ConstantValue)
		end
		CaptureFloat:InitCaptureTimeUIOnShowDownTime()
	end
end

function Component:RemoveRescueCountDownUI_Lua()
    DebugPrint("RescueUI: CloseCountDown")
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
	local UIManager = GameInstance:GetGameUIManager()
	if UIManager ~= nil then
        local CaptureFloat = UIManager:GetUIObj("DungeonCaptureFloat")
        if CaptureFloat then
            CaptureFloat:Close()
        end
	end
end

function Component:OnRep_RescueCountDownTime()
    DebugPrint("RescueUI: OnRep_RescueCountDownTime CurTime:", self.RescueCountDownTime)
    EventManager:FireEvent(EventID.OnRepRescueCountDownTime)
    if self.RescueCountDownTime <= 15 then
        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
	    local UIManager = GameInstance:GetGameUIManager()
        local Names = UIManager:GetAllUINameByBPClass(UE4.UClass.Load(UIConst.DUNGEONINDICATOR.GuidePointMechLevel2))
        for _, v in pairs(Names) do
            local HostageDoorGuide = UIManager:GetUIObj(v)
            if HostageDoorGuide and not HostageDoorGuide:IsAnimationPlaying(HostageDoorGuide.Loop) then
                HostageDoorGuide:PlayAnimation(HostageDoorGuide.Loop, 0, 0)
            end
            return
        end
    end
end

function Component:OnRep_bHostageInvincible()
    DebugPrint("OnRep_bHostageInvincible",self.bHostageInvincible)
    EventManager:FireEvent(EventID.NotifyClientChangeHostageInvincible,self.bHostageInvincible)
end

function Component:HostageDyingCountDown_Lua()
    DebugPrint("RescueUI: HostageDyingCountDown")

    EventManager:FireEvent(EventID.TriggerHostageGuideLoop, true)
    -- todo 这个bui早该独立出来了，不该和倒计时ui绑同一个lua
    -- 换个思路 把这俩ui整合成同一个也行
    local RescueTimeFloat = UIManager(self):GetUIObj("DungeonRescueTimeFloat")
    if RescueTimeFloat == nil then
        RescueTimeFloat = UIManager(self):LoadUINew("DungeonRescueTimeFloat")
    end
    RescueTimeFloat:InitRescueTimeFloatOnHostageDead()

    local CaptureFloat = UIManager(self):GetUIObj("DungeonCaptureFloat")
    if CaptureFloat == nil then
        CaptureFloat = UIManager(self):LoadUINew("DungeonCaptureFloat", 15, 15)
    end
    CaptureFloat:InitCaptureTimeUIOnHostageDead(self:GetHostagePhantomState())
end

function Component:GetHostagePhantomState()
    for _, PhantomState in pairs(self.PhantomArray) do
        if IsValid(PhantomState) and PhantomState.bIsHostage then
            return PhantomState
        end
    end
end

function Component:RemoveHostageDyingCountDown_Lua()
    DebugPrint("RescueUI: RemoveHostageDyingCountDown")

    EventManager:FireEvent(EventID.TriggerHostageGuideLoop, false)
    local RescueTimeFloat = UIManager(self):GetUIObj("DungeonRescueTimeFloat")
    if RescueTimeFloat ~= nil then
        -- RescueTimeFloat.IsInit = true
        RescueTimeFloat:Close()
    end
    -- 出现了人质被拉起，但是死亡倒计时ui没关闭的bug。按理说该在这里关，但是之前没这么做也能行。没空深究了，先在这加上吧
    local CaptureFloat = UIManager(self):GetUIObj("DungeonCaptureFloat")
    if CaptureFloat ~= nil then
        CaptureFloat:Close()
    end
end
---------------------------------------------------------------------------------------------

function Component:OnRepDungeonExitInfo(Info,bIsWaiting)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
	local UIManager = GameInstance:GetGameUIManager()
    if not UIManager then
        return
    end
    local CountDownUI = UIManager:GetUIObj("DungeonCaptureFloat")
    local Text
    if bIsWaiting then
        Text = GText("UI_Evacuated") .. tostring(Info.WaitingPlayerNum) .. "/" .. tostring(Info.TotalPlayerNum)
    else
        Text = string.format(GText("UI_Evacuating"),Info.WaitingPlayerNum)
    end
    if Info.bShowExitCountdownToast then
        local RemaingTime = self.ExitCountDown - math.max(math.floor(self.ReplicatedTimeSeconds - Info.StartExitCountdownTime),0)
        DebugPrint("Show Exit Countdown Toast RemaingTime = " .. RemaingTime,self.ReplicatedTimeSeconds,Info.StartExitCountdownTime)
        if RemaingTime <= 0 then return end
        if CountDownUI then
            CountDownUI:Reset(RemaingTime,-1,self.ReplicatedTimeSeconds)
            CountDownUI:UIStateChange_OnTarget()
        else
            CountDownUI = UIManager:LoadUINew("DungeonCaptureFloat",RemaingTime,-1)
            CountDownUI:UIStateChange_OnTarget()
        end

        if CountDownUI then
            CountDownUI:SetTitle(Text)
        end
    else
        if CountDownUI then
            CountDownUI:UIStateChange_AfterTarget()
        end
    end
end

function Component:OnRep_ExitInfo()
    local ExitMechanismArray = self.MechanismMap:FindRef("ExitTrigger")
    local ExitMechanism = nil
    if ExitMechanismArray and ExitMechanismArray.Array then
        ExitMechanism = ExitMechanismArray.Array:ToTable()[1]
    end
    local bIsWaiting = ExitMechanism and ExitMechanism:IsPlayerWaiting(UE4.UGameplayStatics.GetPlayerController(self, 0).Character)

     -- 再增加一个距离判断作为保底，若玩家是能同步到的所有玩家中离撤离点最近的人，那么肯定是它在等别人
    if not bIsWaiting then
        local PlayerCharacter = UE4.UGameplayStatics.GetPlayerController(self, 0).Character
        local PCs = self:GetAllPlayerCharacters()
        local MinDist = math.huge
        local PlayerCharacterDist = math.huge
        for _, Actor in pairs(PCs or {}) do
            if PlayerCharacter == Actor:Cast(UE4.APlayerCharacter) then
                PlayerCharacterDist = self:GetDistanceToPlayerComponent(PlayerCharacter) or math.huge
                MinDist = math.min(PlayerCharacterDist, MinDist)
            else
                local Dist = self:GetDistanceToPlayerComponent(Actor) or math.huge
                MinDist = math.min(Dist, MinDist)
            end
        end

        if PlayerCharacterDist ~= math.huge and PlayerCharacterDist == MinDist then
            bIsWaiting = true
        end
    end

    DebugPrint("GameState:OnRep_ExitInfo",ExitMechanism,bIsWaiting)
    PrintTable(self.ExitInfo)
    if self.GameModeType == "Party" then
        EventManager:FireEvent(EventID.OnPlayerEnterToExit, self.ExitInfo, bIsWaiting)
    else
        self:OnRepDungeonExitInfo(self.ExitInfo,bIsWaiting)
    end
end

function Component:GetDistanceToPlayerComponent(PlayerCharacter)
    local World = (self.GetWorld and self:GetWorld()) or UE4.UGameplayStatics.GetWorld(self)
    if not World then return nil end

    local BPClass = UE4.UClass.Load("/Game/BluePrints/Common/Triggers/BP_ExitTriggerBoxMechanism.BP_ExitTriggerBoxMechanism_C")
    DebugPrint("BPClass: ", BPClass)
    local Actors = UE4.UGameplayStatics.GetAllActorsOfClass(World, UE4.BP_ExitTriggerBoxMechanism_C)
    local BP_ExitTriggerBoxMechanism = nil
    if Actors and Actors:Length() > 0 then
        BP_ExitTriggerBoxMechanism = Actors:GetRef(1)
    end

    local ExitTriggerBoxLocation = nil
    if BP_ExitTriggerBoxMechanism == nil then
        ExitTriggerBoxLocation = self.ExitTriggerBoxLocation
    else
        ExitTriggerBoxLocation = BP_ExitTriggerBoxMechanism.CollisionComponent and BP_ExitTriggerBoxMechanism.CollisionComponent:K2_GetComponentLocation()
        if ExitTriggerBoxLocation ~= Const.ZeroVector then
            self.ExitTriggerBoxLocation = ExitTriggerBoxLocation
        end
    end

    if ExitTriggerBoxLocation == nil or ExitTriggerBoxLocation == Const.ZeroVector then
        return
    end

    if not PlayerCharacter or not PlayerCharacter.CapsuleComponent then
        return nil
    end

    local PlayerCharacterLocation = PlayerCharacter.CapsuleComponent:K2_GetComponentLocation()

    local Delta = ExitTriggerBoxLocation - PlayerCharacterLocation
    return Delta:Size()
end

-- 返回一个包含当前所有Character的数组
function Component:GetAllPlayerCharacters()

    local World = (self.GetWorld and self:GetWorld()) or UE4.UGameplayStatics.GetWorld(self)
    if not World then return {} end
    local PCs = {}

    local Actors = UE4.UGameplayStatics.GetAllActorsOfClass(World, UE4.APlayerCharacter)
    if Actors then
        for i = 1, Actors:Length() do
            local Actor = Actors:GetRef(i)
            if Actor then
                table.insert(PCs, Actor)
            end
        end
    end

    return PCs
end

function Component:SurvivalValueFinished_Lua()
    DebugPrint("SurvivalUI: SurvivalValueFinished")
	local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
	local UIManager = GameInstance:GetGameUIManager()
	local DungenonSurviveFloat = UIManager:GetUIObj("DungenonSurviveFloat")
	if (DungenonSurviveFloat ~= nil) then
		DungenonSurviveFloat:OnEnd()
	end
end

------------------ 捕获倒计时 ---------------------
function Component:CaptureMonsterRecovery_Lua()
    DebugPrint("CaptureComponent: ShowCaptureMonsterRecovery_Lua")
    EventManager:FireEvent(EventID.ShowDungeonUI)
end

function Component:RemoveCaptureMonsterRecovery_Lua()
    DebugPrint("CaptureComponent: CloseCaptureMonsterRecovery_Lua")
    EventManager:FireEvent(EventID.CloseDungeonUI)
    local SceneMgrComponent = GWorld.GameInstance:GetSceneManager()
    if (IsValid(SceneMgrComponent) and not IsDedicatedServer(self)) then
        local CaptureMonsterEid = SceneMgrComponent.CaptureMonsterEid       -- 客户端记录过捕获怪的Eid，直接拿来用了    todo：Eid移到GameState上
        local CaptureMonster = Battle(self):GetEntity(CaptureMonsterEid)
	    if IsValid(CaptureMonster) then
            CaptureMonster:SetMonWaitForCaught(false)
		    CaptureMonster:SetCharacterTag("Idle")
        end

        SceneMgrComponent:RecoverGuideIcon()
    end
end

------------------ 区域防御 -----------------------
function Component:Chapter01_Trafficway_Hunt3_Lua()
    local Info = self.ClientTimerStruct:GetTimerInfo("Chapter01_Trafficway_Hunt3")
    DebugPrint("RegionDefenceUI: Chapter01_Trafficway_Hunt3", Info.Time, Info.TimeSeconds, GWorld:IsStandAlone())
    EventManager:FireEvent(EventID.DefenseTimerAdded, Info.Key, Info.Time, Info.TimeSeconds)
    EventManager:FireEvent(EventID.ShowDungeonUI)
end

function Component:RemoveChapter01_Trafficway_Hunt3_Lua()
    local Info = self.ClientTimerStruct:GetTimerInfo("Chapter01_Trafficway_Hunt3")
    DebugPrint("RemoveRegionDefenceUI: Chapter01_Trafficway_Hunt3", Info.Time, Info.TimeSeconds, GWorld:IsStandAlone())
    EventManager:FireEvent(EventID.CloseDungeonUI)
end

------------------定时器样例by防御玩法
function Component:DefenceCountDown_Lua()
    local Info = self.ClientTimerStruct:GetTimerInfo("DefenceCountDown")
    -- local B = FClientTimerInfo()
    DebugPrint("GameStateInterface 收到 DefenceCountDown_Lua", self:GetLocalRole())
    EventManager:FireEvent(EventID.DefenseTimerAdded, Info.Key, Info.Time, Info.TimeSeconds)
    EventManager:FireEvent(EventID.ShowDungeonUI)
end

function Component:RemoveDefenceCountDown_Lua()
    DebugPrint("GameStateInterface 收到 RemoveDefenceCountDown_Lua", self:GetLocalRole())
end

function Component:OnWaveStart_Lua()
	EventManager:FireEvent(EventID.OnWaveStart)
end

function Component:OnWaveEnd_Lua()
	EventManager:FireEvent(EventID.OnWaveEnd)
end

function Component:OnSurvivalProFinishTutorial_Lua()
	EventManager:FireEvent(EventID.SurvivalProFinishTutorial)
end

function Component:OnSurvivalProSurpossedLeave_Lua()
	EventManager:FireEvent(EventID.SurvivalProSurpossedLeave)
end

function Component:OnSurvivalProBeginTutorial_Lua()
	EventManager:FireEvent(EventID.SurvivalProBeginTutorial)
end

function Component:OnSabotageOptionalMissionSucceed_Lua()
    -- Close TaskPanel
	local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if (UIManager == nil) then
		return
	end
end

function Component:InitFbdRule()
    DebugPrint("InitFbdRule", self.DungeonId)

    local DungeonData = DataMgr.Dungeon[self.DungeonId]
    if not DungeonData then
        return
    end

    local FbdRule = DungeonData.FbdRule
    if not FbdRule then
        return
    end

    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    -- 轮盘禁用
    if FbdRule.NoBattleWheel and FbdRule.NoBattleWheel ~= 0 then
        if Player then
            Player:DisableBattleWheel()
        end
    end
    -- 技能禁用
    if Player then
        if FbdRule.NoSkill and FbdRule.NoSkill ~= 0 then
            Player:ForbidAllSkillsByBuff(true)
        end
        if FbdRule.NoMelee and FbdRule.NoMelee ~= 0 then
            Player:ForbidMeleeSkills(true)
        end
        if FbdRule.NoRanged and FbdRule.NoRanged ~= 0 then
            Player:ForbidRangedSkills(true)
        end
    end
end

function Component:ResetFbdRule()
    DebugPrint("ResetFbdRule", self.DungeonId)

    local DungeonData = DataMgr.Dungeon[self.DungeonId]
    if not DungeonData then
        return
    end

    local FbdRule = DungeonData.FbdRule
    if not FbdRule then
        return
    end

    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    -- 轮盘禁用
    if FbdRule.NoBattleWheel and FbdRule.NoBattleWheel ~= 0 then
        if Player then
            Player:EnableBattleWheel()
        end
    end
    -- 技能禁用
    if Player then
        if FbdRule.NoSkill and FbdRule.NoSkill ~= 0 then
            Player:ForbidAllSkillsByBuff(false)
        end
        if FbdRule.NoMelee and FbdRule.NoMelee ~= 0 then
            Player:ForbidMeleeSkills(false)
        end
        if FbdRule.NoRanged and FbdRule.NoRanged ~= 0 then
            Player:ForbidRangedSkills(false)
        end
    end
end

--region 副本UI通用加载接口
--- 加载对应副本的UI, 该接口会根据当前副本类型去加载对应的副本UI
--- 后续如果新增副本类型，先思考是否可以使用该通用接口实现功能，避免额外创建一些不必要的接口
--- 如果该接口能够实现副本UI的加载，在CommonConst.DungeonUINameMap中添加新增副本类型的UIName映射即可
function Component:LoadDungeonUI(DungeonType)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local GameModeType = self.GameModeType

    if DungeonType then
        GameModeType = string.sub(DungeonType, 7)
    else
        if GameModeType == "Region" then
            return
        end
        -- 需要手动Add到GuideBook = true
        local NeedManualAddGuideBook = true
        if self.DungeonId and Avatar:CheckIsFirstEnterDungeonType(self.DungeonId) and not self.bShown then
            self.bShown = true
            -- 第一次进入关卡正常
            local ShowGuideUISuccess = self:TryShowDungeonFirstGuide(self.GameModeType)
            NeedManualAddGuideBook = not ShowGuideUISuccess
        end

        if NeedManualAddGuideBook then
            if DataMgr.DungeonTypeToId[GameModeType] then
                local DungeonGuideId = DataMgr.DungeonTypeToId[GameModeType].GuideId
                if DungeonGuideId then
                    local RelateData = DataMgr.GuideBookConditionTwo["CompleteUIGuideId"][DungeonGuideId]
                    if RelateData then
                        for _, data in pairs(RelateData) do
                            if data.GuideNoteId and not Avatar.GuideBook[data.GuideNoteId] then
                                DebugPrint("Not UnLock Last Time", DungeonGuideId)
                                Avatar:GuideBookFinishSomething("CompleteUIGuideId", DungeonGuideId)
                                break
                            end
                        end
                    end
                end
            end
        end
    end

    -- 直接写死的UI名
    local DungeonUIName = CommonConst.DungeonUINameMap[GameModeType]

    if DungeonUIName == "Disable" then
        -- 填入"Disable"则不加载关卡UI
        -- 训练场ui自己Load，不走这套流程
        -- 其他的暂时没有关卡ui 先不走
        return
    end

    -- 由于各种原因，早期大多数副本ui都继承的UIState，与"挂载到BattleMain"的需求不太契合
    -- 后续优先考虑使用WidgetUI，这里兼容旧的和新的方式
    -- 如果读DungeonUINameMap到的是"WidgetUI"，则走WidgetUI加载方式
    if DungeonUIName == "WidgetUI" then
        self:LoadDungeonUIEMWdiget(GameModeType)
    else
        self:LoadDungeonUIState(GameModeType, DungeonUIName)
    end
end

function Component:LoadDungeonUIState(GameModeType, DungeonUIName)
    -- 策划在DungeonParamUI表中配置的UI名，如果CurDungeonUIParamID不为0且策划配了表，则load读出来的所有ui
    local ParamUINameTable = self:GetToLoadDungeonUINames()

    if ParamUINameTable then
        for _, UIName in pairs(ParamUINameTable) do
            self:RealLoadDungeonUI(UIName)
        end
    elseif DungeonUIName then
        self:RealLoadDungeonUI(DungeonUIName)
    else
        ScreenPrint("LoadDungeonUI加载对应副本UI失败，没有填写默认值！GameModeType "..GameModeType)
    end
end

function Component:RealLoadDungeonUI(DungeonUIName)
    if DungeonUIName == "DungeonHijackFloat" then
        -- wps: 推车关的UI和车本身耦合的太严重了，把UI的初始化放在车的初始化去做，不然一堆问题
        -- ljl: 只是不从这里统一Load，但要从这里UnLoad，因此单独处理（为了兼容DungeonParamUI表配置其他ui的可能性，放在这里过滤最合适）
        return
    end

    if DungeonUIName == "DungeonCaptureFloat" then
        if not UIManager(self):GetUIObj("DungeonCaptureFloat") then
            UIManager(self):LoadUINew("DungeonCaptureFloat",30,DataMgr.GlobalConstant.CaptureCountdownPoint.ConstantValue,true)
        end
        return
    end

    if not UIManager(self):GetUIObj(DungeonUIName) then
        UIManager(self):LoadUINew(DungeonUIName)
    end
end

function Component:UnloadDungeonUI(DungeonType)
    local GameModeType = self.GameModeType
    if DungeonType then
        GameModeType = string.sub(DungeonType, 7)
    else
        if GameModeType == "Region" then
            return
        end
    end

    local DungeonUIName = CommonConst.DungeonUINameMap[GameModeType]
    local ParamUINameTable = self:GetToLoadDungeonUINames()

    if ParamUINameTable then
        for _, UIName in pairs(ParamUINameTable) do
            self:RealCloseDungeonUI(UIName)
        end
    elseif DungeonUIName then
        self:RealCloseDungeonUI(DungeonUIName)
    else
        ScreenPrint("CloseDungeonUI卸载对应副本UI失败！GameModeType "..GameModeType)
    end
end

function Component:RealCloseDungeonUI(DungeonUIName)
    local DungeonUI = UIManager(self):GetUIObj(DungeonUIName)
    if DungeonUI and DungeonUI.CloseDungeonUI then
        DungeonUI:CloseDungeonUI()
    end
end

function Component:GetToLoadDungeonUINames()
	if not self:IsInRegion() then
		return
	end

	local UIParamID = self.CurDungeonUIParamID
	if not UIParamID then
		return
	end
	local UIParamData = DataMgr.DungeonUIParams[UIParamID]
	if not UIParamData then
		return
	end
	return UIParamData.UIName
end

function Component:LoadDungeonUIEMWdiget(GameModeType)
    local WidgetUIName = CommonConst.DungeonEMWidgetUINameMap[GameModeType]
    if not WidgetUIName then
        ScreenPrint("LoadDungoenUI加载对应副本WidgetUI失败，没有填写默认值！GameModeType "..GameModeType)
        return
    end

    -- 兼容一下，可以配置多个WidgetUI
    if type(WidgetUIName) == "table" then
        for _, UIName in pairs(WidgetUIName) do
            self:RealLoadDungeonUIEMWdiget(UIName)
        end
    else
        self:RealLoadDungeonUIEMWdiget(WidgetUIName)
    end
end

function Component:RealLoadDungeonUIEMWdiget(WidgetUIName)
    local EMDungeonWidget = UIManager(self):_CreateWidgetNew(WidgetUIName)
    if not EMDungeonWidget then
        ScreenPrint("LoadDungoenUI加载对应副本WidgetUI失败，创建Widget失败！WidgetUIName "..WidgetUIName)
        return
    end

    EMDungeonWidget:InitDungeonWidget()
end

--endregion

function Component:OnRep_DungeonUIInfo()
    DebugPrint("GameState:OnRep_DungeonUIInfo 客户端收到DungeonUIInfo数据", self.DungeonUIInfo.TexturePath, self.DungeonUIInfo.TextTitle, self.DungeonUIInfo.TextMap)
	self.HasDungeonUIInfoData = true
    self:RealShowDungeonTask()
end

function Component:ShowDungeonTask_Lua()
    DebugPrint("GameState:ShowDungeonTask_Lua 客户端收到DungeonUIInfo事件 之前的self.HasDungeonUIInfoEvent", self.HasDungeonUIInfoEvent)
    if self.HasDungeonUIInfoEvent then
        return
    end
    self.HasDungeonUIInfoEvent = true
    self:RealShowDungeonTask()
end

--- 展示副本的任务描述
function Component:RealShowDungeonTask()
    DebugPrint("GameState:RealShowDungeonTask 客户端是否收到数据", self.HasDungeonUIInfoData, "客户端是否收到事件", self.HasDungeonUIInfoEvent)
    if (not self.HasDungeonUIInfoData) or (not self.HasDungeonUIInfoEvent) then
        return
    end
    self.HasDungeonUIInfoData = false
    -- self.HasDungeonUIInfoEvent = false       分支先临时这么处理，客户端帧率很低的情况下，DS两次Event，客户端只会OnRep一次；另外，其实AddEvent仅需要第一次就够了，后续迭代下这个逻辑
    DebugPrint("GameState:RealShowDungeonTask 客户端更新任务栏")
    
	local WrapFuncEventFire = function()
        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
        local UIManager = GameInstance:GetGameUIManager()
        if not UIManager then
            return
        end
        local BattleMainUI = UIManager:GetUIObj("BattleMain")
        if not BattleMainUI then
            return
        end
        local RealTexturePath = UIConst.DungeonTaskPath[self.DungeonUIInfo.TexturePath] or ""
        BattleMainUI.Pos_TaskBar:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        BattleMainUI.Pos_TaskBar:GetChildAt(0):SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        BattleMainUI.Pos_TaskBar:GetChildAt(0):SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        BattleMainUI.Pos_TaskBar:GetChildAt(0):OnLoaded()
        --BattleMainUI.Pos_TaskBar:GetChildAt(0).Button_Guide:SetVisibility(ESlateVisibility.Visible)
		EventManager:FireEvent(EventID.OnReceiveTask, RealTexturePath, self.DungeonUIInfo.TextTitle, self.DungeonUIInfo.TextMap, self.DungeonUIInfo.TextWave)
	end
    WrapFuncEventFire()
end

function Component:ShowRescuePanel_Lua()
    if self.GameModeType == "Rescue" then
        self:TryToShowRescuePanel()
    end
end

function Component:UpdateSurvivalProBuffInfo_Lua()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if not UIManager then
		return
	end
    local SurvivalProUI = UIManager:GetUIObj("DungenonSurviveFloat")
    if SurvivalProUI then
        SurvivalProUI:ShowBuffInfo(self.SurvivalProBuffInfo.PathIconList,self.SurvivalProBuffInfo.TextMapList,self.SurvivalProBuffInfo.Duration)
    end
end

function Component:TryToShowRescuePanel()
	local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if (UIManager == nil ) then
		return
	end

    local RescuePanel = UIManager:GetUIObj("DungeonRescueFloat")
    if (RescuePanel) then
        RescuePanel:UIStateChange_OnTarget()
    else
        UIManager:LoadUI(UIConst.DUNGEONDEFENCEFLOAT, "DungeonRescueFloat", UIConst.ZORDER_FOR_DESKTOP_TEMP,true)
    end
end

function Component:TryShowDungeonFirstGuide(GameModeType)
	if not GWorld:IsStandAlone() then
		return false
	end
	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	if not GameMode then
		return false
	end
	if not GameMode:GetLevelLoader() then
		return false
	end
	local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if UIManager == nil then
		return false
	end
    if DataMgr.DungeonTypeToId[GameModeType] then
        GameFlowUtils:AddFlow("GuideMain", {
            GWorld.GameInstance, function(_, Flow)
                local UIStateAsyncActionBase = UE4.UUIStateAsyncActionBase.ShowGuideUI(self, DataMgr.DungeonTypeToId[GameModeType].GuideId)
                UIStateAsyncActionBase.OnGuideEnd:Add(self, function ()
                    GameFlowUtils:RemoveFlow(Flow)
                end)
            end
        })
        -- UE4.UUIStateAsyncActionBase.ShowGuideUI(self, DataMgr.DungeonTypeToId[GameModeType].GuideId)
    end
    return true
end

function Component:ShowDungeonToast_Lua(TextMapIndex, Duration, ToastType,ToastColor)
    DebugPrint("ShowDungeonToast_Lua TextMapIndex", TextMapIndex, "Duration", Duration, "ToastType", ToastType)
	local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if UIManager == nil then
		return
	end
	if ToastType == EToastType.Common then
        if ToastColor and ToastColor~=0  then
            local ExtraColor = {Color = ToastColor}
            UIManager:ShowUITip(UIConst.Tip_CommonTop, GText(TextMapIndex), Duration,nil,ExtraColor)
        else
		    UIManager:ShowUITip(UIConst.Tip_CommonTop, GText(TextMapIndex), Duration)
        end
	end

	if ToastType == EToastType.Warning then
		UIManager:ShowUITip(UIConst.Tip_CommonWarning, GText(TextMapIndex), Duration,nil,TextMapIndex)
	end

	if ToastType == EToastType.SpecialQuestStart then
		UIManager:LoadUINew("ExploreToastTips", TextMapIndex)
	end

	if ToastType == EToastType.Success then
		UIManager:LoadUINew("ExploreToastSuccess", TextMapIndex)
	end

	if ToastType == EToastType.Failed then
		UIManager:LoadUINew("ExploreToastFail", TextMapIndex)
	end

    if ToastType == EToastType.Treasure then
        if UIManager:GetUIObj("TreasureToast") then
            UIManager:UnLoadUINew("TreasureToast")
        end
        UIManager:LoadUINew("TreasureToast",GText(TextMapIndex),Duration)
    end

    if ToastType == EToastType.SabotageAlarm then
        local ToastUI = UIManager:LoadUINew("DestoryAlarm")
        if ToastUI then
            ToastUI:InitializeData(Duration, true)
        end
    end
end

-- 目前仅支持WarningToast
function Component:UnShowDungeonToast_Lua(Key,ToastType)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if UIManager == nil then
		return
	end
	if ToastType == EToastType.Warning then
		UIManager:HideWarningUITip(Key)
	end
end

function Component:ShowCountDownUI_Lua(TextMap,CountDownTime,EnterWarningTime)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if UIManager == nil then
		return
	end
    local CountDownUI = UIManager:LoadUINew("DungeonCaptureFloat",CountDownTime,EnterWarningTime)
    if (CountDownUI) then
        CountDownUI:SetTextFromGameMode(TextMap)
        CountDownUI:UIStateChange_OnTarget()
    end
end

function Component:HideCountDownUI_Lua(TextMap)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if UIManager == nil then
		return
	end
    local CountDownUI = UIManager:GetUIObj("DungeonCaptureFloat")
    if CountDownUI and CountDownUI.KeyToHideSelf == TextMap then
        UIManager:UnLoadUINew("DungeonCaptureFloat")
    end
end

function Component:ShowRankStarUI_Lua(TextMapTitle, TextMapStar3, TextMapStar2, TextMapStar1, TimerHandle, TimerStar3, TimeStar2, TimeStar1)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if UIManager == nil then
		return
	end
    local BattleMainUI = UIManager:GetUIObj("BattleMain")
    if not BattleMainUI then
        DebugPrint("zzwwkk ShowRankStarUI_Lua BattleMainUI is nil")
        return
    end
    self.RankStarUI = UIManager:_CreateWidgetNew("DungeonCommonRankStar")
    self.RankStarUI:InitWidgetUI(TextMapTitle, TextMapStar3, TextMapStar2, TextMapStar1, TimerHandle, TimerStar3, TimeStar2, TimeStar1)
    BattleMainUI.Group_Temple:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    BattleMainUI.Pos_TempleRight:ClearChildren()
	BattleMainUI.Pos_TempleRight:AddChildToOverlay(self.RankStarUI)
end

function Component:UnShowRankStarUI_Lua()
    if self.RankStarUI then
        self.RankStarUI:RemoveFromParent()
        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
        local UIManager = GameInstance:GetGameUIManager()
        if UIManager == nil then
            return
        end
        local BattleMainUI = UIManager:GetUIObj("BattleMain")
        if BattleMainUI then
            BattleMainUI.Group_Temple:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end
end

function Component:ShowRankStarScoreUI_Lua(TextMapTitle, TextMapStar3, TextMapStar2, TextMapStar1, ScoreStar3, ScoreStar2, ScoreStar1, InitScore)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if UIManager == nil then
		return
	end
    local BattleMainUI = UIManager:GetUIObj("BattleMain")
    if not BattleMainUI then
        DebugPrint("zzwwkk ShowRankStarUI_Lua BattleMainUI is nil")
        return
    end
    self.RankStarUI = UIManager:_CreateWidgetNew("DungeonCommonRankStar")
    self.RankStarUI:InitWidgetUIScore(TextMapTitle, TextMapStar3, TextMapStar2, TextMapStar1, ScoreStar3, ScoreStar2, ScoreStar1, InitScore)
    BattleMainUI.Group_Temple:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    BattleMainUI.Pos_TempleRight:ClearChildren()
	BattleMainUI.Pos_TempleRight:AddChildToOverlay(self.RankStarUI)
end

function Component:ShowBuffInfo_Lua(PathIconList, TextMapList, Duration)
	local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if UIManager == nil then
		return
	end

	local TaskPanel = UIManager:GetUIObj("DungenonSurviveFloat")
	if not TaskPanel then
		return
	end
	TaskPanel:ShowBuffInfo(PathIconList, TextMapList, Duration)
end

function Component:FireEventBuffChange_Lua(BuffId, bAdd, Eid)
    if not GWorld.GameInstance or not GWorld.Battle or Eid == nil then
        return
    end
    
    local Entity = Battle(GWorld.GameInstance):GetEntity(Eid)
    if Entity and rawget(Entity, "TeammateUI") then
        local TeammateUI = rawget(Entity, "TeammateUI")
        TeammateUI:ShowShortageUI(BuffId, bAdd)
    end
end

function Component:OnActiveSurvivalTime_Lua()
	if IsAuthority(self) then
		self:SetDungeonUIState(Const.EDungeonUIState.OnTarget)
	end
end

-- OnCustomEvent调过来的 'On'..EventName..'_Lua' 拼接而成
function Component:OnDefenceWaveStart_Lua()
    -- AudioManager(self):PlayUISound(nil, "event:/ui/common/battle_warning", nil, nil)
    -- 写这里有问题 这个逻辑只有客户端走，移到GameMode组件上了
	-- if IsAuthority(self) then
	-- 	self:SetDungeonUIState(Const.EDungeonUIState.OnTarget)
	-- end
    EventManager:FireEvent(EventID.OnDefenseWaveStart)
    for Eid, DefenceCore in pairs(self.DefBaseMap) do
		if IsValid(DefenceCore) then
            DefenceCore:OnDefenceWaveStart()
        end
    end
end

function Component:OnDefenceWaveEnd_Lua()
    AudioManager(self):PlayUISound(nil, "event:/ui/common/battle_stage_success",nil,nil)
    EventManager:FireEvent(EventID.OnDefenceWaveEnd)
    for Eid, DefenceCore in pairs(self.DefBaseMap) do
		if IsValid(DefenceCore) then
            DefenceCore:OnDefenceWaveEnd()
        end
    end
end

function Component:UpdateDungeonVote_Lua(VoteValues)
    local MainPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
    EventManager:RemoveEvent(EventID.OnDungeonVoteBegin, self)
    if not self.IsCanFreshDungeonEvent then
        EventManager:AddEvent(EventID.OnDungeonVoteBegin, self, self.UpdateDungeonVote_Lua)
        return
    end
    if VoteValues:Length() == 0 and UIManager(self):GetUIObj("Vote") then
        -- @LXZ 联机时先触发结算清空VoteValue，同步触发此逻辑
        if MainPlayer then
            print(_G.LogTag,"LXZ  UpdateDungeonVote_Lua Clear VoteValues")
            MainPlayer:TriggerFreezeMove(false)
        end
        EventManager:FireEvent(EventID.OnRepDungeonVoteInterval)
        return
    end
    print(_G.LogTag,"LXZ  UpdateDungeonVote_Lua", VoteValues)
    if VoteValues:FindRef(MainPlayer.Eid) == EVoteState.Forbid then
        return
    end
    print(_G.LogTag,"LXZ  UpdateDungeonVote_Lua Load Vote bushiren")

    if not UIManager(self):GetUIObj("Vote") and not GWorld.GameInstance:IsInTempScene() then
        local NeedVote = false
        for i = 1, self.DungeonEvent:Num() do
            local Event = self.DungeonEvent:GetValueByIdx(i-1)
            if Event == "OnDungeonVoteBegin" then
                NeedVote = true
            end
        end
        if not NeedVote then
            return
        end
        for Eid, Value in pairs(VoteValues) do
            if Value ~= EVoteState.Wait then
                return
            end
        end
        if MainPlayer then
            print(_G.LogTag,"LXZ  UpdateDungeonVote_Lua Load Vote")
            MainPlayer:TriggerFreezeMove(true)
        end
        UIManager(self):LoadUINew("Vote")
    elseif UIManager(self):GetUIObj("Vote") then
        EventManager:FireEvent(EventID.UpdateDungeonValues, VoteValues)
        if not IsDedicatedServer(self) and IsAuthority(self) then
            -- @SnowMoon 不考虑联机，直接触发结算
            -- @LXZ 单机时先触发此逻辑，再手动触发结算
            EventManager:FireEvent(EventID.OnRepDungeonVoteInterval)
            self:DealDungeonVoteResult()
        end
    end
end

function Component:UpdateDungeonLoadingProgress()
    self.LoadingProgressInfo = 0
    if self.LevelLoaderReady then
        self.LoadingProgressInfo = self.LoadingProgressInfo + 50
    end
     self.LoadingProgressInfo = self.LoadingProgressInfo + 40 * self:GetPreloadProgress()
    if self.bGameModeReady then
        self.LoadingProgressInfo = self.LoadingProgressInfo + 1
    end
    if self.PlayerReady then
        self.LoadingProgressInfo = self.LoadingProgressInfo + 2
    end
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UI = GameInstance:GetLoadingUI()
    if UI then
        UI:AddQuene(self.LoadingProgressInfo)
    end
end

function Component:TryEndLoading(Reason)
    if not self.LevelLoaderReady then
        if self:GetCurrentLevelLoader() then
            self.LevelLoaderReady = false
        else
            self.LevelLoaderReady = true
        end
    else
        -- 只有当levelload准备好以后才会更新其他参数增长的进度条，90%是区分
        -- self.bGameModeReady = 1
        -- self.PlayerReady = 2
        -- self.IsPreloadGameAssetsReady = 40
        self:UpdateDungeonLoadingProgress()
    end
    print(_G.LogTag, "TryEndLoading", self.PlayerReady, self.bGameModeReady, self.LevelLoaderReady, self:IsPreloadGameAssetsReady(), Reason,self.DungeonId)
    if self.PlayerReady and self.LevelLoaderReady and self:NeedPreloadGameAssets() then
        self:PreloadGameAssets()
    end

	if self.bGameModeReady and self.LevelLoaderReady and self:IsPreloadGameAssetsReady() and self:IsPreloadGameAssetsReady() then
		self:PreCreateUnit()
	end

    if IsDedicatedServer(self) then
        local PreloadSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UE4.URolePreloadGameInstanceSubsystem)
        if PreloadSystem then
            PreloadSystem:DSLoadBT()
        end
    end

    if self.bGameModeReady and self.LevelLoaderReady  and self:IsPreloadGameAssetsReady() and self.bRegionPreCreateUnitReady then
        -- LS模式Master的PlayerReady只会在服务端执行
		if (self.PlayerReady or MiscUtils.IsListenServer(self)) and not self.EndLoadingSuccess then
            self.EndLoadingSuccess = true  -- 防止重入
			local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
			PlayerController:NotifyServerClientReady()
			local WorldCompositionSubSystem = UE4.USubsystemBlueprintLibrary.GetWorldSubsystem(self, UE4.UWorldCompositionSubSystem)
			if WorldCompositionSubSystem then
				local SubSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, URegionDataMgrSubsystem:StaticClass())
				if SubSystem then
					SubSystem:SetRegionInitState(ERegionInitState.RegionEntityCreating)
				end
				WorldCompositionSubSystem:TickAsyncQueueReady()
			else
				local SubSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, URegionDataMgrSubsystem:StaticClass())
				if SubSystem then
					SubSystem:SetRegionInitState(ERegionInitState.AllReady)
				end
			end
             -- 关Loading后开启同步加载优化
            --  print(_G.LogTag, "SetSyncLoaderOptimization True")
            --  GWorld.GameInstance:SetSyncLoaderOptimization(true)
        else
            self.EndLoadingSuccess = false
        end
    end
end

function Component:PreCreateUnit()
	if not self:RegionNeedPreCreateUnit() then
		self.bRegionPreCreateUnitReady = true
		return
	end
	local WorldCompositionSubSystem = UE4.USubsystemBlueprintLibrary.GetWorldSubsystem(self, UE4.UWorldCompositionSubSystem)
	if not WorldCompositionSubSystem then
		self.bRegionPreCreateUnitReady = true
		return
	end
	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	if not GameMode then
		self.bRegionPreCreateUnitReady = true
		return
	end
	GameMode:GetRegionDataMgrSubSystem():OnInitRecoverRegionData(false)
	WorldCompositionSubSystem:PreCreateUnit()
end

function Component:IsPreloadGameAssetsReady()
    local PreloadSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UE4.URolePreloadGameInstanceSubsystem)
    if not PreloadSystem or not PreloadSystem:EnableOptimization() then
        return true
    end
    return self.bPreloadAssetsReady 
end

function Component:GetPreloadProgress()
    local PreloadSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UE4.URolePreloadGameInstanceSubsystem)
    if not PreloadSystem or not PreloadSystem:EnableOptimization() or self.bPreloadAssetsReady then
        return 1.0
    end
    return PreloadSystem:GetAsyncLoadingProgress()
end

function Component:NeedPreloadGameAssets()
    return not self:IsPreloadGameAssetsReady() and not self.bAssetsPreloading
end

function Component:PreloadGameAssets()
    local PreloadSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UE4.URolePreloadGameInstanceSubsystem)
    if not PreloadSystem then
        self.bPreloadAssetsReady = true
        self.bAssetsPreloading = false
        return
    end

    local UnitBudgetSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UE4.UUnitBudgetAllocatorSubsystem)
    if UnitBudgetSystem then
        -- 自走棋跳过EnableAnimCache
        if self:IsInDungeon() then
            local DungeonId = GWorld.GameInstance:GetCurrentDungeonId()
            local DungeonInfo = DataMgr.Dungeon[DungeonId]
            if DungeonInfo and DungeonInfo.DungeonType == "AutoChess" then
                print(_G.LogTag, "wzj- 自走棋跳过EnableAnimCache")
                UnitBudgetSystem:SetEnableAnimCache(false)
            else
                print(_G.LogTag, "wzj- 打开EnableAnimCache")
                UnitBudgetSystem:SetEnableAnimCache(true)
            end
        else
            print(_G.LogTag, "wzj- 打开EnableAnimCache")
            UnitBudgetSystem:SetEnableAnimCache(true)
        end

        local bSkip = false
        if IsClient(self) then
            bSkip = true
        else
            local MainPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
            if MainPlayer then
                for _, ConfigId in ipairs(Const.SkipShadowBudgetConfig) do
                    if MainPlayer.CurrentRoleId == tonumber(ConfigId) then
                        bSkip = true
                        break
                    end
                end
            end

            if bSkip == false and MainPlayer and MainPlayer.GetPhantomTeammates then
                for i, Phantom in pairs(MainPlayer:GetPhantomTeammates()) do
                    if Phantom then
                        for _, ConfigId in ipairs(Const.SkipShadowBudgetConfig) do
                            if Phantom.CurrentRoleId == tonumber(ConfigId) then
                                bSkip = true
                                break
                            end
                        end
                    end
                    if bSkip then
                        break
                    end
                end
            end
        end

        if self:IsInDungeon() and bSkip == false then
            UnitBudgetSystem:UpdateDynamicShadowBudget(false)
        else
            UnitBudgetSystem:UpdateDynamicShadowBudget(true)
        end
    end

    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local PhantomTable = Player and Player:GetPhantomTeammates(false,false):ToTable() or {}
    -- 切场景之后清除所有预加载的数据和UObject
    -- 这里算是个保底，以防切场景前的缓存数据没有被正确释放
    -- 注意：所有预加载的资源都要在这个阶段之后，否则会被错误清除。

    local SkipPlayerId = Player and Player.CurrentRoleId or 0
    if Player.GetCharPreloadComp and Player:GetCharPreloadComp() then
        if Player:GetCharPreloadComp():GetPlayerCacheLoadId() > 0 then
            SkipPlayerId = Player:GetCharPreloadComp():GetPlayerCacheLoadId()
        end
    end

    -- todo
    -- PreloadSystem:ReleaseAllCacheBeforeChangeScene({SkipPlayerId})
    PreloadSystem:ReleaseAllCacheBeforeChangeScene(UE.TArray(0))
    PreloadSystem:ReleaseAllCacheObj(false)
    PreloadSystem:PreloadScatteredAsset_All()
    if Player and Player.DelayCacheLoadPlayerAssets == true then
        if not PreloadSystem:IsRoleAssetCached(Player.CurrentRoleId) then
             Player:GetCharPreloadComp():CacheLoadAssets()
        end
        -- 清除了所有预加载数据后，如果这里有魅影(阵容预设)，那魅影的预加载资产一定是空的
        for _,Phantom in pairs(PhantomTable) do
            Phantom:GetCharPreloadComp():PreloadAssets({})
        end
    end

    local DungeonId = GWorld.GameInstance:GetCurrentDungeonId()
    if self:IsInDungeon() then
        PreloadSystem:PreloadScatteredAsset_Dungeon(DungeonId or 0)
    elseif self:IsInRegion() then
        PreloadSystem:PreloadScatteredAsset_Region()
    end

    if DungeonId == nil  or DungeonId == -1 then
        print(_G.LogTag, "wzj- 副本资源预加载 StartEnd", UE4.UGameplayStatics.GetTimeSeconds(self), DungeonId)
        self.bPreloadAssetsReady = true
        self.bAssetsPreloading = false
        return
    end

	print(_G.LogTag, "wzj- 副本资源预加载 Start", UE4.UGameplayStatics.GetTimeSeconds(self), DungeonId)

    self.bPreloadAssetsReady = false
    self.bAssetsPreloading = true
    local Res = PreloadSystem:CacheDungeonGameAssetsOuter({self,self.PreloadGameAssetsCallback})
    -- local Res = PreloadSystem:CacheDungeonGameAssetsOuter_Test(self.PreloadGameAssetsCallback)
    if not Res then
        self:PreloadGameAssetsCallback()
    end
end

function Component:PreloadGameAssetsCallback()
	print(_G.LogTag, "wzj- 副本资源预加载 End", UE4.UGameplayStatics.GetTimeSeconds(self), GWorld.GameInstance:GetCurrentDungeonId())

    self.bPreloadAssetsReady = true
    self.bAssetsPreloading = false
    self:TryEndLoading("AssetsPreload")
end

--------------------------------------------------------

--- Pet

function Component:ShowPetDefenseDynamicEvent_Lua()
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local BattleMain = UIManager:GetUIObj("BattleMain")
    if BattleMain then
        local DynamicEventUI=BattleMain:GetOrAddDynamicEventWidget()
        DynamicEventUI:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        DynamicEventUI:PetPlayInAnim()
        DynamicEventUI:SetEventInfo(self.PetEventName, self.PetEventDescribe)
        DynamicEventUI:HidePetProgressRoot()
        DynamicEventUI.Name:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function Component:ShowPetDefenseProgress_Lua()
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local BattleMain = UIManager:GetUIObj("BattleMain")
    if BattleMain then
        local DynamicEventUI=BattleMain:GetOrAddDynamicEventWidget()
        DynamicEventUI:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        DynamicEventUI:PlayAnimation(DynamicEventUI.Get_In)
        DynamicEventUI:SetEventInfo(self.PetEventName, self.PetEventDescribe)
		DynamicEventUI:ShowPetProgress()
		self:PetCaputreDefenceWidgetShow()
    end
end

function Component:RemoveShowPetDefenseProgress_Lua()
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local BattleMain = UIManager:GetUIObj("BattleMain")
    if BattleMain then
        local DynamicEventUI=BattleMain:GetOrAddDynamicEventWidget()
		DynamicEventUI:HidePetProgress(self.PetEventSuccess, self.PetEventFail, self.PetSuccess)
		self:PetCaputreDefenceWidgetHide()
    end
end

function  Component:PetPlayFailureMontage_Lua()
    local DefencePet = self:GetNpcInfo(self.PetId)
    if IsValid(DefencePet) then
        DefencePet:PlayFailureMontageThenDestroy()
    end
end

function Component:PetAddGuideAllPlayer()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    for i, Player in pairs(GameMode:GetAllPlayer()) do
        DebugPrint("=======================PetAddGuideAllPlayer=========IsInHidePetPlayers====Player.Eid:",self:IsInHidePetPlayers(Player.Eid),Player.Eid)
        if self:IsInHidePetPlayers(Player.Eid) == false then
            self:PetAddGuide(Player.Eid)
        end
    end
end

function Component:PetAddGuide(PlayerEid)
    local Pet = self:GetNpcInfo(self.PetId)
    DebugPrint("================================PetAddGuide======Pet.Eid, Player.Eid:",Pet.Eid, PlayerEid)
    self:AddGuideEid(Pet.Eid, PlayerEid)
end

function Component:PetRemoveGuide(PetEid)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    DebugPrint("=======================================PetRemoveGuide===PetEid,Player.Eid=",PetEid,Player.Eid)
    self:RemoveGuideEid(PetEid, Player.Eid)
end

function Component:UpdatePetDefenseProgress()
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local BattleMain = UIManager:GetUIObj("BattleMain")
    if BattleMain then
        local DynamicEventUI=BattleMain:GetOrAddDynamicEventWidget()
		DynamicEventUI:UpdatePetProgress()
		self:PetCaputreDefenceWidgetUpdate()
    end
end

function Component:PetDefenceCoreDestory()
    local DefenceCore = self:GetDefenceCore(self.PetDefenceCoreId)
    if DefenceCore then
        DefenceCore:K2_DestroyActor()
    end
end

function Component:PetCaputreDefenceWidgetShow()
    local DefenceCore = self:GetDefenceCore(self.PetDefenceCoreId)
    if IsValid(DefenceCore) and DefenceCore.PetCaptureDefense then
        self:PetCaputreDefenceWidgetUpdateByDefenceCore(DefenceCore)
        DefenceCore.PetCaptureDefense:SetHiddenInGame(false)
        -- DefenceCore.PetCaptureDefense.PetRoot = DefenceCore.PetRoot
        self.PetDefenceCore = DefenceCore
        if not self:IsExistTimer("PetCaptureWidget") then
            self:AddTimer(0.02, self.UpdatePetWidgetRotation, true, 0, "PetCaptureWidget")
        end
    end
end

function Component:PetCaputreDefenceWidgetHide()
    local DefenceCore = self:GetDefenceCore(self.PetDefenceCoreId)
    if IsValid(DefenceCore) and DefenceCore.PetCaptureDefense then
        local Widget = DefenceCore.PetCaptureDefense:GetWidget()
        Widget:PlayAnimation(Widget.Out)
        -- DefenceCore.PetCaptureDefense.PetRoot = nil
        self.PetDefenceCore = nil
        self:RemoveTimer("PetCaptureWidget")
    end
end

function Component:UpdatePetWidgetRotation()
    if IsValid(self.PetDefenceCore) and self.PetDefenceCore.PetCaptureDefense and self.PetDefenceCore.PetRoot then
        local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
        local PlayerLocation = Player:K2_GetActorLocation()
        local SelfLocation = self.PetDefenceCore:K2_GetActorLocation()
        PlayerLocation.Z = 0
        SelfLocation.Z = 0
        local Dir = PlayerLocation - SelfLocation
        local Forward = self.PetDefenceCore:GetActorForwardVector()
        Forward.Z = 0
        Dir:Normalize()
        Forward:Normalize()
	    local Angle = Dir:Dot(Forward)
        local Cross = Dir:Cross(Forward)
        local OnRight = Cross.Z < 0
        local Degree = UE.UKismetMathLibrary.DegAcos(Angle)
        if OnRight == false then
            Degree = 360 - Degree
        end
        self.PetDefenceCore.PetRoot:K2_SetRelativeRotation(FRotator(0, Degree, 0), false, nil, true)
        self.PetDefenceCore:UpdatePetFXRotation(Degree)
    end
end

function Component:PetCaputreDefenceWidgetUpdate()
    local DefenceCore = self:GetDefenceCore(self.PetDefenceCoreId)
    self:PetCaputreDefenceWidgetUpdateByDefenceCore(DefenceCore)
end

function Component:PetCaputreDefenceWidgetUpdateByDefenceCore(DefenceCore)
    if IsValid(DefenceCore) and DefenceCore.PetCaptureDefense then
        local Widget = DefenceCore.PetCaptureDefense:GetWidget()
        local TotalVal = DataMgr.GlobalConstant.PetDefenceMonsterNum.ConstantValue
        local Rate = self.PetDefenceKilledNum / TotalVal
        Rate = math.min(Rate, 1)
        DefenceCore:UpdatePetFXProgress(Rate)
        Widget.Text_Process:SetText(math.floor(Rate * 100))
    end
end

function Component:GetDefenceCore(UnitId)
    local Mechanisms = self.MechanismMap:FindRef('DefenceCore')
	if Mechanisms ~= nil then
		Mechanisms = Mechanisms.Array
		for _, Mechanism in pairs(Mechanisms:ToTable()) do
			if Mechanism.UnitId == UnitId then
                return Mechanism
            end
		end
	end
    return nil
end

function Component:OnRep_PetDefenceKilled()
    self:UpdatePetDefenseProgress()
    self:MarkPetDefenceKilledNumAsDirtyData()
end

----------------------------------------------------------------

-----------------------选门票相关-----------------------------
function Component:SelectTicket_Lua()
    print(_G.LogTag,"LXZ SelectTicket")
    if IsStandAlone(self) then
        local DungeonId = GWorld.GameInstance:GetCurrentDungeonId()
        local function OnRightConfirm(_, PackageData)
            local Avatar = GWorld:GetAvatar()
            if not Avatar then return end
            Avatar:SelectTicket(nil, DungeonId, PackageData.Content_1.TicketId)
            local GameMode = UE4.UGameplayStatics.GetGameMode(self)
            GameMode:RemoveDungeonEvent("SelectTicket")
            GameMode:ExecuteNextStepOfTicket()
        end
        if self:CheckAvatarHasTicket() then
            local CommonDialog = UIManager(self):ShowCommonPopupUI(100252, {
                DungeonId = DungeonId,
                RightCallbackObj = self,
                RightCallbackFunction = OnRightConfirm,
                ForbiddenRightCallbackObj = self,
                AutoFocus = true,
                DisableEscClose = true
            }, self)
            EventManager:AddEvent(EventID.OnSelectTicketTimeout, self, self.OnSelectTicketTimeout)
        else
            OnRightConfirm(_, {Content_1 = {TicketId = 0}})
        end
    else
        local DungeonId = GWorld.GameInstance:GetCurrentDungeonId()
        local function OnRightConfirm(_, PackageData)
            local Avatar = GWorld:GetAvatar()
            if not Avatar then 
                return 
            end
            Avatar:SelectTicket(nil, DungeonId, PackageData.Content_1.TicketId)
            local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
            local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
            PlayerCharacter.RPCComponent:SendDungeonTicket(PlayerCharacter.Eid, true)
        end
        
        print(_G.LogTag,"LXZ SelectTicket OnRep_NextTicketPlayer", self.IsInSelectTicket, NeedVote)
        if self:CheckAvatarHasTicket() then
            local CommonDialog = UIManager(self):ShowCommonPopupUI(100252, {
                DungeonId = DungeonId,
                RightCallbackObj = self,
                RightCallbackFunction = OnRightConfirm,
                ForbiddenRightCallbackObj = self,
                DontCloseWhenRightBtnClicked = true,
                DisableEscClose = true
            }, self)
            EventManager:AddEvent(EventID.OnSelectTicketTimeout, self, self.OnSelectTicketTimeout)
        else
            OnRightConfirm(_, {Content_1 = {TicketId = 0}})
        end
    end
end

function Component:RemoveSelectTicket_Lua()
    print(_G.LogTag,"LXZ SelectTicket RemoveSelectTicket_Lua", IsClient(self))
    if IsClient(self) then
        EventManager:FireEvent(EventID.DungeonSelectTicketEnd)
    end
end

function Component:OnRep_NextTicketPlayer()
    -- local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    -- local Eid = Player.Eid
    -- local ClientRes = self.NextTicketPlayer:Find(Eid)
    -- if ClientRes ~= false or UIManager(self):GetUIObj("CommonDialog") then
    --     for i, v in pairs(self.NextTicketPlayer) do
    --         if not v then
    --             return
    --         end
    --     end
    --     EventManager:FireEvent(EventID.DungeonSelectTicketEnd)
    -- end
end

function Component:CheckAvatarHasTicket()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then 
        return false
    end
    local DungeonInfo = DataMgr.Dungeon[self.DungeonId]
	if not DungeonInfo or not DungeonInfo.TicketId then
		return false
	end
    if DungeonInfo and DungeonInfo.NoTicketEnter then
        return true
    end
    for i, v in pairs(DungeonInfo.TicketId) do
        local ResourceServerData = Avatar.Resources[v]
        if ResourceServerData and ResourceServerData.Count and ResourceServerData.Count > 0 then
            return true
        end
    end
    return false
end

function Component:OnSelectTicketTimeout(TicketId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local DungeonId = GWorld.GameInstance:GetCurrentDungeonId()
    if IsStandAlone(self) then
        Avatar:SelectTicket(nil, DungeonId, TicketId)
        local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        GameMode:ExecuteNextStepOfTicket()
    else
        Avatar:SelectTicket(nil, DungeonId, TicketId)
        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
        local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
        PlayerCharacter.RPCComponent:SendDungeonTicket(PlayerCharacter.Eid, true)
    end
end

function Component:UpdateDungeonTicket_Lua(NextTicketPlayer)
    if not IsAuthority(self) then
        return
    end
    print(_G.LogTag,"LXZ SelectTicket UpdateDungeonTicket_Lua")
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    for _, Player in pairs(GameMode:GetAllPlayer()) do
        print(_G.LogTag,"LXZ SelectTicket UpdateDungeonTicket_Lua111", Player.Eid, NextTicketPlayer:Find(Player.Eid))
        if not NextTicketPlayer:Find(Player.Eid) then
            return
        end
    end
    GameMode:BpDelTimer("SelectTicket", false, Const.GameModeEventServerClient)
    GameMode:RemoveDungeonEvent("SelectTicket")
    self.NextTicketPlayer:Clear()
    UE.UMapSyncHelper.SyncMap(self, "NextTicketPlayer")
    GameMode:ExecuteNextStepOfTicket()
end
-------------------------------------------------------------

-----------------------核桃相关-----------------------------

function Component:ShowWalnutReward_Lua()
    DebugPrint("WalnutReward ShowWalnutReward_Lua")
    if not UIManager(self):GetUIObj("WalnutReward") then
        UIManager(self):LoadUINew("WalnutReward")
    end
end

function Component:RemoveShowWalnutReward_Lua()
    DebugPrint("WalnutReward RemoveShowWalnutReward_Lua")
    local WalnutRewardUI = UIManager(self):GetUIObj("WalnutReward")
    if WalnutRewardUI then
        WalnutRewardUI:Close()
    end
end

function Component:OnRep_WalnutRewardPlayer()
    DebugPrint("WalnutReward OnRep_WalnutRewardPlayer")
    -- local WalnutRewarPlayer = self.WalnutRewardPlayer:ToTable()
    -- PrintTable(WalnutRewarPlayer)
    local WalnutRewardUI = UIManager(self):GetUIObj("WalnutReward")
    if WalnutRewardUI then
        WalnutRewardUI:ReceiveWalnutRewardChoose()
    end
end

function Component:NextWalnut_Lua()
    DebugPrint("DungeonWalnutChoice NextWalnut_Lua")
    -- if IsStandAlone(self) then
        if not UIManager(self):GetUIObj("WalnutChoice") then
            local WalnutChoiceUI = UIManager(self):LoadUINew("WalnutChoice", CommonConst.WalnutUser.Dungeon)
            local WalnutUtils = require "BluePrints.UI.WBP.Walnut.WalnutChoice.WalnutUtils"
            local WalnutId = WalnutUtils:GetWalnutCacheIdByDungeonId(self.DungeonId)
            WalnutChoiceUI:SelectWalnutById(WalnutId)
        end
    -- end
end

function Component:RemoveNextWalnut_Lua()
    DebugPrint("DungeonWalnutChoice RemoveNextWalnut_Lua")
    local WalnutChoiceUI = UIManager(self):GetUIObj("WalnutChoice")
    if WalnutChoiceUI then
        if IsStandAlone(self) then
            WalnutChoiceUI:Close()
        else
            WalnutChoiceUI:PlayWalnutReady()
        end
    end
end

function Component:WalnutReady_Lua()
    DebugPrint("WalnutReady_Lua")
end

function Component:RemoveWalnutReady_Lua()
    DebugPrint("DungeonWalnutChoice RemoveWalnutReady_Lua")
    local WalnutChoiceUI = UIManager(self):GetUIObj("WalnutChoice")
    if WalnutChoiceUI then
        WalnutChoiceUI:Close()
    end
end

function Component:OnRep_NextWalnutPlayer()
    DebugPrint("DungeonWalnutChoice OnRep_NextWalnutPlayer")
    local NextWalnutPlayer = self.NextWalnutPlayer:ToTable()
    PrintTable(NextWalnutPlayer)
    local WalnutChoiceUI = UIManager(self):GetUIObj("WalnutChoice")
    if WalnutChoiceUI then
        WalnutChoiceUI:ReceiveTeammateChoose(NextWalnutPlayer)
    -- else
        -- WalnutChoiceUI = UIManager(self):LoadUINew("WalnutChoice", CommonConst.WalnutUser.Dungeon)
        -- WalnutChoiceUI:InitTeamHeads(NextWalnutPlayer)
    end
end

-----------------------核桃相关END--------------------------




-----------------------大秘境相关-----------------------------

-- 策划希望使用新接口（外面包了一层）时，才显示新ui
-- 使用原来的配置方法时，显示旧ui
-- 新的接口写死HandleName，AbyssBattleNew代表是用新接口开启的定时器
function Component:AbyssBattleNew_Lua()
    DebugPrint("AbyssBattleNew_Lua")
    local AbyssCountDownUI = UIManager(self):GetUIObj("Abyss_CountDown_Progress")
    if not AbyssCountDownUI then
        AbyssCountDownUI = UIManager(self):LoadUINew("Abyss_CountDown_Progress")
    end
    AbyssCountDownUI:ShowAbyssCountDown("AbyssBattleNew")
end

function Component:RemoveAbyssBattleNew_Lua()
    DebugPrint("RemoveAbyssBattleNew_Lua")
    local AbyssCountDownUI = UIManager(self):GetUIObj("Abyss_CountDown_Progress")
    if not AbyssCountDownUI then
        return
    end
    AbyssCountDownUI:HideAbyssCountDown("AbyssBattleNew")
end

function Component:AbyssBattle_Lua()
    DebugPrint("AbyssBattle_Lua")
    local AbyssCountDownUI = UIManager(self):GetUIObj("Abyss_CountDown")
    if not AbyssCountDownUI then
        AbyssCountDownUI = UIManager(self):LoadUINew("Abyss_CountDown")
    end
    AbyssCountDownUI:ShowAbyssCountDown("AbyssBattle")
end

function Component:RemoveAbyssBattle_Lua()
    DebugPrint("RemoveAbyssBattle_Lua")
    local AbyssCountDownUI = UIManager(self):GetUIObj("Abyss_CountDown")
    if not AbyssCountDownUI then
        return
    end
    AbyssCountDownUI:HideAbyssCountDown("AbyssBattle")
end

function Component:AbyssNextRoom_Lua()
    DebugPrint("AbyssNextRoom_Lua")
    local AbyssCountDownUI = UIManager(self):GetUIObj("Abyss_CountDown")
    if not AbyssCountDownUI then
        AbyssCountDownUI = UIManager(self):LoadUINew("Abyss_CountDown")
    end
    AbyssCountDownUI:ShowAbyssCountDown("AbyssNextRoom")
end

function Component:RemoveAbyssNextRoom_Lua()
    DebugPrint("RemoveAbyssNextRoom_Lua")
    local AbyssCountDownUI = UIManager(self):GetUIObj("Abyss_CountDown")
    if not AbyssCountDownUI then
        return
    end
    AbyssCountDownUI:HideAbyssCountDown("AbyssNextRoom")
end


-----------------------大秘境相关END-----------------------------

--region 派对玩法相关
function Component:PartyWaitPlayerEnter_Lua()
    local PartyWaitUI = UIManager(self):GetUIObj("DungeonCaptureFloat")
    if not PartyWaitUI then
        PartyWaitUI = UIManager(self):LoadUINew("DungeonCaptureFloat", 60)
    end
    PartyWaitUI:InitPartyWaitUI()
end

function Component:RemovePartyWaitPlayerEnter_Lua()
    local PartyWaitUI = UIManager(self):GetUIObj("DungeonCaptureFloat")
    if not PartyWaitUI then
        return
    end
    PartyWaitUI:ClosePartyWaitUI()
end

function Component:OnRep_PartyTime()
    -- 更新派对UI
    local Eid = UGameplayStatics.GetPlayerCharacter(self, 0).Eid
    local CompletionRate = 0
    local NumOfPlayers = 1
    if self.PartyPlayerDisPercent.Items:Num() ~= 0 then
        CompletionRate = self.PartyPlayerDisPercent.Items[Eid].Value
        NumOfPlayers = self.PartyPlayerDisPercent.Items:Num()
    end

    -- 计算当前玩家的排名
    local PlayerRank = 1
    for Id, Rate in pairs(self.PartyPlayerDisPercent.Items) do
        if Id ~= Eid and Rate.Value > CompletionRate then
            PlayerRank = PlayerRank + 1
        end
    end

    -- 时间
    EventManager:FireEvent(EventID.OnUpdatePartyLeftUI, self.PartyTime)

    -- 排名以及完成率
    EventManager:FireEvent(EventID.OnUpdatePartyRightUI, CompletionRate, PlayerRank, NumOfPlayers)
end

function Component:OnPartyPlayerGetBuff(Eid, BuffId, IsPositive, Time)
    EventManager:FireEvent(EventID.OnPartyPlayerGetBuff, Eid, BuffId, IsPositive, Time)
end

function Component:OnPartyPlayerTriggerFallTrigger(Eid)
    EventManager:FireEvent(EventID.OnPartyPlayerTriggerFallTrigger, Eid)
end

function Component:OnPartyPlayerFirstComplete(Eid)
    EventManager:FireEvent(EventID.OnOnePlayerEnd, Eid)
end

function Component:OnNotifyPartyBuff_Lua(BuffId, LastTime, Eid)
	EventManager:FireEvent(EventID.OnPlayerGetDeBuff, BuffId, LastTime, Eid)
end
--endregion

--region 破坏Pro玩法相关
function Component:SabotageProLimitTimer_Lua()
    DebugPrint("SabotageProComponent:Client SabotageProLimitTimer_Lua", self.DungeonId)
    local CommonClientTimerUI = UIManager(self):GetUIObj("DungeonCaptureFloat")
    if not CommonClientTimerUI then
        CommonClientTimerUI = UIManager(self):LoadUINew("DungeonCaptureFloat")
    end
    CommonClientTimerUI:InitClientTimerByHandleName("SabotageProLimitTimer", "UI_TEMPLE_LIMIT_TIME", 10)
end

function Component:RemoveSabotageProLimitTimer_Lua()
    DebugPrint("SabotageProComponent:Client RemoveSabotageProLimitTimer_Lua", self.DungeonId)
    local CommonClientTimerUI = UIManager(self):GetUIObj("DungeonCaptureFloat")
    if not CommonClientTimerUI then
        return
    end
    CommonClientTimerUI:CloseClientTimerByHandleName()
end

--endregion

--region 新周本Synthesis玩法相关
function Component:SynthesisBuffList_Lua()
    self.SynthesisBuffList = UIManager(self):_CreateWidgetNew("SynthesisBuffList")
    -- 暂时挂在这测试
    local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
    BattleMainUI.Task:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	BattleMainUI.Task:AddChildToOverlay(self.SynthesisBuffList)
    self.SynthesisBuffList:Init()
end

function Component:RemoveSynthesisBuffList_Lua()
    if self.SynthesisBuffList then
        self.SynthesisBuffList:RemoveFromParent()
    end
end

function Component:SynthesisDestruction_Lua()
    local SynthesisUI = UIManager(self):GetUIObj("DungeonSynthesisFloat")
    if not SynthesisUI then
        SynthesisUI = UIManager(self):LoadUINew("DungeonSynthesisFloat")
    end
end

function Component:RemoveSynthesisDestruction_Lua()
    local SynthesisUI = UIManager(self):GetUIObj("DungeonSynthesisFloat")
    if SynthesisUI then
        SynthesisUI:Close()
    end
    self:ShowSynthesisSuccessEffect()
end

function Component:RemoveMonsterRush_Wuyou_Lua()
    if self.RankStarUI then
        self.RankStarUI:OnTimerDel()
    end
end

function Component:OnRep_RageValue()
    EventManager:FireEvent(EventID.OnRepSynthesisRageValue, self.RageValue)
    self:UpdateSynthesisDestructionTaskProgress()
end

function Component:OnRep_GuideSupervisorEids()
    EventManager:FireEvent(EventID.OnRepGuideSupervisorEids, self.GuideSupervisorEids, self.DeadSupervisorEids)
    self:UpdateSynthesisDestructionTaskProgress()
end

function Component:OnRep_DeadSupervisorEids()
    EventManager:FireEvent(EventID.OnRepDeadSupervisorEids, self.GuideSupervisorEids, self.DeadSupervisorEids)
end

function Component:UpdateSynthesisDestructionTaskProgress()
    local DungeonInfo = DataMgr.Synthesis[self.DungeonId]
    if not DungeonInfo then
        return
    end
    if not DungeonInfo.RageValueStages then
        return
    end
    -- 迭代过后 GuideSupervisorEids 不区分是主动发现还是被动发现的了
    -- local RageValueFinishNum = 0
    -- for _, RageValueStage in pairs(DungeonInfo.RageValueStages) do
    --     if self.RageValue >= RageValueStage then
    --         RageValueFinishNum = RageValueFinishNum + 1
    --     else
    --         break
    --     end
    -- end
    local GuideSupervisorNum = self.GuideSupervisorEids:Num()
    if self.SynthesisGuideNumCache and self.SynthesisGuideNumCache == GuideSupervisorNum then
        return
    end
    self.SynthesisGuideNumCache = GuideSupervisorNum
    DebugPrint("Synthesis Destruction UpdateDungeonTaskProgress", GuideSupervisorNum, #DungeonInfo.RageValueStages)
    self:UpdateDungeonTaskProgress(GuideSupervisorNum, #DungeonInfo.RageValueStages)
end

function Component:ShowDiscoverSupervisorToast_Lua(Percent)
    local SynthesisUI = UIManager(self):GetUIObj("DungeonSynthesisFloat")
    if SynthesisUI then
        SynthesisUI:ShowDiscoverSupervisorToast(Percent)
    end
end

function Component:SynthesisOccupation_Lua()
    self:OnRep_OccupationFinishNum()
end

function Component:RemoveSynthesisOccupation_Lua()
    self:ShowSynthesisSuccessEffect()
end

function Component:OnRep_OccupationFinishNum()
    local DungeonInfo = DataMgr.Synthesis[self.DungeonId]
    if not DungeonInfo then
        return
    end
    if not DungeonInfo.OccupationTargetNum then
        return
    end
    DebugPrint("Synthesis Occupation UpdateDungeonTaskProgress", self.OccupationFinishNum, DungeonInfo.OccupationTargetNum)
    self:UpdateDungeonTaskProgress(self.OccupationFinishNum, DungeonInfo.OccupationTargetNum)
end

function Component:SynthesisCrack_Lua()
    UIManager(self):LoadUINew("DungeonSynthesisCrack")
end

function Component:RemoveSynthesisCrack_Lua()
    local SynthesisCrackUI = UIManager(self):GetUIObj("DungeonSynthesisCrack")
    if SynthesisCrackUI then
        SynthesisCrackUI:PlayOutAnimation()
    end
    EventManager:FireEvent(EventID.CloseDungeonUI)
    self:ShowSynthesisSuccessEffect(2)
end

function Component:OnRep_KeySubmitNum()
    EventManager:FireEvent(EventID.OnRepKeySubmitNum, self.KeySubmitNum)
end

function Component:OpenChestTime_Lua()
    local CommonClientTimerUI = UIManager(self):GetUIObj("DungeonCaptureFloat")
    if not CommonClientTimerUI then
        CommonClientTimerUI = UIManager(self):LoadUINew("DungeonCaptureFloat")
    end
    CommonClientTimerUI:InitClientTimerByHandleName("OpenChestTime", "DUNGEON_SYNTHESIS_112", 0)
end

function Component:RemoveOpenChestTime_Lua()
    local CommonClientTimerUI = UIManager(self):GetUIObj("DungeonCaptureFloat")
    if not CommonClientTimerUI then
        return
    end
    CommonClientTimerUI:CloseClientTimerByHandleName()
end

function Component:ShowSynthesisSuccessEffect(DelayTime)
    local ShowSuccessEffect = function()
        local SuccessEffectUI = UIManager(self):LoadUINew("SynthesisSuccessEffect")
        if SuccessEffectUI then
            SuccessEffectUI:ShowEffect()
        end
    end

    if DelayTime and DelayTime > 0 then
        self:AddTimer(DelayTime, ShowSuccessEffect)
    else
        ShowSuccessEffect()
    end
end

--endregion

-- GameState也得缓存下
-- 避免 FireEvent时 task UI还没创建，taskUI收不到此次CurProgress 和 TotalProgress的情况
function Component:UpdateDungeonTaskProgress(CurProgress, TotalProgress)
    self.CurProgressCache = CurProgress
    self.TotalProgressCache = TotalProgress
    EventManager:FireEvent(EventID.OnDungeonTaskProgress, CurProgress, TotalProgress)
end

function Component:OnRep_DungeonProgress()
    EventManager:FireEvent(EventID.OnRepDungeonProgress, self.DungeonProgress)
end


--region GameMode通用时间杀怪进度组件
function Component:BattleProgress_Lua()
    -- todo: 可以不用全加载的
    local CommonBattleProgressWidget = UIManager(self):_CreateWidgetNew("CommonBattleProgress")
    CommonBattleProgressWidget:InitWidgetUI()
    local CommonBattleCountWidget = UIManager(self):_CreateWidgetNew("CommonBattleCount")
    CommonBattleCountWidget:InitWidgetUI()
    local CommonBattleCountDownWidget = UIManager(self):_CreateWidgetNew("CommonBattleCountDown")
    CommonBattleCountDownWidget:InitWidgetUI()
end

function Component:RemoveBattleProgress_Lua()
    -- todo: 可以不用全卸载,改隐藏,下次加载的时候改显示
    local BattleMain = UIManager(self):GetUIObj("BattleMain")
    BattleMain.Pos_Abyss_CountDown_1:ClearChildren()
    BattleMain.Task:ClearChildren()
    BattleMain.Pos_Abyss_CountDown:ClearChildren()
end

function Component:OnRep_BattleProgressNum()
    EventManager:FireEvent(EventID.OnRepBattleProgressNum, self.BattleProgressNum, self.BattleProgressInfo.MaxProgressNum)
end

function Component:OnRep_BattleProgressInfo()
    EventManager:FireEvent(EventID.OnRepBattleProgressInfo, self.BattleProgressInfo)
end

--endregion

--region 公会战
function Component:OnRep_RaidScore()
    EventManager:FireEvent(EventID.OnRepRaidScore, self.RaidScore)
end

--endregion

function Component:OnRep_IsExitDeliveryActive()
    DebugPrint("OnRep_IsExitDeliveryActive", self.IsExitDeliveryActive)

    -- 换了种实现方法 这里看上去用不上了

    -- if self.IsExitDeliveryActive then
    --     -- 本来该 RegisterBattleEvent AfterSupportSkill事件，
    --     -- 但事件触发那边不支持客户端注册，所以用这个代替 (有RegisterBattleEventClient 暂不探究了）
    --     EventManager:AddEvent(EventID.OnTheaterPerform, self, self.OnExitDeliveryAfterSupportSkill)
    -- else
    --     EventManager:RemoveEvent(EventID.OnTheaterPerform, self)
    -- end
end

-- function Component:OnExitDeliveryAfterSupportSkill(_)
--     local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)

--     local Pet = Player:GetBattlePet()
--     local IsPetTeleportAble = Pet and Pet:HasAutoTransfer()
--     DebugPrint("OnExitDeliveryAfterSupportSkill", IsPetTeleportAble)
--     if not IsPetTeleportAble then
--         return
--     end

--     Player.RPCComponent:NotifyServerStartExitDelivery()
-- end

function Component:ChargeGame_Lua()
    local CommonClientTimerUI = UIManager(self):GetUIObj("DungeonCaptureFloat")
    if not CommonClientTimerUI then
        CommonClientTimerUI = UIManager(self):LoadUINew("DungeonCaptureFloat")
    end
    CommonClientTimerUI:InitClientTimerByHandleName("ChargeGame", "DUNGEON_SYNTHESIS2_109", 10)
end

function Component:RemoveChargeGame_Lua()
    local CommonClientTimerUI = UIManager(self):GetUIObj("DungeonCaptureFloat")
    if not CommonClientTimerUI then
        return
    end
    CommonClientTimerUI:CloseClientTimerByHandleName()
end


-- region 周本Ⅱ
function Component:ShowSynthesisIIChargeProgressUI_Lua()
    if self.SynthesisIIProgressHudWidget then
        return
    end
    local SynthesisIIProgressHudWidget = UIManager(self):_CreateWidgetNew("SynthesisIIProgressHud")
    if not SynthesisIIProgressHudWidget then
        ScreenPrint("LoadDungoenUI加载对应副本WidgetUI失败，创建Widget失败！WidgetUIName SynthesisIIProgressHud")
        return
    end
    SynthesisIIProgressHudWidget:InitDungeonWidget(self.DungeonId)
    self.SynthesisIIProgressHudWidget = SynthesisIIProgressHudWidget
end

function Component:RemoveShowSynthesisIIChargeProgressUI_Lua()
    if self.SynthesisIIProgressHudWidget then
        self.SynthesisIIProgressHudWidget:SetVisibility(ESlateVisibility.Collapsed)
    end
    local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
    if not BattleMainUI then
        return
    end
    if self.SynthesisIIProgressHudWidget then
        self.SynthesisIIProgressHudWidget:SetVisibility(ESlateVisibility.Collapsed)
    end
    BattleMainUI.Pos_Weekly_Buff:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function Component:ShowSynthesisIIFortDefenceProgressUI_Lua()
    local FortDefenceTargetNums = DataMgr.SynthesisII[self.DungeonId].FortDefenceTargetNum
    local FortDefenceTargetNum = FortDefenceTargetNums[self.FortDefenceGameIndex]
    if self.SynthesisIIExpelBarHudWidget then
        self.SynthesisIIExpelBarHudWidget:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.SynthesisIIExpelBarHudWidget:SetFortDefenceTargetNum(FortDefenceTargetNum)
        self.SynthesisIIExpelBarHudWidget:UpdateProgress(0)
        return
    end
    local SynthesisIIExpelBarHudWidget = UIManager(self):_CreateWidgetNew("SynthesisIIExpelBarHud")
    if not SynthesisIIExpelBarHudWidget then
        ScreenPrint("LoadDungoenUI加载对应副本WidgetUI失败，创建Widget失败！WidgetUIName SynthesisIIExpelBarHud")
        return
    end
    self.SynthesisIIExpelBarHudWidget = SynthesisIIExpelBarHudWidget
    SynthesisIIExpelBarHudWidget:InitDungeonWidget(FortDefenceTargetNum)
    self.SynthesisIIExpelBarHudWidget:UpdateProgress(0)
end

function Component:OnRep_FortDefenceKilledNum()
    if self.SynthesisIIExpelBarHudWidget then
        self.SynthesisIIExpelBarHudWidget:UpdateProgress(self.FortDefenceKilledNum)
    end
end

function Component:RemoveShowSynthesisIIFortDefenceProgressUI_Lua()
    if self.SynthesisIIExpelBarHudWidget then
        self.SynthesisIIExpelBarHudWidget:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function Component:ShowSynthesisIIHostageHealthBarUI_Lua()
    local HostageEid = nil
    for _,AI in pairs(self.MonsterMap) do
        if IsValid(AI) and AI.UnitId == 7017051 then
            HostageEid = AI.Eid
            break
        end
    end
    if self.SynthesisIIHostageHealthBarHudWidget then
        self.SynthesisIIHostageHealthBarHudWidget:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.SynthesisIIHostageHealthBarHudWidget.HostageEid = HostageEid
        return
    end
    local SynthesisIIHostageHealthBarHudWidget = UIManager(self):_CreateWidgetNew("SynthesisIIHostageHealthBarHud")
    if not SynthesisIIHostageHealthBarHudWidget then
        ScreenPrint("LoadDungoenUI加载对应副本WidgetUI失败，创建人质血条Widget失败！WidgetUIName SynthesisIIHostageHealthBarHud")
        return
    end
    self.SynthesisIIHostageHealthBarHudWidget = SynthesisIIHostageHealthBarHudWidget
    SynthesisIIHostageHealthBarHudWidget:InitDungeonWidget(HostageEid)
end

function Component:RemoveShowSynthesisIIHostageHealthBarUI_Lua()
    if self.SynthesisIIHostageHealthBarHudWidget then
        self.SynthesisIIHostageHealthBarHudWidget:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function Component:FinishSynthesisII_Lua()
    self:ShowSynthesisSuccessEffect()
end

return Component
