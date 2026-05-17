
require "UnLua"
local BattleMonitorConst = require "BattleMonitorConst"

---@class BP_Avatar_C
local BP_Avatar_C = Class()
BP_Avatar_C._components = {
	"BluePrints.Client.GM_Command",
	"BluePrints.Client.GM_Command_Region",
	"BluePrints.Combat.Components.GameModeInterface",
}
local ChatArray = TArray("")

function BP_Avatar_C:Initialize(Initializer)
end

function BP_Avatar_C:ReceiveBeginPlay()
end

function BP_Avatar_C:GetCurrentGameMode()
	local GameInstance = self:GetGameInstance()
	if GameInstance then
		return GameInstance:GetCurrentGameMode()
	end
end

function BP_Avatar_C:CompleteQuest(QuestChainId, QuestId, IsSuccess)
    DebugPrint(" BP_Avatar_C CompleteQuest, ", QuestChainId, QuestId, IsSuccess)
    self.Avatar:CompleteQuest(QuestChainId, QuestId, IsSuccess)
end

function BP_Avatar_C:IsQuestChainFinished(QuestChainId)
    DebugPrint(" BP_Avatar_C IsQuestChainFinished, ", QuestChainId)
    return self.Avatar:IsQuestChainFinished(QuestChainId)
end

function BP_Avatar_C:CheckFirstMonster(UnitId,bUpdate)
	if self.Avatar then
		return self.Avatar:CheckFirstMonster(UnitId,bUpdate)
	end
	return false
end

function BP_Avatar_C:CheckStrongGuideFirstMonster(UnitId,bUpdate)
	if self.Avatar then
		return self.Avatar:CheckStrongGuideFirstMonster(UnitId,bUpdate)
	end
	return false
end

function BP_Avatar_C:CheckChatMessage(Content)
	-- 只给DS用
	if not self.DSEntity then
		return
	end

	local ContentTable = Content:ToTable()

	local cb = function (ResultContent)
		ChatArray:Clear()
		for i=1, #ResultContent do
			ChatArray:Add(ResultContent[i])
		end
		self:OnCheckChatMessage(ChatArray)
	end
	self.DSEntity:CallServer("CheckChatMessage", cb, ContentTable)
end

function BP_Avatar_C:SetClientAvatar(Avatar)
	self.Avatar = Avatar
	self.bClientAvatarValid = Avatar and true or false
end

---@return Avatar
function BP_Avatar_C:GetClientAvatar()
	return self.Avatar
end

function BP_Avatar_C:SetDSEntity(DSEntity)
	self.DSEntity = DSEntity
end

function BP_Avatar_C:GetDSEntity()
	return self.DSEntity
end

function BP_Avatar_C:SendToFeishuForCombatMonitor(Msg)
	local Avatar = GWorld:GetAvatar()
	if Avatar then
		local GameInstance = GWorld.GameInstance
		local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
		if Player then
			if BattleMonitorConst:CheckAttributeValid(Player) then
				Avatar:SendToFeishuForCombatMonitor(Msg)
			end
		else
			Avatar:SendToFeishuForCombatMonitor(Msg)
		end
	end
end

function BP_Avatar_C:IntProp(Path)
	return self:FindAvatarProperty(Path)
end

function BP_Avatar_C:StringProp(Path)
	return self:FindAvatarProperty(Path)
end

function BP_Avatar_C:FloatProp(Path)
	return self:FindAvatarProperty(Path)
end

function BP_Avatar_C:FindAvatarProperty(Path)
	DebugPrint("BP_Avatar_C:FindAvatarProperty")
	local Props = self:GetClientAvatar()
	if Props == nil then
		return nil
	end
	for _, key in ipairs(Path:ToTable()) do
		if tonumber(key) then
			key = tonumber(key)
		end
		DebugPrint("key", key)
		Props = Props[key]
		if Props == nil then
			return nil
		end
	end
	return Props
end

AssembleComponents(BP_Avatar_C)
return BP_Avatar_C
