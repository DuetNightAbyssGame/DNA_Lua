--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_PersonalInfo_Title_TitleContentItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
-- function M:Initialize(Initializer)
-- end
function M:OnListItemObjectSet(ItemObject)
    self.Text_Title:SetText(GText(ItemObject.Name))
    if  not ItemObject.IsSelected then
        self.Text_Title:SetRenderOpacity(0.4)
        else
        self.Text_Title:SetRenderOpacity(1)
    end
    ItemObject.UI = self
    self.Item=ItemObject
    if ItemObject.TitleID~=-1 then--放在这里不放在Item初始化是因为有复制的Item，New更新不及时
        local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("Title")
        if CacheDetail and  CacheDetail[ItemObject.TitleID] then
            self.New:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        else
            self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
        ItemObject.IsNew=true
    else
        self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
        ItemObject.IsNew=false
    end
end
function M:OnEntryReleased()

end
function M:SetNotNew()
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("Title")
    UIUtils.TrySubReddotCacheDetailNumber(self.Item.TitleID,"Title")
    self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

-- function M:Construct()
-- end

-- function M:Tick(MyGeometry, InDeltaTime)
-- end

-- function M:Destruct()
-- end

return M
