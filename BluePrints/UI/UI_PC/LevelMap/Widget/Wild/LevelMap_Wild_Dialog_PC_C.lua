--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type LevelMap_Wild_Area01_Dialog_PC_C
local M = Class({"BluePrints.UI.BP_UIState_C"})
M._components = {"BluePrints.UI.UIComponent.TouchComponent", 
                "BluePrints.UI.UI_PC.Common.LSFocusComp",
                "BluePrints.UI.UI_PC.LevelMap.Widget.Wild.Components.TeleportPointComponent",
                "BluePrints.UI.UI_PC.LevelMap.Widget.Wild.Components.RegionPointComponent",
                "BluePrints.UI.UI_PC.LevelMap.Widget.Wild.Components.MarkPointComponent",
                "BluePrints.UI.UI_PC.LevelMap.Widget.Wild.Components.DoorIconComponent",
                "BluePrints.UI.UI_PC.LevelMap.Widget.Wild.Components.FloorBoxComponent",
                "BluePrints.UI.UI_PC.LevelMap.Widget.Wild.Components.DispatchPointComponent",
                "BluePrints.UI.UI_PC.LevelMap.Widget.Wild.Components.TaskIndicatorComponent",
                "BluePrints.UI.UI_PC.LevelMap.Widget.Wild.Components.MultiPlayerChangeCompoment",
                "BluePrints.UI.UI_PC.LevelMap.Widget.Wild.Components.DungeonCompoment",
                "BluePrints.UI.UI_PC.LevelMap.Widget.Wild.Components.MapPaneCompoment",
                "BluePrints.UI.UI_PC.LevelMap.Widget.Wild.Components.SoloTreasureComponent",
            }
local TaskUtils = require "BluePrints.UI.TaskPanel.TaskUtils"
local CommonUtils = require "Utils.CommonUtils"
local TimeUtils = require "Utils.TimeUtils"
local GuidePointLocData = require ("BluePrints.UI.TaskPanel/QuestGuidePointLocData")

-- function M:Initialize(Initializer)
--     self.Super.Initialize(self,Initializer)
-- end

--function M:PreConstruct(IsDesignTime)
--end

---------------------------------组件里实现
-- function M:InitComponentCoroutine()--初始化函数
    -- local Coroutine = CreateCoroutine(Func)--举例
    -- table.insert(self.InitCoroutines, Coroutine)
    -- coroutine.resume(Coroutine, self, #self.InitCoroutines)
-- end

-- function Component:ClearData()--清理数据
-- end

-- function Component:ShowFloor_Component(FloorId)--地图层级变化
-- end

-- function Component:OnScaleChange_Component(Percent)--地图缩放变化
-- end

-------------------------------------------

local ControlPriority={
    Normal=0,
    Inertia=1,
    Stop=2,
    Resilience=3,
    Drag=4
}

function M:Construct()
    self.Super.Construct(self)
    self:SetGamepadVirtualCursorFocusPosition(FVector2D(-1,-1))
    self.Scale=1/30
    self.WheelMaxScale=1.25
    self.WheelMinScale=0.5
    self.MapPanelCPP=self.Panel_Map
    -- self.FloorPanelCPP=self.Panel_Floor
    self.PointPanelCPP=self.Panel_Point
    -- self.SelectPanelCPP=self.Panel_Select
    self.GamerCPP=self.Gamer
    self.DirectionCPP=self.Direction
    self.IsDragging=false
    self.IsClicked=false
    self.levelLoader=UGameplayStatics.GetGameInstance(self):GetSceneManager():GetLevelLoader()
    self.Player=UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    self.IsInRegion=false
    self.CurrentConveyId=nil
    self.CurTrackDispatchId = nil
    self.ChangeAreaWidget=nil
    self.MapTipsWidget = nil
    self.GameState=UGameplayStatics.GetGameState(self)
    self.ScreenSize=UIManager(self):GetDesignedScreenSize(self)
    FVector2D.Div(self.ScreenSize,2)
    self.MaxFloorId=0
    self.CurrentFloorId=self.MaxFloorId
    self.BranchQuestMiniPointWidgets = {}
    self.BranchQuestPointWidgets = {}
    self.IndicatorWidgets = {}
    self.RegionMapIndicatorWidgets = {}
    self.DispatchPoint = {}
    self.MiniDispatchPoint = {}
    self.DispatchSelect = {}
    self.DispatchLocations = {}
    self.EnterTaskRegion = {}
    self.CurClickDispatchId = 0
    self.OriginalRegionId = 0
    self.MaxMarkNum=math.floor(DataMgr.GlobalConstant['MaxMapMarkIcon'].ConstantValue)
    self.MapDrawMistyMaterialInstance = UKismetMaterialLibrary.CreateDynamicMaterialInstance(self,self.MapDrawMistyMaterial)
    EventManager:AddEvent(EventID.EnterOrExitFloor,self,self.EnterOrExitFloor)
    EventManager:AddEvent(EventID.OnCommonTrack,self,self.OnCommonTrack)
    EventManager:AddEvent(EventID.OnSkipRegion,self,self.OnSkipRegion)
    EventManager:AddEvent(EventID.GameViewportSizeChanged,self,self.GameViewportSizeChanged)
    EventManager:AddEvent(EventID.ConditionComplete, self, self.OnConditionComplete)
    self:AddComponentEvent()
    self.MiniMapTrackQuestId = nil
    self.IsOpenDispatch = false
end

function M:AddComponentEvent()
end

function M:RemoveComponentEvent()
end

function M:Destruct()
    M.Super.Destruct(self)
    self:RemoveComponentEvent()
    EventManager:RemoveEvent(EventID.EnterOrExitFloor,self)
    EventManager:RemoveEvent(EventID.OnCommonTrack,self)
    EventManager:RemoveEvent(EventID.OnSkipRegion,self)
    EventManager:RemoveEvent(EventID.GameViewportSizeChanged,self)
    EventManager:RemoveEvent(EventID.OnDispatchExistingComplete, self)
    EventManager:RemoveEvent(EventID.ConditionComplete, self)
    self:RemoveTimer("TickRegionMapImageOpen")
    self:RemoveTimer("TickPointActivityTime")
    if not self.IsMiniMap and not self.IsEmpty then
        self:ClosePanel(true)
    end
    self:ClearData()
    if self.Indicator then
        self.Indicator:RemoveFromParent()
    end
    self:RemoveTrackIndicator()
    if self.MarkPanel then
        self.MarkPanel:RemoveFromParent()
    end
    if self.RegionInfo then
        self.RegionInfo:RemoveFromParent()
    end
    if self.LevelMap_Convey_Widget_PC then
        self.LevelMap_Convey_Widget_PC:RemoveFromParent()
    end
    if self.TureHardBoss_MapTips then
        self.TureHardBoss_MapTips:RemoveFromParent()
    end
    if self.ChangeAreaWidget then
        self.ChangeAreaWidget:RemoveFromParent()
    end
    if self.Panel_Close then
        self.Panel_Close:SetVisibility(ESlateVisibility.Collapsed)
    end
    if self.GamepadSelect then
        self.GamepadSelect:RemoveFromParent()
        self.GamepadSelect = nil
    end
    if self.InteractivePanel then
        self.InteractivePanel.WBox:ClearChildren()
    end
	self:RemoveFocusTarget("Right")


end

function M:ClearData()
    if self.FloorWidget then
        self.FloorWidget:ClearData()
    end
    if self.SelectWidgetTable then
        for _,select in pairs (self.SelectWidgetTable) do
            select:RemoveFromParent()
        end
        self.SelectWidgetTable={}
    end
    if self.MapImage then
        self.MapImage:RemoveFromParent()
        self.MapImage = nil
    end
    self:RemoveTrackIndicator()

end

-- function M:Tick(MyGeometry, InDeltaTime)
--     -- self:OnDrag()
-- end

function M:Init(IsMiniMap,RegionID, MainMap, InitCompleteFunc)
    self.IsInit = true
    self.IsMiniMap=IsMiniMap
    if DataMgr.Region[RegionID] and DataMgr.Region[RegionID].RegionMapId then
        self.RegionID = DataMgr.RegionMap[DataMgr.Region[RegionID].RegionMapId].RegionId
    else
        self.RegionID=RegionID
    end
    self.MainMap = MainMap
    self.InitComplete = false
    if self.CoroutineInitObj then
        coroutine.close(self.CoroutineInitObj)
    end
    if self.InitCoroutines then
        for _, Coroutine in pairs(self.InitCoroutines) do
            coroutine.close(Coroutine)
        end
    end
    local Avatar = GWorld:GetAvatar()
    if (self.RegionID and DataMgr.Region[self.RegionID] and Avatar.CurrentRegionId~=100104) or self.IsMiniMap then
        self.Panel_Empty:SetVisibility(ESlateVisibility.Collapsed)
        self.IsEmpty=false
    else
        self.Panel_Empty:SetVisibility(ESlateVisibility.HitTestInvisible)
        self.Panel_Gamer:SetVisibility(ESlateVisibility.Collapsed)
        self.Text_Describe:SetText(GText('UI_Banned_Des_Map'))
        self.IsEmpty=true
        -- self.MainMap.BackToWorldMap:SetVisibility(ESlateVisibility.Collapsed)
        self.MainMap.Slider_Zoom:SetVisibility(ESlateVisibility.Collapsed)
        self.MainMap.WildMapKeysShow = false
        self.MainMap.Tab:SetVisibility(ESlateVisibility.Collapsed)
        self.MainMap.Entrance_Dispatch:SetVisibility(ESlateVisibility.Collapsed)
        self.MainMap.FloorWidget:SetVisibility(ESlateVisibility.Collapsed)
        self:PlayAnimation(self.Auto_In)
        self.InitComplete = true
        if self.MainMap.Btn_Location then
            self.MainMap.Btn_Location:SetVisibility(ESlateVisibility.Collapsed)
        end
        self.MainMap.Btn_ReturnHome:SetVisibility(ESlateVisibility.Collapsed)
        self:PlayAnimation(self.WhiteBg)
        return
    end
    self.RegionData = DataMgr.Region[self.RegionID]
    if self.RegionData.IsBlackBg then
        self:PlayAnimation(self.BlackBg)
    else
        self:PlayAnimation(self.WhiteBg)
    end
    self.InitCompleteFunc = InitCompleteFunc
    self.InitCoroutines = {}
    self.CoroutineInitObj = CreateCoroutine(self.InitCoroutine)
    -- table.insert(self.InitCoroutines, self.CoroutineInitObj)
    coroutine.resume(self.CoroutineInitObj,self)
end

function M:InitCoroutine()
    if self.RegionData.RegionMapImage then
        self.MapRotation=self.RegionData.RegionRotation or 0
        local RegionMapImageClass = nil
        if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
            local MobilePath = string.gsub(self.RegionData.RegionMapImage, 'Widget/RegionMap', 'Mobile/RegionMap')
            local Name = string.sub(MobilePath, string.find(MobilePath, "%.") + 1)
            MobilePath = string.gsub(MobilePath, Name, Name .. '_Radar_M')
            local MobileClass = LoadClass(MobilePath)
            if MobileClass then
                RegionMapImageClass = MobileClass
            end
        end
        if not RegionMapImageClass then
            RegionMapImageClass = LoadClass(self.RegionData.RegionMapImage)
        end
        self.MapImage = UIManager(self):_CreateWidgetByUMGClass(RegionMapImageClass, nil, nil, nil, false)
        if self.MapImage then
            self.Panel_Map:AddChild(self.MapImage)
            self.MapImage:SetRenderTransformAngle(self.MapRotation)
            local half=UKismetMathLibrary.Vector2D_One()/2
            local anchors=self.MapImage.Slot:GetAnchors()
            anchors.Minimum=half
            anchors.Maximum=half
            self.MapImage.Slot:SetAnchors(anchors)
            self.MapImage.Slot:SetAutoSize(true)
            self.MapImage.Slot:SetAlignment(half)
            self.NewMapType = self.MapImage.Img_Map == nil--新版地图拼接
            self.AllMapImage:Clear()
            self.MapImage2LocalPos:Clear()
            self.AllMapImage:Append(UUIFunctionLibrary.GetAllImageWidget(self.MapImage))
            self.MapFog = {}
            if not self.NewMapType then
                -- self:GetTextureRealMips(self.MapImage.Img_Map.Brush.ResourceObject)
                self:CreateMapFog(self.MapImage.Img_Map, self.MaxFloorId, self.RegionID)
            else
                self.MapImageTable={}
                self.MapBoxMax=FVector2D(0,0)
                self.MapBoxMin=FVector2D(0,0)
                local mapJointOffset=nil
                local tempRotation=self.MapRotation--所有计算都需要在没有旋转MapScale=1的情况下计算,所以暂时修改MapRotation，同时把MapScale除回去
                self.MapRotation=0
                local tempScale=FVector2D()
                tempScale:Set(self.MapScale.X,self.MapScale.Y)
                if self.MapScale.X==0 or self.MapScale.Y==0 then
                    self.MapScale:Set(1,1)
                end
                for _,subRegionId in pairs(self.RegionData.IsRandom) do
                    if self.MapImage[subRegionId] then
                        local tempImage=self.MapImage[subRegionId]
                        self.MapImageTable[subRegionId]=tempImage
                        self:CreateMapFog(tempImage, self.MaxFloorId, subRegionId)
                        local subRegionData=DataMgr.SubRegion[subRegionId]
                        if subRegionData and subRegionData.SubRegionCenter and #subRegionData.SubRegionCenter>1 then
                            if not mapJointOffset then
                                mapJointOffset = tempImage.Slot:GetPosition()
                                self.MapImageCenter=FVector2D(subRegionData.SubRegionCenter[1],subRegionData.SubRegionCenter[2])
                            else
                                local position=self:TransformWorldLocToUILoc(subRegionData.SubRegionCenter[1],subRegionData.SubRegionCenter[2])/self.MapScale+mapJointOffset
                                tempImage.Slot:SetPosition(position)
                                if self.MapImage["Panel_"..subRegionId] then
                                    self.MapImage["Panel_"..subRegionId].Slot:SetPosition(position)
                                end
                            end
                            tempImage:ForceLayoutPrepass()
                            local tempPos=tempImage.Slot:GetPosition()
                            local tempSize=tempImage.Slot:GetSize()
                            self.MapBoxMax:Set(math.max(self.MapBoxMax.X,tempPos.X+tempSize.X/2),math.max(self.MapBoxMax.Y,tempPos.Y+tempSize.Y/2))
                            self.MapBoxMin:Set(math.min(self.MapBoxMin.X,tempPos.X-tempSize.X/2),math.min(self.MapBoxMin.Y,tempPos.Y-tempSize.Y/2))
                        else
                            error("子区域"..subRegionId.."缺少Grdiframe坐标！")
                        end
                    end
                end
                local centerOffset=(self.MapBoxMax+self.MapBoxMin)/-2
                self.MapImage.Main:SetRenderTranslation(centerOffset)
                self.MapImageCenter=(centerOffset*-1-mapJointOffset)/self.Scale+self.MapImageCenter
                self.MapRotation=tempRotation
                self.MapScale:Set(tempScale.X,tempScale.Y)
            end
        end
    end
    if not self.NewMapType then
        local center=FVector2D()
        if self.RegionData.RegionMapImageCenter and #self.RegionData.RegionMapImageCenter>1 then
            center:Set(self.RegionData.RegionMapImageCenter[1],self.RegionData.RegionMapImageCenter[2])
        end
        self.MapImageCenter=center
    end

    self.MapScale=FVector2D(1,1)
    self.CurrentDragOffset=FVector2D()
    self.BuildingFloor2Map={}
    self.BuildingName2Map={}
    self.BulidingState={}
    self.LimitOffset=nil
    self.DragLimitOffset=nil
    self.TaskArea={}
    self.SelectWidgetTable={}
    self.IsConveyClicked=false

    if self.IsMiniMap then
        self:InitInMiniMap()
    else
        self.MainMap.WildMapKeysShow = true
        self.MainMap.Tab:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self:InitInRegionMap()
    end
    self:InitComponentCoroutine()
    coroutine.yield()
    self:InitMapFog()
    if self.DefaultFloorId and self.FloorWidgetTable and self.FloorWidgetTable[self.DefaultFloorId] then
        self.FloorWidgetTable[self.DefaultFloorId].Btn.OnClicked:Broadcast()
        self.FloorWidgetTable[self.DefaultFloorId]:PlayAnimation(self.FloorWidgetTable[self.MaxFloorId].Click)
        self.FloorWidgetTable[self.DefaultFloorId].SizeBox:SetRenderOpacity(self.IsInRegion and 1 or 0)
        self.LastFloorWidget = self.FloorWidgetTable[self.DefaultFloorId]
    elseif self.FloorWidgetTable and CommonUtils.IsEmpty(self.FloorWidgetTable) then
        self:OnScaleChange(self.CurrentPercent)
    end
    self:InitTaskArea()
    --self.MainMap.Entrance_Dispatch:SetVisibility(ESlateVisibility.Visible)

    -- self.MainMap:UpdateWildMapKeys()
    if self.InitCompleteFunc then
        self.InitCompleteFunc()
    end
    self:InitDispatchCondition()
    self.InitComplete = true
    self.CoroutineInitObj = nil
    if self.TrackTarget then
        self:CreateTrackIndicator(self.TrackTarget)
    end

    if self.IsMiniMap then
        local Array= GWorld.GameInstance:GetSceneManager().FloorBoxArray
        if Array then 
            self.CurrentFloorId = nil
            for _,FloorBox in pairs(Array) do
                FloorBox:CheckPlayerIn()
                DebugPrint('MiniMap Wild CheckPlayerIn', FloorBox:GetName())
            end
            DebugPrint('MiniMap Wild CheckPlayerIn', self.CurrentFloorId)
        end
        if not self.CurrentFloorId then
            self:ShowFloor(self.MaxFloorId)
        end
        if self.WheelMaxScale ~= self.WheelMinScale and self.MiniMapScale then
            self.MiniMapScale = math.clamp(self.MiniMapScale, 0, 1)
            self:OnScaleChange((self.MiniMapScale - self.WheelMinScale)/(self.WheelMaxScale - self.WheelMinScale))
            self.MainMap.Scale = self.Scale * self.MapScale.X--battlemap没有地图缩放的参数，先直接乘在Scale上吧
        end
        self:MinimapDelayMapImagePos("OnScaleChange")
            if GWorld.GameInstance.TrackingPack then
                local TrackingType, Id = table.unpack(GWorld.GameInstance.TrackingPack)
                self:OnCommonTrack(TrackingType, Id, true)
            end
    end
end

function M:InitCoroutineCheck(Index)
    -- coroutine.close(self.InitCoroutines[Index])
    if not Index then
        return
    end
    self.InitCoroutines[Index] = nil
    DebugPrint('RegionMap InitCoroutineCheck', Index)
    if CommonUtils.IsEmpty(self.InitCoroutines) then
        coroutine.resume(self.CoroutineInitObj)
    end
end

--作为小地图初始化
function M:InitInMiniMap()
    self.Panel_Gamer:SetVisibility(ESlateVisibility.Collapsed)
    -- self.VX_01:SetVisibility(ESlateVisibility.Collapsed)
    -- self.NiagaraSystemWidget_122:SetVisibility(ESlateVisibility.Collapsed)
    self.Panel_Bg:SetVisibility(ESlateVisibility.Collapsed)
    self.BackgroundBlur:SetVisibility(ESlateVisibility.Collapsed)
    self:SetVisibility(ESlateVisibility.HitTestInvisible)

    if self.MapImage then
        self.MapImage:SetRenderOpacity(self.BattleMapOpacity)
    end
    self.MiniMapRad=135
    local Avatar = GWorld:GetAvatar()
    self:OnSkipRegion(Avatar.CurrentRegionId)

    self:AddTimer(0.1,function()
        if MissionIndicatorManager.TrackingSpecialSideQuestChainId and DataMgr.QuestChain[MissionIndicatorManager.TrackingSpecialSideQuestChainId] and
        DataMgr.QuestChain[MissionIndicatorManager.TrackingSpecialSideQuestChainId].SpecialQuestDisplayName and DataMgr.QuestChain[MissionIndicatorManager.TrackingSpecialSideQuestChainId].QuestNpcId then
            MissionIndicatorManager:ActiveMissionIndicatorByRegionMap(DataMgr.QuestChain[MissionIndicatorManager.TrackingSpecialSideQuestChainId].SpecialQuestDisplayName, DataMgr.QuestChain[MissionIndicatorManager.TrackingSpecialSideQuestChainId].QuestNpcId)
        end
    end)
    -- self:AddTimer(0.1,function()
    --     self.TickRegionMapImageOpen=true
    -- end)
    self.MarkPointTargetActor = nil
end

function M:MinimapDelayMapImagePos(Reason)
    if not self.MinimapDelayMapImagePosReason then
        self.MinimapDelayMapImagePosReason = {}
    end
    table.insert(self.MinimapDelayMapImagePosReason, Reason)
    DebugPrint('MinimapDelayMapImagePos', Reason)
    if #self.MinimapDelayMapImagePosReason >= 2 then
        self:AddTimer(1,function()
            DebugPrint('TickRegionMapImageOpen')
            self:GetTeleportLocalPos()
            self.ImageLocalSize = FVector2D(512, 512)--虽然很不想这么写，但是tm uniformgrid的奇怪bug太多了
            self:GetMapImageLocalPos()
            self.TickRegionMapImageOpen = true
        end)
    end
end

--作为区域地图初始化
function M:InitInRegionMap()
    AudioManager(self):PlayUISound(self, "event:/ui/common/map_switch_to_level", "", nil)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    if not self.GamepadSelect then
        self.GamepadSelect = NewObject(LoadClass('/Game/UI/WBP/Map/Widget/WBP_Map_Select.WBP_Map_Select_C'), self)
        self.Panel_Gamer:GetParent():AddChild(self.GamepadSelect)
        self:AdjustSlot(self.GamepadSelect.Slot)
    end
    -- self.Panel_Select:SetVisibility(self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
    self.GamepadSelect:SetVisibility(self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
    self.GamepadSelect:PlayAnimation(self.GamepadSelect.Normal)
    self:AddInputMethodChangedListen()
    self:SetControlPriority(ControlPriority.Normal)
    self:SetVisibility(ESlateVisibility.Visible)
    -- self.VX_01:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    -- self.NiagaraSystemWidget_122:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    if self.RegionData.RegionMapWheelScale then
        self.WheelMinScale = self.RegionData.RegionMapWheelScale[1]
        self.WheelMaxScale = self.RegionData.RegionMapWheelScale[2]
    end
    self.CurrentFloorId=self.MaxFloorId
    self.Panel_Bg:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.BackgroundBlur:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self:PlayAnimation(self.Auto_In)
    -- local MidScale = (self.WheelMinScale + self.WheelMaxScale) / 2
    -- self.MapScale=FVector2D(MidScale, MidScale)
    self.BackgroundScale=FVector2D(self.BackgroundMinScale.X,self.BackgroundMinScale.Y)
    self.MapImage:SetRenderScale(self.MapScale)
    self.MapImage:SetRenderOpacity(self.RegionMapOpacity)
    self.Bg_Map:SetRenderScale(self.BackgroundMinScale)
    self.CurrentInnerSubRegionId = nil
    self.CurrentInnerId = nil
    self.RegionIcon = nil
    self.WorldId = nil
    for _,MapData in pairs(DataMgr.WorldMap) do
        for _,regionMapId in pairs(MapData.WorldMapRegion) do
            if self.RegionID == DataMgr.RegionMap[regionMapId].RegionId then
                self.RegionIcon = MapData.RegionIcon
                self.WorldId = MapData.WorldMapId
                break
            end
        end
    end
    self.Panel_Gamer:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.WS_Indoor:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    local Avatar = GWorld:GetAvatar()
    self.IsInRegion=Avatar.CurrentRegionId and DataMgr.SubRegion[Avatar.CurrentRegionId].RegionId==self.RegionID
    if self.IsInRegion and not DataMgr.SubRegion[Avatar.CurrentRegionId].NotShowInRegionMap then
        self.WS_Indoor:SetActiveWidgetIndex(0)
        self.Direction:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Gamer:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.gamerLoc= self:TransformWorldLocToUILoc(self.Player.CurrentLocation.X,self.Player.CurrentLocation.Y)
        self.Gamer:SetRenderTranslation(self.gamerLoc)
        self.Direction:SetRenderTranslation(self.gamerLoc)
        self.Direction:SetRenderTransformAngle(self.Player:GetController().PlayerCameraManager:GetCameraRotation().Yaw+self.MapRotation+90)
        -- self.Direction:SetVisibility(ESlateVisibility.Collapsed)
        self.Gamer:SetRenderTransformAngle(self.Player.CurrentRotation.Yaw+self.MapRotation+90)
    else
        if self.IsInRegion then
            self.CurrentInnerSubRegionId = Avatar.CurrentRegionId
            self.WS_Indoor:SetActiveWidgetIndex(1)
        else
            local RegionMapId = DataMgr.Region[DataMgr.Subregion[Avatar.CurrentRegionId].RegionId].RegionMapId
            local SpecialCheck =  RegionMapId and (DataMgr.RegionMap[RegionMapId].RegionId == self.RegionID) or false
            if SpecialCheck then
                self.CurrentInnerSubRegionId = Avatar.CurrentRegionId
                self.WS_Indoor:SetActiveWidgetIndex(1)
            else
                self.WS_Indoor:SetVisibility(ESlateVisibility.Collapsed)
            end
        end
        self.gamerLoc=nil
    end
    if not self.RegionInfo then
        self.RegionInfo = self:CreateWidgetAsync("RegionMapRegionInfo", self.CoroutineInitObj)--NewObject(self.RegionInfoClass,self)
        self.MainMap.AreaInfo:AddChild(self.RegionInfo)
        self.RegionInfo.Btn_ShowUp:BindEventOnClicked(self,self.OnClickOpenRegionList)
        self.RegionInfo.Btn_Name.OnClicked:Clear()
        self.RegionInfo.Btn_Name.OnClicked:Add(self,self.OnClickOpenRegionList_Sound)
        self.RegionInfo.Impression_Dimension:UnBindEventOnClicked(self,self.OnClickDimension)
        self.RegionInfo.Impression_Dimension:BindEventOnClicked(self,self.OnClickDimension)
        self:AddLSFocusTarget(self.RegionInfo.Impression_Dimension.Key_Dimension, self.RegionInfo.Impression_Dimension, "Right", true)
        local IconTexture = TaskUtils:GetIconTextureByTrackQuestChainType()
        if IconTexture then
            self.RegionInfo.GuidePoint.Img_GuidePoint_Icon:SetBrushResourceObject(IconTexture)
        end
        self.RegionInfo:SetVisibility(ESlateVisibility.Collapsed)
    end
    if self:CheckIsTrackingQuest(self.RegionID) then
        self.RegionInfo.GuidePoint:PlayAnimation(self.RegionInfo.GuidePoint.Loop, 0, 0)
        self.RegionInfo.Panel_Guidepoint:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.RegionInfo.GuidePoint:StopAllAnimations()
        self.RegionInfo.Panel_Guidepoint:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.RegionInfo:Init(self.RegionID, self.MainMap.Spacer_Impression)
    if self.MapImage then
        self.MapImage:SetRenderTranslation(self.CurrentDragOffset)
        self.Bg_Map:SetRenderTranslation(self.CurrentDragOffset*self.BackgroundDragRatio)
    end
    self.Panel_Gamer:SetRenderTranslation(self.CurrentDragOffset)
    -- self.Panel_Floor:SetRenderTranslation(self.CurrentDragOffset)
    -- self.Panel_Select:SetRenderTranslation(self.CurrentDragOffset)
    self.Panel_Point:SetRenderTranslation(self.CurrentDragOffset)
    self.FloorWidget=self.MainMap.FloorWidget
    self.FloorWidget:SetVisibility(ESlateVisibility.SelfHitTestInvisible)

    if not self.TureHardBoss_MapTips then
        self.TureHardBoss_MapTips=self:CreateWidgetAsync("HardBossMapTips", self.CoroutineInitObj)
        self.MainMap.Convey_HardBoss:AddChild(self.TureHardBoss_MapTips)
        self.TureHardBoss_MapTips:BindToAnimationFinished(self.TureHardBoss_MapTips.Out, {self.TureHardBoss_MapTips, self.TureHardBoss_MapTips.PlayOutAnimFinished})
        self.TureHardBoss_MapTips.Common_Button_Text_PC:BindEventOnClicked(self, self.OnConveyClicked)
        self.TureHardBoss_MapTips.Parent = self
    end
    if not self.ChanllengeTips then
        local TipsBpPath="WidgetBlueprint'/Game/UI/WBP/AreaCoop/Widget/WBP_AreaCoop_MapTips.WBP_AreaCoop_MapTips'"
        self.ChanllengeTips = UIManager(self):CreateWidgetAsync(nil,self.CoroutineInitObj,TipsBpPath) --self.ChanllengeTips = self:CreateWidgetAsync("MultiPlayerChangeCompoment", self.CoroutineInitObj)
        self.MainMap.Convey_AreaCoop:AddChild(self.ChanllengeTips)
        self.ChanllengeTips:SetVisibility(ESlateVisibility.Collapsed)
        self.ChanllengeTips.Parent = self
        --self.ChanllengeTips.Common_Button_Text_PC:BindEventOnClicked(self, self.OnConveyClicked)
    end
    if self.RegionIcon then
        local Icon = LoadObject(self.RegionIcon)
        if Icon then
            self.TureHardBoss_MapTips.Icon_Camp:SetBrushResourceObject(Icon)
        end
    end
    self.TureHardBoss_MapTips:SetVisibility(ESlateVisibility.Collapsed)
    self:InitConveyWidget()
    if not self.InteractivePanel then
        self.InteractivePanel = self.MainMap.Interactive_Locate
        -- local Class = LoadClass('/Game/UI/WBP/Map/Widget/Interactive/WBP_Map_InteractiveItem.WBP_Map_InteractiveItem_C')
        local Item1 = self:CreateWidgetAsync("RegionMapSelectItem", self.CoroutineInitObj)--NewObject(Class, self)
        self.InteractivePanel.WBox:AddChild(Item1)
        Item1.Img_Icon:SetBrushResourceObject(self.Gamer.Brush.ResourceObject)
        Item1.Text_Interactive:SetText(GText('UI_RegionMap_GotoCurrentPosition'))
        Item1.Button_Area.OnClicked:Add(self,self.JumpToCurrentPosition)
        local Item2 = self:CreateWidgetAsync("RegionMapSelectItem", self.CoroutineInitObj)--NewObject(Class, self)
        self.InteractivePanel.WBox:AddChild(Item2)
        Item2.Img_Icon:SetBrushFromTexture(LoadObject('/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SideMission.T_Gp_SideMission'))
        Item2.Text_Interactive:SetText(GText('UI_RegionMap_GotoCurrentTask'))
        Item2.Button_Area.OnClicked:Add(self,self.JumpToTaskPosition)
        if self.MainMap.Btn_Location then
            self.MainMap.Btn_Location:SetText(GText("UI_RegionMap_GotoPosition"))
            self.MainMap.Btn_Location:BindEventOnClicked(self, self.OpenOptionSelect)
            self.MainMap.Btn_Location:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
    end

    -- self.BgHeight = FVector2D(0,0)
    -- if self.MainMap.DeviceInPc then
        self.BgHeight = FVector2D(0,self.MainMap.Tab_Top.Slot:GetSize().Y)
    -- else
    --     self.BgHeight = FVector2D(0,0)
    -- end
    if not self.Indicator then
        self.Indicator = self:CreateWidgetAsync("RegionMapIndicator", self.CoroutineInitObj)
        self.Panel_Floor:AddChild(self.Indicator)
        self:AdjustSlot(self.Indicator.Slot)
    end
    self.Indicator:Init(self,self.ScreenSize-self.BgHeight,self.Gamer,true)
    self.Indicator.Slot:SetZOrder(0)

    self:UpdateLimitOffset()
    if self.gamerLoc and not DataMgr.SubRegion[Avatar.CurrentRegionId].NotShowInRegionMap then
        self:MoveMapTo(self.gamerLoc * -1)
    elseif self.CurrentInnerSubRegionId then
        local HasInnerSubRegion = false
        for _,RegionPointData in pairs(DataMgr.RegionPoint) do
            if RegionPointData.TargetSubRegion then
                for _,TargetSbugRegionId in pairs(RegionPointData.TargetSubRegion) do
                    if TargetSbugRegionId == self.CurrentInnerSubRegionId then
                        self.CurrentInnerId = RegionPointData.Id
                        local Pos = self:TransformWorldLocToUILoc(RegionPointData.Pos[1], RegionPointData.Pos[2])
                        self.Gamer_Indoor:SetRenderTranslation(Pos)
                        self:MoveMapTo(Pos * -1)
                        HasInnerSubRegion = true
                        break
                    end
                end
            end
        end
        if not HasInnerSubRegion then
            self.WS_Indoor:SetVisibility(ESlateVisibility.Collapsed)
        end
    end
    -- self.MainMap:InitBackToWorldMapGuidePoint(self.RegionID)
    
    self.Panel_Close=self.MainMap.Btn_Panel_Close
    self.Panel_Close.OnClicked:Clear()
    self.Panel_Close.OnClicked:Add(self,self.OnPanelClose)
    -- self.MainMap.BackToWorldMap:SetVisibility(ESlateVisibility.Visible)
    -- self.MainMap.BackToWorldMap:Show()
    self.MainMap.Slider_Zoom:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    
    self:InitTouchLayer(self.Player, 0, 0, true)
    self:AddStaticSubTouchItem("RegionMapLayer", self.Panel_Touch, {MultiMove=self.TouchWildMapMultiMove,Down=self.OnRegionTouchDown,Move=self.OnRegionTouchMove,Up=self.OnRegionTouchUp})
    if _G.ShowRegionmapPane then
        self.Panel_Touch:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:InitConveyWidget()
    if not self.LevelMap_Convey_Widget_PC then
        self.LevelMap_Convey_Widget_PC = self:CreateWidgetAsync("RegionMapConvey", self.CoroutineInitObj)--NewObject(self.ConveyClass, self)
        self.MainMap.Convey:AddChild(self.LevelMap_Convey_Widget_PC)
        self.LevelMap_Convey_Widget_PC.Text_LockTips:SetText(GText('UI_TELEPORTPOINT_UNLOCK'))
        self.LevelMap_Convey_Widget_PC.Btn_Go:SetText(GText('UI_MECHANISM_105'))
        self.LevelMap_Convey_Widget_PC.Btn_Track:SetText(GText('UI_RegionMap_Track'))
        self.LevelMap_Convey_Widget_PC.Btn_Go:BindEventOnClicked(self,self.OnConveyClicked)
        self.LevelMap_Convey_Widget_PC.Btn_Track:BindEventOnClicked(self,self.OnConveyTrace)
        self.LevelMap_Convey_Widget_PC.Btn_Track:TryOverrideSoundFunc(self.OnTraceSound)
        self.LevelMap_Convey_Widget_PC.Btn_Go_Track:BindEventOnClicked(self, self.OnConveyGoTrace)
        self.LevelMap_Convey_Widget_PC.Btn_Go_Track:TryOverrideSoundFunc(self.OnTraceSound)
        self.LevelMap_Convey_Widget_PC.Btn_Go_Track:SetText(GText('UI_RegionMap_Track'))
        self.LevelMap_Convey_Widget_PC:InitWildMap(self)
    end
    self.LevelMap_Convey_Widget_PC:SetVisibility(ESlateVisibility.Collapsed)
end

function M:OnConveyGoTrace()
    if self.OnConveyGoTrace_Component then
        self.OnConveyGoTrace_Component(self)
    end
end

function M:InitDispatchCondition()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local ConditionId = DataMgr.UIUnlockRule['Dispatch'].ConditionId
    local Res = ConditionUtils.CheckCondition(Avatar, ConditionId)
    if not self.NormalInit then
        return
    end
    if Res then
        if self.MainMap.Entrance_Dispatch then
            self.MainMap.Entrance_Dispatch:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            SystemGuideManager:RunGuideById(2057)
        end
    else
        if self.MainMap.Entrance_Dispatch then
            self.MainMap.Entrance_Dispatch:SetVisibility(ESlateVisibility.Collapsed)
        end
    end

end
function M:OnReturnKeyDown()
    if self.ChangeAreaWidget and self.ChangeAreaWidget:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
        self:ClosePanel()
        return true
    end
    return false
end

function M:CreateMapFog(MapWidget, FloorId, SubRegionId)
    SubRegionId = self.NewMapType and SubRegionId or self.RegionID
    local MapTable = UUIFunctionLibrary.GetAllImageWidget(MapWidget):ToTable()
    if not self.MapFog[SubRegionId] then
        self.MapFog[SubRegionId] = {}
    end
    if not self.MapFog[SubRegionId][FloorId] then
        self.MapFog[SubRegionId][FloorId] = {}
    end
    local NoFog = DataMgr.Region[self.RegionID].CloseBlock
    for Index,Map in pairs(MapTable) do
        self.MapFog[SubRegionId][FloorId][Index] = Map
        local Material = nil
        if self.IsMiniMap then
            Material = UKismetMaterialLibrary.CreateDynamicMaterialInstance(self,self.MapMistyMaterialMiniMap)
        else
            Material = UKismetMaterialLibrary.CreateDynamicMaterialInstance(self,self.MapMistyMaterial)
        end
        Material:SetTextureParameterValue("Map",Map.Brush.ResourceObject)
        Material:SetScalarParameterValue("Layer",FloorId)
        Material:SetScalarParameterValue("Appear", NoFog and 0 or 1)
        Map:SetBrushFromMaterial(Material)
    end
end

function M:InitMapFog()
    if self.IsMiniMap then
        -- UKismetRenderingLibrary.ClearRenderTarget2D(self,self.MapMistyRTMiniMap)
    else
        UKismetRenderingLibrary.ClearRenderTarget2D(self,self.MapMistyRT)
        UKismetRenderingLibrary.ClearRenderTarget2D(self,self.MapMistyRT2)

        self:AddTimer(0.01,function()--小地图在OnSkipRegion，同时需要额外检查
            self:GetTeleportLocalPos()
            self:GetMapImageLocalPos()
            self.TickRegionMapImageOpen=true
        end)
    end
end

function M:UpdateMapImageFog()
    if not self.MapImage then
        return
    end
    -- self.MapPosPer=FVector2D(512,512)--单图大小
    local AddX = 100000
    local AddY = 100000
    local TempPos = nil
    for SubRegionId,table1 in pairs(self.MapFog) do
        for FloorId,table2 in pairs(table1) do
            for _,Map in pairs(table2) do
                TempPos = self.MapImage2LocalPos:Find(Map)
                AddX = math.min(AddX,TempPos.X)
                AddY = math.min(AddY,TempPos.Y)
            end
        end
    end
    self.MapImageAddVector = FVector2D(AddX,AddY)
    self.MapPosPer = USlateBlueprintLibrary.TransformVectorAbsoluteToLocal(self.MapImage:GetCachedGeometry(),FVector2D(512,512))
    self.MapPosPer = USlateBlueprintLibrary.TransformVectorLocalToAbsolute(self:GetCachedGeometry(),self.MapPosPer)
    self.MapPosPer:Set(math.abs(self.MapPosPer.X),math.abs(self.MapPosPer.Y))
    -- FVector2D.Mul(self.MapPosPer,self.MapImage.RenderTransform.Scale)
    for SubRegionId,table1 in pairs(self.MapFog) do
        for FloorId,table2 in pairs(table1) do
            table.sort(table2,function(X,Y)
                local PosX = self.MapImage2LocalPos:Find(X)
                local PosY = self.MapImage2LocalPos:Find(Y)
                if PosX.Y==PosY.Y then
                    return PosX.X < PosY.X
                else
                    return PosX.Y < PosY.Y
                end
            end)
            for Index,Map in pairs(table2) do
                local Material = Map:GetDynamicMaterial()
                local Pos = self.MapImage2LocalPos:Find(Map)
                -- if self.IsMiniMap then
                    FVector2D.Sub(Pos,self.MapImageAddVector)
                -- end
                FVector2D.Div(Pos,self.MapPosPer)
                local LinerColor = FLinearColor(Pos.X,Pos.Y,0,0)
                Material:SetVectorParameterValue("Offset",LinerColor)
                Material:SetScalarParameterValue("Rotator",self.MapRotation/360.0)

                if _G.ShowRegionmapPane and not self.IsMiniMap then
                    if not self.PaneBtns then
                        self.PaneBtns = {}
                    end
                    if not self.PaneBtns[FloorId] then
                        self.PaneBtns[FloorId] = {}
                    end
                    if not self.PaneBtns[FloorId][Index] then
                        self.PaneBtns[FloorId][Index] = {}
                    end
                    local Pane = UIManager(self):CreateWidget('/Game/UI/WBP/Map/Widget/RegionMap/WBP_Map_Pane.WBP_Map_Pane_C')
                    Map:GetParent():AddChild(Pane)
                    if UKismetMathLibrary.ClassIsChildOf(Pane.Slot:GetClass(), UUniformGridSlot:StaticClass()) then
                        Pane.Slot:SetRow(Map.Slot.Row)
                        Pane.Slot:SetColumn(Map.Slot.Column)
                        Pane.Text:SetText(Index)
                    else
                        Pane.Slot:SetAnchors(Map.Slot:GetAnchors())
                        Pane.Slot:SetPosition(Map.Slot:GetPosition())
                        Pane.Slot:SetAlignment(Map.Slot:GetAlignment())
                        Pane.Slot:SetZOrder(1)
                        Pane.Text:SetText(Index)
                    end
                    Pane:SetRenderTransformAngle(360-self.MapRotation)
                    for i = 0, 15 do
                        Pane['WBP_Map_PaneBtn_' .. i]:Init(Index, i + 1, FloorId, self)
                        self.PaneBtns[FloorId][Index][i + 1] = Pane['WBP_Map_PaneBtn_' .. i]
                    end
                end
            end
        end
    end
    local ShowFogAnimId = {}
    if not self.IsMiniMap and GWorld.GameInstance.ShowFogAnimId then
        for _,Id in pairs(GWorld.GameInstance.ShowFogAnimId) do
            ShowFogAnimId[Id] = true
        end
        local ShowId = GWorld.GameInstance.ShowFogAnimId[#GWorld.GameInstance.ShowFogAnimId]
        if self.Teleport2LocalPos[ShowId] then
            local Pos = self.Teleport2LocalPos[ShowId]
            FVector2D.Sub(Pos,self.MapImageAddVector)
            FVector2D.Div(Pos,self.MapPosPer)
            self.ShowFogPos = FLinearColor(Pos.X,Pos.Y,0,0)
        end
        -- UKismetRenderingLibrary.DrawMaterialToRenderTarget(self, self.MapMistyRT2, self.MapDrawMistyMaterial2)
    end
    local AnimId = {}
    for Id,State in pairs(self.TeleportState) do
        if State or Const.UnlockRegionTeleport then
            local ShowAnimId = ShowFogAnimId[Id] and Id or nil
            if not ShowAnimId then
                self:UpdateSingleMapFogByTeleport(DataMgr.TeleportPoint[Id].Block, true, nil)
            else
                table.insert(AnimId, ShowAnimId)
            end
        end
    end
    local Avatar = GWorld:GetAvatar()
    for Id, Data  in pairs(DataMgr.MapFogCondition) do
        if (Data.RegionId == self.RegionID and ConditionUtils.CheckCondition(Avatar, Id)) or Const.UnlockRegionTeleport then
            self:UpdateSingleMapFogByTeleport(Data.Block, true, nil)
        end
    end
    for _, ShowAnimId in pairs(AnimId) do
        if self.TeleportPoints[ShowAnimId] then
            self.TeleportPoints[ShowAnimId]:PlayAnimation(self.TeleportPoints[ShowAnimId].FirstUnlock)
        end
        self:UpdateSingleMapFogByTeleport(DataMgr.TeleportPoint[ShowAnimId].Block, true, ShowAnimId)
    end
    if self.ShowFogPos then
        local Seconds,PartialSeconds = UGameplayStatics.GetAccurateRealTime()
        local Time = Seconds + PartialSeconds
        for _,Image in pairs(self.AllMapImage) do
            local Material = Image:GetDynamicMaterial()
            if Material then
                Material:SetVectorParameterValue("Position", self.ShowFogPos)
                Material:SetScalarParameterValue("Time", Time)
            end
        end
        AudioManager(self):PlayUISound(self, "event:/ui/common/map_mist_disappear", nil, nil)
    end
    if not self.IsMinimap then
        GWorld.GameInstance.ShowFogAnimId = nil
    end
end

function M:UpdateSingleMapFogByTeleport(TeleportJson, ShowFog, ShowAnimId)
    if not TeleportJson then
        return
    end
    local Liner = nil
    if ShowAnimId and self.Teleport2LocalPos[ShowAnimId] then
        if self.IsMiniMap or not self.ShowFogPos then
            local Pos=self.Teleport2LocalPos[ShowAnimId]
            FVector2D.Sub(Pos,self.MapImageAddVector)
            FVector2D.Div(Pos,self.MapPosPer)
            Liner = FLinearColor(Pos.X,Pos.Y,0,0)
        else
            Liner = self.ShowFogPos
        end

        -- if not self.ShowFogTween then
        --     self:AddTimer(0.5,function()
        --         self:DOFloat(2,0,1,EaseType.OutCirc)
        --     end)
        -- end
        -- if not self.ShowFogMaterial then
        --     self.ShowFogMaterial = {}
        -- end
    end
    local Seconds,PartialSeconds = UGameplayStatics.GetAccurateRealTime()
    local Time = Seconds + PartialSeconds
    for _,Block in pairs(TeleportJson) do
        local SubRegionId = self.NewMapType and Block.SubRegionId or self.RegionID
        if SubRegionId and self.MapFog[SubRegionId] and self.MapFog[SubRegionId][Block.FloorId] and self.MapFog[SubRegionId][Block.FloorId][Block.Big] then
            if ShowFog then
                local MapMaterial = self.MapFog[SubRegionId][Block.FloorId][Block.Big]:GetDynamicMaterial()
                for _,Index in pairs(Block.Small) do
                    self.MapDrawMistyMaterialInstance:SetScalarParameterValue("Pos", Index-1)
                    self.MapDrawMistyMaterialInstance:SetVectorParameterValue("Offset", MapMaterial:K2_GetVectorParameterValue("Offset"))
                    self.MapDrawMistyMaterialInstance:SetScalarParameterValue("Layer",Block.FloorId)
                    if self.IsMiniMap then
                        UKismetRenderingLibrary.DrawMaterialToRenderTarget(self, self.MapMistyRTMiniMap, self.MapDrawMistyMaterialInstance)
                    else
                        if Liner then
                            UKismetRenderingLibrary.DrawMaterialToRenderTarget(self, self.MapMistyRT, self.MapDrawMistyMaterialInstance)
                        else
                            UKismetRenderingLibrary.DrawMaterialToRenderTarget(self, self.MapMistyRT2, self.MapDrawMistyMaterialInstance)
                        end
                    end
                end
                if Liner then
                    MapMaterial:SetVectorParameterValue("Position", Liner)
                    MapMaterial:SetScalarParameterValue("Time", Time)
                    -- table.insert(self.ShowFogMaterial, MapMaterial)
                end
            end
        else
            if Const.EnableTaskPrintError then
                ScreenPrint(string.format("地图迷雾block不存在，SubRegionId:%s  FloorId:%s  BlockIndex:%s", SubRegionId,Block.FloorId,Block.Big))
            end
        end
    end
end

function M:OnConditionComplete(ConditionId)
    local Avatar = GWorld:GetAvatar()
    local Data = DataMgr.MapFogCondition[ConditionId]
    if Data then
        if Data.RegionId == self.RegionID and ConditionUtils.CheckCondition(Avatar, ConditionId) then
            self:UpdateSingleMapFogByTeleport(Data.Block, true, nil)
        end
    end
end

-- function M:OnUpdateShowFog(Value)
--     for _, Material in pairs(self.ShowFogMaterial) do
--         Material:SetScalarParameterValue("Time", Value)
--     end
-- end

-- function M:OnCompleteShowFog(Value)
--     for _, Material in pairs(self.ShowFogMaterial) do
--         Material:SetScalarParameterValue("Time", Value)
--     end
--     self.ShowFogMaterial = nil
--     self.ShowFogTween = nil
--     self.ShowFogPos = nil
-- end

function M:OnSkipRegion(SubRegionId)
    if not self.IsMiniMap or not self.MapImage then
        return
    end
    if DataMgr.SubRegion[SubRegionId].NotShowInRegionMap then
        self.Panel_Point:SetVisibility(ESlateVisibility.Collapsed)
        self.MapImage:SetVisibility(ESlateVisibility.Collapsed)
        self.HideTrack = true
    else
        self.Panel_Point:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.MapImage:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.HideTrack = false
        if not self.TickRegionMapImageOpen then
            UKismetRenderingLibrary.ClearRenderTarget2D(self,self.MapMistyRTMiniMap)
            self:AddTimer(0.1,function()
                local UIManager = GWorld.GameInstance:GetGameUIManager()
                local Battle = UIManager:GetUIObj("BattleMain")
                if self.MainMap.Battle and self.MainMap.Battle:IsVisible() and self.MainMap:IsVisible() and Battle and not Battle:IsHide() then
                    self:MinimapDelayMapImagePos("OnSkipRegion")
                    self:RemoveTimer("TickRegionMapImageOpen")
                end
            end, true, 0, "TickRegionMapImageOpen")
        end
    end
    self:CheckRegionPointCancelTrack(SubRegionId)
end

function M:PlayCloseAnimation()
    self:PlayAnimation(self.Auto_Out)
    local Task = UIManager(self):GetUIObj("TaskPanel")
    if Task then
        local Objs = MissionIndicatorManager:GetAllIndicatorUIObjs()
        if not IsEmptyTable(Objs) then
            for Name, UIObj in pairs(Objs) do
                UIObj:Hide("UIPopUp")
            end
        end
    end
    -- self.MainMap.BackToWorldMap:Close()
    if self.IsEmpty then
        return
    end
    if self.RegionInfo then
        self.RegionInfo:Close()
    end
    self:ClosePanel(true)
    local Impression = UIManager(self):GetUIObj("RegionMapImpression")
    if Impression then
        Impression:Close()--做个保底，出现过未知的未关闭印象UI的情况下关闭地图情况
    end
end

--坐标换算
-- function M:TransformWorldLocToUILoc(X,Y)
--     local location=FVector2D(X,Y)
--     FVector2D.Sub(location,self.MapImageCenter)
--     FVector2D.Mul(location,self.Scale)
--     location:Set(location.Y,-location.X)
--     FVector2D.Mul(location,self.MapScale)
--     return location
-- end

function M:NewPoint()
    local point,select=self.Overridden.NewPoint(self)
    if self.IsMiniMap then
        point:SetRenderScale(self.MinimapIconScale)
    else
        point:SetRenderScale(UKismetMathLibrary.Vector2D_One())
    end
    if self.IsMiniMap then
        self.MapPointQueue:Add(point)
    end
    return point,select
end

function M:NewPointAsync(Coroutine)
    local Point = self:CreateWidgetAsync("RegionMapPoint", Coroutine)
    self.Panel_Point:AddChild(Point)
    local Select = self:CreateWidgetAsync("RegionMapSelect", Coroutine)
    self.Panel_Point:AddChild(Select)
    self:AdjustSlot(Point.Slot)
    self:AdjustSlot(Select.Slot)
    if self.IsMiniMap then
        Point:SetRenderScale(self.MinimapIconScale)
    else
        Point:SetRenderScale(UKismetMathLibrary.Vector2D_One())
    end
    Point.Slot:SetZOrder(0)
    Select.Slot:SetZOrder(10)
    Select:SetVisibility(ESlateVisibility.Collapsed)
    if self.IsMiniMap then
        self.MapPointQueue:Add(Point)
    end
    return Point, Select
end
--小地图tick优化，小地图remove时需要调用
function M:RemovePoint(Point)
    self.MapPoint2LocalPos:Remove(Point)
    self.MapPointQueue:Remove(Point)
    self.MapPointLock:Remove(Point)
end

function M:OnPanelClose()
    -- self.Panel_Close:SetVisibility(ESlateVisibility.Collapsed)
end

function M:OpenOptionSelect()
    self:OnPanelOpen(6)
    self.MainMap:OpenOptionSelect()
    local Avatar = GWorld:GetAvatar()
    local TaskCheck = false
    if Avatar then
        local TrackingQuestChainId = Avatar.TrackingQuestChainId
        local TrackingQuestId = 0
        if Avatar.QuestChains[TrackingQuestChainId] then
            TrackingQuestId = Avatar.QuestChains[TrackingQuestChainId].DoingQuestId
        end
        if TrackingQuestId ~= 0 then
            local SubRegionId =  MissionIndicatorManager:GetTargetTaskSubRegionId(TrackingQuestChainId, TrackingQuestId)
            if SubRegionId and SubRegionId ~= 0 then
                TaskCheck = true
            end
        end
        local QuestItem = self.InteractivePanel.WBox:GetChildAt(1)
        QuestItem:SetVisibility(TaskCheck and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
        if TaskCheck then
            local IconTexture = TaskUtils:GetIconTextureByTrackQuestChainType()
            if IconTexture then
                QuestItem.Img_Icon:SetBrushFromTexture(IconTexture)
            end
        end
    end
end

function M:GoToCurrentPosition()
    self:MoveMapTo(self.gamerLoc * -1)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    if self.IsMiniMap then
        return UWidgetBlueprintLibrary.Unhandled()
    end
    if not self.InitComplete then
        return UWidgetBlueprintLibrary.Handled()
    end
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    if self.IsEmpty then
        if InKeyName == "Escape" or InKeyName == UIConst.GamePadKey.FaceButtonRight then
            return UWidgetBlueprintLibrary.Unhandled()
        end
        return UWidgetBlueprintLibrary.Handled()
    end
    if InKeyName == "Escape" or InKeyName == UIConst.GamePadKey.FaceButtonRight then
        if(self.MainMap.DispatchAgentList ~= nil) then
            self.MainMap.DispatchAgentList:OnClickClose()
            self.MainMap.DispatchAgentList = nil
            return UWidgetBlueprintLibrary.Handled()
        end
        if (self.MainMap.DispatchList ~= nil and self.MainMap.DispatchDetail ~= nil) or (self.MainMap.DispatchList ~= nil) then
            if self.MainMap.DispatchList then
                self.MainMap.DispatchList:Close()             
            end
            self.MainMap.Dispatch = nil
            self.MainMap.DispatchList = nil
            return UWidgetBlueprintLibrary.Handled()
        end
        
        return self:ClosePanel() and UWidgetBlueprintLibrary.Handled() or UWidgetBlueprintLibrary.Unhandled()
    elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
        self:OnClickOpenRegionList_Sound()
        return UWidgetBlueprintLibrary.Handled()
    elseif InKeyName == UIConst.GamePadKey.FaceButtonBottom then
        if self.GamepadSelectPoint then
            -- self.GamepadSelect:PlayAnimation(self.GamepadSelect.Click)
            if self.GamepadSelectPoint.Btn_Level then
                self.GamepadSelectPoint.Btn_Level.OnClicked:Broadcast()
            elseif self.GamepadSelectPoint.GuidePoint then
                self.GamepadSelectPoint.GuidePoint.Button_GuidePoint.OnClicked:Broadcast()
                --其他按钮
            end
        elseif not self.IsInDungeon then
            self:ClosePanel(true)
            self:OpenMark(nil, self.CurrentDragOffset * -1 + self.ScreenSize)
        end
        return UWidgetBlueprintLibrary.Handled()
    elseif InKeyName == UIConst.GamePadKey.LeftThumb or InKeyName == "V" then
        if not self.LastPanelId and self.InteractivePanel then
            self:OpenOptionSelect()
            return UWidgetBlueprintLibrary.Handled()
        elseif self.IsInDungeon then
            self:GoToCurrentPosition()
            return UWidgetBlueprintLibrary.Handled()
        end
    elseif InKeyName == UIConst.GamePadKey.DPadUp then
        if next(self.FloorWidgetTable) then
            local Index = self.FloorWidget.WrapBox:GetChildIndex(self.LastFloorWidget)
            if Index ~= 0 then
                local Child = self.FloorWidget.WrapBox:GetChildAt(Index - 1)
                Child.Btn.OnClicked:Broadcast()
                Child:PlayAnimation(Child.Click)
                return UWidgetBlueprintLibrary.Handled()
            end
        end
    elseif InKeyName == UIConst.GamePadKey.DPadDown then
        if self.FloorWidgetTable and next(self.FloorWidgetTable) then
            local Index = self.FloorWidget.WrapBox:GetChildIndex(self.LastFloorWidget)
            if Index ~= self.FloorWidget.WrapBox:GetChildrenCount() - 1 then
                local Child = self.FloorWidget.WrapBox:GetChildAt(Index + 1)
                Child.Btn.OnClicked:Broadcast()
                Child:PlayAnimation(Child.Click)
                return UWidgetBlueprintLibrary.Handled()
            end
        end
    elseif InKeyName == UIConst.GamePadKey.FaceButtonLeft or InKeyName == "L" then
        if self.MainMap.Entrance_Dispatch and self.MainMap.Entrance_Dispatch:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
            self.MainMap:OnClickDispatch()
        end
        if self.KeyLocPanel then
            self.KeyLocPanel:OnOpenClick()
        end
        return UWidgetBlueprintLibrary.Handled()
    elseif InKeyName == "SpaceBar" then
        if self.MainMap.DispatchList and self.MainMap.DispatchAgentList == nil then
            self.MainMap.DispatchList:OnClickSpace()
        end
        if self.KeyLocPanel then
            self.KeyLocPanel:OnOpenClick()
        end
        return UWidgetBlueprintLibrary.Handled()
    end

    return UWidgetBlueprintLibrary.Unhandled()
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    if self.IsEmpty then
        return M.Super.OnPreviewKeyDown(self, MyGeometry, InKeyEvent)
    end
    if not self.InitComplete then
        return UWidgetBlueprintLibrary.Handled()
    end
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = false
    IsHandled = self:OnKeyDownForLSComp(MyGeometry, InKeyEvent)
    if IsHandled then
        return UIUtils.Handled
    end
    return M.Super.OnPreviewKeyDown(self, MyGeometry, InKeyEvent)
end

function M:GetBuildingNameAndId(InName)
    local index=string.find(InName,'_L%d')
    local negativeIndex=string.find(InName,'_L%-%d')
    local floorId,buildingName=nil
    if index or negativeIndex then
        local floor=nil
        if index then
            buildingName=string.sub(InName,1,index-1)
            floorId = tonumber(string.sub(InName,index+2))
        else
            buildingName=string.sub(InName,1,negativeIndex-1)
            floorId = tonumber(string.sub(InName,negativeIndex+3))*-1
        end
    end
    return buildingName,floorId
end

----------地图操作----------Start
function M:OnMouseWheel(MyGeometry,Event)
    if self.MainMap.IsPanelOpen or not self.BgHeight then
        return UWidgetBlueprintLibrary.Unhandled()
    end
    local delta=UKismetInputLibrary.PointerEvent_GetWheelDelta(Event)*0.05
    local temp=self.MapScale.X+delta
    if temp<self.WheelMinScale then
        temp=self.WheelMinScale
    elseif temp>self.WheelMaxScale then
        temp=self.WheelMaxScale
    end
    -- self:OnScaleChange((temp-self.WheelMinScale)/(self.WheelMaxScale-self.WheelMinScale))
    self.MainMap:OnMouseWheelTurned((temp-self.WheelMinScale)/(self.WheelMaxScale-self.WheelMinScale))
    return UWidgetBlueprintLibrary.Handled()
end

function M:OnScaleChange(Percent)
    if not Percent or not self.MapImage then
        return
    end
    if self.SlideTween~=nil then
        self:StopSlide(ControlPriority.Stop)
    end
    self.CurrentPercent=Percent
    local temp=self.WheelMinScale+(self.WheelMaxScale-self.WheelMinScale)*Percent
    local TargetOffset = self.CurrentDragOffset * temp / self.MapScale.X
    self.MapScale:Set(temp,temp)
    self.MapImage:SetRenderScale(self.MapScale)
    if not self.IsMiniMap then
        self.BackgroundScale:Set(self.BackgroundMaxScale.X,self.BackgroundMaxScale.Y)
        FVector2D.Sub(self.BackgroundScale,self.BackgroundMinScale)
        self.BackgroundScale=self.BackgroundScale*Percent
        FVector2D.Add(self.BackgroundScale,self.BackgroundMinScale)
        self.Bg_Map:SetRenderScale(self.BackgroundScale)
        self:UpdateLimitOffset()
    end

    if self.CurrentInnerSubRegionId and self.CurrentInnerId then
        if self.RegionPointLocation[self.CurrentInnerId] then
            self.Gamer_Indoor:SetRenderTranslation(self:TransformWorldLocToUILoc(self.RegionPointLocation[self.CurrentInnerId].X,self.RegionPointLocation[self.CurrentInnerId].Y))
        end
    elseif self.IsInRegion then
        self.gamerLoc= self:TransformWorldLocToUILoc(self.Player.CurrentLocation.X,self.Player.CurrentLocation.Y)
        self.Gamer:SetRenderTranslation(self.gamerLoc)
        self.Direction:SetRenderTranslation(self.gamerLoc)
    end

    self:OnScaleChange_Component(Percent)
    if not self.IsMiniMap then
        self:MoveMapTo(TargetOffset)
    end
end

function M:GetMapIconVisible(IconType, Percent)
    local Data = DataMgr.RegionMapIconRange[IconType]
    if not Data or not Data.IconScaleInterval or not #Data.IconScaleInterval == 2 then 
        return true
    end
    return Percent*100 >= Data.IconScaleInterval[1] and Percent <= Data.IconScaleInterval[2]
end

function M:UpdateLimitOffset()
    if self.NewMapType then
        self.LimitOffset=self.MapBoxMax-self.MapBoxMin
        if self.MapRotation ~=0 and self.MapRotation ~= 180 then
            self.LimitOffset:Set(self.LimitOffset.Y,self.LimitOffset.X)
        end
    else
        self.MapImage.Img_Map:ForceLayoutPrepass()
        self.LimitOffset=self.MapImage.Img_Map.Slot:GetSize()
    end
    FVector2D.Mul(self.LimitOffset,self.MapScale)
    FVector2D.Div(self.LimitOffset,2)
    -- FVector2D.Sub(self.LimitOffset,self.ScreenSize)
    if self.LimitOffset.X<0 then
        self.LimitOffset:Set(-self.LimitOffset.X,self.LimitOffset.Y)
    end
    if self.LimitOffset.Y<0 then
        self.LimitOffset:Set(self.LimitOffset.X,-self.LimitOffset.Y)
    end
    FVector2D.Add(self.LimitOffset,self.BgHeight)

    self:AddTimer(0.01,function()
        self.DragLimitOffset=UIManager(self):GetWidgetRenderSize(self.Bg_Map)
        FVector2D.Mul(self.DragLimitOffset,self.BackgroundScale)
        self.DragLimitOffset=self.DragLimitOffset/2
        -- FVector2D.Sub(self.DragLimitOffset,self.ScreenSize)
        self.DragLimitOffset=self.DragLimitOffset*self.BackgroundDragRatio--算的不完全准，不过先用着
    end)
end

function M:OnRegionTouchDown(Index, StartPos)
    self:OnPointerDown(nil,nil)
end

function M:OnRegionTouchMove(TouchFingerCount, Index, LastPos, TotalDeltaDis, LastDeltaDis)
    self:OnPointerMove(nil,self.CurrentTouchingGestureEvent[Index + 1])

end

function M:OnRegionTouchUp(Index, WidgetLocalPos, LastWidgetTouchPos, EndTouchPos, TotalDeltaDis)
    self:OnPointerUp(nil,self.CurrentTouchingGestureEvent[Index + 1])
end

function M:OnPointerDown(MyGeometry,Event)
    -- self.MouseLoc = UWidgetLayoutLibrary.GetMousePositionOnViewport(self)
    if self.IsEmpty then
        return UWidgetBlueprintLibrary.Unhandled()
    end
    if not self.InitComplete then
        return UWidgetBlueprintLibrary.Handled()
    end
    self.IsDragging=true
    self.IsClicked=true
    if self.SlideTween~=nil then
        self:StopSlide(ControlPriority.Stop)
    end
    self.CacheDragOffset={}
    return UWidgetBlueprintLibrary.Handled()
end

function M:OnPointerMove(MyGeometry,Event)
    if not self.IsDragging then
        return UWidgetBlueprintLibrary.Unhandled()
    end
    if not self.InitComplete then
        return UWidgetBlueprintLibrary.Handled()
    end
    local deltaLoc=UKismetInputLibrary.PointerEvent_GetCursorDelta(Event)
    if not UKismetMathLibrary.EqualEqual_Vector2DVector2D(deltaLoc,UKismetMathLibrary.Vector2D_Zero(),0.001) then
        if self.IsClicked and not self.IsOpenDispatch then
            self:ClosePanel()
        end
        self.IsClicked=false
        self:UpdateMapDelta(deltaLoc)
        table.insert(self.CacheDragOffset,{X=self.CurrentDragOffset.X,Y=self.CurrentDragOffset.Y,Time=UGameplayStatics.GetRealTimeSeconds(self)})
        if #self.CacheDragOffset>5 then
            table.remove(self.CacheDragOffset,1)
        end
        if self.SlideTween~=nil then
            self:StopSlide(ControlPriority.Drag)
        end
    end
    return UWidgetBlueprintLibrary.Handled()
end

function M:UpdateMapDelta(DeltaLoc)
    local Geometry=self:GetCachedGeometry()
    DeltaLoc=USlateBlueprintLibrary.TransformVectorLocalToAbsolute(Geometry,DeltaLoc)--这个静态函数名疑似写反了
    FVector2D.Mul(DeltaLoc,-1)

    self.CurrentDragOffset:Set(self.MapImage.RenderTransform.Translation.X,self.MapImage.RenderTransform.Translation.Y)
    FVector2D.Sub(self.CurrentDragOffset,DeltaLoc)
    if self.DragLimitOffset then
        if self.CurrentDragOffset.X>self.DragLimitOffset.X then
            self.CurrentDragOffset:Set(self.DragLimitOffset.X,self.CurrentDragOffset.Y)
        elseif self.CurrentDragOffset.X<-self.DragLimitOffset.X then
            self.CurrentDragOffset:Set(-self.DragLimitOffset.X,self.CurrentDragOffset.Y)
        end
        if self.CurrentDragOffset.Y>self.DragLimitOffset.Y then
            self.CurrentDragOffset:Set(self.CurrentDragOffset.X,self.DragLimitOffset.Y)
        elseif self.CurrentDragOffset.Y<-self.DragLimitOffset.Y then
            self.CurrentDragOffset:Set(self.CurrentDragOffset.X,-self.DragLimitOffset.Y)
        end
    end
    
    self:SetDragOffset()

    self.NeedResilience=self:IsOverBorder()
end

function M:CheckUpdateMapDelta()
    if self.NeedResilience then
        self:LimitDragOffset()
        self:SetDragOffset()
    end
end

function M:IsOverBorder()
    return self.CurrentDragOffset.X>self.LimitOffset.X or self.CurrentDragOffset.X<-self.LimitOffset.X or self.CurrentDragOffset.Y>self.LimitOffset.Y or self.CurrentDragOffset.Y<-self.LimitOffset.Y
end

function M:SetDragOffset()
    self.MapImage:SetRenderTranslation(self.CurrentDragOffset)
    self.Bg_Map:SetRenderTranslation(self.CurrentDragOffset*self.BackgroundDragRatio)
    self.Panel_Gamer:SetRenderTranslation(self.CurrentDragOffset)
    -- self.Panel_Floor:SetRenderTranslation(self.CurrentDragOffset)
    -- self.Panel_Select:SetRenderTranslation(self.CurrentDragOffset)
    self.Panel_Point:SetRenderTranslation(self.CurrentDragOffset)

    if self.IsInRegion then
    -- FVector2D.Add(self.CurrentDragOffset,self.gamerLoc)
        self.Indicator:OnPointerMove(self.CurrentDragOffset,self.gamerLoc)
    else
        -- self.Indicator:SetVisibility(ESlateVisibility.Collapsed)
    end
    if self.TrackIndicator then
        self.TrackIndicator:OnPointerMove(self.CurrentDragOffset,self.TrackTarget.RenderTransform.Translation)
    end

    if not IsEmptyTable(self.RegionMapIndicatorWidgets) then
        for k, v in pairs(self.RegionMapIndicatorWidgets) do
            if IsValid(v) and self.IndicatorWidgets[k] and IsValid(self.IndicatorWidgets[k]) then
                v:OnPointerMove(self.CurrentDragOffset, self.IndicatorWidgets[k].RenderTransform.Translation)
            end
        end
    end
end

function M:LimitDragOffset()
    -- local k=self.CurrentDragOffset.Y/self.CurrentDragOffset.X
    -- local screenK=self.LimitOffset.Y/self.LimitOffset.X

    -- if (k> screenK and self.CurrentDragOffset.X>0) or (k<-screenK and self.CurrentDragOffset.X<0) then
    --     self.CurrentDragOffset:Set(self.LimitOffset.Y/k,self.LimitOffset.Y)
    -- elseif (k>screenK and self.CurrentDragOffset.X<0) or (k<-screenK and self.CurrentDragOffset.X>0) then
    --     self.CurrentDragOffset:Set(-self.LimitOffset.Y/k,-self.LimitOffset.Y)
    -- elseif (k<screenK and self.CurrentDragOffset.X>0) or (k>-screenK and self.CurrentDragOffset.X>0) then
    --     self.CurrentDragOffset:Set(self.LimitOffset.X,(self.LimitOffset.X)*k)
    -- elseif (k<screenK and self.CurrentDragOffset.X<0) or (k>-screenK and self.CurrentDragOffset.X<0) then
    --     self.CurrentDragOffset:Set(-self.LimitOffset.X,-self.LimitOffset.X*k)
    -- end
    self.CurrentDragOffset:Set(math.min(self.CurrentDragOffset.X,self.LimitOffset.X),math.min(self.CurrentDragOffset.Y,self.LimitOffset.Y))
    self.CurrentDragOffset:Set(math.max(self.CurrentDragOffset.X,-self.LimitOffset.X),math.max(self.CurrentDragOffset.Y,-self.LimitOffset.Y))
end

function M:GameViewportSizeChanged()
    if self.IsMiniMap then
        return
    end
    self.ScreenSize=UIManager(self):GetDesignedScreenSize(self)
    FVector2D.Div(self.ScreenSize,2)
end

function M:OnPointerUp(MyGeometry,Event)
    if self.IsEmpty then
        return UWidgetBlueprintLibrary.Unhandled()
    end
    if not self.InitComplete then
        return UWidgetBlueprintLibrary.Handled()
    end

    self.IsDragging=false
    if self.IsClicked and self.IsOpenDispatch == false then
        if not self:ClosePanel() and self:CheckControlPriority(ControlPriority.Normal) and not self.IsInDungeon then
            -- local temp=1
            -- if not self.NewMapType then
            --     local imagePos=USlateBlueprintLibrary.AbsoluteToLocal(self.MapImage.Img_Map:GetCachedGeometry(),UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(Event))
            --     temp=self:GetMousePosAlpha(imagePos/self.MapImage.Img_Map:GetDesiredSize())
            -- end
            -- if temp>0 then
                local position=USlateBlueprintLibrary.AbsoluteToLocal(self.Panel_Point:GetCachedGeometry(),UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(Event))
                self:OpenMark(nil,position)
            -- end
        end
    end

    if not IsEmptyTable(self.IndicatorWidgets) then
        for _, v in pairs(self.IndicatorWidgets) do
            if IsValid(v) then
                v.IsSelected = false
                v:PlayAnimation(v.Normal)
            end
        end
    end
    self.IsClicked=false
    if self.NeedResilience then
        self:LimitDragOffset()
        self:SetSlideTarget(self.CurrentDragOffset,ControlPriority.Resilience,0.5)
    else
        self:StartInertiaSlide()
    end
    return UWidgetBlueprintLibrary.Unhandled()
end

function M:ClosePanel(IsImmediately)
    for _,selectWidget in pairs (self.SelectWidgetTable) do
        selectWidget:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.ClickedSelectWidget=nil
    if self.CurrentSelectPoint then
        if self.CurrentSelectPoint.VisibilityTag:Find("SingleCreate") then
            self.CurrentSelectPoint:SetPointVisibility("SingleCreate",false,true)
        end
        self.CurrentSelectPoint.Slot:SetZOrder(0)
        self.CurrentSelectPoint:PlayAnimation(self.CurrentSelectPoint.NormalAni)
        self.CurrentSelectPoint.IsSelected=false
        self.CurrentSelectPoint=nil
    end
    if not IsImmediately then
        self.LastPanelId = nil
        self.MainMap.IsPanelOpen = false
        self:SetFocus()
        -- self.MainMap.BackToWorldMap:SetVisibility(ESlateVisibility.Visible)
        -- self.MainMap.BackToWorldMap:Show()
        self:InitDispatchCondition()
        --self.MainMap.Entrance_Dispatch:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        if self.RegionInfo then
            self.RegionInfo:Show()
            -- self.RegionInfo.Img_Arrow:SetRenderTransformAngle(0)
            if self.RegionInfo.Img_Arrow.RenderTransform.Angle==-180 then
                self.RegionInfo:PlayAnimation(self.RegionInfo.Spin_Arrow)
            end
        end
        self.MainMap:ShoworHideTopTab(true)
        self.MainMap.WildMapKeysShow = true
        self.MainMap:UpdateWildMapKeys()
        if self.GamepadSelect then
            self.GamepadSelect:PlayAnimation(self.GamepadSelect.Normal)
        end
    end
    self.MainMap:ShoworHideBottomTab(true)
    if self.IsOpenDispatch == false then
        if self.FloorWidget then
            self.FloorWidget:SetVisibility(IsEmptyTable(self.FloorWidgetTable) and ESlateVisibility.Collapsed or ESlateVisibility.SelfHitTestInvisible)
        end
        self.MainMap.DispatchId = -1
    end
    if self.KeyLocPanel then
        self.KeyLocPanel:Show()
    end
    if self.MainMap.DispatchDetail then
        self.MainMap.DispatchDetail:RealClose()
        self:RefreshAllDispatchPoint()
        self:RefreshDispatchSelect()
        self.CurClickDispatchId = -1
        return true
    end
    if self.LevelMap_Convey_Widget_PC and self.LevelMap_Convey_Widget_PC:GetVisibility()==ESlateVisibility.SelfHitTestInvisible then
        self.CurrentConveyId=nil
        self:OnScaleChange(self.CurrentPercent)
        self.LevelMap_Convey_Widget_PC.Group_Temple:SetVisibility(ESlateVisibility.Collapsed)
        self.LevelMap_Convey_Widget_PC:RemoveKey()
        if IsImmediately then
            self.LevelMap_Convey_Widget_PC:SetVisibility(ESlateVisibility.Collapsed)
        elseif not self.LevelMap_Convey_Widget_PC:IsAnimationPlaying(self.LevelMap_Convey_Widget_PC.Auto_Out) then
            self.LevelMap_Convey_Widget_PC:PlayAnimation(self.LevelMap_Convey_Widget_PC.Auto_Out)
            return true
        end
    end

    if self.TureHardBoss_MapTips and self.TureHardBoss_MapTips:GetVisibility()==ESlateVisibility.SelfHitTestInvisible then
        self.CurrentConveyId=nil
        self:OnScaleChange(self.CurrentPercent)
        if IsImmediately then
            self.TureHardBoss_MapTips:SetVisibility(ESlateVisibility.Collapsed)
        else
            self.TureHardBoss_MapTips:PlayAnimation(self.TureHardBoss_MapTips.Out)
            return true
        end
    end
     self:CloseChallengeTips()
    if self.ChangeAreaWidget and self.ChangeAreaWidget:GetVisibility()==ESlateVisibility.SelfHitTestInvisible and not self.ChangeAreaWidget:IsAnimationPlaying(self.ChangeAreaWidget.Auto_Out) then
        self.ChangeAreaWidget:PlayAnimation(self.ChangeAreaWidget.Auto_Out)
        return true
    end
    if self.MarkPanel and self.MarkPanel.IsVisible then
        self:TryDeleteTempMarkAndClose()
        self.CurrentMarkUuid=nil
        self:OnScaleChange(self.CurrentPercent)
        return true
    end
    if not IsEmptyTable(self.IndicatorWidgets) then
        for k, v in pairs(self.IndicatorWidgets) do
            if IsValid(v) then
                v:PlayAnimation(v.Normal)
                v.IsSelected = false
            end

            if IsValid(self.SelectWidgetTable[k]) then
                self.SelectWidgetTable[k]:SetVisibility(ESlateVisibility.Collapsed)
            end
        end
    end
    if self.MapTipsWidget and self.MapTipsWidget:GetVisibility()==ESlateVisibility.SelfHitTestInvisible then
        if IsImmediately then
            self.MapTipsWidget:SetVisibility(ESlateVisibility.Collapsed)
            self.MapTipsWidget:OnHide()
        else
            self.MapTipsWidget:BindToAnimationFinished(self.MapTipsWidget.Auto_Out, 
                {self.MapTipsWidget, function()
                    self.MapTipsWidget:UnbindAllFromAnimationFinished(self.MapTipsWidget.Auto_In)
                    self.MapTipsWidget:SetVisibility(ESlateVisibility.Collapsed)
                    self.MapTipsWidget:OnHide()
                end})
            if not self.MapTipsWidget:IsAnimationPlaying(self.MapTipsWidget.Auto_Out)  then
                self.MapTipsWidget:PlayAnimation(self.MapTipsWidget.Auto_Out)
            end
            return true
        end
    end
    return false
end

function M:OnMouseLeave(Event)
    if self.IsDragging then
        self:OnPointerUp(nil,Event)
    end
end

function M:OnPanelOpen(panel)
    self.MainMap:ShoworHideTopTab(false)
    self.MainMap.WildMapKeysShow = false
    self.MainMap.IsPanelOpen = true
    self.MainMap:UpdateWildMapKeys()
    if panel==0 then--标记
        self.LevelMap_Convey_Widget_PC:SetVisibility(ESlateVisibility.Collapsed)
        self.TureHardBoss_MapTips:SetVisibility(ESlateVisibility.Collapsed)
        self.RegionInfo:Close()
        self.FloorWidget:SetVisibility(ESlateVisibility.Collapsed)
        -- self.MainMap.BackToWorldMap:Close()
        self.MainMap.Entrance_Dispatch:SetVisibility(ESlateVisibility.Collapsed)
        self:RefreshAllDispatchPoint()
        self:RefreshDispatchSelect()
        if self.MainMap.DispatchDetail then     
            self.MainMap.DispatchDetail:RealClose()
        end
    elseif panel==1 then--区域选择
        if self.MarkPanel then
            self.MarkPanel:SetVisibility(ESlateVisibility.Collapsed)
        end
        self.LevelMap_Convey_Widget_PC:SetVisibility(ESlateVisibility.Collapsed)
        self.TureHardBoss_MapTips:SetVisibility(ESlateVisibility.Collapsed)
        self.FloorWidget:SetVisibility(ESlateVisibility.Collapsed)
        -- self.MainMap.BackToWorldMap:Close()
        self.MainMap.Entrance_Dispatch:SetVisibility(ESlateVisibility.Collapsed)
        self:RefreshAllDispatchPoint()
        self:RefreshDispatchSelect()
        if self.MainMap.DispatchDetail then     
            self.MainMap.DispatchDetail:RealClose()
        end
        self.MainMap:ShoworHideBottomTab(false)
        self.RegionInfo:Close()
    elseif panel==2 then--传送
        if self.MarkPanel then
            self.MarkPanel:SetVisibility(ESlateVisibility.Collapsed)
        end
        self.RegionInfo:Close()
        self.FloorWidget:SetVisibility(ESlateVisibility.Collapsed)
        -- self.MainMap.BackToWorldMap:Close()
        self.MainMap.Entrance_Dispatch:SetVisibility(ESlateVisibility.Collapsed)
        self:RefreshAllDispatchPoint()
        self:RefreshDispatchSelect()
        if self.MainMap.DispatchDetail then  
            self.MainMap.DispatchDetail:RealClose()
        end
    elseif panel==3 then --印象
        -- self.MainMap.BackToWorldMap:Close()
        self.MainMap.Entrance_Dispatch:SetVisibility(ESlateVisibility.Collapsed)
        self:RefreshAllDispatchPoint()
        self:RefreshDispatchSelect()
        if self.MainMap.DispatchDetail then     
            self.MainMap.DispatchDetail:RealClose()
        end
    elseif panel == 4 then --任务指引点
        -- self.MainMap.BackToWorldMap:Close()
        self.RegionInfo:Close()
        self.MainMap.Entrance_Dispatch:SetVisibility(ESlateVisibility.Collapsed)
        self.FloorWidget:SetVisibility(ESlateVisibility.Collapsed)
        self:RefreshAllDispatchPoint()
        self:RefreshDispatchSelect()
        if self.MainMap.DispatchDetail then
            self.MainMap.DispatchDetail:RealClose()
        end
    elseif panel == 5 then--派遣,对地图其他信息点的显隐在ClsoeForDispatch
        self.RegionInfo:SetVisibility(ESlateVisibility.Collapsed)
        self.FloorWidget:SetVisibility(ESlateVisibility.Collapsed)
        self.MainMap.Entrance_Dispatch:SetVisibility(ESlateVisibility.Collapsed)
        -- self.MainMap.BackToWorldMap:Close()
    elseif panel == 6 then
        if self.MarkPanel then
            self.MarkPanel:SetVisibility(ESlateVisibility.Collapsed)
        end
        self.LevelMap_Convey_Widget_PC:SetVisibility(ESlateVisibility.Collapsed)
        self.TureHardBoss_MapTips:SetVisibility(ESlateVisibility.Collapsed)
        self.RegionInfo:Close()
        self.FloorWidget:SetVisibility(ESlateVisibility.Collapsed)
        -- self.MainMap.BackToWorldMap:Close()
        self.MainMap.Entrance_Dispatch:SetVisibility(ESlateVisibility.Collapsed)
        self:RefreshAllDispatchPoint()
        self:RefreshDispatchSelect()
        if self.MainMap.DispatchDetail then     
            self.MainMap.DispatchDetail:RealClose()
        end
    end
    self.LastPanelId = panel
end

function M:TouchWildMapMultiMove(TouchFingerCount, Index, Pos1, Pos2, TwoPointDist)
    if (not UE4.UKismetSystemLibrary.IsValid(self.Player) or TouchFingerCount <= 1) then
        return
    end
    if (self.LastTouchMultiDist == nil) then
        self.LastTouchMultiDist = TwoPointDist
        return
    end
    self.IsDragging=false
    if self.IsClicked then
        self:ClosePanel()
    end
    self.IsClicked=false
    local DeltaDis = TwoPointDist - self.LastTouchMultiDist
    local temp=self.MapScale.X
    if (DeltaDis >= 5) then
        -- 双指靠近
        temp = math.min(temp + 0.05, self.WheelMaxScale)
    elseif (DeltaDis <= -5) then 
        -- 双指分开
        temp = math.max(temp - 0.05, self.WheelMinScale)
    end
    -- self:OnScaleChange((temp-0.75)/0.5)
    self.MainMap:OnMouseWheelTurned((temp-self.WheelMinScale)/(self.WheelMaxScale-self.WheelMinScale))
    self.LastTouchMultiDist = TwoPointDist
end

function M:CheckControlPriority(RequireControlPriority)
    return self.CurrentControlPriority<=RequireControlPriority
end

function M:SetControlPriority(TargetControlPriority)
    self.CurrentControlPriority=TargetControlPriority
end

function M:CheckControlPriority_Normal()
    return self.CurrentControlPriority<=ControlPriority.Normal
end

function M:SetSlideTarget(TargetLoc, InControlPriority,Duration)
    if not self:CheckControlPriority(InControlPriority) or UUIFunctionLibrary.Vector2D_IsNAN(TargetLoc) then
        return
    end
    self:SetControlPriority(InControlPriority)
    -- self.SlideTween=UDBTweenVector2D.DOVector2D('RegionMapSlide',1,self.MapImage.RenderTransform.Translation, TargetLoc,EaseType.InExpo)
    self:DOVector2D(Duration,self.MapImage.RenderTransform.Translation, TargetLoc,EaseType.OutCirc)
    -- self.SlideTween.OnUpdate:Add(self,self.OnUpdateSlide)
    -- self.SlideTween.OnComplete:Add(self,self.OnCompleteSlide)--lua里绑定会在完成一次动画后再mouseMove时crash？
end

function M:StopSlide(InControlPriority)
    if not self:CheckControlPriority(InControlPriority) then
        return
    end
    UDBTweenBase.DBTweenStop("RegionMapSlide")
    self.SlideTween=nil
    self:SetControlPriority(ControlPriority.Normal)
end

function M:OnUpdateSlide(curValue)
    self.CurrentDragOffset=curValue
    self:SetDragOffset()
end

function M:OnCompleteSlide(curValue)
    self:SetControlPriority(ControlPriority.Normal)
    self.NeedResilience=false
    self.SlideTween=nil
end

function M:StartInertiaSlide()
    if not self.CacheDragOffset or #self.CacheDragOffset<2 then
        return
    end
    local startT=self.CacheDragOffset[1]
    local endT=self.CacheDragOffset[#self.CacheDragOffset]
    if endT.Time - startT.Time == 0 then--防止卡顿时同一帧多次输入，造成Nan
        return
    end
    local v=FVector2D(endT.X-startT.X,endT.Y-startT.Y)
    v=v/(endT.Time-startT.Time)*0.2
    v:Set(math.min(v.X, 4000), math.min(v.Y, 4000))
    v:Set(math.max(v.X, -4000), math.max(v.Y, -4000))
    local time=math.max(0,0.5-(UGameplayStatics.GetRealTimeSeconds(self)-endT.Time))
    if time>0 then
        v=v*time
        FVector2D.Add(self.CurrentDragOffset,v)
        if self:IsOverBorder() then
            self:LimitDragOffset()
        end
        self:SetSlideTarget(self.CurrentDragOffset,ControlPriority.Inertia,time)
    end
end

function M:MoveMapAndCheck(DeltaLoc)
    self:UpdateMapDelta(DeltaLoc)
    self:CheckUpdateMapDelta()
end

function M:JumpToCurrentPosition()
    self.MainMap:OnAreaClicked()
    -- self.MainMap:OnTabItemClick({Idx = 2})
    local Avatar = GWorld:GetAvatar()
    local RegionId = DataMgr.SubRegion[Avatar.CurrentRegionId].RegionId
    if DataMgr.Region[RegionId].RegionMapId then
        RegionId = DataMgr.RegionMap[DataMgr.Region[RegionId].RegionMapId].RegionId
    end
    self:ChangeRegion(RegionId,function()
        self:ShowMissionIndicatorsInRegionMap()
    end)
end

function M:JumpToTaskPosition()
    self.MainMap:OnAreaClicked()
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
    local SubRegionId =  MissionIndicatorManager:GetTargetTaskSubRegionId(TrackingQuestChainId, TrackingQuestId) 
    if not SubRegionId or SubRegionId == 0 then
        return
    end
    self:ChangeRegionForSmartIndicator(SubRegionId, TrackingQuestChainId)
    -- self:MoveMapToQuestTarget(TrackingQuestChainId)
end

function M:MoveMapTo(TargetLoc)
    local Geometry=self:GetCachedGeometry()
    local TargetDeltaLoc = TargetLoc - self.CurrentDragOffset
    TargetDeltaLoc = USlateBlueprintLibrary.TransformVectorAbsoluteToLocal(Geometry,TargetDeltaLoc)
    self:MoveMapAndCheck(TargetDeltaLoc)
end

function M:MoveMapToTelepoint(Id)
    local data = DataMgr.TeleportPoint[Id]
    if not data then
        return
    end
    self:MoveMapTo(self:TransformWorldLocToUILoc(data.MechanismPos[1],data.MechanismPos[2]) * -1)
    local floorid=self.TeleportPoint2FloorId[Id]
    if floorid then
        self:OnFloorBtnClicked(floorid,true)
    end
end

function M:MoveMapToQuestTarget(InQuestChainId, GuidePoint)
    local FloorId = nil
    for k, v in pairs(self.IndicatorLocations) do
        local IndicatorUI = UIManager(self):GetUIObj(k)
        local IsRange = false
        if IndicatorUI then
            local TargetPointKey = nil
            if IndicatorUI.GuideInfoCache and IndicatorUI.GuideInfoCache.PointOrStaticCreatorName then
                TargetPointKey = IndicatorUI.GuideInfoCache.PointOrStaticCreatorName
            end
            if GuidePointLocData[TargetPointKey] ~= nil and GuidePointLocData[TargetPointKey].R ~= nil and GuidePointLocData[TargetPointKey].R > 0 then
                IsRange = true
            end
        end

        if IsValid(self.IndicatorWidgets[k]) and IsValid(self.IndicatorWidgets[k]) == GuidePoint then
            self.IndicatorWidgets[k].IsSelected = true
            self:MoveMapTo(self:TransformWorldLocToUILoc(v.X, v.Y) * -1)
            FloorId = GuidePoint.FloorId
        elseif InQuestChainId and IsValid(self.IndicatorWidgets[k]) and self.IndicatorWidgets[k].TargetQuestChainId and self.IndicatorWidgets[k].TargetQuestChainId == InQuestChainId then
            self.IndicatorWidgets[k].IsSelected = true
            self:MoveMapTo(self:TransformWorldLocToUILoc(v.X, v.Y) * -1)
            FloorId = self.IndicatorWidgets[k].FloorId
            if IsValid(self.SelectWidgetTable[k]) and IsRange == false then
                self.SelectWidgetTable[k]:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                self.SelectWidgetTable[k]:PlayAnimation(self.SelectWidgetTable[k].Click)
            end
            break
        elseif IsValid(self.IndicatorWidgets[k]) and self.IndicatorWidgets[k].IsSelected then
            self:MoveMapTo(self:TransformWorldLocToUILoc(v.X, v.Y) * -1)
            FloorId = self.IndicatorWidgets[k].FloorId
            if IsValid(self.SelectWidgetTable[k]) and IsRange == false  then
                self.SelectWidgetTable[k]:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                self.SelectWidgetTable[k]:PlayAnimation(self.SelectWidgetTable[k].Click)
            end
            break
        end
    end
    if FloorId then
        self:OnFloorBtnClicked(FloorId, true)
    end
    self:ShowQuestDetailInRegionMap(InQuestChainId)
end

function M:MoveMapToRegionPoint(Id)
    local Position = self.RegionPointLocation[Id]
    if not Position then
        return
    end
    self:MoveMapTo(self:TransformWorldLocToUILoc(Position.X, Position.Y) * -1)
    local FloorId = self.RegionPoint2FloorId[Id]
    if FloorId then
        self:OnFloorBtnClicked(FloorId, true)
    end
end

function M:MoveMapToMarkPoint(Id)
    local Data = self.MarkData[Id]
    if not Data then
        return
    end
    local Position = FVector2D(Data.PositionX, Data.PositionY)
    -- FVector2D.Sub(Position,self.ScreenSize)
    FVector2D.Mul(Position,self.MapScale)
    self:MoveMapTo(Position * -1)
    local FloorId = Data.FloorId
    if FloorId then
        self:OnFloorBtnClicked(FloorId, true)
    end
end

function M:CheckSelect(Point)
    if self.CheckBreak then
        self.CheckBreak = false
        return true
    end
    local SelectTable = self:GetPointByPosition(Point.RenderTransform.Translation, Point:GetDesiredSize()/2*1.5, Point)
    if #SelectTable == 1 then
        return true
    else
        self.MainMap:OpenSelectList(SelectTable)
        return false
    end
end

function M:GetPointByPosition(MyPosition, MySize, CheckPoint)
    local SelectTable={}
    local IsGuidePoint = false

    if CheckPoint then
        table.insert(SelectTable, CheckPoint)
        if CheckPoint.TargetQuestChainId and CheckPoint.TargetQuestChainId > 0 then
            IsGuidePoint = true
        end
    end

    -- local IsGuidePoint = false
    -- for _, GuideWidget in pairs(self.IndicatorWidgets) do
    --     if IsValid(GuideWidget) and GuideWidget == CheckPoint then
    --         IsGuidePoint = true
    --         break
    --     end
    -- end

    for i=1,self.Panel_Point:GetChildrenCount() do 
        local TempPoint = self.Panel_Point:GetChildAt(i-1)
        if TempPoint ~= CheckPoint and TempPoint:GetVisibility() == ESlateVisibility.SelfHitTestInvisible and TempPoint:GetClass():GetName() ~= 'WBP_Map_Select_C' then
            local Position = TempPoint.RenderTransform.Translation
            if MyPosition.X - MySize.X <= Position.X and MyPosition.X + MySize.X >= Position.X
            and MyPosition.Y - MySize.Y <= Position.Y and MyPosition.Y + MySize.Y >= Position.Y then
                table.insert(SelectTable,TempPoint)
            end
        end
    end

    for _,GuideWidget in pairs(self.IndicatorWidgets) do
        if GuideWidget ~= CheckPoint and GuideWidget:GetVisibility() == ESlateVisibility.SelfHitTestInvisible and IsGuidePoint == false then
            local Position = GuideWidget.RenderTransform.Translation
            if MyPosition.X - MySize.X <= Position.X and MyPosition.X + MySize.X >= Position.X
            and MyPosition.Y - MySize.Y <= Position.Y and MyPosition.Y + MySize.Y >= Position.Y then
                table.insert(SelectTable,GuideWidget)
                IsGuidePoint = true
            end
        end
    end
    return SelectTable
end

function M:CheckSelectByPosition(Position, Size)
    local SelectTable = self:GetPointByPosition(Position, Size, nil)
    local MinDistance = nil
    local MinDisPoint = nil
    for _, Point in pairs(SelectTable) do
        local Distance = UKismetMathLibrary.Distance2D(Position, Point.RenderTransform.Translation)
        if not MinDistance or MinDistance > Distance then
            MinDistance = Distance
            MinDisPoint = Point
        end
    end
    return MinDisPoint
end
----------地图操作----------End

function M:EnterOrExitFloor(IsEnter,Box)
    if not self.BulidingState[Box.BuildingFloor] then
        self.BulidingState[Box.BuildingFloor]={}
    end
    self.BulidingState[Box.BuildingFloor][Box]=IsEnter
    local targetFloor=self.MaxFloorId
    if IsEnter then
        targetFloor=Box.BuildingFloor
    else
        for floor,boxMap in pairs(self.BulidingState) do
            for box,IsShow in pairs(boxMap) do
                if IsShow then
                    targetFloor = floor
                end
            end
        end
    end
    DebugPrint('EnterOrExitFloor', IsEnter, Box:GetName(), Box.BuildingFloor, targetFloor)
    self:ShowFloor(targetFloor)
end

function M:ShowFloor(FloorId)
    if not self.MapImage then
        return
    end
    for floor,boxMap in pairs(self.BulidingState) do
        for box,IsShow in pairs(boxMap) do
            if floor <FloorId and IsShow then
                FloorId=floor
            end
        end
    end
    self.CurrentFloorId=FloorId
    self:ShowFloor_Component(FloorId)
    self:SetAllMissionIndicatorsPlayerFloorId(self.CurrentFloorId)
end

----------区域列表----------Start
function M:OnClickOpenRegionList_Sound()
    if self.IsInDungeon then
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", "", nil)
    self:OnClickOpenRegionList()
end

function M:OnClickOpenRegionList()
    -- self.RegionInfo.Img_Arrow:SetRenderTransformAngle(self.RegionInfo.Img_Arrow:GetRenderTransformAngle()+180)
    self.RegionInfo.Btn_ShowUp:PlayAnimation(self.RegionInfo.Btn_ShowUp.Btn_Click)
    if not self.ChangeAreaWidget then
        self.ChangeAreaWidget=UIManager(self):_CreateWidgetNew("RegionMapChangeRegion")
        self.MainMap.ChangeArea:AddChild(self.ChangeAreaWidget)
        self.ChangeAreaWidget:Init(self)
        self:OnPanelOpen(1)
        self.ChangeAreaWidget:PlayAnimation(self.ChangeAreaWidget.Auto_In)
        self.RegionInfo:PlayAnimationReverse(self.RegionInfo.Spin_Arrow)
    else
        if self.ChangeAreaWidget:GetVisibility()==ESlateVisibility.Collapsed then
            self.ChangeAreaWidget:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.ChangeAreaWidget:Init(self)
            self.ChangeAreaWidget:PlayAnimation(self.ChangeAreaWidget.Auto_In)
            self:OnPanelOpen(1)
            self.RegionInfo:PlayAnimationReverse(self.RegionInfo.Spin_Arrow)
        else
            -- self.ChangeAreaWidget:SetVisibility(ESlateVisibility.Collapsed)
            -- self.ChangeAreaWidget:PlayAnimation(self.ChangeAreaWidget.Auto_Out)
            self:ClosePanel()
            self.RegionInfo:PlayAnimation(self.RegionInfo.Spin_Arrow)
        end
    end
end

function M:OnRegionClick(RegionId)
    self.RegionInfo.Img_Arrow:SetRenderTransformAngle(0)
    -- self.ChangeAreaWidget:SetVisibility(ESlateVisibility.Collapsed)
    self:ChangeRegion(RegionId, function()
        self:ShowMissionIndicatorsInRegionMap()
    end)
    self.MainMap:UpdateWildMapKeys()
    self.MainMap.Btn_ReturnHome:SetVisibility(ESlateVisibility.Collapsed)
    self:AddTimer(0.01, function()
        self.MainMap.Entrance_Dispatch:SetVisibility(ESlateVisibility.Collapsed)
    end)
    -- AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", "", nil)
end

function M:ChangeRegion(RegionId, InitCompleteFunc)
    self:ClearData()
    self:Init(false,RegionId,self.MainMap, InitCompleteFunc)
end

function M:SetAllMissionIndicatorsPlayerFloorId(InFloorId)
    local Indicators = MissionIndicatorManager:GetAllIndicatorUIObjs()
    if not IsEmptyTable(Indicators) then
        for _, Obj in pairs(Indicators) do
            if IsValid(Obj) then
                Obj.PlayerFloorLevelId = InFloorId
            end
        end
    end
end

function M:ChangeRegionForSmartIndicator(InTaskSubRegionId, TrackingQuestChainId)
    local function TryGetSmartPointDataForRegionMap(InTaskSubRegionId)
        local TempRegionDatas = nil
        local RegionTargetDatas = nil
        if DataMgr.RegionGraph[InTaskSubRegionId] == nil or 
        DataMgr.RegionGraph[InTaskSubRegionId].SubRegionTarget == nil or
        DataMgr.RegionGraph[InTaskSubRegionId].SubRegionTarget.RegionTarget == nil then
            return nil
        end
        local RetSubRegionId, RetData = InTaskSubRegionId, nil
        TempRegionDatas = DataMgr.RegionGraph[InTaskSubRegionId].SubRegionTarget.RegionTarget
        for _, Data in pairs(TempRegionDatas) do
            if Data and Data[1] and Data[1] < RetSubRegionId then
                RetSubRegionId = Data[1]
            end
        end

        if DataMgr.RegionGraph[RetSubRegionId] == nil or 
        DataMgr.RegionGraph[RetSubRegionId].SubRegionTarget == nil or
        DataMgr.RegionGraph[RetSubRegionId].SubRegionTarget.RegionTarget == nil then
            return nil
        end
        RegionTargetDatas = DataMgr.RegionGraph[RetSubRegionId].SubRegionTarget.RegionTarget
        for _, Data in pairs(RegionTargetDatas) do
            if Data and Data[1] and Data[2] and Data[1] == InTaskSubRegionId then
                return {SubRegionId = RetSubRegionId, Data = Data}
            end
        end

        return nil
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    local RegionId = DataMgr.SubRegion[InTaskSubRegionId].RegionId
    if self:CheckIsAnyTeleporPointUnlock(InTaskSubRegionId, true) or (DataMgr.RegionGraph[Avatar.CurrentRegionId] and DataMgr.RegionGraph[Avatar.CurrentRegionId].RegionStart == nil) then
        self:ChangeRegion(RegionId, function()
            self:ShowMissionIndicatorsInRegionMap()
            self:MoveMapToQuestTarget(TrackingQuestChainId)
        end)
    else
        -- local Data = TryGetSmartPointDataForRegionMap(InTaskSubRegionId)
        local TargetRegionId, Data = TaskUtils:TryGetSmartPointDataForRegionMap(Avatar.CurrentRegionId, InTaskSubRegionId)
        if TargetRegionId == nil and Data and Data[1] and Data[2] then
            local RegionId = DataMgr.SubRegion[Data[1]].RegionId
            self:ChangeRegion(RegionId, function()
                self:AddMainTaskGuidePointToRegionMapForTrackingQuest(Data[2])
                self:MoveMapToQuestTarget(TrackingQuestChainId)
            end)
        elseif TargetRegionId ~= nil and Data and Data[1] and Data[2] then
            self:ChangeRegion(TargetRegionId, function()
                self:AddMainTaskGuidePointToRegionMapForTrackingQuest(Data[2])
                self:MoveMapToQuestTarget(TrackingQuestChainId)
            end)
        else
            if DataMgr.RegionGraph[InTaskSubRegionId] == nil or 
            DataMgr.RegionGraph[InTaskSubRegionId].SubRegionTarget == nil or
            DataMgr.RegionGraph[InTaskSubRegionId].SubRegionTarget.RegionTarget == nil then
                self:ChangeRegion(RegionId, function()
                    self:ShowMissionIndicatorsInRegionMap()
                    self:MoveMapToQuestTarget(TrackingQuestChainId)
                end)
                return
            end
            local TargetRegionTargetDatas = DataMgr.RegionGraph[InTaskSubRegionId].SubRegionTarget.RegionTarget
            for _, IterData in pairs(TargetRegionTargetDatas) do
                if IterData and IterData[1] and IterData[2] and self:CheckIsAnyTeleporPointUnlock(IterData[1], true) then
                    local IterRegionId = DataMgr.SubRegion[IterData[1]].RegionId
                    self:ChangeRegion(IterRegionId, function()
                        self:AddMainTaskGuidePointToRegionMapForTrackingQuest(IterData[2])
                        self:MoveMapToQuestTarget(TrackingQuestChainId)
                    end)
                    return
                end
            end

            self:ChangeRegion(RegionId, function()
                self:ShowMissionIndicatorsInRegionMap()
                self:MoveMapToQuestTarget(TrackingQuestChainId)
            end)
        end
    end
end

----------区域列表----------End

function M:OnCommonTrack(TrackingType, Id, IsAdd)--标记和传送点公用一个追踪名额
    if self.IsMiniMap and TrackingType == CommonConst.RegionMapTrackingType.MiniDispatchPoint and DataMgr.Dispatch[Id] ~= nil and IsAdd == true then
        local Path = '/Game/UI/WBP/Map/Widget/Dispatch/WBP_Map_DispatchPointInfo.WBP_Map_DispatchPointInfo'
        local Point = UIManager(self):CreateWidget(Path)
        local UIPos = DataMgr.DispatchUI[Id].UIPos
        local Pos = self:TransformWorldLocToUILoc(UIPos[1], UIPos[2])
        Point:SetRenderTranslation(Pos)
        Point:InitMini(Id)
        self.MiniDispatchPoint[Id] = Point   
        DebugPrint('Point',Point,IsAdd)
        GWorld.GameInstance.TrackingPack = {TrackingType, Id}
    end
    
    if TrackingType ~= CommonConst.RegionMapTrackingType.SpecialSideQuest then
        self:OnCommonTrackDeleteSpecialSideQuestTrack(TrackingType)
    end
    if not self.IsMiniMap then
        return
    end
    if IsAdd then
        GWorld.GameInstance.TrackingPack = {TrackingType, Id}
    else
        GWorld.GameInstance.TrackingPack = nil
    end
    local trackTarget = self:GetTrackingTarget(TrackingType, Id)
    if not trackTarget then
        return
    end
    if IsAdd then
        local TargetActor = nil
        local StaticCreartorId = TArray(0)
        local ManualItemId = TArray(0)
        if TrackingType ==  CommonConst.RegionMapTrackingType.TeleportPoint then
            local Data = DataMgr.TeleportPoint[Id]
            TargetActor = self.GameState.StaticCreatorMap:FindRef(trackTarget.Data.StaticId)
            StaticCreartorId:Add(trackTarget.Data.StaticId)
        elseif TrackingType == CommonConst.RegionMapTrackingType.RegionPoint then
            local Data = DataMgr.RegionPoint[Id]
            local CreatorId = Data.StaticId
            if CreatorId then
                TargetActor = self.GameState.StaticCreatorMap:FindRef(CreatorId)
                StaticCreartorId:Add(CreatorId)
            else
                local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
                if GameMode then
                    local ManualItemId = Data.ManualItemId
                    TargetActor = GameMode.BPBornRegionActor:FindRef(ManualItemId)
                    ManualItemId:Add(ManualItemId)
                end
            end
        elseif TrackingType == CommonConst.RegionMapTrackingType.MiniDispatchPoint then
            local Data = DataMgr.DynQuest[Id]
            local CreatorId = Data.TriggerBoxID
            if CreatorId then
                TargetActor = self.GameState.StaticCreatorMap:FindRef(CreatorId)
                StaticCreartorId:Add(CreatorId)
            end
        elseif TrackingType == CommonConst.RegionMapTrackingType.MarkPoint then
            local ActorClass = LoadClass('/Game/BluePrints/Common/Level/BP_RegionMapTrackTarget.BP_RegionMapTrackTarget')
            if self.MarkPointTargetActor then
                self.MarkPointTargetActor:K2_DestroyActor()
            end
            local Location = trackTarget.RenderTransform.Translation
            Location = self:TransformUILocToWorldLoc(Location.X, Location.Y)
            local Transform = FTransform(FRotator(), FVector(Location.X, Location.Y, -100000))
            self.MarkPointTargetActor = self:GetWorld():SpawnActor(ActorClass, Transform, ESpawnActorCollisionHandlingMethod.AlwaysSpawn, nil, self, nil)
            self.MarkPointTargetActor.MarkUuid = Id
        elseif TrackingType == CommonConst.RegionMapTrackingType.SoloTreasure then
            if self:IsSolotreasureStaticCreator(Id) then
                TargetActor = self.GameState.StaticCreatorMap:FindRef(Id)
                StaticCreartorId:Add(Id)
            else
                self:AddGuideRandomCreator(Id)
            end
        end
        local arrow=self.MainMap:NewPointArrow()
        -- arrow:SetRenderScale(self.MainMap.PointPanel.RenderTransform.Scale)
        self:AddTrack(trackTarget, arrow, TargetActor)
        -- 场景指引
        local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
        if GameMode then
            GameMode:OpenGuideIconRegion(nil, StaticCreartorId, ManualItemId, nil, nil)
        end
        self.MainMap.TracePanel:AddChild(trackTarget)
        if TrackingType ==  CommonConst.RegionMapTrackingType.TeleportPoint then
            trackTarget:ReInitTeleportPoint(DataMgr.TeleportPoint[Id])
        end
        self:AdjustSlot(trackTarget.Slot)
        trackTarget:SetRenderScale(self.MinimapIconScale/FVector2D(0.7,0.7))--levelMapPoint本身有缩放，tracePanel跟随拼接关是0.7，需要修改scale
        trackTarget:StopAllAnimations()
        trackTarget:PlayAnimation(trackTarget.Loop,0,0)
        -- GWorld.GameInstance.TrackingPack = {TrackingType, Id}
    elseif self.MainMap.TracePanel:HasChild(trackTarget) then
        local StaticCreartorId = TArray(0)
        local ManualItemId = TArray(0)
        if TrackingType ==  CommonConst.RegionMapTrackingType.TeleportPoint then
            StaticCreartorId:Add(trackTarget.Data.StaticId)
        elseif TrackingType == CommonConst.RegionMapTrackingType.RegionPoint then
            local Data = DataMgr.RegionPoint[Id]
            local CreatorId = Data.StaticId
            if CreatorId then
                StaticCreartorId:Add(CreatorId)
            else
                local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
                if GameMode then
                    local ManualItemId = Data.ManualItemId
                    ManualItemId:Add(ManualItemId)
                end
            end
        elseif TrackingType == CommonConst.RegionMapTrackingType.MiniDispatchPoint then
            local Data = DataMgr.DynQuest[Id]
            local CreatorId = Data.TriggerBoxID
            if CreatorId then
                StaticCreartorId:Add(CreatorId)
            end
        elseif TrackingType == CommonConst.RegionMapTrackingType.SoloTreasure then
            if self:IsSolotreasureStaticCreator(Id) then
                StaticCreartorId:Add(Id)
            else
                self:RemoveGuideRandomCreator(Id)
            end
        end
        if TrackingType == CommonConst.RegionMapTrackingType.MiniDispatchPoint and DataMgr.Dispatch[Id] ~= nil then
            self:RemoveTrack(trackTarget)
            
            -- 场景指引
            local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
            if GameMode then
                GameMode:CloseGuideIconRegion(nil, StaticCreartorId, ManualItemId, nil, nil)
            end

            if TrackingType ==  CommonConst.RegionMapTrackingType.TeleportPoint then
                trackTarget:ReInitTeleportPoint(DataMgr.TeleportPoint[Id])
            end
            trackTarget:RemoveFromParent()
            -- GWorld.GameInstance.TrackingPack=nil
            return
        end
        self.Panel_Point:AddChild(trackTarget)
        self:AdjustSlot(trackTarget.Slot)
        trackTarget:SetRenderScale(self.MinimapIconScale)
        self:RemoveTrack(trackTarget)

        -- 场景指引
        local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
        if GameMode then
            GameMode:CloseGuideIconRegion(nil, StaticCreartorId, ManualItemId, nil, nil)
        end

        if TrackingType ==  CommonConst.RegionMapTrackingType.TeleportPoint then
            trackTarget:ReInitTeleportPoint(DataMgr.TeleportPoint[Id])
        end
        trackTarget:StopAllAnimations()
        GWorld.GameInstance.TrackingPack=nil
        if self.MarkPointTargetActor then
            self.MarkPointTargetActor:K2_DestroyActor()
            self.MarkPointTargetActor = nil
        end
    end
end

function M:OnCommonTrackDeleteSpecialSideQuestTrack(TrackingType)
    if self.IsMiniMap then
        return
    end
    if TrackingType ~= CommonConst.RegionMapTrackingType and MissionIndicatorManager.TrackingSpecialSideQuestChainId ~= nil then
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
        if MissionIndicatorManager.TrackingSpecialSideQuestChainId and DataMgr.QuestChain[MissionIndicatorManager.TrackingSpecialSideQuestChainId] then
            EventManager:FireEvent(EventID.UpdateMiniMap, DataMgr.QuestChain[MissionIndicatorManager.TrackingSpecialSideQuestChainId].QuestNpcId, "SpecialSide", "Delete")
            MissionIndicatorManager:ReactiveMissionIndicatorByRegionMap(DataMgr.QuestChain[MissionIndicatorManager.TrackingSpecialSideQuestChainId].QuestNpcId)
            EventManager:FireEvent(EventID.OnChangeTaskIndicator, TaskUtils.MissionNpcGuideMaps)
        end
        MissionIndicatorManager.TrackingSpecialSideQuestChainId = nil
    end
end

function M:GetTrackingId(TrackingType)
    local TrackingPack = GWorld.GameInstance.TrackingPack
    if not TrackingPack or TrackingPack[1] ~= TrackingType then
        return nil
    end
    return TrackingPack[2]
end

function M:GetTrackingTarget(TrackingType, Id)
    local TrackingType2Table = {
        [CommonConst.RegionMapTrackingType.TeleportPoint] = self.TeleportPoints,
        [CommonConst.RegionMapTrackingType.RegionPoint] = self.RegionPoints,
        [CommonConst.RegionMapTrackingType.MarkPoint] = self.MarkTable,
        [CommonConst.RegionMapTrackingType.MiniDispatchPoint] = self.MiniDispatchPoint,
        [CommonConst.RegionMapTrackingType.SoloTreasure] = self.SoloTreasurePoints,
    }
    if not TrackingType2Table[TrackingType] or not TrackingType2Table[TrackingType][Id] then
        return nil
    end
    return TrackingType2Table[TrackingType][Id]
end

function M:CancelCurrentTracking()
    if not GWorld.GameInstance.TrackingPack then
        return
    end
    local TrackType, Id = table.unpack(GWorld.GameInstance.TrackingPack)
    local TrackTarget = self:GetTrackingTarget(TrackType, Id)
    if TrackTarget then
        TrackTarget:StopAllAnimations()
    end
    EventManager:FireEvent(EventID.OnCommonTrack, TrackType, Id , false)
end

function M:OnTrackCancel(TrackTarget)
    if not GWorld.GameInstance.TrackingPack then
        return
    end
    local TrackingType, Id = table.unpack(GWorld.GameInstance.TrackingPack)
    local CurrentTarget = self:GetTrackingTarget(TrackingType, Id)
    if not CurrentTarget or TrackTarget ~= CurrentTarget then
        return
    end
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_ARRIVED"))
    self:OnCommonTrack(TrackingType, Id, false)
end

function M:OnClickDimension()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click", "", nil)
    self.RegionInfo.Impression_Dimension:SetIsChecked(false)
    -- self:OnPanelOpen(3)
    local DimensionPanel=UIManager(self):LoadUINew("RegionMapImpression")
    DimensionPanel:Init(self.RegionID,self)
    if self.ChangeAreaWidget and self.ChangeAreaWidget:GetVisibility()==ESlateVisibility.SelfHitTestInvisible then
        self:OnClickOpenRegionList()
    end
end

function M:CreateTrackIndicator(TrackTarget)
    if self.IsMiniMap then
        return
    end
    if not self.InitComplete then
        self.TrackTarget = TrackTarget
        return
    end
    if not self.TrackIndicator then
        self.TrackIndicator=self:NewIndicator()
        self.TrackIndicator:Init(self,self.ScreenSize-self.BgHeight,TrackTarget,false)
        self.TrackIndicator.Slot:SetZOrder(2)
    end
    self.TrackTarget=TrackTarget
    self.TrackIndicator:SetIcon(TrackTarget.Img_Point.Brush.ResourceObject)
    self.TrackIndicator:OnPointerMove(self.CurrentDragOffset,self.TrackTarget.RenderTransform.Translation)
end

function M:RemoveTrackIndicator()
    if self.TrackIndicator then
        self.TrackIndicator:RemoveFromParent()
        self.TrackIndicator=nil
    end
    self.TrackTarget=nil
end

function M:AdjustSlot(CanvasSlot)
    local half=UKismetMathLibrary.Vector2D_One()/2
    local anchors=CanvasSlot:GetAnchors()
    anchors.Minimum=half
    anchors.Maximum=half
    CanvasSlot:SetAnchors(anchors)
    CanvasSlot:SetAlignment(half)
end

--region 手柄相关--------------------------------
function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    if CurInputDevice == ECommonInputType.Gamepad then
        if self.MainMap:IsInteractiveOpen() or self.IsOpenDispatch then
            return
        end
        if UIManager(self):GetUIObj("RegionMapImpression") then
            return
        end
        -- self.Panel_Select:SetVisibility(ESlateVisibility.Visible)
        self.GamepadSelect:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        if not self.LastPanelId then
            self:SetFocus()
        -- elseif self.LastPanelId == 1 then
        --     self.ChangeAreaWidget:SetFocus()
        elseif self.LastPanelId == 2 then
            if self.TureHardBoss_MapTips and self.TureHardBoss_MapTips:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
                self.TureHardBoss_MapTips:SetFocus()
            elseif self.LevelMap_Convey_Widget_PC and self.LevelMap_Convey_Widget_PC:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
                self.LevelMap_Convey_Widget_PC:SetFocus()
            end
        end
        if self.FloorWidget and next(self.FloorWidgetTable) then
            self.FloorWidget.Key_Controller_Up:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.FloorWidget.Key_Controller_Down:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
    else
        -- self.Panel_Select:SetVisibility(ESlateVisibility.Collapsed)
        self.GamepadSelect:SetVisibility(ESlateVisibility.Collapsed)
        if self.FloorWidget and next(self.FloorWidgetTable) then
            self.FloorWidget.Key_Controller_Up:SetVisibility(ESlateVisibility.Collapsed)
            self.FloorWidget.Key_Controller_Down:SetVisibility(ESlateVisibility.Collapsed)
        end
    end
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
    if self.IsMiniMap then
        return UWidgetBlueprintLibrary.Unhandled()
    end
    if self.IsEmpty then
        return UWidgetBlueprintLibrary.Handled()
    end
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if not self.CurrentAnalogDelta then
        self.CurrentAnalogDelta = FVector2D(0, 0)
    else
        self.CurrentAnalogDelta:Set(0, 0)
    end
    if InKeyName == UIConst.GamePadKey.LeftAnalogX then
        local DeltaX = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * -15
        if self.CurrentDragOffset.X + DeltaX > self.LimitOffset.X or self.CurrentDragOffset.X + DeltaX < -self.LimitOffset.X then
            DeltaX = 0
        end
        self.CurrentAnalogDelta:Set(DeltaX, 0)
    elseif InKeyName == UIConst.GamePadKey.LeftAnalogY then
        local DeltaY = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 15
        if self.CurrentDragOffset.Y + DeltaY > self.LimitOffset.Y or
        self.CurrentDragOffset.Y + DeltaY < -self.LimitOffset.Y then
            DeltaY = 0
        end
        self.CurrentAnalogDelta:Set(0, DeltaY)
    elseif InKeyName == UIConst.GamePadKey.RightAnalogY then
        local delta=UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)*0.05
        local temp = self.MapScale.X + delta
        if temp < self.WheelMinScale then
            temp = self.WheelMinScale
        elseif temp > self.WheelMaxScale then
            temp = self.WheelMaxScale
        end
        self.MainMap:OnMouseWheelTurned((temp - self.WheelMinScale)/(self.WheelMaxScale-self.WheelMinScale))
        return UWidgetBlueprintLibrary.Handled()
    end
    if UKismetMathLibrary.EqualEqual_Vector2DVector2D(self.CurrentAnalogDelta, UKismetMathLibrary.Vector2D_Zero(),2.25) then
        return UWidgetBlueprintLibrary.Handled()
    end
    self.bCheckGamepadSelect = true
    self.CheckGamepadSelectTime = UGameplayStatics.GetRealTimeSeconds(self)
    self.GamepadSelect:PlayAnimation(self.GamepadSelect.Normal)
    self.GamepadSelectState = false
    self.GamepadSelectPoint = nil
    -- if not self.IsOpenDispatch and self.AnalogStartMove then
    --     self:ClosePanel()
    --     self.AnalogStartMove = false
    -- end
    self:UpdateMapDelta(self.CurrentAnalogDelta)
    -- table.insert(self.CacheDragOffset,{X=self.CurrentDragOffset.X,Y=self.CurrentDragOffset.Y,Time=UGameplayStatics.GetRealTimeSeconds(self)})
    -- if #self.CacheDragOffset>5 then
    --     table.remove(self.CacheDragOffset,1)
    -- end
    -- if self.SlideTween~=nil then
    --     self:StopSlide(ControlPriority.Drag)
    -- end
    return UWidgetBlueprintLibrary.Handled()
end

function M:CheckGamepadSelect()
    if not self.GamepadSelectState then
        self.GamepadSelectState = true
        self.GamepadSelectPoint = self:CheckSelectByPosition(self.CurrentDragOffset * -1, FVector2D(50,50))
        if self.GamepadSelectPoint then
            self.GamepadSelect:PlayAnimation(self.GamepadSelect.Hover)
            self:MoveMapTo(self.GamepadSelectPoint.RenderTransform.Translation * -1)
            if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
                self.MainMap.Key_Tip:UpdateKeyInfo(self.MainMap.WildMapGamePadEnsureKeys)
            end
        else
            if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
                self.MainMap.Key_Tip:UpdateKeyInfo(self.MainMap.WildMapGamePadKeys)
            end
        end
    end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if self.GamepadSelect then
        self.GamepadSelect:SetRenderOpacity(1)
    end
    -- self.AnalogStartMove = true
    return UWidgetBlueprintLibrary.Unhandle
end

function M:OnFocusLost(MyGeometry, InFocusEvent)
    if self.GamepadSelect then
        self.GamepadSelect:SetRenderOpacity(0)
    end
    return UWidgetBlueprintLibrary.Unhandle
end
--endregion

function M:TryToastNotInSameRegion()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local RegionId = DataMgr.SubRegion[Avatar.CurrentRegionId].RegionId
    if DataMgr.Region[RegionId] and DataMgr.Region[RegionId].RegionMapId then
        RegionId = DataMgr.RegionMap[DataMgr.Region[RegionId].RegionMapId].RegionId
    end
    if self.RegionID ~= RegionId then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_RegionMap_NotInSameRegion"))
    end
end

AssembleComponents(M)
return M
