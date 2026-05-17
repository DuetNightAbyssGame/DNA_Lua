--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_BattleProgress_CountBar_C
local M = Class("BluePrints.UI.BP_EMDungeonWidget_C")

local StyleToVisibility = {     -- 在这里配置哪些Style需要显示本Widget
    EStandard = {true, false},       -- Params: 是否整体显示，是否显示进度条
    ELeftOnly = {true, true},
    EClassic = {true, true},
    EClassicTime = {false, false},
    ELeftOnlyNumber = {true, false},
}

function M:InitListenEvent()
    self:AddDispatcher(EventID.OnRepBattleProgressInfo, self, self.OnRepBattleProgressInfo)
    self:AddDispatcher(EventID.OnRepBattleProgressNum, self, self.OnRepBattleProgressNum)
end

function M:InitWidgetUI()
    self:InitListenEvent()
    self.GameState = UE4.UGameplayStatics.GetGameState(self)

    -- 初始化进度显示
    self:OnRepBattleProgressInfo(self.GameState.BattleProgressInfo)
    self:OnRepBattleProgressNum(self.GameState.BattleProgressNum, self.GameState.BattleProgressInfo.MaxProgressNum)

    self:PlayAnimation(self.In)

    local BattleMain = UIManager(self):GetUIObj("BattleMain")
    BattleMain.Task:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	BattleMain.Task:AddChildToOverlay(self)
end

function M:OnRepBattleProgressInfo(BattleProgressInfo)
    -- 根据Style来控制自己显隐
    local StyleName = EBattleProgressStyle:GetNameByValue(BattleProgressInfo.Style)
    local Settings = StyleToVisibility[StyleName] or {true, true}
    local IsShowSelf = Settings[1]
    local IsShowBar = Settings[2]

    -- 更新自己显隐
    self:SetBattleWidgetVisibility(IsShowSelf)
    -- 更新文本 及Bar的显隐
    local Text = BattleProgressInfo.DisplayText:GetRef(1) or ""
    self:InitBattleDisplayText(Text, IsShowBar)
end

function M:InitBattleDisplayText(DisplayText, IsShowBar)
    if DisplayText == "" then
        self.Text_AnnihilateTitle:SetText(GText("DUNGEON_EXTERMINATE_100"))         -- 如果没传则显示默认textmap
    else
        self.Text_AnnihilateTitle:SetText(GText(DisplayText))
    end
    if IsShowBar then
        self.Overlay_Bar:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Overlay_Bar:SetVisibility(UE4.ESlateVisibility.Hidden)
    end
    self:ResetToDefaultState()
end

function M:OnRepBattleProgressNum(BattleProgressNum, MaxProgressNum)
    self.Text_AnnihilateNum:SetText(BattleProgressNum .. '/' .. MaxProgressNum)
    self.Progress_Annihilate:SetPercent(BattleProgressNum / MaxProgressNum)
    if BattleProgressNum >= MaxProgressNum then
        self:PlayAnimation(self.Complete)
        self.Group_Full:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
end

function M:ResetToDefaultState()
    self.Group_Full:SetVisibility(UE4.ESlateVisibility.Hidden)
end

function M:SetBattleWidgetVisibility(IsShow)
    if IsShow then
        self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end


return M
