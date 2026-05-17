local Const = require "Const"

local Component = {}


-- function Component:CanApplyCutToughness(Target)
--     if not self:HasToughness(Target) then 
--         return false 
--     end 

--     if Target:IsCharacter() and not Target:CanApplyToughness() then 
--         return false
--     end

--     return true
-- end

--- 施加受击效果
-- -@param Source table 效果来源
-- -@param Target table 效果目标
-- -@param CutTNParam table 削韧的参数
-- -@param HitRule string 具体的受击规则
-- -@param CutTNInfo table 削韧信息
-- -@param Skill table 施加受击效果的技能
-- function Component:ApplyCutToughness(Source, Target, CutTNParam, HitRule, CutTNInfo, Skill)
--     HitRule = HitRule or {}

--     if not self:CanExecute() then
--         return false
--     end

--     if not self:CanApplyCutToughness(Target) then 
--         return false 
--     end

--     local HitType = nil -- 受击类型
--     local CauseHitType = nil -- 造成的受击类型，如第一次受击、死亡受击等
--     local EffectParamentTable = {}  -- 受击效果的参数表
--     local CutTNValue = CutTNParam.Value     -- 削韧数值
--     local IsForceCauseHit = CutTNParam.ForceHit or false   -- 是否强制触发受击

--     local TNValue = Target:GetAttr("TN")

--     -- 判断应用的削韧效果并计算实际削韧值
--     local RealCutValue = 0
    
--     if CutTNInfo then 
--         if UBattleFunctionLibrary.GetIsEmptyTN(CutTNInfo, Target) then
--             RealCutValue = TNValue
--         else
--             RealCutValue = CutTNInfo.CutTNModifyRate * CutTNValue * (Target:GetAttr("TNResistance") or 1)
--         end
--     end

--     -- 如果被攻击对象是玩家，则无视削韧逻辑直接走受击表现
--     if Target:IsPlayer() then 
--         IsForceCauseHit = true 
--         RealCutValue = 0
--     end

--     -- 韧性等级压制
--     local SourceLevel = Source:GetAttr("Level")
--     local TargetLevel = Target:GetAttr("Level")
--     local CutValueModifer = 1
--     if TargetLevel and SourceLevel and (TargetLevel - SourceLevel >= Const.CutTNLevelThreshold) then 
--         CutValueModifer = Const.CutTNLevelModifer
--     end
--     RealCutValue = RealCutValue * CutValueModifer

--     local BeforeTN = Target:GetAttr("TN")
--     self:AddTN(Source, Target, -RealCutValue)
--     local CurrentTN = Target:GetAttr("TN")
--     -- DebugPrint('Tianyi@ 当前韧性: ' .. CurrentTN)
--     -- 削韧后
--     self:TriggerBattleEvent(BattleEventName.AfterCutToughness, Source, Target, Skill, BeforeTN, CurrentTN, RealCutValue)
--     -- 被削韧后
--     self:TriggerBattleEvent(BattleEventName.AfterBeCutToughness, Target, Source, Skill, BeforeTN, CurrentTN, RealCutValue)

--     if BeforeTN > 0 and CurrentTN <= 0 then 
--         self:TriggerBattleEvent(BattleEventName.OnToughnessToZero, Target)
--     end 

--     -- 如果是角色，触发削韧引发的受击效果
--     if Target:IsCharacter() then 
--         -- 分发给客户端的结构体
--         ---@class HitResult
--         ---@field public TargetEid string
--         ---@field public CauseHitType number
--         ---@field public HitType string
--         local ResultInfo = {
--             TargetEid = Target.Eid, -- 受击对象
--             CauseHitType = nil, -- CauseHit类型
--             HitType = nil   -- 受击类型
--         }
        
--         -- 开始计算受击效果:
--         -- 触发死亡受击效果
--         if HitRule.CauseDie and Target:CharacterInTag("Dead") then      
        
--             HitType = HitRule.CauseDie 
--             EffectParamentTable = HitRule.CauseDieParam or {}
--             CauseHitType = Const.CauseHitTypeDie 
--             ResultInfo.CauseHitType = CauseHitType

--             IsForceCauseHit = true
        
--         -- 韧性被削到零触发的受击效果
--         elseif HitRule.CauseHit and CurrentTN <= 0 then 
--             HitType = HitRule.CauseHit
--             EffectParamentTable = HitRule.CauseHitParam or {}
--             CauseHitType = Const.CauseHitTypeNormal
--             ResultInfo.CauseHitType = CauseHitType

--         -- 若带有FirstHit参数，则怪物的第一次受击必触发受击动作
--         elseif HitRule.FirstHit and not Target.IsFirstCauseHit and not Target:IsBossMonster() then 
--             Target.IsFirstCauseHit = true

--             HitType = HitRule.FirstHit 
--             EffectParamentTable = HitRule.FirstHitParam or {}
--             CauseHitType = Const.CauseHitTypeFirst
--             ResultInfo.CauseHitType = CauseHitType
            
--             IsForceCauseHit = true 
--             -- print(_G.LogTag, "TTT", "触发 FirstCauseHit")

--         -- 触发默认的削韧效果，走默认的韧性规则
--         elseif HitRule.CauseHit then 
--             HitType = HitRule.CauseHit
--             CauseHitType = Const.CauseHitTypeNormal
--             ResultInfo.CauseHitType = CauseHitType
--         end

--         -- 计算最终的受击效果
--         local FinalHitType = nil 
--         if HitType then
--             local CurrentHitMaxLevel = Const.HitToLevel[HitType]
--             local CurrentHitLevel = 0
--             if IsForceCauseHit or Target:CanCauseMaxHit() then -- 韧性削到0则可以触发最高的受击效果
--                 CurrentHitLevel = math.min(CurrentHitMaxLevel, Const.HitToLevel.GrabHit)
--             else
--                 local CutPer = RealCutValue / Target:GetAttr("MaxTN")
--                 if CutPer < 0.2 then
--                     CurrentHitLevel = math.min(CurrentHitMaxLevel, Const.HitToLevel.BoneHit)
--                 else
--                     CurrentHitLevel = math.min(CurrentHitMaxLevel, Const.HitToLevel.LightHit)
--                 end
--             end
            
--             -- 计算最终的受击类型
--             FinalHitType = HitType 
--             if CurrentHitLevel < CurrentHitMaxLevel then
--                 FinalHitType = Const.LevelToHit[CurrentHitLevel]
--             end
--         end

--         -- Boss的受击附加规则
--         if Target:IsBossMonster() then
--             local CurrentHitLevel = self:BossCauseHit(Target, TNValue)
--             if CurrentHitLevel and CurrentHitLevel > 0 then 
--                 FinalHitType = Const.LevelToHit[CurrentHitLevel]
--             else 
--                 FinalHitType = nil
--             end
--         end
        
--         local IsHitSuccess = false
--         if FinalHitType then 
--             if CurrentTN <= 0 then
--                 Target:SetSuperArmor(false, "AnimNotify")
--             end
            
--             -- DebugPrint("Tianyi@ 最终触发结果: " .. FinalHitType)
--             IsHitSuccess = Target:ApplyEffectHitPerformance(Source, FinalHitType, CauseHitType, CutTNParam)
--             ResultInfo.HitType = FinalHitType
--         else 
--             if CurrentTN <= 0 then
--             -- 表中没有提供CauseHit参数，则保持韧性为0不进入回复
--             -- Boss依然要触发处刑
--                 local ShouldRecoverTN = Target:HasHandlePenalize()
--                 Target:SetTNBeginRecover(ShouldRecoverTN)
--                 return false, ResultInfo
--             else
--                 Target:SetTNBeginRecover(false)
--             end
--         end

--         return IsHitSuccess, ResultInfo
--     end

--     return false, {}
-- end

function Component:Play_UsePenalizeSkill(Content)
    local Target = self:GetEntity(Content.TargetEid)
    local Source = self:GetEntity(Content.SourceEid)
    if Target then
        Source.CondemnMonsterEid = Content.TargetEid
        if Target.GetCanOpen then
            Target:GetCanOpen()
        end
    end
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    ---@type BP_UIManagerComponent_C
    local UIManager = GameInstance:GetGameUIManager()
    ---@type Battle_Execute_PC_C
    local DefeatedUI = UIManager:GetUIObj("DefeatedInteract")
    if DefeatedUI then
        DefeatedUI:StopAllAnimations()
        DefeatedUI:PlayAnimation(DefeatedUI.Press)
    end
end

function Component:Play_StartTargetCondemn(Content)
    local Target = self:GetEntity(Content.Eid)
    if Target then
        Target:PlayCondemnMontage()
    end
end

function Component:BossCauseHit(Target, TNValue)
    local ReturnHitLevel = nil
    local TargetCharInfo = Target.BattleCharInfo
    local TargetRoleId = TargetCharInfo.BattleRoleId
    local DeductToughnessHitIndex = DataMgr.DeductToughnessHitIndex[TargetRoleId]
    if DeductToughnessHitIndex then
        local DeductToughnessHit = TargetCharInfo.DeductToughnessHit
        local TNMax = Target:GetAttr("MaxTN")
        local TNPercent = TNValue / TNMax * 100 -- 修正为百分比数值
        local RemainTNPercent = Target:GetAttr("TN") / TNMax * 100 -- 修正为百分比数值
        -- print(_G.LogTag, "TTT 剩余TN百分比", RemainTNPercent, "TN百分比", TNPercent)
        for _, Percent in ipairs(DeductToughnessHitIndex) do
            local HitLevel = DeductToughnessHit[Percent]
            -- print(_G.LogTag, "TTT 检查Boss受击", HitLevel, Percent)
            if RemainTNPercent <= Percent and TNPercent > Percent then
                -- print(_G.LogTag, "TTT 选中Boss受击", HitLevel, Percent)
                ReturnHitLevel = Const.HitToLevel[HitLevel]
                break
            end
        end
    end
    return ReturnHitLevel
end


return Component
