
-- local NewCircularQueue = function(MaxNum)
--     local CircularQueue = {
--         Current = 1,
--         MaxNum = 1000,
--         Items = {}
--     }
--     function CircularQueue:PopNext()
--         local Items = self.Items[self.Current]
--         self.Items[self.Current] = nil
--         self.Current = self.Current % self.MaxNum + 1
--         return Items
--     end

--     function CircularQueue:AddItem(Step, Item)
--         local Index = (self.Current + math.min(math.max(Step, 2), self.MaxNum - 1) - 1) % self.MaxNum + 1
--         if not self.Items[Index] then
--             self.Items[Index] = {}
--         end
--         table.insert(self.Items[Index], Item)
--     end

--     function CircularQueue:GetAll()
--         return self.Items
--     end

--     function CircularQueue:Clear()
--         self.Items = {}
--     end

--     return CircularQueue
-- end

local SkillCreaturePool = {}

-- function SkillCreaturePool:Init_SkillCreaturePool()
--     -- 客户端不tick
--     if not IsAuthority(self) then
--         self.TickSkillCreaturePool = MiscUtils.EmptyFunction
--         return
--     end
--     self.Init = true
--     self.ClassMap = {}
--     self.CachedPool = {}
--     self.RefreshList = NewCircularQueue(1000)

--     self.ShrinkInterval = 10
--     self:AddTimer(self.ShrinkInterval, self.ShrinkPoolActor, true)

--     self.CacheInfos = {}
--     self.RecycleDelay=100
-- end

function SkillCreaturePool:GetSkillCreaturePoolRefreshTime()
    return Const.SkillCreaturePoolRefreshTime
end

function SkillCreaturePool:GetSkillCreaturePoolCleanTime()
    return Const.SkillCreaturePoolCleanTime
end


-- 创建创生物
-- 开始
-- function SkillCreaturePool:SpawnActor(BPPath, CreatureId, UsePool)
--     return self:SpawnSkillCreature(CreatureId, BPPath, UsePool)
--     -- local Creature
--     -- if UsePool and self:HaveCreatureInPool(CreatureId) then
--     --     Creature = self:GetCreatureFormPool(CreatureId)
--     -- else
--     --     local CreatureClass = self:GetCreatureClass(BPPath)
--     --     Creature = self:CreateNewCreture(CreatureId, CreatureClass)
--     -- end   
--     -- return Creature
-- end

---@param Weapon BP_WeaponBase_C
function SkillCreaturePool:PreloadSkillCreature_Lua(Source, Weapon, bPersistent)
    local BulletNum = math.max(Weapon.Data.BulletInit or 0, Weapon.Data.MagazineCapacity or 0)
    if BulletNum == 0 then
        BulletNum = Const.SkillCreaturePoolDefaultPreloadNum
    end
    local Skills = Weapon:GetSkills()
    for _, SKillId in ipairs(Skills) do
        local Skill = Source:GetSkill(SKillId)
        self:PreloadSkillCreatureBySkill(Skill, bPersistent, BulletNum)
    end
end

---@param Skill BP_SkillObject_C
function SkillCreaturePool:PreloadSkillCreatureBySkill(Skill, bPersistent, BulletNum)
    if not Skill then
        return
    end
    local BeginNodeId = Skill.Data.BeginNodeId
    local AllSkillNode = {}
    if not BeginNodeId then
        return
    end
    AllSkillNode[BeginNodeId] = true
    local TempSkillList = 
    {
        BeginNodeId
    }
    while #TempSkillList > 0 do
        local SkillNodeId = table.remove(TempSkillList, #TempSkillList)
        local SkillNodeData = DataMgr.SkillNode[SkillNodeId]
        if SkillNodeData then
            if SkillNodeData.SkillNodeEffects then
                for _, SkillNodeEffectId in pairs(SkillNodeData.SkillNodeEffects) do
                    local SKillEffectData = DataMgr.SkillEffects[SkillNodeEffectId]
                    local TaskEffects = SKillEffectData.TaskEffects or {}
                    for _, Effect in ipairs(TaskEffects) do
                        if Effect.Function == "CreateSkillCreature" then
                            local CreatureData = DataMgr.SkillCreature[Effect.CreatureId]
                            local BPPath = CreatureData.BPPath or "/Game/BluePrints/Combat/SkillCreatures/BP_SkillCreature.BP_SkillCreature"
                            if CreatureData.EnterPool and not CreatureData.BPPath and not CreatureData.UseBulletCreature then
                                self:PreloadSkillCreature(Effect.CreatureId, BPPath, bPersistent, BulletNum)
                            end
                        end
                    end
                end
            end
            local NextNodeId = SkillNodeData.NextNodeId
            local ExtraNextNodeId = SkillNodeData.ExtraNextNodeId
            if NextNodeId and not AllSkillNode[NextNodeId] then
                AllSkillNode[NextNodeId] = true
                table.insert(TempSkillList, NextNodeId)
            end
            if ExtraNextNodeId and not AllSkillNode[ExtraNextNodeId] then
                AllSkillNode[ExtraNextNodeId] = true
                table.insert(TempSkillList, ExtraNextNodeId)
            end
        end
    end
end
-- function SkillCreaturePool:HaveCreatureInPool(CreatureId)
--     if not self.CachedPool[CreatureId] then
--         return false
--     end
--     local Num = #self.CachedPool[CreatureId]
--     return Num > 0
-- end

-- function SkillCreaturePool:GetCreatureFormPool(CreatureId)
--     local Creature = table.remove(self.CachedPool[CreatureId])
--     if #self.CachedPool[CreatureId] == 0 then
--         self.CachedPool[CreatureId] = nil
--     end
--     self.CacheInfos[CreatureId] = true
--     return Creature
-- end

-- function SkillCreaturePool:GetCreatureClass(BPPath)
--     local CreatureClass = self.ClassMap[BPPath]
--     if not CreatureClass or not UE4.UKismetSystemLibrary.IsValid(CreatureClass) or type(CreatureClass) == 'table' then
--         CreatureClass = LoadClass(BPPath)
--         self.ClassMap[BPPath] = CreatureClass
--     end
   
--     local CreatureClass = LoadClass(BPPath)
--     -- 备忘
--     -- if not CreatureClass or not UE4.UKismetSystemLibrary.IsValid(CreatureClass) or type(CreatureClass) == 'table' then 
--     --     CreatureClass = LoadClass(BPPath)
--     --     if  type(CreatureClass) == 'table' then 
--     --         CreatureClass = CreatureClass.Object
--     --     end
--     --     self.ClassMap[BPPath] = CreatureClass
--     -- end
--     return CreatureClass
-- end

-- function SkillCreaturePool:CreateNewCreture(CreatureId, CreatureClass)
--     return self:GetWorld():SpawnActor(CreatureClass, self:GetTransform(), UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)    
-- end
-- 创建创生物
-- 结束




-- 创生物缓存
-- 开始


-- 低帧率下，高复用，低内存
-- 高帧率下，低复用，高内存

-- 创生物销毁的时候，进入刷新列表（刷新列表中的不可复用）
-- function SkillCreaturePool:RecycleActor(Creature)
--     -- Creature:K2_DestroyActor()
--     -- 100帧以后可复用
--     self.RefreshList:AddItem(self.RecycleDelay, Creature)
-- end

-- function SkillCreaturePool:TickSkillCreaturePool(DeltaSeconds)
--     return self:DoRefreshList(DeltaSeconds)
-- end

-- -- 让刷新列表的创生物进入CachedPool，进入可复用状态
-- function SkillCreaturePool:DoRefreshList(DeltaSeconds)
--     if not self.RefreshList then
--         return
--     end
--     local Step = math.min(math.max(math.floor(DeltaSeconds * 16), 1), 5)
--     for i=1,Step do
--         local Items = self.RefreshList:PopNext()
--         if not Items then
--             return
--         end
--         for _, SkillCreature in ipairs(Items) do
--             if IsValid(SkillCreature) then
--                 local CreatureId = SkillCreature.CreatureId
--                 -- PrintTable({MoveInToCache=SkillCreature})
--                 SkillCreature:MoveInToCache()
--                 self.CachedPool[CreatureId] = self.CachedPool[CreatureId] or {}
--                 table.insert(self.CachedPool[CreatureId], SkillCreature)
--             end
--         end
--     end
-- end

-- -- 创生物缓存
-- -- 结束

-- -- 清除
-- function SkillCreaturePool:ShrinkPoolActor()
--     for CreatureId, Pool in pairs(self.CachedPool) do
--         if not self.CacheInfos[CreatureId] then
--             local Creature = self:GetCreatureFormPool(CreatureId)
--             Creature:K2_DestroyActor()
--         end
--     end
--     self.CacheInfos = {}
-- end

-- function SkillCreaturePool:ClearCreaturePool()
--     -- PrintTable(self.CachedPool)
--     for CreatureId, Pool in pairs(self.CachedPool) do
--         for _, Creature in ipairs(Pool) do
--             PrintTable({S=Creature})
--             Creature:K2_DestroyActor()
--         end
--     end
--     self.CachedPool = {}

--     local Items = self.RefreshList:GetAll()
--     -- PrintTable(Items,2)
--     for _, _Items in pairs(Items) do
--         for _, Creature in ipairs(_Items) do
--             Creature:K2_DestroyActor()
--         end
--     end
--     self.RefreshList:Clear()
-- end

return SkillCreaturePool
