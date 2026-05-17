--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local FSM = require("Blueprints.UI.FocusStateMachine")
local FocusStates = {
    PhotoList = "PhotoList",
    RewardList = "RewardList"
}

---@type WBP_Activity_CameraGame_P_C
local M = Class({"BluePrints.UI.WBP.Activity.PC.CameraGame.WBP_Activity_CameraGame_Base_C"})

function M:Initialize(Initializer)
    rawset(self,"FSM",FSM:New(self,{
        StateNames = FocusStates,
        OnStateChanged = self.OnFocusChanged,
        CheckFunction = self.IsFocusStateValid,
    }))
    rawset(self,"ESCKeyInfoList",{
        KeyInfoList = {
            {Type="Text", Text=CommonUtils:GetKeyText("Escape"), ClickCallback = self.OnBackKeyDown, Owner=self},
        },
        GamePadInfoList =  {
            {Type="Img", ImgShortPath="B", ClickCallback = self.OnBackKeyDown, Owner=self}
        },
        Desc = GText("UI_BACK"),
    })
    rawset(self, "TabConfigData", {
        TitleName = GText("Event_Title_103017"),
        DynamicNode = { "Back", "ResourceBar", "BottomKey" },
        StyleName = "TextImage",
        OwnerPanel = self,
        BackCallback = self.CloseSelf,
        BottomKeyInfo = { self.ESCKeyInfoList }
    })
end

function M:Construct()
    self.Super.Construct(self)
    self.Key_Go:CreateCommonKey({KeyInfoList={{ Type = "Img", ImgShortPath = "A"}}})
    -- 输入设备切换
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    if (IsValid(self.GameInputModeSubsystem))then
        self.CurInputDeviceType  = self.GameInputModeSubsystem:GetCurrentInputType()
        rawset(self,"IsGamepadInput",self.CurInputDeviceType == ECommonInputType.Gamepad)
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice) 
    end
end

function M:Destruct()
    -- 输入设备切换
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice) 
    end
    self.Super:Destruct(self)
end

--- Begin 设备切换 ---
-- 切换手柄和键鼠的处理
function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    rawset(self,"CurInputDeviceType",CurInputDevice)
    rawset(self,"IsGamepadInput",self.CurInputDeviceType == ECommonInputType.Gamepad)
    if(self.IsGamepadInput and self.IsInFocusPath and not self:IsFocusStateWidgetHasAnyFocus(self.FSM:Peak()))then
        --保底措施，以防输入设备切换时聚焦不在任何合法热区
        self.FSM:Clear()
        local Widget = self:GetDesiredFocusTarget()
        if(Widget)then
            Widget:SetFocus()
        end
    end
    self:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
end

-- 第一次打开界面会执行
function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    M.Super.OnUpdateUIStyleByInputTypeChange(self,CurInputDevice, CurGamepadName)
    rawset(self,"CurInputDeviceType",CurInputDevice)
    rawset(self,"IsGamepadInput",self.CurInputDeviceType == ECommonInputType.Gamepad)
    self:OnFocusChanged()
end

function M:OnFocusChanged(NewState,OladState,Operation)
    --更新UI样式
    self:UpdateKeyStyle()
    --更新底部快捷键提示
    self:UpdateBottomKeyInfo()
end

--更新UI样式
function M:UpdateKeyStyle()
    local State = self.FSM:Peak()
    local StateName = State.Name
    if(StateName == FocusStates.PhotoList)then
        --聚焦在照片列表的UI样式
        if self.IsGamepadInput then  -- 前往拍照手柄按键
            self.Key_Go:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        end
    elseif(StateName == FocusStates.RewardList)then
        --聚焦在奖励列表的UI样式
        if self.IsGamepadInput then  -- 前往拍照手柄按键
            self.Key_Go:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end

    if not self.IsGamepadInput then  -- PC 隐藏
        self.Key_Go:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

--更新底部快捷键提示
function M:UpdateBottomKeyInfo()
    local BottomKeyInfo = {}
    if(self.IsGamepadInput)then
        local State = self.FSM:Peak()
        local StateName = State.Name
        if(StateName == FocusStates.PhotoList)then
            if (self.CurQuestState ~= self.QCS.lock) then
                -- 查看奖励
                table.insert(BottomKeyInfo,{
                    GamePadInfoList =  {{Type="Img", ImgShortPath="LS",}},
                    Desc = GText("UI_Controller_CheckReward"),
                })
            end

            -- 滚动查看
            local ScrolOffsetEnd = self.ScrollBox_Message:GetScrollOffsetOfEnd()
            if ScrolOffsetEnd > 0 then
                table.insert(BottomKeyInfo,{
                    GamePadInfoList =  {{Type="Img", ImgShortPath="RV",}},
                    Desc = GText("UI_Controller_Slide"),
                })
            end
        elseif(StateName == FocusStates.RewardList)then
            -- 查看详情
            table.insert(BottomKeyInfo,{
                GamePadInfoList =  {{Type="Img", ImgShortPath="A",}},
                Desc = GText("UI_Controller_CheckDetails"),
            })
        end
    end
    table.insert(BottomKeyInfo,self.ESCKeyInfoList)
    self.Tab:UpdateBottomKeyInfo(BottomKeyInfo)
end
--- End 设备切换 ---


--Begin 聚焦处理
---判断当前聚集状态是否合法(由FSM调用)
function M:IsFocusStateValid(State)
    local StateName = State.Name
    if(StateName == FocusStates.PhotoList)then
        return self.ListView_Left:GetIndexForItem(State.Content) >= 0
    elseif(StateName == FocusStates.RewardList)then
        return self.List_Reward:GetIndexForItem(State.Content) >= 0
    end
end

---判断当前聚焦状态对应的控件是否有聚集
function M:IsFocusStateWidgetHasAnyFocus(State)
    local StateName = State.Name
    if(StateName == FocusStates.PhotoList)then
        return UIUtils.HasAnyFocus(self.ListView_Left)
    elseif(StateName == FocusStates.RewardList)then
        return UIUtils.HasAnyFocus(self.List_Reward)
    end
end

---获取当前期望获得聚焦的控件
function M:GetDesiredFocusTarget()
    local State = self.FSM:Peak()
    local StateName = State.Name

    if(StateName == FocusStates.RewardList)then
        self.List_Reward:BP_CancelScrollIntoView()
        self.List_Reward:BP_SetSelectedItem(State.Content)
        self.List_Reward:BP_NavigateToItem(State.Content)
        if(rawget(State.Content,"SelfWidget"))then
            return State.Content.SelfWidget
        end
        return self.List_Reward
    end

    if(StateName == FocusStates.PhotoList)then
        self.ListView_Left:BP_CancelScrollIntoView()
        self.ListView_Left:BP_SetSelectedItem(State.Content)
        self.ListView_Left:BP_NavigateToItem(State.Content)
        if(rawget(State.Content,"SelfWidget"))then
            return State.Content.SelfWidget
        end
        return self.ListView_Left
    else
        self.ListView_Left:BP_CancelScrollIntoView()
        local Content = self.ListView_Left:GetItemAt(0)
        if(Content)then
            self.ListView_Left:BP_SetSelectedItem(Content)
            self.ListView_Left:BP_NavigateToItem(Content)
        end
        return self.ListView_Left
    end
end

function M:OnPhotoListContentCreated(Content)
    rawset(Content,"OnAddedToFocusPath",self.OnPhotoListItemAddedToFocusPath)
    rawset(Content,"OnRemovedFromFocusPath",self.OnPhotoListItemRemovedFromFocusPath)
end

function M:OnPhotoListItemAddedToFocusPath(Content)
    if(self.FSM:Peak().Name == FocusStates.RewardList)then
        self.FSM:Pop()
    end
    self.FSM:Push({Name = FocusStates.PhotoList, Content = Content})
end

function M:OnRewardListContentCreated(Content)
    rawset(Content,"OnFocusReceivedEvent",{
        Obj = self,
        Callback = self.OnRewardListItemFocusReceived,
        Params = Content,
    })
    rawset(Content,"OnMouseButtonUpEvents",{
        Obj = self,
        Callback = self.OnRewardListItemClicked,
        Params = Content,
    })
    rawset(Content,"OnRemovedFromFocusPathEvent",{
        Obj = self,
        Callback = self.OnRewardListItemRemovedFromFocusPath,
        Params = Content,
    })
end

function M:OnRewardListItemFocusReceived(Content)
    self:UpdateBottomKeyInfo()
end

function M:OnRewardListItemClicked(Content)
    if self.IsGamepadInput then
        self.Tab:UpdateBottomKeyInfo({})
    end
end

function M:OnRewardListItemRemovedFromFocusPath(Content)
    self:UpdateBottomKeyInfo()
end

function M:OnAddedToFocusPath()
    rawset(self,"IsInFocusPath",true)
end

function M:OnRemovedFromFocusPath()
    rawset(self,"IsInFocusPath",false)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if(not self.IsGamepadInput)then
        return UIUtils.Handled
    end
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self:GetDesiredFocusTarget())
end
---End 聚焦处理

--- Begin 按键处理
function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    if (InKeyName == "Escape")
        or (InKeyName == UIConst.GamePadKey.FaceButtonRight) then  -- 手柄B or ESC返回
        self:OnBackKeyDown()
        return UIUtils.Handled
    end

    -- 未解锁不触发下面事件
    if (self.CurQuestState == self.QCS.lock) then
        return UIUtils.Handled
    end

    local StateName = self.FSM:Peak().Name
    if(StateName == FocusStates.PhotoList)then
        if InKeyName == UIConst.GamePadKey.FaceButtonBottom  then  -- A 前往拍照/领取奖励
            self:OnRewardAndPhotoButtonClicked()
        elseif InKeyName == UIConst.GamePadKey.LeftThumb then  -- LS 奖励列表
            self.FSM:Push({Name = FocusStates.RewardList, Content = self.List_Reward:GetItemAt(0)})
            UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self:GetDesiredFocusTarget())
        end
    end

    return UIUtils.Handled
end

function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName ~= UIConst.GamePadKey.RightAnalogY then
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end

    local StateName = self.FSM:Peak().Name
    if(StateName == FocusStates.PhotoList)then-- RH 滚动查看
        UIUtils.ScrollBoxByGamepad(self.ScrollBox_Message, InAnalogInputEvent)
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnBackKeyDown()
    local StateName = self.FSM:Peak().Name
    if(StateName == FocusStates.RewardList)then
        self.FSM:Pop()
        UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self:GetDesiredFocusTarget())
    else
        self:CloseSelf()
    end
end
--End 按键处理

return M
