
-- 外骨骼掉落功能
-- local Component = Class("BluePrints.Combat.BattleEvents.BaseEvent")
-- Component = setmetatable(Component, getmetatable(Component.Super))
local Component = Class()

-- Component:Decorator(BattleEventName.Damaged)
-- function Component:DamagedDropBodyAccessory(_, DamageEvent, Source, Target)
--     if not DamageEvent.DropBodyAccessory then
--         return
--     end
--     if not Target.Data or not Target.Data.AccessoryIds then
--         return
--     end
--     if not Source then
--         return 
--     end
--     if Target == Source then
--         return
--     end
--     local TargetLocation = Target:K2_GetActorLocation()
--     local SourceLocation = Source:K2_GetActorLocation()
--     local Point = SourceLocation - TargetLocation
--     local Point1 = UE.UKismetMathLibrary.InverseTransformDirection(Target:GetTransform(), Point)
--     local HitRotation = Point1:ToRotator()

--     if not Target.AccessoryIds then
--         return
--     end
--     if not Target.GetAccessories then
--         return
--     end

--     local Accessories = Target:GetAccessories()
--     if not Accessories then
--         return
--     end
--     if Target:IsDead() then
--         return
--     end

--     local HitType = "Normal"
--     if Target.CharacterInTag and (Target:CharacterInTag("HitFly") or Target:CharacterInTag("HitRepel")) then
--         HitType = "Hit"
--     end

--     for _, AccessoryId in ipairs(Target.AccessoryIds) do
--         local Accessory = Accessories[AccessoryId]
--         if Accessory then
--             local DirectIndex = self:CheckAccessoryDrop(Point1, Accessory, Accessories)
--             if DirectIndex and DirectIndex > 0 then
--                 if not self.AccessoryDropList then
--                     self.AccessoryDropList = {}
--                 end
--                 Accessory.MarkDroped = true
--                 table.insert(self.AccessoryDropList, 
--                 {
--                     Target = Target,
--                     AccessoryId = AccessoryId,
--                     DirectIndex = DirectIndex,
--                     HitType = HitType,
--                     HitRotation = { HitRotation.Pitch, HitRotation.Roll, HitRotation.Yaw }
--                 })
--                 if DamageEvent.bSingleDamage and DamageEvent.bIsCreatureDamage then
--                     break
--                 end
--             end
--         end
--     end
-- end

-- function Component:CheckAccessoryDrop(Point, Accessory, Accessories)
--     if Accessory.MarkDroped then
--         return -1
--     end
--     local PreAccessories = Accessory.Data.PreAccessories
--     if PreAccessories then
--         for i = 1, #PreAccessories do
--             if Accessories[PreAccessories[i]] then
--                 -- 前置配件没掉落
--                 return -1
--             end
--         end
--     end
--     local DropProb = Accessory.Data.DropProb
--     -- 没有概率，直接false
--     if not DropProb then
--         return -1
--     end
--     local MoveDirect = Accessory.Data.MoveDirect
--     if not MoveDirect then
--         return -1
--     end

--     local DirectIndex = -1
--     local DamageDirect = Accessory.Data.DamageDirect
--     if DamageDirect then
--         if #DamageDirect ~= #DropProb or #DamageDirect ~= #MoveDirect then
--             return -1
--         end 

--         -- local TargetLocation = Target:K2_GetActorLocation()
--         -- local SourceLocation = Source:K2_GetActorLocation()
--         -- local Point = SourceLocation - TargetLocation
--         -- local Point1 = UE.UKismetMathLibrary.InverseTransformDirection(Target:GetTransform(), Point)

--         -- -- PrintTable({Point=Point,Point1=Point1})
--         -- Point = Point1

--         local AbsX = math.abs(Point.x)
--         local AbsY = math.abs(Point.y)
--         local CurDirect
--         if AbsY >= AbsX and Point.y >= 0 then
--             CurDirect = "right"
--         elseif AbsY <= AbsX and Point.x >= 0 then
--             CurDirect = "front"
--         elseif AbsY <= AbsX and Point.x <= 0 then
--             CurDirect = "back"
--         elseif AbsY >= AbsX and Point.y <= 0 then
--             CurDirect = "left"
--         end
--         for Index, Direct in ipairs(DamageDirect) do
--             if Direct == CurDirect then
--                 DirectIndex = Index
--                 break
--             end
--         end
--     end
--     if DirectIndex == -1 then
--         return -1
--     end

--     -- DropProb = 1
--     local RandomValue = math.random()
--     -- 没随机到，返回false
--     if RandomValue >= DropProb[DirectIndex] then
--         return -1
--     end

--     return DirectIndex
-- end

-- function Component:Tick(DeltaSeconds)
--     if not self.AccessoryDropList then
--         return
--     end
--     if #self.AccessoryDropList == 0 then
--         return
--     end
--     for i = 1, Const.BodyAccessoryDropFrameCount do
--         if #self.AccessoryDropList == 0 then
--             break
--         end
--         local AccessoryDropInfo = self.AccessoryDropList[1]
--         table.remove(self.AccessoryDropList, 1)
--         if IsValid(AccessoryDropInfo.Target) then
--             AccessoryDropInfo.Target:DestroyAccessory(AccessoryDropInfo.AccessoryId, AccessoryDropInfo.DirectIndex, AccessoryDropInfo.HitType, AccessoryDropInfo.HitRotation)
--         end
--     end
-- end

function Component:GetBodyAccessoryDropFrameCount()
    return Const.BodyAccessoryDropFrameCount
end

return Component
