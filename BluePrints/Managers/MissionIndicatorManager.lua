local GuidePointLocData = require ("BluePrints.UI.TaskPanel/QuestGuidePointLocData")
local TaskUtils = require "BluePrints.UI.TaskPanel.TaskUtils"

local MissionIndicatorManager = {}
MissionIndicatorManager.MissionIndicatorNames = {}
MissionIndicatorManager.SpecialSideIndicatorNames = {}
MissionIndicatorManager.MissionNpcSideBubbles = {}
MissionIndicatorManager.bTriggerCollapsAll = true
MissionIndicatorManager.TrackingSpecialSideQuestChainId = nil
function MissionIndicatorManager:ActiveMissionIndicatorByNode(InNode)
    local IndicatorData = 
    {
        GuideType = nil,
        PointKey = nil,
        StaticCreatorKey = nil,
        GuideTag = nil,
        SourceId = 0
    }
    if self["SetIndicatorDataBy_"..InNode.Type] then
        self["SetIndicatorDataBy_"..InNode.Type](self, IndicatorData, InNode)
    end

    if IndicatorData.GuideType == nil or IndicatorData.PointKey == nil then
        GWorld.logger.errorlog("STL节点指引数据有误, STL节点Key", InNode.Key)
        return
    end

    self:SetSTLIndicatorUniqueData(IndicatorData, InNode)
    if IndicatorData.GuideTag == nil then
        GWorld.logger.errorlog("STL指引节点生成的GuideTag为空, STL节点Key", InNode.Key)
        return
    end

    local UIObj = self:LoadMissionIndicatorUI(IndicatorData, InNode)
    if UIObj ~= nil then
        MissionIndicatorManager.MissionIndicatorNames[UIObj:GetName()] = IndicatorData.SourceId
        EventManager:FireEvent(EventID.OnChangeTaskIndicator, TaskUtils.MissionNpcGuideMaps)
    end
end

--幻境入口指引点
function MissionIndicatorManager:ActiveFailryQuestIndicatorBy(InNode)
    local IndicatorData = 
    {
        GuideType = nil,
        PointKey = nil,
        StaticCreatorKey = nil,
        GuideTag = nil,
        SourceId = 0
    }
    self:SetIndicatorDataBy_FairyLandNode(IndicatorData, InNode)
    self:SetSTLIndicatorUniqueData(IndicatorData, InNode)
    local UIObj = self:LoadMissionIndicatorUI(IndicatorData, InNode)
    if UIObj ~= nil then
        MissionIndicatorManager.MissionIndicatorNames[UIObj:GetName()] = IndicatorData.SourceId
        EventManager:FireEvent(EventID.OnChangeTaskIndicator, TaskUtils.MissionNpcGuideMaps)
    end
end


function MissionIndicatorManager:ReactiveMissionIndicatorByNode(InNode)
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    local UIName = ""
    if InNode.bIsDynamicEvent then
        UIName = "DynamicEventIndicator_"..InNode.Key
    else
        UIName = "TaskIndicator_"..InNode.Key
    end

    if InNode.Type == "ShowOrHideTaskIndicatorNode" then
        if InNode.bIsDynamicEvent then
            UIName = "DynamicEventIndicator_"..InNode.GuideName
        else
            UIName = "TaskIndicator_"..InNode.GuideName
        end
    end
    
    if MissionIndicatorManager.MissionIndicatorNames[UIName] then
        MissionIndicatorManager.MissionIndicatorNames[UIName] = nil
    else
        GWorld.logger.errorlog("删除了不存在的STL指引点，NodeKey:", InNode.Key)
    end

    local UIObj = UIManager:GetUIObj(UIName)
    if UIObj then
        UIObj:CloseIndicator()
    end
end

function MissionIndicatorManager:ActiveMissionIndicatorByRegionMap(InDisplayName, InQuestNpcId)
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    local SystemUIConfig = DataMgr.SystemUI["TaskIndicator"]
    self.SpecialSideIndicatorNames[InDisplayName] = "UnSpecialSide_"..InQuestNpcId
    return UIManager:LoadUI(UIConst.TASKINDICATORUI, "TaskIndicator#".."UnSpecialSide_"..InQuestNpcId, SystemUIConfig.ZOrder, "UnSpecialSide", InDisplayName, InQuestNpcId)
end

function MissionIndicatorManager:ReactiveMissionIndicatorByRegionMap(InQuestNpcId)
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    local UIObj = UIManager:GetUIObj("UnSpecialSide_"..InQuestNpcId)
    if UIObj then
        self.SpecialSideIndicatorNames[InQuestNpcId] = nil
        UIObj:CloseIndicator()
    end
end

function MissionIndicatorManager:GenIndicatorGuideTag(InNode)
    -- body
end

function MissionIndicatorManager:SetIndicatorDataBy_QuestStartNode(InData, InNode)
    InData.GuideType = InNode.StoryGuideType
    InData.PointKey = InNode.StoryGuidePointName
    if InNode.StoryGuideType == "Npc" then
        local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
        local TargetStaticCreator = GameState.StaticCreatorStringNameMap:FindRef(InNode.StoryGuidePointName)
        if TargetStaticCreator then
            InData.PointKey = TargetStaticCreator.UnitId
        end
    end
    InData.StaticCreatorKey = InNode.StoryGuidePointName
end

function MissionIndicatorManager:SetIndicatorDataBy_ElevatorNode(InData, InNode)
    InData.GuideType = InNode.GuideType
    InData.PointKey = InNode.GuideDisplayName
    if InNode.GuideType == "N" then
        local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
        local TargetStaticCreator = GameState.StaticCreatorStringNameMap:FindRef(InNode.GuidePointName)
        if TargetStaticCreator then
            InData.PointKey = TargetStaticCreator.UnitId
        end
    end
    InData.StaticCreatorKey = InNode.GuideDisplayName
end

function MissionIndicatorManager:SetIndicatorDataBy_GoToNode(InData, InNode)
    InData.GuideType = InNode.GuideType
    InData.PointKey = InNode.GuidePointName
    if InNode.GuideType == "N" then
        local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
        local TargetStaticCreator = GameState.StaticCreatorStringNameMap:FindRef(InNode.GuidePointName)
        if TargetStaticCreator then
            InData.PointKey = TargetStaticCreator.UnitId
        end
    end
    InData.StaticCreatorKey = InNode.GuidePointName
end

function MissionIndicatorManager:SetIndicatorDataBy_GoToRegionNode(InData, InNode)
    InData.GuideType = InNode.GuideType
    InData.PointKey = InNode.GuideName
    if InNode.GuideType == "N" then
        local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
        local TargetStaticCreator = GameState.StaticCreatorStringNameMap:FindRef(InNode.GuideName)
        if TargetStaticCreator then
            InData.PointKey = TargetStaticCreator.UnitId
        end
    end
    InData.StaticCreatorKey = InNode.GuideName
end

function MissionIndicatorManager:SetIndicatorDataBy_SitOnNode(InData, InNode)
    InData.GuideType = InNode.GuideType
    InData.PointKey = InNode.GuidePointName
    if InNode.GuideType == "N" then
        local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
        local TargetStaticCreator = GameState.StaticCreatorStringNameMap:FindRef(InNode.GuidePointName)
        if TargetStaticCreator then
            InData.PointKey = TargetStaticCreator.UnitId
        end
    end
    InData.StaticCreatorKey = InNode.GuidePointName
end

function MissionIndicatorManager:SetIndicatorDataBy_MiniGameOpenGateNode(InData, InNode)
    InData.GuideType = InNode.GuideType
    InData.PointKey = InNode.GuidePointName
    if InNode.GuideType == "N" then
        local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
        local TargetStaticCreator = GameState.StaticCreatorStringNameMap:FindRef(InNode.GuidePointName)
        if TargetStaticCreator then
            InData.PointKey = TargetStaticCreator.UnitId
        end
    end
    InData.StaticCreatorKey = InNode.GuidePointName
end

function MissionIndicatorManager:SetIndicatorDataBy_SubmitItemNode(InData, InNode)
    InData.GuideType = InNode.GuideType
    InData.PointKey = InNode.GuidePointName
    if InData.GuideType == "N" then
        local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
        local TargetStaticCreator = GameState.StaticCreatorStringNameMap:FindRef(InNode.GuidePointName)
        if TargetStaticCreator then
            InData.PointKey = TargetStaticCreator.UnitId
        end
    end
    InData.StaticCreatorKey = InNode.GuidePointName
end

function MissionIndicatorManager:SetIndicatorDataBy_PickUpNode(InData, InNode)
    InData.GuideType = InNode.GuideType
    InData.PointKey = InNode.GuidePointName
    InData.StaticCreatorKey = InNode.GuidePointName
end

function MissionIndicatorManager:SetIndicatorDataBy_ResourceCollectNode(InData, InNode)
    InData.GuideType = InNode.GuideType
    InData.PointKey = InNode.GuidePointName
    if InNode.GuideType == "N" then
        local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
        local TargetStaticCreator = GameState.StaticCreatorStringNameMap:FindRef(InNode.GuidePointName)
        if TargetStaticCreator then
            InData.PointKey = TargetStaticCreator.UnitId
        end
    end
    InData.StaticCreatorKey = InNode.GuidePointName
end

function MissionIndicatorManager:SetIndicatorDataBy_TalkNode(InData, InNode)
    InData.GuideType = InNode.GuideType
    if InData.GuideType == "N" then
        InData.PointKey = InNode.NpcId
    else
        InData.PointKey = InNode.GuidePointName
    end
    InData.StaticCreatorKey = InNode.GuidePointName
end

function MissionIndicatorManager:SetIndicatorDataBy_WaitImpressionTalkCompleteNode(InData, InNode)
    InData.GuideType = InNode.GuideType
    InData.PointKey = InNode.NPCStaticCreaterName
    if InNode.GuideType == "N" then
        local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
        local TargetStaticCreator = GameState.StaticCreatorStringNameMap:FindRef(InNode.NPCStaticCreaterName)
        if TargetStaticCreator then
            InData.PointKey = TargetStaticCreator.UnitId
        end
    end
    InData.StaticCreatorKey = InNode.NPCStaticCreaterName
end

function MissionIndicatorManager:SetIndicatorDataBy_FairyLandNode(InData, InNode)
    InData.GuideType = "M"
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
    local Point = GameState.StaticCreatorMap:FindRef(InNode.CreateId)
    if Point then
        InData.PointKey = Point.DisplayName
        InData.StaticCreatorKey = Point.DisplayName
    end
    InData.GuideTag = "FairyLand"..InNode.Key
end

function MissionIndicatorManager:SetIndicatorDataBy_ShowOrHideTaskIndicatorNode(InData, InNode)
    InData.GuideType = InNode.GuideType
    InData.PointKey = InNode.GuideName
    if InNode.GuideType == "N" then
        local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
        local TargetStaticCreator = GameState.StaticCreatorStringNameMap:FindRef(InNode.GuideName)
        if TargetStaticCreator then
            InData.PointKey = TargetStaticCreator.UnitId
        end
    end
    InData.StaticCreatorKey = InNode.GuideName
    InData.GuideTag = InNode.GuideName
end

function MissionIndicatorManager:SetIndicatorDataBy_GameModeCompleteNode(InData, InNode)
    InData.GuideType = InNode.GuideType
    InData.PointKey = InNode.GuidePointName
    if InNode.GuideType == "N" then
        local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
        local TargetStaticCreator = GameState.StaticCreatorStringNameMap:FindRef(InNode.GuideName)
        if TargetStaticCreator then
            InData.PointKey = TargetStaticCreator.UnitId
        end
    end
    InData.StaticCreatorKey = InNode.GuidePointName
end

function MissionIndicatorManager:SetIndicatorDataBy_WaitingMechanismEnterStateNode(InData, InNode)
    InData.GuideType = "M"
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
    if InNode.GuidePointName == nil or InNode.GuidePointName == "" then
        if InNode.CreateType == "StaticCreator" then
            InData.PointKey = InNode.CreateId
        else
            local SceneItem = GameState.ManualActiveCombat:Find(InNode.CreateId)
            if SceneItem then
                InData.PointKey = SceneItem.CreatorId
            end
        end

        local TargetStaticCreator = GameState.StaticCreatorMap:Find(InNode.PointKey)
        if TargetStaticCreator then
            InData.StaticCreatorKey = TargetStaticCreator.DisplayName
        end
    else
        InData.PointKey = InNode.GuidePointName
        InData.StaticCreatorKey = InNode.GuidePointName
    end
end

function MissionIndicatorManager:SetIndicatorDataBy_FirstObservationCompleteNode(InData, InNode)
    InData.GuideType = InNode.GuideType
    InData.PointKey = InNode.ObservationPointName
    InData.StaticCreatorKey = InNode.ObservationPointName
end

function MissionIndicatorManager:SetIndicatorDataBy_CameraNode(InData, InNode)
    InData.GuideType = InNode.GuideType
    InData.PointKey = InNode._GuidePointName
    InData.StaticCreatorKey = InNode._GuidePointName
end

function MissionIndicatorManager:SetIndicatorDataBy_KillMonsterNode(InData, InNode)
    InData.GuideType = InNode.GuideType
    InData.PointKey = InNode.GuideName
    InData.StaticCreatorKey = InNode.GuideName
end

function MissionIndicatorManager:SetSTLIndicatorUniqueData(InData, InNode)
    local Avatar = GWorld:GetAvatar()
    local GuideTag = nil
    if not Avatar then
        GWorld.logger.errorlog("STL节点指引数据有误, Avatar为空")
        return
    end

    if InData.GuideTag == nil then
        InData.GuideTag = InNode.Key
    end

    local GuidePointChainId = 0
    if Avatar.InSpecialQuest then
        GuidePointChainId = Avatar.TrackingQuestChainId
    else
        GuidePointChainId = InNode.Context.QuestChainId
    end
    InData.SourceId = GuidePointChainId
end

function MissionIndicatorManager:LoadMissionIndicatorUI(IndicatorData, InNode)
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    local SystemUIConfig = DataMgr.SystemUI["TaskIndicator"]
    local STLExportInfo = DataMgr.STLExportQuestChain[InNode.QuestChainId]
    local IsPreQuest = false
    if STLExportInfo and STLExportInfo.Quests[InNode.QuestId] ~= nil and STLExportInfo.Quests[InNode.QuestId].IsPreQuest then
        IsPreQuest = STLExportInfo.Quests[InNode.QuestId].IsPreQuest
    end

    if InNode.bIsDynamicEvent then
        local DynIndicator = UIManager:GetUIObj("DynamicEventIndicator_"..IndicatorData.GuideTag)
        if DynIndicator then
            DynIndicator:SetDynamicEventGuideInfo(IndicatorData.GuideType, IndicatorData.PointKey, IndicatorData.StaticCreatorKey, InNode, IndicatorData.GuideTag)
            return DynIndicator
        else
            return UIManager:LoadUI(UIConst.TASKINDICATORUI, "TaskIndicator#".."DynamicEventIndicator_"..IndicatorData.GuideTag, SystemUIConfig.ZOrder,
            "Dynamic", IndicatorData.GuideType, IndicatorData.PointKey, IndicatorData.StaticCreatorKey, InNode, IndicatorData.GuideTag)
        end
    else
        local TaskIndicator = UIManager:GetUIObj("TaskIndicator_"..IndicatorData.GuideTag)
        if TaskIndicator then
            TaskIndicator:SetGuideInfo(IndicatorData.GuideType, IndicatorData.PointKey, IndicatorData.StaticCreatorKey, InNode, IndicatorData.GuideTag)
            return TaskIndicator
        elseif IsPreQuest and InNode.Type == "QuestStartNode" then
            -- return UIManager:LoadUI(UIConst.TASKINDICATORUI, "TaskIndicator#".."NpcSideQuest_"..IndicatorData.PointKey, SystemUIConfig.ZOrder,
            -- "NpcSide", IndicatorData.PointKey, InNode.QuestChainId)
            MissionIndicatorManager.MissionNpcSideBubbles[IndicatorData.PointKey] = InNode.QuestChainId
            EventManager:FireEvent(EventID.EnableNpcSideBubble, IndicatorData.PointKey, true)
            return nil
        else
            return UIManager:LoadUI(UIConst.TASKINDICATORUI, "TaskIndicator#".."TaskIndicator_"..IndicatorData.GuideTag, SystemUIConfig.ZOrder,
            "Task", IndicatorData.GuideType, IndicatorData.PointKey, IndicatorData.StaticCreatorKey, InNode, IndicatorData.GuideTag)
        end
    end
end

function MissionIndicatorManager:GetIndicatorUIObjByQuestChainId(InChainId)
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    local UIObjs = {}
    if not IsEmptyTable(self.MissionIndicatorNames) then
        for k, v in pairs(self.MissionIndicatorNames) do
            if v == InChainId then
                table.insert(UIObjs, UIManager:GetUIObj(k))
            end
        end
    end

    return UIObjs
end

function MissionIndicatorManager:GetSpecialSideIndicatorUIObj()
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    local UIObjs = {}
    if not IsEmptyTable(self.SpecialSideIndicatorNames) then
        for _, v in pairs(self.SpecialSideIndicatorNames) do
            table.insert(UIObjs, UIManager:GetUIObj(v))
        end
    end

    return UIObjs
end

function MissionIndicatorManager:TriggerAllIndicatorVisible(bShow)
    self.bTriggerCollapsAll = bShow
    local AllObj = self:GetAllIndicatorUIObjs()
    if AllObj then
        for _, v in pairs(AllObj) do
            if bShow then
                -- v:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                v:Show("MissionIndicatorMgr")
            else
                -- v:SetVisibility(UE4.ESlateVisibility.Collapsed)
                v:Hide("MissionIndicatorMgr")
            end
        end
    end
end

function MissionIndicatorManager:GetTargetTaskSubRegionId(QuestChainId, QuestId)
    local TargetSubRegionId = 0
    local Info = TaskUtils:GetQuestDetail(QuestChainId, QuestId)

    if Info and Info.SubRegionId and Info.SubRegionId > 0 then
        local QuestSubRegionId = Info.SubRegionId
        return QuestSubRegionId
    else
        local UIObjs = MissionIndicatorManager:GetIndicatorUIObjByQuestChainIdWithType(QuestChainId, "Task")
        if IsEmptyTable(UIObjs) then
            return TargetSubRegionId
        end
        for _, v in pairs(UIObjs) do
            local TargetKey = v.GuideInfoCache.PointOrStaticCreatorName
            if TargetKey and GuidePointLocData[TargetKey] then
                TargetSubRegionId = GuidePointLocData[TargetKey].SubRegionId
                return TargetSubRegionId
            end
        end
    end

    return TargetSubRegionId
end

function MissionIndicatorManager:GetIndicatorUIObjByQuestChainIdWithType(InChainId, Type)
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    local UIObjs = {}
    if not IsEmptyTable(self.MissionIndicatorNames) then
        for k, v in pairs(self.MissionIndicatorNames) do
            local Obj = UIManager:GetUIObj(k)
            if v == InChainId and Obj and Obj.STLIndicatorType == Type then
                table.insert(UIObjs, Obj)
            end
        end
    end

    return UIObjs
end

function MissionIndicatorManager:GetIndicatorUIObjBySTLType(InType)
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    local UIObjs = {}
    if not IsEmptyTable(self.MissionIndicatorNames) then
        for k, _ in pairs(self.MissionIndicatorNames) do
            local TargetObj = UIManager:GetUIObj(k)
            if IsValid(TargetObj) and TargetObj.STLIndicatorType == InType then
                table.insert(UIObjs, TargetObj)
            end
        end
    end

    return UIObjs
end

function MissionIndicatorManager:GetAllIndicatorUIObjs()
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    local UIObjs = {}
    if not IsEmptyTable(self.MissionIndicatorNames) then
        for k, v in pairs(self.MissionIndicatorNames) do
            local Obj = UIManager:GetUIObj(k)
            if Obj then
                UIObjs[k] = Obj
            end
        end
    end

    if not IsEmptyTable(self.SpecialSideIndicatorNames) then
        for _, v in pairs(self.SpecialSideIndicatorNames) do
            local Obj = UIManager:GetUIObj(v)
            if Obj then
                UIObjs[v] = Obj
            end
        end
    end

    return UIObjs
end

function MissionIndicatorManager:CheckIsShowingAnyNpcIndicatorByUnitId(UnitId)
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
   
    if not IsEmptyTable(MissionIndicatorManager.MissionIndicatorNames) then
        for k, v in pairs(MissionIndicatorManager.MissionIndicatorNames) do
            local UI = UIManager:GetUIObj(k)
            if UI and UI.TryGetTaskGuideNpcUnitId and UI:TryGetTaskGuideNpcUnitId() == UnitId
            and UI.Guide_Node.Visibility == UE4.ESlateVisibility.SelfHitTestInvisible then
                return true
            end
        end
    end

    return false
end

function MissionIndicatorManager:TryToArrangeIndicatorBySmartPointInfo()
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    local TempIndicators = {}
    if not IsEmptyTable(MissionIndicatorManager.MissionIndicatorNames) then
        for Name, _ in pairs(MissionIndicatorManager.MissionIndicatorNames) do
            local UI = UIManager:GetUIObj(Name)
            if UI and UI.Guide_Node.Visibility == UE4.ESlateVisibility.SelfHitTestInvisible and UI.SmartGuidePointInfo then
                TempIndicators[Name] = UI
            end
        end
    end

    if not IsEmptyTable(MissionIndicatorManager.SpecialSideIndicatorNames) then
        for _, Name in pairs(MissionIndicatorManager.SpecialSideIndicatorNames) do
            local UI = UIManager:GetUIObj(Name)
            if UI and UI.Guide_Node.Visibility == UE4.ESlateVisibility.SelfHitTestInvisible and UI.SmartGuidePointInfo then
                TempIndicators[Name] = UI
            end
        end
    end

    if TempIndicators then
        local CategoryCount = 0
        for _, _ in pairs(TempIndicators) do
            CategoryCount = CategoryCount + 1
        end

        local DoorDummyDistance = 200
        local DeltaValue = DoorDummyDistance / (CategoryCount + 1)
        local Carry = DeltaValue

        for _, IconObj in pairs(TempIndicators) do
            if CategoryCount == 1 then
                IconObj.TargetOffsetOnDoor = 0
                IconObj.IsInDoorState = false
                return
            end
            IconObj.IsInDoorState = true
            IconObj.TargetOffsetOnDoor = -(DoorDummyDistance / 2)
            IconObj.TargetOffsetOnDoor = IconObj.TargetOffsetOnDoor + Carry
            Carry = Carry + DeltaValue
        end
    end
end

return MissionIndicatorManager
