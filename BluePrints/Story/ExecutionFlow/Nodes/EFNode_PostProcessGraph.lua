local M = {}
local ScriptLogType = UE.EStoryLogType.Script
local FadeTime = 0.6

function M:CreateNode(Flow, TalkTask, Params)
	local GraphPath = Params.GraphPath
	local MatPath = Params.MaterailInstance
    self.bBlendIn = true          --节点是淡入还是淡出

	local TalkContext = GWorld.GameInstance:GetTalkContext()
	if (not IsValid(TalkContext)) then
		local Message = string.format("PostProcessGraph create failed: TalkContext not found, DialogueId: %d", Flow.DialogueId)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, ScriptLogType, "PostProcessGraph脚本执行出错：TalkContext无效", Message)
		return
	end

	self.DynamicInstance = nil
	self.PostProcessInfo = nil
	if not self:ProcessGraphAndMaterial(GraphPath, MatPath) then
		-- 初始化后处理材质和图片失败
		return
	end

	local FadeHandle = nil

	local PostProcessGraphNode = Flow:CreateNode(UEFNode_Delegate)
	PostProcessGraphNode.DebugLog = string.format("PostProcessGraph GraphPath: %s, MaterialInstance: %s", GraphPath, MatPath)

	PostProcessGraphNode.OnStart:Add(PostProcessGraphNode, function(Node)
		if MatPath == "None" then
			TalkContext.TalkCameraManager:SetPostProcess(MatPath)
			Node:Finish({ Node.FinishPin })
			return
		end

		if self.bBlendIn then
			if IsValid(self.DynamicInstance) then
				self.DynamicInstance:SetScalarParameterValue("Appear", 1.0)
				self.DynamicInstance:SetScalarParameterValue("CurrentTime", GWorld:GetCurrentTime())
			end
			TalkContext.TalkCameraManager:SetPostProcess_Internal(self.PostProcessInfo)
		else
			if IsValid(self.DynamicInstance) then
				self.DynamicInstance:SetScalarParameterValue("Appear", 0.0)
				self.DynamicInstance:SetScalarParameterValue("CurrentTime", GWorld:GetCurrentTime())
			end
		end
		if FadeTime > 0 then
			FadeHandle = UKismetSystemLibrary.K2_SetTimerDelegate({ Node, function()
				Node:Finish({ Node.FinishPin })
			end }, FadeTime, false)
		else
			Node:Finish({ Node.FinishPin })
		end
	end)


	PostProcessGraphNode.OnFinish:Add(PostProcessGraphNode, function(Node)
		if (FadeHandle) then
			UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(Node, FadeHandle)
			FadeHandle = nil
		end
		if not self.bBlendIn then
			TalkContext.TalkCameraManager:ClearPostProcess()
		end
	end)


	PostProcessGraphNode.OnSkip:Add(PostProcessGraphNode, function(Node)
		if self.bBlendIn then

		else

		end
		Node:Finish({ Node.FinishPin })
	end)

	return PostProcessGraphNode
end

function M:ProcessGraphAndMaterial(GraphPath, MatPath)
	-- MatPath为None时，无需其他处理
	if MatPath == "None" then
		return true
	end
	-- GraphPath为None时，节点为淡出
	local DialogueImage = nil
	local DynamicInstance = nil
	if GraphPath == "None" then
		self.bBlendIn = false
		local TalkContext = GWorld.GameInstance:GetTalkContext()
		local CachedPPInfo = TalkContext.TalkCameraManager.CachedPPInfo
		if CachedPPInfo then
			DynamicInstance = CachedPPInfo.DynamicInstance
		end
	else
		DialogueImage = UStoryFunctionLibrary.LoadResourceWithGender(GWorld.GameInstance, GraphPath, self)
		if not DialogueImage then
	        local Message = "图片资源缺失".."\n路径:"..GraphPath
	        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, ScriptLogType, "PostProcessGraph脚本执行出错：图片资源缺失", Message)
	        return false
	    end
	    local Mat = LoadObject(MatPath)
	    if not Mat then
	        local Message = "材质资源缺失"..
	        "\n路径:"..MatPath
	        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, ScriptLogType, "PostProcessGraph脚本执行出错：材质资源缺失", Message)
	        return false
	    end
		local MaterialType = Mat:GetBaseMaterial()
	    DynamicInstance = UE4.UKismetMaterialLibrary.CreateDynamicMaterialInstance(GWorld.GameInstance, Mat, "None")
	    if DynamicInstance then
	        DynamicInstance:SetTextureParameterValue("Texture", DialogueImage)
	    end
	    self.PostProcessInfo = {
	        MaterialPath = MatPath,
	        MaterialType = MaterialType,
	        DynamicInstance = DynamicInstance,
	    }
	end
    if not DynamicInstance then
    	local Message = "DynamicInstance为空"..
        "\n材质路径:"..MatPath..
        "\n图片路径:"..GraphPath
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, ScriptLogType, "PostProcessGraph脚本执行出错：材质动态实例无效", Message)
        return false
    end
    self.DynamicInstance = DynamicInstance
	return true
end

return M
