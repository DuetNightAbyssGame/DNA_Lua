local BattlePassUtils = {}

local BattlePassController = require "BluePrints.UI.WBP.BattlePass.Controller.BattlePassController"
local TimeUtils = require "Utils.TimeUtils"
--function BattlePassUtils:IsSystemShowRedDot()
--    DebugPrint("gmy@BattlePassUtils BattlePassUtils:IsSystemShowRedDot")
--
--    ReddotManager.GetTreeNode("BattlePass")
--    return false
--end

function BattlePassUtils:GetLevel()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        return Avatar.BattlePassLevel
    end
    return 0
end

function BattlePassUtils:GetMaxLevelReal()
    local Avatar = GWorld:GetAvatar()
    if Avatar and Avatar.BattlePassVersion ~= 0 then
        local BattlePassData = DataMgr.BattlePassMain[Avatar.BattlePassVersion]
        if BattlePassData and BattlePassData.LoopRewardPeriod and BattlePassData.LevelLimit then
            return BattlePassData.LevelLimit
        end
    end
    return self:GetMaxLevel()
end

function BattlePassUtils:GetMaxLevel()
    local Avatar = GWorld:GetAvatar()
    if Avatar and Avatar.BattlePassVersion ~= 0 then
        local BattlePassReward = self:GetBattlePassReward(Avatar.BattlePassVersion)
        return #(BattlePassReward or {})
    end
    return 0
end

function BattlePassUtils:IsMaxLevel()
    local MaxLevel = self:GetLoopMaxLevel()
    if MaxLevel <= 0 then
        MaxLevel = self:GetMaxLevel()
    end
    return self:GetLevel() >= MaxLevel
end

function BattlePassUtils:GetBattlePassReward(BattlePassVersion)
	local BattlePassData = DataMgr.BattlePassMain[BattlePassVersion]
	if not BattlePassData then
		return nil
	end
	local BPRewardTemplateID = BattlePassData.BPRewardTemplateID
	if not BPRewardTemplateID then
		return nil
	end
	local BattlePassReward = DataMgr.BattlePassReward[BPRewardTemplateID]
	return BattlePassReward
end

-- @description 获取当前循环的最大等级，前NormalMaxLevel级为第一个循环，后续每LoopRewardPeriod级为一个循环
-- @return number
function BattlePassUtils:GetCurLoopMaxLevel()
    local Avatar = GWorld:GetAvatar()
    local NormalMaxLevel = self:GetMaxLevel()
    local CurLevel = self:GetLevel()
    if CurLevel < NormalMaxLevel then
        return NormalMaxLevel
    end
    local BattlePassMain = Avatar and DataMgr.BattlePassMain[Avatar.BattlePassVersion] or nil
    local LoopMaxLevel = BattlePassMain.LevelLimit or 0
    local LoopRewardPeriod = BattlePassMain.LoopRewardPeriod or 0
    local CurLoopMaxLevel = NormalMaxLevel
    if CurLevel > 0 and NormalMaxLevel > 0 and LoopRewardPeriod > 0 and LoopMaxLevel > 0 then
        local delta = CurLevel - NormalMaxLevel
        local loopIndex = math.floor(delta / LoopRewardPeriod)
        CurLoopMaxLevel = NormalMaxLevel + (loopIndex + 1) * LoopRewardPeriod
        if CurLoopMaxLevel > LoopMaxLevel then
            CurLoopMaxLevel = LoopMaxLevel
        end
    end
    return CurLoopMaxLevel or 0
end

function BattlePassUtils:GetLoopMaxLevel()
    local Avatar = GWorld:GetAvatar()
    local BattlePassMain = Avatar and DataMgr.BattlePassMain[Avatar.BattlePassVersion] or nil
    local LoopMaxLevel = BattlePassMain and BattlePassMain.LevelLimit or 0
    return LoopMaxLevel
end

---@param TaskId number
function BattlePassUtils:IsIgnoreTaskReddot(TaskId)
    local IgnoreResourceIds = {
        [0] = false,
        [2002] = true,
    }

    local TaskData = DataMgr.BattlePassTask[TaskId]
    if not TaskData or not TaskData.QuestReward or not next(TaskData.QuestReward) then return false end
    local TaskRewardDataList = {}
    for _, QuestReward in pairs(TaskData.QuestReward) do
        local TaskRewardData = DataMgr.Reward[QuestReward]
        if TaskRewardData and next(TaskRewardData) then
            table.insert(TaskRewardDataList, TaskRewardData)
        end
    end
    if not TaskRewardDataList or not next(TaskRewardDataList) then return false end
    local bHasIgnoreResource = false
    local bHasOtherReward = false
    for _, TaskRewardData in ipairs(TaskRewardDataList) do
        local RewardIds = TaskRewardData.Id
        local RewardCounts = TaskRewardData.Count
        local RewardTypes = TaskRewardData.Type
        for i, RewardType in ipairs(RewardIds) do
            local RewardId = RewardIds[i] or 0
            local RewardCount = RewardCounts[i] and RewardCounts[i][1] or 0
            local RewardType = RewardTypes[i] or ""
            if RewardType == "Resource" and IgnoreResourceIds[RewardId] and RewardCount > 0 then
                bHasIgnoreResource = true
            else
                bHasOtherReward = true
            end
        end
    end

    if bHasIgnoreResource and not bHasOtherReward and self:IsReachWeeklyMaxExp() then
        return true
    end
    return false
end 

---@return boolean @当周战令可获取经验是否达到上限
function BattlePassUtils:IsReachWeeklyMaxExp()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    local BattlePassInfo = DataMgr.BattlePassMain[Avatar.BattlePassVersion]
    if not BattlePassInfo then
        return false
    end
    local WeeklyMaxExp = BattlePassInfo.WeeklyMaxExp or 0
    local WeeklyNowExp = Avatar.BattlePassWeeklyExp or 0
    return WeeklyNowExp >= WeeklyMaxExp
end

local BATTLE_PASS_END_TIME_REMIND_POPUP = 100010  -- 通用"提示"确认弹窗（确定/取消）

-- 临期提醒：若战令剩余时间不足则先弹二次确认，用户确认后再执行 OpenFunc
-- @param Owner  调用方 Widget，用于 UIManager 上下文
-- @param OpenFunc  用户确认后执行的函数
function BattlePassUtils:TryOpenWithEndTimeReminder(Owner, OpenFunc)
    if self:ShouldShowEndTimeReminder() then
        local RemainTimeStr = self:GetBattlePassRemainTimeStr()
        local Params = {
            ShortText = string.format(GText("UI_BattlePass_EndTimeReminder"), RemainTimeStr),
            RightCallbackFunction = function()
                OpenFunc()
            end,
        }
        UIManager(Owner):ShowCommonPopupUI(BATTLE_PASS_END_TIME_REMIND_POPUP, Params)
    else
        OpenFunc()
    end
end

-- 是否需要弹出战令临期购买二次确认
-- @return boolean
function BattlePassUtils:ShouldShowEndTimeReminder()
    local EndTime = BattlePassController:GetModelData("BattlePassEndTime")
    if not EndTime then return false end
    local RemindHours = DataMgr.GlobalConstant.BattlePassEndRemindTime.ConstantValue
    local RemainSeconds = EndTime - TimeUtils.NowTime()
    return RemainSeconds > 0 and RemainSeconds < RemindHours * 3600
end

-- 获取战令剩余时间的可读字符串，用于填入二次确认文本的 %s
-- @return string  例如 "3天2小时"
function BattlePassUtils:GetBattlePassRemainTimeStr()
    local EndTime = BattlePassController:GetModelData("BattlePassEndTime")
    if not EndTime then return "" end
    return UIUtils.GetLeftTimeStrStyle1(EndTime)
end

return BattlePassUtils
