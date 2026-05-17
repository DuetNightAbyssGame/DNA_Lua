
local Component = {}

function Component:GetSkeletalMeshAccessoryBPPath()
    return Const.CharResourcePaths.AccessoryBP
end

function Component:GetStaticMeshAccessoryBPPath()
    return Const.CharResourcePaths.StaticAccessoryBP
end

-- function Component:AddAccessory(AccessoryId)
-- 	if self.Accessories == nil then
--         ---@type BP_BodyAccessoryItem_C[]
--         self.Accessories = {}
--     end

--     assert(not self.Accessories[AccessoryId], '已经存在该配件')

--     -- 创建新的武器
--     local Accessory = self:_SpawnAccessory(AccessoryId)
--     if Accessory == nil then
--         return
--     end

--     self.Accessories[AccessoryId] = Accessory
--     return Accessory
-- end

-- function Component:GetAccessories()
--     return self.Accessories
-- end

-- function Component:ServerSetUpAccessories()
--     if not self:IsMonster() and not self:IsNPC() and not self:IsCombatItemBase() then
--         return
--     end

--     self.AccessoryIds = {}
--     local AccessoryIds = self.Data.AccessoryIds
--     if not AccessoryIds then
--         return
--     end
--     local NormalAccessoryIds = AccessoryIds.Normal
--     if NormalAccessoryIds then
--         for i = 1, #NormalAccessoryIds do
--             local Accessory = self:AddAccessory(NormalAccessoryIds[i])
--             Accessory:Bind()
--             table.insert(self.AccessoryIds, NormalAccessoryIds[i])
--         end
--     end

--     local RandomAccessoryIds = AccessoryIds.Random
--     local RandomNum = AccessoryIds.RandomNum
--     if RandomAccessoryIds and RandomNum then
--         if RandomNum >= #RandomAccessoryIds then
--             for i = 1, #RandomAccessoryIds do
--                 local Accessory = self:AddAccessory(RandomAccessoryIds[i])
--                 Accessory:Bind()
--                 table.insert(self.AccessoryIds, RandomAccessoryIds[i])
--             end
--         else
--             local RandomArray = {}
--             for i = 1, #RandomAccessoryIds do
--                 table.insert(RandomArray, RandomAccessoryIds[i])
--             end
--             for i = 1, RandomNum do
--                 local AccessoryId = table.remove(RandomArray, math.random(#RandomArray))
--                 local Accessory = self:AddAccessory(AccessoryId)
--                 Accessory:Bind()
--                 table.insert(self.AccessoryIds, AccessoryId)
--             end
--         end
--     end
-- end

-- function Component:_SpawnAccessory(AccessoryId)
--     local Accessory
--     local GameState = UE4.UGameplayStatics.GetGameState(self)
--     if GameState and GameState:HasBodyAccessoryCache(AccessoryId) then
--         Accessory = GameState:CreateBodyAccessoryFromCache(AccessoryId)
--         Accessory:SetOwner(self)
--         Accessory:SetActorHideTag("CacheFreeze", false)
--     elseif GameState and GameState:HasBodyAccessoryInPool(AccessoryId) then
--         Accessory = GameState:GetBodyAccessoryFromPool(AccessoryId)
--         Accessory:SetOwner(self)
--         Accessory:SetActorHideTag("BodyAccessoryPool", false)
--     else
--         local WeaponClass = nil
--         local Mesh = LoadObject(DataMgr.BodyAccessory[AccessoryId].ModelPath)
--         if Mesh:Cast(USkeletalMesh) then
--             WeaponClass = UE4.UClass.Load(Const.CharResourcePaths.AccessoryBP)
--         elseif Mesh:Cast(UStaticMesh) then
--             WeaponClass = UE4.UClass.Load(Const.CharResourcePaths.StaticAccessoryBP)
--         end
--         assert(WeaponClass, '找不到配件蓝图')
--         local Transform = self.Mesh:GetSocketTransform("Root", Const.RST_World)
--         Accessory = self:GetWorld():SpawnActor(WeaponClass, Transform, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn, self, self, nil)
--         if Accessory then
--             Accessory:InitAccessoryInfo(AccessoryId)
--         end
--     end

--     return Accessory
-- end

function Component:GetAllAccessoryMeshes()
    local Meshes = TArray(UE4.UMeshComponent)
    if not self.Accessories then
        return Meshes
    end
    for _, Accessory in pairs(self.Accessories) do
        if Accessory.Mesh then
            Meshes:Add(Accessory.Mesh)
        end
    end
    return Meshes
end

-- function Component:GetAllBodyAccessories()
--     local BodyAccessories = TMap(0, AActor)
--     if not self.Accessories then
--         return BodyAccessories
--     end
--     for AccessoryId, Accessory in pairs(self.Accessories) do
--         if Accessory.Mesh then
--             BodyAccessories:Add(AccessoryId, Accessory)
--         end
--     end
--     return BodyAccessories
-- end

-- function Component:DestroyAccessory(AccessoryId, DirectIndex, HitType, HitRotation)
--     local Accessory = self.Accessories[AccessoryId]
--     self.Accessories[AccessoryId] = nil
--     if not IsValid(Accessory) then
--         return
--     end
--     if Accessory.Data.HitEffect and self.PlayBodyAccessoryEffect then
--         for EffectId, EffectData in pairs(Accessory.Data.HitEffect) do
--             if EffectData.DelayTime then
--                 self:AddTimer(EffectData.DelayTime, function() 
--                     if not IsValid(self) or not IsValid(self.FXComponent) then
--                         return
--                     end
--                     self.FXComponent:PlayEffectByIDParams(EffectId, EffectData.IgnoreHitRotation and {NotAttached=true} or { rotation = HitRotation, NotAttached=true }) 
--                 end)
--             else
--                 self.FXComponent:PlayEffectByIDParams(EffectId, EffectData.IgnoreHitRotation and {NotAttached=true} or { rotation = HitRotation, NotAttached=true }) 
--             end
--         end
--     end
--     Accessory.PlayBodyAccessoryEffect = self.PlayBodyAccessoryEffect
--     Accessory:Destroy(DirectIndex, HitType)
-- end

-- function Component:DestroyActorOnDead(bNormalDeath, DeathReason)
--     self:DestroyAccessoryOnDead(bNormalDeath, DeathReason)
--     -- if not self.InitSuccess then
--     --     return
--     -- end
--     -- if not self.Accessories then
--     --     return
--     -- end
--     -- if not NormalDeath then
--     --     for _, AccessoryId in pairs(CommonUtils.Keys(self.Accessories)) do
--     --         local Accessory = self.Accessories[AccessoryId]
--     --         self.Accessories[AccessoryId] = nil
--     --         if IsValid(Accessory) then
--     --             Accessory:EMActorDestroy()
--     --         end
--     --     end
--     -- else
--     --     self:AddTimer(0.01,
--     --         function()
--     --             if not UKismetSystemLibrary.IsValid(self) then
--     --                 return
--     --             end
--     --             if not self.Accessories then
--     --                 return
--     --             end
--     --             for _, AccessoryId in pairs(CommonUtils.Keys(self.Accessories)) do
--     --                 self:DestroyAccessory(AccessoryId, 1, "Death")
--     --             end
--     --         end
--     --     )
--     -- end
-- end

-- function Component:HideAllBodyAccessories(HideTag, bHide)
--     if not self.Accessories then
--         return
--     end
--     for _, Accesspory in pairs(self.Accessories) do
--         if IsValid(Accesspory) then
--             Accesspory:SetActorHideTag(HideTag, bHide)
--         end
--     end
-- end

function Component:HasBodyAccessories()
    return self.Accessories:Num() > 0
end

return Component