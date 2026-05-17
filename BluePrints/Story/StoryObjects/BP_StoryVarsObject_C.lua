
---@type BP_StoryVarsObject_C
local BP_StoryVarsObject_C = Class()

function BP_StoryVarsObject_C:TryInitVars()
	self:ClearVars()
	self:InitVars()
end

function BP_StoryVarsObject_C:InitVars()
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return false
	end
	self.InitFlag = true
	for VarName, Value in pairs(Avatar.StoryVariable) do
		local VarInfo = DataMgr.StoryVariable[VarName]
	    if VarInfo then
	    	-- PrintTable({CZC_RawSetInt=VarName,CZC_Value=Value})
	    	self:RawSetInt(VarName, Value)
	    	-- self.Overridden.SetInt(self, VarName, Value)
	    end
	end
end

function BP_StoryVarsObject_C:UpdateGlobalVariable(VarName, Value)
	local VarInfo = DataMgr.StoryVariable[VarName]
	if VarInfo and VarInfo.IsGlobal then
    	local Avatar = GWorld:GetAvatar()
    	if Avatar then
	    	if Value == nil then
	    		-- PrintTable({CZC_RemoveStoryVariable=VarName,CZC_Value=Value})
	    		Avatar:RemoveStoryVariable(VarName, Value)
	    	else
	    		-- PrintTable({CZC_UpdateStoryVariable=VarName,CZC_Value=Value})
	    		Avatar:UpdateStoryVariable(VarName, Value)
	    	end
	    end
    end
end

function BP_StoryVarsObject_C:UpdateTaskQuestExtraData(InKey, InOldValue, InNewValue)
	EventManager:FireEvent(EventID.OnCalcVarChange, InKey, InOldValue, InNewValue)
end

-- function BP_StoryVarsObject_C:ExecuteBlueprintFunction(FunctionName, Vars, ExtraVars, NeedReturnValue)
-- 	local Function = self[FunctionName]
-- 	if not Function then
-- 		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.StoryVar, "StorySubsystem错误",
-- 			"在StoryVarsObject里找不到函数[" .. tostring(FunctionName) .. "]，请任务策划排查")
-- 		return 
-- 	end
-- 	if Vars then
-- 		for Key, Value in pairs(Vars) do
-- 			self[Key] = Value
-- 		end
-- 	end
-- 	if ExtraVars then
-- 		for Key, Value in pairs(ExtraVars) do
-- 			self[Key] = Value
-- 		end
-- 	end
-- 	return Function(self)
-- end

return BP_StoryVarsObject_C