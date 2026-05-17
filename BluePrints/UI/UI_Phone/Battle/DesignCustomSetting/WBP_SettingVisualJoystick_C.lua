--
-- DESCRIPTION
-- 手机端布局自定义Design子Item
-- @AUTHOR HY

require "UnLua"

local BattleHUDCommonConst = require "BluePrints.UI.UI_Phone.Battle.BattleHUDCommonConst"

local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

M._components = {
    "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent",
}

-- 初始化一些变量
function M:Initialize(Initializer)
    self.RelativeNodeWidgetName = nil
    self.RelativeNodeWidgetInfo = nil
    self.TouchAreaWidget = nil
    self.LayoutLocalSize = nil
    -- 操作区域信息(X的值读取配置，Y的值根据服务器记录的值进行设置)
    self.CurAreaRangeXPercent = BattleHUDCommonConst.VisualJoystickConfig.DefaultAreaRangeXPercent
end

--function M:PreConstruct(IsDesignTime)
--end

-- 设置相关节点存档数据
---@param RelativeWidget UWidget 相关节点控件
---@param SaveData table 存档数据
---@param Params table 其他参数
function M:InitRelativeNodeSaveData(RelativeWidget, SaveData, Params)
    self.bHasLocalChanges = false
    self.RelativeNodeWidgetInfo = {
        Widget = RelativeWidget,
        Data = SaveData,
    }
    self.RelativeNodeWidgetName = Params.RelativeName
    self.TouchAreaWidget = Params.TouchAreaWidget
    self.TouchAreaWidget:InitData(self, self.OnModifyPropertyWithMoving)
end

-- 是否有本地修改
function M:IsHasLocalChanges()
    return self.bHasLocalChanges
end

-- 获取相关节点存档数据
function M:GetRelativeNodeSaveData()
    return self.RelativeNodeWidgetInfo
end

-- 获取操作区域X轴占比
function M:GetAreaRangeXPercent()
    return self.CurAreaRangeXPercent
end

-- 获取操作区域X轴占比
function M:GetAreaRangeYPercent()
    return self.CurAreaRangeYPercent
end

-- 重置到默认值
function M:ResetRelativeNodeToDefault()
    self.CurAreaRangeXPercent = BattleHUDCommonConst.VisualJoystickConfig.DefaultAreaRangeXPercent
    self:ResetToDefaultValue(BattleHUDCommonConst.VisualJoystickConfig.DefaultAreaRangeYPercent)
end

-- 更新相关节点位置（选中时候调用）
function M:UpdateRelativeNodeWhenSelected()
    local RelativeNodeWidget = self.RelativeNodeWidgetInfo.Widget
    if (not RelativeNodeWidget) then
        DebugPrint("SettingVisualJoystick== UpdateRelativeNodeWhenSelected: RelativeNodeWidget is nil")
        return
    end
    RelativeNodeWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- 有本地修改则不进行更新
    if (self.bHasLocalChanges) then
        DebugPrint("SettingVisualJoystick== UpdateRelativeNodeWhenSelected: Has Local Changes, Skip Update")
        return
    end
    -- 没有相关节点信息则不进行更新
    if (not self.RelativeNodeWidgetInfo) then
        DebugPrint("SettingVisualJoystick== UpdateRelativeNodeWhenSelected: RelativeNodeWidgetInfo is nil")
        return
    end
    local RelativeNodeSaveData = self.RelativeNodeWidgetInfo.Data or {}
    local RelativeNodeSlot = RelativeNodeWidget.Slot
    if (RelativeNodeSlot) then
        local LayoutWidgetGeometry = self.OwnerWidget:GetCachedGeometry()
        local WidgetLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(LayoutWidgetGeometry)
        self.LayoutLocalSize = WidgetLocalSize
        DebugPrint("SettingVisualJoystick== UpdateRelativeNodeWhenSelected: Update MoveRangePos RelativeNodeSaveData is ", RelativeNodeSaveData.AreaRangeSizeY, 
                    RelativeNodeSaveData.AreaRangeSizeYPercent, WidgetLocalSize.Y)
        if (RelativeNodeSaveData.AreaRangeSizeY) then
            RelativeNodeSlot:SetSize(FVector2D(0, RelativeNodeSaveData.AreaRangeSizeY))
            self.CurAreaRangeYPercent = RelativeNodeSaveData.AreaRangeSizeY / WidgetLocalSize.Y
        else
            RelativeNodeSlot:SetSize(FVector2D(0, WidgetLocalSize.Y * BattleHUDCommonConst.VisualJoystickConfig.DefaultAreaRangeYPercent)) 
            self.CurAreaRangeYPercent = BattleHUDCommonConst.VisualJoystickConfig.DefaultAreaRangeYPercent
        end
    end
end

-- 修改相关节点属性（被拖拽控件拖动时候调用）
---@param LastPosition FVector2D 上一次拖动位置
---@param CurPosition FVector2D 当前拖动位置
function M:OnModifyPropertyWithMoving(LastPosition, CurPosition)
    if (not self.LayoutLocalSize) then
        local LayoutWidgetGeometry = self.OwnerWidget:GetCachedGeometry()
        self.LayoutLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(LayoutWidgetGeometry)
    end
    local RelativeNodeWidget = self.RelativeNodeWidgetInfo.Widget
    local RelativeNodeSlot = RelativeNodeWidget.Slot
    if (RelativeNodeSlot) then
        self.bHasLocalChanges = true
        local DeltaValueY = LastPosition.Y - CurPosition.Y
        local DesireRelativeSizeY = UE.UKismetMathLibrary.FClamp(RelativeNodeSlot:GetSize().Y + DeltaValueY, self.LayoutLocalSize.Y * BattleHUDCommonConst.VisualJoystickConfig.AreaRangeYPercentMin, 
                                        self.LayoutLocalSize.Y * BattleHUDCommonConst.VisualJoystickConfig.AreaRangeYPercentMax)
        RelativeNodeSlot:SetSize(FVector2D(0, DesireRelativeSizeY))
        self.CurAreaRangeYPercent = DesireRelativeSizeY / self.LayoutLocalSize.Y
        self:CallOwnerRefreshForRelativeNodeChange()
        -- 动态调整位置
        self:AdjustPositioByRelativeWidgetChange(self.ParentLayoutNode or self.DraggableWidget)
        DebugPrint("SettingVisualJoystick== OnModifyPropertyWithMoving: Update MoveRangePos DesireRelativeSizeY is ", DesireRelativeSizeY, ", The Percent is ", self.CurAreaRangeYPercent)
    end
end

-- 修改相关节点属性（被滑动条控件滑动时候调用）
---@param NewValue number 新的值
function M:OnModifyPropertyWithSlideChange(NewValue)
    if (not self.LayoutLocalSize) then
        local LayoutWidgetGeometry = self.OwnerWidget:GetCachedGeometry()
        self.LayoutLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(LayoutWidgetGeometry)
    end
    local RelativeNodeWidget = self.RelativeNodeWidgetInfo.Widget
    local RelativeNodeSlot = RelativeNodeWidget.Slot
    if (RelativeNodeSlot) then
        self.bHasLocalChanges = true
        local DesireRelativeSizeY = UE.UKismetMathLibrary.FClamp(self.LayoutLocalSize.Y * NewValue, self.LayoutLocalSize.Y * BattleHUDCommonConst.VisualJoystickConfig.AreaRangeYPercentMin, 
                                        self.LayoutLocalSize.Y * BattleHUDCommonConst.VisualJoystickConfig.AreaRangeYPercentMax)
        RelativeNodeSlot:SetSize(FVector2D(0, DesireRelativeSizeY))
        self.CurAreaRangeYPercent = DesireRelativeSizeY / self.LayoutLocalSize.Y
        -- 动态调整位置
        self:AdjustPositioByRelativeWidgetChange(self.ParentLayoutNode or self.DraggableWidget)
        DebugPrint("SettingVisualJoystick== OnModifyPropertyWithSlideChange: Update MoveRangePos DesireRelativeSizeY is ", DesireRelativeSizeY, ", The Percent is ", self.CurAreaRangeYPercent)
    end
end

-- 重置到默认值
---@param DefaultValue number 默认值
function M:ResetToDefaultValue(DefaultValue)
    if (not self.LayoutLocalSize) then
        local LayoutWidgetGeometry = self.OwnerWidget:GetCachedGeometry()
        self.LayoutLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(LayoutWidgetGeometry)
    end
    local RelativeNodeWidget = self.RelativeNodeWidgetInfo.Widget
    local RelativeNodeSlot = RelativeNodeWidget.Slot
    if (RelativeNodeSlot) then
        self.bHasLocalChanges = true
        local DesireRelativeSizeY = self.LayoutLocalSize.Y * DefaultValue
        RelativeNodeSlot:SetSize(FVector2D(0, DesireRelativeSizeY))
        self.CurAreaRangeYPercent = DefaultValue
        -- 通知拥有者刷新相关节点的信息
        self:CallOwnerRefreshForRelativeNodeChange()
        DebugPrint("SettingVisualJoystick== ResetToDefaultValue: Update MoveRangePos DesireRelativeSizeY is ", DesireRelativeSizeY, ", The Percent is ", self.CurAreaRangeYPercent)
    end
end

-- 通知拥有者此控件的相关节点发生变化
function M:CallOwnerRefreshForRelativeNodeChange()
    if (self.OwnerWidget and type(self.OwnerWidget.UpdateSliderValue) == "function") then
        self.OwnerWidget:UpdateSliderValue("Stretch", self.CurAreaRangeYPercent)
    end
end

-- 隐藏所有相关节点
function M:HideRelativeNodeWhenUnSelected(bHide)
    local RelativeNodeWidget = nil
    if (self.RelativeNodeWidgetInfo) then
        RelativeNodeWidget = self.RelativeNodeWidgetInfo.Widget
    elseif (self.RelativeNodeName) then
        RelativeNodeWidget = self.OwnerWidget[self.RelativeNodeName]
    end
    if (RelativeNodeWidget) then
        RelativeNodeWidget:SetVisibility(bHide and UE4.ESlateVisibility.Collapsed or UE4.ESlateVisibility.SelfHitTestInvisible)
    end
end

AssembleComponents(M)

return M
