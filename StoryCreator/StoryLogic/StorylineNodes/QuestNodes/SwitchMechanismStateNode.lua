
local SwitchMechanismStateNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseQuestNode')


function SwitchMechanismStateNode:Init()
    self.StaticCreatorIdList = {}
    self.ManualItemIdList = {}
    self.StateId = 0
    self.QuestId = 0

    self.BeginStaticCreatorStateIds = {}
    self.BeginManualItemStateIds = {}
end

function SwitchMechanismStateNode:Execute()
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    local GameState = UE4.UGameplayStatics.GetGameState(GameMode)

    if #self.StaticCreatorIdList > 0 then
        for i = 1, #self.StaticCreatorIdList do
            local StateId = GameState.MechanismStateIdMap:Find(self.StaticCreatorIdList[i])
            self.BeginStaticCreatorStateIds[self.StaticCreatorIdList[i]] = StateId

            GameMode:TriggerMechanism(self.StaticCreatorIdList[i], self.StateId)
        end
    elseif #self.ManualItemIdList > 0 then
        for i = 1, #self.ManualItemIdList do
            local StateId = GameState.ManualMechanismStateIdMap:Find(self.ManualItemIdList[i])
            self.BeginManualItemStateIds[self.ManualItemIdList[i]] = StateId
        end
        local Array = self:TableToTArray(self.ManualItemIdList)
        GameMode:TriggerMechanismManualItem(Array, self.StateId, 0, self.QuestId)
    else
        error("SwitchMechanismStateNode节点中静态点Id和ManualItemId均未配置")
    end
end

function SwitchMechanismStateNode:OnQuestlineFail()
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    if #self.StaticCreatorIdList > 0 then
        for i = 1, #self.StaticCreatorIdList do
            GameMode:TriggerMechanism(self.StaticCreatorIdList[i], self.BeginStaticCreatorStateIds[self.StaticCreatorIdList[i]])
        end
    elseif #self.ManualItemIdList > 0 then
        for i = 1, #self.ManualItemIdList do
            local Table = {}
            Table[1] = self.ManualItemIdList[i]
            local Array = self:TableToTArray(Table)
            GameMode:TriggerMechanismManualItem(Array, self.BeginManualItemStateIds[self.ManualItemIdList[i]], 0, self.QuestId)
        end
    end
end

function SwitchMechanismStateNode:TableToTArray(table)
	local ResTArray = TArray(0)
    if table then
		for _, Item in ipairs(table) do
			ResTArray:Add(Item)
		end
    end
    return ResTArray
end

return SwitchMechanismStateNode