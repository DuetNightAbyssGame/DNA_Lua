local TimeUtils = require "src.utils.TimeUtils"

local DungeonSoloTreasure = {}

function DungeonSoloTreasure:OnNotifyServerDungeonEvent_yxdtest()
	self:ActiveStaticCreator({2710005,2710006})
end

function DungeonSoloTreasure:OnNotifyServerDungeonEvent_OnInit()
	print("ljl@DungeonSoloTreasure OnInit DungeonId", self.DungeonId)

	self.CurStage = "Normal"

	local SoloTreasureInfo = DataMgr.SoloTreasure[self.DungeonId]
	if not SoloTreasureInfo then return end

	self.GameTotalTime = SoloTreasureInfo.GameTotalTime
	self.TurnRainyTime = SoloTreasureInfo.TurnRainyTime
	self.RainyRandomId = SoloTreasureInfo.RainyRandomId or {}

	print("ljl@ DungeonSoloTreasure OnInit GameTotalTime", self.GameTotalTime, "TurnRainyTime", self.TurnRainyTime)

	self:InitTableDrivenServerEventComponent("SoloTreasure")

	-- 之后游戏真正开启时机可能不在这 先写这
	self:SoloTreasureGameStart()
end

function DungeonSoloTreasure:SoloTreasureGameStart()
	local BeginTimeStamp = TimeUtils.NowTime()
	self:SetSoloTreasureTimeStamp(BeginTimeStamp)
	self:NotifyGameModeDungeonEvent("DungeonComponentFun", "OnSetGameStartTime", BeginTimeStamp)
	print("DungeonSoloTreasure:SoloTreasureGameStart", BeginTimeStamp)
	self:RemoveTimer("RemainGameTime")
	self:AddLoopTimer(0.01, 0.1, function()
		self.GameTIme = TimeUtils.NowTime() - BeginTimeStamp
		self.GameTIme = math.min(self.GameTIme, self.GameTotalTime)
		if self.GameTIme == self.GameTotalTime then
			self:RemoveTimer("RemainGameTime")
			self:NotifyGameModeDungeonEvent("DungeonComponentFun", "OnTimeOver")
			--self:TryDungeonFinish(false, "TimeOver")
		end
	end, "RemainGameTime")

	self:AddTimer(self.TurnRainyTime, function()
		print("ljl@DungeonSoloTreasure OnTurnRainy")

		self.CurStage = "Rainy"
		self:NotifyGameModeDungeonEvent("DungeonComponentFun", "OnTurnRainy")

		self:ActiveRandomCreator(self.RainyRandomId)
	end)
end

function DungeonSoloTreasure:EndPlay()
	self:RemoveTimer("RemainGameTime")
end

-- 各个玩法自己实现，副本是否允许结算
function DungeonSoloTreasure:CheckAllowedFinish(IsWin, GameEndReason)
	return true
end

function DungeonSoloTreasure:OnNotifyServerDungeonEvent_DefenceGameBegin(MechanismStaticId, UniqueId, DefenceGamePlayId)
	if self.InDefenceGame then
		return
	end
	local DefenceGameInfo = DataMgr.SoloTreasureGamePlay[DefenceGamePlayId]
	if not DefenceGameInfo then
		return
	end

	self.InDefenceGame = true
	self.DefenceContainerInfos = {}		-- key: ContainerStaticId, value: table
	for _, ContainerId in pairs(DefenceGameInfo.Container or {}) do		
		self.DefenceContainerInfos[ContainerId] = {
			IsAlive = true,
		}
	end
	self.DefenceGamePlayId = DefenceGamePlayId
	self.DefenceGameContainerCount = #DefenceGameInfo.Container
	self.DefenceGameDeadContainerCount = 0
	self.DefenceGameMonsterSpawnId = DefenceGameInfo.MonsterSpawn

	self.DefenceGameTotalTime = DefenceGameInfo.CountDown
	self.DefenceGameTimerHandle = self:AddTimer(self.DefenceGameTotalTime, function()
		self:DefenceGameEnd(true)
	end)

	print("ljl@DungeonSoloTreasure DefenceGameBegin MonsterSpawnId", self.DefenceGameMonsterSpawnId, "StaticCreatorId", MechanismStaticId, "UniqueId", UniqueId)
	self:ServerTriggerCreateMonsterSpawn({self.DefenceGameMonsterSpawnId}, false)
end

function DungeonSoloTreasure:DefenceGameEnd(IsWin)
	if not self.InDefenceGame then
		return
	end
	self.InDefenceGame = false
	print("ljl@DungeonSoloTreasure DefenceGameEnd, IsWin: "..tostring(IsWin))

	self:NotifyGameModeDungeonEvent("DungeonComponentFun", "DefenceGameEnd", IsWin)
	local DefenceGameInfo = DataMgr.SoloTreasureGamePlay[self.DefenceGamePlayId]
	if DefenceGameInfo and IsWin then
		self:SetSoloTreasureKillMonsterScore(self:GetSoloTreasureKillMonsterScore() + DefenceGameInfo.TaskGains)
	end

	self:ServerTriggerDestroyAll({self.DefenceGameMonsterSpawnId}, false)

	---ryc.守护结束,还存活的容器，设置可打开
	if IsWin then
		for _, Container in pairs(self.DefenceContainerInfos) do
			Container.CanOpen = Container.IsAlive and true
		end
	end
end

function DungeonSoloTreasure:OnNotifyServerDungeonEvent_SpecialContainerDead(ContainerStaticId)
	if not self.InDefenceGame then
		return
	end
	if not self.DefenceContainerInfos[ContainerStaticId] then
		return
	end
	if not self.DefenceContainerInfos[ContainerStaticId].IsAlive then
		return
	end
	self.DefenceContainerInfos[ContainerStaticId].IsAlive = false

	self.DefenceGameDeadContainerCount = self.DefenceGameDeadContainerCount + 1
	print("ljl@DungeonSoloTreasure SpecialContainerDead, ContainerStaticId: ", ContainerStaticId, "CurCount: ", self.DefenceGameDeadContainerCount, "TotalCount: ", self.DefenceGameContainerCount)
	
	if self.DefenceGameDeadContainerCount >= self.DefenceGameContainerCount then
		self:RemoveTimer(self.DefenceGameTimerHandle)
		self:DefenceGameEnd(false)
	end
end

-- 怪物死亡
function DungeonSoloTreasure:DungeonMonsterDead(MonsterInfo)
	--print("gmy@DungeonSoloTreasure DungeonSoloTreasure:DungeonMonsterDead 0 0", MonsterInfo.UnitId)
	local UnitId = MonsterInfo.UnitId
	if not UnitId then
		return
	end

	--print("gmy@DungeonSoloTreasure DungeonSoloTreasure:DungeonMonsterDead 0 1", MonsterInfo.UnitId)
	
	local MonsterData = DataMgr.Monster[UnitId]
	if not MonsterData or not MonsterData.GamePlayTags then 
		return
	end

	--print("gmy@DungeonSoloTreasure DungeonSoloTreasure:DungeonMonsterDead 0 2", MonsterInfo.UnitId)
	
	for i, GamePlayTag in pairs(MonsterData.GamePlayTags) do
		--print("gmy@DungeonSoloTreasure DungeonSoloTreasure:DungeonMonsterDead 1", UnitId, "GamePlayTag", GamePlayTag)
		if DataMgr.SoloTreasureDrop[GamePlayTag] then
			local DropData = DataMgr.SoloTreasureDrop[GamePlayTag]
			if not DropData then
				return
			end
			local KillScore = DropData.KillScore or 0
			print("DungeonSoloTreasure:DungeonMonsterDead, UnitId: ".. UnitId.."  KillScore: "..KillScore)
			if DropData.KillScore and DropData.KillScore > 0 then
				print(string.format("DungeonSoloTreasure:DungeonMonsterDead, AddSoloTreasure Score(%d)", DropData.KillScore))
				self:SetSoloTreasureKillMonsterScore(self:GetSoloTreasureKillMonsterScore() + DropData.KillScore)
			end
			if DropData.DropMechanismId and DropData.DropMechanismId > 0 and math.random() <= DropData.BoxDropRate then
				print(string.format("DungeonSoloTreasure:DungeonMonsterDead, NewMechanism UnitId(%d)", DropData.DropMechanismId))

				local MechanismInfo = self:CreateMechanism(DropData.DropMechanismId)

				--print("gmy@DungeonSoloTreasure DungeonSoloTreasure:DungeonMonsterDead2", MonsterInfo.Transform)
				if MechanismInfo then
					local DropMechanismInfo = {
						UnitId = MechanismInfo.UnitId,
						UniqueId = MechanismInfo.UniqueId,
						Transform = MonsterInfo.Transform,  -- 怪物死亡位置
						DropReason = "MonsterDrop",         -- 掉落原因
						MonsterUnitId = MonsterInfo.UnitId, -- 来源怪物ID
					}
					
					self:NotifyGameModeDungeonEvent("ServerCreateDropMechanism", DropMechanismInfo)
				end
			end
		end
	end
end


---请求获取局内信息
function DungeonSoloTreasure:OnNotifyServerDungeonEvent_GetSoloTreasureInfo()
	self:NotifyGameModeDungeonEvent("OnGetSoloTreasureInfo", self:GetSoloTreasureInfo())	
end

---开物资容器
function DungeonSoloTreasure:OnNotifyServerDungeonEvent_OpenSoloTreasureMechanism(uid)
	local Mechanism = self:GetMechanism(uid)
	if Mechanism == nil then
		return
	end
	if DataMgr.ExtractionTreasureGuard[Mechanism.UnitId] then
		local ContainerStaticId = self:GetMechanismStaticIdByUniqueId(uid)
		if self.DefenceContainerInfos[ContainerStaticId] and not self.DefenceContainerInfos[ContainerStaticId].CanOpen then
			---特殊守护容器不可开启
			return
		end
	end
	local ret = self:SoloTreasureInfoOpenItemBoxMechanism(uid)
	if not ret then
		return
	end
	self:NotifyGameModeDungeonEvent("OnSoloTreasureSyncMechanism", Mechanism)	---更新容器机关状态
end

---移动物资，在玩家背包，回收站，机关背包 中移动 
function DungeonSoloTreasure:OnNotifyServerDungeonEvent_MoveTreasureItem(uid, TargetBagIndex, TargetSubBagIndex, Pos, IsRotate)
	local item_list = {}
	local uid_list = self:SoloTreasureInfoMoveItem(uid, TargetBagIndex, TargetSubBagIndex, Pos, IsRotate)
	for i = 1, #uid_list do
		table.insert(item_list, self:GetSoloTreasureItem(uid_list[i]))
	end
	self:NotifyGameModeDungeonEvent("OnSoloTreasureSyncItemList", item_list, false)	
end

---@param UpdateList SoloTreasureItem[]
function DungeonSoloTreasure:OnNotifyServerDungeonEvent_UpdateTreasureItemList(UpdateList)
	---@type SoloTreasureItem[]
	local CopyList = {}

	---备份
	for i = 1, #UpdateList do
		local ItemCopy = self:GetSoloTreasureItem(UpdateList[i].UniqueId)
		if ItemCopy == nil then
			self:NotifyGameModeDungeonEvent("OnSoloTreasureSyncItemList", {}, false)
			return
		end
		table.insert(CopyList, ItemCopy)
	end

	---删除背包物资
	local RemoveTreasureListFromBag = function(ItemList)
		for i = 1, #ItemList do
			---@type SoloTreasureItem
			local Item = ItemList[i]
			if Item.BagIndex == -1 then
				self:RemoveItemFromDestbinBag(Item.UniqueId)
			else
				---@type SoloTreasureBag
				local Bag = nil
				if Item.BagIndex == 0 then
					Bag = self.PlayerBagList[Item.SubBagIndex]
				else
					Bag = self.MechanismBagList[Item.BagIndex]
				end
				if Bag == nil or Bag:RemoveItem(Item.UniqueId) == false then
					--print("Bag.SlotDict = ",Bag.SlotDict)
					print(string.format("DungeonSoloTreasure:OnNotifyServerDungeonEvent_UpdateTreasureItemList RemoveTreasureListFromBag error. Bag == nil or Bag:RemoveItem(%s) == false", tostring(Item.UniqueId)))
					return false
				end
			end
		end	
		return true
	end
	---增加背包物资
	local AddTreasureListFromBag = function(ItemList)
		for i = 1, #ItemList do
			---@type SoloTreasureItem
			local Item = ItemList[i]
			if Item.BagIndex == -1 then
				self:MoveItem2DestbinBag(Item.UniqueId)
			else
				local tabExtractionTreasure = DataMgr.ExtractionTreasure[Item.Id]
				local sizeX, sizeY = tabExtractionTreasure.Shape[1], tabExtractionTreasure.Shape[2]
				if Item.Rotate then
					sizeX, sizeY = sizeY, sizeX
				end
				---@type SoloTreasureBag
				local Bag = nil
				if Item.BagIndex == 0 then
					Bag = self.PlayerBagList[Item.SubBagIndex]
				else
					Bag = self.MechanismBagList[Item.BagIndex]
				end
				if Bag == nil or Bag:MoveItem(Item.UniqueId, sizeX, sizeY, Item.Pos) == false then
					--print("Bag.SlotDict = ",Bag.SlotDict)
					print(string.format("DungeonSoloTreasure:OnNotifyServerDungeonEvent_UpdateTreasureItemList RemoveTreasureListFromBag error. Bag == nil or Bag:MoveItem(%s, %s, %s, %s) == false", tostring(Item.UniqueId), tostring(sizeX), tostring(sizeY),tostring(Item.Pos)))
					return false
				end
			end
		end
		return true
	end

	local RevertFunc = function()
		RemoveTreasureListFromBag(CopyList)					----旧的删干净
		RemoveTreasureListFromBag(UpdateList)				----新的删干净
		AddTreasureListFromBag(CopyList)					----回退成旧的
		self:NotifyGameModeDungeonEvent("OnSoloTreasureSyncItemList", {}, false)
	end
	if RemoveTreasureListFromBag(CopyList) == false then
		RevertFunc()
		return
	end
	if AddTreasureListFromBag(UpdateList) == false then
		RevertFunc()
		return
	end
	
	---replace
	for i = 1, #UpdateList do
		 self.AllItemHashMap[UpdateList[i].UniqueId] = UpdateList[i]
	end
	self:NotifyGameModeDungeonEvent("OnSoloTreasureSyncItemList", UpdateList, false)	
end

---献祭Ask
function DungeonSoloTreasure:OnNotifyServerDungeonEvent_SoloTreasureTribute(uid)
	local Mechanism = self:GetMechanism(uid)
	if Mechanism == nil or Mechanism.IsUnlock == false or Mechanism.IsUsed == true then
		return
	end
	local ret = self:SoloTreasureInfo_Tribute(Mechanism)
	if not ret then
		return
	end
	self:NotifyGameModeDungeonEvent("SoloTreasureTribute", uid)	
end

---扭蛋机-选彩票Ask
function DungeonSoloTreasure:OnNotifyServerDungeonEvent_SoloTreasureTicketSelect(uid, TicketId)
	local Mechanism = self:GetMechanism(uid)
	--if Mechanism == nil or Mechanism.IsUnlock == false then
	if Mechanism == nil then
		return
	end
	local ret = self:SoloTreasureInfo_TicketSelect(Mechanism, TicketId)
	if not ret then
		return
	end
	self:NotifyGameModeDungeonEvent("OnSoloTreasureSyncMechanism", Mechanism)
	self:NotifyGameModeDungeonEvent("SoloTreasureTicketSelect", uid, TicketId)	
end

---扭蛋机-刷新彩票Ask
function DungeonSoloTreasure:OnNotifyServerDungeonEvent_SoloTreasureRandomTicket(uid)
	local Mechanism = self:GetMechanism(uid)
	if Mechanism == nil or Mechanism.IsUnlock == false or Mechanism.IsUsed == true then
		return
	end
	if Mechanism.TicketInfo == nil then
		return
	end
	local ret = self:SoloTreasureInfo_RandomTicket(Mechanism)
	if not ret then
		return
	end
	self:NotifyGameModeDungeonEvent("OnSoloTreasureSyncMechanism", Mechanism)
	self:NotifyGameModeDungeonEvent("SoloTreasureRandomTicket", uid, Mechanism.TicketInfo.TicketList)
end


---机关解锁 Ask
function DungeonSoloTreasure:OnNotifyServerDungeonEvent_UnlockMechanism(uid)
	local Mechanism = self:GetMechanism(uid)
    if Mechanism == nil or Mechanism.IsUnlock then
        return
    end
	local ret = self:UnlockMechanism(Mechanism)
	if not ret then
		return	
	end
	self:NotifyGameModeDungeonEvent("UnlockMechanism", uid)
end


-- ---守护机关，被摧毁通知(修改为self.DefenceContainerInfos)
-- function DungeonSoloTreasure:OnNotifyServerDungeonEvent_DefenceMechanismDestory(uid)
-- 	local Mechanism = self:GetMechanism(uid)
-- 	if Mechanism == nil or Mechanism.IsDestory then
-- 		return
-- 	end
-- 	if DataMgr.ExtractionTreasureGuard[Mechanism.UnitId] == nil then
-- 		return
-- 	end
-- 	Mechanism.IsDestory = true
-- 	self:NotifyGameModeDungeonEvent("OnSoloTreasureSyncMechanism", Mechanism)
-- end

---秘宝房间Ask
function DungeonSoloTreasure:OnNotifyServerDungeonEvent_RewardRoomOpen(uid)
	local Mechanism = self:GetMechanism(uid)
	if Mechanism == nil or Mechanism.IsUnlock == false or Mechanism.IsUsed == true then
		return ErrorCode.RET_FAIL
	end
	local ret = self:SoloTreasureInfo_RewardRoomOpen(Mechanism)
	if not ret then
		return ErrorCode.RET_FAIL
	end
	self:NotifyGameModeDungeonEvent("RewardRoomOpen", uid)
	return ErrorCode.RET_SUCCESS
end


---测试GM,  加杀怪积分
function DungeonSoloTreasure:OnNotifyServerDungeonEvent_SoloTreasureSetScore(KillMonsterScore)
	self:SetSoloTreasureKillMonsterScore(KillMonsterScore)
	--DebugPrint("ayff test OnTriggerDungeonEvent_SoloTreasureSetScore KillMonsterScore:",KillMonsterScore)
end




return DungeonSoloTreasure