local M = Class({
    "BluePrints.UI.BP_EMUserWidget_C",
    "BluePrints.Common.TimerMgr",
})

local PhotoWallModel = require "BluePrints.UI.WBP.Activity.PC.Fool.Model.PhotoWallModel"

ETabType = {
    Hottest = 1,
    Latest = 2,
    MyLike = 3,
}

-- 按批次加载图片，一次加载的数量
local SizeOfBatch = 20

function M:Construct()
    self.bEntered = false
    self.ContentNum = 0
    self.RefreshTimes = 0
    self.CurrTabId = nil
    self.CurContent = nil
    -- 绑定空Item创建方法
    self.List_FoolOtherDetail.OnCreateEmptyContent:Bind(self, function()
        return self:CreateEmptyItem()
    end)
    self.List_FoolOtherDetail.BP_OnEntryInitialized:Add(self,self.OnItemScrolledIntoView)
    self.List_FoolOtherDetail.BP_OnItemIsHoveredChanged:Add(self, self.OnItemHoveredChanged)
end

function M:Destruct()
    self.bEntered = false
    self:UnbindFromAnimationFinished(self.Out, {self, self.OnOutAnimationFinished})
end

function M:EnterPage()
    if self.bEntered then return end
    self.bEntered = true
    self.CurContent = nil
    PhotoWallModel:SetBatchSize(20)
    self:InitTable()
    self.Parent:OnTabDetailInited(false)
    self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self:UnbindFromAnimationFinished(self.Out, {self, self.OnOutAnimationFinished})
    self:StopAllAnimations()
    self:PlayAnimation(self.In)
    self.bActive = true
end

function M:LeavePage()
    if not self.bEntered then 
        self:SetVisibility(ESlateVisibility.Collapsed)
        return 
    end
    self.bEntered = false
    self.CurrTabId = nil
    self.CurContent = nil
    self.bFetchingNewPhotos = false
    self:StopAllAnimations()
    self:BindToAnimationFinished(self.Out, {self, self.OnOutAnimationFinished})
	self:PlayAnimation(self.Out)
    self.List_FoolOtherDetail:ClearListItems()
end

function M:OnOutAnimationFinished()
    self:SetVisibility(ESlateVisibility.Collapsed)
    self:UnbindFromAnimationFinished(self.Out, {self, self.OnOutAnimationFinished})
end

function M:InitTable()
    self.Parent:UpdateBottomKeyInfo(false)
    self.Com_Tab:Init({Tabs = {
        { Text = GText("AFDayEvent_PhotoWall_Hottest"), TabId = 1},
        { Text = GText("AFDayEvent_PhotoWall_Latest"), TabId = 2},
        { Text = GText("AFDayEvent_PhotoWall_MyLikes"), TabId = 3},
        },
        SoundFunc = function()
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_sort_tab", nil, nil)
        end,
        ChildWidgetBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/Widget/Fool/Tab/WBP_Activity_Fool_TabSubItem.WBP_Activity_Fool_TabSubItem'"
    })
    self.Com_Tab:BindEventOnTabSelected(self, self.OnTabChanged)
    self:AddTimer(0.1, function()
        self.Com_Tab:SelectTab(1)
        self:SetFocus()
    end, nil, nil, "DelaySelectTab", true)
end

function M:UpdateBottomKeyInfo(bEdit, bHide)
    if IsValid(self.Parent) then
        self.Parent:UpdateBottomKeyInfo(bEdit, bHide)
    end
end

function M:OnItemScrolledIntoView(Item, Widget)
    if self.CurrTabId == ETabType.MyLike then return end
    if self.bIniting or self.bFetchingNewPhotos then return end
    if not IsValid(Item) then return end
    if self.ContentNum <= 0 then return end
    if Item == self.List_FoolOtherDetail:GetItemAt(self.ContentNum-1) then
        self:FetchPhotosInBatch()
    end
end

function M:OnItemHoveredChanged(Content,IsHover)
    if not IsValid(Content) then return end
    if IsHover then
        if IsValid(self.CurContent) then
            if self.CurContent ~= Content then
                local CurEntryUI = self.CurContent.Widget
                if IsValid(CurEntryUI) and CurEntryUI.bAnchorOpen and CurEntryUI.Head_Anchor then
                    CurEntryUI.Head_Anchor:Close()
                end
            end
        end
        self.CurContent = Content
    end
    if IsValid(Content.Widget) then
        Content.Widget:SwitchUIType(self.bGamepad and IsHover)
    end
end

function M:OnTabChanged(TabWidget)
    if self.CurrTabId == TabWidget:GetTabId() then return end
    self.CurrTabId = TabWidget:GetTabId()
    if self.CurrTabId == ETabType.Hottest then
        PhotoWallModel:StartFetchHottest(SizeOfBatch)
    elseif self.CurrTabId == ETabType.Latest then
        PhotoWallModel:StartFetchFreshest(SizeOfBatch)
    end
    self:ResetCurContent()
    self:RefreshList()
    self:UpdateEmptyText()
end

function M:ResetCurContent()
    if IsValid(self.CurContent) then
        if IsValid(self.CurContent.Widget) then
            self.CurContent.Widget:SwitchUIType(false)
        end
    end
    self.CurContent = nil
end

function M:UpdateEmptyText()
    if not self.CurrTabId then return end
    if self.CurrTabId == ETabType.MyLike then
        self.Text_Empty:SetText(GText("AFDayEvent_PhotoWall_MyLikes_Empty"))
    else
        self.Text_Empty:SetText(GText("AFDayEvent_PhotoWall_Empty"))
    end
end

function M:RefreshList()
    self.ContentMap = {}
    self.ContentNum = 0
    self.EmptyItems = {}
    self.CurrentExpandId = nil
    self.RefreshTimes = self.RefreshTimes + 1
    self.List_FoolOtherDetail:ClearListItems()
    self.bIniting = true
    self.WS_List:SetVisibility(ESlateVisibility.Collapsed)
    self.List_FoolOtherDetail:RequestFillEmptyContent()
    if self.CurrTabId ~= ETabType.MyLike then
        self:FetchPhotosInBatch()
    else
        self:FetchPhotoDocs(PhotoWallModel:FetchMyLikeFoolsDayPhotoIds())
    end
    self:DelaySetFocusTarget()
end

function M:FetchPhotosInBatch()
    self.bFetchingNewPhotos = true
    local RefreshTimes = self.RefreshTimes
    PhotoWallModel:FetchBatch(function(Photos)
        DebugPrint("FetchPhotosInBatch@Cnt", Photos and #Photos)
        self:AddPhotoIntoList(Photos, RefreshTimes)
    end)
end

function M:FetchPhotoDocs(PhotoIds)
    if not PhotoIds then return end
    local RefreshTimes = self.RefreshTimes
    if #PhotoIds <= 0 then
        self:AddPhotoIntoList({}, RefreshTimes)
        return
    end
    local Callback = function(PhotoDocs)
        DebugPrint("FetchPhotoDocs@Cnt", PhotoDocs and #PhotoDocs)
        self:AddPhotoIntoList(PhotoDocs, RefreshTimes)
    end
    PhotoWallModel:FetchPhotoDocs(PhotoIds, nil, Callback)
end

function M:AddPhotoIntoList(Photos, RefreshTimes)
    if self.RefreshTimes ~= RefreshTimes then return end
    local Photos = Photos or {}
    local PhotosCnt = CommonUtils.Size(Photos)
    if (self.bIniting) then
        -- 初始化时
        self.List_FoolOtherDetail:ClearListItems()
        self.WS_List:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        if(PhotosCnt > 0)then
            self.WS_List:SetActiveWidgetIndex(0)
            self:AddTimer(0.01, function()
                --刷新列表显示项，让加载失败的图片重新加载
                for _, Content in pairs(self.ContentMap) do
                    if IsValid(Content.Widget) then
                        Content.Widget:ResetEntryUI(Content.PhotoDoc)
                    end
                end
                -- 将列表滚动至最上方
                self.List_FoolOtherDetail:RegenerateAllEntries()
                self.List_FoolOtherDetail:ScrollToTop()
            end,false, 0, "DelayRefresh",true)
        else
            self.WS_List:SetActiveWidgetIndex(1)
        end
        self.bIniting = false
        self.List_FoolOtherDetail:RequestPlayEntriesAnim()
    end
    self:RemoveEmptyItems()
    local NewPhotos = {}
    for _, Photo in ipairs(Photos) do
        local PhotoId = Photo.PhotoId
        local PhotoDoc = Photo
        PhotoWallModel:UpdatePhotoDoc(PhotoId, PhotoDoc)
        if self.ContentMap[PhotoId] then goto continue end
        local Content = PhotoWallModel:GetPhotoData(PhotoId)
        if not Content then
            Content = NewObject(UIUtils.GetCommonItemContentClass())
            Content.PhotoId = PhotoId
            Content.PhotoDoc = PhotoDoc
            self.BP_ContentsArray:Add(Content)
            PhotoWallModel:SavePhotoData(PhotoId, Content)
        end
        Content.OnDetailExpanded = function(bExpand)
            self:OnDetailExpanded(Content, bExpand)
        end
        Content.Owner = self
        self.ContentMap[PhotoId] = Content
        self.List_FoolOtherDetail:AddItem(Content)
        ::continue::
    end
    if (not self.bIniting) or (PhotosCnt > 0) then
        self.List_FoolOtherDetail:RequestFillEmptyContent()
    end

    self.bFetchingNewPhotos = false
    self.ContentNum = self.ContentNum + PhotosCnt
end

function M:CreateEmptyItem()
    local EmptyContent = NewObject(UIUtils.GetCommonItemContentClass())
    EmptyContent.IsEmpty = true
    table.insert(self.EmptyItems, EmptyContent)
    return EmptyContent
end

function M:RemoveEmptyItems()
    for _, Content in ipairs(self.EmptyItems) do
        if IsValid(Content) then
            self.List_FoolOtherDetail:RemoveItem(Content)
        end
    end
    self.EmptyItems = {}
end

function M:OnDetailExpanded(Content, bExpand)
    if not IsValid(Content) or not IsValid(Content.Widget) then return end
    if not Content.PhotoId then return end
    DebugPrint("Fool_OtherDetail@OnDetailExpanded", self.CurrentExpandId, Content.PhotoId, bExpand)
    if bExpand then
        self.CurrentExpandId = Content.PhotoId
    elseif self.CurrentExpandId == Content.PhotoId then
        self.CurrentExpandId = nil
    end
end

function M:OnPhotoDeleted(PhotoId)
    if not self.ContentMap or not self.ContentMap[PhotoId] then return end
    local Content = self.ContentMap[PhotoId]
    self.ContentMap[PhotoId] = nil
    PhotoWallModel:DeletePhotoData(PhotoId)
    if IsValid(Content.Widget) then 
        Content.Widget:OnPhotoDeleted()
    end
    self.List_FoolOtherDetail:RemoveItem(Content)
    self:RemoveEmptyItems()
    self.List_FoolOtherDetail:RequestFillEmptyContent()
    if self.ContentNum > 0 then
        self.ContentNum = self.ContentNum - 1
    end
    if self.CurrentExpandId and self.CurrentExpandId ~= PhotoId then
        local CurExpandContent = self.ContentMap[self.CurrentExpandId]
        if IsValid(CurExpandContent) then
            self.List_FoolOtherDetail:BP_NavigateToItem(CurExpandContent)
        end
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadDown(InKeyName)
    else
        if InKeyName == "A" or InKeyName == "D" then
            IsEventHandled = self.Com_Tab:Handle_KeyEventOnPC(InKeyName)
        else

        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

function M:OnGamePadDown(InKeyName)
    local IsEventHandled = false
    if InKeyName == "Gamepad_LeftTrigger" or InKeyName == "Gamepad_RightTrigger"  then
        IsEventHandled = self.Com_Tab:Handle_KeyEventOnGamePad(InKeyName)
    else
        
    end
    return IsEventHandled
end

function M:SwitchUIType(bGamepad)
    if IsValid(self.CurContent) and IsValid(self.CurContent.Widget) then
        self.CurContent.Widget:SwitchUIType(bGamepad)
    end
    self.bGamepad = bGamepad
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    self:SetFocusTarget()
    return UIUtils.Handled
end

function M:DelaySetFocusTarget()
    if self.bGamepad then
        self.List_FoolOtherDetail:SetFocus()
    end
    self:AddTimer(0.1, function()
        self:SetFocusTarget()
    end, nil, nil, "DelaySetFocusTarget", true)
end

function M:SetFocusTarget()
    if self.bGamepad then
        self.List_FoolOtherDetail:SetFocus()
        local Content = self.CurContent or self.List_FoolOtherDetail:GetItemAt(0)
        if Content then
            if IsValid(self.Parent) and IsValid(self.Parent.GameInputModeSubsystem) then
                self.Parent.GameInputModeSubsystem:SetTargetUIFocusWidget(Content.Widget)
                self.Parent.GameInputModeSubsystem:UpdateCurrentFocusWidgetPos()
            end
            self.List_FoolOtherDetail:BP_NavigateToItem(Content)
        end
    end
end

return M