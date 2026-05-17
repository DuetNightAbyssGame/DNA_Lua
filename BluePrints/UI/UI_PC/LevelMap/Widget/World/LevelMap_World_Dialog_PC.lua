--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type LevelMap_World_PC_C
local M = Class("BluePrints.UI.BP_UIState_C")
local TaskUtils = require "BluePrints.UI.TaskPanel.TaskUtils"
--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()
    self.Overridden.Construct(self)
    self.DeviceInPc = (CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile")
    self:InitAreaList()
    self.RealMousePos = FVector2D(0, 0)
    self.SelectBtnIdx = 0
    self.GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function M:Init(RootPage)
    self.RootPage = RootPage
    self:InitAreaBtn()
    self:InitAllAreaName()
    self:InitWorldMapSelect()
    -- self:AddStaticSubTouchItem("WorldMapLayer", self.Panel_Touch, {Down=self.OnWorldTouchDown,Move=self.OnWorldTouchMove,Up=self.OnWorldTouchUp})
end

function M:InitWorldMapSelect()
    if not self.GamepadSelect then
        self.GamepadSelect = UIManager(self):_CreateWidgetNew("WorldMapSelectControllerItem")
        self.Panel_MapSelect:GetParent():AddChild(self.GamepadSelect)
        self:AdjustSlot(self.GamepadSelect.Slot)
        self.GamepadSelect.Slot:SetZOrder(0)
    end
    self.GamepadSelect:SetVisibility(self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
    self.GamepadSelect:PlayAnimation(self.GamepadSelect.Normal)
end

function M:AdjustSlot(CanvasSlot)
    local half=UKismetMathLibrary.Vector2D_One()/2
    local anchors=CanvasSlot:GetAnchors()
    anchors.Minimum=half
    anchors.Maximum=half
    CanvasSlot:SetAnchors(anchors)
    CanvasSlot:SetAlignment(half)
end

function M:Tick(MyGeometry, InDeltaTime)
    self.Overridden.Tick(self, MyGeometry, InDeltaTime)
    if not self.RootPage or self.RootPage.ReturnHomePop or self.RootPage.HasOpenWildMap then
        return
    end
    self:GetMouseLocal()
    -- self:GetSelectImage()
    
    -- 手柄自动吸附检测
    if self.bCheckGamepadSelect then
        local CurrentTime = UGameplayStatics.GetRealTimeSeconds(self)
        -- 延迟检测（摇杆停止后约2帧触发）
        if CurrentTime - self.CheckGamepadSelectTime > InDeltaTime * 2 then
            self:CheckGamepadSelect()
            self.bCheckGamepadSelect = false
        end
    end
end

function M:InitAreaList()
    -- self.AreaBtnList = {
    --    self.Area01_Btn,
    --    self.Area02_Btn
    -- }
    local NameList = self.Panel_AreaName:GetAllChildren()
    self.AreaNameList = {}
    for i, v in pairs(NameList) do
        table.insert(self.AreaNameList, {
            NameWidget = v,
            Used = false,
            MapDataId = 1
        })
    end
    local RegionNameList = self.Panel_RegionName:GetAllChildren()
    self.RegionNameList = {}
    for i, v in pairs(RegionNameList) do
        table.insert(self.RegionNameList, {
            NameWidget = v,
            Used = false,
            MapDataId = 1
        })
    end
    -- self.HoverAreaList = {
    --    self.Hover_Area01,
    --    self.Hover_Area02,
    --    self.Hover_Area03,
    --    self.Hover_Area04,
    --    self.Hover_Area05,
    -- }
end

function M:InitAreaBtn()
    if self.DeviceInPc then
        -- self.Btn_Mouse.OnPressed:Add(self, self.OnMousePress)
        -- self.Btn_Mouse.OnReleased:Add(self, self.OnMouseRelease)
        -- self.Btn_Mouse.OnClicked:Add(self, self.OnMouseClick)
        self.Btn_Mouse:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        self.Btn_Mouse:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self:SetVisibility(UE4.ESlateVisibility.Visible)
    end
end

function M:InitAllAreaName()
    local TrackingQuestWorldMapId = TaskUtils:GetTrackingQuestMapInfo()
    self.NowHover = false
    local WorldMapDatas = DataMgr.WorldMap
    for i, AreaName in pairs(self.AreaNameList) do
        AreaName.Used = false
    end
    for i, WorldMapData in pairs(WorldMapDatas) do
        self:InitArea(i, WorldMapData, TrackingQuestWorldMapId)
    end
    for i, AreaName in pairs(self.AreaNameList) do
        if not AreaName.Used then
            self:LockRegion(i)
        end
    end
end

function M:InitArea(TableIndex, WorldMapData, TrackingQuestWorldMapId)
    -- if WorldMapData.UIRegionType == nil and self.RootPage.MapRegionType ~= "Now" then
    --    return
    -- elseif WorldMapData.UIRegionType ~= nil and WorldMapData.UIRegionType ~= self.RootPage.MapRegionType then
    --    return
    -- end
    local UIIndex = WorldMapData.UIIndex
    assert(#self.AreaNameList >= TableIndex, "表内地图点位数量超过蓝图内预留数量，联系蓝图添加，蓝图内数量："..#self.AreaNameList)
    local AreaName = self.AreaNameList[UIIndex].NameWidget
    if not self:CheckRegionUnLocked(TableIndex) then
        self:LockRegion(UIIndex)
    else
        self:UnLockRegion(UIIndex)
    end
    AreaName:Init({
        UIIndex = UIIndex,
        Used = self.AreaNameList[UIIndex].Used,
        WorldMapData = WorldMapData,
        RootPage = self
    })
    if self.AreaNameList[UIIndex].Used then
        assert(nil, "世界地图的UIIndex有重复，重复数值："..UIIndex)
    end
    self.AreaNameList[UIIndex].Used = true
    self.AreaNameList[UIIndex].MapDataId = WorldMapData.WorldMapId
    AreaName.Text_Name:SetText(GText(WorldMapData.WorldMapName))
    AreaName.Text_WorldText:SetText(EnText(WorldMapData.WorldMapName))
    AreaName.Text_CL:SetText(GText("UI_WORLDMAP_CURRENTLOCATION"))
    if self:CheckCurrentRegionId(WorldMapData.WorldMapId) then
        AreaName:PlayAnimation(AreaName.CurrentPosition_In)
    else
        AreaName:PlayAnimation(AreaName.CurrentPosition_Out)
    end
    local RegionUIIndex = WorldMapData.RegionUIIndex
    if RegionUIIndex and WorldMapData.RegionName then
        self.RegionNameList[RegionUIIndex].NameWidget:SetText(GText(WorldMapData.RegionName))
    end
    local IsInEXRegion = TaskUtils:CheckTaskIsInEXRegion()
    local Info = TaskUtils:GetTrackingQuestDetailInfo()
    if Info and Info.IsFairyLand then
        AreaName.HB_AreaDesc:SetVisibility(UE4.ESlateVisibility.Collapsed)
        AreaName.Panel_GuidePoint:SetVisibility(UE4.ESlateVisibility.Collapsed)
        AreaName.GuidePoint:SetVisibility(UE4.ESlateVisibility.Collapsed)
    elseif IsInEXRegion and self.RootPage.MapRegionType == "EX" then
        if UIIndex == TrackingQuestWorldMapId then
            AreaName.HB_AreaDesc:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            AreaName.Panel_GuidePoint:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            AreaName.GuidePoint:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            local IconTexture = TaskUtils:GetIconTextureByTrackQuestChainType()
            if IconTexture then
                AreaName.GuidePoint.Img_GuidePoint_Icon:SetBrushResourceObject(IconTexture)
            end
            AreaName.Text_AreaDesc:SetText(GText("UI_QUEST_MAP"))
        else
            AreaName.HB_AreaDesc:SetVisibility(UE4.ESlateVisibility.Collapsed)
            AreaName.Panel_GuidePoint:SetVisibility(UE4.ESlateVisibility.Collapsed)
            AreaName.GuidePoint:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    elseif not IsInEXRegion and self.RootPage.MapRegionType == "Now" then
        if UIIndex == TrackingQuestWorldMapId then
            AreaName.HB_AreaDesc:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            AreaName.Panel_GuidePoint:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            AreaName.GuidePoint:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            local IconTexture = TaskUtils:GetIconTextureByTrackQuestChainType()
            if IconTexture then
                AreaName.GuidePoint.Img_GuidePoint_Icon:SetBrushResourceObject(IconTexture)
            end
            AreaName.Text_AreaDesc:SetText(GText("UI_QUEST_MAP"))
        else
            AreaName.HB_AreaDesc:SetVisibility(UE4.ESlateVisibility.Collapsed)
            AreaName.Panel_GuidePoint:SetVisibility(UE4.ESlateVisibility.Collapsed)
            AreaName.GuidePoint:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    else
        AreaName.HB_AreaDesc:SetVisibility(UE4.ESlateVisibility.Collapsed)
        AreaName.Panel_GuidePoint:SetVisibility(UE4.ESlateVisibility.Collapsed)
        AreaName.GuidePoint:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

-- function M:OnChangeTimeLine(PreRegionType)
--    if self:IsAnimationPlaying(self.ChangeTime) then
--        return
--    end
--    if PreRegionType == "EX" then
--        self:PlayAnimation(self.ChangeTime)
--    else
--        self:PlayAnimationReverse(self.ChangeTime)
--    end
--    self:InitAllAreaName()
-- end

function M:LockRegion(Index)
    -- self["Panel_Area"..string.format("%02d", Index)]:SetVisibility(ESlateVisibility.Collapsed)
    self.AreaNameList[Index].NameWidget:SetVisibility(ESlateVisibility.Collapsed)
    -- self.AreaBtnList[Index] = nil
end

function M:UnLockRegion(Index)
    -- self["Panel_Area"..string.format("%02d", Index)]:SetVisibility(ESlateVisibility.HitTestInvisible)
    self.AreaNameList[Index].NameWidget:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    -- self.AreaBtnList[Index] = self["Area"..string.format("%02d", Index).."_Btn"]
end

function M:OnDragMap()
    self.bCanDragMap = true
    self.bDragNeedBack = false
    if self.DragBackhandle then
        ULTweenBPLibrary.KillIfIsTweening(self, self.DragBackhandle)
        self.DragBackhandle = nil
    end
end

function M:OnStopDragMap()
    self.HasMoved = false
    self.bCanDragMap = false

    if self.bDragNeedBack then
        local Start = self.Panel_Drag.RenderTransform.Translation
        local Limit = UIManager(self):GetWidgetRenderSize(self.CanvasPanel_20)/2
        local End = FVector2D(Start.X, Start.Y)
        if Start.X < -Limit.X then
            End.X = -Limit.X
        end
        if Start.X > Limit.X then
            End.X = Limit.X
        end
        if Start.Y < -Limit.Y then
            End.Y = -Limit.Y
        end
        if Start.Y > Limit.Y then
            End.Y = Limit.Y
        end
        self.DragBackhandle = UE4.ULTweenBPLibrary.Vector2To(self,{self,function(_,value)
            self:SetTranslation(value)
        end},Start,End,0.5,0, 17)
        self.DragBackhandle:OnComplete({self,function() 
            self.bDragNeedBack = false
        end})
        local LTweenActor = UE4.ALTweenActor.GetLTweenInstance(self.DragBackhandle)
        if LTweenActor then
            LTweenActor:SetTickableWhenPaused(true)
        end
    end
end

function M:ResetTranslation()
    local Loc = FVector2D(0, 0)
    self:SetTranslation(Loc)
end

function M:SetTranslation(Loc)
    DebugPrint("JLY SetTranslation", Loc.X, Loc.Y)
    self.Panel_Drag:SetRenderTranslation(Loc)
end


function M:UpdateMapOffset(DeltaLoc)
    if not self.bCanDragMap and not self.bDragNeedBack then
        return
    end
    local DragLimitOffset=UIManager(self):GetWidgetRenderSize(self.CanvasPanel_20)/2
    
    local OriginLoc = {}
    OriginLoc["Panel_Drag"] = self.Panel_Drag.RenderTransform.Translation
    self.HasMoved = true

    local NextTrans = OriginLoc["Panel_Drag"] + DeltaLoc
    if NextTrans.X > DragLimitOffset.X or NextTrans.X < -DragLimitOffset.X then
        self.bDragNeedBack = true
    end
    if NextTrans.Y > DragLimitOffset.Y or NextTrans.Y < -DragLimitOffset.Y then
        self.bDragNeedBack = true
    end
    self:SetTranslation(NextTrans)
end

function M:OnPointerMove(MyGeometry, MouseEvent)
    if self.bCheckGamepadSelect then
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
    local DeltaLoc = UE4.UKismetInputLibrary.PointerEvent_GetCursorDelta(MouseEvent)
    if self.bCanDragMap and not UE4.UKismetMathLibrary.EqualEqual_Vector2DVector2D(DeltaLoc, UE4.UKismetMathLibrary.Vector2D_Zero(), 0.001) then
        self:UpdateMapOffset(DeltaLoc)
    end
    local MouseViewPortPos = UE4.UWidgetLayoutLibrary.GetMousePositionOnViewport(self)
    local ViewportPos = FVector2D(0, 0)
    UE4.USlateBlueprintLibrary.LocalToViewport(self, self.CanvasPanel_20:GetCachedGeometry(), FVector2D(0,0), nil, ViewportPos)
    local Size = UWidgetLayoutLibrary.GetViewportSize(self)
    local Scale = UWidgetLayoutLibrary.GetViewportScale(self)
    self.NewPosition = MouseViewPortPos - ViewportPos - Size/Scale/2
    if(self.HoverBtnIdx == nil) then
        local Slot1 = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Select)
        Slot1:SetPosition(self.NewPosition)
        self.Select:StopAnimation(self.Select.Hover)
        self.Select:PlayAnimation(self.Select.Normal)
    end
    local Handled = UE4.UWidgetBlueprintLibrary.Handled()
    return Handled
end

function M:OnPointerUp(MyGeometry, MouseEvent)
    if self.bCheckGamepadSelect then
        print(_G.LogTag,"LXZ OnPointerUp bCheckGamepadSelect")
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
    self.IsPointerDown = false
    print(_G.LogTag,"LXZ OnPointerUp")
    self:OnStopDragMap()
    if self.HasMoved then
        return UE4.UWidgetBlueprintLibrary.Unhandled()
    end
    if self.SelectBtnIdx == 0 then
        return UE4.UWidgetBlueprintLibrary.Unhandled()
    end
    self:OnClickArea(self.AreaNameList[self.SelectBtnIdx].MapDataId)
    self.SelectBtnIdx = 0
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:Handle_KeyEventOnGamePad(InKeyName)
    if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
        DebugPrint("jly Handle_KeyEventOnGamePad", InKeyName)
        if self.bCheckGamepadSelect then
            print(_G.LogTag,"LXZ OnPointerUp bCheckGamepadSelect")
            return UE4.UWidgetBlueprintLibrary.UnHandled()
        end
        self.IsPointerDown = false
        print(_G.LogTag,"LXZ OnPointerUp")
        self:OnStopDragMap()
        if self.HasMoved then
            return UE4.UWidgetBlueprintLibrary.Unhandled()
        end
        if self.HoverBtnIdx == 0 then
            return UE4.UWidgetBlueprintLibrary.Unhandled()
        end
        self:OnClickArea(self.AreaNameList[self.HoverBtnIdx].MapDataId)
        if self.IsGamepadSelect then
            self.IsGamepadSelect = false
            self.GamepadSelect:PlayAnimation(self.GamepadSelect.UnHover)
    
            self:UpdateRootPageGamepadKey(false)
            self.GamepadSelect.Slot:SetZOrder(2)
        end
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
end

function M:OnPointerDown(MyGeometry, MouseEvent)
    if self.bCheckGamepadSelect then
        print(_G.LogTag,"LXZ OnPointerDown bCheckGamepadSelect")
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
    print(_G.LogTag,"LXZ OnPointerDown")
    self.IsPointerDown = true
    if UKismetInputLibrary.PointerEvent_IsMouseButtonDown(MouseEvent, EKeys.LeftMouseButton) then
        self:OnDragMap()
    elseif UKismetInputLibrary.PointerEvent_IsTouchEvent(MouseEvent) then
        self:OnDragMap()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnMouseLeave(Event)
    if self.bCanDragMap then
        self:OnPointerUp(nil,Event)
    end
end

function M:OnItemHover()
    -- 设置Select的位置
    local NameWidget = self.AreaNameList[self.HoverBtnIdx].NameWidget
    local Pos = FVector2D(0,0)
    UE4.USlateBlueprintLibrary.LocalToViewport(self, NameWidget:GetCachedGeometry(), FVector2D(0,0), nil, Pos)
    -- 策划要求，手柄的时候不播这个十字特效
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        DebugPrint("JLY OnItemHover Gamepad")
        self.GamepadSelect:PlayAnimation(self.GamepadSelect.Hover)
        self:UpdateRootPageGamepadKey(true)
        self.GamepadSelect.Slot:SetZOrder(0)
    else
        self:PlaySelectAnimation(Pos, NameWidget)
    end
end

function M:OnItemUnhover()
    if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
        if self.Select then
            self.Select:StopAnimation(self.Select.Hover)
            self.Select:PlayAnimation(self.Select.Normal)
        end
    end
end

function M:OnTouchStarted(MyGeometry, InTouchEvent)
    if self.bCheckGamepadSelect then
        return
    end
    if self.DeviceInPc then
        return
    end
    self:OnPointerDown(MyGeometry, InTouchEvent)
    local UnHandled = UE4.UWidgetBlueprintLibrary.UnHandled()
    return UnHandled
end

function M:OnTouchMoved(MyGeometry, InTouchEvent)
    if self.bCheckGamepadSelect then
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
    if self.DeviceInPc then
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
    self:OnPointerMove(MyGeometry, InTouchEvent)
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnTouchEnded(MyGeometry, InTouchEvent)
    if self.bCheckGamepadSelect then
        return
    end
    if self.DeviceInPc then
        return
    end
    
    self:OnPointerUp(MyGeometry, InTouchEvent)
    local UnHandled = UE4.UWidgetBlueprintLibrary.UnHandled()
    if self.SelectBtnIdx == 0 then
        return UnHandled
    end
    self:OnClickArea(self.AreaNameList[self.SelectBtnIdx].MapDataId)
    self.SelectBtnIdx = 0
    return UnHandled
end

--废弃，后续需要不规则按钮再启用
function M:GetSelectImage()
    if self.RealMousePos == false then
        return
    end
    -- for i, Btn in pairs(self.AreaBtnList) do
    --    local Slot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(Btn)
    --    local BtnSize = Slot:GetSize()
    --    local Pos = FVector2D(0,0)
    --    UE4.USlateBlueprintLibrary.LocalToViewport(self, Btn:GetCachedGeometry(), FVector2D(0,0), nil, Pos)
    --    local Rate = (self.RealMousePos - Pos)/BtnSize
    --    local Alpha = Btn:GetMousePosAlpha(Rate)
    --    if Alpha > 0 then
    --        self.SelectBtnIdx = i;
    --        self:OnHoveredArea(self.HoverAreaList[i])
    --        return
    --    end
    -- end
    for i, NameWidget in pairs(self.AreaNameList) do
        local Slot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(NameWidget)
        local Size = Slot:GetSize()
        local Pos = FVector2D(0,0)
        UE4.USlateBlueprintLibrary.LocalToViewport(self, NameWidget:GetCachedGeometry(), FVector2D(0,0), nil, Pos)
        local Rate = (self.RealMousePos - Pos)/Size
        if Rate.X < 1 and Rate.Y < 1 then
            self.SelectBtnIdx = i;
            self:OnHoveredArea(self.HoverAreaList[i])
            return
        end
    end
    self:HideHover()
    self.SelectBtnIdx = 0
end

function M:GetMouseLocal()
    if self.DeviceInPc then
        self.RealMousePos = UE4.UWidgetLayoutLibrary.GetMousePositionOnViewport(self)
    end
end

function M:HideWorldMap()
    if self:GetVisibility() == UE4.ESlateVisibility.Collapsed then
        return
    end
    self:StopAnimation(self.In)
    self:SetVisibility(UE4.ESlateVisibility.Collapsed) 
    self:PlayAnimation(self.Out)
end

function M:ShowWorldMap()
    if self:GetVisibility() == 0 then
        return
    end
    self:StopAnimation(self.Out)
    self:PlayAnimation(self.In)
    self:SetVisibility(UE4.ESlateVisibility.Visible)
end
--------------------- Hover ----------------
function M:HideHover()
    for i, Hover in pairs(self.HoverAreaList) do
        if Hover == self.NowHover then
            self.AreaNameList[i].NameWidget:StopAnimation(self.AreaNameList[i].NameWidget.Hover)
            self:StopAnimation(self["Hover_"..string.format("%02d", i)])
            self:PlayAnimation(self["Normal_"..string.format("%02d", i)])
            Hover:SetRenderOpacity(0.4)
            UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self["Panel_Area"..string.format("%02d", i)]):SetZOrder(0)
            break
        end
    end
    --清空NowHover，同时防止它变成nil导致下一次还要重新遍历所有变量
    self.NowHover = false
end

function M:OnHoveredArea(AreaHover)
    if not self.DeviceInPc then
        return
    end
    if self.NowHover == AreaHover then
        return
    end
    self:HideHover()
    self.AreaNameList[self.SelectBtnIdx].NameWidget:StopAnimation(self.AreaNameList[self.SelectBtnIdx].NameWidget.Normal)
    self:StopAnimation(self["Normal_"..string.format("%02d", self.SelectBtnIdx)])
    self:PlayAnimation(self["Hover_"..string.format("%02d", self.SelectBtnIdx)])
    UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self["Panel_Area"..string.format("%02d", self.SelectBtnIdx)]):SetZOrder(1)
    self.NowHover = AreaHover
    -- 设置Select的位置
    local NameWidget = self.AreaNameList[self.SelectBtnIdx].NameWidget
    local Pos = FVector2D(0,0)
    UE4.USlateBlueprintLibrary.LocalToViewport(self, NameWidget:GetCachedGeometry(), FVector2D(0,0), nil, Pos)
    self:PlaySelectAnimation(Pos, NameWidget)
    AudioManager(self):PlayUISound(self, "event:/ui/common/map_hover_level", "", nil)
end

function M:PlaySelectAnimation(Pos, NameWidget)
    if self.Select then
        local selectSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Select)
        if selectSlot then
            local ViewportPos = FVector2D(0, 0)
            UE4.USlateBlueprintLibrary.LocalToViewport(self, self.CanvasPanel_20:GetCachedGeometry(), FVector2D(0,0), nil, ViewportPos)
            local Size = UWidgetLayoutLibrary.GetViewportSize(self)
            local Scale = UWidgetLayoutLibrary.GetViewportScale(self)
            local Position = Pos - ViewportPos - Size/Scale/2
            local NameWidgetSize = NameWidget:GetDesiredSize()
            Position.X = Position.X + NameWidgetSize.X/2
            Position.Y = Position.Y + NameWidgetSize.Y/2
            selectSlot:SetPosition(Position)
            self.Select:StopAnimation(self.Select.Normal)
            self.Select:PlayAnimation(self.Select.Hover)
        end
    end
end

--------------------- Click ----------------
function M:OnClickArea(AreaIdx)
    print(_G.LogTag,"LXZ OnClickArea", AreaIdx)
    local MainRegionData
    for i,v in pairs(DataMgr.WorldMap[AreaIdx].WorldMapRegion) do
        local RegionMapData = DataMgr.RegionMap[v]
        if RegionMapData.MainRegionMap == true then
            MainRegionData = RegionMapData
        end
    end
    local FirstRegionMapId = DataMgr.WorldMap[AreaIdx].WorldMapRegion[1]
    local MainRegionId = DataMgr.RegionMap[FirstRegionMapId].RegionId
    if MainRegionData then
        MainRegionId = MainRegionData.RegionId
    end
    self.RootPage.CurrentMainRegionId = MainRegionId
    self.RootPage.Tab:SelectTab(2)
    -- local WildMap = self.RootPage:LoadOrUnLoadWildMap(true)
    -- WildMap:Init(false, MainRegionId, self.RootPage)
    -- self.RootPage.AreaInfo:SetVisibility(UE4.ESlateVisibility.Visible)

    AudioManager(self):PlayUISound(self, "event:/ui/common/map_click_chapter", "", nil)
end

---------------------Tool----------------------
function M:CheckCurrentRegionId(AreaIdx)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    local CurrentRegionId = Avatar.CurrentRegionId//100
    for i,v in pairs(DataMgr.WorldMap[AreaIdx].WorldMapRegion) do
        local RegionMapData = DataMgr.RegionMap[v]
        if RegionMapData.RegionId == CurrentRegionId then
            return true
        end
    end
    return false
end

function M:CheckRegionUnLocked(AreaIdx)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return true
    end
    local ConditionId = DataMgr.WorldMap[AreaIdx].WorldMapUnlockCondition
    local Avatar = GWorld:GetAvatar()
    if not ConditionId or ConditionUtils.CheckCondition(Avatar, ConditionId) or Const.UnlockRegionTeleport then
        return true
    end
    return false
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    self.CurInputDevice = CurInputDevice
    self.CurGamepadName = CurGamepadName
    if CurInputDevice == ECommonInputType.Gamepad then
        self.GamepadSelect:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
    else
        self.GamepadSelect:SetVisibility(ESlateVisibility.Collapsed)
        self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
        self.Select:StopAnimation(self.Select.Hover)
        self.Select:PlayAnimation(self.Select.Normal)
        self.bCanDragMap = false
    end
end

-- 手柄拖拽逻辑
function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
    if self.IsPointerDown then
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    
    -- 初始化增量
    if not self.CurrentAnalogDelta then
        self.CurrentAnalogDelta = FVector2D(0, 0)
    else
        self.CurrentAnalogDelta:Set(0, 0)
    end
    
    -- 获取拖拽限制（边界）
    local DragLimitOffset = UIManager(self):GetWidgetRenderSize(self.CanvasPanel_20)/2
    
    -- 获取当前地图偏移
    local CurrentOffset = self.Panel_Drag.RenderTransform.Translation
    
    -- 左摇杆X轴（左右拖拽）
    if InKeyName == UIConst.GamePadKey.LeftAnalogX then
        local DeltaX = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * -15
        -- 检查是否超出边界
        if CurrentOffset.X + DeltaX > DragLimitOffset.X or CurrentOffset.X + DeltaX < -DragLimitOffset.X then
            DeltaX = 0
        end
        self.CurrentAnalogDelta:Set(DeltaX, 0)
        
    -- 左摇杆Y轴（上下拖拽）
    elseif InKeyName == UIConst.GamePadKey.LeftAnalogY then
        local DeltaY = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 15
        -- 检查是否超出边界
        if CurrentOffset.Y + DeltaY > DragLimitOffset.Y or CurrentOffset.Y + DeltaY < -DragLimitOffset.Y then
            DeltaY = 0
        end
        self.CurrentAnalogDelta:Set(0, DeltaY)
    end
    
    -- 如果增量为0，直接返回
    if UKismetMathLibrary.EqualEqual_Vector2DVector2D(self.CurrentAnalogDelta, UKismetMathLibrary.Vector2D_Zero(), 2.25) then
        return UWidgetBlueprintLibrary.Handled()
    end
    
    -- 设置手柄自动吸附检测标记
    self.bCheckGamepadSelect = true
    self.CheckGamepadSelectTime = UGameplayStatics.GetRealTimeSeconds(self)
    
    self.GamepadSelectState = false
    self.GamepadSelectPoint = nil
    
    -- 更新地图偏移
    self.bCanDragMap = true
    self:UpdateMapOffset(self.CurrentAnalogDelta)
    

    if self.IsGamepadSelect then
        self.IsGamepadSelect = false
        self.GamepadSelect:PlayAnimation(self.GamepadSelect.UnHover)
        self.Select:StopAnimation(self.Select.Hover)
        self.Select:PlayAnimation(self.Select.Normal)

        self:UpdateRootPageGamepadKey(false)
        self.GamepadSelect.Slot:SetZOrder(2)
    end
    return UWidgetBlueprintLibrary.Handled()
end

--- 检测手柄自动吸附（摇杆停止后自动吸附到最近的区域）
function M:CheckGamepadSelect()
    if not self.GamepadSelectState then
        self.GamepadSelectState = true
        
        -- 获取屏幕中心的实际屏幕坐标
        local ViewportSize = UWidgetLayoutLibrary.GetViewportSize(self)
        local ViewportScale = UWidgetLayoutLibrary.GetViewportScale(self)
        local ScreenCenter = ViewportSize / ViewportScale / 2
        
        DebugPrint("JLY ViewportSize:", ViewportSize.X, ViewportSize.Y)
        DebugPrint("JLY ViewportScale:", ViewportScale)
        DebugPrint("JLY ScreenCenter:", ScreenCenter.X, ScreenCenter.Y)
        
        -- 检测屏幕中心附近的区域名称Widget（同时返回Widget的屏幕位置）
        local AreaIdx, WidgetScreenCenter = self:CheckSelectAreaByPosition(ScreenCenter, FVector2D(100, 100))
        self.GamepadSelectAreaIdx = AreaIdx
        
        if self.GamepadSelectAreaIdx and WidgetScreenCenter then
            -- 直接使用检测时获取的屏幕位置，移动地图使Widget居中
            self:MoveMapToScreenPosition(WidgetScreenCenter, ScreenCenter)
            
            -- 播放区域悬停动画
            self.HoverBtnIdx = self.GamepadSelectAreaIdx
            self:OnItemHover()
            self.IsGamepadSelect = true
        else
            self.IsGamepadSelect = false
            self.GamepadSelectAreaIdx = nil
        end
    end
end

--- 检测指定位置附近的区域（世界地图专用）
---@param ScreenPos FVector2D 检测位置（屏幕绝对坐标）
---@param Size FVector2D 检测范围
---@return number|nil 最近的区域索引
---@return FVector2D|nil 选中区域的屏幕中心位置
function M:CheckSelectAreaByPosition(ScreenPos, Size)
    local MinDistance = nil
    local MinDisAreaIdx = nil
    local MinDisWidgetCenter = nil
    
    -- 遍历所有已使用的区域名称Widget
    for i, AreaData in pairs(self.AreaNameList) do
        if AreaData.Used and AreaData.NameWidget:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
            -- 获取Widget的实际屏幕位置
            local WidgetGeometry = AreaData.NameWidget:GetCachedGeometry()
            local WidgetScreenPos = FVector2D(0, 0)
            USlateBlueprintLibrary.LocalToViewport(self, WidgetGeometry, FVector2D(0, 0), nil, WidgetScreenPos)
            
            -- 获取Widget的大小（用于计算中心点）
            local WidgetSize = USlateBlueprintLibrary.GetLocalSize(WidgetGeometry)
            local WidgetCenter = WidgetScreenPos + WidgetSize / 2
            
            DebugPrint("JLY Area", i, "ScreenPos:", WidgetCenter.X, WidgetCenter.Y)
            DebugPrint("JLY CheckPos:", ScreenPos.X, ScreenPos.Y, "Range:", Size.X, Size.Y)
            
            -- 检测是否在范围内（矩形碰撞）
            if math.abs(ScreenPos.X - WidgetCenter.X) <= Size.X 
            and math.abs(ScreenPos.Y - WidgetCenter.Y) <= Size.Y then
                -- 计算距离，选择最近的
                local Distance = UKismetMathLibrary.Distance2D(ScreenPos, WidgetCenter)
                DebugPrint("JLY Area", i, "在范围内! Distance:", Distance)
                if not MinDistance or MinDistance > Distance then
                    MinDistance = Distance
                    MinDisAreaIdx = i
                    MinDisWidgetCenter = WidgetCenter  -- 保存Widget中心位置
                end
            end
        end
    end
    
    if MinDisAreaIdx then
        DebugPrint("JLY 最终选中区域:", MinDisAreaIdx, "Distance:", MinDistance)
        DebugPrint("JLY Widget中心位置:", MinDisWidgetCenter.X, MinDisWidgetCenter.Y)
    else
        DebugPrint("JLY 未找到附近的区域")
    end
    
    return MinDisAreaIdx, MinDisWidgetCenter
end

--- 移动地图使Widget移动到屏幕中心（世界地图专用）
---@param WidgetScreenCenter FVector2D Widget当前的屏幕中心位置
---@param ScreenCenter FVector2D 屏幕中心位置
function M:MoveMapToScreenPosition(WidgetScreenCenter, ScreenCenter)
    -- 如果正在回弹动画中，停止吸附
    if self.bDragNeedBack or self.DragBackhandle then
        return
    end
    
    -- 计算需要移动的屏幕距离
    local ScreenDelta = ScreenCenter - WidgetScreenCenter
    
    DebugPrint("JLY WidgetScreenCenter:", WidgetScreenCenter.X, WidgetScreenCenter.Y)
    DebugPrint("JLY ScreenCenter:", ScreenCenter.X, ScreenCenter.Y)
    DebugPrint("JLY ScreenDelta:", ScreenDelta.X, ScreenDelta.Y)
    
    -- 将屏幕增量转换为地图偏移增量
    -- 因为地图是通过 UpdateMapOffset 移动的，所以直接加到当前偏移上
    local CurrentOffset = self.Panel_Drag.RenderTransform.Translation
    local TargetOffset = CurrentOffset + ScreenDelta
    
    DebugPrint("JLY CurrentOffset:", CurrentOffset.X, CurrentOffset.Y)
    DebugPrint("JLY TargetOffset:", TargetOffset.X, TargetOffset.Y)
    
    -- 检查目标位置是否超出边界
    local DragLimitOffset = UIManager(self):GetWidgetRenderSize(self.CanvasPanel_20)/2
    if TargetOffset.X < -DragLimitOffset.X then
        TargetOffset.X = -DragLimitOffset.X
    elseif TargetOffset.X > DragLimitOffset.X then
        TargetOffset.X = DragLimitOffset.X
    end
    if TargetOffset.Y < -DragLimitOffset.Y then
        TargetOffset.Y = -DragLimitOffset.Y
    elseif TargetOffset.Y > DragLimitOffset.Y then
        TargetOffset.Y = DragLimitOffset.Y
    end
    
    -- 执行平滑移动动画（同步移动所有面板）
    if self.GamepadSelectTween then
        ULTweenBPLibrary.KillIfIsTweening(self, self.GamepadSelectTween)
        self.GamepadSelectTween = nil
    end
    
    self.GamepadSelectTween = UE4.ULTweenBPLibrary.Vector2To(self, {self, function(_, value)
        self:SetTranslation(value)
    end}, CurrentOffset, TargetOffset, 0.3, 0, 17)  -- 0.3秒动画，缓动类型17（OutCirc）
    
    self.GamepadSelectTween:OnComplete({self, function()
        self.GamepadSelectTween = nil
        -- 设置Select的位置
        local NameWidget = self.AreaNameList[self.HoverBtnIdx].NameWidget
        local Pos = FVector2D(0,0)
        UE4.USlateBlueprintLibrary.LocalToViewport(self, NameWidget:GetCachedGeometry(), FVector2D(0,0), nil, Pos)
        self:PlaySelectAnimation(Pos, NameWidget)
    end})
    
    local LTweenActor = UE4.ALTweenActor.GetLTweenInstance(self.GamepadSelectTween)
    if LTweenActor then
        LTweenActor:SetTickableWhenPaused(true)
    end
end

function M:UpdateRootPageGamepadKey(isGoto)
    local GamepadKeys = {}
    if isGoto then
        GamepadKeys = {
            {
                KeyInfoList={
                    {
                        Type="Img",
                        ImgShortPath="A"
                    }
                },
                Desc = GText("UI_Controller_Go"),
            },
            {
                KeyInfoList={
                    {
                        Type="Img",
                        ImgShortPath="B"
                    }
                },
                Desc = GText("UI_BACK"),
            }
        }
    else
        GamepadKeys = {
            {
                KeyInfoList={
                    {
                        Type="Img",
                        ImgShortPath="B"
                    }
                },
                Desc = GText("UI_BACK"),
            }
        }
    end
    self.RootPage.Key_Tip:UpdateKeyInfo(GamepadKeys)
end

return M
