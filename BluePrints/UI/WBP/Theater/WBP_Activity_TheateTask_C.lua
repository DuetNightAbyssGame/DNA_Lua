--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_TheaterTask_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

function M:Construct()
    self.RegionId = nil
end

function M:InitUI()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self.RegionId = Avatar:GetCurrentRegionId()
    self.Text_Title:SetText(GText("TheaterOnline_Game_Name"))
    self.Text_Progress:SetText(GText("TheaterOnline_Game_Waiting"))
    
    local CurrentTime = TimeUtils.NowTime()
    local RemainTime = self:CalculateRemainTimeToNextHour()

    local TargetTime = CurrentTime + RemainTime
    local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(TargetTime)
    self.WBP_Com_Time:SetTimeText("", RemainTimeDict)
    
    self:StartCountdownTimer()
end

function M:InitFailUI()
    self.JoinCountDown = true
    self.Text_Title:SetText(GText("TheaterOnline_Game_Name"))
    self.Text_Progress:SetText(GText("TheaterOnline_Game_Sign_Waiting"))
    local CurrentTime = TimeUtils.NowTime()
    local RemainTime = self:CalculateRemainTimeToAvailableJoin()

    local TargetTime = CurrentTime + RemainTime
    local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(TargetTime)
    self.WBP_Com_Time:SetTimeText("", RemainTimeDict)

    self:StartCountdownTimer()
end

function M:CalculateRemainTimeToNextHour()
    local CurrentTime = TimeUtils.NowTime()
    local CurrentDateTime = os.date("*t", CurrentTime)
    
    local CurrentMinutes = CurrentDateTime.min
    local CurrentSeconds = CurrentDateTime.sec
    
    local CurrentTotalSeconds = CurrentMinutes * 60 + CurrentSeconds
    
    local NextTargetSeconds
    if CurrentTotalSeconds <= 30 * 60 then
        NextTargetSeconds = 30 * 60
    else
        NextTargetSeconds = 60 * 60
    end
    
    return NextTargetSeconds - CurrentTotalSeconds
end

function M:CalculateRemainTimeToAvailableJoin()
    local NpcInteractON = DataMgr.TheaterConstant.NpcInteractON.ConstantValue
    local CurrentTime = TimeUtils.NowTime()

    if (CurrentTime % 1800) <=  NpcInteractON then
        return NpcInteractON - (CurrentTime % 1800)
    end
    return 0
end

function M:StartCountdownTimer()
    -- 清除之前的定时器
    if self.CountdownTimer then
        self:RemoveTimer(self.CountdownTimer)
    end
    
    -- 每秒更新一次倒计时
    self.CountdownTimer = self:AddTimer(1.0, function()
        self:UpdateCountdown()
    end, true, 0, "TheaterCountdown", true)
end

function M:UpdateCountdown()
    local CurrentTime = TimeUtils.NowTime()
    local RemainTime
    if self.JoinCountDown then
        RemainTime = self:CalculateRemainTimeToAvailableJoin()
    else
        RemainTime = self:CalculateRemainTimeToNextHour()
    end
    
    if RemainTime <= 0 then
        -- 清除定时器
        if self.CountdownTimer then
            self:RemoveTimer(self.CountdownTimer)
            self.CountdownTimer = nil
        end
        self:Close()
    else
        -- 更新倒计时显示
        local TargetTime = CurrentTime + RemainTime
        local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(TargetTime)
        self.WBP_Com_Time:SetTimeText("", RemainTimeDict)
    end

    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local RegionId = Avatar.CurrentRegionId
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
    if not GameState:IsInRegion() or RegionId ~= 101901 or Avatar:IsInHardBoss() then
        -- 离开剧院 进副本时卸载UI
        self:Close()
    elseif Avatar:IsInHardBoss() then
        -- 单机梦魇残生时不卸载UI，只隐藏
        self:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
end

function M:Close()
    local BattleMain = UIManager(self):GetUI("BattleMain")
    if BattleMain then
        if BattleMain.TheaterCheckTimer then
            BattleMain:RemoveTimer(BattleMain.TheaterCheckTimer)
            BattleMain.TheaterCheckTimer = nil
        end
    end
    if self.CountdownTimer then
        self:RemoveTimer(self.CountdownTimer)
        self.CountdownTimer = nil
    end
    
	self.IsInit = true
    self.Super.Close(self)
end


return M
