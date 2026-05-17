---@type BP_CharacterBase_C
local Component = {}

-- BindWeaponTags = {
--     Skill = 1,
--     Shooting = 1
-- }

-- function Component:ReceiveTick(DeltaSeconds)
--     if not self.InitSuccess then
--         return
--     end
--     if not self:IsPlayer() and not self:IsPhantom() then
--         return
--     end
--     self:HandleWeaponSocketInTick()
-- end

-- function Component:WeaponOffHandWhenSkill(SkillWeaponUnbind)
--     if SkillWeaponUnbind then
--         self.SkillWeaponUnbind = (self.SkillWeaponUnbind or 0) + 1
--     else
--         self.SkillWeaponUnbind = (self.SkillWeaponUnbind or 0) - 1
--     end
--     if self.SkillWeaponUnbind < 0 then
--         self.SkillWeaponUnbind = 0
--     end
-- end

-- function Component:HandleWeaponSocketInTick()
--     if not self.PlayerAnimInstance then
--         return
--     end
--     if self:CharacterInTag("Skill") or self:CharacterInTag("Shooting")then
--         if self.SkillWeaponUnbind and self.SkillWeaponUnbind > 0 then
--             if self.WeaponPos == Const.Hand then
--                 self.WeaponPos = Const.Shoulder
--                 self:UnBindWeaponFromHand()
--             end
--         elseif self.WeaponPos ~= Const.Hand then
--             self.WeaponPos = Const.Hand
--             self:BindWeaponToHand()
--         end
--     elseif self.PlayerAnimInstance.InBoneHit then
--         self:ResetWeaponHandDelay()
--         if self.WeaponPos ~= Const.Shoulder then
--             self.WeaponPos = Const.Shoulder
--             self:UnBindWeaponFromHand()
--         end
--     elseif self.PlayerAnimInstance.IdleTag ~= "0" and self.PlayerAnimInstance.IdleTag ~= "EmoIdle" then
--         if self.WeaponPos ~= Const.Hand then
--             self.WeaponPos = Const.Hand
--             self:BindWeaponToHand()
--         end
--     elseif self.PlayerAnimInstance.StartShoot then 
--         if self.WeaponPos ~= Const.Hand then
--             self.WeaponPos = Const.Hand
--             self:BindWeaponToHand()
--         end
--     elseif not self.KeepWeaponOnHand and not self:InBindWeaponTag()then
--         if self.WeaponPos ~= Const.Shoulder then
--             self.WeaponPos = Const.Shoulder
--             self:UnBindWeaponFromHand()
--         end
--     else
--         if self.WeaponPos ~= Const.Hand then
--             self.WeaponPos = Const.Hand
--             self:BindWeaponToHand()
--         end
--     end
--     if self.PlayerAnimInstance and self.PlayerAnimInstance.WeaponPos ~= self.WeaponPos then
--         self.PlayerAnimInstance.WeaponPos = self.WeaponPos
--     end
-- end

-- function Component:InBindWeaponTag()
--     return BindWeaponTags[self:GetCharacterTag()]
-- end

-- 客户端
-- function Component:OnRep_Weapon()
--     -- PrintTable({OnRep_Weapon=1})
--     if IsValid(self.LastUsingWeapon) then
--         self.LastUsingWeapon:OnLeave(true)
--         self.WeaponPos = Const.Shoulder
--         -- if self:IsMainPlayer() then
--         --     HeroUSDKSubsystem():UploadWeaponUseCountInfo(self)
--         -- end
--     else
--         self.LastUsingWeapon = nil
--     end
--     if self.UsingWeapon then
--         self.UsingWeapon:OnEnter(self)
--     end
--     if self.UsingWeapon and self.PlayerAnimInstance then
--         self.PlayerAnimInstance.UsingWeaponTags = self.UsingWeapon:GetWeaponTags()
-- 		local LuaWeaponArray = self.PlayerAnimInstance.UsingWeaponTags:ToTable()
-- 		for _, WeaponTag in ipairs(LuaWeaponArray) do
-- 			local WeaponTagContext = DataMgr.WeaponTag[WeaponTag]
-- 			if WeaponTagContext.WeaponTagFloat then
-- 				self.PlayerAnimInstance.WeaponTagFloat = WeaponTagContext.WeaponTagFloat
-- 				self.WeaponTagFloat = WeaponTagContext.WeaponTagFloat
-- 			end
-- 		end
--     elseif self.PlayerAnimInstance then
--         self.PlayerAnimInstance.UsingWeaponTags = TArray("")
--     end
--     self:CheckUsingWeaponHandAdditive()
--     self.LastUsingWeapon = self.UsingWeapon
--     if not self.UsingWeapon then 
--         return 
--     end
--     local ShouldBindAtBegin = not self:IsPlayer() and not self:IsPhantom() and not self.CanChangeWeaponPos
--     if ShouldBindAtBegin then
--         self:BindWeaponToHand()
--     else
--         self:UnBindWeaponFromHand()
--     end
-- end

-- function Component:ClearWeapon()
--     if self.Weapons:Num() == 0 then
--         return
--     end
--     -- if self.Weapons == nil then
--     --     return
--     -- end

--     self:RealChangeUsingWeapon(nil)
--     for i,v in pairs(MiscUtils.Values(self.Weapons)) do
--         v:Destroy()
--     end
--     -- clear all
--     if true then
--         ---@type BP_WeaponBase_C
--         self.MeleeWeapon = nil
--         ---@type BP_WeaponBase_C
--         self.RangedWeapon = nil
--         ---@type BP_WeaponBase_C
--         self.CondemnWeapon = nil
-- 		---@type BP_WeaponBase_C
--         self.UltraWeapon = nil
--         ---@type BP_WeaponBase_C
--         self.UsingWeapon = nil
--         ---@type BP_WeaponBase_C
--         self.LastUsingWeapon = nil

--         self.Weapons:Clear()
--         self.Tag2WeaponId:Clear()
--     end
-- end

-- function Component:ClearWeaponModPassive()
--     if self.Weapons:Num() == 0 then
--         return
--     end

    -- if self.Weapons == nil then
    --     return
    -- end

    -- for _, Weapon in pairs(self.Weapons) do
    --     self:RemovePassiveEffectByWeapon(Weapon)
    -- end
-- end

-- function Component:InitWeaponHideState()
--     if IsValid(self.MeleeWeapon) then
--         if IsValid(self.RangedWeapon) and self.RangedWeapon:IsUnBind() then
--             self.RangedWeapon:SetActorHideTag("Unbind", true)
--         end
--     elseif IsValid(self.RangedWeapon) then
--         if IsValid(self.MeleeWeapon) then
--             self.MeleeWeapon:SetActorHideTag("Unbind", true)
--         end
--     end
-- end

-- function Component:MonsterAddWeapons(WeaponId)
--     if self.Weapons:Num() == 0 then
--         self.Tag2WeaponId:Clear()
--         self.LastWeaponIds = {}
--     end

--     assert(not self:GetWeapon(WeaponId), '已经存在该武器')

--     -- 创建新的武器
--     local Weapon = self:_SpawnWeapon(WeaponId)
--     if Weapon == nil then
--         return
--     end
--     self:RawAddWeapon(Weapon)

--     return Weapon
-- end

-- function Component:AddWeapon(WeaponId, WeaponInfo, index)
--     if self.Weapons:Num() == 0 then
--         self.Tag2WeaponId:Clear()
--         --self.LastWeaponIds = {}
--     end

--     assert(not self:GetWeapon(WeaponId), '已经存在该武器')

--     -- 创建新的武器
--     local Weapon = self:_SpawnWeapon(WeaponId, WeaponInfo)
--     if Weapon == nil then
--         return
--     end
--     local bIsUltra = Weapon:HasTag("Ultra")
--     if bIsUltra then
--         self:AddUltraWeapon(index, Weapon)
--     end
--     self:InitWeapon(Weapon)

--     self:RawAddWeapon(Weapon)
    
--     if Weapon.Data.WeaponTag then
--         for _, WeaponTag in pairs(Weapon.Data.WeaponTag) do
--             if bIsUltra then
--                 self.Tag2WeaponId:Add("Ultra", WeaponId)
--             else
--                 self.Tag2WeaponId:Add(WeaponTag, WeaponId)
--             end
--         end
--     end
--     if not(self.PlayerAnimInstance and self.PlayerAnimInstance.IdleTagName ~= "0" and self.PlayerAnimInstance.IdleTagName ~= "EmoIdle") then
--         return Weapon
--     end

--     self.WeaponPos = Const.Shoulder

--     return Weapon
-- end

-- function Component:GetWeapon(WeaponId)
--     if not self.Weapons then
--         return
--     end
--     return self.Weapons[WeaponId]
-- end

function Component:ClientAddWeapon(Weapon)
    if self.Weapons:Num() == 0 then
    -- if self.Weapons == nil then
    --     self.Weapons = {}
        self.Tag2WeaponId:Clear()
        self.LastWeaponIds = {}
    end

    self:RawAddWeapon(Weapon)

    local WeaponData = DataMgr.BattleWeapon[Weapon.WeaponId]

    if WeaponData then
        local bIsUltra = Weapon:HasTag("Ultra")
        for _, WeaponTag in pairs(WeaponData.WeaponTag) do
            if bIsUltra then
                self.Tag2WeaponId:Add("Ultra", Weapon.WeaponId)
            else
                self.Tag2WeaponId:Add(WeaponTag, Weapon.WeaponId)
            end
        end
    end
    if self.WeaponNum > 0 and self.Weapons:Num() == self.WeaponNum then
        self:InitWeaponHideState()
    end

    return Weapon
end

--function Component:RealChangeUsingWeapon(Weapon)
--    if self.UsingWeapon then
--        self.UsingWeapon:ResetAttr()
--    end
--    self.UsingWeapon = Weapon
--    if self.UsingWeapon then
--        self.UsingWeapon:ApplyAttr()
--    end
--    self.SavedLastUsingWeapon = self.LastUsingWeapon
--
--    self:OnRep_Weapon()
--
--    self:FixWeaponVisibilityOnWeaponChanged()
--    
--    if self.UsingWeapon then
--        local _SocketName = self:SetLeftHandIkSocket() or ""
--        if _SocketName == "None" then 
--            self.LeftHandIkSocketName = ""
--            return 
--        end
--        self.LeftHandIkSocketName = _SocketName
--    end
--
--    if Battle(self) then
--        Battle(self):TriggerBattleEvent(BattleEventName.OnWeaponChanged, self, self.SavedLastUsingWeapon, self.UsingWeapon)
--    end
--end


-- function Component:MonRealChangeUsingWeapon(Weapon)
--     -- if self.UsingWeapon then
--     --     self.UsingWeapon:ResetAttr()
--     -- end
--     if self.UsingWeapon == Weapon then
--         return
--     end
--     self.UsingWeapon = Weapon
--     if self.UsingWeapon then
--         self.UsingWeapon:ApplyAttr()
--     end

--     self:OnRep_Weapon()
-- 	Weapon:ShouldHideWeapon(true)

--     self:FixWeaponVisibilityOnWeaponChanged()

--     if self.UsingWeapon then
--         local _SocketName = self:SetLeftHandIkSocket() or ""
--         if _SocketName == "None" then 
--             self.LeftHandIkSocketName = ""
--             return 
--         end
--         self.LeftHandIkSocketName = _SocketName
--     end
-- end

-- function Component:CheckUsingWeaponHandAdditive()
--     if not self.PlayerAnimInstance then 
--         return 
--     end
--     if not self.UsingWeapon then 
--         self.PlayerAnimInstance.HandSequence = nil 
--         return 
--     end
--     local Data = self.UsingWeapon.Data
--     if not Data then 
--         self.PlayerAnimInstance.HandSequence = nil 
--         return 
--     end

--     if not Data.HandAdditiveSequence then 
--         self.PlayerAnimInstance.HandSequence = nil 
--         return
--     end
--     local HandAdditiveSequence = LoadObject(Data.HandAdditiveSequence)
--     if not HandAdditiveSequence then 
--         self.PlayerAnimInstance.HandSequence = nil 
--         return
--     end
--     self.PlayerAnimInstance.HandSequence = HandAdditiveSequence
-- end

--function Component:SetLeftHandIkSocket()
--   
--    if not self.UsingWeapon.Data then 
--        return
--    end
--    local WeaponInfo = self.UsingWeapon.Data 
--    if not WeaponInfo.WeaponSockets then 
--        return 
--    end
--    local SocketInfo = WeaponInfo.WeaponSockets
--    if not SocketInfo["HandHoldIK"] then 
--        return 
--    end
--    return SocketInfo["HandHoldIK"]["SocketA"]
--    
--end

-- function Component:ChangeUsingWeaponByType(WeaponTag)
--     self.WeaponPos = Const.Shoulder

--     if not WeaponTag then
--         self:RealChangeUsingWeapon(nil)
--         return
--     end

--     assert(self[WeaponTag.."Weapon"], UE4.UKismetSystemLibrary.GetDisplayName(self) .. "没有对应【" .. tostring(WeaponTag) .. "】的武器")
--     if self.UsingWeapon and self.UsingWeapon.WeaponId == self[WeaponTag.."Weapon"].WeaponId then
--         return
--     end

--     local NewWeapon = self[WeaponTag.."Weapon"]

--     if self.UsingWeapon and self.UsingWeapon:HasTag("Melee") then
--         self:ZeroComboCount(UE4.EClearComboReason.ChangeWeapon)
--     end
--     self:RealChangeUsingWeapon(NewWeapon)
-- end

function Component:ChangeUsingWeaponById(WeaponId)
    self.WeaponPos = Const.Shoulder

    if not WeaponId then
        self:RealChangeUsingWeapon(nil)
		self.EMAnimInstance.WeaponTagFloat = 0
		self.WeaponTagFloat = 0
        return
    end

    local NewWeapon = self:GetWeapon(WeaponId)

    assert(NewWeapon, UE4.UKismetSystemLibrary.GetDisplayName(self) .. "没有对应【" .. tostring(WeaponId) .. "】的武器")
    if self.UsingWeapon and self.UsingWeapon.WeaponId == NewWeapon.WeaponId then
        return
    end

    if self.UsingWeapon and self.UsingWeapon:HasTag("Melee") then
        self:ZeroComboCount(UE4.EClearComboReason.ChangeWeapon)
    end
	self:BindWeaponToHand(NewWeapon)
    self:RealChangeUsingWeapon(NewWeapon)
	NewWeapon:ShouldHideWeapon(true)
end

-- -- 服务器
-- function Component:ChangeWeapon(WeaponId, bRecordLastWeapon, bForceBindToHand)
--     if WeaponId == nil or WeaponId == 0 then
--         return
--     end
--     local NewWeapon = self.Weapons[WeaponId]
--     if NewWeapon == nil then
--         return
--     end
--     local TagToChange = nil
--     if NewWeapon:HasTag("Melee") then
--         TagToChange = "Melee"
--     elseif NewWeapon:HasTag("Ranged") then
--         TagToChange = "Ranged"
--     end
--     if not TagToChange then
--         return
--     end

--     local WeaponToChange = self[TagToChange.."Weapon"]
--     if not WeaponToChange then
--         return
--     end

--     if WeaponToChange.WeaponId == WeaponId then
--         return
--     end
--     if bRecordLastWeapon then
--         self.LastWeaponIds[TagToChange] = WeaponToChange.WeaponId
--     end
--     WeaponToChange:OnDismiss()
--     PrintTable({bForceBindToHand=bForceBindToHand,NewWeapon=NewWeapon})
--     PrintTable({HasTag=self.UsingWeapon:HasTag(TagToChange),TagToChange=TagToChange})
--     if bForceBindToHand or self.UsingWeapon:HasTag(TagToChange) then
--         self.WeaponPos = Const.Shoulder
--         self:RealChangeUsingWeapon(NewWeapon)
--     end
--     -- self[TagToChange.."Weapon"] = NewWeapon
--     if TagToChange == "Melee" and self.UsingWeapon:HasTag("Melee") then
--         self:ZeroComboCount()
--     end
-- end

-- function Component:EquipUltraWeapon()
--     if not self.UltraWeapon then
--         return
--     end
--     self.UltraWeapon.bVisibleWhenUnbind = true
--     if self.UltraWeapon:HasTag("Melee") then
--         self.MeleeWeapon:DeactivateSkills()
--     end
--     if self.UltraWeapon:HasTag("Ranged") then
--         self.RangedWeapon:DeactivateSkills()
--     end

--     self:ChangeUsingWeaponByType("Ultra")
--     -- self:ChangeWeapon(self.UltraWeapon.WeaponId, true, true)
-- end

-- function Component:DisburdenUltraWeapon()
--     if not self.UltraWeapon then
--         return
--     end
--     self.UltraWeapon.bVisibleWhenUnbind = false
--     -- 策划说不切了
--     if self.UsingWeapon == self.UltraWeapon then
--         self:ChangeUsingWeaponByType(nil)
--         -- if self.UltraWeapon:HasTag("Melee") then
--         --     self:ChangeUsingWeaponByType("Melee")
--         -- else
--         --     self:ChangeUsingWeaponByType("Ranged")
--         -- end
--     end
--     if self.MeleeWeapon then
--         self.MeleeWeapon:ActivateSkills()
--     end
--     if self.RangedWeapon then
--         self.RangedWeapon:ActivateSkills()
--     end
--     self.UltraWeapon:ShouldHideWeapon()
    
--     -- 走这个接口移除显赫武器，需要清空角色连击数
--     self:ZeroComboCount(UE4.EClearComboReason.DisableUltraWeapon)
-- end


-- function Component:BindWeaponArm(ArmComponent, SocketName)
--     if not self.WeaponArmLogicComponent then
--         return
--     end
--     if not SocketName then 
--         SocketName = Const.DefaultWeaponArmSocket
--     end
--     if not ArmComponent then 
--         ArmComponent = self.WeaponSpringComponent
--     end
--     self.WeaponArmLogicComponent:BindArm(ArmComponent, SocketName)
-- end

-- function Component:FindArmBySocketName(SocketName)
--     if not self.WeaponArmLogicComponent then
--         return
--     end
--     return self.WeaponArmLogicComponent:FindOrAddArmBySocketName(self, SocketName)
-- end

-- function Component:AddWeaponModPassiveEffect(Weapon, Passives)
--     if not Passives then
--         return
--     end
--     for i = 1, #Passives do
--         local PassiveInfo = Passives[i]
--         local PassiveId = PassiveInfo[1]
--         local Level = PassiveInfo[2]
--         self:AddPassiveEffectByWeapon(Weapon, PassiveId, Level)
--     end
-- end

-- function Component:GetMeleeWeaponId(WeaponInfo)
--     local WeaponId = nil
--     if WeaponInfo then
--         if WeaponInfo.WeaponId ~= 0 then
--             WeaponId = WeaponInfo.WeaponId
--         end
--     else
--         if self:IsPlayer() or (self:IsPhantom() and self.Data.WearMeleeWeapon) or self:IsRobot() then
--             WeaponId = self.BattleCharInfo.WeaponId
--         elseif self:IsMonster() then
--             if self.Data.WeaponId and type(self.Data.WeaponId) == "table" then
--                 WeaponId = self.Data.WeaponId[1]
--             else
--                 WeaponId = self.Data.WeaponId
--             end
--         end
--     end

--     return WeaponId
-- end

-- function Component:ServerSetUpMeleeWeapon(WeaponInfo)
--     local WeaponId = self:GetMeleeWeaponId(WeaponInfo)
--     if not WeaponId then
--         return
--     end
--     local Weapon = self:AddWeapon(WeaponId, WeaponInfo)
--     if not Weapon then
--         return
--     end
--     if self:IsPlayer() then
--         self:SyncPlayerState_MeleeWeapon(WeaponId, Weapon:GetAttr("Level"))
--     end
--     if self:IsPhantom() then
--         self:SyncPhamtomState_MeleeWeapon(WeaponId, Weapon:GetAttr("Level"))
--     end
--     Weapon:ShouldHideWeapon(true)
--     if self:IsPlayer() or self:IsPhantom() then
--         Weapon:UnBindWeaponFromHand(true, true)
--     else
--         self:RealChangeUsingWeapon(Weapon)
--     end
--     -- Weapon:ActivateSkills()
-- end

function Component:GetMonsterFirstWeapon()
    local WeaponId = self.Data.WeaponId and self.Data.WeaponId[1]
    if not WeaponId then
        return
    end
    return self:GetWeapon(WeaponId)
end

-- function Component:ServerSetMonsterWeapons()
--     if not self:IsMonster() then
--         return
--     end

--     local WeaponId = self.Data.WeaponId and self.Data.WeaponId[1]
--     if not WeaponId then
--         return
--     end
--     local Weapon = self:MonsterAddWeapons(WeaponId)
--     if not Weapon then
--         return
--     end
-- 	self.WeaponIndex = 1

--     -- Weapon:ShouldHideWeapon(true)
--     self:MonRealChangeUsingWeapon(Weapon)

--     -- CBT1后的多武器逻辑
--     local WeaponList = self.Data.WeaponId
--     if not WeaponList or type(WeaponList) ~= "table" then
--         return
--     end
--     for Index = 2, #WeaponList do
--         local Weapon = self:MonsterAddWeapons(WeaponList[Index])
--         if Weapon then
--             Weapon:ShouldHideWeapon(true)
--             Weapon:UnBindWeaponFromHand(nil, true)
--         end
--     end
-- end

function Component:ServerChangeMonsterWeapon(ChangeReason)
	if not self:IsMonster() then
		return
	end
	local WeaponIndex = self.Data.ChangeWeaponParams[ChangeReason]
	if not WeaponIndex then
		return
	end
	self.LastWeaponIndex = self.WeaponIndex
	self.WeaponIndex = WeaponIndex
	if WeaponIndex == 0 then
	end
	
	if self.LastWeaponIndex then
		local LastWeaponIndex = self.Data.WeaponId[self.LastWeaponIndex]
	end

	local LastWeaponWeapon = self:GetWeapon(self.LastWeaponIndex)
	if LastWeaponWeapon then
		LastWeaponWeapon:ShouldHideWeapon(true)
	end

	local WeaponId = self.Data.WeaponId[WeaponIndex]
	
	self:ChangeUsingWeaponById(WeaponId)
	self:GetOwnBlackBoardComponent():SetValueAsInt("WeaponIndex", WeaponIndex)
end

-- function Component:GetRangedWeaponId(WeaponInfo)
--     local WeaponId = nil
--     if WeaponInfo then
--         if WeaponInfo.WeaponId ~= 0 then
--             WeaponId = WeaponInfo.WeaponId
--         end
--     elseif not WeaponId then
--         if self:IsPlayer() or (self:IsPhantom() and self.Data.WearRangedWeapon) then
--             WeaponId = self.BattleCharInfo.RangedWeapon
--         end
--     end
--     return WeaponId
-- end

-- function Component:ServerSetUpRangedWeapon(WeaponInfo)
--     local WeaponId = self:GetRangedWeaponId(WeaponInfo)
--     if not WeaponId then
--         return
--     end
--     local Weapon = self:AddWeapon(WeaponId, WeaponInfo)
--     if not Weapon then
--         return
--     end
--     if self:IsPlayer() then
--         self:SyncPlayerState_RangedWeapon(WeaponId, Weapon:GetAttr("Level"))
--     end
--     if self:IsPhantom() then
--         self:SyncPhamtomState_RangedWeapon(WeaponId, Weapon:GetAttr("Level"))
--     end
--     Weapon:ShouldHideWeapon(true)
--     Weapon:UnBindWeaponFromHand(true, true)
--     -- Weapon:ActivateSkills()
-- end

-- function Component:GetUltraWeaponId(WeaponInfo)
--     local WeaponId = nil
--     if WeaponInfo then
--         if WeaponInfo.WeaponId ~= 0 then
--             WeaponId = WeaponInfo.WeaponId
--         end
--     elseif not WeaponId then
--         local UltraWeapons = self.BattleCharInfo.UltraWeapon
--         if not UltraWeapons then
--             return
--         end
--         WeaponId =UltraWeapons[1]
--     end
--     return WeaponId
-- end


-- function Component:ServerSetUpUltraWeapon(WeaponInfos)
--     if WeaponInfos then
--         local WeaponInfoIds = {}
--         for _, Info in ipairs(WeaponInfos) do
--             local WeaponId = self:GetUltraWeaponId(Info)
--             --DebugPrint("WeaponInfo存在888"..Info.WeaponId)
--             if not WeaponId then
--                 goto continue
--             end

--             WeaponInfoIds[WeaponId] = true
--             local Weapon = self:AddWeapon(WeaponId, Info, 1)
--             if not Weapon then
--                 goto continue
--             end

--             -- 防止未装备近战或远程武器的情况下默认使用显赫武器
--             Weapon:DeactivateSkills()

--             Weapon:ShouldHideWeapon(true)
--             Weapon:UnBindWeaponFromHand(true, true)

--             ::continue::
--         end

--         local UltraWeapons = self.BattleCharInfo.UltraWeapon

--         if not UltraWeapons then
--             return
--         end

--         for Index, WeaponId in ipairs(UltraWeapons) do
--             --检查 weaponId 是否存在
--             if WeaponId then
--                 local IsRealUltraWeapon = DataMgr.BattleWeapon[WeaponId].IsRealUltraWeapon
--                 if IsRealUltraWeapon and not WeaponInfoIds[WeaponId] then
--                    -- DebugPrint("WeaponInfo存在888  IsRealUltraWeapon"..WeaponId)
--                     local Weapon = self:AddWeapon(WeaponId,nil,Index)
--                     if Weapon then
--                         -- 防止未装备近战或远程武器时默认使用显赫武器
--                         Weapon:DeactivateSkills()
--                         Weapon:ShouldHideWeapon(true)
--                         Weapon:UnBindWeaponFromHand(true, true)
--                     end
--                 end
--             end
--         end

--     else

--         local UltraWeapons = self.BattleCharInfo.UltraWeapon

--         if not UltraWeapons then
--             return
--         end

--         for Index, WeaponId in ipairs(UltraWeapons) do
--             --检查 weaponId 是否存在
--             if WeaponId then
--                 local Weapon = self:AddWeapon(WeaponId,nil,Index)
--                 if Weapon then
--                     DebugPrint("WeaponInfo存在666"..WeaponId)
--                     -- 防止未装备近战或远程武器时默认使用显赫武器
--                     Weapon:DeactivateSkills()

--                     -- if self:IsPlayer() then
--                     --     self:SyncPlayerState_UltraWeapon(WeaponId, Weapon:GetAttr("Level"))
--                     -- end

--                     Weapon:ShouldHideWeapon(true)
--                     Weapon:UnBindWeaponFromHand(true, true)
--                 end
--             end
--         end
--     end

-- end

-- function Component:GetCondemnWeaponId()
--     local WeaponId = nil
--     --if WeaponInfo then
--     --    WeaponId = WeaponInfo.WeaponId
--     --end
--     if not WeaponId then
--         WeaponId = self.BattleCharInfo.CondemnWeapon
--     end
--     return WeaponId
-- end

function Component:SetUpCondemnWeapon()
    local WeaponId = self:GetCondemnWeaponId()
    if not WeaponId then
        return
    end
    local Weapon = self:AddWeapon(WeaponId)
    if not Weapon then
        return
    end
    Weapon:ShouldHideWeapon(true)
    Weapon:UnBindWeaponFromHand(true, true)
    Weapon:DeactivateSkills()
end

-- -- 服务器
-- function Component:ServerSetUpWeapons(MeleeWeapon, RangedWeapon, UltraWeapon)
--     if self:IsMonster() and not self:IsPhantom() then
--         self:ServerSetMonsterWeapons()
--         return
--     end

--     -- PrintTable({SetUpWeapons=1})
--     self:ClearWeapon()
--     self:ServerSetUpMeleeWeapon(MeleeWeapon)
--     self:ServerSetUpRangedWeapon(RangedWeapon)
--     self:ServerSetUpUltraWeapon(UltraWeapon)
--     self:SetUpCondemnWeapon()
--     self.WeaponNum = self.Weapons:Num()
--     self:InitWeaponHideState()
-- end

function Component:SpawnShowWeapon(WeaponId, Transform, ReplaceAttrs, SkillInfos, AppearanceInfo, WeaponInfo)
    local _Data = DataMgr.BattleWeapon[WeaponId]
    local WeaponClass = UE4.UClass.Load(_Data.WeaponBlueprint)
    assert(WeaponClass, '找不到展示武器蓝图:'..tostring(_Data.WeaponBlueprint))

    local NewShowWeapon = self:GetWorld():SpawnActor(WeaponClass, Transform, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn, nil, self, nil)
    NewShowWeapon:InitWeaponInfo(WeaponId, false, ReplaceAttrs, SkillInfos, AppearanceInfo, WeaponInfo)
    return NewShowWeapon
end 

function Component:SpawnShowWeaponAsync(WeaponId, Transform, ReplaceAttrs, SkillInfos, AppearanceInfo, WeaponInfo, OnLoaded)
    local _Data = DataMgr.BattleWeapon[WeaponId]
    local AssetPath = _Data.WeaponBlueprint
    assert(AssetPath, "展示武器路径为空，WeaponId = " .. tostring(WeaponId))

    --请求生成唯一
    self._ShowWeaponRequestId = (self._ShowWeaponRequestId or 0) + 1
    local ThisRequestId = self._ShowWeaponRequestId
    UE4.UResourceLibrary.LoadClassAsync(self, AssetPath, {
        self,
        function(_, ClassObject)

            -- 验证是否为当前最新请求
            if ThisRequestId ~= self._ShowWeaponRequestId then
                -- 旧请求就丢弃
                DebugPrint("[展示武器] 异步加载被取消")
                return
            end
            if not ClassObject then
                DebugPrint("异步加载展示武器失败: ", AssetPath)
                return
            end

            local NewShowWeapon = self:GetWorld():SpawnActor(
                ClassObject,
                Transform,
                UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn,
                nil, self, nil
            )
            NewShowWeapon.bIsShow = true
            local co = coroutine.create(function()
                NewShowWeapon:InitWeaponInfo(WeaponId, false, ReplaceAttrs, SkillInfos, AppearanceInfo, WeaponInfo, true)
                NewShowWeapon:SetupAccessories()
                coroutine.yield()
                if ThisRequestId ~= self._ShowWeaponRequestId then
                    NewShowWeapon:K2_DestroyActor()
                    -- 旧请求就丢弃
                    DebugPrint("[展示武器] 异步加载被取消")
                    return
                end
                NewShowWeapon:OnWeaponReady()
                if OnLoaded then
                    OnLoaded(NewShowWeapon)
                end
            end)
            EventManager:AddEvent(EventID.OnShowWeaponLoadFinished,self,self.OnShowWeaponLoadFinished)
            self.ShowWeaponCoroutines = self.ShowWeaponCoroutines or {}
            self.ShowWeaponCoroutines[NewShowWeapon] = co
            coroutine.resume(co)
        end
    })
end

function Component:OnShowWeaponLoadFinished(ShowWeapon)
    if(not self.ShowWeaponCoroutines or next(self.ShowWeaponCoroutines) == nil)then
        EventManager:RemoveEvent(EventID.OnShowWeaponLoadFinished,self)
        return
    end
    if(self.ShowWeaponCoroutines[ShowWeapon])then
        coroutine.resume(self.ShowWeaponCoroutines[ShowWeapon])
    end
end


-- 服务器
-- function Component:_SpawnWeapon(WeaponId, WeaponInfo)
--     local _Data = DataMgr.BattleWeapon[WeaponId]
--     local WeaponClass = UE4.UClass.Load(_Data.WeaponBlueprint)
--     assert(WeaponClass, '找不到武器蓝图:' .. tostring(_Data.WeaponBlueprint))
--     local HandHoldSocket = _Data.WeaponSockets["HandHold"]
--     if not HandHoldSocket then
--         HandHoldSocket = {}
--         HandHoldSocket["SocketB"] = "Root"
--     end
--     local HandHoldTransform = self.Mesh:GetSocketTransform(HandHoldSocket["SocketB"], Const.RST_World)
--     local NewWeapon = self:GetWorld():SpawnActor(WeaponClass, HandHoldTransform,
--     UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn, self, self, nil)

--     if NewWeapon then
--         -- 整合设置武器属性的逻辑到 InitWeaponInfo 中
--         NewWeapon:InitWeaponInfo(WeaponId, false, WeaponInfo and WeaponInfo.ReplaceAttrs, WeaponInfo and WeaponInfo.SkillInfos, WeaponInfo and WeaponInfo.AppearanceInfo, WeaponInfo)

--         --武器自带的Mod
--         -- if _Data.PassiveEffects then
--         --     local GradeLevel = math.floor(NewWeapon:GetAttr("GradeLevel") or 0)
--         --     NewWeapon.PassiveEffects = NewWeapon.PassiveEffects or {}
--         --     local Attribute = self.BattleCharInfo.Attribute
--         --     if not Attribute or NewWeapon:IsContainAttribute(Attribute) then
--         --         for _, PassiveEffectId in ipairs(_Data.PassiveEffects) do
--         --             table.insert(NewWeapon.PassiveEffects, {PassiveEffectId, math.min(DataMgr.DataConst.MaxSkillLevel, GradeLevel + 1)})
--         --         end
--         --     end
--         -- end
--         -- -- 添加被动效果
--         -- if NewWeapon.PassiveEffects then
--         --     self:AddWeaponModPassiveEffect(NewWeapon, NewWeapon.PassiveEffects)
--         -- end
--     end

--     return NewWeapon
-- end

------------------------------start c++---------------------------------
-- function Component:BindWeaponToBlend()
--     if self.UsingWeapon then
--         self.UsingWeapon:BindWeaponToBlend()
--     end
-- end

-- function Component:BindWeaponToHand(Weapon)
--     Weapon = Weapon or self.UsingWeapon
    
--     if Weapon then
--         if self.WeaponPos == Const.Shoulder then
--             self.WeaponPos = Const.Hand
--         end
--         Weapon:BindWeaponToHand()
--     end
-- end

-- function Component:UnBindWeaponFromHand()
--     if self.UsingWeapon then
--         if self.WeaponPos == Const.Hand then
--             self.WeaponPos = Const.Shoulder
--         end
--         self.UsingWeapon:UnBindWeaponFromHand()
--     end
-- end

-- ---@param Weapon BP_WeaponBase_C
-- function Component:ChangeWeaponHideStateWhenUnbind(Weapon)
--     if not IsValid(Weapon) then
--         return
--     end
--     if IsClient(self) then
--         return
--     end
--     if Weapon == self.MeleeWeapon then
--         if IsValid(self.RangedWeapon) and self.RangedWeapon:IsUnBind() then
--             self.RangedWeapon:SetActorHideTag("Unbind", true)
--         end
--     elseif Weapon == self.RangedWeapon then
--         if IsValid(self.MeleeWeapon) and self.MeleeWeapon:IsUnBind() then
--             self.MeleeWeapon:SetActorHideTag("Unbind", true)
--         end
--     end
--     Weapon:SetActorHideTag("Unbind", false)
-- end

-- function Component:PlayWeaponNewTypeIn()
--     self.UsingWeapon:PlayWeaponNewTypeIn()
-- end

-- function Component:BindNewWeaponType(AttachSocket, InverseSocket)
--     self.UsingWeapon:PlayWeaponNewTypeIn(AttachSocket, InverseSocket)
-- end

------------------------------end c++---------------------------------

-- function Component:HideWeaponByWeaponTag(WeaponTag, bHide, HideTag)
--     if not self.Weapons or self.Weapons:Num() == 0 then
--         return
--     end
--     if MiscUtils.IsNilOrEmpty(HideTag) then
--         HideTag = "Weapon"
--     end
--     local Tag2WeaponIdTable = self.Tag2WeaponId:ToTable()
--     local WeaponId = Tag2WeaponIdTable[WeaponTag]
--     if not WeaponId then
--         return
--     end
--     local Weapon = self:GetWeapon(WeaponId)
--     if not Weapon then
--         return
--     end
--     if Weapon == self.UsingWeapon and bHide then
--         return
--     end
--     if (Weapon.BindToHand or Weapon.BindToCreature) and bHide then
--         return
--     end
--     Weapon:SetActorHideTag(HideTag, bHide)
-- end

-- function Component:ForbidWeaponByWeaponTag(WeaponTag, bForbid, ForbidTag, bHideWhenForbid)
--     if not self.Weapons or self.Weapons:Num() == 0 then
--         return
--     end
--     if MiscUtils.IsNilOrEmpty(ForbidTag) then
--         ForbidTag = "ForbidDefault"
--     end
--     local WeaponId = self.Tag2WeaponId[WeaponTag]
--     if not WeaponId then
--         return
--     end
--     local Weapon = self:GetWeapon(WeaponId)
--     if not Weapon then
--         return
--     end
--     Weapon:SetWeaponForbid(bForbid, ForbidTag, bHideWhenForbid)
--     EventManager:FireEvent(EventID.OnCharForbidWeapon, WeaponTag, bForbid)
-- end

-- function Component:CheckWeaponForbidByWeaponTag(WeaponTag)
--     if not self.Tag2WeaponId or not self.Weapons or self.Weapons:Num() == 0 then
--         return false
--     end
--     local WeaponId = self.Tag2WeaponId[WeaponTag]
--     if not WeaponId then
--         return false
--     end
--     local Weapon = self:GetWeapon(WeaponId)
--     if not Weapon then
--         return false
--     end
--     return Weapon:IsWeaponForbid()
-- end

-- function Component:GenUniqueWeaponHideTag()
--     if not self.WeaponHideTagCount then
--         self.WeaponHideTagCount = 0
--     end
--     self.WeaponHideTagCount = self.WeaponHideTagCount + 1
--     return "Weapon_" .. tostring(self.WeaponHideTagCount)
-- end

-- function Component:UnFreezeWeapons()
--     if not self.Weapons or self.Weapons:Num() == 0 then
--         return
--     end

--     if not IsValid(self.UsingWeapon) then
--         self.UsingWeapon = nil
--     end
--     if not IsValid(self.MeleeWeapon) then
--         self.MeleeWeapon = nil
--     end
--     if not IsValid(self.RangedWeapon) then
--         self.RangedWeapon = nil
--     end
--     if not IsValid(self.CondemnWeapon) then
--         self.CondemnWeapon = nil
--     end

--     for _, WeaponId in pairs(CommonUtils.Keys(self.Weapons)) do
--         local Weapon = self:GetWeapon(WeaponId)
--         if IsValid(Weapon) then
--             Weapon.WeaponMesh:SetCollisionProfileName(self.DefaultMeshCollision or "NoCollision")
--             Weapon:SetActorHideTag("CacheFreeze", false)
--             Weapon:UnFreezeChildWeapon()
--             if not IsInBattleLua(self) and self.UsingWeapon == nil then
--                 self:RealChangeUsingWeapon(Weapon)
--             end
--         end
--     end
-- end

--function Component:FixWeaponVisibilityOnWeaponChanged()
--    if not self.Weapons or self.Weapons:Num() == 0 then
--        return
--    end
--    for _, Weapon in pairs(self.Weapons) do
--        repeat
--            if not IsValid(Weapon) then
--                break
--            end
--            
--            if Weapon == self.UsingWeapon then
--                Weapon:SetActorHideTag("UnUsing", false)
--                Weapon:SetActorHideTag("Unbind", false)
--            elseif Weapon ~= self.CondemnWeapon and Weapon:IsUnBind() then
--                Weapon:SetActorHideTag("UnUsing", true)
--            end
--        until true
--    end
--end

---@param bUnusingInBind boolean @武器用的，是否作用于非当前正在使用但是处于bind下的武器
-- function Component:HideAllWeapons(HideTag, Hidden, bUnusingInBind, bFromNotify)
--     if self.Weapons and self.Weapons:Num() > 0 then 
--         for _, v in pairs(self.Weapons) do
--             repeat
--                 if bUnusingInBind == false and v ~= self.UsingWeapon 
--                 and (v.BindToCreature or v.BindToHand) then
--                     break
--                 end
--                 v:SetActorHideTag(HideTag, Hidden, bFromNotify)
--             until true
--         end
--     end
-- end


--function Component:DelayUnBindWeaponFromCreature(BindWeapon, BindWeaponState)
--    self:AddDelayFrameFunc(function()
--        if IsValid(BindWeapon) and BindWeapon.Owner then
--            BindWeapon:UnBindWeaponFromCreature(BindWeaponState)
--            -- 解绑后将武器scale初始化
--            BindWeapon:SetActorScale3D(FVector(1.0, 1.0, 1.0))
--        end
--    end, 2)
--end

return Component
