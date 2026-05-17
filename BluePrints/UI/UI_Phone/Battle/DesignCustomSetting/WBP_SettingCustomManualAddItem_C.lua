--
-- DESCRIPTION
-- 外显NodeItem脚本
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:Init(NodeName, NodeData, bHasAddInHUDSetting, ChooseCallback, ParentWidget)
    self.NodeName = NodeName
    self.NodeData = NodeData
    self.ChooseCallback = ChooseCallback
    self.ParentWidget = ParentWidget

    -- 刷新界面上的信息
    self.Text_Name:SetText(self.NodeData.ShowText)
    -- 添加绑定回调
    self.CheckBox:BindEventOnClicked({
        Inst = self,
        Func = self.OnClickCheckBox,
    })
    self.Com_List:BindEventOnClicked(self, self.OnClickCellItem)
    self.Com_List:SetCanCancelSelection(true)
    self.CheckBox:SetIsChecked(bHasAddInHUDSetting)
    self.Com_List:OnCellUnSelect()
end

-- 刷新状态,当界面数据改变时调用
function M:RefreshStateWhenDataChange(bHasAddInHUDSetting)
    self.CheckBox:SetIsChecked(bHasAddInHUDSetting)
    self:CancelCellSelectState()
end

-- 点击CheckBox的回调
function M:OnClickCheckBox(bChecked)
    if (type(self.ChooseCallback) == "function") then
        self.ChooseCallback(self.ParentWidget, bChecked, self.NodeName, self)
    end
    -- if (bChecked) then
    --     self.Com_List:SelectCell()
    -- else
    --     self.Com_List:OnCellUnSelect() 
    -- end
end

-- 点击CellItem的回调
function M:OnClickCellItem()
    local CurChecked = self.CheckBox:IsChecked()
    self.CheckBox:SetIsChecked(not CurChecked)
end

-- 取消Cell的选中状态
function M:CancelCellSelectState()
    self.Com_List:OnCellUnSelect()
end

-- 重置State
function M:ResetState()
    self.CheckBox:UnInitCommonCheckBox()
end

return M
