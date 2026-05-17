require "UnLua"

local Component = {}

function Component:InitComponentCoroutine()
    local Coroutine = CreateCoroutine(self.InitRegionPoint)
    table.insert(self.InitCoroutines, Coroutine)
    coroutine.resume(Coroutine, self, #self.InitCoroutines)
end

function Component:ClearData()
    if self.RegionPoints then
        for _,widget in pairs(self.RegionPoints) do
            widget:RemoveFromParent()
        end
        self.RegionPoints={}
    end
end

function Component:CheckRegionPointCancelTrack(RegionID)
    local TrackingID = self:GetTrackingId(CommonConst.RegionMapTrackingType.RegionPoint)
    if TrackingID == nil then
        return
    end
    if self.RegionPoints == nil then
        return
    end
    local TrackTarget = self.RegionPoints[TrackingID]
    if TrackTarget == nil then
        return
    end
    local RegionPointTargetSubRegion = self.RegionPointTargetSubRegion[TrackingID]
    if RegionPointTargetSubRegion then
        -- 进入室内取消
        for i = 1, #RegionPointTargetSubRegion do
            if RegionPointTargetSubRegion[i] == RegionID then
                    EventManager:FireEvent(EventID.OnCommonTrack, CommonConst.RegionMapTrackingType.RegionPoint, TrackingID, false)
                    TrackTarget:StopAllAnimations()
                    self:RemoveTrackIndicator()
                    break
            end
        end
    end
end

function Component:InitRegionPoint(CoroutineIndex)
    self.RegionPoints = {}
    self.RegionPointLocation = {}
    self.RegionPoint2FloorId = {}
    self.RegionPointTeleportPointId = {}
    self.RegionPointTargetSubRegion = {}
    self.RegionPointUnlockConditionId = {}
    self.RegionPointStartTime = {}
    self.RegionPointEndTime = {}
    self.RegionPointTickTable = {}

    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	if GameMode == nil or GameMode:GetRegionDataMgrSubSystem() == nil then
        self:InitCoroutineCheck(CoroutineIndex)
        return 
    end
    local TrackingId = self:GetTrackingId(CommonConst.RegionMapTrackingType.RegionPoint)
    for _, subRegionID in pairs(self.RegionData.IsRandom) do -- 遍历所有子区域
        repeat 
            local transferDatas = {}
            for _, RegionPointData in pairs(DataMgr.RegionPoint) do
                if RegionPointData.SubRegion == subRegionID then
                    transferDatas[RegionPointData.Id] = RegionPointData
                    local floorId = nil
                    if RegionPointData.BuildingNameAndId then
                        _, floorId = self:GetBuildingNameAndId(RegionPointData.BuildingNameAndId)
                    end
                    if not floorId then
                        floorId = self.MaxFloorId
                    end
                    self.RegionPoint2FloorId[RegionPointData.Id] = floorId
                end
            end
           
            for _, data in pairs(transferDatas) do 
                local point, select = self:NewPointAsync(self.InitCoroutines[CoroutineIndex])
                point:InitAsRegionPoint(self, data, self.OnRegionPointClick, self.OnRegionPointHover, self.OnRegionPointUnhover)
                local position = self:TransformWorldLocToUILoc(data.Pos[1], data.Pos[2])
                point:SetRenderTranslation(position)
                select:SetRenderTranslation(position)
                self.RegionPoints[data.Id] = point
                self.RegionPointLocation[data.Id] = FVector2D(data.Pos[1], data.Pos[2])
                self.RegionPointTeleportPointId[data.Id] = data.TelepointId
                self.RegionPointTargetSubRegion[data.Id] = data.TargetSubRegion
                self.SelectWidgetTable[data.Id] = select
                self.RegionPointUnlockConditionId[data.Id] = data.UnlockConditionId
                self.RegionPointStartTime[data.Id] = data.StartTime
                self.RegionPointEndTime[data.Id] = data.EndTime
                if data.StartTime or data.EndTime then
                    table.insert(self.RegionPointTickTable, data.Id)
                end
                if data.Id == TrackingId then
                    point:PlayAnimation(point.Loop,0,0) 
                    self:CreateTrackIndicator(point)
                end
                local Avatar = GWorld:GetAvatar()
                if Avatar == nil or not ConditionUtils.CheckCondition(Avatar, data.UnlockConditionId)
                or (not self.TeleportState[data.TelepointId] and not self:HasActivityTime(data.Id)) then
                    point:SetPointVisibility("Lock",false,true)
                end
                if not self:IsWithinActivityTime(data.Id) then
                    point:SetPointVisibility("Time", false, true)
                end
                if data.SingleCreate then
                    point:SetPointVisibility("SingleCreate",false,true)
                end
            end
        until true
    end
    if #self.RegionPointTickTable > 0 then
        self:AddTimer(1, function()
            for _, Id in pairs(self.RegionPointTickTable) do
                if self:IsWithinActivityTime(Id) then
                    self.RegionPoints[Id]:SetPointVisibility("Time", true)
                else
                    self.RegionPoints[Id]:SetPointVisibility("Time", false, true)
                end 
            end
        end, true, 0, "TickPointActivityTime")
    end
    self.OnConveyGoTrace_Component = self.OnConveyGoTrace_RegionPoint
    self:InitCoroutineCheck(CoroutineIndex)
end

function Component:ShowFloor_Component(FloorId)
    if not self.RegionPoints then
        return
    end
    for id,RegionPoint in pairs(self.RegionPoints) do
        if self.RegionPoint2FloorId[id]==FloorId then
            local Avatar = GWorld:GetAvatar()
            if Avatar ~= nil and ConditionUtils.CheckCondition(Avatar, self.RegionPointUnlockConditionId[id])then
                RegionPoint:SetPointVisibility('Floor',true)
            end
        else
            RegionPoint:SetPointVisibility('Floor',false,true)
        end
    end
end

function Component:OnScaleChange_Component(Percent)
    if not self.RegionPoints then
        return
    end
    local TrackingID=self:GetTrackingId(CommonConst.RegionMapTrackingType.RegionPoint)
    local Visible = self:GetMapIconVisible("UI_SUBREGION", Percent)
    for id,point in pairs(self.RegionPoints) do
        if not self.IsMinimap then
            if Visible or id == self.CurrentConveyId or id == TrackingID then
                if point:GetVisibility() ~= ESlateVisibility.SelfHitTestInvisible or not point.PlayForward then
                    if point:SetPointVisibility("Scale",true) then
                        point:StopAnimation(point.In)
                        point:PlayAnimation(point.In)
                        point.PlayForward=true
                    end
                end
            else
                if point:GetVisibility() ~= ESlateVisibility.Collapsed or point.PlayForward then
                    -- point:SetVisibility(ESlateVisibility.Collapsed)
                    if not point:IsAnimationPlaying(point.In) or point.PlayForward then
                        point:StopAnimation(point.In)
                        point:PlayAnimationReverse(point.In)
                        point.PlayForward=false
                    end
                    point:SetPointVisibility("Scale",false)
                end
            end
        end
        if point:GetVisibility() ~= ESlateVisibility.Collapsed or self.IsMinimap then
            local position=self:TransformWorldLocToUILoc(self.RegionPointLocation[id].X,self.RegionPointLocation[id].Y)
            point:SetRenderTranslation(position)
            self.SelectWidgetTable[id]:SetRenderTranslation(position)
        end
    end
end

function Component:IsWithinActivityTime(Id)
    local NowTime = TimeUtils.NowTime()
    if not self.RegionPointStartTime then
        return false
    end
    local StartTime = self.RegionPointStartTime[Id]
    local EndTime = self.RegionPointEndTime[Id]
    local IsAfterStartTime = not StartTime or StartTime < NowTime
    local IsBeforeEndTime = not EndTime or EndTime > NowTime
    if IsAfterStartTime and IsBeforeEndTime then
        return true
    else
        return false
    end
end

function Component:HasActivityTime(Id)
    if self.RegionPointStartTime[Id] or self.RegionPointEndTime[Id] then
        return true
    end
    return
end

function Component:OnRegionPointClick(Id, IgnoreCheckSelect)
    self.CurrentConveyId = nil
    local data = DataMgr.RegionPoint[Id]
    if not data or not self:CheckControlPriority_Normal() then
        return
    end
    self:ClosePanel(true)
    if self.CurrentSelectPoint and self.RegionPoints[Id] then
        self.CurrentSelectPoint:PlayAnimation(self.CurrentSelectPoint.NormalAni)
        self.CurrentSelectPoint.IsSelected=false
        self.CurrentSelectPoint.Slot:SetZOrder(0)
    end
    if not IgnoreCheckSelect and not self:CheckSelect(self.RegionPoints[Id]) then
        return
    end
    self.CurrentSelectPoint = self.RegionPoints[Id]
    self.CurrentSelectPoint.Slot:SetZOrder(20)
    self.SelectWidgetTable[Id]:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.SelectWidgetTable[Id]:PlayAnimation(self.SelectWidgetTable[Id].Click)
    if self.ClickedSelectWidget then
        self.ClickedSelectWidget:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.ClickedSelectWidget = self.SelectWidgetTable[Id]
    self.CurrentConveyId = Id
    self.LevelMap_Convey_Widget_PC:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.LevelMap_Convey_Widget_PC:PlayAnimation(self.LevelMap_Convey_Widget_PC.Auto_In)
    self.LevelMap_Convey_Widget_PC.Text_Name:SetText(GText(data.Name))
    if data.Desc then
        self.LevelMap_Convey_Widget_PC.Describe:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.LevelMap_Convey_Widget_PC.Text_Describe:SetText(GText(data.Desc))
    else
        self.LevelMap_Convey_Widget_PC.Describe:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.LevelMap_Convey_Widget_PC.Lock:SetVisibility(ESlateVisibility.Collapsed)
    self.LevelMap_Convey_Widget_PC:SetFocus()
    self.LevelMap_Convey_Widget_PC.Img_GuidePoint_Icon:SetBrushFromTexture(self.CurrentSelectPoint.Img_Point.Brush.ResourceObject)
    self:OnPanelOpen(2)
    if data.TeleportPointPos and data.TeleportSubRegion then
        self.LevelMap_Convey_Widget_PC.Switch_Button:SetActiveWidgetIndex(0)
        self.LevelMap_Convey_Widget_PC.Btn_Go:UnBindEventOnClickedByObj(self)
        self.LevelMap_Convey_Widget_PC.Btn_Go:BindEventOnClicked(self,self.OnRegionPointTeleportClicked)
        if data.SingleCreate then
            self.CurrentSelectPoint:SetPointVisibility("SingleCreate", true)
            self.CurrentSelectPoint:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
    else
        self.LevelMap_Convey_Widget_PC.Switch_Button:SetActiveWidgetIndex(2)
    end
    if self:GetTrackingId(CommonConst.RegionMapTrackingType.RegionPoint)~=self.CurrentConveyId then
        self.LevelMap_Convey_Widget_PC.Btn_Go_Track:SetText(GText('UI_RegionMap_Track'))
        self.LevelMap_Convey_Widget_PC.Btn_Go_Track.Img_Convey_1:SetBrushResourceObject(LoadObject('/Game/UI/Texture/Static/Atlas/Common/T_Com_IconConvey.T_Com_IconConvey'))
        self.LevelMap_Convey_Widget_PC.Btn_Go_Track.Img_Convey_1:SetBrushTintColor(UE4.UUIFunctionLibrary.StringToSlateColor("E1B454"))
    else
        self.LevelMap_Convey_Widget_PC.Btn_Go_Track:SetText(GText('UI_RegionMap_Untrack'))
        self.LevelMap_Convey_Widget_PC.Btn_Go_Track.Img_Convey_1:SetBrushResourceObject(LoadObject('/Game/UI/Texture/Static/Atlas/Common/T_Com_IconNo.T_Com_IconNo'))
        self.LevelMap_Convey_Widget_PC.Btn_Go_Track.Img_Convey_1:SetBrushTintColor(UE4.UUIFunctionLibrary.StringToSlateColor("BD4545"))
    end
    self:MoveMapToRegionPoint(Id)
    self.CurrentSelectPoint:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
end

function Component:OnRegionPointTeleportClicked()
    AudioManager(self):PlayUISound(self, "event:/ui/common/map_click_enter_level", "", nil)
    if self.CurrentConveyId and self.RegionPoints[self.CurrentConveyId] and not self.IsConveyClicked then
        local Data = DataMgr.RegionPoint[self.CurrentConveyId]
        local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        local Avatar = GWorld:GetAvatar()
        if Data and Avatar and GameMode then
            if not GameMode:CheckRegionPatchCondition(DataMgr.SubRegion[Data.TeleportSubRegion].RegionId) then
                GameMode:HandleLevelDeliver(UE4.EModeType.ModeRegion,Data.TeleportSubRegion,Data.TeleportPointPos, nil, true, true)
                return
            end
            self.MainMap:BindToAnimationFinished(self.MainMap.Auto_Out, function()
                GameMode:HandleLevelDeliver(UE4.EModeType.ModeRegion,Data.TeleportSubRegion,Data.TeleportPointPos, nil, true, true)
            end)
            self.MainMap:Close()
            self.IsConveyClicked=true
        end
    end
end

function Component:OnRegionPointHover(Id)
    if self.RegionPoints[Id] and self.SelectWidgetTable[Id] ~= self.ClickedSelectWidget then
        self.SelectWidgetTable[Id]:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.SelectWidgetTable[Id]:PlayAnimation(self.SelectWidgetTable[Id].Hover)
    end
end

function Component:OnRegionPointUnhover(Id)
    if self.RegionPoints[Id] and self.SelectWidgetTable[Id] ~= self.ClickedSelectWidget then
        self.SelectWidgetTable[Id]:SetVisibility(ESlateVisibility.Collapsed)
    end
end


function Component:OnConveyGoTrace_RegionPoint()
    --追踪
    if self.CurrentConveyId then
        if self:GetTrackingId(CommonConst.RegionMapTrackingType.RegionPoint) ~= self.CurrentConveyId then
            local avatar = GWorld:GetAvatar()
            if avatar == nil then
                self:ClosePanel(false)
                return
            end
            local CurrentRegionID = avatar.CurrentRegionId
            local RegionPointTargetSubRegion = self.RegionPointTargetSubRegion[self.CurrentConveyId]
            if RegionPointTargetSubRegion then
                -- 已在需要追踪的室内
                for i = 1, #RegionPointTargetSubRegion do
                    if RegionPointTargetSubRegion[i] == CurrentRegionID then
                        self:ClosePanel(false)
                        return
                    end
                end
            end
            self:CancelCurrentTracking()
            EventManager:FireEvent(EventID.OnCommonTrack, CommonConst.RegionMapTrackingType.RegionPoint,  self.CurrentConveyId, true)
            self.CurrentSelectPoint:PlayAnimation(self.CurrentSelectPoint.Loop, 0, 0)
            self:CreateTrackIndicator(self.CurrentSelectPoint)
            self:TryToastNotInSameRegion()
        else
            EventManager:FireEvent(EventID.OnCommonTrack, CommonConst.RegionMapTrackingType.RegionPoint, self.CurrentConveyId,false)
            self.CurrentSelectPoint:StopAllAnimations()
            self:RemoveTrackIndicator()
            self:ClosePanel(false)
            return
        end
    end
    self:ClosePanel(false)

    -- 传送（取消室内传送功能）
    -- local TeleportId = self.RegionPointTeleportPointId[self.CurrentConveyId]

    -- if not(self.TeleportState[teleportId] or Const.UnlockRegionTeleport) then
    --     local RegionPointLocation = self.RegionPointLocation[self.CurrentConveyId]
    --     local DistanceTable = {}
    --     local DistanceToId = {}
    --     for id, location in pairs(self.TeleportPointLocation) do
    --         local Distance = UE4.UKismetMathLibrary.Distance2D(RegionPointLocation, location)
    --         table.insert(DistanceTable, Distance)
    --         DistanceToId[Distance] = id
    --         local data = DataMgr.TeleportPoint[id]
    --         if data.IsDefault == 1 then
    --             TeleportId = id
    --         end
    --     end
    --     table.sort(DistanceTable)
    --     for _, distance in pairs(DistanceTable) do
    --         local CurrentTeleportId = DistanceToId[distance]
    --         if self.TeleportState[CurrentTeleportId] then
    --             TeleportId = CurrentTeleportId
    --             break
    --         end
    --     end
    -- end

    -- AudioManager(self):PlayUISound(self, "event:/ui/common/map_click_enter_level", "", nil)
    -- if self.CurrentConveyId and not self.IsConveyClicked then
    --     local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    --     local Avatar = GWorld:GetAvatar()
    --     local data = DataMgr.TeleportPoint[TeleportId]
    --     if Avatar and GameMode and data then
    --         GameMode:HandleLevelDeliver(UE4.EModeType.ModeRegion, data.TeleportPointSubRegion, data.TeleportPointPos)
    --         self.MainMap:Close()
    --         self.IsConveyClicked = true
    --     end
    -- end

end

return Component