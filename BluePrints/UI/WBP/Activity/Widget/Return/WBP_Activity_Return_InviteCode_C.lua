--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local DevServerList = require "BluePrints/UI/GameLogin/DevServerList"
---@type WBP_Activity_Return_InviteCode_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.ActivityReturnType = "InviteCode"
    self.Text_Title:SetText(GText("UI_ComeBackEvent_Invite_Title"))
    self.Text_InviteCodeDesc:SetText(GText("UI_ComeBackEvent_Invite_Des"))
    self.Btn_Jump:SetText(GText("UI_ComeBackEvent_Invite_JumpBtn"))
    self.Btn_Jump.AudioEventPath = "event:/ui/activity/feina_tab_btn_click"
    self.Btn_Jump:BindEventOnClicked(self, self.OpenReturnInviteCode)
    self.Btn_Jump:SetGamePadImg("Y")
    self.Btn_Jump:SetGamePadVisibility(UIUtils.IsGamepadInput() and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:Init(InitParams)
    self:PlayAnimation(self.In)
end

function M:RefreshOpInfoByInputDevice()
    self.Btn_Jump:SetGamePadVisibility(UIUtils.IsGamepadInput() and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:OpenReturnInviteCode()
    local Avatar = GWorld:GetAvatar()
    if not Avatar or not Avatar.Hostnum then
        return
    end
    local Server = DevServerList[Avatar.Hostnum]
    if not Server or not Server.area then
        return
    end
    local Area = Server.area
    local InviteEventConfig = DataMgr.InviteEventScheme[114001][Area]
    if not InviteEventConfig then
        return
    end
    local JumpLink = InviteEventConfig.PCJumpLink
    if CommonUtils.GetRuntimePlatform() == "Mobile" then
        JumpLink = InviteEventConfig.PhoneJumpLink
    end
    UE4.UKismetSystemLibrary.LaunchURL(JumpLink)
end

function M:Destruct()
    self.Btn_Jump:UnBindEventOnClicked(self, self.OpenReturnInviteCode)
end

return M
