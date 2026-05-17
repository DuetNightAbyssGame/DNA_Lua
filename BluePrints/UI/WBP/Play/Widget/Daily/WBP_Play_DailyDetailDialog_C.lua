--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR shilei
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Play_DailyDetailDialog_C
local M = Class({ "BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase" })
--function M:Initialize(Initializer)
--end

function M:Construct()
    M.Super.Construct(self)

    if CommonUtils.GetDeviceTypeByPlatformName() == "Mobile" then
        self.List_Item:SetControlScrollbarInside(false)
    else
        self.List_Item:SetScrollbarVisibility(UIConst.VisibilityOp.Collapsed)
        self.List_Item:SetControlScrollbarInside(true)
    end
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end
function M:InitContent(Params, PopupData, Owner)
    self.Super.InitContent(self, Params, PopupData, Owner)
    self:BindDialogEvent(DialogEvent.OnTitleTabSelected, self.OnTabSelected)
    if not Params.DataMap then
        return
    end
    self.DataMap = Params.DataMap
    if self.DataMap.Tabs then
        self:InitPage(self.DataMap.Tabs[1], true)
    else
        self:InitPage(self.DataMap)
    end
end

function M:InitPage(DataMap, IsTabPage)
    self.List_Item:ClearChildren()

    local Keys = {}

    -- 提取所有键
    for des in pairs(DataMap) do
        table.insert(Keys, des)
    end

    -- 对键进行升序排序
    table.sort(Keys, function(a, b) return a < b end)

    self.ListTiles = {}
    -- 按升序遍历
    for i, des in ipairs(Keys) do
        local RewardList = DataMap[des]
        local Content = {}
        Content.RewardList = RewardList
        Content.des = des
        Content.ParentWidget = self
        Content.Index = i
        Content.IsTabPage = IsTabPage

        local Item = self:CreateWidgetNew("DailyDetailItem")
        table.insert(self.ListTiles,Item)
        self.List_Item:AddChild(Item)
        Item:Init(Content)
    end


    self:AddTimer(0.01, function()
        self.List_Item:GetChildAt(0):SetFocus()
        self:ShowGamepadABtn(true)
        --self:ShowGamepadScrollBtn(UIUtils.CheckScrollBoxCanScroll(self.List_Item))
    end, false, 0, "__DeputeDetailDialog_List_Drop")
end

function M:OnTabSelected(TabWidget)
    local Idx = TabWidget.Idx
    if Idx and self.DataMap.Tabs and self.DataMap.Tabs[Idx] then
        self:InitPage(self.DataMap.Tabs[Idx], true)
    else
        self:InitPage(self.DataMap, false)
    end
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
        self:HideGamepadShortcut(self.GamepadCheckItemKeyInfo)
        self.GamepadCheckItemKeyInfo = nil
    end
end

function M:OnContentFocusReceived(MyGeometry, InFocusEvent)
    --self.ScrollBox_List:GetChildAt(5).Bg_List.Button_Area:SetFocus()
    --self.List_Drop:NavigateToIndex(0)
    if self.List_Item:GetChildAt(0) then
        self.List_Item:GetChildAt(0):SetFocus()
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == "Gamepad_RightY") then
        local a = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 5
        local CurScrollOffset = self.List_Item:GetScrollOffset()
        self.List_Item:SetScrollOffset(CurScrollOffset + a)
    end
    return UWidgetBlueprintLibrary.Unhandled()
end


return M
