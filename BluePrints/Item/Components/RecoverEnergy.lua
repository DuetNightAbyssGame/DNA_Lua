
local Component = {}

function Component:OnActorReady(Info)
    -- print(_G.LogTag,"LXZ   ",self:GetName())
    if IsAuthority(self) then
        self._RegisterOnCharacterDead = true
        -- Battle(self):RegisterBattleEvent(BattleEventName.OnAfterDead, self, "_OnCharacterDead")
        self:RegisterAfterDeadBattleEvent(self, "OnCharacterDead")
    end
end

function Component:OnCharacterDead(Target, ...)
    if not Target then
    	return
    end

    if not Target:IsSummonMonster() and Target:IsMonster() then
        self:OutRecover(Target)
    end
end

return Component