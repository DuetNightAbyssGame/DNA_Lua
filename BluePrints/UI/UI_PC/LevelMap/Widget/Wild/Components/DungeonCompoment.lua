require "UnLua"

local Component = {}

local ControlPriority={
    Normal=0,
    Inertia=1,
    Stop=2,
    Resilience=3,
    Drag=4
}

function Component:InitInDungeon(Id, MainMap, IsMiniMap)--先默认小地图
    self.RegionID = Id
    self.IsMiniMap = IsMiniMap
    self.MainMap = MainMap
    self.Panel_Empty:SetVisibility(ESlateVisibility.Collapsed)
    self.IsEmpty = false
    self.IsInDungeon = true
    self.RegionData = DataMgr.Region[Id]
    if self.RegionData.IsBlackBg then
        self:PlayAnimation(self.BlackBg)
    else
        self:PlayAnimation(self.WhiteBg)
    end
    self.InitCoroutines = {}
    self.CoroutineInitObj = CreateCoroutine(self.DungeonInitCoroutine)
    -- if not self.IsMiniMap then
    --     self:AddStaticSubTouchItem("RegionMapLayer", self.Panel_Touch, {MultiMove=self.TouchWildMapMultiMove,Down=self.OnRegionTouchDown,Move=self.OnRegionTouchMove,Up=self.OnRegionTouchUp})
    -- end
    coroutine.resume(self.CoroutineInitObj,self)
    -- self:OnScaleChange(self.CurrentPercent)
    -- self:OnScaleChange(1)
end

function Component:DungeonInitCoroutine()
    if self.RegionData.RegionMapImage then
        self.MapRotation=self.RegionData.RegionRotation or 0
        self.MapImage = UIManager(self):_CreateWidgetByUMGClass(LoadClass(self.RegionData.RegionMapImage), nil, nil, nil, false)
        if self.MapImage then
            self.Panel_Map:AddChild(self.MapImage)
            self.MapImage:SetRenderTransformAngle(self.MapRotation)
            local Half=UKismetMathLibrary.Vector2D_One()/2
            local Anchors=self.MapImage.Slot:GetAnchors()
            Anchors.Minimum=Half
            Anchors.Maximum=Half
            self.MapImage.Slot:SetAnchors(Anchors)
            self.MapImage.Slot:SetAutoSize(true)
            self.MapImage.Slot:SetAlignment(Half)
            self.NewMapType = self.MapImage.Img_Map == nil--新版地图拼接
            self.AllMapImage:Clear()
            self.MapImage2LocalPos:Clear()
            self.AllMapImage:Append(UUIFunctionLibrary.GetAllImageWidget(self.MapImage))
            self.MapFog = {}
            if not self.NewMapType then
                -- self:GetTextureRealMips(self.MapImage.Img_Map.Brush.ResourceObject)
                -- self:CreateMapFog(self.MapImage.Img_Map, self.MaxFloorId, self.RegionID)
            else
                GWorld.logger.error("副本不支持拼接式地图！!")
                -- self.MapImageTable={}
                -- self.MapBoxMax=FVector2D(0,0)
                -- self.MapBoxMin=FVector2D(0,0)
                -- local mapJointOffset=nil
                -- local tempRotation=self.MapRotation--所有计算都需要在没有旋转MapScale=1的情况下计算,所以暂时修改MapRotation，同时把MapScale除回去
                -- self.MapRotation=0
                -- local tempScale=FVector2D()
                -- tempScale:Set(self.MapScale.X,self.MapScale.Y)
                -- if self.MapScale.X==0 or self.MapScale.Y==0 then
                --     self.MapScale:Set(1,1)
                -- end
                -- for _,subRegionId in pairs(self.RegionData.IsRandom) do
                --     if self.MapImage[subRegionId] then
                --         local tempImage=self.MapImage[subRegionId]
                --         self.MapImageTable[subRegionId]=tempImage
                --         self:CreateMapFog(tempImage, self.MaxFloorId, subRegionId)
                --         local subRegionData=DataMgr.SubRegion[subRegionId]
                --         if subRegionData and subRegionData.SubRegionCenter and #subRegionData.SubRegionCenter>1 then
                --             if not mapJointOffset then
                --                 mapJointOffset = tempImage.Slot:GetPosition()
                --                 self.MapImageCenter=FVector2D(subRegionData.SubRegionCenter[1],subRegionData.SubRegionCenter[2])
                --             else
                --                 local position=self:TransformWorldLocToUILoc(subRegionData.SubRegionCenter[1],subRegionData.SubRegionCenter[2])/self.MapScale+mapJointOffset
                --                 tempImage.Slot:SetPosition(position)
                --                 if self.MapImage["Panel_"..subRegionId] then
                --                     self.MapImage["Panel_"..subRegionId].Slot:SetPosition(position)
                --                 end
                --             end
                --             tempImage:ForceLayoutPrepass()
                --             local tempPos=tempImage.Slot:GetPosition()
                --             local tempSize=tempImage.Slot:GetSize()
                --             self.MapBoxMax:Set(math.max(self.MapBoxMax.X,tempPos.X+tempSize.X/2),math.max(self.MapBoxMax.Y,tempPos.Y+tempSize.Y/2))
                --             self.MapBoxMin:Set(math.min(self.MapBoxMin.X,tempPos.X-tempSize.X/2),math.min(self.MapBoxMin.Y,tempPos.Y-tempSize.Y/2))
                --         else
                --             error("子区域"..subRegionId.."缺少Grdiframe坐标！")
                --         end
                --     end
                -- end
                -- local centerOffset=(self.MapBoxMax+self.MapBoxMin)/-2
                -- self.MapImage.Main:SetRenderTranslation(centerOffset)
                -- self.MapImageCenter=(centerOffset*-1-mapJointOffset)/self.Scale+self.MapImageCenter
                -- self.MapRotation=tempRotation
                -- self.MapScale:Set(tempScale.X,tempScale.Y)
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
        self.Panel_Gamer:SetVisibility(ESlateVisibility.Collapsed)
        self.Panel_Bg:SetVisibility(ESlateVisibility.Collapsed)
        self.BackgroundBlur:SetVisibility(ESlateVisibility.Collapsed)
        self:SetVisibility(ESlateVisibility.HitTestInvisible)

        if self.MapImage then
            self.MapImage:SetRenderOpacity(self.BattleMapOpacity)
            self.MapImage:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
        -- self.MiniMapRad=320--按battlemap里大的来
        self.MiniMapRad=135
        
        self.Panel_Point:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.HideTrack = false
        -- if not self.TickRegionMapImageOpen then
        --     UKismetRenderingLibrary.ClearRenderTarget2D(self,self.MapMistyRTMiniMap)
        --     self:AddTimer(0.1,function()
        --         local UIManager = GWorld.GameInstance:GetGameUIManager()
        --         local Battle = UIManager:GetUIObj("BattleMain")
        --         if self.MainMap.Battle and self.MainMap.Battle:IsVisible() and self.MainMap:IsVisible() and Battle and not Battle:IsHide() then
        --             -- self:AddTimer(1,function()--UUniformGrid下会出现size=0的情况，再延迟一次
        --                 DebugPrint('TickRegionMapImageOpen')
        --                 -- self:GetTeleportLocalPos()
        --                 self:GetMapImageLocalPos()
        --                 self.TickRegionMapImageOpen = true
        --             -- end)
        --             self:RemoveTimer("TickRegionMapImageOpen")
        --         end
        --     end, true, 0, "TickRegionMapImageOpen")
        -- end
        EventManager:AddEvent(EventID.OnNotifyClientToCloseLoading, self, self.InitMapRect)
    else
        -- self.MainMap.WildMapKeysShow = true
        -- self.MainMap.Tab:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        -- self:InitInRegionMap()
        self:InitInDungeonMap()
        self:InitMapRect()
        if self.AirBoxLocation then
            local TargetLoc = self:TransformWorldLocToUILoc(self.AirBoxLocation.X, self.AirBoxLocation.Y)
            self:MoveMapTo(TargetLoc * -1)
        end
    end
    self:InitDungeonComponentCoroutine()
    if not CommonUtils.IsEmpty(self.InitCoroutines) then
        coroutine.yield()
    end
    -- self:InitComponentCoroutine()
    -- coroutine.yield()
    -- self:InitMapFog()
    if self.DefaultFloorId and self.FloorWidgetTable and self.FloorWidgetTable[self.DefaultFloorId] then
        self.FloorWidgetTable[self.DefaultFloorId].Btn.OnClicked:Broadcast()
        self.FloorWidgetTable[self.DefaultFloorId]:PlayAnimation(self.FloorWidgetTable[self.MaxFloorId].Click)
        self.FloorWidgetTable[self.DefaultFloorId].SizeBox:SetRenderOpacity(self.IsInRegion and 1 or 0)
    elseif self.FloorWidgetTable and CommonUtils.IsEmpty(self.FloorWidgetTable) then
        self:OnScaleChange(self.CurrentPercent)
    end
    -- self:InitTaskArea()
    -- if self.IsMiniMap and GWorld.GameInstance.TrackingPack then
    --     self:OnCommonTrack(table.unpack(GWorld.GameInstance.TrackingPack),true)
    -- end

    -- self:InitDispatchCondition()

    -- self:InitMapRect()

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
    else
        self:ShowFloor(self.MaxFloorId)
    end
end

function Component:InitInDungeonMap()
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
    self.Panel_Gamer:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.WS_Indoor:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    local Avatar = GWorld:GetAvatar()
    self.IsInRegion=true
    self.WS_Indoor:SetActiveWidgetIndex(0)
    self.Direction:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Gamer:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.gamerLoc= self:TransformWorldLocToUILoc(self.Player.CurrentLocation.X,self.Player.CurrentLocation.Y)
    self.Gamer:SetRenderTranslation(self.gamerLoc)
    self.Direction:SetRenderTranslation(self.gamerLoc)
    self.Direction:SetRenderTransformAngle(self.Player:GetController().PlayerCameraManager:GetCameraRotation().Yaw+self.MapRotation+90)
    -- self.Direction:SetVisibility(ESlateVisibility.Collapsed)
    self.Gamer:SetRenderTransformAngle(self.Player.CurrentRotation.Yaw+self.MapRotation+90)
    if self.MapImage then
        self.MapImage:SetRenderTranslation(self.CurrentDragOffset)
        self.Bg_Map:SetRenderTranslation(self.CurrentDragOffset*self.BackgroundDragRatio)
    end
    self.Panel_Gamer:SetRenderTranslation(self.CurrentDragOffset)
    self.Panel_Point:SetRenderTranslation(self.CurrentDragOffset)
    -- self.FloorWidget=self.MainMap.FloorWidget
    -- self.FloorWidget:SetVisibility(ESlateVisibility.SelfHitTestInvisible)

    self.BgHeight = FVector2D(0,self.MainMap.Tab_Top.Slot:GetSize().Y)
    
    -- self:InitConveyWidget()
    if not self.Indicator then
        self.Indicator = self:CreateWidgetAsync("RegionMapIndicator", self.CoroutineInitObj)
        self.Panel_Floor:AddChild(self.Indicator)
        self:AdjustSlot(self.Indicator.Slot)
    end
    self.Indicator:Init(self,self.ScreenSize-self.BgHeight,self.Gamer,true)
    self.Indicator.Slot:SetZOrder(0)

    self:UpdateLimitOffset()
    -- if self.gamerLoc then
    --     self:MoveMapTo(self.gamerLoc * -1)
    -- end
    
    -- self.Panel_Close=self.MainMap.Btn_Panel_Close
    -- self.Panel_Close.OnClicked:Clear()
    -- self.Panel_Close.OnClicked:Add(self,self.OnPanelClose)
    self.MainMap.Slider_Zoom:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    
    self:InitTouchLayer(self.Player, 0, 0, true)
    self:AddStaticSubTouchItem("RegionMapLayer", self.Panel_Touch, {MultiMove=self.TouchWildMapMultiMove,Down=self.OnRegionTouchDown,Move=self.OnRegionTouchMove,Up=self.OnRegionTouchUp})
end

function Component:InitMapRect()
    local GameState = UGameplayStatics.GetGameState(self)
    if not GameState then
        return
    end
    self.MapRect = UIManager(self):_CreateWidgetByUMGClass(LoadClass('/Game/UI/WBP/Map/Widget/RegionMap/WBP_Map_Rect.WBP_Map_Rect'), nil, nil, nil, false)
    if self.IsMiniMap then
        self.Panel_Map:AddChild(self.MapRect)
        self.MapRect.Rect:GetDynamicMaterial():SetScalarParameterValue("Feather", 0.01)
    else
        self.Panel_Gamer:AddChild(self.MapRect)
        self.MapRect.Rect:GetDynamicMaterial():SetScalarParameterValue("Feather", 0.001)
    end
    local Half=UKismetMathLibrary.Vector2D_One()/2
    local Anchors=self.MapRect.Slot:GetAnchors()
    Anchors.Minimum=Half
    Anchors.Maximum=Half
    self.MapRect.Slot:SetAnchors(Anchors)
    self.MapRect.Slot:SetAlignment(Half)

    -- self:AddTimer(10,function()
    for _,ManualItem in pairs(GameState.ManualActiveCombat:ToTable()) do
        if ManualItem.UnitId == Const.WCDungeonAirBoxUnitId then
            self.AirBoxLocation = ManualItem:k2_GetActorLocation()
            self.MapRect:SetRenderTranslation(self:TransformWorldLocToUILoc(self.AirBoxLocation.X, self.AirBoxLocation.Y))
            local Scale = ManualItem:GetActorScale3D()
            local Size = FVector2D(Scale.X * 200, Scale.Y * 200) * self.Scale--这里用到的cube的模型是200*200的
            local ImageSize = nil
            if self.IsMiniMap then
                ImageSize = FVector2D(Size.X + self.MiniMapRad * 2, Size.Y + self.MiniMapRad * 2)
            else
                ImageSize = self.MapImage.Img_Map.Slot:GetSize() * 3
            end
            self.MapRect.Rect.Slot:SetSize(ImageSize)
            self.MapRect.Rect:GetDynamicMaterial():SetScalarParameterValue("Width", Size.X / ImageSize.X)
            self.MapRect.Rect:GetDynamicMaterial():SetScalarParameterValue("Height", Size.Y / ImageSize.Y)
            self.MapRect:SetRenderTransformAngle(ManualItem:K2_GetActorRotation().Yaw)
            break
        end
    end
    -- end)
    self.MapRect:SetVisibility(ESlateVisibility.HitTestInvisible)
end

function Component:AddComponentEvent()
    -- EventManager:AddEvent(EventID.OnNotifyClientToCloseLoading, self, self.InitMapRect)
end

function Component:RemoveComponentEvent()
    EventManager:RemoveEvent(EventID.OnNotifyClientToCloseLoading, self)
end

-- function Component:InitComponentCoroutine()
--     local Coroutine = CreateCoroutine(self.InitTeleportPoint)
--     table.insert(self.InitCoroutines, Coroutine)
--     coroutine.resume(Coroutine, self, #self.InitCoroutines)
-- end

function Component:ClearData()
    if self.MapRect then
        self.MapRect:RemoveFromParent()
        self.MapRect = nil
    end
end

function Component:OnScaleChange_Component(Percent)
    if not self.MapRect then
        return
    end
    self.MapRect:SetRenderTranslation(self:TransformWorldLocToUILoc(self.AirBoxLocation.X, self.AirBoxLocation.Y))
    self.MapRect:SetRenderScale(self.MapScale)
end

return Component