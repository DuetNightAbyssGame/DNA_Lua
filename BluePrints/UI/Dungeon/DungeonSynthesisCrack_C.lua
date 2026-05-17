--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Play_DeputeWeekly_Hud_KeyItem_C
local M = Class("BluePrints.UI.BP_UIState_C")

function M:Construct()
    self.KeyItemTotalNum = 0
    self.KeyItemContents = {}  -- 用于存储每个KeyItem的实例
    self.LastKeySubmitNum = 0
end

function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)

    local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
    if BattleMainUI then
        self:AddTaskToOverlay(BattleMainUI)
    end

    self:InitListenEvent()
    self:InitItemList()

    self:PlayAnimation(self.In)

    self.IsInit = true
end

function M:AddTaskToOverlay(BattleMainUI)
	BattleMainUI.Pos_Weekly:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	BattleMainUI.Pos_Weekly:AddChildToOverlay(self)
end

function M:InitListenEvent()
    self:AddDispatcher(EventID.OnRepKeySubmitNum, self, self.UpdateSubmitNum)
end

function M:InitItemList()
    self.List_KeyItem:ClearListItems()
    self.KeyItemContents = {}

    local DungeonData = DataMgr.Synthesis[GameState(self).DungeonId]
    if not DungeonData then
        GameState(self):ShowDungeonError("SynthesisComponent:Client 当前副本ID没有填写在对应的副本表中, 读表失败! 读入Id："..GameState(self).DungeonId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
        return
    end

    local CurKeySubmitNum = GameState(self).KeySubmitNum or 0

    self.KeyItemTotalNum = DungeonData.KeyNeedNum or 0
    for i = 1, self.KeyItemTotalNum do
        local KeyItemContent = NewObject(UIUtils.GetCommonItemContentClass())
        KeyItemContent.ParentWidget = self
        KeyItemContent.Index = i
        KeyItemContent.State = "Normal"
        self.List_KeyItem:AddItem(KeyItemContent)
        self.KeyItemContents[i] = KeyItemContent
    end

    self:UpdateSubmitNum(CurKeySubmitNum)
end

function M:UpdateSubmitNum(KeySubmitNum)
    local DisplayText = string.format(GText("DUNGEON_SYNTHESIS_104"), KeySubmitNum, self.KeyItemTotalNum)
    self.Text_Title:SetText(DisplayText)

    for i = self.LastKeySubmitNum + 1, KeySubmitNum do
        local Content = self.KeyItemContents[i]
        if Content then
            Content.State = "Activated"
            if Content.SelfWidget then
                Content.SelfWidget:UpdateState(Content.State)
            end
        end
    end

    self.LastKeySubmitNum = KeySubmitNum
end

function M:PlayOutAnimation()
    self:PlayAnimation(self.Out)
end

return M
