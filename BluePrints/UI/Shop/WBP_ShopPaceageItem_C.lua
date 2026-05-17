--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type Shop_Package_Cell_PC_C
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
-- end

function M:Init(TableName, ItemId, ItemCount)
    self.Text_Name:SetText(ItemUtils:GetDropName(ItemId, TableName))
    self.Text_Num:SetText("x" .. tostring(ItemCount))
    local Object = NewObject(UIUtils.GetCommonItemContentClass())
    Object.ParentWidget = self
    Object.ItemType = TableName
    Object.Id = ItemId
    Object.Count = nil
    Object.Icon = ItemUtils.GetItemIconPath(ItemId, TableName)
    Object.Rarity = DataMgr[TableName][ItemId].Rarity or DataMgr[TableName][ItemId][TableName .. "Rarity"] or 0
    Object.IsShowDetails = true
    Object.OnFocusReceivedEvent = {
        Obj = self,
        Callback = function()
            self.Parent.ScrollBox_Package:ScrollWidgetIntoView(self)
        end
    }
    Object.UIName = "ShopMain"
    self.Package_Item:Init(Object)

end

-- function M:OnFocusReceived(MyGeometry, InFocusEvent)
--     self.Parent.ScrollBox_Package:ScrollWidgetIntoView(self)
-- end

-- function M:OnMouseEnter(MyGeometry, MouseEvent)
--     DebugPrint("ZDX_PackageItem:OnMouseEnter")
--     return self.Package_Item:OnMouseEnter(MyGeometry, MouseEvent)
-- end

-- function M:OnMouseLeave(MyGeometry, MouseEvent)
--     return self.Package_Item:OnMouseLeave(MyGeometry, MouseEvent)
-- end
-- function M:OnMouseButtonDown(MyGeometry, MouseEvent)
--     return self.Package_Item:OnMouseButtonDown(MyGeometry, MouseEvent)
-- end

-- function M:OnMouseButtonUp(MyGeometry, MouseEvent)
--     return self.Package_Item:OnMouseButtonUp(MyGeometry, MouseEvent)
-- end
--function M:Tick(MyGeometry, InDeltaTime)
--end

return M
