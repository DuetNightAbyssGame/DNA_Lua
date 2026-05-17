local WBP_Guide_ChapterBegin_C = Class("BluePrints.UI.BP_UIState_C")


function WBP_Guide_ChapterBegin_C:Construct()
    WBP_Guide_ChapterBegin_C.Super.Construct(self)
    EventManager:AddEvent(EventID.OnLevelDeliverBlackCurtainStart, self, self.OnTipRealEnd)
    EventManager:AddEvent(EventID.InLoading, self, self.OnTipRealEnd)
    EventManager:AddEvent(EventID.CloseLoading, self, self.OnCloseLoading)
end

function WBP_Guide_ChapterBegin_C:OnLoaded(...)
    local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
	if not BattleMainUI then
		return
	end
	if BattleMainUI then
		BattleMainUI.Pos_Chapter:AddChildToOverlay(self)
        BattleMainUI:SetSubSystemVisibility("Pos_Chapter", ESlateVisibility.SelfHitTestInvisible)
        self.IsInit = true
    end
    local QuestChainId, QuestId, IsBegin = ...
    local TS = TalkSubsystem()
    local IsInTalk = false
    if TS and TS:IsInImmersiveStory() then
        IsInTalk = true
    end

    self.QuestChainId = QuestChainId
    self.QuestId = QuestId
    self.Duration = 2.0
    -- 初始化失败，则直接返回
    -- if not self:OnTipBegin() then
    --     --self:HideAllUIWithOutSelf(false, "QuestChapterBeginEnd")
    --     return
    -- end
    self.VX_Bg_Glow_1:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    local QuestChainInfo = DataMgr.QuestChain[QuestChainId]
    if QuestChainInfo ~= nil then 
        self.Text_QuestName:SetText(self:GetTaskInfoString(QuestChainInfo.QuestChainName))
        local ChapterName = QuestChainInfo.ChapterName or ""
        local ChapterNumber = QuestChainInfo.ChapterNumber or ""
        local EpisodeName = QuestChainInfo.Episode or ""
        if QuestChainInfo.ChapterBeginEndIconPath ~= nil then
            local IconImageObj = LoadObject(QuestChainInfo.ChapterBeginEndIconPath)
            if IconImageObj then
                self.Icon:GetDynamicMaterial():SetTextureParameterValue("IconTex", IconImageObj)
            end
        end
       
        self.Text_MissionType:SetText(GText(ChapterName))
        self.Text_MissionType01:SetText(GText(ChapterNumber))
        self.Text_MissionType02:SetText(GText(EpisodeName))
    else 
        self.Text_QuestName:SetText("UI_QUEST_UNKNOW")
    end
    self.IsBegin = IsBegin
    if IsBegin then
        self.Text_Start:SetText(GText("UI_QUEST_START"))
        self.Task_State:SetActiveWidgetIndex(0)
    else
        self.Text_Success:SetText(GText("UI_QUEST_SUCCESS"))
        self.Task_State:SetActiveWidgetIndex(1)
    end
    self:PlayAnimation(self.In)
    local InTime = self.In:GetEndTime() 
    local OutTime = self.Out:GetEndTime()
    local TotalTime = InTime + OutTime
    self:AddTimer(InTime, function()
        self:PlayAnimation(self.Out)
    end, false, 0, "PlayOut", true)
    self:AddTimer(TotalTime,  self.OnTipRealEnd, false, 0, "TryToClose", true)
    if self:IsHide() or BattleMainUI:GetVisibility() == UE4.ESlateVisibility.Collapsed then
        self:PauseTimer("TryToClose")
        self:PauseTimer("PlayOut")
    end
    --收不到show的情况
    self:AddTimer(0.3, function()
        if BattleMainUI:GetVisibility() == UE4.ESlateVisibility.SelfHitTestInvisible then
            self:UnPauseTimer("TryToClose")
            self:UnPauseTimer("PlayOut")
            self:RemoveTimer("CheckBattleMain")
        end
    end, true, 0, "CheckBattleMain")
end

function WBP_Guide_ChapterBegin_C:GetTaskInfoString(TaskText)
    return GText(TaskText)
end

function WBP_Guide_ChapterBegin_C:OnClose()
    self:OnTipRealEnd()
end

function WBP_Guide_ChapterBegin_C:OnCloseLoading()
    self:OnTipEnd()
end

function WBP_Guide_ChapterBegin_C:OnTipBegin()
    if self.In then
        self:UnbindAllFromAnimationFinished(self.In)
        self:BindToAnimationFinished(self.In, {self, self.OnTipEnd})
        self:PlayAnimation(self.In)
    end

    return true
end

function WBP_Guide_ChapterBegin_C:PlayInAudio()
    AudioManager(self):PlayUISound(self, "event:/ui/common/mission_start_in", nil, nil)
end

function WBP_Guide_ChapterBegin_C:Hide(HideTag)
	WBP_Guide_ChapterBegin_C.Super.Hide(self, HideTag)
	self:PauseTimer("TryToClose")
    self:PauseTimer("PlayOut")
end

function WBP_Guide_ChapterBegin_C:Show(ShowTag)
    WBP_Guide_ChapterBegin_C.Super.Show(self, ShowTag)
    local IsHide = not IsEmptyTable(self.HideTags)
    if (not IsHide) then
        self:UnPauseTimer("TryToClose")
        self:UnPauseTimer("PlayOut")
    end
end

function WBP_Guide_ChapterBegin_C:OnTipEnd()
    -- self:AddTimer(self.Duration, function ()
    --     if self.Out then
    --         self:UnbindAllFromAnimationFinished(self.Out)
    --         self:BindToAnimationFinished(self.Out, {self, self.OnTipRealEnd})
    --         DebugPrint("LHQ@@@Chapter OnTipEnd")
    --         self:PlayAnimation(self.Out)
    --     else
    --         self:OnTipRealEnd()
    --     end
    -- end)

    if self.Out then
            self:UnbindAllFromAnimationFinished(self.Out)
            self:BindToAnimationFinished(self.Out, {self, self.OnTipRealEnd})
            self:PlayAnimation(self.Out)
    else
        self:OnTipRealEnd()
    end
end

function WBP_Guide_ChapterBegin_C:PlayOutAudio()
    AudioManager(self):PlayUISound(self, "event:/ui/common/mission_start_out", nil, nil)
end

function WBP_Guide_ChapterBegin_C:OnTipRealEnd()
    local UIManager = UE4.UGameplayStatics.GetGameInstance(self):GetGameUIManager()
    if UIManager ~= nil then
        local BattleMainUI = UIManager:GetUIObj("BattleMain")
        if BattleMainUI then
            BattleMainUI.Pos_TaskBar:GetChildAt(0):OnTipEndPlayTaskBarAnim(self.QuestChainId, self.QuestId, self.IsBegin)
        end

    end
    self.IsDestroied = true
    self:Close()
end

function WBP_Guide_ChapterBegin_C:Destruct()
    EventManager:RemoveEvent(EventID.OnLevelDeliverBlackCurtainStart, self)
    EventManager:RemoveEvent(EventID.InLoading, self)
    EventManager:RemoveEvent(EventID.CloseLoading, self)
    self:RemoveTimer("TryToClose")
    self:RemoveTimer("PlayOut")
    self:RemoveTimer("CheckBattleMain")
    self.Super.Destruct(self)
end


return WBP_Guide_ChapterBegin_C