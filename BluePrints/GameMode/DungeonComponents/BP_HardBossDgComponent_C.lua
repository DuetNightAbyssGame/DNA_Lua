--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_HardBossDgComponent_C
local M = Class({
	"BluePrints.Common.TimerMgr",
})

local OPENING_WAIT_TIME = 5    -- 等待所有客户端播放完开场动画的保底时间

local PlayerGameState = {
    NotReady = 1,       -- 未准备好，可能在loading，或客户端播开场动画（通常不会出现，nil也会视为NotReady）
    Ready = 2,          -- 已准备好
    Disconnect = 3,     -- 断线，等待连接
    Exit = 4,           -- 已退出副本（主动退出，或超时踢出）
}


--region GameMode 流程&事件相关
function M:InitHardBossDgComponent()
    self.GameMode = self:GetOwner()

    -- 联机梦魇副本专用表
    local HardBossInfo = DataMgr.HardBossDg[self.GameMode.DungeonId]
    if not HardBossInfo then
		GameState(self):ShowDungeonError("HardBossDgComponent:当前副本ID没有填写在对应的副本表中, 读表失败! 读入Id："..self.GameMode.DungeonId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
		return
	end
    -- 复用区域梦魇表
    local HardBossMainInfo = DataMgr.HardBossMain[HardBossInfo.HardBossId]
    if not HardBossMainInfo then
		GameState(self):ShowDungeonError("HardBossDgComponent:读取梦魇配置失败! 读入配置Id："..tostring(HardBossInfo.HardBossId), Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
		return
	end

    self.BossUnitId = HardBossInfo.BossUnitId -- Array 
    self.BossStaticCreatorId = HardBossInfo.BossStaticId
    self.AirWallStaticCreatorId = HardBossInfo.AirWallStaticId
    self.PreparingAirWallStaticId = HardBossInfo.PreparingAirWallStaticId

    self.NowBossUnitIds = {}    --@ key = UnitId, value = boolean
    self.BossEids = {}          --@ array

    self:RegisterGameModeEvents()

    DebugPrint("HardBossDgComponent: InitHardBossDgComponent")
end

function M:RegisterGameModeEvents()
    self.GameMode.EMGameState:RegisterGameModeEvent("OnExit", self, self.OnPlayerExitGame)
    self.GameMode.EMGameState:RegisterGameModeEvent("OnDisconnect", self, self.OnPlayerDisconnectGame)
    EventManager:AddEvent(EventID.OnAvatarLogout, self, self.OnPlayerAvatarLogout)
end

function M:InitHardBossDgBaseInfo()
    GWorld:DSBLog("Info", "HardBossDgComponent: InitHardBossDgBaseInfo", "GameMode")
    self:SpawnMainActors()
    self:PlayOpeningSequence()
end

function M:SpawnMainActors()
    local CreatorIds = TArray(0)

    for GroupIndex, CreatorId in pairs(self.BossStaticCreatorId) do
        local BossCreator = self.GameMode.EMGameState.StaticCreatorMap:Find(CreatorId)
        local Index = self.GameMode:GetTargetPlayerNum()
        Index = math.clamp(Index, 1, #(self.BossUnitId))
        local BossUnitId = self.BossUnitId[Index][GroupIndex]
        if BossCreator and BossUnitId then
            CreatorIds:Add(CreatorId)
            BossCreator.UnitId = BossUnitId
            self.NowBossUnitIds[BossUnitId] = true
        end
    end

    CreatorIds:Add(self.PreparingAirWallStaticId)
    self.GameMode:TriggerActiveStaticCreator(CreatorIds, "HardBossMain")
end

function M:OnStaticCreatorEvent(EventName, Eid, UnitId, UnitType, CreatorId)
	if (EventName == "HardBossMain") and self.NowBossUnitIds[UnitId] then
        local Boss = Battle(self):GetEntity(Eid)
        if IsValid(Boss) then
            Boss:StopBT("HardBossOpening")
            Battle(self):AddBuffToTarget(Boss, Boss, Const.BossInvincibleBuffId, -1)
            table.insert(self.BossEids, Eid)
        end
    end
end

--region 播开场动画相关
function M:PlayOpeningSequence()
    self.IsWaitingClientOpening = true
    self.ClientReadyMap = {}

    local Players = self.GameMode:GetAllPlayer()
    for _, Player in pairs(Players) do
        DebugPrint("HardBossDgComponent: PlayOpeningSequence", Player.Eid)
        GWorld:DSBLog("Info", "HardBossDgComponent: PlayOpeningSequence PlayerEid: "..Player.Eid, "GameMode")
        --self.GameMode:SetPlayerInvincible(Player, true)
        self:MutePlayerAction(Player, true)
        self.GameMode:PausePhantomBTByPlayer(Player, true, "HardBossOpening")
    end

    self.GameMode:AddDungeonEvent("OpeningSequence")
end

function M:OnPlayerEnter(Eid)
    if not self.IsWaitingClientOpening then
        return
    end

    DebugPrint("HardBossDgComponent: OnPlayerEnter", Eid)
    GWorld:DSBLog("Info", "HardBossDgComponent: OnPlayerEnter PlayerEid: "..Eid, "GameMode")

    local Player = Battle(self):GetEntity(Eid)
    --self.GameMode:SetPlayerInvincible(Player, true)
    self:MutePlayerAction(Player, true)
    self.GameMode:PausePhantomBTByPlayer(Player, true, "HardBossOpening")
end

function M:ClientPlayOpeningFinish(PlayerEid)
    local PlayerCharacter = Battle(self):GetEntity(PlayerEid)
    if not PlayerCharacter then
        return
    end
    local PlayerNum = self.GameMode:GetTargetPlayerNum()
    local AvatarEidStr = PlayerCharacter:GetOwner().AvatarEidStr
    DebugPrint("HardBossDgComponent: ClientPlaySequenceFinish PlayerEid:", PlayerEid, " PlayerNum:", PlayerNum, "AvatarEidStr", AvatarEidStr)
    GWorld:DSBLog("Info", "HardBossDgComponent: ClientPlaySequenceFinish PlayerEid: "..PlayerEid.." PlayerNum: "..PlayerNum.." AvatarEidStr: "..AvatarEidStr, "GameMode")

    self.ClientReadyMap[AvatarEidStr] = PlayerGameState.Ready
    if self:IsAllActiveClientReady() then
        self:OnAllClientOpeningReady()
    end
end

function M:IsAllActiveClientReady()
    local PlayerNum = self.GameMode:GetTargetPlayerNum()
    local ActiveReadyCount = 0

    for AvatarEidStr, State in pairs(self.ClientReadyMap) do
        if State == PlayerGameState.Ready then
            ActiveReadyCount = ActiveReadyCount + 1
        end
    end

    return ActiveReadyCount >= PlayerNum
end

function M:OnAllClientOpeningReady()
    if not self.IsWaitingClientOpening then
        return
    end
    self.IsWaitingClientOpening = false
    
    DebugPrint("HardBossDgComponent: OnAllClientOpeningReady")
    GWorld:DSBLog("Info", "HardBossDgComponent: OnAllClientOpeningReady ", "GameMode")
    self.GameMode:RemoveDungeonEvent("OpeningSequence")

    local CreatorIds = TArray(0)
    CreatorIds:Add(self.AirWallStaticCreatorId)
    self.GameMode:TriggerActiveStaticCreator(CreatorIds)

    self.GameMode:TriggerGameModeEvent("Event_OnAllClientOpeningReady")
end

-- 这个时机交给策划在蓝图里配置
-- 通常在Event_OnAllClientOpeningReady事件后，策划会播一个倒计时ui，倒计时结束后调用这个函数
function M:RealGameStart()
    for _, BossEid in pairs(self.BossEids) do
        local Boss = Battle(self):GetEntity(BossEid)
        if IsValid(Boss) then
            Boss:RestartBT()
            Battle(self):RemoveBuffFromTarget(Boss, Boss, Const.BossInvincibleBuffId, false, -1)
        end
    end

    local AllPlayers = self.GameMode:GetAllPlayer()
    for _, Player in pairs(AllPlayers) do
        DebugPrint("HardBossDgComponent: RealGameStart", Player.Eid)
        GWorld:DSBLog("Info", "HardBossDgComponent: RealGameStart PlayerEid: "..Player.Eid, "GameMode")
        --self.GameMode:SetPlayerInvincible(Player, false)
        self:MutePlayerAction(Player, false)
        self.GameMode:PausePhantomBTByPlayer(Player, false, "HardBossOpening")
    end

    -- local InActiveCreatorIds = TArray(0)
    -- InActiveCreatorIds:Add(self.PreparingAirWallStaticId)
    -- self.GameMode:TriggerInactiveStaticCreator(InActiveCreatorIds, false, EDestroyReason.DungeonNormal)
    -- 空气墙需要播溶解特效再销毁，改为通知，在蓝图里配置
    local Creator = self.GameMode.EMGameState:GetStaticCreatorInfo(self.PreparingAirWallStaticId)
    if IsValid(Creator) then
        local ChildEids = Creator:GetChildEids()
        for _, ChildEid in pairs(ChildEids) do
            local AirWall = Battle(self):GetEntity(ChildEid)
            if IsValid(AirWall) and AirWall.HardBossPreAirWallEnd then
                AirWall:HardBossPreAirWallEnd()
            end
        end
    end
end

function M:OnPlayerExitGame(AvatarArr)
    if not self.IsWaitingClientOpening then
        return
    end

    local PlayerNum = self.GameMode:GetTargetPlayerNum()
    for i=1, AvatarArr:Length() do
        local AvatarEidStr = AvatarArr:GetRef(i)
        self.ClientReadyMap[AvatarEidStr] = PlayerGameState.Exit
        DebugPrint("HardBossDgComponent: OnPlayerExitGame", AvatarEidStr, "PlayerNum", PlayerNum)
        GWorld:DSBLog("Info", "HardBossDgComponent: OnPlayerExitGame AvatarEidStr: "..AvatarEidStr.." PlayerNum: "..PlayerNum, "GameMode")
    end

    if self:IsAllActiveClientReady() then
        self:OnAllClientOpeningReady()
    end
end

function M:OnPlayerDisconnectGame(AvatarEidStr)
    if not self.IsWaitingClientOpening then
        return
    end

    local PlayerNum = self.GameMode:GetTargetPlayerNum()
    self.ClientReadyMap[AvatarEidStr] = PlayerGameState.Disconnect
    DebugPrint("HardBossDgComponent: OnPlayerDisconnectGame", AvatarEidStr, "PlayerNum", PlayerNum)
    GWorld:DSBLog("Info", "HardBossDgComponent: OnPlayerDisconnectGame AvatarEidStr: "..AvatarEidStr.." PlayerNum: "..PlayerNum, "GameMode")
end

-- 再监听一个玩家真正断连的事件，可能出现某玩家在Loading期间强制结算，但是他并没有真正和服务器断连，这时GetTargetPlayerNum中也有该玩家
-- 这个事件是GetTargetPlayerNum减少的时机
function M:OnPlayerAvatarLogout(AvatarEidStr)
    if not self.IsWaitingClientOpening then
        return
    end

    local PlayerNum = self.GameMode:GetTargetPlayerNum()
    DebugPrint("HardBossDgComponent: OnPlayerAvatarLogout", AvatarEidStr, "PlayerNum", PlayerNum)
    GWorld:DSBLog("Info", "HardBossDgComponent: OnPlayerAvatarLogout AvatarEidStr: "..AvatarEidStr.." PlayerNum: "..PlayerNum, "GameMode")

    if self:IsAllActiveClientReady() then
        self:OnAllClientOpeningReady()
    end
end

-- 暂不需要监听重新连接的事件，因为处于IsWaitingClientOpening状态，客户端重连后会重播开场动画，播完后会通知服务端自己ready

--endregion

function M:MutePlayerAction(Player, IsMute)
    if not IsValid(Player) then
        return
    end

    DebugPrint("HardBossDgComponent: MutePlayerAction", IsMute, "PlayerEid:", Player.Eid)
    if IsMute then
        Battle(self):AddBuffToTarget(Player, Player, Const.MuteBuffId, -1)
    else
        Battle(self):RemoveBuffFromTarget(Player, Player, Const.MuteBuffId, false, -1)
    end
end

return M
