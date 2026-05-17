
---@type BP_StoryVarsObject_C
local BP_StorySubsystem_C = Class()

local VarLogType = UE.EStoryLogType.StoryVar

function BP_StorySubsystem_C:TryInitVars()
	local StoryVarsObject = self:GetStoryVarsObject()
	if not StoryVarsObject then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, VarLogType, "StorySubsystem错误: StoryVarsObject无效", "找不到StoryVarsObject，联系程序排查")
		return
	end
	StoryVarsObject:TryInitVars()
end

function BP_StorySubsystem_C:ExecuteBlueprintVarFunction(FunctionName, VarName, Vars, QuestChainId, NeedReturnBoolean)
	local VarValue = self:GetInt(VarName)
	local StoryVarsObject = self:GetStoryVarsObject()
	if not StoryVarsObject then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, VarLogType, "StorySubsystem错误: StoryVarsObject无效", "找不到StoryVarsObject，联系程序排查")
		return
	end
	local VarInfo = DataMgr.StoryVariable[VarName]
	if not VarInfo then
		local _Str = "变量:[" .. tostring(VarName) .. "]需要现在StoryVariable.xlsx中先声明"
		if QuestChainId and QuestChainId ~= 0 then
			_Str = _Str .. ",QuestChainId:[" .. tostring(QuestChainId) .. "]"
		end
		_Str = _Str .. ",请策划排查."
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, VarLogType, "StorySubsystem错误: StoryVariable表中未找到变量", _Str)
		return
	end
	if VarInfo.QuestChainId and VarInfo.QuestChainId ~= QuestChainId then
		local _Str = "变量:[" .. tostring(VarName) .. "]不能在QuestChain:[" .. tostring(QuestChainId) .. "]中使用！表里填里它只支持在QuestChain:[" .. tostring(VarInfo.QuestChainId) .. "]中使用！"
		_Str = _Str .. ",请策划排查."
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, VarLogType, "StorySubsystem错误: 需在对应QuestChain中", _Str)
		return
	end

	local ExtraVars = {
		VarName = VarName,
		VarValue = VarValue,
		QuestChainId = QuestChainId or 0,
	}
	return StoryVarsObject:ExecuteBlueprintFunction(FunctionName, Vars, ExtraVars, NeedReturnBoolean)
end


function BP_StorySubsystem_C:ExecuteBlueprintFunction(FunctionName, Vars)
	local StoryVarsObject = self:GetStoryVarsObject()
	if not StoryVarsObject then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, VarLogType, "StorySubsystem错误: StoryVarsObject无效", "找不到StoryVarsObject，联系程序排查")
		return
	end
	return StoryVarsObject:ExecuteBlueprintFunction(FunctionName, Vars)
end

return BP_StorySubsystem_C