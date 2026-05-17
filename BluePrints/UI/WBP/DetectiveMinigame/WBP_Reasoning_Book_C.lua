--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local ReasoningUtils = require "BluePrints.UI.WBP.DetectiveMinigame.ReasoningUtils"

---@type WBP_Reasoning_Book_P_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Btn_QaBook.Btn_Click.OnClicked:Add(self, self.OnClickButton)
    self.IsClueUi = false

    ReddotManager.AddListener("DetectiveQuestion",self,self.RefreshReddotAndSolvedUI)
    ReddotManager.AddListener("DetectiveAnswer",self,self.RefreshReddotAndSolvedUI)
    self.Btn_QaBook.Text_Clue:SetText(GText("Minigame_Textmap_100303"))
    self.Btn_QaBook.Text_Clue_1:SetText(GText("Minigame_Textmap_100340"))
    self.Btn_Close.Btn_Close.OnClicked:Add(self, self.OnClickClose)
    if self.Btn_Esc then
        self.Btn_Esc:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Text",
                    Text = "Esc",
                    ClickCallback = function()
                        self:OnClickClose()
                    end
                }
            },
            Desc = GText("UI_BACK")
        })
        self.Controller_01:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "X"
                }
            },
            Desc = GText("UI_CTL_Squad_Expand")
        })
        self.Controller_02:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "A"
                }
            },
            Desc = GText("UI_Tips_Ensure")
        })
        self.Controller_03:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "B"
                }
            },
            Desc = GText("UI_Controller_Close")
        })
    end
    self:RefreshReddotAndSolvedUI()
    self.Text_Empty:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Text_Empty_1:SetText(GText("Minigame_Textmap_100341"))
    self.Panel_Clue:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

function M:Destruct()
    ReddotManager.RemoveListener("DetectiveQuestion",self)
    ReddotManager.RemoveListener("DetectiveAnswer",self)
end

function M:OnClickCloseButton()
    self:OnClickClose()
end

function M:RefreshReddotAndSolvedUI()
    self.Btn_QaBook.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Btn_QaBook.Panel_Clue:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Btn_QaBook.Panel_Reason:SetVisibility(UE4.ESlateVisibility.Collapsed)
    local IsReasoningState = ReasoningUtils:IsAllQuestionReasoningState()
    local IsNewClue = ReasoningUtils:IsAllClueHasNewClue()
    local IsNewQuestion = ReasoningUtils:IsAllQuestionHasNewQuestion()
    if IsNewClue then
        self.Btn_QaBook.Panel_Clue:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    elseif IsNewQuestion then
        self.Btn_QaBook.New:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    elseif IsReasoningState then
        self.Btn_QaBook.Panel_Reason:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
end

function M:OnClickButton()
    self:SwitchToClueUi(false)
end

function M:OnClickClose()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    self:SwitchToClueUi(true)
end

function M:SwitchToClueUi(bVisible)
    if self.IsClueUi == bVisible then
        return
    end

    self.ParentUI:SelectFirstClue()

    self:RefreshReddotAndSolvedUI()
    if bVisible then
        AudioManager(self):PlayUISound(self, "event:/ui/common/tuili_clue_list_to_detail", nil, nil)
        self:PlayAnimation(self.Xiang_In)
        self.ParentUI.Tab:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        if self.IsEmpty then
            self.Switch_MainType:SetActiveWidgetIndex(1)
        else
            self.Switch_MainType:SetActiveWidgetIndex(0)
        end
        if (self.ParentUI.CurrentReasoningState == 4 or self.ParentUI.IsClueEmpty) then
            self.ParentUI.Panel_Guide:SetVisibility(UE4.ESlateVisibility.Collapsed)
        else
            self.ParentUI.Panel_Guide:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
        self.ParentUI:PlayAnimation(self.ParentUI.Guide_In)
    else
        AudioManager(self):PlayUISound(self, "event:/ui/common/tuili_clue_detail_to_list", nil, nil)
        if not self.IsEmpty then
            self.Switch_QuizType:SetActiveWidgetIndex(0)
            EventManager:FireEvent(EventID.OnDetectiveRefreshProgress, self)
        end
        self:PlayAnimation(self.Lie_In)
        self.ParentUI.Tab:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.ParentUI:PlayAnimation(self.ParentUI.Guide_Out)
    end
    self.IsClueUi = bVisible
end

function M:GetIsClueUi()
    return self.IsClueUi
end

function M:PlayChangeAnimation(AnswerId)
    if self.AnswerId == AnswerId then
        return
    end
    self.AnswerId = AnswerId
    self:PlayAnimation(self.Change)
end

function M:InitUIInfo(ParentQuestions, ParentUI, NewAnswerId, NewQuestionId)
    self.ParentQuestions = ParentQuestions
    self.ParentUI = ParentUI
    self.List_Question:ClearListItems()
    local index = 0
    for _, Question in pairs(self.ParentQuestions) do
        local Content =  NewObject(UIUtils.GetCommonItemContentClass())
        Content.ParentQuestion = Question.id
        Content.ChildrenQuestions = Question.children
        Content.ParentUI = ParentUI
        Content.IsSolved = ReasoningUtils:IsQuestionSolved(Question.id)
        Content.Index = index
        self.List_Question:AddItem(Content)
        index = index + 1
    end
    
    -- 设置ListView滚动倍率，使其能够直接响应鼠标滚轮
    self:UpdateListViewScrollMultiplier(self.List_Question, 10)
    
    -- 设置ListView可聚焦，使其能够直接响应鼠标滚轮
    if self.List_Question then
        self.List_Question.bIsFocusable = true
    end
    
    -- 根据列表项数量设置滚动条可见性（参考任务界面的实现）
    if self.List_Question.ListItems and self.List_Question.ListItems:Num() ~= 0 then
        self.List_Question:SetScrollbarVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.List_Question:SetScrollbarVisibility(UE4.ESlateVisibility.Collapsed)
    end
    
    self:AddTimer(0.2, function()
        if NewAnswerId ~= nil then
            local answerData = DataMgr["DetectiveAnswer"][NewAnswerId]
            self:SelectQuestionByQuestionId(answerData.QuestionID)
        elseif NewQuestionId ~= nil then
            self:SelectQuestionByQuestionId(NewQuestionId)
        end
        
        -- 延迟检查并设置滚动条可见性（等列表项渲染完成后）
        if self.List_Question then
            local TaskItemUIs = self.List_Question:GetDisplayedEntryWidgets()
            if TaskItemUIs and TaskItemUIs:Num() > 0 then
                local TaskMaxCount = UIUtils.GetListViewContentMaxCount(self.List_Question, TaskItemUIs)
                local AllListItems = self.List_Question.ListItems:ToTable()
                if #AllListItems >= TaskMaxCount then
                    self.List_Question:SetScrollbarVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                else
                    self.List_Question:SetScrollbarVisibility(UE4.ESlateVisibility.Collapsed)
                end
            end
            
            -- 延迟设置焦点，确保列表项已渲染完成
            if self.List_Question.SetFocus then
                self.List_Question:SetFocus()
            end
        end
    end)
    self.Btn_QaBook.Text_Name:SetText(GText("Minigame_Textmap_100306"))
    self.Text_Title:SetText(GText("Minigame_Textmap_100307"))
end

function M:SelectQuestionByQuestionId(QuestionId)
    for i = 0, self.List_Question:GetNumItems() - 1 do
        local Item = self.List_Question:GetItemAt(i)
        if Item and Item.UI and Item.ParentQuestion == QuestionId then
            Item.UI:OnClickButton()
            Item.UI:SetFocus()
            Item.UI.BG:OnCellClicked()
            self.List_Question:SetSelectedIndex(i)
            return
        end
        if Item and Item.UI and Item.UI.List_SubTask then
            for j = 0, Item.UI.List_SubTask:GetNumItems() - 1 do
                local SubItem = Item.UI.List_SubTask:GetItemAt(j)
                if SubItem and SubItem.UI and SubItem.Question == QuestionId then
                    SubItem.UI:OnClickButton()
                    SubItem.UI.BG:OnCellClicked()
                    SubItem.UI:SetFocus()
                    self.List_Question:SetSelectedIndex(i)
                    return
                end
            end
        end
    end
end

function M:UpdateItemInfo(Content)
    if Content and not Content.IsEmpty then
        self.Icon_Clue:SetBrushResourceObject(Content.Icon)
        self.Text_Name:SetText(GText(Content.Name))
        self.Text_Desc:SetText(GText(Content.Detail))
        self.IsEmpty = false
        local questionId = ReasoningUtils:IsClueFromResult(Content.AnswerId)
        if questionId then
            local DetectiveQuestionData = DataMgr["DetectiveQuestion"][questionId]
            if DetectiveQuestionData then
                local Tips = DetectiveQuestionData.Tips
                self.Text_Gain:SetText(string.format(GText("Minigame_Textmap_100331"), GText(Tips)))
                self.Text_Gain:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            end
        else
            self.Text_Gain:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    else
        self.IsEmpty = true
    end
end

return M
