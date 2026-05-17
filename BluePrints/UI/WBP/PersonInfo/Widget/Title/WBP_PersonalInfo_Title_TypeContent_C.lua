--
-- DESCRIPTION
-- 称号样式选择
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_PersonalInfo_Title_TypeContent_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C","BluePrints.Common.TimerMgr"})

---仅初始化lua变量时使用，千万不要有控件操作！！
function M:Initialize(Initializer)
    self.SelectedItem = nil
    self.EquippedItem=nil
end

function M:Construct()
    self.List_Title.BP_OnItemClicked:Add(self, self.OnItemClicked)
end

function M:InitBaseView()
    local Avatar = GWorld:GetAvatar()
    local OwnedFrames = Avatar.TitleFrames
    local CurrentFrameID = Avatar.TitleFrame
    local AllFrames = DataMgr["TitleFrame"] or {}
    local OwnedList, UnownedList = {}, {}
    for FrameId, _ in pairs(AllFrames) do
        local SingleFrame = NewObject(UIUtils.GetCommonItemContentClass())
        SingleFrame.FrameId = FrameId
        SingleFrame.bOwned = OwnedFrames and OwnedFrames[FrameId] ~= nil
        local FrameData = AllFrames[FrameId]
        local ShouldInclude = SingleFrame.bOwned or (FrameData and FrameData.CanPreView)
        if ShouldInclude then
            if CurrentFrameID == SingleFrame.FrameId and self.SelectedItem == nil and SingleFrame.bOwned then
                SingleFrame.bSelect = true
                SingleFrame.bEquipped = true
                self.SelectedItem = SingleFrame
                self.EquippedItem = SingleFrame
            end
            SingleFrame.Father = self
            local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("TitleFrame")
            if CacheDetail and CacheDetail[SingleFrame.FrameId] then
                SingleFrame.IsNew = true
            else
                SingleFrame.IsNew = false
            end
            SingleFrame.FocusEvent = self.OnFocusFrame
            SingleFrame.FocusEventObj = self
            if SingleFrame.bOwned then
                table.insert(OwnedList, SingleFrame)
            else
                table.insert(UnownedList, SingleFrame)
            end
        end
    end
    table.sort(OwnedList, function(LeftItem, RightItem)
        local LeftId = tonumber(LeftItem.FrameId) or LeftItem.FrameId
        local RightId = tonumber(RightItem.FrameId) or RightItem.FrameId
        return LeftId < RightId
    end)
    table.sort(UnownedList, function(LeftItem, RightItem)
        local LeftId = tonumber(LeftItem.FrameId) or LeftItem.FrameId
        local RightId = tonumber(RightItem.FrameId) or RightItem.FrameId
        return LeftId < RightId
    end)
    for _, item in ipairs(OwnedList) do
        self.List_Title:AddItem(item)
    end
    for _, item in ipairs(UnownedList) do
        self.List_Title:AddItem(item)
    end
    self.List_Title.OnCreateEmptyContent:Bind(self, function(self)
        return NewObject(UIUtils.GetCommonItemContentClass())
    end)
    self.List_Title:RequestFillEmptyContent()

end
function M:ResetEquipFrame()
    self:OnItemClicked(self.EquippedItem)
    if self.EquippedItem and self.EquippedItem.UI then
        self.EquippedItem.UI:PlayAnimation(self.EquippedItem.UI.Click)
        if not self.EquippedItem.UI.Btn_Area:IsChecked() then
            self.EquippedItem.UI.Btn_Area:SetChecked(true)
        end
    end

end
function M:OnItemClicked(Content)
    --ScreenPrint("OnItemClicked", Content.FrameId)
    AudioManager(self):PlayUISound(self, "event:/ui/common/special_content_01_click", nil, nil)
    if self.SelectedItem == Content then
        return
    end
    if self.SelectedItem and self.SelectedItem.UI then
        self.SelectedItem.UI:SetIsSelected(false)
    end
    self.SelectedItem = Content
    Content.UI:SetIsSelected(true)
    self:OnClickTitleFrame(Content.FrameId)

end

-- 通知父界面更换标题
function M:OnClickTitleFrame(TitleFrameID)
    self.FatherPage:OnTietleStyleChange(TitleFrameID)
end

function M:OnFocusFrame(Content,Widget)
    if self.IsGamePad then
        self:OnItemClicked(Content)
        --Widget:StopAllAnimations()
        Widget:PlayAnimation(Widget.Click)
        if not Widget.Btn_Area:IsChecked() then
            Widget.Btn_Area:SetChecked(true)
        end
        return
    end
    -- local Widget = self.List_Title:GetItemAt(0)
    -- if Widget.UI then
    -- Widget.Btn_Area:SetChecked(true)
    -- self.Btn_Area:SetChecked(true)
end

function M:InitGamepadView()
    self.IsGamePad = true
    local FocusItem =   self.SelectedItem
    -- if FocusItem  and FocusItem.UI then
    --     FocusItem.UI:SetFocus()
    -- else
        self:AddTimer(0.1, function()
            local FocusItem =   self.SelectedItem
            if FocusItem and FocusItem.UI then
                FocusItem.UI:SetFocus()
                self.List_Title:BP_SetItemSelection(FocusItem)
            end
            -- self:NavigateTo(1) -- 默认选中第一项
        end, nil, nil, nil, true)
   -- end
end

function M:InitKeyboardView()
    self.IsGamePad = false
end

function M:EquipSelectedTitleFrame()
    if  self.EquippedItem == self.SelectedItem then
        return
    end
    if self.EquippedItem and self.EquippedItem.UI then
        self.EquippedItem.UI:SetIsEquipped(false)
    end
    self.EquippedItem = self.SelectedItem
    if self.EquippedItem.UI then
        self.EquippedItem.UI:SetIsEquipped(true)
    else
        ScreenPrint("EquipSelectedTitleFrame: ".."找不到Item对应的UI" )
    end
end

-- function M:Tick(MyGeometry, InDeltaTime)
-- end

-- function M:Destruct()
-- end
function M:OnGamePadDown(InKeyName)
    local IsEventHandled = false
    --ScreenPrint("OnGamePadDown" ..InKeyName)
    if (InKeyName == UIConst.GamePadKey.FaceButtonBottom) then
        if self.FatherPage:IsCanChangeTitle() then
            self.FatherPage:OnComfirmBtnClick()
            return UE4.UWidgetBlueprintLibrary.Handled()
        end
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        -- self.PersonInfoMainPage:RotateActorForGamePad()
        self.IsGamePad = true
        IsEventHandled = self:OnGamePadDown(InKeyName)
    else

    end
    IsEventHandled = false
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

return M
