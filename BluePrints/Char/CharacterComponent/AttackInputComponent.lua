local SkillUtils = require "Utils.SkillUtils"

local Component = {}

local CanCheckShootTag = {
    Idle = 1,
    Crouch = 1,
    Falling = 1
}
-- function Component:HandleInputCacheInTick()
--     if self:CheckForbidInput() then
--         self.MoveInput = FVector(0,0,0)
--         return
--     end
--     local CurrentInputCache = self.InputCache:GetInputCache()
--     local OtherCurrentInputCache = self.InputCache:GetInputCache(2)
--     if CurrentInputCache ~= "" or OtherCurrentInputCache ~= "" then
--         if CurrentInputCache == "Jump" and OtherCurrentInputCache == "Slide" then
--             self:StartBulletJump()
--         elseif CurrentInputCache == "Jump" then 
--             self:StartJump()
--         elseif CurrentInputCache == 'Avoid' then 
--             self:StartDodge()
--         elseif OtherCurrentInputCache == "Slide" then
--             self:StartSlide()
--         elseif CurrentInputCache == "Attack" then
--             self:InputCacheUseSkill(self:GetCanUseAttackSkill(), "Attack")
--         elseif CurrentInputCache == "Skill1" then
--             self:InputCacheUseSkill(self:GetSkillByType(UE.ESkillType.Skill1), "Skill1")
--         elseif CurrentInputCache == "Skill2" then
--             self:InputCacheUseSkill(self:GetSkillByType(UE.ESkillType.Skill2), "Skill2")
--         elseif CurrentInputCache == "Skill1Hold" then
--             self:InputCacheUseHoldSkill(self:GetSkillByType(UE.ESkillType.Skill1), "Skill1")
--         elseif CurrentInputCache == "Skill2Hold" then
--             self:InputCacheUseHoldSkill(self:GetSkillByType(UE.ESkillType.Skill2), "Skill2")
--         elseif CurrentInputCache == "AttackHold" then
--             self:InputCacheUseHoldAttackSkill()
--         end
--     end
--     local CharacterTagChanged = self.LastCharacterTag ~= self:GetCharacterTag()
--     self.LastCharacterTag = self:GetCharacterTag()
--     if self:IsSkillFinished() and not (CharacterTagChanged and CanCheckShootTag[self:GetCharacterTag()] )then 
--         return 
--     end
--     self:CheckShootingCondition()

--     -- if self:CheckCanSkillTypeCancel('Shooting') and self:CheckShouldShootAgain(CurrentInputCache) then
--     --     self:StartFire('Fire')
--     -- elseif self:CheckCanSkillTypeCancel('Shooting') and self:CheckShouldHeavyShootAgain(CurrentInputCache) then
--     --     self:StartFire("HeavyShooting")
--     -- elseif self:CheckCanSkillTypeCancel('Reload') and  self:CheckShouldCancelByReload(CurrentInputCache) then 
--     --     self:TryFireOverLoad()
--     -- end

-- end

function Component:CheckHasHoldingShooting()
    local HeavyShootingSkill = self:GetSkillByType(UE.ESkillType.HeavyShooting)
    return self.bHoldingShooting and (self.CurrentSkillId ~= HeavyShootingSkill)
end

function Component:CheckHasHoldingShootingSkill()
    local HeavyShootingSkill = self:GetSkillByType(UE.ESkillType.HeavyShooting)
    -- print(_G.LogTag, "CheckHasHoldingShootingSkill", self.bPressedFire, self:GetSkillByType(UE.ESkillType.HeavyShooting))
    return (HeavyShootingSkill>0) and self.bPressedFire
end

-- function Component:CheckShootingCondition()
--     local CurrentInputCache = self.InputCache:GetInputCache()
   
--     if self:CheckReloadCondition(CurrentInputCache) then 
--         self:TryFireOverLoad()
--     elseif self:CheckCanSkillTypeCancel('Shooting') then 
--         if not self:CheckCanShoot() then 
--             return 
--         end
--         local CanShootAgain = self:CheckShouldShootAgain(CurrentInputCache) 
--         local CanHeavyShootAgain = self:CheckShouldHeavyShootAgain(CurrentInputCache)
--         if CanHeavyShootAgain then
--             self:StartFire("HeavyShooting")        
--         elseif CanShootAgain then
--             self:StartFire('Fire')
--         end
--     end 
-- end
-- function Component:CheckReloadCondition(CurrentInputCache)
--     local CanReloadAgain = self:CheckShouldCancelByReload(CurrentInputCache)
--     return self:CheckCanSkillTypeCancel('Reload') and CanReloadAgain
-- end

-- function Component:CheckShouldShootAgain(CurrentInputCache)
--     local CanShoot = self:CheckCanShoot() and (CurrentInputCache == "Fire" or self.bPressedFire == true)
--     local NotInShoot = self.CurrentSkillId ~= self:GetSkillByType(UE.ESkillType.Shooting)
--     local NotInSlideAndAvoid = not self:CharacterInTag("Slide") and not self:CharacterInTag("Avoid")
--     if CanShoot and NotInShoot and not self.HoldShootingTimer and not self.bHoldingShooting and  NotInSlideAndAvoid then 
--         return true
--     end

--     return false
-- end

-- function Component:CheckShouldHeavyShootAgain(CurrentInputCache)
--     local CanShoot = self:CheckCanShoot() and (CurrentInputCache == "HoldFire" or self.bPressedFire == true)
--     local NotInShoot = self.CurrentSkillId ~= self:GetSkillByType(UE.ESkillType.HeavyShooting)
--     local NotInSlideAndAvoid = not self:CharacterInTag("Slide") and not self:CharacterInTag("Avoid")
--     if CanShoot and NotInShoot and (self.HoldShootingTimer or self.bHoldingShooting)  and  NotInSlideAndAvoid then 
--         return true
--     end

--     return false
-- end

-- function Component:CheckShouldCancelByReload(CurrentInputCache)
--     local ShootOverload = (self:CharacterHasAnyTag("OverHeat") or self:CharacterHasAnyTag("NoBullet"))
--     local CurrentSkillId = self.CurrentSkillId 
--     local NotInReload = CurrentSkillId ~= self:GetSkillByType(UE.ESkillType.ShootingOverheat) and CurrentSkillId ~= self:GetSkillByType(UE.ESkillType.Reload)
--     local UsingRangedWeapon = self.UsingWeapon and self.UsingWeapon == self.RangedWeapon
--     local HasBullet = self.RangedWeapon and self.RangedWeapon:GetAttr("BulletNum") > 0
--     local NotInSlideAndAvoid = not self:CharacterInTag("Slide") and not self:CharacterInTag("Avoid")
--     local WillShoot = (CurrentInputCache == "Fire" or self.bPressedFire == true)
--     if ShootOverload and NotInReload and UsingRangedWeapon and HasBullet and NotInSlideAndAvoid and WillShoot then 
--         return true
--     end

--     return false
-- end

function Component:PressSkill3()
    if self:CheckSkillOccupiedByProp(ESkillName.Skill3) and self.PropEffectComponent.CurrentPropEffect then
        self.PropEffectComponent.CurrentPropEffect:OnSkill3Pressed()
        return
    end
    -- 检查是否解锁援护技能
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local UIUnlockRule = DataMgr.UIUnlockRule
        local UIUnlockRuleId = UIUnlockRule.PetSkill.UIUnlockRuleId
        local bUnlocked = Avatar:CheckUIUnlocked(UIUnlockRuleId)
        if not bUnlocked then
            UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, UIUnlockRule.PetSkill.UIUnlockDesc)
            return
        end
    end
    -- 检查是否禁用技能
    if self:CheckSkillIsBan(ESkillName.Skill3) then
        local _ = not self.CurrentMasterBan and UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText("UI_SKILL_FORBIDDEN"))
        return
    end
    if self:CheckForbidInput() or self:CheckSkillInActive(ESkillName.Skill3) then
        return
    end

    if self.BuffManager and self.BuffManager:CheckDisableSkillBuff(ESkillType.Skill3) then
        UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText("UI_SKILL_FORBIDDEN"))
    end

    self:SupportSkill()

    if (self.NeedSkill3Event) then
        EventManager:FireEvent(EventID.OnSkill3Pressed)
    end
end

function Component:CheckChangeRoleInMainCityNotInCdTime()
    local NowTime = UE4.UGameplayStatics.GetTimeSeconds(self)
    if (self.SupportUseTimeStamp == nil) then
        self.SupportUseTimeStamp = NowTime
        return true
    end
    local IsCanUse = NowTime - self.SupportUseTimeStamp >= 1
    if (IsCanUse) then
        self.SupportUseTimeStamp = NowTime 
    end
    return IsCanUse
end

function Component:SupportSkill()
    local SupportSKill = self:GetSkillByType(UE.ESkillType.Support)
    if SupportSKill == nil then
        return false
    end
    Battle(self):TriggerBattleEvent(BattleEventName.BeforeSupportSkill, self)
    local Success = self:UseSkill(SupportSKill, 0)
    if Success then
        self:RemoveInputCache('Support')
        local BattlePet = self:GetBattlePet()
        Battle(self):TriggerBattleEvent(BattleEventName.AfterSupportSkill, self)
        EventManager:FireEvent(EventID.OnTheaterPerform, BattlePet.PetId)
    end
end

function Component:Reload()
    if (self.NeedChargeBulletEvent) then
        EventManager:FireEvent(EventID.OnChargeBulletPressed)
    end
    local ReloadSkillId = self:GetSkillByType(UE.ESkillType.Reload)
    if ReloadSkillId == nil then
        return false
    end
    if (not self:CheckCanSkillCancel(ReloadSkillId) and self:CheckForbidInput()) then
        return
    end
    if self:CheckSkillIsBan(ESkillName.Fire) then
        local _ = not self.CurrentMasterBan and UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText("UI_RANGED_FORBIDDEN"))
        return
    end
    if not self:CheckCanShoot(true) or self:CheckSkillInActive(ESkillName.Fire) then
        
        return
    end

    local ReloadSkill = self:GetSkill(ReloadSkillId)
    if not ReloadSkill then
        return
    end

    local FireSkillId = self:GetSkillByType(UE.ESkillType.Shooting)
    local FireSkill = self:GetSkill(FireSkillId)
    if FireSkill and FireSkill.Weapon ~= ReloadSkill.Weapon then
        return
    end
    local IsInShoot = self.CurrentSkillId == FireSkillId
    local IsCrouchng = self.PlayerAnimInstance and not self.PlayerAnimInstance.IsCrouching
    if not IsInShoot and IsCrouchng then 
        self.CanReloadWithoutShoot = true 
    end
    local Success = self:UseSkill(ReloadSkillId, 0)
    self.CanReloadWithoutShoot = false
    if Success then
        self:RemoveInputCache('Reload')
    end
end

--function Component:ChangeReloadWithoutShoot()
--    if not self.CanReloadWithoutShoot then 
--        return 
--    end
--    self.CanReloadWithoutShoot = nil
--    self:SyncReloadWithoutShoot()
--end

-- function Component:GetInputCacheGroupId(CacheName)
--     local cacheInfo = DataMgr.InputCache[CacheName]
--     local group_id = 1
--     if cacheInfo then
--         group_id = cacheInfo.GroupId
--     end
--     return group_id
-- end

-- function Component:RemoveInputCache(CacheName)
--     local cacheInfo = DataMgr.InputCache[CacheName]
--     local group_id = 1
--     if cacheInfo then
--         group_id = cacheInfo.GroupId
--     end
--     local CurrentInputCache = self.InputCache:GetInputCache(group_id)
--     if CurrentInputCache == CacheName then
--         self:ClearInputCache(group_id)
--     end
-- end

-- function Component:RemoveClearInputCache()
--     local cacheInfoTable = DataMgr.InputCache
--     for key,value in pairs(cacheInfoTable) do
--         local cacheInfo = DataMgr.InputCache[key]
--         local group_id = 1
--         if cacheInfo then
--             group_id = cacheInfo.GroupId
--         end
--         local CurrentInputCache = self.InputCache:GetInputCache(group_id)
--         if CurrentInputCache == key then
--             self:ClearInputCache(group_id)
--         end
--     end
-- end

-- function Component:ContainInputCache(CacheName)
--     local cacheInfo = DataMgr.InputCache[CacheName]
--     local group_id = 1
--     if cacheInfo then
--         group_id = cacheInfo.GroupId
--     end
--     local CurrentInputCache = self.InputCache:GetInputCache(group_id)
--     return  CurrentInputCache == CacheName
-- end

function Component:IsSkillDown()
    return self.bPressedAttack or self.bPressedFire or self.bPressedSkill1 or self.bPressedSkill2
end

function Component:InputCacheUseHoldAttackSkill()
    local HoldAttackSkill = self:GetSkillByType(UE.ESkillType.HeavyAttack)
    if HoldAttackSkill == nil then
        self:RemoveInputCache("AttackHold")
        return
    end
    local Success = self:UseSkill(HoldAttackSkill, 0)
    if Success then
        self:RemoveInputCache("AttackHold")
    end
end

-- function Component:CheckCanUseFallAttack()
--     -- --如果不在空中
--     if not self:CharacterInTag("Falling") and not self.IsInAir then
--         return false
--     end
--     -- 如果在滑铲
--     if self:CharacterInTag("Slide") and not self.SlideInAir then
--         return false
--     end
--     if self:GetMovementComponent() and self:GetMovementComponent().bCheatFlying then 
--         return false
--     end

--     -- 子弹跳的时候
--     if self.PlayerAnimInstance.CurrentJumpState == Const.BulletJump then
--     -- if self.AutoSyncProp.IsBulletJumping then
--         PrintTable({"子弹跳必下落攻击"})
--         return true
--     end

--     local StartPos = self:K2_GetActorLocation()
--     local HalfHeight = self.CapsuleComponent:GetUnscaledCapsuleHalfHeight()
--     StartPos = FVector(StartPos.X, StartPos.Y, StartPos.Z - HalfHeight)
    
--     local TraceLength = 100
--     local EndPos = FVector(StartPos.X, StartPos.Y, StartPos.Z - TraceLength)
--     local HitResult = FHitResult()
--     local bHit = UE4.UKismetSystemLibrary.SphereTraceSingle(self, StartPos, EndPos, self.CapsuleComponent:GetUnscaledCapsuleRadius(), ETraceTypeQuery.TraceScene, false, TArray(AActor), 0, HitResult, true)
    
--     return not bHit
-- end

function Component:PressSkill1()
    local NormalSKill = self:GetSkillByType(UE.ESkillType.Skill1)
    if not NormalSKill then
        self:RemoveInputCache("Skill1")
        return
    end
    if self:CheckSkillIsBan(ESkillName.Skill1) then
        local _ = not self.CurrentMasterBan and UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText("UI_SKILL_FORBIDDEN"))
        self:RemoveInputCache("Skill1")
        return
    end

    if self.BuffManager and self.BuffManager:CheckDisableSkillBuff(ESkillType.Skill1) then
        UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText("UI_SKILL_FORBIDDEN"))
    end

    if (not self:CheckCanSkillCancel(NormalSKill) and self:CheckForbidInput()) or self:CheckSkillInActive(ESkillName.Skill1) then
        
        self:RemoveInputCache("Skill1")
        return
    end

    self:PressSkill(NormalSKill, "Skill1")
    if (self.NeedSkill1Event) then
        EventManager:FireEvent(EventID.OnSkill1Pressed)
    end
end

function Component:PressSkill2()
    local UltraSKill = self:GetSkillByType(UE.ESkillType.Skill2)
    if not UltraSKill then
        self:RemoveInputCache("Skill2")
        return
    end

    if self:CheckSkillIsBan(ESkillName.Skill2) and not self.CurrentMasterBan then
        local _ = not self.CurrentMasterBan and UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText("UI_SKILL_FORBIDDEN"))
        self:RemoveInputCache("Skill2")
        return
    end

    if self.BuffManager and self.BuffManager:CheckDisableSkillBuff(ESkillType.Skill2) then
        UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText("UI_SKILL_FORBIDDEN"))
    end

    if (not self:CheckCanSkillCancel(UltraSKill) and self:CheckForbidInput()) or self:CheckSkillInActive(ESkillName.Skill2) then
        
        self:RemoveInputCache("Skill2")
        return
    end

    self:PressSkill(UltraSKill, "Skill2")
    if (self.NeedSkill2Event) then
        EventManager:FireEvent(EventID.OnSkill2Pressed)
    end
end

function Component:InputCacheUseHoldSkill(SkillId, SkillName)
    if not SkillId then
        self:RemoveInputCache(SkillName.."Hold")
        return
    end
    local Skill = self:GetSkill(SkillId)
    if not Skill or Skill.LongPressSkill == 0 then
        self:RemoveInputCache(SkillName.."Hold")
        return
    end
    local Success = self:UseSkill(Skill.LongPressSkill, 0)
    if Success then
        self:RemoveInputCache(SkillName.."Hold")
    end
end

function Component:ReleaseSkill1()
    local NormalSKill = self:GetSkillByType(UE.ESkillType.Skill1)
    if not NormalSKill then
        self:ResetAttackProperty("Skill1")
        return
    end

    if (not self:CheckCanSkillCancel(NormalSKill) and self:CheckForbidInput()) or self:CheckSkillInActive(ESkillName.Skill1) then
        self:ResetAttackProperty("Skill1")
        return
    end

    local Skill = self:GetSkill(NormalSKill)
    self:ReleaseSkill(NormalSKill, "Skill1")
end

function Component:ReleaseSkill2()
    local UltraSKill = self:GetSkillByType(UE.ESkillType.Skill2)
    if not UltraSKill then
        self:ResetAttackProperty("Skill2")
        return
    end
    if (not self:CheckCanSkillCancel(UltraSKill) and self:CheckForbidInput()) or self:CheckSkillInActive(ESkillName.Skill2) then
        self:ResetAttackProperty("Skill2")
        return
    end
    
    local Skill = self:GetSkill(UltraSKill)
    self:ReleaseSkill(UltraSKill, "Skill2")
end

function Component:InputCacheUseSkill(SkillId, SkillName)
    if not SkillId or (not self:CheckCanSkillCancel(SkillId) and self:CheckForbidInput()) or self:CheckSkillInActive(ESkillName[SkillName]) then
        self:RemoveInputCache(SkillName)
        return
    end
    local Success = self:UseSkill(SkillId, 0)
    if Success then
        self:RemoveInputCache(SkillName)
    end
end

function Component:UsePenalizeSkill(Eid)
    self.CondemnMonsterEid = Eid
    local Success = self:UseSkill(self:GetSkillByType(UE.ESkillType.Condemn), 0)
    return Success
end

local InputInfoTemplate = {   
    ReMappingActionName = "",
    OriginKeyState = EInputEvent.IE_Released,

    Init = function(self, ReMappingActionName, OriginKeyState, MappedKeyState)
        self.ReMappingActionName = ReMappingActionName
        self.OriginKeyState = OriginKeyState or EInputEvent.IE_Released
    end
}

-- function Component:CombindTwoKeyToOneCommand(OriginActionName, ActionCombindTo)
--     if not self.InputReMapping then 
--         self.InputReMapping = {}
--     end
--     local InputInfo = New(InputInfoTemplate)
--     InputInfo:Init(ActionCombindTo)
--     self.InputReMapping[OriginActionName] = InputInfo
--     if not self.MappedActionName then
--         self.MappedActionName = {}
--     end
--     local InputInfo = New(InputInfoTemplate)
--     InputInfo:Init(OriginActionName)
--     self.MappedActionName[ActionCombindTo] = InputInfo
-- end

-- function Component:SeparateTwoKeyToOneCommand(OriginActionName, ActionCombindTo)
--     if not self.InputReMapping then 
--         return
--     end
--     self.InputReMapping[OriginActionName] = nil
--     if not self.MappedActionName then
--         return
--     end
--     self.MappedActionName[ActionCombindTo] = nil
-- end

function Component:InitReplaceGamepadSet(KeySet)
    self.BattleMapping:Clear()
    self.SystemMapping:Clear()
    self.BattleInputMappingKey:Clear()
    self.SystemInputMappingKey:Clear()
    self.StopListenWhenPressUseSkill:Clear()
    self.StopListenWhenReleaseUseSkill:Clear()
    self.InputSetting = UE4.UInputSettings.GetInputSettings()
    local ActionMappings = self.InputSetting.ActionMappings:ToTable()
    local GamepadSet = DataMgr.GamepadMap
    for _, UserData in ipairs(ActionMappings) do
        if UserData.ActionName == "GamepadUseSkill" then
            self.GamepadUseSkillKey = UserData.Key
        end
        if UserData.ActionName == "GamepadOpenSystem" then
            self.GamepadOpenSystemKey = UserData.Key
        end
        if string.find(UserData.Key.KeyName,'Gamepad') then
            DebugPrint("@zyh222", UserData.ActionName, UserData.Key.KeyName)
        end
    end
    for ActionName, ActionData in pairs(GamepadSet) do
        if ActionData.BattleInput and ActionData.BattleInput[KeySet] then
            self.BattleMapping:Add(ActionData.BattleInput[KeySet], ActionName)
            for _, UserData in ipairs(ActionMappings) do
                local Res = string.find(UserData.Key.KeyName,'Gamepad')
                if (UserData.ActionName == ActionData.BattleInput[KeySet] or UserData.ActionName == ActionData.ActionName) and Res then
                    DebugPrint("@zyh ReplaceUseSkill", UserData.ActionName, UserData.Key.KeyName)
                    --self.BattleInputMappingKey[ActionData.BattleInput[1]] = UserData
                    self.BattleInputMappingKey:Add(ActionData.BattleInput[KeySet], UserData)
                end
            end
        end
    end
    for ActionName, ActionData in pairs(GamepadSet) do
        if ActionData.SystemInput and ActionData.SystemInput[KeySet] then
            self.SystemMapping:Add(ActionData.SystemInput[KeySet], ActionName)
            --table.insert(self.SystemMapping, {ActionData.SystemInput[1], ActionName})
            for _, UserData in ipairs(ActionMappings) do
                local Res = string.find(UserData.Key.KeyName,'Gamepad')
                if UserData.ActionName == ActionData.SystemInput[KeySet] and Res then
                    --self.SystemInputMappingKey[ActionData.SystemInput[1]] = UserData
                    DebugPrint("@zyh ReplaceOpenSystem", UserData.ActionName, UserData.Key.KeyName)
                    self.SystemInputMappingKey:Add(ActionData.SystemInput[KeySet], UserData)
                end
            end
        end
    end
end


function Component:InitGamepadSet(KeySet)
    local NameMapping = {}
    local CurrentKeyMapping = {}
    self.ActionToGamepadIcon = {}
    self.InputSetting = UE4.UInputSettings.GetInputSettings()
    if not self.InputSetting then
        DebugPrint("@@zyh 获取InputSetting失败")
        return
    end

    local ActionMappings = self.InputSetting.ActionMappings:ToTable()
    local GamepadSet = DataMgr.GamepadMap

    -- 根据表格，把所有手柄键位初始化一次
    for _, UserData in ipairs(ActionMappings) do
        local ActionName = UserData.ActionName
        if GamepadSet[ActionName] and GamepadSet[ActionName].GamepadKey and GamepadSet[ActionName].GamepadKey[KeySet] then
            local KeyName = "Gamepad_" .. GamepadSet[ActionName].GamepadKey[KeySet]
            if string.find(UserData.Key.KeyName,'Gamepad') and UserData.Key.KeyName ~= KeyName then
                self.InputSetting:RemoveActionMapping(UserData) -- 删掉不匹配的
            end
            local NewKey = UE4.EKeys[KeyName]
            UserData.Key = NewKey
            self.InputSetting:AddActionMapping(UserData) -- 加上匹配的
        elseif GamepadSet[ActionName] and (not GamepadSet[ActionName].GamepadKey or not GamepadSet[ActionName].GamepadKey[KeySet])
                and string.find(UserData.Key.KeyName,'Gamepad') then
            self.InputSetting:RemoveActionMapping(UserData) -- 如果是个组合按键，删掉残留的
        end
    end

    ActionMappings = self.InputSetting.ActionMappings:ToTable()
    for ActionName, ActionData in pairs(GamepadSet) do
        if ActionData.GamepadKey and ActionData.GamepadKey[KeySet] then
            NameMapping[ActionName] = "Gamepad_" .. ActionData.GamepadKey[KeySet]
            for _, UserData in ipairs(ActionMappings) do
                local Res = string.find(UserData.Key.KeyName,'Gamepad')
                if UserData.ActionName == ActionName and Res then
                    if not CurrentKeyMapping[ActionName] then
                        CurrentKeyMapping[ActionName] = {UserData}
                    else
                        table.insert(CurrentKeyMapping[ActionName], UserData)
                    end

                end
            end
        end
    end

    for ActionName, KeyName in pairs(NameMapping) do
        --local OneKeyMapping = FInputActionKeyMapping(ActionName, false, false, false, false, FKey("Gamepad_"..KeyName))
        if CurrentKeyMapping[ActionName] then
            for _, UserData in ipairs(CurrentKeyMapping[ActionName]) do
                DebugPrint("@zyh 被删掉的映射", UserData.ActionName, UserData.Key.KeyName)
                self.InputSetting:RemoveActionMapping(UserData)
            end
            --CurrentKeyMapping[ActionName][1].Key.KeyName = KeyName
            --DebugPrint("@zyh 添加的映射关系", ActionName, KeyName)
            --self.InputSetting:AddActionMapping(CurrentKeyMapping[ActionName][1])
        end
        
    end
    for ActionName, ActionData in pairs(GamepadSet) do
        if ActionData.GamepadKey and ActionData.GamepadKey[KeySet] then
            local KeyName = "Gamepad_" .. ActionData.GamepadKey[KeySet]
            DebugPrint("@zyh 添加的映射关系", ActionName, KeyName)
            local FInputActionKeyMapping = UE4.FInputActionKeyMapping()
            FInputActionKeyMapping.ActionName = ActionName
            FInputActionKeyMapping.Key = UE4.EKeys[KeyName]
            self.InputSetting:AddActionMapping(FInputActionKeyMapping)
        end
    end
    self.InputSetting:SaveKeyMappings()
    ActionMappings = self.InputSetting.ActionMappings:ToTable()
    for _, UserData in ipairs(ActionMappings) do
        if string.find(UserData.Key.KeyName,'Gamepad') then
            DebugPrint("@zyh111", UserData.ActionName, UserData.Key.KeyName)
        end
    end
end

--function Component:PressGamepadUseSkill()
--    PrintTable(self.BattleMapping, 10, "@zyh BattleMapping")
--    for _, v in ipairs(self.BattleMapping) do
--        self.InputSetting:RemoveActionMapping(self.BattleInputMappingKey[v[1]])
--        self.BattleInputMappingKey[v[1]].ActionName = v[2]
--        DebugPrint(self.BattleInputMappingKey[v[1]].ActionName,self.BattleInputMappingKey[v[1]].Key.KeyName, "@zyh123321")
--        self.InputSetting:AddActionMapping(self.BattleInputMappingKey[v[1]])
--    end
--end
--
--function Component:ReleaseGamepadUseSkill()
--    DebugPrint("@zyh ReleaseGamepadUseSkill")
--    for _, v in ipairs(self.BattleMapping) do
--        self.InputSetting:RemoveActionMapping(self.BattleInputMappingKey[v[1]])
--        self.BattleInputMappingKey[v[1]].ActionName = v[1]
--        self.InputSetting:AddActionMapping(self.BattleInputMappingKey[v[1]])
--    end
--end
--
--function Component:PressGamepadOpenSystem()
--    PrintTable(self.SystemMapping, 10, "@zyh SystemMapping")
--    for _, v in ipairs(self.SystemMapping) do
--        self.InputSetting:RemoveActionMapping(self.SystemInputMappingKey[v[1]])
--        self.SystemInputMappingKey[v[1]].ActionName = v[2]
--        DebugPrint(self.SystemInputMappingKey[v[1]].ActionName,self.SystemInputMappingKey[v[1]].Key.KeyName, "@zyh123321")
--        self.InputSetting:AddActionMapping(self.SystemInputMappingKey[v[1]])
--    end
--end
--
--function Component:ReleaseGamepadOpenSystem()
--    DebugPrint("@zyh ReleaseGamepadOpenSystem")
--    for _, v in ipairs(self.SystemMapping) do
--        self.InputSetting:RemoveActionMapping(self.SystemInputMappingKey[v[1]])
--        self.SystemInputMappingKey[v[1]].ActionName = v[1]
--        self.InputSetting:AddActionMapping(self.SystemInputMappingKey[v[1]])
--    end
--end


--function Component:ResetAttackProperty(SkillName)
--    self:RemoveTimer("Hold"..SkillName)
--    self["bPressed"..SkillName] = false
--    self["bHolding"..SkillName] = false
--    if(SkillName == "Jump") then
--        self:StopJump()
--    elseif(SkillName == "Slide") then
--        self:StopSlide()
--    end
--end

--function Component:ReleaseSkill(SkillId, SkillName)
--    -- print(_G.LogTag, "ZJY11ReleaseSkill", SkillId, SkillName)
--    if self:CheckSkillIsBan(ESkillName[SkillName]) then
--        -- local _ = not self.CurrentMasterBan and UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText("UI_RANGED_FORBIDDEN"))
--        return
--    end
--    if SkillId then
--        local Skill = self:GetSkill(SkillId)
--        if self.CurrentContinuousSkillId ~= 0 then
--            self:StopSkill()
--        else
--            if SkillName == "Attack" or (Skill.LongPressSkill ~= 0 and Skill.LongPressSkill ~= SkillId) then
--                if not self["bHolding"..SkillName] and self["bPressed"..SkillName] then
--                    self:SetInputCache(SkillName)
--                    local Success = self:UseSkill(SkillId, 0)
--                    if Success then
--                        self:RemoveInputCache(SkillName)
--                    end
--                end
--            end
--        end
--    end
--    self:ResetAttackProperty(SkillName)
--end

--function Component:PressAttack()
--    self.bPressedAttack = true
--    if self:CheckSkillOccupiedByProp(ESkillName.HeavyAttack) then
--        self.PropHoldAttackTimer = self:AddTimer(0.2, function()
--            self.PropEffectComponent.CurrentPropEffect:OnHoldAttack()
--            self.PropHoldAttackTimer = nil
--        end, false, 0, "PropHoldAttack")
--    end
--    if self:CheckSkillOccupiedByProp(ESkillName.Attack) then
--        self.PropEffectComponent.CurrentPropEffect:OnAttackPressed()
--        return
--    end
--    local HoldAttackSkill = self:GetSkillByType(UE.ESkillType.HeavyAttack)
--    if not HoldAttackSkill then
--        return
--    end
--    if self:CheckSkillIsBan(ESkillName.Attack) then
--        local _ = not self.CurrentMasterBan and UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText("UI_MELEE_FORBIDDEN"))
--        print(_G.LogTag, "PressAttack   ", _)
--        return
--    end
--    if (not self:CheckCanSkillCancel(HoldAttackSkill) and self:CheckForbidInput()) or self:CheckSkillInActive(ESkillName.Attack) then
--        return
--    end
--    if not self.PropHoldAttackTimer then
--        self:AddTimer(0.2, self.HoldSkill, false, 0, "HoldAttack", nil, HoldAttackSkill, "Attack")
--    end
--end

--function Component:GetCanUseAttackSkill()
--    local AttackSkillId
--    if self:CharacterInTag("Slide") or self:CharacterInTag("Crouch") then
--        AttackSkillId = self:GetSkillByType(UE.ESkillType.SlideAttack)
--        if (self.NeedSlideAttackEvent) then
--            EventManager:FireEvent(EventID.OnSlideAttackPressed)
--        end
--    elseif (self:IsDisableSkillType(UE.ESkillType.FallAttack)) then
--        AttackSkillId = self:GetSkillByType(UE.ESkillType.Attack)
--        if (self.NeedAttackEvent) then
--            EventManager:FireEvent(EventID.OnAttackPressed)
--        end
--    elseif self:CheckCanUseFallAttack() then
--        AttackSkillId = self:GetSkillByType(UE.ESkillType.FallAttack)
--        if (self.NeedFallAttackEvent) then
--            EventManager:FireEvent(EventID.OnFallAttackPressed)
--        end
--    else
--        AttackSkillId = self:GetSkillByType(UE.ESkillType.Attack)
--        if (self.NeedAttackEvent) then
--            EventManager:FireEvent(EventID.OnAttackPressed)
--        end
--    end
--    return AttackSkillId
--end

--function Component:ReleaseAttack()
--    if self:CheckSkillOccupiedByProp(ESkillName.HeavyAttack) then
--        if self.PropHoldAttackTimer then
--            self:RemoveTimer("PropHoldAttack")
--            self.PropHoldAttackTimer = nil
--        end
--    end
--    if self:CheckSkillOccupiedByProp(ESkillName.Attack) then
--        self.PropEffectComponent.CurrentPropEffect:OnAttackReleased()
--        return
--    end
--    local AttackSkill = self:GetCanUseAttackSkill()
--    if not AttackSkill then
--        self:ResetAttackProperty("Attack")
--        return 
--    end
--    if self:CheckSkillIsBan(ESkillName.Attack) then
--        local _ = not self.CurrentMasterBan and UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText("UI_MELEE_FORBIDDEN"))
--        self:ResetAttackProperty("Attack")
--        return
--    end
--    if (not self:CheckCanSkillCancel(AttackSkill) and self:CheckForbidInput()) or self:CheckSkillInActive(ESkillName.Attack) then
--        self:ResetAttackProperty("Attack")
--        return
--    end
--    self:ReleaseSkill(AttackSkill, "Attack")
--end

--function Component:PressSkill(SkillId, SkillName)
--    local Skill = self:GetSkill(SkillId)
--    self["bPressed"..SkillName] = true
--    if Skill.LongPressSkill == 0 then
--        local Success = self:UseSkill(SkillId, 0)
--        if Success then
--            self:RemoveInputCache(SkillName)
--        end
--    else
--        self:RemoveInputCache(SkillName)
--        self:AddTimer(0.2, self.HoldSkill, false, 0, "Hold"..SkillName, nil, Skill.LongPressSkill, SkillName)
--    end
--end
--
--function Component:HoldSkill(HoldSkillId, SkillName)
--    if self:CharacterInTag("Slide") or self:CharacterInTag("Crouch") then
--        return
--    end
--    if (SkillName == "Attack" and self.NeedHeavyAttackEvent) then
--        EventManager:FireEvent(EventID.OnHeavyAttackPressed)
--    end
--    self["bHolding"..SkillName] = true
--    self:SetInputCache(SkillName.."Hold")
--    local Success = self:UseSkill(HoldSkillId, HoldSkillId)
--    if Success then
--        self:RemoveInputCache(SkillName.."Hold")
--    end
--end

return Component
