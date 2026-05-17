require "UnLua"

-- 活动主界面进度板
---@type WBP_Activity_SoloTreasure_TaskProgress_C
local SoloTreasureTaskProgress = Class({"BluePrints.UI.BP_EMUserWidget_C"})
local SoloTreasureDataModel = require "BluePrints.UI.WBP.Activity.Widget.SoloTreasure.SoloTreasureDataModel"

function SoloTreasureTaskProgress:Init()
    self:UpdateTaskProgressBoard()
end

function SoloTreasureTaskProgress:UpdateTaskProgressBoard()
    self:LoadDataFromModel()
    self:InitStaticUI()
    self:RefreshProgressBoard(self.UserCurScore)
end

-- 初始化静态UI
function SoloTreasureTaskProgress:InitStaticUI()
    if self.Text_TaskProgress then
        self.Text_TaskProgress:SetText(GText("UI_SoloTreasure_EventProgress"))
    end
end

-- 刷新进度板
function SoloTreasureTaskProgress:RefreshProgressBoard(UserCurScore)
    local Result = SoloTreasureDataModel:GetUserCurrentProgress(UserCurScore, self.SoloTreasureTaskProgressData)
    if not Result then
        DebugPrint(ErrorTag, "------------ [TaskProgress] 用户当前进度数据请求失败 ------------")
        return
    end
    if self.Num_Now then
        if Result.CurStageIndex then
            self.Num_Now:SetText(tostring(Result.CurStageIndex))
        else
            DebugPrint(ErrorTag, "------------ [TaskProgress] CurStageIndex is nil ------------")
        end
    end

    if self.Text_Title then
        if Result.CurRow and Result.CurRow.EventProgressText then
            self.Text_Title:SetText(GText(Result.CurRow.EventProgressText))
        else
            DebugPrint(ErrorTag, "------------ [TaskProgress] BoardState is nil ------------")
        end
    end
end

-- 加载数据
function SoloTreasureTaskProgress:LoadDataFromModel()
    local SoloTreasureEventId = SoloTreasureDataModel:GetEventId()
    if SoloTreasureEventId then
        self.EventId = SoloTreasureEventId
    else
        DebugPrint(ErrorTag, "------ [TaskProgress] EventId is nil")
    end

    local SoloTreasureTaskProgressData = SoloTreasureDataModel:GetTreasureHuntProgressData(self.EventId)
    if SoloTreasureTaskProgressData then
        self.SoloTreasureTaskProgressData = SoloTreasureTaskProgressData
    else
        DebugPrint(ErrorTag, "------ [TaskProgress] SoloTreasureTaskProgressData is nil")
    end

    local UserCurScore = SoloTreasureDataModel:GetUserCurrentScore(SoloTreasureEventId)
    if UserCurScore then
        self.UserCurScore = UserCurScore
    else
        DebugPrint(ErrorTag, "------ [TaskProgress] UserCurScore is nil")
    end
end

return SoloTreasureTaskProgress
