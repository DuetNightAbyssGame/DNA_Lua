--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Fame_ItemStar_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

function M:Init(Content)
    rawset(self, "Type", Content.Type)
    rawset(self, "Level", Content.Level)

    rawset(self, "Id", Content.Id)
    rawset(self, "Icon", Content.Icon)
    rawset(self, "ItemType", Content.ItemType)
    rawset(self, "Count", Content.Count)
    rawset(self, "bCanGet", Content.bCanGet)
    rawset(self, "CanGetStyle", Content.CanGetStyle)
    rawset(self, "IsShowDetails", Content.IsShowDetails)
    rawset(self, "OnMenuOpenChangedEvents", Content.OnMenuOpenChangedEvents)

    self:InitDetail()
end

function M:InitDetail()
    if self.Type == 1 then
        self.ListStar:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        local StarMaxCount = 3
        for i = 1, StarMaxCount do
            if self.Level >= i then
                self["Star_"..i]:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            else
                self["Star_"..i]:SetVisibility(UIConst.VisibilityOp.Collapsed)
            end
        end
        self.ListStar:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end

    local Content = NewObject(UIUtils.GetCommonItemContentClass())

    Content.Id = self.Id
    Content.Icon = self.Icon
    Content.ItemType = self.ItemType
    Content.Count = self.Count
    Content.IsShowDetails = self.IsShowDetails
    Content.bCanGet = self.bCanGet
    Content.CanGetStyle = self.CanGetStyle
    Content.OnMenuOpenChangedEvents = self.OnMenuOpenChangedEvents
    self.Item_S:Init(Content)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M
