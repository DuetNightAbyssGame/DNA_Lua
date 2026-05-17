local SoloTreasureUtils = require "Utils.SoloTreasureUtils"
local SoloTreasureBag = require "BluePrints.DungeonObject.SoloTreasure.SoloTreasureBag"
local ServerDomStaticCreator = require "Datas.ServerDomLevel_data.ServerDomStaticCreator"
local ServerDomRandomCreator = require "Datas.ServerDomLevel_data.ServerDomRandomCreator"
local TimeUtils = require "src.utils.TimeUtils"
---@class SoloTreasureItem
local SoloTreasureItem = DungeonClass.Class()
SoloTreasureItem.UniqueId = -1
SoloTreasureItem.Id = -1
SoloTreasureItem.BagIndex = -1
SoloTreasureItem.SubBagIndex = -1
SoloTreasureItem.Pos = -1
SoloTreasureItem.Rotate = false



---局内全量数据结构
---@class SoloTreasureInfo
---@field PlayerBagList SoloTreasureBag[]                   --玩家背包
---@field MechanismBagList table<number,SoloTreasureBag>    --机关背包
---@field DestbinBag number[]                               --回收站<物资uid>
---@field AllItemHashMap table<number, SoloTreasureItem>    --所有物资(包括背包、机关、回收站)
---@field KillMonsterScore number                           --杀怪积分
---@field ItemUniqueIdInc number
---@field DungeonId number
---@field TicketId number
---@field BeginTimeStamp number                             --副本开始时间戳
---@field AllMechanismStaticIdList
local SoloTreasureInfo = DungeonClass.Class()
function SoloTreasureInfo:CleanupSoloTreasureInfo()
    self.PlayerBagList = {}
    self.MechanismBagList = {}
    self.DestbinBag = {}
    self.AllItemHashMap = {}
    self.KillMonsterScore = 0
    self.ItemUniqueIdInc = 0
    self.DungeonId = -1
    self.TicketId = -1
    self.BeginTimeStamp = TimeUtils.NowTime()
    self.AllMechanismStaticIdList = {}
end

function SoloTreasureInfo:SoloTreasureInfoNewPlayerBag()
    print(string.format("SoloTreasureInfo:SoloTreasureInfoNewPlayerBag(%d)", self.BagId))
    local tab = DataMgr.ExtractionTreasureBag[self.BagId]
    if tab == nil then
        return
    end
    local ShapeList = tab.Shape
    for i = 1, #ShapeList do
        local Shape = ShapeList[i]
        local NewBag = SoloTreasureBag()
        if NewBag then
            NewBag:Init(Shape[1], Shape[2])
            table.insert(self.PlayerBagList, NewBag)
        end
    end
    self:NotifyGameModeDungeonEvent("SoloTreasureInfoNewPlayerBag", self.BagId)
end

function SoloTreasureInfo:IsSoloTreasureMechanism(UnitId)
    return DataMgr.ExtractionTreasureMechanism[UnitId] ~= nil
        or DataMgr.ExtractionTreasureTribute[UnitId] ~= nil
        or DataMgr.ExtractionTreasureGuard[UnitId] ~= nil
        or DataMgr.ExtractionTreasureTicket[UnitId] ~= nil
        or DataMgr.ExtractionTreasureRewardRoom[UnitId] ~= nil
end

---新增一个机关后
function SoloTreasureInfo:OnCreateMechanism(MechanismUniqueId)
    local mechanism = self:GetMechanism(MechanismUniqueId)  ---已经由副本服务器创建
    if mechanism == nil then
        print(string.format("SoloTreasureInfo:self:GetMechanism(MechanismUniqueId(%s)) == nil", MechanismUniqueId))
        return
    end
    if self:IsSoloTreasureMechanism(mechanism.UnitId) == false then
        return ---不是寻宝关心的五种机关
    end
	print(string.format("SoloTreasureInfo:OnCreateMechanism(%s) UnitId(%s)", MechanismUniqueId, mechanism.UnitId))

    mechanism.OpenTimeStamp = -1    ---容器开启时间戳
    mechanism.IsUsed = false        ---献祭机关、秘宝房间，是否使用过
    mechanism.IsUnlock = true       ---默认解锁，特殊容器需要手动解锁
    
    local tabExtractionTreasureMechanism = DataMgr.ExtractionTreasureMechanism[mechanism.UnitId]
    if tabExtractionTreasureMechanism then ---物资容器， 需要背包
        ---@type SoloTreasureBag
        local NewBag = SoloTreasureBag()
        NewBag:Init(tabExtractionTreasureMechanism.Shape[1], tabExtractionTreasureMechanism.Shape[2])
        self.MechanismBagList[mechanism.UniqueId] = NewBag
    end
    local tabExtractionTreasureTribute = DataMgr.ExtractionTreasureTribute[mechanism.UnitId]
    if tabExtractionTreasureTribute then ---献祭容器， 需要背包
        ---@type SoloTreasureBag
        local NewBag = SoloTreasureBag()
        NewBag:Init(tabExtractionTreasureTribute.Shape[1], tabExtractionTreasureTribute.Shape[2])
        self.MechanismBagList[mechanism.UniqueId] = NewBag
    end
    local tabExtractionTreasureGuard = DataMgr.ExtractionTreasureGuard[mechanism.UnitId]
    if tabExtractionTreasureGuard then ---守护机关，守卫成功后的奖励阶段需要背包
        local _tabExtractionTreasureMechanism = DataMgr.ExtractionTreasureMechanism[tabExtractionTreasureGuard.MechanismItemBox]
        if _tabExtractionTreasureMechanism then
           local NewBag = SoloTreasureBag()
           NewBag:Init(_tabExtractionTreasureMechanism.Shape[1], _tabExtractionTreasureMechanism.Shape[2])
           self.MechanismBagList[mechanism.UniqueId] = NewBag
        end
    end
    local tabExtractionTreasureTicket = DataMgr.ExtractionTreasureTicket[mechanism.UnitId]
    if tabExtractionTreasureTicket then ---扭蛋机，需要彩票列表
        mechanism.TicketInfo = {}
        mechanism.TicketInfo.RenewalTimes = 0
        mechanism.TicketInfo.TicketList = SoloTreasureUtils:RandomTicketList()
    end

    ---献祭机关和扭蛋机，需要手动解锁
    if DataMgr.ExtractionTreasureTribute[mechanism.UnitId] or DataMgr.ExtractionTreasureTicket[mechanism.UnitId] then
        mechanism.IsUnlock = false
    end

    self:NotifyGameModeDungeonEvent("OnSoloTreasureSyncMechanism", mechanism)
end

---开启物资容器
---@param uid number ---要开启的物资容器的机关uid
function SoloTreasureInfo:SoloTreasureInfoOpenItemBoxMechanism(uid)
    local mechanism = self:GetMechanism(uid)
    if mechanism == nil then
        return false
    end
    local RewardItemBoxId = -1
    if DataMgr.ExtractionTreasureMechanism[mechanism.UnitId] then
        RewardItemBoxId = mechanism.UnitId
    end
    if DataMgr.ExtractionTreasureGuard[mechanism.UnitId] then ---如果是守护机关，容器id，是MechanismItemBox
        RewardItemBoxId = DataMgr.ExtractionTreasureGuard[mechanism.UnitId].MechanismItemBox
    end
    print(string.format("SoloTreasureInfoOpenItemBoxMechanism UniqueId=%s UnitId=%s RewardItemBoxId=%s", tostring(uid), tostring(mechanism.UnitId), tostring(RewardItemBoxId)))
    if RewardItemBoxId == -1 then
        return false
    end
    if mechanism.OpenTimeStamp > 0 then
        print(string.format("SoloTreasureInfoOpenItemBoxMechanism(%s) mechanism.OpenTimeStamp(%s) > 0", tostring(uid), tostring(mechanism.OpenTimeStamp)))
        return false
    end

    mechanism.OpenTimeStamp = os.time() ---标记已打开，之后不可再次随机宝物

    local itemlist = {}
    local ItemIdList = SoloTreasureUtils:GetExtractionTreasureMechanismItemList(RewardItemBoxId)
    print("ItemIdList = "..CommonUtils.TableToString3(ItemIdList))
    for i = 1, #ItemIdList do
        local item = self:SoloTreasureInfoNewMechanismItem(uid, ItemIdList[i])
        if item then
            table.insert(itemlist, item)
        end
    end
    print(string.format("SoloTreasureInfo:SoloTreasureInfoOpenItemBoxMechanism(%s, %s) CreateNewMechanismItem=%s", tostring(uid), tostring(mechanism.UnitId), CommonUtils.TableToString3(itemlist))) 
    self:NotifyGameModeDungeonEvent("OnSoloTreasureSyncItemList", itemlist, true)		    ---更新新创建的物资列表
    return true
end

---物资在玩家背包、回收站、机关背包之间移动
---@param uid number 物资uid
---@param TargetBagIndex number 同SrcBagIndex
---@param TargetSubBagIndex number 同SrcSubBagIndex
---@param Pos number 目标格子(一维)
---@param IsRotate boolean 本次操作是否旋转
function SoloTreasureInfo:SoloTreasureInfoMoveItem(uid, TargetBagIndex, TargetSubBagIndex, Pos, IsRotate)
    -- print(string.format("SoloTreasureInfoMoveItem(uid(%s), TargetBagIndex(%d), TargetSubBagIndex(%d), Pos(%d)) Begin", 
    --         uid, TargetBagIndex, TargetSubBagIndex, Pos))
    local Item = self.AllItemHashMap[uid]
    if Item == nil then
        print("SoloTreasureInfoMoveItem Item == nil")
        return {}
    end
    local tabExtractionTreasure = DataMgr.ExtractionTreasure[Item.Id]
    if tabExtractionTreasure == nil then
        print("SoloTreasureInfoMoveItem tabExtractionTreasure == nil")
        return {}
    end
    local sizeX, sizeY = tabExtractionTreasure.Shape[1], tabExtractionTreasure.Shape[2]
    if Item.Rotate then
        sizeX, sizeY = sizeY, sizeX
    end
    if IsRotate then
        sizeX, sizeY = sizeY, sizeX
    end

    ---起始位置
    local SourceBagIndex = Item.BagIndex
    local SourceSubIndex = Item.SubBagIndex
    local SourcePos = Item.Pos
    local conflict_list = {uid} ---冲突的物资list
    if self:CanPlacementItem2Bag(uid, TargetBagIndex, TargetSubBagIndex, sizeX, sizeY, Pos, conflict_list) == false then
        print(string.format("CanPlacementItem2Bag(uid(%s), TargetBagIndex(%s), TargetSubBagIndex(%s), sizeX(%s), sizeY(%s), Pos(%s)) == false", 
            tostring(uid), tostring(TargetBagIndex), tostring(TargetSubBagIndex), tostring(sizeX), tostring(sizeY), tostring(Pos)))
        return {}
    end

    print(string.format("SoloTreasureInfoMoveItem(%s) conflictlist = ", uid), CommonUtils.TableToString3(conflict_list))

    ---解决冲突，将冲突的物资从它们自己的Bag中移除
    for i = 1, #conflict_list do
        if self:PopItemFromBag(conflict_list[i]) == false then
            print("SoloTreasureInfoMoveItem self:PopItemFromBag(conflict_list[i] == false")
            return {}
        end
    end

    ---将要操作的物资对象放入目标背包目标位置
    local NewPos = self:PlacementItem2Bag(uid, TargetBagIndex, TargetSubBagIndex, sizeX, sizeY, Pos)
    if NewPos == -1 then
        print("SoloTreasureInfoMoveItemNewPos == -1")
        return {}
    end

    ---物资对象放入成功, 更新物资信息
    Item.BagIndex = TargetBagIndex
    Item.SubBagIndex = TargetSubBagIndex
    Item.Pos = NewPos
    if IsRotate then
        Item.Rotate = not Item.Rotate
    end

    ---处理冲突的物资对象, 从<SourceBagIndex, SourceSubIndex, SourcePos>开始追加物资，重新分配坐标
    for i = 2, #conflict_list do
        self:PushBackItem2Bag(conflict_list[i], SourceBagIndex, SourceSubIndex, SourcePos)
    end

    for i = 1, #conflict_list do
        local uid = conflict_list[i]
        local item = self.AllItemHashMap[uid]
        print(string.format("conflict_list[%d] item = ", i) .. CommonUtils.TableToString3(item))
    end

    -- print(string.format("SoloTreasureInfoMoveItem(uid(%s), TargetBagIndex(%d), TargetSubBagIndex(%d), sizeX(%d), sizeY(%d), Pos(%d)) Finish", 
    --         uid, TargetBagIndex, TargetSubBagIndex, sizeX, sizeY, Pos))
    return conflict_list
end

function SoloTreasureInfo:CanPlacementItem2Bag(uid, BagIndex, SubBagIndex, SizeX, SizeY, Pos, ConflictList)
    if BagIndex == -1 then
        return true
    elseif BagIndex == 0 then
        ---角色背包
        return self.PlayerBagList[SubBagIndex] and self.PlayerBagList[SubBagIndex]:CanPlacementItem(uid, SizeX, SizeY, Pos, ConflictList)
    else
        ---机关背包
        return self.MechanismBagList[BagIndex] and self.MechanismBagList[BagIndex]:CanPlacementItem(uid, SizeX, SizeY, Pos, ConflictList) 
    end
end
function SoloTreasureInfo:PlacementItem2Bag(uid, BagIndex, SubBagIndex, SizeX, SizeY, Pos)
    if BagIndex == -1 then
        return self:MoveItem2DestbinBag(uid)
    elseif BagIndex == 0 and self.PlayerBagList[SubBagIndex] then
        return self.PlayerBagList[SubBagIndex]:PlacementItem(uid, SizeX, SizeY, Pos)
    elseif self.MechanismBagList[BagIndex]  then
        return self.MechanismBagList[BagIndex]:PlacementItem(uid, SizeX, SizeY, Pos)
    end
    return -1
end


---压入物资，如果压入失败，加入回收站（往背包里追加物资，追加失败放入回收站）
function SoloTreasureInfo:PushBackItem2Bag(uid, BagIndex, SubBagIndex, Pos)
    local Item = self.AllItemHashMap[uid]
    if Item == nil then
        return
    end
    local tabExtractionTreasure = DataMgr.ExtractionTreasure[Item.Id]
    if tabExtractionTreasure == nil then
        return
    end

    Item.BagIndex = BagIndex
    Item.SubBagIndex = SubBagIndex
    Item.Pos = Pos
    local sizeX, sizeY = tabExtractionTreasure.Shape[1], tabExtractionTreasure.Shape[2]
    if Item.Rotate then
        sizeX, sizeY = sizeY, sizeX
    end
    
    if BagIndex == -1 then
        Item.Pos = self:MoveItem2DestbinBag(uid)
    elseif BagIndex == 0 and self.PlayerBagList[SubBagIndex] then
        Item.Pos = self.PlayerBagList[SubBagIndex]:PushItem(uid, sizeX, sizeY, Pos)
    elseif self.MechanismBagList[BagIndex] then
        Item.Pos = self.MechanismBagList[BagIndex]:PushItem(uid, sizeX, sizeY, Pos)
    end
    ---如果压入背包失败，压入回收站
    if Item.Pos == -1 then
        Item.BagIndex = -1
        Item.SubBagIndex = -1
        Item.Pos = self:MoveItem2DestbinBag(uid)
    end
end

function SoloTreasureInfo:PopItemFromBag(uid)
    local Item = self.AllItemHashMap[uid]
    if Item == nil then
        return false
    end
    if Item.BagIndex == -1 then
        self:RemoveItemFromDestbinBag(uid)----如果从回收站移出
        return true
    end
    local tabExtractionTreasure = DataMgr.ExtractionTreasure[Item.Id]
    if tabExtractionTreasure == nil then
        return false
    end
    local sizeX, sizeY = tabExtractionTreasure.Shape[1], tabExtractionTreasure.Shape[2]
    if Item.Rotate then
        sizeX, sizeY = sizeY, sizeX
    end
    local pos = Item.Pos
    if Item.BagIndex == 0 then
        return self.PlayerBagList[Item.SubBagIndex] and self.PlayerBagList[Item.SubBagIndex]:PopItem(uid)
    else
        return self.MechanismBagList[Item.BagIndex] and self.MechanismBagList[Item.BagIndex]:PopItem(uid)        
    end
    return false
end

---加入回收站
function SoloTreasureInfo:MoveItem2DestbinBag(uid)
    local NewPos = #self.DestbinBag + 1
    for i = 1, #self.DestbinBag do
        if self.DestbinBag[i] == -1 then
            NewPos = i
            break
        end
    end
    self.DestbinBag[NewPos] = uid 
    return NewPos
end
---移除回收站
function SoloTreasureInfo:RemoveItemFromDestbinBag(uid)
    for i = 1, #self.DestbinBag do
        if self.DestbinBag[i] == uid then
            self.DestbinBag[i] = -1
            return true
        end
    end
    return false
end

---机关内，创建一个物资
---@param MechanismUniqueId number 机关对象uid
---@param itemId number ExtractionTreasure.xlsx的Id
function SoloTreasureInfo:SoloTreasureInfoNewMechanismItem(MechanismUniqueId, ItemId)
    local tabExtractionTreasure = DataMgr.ExtractionTreasure[ItemId]
    if tabExtractionTreasure == nil then
        return nil
    end

    local MechanismBag = self.MechanismBagList[MechanismUniqueId]
    if MechanismBag == nil then
        return nil
    end
    local sizeX = tabExtractionTreasure.Shape[1]
    local sizeY = tabExtractionTreasure.Shape[2]
    local uid = self:GenSoloTreasureItemUniqueId()
    local Pos = MechanismBag:PushItem(uid, sizeX, sizeY)
    if Pos == -1 then
        return nil
    end
    ---放置成功，创建真正的物资对象
    local _SoloTreasureItem = SoloTreasureItem()
    _SoloTreasureItem.UniqueId = uid
    _SoloTreasureItem.Id = ItemId
    _SoloTreasureItem.BagIndex = MechanismUniqueId
    _SoloTreasureItem.SubBagIndex = 0
    _SoloTreasureItem.Pos = Pos
    _SoloTreasureItem.Rotate = false
    self.AllItemHashMap[uid] = _SoloTreasureItem
    return _SoloTreasureItem
end


---完全销毁一个物资
---@param ItemUniqueId number 物资uid
function SoloTreasureInfo:SoloTreasureInfoDestoryItem(ItemUniqueId)
    local Item = self.AllItemHashMap[ItemUniqueId]
    if Item == nil then
        return false
    end
    local Bag = nil
    if Item.BagIndex == 0 then
        Bag = self.PlayerBagList[Item.SubBagIndex]
    else
       Bag = self.MechanismBagList[Item.BagIndex] 
    end
    if Bag == nil then
        return false
    end
    local ItemId = Item.Id
    local IsRotate = Item.Rotate
    local tabExtractionTreasure = DataMgr.ExtractionTreasure[ItemId]
    if tabExtractionTreasure == nil then
        return false
    end
    local sizeX, sizeY = tabExtractionTreasure.Shape[1], tabExtractionTreasure.Shape[2]
    if IsRotate then
        sizeX, sizeY = sizeY, sizeX
    end
    local ret = Bag:PopItem(ItemUniqueId, sizeX, sizeY)
    if ret then
       self.AllItemHashMap[ItemUniqueId] = nil
    end
    return ret
end

function SoloTreasureInfo:GenSoloTreasureItemUniqueId()
    self.ItemUniqueIdInc = self.ItemUniqueIdInc + 1
    return self.ItemUniqueIdInc
end

---打开秘宝房间
function SoloTreasureInfo:SoloTreasureInfo_RewardRoomOpen(Mechanism)
    local tabExtractionTreasureRewardRoom = DataMgr.ExtractionTreasureRewardRoom[Mechanism.UnitId]
    if tabExtractionTreasureRewardRoom == nil then
        return false
    end
    local KeyId = tabExtractionTreasureRewardRoom.KeyID
    local ItemUniqueId = -1
    for uid, Item in pairs(self.AllItemHashMap) do
        if Item.BagIndex == 0 then
            if Item.Id == KeyId then
                ItemUniqueId = Item.UniqueId
                break
            end
        end
    end
    if ItemUniqueId == -1 then
        return false
    end
    if self:SoloTreasureInfoDestoryItem(ItemUniqueId) == false then
        return false
    end
    self:NotifyGameModeDungeonEvent("OnSoloTreasureDeleteItemList", {ItemUniqueId})
    
    Mechanism.IsUsed = true
    self:NotifyGameModeDungeonEvent("OnSoloTreasureSyncMechanism", Mechanism)
    return true
end

---献祭机关
---@param MechanismUniqueId number 操作的献祭机关uid
function SoloTreasureInfo:SoloTreasureInfo_Tribute(Mechanism)
    local MechanismUniqueId = Mechanism.UniqueId
    local tabSoloTreasure = DataMgr.SoloTreasure[self.DungeonId]
    if tabSoloTreasure == nil or tabSoloTreasure.GamePlayId == nil then
        return
    end
    local tabExtractionMechanism = DataMgr.ExtractionTreasureTribute[Mechanism.UnitId]
    if tabExtractionMechanism == nil then
        return
    end
    local MechanismBag = self.MechanismBagList[MechanismUniqueId]
    if MechanismBag == nil then
        return
    end
    local tabSoloTreasureGamePlay = nil
    for i = 1, #tabSoloTreasure.GamePlayId do
        local GamePlayId = tabSoloTreasure.GamePlayId[i]
        local _tabSoloTreasureGamePlay = DataMgr.SoloTreasureGamePlay[GamePlayId]
        if _tabSoloTreasureGamePlay and _tabSoloTreasureGamePlay.Container and SoloTreasureUtils:IsUnitIdInStaticContainerList(self.DungeonId, _tabSoloTreasureGamePlay.Container, Mechanism.UnitId) then
            tabSoloTreasureGamePlay = _tabSoloTreasureGamePlay
            break
        end
    end
    if tabSoloTreasureGamePlay == nil then
        return
    end
    local TributeItemList = {}---物资uid的list
    local TotalScore = 0
    for uid, Item in pairs(self.AllItemHashMap) do
        if Item.BagIndex == MechanismUniqueId then
            table.insert(TributeItemList, uid)
            local tab = DataMgr.ExtractionTreasure[Item.Id]
            if tab then
                TotalScore = TotalScore + tab.TreasureValue
            end
        end
    end

    local MonsterSpawnId = -1
    if TotalScore <= 0 then
        MonsterSpawnId = -1
    elseif TotalScore < tabSoloTreasureGamePlay.Gear1 then
        MonsterSpawnId = tabSoloTreasureGamePlay.Monster1
    elseif TotalScore < tabSoloTreasureGamePlay.Gear2 then
        MonsterSpawnId = tabSoloTreasureGamePlay.Monster2
    elseif TotalScore < tabSoloTreasureGamePlay.Gear3 then
        MonsterSpawnId = tabSoloTreasureGamePlay.Monster3
    --elseif TotalScore < tabSoloTreasureGamePlay.Gear4 then
    else
        MonsterSpawnId = tabSoloTreasureGamePlay.Monster4
    end
    if MonsterSpawnId == -1 then return end

    ---删除物资
    for i = 1, #TributeItemList do
        if self:SoloTreasureInfoDestoryItem(TributeItemList[i]) == false then
            --error
            print(string.format("SoloTreasureInfo_Tribute self:SoloTreasureInfoDestoryItem(ItemUniqueId(%s)) == false"), TributeItemList[i])
            return
        end
    end
    print("SoloTreasureInfo_Tribute  TributeItemList = ", TributeItemList)
    self:NotifyGameModeDungeonEvent("OnSoloTreasureDeleteItemList", TributeItemList)


    Mechanism.IsUsed = true ---只能献祭一次
    self:NotifyGameModeDungeonEvent("OnSoloTreasureSyncMechanism", Mechanism)
    
    --TODO 刷怪
    self:ServerTriggerCreateMonsterSpawn({MonsterSpawnId}, false)
    return true
end


function SoloTreasureInfo:SoloTreasureInfo_TicketSelect(Mechanism, TicketId)
    local tabExtractionTreasureTicket = DataMgr.ExtractionTreasureTicket[Mechanism.UnitId]
    if tabExtractionTreasureTicket == nil then
        return
    end
    if Mechanism.TicketInfo == nil or next(Mechanism.TicketInfo.TicketList) == nil  then
        return
    end
    if CommonUtils.HasValue(Mechanism.TicketInfo.TicketList, TicketId) == false then
        print(string.format("SoloTreasureInfo:SoloTreasureInfo_TicketSelect(%d, %d) Error. TicketList = ", Mechanism.UnitId, TicketId).. CommonUtils.TableToString3(Mechanism.TicketInfo.TicketList)) 
        return
    end
    
    self.TicketId = TicketId
    return true
end

---刷新彩票
function SoloTreasureInfo:SoloTreasureInfo_RandomTicket(Mechanism)
    if Mechanism.TicketInfo == nil then
        return
    end
    local tabExtractionTreasureTicket = DataMgr.ExtractionTreasureTicket[Mechanism.UnitId]
    if tabExtractionTreasureTicket == nil or tabExtractionTreasureTicket.RenewalPoint == nil or next(tabExtractionTreasureTicket.RenewalPoint)==nil then
        return
    end
    local RenewalTimes = Mechanism.TicketInfo.RenewalTimes + 1
    
    local CostPoint = tabExtractionTreasureTicket.RenewalPoint[RenewalTimes]
    if CostPoint == nil then
        CostPoint = tabExtractionTreasureTicket.RenewalPoint[#tabExtractionTreasureTicket.RenewalPoint]
    end
    if CostPoint == nil then
        return
    end

    if self:GetSoloTreasureKillMonsterScore() < CostPoint then
        return
    end
    self:SetSoloTreasureKillMonsterScore(self:GetSoloTreasureKillMonsterScore() - CostPoint)
    print(string.format("SoloTreasureInfo_RandomTicket uid(%s) MechanismId(%d) RenewalTimes(%d) CostPoint(%d)", Mechanism.UniqueId, Mechanism.UnitId, RenewalTimes, CostPoint))

    local list = SoloTreasureUtils:RandomTicketList()
    if next(list) == nil then
        return
    end

    Mechanism.TicketInfo.RenewalTimes = RenewalTimes
    Mechanism.TicketInfo.TicketList = list
    return true
end


function SoloTreasureInfo:UnlockMechanism(Mechanism)
    local MechanismId = Mechanism.UnitId
    local NeedPoint = 0
    if DataMgr.ExtractionTreasureTribute[MechanismId] then
        NeedPoint = DataMgr.ExtractionTreasureTribute[MechanismId].UnlockPoint 
    end
    if DataMgr.ExtractionTreasureTicket[MechanismId] then
        NeedPoint = DataMgr.ExtractionTreasureTicket[MechanismId].UnlockPoint
    end
    ---Other ...
    if self:GetSoloTreasureKillMonsterScore() < NeedPoint then
        return false
    end
    if NeedPoint > 0 then
        self:SetSoloTreasureKillMonsterScore(self:GetSoloTreasureKillMonsterScore() - NeedPoint)
    end
    Mechanism.IsUnlock = true
    self:NotifyGameModeDungeonEvent("OnSoloTreasureSyncMechanism", Mechanism)
    return true
end


function SoloTreasureInfo:GetSoloTreasureItem(uid)
    return CommonUtils.Copy(self.AllItemHashMap[uid])
end


function SoloTreasureInfo:GetSoloTreasureInfo()
    return self:GetSoloTreasureDetailInfo()
end

---@return SoloTreasureDetailInfo
function SoloTreasureInfo:GetSoloTreasureDetailInfo()
    ---@type SoloTreasureDetailInfo
    local info = {}
    info.ItemList = {}
    for uid, item in pairs(self.AllItemHashMap) do
        if item.BagIndex == 0 then
            table.insert(info.ItemList, item.Id)
        end
    end
    info.KillMonsterScore = self:GetSoloTreasureKillMonsterScore()
    info.TreasureScore = SoloTreasureUtils:CalcTotalTreasureScore(self.AllItemHashMap, self.TicketId)
    info.Ticket = self.TicketId
    info.DungeonId = self.DungeonId
    info.BeginTimeStamp = self.BeginTimeStamp
    return info
end

function SoloTreasureInfo:SetSoloTreasureTimeStamp(ANSITime)
    self.BeginTimeStamp = ANSITime
end


function SoloTreasureInfo:SetSoloTreasureKillMonsterScore(KillMonsterScore)
    print(string.format("SoloTreasureInfo:SetSoloTreasureKillMonsterScore OldKillMonsterScore(%d) NewKillMonsterScore(%d)", self.KillMonsterScore, KillMonsterScore))
    self.KillMonsterScore = KillMonsterScore
    self:NotifyGameModeDungeonEvent("OnUpdateKillMonsterScore", self.KillMonsterScore)
end
function SoloTreasureInfo:GetSoloTreasureKillMonsterScore()
    return self.KillMonsterScore
end



function SoloTreasureInfo:OnServerActiveStaticCreator(Infos)
    self.AllMechanismStaticIdList = {}
    for i = 1, #Infos do
       if self:IsSoloTreasureMechanism(Infos[i].UnitId) then
            table.insert(self.AllMechanismStaticIdList, Infos[i])
       end
    end
end
function SoloTreasureInfo:GetMechanismStaticIdByUniqueId(UniqueId)
    for i = 1, #self.AllMechanismStaticIdList do
        if self.AllMechanismStaticIdList[i].UniqueId == UniqueId then
            return self.AllMechanismStaticIdList[i].StaticCreatorId
        end
    end
    return -1
end

function SoloTreasureInfo:Init(param)
    self:CleanupSoloTreasureInfo()
    self.DungeonId = param.DungeonId
    self.BagId = param.CustomDungeonParams and param.CustomDungeonParams.BagId or 1
end

function SoloTreasureInfo:BeginPlay()
    print("SoloTreasureInfo BeginPlay()")
    self:SoloTreasureInfoNewPlayerBag()
end
function SoloTreasureInfo:EndPlay()
    print("SoloTreasureInfo EndPlay()")
    self:CleanupSoloTreasureInfo()
end

function SoloTreasureInfo:CustomFinishInfo()
    local info = self:GetSoloTreasureInfo()
    self:NotifyGameModeDungeonEvent("OnSoloTreasureDeal", info)
    return info
end

function SoloTreasureInfo:GM_AddSoloTreasure(ItemId)
    local tabExtractionTreasure = DataMgr.ExtractionTreasure[ItemId]
    if tabExtractionTreasure == nil then
        return
    end

    for i = 1, #self.PlayerBagList do
        local bag = self.PlayerBagList[i]
        local sizeX = tabExtractionTreasure.Shape[1]
        local sizeY = tabExtractionTreasure.Shape[2]
        local uid = self:GenSoloTreasureItemUniqueId()
        local Pos = bag:PushItem(uid, sizeX, sizeY)
        if Pos ~= -1 then
            ---放置成功，创建真正的物资对象
            local _SoloTreasureItem = SoloTreasureItem()
            _SoloTreasureItem.UniqueId = uid
            _SoloTreasureItem.Id = ItemId
            _SoloTreasureItem.BagIndex = 0
            _SoloTreasureItem.SubBagIndex = i
            _SoloTreasureItem.Pos = Pos
            _SoloTreasureItem.Rotate = false
            self.AllItemHashMap[uid] = _SoloTreasureItem
            self:NotifyGameModeDungeonEvent("OnSoloTreasureSyncItemList", {_SoloTreasureItem}, true)
            return
        end
    end
end

return SoloTreasureInfo