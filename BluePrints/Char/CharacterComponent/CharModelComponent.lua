
require "UnLua"

local Component = Class()

function Component:GetCurrentModelInfo()
    return DataMgr.Model[self.Owner.ModelId]
end

-- function Component:GetCurrentModelId()
--     local Owner = self.Owner
--     if Owner.ShadowModelId and Owner.ShadowModelId ~= 0 then
--         return Owner.ShadowModelId
--     end
--     -- 玩家或者魅影
--     if Owner:IsPlayer() or Owner:IsPhantom() then
--         if Owner.CurrentSkinId and DataMgr.Skin[Owner.CurrentSkinId]then
--             return DataMgr.Skin[Owner.CurrentSkinId].SkinModelId
--         else
--             return Owner.BattleCharInfo.ModelId
--         end
--     elseif Owner:IsAIControlled() then
--         return Owner.Data.ModelId
--     elseif Owner:IsFakeCharacter() then
--         return Owner.ModelId
--     end 
-- end

-- 定义在C++
-- function Component:GetCurrentAnimationBlueprint(Id)
--     local ModelId = Id
--     local Owner =self.Owner
--     if not ModelId then
--         ModelId = DataMgr.BattleChar[Owner.CurrentRoleId].ModelId
--     end
-- 	if not DataMgr.Model[ModelId].SkeletonMeshPath then
-- 		return
-- 	end
--     local ABPPath = DataMgr.Model[ModelId].AnimInstancePath
--     return ABPPath
-- end

function Component:GetCurrentKawaiiLinkLayer(Id)
    local ModelId = Id
    if not ModelId then
        ModelId = DataMgr.BattleChar[self.CurrentRoleId].ModelId
    end
    if not DataMgr.Model[ModelId] then 
        return --Const.DefaultKawaiiLinkLayer
    end
    local LinkLayerPath = DataMgr.Model[ModelId].LinkLayerPath
    --LinkLayerPath = LinkLayerPath or Const.DefaultKawaiiLinkLayer
    -- print(_G.LogTag, "111111111111111111111111zjy",ModelId, LinkLayerPath)
    return LinkLayerPath
end

function Component:GetNPCServerSkinIdByUnitId(NpcId, ConmmonSkinId)
    if not NpcId or not DataMgr.Npc[NpcId] then
        return 0
    end
    local NpcInfo = DataMgr.Npc[NpcId]
    if (NpcInfo.PlayerInfo and NpcInfo.CharId ~= nil) or (NpcInfo.NpcType == "Show" and NpcInfo.CharId ~= nil) then
        local CharId = NpcInfo.CharId
        local Avatar = GWorld:GetAvatar()
        if not Avatar then return 0 end
        local SkinId
        for key,Char in pairs(Avatar.Chars) do
            if Char.CharId == CharId then
                local Appearance = Char.AppearanceSuits[Char.CurrentAppearanceIndex]
                SkinId = Appearance.SkinId
                break
            end
        end
        local CommonChar = Avatar.CommonChars[CharId]
        if CommonChar == nil then
            Utils.ScreenPrint("时装信息错误, CommonChars为空，CharId:" .. tostring(CharId))
            return 0
        end
        local Skin = CommonChar.OwnedSkins[SkinId]
        if Skin == nil then
            Utils.ScreenPrint("时装信息错误, OwnedSkins，SkinId::" .. tostring(SkinId))
            return 0
        end
        local SkinInfo = DataMgr.Skin[SkinId]
        if not SkinInfo or not SkinInfo.SkinModelId then
            return 0
        end
        if SkinInfo.CommonSkinSettingId then 
            ConmmonSkinId = SkinInfo.CommonSkinSettingId
        else
            ConmmonSkinId = 0
        end
        return ConmmonSkinId,SkinInfo.SkinModelId
    end
    -- local SkinData = Skin.Colors
    return 0
end

-- function Component:LoadCurrentModel() -- 1
--     local Owner = self.Owner
--     Owner.CharacterFashion:ClearAllMaterials()
--     local CurrentModelId = self:GetCurrentModelId()
--     Owner.ModelId = CurrentModelId
--     if not Owner.ModelId then
-- 		if Owner.BodyID then
-- 			-- 拼接NPC这里不要在走下去了， 他的模型有构造函数处理
-- 			return
-- 		end
--         Owner.ModelId = DataMgr.BattleChar[Owner.CurrentRoleId].ModelId
--     end
--     local ModelData = DataMgr.Model[Owner.ModelId]
--     if not CurrentModelId or not ModelData then
--         return
--     end
--     local HitMontageRule = Owner:GetHitMontageRule()
--     local ModelPath = ModelData.SkeletonMeshPath
--     if Owner:CheckCanPart() then 
--         self:LoadPartitionModel(ModelPath)
--     else
--         self:LoadFullModel(ModelPath)
--     end
--     if ModelData.ModelScale then
--         local Scale = ModelData.ModelScale
--         local Scale3D = Const.OneVector * Scale --FVector(Scale, Scale, Scale)
--         Owner.Mesh:SetRelativeScale3D(Scale3D)
--     else
--         Owner.Mesh:SetRelativeScale3D(Const.OneVector)
--     end

--     -- --------------------------------------CPP----------------------------------------
--     -- local AnimationPath = self:GetCurrentAnimationBlueprint(Owner.ModelId)
--     -- -- print(_G.LogTag, '111111111111zjy', self.ModelId)
--     -- if AnimationPath then
--     --     self:LoadAnimationBlueprint(AnimationPath, ModelData)
--     -- end
--     -- ------------------------------------------------------------------------------

--     -- --------------------------------------CPP----------------------------------------
--     -- Owner.PlayerAnimInstance = Owner.Mesh:GetAnimInstance()
--     -- if Owner.PlayerAnimInstance.LinkLayerClass then 
--     --     -- print(_G.LogTag,'11111zjy', self.PlayerAnimInstance.LinkLayerClass)
--     --     Owner.Mesh:LinkAnimClassLayers(Owner.PlayerAnimInstance.LinkLayerClass)
--     -- end
--     -- ------------------------------------------------------------------------------

--     -- local LinkLayerPath = self:GetCurrentKawaiiLinkLayer(self.ModelId)
--     -- if LinkLayerPath then 
--     --     local NewLinkLayer = UE4.UResourceLibrary.FindClass(self, LinkLayerPath)
--     --     if NewLinkLayer == nil then
--     --         NewLinkLayer = LoadClass(LinkLayerPath)
--     --     end
--     --     print(_G.LogTag,'2222222zjy',NewLinkLayer)
             
--     -- end

--     -- --------------------------------------CPP----------------------------------------
--     -- if ModelData.HeadScale then
--     --     Owner.PlayerAnimInstance.HeadScale = ModelData.HeadScale
--     -- end
--     -- ----------------------------------------------------------------------------------

--     self:LoadCurrentModel_CPP(Owner.ModelId)

--     local FaceMaterialIndex = ModelData.FaceMaterialIndex
--     local BodyMaterialIndex = ModelData.BodyMaterialIndex
--     if FaceMaterialIndex ~= nil then
--         Owner.CharacterFashion.FaceIndex = FaceMaterialIndex -- FaceIndex C++
--     else
--         Owner.CharacterFashion.FaceIndex = -1
--     end  
--     if BodyMaterialIndex ~= nil then
--         Owner.CharacterFashion.BodyIndex = BodyMaterialIndex  -- BodyIndex Lua
--     else
--         Owner.CharacterFashion.BodyIndex = nil
--     end
--     Owner.CharacterFashion:ReceiveBeginPlay()

--     local RagdollHitFlyCurve = HitMontageRule.RagdollHitFlyCurve
--     if RagdollHitFlyCurve ~= nil then
--         Owner.RagdollHitFlyCurve = LoadObject(RagdollHitFlyCurve)
--     else
--         Owner.RagdollHitFlyCurve = nil
--     end
    
--     Owner.RagdollHitFlyBoneName = HitMontageRule.RagdollHitFlyBoneName

-- end

-- C++
-- function Component:LoadPartitionModel(ModelPath) 
-- 	if not ModelPath then
-- 		return
-- 	end
--     local Owner = self.Owner
--     local MergeResult = Owner:LoadAndMergeMesh()
--     if not MergeResult then 
--         self:LoadFullModel(ModelPath)
--     end
--     if Owner.AccessoryMesh then 
--         Owner.AccessoryMesh:SetHiddenInGame(true)
--     end
-- end

-- C++
-- function Component:LoadFullModel(ModelPath)  
-- 	if not ModelPath then
-- 		return
-- 	end
--     ModelPath = '/Game/'..ModelPath
--     local Owner = self.Owner
--     local ModelMesh = UE4.UResourceLibrary.FindObject(Owner, ModelPath)
--     if ModelMesh == nil then
--         -- 加入预加载
--         ModelMesh = LoadObject(ModelPath)
--     end
        
--     if ModelMesh then
--         Owner:SetCharacterSkinedMesh(ModelMesh)
--     end
-- end

-- 定义在C++
-- function Component:LoadAnimationBlueprint(AnimationPath, ModelData)
--     local Owner = self.Owner
--     if not AnimationPath then
--         return
--     end

--     local NewABPClass = UE4.UResourceLibrary.FindClass(Owner, AnimationPath)
--     if NewABPClass == nil then
--         NewABPClass = LoadClass(AnimationPath)
--     end
--     Owner:SetCharacterAnimInstaceClass(NewABPClass)
--     Owner.PlayerAnimInstance = Owner.Mesh:GetAnimInstance()
--     if not Owner.PlayerAnimInstance.Begining then
--         Owner.PlayerAnimInstance:AnimInstanceRestart()
--     end
--     -- TODO: 需要将原地转身、看向的逻辑抽出 AnimInstance
--     self:InitTurnInPlace(Owner.PlayerAnimInstance, Owner.ModelId)
-- end

-- 定义在C++
-- function Component:InitTurnInPlace(PlayerAnimInstance, Id)
--     local ModelInfo = DataMgr.Model[Id]
-- 	if PlayerAnimInstance == nil or ModelInfo == nil or ModelInfo.MontageFolder == nil then return end
--     local RotationMontagePath = self:GetRotationMontagePath()
--     PlayerAnimInstance.TurnIPStandMontageInfo.Montage = LoadObject(RotationMontagePath)
--     PlayerAnimInstance.TurnIPStandMontageInfo.L90.PartName = "L90"
--     PlayerAnimInstance.TurnIPStandMontageInfo.R90.PartName = "R90"
--     PlayerAnimInstance.TurnIPStandMontageInfo.L180.PartName = "L180"
--     PlayerAnimInstance.TurnIPStandMontageInfo.R180.PartName = "R180"
--     local TurnIPMinAngle = 30
--     local TurnIP180Threshold = 90
--     local MoveParameters = ModelInfo.MoveParameters
--     if MoveParameters then
--         TurnIPMinAngle = MoveParameters.TurnIPMinAngle
--         TurnIP180Threshold = MoveParameters.TurnIP180Threshold
--     end
--     PlayerAnimInstance.TurnIPMinAngle = TurnIPMinAngle or 30
--     PlayerAnimInstance.TurnIP180Threshold = TurnIP180Threshold or 90
-- end

function Component:GetRotationMontagePath()
    local ModelData = DataMgr.Model[self:GetCurrentModelId()] 
    return ModelData.MontageFolder .. "Locomotion/" .. ModelData.MontagePrefix .. "Rotation_Montage"
end

-- BodyId这个变量定义在不同的NPC蓝图里。。。
function Component:HaveBodyId()
    return self.Owner and self.Owner.BodyId
end

return Component