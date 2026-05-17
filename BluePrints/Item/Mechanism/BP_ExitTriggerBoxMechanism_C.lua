--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local CommonUtils = require "Utils.CommonUtils"

local BP_ExitTriggerBoxMechanism_C = Class("BluePrints.Common.Triggers.BP_AOITriggerBox_C")
local OverlapActor = {}
local PlayerState = {
    Play = 1, -- 游戏中，没有进入撤离点
    Dead = 2, -- 游戏中，寄了
    WaitExit = 3, -- 进入撤离点等待
    Leave = 4, -- 已撤离
}

function BP_ExitTriggerBoxMechanism_C:Initialize(Initializer)
    BP_ExitTriggerBoxMechanism_C.Super.Initialize(BP_ExitTriggerBoxMechanism_C, Initializer)
    self.bShowingCountdownToast = false
    self.PrepareExitPlayers = {}
end

function BP_ExitTriggerBoxMechanism_C:ReceiveBeginPlay()
    print(_G.LogTag, "ReceiveBeginPlay", self:GetName(), self.BpBorn)
    self.Overridden.ReceiveBeginPlay(self)
    self:ActiveGuide("Add")
    self.GameMode = UE4.UGameplayStatics.GetGameMode(self)

    if not IsDedicatedServer(self) then
        return
    end

    -- 注册相关事件监听
    self.GameMode.EMGameState:RegisterGameModeEvent("OnExit", self, self.OnAvatarExit)
    self.GameMode.EMGameState:RegisterGameModeEvent("OnEnter", self, self.OnAvatarEnter)
    EventManager:AddEvent(EventID.CharDie, self, self.OnCharDie)
end

function BP_ExitTriggerBoxMechanism_C:OnRep_Size()
    self:SetBoxExtent(self.Size)
end

function BP_ExitTriggerBoxMechanism_C:AuthorityInitInfo(Info)
    BP_ExitTriggerBoxMechanism_C.Super.AuthorityInitInfo(self,Info)
    if not IsDedicatedServer(self) then
        return
    end

    if GWorld.bDebugServer then
        return
    end

    -- 初始化保存所有玩家状态
    -- 去掉在撤离点刷出来之前已经结算的玩家
    local Avatars = self.GameMode.AvatarInfos or {}
    local DSEntity = GWorld:GetDSEntity()
    for HasLeaveAvatar, _ in pairs(DSEntity.HasLeaveAvatars) do
        Avatars[HasLeaveAvatar] = nil
    end

    for Avatar, _ in pairs(Avatars) do
        self.PrepareExitPlayers[Avatar] = PlayerState.Play
    end
end

function BP_ExitTriggerBoxMechanism_C:OnAvatarExit(AvatarArr)
    print(_G.LogTag, "OnAvatarExit")
    local bCheck = false
    for i=1, AvatarArr:Length() do
        local AvatarEidStr = AvatarArr:GetRef(i)
        if not rawget(self.PrepareExitPlayers, AvatarEidStr) then
            error("Unauthorized Avatar")
        end

        if self.PrepareExitPlayers[AvatarEidStr] ~= PlayerState.Leave then
            self.PrepareExitPlayers[AvatarEidStr] = PlayerState.Leave
            bCheck = true
        end
    end

    if bCheck then
        self:CheckTimerAndExit()
    end
end

function BP_ExitTriggerBoxMechanism_C:OnAvatarEnter(PlayerEid)
    print(_G.LogTag, "OnAvatarEnter")
    local PlayerCharacter = Battle(self):GetEntity(PlayerEid)
    if not PlayerCharacter then
        error("Character is not exist.", PlayerEid)
        return
    end
    local AvatarEid = PlayerCharacter:GetOwner().AvatarEidStr
    if not rawget(self.PrepareExitPlayers, AvatarEid) then
        error("Unauthorized Avatar")
		return
    end
    self.PrepareExitPlayers[AvatarEid] = PlayerState.Play
end

function BP_ExitTriggerBoxMechanism_C:OnCharDie(CharacterEid)
    print(_G.LogTag, "OnCharDie")
    local Character = Battle(self):GetEntity(CharacterEid)
    if not Character then
        error("Character is not exist.")
    end

    -- 假死跳过
    if Character:CheckCanRecovery() then
        return
    end

    local AvatarEid = Character:GetOwner().AvatarEidStr
    if not rawget(self.PrepareExitPlayers, AvatarEid) then
        error("Unauthorized Avatar")
    end

    if self.PrepareExitPlayers[AvatarEid] == PlayerState.Play then
        self.PrepareExitPlayers[AvatarEid] = PlayerState.Dead
    end
    self:CheckTimerAndExit()
end

function BP_ExitTriggerBoxMechanism_C:ExitInGameWin()
    print(_G.LogTag, "ExitInGameWin")
    if self:IsExistTimer("ExitTimeDownTick") then
        self:RemoveExitTimer()
    end

    -- 关卡胜利流程
    local FunName = 'Trigger'..self.GameMode.EMGameState.GameModeType..'Win'
    self.GameMode:TriggerDungeonComponentFun(FunName)
    if self.GameMode.EMGameState.GameModeType ~= "Party" then       -- 派对玩法有个专用的PartySuccess方法，就不走下面那个了
        if self.GameMode:CheckServerDungeonEnable() then
            self.GameMode:NotifyServerGameEnd(true, "ExitTriggerBox")
        else
            self.GameMode:TriggerDungeonWin()
        end
    end
    ---- 玩家关卡胜利结算流程
    --if IsDedicatedServer(self) then
    --    -- 联机结算流程
    --    local DungeonId = self.GameMode.EMGameState.DungeonId
    --    if not DataMgr.Dungeon[DungeonId].DungeonExitRule or DataMgr.Dungeon[DungeonId].DungeonExitRule == CommonConst.DungeonExitRule.OVERLAP_EXIT then
    --        local Avatars = {}
    --        for AvatarEid, State in pairs(self.PrepareExitPlayers) do
    --            if State == PlayerState.WaitExit then
    --                table.insert(Avatars, AvatarEid)
    --                State = PlayerState.Leave -- 提前设置状态，以区别不是从撤离点结算离开的玩家
    --            end
    --        end
    --
    --        if #Avatars ~= 0 then
    --            self.GameMode:TriggerPlayerWin(Avatars)
    --        end
    --    elseif DataMgr.Dungeon[DungeonId].DungeonExitRule == CommonConst.DungeonExitRule.ALL_EXIT then
    --        self.GameMode:TriggerDungeonWin()
    --    else
    --        print(_G.LogTag, "[Error] Unknown Exit Rule.")
    --    end
    --else
    --    -- 单机结算流程
    --    self.GameMode:TriggerDungeonWin()
    --end
end

--重叠函数
function BP_ExitTriggerBoxMechanism_C:OnBeginOverlapLua(TargetActor)
    if IsAuthority(self) then
        local PlayerCharacter = TargetActor:Cast(UE4.APlayerCharacter)
        if not PlayerCharacter then
            return
        end

        -- 副本额外流程
        local FunName = 'Trigger'..self.GameMode.EMGameState.GameModeType..'ExitMechanismOverlap'
        self.GameMode:TriggerDungeonComponentFun(FunName, TargetActor)
        self:AddPlayer(PlayerCharacter)
        AudioManager(self):PauseDungeonBGM()
    else
        -- 联机下发给客户端消息 PauseDungeonBGM ,待做
        if IsClient(self) then
            OverlapActor[TargetActor] = true
        end
    end
end

function BP_ExitTriggerBoxMechanism_C:AddPlayer(PlayerCharacter)
    if IsStandAlone(self) then
        self:ExitInGameWin() -- 单机简单一点，撞trigger直接结算胜利
        return
    end

    local AvatarEid = PlayerCharacter:GetOwner().AvatarEidStr
    if not rawget(self.PrepareExitPlayers, AvatarEid) then
        error("Unauthorized Avatar")
    end
    DebugPrint("AddPlayer")
    self.PrepareExitPlayers[AvatarEid] = PlayerState.WaitExit
    self:CheckTimerAndExit()
    self:RefreshPlayerNumInfo()
end

function BP_ExitTriggerBoxMechanism_C:CheckTimerAndExit()
    if not self.GameMode.EMGameState:CheckGameModeStateEnable() then
        return
    end

    local EndNow = true
    local bStart = false
    for _, State in pairs(self.PrepareExitPlayers) do
        if State == PlayerState.Play then
            EndNow = false
        elseif State == PlayerState.WaitExit then
            bStart = true
        end
    end

    if EndNow then
        self:ExitInGameWin()
        return
    end

    if bStart then
        -- 当前需要开启倒计时
        if not self:IsExistTimer("ExitTimeDownTick") then
            -- 当前没有正在进行倒计时
            self:ResetExitTimer()
            if not self.bShowingCountdownToast and CommonUtils.TableLength(self.PrepareExitPlayers) > 1 then
                self:ShowOrHideCountdownToast(true)
            end
        end
    else
        -- 当前不需要开启倒计时
        self:RemoveExitTimer()
    end
end

--结束重叠
function BP_ExitTriggerBoxMechanism_C:OnEndOverlapLua(TargetActor)

    if IsClient(self) then
        OverlapActor[TargetActor] = nil
    end

    -- 单机进去了直接结算，不存在出撤离点的问题
    if not IsDedicatedServer(self) then
        return
    end

    local PlayerCharacter = TargetActor:Cast(UE4.APlayerCharacter)
    -- 有可能是结算后直接从撤离点中消失
    if not PlayerCharacter or not PlayerCharacter:GetOwner() then
        return
    end

    local AvatarEid = PlayerCharacter:GetOwner().AvatarEidStr
    if not rawget(self.PrepareExitPlayers, AvatarEid) then
        error("Unauthorized Avatar")
    end

    if PlayerCharacter:IsRealDead() then
        self.PrepareExitPlayers[AvatarEid] = PlayerState.Dead
        self:CheckTimerAndExit()
    else
        self.PrepareExitPlayers[AvatarEid] = PlayerState.Play
    end
    self:RefreshPlayerNumInfo()

    for _, State in pairs(self.PrepareExitPlayers) do
        if State == PlayerState.WaitExit then
            return
        end
    end

    -- 策划要求，派对玩法即便所有人离开，也不需要移除倒计时
    if self.GameMode.EMGameState.GameModeType == "Party" then
        return
    end
    self:RemoveExitTimer()
end

--移除计时器
function BP_ExitTriggerBoxMechanism_C:RemoveExitTimer()
    DebugPrint("BP_ExitTriggerBoxMechanism_C:RemoveExitTimer")
    self:RemoveTimer("ExitTimeDownTick")
    self.ExitCountDown = -1
    if self.bShowingCountdownToast then
        self:ShowOrHideCountdownToast(false)
    end
end

--重置计时器
function BP_ExitTriggerBoxMechanism_C:ResetExitTimer()
    self:RemoveExitTimer()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    self.ExitCountDown = GameState.ExitCountDown
    self:AddTimer(1.0, self.UpdatePage, true, 0, "ExitTimeDownTick")
end

--更新当前时间
function BP_ExitTriggerBoxMechanism_C:UpdatePage()
    DebugPrint("BP_ExitTriggerBoxMechanism_C:UpdatePage")
    if self.ExitCountDown - 1 < 0 then
        if self.ExitCountDown ~= 0 then
            self.ExitCountDown = 0
        end
    else
        self.ExitCountDown = self.ExitCountDown - 1
    end
    DebugPrint("BP_ExitTriggerBoxMechanism_C:UpdatePage",self.bShowingCountdownToast,self.ExitCountDown)
    if self.bShowingCountdownToast and (self.ExitCountDown == 0 or not self:IsSomeoneWaiting()) 
    and self.GameMode.EMGameState.GameModeType ~= "Party" then
        self:ShowOrHideCountdownToast(false)
    end

    if self.ExitCountDown == 0 then
        self:ExitInGameWin()
    end
end

--处理当倒计时发生改变的时候进行调用，仅用于显示UI
function BP_ExitTriggerBoxMechanism_C:HandleExitCountDownValueChange()
    -- local UIManager = GWorld.GameInstance:GetGameUIManager()
    -- if not UIManager then
    --     return
    -- end
    -- local ExitTimeDownUI = UIManager:GetUIObj("ExitTimeDown")
    -- if self.ExitCountDown < 0 and ExitTimeDownUI then
    --     UIManager:UnLoadUI("ExitTimeDown")
    --     return
    -- end

    -- if not ExitTimeDownUI then
    --     local ScreenPos = FVector2D(0, 0)
    --     ExitTimeDownUI = UIManager:LoadUI(UIConst.ExitTimeDown, "ExitTimeDown", UIConst.ZORDER_ABOVE_ALL, 10, ScreenPos)
    -- end

    -- if ExitTimeDownUI then
    --     ExitTimeDownUI.TimeDown:SetText(self.ExitCountDown)
    -- end
end

function BP_ExitTriggerBoxMechanism_C:IsSomeoneWaiting()
    local Res = false
    local WaitingNum,TotalNum = self:GetPlayerNum()
    self.ExitInfo.WaitingPlayerNum = WaitingNum
    self.ExitInfo.TotalPlayerNum = TotalNum
    Res = WaitingNum > 0
    DebugPrint("IsSomeoneWaiting Res = " .. (Res == true and "true" or "false"),WaitingNum)
    return Res
end

function BP_ExitTriggerBoxMechanism_C:GetPlayerNum()
    local WaitingNum,TotalNum = 0,0
    for AvatarEid, State in pairs(self.PrepareExitPlayers or {}) do
        if State == PlayerState.WaitExit then
            WaitingNum = WaitingNum + 1
        end
        TotalNum = TotalNum + 1
    end
    return WaitingNum,TotalNum
end

function BP_ExitTriggerBoxMechanism_C:OnRep_ExitInfo()
    -- DebugPrint("BP_ExitTriggerBoxMechanism_CL:OnExitInfoChange")
    
    -- local PlayerCharacter = UE4.UGameplayStatics.GetPlayerController(self, 0).Character
    -- local bIsWaiting = false

    -- if PlayerCharacter then
    --     for Actor,_ in pairs(OverlapActor or {}) do
    --         if PlayerCharacter == Actor:Cast(UE4.APlayerCharacter) then
    --             bIsWaiting = true
    --             break
    --         end
    --     end
    -- end

    -- local GameState = UE4.UGameplayStatics.GetGameState(self)
    -- if GameState then
    --     GameState:OnRepDungeonExitInfo(self.ExitInfo,bIsWaiting)
    -- end
end

function BP_ExitTriggerBoxMechanism_C:ShowOrHideCountdownToast(bIsShow)
    if bIsShow == nil then return end
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if (GameState) then
        GameState.ExitInfo.bShowExitCountdownToast = bIsShow
        GameState.ExitInfo.StartExitCountdownTime = GameState.ReplicatedTimeSeconds
        self.bShowingCountdownToast = bIsShow
        if bIsShow then
            GameState.ExitInfo.WaitingPlayerNum,GameState.ExitInfo.TotalPlayerNum = self:GetPlayerNum()
        end
    end
end

function BP_ExitTriggerBoxMechanism_C:EMActorDestroy(DestroyReason)
    self:OnEMActorDestroy(DestroyReason)
end

function BP_ExitTriggerBoxMechanism_C:OnEMActorDestroy(DestroyReason)
    self:RemoveExitTimer()
    self:K2_DestroyActor()
    EventManager:RemoveEvent(EventID.CharDie)
end

function BP_ExitTriggerBoxMechanism_C:ReceiveActorBeginOverlap(OtherActor)
    self.Overridden.ReceiveActorBeginOverlap(self, OtherActor)
end

function BP_ExitTriggerBoxMechanism_C:ReceiveActorEndOverlap(OtherActor)
    self.Overridden.ReceiveActorEndOverlap(self, OtherActor)
end

-- client function
function BP_ExitTriggerBoxMechanism_C:IsPlayerWaiting(PlayerCharacter)
    local bIsWaiting = false
    DebugPrint("BP_ExitTriggerBoxMechanism_C:IsPlayerWaiting ",PlayerCharacter)
    if PlayerCharacter then
        -- 客户端原本靠overlap判断玩家是否到撤离点，但是overlap可能会比服务端同步Info要慢导致显示不对，补充一个Character位置与box的位置判断
        if UE4.URuntimeCommonFunctionLibrary.CheckBoxAndCapsuleOverlap(PlayerCharacter.CapsuleComponent,self.CollisionComponent) then
            return true
        end
        for Actor,_ in pairs(OverlapActor or {}) do
            if PlayerCharacter == Actor:Cast(UE4.APlayerCharacter) then
                bIsWaiting = true
                break
            end
        end
    end

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

    if PlayerCharacterDist == MinDist then
        bIsWaiting = true
    end
    
    return bIsWaiting
end

-- 返回一个包含当前所有Character的数组
function BP_ExitTriggerBoxMechanism_C:GetAllPlayerCharacters()

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

function BP_ExitTriggerBoxMechanism_C:GetComponentDistance(CompA, CompB)
    if not CompA or not CompB then
        return math.huge
    end
    local LocA = CompA:K2_GetComponentLocation()
    local LocB = CompB:K2_GetComponentLocation()
    if not LocA or not LocB then
        return math.huge
    end
    local Delta = LocA - LocB
    return Delta:Size()
end

function BP_ExitTriggerBoxMechanism_C:GetDistanceToPlayerComponent(PlayerCharacter)
    if not PlayerCharacter or not PlayerCharacter.CapsuleComponent or not self.CollisionComponent then
        return nil
    end
    local dist = self:GetComponentDistance(PlayerCharacter.CapsuleComponent, self.CollisionComponent)
    DebugPrint("BP_ExitTriggerBoxMechanism_C:GetDistanceToPlayerComponent", dist)
    return dist
end

function BP_ExitTriggerBoxMechanism_C:GetUnitRealType()
    if self.UnitId and DataMgr.Mechanism[self.UnitId] then
        return DataMgr.Mechanism[self.UnitId].UnitRealType
    end
end

function BP_ExitTriggerBoxMechanism_C:RefreshPlayerNumInfo()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if GameState and self.bShowingCountdownToast then
        GameState.ExitInfo.WaitingPlayerNum,GameState.ExitInfo.TotalPlayerNum = self:GetPlayerNum()
    end
end

return BP_ExitTriggerBoxMechanism_C
