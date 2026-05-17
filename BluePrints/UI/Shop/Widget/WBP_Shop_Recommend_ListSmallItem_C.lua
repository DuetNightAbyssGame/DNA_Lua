--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Shop_Recommend_ListSmallItem_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

function M:Construct()
    self.Super.Construct(self)
    self.Btn_Click.OnClicked:Add(self, self.OnItemClick)
    self.Btn_Click.OnHovered:Add(self, self.OnItemHovered)
    self.Btn_Click.OnUnhovered:Add(self, self.OnItemUnhovered)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:InitItemInfo(BannerData)
    self.BannerData = BannerData
    self.bSelected = false
    self.Content = {}
    self.Content.SelfWidget = self
    self:SetBannerItemIcon(self.Image_ItemIcon, BannerData.BannerIcon)

    self.Text_Title:SetText(GText(BannerData.Text1))
    if BannerData.MarkText then
        self.Group_Sign:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Text_MoreNum:SetText(GText(BannerData.MarkText))
    else
        self.Group_Sign:SetVisibility(ESlateVisibility.Hidden)
    end
end

function M:OnItemClick()
    if self.bSelected then
        local ShopMain = UIManager(self):GetUIObj("ShopMain")
        if ShopMain and ShopMain.TabType == "Banner" and ShopMain.SelectBannerId and ShopMain.BannerIdMap and type(ShopMain.BannerIdMap) == "table" then
            local CurrentPage = ShopMain.BannerIdMap[ShopMain.SelectBannerId]
            if CurrentPage and CurrentPage.HandlePreviewKeyDown and UIUtils.IsGamepadInput() then
                CurrentPage:HandlePreviewKeyDown(nil, Const.GamepadFaceButtonDown)
            end
        end
        return
    end

    self.bSelected = true
    self:StopAllAnimations()
    self:PlayAnimation(self.Click)
    if self.ClickObj then
        self.ClickFunc(self.ClickObj, self.BannerData.Id, self.Content, true)
    end
end

---设置BannerItem的Icon图标
---@param Widget 
---@param IconPath string 图标路径
function M:SetBannerItemIcon(Widget, IconPath)
    local IconDynaMaterial = Widget:GetDynamicMaterial()
    if IconDynaMaterial then
        local Icon = LoadObject(IconPath)
        IconDynaMaterial:SetTextureParameterValue("IconMap", Icon)
    end
end

--- 绑定点击事件
function M:BindBtnClickEvent(Obj, Func)
    self.ClickObj = Obj
    self.ClickFunc = Func
end

function M:OnItemHovered()
    if self.bSelected then
        return
    end
    if UIUtils.IsMobileInput() then
        return
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
    if UIUtils.IsGamepadInput() then
        self:OnItemClick(true)
    end
end

function M:OnItemUnhovered()
    if self.bSelected then
        return
    end
    if UIUtils.IsMobileInput() then
        return
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Unhover)
end

function M:UnSelect()
    self.bSelected = false
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
end

return M
