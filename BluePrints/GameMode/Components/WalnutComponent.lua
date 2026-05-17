
require "UnLua"
require "Const"

local WalnutComponent = {}

function WalnutComponent:IsWalnutDungeon()
	if self.IsDungeonTypeWalnut == nil then
		local DungeonInfo = DataMgr.Dungeon[self.DungeonId]
		if DungeonInfo then
			self.IsDungeonTypeWalnut = DungeonInfo.IsWalnutDungeon == true
		end
	end
	return self.IsDungeonTypeWalnut
end

----- 核桃奖励选择相关 begin ---------------------------------------------
function WalnutComponent:TriggerShowWalnutReward()
	if self.IsInWalnutReward then
		return
	end
	self.IsInWalnutReward = true

	DebugPrint("WalnutComponent:TriggerShowWalnutReward")

	if IsStandAlone(self) then
		-- 单机不开启倒计时，等玩家选择
		-- 单机GameMode无需知道玩家是否装备核桃，客户端自己判断
		self:AddDungeonEvent("ShowWalnutReward")
	elseif IsDedicatedServer(self) then
		-- 若存在玩家尚未连进来，直接以失败结算掉这些玩家
		self:KickPlayerNotInGame()

		if self:IsAllPlayerNotChoosedNextWalnut() then
			DebugPrint("WalnutComponent: 所有玩家都没装备核桃")
			self:ExecuteNextStepOfWalnutReward()
			return
		end

		-- 初始化TMap，管理每个玩家是否已选择奖励
		self:InitWalnutRewardPlayerMap()

		-- 开启奖励计时
		local WalnutRewardSelectTime = DataMgr.GlobalConstant.WalnutRewardSelectTime.ConstantValue or 15
		self:BpAddTimer("ShowWalnutReward", WalnutRewardSelectTime, true, Const.GameModeEventServerClient)

		-- 测试打印用（待流程稳定后删除）
		self:ShowWalnutDebugTimer(WalnutRewardSelectTime, "ShowWalnutRewardDebug")
	end

	-- 通知逻辑服，客户端可以开始选择奖励了
	EventManager:AddEvent(EventID.OnSelectWalnutReward, self, self.OnClientSelectedWalnutReward)
	self:NotifyLogicServerOpenWalnut()

	self:SetGamePaused("WalnutReward", true)
end

-- 接收来自逻辑服，某玩家已选奖励的事件
function WalnutComponent:OnClientSelectedWalnutReward(AvatarEidStr)
	DebugPrint("WalnutComponent:OnClientSelectedWalnutReward, AvatarEidStr", AvatarEidStr)
	if IsStandAlone(self) then
		self:OnClientSelectedWalnutReward_StandAlone(AvatarEidStr)
	elseif IsDedicatedServer(self) then
		self:OnClientSelectedWalnutReward_DedicatedServer(AvatarEidStr)
	end
end

-- 单机不选核桃奖励，但会播一个过场提示，提示结束后客户端可以直接调这个
function WalnutComponent:OnClientSelectedWalnutReward_StandAlone(AvatarEidStr)
	self:RemoveDungeonEvent("ShowWalnutReward")
	self:ExecuteNextStepOfWalnutReward()
end

function WalnutComponent:OnClientSelectedWalnutReward_DedicatedServer(AvatarEidStr)
	if self.EMGameState.WalnutRewardPlayer:Find(AvatarEidStr) ~= nil then
		self.EMGameState.WalnutRewardPlayer:Add(AvatarEidStr, true)
		UE.UMapSyncHelper.SyncMap(self.EMGameState, "WalnutRewardPlayer")
		-- 判断是否全部选择完毕，若是则直接结束选择
		local NotSelectedPlayers = self:GetWalnutRewardNotSelectedPlayers()
		if #NotSelectedPlayers == 0 then
			self:OnPlayerSelectWalnutReward()
		end
	else
		self.EMGameState:ShowDungeonError("WalnutComponent:一个不存在的AvatarEidStr选择了奖励 AvatarEidStr "..(AvatarEidStr or "nil"), Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.ServerData)
	end
end

function WalnutComponent:GetWalnutRewardNotSelectedPlayers()
	local Res = {}
	for AvatarEidStr, IsSelected in pairs(self.EMGameState.WalnutRewardPlayer) do
		if not IsSelected then
			table.insert(Res, AvatarEidStr)
		end
	end
	return Res
end

function WalnutComponent:InitWalnutRewardPlayerMap()
	self.EMGameState.WalnutRewardPlayer:Clear()
	local InGameAvatarEids = self:GetInGamePlayerAvatarEids()
	for _, AvatarEidStr in pairs(InGameAvatarEids) do
		local LastChooseWalnutId = self:GetLastChooseWalnutId(AvatarEidStr)
		local IsAlreadySelect = (LastChooseWalnutId == -1) or (LastChooseWalnutId == 0) or (LastChooseWalnutId == nil)  -- -1 上一次选择不装备，0 上一次没选择，nil 边界条件，均在开始选择时视为已选择核桃
		self.EMGameState.WalnutRewardPlayer:Add(AvatarEidStr, IsAlreadySelect)
		DebugPrint("WalnutComponent: InitWalnutRewardPlayerMap, AvatarEidStr", AvatarEidStr, "LastChooseWalnutId", LastChooseWalnutId)
	end
	UE.UMapSyncHelper.SyncMap(self.EMGameState, "WalnutRewardPlayer")
end

function WalnutComponent:GetInGamePlayerAvatarEids()
	local Res = {}
	if not self.AvatarInfos then
		return Res
	end

	for AvatarEidStr, _ in pairs(self.AvatarInfos) do
		table.insert(Res, AvatarEidStr)
	end
	return Res
end

function WalnutComponent:GetLastChooseWalnutId(AvatarEidStr)
	if self.EMGameState.NextWalnutPlayer:Length() == 0 then
		-- 第一次进入，从外面给的信息拿
		if not self.AvatarInfos[AvatarEidStr] then
			return nil
		end
		return self.AvatarInfos[AvatarEidStr].PlayerInfo.Walnuts.WalnutId
	else
		return self.EMGameState.NextWalnutPlayer:Find(AvatarEidStr)
	end
end

function WalnutComponent:IsAllPlayerNotChoosedNextWalnut()
	if self.EMGameState.NextWalnutPlayer:Length() == 0 then
		PrintTable(self.AvatarInfos, 10)
		for _, v in pairs(self.AvatarInfos) do
			if v.PlayerInfo.Walnuts.WalnutId ~= -1 then
				return false
			end
		end
		return true
	else
		for _, WalnutId in pairs(self.EMGameState.NextWalnutPlayer) do
			if (WalnutId ~= -1) and (WalnutId ~= 0) then
				return false
			end
		end
		return true
	end
end

function WalnutComponent:NotifyLogicServerOpenWalnut()
	local Entity
	if IsStandAlone(self) then
		Entity = GWorld:GetAvatar()
	else
		Entity = GWorld:GetDSEntity()
	end
	Entity:OpenWalnut()
end

function WalnutComponent:BpOnTimerEnd_ShowWalnutReward()
	DebugPrint("WalnutComponent:BpOnTimerEnd_ShowWalnutReward")

	-- 代替未选择的客户端选奖励
	local DSEntity = GWorld:GetDSEntity()
	local NotSelectedPlayers = self:GetWalnutRewardNotSelectedPlayers()
	PrintTable(NotSelectedPlayers, 2)
	DSEntity:SelectWalnutReward(NotSelectedPlayers, 1)

	self:ExecuteNextStepOfWalnutReward()
end

-- 玩家已选择，关闭计时器，直接进入下一流程
function WalnutComponent:OnPlayerSelectWalnutReward()
	DebugPrint("WalnutComponent:OnPlayerSelectWalnutReward")
	self:BpDelTimer("ShowWalnutReward", true, Const.GameModeEventServerClient)
	self:ExecuteNextStepOfWalnutReward()
end

-- 进入下一流程
function WalnutComponent:ExecuteNextStepOfWalnutReward()
	self.IsInWalnutReward = false

	-- 测试打印用（待流程稳定后删除）
	self:RemoveTimer("ShowWalnutRewardDebug")

	EventManager:RemoveEvent(EventID.OnSelectWalnutReward, self)

	self:SetGamePaused("WalnutReward", false)

	DebugPrint("WalnutComponent:ExecuteNextStepOfWalnutReward 是无尽副本吗", self:IsEndlessDungeon())
	if not self:IsEndlessDungeon() then
		-- 继续结算
		self:TriggerRealDungeFinish(true)
	else
		-- 开启投票
		self:ExecuteLogicStartDungeonVote()
	end
end

-- 结算时，选择核桃奖励的额外逻辑
function WalnutComponent:ExecuteWalutLogicOnEnd()
	self:TriggerShowWalnutReward()
end

function WalnutComponent:KickPlayerNotInGame()
	local KickedAvatarEids = {}
	local InGameAvatarEids = self:GetInGamePlayerAvatarEids()
	for _, AvatarEidStr in pairs(InGameAvatarEids) do
		local PlayerState = UE4.URuntimeCommonFunctionLibrary.GetPlayerStateByAvatarEid(GWorld.GameInstance, AvatarEidStr)
		if PlayerState and (not PlayerState:IsInGame()) then
			table.insert(KickedAvatarEids, AvatarEidStr)
			DebugPrint("WalnutComponent:KickPlayerNotInGame, 踢掉未连进来的玩家 AvatarEidStr", AvatarEidStr)
		end
	end
	if #KickedAvatarEids > 0 then
		self:ForceFinishPlayerByFailed(KickedAvatarEids)
	end
end

----- 核桃奖励选择相关 end ---------------------------------------------

----- 下一轮核桃选择相关 begin ---------------------------------------------
function WalnutComponent:TriggerShowNextWalnut()
	if self.IsInNextWalnut then
		return
	end
	self.IsInNextWalnut = true

	DebugPrint("WalnutComponent:TriggerShowNextWalnut")
	EventManager:AddEvent(EventID.OnSelectWalnut, self, self.OnClinetChooseNextWalnut)

	if IsStandAlone(self) then
		-- 单机时，等skynet事件通知
		self:AddDungeonEvent("NextWalnut")
	elseif IsDedicatedServer(self) then
		-- 联机时，开启核桃选择倒计时
		local WalnutSelectTime = DataMgr.GlobalConstant.WalnutSelectTime.ConstantValue or 15
		self:BpAddTimer("NextWalnut", WalnutSelectTime, true, Const.GameModeEventServerClient)

		-- 初始化TMap，管理每个玩家是否已选择下一个核桃
		self:InitNextWalnutPlayerMap()

		-- 需要一个变量，保证仅触发一次“进入下一步”
		self.IsNextStepTriggered = false

		-- 测试打印用（待流程稳定后删除）
		self:ShowWalnutDebugTimer(WalnutSelectTime, "ShowNextWalnutDebug")
	end
end

-- 0 没选
-- -1 选择不装备
-- 其他 核桃id
function WalnutComponent:InitNextWalnutPlayerMap()
	self.EMGameState.NextWalnutPlayer:Clear()
	for _, Player in pairs(self:GetAllPlayer()) do
		local AvatarEidStr = Player:GetOwner().AvatarEidStr
		self.EMGameState.NextWalnutPlayer:Add(AvatarEidStr, 0)
		DebugPrint("WalnutComponent: InitNextWalnutPlayerMap, AvatarEidStr", AvatarEidStr)
	end
	UE.UMapSyncHelper.SyncMap(self.EMGameState, "NextWalnutPlayer")
end

-- 接收来自逻辑服，某玩家已选下一核桃的事件，WalnutId == -1 代表选择不装备核桃
function WalnutComponent:OnClinetChooseNextWalnut(AvatarEidStr, WalnutId)
	DebugPrint("WalnutComponent:OnClinetChooseNextWalnut, AvatarEidStr", AvatarEidStr, "WalnutId", WalnutId)
	if IsStandAlone(self) then
		self:OnClinetChooseNextWalnut_StandAlone(AvatarEidStr, WalnutId)
	elseif IsDedicatedServer(self) then
		self:OnClinetChooseNextWalnut_DedicatedServer(AvatarEidStr, WalnutId)
	end
end

-- 单机时，选下一个核桃的最终出口
-- ExecuteNextStepOfChooseWalnut_StandAlone
function WalnutComponent:OnClinetChooseNextWalnut_StandAlone(AvatarEidStr, WalnutId)
	self.IsInNextWalnut = false

	self:SetGamePaused("NextWalnutRecover", false)

	DebugPrint("WalnutComponent:ExecuteNextStepOfChooseWalnut_StandAlone")
	EventManager:RemoveEvent(EventID.OnSelectWalnut, self)
	self:RemoveDungeonEvent("NextWalnut")

	self:TriggerActiveGameModeState(Const.StateBattleProgress)
end

function WalnutComponent:OnClinetChooseNextWalnut_DedicatedServer(AvatarEidStr, WalnutId)
	if self.EMGameState.NextWalnutPlayer:Find(AvatarEidStr) ~= nil then
		self.EMGameState.NextWalnutPlayer:Add(AvatarEidStr, WalnutId)
		UE.UMapSyncHelper.SyncMap(self.EMGameState, "NextWalnutPlayer")

		if self.IsNextStepTriggered then		-- 只触发一次后面的逻辑
			DebugPrint("WalnutComponent: 倒计时后才收到的skynet事件 AvatarEidStr", AvatarEidStr, "WalnutId", WalnutId)
			return
		end

		local NotChoosedPlayers = self:GetNextWalnutNotChoosedPlayers()
		if #NotChoosedPlayers == 0 then
			self:OnPlayerChoosedNextWalnut()
		end
	end
end

-- 所有人都已经做出过选择
function WalnutComponent:OnPlayerChoosedNextWalnut()
	DebugPrint("WalnutComponent:OnPlayerChoosedNextWalnut")
	self:BpDelTimer("NextWalnut", true, Const.GameModeEventServerClient)
	self:ExecuteWalnutReadyCountDown()
end

function WalnutComponent:BpOnTimerEnd_NextWalnut()
	DebugPrint("WalnutComponent:BpOnTimerEnd_NextWalnut")

	-- 超时没选择的玩家，skynet那边状态是0，不触发OnSelectWalnut，也无需ds代替选择
	-- 下面逻辑可以不要了

	-- local NotChoosedAvatarEids = self:GetNextWalnutNotChoosedPlayers()
	-- if #NotChoosedAvatarEids > 0 then
	-- 	local PlayerEids = {}
	-- 	for _, AvatarEid in pairs(NotChoosedAvatarEids) do
	-- 		local PlayerEid = self:GetPlayerEidByAvatarEidStr(AvatarEid) or -1
	-- 		table.insert(PlayerEids, PlayerEid)
	-- 		DebugPrint("WalnutComponent:没选下一轮核桃，结算的玩家 AvatarEidStr", AvatarEid, "PlayerEid", PlayerEid)
	-- 	end
	-- 	self:TriggerPlayerWin(NotChoosedAvatarEids, PlayerEids)
	-- end

	self:ExecuteWalnutReadyCountDown()
end

function WalnutComponent:ExecuteWalnutReadyCountDown()
	-- 测试打印用（待流程稳定后删除）
	self:RemoveTimer("ShowNextWalnutDebug")

	-- 要稍微等一下skynet的回调，才知道对应的玩家选择装备/选择不装备核桃，RemoveEvent放到副本准备倒计时之后吧
	--EventManager:RemoveEvent(EventID.OnSelectWalnut, self)

	self.IsNextStepTriggered = true

	DebugPrint("WalnutComponent:ExecuteWalnutReadyCountDown")
	-- 联机时，开启副本轮次倒计时
	local WalnutDungeonReadyTime = DataMgr.GlobalConstant.WalnutDungeonReadyTime.ConstantValue or 15
	self:BpAddTimer("WalnutReady", WalnutDungeonReadyTime, true, Const.GameModeEventServerClient)
	-- 测试打印用（待流程稳定后删除）
	self:ShowWalnutDebugTimer(WalnutDungeonReadyTime, "ShowWalnutReadyDebug")
end

-- 联机时，选下一个核桃的最终出口
-- ExecuteNextStepOfChooseWalnut_DedicatedServer
function WalnutComponent:BpOnTimerEnd_WalnutReady()
	self.IsInNextWalnut = false

	DebugPrint("WalnutComponent:BpOnTimerEnd_WalnutReady")
	EventManager:RemoveEvent(EventID.OnSelectWalnut, self)
	PrintTable(self.EMGameState.NextWalnutPlayer:ToTable())

	-- 测试打印用（待流程稳定后删除）
	self:RemoveTimer("ShowWalnutReadyDebug")

	self:TriggerActiveGameModeState(Const.StateBattleProgress)
end

function WalnutComponent:GetNextWalnutNotChoosedPlayers()
	local Res = {}
	for AvatarEidStr, WalnutId in pairs(self.EMGameState.NextWalnutPlayer) do
		if WalnutId == 0 then		-- 0代表没选
			table.insert(Res, AvatarEidStr)
		end
	end
	return Res
end
----- 下一轮核桃选择相关 begin ---------------------------------------------

function WalnutComponent:ShowWalnutDebugTimer(TotalTime, Handle)
	local count = TotalTime
	self:AddTimer(1, function()
		DebugPrint("WalnutComponent:"..Handle.." remaintime:", count)
		count = count-1
		if count <= 0 then
			self:RemoveTimer(Handle)
		end
	end, true, 0, Handle, true)
end

return WalnutComponent