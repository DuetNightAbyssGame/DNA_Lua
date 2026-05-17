require "UnLua"

---@type BP_PartyComponent_C
local BP_PartyComponent_C = Class({
	"BluePrints.Common.TimerMgr",
})

function BP_PartyComponent_C:InitPartyBaseInfo()
	DebugPrint("BP_PartyComponent_C:InitPartyBaseInfo")

	self.GameMode = self:GetOwner().LevelGameMode
	self.RatingRange = DataMgr.Party[self.GameMode.DungeonId].RatingRange or {}
	self:InitPartyStagePoints()
	self:InitArchivePointMulti()
	self:WaitPlayerEnter()
	self:InitPartyMainTimer()

	-- self.GameMode:AddDungeonEvent("InitParty")
end

function BP_PartyComponent_C:CustomFinishInfo(AvatarStr)
	local PlayerStar = self:GetPlayerStar(AvatarStr)
	self.GameMode:UpdateClientPartyInfo(AvatarStr, PlayerStar)
	return {
		Star = PlayerStar,
		PlayerNum = self:GetPartyPlayerNum(),
	}
end

function BP_PartyComponent_C:PartySuccess()
	self.GameMode:TriggerDungeonWin()
end

-- 当有玩家进入撤离点时
function BP_PartyComponent_C:TriggerPartyExitMechanismOverlap(PlayerCharacter)
	if not self.PlayerRemainTime then
		return
	end

	local Eid = PlayerCharacter.Eid
	-- 仅在第一次进入时记录
	if not self.PlayerRemainTime[Eid] then
		local Time = self:GetPartyRemainTime()
		self.PlayerRemainTime[Eid] = Time
		DebugPrint("BP_PartyComponent_C:有玩家到达终点，Eid", Eid, "剩余时间", Time)
		self.GameMode:OnPlayerComplete(Eid, self:GetPartyTime())
		self.GameMode:TriggerGameModeEvent("OnPlayerReachPartyExit", Eid, Time)
	end
end

-- 所有玩家进入撤离点，触发副本胜利逻辑
function BP_PartyComponent_C:TriggerPartyWin()
	self:PartySuccess()
end

-- 最终上报到服务端时，奖励会根据人数浮动，所以需要上报
-- 策划要求上报的人数为全流程最高人数（即使有人中途退出也会计数
-- PartyPlayerDisPercentValues在所有玩家进入完毕后InitPlayerOrdinal时初始化，并且不会因为玩家退出而移除信息
-- 直接拿这个的长度就够用了，不用专门写个结构统计玩家数目了
function BP_PartyComponent_C:GetPartyPlayerNum()
	return self.GameMode.EMGameState.PartyPlayerDisPercentValues:Num()
end

function BP_PartyComponent_C:GetPlayerStar(AvatarStr)
	local Eid = 0
	if AvatarStr == nil then
		-- 没传视为单机
		Eid = UE4.UGameplayStatics.GetPlayerCharacter(self, 0).Eid
	else
		Eid = self.GameMode:GetPlayerEidByAvatarEidStr(AvatarStr)
	end

	if (not Eid) or (Eid == 0) then
		ScreenPrint("BP_PartyComponent_C:AvatarStr获取Eid失败! AvatarStr"..AvatarStr)
		return 0
	end
	local RemainTime = self.PlayerRemainTime[Eid] or -1 		-- 如果没有出现在这个结构里，说明玩家尚未到达终点，剩余时间视为-1，保证策划第一个档位填0时获得星级为0
	local Star = 0
	for i, Rate in ipairs(self.RatingRange) do
		if RemainTime >= Rate then
			Star = i
		else
			break
		end
	end
	DebugPrint("BP_PartyComponent_C:玩家结算星级 AvatrStr", AvatarStr, "Eid", Eid, "星级", Star)
	return Star
end

function BP_PartyComponent_C:TriggerPartyOnEnd()
	-- self.GameMode:RemoveDungeonEvent("InitParty")
end

------ 联机存档点相关逻辑 -----
function BP_PartyComponent_C:InitArchivePointMulti()
	print(_G.LogTag,"LXZ InitArchivePointMulti")
	self.ArchivePointMultiInfo = {}			-- {存档点id, {PlayerEid, bool}} .count = 数量
	self.PlayerToArchivePointMultiInfo = {}	-- {玩家eid：最新存档点id}
end

function BP_PartyComponent_C:OnPlayerTriggerArchivePointMulti(ArchivePointMultiId, PlayerEid)
	DebugPrint("PartyComponent:OnPlayerTriggerArchivePointMulti", ArchivePointMultiId, PlayerEid)

	self.PlayerToArchivePointMultiInfo[PlayerEid] = ArchivePointMultiId

	if self.ArchivePointMultiInfo[ArchivePointMultiId] and self.ArchivePointMultiInfo[ArchivePointMultiId][PlayerEid] then
		DebugPrint("PartyComponent: 已触发过", ArchivePointMultiId, PlayerEid)
		return
	end

	if self.ArchivePointMultiInfo[ArchivePointMultiId] == nil then
		self.ArchivePointMultiInfo[ArchivePointMultiId] = {}
		self.ArchivePointMultiInfo[ArchivePointMultiId].count = 0
	end
	self.ArchivePointMultiInfo[ArchivePointMultiId][PlayerEid] = true
	self.ArchivePointMultiInfo[ArchivePointMultiId].count = self.ArchivePointMultiInfo[ArchivePointMultiId].count + 1
	DebugPrint("PartyComponent: 触发GameMode蓝图", ArchivePointMultiId, self.ArchivePointMultiInfo[ArchivePointMultiId].count)
	self.GameMode:TriggerGameModeEvent("OnArchivePointMultiTriggered", ArchivePointMultiId, self.ArchivePointMultiInfo[ArchivePointMultiId].count)
end

-------------------------------

--region 玩家进入流程相关
-- 第一个玩家进入时会走GameMode的OnInit，开始计时
function BP_PartyComponent_C:WaitPlayerEnter()
	self.IsAllPlayerReadyEventTriggered = false

	-- 策划要求，单人进入时不走倒计时，直接进入
	if self.GameMode:GetTargetPlayerNum() == 1 then
		DebugPrint("PartyComponent: 单人进入，不会走倒计时！")
		self.GameMode:TriggerGameModeEvent("OnAllPlayersReady")
		-- InitPartyBaseInfo 初始化顺序比机关初始化顺序慢，会导致机关没在ArchivePointMap注册就InitPlayerOrdinal，延迟一点处理
		self:AddTimer(0.1, function()
			self:BpOnTimerEnd_PartyWaitPlayerEnter()
		end)
		return
	end

	local TotalTime = DataMgr.GlobalConstant.PartyPreStartCountDownTotal.ConstantValue
	self.GameMode:BpAddTimer("PartyWaitPlayerEnter", TotalTime, true, Const.GameModeEventServerClient)
	--self.GameMode.EMGameState:RegisterGameModeEvent("OnEnter", self, self.OnPlayerEnter) EMGameMode有做过当玩家加入时通知Component的逻辑了，这里就不用了（否则会多次触发

	self:OnPlayerEnter()
end

function BP_PartyComponent_C:OnPlayerEnter(Eid)
	DebugPrint("BP_PartyComponent_C:OnPlayerEnter", Eid)

	if not self:CheckIsAllPlayersReady() then
		return
	end

	DebugPrint("BP_PartyComponent_C: AllPlayerEntered!")
	self.GameMode:TriggerGameModeEvent("OnAllPlayersReady")

	local WaitTimerRemainTime = CommonUtils.GetClientTimerStructRemainTime("PartyWaitPlayerEnter")
	local Threshold = DataMgr.GlobalConstant.PartyPreStartCountDownShort.ConstantValue
	if WaitTimerRemainTime > Threshold then
		self.GameMode:BpResetTimer("PartyWaitPlayerEnter", Threshold, true, Const.GameModeEventServerClient)
	end
end

function BP_PartyComponent_C:BpOnTimerEnd_PartyWaitPlayerEnter()
	if self.IsAllPlayerReadyEventTriggered then
		return
	end
	self.IsAllPlayerReadyEventTriggered = true
	DebugPrint("BP_PartyComponent_C: 触发GameMode蓝图 OnEnterCountDownEnd")
	self.GameMode:TriggerGameModeEvent("OnEnterCountDownEnd")
	self:InitPlayerOrdinal()
	self:AddTimer(1, self.UpdatePlayerOrdinal, true, 0, "UpdatePlayerOrdinal")
end

-- 执行移动玩家位置的逻辑
function BP_PartyComponent_C:SetPlayersToPartyStagePoints(Index)
	DebugPrint("BP_PartyComponent_C: SetPlayersToPartyStagePoints index", Index)

	local TargetStagePoint = self.PartyStagePoints[Index]
	assert(IsValid(TargetStagePoint), "BP_PartyComponent_C: 场上不存在StageId为"..Index.."的PartyStagePoint！不会执行移动玩家位置的逻辑")

	for Index, Player in pairs(self.GameMode:GetAllPlayer()) do
		if IsValid(Player) then
			local TargetTransform = TargetStagePoint:GetTransformByIndex(Index)
			local NewTranslation = TargetTransform.Translation
			NewTranslation.Z = NewTranslation.Z +Player.CapsuleComponent:GetUnscaledCapsuleHalfHeight() --看上去是向上移动半高，startpoint这么写的，就照做吧
			Player:K2_SetActorLocation(NewTranslation, false, nil, true)
			Player:MulticastSetPlayerRotation(TargetTransform.Rotation:ToRotator())
			Player:ResetIdle()
			DebugPrint("BP_PartyComponent_C SetLocation index", Index, "PlayerNewLoc", Player:K2_GetActorLocation())
			Player:GetMovementComponent():ForceClientUpdate()
		end
	end

	self.GameMode:NotifyClientShowBlackScreenFade()
end

function BP_PartyComponent_C:CheckIsAllPlayersReady()
	local CurReadyPlayerNum = 0
	for _, IsReady in pairs(self.GameMode.ClientReadyMap) do
		if IsReady then
			CurReadyPlayerNum = CurReadyPlayerNum + 1
		end
	end
	local TotalPlayerNum = self.GameMode:GetTargetPlayerNum()
	DebugPrint("BP_PartyComponent_C:CheckIsAllPlayersReady CurReadyPlayerNum", CurReadyPlayerNum, "TotalPlayerNum", TotalPlayerNum, "IsAllReady", CurReadyPlayerNum == TotalPlayerNum)
	return CurReadyPlayerNum == TotalPlayerNum
end
--endregion

function BP_PartyComponent_C:InitPartyStagePoints()
	self.PartyStagePoints = {}
	local Points = UGameplayStatics.GetAllActorsOfClass(self, LoadClass('/Game/BluePrints/Common/Level/BP_PartyStagePoint.BP_PartyStagePoint_C'))
	for _, Point in pairs(Points) do
		local StageId = Point:GetStageId()
		self.PartyStagePoints[StageId] = Point
	end
end

function BP_PartyComponent_C:InitPlayerOrdinal()
	for Index, Player in pairs(self.GameMode:GetAllPlayer()) do
		self.GameMode.EMGameState:InitPlayerOrdinal(Player)
	end
	-- 存一下存档点的进度位置，客户端UI会用
	if DataMgr.Party[self.GameMode.DungeonId].SucRule == "Parkour" then
		self.GameMode.EMGameState:InitArchivePointProgress()
	end
end

function BP_PartyComponent_C:UpdatePlayerOrdinal()
	for Index, Player in pairs(self.GameMode:GetAllPlayer()) do
		if IsValid(Player) and self.PlayerToArchivePointMultiInfo[Player.Eid] then
			self.GameMode.EMGameState:UpdatePartyPlayerDis(Player, self.PlayerToArchivePointMultiInfo[Player.Eid] or 0, self.ArchivePointList)
		end
	end
	self.GameMode.EMGameState:UpdatePatryPlayerOrdinal()
end

--region 派对计时相关
function BP_PartyComponent_C:InitPartyMainTimer()
	self.PlayerRemainTime = {}		-- {Eid, Time}   统计玩家通关剩余时间的结构，暂时没有需要同步的需求 先如此做
	self:SetPartyTimeThreshold(0)
	self:SetPartyTime(0)
end

function BP_PartyComponent_C:StartPartyTimer()
	self:SetPartyTime()	-- 开启派对计时，会默认将计时归零再开始
	self:AddTimer(1, self.PartyTiming, true, 0, "PartyTimer")
end

function BP_PartyComponent_C:PartyTiming()
	if not self.GameMode.EMGameState:CheckGameModeStateEnable() then
		self:StopPartyTimer()
		return
	end

	self:AddPartyTime(1)
end

function BP_PartyComponent_C:StopPartyTimer()
	self:RemoveTimer("PartyTimer")
end

function BP_PartyComponent_C:SetPartyTimeThreshold(Threshold)
	-- self.GameMode.EMGameState.PartyTimerThreshold = Threshold
	self.GameMode.EMGameState:SetPartyTimerThreshold(Threshold)
end

function BP_PartyComponent_C:SetPartyTime(Value)
	-- self.GameMode.EMGameState.PartyTime = Value
	self.GameMode.EMGameState:SetPartyTime(Value)
end

function BP_PartyComponent_C:AddPartyTime(Value)
	-- self.GameMode.EMGameState.PartyTime = self.GameMode.EMGameState.PartyTime + Value
	self.GameMode.EMGameState:SetPartyTime(self.GameMode.EMGameState.PartyTime + Value)

	if self.GameMode.EMGameState.PartyTime >= self.GameMode.EMGameState.PartyTimerThreshold then
		DebugPrint("BP_PartyComponent_C: PartyTimerReachThreshold!")
		self:StopPartyTimer()
		self.GameMode:TriggerGameModeEvent("OnPartyTimerReachThreshold")
	end
end

function BP_PartyComponent_C:GetPartyTime()
	return self.GameMode.EMGameState.PartyTime
end

function BP_PartyComponent_C:GetPartyRemainTime()
	return self.GameMode.EMGameState.PartyTimerThreshold - self.GameMode.EMGameState.PartyTime
end
--endregion

return BP_PartyComponent_C
