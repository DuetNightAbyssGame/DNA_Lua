require "UnLua"
require "DataMgr"

local WBP_Piano_MusicItem = Class("BluePrints.UI.BP_UIState_C")

function WBP_Piano_MusicItem:Destruct()
    self.Button_Music.OnClicked:Remove(self, self.OnBtnClicked)
    self.Button_Music.OnHovered:Remove(self, self.OnBtnHovered)
    self.Button_Music.OnUnHovered:Remove(self, self.OnBtnUnHovered)
    WBP_Piano_MusicItem.Super.Destruct(self)
end

-- 初始化
function WBP_Piano_MusicItem:OnListItemObjectSet(ListItemObject)
    self:PlayAnimation(self.Normal)
    self:PlayAnimation(self.In)
    self.DataObject = ListItemObject
    self.ParentUI = ListItemObject.Owner
    self.MusicId = ListItemObject.MusicId
    self.IsLocked = ListItemObject.bIsLocked
    self.ListViewIndex = ListItemObject.Index
    self.NeedReddot = ListItemObject.NeedReddot
    self.IsSelected = false
    self.IsPlaying = false
    self.IsStoredCustomBGMMusicScore = false
    self.EventInstance = nil
    self.UpdateProgressTimer = nil
    self.ScrollTimer = nil
    self.TextLength = nil
    -- self.ParentSlotLength = self.VB_Main:GetDesiredSize().X
    self:InitUI()
    self:AddDispatcher(EventID.ChangePlayedMusicItem, self, self.OnPlayedMusicItemChanged)
    self:AddDispatcher(EventID.ChangeStoredCustomBGM, self, self.OnStoredCustomBGMChanged)
    -- 用于初始化不播声音的锁定
    self.bIsOnListItemSet = true
    if self.MusicId == self.ParentUI.Cur_PlayMusicId then
        self:OnBtnClicked()
    end
    if self.MusicId == self.ParentUI.CurrentHomeBaseBGM then
        self:IsStoredBGMMusic()
    end
    self.bIsOnListItemSet = false
    if not self.IsPlaying then
        self.WS_Icon:SetActiveWidgetIndex(0)
    end
end

-- region Reddot
--endregion

-- 初始化UI数据
function WBP_Piano_MusicItem:InitUI()
    local MusicInfo = DataMgr.Music[self.MusicId]
    self.Text_Name:SetText(GText(MusicInfo.MusicName))
    self.Icon_Music:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    if self.IsLocked then
        self.Hb_Time:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Panel_Bar:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self:StopAllAnimations()
        self.Button_Music:SetForbidden(true)
        self:PlayAnimation(self.Forbidden)
    else
        self.Hb_Time:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Panel_Bar:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Button_Music:SetForbidden(false)
        self.SoundEventPath = MusicInfo.Event
        self.EventLength = AudioManager(self):GetEventLengthByPath(self.SoundEventPath)
        local EventLength_Second = math.floor(self.EventLength/1000)
        local Event_Minute = math.floor(EventLength_Second/60)
        local Event_Second = EventLength_Second%60
        local TotalTimeStr = string.format("%02d:%02d", Event_Minute, Event_Second)
        self.Text_Total_Time:SetText(TotalTimeStr)
        self.Text_Time:SetText("00:00")
        self.Bar_Time:SetPercent(0)
    end
    -- Reddot
    if self.NeedReddot then
        self.New:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self.New:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
    self.Button_Music.OnClicked:Add(self, self.OnBtnClicked)
    self.Button_Music.OnHovered:Add(self, self.OnBtnHovered)
    self.Button_Music.OnUnHovered:Add(self, self.OnBtnUnHovered)
end

function WBP_Piano_MusicItem:OnBtnClicked()
    if self.IsPlaying then
        return
    end
    self.ParentUI:ChangeCurrentPlayedMusicItem(self.ListViewIndex)
    if not self.bIsOnListItemSet then
        AudioManager(self):PlayUISound(self, "event:/ui/armory/click_crystal_btn_content", nil, nil)
    end
end

function WBP_Piano_MusicItem:OnBtnHovered()
    self:PlayScrollAnim()
    self.ParentUI:UpdateMusicItemTextShow(self.ListViewIndex)
    if self.IsSelected then
        return
    end
    if self.NeedReddot then
        EventManager:FireEvent(EventID.ChangeMusicItemNewState, self.MusicId)
        self.NeedReddot = false
        self.New:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
    self:PlayAnimation(self.Hover)
end

function WBP_Piano_MusicItem:OnBtnUnHovered()
    self:StopScrollAnim()
    if self.IsSelected then
        return
    end
    self:PlayAnimation(self.Unhover)
end

function WBP_Piano_MusicItem:PlayScrollAnim()
    if not self.TextLength then
        self.TextLength = self.Text_Name:GetDesiredSize().X*-1
    end
    self.ScrollTimer = self:AddTimer(0.02, self.ScrollMusicName, true, 0, "Scroll", true)
end

function WBP_Piano_MusicItem:StopScrollAnim()
    if self.ScrollTimer then
        self:RemoveTimer(self.ScrollTimer)
    end
    self.ScrollTimer = nil
    self.TextLength = nil
    self.Text_Name:SetRenderTranslation(FVector2D(0,0))
end

function WBP_Piano_MusicItem:ScrollMusicName()
    local NewTrans = self.Text_Name.RenderTransform.Translation
    if NewTrans.X < self.TextLength then
        -- NewTrans.X = self.ParentSlotLength
        NewTrans.X = 355
    else
        NewTrans.X = NewTrans.X-1
    end
    self.Text_Name:SetRenderTranslation(NewTrans)
end

-- 只用于记录是否正处于选择状态
function WBP_Piano_MusicItem:Selected()
    if self.IsSelected then
        return
    end
    self.IsSelected = true
end

function WBP_Piano_MusicItem:Deselected()
    if not self.IsSelected then
        return
    end
    self.IsSelected = false
    self:PlayAnimation(self.Unhover)
end

-- 触发播放|停止，非最后的播放|停止
function WBP_Piano_MusicItem:OnPlayedMusicItemChanged(NewMusicId)
    if NewMusicId==self.MusicId then
        self:Selected()
        self:TryPlayPianoBGM()
    else
        self:Deselected()
        self:TryStopPianoBGM()
    end
end

function WBP_Piano_MusicItem:TryPlayPianoBGM()
    if self.IsLocked or self.IsPlaying then
        return
    end
    self.IsPlaying = true
    if self.MusicId then
        self.ParentUI.Cur_PlayMusicId = self.MusicId
    end
    self:RealPlayPianoBGM()
end

function WBP_Piano_MusicItem:RealPlayPianoBGM()
    AudioManager(self):PlayPianoSystemBGM(self.SoundEventPath)
    self.EventInstance = AudioManager(self):GetPlayingFMODEventInstance(nil, "BGMKey_0")
    self.UpdateProgressTimer = self:AddTimer(0.1, self.UpdateProgressBar, true, 0, "BGM", true)
    self.WS_Icon:SetActiveWidgetIndex(1)
    self:StopAllAnimations()
    self:PlayAnimation(self.Select)
end

function WBP_Piano_MusicItem:TryStopPianoBGM()
    if self.IsLocked or not self.IsPlaying then
        return
    end
    self.IsPlaying = false
    self:RealStopPianoBGM()
end

-- 不会真的停，钢琴系统一定有BGM在播放，只是改变了UI状态
function WBP_Piano_MusicItem:RealStopPianoBGM()
    if self.UpdateProgressTimer then
        self:RemoveTimer(self.UpdateProgressTimer)
    end
    self.Text_Time:SetText("00:00")
    self.Bar_Time:SetPercent(0)
    self.WS_Icon:SetActiveWidgetIndex(0)
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
end

function WBP_Piano_MusicItem:UpdateProgressBar()
    if not self.EventInstance then
        self:TryStopPianoBGM()
        return
    end
    -- ms
    local EventInstancePos = AudioManager(self):GetEventInstanceTimelinePosition(self.EventInstance)
    self.Bar_Time:SetPercent(EventInstancePos/self.EventLength)
    local EventPos_Second = math.floor(EventInstancePos/1000)
    local Event_Minute = math.floor(EventPos_Second/60)
    local Event_Second = EventPos_Second%60
    local TotalTimeStr = string.format("%02d:%02d", Event_Minute, Event_Second)
    self.Text_Time:SetText(TotalTimeStr)
end

function WBP_Piano_MusicItem:OnStoredCustomBGMChanged(NewMusicId)
    if NewMusicId==self.MusicId then
        self:IsStoredBGMMusic()
    else
        self:IsNotStoredBGMMusic()
    end
end

function WBP_Piano_MusicItem:IsStoredBGMMusic()
    if self.IsStoredCustomBGMMusicScore then
        return
    end
    self.IsStoredCustomBGMMusicScore = true
    self.Icon_Music:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
end

function WBP_Piano_MusicItem:IsNotStoredBGMMusic()
    if not self.IsStoredCustomBGMMusicScore then
        return
    end
    self.IsStoredCustomBGMMusicScore = false
    self.Icon_Music:SetVisibility(UIConst.VisibilityOp["Collapsed"])
end

return WBP_Piano_MusicItem