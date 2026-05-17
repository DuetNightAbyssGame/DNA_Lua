-- local SkillUtils = require "Utils.SkillUtils"

-- local Component = {}

-- function Component:Refresh_Server(bIgnoreLastTime)
--     -- self:InitAttrData()
-- end

-- -- 服务端
-- function Component:ServerBeginPlay_Lua()
--     self:InitAttrData()
-- end

-- -- 服务端
-- function Component:ServerBeforeDestroy()
--     self:ResetAttrChanges()
--     -- DebugPrint("Tianyi@ 移除Buff所有属性附加: " .. self.BuffId)
-- end

-- function Component:OnFreeLayerUpdated(FreeLayer)
--     if not self.InitSuccess then return end 
--     if IsClient(self.OwnerActor) then return end
--     local Layers = self:GetFreeLayers()
--     local LayerNum = Layers:Num()
--     for i = 1, LayerNum do 
--         local Layer = Layers:GetRef(i)
--         if not Layer.bIsDirty then 
--             goto continue    
--         end

--         self:ApplyLayerAttrChange(Layer)
--         ::continue::
--     end
-- end

-- function Component:OnFreeLayerAdded(FreeLayer)
--     if not self.InitSuccess then return end 
--     if IsClient(self.OwnerActor) then return end
--     self:ApplyLayerAttrChange(FreeLayer)
-- end


-- function Component:OnFreeLayerRemoved(FreeLayer)
--     if not self.InitSuccess then return end 
--     if IsClient(self.OwnerActor) then return end
--     if not self.BuffConfig.AddAttrs then return end
--     self:RemoveTargetAttrChange(FreeLayer.Uid)
--     -- DebugPrint("Tianyi@ 移除Buff属性: " .. FreeLayer.Uid)
-- end


-- -- 属性附加
-- function Component:InitAttrData()
--     self:ResetAttrChanges()

--     local FreeLayers = self:GetFreeLayers()
--     local LayerNum = FreeLayers:Num()
--     for i = 1, LayerNum do 
--         local FreeLayer = FreeLayers:GetRef(i) 
--         self:ApplyLayerAttrChange(FreeLayer)
--     end    
-- end

-- function Component:ApplyLayerAttrChange(FreeLayer)
--     if not self.BuffConfig.AddAttrs then return end
--     local AddAttrs = self.BuffConfig.AddAttrs
--     for i = 1, #AddAttrs do 
--         local AttrData = AddAttrs[i]
--         local FreeLayerSkillLevel = FreeLayer.SkillLevel.SkillLevel
--         local SourceEid = FreeLayer.SourceEid
--         local Source = Battle(self):GetEntity(SourceEid)
    
--         AttrData = SkillUtils.GrowProxyBySkillLevel('Buff', self.BuffId, FreeLayerSkillLevel, AttrData)
--         local Layer = 1
--         if AttrData.Stackable then
--             Layer = FreeLayer.Layer
--         end
--         local AttrName = AttrData.AttrName
--         if DataMgr.AttributeType[AttrName] then
--             AttrName = AttrName .. "_" .. (AttrData.Type or "Normal")
--         end
--         local Rate = 0
--         local Value = 0
--         if AttrData.RateUseValue then
--             Rate = FreeLayer.Value
--         else
--             Rate = (AttrData.Rate or 0)
--         end
--         if AttrData.ValueUseValue then
--             Value = FreeLayer.Value
--         else
--             Value = (AttrData.Value or 0)
--         end
--         Rate = Rate * Layer
--         Value = Value * Layer
--         if AttrData.AllowSkillIntensity then
--             Value = Value * (Source:GetAttrByConstrain(EAttrName.SkillIntensity) or 1)
--         end
    
--         if Rate ~= 0 and AttrData.BaseUseValue then
--             -- 使用施法者参数转换Rate
--             Value = Value + FreeLayer.Value * Rate
--             Rate = 0
--         end
--         if Rate ~= 0 or Value ~= 0 then
--             local UniqueId = table.concat({"Buff_", self.BuffId, "_", self.UniqueId, "_", FreeLayer.Uid, "_", i}, "")
--             self:ApplyAttrChange(FreeLayer.Uid, UniqueId, AttrName, Rate, Value)
--         end
--     end
-- end

-- return Component