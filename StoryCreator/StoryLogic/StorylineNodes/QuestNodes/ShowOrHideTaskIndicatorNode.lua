local ShowOrHideTaskIndicatorNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')
local TaskUtils = require "BluePrints.UI.TaskPanel.TaskUtils"

function ShowOrHideTaskIndicatorNode:Init()
    self.IsShow = nil
    self.GuideType = nil
    self.GuideName = nil
    self.GuideRadius = nil
end

-- function ShowOrHideTaskIndicatorNode:Start(Context)
--     self.Context = Context
-- end

function ShowOrHideTaskIndicatorNode:Execute(Callback)
	self:ShowOrHideIndicator()
    Callback()
end

function ShowOrHideTaskIndicatorNode:ShowOrHideIndicator()
    -- local GameInstance = GWorld.GameInstance
    -- local UIManager = GameInstance:GetGameUIManager()
    -- local OwnerQuestId = self.QuestData.QuestId
    -- local Avatar = GWorld:GetAvatar()
    -- if Avatar and Avatar.InSpecialQuest and self.QuestData.QuestId == 0 then
    --     local CurTrackingQuestChaindId = Avatar.TrackingQuestChainId
    --     if Avatar.QuestChains[CurTrackingQuestChaindId] and Avatar.QuestChains[CurTrackingQuestChaindId].DoingQuestId then
    --         local DoingQuestId = Avatar.QuestChains[CurTrackingQuestChaindId].DoingQuestId
    --         OwnerQuestId = DoingQuestId
    --     end
    -- end
    if self.IsShow then
        MissionIndicatorManager:ActiveMissionIndicatorByNode(self)
    else
        MissionIndicatorManager:ReactiveMissionIndicatorByNode(self)
    end
    self:CreateOrDestoryEffect(self.bOpenRangeEffect)
end

function ShowOrHideTaskIndicatorNode:ClearWhenQuestSuccess()
    if self.IsShow then
        MissionIndicatorManager:ReactiveMissionIndicatorByNode(self)
    end
    self:CreateOrDestoryEffect(false)
end

function ShowOrHideTaskIndicatorNode:ClearWhenQuestFail()
    if self.IsShow then
        MissionIndicatorManager:ReactiveMissionIndicatorByNode(self)
    end
    self:CreateOrDestoryEffect(false)
end

function ShowOrHideTaskIndicatorNode:CreateOrDestoryEffect(bCreate)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local NewTargetPoint = GameState:GetTargetPoint(self.GuideName) 
    if NewTargetPoint == nil then
        return
    end
    if bCreate then
        NewTargetPoint:SetTargetRangeEffect(self.bIsDynamicEvent)
    else
        NewTargetPoint:DestoryTargetRangeEffect()
    end
end

return ShowOrHideTaskIndicatorNode
