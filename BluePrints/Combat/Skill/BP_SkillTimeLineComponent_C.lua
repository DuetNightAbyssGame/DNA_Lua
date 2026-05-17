  --
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local BP_SkillTimeLineComponent_C = Class()

--function BP_SkillTimeLineComponent_C:Initialize(Initializer)
--end

function BP_SkillTimeLineComponent_C:ReceiveBeginPlay()
    -- self.Overridden.ReceiveBeginPlay(self)
end

--function BP_SkillTimeLineComponent_C:ReceiveEndPlay()
--end

  -- @zyh已移到C++，稳定后删除
--function BP_SkillTimeLineComponent_C:ReceiveTick(DeltaSeconds)
--    -- self.Overridden.ReceiveTick(self, DeltaSeconds)
--
--    -- if not self.CurrentSkillNode then
--    --     return
--    -- end
--    -- if self.OwnerCharacter:IsSkillFinished() then
--    --     return
--    -- end
--    -- local Now1 = URuntimeCommonFunctionLibrary.GetNowMS()
--
--    self:TickByTimeLine()
--    -- local Now2 = URuntimeCommonFunctionLibrary.GetNowMS()
--    -- PrintTable({T=Now2-Now1})
--end
  
  -- @gmy已移到C++，稳定后删除
--function BP_SkillTimeLineComponent_C:UseSkill(Skill, PreTarget)
--    self.SkillFinish = false
--    self.SkillPreTarget = PreTarget -- 预先设置一个技能目标，该技能触发的技能效果会优先选择该目标
--    self:InitSkillNode(Skill)
--    return true
--end

  -- @zyh已移到C++，稳定后删除
--function BP_SkillTimeLineComponent_C:CheckFirstNodeCondition(SkillId)
--    -- 检查第一个节点进入的条件
--    local Skill = self.OwnerCharacter:GetSkill(SkillId)
--    return self.OwnerCharacter:DoCheckSkillNodeCondition(SkillId, Skill.BeginNodeId)
--end
--  
--function BP_SkillTimeLineComponent_C:CheckMultiSpCondition(SkillId, CostMultiplier)
--    local Skill = self.OwnerCharacter:GetSkill(SkillId)
--    return self.OwnerCharacter:CheckMultiSpCondition(SkillId, Skill.BeginNodeId, CostMultiplier)
--end
  
-- function BP_SkillTimeLineComponent_C:OnNotifyMakeSound(SoundSourceId, SocketName)
--     local SoundLoc = self.OwnerCharacter:K2_GetActorLocation()
--     if SocketName then
--         SoundLoc = self.OwnerCharacter.Mesh:GetSocketLocation(SocketName)
--     end
--     Battle(self):MakeSound(self.OwnerCharacter, SoundSourceId, SoundLoc)
-- end
  

return BP_SkillTimeLineComponent_C
