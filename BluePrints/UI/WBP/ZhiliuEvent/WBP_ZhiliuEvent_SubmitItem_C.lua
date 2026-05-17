--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_ZhiliuEvent_SubmitItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:Init(Content)
    self.RealItem:Init(Content)
end

function M:OnListItemObjectSet(Content)
    -- 特殊处理 关掉waring动效残留的部分
    self.CanvasPanel_81:SetVisibility(UE4.ESlateVisibility.Collapsed)

    self.OwningList = UE4.UUserListEntryLibrary.GetOwningListView(self)
    if(self.OwningList)then
        self.OwningList.BP_OnItemClicked:Remove(self,self.OnOwningListItemClicked)
        self.OwningList.BP_OnItemClicked:Add(self,self.OnOwningListItemClicked)
    end

    self.RealItem:OnListItemObjectSet(Content)
end

function M:OnOwningListItemClicked(Content)
    self.RealItem:OnOwningListItemClicked(Content)
end

-- 不知道为什么，点击之后，RealItem调用OnMouseButtonDown之后会立刻调用OnMouseLeave，导致OnMouseButtonUp里面PlayItemSound逻辑走不到
-- 先这么处理吧，有空再深究
function M:OnMouseButtonUp(MyGeometry, MouseEvent)
    AudioManager(self):PlayItemSound(self, self.RealItem.Id, "Click", self.RealItem.ItemType)
    return UWidgetBlueprintLibrary.Unhandled()
end

--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M
