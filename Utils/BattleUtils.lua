local BattleDumpUtils = require "BluePrints.Client.BattleDumpUtils"

local BattleUtils = {}

function BattleUtils.GetExtraCreateInfo(UnitType, UnitId, RoleId)
	local ExtraCreateInfo = {}
	if UnitType == "Phantom" then
		local PhantomInfo = DataMgr.Phantom[RoleId]
		if PhantomInfo then
			ExtraCreateInfo.IsHostage = PhantomInfo.IsHostage
			ExtraCreateInfo.IsNPCPhantom = PhantomInfo.IsNPCPhantom
			ExtraCreateInfo.BTIndex = 1
		end
		return ExtraCreateInfo
	end
	return ExtraCreateInfo
end

function BattleUtils.GetQuestRoleCreateInfo(UnitType, QuestRoleId)
	local AvatarInfo, RoleId = nil, nil
	if UnitType == "Phantom" then
		local QuestRoleTable = DataMgr.QuestRoleInfo[QuestRoleId]
		if not QuestRoleTable then
			local Title = "静态刷新点参数错误"
            local Message = string.format("静态刷新点填写的QuestRoleId: %s ，在QuestRoleInfo中不存在对应角色 ，请检查配置", tostring(QuestRoleId))
            UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, Title, Message)
			return AvatarInfo, RoleId
		end
		local PhantomId = QuestRoleTable.PhantomId
		if not PhantomId then
			local Title = "静态刷新点参数错误"
            local Message = string.format("静态刷新点填写了QuestRoleId: %s ，但QuestRoleInfo中对应的角色未填写魅影Id ，请检查配置", tostring(QuestRoleId))
            UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, Title, Message)
            local CharRuleId = QuestRoleTable.CharTemplateRuleId
            if CharRuleId and DataMgr.CharTemplate[CharRuleId] then
            	PhantomId = DataMgr.CharTemplate[CharRuleId].CharId
            end
		end
		RoleId = PhantomId
		local Avatar = GWorld:GetAvatar()
		if (Avatar == nil) then
			return AvatarInfo, RoleId
		end
		AvatarInfo = BattleDumpUtils:GetBattleInfoByQuestRoleId(QuestRoleId, Avatar)
	end
	return AvatarInfo, RoleId
end

return BattleUtils