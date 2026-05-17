--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_ModArchive_Task_TitleItem_P_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

function M:Construct()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self.CurInputDeviceType = self.GameInputModeSubsystem:GetCurrentInputType()

    if self.Key_TaskRewardTitle then
        self.Key_TaskRewardTitle:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "LS",
                }
            }
        })
    end

    if self.Key_TitleLeft then
        self.Key_TitleLeft:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "LT",
                }
            }
        })
    end

    if self.Key_TitleRight then
        self.Key_TitleRight:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "RT",
                }
            }
        })
    end

    self.Btn_Get:SetDefaultGamePadImg("A")
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        return
    end
    if not self.Owner or self.Owner.CurInputDeviceType ~= ECommonInputType.GamePad then return end
    -- if self.Owner and self.Owner:IsAnimationPlaying(self.Owner.In) then return end
    -- AudioManager(self):PlayUISound(self, "event:/ui/common/hover_btn_large", nil, nil)
    -- self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
    self.IsHovering = true
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        return
    end
    if not self.Owner or self.Owner.CurInputDeviceType ~= ECommonInputType.GamePad then return end
    -- if self.Owner and self.Owner:IsAnimationPlaying(self.Owner.In) then return end
    -- self:StopAllAnimations()
    self:PlayAnimation(self.UnHover)
    self.IsHovering = false
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    self.InFocus = true
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        self.Key_TaskRewardTitle:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        if self.Key_TitleLeft and self.Key_TitleRight then
            self.Key_TitleLeft:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.Key_TitleRight:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
        self.Btn_Get:SetGamePadVisibility(ESlateVisibility.SelfHitTestInvisible)
        if self.Owner and self.Owner.Owner then
            self.Owner.Owner:SwitchComKeyTipsState(7)
        end
    end
end

function M:OnFocusLost(InFocusEvent)
    self.InFocus = false
    self.Key_TaskRewardTitle:SetVisibility(ESlateVisibility.Collapsed)
    if self.Key_TitleLeft and self.Key_TitleRight then
        self.Key_TitleLeft:SetVisibility(ESlateVisibility.Collapsed)
        self.Key_TitleRight:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.Btn_Get:SetGamePadVisibility(ESlateVisibility.Collapsed)
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        if self.Owner and self.Owner.Owner then
            self.Owner.Owner:SwitchComKeyTipsState(3)
        end
    end
end

function M:OnGamePadSelected()
    self.ListView_Rewards:SetFocus()
end




function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        return
    end
    --更新输入模式
    self.CurInputDeviceType = CurInputDevice
    self.CurGamepadName = CurGamepadName

    self:UpdateOnInputDeviceTypeChange()
end

function M:UpdateOnInputDeviceTypeChange()
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        if self.InFocus then
            self.Key_TaskRewardTitle:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
        if self.Key_TitleLeft and self.Key_TitleRight and self.InFocus then
            self.Key_TitleLeft:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.Key_TitleRight:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
        if self.Owner and self.Owner.CurPhaseId and self.Owner.MaxPhase then
            local CurPhaseId = self.Owner.CurPhaseId
            if CurPhaseId == 1 then
                if self.Key_TitleLeft then
                    self.Key_TitleLeft:SetForbidKey(false)
                    self.Key_TitleLeft:SetForbidKey(true)
                end
            end

            if CurPhaseId == self.Owner.MaxPhase then
                if self.Key_TitleRight then
                    self.Key_TitleRight:SetForbidKey(false)
                    self.Key_TitleRight:SetForbidKey(true)
                end
            else
                -- 不是最右，判断下一阶段可否查看
                local NextPhase = CurPhaseId + 1
                local Avatar = GWorld:GetAvatar()
                if DataMgr.ModTaskPhase and DataMgr.ModTaskPhase[NextPhase] and DataMgr.ModTaskPhase[NextPhase].Condition and not ConditionUtils.CheckCondition(Avatar, DataMgr.ModTaskPhase[NextPhase].Condition) then
                    if self.Key_TitleRight then
                        self.Key_TitleRight:SetForbidKey(false)
                        self.Key_TitleRight:SetForbidKey(true)
                    end
                else
                    if self.Key_TitleRight then
                        self.Key_TitleRight:SetForbidKey(true)
                        self.Key_TitleRight:SetForbidKey(false)
                    end
                end
            end
        end
    else
        self.Key_TaskRewardTitle:SetVisibility(ESlateVisibility.Collapsed)
        if self.Key_TitleLeft and self.Key_TitleRight then
            self.Key_TitleLeft:SetVisibility(ESlateVisibility.Collapsed)
            self.Key_TitleRight:SetVisibility(ESlateVisibility.Collapsed)
        end
    end
end


return M
