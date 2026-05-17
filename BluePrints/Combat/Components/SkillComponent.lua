
local Component = {}

--function Component:Init_SkillComponent_()
--    self.Type_2_Skills = {}
--    self.ForceSkills = {}
--    self.SeqSkills = {}
--    self.SkillObjectClass = UE4.UClass.Load('/Game/BluePrints/Combat/Skill/BP_SkillObject.BP_SkillObject')
--
--    self:SetAttr('CDRate', 1)
--end

--function Component:CreateSkill(SkillId, SkillLevel, SkillGrade, ExtraInfo)
--    -- PrintTable({SkillId=SkillId, SkillLevel=SkillLevel, SkillGrade=SkillGrade})
--    self.CheckValidSkill(SkillId, SkillLevel, SkillGrade)
--    local Skill = NewObject(self.SkillObjectClass)
--    ExtraInfo = ExtraInfo or {}
--    Skill:InitSkillInfo(SkillId, SkillLevel, SkillGrade)
--    -- 做了优化，所以这里需要多调用一次
--    Skill:SetSkillLevelInfo(Skill)
--    Skill.Weapon = ExtraInfo.Weapon
--    self:RawAddSkill(SkillId, Skill)
--    return Skill
--end

--function Component:AddSkill(SkillId, SkillLevel, SkillGrade, ExtraInfo)
--    -- PrintTable({AddSkill=SkillId, IsAu=IsAuthority(self), SkillLevel=SkillLevel, SkillGrade=SkillGrade, ExtraInfo=ExtraInfo, Eid=self.Eid},10)
--    local Skill = self:GetSkill(SkillId)
--    assert(not Skill, "已经存在技能:"..tostring(SkillId))
--
--    ExtraInfo = ExtraInfo or {}
--    Skill = self:CreateSkill(SkillId, SkillLevel, SkillGrade, ExtraInfo)
--    if not Skill then
--        return
--    end
--
--    local Index = ExtraInfo.Index
--    if Index then
--        self.SeqSkills[Index] = SkillId
--    end
--
--    if Skill.SkillType then
--        if self.Type_2_Skills[Skill.SkillType] == nil then
--            self.Type_2_Skills[Skill.SkillType] = SkillId
--        end
--    end
--
--    if Skill.PassiveEffects then
--        for k,v in pairs(Skill.PassiveEffects) do
--            self:AddPassiveEffectBySkill(Skill, v, ExtraInfo.Weapon)
--        end
--    end
--
--    if Skill.SubSkills then
--        for k, SubSkillId in pairs(Skill.SubSkills) do
--            self:AddSkill(SubSkillId, SkillLevel, SkillGrade, {Weapon = ExtraInfo.Weapon})
--        end
--    end
--
--    return Skill
--end

--function Component:ClearSkill()
--    for SkillId, Skill in pairs(self.Skills) do
--        self:RemoveSkill(SkillId)
--    end
--end
--
--function Component:RemoveSkill(SkillId)
--    -- PrintTable({RemoveSkill = SkillId, IsAuthority= IsAuthority(self), self=self})
--    local Skill = self:GetSkill(SkillId)
--    if not Skill then
--        return
--    end
--    
--    if Skill.SkillType then
--        if self.Type_2_Skills and self.Type_2_Skills[Skill.SkillType] == SkillId then
--            self.Type_2_Skills[Skill.SkillType] = nil
--        end
--    end
--
--    if Skill.PassiveEffects then
--        self:RemovePassiveEffectBySkill(Skill)
--    end
--
--    if Skill.SubSkills then
--        for k, SubSkillId in pairs(Skill.SubSkills) do
--            self:RemoveSkill(SubSkillId)
--        end
--    end
--
--    self:RawRemoveSkill(SkillId)
--end

-- function Component:SetForceSkills(ActivateSkills)
--     self.ForceSkills:Clear()
--     for PrimitiveSkillId, ReplaceSkillId in pairs(ActivateSkills) do
--         self.ForceSkills:Add(PrimitiveSkillId, ReplaceSkillId)
--     end
-- end

-- function Component:ActivateSkill(SkillId)
--     local Skill = self:GetSkill(SkillId)
--     if Skill == nil then
--         return
--     end

--     if Skill.SkillType then
--         self.Type_2_Skills:Add(Skill.SkillType, SkillId)
--     end
-- end

-- function Component:GetSkillId_Lua(SkillName)
--     return self["Get".. SkillName .. "Skill"](self) or 0
-- end

-- _Type填写Const文件里的Attack和Skill
-- function Component:GetSkillByType(_Type)
--     local SkillId = self.Type_2_Skills:Find(_Type)
--     return self.ForceSkills:Find(SkillId) or SkillId
-- end

-- TODO@GMY: 有空整理下这段逻辑
-- function Component:GetSkillByType(_Type)
--     local Ret = self.Overridden.GetSkillByType(self, _Type)
--     if Ret == 0 then
--         return nil
--     end
--     return Ret
-- end

--function Component:CheckSkillWeaponCanUse(Skill)
--    local WeaponTag = nil
--    if not self:IsPlayer() then 
--        if self:CanInShootingTag(Skill) then 
--            WeaponTag = "Ranged"
--        else
--            WeaponTag = "Melee"
--        end
--    else
--        WeaponTag = Skill.SkillWeaponType
--    end
--    if not WeaponTag then
--        return true
--    end
--    return not self:CheckWeaponForbidByWeaponTag(WeaponTag)
--end

--function Component:GetSkillCanUseTime(SkillId)
--    local Skill = self:GetSkill(SkillId)
--    if not Skill then
--        return 0
--    end
--
--    return Skill:GetUseTime()
--end
--
--function Component:GetSkillCdTimeAndPercent(SkillId)
--    local Skill = self:GetSkill(SkillId)
--    if not Skill then
--        -- Error，没有此类技能，可能是表填错了
--        return -2, 0
--    end
--    return Skill:GetSkillCdTimeAndPercent()
--end

--function Component:SetSkillTimestamp(SkillId, IsRoot)
--    local Skill = self:GetSkill(SkillId)
--    if not Skill then
--        return
--    end
--
--    Skill:SetSkillTimestamp()
--
--    if IsRoot then
--        local _type = Skill.CDType
--        if _type then
--            local SkillIds = DataMgr.CDType2Skills[_type]
--            for _SkillId, _ in pairs(SkillIds) do
--				if _SkillId ~= SkillId then
--					self:SetSkillTimestamp(_SkillId)
--				end
--            end
--        end
--    end
--end

-- -- 是否能够用技能类型取消
-- --- @param SkillType string
-- function Component:CheckCanSkillTypeCancel(SkillType)
--     local CurSkillId = self.CurrentSkillId
--     if CurSkillId == 0 then return true end

--     local CurSkillType = DataMgr.Skill[CurSkillId][1][0].SkillType

--     if self:IsForbidCurSkillCancel() and SkillType == CurSkillType then return false end

--     local SkillCancelType = UE.ESkillCancelType.ENUM_MAX 

--     -- 先把类型转为C++的Enum类, 这里看看有没有必要单独抽出来
--     if SkillType == 'Attack' then SkillCancelType = UE.ESkillCancelType.Attack
--     elseif SkillType == 'HeavyAttack' then SkillCancelType = UE.ESkillCancelType.HeavyAttack 
--     elseif SkillType == 'FallAttack' then SkillCancelType = UE.ESkillCancelType.FallAttack 
--     elseif SkillType == 'SlideAttack' then SkillCancelType = UE.ESkillCancelType.SlideAttack 
--     elseif SkillType == 'Block' then SkillCancelType = UE.ESkillCancelType.Block 
--     elseif SkillType == 'Shooting' then SkillCancelType = UE.ESkillCancelType.Shooting 
--     elseif SkillType == 'HeavyShooting' then SkillCancelType = UE.ESkillCancelType.HeavyShooting
--     elseif SkillType == 'Reload' then SkillCancelType = UE.ESkillCancelType.Reload 
--     elseif SkillType == 'Skill1' then SkillCancelType = UE.ESkillCancelType.Skill1 
--     elseif SkillType == 'Skill2' then SkillCancelType = UE.ESkillCancelType.Skill2 
--     elseif SkillType == 'Skill3' then SkillCancelType = UE.ESkillCancelType.Skill3 
--     elseif SkillType == 'Skill1Hold' then SkillCancelType = UE.ESkillCancelType.Skill1 
--     elseif SkillType == 'Skill2Hold' then SkillCancelType = UE.ESkillCancelType.Skill2 
--     elseif SkillType == 'Skill3Hold' then SkillCancelType = UE.ESkillCancelType.Skill3 
--     elseif SkillType == 'Condemn' then SkillCancelType = UE.ESkillCancelType.Condemn 
--     end
    
--     return self:CanSkillTypeCancel(SkillCancelType) -- 这里调用到C++侧的实现去判断
-- end

-- 是否能够用该技能取消
--- @param SkillId number
-- function Component:CheckCanSkillCancel(SkillId)
--     local SkillType = DataMgr.Skill[SkillId][1][0].SkillType
--     if SkillType then
--         return self:CheckCanSkillTypeCancel(SkillType)
--     end 
    
--     return false
-- end

-- function Component:IsSkillNotInCD(SkillId)
--     ---@type BP_SkillObject_C
--     local SkillObject = self:GetSkill(SkillId)
--     if not SkillObject then
--         return false
--     end
--     return SkillObject:GetUseTime() > 0
-- end

-- function Component:HandleCheckUseSkill(SkillId, RetCode)
--     if RetCode == ESkillUseRetCode.Success then
--         return true
--     end

--     if RetCode == ESkillUseRetCode.UseTimeOut then
--         if self:IsMainPlayer() then
--             local SkillObject = self:GetSkill(SkillId)
--             local SkillLevel = SkillObject.SkillLevel
--             local SkillGrade = SkillObject.SkillGrade
--             local SkillConfig = DataMgr.Skill[SkillId][SkillLevel][SkillGrade]

--             if SkillConfig.HideCDToast and SkillConfig.HideCDToast == Const.bHideSkillCD then
--                 -- hide cd toast
--             else
--                 UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, "TOAST_SKILL_IN_CD")
--             end
--         end
--     elseif RetCode == ESkillUseRetCode.OutOfBullet then
--         if self.CurrentSkillId == 0 or self:CheckCanSkillCancel(self:GetSkillByType(UE.ESkillType.Reload)) then
--             EventManager:FireEvent(EventID.OutOfBullet)
--         end
--     elseif RetCode == ESkillUseRetCode.FullOfMagazine then
--         if(self.CurrentSkillId == 0 or self:CheckCanSkillCancel(self:GetSkillByType(UE.ESkillType.Reload)))then
--             EventManager:FireEvent(EventID.FullOfMagazine)
--         end
--     end
--     return false
-- end

-- function Component.CheckValidSkill(SkillId, SkillLevel, SkillGrade)
--     assert(DataMgr.Skill[SkillId], SkillId.."技能不存在")
--     assert(DataMgr.Skill[SkillId][SkillLevel],SkillId.."技能的"..SkillLevel.."等级不存在")
--     assert(DataMgr.Skill[SkillId][SkillLevel][SkillGrade], SkillId.."技能的"..SkillLevel.."等级的"..SkillGrade.."阶级不存在")
-- end

return Component
