--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_MiniGame_Tiaopin_List_C
local WBP_MiniGame_Tiaopin_List_C = Class({"BluePrints.UI.BP_EMUserWidget_C", "BluePrints.Common.TimerMgr","BluePrints.Common.DelayFrameComponent"})

--function M:Initialize(Initializer)
--end

-- function WBP_MiniGame_Tiaopin_List_C:Construct()
-- end

function WBP_MiniGame_Tiaopin_List_C:OnListItemObjectSet(TiaoPin)
    self.Owner = TiaoPin.Owner
    self.Index = TiaoPin.Index
    self.PointPosition = {
        -177,-140,-105,-70,-35,0,35,70,105,140,177
    }
    self.IsUpForbid = false
    self.IsDownForbid = false
    self.MoveRange = TiaoPin.MoveRange
    self.OriginPointPositionIndex = TiaoPin.OriginPointPositionIndex
    --申明白块的当前位置变量
    self.CurrentPositionIndex = TiaoPin.CurrentPositionIndex
    --设置目标点的位置
    self.TargetPointPositionIndex = TiaoPin.TargetPointPositionIndex
    local TargetSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Img_In)
    local TargetPositionX = TargetSlot:GetPosition().X
    TargetSlot:SetPosition(FVector2D(TargetPositionX, self.PointPosition[self.TargetPointPositionIndex]))
    --申明当前列的完成状态变量
    self.IsComplete = false
    --初始化频率点
    self:InitPointInList()
    --更新白块的位置
    self:UpdatePointPosition()
    --把生成的调频列存入主界面的List中
    self.Owner:AddItemInTiaoPinList(self.Index, self)
end

--初始化列中的点
function WBP_MiniGame_Tiaopin_List_C:InitPointInList()
    self.TiaoPinDotList = {}
    self.List_Deco:ClearListItems()
    for index = 1, #self.PointPosition do
        local TiaoPinDot = NewObject(UIUtils.GetCommonItemContentClass())
        TiaoPinDot.Index = index
        TiaoPinDot.Owner = self

        self.List_Deco:AddItem(TiaoPinDot)
    end
    self:AddTimer(0.1, self.UpdateDotAniamtion, false, 0.1, "InitPoint", true, 1)
    self:AddTimer(0.1, self.UpdateArrowAnimation, false, 0.1, "InitArrow", true)
end

function WBP_MiniGame_Tiaopin_List_C:AddItemInTiaoPinList(Index, TiaoPin)
    self.TiaoPinDotList[Index] = TiaoPin
end

--更新点的动画
function WBP_MiniGame_Tiaopin_List_C:UpdateDotAniamtion(CurTiaoPinListIndex)
    --仅用做初始化的时候判断
    if CurTiaoPinListIndex and CurTiaoPinListIndex ~= self.Index then
        DebugPrint("thy    CurTiaoPinListIndex ~= self.Index", self.Index)
        self:CloseDotAniamtion()
        return
    end
    for index = 1, #self.TiaoPinDotList do
        self.TiaoPinDotList[index]:StopLoopState()
        if self.CurrentPositionIndex + self.MoveRange == index or  self.CurrentPositionIndex - self.MoveRange == index then
            self.TiaoPinDotList[index]:OpenLoopState()
        end
    end
end

--关闭点的动画
function WBP_MiniGame_Tiaopin_List_C:CloseDotAniamtion()
    for index = 1, #self.TiaoPinDotList do
        self.TiaoPinDotList[index]:StopLoopState()
    end
end

--白块移动
function WBP_MiniGame_Tiaopin_List_C:UpdatePointPosition()
    local Slot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Panel_Move)
    if not Slot then
        DebugPrint("thy     TiaoPin Slot is nil")
        return
    end
    local PositionX = Slot:GetPosition().X
    Slot:SetPosition(FVector2D(PositionX, self.PointPosition[self.CurrentPositionIndex]))
    --检查当前完成是否完成
    self:CheckPointPosition()
    --更新点的动画
    self:UpdateDotAniamtion()
    --更新箭头动画
    self:UpdateArrowAnimation()
end

--更新箭头动画
function WBP_MiniGame_Tiaopin_List_C:UpdateArrowAnimation()
    if self.CurrentPositionIndex == 1 then
        self.IsUpForbid = true
        self:PlayAnimation(self.Up_Forbid)
        return
    end

    if self.CurrentPositionIndex ~= 1 and self.IsUpForbid then
        self.IsUpForbid = false
        self:StopAllAnimations()
        self:PlayAnimationReverse(self.Up_Forbid)
    end

    if self.CurrentPositionIndex == #self.PointPosition then
        self.IsDownForbid = true
        self:PlayAnimation(self.Down_Forbid)
        return
    end

    if self.CurrentPositionIndex ~= #self.PointPosition and self.IsDownForbid then
        self.IsDownForbid = false
        self:StopAllAnimations()
        self:PlayAnimationReverse(self.Down_Forbid)
    end
end

--重置白块
function WBP_MiniGame_Tiaopin_List_C:ResetPointPosition()
    local Slot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Panel_Move)
    if not Slot then
        DebugPrint("thy     TiaoPin Slot is nil")
        return
    end
    local PositionX = Slot:GetPosition().X
    Slot:SetPosition(FVector2D(PositionX, self.PointPosition[self.OriginPointPositionIndex]))
    self.CurrentPositionIndex = self.OriginPointPositionIndex
    --检查当前完成是否完成
    self:CheckPointPosition()
end

--检查是否可以向上移动
function WBP_MiniGame_Tiaopin_List_C:CheckCanMovePointUp()
    if self.CurrentPositionIndex - self.MoveRange < 1 then
        --不能移动 播放警告动画
        self:PlayAnimation(self.Up_Warning)
        return false
    end
    return true
end

--检查是否可以向下移动
function WBP_MiniGame_Tiaopin_List_C:CheckCanMovePointDown()
    if self.CurrentPositionIndex + self.MoveRange > #self.PointPosition then
        --不能移动 播放警告动画
        self:PlayAnimation(self.Down_Warning)
        return false
    end
    return true
end

--向上移动 
function WBP_MiniGame_Tiaopin_List_C:MovePointUp()
    if not self:CheckCanMovePointUp() then
        return
    end
    self.CurrentPositionIndex = self.CurrentPositionIndex - self.MoveRange
    --设置位置
    self:UpdatePointPosition()
end

--向下移动 
function WBP_MiniGame_Tiaopin_List_C:MovePointDown()
    if not self:CheckCanMovePointDown() then
        return
    end
    self.CurrentPositionIndex = self.CurrentPositionIndex + self.MoveRange
    --设置位置
    self:UpdatePointPosition()
end

--检查当前的位置是不是目标位置
function WBP_MiniGame_Tiaopin_List_C:CheckPointPosition()
    if self.TargetPointPositionIndex == self.CurrentPositionIndex then
        DebugPrint("thy   CheckPointPosition  Complete")
        --完成
        self.IsComplete = true
        --播放完成动画
        self:AddDelayFrameFunc(
            function()
                self:PlayAnimation(self.Move_Reach)
            end, 1, "DelayPlay")

        AudioManager(self):PlayUISound(nil, "event:/ui/minigame/tiaopin_block_bingo", nil, nil)
    else
        DebugPrint("thy   CheckPointPosition  Normal")
        --未完成
        self.IsComplete = false
        --播放普通动画
        self:StopAllAnimations()
        self:PlayAnimation(self.Move_Normal)
    end
end

--关闭选中状态
function WBP_MiniGame_Tiaopin_List_C:CloseSelectState()
    self.VX_Select1:SetRenderOpacity(0)
    self.Img_Up:SetRenderOpacity(0)
    self.Img_Down:SetRenderOpacity(0)
    self:StopAllAnimations()
    self:CloseDotAniamtion()
end

--开启选中状态
function WBP_MiniGame_Tiaopin_List_C:OpenSelectState()
    self:PlayAnimation(self.Select)
    self.Img_Up:SetRenderOpacity(1)
    self.Img_Down:SetRenderOpacity(1)
    self:UpdateDotAniamtion()
    self:UpdateArrowAnimation()
end

return WBP_MiniGame_Tiaopin_List_C
