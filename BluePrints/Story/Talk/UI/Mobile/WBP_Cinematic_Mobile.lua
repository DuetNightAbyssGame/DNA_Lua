--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

---@class WBP_Cinematic_Mobile : BP_TalkBaseUINew_C
local WBP_Cinematic_Mobile = Class("BluePrints.Story.Talk.UI.Common.WBP_Cinematic_Common")

function WBP_Cinematic_Mobile:OnPlayKeyActive()
    self.Story_PlayBtn:SetVisibility(UE4.ESlateVisibility.Visible)
end

function WBP_Cinematic_Mobile:OnPlayKeyDeactive()
    self.Story_PlayBtn:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function WBP_Cinematic_Mobile:InitPlayKey()
    self.Story_PlayBtn:InitPlayKey()
end

function WBP_Cinematic_Mobile:OnSkipButtonClicked()
    self:ShowSkipPopup()
end

-- 弹框是否确认跳过
function WBP_Cinematic_Mobile:ShowSkipPopup()
    local Params = {}
    Params.RightCallbackFunction = self.OnSkipConfirmed
    Params.RightCallbackObj = self
    Params.OnCloseCallbackFunction = self.OnPopupEnd
    Params.OnCloseCallbackObj = self
    Params.DontPlayOutAnimation = true
    local PopupUI = UIManager(self):ShowCommonPopupUI(100070, Params)
    if IsValid(PopupUI) then
        self:OnPaused() 
    end
end

function WBP_Cinematic_Mobile:OnPopupEnd()
    self:OnPauseResumed()
end

function WBP_Cinematic_Mobile:OnSkipConfirmed()
    self:SwitchEnableSkipButton(false)
    self.SkipButtonClicked_Delegate:Fire()
end


return WBP_Cinematic_Mobile