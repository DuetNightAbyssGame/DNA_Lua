---@class FTalkTriggerComponent
local FTalkTriggerComponent = {}

---@return FTalkTriggerComponent
function FTalkTriggerComponent:New()
    local TalkTriggerComponent = setmetatable({}, {
        __index = FTalkTriggerComponent
    })
    return TalkTriggerComponent
end

---@param TalkTriggerData table<string, any>
---@return boolean
function FTalkTriggerComponent:IsNormal(TalkTriggerData)
    return TalkTriggerData and TalkTriggerData.Type == nil
end

---@param TalkTriggerData table<string, any>
---@return boolean
function FTalkTriggerComponent:IsSideQuest(TalkTriggerData)
    return TalkTriggerData and TalkTriggerData.Type == "SideQuest"
end

---@param TalkTriggerData table<string, any>
---@return boolean
function FTalkTriggerComponent:IsImpression(TalkTriggerData)
    return TalkTriggerData and TalkTriggerData.Type == "Impression"
end

---@param TalkTriggerData table<string, any>
---@return boolean
function FTalkTriggerComponent:CanTrigger(TalkTriggerData)
    if (TalkTriggerData == nil) then
        return false
    end
    local TalkTriggerId = TalkTriggerData.TalkTriggerId

    if self:IsImpression(TalkTriggerData) then
        local Avatar = GWorld:GetAvatar()
        if (Avatar == nil) or Avatar:IsStorylineComplete(TalkTriggerId) then
            return false
        end
    end
    return self:CheckCondition(TalkTriggerData.TalkTriggerId)
end

-- ---@param TalkTriggerData table<string, any>
-- ---@return table<string, any>
-- function FTalkTriggerComponent:NewConditionWithImprUncomp(TalkTriggerData)
--     local Condition = {
--         And = { {
--                     ImprUncomp = {
--                         TalkTriggerId = TalkTriggerData.TalkTriggerId
--                     }
--                 } }
--     }
--     if TalkTriggerData.TriggerCondition then
--         for Func, Params in pairs(TalkTriggerData.TriggerCondition) do
--             table.insert(Condition.And, {
--                 [Func] = Params
--             })
--         end
--     end
--     return Condition
-- end

---@param TalkTriggerId integer
---@return boolean
function FTalkTriggerComponent:CheckCondition(TalkTriggerId)
    local StorySubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UStorySubsystem:StaticClass())
    if not StorySubsystem then return false end
    return StorySubsystem:CheckTalkTriggerCondition(TalkTriggerId)
end

---@param DialogueId integer
---@return boolean
function FTalkTriggerComponent:CheckDialogueCondition(DialogueId)
    local StorySubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UStorySubsystem:StaticClass())
    --DebugPrint("TTT: CheckCondition1", DialogueId)
    if not StorySubsystem then return false end
    --DebugPrint("TTT: CheckCondition2", DialogueId)
    return StorySubsystem:CheckDialogueCondition(DialogueId)
end

---@param Guid FGuid
---@param Index integer
---@return boolean
function FTalkTriggerComponent:CheckFlowCondition(Guid, Index)
    local StorySubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UStorySubsystem:StaticClass())
    --DebugPrint("TTT: CheckCondition1", DialogueId)
    if not StorySubsystem then return false end
    --DebugPrint("TTT: CheckCondition2", DialogueId)
    return StorySubsystem:CheckFlowCondition(Guid, Index)
end

return FTalkTriggerComponent


-- ---@param Conditions table<string, any>
-- function FTalkTriggerComponent:And(Conditions)
--     for _, Condition in pairs(Conditions) do
--         for Func, Params in pairs(Condition) do
--             if (self[Func](self, Params) == false) then
--                 return false
--             end
--         end
--     end
--     return true
-- end

-- ---@param Conditions table<string, any>
-- function FTalkTriggerComponent:Or(Conditions)
--     for _, Condition in pairs(Conditions) do
--         for Func, Params in pairs(Condition) do
--             if (self[Func](self, Params) == true) then
--                 return true
--             end
--         end
--     end
--     return false
-- end

-- ---@param Condition table<string, any>
-- function FTalkTriggerComponent:Not(Condition)
--     for Func, Params in pairs(Condition) do
--         return not self[Func](self, Params)
--     end
-- end

-- ---@param Params table<string, any>
-- function FTalkTriggerComponent:ImprFail(Params)
--     local TalkTriggerId = Params.TalkTriggerId
--     local Avatar = GWorld:GetAvatar()
--     if (Avatar == nil) then
--         return false
--     end
--     local RtnRes = Avatar:IsStorylineFailure(TalkTriggerId)
--     -- DebugPrint("TTT: ImprFail", TalkTriggerId, StorylineId, RtnRes)
--     return RtnRes
-- end

-- ---@param Params table<string, any>
-- function FTalkTriggerComponent:ImprSucc(Params)
--     local TalkTriggerId = Params.TalkTriggerId
--     local Avatar = GWorld:GetAvatar()
--     if (Avatar == nil) then
--         return false
--     end
--     local RtnRes = Avatar:IsStorylineSuccess(TalkTriggerId)
--     -- DebugPrint("TTT: ImprSucc", TalkTriggerId, StorylineId, RtnRes)
--     return RtnRes
-- end

-- ---@param Params table<string, any>
-- function FTalkTriggerComponent:ImprComp(Params)
--     local TalkTriggerId = Params.TalkTriggerId
--     local Avatar = GWorld:GetAvatar()
--     if (Avatar == nil) then
--         return false
--     end
--     local RtnRes = Avatar:IsStorylineComplete(TalkTriggerId)
--     -- DebugPrint("TTT: ImprComp", TalkTriggerId, StorylineId, RtnRes)
--     return RtnRes
-- end

-- ---@param Params table<string, any>
-- function FTalkTriggerComponent:ImprUncomp(Params)
--     local TalkTriggerId = Params.TalkTriggerId
--     local Avatar = GWorld:GetAvatar()
--     if (Avatar == nil) then
--         return false
--     end
--     local RtnRes = Avatar:IsStorylineUnComplete(TalkTriggerId)
--     -- DebugPrint("TTT: ImprUncomp", TalkTriggerId, StorylineId, RtnRes)
--     return RtnRes
-- end

-- ---@param Params table<string, any>
-- function FTalkTriggerComponent:QuestUnstart(Params)
--     local QuestId = Params.QuestId
--     local Avatar = GWorld:GetAvatar()
--     if (Avatar == nil) then
--         return false
--     end
--     local RtnRes = (not Avatar:IsQuestDoing(QuestId)) and (not Avatar:IsQuestFinished(QuestId))
--     -- DebugPrint("TTT: QuestUnstart", QuestId, RtnRes)
--     return RtnRes
-- end

-- ---@param Params table<string, any>
-- function FTalkTriggerComponent:QuestStart(Params)
--     local QuestId = Params.QuestId
--     local Avatar = GWorld:GetAvatar()
--     if (Avatar == nil) then
--         return false
--     end
--     local RtnRes = Avatar:IsQuestDoing(QuestId)
--     -- DebugPrint("TTT: QuestStart", QuestId, RtnRes)
--     return RtnRes
-- end

-- ---@param Params table<string, any>
-- function FTalkTriggerComponent:QuestFinish(Params)
--     local QuestId = Params.QuestId
--     local Avatar = GWorld:GetAvatar()
--     if (Avatar == nil) then
--         return false
--     end
--     local RtnRes = Avatar:IsQuestFinished(QuestId)
--     -- DebugPrint("TTT: QuestFinish", QuestId, RtnRes)
--     return RtnRes
-- end

-- ---@param Params table<string, any>
-- function FTalkTriggerComponent:QuestChainLock(Params)
--     local QuestChainId = Params.QuestChainId
--     local Avatar = GWorld:GetAvatar()
--     if (Avatar == nil) then
--         return false
--     end
--     local RtnRes = Avatar:IsQuestChainLock(QuestChainId)
--     -- DebugPrint("TTT: QuestChainLock", QuestChainId, RtnRes)
--     return RtnRes
-- end

-- ---@param Params table<string, any>
-- function FTalkTriggerComponent:QuestChainUnlock(Params)
--     local QuestChainId = Params.QuestChainId
--     local Avatar = GWorld:GetAvatar()
--     if (Avatar == nil) then
--         return false
--     end
--     local RtnRes = Avatar:IsQuestChainUnlock(QuestChainId)
--     -- DebugPrint("TTT: QuestChainUnlock", QuestChainId, RtnRes)
--     return RtnRes
-- end

-- ---@param Params table<string, any>
-- function FTalkTriggerComponent:QuestChainUnstart(Params)
--     local QuestChainId = Params.QuestChainId
--     local Avatar = GWorld:GetAvatar()
--     if (Avatar == nil) then
--         return false
--     end
--     local RtnRes = (not Avatar:IsQuestChainDoing(QuestChainId)) and (not Avatar:IsQuestFinished(QuestChainId))
--     -- DebugPrint("TTT: QuestChainUnstart", QuestChainId, RtnRes)
--     return RtnRes
-- end

-- ---@param Params table<string, any>
-- function FTalkTriggerComponent:QuestChainStart(Params)
--     local QuestChainId = Params.QuestChainId
--     local Avatar = GWorld:GetAvatar()
--     if (Avatar == nil) then
--         return false
--     end
--     local RtnRes = Avatar:IsQuestChainDoing(QuestChainId)
--     -- DebugPrint("TTT: QuestChainStart", QuestChainId, RtnRes)
--     return RtnRes
-- end

-- ---@param Params table<string, any>
-- function FTalkTriggerComponent:QuestChainFinish(Params)
--     local QuestChainId = Params.QuestChainId
--     local Avatar = GWorld:GetAvatar()
--     if (Avatar == nil) then
--         return false
--     end
--     local RtnRes = Avatar:IsQuestFinished(QuestChainId)
--     -- DebugPrint("TTT: QuestChainFinish", QuestChainId, RtnRes)
--     return RtnRes
-- end

-- ---@param Params table<string, any>
-- function FTalkTriggerComponent:VarEqual(Params)
--     local Name = Params.Name
--     local Value = Params.Value
--     local StorySubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UStorySubsystem)
--     if (StorySubsystem == nil) then
--         return false
--     end
--     local QueryValue = StorySubsystem:GetInt(Name)
--     local RtnRes = QueryValue == Value
--     --DebugPrint("TTT: VarEqual", Name, Value, QueryValue, RtnRes)
--     return RtnRes
-- end

-- return FTalkTriggerComponent
