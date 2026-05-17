require "UnLua"

local Component = {}

function Component:InitComponentCoroutine()
    local Coroutine = CreateCoroutine(self.InitDispatchPoint)
    table.insert(self.InitCoroutines, Coroutine)
    coroutine.resume(Coroutine, self, #self.InitCoroutines)
end

function Component:AddComponentEvent()
    EventManager:AddEvent(EventID.StartDispatch,self,self.StartDispatch)
    EventManager:AddEvent(EventID.CancelDispatch, self, self.CancelDispatch)
    EventManager:AddEvent(EventID.CompleteDispatch, self, self.CompleteDispatch)
    EventManager:AddEvent(EventID.GetAllDispatchReward, self, self.GetAllDispatchReward)
    EventManager:AddEvent(EventID.OnDispatchOverdate, self, self.OnDispatchOverdate)
    EventManager:AddEvent(EventID.OnDispatchComplete, self, self.OnDispatchComplete)
    EventManager:AddEvent(EventID.OnActiveDynamicQuest, self, self.OnActiveDynamicQuest)
    EventManager:AddEvent(EventID.GoToDispatch,self,self.OnDispatchTrace)
end

function Component:RemoveComponentEvent()
    EventManager:RemoveEvent(EventID.StartDispatch,self)
    EventManager:RemoveEvent(EventID.CancelDispatch,self)
    EventManager:RemoveEvent(EventID.CompleteDispatch,self)
    EventManager:RemoveEvent(EventID.GetAllDispatchReward,self)
    EventManager:RemoveEvent(EventID.OnDispatchOverdate, self)
    EventManager:RemoveEvent(EventID.OnDispatchComplete, self)
    EventManager:RemoveEvent(EventID.OnActiveDynamicQuest, self)
    EventManager:RemoveEvent(EventID.GoToDispatch,self)
end

function Component:ClearData()
    if next(self.DispatchPoint) then
        for Id, Item in pairs(self.DispatchPoint) do
            if Item then
                Item:RemoveFromParent()
            end
        end
        self.DispatchPoint = {}
    end
    if next(self.DispatchSelect) then
        for Id, Item in pairs(self.DispatchSelect) do
            if Item then
                Item:RemoveFromParent()
            end
        end
        self.DispatchSelect = {}
    end

    if next(self.DispatchLocations) then
        self.DispatchLocations = {}
    end
end

function Component:InitDispatchPoint(CoroutineIndex)
    local Avatar = GWorld:GetAvatar()
    if Avatar == nil or self.IsMiniMap then
        self:InitCoroutineCheck(CoroutineIndex)
        return
    end
    for Id, Dispatch in pairs(Avatar.Dispatches) do
        if (Dispatch.State == CommonConst.DispatchState.Success or Dispatch.State == CommonConst.DispatchState.Perfect or Dispatch.State == CommonConst.DispatchState.Qualified or
            Dispatch.State == CommonConst.DispatchState.Disqualified) then
            if Dispatch.RegionId == self.RegionID and self.DispatchPoint[Id] == nil then
                local Point = nil
                -- local Path = '/Game/UI/WBP/Map/Widget/Dispatch/WBP_Map_DispatchPointInfo.WBP_Map_DispatchPointInfo'
                if CoroutineIndex == nil then
                    Point = UIManager(self):_CreateWidgetNew("RegionMapDispatchPointInfo")
                else
                    Point = UIManager(self):CreateWidgetAsync("RegionMapDispatchPointInfo", self.InitCoroutines[CoroutineIndex])
                end
                self.Panel_Point:AddChild(Point)
                local function AdjustSlot(Point)
                    Point:SetAlignment(FVector2D(0.5, 0.5))
                    Point:SetAutoSize(true)
                    local Anchors = FAnchors()
                    Anchors.Minimum = FVector2D(0.5, 0.5)
                    Anchors.Maximum = FVector2D(0.5, 0.5)
                    Point:SetAnchors(Anchors)
                    local Offset = FMargin()
                    Offset.Left = 0
                    Offset.Top = 0
                    Point:SetOffsets(Offset)
                end
                AdjustSlot(Point.Slot)
                local UIPos = DataMgr.DispatchUI[Dispatch.DispatchId].UIPos
                local Pos = self:TransformWorldLocToUILoc(UIPos[1], UIPos[2])
                Point:SetRenderTranslation(Pos)
                Point:Init(Dispatch, self)
                self.DispatchPoint[Id] = Point             
                self.DispatchLocations[Id] = Pos
            end
        end
    end
    --遍历随机到的派遣
    for _, DispatchListProp in ipairs(Avatar.CurrentDispatchList) do
        local Id = DispatchListProp:GetDispatchId()
        --有效的id
        if Id ~= -1 then
            local Dispatch = Avatar.Dispatches[Id]
            if self.DispatchPoint[Id] == nil then            
                if Dispatch.RegionId == self.RegionID then
                    local Point = nil
                    -- local Path = '/Game/UI/WBP/Map/Widget/Dispatch/WBP_Map_DispatchPointInfo.WBP_Map_DispatchPointInfo'
                    if CoroutineIndex == nil then
                        Point = UIManager(self):_CreateWidgetNew("RegionMapDispatchPointInfo")
                    else
                        Point = UIManager(self):CreateWidgetAsync("RegionMapDispatchPointInfo", self.InitCoroutines[CoroutineIndex])
                    end
                    --local Point = UIManager(self):CreateWidgetAsync("RegionMapDispatchPointInfo", self.InitCoroutines[CoroutineIndex])
                    self.Panel_Point:AddChild(Point)
                    local function AdjustSlot(Point)
                        Point:SetAlignment(FVector2D(0.5, 0.5))
                        Point:SetAutoSize(true)
                        local Anchors = FAnchors()
                        Anchors.Minimum = FVector2D(0.5, 0.5)
                        Anchors.Maximum = FVector2D(0.5, 0.5)
                        Point:SetAnchors(Anchors)
                        local Offset = FMargin()
                        Offset.Left = 0
                        Offset.Top = 0
                        Point:SetOffsets(Offset)
                        Point:SetZOrder(0)
                    end
                    AdjustSlot(Point.Slot)
                    local UIPos = DataMgr.DispatchUI[Dispatch.DispatchId].UIPos
                    local Pos = self:TransformWorldLocToUILoc(UIPos[1], UIPos[2])
                    Point:SetRenderTranslation(Pos)
                    Point:Init(Dispatch, self)          
                    self.DispatchPoint[Id] = Point
                    self.DispatchLocations[Id] = Pos
                end
            end
        end   
    end

    for Id, Ponit in pairs(self.DispatchPoint) do
        if self.DispatchSelect[Id] == nil then
            local Select = nil
            if CoroutineIndex == nil then
                Select = UIManager(self):_CreateWidgetNew("RegionMapSelect")
            else
                Select = UIManager(self):CreateWidgetAsync("RegionMapSelect", self.InitCoroutines[CoroutineIndex])
            end
            self.Panel_Point:AddChild(Select)

            local function AdjustSlot(Point)
                Point:SetAlignment(FVector2D(0.5, 0.5))
                Point:SetAutoSize(true)
                local Anchors = FAnchors()
                Anchors.Minimum = FVector2D(0.5, 0.5)
                Anchors.Maximum = FVector2D(0.5, 0.5)
                Point:SetAnchors(Anchors)
                local Offset = FMargin()
                Offset.Left = 0
                Offset.Top = 0
                Point:SetOffsets(Offset)
                Point:SetZOrder(10)
            end
            AdjustSlot(Select.Slot)
            Select:SetRenderTranslation(self.DispatchLocations[Id])          
            self.DispatchSelect[Id] = Select
            Select:SetVisibility(ESlateVisibility.Collapsed)
        end  
    end
    self:InitCoroutineCheck(CoroutineIndex)
end

function Component:OnScaleChange_Component(Percent)
    if not self.DispatchPoint or not self.DispatchSelect then
        return
    end
    for Id,Point in pairs(self.DispatchPoint) do
        local UIPos = DataMgr.DispatchUI[Id].UIPos
        local Pos = self:TransformWorldLocToUILoc(UIPos[1], UIPos[2])
        Point:SetRenderTranslation(Pos)
    end
    for Id, Point in pairs(self.DispatchSelect) do
        local UIPos = DataMgr.DispatchUI[Id].UIPos
        local Pos = self:TransformWorldLocToUILoc(UIPos[1], UIPos[2])
        Point:SetRenderTranslation(Pos)
    end
end

function Component:RefreshDispatchMap(RegionId, DispatchId)
    if RegionId ~= self.RegionID then
        self:ChangeRegion(RegionId, function()
            self:CloseForDispatch(true)
            self:OnPanelOpen(5)
            local UIPos = DataMgr.DispatchUI[DispatchId].UIPos
            if UIPos then
                local Pos = self:TransformWorldLocToUILoc(UIPos[1], UIPos[2])
                self:MoveMapTo(Pos * -1)
                self:RefreshDispatchSelect()
                self:RefreshSingleDispatchPoint()
                self:DispatchSelectClick(DispatchId)
                local Item = self.DispatchPoint[DispatchId]
                if Item then
                    Item.Slot:SetZOrder(20)
                    Item:OnItemSelect(true)
                end      
            end   
        end)
        
    else
        local Item = self.DispatchPoint[DispatchId]
        --当前区域没刷出来
        if Item == nil then
            self:InitDispatchPoint()
        end
            local UIPos = DataMgr.DispatchUI[DispatchId].UIPos
            if UIPos then
            local Pos = self:TransformWorldLocToUILoc(UIPos[1], UIPos[2])
            self:MoveMapTo(Pos * -1)
            self:RefreshDispatchSelect()
            self:RefreshSingleDispatchPoint()
            self:DispatchSelectClick(DispatchId)
            local Item = self.DispatchPoint[DispatchId]
            if Item then
                Item.Slot:SetZOrder(20)
                Item:OnItemSelect()
            end      
        end   
    end
     self:ShowAllMiniHead(DispatchId)

end

function Component:ShowAllMiniHead(DispatchId)
    for Id, Point in pairs(self.DispatchPoint) do
        Point:ShowMiniHead(DispatchId)
    end
end

function Component:RefreshDispatchPoint(Id, CharId)
    local Point = self.DispatchPoint[Id]
    if Point then
        Point:RefreshAgent(CharId)
    end
end

function Component:RemoveDispatchPoint(Id, AgentId)
    local Point = self.DispatchPoint[Id]
    if Point then
         Point:RemoveAgent(AgentId)
    end
end

-- function Component:RefreshState(Id)
--      for DispatchId, Point in pairs(self.DispatchPoint) do
--         if DispatchId == Id then
--             Point:RemoveAgent(AgentId)
--         end
--     end
-- end

function Component:StartDispatch(Id)
    if self.IsMiniMap then
        return
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    for DispatchId, Point in pairs(self.DispatchPoint) do
        if DispatchId == Id then
            local Dispatch = Avatar.Dispatches[Id]
            Point:StartDispatch(Dispatch)
        end
    end
end

function Component:CancelDispatch(Id)
    if self.IsMiniMap then
        return
    end
    local Avatar = GWorld:GetAvatar()
    if Avatar == nil then
        return
    end
    local Item = self.DispatchPoint[Id]
    local Select = self.DispatchSelect[Id]
    Item:RemoveFromParent()
    Select:RemoveFromParent()
    if self.MainMap.DispatchDetail then
        self.MainMap.DispatchDetail:RealClose()
    end
    self.DispatchPoint[Id] = nil
    self.DispatchSelect[Id] = nil
    self.DispatchLocations[Id] = nil

end

function Component:CompleteDispatch(TotalReward, Id)
    if self.IsMiniMap then
        return
    end
    local Item = self.DispatchPoint[Id]
    local Select = self.DispatchSelect[Id]        
    Item:RemoveFromParent()
    Select:RemoveFromParent()
    if self.MainMap.DispatchDetail then
        self.MainMap.DispatchDetail:RealClose()
    end
    self.DispatchPoint[Id] = nil
    self.DispatchSelect[Id] = nil
    self.DispatchLocations[Id] = nil
end

function Component:GetAllDispatchReward(TotalReward, CompleteDispatchs)
    if self.IsMiniMap then
        return
    end
    for _, Id in pairs(CompleteDispatchs) do
        local Item = self.DispatchPoint[Id]
        local Select = self.DispatchSelect[Id] 
        if Item then
            Item:RemoveFromParent()
        end
        if Select then
            Select:RemoveFromParent()
        end
        self.DispatchPoint[Id] = nil
        self.DispatchSelect[Id] = nil
        self.DispatchLocations[Id] = nil

    end
end

function Component:OnDispatchOverdate(Id)
    if self.IsMiniMap then
        return
    end
    if next(self.DispatchPoint) then
        for Id, Item in pairs(self.DispatchPoint) do
            if Item then
                Item:RemoveFromParent()
            end
        end
        self.DispatchPoint = {}
    end
    if next(self.DispatchSelect) then
        for Id, Item in pairs(self.DispatchSelect) do
            if Item then
                Item:RemoveFromParent()
            end
        end
        self.DispatchSelect = {}
    end

    if next(self.DispatchLocations) then
        self.DispatchLocations = {}
    end
    self:InitDispatchPoint()
    
end

function Component:OnActiveDynamicQuest(Id)
    self:OnCommonTrack(CommonConst.RegionMapTrackingType.MiniDispatchPoint, Id, false)
end

function Component:RefreshAllDispatchPoint()
    for DispatchId, Point in pairs(self.DispatchPoint) do
        Point:RefreshPoint()
    end
end

function Component:RefreshSingleDispatchPoint()
    for DispatchId, Point in pairs(self.DispatchPoint) do
        Point:RefreshSinglePoint()
    end

end

function Component:DispatchSelectHover(Id)
    if Id ~= self.CurClickDispatchId then
        local Select = self.DispatchSelect[Id]
        Select:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        Select:PlayAnimation(Select.Hover)
    end
end

function Component:DispatchSelectUnHover(Id)
    if Id ~= self.CurClickDispatchId then
        local Select = self.DispatchSelect[Id]
        Select:SetVisibility(ESlateVisibility.Collapsed)
        
    end 
end

function Component:PlaySelectAni(Id)
    local Point = self.DispatchPoint[Id]
    if Point then
         Point:PlaySelectAnimation()
    end

end

function Component:DispatchSelectClick(Id)
    self.CurClickDispatchId = Id
    self.MainMap.DispatchId = Id
    local UIId = DataMgr.Dispatch[Id].DispatchUIId
    local FloorId = DataMgr.DispatchUI[UIId].FloorId
    self:OnFloorBtnClicked(FloorId, true)
    local Select = self.DispatchSelect[Id]
    if Select then
        Select.Slot:SetZOrder(10)
        Select:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        Select.IsPlay = false
        Select:PlayAnimation(Select.Click)
    end

end

function Component:RefreshDispatchSelect()
    for _, Select in pairs(self.DispatchSelect) do
        if Select then
            Select:SetVisibility(ESlateVisibility.Collapsed)
        end
    end
end


function Component:OnDispatchExistingComplete(Id)
    if self.IsMiniMap then
        return
    end
    if self.MainMap.DispatchAgentList then
        return
    end
    local Point = self.DispatchPoint[Id]
    local Select = self.DispatchSelect[Id]
    if Point then
        Point:RemoveFromParent()
        self.DispatchPoint[Id] = nil
        if Select then
            Select:RemoveFromParent()
            self.DispatchSelect[Id] = nil
        end
    end

end

function Component:OnDispatchComplete(Id)
    if self.IsMiniMap then
        return
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local Dispatch = Avatar.Dispatches[Id]
    local Point = self.DispatchPoint[Id]
    if Point then
        Point:SetState(Dispatch)
    end
end

function Component:BackToOriginalRegion()
    self:ChangeRegion(self.OriginalRegionId, function()
        self:ShowMissionIndicatorsInRegionMap()
    end)
end

function Component:OnDispatchTrace(Dispatch)
    self.CurTrackDispatchId = Dispatch
    local TrackingId = self:GetTrackingId(CommonConst.RegionMapTrackingType.MiniDispatchPoint)
    if TrackingId ~= self.CurTrackDispatchId then
        self:CancelCurrentTracking()
        EventManager:FireEvent(EventID.OnCommonTrack, CommonConst.RegionMapTrackingType.MiniDispatchPoint, self.CurTrackDispatchId,true)
        --self.CurrentSelectPoint:PlayAnimation(self.CurrentSelectPoint.Loop,0,0)
        --self:CreateTrackIndicator(self.CurrentSelectPoint)
        self:TryToastNotInSameRegion()
    else
        EventManager:FireEvent(EventID.OnCommonTrack, CommonConst.RegionMapTrackingType.MiniDispatchPoint, self.CurTrackDispatchId,false)
        --self.CurrentSelectPoint:StopAllAnimations()
        --self:RemoveTrackIndicator()
    end
end

function Component:CloseForDispatch(ShowDispatch)
    local Avatar = GWorld:GetAvatar()
    local Visible = ShowDispatch and ESlateVisibility.Collapsed or  ESlateVisibility.SelfHitTestInvisible
    for _,Point in pairs(self.TeleportPoints) do
        Point:SetPointVisibility("Dispatch",not ShowDispatch,true)
    end
    for _,Point in pairs(self.RegionPoints) do
        Point:SetPointVisibility("Dispatch",not ShowDispatch,true)
    end
    for _,Point in pairs(self.MarkTable) do
        Point:SetPointVisibility("Dispatch",not ShowDispatch,true)
    end
    for _,Point in pairs(self.ChallengePoints) do
        Point:SetPointVisibility("Dispatch",not ShowDispatch,true)
    end
    if not IsEmptyTable(self.IndicatorWidgets) then
        for _, v in pairs(self.IndicatorWidgets) do
            if IsValid(v) then
                v:SetVisibility(Visible)
            end
        end
    end
    if ShowDispatch then
        self.Panel_Gamer:SetVisibility(ESlateVisibility.Collapsed)
        self.MainMap.Slider_Zoom:SetVisibility(ESlateVisibility.Collapsed)
    elseif self.IsInRegion and not DataMgr.SubRegion[Avatar.CurrentRegionId].NotShowInRegionMap then
        self.Panel_Gamer:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.MainMap.Slider_Zoom:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end

return Component