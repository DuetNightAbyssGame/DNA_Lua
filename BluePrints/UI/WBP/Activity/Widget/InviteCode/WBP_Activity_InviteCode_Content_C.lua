--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local HeroUSDKUtils = require "Utils.HeroUSDKUtils"

---@type WBP_Activity_InviteCode_Content_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Btn_Paste.OnClicked:Add(self, self.OnBtnPasteClicked)
    self.Text_InviteCodeTitle:SetText(GText("InvitationEvent_MyCode"))
    self.Text_InvitedTitle:SetText(GText("InvitationEvent_PlayersInvited"))
    self:RefreshBaseInfo()
    self:InitListenEvent()
    self.Key_Copy:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "View"
            }
        }
    })
end

function M:Destruct()
    self.Btn_Paste.OnClicked:Remove(self, self.OnBtnPasteClicked)
end

function M:Init()
    self._Avatar = GWorld:GetAvatar()
    self._Avatar:GetInviteActivityInfo(function(ret, ...)
        if not ErrorCode:Check(ret) then
            return
        end

        local InviteInfos = ...
        local InviteData = InviteInfos.data
        self.InviteCode = InviteData.code
        PrintTable(InviteInfos,2)
        PrintTable(InviteData,2)
        self.Text_MyInviteCode:SetText(GText(InviteData.code))
        self:UpdateInviteInfos(InviteData)
    end)
end

function M:OnBtnPasteClicked()
	local SdkUserInfo = HeroUSDKUtils.GetUserInfo()
    local AccessToken = SdkUserInfo.accessToken
    local SdkUserId = SdkUserInfo.sdkUserId
    local UserName = SdkUserInfo.userName
    if self.InviteCode ~= nil then
        ULowEntryExtendedStandardLibrary.ClipboardSet(self.InviteCode)
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("InvitationEvent_Copy_Tosat"))
    else
        UIManager(GWorld.GameInstance):ShowError(ErrorCode.RET_INVITEINFO_HTTP_RET_FAIL,1.0,"CommonToastMain")
    end
end

function M:UpdateInviteInfos(InviteData)
    for i = 1, 4 do
        local InviteStatus = InviteData["invite"..i] or 0
        if InviteStatus == 0 then
            self["WS_Invite_" .. i]:SetActiveWidgetIndex(0)
        else
            self["WS_Invite_" .. i]:SetActiveWidgetIndex(1)
        end
    end
end

function M:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function M:RefreshBaseInfo()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    self.CurGamepadName = CurGamepadName
    local IsUseGamepad = CurInputDevice == ECommonInputType.Gamepad
    if (IsUseGamepad) then
        --手柄
        self.Key_Copy:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Key_Copy:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.CurInputDevice = CurInputDevice
end

function M:HandleKeyDownInPage(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false

    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadButtonDown(InKeyName)
    else
        if (InKeyName == "Escape") then
            self:CloseSelf()
        end
    end

    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnGamePadButtonDown(InKeyName)
    local IsEventHandled = self:HandleKeyDownOnGamePad(InKeyName)
    return IsEventHandled
end

function M:HandleKeyDownOnGamePad(InKeyName)
    if (InKeyName == UIConst.GamePadKey.SpecialLeft) then
        self:OnBtnPasteClicked()
    end
end

return M
