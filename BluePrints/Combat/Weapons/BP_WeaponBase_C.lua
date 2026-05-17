
require "UnLua"
local EffectResults = require "BluePrints.Combat.BattleLogic.EffectResults"
local EMCache = require "EMCache.EMCache"
local HyperWeaponUtils = require "Utils.HyperWeaponUtils"

---@type BP_WeaponBase_C
local BP_WeaponBase_C = Class({
	"BluePrints.Combat.Components.EffectSourceInterface",
})

BP_WeaponBase_C._components = {
    "BluePrints.Combat.Weapons.WeaponAttrComponent",
    "BluePrints.Combat.Components.SkillLevelInterface",
	"BluePrints.Combat.Components.ActorTypeComponent",
	"BluePrints.Common.DelayFrameComponent",
}

function BP_WeaponBase_C:ReceiveBeginPlay()
	self.Overridden.ReceiveBeginPlay(self)
	self.ForbidTag = {}
end

function BP_WeaponBase_C:OnRep_ServerBornInfo()
    self.BornInfo = EffectResults.UnpackEffectStruct(self.ServerBornInfo)
end

-- function BP_WeaponBase_C:OnRep_ServerInitSuccess()
--     -- 客户端延迟一下初始化
--     self.InitTimerHandle = self:AddTimer(0.1, self.TryInitInitWeaponInfo, true)
--     -- self.InitTimerHandle = self:AddTimer(10 * math.random(), self.TryInitInitWeaponInfo, true)
-- 	print(_G.LogTag, "TryInitInitWeaponInfozjy", self.Accessories:Length())
-- end

-- -- function BP_WeaponBase_C:GetObjType()
-- --     return EObjType.WeaponBase
-- -- end

-- function BP_WeaponBase_C:TryInitInitWeaponInfo()
-- 	if not self.Owner or not self.Owner.InitSuccess then
-- 		return
-- 	end

-- 	if self.ChildWeapon and not self.ChildWeapon.InitSuccess then
-- 		return
-- 	end

-- 	if self.InheritAttributesWeaponId ~= 0 then
-- 		local Weapon = self.Owner:GetWeapon(self.InheritAttributesWeaponId)
-- 		if not Weapon or not Weapon.InitSuccess then
-- 			return
-- 		end
-- 	end

-- 	if not self.IsChild then
-- 		self.Owner:ClientAddWeapon(self)
-- 	end

-- 	self:InitWeaponInfo(self.WeaponId, false, nil, self.BornInfo and self.BornInfo.SkillInfos, self.BornInfo and self.BornInfo.AppearanceInfo)

-- 	self:RemoveTimer(self.InitTimerHandle)
--     self.InitTimerHandle = nil
-- end

function BP_WeaponBase_C:SetBornInfo()
	if not self.BornInfo then
        self.BornInfo = EffectResults.Result()
    end
end

function BP_WeaponBase_C:IsReplaceAttrs()
	return not self.ReplaceAttrs
end

function BP_WeaponBase_C:SetBornInfoAppearance()
	self.BornInfo.AppearanceInfo = self.AppearanceInfo
end

function BP_WeaponBase_C:SetData()
	self.Data = DataMgr.BattleWeapon[self.WeaponId];
end

function BP_WeaponBase_C:ApplyWeaponAttributes()
	-- if IsClient(self) then
	-- 	return
	-- end
	-- if self.InheritAttributesWeaponId ~= 0 then
	-- 	return
	-- end
	--self:SetTableAttr(self.ReplaceAttrs)
	if not self:CanApplyWeaponAttributes() then
		return
	end
	local attrs = rawget(self, "ReplaceAttrs")
	self:SetTableAttr(attrs)
end


-- function BP_WeaponBase_C:InitWeaponInfo(WeaponId, IsChild, ReplaceAttrs, SkillInfos, AppearanceInfo, WeaponInfo)
-- 	-- self.ReplaceAttrs = ReplaceAttrs;
-- 	-- self.SkillInfos = SkillInfos;
-- 	-- self.AppearanceInfo = AppearanceInfo

-- 	-- WeaponInfo = WeaponInfo or {}
-- 	-- -- 设置基础属性
--     -- self:SetAttr("Level", WeaponInfo.Level or 1)
--     -- self:SetAttr("Exp", WeaponInfo.Exp or 0)
--     -- self:SetAttr("GradeLevel", WeaponInfo.GradeLevel or Const.DefaultWeaponGrade)
--     -- self:SetAttr("EnhanceLevel", WeaponInfo.EnhanceLevel or 0)

-- 	self:InitWeaponInfoImpl(WeaponId,IsChild)

--     -- -- 设置武器的子弹数量
--     -- if WeaponInfo.BulletNum then
--     --     self:SetAttr("BulletNum", WeaponInfo.BulletNum)
--     -- end
--     -- if WeaponInfo.MagazineBulletNum then
--     --     self:SetAttr("MagazineBulletNum", WeaponInfo.MagazineBulletNum)
--     -- end
-- 	-- -- 确保 PassiveEffects 不为空
--     -- self.PassiveEffects = {}
-- 	-- if WeaponInfo and WeaponInfo.PassiveEffects then
--     --     self.PassiveEffects = New(WeaponInfo.PassiveEffects)
--     -- end

-- end

function BP_WeaponBase_C:SetServerBornInfo()
	self.ServerBornInfo = self.BornInfo:ToEffectStruct()
end

function BP_WeaponBase_C:Lua_InitWeaponAppearance()
	self:InitWeaponAppearance(self.AppearanceInfo)
end

function BP_WeaponBase_C:InitWeaponAppearance(AppearanceInfo)
	self.AppearanceInfo = AppearanceInfo
	self:InitWeaponSkin(AppearanceInfo and AppearanceInfo.SkinId)
	if self.bIsShow then
		return
	end
	self:Lua_InitShowWeaponAppearance()
end

function BP_WeaponBase_C:Lua_InitShowWeaponAppearance()
	self:InitWeaponBreakMI()
	self:InitWeaponColor(self.AppearanceInfo and self.AppearanceInfo.Colors)
	local AccessorySuit = self.AppearanceInfo and self.AppearanceInfo.AccessorySuit or {}
	for AccessoryType, AccessoryTypeIdx in pairs(CommonConst.WeaponAccessoryTypeIndex) do
		self:ChangeAccessory(AccessorySuit[AccessoryTypeIdx],AccessoryType)
	end
	EventManager:FireEvent(EventID.OnShowWeaponLoadFinished,self)
end

function BP_WeaponBase_C:InitWeaponSkin(SkinId)
	self:InitWeaponSkinImpl(SkinId,self.bIsShow)
end

function BP_WeaponBase_C:InitWeaponColor(Colors)
    -- PrintTable({InitWeaponColor=Colors,Au=IsAuthority(self), Colors=self.BornInfo.Colors},10)
    if Colors then
        local SpecialColor = Colors.SpecialColor
        if SpecialColor == DataMgr.GlobalConstant.WeaponDefaultColor.ConstantValue then
            self:InitWeaponPartsColor(Colors)
        else
            --self:InitWeaponSpecialColor(Colors)
        end
    end
end

function BP_WeaponBase_C:InitWeaponPartsColor(Colors)
    if self.ChildWeapon then
        self.ChildWeapon:InitWeaponPartsColor(Colors)
    end
    if Colors.Colors then
        local SwatchData = DataMgr.Swatch
        local Color = FLinearColor()
        for PartIdx, ColorId in ipairs(Colors.Colors) do
            local func = self["SetWPTintColor"..PartIdx]
			local ColorData = SwatchData[ColorId]
			if(ColorData and func)then
				if(ColorData.ActualR and ColorData.ActualG and ColorData.ActualB)then
					Color = FLinearColor(ColorData.ActualR,ColorData.ActualG,ColorData.ActualB)
					func(self, Color)
				elseif(ColorData.ColorNumber)then
					local ColorNumber = ColorData.ColorNumber
					UKismetMathLibrary.LinearColor_SetFromSRGB(Color,
						FColor(ColorNumber[1] or 0,ColorNumber[2] or 0,ColorNumber[3] or 0))
					func(self, Color)
				end
			end
        end
    end
end

function BP_WeaponBase_C:InitWeaponSpecialColor(Colors)
    if self.ChildWeapon then
        self.ChildWeapon:InitWeaponSpecialColor(Colors)
    end
    if(Colors.SpecialColor)then
        local Data = DataMgr.SpecialSwatch[Colors.SpecialColor]
        if(Data and Data.LinkedMaterial)then
            self:ChangeWPMaterial(Data.LinkedMaterial)
        end
    end
end

function BP_WeaponBase_C:ChangeAccessory(AccessoryId,AccessoryType)
	local Data = DataMgr.WeaponAccessory[AccessoryId]
	if(AccessoryType == CommonConst.WeaponAccessoryTypes.Accessory)then
		--普通挂饰
		self:DetachWeaponSuit()
		if(Data == nil)then
			return
		end
		local Offsets = Data.Offset or {0,0,0}
		local Offset = FTransform(FRotator(0,0,0):ToQuat(),FVector(Offsets[1] or 0,Offsets[2] or 0,Offsets[3] or 0))
		self:AttachWeaponSuit(Data.AccessorySocket,Data.ModelPath,Offset, Data.NiagaraPath, Data.SocketName)
		self:ChangeWPSuitLook(Data.ChangeColor or 1)
		return
	end
	--架势特效
    if(AccessoryId == nil or Data == nil)then
		self.AccessoryAuName = ""
        return
    end
	if Data.StanceFXType and Data.StanceFXTag then
		self.StanceFXName = Data.StanceFXType .. "_" .. Data.StanceFXTag .. "_"
		self.StanceFXType = Data.StanceFXType
		self.StanceFXTag = Data.StanceFXTag
	else
		self.StanceFXName = ""
		self.StanceFXType = ""
		self.StanceFXTag = ""
	end
	if Data.AuSplice then
		self.AccessoryAuName = Data.AuSplice
	else
		self.AccessoryAuName = ""
	end
end

-- function BP_WeaponBase_C:SetupWeaponScaleFactor()
-- 	local BattleCharTag
-- 	if self.Owner:IsPlayer() or self.Owner:IsPhantom() then
-- 		BattleCharTag = self.Owner.BattleCharInfo.BattleCharTag
-- 	else
-- 		BattleCharTag = DataMgr.Monster[self.Owner.UnitId].BattleCharTag
-- 	end
-- 	self.ScalerFactor = 1
-- 	if self.Owner and self.Owner:GetCharModelComponent() then 
-- 		local ModelId = self.Owner:GetCharModelComponent():GetCurrentModelId()
-- 		local ModelInfo = DataMgr.Model[ModelId]
-- 		if ModelInfo and ModelInfo.WeaponScale then 
-- 			self.ScalerFactor = ModelInfo.WeaponScale or 1
-- 		end
-- 	end
-- 	self.AixsScalerFactor = Const.OneVector
-- 	local WeaponMeshRes = self.Data.WeaponMeshResourceId
-- 	local WeaponMeshResInfo = DataMgr.Model[WeaponMeshRes]
-- 	if WeaponMeshResInfo then
-- 		local AixsModelScale = WeaponMeshResInfo.ModelAixsScale
-- 		if AixsModelScale and #AixsModelScale == 3 then
-- 			self.AixsScalerFactor = FVector(AixsModelScale[1], AixsModelScale[2], AixsModelScale[3])
-- 		end
-- 	end

-- 	self.AixsScalerFactor = self.AixsScalerFactor * self.ScalerFactor
-- end

--function BP_WeaponBase_C:InitPassiveEffectsAttribute()
--	self.PassiveEffectsAttribute = nil
--	local PassiveEffectsAttribute = self.Data.PassiveEffectsAttribute
--	if not PassiveEffectsAttribute then
--		return
--	end
--	self.PassiveEffectsAttribute = {}
--	for i = 1, #PassiveEffectsAttribute do
--		self.PassiveEffectsAttribute[PassiveEffectsAttribute[i]] = true
--	end
--end
--
--function BP_WeaponBase_C:IsContainAttribute(Attribute)
--	if not self.PassiveEffectsAttribute then
--		return true
--	end
--	return self.PassiveEffectsAttribute[Attribute]
--end

-- function BP_WeaponBase_C:InitWeaponAddAttrs()
-- 	if not self.Data.AddAttrs then
-- 		return
-- 	end
	
-- 	for _, AttrData in pairs(self.Data.AddAttrs) do
-- 		local AttrName = AttrData.AttrName
-- 		if DataMgr.AttributeType[AttrName] then
-- 			AttrName = AttrName .. "_" .. (AttrData.Type or "Normal")
-- 		end

-- 		local Rate = AttrData.Rate
-- 		local Value = AttrData.Value
-- 		if AttrName == 'ATK' then
-- 			for _AttrName, _ in pairs(DataMgr.Attribute) do
-- 				if Rate then
-- 					-- CommonConst.RateIndex.GlobalATK 总攻击力乘区
-- 					self:SetRateAttr("ATK_" .. _AttrName, "WeaponPassive", CommonConst.RateIndex.GlobalATK, Rate)
-- 				end
-- 				if Value then
-- 					self:SetAddAttr("ATK_" .. _AttrName, "WeaponPassive", Value)
-- 				end
-- 			end
-- 		else
-- 			-- CommonConst.RateIndex.Default 默认乘区
-- 			if Rate then
-- 				self:SetRateAttr(AttrName, "WeaponPassive", CommonConst.RateIndex.Default, Rate)
-- 			end
-- 			if Value then
-- 				self:SetAddAttr(AttrName, "WeaponPassive", Value)
-- 			end
-- 		end
-- 	end
-- end

-- function BP_WeaponBase_C:InitExcelWeaponTag()
-- 	-- 如果装备的角色没有得意武器，返回
-- 	local ExcelWeaponTag = self.Owner.BattleCharInfo.ExcelWeaponTag
-- 	if not ExcelWeaponTag then
-- 		return
-- 	end
-- 	-- 如果武器标签不符合，返回
-- 	if not self:HasTag(ExcelWeaponTag) then
-- 		return
-- 	end

-- 	local Rate = self.Owner.BattleCharInfo.ExcelWeaponRate

-- 	for _AttrName, _ in pairs(DataMgr.Attribute) do
-- 		local AttrName = "ATK_" .. _AttrName
-- 		self:SetRateAttr(AttrName, "ExcelWeapon", CommonConst.RateIndex.ExcelWeapon, Rate) -- 得意武器攻击加成
-- 	end

-- 	self:CalcATK()
-- end

-- function BP_WeaponBase_C:OnWeaponReady()
-- 	-- if self.Owner.PlayerAnimInstance.IdleTag == "0" or self.Owner.PlayerAnimInstance.IdleTag == "EmoIdle" then
-- 	-- 	self:UnBindWeaponFromHand(true)
-- 	-- end
-- 	if self.Owner.UsingWeapon and self.Owner.UsingWeapon.WeaponId == self.WeaponId then
-- 		self:OnEnter()
-- 		if not self.Owner:IsPlayer() and not self.Owner:IsPhantom() then
-- 	        self:BindWeaponToHand()
-- 	    end
-- 	-- 激活近战武器的技能
-- 	elseif not self.Owner.UsingWeapon and self.Owner.MeleeWeapon and self.Owner.MeleeWeapon.WeaponId  == self.WeaponId then
-- 		self:ActivateSkills()
-- 	-- 激活远程武器的技能
-- 	elseif not self.Owner.UsingWeapon and self.Owner.RangedWeapon and self.Owner.RangedWeapon.WeaponId  == self.WeaponId then
-- 		self:ActivateSkills()
-- 	else
-- 		self:OnLeave()
-- 	end
-- 	-- 纯蓝图函数 通知属性初始化完成 做视觉效果
-- 	self:OnAttrInitReady()
-- 	-- 联机服务器
--     if IsDedicatedServer(self) and IsAuthority(self) then
--         self.ServerBornInfo = self.BornInfo:ToEffectStruct()
--     end
-- 	-- 联机客户端
-- 	if IsClient(self) then
-- 		self:ShouldHideWeapon(true)
-- 		if self.Owner.IsMainPlayer and self.Owner:IsMainPlayer() and self.Owner.RangedWeapon.WeaponId  == self.WeaponId then
-- 			EventManager:FireEvent(EventID.OnSwitchWeapon)
-- 		end
-- 	end

-- 	self.Overridden.OnWeaponReady(self)
-- 	self:OnWeaponReadyCPP();
-- end

-- function BP_WeaponBase_C:ScaleByChar()
-- end

-- function BP_WeaponBase_C:GetOwnerCharTag()
-- 	local BattleCharTag

-- 	if self.Owner:IsPlayer() or self.Owner:IsPhantom() then
-- 		BattleCharTag = self.Owner.BattleCharInfo.BattleCharTag
-- 	else
-- 		BattleCharTag = DataMgr.Monster[self.Owner.UnitId].BattleCharTag
-- 	end
-- 	-- print("BattleCharTag", BattleCharTag)
-- 	if BattleCharTag then
-- 		return BattleCharTag[1]
-- 	end
-- 	return ""
-- end

-- function BP_WeaponBase_C:SpawnChildWeapon()
-- 	if not self.Data.ChildWeaponId then
-- 		return
-- 	end
-- 	if not IsAuthority(self) then
-- 		return
-- 	end
-- 	local _Data = DataMgr.BattleWeapon[self.Data.ChildWeaponId]
--     local WeaponClass = UE4.UClass.Load(_Data.WeaponBlueprint)
-- 	self.ChildWeapon = self:GetWorld():SpawnActor(WeaponClass, self.Owner:GetTransform(), UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn, self.Owner, self.Owner, nil)
--     if self.ChildWeapon then
-- 		self.ChildWeapon:InitWeaponInfo(self.Data.ChildWeaponId, true, nil, nil)
--     end
--     if self.ChildWeapon then
--     	self.ChildWeapon.bVisibleWhenUnbind = self.bVisibleWhenUnbind
-- 		self.ChildWeapon.bChildWeapon = true
--     end
-- end

--function BP_WeaponBase_C:HasTag(WeaponTag)
--	return self.WeaponTags:Contains(WeaponTag)
--end

-- function BP_WeaponBase_C:SetupAccessories()
-- 	if not self.Owner then 
-- 		return 
-- 	end
-- 	if not MiscUtils.IsSimulatedProxy(self) and not IsStandAlone(self) then
-- 		return
-- 	end
-- 	if not self.Data.WipCharmsResIds then
-- 		return
-- 	end
-- 	local SocketOwner = self:GetOwner()
-- 	print(_G.LogTag, "SetupAccessories")
-- 	for i,v in pairs(self.Data.WipCharmsResIds) do
-- 		local AccessoryClass = UE4.UClass.Load("/Game/BluePrints/Item/AccessoryItems/BP_AccessoryItem.BP_AccessoryItem")
-- 		local NewAccessory = self:GetWorld():SpawnActor(AccessoryClass, SocketOwner:GetTransform(), UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn, SocketOwner, SocketOwner, nil)
-- 		-- print('44444444444444444444zjy',v, NewAccessory, self.Owner:GetLocalRole())
-- 		if NewAccessory then
-- 			self.Accessories:Add(NewAccessory)
-- 			NewAccessory:InitModelInfo(v, self.Data.WipCharmsAttachRules[i], self, SocketOwner, i)
-- 		end
-- 	end
-- 	-- print('333333333333333333333333333333333333333333333333333333333333333333zjy',self.Accessories:Length(), self.Owner:GetLocalRole())
-- end

function BP_WeaponBase_C:ClearAccessories()
	for i = 1, self.Accessories:Length() do
		local Accessory = self.Accessories:GetRef(i)
		Accessory:K2_DestroyActor()
	end
	self.Accessories:Clear()
end

function BP_WeaponBase_C:Destroy()
	if self.Owner ~= nil then
		self.Owner:RemovePassiveEffectByWeapon(self)
		self:RemoveWeaponSkill()
	end
	self:ClearAccessories()
	if self.ChildWeapon then
		self.ChildWeapon:K2_DestroyActor()
	end
	self:K2_DestroyActor()
end

function BP_WeaponBase_C:GetSkillByType(SkillType)
	if not self.TypeSkills then
		return 0
	end
	return self.TypeSkills[SkillType]
end

function BP_WeaponBase_C:GetWeaponOwner()
	return self.Owner
end

function BP_WeaponBase_C:AddWeaponSkill()
	-- PrintTable({AddWeaponSkill=SkillInfos,IsAuthority=IsAuthority(self)},10)
	if not self.Owner then return end
	-- 从登录服或者联机服务器获取数据
	if self.Owner.FromOtherWorld then 
		return 
	end
    if self.SkillInfos then
        for SkillId, SkillInfo in pairs(self.SkillInfos) do
            local SkillLevel = SkillInfo.Level or Const.DefaultSkillLevel
            local SkillGrade = SkillInfo.Grade or Const.DefaultSkillGrade
			if self.Owner.SkillsComponent then
				self.Owner.SkillsComponent:ServerAddSkillInfo(SkillId, SkillLevel, SkillGrade, 0, self)
			end
        end
        -- self.BornInfo.SkillInfos = self.SkillInfos
    else
		local SkillLevel = 1
		local SkillGrade = 0
        local SkillList = self.Data.WeaponSkillList
		if self.Data.InheritSkillId then
			local Skill = self.Owner:GetSkill(self.Data.InheritSkillId)
			if Skill then
				SkillLevel = Skill.SkillLevel == 0 and 1 or Skill.SkillLevel
				SkillGrade = Skill.SkillGrade == 0 and 0 or Skill.SkillGrade
			end

		end

		if SkillList ~= nil then
			for _, SkillId in ipairs(SkillList) do
				if self.Owner.SkillsComponent then
					self.Owner.SkillsComponent:ServerAddSkillInfo(SkillId, SkillLevel, SkillGrade, 0, self)
				end
			end
		end
	end
end

function BP_WeaponBase_C:RemoveWeaponSkill()
	if not self.Owner then return end
	local SkillList = self.Data.WeaponSkillList
	if SkillList ~= nil then
		for i,SkillId in pairs(SkillList) do
			if self.Owner.SkillsComponent then
				self.Owner.SkillsComponent:ServerRemoveSkillInfo(SkillId)
			end
			if SkillId == self.Owner.CurrentSkillId then
				self.Owner:StopSkill(UE.ESkillStopReason.SkillRemove)
				-- self.Owner.CurrentSkillId = nil
			end
		end
	end
end

--activate as UsingWeapon
-- function BP_WeaponBase_C:OnEnter()
-- 	if not self.InitSuccess then
-- 		return
-- 	end
-- 	if self.InHand then
-- 		return
-- 	end
-- 	self.InHand = true
-- 	--local OnwerInAmory = self.Owner.ArmoryTag ~= nil and self.Owner.ArmoryTag ~= false

-- 	self:ShouldHideWeapon(false, OnwerInAmory)
-- 	self:ActivateSkills()
-- 	for i = 1, self.Accessories:Length() do
-- 		self.Accessories:GetRef(i):OnEnter()
-- 	end
-- end


--activate as UsingWeapon
-- function BP_WeaponBase_C:ActivateSkills()
-- 	if not self.Owner then return end
-- 	self:SetIsActivated(true);
-- 	local ChangedSkills = TMap(0, 0)
-- 	if self.Owner.SkillsComponent and self.Owner.SkillsComponent.SkillInfos then
-- 		for _, Data in pairs(self.Owner.SkillsComponent.SkillInfos) do
-- 			if Data.Weapon and Data.Weapon == self and not Data.IsSubSkill then
-- 				local SkillId = Data.SkillId
-- 				local Skill = self.Owner:GetSkill(SkillId)
-- 				if Skill then
-- 					local SkillType = Skill:GetSkillType()
-- 					local OldSkillId = self.Owner.Type_2_Skills:Find(SkillType)
-- 					if OldSkillId and OldSkillId ~= SkillId then
-- 						self.Owner.WeaponReplaceSkills:Add(SkillId, OldSkillId)
-- 						ChangedSkills:Add(OldSkillId, SkillId)
-- 					end
-- 				end
-- 				self.Owner:ActivateSkill(SkillId)
-- 			end
-- 		end
-- 	else
-- 		local SkillList = self.Data.WeaponSkillList
-- 		if SkillList ~= nil then
-- 			for _, SkillId in pairs(SkillList) do
-- 				local Skill = self.Owner:GetSkill(SkillId)
-- 				if Skill then
-- 					local SkillType = Skill:GetSkillType()
-- 					local OldSkillId = self.Owner.Type_2_Skills:Find(SkillType)
-- 					if OldSkillId and OldSkillId ~= SkillId then
-- 						self.Owner.WeaponReplaceSkills:Add(SkillId, OldSkillId)
-- 						ChangedSkills:Add(OldSkillId, SkillId)
-- 					end
-- 				end
-- 				self.Owner:ActivateSkill(SkillId)
-- 			end
-- 		end
-- 	end
-- 	if self.Owner:IsMainPlayer() and not self.Owner:IsRobot() then
-- 		self:AddDelayFrameFunc(
-- 				function()
-- 					if IsValid(self.Owner) and self.Owner.UpdateSkillUIInfo then -- 刷新技能面板
-- 						self.Owner:UpdateSkillUIInfo(ChangedSkills)
-- 					end
-- 				end)
-- 	end
-- end

-- function BP_WeaponBase_C:DeactivateSkills()
-- 	if not self.Owner then return end
-- 	self:SetIsActivated(false);
-- 	if self.Owner.SkillsComponent and self.Owner.SkillsComponent.SkillInfos then
-- 		for _, Data in pairs(self.Owner.SkillsComponent.SkillInfos) do
-- 			if Data.Weapon and Data.Weapon == self and not Data.IsSubSkill then
-- 				local SkillId = Data.SkillId
-- 				self.Owner:DeactivateSkill(SkillId)
-- 			end
-- 		end
		
-- 	--end
-- 	--if self.BornInfo.SkillInfos then
-- 	--	for SkillId, _ in pairs(self.BornInfo.SkillInfos) do
--     --        self.Owner:DeactivateSkill(SkillId)
--     --    end
-- 	else
-- 		local SkillList = self.Data.WeaponSkillList
-- 		if SkillList ~= nil then
-- 			for _, v in pairs(SkillList) do
-- 				self.Owner:DeactivateSkill(v)
-- 			end
-- 		end
-- 	end
-- end

function BP_WeaponBase_C:GetSkills()
	local Skills = {}
	if self.Owner.SkillsComponent and self.Owner.SkillsComponent.SkillInfos then
		for _, Data in pairs(self.Owner.SkillsComponent.SkillInfos) do
			if Data.Weapon and Data.Weapon == self then
				local SkillId = Data.SkillId
				table.insert(Skills, SkillId)
			end
		end
	--end
	--if self.BornInfo.SkillInfos then
	--	for SkillId, _ in pairs(self.BornInfo.SkillInfos) do
	--		table.insert(Skills, SkillId)
	--	end
	else
		local SkillList = self.Data.WeaponSkillList
		if SkillList ~= nil then
			for _, v in pairs(SkillList) do
				table.insert(Skills, v)
			end
		end
	end
	return Skills
end

--deactivate as UsingWeapon
function BP_WeaponBase_C:OnLeave(DontPlayDissolve)
	if not self.InHand then
		return
	end

	self.InHand = false
	if not self.InitSuccess then
		return
	end
	self:ShouldHideWeapon()
	self:UnBindWeaponFromHand(DontPlayDissolve)
	for i = 1, self.Accessories:Length() do
		self.Accessories:GetRef(i):OnLeave()
	end
end


-- When weapon change out from Carried Weapons
-- function BP_WeaponBase_C:OnDismiss()
-- 	self.InHand = false
-- 	self:UnBindWeaponFromHand(true)
-- 	self:ShouldHideWeapon(false)
-- 	for i = 1, self.Accessories:Length() do
-- 		self.Accessories:GetRef(i):OnDismiss()
-- 	end
-- end

-- function BP_WeaponBase_C:_InverseWeaponPosition(SocketName, FromCreature)
-- 	-- PrintTable({_InverseWeaponPosition=SocketName})
-- 	-- local Scale = self:GetActorScale3D()
-- 	local RelativeTransformSpace = FromCreature and UE4.ERelativeTransformSpace.RTS_ParentBoneSpace or UE4.ERelativeTransformSpace.RTS_Component
-- 	local Transform = self.WeaponMesh:GetSocketTransform(SocketName, RelativeTransformSpace)
-- 	local InverseTransform = Transform:Inverse()
-- 	self.WeaponMesh:K2_SetRelativeTransform(InverseTransform, false, nil, true)
-- 	local Scale = Const.OneVector * self.AixsScalerFactor
-- 	self:SetActorScale3D(Scale)
-- end

------------ start c++  ------------------------------------------
-- function BP_WeaponBase_C:BindWeaponToBlend()
-- 	if not self.InitSuccess then
-- 		return
-- 	end
-- 	if self.BindToCreature then
-- 		return
-- 	end
-- 	self.BindToHand = false
-- 	local BlendHoldSocket = self.Data.WeaponSockets["BlendHold"]
-- 	local AttachSocket = BlendHoldSocket["SocketB"]
-- 	local InverseSocket = BlendHoldSocket["SocketA"]
-- 	self:K2_AttachToComponent(self.Owner.Mesh, AttachSocket, UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.KeepWorld)
-- 	self:_InverseWeaponPosition(InverseSocket)
-- end

-- function BP_WeaponBase_C:BindWeaponToHand()
-- 	if not self.InitSuccess then
-- 		return
-- 	end
-- 	if self.BindToCreature then
-- 		return
-- 	end
-- 	self.BindToHand = true
-- 	self:SetActorHideTag("Unbind", false)
-- 	self:SetActorHideTag('Weapon', false)
-- 	local HandHoldSocket = self.Data.WeaponSockets["HandHold"]
-- 	local AttachSocket = HandHoldSocket["SocketB"]
-- 	local InverseSocket = HandHoldSocket["SocketA"]
-- 	local HandHoldInfo = self.Owner.HandHoldSocket
-- 	if HandHoldInfo then 
-- 		if HandHoldInfo.SocketA ~= nil and HandHoldInfo.SocketA ~= ""  and HandHoldInfo.SocketA ~= "None" and HandHoldInfo.SocketA ~= "none" then 
-- 			InverseSocket = HandHoldInfo.SocketA
-- 			print(_G.LogTag, "InverseSocket", InverseSocket)
-- 		end
-- 		if HandHoldInfo.SocketB ~= nil and HandHoldInfo.SocketB ~= ""  and HandHoldInfo.SocketB ~= "None" and HandHoldInfo.SocketB ~= "none" then 
-- 			AttachSocket = HandHoldInfo.SocketB
-- 			print(_G.LogTag, "AttachSocket", AttachSocket)
-- 		end
-- 	end
-- 	print(_G.LogTag, "BindWeaponToHand")
-- 	--  self.WeaponFashion:WeaponDisappear()
-- 	self:WeaponEffectCheck("Bind")
-- 	self:K2_AttachToComponent(self.Owner.Mesh, AttachSocket, UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.KeepWorld)
-- 	self:_InverseWeaponPosition(InverseSocket)
-- 	self:WeaponMoveToHand()
-- 	if self.WeaponFashion and self.WeaponFashion.WeaponMaterial then 
-- 		self.WeaponFashion.WeaponMaterial:SetScalarParameterValue("Dissolve_Pre", 1)
-- 	end
-- 	if self.ChildWeapon then
-- 		self.ChildWeapon:BindWeaponToHand()
-- 	end
-- 	for i = 1, self.Accessories:Length() do
-- 		if self.Accessories:GetRef(i) then 
-- 			self.Accessories:GetRef(i):WhenWeaponBindToHand()
-- 		end
-- 	end
-- end

-----------------------end  c++----------------------------------------------------
-- function BP_WeaponBase_C:BindWeaponToCreature(WeaponComponent, Creature, WeaponSocket)
-- 	if not self.InitSuccess then
-- 		return
-- 	end

-- 	self.WeaponMesh:SetCastInsetShadow(false)
-- 	self.BindToCreature = true
-- 	self.BindToHand = false
-- 	self:SetActorHideTag("Unbind", false)
-- 	if Creature[WeaponComponent] then
-- 		self:K2_AttachToComponent(Creature[WeaponComponent], "Root", UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.SnapToTarget, false)
-- 	else
-- 		self:K2_AttachToActor(Creature, "Root", UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.SnapToTarget, false)
-- 	end
-- 	Creature:SetBindWeapon(self)
-- 	self:SetActorHideTag('Weapon', false)
-- 	self:_InverseWeaponPosition(WeaponSocket)
-- end

-- function BP_WeaponBase_C:UnBindWeaponFromCreature(BindWeaponState)
-- 	if not self.InitSuccess then
-- 		return
-- 	end


-- 	self.BindToCreature = false
-- 	self.Overridden.UnBindWeaponFromCreature(self)
-- 	if BindWeaponState then
-- 		self:BindWeaponToHand()
-- 	else
-- 		self:UnBindWeaponFromHand(true, nil, self.Owner.CurrentSkillId == self.WeaponSkillId, true)
-- 	end
-- end

-- function BP_WeaponBase_C:UnBindWeaponFromHand(DontPlayDissolve, bFromInit, DontInverse, FromCreature)
-- 	if not self.InitSuccess then
-- 		return
-- 	end
-- 	if self.BindToCreature then
-- 		return
-- 	end
-- 	self.BindToHand = false
-- 	local UnbindHand = self.Data.WeaponSockets["UnbindHand"]
-- 	if self.ChildWeapon then
-- 		self.ChildWeapon:UnBindWeaponFromHand(DontPlayDissolve)
-- 	end
-- 	if not UnbindHand then
-- 		UnbindHand = {}
-- 		self:SetActorHideTag('Weapon', true)
-- 		UnbindHand["SocketB"] = "Root"
-- 		UnbindHand["SocketA"] = "Root"
-- 	end
-- 	local AttachSocket = UnbindHand["SocketB"]
-- 	local InverseSocket = UnbindHand["SocketA"]
	
-- 	self:WeaponOffHand()
-- 	if not DontPlayDissolve then 
-- 		self:WeaponMoveToBack()
-- 	end

-- 	self.FXComponent:StopAllGroupFX()
-- 	self:WeaponEffectCheck("Unbind", DontPlayDissolve)
-- 	local CompBindTo = self.Owner.Mesh
-- 	if self.Data.SpringArmParam ~= nil and (not self.Owner:IsPhantom()) then
-- 		CompBindTo = self.Owner:FindArmBySocketName(AttachSocket)
-- 		self:SetupArmParam(CompBindTo, self.Data.SpringArmParam)
-- 		AttachSocket = nil
-- 	end
-- 	local AttachRule = DontInverse and UE4.EAttachmentRule.KeepWorld or UE4.EAttachmentRule.SnapToTarget
-- 	self:K2_AttachToComponent(CompBindTo, AttachSocket, AttachRule, AttachRule, UE4.EAttachmentRule.KeepWorld)
-- 	if not DontInverse then
-- 		self:_InverseWeaponPosition(InverseSocket, FromCreature)
-- 	end
-- 	if self.Owner and self.Owner.ModelId then 
-- 		local ModelId =  self.Owner.ModelId
-- 		local ModelInfo = DataMgr.Model[ModelId]
-- 		local OffsetTrans = ModelInfo.UnbindSocketOffset
-- 		if OffsetTrans and #OffsetTrans == 3 then
-- 			OffsetTrans = FVector(OffsetTrans[1], OffsetTrans[2], OffsetTrans[3])
-- 			-- print(_G.LogTag, "OffsetTrans", OffsetTrans)
-- 			self:K2_AddActorWorldOffset(OffsetTrans, false, nil, false)
-- 		end
-- 	end
-- 	if not bFromInit and IsValid(self.Owner) then
-- 		self.Owner:ChangeWeaponHideStateWhenUnbind(self)
-- 	end
-- 	for i = 1, self.Accessories:Length() do
-- 		-- print('2222222222222222222222222222zjy',i, self.Accessories:GetRef(i), self.Owner:GetLocalRole())
-- 		if self.Accessories:GetRef(i) then 
-- 			self.Accessories:GetRef(i):WhenWeaponUnbindFromHand()
-- 		end
-- 	end
-- end

-- function BP_WeaponBase_C:SetupArmParam(ArmComp, SpringParam)
-- 	if not ArmComp then
-- 		return
-- 	end
-- 	for k, v in pairs(SpringParam) do 
-- 		ArmComp[k] = v 
-- 	end
-- end

-- function BP_WeaponBase_C:WeaponEffectCheck(WeaponAction, DontPlayDissolve)
-- 	local IsBindHand = WeaponAction == "Bind"
-- 	local IsUnBind = WeaponAction == "Unbind"
-- 	local OnwerInAmory = self.Owner.ArmoryTag ~= nil and self.Owner.ArmoryTag ~= false
-- 	if OnwerInAmory then 
-- 		DontPlayDissolve = true
-- 	end
-- 	if IsBindHand and OnwerInAmory and not self.LastWeaponTypeDiffrent then
-- 		self:Appear()
-- 	elseif self.LastWeaponTypeDiffrent and IsBindHand then
-- 		self:SetActorHideTag('Weapon', true)
-- 	end

-- 	if IsUnBind and not OnwerInAmory and not DontPlayDissolve then
-- 		self:Disappear()
-- 		self:Appear()
-- 	elseif IsUnBind and OnwerInAmory then 
-- 		self:Appear()
-- 	end
-- end


-- function BP_WeaponBase_C:PlayWeaponNewTypeIn(AttachSocket, InverseSocket)
-- 	self:SetActorHideTag('Weapon', false)
-- 	if not (AttachSocket == nil or AttachSocket == "" or AttachSocket == "None" or AttachSocket == "none") then 
-- 		self:BindWeaponToSocket(AttachSocket, InverseSocket)
-- 	end
-- 	self:Appear()
-- end

-- function BP_WeaponBase_C:BindWeaponToSocket(AttachSocket, InverseSocket)
-- 	self:K2_AttachToComponent(self.Owner.Mesh, AttachSocket, UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.KeepWorld)
-- 	self:_InverseWeaponPosition(InverseSocket)
-- end

-- function BP_WeaponBase_C:Disappear()
-- 	if (not IsStandAlone(self)) and (not MiscUtils.IsSimulatedProxy(self)) then 
-- 		return 
-- 	end 
-- 	self:WeaponDisappear()
-- 	self.FXComponent:PlayGroupFX("DisappearEffect", false, self.WeaponMesh, self.Owner.Mesh, "", "", nil, nil, Const.OneVector, "", false, nil, false, false, 0)
-- end

-- function BP_WeaponBase_C:Appear()
-- 	if (not IsStandAlone(self)) and (not MiscUtils.IsSimulatedProxy(self)) then 
-- 		return 
-- 	end 
-- 	self:WeaponAppear()
-- 	self.FXComponent:PlayGroupFX("AppearEffect", false, self.WeaponMesh, self.Owner.Mesh, "", "", nil, nil, Const.OneVector, "", false, nil, false, false, 0)
-- end

-- function BP_WeaponBase_C:GetWeaponType()
-- 	local WeaponTypes = CommonConst.WeaponTypes
-- 	local WeaponTagTable = self.WeaponTags:ToTable()
--     for i, v in pairs(WeaponTagTable) do
--     	if WeaponTypes[v] then 
-- 			return v
-- 		end
--     end
-- 	return "0"
-- end

-- function BP_WeaponBase_C:SetWeaponTypeChanged(Changed)
-- 	self.LastWeaponTypeDiffrent = Changed 
-- 	if self.ChildWeapon then 
-- 		self.ChildWeapon.LastWeaponTypeDiffrent = Changed
-- 	end
-- end

-- function BP_WeaponBase_C:ShouldHideWeapon(CheckIsUsingWeapon, ForceHide)
-- 	if not IsValid(self.Owner) then
-- 		self:SetActorHideTag('Weapon', true)
-- 		return
-- 	end

-- 	local Hide = false
-- 	local UnbindHand = self.Data.WeaponSockets["UnbindHand"]
-- 	local WeaponPos= self.Owner.WeaponPos
-- 	local IsUsingWeapon = self.Owner.UsingWeapon and self.Owner.UsingWeapon.WeaponId == self.WeaponId

-- 	if ForceHide then
-- 		Hide = true
-- 	elseif not UnbindHand and WeaponPos == Const.Shoulder then
-- 		Hide = true
-- 	elseif CheckIsUsingWeapon and IsUsingWeapon then
-- 		Hide = false
-- 	elseif self.bVisibleWhenUnbind ~= nil and not self.bVisibleWhenUnbind then
-- 		Hide = true
-- 	else
-- 		Hide = false
-- 	end
-- 	--TakeRecorder相关
-- 	if self.Owner.IsSpawnedByMovieCaptureSequence then
-- 		Hide = true
-- 	end

-- 	self:SetActorHideTag('Weapon', Hide)
-- 	print(_G.LogTag, "SetActorHideTag",Hide)

-- end

-- function BP_WeaponBase_C:SetWeaponForbid(bForbid, ForbidTag, bHideWhenForbid)
-- 	if bHideWhenForbid == nil then
-- 		bHideWhenForbid = true
-- 	end
-- 	if bForbid then
-- 		self.ForbidTag[ForbidTag] = 1
-- 	else 
-- 		self.ForbidTag[ForbidTag] = nil
-- 	end
-- 	if bHideWhenForbid then
-- 		self:SetActorHideTag( "Forbid_" .. ForbidTag, bForbid)
-- 	end
-- end

-- function BP_WeaponBase_C:IsWeaponForbid()
-- 	return CommonUtils.TableLength(self.ForbidTag) ~= 0
-- end

-- function BP_WeaponBase_C:WeaponAppear()
-- 	if self:CheckWeaponIsClient() then
-- 		self.Overridden.WeaponAppear(self)
-- 	end	
-- 	if UGameplayStatics.GetGameInstance(self).IsTakeRecorderCapturing then
-- 		local appearActor=self:GetWorld():SpawnActor(LoadClass('/Game/BluePrints/Scene/TakeRecorder/BP_TakeRecorder_WeaponAppear.BP_TakeRecorder_WeaponAppear_C'),nil, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn, nil, nil, nil)
-- 		appearActor:K2_AttachToActor(self,'',0,0,0,true)
-- 	end
-- end

function BP_WeaponBase_C:WeaponBright()
	if not self:CheckWeaponIsClient() then
		return 
	end
	self.Overridden.WeaponBright(self)
	if self.ChildWeapon then
		self.ChildWeapon:WeaponBright()
	end
end

function BP_WeaponBase_C:RemoveWeaponBright()
	if not self:CheckWeaponIsClient() then
		return 
	end
	self.Overridden.RemoveWeaponBright(self)
	if self.ChildWeapon then
		self.ChildWeapon:RemoveWeaponBright()
	end
end


-- function BP_WeaponBase_C:WeaponDisappear()
-- 	if self.bHidden then
-- 		return
-- 	end
-- 	if not self:CheckWeaponIsClient() then
-- 		return 
-- 	end
	
-- 	self.DissolveWeapon = self.WeaponFashion:WeaponDisappear()
-- 	self.Overridden.WeaponDisappear(self)
-- 	if self.ChildWeapon then
-- 		self.ChildWeapon:WeaponDisappear()
-- 	end
-- end

-- function BP_WeaponBase_C:WeaponMoveToHand()
-- 	if not self:CheckWeaponIsClient() then
-- 		return 
-- 	end
-- 	self.Overridden.WeaponMoveToHand(self)
-- 	if self.ChildWeapon then
-- 		self.ChildWeapon:WeaponMoveToHand()
-- 	end
-- end

-- function BP_WeaponBase_C:WeaponMoveToBack()
-- 	if not self:CheckWeaponIsClient() then
-- 		return 
-- 	end
-- 	self.Overridden.WeaponMoveToBack(self)
-- 	if self.ChildWeapon then
-- 		self.ChildWeapon:WeaponMoveToBack()
-- 	end
-- end


-- function BP_WeaponBase_C:CheckWeaponIsClient()
-- 	if not IsValid(self.Owner) then
-- 		return false
-- 	end
-- 	if IsStandAlone(self) then
-- 		return true
-- 	end
-- 	if MiscUtils.IsSimulatedProxy(self) then 
-- 		return true
-- 	end
-- 	return false 
-- end

-- Play Weapon Animation When Weapon unbind
-- function BP_WeaponBase_C:WeaponOffHand()
-- 	if self.bHidden then
-- 		return
-- 	end
-- 	self.Overridden.WeaponOffHand(self)
-- 	if self.ChildWeapon then
-- 		self.ChildWeapon:WeaponOffHand()
-- 	end
-- end

-- function BP_WeaponBase_C:WeaponAnim()
-- 	local ShouldPlay = not self.bHidden or (not self.HideTags:Contains("Weapon") and not self.HideTags:Contains("CacheFreeze"))
-- 	if not ShouldPlay then
-- 		return
-- 	end
-- 	self.WeaponMesh:SetComponentTickEnabled(true)
-- 	self.Overridden.WeaponAnim(self)
-- 	if self.ChildWeapon then
-- 		self.ChildWeapon:WeaponAnim()
-- 	end
-- end

-- function BP_WeaponBase_C:WeaponFall()
-- 	-- body
-- 	print("WeaponFall")
-- 	self:K2_DetachFromActor(UE4.EDetachmentRule.KeepWorld, UE4.EDetachmentRule.KeepWorld, UE4.EDetachmentRule.KeepWorld)
-- 	self.WeaponMesh:SetSimulatePhysics(true)
-- 	self.WeaponMesh:SetCollisionProfileName("Ragdoll")
-- 	self.WeaponMesh:SetComponentTickEnabled(true)
-- 	if self.ChildWeapon then
-- 		self.ChildWeapon:K2_DetachFromActor(UE4.EDetachmentRule.KeepWorld, UE4.EDetachmentRule.KeepWorld, UE4.EDetachmentRule.KeepWorld)
-- 		self.ChildWeapon.WeaponMesh:SetSimulatePhysics(true)
-- 		self.ChildWeapon.WeaponMesh:SetCollisionProfileName("Ragdoll")
-- 		self.ChildWeapon.WeaponMesh:SetComponentTickEnabled(true)
-- 	end
-- end

-- function BP_WeaponBase_C:GetWeaponTags()
-- 	local Types = TArray('')
-- 	if not self.Data then
-- 		return Types
-- 	end
-- 	for _, Tag in pairs(self.Data.WeaponTag) do
-- 		Types:Add(Tag)
-- 	end
--     return Types
-- end

-- function BP_WeaponBase_C:EnterIdleAnimation(AnimIndex)
-- 	AnimIndex = AnimIndex and AnimIndex + 1 or 1
-- 	print(_G.LogTag, "EnterIdleAnimation", AnimIndex)
-- 	if not self.WeaponMesh then return end
-- 	local ShouldPlay = not self.bHidden or (not self.HideTags:Contains("Weapon") and not self.HideTags:Contains("CacheFreeze"))
-- 	if not ShouldPlay then return end
-- 	if self.WeaponAnims:Length() == 0 or self.WeaponAnims:Length() < AnimIndex then return end
-- 	self.WeaponMesh:SetComponentTickEnabled(true)
-- 	self.WeaponMesh:PlayAnimation(self.WeaponAnims[AnimIndex], true)
-- 	if self.ChildWeapon then
-- 		self.ChildWeapon:EnterIdleAnimation()
-- 	end
-- end

function BP_WeaponBase_C:EnterIdleAnimationRepPlay_Implementation(AnimIndex)
	self:EnterIdleAnimation(AnimIndex)
end


-- function BP_WeaponBase_C:EnterIdleAnimationRepPlay_Implementation(AnimIndex)
-- 	self:EnterIdleAnimation(AnimIndex)
-- end


-----待定
-- function BP_WeaponBase_C:ShowDissolve(DissolveDuration)
-- 	-- body
-- 	-- self.WeaponFashion:ShowDissolve(DissolveDuration)
-- 	self:WeaponDissolve()
-- 	if self.ChildWeapon then
-- 		self.ChildWeapon:ShowDissolve(DissolveDuration)
-- 	end
-- end

-- function BP_WeaponBase_C:IsUnBind()
-- 	return not self.BindToCreature and not self.BindToHand
-- end

-- function BP_WeaponBase_C:SetWeaponState(State, Flag)
-- 	self.WeaponStates = self.WeaponStates or {}
-- 	self.WeaponStates[State] = Flag
-- end

-- function BP_WeaponBase_C:CheckWeaponState(State)
-- 	self.WeaponStates = self.WeaponStates or {}
-- 	return self.WeaponStates[State] or false
-- end
---------------------------------------------
function BP_WeaponBase_C:GetWeaponTypes()
	return CommonConst.WeaponTypes
end

function BP_WeaponBase_C:GetWeaponMeleeOrRanged()
	local WeaponTags = self:GetWeaponTags()
	if WeaponTags:Contains("Condemn") then
		return "Condemn"
	end
	if WeaponTags:Contains("Ultra") then
		return "Ultra"
	end
	if WeaponTags:Contains("Ranged") then
		return "Ranged"
	end
	return "Melee"
end

function BP_WeaponBase_C:GetHideDelayTimeOnMoveToBack()
	return 5
end

--#region 灵化武器
function BP_WeaponBase_C:IsHyperWeapon()
	return HyperWeaponUtils.IsHyperWeapon(self.WeaponId)
end

function BP_WeaponBase_C:IsHyperWeaponSkillActivated(HyperWeaponSkillId)
	if not self:IsHyperWeapon() then return false end
	local Avatar = GWorld:GetAvatar()
	local HyperWeaponUid = nil
	local _ServerMeleeWeapon = Avatar and Avatar.Weapons[Avatar.MeleeWeapon]
	if _ServerMeleeWeapon and _ServerMeleeWeapon.WeaponId == self.WeaponId then
		HyperWeaponUid = Avatar.MeleeWeapon
	else
		local _ServerRangedWeapon = Avatar and Avatar.Weapons[Avatar.RangedWeapon]
		if _ServerRangedWeapon and _ServerRangedWeapon.WeaponId == self.WeaponId then
			HyperWeaponUid = Avatar.RangedWeapon
		end
	end
	if not HyperWeaponUid then return false end
	return HyperWeaponUtils.IsHyperWeaponSkillActivated(HyperWeaponUid, HyperWeaponSkillId)
end
--#endregion

AssembleComponents(BP_WeaponBase_C)
return BP_WeaponBase_C
