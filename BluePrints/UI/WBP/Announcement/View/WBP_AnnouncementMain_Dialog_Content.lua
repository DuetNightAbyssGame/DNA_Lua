--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local UIUtils = require "Utils.UIUtils"
local AnnounceModel = AnnounceController:GetModel()
local Utils = require "Utils"

local ReddotNames = {"SystemAnnouncement",  "ActivityAnnouncement", "NewsAnnouncement"}


---@type WBP_Announcement_MainContent_C
local M = Class({"BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"})

function M:Construct()
    M.Super.Construct(self)
    self:SetUpFixedText()

    self.WebContent:SetVisibility(UIConst.VisibilityOp.Visible)
    self.SizeBox_ContentRoot:SetVisibility(UIConst.VisibilityOp.Collapsed)

    if self.WebContent.BindUObject then
        self.WebContent:BindUObject("obj", self, true)
    end
    self.WebContent.OnLoadCompleted:Add(self, function()
        self:ToggleWebContentVisiblity()
    end)
    self.WebContent.OnLoadError:Add(self,function()
        self._LoadError = true
        self:ToggleWebContentVisiblity()
    end)
    self.List_Announcement.OnCreateEmptyContent:Bind(self, function(self)
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.Conf = nil
        Content.IsSelected = false
        Content.Parent = self
        return Content
    end)
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
    self:ShowGoBtn(false)
    self.WebContent:SetNavigationRuleCustom(EUINavigation.Left, {self,self.OnWebContentNavigationLeft})
    self.List_Announcement:SetNavigationRuleCustom(EUINavigation.Right, {self,self.OnListAnnouncementNavigationRight})
    self:AddDispatcher(EventID.OnToggleDisconnectUI, self, function(_, HasConfirmUI)
        self._HasConfirmUIOnWebContent = HasConfirmUI
        self:ToggleWebContentVisiblity()
    end)
end

function M:ToggleWebContentVisiblity()
    if self._HasConfirmUIOnWebContent then
        self.WebContent:SetVisibility(UE4.ESlateVisibility.Collapsed)
        return
    end

    if self._LoadError then
        self.WebContent:SetVisibility(UE4.ESlateVisibility.Visible)
        self._LoadError = nil
        return
    end

    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        -- 根据检查结果决定是否显示WebContent
        if self._HasLinkImage then
        -- 如果存在带链接的图片，显示WebContent
            self.WebContent:SetVisibility(UE4.ESlateVisibility.Visible)
            self.List_Announcement:SetNavigationRuleCustom(EUINavigation.Right, {self,self.OnListAnnouncementNavigationRight})
        else
            -- 如果不存在带链接的图片，隐藏WebContent
            self.WebContent:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
            self.List_Announcement:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
        end
        self._HasLinkImage = false
    else
        self.WebContent:SetVisibility(UE4.ESlateVisibility.Visible)
    end
end

function M:OnBeforePopup(RawUrl,Frame)
    RawUrl = AnnounceModel:UrlDecode(RawUrl)
    local NewUrl = string.lower(RawUrl)
    DebugPrint("看看Url是啥 ", NewUrl)
    if string.find(NewUrl,"opengamesystem|") then
        DebugPrint("应该是找到了系统跳转的关键字了")
        if self.ShowTag ~= AnnounceCommon.ShowTag.InGame then
            DebugPrint(ErrorTag, "该公告类型不是“游戏内公告”，不允许系统跳转！！！！！，公告标题：",self.CurContent.Conf.NoticeTitle)
        end
        local OpenGameSystemInfo = string.split(NewUrl,"opengamesystem|")
        OpenGameSystemInfo = string.split(OpenGameSystemInfo[#OpenGameSystemInfo], ",")
        OpenGameSystemInfo = string.split(OpenGameSystemInfo[1], "，")
        local SystemId = tonumber(OpenGameSystemInfo[1])
        if DataMgr.MainUI[SystemId].AnnouncementMain == "AnnouncementMain" then
            DebugPrint(ErrorTag, "公告不准自己跳自己")
            return
        end
        if SystemId then
            self.Owner.OnCloseCallbackFunction = function()
                UIUtils.OpenSystem(SystemId, "ResumeAnnouncementMain")
            end
            self.Owner:OnCloseBtnClicked()
        else
            DebugPrint(ErrorTag, "该公告的跳转超链接格式不对，不允许系统跳转！！！！！，公告标题：",self.CurContent.Conf.NoticeTitle)
        end
        --@todo OpenGameSystemInfo可能还带了其他参数，用来后面接入跳转到界面更内层部分的功能
        return
    end
    if not string.endswith(NewUrl, "nil") and AnnounceCommon.PlatformName ~= "android" then
        UE4.UKismetSystemLibrary.LaunchURL(RawUrl)
    end
end

function M:Destruct()
    for _,Widget in pairs(self.StyleToContent) do
        if Widget then
            Widget:RemoveFromParent()
        end
    end
    self:UnbindDialogEvent(DialogEvent.OnTitleTabSelected)
    --self.WebContent.OnBeforePopup:Remove(self, self.OnBeforePopup)
    if self.WebContent.UnBindUObject then
        self.WebContent:UnbindUObject("obj", self, true)
    end
    self.WebContent.OnLoadCompleted:Clear()
    self.WebContent.OnLoadError:Clear()
    self.CurrUrl = nil
    self.List_Announcement.OnCreateEmptyContent:Unbind()
    M.Super.Destruct(self)
    AnnounceController:ClearAnnounceMainUI()
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
    EMCache:SaveCommon()
end

function M:SetUpFixedText()
    self.Text_AnnouncementEmpty:SetText(GText("UI_Notice_None"))
end

function M:PreInitContent(Params, PopupData, Owner)
    M.Super.PreInitContent(self, Params, PopupData, Owner)
    self.Group_Normal:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Group_Empty:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.StyleToContent = {}
    self.CurContent = nil
    self.bNeedRequest = Params.bNeedRequest
    self.HostId = Params.HostId
    self.ShowTag = Params.ShowTag
    self.CurrTabIdx = Params.CurrTabIdx
    if self.bNeedRequest == nil then self.bNeedRequest = true end
    self:BindDialogEvent(DialogEvent.OnTitleTabSelected, function(self, TabWidget)
        self.CurrTabIdx = TabWidget.Idx
        self.CurrUrl = nil
        self.List_Announcement:ScrollToTop()
        self:UpdateAnnoucement()
    end)
    for i, NodeName in ipairs(ReddotNames) do
        self:AddReddotListener(NodeName, i)
    end
    self.Owner.CloseBtnCallbackFunction = function ()
        AudioManager(self):SetEventSoundParam(self, "AnnouncementMainOpen", {ToEnd = 1})
        ForceStopAsyncTask(self, "UpdateAnnoucementTask")
        self:StopAllAnimations()
        self:PlayAnimation(self.Out)
        self.WebContent:LoadUrl("about:blank")
        self.WebContent:SetVisibility(UIConst.VisibilityOp.Collapsed)
        for i, NodeName in ipairs(ReddotNames) do
            self:RemoveReddotListener(NodeName)
        end
    end
    self:AddDispatcher(EventID.GameViewportSizeChanged, self, function()
        if self.CurContent then
            self:RealLoadWeb(self.CurContent)
        end
    end)
end

function M:AddReddotListener(ReddotName, TabIdx)
    ReddotManager.AddListener(ReddotName, self, function(self, Count)
        if not self.Owner.DialogTitle then 
            DebugPrint(ErrorTag, LXYTag, "公告弹窗的Tab出错，是因为通用弹窗的Tab初始化时序改了")
            return
        end
        local NodeConf = DataMgr.ReddotNode[ReddotName]
        local IsNew = NodeConf.Type == 1 and Count >0
        self.Owner.DialogTitle.Com_Tab:ShowTabRedDot(TabIdx, IsNew, false, false)
    end)
end

function M:RemoveReddotListener(ReddotName)
    ReddotManager.RemoveListener(ReddotName, self)
end

function M:InitContent(Params, PopupData, Owner)
    M.Super.InitContent(self, Params, PopupData, Owner)
    AudioManager(self):PlayUISound(self, "event:/ui/common/window_filter_common","AnnouncementMainOpen",nil)
    self:UpdateAnnoucement()
    self.GoBtnIndex = self:ShowGamepadShortcutBtn({        
        KeyInfoList = {
        {
            Type = "Img",
            ImgShortPath = "A"
        }},
        Desc = GText("UI_Controller_Go")
    })
end


function M:UpdateAnnoucement()
    if self.bNeedRequest then
        ForceStopAsyncTask(self, "UpdateAnnoucementTask")
        RunAsyncTask(self, "UpdateAnnoucementTask", function(Coroutine)
            AnnounceController:GetAnnouncementDataAsync(self.ShowTag, Coroutine,self.HostId)
            self:RefreshAllAnnouncement()
        end)
        self.bNeedRequest = false
    else
        self:RefreshAllAnnouncement()
    end
    self.List_Announcement:NavigateToIndex(0)
    self:AddTimer(0.1, function()
        local Item =self.List_Announcement:GetItemAt(0)
        if Item and Item.Widget then
            Item.Widget:SetFocus()
            self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
        end
    end)
    self:ShowGoBtn(false)
end

function M:RefreshAllAnnouncement()
    ---公告埋点
    HeroUSDKSubsystem(self):UploadTrackLog_Lua("game_show_notice")
    local Confs = AnnounceModel:FilterConfForUI(self.CurrTabIdx, self.ShowTag)
    self:RefreshScrollTips()
    self.List_Announcement:ClearListItems()
    if not Confs or #Confs==0 then 
        self.Group_Empty:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Group_Normal:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
        return 
    else 
        self.Group_Normal:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Group_Empty:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
    end

    local bFirst = false
    for _,Conf in pairs(Confs) do
        if not Conf then goto continue end
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.Conf = Conf
        Content.IsSelected = false
        Content.Parent = self
        if (not bFirst) then
            bFirst = true
            Content.IsSelected = true
            Content.bForce = true
        end
        self.List_Announcement:AddItem(Content)
        ::continue::
    end
    self.List_Announcement:RequestFillEmptyContent()
end

function M:RealLoadWeb(Content)
    AnnounceModel:LoadHtmlContent(Content.Conf, function(DummyUrl, HtmlText)
        if DummyUrl == self.CurrUrl then return end
        self.CurrUrl = DummyUrl
        self.WebContent:LoadUrl(DummyUrl)
        -- 检查HTML内容中是否存在带有href的img标签
        if HtmlText and UIManager(self):GetGameInputModeSubsystem(self):GetCurrentInputType() == ECommonInputType.Gamepad then
            -- 使用模式匹配查找<a href="..."><img...></a>模式
            self._HasLinkImage = string.match(HtmlText, "<a%s+[^>]*href%s*=%s*[\"']([^\"']+)[\"'][^>]*>%s*<img") ~= nil
        end
    end, UIManager(self):GetWidgetRenderSize(self.WebContent).X)
end

function M:ChangeMainContent(Content, bForce)

    if not self.CurContent or self.CurContent.Conf.NoticeID ~= Content.Conf.NoticeID or bForce then
        self:RemoveTimer(self.GetHtmlHandle)
        local _, key = self:AddTimer(0.1, function()
            self:RealLoadWeb(Content)
        end)
        self.GetHtmlHandle = key
    end
    self.CurContent = Content

end

--region 手柄相关
function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if not self:HasFocusedDescendants() and not self:HasAnyUserFocus() then
        return
    end
    self.CurInputDevice = CurInputDevice
    if self.CurInputDevice == ECommonInputType.Gamepad then
        self:AddTimer(0.1, function()
            local Item =self.List_Announcement:GetItemAt(0)
            if Item then
                Item.Widget:SetFocus()
                self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
            end
            self.List_Announcement:NavigateToIndex(0)
        end)
        self:ShowGoBtn(false)
        self:RefreshScrollTips()
    end
end

function M:RefreshScrollTips()
    local Confs = AnnounceModel:FilterConfForUI(self.CurrTabIdx, self.ShowTag)
    local length = #Confs
    if(length > 0) then
        self:ShowGamepadScrollBtn(true)
    end
end

function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == "Gamepad_RightY") then
        local a = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * -self.ScrollSpeed
        self.WebContent:ExecuteJavascript("window.scrollBy(0, " .. a .. ");")
    end
    return UWidgetBlueprintLibrary.Unhandled()
end

function M:ShowGoBtn(bShow)
    if bShow then
        self:ShowGamepadShortcut(self.GoBtnIndex)
    else
        self:HideGamepadShortcut(self.GoBtnIndex)
    end
end

function M:OnWebContentNavigationLeft(MyGeometry, InKeyEvent)
    self:ShowGoBtn(false)
    return self.List_Announcement
end

function M:OnListAnnouncementNavigationRight(MyGeometry, InKeyEvent)
    self:ShowGoBtn(true)
    return self.WebContent
end


--endregion

return M
