--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local BagGameModel = require "BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameModel"

---@type WBP_Activity_BagGame_PlayItem01_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C",
"BluePrints.UI.WBP.Activity.Widget.BagGame.Activity_BagGame_DragComponent",
"BluePrints.UI.BP_EMUserWidgetUtils_C",
})

-- 使用 Model 中的格子常量
M.GRID_ROWS = BagGameModel.GRID_ROWS
M.GRID_COLS = BagGameModel.GRID_COLS

-- 使用 Model 中的格子值常量
M.VALUE_UNCLICKABLE = BagGameModel.VALUE_UNCLICKABLE
M.VALUE_SINGLE_REWARD = BagGameModel.VALUE_SINGLE_REWARD
M.VALUE_DOUBLE_REWARD = BagGameModel.VALUE_DOUBLE_REWARD
M.VALUE_BLOCKED = BagGameModel.VALUE_BLOCKED

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Row = 0       -- 行索引 (1-8)
    self.Col = 0       -- 列索引 (1-10)
    self.Value = 0     -- 格子值
    self:PlayAnimation(self.Normal)
end

function M:Destruct()
end

--- 初始化格子
---@param Row number 行索引 (1-8)
---@param Col number 列索引 (1-10)
---@param Value number 格子值 (0=不可点击, 1=单倍奖励, 2=双倍奖励, -1=不可用)
function M:Init(Row, Col, Value)
    self.Row = Row or 0
    self.Col = Col or 0
    self.Value = Value or 0
    self:UpdateDisplay()
end

---@param Value number 格子值
function M:SetValue(Value)
    self.Value = Value
    self:UpdateDisplay()
end

---@return number
function M:GetValue()
    return self.Value
end

---@return number, number 行, 列
function M:GetPosition()
    return self.Row, self.Col
end

---@return boolean
function M:IsEmpty()
    return self.Value == M.VALUE_EMPTY
end

---@return boolean
function M:IsAvailable()
    return self.Value ~= M.VALUE_BLOCKED
end

function M:UpdateDisplay()   
    if self.Value == M.VALUE_UNCLICKABLE then
        self.Switch_Type:SetActiveWidgetIndex(0)
    elseif self.Value == M.VALUE_SINGLE_REWARD then
        self.Switch_Type:SetActiveWidgetIndex(1)
    elseif self.Value == M.VALUE_DOUBLE_REWARD then
        self.Switch_Type:SetActiveWidgetIndex(2)
    end
end

-- ==================== 系统拖拽事件 ====================
function M:OnDragEnter(MyGeometry, PointerEvent, Operation)
    -- 光标进入此格子，通知 PlayScreen 激活形状区域
    if Operation.Tag == "BagGameDisPlayItem" then
        local DragUI = Operation.DefaultDragVisual
        if self.PlayScreen and self.PlayScreen.ActivateShapeArea then
            self.PlayScreen:ActivateShapeArea(self.Row, self.Col, DragUI)
        end
        self:UpdateDragUI(DragUI)
    end
end

function M:UpdateDragUI(DragUI)
    DragUI:PlayAnimation(DragUI.Btn_In)
end

function M:OnDragLeave(PointerEvent, Operation)
    -- 光标离开此格子，通知 PlayScreen（带行列信息，防止 Enter/Leave 事件竞争）
    if Operation.Tag == "BagGameDisPlayItem" then
        if self.PlayScreen and self.PlayScreen.OnCellDragLeave then
            self.PlayScreen:OnCellDragLeave(self.Row, self.Col)
        end
    end
end

function M:OnDragCancelled(PointerEvent, Operation)
    -- 拖拽取消，确保清除激活状态
    if self.PlayScreen and self.PlayScreen.DeactivateShapeArea then
        self.PlayScreen:DeactivateShapeArea()
    end
end

function M:OnDrop(MyGeometry, PointerEvent, Operation)
    if Operation.Tag ~= "BagGameDisPlayItem" then
        return false
    end

    local bSuccess = false

    -- 通知 PlayScreen 执行放置
    if self.PlayScreen and self.PlayScreen.PlaceItemAtCell then
        local DragUI = Operation.DefaultDragVisual
        bSuccess = self.PlayScreen:PlaceItemAtCell(self.Row, self.Col, DragUI, Operation)
        if bSuccess then
            -- 放置成功，清除高亮
            if self.PlayScreen.DeactivateShapeArea then
                -- self.PlayScreen:DeactivateShapeArea()
            end
        end
    end

    if self.OnDropCallback then
        self.OnDropCallback(self, PointerEvent, Operation)
    end

    -- 放置成功返回 true（UE 销毁 DragUI），失败返回 false（UE 触发 OnDragCancelled 恢复物品）
    return bSuccess
end

-- ==================== 形状区域激活（由 PlayScreen 调用） ====================
--- 激活此格子的高亮显示（普通放置模式）
---@param bCanPlace boolean 是否可以放置（影响动画类型）
function M:ActivateHighlight(bCanPlace)
    self.bIsHighlighted = true
    self.bIsLoadHighlight = false
    self.bIsStackHighlight = false
    self:StopAllHighlightAnimations()
    if bCanPlace and self.Value ~= M.VALUE_UNCLICKABLE then
        self:PlayAnimation(self.Able)
    else
        self:PlayAnimation(self.Disable)
    end
end

--- 激活此格子的装配高亮显示（子弹装配模式）
---@param bCanLoad boolean 是否可以装配（true=可装配/绿色, false=弹药已满/红色）
function M:ActivateLoadHighlight(bCanLoad)
    self.bIsHighlighted = true
    self.bIsLoadHighlight = true
    self.bIsStackHighlight = false
    self:StopAllHighlightAnimations()

    if bCanLoad then
        self:PlayAnimation(self.Able)
    else
        self:PlayAnimation(self.Disable)
    end
end

--- 激活此格子的堆叠高亮显示（Other 类型物品堆叠模式）
---@param bCanStack boolean 是否可以堆叠（true=可堆叠/绿色, false=堆叠已满/红色）
function M:ActivateStackHighlight(bCanStack)
    self.bIsHighlighted = true
    self.bIsLoadHighlight = false
    self.bIsStackHighlight = true
    self:StopAllHighlightAnimations()

    if bCanStack then
        self:PlayAnimation(self.Able)
    else
        self:PlayAnimation(self.Disable)
    end
end

--- 停止所有高亮及放置相关动画，避免残留
function M:StopAllHighlightAnimations()
    if self.Normal then self:StopAnimation(self.Normal) end
    if self.Able then self:StopAnimation(self.Able) end
    if self.Disable then self:StopAnimation(self.Disable) end
    if self.Put_Normal then self:StopAnimation(self.Put_Normal) end
    if self.Put_GetPoint then self:StopAnimation(self.Put_GetPoint) end
    if self.Put_Flash then self:StopAnimation(self.Put_Flash) end
    if self.Double_Loop then self:PlayAnimationReverse(self.Double_Loop) end
end

--- 放置动效：item 未满足双倍条件时，被放置格子播放
function M:PlayPutNormal()
    self:StopAllHighlightAnimations()
    if self.Put_Normal then self:PlayAnimation(self.Put_Normal) end
end

--- 放置动效：item 满足双倍条件（全部在双倍区）时，被放置格子播放
function M:PlayPutGetPoint()
    self:StopAllHighlightAnimations()
    if self.Put_GetPoint then self:PlayAnimation(self.Put_GetPoint) end
end

--- 确认动效：点击确认时，被放置格子播放一次闪光
function M:PlayPutFlash()
    if self.Put_Flash then self:PlayAnimation(self.Put_Flash) end
end

--- 确认动效：在双倍条件下点击确认时，额外播放循环动效
function M:PlayDoubleLoop()
    if self.Double_Loop then self:PlayAnimation(self.Double_Loop) end
end

--- 取消此格子的高亮显示
function M:DeactivateHighlight()
    self.bIsHighlighted = false
    self.bIsLoadHighlight = false
    self.bIsStackHighlight = false
    self:StopAllHighlightAnimations()
    self:PlayAnimation(self.Normal)
end

--- 检查此格子是否正在高亮
function M:IsHighlighted()
    return self.bIsHighlighted == true
end

--- 设置 PlayScreen 引用
function M:SetPlayScreen(PlayScreen)
    self.PlayScreen = PlayScreen
end

return M
