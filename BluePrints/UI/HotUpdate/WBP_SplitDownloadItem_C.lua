--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Download_ContentItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

local function FormatValue(Value)
    local Unit = "KB"
    local Divisor = 1024
    if Value >= 1024 * 1024 * 1024 then
        Unit = "GB"
        Divisor = 1024 * 1024 * 1024
    elseif Value >= 1024 * 1024 then
        Unit = "MB"
        Divisor = 1024 * 1024
    end
    return Value / Divisor, Unit
end

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

---@param Content BP_Download_Content
function M:OnListItemObjectSet(Content)
    if not Content then
        return
    end
    self.Content = Content
    self.Content.CurrentEntry = self
    local PatchResource = DataMgr.PatchResource[Content.PatchID]
    if not PatchResource then
        self.Group_Item:SetVisibility(UE4.ESlateVisibility.Collapsed)
        return
    end
    self:BindDelegates()
    self.Group_Item:SetVisibility(UE4.ESlateVisibility.Visible)
    if PatchResource.Icon then
        local MaterialInstance = self.Image_Item:GetDynamicMaterial()
        if MaterialInstance then
            MaterialInstance:SetTextureParameterValue("MainTex", LoadObject(PatchResource.Icon))
        end
    end
    self.Text_DownloadAreaTitle:SetText(GText(PatchResource.Name))
    self.Text_DownloadEnd:SetText(GText("UI_Patch_DownloadFinish"))
    self:PlayAnimation(self.Download_Normal)
    self:UpdateDownloadState()
    self:UpdateNecessaryState()
    if self.Content.bSelected then
        self:SetSelected(true)
    end
end

function M:UpdateNecessaryState()
    if not self.Group_Necessary then
        return
    end
    local bNecessary = self.Content and self.Content.bNecessary
    self.Group_Necessary:SetVisibility(bNecessary and UE4.ESlateVisibility.Visible or UE4.ESlateVisibility.Collapsed)
    if bNecessary and self.Text_NecessaryTitle then
        self.Text_NecessaryTitle:SetText(GText("UI_Patch_Necessory"))
    end
end

function M:BindDelegates()
    self.Btn_Click.OnClicked:Clear()
    self.Btn_Click.OnClicked:Add(self, self.OnButtonClicked)
    self.Btn_DownloadIcon.OnClicked:Clear()
    self.Btn_DownloadIcon.OnClicked:Add(self, self.OnDownloadButtonClicked)
end

function M:OnSelect()
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    if not UIManager then
        return
    end
    local ParentUI = UIManager:GetUIObj("OptionalPatch")
    if not ParentUI then
        return
    end
    self:PlayAnimation(self.BG_Click)
    ParentUI:OnSelectPatchItem(self.Content)
end

function M:SetSelected(bSelected)
    if self.Content then
        -- if self.Content.bSelected == bSelected then
        --     return
        -- end
        self.Content.bSelected = bSelected
    end
    if bSelected then
        self:OnSelect()
    else
        self:PlayAnimation(self.BG_Normal)
    end
end

function M:OnButtonClicked()
    self:SetSelected(true)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_sort_tab", nil, nil)
end

function M:UpdateDownloadState()
    if not self.Content or not self.Text_DownloadEnd then
        return
    end
    local bDownloaded = self.Content.DownloadedAssetState == EOptionalPatchAssetState.Downloaded
    self.Text_DownloadEnd:SetVisibility(bDownloaded and UE4.ESlateVisibility.Visible or UE4.ESlateVisibility.Collapsed)
    self:PlayAnimation(bDownloaded and self.End or self.Active)
    self.Btn_DownloadIcon:SetVisibility(bDownloaded and UE4.ESlateVisibility.Collapsed or UE4.ESlateVisibility.Visible)
    self:UpdateNecessaryState()
    if self.WS_DownloadIcon then
        local bDownloading = self.Content.DownloadedAssetState == EOptionalPatchAssetState.Downloading
        local bPaused = false
        local HotUpdateSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UHotUpdateSubsystem)
        if HotUpdateSubsystem and self.Content.PatchID then
            bPaused = HotUpdateSubsystem:IsPatchOptionSignPaused(self.Content.PatchID)
        end
    end
    self:UpdateDownloadDetail()
end

function M:UpdateDownloadProgress()
    self:UpdateDownloadDetail()
end

function M:UpdateDownloadDetail()
    if not self.Content or not self.Group_DownloadDetail then
        return
    end
    local bDownloaded = self.Content.DownloadedAssetState == EOptionalPatchAssetState.Downloaded
    local bNotStarted = not self.Content.DownloadedAssetState or self.Content.DownloadedAssetState == EOptionalPatchAssetState.None
    local bShowDetail = not (bDownloaded or bNotStarted)
    self.Group_DownloadDetail:SetVisibility(bShowDetail and UE4.ESlateVisibility.Visible or UE4.ESlateVisibility.Collapsed)
    local BytesSoFar = self.Content.DownloadProcess and self.Content.DownloadProcess.BytesSoFar or 0
    local TotalBytes = self.Content.DownloadProcess and self.Content.DownloadProcess.TotalBytes or 0
    if not bShowDetail then
        local HotUpdateSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UHotUpdateSubsystem)
        if self.Progress_Download then
            self.Progress_Download:SetPercent(0)
        end
        if self.Text_DownloadDetail then
            self.Text_DownloadDetail:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        if self.Text_DownloadProgress then
            self.Text_DownloadProgress:SetText(self:FormatProgressText(0, TotalBytes))
        end
        if self.Text_DownloadTitle then
            self.Text_DownloadTitle:SetText(GText("UI_Patch_Support"))
        end
        return
    end


    local Percent = TotalBytes > 0 and (BytesSoFar / TotalBytes) or 0
    if self.Progress_Download then
        self.Progress_Download:SetPercent(Percent)
    end
    if self.Text_DownloadDetail then
        self.Text_DownloadDetail:SetVisibility(UE4.ESlateVisibility.Visible)
        self.Text_DownloadDetail:SetText(string.format("%.0f%%", Percent * 100))
    end
    if self.Text_DownloadProgress then
        self.Text_DownloadProgress:SetText(self:FormatProgressText(BytesSoFar, TotalBytes))
    end

    local bPaused = false
    local HotUpdateSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UHotUpdateSubsystem)
    if HotUpdateSubsystem and self.Content.PatchID then
        bPaused = HotUpdateSubsystem:IsPatchOptionSignPaused(self.Content.PatchID)
    end
    if self.Text_DownloadTitle then
        self.Text_DownloadTitle:SetText(GText(bPaused and "UI_OPTION_Language_Download_Pausing" or "UI_OPTION_Language_Downloading"))
    end
    if not bPaused and self.WS_DownloadIcon:GetActiveWidgetIndex() ~= 0 then
        self:PlayDownloadAnim(true)
    end
end

function M:FormatProgressText(BytesSoFar, TotalBytes)
    local Current = BytesSoFar or 0
    local Total = TotalBytes or 0

    local CurrentValue, CurrentUnit = FormatValue(Current)
    local TotalValue, TotalUnit = FormatValue(Total)
    return string.format("%.2f%s/%.2f%s", CurrentValue, CurrentUnit, TotalValue, TotalUnit)
end

function M:GetParentContents()
    local UIManagerObj = GWorld.GameInstance and GWorld.GameInstance:GetGameUIManager() or nil
    if not UIManagerObj then
        return nil
    end
    local ParentUI = UIManagerObj:GetUIObj("OptionalPatch")
    if not ParentUI or not ParentUI.Contents then
        return nil
    end
    return ParentUI.Contents
end

function M:FindDownloadingContent(Contents)
    if not Contents then
        return nil
    end
    for _, Content in pairs(Contents) do
        if Content and Content.DownloadedAssetState == EOptionalPatchAssetState.Downloading then
            return Content
        end
    end
    return nil
end

function M:CheckNecessaryState(Contents, HotUpdateSubsystem)
    if not Contents or not HotUpdateSubsystem then
        return false, false
    end
    local bHasNecessary = false
    local bNecessaryDownloading = false
    for _, Content in ipairs(Contents) do
        if Content and Content.bNecessary and Content.PatchID then
            bHasNecessary = true
            if HotUpdateSubsystem:IsTagDownloading(Content.PatchID) then
                bNecessaryDownloading = true
                break
            end
        end
    end
    if self.Content and self.Content.bNecessary and self.Content.PatchID then
        bHasNecessary = false
    end
    return bHasNecessary, bNecessaryDownloading
end

function M:OnDownloadButtonClicked()
    local HotUpdateSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UHotUpdateSubsystem)
    if not HotUpdateSubsystem or not self.Content or not self.Content.PatchID then
        return
    end

    local function IsAllowMobileDownload()
        local UIManagerObj = GWorld.GameInstance and GWorld.GameInstance:GetGameUIManager() or nil
        if not UIManagerObj then
            return false
        end
        local ParentUI = UIManagerObj:GetUIObj("OptionalPatch")
        if not ParentUI or not ParentUI.Com_CheckBox_Download then
            return false
        end
        if ParentUI.Com_CheckBox_Download.IsChecked then
            return ParentUI.Com_CheckBox_Download:IsChecked()
        end
        return false
    end

    local function GuardWifiAndStart(StartFunc)
        if not StartFunc then
            return
        end
        local bHasWifi = UHotUpdateFunctionLibrary.HasActiveWiFiConnection()
        local bAllowMobile = IsAllowMobileDownload()
        if not bHasWifi and not bAllowMobile then
            local Params = {
                RightCallbackFunction = function()
                    StartFunc()
                end,
            }
            UIManager(self):ShowCommonPopupUI(100326, Params)
            return
        end
        StartFunc()
    end
    local PatchID = self.Content.PatchID
    if HotUpdateSubsystem:IsTagDownloading(PatchID) then
        if not HotUpdateSubsystem:PauseDownloadOptionalPatchAssets(PatchID, PatchID) then
            UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_OPTION_Language_Pause_Unable"))
        end
        self:PlayDownloadAnim(false)
        self:UpdateDownloadState()
        return
    end
    local Contents = self:GetParentContents()
    local bHasNecessary, bNecessaryDownloading = self:CheckNecessaryState(Contents, HotUpdateSubsystem)
    if bNecessaryDownloading then
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_Patch_DownloadingNecessory"))
        return
    end
    if bHasNecessary then
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_Patch_NeedNecessory"))
        return
    end

    local DownloadingContent = self:FindDownloadingContent(Contents)
    if DownloadingContent and DownloadingContent.PatchID and DownloadingContent.PatchID ~= PatchID then
        local Params = {
            RightCallbackFunction = function()
                GuardWifiAndStart(function()
                    HotUpdateSubsystem:StopUpdateImmediately()
                    HotUpdateSubsystem:TryStartUpdate(PatchID, { PatchID }, true)
                    self:PlayDownloadAnim(true)
                    self:UpdateDownloadState()
                end)
            end,
        }
        UIManager(self):ShowCommonPopupUI(100327, Params)
        return
    end
    local bPaused = HotUpdateSubsystem:IsPatchOptionSignPaused(PatchID)
    local bNoneState = not self.Content.DownloadedAssetState
        or self.Content.DownloadedAssetState == EOptionalPatchAssetState.None
    if bPaused or bNoneState then
        GuardWifiAndStart(function()
            HotUpdateSubsystem:TryStartUpdate(PatchID, { PatchID }, true)
            self:PlayDownloadAnim(true)
        end)
    else
        if not HotUpdateSubsystem:PauseDownloadOptionalPatchAssets(PatchID, PatchID) then
            UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_OPTION_Language_Pause_Unable"))
        end
    end
    self:UpdateDownloadState()
end

function M:PlayDownloadAnim(bDownloading)
    self:StopAnimation(self.Download_Normal)
    self:StopAnimation(self.Download_Hover)
    self:StopAnimation(self.Download_UnHover)
    if bDownloading then
        self:PlayAnimation(self.Download_Click)
    else
        self:PlayAnimationReverse(self.Download_Click)
    end
end

return M
