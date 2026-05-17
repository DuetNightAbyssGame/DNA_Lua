--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local ReasoningUtils = require "BluePrints.UI.WBP.DetectiveMinigame.ReasoningUtils"
---@type WBP_Reasoning_Question_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:OnListItemObjectSet(Content)
    self.Content = Content
    self.Content.UI = self
    self.List_SubTask:ClearListItems()
    self.Index = Content.Index
    for index, Question in ipairs(Content.ChildrenQuestions) do
        local SubContent =  NewObject(UIUtils.GetCommonItemContentClass())
        SubContent.Question = Question
        SubContent.ParentUI = Content.ParentUI
        SubContent.Index = index
        SubContent.IsSolved = ReasoningUtils:IsQuestionSolved(Question)
        self.List_SubTask:AddItem(SubContent)
    end
    self:InitUIInfo()
    ReddotManager.AddListener("DetectiveAnswer",self,self.RefreshReddotAndSolvedUI, nil, true)
    self.IsMainQuestion = true
    if Content.Index == 0 then
        self:OnClickButton()
        self:SetFocus()
        self.BG:OnCellClicked()
    end
    if Content.ChildrenQuestions and #Content.ChildrenQuestions > 0 then
        self.Panel_Arrow:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        -- 初始状态：展开状态，Arrow角度为0度
        self:SetArrowRotation(0)
    else
        self.Panel_Arrow:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self.IsExpansion = true
    self:SetNavigationRule()
end

function M:InitUIInfo()
    local DetectiveQuestionData = DataMgr["DetectiveQuestion"][self.Content.ParentQuestion]
    self.Text_Question:SetText(GText(DetectiveQuestionData.Tips))
    if DetectiveQuestionData.QuestName then
        self.Text_Task:SetText(GText(DetectiveQuestionData.QuestName))
        self.Icon_Task:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Text_Task:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Icon_Task:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Text_Task:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self:RefreshReddotAndSolvedUI()
    self.Text_Clue:SetText(GText("Minigame_Textmap_100303"))
    self.Text_Clue_1:SetText(GText("Minigame_Textmap_100340"))
end

function M:Construct()
    self.BG.Button_Area.OnClicked:Add(self, self.OnClickButton)
    self.BG.Button_Area.OnHovered:Add(self, self.OnHoverButton)
end

function M:OnHoverButton()
    if(self.Content.ParentUI.CurInputDeviceType == ECommonInputType.Gamepad) then
        self:OnClickButton()
        self.BG:SelectCell()
        if self.List_SubTask:GetNumItems() ==0 then
            self.Content.ParentUI.Book.Controller_01:SetVisibility(ESlateVisibility.Collapsed)
        else
            self.Content.ParentUI.Book.Controller_01:SetVisibility(ESlateVisibility.Visible)
        end
        self:SetNavigationRule()
    end
end

function M:Destruct()
    ReddotManager.RemoveListener("DetectiveAnswer",self)
end

function M:OnClickButton()
    if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
        self:ExpandQuestion()
    end
    self:PlayAnimation(self.Text_Select)
    self.IsSelect = true
    if self.Content.ParentUI.CurerntQuestionId == self.Content.ParentQuestion then
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_02", nil, nil)
    self.Content.ParentUI:RefreshAnswerByQuestionId(self.Content.ParentQuestion)
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
    local CacheKey = self.Content.ParentQuestion
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("DetectiveQuestion")
    if CacheDetail and CacheDetail[CacheKey] then
        CacheDetail[CacheKey] = false
        ReddotManager.DecreaseLeafNodeCount("DetectiveQuestion")
    end
    self:RefreshReddotAndSolvedUI()
    self:StopAllAnimations()
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    local IsHandled = false

    if (InKeyName == "Gamepad_FaceButton_Left") then
        if not self.BG:HasFocusedDescendants() and not self.BG:HasAnyUserFocus() then
            return UE4.UWidgetBlueprintLibrary.Unhandled()
        end
        self:ExpandQuestion()
        IsHandled = true
    end

    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:SetArrowRotation(Angle)
    -- 直接设置Arrow的旋转角度（0度或180度）
    if self.Arrow then
        self.Arrow:SetRenderTransformAngle(Angle)
    end
end

function M:ExpandQuestion()
    if self.List_SubTask:GetNumItems() == 0 then
        return
    end
    if not self.IsExpansion then
        self.List_SubTask:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.IsExpansion = true
        -- Expansion: 从180度变成0度
        self:SetArrowRotation(0)
    else
        self.List_SubTask:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.IsExpansion = false
        -- Fold: 从0度变成180度
        self:SetArrowRotation(180)
    end
    self:SetNavigationRule()
end

function M:RefreshReddotAndSolvedUI()
    self.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_Clue:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_Reason:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if self.Content.IsSolved then
        self:StopAllAnimations()
        if self.IsSelect == false and self.Content.Index ~= 0 then
            self:PlayAnimation(self.Text_Normal)
        end
        self.Panel_Finish:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Panel_Finish:SetVisibility(UE4.ESlateVisibility.Collapsed)
        local QuestionId = self.Content.ParentQuestion

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

function M:SetNavigationRule()
    local TaskUI = self.List_SubTask:GetItemAt(0)
    local NextQuestionUI = self.Content.ParentUI.Book.List_Question:GetItemAt(self.Index + 1)
    -- 设置 BG 的 Down 导航规则
    if self.List_SubTask:GetNumItems() ~= 0 and self.IsExpansion then
        self.BG:SetNavigationRuleExplicit(EUINavigation.Down, self.List_SubTask)
        if NextQuestionUI and NextQuestionUI.UI then
            self.List_SubTask:SetNavigationRuleExplicit(EUINavigation.Down, NextQuestionUI.UI.BG)
        else
            self.List_SubTask:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
        end
    else
        if NextQuestionUI and NextQuestionUI.UI then
            self.BG:SetNavigationRuleExplicit(EUINavigation.Down, NextQuestionUI.UI.BG)
        else
            self.BG:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
        end
    end
    
    -- 设置 List_SubTask 的 Up 导航规则
    local PrevQuestionUI = self.Content.ParentUI.Book.List_Question:GetItemAt(self.Index - 1)
    if PrevQuestionUI then
        local FocusItem = nil
        if PrevQuestionUI.UI.IsExpansion then
            -- 如果上一个 Question 展开，导航到上一个 Question 的 List_SubTask 的最后一个子项
            local Num = PrevQuestionUI.UI.List_SubTask:GetNumItems()
            if Num > 0 then
                local LastSubTask = PrevQuestionUI.UI.List_SubTask:GetItemAt(Num - 1)
                if LastSubTask and LastSubTask.UI then
                    FocusItem = LastSubTask.UI.BG
                end
            end
            if FocusItem then
                self.BG:SetNavigationRuleExplicit(EUINavigation.Up, FocusItem)
            else
                self.BG:SetNavigationRuleExplicit(EUINavigation.Up, PrevQuestionUI.UI.BG)
            end
        else
            -- 否则导航到上一个 Question 的 BG
            self.BG:SetNavigationRuleExplicit(EUINavigation.Up, PrevQuestionUI.UI.BG)
        end
    else
        -- 如果没有上一个 Question，导航到当前 Question 的 BG
        self.BG:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    end
end

return M
