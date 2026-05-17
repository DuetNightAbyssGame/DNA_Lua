--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Battle_TaskBar_SubTask
local M = Class("BluePrints.UI.BP_UIState_C")
local TaskUtils = require "BluePrints.UI.TaskPanel.TaskUtils"
local ClientEventUtils = require "BluePrints.Common.ClientEvent.ClientEventUtils"

function M:Initialize(Initializer)
    self.Super.Initialize(self)
    self.TargetNodeKey = ""
    self.SourceGText = ""
    self.bPlayArrive = false
    -- self.DiffGuideInfos = {}
end

function M:Construct()
    self.Super.Construct(self)
    EventManager:AddEvent(EventID.OnMissiongIndicatorFloorLevelChange, self, self.SetFloorStyle)
end

function M:Destruct()
    self.Super.Destruct(self)
    EventManager:RemoveEvent(EventID.OnMissiongIndicatorFloorLevelChange,self)
end

function M:SetBranchInfo(InKey, InGText)
    self.TargetNodeKey = InKey
    self.SourceGText = InGText
end

function M:PlayArrive()
    self.bPlayArrive = true
    self:PlayAnimation(self.TargetArea)

end

function M:StopArrive()
    self.bPlayArrive = false
    self:PlayAnimation(self.TargetArea_Normal)
end



function M:CheckIsEqualKey(InKey)
    return self.TargetNodeKey == InKey
end

function M:SetFloorStyle(InUIName)
    -- local IndicatorUI = UIManager(self):GetUIObj(InUIName)
    -- local IndicatorNodeKey = nil
    -- if not IndicatorUI then
    --     return
    -- end

    -- if IndicatorUI.GuideInfoCache and IndicatorUI.GuideInfoCache.QuestNode.Key then
    --     IndicatorNodeKey = IndicatorUI.GuideInfoCache.QuestNode.Key
    -- end

    -- local Avatar = GWorld:GetAvatar()
    -- if not Avatar then
    --     return
    -- end
    -- local CurQuestChainId = nil
    -- local CurDoingQuestId = nil
    -- if Avatar.InSpecialQuest then
    --     CurQuestChainId = ClientEventUtils:GetCurrentEvent().PreQuestChainId
    -- else
    --     CurQuestChainId = Avatar.TrackingQuestChainId
    -- end
    -- if Avatar.QuestChains[CurQuestChainId] then
    --     CurDoingQuestId = Avatar.QuestChains[CurQuestChainId].DoingQuestId
    -- end

    -- local QuestExtraInfo = TaskUtils:GetQuestExtraInfo(CurQuestChainId, CurDoingQuestId)
    -- if QuestExtraInfo then
    --     for _, Data in pairs(QuestExtraInfo) do
    --         if Data.Node and Data.Node.Type == "BranchQuestStartNode" then
    --             for Index, OptionElemts in pairs(Data.DiffGuideList) do
    --                 for _, KeyList in pairs(OptionElemts) do
    --                     for _, KeyData in pairs(KeyList) do
    --                         if KeyData.TargetIndicatorKey == IndicatorNodeKey and Index == self.SubTaskIndex then
    --                             if IndicatorUI.CurrentFloorLevel == UE4.FloorLevelType.FloorLevelBottom then
    --                                 self.Arrow_Up:SetVisibility(UE4.ESlateVisibility.Collapsed)
    --                                 self.Arrow_Down:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    --                             elseif IndicatorUI.CurrentFloorLevel == UE4.FloorLevelType.FloorLevelUp and Index == self.SubTaskIndex then
    --                                 self.Arrow_Up:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    --                                 self.Arrow_Down:SetVisibility(UE4.ESlateVisibility.Collapsed)
    --                             elseif Index == self.SubTaskIndex then
    --                                 self.Arrow_Up:SetVisibility(UE4.ESlateVisibility.Collapsed)
    --                                 self.Arrow_Down:SetVisibility(UE4.ESlateVisibility.Collapsed)
    --                             end
    --                         end
    --                     end
    --                 end
    --             end
    --         end
    --     end
    -- end
end

function M:SetABCImg(Index, InContent)
    self.WS_Type:SetActiveWidgetIndex(1)
    local Content = string.char(string.byte('A') + Index - 1)
    -- local RetPath = '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SubTask_'..Content..'.T_Gp_SubTask_'..Content
    local RetPath = TaskUtils:GetDiffIconByQuestChainType(InContent, Content)
    UE4.UResourceLibrary.LoadObjectAsync(self, RetPath, {self, self.RealSetABCImg})
end

function M:SetABCImgDiffOptional(Index, InContent)
    self.WS_Type:SetActiveWidgetIndex(1)
    local Content = string.char(string.byte('A') + Index - 1)
    -- local RetPath = '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Digging_'..Content..'.T_Gp_Digging_'..Content
    local RetPath = TaskUtils:GetDiffIconOptionalByQuestChainType(InContent, Content)
    UE4.UResourceLibrary.LoadObjectAsync(self, RetPath, {self, self.RealSetABCImg})
end

function M:SetOptional(InGuidePointChainId)
    self.WS_Type:SetActiveWidgetIndex(1)
    local IconObj = TaskUtils:GetOptinalIconTextureByQuestChainType(InGuidePointChainId)
    self.Icon_Letter:SetBrushResourceObject(IconObj)
end

function M:RealSetABCImg(Object)
    self.Icon_Letter:SetBrushResourceObject(Object)
end

return M
