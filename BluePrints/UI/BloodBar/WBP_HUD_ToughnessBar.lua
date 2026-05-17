--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_HUD_ToughnessBar_C
local WBP_HUD_ToughnessBar_C = Class("BluePrints.UI.BP_UIState_C")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function WBP_HUD_ToughnessBar_C:InitConfig_Lua(ActorOwner)
    self.Owner = rawset(self, "Owner", ActorOwner)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    self.SceneMgrComponent = GameInstance:GetSceneManager()
end

-- function WBP_HUD_ToughnessBar_C:IsAttacking()
--     if self.LastAttackTime then
--         return UE4.UGameplayStatics.GetRealTimeSeconds(self) - self.LastAttackTime < Const.BloodBarDelayTime
--     else
--         return false
--     end
-- end

-- function WBP_HUD_ToughnessBar_C:OnDamaged(ActionName, DamageEvent)
    
--     -- 缓存打击技能是否为攻击
--     -- self:CheckIsReduceDelay(DamageEvent)
--     local NowTime = UE4.UGameplayStatics.GetRealTimeSeconds(self)
--     if DamageEvent.SkillId then
--         local SkillInfo = DataMgr.Skill[DamageEvent.SkillId]
--         if SkillInfo and SkillInfo[1] then
--             -- 技能的伤害类型一般不改，直接拿默认等级就可以
--             local SkillGradeInfo = SkillInfo[1][0]
--             if SkillGradeInfo then
--                 local SkillType = SkillGradeInfo.SkillType
--                 if SkillType == 'Attack' then
--                     self.LastAttackTime = NowTime
--                 end
--             end
--         end
--     end
-- end

-- function WBP_HUD_ToughnessBar_C:CharOnDead()
--     local function PlayAnimFinished()
--         self:SetVisibility(UE4.ESlateVisibility.Collapsed)
--     end
--     self:StopAllAnimations()
--     if (IsValid(self.SceneMgrComponent) and self.SceneMgrComponent.SpecialMonsterInfo[self.OwnerEid]) then
--         self.SceneMgrComponent.SpecialMonsterInfo[self.OwnerEid] = nil
--     end
--     self:PlayAnimation(self.OutAnimation)
--     self:BindToAnimationFinished(self.OutAnimation, {self, PlayAnimFinished})
-- end

-- function WBP_HUD_ToughnessBar_C:CheckIsShowByType()
--     return self.SizeBox_0:GetRenderOpacity() > 0
-- end


return WBP_HUD_ToughnessBar_C
