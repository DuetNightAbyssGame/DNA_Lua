--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local ReasoningUtils = require "BluePrints.UI.WBP.DetectiveMinigame.ReasoningUtils"
---@type WBP_Reasoning_SubQuestion_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:OnListItemObjectSet(Content)
    self.Content = Content
    self.Content.UI = self
    self:InitUIInfo()
    ReddotManager.AddListener("DetectiveAnswer",self,self.RefreshReddotAndSolvedUI)
end

function M:InitUIInfo()
    local DetectiveQuestionData = DataMgr["DetectiveQuestion"][self.Content.Question]
    self.Text_Question:SetText(GText(DetectiveQuestionData.Tips))
    self.Text_Num:SetText(string.format(GText("Minigame_Textmap_100336"), Const.IndexNum[self.Content.Index]))
    self:RefreshReddotAndSolvedUI()
    self:PlaySelectAnimation()

    self:RefreshProgress()
    self.Text_Clue:SetText(GText("Minigame_Textmap_100303"))
    self.Text_Clue_1:SetText(GText("Minigame_Textmap_100340"))
end

function M:RefreshProgress()
    local currentClueCount, totalClueCount = ReasoningUtils:GetQuestionClueCount(self.Content.Question)
    self.Text_Progress:SetText(string.format("%d/%d", currentClueCount, totalClueCount))
end

function M:Construct()
    self.BG.Button_Area.OnClicked:Add(self, self.OnClickButton)
    self.BG.Button_Area.OnHovered:Add(self, self.OnHoverButton)
    EventManager:AddEvent(EventID.OnDetectiveRefreshProgress, self, self.RefreshProgress)
end

function M:Destruct()
    ReddotManager.RemoveListener("DetectiveAnswer",self)
    EventManager:RemoveEvent(EventID.OnDetectiveRefreshProgress, self)
end

function M:OnHoverButton()
    if(self.Content.ParentUI.CurInputDeviceType == ECommonInputType.Gamepad) then
        self:OnClickButton()
        self.BG:SelectCell()
        self.Content.ParentUI.Book.Controller_01:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:OnClickButton()
    if self.Content.ParentUI.CurerntQuestionId == self.Content.Question then
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
    self.Content.ParentUI:RefreshAnswerByQuestionId(self.Content.Question, self.Content.Index)
    self.Content.ParentUI:SetPanelGuideText(-1, false, false)
    local CurrentSelectQuestionUI = self.Content.ParentUI.CurrentSelectQuestionUI
    if CurrentSelectQuestionUI and CurrentSelectQuestionUI ~= self then
        CurrentSelectQuestionUI.BG:OnCellUnSelect()
        CurrentSelectQuestionUI:StopAllAnimations()
        CurrentSelectQuestionUI.IsSelect = false
        if CurrentSelectQuestionUI.Content.IsSolved and CurrentSelectQuestionUI.IsMainQuestion ~= true then
            CurrentSelectQuestionUI:PlayAnimation(CurrentSelectQuestionUI.Text_Forbidden)
        else
            CurrentSelectQuestionUI:PlayAnimation(CurrentSelectQuestionUI.Text_Normal)
        end
    end
    self.Content.ParentUI.CurrentSelectQuestionUI = self
    local CacheKey = self.Content.Question
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("DetectiveQuestion")
    if CacheDetail and CacheDetail[CacheKey] then
        CacheDetail[CacheKey] = false
        ReddotManager.DecreaseLeafNodeCount("DetectiveQuestion")
    end
    self.IsSelect = true
    self:RefreshReddotAndSolvedUI()
    self:PlaySelectAnimation()
end

function M:PlaySelectAnimation()
    if self.IsSelect then
        self:StopAllAnimations()
        self:PlayAnimation(self.Text_Select)
    end
    if self.Content.IsSolved then
        if not self.IsSelect then
            self:StopAllAnimations()
            self:PlayAnimation(self.Text_Forbidden)
        end
    end
end

function M:RefreshReddotAndSolvedUI()
    self.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_Clue:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_Reason:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self:RefreshProgress()
    if self.Content.IsSolved then
        self.WS_Type:SetActiveWidgetIndex(1)
    else
        self.WS_Type:SetActiveWidgetIndex(0)

        local QuestionId = self.Content.Question
        local IsReasoningState = ReasoningUtils:IsQuestionReasoningState(QuestionId)
        local Result = ReasoningUtils:IsHasNewQuestionOrClue(QuestionId)
        local IsNewQuestion = Result == 1
        local IsNewClue = Result == 2
        if IsNewClue then
            self.Panel_Clue:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        elseif IsNewQuestion then
            self.New:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        elseif IsReasoningState then
            self.Panel_Reason:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
    end
end

return M
