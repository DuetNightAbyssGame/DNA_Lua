--
-- DESCRIPTION
-- 背包自选道具、材料弹窗
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Bag_OptionalGiftItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:Construct()
end

function M:Destruct()
end

function M:OnListItemObjectSet(Content)
    self:Init(Content)
end

function M:Init(Content)
    if not Content.ItemType then return end
    if not self._components then
        if Content.ItemType == "SelectResource" then

        end
        AssembleComponents(self)
    end
    self.ChooseCallback = Content.ChooseCallback
    self.ParentWidget = Content.ParentWidget
    self.ItemType = Content.ItemType
    self.ChooseDataInfo = {ResourceId = Content.ResourceId, OptionalId = Content.OptionalId, ChooseId = Content.Id, ChooseIndex = Content.ChooseIndex, 
                            ChooseName = Content.Name, ConsumeCount = 1,ChooseWidget = self}
    self.Content = Content
    self.Count = Content.Count

    self:InitCommonView(Content)
end

-- 初始化通用视图
function M:InitCommonView(Content)
    -- 名称
    self.Text_Name:SetText(Content.Name)
    -- self.Text_Num:SetText(string.format(GText("UI_Consumable_HasGot"),1,1))
    self.Text_Num:SetText("×"..Content.Count)

    -- 图标
    local GiftContent = NewObject(UIUtils.GetCommonItemContentClass())
    GiftContent.ParentWidget = self
    GiftContent.Id = Content.Id
    GiftContent.Rarity = Content.Rarity
    GiftContent.ItemType = CommonConst.DataType.Resource
    GiftContent.Name = Content.Name
    -- GiftContent.Count = Content.Count
    GiftContent.IsShowDetails = true
    GiftContent.Icon = Content.Icon
    GiftContent.HandleMouseDown = true
    GiftContent.OnMenuOpenChangedEvents = {Obj = self, Callback = self.OnMenuOpenChangedEvents}
    self.Item_Gift:Init(GiftContent)

    -- self.Com_List.Button_Area.OnClicked:Add(self, self.OnComListClicked)
    -- self.Item_Gift.OnClicked:Add(self, self.OnItemClicked)
end

function M:SetSelected(IsSelected)
    -- self.IsSelected = IsSelected
    -- if IsSelected then
    --     self.Com_List:PlayAnimation(self.Com_List.Select)
    -- else
    --     self.Com_List:PlayAnimation(self.Com_List.Normal)
    -- end 
end

function M:OnComListClicked()
    -- local bNewSelectState = not self.IsSelected
    -- self:SetSelected(bNewSelectState)
    -- local CallbackData = nil
    -- if (bNewSelectState) then
    --     CallbackData = self.ChooseDataInfo
    -- end
    -- if (type(self.ChooseCallback) == "function") then
    --     self.ChooseCallback(self.ParentWidget, bNewSelectState, CallbackData)
    -- end
end

function M:OnItemClicked()
    -- self.Item_Gift:OnClicked()
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
    -- self:OnBtnChooseHovered()
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
    -- self:OnBtnChooseUnHovered()
end

function M:OnBtnChooseHovered()
    if (CommonUtils.GetDeviceTypeByPlatformName(self) == CommonConst.CLIENT_DEVICE_TYPE.MOBILE) then
        return
    end
    if (self.IsSelected) then
        return
    end
    if (not self.IsInHovered) then
        self.Com_List:StopAllAnimations()
        self.Com_List:PlayAnimation(self.Com_List.Hover)
    end
    self.IsInHovered = true
end

function M:OnBtnChooseUnHovered()
    if (CommonUtils.GetDeviceTypeByPlatformName(self) == CommonConst.CLIENT_DEVICE_TYPE.MOBILE) then
        return
    end
    if (self.IsSelected) then
        return
    end
    if (self.IsInHovered) then
        self.Com_List:StopAllAnimations()
        self.Com_List:PlayAnimation(self.Com_List.UnHover)
    end
    self.IsInHovered = false
end

function M:OnMenuOpenChangedEvents(bIsOpen)
    self.ParentWidget:OnMenuOpenChangedEvents(bIsOpen)
end

return M
