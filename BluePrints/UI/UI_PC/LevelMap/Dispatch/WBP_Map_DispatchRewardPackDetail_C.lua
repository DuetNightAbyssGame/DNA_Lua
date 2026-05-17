--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Map_DialogDispatchPackDetailItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:OnListItemObjectSet(Content)
    local Name = ItemUtils.GetItemName(Content.Id, Content.Type)
    self.Text_Name:SetText(GText(Name))
    self.Owner = Content.Owner
    local RewardContent = NewObject(UIUtils.GetCommonItemContentClass())
    RewardContent.Id = Content.Id
    RewardContent.Count = Content.Count[1]
    RewardContent.Icon= ItemUtils.GetItemIconPath(Content.Id, Content.Type)
    RewardContent.Rarity = ItemUtils.GetItemRarity(Content.Id, Content.Type)
    RewardContent.ItemType = Content.Type
    -- RewardContent.BonusType = 1
    -- RewardContent.ExtraBonusText = Content.Rate.."%"
    RewardContent.IsShowDetails = true
    RewardContent.AfterInitCallback = function(Widget)
        Widget:BindEvents(self,{
            OnMenuOpenChanged = self.OnRewardMenuOpenChanged
        })
    end  
    self.List_Item:AddItem(RewardContent)

    --self:SetRewardList(Content.RewardId)
end

function M:OnRewardMenuOpenChanged(bIsOpen)
    if self.Owner == nil then
        return
    end
    if bIsOpen then
        self.Owner:HideAllGamepadShortcut()
    else
        self.Owner:ShowGamepadShortcut(4)
        self.Owner:ShowGamepadShortcut(5)
    end

end


return M
