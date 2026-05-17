---@type Armory_ActorController
local M = {}

function M:Init()
    self.SceneCoroutineMap = {}
    self.SceneCoroutineArray = {}
end

local PreviewSceneLoaded = {}
local IncreacePreviewSceneRefCount = function(PreviewLevelName)
    PreviewSceneLoaded[PreviewLevelName] = PreviewSceneLoaded[PreviewLevelName] or 0
    PreviewSceneLoaded[PreviewLevelName] = PreviewSceneLoaded[PreviewLevelName] + 1
end
local DecreacePreviewSceneRefCount = function(PreviewLevelName)
    if(PreviewSceneLoaded[PreviewLevelName])then
        PreviewSceneLoaded[PreviewLevelName] = PreviewSceneLoaded[PreviewLevelName] - 1
        if(PreviewSceneLoaded[PreviewLevelName] <= 0)then
            PreviewSceneLoaded[PreviewLevelName] = nil
        end
    end
end
local IsPreviewSceneHasRef = function(PreviewLevelName)
    return PreviewSceneLoaded[PreviewLevelName] and PreviewSceneLoaded[PreviewLevelName] > 0
end

local _RemoveSceneCoroutine = function(self,CoroutineName)
    local Idx = self.SceneCoroutineMap[CoroutineName]
    if(Idx)then
        table.remove(self.SceneCoroutineArray,Idx)
    end
end

local _AddSceneCoroutine = function(self,CoroutineName,Co)
    _RemoveSceneCoroutine(self,CoroutineName)
    table.insert(self.SceneCoroutineArray,Co)
    self.SceneCoroutineMap[CoroutineName] = #self.SceneCoroutineArray
end

local _FindSceneCoroutine = function(self,CoroutineName)
    local Idx = self.SceneCoroutineMap[CoroutineName]
    if(Idx)then
        return self.SceneCoroutineArray[Idx]
    end
end

local _HadAnyPreviewScene = function()
    return next(PreviewSceneLoaded) ~= nil
end


function M:GetPreviewSceneTrans()
    return self.PreviewSceneTrans
end

local GetLevelScriptActor = function(WorldLoader, PreviewLevelName)
    local PreviewLevelStreaming = WorldLoader[PreviewLevelName]
    if not PreviewLevelStreaming then
        return
    end
    local PreviewLevel = PreviewLevelStreaming:GetLoadedLevel()
    if not PreviewLevel then
        return
    end
    return PreviewLevel.LevelScriptActor
end

function M:TryLoadPreviewScene(SceneType)
    if(_HadAnyPreviewScene())then
        self.EPreviewSceneType = self.EPreviewSceneType or CommonConst.EPreviewSceneType.PreviewCommon
    end
    self.EPreviewSceneType = SceneType or self.EPreviewSceneType
    local Path = CommonConst.PreviewScenePaths[self.EPreviewSceneType]
    if(not Path)then
        return
    end
    self.PreviewSceneLocation = self.PreviewSceneLocation or FVector(190000,190000,190000)
    local PreviewLevelLocation = self.PreviewSceneLocation
    local GameMode = UE4.UGameplayStatics.GetGameMode(self.ViewUI)
    local WorldLoader = GameMode:GetLevelLoader()
    local TargetTrans
    if(WorldLoader)then
        TargetTrans = FTransform()
        TargetTrans.Translation = PreviewLevelLocation
        TargetTrans.Rotation = FRotator(0,0,0):ToQuat()
        self.PreviewSceneTrans = TargetTrans
        local PreviewLevelName = "PreviewLevel" .. self.EPreviewSceneType
        self.IsPreviewSceneLoading = true
        if(not IsPreviewSceneHasRef(PreviewLevelName))then
            local bSuccess = WorldLoader:LoadPreviewLevel(PreviewLevelName,Path,
            function()
                self.ViewUI:AddTimer(0.1,function()
                    self.ArmoryHelper:SetPreviewLevelActor(GetLevelScriptActor(WorldLoader, PreviewLevelName))
                    self:OnPreviewSceneLoaded()
                end)
            end,PreviewLevelLocation,FRotator(0,0,0))
            if(bSuccess)then
                self.PreviewLevelName = PreviewLevelName
                IncreacePreviewSceneRefCount(PreviewLevelName)
                self.bPreviewSceneLoaded = true
            else
                self.PreviewSceneTrans = nil
            end
        else
            IncreacePreviewSceneRefCount(PreviewLevelName)
            self.bPreviewSceneLoaded = true
            self.PreviewLevelName = PreviewLevelName
            self.ArmoryHelper:AddTimer(0.1,function()
                if(IsValid(self.ArmoryHelper))then
                    self.ArmoryHelper:SetPreviewLevelActor(GetLevelScriptActor(WorldLoader, PreviewLevelName))
                end
                self:OnPreviewSceneLoaded()
            end,false,0,"DelayCallSceneLoaded",true)
        end
    end
end

function M:UnloadPreviewScene()
    if(self.bPreviewSceneLoaded)then
        local PreviewLevelName = "PreviewLevel" .. self.EPreviewSceneType
        self.bPreviewSceneLoaded = false
        DecreacePreviewSceneRefCount(PreviewLevelName)
        if(not IsPreviewSceneHasRef(PreviewLevelName))then
            local GameMode = UE4.UGameplayStatics.GetGameMode(self.ViewUI)
            local WorldLoader = GameMode:GetLevelLoader()
            if(WorldLoader)then
                self:DisableEnvirSystem(true)
                local Controller = UE4.UGameplayStatics.GetPlayerController(self.ArmoryHelper,0)
                if(Controller)then
                    --手动更新相机位置，防止场景卸载时相机位置不对
                    UTalkSequenceFunctionLibrary.UpdatePlayerCameraManager(Controller)
                end
                WorldLoader:UnloadPreviewLevel("PreviewLevel"..self.EPreviewSceneType)
                if(IsValid(self.ArmoryHelper))then
                    self.ArmoryHelper:SetPreviewLevelActor(nil)
                    self.ArmoryHelper:OnPreviewSceneUnloaded()
                end
                DebugPrint("CY@ OnPreviewSceneUnloaded")
            end
        end
    end
end

function M:RefreshEnvironment()
    self.ArmoryHelper:AddTimer(0.01,function()
        local EnvironmentManager = UE4.UGameplayStatics.GetActorOfClass(self.ViewUI,UE4.AEnvironmentManager:StaticClass()) 
        if(EnvironmentManager)then
            self:DisableEnvirSystem(true)
            local Controller = UE4.UGameplayStatics.GetPlayerController(self.ArmoryHelper,0)
            if(Controller)then
                UTalkSequenceFunctionLibrary.UpdatePlayerCameraManager(Controller)
            end
            EnvironmentManager:Refresh(true)
        end
    end,false, 0, "RefreshEnvironment",true)
end



function M:GetEnvirSystemActor()
    if(IsValid(self.ArmoryHelper))then
        local PreviewLevelActor = self.ArmoryHelper:GetPreviewLevelActor()
        local EnvirSystemActor = PreviewLevelActor and PreviewLevelActor.GetEnvirSystemActor and PreviewLevelActor:GetEnvirSystemActor()
        return EnvirSystemActor
    end
end

function M:WaitForPreviewSceneLoadFinished()
    if(self.IsPreviewSceneLoading)then
        if(coroutine.isyieldable())then
            coroutine.yield()
        else
            return
        end
    end
    return true
end

function M:StartPreviewBGAnimation(PreviewBGPos,Time)
    local _StartPreviewBGAnimation = function(...)
        local bSuccess = self:WaitForPreviewSceneLoadFinished()
        if(not bSuccess)then
            return
        end
        local TargetBGLoc
        if(PreviewBGPos)then
            TargetBGLoc = FVector(PreviewBGPos[1],PreviewBGPos[2],PreviewBGPos[3])
        else
            TargetBGLoc = FVector(0,0,0)
        end
        self.ArmoryHelper:StartPreviewBGAnimation(TargetBGLoc,Time)
    end
    self:DoSomethingWithScene("StartPreviewBGAnimation",_StartPreviewBGAnimation)
end

function M:DisableEnvirSystem(bDisable)
    local _DisableEnvirSystem = function(...)
        local bSuccess = self:WaitForPreviewSceneLoadFinished()
        if(not bSuccess)then
            return
        end
        local EnvirSystemActor = self:GetEnvirSystemActor()
        if(EnvirSystemActor)then
            EnvirSystemActor.Disable = bDisable
        end
    end
    self:DoSomethingWithScene("DisableEnvirSystem",_DisableEnvirSystem)
end

function M:ChangeSkyBoxColor(Index)
    if not self.ArmoryHelper then
        return
    end
    self.ArmoryHelper.SkyBoxIndex = Index or 0
    local _CallSkyBoxChanged = function(...)
        local bSuccess = self:WaitForPreviewSceneLoadFinished()
        if not bSuccess then
            return
        end
        self.ArmoryHelper:OnSkyBoxIndexChange(self.ArmoryHelper.SkyBoxIndex)
    end
    self:DoSomethingWithScene("OnSkyBoxIndexChange", _CallSkyBoxChanged)
end

function M:DoSomethingWithScene(BehaviorName,Func,...)
    local Co = _FindSceneCoroutine(self,BehaviorName)
    if(Co)then
        local Status = coroutine.status(Co)
        if (Status == "running" or Status == "suspended") then
            coroutine.close(Co)
            _RemoveSceneCoroutine(self,BehaviorName)
        end
    end
    Co = coroutine.create(Func)
    _AddSceneCoroutine(self,BehaviorName,Co)
    coroutine.resume(Co,...)
end

function M:DoDeferedSceneBehavior()
    local SceneCoroutineArray = {}
    for _, value in ipairs(self.SceneCoroutineArray) do
        table.insert(SceneCoroutineArray,value)
    end
    self.SceneCoroutineArray = {}
    self.SceneCoroutineMap = {}
    for _, Co in ipairs(SceneCoroutineArray) do
        coroutine.resume(Co)
    end
end

---是否正在加载
function M:IsSceneActorLoading()
    return self.IsPreviewSceneLoading
end

---加载完成回调
function M:OnPreviewSceneLoaded()
    self:DisableEnvirSystem(false)
    self.IsPreviewSceneLoading = false
    self:DoDeferedSceneBehavior()
    self:UpdateSceneLighting()
end

function M:DelayUpdateSceneLighting()
    self.ArmoryHelper:AddTimer(0.03,function()
        self:UpdateSceneLighting()
    end,false,0,"DelayUpdateSceneLighting",true)
end

function M:UpdateSceneLighting()
    if(not self.bPreviewSceneLoaded)then
        return
    end
    self.bNotifyHelperUpdateLighting = false
    local _NotifyPreviewSceneUpdateLight = function(...)
        local bSuccess = self:WaitForPreviewSceneLoadFinished()
        if(not bSuccess)then
            return
        end
        UKismetSystemLibrary.ExecuteConsoleCommand(self.ViewUI,'r.Shadow.ForceCacheUpdate 1',nil)--更新阴影缓存
        local _CallBP_WaitForWeaponLoading = function()
            if(self.IsArmoryWeaponLoading)then
                self:GetWeaponActor()
            end
            self:TryNotifyHelperUpdateLighting()
        end
        self:DoSomethingWithWeapon("CallBP_WaitForWeaponLoading",_CallBP_WaitForWeaponLoading)
        local _CallBP_WaitForPlayerLoading = function()
            if(self.IsArmoryPlayerLoading)then
                self:GetPlayerActor()
            end
            self:TryNotifyHelperUpdateLighting()
        end
        self:DoSomethingWithPlayer("CallBP_WaitForPlayerLoading",_CallBP_WaitForPlayerLoading)
    end
    self:DoSomethingWithScene("NotifyPreviewSceneUpdateLight",_NotifyPreviewSceneUpdateLight)
end

function M:TryNotifyHelperUpdateLighting()
    if(self.IsArmoryWeaponLoading or self.IsArmoryPlayerLoading)then
        return
    end
    if(self.bNotifyHelperUpdateLighting)then
        return
    end
    if(IsValid(self.ArmoryHelper))then
        self.bNotifyHelperUpdateLighting = true
        self.ArmoryHelper.SkyBoxIndex = self.SkyBoxIndex or 0
        self.ArmoryHelper:UpdateDirLight(true)
        if(self.bPreviewSceneLoaded)then
            self.ArmoryHelper:UpdateLighting()
        end
    end
end

function M:SwitchArmoryCamera(IsArmoryCamera)
    if(IsArmoryCamera)then
        self.ArmoryHelper:UpdateDirLight(true)
    end
end

function M:Component_OnClosed()
    self.ArmoryHelper:UpdateDirLight(false)
end

function M:Component_DestroyActors()
    self:UnloadPreviewScene()
end

function M:Component_AfterDestroyActors()
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    if(Player)then
        Player.CharCameraComponent:SetComponentTickEnabled(true)
        if self.EPreviewSceneType then
            UKismetSystemLibrary.ExecuteConsoleCommand(Player,'r.Shadow.ForceCacheUpdate 1',nil)--更新阴影缓存
            -- URuntimeCommonFunctionLibrary.UpdateWorldLighting(Player)
        end
    end
end

return M