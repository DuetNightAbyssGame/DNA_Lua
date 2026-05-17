--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local AnnounceModel = AnnounceController:GetModel()

local ReddotNames = {"SystemAnnouncement",  "ActivityAnnouncement", "NewsAnnouncement"}

---@type WBP_Announcement_Main_M_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

function M:Construct()
    M.Super.Construct(self)
    self.VB_Catalog:ClearChildren()
    self.WB_CatalogItem:ClearChildren()
    self.Panel_CatalogItem:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Panel_Catalog:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Text_Fail:SetText(GText("AFDayEvent_PhotoWall_LoadFailed"))
    self.Com_Empty.Text_Empty:SetText(GText("UI_Notice_None"))
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self:SetWebContentVisible(false)
    self.Main:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Com_Empty:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WS_State:SetActiveWidgetIndex(0)
    self.WebContent:BindUObject('obj', self, true)
    self.WebContent.OnLoadCompleted:Add(self, function()
        if self.bWebFailed then return end
        self:SetLoadingVisible(false)
        self.WS_State:SetActiveWidgetIndex(0)
        if self.WebContent:GetUrl()=="about:blank" then
            return
        end
        self:SetWebContentVisible(true)
        self.bWebFailed = false
    end)
    self.WebContent.OnLoadError:Add(self, function()
        self:SetWebContentVisible(false)
        self.WS_State:SetActiveWidgetIndex(1)
        self:SetLoadingVisible(false)
        self.bWebFailed = true
    end)
    self.WebContent.OnLoadStarted:Add(self, function()
        if self.bWebFailed then return end
        self:SetWebContentVisible(false)
        self.WS_State:SetActiveWidgetIndex(2)
        self:SetLoadingVisible(true)
    end)
    self.Btn_Refresh.OnClicked:Add(self, function()
        if self.CurContent then
            self:ChangeMainContent(self.CurContent, true)
        end
    end)
    self.Btn_Close:Init("Close",self, function()
        self:Close()
    end)
    -- self.Btn_Top:BindEventOnClicked(self, function()
    --     self.WebContent:ExecuteJavascript("window.scrollTo(0, 0)")
    -- end)
    -- self.Btn_Bottom:BindEventOnClicked(self, function()
    --     self.WebContent:ExecuteJavascript("window.scrollTo(0, document.body.scrollHeight)")
    -- end)
    self.CurContent = nil
    self:BlockAllUIInput(true, "SP_DisplayOnly")
end

function M:SetLoadingVisible(bVisible)
    if bVisible then
        --self.Com_Loading:PlayAnimation(self.Com_Loading.In)
        self.Com_Loading:PlayAnimation(self.Com_Loading.Loop, 0, 0)
    else
        self.Com_Loading:StopAllAnimations()
    end
end

function M:AddReddotListener(ReddotName, TabIdx)
    ReddotManager.AddListener(ReddotName, self, function(self, Count)
        local NodeConf = DataMgr.ReddotNode[ReddotName]
        local IsNew = NodeConf.Type == 1 and Count>0 
        self.Tab_Announcement:ShowTabRedDot(TabIdx, IsNew, false, false)
    end)
end

function M:RemoveReddotListener(ReddotName)
    ReddotManager.RemoveListener(ReddotName, self)
end

function M:Destruct()
    self.Btn_Top:UnBindEventOnClicked(self)
    self.Btn_Bottom:UnBindEventOnClicked(self)
    self.WebContent:UnbindUObject("obj", self, true)
    for i, NodeName in ipairs(ReddotNames) do
        self:RemoveReddotListener(NodeName)
    end
    M.Super.Destruct(self)
    EMCache:SaveCommon()
    AnnounceController:ClearAnnounceMainUI()
end

function M:SetWebContentVisible(bVisible)
    if bVisible and self.CurContent then
        if self.CurContent.Conf.HasLinkImage or self.CurContent.Conf.UIStyle == AnnounceCommon.ContentUIStyle.Default then
            self.WebContent:SetVisibility(UIConst.VisibilityOp.Visible)
        else
            self.WebContent:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        end
        self.Panel_PageBtn:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self:InitCatalog()
    else
        self.Panel_Catalog:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Panel_PageBtn:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:InitCatalog()
    if #self.CurContent.Conf.SubTitleInfos==0 then
        self.Panel_Catalog:SetVisibility(UIConst.VisibilityOp.Collapsed)
        return
    end
    self.VB_Catalog:ClearChildren()
    self.WB_CatalogItem:ClearChildren()
    self.Panel_Catalog:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Panel_CatalogItem:SetVisibility(UIConst.VisibilityOp.Collapsed)
    for Index,SubTitleInfo in pairs(self.CurContent.Conf.SubTitleInfos) do
        local Btn = UIManager(self):CreateWidget('/Game/UI/WBP/Announcement/Widget/WBP_Announcement_Catalog.WBP_Announcement_Catalog')
        self.VB_Catalog:AddChild(Btn)
        Btn:InitData(SubTitleInfo)
        Btn:SetCallback({CallObj=self, OnClickCallback = self.OnSubBtnClick, OnRemoveFocusCallback = self.OnSubBtnRemovedFromFocusPath})
        local Tab = UIManager(self):CreateWidget('/Game/UI/WBP/Announcement/Widget/WBP_Announcement_CatalogItem.WBP_Announcement_CatalogItem')
        self.WB_CatalogItem:AddChild(Tab)
        Tab:InitData(SubTitleInfo)
        Tab:SetCallback({CallObj=self, OnClickCallback = self.OnSubTabClick})
        if Index == 1 then
            self.CurSubBtn = Btn
            Btn:SetSelected()
            self.CurSubTab = Tab
            Tab:SetSelected()
        end
    end
end

function M:OnSubTabClick(TabWidget)
    if TabWidget ~= self.CurSubTab then
        TabWidget:SetSelected()
        self.CurSubTab:RevertSelect()
        self.CurSubTab = TabWidget
    end
    self.WebContent:ExecuteJavascript()
end

function M:OnSubBtnClick(BtnWidget)
    if BtnWidget ~= self.CurSubBtn then
        BtnWidget:SetSelected()
        self.CurSubBtn:RevertSelect()
        self.CurSubBtn = BtnWidget
    end
    self.Panel_CatalogItem:SetVisibility(UIConst.VisibilityOp.Visible)
end

function M:OnSubBtnRemovedFromFocusPath()
    self.Panel_CatalogItem:SetVisibility(UIConst.VisibilityOp.Collapsed)
end


function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
    M.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
    self.bNeedRequest, self.HostId, self.ShowTag, self.CurrTabIdx = ...
    self:SetUpTabs()
    --self:UpdateAnnoucement()
    self:AddDispatcher(EventID.GameViewportSizeChanged, self, function()
        if self.CurContent then
            self:RealLoadWeb(self.CurContent)
        end
    end)
end

function M:OnLoaded()
    self:BlockAllUIInput(false)
end

function M:_CreateTabParams()
    local TabParams = {
        PlatformName = PlatformName,
        Tabs = {
            {
                Text = GText(DataMgr["NoticeTab"][1]["Text"]),
                TabId = 1,
                Icon = DataMgr["NoticeTab"][1]["IconPath"]
            },
            {
                Text = GText(DataMgr["NoticeTab"][2]["Text"]),
                TabId = 2,
                Icon = DataMgr["NoticeTab"][2]["IconPath"]
            },
            {
                Text = GText(DataMgr["NoticeTab"][3]["Text"]),
                TabId = 3,
                Icon = DataMgr["NoticeTab"][3]["IconPath"]
            }
        },
        ChildWidgetBPPath = "WidgetBlueprint'/Game/UI/WBP/Announcement/Widget/WBP_Announcement_TabCell.WBP_Announcement_TabCell'"
    }
    return TabParams
end

function M:SetUpTabs()
    local PlatformName = CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance)
    if AnnounceController:IsGamepad() then
        PlatformName = "Gamepad"
    end
    local TabParams = self:_CreateTabParams()
    self.Tab_Announcement:Init(TabParams)
    self.Tab_Announcement:BindEventOnTabSelected(self, function(self, TabWidget)
        self.CurrTabIdx = TabWidget.Idx
        self.CurrUrl = nil
        self:UpdateAnnoucement()
    end)
    for i, NodeName in ipairs(ReddotNames) do
        self:AddReddotListener(NodeName, i)
    end
    self.Tab_Announcement:SelectTab(1)
end


function M:UpdateAnnoucement()
    if self.bNeedRequest then
        ForceStopAsyncTask(self, "UpdateAnnouncementTask")
        RunAsyncTask(self, "UpdateAnnouncementTask", function(Coroutine)
            AnnounceController:GetAnnouncementDataAsync(self.ShowTag, Coroutine, self.HostId)
            self:RefreshAllAnnouncement()
        end)
        self.bNeedRequest = false
    else
        self:RefreshAllAnnouncement()
    end
end

function M:RefreshAllAnnouncement()
    HeroUSDKSubsystem(self):UploadTrackLog_Lua("game_show_notice")
    local Confs = AnnounceModel:FilterConfForUI(self.CurrTabIdx, self.ShowTag)
    if not Confs or #Confs == 0 then
        self.Com_Empty:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Main:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
        return
    else
        self.Com_Empty:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Main:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
    
    self.List_Announcement:ScrollToTop()
    self.List_Announcement:ClearListItems()
    
    ---@todo 公告不空
    local bFirst = false
    local LastContent = nil
    for _,Conf in pairs(Confs) do
        if not Conf then goto continue end
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.Conf = Conf
        Content.IsSelected = false
        Content.Parent = self
        Content.Index = Index
        Content.OnChangeMainContent = self.ChangeMainContent
        Content.OnSelectedItenClick = function()
            if AnnounceController:IsGamepad() then
                self.WebContent:SetFocus()
            end
        end
        if (not bFirst) then
            bFirst = true
            Content.bBegin = true
            Content.IsSelected = true
        end
        self.List_Announcement:AddItem(Content)
        LastContent = Content
        ::continue::
    end
    if LastContent then
        LastContent.bLast = true
    end
    self.List_Announcement:RequestPlayEntriesAnim()
end

function M:ChangeMainContent(Content, bForce)
    local bChanged = false
    if self.CurContent and (self.CurContent.Conf.NoticeID ~= Content.Conf.NoticeID) then
        if self.CurContent.Widget then
            self.CurContent.Widget.Btn_Area:SetVisibility(UIConst.VisibilityOp.Visible)
            self.CurContent.Widget.Btn_Area:SetChecked(false)
            self.CurContent.Widget:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
        end
        self.CurContent.IsSelected = false
        bChanged = true
    end
    if not self.CurContent or self.CurContent.Conf.NoticeID ~= Content.Conf.NoticeID or bForce then
        self.WebContent:LoadURL("about:blank")
        self:RemoveTimer(self.GetHtmlHandle)
        local _, key = self:AddTimer(0.1, function()
            self:RealLoadWeb(Content)
        end)
        self.GetHtmlHandle = key
        bChanged = true
    end
    self.CurContent = Content
    return bChanged
end

function M:RealLoadWeb(Content)
    self.bWebFailed = false
    if not self.WebContentSize then
        self.WebContentSize = UIManager(self):GetWidgetRenderSize(self.WS_State)
    end
    AnnounceModel:LoadHtmlContent(Content.Conf, function(DummyUrl, HtmlText)
        if DummyUrl == self.CurrUrl then return end
        self.CurrUrl = DummyUrl
        self.WebContent:LoadURL(DummyUrl)
    end, self.WebContentSize.X)
end

function M:Close()
    M.Super.Close(self)
    AnnounceController:OnCloseAnnounceMainUI()
    self.WebContent:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

return M
