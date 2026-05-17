--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Announcement_ListCell_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})
local AnnounceModel = AnnounceController:GetModel()

function M:Construct()
    self.Btn_Area.OnClicked:Add(self, self.OnClick)
end

function M:OnClick(bForce)
    if not bForce then
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_02",nil,nil)
    end
    if self.Content.OnChangeMainContent(self.Parent, self.Content, bForce) then
        self:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Escape)
        self.Content.IsSelected = true
        if AnnounceController:IsGamepad() then
            self.Btn_Area:SetVisibility(UIConst.VisibilityOp.Collapsed)
            self:SetFocus()
        else 
            self.Btn_Area:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        end
        AnnounceModel:TrySubReddotCacheDetail(self.Content.Conf)
    end
end

function M:OnMouseButtonUp(MyGeo, InMouseEvent)
    if not self.Btn_Area:IsVisible() then
        if self.Content.OnSelectedItenClick then
            self.Content.OnSelectedItenClick(self.Parent)
        end
        return UIUtils.Handled
    end
    return UIUtils.Unhandled
end


function M:OnListItemObjectSet(Content)
    self:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    self:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    self:SetNavigationRuleBase(EUINavigation.Previous, EUINavigationRule.Stop)
    self:SetNavigationRuleBase(EUINavigation.Next, EUINavigationRule.Stop)
    self.Content = Content
    self.Parent = Content.Parent
    Content.Widget = self
    self.Text_AnnouncementTitle:SetText(Content.Conf.NoticeTitle)
    self.Text_Date:SetText(GDate_YMD_Timestamp(Content.Conf.StartTimestamp))
    if CommonConst.SystemLanguage[Content.Conf.Language] == CommonConst.SystemLanguage.TC then
        self.Text_AnnouncementTitle.Font.TypefaceFontName = "Default-TC"
    else
        self.Text_AnnouncementTitle.Font.TypefaceFontName = "Default"
    end
    self.Text_AnnouncementTitle:SetFont(self.Text_AnnouncementTitle.Font)
    if(Content.IsSelected)then 
        self:OnClick(Content.bBegin)
        self.Btn_Area:SetCheckedNoNotify(true)
    else
        self.Btn_Area:SetVisibility(UIConst.VisibilityOp.Visible)
    end

    if Content.bBegin then
        self:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    else
        self:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Escape)
    end
    if Content.bLast then
        self:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    else
        self:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Escape)
    end
    
    self.ReddotName = AnnounceModel:GetReddotNameByConf(Content.Conf)
    self:AddReddotListener(self.ReddotName)
end

function M:BP_OnEntryReleased()
    self.Btn_Area:SetChecked(false)
    if self.Content.Conf then
        self:RemoveReddotListener(self.ReddotName)
    end
    self.Content.Widget = nil
end


function M:Destruct()
    if(self.ReddotName) then
        self:RemoveReddotListener(self.ReddotName)
    end
end


function M:AddReddotListener(ReddotNodeName)
    self:RemoveReddotListener(ReddotNodeName)
    ReddotManager.AddListener(ReddotNodeName,self, self.OnReddotChange)
    self.ListenedReddot = true
end

function M:RemoveReddotListener(ReddotNodeName)
    if(self.ListenedReddot) then
        ReddotManager.RemoveListener(ReddotNodeName,self)
        self.New:SetEnable(false)
        self.ListenedReddot = false
    end
end

function M:OnReddotChange(Count)
    if not self.Content.Conf then return end
    local CacheKey = tostring(self.Content.Conf.NoticeID)
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(self.ReddotName)
    self.New:SetEnable(CacheDetail[CacheKey] and Count>0)
end


return M
