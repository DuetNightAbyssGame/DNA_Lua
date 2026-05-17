require "UnLua"

local BP_DungeonVoteComponent_C = Class()

--------------------GameMode 流程&事件相关------------------------
function BP_DungeonVoteComponent_C:InitVoteComponent()
	self.GameMode.EMGameState.DungeonVoteInterval = DataMgr.GlobalConstant.DungeonVoteInterval.ConstantValue or 15
end

function BP_DungeonVoteComponent_C:TriggerDungeonVoteBegin()
	if not self.GameMode.EMGameState:CheckGameModeStateEnable() then
		DebugPrint("副本状态不正确 触发了TriggerDungeonVoteBegin")
		return
	end

	DebugPrint("DungeonVoteComponent:TriggerDungeonVoteBegin")
	self.GameMode.IsInDungeonVote = true						-- 标记正在投票中，防止重复结算投票
	self.IsAllPlayersVotedTriggered = false
	self.GameMode:KickNotEnteredPlayers("VoteStart")
	self:InitDungeonVoteValues()
	if IsDedicatedServer(self.GameMode) then
		self.GameMode:BpAddTimer("OnDungeonVoteBegin", self.GameMode.EMGameState.DungeonVoteInterval, true, Const.GameModeEventServerClient)
	else
		-- 单机下客户端好像用不上这些，暂时保留着
		self.GameMode:AddClientTimerStruct(self.GameMode, "OnDungeonVoteBegin", self.GameMode.EMGameState.DungeonVoteInterval, true)
		self.GameMode:AddDungeonEvent("OnDungeonVoteBegin")
	end
end

function BP_DungeonVoteComponent_C:InitDungeonVoteValues()
    self.GameMode.EMGameState.VoteValues:Clear()
	for _, PlayerCharacter in pairs(self.GameMode:GetAllPlayer()) do
		self.GameMode.EMGameState.VoteValues:Add(PlayerCharacter.Eid, EVoteState.Wait)
	end
	UMapSyncHelper.SyncMap(self.GameMode.EMGameState, "VoteValues")
end

function BP_DungeonVoteComponent_C:OnAllPlayersVoted()
	if self.IsAllPlayersVotedTriggered then
		DebugPrint("DungeonVoteComponent:OnAllPlayersVoted Already triggered")
		return
	end
	self.IsAllPlayersVotedTriggered = true

	local Info = self.GameMode.EMGameState.ClientTimerStruct:GetTimerInfo("OnDungeonVoteBegin")
	local RemainVoteTime = Info.Time - (self.GameMode.EMGameState.ReplicatedRealTimeSeconds - Info.RealTimeSeconds)
	local VoteReadyCountTime = DataMgr.GlobalConstant.VoteReadyCountTime.ConstantValue or 3
	DebugPrint("DungeonVoteComponent:OnAllPlayersVoted RemainVoteTime", RemainVoteTime, VoteReadyCountTime)
	if RemainVoteTime > VoteReadyCountTime then
		DebugPrint("DungeonVoteComponent:OnAllPlayersVoted RestTimer!")
		self.GameMode:BpResetTimer("OnDungeonVoteBegin", VoteReadyCountTime, true, Const.GameModeEventServerClient)
	end
end

return BP_DungeonVoteComponent_C

