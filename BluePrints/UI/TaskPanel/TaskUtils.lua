--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

local StorylineUtils = require 'StoryCreator.StoryLogic.StorylineUtils'
local ClientEventUtils = require "BluePrints.Common.ClientEvent.ClientEventUtils"
local GuidePointLocData = require ("BluePrints.UI.TaskPanel/QuestGuidePointLocData")
    
local TaskUtils = {}
local QuestDataInStoryLine = {}
local QuestExtraInfo = {}
local QuestInterfaceJump = {}
local QuestInterfaceJumpId = {}
local NodeHaveExtraInfo = {KillMonsterNode = true,ResourceCollectNode = true}
TaskUtils.StoryLineData = QuestDataInStoryLine
TaskUtils.QuestExtraInfo = QuestExtraInfo
TaskUtils.TaskMainLastSelectId = nil
TaskUtils.IsInTaskRegion = false
TaskUtils.MissionNpcGuideMaps = {}
TaskUtils.TaskPathActor = nil
TaskUtils.IsCanMakeTaskPathActor = true
TaskUtils.TaskPathActor = nil
TaskUtils.TaskRegionMap = "Now"
TaskUtils.bShowLevelMap = false
function TaskUtils:CreateSubItemContent(Content)
    local ClassPath = "/Game/UI/WBP/Task/Widget/SubItemContent.SubItemContent"
    local Object = NewObject(UE4.LoadClass(ClassPath))


    Object.OwnerWidget = Content.OwnerWidget
    Object.MainWidget = Content.MainWidget
    Object.IsDoingQuest = Content.IsDoingQuest
    Object.State = Content.State
    Object.QuestId = Content.QuestId
    Object.QuestChainId = Content.QuestChainId
    Object.IsNew = Content.IsNew

    return Object
end

function TaskUtils:CreateListItemContent(Content)
    local ClassPath = "/Game/UI/WBP/Task/Widget/ListItemContent.ListItemContent"
    local Object = NewObject(UE4.LoadClass(ClassPath))

    Object.DoingQuestId = Content.DoingQuestId
    Object.QuestChainId = Content.QuestChainId
    Object.State = Content.State
    Object.OwnerWidget = Content.OwnerWidget
    Object.IsShowType = Content.IsShowType
    Object.IsTracking = Content.IsTracking
    Object.IsSelectDoingQuest = Content.IsSelectDoingQuest
    Object.IsEmpty = Content.IsEmpty
    Object.UI = Content.UI
    -- if Content.CompletedQuestId then
    --     for _, id in pairs(Content.CompletedQuestId) do
    --         Object.CompletedQuetsId:Add(id)
    --     end
    -- end

    return Object
end

function TaskUtils:CreateRewardContent(Content)
    local Object = NewObject(UIUtils.GetCommonItemContentClass())
    Object.ParentWidget = Content.OwnerWidget
    Object.Id = Content.Id
    Object.Count = Content.Count
    Object.Icon = Content.Icon
    Object.Rarity = Content.Rarity
    Object.IsShowDetails = Content.IsShowDetails
    Object.ItemType = Content.ItemType
    Object.UIName = "TaskPanel"
    return Object
end

---@param TaskDetailInfo TaskDetailInfo
function TaskUtils:TaskDetailInfo2STLTaskInfo(TaskDetailInfo)
    local ChainInfo = DataMgr.QuestChain[TaskDetailInfo.QuestChainId]
    local STLTaskInfo = {
        TaskChainId = TaskDetailInfo.QuestChainId, 
        TaskId = TaskDetailInfo.QuestId, 
        TaskName = GText(ChainInfo and ChainInfo.QuestChainName),	  
        TaskDescription = GText(TaskDetailInfo.QuestDescription), 
        IsChainFirstTask = TaskDetailInfo.bIsStartQuest, 
        IsChapterStart = TaskDetailInfo.bIsStartChapter,
    }
    return STLTaskInfo
end

---@return TaskDetailInfo
function TaskUtils:GetQuestDetail(QuestChainId, QuestId)
    QuestDataInStoryLine[QuestChainId] = QuestDataInStoryLine[QuestChainId] or {}
    if QuestDataInStoryLine[QuestChainId] and QuestDataInStoryLine[QuestChainId][QuestId] then
        return QuestDataInStoryLine[QuestChainId][QuestId]
    end

    local StoryLineDetails = StorylineUtils.CreateQuestDetails(QuestChainId)
    local NodeList = StoryLineDetails.QuestStoryNodeQuestInfos
    for _,Node in pairs(NodeList) do
        QuestDataInStoryLine[QuestChainId][Node.PropsData.QuestId] = Node.PropsData
        for Key, QuestNodeData in pairs(Node.QuestNodeQuestInfos) do
            self:CheckTypeAndCollectExtraInfo(QuestNodeData,QuestChainId,Node.PropsData.QuestId)
        end
    end
    return QuestDataInStoryLine[QuestChainId][QuestId]
end

function TaskUtils:GetTrackingQuestDetailInfo()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return nil
    end
    local TrackingId = Avatar.TrackingQuestChainId
    local QuestData = Avatar.QuestChains[TrackingId]
    if not QuestData or QuestData.State == 3 then
        return nil
    end
    local DoingQuestId = Avatar.QuestChains[TrackingId].DoingQuestId
    return self:GetQuestDetail(TrackingId, DoingQuestId)
end

function TaskUtils:GetTrackingQuestMapInfo()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return nil
    end
    local TrackingId = Avatar.TrackingQuestChainId
    if not Avatar.QuestChains[TrackingId] then
        return nil
    end
    return self:GetQuestMapInfo(TrackingId)
end

function TaskUtils:GetQuestMapInfo(InChainId)
    local Info = self:GetTrackingQuestDetailInfo()
    local ContainWorldMapRegionId = function(Target, Datas)
        for _, Data in pairs(Datas) do
            if Target == Data then
                return true
            end
        end

        return false
    end

    if Info and Info.SubRegionId and Info.SubRegionId > 0 then
        local QuestSubRegionId = Info.SubRegionId
        local ParentRegionId = DataMgr.SubRegion[QuestSubRegionId].RegionId
        local RegionMapId = nil
        if DataMgr.Region[ParentRegionId] and DataMgr.Region[ParentRegionId].RegionMapId then
            RegionMapId = DataMgr.Region[ParentRegionId].RegionMapId
        end
        local WorldMapId = nil
        if RegionMapId ~= nil then
            for _, Data in pairs(DataMgr.WorldMap) do
                if ContainWorldMapRegionId(RegionMapId, Data.WorldMapRegion) then
                    WorldMapId = Data.UIIndex
                    break
                end
            end
        end
        return WorldMapId, RegionMapId
    else
        local UIObjs = MissionIndicatorManager:GetIndicatorUIObjByQuestChainIdWithType(InChainId, "Task")
        if IsEmptyTable(UIObjs) then
            -- ScreenPrint(string.format("TaskUtils:GetTrackingQuestMapInfo, 不存在追踪中的指引点, 任务区域信息获取失败，请检查STL是否配置指引点节点, 任务Id: %s", InChainId))
            local TargetDoingQuestId = 0
            local Avatar = GWorld:GetAvatar()
            if Avatar then
                if Avatar.QuestChains[InChainId] then
                    TargetDoingQuestId = Avatar.QuestChains[InChainId].DoingQuestId
                end
                local Message = "请检查STL任务节点是否配置指引点节点"..
                "\n对应任务链:"..InChainId..
                "\n对应任务:"..TargetDoingQuestId..
                "\n玩家子区域:"..Avatar.CurrentRegionId
                -- UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, "未检测到任何任务指引点数据", Message)
                if Const.EnableTaskPrintError then
                    ScreenPrint(string.format("%s", Message))
                end
            end

            return nil, nil
        end
        for _, v in pairs(UIObjs) do
            local TargetKey = v.GuideInfoCache.PointOrStaticCreatorName
            if TargetKey and GuidePointLocData[TargetKey] then
                local TargetSubRegionId = GuidePointLocData[TargetKey].SubRegionId
                if not DataMgr.SubRegion[TargetSubRegionId] then
                    -- ScreenPrint(string.format("TaskUtils:GetQuestMapInfo, 任务区域信息获取失败，请检查STL是否配置指引点节点, GuideLocData Key: %s", TargetKey))
                    local TargetDoingQuestId = 0
                    local Avatar = GWorld:GetAvatar()
                    if Avatar then
                        if Avatar.QuestChains[InChainId] then
                            TargetDoingQuestId = Avatar.QuestChains[InChainId].DoingQuestId
                        end
                        local Message = "任务指引点区域数据不存在，导致获取任务区域数据失败，请策划同学检查"..
                        "\n对应任务链:"..InChainId..
                        "\n对应任务:"..TargetDoingQuestId..
                        "\n玩家子区域:"..Avatar.CurrentRegionId..
                        "\n指引点名称（下划线后缀为指引点节点Key）:"..v:GetName()
                        -- UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, "任务指引点导出数据不存在", Message)
                        if Const.EnableTaskPrintError then
                            ScreenPrint(string.format("%s", Message))
                        end
                    end
                    goto continue
                end
                local ParentRegionId = DataMgr.SubRegion[TargetSubRegionId].RegionId
                local RegionMapId = nil
                if DataMgr.Region[ParentRegionId] and DataMgr.Region[ParentRegionId].RegionMapId then
                    RegionMapId = DataMgr.Region[ParentRegionId].RegionMapId
                end
                local WorldMapId = nil
                if RegionMapId ~= nil then
                    for _, Data in pairs(DataMgr.WorldMap) do
                        if ContainWorldMapRegionId(RegionMapId, Data.WorldMapRegion) then
                            WorldMapId = Data.UIIndex
                            break
                        end
                    end
                end
                return WorldMapId, RegionMapId
            else
                -- ScreenPrint(string.format("TaskUtils:GetTrackingQuestMapInfo, 指引点区域数据不存在, 任务区域信息获取失败，请检查导出数据, 指引点: %s", v:GetName()))
                local TargetDoingQuestId = 0
                local Avatar = GWorld:GetAvatar()
                if Avatar then
                    if Avatar.QuestChains[InChainId] then
                        TargetDoingQuestId = Avatar.QuestChains[InChainId].DoingQuestId
                    end
                    local Message = "任务指引点区域数据不存在，导致获取任务区域数据失败，请策划同学检查"..
                    "\n对应任务链:"..InChainId..
                    "\n对应任务:"..TargetDoingQuestId..
                    "\n玩家子区域:"..Avatar.CurrentRegionId..
                    "\n指引点名称（下划线后缀为指引点节点Key）:"..v:GetName()
                    -- UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, "任务指引点导出数据不存在", Message)
                    if Const.EnableTaskPrintError then
                        ScreenPrint(string.format("%s", Message))
                    end
                end
                return
            end
             ::continue::
        end
    end
end

function TaskUtils:CheckTypeAndCollectExtraInfo(QuestNodeData, QuestChainId, QuestId)
    if NodeHaveExtraInfo[QuestNodeData.Type] then
        if QuestExtraInfo[QuestChainId] and QuestExtraInfo[QuestChainId][QuestId] then
            return
        end
    end 
end

function TaskUtils:SetQuestExtraInfo(QuestChainId, QuestId, Data)
    if not Data then
        return
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local ChainId = QuestChainId
    local DoingQuestId = QuestId
    if Avatar.InSpecialQuest and ClientEventUtils:GetCurrentEvent() and ClientEventUtils:GetCurrentEvent().PreQuestChainId then
        ChainId = ClientEventUtils:GetCurrentEvent().PreQuestChainId
        DoingQuestId = Avatar.QuestChains[ChainId].DoingQuestId
    end
   
    QuestExtraInfo = QuestExtraInfo or {}
    QuestExtraInfo[ChainId] = QuestExtraInfo[ChainId] or {}
    QuestExtraInfo[ChainId][DoingQuestId] = QuestExtraInfo[ChainId][DoingQuestId] or {}
    if Data.NodeKey then
        if Data.Node.Type == "UpdateTaskBarAndTaskMainNode" then
            if QuestExtraInfo[ChainId][DoingQuestId] then
                for _,NodeData in pairs(QuestExtraInfo[ChainId][DoingQuestId]) do
                    if NodeData and NodeData.Node.Type == "UpdateTaskBarAndTaskMainNode" then
                        NodeData.CurNode = NodeData.CurNode + 1
                    end
                end
            end
        end
        QuestExtraInfo[ChainId][DoingQuestId][Data.NodeKey] = Data
    end
end

function TaskUtils:ClearQuestExtraInfo(QuestChainId, QuestId, InKey)
    if QuestExtraInfo and QuestExtraInfo[QuestChainId] and QuestExtraInfo[QuestChainId][QuestId] and QuestExtraInfo[QuestChainId][QuestId][InKey]then
        -- if not IsEmptyTable(QuestExtraInfo[QuestChainId][QuestId]) then
        --     for _, Data in pairs(QuestExtraInfo[QuestChainId][QuestId]) do
        --         if Data.Node then
        --             Data.Node = nil
        --         end
        --     end

        -- end

        if QuestExtraInfo[QuestChainId][QuestId][InKey].Node then
            QuestExtraInfo[QuestChainId][QuestId][InKey].Node = nil
        end

        QuestExtraInfo[QuestChainId][QuestId][InKey] = nil
    end
end

function TaskUtils:GetQuestCountExtraInfoString(QuestChainId, QuestId, NodeKey)
    if not QuestExtraInfo[QuestChainId] or not QuestExtraInfo[QuestChainId][QuestId] then
        return ""
    end

    local Info = QuestExtraInfo[QuestChainId][QuestId]

    if NodeKey ~= nil and Info[NodeKey] then
        if Info and Info[NodeKey] and Info[NodeKey].Count and Info[NodeKey].RetCount then
            return "(" .. Info[NodeKey].Count .. "/" .. Info[NodeKey].RetCount .. ")"
        end
    else
        local UpdateCountInfo = ""
        local IsUpdateMainBar = false
        for _, Data in pairs(Info) do --当启用了主任务下子任务更新
            if Data.Node and Data.Node.Type == "BranchQuestStartNode" and Data.IsUpdateCountInfo then
                UpdateCountInfo = "(" .. "0" .. "/" .. Data.NeedFinishCount .. ")"
                IsUpdateMainBar = Data.IsUpdateCountInfo and Data.NeedFinishCount > 0
            end
        end

        if IsUpdateMainBar then
            local IsValid = true
            for _, Data in pairs(Info) do
                if Data.Node and Data.Node.Type == "CheckBranchQuestFinishedNode" then
                    UpdateCountInfo = "(" .. Data.CurrentFinishedCount .. "/" .. Data.NeedFinishCount .. ")"
                    IsValid = (Data.CurrentFinishedCount <= Data.NeedFinishCount) and Data.NeedFinishCount > 0
                end
            end

            if IsValid then
                return UpdateCountInfo
            end
        end

        for _, v in pairs(Info) do --当未启用了主任务下子任务更新，此时应该只剩下一个更新计数的节点
            if v.Count and v.RetCount then
                return "(" .. v.Count .. "/" .. v.RetCount .. ")"
            end
        end
    end
    return ""
end

function TaskUtils:GetQuestExtraInfo(QuestChainId, QuestId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local ChainId = QuestChainId
    local DoingQuestId = QuestId
    if Avatar.InSpecialQuest and ClientEventUtils:GetCurrentEvent() and ClientEventUtils:GetCurrentEvent().PreQuestChainId then
        ChainId = ClientEventUtils:GetCurrentEvent().PreQuestChainId
        DoingQuestId = Avatar.QuestChains[ChainId].DoingQuestId
    end

    if QuestExtraInfo and QuestExtraInfo[ChainId] and QuestExtraInfo[ChainId][DoingQuestId] then
       return QuestExtraInfo[ChainId][DoingQuestId]
    end

    return nil
end

function TaskUtils:CheckTaskIsInEXRegion()
    local Info = self:GetTrackingQuestDetailInfo()
    local QuestRegionMapId = nil
    
    if Info and Info.SubRegionId and Info.SubRegionId > 0 then
        QuestRegionMapId = Info.SubRegionId
    else
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
            return false
        end
        local CurTrackingQuestChainId = Avatar.TrackingQuestChainId
        if CurTrackingQuestChainId == nil or CurTrackingQuestChainId == 0 then
            return false
        end
    
        local UIObjs = MissionIndicatorManager:GetIndicatorUIObjByQuestChainIdWithType(CurTrackingQuestChainId, "Task")
        if IsEmptyTable(UIObjs) then
            return false
        end
    
        for _, v in pairs(UIObjs) do
            local TargetKey = v.GuideInfoCache.PointOrStaticCreatorName
            if TargetKey and GuidePointLocData[TargetKey] and GuidePointLocData[TargetKey].SubRegionId > 0 then
                QuestRegionMapId = GuidePointLocData[TargetKey].SubRegionId
            else
                -- ScreenPrint(string.format("CheckIsTrackingQuest: 指引点区域数据不存在, 任务区域信息获取失败，请检查导出数据, 指引点: %s", v:GetName()))
                local CurTrackingQuestId = 0
                if Avatar.QuestChains[CurTrackingQuestChainId] then
                    CurTrackingQuestId = Avatar.QuestChains[CurTrackingQuestChainId].DoingQuestId
                end
                local Message = "任务指引点区域数据不存在，导致获取任务区域数据失败，请策划同学检查"..
                "\n当前追踪任务链:"..CurTrackingQuestChainId..
                "\n当前追踪任务:"..CurTrackingQuestId..
                "\n玩家子区域:"..Avatar.CurrentRegionId..
                "\n指引点名称（下划线后缀为指引点节点Key）:"..v:GetName()
                -- UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, "任务指引点导出数据不存在", Message)
                if Const.EnableTaskPrintError then
                    ScreenPrint(string.format("%s", Message))
                end
            end
            break
        end
    end
   
    if not QuestRegionMapId or not DataMgr.SubRegion[QuestRegionMapId] or
    not DataMgr.SubRegion[QuestRegionMapId].RegionId 
    or not DataMgr.Region[DataMgr.SubRegion[QuestRegionMapId].RegionId]
    or not DataMgr.Region[DataMgr.SubRegion[QuestRegionMapId].RegionId].RegionMapId then
        return false
    end
    
    local IsInEXRegion = false
    local TaskRegionMapId = DataMgr.Region[DataMgr.SubRegion[QuestRegionMapId].RegionId].RegionMapId

    for _, Data in pairs(DataMgr.WorldMap) do
        for _, WorldMapRegion in pairs(Data.WorldMapRegion) do
            if WorldMapRegion == TaskRegionMapId then
                if Data.UIRegionType == "EX" then
                    IsInEXRegion = true
                end
                break
            end
        end
    end

    return IsInEXRegion
end

function TaskUtils:ResumQuestTaskBarOnTrack(ServerQuestChainId, ClientQuestChainId, QuestId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return nil
    end

    if ServerQuestChainId and ClientQuestChainId and QuestId then
        if Avatar.QuestChains[ServerQuestChainId] and
        (Avatar.QuestChains[ServerQuestChainId].DoingQuestId and Avatar.QuestChains[ServerQuestChainId].DoingQuestId ~= 0) then
            local TargetServerQuestId = Avatar.QuestChains[ServerQuestChainId].DoingQuestId
            if QuestExtraInfo and QuestExtraInfo[ServerQuestChainId] and QuestExtraInfo[ServerQuestChainId][TargetServerQuestId] then
                local ServerInfo = QuestExtraInfo[ServerQuestChainId][Avatar.QuestChains[ServerQuestChainId].DoingQuestId]
                if not IsEmptyTable(ServerInfo) then
                    for _, Data in pairs(ServerInfo) do
                        if Data.Node then
                            Data.Node:OnCancelTrack()
                        end
                    end
                end
            end
        end

        -- if QuestExtraInfo and QuestExtraInfo[ClientQuestChainId] and QuestExtraInfo[ClientQuestChainId][QuestId] then
        --     local ClientInfo = QuestExtraInfo[ClientQuestChainId][QuestId]

        --     if not IsEmptyTable(ClientInfo) then
        --         for _, Data in pairs(ClientInfo) do
        --             if Data.Node then
        --                 Data.Node:OnChooseTrack()
        --             end
        --         end
        --     end
        -- end
    else
        if Avatar.QuestChains[ServerQuestChainId] and
        (Avatar.QuestChains[ServerQuestChainId].DoingQuestId and Avatar.QuestChains[ServerQuestChainId].DoingQuestId ~= 0) then
            local TargetServerQuestChainId = Avatar.QuestChains[ServerQuestChainId].DoingQuestId
            if QuestExtraInfo and QuestExtraInfo[ServerQuestChainId] and QuestExtraInfo[ServerQuestChainId][TargetServerQuestChainId] then
                local ServerInfo = QuestExtraInfo[ServerQuestChainId][Avatar.QuestChains[ServerQuestChainId].DoingQuestId]
                if not IsEmptyTable(ServerInfo) then
                    for _, Data in pairs(ServerInfo) do
                        if Data.Node then
                            Data.Node:OnCancelTrack()
                        end
                    end
                end
            end
        end
    end
   
end

function TaskUtils:ShowQuestChainFinishCommonHudReward(QuestChainId, RewardBox)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local QuestInfo = Avatar.QuestChains[QuestChainId]
    if QuestInfo and QuestInfo:GetAssumeFinish() then
        return
    end
    if DataMgr.QuestChain[QuestChainId] == nil or DataMgr.QuestChain[QuestChainId].QuestChainReward == nil then
        DebugPrint("TaskUtils:ShowQuestChainFinishCommonHudReward QuestChainId is error or QuestChainReward is nil")
        return
    end
    if RewardBox == nil then
       return 
    end
    local AllRewardType = DataMgr.RewardType
    local TempRewardList = {}

    for Type, _ in pairs(AllRewardType) do
        local CurRewards = RewardBox[Type.."s"]
        if not IsEmptyTable(CurRewards) then
            for Id, Count in pairs(CurRewards) do
                local ItemId = Id
                local ItemCount = Count
                local ItemRarity = ItemUtils.GetItemRarity(ItemId, Type)
                local ItemType = Type
                local RewardContent = {
                    ItemType = ItemType,
                    ItemId = ItemId,
                    Count = ItemCount,
                    Rarity = ItemRarity,
                }
                table.insert(TempRewardList, RewardContent)
            end
        end
    end

    local function SortByRarity(a, b)
        return a.Rarity > b.Rarity
    end
    table.sort(TempRewardList, SortByRarity)
    UIUtils.ShowHudReward("UI_QUEST_REWARDS", TempRewardList)
end

function TaskUtils:RemoveAllQuestExtraInfo()
    if QuestExtraInfo ~= nil then
        for ChainId, Data in pairs(QuestExtraInfo) do
            for QuestId, _ in pairs(Data) do
                QuestExtraInfo[ChainId][QuestId] = nil
            end
        end
    end
end

function TaskUtils:UpdateAllMissionNpcGuideMaps(IsAdd, Name, NpcUnitId)
    if IsAdd then
        if self.MissionNpcGuideMaps[Name] == nil and NpcUnitId ~= nil then
            self.MissionNpcGuideMaps[Name] = NpcUnitId
        end
    else
        self.MissionNpcGuideMaps[Name] = nil
    end
end

function TaskUtils:CreateAndMoveFollowingPath(Class)
    local GameInstance = GWorld.GameInstance
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    local BPClass = LoadClass('/Game/BluePrints/Combat/EffectCreature/Others/BP_CreatPathEffectTrail.BP_CreatPathEffectTrail')
    if not IsValid(self.TaskPathActor) and self.IsCanMakeTaskPathActor == true then
        self.TaskPathActor = Class:GetWorld():SpawnActor(BPClass, nil, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn, nil, nil, nil)
        self.TaskPathActor:K2_SetActorLocation(PlayerCharacter:K2_GetActorLocation(), false, nil, false)
    end
end

function TaskUtils:UpdatePlayerSubRegionIdInfo(NewPlayerSubRegionId)
    DebugPrint("LHQ_UpdatePlayerSubRegionIdInfo, NewPlayerSubRegionId:", NewPlayerSubRegionId, "start===")
    local Avatar = GWorld:GetAvatar()
    if not Avatar or NewPlayerSubRegionId == nil or NewPlayerSubRegionId == 0 then
        return
    end
    EventManager:FireEvent(EventID.OnChangeTaskSubRegion)
    DebugPrint("LHQ_UpdatePlayerSubRegionIdInfo, NewPlayerSubRegionId:", NewPlayerSubRegionId, "end===")
end

function TaskUtils:GetSpcialPreQuestChainIdByConfig(StoryPath)
    local SpcialQuestCfgDatas = DataMgr.SpecialQuestConfig
    for _, Data in pairs(SpcialQuestCfgDatas) do
        if Data.StoryPath and Data.StoryPath == StoryPath then
            return Data.QuestChainId
        end
    end
    return 0
end

function TaskUtils:GetTaskBarWidget()
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    local TaskUIObj = nil
    local BattleMainUI = UIManager:GetUIObj("BattleMain")
    if BattleMainUI ~= nil and BattleMainUI.Pos_TaskBar:GetChildAt(0) then
        TaskUIObj = BattleMainUI.Pos_TaskBar:GetChildAt(0)
    end
    if TaskUIObj ~= nil then
        return TaskUIObj
    end
    return nil
end

function TaskUtils:UpdateSpecialTaskInfo(OpType, TaskInfo)
    local TaskBar = self:GetTaskBarWidget()
    if TaskBar then
        TaskBar:UpdateSpecialTaskInfo(OpType, TaskInfo)
    end
end

function TaskUtils:CheckSpecialTaskDoing()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    if Avatar.SpecialQuestData then
	    PrintTable({SpecialQuestData = Avatar.SpecialQuestData:all_dump(Avatar.SpecialQuestData)}, 10)
        for _, QuestData in pairs(Avatar.SpecialQuestData) do
            if QuestData then
                if QuestData.SpecialQuestState == 1 then --Doing
                    return true
                end
            end
        end
    else
		DebugPrint("Avatar.SpecialQuestData Is nil")
    end

    return false
end

function TaskUtils:QuestOpenMainMapByQuestTrack()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local Platform = CommonUtils.GetDeviceTypeByPlatformName(self)
    if Platform == "Mobile" then
        local Objs = MissionIndicatorManager:GetAllIndicatorUIObjs()
        if not IsEmptyTable(Objs) then
            for Name, UIObj in pairs(Objs) do
                UIObj:RePlayAppearAnim()
            end
        end
    end

    local TrackingQuestData = TaskUtils:GetTrackingQuestDetailInfo()
    local IsFairyLand = false
    if TrackingQuestData and TrackingQuestData.IsFairyLand then
        IsFairyLand = TrackingQuestData.IsFairyLand
    end
    if not TrackingQuestData then
        return
    end

    local TargetSubRegionId = MissionIndicatorManager:GetTargetTaskSubRegionId(Avatar.TrackingQuestChainId, Avatar.QuestChains[Avatar.TrackingQuestChainId].DoingQuestId)
    if DataMgr.SubRegion[Avatar.CurrentRegionId] == nil or DataMgr.SubRegion[TargetSubRegionId] == nil then
        -- local DoingQuestId = 0
        -- if Avatar.QuestChains[Avatar.TrackingQuestChainId] then
        --     DoingQuestId = Avatar.QuestChains[Avatar.TrackingQuestChainId].DoingQuestId
        -- end
        -- ScreenPrint(string.format("[任务栏追踪按钮Error]任务指引点区域数据不存在, QuestChainId:%s, DoingQuestId:%s, TargetSubRegionId:%s, 请策划同学配",
        -- tostring(Avatar.TrackingQuestChainId), tostring(DoingQuestId), tostring(TargetSubRegionId)))
        local CurTrackingQuestChainId = Avatar.TrackingQuestChainId
        local CurTrackingQuestId = 0
        if Avatar.QuestChains[CurTrackingQuestChainId] then
            CurTrackingQuestId = Avatar.QuestChains[CurTrackingQuestChainId].DoingQuestId
        end
        local Message = "任务指引点区域数据不存在，请策划同学配"..
        "\n当前追踪任务链:"..CurTrackingQuestChainId..
        "\n当前追踪任务:"..CurTrackingQuestId..
        "\n玩家子区域:"..Avatar.CurrentRegionId..
        "\n任务子区域Id:"..TargetSubRegionId
        -- UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, "任务栏追踪按钮报错", Message)
        if Const.EnableTaskPrintError then
            ScreenPrint(string.format("%s", Message))
        end
        return
    end
    local CurrentRegionId = DataMgr.SubRegion[Avatar.CurrentRegionId].RegionId
    local TaskRegionId = DataMgr.SubRegion[TargetSubRegionId].RegionId


    if CurrentRegionId ~= TaskRegionId and IsFairyLand == false then
        local MainMap = UIManager(GWorld.GameInstance):GetUIObj("LevelMapMain")
        if MainMap == nil then
            MainMap = UIManager(GWorld.GameInstance):LoadUINew("LevelMapMain", true)
        end

        if TargetSubRegionId ~= Const.HomeBaseSubRegionId then
            -- MainMap.RealWildMap:ChangeRegion(TaskRegionId)
            MainMap.RealWildMap:ChangeRegionForSmartIndicator(TargetSubRegionId, Avatar.TrackingQuestChainId)
            -- MainMap.RealWildMap:MoveMapToQuestTarget(Avatar.TrackingQuestChainId)
        else
            -- MainMap.RealWildMap:ChangeRegion( DataMgr.SubRegion[Const.IceCitySubRegionId].RegionId)
            MainMap.RealWildMap:ChangeRegionForSmartIndicator(TargetSubRegionId, Avatar.TrackingQuestChainId)
            -- MainMap.RealWildMap:MoveMapToQuestTarget(Avatar.TrackingQuestChainId)
        end
    elseif CurrentRegionId ~= TaskRegionId or IsFairyLand == true then
        if DataMgr.SubRegion[Avatar.CurrentRegionId] == DataMgr.SubRegion[TargetSubRegionId] and IsFairyLand == true then
            return
        end
        local CancelDeliverTo = function()
        end
        
        local DoDeliverTo = function()
            local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
            if IsValid(GameMode) then
                GameMode:HandleLevelDeliver(UE4.EModeType.ModeRegion, TargetSubRegionId, TrackingQuestData.FairyLandDeliverIndex, true)
            end
        end

        local UIManager = GWorld.GameInstance:GetGameUIManager()
        if not DataMgr.QuestChain[Avatar.TrackingQuestChainId] then
            return
        end
        local TaskName = DataMgr.QuestChain[Avatar.TrackingQuestChainId].QuestChainName
        local Params =
        {
            ShortText = string.format("%s <H>%s</>", GText("UI_Prompt_QuestTrans"), GText(TaskName)),
            LeftCallbackObj = self,
            LeftCallbackFunction = CancelDeliverTo,
            RightCallbackObj = self,
            RightCallbackFunction = DoDeliverTo,
            CloseBtnCallbackObj = self,
            CloseBtnCallbackFunction = CancelDeliverTo
        }
        UIManager:ShowCommonPopupUI(100160, Params)
    end
end

function TaskUtils:CheckIsNeedLoadLevelMap(InTaskSubRegionId, InCurrentSubRegionid)
    local bAnyTeleporPointUnlock = self:CheckIsAnyTeleporPointUnlock(InTaskSubRegionId, true)
    local TaskRegionId = 0
    local CurrentRegionId = 0
    if DataMgr.SubRegion[InTaskSubRegionId] and DataMgr.SubRegion[InTaskSubRegionId].RegionId then
        TaskRegionId = DataMgr.SubRegion[InTaskSubRegionId].RegionId
    end
    if DataMgr.SubRegion[InCurrentSubRegionid] and DataMgr.SubRegion[InCurrentSubRegionid].RegionId then
        CurrentRegionId = DataMgr.SubRegion[InCurrentSubRegionid].RegionId
    end

    if TaskRegionId ~= CurrentRegionId and bAnyTeleporPointUnlock then
        return true
    elseif TaskRegionId == CurrentRegionId then
        return false
    else
        -- local TargetRegionId, Data = self:TryGetSmartPointDataForRegionMap(InCurrentSubRegionid, InTaskSubRegionId)
        return true
    end
end


function TaskUtils:GetIconTextureByTrackQuestChainType(QuestChainId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return nil
    end
    local TrackQuestChainId
    if not QuestChainId then
        TrackQuestChainId = Avatar.TrackingQuestChainId
    else
        TrackQuestChainId = QuestChainId
    end

    local ConstQuestChainTypeTable = 
        {
            [Const.MainQuestChainType] = '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_MainMission.T_Gp_MainMission',
            [Const.SideQuestChainType] = '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SideMission.T_Gp_SideMission',
            [Const.MainActivityQuestChainType] = '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_EventMainMission.T_Gp_EventMainMission',
            [Const.LimTimeQuestChainType] = '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_LTMission.T_Gp_LTMission',
            [Const.SpecialSideQuestChainType] = '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SpSideMission.T_Gp_SpSideMission',
        }
    if DataMgr.QuestChain[TrackQuestChainId] then
        local CurQuestChainType = DataMgr.QuestChain[TrackQuestChainId].QuestChainType
        if ConstQuestChainTypeTable[CurQuestChainType] then
            return LoadObject(ConstQuestChainTypeTable[CurQuestChainType])
        end
    end
    return nil
end

function TaskUtils:GetIconTextureByQuestChainType(InChainId)
    local ConstQuestChainTypeTable = 
        {
            [Const.MainQuestChainType] = '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_MainMission.T_Gp_MainMission',
            [Const.SideQuestChainType] = '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SideMission.T_Gp_SideMission',
            [Const.MainActivityQuestChainType] = '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_EventMainMission.T_Gp_EventMainMission',
            [Const.LimTimeQuestChainType] = '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_LTMission.T_Gp_LTMission',
            [Const.SpecialSideQuestChainType] = '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SpSideMission.T_Gp_SpSideMission',
        }
    if DataMgr.QuestChain[InChainId] then
        local CurQuestChainType = DataMgr.QuestChain[InChainId].QuestChainType
        if ConstQuestChainTypeTable[CurQuestChainType] then
            return LoadObject(ConstQuestChainTypeTable[CurQuestChainType])
        end
    end
    return nil
end

function TaskUtils:GetGrayIconTextureByQuestChainType(InChainId)
    local ConstQuestChainTypeTable = 
        {
            [Const.MainQuestChainType] = '/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_TaskMainLine.T_Tab_TaskMainLine',
            [Const.SideQuestChainType] = '/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_TaskSider.T_Tab_TaskSider',
            [Const.MainActivityQuestChainType] = '/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_TaskActivityMainLine.T_Tab_TaskActivityMainLine',
            [Const.LimTimeQuestChainType] = '/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_TaskLimitedtimeActivity.T_Tab_TaskLimitedtimeActivity',
            [Const.SpecialSideQuestChainType] = '/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_TaskSpecialSider.T_Tab_TaskSpecialSider',
        }
    if DataMgr.QuestChain[InChainId] then
        local CurQuestChainType = DataMgr.QuestChain[InChainId].QuestChainType
        if ConstQuestChainTypeTable[CurQuestChainType] then
            return LoadObject(ConstQuestChainTypeTable[CurQuestChainType])
        end
    end
    return nil
end

function TaskUtils:GetOptinalIconTextureByQuestChainType(InChainId)
    local ConstQuestChainTypeTable = 
        {
            [Const.MainQuestChainType] = '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_MainMission_Optional.T_Gp_MainMission_Optional',
            [Const.SideQuestChainType] = '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SideMission_Optional.T_Gp_SideMission_Optional',
            [Const.SpecialSideQuestChainType] = '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SpSideMission_Optional.T_Gp_SpSideMission_Optional',
        }
    if DataMgr.QuestChain[InChainId] then
        local CurQuestChainType = DataMgr.QuestChain[InChainId].QuestChainType
        if ConstQuestChainTypeTable[CurQuestChainType] then
            return LoadObject(ConstQuestChainTypeTable[CurQuestChainType])
        end
    else
            return LoadObject('/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_DynQuest_Optional.T_Gp_DynQuest_Optional')
    end
    return nil
end

function TaskUtils:GetDiffIconByQuestChainType(InChainId, InContent)
    if DataMgr.QuestChain[InChainId] and DataMgr.QuestChain[InChainId].QuestChainType then
        local InType = DataMgr.QuestChain[InChainId].QuestChainType
        if InType == Const.MainQuestChainType or InType == Const.MainActivityQuestChainType then
            return '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SubTask_'..InContent..'.T_Gp_SubTask_'..InContent
        elseif InType == Const.SpecialSideQuestChainType or InType == Const.LimTimeQuestChainType then
            return '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SubTask_'..InContent..'_SpSide'..'.T_Gp_SubTask_'..InContent..'_SpSide'
        elseif InType == Const.SideQuestChainType then
            return '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SubTask_'..InContent..'_Side'..'.T_Gp_SubTask_'..InContent..'_Side'
        end
    end
end

function TaskUtils:GetDiffIconOptionalByQuestChainType(InChainId, InContent)
    if DataMgr.QuestChain[InChainId] and DataMgr.QuestChain[InChainId].QuestChainType then
        local InType = DataMgr.QuestChain[InChainId].QuestChainType
        if InType == Const.MainQuestChainType or InType == Const.MainActivityQuestChainType then
            return '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Digging_'..InContent..'.T_Gp_Digging_'..InContent
        elseif InType == Const.SpecialSideQuestChainType or InType == Const.LimTimeQuestChainType then
            return '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SubTask_'..InContent..'_SpSide_Optional'..'.T_Gp_SubTask_'..InContent..'_SpSide_Optional'
        elseif InType == Const.SideQuestChainType then
            return '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SubTask_'..InContent..'_Side_Optional'..'.T_Gp_SubTask_'..InContent..'_Side_Optional'
        end
    end
end

function TaskUtils:GetOptionalDiffIconByQuestChainType(InType, InContent)
    if InType == Const.MainQuestChainType or InType == Const.MainActivityQuestChainType then

    elseif InType == Const.SpecialSideQuestChainType or InType == Const.LimTimeQuestChainType then

    elseif InType == Const.SideQuestChainType then

    end
end

function TaskUtils:GetUnlockMainStory()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local AllQuestData = Avatar.QuestChains or {}    
    for QuestChainId, Data in pairs(AllQuestData) do
        if DataMgr.QuestChain[QuestChainId] and DataMgr.QuestChain[QuestChainId].QuestChainType then
            local QuestChainType = DataMgr.QuestChain[QuestChainId].QuestChainType
            if QuestChainType == 1 and Data.State == 0 and Data.CanShow then
                return QuestChainId
            end
        end
    end  
    return nil
end

-- function TaskUtils:CheckUnlockMainStoryLevel(QuestChainId)
--     local Avatar = GWorld:GetAvatar()
--     if not Avatar then
--         return
--     end
--     local QuestChainType = DataMgr.QuestChain[QuestChainId].QuestChainType
--     if QuestChainType == 1 then
--         local UnlockConditionId = DataMgr.QuestChain[QuestChainId].UnlockCondition
--         if UnlockConditionId then
--             local UnlockCondition = DataMgr.Condition[UnlockConditionId].ConditionMap
--             for Type, Param in pairs(UnlockCondition) do
--                 if Type == "PlayerLevelMin" then
--                     if Avatar.Level < Param[1] then
--                         return true
--                     else
--                         return false
--                     end
--                 end
--             end
--         end
--     end 
-- end

function TaskUtils:TryGetSmartPointDataForRegionMap(CurSubRegionId, TargetSubRegionId)
    local function ContainsElement(table, element)
        for _, value in pairs(table) do
            if value[1] == element then
                return value
            end
        end
        return nil
    end

    local function ContainsSubRegion(table, element)
        for _, value in pairs(table) do
            if value == element then
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

    local RetWeight = math.maxinteger
    local RetData = nil

    local MinDistance = math.maxinteger
    local RetDataTable = {}
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
    local PlayerChar = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance,0)

    if not ContainsElement(RegionTargetDatas, TargetSubRegionId) then
        for _, IteraData in pairs(RegionTargetDatas) do
            local IterWeight = TryFindTargetPointByBFS(IteraData)
            if IterWeight >= 0 and IterWeight <= RetWeight then
                RetWeight = IterWeight
                table.insert(RetDataTable, IteraData)
            end
        end
        for _, Data in pairs(RetDataTable) do
            local NewTargetPoint = GameState:GetTargetPoint(Data[2])
            if NewTargetPoint and TaskUtils:CheckIsAnyTeleporPointUnlock(Data[1], true) then
                local PointLocation = NewTargetPoint:K2_GetActorLocation()
                local Distance = UKismetMathLibrary.Vector_Distance(PlayerChar.CurrentLocation, PointLocation)
                if Distance < MinDistance then
                    MinDistance = Distance
                    RetData = Data
                end
            end
        end

    else
        RetWeight = 1
        for _, IteraData in pairs(RegionTargetDatas) do
            if DataMgr.RegionGraph[IteraData[1]].RegionStart and ContainsSubRegion(DataMgr.RegionGraph[IteraData[1]].RegionStart, TargetSubRegionId) then
                table.insert(RetDataTable, IteraData)
            end
        end

        local TempRetData = {}
        RetData = RetData or {}
        for _, Data in pairs(RetDataTable) do
            if Data and Data[1] and Data[2] and DataMgr.SubRegion[Data[1]] then --当前所在区域就不用判断传送点是否解锁了
                local NewTargetPoint = GameState:GetTargetPoint(Data[2])
                local IsConditionUnlock = true
                local Avatar = GWorld:GetAvatar()
                if Avatar and Data[4] then
                  IsConditionUnlock = ConditionUtils.CheckCondition(Avatar, Data[4])
                end
                if NewTargetPoint and IsConditionUnlock then
                    local PointLocation = NewTargetPoint:K2_GetActorLocation()
                    local Distance = UKismetMathLibrary.Vector_Distance(PlayerChar.CurrentLocation, PointLocation)
                    if Distance < MinDistance then
                        MinDistance = Distance
                        TempRetData = Data
                    end
                end
            end
        end

        RetData[1] = CurSubRegionId
        RetData[2] = TempRetData[2]
        RetData[3] = TempRetData[3]
    end
    if IsEmptyTable(RetDataTable) and DataMgr.RegionGraph[TargetSubRegionId] 
    and DataMgr.RegionGraph[TargetSubRegionId].SubRegionTarget 
    and DataMgr.RegionGraph[TargetSubRegionId].SubRegionTarget.RegionTarget then --无联通指引, 从对应目标区域开始找已经解锁传送点的区域
        local TargetRegionTargets = DataMgr.RegionGraph[TargetSubRegionId].SubRegionTarget.RegionTarget
        for _, Data in pairs(TargetRegionTargets) do
            local RetRegionId, RetTargetData = self:TryFindUnlockTeleporPointByBFS(Data[1], TargetSubRegionId)
            if RetRegionId and RetTargetData then
                RetData = RetTargetData
                return RetRegionId, RetData
            end
        end
    end
    return nil, RetData
end

function TaskUtils:TryFindUnlockTeleporPointByBFS(InSubRegionId,TargetSubRegionId)
    local function TryGetAnyRegionDataUnlock(table)
        if table then
            for _, value in pairs(table) do
                if self:CheckIsAnyTeleporPointUnlock(value, true)then
                    return value
                end
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

    local function CheckTargetSubRegionIdFromStart(StartTable, TargetSubRegionId)
        if StartTable then
            for _, value in pairs(StartTable) do
                if value == TargetSubRegionId then
                    return true
                end
            end
        end
        return false
    end

    if not DataMgr.RegionGraph[InSubRegionId] or
    not  DataMgr.SubRegion[InSubRegionId].RegionId then
        return nil, nil
    end
 
    local RegionStartDatas = DataMgr.RegionGraph[InSubRegionId].RegionStart
    local TargetRegionStartDatas = DataMgr.RegionGraph[TargetSubRegionId].RegionStart

    local function TryFindTargetPointByBFS(RootSubRegionId)
        local RootRegionQueue = CreateQueue()
        local RootRegionDatas = DataMgr.RegionGraph[RootSubRegionId].SubRegionTarget.RegionTarget --Debug 1：逐一遍历对应子区域里的SubRegionTarget数据
        for _, v in pairs(RootRegionDatas) do
            Enqueue(RootRegionQueue, v)
        end
        local QueueCount = RootRegionQueue.last - RootRegionQueue.first + 1

        local Weight = 1
        local QueueIndex = 0
        while not IsEmptyQueue(RootRegionQueue) do
            if TryGetAnyRegionDataUnlock(RegionStartDatas) == nil then --当前区域没有直接可达目标区域，需要逐个在当前区域的联通区域内找
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
                
                if DataMgr.RegionGraph[frontDataSubRegionId].RegionStart and not ContainsPath(RootRegionQueue.Path, frontDataSubRegionId) then
                    local NewRegionDatas = DataMgr.RegionGraph[frontDataSubRegionId].SubRegionTarget.RegionTarget --取队列第一个区域
                    for _, NewRegionData in pairs(NewRegionDatas) do
                        local SubRegionId = NewRegionData[1]--Debug 2：取出队列第一个子区域数据，逐一遍历对应子区域里的SubRegionTarget数据
                        Enqueue(RootRegionQueue, NewRegionData)
                        if TryGetAnyRegionDataUnlock(NewRegionDatas) then
                            local RetRegionId = DataMgr.SubRegion[SubRegionId].RegionId
                            return RetRegionId, NewRegionData[1]
                        end
                    end
                end
                ::continue::
            else
               
                for _, Data in pairs(RootRegionDatas) do
                    if Data and Data[1] and CheckTargetSubRegionIdFromStart(TargetRegionStartDatas, Data[1]) then
                        return DataMgr.SubRegion[RootSubRegionId].RegionId, Data
                    end
                end

                return nil ,nil
            end
        end

        if IsEmptyQueue(RootRegionQueue) then --当前区域无论如何都到不了目标区域
            return nil ,nil
        end
    end

    return TryFindTargetPointByBFS(InSubRegionId)
end

function TaskUtils:CheckIsAnyTeleporPointUnlock(InSubRegionId, IsInAllSubRegion)
    if DataMgr.SubRegion[InSubRegionId] == nil then
        return false
    end
    local RegionId = DataMgr.SubRegion[InSubRegionId].RegionId
    local RegionData = DataMgr.Region[RegionId]
    if not RegionData then
        return false
    end
    local TempTransferDatas = {}
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    for _, TransferData in pairs(DataMgr.TeleportPoint) do
        if IsInAllSubRegion then
            if CommonUtils.HasValue(RegionData.IsRandom, TransferData.TeleportPointSubRegion)and TransferData.StaticId then
                TempTransferDatas[TransferData.StaticId] = TransferData
            end
        else
            if TransferData.TeleportPointSubRegion == InSubRegionId and TransferData.StaticId then
                TempTransferDatas[TransferData.StaticId] = TransferData
            end
        end
    end

    local TmpFullRegionStoreDatas = GameMode:GetRegionDataMgrSubSystem().DataLibrary:GetFullRegionStoreDatas()
    if TmpFullRegionStoreDatas ~= nil then
        for _, RegionBaseData in pairs(TmpFullRegionStoreDatas) do
            local Data = TempTransferDatas[RegionBaseData.CreatorId]
            if Data then
                local State = false
                if RegionBaseData.State then
                    State = RegionBaseData.State.OpenState
                end

                if State then
                    return true
                end
            end
        end
    end

    return false
end


function TaskUtils:SetQuestInterfaceJump(QuestId, IsJump, JumpId, IsShowGuide)
    QuestInterfaceJump = QuestInterfaceJump or {}
    QuestInterfaceJump[QuestId] = QuestInterfaceJump[QuestId] or {}
    QuestInterfaceJump[QuestId] = {IsJump, IsShowGuide}
    QuestInterfaceJumpId = QuestInterfaceJumpId or {}
    QuestInterfaceJumpId[QuestId] = JumpId
end

function TaskUtils:GetQuestInterfaceJump(QuestId)
    if not QuestId then
        return nil
    end
    if QuestInterfaceJump[QuestId] then
        return QuestInterfaceJump[QuestId][1]
    end
end

function TaskUtils:GetQuestIsShowGuide(QuestId)
    if not QuestId then
        return nil
    end
    if QuestInterfaceJump[QuestId] then
        return QuestInterfaceJump[QuestId][2]

    end
end

function TaskUtils:GetQuestInterfaceJumpId(QuestId)
    if not QuestId then
        return nil
    end
    return QuestInterfaceJumpId[QuestId]
end

function TaskUtils:RemoveQuestInterfaceJump(QuestId)
    QuestInterfaceJump[QuestId] = nil
    QuestInterfaceJumpId[QuestId] = nil
end

function TaskUtils:JudgeCanTrack()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
    if GameState and GameState:IsInRegion() and not Avatar:IsInHardBoss() then
        return true
    end
    return false
end


return TaskUtils
