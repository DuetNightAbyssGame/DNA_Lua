--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"


---@type ReasoningUtils
local M = {}

-- 判断这个问题是否还有可以联想的线索
function M:IsCanInferAnswer(QuestionId)
    local Avatar = GWorld:GetAvatar()
    local UnlockedAnswersRecord = Avatar.DetectiveGameUnlockedAnswersRecord
    local QuestionData = DataMgr["DetectiveQuestion"][QuestionId]

    if not QuestionData or not QuestionData.ProbablyNeededAnswers then
        return false
    end

    -- 遍历可能需要的答案
    for _, answerId in pairs(QuestionData.ProbablyNeededAnswers) do
        -- 检查该答案是否已经获得，如果已获得则跳过
        if not UnlockedAnswersRecord[answerId] then
            local answerData = DataMgr["DetectiveAnswer"][answerId]
            -- 检查该答案是否有联想内容
            if answerData and answerData.Detective then
                return true  -- 找到一个可用于联想的线索
            end
        end
    end

    -- 如果所有可能的答案都已获得、没有联想内容或是通过推理得到的，返回false
    return false
end

-- 判断一个问题是否是多结局
function M:IsMultiEndingQuestion(QuestionId)
    local QuestionData = DataMgr["DetectiveQuestion"][QuestionId]
    if not QuestionData or not QuestionData.ProbablyNeededAnswers then
        return false
    end
    -- 计数有多少个结果对应这个问题
    local resultCount = 0
    -- 遍历所有侦探结果
    for _, resultData in pairs(DataMgr["DetectiveResult"]) do
        if resultData.QuestionID == QuestionId then
            resultCount = resultCount + 1
            -- 如果找到超过一个结果，就可以确定是多结局了
            if resultCount > 1 then
                return true
            end
        end
    end
    -- 如果只找到一个或没有找到结果，则不是多结局
    return false
end

-- 判断一个问题是否是多选提交
function M:IsMultiSelectCommitQuestion(QuestionId)
    local QuestionData = DataMgr["DetectiveQuestion"][QuestionId]
    if not QuestionData or not QuestionData.ProbablyNeededAnswers then
        return false
    end
    -- 遍历所有侦探结果
    for resultId, resultData in pairs(DataMgr["DetectiveResult"]) do
        if resultData.QuestionID == QuestionId then
            -- 检查是否拥有提交这个结果所需的所有线索，如果大于1则说明是多选提交
            if #resultData.Answers > 1 then
                return true
            end
        end
    end
    return false
end

-- 拿到一个问题目前缺失的线索的需要联想的线索
function M:GetMissingInferAnswers(QuestionId)
    local QuestionData = DataMgr["DetectiveQuestion"][QuestionId]
    if not QuestionData or not QuestionData.ProbablyNeededAnswers then
        return {}
    end
    local Avatar = GWorld:GetAvatar()
    local UnlockedAnswersRecord = Avatar.DetectiveGameUnlockedAnswersRecord
    -- 遍历问题可能需要的答案
    for _, answerId in pairs(QuestionData.ProbablyNeededAnswers) do
        -- 检查该答案是否已经获得，如果已获得则跳过
        if not UnlockedAnswersRecord[answerId] then
            local answerData = DataMgr["DetectiveAnswer"][answerId]
            -- 检查该答案是否有联想内容
            if answerData and answerData.Detective then
                -- 检查联想所需的所有线索是否都已获得
                local canInfer = true
                for _, requiredAnswerId in pairs(answerData.Detective) do
                    if not UnlockedAnswersRecord[requiredAnswerId] then
                        canInfer = false
                        break
                    end
                end
                -- 如果所有需要的线索都已获得，添加到可联想列表
                if canInfer then
                    return answerData.Detective
                end
            end
        end
    end
    return nil
end

-- 拿到一个问题目前缺失的线索的需要联想的线索数量
function M:GetMissingInferAnswersNum(QuestionId)
    local QuestionData = DataMgr["DetectiveQuestion"][QuestionId]
    if not QuestionData or not QuestionData.ProbablyNeededAnswers then
        return 0
    end
    local Avatar = GWorld:GetAvatar()
    local UnlockedAnswersRecord = Avatar.DetectiveGameUnlockedAnswersRecord
    -- 遍历问题可能需要的答案
    for _, answerId in pairs(QuestionData.ProbablyNeededAnswers) do
        -- 检查该答案是否已经获得，如果已获得则跳过
        if not UnlockedAnswersRecord[answerId] then
            local answerData = DataMgr["DetectiveAnswer"][answerId]
            if answerData and answerData.Detective then
                return #answerData.Detective
            end
        end
    end
    return 0
end

-- 拿到一个问题提交答案需要的线索
function M:GetCommitAnswers(QuestionId)
    local QuestionData = DataMgr["DetectiveQuestion"][QuestionId]
    if not QuestionData then
        return {}
    end
    local Avatar = GWorld:GetAvatar()
    local UnlockedAnswers = Avatar.DetectiveGameUnlockedAnswers
    local possibleResults = {}
    -- 遍历所有侦探结果
    for resultId, resultData in pairs(DataMgr["DetectiveResult"]) do
        -- 找到与当前问题匹配的结果
        if resultData.QuestionID == QuestionId then
            -- 检查是否拥有提交这个结果所需的所有线索
            local hasAllAnswers = true
            if resultData.Answers then
                for _, answerId in pairs(resultData.Answers) do
                    if not UnlockedAnswers[answerId] then
                        hasAllAnswers = false
                        break
                    end
                end
            end
            -- 如果拥有所有需要的线索，添加到可能的结果列表
            if hasAllAnswers then
                return resultData.Answers
            end
        end
    end
    return nil
end

-- 拿到一个问题提交答案需要的线索(无需检查是否拥有)
function M:GetCommitFirstAnswers(QuestionId)
    local QuestionData = DataMgr["DetectiveQuestion"][QuestionId]
    if not QuestionData then
        return {}
    end
    -- 遍历所有侦探结果
    for resultId, resultData in pairs(DataMgr["DetectiveResult"]) do
        -- 找到与当前问题匹配的结果
        if resultData.QuestionID == QuestionId then
            return resultData.Answers
        end
    end
    return nil
end

-- 判断一个问题是否已经被解决
function M:IsQuestionSolved(QuestionId)
    local Avatar = GWorld:GetAvatar()
    local UnlockedResults = Avatar.DetectiveGameUnlockedResults
    if not UnlockedResults then
        return false
    end
    for Result, _ in pairs(UnlockedResults) do
        local DetectiveQuestionData = DataMgr["DetectiveResult"][Result]
        if QuestionId == DetectiveQuestionData.QuestionID then
            return true
        end
    end
    return false
end

-- 判断一个问题会解锁新线索
function M:IsQuestionUnlockNewClue(QuestionId)
    local Avatar = GWorld:GetAvatar()
    local UnlockedResults = Avatar.DetectiveGameUnlockedResults
    if not UnlockedResults then
        return false
    end
    for Result, _ in pairs(UnlockedResults) do
        local DetectiveQuestionData = DataMgr["DetectiveResult"][Result]
        if QuestionId == DetectiveQuestionData.QuestionID and DetectiveQuestionData.MainClueUnlock then
            return DetectiveQuestionData.MainClueUnlock
        end
    end
    return false
end

-- 拿一个问题对应结局的线索
function M:GetQuestionResultAnswers(QuestionId)
    local Avatar = GWorld:GetAvatar()
    local UnlockedResults = Avatar.DetectiveGameUnlockedResults
    if not UnlockedResults then
        return nil
    end
    for Result, _ in pairs(UnlockedResults) do
        local DetectiveQuestionData = DataMgr["DetectiveResult"][Result]
        if QuestionId == DetectiveQuestionData.QuestionID then
            return DetectiveQuestionData.Answers
        end
    end
    return nil
end

-- 拿一个问题获得过的线索数量和总问题数量
function M:GetQuestionClueCount(QuestionId)
    local Avatar = GWorld:GetAvatar()
    local UnlockedAnswersRecord = Avatar.DetectiveGameUnlockedAnswersRecord
    if not UnlockedAnswersRecord then
        return 0, 0
    end
    local QuestionData = DataMgr["DetectiveQuestion"][QuestionId]
    if not QuestionData then
        return 0, 0
    end
    local totalClueCount = #QuestionData.ProbablyNeededAnswers
    local currentClueCount = 0
    for AnswerId, _ in pairs(UnlockedAnswersRecord) do
        if self:TableContains(QuestionData.ProbablyNeededAnswers, AnswerId) then
            currentClueCount = currentClueCount + 1
        end
    end
    return currentClueCount, totalClueCount
end

-- 判断一个问题是否有新线索
function M:IsQuestionHasNewClue(QuestionId)
    local Avatar = GWorld:GetAvatar()
    local UnlockedAnswers = Avatar.DetectiveGameUnlockedAnswers
    if not UnlockedAnswers then
        return false
    end

    local QuestionData = DataMgr["DetectiveQuestion"][QuestionId]
    if not QuestionData then
        return false
    end
    if not ReddotManager.GetTreeNode("DetectiveAnswer") then
        ReddotManager.AddNode("DetectiveAnswer")
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("DetectiveAnswer")
    for _, AnswerId in pairs(QuestionData.ProbablyNeededAnswers) do
        if CacheDetail[AnswerId] then
            return true
        end
    end
    return false
end

-- 判断一个问题是否处于可推理状态（可联想或可提交答案）
function M:IsQuestionReasoningState(QuestionId)
    -- 已经完成的问题肯定不是可推理状态
    if self:IsQuestionSolved(QuestionId) then
        return false
    end
    
    -- 检查是否可以联想
    local inferAnswers = self:GetMissingInferAnswers(QuestionId)
    if inferAnswers then
        return true
    end
    
    -- 检查是否可以提交答案
    local commitAnswers = self:GetCommitAnswers(QuestionId)
    if commitAnswers then
        return true
    end
    
    return false
end

-- 判断有无新问题or新线索 
-- 0：啥都没
-- 1：有新问题
-- 2：有新线索
function M:IsHasNewQuestionOrClue(QuestionId)
    if QuestionId == nil then
        return 0
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("DetectiveAnswer")
    if CacheDetail then
        for AnswerId, Value in pairs(CacheDetail) do
            local answerData = DataMgr["DetectiveAnswer"][AnswerId]
            if answerData and answerData.QuestionID == QuestionId and Value then
                return 2
            end
        end
    end

    CacheDetail = ReddotManager.GetLeafNodeCacheDetail("DetectiveQuestion")
    if CacheDetail and CacheDetail[QuestionId] then
        return 1
    end
    return 0
end

-- 判断当前所有问题有没有处于可推理状态
function M:IsAllQuestionReasoningState()
    local Avatar = GWorld:GetAvatar()
    local UnlockedQuestions = Avatar.DetectiveGameUnlockedQuestions
    if not UnlockedQuestions then
        return false
    end
    for QuestionId, _ in pairs(UnlockedQuestions) do
        if self:IsQuestionReasoningState(QuestionId) then
            return true
        end
    end
    return false
end

-- 判断当前所有线索有没有新线索
function M:IsAllClueHasNewClue()
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("DetectiveAnswer")
    if CacheDetail then
        for AnswerId, Value in pairs(CacheDetail) do
            if Value then
                return true
            end
        end
    end
    return false
end

-- 判断当前所有问题有没有新问题
function M:IsAllQuestionHasNewQuestion()
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("DetectiveQuestion")
    if CacheDetail then
        for QuestionId, Value in pairs(CacheDetail) do
            if Value then
                return true
            end
        end
    end
    return false
end

-- 判断一个线索是否是通过其他问题的结果来拿到的
function M:IsClueFromResult(AnswerId)
    -- 遍历所有侦探结果
    for resultId, resultData in pairs(DataMgr["DetectiveResult"]) do
        -- 判断AnswerId是否在resultData.Answers中
        if resultData.MainClueUnlock and self:TableContains(resultData.MainClueUnlock, AnswerId) then
            return resultData.QuestionID
        end
    end
    return nil
end


-- 消除某个问题所有线索的红点
function M:ClearClueReddot(QuestionId)
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("DetectiveAnswer")
    for CacheDetailKey, _ in pairs(CacheDetail) do
        local answerData = DataMgr["DetectiveAnswer"][CacheDetailKey]
        if answerData and answerData.QuestionID == QuestionId then
            CacheDetail[CacheDetailKey] = false
        end
    end
end

function M:GetNeedOpenQuestionIdByIds(AnswerIds, ResultIds)
    local Avatar = GWorld:GetAvatar()
    local UnlockedAnswers = Avatar.DetectiveGameUnlockedAnswers
    local UnlockedResults = Avatar.DetectiveGameUnlockedResults
    
    -- 遍历 ResultIds，找到第一个 Avatar 身上不存在的 Result
    if ResultIds then
        for _, ResultId in pairs(ResultIds) do
            -- 检查 Avatar 身上是否存在这个 Result
            if not UnlockedResults or not UnlockedResults[ResultId] then
                -- 如果不存在，直接从 Result 数据中获取对应的 QuestionId
                local ResultData = DataMgr["DetectiveResult"][ResultId]
                if ResultData and ResultData.QuestionID then
                    return ResultData.QuestionID
                end
            end
        end
    end

    -- 遍历 AnswerIds，找到第一个 Avatar 身上不存在的 Answer
    if AnswerIds then
        for _, AnswerId in pairs(AnswerIds) do
            -- 检查 Avatar 身上是否存在这个 Answer
            if not UnlockedAnswers or not UnlockedAnswers[AnswerId] then
                -- 如果不存在，获取这个 Answer 对应的 QuestionId
                local QuestionId = self:IsClueFromResult(AnswerId)
                if QuestionId then
                    return QuestionId
                end
            end
        end
    end
    
    return nil
end

function M:TableContains(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end

return M