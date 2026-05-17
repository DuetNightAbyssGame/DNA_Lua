
-- local Component = {}

-- function Component:OnCharacterReady()
--     Battle(self):RegisterBattleEvent(BattleEventName.AfterSkill, self, "OnSkillStoped")

--     if self:IsMainPlayer() then
--         self.BattleComboUI = UIManager(self):LoadUINew("BattleCombo")
--     end

--     self.ComboRestTime = nil
--     self.CachedComboCount = self:GetAttr('ComboCount') or 0    
--     self.IsDirty = false
--     self.ClearComboFromReason = nil
-- end

-- function Component:ReceiveTick(DeltaSeconds)
--     if self.ComboRestTime and self.ComboRestTime > 0 and self.ComboHoldTime then 
--         self.ComboRestTime = self.ComboRestTime - DeltaSeconds
--         if self.ComboRestTime <= 0 then 
--             self:ZeroComboCount(UE4.EClearComboReason.Timelimit)
--         else
--             if self.ComboHoldTime > 0 and self.BattleComboUI then 
--                 self.BattleComboUI:SetComboHoldTimeProgress(self.ComboRestTime / self.ComboHoldTime)
--             end
--         end

--     end

--     -- 结算连击
--     if self.IsDirty then 
--         -- 是否要中断连击
--         if self.ClearComboFromReason then 
--             self.CachedComboCount = 0
--         end

--         self:TriggerComboCountChanged(self.ClearComboFromReason)
--     end
-- end

-- function Component:OnSkillStoped(Player, Skill)
--     -- local SkillWeaponType = Skill.SkillWeaponType
    
--     -- if self.Eid == Player.Eid then 
--     --     -- 显赫武器被换下来时，清空连击数
--     --     if not self.BuffManager.UseSummonWeapon and SkillWeaponType == "Ultra" then 
--     --         self:ZeroComboCount(UE4.EClearComboReason.DisableUltraWeapon)
--     --     end
--     -- end
-- end

-- function Component:AddComboCount(ComboCount)
--     if ComboCount == nil or ComboCount < 0 then
--         return
--     end
--     -- AddTimer里调用过RemoveTimer了 这里不调用了
--     --self:RemoveTimer("ZeroComboCount")
--     self.MaxComboCount = self.MeleeWeapon:GetAttr("MaxComboCount")
--     self.ComboHoldTime = self.MeleeWeapon:GetAttr("ComboHoldTime")

--     self.CachedComboCount = math.min((self.CachedComboCount or 0) + ComboCount, self.MaxComboCount)
--     self.ComboRestTime = self.ComboHoldTime
--     self.IsDirty = true
-- end

-- function Component:CheckComboCountChanged(BeforeComboCount, BeforeComboLevel, FromReason)
--     local CurrentComboCount = self:GetAttr('ComboCount')
--     local CurrentComboLevel = self:GetAttr('ComboLevel')
--     local MaxComboCount = self.MeleeWeapon:GetAttr("MaxComboCount")

--     if (BeforeComboCount == CurrentComboCount and BeforeComboLevel == CurrentComboLevel and CurrentComboCount < MaxComboCount) then
--         return
--     end
--     Battle(self):TriggerBattleEvent(BattleEventName.ComboCountChanged, self, self.MeleeWeapon, BeforeComboCount, BeforeComboLevel, CurrentComboCount, CurrentComboLevel, FromReason)
--     if self.BattleComboUI then 
--         self.BattleComboUI:OnBattleCountChanged(self, self.MeleeWeapon, BeforeComboCount, BeforeComboLevel, CurrentComboCount, CurrentComboLevel, FromReason)
--     end
-- end

-- function Component:TriggerComboCountChanged(FromReason)
--     local NewComboCount = self.CachedComboCount
--     local NewComboLevel = self:CalcComboLevel(NewComboCount)
    
--     local CurrentComboCount = self:GetAttr('ComboCount') or 0 
--     local CurrentComboLevel = self:GetAttr('ComboLevel') or 0

--     self:SetAttr('ComboCount', NewComboCount)
--     self:SetAttr('ComboLevel', NewComboLevel)

--     Battle(self):TriggerBattleEvent(BattleEventName.ComboCountChanged, self, self.MeleeWeapon, CurrentComboCount, CurrentComboLevel, NewComboCount, NewComboLevel, FromReason)

--     if self.BattleComboUI then 
--         self.BattleComboUI:OnBattleCountChanged(self, self.MeleeWeapon, CurrentComboCount, CurrentComboLevel, NewComboCount, NewComboLevel, FromReason)
--     end

--     self.IsDirty = false
--     self.ClearComboFromReason = nil 
-- end

-- function Component:ZeroComboCount(FromReason)
--     DebugPrint("Tianyi@ Clear ComboCount , Reason = " .. tostring(FromReason))
--     self.ClearComboFromReason = FromReason
--     self.IsDirty = true
--     self.ComboRestTime = nil
-- end

-- function Component:CalcComboLevel(Count)
--     local ComboLevel = 0
--     for _, info in ipairs(DataMgr.ComboLevel) do
--         if Count < info.ComboCount then
--             return ComboLevel
--         else
--             ComboLevel = info.ComboLevel
--         end
--     end

--     return ComboLevel
-- end

-- -- C++ interface implementation begin
-- function Component:BP_AddComboCount(Value)
--     self:AddComboCount(Value)
-- end
-- -- C++ interface implementation end

-- return Component
