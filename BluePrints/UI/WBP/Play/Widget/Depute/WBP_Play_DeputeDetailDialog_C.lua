--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR shilei
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Play_DeputeDetailDialog_C
local M = Class({ "BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase" })
--function M:Initialize(Initializer)
--end

function M:Construct()
    M.Super.Construct(self)

    if CommonUtils.GetDeviceTypeByPlatformName()=="Mobile" then
        self.Scroll_Drop:SetControlScrollbarInside(false)
    else
        self.Scroll_Drop:SetControlScrollbarInside(true)
    end
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end
-- 奖励类型顺序：首次通关 > 固定奖励 > 概率奖励
local DropTypeOrder =
{
    "FirstReward",
    -- "DropType_Fixed",
    -- "DropTag_Prob",
}
function M:InitContent(Params, PopupData, Owner)
    self.Super.InitContent(self, Params, PopupData, Owner)

    if not Params.RewardList then
        return
    end

    --self.DropTypeOrder = {"FirstReward"}
    self.Scroll_Drop:ClearChildren()
    -- for  _, Data in pairs(DataMgr.DropProbType) do
    --     table.insert(self.DropTypeOrder,Data.DropTypeKey)
    -- end

    self.DropTypeOrder = { "FirstReward" }

    local dropList = {}
    for _, Data in pairs(DataMgr.DropProbType) do
        table.insert(dropList, Data)
    end

    -- 按 DropTypeSequence 从大到小排序
    table.sort(dropList, function(a, b)
        return (a.DropTypeSequence or 0) > (b.DropTypeSequence or 0)
    end)

    for _, Data in ipairs(dropList) do
        table.insert(self.DropTypeOrder, Data.DropTypeKey)
    end
    
    local RewardList = Params.RewardList
    local DropTypeMap = {}
    for _, ItemData in ipairs(RewardList) do
        if not ItemData.DropType then
            ItemData.DropType = self.DropTypeOrder[1]
        end
        if not DropTypeMap[ItemData.DropType] then
            DropTypeMap[ItemData.DropType] = {}
        end
        local Data = {}
        Data.DropType = ItemData.DropType
        Data.Id = ItemData.Id
        Data.Icon = ItemUtils.GetItemIconPath(ItemData.Id, ItemData.Type)
        Data.ParentWidget = self
        Data.ItemType = ItemData.Type
        Data.Rarity = ItemData.Rarity or 1
        Data.IsShowDetails = true
        Data.UIName = "DeputeDetail"
        Data.Quantity = ItemData.Quantity
        Data.ItemCount = ItemData.ItemCount
        Data.FirstRewardFlag = ItemData.bFirst
        -- 将 Data 归属到对应的 DropType 下
        table.insert(DropTypeMap[ItemData.DropType], Data)
    end

    for Index, DropType in ipairs(self.DropTypeOrder) do
        local Rewards = DropTypeMap[DropType]
        if Rewards then
            local Content = {}
            Content.RewardList = Rewards
            Content.DropType = DropType
            Content.Index = Index
            Content.ParentWidget = self
            Content.Checked = Params.Checked
            local Item = self:CreateWidgetNew("DeputeDetailItem")
            self.Scroll_Drop:AddChild(Item)
            Item:Init(Content)
        end
    end
    self:AddTimer(0.01, function()
        if self.Scroll_Drop:GetChildAt(0) then
            self.Scroll_Drop:GetChildAt(0):SetFocus()
        end

        --self:ShowGamepadScrollBtn(UIUtils.CheckScrollBoxCanScroll(self.Scroll_Drop))
        self:ShowGamepadABtn(true)
    end, false, 0, "__DeputeDetailDialog_List_Drop")
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
    --当聚焦到item的时候 设置聚焦到第一个关卡按钮
    --self.ScrollBox_List:GetChildAt(5).Bg_List.Button_Area:SetFocus()
    if self.Scroll_Drop:GetChildAt(0) then
        self.Scroll_Drop:GetChildAt(0):SetFocus()
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        if self.Scroll_Drop:GetChildAt(0) then
            self.Scroll_Drop:GetChildAt(0):SetFocus()
        end
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == "Gamepad_RightY") then
        local a = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 10
        local CurScrollOffset = self.Scroll_Drop:GetScrollOffset()
        self.Scroll_Drop:SetScrollOffset(CurScrollOffset + a)
    end
    return UWidgetBlueprintLibrary.Unhandled()
end


return M
