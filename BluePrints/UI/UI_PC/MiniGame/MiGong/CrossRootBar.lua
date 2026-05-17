--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local CrossRootBar = Class({
    "BluePrints.UI.UI_PC.MiniGame.MiGong.RootBar",
})

function CrossRootBar:SetCrossPercent()
    local Center = FVector2D((self.Left+self.Right)/2, (self.Top+self.Down)/2)
    local ArrowRelativePos = self.ArrowPosition - Center
    local PercentRight = -2.0
    local PercentDown = -2.0
    local PercentLeft = -2.0
    local PercentUp = -2.0
    PercentRight = ArrowRelativePos.X/self.Width*2
    PercentLeft = -PercentRight
    if self.ProgressBar_Left.ArrowType == 2 then
        PercentLeft = 1 - PercentLeft
    end
    if self.ProgressBar_Right.ArrowType == 0 then
        PercentRight = 1 - PercentRight
    end
    PercentDown = ArrowRelativePos.Y/self.Height*2
    PercentUp = -PercentDown
    if self.ProgressBar_Up.ArrowType == 3 then
        PercentUp = 1 - PercentUp
    end
    if self.ProgressBar_Down.ArrowType == 1 then
        PercentDown = 1 - PercentDown
    end
    self:SetPercent(PercentLeft, PercentRight, PercentUp, PercentDown)
end

function CrossRootBar:SetCrossFillType()
    local SourceDiection = "Left"
    --相对于上一个bar，新的corss在它的哪个方位
    for i, v in pairs(self.RootWidget.GameMap[self.LastBarIndex]) do
        if v == self.Index then
            SourceDiection = i
        end
    end
    if SourceDiection == "Left" then
        self.Line_Left.Slot:SetZOrder(0)
        self.Line_Right.Slot:SetZOrder(99)
        self.Line_Up.Slot:SetZOrder(0)
        self.Line_Down.Slot:SetZOrder(0)
        self.ProgressBar_Left:SetFillType(0)
        self.ProgressBar_Right:SetFillType(0)
        self.ProgressBar_Up:SetFillType(1)
        self.ProgressBar_Down:SetFillType(3)
    elseif SourceDiection == "Up" then
        self.Line_Left.Slot:SetZOrder(0)
        self.Line_Right.Slot:SetZOrder(0)
        self.Line_Up.Slot:SetZOrder(0)
        self.Line_Down.Slot:SetZOrder(99)
        self.ProgressBar_Left:SetFillType(0)
        self.ProgressBar_Right:SetFillType(2)
        self.ProgressBar_Up:SetFillType(1)
        self.ProgressBar_Down:SetFillType(1)
    elseif SourceDiection == "Right" then
        self.Line_Left.Slot:SetZOrder(99)
        self.Line_Right.Slot:SetZOrder(0)
        self.Line_Up.Slot:SetZOrder(0)
        self.Line_Down.Slot:SetZOrder(0)
        self.ProgressBar_Left:SetFillType(2)
        self.ProgressBar_Right:SetFillType(2)
        self.ProgressBar_Up:SetFillType(1)
        self.ProgressBar_Down:SetFillType(3)
    elseif SourceDiection == "Down" then
        self.Line_Left.Slot:SetZOrder(0)
        self.Line_Right.Slot:SetZOrder(0)
        self.Line_Up.Slot:SetZOrder(99)
        self.Line_Down.Slot:SetZOrder(0)
        self.ProgressBar_Left:SetFillType(0)
        self.ProgressBar_Right:SetFillType(2)
        self.ProgressBar_Up:SetFillType(3)
        self.ProgressBar_Down:SetFillType(3)
    end
end

function CrossRootBar:ChangeNowBarSetPercent(NextBarIndex)
    local DirectionType = {"Left", "Right", "Up", "Down"}
    local LastDiection = ""
    local NextDiection = ""
    --相对于corss,上一个bar在它的哪个方位
    for i, v in pairs(self.RootWidget.GameMap[self.Index]) do
        if v == self.LastBarIndex then
            LastDiection = i
        end
    end
    --相对于corss,下一个bar在它的哪个方位
    for i, v in pairs(self.RootWidget.GameMap[self.Index]) do
        if v == NextBarIndex then
            NextDiection = i
        end
    end
    local PercentRight = 0
    local PercentDown = 0
    local PercentLeft = 0
    local PercentUp = 0
    for i, v in pairs(DirectionType) do
        if v == LastDiection or v == NextDiection then
            self["ProgressBar_"..v]:SetPercent(1)
        else
            self["ProgressBar_"..v]:SetPercent(0)
        end
    end
end

function CrossRootBar:InitPositionAndSize(Discrete)
    UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Line_Left):SetSize(FVector2D(Discrete/2, self.Thick))
    UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Line_Right):SetSize(FVector2D(Discrete/2, self.Thick))
    UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Line_Up):SetSize(FVector2D(self.Thick, Discrete/2))
    UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Line_Down):SetSize(FVector2D(self.Thick, Discrete/2))
end
-- function CrossRootBar:CheckOverlaped()
--     local Center = FVector2D((self.Left+self.Right)/2, (self.Top+self.Down)/2)
--     local ArrowRelativePos = self.ArrowPosition - Center
--     if ArrowRelativePos.X <= 5 and ArrowRelativePos.Y <= 5 then
--         return true
--     end
--     return false
-- end
return CrossRootBar
