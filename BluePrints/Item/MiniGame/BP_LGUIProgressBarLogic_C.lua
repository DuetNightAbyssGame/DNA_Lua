require "UnLua"

local BP_LGUIProgressBarLogic_C = Class({
    "BluePrints.Common.TimerMgr",
})

function BP_LGUIProgressBarLogic_C:ReceiveBeginPlay()
    self.Direction = 0
end

function BP_LGUIProgressBarLogic_C:ReceiveUpdate()
    if self.RootWidget and not self.RootWidget.bIsResetting and self.RootWidget.bCanDrag and self:CheckArrowIn() then
        -- UEPrint(self.Index)
        self:CheckCanGoIn()
        self:SetPercentByArrow()
        self:OnEnter()
    end
end

function BP_LGUIProgressBarLogic_C:RegisterSelf()
    self.OverLap = 0
    self.LastBarStack = TArray(ULGUILifeCycleUIBehaviour)
    self:InitSliderAndFill()
    self:SetPercent(0.0)
    if self.bIsStart then
        self.RootWidget.NowBar = self
        self.Direction = 1
    end
end

function BP_LGUIProgressBarLogic_C:CheckCanGoIn()
    if self.RootWidget.bIsResetting then
        return
    end
    self.Directions = {}
    for i,v in pairs(self.RootWidget.NowBarArray) do
        if self:GameMapHas(v.Index) then
            -- self:ChangeNowBar(i)
            -- return
            table.insert(self.Directions, i)
        end
    end
    if #self.Directions > 1 then
        self:SetPercent(1.0)
        for i,v in pairs(self.RootWidget.NowBarArray) do
            v:SetPercent(1.0)
        end
        self:Overlaped()
        return
    end
    if #self.Directions == 1 then
        self:ChangeNowBar(self.Directions[1])
    end
end

function BP_LGUIProgressBarLogic_C:GameMapHas(Index)
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

function BP_LGUIProgressBarLogic_C:ChangeNowBar(Index)
    if self.RootWidget == nil or self.RootWidget.NowBarArray:Contains(self) then
        return
    end
    local Length = self.RootWidget.Path[Index]:Length()
    if Length > 0 and self == self.RootWidget.Path[Index][Length] then
        for i,v in pairs(self.RootWidget.Path) do
            self.RootWidget.NowBarArray[Index].OverLap = self.RootWidget.NowBarArray[Index].OverLap - 1
            self.Direction = self:GetFillType()
            self.RootWidget.NowBarArray[Index]:SetPercent(0.0)
            self.RootWidget.Path[Index]:Remove(Length)
        end
    else
        self.RootWidget.NowBarArray[Index]:SetPercent(1.0)
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
    if self.bIsStart then
        self.Arrow:GetRootUIComponent():FindChildByDisplayName("StartArrow",true):SetIsUIActive(true)
    else
        self.Arrow:GetRootUIComponent():FindChildByDisplayName("StartArrow",true):SetIsUIActive(false)
    end
    self.ArrowPosition = self.Arrow:GetOwner():Cast(UE4.AUIContainerActor):GetUIItem():GetAnchoredPosition()
    self.RootWidget.NowBarArray[Index] = self
    self:ChangeFillType()
end

function BP_LGUIProgressBarLogic_C:ChangeFillType()
    if self.RootWidget == nil or not self.RootWidget.NowBarArray:Contains(self) then
        return
    end
    if self.Direction==self:GetFillType() then
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

function BP_LGUIProgressBarLogic_C:SetPercentByArrow()
    if not self.RootWidget.NowBarArray:Contains(self) then
        return
    end
    self.ArrowPosition = self.Arrow:GetOwner():Cast(UE4.AUIContainerActor):GetUIItem():GetAnchoredPosition()
    local Percent
    if self.Width > self.Height then
        Percent = (self.ArrowPosition.X - self.Left)/self.Width
    else
        Percent = (self.Top - self.ArrowPosition.Y)/self.Height
    end
    if self.Direction == "Up" or self.Direction == "Left" then
        Percent = 1 - Percent
    end
    if self.bIsStart or self.bIsEnd or self.bIsCross then
        Percent = 1
    end
    self:SetPercent(Percent)
end

function BP_LGUIProgressBarLogic_C:CheckArrowIn()
    for i,v in pairs(self.RootWidget.ArrowArray) do
        local ArrowPosition = v:GetOwner():Cast(UE4.AUIContainerActor):GetUIItem():GetAnchoredPosition()
        if ArrowPosition.X >= self.Left
            and ArrowPosition.X <= self.Right
            and ArrowPosition.Y <= self.Top
            and ArrowPosition.Y >= self.Bottom then
                return true
        end
    end
    return false
end

function BP_LGUIProgressBarLogic_C:SetCrossMoveRange(PositionX, PositionY)
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
    XOut = math.max(XOut, self.Left-5)
    XOut = math.min(XOut, self.Right+5)
    YOut = math.max(YOut, self.Bottom-5)
    YOut = math.min(YOut, self.Top+5)
    if bAxisX then
        YOut = CenterY
        if XOut<CenterX and Left == nil then
            XOut = CenterX
        end
        if XOut>CenterX and Right == nil then
            XOut = CenterX
        end
    else
        XOut = CenterX
        if YOut>CenterY and Up == nil then
            YOut = CenterY
        end

        if YOut<CenterY and Down == nil then
            YOut = CenterY
        end
    end
    return XOut, YOut
end

function BP_LGUIProgressBarLogic_C:SetHorizenMoveRange(PositionX, PositionY)
    local Position = self.RootWidget.PointerPosition
    if PositionX and PositionY then
        Position = FVector2D(PositionX, PositionY)
    end
    local ArrowPosition = self.ArrowPosition
    local MouseY = Position.Y
    if MouseY > ArrowPosition.Y+150 or MouseY < ArrowPosition.Y-150 then
        return ArrowPosition.X, ArrowPosition.Y
    end
    local Neighbor = self.RootWidget.GameMap[self.Index]
    local Left = Neighbor["Left"]
    local Right = Neighbor["Right"]

    local CenterY = self.Bottom+self.Height/2

    local XOut, YOut
    XOut = Position.X
    YOut = CenterY

    if Left == nil then
        XOut = math.max(XOut, self.Left)
    else
        XOut = math.max(XOut, self.Left-5)
    end
    if Right == nil then
        XOut = math.min(XOut, self.Right)
    else
        XOut = math.min(XOut, self.Right+5)
    end

    return XOut,YOut
end

function BP_LGUIProgressBarLogic_C:SetVerticalMoveRange(PositionX, PositionY)
    local Position = self.RootWidget.PointerPosition
    if PositionX and PositionY then
        Position = FVector2D(PositionX, PositionY)
    end
    local ArrowPosition = self.ArrowPosition
    local MouseX = Position.X
    if MouseX > ArrowPosition.X+150 or MouseX < ArrowPosition.X-150 then
        return ArrowPosition.X, ArrowPosition.Y
    end
    local Neighbor = self.RootWidget.GameMap[self.Index]
    local Up = Neighbor["Up"]
    local Down = Neighbor["Down"]

    local CenterX = self.Left+self.Width/2

    local XOut, YOut
    YOut = Position.Y
    XOut = CenterX

    if Up == nil then
        YOut = math.min(YOut, self.Top)
    else
        YOut = math.min(YOut, self.Top+5)
    end

    if Down == nil then
        YOut = math.max(YOut, self.Bottom)
    else
        YOut = math.max(YOut, self.Bottom-5)
    end
    return XOut,YOut
end

--0:Cross 1:Horizen 2:Vertical
function BP_LGUIProgressBarLogic_C:SetMoveRange(PositionX, PositionY)
    if self.Type == 0 then
        return self:SetCrossMoveRange(PositionX, PositionY)
    elseif self.Type == 1 then
        return self:SetHorizenMoveRange(PositionX, PositionY)
    elseif self.Type == 2 then
        return self:SetVerticalMoveRange(PositionX, PositionY)
    end
    return 0, 0
end

function BP_LGUIProgressBarLogic_C:OnEnter()
    if self.bIsEnd then
        self.RootWidget:TryGameOver()
    end
end

function BP_LGUIProgressBarLogic_C:Overlaped()
    self.RootWidget.bIsResetting = true
    self.RootWidget:ChangeColorOverlap()
    self.Arrow:GetRootUIComponent():FindChildByDisplayName("Handle",true):SetColor(UE4.UKismetMathLibrary.Conv_LinearColorToColor(UE4.UColorWheelHelper.HexToLinearColor("D36767"),true))
    self.RootWidget.ErrorText:SetIsUIActive(true)
    self.RootWidget.bCanDrag = false
    self.RootWidget:LuaReset()
end

function BP_LGUIProgressBarLogic_C:Reset()
    self.LastBarStack:Clear()
    self.OverLap = 0
    self.Direction = 0
    self:SetPercent(0.0)
    if self.bIsStart then
        self.RootWidget.NowBar = self
        self.Direction = 1
        self.Arrow:GetRootUIComponent():FindChildByDisplayName("StartArrow",true):SetIsUIActive(true)
        self.Arrow:GetRootUIComponent():FindChildByDisplayName("Handle",true):SetColor(UE4.UKismetMathLibrary.Conv_LinearColorToColor(UE4.UColorWheelHelper.HexToLinearColor("E9B971"),true))
        -- self.RootWidget:SetArrowPosition(self.Left+self.width/2, self.Top-self.Height/2)
        --self.RootWidget:SetArrowRotation()
    end
    self.Arrow = nil
    self.ArrowPosition = nil
end

function BP_LGUIProgressBarLogic_C:ChangeColorOnEnd()
    local Color = UE4.UColorWheelHelper.HexToLinearColor("E9B971")
    if self.ColorHandle then
        Color = UE4.UColorWheelHelper.HexToLinearColor("508E4F")
    end
    self:ChangeColor(Color)
    if self.bIsEnd then
        self.Arrow:GetRootUIComponent():FindChildByDisplayName("Handle",true):SetColor(UE4.UKismetMathLibrary.Conv_LinearColorToColor(Color,true))
        self:GetRootUIComponent():FindChildByDisplayName("EndSprite",true):SetColor(UE4.UKismetMathLibrary.Conv_LinearColorToColor(Color,true))
    end
    self.ColorHandle = not self.ColorHandle
    self.EndColorCount = self.EndColorCount + 1
    if self.EndColorCount >= 4 then
        self:RemoveTimer(self.EndColorHandle)
        self.EndColorHandle = nil
    end
end
return BP_LGUIProgressBarLogic_C
