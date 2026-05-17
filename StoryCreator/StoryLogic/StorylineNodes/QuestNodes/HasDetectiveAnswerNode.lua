local HasDetectiveAnswerNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')
local TaskUtils = require "BluePrints.UI.TaskPanel.TaskUtils"
local ReasoningUtils = require "BluePrints.UI.WBP.DetectiveMinigame.ReasoningUtils"
local ClientEventUtils = require "BluePrints.Common.ClientEvent.ClientEventUtils"

function HasDetectiveAnswerNode:Init()
    self.AnswerIds = {}
    self.FinishAnswerTable = {}
end

function HasDetectiveAnswerNode:Execute(Callback)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        TaskUtils:SetQuestExtraInfo(self.QuestChainId, self.QuestData.QuestId, 
        {
            NodeKey = self.Key,
            Node = self,
            Description = GText("打开推理界面")
        })
        self:OnChooseTrack()

        local function ExecuteCallback()
            DebugPrint("JLY: HasDetectiveAnswerNode: ExecuteCallback")
            self:ClearTaskBarNeedOpenDetectiveGame()
            Callback()
        end

        local function HasDetectiveAnswerNodeCallback(AnswerId)
            DebugPrint("HasDetectiveAnswerNode HasDetectiveAnswerNodeCallback AnswersId: "..AnswerId)
            self.FinishAnswerTable[AnswerId] = true
            for _, IsFinish in pairs(self.FinishAnswerTable) do
                if IsFinish == false then
                    return
                end
            end
            local UIManager = GWorld.GameInstance:GetGameUIManager()
            local ReasoningUI = UIManager:GetUIObj("DetectiveMinigame")
            if ReasoningUI then
                ReasoningUI.AutoClose = true
                if not ReasoningUI.IsPlayingAnimation then
                    ReasoningUI:Close()
                else
                    if ReasoningUI.AddCloseCallback then
                        DebugPrint("JLY: HasDetectiveAnswerNode: AddCloseCallback")
                        ReasoningUI:AddCloseCallback(self, function()
                            ExecuteCallback()
                        end)
                    end
                    return
                end
            else
                ExecuteCallback()
            end
        end

        local DetectiveGameUnlockedAnswersRecord = Avatar.DetectiveGameUnlockedAnswersRecord
        local AllAnswerUnlocked = true
        for _, Id in pairs(self.AnswerIds) do
            local AnswerV = DetectiveGameUnlockedAnswersRecord[Id]
            if AnswerV == nil then
                DebugPrint("HasDetectiveAnswerNode: False AnswersId: "..Id)
                self.FinishAnswerTable[Id] = false
                AllAnswerUnlocked = false
                Avatar:AddUnlockDetectiveAnswerCallback(Id, HasDetectiveAnswerNodeCallback)
            else
                DebugPrint("HasDetectiveAnswerNode: True AnswersId: "..Id)
                self.FinishAnswerTable[Id] = true
            end
        end
        if AllAnswerUnlocked then
            local UIManager = GWorld.GameInstance:GetGameUIManager()
            local ReasoningUI = UIManager:GetUIObj("DetectiveMinigame")
            if ReasoningUI then
                ReasoningUI.AutoClose = true
                if not ReasoningUI.IsPlayingAnimation then
                    ReasoningUI:Close()
                else
                    if ReasoningUI.AddCloseCallback then
                        ReasoningUI:AddCloseCallback(self, function()
                            ExecuteCallback()
                        end)
                    end
                    return
                end
            else
                ExecuteCallback()
            end
        end
    end
end

function HasDetectiveAnswerNode:Clear()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        for _, Id in pairs(self.AnswerIds) do
            Avatar:RemoveUnlockDetectiveAnswerCallback(Id)
        end
    end
    self:ClearTaskBarNeedOpenDetectiveGame()
    TaskUtils:ClearQuestExtraInfo(self.CurQuestChainId, self.CurDoingQuestId, self.Key)
end

function HasDetectiveAnswerNode:OnCancelTrack()
    self:ClearTaskBarNeedOpenDetectiveGame()
    self.IsTracking = false
end

function HasDetectiveAnswerNode:OnChooseTrack()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        self:FinishAction()
        return
    end
    local IsTracking = false
    self.CurQuestChainId = self.QuestChainId
    if Avatar.InSpecialQuest then
        self.CurQuestChainId = ClientEventUtils:GetCurrentEvent().PreQuestChainId
    end
    self.CurDoingQuestId = Avatar.QuestChains[self.CurQuestChainId].DoingQuestId
    
    if Avatar.TrackingQuestChainId == self.CurQuestChainId then
        IsTracking = true
        self.IsTracking = true
    end

    if IsTracking then
        self:ChangeMainTaskBarInfo()
    end
end

function HasDetectiveAnswerNode:ChangeMainTaskBarInfo()
    local TaskUIObj = TaskUtils:GetTaskBarWidget()
    if not TaskUIObj then
        return
    end

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self.Text = TaskUIObj.Text_Tips02:GetText()
    TaskUIObj.Text_Tips02:SetText(GText("Minigame_Textmap_100304"))
    TaskUIObj.NeedOpenDetectiveGame = true
    TaskUIObj.NeedOpenDetectiveAnswerIds = self.AnswerIds
end


function HasDetectiveAnswerNode:ClearTaskBarNeedOpenDetectiveGame()
    if not self.IsTracking then
        return
    end
    local TaskUIObj = TaskUtils:GetTaskBarWidget()
    if not TaskUIObj then
        return
    end
    TaskUIObj.Text_Tips02:SetText(self.Text)
    TaskUIObj.NeedOpenDetectiveGame = false
    TaskUIObj.NeedOpenDetectiveAnswerIds = nil
end

function HasDetectiveAnswerNode:ClearWhenQuestSuccess()
    TaskUtils:ClearQuestExtraInfo(self.CurQuestChainId, self.CurDoingQuestId, self.Key)
end

return HasDetectiveAnswerNode