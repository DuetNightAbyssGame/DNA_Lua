local M = Class({
	"BluePrints.UI.BP_EMUserWidget_C",
    "BluePrints.Common.TimerMgr",
})

local PhotoWallModel = require "BluePrints.UI.WBP.Activity.PC.Fool.Model.PhotoWallModel"

local EDetailState = {
    View = 0,
    Edit = 1,
}

function M:Construct()
    self.bEntered = false
	self.ContentMap = {}
    self.CurContent = nil
    self.BP_ContentsArray:Clear()
    self.Platform = CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance)
	self.Text_UploadTitle:SetText(GText("AFDayEvent_PhotoWall_Mywork"))
	self.Text_UploadNum01:SetText(0)
	self.Text_UploadNum02:SetText(DataMgr.EventConstant.PictureUploadLimit.ConstantValue)
	self.Btn_Edit:SetText(GText("AFDayEvent_PhotoWall_Modify"))
	self.Text_All:SetText(GText("AFDayEvent_PhotoWall_SelectAll"))
	self.Text_EditTitle:SetText(GText("AFDayEvent_PhotoWall_Selected"))
	self.Text_EditNum01:SetText(0)
	self.Text_EditNum02:SetText(0)
	self.Btn_Cancel:SetText(GText("AFDayEvent_PhotoWall_Cancel"))
	self.Btn_Delete:SetText(GText("UI_RegionMap_Delete"))
	self.Com_CheckBox:BindEventOnClicked({Inst = self, Func = self.OnSelectAllChecked})
    self:BindButtonEvents()
    self:InitGamepadKeys()
    self.List_FoolMyDetail.BP_OnItemIsHoveredChanged:Add(self, self.OnItemHoveredChanged)
    self.List_FoolMyDetail.OnCreateEmptyContent:Bind(self, function()
        return self:CreateEmptyItem()
    end)
end

function M:Destruct()
    self.bEntered = false
    self:UnbindFromAnimationFinished(self.Out, {self, self.OnOutAnimationFinished})
	self.BP_ContentsArray:Clear()
	self:CleanTimer()
end

function M:EnterPage()
	if self.bEntered then return end
	self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	self.bEntered = true
    self.CurContent = nil
    self:SetFocus()
	self:RefreshList()
    self:UnbindFromAnimationFinished(self.Out, {self, self.OnOutAnimationFinished})
	self:StopAllAnimations()
    self:PlayAnimation(self.In)
end

function M:LeavePage()
	if not self.bEntered then 
		self:SetVisibility(ESlateVisibility.Collapsed)
		return 
	end
	self.bEntered = false
    self.CurContent = nil
	self:CleanTimer()
	self:StopAllAnimations()
	self:BindToAnimationFinished(self.Out, {self, self.OnOutAnimationFinished})
    self:PlayAnimation(self.Out)
	self.List_FoolMyDetail:ClearListItems()
end

function M:OnOutAnimationFinished()
    self:SetVisibility(ESlateVisibility.Collapsed)
    self:UnbindFromAnimationFinished(self.Out, {self, self.OnOutAnimationFinished})
end

-- 浏览/编辑 模式切换
function M:SwitchState(EState)
    if EState == EDetailState.View then
        self.State = EState
        self.Group_Normal:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Group_Edit:SetVisibility(ESlateVisibility.Collapsed)
		self.Com_CheckBox:SetIsCheckedWithoutCallback(false, false)
    	self.Parent:UpdateBottomKeyInfo(false)
    	self:SwitchUIType(self.bGamepad)
    elseif EState == EDetailState.Edit then
        self.State = EState
        self.Group_Normal:SetVisibility(ESlateVisibility.Collapsed)
        self.Group_Edit:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
		self.Btn_Delete:ForbidBtn(true)
    	self.Parent:UpdateBottomKeyInfo(true)
		self:UpdateCheckNum()
    else
    	GWorld.logger.error("Fool_MyDetail:SwitchState, State is Invalid, State:"..EState and EState or "")
    	return
    end
    -- 重置选中计数
    self.CheckedRecord = {}
    self.CheckedContentNum = 0
    for _, Content in pairs(self.ContentMap) do
    	Content.State = EState
    	if IsValid(Content.Widget) and Content.Widget.SwitchItemState then
			Content.Widget:SwitchItemState(EState)
    	end
   	end
end

function M:OnItemHoveredChanged(Content,IsHover)
    if not IsValid(Content) then return end
    if IsHover then
        self.CurContent = Content
    end
    if self.bGamepad and self.State == EDetailState.View then
        if IsValid(Content.Widget) then
            Content.Widget:SwitchUIType(IsHover)
        end
    end
end

function M:RefreshList()
    self:SwitchState(EDetailState.View)
    self.ContentMap = {}
    self.ContentNum = 0
    self.CurContent = nil
    self.CurrentExpandId = nil
    local MyPics = PhotoWallModel:GetMyFoolsDayPhotoIds() or {}
    local NewPhotos = {}
	self.List_FoolMyDetail:ClearListItems()
	for _, PhotoId in ipairs(MyPics) do
		if self.ContentMap[PhotoId] then goto continue end
		local Content = PhotoWallModel:GetPhotoData(PhotoId)
		if not Content then
	    	Content = NewObject(UIUtils.GetCommonItemContentClass())
	    	Content.PhotoId = PhotoId
	    	self.BP_ContentsArray:Add(Content)
	    	PhotoWallModel:SavePhotoData(PhotoId, Content)
	    	table.insert(NewPhotos, PhotoId)
	    end
	    Content.OnDetailExpanded = function(bExpand)
            self:OnDetailExpanded(Content, bExpand)
        end
	    Content.OnItemChecked = function(InContent, Checked)
    		self:OnItemChecked(InContent, Checked)
    	end
    	self.ContentMap[PhotoId] = Content
        self.List_FoolMyDetail:AddItem(Content)
        ::continue::
    end
    self:FetchPhotoDocs(NewPhotos)

    local bListEmpty = false
    local MyWorkCnt = CommonUtils.Size(MyPics)
    if(MyWorkCnt <= 0)then
        bListEmpty = true
		self:StopAllAnimations()
		self:SetVisibility(ESlateVisibility.Collapsed)
    else
        self:AddTimer(0.01, function()
            --刷新列表显示项
			for _, Content in pairs(self.ContentMap) do
            	if IsValid(Content.Widget) then
            		Content.Widget:ResetEntryUI(Content.PhotoDoc)
            	end
            end
            self.List_FoolMyDetail:RegenerateAllEntries()
            self.List_FoolMyDetail:ScrollToTop()
        end,false, 0, "DelayRefresh",true)
    	self.List_FoolMyDetail:RequestFillEmptyContent()
    end
    self.ContentNum = MyWorkCnt
	self.Text_UploadNum01:SetText(MyWorkCnt)
	self.Text_EditNum01:SetText(0)
	self.Text_EditNum02:SetText(MyWorkCnt)
    self.Parent:OnTabDetailInited(bListEmpty)
    self:DelaySetFocusTarget()
    self.List_FoolMyDetail:RequestPlayEntriesAnim()
end

function M:CreateEmptyItem()
    local EmptyContent = NewObject(UIUtils.GetCommonItemContentClass())
    EmptyContent.IsEmpty = true
    return EmptyContent
end

function M:OnDetailExpanded(Content, bExpand)
    if not IsValid(Content) or not IsValid(Content.Widget) then return end
    if not Content.PhotoId then return end
    DebugPrint("Fool_MyDetail@OnDetailExpanded", self.CurrentExpandId, Content.PhotoId, bExpand)
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
    self.List_FoolMyDetail:RemoveItem(Content)
    self.List_FoolMyDetail:RequestFillEmptyContent()
    if self.ContentNum > 0 then
        self.ContentNum = self.ContentNum - 1
		self.Text_UploadNum01:SetText(self.ContentNum)
		self.Text_EditNum02:SetText(self.ContentNum)
        if self.CheckedRecord[Content] then
    		self.CheckedContentNum = self.CheckedContentNum - 1
			self:UpdateCheckNum()
        end
    end
    if self.CurrentExpandId and self.CurrentExpandId ~= PhotoId then
		local CurExpandContent = self.ContentMap[self.CurrentExpandId]
		if IsValid(CurExpandContent) then
			self.List_FoolMyDetail:BP_NavigateToItem(CurExpandContent)
		end
    end
end

function M:FetchPhotoDocs(PhotoIds)
	if not PhotoIds or #PhotoIds <= 0 then return end
	local Callback = function(Content, PhotoDoc)
        if IsValid(Content.Widget) then
            Content.Widget:ResetEntryUI(PhotoDoc)
        end
	end
	PhotoWallModel:FetchPhotoDocs(PhotoIds, Callback)
end

function M:OnEditBtnClicked()
	if self.State ~= EDetailState.View then return end
	self:SwitchState(EDetailState.Edit)
end

function M:OnSelectAllChecked(Checked)
	if self.State ~= EDetailState.Edit then return end
	for _, Content in pairs(self.ContentMap) do
    	if Content then
    		Content.IsSelect = Checked
    		self.CheckedRecord[Content] = Checked
    		if IsValid(Content.Widget) then
    			Content.Widget:SetIsSelected(Checked, false, true)
    		end
    	end
    end
    self.CheckedContentNum = Checked and self.ContentNum or 0
	self:UpdateCheckNum()
end

function M:OnCancelBtnClicked()
	if self.State ~= EDetailState.Edit then return end
	self:SwitchState(EDetailState.View)
end

local DeletePopupId = 100298

function M:OnDeleteBtnClicked()
	if self.State ~= EDetailState.Edit then return end
	local Params = {}
    if self.ReturnTimer then
        self:RemoveTimer(self.ReturnTimer)
    end
    Params.OnCloseCallbackFunction = function() 
        self:SetFocus()
    end
    Params.RightCallbackFunction = function() 
        self:DeleteCheckedPhotos()
    end
    local PopupData = DataMgr.CommonPopupUIContext[DeletePopupId]
    Params.ShortText = string.format(GText(PopupData.PopoverText), self.CheckedContentNum)
    UIManager(self):ShowCommonPopupUI(DeletePopupId, Params, self.Parent)
end

-- 编辑模式下，删除选中的照片并刷新列表
function M:DeleteCheckedPhotos()
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
    	GWorld.logger.error("Fool_MyDetail:OnDeleteBtnClicked, Avatar is invalid")
    	return
	end
	local NumToDelete = 0
	local IsCallbackExecuted = false
	local Callback = function(Ret)
		ErrorCode:Check(Ret)
		if IsCallbackExecuted then return end
		NumToDelete = NumToDelete - 1
		if NumToDelete <= 0 then
			IsCallbackExecuted = true
			self:RemoveTimer("DeletePhoto")
    		UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("AFDayEvent_PhotoWall_DeleteToast"))
			self:RefreshList()
			self.Parent:BlockAllUIInput(false)
		end
	end
	for Content, bChecked in pairs(self.CheckedRecord) do
		if Content and bChecked then
			NumToDelete = NumToDelete + 1
			Avatar:FoolsDayDelPhoto(Content.PhotoId, Callback)
		end
	end
	self:AddTimer(3, function()
		if not IsCallbackExecuted then
			self.Parent:BlockAllUIInput(false)
			self:RefreshList()
		end
	end,nil,nil,"DeletePhoto",true)
	-- 重置选中计数
    self.CheckedRecord = {}
    self.CheckedContentNum = 0
	self.Parent:BlockAllUIInput(true)
end

-- 编辑模式下，当Item被选中时
function M:OnItemChecked(Content, Checked)
	if self.State ~= EDetailState.Edit then return end
	self.CheckedRecord[Content] = Checked

	local Delta = Checked and 1 or -1
	self.CheckedContentNum = self.CheckedContentNum + Delta

	self:UpdateCheckNum()
	self.Com_CheckBox:SetIsCheckedWithoutCallback(self.CheckedContentNum == self.ContentNum, false)
end

function M:UpdateCheckNum()
	if self.State ~= EDetailState.Edit then return end
	self.Text_EditNum01:SetText(self.CheckedContentNum)
	self.Text_EditNum02:SetText(self.ContentNum)
	self.Btn_Delete:ForbidBtn(self.CheckedContentNum == 0)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadDown(InKeyName)
    else
        if InKeyName == "Escape" then
            IsEventHandled = self:HandleClose()
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
    if InKeyName == "Gamepad_FaceButton_Right"  then
    	if self.State == EDetailState.View then
        	IsEventHandled = self:HandleClose()
	    elseif self.State == EDetailState.Edit then
	    	if not self.Btn_Cancel.IsPressing then
	    		self.Btn_Cancel:OnBtnPressed()
	            IsEventHandled = true
	    	end
       	end
    elseif InKeyName == "Gamepad_FaceButton_Left"  then
    	if self.State == EDetailState.View then
	    	if not self.Btn_Edit.IsPressing then
	            self.Btn_Edit:OnBtnPressed()
	            IsEventHandled = true
	        end
	    elseif self.State == EDetailState.Edit then
	    	if not self.Btn_Delete.IsPressing then
	            self.Btn_Delete:OnBtnPressed()
	            IsEventHandled = true
	        end
	    end
    elseif InKeyName == "Gamepad_LeftThumbstick"  then
    	if self.State == EDetailState.Edit then
    		self.Com_CheckBox:OnClicked()
	        IsEventHandled = true
    	end
    end
    return IsEventHandled
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
    	if InKeyName == "Gamepad_FaceButton_Right" then
    		if self.State == EDetailState.Edit then
		    	if self.Btn_Cancel.IsPressing then
		    		self.Btn_Cancel:OnBtnReleased()
		    		self.Btn_Cancel:OnBtnClicked()
		            IsEventHandled = true
		    	end
	       	end
        elseif InKeyName == "Gamepad_FaceButton_Left"  then
    		if self.State == EDetailState.View then
	            if self.Btn_Edit.IsPressing then
	                self.Btn_Edit:OnBtnReleased()
	                self.Btn_Edit:OnBtnClicked()
	                IsEventHandled = true
	            end
	    	elseif self.State == EDetailState.Edit then
	    		if self.Btn_Delete.IsPressing then
		            self.Btn_Delete:OnBtnReleased()
		            self.Btn_Delete:OnBtnClicked()
		            IsEventHandled = true
		        end
		    end
        end
    end
    if IsEventHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:HandleClose()
    if self.State == EDetailState.Edit then
        self:OnCancelBtnClicked()
        return true
    end
    return false
end

function M:IsMobile()
    return self.Platform == CommonConst.CLIENT_DEVICE_TYPE.MOBILE
end

function M:InitGamepadKeys()
	if self:IsMobile() then return end
    self.Com_CheckBox:InitGamepadKey("LS")
end

function M:BindButtonEvents()
    self.Btn_Edit:UnBindEventOnClickedByObj(self)
    self.Btn_Cancel:UnBindEventOnClickedByObj(self)
    self.Btn_Delete:UnBindEventOnClickedByObj(self)

    self.Btn_Edit:BindEventOnClicked(self, self.OnEditBtnClicked)
    self.Btn_Cancel:BindEventOnClicked(self, self.OnCancelBtnClicked)
    self.Btn_Delete:BindEventOnClicked(self, self.OnDeleteBtnClicked)
    self.Btn_Delete:BindForbidStateExecuteEvent(self, function()
    	UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("AFDayEvent_PhotoWall_NotSelected"))
    end)
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
        self.List_FoolMyDetail:SetFocus()
    end
    self:AddTimer(0.1, function()
        self:SetFocusTarget()
    end, nil, nil, "DelaySetFocusTarget", true)
end

function M:SetFocusTarget()
    if self.bGamepad then
        self.List_FoolMyDetail:SetFocus()
        local Content = self.CurContent or self.List_FoolMyDetail:GetItemAt(0)
        if Content then
            if IsValid(self.Parent) and IsValid(self.Parent.GameInputModeSubsystem) then
                self.Parent.GameInputModeSubsystem:SetTargetUIFocusWidget(Content.Widget)
                self.Parent.GameInputModeSubsystem:UpdateCurrentFocusWidgetPos()
            end
            self.List_FoolMyDetail:BP_NavigateToItem(Content)
        end
    end
end

return M