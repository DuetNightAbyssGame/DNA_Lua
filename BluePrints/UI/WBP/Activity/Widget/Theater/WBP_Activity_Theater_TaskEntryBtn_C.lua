--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_Theater_TaskEntryBtn_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

function M:Construct()
    self.Text_Title01:SetText(GText("TheaterOnline_Game_Name"))
    self.Text_Title02:SetText(GText("TheaterOnline_Game_Interactor"))
    self:AddTimer(1, self.CountDown, true, -1, "TheaterTaskEntryBtnCountDown")
    local Avatar = GWorld:GetAvatar()
    Avatar:TheaterDonationGet(function(ErrCode,Ret)
        DebugPrint("TheaterDonationGet",ErrorCode:Name(ErrCode))
        if Ret then
            local tempString = string.format("<Default>%d</>/3", Ret.CurStep)
            self.Text_Stage:SetText(string.format(GText("UI_Theater_Donate_Step"), tempString))
            if Ret.CurStep == 3 and Ret.IsFinished == true then
                self.Panel_Finish:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                self.Text_Title02:SetText(GText("UI_Theater_Donate_Finish"))
            else
                self.Panel_Finish:SetVisibility(UE4.ESlateVisibility.Collapsed)
            end
        end
    end)
end

function M:Destruct()
    self:RemoveTimer("TheaterTaskEntryBtnCountDown")
end

function M:CountDown()
    local RemainingSeconds, CompletedActivities = self:GetNextActivityInfo()
    
    -- 判断是否在小游戏的持续时间内
    if RemainingSeconds == nil then
        -- 在持续时间内，隐藏时间文本，显示已开始文本
        self.Text_Time:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Text_Time_Right:SetText(GText("UI_Theater_Started"))
        self.Text_Time_Right:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        -- 不在持续时间内，显示倒计时
        self.Text_Time:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        
        -- 转换为分钟和秒
        local Minutes = math.floor(RemainingSeconds / 60)
        local Seconds = RemainingSeconds % 60
        local TimeStr = string.format("%02d:%02d", Minutes, Seconds)
        
        -- 切分 UI_Theater_Start 文本："%s后开始"
        local StartTextTemplate = GText("UI_Theater_Start")
        local StartPercentSIndex = string.find(StartTextTemplate, "%%s")
        
        if StartPercentSIndex then
            -- 切分文本：%s 后面的部分
            local TimeRightText = string.sub(StartTextTemplate, StartPercentSIndex + 2)
            
            -- 设置时间文本
            self.Text_Time:SetText(TimeStr)
            
            -- 设置右侧文本，如果为空则隐藏
            if TimeRightText and TimeRightText ~= "" then
                self.Text_Time_Right:SetText(TimeRightText)
                self.Text_Time_Right:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            else
                self.Text_Time_Right:SetVisibility(UE4.ESlateVisibility.Collapsed)
            end
        else
            -- 如果没有找到 %s，则使用原来的方式
            self.Text_Time:SetText(string.format(StartTextTemplate, TimeStr))
            self.Text_Time_Right:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end
    
    -- 切分 UI_Theater_Round 文本："第%s轮"
    -- 如果 CompletedActivities 为 nil，需要重新计算（持续时间内的情况）
    if CompletedActivities == nil then
        local CurrentTime = os.time()
        local CurrentDate = os.date("*t", CurrentTime)
        local MinutesSinceMidnight = CurrentDate.hour * 60 + CurrentDate.min
        CompletedActivities = math.floor(MinutesSinceMidnight / 30)
    end
    
    local RoundTextTemplate = GText("UI_Theater_Round")
    local RoundValue = CompletedActivities .. "/" .. 48
    local PercentSIndex = string.find(RoundTextTemplate, "%%s")
    
    if PercentSIndex then
        -- 切分文本：%s 前面的部分和 %s 后面的部分
        local LeftText = string.sub(RoundTextTemplate, 1, PercentSIndex - 1)
        local RightText = string.sub(RoundTextTemplate, PercentSIndex + 2)
        
        -- 设置左侧文本，如果为空则隐藏
        if LeftText and LeftText ~= "" then
            self.Text_Num_Left:SetText(LeftText)
            self.Text_Num_Left:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        else
            self.Text_Num_Left:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        
        -- 设置中间数值
        self.Text_Num:SetText(RoundValue)
        
        -- 设置右侧文本，如果为空则隐藏
        if RightText and RightText ~= "" then
            self.Text_Num_Right:SetText(RightText)
            self.Text_Num_Right:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        else
            self.Text_Num_Right:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    else
        -- 如果没有找到 %s，则使用原来的方式
        self.Text_Num:SetText(string.format(RoundTextTemplate, RoundValue))
        self.Text_Num_Left:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Text_Num_Right:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function M:GetNextActivityInfo()
    local GameTotalTime = 380
    local Step12Time = DataMgr.TheaterConstant.Step12.ConstantValue
    if Step12Time then
        GameTotalTime = Step12Time
    end
    -- 获取当前时间
    local CurrentTime = os.time()
    local CurrentDate = os.date("*t", CurrentTime)
    
    -- 计算从零点开始到现在经过的分钟数
    local MinutesSinceMidnight = CurrentDate.hour * 60 + CurrentDate.min
    
    -- 计算已经举行的活动次数（每30分钟一次）
    local CompletedActivities = math.floor(MinutesSinceMidnight / 30)
    
    -- 计算当前活动周期的开始时间（分钟数）
    local CurrentActivityStartMinutes = CompletedActivities * 30
    
    -- 计算当前时间从零点开始的秒数
    local CurrentSecondsSinceMidnight = MinutesSinceMidnight * 60 + CurrentDate.sec
    
    -- 计算当前活动周期的开始时间（秒数）
    local CurrentActivityStartSeconds = CurrentActivityStartMinutes * 60
    
    -- 计算当前活动周期的结束时间（秒数）
    local CurrentActivityEndSeconds = CurrentActivityStartSeconds + GameTotalTime
    
    -- 判断当前时间是否在小游戏的持续时间内
    if CurrentSecondsSinceMidnight >= CurrentActivityStartSeconds and CurrentSecondsSinceMidnight < CurrentActivityEndSeconds then
        return nil, nil
    end
    
    -- 计算下一次活动的开始时间（分钟数）
    local NextActivityMinutes = (CompletedActivities + 1) * 30
    
    -- 计算到下一次活动的剩余分钟数
    local RemainingMinutes = NextActivityMinutes - MinutesSinceMidnight
    
    -- 如果剩余分钟数为0，说明正好是活动时间
    if RemainingMinutes == 0 then
        RemainingMinutes = 30
    end
    
    -- 转换为秒数并减去当前秒数
    local RemainingSeconds = RemainingMinutes * 60 - CurrentDate.sec
    
    -- 确保不为负数
    if RemainingSeconds < 0 then
        RemainingSeconds = 0
    end
    
    return RemainingSeconds, CompletedActivities
end

function M:Init(ActivityConfigData, PageConfigData, PlayerAvatar)
    self.EventId = ActivityConfigData.EventId
end

return M
