-- ---@class DotInfo 
-- ---@field DotDataIndex number @Dot信息对应表中下标
-- ---@field DotType string @Dot类型 
-- ---@field FinalValue number @计算后最后生效的数值

-- ---@class PerLayerDotInfo 
-- ---@field SourceEid number @Buff来源的Eid
-- ---@field Infos DotInfo[] @所有Dot数据

-- ---@class LayerDotInfos
-- ---@field LayerInfos table<number, PerLayerDotInfo> @对应每层数据， 用每层的Uid作为索引 
-- ---@field MergedFinalValue table<number, number[]> @按照SourceEid合并，用于加速计算

-- local SkillUtils = require "Utils.SkillUtils"
-- local Component = {}

-- function Component:BeginPlay_Lua()
--     self.DotDatas = self.BuffConfig.DotDatas

--     ---@type LayerDotInfos
--     self.LayerDotInfos = {
--         LayerInfos = {},
--         MergedFinalValue = {},
--     }
-- end

-- function Component:Refresh_Server()
--     -- DebugPrint("Tianyi@ DotRefresh:, LocalRole = " .. self.Owner:GetLocalRole())
--     self:InitDotEffect()
-- end

-- -- 服务端
-- function Component:ServerBeginPlay_Lua()
--     self:InitDotEffect()

--     -- local FreeLayers = self:GetFreeLayers()
--     -- local LayerNum = FreeLayers:Num()
--     -- for i = 1, LayerNum do 
--     --     local FreeLayer = FreeLayers:GetRef(i) 
--     --     self:AddLayerDotEffect(FreeLayer)
--     -- end
-- end

-- -- 服务端
-- function Component:ServerBeforeDestroy()
--     self:ClearDotTimer()
-- end

-- function Component:OnFreeLayerAdded(FreeLayer)
--     if IsClient(self.OwnerActor) then return end
--     self:AddLayerDotEffect(FreeLayer)
-- end

-- function Component:OnFreeLayerUpdated()
--     if not self.InitSuccess then return end 
--     if IsClient(self.OwnerActor) then return end
--     if not self:HasDotEffect() then return end

--     local FreeLayers = self:GetFreeLayers()
--     local LayerNum = FreeLayers:Num()
--     for i = 1, LayerNum do 
--         local FreeLayer = FreeLayers:GetRef(i) 
--         if FreeLayer.bIsDirty then 
--             self:RemoveLayerDotEffect(FreeLayer)
--             self:AddLayerDotEffect(FreeLayer)
--         end
--     end
-- end

-- function Component:OnFreeLayerRemoved(FreeLayer)
--     DebugPrint("Tianyi@ OnFreeLayerRemoved, LocalRole = " .. self.Owner:GetLocalRole())
--     if not self.InitSuccess then return end 
--     if IsClient(self.OwnerActor) then return end
--     self:RemoveLayerDotEffect(FreeLayer)
-- end

-- function Component:AddLayerDotEffect(FreeLayer)
--     if not self.InitSuccess then return end 
--     if not self:HasDotEffect() then return end
        
--     ---@type PerLayerDotInfo 
--     local LayerDotInfo = {}
--     LayerDotInfo.SourceEid = FreeLayer.SourceEid
--     LayerDotInfo.Infos = {}


--     for i = 1, #self.DotDatas do
--         local DotData = self.DotDatas[i] 
--         local DotInfo = self:ConstructDotInfo(FreeLayer, DotData, i) 
--         table.insert(LayerDotInfo.Infos, DotInfo)

--         if DotInfo.FinalValue then 
--             local MergedFinalValues = self.LayerDotInfos.MergedFinalValue[LayerDotInfo.SourceEid] or {}
--             MergedFinalValues[i] = (MergedFinalValues[i] or 0) + DotInfo.FinalValue
--             self.LayerDotInfos.MergedFinalValue[LayerDotInfo.SourceEid] = MergedFinalValues
--         end
--     end

--     self.LayerDotInfos.LayerInfos[FreeLayer.Uid] = LayerDotInfo
-- end

-- function Component:RemoveLayerDotEffect(FreeLayer)
--     if not self.InitSuccess then return end 
--     if not self:HasDotEffect() then return end

--     ---@type PerLayerDotInfo
--     local LayerDotInfo = self.LayerDotInfos.LayerInfos[FreeLayer.Uid]

--     for Index, DotInfo in ipairs(LayerDotInfo.Infos) do 
--         if DotInfo.FinalValue then 
--             local MergedFinalValues = self.LayerDotInfos.MergedFinalValue[LayerDotInfo.SourceEid]
--             if MergedFinalValues and MergedFinalValues[Index] then 
--                 MergedFinalValues[Index] = MergedFinalValues[Index] - DotInfo.FinalValue
--             end
--         end
--     end

--     self.LayerDotInfos.LayerInfos[FreeLayer.Uid] = nil
-- end

-- function Component:ConstructDotInfo(FreeLayer, DotData, DotDataIndex)
--     local DotType = string.upper(DotData.Type)
--     if DotType == string.upper(Const.BuffDotDamage) then
--         return self:ConstructDotDamageInfo(FreeLayer, DotData, DotDataIndex)
--     elseif DotType == string.upper(Const.BuffDotAddShield) then 
--         return self:ConstructDotShieldInfo(FreeLayer, DotData, DotDataIndex)
--     elseif DotType == string.upper(Const.BuffDotHot) then 
--         return self:ConstructDotHotInfo(FreeLayer, DotData, DotDataIndex)
--     elseif DotType == string.upper(Const.BuffDotSkillEffect) then
--         return self:ConstructDotSkillEffectInfo(FreeLayer, DotData, DotDataIndex)
--     elseif DotType == string.upper(Const.BuffDotSpChange) then
--         return self:ConstructDotSpChangeInfo(FreeLayer, DotData, DotDataIndex)
--     end
-- end

-- function Component:ConstructDotDamageInfo(FreeLayer, DotData, DotDataIndex)
--     local FreeLayerSkillLevel = FreeLayer.SkillLevel.SkillLevel
--     local FreeLayerValue = FreeLayer.Value 
--     local FreeLayerNum = DotData.Stackable and FreeLayer.Layer or 1
--     local DotValue = FreeLayerNum * self:CalcSingleNewFreeLayerDotDamage(FreeLayerValue, FreeLayerSkillLevel, DotDataIndex)

--     if DotData.AllowSkillIntensity then
--         DotValue = DotValue * self.SkillIntensity
--     end

--     ---@type DotInfo
--     local DotInfo = {
--         DotType = Const.BuffDotDamage,
--         FinalValue = DotValue,
--     }
--     return DotInfo
-- end

-- function Component:ConstructDotShieldInfo(FreeLayer, DotData, DotDataIndex)
--     local FreeLayerSkillLevel = FreeLayer.SkillLevel.SkillLevel
--     local FreeLayerValue = FreeLayer.Value 
--     local FreeLayerNum = DotData.Stackable and FreeLayer.Layer or 1
--     local DotValue = FreeLayerNum * self:CalcSingleNewFreeLayerDotDamage(FreeLayerValue, FreeLayerSkillLevel, DotDataIndex)

--     if DotData.AllowSkillIntensity then
--         DotValue = DotValue * self.SkillIntensity
--     end

--     ---@type DotInfo
--     local DotInfo = {
--         DotType = Const.BuffDotAddShield,
--         FinalValue = DotValue,
--     }
--     return DotInfo
-- end

-- function Component:ConstructDotHotInfo(FreeLayer, DotData, DotDataIndex)
--     local FreeLayerSkillLevel = FreeLayer.SkillLevel.SkillLevel
--     local FreeLayerValue = FreeLayer.Value 
--     local FreeLayerNum = DotData.Stackable and FreeLayer.Layer or 1
--     local DotValue = FreeLayerNum * self:CalcSingleNewFreeLayerDotDamage(FreeLayerValue, FreeLayerSkillLevel, DotDataIndex)

--     if DotData.AllowSkillIntensity then
--         DotValue = DotValue * self.SkillIntensity
--     end

--     ---@type DotInfo
--     local DotInfo = {
--         DotType = Const.BuffDotHot,
--         FinalValue = DotValue,
--     }
--     return DotInfo
-- end

-- function Component:ConstructDotSkillEffectInfo(FreeLayer, DotData, DotDataIndex)
--     ---@type DotInfo
--     local DotInfo = {
--         DotType = Const.BuffDotSkillEffect,
--     }
--     return DotInfo
-- end

-- function Component:ConstructDotSpChangeInfo(FreeLayer, DotData, DotDataIndex)
--     local Source = Battle(self.Owner):GetEntity(FreeLayer.SourceEid)
--     local SkillEfficiency = Source:GetAttrByConstrain(EAttrName.SkillEfficiency) or 0
--     local SpChange = DotData.Value * (2 - SkillEfficiency)
--     if self.BuffConfig.AllowSkillSustainModify then
--         local SkillSustain = Source:GetAttrByConstrain(EAttrName.SkillSustain) or 1
--         SpChange = SpChange / SkillSustain
--     end
--     if SpChange < 0 then 
--         -- 负数，向下取整
--         local LimitSpChange = DotData.Value * Const.SpChangeLimitPercent
--         SpChange = math.floor(math.min(SpChange, LimitSpChange))
--     else 
--         SpChange = MiscUtils.Int(SpChange)
--     end

--     ---@type DotInfo
--     local DotInfo = {
--         DotType = Const.BuffDotSpChange,
--         FinalValue = SpChange,
--     }
--     return DotInfo
-- end

-- function Component:ClearDotTimer()
--     if not self.DotTimers or #self.DotTimers == 0 then return end
--     for i = 1, #self.DotTimers do
--         self:RemoveTimer(self.DotTimers[i])
--     end
--     self.DotTimers = nil
-- end

-- function Component:HasDotEffect()
--     if not self.DotDatas then
--         return false
--     end
--     return true
-- end

-- function Component:CalcDotValue(DotData)
--     local Rate = DotData.Rate or 0
--     local Value = 0
--     if DotData.BaseAttr then
--         Value = self.Owner:GetAttr(DotData.BaseAttr) * Rate + (DotData.Value or 0)
--     else
--         Value = self.Value * Rate + (DotData.Value or 0)
--     end
--     if DotData.Stackable then
--         Value = Value * self.Layer
--     end
--     if DotData.AllowSkillIntensity then
--         Value = Value * self.SkillIntensity
--     end
--     return Value
-- end

-- -- 持续伤害
-- function Component:InitDotEffect()
--     if not self:HasDotEffect() then
--         self:ClearDotTimer()
--         return
--     end
--     if self.DotTimers then return end
--     self.DotTimers = {}

--     for i = 1, #self.DotDatas do
--         local DotData = self.DotDatas[i]
--         DotData = SkillUtils.GrowProxy('Buff', self.BuffId, self, DotData)
--         local Interval = DotData.Interval
--         local function DotEffect()
--             if not IsValid(self.Owner) then 
--                 self:ClearDotTimer() 
--                 return
--             end 

--             if self.Owner:IsDead() then 
--                 return 
--             end

--             local IsConditionMet = true
--             if DotData.Condition then
--                 local TargetEids = TArray(0)
--                 TargetEids:Add(self.SourceEid)
--                 IsConditionMet = Battle(self.Owner):CheckConditionNew(tonumber(DotData.Condition), self.Owner, TargetEids)
--             end
--             if DotData.Condition and not IsConditionMet then
--                 return
--             end

--             local DotType = string.upper(DotData.Type) 
--             if DotType == string.upper(Const.BuffDotDamage) then
--                 self:NewFreeDotDamage(DotData, i)
--             elseif DotType == string.upper(Const.BuffDotAddShield) then 
--                 self:NewFreeDotShield(DotData, i)
--             elseif DotType == string.upper(Const.BuffDotHot) then 
--                 self:NewFreeDotHot(DotData, i)
--             elseif DotType == string.upper(Const.BuffDotSkillEffect) then
--                 self:NewFreeDotSkillEffect(DotData, i)
--             elseif DotType == string.upper(Const.BuffDotSpChange) then
--                 self:NewFreeDotSpChange(DotData, i)
--             end
--         end
--         -- DebugPrint("Tianyi@ Interval = " .. Interval .. " BuffId = " .. self.BuffId)
--         local DotDelay = DotData.DotDelay or 0
--         DotDelay = DotDelay + math.random() * 0.2 - 0.1
--         self.DotTimers[i] = self:AddTimer(Interval, DotEffect, true, DotDelay)

--         -- 如果配置了立即生效一次的效果
--         if DotData.Immediately then
--             self.Owner:AddDelayFrameFunc(function()
--                 if IsValid(self) and IsValid(self.Owner) and not self.Owner:IsDead() then
--                     DotEffect()
--                 end
--             end, math.random(2, 6)) 
--         end
--     end
-- end

-- function Component:GetDotDamage()
--     local DotDamages = TArray(0.0)
--     if not self.DotTimers then
--         return DotDamages
--     end
--     for i = 1, #self.DotDatas do
--         local DotData = self.DotDatas[i]

--         local TotalValue = 0
--         for SourceEid, MergedValues in pairs(self.LayerDotInfos.MergedFinalValue) do 
--             if MergedValues and MergedValues[i] then 
--                 TotalValue = TotalValue + MergedValues[i]
--             end
--         end

--         DotDamages:Add(TotalValue)
--         -- if self.IsNewLayerBuff then 
--         --     if DotData.Type == Const.BuffDotDamage then 
--         --         self:InitNewFreeDotDamages(DotData, i) 
--         --         local TotalValue = 0
--         --         for SourceEid, DotDamage in pairs(self.CacheDotDamages[i]) do 
--         --             TotalValue = TotalValue + DotDamage
--         --         end
--         --         DebugPrint("Tianyi@ GetDotDamage: " .. TotalValue .. " DotIndex = " .. i)
--         --         DotDamages:Add(TotalValue)
--         --     end
--         -- else 
--         --     DotData = SkillUtils.GrowProxy('Buff', self.BuffId, self, DotData)
--         --     if DotData.Type == Const.BuffDotDamage then
--         --         local Value = self:CalcDotValue(DotData)
--         --         DotDamages:Add(Value)
--         --     end
--         -- end
--     end
--     return DotDamages
-- end

-- function Component:GetRemainDotDamage()
--     if not self.DotTimers then return end
--     local RemainDotDamage = 0
--     for i = 1, #self.DotDatas do
--         local DotData = self.DotDatas[i]
--         DotData = SkillUtils.GrowProxy('Buff', self.BuffId, self, DotData)
--         local SumNum = math.ceil(self.LastTime / DotData.Interval) - 1
--         local TriNum = math.max(0, math.ceil((self.LastTime - self.LeftTime) / DotData.Interval) - 1)
--         local RemainNum = SumNum - TriNum
--         if DotData.Type == Const.BuffDotDamage then
--             local Value = 0
--             for SourceEid, MergedValues in pairs(self.LayerDotInfos.MergedFinalValue) do 
--                 if MergedValues and MergedValues[i] then 
--                     Value = Value + MergedValues[i]
--                 end
--             end
--             -- DebugPrint("Tianyi@ 结算剩余伤害 BuffId: " .. self.BuffId .. " DotIndex: " .. i .. "每跳: " .. Value .. " 剩余次数: " .. RemainNum)
--             RemainDotDamage = RemainDotDamage + (Value * RemainNum)
--         end
--     end
--     return RemainDotDamage
-- end

-- function Component:DotEffectSkill(DotData)
--     Battle(self.Owner):ExecuteSkillEffectWithType(self:GetSource(), DotData.EffectId, self.Owner, nil, self)
-- end


-- function Component:CalcSingleNewFreeLayerDotDamage(LayerValue, SkillLevel, DotDataIndex)
--     local RawDotData = self.BuffConfig.DotDatas[DotDataIndex] 
--     local LayerDotData = SkillUtils.GrowProxyBySkillLevel('Buff', self.BuffId, SkillLevel, RawDotData)

--     local Rate = LayerDotData.Rate or 0
--     local Value = 0
--     if LayerDotData.BaseAttr then
--         Value = self.Owner:GetAttr(LayerDotData.BaseAttr) * Rate + (LayerDotData.Value or 0)
--     else
--         Value = LayerValue * Rate + (LayerDotData.Value or 0)
--     end

--     return Value
-- end

-- function Component:DoNewFreeDotDamage(Source, FinalValue, DotData)
--     if (not IsValid(self)) or not (IsValid(self.Owner)) then 
--         -- DebugPrint("Tianyi@ DotBuff: self or self.Owner is not valid")
--         return
--     end

--     local Battle = Battle(self.Owner)
--     local DamageType = DotData.DamageType or "Default"
--     local DamageEvent = Battle:GenDamage(Source, self.Owner, nil, self, FSkillEffectStruct())
--     DamageEvent.SourceBuff = self
--     DamageEvent.EnableIcon = DotData.EnableIcon
--     local DamageTag = DotData.DamageTag
--     if DamageTag and type(DamageTag) == 'string' then
--         DamageTag = {DamageTag}
--     end
--     local DamageTagArray = TArray(FName)
--     if DamageTag then
--         for i = 1, #DamageTag do
--             DamageTagArray:Add(DamageTag[i])
--         end
--     end
--     DamageEvent.DamageTag = DamageTagArray
--     local BaseValues = TMap(FName, 0.0)
--     BaseValues:Add(DamageType, FinalValue)
--     Battle:SetBaseValues(DamageEvent, BaseValues)
--     Battle:ApplyDamage(DamageEvent)
--     DebugPrint("Tianyi@ Apply newfree dot damage: " .. FinalValue)

--     if not self.Owner then
--         local DeadTarget = Battle:GetEntity(DamageEvent.TargetEid)
--         if DeadTarget then
--             local SeId = DataMgr.Buff[self.BuffId].DotDeathSe
--             if SeId then
--                 AudioManager(self):PlayFMODSoundByID_CPP(DeadTarget, SeId, Source)
--             end
--         end
--     end
-- end

-- function Component:DoNewFreeDotShield(Source, FinalValue, DotData)
--     if (not IsValid(self)) or not (IsValid(self.Owner)) then
--         -- DebugPrint("Tianyi@ DotBuff: self or self.Owner is not valid")
--         return
--     end

--     if FinalValue == 0 then
--         return
--     end

--     -- DebugPrint("Tianyi@ Apply newfree dot Shield: " .. FinalValue)
--     Battle(self.Owner):AddEnergyShield(Source, self.Owner, FinalValue)
-- end

-- function Component:DoNewFreeDotHot(Source, FinalValue, DotData)
--     if (not IsValid(self)) or not (IsValid(self.Owner)) then 
--         -- DebugPrint("Tianyi@ DotBuff: self or self.Owner is not valid")
--         return
--     end

--     if FinalValue <= 0 then
--         return
--     end
--     local DamageType =  DotData.DamageType or "Default"
--     local DamageEvent = Battle(self.Owner):GenDamage(Source, self.Owner, nil, self, FSkillEffectStruct())
--     DamageEvent.SourceBuff = self
--     DamageEvent.DefaultHealFX = DotData.DefaultHealFX~=0
--     local DamageTag = DotData.DamageTag
--     if DamageTag and type(DamageTag) == 'string' then
--         DamageTag = {DamageTag}
--     end
--     local DamageTagArray = TArray(FName)
--     if DamageTag then
--         for i = 1, #DamageTag do
--             DamageTagArray:Add(DamageTag[i])
--         end
--     end
--     DamageEvent.DamageTag = DamageTagArray
--     local BaseValues = TMap(FName, 0.0)
--     BaseValues:Add(DamageType, FinalValue)

--     -- DebugPrint("Tianyi@ Apply newfree Hot: " .. FinalValue)
--     Battle(self.Owner):SetBaseValues(DamageEvent, BaseValues)
--     Battle(self.Owner):ApplyHeal(DamageEvent)
-- end

-- function Component:DoNewFreeSpChange(Source, FinalValue, DotData)
--     if (not IsValid(self)) or not (IsValid(self.Owner)) then 
--         -- DebugPrint("Tianyi@ DotBuff: self or self.Owner is not valid")
--         return
--     end
--     -- local SkillEfficiency = Source:GetAttrByConstrain(EAttrName.SkillEfficiency) or 0
--     -- local SpChange = FinalValue * (2 - SkillEfficiency)
--     -- if self.BuffConfig.AllowSkillSustainModify then
--     --     local SkillSustain = Source:GetAttrByConstrain(EAttrName.SkillSustain) or 1
--     --     SpChange = SpChange / SkillSustain
--     -- end
--     -- if SpChange < 0 then 
--     --     -- 负数，向下取整
--     --     local LimitSpChange = FinalValue * Const.SpChangeLimitPercent
--     --     SpChange = math.floor(math.min(SpChange, LimitSpChange))
--     -- else 
--     --     SpChange = MiscUtils.Int(SpChange)
--     -- end

--     -- DebugPrint("Tianyi@ Apply newfree Spchange: " .. FinalValue)
--     Battle(self.Owner):AddSpToTarget(Source, self.Owner, FinalValue, EChangedSpReason.FromDotBuff)
-- end

-- -- function Component:DoNewFreeDotDamage(DotData, DotDataIndex)
-- --     if not self.CacheDotDamages then return end 
-- --     if not self.CacheDotDamages[DotDataIndex] then return end
-- --     for SourceEid, DotDamage in pairs(self.CacheDotDamages[DotDataIndex]) do 
-- --         local Source = Battle(self.Owner):GetEntity(SourceEid)
-- --         if not Source then 
-- --             DebugPrint("Tianyi@ DotDamage sourceEid is not valid")
-- --             goto continue 
-- --         end

-- --         local DamageType = DotData.DamageType or "Default"
-- --         local DamageEvent = Battle(self.Owner):GenDamage(Source, self.Owner, nil, self, FSkillEffectStruct())
-- --         DamageEvent.SourceBuff = self
-- --         DamageEvent.EnableIcon = DotData.EnableIcon
-- --         local DamageTag = DotData.DamageTag
-- --         if DamageTag and type(DamageTag) == 'string' then
-- --             DamageTag = {DamageTag}
-- --         end
-- --         local DamageTagArray = TArray(FName)
-- --         if DamageTag then
-- --             for i = 1, #DamageTag do
-- --                 DamageTagArray:Add(DamageTag[i])
-- --             end
-- --         end
-- --         DamageEvent.DamageTag = DamageTagArray
-- --         local BaseValues = TMap(FName, 0.0)
-- --         BaseValues:Add(DamageType, DotDamage)
-- --         Battle(self.Owner):SetBaseValues(DamageEvent, BaseValues)
-- --         Battle(self.Owner):ApplyDamage(DamageEvent)
-- --         DebugPrint("Tianyi@ Apply newfree dot damage: " .. DotDamage)

-- --         ::continue::
-- --     end 
-- -- end

-- -- 按照Source合并数值
-- function Component:DoNewFreeDotMergedEffect(DotData, DotDataIndex, EffectFunc)
--     if (not IsValid(self)) or not (IsValid(self.Owner)) then 
--         return
--     end

--     for SourceEid, FinalDotValues in pairs(self.LayerDotInfos.MergedFinalValue) do 
--         local Source = Battle(self.Owner):GetEntity(SourceEid)
--         if not Source then 
--             DebugPrint("Tianyi@ DotDamage sourceEid is not valid: " .. SourceEid)
--             goto continue 
--         end

--         if not FinalDotValues[DotDataIndex] then 
--             goto continue  
--         end

--         EffectFunc(self, Source, FinalDotValues[DotDataIndex], DotData)
--         ::continue::
--         if (not IsValid(self)) or not (IsValid(self.Owner)) then 
--             return
--         end
--     end 
-- end


-- function Component:NewFreeDotDamage(DotData, DotDataIndex)
--     -- self:InitNewFreeDotDamages(DotData, DotDataIndex)    
--     self:DoNewFreeDotMergedEffect(DotData, DotDataIndex, self.DoNewFreeDotDamage)
-- end

-- function Component:NewFreeDotShield(DotData, DotDataIndex)
--     -- self:InitNewFreeDotDamages(DotData, DotDataIndex)    
--     self:DoNewFreeDotMergedEffect(DotData, DotDataIndex, self.DoNewFreeDotShield)
-- end

-- function Component:NewFreeDotHot(DotData, DotDataIndex)
--     -- self:InitNewFreeDotDamages(DotData, DotDataIndex)    
--     self:DoNewFreeDotMergedEffect(DotData, DotDataIndex, self.DoNewFreeDotHot)
-- end 

-- function Component:NewFreeDotSpChange(DotData, DotDataIndex) 
--     self:DoNewFreeDotMergedEffect(DotData, DotDataIndex, self.DoNewFreeSpChange)
-- end

-- function Component:NewFreeDotSkillEffect(DotData, DotDataIndex)
--     for Uid, PerLayerInfo in pairs(self.LayerDotInfos.LayerInfos) do 
--         local Source = Battle(self.Owner):GetEntity(PerLayerInfo.SourceEid)
--         if Source then 
--             Battle(self.Owner):ExecuteSkillEffectWithType(Source, DotData.EffectId, self.Owner, nil, self)
--         else 
--             DebugPrint("Tianyi@ NewFreeDotSkillEffect Source is nil")
--         end
--     end
-- end


-- function Component:DotDamage(Value, DotData)
--     if Value <= 0 then
--         return
--     end
--     local DamageType = DotData.DamageType or "Default"
--     local DamageEvent = Battle(self.Owner):GenDamage(self:GetSource(), self.Owner, nil, self, FSkillEffectStruct())
--     DamageEvent.SourceBuff = self
--     DamageEvent.EnableIcon = DotData.EnableIcon
--     local DamageTag = DotData.DamageTag
--     if DamageTag and type(DamageTag) == 'string' then
--         DamageTag = {DamageTag}
--     end
--     local DamageTagArray = TArray(FName)
--     if DamageTag then
--         for i = 1, #DamageTag do
--             DamageTagArray:Add(DamageTag[i])
--         end
--     end
--     DamageEvent.DamageTag = DamageTagArray
--     local BaseValues = TMap(FName, 0.0)
--     BaseValues:Add(DamageType, Value)
--     Battle(self.Owner):SetBaseValues(DamageEvent, BaseValues)
--     Battle(self.Owner):ApplyDamage(DamageEvent)
-- end

-- function Component:DotShield(Value)
--     if Value == 0 then
--         return
--     end
--     -- local Source = Battle(self.Owner):GetEntity(self.SourceEid)
--     Battle(self.Owner):AddEnergyShield(self:GetSource(), self.Owner, Value)
-- end

-- function Component:DotHot(Value, DotData)
--     if Value <= 0 then
--         return
--     end
--     local DamageType =  DotData.DamageType or "Default"
--     local DamageEvent = Battle(self.Owner):GenDamage(self:GetSource(), self.Owner, nil, self, FSkillEffectStruct())
--     DamageEvent.SourceBuff = self
--     DamageEvent.DefaultHealFX = DotData.DefaultHealFX~=0
--     local DamageTag = DotData.DamageTag
--     if DamageTag and type(DamageTag) == 'string' then
--         DamageTag = {DamageTag}
--     end
--     local DamageTagArray = TArray(FName)
--     if DamageTag then
--         for i = 1, #DamageTag do
--             DamageTagArray:Add(DamageTag[i])
--         end
--     end
--     DamageEvent.DamageTag = DamageTagArray
--     local BaseValues = TMap(FName, 0.0)
--     BaseValues:Add(DamageType, Value)
--     Battle(self.Owner):SetBaseValues(DamageEvent, BaseValues)
--     Battle(self.Owner):ApplyHeal(DamageEvent)
-- end

-- function Component:DotSpChange(Value)
--     local Source = Battle(self.Owner):GetEntity(self.SourceEid)
--     if not Source then
--         return
--     end
--     -- print(_G.LogTag, "TTT Buff 应用技能修正前：", "SpChange: ", self.BuffConfig.SpChange, "LastTime: ", self.LastTime)
--     local SkillEfficiency = Source:GetAttrByConstrain(EAttrName.SkillEfficiency)
--     self.SpChange = Value * (2 - SkillEfficiency)
--     if self.BuffConfig.AllowSkillSustainModify then
--         local SkillSustain = Source:GetAttrByConstrain(EAttrName.SkillSustain)
--         if self.SpChange then
--             self.SpChange = self.SpChange / SkillSustain
--         end
--     end
--     if self.SpChange then
--         if self.SpChange < 0 then
--             -- 负数，向下取整
--             local LimitSpChange = Value * Const.SpChangeLimitPercent
--             self.SpChange = math.floor(math.min(self.SpChange, LimitSpChange))
--         else
--             self.SpChange = MiscUtils.Int(self.SpChange)
--         end
--     end
--     Battle(self.Owner):AddSpToTarget(self:GetSource(), self.Owner, self.SpChange, EChangedSpReason.FromDotBuff)
-- end

-- return Component