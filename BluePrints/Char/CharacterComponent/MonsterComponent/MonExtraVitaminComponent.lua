
local Component = {}

-- function Component:InitComponent()
--     if not self:HasAnyTags_Table(self, Const.ExtraFixVitamin, false) then return end
--     local GameState = UE4.UGameplayStatics.GetGameState(self)
-- 	if GameState.GameModeType ~= "SurvivalPro" then return end
--     self.FixVitaminHandle = self:AddTimer(1, self.ExtraFixVitamin, true)
-- end

-- function Component:ExtraFixVitamin()
-- 	if not IsValid(self) then 
-- 		self:RemoveTimer(self.FixVitaminHandle)
-- 		return
-- 	end
-- 	if self:IsDead() then 
-- 		self:RemoveTimer(self.FixVitaminHandle)
-- 		return
-- 	end

-- 	local GameState = UE4.UGameplayStatics.GetGameState(self)
--     if not GameState:CheckGameModeStateEnable() then
--         return
--     end

-- 	local MinExtraFixVitamin = DataMgr.GlobalConstant.MinExtraFixVitamin.ConstantValue
-- 	if GameState:GetSurvivalValue() <= MinExtraFixVitamin then 
-- 		return
-- 	end

-- 	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
-- 	local Value = GameMode:GetDungeonComponent().ExtraFixVitaminValue or 0
-- 	if GameState:GetSurvivalValue() + Value < MinExtraFixVitamin then
-- 		Value = MinExtraFixVitamin - GameState:GetSurvivalValue()
-- 	end
-- 	GameMode:TriggerDungeonComponentFun("AddSurvivalValue", Value)
-- end

return Component
