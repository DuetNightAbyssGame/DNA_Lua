require "UnLua"

local Component = {}

-- local SoloTreasureMechanismUnitId = {[92001] = {["StateId"] = 900001},--扭蛋机
--                                      [131067] = {["StateId"] = 1310674},--守护机关
--                                      [131068] = {["StateId"] = 1310682},--毒气机关
--                                      [131069] = {["StateId"] = 1310692},--献祭机关
--                                      [131070] = {["StateId"] = 1310702},--秘宝房间大门
--                                      [7] = {}, }--撤离点

function Component:InitDungeonComponentCoroutine()
    local Coroutine = CreateCoroutine(self.InitSoloTreasure)
    table.insert(self.InitCoroutines, Coroutine)
    coroutine.resume(Coroutine, self, #self.InitCoroutines)
end

function Component:ClearData()
    if self.SoloTreasurePoints then
        for _,widget in pairs(self.SoloTreasurePoints) do
            widget:RemoveFromParent()
        end
        self.SoloTreasurePoints={}
    end
    local RegionDataMgr = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, URegionDataMgrSubsystem.StaticClass())
    if RegionDataMgr then
        RegionDataMgr:RemoveRegionDataAddCallback("Mechanism", self)
        RegionDataMgr:RemoveRegionDataUpdateCallback("Mechanism", self)
    end
    if self.KeyLocPanel then
        self.KeyLocPanel:RemoveFromParent()
    end
    if self.IsInDungeon and self.LevelMap_Convey_Widget_PC then
        self.LevelMap_Convey_Widget_PC:RemoveFromParent()
    end
    if self.IsMiniMap then
        if self:GetTrackingId(CommonConst.RegionMapTrackingType.SoloTreasure) then
            GWorld.GameInstance.TrackingPack = nil
        end
    end
end

function Component:InitSoloTreasure(CoroutineIndex)
    local DungeonId = GWorld.GameInstance:GetCurrentDungeonId()
    if DungeonId then
        local DungeonData = DataMgr.Dungeon[DungeonId]
        if not (DungeonData and DungeonData.DungeonType == "SoloTreasure") then
            self:InitCoroutineCheck(CoroutineIndex)
            return
        end
    else
        self:InitCoroutineCheck(CoroutineIndex)
        return
    end
    local RegionDataMgr = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, URegionDataMgrSubsystem.StaticClass())
    if RegionDataMgr then
        RegionDataMgr:AddRegionDataAddCallback("Mechanism", self, self.OnMechanismAdd)
        RegionDataMgr:AddRegionDataUpdateCallback("Mechanism", self, self.OnMechanismUpdate)
    end
    if not self.IsMiniMap then
        self.KeyLocPanel =  self:CreateWidgetNew("RegionMapSoloTreasureKeyLoc")
        self.MainMap.Pos_SoloTreasure_KeyLocation:AddChild(self.KeyLocPanel)
        self.KeyLocPanel:Show()
        self:InitSoloTreasureConveyWidget()
    end
    self.SoloTreasurePoints = {}
    self.SoloTreasurePoint2FloorId = {}
    self.SoloTreasureLocation = {}
    self.SoloTreasureMechanismUnitId = {}
    self.SoloTreasureCreatorId2UnitId = {}
    for _, Data in pairs(DataMgr.SoloTreasureIcon) do
        if Data.Mechanism then
            for Index, MechanismId in pairs(Data.Mechanism) do
                local MechamismTable = {}
                MechamismTable.Icon = Data.SoloTreasureIconType
                MechamismTable.Name = Data.SoloTreasureIconText
                if Data.MechanismState and Data.MechanismState[Index] then
                    MechamismTable.StateId = Data.MechanismState[Index]
                end
                if Data.MechanismDestroyState and Data.MechanismDestroyState[Index] then
                    MechamismTable.DestroyStateId = Data.MechanismDestroyState[Index]
                end
                self.SoloTreasureMechanismUnitId[MechanismId] = MechamismTable
            end
        end
    end
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	if GameMode == nil or GameMode:GetRegionDataMgrSubSystem() == nil then
        self:InitCoroutineCheck(CoroutineIndex)
        return 
    end
    local TrackingId = self:GetTrackingId(CommonConst.RegionMapTrackingType.SoloTreasure)
    local MechanismDatas = GameMode:GetRegionDataMgrSubSystem():GetAllRegionDataByUnitType("Mechanism")
    for _,Mechanism in pairs(MechanismDatas) do
        if self.SoloTreasureMechanismUnitId[Mechanism.UnitId] then
            local Id, IsStaitcCreator = self:GetIdByData(Mechanism)
            if not (Mechanism.State and Mechanism.State.StateId and Mechanism.State.StateId == self.SoloTreasureMechanismUnitId[Mechanism.UnitId].DestroyStateId) then
                self.SoloTreasureCreatorId2UnitId[Id] = {["UnitId"] = Mechanism.UnitId, ["IsStaitcCreator"] = IsStaitcCreator, ["WorldRegionEid"] = Mechanism.WorldRegionEid}
                local Point, Select = self:NewPointAsync(self.InitCoroutines[CoroutineIndex])
                local CreateData = {}
                CreateData.Icon = self.SoloTreasureMechanismUnitId[Mechanism.UnitId].Icon
                CreateData.Id =Id
                CreateData.Name = self.SoloTreasureMechanismUnitId[Mechanism.UnitId].Name
                Point:InitAsRegionPoint(self, CreateData, self.OnSoloTreasureIconClick, self.OnSoloTreasureIconHover, self.OnSoloTreasureIconUnhover)
                local position = self:TransformWorldLocToUILoc(Mechanism.Loc.X, Mechanism.Loc.Y)
                Point:SetRenderTranslation(position)
                Select:SetRenderTranslation(position)
                self.SoloTreasurePoints[Id] = Point
                self.SoloTreasureLocation[Id] = Mechanism.Loc
                self.SelectWidgetTable[Id] = Select
                Point:SetFinish(Mechanism.State and Mechanism.State.StateId and Mechanism.State.StateId == self.SoloTreasureMechanismUnitId[Mechanism.UnitId].StateId)
                if TrackingId == Id then
                    Point:PlayAnimation(Point.Loop,0,0) 
                    self:CreateTrackIndicator(Point)
                end
            end
        end
    end
    self.OnConveyGoTrace_Component = self.OnConveyGoTrace_SoloTreasure
    self:InitCoroutineCheck(CoroutineIndex)
end

function Component:ShowFloor_Component(FloorId)
end

function Component:OnScaleChange_Component(Percent)
    if not self.SoloTreasurePoints then
        return
    end
    for Id, Point in pairs(self.SoloTreasurePoints) do
        if Point:GetVisibility() ~= ESlateVisibility.Collapsed or self.IsMinimap then
            local position=self:TransformWorldLocToUILoc(self.SoloTreasureLocation[Id].X,self.SoloTreasureLocation[Id].Y)
            Point:SetRenderTranslation(position)
            self.SelectWidgetTable[Id]:SetRenderTranslation(position)
        end
    end
end

function Component:OnConveyGoTrace_SoloTreasure()
    --追踪
    if self.CurrentConveyId then
        if self:GetTrackingId(CommonConst.RegionMapTrackingType.SoloTreasure) ~= self.CurrentConveyId then
            self:CancelCurrentTracking()
            EventManager:FireEvent(EventID.OnCommonTrack, CommonConst.RegionMapTrackingType.SoloTreasure,  self.CurrentConveyId, true)
            self.CurrentSelectPoint:PlayAnimation(self.CurrentSelectPoint.Loop, 0, 0)
            self:CreateTrackIndicator(self.CurrentSelectPoint)
        else
            EventManager:FireEvent(EventID.OnCommonTrack, CommonConst.RegionMapTrackingType.SoloTreasure, self.CurrentConveyId,false)
            self.CurrentSelectPoint:StopAllAnimations()
            self:RemoveTrackIndicator()
        end
    end
    self:ClosePanel(false)
end

function Component:OnSoloTreasureIconClick(Id, IgnoreCheckSelect)
    self.CurrentConveyId = nil
    if not self.SoloTreasurePoints[Id] or not self:CheckControlPriority_Normal() then
        return
    end
    self:ClosePanel(true)
    self.KeyLocPanel:Close()
    if self.CurrentSelectPoint and self.SoloTreasurePoints[Id] then
        self.CurrentSelectPoint:PlayAnimation(self.CurrentSelectPoint.NormalAni)
        self.CurrentSelectPoint.IsSelected=false
        self.CurrentSelectPoint.Slot:SetZOrder(0)
    end
    if not IgnoreCheckSelect and not self:CheckSelect(self.SoloTreasurePoints[Id]) then
        return
    end
    self.CurrentSelectPoint = self.SoloTreasurePoints[Id]
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
    local Data = self.SoloTreasureMechanismUnitId[self.SoloTreasureCreatorId2UnitId[Id].UnitId]
    self.LevelMap_Convey_Widget_PC.Text_Name:SetText(GText(Data.Name))
    self.LevelMap_Convey_Widget_PC.Describe:SetVisibility(ESlateVisibility.Collapsed)
    self.LevelMap_Convey_Widget_PC.Lock:SetVisibility(ESlateVisibility.Collapsed)
    self.LevelMap_Convey_Widget_PC:SetFocus()
    self.LevelMap_Convey_Widget_PC.Img_GuidePoint_Icon:SetBrushFromTexture(self.CurrentSelectPoint.Img_Point.Brush.ResourceObject)
    -- self:OnPanelOpen(2)
    if self:GetTrackingId(CommonConst.RegionMapTrackingType.SoloTreasure)~=self.CurrentConveyId then
        self.LevelMap_Convey_Widget_PC.Switch_Button:SetActiveWidgetIndex(0)
    else
        self.LevelMap_Convey_Widget_PC.Switch_Button:SetActiveWidgetIndex(1)
    end
    -- self:MoveMapToRegionPoint(Id)
    self.CurrentSelectPoint:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    --原本OnPanelOpen内的，先临时放下
    self.MainMap.WildMapKeysShow = false
    self.MainMap.IsPanelOpen = true
    self.MainMap:UpdateWildMapKeys()
end

function Component:OnSoloTreasureIconHover(Id)
    if self.SoloTreasurePoints[Id] and self.SelectWidgetTable[Id] ~= self.ClickedSelectWidget then
        self.SelectWidgetTable[Id]:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.SelectWidgetTable[Id]:PlayAnimation(self.SelectWidgetTable[Id].Hover)
    end
end

function Component:OnSoloTreasureIconUnhover(Id)
    if self.SoloTreasurePoints[Id] and self.SelectWidgetTable[Id] ~= self.ClickedSelectWidget then
        self.SelectWidgetTable[Id]:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function Component:OnMechanismAdd(RegionData)
    if self.SoloTreasureMechanismUnitId[RegionData.UnitId] then
        local Id, IsStaitcCreator = self:GetIdByData(RegionData)
        local Point, Select = self:NewPoint()
        local CreateData = {}
        CreateData.Icon = self.SoloTreasureMechanismUnitId[RegionData.UnitId].Icon
        CreateData.Id = Id
        Point:InitAsRegionPoint(self, CreateData, self.OnSoloTreasureIconClick, self.OnSoloTreasureIconHover, self.OnSoloTreasureIconUnhover)
        local position = self:TransformWorldLocToUILoc(RegionData.Loc.X, RegionData.Loc.Y)
        Point:SetRenderTranslation(position)
        Select:SetRenderTranslation(position)
        self.SoloTreasurePoints[Id] = Point
        self.SoloTreasureLocation[Id] = RegionData.Loc
        self.SelectWidgetTable[Id] = Select
        self.SoloTreasureCreatorId2UnitId[Id] = {["UnitId"] = RegionData.UnitId, ["IsStaitcCreator"] = IsStaitcCreator, ["WorldRegionEid"] = RegionData.WorldRegionEid}
        Point:SetFinish(RegionData.State and RegionData.State.StateId and RegionData.State.StateId == self.SoloTreasureMechanismUnitId[RegionData.UnitId].StateId)
    end
end

function Component:OnMechanismUpdate(RegionData)
    local Id, IsStaitcCreator = self:GetIdByData(RegionData)
    if Id and self.SoloTreasurePoints[Id] then
        self.SoloTreasurePoints[Id]:SetFinish(RegionData.State and RegionData.State.StateId and RegionData.State.StateId == self.SoloTreasureMechanismUnitId[RegionData.UnitId].StateId)
        if RegionData.State and RegionData.State.StateId and RegionData.State.StateId == self.SoloTreasureMechanismUnitId[RegionData.UnitId].DestroyStateId then
            if self.IsMinimap then
                self:OnCommonTrack(CommonConst.RegionMapTrackingType.SoloTreasure, Id,false)
            end
            self.SoloTreasurePoints[Id]:RemoveFromParent()
            self.SoloTreasurePoints[Id] = nil
        end
    end
end

function Component:IsSolotreasureStaticCreator(Id)
    if self.SoloTreasureCreatorId2UnitId[Id] then
        return self.SoloTreasureCreatorId2UnitId[Id].IsStaitcCreator
    end
    return true
end

function Component:AddGuideRandomCreator(Id)
    if self.SoloTreasureCreatorId2UnitId[Id] then
        local RegionDataMgr = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, URegionDataMgrSubsystem.StaticClass())
        local GameState = UGameplayStatics.GetGameState(self)
        if RegionDataMgr and GameState then
            local Eid = RegionDataMgr:GetEidByWorldRegionEid(self.SoloTreasureCreatorId2UnitId[Id].WorldRegionEid)
            DebugPrint('SolotreasureComponent:AddGuideRandomCreator', Eid)
            GameState:AddGuideEid(Eid)
        end
    end
end

function Component:RemoveGuideRandomCreator(Id)
    if self.SoloTreasureCreatorId2UnitId[Id] then
        local RegionDataMgr = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, URegionDataMgrSubsystem.StaticClass())
        local GameState = UGameplayStatics.GetGameState(self)
        if RegionDataMgr and GameState then
            local Eid = RegionDataMgr:GetEidByWorldRegionEid(self.SoloTreasureCreatorId2UnitId[Id].WorldRegionEid)
            DebugPrint('SolotreasureComponent:RemoveGuideRandomCreator', Eid)
            GameState:RemoveGuideEid(Eid)
        end
    end
end

function Component:GetIdByData(RegionData)
    if RegionData.CreatorId then
        return RegionData.CreatorId, true
    elseif RegionData.RandomCreatorId then
        return RegionData.RandomCreatorId + 2000000000, false--参考BP_RandomCreateActor_C:AddRandomCreatorInfo
    end
    return nil, true
end

function Component:InitSoloTreasureConveyWidget()
    if not self.LevelMap_Convey_Widget_PC then
        self.LevelMap_Convey_Widget_PC = UIManager(self):CreateWidget('/Game/UI/WBP/Activity/Widget/SoloTreasure/Map/WBP_Activity_SoloTreasure_Map_Convey.WBP_Activity_SoloTreasure_Map_Convey')--self:CreateWidgetAsync("RegionMapConvey", self.CoroutineInitObj)--NewObject(self.ConveyClass, self)
        self.MainMap.Convey:AddChild(self.LevelMap_Convey_Widget_PC)
        self.LevelMap_Convey_Widget_PC.Btn_Track.Text_Button:SetText(GText('UI_RegionMap_Track'))
        self.LevelMap_Convey_Widget_PC.Btn_Track.Btn_Click.OnClicked:Add(self, self.OnConveyGoTrace_SoloTreasure)
        self.LevelMap_Convey_Widget_PC.Btn_Cancel_Track.Text_Button:SetText(GText('UI_RegionMap_Untrack'))
        self.LevelMap_Convey_Widget_PC.Btn_Cancel_Track.Btn_Click.OnClicked:Add(self, self.OnConveyGoTrace_SoloTreasure)
        self.LevelMap_Convey_Widget_PC.Btn_Track.Controller:CreateGamepadKey(UIConst.GamePadImgKey.FaceButtonBottom)
        self.LevelMap_Convey_Widget_PC.Btn_Cancel_Track.Controller:CreateGamepadKey(UIConst.GamePadImgKey.FaceButtonBottom)
        self.LevelMap_Convey_Widget_PC:InitWildMap(self)
    end
    self.LevelMap_Convey_Widget_PC:SetVisibility(ESlateVisibility.Collapsed)
end

function Component:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    if not self.SoloTreasurePoints then
        return
    end
    if CurInputDevice == ECommonInputType.Gamepad then
        self.LevelMap_Convey_Widget_PC.Btn_Track.Controller:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.LevelMap_Convey_Widget_PC.Btn_Cancel_Track.Controller:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.LevelMap_Convey_Widget_PC.Btn_Track.Controller:SetVisibility(ESlateVisibility.Collapsed)
        self.LevelMap_Convey_Widget_PC.Btn_Cancel_Track.Controller:SetVisibility(ESlateVisibility.Collapsed)
    end
end

return Component