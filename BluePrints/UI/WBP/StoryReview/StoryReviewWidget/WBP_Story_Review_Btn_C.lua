--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Story_Review_Btn_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

--function M:Initialize(Initializer)
--end

function M:Construct()
    self.BtnState = ""
    self:BindToAnimationFinished(self.Press_Fold, {self, self.PlayHoverAnimation})
end

function M:Destruct()
    self.OthersItem = nil
    self:PauseTalkAudio()
end

function M:PlaySoundWithTalk(AudioManager, VoiceName, ExStoryInfo, SnapShot)
    local AttachedActor = UE4.UGameplayStatics.GetPlayerController(AudioManager, 0)

    local RealEventPath, SelectKey = AudioManager:GetEventData(VoiceName, ExStoryInfo)
    local PlayStruct = FPlayFMODSoundStruct()
    PlayStruct.FMODEvent = AudioManager:GetFMODEventByPath_Sync(RealEventPath)
    PlayStruct.EventKey = Const.ReviewSoundKey
    PlayStruct.bStopWhenAttachedToDestoryed = true
    PlayStruct.bPlayAs2D = true
    PlayStruct.SelectKey = SelectKey
    PlayStruct.DynamicSoundStop = {GWorld.GameInstance ,function()
        self.AudioState = "Stop"
        self:StopAnimation(self.Click_Sound_Loop)
        self:PlayAnimation(self.Normal_Sound)
    end}
    PlayStruct = UE4.UAudioManager.SetObjectToFPlayFMODSoundStruct(PlayStruct, AttachedActor)
    local SoundEventInstance = AudioManager:PlayFMODSound_Sync(PlayStruct)

    if SnapShot then
        AudioManager:SetEventSoundParam(nil, Const.DialogueEffectSoundKey, {voice_effect_type = Const.DialogueSnapShot[SnapShot]})
    else
        AudioManager:SetEventSoundParam(nil, Const.DialogueEffectSoundKey, {voice_effect_type = 0})
    end

    return SoundEventInstance
end

function M:InitVoiceBtn(DialogueId)
    self.DialogueId = DialogueId
    self.AudioState = "Stop"
    self.BtnState = "Audio"
    self:PlayAnimation(self.Normal_Sound)
    self.Button_Talk.OnClicked:Add(self, self.PlayTalkSound)
    self.Button_Talk.OnHovered:Add(self, function()
        self:PlayAnimation(self.Hover_Sound, 0, 0, 0, 1, true)
    end)
    self.Button_Talk.OnUnhovered:Add(self, function()
        self:StopAnimation(self.Hover_Sound)
        self:PlayAnimation(self.UnHover_Sound)
    end)
    self.Button_Talk.OnPressed:Add(self, function()
        self:PlayAnimation(self.Press_Sound)
    end)
end

function M:InitOptionBtn(TalkWidget, ParentWidget)
    self.IsShowList = false
    self.TalkWidget = TalkWidget
    self.ParentWidget = ParentWidget
    self.BtnState = "Option"
    self:PlayAnimation(self.Normal_Fold)
    self.Button_Talk.OnClicked:Add(self, self.ShowOptionList)
    self.Button_Talk.OnHovered:Add(self, function()
        self.PlayHover = true
        self:PlayAnimation(self.Hover_Fold, 0, 0, 0, 1, true)
    end)
    self.Button_Talk.OnUnhovered:Add(self, function()
        self.PlayHover = false
        self:StopAnimation(self.Hover_Fold)
        self:PlayAnimation(self.UnHover_Fold)
    end)
    self.Button_Talk.OnPressed:Add(self, function()
        self:PlayAnimation(self.Press_Fold)
    end)
end

function M:PlayHoverAnimation()
    if self.PlayHover then
        self:PlayAnimation(self.Hover_Fold, 0, 0, 0, 1, true)
    end
end

function M:ShowOptionList()
    if self.IsShowList then
        self.IsShowList = false
        self:PlayAnimation(self.ArrowFlip, 0, 1, UE4.EUMGSequencePlayMode.Reverse)
        self.TalkWidget:RemoveOtherOptions()
    else
        self.IsShowList = true
        self:PlayAnimation(self.ArrowFlip)
        self.TalkWidget:ListOtherOptions()
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
end

function M:PlayTalkSound()
    if self.AudioState == "IsPlaying" then
        self:PauseTalkAudio()
    elseif self.AudioState == "Stop" then
        self:PlayTalkAudio()
    end
    self:PlayAnimation(self.Click_Sound)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
end

function M:PauseTalkAudio()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
    AudioManager(self):StopSound(PlayerController, Const.ReviewSoundKey)
    self.AudioState = "Stop"
    self:StopAnimation(self.Click_Sound_Loop)
    self:PlayAnimation(self.Normal_Sound)
end

function M:PlayTalkAudio()
    self.AudioState = "IsPlaying"
    local DialogueConfig = DataMgr.Dialogue[self.DialogueId]
    local AudioInstance = self:PlaySoundWithTalk(AudioManager(self), DialogueConfig.VoiceName, DialogueConfig.ExStoryInfo, DialogueConfig.SnapShot)
    self:PlayAnimation(self.Click_Sound_Loop, 0, 0, 0, 1, true)
end

function M:InvokeClick()
    if not self:IsVisible() then
        return
    end
    if self.BtnState == "Audio" then
        self:PlayTalkSound()
    else
        if not self.IsShowList then
            self.ParentWidget:ScrollToEnd()
        end
        self:ShowOptionList()
    end
end

return M
