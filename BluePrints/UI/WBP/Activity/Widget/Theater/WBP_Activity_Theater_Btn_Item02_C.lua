--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_Theater_Btn_item02_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:OnListItemObjectSet(Content)
    self.Content = Content
    self.Content.UI = self
    if self.Content.Progress >= self.Content.Target then
        self:PlayAnimation(self.Finished)
    else
        self:PlayAnimation(self.Normal)
    end
    self:InitUI()
end

function M:InitUI()
    local ResourceData = DataMgr.Resource[self.Content.Resource]
    local ItemContent = {
        Id = self.Content.Resource,
        ItemType = "Resource",
        Icon = ResourceData.Icon,
        Rarity = ResourceData.Rarity,
        IsShowDetails = true,
        HandleMouseDown = true,
        OnMenuOpenChangedEvents = {Obj = self.Content.ParentWidget, Callback = self.Content.ParentWidget.ItemMenuAnchorChanged}
    }
    self.Com_Item_S:Init(ItemContent)
    self.Text_Item_Name:SetText(GText(ResourceData.ResourceName))
    if self.Content.Progress >= self.Content.Target then
        self.Text_Num:SetText(self.Content.Target .. "/" .. self.Content.Target)
    else
        self.Text_Num:SetText(self.Content.Progress .. "/" .. self.Content.Target)
    end
    self.Progress_Num:SetPercent(self.Content.Progress / self.Content.Target)
    self.Progress_NumGrow:SetPercent(0)
end

function M:SetAddProgress(num)
    if num == 0 or num == nil or self.Content.Progress + num > self.Content.Target then
        if self.Content.Progress >= self.Content.Target then
            self.Text_Num:SetText(self.Content.Target .. "/" .. self.Content.Target)
        else
            self.Text_Num:SetText(self.Content.Progress .. "/" .. self.Content.Target)
        end
        self.Progress_Num:SetPercent(self.Content.Progress / self.Content.Target)
        self.Progress_NumGrow:SetPercent(0)
    else
        self.Text_Num:SetText(self.Content.Progress .. "<Qua2>+" .. num .. "</>/" .. self.Content.Target)
        self.Progress_Num:SetPercent(self.Content.Progress / self.Content.Target)
        self.Progress_NumGrow:SetPercent((self.Content.Progress + num) / self.Content.Target)
    end
end

return M
