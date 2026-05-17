local CameraControlNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')


function CameraControlNode:Init()
	self.Duration = 0
	self.CameraName = ''
    self.LockRotate = false
    self.FocalLength = 0
    self.LensAperture = 0
    self.FOV = 0
    self.PPMaterialPath = ''
end

function CameraControlNode:Execute(Callback)
    DebugPrint("------------ CameraControlNode ------------------")
    local STLCameraControlInfo = {}
    _G.STLCameraControlInfo = STLCameraControlInfo
    local GameInstance = GWorld.GameInstance
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    if(Player and Player.CameraControlComponent)then
        Player.CameraControlComponent:PushCameraStateFromPreset(self.CameraName, self.Duration, 9999999)
        if(self.FOV > 0 )then
            Player.CameraControlComponent:InterpFOVByTime(self.FOV,self.Duration)
            STLCameraControlInfo.FOV = self.FOV
        end
        STLCameraControlInfo.CameraName = self.CameraName
        if(self.LockRotate)then
            local Controller = Player:GetController()
            if(Controller and Controller.AddDisableRotationInputTag)then
                Controller:AddDisableRotationInputTag("CameraControlNode")
            end
        end
        -- 禁用相机滚轮
        if(Player.CameraControlComponent.DisableArmLengthControl) then
            Player.CameraControlComponent:DisableArmLengthControl("CameraControlNode")
        end
        self.TimerHandle = GWorld.GameInstance:AddTimer(self.Duration, function()
            Callback()
        end)
        --修改后处理效果
        self:SetPPMaterial(Player.CharCameraComponent,self.PPMaterialPath,STLCameraControlInfo)
    else
        DebugPrint("Error:: CameraControlComponent Not Found")
        Callback()
    end
end

function CameraControlNode:SetPPMaterial(CameraComponent,PPMaterialPath,InOutInfo)
    if(not IsValid(CameraComponent))then
        return
    end
    if not CameraComponent then
        DebugPrint("Error::CameraControlNode: CameraComponent is nil or not PlayerCamera")
        return
    end

    if(self.FocalLength > 0 )then
        InOutInfo.OldFocalDistanceInfo = {
            bOverride_DepthOfFieldFocalDistance = CameraComponent.PostProcessSettings.bOverride_DepthOfFieldFocalDistance,
            DepthOfFieldFocalDistance = CameraComponent.PostProcessSettings.DepthOfFieldFocalDistance,
        }
        CameraComponent.PostProcessSettings.bOverride_DepthOfFieldFocalDistance = true
        CameraComponent.PostProcessSettings.DepthOfFieldFocalDistance = self.FocalLength
    end

    local Material
    if(PPMaterialPath and PPMaterialPath ~= "")then
        Material = LoadObject(PPMaterialPath)
        if not Material then
            local Message = "后处理材质不存在，路径："..PPMaterialPath
            local Title = "镜头控制节点Error：后处理材质不存在"
            UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, Title, Message)
            return
        end
    end
    local DynamicInstance = UE4.UKismetMaterialLibrary.CreateDynamicMaterialInstance(self, Material)
    if(not DynamicInstance)then
        return
    end
    InOutInfo.DynamicInstanceRef = Ref(DynamicInstance)
    InOutInfo.DynamicInstance = DynamicInstance
    CameraComponent:AddOrUpdateBlendable(DynamicInstance, 1)
end

function CameraControlNode:Clear()
    if(self.TimerHandle)then
        GWorld.GameInstance:RemoveTimer(self.TimerHandle)
    end
    self.TimerHandle = nil
end

return CameraControlNode