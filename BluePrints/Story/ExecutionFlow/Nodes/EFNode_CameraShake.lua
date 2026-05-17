local M = {}
local DefaultPath = "Blueprint\'/Game/AssetDesign/Camera/CameraShake/Story/"
local ScriptLogType = UE.EStoryLogType.Script

function M:CreateNode(Flow, TalkTask, Params)
	local ShakeClassPath = Params.Path
	if not ShakeClassPath then
		local FileName = Params.FileName
		if not FileName then
			local Message = string.format("CameraShake create failed: 未填写Path或FileName, DialogueId: %d",Flow.DialogueId)
			UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, ScriptLogType, "CameraShake脚本执行失败: 文件路径错误", Message)
			return
		end
		ShakeClassPath = DefaultPath..FileName.."."..FileName.."\'"
	end
    local TalkContext = GWorld.GameInstance:GetTalkContext()

	local ShakeClass = LoadClass(ShakeClassPath)
	if ShakeClass == nil then
		local Message = string.format("CameraShake create failed: ShakeClass not found, ShakeClassPath: %d, DialogueId: %d",ShakeClassPath, Flow.DialogueId)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, ScriptLogType, "CameraShake脚本执行失败: 加载蓝图类失败", Message)
		return
	end

	local PlayerCameraManager = UE4.UGameplayStatics.GetPlayerCameraManager(GWorld.GameInstance, 0)
	if PlayerCameraManager == nil then
		local Message = string.format("CameraShake create failed: PlayerCameraManager not found, DialogueId: %d",Flow.DialogueId)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, ScriptLogType, "CameraShake脚本执行失败: 未找到PlayerCameraManager", Message)
		return
	end

	local CameraShakeNode = Flow:CreateNode(UEFNode_Delegate)
	CameraShakeNode.DebugLog = string.format("CameraShake ShakeClassPath: %s", ShakeClassPath)

    local HasCallback = false
    local CameraShakeInst = nil
	CameraShakeNode.OnStart:Add(CameraShakeNode, function(Node)
		local FinishCallback = function()
            if HasCallback then return end
            if not IsValid(Node) then return end
			TalkContext.TalkTimerManager:ClearTimer(Node)
            HasCallback = true
            Node:Finish({ Node.FinishPin })
        end
		CameraShakeInst = PlayerCameraManager:StartCameraShake(ShakeClass)
		TalkContext.TalkTimerManager:AddTimer(Node, CameraShakeInst.OscillationDuration, false, nil, nil, FinishCallback)
	end)

	CameraShakeNode.OnSkip:Add(CameraShakeNode, function(Node)
		TalkContext.TalkTimerManager:ClearTimer(Node)
        PlayerCameraManager:StopCameraShake(CameraShakeInst)
        HasCallback = true
        Node:Finish({ Node.FinishPin })
	end)

    CameraShakeNode.OnPause:Add(CameraShakeNode, function(Node)
        --暂停镜头
        TalkTask:PauseCamera(true)
        TalkContext.TalkTimerManager:PauseTimer(Node)
    end)

    CameraShakeNode.OnResume:Add(CameraShakeNode, function(Node)
        --恢复镜头
        TalkTask:PauseCamera(false)
        TalkContext.TalkTimerManager:UnPauseTimer(Node)
    end)

	return CameraShakeNode
end

return M
