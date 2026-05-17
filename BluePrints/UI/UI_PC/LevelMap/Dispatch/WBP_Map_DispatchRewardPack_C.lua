--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Map_DialogDispatchPackDetail_C
local M = Class({"BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    M.Super.Construct(self)
    self:InitListenEvent()
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.List_Gift:SetScrollBarVisibility(UIConst.VisibilityOp.Hidden)
        self.List_Gift:SetControlScrollbarInside(true)
    end
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


--function M:Tick(MyGeometry, InDeltaTime)
--end
function M:InitContent(Params, PopupData, Owner)
    self.Super.InitContent(self, Params, PopupData, Owner)
    self:ShowGamepadABtn(true)
    local PackDetail = DataMgr.Reward[Params.PackId].Id
    local Types = DataMgr.Reward[Params.PackId].Type
    local Counts = DataMgr.Reward[Params.PackId].Count
    local Rates = DataMgr.Reward[Params.PackId].Param
    self.Text_Title:SetText(GText("UI_Dispatch_OpenPackObtain"))
    for key, value in pairs(PackDetail) do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.Id = value
        Content.Type = Types[key]
        Content.Count = Counts[key]
        Content.Owner = self
        Content.Rate = math.floor((Rates[key] / 10000) * 100)
        self.List_Gift:AddItem(Content)
    end
    self.List_Gift:SetFocus()
    self.List_Gift:NavigateToIndex(0)
   
end

-- function M:SetRewardItem(Level, RewardId)
--     local Content = NewObject(UIUtils.GetCommonItemContentClass())
--     Content.Level = Level 
--     Content.RewardId = RewardId
--     Content.UI = nil
--     self.List_Reward:AddItem(Content)
-- end

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
        self.List_Gift:NavigateToIndex(0)

    end
end


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
