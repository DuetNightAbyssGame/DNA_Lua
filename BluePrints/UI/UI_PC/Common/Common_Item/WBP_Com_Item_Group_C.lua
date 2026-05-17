--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_Item_Group
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

-- 控件排序优先级配置表，用于定义不同控件在Group中的列排序顺序，数值越小优先级越高
local ComItemPriority = {
    ComItemLock = 1,
    ComItemCardLevel = 2,
    ComItemMoney = 3,
    ComItemStartLevel = 4,
    ComItemCustomTag = 5,
    DraftCompendiumItem = 6,
}

function M:Construct()
    self:Init()
end

function M:Init()
    self.WidgetsMap = {}
    self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

--- 创建并添加控件到Group中
-- @param WidgetName 控件名称
-- @return Widget|nil 返回成功创建的控件对象，否则返回nil
function M:CreateAndAddWidgetAsyc(WidgetName, CoroutineObj)
    if not self.WidgetsMap then
        self:Init()
    end

    local AddedWidget = self.WidgetsMap[WidgetName]
    if AddedWidget then
        AddedWidget:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        AddedWidget = UIManager(self):CreateWidgetAsync(WidgetName, CoroutineObj)
        local RowIndex = ComItemPriority[WidgetName]
        if AddedWidget and RowIndex and RowIndex >= 0 then
            local GridSlot = self.GP_ItemGroup:AddChildToGrid(AddedWidget, RowIndex, 0)
            GridSlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Right)
            self.WidgetsMap[WidgetName] = AddedWidget
        end
    end
    return AddedWidget
end

--- 移除指定的控件
-- @param WidgetName string 要移除的控件名称
-- @param bForce bool 默认为nil只是隐藏控件，为true时从group中真正移除
function M:RemoveWidget(WidgetName, bFroce)
    local ChildWidget = self.WidgetsMap[WidgetName]
    if not ChildWidget then
        return
    end

    if bFroce then
        self.GP_ItemGroup:RemoveChild(ChildWidget)
        self.WidgetsMap[WidgetName] = nil
    else
        ChildWidget:SetVisibility(ESlateVisibility.Collapsed)
    end
end

--- 清空Group中的所有控件
function M:ClearWidgets()
    self.GP_ItemGroup:ClearChildren()
    self.WidgetsMap = {}
end

--- 通过名称获取控件对象
-- @param WidgetName string 控件名称
-- @return Widget|nil 找到返回控件对象，否则返回nil
function M:GetWidget(WidgetName)
    if type(WidgetName) == "string" then
        return self.WidgetsMap[WidgetName]
    end
end

--- 获取所有控件的列表
-- @return Widget[] 控件对象数组
function M:GetAllWidgets()
    local AllWidgets = {}
    for _, Widget in pairs(self.WidgetsMap) do
        table.insert(AllWidgets, Widget)
    end
    return AllWidgets
end

--- 获取当前控件数量
-- @return number 控件总数
function M:GetWidgetCount()
    return self.GP_ItemGroup:GetChildrenCount()
end

return M