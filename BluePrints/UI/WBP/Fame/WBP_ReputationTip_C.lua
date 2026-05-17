--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Battle_HUD_ReputationTip_C
local M = Class("BluePrints.UI.BP_UIState_C")

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

function M:OnLoaded(ReputationExpAddInfo)
    rawset(self, "RegionId", ReputationExpAddInfo.RegionId)
    rawset(self, "OnlyShowLevel", ReputationExpAddInfo.OnlyShowLevel)
    rawset(self, "OldLevel", ReputationExpAddInfo.OldLevel)
    rawset(self, "OldExp", ReputationExpAddInfo.OldExp)
    rawset(self, "CurLevel", ReputationExpAddInfo.CurLevel)
    rawset(self, "CurExp", ReputationExpAddInfo.CurExp)

    rawset(self, "bMaxLevel", self:IsMaxLevel())
    self:PlayToast()
end

function M:OnAnimationFinished(Animation)
    rawset(self, "bPlaying", false)
    self:Close()
end

function M:PlayToast()
    if self.bPlaying then
        return
    end
    rawset(self, "bPlaying", true)
    self:InitCommonDetail()
    if self.OnlyShowLevel or self.bMaxLevel then
        -- 若只显示当前声望等级
        self:PlayAnimation(self.In)
    else
        -- 不单单只显示等级
        if self.OldLevel == self.CurLevel then
            -- 若没有升级
            self:PlayAnimation(self.Add_In)
        else
            -- 若升级
            self:PlayAnimation(self.Levelup_In)
        end
    end
end

-- 初始化一些通用控件数据
function M:InitCommonDetail()
    local ReputationData = DataMgr.RegionReputation
    if not ReputationData then
        UEPrint(string.format("WBP_ReputationTip_C not ReputationData Data"))
        return
    end
    local RegionData = ReputationData[self.RegionId]
    if not RegionData then
        UEPrint(string.format("WBP_ReputationTip_C not ReputationData RegionId:%s Data", self.RegionId))
        return
    end

    local IconImagePath = RegionData.RegionIconPath
    UE4.UResourceLibrary.LoadObjectAsync(self, IconImagePath, {self, M.OnReputationIconLoadFinish})

    self.Text_Level_Before:SetText(self.OldLevel)
    self.Text_Level_After:SetText(self.CurLevel)

    self.Text_Exp_Num:SetText(self.OldExp)
    local MaxExp = self:GetCurrentLevelMaxExp(self.OldLevel)
    self.Text_Exp_Total:SetText(MaxExp)
    self.Text_Exp_Total:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Text_Split:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)

    local TabName = string.format("%s·%s", GText("RegionReputation_TaskTitle"),  GText(RegionData.RegionName))
    self.Text_Desc:SetText(TabName)
end

function M:UpdateCurrentExp()
    local CurreentTime = UE4.UGameplayStatics.GetRealTimeSeconds(self)
    local ElapsedTime = CurreentTime - self.StartUpdateExpTime
    local Progress = ElapsedTime / self.UpdateExpDuration
    Progress =  math.min(Progress, 1.0)
    local ExpGrowNum = self.UpdateExpTo - self.UpdateExpFrom
    local CurrentExp = self.UpdateExpFrom + ExpGrowNum * Progress
    local FinExpText = string.format("%.0f", CurrentExp)
    self.Text_Exp_Num:SetText(FinExpText)
end

function M:PreAddExpStart_Lua()
    rawset(self, "StartUpdateExpTime", UE4.UGameplayStatics.GetRealTimeSeconds(self))
    rawset(self, "UpdateExpDuration", self.PreAddDuration)
    rawset(self, "UpdateExpFrom", self.OldExp)
    rawset(self, "UpdateExpTo", self.CurExp)
    self:AddTimer(0.03, self.UpdateCurrentExp, true, 0, "AddExpLoop", true)
    AudioManager(self):PlayUISound(self, "event:/ui/common/region_level_exp_add", nil, nil)
end

function M:LevelUpStage1_Lua()
    rawset(self, "StartUpdateExpTime", UE4.UGameplayStatics.GetRealTimeSeconds(self))
    rawset(self, "UpdateExpDuration", self.LevelUpStage1Duration)
    rawset(self, "UpdateExpFrom", self.OldExp)
    local CurrentLevelMaxExp = self:GetCurrentLevelMaxExp(self.OldLevel)
    rawset(self, "UpdateExpTo", CurrentLevelMaxExp)
    self:AddTimer(0.03, self.UpdateCurrentExp, true, 0, "AddExpLoop", true)
    AudioManager(self):PlayUISound(self, "event:/ui/common/region_level_upgrade", nil, nil)

    local MaxExp = self:GetCurrentLevelMaxExp(self.OldLevel)
    self.Text_Exp_Total:SetText(MaxExp)
end

function M:LevelUpStage2_Lua()
    rawset(self, "StartUpdateExpTime", UE4.UGameplayStatics.GetRealTimeSeconds(self))
    rawset(self, "UpdateExpDuration", self.LevelUpStage2Duration)
    rawset(self, "UpdateExpFrom", 0)
    rawset(self, "UpdateExpTo", self.CurExp)
    self:AddTimer(0.03, self.UpdateCurrentExp, true, 0, "AddExpLoop", true)

    local MaxExp = self:GetCurrentLevelMaxExp(self.CurLevel)
    self.Text_Exp_Total:SetText(MaxExp)
end

function M:PreAddExpEnd_Lua()
    self:RemoveTimer("AddExpLoop",true)
end

function M:GetCurrentLevelMaxExp(CurrentLevel)
    local ReputationLevelData = DataMgr.ReputationLevel
    if not ReputationLevelData then
        UEPrint(string.format("WBP_ReputationTip_C not ReputationLevelData Data"))
        return 0
    end
    local RegionLevelData = ReputationLevelData[self.RegionId]
    if not RegionLevelData then
        UEPrint(string.format("WBP_ReputationTip_C not RegionLevelData RegionId:%s Data", self.RegionId))
        return 0
    end
    CurrentLevel = math.min(CurrentLevel + 1, #RegionLevelData)
    local CurrentLevelMaxExp = RegionLevelData[CurrentLevel].ReputationLevelMaxExp
    return CurrentLevelMaxExp
end

-- 当前区域是否已经满级
function M:IsMaxLevel()
    local ReputationLevelData = DataMgr.ReputationLevel
    if not ReputationLevelData then
        UEPrint(string.format("WBP_ReputationTip_C not ReputationLevelData Data"))
        return false
    end
    local RegionLevelData = ReputationLevelData[self.RegionId]
    if not RegionLevelData then
        UEPrint(string.format("WBP_ReputationTip_C not RegionLevelData RegionId:%s Data", self.RegionId))
        return false
    end

    local MaxLevel = RegionLevelData[#RegionLevelData].ReputationLevel
    local MaxExp = self:GetCurrentLevelMaxExp(#RegionLevelData)
    if self.OldLevel == MaxLevel and self.OldExp == MaxExp then
        return true
    else
        return false
    end
end

function M:OnReputationIconLoadFinish(Object)
    if self.Icon_Area and self.Icon_Area_01 and Object then
        self.Icon_Area:SetBrushResourceObject(Object)
        self.Icon_Area_01:SetBrushResourceObject(Object)
    end
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M
