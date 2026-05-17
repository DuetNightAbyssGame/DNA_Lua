--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local MiscUtils = require "Utils.MiscUtils"

---@type WBP_GameReview_Main_C
local M = Class(
        {
            "BluePrints.UI.BP_UIState_C",
        }
)
--BluePrints.UI.WBP.GameReview.WBP_GameReview_Main_C

function M:Construct()
    self:InitPlatform()
    self.Btn_Close.Btn_Close.OnClicked:Add(self, self.JumpToClose)
end

function M:Destruct()

end

function M:InitPlatform()
    local PlatformInitFuncs = {
        IOS = self.InitIOSContent,
        TapTap = self.InitTapTapContent,
        Google = self.InitGoogleContent,
    }
    local PlatformName = MiscUtils:GetGameReviewPlatform()
    if PlatformInitFuncs[PlatformName] then 
        PlatformInitFuncs[PlatformName](self)
        return
    end
    local ImgChannelId = HeroUSDKSubsystem():GetMirrorChannelId()
    local ChannelId = HeroUSDKSubsystem():GetChannelId()
    print("GameReview:: Init Error Platform.", PlatformName, ChannelId , ImgChannelId)
end

function M:InitGoogleContent()
    self.IsGooglePlay = true
    self:InitIOSContent()
end
function M:InitIOSContent()
    self.WS_Content:SetActiveWidgetIndex(0)
    self.Text_QA:SetText(GText("UI_GameReview_Title_1"))
    self.Text_GameReview:SetText(GText("UI_GameReview_Content_1"))
    self.Btn_Excellent.Text_Button:SetText(GText("UI_GameReview_Option_1"))
    self.Btn_Good.Text_Button:SetText(GText("UI_GameReview_Option_2"))
    self.Btn_Normal.Text_Button:SetText(GText("UI_GameReview_Option_3"))
    self.Btn_Improve.Text_Button:SetText(GText("UI_GameReview_Option_4"))

    self.Btn_Excellent.Button_Area.OnClicked:Add(self, self.JumpToIosReview)
    self.Btn_Good.Button_Area.OnClicked:Add(self, self.JumpToIosReview)
    self.Btn_Normal.Button_Area.OnClicked:Add(self, self.JumpToBadComment)
    self.Btn_Improve.Button_Area.OnClicked:Add(self, self.JumpToBadComment)
end

function M:InitTapTapContent()
    self.WS_Content:SetActiveWidgetIndex(1)
    self.Text_GameReview_Tap:SetText(GText("UI_GameReview_Title_2"))
    self.Text_ReviewTap:SetText(GText("UI_GameReview_Content_2"))
    self.Btn_FeedBack.Text_Button:SetText(GText("UI_GameReview_Comment"))
    self.Btn_JumpTap.Text_Button:SetText(GText("UI_GameReview_TapTap"))

    self.Btn_FeedBack.Button_Area.OnClicked:Add(self, self.JumpToFeedback)
    self.Btn_JumpTap.Button_Area.OnClicked:Add(self, self.JumpToTapTapReview)
end

function M:JumpToBadComment()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click", nil, nil)
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    UIManager:ShowUITip(UIConst.Tip_CommonTop, GText("UI_GameReview_Finish"))
    self:CloseUI()
end

function M:JumpToFeedback()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click", nil, nil)
    if HeroUSDKSubsystem():IsHeroSDKEnable()  then
        HeroUSDKSubsystem(self):OpenService()
    end
    self:CloseUI()
end

function M:JumpToIosReview()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click", nil, nil)
    if HeroUSDKSubsystem():IsHeroSDKEnable()  then
        HeroUSDKSubsystem():AppRatingWithType(0, "")
    end
    self:CloseUI()
end

function M:JumpToTapTapReview()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click", nil, nil)
    if HeroUSDKSubsystem():IsHeroSDKEnable()  then
        HeroUSDKSubsystem():AppRatingWithType(1, "")
    end
    self:CloseUI()
end

function M:JumpToClose()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_return", nil, nil)
    self:CloseUI()
end

function M:CloseUI()
    UIManager(self):UnLoadUINew("GameReview")
end

return M
