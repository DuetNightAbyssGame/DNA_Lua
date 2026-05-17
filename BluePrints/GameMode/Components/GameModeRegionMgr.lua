require"UnLua"
require "Utils"
local SpecialLoadingRule = require "Utils.LoadingUtils"

local GameModeRegionMgr = {}


function GameModeRegionMgr:GetLevelGamemModeAndLevelName(SubRegionId)
    local LevelName = self:GetLevelLoader():GetLevelIdByRegionId(SubRegionId)
    return LevelName, self.SubGameModeInfo:FindRef(LevelName)
end

function GameModeRegionMgr:IsWorldLoader(LevelLoader)
    LevelLoader = LevelLoader or self:GetLevelLoader()
    return IsValid(LevelLoader) and LevelLoader.IsWorldLoader
end

function GameModeRegionMgr:SetEnterLevelStateReady()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then 
        return 
    end
    Avatar:SetEnterLevelStateReady()
end

function GameModeRegionMgr:SaveQuestData(RegionId)
	if IsStandAlone(self) then
		local Avatar = GWorld:GetAvatar()
		if Avatar then
			Avatar:UpdateRegionData(RegionId, UE4.ERegionDataType.RDT_QuestData)
		end
	elseif IsDedicatedServer(self) then
		print(_G.LogTag,"ZJT_ IsDedicatedServer Not Do ")
	end
end

function GameModeRegionMgr:SaveCommonData(RegionId)
    if IsStandAlone(self) then
		local Avatar = GWorld:GetAvatar()
		if Avatar then
			Avatar:UpdateRegionData(RegionId, UE4.ERegionDataType.RDT_CommonData)
		end
	elseif IsDedicatedServer(self) then
		print(_G.LogTag,"ZJT_ IsDedicatedServer Not Do")
	end
end

function GameModeRegionMgr:SaveRarelyData(RarelyId)
    print(_G.LogTag,"ZJT_ IsDedicatedServer Not Do")
end


-----------------------------------传送相关---------------------------------------
function GameModeRegionMgr:HandleLevelDeliverBlackCurtainEnd()
	-- local func = function()
        AudioManager(self):SetEventSoundParam(self, "Loading", { ToEnd = 1 })
        AudioManager(self):ResumePlayBGMCauseIsLoadingOrBlackScreen()
        local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
        Player:RemoveDisableInputTag("DeliverBlackCurtain")
        DebugPrint("HandleLevelDeliverBlackCurtainEnd CB1")
        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
        local UIManager = GameInstance:GetGameUIManager()
        -- self:CloseCurUI()
        local TaskIndicator = UIManager:GetUIObj("MainTaskIndicator")
        UIManager:HideCommonBlackScreen("HandleLevelDeliverBlackCurtain")
        local UI = UIManager:GetUIObj("BlackScreenXiaobai")
        if UI then
            local SceneMgrComponent = GameInstance:GetSceneManager()
            local function UnLoadingUI()
                TaskIndicator = UIManager:GetUIObj("MainTaskIndicator")
                if IsValid(TaskIndicator) then
                    TaskIndicator:SetVisibility(UE4.ESlateVisibility.Visible)
                end
                SceneMgrComponent = GameInstance:GetSceneManager()
                SceneMgrComponent:ShowOrHideAllSceneGuideIcon(true)
                UI:UnbindAllFromAnimationFinished(UI.Out)
                --UIManager:UnLoadUINew("BlackScreenXiaobai")
                local UI = UIManager:GetUIObj("BlackScreenXiaobai")
                if UI then
                    UI:CloseUI()
                    --UIManager:UnLoadUINew("BlackScreenXiaobai")
                end
                EventManager:FireEvent(EventID.OnLevelDeliverBlackCurtainEnd, Player.Eid)
            end
            UI:BindToAnimationFinished(UI.Out, {UI, UnLoadingUI})
            UI:PlayAnimationForward(UI.Out, 1.0, true)
            if not UI.Out then
                UnLoadingUI()
            end
        end
        local UnLoadingCallback = function() 
            TaskIndicator = UIManager:GetUIObj("MainTaskIndicator")
            if IsValid(TaskIndicator) then
                TaskIndicator:SetVisibility(UE4.ESlateVisibility.Visible)
            end
            local SceneMgrComponent = GameInstance:GetSceneManager()
            SceneMgrComponent:ShowOrHideAllSceneGuideIcon(true)
        end
        if self.WidgetLoading then 
            if self.WidgetLoading.CloseUI then 
                self.WidgetLoading:CloseUI(UnLoadingCallback)
            else 
                self.WidgetLoading:RemoveFromParent()
                UnLoadingCallback()
            end
            self.WidgetLoading = nil
        end
        local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
        if IsValid(PlayerCharacter) then
            PlayerCharacter:DisablePlayerInputInDeliver(false)
        end
        EventManager:FireEvent(EventID.OnLevelDeliverBlackCurtainEnd, PlayerCharacter.Eid)
	-- end 
	-- self:AddTimer(DataMgr.GlobalConstant.DeliveryBlackCurtainTime.ConstantValue, func, false, 0, "HandleLevelDeliver", true)
end

function GameModeRegionMgr:CloseCurUI()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    local UITable = UIManager.CurrentUIList:ToTable()
    for i = #UITable, 1, -1 do
        local Name = UITable[i]
        local SystemUI = UIManager:GetUI(Name)
        if SystemUI and SystemUI.GetUIConfigName then
            local SystemUIConfig = DataMgr.SystemUI[SystemUI:GetUIConfigName()]
            local UnloadCheck = true
            if SystemUIConfig then
                if (SystemUIConfig.System == "Battle" or SystemUIConfig.System == "Common" or SystemUIConfig.System == "Story") then
                    UnloadCheck = false
                end
            end
            if Name == "CommonBlackScreen" or Name == "BlackScreenXiaobai" or Name == "SceneStartUI" or Name == "SelectRole" then
                UnloadCheck = false
            end
            -- 关卡指引和关卡指引主Widget
            if Name == "GuideIconMain" or SystemUI.IsDungeonIndicator then
                UnloadCheck = false
            end
            -- 邀约需要在跳转结束后重新打开
            if Name == "Entertainment" then
                UnloadCheck = false
            end
            -- 开车对话UI
            if Name == "TalkGuideUI" then
                UnloadCheck = false
            end
            -- 剧院倒计时
            if Name == "TheaterTaskTime" then
                UnloadCheck = false
            end
            -- 剧院游戏
            if Name == "TheaterToast" then
                UnloadCheck = false
            end
            if UnloadCheck then
                DebugPrint('HandleLevelDeliverBlackCurtainEnd Systemui Close:', Name)
                SystemUI:Close()
            end
        end
    end
end

function GameModeRegionMgr:InterruptBlackCurtainEnd()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    local UI = UIManager:GetUIObj("CommonBlackScreen")
    if not UI then
        UI = UIManager:GetUIObj("BlackScreenXiaobai")
    end
    if not UI then
        return
    end
    if UI:IsAnimationPlaying(UI.FadeOutAnimation) then
        UI:StopAnimation(UI.FadeOutAnimation)
    end
end

function GameModeRegionMgr:HandleLevelDeliverBlackCurtainStart(IsWhite, IsFromMap)
    DebugPrint("HandleLevelDeliverBlackCurtainStart")
    AudioManager(self):PlayUISound(self, "event:/ui/common/loading_common", "Loading", nil)
    AudioManager(self):PausePlayBGMCauseIsLoadingOrBlackScreen()
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if IsValid(PlayerCharacter) then
        PlayerCharacter:DisablePlayerInputInDeliver(true)
    end
    EventManager:FireEvent(EventID.OnLevelDeliverBlackCurtainStart)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
	local UIManager = GameInstance:GetGameUIManager()
    local OldUI = UIManager:GetUIObj("CommonBlackScreen")
	local SceneMgrComponent = GameInstance:GetSceneManager()
    if OldUI then
        -- UIManager:UnLoadUINew("CommonBlackScreen")
        UIManager:CloseCommonBlackScreenWithoutCB("HandleLevelDeliverBlackCurtain")
        local TaskIndicator = UIManager:GetUIObj("MainTaskIndicator")
        if IsValid(TaskIndicator) then
            TaskIndicator:SetVisibility(UE4.ESlateVisibility.Visible)
        end
        SceneMgrComponent = GameInstance:GetSceneManager()
        SceneMgrComponent:ShowOrHideAllSceneGuideIcon(true)
        -- OldUI:UnbindAllFromAnimationFinished(OldUI.FadeOutAnimation)
    end
    OldUI = UIManager:GetUIObj("BlackScreenXiaobai")
    if OldUI then
        OldUI:CloseUI()
        --UIManager:UnLoadUINew("BlackScreenXiaobai")
    end
    local LoadingData, SpecialLoadingBp = SpecialLoadingRule:GetLoadingBpPath(false)
    if SpecialLoadingBp then 
        local WidgetLoading = UIManager:CreateWidget(SpecialLoadingBp)
        local SystemUIConfig = DataMgr.SystemUI["BlackScreenXiaobai"]
        WidgetLoading:AddToViewport(SystemUIConfig and SystemUIConfig.ZOrder or 105)
        if WidgetLoading.InitLoadingData then 
            WidgetLoading:InitLoadingData(LoadingData, nil)
        end
        self.WidgetLoading = WidgetLoading
    else 
        if not IsFromMap then
            local Params = {}
            Params.BlackScreenHandle = "HandleLevelDeliverBlackCurtain"
            Params.ScreenColor = IsWhite and "White" or "Black"
            Params.OutAnimationPlayTime = 0.5
            Params.OutAnimationObj = self
            Params.OutAnimationCallback = function()
                local SceneMgrComponent = GameInstance:GetSceneManager()
                local TaskIndicator = UIManager:GetUIObj("MainTaskIndicator")
                if IsValid(TaskIndicator) then
                    TaskIndicator:SetVisibility(UE4.ESlateVisibility.Visible)
                end
                SceneMgrComponent = GameInstance:GetSceneManager()
                SceneMgrComponent:ShowOrHideAllSceneGuideIcon(true)
                EventManager:FireEvent(EventID.OnLevelDeliverBlackCurtainEnd, PlayerCharacter.Eid)
            end
            UIManager:ShowCommonBlackScreen(Params)
            -- local UI = UIManager:LoadUINew("CommonBlackScreen", IsWhite)
            -- if UI then
                -- UI.CanvasPanel_0:SetRenderOpacity(1.0)
                -- UI.VX_smoke:SetVisibility(UE4.ESlateVisibility.Hidden)
                -- UI:PlayAnimationForward(UI.FadeInAnimation, 1.0, true)
            -- end
        else
            local UI = UIManager:LoadUINew("BlackScreenXiaobai", IsWhite)
            UI.bUseFakeProgress = true;
        end
    end
	SceneMgrComponent:ShowOrHideAllSceneGuideIcon(false)
	local TaskIndicator = UIManager:GetUIObj("MainTaskIndicator")
	if IsValid(TaskIndicator) then
		TaskIndicator:SetVisibility(UE4.ESlateVisibility.Collapsed)
	end
    PlayerCharacter:ResetIdle()
    if self:IsExistTimer("HandleLevelDeliver", true) then
        self:RemoveTimer("HandleLevelDeliver", true)
    end
end

function GameModeRegionMgr:StopLimitTimeExploreGroup()
    --使用场景：同区域传送时，如果有正在进行的挑战类探索组，令其失败
    if self.EMGameState.ActiveLimitTimeExploreGroup == 0 then
        return
    end
    local ExploreGroup = self.EMGameState.ExploreGroupMap:FindRef(self.EMGameState.ActiveLimitTimeExploreGroup)
    ExploreGroup:FailLimitExplore()
end

function GameModeRegionMgr:AsyncSetPlayerByStartIndex(LoadLevel, LevelId, StartIndex, IsOpenSync, IsWhite, IsFromMap)
	-- todo @fanyuxiao 在这里直接截断了， 等WC全面接入之后替换这个函数
    self:HandleLevelDeliverBlackCurtainStart(IsWhite, IsFromMap)
	local LevelLoader = self:GetLevelLoader()
	local WorldCompositionSubsystem = LevelLoader.WorldCompositionSubSystem
	if WorldCompositionSubsystem and self:IsInRegion() then
		-- self:SetPlayerLocationAndRotation(LevelId, StartIndex)
		local TargtePoint = self:GetLevelLoader():GetStartPointByManager(LevelId, StartIndex)
		local Transform = TargtePoint:GetTransform()
		local Character = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
        local SubRegionId = LevelLoader:GetRegionIdByLevelId(LevelId)
		WorldCompositionSubsystem:RequestAsyncTravel(Character, Transform, 
			{self, 
				function()
                    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
                    Player:AddDisableInputTag("DeliverBlackCurtain")
                    self:HandleLevelDeliverBlackCurtainEnd()
                    if Player.CurrentMountId ~= 0 and not Player:CheckCanMountInCurrentRegion() then
                        Player:DisableBattleMount()
                    end
                    local Avatar = GWorld:GetAvatar()
                    DebugPrint('ExeRegionSkipCallbck', SubRegionId, Avatar.CurrentRegionId)
                    Avatar:ExeRegionSkipCallbck(SubRegionId or Avatar.CurrentRegionId, "Enter")--之前用SetPlayerLocationAndRotation手动触发RegionSkipCallbck来运行SkipRegionNode等逻辑，
                    --虽然现在省掉了一次RequestAsyncTravel但RegionSkipCallbck还是得触发下，虽然用的很不合理。如果还有逻辑比之前少了，参考OpenPlayerPositionSync
                    if Avatar:CheckCurrentSubRegion() and Avatar:CheckSubRegionType(nil,CommonConst.SubRegionType.Field) and not Avatar.IsOpenPlayerPositionSync then
                        DebugPrint('AsyncSetPlayerByStartIndex, PlayerEnterBigWorld')
                        Avatar:PlayerEnterBigWorld()
                    end
					-- self:AddTimer(DataMgr.GlobalConstant.DeliveryBlackCurtainTime.ConstantValue, self.HandleLevelDeliverBlackCurtainEnd, false, 0, "HandleLevelDeliver", true)
				end
			})
		return
	end

    -- 非WC区域,弃用
    -- local function Callback()
    --     local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    --     Player:AddDisableInputTag("DeliverBlackCurtain")
	-- 	self:AddTimer(DataMgr.GlobalConstant.DeliveryBlackCurtainTime.ConstantValue, self.HandleLevelDeliverBlackCurtainEnd, false, 0, "HandleLevelDeliver", true)
    --     self:SetPlayerLocationAndRotation(LevelId , StartIndex)
	-- end
    -- if LevelLoader:GetLevelLoaded(LevelId) then
    --     Callback()
    --     return
    -- end
    -- local function LoadLevelCallBack()
    --     Callback()
    --     LevelLoader:RemoveArtLevelLoadedCompleteCallback(LevelId)
    -- end
    -- LevelLoader:BindArtLevelLoadedCompleteCallback(LevelId, LoadLevelCallBack)
	-- LevelLoader:LoadArtLevel(LevelId)
end

function GameModeRegionMgr:AsyncSetPlayerByLocationAndRotation(LoadLevel, LevelId, Location, Rotation, IsOpenSync, IsWhite)
	local LevelLoader = self:GetLevelLoader()
	self:HandleLevelDeliverBlackCurtainStart(IsWhite)
	local WorldCompositionSubsystem = LevelLoader.WorldCompositionSubSystem
	if WorldCompositionSubsystem and self:IsInRegion() then
        local Transform = UE4.UKismetMathLibrary.MakeTransform(Location, Rotation , UE4.FVector(1, 1, 1))
		local Character = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
		WorldCompositionSubsystem:RequestAsyncTravel(Character, Transform, 
			{self, 
				function()
                    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
                    Player:AddDisableInputTag("DeliverBlackCurtain")
					-- self:AddTimer(DataMgr.GlobalConstant.DeliveryBlackCurtainTime.ConstantValue, self.HandleLevelDeliverBlackCurtainEnd, false, 0, "HandleLevelDeliver", true)
                    self:HandleLevelDeliverBlackCurtainEnd()
				end
			})
		return
	end

    -- 非WC区域,弃用
    -- local function Callback()
    --     local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    --     Player:AddDisableInputTag("DeliverBlackCurtain")
	-- 	self:AddTimer(DataMgr.GlobalConstant.DeliveryBlackCurtainTime.ConstantValue, self.HandleLevelDeliverBlackCurtainEnd, false, 0, "HandleLevelDeliver", true)
    --     local Character = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    --     local Controller = UE4.UGameplayStatics.GetPlayerController(self, 0)
    --     Character:K2_SetActorLocation(Location, false, nil, true)
    --     Character:K2_SetActorRotation(Rotation, false)
    --     Controller:SetControlRotation(Rotation)
    --     LevelLoader:OpenPlayerPositionSync()
	-- end
    -- if LevelLoader:GetLevelLoaded(LevelId) then
    --     Callback()
    --     return
    -- end
    -- local function LoadLevelCallBack()
    --     Callback()
    --     LevelLoader:RemoveArtLevelLoadedCompleteCallback(LevelId)
    -- end
    -- LevelLoader:BindArtLevelLoadedCompleteCallback(LevelId, LoadLevelCallBack)
	-- LevelLoader:LoadArtLevel(LevelId)
end

function GameModeRegionMgr:SetPlayerLocationAndRotation(LevelId, StartIndex)
    local TargtePoint = self:GetLevelLoader():GetStartPointByManager(LevelId, StartIndex)
    TargtePoint:SetPlayerTrans()
end
function GameModeRegionMgr:PrepareLevelDelivery(Id, StartIndex)
    self.TargetSubRegion = Id
    self.TargetSpawnPoint = StartIndex
end
function GameModeRegionMgr:HandleLevelDeliver(ModeType, Id, StartIndex, IsWhite, bIsInvitation, bIsFromMap, bShouldReturnAndDownloadPatch)
    Id = tonumber(Id) ---- 区域或者副本ID 区域指的是子区域ID
    ModeType = tonumber(ModeType) ----- 模式 分为 副本和区域 1 是区域 2 是副本
    StartIndex = tonumber(StartIndex) ---- 出生点 StartPoint 目标区域的出生点 副本就没意义了为1
    self:PrepareLevelDelivery(Id, StartIndex)
    local Avatar = GWorld:GetAvatar()
    local LevelLoader = self:GetLevelLoader()
    if not Avatar or ModeType == UE4.EModeType.ModeNone then return false end
    local PlayerCharacter = UGameplayStatics.GetPlayerCharacter(self, 0)
    if ModeType == UE4.EModeType.ModeRegion then
        HeroUSDKSubsystem():UploadTrackLog_Lua("event_transmit", 
        {
            before_map_id = tostring(Avatar.CurrentRegionId),
            position = PlayerCharacter and tostring(PlayerCharacter:K2_GetActorLocation()) or "",
            trans_id = tostring(StartIndex),
            after_map_id = tostring(Id),
            trans_type = CommonConst.EnterRegionType.Deliver,
        })
    end

    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    if PlayerController:GetStoryModeState() then
        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
        local UIManger = GameInstance:GetGameUIManager()
        UIManger:ShowError(ErrorCode.RET_STORYMODE_STOP_HANDLE_DELIVER_REGION)
        return false
    end
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    local MenuWorld=UIManager:GetUIObj(UIConst.MenuWorld)
    if MenuWorld then
        MenuWorld:Close()
    end
    
    local SceneMgrComponent = GameInstance:GetSceneManager()
    if (IsValid(SceneMgrComponent)) then
        if SceneMgrComponent.NearestPetGuideEid > 0 then
            SceneMgrComponent:CloseOneGuideIconByTargetEid(SceneMgrComponent.NearestPetGuideEid)
            SceneMgrComponent.NearestPetGuideEid = 0
        end

        if SceneMgrComponent.NearestBreakableItemGuideEid > 0 then
            SceneMgrComponent:CloseOneGuideIconByTargetEid(SceneMgrComponent.NearestBreakableItemGuideEid)
            SceneMgrComponent.NearestBreakableItemGuideEid = 0
        end
    end

    GameInstance.ShouldPlayDeliveryEndMontage = false
    GameInstance.AlreadyDeliver = false
    if ModeType == UE4.EModeType.ModeRegion then
        local TargetRegionInfo = DataMgr.SubRegion[Id]
        local CurrentRegionInfo = DataMgr.SubRegion[Avatar.CurrentRegionId]
        if not TargetRegionInfo then return false end
        local CheckResult, Patch = self:CheckRegionPatchCondition(TargetRegionInfo.RegionId)
        if not CheckResult then
            if bShouldReturnAndDownloadPatch then
                GWorld.NetworkMgr:DisconnectAndReturnLogin({["NecessaryPatch"] = Patch})
            else
                local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
                local UIManager = GameInstance:GetGameUIManager()
                UIManager:LoadUINew("OptionalPatch", Patch)
            end
            return false
        end
		-- todo @fanyuxiao 我知道这个不好看, 但是我只能想到在登录界面做WC开关控制台命令的方法(等稳定结束之后干掉)
        local CurrentRegionFile = DataMgr.Region[CurrentRegionInfo.RegionId].RegionMapFile
        local TergetRegionFile = DataMgr.Region[TargetRegionInfo.RegionId].RegionMapFile
        if not IsValid(LevelLoader) then
            if Avatar:IsRealInBigWorld() then
                if CurrentRegionFile == TergetRegionFile then return false end
                Avatar:EnterRegion(Id, StartIndex, CommonConst.EnterRegionType.Deliver, nil, bIsInvitation)
            else
                Avatar:EnterRegion(Id, StartIndex, CommonConst.EnterRegionType.Deliver, nil, bIsInvitation)
            end
        else
            local RegionDeliver = function ()
                if PlayerCharacter then
                    PlayerCharacter.IsInDeliver = true
                end
                if LevelLoader.IsWorldLoader then
                    if CurrentRegionFile == TergetRegionFile then
                        local LevelId = LevelLoader:GetLevelIdByRegionId(Id)
                        if not self:CheckSkipRegionByStartIndex(LevelId, StartIndex) then return false end
                        Avatar:ClosePlayerPositionSync()
                        self:StopLimitTimeExploreGroup()
                        if bIsFromMap then
                            local BlackScreenHandle = {BlackScreenHandle = "HandleLevelDeliverBlackCurtain", InAnimationObj = self,OutAnimationObj = self,
                                ScreenColor = IsWhite and "White" or "Black"}
                            UIManager:ShowCommonBlackScreen(BlackScreenHandle)
                        end
                        ULoadLevel.DeliverTargtePlayer(self, LevelId, StartIndex, true, IsWhite, bIsFromMap)
                    else
                        Avatar:EnterRegion(Id, StartIndex, CommonConst.EnterRegionType.Deliver, nil, bIsInvitation)
                    end
                else
                    Avatar:EnterRegion(Id, StartIndex, CommonConst.EnterRegionType.Deliver, nil, bIsInvitation)
                end
            end
            -- --每个角色传送蒙太奇配置好之前，先判断是否有，有则在蒙太奇通知里真正传送
            -- local MontagePath = PlayerCharacter:GetMontagePath("Interactive/MechInteractive", "Teleport_01_Montage")
            -- local Montage = LoadObject(MontagePath)
            local function RealDelivery()
                DebugPrint("zwk RealDelivery")
                PlayerCharacter:SetInvincible(false, "Delivery")
                PlayerCharacter:SetSuperArmor(false, "Delivery")
                PlayerCharacter:SetTNCannotReduce(false, "Delivery")
                GameInstance.AlreadyDeliver = true
                PlayerCharacter:SetActorHideTag("DeliveryMontage", true)
                RegionDeliver()
                self:DeliveryHideWeapon(PlayerCharacter, false)
            end
            local function NotifyBegin()
                DebugPrint("zwk OnDeliveryPreLoadingMontageNotifyBegin")
                -- self:AddTimer(DataMgr.GlobalConstant.DeliveryMontageEndDelay.ConstantValue, RealDelivery, false, 0, "HandleLevelDeliver", true)
                if not GameInstance.AlreadyDeliver then
                    RealDelivery()
                end
            end
            local function Interrupted()
                DebugPrint("zwk OnDeliveryPreLoadingInterrupted", GameInstance.ShouldPlayDeliveryEndMontage, GameInstance.AlreadyDeliver)
                -- 被可能某个延迟触发的动作打断了，直接强制传送走
                if not GameInstance.AlreadyDeliver then
                    local Rot = PlayerCharacter:K2_GetActorRotation()
                    Rot.Pitch = 0.0
                    Rot.Roll = 0.0
                    PlayerCharacter:K2_SetActorRotation(Rot, false, nil, false)
                    RealDelivery()
                end
            end
            local AllCallback = {
                OnNotifyBegin = NotifyBegin,
                OnInterrupted = Interrupted
            }
            if bIsFromMap then
                DebugPrint("zwk OnDeliveryPreLoadingMontageBeginLoad")
                PlayerCharacter:ForceClearActorHideTag()
                GameInstance:OnCharaterReset()
                PlayerCharacter.CameraControlComponent:RemoveStatesEXBasic()
                local CameraRot = PlayerCharacter.CharCameraComponent:K2_GetComponentRotation()
                CameraRot.Pitch = 0.0
                CameraRot.Roll = 0.0
                PlayerCharacter:K2_SetActorRotation(CameraRot, false, nil, false)
                self:CloseCurUI()
                PlayerCharacter:AddDisableInputTag("DeliverBlackCurtain")
                PlayerCharacter:DisablePlayerInputInDeliver(true)
                PlayerCharacter:SetInvincible(true, "Delivery")
                PlayerCharacter:SetSuperArmor(true, "Delivery")
                PlayerCharacter:SetTNCannotReduce(true, "Delivery")
                self:DeliveryHideWeapon(PlayerCharacter, true)
                -- UIManager:CloseAllStackUI_EX({"BattleMain"}, "Delivery")
                PlayerCharacter:SetActorHideTag("DeliveryMontage", false)
                GameInstance.ShouldPlayDeliveryEndMontage = true
                if PlayerCharacter:IsMainPlayer() and PlayerCharacter:IsExistTimer("SetOnlineStateNormal") then
                    PlayerCharacter:RemoveTimer("SetOnlineStateNormal")
                end

                if Avatar.IsInRegionOnline and Avatar.CurrentOnlineType then
                    DebugPrint("zwk 区域联机传送 ", Avatar.IsInRegionOnline, IsClient(self), IsDedicatedServer(self), IsStandAlone(self))
                    PlayerCharacter:ForceReSyncLocation()
                    Avatar:SwitchOnlineState(Avatar.CurrentOnlineType, CommonConst.OnlineState.UseDelivery)
                end

                PlayerCharacter:PlayTeleportAction(AllCallback, false, true, false)
                self:AddTimer(5, function ()
                    -- 加个保底去掉无敌，以免不知道被什么别的方式打断了传送Montage
                    if PlayerCharacter then
                        PlayerCharacter:SetInvincible(false, "Delivery")
                        PlayerCharacter:SetSuperArmor(false, "Delivery")
                        PlayerCharacter:SetTNCannotReduce(false, "Delivery")
                        self:DeliveryHideWeapon(PlayerCharacter, false)
                    end
                end, false, 0, "DisableInvincible", true)
            else
                RegionDeliver()
            end
        end
    elseif ModeType == UE4.EModeType.ModeDungeon then
        if Avatar:IsRealInBigWorld() then
            Avatar:EnterDungeon(Id, nil)
        else
            local CurrentDungeonId = GWorld.GameInstance:GetCurrentDungeonId()
            if CurrentDungeonId == Id then return false end
            Avatar:EnterDungeon(Id, nil)
        end
    end
    return true
end

function GameModeRegionMgr:CheckRegionPatchCondition(RegionId)
    if DataMgr.RegionPatchCondition[RegionId] then
        local SubSystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UHotUpdateSubsystem:StaticClass())
        local Patch = DataMgr.RegionPatchCondition[RegionId].NecessaryPatch
        if not SubSystem:IsAllPatchOptionalSignsDownloaded(Patch) then
            return false, Patch
        end
    end
    return true, nil
end

function GameModeRegionMgr:DeliveryHideWeapon(PlayerCharacter, bHide)
    for Id, Weapon in pairs(PlayerCharacter.Weapons) do
        Weapon:SetActorHideTag("Delivery", bHide)
    end
end

function GameModeRegionMgr:CheckSkipRegionByStartIndex(LevelId, StartIndex)
    local StartPoint = self:GetLevelLoader():GetStartPointByManager(LevelId, StartIndex)
    return IsValid(StartPoint) 
end

function GameModeRegionMgr:DeliverByLocationAndRotation(SubRegionId, Location, Rotation, IsWhite)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local TargetRegionInfo = DataMgr.SubRegion[SubRegionId]
    local CurrentRegionInfo = DataMgr.SubRegion[Avatar.CurrentRegionId]
    if not TargetRegionInfo then
        return
    end
    local CurrentRegionFile = DataMgr.Region[CurrentRegionInfo.RegionId].RegionMapFile
    local TergetRegionFile = DataMgr.Region[TargetRegionInfo.RegionId].RegionMapFile
    if CurrentRegionFile == TergetRegionFile then
        local LevelLoader = self:GetLevelLoader()
        local LevelId = LevelLoader:GetLevelIdByRegionId(SubRegionId)
        Avatar:ClosePlayerPositionSync()
        self:StopLimitTimeExploreGroup()
        ULoadLevel.DeliverTargtePlayerByLocationAndRotation(self, LevelId, FVector(Location.X,Location.Y,Location.Z), FRotator(Rotation.Pitch,Rotation.Yaw,Rotation.Roll), true, IsWhite)
    end
end

-----------------------------------传送相关---------------------------------------

-- 蓝图策划调用
function GameModeRegionMgr:DelDrop(DropId)
    self.LevelGameMode.DropRule[DropId] = true
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:UpdateSuitKey2Value(CommonConst.SuitType.GameModeSuit ,CommonConst.GameModeSuit.DropRule, DropId, true)
    end
end

-- 蓝图策划调用
function GameModeRegionMgr:RecoverDrop(DropId)
    self.LevelGameMode.DropRule[DropId] = false
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:UpdateSuitKey2Value(CommonConst.SuitType.GameModeSuit, CommonConst.GameModeSuit.DropRule, DropId, false)
    end
end




return GameModeRegionMgr