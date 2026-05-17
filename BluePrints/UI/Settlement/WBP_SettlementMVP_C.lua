--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_SettlementMVP_C
local M = Class("BluePrints.UI.BP_UIState_C")
local EMCache = require "EMCache.EMCache"

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Super.Construct(self)
    self.CanSkip = false
    self.MVPFinishFunction = nil
    self.MVPDamage = 0

    if self.Key_Continue then
        self:InitDeviceInfo()
        -- self.Key_Continue.OnClicked:Add(self, self.OnClickedButtonContinue)
    elseif self.Btn_Continue then
        self.Btn_Continue:SetText(GText("UI_GACHA_SKIP"))
        self.Btn_Continue.Button_Area.OnClicked:Add(self, self.OnClickedButtonContinue)
    end
    local IsSkip = EMCache:Get("SkipMVP")
    if IsSkip == nil then
        local OptionInfo = DataMgr.Option["SkipMVP"]
        if CommonUtils.GetRuntimePlatform(self) == "Mobile" and OptionInfo and OptionInfo.DefaultValueM then
            IsSkip = OptionInfo.DefaultValueM
        else
            IsSkip = OptionInfo.DefaultValue
        end
        if IsSkip == "False" then
            IsSkip = false
        elseif IsSkip == "True" then
            IsSkip = true
        end
    end
    self.IsSkip = IsSkip
    self.IsClickSkip = false
end

function M:InitDeviceInfo()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function M:OnLoaded(...)
    M.Super.OnLoaded(self, ...)
    self:SetFocus()
    self.MVPFinishFunction, self.MVPDamage, self.MVPName, self.MVPTextData = ...
    -- Utils.ScreenPrint("MVP展示开发中，倒计时 跳过倒计时"..self.SkipShowTime)
    self.Text_Name:SetText(self.MVPName)
    self.Text_Row01:SetText(GText("UI_STAT_DAMAGE_TITLE")..": "..Utils.FormatNumber(math.floor(self.MVPDamage), true))
    self:SetTextData()
    self:AddTimer(UIConst.MVPSkipShowTime, function()
        --自动跳过
        if self.IsSkip then
            self:OnFinish()
        else
            self:PlayAnimation(self.In)
            AudioManager(self):PlayUISound(self, "event:/ui/common/level_mvp_in", nil, nil)
            self.CanSkip = true
        end
    end, false, 0)
end

function M:SetTextData()
    local FinalText = ""
    if self.MVPTextData then
        FinalText = GText(self.MVPTextData.Textmap)..": "..self.MVPTextData.Value
    end
    self.Text_Row02:SetText(FinalText)
end

function M:OnAnimationFinished(InAnimation)
    if InAnimation == self.Out then
        self:Close()
    end
end

function M:OnFinish()
    self:Close()
    if self.MVPFinishFunction then
        self.MVPFinishFunction()
    end
end

function M:OnSequenceFinish()
    self:PlayAnimation(self.Out)
    if self.MVPFinishFunction then
        self.MVPFinishFunction()
    end
end

function M:OnClickedButtonContinue()
    if self.CanSkip and not self.IsClickSkip then
        self:PlayAnimation(self.Out)
        if self.MVPFinishFunction then
            self.MVPFinishFunction()
        end
        self.IsClickSkip = true
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:Handle_OnGamePadDown(InKeyName)
    else
        IsEventHandled = self:Handle_OnPCDown(InKeyName) 
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

function M:Handle_OnPCDown(InKeyName)
    local IsEventHandled = false
    if InKeyName == "SpaceBar" or InKeyName == "Escape"then
        IsEventHandled = true
        self:OnClickedButtonContinue()
    end

    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:Handle_OnGamePadDown(InKeyName)
    local IsEventHandled = false
    if InKeyName == "Gamepad_FaceButton_Bottom" then 
        IsEventHandled = true
        self:OnClickedButtonContinue()
    end

    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    DebugPrint("RefreshOpInfoByInputDevice",CurInputDevice, CurGamepadName)
    --- 输入设备切换通知
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        return
    end
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if (IsUseKeyAndMouse) then
        self:GamePadToPC()
    else
        self:PCToGamepad()
    end
    self.CurInputDeviceType = CurInputDevice

    self.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
end

function M:GamePadToPC()
    if not self.Key_Continue then
        return
    end
    self:SetFocus()
    self.Key_Continue:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Text",
                ImgShortPath = "SpaceBar",
                ClickCallback = self.OnClickedButtonContinue,
                Owner = self
            }
        },
        Desc = GText("UI_GACHA_SKIP"),
    })
end

function M:PCToGamepad()
    if not self.Key_Continue then
        return
    end
    self:SetFocus()
    self.Key_Continue:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "A",
                Owner = self
            }
        },
        Desc = GText("UI_GACHA_SKIP"),
    })
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M
