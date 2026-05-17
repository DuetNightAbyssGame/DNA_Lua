local QuestNodeUtils = require 'StoryCreator.StoryLogic.QuestNodeUtils'
local SitOnNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')

function SitOnNode:Init()
	self.GuideUIEnable = false
	self.ManualItemId = nil
	self.GuideType = nil
	self.GuidePointName = nil
end

function SitOnNode:Execute(Callback)
	local SeatItem = self:GetSeat()
	if not IsValid(SeatItem) then
		local Message = "ManualItemId对应的椅子不存在或已失效" ..
				"\nManualItemId:" .. self.ManualItemId
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, "SitOnNode 椅子无效", Message)
		return
	end

	self.SeatItem = SeatItem

	if IsValid(SeatItem.ChestInteractiveComponent) then
		self.OldMergeName = SeatItem.ChestInteractiveComponent.MergeName
		self:UpdateInteractiveIcon()
	end

	EventManager:AddEvent(EventID.OnOpenMechanism, self, function(Obj, SeatEid)
		if IsValid(self.SeatItem) then
			if (SeatEid == self.SeatItem.Eid) then
				Callback()
			end
		else
			local Message = "ManualItemId对应的椅子已失效" ..
				"\nManualItemId:" .. self.ManualItemId
			UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, "OnOpenMechanism触发时椅子已失效", Message)
			return
		end
	end)
    EventManager:AddEvent(EventID.OnChangeTaskIndicator, self, function()
		self:UpdateInteractiveIcon()
    end)
    EventManager:AddEvent(EventID.OnCancelQuestTracking, self, function()
		self:UpdateInteractiveIcon()
    end)

	if self.GuideUIEnable then
		MissionIndicatorManager:ActiveMissionIndicatorByNode(self)
	end
end

function SitOnNode:UpdateInteractiveIcon()
    local Avatar = GWorld:GetAvatar()
	local SeatItem = self.SeatItem
	SeatItem.ChestInteractiveComponent.MergeName = tostring(self.ManualItemId)
	SeatItem.ChestInteractiveComponent:OverrideInteractiveIcon(self:GetQuestInteractiveIconPath())
	--若已经显示交互选项，则需要拿到交互面板UI中的MergeInteractiveComponent进行刷新↓
	local InteractiveUI = UIManager(GWorld.GameInstance):GetUIObj(UIConst.InteractiveUIName)
    if InteractiveUI then
    	local MergeName = SeatItem.ChestInteractiveComponent.MergeName
    	local MergeActor = InteractiveUI.MergeActors and InteractiveUI.MergeActors[MergeName]
    	local MergeInteractiveComp = IsValid(MergeActor) and MergeActor.BP_MergeInteractiveComponent
    	if IsValid(MergeInteractiveComp) then
    		MergeInteractiveComp:UpdateInteractiveUIState()
    	end
    end
end

function SitOnNode:GetSeat()
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	if not GameMode then return end
	local SeatItem = GameMode.BPBornRegionActor:FindRef(self.ManualItemId)
	return SeatItem
end

function SitOnNode:Clear()
	EventManager:RemoveEvent(EventID.OnOpenMechanism,self)
	EventManager:RemoveEvent(EventID.OnChangeTaskIndicator,self)
	EventManager:RemoveEvent(EventID.OnCancelQuestTracking,self)

	if IsValid(self.SeatItem) and IsValid(self.SeatItem.ChestInteractiveComponent) then
		local InteractiveUI = UIManager(GWorld.GameInstance):GetUIObj(UIConst.InteractiveUIName)
    	if InteractiveUI then
			InteractiveUI:RemoveInteractiveItem(self.SeatItem.ChestInteractiveComponent)
		end
		self.SeatItem.ChestInteractiveComponent:OverrideInteractiveIcon(nil)
		self.SeatItem.ChestInteractiveComponent.MergeName = self.OldMergeName
	end

	if self.GuideUIEnable then
		MissionIndicatorManager:ReactiveMissionIndicatorByNode(self)
	end
end

function SitOnNode:GetQuestInteractiveIconPath()
	local QuestChainId, SpecialQuestId, DynQuestId = self.Context.QuestChainId, self:GetPayload("SpecialQuestId"), self:GetPayload("DynQuestId")
    local Avatar = GWorld:GetAvatar()
    if not Avatar then 
    	if DynQuestId and DynQuestId ~= 0 then
	        return '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Explore.T_Gp_Explore'
	    end
        return
    end
    if SpecialQuestId and SpecialQuestId ~= 0 then
        if DataMgr.SpecialQuestConfig[SpecialQuestId] then
            QuestChainId = DataMgr.SpecialQuestConfig[SpecialQuestId].QuestChainId
        end
    end
    local bQuestInTracking = Avatar.TrackingQuestChainId == QuestChainId
    if DataMgr.QuestChain[QuestChainId] then
        local CurQuestChainType = DataMgr.QuestChain[QuestChainId].QuestChainType
        if CurQuestChainType then
            if bQuestInTracking then
                return DataMgr.QuestTypeIcon[CurQuestChainType].TrackingIcon
            else
                return DataMgr.QuestTypeIcon[CurQuestChainType].NotTrackingIcon
            end
        end
    end
    if DynQuestId and DynQuestId ~= 0 then
        return '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Explore.T_Gp_Explore'
    end
end

return SitOnNode
