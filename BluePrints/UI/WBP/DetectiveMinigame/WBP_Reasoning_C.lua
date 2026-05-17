--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local CommonUtils = require "Utils.CommonUtils"

---@type WBP_Reasoning_M_C
local M = Class("BluePrints.UI.BP_UIState_C")
M._components = {
    "BluePrints.UI.WBP.DetectiveMinigame.WBP_Reasoning_C_GamepadComp"
}
local ReasoningUtils = require "BluePrints.UI.WBP.DetectiveMinigame.ReasoningUtils"

-- 查看线索是指还没有联想完，可以进入到联想线索状态，如果都联想完了就直接进入提交线索状态
local EReasoningState = {
    -- 查看线索详情
    SeeAnswerDetail = 1,
    -- 提交线索
    CommitAnswer = 2,
    -- 联想线索
    InferAnswer = 3,
    -- 提交完成
    CommitAnswerFinish = 4,
}

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "DetectiveOpen", nil)
    self.TabNewAnswerId, self.TabNewQuestionId, self.IsInDialogue = ...
    self.InputInit = false
    local Material = self.Img_Animation01:GetDynamicMaterial()
    Material:SetScalarParameterValue("XNum", 1.0)
    Material:SetScalarParameterValue("YNum", 7.0)
    self.NeededAnswerCount = 0
    self.UnlockedNeededAnswerCount = 0
    self.CurrentSelectedAnswers = {}
    self.Avatar = GWorld:GetAvatar()
    self:BindEvents()
    self:InitComTab()
    self.Panel_Guide:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if not ReddotManager.GetTreeNode("DetectiveAnswer") then
		ReddotManager.AddNode("DetectiveAnswer")
	end
    if self.Avatar then
        self:InitQuestion()
        self:InitSortedAnswers()
        self:InitAnswers()
        self:ClearClueWidgetsAnimations()
    end
    self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
    self.InferOrCommitFailTimes = 0
    self:RefreshButtonUI()
    self:InitGamePadUI()
    self:SetPanelGuideText(-1, false, false, true)
    self.AutoClose = false
    -- 清空自动传进来的ID
    self.TabNewAnswerId, self.TabNewQuestionId = nil, nil
end

function M:BindEvents()
    self.Btn_Associate.Btn_Click.OnClicked:Add(self, self.OnClickButtonAssociate)
    self.Btn_Close.OnClicked:Add(self, self.OnClickCloseButton)
    ReddotManager.AddListener("DetectiveAnswer",self,self.RefreshReddot)
end

function M:Construct()
    self.ClueWidgets = {self.Clue_01, self.Clue_02, self.Clue_03, self.Clue_04, self.Clue_05, self.Clue_06}
    self.Tab:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_Num:SetVisibility(UE4.ESlateVisibility.Collapsed)
    AudioManager(self):PlaySystemUIBGM("event:/bgm/cbt03/0072_story_reasoning",nil,"Reasoning")
    for _, clueWidget in ipairs(self.ClueWidgets) do
        clueWidget:PlayAnimation(clueWidget.Normal)
    end
end

function M:Destruct()
    self:UnbindEvents()
    ReddotManager.RemoveListener("DetectiveAnswer",self)
    M.Super.Destruct(self)
end

function M:UnbindEvents()
    self.Btn_Associate.Btn_Click.OnClicked:Remove(self, self.OnClickButtonAssociate)
end

function M:Close()
    self.Super.Close(self)
    if self.Book.IsClueUi then
        self:PlayAnimation(self.Guide_Out)
    end
    AudioManager(self):SetEventSoundParam(self, "DetectiveOpen", {ToEnd = 1})
    AudioManager(self):StopSystemUIBGM("Reasoning")
    if self.AutoClose then
        local TaskPanel = UIManager(self):GetUIObj("TaskPanel")
        if TaskPanel then
            TaskPanel.AutoClose = true
        end
    end
end

-- 绑定关闭回调（可绑定多个）
function M:AddCloseCallback(Obj, Callback)
    if not Callback then
        return
    end
    self.CloseCallbacks = self.CloseCallbacks or {}
    table.insert(self.CloseCallbacks, {Obj = Obj, Callback = Callback})
end

function M:RealClose(...)
    DebugPrint("JLY: ReasoningUI: RealClose")
    self.Super.RealClose(self, ...)
    if self.CloseCallbacks then
        for _, Info in ipairs(self.CloseCallbacks) do
            DebugPrint("JLY: ReasoningUI: RealClose Info", Info.Obj, Info.Callback)
            if Info.Callback then
                if Info.Obj then
                    Info.Callback(Info.Obj, self)
                else
                    Info.Callback(self)
                end
            end
        end
        self.CloseCallbacks = nil
    end
end

function M:InitQuestion()
    self.DetectiveGameCurrentQuestions = self.Avatar.DetectiveGameUnlockedQuestions
    self.Index = 1
    -- 增加保底，如果自动打开界面的时候传进了问题或者线索ID，这时候弱网没有正确获得Questions信息，那么就要把自动传进来的ID加进列表
    local needAddQuestionId = self.TabNewQuestionId
    if self.TabNewAnswerId and self.TabNewAnswerId ~= 0 then
        local DetectiveAnswerData = DataMgr["DetectiveAnswer"][self.TabNewAnswerId]
        if DetectiveAnswerData then
            needAddQuestionId = DetectiveAnswerData.QuestionID
            self.CurerntQuestionId = needAddQuestionId
        end
    end
    if needAddQuestionId and self.DetectiveGameCurrentQuestions[needAddQuestionId] == nil then
        self.DetectiveGameCurrentQuestions[needAddQuestionId] = 1
        -- 如果添加的问题是子问题，那么要看父问题是否已经解锁，如果父问题没有解锁，那么也要解锁父问题
        local DetectiveQuestionData = DataMgr["DetectiveQuestion"][needAddQuestionId]
        if DetectiveQuestionData and DetectiveQuestionData.ParentQuestionID and DetectiveQuestionData.ParentQuestionID ~= 0 then
            if self.DetectiveGameCurrentQuestions[DetectiveQuestionData.ParentQuestionID] == nil then
                self.DetectiveGameCurrentQuestions[DetectiveQuestionData.ParentQuestionID] = 1
            end
        end
    end

    -- 构建父子关系表
    local parentQuestions = {}
    local childToParentMap = {}
    -- 遍历所有解锁的问题
    for questionId, _ in pairs(self.DetectiveGameCurrentQuestions) do
        local questionData = DataMgr["DetectiveQuestion"][questionId]
        if questionData then
            local parentId = questionData.ParentQuestionID
            if not parentId or parentId == 0 then
                -- 这是一个父问题
                if not parentQuestions[questionId] then
                    parentQuestions[questionId] = {
                        id = questionId,
                        children = {}
                    }
                end
            else
                -- 这是一个子问题
                childToParentMap[questionId] = parentId
                -- 确保父问题存在于表中
                if not parentQuestions[parentId] then
                    parentQuestions[parentId] = {
                        id = parentId,
                        children = {}
                    }
                end
                -- 将子问题添加到父问题的children表中
                table.insert(parentQuestions[parentId].children, questionId)
            end
        end
    end
    
    -- 对每个父问题的子问题列表进行排序：未解决的在前，已解决的在后
    for parentId, parentQuestion in pairs(parentQuestions) do
        if parentQuestion.children and #parentQuestion.children > 0 then
            table.sort(parentQuestion.children, function(a, b)
                local aSolved = ReasoningUtils:IsQuestionSolved(a)
                local bSolved = ReasoningUtils:IsQuestionSolved(b)
                -- 如果解决状态不同，未解决的排在前面
                if aSolved ~= bSolved then
                    return not aSolved and bSolved
                end
                -- 如果解决状态相同，保持原有的相对顺序（按ID排序）
                return a < b
            end)
        end
    end

    -- 将字典转换为数组以便排序
    local parentQuestionsArray = {}
    for parentId, parentQuestion in pairs(parentQuestions) do
        table.insert(parentQuestionsArray, parentQuestion)
    end
    
    -- 排序父问题数组，未解决的在前，已解决的在后
    table.sort(parentQuestionsArray, function(a, b)
        local aSolved = ReasoningUtils:IsQuestionSolved(a.id)
        local bSolved = ReasoningUtils:IsQuestionSolved(b.id)
        -- 如果解决状态不同，未解决的排在前面
        if aSolved ~= bSolved then
            return not aSolved and bSolved
        end
        -- 如果解决状态相同，保持原有的相对顺序（按ID排序）
        return a.id < b.id
    end)
    
    -- 保存父子关系表（字典结构）和排序后的数组以供后续使用
    self.ParentQuestions = parentQuestions
    self.ParentQuestionsArray = parentQuestionsArray
    self.ChildToParentMap = childToParentMap
    -- 找到第一个父问题（从排序后的数组中获取）
    local firstParentId = nil
    if #parentQuestionsArray > 0 then
        firstParentId = parentQuestionsArray[1].id
    end
    -- 设置当前问题ID为第一个父问题
    DebugPrint("InitQuestion: ", self.CurerntQuestionId)
    if self.CurerntQuestionId == 0 then
        self.Text_Title:SetText(GText("Minigame_Textmap_100301"))
    end
    self.Book:InitUIInfo(self.ParentQuestionsArray, self, self.TabNewAnswerId, self.TabNewQuestionId)
end

function M:InitSortedAnswers()
    local DetectiveQuestionData = DataMgr["DetectiveQuestion"][self.CurerntQuestionId]
    if DetectiveQuestionData then
        local Tips = DetectiveQuestionData.Tips
        self.Text_Title:SetText(GText(Tips))
        local ProbablyNeededAnswers = DetectiveQuestionData.ProbablyNeededAnswers
        self.NeededAnswers = {}
        if ProbablyNeededAnswers then
            for _, Answer in pairs(ProbablyNeededAnswers) do
                self.NeededAnswers[Answer] = false
                self.NeededAnswerCount = self.NeededAnswerCount + 1
            end
        end
    end
    self.CurrentUnlockedAnswers = {}
    local UnlockedAnswers = self.Avatar.DetectiveGameUnlockedAnswers
    -- 增加保底，如果自动打开界面的时候传进了线索ID，这时候弱网没有正确获得Answers信息，那么就要把自动传进来的ID加进列表
    if self.TabNewAnswerId and self.TabNewAnswerId ~= 0 then
        if UnlockedAnswers[self.TabNewAnswerId] == nil then
            UnlockedAnswers[self.TabNewAnswerId] = 1
        end
    end
    for AnswerId, Timestamp in pairs(UnlockedAnswers) do
        if self.NeededAnswers then
            if self.NeededAnswers[AnswerId] ~= nil then
                table.insert(self.CurrentUnlockedAnswers, AnswerId)
                if self.NeededAnswers[AnswerId] == false then
                    self.NeededAnswers[AnswerId] = true
                    self.UnlockedNeededAnswerCount = self.UnlockedNeededAnswerCount + 1
                end
            end
        end
        DebugPrint("AnswerId, Timestamp", AnswerId, Timestamp)
    end
    table.sort(self.CurrentUnlockedAnswers,  function(a, b)
        return UnlockedAnswers[a] < UnlockedAnswers[b]
    end)
end

function M:InitAnswers()
    -- 清空所有线索控件
    for _, clueWidget in ipairs(self.ClueWidgets) do
        if clueWidget then
            clueWidget:Reset()
        end
    end 
    -- 填充线索数据
    local clueCount = #self.CurrentUnlockedAnswers
    for i = 1, math.min(clueCount, 6) do
        local AnswerId = self.CurrentUnlockedAnswers[i]
        local DetectiveAnswerData = DataMgr["DetectiveAnswer"][AnswerId]
        local SubmittedAnswerIds = ReasoningUtils:GetQuestionResultAnswers(self.CurerntQuestionId)
        if DetectiveAnswerData and self.ClueWidgets[i] then
            local clueWidget = self.ClueWidgets[i]
            local Content =  NewObject(UIUtils.GetCommonItemContentClass())
            Content.AnswerId = AnswerId
            Content.Name = DetectiveAnswerData.Name
            Content.Detail = DetectiveAnswerData.Detail
            Content.Tips = DetectiveAnswerData.Tips
            Content.Icon = LoadObject(DetectiveAnswerData.Icon)
            Content.IsEmpty = false
            Content.CanMultiSelected = false
            Content.IsSingleSelected = false
            Content.IsMultiSelected = false
            Content.Parent = self
            Content.IsSumbit = SubmittedAnswerIds and ReasoningUtils:TableContains(SubmittedAnswerIds, AnswerId)
            clueWidget:InitUIInfo(Content)
            clueWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
    end
    -- 处理空态显示
    self.IsClueEmpty = clueCount == 0
    if clueCount > 0 then
        self.WS_Type:SetActiveWidgetIndex(0)
        self.Btn_Associate:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.WS_Type:SetActiveWidgetIndex(1)
        self.Text_InProgress:SetText(GText("Minigame_Textmap_100309"))
        self.Btn_Associate:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    if ReasoningUtils:IsQuestionSolved(self.CurerntQuestionId) then
        self.WS_Btn:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self:PlayAnimation(self.Closure_In)
        AudioManager(self):PlayUISound(self, "event:/ui/common/tuili_success_stamp", nil, nil)
        self.Panel_Solve:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Panel_Complete:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Text_Complete:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Text_Title:SetRenderOpacity(0.6)
        self.Text_Question:SetRenderOpacity(0.6)
        if self.ParentQuestions[self.CurerntQuestionId] then
            self.Text_Complete:SetText(GText("Minigame_Textmap_100334"))
        else
            self.Text_Complete:SetText(GText("Minigame_Textmap_100323"))
        end
    else
        self.WS_Btn:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Panel_Solve:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Text_Complete:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Panel_Complete:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Text_Title:SetRenderOpacity(1.0)
        self.Text_Question:SetRenderOpacity(1.0)
    end

    -- 如果是在剧情中，就不要显示按钮
    if self.IsInDialogue then
        self.WS_Btn:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    -- 判断是否是父问题
    if self.ParentQuestions[self.CurerntQuestionId] then
        self.Text_Question:SetText(GText("Minigame_Textmap_100308"))
        self.Text_Tip:SetText(GText("Minigame_Textmap_100310"))
        self.Hint:SetText(GText("Minigame_Textmap_100325"))
        self.Text_Solve:SetText(GText("Minigame_Textmap_100302"))
    else
        self.Text_Tip:SetText(GText("Minigame_Textmap_100330"))
        self.Hint:SetText(GText("Minigame_Textmap_100334"))
        self.Text_Solve:SetText(GText("Minigame_Textmap_100335"))
    end
end

function M:InitComTab()
    if self.Tab then
        self.Tab:Init({
            TitleName = GText("Minigame_Textmap_100304"),
            DynamicNode={"Back", "BottomKey"},
            OwnerPanel=self,
            BackCallback=self.OnClickBackButton,
            BottomKeyInfo = {{
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.Close, Owner=self}},
                GamePadInfoList = {{Type="Img", ImgShortPath="B", Owner=self}}, Desc=GText("UI_Controller_Close")
            }}
        })
    end
end

function M:UpdateComTab(IsMultiChosen)
    if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "PC" then
        return
    end
end

function M:OnClickBackButton()
    if self.CurrentReasoningState == EReasoningState.InferAnswer then
        self:RefreshButtonUI()
        self:ClearClueWidgetsAnimations()
        self:SetClueUIEmpty()
    elseif not self.Book.IsClueUi then
        self.Book:OnClickClose()
    else
        self:Close()
    end
end

function M:SetClueUIEmpty()
    if self.Book.IsClueUi then
        self.Book:PlayAnimation(self.Book.kong)
    else
        self.Book.IsEmpty = true
    end
end

function M:OnListItemClicked(Content)
    -- 查看线索和提交问题单选的时候，是单选操作
    if self.CurrentReasoningState == EReasoningState.SeeAnswerDetail or
        (self.CurrentReasoningState == EReasoningState.CommitAnswer and self.IsCommitAnswerMultiSelect == false)
    then
        if self.CurrentChosenContent and self.CurrentChosenContent.AnswerId ~= Content.AnswerId then
            self.CurrentChosenContent.UI:SetIsSingleSelected(false)
            self.CurrentChosenContent.UI:PlaySelectAnimation()
        end
        self.CurrentChosenContent = Content
    else
        --多选的时候也要响应单选，抽象的逻辑
        if self.CurrentChosenContent and self.CurrentChosenContent.AnswerId ~= Content.AnswerId then
            self.CurrentChosenContent.UI:SetIsSingleSelected(false)
            self.CurrentChosenContent.UI:PlaySelectAnimation()
        end
        self.CurrentChosenContent = Content
        if Content.IsMultiSelected then
            self.CurrentSelectedAnswers[Content.AnswerId] = Content
        else
            self.CurrentSelectedAnswers[Content.AnswerId] = nil
        end
    end
    self:UpdateComTab(Content.IsMultiSelected)
    self:RefreshButtonState()
end

function M:OnListItemHovered(Content)
    self:UpdateComTab(Content.IsMultiSelected)
end

function M:SetContentSingleSelected(Content, bSelected)
    if not Content then
        return
    end
    Content.IsSingleSelected = bSelected
end

function M:SetContentMultiSelected(Content, IsSelected)
    if not Content then
        return
    end
    local NewIsMultiSelected = false
    if IsSelected == nil then
        NewIsMultiSelected = not Content:IsMultiSelected()
    else
        NewIsMultiSelected = IsSelected
    end
    Content.UI:SetIsMultiSelected(NewIsMultiSelected)
end

function M:UpdateItemInfo(Content)
    self.Book.Content = Content
    self.Book:UpdateItemInfo(Content)
end

function M:CommitAnswer()
    if not self.Avatar then
        return
    end
    self.AutoClose = false
    local Answers = {}
    if self.IsCommitAnswerMultiSelect then
        for Id, _ in pairs(self.CurrentSelectedAnswers) do
            DebugPrint("Reasoning CommitAnswer: ", Id)
            table.insert(Answers, Id)
        end
    else
        table.insert(Answers, self.CurrentChosenContent.AnswerId)
    end
    self.Avatar:DetectiveQuestionCommit(self.CurerntQuestionId, Answers, function(ErrCode, Result)
        if ErrCode == 0 then
            local AssociateWidget = UIManager(self):LoadUINew("DetectiveAssociate", 0, Answers, nil, self.CurerntQuestionId)
            self.IsPlayingAnimation = true
            AssociateWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            AssociateWidget:StartPlayInAnimation()
            self.InferOrCommitFailTimes = 0
            self:PlayInferOrCommitFailAnimation()
            self.CurrentChosenContent = nil
            self.CurrentSelectedAnswers = {}
            self:UpdateItemInfo(self.CurrentChosenContent)
            self:SetClueUIEmpty()
            ReasoningUtils:ClearClueReddot(self.CurerntQuestionId)
        else
            local AssociateWidget = UIManager(self):LoadUINew("DetectiveAssociate", 1, Answers)
            self.IsPlayingAnimation = true
            AssociateWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            AssociateWidget:StartPlayInAnimation()
            self.InferOrCommitFailTimes = self.InferOrCommitFailTimes + 1
            self:PlayInferOrCommitFailAnimation()
        end
    end)
end

function M:OnDetectiveAniFinish(QuestionId)
    self.IsPlayingAnimation = false
    self.Book:RefreshReddotAndSolvedUI()
    if self.AutoClose then
        self:Close()
        return
    end
    self:RefreshAnswerByQuestionId(QuestionId)
    if self.CurrentSelectQuestionUI then
        self.CurrentSelectQuestionUI.Content.IsSolved = true
        self.CurrentSelectQuestionUI:RefreshReddotAndSolvedUI()
    end
    local AnswerIds = ReasoningUtils:IsQuestionUnlockNewClue(QuestionId)
    if not self.ParentQuestions[QuestionId] and AnswerIds then
        self:AddTimer(0.8, function()
            UIManager(self):ShowUITip("CommonToastMain", GText("Minigame_Textmap_100332"))
            local Avatar = GWorld:GetAvatar()
            for _, AnswerId in pairs(AnswerIds) do
                Avatar:DetectiveQuestionUnlockAnswer(AnswerId)
            end
        end)
    end
    self:ClearClueWidgetsAnimations()

end

function M:OnAssociateAniFinish(AnswerId)
    self.IsPlayingAnimation = false
    self.Book:RefreshReddotAndSolvedUI()
    if self.AutoClose then
        self:Close()
        return
    end
    for _, clueWidget in ipairs(self.ClueWidgets) do
        if clueWidget and clueWidget.Content and clueWidget.Content.AnswerId == AnswerId then
            clueWidget:PlayAnimation(clueWidget.Refresh)
            clueWidget:OnClickButton()
            clueWidget:SetFocus()
            AudioManager(self):PlayUISound(self, "event:/ui/common/tuili_clue_new_appear", nil, nil)
        end
    end
end

function M:OnAssociteUIClose()
    if self.IsNeedPlayGuideTextRefresh then
        self:AddTimer(0.1, function()
            self:PlayAnimation(self.Panel_Guide_TextRefresh)
            self.Text_Content:SetText(self.IsNeedPlayGuideText)
            self.IsNeedPlayGuideTextRefresh = false
            AudioManager(self):PlayUISound(self, "event:/ui/common/tuili_jiaojiao_guider_refresh", nil, nil)
        end)
    end
end

function M:InitInferAnswerState()
    self:UpdateComTab()
    self.CurrentSelectedAnswers = {}
    self:InitSeeAnswerDetailState(EReasoningState.InferAnswer)
    self:RefreshButtonState()
    self:UpdateItemInfo(nil)
    self:SetListItemCanMultiSelected(true)
    self:ClearClueWidgetsAnimations()
    self:SetClueUIEmpty()
end

function M:InferAnswer()
    if not self.Avatar then
        return
    end
    self.AutoClose = false
    local Answers = {}
    for Id, _ in pairs(self.CurrentSelectedAnswers) do
        DebugPrint("Reasoning InferAnswer: ", Id)
        table.insert(Answers, Id)
    end
    self.Avatar:DetectiveQuestionInfer(Answers, function(ErrCode, NewAnswer)
        if ErrCode == 0 and not self.NeededAnswers[NewAnswer] then
            UIManager(self):LoadUINew("DetectiveReasoningAni", Answers,NewAnswer)
            self.IsPlayingAnimation = true
            self:AddTimer(1.0, function()
                self.CurrentChosenContent = nil
                self.CurrentSelectedAnswers = {}
                self:RefreshAnswerByQuestionId(self.CurerntQuestionId)
                self:RefreshButtonUI()
                self:SetClueUIEmpty()
                self:ClearClueWidgetsAnimations()
                for _, clueWidget in ipairs(self.ClueWidgets) do
                    if clueWidget and clueWidget.Content and clueWidget.Content.AnswerId == NewAnswer then
                        clueWidget:PlayAnimation(clueWidget.Hide_Refresh)
                    end
                end
            end)
            self.InferOrCommitFailTimes = 0
            self:PlayInferOrCommitFailAnimation()
        else
            local AssociateWidget = UIManager(self):LoadUINew("DetectiveAssociate", 3, Answers)
            self.IsPlayingAnimation = true
            AssociateWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            AssociateWidget:StartPlayInAnimation()
            self.InferOrCommitFailTimes = self.InferOrCommitFailTimes + 1
            self:PlayInferOrCommitFailAnimation()
        end
    end)
end

-- 播放失败提示信息
function M:PlayInferOrCommitFailAnimation()
    -- 如果失败次数大于3次，则播放失败提示信息
    local NeededAnswers = nil
    local bInferAnswer = false
    local bCommitAnswer = false
    local bSuccess = 0
    if(self.CurrentReasoningState == EReasoningState.InferAnswer) then
        NeededAnswers = ReasoningUtils:GetMissingInferAnswers(self.CurerntQuestionId)
        bInferAnswer = true
    elseif(self.CurrentReasoningState == EReasoningState.CommitAnswer) then
        NeededAnswers = ReasoningUtils:GetCommitAnswers(self.CurerntQuestionId)
        bCommitAnswer = true
    end
    -- 失败
    if self.InferOrCommitFailTimes >= self.WarningFailTimes then
        if not NeededAnswers then
            bSuccess = -2
        else
            for _, clueWidget in ipairs(self.ClueWidgets) do
                if clueWidget and clueWidget:IsVisible() then
                    if ReasoningUtils:TableContains(NeededAnswers, clueWidget.Content.AnswerId) then
                        clueWidget.Arrow:SetVisibility(UE4.ESlateVisibility.Visible)
                    end
                end
            end
        end
    -- 成功
    elseif self.InferOrCommitFailTimes == 0 then
        bSuccess = 1
        for _, clueWidget in ipairs(self.ClueWidgets) do
            if clueWidget and clueWidget:IsVisible() then
                clueWidget.Arrow:SetVisibility(UE4.ESlateVisibility.Collapsed)
            end
        end
    end
    self:SetPanelGuideText(bSuccess, bInferAnswer, bCommitAnswer, false)
end

-- -2线索不足，-1默认，0失败，1成功
function M:SetPanelGuideText(bSuccess, bInferAnswer, bCommitAnswer, bChangeImmediate)
    local bIsParentQuestion = self.ParentQuestions[self.CurerntQuestionId]
    local newText = GText("Minigame_Textmap_BaiTips10")
    
    if bSuccess == -2 then
        newText = GText("Minigame_Textmap_BaiTips09")
    elseif bSuccess == -1 then
        newText = GText("Minigame_Textmap_BaiTips10")
    elseif bSuccess == 0 then
        if self.InferOrCommitFailTimes >= self.WarningFailTimes then
            newText = GText("Minigame_Textmap_BaiTips11")
        else
            if bInferAnswer then
                if bIsParentQuestion then
                    newText = GText("Minigame_Textmap_BaiTips06")
                else
                    newText = GText("Minigame_Textmap_BaiTips02")
                end
            elseif bCommitAnswer then
                if bIsParentQuestion then
                    newText = GText("Minigame_Textmap_BaiTips08")
                else
                    newText = GText("Minigame_Textmap_BaiTips04")
                end
            end
        end
    elseif bSuccess == 1 then
        if bInferAnswer then
            if bIsParentQuestion then
                newText = GText("Minigame_Textmap_BaiTips05")
            else
                newText = GText("Minigame_Textmap_BaiTips01")
            end
        elseif bCommitAnswer then
            self.Panel_Guide:SetVisibility(UE4.ESlateVisibility.Collapsed)
            if bIsParentQuestion then
                newText = GText("Minigame_Textmap_BaiTips07")
            else
                newText = GText("Minigame_Textmap_BaiTips03")
            end
        end
    end
    
    -- 检查文本是否发生变化
    local currentText = self.Text_Content:GetText()
    if currentText ~= newText then
        -- 文本发生变化，播放动画
        self.IsNeedPlayGuideTextRefresh = true
        self.IsNeedPlayGuideText = newText
        -- self:PlayAnimation(self.Panel_Guide_TextRefresh)
    end

    if bChangeImmediate then
        self.Text_Content:SetText(newText)
    end
end

function M:ClearClueWidgetsAnimations()
    for _, clueWidget in ipairs(self.ClueWidgets) do
        if clueWidget and clueWidget:IsVisible() and clueWidget.Content ~= self.CurrentChosenContent then
            if clueWidget.Content.CanMultiSelected or self.CurrentReasoningState == EReasoningState.CommitAnswer then
                clueWidget:PlayAnimation(clueWidget.Multi_Normal)
            else
                clueWidget:PlayAnimation(clueWidget.Normal)
            end
            clueWidget:SetIsSingleSelected(false)
            clueWidget:SetIsMultiSelected(false)
        elseif clueWidget and clueWidget:IsVisible() and clueWidget.Content == self.CurrentChosenContent then
            if self.CurrentReasoningState == EReasoningState.SeeAnswerDetail then
                clueWidget:PlayAnimation(clueWidget.Click)
            else
                clueWidget:PlayAnimation(clueWidget.Normal_JustClick)
            end
            clueWidget:SetIsSingleSelected(true)
            clueWidget:SetIsMultiSelected(false)
        end
    end
end

function M:ClearMultiSelect()
    if self.CurrentSelectedAnswers then
        for _, CurrentContent in pairs(self.CurrentSelectedAnswers) do
            self:SetContentMultiSelected(CurrentContent, false)
        end
        self.CurrentSelectedAnswers = {}
    end
end

function M:SetListItemCanMultiSelected(bCanMultiSelected)
    DebugPrint("SetListItemCanMultiSelected", bCanMultiSelected)
    for _, clueWidget in ipairs(self.ClueWidgets) do
        if clueWidget and clueWidget:IsVisible() then
            clueWidget:SetCanMultiSelected(bCanMultiSelected)
            clueWidget.IsCommitAnswer = self.CurrentReasoningState == EReasoningState.CommitAnswer
        end
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        self:OnGamepadKeyDown(InKeyName)
    else
        if (InKeyName == "Escape") then
            self:OnClickBackButton()
        end
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if InKeyName == "Gamepad_FaceButton_Bottom" then -- A键
            if not self.Book:GetIsClueUi() then
                self.Book:OnClickClose()
                self:SetDefaultFocus()
                self.Btn_Associate.Key_GamePad:SetVisibility(UIConst.VisibilityOp["Visible"])
            end
        end
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:RefreshAnswerByQuestionId(QuestionId, Index)
    local bClearClueWidgetsAnimations = false
    if QuestionId ~= self.CurerntQuestionId then
        bClearClueWidgetsAnimations = true
        self.CurrentChosenContent = nil
        self.CurrentSelectedAnswers = {}
    end
    self.CurerntQuestionId = QuestionId
    self:InitSortedAnswers()
    self:InitAnswers()
    self.InferOrCommitFailTimes = 0
    self:PlayInferOrCommitFailAnimation()
    self:RefreshButtonUI()
    if bClearClueWidgetsAnimations then
        self:ClearClueWidgetsAnimations()
    end
    -- 删除自动选中第一个
    -- if not self.IsClueEmpty and bClearClueWidgetsAnimations then
    --     if not ReasoningUtils:IsMultiEndingQuestion(self.CurerntQuestionId) then
    --         self.Clue_01:SelectSelf()
    --     end
    -- end
    self:UpdateItemInfo(self.CurrentChosenContent)
    if Index then
        self.Text_Question:SetText(string.format(GText("Minigame_Textmap_100336"), Const.IndexNum[Index]))
    end

    for _, clueWidget in ipairs(self.ClueWidgets) do
        if clueWidget and clueWidget.Content then
            clueWidget:PlayAnimation(clueWidget.In)
        end
    end
end

function M:SelectFirstClue()
    if not self.IsClueEmpty then
        if not ReasoningUtils:IsMultiEndingQuestion(self.CurerntQuestionId) then
            if self.CurrentChosenContent == nil then
                local clueWidget = self.ClueWidgets[1]
                self:UpdateItemInfo(clueWidget.Content)
                self.CurrentChosenContent = clueWidget.Content
                if self.CurrentReasoningState == EReasoningState.SeeAnswerDetail or self.CurrentReasoningState == EReasoningState.CommitAnswerFinish then
                    clueWidget:PlayAnimation(clueWidget.Click)
                else
                    clueWidget:PlayAnimation(clueWidget.Normal_JustClick)
                end
                clueWidget:SetIsSingleSelected(true)
                clueWidget:SetIsMultiSelected(false)
            end
        end
    end
end

function M:OnClickButtonAssociate()
    if self.IsInDialogue then
        return
    end
    if self.Btn_Associate.Btn_Click:GetForbidden() then
        if self.IsLackClue then
            UIManager(self):ShowUITip("CommonToastMain", GText("Minigame_Textmap_100339"))
            return
        end
        if self.CurrentReasoningState == EReasoningState.SeeAnswerDetail then
            UIManager(self):ShowUITip("CommonToastMain", GText("Minigame_Textmap_100305"))
        elseif self.CurrentReasoningState == EReasoningState.InferAnswer and self.CurrentClueCount < self.TotalClueCount then
            UIManager(self):ShowUITip("CommonToastMain", GText("Minigame_Textmap_100342"))
        elseif self.CurrentReasoningState == EReasoningState.CommitAnswer and self.CurrentClueCount < self.TotalClueCount then
            UIManager(self):ShowUITip("CommonToastMain", GText("Minigame_Textmap_100342"))
        end
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
    self.Book:OnClickClose()
    if self.CurrentReasoningState == EReasoningState.SeeAnswerDetail then
        self:InitInferAnswerState()
    elseif self.CurrentReasoningState == EReasoningState.InferAnswer then
        self:InferAnswer()
    elseif self.CurrentReasoningState == EReasoningState.CommitAnswer then
        self:CommitAnswer()
        self:RefreshButtonUI()
    end
end

function M:OnClickCloseButton()
    self.Book:OnClickClose()
end

function M:RefreshButtonUI()
    self:InitSeeAnswerDetailState()
    self:RefreshButtonState()
end

function M:InitSeeAnswerDetailState(state)
    if(state ~= nil) then
        self.CurrentReasoningState = state
    elseif(ReasoningUtils:IsCanInferAnswer(self.CurerntQuestionId)) then
        self.CurrentReasoningState = EReasoningState.SeeAnswerDetail
        self:SetListItemCanMultiSelected(false)
    else
        if ReasoningUtils:IsQuestionSolved(self.CurerntQuestionId) then
            self.CurrentReasoningState = EReasoningState.CommitAnswerFinish
            self:SetListItemCanMultiSelected(false)
        else
            self.CurrentReasoningState = EReasoningState.CommitAnswer
            self.IsCommitAnswerMultiSelect = ReasoningUtils:IsMultiSelectCommitQuestion(self.CurerntQuestionId)
            self:SetListItemCanMultiSelected(self.IsCommitAnswerMultiSelect)
        end
    end
end

function M:RefreshButtonState()
    local bShowNum = true
    self.Text_SelectNum:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Text_Warn:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    local WarnInText = nil
    local NumText = nil
    if self.CurrentReasoningState == EReasoningState.SeeAnswerDetail then
        self.Btn_Associate.Text:SetText(GText("Minigame_Textmap_100313"))
        self:SetTextWarnText(nil)
    elseif self.CurrentReasoningState == EReasoningState.InferAnswer then
        WarnInText = GText("Minigame_Textmap_100314")
        local currentClueCount = CommonUtils.TableLength(self.CurrentSelectedAnswers)
        local totalClueCount = ReasoningUtils:GetMissingInferAnswersNum(self.CurerntQuestionId)
        if currentClueCount > totalClueCount then
            NumText = "<W>" .. currentClueCount .. "</><H>/" .. totalClueCount .. "</>"
        else
            NumText = "<H>" .. currentClueCount .. "</><H>/" .. totalClueCount .. "</>"
        end
        self.Text_SelectNum:SetText(NumText)
        self.Text_SelectNum:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Btn_Associate.Text:SetText(GText("Minigame_Textmap_100313"))
        AudioManager(self):PlayUISound(self, "event:/ui/common/tuili_clue_msg_select", nil, nil)
    elseif self.CurrentReasoningState == EReasoningState.CommitAnswer then
        self.Btn_Associate.Text:SetText(GText("Minigame_Textmap_100320"))
        if self.IsCommitAnswerMultiSelect then
            WarnInText = GText("Minigame_Textmap_100328")
        else
            WarnInText = GText("Minigame_Textmap_100328")
        end
    elseif self.CurrentReasoningState == EReasoningState.CommitAnswerFinish then
        self:SetTextWarnText(nil)
        self.Btn_Associate.Text:SetText(GText("Minigame_Textmap_100325"))
    end
    local isForbidden = true
    self.IsLackClue = false
    -- 先判断是否缺少线索
    local NeededAnswers = nil
    if(self.CurrentReasoningState == EReasoningState.InferAnswer or self.CurrentReasoningState == EReasoningState.SeeAnswerDetail) then
        NeededAnswers = ReasoningUtils:GetMissingInferAnswers(self.CurerntQuestionId)
    elseif(self.CurrentReasoningState == EReasoningState.CommitAnswer) then
        NeededAnswers = ReasoningUtils:GetCommitAnswers(self.CurerntQuestionId)
    else
        NeededAnswers = {}
    end

    if not NeededAnswers then
        isForbidden = true
        WarnInText = GText("Minigame_Textmap_100339")
        bShowNum = false
        self.IsLackClue = true
    elseif self.CurrentReasoningState == EReasoningState.SeeAnswerDetail then
        if #self.CurrentUnlockedAnswers > 0 then
            isForbidden = false
        end
    elseif self.CurrentReasoningState == EReasoningState.InferAnswer then
        local currentClueCount = CommonUtils.TableLength(self.CurrentSelectedAnswers)
        local totalClueCount = ReasoningUtils:GetMissingInferAnswersNum(self.CurerntQuestionId)
        if currentClueCount == totalClueCount then
            isForbidden = false
        end
        self.CurrentClueCount = currentClueCount
        self.TotalClueCount = totalClueCount
    elseif self.CurrentReasoningState == EReasoningState.CommitAnswer then
        local currentClueCount = CommonUtils.TableLength(self.CurrentSelectedAnswers)
        if self.IsCommitAnswerMultiSelect then
            currentClueCount = CommonUtils.TableLength(self.CurrentSelectedAnswers)
        else
            currentClueCount = self.CurrentChosenContent and 1 or 0
        end
        local totalClueCount = CommonUtils.TableLength(NeededAnswers)
        if currentClueCount == totalClueCount then
            isForbidden = false
            if ReasoningUtils:IsMultiEndingQuestion(self.CurerntQuestionId) then
                WarnInText = GText("Minigame_Textmap_100333")
            end
        end
        if currentClueCount > totalClueCount then
            NumText = "<W>" .. currentClueCount .. "</><H>/" .. totalClueCount .. "</>"
        else
            NumText = "<H>" .. currentClueCount .. "</><H>/" .. totalClueCount .. "</>"
        end
        self.Text_SelectNum:SetText(NumText)
        self.Text_SelectNum:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.CurrentClueCount = currentClueCount
        self.TotalClueCount = totalClueCount
    end
    self.Btn_Associate.Btn_Click:SetForbidden(isForbidden)
    self:SetTextWarnText(WarnInText,bShowNum)
end

function M:SetTextWarnText(Text,bShowNum)
    if self.IsInDialogue then
        self.Text_Warn:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Panel_Num:SetVisibility(UE4.ESlateVisibility.Collapsed)
        return
    end
    if self.IsClueEmpty then
        self.Text_Warn:SetVisibility(UE4.ESlateVisibility.Collapsed)
    elseif(self.WarnInText ~= Text and Text ~= nil) then
        self.Text_Warn:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self:PlayAnimation(self.Text_Warn_In)
        self.WarnInText = Text
        self.Text_Warn:SetText(Text)
        self.Panel_Num:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    elseif Text == nil then
        self.Text_Warn:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Panel_Num:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.WarnInText = nil
    end
    if bShowNum == false then
        self.Panel_Num:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end
AssembleComponents(M)
return M

