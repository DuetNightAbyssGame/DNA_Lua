--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
require "DataMgr"
local TaskUtils = require "BluePrints.UI.TaskPanel.TaskUtils"
local GuidePointLocData = require ("BluePrints.UI.TaskPanel/QuestGuidePointLocData")
local WBP_UnSpecialSideIndicatorUI_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_UnSpecialSideIndicatorUI_C:Initialize(Initializer)
    self.Super.Initialize(self)
    self.TargetPointPos = nil
    self.HelperCoefficient = 80
    self.OverrideNpcHelperCoefficient = 40      -- 仅针对NPC单独重载的指引点高度
    self.CenterPos = nil
    --指引逻辑逐步迁移到 Storyline
    self.TargetPointType = nil
    self.TargetPointName = nil
    self.TargetAreaName = nil
    self.IsNeedChangeSmartGuideStyle = true
    self.IsShowSmartPointStyle = false
    self.BelongToQuestChainId = 0
    self.IsRangeOrPoint = false
    self.IsInTaskRegion = false
    self.NpcIndicatorPreVisibility = 0
end

function WBP_UnSpecialSideIndicatorUI_C:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    self:OnLoadedInit()
    self:OnLoadedTaskIndicator()
    self.OwnerDisplayName, self.OwenrQuestNpcId = ...
    self:SetNpcSideQuestGuideInfo(self.OwnerDisplayName)
end

function WBP_UnSpecialSideIndicatorUI_C:OnLoadedInit()
    local DesignedScreenSize = UIManager(self):GetDesignedScreenSize()
    self.CenterPos = FVector2D(DesignedScreenSize.X / 2, DesignedScreenSize.Y / 2)
    self.Guide_Node:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.TargetWorldLoc = FVector(0, 0, 0) 
    self.OvalSize = FVector2D(0, 0)
    self.ScreenLocation = FVector2D(0, 0)
    self.CurrentWorldLoc = FVector(0, 0, 0) 
    self.LocationLerpInterval = 3                       -- 指引点的世界坐标插值间隙
    self.BoardSize = FVector2D(30, 30)                  -- 指引显示范围边界大小
    self.TargetOffsetOnDoor = 0                         -- 指引的偏移（挂在门上面的时候，插值目标点）
    self.CurrentOffsetOnDoor = 0                        -- 指引的偏移（挂在门上面的时候，插值当前点）
    self.OffsetLerpInterval = 150                       -- 指引点偏移插值间隙
    self.CacheScreenPos = FVector2D(0, 0)
    self.DistanceUnit = GText("UI_SCALE_METER")
    self.PlayerRegionId = 0
    self.SmartGuidePointInfo = nil
end

function WBP_UnSpecialSideIndicatorUI_C:Construct()
    self.Super.Construct(self)
    EventManager:AddEvent(EventID.OnChangeTaskSubRegion, self, self.SetSmarPointInfoByQuestRegionId)
    self.IsDestroied = false
end

function WBP_UnSpecialSideIndicatorUI_C:Destruct()
    self.Super.Destruct(self)
    EventManager:RemoveEvent(EventID.OnChangeTaskSubRegion, self)
    self.IsDestroied = true
end

function WBP_UnSpecialSideIndicatorUI_C:CloseIndicator()
	EventManager:FireEvent(EventID.UpdateMiniMap, self.OwenrQuestNpcId, "SpecialSide", "Delete")
    self.Super.Close(self)
    MissionIndicatorManager:TryToArrangeIndicatorBySmartPointInfo()
end

function WBP_UnSpecialSideIndicatorUI_C:SetNpcSideQuestGuideInfo(InOwnerDisplayName)
    self.STLIndicatorType = "UnSpecialSide"
    self.WBP_TaskGuide_Base.Img_Main:GetDynamicMaterial():SetTextureParameterValue("GuideIcon", LoadObject('/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SpSideMission_Un.T_Gp_SpSideMission_Un'))
    self.WBP_TaskGuide_Base.Img_Main:GetDynamicMaterial():SetVectorParameterValue("ArrowColor", self.Color_Blue.SpecifiedColor)

    if InOwnerDisplayName and GuidePointLocData[InOwnerDisplayName] and GuidePointLocData[InOwnerDisplayName].SubRegionId > 0 then
        self.TargetRegionId = GuidePointLocData[InOwnerDisplayName].SubRegionId
    end

    local SideActor = self:TryToFindGuidePointTarget(InOwnerDisplayName)
    self:SetSmarPointInfoByQuestRegionId()
    EventManager:FireEvent(EventID.UpdateMiniMap, self.OwenrQuestNpcId, "SpecialSide", "Add")

    if SideActor then
        local TargetLoc = SideActor:K2_GetActorLocation()
        self.TargetPointPos = UE4.FVector(TargetLoc.X, TargetLoc.Y, TargetLoc.Z + 2 * self.HelperCoefficient)
    end
end

function WBP_UnSpecialSideIndicatorUI_C:SetSmarPointInfoByQuestRegionId()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    
    self.PlayerRegionId = Avatar.CurrentRegionId
    if self.TargetRegionId ~= self.PlayerRegionId then --当玩家不处于任务区域时，根据联通图显示相关指引点
        self.SmartGuidePointInfo = self:TryGetTargetGuidePointByRegionGraph(self.PlayerRegionId, self.TargetRegionId)
        self.IsInTaskRegion = false
    else
        self.IsInTaskRegion = true
    end
    EventManager:FireEvent(EventID.UpdateMiniMap, self:GetName(), "SpecialSide", "ChangeRegion")
    if self.SmartGuidePointInfo == nil then
        self:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end

    local SideActor = self:TryToFindGuidePointTarget(self.OwnerDisplayName)
    if SideActor then
        local TargetLoc = SideActor:K2_GetActorLocation()
        self.TargetPointPos = UE4.FVector(TargetLoc.X, TargetLoc.Y, TargetLoc.Z + 2 * self.HelperCoefficient)
        self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end

    MissionIndicatorManager:TryToArrangeIndicatorBySmartPointInfo()
end

function WBP_UnSpecialSideIndicatorUI_C:TryToFindGuidePointTarget(DisplayName)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local TargetStaticCreator = nil
    TargetStaticCreator = GameState.StaticCreatorStringNameMap:FindRef(DisplayName)
    if TargetStaticCreator then
        self.TargetPointType = "M"
        return TargetStaticCreator
    end
    TargetStaticCreator = GameState.StaticCreatorMap:FindRef(DisplayName)
    if TargetStaticCreator then
        self.TargetPointType = "M"
        return TargetStaticCreator
    end

    local NewTargetPoint = GameState:GetTargetPoint(DisplayName) 
    if NewTargetPoint then
        self.TargetPointType = "P"
        return NewTargetPoint
    end
    return nil
end

function WBP_UnSpecialSideIndicatorUI_C:TryGetTargetGuidePointByRegionGraph(CurSubRegionId, TargetSubRegionId)
    local function ContainsElement(table, element)
        for _, value in pairs(table) do
            if value[1] == element then
                return value
            end
        end
        return nil
    end

    local function CreateQueue()
        local queue = {}
        queue.first = 0
        queue.last = -1
        queue.QueueValue = {}
        queue.Path = {}
        return queue
    end
    -- 入队操作
    local function Enqueue(queue, value)
        local last = queue.last + 1
        queue.last = last
        queue.QueueValue[last] = value
        table.insert(queue.Path, value[1])
    end

    local function ContainsPath(table, element)
        for _, value in pairs(table) do
            if value == element then
                return true
            end
        end
        return false
    end

    -- 出队操作
    local function Dequeue(queue)
        local first = queue.first
        if first > queue.last then
            return nil
        end
        local value = queue.QueueValue[first]
        queue.QueueValue[first] = nil
        queue.first = first + 1
        return value
    end

    -- 判断队列是否为空
    local function IsEmptyQueue(queue)
        return queue.first > queue.last
    end

    if not DataMgr.RegionGraph[TargetSubRegionId] or
    not  DataMgr.SubRegion[TargetSubRegionId].RegionId then
        return nil
    end
    local TargetRegionId = DataMgr.SubRegion[TargetSubRegionId].RegionId

    if not DataMgr.RegionGraph[CurSubRegionId] or
    not DataMgr.RegionGraph[CurSubRegionId].SubRegionTarget or
    not DataMgr.RegionGraph[CurSubRegionId].SubRegionTarget.RegionTarget then
        return nil
    end
    local RegionTargetDatas = DataMgr.RegionGraph[CurSubRegionId].SubRegionTarget.RegionTarget

    local function TryFindTargetPointByBFS(RootTargetData)
        local RootSubRegionId = RootTargetData[1]
        if not DataMgr.RegionGraph[RootSubRegionId] or
           not DataMgr.RegionGraph[RootSubRegionId].SubRegionTarget or
           not DataMgr.RegionGraph[RootSubRegionId].SubRegionTarget.RegionTarget then
            return -1
        end

        local RootRegionQueue = CreateQueue()
        local RootRegionDatas = DataMgr.RegionGraph[RootSubRegionId].SubRegionTarget.RegionTarget --Debug 1：逐一遍历对应子区域里的SubRegionTarget数据
        for _, v in pairs(RootRegionDatas) do
            Enqueue(RootRegionQueue, v)
        end
        local QueueCount = RootRegionQueue.last - RootRegionQueue.first + 1

        local Weight = 1
        local QueueIndex = 0
        while not IsEmptyQueue(RootRegionQueue) do
            if ContainsElement(RootRegionQueue.QueueValue, TargetSubRegionId) == nil then --当前区域没有直接可达目标区域，需要逐个在当前区域的联通区域内找
                local frontData = RootRegionQueue.QueueValue[RootRegionQueue.first]
                local frontDataSubRegionId = frontData[1]
                QueueIndex = QueueIndex + 1
                if QueueIndex > QueueCount then
                    Weight = Weight + 1
                    QueueIndex = 0
                    QueueCount = RootRegionQueue.last - RootRegionQueue.first + 1
                end
                Dequeue(RootRegionQueue)

                if not DataMgr.RegionGraph[frontDataSubRegionId] or 
                not DataMgr.RegionGraph[frontDataSubRegionId].SubRegionTarget or
                not DataMgr.RegionGraph[frontDataSubRegionId].SubRegionTarget.RegionTarget then
                    goto continue
                end

                if DataMgr.RegionGraph[frontDataSubRegionId].RegionStart == DataMgr.RegionGraph[TargetSubRegionId].RegionStart then
                    local NewRegionDatas = DataMgr.RegionGraph[frontDataSubRegionId].SubRegionTarget.RegionTarget --取队列第一个区域

                    for _, NewRegionData in pairs(NewRegionDatas) do
                        local SubRegionId = NewRegionData[1]--Debug 2：取出队列第一个子区域数据，逐一遍历对应子区域里的SubRegionTarget数据
                        if DataMgr.RegionGraph[SubRegionId] and DataMgr.RegionGraph[TargetSubRegionId].RegionStart == DataMgr.RegionGraph[SubRegionId].RegionStart and
                        not ContainsPath(RootRegionQueue.Path, SubRegionId) then
                            Enqueue(RootRegionQueue, NewRegionData)
                            if ContainsElement(RootRegionQueue.QueueValue, TargetSubRegionId) then
                                return Weight + 1
                            end
                        end
                    end
                end
                ::continue::
            else
                return Weight + 1
            end
        end

        if IsEmptyQueue(RootRegionQueue) then --当前区域无论如何都到不了目标区域
            return -1
        end
    end

    local function TryFindNearestEnterByRegionId()
        local NearestData = nil
        local CurrentParentRegionId = DataMgr.SubRegion[CurSubRegionId].RegionId
        local TargetParentRegionId = DataMgr.SubRegion[TargetSubRegionId].RegionId
        if CurrentParentRegionId == TargetParentRegionId then
            return NearestData
        end
        local RetDistance = math.maxinteger
        for _, Data in pairs(RegionTargetDatas) do
            if Data and Data[1] and Data[2] and DataMgr.SubRegion[Data[1]] then
                local IterParentRegionId = DataMgr.SubRegion[Data[1]].RegionId
                local IsConditionUnlock = true
                if Data[4] and self:CheckConditionIsUnlock(Data[4]) == false then
                    IsConditionUnlock = false
                end
                if TargetParentRegionId == IterParentRegionId and IsConditionUnlock then
                    local NewTargetPoint = self.GameState:GetTargetPoint(Data[2])
                    if NewTargetPoint then
                        local PointLocation = NewTargetPoint:K2_GetActorLocation()
                        local Distance = UKismetMathLibrary.Vector_Distance(self.PlayerCharacter.CurrentLocation, PointLocation)
                        if Distance < RetDistance then
                            RetDistance = Distance
                            NearestData = Data
                        end
                    end
                end
            end
        end
        return NearestData
    end

    local RetData = TryFindNearestEnterByRegionId()
    local RetWeight = math.maxinteger
    if RetData ~= nil then
        return RetData
    end

    local MinDistance = math.maxinteger
    local RetDataTable = {}
    if not ContainsElement(RegionTargetDatas, TargetSubRegionId) then
        for _, IteraData in pairs(RegionTargetDatas) do
            local IterWeight = TryFindTargetPointByBFS(IteraData)
            if IterWeight >= 0 and IterWeight <= RetWeight then
                RetWeight = IterWeight
                table.insert(RetDataTable, IteraData)
            end
        end
        for _, Data in pairs(RetDataTable) do
            if self:CheckConditionIsUnlock(Data[4]) then
                local NewTargetPoint = self.GameState:GetTargetPoint(Data[2])
                if NewTargetPoint then
                    local PointLocation = NewTargetPoint:K2_GetActorLocation()
                    local Distance = UKismetMathLibrary.Vector_Distance(self.PlayerCharacter.CurrentLocation, PointLocation)
                    if Distance < MinDistance then
                        MinDistance = Distance
                        RetData = Data
                    end
                end
            end
        end

    else
        RetWeight = 1
        for _, IteraData in pairs(RegionTargetDatas) do
            if IteraData and IteraData[1] and IteraData[1] == TargetSubRegionId then
                table.insert(RetDataTable, IteraData)
            end
        end

        for _, Data in pairs(RetDataTable) do
            if Data and Data[1] and Data[2] and DataMgr.SubRegion[Data[1]] and self:CheckConditionIsUnlock(Data[4]) then
                local NewTargetPoint = self.GameState:GetTargetPoint(Data[2])
                if NewTargetPoint then
                    local PointLocation = NewTargetPoint:K2_GetActorLocation()
                    local Distance = UKismetMathLibrary.Vector_Distance(self.PlayerCharacter.CurrentLocation, PointLocation)
                    if Distance < MinDistance then
                        MinDistance = Distance
                        RetData = Data
                    end
                end
            end
        end
    end
    if IsEmptyTable(RetDataTable) then --无联通指引, 开始根据RegionStart寻找物理联通的区域
        if IsEmptyTable(DataMgr.RegionGraph[CurSubRegionId].RegionStart) then --室内空间
            for _, Data in pairs(RegionTargetDatas) do
                local IterSubRegionId = Data[1]
                if DataMgr.RegionGraph[IterSubRegionId] and IsEmptyTable(DataMgr.RegionGraph[IterSubRegionId].RegionStart) == false then --室内空间直接出去就行了不需要判断传送机关
                    for _, Id in pairs(DataMgr.RegionGraph[IterSubRegionId].RegionStart) do
                        if Id == TargetSubRegionId then
                            RetData = Data
                            RetWeight = 1
                            break
                        end
                    end
                end
            end
        else --同一个物理连通区域内
            for _, SubRegionId in pairs(DataMgr.RegionGraph[CurSubRegionId].RegionStart) do
                if SubRegionId == TargetSubRegionId then
                    RetWeight = 2
                    break
                end
            end
        end
    end

    local SourcePointTarget = nil

    if RetWeight > 1 and DataMgr.RegionGraph[CurSubRegionId] and DataMgr.RegionGraph[CurSubRegionId].RegionStart ~= nil then
        if self.OwnerDisplayName then
            SourcePointTarget = self:TryToFindGuidePointTarget(self.OwnerDisplayName)
            if SourcePointTarget then
                return nil
            end
        end
    end

    if SourcePointTarget then
        return nil
    end

    return RetData
end

function WBP_UnSpecialSideIndicatorUI_C:TickChildBP()
    if not self.IsInTaskRegion then --当前区域不处于任务所在区域，需要根据区域联通图，标定相应的指引点位置
            local TargetPointInfo = self.SmartGuidePointInfo
            if TargetPointInfo ~= nil then --存在区域联通，标定相应指引点
                self.TargetPointType = 'P'
                -- self.TargetPointName = TargetPointInfo[2]
                self:TryReplaceNearlySmartPoint(TargetPointInfo)
            else
                self.TargetPointName = self.OwnerDisplayName
            end
    end
    self:UpdateTaskIndicator_CPP()
end

function WBP_UnSpecialSideIndicatorUI_C:CheckConditionIsUnlock(RegionData)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end

    if RegionData == nil then
        return true
    end
    return ConditionUtils.CheckCondition(Avatar, RegionData)
end

function WBP_UnSpecialSideIndicatorUI_C:TryReplaceNearlySmartPoint(SmarPointInfo)
    if SmarPointInfo == nil then
        return false
    end

    if SmarPointInfo[2] ~= nil then
        self.TargetPointName = SmarPointInfo[2]
        self.TargetPointSubRegionId = SmarPointInfo[1]
        return false
    else
        self.TargetPointName = self.OwnerDisplayName
        return true
    end
end

function WBP_UnSpecialSideIndicatorUI_C:CalculateTargetPointPos()
    if self.TargetPointType == "P" then
        self:SetTargetPositionByNewTargetPoint()
    else
        self:SetTargetPositionByStaticCreator()
    end
end

-- function WBP_UnSpecialSideIndicatorUI_C:PostTickChildBP()
--     local TargetNpc = self.GameState.NpcCharacterMap:FindRef(self.OwenrQuestNpcId)
--     if TargetNpc then
--         local Distance = UKismetMathLibrary.Vector_Distance(self.PlayerCharacter.CurrentLocation, self.TargetPointPos) / 100.0
--         if Distance < 40 then
--             self.Guide_Node:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         else
--             self.Guide_Node:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--         end
--     end
-- end

return WBP_UnSpecialSideIndicatorUI_C
