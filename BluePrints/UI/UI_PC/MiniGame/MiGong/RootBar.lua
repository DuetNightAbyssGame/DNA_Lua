--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local RootBar = Class({"BluePrints.Common.TimerMgr", "BluePrints.UI.BP_EMUserWidget_C"})

function RootBar:ReceiveBeginPlay()
    self.Direction = 0
end

function RootBar:Tick()
    if self.IsArrow then
        return
    end
    if self.RootWidget and not self.RootWidget.bIsResetting and self.RootWidget.bCanDrag and self:CheckArrowIn() then
        self:CheckCanGoIn()
        self:SetPercentByArrow()
        self:OnEnter()
    end
end

function RootBar:SetLeftRightTopDown()
    local Size = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.GamePanel):GetSize()

    local ViewportPos = FVector2D(0, 0)
    local GamePanelViewPortPos = FVector2D(0, 0)
    UE4.USlateBlueprintLibrary.LocalToViewport(self, self:GetCachedGeometry(), FVector2D(0,0), nil, ViewportPos)
    UE4.USlateBlueprintLibrary.LocalToViewport(self, self.RootWidget.GamePanel:GetCachedGeometry(), FVector2D(0,0), nil, GamePanelViewPortPos)
    local Position1 =  ViewportPos - GamePanelViewPortPos

    local Position = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self):GetPosition()
    --手机端不知道为啥这两个坐标有个比例，后面计算都要依赖这个比例
    self.ViewportLocalRate = Position1.X / Position.X
    if self.IsArrow then
        --箭头第一次设置的时候，比例不能这么设，以其他bar的比例为准
        self.ViewportLocalRate = self.RootWidget.ViewportLocalRate
    end
    if self.IsCross or self.bIsStart or self.bIsEnd then
        self.Left = Position.X
        self.Down = Position.Y
        self.Right = Position.X + Size.X
        self.Top = Position.Y + Size.Y
    else
        self.Left = Position.X - Size.X/2 + self.RootWidget.Discrete/2
        self.Down = Position.Y - Size.Y/2 + self.RootWidget.Discrete/2
        self.Right = self.Left + Size.X
        self.Top = self.Down + Size.Y
    end
    self.Height = Size.Y
    self.Width = Size.X
    if not self.RootWidget.ViewportLocalRate and not self.IsArrow then
        self.RootWidget.ViewportLocalRate = self.ViewportLocalRate
    end
end
function RootBar:RegisterSelf()
    self.OverLap = 0
    self.LastBarStack = TArray(UObject)
    self:SetPercent(0.0, 0, 0, 0)
    if self.bIsStart then
        self.RootWidget.NowBar = self
        self.Direction = 1
    end
end

function RootBar:CheckCanGoIn()
    if self.RootWidget.bIsResetting then
        return
    end
    self.Directions = {}
    for i,v in pairs(self.RootWidget.NowBarArray) do
        if self:GameMapHas(v.Index) then
            table.insert(self.Directions, i)
        end
    end
    if #self.Directions > 1 then
        self:SetPercent(1.0, 0, 0, 0)
        for i,v in pairs(self.RootWidget.NowBarArray) do
            v:SetPercent(1.0, 0, 0, 0)
        end
        self:Overlaped()
        return
    end
    if #self.Directions == 1 then
        self:ChangeNowBar(self.Directions[1])
    end
end

function RootBar:GameMapHas(Index)
    if self.RootWidget.GameMap[Index] == nil then
        return false
    end
    for i, v in pairs(self.RootWidget.GameMap[Index]) do
        if v == self.Index then
            self.Direction = i
            return true
        end
    end
    return false
end

function RootBar:ChangeNowBar(Index)
    if self.RootWidget == nil or self.RootWidget.NowBarArray:Contains(self) then
        return
    end
    local Length = self.RootWidget.Path[Index]:Length()
    if Length > 0 and self == self.RootWidget.Path[Index][Length] then
        for i,v in pairs(self.RootWidget.Path) do
            self.RootWidget.NowBarArray[Index].OverLap = self.RootWidget.NowBarArray[Index].OverLap - 1
            self.Direction = self:GetFillType()
            self.RootWidget.NowBarArray[Index]:SetPercent(0.0, 0, 0, 0)
            self.RootWidget.Path[Index]:Remove(Length)
        end
    else
        self.LastBarIndex = self.RootWidget.NowBarArray[Index].Index
        if self.RootWidget.NowBarArray[Index].bIsCross then
            self.RootWidget.NowBarArray[Index]:ChangeNowBarSetPercent(self.Index)
        else
            self.RootWidget.NowBarArray[Index]:SetPercent(1.0, 0, 0, 0)
        end
        self.RootWidget.Path[Index]:AddUnique(self.RootWidget.NowBarArray[Index])
        self.OverLap = self.OverLap + 1
        for i,v in pairs(self.RootWidget.Path) do
            if v:Contains(self) then
                self:Overlaped()
                return
            end
        end
    end

    self.Arrow = self.RootWidget.NowBarArray[Index].Arrow
    -- 显隐起始箭头
    -- if self.bIsStart then
    --     self.Arrow:GetRootUIComponent():FindChildByDisplayName("StartArrow",true):SetIsUIActive(true)
    -- else
    --     self.Arrow:GetRootUIComponent():FindChildByDisplayName("StartArrow",true):SetIsUIActive(false)
    -- end
    self.ArrowPosition = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Arrow):GetPosition() + FVector2D(self.RootWidget.Discrete/2,self.RootWidget.Discrete/2)
    self.RootWidget.NowBarArray[Index] = self
    self:ChangeFillType()
end

function RootBar:ChangeFillType()
    if self.RootWidget == nil or not self.RootWidget.NowBarArray:Contains(self) then
        return
    end
    if self.Direction==self:GetFillType() then
        return
    end
    if self.bIsCross then
        self:SetCrossFillType()
        return
    end
    if self.Direction == "Left" then
        self:SetFillType(0)
    elseif self.Direction == "Up" then
        self:SetFillType(1)
    elseif self.Direction == "Right" then
        self:SetFillType(2)
    elseif self.Direction == "Down" then
        self:SetFillType(3)
    end
end

function RootBar:SetPercentByArrow()
    if not self.RootWidget.NowBarArray:Contains(self) then
        return
    end
    self.ArrowPosition = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Arrow):GetPosition() + FVector2D(self.RootWidget.Discrete/2,self.RootWidget.Discrete/2)
    if self.bIsCross then
        self:SetCrossPercent()
        return
    end
    local Percent
    if self.Width > self.Height then
        Percent = (self.ArrowPosition.X - self.Left)/self.Width
    else
        Percent = (self.Top - self.ArrowPosition.Y)/self.Height
    end
    if self.Direction == "Down" or self.Direction == "Left" then
        Percent = 1 - Percent
    end
    if self.bIsStart or self.bIsEnd or self.bIsCross then
        Percent = 1
    end
    self:SetPercent(Percent, 0, 0, 0)
end

function RootBar:CheckArrowIn()
    for i,v in pairs(self.RootWidget.ArrowArray) do
        local ArrowPosition = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(v):GetPosition() + FVector2D(v.Width/2,v.Height/2)
        -- local ArrowPosition = self.RootWidget.PointerPosition
        if ArrowPosition.X >= self.Left
            and ArrowPosition.X <= self.Right
            and ArrowPosition.Y <= self.Top
            and ArrowPosition.Y >= self.Down then
                return true
        end
    end
    return false
end

function RootBar:SetCrossMoveRange(PositionX, PositionY)
    local Position = self.RootWidget.PointerPosition
    if PositionX and PositionY then
        Position = FVector2D(PositionX, PositionY)
    end
    local Neighbor = self.RootWidget.GameMap[self.Index]
    local Left = Neighbor["Left"]
    local Up = Neighbor["Up"]
    local Right = Neighbor["Right"]
    local Down = Neighbor["Down"]

    local CenterX = self.Left + self.Width/2
    local CenterY = self.Top - self.Height/2 

    local XOut, YOut
    XOut = Position.X
    YOut = Position.Y

    local bAxisX = math.abs(XOut-CenterX) > math.abs(YOut-CenterY)
    XOut = math.max(XOut, self.Left-1)
    XOut = math.min(XOut, self.Right+1)
    YOut = math.max(YOut, self.Down-1)
    YOut = math.min(YOut, self.Top+1)

    --将要移动的方向有没有可移动的路径，默认有
    local HasNeighbor = true
    if bAxisX then
        YOut = CenterY
        --左移动
        if (self.bIsEnd and XOut<CenterX - 1 and Left == nil) or (not self.bIsEnd and XOut<CenterX and Left == nil) then
            XOut = CenterX
            HasNeighbor = false
        elseif XOut<CenterX and Left ~= nil then
            --如果将要去的是End，则最多只能到End的中心点，下同
            local EndBar = self:CheckNeighborIsEnd(Left)
            if EndBar ~= nil then
                XOut = math.max(XOut, EndBar.Left + EndBar.Width/2)
            end
        end
        --右移动
        if (self.bIsEnd and XOut>CenterX + 1 and Right == nil) or (not self.bIsEnd and XOut>CenterX and Right == nil) then
            XOut = CenterX
            HasNeighbor = false
        elseif XOut>CenterX and Right ~= nil then
            local EndBar = self:CheckNeighborIsEnd(Right)
            if EndBar ~= nil then
                XOut = math.min(XOut, EndBar.Left + EndBar.Width/2)
            end
        end
    else
        XOut = CenterX
        --上移动
        if (self.bIsEnd and YOut<CenterY - 1 and Up == nil) or (not self.bIsEnd and YOut<CenterY and Up == nil) then
            YOut = CenterY
            HasNeighbor = false
        elseif YOut<CenterY and Up ~= nil then
            local EndBar = self:CheckNeighborIsEnd(Up)
            if EndBar ~= nil then
                YOut = math.max(YOut, EndBar.Top - EndBar.Height/2 )
            end
        end
        --下移动
        if (self.bIsEnd and YOut>CenterY + 1 and Down == nil) or (not self.bIsEnd and YOut>CenterY and Down == nil) then
            YOut = CenterY
            HasNeighbor = false
        elseif YOut>CenterY and Down ~= nil then
            local EndBar = self:CheckNeighborIsEnd(Down)
            if EndBar ~= nil then
                YOut = math.min(YOut, EndBar.Top - EndBar.Height/2)
            end
        end
    end
    return XOut, YOut, HasNeighbor, 30
end

function RootBar:SetHorizenMoveRange(PositionX, PositionY)
    local Position = self.RootWidget.PointerPosition
    if PositionX and PositionY then
        Position = FVector2D(PositionX, PositionY)
    end
    local MouseY = Position.Y
    if MouseY > self.ArrowPosition.Y+150 or MouseY < self.ArrowPosition.Y-150 then
        Position.Y = self.ArrowPosition.Y
    end
    local Neighbor = self.RootWidget.GameMap[self.Index]
    local Left = Neighbor["Left"]
    local Right = Neighbor["Right"]

    local CenterY = self.Down + self.Height/2

    local XOut, YOut
    XOut = Position.X
    YOut = CenterY
    local HasNeighbor = true

    if Left == nil then
        XOut = math.max(XOut, self.Left)
        HasNeighbor = false
    else
        XOut = math.max(XOut, self.Left-1)
    end
    if Right == nil then
        XOut = math.min(XOut, self.Right)
        HasNeighbor = false
    else
        XOut = math.min(XOut, self.Right+1)
    end
    return XOut, YOut, HasNeighbor, 30
end

function RootBar:SetVerticalMoveRange(PositionX, PositionY)
    local Position = self.RootWidget.PointerPosition
    if PositionX and PositionY then
        Position = FVector2D(PositionX, PositionY)
    end
    local MouseX = Position.X
    if MouseX > self.ArrowPosition.X+150 or MouseX < self.ArrowPosition.X-150 then
        Position.X = self.ArrowPosition.X
    end
    local Neighbor = self.RootWidget.GameMap[self.Index]
    local Up = Neighbor["Up"]
    local Down = Neighbor["Down"]

    local CenterX = self.Left+self.Width/2

    local XOut, YOut
    YOut = Position.Y
    XOut = CenterX
    local HasNeighbor = true
    
    if Up == nil then
        YOut = math.min(YOut, self.Top)
        HasNeighbor = false
    else
        YOut = math.min(YOut, self.Top+1)
    end

    if Down == nil then
        YOut = math.max(YOut, self.Down)
        HasNeighbor = false
    else
        YOut = math.max(YOut, self.Down-1)
    end
    return XOut,YOut,HasNeighbor, 30
end

--0:Cross 1:Horizen 2:Vertical
function RootBar:SetMoveRange(PositionX, PositionY)
    if self.Type == 0 then
        return self:SetCrossMoveRange(PositionX, PositionY)
    elseif self.Type == 1 then
        return self:SetHorizenMoveRange(PositionX, PositionY)
    elseif self.Type == 2 then
        return self:SetVerticalMoveRange(PositionX, PositionY)
    end
    return 0, 0
end

function RootBar:OnEnter()
    if self.bIsEnd then
        local Arrow = self.RootWidget.ArrowArray[self.RootWidget.CurrentDragArrowIndex]
        local ArrowPosition = Arrow:GetPosition() + FVector2D(Arrow.Width/2,Arrow.Height/2)
        local SelfX = self.Left+self.Width/2
        local SelfY = self.Top - self.Height/2
        if math.abs(ArrowPosition.X - SelfX) < 1 and math.abs(ArrowPosition.Y - SelfY) < 1 then
            self.RootWidget:TryGameOver()
        end
        -- self.RootWidget:TryGameOver()
    end
end

function RootBar:Overlaped()
    self.RootWidget.bIsResetting = true
    self.RootWidget:ChangeColorOverlap(UE4.UUIFunctionLibrary.StringToLinearColor("B43131"))
    self.RootWidget:PlayErrorAnim()
    AudioManager(self):PlayUISound(self, "event:/ui/minigame/mech_maze_line_cross", nil, nil)
    
    self.RootWidget.bCanDrag = false
    self.RootWidget:LuaReset()
end

function RootBar:Reset()
    self.LastBarStack:Clear()
    self.OverLap = 0
    self.Direction = 0
    self:SetPercent(0.0,0,0,0)
    if self.bIsStart then
        self.RootWidget.NowBar = self
        self.Direction = 1
        -- self.Arrow:GetRootUIComponent():FindChildByDisplayName("StartArrow",true):SetIsUIActive(true)
        -- self.Arrow:GetRootUIComponent():FindChildByDisplayName("Handle",true):SetColor(UE4.UKismetMathLibrary.Conv_LinearColorToColor(UE4.UColorWheelHelper.HexToLinearColor("E9B971"),true))
        -- self.RootWidget:SetArrowPosition(self.Left+self.width/2, self.Top-self.Height/2)
        -- self.RootWidget:SetArrowRotation()
    end
    self.Arrow = nil
    self.ArrowPosition = nil
end

function RootBar:ChangeColorOnEnd()
    local Color = UE4.UUIFunctionLibrary.StringToLinearColor("E9B971")
    if self.ColorHandle then
        Color = UE4.UUIFunctionLibrary.StringToLinearColor("508E4F")
    end
    self:ChangeColor(Color)
    -- if self.bIsEnd then
    --     self.Arrow:GetRootUIComponent():FindChildByDisplayName("Handle",true):SetColor(UE4.UKismetMathLibrary.Conv_LinearColorToColor(Color,true))
    --     self:GetRootUIComponent():FindChildByDisplayName("EndSprite",true):SetColor(UE4.UKismetMathLibrary.Conv_LinearColorToColor(Color,true))
    -- end
    self.ColorHandle = not self.ColorHandle
    self.EndColorCount = self.EndColorCount + 1
    if self.EndColorCount >= 4 then
        self:RemoveTimer(self.EndColorHandle)
        self.EndColorHandle = nil
    end
end

function RootBar:CheckNeighborIsEnd(Index)
    for i,v in pairs(self.RootWidget.EndBarArray) do
        if v.Index == Index then
            return v
        end
    end
    return nil
end
return RootBar
