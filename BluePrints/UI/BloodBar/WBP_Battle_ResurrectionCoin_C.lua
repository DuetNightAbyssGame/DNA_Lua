--
-- DESCRIPTION
-- 血条右侧状态图标
-- @COMPANY HERO GAMES @PAN.Studio
-- @AUTHOR Laixiaoyang
-- @DATE ${date} ${time}
--

---@type WBP_Battle_ResurrectionCoin_C
local M = Class({"BluePrints.Common.TimerMgr","BluePrints.UI.BP_EMUserWidget_C"})

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Init(Owner, PlayerState)
    self.Owner = Owner
    self.PlayerState = PlayerState
    self.CurState = "Dead"
    self.StateCheckUpdateTime = 1.0      -- 状态检查时间
    self:RefreshUIInfo()
    self:StartStateChange()
end

function M:Clear()
    if (self.CurState == "Alive") then
        return
    end
    self.CurState = "Alive"
    self:UnbindAllFromAnimationFinished(self.UseCoin)
    self:UnbindAllFromAnimationFinished(self.Return)

    local RemainTimes = self:GetRemainRecoveryTimes()
    self.Num_Resurrection:SetText(RemainTimes)
    local function EndRecovering()
        if (RemainTimes <= 0) then
            -- self:PlayAnimation(self.Forbidden)
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Forbidden)
        else
            -- self:PlayAnimation(self.Normal)
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
        end
    end
    self:BindToAnimationFinished(self.Return, {self, EndRecovering})
    -- self:PlayAnimation(self.Return)
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Return)
    self:EndStateChange()
end

function M:RefreshUIInfo()
    local RemainTimes = self:GetRemainRecoveryTimes()
    self.Num_Resurrection_Used:SetText(RemainTimes)
    self.Num_Resurrection:SetText(RemainTimes)
    -- self:PlayAnimation(self.Normal)
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
end

function M:GetRemainRecoveryTimes()
    local RemainTimes = 0
    if (IsValid(self.Owner)) then
        RemainTimes = self.Owner:GetRemainRecoveryTimes()
    elseif (IsValid(self.PlayerState)) then
        if self.PlayerState.RecoveryCount and self.PlayerState.RecoveryMaxCount then 
            RemainTimes = self.PlayerState.RecoveryMaxCount - self.PlayerState.RecoveryCount 
        end
    end
    return math.max(0, RemainTimes)
end

function M:StartStateChange()
    self:Update()
    self:AddTimer(self.StateCheckUpdateTime, self.Update, true, 0, "CheckState", true)
end

function M:EndStateChange()
    if(self:IsExistTimer("CheckState")) then
        self:RemoveTimer("CheckState")
    end
end

function M:Update()
    local NowState = self.CurState
    if (IsValid(self.Owner)) then
        if (self.Owner:IsRecoveringByOther()) then
            -- 正在被其他人救
            NowState = "RecoveringByOther"
        elseif (self.Owner:IsRecoveredBySelf()) then
            -- 自救
            NowState = "RecoveredBySelf"
        end
    elseif (IsValid(self.PlayerState)) then
        if (NowState == "Dead" and self.PlayerState.TeamRecoveryState == UE4.ETeamRecoveryState.IsWaitingRecover and self.PlayerState.RecoverySpeed > 0) then
            -- 目前PlayerState上没办法判断是否救助的类型，暂且都认为自救
            NowState = "RecoveredBySelf"
        end
    else
        self:Clear()
        return
    end
    if (NowState == self.CurState) then
        -- 还是原来的状态
        return
    end

    if (NowState == "RecoveringByOther") then
        if (EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.Save_Self)) then
            -- 被队友救助之后只播放队友救助特效，停止自救特效
            -- self:StopAnimation(self.Save_Self)
            EMUIAnimationSubsystem:EMStopAnimation(self, self.Save_Self)
        end
        -- self:PlayAnimation(self.Save_Teamate)
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Save_Teamate)
    elseif (NowState == "RecoveredBySelf") then
        local function StartRecoveringBySelf()
            -- self:PlayAnimation(self.Save_Self)
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Save_Self)
        end
        self:BindToAnimationFinished(self.UseCoin, {self, StartRecoveringBySelf})
        -- self:PlayAnimation(self.UseCoin)
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.UseCoin)
    end
    self.CurState = NowState
end

--function UID_C:Tick(MyGeometry, InDeltaTime)
--end

return M
