--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"

---@type WBP_Activity_TenTimesReward_P_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C",
"BluePrints.UI.WBP.Activity.Widget.ConditionRewardActivity.ConditionRewardActiviyBase"})

function M:InitUI()
    self.FocusWidgetName = "CheckRewardView"
    self.FocusWidgetWidget = nil
    -- 奖励
    local RewardId = self:GetPageConfigData().EventReward
    local RewardData = DataMgr.Reward[RewardId]
    local ResourceData = DataMgr[RewardData.Type[1]][RewardData.Id[1]]
    self.TenTimesReward_Item.Text_ItemTitle:SetText(GText(ResourceData.ResourceName))
    self.TenTimesReward_Item.Text_ItemNum:SetText(RewardData.Count[1][1])

    -- 初始化CommonUI
    self.Activity_TimeView = self.WBP_Activity_TenTimesReward_Title.Activity_Time
    self.Text_ActivityDescView = self.WBP_Activity_TenTimesReward_Title.Text_ActivityDesc
    self.Text_TitleView = self.WBP_Activity_TenTimesReward_Title.Text_Title
    self:InitCommonUI()

    -- 手柄
    self.TenTimesReward_Item.Key_Get:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "X"
            }
        }
    })
    self.FocusWidgetName = "DefaultWidget"

    self.TenTimesReward_Item.Btn_Click.OnClicked:Add(self, self.OnBtnClick)
    -- 如果已经领奖，就设置按钮不可用
    if self.IsCanGetReward then
        self.TenTimesReward_Item.Btn_Click:SetForbidden(false)
        self.TenTimesReward_Item.Text_BtnGet:SetText(GText("UI_GameEvent_ClaimReward"))
    else
        self.TenTimesReward_Item.Btn_Click:SetForbidden(true)
        self.TenTimesReward_Item.Text_BtnGet:SetText(GText("UI_GameEvent_ToBeFinished"))
    end
    if self.IsComplete or self.IsGetReward then
        self.TenTimesReward_Item.Btn_Click:SetForbidden(true)
        self.TenTimesReward_Item.Text_BtnGet:SetText(GText("UI_GameEvent_HasClaimed"))
    end

    self:UpdateUIByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType())

    ActivityUtils.SetUpJustifyOfJap(self.WBP_Activity_TenTimesReward_Title.Text_ActivityDesc)
end

function M:GetCurFocusWidgetInfo()
    self:UpdateUIByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType())
    return self.FocusWidgetName, self.FocusWidgetWidget
end

function M:UpdateUIByInputDevice(CurInputDeviceType)
    if CurInputDeviceType == ECommonInputType.Gamepad then
        if self.IsGetReward then
            self.TenTimesReward_Item.Key_Get:SetVisibility(ESlateVisibility.Collapsed)
        else
            self.TenTimesReward_Item.Key_Get:SetVisibility(ESlateVisibility.Visible)
        end
    elseif CurInputDeviceType == ECommonInputType.MouseAndKeyboard then
        self.TenTimesReward_Item.Key_Get:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:HandleKeyDownInPage(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadButtonDown(InKeyName)
    else

    end
    return IsEventHandled
end

function M:OnGamePadButtonDown(InKeyName)
    local IsEventHandled = self:Handle_KeyDownOnGamePad(InKeyName)
    return IsEventHandled
end

function M:Handle_KeyDownOnGamePad(InKeyName)
    -- 处理手柄相关的交互事件
    local IsEventHandled = false
    if (InKeyName == "Gamepad_FaceButton_Left") then
        self:OnBtnClick()
        IsEventHandled = true
    end
    return IsEventHandled
end

return M
