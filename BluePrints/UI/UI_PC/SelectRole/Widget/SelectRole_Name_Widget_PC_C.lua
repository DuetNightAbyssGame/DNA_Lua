--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local HeroUSDKUtils = require "Utils.HeroUSDKUtils"
local PlayerNameUtils = require "Utils.PlayerNameUtils"

---@type SelectRole_Name_Widget_PC_C
local M = Class("BluePrints.UI.BP_UIState_C")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Init()
    self.Btn_Continue:BindEventOnClicked(self,self.OnClickButtonContinue)
    self.Btn_Continue:SetText(GText("UI_LOGIN_ENSURE"))
    self.Btn_Continue:ForbidBtn(true)
    self.Text_Input:Init({
        Owner = self,
        Events = {
                    OnTextChanged = self.OnNameChanged,   --文本改变时
                    -- OnCheckTextLegality = self.CheckStrLen
                    -- OnTextComposing = function(Owner,Text), --文本改变时（中文输入法按选词之前）
                    -- OnTextCommitted = function(Owner,Text,CommitMethod)--文本提交时
            --         OnCheckTextLegality = function(Owner,Text) , --文本合法性校验函数，OnTextChanged和OnTextCommitted前会调用
            --                                                  两个返回值：是否合法（true则将第二个返回值设置给输入框，false则本次输入无效），
            --                                                             字符串(会SetText到输入框)
            --         OnFocusReceived = function(Owner), --文本框失去聚焦
                    -- OnFocusLost = function(Owner)
                    --     if not self:HasFocusedDescendants() or not self:HasAnyUserFocus() then
                    --         self.Btn_Continue:SetFocus()
                    --         print(_G.LogTag,"LXZ OnTextCommitted")
                    --     end
                    -- end --文本框失去聚焦时
                },
        bLimitSpaces = true,
        HintText = GText("UI_LOGIN_ENSURE"), --空文本时的提示文本
        TextLimit = 14,    --最大字数限制
    })
    self.Text_Input:SetHintText(GText("UI_REGISTER_NAME"))
    if self.RootPage.SelectNodeType ~= "Current" then
        self.Text_Input:SetText(GText("ExPlayerDefaultName"))
    else
        self.Text_Input:SetText(GText("PlayerDefaultName"))
    end
    self.Text_Num:SetText(0)
    self.NowNameLength = 0
    self.SpaceIndex = {}

    if not (CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile") then
    else
        self.Btn_Back:SetText(GText("UI_REGISTER_BACK"))
        self.Btn_Back:BindEventOnClicked(self,self.OnClickButtonBack)
    end

    self.Text_Tips01:SetText(GText("UI_REGISTER_OVERLENGTH"))
    self.Text_Tips02:SetText(GText("UI_REGISTER_BANNEDINPUT"))
    self.Text_Tips03:SetText(GText("UI_REGISTER_ILLEGALINPUT"))
    self.Text_Tips04:SetText(GText("UI_REGISTER_INCLUDEBLANKCHAR"))
    self.Switch_Tips:SetRenderOpacity(0)
    self.Root:SetRenderOpacity(0)

    self:BindToAnimationFinished(self.In, {self, function() 
        self:SetVisibility(4)
    end})
    self:BindToAnimationFinished(self.Out, {self, function() 
        self:SetVisibility(3)
    end})
end

function M:FinishNode()
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	local RealGameMode = GameMode.SubGameModeInfo:Find("Prologue_Void")
	if RealGameMode and RealGameMode.PlayCastingSequence then
        RealGameMode.Sequence:Stop()
	else
        GameMode.Sequence:Stop()
    end
    EventManager:FireEvent(EventID.OnSelectFinish)
end

function M:OnClickButtonContinue()
    print(_G.LogTag,"LXZ OnClickButtonContinue")
    -- local Nickname = self.Text_InputName:GetText()
    local Nickname = self.Text_Input:GetText()
    if PlayerNameUtils.CheckIsAllSpace(Nickname) then
        -- self.Text_Tips02:SetText(GText("UI_REGISTER_EMPTY"))
        self.Text_Input:ShowTips(GText("UI_REGISTER_EMPTY"), 2)
        -- self:PlayWariningAnimation(1)
        return
    end
    self.RootPage.bCanChangeRole = false
    self.Text_Tips02:SetText(GText("UI_REGISTER_BANNEDINPUT"))
    HeroUSDKUtils.CheckStringSensitive(self, Nickname, self.OnNameSensitive, self.OnNameNotSensitive)
end

function M:OnNameSensitive(ReplaceName, Name, Words)
    -- 敏感词替换为*并且标红，暂时废弃
    -- local RealName = ReplaceName
    -- local i = 1
    -- local j = 1
    -- local HighLightNum = 0
    -- while(true) do
    --     local OldByte = string.byte(Name, i)
    --     local ReplaceByte = string.byte(ReplaceName, j)
    --     local OldLength = self:GetWordLength(OldByte)
    --     local ExtraLength = 12 * (HighLightNum)
    --     if OldByte ~= ReplaceByte then
    --         RealName = PlayerNameUtils.HighLightWord(RealName, j + ExtraLength, j + ExtraLength)
    --         i = i + OldLength
    --         j = j + 1
    --         HighLightNum = HighLightNum + 1
    --     else
    --         i = i + OldLength
    --         j = j + OldLength
    --     end
    --     if i > #Name then
    --         break
    --     end
    -- end
    -- self.Text_InputName:SetText(ReplaceName)
    -- self.Text_Show:SetText(RealName)
    -- AudioManager(self):PlayUISound(self, "event:/ui/common/click", "", nil)
    self.Text_Input:ShowTips(GText("UI_REGISTER_BANNEDINPUT"), 1)
    -- self:PlayWariningAnimation(1)
    self.WaitCallBack = false
    self.RootPage.bCanChangeRole = true
end

function M:OnNameNotSensitive(Name)
    if self.WaitCallBack == true then
        return
    end

    AudioManager(self):PlayUISound(self, "event:/ui/common/gender_select_role_create_success", nil, nil)

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    local function Callback(Res)
        print(_G.LogTag,"LXZ AvatarCreateRole Callback", Res)
        self.Btn_Continue:ForbidBtn(false)
        self.WaitCallBack = false
        if Res then
            self:SetInputUIOnly(false)
            self.RootPage:PlayAnimation(self.RootPage.Out)
            local HeroUSDKUtils = require "Utils.HeroUSDKUtils"
            HeroUSDKSubsystem():HeroSDKRoleEnterGame(HeroUSDKUtils.GenHeroHDCGameRoleInfo())
            AudioManager(self):SetVoiceGender()
        end
    end
    self.Btn_Continue:ForbidBtn(true)
    local Sex = self.RootPage.Page_Role.NowRole == "Male" and 0 or 1
    local UsedName = PlayerNameUtils.DeleteHeadAndTailSpace(Name)
    if self.RootPage.SelectNodeType == "Current" then
        Avatar:AvatarCreateRole(UsedName, Sex, Callback)
    else
        Avatar:SetWeitaInfo(UsedName, Sex, Callback)
    end
end

function M:OnClickButtonBack()
    self.RootPage:ChangeWidget("SelectRole")
    self.RootPage.Page_Role.NowState = self.RootPage.Page_Role.NowRole == "Male" and 7 or 6
    self.RootPage:OnBackToDetail()
    if self.RootPage.DeviceInPc then
        self.RootPage.Key_Back:SetVisibility(ESlateVisibility.Collapsed)
        self.RootPage.Key_Observe:SetVisibility(ESlateVisibility.Collapsed)
    end
    -- if self.RootPage.IsGM then
        
    -- else
    --     EventManager:FireEvent(EventID.OnSelectRole, 0)
    -- end
end

function M:Handle_KeyEventOnGamePad(InKeyName)
    print(_G.LogTag,"LXZ Handle_KeyEventOnGamePad", InKeyName)
    if InKeyName == "Escape" or InKeyName == "Gamepad_FaceButton_Right" then
        self:OnClickButtonBack()
    elseif InKeyName == "Gamepad_FaceButton_Bottom" then
        print(_G.LogTag,"LXZ Handle_KeyEventOnGamePad2", InKeyName)
        self:OnClickButtonContinue()
    elseif InKeyName == "Gamepad_FaceButton_Left" then
        self.Text_Input:SetFocus()
    elseif InKeyName == "Gamepad_LeftThumbstick" then
        self.Text_Input:PasteText()
    elseif InKeyName == "Gamepad_RightShoulder" then
        print(_G.LogTag,"LXZ Handle_KeyEventOnGamePad", InKeyName, self.RootPage.Page_Role.NowState)
        if self.RootPage.Page_Role.NowRole == "Female"  then
            self.RootPage.Page_Role:OnClickButtonMale()
        elseif self.RootPage.Page_Role.NowRole == "Male" then
            self.RootPage.Page_Role:OnClickButtonFemale()
        end
    end
    return true
end

function M:OnNameComposing(Text) 
    self.Text_Show:SetText("")
end

function M:OnNameChanged(NewName)
    print(_G.LogTag,"LXZ OnNameChanged", NewName)
    if NewName == "" then
        self.Btn_Continue:ForbidBtn(true)
        return
    end
    self:CheckStrLen()
    self.Btn_Continue:ForbidBtn(false)
end

--Type 0：超长度 1：敏感词 2：不合法字符
function M:PlayWariningAnimation(Type)
    self.Switch_Tips:SetActiveWidgetIndex(Type)
    AudioManager(self):PlayUISound(self, "event:/ui/common/input_err", nil, nil)
    self:PlayAnimation(self.Warning)
end

function M:RefreshInfoByInputTypeChange(CurInputDevice, CurGamepadName)
    print(_G.LogTag,"LXZ RefreshInfoByInputTypeChange Name")
    if CurInputDevice == ECommonInputType.MouseAndKeyboard then
        self.Btn_Continue:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    elseif CurInputDevice == ECommonInputType.Gamepad then
        self.Btn_Continue:SetVisibility(ESlateVisibility.Collapsed)
    elseif CurInputDevice == ECommonInputType.Touch then
        self.Btn_Continue:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end

function M:CheckStrLen()
    if not self.RootPage.DeviceInPc then
        return
    end
    local Text = self.Text_Input:GetText()
    local Len = self.Text_Input:Utf8StrLen(Text)
    if Len > self.Text_Input.TextLimit or Len == 0 then
        self.RootPage.Key_Continue:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.RootPage.Key_Continue:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end


return M
