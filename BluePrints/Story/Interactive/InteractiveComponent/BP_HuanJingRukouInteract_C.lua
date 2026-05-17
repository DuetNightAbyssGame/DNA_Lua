require "UnLua"
require "DataMgr"
local StoryInterActiveModel = require ("BluePrints.UI.WBP.StoryInteractive.StoryInteractiveModel")

local LuaConst = require("EMLuaConst")
local BP_HuanJingRuKouInteract_C = Class("BluePrints.Story.Interactive.InteractiveComponent.BP_InteractiveBaseComponent_C")

function BP_HuanJingRuKouInteract_C:ReceiveBeginPlay()
    self.Super.ReceiveBeginPlay(self)
    self.Owner = self:GetOwner()
end

function BP_HuanJingRuKouInteract_C:SetComponentInfo(QuestChainId, SubRegionId)
	self.QuestChainId = QuestChainId
    self.SubRegionId = SubRegionId
end

function BP_HuanJingRuKouInteract_C:IsCanInteractive(PlayerActor)
    if LuaConst.OpenComputeInteractive then
        return self:GetInteractiveName() ~= "" and
            self:GetDistanceCheckResult() and
            self.CFaceToACheckComponent(self, PlayerActor, self.InteractiveFaceAngle, false) and 
            self.AFaceToCCheckComponent(PlayerActor, self, self.InteractiveAngle, false)
    else
        return self:GetInteractiveName() ~= "" and
            self.DistanceCheckComponent(self, PlayerActor, self.InteractiveDistance, false) and
            self.CFaceToACheckComponent(self, PlayerActor, self.InteractiveFaceAngle, false) and 
            self.AFaceToCCheckComponent(PlayerActor, self, self.InteractiveAngle, false)
    end
end

function BP_HuanJingRuKouInteract_C:GetInteractiveName()
    if not DataMgr.QuestChain[self.QuestChainId] then
        return ""
    end
    local TaskName = DataMgr.QuestChain[self.QuestChainId].QuestChainName
	return string.format(GText("UI_Wonder_DefaultNpcInter"), GText(TaskName))
end

function BP_HuanJingRuKouInteract_C:StartInteractive(PlayerActor)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
	if Avatar.CurrentRegionId ~= self.SubRegionId then
		local UIManager = GWorld.GameInstance:GetGameUIManager()
		if not DataMgr.QuestChain[self.QuestChainId] then
			return
		end
		local TaskName = DataMgr.QuestChain[self.QuestChainId].QuestChainName
		local Params =
        {
        	ShortText = string.format("%s <H>%s</>", GText("UI_Prompt_QuestTrans"), GText(TaskName)),
			LeftCallbackObj = self,
			LeftCallbackFunction = self.CancelDeliverTo,
			RightCallbackObj = self,
			RightCallbackFunction = self.DoDeliverTo,
			CloseBtnCallbackObj = self,
			CloseBtnCallbackFunction = self.CancelDeliverTo
        }
        UIManager:ShowCommonPopupUI(100160, Params)
	end
end

function BP_HuanJingRuKouInteract_C:BtnPressed(PlayerActor)
	self:StartInteractive(PlayerActor)
end

function BP_HuanJingRuKouInteract_C:CancelDeliverTo()

end

function BP_HuanJingRuKouInteract_C:DoDeliverTo()
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    if IsValid(GameMode) and self.SubRegionId and self.SubRegionId > 0 then
        GameMode:HandleLevelDeliver(UE4.EModeType.ModeRegion, self.SubRegionId, 1, true)
    end
end

function BP_HuanJingRuKouInteract_C:GetQuestID()
    if self.Owner.NpcId then
        return StoryInterActiveModel:GetNowInteractiveQuestChainId(self.Owner.NpcId)
    else
        return self.QuestChainId
    end
end

function BP_HuanJingRuKouInteract_C:GetSpecialQuestID()
    if self.Owner.NpcId then
        return StoryInterActiveModel:GetNowInteractiveSpecialQuestId(self.Owner.NpcId)
    end
end

-- function BP_HuanJingRuKouInteract_C:GetInteractiveIcon(PlayerActor)
--     local Type = DataMgr.QuestChain[self.QuestChainId].QuestChainType
--     local Avatar = GWorld:GetAvatar()
--     if not Avatar then
--         return
--     end
--     if self.QuestChainId == Avatar.TrackingQuestChainId then 
--         return DataMgr.QuestTypeIcon[Type].TrackingIcon
--     else
--         return DataMgr.QuestTypeIcon[Type].NotTrackingIcon
--     end	
-- 	return nil
-- end

return BP_HuanJingRuKouInteract_C
