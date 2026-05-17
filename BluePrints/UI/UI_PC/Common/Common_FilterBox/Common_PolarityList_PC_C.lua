--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type Common_PolarityList_PC_C
local M = Class("BluePrints.UI.BP_UIState_C")

function M:Init(Filters)
    self.Filters = Filters or {}
    self.SelectedItem = {}
    self.List:ClearListItems()
    if(Filters and #Filters >0)then
        self.Filters = Filters
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        Obj.Text = GText(Filters[1].TextMapId)
        Obj.IsSelected = true
        Obj.Mode = "Single"
        Obj.Polarity = Filters[1].Polarity
        Obj.Owner = self
        self.SelectedItem = Obj
        self.List:AddItem(Obj)
        for i=2, #Filters do
            Obj = NewObject(UIUtils.GetCommonItemContentClass())
            Obj.Text = GText(Filters[i].TextMapId)
            Obj.Mode = "Single"
            Obj.IsSelected = false
            Obj.Polarity = Filters[i].Polarity
            Obj.Owner = self
            self.List:AddItem(Obj)
        end
        self.Filter_List:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self.Filter_List:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
    self:UpdateFilterInfos()
end

--- 绑定筛选选项变更事件
function M:BindEventOnSelectionsChanged(Obj,Event)
    self.Obj_OnSelectionsChanged = Obj
    self.Event_OnSelectionsChanged = Event
end

---@return int 选筛选器的选中项索引
function M:GetFilterInfos()
    return self.FilterRes
end

-------------

function M:UpdateFilterInfos()
    self.FilterRes = self.SelectedItem.Polarity
    return self.FilterRes
end

function M:Construct()
    --self.List.BP_OnItemClicked:Add(self, self.OnListItemClicked)
    --self.List.BP_OnItemIsHoveredChanged:Add(self, self.OnListItemHoveredChanged)
end

function M:OnListItemClicked(Content)
    if not (Content.IsSelected) then return end
    if(self.SelectedItem ~= Content)then
        self.SelectedItem.Entry:DeSelect()
        self.SelectedItem = Content
    else
        return
    end
    local FilterIdx = self:UpdateFilterInfos()
    if(self.Event_OnSelectionsChanged)then
        self.Event_OnSelectionsChanged(self.Obj_OnSelectionsChanged, FilterIdx)
    end
end

-- function M:OnListItemHoveredChanged(Content,IsHover)
--     Content.Entry:OnEntryHoveredChanged(IsHover)
-- end

--- 切换列表选中项
function M:UpdateListIndex(indexChange)
    if (self.List == nil) then
        return
    end
    local SelectedItem = self.List:BP_GetSelectedItem()
    local MaxIndex = self.List:GetNumItems() - 1
    local index = 0
    if SelectedItem then
        index = self.List:GetIndexForItem(SelectedItem)
    end
    local newIndex = math.clamp(index + indexChange, 0, MaxIndex)
    if (newIndex ~= index) then
        self.List:SetSelectedIndex(newIndex)
        SelectedItem = self.List:BP_GetSelectedItem()
        if (SelectedItem and SelectedItem.Entry) then
            SelectedItem.Entry:OnBtnClick()
        end
    end
end


return M
