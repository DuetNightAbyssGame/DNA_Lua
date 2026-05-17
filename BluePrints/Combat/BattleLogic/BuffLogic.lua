
require "DataMgr"

local Component = {}


-- function Component:CreateBuffObj(Source, BuffId, LastTime, Value, SkillLevelInfo)
-- 	-- Source: 来源
-- 	-- BuffId: Buff编号
-- 	-- LastTime: 持续时间
-- 	-- Value: 施法者参数
-- 	-- SkillLevelInfo: 技能等级参数
-- 	-- return: 状态对象

-- 	local DataBuff = DataMgr.Buff[BuffId]
-- 	if DataBuff == nil then
-- 		MiscUtils.Error("Can not find BuffId:"..tostring(BuffId))
-- 		return nil
-- 	end

-- 	local BPPath = DataBuff.BPPath or '/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff.BP_Buff'
-- 	local BPCLass = LoadClass(BPPath)
-- 	if BPCLass == nil then
-- 		MiscUtils.Error("Can not find BP:"..tostring(BPPath))
-- 		return nil
-- 	end

-- 	local BuffObj = NewObject(BPCLass, self)
-- 	if DataBuff.BPVars then
-- 		for VarName,Value in pairs(DataBuff.BPVars) do
-- 			BuffObj[VarName] = Value
-- 		end
-- 	end
-- 	BuffObj.SourceEid = Source.Eid
-- 	BuffObj.RootSourceEid = Source:GetRootSource().Eid
-- 	BuffObj.BuffId = BuffId
-- 	BuffObj.LastTime = LastTime
-- 	BuffObj.bForever = LastTime < 0
-- 	BuffObj.Layer = 1
-- 	BuffObj.SkillIntensity = Source:GetAttr('SkillIntensity')
-- 	BuffObj.Value = Value
-- 	BuffObj:SetSkillLevelInfo(SkillLevelInfo)
	
-- 	-- Tianyi@ 临时处理：NewFreeLayer类型
-- 	if DataBuff.MergeRule2 == 'NewFree' then 
-- 		self.IsNewLayerBuff = true
-- 		BuffObj:AddFreeLayer(Source.Eid, LastTime, Value, BuffObj:GetSkillLevelInfo_Lua())
-- 	end

-- 	return BuffObj
-- end

-- function Component:MakeNewFreeLayer(Source, BuffId, LastTime, Value, SkillLevelInfo)
-- 	local NewFreeLayer = UE4.FNewFreeLayer()
-- 	NewFreeLayer.SourceEid = Source.Eid
-- 	NewFreeLayer.RootSourceEid = Source:GetRootSource().Eid
-- 	NewFreeLayer.Value = Value 
-- 	NewFreeLayer.Duration = LastTime 
-- 	NewFreeLayer.SkillLevel = SkillLevelInfo

-- 	return NewFreeLayer
-- end

-- function Component:MergeBuff(BuffObj, Source, LastTime, Value, SkillLevelInfo)
-- 	-- Source: 来源
-- 	-- BuffId: Buff编号
-- 	-- LastTime: 持续时间
-- 	-- Value: 施法者参数
-- 	-- SkillLevelInfo: 技能等级参数
-- 	-- return: 状态对象
-- 	BuffObj.SourceEid = Source.Eid
-- 	BuffObj.RootSourceEid = Source:GetRootSource().Eid
-- 	BuffObj.LastTime = LastTime
-- 	BuffObj.bForever = LastTime < 0
-- 	BuffObj.Value = Value
-- 	BuffObj.IsReadyKill = false
-- 	BuffObj:SetSkillLevelInfo(SkillLevelInfo)
-- 	local DataBuff = BuffObj:GetBuffConfig()
-- 	if DataBuff.MergeRule2 == "NewFree" then 
-- 		BuffObj:AddFreeLayer(Source.Eid, LastTime, Value, BuffObj:GetSkillLevelInfo_Lua())
-- 	elseif DataBuff.MergeRule2 ~= 'Free' then
-- 		BuffObj.Layer = math.min(BuffObj.Layer + 1, BuffObj.MaxLayer)
-- 	end
-- 	BuffObj:Refresh()
	
-- 	return BuffObj
-- end

-- -- TODO: 等Free类型Buff全部替换为NewFree后，迁移至C++ @Tianyi
-- function Component:AddBuffToTarget(Source, Target, BuffId, LastTime, Value, SkillLevelSource, Num, Refresh)
-- 	-- Source: 施法者
-- 	-- Target: 目标
-- 	-- BuffId: 状态编号
-- 	-- LastTime：状态持续时间
-- 	-- Value: 施法者参数
-- 	-- SkillLevelSource: 技能等级来源
-- 	-- Num：状态数量
-- 	-- return: 状态对象，同时表明是否添加成功

-- 	if not self:CanExecute() then
-- 		return TArray(UBuff)
-- 	end

-- 	if not IsValid(Target) or Target:IsDead() then
-- 		return TArray(UBuff)
-- 	end

-- 	if not Num then
-- 		Num = 1
-- 	end

-- 	if Refresh == nil then
-- 		Refresh = true
-- 	end

-- 	BuffId = tonumber(BuffId)

-- 	if not self:CheckForbidBuffType(Target, BuffId) then
-- 		return TArray(UBuff)
-- 	end

-- 	LastTime = tonumber(LastTime)
-- 	-- self.Overridden.AddBuffToTarget(self, Source, Target, BuffId, LastTime, Value, SkillLevelSource)
-- 	-- PrintTable({AddBuffToTarget=1,Source=Source,Target=Target,BuffId=BuffId})
-- 	local SkillLevelInfo = nil
-- 	if SkillLevelSource then
-- 		SkillLevelInfo = SkillLevelSource:GetSkillLevelInfo_Lua()
-- 	end
-- 	local DataBuff = DataMgr.Buff[BuffId]
-- 	assert(DataBuff, 'AddBuffToTarget填写的BuffId:[' .. tostring(BuffId) .. ']有误')
-- 	local SourceEid = 0
-- 	if DataBuff.MergeRule1 == 'Personal' then
-- 		SourceEid = Source.Eid
-- 	end
-- 	local RetBuffs = TArray(UBuff)
-- 	for i = 1, Num do
-- 		local FindBuffObj, BuffNum = self:CheckBuffMerge(Target, BuffId, SourceEid, DataBuff)
-- 		if not FindBuffObj then
-- 			local BuffObj = self:CreateBuffObj(Source, BuffId, LastTime, Value, SkillLevelInfo)
-- 			if not BuffObj then 
-- 				return TArray(UBuff)
-- 			end
-- 			Target:RawAddBuff(BuffObj, Refresh or false)
-- 			RetBuffs:Add(BuffObj)
-- 			FindBuffObj = BuffObj
-- 		elseif not DataBuff.HaloBuff then
-- 			-- 如果已经有buff，且叠加规则是覆盖或者叠层，则修改buff属性
-- 			FindBuffObj = self:IncreaseBuffLayerFromTarget(FindBuffObj, Source, LastTime, Value, SkillLevelInfo)
-- 			if FindBuffObj and Refresh then
-- 				Target:RefreshBuff()
-- 			end
-- 			RetBuffs:AddUnique(FindBuffObj)
-- 		end
-- 		self:RemoveBuffBecauseOfIncompatibleBuff(Target, BuffId)
-- 		self:TryAddFreeLayerExtraBuff(Source, Target, BuffNum and BuffNum + 1, BuffId, FindBuffObj, Refresh)
-- 	end

-- 	local PassiveOwner = Source:GetRootSource()
-- 	if PassiveOwner:IsPlayer() then
-- 		self:TriggerBattleEvent(BattleEventName.OnAddBuffToOther, PassiveOwner, Target, BuffId, RetBuffs:Num())
-- 	end

-- 	return RetBuffs
-- end

-- 将BuffObj的数据加到新Target上，目前只适用于水母叠层!
-- function Component:CopyBuffToTarget(Source, Target, BuffObj, Refresh) 
-- 	if not self:CanExecute() then
-- 		return TArray(UBuff)
-- 	end

-- 	if not IsValid(Target) or Target:IsDead() then
-- 		return TArray(UBuff)
-- 	end

-- 	local BuffId = BuffObj.BuffId 
-- 	local SourceEid = Source.Eid   
-- 	local DataBuff = DataMgr.Buff[BuffId]
-- 	local SkillLevelInfo = BuffObj:GetSkillLevelInfo_Lua()

-- 	if DataBuff.MergeRule2 ~= 'NewFree' then 
-- 		DebugPrint("Tianyi@ 目前只有新结构支持叠层") 
-- 		return TArray(UBuff)
-- 	end

-- 	local RetBuffs = TArray(UBuff)
-- 	local FindBuffObj, BuffNum = self:CheckBuffMerge(Target, BuffId, SourceEid, DataBuff)
-- 	if not FindBuffObj then
-- 		local NewBuffObj = self:CreateBuffObj(Source, BuffId, BuffObj.LastTime, BuffObj.Layer, SkillLevelInfo)
-- 		if not NewBuffObj then 
-- 			return TArray(UBuff)
-- 		end
-- 		NewBuffObj:ClearFreeLayer()
-- 		NewBuffObj:MergeFreeLayers(BuffObj:GetFreeLayers())
-- 		Target:RawAddBuff(NewBuffObj, Refresh or false)
-- 		RetBuffs:Add(NewBuffObj)
-- 		FindBuffObj = NewBuffObj
-- 	else
-- 		-- 如果已经有buff，且叠加规则是覆盖或者叠层，则修改buff属性
-- 		FindBuffObj:MergeFreeLayers(BuffObj:GetFreeLayers())
-- 		if FindBuffObj and Refresh then
-- 			Target:RefreshBuff()
-- 		end
-- 		RetBuffs:AddUnique(FindBuffObj)
-- 	end

-- 	local PassiveOwner = Source:GetRootSource()
-- 	if PassiveOwner:IsPlayer() then
-- 		self:TriggerBattleEvent(BattleEventName.OnAddBuffToOther, PassiveOwner, Target, BuffId, RetBuffs:Num())
-- 	end
-- 	return RetBuffs
-- end

-- function Component:CheckBuffMerge(Target, BuffId, SourceEid, DataBuff)
-- 	-- 如果不是Free，表示要Merge，找出第一个进行Merge
-- 	if DataBuff.MergeRule2 ~= 'Free' then
-- 		local FindBuffObj = self:FindBuffById(Target, BuffId, SourceEid)
-- 		return FindBuffObj
-- 	end
-- 	-- 如果是Free
-- 	if DataBuff.MergeRule2 == 'Free' then
-- 		-- 如果有最大叠加层数
-- 		if DataBuff.MaxLayer then
-- 			local BuffNum, FindBuffObj = self:FindMinLeftTimeBuffById(Target, BuffId, SourceEid)
-- 			-- PrintTable({Buff=FindBuffObj, BuffNum=BuffNum})
-- 			-- 并且当前buff数量已经达到最大层数了
-- 			if BuffNum >= DataBuff.MaxLayer then
-- 				-- 就Merge剩余时间最短的那个
-- 				return FindBuffObj, BuffNum
-- 			end
-- 			return nil, BuffNum
-- 		end
-- 	end

-- 	return nil, 0
-- 	-- 其他情况，都不Merge
-- end

-- function Component:CheckForbidBuffType(Target, BuffId)
-- 	if not Target or not IsValid(Target) then
-- 		return false
-- 	end

-- 	if not Target.BuffManager then
-- 		return false
-- 	end

-- 	if not Target.BuffManager.ForbidBuffTypes then
-- 		return true
-- 	end

-- 	local BuffData = DataMgr.Buff[BuffId]

-- 	if not BuffData.BuffType then
-- 		return true
-- 	end

-- 	for _, BuffType in pairs(BuffData.BuffType) do
-- 		BuffType = tonumber(BuffType)
-- 		if Target.BuffManager.ForbidBuffTypes[BuffType] then
-- 			return false
-- 		end
-- 	end

-- 	return true
-- end

-- function Component:FindBuffById(Target, BuffId, SourceEid, bUseRootEid)
-- 	if not Target or not IsValid(Target) then
-- 		return
-- 	end
	
-- 	return Target:FindBuffById(BuffId, SourceEid, bUseRootEid)
-- end

-- BuffId为0，表示所有buff
-- SourceEid为0，表示所有来源
-- function Component:FindBuffsById(Target, BuffId, SourceEid, bUseRootEid)
-- 	if not Target or not IsValid(Target) then
-- 		return
-- 	end
	
-- 	return Target:FindBuffsById(BuffId, SourceEid, bUseRootEid)
-- end

-- function Component:FindBuffsByBuffType(Target, BuffType, SourceEid, bUseRootEid)
-- 	if not Target or not IsValid(Target) then
-- 		return
-- 	end
	
-- 	return Target:FindBuffsByBuffType(BuffType, SourceEid, bUseRootEid)
-- end

-- function Component:FindMinLeftTimeBuffById(Target, BuffId, SourceEid)
-- 	if not Target or not IsValid(Target) then
-- 		return
-- 	end
	
-- 	local BuffNum, BuffObj = Target:FindMinLeftTimeBuffById(BuffId, SourceEid)
-- 	return BuffNum, BuffObj
-- end

-- function Component:FindBuffSpecialEffect(Target, StateName)
-- 	if not Target or not IsValid(Target) then
-- 		return
-- 	end
	
-- 	if not Target.BuffManager then
-- 		return false
-- 	end

-- 	return Target.BuffManager.SpecialEffects[StateName]
-- end

function Component:PrintBuff(Target)
	local Buffs = Target.BuffManager.Buffs
	local t = {Target = {Target}, BuffNum = Buffs:Length()}
	if Buffs:Length() > 0 then
		for i=1, Buffs:Length() do
			local Buff = Buffs:GetRef(i)
			t[i] = {
				BuffId = Buff.BuffId,
				SourceEid = Buff.SourceEid,
				StartTime = Buff.StartTime,
				Value = Buff.Value,
				Layer = Buff.Layer,
				LeftTime = Buff.LeftTime,
			}

			local Layers = Buff:GetFreeLayers()
			local LayerNum = Layers:Num()
			t[i].NewFreeLayerNum =  LayerNum
			t[i].NewFreeLayers = {}
			for j = 1, LayerNum do 
				local NewFreeLayer = Layers:GetRef(j)
				table.insert(t[i].NewFreeLayers, {
					StartTime = NewFreeLayer.StartTime,
					LastTime = NewFreeLayer.LastTime, 
					Value = NewFreeLayer.Value, 
					SourceEid = NewFreeLayer.SourceEid
				})
			end

		end
	end
	PrintTable(t, 5)
end

-- function Component:RemoveBuffBecauseOfIncompatibleBuff(Target, BuffId)
-- 	if not DataMgr.AntiBuff2BuffList[BuffId] then return end
-- 	local IncompatibleBuffList = DataMgr.AntiBuff2BuffList[BuffId]
-- 	local BuffObject = self:FindBuffById(Target, BuffId, 0)
-- 	if not BuffObject then return end
-- 	local BuffList = {}
-- 	for i, IncompatibleBuffId in ipairs(IncompatibleBuffList) do
-- 		local FindBuffObj = self:FindBuffById(Target, IncompatibleBuffId, 0)
-- 		if FindBuffObj then
-- 			BuffObject.IsReadyKill = true
-- 			FindBuffObj.IsReadyKill = true
-- 			table.insert(BuffList, BuffObject.UniqueId)
-- 			table.insert(BuffList, FindBuffObj.UniqueId)
-- 			FindBuffObj:OnBuffTriggerIncompatibleBuff(BuffObject)
-- 			BuffObject:OnBuffTriggerIncompatibleBuff(FindBuffObj)
-- 			break
-- 		end
-- 	end
-- 	if BuffList then
-- 		for _, UniqueId in ipairs(BuffList) do
-- 			self:RemoveUniqueBuffFromTarget(Target, UniqueId)
-- 		end
-- 	end
-- end

-- function Component:RemoveBuffFromTarget(Source, Target, BuffId, BySource, BuffNum)
-- 	-- Source: 施法者
-- 	-- Target: 目标
-- 	-- BuffId: 状态编号
-- 	-- BySource: 通过直接来源 Eid 移除
-- 	-- 移除数量
-- 	-- return: 是否成功

-- 	if BuffNum == 0 then
-- 		return false
-- 	end
-- 	if not BuffNum then
-- 		BuffNum = -1
-- 	end

-- 	if not self:CanExecute() then
-- 		return false
-- 	end

-- 	if not IsValid(Target) then
-- 		return false
-- 	end

-- 	BuffId = tonumber(BuffId)
-- 	-- self.Overridden.RemoveBuffFromTarget(self, Source, Target, BuffId)
-- 	-- PrintTable({RemoveBuffFromTarget=1,Source=Source,Target=Target,BuffId=BuffId})
-- 	local SourceEid = 0
-- 	local DataBuff = DataMgr.Buff[BuffId]
-- 	assert(DataBuff, 'RemoveBuffFromTarget填写的BuffId:[' .. tostring(BuffId) .. ']有误')
-- 	if BySource or DataBuff.HaloBuff then
-- 		SourceEid = Source.Eid
-- 		-- print(_G.LogTag, "TTT 根据角色 Eid 移除：", SourceEid)
-- 	end
	
-- 	local bRet = false
-- 	local BuffObj = self:FindBuffById(Target, BuffId, SourceEid)
-- 	while BuffObj ~= nil do
-- 		bRet = Target:RawRemoveBuff(BuffObj) or bRet
-- 		if not bRet then
-- 			BuffObj = nil
-- 		elseif BuffNum > 0 then
-- 			BuffNum = BuffNum - 1
-- 			if BuffNum == 0 then
-- 				break
-- 			end
-- 		end
-- 		BuffObj = self:FindBuffById(Target, BuffId, SourceEid)
-- 	end

-- 	return bRet
-- end

-- function Component:RemoveBuffFromTargetByBuffType(Source, Target, BuffType, BySource, BuffNum)
-- 	-- Source: 施法者
-- 	-- Target: 目标
-- 	-- BuffType: BuffType
-- 	-- BySource: 通过直接来源 Eid 移除
-- 	-- 移除数量
-- 	-- return: 是否成功
-- 	if BuffNum == 0 then
-- 		return
-- 	end

-- 	if not BuffNum then
-- 		BuffNum = -1
-- 	end

-- 	if not self:CanExecute() then
-- 		return
-- 	end

-- 	if not IsValid(Target) then
-- 		return
-- 	end

-- 	BuffType = tonumber(BuffType)

-- 	local SourceEid = 0
-- 	if BySource then
-- 		SourceEid = Source.Eid
-- 	end

-- 	local Buffs = self:FindBuffsByBuffType(Target, BuffType, SourceEid)
-- 	if not Buffs or Buffs:Num() == 0 then
-- 		return
-- 	end

-- 	local bRet = false
-- 	for i = 1, Buffs:Num() do
-- 		local BuffObj = Buffs:GetRef(i)
-- 		bRet = Target:RawRemoveBuff(BuffObj) or bRet
-- 		if bRet and BuffNum > 0 then
-- 			BuffNum = BuffNum - 1
-- 			if BuffNum == 0 then
-- 				break
-- 			end
-- 		end
-- 	end

-- 	return bRet
-- end

-- function Component:RemoveUniqueBuffFromTarget(Target, UniqueId)
-- 	-- Source: 施法者
-- 	-- Target: 目标
-- 	-- UniqueId: 状态唯一编号
-- 	-- return: 是否成功
-- 	if not self:CanExecute() then
-- 		return
-- 	end
	
-- 	local BuffObj = Target:FindBuffByUniqueId(UniqueId)
-- 	if BuffObj == nil then
-- 		return false
-- 	end

-- 	-- PrintTable({RemoveUniqueBuffFromTarget=1,Source=Source,Target=Target,BuffId=BuffObj.BuffId,UniqueId=UniqueId})
-- 	local Success = Target:RawRemoveBuff(BuffObj)
-- 	return Success
-- end

-- function Component:ReduceBuffLayerFromTarget(Source, Target, BuffId, Layer)
-- 	if not self:CanExecute() then
-- 		return false
-- 	end
-- 	if Layer < 0 then
-- 		return false
-- 	end
-- 	local DataBuff = DataMgr.Buff[BuffId]
-- 	assert(DataBuff, 'ReduceBuffLayerFromTarget填写的BuffId:[' .. tostring(BuffId) .. ']有误')
-- 	if DataBuff.MergeRule2 ~= "Merge" then
-- 		return false
-- 	end
-- 	local Buffs = self:FindBuffsById(Target, BuffId, Source and Source.Eid or 0)
-- 	if not Buffs or Buffs:Length() == 0 then
-- 		return false
-- 	end
-- 	for i = 1, Buffs:Length() do
-- 		---@type BP_Buff_C
-- 		local BuffObj = Buffs:GetRef(i)
-- 		if BuffObj.Layer <= Layer or BuffObj.Layer <= 1 then
-- 			self:RemoveUniqueBuffFromTarget(Target, BuffObj.UniqueId)
-- 		else
-- 			BuffObj.Layer = BuffObj.Layer - Layer
-- 			BuffObj:Refresh(true)
-- 			Target:RefreshBuff()
-- 		end
-- 	end
-- 	return true
-- end

-- function Component:ChangeBuffLastTime(Target, BuffId, SourceEid, LastTimeValue, bIsExpand)
-- 	if not self:CanExecute() then
-- 		return false
-- 	end
-- 	BuffId = tonumber(BuffId)
-- 	local Buffs = self:FindBuffsById(Target, BuffId, SourceEid)
-- 	if not Buffs or Buffs:Length() == 0 then
-- 		return false
-- 	end

-- 	local CalStartTime = function(InBuff)
-- 		local Now = UGameplayStatics.GetTimeSeconds(self)
-- 		local PassTime = Now - InBuff.StartTime
-- 		InBuff.LastTime = LastTimeValue + PassTime
-- 	end

-- 	for i = 1, Buffs:Length() do
-- 		local Buff = Buffs:GetRef(i)
-- 		if LastTimeValue == -1 then
-- 			Buff.LastTime = -1
-- 			Buff.bForever = true
-- 		elseif Buff.LastTime == -1 and LastTimeValue ~= -1 then
-- 			Buff.bForever = false
-- 			CalStartTime(Buff)
-- 		else
-- 			Buff.bForever = false
-- 			if bIsExpand then
-- 				Buff.LastTime = Buff.LastTime + LastTimeValue
-- 			else
-- 				CalStartTime(Buff)
-- 			end
-- 		end

-- 		Target:RefreshBuff()
-- 	end
	
-- 	return true
-- end

-- ---@param Buff BP_Buff_C
-- function Component:TryAddFreeLayerExtraBuff(Source, Target, BuffNum, BuffId, Buff, Refresh)
-- 	local BuffData = DataMgr.Buff[BuffId]
-- 	if not BuffNum or BuffData.MergeRule2 ~= "Free" or not BuffData.LayerExtraBuff then
-- 		return
-- 	end
-- 	for Layer, ExtraBuffId in pairs(BuffData.LayerExtraBuff) do
-- 		if BuffNum >= Layer then
-- 			local Buffs = Battle(self):AddBuffToTarget(Source, Target, ExtraBuffId, -1, Buff.Value, Buff, 1, Refresh)
-- 			if Buffs and Buffs:Num() > 0 then
-- 				local FreeBuffs = self:FindBuffsById(Target, BuffData.BuffId)
-- 				for k, v in pairs(FreeBuffs) do
-- 					v.LayerUniqueId[Layer] = Buffs:GetRef(1).UniqueId
-- 				end
-- 			end
-- 		end
-- 	end
-- end

return Component