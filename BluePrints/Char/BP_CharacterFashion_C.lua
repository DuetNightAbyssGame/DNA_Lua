--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
require "Utils"
local EMLuaConst = require "EMLuaConst"

---@type BP_CharacterFashion_C
local BP_CharacterFashion_C = Class({"BluePrints.Common.FashionComponent_C","BluePrints.Common.TimerMgr"})

-- function BP_CharacterFashion_C:Initialize(Initializer)
-- 	print("character fashion initialize")
-- 	--self.AllMaterials = {}
-- 	-- self.BodyIndex = nil
-- 	-- self.InDither = false
-- end

-- function BP_CharacterFashion_C:ClearAllMaterials()
-- 	--self.AllMaterials = {}
-- 	self.AllMaterials:Clear()
-- end

-- function BP_CharacterFashion_C:CreateAllDynamicMaterial(InMesh)
-- 	--self.AllMaterials = {}
-- 	self:FindMaterialSlotName(InMesh)
-- 	local Mesh = InMesh or self:GetMeshComponent()	
-- 	local MaterialSlotNames = Mesh:GetMaterialSlotNames()
-- 	for i=1,MaterialSlotNames:Length() do
-- 		--self.AllMaterials[i] = Mesh:CreateDynamicMaterialInstance(i - 1)
-- 		local DMMI = Mesh:CreateDynamicMaterialInstance(i - 1)
-- 		self.AllMaterials:Add(DMMI)
-- 		self.CharacterMaterials:Add(DMMI)
-- 	end
-- 	if self.FaceIndex >= 0 then		
-- 		--self.FaceMaterial = self.AllMaterials[self.FaceIndex+1]
-- 		self.FaceMaterial = self.AllMaterials:GetRef(self.FaceIndex + 1)
-- 		local Owner = self:GetOwner()
-- 		local HairCapture = Owner.HairCapture
-- 		if HairCapture then
-- 			HairCapture.PrimitiveRenderMode = ESceneCapturePrimitiveRenderMode.PRM_UseShowOnlyList
-- 			HairCapture:ClearShowOnlyComponents()
-- 			HairCapture:ShowOnlyComponent(Mesh)
-- 			local RenderTarget = UKismetRenderingLibrary.CreateRenderTarget2D(self, 256, 256, ETextureRenderTargetFormat.RTF_R32f)
-- 			HairCapture.TextureTarget = RenderTarget
-- 			if self.FaceMaterial then 
-- 				self.FaceMaterial:SetTextureParameterValue("HairDepth", RenderTarget)
-- 			end
-- 		end
-- 	end
-- 	if self.BodyIndex then
-- 		self.BodyMaterial = self.AllMaterials:GetRef(self.BodyIndex + 1)
-- 	end
-- 	self:HideHairCapture()
-- end
-- function BP_CharacterFashion_C:AddDynamicMaterial(Mesh)
-- 	-- body
-- 	local MaterialSlotNames = Mesh:GetMaterialSlotNames()
-- 	for i=1,MaterialSlotNames:Length() do
-- 		--self.AllMaterials[#self.AllMaterials+1] = Mesh:CreateDynamicMaterialInstance(i - 1)
-- 		self.AllMaterials:Add(Mesh:CreateDynamicMaterialInstance(i - 1))
-- 	end
-- end
-- function BP_CharacterFashion_C:HideHairCapture()
-- 	local Owner = self:GetOwner()
-- 	local HairCapture = Owner.HairCapture
-- 	if HairCapture then
-- 		HairCapture:ClearShowOnlyComponents()
-- 		HairCapture.TextureTarget = nil
-- 	end
-- end

--function BP_CharacterFashion_C:ReceiveEndPlay()
--end

-- function BP_CharacterFashion_C:FindMaterialSlotName(InMesh)
-- 	-- body
-- 	local Mesh = InMesh or self:GetMeshComponent()	
-- 	local MaterialSlotNames = Mesh:GetMaterialSlotNames()
-- 	-- MiscUtils.PrintArray(MaterialSlotNames)
-- 	for i=1,MaterialSlotNames:Length() do
-- 		local Name = MaterialSlotNames:GetRef(i)
-- 		if string.find(Name, "[Ff]ace") then
-- 			self.FaceIndex = i - 1
-- 			break
-- 		end
-- 	end

-- 	for i=1,MaterialSlotNames:Length() do
-- 		local Name = MaterialSlotNames:GetRef(i)
-- 		print("FindMaterialSlotName", Name)
-- 		if string.find(Name, "_[Bb]ody") then
-- 			self.BodyIndex = i - 1
-- 			break
-- 		end
-- 	end
-- 	print("FindMaterialSlotName", self.FaceIndex, self.BodyIndex)
-- end

-- function BP_CharacterFashion_C:OnDitherAlphaChanged()
-- 	if self.AllMaterials:Length() > 0 then
-- 		local Owner = self:GetOwner()
-- 		if Owner.DitherDisabled then
-- 			if self.InDither then
-- 				UProfiles.SetHairOutlineEnabled(true)

-- 				self.InDither = false
					
-- 				self:SetDitherAlpha(0.0, 1.0)
-- 			end
-- 		else
-- 			local DitherAlpha = self.DitherAlpha
-- 			if DitherAlpha > 0.0 then
-- 				if not self.InDither then
-- 					UProfiles.SetHairOutlineEnabled(false)
-- 				end
-- 				self.InDither = true
-- 				-- print("DitherAlpha", DitherAlpha)
-- 				self:SetDitherAlpha(DitherAlpha, 0.0)
-- 			else
-- 				if self.InDither then
-- 					UProfiles.SetHairOutlineEnabled(true)
-- 					self.InDither = false
-- 					self:SetDitherAlpha(0.0, 1.0)

-- 				end
-- 			end
-- 			if Owner.SocketPartsMap then
-- 				for k, v in pairs(Owner.SocketPartsMap) do
-- 					v:OnDitherAlphaChanged(DitherAlpha)
-- 				end
-- 			end
-- 			if Owner.IsBoss then
-- 				local Actors = Owner:GetAttachedActors()
-- 				for _,Target in pairs(Actors) do
-- 					if IsValid(Target) and Target.BillboardComponent then
-- 						Target.BillboardComponent:ShowOrHideBloodBar(DitherAlpha == 0)
-- 					end
-- 				end
-- 			end

-- 		end
-- 	end

-- 	return true
-- end

-- function BP_CharacterFashion_C:SetDitherAlpha(DitherAlpha, OP)  
-- 	-- body
-- 	--for k, v in pairs(self.AllMaterials) do
-- 	for i = 1, self.AllMaterials:Length() do
-- 		local v = self.AllMaterials:GetRef(i)
-- 		if IsValid(v) then
-- 			v:SetScalarParameterValue("DitherAlpha", DitherAlpha)
-- 			if v.NextPass then
-- 				v.NextPass:SetScalarParameterValue("DitherAlpha", DitherAlpha)
-- 				if not self.bDissolving then
-- 					v.NextPass:SetScalarParameterValue("OP", OP)
-- 				end
-- 			end
-- 		end
-- 	end

-- 	local Owner = self:GetOwner()
-- 	if Owner.SuitItemDitherAlpha then
-- 		Owner:SuitItemDitherAlpha(DitherAlpha, OP)
-- 	end

-- 	if Owner.ExpressionPlane then
-- 		Owner.ExpressionPlane:SetScalarParameterValueOnMaterials("DitherAlpha", DitherAlpha)
-- 	end
	
--  if Owner.Horn_R then
--  	Owner.Horn_R:SetScalarParameterValueOnMaterials("DitherAlpha", DitherAlpha)
--  end

-- if Owner.Horn_L then
--  	Owner.Horn_L:SetScalarParameterValueOnMaterials("DitherAlpha", DitherAlpha)
--  end

-- 	-- Actors
-- 	local Owner = self:GetOwner()
-- 	local Actors = Owner:GetAttachedActors()
-- 	for i=1, Actors:Length() do
-- 		local Actor = Actors:GetRef(i)
-- 		if Actor.WeaponFashion then
-- 			Actor.WeaponFashion:SetDitherAlpha(DitherAlpha, OP)
-- 		elseif Actor.ItemMesh then
-- 			Actor.ItemMesh:SetScalarParameterValueOnMaterials("DitherAlpha", DitherAlpha)
-- 			URuntimeCommonFunctionLibrary.SetScalarPamaterValueOnNextPassMaterials(Actor.ItemMesh, "OP", OP)
-- 		elseif Actor.SetDitherAlpha then
-- 			Actor:SetDitherAlpha(DitherAlpha, OP)
-- 		end
-- 	end
-- end

function BP_CharacterFashion_C:EnableDrawMaterialCharacterRim(bEnabled)	
	--for _, v in pairs(self.AllMaterials) do
	for i = 1, self.AllMaterials:Length() do
		local v = self.AllMaterials:GetRef(i)
		if IsValid(v) then
			if bEnabled then
				v:SetScalarParameterValue("RimIntensity", 1.0)
			else
				v:SetScalarParameterValue("RimIntensity", 0.0)
			end
		end
	end
end
-- function BP_CharacterFashion_C:SetOverrideMaterialParam()
--     print(_G.LogTag, "BP_CharacterFashion_C:SetOverrideMaterialParam")
--     local Owner = self:GetOwner()

--     if not Owner then 
--         return 
--     end
--     local ModelInfo = DataMgr.Model[Owner.ModelId]
--     if not ModelInfo then
--         return
--     end
--     local MaterialParams = ModelInfo.OverrideMaterialParam
--     if not MaterialParams then
--         return
--     end
--     PrintTable({MaterialParams = MaterialParams}, 3)
--     local PramTable = {}
--     PramTable.Emissive = Const.ZeroVector
--     if MaterialParams.Emissive then
--         PramTable.Emissive = FVector(MaterialParams.Emissive[1], MaterialParams.Emissive[2], MaterialParams.Emissive[3])
--     end
--     PramTable.CutsOpacity = MaterialParams.CutsOpacity
--     self:SetSkinMaterialParam(Owner, PramTable.Emissive,PramTable.CutsOpacity)
-- end
function BP_CharacterFashion_C:ShowDamage()	
	if self.AllMaterials:Length() > 0 then
		--for k, v in pairs(self.AllMaterials) do
		for i = 1, self.AllMaterials:Length() do
			local v = self.AllMaterials:GetRef(i)
			if IsValid(v) then
				v:SetScalarParameterValue("StartTime_BeAttacked", UE4.UGameplayStatics.GetTimeSeconds(self))
			end
		end
	end
end

function BP_CharacterFashion_C:ShowDissolve(DissolveDuration)
	--for _, v in pairs(self.AllMaterials) do
	for i = 1, self.AllMaterials:Length() do
		local v = self.AllMaterials:GetRef(i)
		if IsValid(v) then
			v:SetScalarParameterValue("StartTime_Dissolve", UE4.UGameplayStatics.GetTimeSeconds(self))
			v:SetScalarParameterValue("Duration_Dissolve", DissolveDuration)
			v.NextPass = nil
		end
	end
end

-- function BP_CharacterFashion_C:GetEffectColor()
	-- body
	-- if self.BodyMaterial then
		-- return self.BodyMaterial:K2_GetVectorParameterValue("EffectColor")
	-- end
	-- return FLinearColor(0, 0, 0, 0)
-- end

-- function BP_CharacterFashion_C:GetDefaultCharacterNextPass_Lua()
--     local DefaultParams = Const.BuffDefaultNextPassParams
--     local Ret = FCharacterNextPassParams()
--     Ret.NextPassShowyColor = FLinearColor(DefaultParams.NextPassShowyColor[1], DefaultParams.NextPassShowyColor[2], DefaultParams.NextPassShowyColor[3], DefaultParams.NextPassShowyColor[4])
--     Ret.NextPassShowy = DefaultParams.NextPassShowy.Default
--     Ret.NextPassShowyWidth = DefaultParams.NextPassShowyWidth.Default
--     Ret.NextPassShowyPriority = -999
--     Ret.Duration = 0.5
--     Ret.MaxDuration = 0.5
-- 	Ret.bDefault = true
--     return Ret
-- end

function BP_CharacterFashion_C:GetPartMesh(PartName)
	local Owner = self:GetOwner()
	if(PartName == "Horn")then
		local Result = TArray(USkeletalMeshComponent)
		Result:Add(Owner.Mesh)
		return Result
	end
	if(Owner.SuitMeshComponentsMap)then
		return Owner.SuitMeshComponentsMap:FindRef(PartName)
	end
end

function BP_CharacterFashion_C:ColletctPartMeshIds(AppearanceSuitInfo, PartMeshIds)
    if(not AppearanceSuitInfo)then
        return
    end
    local AccessorySuit = AppearanceSuitInfo.AccessorySuit or {}
    local PartMeshAccessoryId,_ = self:GetOwnerPartMeshInfo(AppearanceSuitInfo.SkinId)
    table.insert(PartMeshIds,PartMeshAccessoryId)
    for _, AccessoryTypeIdx in pairs(CommonConst.NewCharAccessoryTypes) do
        local AccessoryId = AccessorySuit[AccessoryTypeIdx] 
        if(AccessoryId and AccessoryId ~= PartMeshAccessoryId) then 
            table.insert(PartMeshIds,AccessoryId)
        end
    end
end

local CreateAccessoryHideTags = function(self)
    rawset(self,"AccessoryHideTags",{})
    for AccessoryType, AccessoryTypeIdx in pairs(CommonConst.NewCharAccessoryTypes) do
        self.AccessoryHideTags[AccessoryType] = {}
    end
end

local AddAccessoryHideTag = function(self,AccessoryType,Tag)
    self.AccessoryHideTags[AccessoryType][Tag] = true
end

local RemoveAccessoryHideTag = function(self,AccessoryType,Tag)
    self.AccessoryHideTags[AccessoryType][Tag] = nil
end

local IsAccessoryHiddenByAnyTag = function(self,AccessoryType)
    return self.AccessoryHideTags[AccessoryType] and not not next(self.AccessoryHideTags[AccessoryType])
end

function BP_CharacterFashion_C:InitAppearanceSuit(Info)
    print(_G.LogTag, "BP_CharacterFashion_C:InitAppearanceSuit")
    rawset(self,"AppearanceSuitInfo",Info)
    rawset(self,"Type2Id",rawget(self,"Type2Id") or TMap(FName,0))
    self:InitWeaponColor(Info.Colors)
    self.InitPartIds = {}
    self.InitWithCombinePart = false
    self.SkinLevel = Info.SkinLevel
    CreateAccessoryHideTags(self)
	local Owner = self:GetOwner()
	if not Owner then
		return
	end
	if not Info then
        self:ChangeAccessoryWithDefautl()
        Owner:InitPartMeshCompWithDefault()
		return
	end
    self.Type2PartId = nil
    self.InitWithCombinePart = true
    print(_G.LogTag, "BP_CharacterFashion_C:InitAppearanceSuit Show Cloak", Info.IsShowPartMesh)
    if(EMLuaConst.ShouldCombinePartMesh)then
        self.InitWithCombinePart = true
        print(_G.LogTag, "BP_CharacterFashion_C:InitAppearanceSuit combine", self.InitWithCombinePart, Owner.FromArmory)
    end
    --皮肤
    self:ChangeCharSkin(Info.SkinId)
    local DefaultFacePart = Owner.DefaultCharPartId:Find("Body")

    if(self.InitWithCombinePart) then 
        table.insert(self.InitPartIds,DefaultFacePart)
    else
        Owner:SetPartMesh(DefaultFacePart, true)
    end
    --发型
    self:CheckShouldHideHair(Info.AccessorySuit)
    self:ChangeCharHair(Info.HairId)
    print(_G.LogTag, "BP_CharacterFashion_C:InitAppearanceSuit hair", Info.HairId, #self.InitPartIds)
    --配饰
	local AccessorySuit = Info.AccessorySuit or self:GetDefaultAccessorySuit()
    local AccessoryCustomParams = Info.AccessoryCustomParams or {}
    for i, v in pairs(Owner.DefaultCharPartId) do
        print(_G.LogTag, "BP_CharacterFashion_C:InitAppearanceSuit part", v, i)
    end
    for AccessoryType, AccessoryTypeIdx in pairs(CommonConst.NewCharAccessoryTypes) do
        local AccessoryId = AccessorySuit[AccessoryTypeIdx]
        local Transform = CommonUtils.UnSerializeAccessoryCustomParams(AccessoryCustomParams[AccessoryId],AccessoryType)
        self:ChangeAccessory(AccessoryId,AccessoryType,Transform)
        local InValidAccId = not AccessoryId
        if(InValidAccId and not IsAccessoryHiddenByAnyTag(self,AccessoryType))then
            if(self.InitWithCombinePart)then 
                -- local DefaultPartId = Owner.DefaultCharPartId:Find(AccessoryType)
                -- if(DefaultPartId) then 
                --     table.insert(self.InitPartIds,DefaultPartId)
                -- end
            else
                Owner:RecoverDefaultPartMesh(AccessoryType)
            end
        end
        print(_G.LogTag, "BP_CharacterFashion_C:InitAppearanceSuit acc", AccessoryId, AccessoryType)
    end
    if(Owner) and self.InitWithCombinePart then 
        
        if(#self.InitPartIds > 0) then 
            Owner:InitPartMeshComp(self.InitPartIds)
        end
        self.InitWithCombinePart = false
        -- Owner:InitPartMeshComp()
    end
    --皮肤染色
    local Colors = Info.Colors
    if Owner.FromArmory then
        self:RefreshUncoloredSkinColors(Colors)
    else
        self:InitSkinColors(Colors)
    end
    --发型染色
    self:InitHairColors(Info.HairColors)

    if(Owner.InfoForInit)then
        self:GradeUpEmissive(Owner.InfoForInit.GradeLevel)
    end
    -- self:RecordPartTypeAndId()
end
function BP_CharacterFashion_C:RecordPartTypeAndId()
    self.Type2PartId = {}
    for i, v in pairs(self.InitPartIds)do
        local PartData = DataMgr.CharPartModel[v]
        if(PartData)then
            local PartType = PartData.PartType
            if(PartType and not self.Type2PartId[PartType])then
                self.Type2PartId[PartType] = v
            end
        end
    end
end

function BP_CharacterFashion_C:ChangeCharSkin(SkinId)
    local Owner = self:GetOwner()
	if not Owner then
		return
	end
    if(Owner.ChangeSkinModel)then
        Owner:ChangeSkinModel(SkinId)
    end
    self:RemoveAllSkinLevelUpVisEffect()
    self:RemoveAllSkinLevelUpEffectCreature()
    self:CreateSkinLevelUpEffect(SkinId)
end

function BP_CharacterFashion_C:StopCreateEffectTimer(ForceRemove)
    local Owner = self:GetOwner()
    if not ForceRemove and Owner.FromArmory then
        return
    end
    self:RemoveTimer("FirstCreateEffect")
    self:RemoveTimer("SecondCreateEffect")
end

function BP_CharacterFashion_C:SetTimerForCreateEffectOnSkillLevelUp(SkinId)
    local Owner = self:GetOwner()
    local SkinConfig = DataMgr.Skin[SkinId]
    if not SkinConfig or not SkinConfig.TimerInterval then
        return
    end
    if not self.NotAlwaysVisualEffect and not self.NotAlwaysEffectCreature then
        return
    end
    self:StopCreateEffectTimer(true)
    local TimerInterval = SkinConfig.TimerInterval
    local FirstTime = Owner.FromArmory and TimerInterval[1] or TimerInterval[2]
    if FirstTime then
        Owner:AddTimer(FirstTime, function()
            local NotAlwaysVisualEffect = self.NotAlwaysVisualEffect or {}
            for Id, Data in pairs(NotAlwaysVisualEffect) do
                local T = Owner.FXComponent:PlayEffectByIDParams(Id, {
                    NotAttached = not Data.IsAttach
                })
            end
            local NotAlwaysEffectCreature = self.NotAlwaysEffectCreature or {}
            for Id, Data in pairs(NotAlwaysEffectCreature) do
                Owner:AsyncCreateEffectCreature(Id, FTransform(), not not Data.IsAttach, "")
            end
        end, false, 0, "FirstCreateEffect", Owner.FromArmory)
    end
    local SecondTime = TimerInterval[3]
    if SecondTime and not Owner.FromArmory then
        Owner:AddTimer(SecondTime, function()
            local NotAlwaysVisualEffect = self.NotAlwaysVisualEffect or {}
            for Id, Data in pairs(NotAlwaysVisualEffect) do
                Owner.FXComponent:PlayEffectByIDParams(Id, {
                    NotAttached = not Data.IsAttach
                })
            end
            local NotAlwaysEffectCreature = self.NotAlwaysEffectCreature or {}
            for Id, Data in pairs(NotAlwaysEffectCreature) do
                Owner:AsyncCreateEffectCreature(Id, FTransform(), not not Data.IsAttach, "")
            end
        end, true, 0, "SecondCreateEffect", Owner.FromArmory)
    end
end

function BP_CharacterFashion_C:CreateSkinLevelUpEffect(SkinId)
    local Owner = self:GetOwner()
    self.NotAlwaysVisualEffect = self:CreateSkinLevelUpVisualEffect(SkinId)
    self.NotAlwaysEffectCreature = self:CreateSkinLevelUpEffectCreature(SkinId)
    local CharacterTag = Owner:GetCharacterTag()
    if Owner.FromArmory or CharacterTag == "Idle" then
        self:SetTimerForCreateEffectOnSkillLevelUp(SkinId)
    end
end

function BP_CharacterFashion_C:IsContainsLevel(Levels)
    if not Levels then
        return
    end
    if type(Levels) == "number" then
        return Levels == self.SkinLevel
    end
    for i = 1, #Levels do
        if Levels[i] == self.SkinLevel then
            return true
        end
    end
end

function BP_CharacterFashion_C:RemoveAllSkinLevelUpVisEffect()
    if not self.LevelUpVisualEffects or #self.LevelUpVisualEffects == 0 then
        return
    end
    local Owner = self:GetOwner()
    for i, v in ipairs(self.LevelUpVisualEffects) do
        Owner.FXComponent:StopEffectByID(v, true)
    end
end

function BP_CharacterFashion_C:RemoveAllSkinLevelUpEffectCreature()
    if not self.LevelUpEffectCreatures or #self.LevelUpEffectCreatures == 0 then
        return
    end
    local Owner = self:GetOwner()
    for i, v in ipairs(self.LevelUpEffectCreatures) do
        Owner:RemoveEffectCreature(v)
    end
end

function BP_CharacterFashion_C:CreateSkinLevelUpVisualEffect(SkinId)
    local SkinConfig = DataMgr.Skin[SkinId]
    if not SkinConfig or not SkinConfig.LevelUpVisualEffects then
        return {}
    end
    local NotAlwaysVisualEffect = {}
    local Owner = self:GetOwner()
    local LevelUpVisualEffects = SkinConfig.LevelUpVisualEffects
    self.LevelUpVisualEffects = {}
    for VisualEffectId, LevelUpVisualEffect in pairs(LevelUpVisualEffects) do
        if self:IsContainsLevel(LevelUpVisualEffect.Level) then
            if LevelUpVisualEffect.IsAlways then
                local FxObject = Owner.FXComponent:PlayEffectByIDParams(VisualEffectId, {
                    NotAttached = not LevelUpVisualEffect.IsAttach
                })
                if FxObject then
                    self.NiagaraGroup1:Add(VisualEffectId, FxObject)
                end
            else
                NotAlwaysVisualEffect[VisualEffectId] = LevelUpVisualEffect
            end
            table.insert(self.LevelUpVisualEffects, VisualEffectId)
        end
    end
    return NotAlwaysVisualEffect
end

function BP_CharacterFashion_C:CreateSkinLevelUpEffectCreature(SkinId)
    local SkinConfig = DataMgr.Skin[SkinId]
    if not SkinConfig or not SkinConfig.LevelUpEffectCreatures then
        return {}
    end
    local NotAlwaysEffectCreature = {}
    local Owner = self:GetOwner()
    local LevelUpEffectCreatures = SkinConfig.LevelUpEffectCreatures
    self.LevelUpEffectCreatures = {}
    for EffectCreatureId, LevelUpEffectCreature in pairs(LevelUpEffectCreatures) do
        if self:IsContainsLevel(LevelUpEffectCreature.Level) then
            if LevelUpEffectCreature.IsAlways then
                Owner:AsyncCreateEffectCreatureWithCallBack(EffectCreatureId, FTransform(), not not LevelUpEffectCreature.IsAttach, "",
                        {self, function(_, Creature)
                            Creature:OnSkinLevelUp()
                        end
                        })
            else
                NotAlwaysEffectCreature[EffectCreatureId] = LevelUpEffectCreature
            end
            table.insert(self.LevelUpEffectCreatures, EffectCreatureId)
        end
    end
    return NotAlwaysEffectCreature
end

local GetCharPartIdByAccessoryId = function(AccessoryId)
    local Data = DataMgr.CharAccessory[AccessoryId]
    local CharPartId = Data and Data.CharPartId
    if(not CharPartId)then
        local CharPartMeshData = DataMgr.CharPartMesh[AccessoryId]
        CharPartId = CharPartMeshData and CharPartMeshData.CharPartId
    end
    return CharPartId
end

function BP_CharacterFashion_C:CheckShouldHideHair(AccessorySuit)
    rawset(self,"HideHiarByAccessory",{})
    if(not AccessorySuit)then
        return
    end
    for AccessoryTypeIdx, AccessoryId in pairs(AccessorySuit) do
        local Data = DataMgr.CharAccessory[AccessoryId]
        if(Data and Data.IsTail)then
            self.HideHiarByAccessory[AccessoryTypeIdx] = true
            break
        end
    end
end

function BP_CharacterFashion_C:IsHideHiarByAccessory(AccessoryType)
    if(not CommonConst.NewCharAccessoryTypes[AccessoryType])then
        return
    end
    return self.HideHiarByAccessory[CommonConst.NewCharAccessoryTypes[AccessoryType]]
end

function BP_CharacterFashion_C:IsHideHiarByAnyAccessory()
    return not not next(self.HideHiarByAccessory)
end

function BP_CharacterFashion_C:SetHideHiarByAccessory(AccessoryType,bHide)
    if(not CommonConst.NewCharAccessoryTypes[AccessoryType])then
        return
    end
    if(bHide)then
        self.HideHiarByAccessory[CommonConst.NewCharAccessoryTypes[AccessoryType]] = true
    else
        self.HideHiarByAccessory[CommonConst.NewCharAccessoryTypes[AccessoryType]] = nil
    end
end

function BP_CharacterFashion_C:RecoverHairMesh()
    -- if(self.InitWithCombinePart)then
    --     return
    -- end
    local Owner = self:GetOwner()
	if not Owner then
		return
	end
    local HairType = CommonConst.DataType.Hair
    local HairData = DataMgr.Hair[rawget(self,"CurrentHairId")]
    Owner:DeactivatePartMeshComp(HairType)
    if(HairData)then
        if(HairData.LinkAccessory)then
            --头套当作配饰处理
            self:ChangeAccessory(HairData.LinkAccessory,HairType)
        elseif(HairData.CharPartId)then
            if(self.Type2PartId) then 
                self.Type2PartId[HairType] = HairData.CharPartId
                -- self:ReInitPartMesh()
            else
                Owner:SetPartMesh(HairData.CharPartId)
            end
        end
    elseif not self.InitWithCombinePart then
        Owner:RecoverDefaultPartMesh(HairType)
    end
    for PartIdx, value in pairs(self.RealHairPartColors or {}) do
        self:ChangeHairPartColor(PartIdx,value.Color,value.Fresnel)
    end
end

function BP_CharacterFashion_C:ChangeCharHair(HairId)
    RemoveAccessoryHideTag(self,CommonConst.CharAccessoryTypes.Hat,CommonConst.DataType.Hair)
    rawset(self,"CurrentHairId",HairId)
    local Owner = self:GetOwner()
	if not Owner then
		return
	end
    local HairType = CommonConst.DataType.Hair
    local DefaultHairId = Owner.DefaultCharPartId:Find(HairType)
    if((HairId == 2101 and Owner.CurrentSkinId == 210102)
     or (HairId == 5101 and Owner.CurrentSkinId == 510101)
     or (HairId == 5101 and Owner.CurrentSkinId == 51010010))then
        --丽贝卡、松露皮肤默认发型临时处理
        HairId = DefaultHairId
        rawset(self,"CurrentHairId",HairId)
    end
    local HairData = DataMgr.Hair[HairId]
    if(HairData and HairData.IsHideHat)then
        AddAccessoryHideTag(self,CommonConst.CharAccessoryTypes.Hat,CommonConst.DataType.Hair)
    end
    if(self.InitWithCombinePart)then
        Owner:DetachSuitItem(HairType)
        Owner:DeactivatePartMeshComp(HairType)
        if not HairData then
            if(not self:IsHideHiarByAnyAccessory())then
                if(self.Type2PartId) then 
                    self.Type2PartId[HairType] = DefaultHairId
                    self:ReInitPartMesh()
                    return
                end
                table.insert(self.InitPartIds, DefaultHairId)
            end
            return
        end
        if(self:IsHideHiarByAnyAccessory() and not HairData.IsHideHat)then
            --发型被隐藏
            if(self.Type2PartId) then 
                self.Type2PartId[HairType] = 0
                self:ReInitPartMesh()
            end
            return
        end
        local RealHairId = DefaultHairId
        local CharPartId
        if(HairData.LinkAccessory)then
            self:ChangeAccessory(HairData.LinkAccessory,HairType)
            return
        elseif(HairData.CharPartId)then
            RealHairId  = HairData.CharPartId
        end

        if(self.Type2PartId) then 
            self.Type2PartId[HairType] = RealHairId
            self:ReInitPartMesh()
            -- return
        elseif(RealHairId)then
            table.insert(self.InitPartIds, RealHairId)
        end
        Owner:DetachSuitItem(HairType)
        if(HairData.IsHideHat)then
            AddAccessoryHideTag(self,CommonConst.CharAccessoryTypes.Hat,CommonConst.DataType.Hair)
            self:ChangeAccessory(DataMgr.GlobalConstant.EmptyCharAccessoryID.ConstantValue,CommonConst.CharAccessoryTypes.Hat)
        end
        if(HairData.LinkAccessory)then
            --头套当作配饰处理
            self:ChangeAccessory(HairData.LinkAccessory,HairType)
            -- return
        end
    else
        Owner:DetachSuitItem(HairType)
        if not HairData then 
            if(self:IsHideHiarByAnyAccessory())then
                Owner:DeactivatePartMeshComp(HairType)
            else
                Owner:RecoverDefaultPartMesh(HairType)
            end
            return
        end
        
        Owner:DeactivatePartMeshComp(HairType)
        if(HairData.IsHideHat)then
            AddAccessoryHideTag(self,CommonConst.CharAccessoryTypes.Hat,CommonConst.DataType.Hair)
            self:ChangeAccessory(DataMgr.GlobalConstant.EmptyCharAccessoryID.ConstantValue,CommonConst.CharAccessoryTypes.Hat)
        end
        if(HairData.LinkAccessory)then
            --头套当作配饰处理
            self:ChangeAccessory(HairData.LinkAccessory,HairType)
            return
        end
        if(not self:IsHideHiarByAnyAccessory())then
            Owner:RecoverDefaultPartMesh(HairType)
            if(HairData.CharPartId)then
                Owner:SetPartMesh(HairData.CharPartId)
            end
        end
    end
end

function BP_CharacterFashion_C:ReInitPartMesh()
    print(_G.LogTag, "BP_CharacterFashion_C:ReInitPartMesh",self:IsHideHiarByAnyAccessory())
    local Owner = self:GetOwner()
	if not Owner then
		return
	end
    local ModelComp = Owner:GetCharModelComponent()
    if(not ModelComp)then
        return
    end
    local ModelId = ModelComp:GetCurrentModelId()
    local SkinId = Owner.CurrentSkinId
    local SkinData = DataMgr.Skin[SkinId]
    if(SkinData and SkinData.SkinModelId) then 
        ModelId = SkinData.SkinModelId
    end
    local ModelData = DataMgr.Model[ModelId]
    if(not ModelData)then
        return
    end
    local ModelPath = ModelData.SkeletonMeshPath
    if not ModelPath then
        return
    end
    if Owner.CurrentCompositeMesh then 
        Owner.CurrentCompositeMesh = nil
    end
    ModelComp:LoadFullModel(ModelPath)
    local CurrentPartIds = {}

    for i, v in pairs(self.Type2PartId) do
        print(_G.LogTag, "BP_CharacterFashion_C:InitAppearanceSuit part", v, i)

        table.insert(CurrentPartIds, v)
    end
    local OldFromArmory = Owner.FromArmory
    Owner.FromArmory = false
    Owner:InitPartMeshComp(CurrentPartIds)
    Owner.FromArmory = OldFromArmory
end

function BP_CharacterFashion_C:GetDefaultAccessorySuit()
    local Owner = self:GetOwner()
    if not Owner then
        return {}
    end
    if not IsStandAlone(Owner) then 
        return {}
    end
    local DefaultAccessorySuit = {}
    for AccessoryType, AccessoryId in pairs(Const.DeafaultCharAccessoryTypes) do
        local AccessoryTypeIdx = CommonConst.NewCharAccessoryTypes[AccessoryType]
        DefaultAccessorySuit[AccessoryTypeIdx] = AccessoryId
    end
    return DefaultAccessorySuit
end
function BP_CharacterFashion_C:ChangeAccessoryWithDefautl()
    local Avatar = GWorld:GetAvatar()
    if Avatar then 
        return
    end
    local Owner = self:GetOwner()
    if not Owner then
        return
    end
    if not IsStandAlone(Owner) then 
        return
    end
    self.InitWithCombinePart = true
    for AccessoryType, AccessoryTypeIdx in pairs(Const.DeafaultCharAccessoryTypes) do
        local AccessoryId = -1
        self:ChangeAccessory(AccessoryId,AccessoryType)
    end
end

function BP_CharacterFashion_C:InitWeaponColor(Colors)
    local SwatchData = DataMgr.Swatch
    local ColorData = nil
    self.WeaponColor = nil
    local Color = FLinearColor()
    if Colors then
        ColorData = SwatchData[Colors[#Colors]]
        if(ColorData)then
            self.bHasWeaponColor = true
            if(ColorData.ActualR and ColorData.ActualG and ColorData.ActualB)then
                Color = FLinearColor(ColorData.ActualR,ColorData.ActualG,ColorData.ActualB)
                self.WeaponColor = Color
            elseif(ColorData.ColorNumber)then
                UKismetMathLibrary.LinearColor_SetFromSRGB(Color,
                    FColor(ColorData.ColorNumber[1] or 0,ColorData.ColorNumber[2] or 0,ColorData.ColorNumber[3] or 0))
                self.WeaponColor = Color
            end
        else
            self.bHasWeaponColor = false
        end
    end
end

function BP_CharacterFashion_C:InitColorsWithInfo()
    if not self.AppearanceSuitInfo then
        return
    end
    local Colors = self.AppearanceSuitInfo.Colors
    if Colors and #Colors > 0 then
        self:InitSkinColors(Colors)
        return
    end
    local Owner = self:GetOwner()
    if not Owner then
        return
    end
    -- 说明：此入口仅在军械库且非原皮时会补默认色；其他情况不做默认色刷新。
    self:RefreshUncoloredSkinColors(nil)
end

local GetMeshNameBySkinId = function(SkinId)
    local SkinData = DataMgr.Skin[SkinId]
    if(SkinData == nil)then return end
    local ModelData = DataMgr.Model[SkinData.SkinModelId]
    if(ModelData == nil or ModelData.PartModelsId == nil)then return end
    for _, value in pairs(ModelData.PartModelsId) do
        local CharPartModelData = DataMgr.CharPartModel[value]
        if(CharPartModelData and CharPartModelData.PartType == "Body")then
            local PartPath = CharPartModelData.PartPath or ""
            local Res = string.split(PartPath,".")
            local MeshName = Res[#Res] or ""
            local Len = #MeshName
            local LastChar = string.sub(MeshName, Len, Len)
            if(LastChar == "'")then
                MeshName = string.sub(MeshName, 1, Len - 1)
            end
            return MeshName
        end
    end
end

-- 仅刷新未染色部位的默认染色
-- 参数说明：
-- Owner：角色对象，用于读取默认染色数据表
-- Colors：当前染色数组；其中值为 -1 的部位视为“未染色”，按默认色刷新
-- 行为说明：
-- - 若 Colors 有效：先应用已有颜色，再仅对值为 -1 的部位从数据表取默认色并刷新
 -- - 若 Colors 无效或为空：整套应用默认染色
-- - 第 8 部位支持 Fresnel，取默认色返回的最后一个数值作为 Fresnel8
-- 默认染色刷新（含入口条件判断）
-- 行为概述：
-- 1) 若 Colors 有效：先应用 Colors（按部位染色）
-- 2) 仅当满足【军械库场景】且【当前皮肤不是角色默认皮】时：
--    - 对未染色部位（值为 -1 或缺失）按数据表默认色补齐
--    - 若 Colors 为空，则整套应用默认色
function BP_CharacterFashion_C:RefreshUncoloredSkinColors(Colors)
    local _Owner = self:GetOwner()
    if not _Owner then
        return
    end
    local hasColors = Colors and #Colors > 0
    if hasColors then
        self:InitSkinColors(Colors)
    end
    -- 原皮判定：通过当前 SkinId 查角色默认皮 DefaultSkinId；不成功时回退当前角色ID
    -- 仅军械库且非原皮时才继续做默认色补齐
    local SkinId = self.AppearanceSuitInfo and self.AppearanceSuitInfo.SkinId
    local DefaultSkinId = self:GetDefaultSkinId(_Owner, SkinId)
    local IsOriginalSkin = (DefaultSkinId and SkinId == DefaultSkinId)
    if not (_Owner.FromArmory and not IsOriginalSkin) then
        return
    end
    local DefaultColors = { self:GetCharDefaultColorsFromDataTable(GetMeshNameBySkinId(SkinId)) }
    if not DefaultColors or #DefaultColors == 0 then
        return
    end
    local PartCount = (DataMgr.GlobalConstant and DataMgr.GlobalConstant.CharColorPart and DataMgr.GlobalConstant.CharColorPart.ConstantValue) or #DefaultColors
    local LastVal = DefaultColors[#DefaultColors]
    local Fresnel8 = type(LastVal) == "number" and LastVal or nil
    for i = 1, PartCount do
        if not hasColors or Colors[i] == -1 or Colors[i] == nil then
            local Color = DefaultColors[i]
            if Color then
                local Fresnel = (i == 8) and Fresnel8 or nil
                self:ChangePartColor(i, Color, Fresnel)
            end
        end
    end
end

local IsPartSupportDyeing = function(PartIdx,ColorId)
    local DyePartData = DataMgr.DyePart[PartIdx] or {}
    if(not DyePartData.ColorID)then
        return true
    end
    for key, value in pairs(DyePartData.ColorID) do
        if(value == ColorId)then
            return true
        end
    end
    return false
end

function BP_CharacterFashion_C:InitSkinColors(Colors)
    if(not Colors)then
        return
    end
    -- print(_G.LogTag, "BP_CharacterFashion_C:InitSkinColors",#Colors)
    local SwatchData = DataMgr.Swatch
    local Color = FLinearColor()
    for i = 1, #Colors - 1 do
        local ColorId = Colors[i]
        local PartIdx = i
        local ColorData = SwatchData[ColorId]
        if(ColorData and IsPartSupportDyeing(i,ColorId))then
            if(ColorData.ActualR and ColorData.ActualG and ColorData.ActualB)then
                Color = FLinearColor(ColorData.ActualR,ColorData.ActualG,ColorData.ActualB)
                -- print(_G.LogTag, "BP_CharacterFashion_CColorChangePartColor", Color)
                self:ChangePartColor(PartIdx,Color,ColorData.Fresnel)
            elseif(ColorData.ColorNumber)then
                local ColorNumber = ColorData.ColorNumber
                UKismetMathLibrary.LinearColor_SetFromSRGB(Color,
                    FColor(ColorNumber[1] or 0,ColorNumber[2] or 0,ColorNumber[3] or 0))
                    -- print(_G.LogTag, "BP_CharacterFashion_CColorChangePartColor", Color)

                self:ChangePartColor(PartIdx,Color,ColorData.Fresnel)
            end
        end
    end
end

function BP_CharacterFashion_C:ChangePartColor(PartIdx,Color,Fresnel)
    local FunctionName = "SetCharTintColor"..PartIdx
    local Func = self[FunctionName]
    if(Func)then
        Func(self,Color,Fresnel)
    end
    self:TriggerEffectCreatureEvent()
end

function BP_CharacterFashion_C:TriggerEffectCreatureEvent()
    local Owner = self:GetOwner()
    local EffectCreatures = Owner:GetEffectCreatureByTag("Skin")
    if EffectCreatures:Num() == 0 then
        return
    end
    for i = 1, EffectCreatures:Num() do
        local Creature = EffectCreatures:GetRef(i)
        if not self.NotAlwaysEffectCreature or not self.NotAlwaysEffectCreature[Creature.EffectCreatureId] then
            Creature:OnSkinLevelUp()
        end
    end
end

function BP_CharacterFashion_C:InitHairColors(Colors)
    rawset(self,"CurrentHairColors",Colors)
    rawset(self,"RealHairPartColors",{})
    Colors = Colors or {}
    local SwatchData = DataMgr.Swatch
    local Color = FLinearColor()
    local DefaultColors = {self:GetHiarDefaultColors()}
    for i = 1, DataMgr.GlobalConstant.HairColorPart.ConstantValue do
        local ColorId = Colors[i]
        local PartIdx = i
        local ColorData = SwatchData[ColorId]
        if(ColorData)then
            if(ColorData.ActualR and ColorData.ActualG and ColorData.ActualB)then
                Color = FLinearColor(ColorData.ActualR,ColorData.ActualG,ColorData.ActualB)
                self:ChangeHairPartColor(PartIdx,Color,ColorData.Fresnel)
            elseif(ColorData.ColorNumber)then
                local ColorNumber = ColorData.ColorNumber
                UKismetMathLibrary.LinearColor_SetFromSRGB(Color,
                    FColor(ColorNumber[1] or 0,ColorNumber[2] or 0,ColorNumber[3] or 0))
                self:ChangeHairPartColor(PartIdx,Color,ColorData.Fresnel)
            end
        else
            if(DefaultColors[i])then
                self:ChangeHairPartColor(PartIdx,DefaultColors[i])
            end
        end
    end
end

local HairColorFuncNames = {
    "SetHairTintColor1",
    "SetHairTintColor2",
    "SetHairPartTintColor1",
    "SetHairPartTintColor2",
    "SetHairPartTintColor3",
    "SetHairPartTintColor4",
}

function BP_CharacterFashion_C:ChangeHairPartColor(PartIdx,Color,Fresnel)
    self.RealHairPartColors[PartIdx] = {Color = Color,Fresnel = Fresnel}
    local FunctionName = HairColorFuncNames[PartIdx]
    local Func = self[FunctionName]
    if(Func)then
        Func(self,Color,Fresnel)
    end
end

-- function BP_CharacterFashion_C:GetWeaponColor()
--     if self.WeaponColor then
--         return self.WeaponColor.ActualR, self.WeaponColor.ActualG, self.WeaponColor.ActualB, true
--     end
--     return 0.0, 0.0, 0.0, false
-- end

local RemoveType2Id = function(self,AccessoryType)
    self.Type2Id:Remove(AccessoryType)
    self:ResetSuitAccessoryType()
    self:UpdateSuitAccessoryType2Id(self.Type2Id)
end

local AddType2Id = function(self,AccessoryType,AccessoryId)
    self.Type2Id:Add(AccessoryType,AccessoryId)
    self:ResetSuitAccessoryType()
    self:UpdateSuitAccessoryType2Id(self.Type2Id)
end

function BP_CharacterFashion_C:ChangeAccessory(AccessoryId,AccessoryType,Transform)
    local InValidAccId = not AccessoryId
    AccessoryId = AccessoryId or -1
    if(CommonConst.ActionAccessoryTypes[AccessoryType])then
        --动作类部位
        RemoveType2Id(self,AccessoryType)
        if(DataMgr.CharAccessory[AccessoryId])then
            AddType2Id(self,AccessoryType,AccessoryId)
        end
        return
    end

	local Owner = self:GetOwner()
    --卸载配饰
    Owner:DetachSuitItem(AccessoryType)
    print(_G.LogTag, "Bp_CharacterFashion_C:InitAppearanceSuit ChangeAccessory",AccessoryId, AccessoryType,self:IsHideHiarByAccessory(AccessoryType))
    if(self:IsHideHiarByAccessory(AccessoryType))then
        --先恢复被隐藏的发型
        self:SetHideHiarByAccessory(AccessoryType,false)
        self:RecoverHairMesh()
    end

    if(IsAccessoryHiddenByAnyTag(self,AccessoryType))then
        --帽子被发型/头套隐藏
        RemoveType2Id(self,AccessoryType)
        Owner:DeactivatePartMeshComp(AccessoryType)
        if self.Type2PartId then 
            self.Type2PartId[AccessoryType] = 0
            self:ReInitPartMesh()
        end
        return
    end
    
    print(_G.LogTag, "Bp_CharacterFashion_C:InitAppearanceSuit ChangeAccessory",self.InitWithCombinePart, AccessoryId, AccessoryType)
    if(not self.InitWithCombinePart)then
         Owner:RecoverDefaultPartMesh(AccessoryType) --恢复默认PartMesh
    end
    
    local LastId = self.Type2Id:Find(AccessoryType)
    local LastAccessoryData = DataMgr.CharAccessory[LastId]
    RemoveType2Id(self,AccessoryType)

    if(AccessoryId == DataMgr.GlobalConstant.EmptyCharAccessoryID.ConstantValue or AccessoryId <= 0)then
        local PartMeshAccessoryId,PartMeshAccessoryType = self:GetOwnerPartMeshInfo(Owner.CurrentSkinId)
        if(PartMeshAccessoryType == AccessoryType) and  not InValidAccId then
            --如果角色有默认PartMesh则隐藏
            Owner:DeactivatePartMeshComp(AccessoryType)
            if self.Type2PartId then 
                self.Type2PartId[AccessoryType] = 0
            end
        elseif self.InitWithCombinePart then
            local DefaultPartId = Owner.DefaultCharPartId:Find(AccessoryType)
            if(DefaultPartId) then 
                if(self.Type2PartId) then 
                    self.Type2PartId[AccessoryType] = DefaultPartId
                else
                    print(_G.LogTag,"Bp_CharacterFashion_C:InitAppearanceSuit 3333",DefaultPartId)
                    table.insert(self.InitPartIds,DefaultPartId)
                end
            end
        else 
            if(InValidAccId and self.InitWithCombinePart)then 
                local DefaultPartId = Owner.DefaultCharPartId:Find(AccessoryType)
                if(DefaultPartId) then 
                    if(self.Type2PartId) then 
                        self.Type2PartId[AccessoryType] = DefaultPartId
                    else
                        table.insert(self.InitPartIds,DefaultPartId)
                    end
                    print(_G.LogTag, "BP_CharacterFashion_C:InitAppearanceSuit acc11",#self.InitPartIds, DefaultPartId, AccessoryType)
                end
            end
        end
        --隐藏特效创生物部位
        if(LastAccessoryData and LastAccessoryData.CreatureId)then
            if(self.UpdateFxAccessory)then
                self.UpdateFxAccessory(self,AccessoryType)
            end
        end
        print(_G.LogTag,"Bp_CharacterFashion_C:ChangeAccessory",self.Type2PartId )

        if self.Type2PartId then 
            self:ReInitPartMesh()
        end
        return
    end

    Owner:DeactivatePartMeshComp(AccessoryType)
    if self.Type2PartId then 
        self.Type2PartId[AccessoryType] = 0
    end
    local CharPartId = GetCharPartIdByAccessoryId(AccessoryId)
    -- if CharPartId then
    --     if self.InitWithCombinePart then 
    --         print(_G.LogTag,"Bp_CharacterFashion_C:InitAppearanceSuit 222 Info",CharPartId )
    --         table.insert(self.InitPartIds, CharPartId)
    --         return
    --     else
    --         --显示PartMesh
    --         Owner:SetPartMesh(CharPartId)
    --     end
    -- end
    if not self.InitWithCombinePart and CharPartId then 
        --显示PartMesh
        Owner:SetPartMesh(CharPartId)
    elseif CharPartId and  self.InitWithCombinePart then 
        if(self.Type2PartId) then 
            self.Type2PartId[AccessoryType] = CharPartId
        else
            print(_G.LogTag,"Bp_CharacterFashion_C:InitAppearanceSuit  Info",CharPartId )
            table.insert(self.InitPartIds, CharPartId)
        end
    end

    --安装配饰
    AddType2Id(self,AccessoryType,AccessoryId)
    print(_G.LogTag,"Bp_CharacterFashion_C:ChangeAccessory",self.Type2PartId )
    
    local Data = DataMgr.CharAccessory[AccessoryId]
    if(not Data)then
        if(self.UpdateFxAccessory)then
            self.UpdateFxAccessory(self,AccessoryType)
        end
        if self.Type2PartId then 
            self:ReInitPartMesh()
        end
        return
    end

    --部分帽子需要隐藏头发(IsTail是临时字段名)
    if(Data.IsTail and not IsAccessoryHiddenByAnyTag(self, AccessoryType))then
        self:SetHideHiarByAccessory(AccessoryType,true)
        Owner:DeactivatePartMeshComp(CommonConst.DataType.Hair)
        if(self.Type2PartId) then 
            self.Type2PartId[CommonConst.DataType.Hair] = 0
        end
    end
    if(self.Type2PartId) then 
        self:ReInitPartMesh()
    end
    --安装其他配饰
    local ModelId = Owner.ModelId
    local Paths = TArray(FString)
    local SocketNames = TArray(FName)
    local EffectSocketNames = TArray(FName)
    local EffectPaths = TArray(FString)
    local Offsets = TArray(FTransform)
    local VisualEffectIds = TArray(0)
    self:AddAccessoryParameter(AccessoryId,Paths,SocketNames,Offsets, EffectSocketNames, EffectPaths,ModelId, VisualEffectIds)
    if(Data.ChildAccessory)then
        for _, id in ipairs(Data.ChildAccessory) do
            self:AddAccessoryParameter(id,Paths,SocketNames,Offsets, EffectSocketNames, EffectPaths,ModelId,VisualEffectIds)
        end
    end

    Owner:AttachSuitItems(Data.AccessoryType,Paths,SocketNames,Offsets, EffectPaths, EffectSocketNames,VisualEffectIds)
	self:ChangePartLook(AccessoryType,Data.ChangeColor or 1)

    if(Transform)then
        Transform = Offsets[1] * Transform
        Owner:SetAccessoryTransform(AccessoryId, AccessoryType,Transform)
    else
        Owner:SetAccessoryTransform(AccessoryId, AccessoryType,FTransform())
    end

    if(self.UpdateFxAccessory)then
        self.UpdateFxAccessory(self,AccessoryType)
    end
end

function BP_CharacterFashion_C:GetOwnerPartMeshInfo(SkinId)
	local Owner = self:GetOwner()
    local _SkinId = SkinId or (Owner and Owner.CurrentRoleId)
    if(not _SkinId)then
        return
    end
    for AccessoryId, value in pairs(DataMgr.CharPartMesh) do
        if(value.PartName == "PartMesh")then
            local SkinIds = value.Skin or {}
            for _, Id in pairs(SkinIds) do
                if(Id == _SkinId)then
                    return AccessoryId,value.AccessoryType
                end
            end
        end
    end
end

function BP_CharacterFashion_C:GetDefaultSkinId(Owner, SkinId)
    local _Owner = Owner or self:GetOwner()
    local _SkinId = SkinId or (self.AppearanceSuitInfo and self.AppearanceSuitInfo.SkinId)
    local DefaultSkinId = nil
    local SkinInfo = _SkinId and DataMgr.Skin[_SkinId]
    if SkinInfo and SkinInfo.CharId then
        local CharInfo = DataMgr.Char[SkinInfo.CharId]
        DefaultSkinId = CharInfo and CharInfo.DefaultSkinId
    end
    if not DefaultSkinId and _Owner and _Owner.CurrentRoleId then
        local CharInfo2 = DataMgr.Char[_Owner.CurrentRoleId]
        DefaultSkinId = CharInfo2 and CharInfo2.DefaultSkinId
    end
    return DefaultSkinId
end

function BP_CharacterFashion_C:AddAccessoryParameter(AccessoryId,Paths,SocketNames,Offsets, EffectSocketNames, EffectPaths,ModelId, VisualEffectIds)
    local Data = DataMgr.CharAccessory[AccessoryId]
    if(not Data)then
        return
    end
    local Path = Data.ModelPath
    local Socket = Data.AccessorySocket
    Paths:Add(Path)
    SocketNames:Add(Socket)
    Offsets:Add(self:GetAccessoryOriginOffset(AccessoryId))
    if(Data.NiagaraPath)then
        EffectPaths:Add(Data.NiagaraPath)
    end
    if (Data.AccessorySocket) then 
        EffectSocketNames:Add(Data.SocketName)
    end
    if Data.VisualEffectId then
        VisualEffectIds:Add(Data.VisualEffectId)
    end
end

function BP_CharacterFashion_C:GetAccessoryOriginOffset(AccessoryId)
    local Data = DataMgr.CharAccessory[AccessoryId]
    if(not Data)then
        return FTransform(Const.ZeroRotator:ToQuat(),Const.ZeroVector,Const.OneVector)
    end
    local Owner = self:GetOwner()
    local ModelId = Owner.ModelId
    local ModelData = DataMgr.Model[ModelId] or {}
    local OffsetId = ModelData.CharAccessoryOffsetId and ModelData.CharAccessoryOffsetId[1] or ModelId
    local OffsetData = DataMgr.CharAccessoryOffset[OffsetId]
    OffsetData = OffsetData and OffsetData.OffsetParameter or {}
    for _, OffsetParameter in pairs(OffsetData) do
        for key, value in pairs(OffsetParameter) do
            if(key == Data.AccessorySocket)then
                return CommonUtils:DataToFTransform(value)
            end
        end
    end
    return FTransform(Const.ZeroRotator:ToQuat(),Const.ZeroVector,Const.OneVector)
end

function BP_CharacterFashion_C:GetCurrentHairMeshName()
    local HairData = DataMgr.Hair[rawget(self,"CurrentHairId")]
    if(HairData == nil)then
        return
    end
    local ModelPath
    if(HairData.CharPartId == nil)then
        if(HairData.LinkAccessory)then
            local CharAccessoryData = DataMgr.CharAccessory[HairData.LinkAccessory]
            ModelPath = CharAccessoryData and CharAccessoryData.ModelPath
        end
    else
        local CharPartModelData = DataMgr.CharPartModel[HairData.CharPartId]
        ModelPath = CharPartModelData and CharPartModelData.PartPath
    end
    if(ModelPath)then
        local Res = string.split(ModelPath, ".")
        local MeshName = Res[#Res] or ""
        local Len = #MeshName
        local LastChar = string.sub(MeshName, Len, Len)
        if(LastChar == "'")then
            MeshName = string.sub(MeshName, 1, Len - 1)
        end
        return MeshName
    end
end

function BP_CharacterFashion_C:GetHiarDefaultColors()
    local HairMeshName = self:GetCurrentHairMeshName()
    if(HairMeshName)then
        return self:GetHairDefaultColorsFromDataTable(HairMeshName)
    end
end 

return BP_CharacterFashion_C
