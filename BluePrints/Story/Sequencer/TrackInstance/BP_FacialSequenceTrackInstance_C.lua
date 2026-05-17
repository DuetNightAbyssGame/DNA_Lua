local M = Class()

-- function M:OnInitializeEvent()
--     self.MouthBaseCountSet = {}
--     self.MouthBaseIndexSet = {}
--     self.Overridden.OnInitializeEvent(self)
-- end

-- function M:OnDestroyedEvent()
--     self.MouthBaseSet = nil
-- 	self.Overridden.OnDestroyedEvent(self)
-- end

-- function M:UpdateFacial(FacialData)
--     local SoundBaseInstance = FacialData.SoundBaseInstance
--     self.Overridden.UpdateFacial(self, FacialData)
--     if SoundBaseInstance ~= FacialData.SoundBaseInstance then
--         for i = 1, self.FacialSaveData:Num(), 1 do
--             DebugPrint("UpdateFacial", i, self.FacialSaveData:Num())
--             local TempData = self.FacialSaveData[i]
--             if TempData.SoundBaseInstance == SoundBaseInstance then
--                 TempData.SoundBaseInstance = FacialData.SoundBaseInstance
--             end
--             self.FacialSaveData[i] = TempData
--         end
--         if IsValid(FacialData.Section) 
--             and IsValid(FacialData.Section.SoundBaseMouth) then
--             self.MouthBaseIndexSet[FacialData.Section] = FacialData.SoundBaseInstance
--         end
--     end
-- end

-- function M:StopFacial(FacialData)
--     local Section = FacialData.Section
--     local Character = FacialData.Character
--     if (not IsValid(Section)) or not (IsValid(Character)) then
--         return
--     end

--     local AnimInstance = Character.NpcAnimInstance

--     if not IsValid(AnimInstance) then
--         return
--     end

--     AnimInstance:StartBlinkTimer()

--     self.Montages:Remove(Section.NpcEye1)
--     self.Montages:Remove(Section.NpcMouthLoop)
--     local EyeProxy = USequenceMontageLibrary.GetMontageInstanceProxy(AnimInstance, FacialData.EyeInstance);
-- 	local MouthProxy = USequenceMontageLibrary.GetMontageInstanceProxy(AnimInstance, FacialData.MouthInstance);

-- 	USequenceMontageLibrary.StopAnimMontage(EyeProxy, 0.25);
-- 	USequenceMontageLibrary.StopAnimMontage(MouthProxy, 0.25);


--     if IsValid(Section.SoundBaseMouth) then
--         local Index = self.MouthBaseIndexSet[Section.SoundBaseMouth] or -1
--         local Count = self.MouthBaseCountSet[Section.SoundBaseMouth] or 0
--         Count = Count - 1
--         self.MouthBaseCountSet[Section.SoundBaseMouth] = Count
--         if (Count <= 0) then
--             Count = 0
--             self.MouthBaseCountSet[Section.SoundBaseMouth] = nil
--             self.Montages:Remove(Section.SoundBaseMouth)
--             local SoundProxy = USequenceMontageLibrary.GetMontageInstanceProxy(AnimInstance, Index);
--             USequenceMontageLibrary.StopAnimMontage(SoundProxy, 0.25);
--         end
--     end
-- end

-- function M:PlayFacial(Section, Input)
--     local FacialSaveData = UE.FFacialSaveData()
--     FacialSaveData.Input = Input
--     FacialSaveData.Section = Section
--     FacialSaveData.Character = self:GetAnimatedObject()

--     if not Section then
--         return FacialSaveData
--     end

--     if not FacialSaveData.Character then
--         return FacialSaveData
--     end
--     local Character = FacialSaveData.Character

--     local AnimInstance = Character.NpcAnimInstance

--     if not AnimInstance then
--         return FacialSaveData
--     end

--     if (Section.bForbidDefaultBlink) then
--         AnimInstance:StopBlinkTimer()
--     end

--     if self:GetNumInputs() == 0 then
--         Character:StopFacial()
--     end

--     Section:RefreshFacial(Character)

--     UTalkFunctionLibrary.SetMontageBlendInTime(Section.NpcEye1, 0)
--     UTalkFunctionLibrary.SetMontageBlendInTime(Section.NpcMouthLoop, 0)
--     UTalkFunctionLibrary.SetMontageBlendInTime(Section.SoundBaseMouth, 0)

--     self:TryClearAllExternMontage(AnimInstance, Section.NpcEye1)
--     self:TryClearAllExternMontage(AnimInstance, Section.NpcMouthLoop)
--     self:TryClearAllExternMontage(AnimInstance, Section.SoundBaseMouth)

--     self:TryPlayMontage(AnimInstance, Section.NpcEye1)
--     self:TryPlayMontage(AnimInstance, Section.NpcMouthLoop)
--     self:TryPlayMontage(AnimInstance, Section.SoundBaseMouth)

--     -- FacialSaveData.EyeInstance = USequenceMontageLibrary.CreateAndPlayMontage(Section.NpcEye1, AnimInstance, false, false, "Default", 1)
--     -- FacialSaveData.MouthInstance = USequenceMontageLibrary.CreateAndPlayMontage(Section.NpcMouthLoop, AnimInstance, false, false, "Default", 1)

--     -- if IsValid(Section.SoundBaseMouth) then
--     --     if not self.MouthBaseIndexSet[Section.SoundBaseMouth] then
--     --         self.MouthBaseIndexSet[Section.SoundBaseMouth] = 
--     --             USequenceMontageLibrary.CreateAndPlayMontage(Section.SoundBaseMouth, AnimInstance, false, false, "Default", 1)
--     --     end
--     --     FacialSaveData.SoundBaseInstance = self.MouthBaseIndexSet[Section.SoundBaseMouth]
--     --     local Count = self.MouthBaseCountSet[Section.SoundBaseMouth] or 0
--     --     Count = Count + 1
--     --     self.MouthBaseCountSet[Section.SoundBaseMouth] = Count
--     -- end
--     return FacialSaveData
-- end

return M