--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_GoldBoxBase_C
require "UnLua"

local M = Class({
    "BluePrints/Item/CombatProp/BP_CombatPropBase_C",
})

--激活表现，IsActive变化说明要播放激活或停止激活时对应的特效
function M:OnActiveStateChange()
    local GameState = UE4.URuntimeCommonFunctionLibrary.GetCurrentGameState(self)
    if self.IsActive then
        GameState.HatredCombatProp:Add(self.Eid, self)
        self.CombatClientEffectComponent:OnActiveEffect()
    else
        GameState.HatredCombatProp:Remove(self.Eid)
    end
end

function M:GetRealSkillId()
    print(_G.LogTag,"LXZ GetRealSkillId", self.UnitId)
    self.SkillList = self.UnitParams["SkillId"]
    if not self.SkillList then
        return 0
    end
    local WeightSum = 0
    for _, Data in pairs(self.SkillList) do
        WeightSum = WeightSum + Data[1]
    end
    print(_G.LogTag,"LXZ GetRealSkillId11", WeightSum)

    for SkillId, Data in pairs(self.SkillList) do
        local RandomNumber = math.random(1,WeightSum)
        if #Data < 4 then
            print(_G.LogTag,"Error: GoldBoxBase 机关参数错误")
        else
            print(_G.LogTag,"LXZ GetRealSkillId22", SkillId, Data[1], RandomNumber)
            if(RandomNumber<=Data[1]) then
                return SkillId, Data
            else
                WeightSum = WeightSum - Data[1]
            end
        end
    end
end

function M:OnDead(KillMineRoleEid, KillMineSkillId, DeathReason)
    local SkillId, Data = self:GetRealSkillId()
    print(_G.LogTag,"LXZ GetRealSkillId  OnDead", SkillId, Data[1], Data[2], Data[3], Data[4])
    local Killer = Battle(self):GetEntity(KillMineRoleEid)
    local Source = self
    local PreTarget = self
    local SourceComp = self.RootComponent
    if Data[2] == "Target" then
        Source = Killer
    end
    if Data[3] == "Target" then
        PreTarget = Killer
    end
    if Data[4] == "Target" then
        SourceComp = Killer.RootComponent
    end
    
    if SkillId ~= 0 and Killer:IsPlayer() then
        local EffectIds = TArray(0)
        EffectIds:Add(SkillId)
        Battle(self):ExecuteSkillEffectsWithType(Source, EffectIds, PreTarget, nil, self, SourceComp)
        -- Battle(self):ExecuteSkillEffectWithType(Source, SkillId, PreTarget, nil, self)
    end
    M.Super.OnDead(self, KillMineRoleEid, KillMineSkillId, DeathReason)
end

-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

-- function M:ReceiveBeginPlay()
-- end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

return M
