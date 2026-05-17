local M = Class("BluePrints.Story.Talk.Object.BP_TalkSequencerObject_C")

function M:SetUpLua(TalkTask)
    assert(TalkTask ~= nil, "TalkSequencerProxy: TalkSequencerRuntimeProxy Setup Failed, TalkTask is nil")
    self.TalkTask = TalkTask
    self:InitAfterSetupLua()
end

function M:RealShowMediaUI_Lua(bShow)
    --- @todo 优化成注册事件
    DebugPrint("TalkSequencerProxy:RealShowMediaUI_Lua",bShow)
    local TalkTask = self.TalkTask
    if TalkTask and TalkTask.OnSequenceShowVideoUI then
        TalkTask:OnSequenceShowVideoUI(bShow)
    end
end

-- function M:PlayDialogue_Lua(Section)
--     --- @todo 优化成注册事件
--     local TalkTask = self.TalkTask
--     self.Section = Section
--     if TalkTask then
--         TalkTask:SequenceDrivePlayDialogue(Section.DialogueId)
--     end
-- end

-- function M:EndPlayDialogue_Lua(Section)
--     local TalkTask = self.TalkTask
--     if self.Section ~= Section then return end
--     if TalkTask and Section then
--         TalkTask:SequenceEndPlayDialogue(Section.DialogueId)
--     end
-- end

function M:SendGameModeMessage_Lua(Content)
    local GameInstance = GWorld.GameInstance
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
	local GameMode = UE4.UGameplayStatics.GetGameMode(Player)
    if not IsValid(GameMode) then
        return
    end
    GameMode:PostCustomEvent(Content)
end

function M:SendBehaviorMessage_Lua(UnitId, Content)
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
    if not IsValid(GameState) then return end
    for _, Monster in pairs(GameState.MonsterMap) do
        self:QuestEventMonsterOrNpc(Monster, UnitId, Content)
    end
    for _, Npc in pairs(GameState.NpcMap) do
        self:QuestEventMonsterOrNpc(Npc, UnitId, Content)
    end
end

function M:QuestEventMonsterOrNpc(AI, UnitId, Content)
	if IsValid(AI) and tonumber(UnitId) == tonumber(AI.UnitId) then
		local BB = AI:GetOwnBlackBoardComponent()
		if(BB) then
			BB:SetValueAsString("QuestEvent", Content)
		else
			DebugPrint("ERROR:AI.UnitId:" .. AI.UnitId .. ", AI:GetName " .. AI:GetName() ..  " BehaviorTree Is nil")
		end
	end
end

return M