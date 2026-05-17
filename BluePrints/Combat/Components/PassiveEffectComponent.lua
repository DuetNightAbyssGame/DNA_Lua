
local SkillUtils = require "Utils.SkillUtils"
local CommonUtils = require "Utils.CommonUtils"

local Component = {}

-- function Component:RemovePassiveEffectBySkill(Skill)
--     self:RemovePassiveEffectByParam("OwnerSkill", Skill)
-- end

-- function Component:RemovePassiveEffectByBuff(Buff)
--     self:RemovePassiveEffectByParam("OwnerBuff", Buff)
-- end

-- function Component:RemovePassiveEffectByWeapon(Weapon)
--     self:RemovePassiveEffectByParam("OwnerWeapon", Weapon)
-- end

-- function Component:RemovePassiveEffectByRole(RoleId)
--     self:RemovePassiveEffectByParam("OwnerRole", RoleId)
-- end

-- function Component:RefreshPassiveEffectOnRemoveUniquePassive(ParamName, UniquePassivesExtraData, PassiveEffect)
--     if ParamName == "OwnerSkill" then
--         self:InitPassiveParamBySkill(UniquePassivesExtraData.OwnerSkill, UniquePassivesExtraData.OwnerWeapon, PassiveEffect)
--     elseif ParamName == "OwnerBuff" then
--         self:InitPassiveParamByBuff(UniquePassivesExtraData.OwnerBuff, PassiveEffect)
--     elseif ParamName == "OwnerWeapon" then
--         self:InitPassiveParamByWeapon(UniquePassivesExtraData.OwnerWeapon, UniquePassivesExtraData.Level, PassiveEffect)
--     elseif ParamName == "OwnerRole" then
--         self:InitPassiveParamByRoleId(UniquePassivesExtraData.RoleId, UniquePassivesExtraData.Level, PassiveEffect)
--     end
-- end

-- function Component:RemovePassiveEffectByParam(ParamName, ParamValue)
--     local DestroyUniquePassivesList = {}

--     for i = self.UniquePassivesList:Length(), 1, -1 do
--         local UniquePassivesExtraData = self.UniquePassivesList[i]
--         if UniquePassivesExtraData[ParamName] == ParamValue then
--             self.UniquePassivesList:Remove(i)
--         else
--             DestroyUniquePassivesList[UniquePassivesExtraData.PassiveEffectId] = UniquePassivesExtraData
--         end
--     end
    
--     for i = self.PassiveEffects:Length(), 1, -1 do
--         if self.PassiveEffects[i][ParamName] == ParamValue and not DestroyUniquePassivesList[self.PassiveEffects[i].PassiveEffectId] then
--             self:RemovePassiveFromEventDic(self.PassiveEffects[i])
--             self.PassiveEffects[i]:Destroy()
--             self.PassiveEffects:Remove(i)
--         elseif self.PassiveEffects[i][ParamName] == ParamValue and DestroyUniquePassivesList[self.PassiveEffects[i].PassiveEffectId] then
--             self:RefreshPassiveEffectOnRemoveUniquePassive(ParamName, DestroyUniquePassivesList[self.PassiveEffects[i].PassiveEffectId],  self.PassiveEffects[i])
--             self.UniquePassivesList:RemoveItem(DestroyUniquePassivesList[self.PassiveEffects[i].PassiveEffectId])
--         end
--     end
-- end

-- function Component:AddPassiveEffectsEventDic(Effect)
--     for _, EventName in ipairs(BattleEventName) do
--         local BattleEvent = Effect.BattleEvent:GetEvent(EventName)
--         if BattleEvent then
--             if BattleEventName.TeammateEvent[EventName] then
--                 Battle(self):RegiesterMulticastBattleEvent(EventName, self, BattleEvent)
--             end
            
--             if not self.PassiveEffectsEventDic then
--                 self.PassiveEffectsEventDic = {}
--             end
--             if not self.PassiveEffectsEventDic[EventName] then
--                 self.PassiveEffectsEventDic[EventName] = {}
--             end
--             self.PassiveEffectsEventDic[EventName][Effect] = 1
--         end
--     end
-- end

function Component:InitPassiveVars(Effect)
    local PassiveEffectId = Effect.PassiveEffectId
    local Data = DataMgr.PassiveEffect[PassiveEffectId]
    local Vars = Data.Vars
    if not Vars then
        return
    end

    local VarNameToGrowVars = {}
    local SkillLevelToGrowVars = {}

    local DefaultGrowVars = SkillUtils.GrowProxy('PassiveEffect', PassiveEffectId, Effect, Vars)
    local LevelInfo = Effect:GetSkillLevelInfo()
    local SkillLevel = LevelInfo.SkillLevel
    SkillLevelToGrowVars[SkillLevel] = DefaultGrowVars

    local VarSkillLevelSource = Data.VarSkillLevelSource
    if VarSkillLevelSource then
        for VarName, SkillId in pairs(VarSkillLevelSource) do
            local Skill = self:GetSkill(SkillId)
            if not Skill then
                Battle(self):ShowBattleError("初始化被动[" .. tostring(Effect.PassiveEffectId) .. "]参数Vars的时候,找不到技能[" .. tostring(SkillId) .. "]")
                Skill = Effect
            end

            local LevelInfo = Skill:GetSkillLevelInfo()
            local SkillLevel = LevelInfo.SkillLevel
            if not SkillLevelToGrowVars[SkillLevel] then
                local GrowVars = SkillUtils.GrowProxy('PassiveEffect', PassiveEffectId, Skill, Vars)
                SkillLevelToGrowVars[SkillLevel] = GrowVars
            end

            VarNameToGrowVars[VarName] = SkillLevelToGrowVars[SkillLevel]
        end
    end

    -- local GrowVars = SkillUtils.GrowProxy('PassiveEffect', PassiveEffectId, Effect, Vars)
    for _, VarName in pairs(CommonUtils.Keys(Vars)) do
        local GrowVars = DefaultGrowVars
        if VarNameToGrowVars[VarName] then
            GrowVars = VarNameToGrowVars[VarName]
        end

        local Value = GrowVars[VarName]
        Effect[VarName] = Value
    end
end

-- function Component:GetPrePassiveEffect(PassiveEffectId)
--     local Length = self.PassiveEffects:Length()
--     for i = Length, 1, -1 do
--         if self.PassiveEffects[i].PassiveEffectId == PassiveEffectId then
--             return self.PassiveEffects[i]
--         end
--     end
-- end

-- function Component:RemovePassiveEffect()
--     for i = 1, self.PassiveEffects:Length() do
--         self:RemovePassiveFromEventDic(self.PassiveEffects[i])
--         self.Overridden.RemovePassiveEffect(self, self.PassiveEffects[i])
--         self.PassiveEffects[i]:Destroy()
--     end
--     self.PassiveEffects:Clear()
--     self.UniquePassivesList:Clear()
-- end

function Component:RecoveryPassiveEffects()
    for SkillId, Skill in pairs(self.Skills) do
        if Skill.PassiveEffects then
            local Weapon = Skill.Weapon
            for _, PassiveEffectId in pairs(Skill.PassiveEffects) do
                self:AddPassiveEffectBySkill(Skill, PassiveEffectId, Weapon)
            end
        end
    end

    self:ServerSetRoleMod(self.RoleId, self.ModPassives, false)

    if self.Weapons then 
        for _, Weapon in pairs(self.Weapons) do
            self:AddWeaponModPassiveEffect(Weapon, Weapon.PassiveEffects)
        end
    end

    if GWorld.RougeLikeManager then
        self:AddPassiveEffectByRouge()
    end
end

function Component:AddPassiveEffectByRouge()
    local RougeLikeManager = GWorld.RougeLikeManager
    --for BlessingId, AwardInfo in pairs(RougeLikeManager.Blessings) do
    --    local ModEquip = DataMgr.RougeLikeBlessing[BlessingId].ModEquip
    --    local ModId = DataMgr.RougeLikeBlessing[BlessingId].BlessingMod
    --    if ModId and ModEquip then
    --        RougeLikeManager:AddPassiveEffectById(ModId, ModEquip, AwardInfo.Level-1)
    --    end
    --end
    --for TreasureId, AwardInfo in pairs(RougeLikeManager.Treasures) do
    --    local ModEquip = DataMgr.RougeLikeTreasure[TreasureId].ModEquip
    --    local ModId = DataMgr.RougeLikeTreasure[TreasureId].TreasureMod
    --    if ModId and ModEquip then
    --        RougeLikeManager:AddPassiveEffectById(ModId, ModEquip, AwardInfo.Level-1)
    --    end
    --end
    for BlessingGroupId, BlessingGroupCount in pairs(RougeLikeManager.BlessingGroup) do
        local GroupPassiveEffects = DataMgr.BlessingGroup[BlessingGroupId].PassiveEffects
        for _, PassiveEffectId in ipairs(GroupPassiveEffects) do
            local PassiveEffectActor = self:AddPassiveEffectByRole(self.CurrentRoleId, PassiveEffectId, 0)
            for i, Threshold in ipairs(DataMgr.BlessingGroup[BlessingGroupId].ActivateNeed) do
                if BlessingGroupCount < Threshold + RougeLikeManager.BlessingGroupDiscount then
                    break
                else
                    PassiveEffectActor:SetSkillLevel(i)
                end
            end
        end
    end
end

-- function Component:CanTriggerPassive(EventName)
--     if not self.PassiveEffectsEventDic then
--         return
--     end
--     if self.CheckSkillInActive and self:CheckSkillInActive(ESkillName.Passive) then
--         return
--     end
--     return self.PassiveEffectsEventDic[EventName]
-- end

-- function Component:TriggerPassiveEvent(EventName, ...)
--     if not self.PassiveEffectsEventDic then
--         return
--     end
--     local _Data = self.PassiveEffectsEventDic[EventName]
--     if not _Data then
--         return
--     end
--     self:RealTriggerPassiveEvent(_Data, EventName, ...)
-- end

-- function Component:RealTriggerPassiveEvent(_Data, EventName, ...)
--     for _, Effect in pairs(CommonUtils.Keys(_Data)) do
--         if IsValid(Effect) and Effect.PassiveOwner then
--             Effect.BattleEvent:GetEvent(EventName):Broadcast(...)
--         end
--     end
-- end

-- function Component:RemovePassiveFromEventDic(PassiveEffect)
--     if not self.PassiveEffectsEventDic then
--         return
--     end
--     for k, v in pairs(self.PassiveEffectsEventDic) do
--         if v[PassiveEffect] then
--             v[PassiveEffect] = nil
--         end

--         local BattleEvent = PassiveEffect.BattleEvent:GetEvent(k)
--         if BattleEventName.TeammateEvent[k] and BattleEvent then 
--             Battle(self):UnRegisterMulticastBattleEvent(k, self, BattleEvent)
--         end

--     end
-- end

function Component:GetTeammateEvent()
    return BattleEventName.TeammateEvent
end

function Component:GetBattleEventNames()
    local BattleEventNames = {}
    for _, EventName in ipairs(BattleEventName) do
        table.insert(BattleEventNames, EventName)
    end
    return BattleEventNames
end

return Component
