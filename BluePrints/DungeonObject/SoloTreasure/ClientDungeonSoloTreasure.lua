
local InventoryController = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryController")
local TimeUtils = require "Utils.TimeUtils"

local ClientDungeonSoloTreasure = {}

function ClientDungeonSoloTreasure:ClearMechanismCache()
	self.MechanismInfoMap = {}
end

---获取缓存的机关信息
---@param UniqueId number 机关唯一ID
---@return table 机关信息
function ClientDungeonSoloTreasure:GetCachedMechanismInfo(UniqueId)
	return self.MechanismInfoMap and self.MechanismInfoMap[UniqueId]
end

---客户端创建背包
---@param BagId number
function ClientDungeonSoloTreasure:OnNotifyGameModeDungeonEvent_SoloTreasureInfoNewPlayerBag(BagId)
	print(string.format("OnNotifyGameModeDungeonEvent_SoloTreasureInfoNewPlayerBag(%d)", BagId))
	InventoryController:Destory()
	local InitParams = {
        BagId = BagId,
		bServerInit = true,
    }
    InventoryController:Init(InitParams)
	self.AllItemList = {}
end

---根据TreasureId获取所有类型为TreasureId的TreasureData
---@param TreasureId number
---@return table TreasureData: 所有目标为TreasureId的TreasureData
---@TreasureItemData table：{
--     UUid = Num,
--     TreasureId = Num,
--     Treasure = UserWidget,
--     bInRecycleGrid = bool,
--     Size = FVector2D(X, Y),
--     Direction = InventoryCommonConst.Direction,
-- }
function ClientDungeonSoloTreasure:GetTreasureDatasById(TreasureId)
	print(string.format("ClientDungeonSoloTreasure:GetTreasureDatasById(%d)", TreasureId))
	local TreasureDatas = InventoryController:GetTreasureDatasById(TreasureId)
	return TreasureDatas
end

---机关信息Sync
---@param Mechanism
function ClientDungeonSoloTreasure:OnNotifyGameModeDungeonEvent_OnSoloTreasureSyncMechanism(Mechanism)
	--print("OnNotifyGameModeDungeonEvent_OnSoloTreasureSyncMechanism " .. CommonUtils.TableToString3(Mechanism))
	
	if Mechanism and Mechanism.UniqueId then
		self.MechanismInfoMap = self.MechanismInfoMap or {}
		self.MechanismInfoMap[Mechanism.UniqueId] = Mechanism
	end
	
	--Mechanism.UniqueId = -1
	--Mechanism.UnitId = -1
	--Mechanism.OpenTimeStamp = -1    ---容器开启时间戳
    --Mechanism.IsUsed = false        ---献祭机关、守护机关、秘宝房间，是否使用过
    --Mechanism.IsDestory = false     ---守护机关是否被摧毁
    --Mechanism.IsUnlock = true       ---默认解锁，特殊容器需要手动解锁
end

---更新物资信息。新建、移动都会触发
---@param SyncItemList SoloTreasureItem[]  @刘庚池
function ClientDungeonSoloTreasure:OnNotifyGameModeDungeonEvent_OnSoloTreasureSyncItemList(SyncItemList, IsNew)
	--print("OnNotifyGameModeDungeonEvent_OnSoloTreasureSyncItemList " .. CommonUtils.TableToString3(SyncItemList))
	if not SyncItemList or not next(SyncItemList) then
		print("OnNotifyGameModeDungeonEvent_OnSoloTreasureSyncItemList SyncItemList is empty 服务器校验不通过！")
		return
	end
	for _, ItemData in pairs(SyncItemList) do
		self.AllItemList[ItemData.UniqueId] = ItemData
	end
	if IsNew then
		for _, ItemData in pairs(SyncItemList) do
			InventoryController:UpdateTreasureItemDataServerNew(ItemData)
		end
		return
	end
	local bSuccess = SyncItemList and next(SyncItemList)
	InventoryController:UpdateTreasureItemDataServer(bSuccess)
end

---@param DeleteItemList number[]		@刘庚池
function ClientDungeonSoloTreasure:OnNotifyGameModeDungeonEvent_OnSoloTreasureDeleteItemList(DeleteItemList)
	--print("OnNotifyGameModeDungeonEvent_OnSoloTreasureDeleteItemList " .. CommonUtils.TableToString3(DeleteItemList))
	for _, UniqueId in pairs(DeleteItemList) do
		InventoryController:DeleteTreasureItemDataServer(self.AllItemList[UniqueId])
		self.AllItemList[UniqueId] = nil
	end
end

---得到局内信息
function ClientDungeonSoloTreasure:OnNotifyGameModeDungeonEvent_OnGetSoloTreasureInfo(info)
	--print("OnNotifyGameModeDungeonEvent_OnGetSoloTreasureInfo "..CommonUtils.TableToString3(info))
	--print(info.ItemList) number[] ---物资列表
	--print(info.KillMonsterScore)  ---杀怪积分
	--print(info.TreasureScore)		---物资积分
	--print(info.Ticket)			---彩票Id
	--print(info.DungeonId)			---副本Id
	--print(info.BeginTimeStamp)	---副本开始时间戳
	self.KillMonsterScore = info.KillMonsterScore
	self.TreasureScore = info.TreasureScore
end

---局内杀怪积分Update
function ClientDungeonSoloTreasure:OnNotifyGameModeDungeonEvent_OnUpdateKillMonsterScore(KillMonsterScore)
	print("OnNotifyGameModeDungeonEvent_OnUpdateKillMonsterScore ".. tostring(KillMonsterScore))
	----
	self.KillMonsterScore = self.KillMonsterScore or 0
	local AddKillMonsterScore = KillMonsterScore - self.KillMonsterScore
	self.KillMonsterScore = KillMonsterScore
	EventManager:FireEvent(EventID.OnUpdateGameScore, AddKillMonsterScore, KillMonsterScore)
end

---局内背包物品积分Update
function ClientDungeonSoloTreasure:OnNotifyGameModeDungeonEvent_OnUpdateTreasureScore(TreasureScore)
	print("OnNotifyGameModeDungeonEvent_OnUpdateTreasureScore ".. tostring(TreasureScore))
	----
	self.TreasureScore = self.TreasureScore or 0
	local AddTreasureScore = TreasureScore - self.TreasureScore or 0
	self.TreasureScore = TreasureScore
	EventManager:FireEvent(EventID.OnUpdateBagTreasureScore, AddTreasureScore)
end

---副本结算
function ClientDungeonSoloTreasure:OnNotifyGameModeDungeonEvent_OnSoloTreasureDeal(info)
	--print("OnNotifyGameModeDungeonEvent_OnSoloTreasureDeal " .. CommonUtils.TableToString3(info))
	self.KillMonsterScore = info.KillMonsterScore
	self.TreasureScore = info.TreasureScore
	self.Ticket = info.Ticket
	self.DungeonId = info.DungeonId
	self.BeginTimeStamp = info.BeginTimeStamp

	if self.BeginTimeStamp == nil then
		print("OnNotifyGameModeDungeonEvent_OnSoloTreasureDeal BeginTimeStamp gets nil.")
		return
	end
	local EndTimeStamp = TimeUtils.NowTime()
	print("ClientDungeonSoloTreasure OnSoloTreasureDeal EndTimeStamp = ", EndTimeStamp, "BeginTimeStamp = ", self.BeginTimeStamp)
	self.EvacuationTime = EndTimeStamp - self.BeginTimeStamp
end

---献祭Ack
function ClientDungeonSoloTreasure:OnNotifyGameModeDungeonEvent_SoloTreasureTribute(uid)
	print("OnNotifyGameModeDungeonEvent_SoloTreasureTribute mechanismuid = :"..tostring(uid))
	---
	InventoryController:OnSoloTreasureTribute()
	EventManager:FireEvent(EventID.OnSoloTreasureTribute, uid)
end

---扭蛋机-选彩票Ack
function ClientDungeonSoloTreasure:OnNotifyGameModeDungeonEvent_SoloTreasureTicketSelect(uid, TicketId)
	print(string.format("OnNotifyGameModeDungeonEvent_SoloTreasureTicketSelect uid(%s) TicketId(%d)", uid, TicketId))
	self.SoloTreasureTicketId = TicketId
	EventManager:FireEvent(EventID.OnSoloTreasureGetTicket, TicketId)
end

---扭蛋机-刷新彩票Ack. 彩票列表从Mechanism上拿
function ClientDungeonSoloTreasure:OnNotifyGameModeDungeonEvent_SoloTreasureRandomTicket(uid, TicketList)
	print("OnNotifyGameModeDungeonEvent_SoloTreasureRandomTicket uid = "..tostring(uid))
	--print("OnNotifyGameModeDungeonEvent_SoloTreasureRandomTicket TicketList = ".. CommonUtils.TableToString3(TicketList))
	EventManager:FireEvent(EventID.OnSoloTreasureRefreshTickets, TicketList)
end

---机关解锁 Ack
function ClientDungeonSoloTreasure:OnNotifyGameModeDungeonEvent_UnlockMechanism(uid)
	----
end


---打开秘宝房间Ack
function ClientDungeonSoloTreasure:OnNotifyGameModeDungeonEvent_RewardRoomOpen(uid)
	---
end

return ClientDungeonSoloTreasure