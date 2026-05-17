require "UnLua"
local GachaCommon = require "BluePrints.UI.WBP.Gacha.GachaCommon"
local G = Class("BluePrints.UI.BP_EMUserWidget_C")

function G:Construct()
    self.Btn_Skip:SetCurrentTextBlock(GText("UI_GACHA_SKIP"))
    self.Btn_Skip:BindEventOnClicked(self,self.OnBtnSkipClicked)
    self.WBP_VideoPlayer:HideSkipButton(true)
    self.WBP_VideoPlayer:BindEventToMediaPlayEnd(self,self.OnVideoPlayEnd)
    self.Key_Tips:UpdateKeyInfo({
        {
            KeyInfoList = {{Type = "Img", ImgShortPath = UIConst.GamePadImgKey.FaceButtonBottom}},
            Desc = GText("UI_GACHA_SKIP")
        },
    })
    
    local PlatformName = UE4.UGameplayStatics.GetPlatformName()
    if PlatformName == "Android" then
        -- 监听应用生命周期事件，处理Android平台视频播放问题
        EventManager:AddEvent(EventID.ApplicationWillEnterBackground, self, self.OnApplicationWillEnterBackground)
        EventManager:AddEvent(EventID.ApplicationHasEnteredForeground, self, self.OnApplicationHasEnteredForeground)
    end
end

function G:Init(Result, RebateData)
    self.Result = Result
    self.RebateData = RebateData
    self:SetIsDealWithVirtualAccept(true)

    self.Parent.CantClick = true
    self.WBP_VideoPlayer:Stop()
    local Rarity = self:GetResultRarity()
    local PathHead = "GachaVideoMaleRarity"
    local Avatar = GWorld:GetAvatar()
    if Avatar and Avatar.Sex == CommonConst.Sex.Female then
        PathHead = "GachaVideoFemaleRarity"
    end
    local VideoPathInd = PathHead..Rarity
    local isPc = CommonUtils.GetDeviceTypeByPlatformName(self) == "PC"
    if isPc then 
        VideoPathInd = VideoPathInd .. "_PC"
    else
        VideoPathInd = VideoPathInd .. "_Mobile"
    end
    local path = CommonConst[VideoPathInd]
    local VideoObj = LoadObject(path)
    assert(VideoObj, "未找到对应的视频资源:"..path)
    self.WBP_VideoPlayer:SetUrlByMediaSource(VideoObj)
    self.CanSkip = true
    local GuideGachaId = DataMgr.GlobalConstant.GuideGachaId.ConstantValue
    if GuideGachaId and self.Parent.NowGachaId == GuideGachaId then
        self.CanSkip = false
        self.Btn_Skip:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Text_VoiceText:SetText(GText("UI_ChapterIntro_GaChaDialogue"))
        self.Group_Bottom:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Parent:PlayGuideGachaVoice(CommonConst.GuideGachaVoice,"EXPlayer")
    else
        self.Btn_Skip:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Group_Bottom:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self.WBP_VideoPlayer:SetLooping(false)
    self.WBP_VideoPlayer:Play()
    AudioManager(self):PlayUISound(self.Parent, "event:/ui/common/gacha_cg", "GachaAnime", nil)
    self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self:InitGamepadView()
    else
        self:InitKeyboardView()
    end
    self:SetAnimationCurrentTime(self.In, 0)
    self:PlayAnimation(self.In)
    self:SetFocus()
end

function G:GetResultRarity()
    local Rarity = 0
    for key,GachaResult in pairs(self.Result) do
        local Type = GachaCommon.GachaItemTypeMap[GachaResult.Sign]
        local ItemData = DataMgr[Type][GachaResult.ResultId]
        Rarity = math.max(Rarity, ItemData.Rarity or ItemData[Type.."Rarity"])
    end
    return Rarity
end

function G:OnParentUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    if CurInputType == ECommonInputType.Gamepad then
        self:InitGamepadView()
    else
        self:InitKeyboardView()
    end
end

function G:InitGamepadView()
    self:SetFocus()
    if self.CanSkip then
        self.Key_Tips:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
    self.Btn_Skip:SetVisibility(ESlateVisibility.Collapsed)
end

function G:InitKeyboardView()
    self.Key_Tips:SetVisibility(ESlateVisibility.Collapsed)
    if self.CanSkip then
        self.Btn_Skip:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end

function G:HandleKeyReleased(Key)
    if Key.KeyName == UIConst.GamePadKey.FaceButtonRight and self.CanSkip then
        self:OnBtnSkipClicked()
    end
end

function G:OnParentKeyDown(MyGeometry, InKeyEvent)
    if self.CanSkip then
        self:OnBtnSkipClicked()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function G:OnBtnSkipClicked()
    self:SetIsDealWithVirtualAccept(false)
    AudioManager(self):SetEventSoundParam(self.Parent, "GachaAnime", {state = 1})
    self.Parent:GetGachaResultSpecialShow(self.Result, self.RebateData)
    self.WBP_VideoPlayer:Stop()
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function G:OnVideoPlayEnd()
    self:SetIsDealWithVirtualAccept(false)
    AudioManager(self):SetEventSoundParam(self.Parent, "GachaAnime", {state = 1})
    self.Parent:GetGachaResultSpecialShow(self.Result, self.RebateData)
    self.WBP_VideoPlayer:Stop()
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

-- 处理应用切后台事件
function G:OnApplicationWillEnterBackground()
    DebugPrint("JLY OnApplicationWillEnterBackground")
    -- 保存当前播放状态
    if self.WBP_VideoPlayer and self.WBP_VideoPlayer:IsPlaying() then
        self.bWasPlayingBeforeBackground = true
        self.WBP_VideoPlayer:Pause()
        DebugPrint("JLY Paused video playback")
    else
        self.bWasPlayingBeforeBackground = false
    end
end

-- 处理应用切前台事件
function G:OnApplicationHasEnteredForeground()
    DebugPrint("JLY OnApplicationHasEnteredForeground")
    
    if self.bWasPlayingBeforeBackground and self.WBP_VideoPlayer then
        -- 延时重新播放，确保系统资源已恢复
        self:AddTimer(0.5, function()
            if self.WBP_VideoPlayer then
                -- 重新设置视频源并播放
                local VideoPathInd = self:GetVideoPathInd()
                if VideoPathInd then
                    local path = CommonConst[VideoPathInd]
                    local VideoObj = LoadObject(path)
                    if VideoObj then
                        self.WBP_VideoPlayer:Stop()
                        self.WBP_VideoPlayer:SetUrlByMediaSource(VideoObj)
                        self.WBP_VideoPlayer:SetLooping(false)
                        
                        -- 直接播放视频（不支持Seek）
                        self.WBP_VideoPlayer:Play()
                    end
                end
            end
        end, false, 0, "ResumeVideoPlayback")
    end
end

-- 获取视频路径的辅助函数
function G:GetVideoPathInd()
    if not self.Result then return nil end
    
    local Rarity = self:GetResultRarity()
    local PathHead = "GachaVideoMaleRarity"
    local Avatar = GWorld:GetAvatar()
    if Avatar and Avatar.Sex == CommonConst.Sex.Female then
        PathHead = "GachaVideoFemaleRarity"
    end
    local VideoPathInd = PathHead..Rarity
    local isPc = CommonUtils.GetDeviceTypeByPlatformName(self) == "PC"
    if isPc then 
        VideoPathInd = VideoPathInd .. "_PC"
    else
        VideoPathInd = VideoPathInd .. "_Mobile"
    end
    return VideoPathInd
end

-- 析构函数，清理事件监听
function G:Destruct()
    EventManager:RemoveEvent(EventID.ApplicationWillEnterBackground, self)
    EventManager:RemoveEvent(EventID.ApplicationHasEnteredForeground, self)
end

return G