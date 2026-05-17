--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Battle_ProcessPoint_C
local WBP_Battle_ProcessPoint_C = Class("BluePrints.UI.BP_EMDungeonWidget_C")

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function WBP_Battle_ProcessPoint_C:Construct()
    self.State = {
        "Lock",
        "Unlock",
        "Interaction",
        "CountDown",
        "Complete",
        "Fail",
    }
    self.Panel = {
        self.Panel_Lock,
        self.Panel_Interaction,
        self.Panel_Complete,
        self.Panel_Fail
    }
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function WBP_Battle_ProcessPoint_C:InitWidget(Owner, PointIdnex)
    self.Owner = Owner
    self.CurState = ""
    self:SetPointState("Lock")
    --self:HideAllPanel()
    self.MyIndex = PointIdnex
    self.MyCountDown = 60--后期读表获取这个点的倒计时时间
end

function WBP_Battle_ProcessPoint_C:HideAllPanel()
    for key, value in pairs(self.Panel) do
        value:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function WBP_Battle_ProcessPoint_C:StateIndex2StateStr(StateIndex)
    for key, value in ipairs(self.State) do
        if key == StateIndex then
            return value
        end
    end
end

function WBP_Battle_ProcessPoint_C:SetPointState(StateStr, TimerHandleName, CountDownTextmap)
    if not StateStr then
        DebugPrint("thy    StateStr 是 nil，检查蓝图传入的状态索引") 
        return false
    end
    --状态没变，不需要重新设定
    if self.CurState == StateStr then return false end
    --蓝图不传值TimerHandleName会为是空字符串，主动改为nil，不然下面的判断太抽象了
    if TimerHandleName == "" then TimerHandleName = nil end
    self.CurTimerHandle = TimerHandleName
    self:PlayAnimation(self[self.CurState.."_Out"])
    self.CurState = StateStr
    self:PlayAnimation(self[self.CurState.."_In"])
    self:HideAllPanel()
    if StateStr == "Lock" then
        self.Panel_Lock:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.BG_Bar_UnLock:SetVisibility(ESlateVisibility.Collapsed)
    elseif StateStr == "Unlock" then
        self.Panel_Lock:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.BG_Bar_UnLock:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        if self.CurTimerHandle then
            --开启倒计时
            self.MyCountDown = CommonUtils.GetClientTimerStructTotalTime(self.CurTimerHandle)
            if self.MyCountDown == 0 then
                GWorld.logger.error("CountDown为0, 请检查TimeHandleName配置!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
            end
            self:AddTimer(0.1, self.UpdateCountDownUI, true, 0, "CountDown", true, CountDownTextmap)
        end
    elseif StateStr == "CountDown" then
        self.Panel_Interaction:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Panel_Interaction_CD:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Panel_Interaction_WT:SetVisibility(ESlateVisibility.Collapsed)
        self.MyCountDown = CommonUtils.GetClientTimerStructTotalTime(self.CurTimerHandle)
        if self.MyCountDown == 0 then
            GWorld.logger.error("CountDown为0, 请检查TimeHandleName配置!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        else
            self.WBP_Com_Bubble:Init({
                Text = string.format(GText(CountDownTextmap), self.MyCountDown),
                ColorType = 7,
                Arrow = 1,
            })
        end
        self:AddTimer(0.1, self.UpdateCountDownUI, true, 0, "CountDown", true, CountDownTextmap)
    elseif StateStr == "Interaction" then
        self.Panel_Interaction:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Panel_Interaction_CD:SetVisibility(ESlateVisibility.Collapsed)
        self.Panel_Interaction_WT:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    elseif StateStr == "Complete" then
        self.Panel_Complete:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    elseif StateStr == "Fail" then
        self.Panel_Fail:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        ScreenPrint("thy    SetPointState: 未知状态 " .. StateStr)
        DebugPrint("thy    SetPointState: 未知状态 ", StateStr)
    end

    return true
end

function WBP_Battle_ProcessPoint_C:UpdateCountDownUI(CountDownTextmap)
    local DisplayRemainTime = CommonUtils.GetClientTimerStructRemainTime(self.CurTimerHandle)
    if DisplayRemainTime < 0 then
        DisplayRemainTime = 0
    end
    self:UpdateColoBarProgress(DisplayRemainTime)
    if self.CurState == "CountDown" then
        self.WBP_Com_Bubble.Text_Bubble:SetText(string.format(GText(CountDownTextmap), self.Owner:GetTimeStr_Cpp(DisplayRemainTime)))
    end
end

function WBP_Battle_ProcessPoint_C:UpdateColoBarProgress(DisplayRemainTime)
    if self.CurState == "Unlock" then
        self.ColorBarProgress = self.BG_Bar_UnLock:GetDynamicMaterial()
        local Percent = DisplayRemainTime / self.MyCountDown
        self.ColorBarProgress:SetScalarParameterValue("Percent", 1 - Percent)
    elseif self.CurState == "CountDown" then
        self.ColorBarProgress = self.BG_Bar_CD:GetDynamicMaterial()
        local Percent = DisplayRemainTime / self.MyCountDown
        self.ColorBarProgress:SetScalarParameterValue("Percent", 1 - Percent)
    end
end

function WBP_Battle_ProcessPoint_C:UpdateColorBarProgressPercent(Percent)
    if self.CurState == "Unlock" then
        self.ColorBarProgress = self.BG_Bar_UnLock:GetDynamicMaterial()
        self.ColorBarProgress:SetScalarParameterValue("Percent", Percent)
    elseif self.CurState == "CountDown" then
        self.ColorBarProgress = self.BG_Bar_CD:GetDynamicMaterial()
        self.ColorBarProgress:SetScalarParameterValue("Percent", Percent)
    end
end

return WBP_Battle_ProcessPoint_C
