local M = {}
local EEntertainmentState = {
	None = -1,
	Main = 0,
	SwitchCharacter = 1,
	Topic = 2,
	Invitation = 3
}
local EPartyTopicState = {
	None = 0,
	NotMeetLastPartyTopic = 1,
	NotMeetCondition = 2,
	NotMeetResource = 3,
	RedeemResource = 4,
	CanUnlockPartyTopic = 5,
	CanStartPartyTopic = 6,
	CanReviewPartyTopic = 7
}

local EDisableTopicParty = {
}
function M:IsSystemShowRedDot()
	local Avatar = GWorld:GetAvatar()
	if (Avatar == nil) then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Invite, "邀约系统错误", "获取角色信息失败，avatar 为空。")
		return false
	end

	for I, Char in pairs(Avatar.Chars) do
		if (self:IsCharacterShowRedDot(Char.CharId)) then
			return true
		end
	end

	return false
end

function M:IsDisableTopicParty(CharacterId)
	local NativePartyNPCData = DataMgr.PartyNpc[CharacterId]
	if not NativePartyNPCData then return true end
	return not NativePartyNPCData.bEnableParty
end

function M:IsCharacterShowRedDot(CharacterId)
	if (CharacterId == nil) then
		UStoryLogUtils:PrintToFeiShu(GWorld.GameInstance, "邀约系统错误",
			"获取角色信息失败，character id 为空。")
		return false
	end

	local PartyNPCData = DataMgr.PartyNpc[CharacterId]
	if (PartyNPCData == nil) then
		return false
	end

	local PartyTopicList = PartyNPCData.PartyTopicList
	if (PartyTopicList == nil) then
		UStoryLogUtils:PrintToFeiShu(GWorld.GameInstance, "邀约系统错误", string.format(
			"获取角色信息失败，PartyNpc 表 Id：%d 的 party topic list 字段为空。", CharacterId))
		return false
	end

	if (self:IsDisableTopicParty(CharacterId)) then
		return false
	end

	for PartyTopicLevel, PartyTopicId in pairs(PartyTopicList) do
		if (self:IsPartyTopicShowRedDot(CharacterId, PartyTopicLevel, PartyTopicId)) then
			return true
		end
	end

	return false
end

function M:GetPriorityCharacterId()
	-- do
	-- 	local SystemGuideId = DataMgr.GlobalConstant.InvitationGuideId
	-- 	local SpecialCharacterId = DataMgr.GlobalConstant.InvitationSpecialCharacterId
	-- 	SystemGuideId = SystemGuideId and SystemGuideId.ConstantValue
	-- 	SpecialCharacterId = SpecialCharacterId and SpecialCharacterId.ConstantValue
	-- 	return SpecialCharacterId
	-- end
	local Avatar = GWorld:GetAvatar()
	if (Avatar == nil) then
		UStoryLogUtils:PrintToFeiShu(GWorld.GameInstance, "邀约系统错误", "获取角色信息失败，avatar 为空。")
		return 
	end
	local SojournsGameInstanceSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, USojournsGameInstanceSubsystem)
	local SystemGuideId = DataMgr.GlobalConstant.InvitationGuideId
	local SpecialCharacterId = DataMgr.GlobalConstant.InvitationSpecialCharacterId
	SystemGuideId = SystemGuideId and SystemGuideId.ConstantValue
	SpecialCharacterId = SpecialCharacterId and SpecialCharacterId.ConstantValue
	if SystemGuideId then
		local Guide = Avatar.SystemGuides:Get(SystemGuideId)
		--DebugPrint(ErrorTag, "Guide", Guide)
		if (SojournsGameInstanceSubsystem and SojournsGameInstanceSubsystem.bSpecialGuide) or (Guide and not Guide:IsFinished()) then
			return SpecialCharacterId
		end
	end
end

function M:IsSpecialSelectCharacter()
	local SojournsGameInstanceSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, USojournsGameInstanceSubsystem)
	if (SojournsGameInstanceSubsystem and SojournsGameInstanceSubsystem.bSpecialGuide) then
		local SpecialCharacterId = DataMgr.GlobalConstant.InvitationSpecialCharacterId
		SpecialCharacterId = SpecialCharacterId and SpecialCharacterId.ConstantValue
		return true
	end
end

function M:CheckEnough(Avatar, ConsumeCountMap)
	if Avatar:CheckEnough(ConsumeCountMap) then
		return true
	end

	local HighLevelNeedCount = 0
	for ResourceId, Count in pairs(ConsumeCountMap) do
		local ItemCount = Avatar:GetResourceNum(ResourceId)
		local NeedCount = Count - ItemCount
		HighLevelNeedCount = HighLevelNeedCount + (NeedCount > 0 and NeedCount or 0)
	end

	local HighLevelItemCount = Avatar:GetResourceNum(19000)
	if HighLevelItemCount >= HighLevelNeedCount then
		return true
	end
	return false
end


function M:IsPartyTopicShowRedDot(CharacterId, PartyTopicLevel, PartyTopicId)
	if (CharacterId == nil) then
		UStoryLogUtils:PrintToFeiShu(GWorld.GameInstance, "邀约系统错误",
			"获取话题红点是否显示失败，character id 为空。")
		return false
	end
	if (PartyTopicLevel == nil) then
		UStoryLogUtils:PrintToFeiShu(GWorld.GameInstance, "邀约系统错误",
			"获取话题红点是否显示失败，party topic level 为空。")
		return false
	end
	if (PartyTopicId == nil) then
		UStoryLogUtils:PrintToFeiShu(GWorld.GameInstance, "邀约系统错误",
			"获取话题红点是否显示失败，party topic id 为空。")
		return false
	end

	local PartyTopicData = DataMgr.PartyTopic[PartyTopicId]
	if (PartyTopicData == nil) then
		UStoryLogUtils:PrintToFeiShu(GWorld.GameInstance, "邀约系统错误", string.format(
			"获取话题红点是否显示失败，未在 PartyTopic 表找到 Id：%d 的数据。", PartyTopicId))
		return false
	end

	local Avatar = GWorld:GetAvatar()
	if (Avatar == nil) then
		UStoryLogUtils:PrintToFeiShu(GWorld.GameInstance, "邀约系统错误", "获取角色信息失败，avatar 为空。")
		return false
	end

	local PartyTopic = Avatar:GetPartyTopic(CharacterId, PartyTopicLevel)
	if (PartyTopic and PartyTopic:IsLocked() == false and PartyTopic:IsCompleted() == true) then
		return false
	end

	local LastPartyTopic = Avatar:GetPartyTopic(CharacterId, PartyTopicLevel - 1)
	if (LastPartyTopic and LastPartyTopic:IsCompleted() == false) then
		return false
	end

	local ConditionId = PartyTopicData.ConditionId
	if (ConditionId ~= nil) then
		if (ConditionUtils.CheckCondition(Avatar, ConditionId) == false) then
			return false
		end
	end

	local PartyTopicConsume = PartyTopicData.PartyTopicConsume
	if (PartyTopicConsume ~= nil) then
		if (PartyTopic and PartyTopic:IsLocked()) and (self:CheckEnough(Avatar, PartyTopicConsume) == false) then
			return false
		end
	end

	return true
end

M.EEntertainmentState = EEntertainmentState
M.EPartyTopicState = EPartyTopicState
return M
