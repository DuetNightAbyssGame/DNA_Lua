require "UnLua"

local Component = {}
local GuidePointLocData = require ("BluePrints.UI.TaskPanel/QuestGuidePointLocData")
local ClientEventUtils = require "BluePrints.Common.ClientEvent.ClientEventUtils"
local TaskUtils = require "BluePrints.UI.TaskPanel.TaskUtils"

function Component:InitComponentCoroutine()
    -- local Coroutine = CreateCoroutine(self.InitTeleportPoint)
    -- table.insert(self.InitCoroutines, Coroutine)
    -- coroutine.resume(Coroutine, self, #self.InitCoroutines)
end

function Component:AddComponentEvent()
    EventManager:AddEvent(EventID.UpdateMiniMap,self,self.UpdateMiniMapIndicatorsByStoryNode)
    EventManager:AddEvent(EventID.OnMissiongIndicatorFloorLevelChange,self,self.SetMissionIndicatorsWidgetFloorStyle)
end

function Component:RemoveComponentEvent()
    EventManager:RemoveEvent(EventID.UpdateMiniMap,self)
    EventManager:RemoveEvent(EventID.OnMissiongIndicatorFloorLevelChange,self)
end

function Component:ClearData()
    if self.TaskArea then
        for _,area in pairs(self.TaskArea) do
            area:RemoveFromParent()
        end
        self.TaskArea={}
    end
    self:ClearIndicatorWidgets()
    if  self.IsMiniMap and not IsEmptyTable(self.IndicatorWidgets) then
        for k, v in pairs(self.IndicatorWidgets) do
            if IsValid(v) then
                self:RemoveTrack(v)
                v:RemoveFromParent()
                if self.MainMap.TracePanel:HasChild(v) then
                    self.MainMap.TracePanel:RemoveChild(v)
                end
                if self.Panel_Gamer:HasChild(v) then
                    self.Panel_Gamer:RemoveChild(v)
                end
            end

            self.IndicatorWidgets[k] = nil
        end
        self.IndicatorWidgets = {}
    end
end

function Component:ShowFloor_Component(FloorId)
    self:SetMissionIndicatorsWidgetFloorStyle(FloorId)
end

function Component:OnScaleChange_Component(Percent)
    if not IsEmptyTable(self.IndicatorWidgets) then
        local ConstIndicatorScale = 0.5
        for k, v in pairs(self.IndicatorWidgets) do
            local LocationData = self.IndicatorLocations:FindRef(k)
            local UIPos = self:TransformWorldLocToUILoc(LocationData.X, LocationData.Y)
            if IsValid(v) and LocationData ~= nil then
                v:SetRenderTranslation(UIPos)
                if v.Img_Point and v.Img_Point.Visibility == UE4.ESlateVisibility.Collapsed then
                    v:SetRenderScale(FVector2D(ConstIndicatorScale, ConstIndicatorScale) * self.MapScale)
                end
            end
            if IsValid(self.SelectWidgetTable[k]) then
                self.SelectWidgetTable[k]:SetRenderTranslation(UIPos)
            end
        end
    end
end

function Component:ClearIndicatorWidgets()
    if not IsEmptyTable(self.IndicatorWidgets) then
        for k, v in pairs(self.IndicatorWidgets) do
            if IsValid(v) and self.Panel_Gamer:HasChild(v) then
                self.Panel_Gamer:RemoveChild(v)
            end
            self:RemoveRegionMapGuidPointIndicator(k)
            self.IndicatorWidgets[k] = nil
        end
    end

    self.IndicatorWidgets = {}
end

function Component:CheckIsTrackingQuest(CurMapRegionId)
    local Info = TaskUtils:GetTrackingQuestDetailInfo()
    local QuestSubRegionMapId = nil
    local IsInEXRegion = false
    local HomeBaseRegionId = Const.HomeBaseSubRegionId
    if Info and Info.IsFairyLand then
        return false
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    if Info and Info.SubRegionId and Info.SubRegionId > 0 then
        QuestSubRegionMapId = Info.SubRegionId
    else
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
                QuestSubRegionMapId = GuidePointLocData[TargetKey].SubRegionId
            else
                if Const.EnableTaskPrintError then
                    ScreenPrint(string.format("CheckIsTrackingQuest: 指引点区域数据不存在, 任务区域信息获取失败，请检查导出数据, 指引点: %s", v:GetName()))
                end
            end
            break
        end
    end
    
    -- local TaskMapIndex = nil
    -- local CurWorldMapIndex = nil

    if not QuestSubRegionMapId or not DataMgr.SubRegion[QuestSubRegionMapId] or
    not DataMgr.SubRegion[QuestSubRegionMapId].RegionId 
    or not DataMgr.Region[DataMgr.SubRegion[QuestSubRegionMapId].RegionId]
    or not DataMgr.Region[DataMgr.SubRegion[QuestSubRegionMapId].RegionId].RegionMapId then
        return false
    end
    if QuestSubRegionMapId == HomeBaseRegionId then
        return false
    end

    local QuestRegionMapId = DataMgr.SubRegion[QuestSubRegionMapId].RegionId
    -- if QuestRegionMapId and QuestRegionMapId == CurMapRegionId then
    --     return false
    -- end

    -- local CurMapRegionMapId = DataMgr.Region[self.RegionID].RegionMapId
    -- for WorldMapId, Data in pairs(DataMgr.WorldMap) do
    --     for _, WorldMapRegion in pairs(Data.WorldMapRegion) do
    --         if WorldMapRegion == CurMapRegionMapId then
    --             CurWorldMapIndex = WorldMapId
    --             break
    --         end
    --     end
    -- end

    -- local TaskRegionMapId = DataMgr.Region[DataMgr.SubRegion[QuestSubRegionMapId].RegionId].RegionMapId
    -- for WorldMapId, Data in pairs(DataMgr.WorldMap) do
    --     for _, WorldMapRegion in pairs(Data.WorldMapRegion) do
    --         if WorldMapRegion == TaskRegionMapId then
    --             TaskMapIndex = WorldMapId
    --             if Data.UIRegionType == "EX" then
    --                 IsInEXRegion = true
    --             end
    --             break
    --         end
    --     end
    -- end

    -- if IsInEXRegion and self.MainMap.MapRegionType == "Now" then
    --     return false
    -- end

    return QuestRegionMapId and QuestRegionMapId ~= CurMapRegionId
end

function Component:UpdateMiniMapIndicatorsByStoryNode(InUIName, InUIType, OpType)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    if not self.IsMiniMap then
        return
    end

    local TrackingQuestChainId = Avatar.TrackingQuestChainId
    if OpType == "Delete" then
        local DelWidget = self.IndicatorWidgets[InUIName]
        if IsValid(DelWidget) and DelWidget then
            self:AddOrDeleteMissionIndicatorArray(false, DelWidget)
            self:RemoveTrack(DelWidget)

            if IsValid(self.MainMap.TracePanel) and self.MainMap.TracePanel:HasChild(DelWidget) then
                self.MainMap.TracePanel:RemoveChild(DelWidget)
            end
    
            if IsValid(self.Panel_Gamer) and self.Panel_Gamer:HasChild(DelWidget) then
                self.Panel_Gamer:RemoveChild(DelWidget)
            end

            self.IndicatorWidgets[InUIName] = nil
            self:RemoveIndicatorLocation(InUIName)
        end
    elseif OpType == "Add" then
        if TrackingQuestChainId == 999999 then
            return
        end

        local DelWidget = self.IndicatorWidgets[InUIName]
        if IsValid(DelWidget) and DelWidget then --若已存在则删除再重新创建
            self:AddOrDeleteMissionIndicatorArray(false, DelWidget)
            self:RemoveTrack(DelWidget)

            if IsValid(self.MainMap.TracePanel) and self.MainMap.TracePanel:HasChild(DelWidget) then
                self.MainMap.TracePanel:RemoveChild(DelWidget)
            end
    
            if IsValid(self.Panel_Gamer) and self.Panel_Gamer:HasChild(DelWidget) then
                self.Panel_Gamer:RemoveChild(DelWidget)
            end

            self.IndicatorWidgets[InUIName] = nil
            self:RemoveIndicatorLocation(InUIName)
        end

        local IndicatorWidget = self:CreateIndicatorMiniMapWidget()
        self.IndicatorWidgets[InUIName] = IndicatorWidget
        self:UpdateMiniIndicatorWidgetByType(InUIName, IndicatorWidget, InUIType)
    elseif OpType == "Clear" then
        if not IsEmptyTable(self.IndicatorWidgets) then
            for k, v in pairs(self.IndicatorWidgets) do
                if IsValid(v) then
                    self:AddOrDeleteMissionIndicatorArray(false, v)
                    self:RemoveTrack(v)
                    if IsValid(self.MainMap.TracePanel) and self.MainMap.TracePanel:HasChild(v) then
                        self.MainMap.TracePanel:RemoveChild(v)
                    end
                    if  IsValid(self.Panel_Gamer) and self.Panel_Gamer:HasChild(v) then
                        self.Panel_Gamer:RemoveChild(v)
                    end
                end

                self.IndicatorWidgets[k] = nil
                self:RemoveIndicatorLocation(k)
            end
            self.IndicatorWidgets = {}
        end
    elseif OpType == "ChangeRegion" then
        local ChangeWidget = self.IndicatorWidgets[InUIName]
        if IsValid(ChangeWidget) then
            self:ChangeMissionIndicatorLocationtoSmartPointLoc(InUIName, ChangeWidget)
        end
    end
end

function Component:CreateIndicatorMiniMapWidget()
    local Path = "/Game/UI/WBP/GuidePoint/WBP_GuidePoint_MiniMap.WBP_GuidePoint_MiniMap_C"
    local GuidePointWidget = UE4.UWidgetBlueprintLibrary.Create(self, LoadClass(Path))
    return GuidePointWidget
end

function Component:CreateIndicatorRegionMapWidget(InChainId)
    local PointPath = "/Game/UI/WBP/Map/Widget/WBP_Map_Point.WBP_Map_Point"
    local Point = UIManager(self):CreateWidget(PointPath)
    local SelectPath = "/Game/UI/WBP/Map/Widget/WBP_Map_Select.WBP_Map_Select"
    local Select = UIManager(self):CreateWidget(SelectPath)
    local IconTexture = TaskUtils:GetIconTextureByTrackQuestChainType()
    if IconTexture then
        Point.Img_Point:SetBrushResourceObject(IconTexture)
        if DataMgr.QuestChain[InChainId] then
            local CurQuestChainType = DataMgr.QuestChain[InChainId].QuestChainType
            if CurQuestChainType == 3 then
                -- Point.Img_Range:SetBrushTintColor(UE4.UUIFunctionLibrary.StringToSlateColor("F4F4EFFF"))
            end
        end
    end
    return Point, Select
end

function Component:UpdateMiniIndicatorWidgetByType(InUIName, Widget, Type)
    if Type == "Task" then
        self:AddTaskMiniMapIndicator(InUIName, Widget)
    elseif Type == "Dynamic" then
        self:AddDynamicMiniMapIndicator(InUIName, Widget)
    elseif Type == "SpecialSide" then
        self:AddSpecialSideMiniMapIndicator(InUIName, Widget)
    end
end

function Component:ChangeMissionIndicatorLocationtoSmartPointLoc(InUIName, InWidget)
    local IndicatorUI = UIManager(self):GetUIObj(InUIName)
    if not IndicatorUI then
        return
    end

    local DelWidget = self.IndicatorWidgets[InUIName]
    if IsValid(DelWidget) and DelWidget then
        self:AddOrDeleteMissionIndicatorArray(false, DelWidget)
        self:RemoveTrack(DelWidget)
        if IsValid(self.MainMap.TracePanel) and self.MainMap.TracePanel:HasChild(DelWidget) then
            self.MainMap.TracePanel:RemoveChild(DelWidget)
        end

        if IsValid(self.Panel_Gamer) and self.Panel_Gamer:HasChild(DelWidget) then
            self.Panel_Gamer:RemoveChild(DelWidget)
        end

        self.IndicatorWidgets[InUIName] = nil
    end
    local IndicatorWidget = self:CreateIndicatorMiniMapWidget()
    self.IndicatorWidgets[InUIName] = IndicatorWidget
    self:UpdateMiniIndicatorWidgetByType(InUIName, IndicatorWidget, "Task")
end

function Component:AddTaskMiniMapIndicator(InUIName, Widget)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local TrackingQuestChainId = Avatar.TrackingQuestChainId
    local TrackingQuestId = 0
    if Avatar.QuestChains[TrackingQuestChainId] then
        TrackingQuestId = Avatar.QuestChains[TrackingQuestChainId].DoingQuestId
    end
    if TrackingQuestId == 0 then
        if Const.EnableTaskPrintError then
            ScreenPrint(string.format("[line:555]追踪任务不存在，小地图指引点加载失败, 任务链Id: %s", TrackingQuestChainId))
        end
        return
    end

    local Info = TaskUtils:GetQuestDetail(TrackingQuestChainId, TrackingQuestId)
    if Info and Info.IsFairyLand then
        return
    end

    local IndicatorUI = UIManager(self):GetUIObj(InUIName)
    if not IndicatorUI then
        return
    end

    local TargetPointKey = nil
    local TargetActorKey = nil
    local IsNpcIndicator = IndicatorUI.GuideInfoCache.PointType == "N" or IndicatorUI.GuideInfoCache.PointType == "Npc"

    if IndicatorUI.GuideInfoCache and IndicatorUI.GuideInfoCache.PointName then
        TargetPointKey = IndicatorUI.GuideInfoCache.PointName
    end
    local PointOrStaticKey = nil
    if IndicatorUI.GuideInfoCache and IndicatorUI.GuideInfoCache.PointOrStaticCreatorName then
        PointOrStaticKey = IndicatorUI.GuideInfoCache.PointOrStaticCreatorName
    end
    if GuidePointLocData[TargetPointKey] == nil and PointOrStaticKey ~= nil then
        TargetPointKey = PointOrStaticKey
    end
    if IndicatorUI.IsInTaskRegion == false and IndicatorUI.SmartGuidePointInfo and IndicatorUI.SmartGuidePointInfo[2] then
        TargetPointKey = IndicatorUI.SmartGuidePointInfo[2]
    end
    

    if GuidePointLocData[TargetPointKey] == nil then
        if Const.EnableTaskPrintError then
            ScreenPrint(string.format("[line:577]任务小地图地图指引点数据不存在, 指引点名称：%s", IndicatorUI:GetName()))
        end
        return
    end

    local TempLocation = GuidePointLocData[TargetPointKey]
    local Location = {X = 0, Y = 0, Z = 0, R = 0}

    local TargetActor = nil
    if IsNpcIndicator then
        TargetActor = self.GameState.NpcCharacterMap:Find(tonumber(IndicatorUI.GuideInfoCache.PointName))
        if TargetActor == nil then
            TargetActor = self:TryToFindGuidePointTarget(TargetPointKey)
        end
    else
        TargetActor = self:TryToFindGuidePointTarget(TargetPointKey)
    end
    
    if TempLocation ~= nil then
        if TargetActor ~= nil then
            Location.X = TempLocation.X
            Location.Y = TempLocation.Y
            Location.Z = TempLocation.Z
            Location.R = TempLocation.R or 0
        end
    end
    if TargetActor == nil then
        return
    end

    local TaskWorldMapRegionId = GuidePointLocData[TargetPointKey].SubRegionId
    if not TaskWorldMapRegionId then
        if Const.EnableTaskPrintError then
            ScreenPrint(string.format("[line:601]任务小地图地图指引点区域数据不存在, 指引点名称：%s", TargetPointKey))
        end
        return
    end

    local IconTexture = TaskUtils:GetIconTextureByTrackQuestChainType()
    if IconTexture then
        Widget.Img_GuidePoint_Icon:SetBrushResourceObject(IconTexture)
        if DataMgr.QuestChain[TrackingQuestChainId] then
            local CurQuestChainType = DataMgr.QuestChain[TrackingQuestChainId].QuestChainType
            if CurQuestChainType == 3 then
                -- Widget.Img_Range:SetBrushTintColor(UE4.UUIFunctionLibrary.StringToSlateColor("F4F4EFFF"))
            end
        end
    end
    if Location.R ~= nil and Location.R > 0 then
        self.Panel_Gamer:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.WS_Indoor:SetVisibility(UE4.ESlateVisibility.Collapsed)
        if IsValid(self.Panel_Gamer) then
            self.Panel_Gamer:AddChild(Widget)
        end
        Widget.RenderTransform.Scale.X = self.MainMap.TracePanel.RenderTransform.Scale.X * 0.75 * self.MiniMapScale --0.75的原因为需要乘以大地图缩放，改了同步改
        Widget.RenderTransform.Scale.Y = self.MainMap.TracePanel.RenderTransform.Scale.Y * 0.75 * self.MiniMapScale
    else
        if IsValid(self.MainMap.TracePanel) then
            self.MainMap.TracePanel:AddChild(Widget)
        end
    end

    self:SetIndicatorRangeMaterial(Widget, TrackingQuestChainId, false)
    self:SetIndicatorLoopColor(Widget, TrackingQuestChainId)

    local GuidePointSlot = Widget.Slot
    local function AdjustSlot(GuidePointSlot)
        GuidePointSlot:SetAlignment(FVector2D(0.5, 0.5))
        GuidePointSlot:SetAutoSize(true)
        local Anchors = FAnchors()
        Anchors.Minimum = FVector2D(0.5, 0.5)
        Anchors.Maximum = FVector2D(0.5, 0.5)
        GuidePointSlot:SetAnchors(Anchors)
        local Offset = FMargin()
        Offset.Left = 0
        Offset.Top = 0
        GuidePointSlot:SetOffsets(Offset)
    end
    AdjustSlot(GuidePointSlot)
    Widget:StopAllAnimations()

    -- self.IndicatorLocations[InUIName] = Location
    self:AddIndicatorLocation(InUIName, Location.X, Location.Y, Location.Z, Location.R)
    self:SetIndicatorsFloorIdByData(IndicatorUI, Widget, TaskWorldMapRegionId, TargetPointKey)
    self:TrySetDiffGuideIcon(Widget, TrackingQuestChainId, IndicatorUI.GuideInfoCache.QuestNode.Key)

    local LocInUI = self:TransformWorldLocToUILoc(Location.X,Location.Y) -- Location.X,Location.Y
    Widget:SetRenderTranslation(LocInUI)
    if Location.R ~= nil and Location.R > 0 then
        Widget.Img_GuidePoint_Icon:SetVisibility(UE4.ESlateVisibility.Collapsed)
        Widget.Img_Range:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        Widget.Img_Range.Slot:SetSize(FVector2D(Location.R * 2 * self.Scale, Location.R * 2 * self.Scale))
        Widget:ClearAllFunc()
    else
        local arrow = self.MainMap:NewPointArrow()
        if TargetActor.IsNPC and TargetActor:IsNPC() then
            self:AddOrDeleteMissionIndicatorArray(true, Widget)
            self:AddTrack(Widget, arrow, TargetActor)
        else
            self:AddTrack(Widget, arrow, nil)
        end
        Widget:PlayAnimation(Widget.Loop, 0, 0)
    end

    local IsRangeOrPoint = Location.R ~= nil and Location.R > 0
    self:RealChangeRangesGuideInMap(InUIName, IsRangeOrPoint)
    self:ChangeMiniMapIndicatorsFloorStyle(Widget, InUIName)
end

function Component:AddSpecialSideMiniMapIndicator(InUIName, Widget)
    local TargetPointKey = nil
    for _, Data in pairs(DataMgr.QuestChain) do
        if Data and Data.QuestNpcId == InUIName then
            TargetPointKey = Data.SpecialQuestDisplayName
            break
        end
    end
    if GuidePointLocData[TargetPointKey] == nil then
        if Const.EnableTaskPrintError then
            ScreenPrint(string.format("[line:577]任务小地图地图指引点数据不存在, 指引点名称：%s", InUIName))
        end
        return
    end

    local IndicatorUI = UIManager(self):GetUIObj("UnSpecialSide_"..tostring(InUIName))
    if not IndicatorUI then
        return
    end
    
    if IndicatorUI.IsInTaskRegion == false and IndicatorUI.SmartGuidePointInfo and IndicatorUI.SmartGuidePointInfo[2] then
        TargetPointKey = IndicatorUI.SmartGuidePointInfo[2]
    end

    local TempLocation = GuidePointLocData[TargetPointKey]
    local Location = {X = 0, Y = 0, Z = 0, R = 0}

    local TargetActor = self:TryToFindGuidePointTarget(TargetPointKey)
    if TempLocation ~= nil then
        if TargetActor ~= nil then
            Location.X = TempLocation.X
            Location.Y = TempLocation.Y
            Location.Z = TempLocation.Z
            Location.R = TempLocation.R or 0
        end
    end
    if TargetActor == nil then
        return
    end

    local TaskWorldMapRegionId = GuidePointLocData[TargetPointKey].SubRegionId
    if not TaskWorldMapRegionId then
        if Const.EnableTaskPrintError then
            ScreenPrint(string.format("[line:601]任务小地图地图指引点区域数据不存在, 指引点名称：%s", TargetPointKey))
        end
        return
    end

    local IconTexture = LoadObject('/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SpSideMission_Un.T_Gp_SpSideMission_Un')
    if IconTexture then
        Widget.Img_GuidePoint_Icon:SetBrushResourceObject(IconTexture)
    end
    if IsValid(self.MainMap.TracePanel) then
        self.MainMap.TracePanel:AddChild(Widget)
    end
    local GuidePointSlot = Widget.Slot
    local function AdjustSlot(GuidePointSlot)
        GuidePointSlot:SetAlignment(FVector2D(0.5, 0.5))
        GuidePointSlot:SetAutoSize(true)
        local Anchors = FAnchors()
        Anchors.Minimum = FVector2D(0.5, 0.5)
        Anchors.Maximum = FVector2D(0.5, 0.5)
        GuidePointSlot:SetAnchors(Anchors)
        local Offset = FMargin()
        Offset.Left = 0
        Offset.Top = 0
        GuidePointSlot:SetOffsets(Offset)
    end
    AdjustSlot(GuidePointSlot)
    Widget:StopAllAnimations()

    self:AddIndicatorLocation(InUIName, Location.X, Location.Y, Location.Z, Location.R)
    self:SetIndicatorsFloorIdByData(IndicatorUI, Widget, TaskWorldMapRegionId, TargetPointKey)
    self:ChangeMiniMapIndicatorsFloorStyle(Widget, InUIName)

    local LocInUI = self:TransformWorldLocToUILoc(Location.X,Location.Y) -- Location.X,Location.Y
    Widget:SetRenderTranslation(LocInUI)
    local arrow = self.MainMap:NewPointArrow()
    if TargetActor.IsNPC and TargetActor:IsNPC() then
        self:AddOrDeleteMissionIndicatorArray(true, Widget)
        self:AddTrack(Widget, arrow, TargetActor)
    else
        self:AddTrack(Widget, arrow, nil)
    end
end

function Component:TrySetDiffGuideIcon(Widget, InGuidePointChainId, InKey)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    local DoingQuestId = Avatar.QuestChains[InGuidePointChainId].DoingQuestId
    local Info = TaskUtils:GetQuestExtraInfo(InGuidePointChainId, DoingQuestId)
    if not Info then
        return
    end

    for _, Data in pairs(Info) do
        if Data.Node and Data.Node.Type == "BranchQuestStartNode" and IsEmptyTable(Data.DiffGuideList) == false then
            for Index, OptionElemts in pairs(Data.DiffGuideList) do
                for _, KeyList in pairs(OptionElemts) do
                    for _, KeyData in pairs(KeyList) do
                        if Data.IsUseDifftation and Widget.Img_GuidePoint_Icon then
                            if KeyData.IsShowOptional and KeyData.TargetIndicatorKey == InKey then
                                local Content = string.char(string.byte('A') + Index - 1)
                                -- local RetPath = '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Digging_'..Content..'.T_Gp_Digging_'..Content
                                local RetPath = TaskUtils:GetDiffIconOptionalByQuestChainType(InGuidePointChainId, Content)
                                Widget.Img_GuidePoint_Icon:SetBrushResourceObject(LoadObject(RetPath))
                            elseif KeyData.TargetIndicatorKey == InKey then
                                local Content = string.char(string.byte('A') + Index - 1)
                                -- local RetPath = '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SubTask_'..Content..'.T_Gp_SubTask_'..Content
                                local RetPath = TaskUtils:GetDiffIconByQuestChainType(InGuidePointChainId, Content)
                                Widget.Img_GuidePoint_Icon:SetBrushResourceObject(LoadObject(RetPath))
                            end
                        elseif Widget.Img_GuidePoint_Icon then
                            if KeyData.IsShowOptional and InKey == KeyData.TargetIndicatorKey then
                                local IconTexture = TaskUtils:GetOptinalIconTextureByQuestChainType(InGuidePointChainId)
                                Widget.Img_GuidePoint_Icon:SetBrushResourceObject(IconTexture)
                            end
                        end

                        if Data.IsUseDifftation and Widget.Img_Point then
                            if KeyData.IsShowOptional and KeyData.TargetIndicatorKey == InKey then
                                local Content = string.char(string.byte('A') + Index - 1)
                                -- local RetPath = '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Digging_'..Content..'.T_Gp_Digging_'..Content
                                local RetPath = TaskUtils:GetDiffIconOptionalByQuestChainType(InGuidePointChainId, Content)
                                Widget.Img_Point:SetBrushResourceObject(LoadObject(RetPath))
                            elseif KeyData.TargetIndicatorKey == InKey then
                                local Content = string.char(string.byte('A') + Index - 1)
                                -- local RetPath = '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SubTask_'..Content..'.T_Gp_SubTask_'..Content
                                local RetPath = TaskUtils:GetDiffIconByQuestChainType(InGuidePointChainId, Content)
                                Widget.Img_Point:SetBrushResourceObject(LoadObject(RetPath))
                            end
                        elseif Widget.Img_Point then
                            if KeyData.IsShowOptional and InKey == KeyData.TargetIndicatorKey then
                                local IconTexture = TaskUtils:GetOptinalIconTextureByQuestChainType(InGuidePointChainId)
                                Widget.Img_Point:SetBrushResourceObject(IconTexture)
                            end
                        end
                    end
                end
            end
        end
    end
end

function Component:SetIndicatorRangeMaterial(InWidget, TrackQuestChainId, IsDynEvent)
    if not IsValid(InWidget) then
        return 
    end
    if InWidget.Img_Range == nil then
        return
    end

    local Material = InWidget.Img_Range:GetDynamicMaterial()
    if not Material then
       return
    end

    if IsDynEvent and InWidget.Color_Dyn_Fill and InWidget.Color_Dyc_Stroke then
        Material:SetVectorParameterValue("Color_Fill",InWidget.Color_Dyn_Fill.SpecifiedColor)
        Material:SetVectorParameterValue("Color_Stroke", InWidget.Color_Dyc_Stroke.SpecifiedColor)
        return
    end

    if DataMgr.QuestChain[TrackQuestChainId] then
        local CurQuestChainType = DataMgr.QuestChain[TrackQuestChainId].QuestChainType
        if (CurQuestChainType == Const.MainQuestChainType or CurQuestChainType == Const.MainActivityQuestChainType) and InWidget.Color_Main_Fill and InWidget.Color_Main_Stroke then
            Material:SetVectorParameterValue("Color_Fill", InWidget.Color_Main_Fill.SpecifiedColor)
            Material:SetVectorParameterValue("Color_Stroke", InWidget.Color_Main_Stroke.SpecifiedColor)
        elseif CurQuestChainType == Const.SideQuestChainType and InWidget.Color_Side_Fill and InWidget.Color_Side_Stroke then
            Material:SetVectorParameterValue("Color_Fill", InWidget.Color_Side_Fill.SpecifiedColor)
            Material:SetVectorParameterValue("Color_Stroke", InWidget.Color_Side_Stroke.SpecifiedColor)
        elseif (CurQuestChainType == Const.SpecialSideQuestChainType or CurQuestChainType == Const.LimTimeQuestChainType) and InWidget.Color_SP_Fill and InWidget.Color_SP_Stroke then
            Material:SetVectorParameterValue("Color_Fill", InWidget.Color_SP_Fill.SpecifiedColor)
            Material:SetVectorParameterValue("Color_Stroke", InWidget.Color_SP_Stroke.SpecifiedColor)
        end
    end
end

function Component:SetIndicatorLoopColor(InWidget, TrackQuestChainId)
    if not IsValid(InWidget) then
        return 
    end
    if InWidget.vx_sq01 == nil or InWidget.vx_sq01_2 == nil or InWidget.vx_Light == nil then
        return
    end

    if DataMgr.QuestChain[TrackQuestChainId] then
        local CurQuestChainType = DataMgr.QuestChain[TrackQuestChainId].QuestChainType
        if (CurQuestChainType == Const.MainQuestChainType or CurQuestChainType == Const.MainActivityQuestChainType) and InWidget.Color_Main_Loop then
            InWidget.vx_sq01:SetColorAndOpacity(InWidget.Color_Main_Loop.SpecifiedColor)
            InWidget.vx_sq01_2:SetColorAndOpacity(InWidget.Color_Main_Loop.SpecifiedColor)
            InWidget.vx_Light:SetColorAndOpacity(InWidget.Color_Main_Loop.SpecifiedColor)
        elseif CurQuestChainType == Const.SideQuestChainType and InWidget.Color_Side_Loop then
            InWidget.vx_sq01:SetColorAndOpacity(InWidget.Color_Side_Loop.SpecifiedColor)
            InWidget.vx_sq01_2:SetColorAndOpacity(InWidget.Color_Side_Loop.SpecifiedColor)
            InWidget.vx_Light:SetColorAndOpacity(InWidget.Color_Side_Loop.SpecifiedColor)
        elseif (CurQuestChainType == Const.SpecialSideQuestChainType or CurQuestChainType == Const.LimTimeQuestChainType) and InWidget.Color_SP_Loop then
            InWidget.vx_sq01:SetColorAndOpacity(InWidget.Color_SP_Loop.SpecifiedColor)
            InWidget.vx_sq01_2:SetColorAndOpacity(InWidget.Color_SP_Loop.SpecifiedColor)
            InWidget.vx_Light:SetColorAndOpacity(InWidget.Color_SP_Loop.SpecifiedColor)
        end
    end
end

function Component:AddDynamicMiniMapIndicator(InUIName, Widget)
    local IndicatorUI = UIManager(self):GetUIObj(InUIName)
    if not IndicatorUI then
        return
    end
    local TargetPointKey = nil
    local TargetActor = nil
    local IsNpcIndicator = IndicatorUI.GuideInfoCache.PointType == "N" or IndicatorUI.GuideInfoCache.PointType == "Npc"
    if IndicatorUI.GuideInfoCache and IndicatorUI.GuideInfoCache.PointName then
        TargetPointKey = IndicatorUI.GuideInfoCache.PointName
    end
    local PointOrStaticKey = nil
    if IndicatorUI.GuideInfoCache and IndicatorUI.GuideInfoCache.PointOrStaticCreatorName then
        PointOrStaticKey = IndicatorUI.GuideInfoCache.PointOrStaticCreatorName
    end
    if GuidePointLocData[TargetPointKey] == nil and PointOrStaticKey ~= nil then
        TargetPointKey = PointOrStaticKey
    end

    local Location = GuidePointLocData[TargetPointKey]

    if TargetPointKey == nil or TargetPointKey == "" or GuidePointLocData[TargetPointKey] == nil then
        if Const.EnableTaskPrintError then
            ScreenPrint(string.format("动态事件小地图指引点数据不存在, 指引点名称 %s:", IndicatorUI:GetName()))
        end
        return
    end

    local IconTexture = LoadObject("/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_DynQuest.T_Gp_DynQuest")
    if IconTexture then
        Widget.Img_GuidePoint_Icon:SetBrushResourceObject(IconTexture)
        -- Widget.Img_Range:SetBrushTintColor(UE4.UUIFunctionLibrary.StringToSlateColor("AAAEE6FF"))
    end
    if IsNpcIndicator then
        TargetActor = self.GameState.NpcCharacterMap:Find(tonumber(IndicatorUI.GuideInfoCache.PointName))
    end

    if Location.R ~= nil and Location.R > 0 then
        self.Panel_Gamer:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.WS_Indoor:SetVisibility(UE4.ESlateVisibility.Collapsed)
        if IsValid(self.Panel_Gamer) then
            self.Panel_Gamer:AddChild(Widget)
        end
        Widget.RenderTransform.Scale.X = self.MainMap.TracePanel.RenderTransform.Scale.X * 0.75 * self.MiniMapScale --0.75的原因为需要乘以大地图缩放，改了同步改
        Widget.RenderTransform.Scale.Y = self.MainMap.TracePanel.RenderTransform.Scale.Y * 0.75 * self.MiniMapScale
    else
        if IsValid(self.MainMap.TracePanel) then
            self.MainMap.TracePanel:AddChild(Widget)
        end
    end

    self:SetIndicatorRangeMaterial(Widget, nil, true)

    local GuidePointSlot = Widget.Slot
    local function AdjustSlot(GuidePointSlot)
        GuidePointSlot:SetAlignment(FVector2D(0.5, 0.5))
        GuidePointSlot:SetAutoSize(true)
        local Anchors = FAnchors()
        Anchors.Minimum = FVector2D(0.5, 0.5)
        Anchors.Maximum = FVector2D(0.5, 0.5)
        GuidePointSlot:SetAnchors(Anchors)
        local Offset = FMargin()
        Offset.Left = 0
        Offset.Top = 0
        GuidePointSlot:SetOffsets(Offset)
    end
    AdjustSlot(GuidePointSlot)
    Widget:StopAllAnimations()

    -- self.IndicatorLocations[InUIName] = Location
    self:AddIndicatorLocation(InUIName, Location.X, Location.Y, Location.Z, Location.R)
    local TargetSubRegionId = GuidePointLocData[TargetPointKey].SubRegionId
    self:SetIndicatorsFloorIdByData(IndicatorUI, Widget, TargetSubRegionId, TargetPointKey)

    local LocInUI = self:TransformWorldLocToUILoc(Location.X,Location.Y) -- Location.X,Location.Y
    Widget:SetRenderTranslation(LocInUI)
    if Location.R ~= nil and Location.R > 0 then
        Widget.Img_GuidePoint_Icon:SetVisibility(UE4.ESlateVisibility.Collapsed)
        Widget.Img_Range:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        Widget.Img_Range.Slot:SetSize(FVector2D(Location.R * 2 * self.Scale, Location.R * 2 * self.Scale))
        Widget:ClearAllFunc()
    else
        local arrow = self.MainMap:NewPointArrow()
        if TargetActor and TargetActor.IsNPC and TargetActor:IsNPC() then
            self:AddOrDeleteMissionIndicatorArray(true, Widget)
            self:AddTrack(Widget, arrow, TargetActor)
        else
            self:AddTrack(Widget, arrow, nil)
        end
    end

    local IsRangeOrPoint = self:CheckIsNeedShowRangeStyleByLocation(Location)
    self:RealChangeRangesGuideInMap(InUIName, IsRangeOrPoint)
    -- self:ChangeMiniMapIndicatorsFloorStyle(Widget, InUIName)
end

function Component:SetMiniMapIsRangeIndicator(InUIName, IsAdd)
    local IndicatorUI = UIManager(self):GetUIObj(InUIName)
    if not IndicatorUI then
        self.IsRangeIndicator = false
        return
    end

    local TargetPointKey = nil
    local TargetActor = nil
    local IsNpcIndicator = IndicatorUI.GuideInfoCache.PointType == "N" or IndicatorUI.GuideInfoCache.PointType == "Npc"
    if IndicatorUI.GuideInfoCache and IndicatorUI.GuideInfoCache.PointName then
        TargetPointKey = IndicatorUI.GuideInfoCache.PointName
    end
    local PointOrStaticKey = nil
    if IndicatorUI.GuideInfoCache and IndicatorUI.GuideInfoCache.PointOrStaticCreatorName then
        PointOrStaticKey = IndicatorUI.GuideInfoCache.PointOrStaticCreatorName
    end
    if GuidePointLocData[TargetPointKey] == nil and PointOrStaticKey ~= nil then
        TargetPointKey = PointOrStaticKey
    end

    local Location = GuidePointLocData[TargetPointKey]
    if Location and Location.R ~= nil and Location.R > 0 then
        self.IsRangeIndicator = true
    else
        self.IsRangeIndicator = false
    end
end

function Component:TryToFindGuidePointTarget(DisplayName)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local TargetStaticCreator = nil
    TargetStaticCreator = GameState.StaticCreatorStringNameMap:FindRef(DisplayName)
    if TargetStaticCreator then
        return TargetStaticCreator
    end
    TargetStaticCreator = GameState.StaticCreatorMap:FindRef(DisplayName)
    if TargetStaticCreator then
        return TargetStaticCreator
    end

    local NewTargetPoint = GameState:GetTargetPoint(DisplayName) 
    if NewTargetPoint then
        return NewTargetPoint
    end

    local TalkSubsystem = TalkSubsystem()
	local ObservationPoint = TalkSubsystem:GetTalkInteractiveItem(DisplayName)
    if ObservationPoint then
        return ObservationPoint
    end
    return nil
end

function Component:ShowMissionIndicatorsInRegionMap()
    self:AddMainTaskGuidePointToRegionMap()
    self:AddSpecialSideTaskGuidePointToRegionMap()
    self:ChangeRegionMapIndicatorsFloorStyle()
end

function Component:ChangeMiniMapIndicatorsFloorStyle(Widget, InUIName)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    local CurRegionId = DataMgr.SubRegion[Avatar.CurrentRegionId].RegionId 
    if Widget.TaskSubRegionId and DataMgr.SubRegion[Widget.TaskSubRegionId] then
        local TaskRegionId = DataMgr.SubRegion[Widget.TaskSubRegionId].RegionId 
        if CurRegionId ~= TaskRegionId then
            Widget.Bottom:SetVisibility(UE4.ESlateVisibility.Collapsed)
            Widget.Top:SetVisibility(UE4.ESlateVisibility.Collapsed)
            return
        end
    end
    local IndicatorUI = UIManager(self):GetUIObj(InUIName)

    if IsValid(Widget) and Widget.Img_GuidePoint_Icon and Widget.Img_GuidePoint_Icon.Visibility == UE4.ESlateVisibility.Collapsed then
        Widget.Bottom:SetVisibility(UE4.ESlateVisibility.Collapsed)
        Widget.Top:SetVisibility(UE4.ESlateVisibility.Collapsed)
        return
    end

    if IsValid(Widget) and IndicatorUI then
        if self.CurrentFloorId > IndicatorUI.CurrentFloorLevelId then
            Widget.Bottom:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            Widget.Top:SetVisibility(UE4.ESlateVisibility.Collapsed)
        elseif self.CurrentFloorId < IndicatorUI.CurrentFloorLevelId then
            Widget.Bottom:SetVisibility(UE4.ESlateVisibility.Collapsed)
            Widget.Top:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        else
            if IndicatorUI.CurrentFloorLevel == UE4.FloorLevelType.FloorLevelBottom then
                Widget.Bottom:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                Widget.Top:SetVisibility(UE4.ESlateVisibility.Collapsed)
            elseif IndicatorUI.CurrentFloorLevel == UE4.FloorLevelType.FloorLevelUp then
                Widget.Bottom:SetVisibility(UE4.ESlateVisibility.Collapsed)
                Widget.Top:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            else
                Widget.Bottom:SetVisibility(UE4.ESlateVisibility.Collapsed)
                Widget.Top:SetVisibility(UE4.ESlateVisibility.Collapsed)
            end
        end
    end
end

function Component:SetMissionIndicatorsWidgetFloorStyle(InFloorId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local CurRegionId = DataMgr.SubRegion[Avatar.CurrentRegionId].RegionId 
    -- for UIName, Widget in pairs(self.IndicatorWidgets) do
    local IndicatorUI = UIManager(self):GetUIObj(InFloorId)
    local Widget = self.IndicatorWidgets[InFloorId]
    if not Widget then
        return
    end

    if Widget.TaskSubRegionId and DataMgr.SubRegion[Widget.TaskSubRegionId] then
        local TaskRegionId = DataMgr.SubRegion[Widget.TaskSubRegionId].RegionId 
        if CurRegionId ~= TaskRegionId then
            Widget.Bottom:SetVisibility(UE4.ESlateVisibility.Collapsed)
            Widget.Top:SetVisibility(UE4.ESlateVisibility.Collapsed)
            return
        end
    end
    local TargetKey = IndicatorUI.GuideInfoCache.PointOrStaticCreatorName
    if TargetKey and GuidePointLocData[TargetKey] and GuidePointLocData[TargetKey].R > 0 then
        Widget.Bottom:SetVisibility(UE4.ESlateVisibility.Collapsed)
        Widget.Top:SetVisibility(UE4.ESlateVisibility.Collapsed)
        return
    end

    if IsValid(Widget) and IndicatorUI then
        if self.CurrentFloorId > IndicatorUI.CurrentFloorLevelId then
            Widget.Bottom:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            Widget.Top:SetVisibility(UE4.ESlateVisibility.Collapsed)
        elseif self.CurrentFloorId < IndicatorUI.CurrentFloorLevelId then
            Widget.Bottom:SetVisibility(UE4.ESlateVisibility.Collapsed)
            Widget.Top:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        else
            if IndicatorUI.CurrentFloorLevel == UE4.FloorLevelType.FloorLevelBottom then
                Widget.Bottom:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                Widget.Top:SetVisibility(UE4.ESlateVisibility.Collapsed)
            elseif IndicatorUI.CurrentFloorLevel == UE4.FloorLevelType.FloorLevelUp then
                Widget.Bottom:SetVisibility(UE4.ESlateVisibility.Collapsed)
                Widget.Top:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            else
                Widget.Bottom:SetVisibility(UE4.ESlateVisibility.Collapsed)
                Widget.Top:SetVisibility(UE4.ESlateVisibility.Collapsed)
            end
        end
    end
    -- end
end

function Component:ChangeRegionMapIndicatorsFloorStyle()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local CurRegionId = DataMgr.SubRegion[Avatar.CurrentRegionId].RegionId 
    for UIName, Widget in pairs(self.IndicatorWidgets) do
        local IndicatorUI = UIManager(self):GetUIObj(UIName)
        if Widget.TaskSubRegionId and DataMgr.SubRegion[Widget.TaskSubRegionId] then
            local TaskRegionId = DataMgr.SubRegion[Widget.TaskSubRegionId].RegionId 
            if CurRegionId ~= TaskRegionId then
                Widget.Bottom:SetVisibility(UE4.ESlateVisibility.Collapsed)
                Widget.Top:SetVisibility(UE4.ESlateVisibility.Collapsed)
                goto continue
            end
        end
        if not IndicatorUI or IndicatorUI.GuideInfoCache == nil or IndicatorUI.GuideInfoCache.PointOrStaticCreatorName == nil then
            goto continue
        end

        local TargetKey = IndicatorUI.GuideInfoCache.PointOrStaticCreatorName
        if TargetKey and GuidePointLocData[TargetKey] and GuidePointLocData[TargetKey].R > 0 then
            Widget.Bottom:SetVisibility(UE4.ESlateVisibility.Collapsed)
            Widget.Top:SetVisibility(UE4.ESlateVisibility.Collapsed)
            goto continue
        end

        if IsValid(Widget) and IndicatorUI then
            if self.CurrentFloorId > IndicatorUI.CurrentFloorLevelId then
                Widget.Bottom:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                Widget.Top:SetVisibility(UE4.ESlateVisibility.Collapsed)
            elseif self.CurrentFloorId < IndicatorUI.CurrentFloorLevelId then
                Widget.Bottom:SetVisibility(UE4.ESlateVisibility.Collapsed)
                Widget.Top:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            else
                if IndicatorUI.CurrentFloorLevel == UE4.FloorLevelType.FloorLevelBottom then
                    Widget.Bottom:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                    Widget.Top:SetVisibility(UE4.ESlateVisibility.Collapsed)
                elseif IndicatorUI.CurrentFloorLevel == UE4.FloorLevelType.FloorLevelUp then
                    Widget.Bottom:SetVisibility(UE4.ESlateVisibility.Collapsed)
                    Widget.Top:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                else
                    Widget.Bottom:SetVisibility(UE4.ESlateVisibility.Collapsed)
                    Widget.Top:SetVisibility(UE4.ESlateVisibility.Collapsed)
                end
            end
        end

        ::continue::
    end
end

function Component:AddSpecialSideTaskGuidePointToRegionMap()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    for QuestChainId, QuestChainData in pairs(DataMgr.QuestChain) do
        if QuestChainData == nil or QuestChainData.SpecialQuestDisplayName == nil or
        QuestChainData.QuestNpcId == nil or QuestChainData.QuestChainType ~= Const.SpecialSideQuestChainType then
            goto continue
        end

        if Avatar.QuestChains[QuestChainId] and Avatar.QuestChains[QuestChainId].State == 1 and GuidePointLocData[QuestChainData.SpecialQuestDisplayName] 
        and GuidePointLocData[QuestChainData.SpecialQuestDisplayName].SubRegionId > 0 then
            local SubRegionId = GuidePointLocData[QuestChainData.SpecialQuestDisplayName].SubRegionId
            local TaskRegionId = DataMgr.Subregion[SubRegionId].RegionId
            if TaskRegionId == self.RegionID then
              
                local CreateSpecialSideIndicatorRegionMapWidget = function()
                    local PointPath = "/Game/UI/WBP/Map/Widget/WBP_Map_Point.WBP_Map_Point"
                    local Point = UIManager(self):CreateWidget(PointPath)
                    local SelectPath = "/Game/UI/WBP/Map/Widget/WBP_Map_Select.WBP_Map_Select"
                    local Select = UIManager(self):CreateWidget(SelectPath)
                    local IconTexture = LoadObject('/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SpSideMission.T_Gp_SpSideMission')
                    if IconTexture then
                        Point.Img_Point:SetBrushResourceObject(IconTexture)
                    end
                    return Point, Select
                end

                local IndicatorName = "NpcSpecialSideQuest_"..QuestChainData.SpecialQuestDisplayName
                local Location = GuidePointLocData[QuestChainData.SpecialQuestDisplayName] 
                local IndicatorWidget, SelectWidget = CreateSpecialSideIndicatorRegionMapWidget()
                IndicatorWidget.TargetQuestChainId = QuestChainId
                IndicatorWidget.UnLockSpecialTask = true
                IndicatorWidget.Tip_AcceptMission.Text_Accept:SetText(GText("UI_Quest_CanTakeQuest"))

                if self.IndicatorWidgets[IndicatorName] ~= nil then
                    goto continue
                end
    
                self.Panel_Gamer:AddChildToCanvas(IndicatorWidget)
                self.Panel_Gamer:AddChildToCanvas(SelectWidget)

                IndicatorWidget.Tip_AcceptMission:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
                SelectWidget:SetVisibility(ESlateVisibility.Collapsed)
                self.IndicatorWidgets[IndicatorName] = IndicatorWidget
                self.SelectWidgetTable[IndicatorName] = SelectWidget
    
                IndicatorWidget:InitGuidePoint(self, IndicatorName, self.OnSpecialGuidePointClicked, self.OnGuidePointHover, self.OnGuidePointUnHover)
                local function AdjustSlot(GuidePointSlot)
                    GuidePointSlot:SetAlignment(FVector2D(0.5, 0.5))
                    GuidePointSlot:SetAutoSize(true)
                    local Anchors = FAnchors()
                    Anchors.Minimum = FVector2D(0.5, 0.5)
                    Anchors.Maximum = FVector2D(0.5, 0.5)
                    GuidePointSlot:SetAnchors(Anchors)
                    local Offset = FMargin()
                    Offset.Left = 0
                    Offset.Top = 0
                    GuidePointSlot:SetOffsets(Offset)
                end
                AdjustSlot(IndicatorWidget.Slot)
                AdjustSlot(SelectWidget.Slot)
            
                -- self.IndicatorLocations[IndicatorName] = Location
                self:AddIndicatorLocation(IndicatorName, Location.X, Location.Y, Location.Z, Location.R)
                local LocInUI = self:TransformWorldLocToUILoc(Location.X,Location.Y) -- Location.X,Location.Y
                IndicatorWidget:SetRenderTranslation(LocInUI)
                SelectWidget:SetRenderTranslation(LocInUI)
                if IndicatorWidget:IsAnimationPlaying(IndicatorWidget.Loop) then
                    IndicatorWidget:StopAnimation(IndicatorWidget.Loop)
                end
                
                if MissionIndicatorManager.TrackingSpecialSideQuestChainId == QuestChainId then
                    IndicatorWidget:PlayAnimation(IndicatorWidget.Loop, 0, 0)
                end
            end
        end
        ::continue::
    end
end

function Component:AddMainTaskGuidePointToRegionMap()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local TrackingQuestChainId = Avatar.TrackingQuestChainId
    local TrackingQuestId = 0
    if Avatar.QuestChains[TrackingQuestChainId] then
        TrackingQuestId = Avatar.QuestChains[TrackingQuestChainId].DoingQuestId
    end
    if TrackingQuestId == 0 then
        return
    end
    local Info = TaskUtils:GetQuestDetail(TrackingQuestChainId, TrackingQuestId)
    if Info and Info.IsFairyLand then
        return
    end

    local UIObjs = MissionIndicatorManager:GetIndicatorUIObjByQuestChainIdWithType(TrackingQuestChainId, "Task")
    if IsEmptyTable(UIObjs) then
        return
    end

    for _, IndicatorUI in pairs(UIObjs) do
        local TargetPointKey = nil

        if IndicatorUI.GuideInfoCache and IndicatorUI.GuideInfoCache.PointName then
            TargetPointKey = IndicatorUI.GuideInfoCache.PointName
        end
        local PointOrStaticKey = nil
        if IndicatorUI.GuideInfoCache and IndicatorUI.GuideInfoCache.PointOrStaticCreatorName then
            PointOrStaticKey = IndicatorUI.GuideInfoCache.PointOrStaticCreatorName
        end
        if GuidePointLocData[TargetPointKey] == nil and PointOrStaticKey ~= nil then
            TargetPointKey = PointOrStaticKey
        end

        if TargetPointKey == nil or GuidePointLocData[TargetPointKey] == nil then
            if Const.EnableTaskPrintError then
                ScreenPrint(string.format("[line:782]区域地图任务指引点数据不存在, TargetPointKey：%s", TargetPointKey))
            end
            goto continue
        end

        local TempLocation = GuidePointLocData[TargetPointKey]
        local Location = {X = 0, Y = 0, Z = 0, R = 0}
      
        local TaskSubRegionId = 0
        local Info = TaskUtils:GetQuestDetail(TrackingQuestChainId, TrackingQuestId)
        if Info and Info.SubRegionId and Info.SubRegionId > 0 then
            TaskSubRegionId = Info.SubRegionId
        else
            TaskSubRegionId = GuidePointLocData[TargetPointKey].SubRegionId
        end
        if not TaskSubRegionId then
            if Const.EnableTaskPrintError then
                ScreenPrint(string.format("区域地图任务指引点数据不存在, TargetPointKey：%s", TargetPointKey))
            end
            goto continue
        end

        if DataMgr.SubRegion[TaskSubRegionId] == nil or DataMgr.SubRegion[TaskSubRegionId].RegionId == nil then
            if Const.EnableTaskPrintError then
                ScreenPrint(string.format("SubRegion表区域数据不存在, SubRegionId：%s", TaskSubRegionId))
            end
            goto continue
        end

        -- local AvatarRegionId = DataMgr.SubRegion[Avatar.CurrentRegionId].RegionId
        -- if self.RegionID == AvatarRegionId and IndicatorUI.IsInTaskRegion == false and IndicatorUI.SmartGuidePointInfo and IndicatorUI.SmartGuidePointInfo[2] then
        --     local TempPointKey = IndicatorUI.SmartGuidePointInfo[2]
        --     if GuidePointLocData[TempPointKey] and GuidePointLocData[TempPointKey].SubRegionId then
        --         TaskSubRegionId = GuidePointLocData[TempPointKey].SubRegionId
        --     end
        --     if TempPointKey and DataMgr.SubRegion[TaskSubRegionId].RegionId == AvatarRegionId and GuidePointLocData[TempPointKey] then
        --         TempLocation = GuidePointLocData[TempPointKey]
        --     elseif GuidePointLocData[TempPointKey] == nil then
        --         ScreenPrint(string.format("区域地图任务指引点数据不存在, 应该是联通指引点 TargetPointKey：%s", TempPointKey))
        --         return
        --     end
        -- end

        if TempLocation ~= nil then
            if TaskSubRegionId == Const.HomeBaseSubRegionId then --据点在特定按钮显示
                return
            else
                Location.X = TempLocation.X
                Location.Y = TempLocation.Y
                Location.Z = TempLocation.Z
                Location.R = TempLocation.R or 0
            end
        end

        if DataMgr.SubRegion[TaskSubRegionId].RegionId == self.RegionID then
            local IndicatorWidget, SelectWidget = self:CreateIndicatorRegionMapWidget()
            if self.IndicatorWidgets[IndicatorUI:GetName()] ~= nil then
                goto continue
            end

            self.Panel_Gamer:AddChildToCanvas(IndicatorWidget)
            self.Panel_Gamer:AddChildToCanvas(SelectWidget)
            SelectWidget:SetVisibility(ESlateVisibility.Collapsed)
            IndicatorWidget.TargetQuestChainId = TrackingQuestChainId
            self.IndicatorWidgets[IndicatorUI:GetName()] = IndicatorWidget
            self.SelectWidgetTable[IndicatorUI:GetName()] = SelectWidget

            self:SetIndicatorsFloorIdByData(IndicatorUI, IndicatorWidget, TaskSubRegionId, TargetPointKey)

            IndicatorWidget:InitGuidePoint(self, IndicatorUI:GetName(), self.OnGuidePointClicked, self.OnGuidePointHover, self.OnGuidePointUnHover)
            self:SetIndicatorRangeMaterial(IndicatorWidget, TrackingQuestChainId, false)
            self:TrySetDiffGuideIcon(IndicatorWidget, TrackingQuestChainId, IndicatorUI.GuideInfoCache.QuestNode.Key)

            local function AdjustSlot(GuidePointSlot)
                GuidePointSlot:SetAlignment(FVector2D(0.5, 0.5))
                GuidePointSlot:SetAutoSize(true)
                local Anchors = FAnchors()
                Anchors.Minimum = FVector2D(0.5, 0.5)
                Anchors.Maximum = FVector2D(0.5, 0.5)
                GuidePointSlot:SetAnchors(Anchors)
                local Offset = FMargin()
                Offset.Left = 0
                Offset.Top = 0
                GuidePointSlot:SetOffsets(Offset)
            end
            AdjustSlot(IndicatorWidget.Slot)
            AdjustSlot(SelectWidget.Slot)
        
            if DataMgr.SubRegion[TaskSubRegionId].DefaultQuestPoint then
                local LocData =  DataMgr.SubRegion[TaskSubRegionId].DefaultQuestPoint
                local SplitStrLoc = function (str,reps)
                    local resultStrList = {}
                    string.gsub(str,'[^'..reps..']+',function (w)
                        table.insert(resultStrList,w)end)
                    return resultStrList
                end
                local RetLoc = SplitStrLoc(LocData, ',')
                for i = 1, 3, 1 do
                    local TempNumber = tonumber(RetLoc[i])
                    RetLoc[i] = TempNumber
                end
                Location.X = RetLoc[1]
                Location.Y = RetLoc[2]
                Location.Z = RetLoc[3]
            end
        
            -- self.IndicatorLocations[IndicatorUI:GetName()] = Location
            self:AddIndicatorLocation(IndicatorUI:GetName(), Location.X, Location.Y, Location.Z, Location.R)
            local LocInUI = self:TransformWorldLocToUILoc(Location.X,Location.Y) -- Location.X,Location.Y
            IndicatorWidget:SetRenderTranslation(LocInUI)
            SelectWidget:SetRenderTranslation(LocInUI)

            self:CreateTaskRegionMapGuidPointIndicator(IndicatorUI:GetName())

            if Location.R ~= nil and Location.R > 0 then
                IndicatorWidget.Img_Point:SetVisibility(UE4.ESlateVisibility.Collapsed)
                IndicatorWidget.Img_Range:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                IndicatorWidget.Img_Range.Slot:SetSize(FVector2D(Location.R * 2 * self.Scale, Location.R * 2 * self.Scale))
                if IndicatorWidget:IsAnimationPlaying(IndicatorWidget.Loop) then
                    IndicatorWidget:StopAnimation(IndicatorWidget.Loop)
                    IndicatorWidget:ClearAllFunc()
                end
            end

        end
        ::continue::
    end
    
    -- self.Panel_Gamer:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- if self.IsInRegion and DataMgr.SubRegion[Avatar.CurrentRegionId].NotShowInRegionMap then
    --     self.Direction:SetVisibility(UE4.ESlateVisibility.Collapsed)
    --     self.Gamer:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- elseif self.IsInRegion and not DataMgr.SubRegion[Avatar.CurrentRegionId].NotShowInRegionMap then
    --     self.Direction:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    --     self.Gamer:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- else
    --     self.Direction:SetVisibility(UE4.ESlateVisibility.Collapsed)
    --     self.Gamer:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- end
end

function Component:AddMainTaskGuidePointToRegionMapForTrackingQuest(TargetKey)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local TrackingQuestChainId = Avatar.TrackingQuestChainId
    local TrackingQuestId = 0
    if Avatar.QuestChains[TrackingQuestChainId] then
        TrackingQuestId = Avatar.QuestChains[TrackingQuestChainId].DoingQuestId
    end
    if TrackingQuestId == 0 then
        return
    end
    local Info = TaskUtils:GetQuestDetail(TrackingQuestChainId, TrackingQuestId)
    if Info and Info.IsFairyLand then
        return
    end

    local UIObjs = MissionIndicatorManager:GetIndicatorUIObjByQuestChainIdWithType(TrackingQuestChainId, "Task")
    if IsEmptyTable(UIObjs) then
        return
    end

    for _, IndicatorUI in pairs(UIObjs) do
        local TargetPointKey = TargetKey
        if TargetPointKey == nil or GuidePointLocData[TargetPointKey] == nil then
            if Const.EnableTaskPrintError then
                ScreenPrint(string.format("[line:782]区域地图任务指引点数据不存在, TargetPointKey：%s", TargetPointKey))
            end
            return
        end

        local TempLocation = GuidePointLocData[TargetPointKey]
        local Location = {X = 0, Y = 0, Z = 0, R = 0}
      
        local TaskSubRegionId = GuidePointLocData[TargetPointKey].SubRegionId
        if DataMgr.SubRegion[TaskSubRegionId] == nil or DataMgr.SubRegion[TaskSubRegionId].RegionId == nil then
            if Const.EnableTaskPrintError then
                ScreenPrint(string.format("SubRegion表区域数据不存在, SubRegionId：%s", TaskSubRegionId))
            end
            return
        end
        if TempLocation ~= nil then
            -- if TaskSubRegionId == Const.HomeBaseSubRegionId then --据点在特定按钮显示
            --     return
            -- else
                Location.X = TempLocation.X
                Location.Y = TempLocation.Y
                Location.Z = TempLocation.Z
                Location.R = TempLocation.R or 0
            -- end
        end

        if DataMgr.SubRegion[TaskSubRegionId].RegionId == self.RegionID or DataMgr.SubRegion[TaskSubRegionId].DefaultQuestPoint then
            local IndicatorWidget, SelectWidget = self:CreateIndicatorRegionMapWidget()
            if self.IndicatorWidgets[IndicatorUI:GetName()] ~= nil then
                return
            end

            self.Panel_Gamer:AddChildToCanvas(IndicatorWidget)
            self.Panel_Gamer:AddChildToCanvas(SelectWidget)
            SelectWidget:SetVisibility(ESlateVisibility.Collapsed)
            IndicatorWidget.TargetQuestChainId = TrackingQuestChainId
            self.IndicatorWidgets[IndicatorUI:GetName()] = IndicatorWidget
            self.SelectWidgetTable[IndicatorUI:GetName()] = SelectWidget

            self:SetIndicatorsFloorIdByData(IndicatorUI, IndicatorWidget, TaskSubRegionId, TargetPointKey)

            IndicatorWidget:InitGuidePoint(self, IndicatorUI:GetName(), self.OnGuidePointClicked, self.OnGuidePointHover, self.OnGuidePointUnHover)
            self:SetIndicatorRangeMaterial(IndicatorWidget, TrackingQuestChainId, false)

            if DataMgr.SubRegion[TaskSubRegionId].DefaultQuestPoint then
                local LocData =  DataMgr.SubRegion[TaskSubRegionId].DefaultQuestPoint
                local SplitStrLoc = function (str,reps)
                    local resultStrList = {}
                    string.gsub(str,'[^'..reps..']+',function (w)
                        table.insert(resultStrList,w)end)
                    return resultStrList
                end
                local RetLoc = SplitStrLoc(LocData, ',')
                for i = 1, 3, 1 do
                    local TempNumber = tonumber(RetLoc[i])
                    RetLoc[i] = TempNumber
                end
                Location.X = RetLoc[1]
                Location.Y = RetLoc[2]
                Location.Z = RetLoc[3]
            end
        
            -- self.IndicatorLocations[IndicatorUI:GetName()] = Location
            self:AddIndicatorLocation(IndicatorUI:GetName(), Location.X, Location.Y, Location.Z, Location.R)
            local LocInUI = self:TransformWorldLocToUILoc(Location.X,Location.Y) -- Location.X,Location.Y
            IndicatorWidget:SetRenderTranslation(LocInUI)
            SelectWidget:SetRenderTranslation(LocInUI)

            self:CreateTaskRegionMapGuidPointIndicator(IndicatorUI:GetName())

            if Location.R ~= nil and Location.R > 0 then
                IndicatorWidget.Img_Point:SetVisibility(UE4.ESlateVisibility.Collapsed)
                IndicatorWidget.Img_Range:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                IndicatorWidget.Img_Range.Slot:SetSize(FVector2D(Location.R * 2 * self.Scale, Location.R * 2 * self.Scale))
                if IndicatorWidget:IsAnimationPlaying(IndicatorWidget.Loop) then
                    IndicatorWidget:StopAnimation(IndicatorWidget.Loop)
                    IndicatorWidget:ClearAllFunc()
                end
            end
        end
        break
    end
    
    -- self.Panel_Gamer:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- if self.IsInRegion and DataMgr.SubRegion[Avatar.CurrentRegionId].NotShowInRegionMap then
    --     self.Direction:SetVisibility(UE4.ESlateVisibility.Collapsed)
    --     self.Gamer:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- elseif self.IsInRegion and not DataMgr.SubRegion[Avatar.CurrentRegionId].NotShowInRegionMap then
    --     self.Direction:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    --     self.Gamer:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- else
    --     self.Direction:SetVisibility(UE4.ESlateVisibility.Collapsed)
    --     self.Gamer:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- end
end

function Component:SetIndicatorsFloorIdByData(Indicator, Widget, SubRegionId, TargetPointKey)
    -- local Data = DataMgr.SubRegion[SubRegionId].IndicatorsFloorIdDict
    -- Widget.TaskSubRegionId = SubRegionId
    -- if Data == nil or Data.FloorIdDict == nil then
    --     Widget.FloorId = 0
    --     return
    -- end
    -- for _, Data in pairs(Data.FloorIdDict) do
    --     local Data1 = Data[1]
    --     local Data2 = Data[2]
    --     local Min, Max = nil, nil
    --     if Data1 < Data2 then
    --         Min = Data1
    --         Max = Data2
    --     else
    --         Min = Data2
    --         Max = Data1
    --     end
    --     local FloorId = Data[3]
    --     if Z > Min and Z < Max then
    --         Widget.FloorId = FloorId
    --         return
    --     end
    -- end
    Indicator.PlayerFloorLevelId = self.CurrentFloorId
    if not GuidePointLocData[TargetPointKey] or not GuidePointLocData[TargetPointKey].FloorId then
        Widget.FloorId = 0
        return
    end
    Widget.FloorId = GuidePointLocData[TargetPointKey].FloorId
end

function Component:AddDynamicGuidePointToRegionMap()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local UIObjs = MissionIndicatorManager:GetIndicatorUIObjBySTLType("Dynamic")
    if IsEmptyTable(UIObjs) then
        return
    end

    for _, IndicatorUI in pairs(UIObjs) do
        local TargetPointKey = nil
        if IndicatorUI.GuideInfoCache and IndicatorUI.GuideInfoCache.PointName then
            TargetPointKey = IndicatorUI.GuideInfoCache.PointName
        end
        local PointOrStaticKey = nil
        if IndicatorUI.GuideInfoCache and IndicatorUI.GuideInfoCache.PointOrStaticCreatorName then
            PointOrStaticKey = IndicatorUI.GuideInfoCache.PointOrStaticCreatorName
        end
        if GuidePointLocData[TargetPointKey] == nil and PointOrStaticKey ~= nil then
            TargetPointKey = PointOrStaticKey
        end

        if TargetPointKey == nil or TargetPointKey == "" or GuidePointLocData[TargetPointKey] == nil then
            if Const.EnableTaskPrintError then
                ScreenPrint(string.format("动态事件地图指引点数据不存在, 指引点名称：%s", IndicatorUI:GetName()))
            end
            goto continue
        end

        local TempLocation = GuidePointLocData[TargetPointKey]
        local Location = {X = 0, Y = 0, Z = 0, R = 0}
        local TargetActor = self:TryToFindGuidePointTarget(TargetPointKey)
        if TempLocation ~= nil then
            if TargetActor ~= nil then
                Location.X = TempLocation.X
                Location.Y = TempLocation.Y
                Location.Z = TempLocation.Z
                Location.R = TempLocation.R or 0
            end
        end

        local TargetSubRegionId = Avatar.CurrentRegionId
        if not TargetSubRegionId or not DataMgr.SubRegion[TargetSubRegionId] then
            if Const.EnableTaskPrintError then
                ScreenPrint(string.format("动态事件地图指引点区域数据不存在, 指引点名称：%s", IndicatorUI:GetName()))
            end
            goto continue
        end
        if DataMgr.SubRegion[TargetSubRegionId].RegionId == self.RegionID then
            local Path = "/Game/UI/WBP/GuidePoint/WBP_GuidePoint_MiniMap.WBP_GuidePoint_MiniMap_C"
            local IndicatorWidget = self:CreateIndicatorMiniMapWidget()
            local IconTexture = LoadObject("/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_DynQuest.T_Gp_DynQuest")
            if IconTexture then
                IndicatorWidget.Img_GuidePoint_Icon:SetBrushResourceObject(IconTexture)
                -- IndicatorWidget.Img_Range:SetBrushTintColor(UE4.UUIFunctionLibrary.StringToSlateColor("AAAEE6FF"))
            end

            if self.IndicatorWidgets[IndicatorUI:GetName()] ~= nil then
                goto continue
            end

            self.Panel_Gamer:AddChildToCanvas(IndicatorWidget)
            local ImgXScaleX = IndicatorWidget.Img_Range.RenderTransform.Scale.X
            local ImgXScaleY = IndicatorWidget.Img_Range.RenderTransform.Scale.Y

            self.IndicatorWidgets[IndicatorUI:GetName()] = IndicatorWidget
            self:SetIndicatorsFloorIdByData(IndicatorUI, IndicatorWidget, TargetSubRegionId, TargetPointKey)

            self:SetIndicatorRangeMaterial(IndicatorWidget, nil, true)

            local GuidePointSlot = IndicatorWidget.Slot
            local function AdjustSlot(GuidePointSlot)
                GuidePointSlot:SetAlignment(FVector2D(0.5, 0.5))
                GuidePointSlot:SetAutoSize(true)
                local Anchors = FAnchors()
                Anchors.Minimum = FVector2D(0.5, 0.5)
                Anchors.Maximum = FVector2D(0.5, 0.5)
                GuidePointSlot:SetAnchors(Anchors)
                local Offset = FMargin()
                Offset.Left = 0
                Offset.Top = 0
                GuidePointSlot:SetOffsets(Offset)
            end
            AdjustSlot(GuidePointSlot)
        
            if DataMgr.SubRegion[TargetSubRegionId].DefaultQuestPoint then
                local LocData =  DataMgr.SubRegion[TargetSubRegionId].DefaultQuestPoint
                local SplitStrLoc = function (str,reps)
                    local resultStrList = {}
                    string.gsub(str,'[^'..reps..']+',function (w)
                        table.insert(resultStrList,w)end)
                    return resultStrList
                end
                local RetLoc = SplitStrLoc(LocData, ',')
                for i = 1, 3, 1 do
                    local TempNumber = tonumber(RetLoc[i])
                    RetLoc[i] = TempNumber
                end
                Location.X = RetLoc[1]
                Location.Y = RetLoc[2]
                Location.Z = RetLoc[3]
            end
        
            -- self.IndicatorLocations[IndicatorUI:GetName()] = Location
            self:AddIndicatorLocation(IndicatorUI:GetName(), Location.X, Location.Y, Location.Z, Location.R)
            local LocInUI = self:TransformWorldLocToUILoc(Location.X,Location.Y) -- Location.X,Location.Y
            IndicatorWidget:SetRenderTranslation(LocInUI)

            self:CreateDynamicRegionMapGuidPointIndicator(IndicatorUI:GetName())
            if Location.R ~= nil and Location.R > 0 then
                IndicatorWidget.Panel_Guide_Point:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                IndicatorWidget.Button_GuidePoint:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                IndicatorWidget.Img_GuidePoint_Icon:SetVisibility(UE4.ESlateVisibility.Collapsed)
                IndicatorWidget.Img_Range:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                IndicatorWidget.Img_Range.Slot:SetSize(FVector2D(Location.R * 2 * self.Scale, Location.R * 2 * self.Scale))
                if IndicatorWidget:IsAnimationPlaying(IndicatorWidget.Loop) then
                    IndicatorWidget:StopAnimation(IndicatorWidget.Loop)
                    IndicatorWidget:ClearAllFunc()
                end
            end

        end
        ::continue::
    end
    
end

function Component:CheckIsNeedShowRangeStyleByLocation(Location)
    if Location == nil or Location.R == nil or not IsValid(self.Player) then
        return false
    end
    local RealRadius = nil
    if Location and Location.R and Location.R > 0 then
        RealRadius = (Location.R + 5) / 100
    end
    -- local PlayerLoc2D = FVector2D(Player.CurrentLocation.X,  Player.CurrentLocation.Y)
    local PointLoc = FVector(Location.X,  Location.Y, Location.Z)
    local Distance = UKismetMathLibrary.Vector_Distance2D(
        self.Player.CurrentLocation, PointLoc
    ) / 100.0

    if RealRadius == nil then
        return false
    end
    
    local IsShowRange = Distance < RealRadius

    if RealRadius ~= nil and IsShowRange then
        return true
    end

    return false
end

function Component:EnterOrExitTaskRegion(WidgetName, IsEnter)
    local Widget = self.IndicatorWidgets[WidgetName]
    local TaskBar = TaskUtils:GetTaskBarWidget()
    if not Widget then
        if TaskBar and TaskBar.Panel_Tips2:GetVisibility() == UE4.ESlateVisibility.SelfHitTestInvisible then
            if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
                TaskBar:PlayAnimation(TaskBar.Tooltip_In)
            end
            TaskBar.Panel_Tips2:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end 
        return
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end 
    if TaskBar.VBox_SubTasks:GetChildrenCount() > 0 then
        local DoingQuestId = Avatar.QuestChains[Avatar.TrackingQuestChainId].DoingQuestId
        local Info = TaskUtils:GetQuestExtraInfo(Avatar.TrackingQuestChainId, DoingQuestId)
        if not Info then return {} end       
        local guidePoints = {}      
        for _, Data in pairs(Info) do
            if Data.Node and Data.Node.Type == "BranchQuestStartNode" and not IsEmptyTable(Data.DiffGuideList) then     
                for optionIndex, optionGroup in pairs(Data.DiffGuideList) do
                    local optionChar = string.char(string.byte('A') + optionIndex - 1)
                    local optionKey = "Option" .. optionChar                 
                    guidePoints[optionIndex] = {}          
                    for _, keyGroup in pairs(optionGroup) do
                        for _, keyData in pairs(keyGroup) do
                            table.insert(guidePoints[optionIndex], {
                                targetKey = keyData.TargetIndicatorKey,
                            })
                        end
                    end
                end
            end
        end
        local bSame = true
        local UIObjs = MissionIndicatorManager:GetIndicatorUIObjByQuestChainIdWithType(Avatar.TrackingQuestChainId, "Task")
        local First = nil 
        local CurKey = nil
        for _, v in pairs(UIObjs) do
            local a = v:GetName()
            if WidgetName == v:GetName() then
                CurKey = v.GuideInfoCache.QuestNode.Key
            end                 
        end
        for _, v in pairs(UIObjs) do
            if v.GuideInfoCache and v.GuideInfoCache.QuestNode.Key then
                if self:CheckIsBranchQuest(guidePoints, v.GuideInfoCache.QuestNode.Key) then
                    if v.GuideInfoCache.QuestNode.Key == CurKey then
                        bSame = false
                        break
                    end
                    -- if First == nil then
                    --     First = v.GuideInfoCache.PointOrStaticCreatorName
                    -- elseif First ~= v.GuideInfoCache.PointOrStaticCreatorName then
                    --     bSame = false
                    --     break
                    -- end
                end
            end         
        end
        if not bSame then
            local Index = self:FindBranchQuest(guidePoints, CurKey)
            if IsEnter then
                for key, value in pairs(TaskBar.VBox_SubTasks:GetAllChildren()) do
                    if key == Index then
                        value:PlayArrive()
                        break
                    end
                end
            else
                for key, value in pairs(TaskBar.VBox_SubTasks:GetAllChildren()) do
                    if key == Index then
                        value:StopArrive()
                        break
                    end
                end
            end

        end
    
    end   
    if self.CurrentFloorId ~= Widget.FloorId then
        self:RemoveTimer("TargetArea")
        if TaskBar and TaskBar.Panel_Tips2:GetVisibility() == UE4.ESlateVisibility.SelfHitTestInvisible then
            if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
                TaskBar:PlayAnimation(TaskBar.Tooltip_In)
            end
            TaskBar.Panel_Tips2:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end 
        return
    end
    if IsEnter  then
        local IsIn = self.EnterTaskRegion[WidgetName]
        if not IsIn then
            UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_Quest_TargetArea"), 2, nil, {Color = 1})
            self.EnterTaskRegion[WidgetName] = true
            self:AddTimer(0.5, function()
                if TaskBar then
                    TaskBar.Text_TextTip:SetText(GText("UI_Quest_TargetArea"))
                    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
                        TaskBar:StopAnimation(TaskBar.Tooltip_In)
                        TaskBar:PlayAnimation(TaskBar.Tooltip_Out)
                    end
                    AudioManager(self):PlayUISound(self, "event:/ui/common/reach_target_region", "", nil)
                    TaskBar:StopAnimation(TaskBar.Tooltip2_Out)
                    TaskBar:PlayAnimation(TaskBar.Tooltip2_In)
                end
            end, false, 0, "TargetArea")
        else
            if TaskBar then
                TaskBar.Text_TextTip:SetText(GText("UI_Quest_TargetArea"))
                if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
                    TaskBar:StopAnimation(TaskBar.Tooltip_In)
                    TaskBar:PlayAnimation(TaskBar.Tooltip_Out)
                end
                AudioManager(self):PlayUISound(self, "event:/ui/common/reach_target_region", "", nil)
                TaskBar:StopAnimation(TaskBar.Tooltip2_Out)
                TaskBar:PlayAnimation(TaskBar.Tooltip2_In)
            end
        end
        self:ShowOrHideGuidePointInRangeIndicator(true)
    else
        self:RemoveTimer("TargetArea")
        TaskBar.Text_TextTip:SetText(GText("UI_Quest_TargetArea"))
        TaskBar:StopAnimation(TaskBar.Tooltip2_In)
        TaskBar:PlayAnimation(TaskBar.Tooltip2_Out)

        if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
            TaskBar:StopAnimation(TaskBar.Tooltip_Out)
            TaskBar:PlayAnimation(TaskBar.Tooltip_In)
        end
        self:ShowOrHideGuidePointInRangeIndicator(false)
    end
    self:ChangeLocationDataRangeOrPoint(WidgetName, IsEnter)
end

function Component:CheckIsBranchQuest(BranchQuests, Nodekey)
    for Option, OptionInfo in pairs(BranchQuests) do
        for k, v in pairs(OptionInfo) do
            for key, value in pairs(v) do
                if value == Nodekey then
                    return true
                end
            end   
        end
    end
    return false
end

function Component:FindBranchQuest(BranchQuests, Nodekey)
     for Option, OptionInfo in pairs(BranchQuests) do
        for k, v in pairs(OptionInfo) do
            for key, value in pairs(v) do
                if value == Nodekey then
                    return Option
                end
            end   
        end
    end
end

function Component:ShowOrHideGuidePointInRangeIndicator(IsShowOrHide)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local CurQuestChainId = nil
    local CurDoingQuestId = nil
    if Avatar.InSpecialQuest then
        CurQuestChainId = ClientEventUtils:GetCurrentEvent().PreQuestChainId
    else
        CurQuestChainId = Avatar.TrackingQuestChainId
    end
    if Avatar.QuestChains[CurQuestChainId] then
        CurDoingQuestId = Avatar.QuestChains[CurQuestChainId].DoingQuestId
    end

    local QuestExtraInfo = TaskUtils:GetQuestExtraInfo(CurQuestChainId, CurDoingQuestId)
    if QuestExtraInfo then
        for _, Data in pairs(QuestExtraInfo) do --当启用了主任务下子任务更新
            if Data.Node and Data.Node.Type == "KillMonsterNode" then
                if IsShowOrHide then
                    for _, Eid in pairs(Data.Node.MonsterGuideMap) do
                        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
                        local SceneMgrComponent = GameInstance:GetSceneManager()
                        if (IsValid(SceneMgrComponent)) then
                            SceneMgrComponent:ShowOrHideSceneGuideIcon(Eid, true, "KillMonsterNodeTag") 
                        end
                    end
                else
                    for _, Eid in pairs(Data.Node.MonsterGuideMap) do
                        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
                        local SceneMgrComponent = GameInstance:GetSceneManager()
                        if (IsValid(SceneMgrComponent)) then
                            SceneMgrComponent:ShowOrHideSceneGuideIcon(Eid, false, "KillMonsterNodeTag") 
                        end
                    end
                end
            end
        end
    end
end

-- function Component:TryChangeIndicatorStyle_Lua()
--     for k, v in pairs(self.IndicatorLocations) do
--         local IsRangeOrPoint = self:CheckIsNeedShowRangeStyleByLocation(v)
--         if self.IndicatorWidgets[k] and IsValid(self.IndicatorWidgets[k]) then
--             self:RealChangeRangesGuideInMap(self.IndicatorWidgets[k], IsRangeOrPoint)
--         end
--     end
-- end

function Component:RealChangeRangesGuideInMap(WidgetName, IsRange)
    local Widget = self.IndicatorWidgets[WidgetName]
    -- local CurRangeVisibility =  Widget.Img_Range.Visibility
    -- if IsRange and CurRangeVisibility == UE4.ESlateVisibility.SelfHitTestInvisible then
    --     return
    -- elseif IsRange == false and CurRangeVisibility == UE4.ESlateVisibility.Collapsed then
    --     return
    -- end

    local function AdjustSlot(GuidePointSlot)
        GuidePointSlot:SetAlignment(FVector2D(0.5, 0.5))
        GuidePointSlot:SetAutoSize(true)
        local Anchors = FAnchors()
        Anchors.Minimum = FVector2D(0.5, 0.5)
        Anchors.Maximum = FVector2D(0.5, 0.5)
        GuidePointSlot:SetAnchors(Anchors)
        local Offset = FMargin()
        Offset.Left = 0
        Offset.Top = 0
        GuidePointSlot:SetOffsets(Offset)
    end

    if not IsRange then
        if IsValid(Widget) and self.Panel_Gamer:HasChild(Widget) then
            self.Panel_Gamer:RemoveChild(Widget)
            self.MainMap.TracePanel:AddChild(Widget)
        end
        AdjustSlot(Widget.Slot)
        Widget:SetRenderScale(FVector2D(1, 1))
        -- local arrow = self.MainMap:NewPointArrow()
        Widget.Img_GuidePoint_Icon:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        Widget.Img_Range:SetVisibility(UE4.ESlateVisibility.Collapsed)
        -- self:AddTrack(Widget, arrow, nil)
        Widget:PlayAnimation(Widget.Loop, 0, 0)

    else
        AudioManager(self):PlayUISound(self, "event:/ui/common/reach_target_region", nil, nil)
        if IsValid(Widget) and self.MainMap.TracePanel:HasChild(Widget) then
            self.MainMap.TracePanel:RemoveChild(Widget)
            self.Panel_Gamer:AddChild(Widget)
        end
        if IsValid(Widget) and self.Panel_Gamer:HasChild(Widget) then
            AdjustSlot(Widget.Slot)
            Widget.RenderTransform.Scale.X = self.MainMap.TracePanel.RenderTransform.Scale.X * 0.75 * self.MiniMapScale --0.75的原因为需要乘以大地图缩放，改了同步改
            Widget.RenderTransform.Scale.Y = self.MainMap.TracePanel.RenderTransform.Scale.Y * 0.75 * self.MiniMapScale
            self:RemoveTrack(Widget)
            Widget.Img_GuidePoint_Icon:SetVisibility(UE4.ESlateVisibility.Collapsed)
            Widget.Img_Range:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            if Widget:IsAnimationPlaying(Widget.Loop) then
                Widget:StopAnimation(Widget.Loop)
            end
            Widget:PlayAnimation(Widget.Range_In)
        end     
    end
    self:ChangeLocationDataRangeOrPoint(WidgetName, IsRange)
end

function Component:OnGuidePointClicked(InFloorId, GuidePoint)
    self:ClosePanel(true)
    if not self:CheckSelect(GuidePoint) then
        return
    end
    -- if InFloorId ~= nil then
    --     self:OnFloorBtnClicked(InFloorId, true)
    -- end
    if GuidePoint.PointWidgetName and self.SelectWidgetTable[GuidePoint.PointWidgetName] then
        self.SelectWidgetTable[GuidePoint.PointWidgetName]:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.SelectWidgetTable[GuidePoint.PointWidgetName]:PlayAnimation(self.SelectWidgetTable[GuidePoint.PointWidgetName].Click)
        GuidePoint.IsSelected = true
    end

    self:MoveMapToQuestTarget(nil, GuidePoint)
end

function Component:OnSpecialGuidePointClicked(InFloorId, GuidePoint)
    self:ClosePanel(true)
    if not self:CheckSelect(GuidePoint) then
        return
    end
    if InFloorId ~= nil then
        self:OnFloorBtnClicked(InFloorId, true)
    end
    if GuidePoint.PointWidgetName and self.SelectWidgetTable[GuidePoint.PointWidgetName] then
        self.SelectWidgetTable[GuidePoint.PointWidgetName]:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.SelectWidgetTable[GuidePoint.PointWidgetName]:PlayAnimation(self.SelectWidgetTable[GuidePoint.PointWidgetName].Click)
        GuidePoint.IsSelected = true
    end

    for k, v in pairs(self.IndicatorLocations) do
        if IsValid(self.SelectWidgetTable[k]) and self.IndicatorWidgets[k] == GuidePoint then
            self:MoveMapTo(self:TransformWorldLocToUILoc(v.X, v.Y) * -1)
            self.SelectWidgetTable[k]:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.SelectWidgetTable[k]:PlayAnimation(self.SelectWidgetTable[k].Click)
            self.IndicatorWidgets[k].IsSelected = true
            break
        end
        
    end

    self:ShowQuestDetailInRegionMap(GuidePoint.TargetQuestChainId)
end

function Component:ShowQuestDetailInRegionMap(InQuestChainId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    if self.MapTipsWidget == nil then
        local IsHasChildren = self.MainMap.CommonMapTips:HasAnyChildren()
        if IsHasChildren then
            self.MainMap.CommonMapTips:ClearChildren()
        end
        local Path = "/Game/UI/WBP/Map/Widget/WBP_Map_Task.WBP_Map_Task"
        self.MapTipsWidget = UE4.UWidgetBlueprintLibrary.Create(self, LoadClass(Path))

        self.MapTipsWidget:Init(self.MainMap)
       
        self.MainMap.CommonMapTips:AddChild(self.MapTipsWidget)
        self.MapTipsWidget:PlayAnimation(self.MapTipsWidget.Auto_In)
    else
        local VisibleStatue = self.MapTipsWidget:GetVisibility()
        if VisibleStatue == UE4.ESlateVisibility.Collapsed then
            self.MapTipsWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.MapTipsWidget:OnShow()
            self.MapTipsWidget:PlayAnimation(self.MapTipsWidget.Auto_In)
        end
    end
    self.MapTipsWidget:SetFocus()

    local IconTexture = nil
    local GrayTexture = nil

    if InQuestChainId then
        IconTexture = TaskUtils:GetIconTextureByQuestChainType(InQuestChainId)
        self.MapTipsWidget.Text_CanGetTask:SetText(GText("UI_QUEST_GETNEWQUEST"))
    else
        IconTexture = TaskUtils:GetIconTextureByTrackQuestChainType()
    end

    if Avatar and InQuestChainId then
        GrayTexture = TaskUtils:GetGrayIconTextureByQuestChainType(InQuestChainId)
        local BranchQuestNpcNameId = DataMgr.QuestChain[InQuestChainId].QuestNpcId or "UI_QUEST_UNKNOWN"
        local NpcName = nil
        if BranchQuestNpcNameId ~= "UI_QUEST_UNKNOWN" then
            NpcName = DataMgr.Npc[BranchQuestNpcNameId].UnitName
        end
        self.MapTipsWidget.Text_NPCName:SetText(GText(NpcName))
    else
        GrayTexture = TaskUtils:GetGrayIconTextureByQuestChainType(Avatar.TrackingQuestChainId)
        local BranchQuestNpcNameId = DataMgr.QuestChain[Avatar.TrackingQuestChainId].QuestNpcId or "UI_QUEST_UNKNOWN"
        local NpcName = nil
        if BranchQuestNpcNameId ~= "UI_QUEST_UNKNOWN" then
            NpcName = DataMgr.Npc[BranchQuestNpcNameId].UnitName
        end
        self.MapTipsWidget.Text_NPCName:SetText(GText(NpcName))
    end

    if IconTexture then
        self.MapTipsWidget.Img_GuidePoint_Icon:SetBrushResourceObject(IconTexture)
    end
    if GrayTexture then
        self.MapTipsWidget.Icon_TaskType:SetBrushResourceObject(GrayTexture)
    end

    local CurTrackingQuestChaindId = 0
    local TrackingQuestId = 0
    if InQuestChainId then
        CurTrackingQuestChaindId = InQuestChainId
        local STLExportInfo = DataMgr.STLExportQuestChain[CurTrackingQuestChaindId]
        if STLExportInfo and STLExportInfo.Quests then
            local TempExportQuests = {}
            for QuestId, _ in pairs(STLExportInfo.Quests) do
                table.insert(TempExportQuests, QuestId)
            end
            table.sort(TempExportQuests,  function(a, b)
                return a < b
            end)

            if Avatar.QuestChains[CurTrackingQuestChaindId] and Avatar.QuestChains[CurTrackingQuestChaindId].State ~= 1 then --特殊支线已经开始
                CurTrackingQuestChaindId = Avatar.TrackingQuestChainId
                TrackingQuestId = Avatar.QuestChains[CurTrackingQuestChaindId].DoingQuestId
            else
                for _, QuestId in pairs(TempExportQuests) do
                    if STLExportInfo.Quests[QuestId].IsPreQuest == nil  then
                        TrackingQuestId = QuestId
                        break
                    end
                end
            end
        end
    else
        CurTrackingQuestChaindId = Avatar.TrackingQuestChainId
        TrackingQuestId = Avatar.QuestChains[CurTrackingQuestChaindId].DoingQuestId
    end
     
    if DataMgr.QuestChain[CurTrackingQuestChaindId] and DataMgr.QuestChain[CurTrackingQuestChaindId].QuestChainType == Const.SpecialSideQuestChainType
    and Avatar.QuestChains[CurTrackingQuestChaindId].State == 1 then
        self.MapTipsWidget.WS_BG:SetActiveWidgetIndex(1)
        self.MapTipsWidget.Panel_Bottom:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.MapTipsWidget.Group_CanGetTask:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.MapTipsWidget.HB_NPCName:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        if DataMgr.QuestChain[CurTrackingQuestChaindId] and DataMgr.QuestChain[CurTrackingQuestChaindId].SpecialQuestDisplayName and DataMgr.QuestChain[CurTrackingQuestChaindId].QuestNpcId then
            self.MapTipsWidget.SpecialQuestDisplayName = DataMgr.QuestChain[CurTrackingQuestChaindId].SpecialQuestDisplayName
            self.MapTipsWidget.SideQuestNpcId = DataMgr.QuestChain[CurTrackingQuestChaindId].QuestNpcId
        end
    else
        self.MapTipsWidget.WS_BG:SetActiveWidgetIndex(0)
        self.MapTipsWidget.Panel_Bottom:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.MapTipsWidget.Group_CanGetTask:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.MapTipsWidget.HB_NPCName:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    self.MapTipsWidget.CurTrackingQuestChaindId = CurTrackingQuestChaindId

    if MissionIndicatorManager.TrackingSpecialSideQuestChainId == nil then
        self.MapTipsWidget.Btn_Track:SetText(GText('UI_RegionMap_Track'))
        self.MapTipsWidget.Switch_Button:SetActiveWidgetIndex(1)
    else
        if MissionIndicatorManager.TrackingSpecialSideQuestChainId ~= CurTrackingQuestChaindId then
            self.MapTipsWidget.Btn_Track:SetText(GText('UI_RegionMap_Track'))
            self.MapTipsWidget.Switch_Button:SetActiveWidgetIndex(1)
        else
            self.MapTipsWidget.Btn_Cancel_Track:SetText(GText('UI_RegionMap_Untrack'))
            self.MapTipsWidget.Switch_Button:SetActiveWidgetIndex(3)
        end
    end

    self.MapTipsWidget.Btn_Track:BindSingleEventOnClicked(self, self.OnSpecialSideTaskGuidePointTrackClick)
    self.MapTipsWidget.Btn_Cancel_Track:BindSingleEventOnClicked(self, self.OnSpecialSideTaskGuidePointUnTrackClick)

    local Info = TaskUtils:GetQuestDetail(CurTrackingQuestChaindId, TrackingQuestId)
    if not Info then
        return
    end

    for _, Data in pairs(DataMgr.QuestTab) do
        if Data and Data.QuestType == DataMgr.QuestChain[CurTrackingQuestChaindId].QuestChainType then
            self.MapTipsWidget.Text_TaskType:SetText(GText(Data.TabName))
            break
        end
    end

    if DataMgr.QuestChain[CurTrackingQuestChaindId] and DataMgr.QuestChain[CurTrackingQuestChaindId].QuestChainType == Const.SpecialSideQuestChainType
    and Avatar.QuestChains[CurTrackingQuestChaindId].State == 1 and DataMgr.QuestChain[CurTrackingQuestChaindId].QuestChainName then
        self.MapTipsWidget.Text_Title:SetText(GText(DataMgr.QuestChain[CurTrackingQuestChaindId].QuestChainName))
    else
        self.MapTipsWidget.Text_Title:SetText(GText(Info.QuestDescription))
    end
    self.MapTipsWidget.Text_Desc:SetText(GText(Info.QuestDeatil))
    self.MapTipsWidget.Text_TaskContent:SetText(GText("UI_QUEST_CONTENT"))
    self.MapTipsWidget.Text_TaskRewards:SetText(GText("UI_QUEST_REWARDS"))
    local Icon = nil
    if self.RegionIcon then
        Icon = LoadObject(self.RegionIcon)
    end
    if Icon then
        self.MapTipsWidget.Icon_Camp:SetBrushFromTexture(Icon)
    end
    local RewardList = DataMgr.QuestChain[CurTrackingQuestChaindId].QuestChainReward
    if RewardList then
        self.MapTipsWidget.TileView_Rewards:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.MapTipsWidget.TileView_Rewards:ClearListItems()
        for _, RewardId in pairs(RewardList) do
            local RewardInfo = DataMgr.Reward[RewardId]
            if RewardInfo then
                local Ids = RewardInfo.Id or {}
                local RewardCount = RewardInfo.Count or {}
                local TableName = RewardInfo.Type or {}
                for i = 1, #Ids do
                    local ItemId = Ids[i]
                    local Count = RewardUtils:GetCount(RewardCount[i])
                    local Icon = ItemUtils.GetItemIconPath(ItemId, TableName[i])
                    local Rarity = ItemUtils.GetItemRarity(ItemId, TableName[i])
                    local ItemType = TableName[i]
                    local RewardContent = TaskUtils:CreateRewardContent(
                        {Id = ItemId, Count = Count, OwnerWidget = self, Icon = Icon, Rarity = Rarity, IsShowDetails = true,ItemType = ItemType}
                    )
                    RewardContent.OnMenuOpenChangedEvents =
                    {
                        Obj = self.MapTipsWidget,
                        Callback = self.MapTipsWidget.OnRewardItemMenuAnchorChanged
                    }
                    self.MapTipsWidget.TileView_Rewards:AddItem(RewardContent)
                end
            end
        end
    else
        self.MapTipsWidget.TileView_Rewards:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self:OnPanelOpen(4)
    AudioManager(self):PlayUISound(self, "event:/ui/common/map_click_level", nil, nil)
end

function Component:OnSpecialSideTaskGuidePointTrackClick()
    self:CancelCurrentTracking()
    MissionIndicatorManager.TrackingSpecialSideQuestChainId = self.MapTipsWidget.CurTrackingQuestChaindId
    GWorld.GameInstance.TrackingPack = {CommonConst.RegionMapTrackingType.SpecialSideQuest, self.MapTipsWidget.CurTrackingQuestChaindId}
    local SpecialSideQuestWidget = nil
    for k, v in pairs(self.IndicatorWidgets) do
       if v.UnLockSpecialTask and v.TargetQuestChainId and v.TargetQuestChainId == self.MapTipsWidget.CurTrackingQuestChaindId then
            v:PlayAnimation(v.Loop, 0, 0)
            SpecialSideQuestWidget = v
       elseif v.UnLockSpecialTask and v.TargetQuestChainId and v.TargetQuestChainId == self.MapTipsWidget.CurTrackingQuestChaindId then
            v:StopAnimation(v.Loop)
       end
    end

    self.MapTipsWidget.Btn_Cancel_Track:SetText(GText('UI_RegionMap_Untrack'))
    self.MapTipsWidget.Switch_Button:SetActiveWidgetIndex(3)
    if self.MapTipsWidget.SpecialQuestDisplayName then
        MissionIndicatorManager:ActiveMissionIndicatorByRegionMap(self.MapTipsWidget.SpecialQuestDisplayName, self.MapTipsWidget.SideQuestNpcId)
        EventManager:FireEvent(EventID.OnChangeTaskIndicator, TaskUtils.MissionNpcGuideMaps)
    end

    if SpecialSideQuestWidget then
        self:CreateTrackIndicator(SpecialSideQuestWidget)
    end
    self:ClosePanel()
end

function Component:OnSpecialSideTaskGuidePointUnTrackClick()
    local SpecialSideQuestWidget = nil
    for k, v in pairs(self.IndicatorWidgets) do
       if v.UnLockSpecialTask and v.TargetQuestChainId and v.TargetQuestChainId == MissionIndicatorManager.TrackingSpecialSideQuestChainId then
            v:StopAnimation(v.Loop)
            SpecialSideQuestWidget = v
       end
    end

    if SpecialSideQuestWidget then
        self:RemoveTrackIndicator()
    end
    MissionIndicatorManager.TrackingSpecialSideQuestChainId = nil
    self.MapTipsWidget.Btn_Track:SetText(GText('UI_RegionMap_Track'))
    self.MapTipsWidget.Switch_Button:SetActiveWidgetIndex(1)
     if self.MapTipsWidget.SideQuestNpcId then
        EventManager:FireEvent(EventID.UpdateMiniMap, self.MapTipsWidget.QuestNpcId, "SpecialSide", "Delete")
        MissionIndicatorManager:ReactiveMissionIndicatorByRegionMap(self.MapTipsWidget.SideQuestNpcId)
        EventManager:FireEvent(EventID.OnChangeTaskIndicator, TaskUtils.MissionNpcGuideMaps)
    end
    self:ClosePanel()
end

function Component:OnGuidePointHover(InName)
    if InName and IsValid(self.SelectWidgetTable[InName]) then
        if IsValid(self.IndicatorWidgets[InName]) and self.IndicatorWidgets[InName].IsSelected == false then
            self.SelectWidgetTable[InName]:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.SelectWidgetTable[InName]:PlayAnimation(self.SelectWidgetTable[InName].Hover)
        end
    end
end

function Component:OnGuidePointUnHover(InName)
    if InName and IsValid(self.SelectWidgetTable[InName]) then
        if IsValid(self.IndicatorWidgets[InName]) and self.IndicatorWidgets[InName].IsSelected == false then
        self.SelectWidgetTable[InName]:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.SelectWidgetTable[InName]:PlayAnimation(self.SelectWidgetTable[InName].Out)
        end
    end
end

function Component:InitTaskArea()
    local uiManager=UIManager(self)
    local Result = uiManager:GetAllUINameByBPClass(UE4.UClass.Load(UIConst.TASKINDICATORUIBASE))
    for i = 1, Result:Length() do
        local UIName = Result:GetRef(i)
        local UIObj = uiManager:GetUIObj(UIName)
        if UIObj.TargetAreaName then
            local TargetArea=self.GameState.QuestArea[UIObj.TargetAreaName]
            if not TargetArea then
                return
            end
            local pos=TargetArea:K2_GetActorLocation()
            local location= self:TransformWorldLocToUILoc(pos.X,pos.Y)
            local scale=FVector2D(TargetArea.Radius*2*self.Scale/230)
            local area=self:NewArea()
            area:SetRenderTranslation(location)
            area:SetRenderScale(scale)
            table.insert(self.TaskArea,area)
        end
    end
end

function Component:CreateDynamicRegionMapGuidPointIndicator(InName)
    if not self.RegionMapIndicatorWidgets[InName] then
        local Widget = self:NewIndicator()
        self.RegionMapIndicatorWidgets[InName] = Widget
        if self.IndicatorWidgets[InName] and IsValid(self.IndicatorWidgets[InName]) then
            Widget:Init(self,self.ScreenSize-self.BgHeight, self.IndicatorWidgets[InName], false)
        end
        Widget.Slot:SetZOrder(3)
    end
    if self.RegionMapIndicatorWidgets[InName] and IsValid(self.RegionMapIndicatorWidgets[InName]) and self.IndicatorWidgets[InName] then
        self.RegionMapIndicatorWidgets[InName]:SetIcon(self.IndicatorWidgets[InName].Img_GuidePoint_Icon.Brush.ResourceObject)
        self.RegionMapIndicatorWidgets[InName]:OnPointerMove(self.CurrentDragOffset,self.IndicatorWidgets[InName].RenderTransform.Translation)
    end
end

function Component:CreateTaskRegionMapGuidPointIndicator(InName)
    if not self.RegionMapIndicatorWidgets[InName] then
        local Widget = self:NewIndicator()
        self.RegionMapIndicatorWidgets[InName] = Widget
        if self.IndicatorWidgets[InName] and IsValid(self.IndicatorWidgets[InName]) then
            Widget:Init(self,self.ScreenSize-self.BgHeight, self.IndicatorWidgets[InName], false)
        end
        Widget.Slot:SetZOrder(3)
    end
    if self.RegionMapIndicatorWidgets[InName] and IsValid(self.RegionMapIndicatorWidgets[InName]) and self.IndicatorWidgets[InName] then
        self.RegionMapIndicatorWidgets[InName]:SetIcon(self.IndicatorWidgets[InName].Img_Point.Brush.ResourceObject)
        self.RegionMapIndicatorWidgets[InName]:OnPointerMove(self.CurrentDragOffset,self.IndicatorWidgets[InName].RenderTransform.Translation)
    end
end

function Component:RemoveRegionMapGuidPointIndicator(InName)
    if self.RegionMapIndicatorWidgets[InName] then
        self.RegionMapIndicatorWidgets[InName]:RemoveFromParent()
        self.RegionMapIndicatorWidgets[InName] = nil
    end
end

return Component