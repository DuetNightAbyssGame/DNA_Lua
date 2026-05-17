---@class DetectiveQuestion
local Component = {}
local ReasoningUtils = require "BluePrints.UI.WBP.DetectiveMinigame.ReasoningUtils"

--提交线索得到结果
function Component:DetectiveQuestionCommit(QuestionId, Answers, Callback)
    DebugPrint("DetectiveQuestionCommit", QuestionId, Answers)
    local function Cb(ErrCode,Result)
        DebugPrint("DetectiveQuestionCommit Cb",ErrorCode:Name(ErrCode),Result)
        if Callback then
            Callback(ErrCode, Result)
        end
        if ErrCode == 0 then
            self:DoResultTaskNodeCallback(Result)
        end
    end
    self:CallServer("RpcDetectiveQuestionCommit",Cb,QuestionId,Answers)
end

--根据线索推理出新线索
function Component:DetectiveQuestionInfer(Answers, Callback)
    DebugPrint("DetectiveQuestionInfer",  Answers)
    local function Cb(ErrCode,NewAnswer)
        DebugPrint("DetectiveQuestionInfer Cb",ErrorCode:Name(ErrCode),NewAnswer)
        if Callback then
            Callback(ErrCode, NewAnswer)
        end
        if ErrCode == 0 then
            self:DoAnswerTaskNodeCallback(NewAnswer)
        end
    end
    self:CallServer("RpcDetectiveQuestionInfer",Cb,Answers)
end

--获得推理线索Notify
function Component:NotifyDetectiveAnswerUnlock(AnswerId)
    DebugPrint("NotifyDetectiveAnswerUnlock", AnswerId)
    local DetectiveMinigameUI = UIManager(self):GetUIObj("DetectiveMinigame")
    local ReasoningItemInformationUI = UIManager(self):GetUIObj("ReasoningItemInformation")
    -- 推理界面没开的时候跳tips，推理界面内获得的线索在推理界面内处理
    if not DetectiveMinigameUI and not ReasoningItemInformationUI then
        UIManager(self):LoadUINew("DetectiveMinigameTips", AnswerId)
    end
    -- 任务节点用Callback
    self:DoAnswerTaskNodeCallback(AnswerId)
end

--推理问题改变Notify
function Component:NotifyDetectiveGameUnlockedNewQuestion(DetectiveQuestionId)
    DebugPrint("NotifyDetectiveGameUnlockedNewQuestion", DetectiveQuestionId)
end

--解锁推理线索RPC
function Component:DetectiveQuestionUnlockAnswer(Answer)
    DebugPrint("DetectiveQuestionUnlockAnswer", Answer)
    local function Cb(ErrCode)
        DebugPrint("DetectiveQuestionUnlockAnswer Cb",ErrorCode:Name(ErrCode))
        if ErrCode == 0 then
            local DetectiveMinigameUI = UIManager(self):GetUIObj("DetectiveMinigame")
            local ItemInformationUI = UIManager(self):GetUIObj("ItemInformation")
            -- 推理界面没开的时候跳tips，推理界面内获得的线索在推理界面内处理
            if not DetectiveMinigameUI and not ItemInformationUI then
                UIManager(self):LoadUINew("DetectiveMinigameTips", Answer)
            end
            -- 任务节点用Callback
            self:DoAnswerTaskNodeCallback(Answer)

            if not ReddotManager.GetTreeNode("DetectiveAnswer") then
                ReddotManager.AddNode("DetectiveAnswer")
            end
            local CacheKey = Answer
            local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("DetectiveAnswer")
            if CacheDetail then
                if CacheDetail[CacheKey] == nil then
                    local QuestionId = DataMgr["DetectiveAnswer"][Answer].QuestionID
                    if ReasoningUtils:IsQuestionSolved(QuestionId) then
                        CacheDetail[CacheKey] = false
                    else
                        CacheDetail[CacheKey] = true
                        ReddotManager.IncreaseLeafNodeCount("DetectiveAnswer")
                    end
                end
            end
        end
    end

    -- 这里要判断是否已经获得过，获得过的不要再走下面的东西
    local record = self.DetectiveGameUnlockedAnswersRecord
    if record[Answer] then
        return
    end
    self:CallServer("RpcDetectiveQuestionUnlockAnswer",Cb,Answer)

    -- 在这儿弹新线索
    EventManager:FireEvent(EventID.OnHomeBaseeBtnShowNewClue, "TaskPanel")
end

--解锁推理问题RPC
function Component:DetectiveQuestionUnlockQuestion(Question, DonotShowToast)
    DebugPrint("DetectiveQuestionUnlockQuestion", Question)
    local function Cb(ErrCode)
        DebugPrint("DetectiveQuestionUnlockQuestion Cb",ErrorCode:Name(ErrCode))

        if not ReddotManager.GetTreeNode("DetectiveQuestion") then
            ReddotManager.AddNode("DetectiveQuestion")
        end
        local CacheKey = Question
        local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("DetectiveQuestion")
        if CacheDetail then
            if CacheDetail[CacheKey] == nil then
                CacheDetail[CacheKey] = true
                ReddotManager.IncreaseLeafNodeCount("DetectiveQuestion")
            end
        end
    end
    self:CallServer("RpcDetectiveQuestionUnlockQuestion",Cb,Question)

    if DonotShowToast ~= true then
        EventManager:FireEvent(EventID.OnNewDetectiveQuestion, Question)
    end
end

------------------  任务节点用Callback ------------------
function Component:AddUnlockDetectiveAnswerCallback(AnswerId, Callback)
    DebugPrint("AddUnlockDetectiveAnswerCallback AnswerId", AnswerId)
	if not self.UnlockDetectiveAnswerCallback then
		self.UnlockDetectiveAnswerCallback = {}
	end
    self.UnlockDetectiveAnswerCallback[AnswerId] = Callback
end

function Component:RemoveUnlockDetectiveAnswerCallback(AnswerId)
    DebugPrint("RemoveUnlockDetectiveAnswerCallback AnswerId", AnswerId)
	if self.UnlockDetectiveAnswerCallback then
		self.UnlockDetectiveAnswerCallback[AnswerId] = nil
	end
end

function Component:DoAnswerTaskNodeCallback(AnswerId)
    if self.UnlockDetectiveAnswerCallback then
        local Callback = self.UnlockDetectiveAnswerCallback[AnswerId]
        if Callback then
            Callback(AnswerId)
        end
        self:RemoveUnlockDetectiveAnswerCallback(AnswerId)
    end
end

function Component:AddUnlockDetectiveResultCallback(ResultId, Callback)
    DebugPrint("AddUnlockDetectiveResultCallback AnswerId", ResultId)
	if not self.UnlockDetectiveResultCallback then
		self.UnlockDetectiveResultCallback = {}
	end
    self.UnlockDetectiveResultCallback[ResultId] = Callback
end

function Component:RemoveUnlockDetectiveResultCallback(ResultId)
    DebugPrint("RemoveUnlockDetectiveResultCallback ResultId", ResultId)
	if self.UnlockDetectiveResultCallback then
		self.UnlockDetectiveResultCallback[ResultId] = nil
	end
end

function Component:DoResultTaskNodeCallback(ResultId)
    if self.UnlockDetectiveResultCallback then
        local Callback = self.UnlockDetectiveResultCallback[ResultId]
        if Callback then
            Callback(ResultId)
        end
        self:RemoveUnlockDetectiveResultCallback(ResultId)
    end
end

return Component