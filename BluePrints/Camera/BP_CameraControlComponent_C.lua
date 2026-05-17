
require "UnLua"
local SettingUtils = require "Utils.SettingUtils"

---@type BP_CameraControlComponent_C
local M = Class()

function M:Initialize(Initializer)
    self.ViewCamera = false
    local CameraData = DataMgr.BattleCamera
    self.CameraPitchLimitMin = tonumber(CameraData.CameraPitchLimitMin.ParamentValue[1])
    self.CameraPitchLimitMax = tonumber(CameraData.CameraPitchLimitMax.ParamentValue[1])
end

function M:ReceiveBeginPlay()
    EventManager:AddEvent(EventID.OnShootCameraDistanceOptionChanged, self, self.OnShootCameraDistanceOptionChanged)
    self.OwnerPlayer = self:GetOwner()
    local Controller = self.OwnerPlayer:GetController()
    if(Controller)then
        self.CameraManager = Controller.PlayerCameraManager
    end
    self:ModifyViewPitch(self.CameraPitchLimitMin, self.CameraPitchLimitMax)
    self.Overridden.ReceiveBeginPlay(self)
    self:OnCharacterTagChanged("", self.OwnerPlayer and self.OwnerPlayer:GetCharacterTag())
    self:OnShootCameraDistanceOptionChanged(SettingUtils.GetEMCache("ShootCameraDistance", nil, false))
    
end

function M:ReceiveEndPlay(...)
    self.Overridden.ReceiveEndPlay(self,...)
    EventManager:RemoveEvent(EventID.OnShootCameraDistanceOptionChanged, self)
end

function M:CanBeControlledByTick()
    return not (self:HasRunningCameraState() or self.OwnerPlayer.IsSpawnedByMovieCaptureSequence)
end

function M:ModifyViewPitch(MinViewPitch, MaxViewPitch)
    if(not self.CameraManager)then
        return
    end
    self.CameraManager.ViewPitchMin = math.max(MinViewPitch, self.CameraPitchLimitMin)
    self.CameraManager.ViewPitchMax = math.min(MaxViewPitch, self.CameraPitchLimitMax)
end

function M:OnShootCameraDistanceOptionChanged(NewValue)
    if(self.BP_OnShootCameraDistanceOptionChanged)then
        self:BP_OnShootCameraDistanceOptionChanged(NewValue)
    end
end

return M
