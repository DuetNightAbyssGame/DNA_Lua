--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local EMCache = require "EMCache.EMCache"
local HotUpdateUtils = require "Utils.HotUpdateUtils"
local CommonUtils = require "Utils.CommonUtils"

---@type WBP_Download_Content_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:IsCommonGameUpdating()
    local HotUpdateSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UHotUpdateSubsystem)
    if not HotUpdateSubsystem then
        return false
    end
    return HotUpdateSubsystem:IsCommonGameUpdating()
end

function M:IsInGame()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not GameMode then
        return false
    end
    return GameMode:IsA(UE4.AEMGameMode)
end

function M:IsInOptionPatchLevel()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not GameMode then
        return false
    end
    return GameMode:IsA(UE4.AOptionalDownloadGameMode)
end

function M:OnLoaded(NecessoryPatchSigns)
    local bHasIncomingSigns = NecessoryPatchSigns ~= nil
    local IncomingSigns = HotUpdateUtils.NormalizeNecessoryPatchSigns(NecessoryPatchSigns)
    if bHasIncomingSigns then
        HotUpdateUtils.MergeNecessoryPatchSigns(IncomingSigns)
        self:InitDownloadUI(HotUpdateUtils.GetNecessoryPatchSigns())
    else
        self:InitDownloadUI(HotUpdateUtils.GetNecessoryPatchSigns())
    end
    HotUpdateUtils.TryAutoDownloadNextNecessoryPatch(self)
end

function M:SetLangImage()
    if not self.Image_Lang then
        return
    end
    local SystemLanguage = EMCache:Get("SystemLanguage") or "EN"
    if SystemLanguage == "DE" or SystemLanguage == "FR" or SystemLanguage == "ES" then
        SystemLanguage = "EN"
    elseif SystemLanguage == "CN" and UE.AHotUpdateGameMode.IsGlobalPak() then
        SystemLanguage = "CN_OverSea"
    end

    local LanguageFolderMap = {
        CN = "ZH_CHS",
        CN_OverSea = "ZH_CHT",
        EN = "EN",
        JP = "JA",
        JA = "JA",
        KR = "KR",
        TC = "ZH_CHT",
        ZH_CHS = "ZH_CHS",
        ZH_CHT = "ZH_CHT",
    }
    local FolderName = LanguageFolderMap[SystemLanguage] or "EN"
    local TexturePath = "Texture2D'/Game/UI/Texture/Dynamic/Image/Lang/" .. FolderName .. "/T_BG_GameNameIcon_Camera.T_BG_GameNameIcon_Camera'"
    local Texture = LoadObject(TexturePath)
    if Texture then
        self.Image_Lang:SetBrushResourceObject(Texture)
    end
end

function M:InitCommonTab()
    self.WS_Tab:SetActiveWidgetIndex(1)
    self.Com_Tab_M:Init({
            PlatformName = "Mobile",
            -- ForceHideTabs = true,
            BackCallback = function()
                if self:IsInOptionPatchLevel() then
                    UGameplayStatics.OpenLevel(self, "Login")
                else
                    self:Close()
                end
            end,
            OwnerPanel = self,
            DynamicNode = {
                "Back"
            }, 
        })
end

function M:InitDownloadUI(NecessoryPatchSigns, bReInit)
    self:PreInitDownloadUI(NecessoryPatchSigns, bReInit)
    self:InitDownloadContent(NecessoryPatchSigns, bReInit)
    self:PostInitDownloadUI(NecessoryPatchSigns, bReInit)
end

function M:PreInitDownloadUI(NecessoryPatchSigns, bReInit)
    if not bReInit then
        self:SetLangImage()
        self:InitCommonTab()
        self:InitWifiCheckBox()
    end
    self.List_Download.OnCreateEmptyContent:Bind(self, self.CreateEmptyContent)
    self:BindHotUpdateDelegates()
end

function M:InitWifiCheckBox()
    self.Text_DownloadCheckDesc:SetText(GText("UI_Patch_AllowData"))
end

function M:InitDownloadContent(NecessoryPatchSigns, bReInit)
    local HotUpdateSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UHotUpdateSubsystem)
    if not HotUpdateSubsystem then
        return
    end
    self:PlayAnimation(self.In)
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "SplitDownload", nil)
    AudioManager(self):SetEventSoundParam(self, "SplitDownload", {ToEnd = 1})
    rawset(self, "PatchSigns", {})
    rawset(self, "Contents", {})
    if not rawget(self, "DownloadProcess") then
        rawset(self, "DownloadProcess", {})
    end
    for PatchId, PatchResource in pairs(DataMgr.PatchResource) do
        table.insert(self.PatchSigns, PatchId)
    end
    rawset(self, "DownloadedAssetState", HotUpdateSubsystem:GetOptionalPatchAssetStates(self.PatchSigns))
    if not bReInit then
        local OptionalPatchAssetSizeInfo = HotUpdateSubsystem:GetOptionalPatchAssetSizeInfo(self.PatchSigns)
        for k, PatchSign in pairs(self.PatchSigns) do
            local AssetSizeInfo = OptionalPatchAssetSizeInfo:Find(PatchSign)
            if AssetSizeInfo then
                self.DownloadProcess[PatchSign] = { BytesSoFar = AssetSizeInfo.DownloadedSize, TotalBytes = AssetSizeInfo.TotalSize }
            end
        end
        for k, PatchSign in pairs(self.PatchSigns) do
            local Content = self:CreateEmptyContent()
            if Content then
                Content.PatchID = PatchSign
                Content.DownloadedAssetState = self.DownloadedAssetState:Find(PatchSign) or EOptionalPatchAssetState.None
                Content.DownloadProcess = self.DownloadProcess[PatchSign]
                if CommonUtils.HasValue(NecessoryPatchSigns, PatchSign) then
                    Content.bNecessary = true
                end
                self.Contents[PatchSign] = Content
            end
        end
        local SortedContents = {}
        for _, v in pairs(self.Contents) do
            table.insert(SortedContents, v)
        end
        table.sort(SortedContents, function(a, b)
            local NecessaryA = a and a.bNecessary or false
            local NecessaryB = b and b.bNecessary or false
            if NecessaryA ~= NecessaryB then
                return NecessaryA
            end
            local ResourceA = a and a.PatchID and DataMgr.PatchResource[a.PatchID]
            local ResourceB = b and b.PatchID and DataMgr.PatchResource[b.PatchID]
            local PriorityA = tonumber(ResourceA and ResourceA.SortPriority) or math.huge
            local PriorityB = tonumber(ResourceB and ResourceB.SortPriority) or math.huge
            if PriorityA == PriorityB then
                return a.DownloadedAssetState == EOptionalPatchAssetState.Downloading and b.DownloadedAssetState ~= EOptionalPatchAssetState.Downloading
                    or a.PatchID < b.PatchID
            end
            return PriorityA < PriorityB
        end)
        local bSelected = false
        self.List_Download:ClearListItems()
        for _, v in ipairs(SortedContents) do
            self.List_Download:AddItem(v)
            if v.bNecessary and not bSelected then
                v.bSelected = true
                bSelected = true
            end
        end
        if not bSelected and #SortedContents > 0 then
            SortedContents[1].bSelected = true
        end
        self.Contents = SortedContents
        self.List_Download:RequestFillEmptyContent()
    end
end

function M:PostInitDownloadUI(NecessoryPatchSigns, bReInit)
    if not self.Btn_Continue then
        return
    end

    self.Btn_Continue:SetText(GText("UI_Esc_Continue"))
    self.Btn_Continue:UnBindEventOnClickedByObj(self)

    local bAllNecessaryDownloaded = true
    if NecessoryPatchSigns and #NecessoryPatchSigns > 0 then
        local DownloadedAssetState = self.DownloadedAssetState
        if not DownloadedAssetState then
            local HotUpdateSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UHotUpdateSubsystem)
            if HotUpdateSubsystem then
                DownloadedAssetState = HotUpdateSubsystem:GetOptionalPatchAssetStates(NecessoryPatchSigns)
            end
        end
        for _, PatchSign in ipairs(NecessoryPatchSigns) do
            local PatchState = DownloadedAssetState and DownloadedAssetState:Find(PatchSign) or EOptionalPatchAssetState.None
            if PatchState ~= EOptionalPatchAssetState.Downloaded then
                bAllNecessaryDownloaded = false
                break
            end
        end
    end

    self.Btn_Continue:ForbidBtn(not bAllNecessaryDownloaded)
    if bAllNecessaryDownloaded then
        self.Btn_Continue:BindSingleEventOnClicked(self, self.OnClickBackToGame)
    end
end

function M:CreateEmptyContent()
    local EmptyContent = NewObject(LoadClass("/Game/UI/WBP/Download/Widget/BP_Download_Content.BP_Download_Content_C"))
    return EmptyContent
end

function M:OnSelectPatchItem(Content)
    if not Content then
        DebugPrint("Content is nil, cannot select patch item.")
        return
    end
    if Content == self.CurrentSelectedContent then
        return
    end
    local PatchResource = DataMgr.PatchResource[Content.PatchID]
    if not PatchResource then
        DebugPrint("No PatchResource found for PatchID: " .. tostring(Content.PatchID))
        return
    end
    -- self:PlayAnimation(self.In)
    if PatchResource.Background then
        self.BGAnchor:ClearChildren()
        local BG = UIManager(self):CreateWidget(PatchResource.Background)
        if BG then
            self.BGAnchor:AddChild(BG)
            local Slot = BG.Slot
            if Slot then
                Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
                Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
            end
            BG:PlayAnimation(BG.In)
        end
    end
    if PatchResource.TitleBP then
        self.TitleAnchor:ClearChildren()
        local Title = UIManager(self):CreateWidget(PatchResource.TitleBP)
        if Title then
            self.TitleAnchor:AddChild(Title)
        end
    end
    self.Text_TitleDesc:SetText(GText(PatchResource.Desc))
    if self.CurrentSelectedContent and self.CurrentSelectedContent ~= Content then
        if self.CurrentSelectedContent.CurrentEntry then
            self.CurrentSelectedContent.CurrentEntry:SetSelected(false)
        end
        self.CurrentSelectedContent.bSelected = false
    end
    self.CurrentSelectedContent = Content
    self.Text_DownloadBtnDesc:SetText(string.format(GText("UI_Patch_NeedDownload"), GText(PatchResource.Name)))
    if self.Change then
        self:PlayAnimation(self.Change)
    end
end

function M:BindHotUpdateDelegates()
    if self.bHotUpdateDelegateBound then
        return
    end
    local HotUpdateSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UHotUpdateSubsystem)
    if not HotUpdateSubsystem then
        return
    end
    HotUpdateSubsystem.PatchPostSuccessDelegate:Add(self, self.OnPatchPostSuccess)
    HotUpdateSubsystem.AssetDownloadProgressDelegate:Bind(self, self.OnAssetDownloadProgressChanged)
    HotUpdateSubsystem.AssetStartDownloadDelegate:Bind(self, self.OnAssetStartDownload)
    HotUpdateSubsystem.PatchFailedDelegate:Add(self, self.RefreshDownloadedAssetState)
    HotUpdateSubsystem.UpdatePatchOptionalSignsDelegate:Add(self, self.RefreshDownloadedAssetState)
    self.bHotUpdateDelegateBound = true
end

function M:UnbindHotUpdateDelegates()
    if not self.bHotUpdateDelegateBound then
        return
    end
    local HotUpdateSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UHotUpdateSubsystem)
    if not HotUpdateSubsystem then
        return
    end
    HotUpdateSubsystem.PatchPostSuccessDelegate:Remove(self, self.OnPatchPostSuccess)
    HotUpdateSubsystem.AssetDownloadProgressDelegate:Unbind()
    HotUpdateSubsystem.AssetStartDownloadDelegate:Unbind()
    HotUpdateSubsystem.PatchFailedDelegate:Remove(self, self.RefreshDownloadedAssetState)
    HotUpdateSubsystem.UpdatePatchOptionalSignsDelegate:Remove(self, self.RefreshDownloadedAssetState)
    self.bHotUpdateDelegateBound = false
end

function M:OnAssetStartDownload(TotalBytes, DownloadedBytes)
    self:RefreshDownloadedAssetState(false)
end

function M:OnPatchPostSuccess(bFirst)
    self:RefreshDownloadedAssetState(bFirst)
end

function M:RefreshDownloadedAssetState(bFirst)
    if not self.PatchSigns then
        return
    end
    local HotUpdateSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UHotUpdateSubsystem)
    if not HotUpdateSubsystem then
        return
    end
    self.DownloadedAssetState = HotUpdateSubsystem:GetOptionalPatchAssetStates(self.PatchSigns)
    for PatchSign, Content in pairs(self.Contents or {}) do
        if Content then
            Content.DownloadedAssetState = self.DownloadedAssetState:Find(PatchSign) or EOptionalPatchAssetState.None
            if Content.CurrentEntry and Content.CurrentEntry.UpdateDownloadState then
                Content.CurrentEntry:UpdateDownloadState()
            end
        end
    end
end

function M:OnAssetDownloadProgressChanged(Url, BytesSoFar, TotalBytes, PatchSign)
    if not rawget(self, "DownloadProcess") then
        rawset(self, "DownloadProcess", {})
    end
    if not self.DownloadProcess[PatchSign] then
        self.DownloadProcess[PatchSign] = {}
    end
    self.DownloadProcess[PatchSign].BytesSoFar = 0
    self.DownloadProcess[PatchSign].TotalBytes = 0
    self.DownloadProcess[PatchSign][Url] = { BytesSoFar = BytesSoFar, TotalBytes = TotalBytes }
    for _, v in pairs(self.DownloadProcess[PatchSign]) do
        if v and type(v) == "table" and v.BytesSoFar and v.TotalBytes then
            self.DownloadProcess[PatchSign].BytesSoFar = (self.DownloadProcess[PatchSign].BytesSoFar or 0) + v.BytesSoFar
            self.DownloadProcess[PatchSign].TotalBytes = (self.DownloadProcess[PatchSign].TotalBytes or 0) + v.TotalBytes
        end
    end
    for k, Content in pairs(self.Contents or {}) do
        if Content and Content.PatchID == PatchSign then
            Content.DownloadProcess = self.DownloadProcess[PatchSign]
            if Content.CurrentEntry and Content.CurrentEntry.UpdateDownloadProgress then
                Content.CurrentEntry:UpdateDownloadProgress()
            end
            break
        end
    end
end

function M:OnClickBackToGame()
    if self:IsInGame() then
        self:Close()
    else
        UGameplayStatics.OpenLevel(self, "Login")
    end
end

function M:Destruct()
    self:UnbindHotUpdateDelegates()
    self.Super.Destruct(self)
end

function M:Close()
    self.Super.Close(self)
    AudioManager(self):StopSound(self, "SplitDownload")
end



return M
