--
-- DESCRIPTION
-- 双倍Mod活动View （PC、移动端公用）
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local ActivityController = require "BluePrints.UI.WBP.Activity.ActivityController"
local M = {}

function M:GetDoubleModDropData()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return nil
    end

    local curEventId = ActivityController:GetDoubleModDropEventID()

    local defaultData = {
        EventId        = curEventId,
        DropTimes      = 0,
        EliteRushTimes = 0,
    }

    self.DoubleModDrop = Avatar.DoubleModDrop
    if not self.DoubleModDrop then
        return defaultData
    end

    local result = nil

    for _, value in pairs(self.DoubleModDrop) do
        local props = value.Props
        if props and props.EventId == curEventId then
            result = {
                EventId        = props.EventId        or curEventId,
                DropTimes      = props.DropTimes      or 0,
                EliteRushTimes = props.EliteRushTimes or 0,
            }
            break
        end
    end

    -- 服务器如果有当前活动的curEventId数据那么就使用 不然就走默认的
    if not result then
        result = defaultData
    end

    return result
end

function M:IsDoubleMod()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    if not self:IsPrerequisiteSatisfied() then
        return false
    end
    local EventId = ActivityController:GetDoubleModDropEventID()
    if (Avatar.ActivityTimeOpen and Avatar.ActivityTimeOpen[EventId]) then
		-- 活动在服务端处于开启时间
		return true
    end
    return false
end

-- 是否满足前置任务
function M:IsPrerequisiteSatisfied()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end

    local EventId = ActivityController:GetDoubleModDropEventID()
    local DoubleModEventInfo = DataMgr.EventMain[EventId]
    if not DoubleModEventInfo then
        --ScreenPrint("EventMain表中找不到m魔之楔活动相关信息！读取的EventId:"..100202)
        return false
    end

    local PrerequisiteQuestId = {}
    if DoubleModEventInfo.PretextTasks1 then
        table.insert(PrerequisiteQuestId, DoubleModEventInfo.PretextTasks1)
    end
    for _, QuestId in pairs(DoubleModEventInfo.PretextTasks2 or {}) do
        table.insert(PrerequisiteQuestId, QuestId)
    end

    for _, QuestId in pairs(PrerequisiteQuestId) do
        -- local QuestChain = Avatar.QuestChains[QuestId]
        -- -- 不合法输入，报错
        -- if not QuestChain then
        --     ScreenPrint("魔之楔 配置了一个不存在的任务链Id！请策划检查！Id:"..QuestId)
        --     return false
        -- end
        -- -- 存在未完成，直接返回错误
        -- if not QuestChain:IsFinish() then
        --     return false
        -- end
        local IsQuestFinished = Avatar:IsQuestFinished(QuestId)
        local IsQuestAssumeFinished = Avatar:IsQuestAssumeFinished(QuestId)
        if (not IsQuestFinished) and (not IsQuestAssumeFinished) then
            return false
        end
    end
    return true
end

return M