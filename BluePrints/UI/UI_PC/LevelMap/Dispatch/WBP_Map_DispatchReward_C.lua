--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Map_DialogDispatchReward_C
local M = Class({"BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"})
local DispatchLevelEnum = {
    Perfect = 0,
    BigSuccess = 1,
    Success = 2,
    Fail = 3,
}

--function M:Initialize(Initializer)
--end

function M:Construct()
    M.Super.Construct(self)
    self:InitListenEvent()
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.List_Reward:SetScrollBarVisibility(UIConst.VisibilityOp.Hidden)
        self.List_Reward:SetControlScrollbarInside(true)
    end
    
end

--function M:Tick(MyGeometry, InDeltaTime)
--end
function M:InitContent(Params, PopupData, Owner)
    self.Super.InitContent(self, Params, PopupData, Owner)
    self:ShowGamepadABtn(true)
    for Index, RewardId in ipairs(Params.RewardList) do
        if Index == 1 then
            self:SetRewardItem(DispatchLevelEnum.Perfect, RewardId, self)
        elseif Index == 2 then
            self:SetRewardItem(DispatchLevelEnum.BigSuccess, RewardId, self)
        elseif Index == 3 then
            self:SetRewardItem(DispatchLevelEnum.Success, RewardId, self)
        else
            self:SetRewardItem(DispatchLevelEnum.Fail, RewardId, self)
        end
    end
    self.List_Reward:SetFocus()
    self.List_Reward:NavigateToIndex(0)
   
end

function M:SetRewardItem(Level, RewardId, Owner)
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Level = Level 
    Content.RewardId = RewardId
    Content.UI = nil
    Content.Owner = Owner
    self.List_Reward:AddItem(Content)
end

function M:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice) 
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end
    --- 切换手柄端相关图标显隐
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if (IsUseKeyAndMouse) then
        self.UsingGamepad = false
        
    else
        self.UsingGamepad = true
        self.List_Reward:NavigateToIndex(0)

    end
end

-- function M:OnContentFocusReceived(MyGeometry, InFocusEvent)
--     --当聚焦到item的时候 设置聚焦到第一个关卡按钮
--     --self.ScrollBox_List:GetChildAt(5).Bg_List.Button_Area:SetFocus()
--     if self.List_Reward:GetItemAt(0) then
--         self.List_Reward:GetItemAt(0):SetFocus()
--     end
--     return UE4.UWidgetBlueprintLibrary.Unhandled()
-- end

function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == "Gamepad_RightY") then
        local a = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 10
        -- local CurScrollOffset = self.Scroll_Drop:GetScrollOffset()
        -- self.Scroll_Drop:SetScrollOffset(CurScrollOffset + a)
    end
    return UWidgetBlueprintLibrary.Unhandled()
end

function M:ShowGamepadABtn(bIsShow)
    if bIsShow then
        self.GamepadCheckItemKeyInfo = self.GamepadCheckItemKeyInfo or self:ShowGamepadShortcutBtn({
            KeyInfoList = {
                { Type = "Img", ImgShortPath = UIConst.GamePadImgKey.FaceButtonBottom }
            },
            Desc = GText("UI_Controller_CheckDetails")  --UI_Controller_CheckDetails

        })
    elseif self.GamepadCheckItemKeyInfo then
        --self:HideGamepadShortcut(self.GamepadCheckItemKeyInfo)
        self.GamepadCheckItemKeyInfo = nil
    end
end


return M
