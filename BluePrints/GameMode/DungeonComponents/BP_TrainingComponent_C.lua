require "UnLua"

local BP_TrainingComponent_C = Class({
	"BluePrints.Common.TimerMgr",
})

--------------------GameMode 流程&事件相关------------------------

function BP_TrainingComponent_C:InitTrainingComponent()
    self.GameMode = self:GetOwner()
    self.TrainingData = DataMgr.Training[self.GameMode.DungeonId]

    self.StopBTReason = "Training"
    self.MonsterCreateInfo = {}
    self.MonsterNeedToStartBT = true    -- 怪物是否开启AI
    self.PlayerInvincible = false       -- 玩家是否无敌
end

function BP_TrainingComponent_C:InitTrainingBaseInfo()
    self.StaticCreators = {}
    for _, Creator in pairs(self.GameMode.EMGameState.StaticCreatorMap) do
        if Creator.UnitType == "Monster" then
            table.insert(self.StaticCreators, Creator)
        end
    end
    table.sort(self.StaticCreators, function(CreatorA, CreatorB)
        return CreatorA.StaticCreatorId < CreatorB.StaticCreatorId
    end)
end

function BP_TrainingComponent_C:GetPlayerRecoveryTime()
    return DataMgr.GlobalConstant.TrainingPlayerRecoveryTime.ConstantValue
end

------------------------静态点刷怪相关----------------------------

function BP_TrainingComponent_C:GetMonsterNeedToStartBT()
    return self.MonsterNeedToStartBT
end

function BP_TrainingComponent_C:CreateMonster(CreateInfo)
    if #CreateInfo <= 0 then
        CreateInfo = self.MonsterCreateInfo
    else self.MonsterCreateInfo = CreateInfo end
    local Res, Index, Creator = {}, 1, nil
    for _, Info in ipairs(CreateInfo) do
        for __ = 1, Info[2] do
            while true do
                Creator = self.StaticCreators[Index]
                if Creator == nil then
                    DebugPrint("训练场刷怪：刷怪点不足，有怪物没分配到刷怪点")
                    return
                end
                if Creator.ChildEids:Num() <= 0 then
                    Creator.UnitId = Info[1]
                    Creator.Level = Info[3]
                    Creator.bIsCreating = true
                    table.insert(Res, Creator.StaticCreatorId)
                    Index = Index + 1
                    break
                end
                Index = Index + 1
            end
        end
    end
    if #Res > 0 then
        self.GameMode:TriggerActiveStaticCreator(Res)
    end
end

function BP_TrainingComponent_C:SetMonsterAI(Flag)
    self.MonsterNeedToStartBT = Flag
    for _, Creator in pairs(self.StaticCreators) do
        for __, MonsterEid in pairs(Creator.ChildEids) do
            local Monster = Battle(self):GetEntity(MonsterEid)
            if Monster ~= nil then
                if Flag == true then
                    Monster:StartBT(self.StopBTReason)
                else Monster:StopBT(self.StopBTReason) end
            end
        end
    end
end

function BP_TrainingComponent_C:RemoveMonster()
    for _, Creator in pairs(self.StaticCreators) do
        for __, MonsterEid in pairs(Creator.ChildEids) do
            Battle(self):BattleOnDead(MonsterEid, MonsterEid, 0, EDeathReason.Training)
        end
    end
end

function BP_TrainingComponent_C:ClearCreateInfo()
    self.MonsterCreateInfo = {}
end

function BP_TrainingComponent_C:CheckAliveMonsterCount()
    local Total, Alive = 0, 0
    local AliveIds = {}

    local IsMonsterAlive = function(StaticCreatorId)
        local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        local MonsterMap = GameMode.EMGameState.MonsterMap:ToTable()
        for _, Monster in pairs(MonsterMap) do
            if not IsValid(Monster) then 
                return false
            end
            if Monster:IsRealDead() then 
                return false
            else
                DebugPrint("ayff test Monster:"..StaticCreatorId.." is alive")
                return true
            end
        end
        return true
    end

    for _, Creator in pairs(self.StaticCreators or {}) do
        if Creator.ChildEids:Num() > 0 then
            Total = Total + 1
            if IsMonsterAlive(Creator.StaticCreatorId) then
                Alive = Alive + 1
                table.insert(AliveIds, Creator.StaticCreatorId)
            end
            if Creator.bIsCreating then
                Creator.bIsCreating = false
            end
        elseif Creator.bIsCreating then
            Total = Total + 1
            Alive = Alive + 1
            table.insert(AliveIds, Creator.StaticCreatorId)
        end
    end
    DebugPrint(string.format("ayff 训练场：当前怪物 总数=%d,存活=%d", Total, Alive))
    return Alive, Total, AliveIds
end

------------------------ 训练场功能相关 -----------------------------
function BP_TrainingComponent_C:TrainingOpenSetup()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    UIManager:LoadUINew("TrainingGroundSetup")
end

function BP_TrainingComponent_C:TrainingCharacterSkills()
    local BattleUI = UIManager(self):GetUIObj("BattleMain")
    UIUtils.LoadPreviewSkillDetails(BattleUI,{OnClosedCallback = function() BattleUI:PlayInAnim() end})
end

function BP_TrainingComponent_C:TrainingKillMonsters()
    self:RemoveMonster()
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, string.format(GText("UI_DUNGEON_DES_TRAINING_4")))
end

function BP_TrainingComponent_C:GetIsPlayerInvincible()
    return self.PlayerInvincible
end

function BP_TrainingComponent_C:TrainingSetPlayerInvincible()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    if PlayerController then
        self.PlayerInvincible = not self.PlayerInvincible
        local PlayerCharacter = PlayerController:GetMyPawn()
        PlayerCharacter:SetInvincible(self.PlayerInvincible, "Training")
    end

    local Msg = nil
    if self.PlayerInvincible then
        Msg = GText("UI_DUNGEON_DES_TRAINING_37")
    else 
        Msg = GText("UI_DUNGEON_DES_TRAINING_38") 
    end
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, Msg)
end

function BP_TrainingComponent_C:GetIsMonsterAIEnabled()
    return self.MonsterNeedToStartBT
end

function BP_TrainingComponent_C:TrainingDisableMonsterAI()
    self:SetMonsterAI(not self.MonsterNeedToStartBT)

    local Msg = nil
    if self.MonsterNeedToStartBT then
        Msg = GText("UI_DUNGEON_DES_TRAINING_39")
    else 
        Msg = GText("UI_DUNGEON_DES_TRAINING_40") 
    end
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, Msg)
end

return BP_TrainingComponent_C