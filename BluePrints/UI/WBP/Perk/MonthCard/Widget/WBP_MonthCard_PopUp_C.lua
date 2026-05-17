--
-- DESCRIPTION
-- 月卡界面弹窗拍脸
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

--- @type WBP_MonthCard_PopUp_C
local M = Class("BluePrints.UI.BP_UIState_C")

M._components = {
    "BluePrints.UI.WBP.Perk.MonthCard.View.MonthCardPopupView"
}
function M:Construct()
    M.Super.Construct(self)
    self:AddInputMethodChangedListen()
    self.Btn_FullClose.OnClicked:Add(self, self.NextAction)
end

--- @param Reward MonthCardReward
function M:OnLoaded(Reward, ...)
    -- 界面初始化完成
    M.Super.OnLoaded(self)
    self:InitListenEvent()
    self:RefreshBaseInfo()
    
    self:PlayInAnim()
    self:SetDailyReward(Reward)
end

function M:Close()
    -- TODO 界面关闭逻辑
    EventManager:RemoveEvent(EventID.CloseLoading, self)
    M.Super.Close(self)
end

function M:InitListenEvent()
    -- TODO 监听相关事件
end

function M:RefreshBaseInfo()
    -- 刷新一些基础数据
    self:InitBaseView()
end

function M:OnReturnKeyDown()
    -- 返回上一级
    if (not self:CheckIsCanCloseSelf()) then
        return
    end

    -- UIUtils.PlayCommonBtnSe(self)
    self:PlayOutAnim()
end

--------------------------输入交互--------------------------------
function M:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if (not self:HasAnyUserFocus()) and (not self:HasFocusedDescendants()) then
            IsEventHandled = self:OnGamePadDown(InKeyName)
        end
    else
        if InKeyName == "Escape" then
            self:NextAction()
            IsEventHandled = true
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:NextAction()
    --if self:IsAnyAnimationPlaying() then return end
    if self.bAfterLoaded then
        self:OnReturnKeyDown()
    end
end

function M:OnGamePadDown(InKeyName)
    -- local IsEventHandled = self.Com_Tab:Handle_KeyEventOnGamePad(InKeyName)
    -- return IsEventHandled
    if InKeyName == Const.GamepadFaceButtonDown then
        self:NextAction()
        return true
    end
    return false
end

function M:Handle_KeyDownOnGamePad()
    -- 处理手柄相关的交互事件
    return true
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    self:SwitchInputType(CurInputDevice, CurGamepadName)
end

AssembleComponents(M)
return M
