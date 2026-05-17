
local M = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')

function M:Init()
    self.bIsForceOpenCamera = false
    self.bGuideUIEnable = false
    self.GuideType = nil
    self._GuidePointName = ""
    self.TargetPointList = {}
    self.EventId = nil
    self.EventParams = {}
    self.Text_TargetFound = ""
    self.Text_TargetNotFound = ""
    self.bShouldSetCameraParams = false
    self.FocalLength = 0
    self.LookAtTargetName = ""
    self.BlackScreenHandle = "CameraNode"
    self.CameraUIName = "PhotoCameraMain"
    self.StartPos = ""
    self.bLockCameraPos = false
    self.bStartHiddenRole = false
    self.bLockHiddenRole = false
    self.bLockHiddenPlayer = false
    self.bStartHiddenNPC = false
    self.bLockHiddenNPC = false
    self.bStartHiddenMonster = false
    self.bLockHiddenMonster = false
    self.bStartHiddenPet = false
    self.bLockHiddenPet = false
    self.bLockGamePause = false
    self.bForceGamePause = true
    self.ForceMaxLodStaticPointList = {}
end

function M:Execute(Callback)
    local function ExecuteLogic()
        self.Callback = Callback
        DebugPrint("------------ CameraNode Execute------------------")
        local UIManager = GWorld.GameInstance:GetGameUIManager()
        if(not UIManager)then
            Callback()
            return
        end

        EventManager:AddEvent(EventID.OnInitScreenshotParams, self, self.OnInitScreenshotParams)
        
        if(self.bIsForceOpenCamera)then
            local OpenCamera = function()
                UIManager:HideCommonBlackScreen(self.BlackScreenHandle)
                UIManager:LoadUINew(self.CameraUIName)
            end

            if(self.bFadeInOut)then
                self:DisablePlayerInput(true)
                UIManager:ShowCommonBlackScreen({
                    BlackScreenHandle = self.BlackScreenHandle,
                    InAnimationObj = self,
                    InAnimationCallback = OpenCamera,
                    InAnimationPlayTime = 1,
                })
            else
                OpenCamera()
            end
        end
    end
    
    -- 如果ForceMaxLodStaticPointList有值，先执行LOD处理，然后延迟执行剩余逻辑
    if self.ForceMaxLodStaticPointList and next(self.ForceMaxLodStaticPointList) then
        self:HandleStaticPointActorsLOD(true)
        GWorld.GameInstance:AddTimer(0.05, ExecuteLogic)
    else
        ExecuteLogic()
    end
end

function M:DisablePlayerInput(bDisable)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    if(not IsValid(Player))then
        return
    end
    local PC = Player:GetController()
    if(IsValid(PC) and PC:IsA(APlayerController))then
        if(bDisable)then
            Player:AddDisableInputTag("CameraNode")
        else
            Player:RemoveDisableInputTag("CameraNode")
        end
    end
end

function M:OnInitScreenshotParams(InOutParams)
    InOutParams.TargetPointNames = self.TargetPointList

    InOutParams.EventId = self.EventId
    InOutParams.EventParams = self.EventParams
    
    InOutParams.Text_TargetFound = GText(self.Text_TargetFound)
    if(not self.Text_TargetFound or self.Text_TargetFound == "")then
        InOutParams.Text_TargetFound = GText("UI_CameraSystem_QuestSucc_Default")
    end

    InOutParams.Text_TargetNotFound = GText(self.Text_TargetNotFound)
    if(not self.Text_TargetNotFound or self.Text_TargetNotFound == "")then
        InOutParams.Text_TargetNotFound = GText("UI_CameraSystem_QuestFailed_Default")
    end

    InOutParams.StartPos = self.StartPos
    InOutParams.bLockCameraPos = self.bLockCameraPos
    InOutParams.LockHiddenList = {
        self.bLockHiddenRole and UIConst.PhotoCameraHiddenButton.Role or nil,
        self.bLockHiddenPlayer and UIConst.PhotoCameraHiddenButton.Player or nil,
        self.bLockHiddenNPC and UIConst.PhotoCameraHiddenButton.NPC or nil,
        self.bLockHiddenMonster and UIConst.PhotoCameraHiddenButton.Monster or nil,
        self.bLockHiddenPet and UIConst.PhotoCameraHiddenButton.Pet or nil,
    }
    InOutParams.bStartHiddenRole = self.bStartHiddenRole
    InOutParams.bStartHiddenPlayer = self.bStartHiddenPlayer
    InOutParams.bStartHiddenNPC = self.bStartHiddenNPC
    InOutParams.bStartHiddenMonster = self.bStartHiddenMonster
    InOutParams.bStartHiddenPet = self.bStartHiddenPet
    InOutParams.bLockGamePause = self.bLockGamePause
    InOutParams.bForceGamePause = self.bForceGamePause
    if(self.bGuideUIEnable)then
        MissionIndicatorManager:ActiveMissionIndicatorByNode(self)
        local UIManager = GWorld.GameInstance:GetGameUIManager()
        if(UIManager)then
            local TaskIndicator = UIManager:GetUIObj("TaskIndicator_"..self.Key)
            if(TaskIndicator)then
                TaskIndicator:Show("UIPopUp")
            end
        end
    end
    if(self.bShouldSetCameraParams)then
        InOutParams.FocalLength = self.FocalLength
    end
    if(self.LookAtTargetName and self.LookAtTargetName ~= "")then
        InOutParams.LookAtTargetName = self.LookAtTargetName
    end
    InOutParams.CloseCallback = function(Params)
        if(self.bIsForceOpenCamera and self.bFadeInOut)then
            local UIManager = GWorld.GameInstance:GetGameUIManager()
            if(UIManager)then
                UIManager:ShowCommonBlackScreen({
                    BlackScreenHandle = self.BlackScreenHandle,
                    OutAnimationObj = self,
                    OutAnimationCallback = function()
                        self:OnCameraUIClosed(Params)
                    end,
                    OutAnimationPlayTime = 1,
                    IsPlayOutWhenLoaded = true,
                })
            end
        else
            self:OnCameraUIClosed(Params)
        end
    end
end

function M:OnCameraUIClosed(Params)
    self:DisablePlayerInput(false)
    self:HandleStaticPointActorsLOD(false)
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    if(UIManager)then
        local TaskIndicator = UIManager:GetUIObj("TaskIndicator_"..self.Key)
        if(TaskIndicator)then
            TaskIndicator:Hide("UIPopUp")
        end
    end
    if(not Params.IsSucceeded)then
        return
    end
    self.Callback("Success")
    -- 通过 GM 触发 STLNode 进入相机拍照，退出时无法正常执行到 Clear() 函数
    self:Clear()
    self.Cleared = true
end

function M:Clear()
    if(self.Cleared)then
        return
    end

    self.Cleared = true
	EventManager:RemoveEvent(EventID.OnInitScreenshotParams, self)
    if self.bGuideUIEnable then
        MissionIndicatorManager:ReactiveMissionIndicatorByNode(self)
    end
end

-- 设置或恢复静态刷新点对应Actor的LOD
-- 该功能不能写在相机界面上，因为相机UI打开会导致游戏时间暂停，新的LOD加载不出来
-- @param bSetMaxLOD: true为设置最高LOD(PC是1,移动端是1)，false为恢复原来的LOD
function M:HandleStaticPointActorsLOD(bSetMaxLOD)
    if bSetMaxLOD then
        if not self.ForceMaxLodStaticPointList or not next(self.ForceMaxLodStaticPointList) then
            return
        end
        self.SavedLodActors = {}
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        if not IsValid(GameState) then
            return
        end
        local MaxLod = CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" and 1 or 1
        for _, StaticCreatorId in pairs(self.ForceMaxLodStaticPointList) do
            local CreatorInfo = GameState:GetStaticCreatorInfo(StaticCreatorId)
            if IsValid(CreatorInfo) then
                local Actors = UE4.URuntimeCommonFunctionLibrary.GetStaticCreatorChildActors(GWorld.GameInstance, CreatorInfo)
                for _, Actor in pairs(Actors) do
                    if IsValid(Actor) and IsValid(Actor.Mesh) and type(Actor.Mesh.SetForcedLOD) == "function" then
                        local OriginalLOD = Actor.Mesh:GetForcedLOD()
                        self.SavedLodActors[Actor] = OriginalLOD
                        Actor.Mesh:SetForcedLOD(MaxLod)
                        DebugPrint("lgc@HandleStaticPointActorsLOD(Set): StaticCreatorId = " .. tostring(StaticCreatorId) .. 
                            ", Actor = " .. Actor:GetName() .. 
                            ", OriginalLOD = " .. tostring(OriginalLOD) .. 
                            ", NewLOD = " .. tostring(MaxLod))
                        
                    end
                end
                if not Actors or Actors:Num() == 0 then
                    DebugPrint("lgc@HandleStaticPointActorsLOD(Set): 没有找到静态刷新点ID = " .. tostring(StaticCreatorId) .. " 对应的Actors")
                end
            else
                DebugPrint("lgc@HandleStaticPointActorsLOD(Set): 找不到静态刷新点ID = " .. tostring(StaticCreatorId))
            end
        end
    else
        if not self.SavedLodActors or not next(self.SavedLodActors) then
            return
        end
        for Actor, OriginalLOD in pairs(self.SavedLodActors) do
            if IsValid(Actor) and IsValid(Actor.Mesh) and type(Actor.Mesh.SetForcedLOD) == "function" then
                Actor.Mesh:SetForcedLOD(OriginalLOD)
                DebugPrint("lgc@HandleStaticPointActorsLOD(Restore): Actor = " .. Actor:GetName() .. 
                          ", RestoredLOD = " .. tostring(OriginalLOD))
            end
        end
        self.SavedLodActors = {}
    end
end

return M