
require "UnLua"
require "DataMgr"
local Const = require "Const"
local EMCache = require "EMCache.EMCache"
local CommonUtils = require "Utils.CommonUtils"
local TimeUtils = require "Utils.TimeUtils"
local GMVariable = require "BluePrints.UI.GMInterface.GMVariable"
local StoryPlayableUtils = require "BluePrints.Story.StoryPlayableUtils"
local ForgeModel = require "Blueprints.UI.Forge.ForgeDataModel"
local AllPlayerBloodState = require "BluePrints.UI.BloodBar.BloodBarUtils".AllBloodState
local ChatController = require "BluePrints.UI.WBP.Chat.ChatController"
local MiscUtils = require "Utils.MiscUtils"
local EMLuaConst = require("EMLuaConst")

---@class BP_PlayerCharacter_C : BP_CharacterBase_C
local BP_PlayerCharacter_C = Class("BluePrints.Char.BP_CharacterBase_C")

BP_PlayerCharacter_C._components = {
    "BluePrints.Char.CharacterComponent.PickupComponent",
    "BluePrints.Char.CharacterComponent.CameraComponent",
    -- "BluePrints.Char.CharacterComponent.ActionLogicComponent",
    "BluePrints.Char.CharacterComponent.CamPostProcessMgrComponent",
    "BluePrints.Char.CharacterComponent.AttackInputComponent",
    "BluePrints.Char.CharacterComponent.PlayerCommonInterface",
    "BluePrints.Char.CharacterComponent.NewBDCTrackComponent",
    "BluePrints.Char.CharacterComponent.CharacterPickupUseComponent",
    "BluePrints.Char.CharacterComponent.TeamRecoveryComponent",
    "BluePrints.Char.CharacterComponent.QTEComponent",
    "BluePrints.Char.CharacterComponent.CharMoveSyncMgr",
    "BluePrints.Char.CharacterComponent.PropEffectComponent"
}

function BP_PlayerCharacter_C:Initialize(Initializer)
    self:PlayerCharacterInitialize()
end

function BP_PlayerCharacter_C:ReceiveBeginPlay()
    self:BeforeBeginPlay()
    -- self:AddTickPrerequisiteComponent(self.Mesh)
    self.Super.ReceiveBeginPlay(self)
    self:AfterBeginPlay()
	self.UpVector = FVector(0, 0, 1)
    self.IsNearDeath=false
    self.UpVector:Normalize()
    EventManager:AddEvent(EventID.SetDefaultWeapon,self,self.SetDefaultWeapon)
    EventManager:AddEvent(EventID.OnStartSkillFeature, self, self.OnSkillFeatureBegin)
    EventManager:AddEvent(EventID.CloseLoading, self, self.AfterLoading)
    EventManager:AddEvent(EventID.OnLevelDeliverBlackCurtainEnd, self, self.AfterLoading)
    EventManager:AddEvent(EventID.OnRepBulletNum, self, self.UpdateBulletNumUI)
    self:SetActorHideTag("login", true)
    self.DisableInputTags = TArray("")
    -- GWorld.StoryMgr:RunStory('DefaultTalk.story')
    -- Modify Game Settings
    MiscUtils.InitializeSettings(self)

	self:RefreshTeamMemberInfo("ReceiveBeginPlay")
	if self:IsMainPlayer() then
		EventManager:FireEvent(EventID.OnMainCharacterBeginPlay)
        local IsOpenHelperAim = EMCache:Get("IsOpenHelperAim")
		self.IsOpenHelperAim = IsOpenHelperAim == nil and true or IsOpenHelperAim
        local IsOpenLockAim = EMCache:Get("IsOpenLockAim")
		self.IsOpenLockAim = IsOpenLockAim == nil and true or IsOpenLockAim
        self:UpdateOpenHelperAim(self.IsOpenHelperAim)
        self:InitGameSkillFaceTo()
        self:SetEnableFallAtkDir()
        self:SetVirtualJoystickEnableMoveLockFromCache()
        self:SetRegionOnlineState()
        local ShowPlayerNameOption = EMCache:Get("ShowPlayerName") or EMainPlayerNameWidgetOption.EOnlyInRegionOnline
        self:ChangeNameWidgetOption(ShowPlayerNameOption,true)
	end
    -- 设置各种Timer
    self:SetUpAllTimer()
    -- 设置各种初始值
    self:SetGamepadFromCache()
    self:SetMobileRotationFromCache()
    self:BindControllerChangedDelegate()
    local Controller = self:GetController()
    if Controller then
        Controller:ShowFlags("VisualizeSkyVisibilityLightmap", false)
        Controller:ShowFlags("VisualizeBouncedSkyVisibilityLightmap", false)
    end

    -- 临时fix
    if self.CharFSMComp then
        self.CharFSMComp.OnAfterTagChanged:Add(self,self.OnTagChange)
    end
end

function BP_PlayerCharacter_C:OnTagChange(Eid,OldTag,NewTag)
    if NewTag == "GrabHit" and not self.GrabHitCheckTimer then
        self.GrabHitCheckTimer = self:AddTimer(1, function()
            if self:CharacterInTag("GrabHit") then
                -- DebugPrint("Tianyi@ 还在投技中, 且不在空中了")
                self:OnGrabHitLanded()
            else
                if self.GrabHitCheckTimer then
                    self:RemoveTimer(self.GrabHitCheckTimer)
                    self.GrabHitCheckTimer = nil
                end
            end
        end, true, 0, "GrabHitCheckTimer")
    else
        if self.GrabHitCheckTimer then
            self:RemoveTimer(self.GrabHitCheckTimer)
            self.GrabHitCheckTimer = nil
        end
    end
end


function BP_PlayerCharacter_C:BindControllerChangedDelegate()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    GameInstance.OnPawnControllerChangedDelegates:Add(self, self.OnPlayerControllerChanged)
end

function BP_PlayerCharacter_C:OnPlayerControllerChanged(Pawn, Controller)
    if Pawn==self and Controller and Controller:IsPlayerController() then
        if self.DisableInputTags:Length()>0 then
            self:DisableInput(self:GetController())
        else
            self:EnableInput(self:GetController())
        end
    end
end

-- function BP_PlayerCharacter_C:ReceiveTick(DeltaTime)
--     -- if self.PlayerAnimInstance:GetCurrentActiveMontage() then 
--     if(self.FromOtherWorld) then
--         print(_G.LogTag, "BP_PlayerCharacter_C:ReceiveTick",self.InSprint, self.SprintRate)
--     end
--     -- end
--     -- end
-- end

function BP_PlayerCharacter_C:SetGamepadFromCache()
    if not self:IsMainPlayer() then
        return
    end
    local GamepadLayout = EMCache:Get("GamepadLayout")
    DebugPrint("@zyh 获取到的GamepadLayout", GamepadLayout)
    if not GamepadLayout then
        local DefaultLayout = tonumber(DataMgr.Option["GamepadPreset"].DefaultValue)
        EMCache:Set("GamepadLayout", DefaultLayout)
        self:InitGamepadSet(DefaultLayout)
        self:InitReplaceGamepadSet(DefaultLayout)
    else
        self:InitGamepadSet(GamepadLayout)
        self:InitReplaceGamepadSet(GamepadLayout)
    end
end

function BP_PlayerCharacter_C:SwitchGamepadSet(KeySet)
    self:InitGamepadSet(KeySet)
    self:InitReplaceGamepadSet(KeySet)
    EventManager:FireEvent(EventID.OnSwitchGamepadSet)
end

function BP_PlayerCharacter_C:SetMobileRotationFromCache()
    if not self:IsMainPlayer() then
        return
    end
    local EnableMobileRotation = EMCache:Get("EnableMobileRotation")
    DebugPrint("@zyh 获取到的EnableMobileRotation", EnableMobileRotation)
    if EnableMobileRotation == nil then
        local DefaultValue = DataMgr.Option["EnableMobileRotation"].DefaultValueM
        local ToBool = DefaultValue == "True" and true or false
        EMCache:Set("EnableMobileRotation", ToBool)
        self.EnableMobileRotation = ToBool
    else
        self.EnableMobileRotation = EnableMobileRotation
    end
end

function BP_PlayerCharacter_C:SwitchEnableMobileRotation(Value)
    self.EnableMobileRotation = Value
    EMCache:Set("EnableMobileRotation", Value)
end

function BP_PlayerCharacter_C:UpdateOpenHelperAim(IsOpen)
    self.IsOpenHelperAim = IsOpen
    self.CurShootingLocation = Const.ZeroVector
    EMCache:Set("IsOpenHelperAim", IsOpen)
end

function BP_PlayerCharacter_C:UpdateOpenLockAim(IsOpen)
    self.IsOpenLockAim = IsOpen
    self.CurShootingLocation = Const.ZeroVector
    EMCache:Set("IsOpenLockAim", IsOpen)
end

--初始化技能朝向
function BP_PlayerCharacter_C:InitGameSkillFaceTo()
	local OptionName = "SkillFaceTo"
	local GameSkillFaceTo = EMCache:Get(OptionName)
    local DefaultValue
	if GameSkillFaceTo == nil then
		local OptionInfo = DataMgr.Option[OptionName]
		if CommonUtils.GetRuntimePlatform(self) == "Mobile" and OptionInfo.DefaultValueM then
			DefaultValue = OptionInfo.DefaultValueM
		else
			DefaultValue = OptionInfo.DefaultValue
		end
		if DefaultValue == "True" then
			GameSkillFaceTo = true
		else
			GameSkillFaceTo = false
		end
		EMCache:Set(OptionName,GameSkillFaceTo)
	end
    self:SetLockOrientpreference(GameSkillFaceTo)
end

function BP_PlayerCharacter_C:SetUpAllTimer()
    if (self:IsMainPlayer()) then
        self:AddTimer(1.0, self.UpdatePlayerBloodEffectInfo, true, 0, "UpdatePlayerBloodEffectInfo")   
        local Avatar = GWorld:GetAvatar()
        if Avatar and Avatar:IsInBigWorld() then
            self:AddTimer(0.5, self.CalcCurrentPlayerRegionId, true)
        end
    end
end

function BP_PlayerCharacter_C:ShowCursor_Press()
    DebugPrint("ShowCursor_Press", UE4.UKismetSystemLibrary.GetFrameCount())
    local GameInputSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    if not IsValid(GameInputSubsystem) then
        return
    end
    GameInputSubsystem:HandleShowCursorPressOrRelease(true)
end

function BP_PlayerCharacter_C:ShowCursor_Release()
    DebugPrint("ShowCursor_Release",UE4.UKismetSystemLibrary.GetFrameCount())
    local GameInputSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    if not IsValid(GameInputSubsystem) then
        return
    end
    GameInputSubsystem:HandleShowCursorPressOrRelease(false)
end

function BP_PlayerCharacter_C:ShowCursorLock(bLock)
    self.bShowCursorLock=bLock
end

function BP_PlayerCharacter_C:ShowMonsterInfo()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()

    self.bShowMonsterInfo = not self.bShowMonsterInfo
    if self.bShowMonsterInfo then
        UIManager:LoadUI(UIConst.MONSTERINFOPANEL, "MonsterInfo", UIConst.ZORDER_FOR_DESKTOP_TEMP)
    else
        UIManager:UnLoadUI("MonsterInfo")
    end
    self:RemoveInputCache('ShowMonsterInfo')
end

function BP_PlayerCharacter_C:OpenMap()
    --组队相关弹窗打开时且手柄模式需要屏蔽相关操作..
    if TeamController:IsTeamPopupBarOpenInGamepad() then
        return
    end
    if not UIManager(self):TryOpenSystem("Map") then return end
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if not UIManager then
        return
    end
    local battleMap=nil
    local battleMain=UIManager:GetUI('BattleMain') or UIManager:GetUI('HomeBaseMain')
    if battleMain then
        battleMap=battleMain.Battle_Map or battleMain.Battle_Map_PC
    end
    if battleMap then
        battleMap:OnKeyboardClick()
    end
end

function BP_PlayerCharacter_C:StartOpenMap()
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        local Avatar = GWorld:GetAvatar()
        if Avatar and Avatar:CheckUIUnlocked("Chat") then 
            local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
            if BattleMainUI and BattleMainUI.Key_ChatEntry then 
                self.Key_ChatEntry = BattleMainUI.Key_ChatEntry
                self.Key_ChatEntry:AddExecuteLogic(self, self.ChatUpdate)
                self.Key_ChatEntry:OnButtonPressed(nil, true, 0, 0.5)
                return
            end
        end
    end
    self:OpenMap()
end

function BP_PlayerCharacter_C:ClearChatEntryKey()
    self.Key_ChatEntry:RemoveExecuteLogic()
    self.Key_ChatEntry:OnButtonReleased()
    self.Key_ChatEntry = nil
end

function BP_PlayerCharacter_C:StopOpenMap()
    if self.Key_ChatEntry then 
        self:ClearChatEntryKey()
        self:OpenMap()
    end
end

function BP_PlayerCharacter_C:ChatUpdate()
    self:ClearChatEntryKey()
    ChatController:OpenView(self,true)
end

function BP_PlayerCharacter_C:OpenBattleWheel()
    DebugPrint("gmy@OpenBattleWheel")

    -- local SceneManager = GWorld.GameInstance:GetSceneManager()

    -- SceneManager:ReportCheatMsg(CommonConst.MonitorCheatType.Keyboard, "MonitorType: ScriptDetection [KeyBoardRepeatDetection] DungeonId: 123, DungeonType = 1, RoundNum: 1, RepeatTime: 5.")
    
    -- do return end
    local Avatar = GWorld:GetAvatar()
    if Avatar == nil then return end
    local UIUnlockRule = DataMgr.UIUnlockRule
    local UIUnlockRuleId = UIUnlockRule.BattleWheel.UIUnlockRuleId
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)

    local Controller = UE4.UGameplayStatics.GetPlayerController(GameInstance, 0)
    if Controller.bEnableBattleWheel then
        local bUnlocked = Avatar:CheckUIUnlocked(UIUnlockRuleId)
        
        DebugPrint("gmy@BattleMenu Unlocked", bUnlocked)
        if bUnlocked then
            local UIManager = GameInstance:GetGameUIManager()
            local BattleWheel = UIManager:GetUIObj("InBattleWheelMenu")

            if BattleWheel then
                UIManager:UnLoadUI("InBattleWheelMenu")
                BattleWheel = nil
            end
            
            if nil == BattleWheel then
                BattleWheel = UIManager:LoadUINew("InBattleWheelMenu", Controller.QuestBattleWheelID or nil)
            end
            DebugPrint(LXYTag, "BattleWheel", BattleWheel)
            AudioManager(self):PlayUISound(BattleWheel, "event:/ui/common/combat_bag_show", "BattleMenuShow", nil)

            self:FlushInputKeyExceptMove()
            self:AddForbidTag("BattleWheelForbid")
            Controller:AddDisableRotationInputTag("SetRotation_Lerp")
        else
            UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, UIUnlockRule.BattleWheel.UIUnlockDesc)
        end
    else
        DebugPrint("gmy@BP_PlayerCharacter_C:OpenBattleWheel DisableBattleWheel")
        
        local CurDungeonType = WorldTravelSubsystem():GetCurrentDungeonType()
        if CurDungeonType == CommonConst.DungeonType.Abyss then
            UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText('UI_Disabled_Des_BattleWheel'))
        else
            UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText('UI_BATTLEWHEEL_FORBIDDEN'))
        end
    end
end

function BP_PlayerCharacter_C:CloseBattleWheel(bForceClose)
	-- DebugPrint("gmy@CloseBattleWheel")
    
    --[[
        注意: 这里不要异步关闭!!!
    ]]--
    
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    local BattleWheel = UIManager:GetUIObj("InBattleWheelMenu")

    local Controller = UE4.UGameplayStatics.GetPlayerController(GameInstance, 0)
    if nil ~= BattleWheel then
        local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
        if GameInputModeSubsystem then
            local bIsGamepad = GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad
            if bIsGamepad then
                BattleWheel:CloseMenu()
            else
                BattleWheel:SelectAndCloseMenu()
            end
        end
    end
    self:MinusForbidTag("BattleWheelForbid")
    Controller:RemoveDisableRotationInputTag("SetRotation_Lerp")
end

function BP_PlayerCharacter_C:RefreshBattleWheelEnableState()
	local Controller = self:GetController()
	
	if not Controller.bEnableBattleWheel then
		self:CloseBattleWheel(true)
	end
	
	DebugPrint("gmy@BP_PlayerCharacter_C:RefreshBattleWheelEnableState", Controller.bEnableBattleWheel)
	EventManager:FireEvent(EventID.OnRefreshBattleWheelEnableState, Controller.bEnableBattleWheel, Controller.bShowBattleWheel)
end

function BP_PlayerCharacter_C:SetQuestBattleWheelID(QuestBattleWheelID)
    self.QuestBattleWheelID = QuestBattleWheelID
    local GameInstance = GWorld.GameInstance
	local Controller = UE4.UGameplayStatics.GetPlayerController(GameInstance, 0)
	if Controller then
		Controller.QuestBattleWheelID = self.QuestBattleWheelID
    end
end

function BP_PlayerCharacter_C:EnableBattleWheel()
    local GameInstance = GWorld.GameInstance
	local Controller = UE4.UGameplayStatics.GetPlayerController(GameInstance, 0)
	if Controller then
		Controller.bEnableBattleWheel = true
		self:RefreshBattleWheelEnableState()
	end
end

function BP_PlayerCharacter_C:DisableBattleWheel()
    local GameInstance = GWorld.GameInstance
    local Controller = UE4.UGameplayStatics.GetPlayerController(GameInstance, 0)
    if Controller then
        Controller.bEnableBattleWheel = false
        self:RefreshBattleWheelEnableState()
    end
end

function BP_PlayerCharacter_C:ShowBattleWheel()
    local Controller = self:GetController()
    if Controller then
        Controller.bShowBattleWheel = true
        self:RefreshBattleWheelEnableState()
    end
end

function BP_PlayerCharacter_C:HideBattleWheel()
    local Controller = self:GetController()
    if Controller then
        Controller.bShowBattleWheel = false
        self:RefreshBattleWheelEnableState()
    end
end

-- function BP_PlayerCharacter_C:GetObjType()
--     return EObjType.PlayerCharacter
-- end

-------------------  大世界测试函数 ----------------------------
function BP_PlayerCharacter_C:CalcCurrentPlayerRegionId()
    local Avatar = GWorld:GetAvatar()
    local CalcRegionId = self:GetRegionId()
    if not CalcRegionId or not Avatar or not Avatar:CheckCurrentSubRegion() then return end
    if Avatar.SyncReason ~= CommonConst.SyncReason.Normal then return end
    if not Avatar:CheckCurrentSubRegion(CalcRegionId) then return end
    local CurrentRegionId = Avatar.CurrentRegionId
    if CurrentRegionId ~= CalcRegionId and CalcRegionId ~= -1 then
        if Avatar:GetSubRegionId2RegionId() ~= Avatar:GetSubRegionId2RegionId(CalcRegionId) then return end
        if self:GetRegionId(self:GetLastSafeLocation()) ~= CalcRegionId then return end
        Avatar:SkipRegion(CalcRegionId)
    end
end

function BP_PlayerCharacter_C:OnEnteredNewSubRegion()
	local Avatar = GWorld:GetAvatar()
	DebugPrint("OnEnteredNewSubRegion", Avatar.CurrentRegionId)
    if self.CanChangeToMaster == nil then
        self.CanChangeToMaster = self:CheckCanChangeToMaster(false)
    end
    local OldCanChangeToMaster = self.CanChangeToMaster
    local NewCanChangeToMaster = self:CheckCanChangeToMaster(false, true)
    -- 如果当前是女主状态，但是目前不让切女主，则强行切回
    -- PrintTable({S=self.CurrentMasterBan,N=NewCanChangeToMaster})
    if self.CurrentMasterBan and not NewCanChangeToMaster then
        -- 表现层
        self:SwitchMasterOrHeroUIPerform()
        -- 逻辑层
        self:ChangeBackToHero()
    end
    -- UI上的处理
    -- if not OldCanChangeToMaster and NewCanChangeToMaster then
    --     UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, "Toast_SwitchMaster_UnableToA")
    -- elseif OldCanChangeToMaster and not NewCanChangeToMaster then
    --     UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, "Toast_SwitchMaster_AbleToU")
    -- end
    -- local BattleMain = UIManager(self):GetUIObj("BattleMain")
    -- if BattleMain ~= nil and BattleMain.Char_Skill ~= nil then
    --     if self.UIModePlatform == "PC" then
    --         BattleMain.Char_Skill:OnEnteredNewSubRegionUIPerform(NewCanChangeToMaster)
    --     else
    --         BattleMain.Char_Skill.SupportSkill:OnEnteredNewSubRegionUIPerform(NewCanChangeToMaster)
    --     end
    -- end
    -- Audio
    AudioManager(self):CheckLevelSoundAndRegionId(Avatar.CurrentRegionId)
end

function BP_PlayerCharacter_C:GetRegionId(TargetLocation)
    -- TargetLocation = TargetLocation or self:K2_GetActorLocation()
    TargetLocation = TargetLocation or self.CurrentLocation
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local CalcRegionId = -1
    if not GameMode then return end
    local LevelLoader = GameMode:GetLevelLoader()
    if LevelLoader and GWorld:GetWorldRegionState() and LevelLoader.IsWorldLoader then
        CalcRegionId = LevelLoader:GetRegionIdByLocation(TargetLocation)
    end
    return CalcRegionId
end

-- function BP_PlayerCharacter_C:GetMeshOriginTransform()
--     return  self.OriginMeshTransform.Translation
-- end

function BP_PlayerCharacter_C:StartLookAt(LookType, LookInfo)
    if not self:CheckLookPriority(LookType) then
        return
    end
    self:StopLookAt()
    self.CurrentLookType = LookType
    self.CurrentLookInfo = LookInfo
    self.LookAtTag:SetTagState(LookType, true)
end

function BP_PlayerCharacter_C:CheckLookPriority(LookType)
    return true
end

function BP_PlayerCharacter_C:StopLookAt(LookType)
    if not LookType then
        self.LookAtTag:SetTagState(self.CurrentLookType, false)
        return
    end
    if LookType == self.CurrentLookType then
        self.LookAtTag:SetTagState(self.CurrentLookType, false)
    end
end

function BP_PlayerCharacter_C:CheckCanLookAt(FroceStop)
    if FroceStop then
        self:StopLookAt()
        return
    end
    local CurrentStateLimit = DataMgr.PlayerStateLimit[self.AutoSyncProp.CharacterTag]
    if CurrentStateLimit and CurrentStateLimit.NeackRotation then
        local LookInfo = { TurnHeadParam = {bLookUseCamera = true,
                                            bIsLookAt = true}}
        self:StartLookAt('Camera', LookInfo)
    else
        self:StopLookAt('Camera')
    end
end

function BP_PlayerCharacter_C.OnSetLookAtTag(Owner, IsShouldLookAt)
    if not Owner.PlayerAnimInstance then
        return
    end
    if not IsShouldLookAt then
        Owner.PlayerAnimInstance:StopLookAt()
        return
    end
    Owner:SetLookAtParam()

end

function BP_PlayerCharacter_C:SetLookAtParam()
    if not self.PlayerAnimInstance then
        return
    end
    if not self.CurrentLookInfo then
        return
    end
    for k, v in pairs(self.CurrentLookInfo.TurnHeadParam) do
        if self.PlayerAnimInstance[k] ~= nil then
            self.PlayerAnimInstance[k] = v
        end
    end
    local Target = self.CurrentLookInfo.Target
    local Socket = self.CurrentLookInfo.SocketName
    if self.CurrentLookType == 'Actor' then
        
        self.PlayerAnimInstance:SetLookAtActor(Target, Socket)
    elseif self.CurrentLookType == 'Camera' then
        -- DoNothing
    else
        -- Location = self.CurrentLookInfo.TargetLocation
        self.PlayerAnimInstance:SetLookAtActor(Target, Socket)
    end

end


-- function BP_PlayerCharacter_C:AnimHasNotifyOnZeroFrame()
--     if not self.CheckAnimNotifyOnZeroFrame then
--         return false
--     end
--     self.CheckAnimNotifyOnZeroFrame = false
--     if not self:GetCurrentMontage() then
--         return false
--     end

--     if not self.PlayerAnimInstance then
--         return false
--     end
--     if self:GetCurrentMontage().Notifies:Length() <= 0 then
--         return false
--     end
--     local ActiveNotifies = self.PlayerAnimInstance.ActiveAnimNotifyState
--     for i = 1, self:GetCurrentMontage().Notifies:Length() do
--         local NotifyEvent = self:GetCurrentMontage().Notifies:GetRef(i)
--         if NotifyEvent.NotifyName == "UnbindWeapon" and NotifyEvent.TriggerTimeOffset < UE4.UGameplayStatics.GetWorldDeltaSeconds(self) then
--             return true
--         end
--     end
--     return false
-- end

-- function BP_PlayerCharacter_C:SetArmoryTag(ArmoryTag)

-- end

-- function BP_PlayerCharacter_C:SetShootInAirStage()
--     if not self.PlayerAnimInstance then
--         return
--     end
--     self:SetCurrentJumpState(Const.JumpFall)
-- end

function BP_PlayerCharacter_C:OnSkillFeatureBegin()
    self:StopFire(false, true)
end

-- TODO 这个名字不好，要改掉
function BP_PlayerCharacter_C:CancelSkill(JumpStage, bStillHoldFire)
    if not self:IsSkillFinished() then
        self:StopSkill(UE.ESkillStopReason.ForceCancel)
        self:StopFire(bStillHoldFire, false)
        self.PlayerAnimInstance:StopSkillAnimation()
    end
end


function BP_PlayerCharacter_C:InitSceneStartUI()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    -- 初始化一些和场景相关的UI
    local UIManager = GameInstance:GetGameUIManager()
    if (not IsValid(UIManager)) then
        return
    end
    self.UIModePlatform = CommonUtils.GetDeviceTypeByPlatformName(self)
    self.PlatformName = UGameplayStatics.GetPlatformName()
    if (UIConst.bUseHierarchicalLayer) then
        UIManager:LoadUI(UIConst.SCENESTARTUINEW, "SceneStartUI", UIConst.ZORDER_FOR_DESKTOP)
    else
        local SceneStartUI = UIManager:LoadUI(UIConst.SCENESTARTUI, "SceneStartUI", UIConst.ZORDER_FOR_DESKTOP)
        if (SceneStartUI ~= nil) then
            SceneStartUI:InitMainPage()
        end 
    end
    -- 更新一下准星
    --self:UpdateShootingUIByMode()

    -- 如果有复活UI，隐藏
    if not self:IsDead() then 
        local UIBattleMain = UIManager:GetUI("BattleMain")
        if UIBattleMain then 
            UIBattleMain:HidePlayerDeadUI()
        end

        -- 区域规则还不太一样，特殊处理
        local ExceptUIName = TSet(FName)
        UIManager:HideAllUI_EX(ExceptUIName, false, "RegionResurgence")
    end

    local bIsInAutoChessDungeon = GWorld.GameInstance:CheckInAutoChessDungeon()
    -- 自走棋副本隐藏战斗HUD
    local BattleMain = UIManager:GetUI('BattleMain') or UIManager:GetUI('HomeBaseMain')
    if BattleMain then
        if bIsInAutoChessDungeon then
            BattleMain:Hide("AutoChess")
        else
            BattleMain:Show("AutoChess")
        end
    end

    if not bIsInAutoChessDungeon then
        -- 不再强制显示怪物血条，用于处理不杀死游戏进程时非正常退出自走棋然后重进游戏的情况（如仅开关PIE，使用gm ds）
        UE4.UMainBar.SetIsForceShowBloodUI(false);
        -- 去掉自走棋中设置的输入模式
        local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
        GameInputModeSubsystem:DisableInputMode(CommonConst.AutoChess.InputMode)
    end

    -- 刷新一下任务面板
    self:UpdatePlayerTaskInfo()

	-- 刷新一下技能UI
	if not GameInstance:GetLoadingUI() then
		self:RefreshCharUIByPlatform()
	end
end

function BP_PlayerCharacter_C:RefreshCharUIByPlatform()
    local UIManager = UIManager(self)

	self.SkillUINames = self.SkillUINames or {}
	for SkillUIName, _ in pairs(self.SkillUINames) do
		DebugPrint("gmy@BP_PlayerCharacter_C:RefreshCharUIByPlatform ", SkillUIName)
		UIManager:UnLoadUI(SkillUIName)
		self.SkillUINames[SkillUIName] = nil
    end

    DebugPrint("gmy@BP_PlayerCharacter_C BP_PlayerCharacter_C:RefreshCharUIByPlatform1", self.CurrentRoleId)
    local BattleCharInfo = DataMgr.BattleChar[self.CurrentRoleId]
    if BattleCharInfo and BattleCharInfo.CharUIId then
        self:TryOpenSkillUI(BattleCharInfo.CharUIId, false)
    end
end

function BP_PlayerCharacter_C:CheckDraftCanProduce()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end 
    local CurrentRegionId = Avatar:GetCurrentRegionId()
    if Avatar:CheckSubRegionType(CurrentRegionId,CommonConst.SubRegionType.Home) and Avatar:IsInBigWorld() then 
        local CanProductDraftIds = ForgeModel:GetCanProduceDraftIds()
        -- local TargetDraftIds = EMCache:Get("TargetDraftIds", true)
        if #CanProductDraftIds > 0 then 
            self:AddTimer(1, function()
                -- 铸造开车对话ID 
                local ForgingGuideTalkTriggerId = 3001
                -- 显示Talk对话
                UE4.UTalkFunctionLibrary.PlayDirectTalkByTalkTriggerId(GWorld.GameInstance, ForgingGuideTalkTriggerId)
            end)
        end
    end
end

function BP_PlayerCharacter_C:UpdatePlayerBloodEffectInfo()
    -- 刷新能量相关
    if (not self.InitSuccess) then
        return
    end
    local CurrentBlood = self:GetCurrentBloodVolume()
    local MaxBlood = self:GetMaxBloodVolume()
    local BloodStrength = CurrentBlood / MaxBlood
    local NowEnergyShield = self:GetAttr("ES")
    local SystemUIConfig = DataMgr.SystemUI[UIConst.BattleNearDeathPCName]
    if SystemUIConfig then
            --濒死特效参数
        local FirstLevelFactor= SystemUIConfig.Params.FirstLevelFactor
        local SecondLevelFactor=SystemUIConfig.Params.SecondLevelFactor
        local ShowUIBloodStrength=SystemUIConfig.Params.ShowUIBloodStrength
        local SecondLevelBloodStrength=SystemUIConfig.Params.SecondLevelBloodStrength
        if FirstLevelFactor==nil or SecondLevelFactor==nil or ShowUIBloodStrength==nil or SecondLevelBloodStrength==nil then
            return
        end
        local PreNearDeath=self.IsNearDeath
        self.IsNearDeath=BloodStrength > 0.0001 and BloodStrength < ShowUIBloodStrength and NowEnergyShield <= 0
        local EffectUIWidget = UIManager(self):GetUIObj(UIConst.BattleNearDeathPCName)
        local InAnimName
        if not PreNearDeath and self.IsNearDeath then
            InAnimName="In"
        end
        if PreNearDeath and self.IsNearDeath then
           InAnimName="Loop"
        end
        if PreNearDeath and not self.IsNearDeath then
            InAnimName="Out"
        end
        if self.IsNearDeath then
            if (EffectUIWidget == nil) then
                EffectUIWidget = UIManager(self):LoadUINew(UIConst.BattleNearDeathPCName)
            end
            if EffectUIWidget ~= nil then
                local BgMat
                local FlashFactor = BloodStrength > SecondLevelBloodStrength and FirstLevelFactor or SecondLevelFactor
                if CommonUtils.GetDeviceTypeByPlatformName()=="PC" then
                    BgMat = EffectUIWidget.Bg_1:GetDynamicMaterial()
                else
                    BgMat = EffectUIWidget.glassglow:GetDynamicMaterial()
                end
                if (BgMat ~= nil) then
                    BgMat:SetScalarParameterValue("Flash", FlashFactor)
                end
            end
        else
            if EffectUIWidget ~= nil and PreNearDeath then
                EffectUIWidget:BindToAnimationFinished(EffectUIWidget.Out, function ()
                    EffectUIWidget:UnbindAllFromAnimationFinished(EffectUIWidget.Out)
                    UIManager(self):UnLoadUI(UIConst.BattleNearDeathPCName)
                end)
                EMUIAnimationSubsystem:EMPlayAnimation(EffectUIWidget,EffectUIWidget.Out)
            end
        end
    end
end

function BP_PlayerCharacter_C:UpdateUIMode(UIMode)
    self.UIModePlatform = UIMode
    local CharMainUI = UIManager(self):GetUIObj("SceneStartUI")
    if (CharMainUI ~= nil) then
        if (UIConst.bUseHierarchicalLayer) then
            CharMainUI:ReInit()
        else
            CharMainUI:OnCloseOtherUI()
            CharMainUI:InitMainPage() 
        end
    end
end

function BP_PlayerCharacter_C:Landed()
    if not self:PlayerLanded()then
        return
    end
    if self:CharacterInTag("Shooting") and self:CheckCanEnterTag("LandHeavy") and self.PlayerAnimInstance.FallingSpeed < Const.LandHeavySpeed then
        self:StopFire(true, false)
        self:StopSkill(UE.ESkillStopReason.ActionCancel)
    end
end

function BP_PlayerCharacter_C:Impending()
    if not self:PlayerImpending() then
        return
    end
    self.Overridden.Impending(self)
end

function BP_PlayerCharacter_C:StartSlide()
    print(_G.LogTag, "StartSlideStartSlideStartSlide")
    self:DoSlide()
    if (self.NeedSlideEvent) then
        EventManager:FireEvent(EventID.OnSlidePressed)
    end
end

function BP_PlayerCharacter_C:PressDodge()
    self.bSprintPressed = true
    self:StartDodge()
end

function BP_PlayerCharacter_C:StartDodge()
    self:DoDodge()
    if (self.NeedAvoidEvent) then
        EventManager:FireEvent(EventID.OnAvoidPressed)
    end
end

-- function BP_PlayerCharacter_C:StopSlide()
--     self:DoStopSlide()
-- end


function BP_PlayerCharacter_C:ApplyHitFlyDown()
    self:ResetCapSize()
    self:RealStopSlide(true)
    self.Super.ApplyHitFlyDown(self)
end

-- function BP_PlayerCharacter_C:ShowDamageIndicator(Attacker,DamageEvent)
--     if MiscUtils.IsAutonomousProxy(self) or IsStandAlone(self) then
--         -- 2D的UI方式
--         self:CreateHitDirection(Attacker, self, DamageEvent.EnergyShieldReduce>0)
--         local SystemUIConfig = DataMgr.SystemUI["BattleBeharmed"]
--         if(SystemUIConfig.Params.AnimPlayHPPercentage) then
--             local ShowHarmedValue=self:GetAttr("MaxHp")*SystemUIConfig.Params.AnimPlayHPPercentage;
--             if DamageEvent.TrueValue>ShowHarmedValue then
--                 local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
--                 local UIManager = GameInstance:GetGameUIManager()
--                 local BattleBeharmedUI = UIManager:GetUIObj("BattleBeharmed")
--                 if BattleBeharmedUI then
--                     BattleBeharmedUI:Refresh()
--                 else
--                     UIManager:LoadUINew("BattleBeharmed")
--                 end
--             end
--         end
--     end
-- end

function BP_PlayerCharacter_C:ShowPlayerDeadUI()
    local RecoverUIName = self:GetCurRecoveryUIName()
    if RecoverUIName then
        local RecoverUI = UIManager(self):LoadUINew(RecoverUIName)
        RecoverUI:OnMainCharacterInitReady()
        RecoverUI:InitResurgenceUI(self.Eid)
    end
end

function BP_PlayerCharacter_C:IsDeadDuringQuest()
    local CurrentStoryNode = GWorld.StoryMgr:GetCurrentStoryNode()
    return CurrentStoryNode and CurrentStoryNode.bDeadTriggerQuestFail 
end

function BP_PlayerCharacter_C:HandleDeadDuringQuest()
    local StoryMgr = GWorld.StoryMgr
    local RespawnPointParams = StoryMgr:GetResurgencePointInfo()
    local RespawnDelayTime = 1.8
    if RespawnPointParams then 
        self:AddTimer(RespawnDelayTime, function()
            self:RequestDeadAsyncTravel(RespawnPointParams) 
        end)
    else 
        DebugPrint("Tianyi@ 找不到复活点，走区域复活逻辑")
        self:TryEnterDying()
    end
end

function BP_PlayerCharacter_C:RealOnDead_Lua(KillMineRoleEid, KillMineSkillId, DeathReason)
    -- BP_PlayerCharacter_C.Super.RealOnDead(self, KillMineRoleEid, KillMineSkillId, DeathReason)
    
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode ~= nil then
        GameMode:NotifyGameModePlayerDead(self)
    end
    
    DebugPrint("Tianyi@ Player Die!!!!!!!!!!")
    self:SetHoldCrouch(false)
    self:StopFire(false, false)
    self:ZeroComboCount(UE4.EClearComboReason.Dead)
    
    local GameState = UE4.UGameplayStatics.GetGameState(self)
	if GameMode and (GameState.GameModeType == "Training" or GameState.GameModeType == "Trial") then 
        local DelayTime = 0
        local RespawnPoint = GameState:GetTargetPoint("Training")
        if RespawnPoint then 
            Battle(self):TeleportRecovery(self.Eid, RespawnPoint:K2_GetActorLocation(), RespawnPoint:K2_GetActorRotation(), DelayTime)
        else 
            DebugPrint("Tianyi@ 找不到训练场复活点")
            Battle(self):TeleportRecovery(self.Eid, FVector(2148.795166,-4042.718262,2133), FRotator(0,0,0), DelayTime)
        end
    elseif self:IsDeadDuringQuest() then 
        DebugPrint("Tianyi@ 玩家在任务中死亡")
        self:HandleDeadDuringQuest()
    else 
        self:TryEnterDying()
    end

    -- 在肉鸽中死亡时，提前记录一下复活点数
    local Avatar = GWorld:GetAvatar()
    if self:IsMainPlayer() and Avatar and Avatar:IsInRougeLike() then 
        local CurRecoveryCount = self:GetRecoveryCount()
        Avatar:SavePlayerSlice({
            Type = Const.RougeSliceInfoType.RecoverCount, 
            Value = {RecoveryCount = CurRecoveryCount + 1}})
    end
end

function BP_PlayerCharacter_C:OnTriggerFallTrigger(GameMode, FallTrigger)
    if GameMode and FallTrigger then
        local ControllerIndex = UE4.URuntimeCommonFunctionLibrary.GetPlayerControllerIndex(self, self:GetController())
        GameMode:OnTriggerFallTrigger(FallTrigger, self, ControllerIndex)
    end
end
function BP_PlayerCharacter_C:HandleRemoveModPassives()
    self:ClearWeaponModPassive()
    local Controller = self:GetController()
    self:RemovePassiveEffectByRole(Controller:GetRoleId())
end

function BP_PlayerCharacter_C:TriggerFallingCallable(GameMode, DefaultTransform, MaxDis, DefaultEnable, FallTrigger, TriggerFallingScreenColor)
    DebugPrint("OtherActor is Falling Dead. TriggeredByPlayer. ActorName:", self:GetName(), ", UnitId:", self.UnitId, ", Eid:", self.Eid, ", CreatorId:", self.CreatorId, ", CreatorType:", self.CreatorType, ", BornPos:", self.BornPos, "MaxDis", MaxDis, "DefaultEnable", DefaultEnable, "DefaultTransform", DefaultTransform)
    
    if self.FromOtherWorld then
        DebugPrint("OtherActor is player, but from other world  ActorName:", self:GetName())
        return
    end
    if not IsDedicatedServer(self) and not self:IsMainPlayer() then
        DebugPrint("OtherActor is player, but not main player  ActorName:", self:GetName())
        return
    end
    if not self.InitSuccess then
        DebugPrint("OtherActor is player, but not InitSuccess  ActorName:", self:GetName())
        return
    end
    
    GameMode:TriggerDungeonComponentFun("OnPlayerTriggerFallTrigger")
    self:OnTriggerFallTrigger(GameMode, FallTrigger)
    --获取安全点位置和角度
	local SafeLocation = GameMode:TryGetSafeLocation(self, MaxDis)
	local SafeRotation = nil

    --小游戏中触发FallTrigger处理
    if self:CharacterInTag("Interactive") then
        self:LeaveInteractiveTag("Interactive")
    end
    if self.EnterRegion then 
        self:StopAllCurrentMove()
    end
    --这块有问题，后续这个函数应该改成直接在外面算好安全坐标再传进来
	--神庙玩法掉落
    if DefaultEnable ~= true then
        local GameModeType = GameMode.EMGameState.GameModeType
        if GameModeType == "Temple" then
            local ArchivePointLocation, ArchivePointRotation = GameMode.EMGameState:BackToTempleArchivePoint()
            if ArchivePointLocation then
                SafeLocation = ArchivePointLocation + FVector(0,0,self.CapsuleComponent:GetScaledCapsuleHalfHeight())
                SafeRotation = ArchivePointRotation
            else
                DebugPrint("ERROR:BackToTempleArchivePoint ArchivePointLocation is nil")
            end
        elseif GameModeType == "Party" then
            local ArchivePointLocation, ArchivePointRotation = GameMode.EMGameState:BackToPartyArchivePoint(self)
            if ArchivePointLocation then
                SafeLocation = ArchivePointLocation + FVector(0,0,self.CapsuleComponent:GetScaledCapsuleHalfHeight())
                SafeRotation = ArchivePointRotation
                GameMode:OnPartyPlayerTriggerFallTrigger(self.Eid)
            else
                DebugPrint("ERROR:BackToPartyArchivePoint ArchivePointLocation is nil")
            end
        end
    end

	--移动角色
    -- self:TriggerCustomServerCorrection(false)
    -- self:GetMovementComponent().DisableWhenCatchupClient = false

    -- 先注释掉 debug的时候打开
    -- if SafeLocation then
    --     DebugPrint("FallTrigger PrintPlayer SafeLocation ", SafeLocation.X, SafeLocation.Y, SafeLocation.Z)
    -- end
    -- if DefaultTransform and DefaultTransform.Translation then
    --     DebugPrint("FallTrigger PrintPlayer DefaultTransform ", DefaultTransform.Translation.X, DefaultTransform.Translation.Y, DefaultTransform.Translation.Z)
	-- end

	if not DefaultEnable and SafeLocation ~= FVector(0,0,0)  then
        -- 先注释掉 debug的时候打开
		-- DebugPrint("FallTrigger SetPlayerLocation to SafeLocation", SafeLocation.X, SafeLocation.Y, SafeLocation.Z)
        self:K2_SetActorLocation(SafeLocation, false, nil, false)
		if SafeRotation ~= nil then
			self:K2_SetActorRotation(SafeRotation, false)
		end
	else
        -- 先注释掉 debug的时候打开
		-- DebugPrint("FallTrigger SetPlayerLocation to DefaultTransform", DefaultTransform.Translation.X, DefaultTransform.Translation.Y, DefaultTransform.Translation.Z)
        self:K2_SetActorLocation(DefaultTransform.Translation, false, nil, false)
		self:K2_SetActorRotation(DefaultTransform.Rotation:ToRotator(), false)
	end
    if IsStandAlone(self) then 
        self:ChangeGravityUseAnim(false, 0)
        self:ClearGravityModifier()
    end
    self:GetMovementComponent():ForceClientUpdate()

	self:EnableCheckOverlapPush({})

	if self.OnTriggerFallingCallable then
		self:OnTriggerFallingCallable()
	end

	if IsDedicatedServer(self) then
		self.RPCComponent:OnPlayerFallTriggerClient(SafeRotation and SafeRotation or DefaultTransform.Rotation:ToRotator())
	else
		self:ShowBlackScreenFade_StandAlone(TriggerFallingScreenColor)
	end
    if self.EnterRegion then 
        self:ForceReSyncLocation()
    end
	self:GetController():SetControlRotation(self:K2_GetActorRotation())
	self:Landed()
    local Mount = self.CurMount
    if Mount and Mount.EMAnimInstance then
        local MountAnim = Mount.EMAnimInstance
        if MountAnim.OnMountStopRideFly then
            MountAnim:OnMountStopRideFly()
        end
    end
    if self.FlyMount then 
        self:StartRideFly()
    end
end

function BP_PlayerCharacter_C:TriggerWaterFallingCallable(GameMode, DefaultTransform, MaxDis, DefaultEnable)
    self:TriggerFallingCallable(GameMode, DefaultTransform, MaxDis, DefaultEnable)
end

-- 想了下不想往NewBlackScreenFade里加参数，先这样吧
function BP_PlayerCharacter_C:ShowBlackScreenFade_StandAlone(TriggerFallingScreenColor, OutAnimationPlayTime)
    if TriggerFallingScreenColor == "White" then
        local Params = {}
        Params.BlackScreenHandle = "BlackScreenFade"
        Params.ScreenColor = "White"
        Params.OutAnimationPlayTime = 1
        Params.IsPlayOutWhenLoaded = true
		UIManager(self):ShowCommonBlackScreen(Params)
    else
        self:NewBlackScreenFade(OutAnimationPlayTime)
    end
end

-- 已移到C++
-- function BP_PlayerCharacter_C:GetDamageInstigatorCurrentAngle(Attacker)
--     -- 计算受击方向
--     if (not IsValid(Attacker)) then
--         return 0
--     end
--     local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
--     local UIManager = GameInstance:GetGameUIManager()

--     local Controller = UE4.UGameplayStatics.GetPlayerController(self,0)
--     local AttackerWorldLocation = Attacker:K2_GetActorLocation()
--     local AttackerScreenLocation = FVector2D(0, 0)
--     local PlayerWorldLocation = self:K2_GetActorLocation()
--     local PlayerScreenLocation = FVector2D(0, 0)
--     --local IsAttackerInScreen = Controller:ProjectWorldLocationToScreen(AttackerWorldLocation, AttackerScreenLocation)
--     --local IsAttackerInScreen = UE4.UWidgetLayoutLibrary.ProjectWorldLocationToWidgetPosition(Controller, AttackerWorldLocation, AttackerScreenLocation, false)
--     --local IsPlayerInScreen = UE4.UWidgetLayoutLibrary.ProjectWorldLocationToWidgetPosition(Controller, PlayerWorldLocation, PlayerScreenLocation, false)
--     --local ScreenViewportSize = UIManager:GetViewportSize()
--     UE4.UUIFunctionLibrary.WorldPostionToScreenPosition(Controller, AttackerWorldLocation, AttackerScreenLocation)
--     local DesignedSize = UIManager:GetDesignedScreenSize()
--     local RotationAngle = 0
--     PlayerScreenLocation = DesignedSize/2
--     --if IsAttackerInScreen then
--     local DeltaCenterPos = FVector2D(AttackerScreenLocation.X - PlayerScreenLocation.X,  PlayerScreenLocation.Y - AttackerScreenLocation.Y)
--     DeltaCenterPos:Normalize()
--     local UpVector2D = FVector2D(0, 1)
--     local DotCenterAndUp = DeltaCenterPos.X * UpVector2D.X + DeltaCenterPos.Y * UpVector2D.Y
--     local RightVector2D = FVector2D(1, 0)
--     local DotCenterAndRight = DeltaCenterPos.X * RightVector2D.X + DeltaCenterPos.Y * RightVector2D.Y
--     RotationAngle = math.acos(DotCenterAndUp)
--     if (DotCenterAndRight < 0) then
--         RotationAngle = 2 * math.pi - RotationAngle
--     end
--     --[[else
--         local DeltaCenterPos = FVector2D(AttackerScreenLocation.X - PlayerScreenLocation.X, PlayerScreenLocation.Y - AttackerScreenLocation.Y)
--         DeltaCenterPos:Normalize()
--         local UpVector2D = FVector2D(0, 1)
--         local DotCenterAndUp = DeltaCenterPos.X * UpVector2D.X + DeltaCenterPos.Y * UpVector2D.Y
--         local RightVector2D = FVector2D(1, 0)
--         local DotCenterAndRight = DeltaCenterPos.X * RightVector2D.X + DeltaCenterPos.Y * RightVector2D.Y
--         RotationAngle = math.acos(DotCenterAndUp)
--         if (DotCenterAndRight < 0) then
--             RotationAngle = 2 * math.pi - RotationAngle
--         end
--     end]]
--     -- print (_G.LogTag, "GetDamageInstigatorCurrentAngle, the Angle is ", RotationAngle / math.pi * 180)
--     return RotationAngle
-- end

-- function BP_PlayerCharacter_C:ShowDamage(DamageEvent)
--     BP_PlayerCharacter_C.Super.ShowDamage(self, DamageEvent)
--     local DamageCauser = Battle(self):GetEntity(DamageEvent.SourceEid)
--     if (DamageCauser ~= nil and DamageEvent.DisableUIEffect == false) then
--         -- self:ShowDamageIndicator(DamageCauser:GetDirectSource(), DamageEvent.EnergyShieldReduce > 0)
--         local DirectSource = DamageCauser:GetDirectSource() or DamageCauser
--         -- self:AddTimer(0.01, self.ShowDamageIndicator, false, 0, "ShowUIDamageIndicator", nil, DirectSource, FDamageStructFowShow(DamageEvent, true))
--         self:ShowDamageIndicator(DirectSource, DamageEvent)
--     end
--     self:TryToUpdateScreenEffect(DamageCauser, DamageEvent.EnergyShieldReduce)
-- end

-- function BP_PlayerCharacter_C:ShowHeal(HealEvent)
--     BP_PlayerCharacter_C.Super.ShowHeal(self, HealEvent)
--     if self:IsMainPlayer() then
--         EventManager:FireEvent(EventID.OnShowMainPlayerHealEvent,HealEvent)
--     end
--     if GMVariable.EnableShowBillboard then
--         if (HealEvent.HitPosition ~= nil) then
--             self.JumpWordComponent:TryToShowJumpWord(HealEvent.HitPosition, HealEvent.HitDirection, "Cure", HealEvent.TrueValue, 0, HealEvent.TargetEid, HealEvent.DamageType, HealEvent.DamageTag,TMap("", FRateStructFowShow))
--         else
--             self.JumpWordComponent:TryToShowJumpWord(UE4.FVector(0, 0, 0), nil, "Cure", HealEvent.TrueValue, 0, HealEvent.TargetEid, HealEvent.DamageType, HealEvent.DamageTag, TMap("", FRateStructFowShow))
--         end
--     end
-- end

function BP_PlayerCharacter_C:TryToUpdateScreenEffect(DamageFrom, EnergyShieldReduce)
    -- 血量变化
    -- local DamageAttacker = nil
    -- local DamageFromVec = nil
    -- if (DamageFrom ~= nil) then
    --     DamageAttacker = DamageFrom:GetDirectSource()
    --     if (IsValid(DamageAttacker)) then
    --         DamageFromVec = DamageAttacker:K2_GetActorLocation() - self:K2_GetActorLocation()
    --     end
    -- end

    -- local CurrentBlood = self:GetCurrentBloodVolume()
    -- local MaxBlood = self:GetMaxBloodVolume()
    -- local BloodStrength = CurrentBlood / MaxBlood
    local NowEnergyShield = self:GetAttr("ES")
    -- 破盾特效
    if (EnergyShieldReduce > 0) then
        local MaxES=self:GetAttr("MaxES")
        if MaxES~=0 and DataMgr.SystemUI[UIConst.BattleBrokenShieldPCName].Params.ShieldUIResetRate then
            if (NowEnergyShield+EnergyShieldReduce)/MaxES>DataMgr.SystemUI[UIConst.BattleBrokenShieldPCName].Params.ShieldUIResetRate then
                self.PlayBrokenShiledAnim=true
            end
        end
        if (NowEnergyShield <= 0 and self:IsMainPlayer() and self.PlayBrokenShiledAnim) then
            self.PlayBrokenShiledAnim=false
            local SystemUIConfig = DataMgr.SystemUI[UIConst.BattleBrokenShieldPCName]
            if SystemUIConfig then
                local InAnimName=SystemUIConfig.Params.AnimName
                if InAnimName~=nil then
                    local ScreenEffectUI = UIManager(self):PlayScreenEffectAnim(UIConst.LoadInConfig, UIConst.BattleBrokenShieldPCName, {{AnimName=InAnimName, StartTime=0.0, LoopNums=1}})
                    local curTime = TimeUtils.NowTime()
                    AudioManager(self):PlayUISound(ScreenEffectUI, "event:/ui/common/char_sheild_break", nil, nil)
                    if self.PreHitSoundTime== nil or curTime-self.PreHitSoundTime >=30 then
                        self.PreHitSoundTime=curTime
                        local PlayStruct = FPlayFMODSoundStruct()
                        PlayStruct.FMODEventPath,PlayStruct.SelectKey = AudioManager(self):ContactPlayerStringPath(self, "vo_be_hit_heavy")
                        PlayStruct.EventKey = "vo_be_hit_heavy"
                        PlayStruct.bStopWhenAttachedToDestoryed = true
                        PlayStruct.bPlayAs2D = true
                        PlayStruct = UE4.UAudioManager.SetObjectToFPlayFMODSoundStruct(PlayStruct, self)
                        local SoundEventInstance = AudioManager(self):PlayFMODSound_Sync(PlayStruct)
                    end
                end
            end
        end
    end
    if self:IsMainPlayer() then
        EventManager:FireEvent(EventID.OnPlayShowDamageEffect)
    end
end

function BP_PlayerCharacter_C:SkillEnd(Owner, SkillId)
    if not SkillId or SkillId == 0 then
        return
    end
    local Skill = self:GetSkill(SkillId)
    if not Skill then
        return
    end
    self.Super.SkillEnd(Owner, SkillId)
    self:SetRotationRate("OnGround")
end

function BP_PlayerCharacter_C:ResetWeaponHandDelay()
    if not self.KeepWeaponOnHand then
        return
    end
    self.KeepWeaponOnHand = false
    self:RemoveTimer("KeepWeaponDelay")
end

-- function BP_PlayerCharacter_C:SetRotationRate(StateName)
--     if self:CharacterInTag("Shooting") and self.RotState == "Shooting" then
--         return
--     end
--     local r = DataMgr.PlayerRotationRates[StateName]
--     if r then
--         local Movement = self:GetMovementComponent()
--         Movement.RotationRate = FRotator(r.ParamentValue[1],r.ParamentValue[2],r.ParamentValue[3]) * self.RotationRateMultiplier
--         -- print('11111111111111111111111111111111111111111111111111111111111111111zjy',  Movement.RotationRate)
--         self.RotState = StateName

--     end
-- end

-- function BP_PlayerCharacter_C:CancelPostSkillState()
--     if self.bPostSkillState then
--         self:StopSkill()
--         self.bPostSkillState = false
--         self.PlayerAnimInstance:StopSkillAnimation()
--         print("post skill state")
--         return true
--     else
--         return false
--     end
-- end

-- TODO@gmy: 这部分已经挪到C++，稳定后删除
--function BP_PlayerCharacter_C:UseSkill(SkillId, IsTickUse)
--    if not self.Super:UseSkill(SkillId, IsTickUse) then
--        return false
--    end
--    if SkillId == self:GetSkillByType(UE.ESkillType.Reload) or SkillId == self:GetSkillByType(UE.ESkillType.ShootingOverheat) then
--        self:RemoveInputCache("Fire")
--    end
--    return true
--end

-- TODO@gmy: 这部分已经挪到C++，稳定后删除
--function BP_PlayerCharacter_C:RealUseSkill(Skill, PreTarget)
--    local InSlide = self:CharacterInTag("Slide") or self:CharacterInTag("Crouch")
--    local FireSkill = Skill.SkillId == self:GetSkillByType(UE.ESkillType.Shooting) or Skill.SkillId == self:GetSkillByType(UE.ESkillType.Reload) or Skill.SkillId == self:GetSkillByType(UE.ESkillType.ShootingOverheat)
--    if InSlide and not FireSkill  then
--        self:RealStopSlide()
--    end
--    
--    if Skill.AllowUseSkillInAir and self.IsInAir then
--        self:ResetJumpState_Cpp(true)
--    else
--        self:ResetJumpState_Cpp()
--    end
--    BP_PlayerCharacter_C.Super.RealUseSkill(self, Skill, PreTarget)
--    self.CheckAnimNotifyOnZeroFrame = true
--    self:ResetCapRot()
--    self:RecordWeaponUseCount()
--    self:RecordSkillUseCount(Skill.SkillId)
--    self:CountPlayerSkillUsedTimes(Skill.SkillType)
--    
--    if self.CurrentSkillId == self:GetSkillByType(UE.ESkillType.Reload) then 
--        self.PlayerAnimInstance:SetKawaiiPhysics_Cpp("Reload")
--    elseif self.CurrentSkillId == self:GetSkillByType(UE.ESkillType.Shooting) then 
--        self.PlayerAnimInstance:SetKawaiiPhysics_Cpp("Shooting")
--    end
--end

function BP_PlayerCharacter_C:InitPlayerUseSkillTimes_Internal()
    if not GWorld:GetAvatar() then
        return
    end
    local NeedCountPlayerSkillUsedTimesList = EMCache:Get('bNeedCountPlayerSkillUsedTimesList', true) or {}
    for SkillType, Count in pairs(NeedCountPlayerSkillUsedTimesList) do
        self.NeedCountPlayerSkillUsedTimesList:Add(SkillType, Count)
    end
    local CountPlayerSkillUsedTimesList = EMCache:Get('CountPlayerSkillUsedTimesList', true) or {}
    for SkillType, Count in pairs(CountPlayerSkillUsedTimesList) do
        self.CountPlayerSkillUsedTimesList:Add(SkillType, Count)
    end
end

function BP_PlayerCharacter_C:GetPlayerUseSkillTimesFromCache(SkillType)
    if not GWorld:GetAvatar() then
        return
    end
    local CountPlayerSkillUsedTimesList = EMCache:Get('CountPlayerSkillUsedTimesList', true) or {}
    return CountPlayerSkillUsedTimesList[SkillType] or 0
end

-- function BP_PlayerCharacter_C:StartPlayerUseSkillTimes(SkillType)
--     self:InitPlayerUseSkillTimes()
--     self.NeedCountPlayerSkillUsedTimesList[SkillType] = true
--     self.CountPlayerSkillUsedTimesList[SkillType] = self.CountPlayerSkillUsedTimesList[SkillType] or 0
-- end

-- function BP_PlayerCharacter_C:ResetPlayerUseSkillTimes(SkillType, Count, Res)
--     self:InitPlayerUseSkillTimes()
--     self.NeedCountPlayerSkillUsedTimesList[SkillType] = Res
--     self.CountPlayerSkillUsedTimesList[SkillType] = Count
-- end

-- function BP_PlayerCharacter_C:GetCountPlayerSkillUsedTimes(SkillType)
--     self:InitPlayerUseSkillTimes()
--     return self.CountPlayerSkillUsedTimesList[SkillType]
-- end

-- function BP_PlayerCharacter_C:ResetNeedCountPlayerSkillUsedTimes(SkillType)
--     self:InitPlayerUseSkillTimes()
--     self.NeedCountPlayerSkillUsedTimesList[SkillType] = nil
-- end

-- function BP_PlayerCharacter_C:ResetCountPlayerSkillUsedTimes(SkillType)
--     self:InitPlayerUseSkillTimes()
--     self.CountPlayerSkillUsedTimesList[SkillType] = nil
-- end

function BP_PlayerCharacter_C:SavePlayerSkillUsedTimes()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        EMCache:Set('bNeedCountPlayerSkillUsedTimesList', self.NeedCountPlayerSkillUsedTimesList:ToTable(), true)
        EMCache:Set('CountPlayerSkillUsedTimesList', self.CountPlayerSkillUsedTimesList:ToTable(), true)
    end
end

-- function BP_PlayerCharacter_C:CountPlayerSkillUsedTimes(SkillType)
--     if not self:IsMainPlayer() then
--         return
--     end
--     if not IsStandAlone(self) then
--         return
--     end
--     if not GWorld:GetAvatar() then
--         return
--     end
--     if not self.NeedCountPlayerSkillUsedTimesList then
--         self:InitPlayerUseSkillTimes()
--     end
    
--     if self.NeedCountPlayerSkillUsedTimesList[SkillType] then
--         self.CountPlayerSkillUsedTimesList[SkillType] = self.CountPlayerSkillUsedTimesList[SkillType] + 1
--     end
-- end

function BP_PlayerCharacter_C:PressFire()
    if not self:CharacterInTag("LandHeavy") and (not self:CheckCanSkillTypeCancel(UE.ESkillType.Shooting) and self:CheckForbidInput())then
        return
    end
    if self:CheckSkillOccupiedByProp(ESkillName.HeavyShooting) then
        self.PropHoldShootTimer = self:AddTimer(0.2, function()
            if(self.PropEffectComponent and self.PropEffectComponent.CurrentPropEffect) then
                self.PropEffectComponent.CurrentPropEffect:OnHoldShoot()
            end
            self.PropHoldShootTimer = nil
        end, false, 0, "PropHoldShoot")
    end
    if self:CheckSkillOccupiedByProp(ESkillName.Fire) then
        self.PropEffectComponent.CurrentPropEffect:OnShootPressed()
        return
    end
    self.bPressedFire = true
    if (self:CharacterHasAnyTag("OverHeat") or self:CharacterHasAnyTag("NoBullet")) then
        self:TryFireOverLoad()
        self:RemoveInputCache("Fire")
        return 
    end
    local SkillId = self:GetSkillByType(UE.ESkillType.HeavyShooting)
    if SkillId and SkillId ~= 0 and not self.PropHoldShootTimer then
        self:RemoveInputCache("Fire")
        self.HoldShootingTimer = self:AddTimer(0.2, self.HoldShooting)
        return
    end
    self:StartFire("Fire")
    if (self.NeedFireEvent) then
        EventManager:FireEvent(EventID.OnFirePressed)
    end
end

function BP_PlayerCharacter_C:StartFire(FireType)
    if self:CheckSkillOccupiedByProp(ESkillName.Fire) then
        return false
    end
    if self:CheckSkillIsBan(ESkillName.Fire) then
        local _ = not self.CurrentMasterBan and UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText("UI_RANGED_FORBIDDEN"))
        return false
    end
    if self:CheckSkillInActive(ESkillName.Fire) then
        return false
    end
    -- if self:CharacterInTag("Crouch") then 
    --     return false
    -- end
    if not self:CheckCanShoot(false) then
        return
    end
    -- print(_G.LogTag, "StartFireStartFireStartFire", FireType)
    if self.PlayerAnimInstance then
        self.PlayerAnimInstance.bPressedFire = true
    end
    local SkillId = nil
    if FireType == "Fire" then
        SkillId = self:GetSkillByType(UE.ESkillType.Shooting)
    else
        SkillId = self:GetSkillByType(UE.ESkillType.HeavyShooting)
    end
    -- print(_G.LogTag, "StartFireStartFireStartFireStartFire", SkillId)
    local FireSuccess = self:UseSkill(SkillId, 0)
    if not FireSuccess then
        --self:TryFireOverLoad()
        return false
    end
    self.AllowEnterShoot = false
    local InputCache = FireType ~= "Fire" and "HeavyShooting" or "Fire"
    self:RemoveInputCache(InputCache)
    return true
end

function BP_PlayerCharacter_C:HoldShooting()
    self.bHoldingShooting = true
    if self:CharacterInTag("Slide") then 
        return 
    end
    self:SetInputCache("HeavyShooting")
    self:StartFire("HeavyShooting")
    self.HoldShootingTimer = nil
end

-- function BP_PlayerCharacter_C:TryFireOverLoad()
--     if not self:CheckCanShoot(true) then 
--         return
--     end
--     local WeaponId, RangedWeapon
--     if (self.BuffManager.UseSummonWeapon) then
--         WeaponId = self.UltraWeapon.WeaponId
--         local WeaponTags = DataMgr.BattleWeapon[WeaponId].WeaponTag
--         if (CommonUtils.HasValue(WeaponTags, "Ranged")) then
--             RangedWeapon = self.UltraWeapon
--         else
--             RangedWeapon = self.RangedWeapon
--         end
--     else
--         RangedWeapon = self.RangedWeapon
--     end
--     if self:CharacterHasAnyTag("OverHeat") and self:GetSkillByType(UE.ESkillType.Reload) then
--         self:UseSkill(self:GetSkillByType(UE.ESkillType.ShootingOverheat))
--     elseif self:CharacterHasAnyTag("NoBullet") and self:GetSkillByType(UE.ESkillType.Reload) then
--         self:UseSkill(self:GetSkillByType(UE.ESkillType.Reload))
--     elseif RangedWeapon and not RangedWeapon:IsBulletCountGreaterZero() then
--         EventManager:FireEvent(EventID.OutOfBullet)
--     end
-- end

-- function BP_PlayerCharacter_C:CheckCanShoot()
--     local NormalCanShoot = self:CheckCanEnterTag("Shooting") or self:IsFlying() 
--     local ShootOverload = self:CharacterHasAnyTag("OverHeat") or self:CharacterHasAnyTag("NoBullet")
--     if not self.PlayerAnimInstance then
--         return NormalCanShoot and not ShootOverload
--     end
--     local JumpStage = self.PlayerAnimInstance.CurrentJumpState
--     if (self:CharacterInTag("Falling")) then 
--         local bNoCancelFire = (JumpStage == Const.FirstJump or JumpStage == Const.JumpFall or JumpStage == Const.Flying) 
--         NormalCanShoot = NormalCanShoot and bNoCancelFire
--     end
--     local bCanEnterFire = JumpStage ~= Const.NormalState and self.AllowEnterShoot
--     return (NormalCanShoot or bCanEnterFire) and not ShootOverload
-- end


-- function BP_PlayerCharacter_C:CheckCanReload()
--     local NormalCanShoot = self:CheckCanEnterTag("Shooting") or self:IsFlying()
--     if not self.PlayerAnimInstance then
--         return NormalCanShoot
--     end
--     local JumpStage = self.PlayerAnimInstance.CurrentJumpState
--     local bNoCancelFire = (JumpStage == Const.FirstJump or JumpStage == Const.JumpFall)and (self:CharacterInTag("Falling"))
--     local bCanEnterFire = JumpStage ~= Const.NormalState and self.AllowEnterShoot
--     return (bNoCancelFire or NormalCanShoot or bCanEnterFire)
-- end

-- function BP_PlayerCharacter_C:UpdateShootingUIByMode(UIShowMode, IsForceShow, HideTag)
--     if IsDedicatedServer(self) then
--         return
--     end
--     local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
--     local SceneMgrComponent = GameInstance:GetSceneManager()
--     local UIManager = GameInstance:GetGameUIManager()
--     if (not IsValid(UIManager) or not IsValid(SceneMgrComponent)) then
--         return
--     end
--     local ShootingTakeAim = UIManager:GetUIObj("TakeAimIndicator")

--     local CurrentWeapon = self:GetCurrentWeapon()
--     if (ShootingTakeAim == nil) then
--         UIManager:LoadUINew("TakeAimIndicator", CurrentWeapon, self, UIShowMode)
--     else
--         ShootingTakeAim:RefreshUIShowPage()
--         ShootingTakeAim:Show(HideTag)
--     end
-- end

function BP_PlayerCharacter_C:RemoveHoldShootingTimer()
    self:RemoveTimer(self.HoldShootingTimer)
    self.HoldShootingTimer = nil
end

function BP_PlayerCharacter_C:ReleasePropEffectFire()
    if self:CheckSkillOccupiedByProp(ESkillName.HeavyShooting) then
        if self.PropHoldShootTimer then
            self:RemoveTimer("PropHoldShoot")
            self.PropHoldShootTimer = nil
        end
    end
    if self:CheckSkillOccupiedByProp(ESkillName.Fire) then
        self.PropEffectComponent.CurrentPropEffect:OnShootReleased()
        return
    end
end

function BP_PlayerCharacter_C:ReleaseFire()
    self:ReleasePropEffectFire()
    if not self.bHoldingShooting and self.HoldShootingTimer then
        self:SetInputCache("Fire")
        self:StartFire("Fire")
    end
    --self.bHoldingShooting = false
    self:StopFire(false, true)
end

function BP_PlayerCharacter_C:StopFire(bStillHoldFire, OnlyReleaseFire)
    if (self.NeedFireReleaseEvent) then
        EventManager:FireEvent(EventID.OnFireRelease)
    end
    if bStillHoldFire and not self.bPressedFire then
        return 
    end
    if not bStillHoldFire then
        self.bPressedFire = false
        self.bHoldingShooting = false
    end
    self:RemoveHoldShootingTimer()
    if self.PlayerAnimInstance then 
        self.PlayerAnimInstance.bPressedFire = false
    end
    if OnlyReleaseFire then
        return
    end
    self.ResetedWhenShoot = false
    if self.PlayerAnimInstance then
        if bStillHoldFire then 
            self.PlayerAnimInstance.StartShoot = false
            self:DisableReloadWithoutShoot()
            self:ShouldEnableHandIk()
        end
        self.PlayerAnimInstance.StopShoot = false
        self.PlayerAnimInstance.EnableAim = UE4.UKismetMathLibrary.Clamp(self.PlayerAnimInstance.EnableAim - 1, 0, 1)
    end
end

-- function BP_PlayerCharacter_C:AfterTagChanged(OldTag, NewTag)
    -- self:CheckCanLookAt()
    -- AudioManager(self):ClearDontLoopEvent(self)
    -- AudioManager(self):StopObjectStopEvent(self)
    -- if(self.CameraControlComponent)then
    --     self.CameraControlComponent:OnCharacterTagChanged(OldTag, NewTag)
    -- end

    -- if self.BuffEnableFlight then 
        -- 如果有飞行状态，则需要再设置一下，防止其他逻辑把飞行状态关闭了
        -- 比如受击相关，以及LaunchCharacter
        -- self:SetFlyMode(true)
    -- end
-- end

--function BP_PlayerCharacter_C:EnterIdleTag()
     -- BP_PlayerCharacter_C.Super.EnterIdleTag(self)
     -- self:SetRotationRate("OnGround")
     -- -- self:GetMovementComponent().bOrientRotationToMovement = true
     -- if not self.bPressedCrouch then 
     --     self:ResetCapSize() 
     -- end
--end

function BP_PlayerCharacter_C:AnimIdleStart()  
    if self:CheckShouldEnterNormalIdle() then
        self.PlayerAnimInstance:AnimNotify_IdleStartNew()
    end
    self:TryEnterTalk()
end

function BP_PlayerCharacter_C:EnterCrouchTag()
    -- self:CheckShootingCondition()
    self:TryEnterTalk()
end

function BP_PlayerCharacter_C:CheckShouldEnterNormalIdle()
    if not self.PlayerAnimInstance then
        return false
    end

    if not self.BuffManager then 
        return true
    end
    local CurIdleTag = self.BuffManager.CurrentIdleTag
    
    if CurIdleTag and CurIdleTag ~= "0" then 
        return false 
    end
    
    return true
end

-- function BP_PlayerCharacter_C:SetFlyMode(bIsFly)
--     self:SetFlyingMode(bIsFly)
--     if bIsFly and not self:IsFlying() then 
--         self:RealFlipFly(true)
--     elseif not bIsFly and self:IsFlying() then 
--         self:SetCurrentJumpState(Const.NormalState)
--         self:RealFlipFly(false)
--     end
-- end

function BP_PlayerCharacter_C:EnterSkillTag()
    self.PreSkillId = self.CurrentSkillId
    if self:IsAnimCrouch() and self.CurrentSkillId == self:GetSkillByType(UE.ESkillType.SlideAttack) then
        return
    end
    -- self:SetCrouch(false)
    self:ResetCapSize()
    -- self.Super.EnterIdleTag(self)
end

function BP_PlayerCharacter_C:LeaveSkillTag()
    self:EnsureCondemnMonsterRecoverIdle()
end

function BP_PlayerCharacter_C:EnsureCondemnMonsterRecoverIdle()
    if not IsAuthority(self) or not self.PreSkillId then
        return
    end
    local Skill = self:GetSkill(self.PreSkillId)
    if not Skill then
        return
    end
    local SkillType = Skill:GetSkillType()
    if SkillType and SkillType == ESkillType.Condemn and self.CondemnMonsterEid then
        local CondemnMonster = Battle(self):GetEntity(self.CondemnMonsterEid)
        if CondemnMonster and CondemnMonster:IsCantLeaveDefeated() then
            CondemnMonster:DefeatedRecoverToIdle(true)
        end
    end
end

function BP_PlayerCharacter_C:EnterBulletJumpTag()
    Battle(self):TriggerBattleEvent(BattleEventName.EnterBulletJump, self)
    -- if not self.UploadBDCTrackInfo then
    --     return
    -- end
    -- if not self:IsMainPlayer() then
    --     return
    -- end
    -- local PlayerAvatar = GWorld:GetAvatar()
    -- if not PlayerAvatar then
    --     return
    -- end
    -- if not self.UploadBDCTrackInfo.BulletJumpCount then
    --     self.UploadBDCTrackInfo.BulletJumpCount = 0
    -- end
    -- self.UploadBDCTrackInfo.BulletJumpCount = self.UploadBDCTrackInfo.BulletJumpCount + 1
end

function BP_PlayerCharacter_C:LeaveBulletJumpTag(NewTag)
    Battle(self):TriggerBattleEvent(BattleEventName.QuitBulletJump, self)
    self:SetPushEnemyInfo("BulletJump", false)
end

-- function BP_PlayerCharacter_C:EnterSlideTag()
--     if not self.UploadBDCTrackInfo then
--         return
--     end
--     if not self:IsMainPlayer() then
--         return
--     end
--     if not self.UploadBDCTrackInfo.SlideCount then
--         self.UploadBDCTrackInfo.SlideCount = 0
--         -- self.UploadBDCTrackInfo.SlideCountTrack.bones_id = self.InfoForInit.RoleId
--         -- self.UploadBDCTrackInfo.SlideCountTrack.map_id = GWorld.SceneId
--         -- -- self.UploadBDCTrackInfo.SlideCountTrack["#role_key"] = CommonUtils.ObjId2Str(PlayerAvatar.Eid)
--         -- self.UploadBDCTrackInfo.SlideCountTrack.Position = self:K2_GetActorLocation()
--         -- self.UploadBDCTrackInfo.SlideCountTrack.slide_count = 0
--     end
--     self.UploadBDCTrackInfo.SlideCount = self.UploadBDCTrackInfo.SlideCount + 1
-- end

function BP_PlayerCharacter_C:CheckKeepBoneHit()
    local MoveState = self.PlayerAnimInstance:GetCurrentStateNameByStateMachineName("Movement")
    if MoveState ~= "Idle" and MoveState ~= "Run" then
        self.PlayerAnimInstance.InBoneHit = false
        if self.LuaTimerHandles["BoneHit"] ~= nil then
            self:RemoveTimer(self.LuaTimerHandles["BoneHit"])
            self.LuaTimerHandles["BoneHit"] = nil
        end
    end
end

function BP_PlayerCharacter_C:ForbidRenderMainCamera()
    -- set far plane == near plane to reduce render time
    self.CharCameraComponent:SetOrthoNearClipPlane(100000)
    self.CharCameraComponent:SetOrthoFarClipPlane(100001)
    self.CharCameraComponent:SetOrthoWidth(1)
    self.CharCameraComponent:SetProjectionMode(1)
end

function BP_PlayerCharacter_C:AllowRenderMainCamera()
    self.CharCameraComponent:SetProjectionMode(0)
end

-- function BP_PlayerCharacter_C:ApplyEffectBoneHit(DamageCauser, EffectParamentTable)
--     local CurrentTime = UE4.UGameplayStatics.GetTimeSeconds(self)
--     local MoveState = self.PlayerAnimInstance:GetCurrentStateNameByStateMachineName("Movement")
--     if MoveState ~= "Idle" and MoveState ~= "Run" then
--         return
--     end
--     if CurrentTime < self.CacheInfos["LastBoneHitTime"] + self:GetBoneHitCD() then
--         return
--     end
--     self.CacheInfos["LastBoneHitTime"] = CurrentTime
--     self.PlayerAnimInstance.InBoneHit = true
--     self.LuaTimerHandles["BoneHit"] = self:AddTimer_Combat(Const.BoneHitTime, self.EndBoneHit)
-- end

-- function BP_PlayerCharacter_C:EndBoneHit()
--     self.PlayerAnimInstance.InBoneHit = false
-- end

-- function BP_PlayerCharacter_C:EnterShootingTag()
--     self:ResetEnterShootingTagState()
--     self:UpdateCameraSensitivityFromCache("Shooting")
-- end

--function BP_PlayerCharacter_C:HandleAimTargetRotateTick()
--    local Controller = self:GetController()
--    if (not Controller) or (not self.bPressedFire) then
--        return
--    end
--    local CurSkill = self:GetCurrentSkill()
--    if CurSkill and CurSkill.SkillType == Const.ReloadSkill then
--        return
--    end
--    if self.OpenAimShootingLocation ~= Const.ZeroVector then
--        self:HandleOpenAimTargetRotateTick(Controller)
--    elseif self.CurShootingLocation ~= Const.ZeroVector then
--        self:HandleHitAimTargetRotateTick(Controller)
--    else
--        self:HandleMissAimTargetRotateTick(Controller)
--    end
--end

--function BP_PlayerCharacter_C:HandleOpenAimTargetRotateTick()
--    local Weapon = self:GetCurrentWeapon()
--    if not Weapon then
--        self.OpenAimShootingLocation = Const.ZeroVector
--        return
--    end
--    local HitLocation = self.OpenAimShootingLocation
--    local CameraPos = self.CharCameraComponent:K2_GetComponentLocation()
--    local Rotate = UE4.UKismetMathLibrary.FindLookAtRotation(CameraPos, HitLocation)
--    local ControllerRotation = Controller:GetControlRotation()
--    local CameraRotate = self.CharCameraComponent:K2_GetComponentRotation()
--    local OffsetPitch = CameraRotate.Pitch - ControllerRotation.Pitch
--    Rotate.Pitch = Rotate.Pitch - OffsetPitch
--    local WeaponId = Weapon.WeaponId
--    local WeaponConfig = DataMgr.BattleWeapon[WeaponId]
--    if not WeaponConfig.OpenAimTargetFilter then
--        self.OpenAimShootingLocation = Const.ZeroVector
--        return
--    end
--    local StageRotation = UE4.UKismetMathLibrary.RLerp(ControllerRotation, Rotate, WeaponConfig.OpenAimTargetFilter.AimSpeed, true)
--    StageRotation.Roll = ControllerRotation.Roll
--    Controller:SetControlRotation(StageRotation)
--    if UKismetMathLibrary.EqualEqual_RotatorRotator(ControllerRotation, Rotate, 0.1) then
--        self.OpenAimShootingLocation = Const.ZeroVector
--    end
--end
--
-----@param Controller AController
--function BP_PlayerCharacter_C:HandleHitAimTargetRotateTick(Controller)
--    local Weapon = self:GetCurrentWeapon()
--    if not Weapon then
--        self.CurShootingLocation = Const.ZeroVector
--        return
--    end
--    local HitLocation = self.CurShootingLocation
--    local CameraPos = self.CharCameraComponent:K2_GetComponentLocation()
--    local Rotate = UE4.UKismetMathLibrary.FindLookAtRotation(CameraPos, HitLocation)
--    local ControllerRotation = Controller:GetControlRotation()
--    local CameraRotate = self.CharCameraComponent:K2_GetComponentRotation()
--    local OffsetPitch = CameraRotate.Pitch - ControllerRotation.Pitch
--    Rotate.Pitch = Rotate.Pitch - OffsetPitch
--    local WeaponId = Weapon.WeaponId
--    local WeaponConfig = DataMgr.BattleWeapon[WeaponId]
--    if not WeaponConfig.AimTargetFilter then
--        self.CurShootingLocation = Const.ZeroVector
--        return
--    end
--    local PlayerHandAimSpeedRate = self.IsFixHelpAimSpeedRate and Const.PlayerHandAimSpeedRate or 1
--    local AimSpeedRate = WeaponConfig.AimTargetFilter.AimSpeed * PlayerHandAimSpeedRate
--    local StageRotation = UE4.UKismetMathLibrary.RLerp(ControllerRotation, Rotate, AimSpeedRate, true)
--    StageRotation.Roll = ControllerRotation.Roll
--	Controller:SetControlRotation(StageRotation)
--end

function BP_PlayerCharacter_C:CheckNeedFootprint()
    if CommonUtils.GetRuntimePlatform(self) == "Mobile" then
        return false
    end
    if (IsStandAlone(self) or MiscUtils.IsAutonomousProxy(self)) then
        -- 作为客户端也会走到这里，不能调GameMode
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            local IsInBigWorld = Avatar:CheckCurrentSubRegion()
            if IsInBigWorld == true then
                print("need foot print")
                return true
            end
        else
            print("need foot print")
            return true
        end
    end
    print("not need foot print")
    return false
end

function BP_PlayerCharacter_C:IsOpenNormalAim()
    if (not IsValid(self.RangedWeapon)) then
        return false
    end
    local AimLockStyle = self:GetWeaponAimLockStyle()
    if (AimLockStyle and AimLockStyle == "FieldAim") then
        return true
    end
    return (self.ChooseTargetFilter ~= nil and self.LockTargetFilter ~= nil)
end

-- function BP_PlayerCharacter_C:LeaveShootingTag(NewTag)
--     -- self.Super.LeaveShootingTag(self, NewTag)
--     self:UpdateCameraSensitivityFromCache("Idle")
--     self:ResetLeaveShootingTagState()
-- end

function BP_PlayerCharacter_C:HoldToRecovery()
    Battle(self):Recovery(self.Eid)
end

function BP_PlayerCharacter_C:CommonRecoveryImpl()
    self.Super.CommonRecoveryImpl(self)
    if IsClient(self) or IsStandAlone(self) then
        self:ResetForbidTag("Battle")
        self:RefreshClientSkillLogicComponents()
        self:OnRecoverDissolve()      
    end
end

function BP_PlayerCharacter_C:Recovery(...)
    BP_PlayerCharacter_C.Super.Recovery(self, ...)
    if self:IsInRideMove() then
        self:ServerResourceDisableBattleMount(true)
    end
    if IsClient(self) or IsStandAlone(self) then
        self:UseSkill(Const.PlayerRecoverySkill, 0)
    end
end

function BP_PlayerCharacter_C:QuickRecovery(NotRecoverAttr)
    if self:IsInRideMove() then
        self:ServerResourceDisableBattleMount(true)
    end
    self.Super.QuickRecovery(self, NotRecoverAttr)
end


function BP_PlayerCharacter_C:OnRealEnterDying()
    self.Super.OnRealEnterDying(self)
    -- 通知UI可以显示复活图标了
    if not IsDedicatedServer(self) and self:IsMainPlayer() then 
        self:ShowPlayerDeadUI()
        self:TryHideAllSkillUI()
        if self.TeammateUI then
            self.TeammateUI:OnDead()
        end
    end
end

-- 离开濒死状态，进入真正死亡阶段
function BP_PlayerCharacter_C:OnRealDie()
    DebugPrint("Tianyi@ Player real die, Eid = " .. self.Eid)
    if IsAuthority(self) then 
        local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        --GameMode:TriggerPlayerFailed({self:GetController().AvatarEidStr})
        GameMode:DungeonFinish_OnPlayerRealDead({self:GetController().AvatarEidStr})
    end 
end


function BP_PlayerCharacter_C:OnLanded()
    --如果不在空中，并且存在播放死亡动画的定时器，说明角色在空中死亡，需要落地播放死亡动画
    if self:IsExistTimer("PlayDeadMontage") then
        self:RemoveTimer("PlayDeadMontage")
        self:PlayHitMontage("Die")
    end
    if not self:CharacterInTag("Shooting") and self.PlayerAnimInstance and self.PlayerAnimInstance.StartShoot then 
        self.PlayerAnimInstance.StartShoot = false
        self.PlayerAnimInstance.FullBody = true
        self:ShouldEnableHandIk()
    end
    if self:CharacterInTag("GrabHit") then 
        self:OnGrabHitLanded()
    end
end

function BP_PlayerCharacter_C:EnterDeadTag()
    self:AddForbidTag("Battle")
    self:TrackDeadInfo()
    local BattlePet = self:GetBattlePet()
    if not BattlePet then
        return
    end
    BattlePet:HideBattlePet("Dead", true)
end

function BP_PlayerCharacter_C:LeaveDeadTag()
    local BattlePet = self:GetBattlePet()
    if not BattlePet then
        return
    end
    BattlePet:HideBattlePet("Dead", false)
end

function BP_PlayerCharacter_C:EnterRecoveryTag()
    self:TrackRecoverInfo()
end

function BP_PlayerCharacter_C:GetLogMask()
    return _G.LogTag
end

function BP_PlayerCharacter_C:SetLogMask(MaskName)
    print('LogInfo', MaskName)
    _G.LogTag = MaskName
end

function BP_PlayerCharacter_C:SetLogMask(MaskName)
    print('LogInfo', MaskName)
    _G.LogTag = MaskName
end

function BP_PlayerCharacter_C:GetLogMask()
    return _G.LogTag
end

-- function BP_PlayerCharacter_C:IsCharacterInAir()
--     if not self.PlayerAnimInstance then
--         return self.Overridden.IsCharacterInAir(self)
--     end
--     -- print('IsCharacterInAirIsCharacterInAirIsCharacterInAirIsCharacterInAirzjy',self.Overridden.IsCharacterInAir(self), self.IsInAir)
--     return (self.PlayerAnimInstance.CurrentJumpState ~= Const.Climb) and self.Overridden.IsCharacterInAir(self)
-- end

function BP_PlayerCharacter_C:ReceiveSound(SoundSourceLoc, Strength)
    self.Overridden.ReceiveSound(self, SoundSourceLoc, Strength)
end

-- function BP_PlayerCharacter_C:GetCameraComponent()
--     return self.CharCameraComponent
-- end

function BP_PlayerCharacter_C:GetCharSpringArmWorldResultLoc()
    return self.CharSpringArmComponent.bWorldResultLoc
end

-- function BP_PlayerCharacter_C:CheckNoRotationInputTime(DeltaSeconds)
--     if self:CanResetCamera() then
--         self.fNoControlRotationInputTime = self.fNoControlRotationInputTime + DeltaSeconds
--         if self.fNoControlRotationInputTime >= 2 then
--             return true
--         end
--     else
--         self.fNoControlRotationInputTime = 0.0
--     end
--     return false
-- end

-- function BP_PlayerCharacter_C:GotRotationInput()
--     return self.bGotControllerPitchInput or self.bGotControllerYawInput
-- end

function BP_PlayerCharacter_C:GetNickName()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return "夜航主角名"
    end
    if GWorld:IsStandAlone() then
        return Avatar.Nickname
    end
    return self.PlayerState.PlayerName
end

-- function BP_PlayerCharacter_C:CheckSkillInActive(SkillName)
--     local Controller = self:GetController()
--     if not Controller or not Controller.CheckSkillInActive then
--         return false
--     end
--     return Controller:CheckSkillInActive(SkillName)
-- end

--function BP_PlayerCharacter_C:CheckSkillIsBan(SkillName)
--    local Controller = self:GetController()
--    if not Controller or not Controller.CheckSkillIsBan then
--        return false
--    end
--    return Controller:CheckSkillIsBan(SkillName)
--end

------------ 处理服务端处理掉落物效果 start ------------- 
function BP_PlayerCharacter_C:PickupFunctionDispatcher(UnitId, PickUpCount, Transform, CharacterEid, PickUpEid, bExtra)
    local Battle= Battle(self)
    local TargetCharacter =Battle:GetEntity(CharacterEid)
    local ItemInfo = DataMgr.Drop[UnitId]
    if ItemInfo then
        Battle:TriggerBattleEvent(BattleEventName.OnGetDrop, self, UnitId)

        if ItemInfo.UseEffectType then
            -- 提醒一下以后迭代掉落的同学要单机和联机一起迭代^_^
            local FunctionName = "PickupTo"..ItemInfo.UseEffectType
            -- todo 联机校验客户端生成的PickUpEid
            if IsDedicatedServer(self) then
                -- 联机拾取掉落物
                if rawget(Const.SavePickupType, ItemInfo.UseEffectType) and not GWorld.bDebugServer then
                    local DSEntity = GWorld:GetDSEntity()
                    if DSEntity then
                        DSEntity:PickUpToSave(FunctionName, PickUpCount, ItemInfo, UnitId, Transform, CharacterEid, bExtra)
                    end
                else
                    if ItemUtils:IsServerCreate(ItemInfo.DropId) and ItemInfo.IsPickShare then
                        local GameMode = UE4.UGameplayStatics.GetGameMode(self)
                        GameMode:PickUpForAllPlayers(FunctionName, PickUpCount, ItemInfo.UseParam, UnitId, Transform, PickUpEid, bExtra)
                    else
                        TargetCharacter[FunctionName](TargetCharacter, PickUpCount, ItemInfo.UseParam, UnitId, Transform, PickUpEid, bExtra)
                    end
                end
            else
                -- 单机拾取掉落物
                TargetCharacter[FunctionName](TargetCharacter, PickUpCount, ItemInfo.UseParam, UnitId, Transform, PickUpEid, bExtra)
            end
        end
    end
end

-- 掉落物处理 end
function BP_PlayerCharacter_C:SetDefaultWeapon()
    if not IsAuthority(self) then
        return
    end
    local Avatar = GWorld:GetAvatar()
    local UltraWeapon=nil
    for id,_ in pairs(self.Weapons) do
        for _,tag in pairs(DataMgr.BattleWeapon[id].WeaponTag) do
            if tag == "Ultra" then
                UltraWeapon=id
            end
        end
    end
    self:ClearWeapon()
    local melee= self:AddWeapon(Avatar.Weapons[Avatar.MeleeWeapon].WeaponId)
    melee:UnBindWeaponFromHand()
    local ranged= self:AddWeapon(Avatar.Weapons[Avatar.RangedWeapon].WeaponId)
    ranged:ShouldHideWeapon(true,true)
    ranged:UnBindWeaponFromHand()
    if UltraWeapon then
        self:AddWeapon(UltraWeapon)
    end
    self:ChangeUsingWeaponByType("Melee")
end

function BP_PlayerCharacter_C:HideMonsterCapsule(IsEnable)
    --隐藏全部怪物的胶囊体组件
    local Entities = Battle(self):GetAllEntities()
    for eid, ent in pairs(Entities) do
        if ent and ent.IsMonster and ent:IsMonster() then
            ent.CapsuleComponent:SetHiddenInGame(IsEnable,false)
        end
    end
end

-- function BP_PlayerCharacter_C:ReloadAimIndicatorUI()
--     self:UpdateShootingUIByMode("Melee", true)
-- end

-- function BP_PlayerCharacter_C:RotateToInteractiveTarget(Id)
--     local Target = Battle(self):GetEntity(Id)
--     local PlayerLoc = self:K2_GetActorLocation()
--     local PlayerRotate = self:K2_GetActorRotation()
--     local TargetLoc = Target:K2_GetActorLocation()
--     local RotateYaw = UE4.UKismetMathLibrary.Conv_VectorToRotator(TargetLoc - PlayerLoc).Yaw
--     local RealRotate = FRotator(PlayerRotate.Pitch, RotateYaw, PlayerRotate.Roll)
--     -- local NewLoc = UE4.UKismetMathLibrary.GreaterGreater_VectorRotator(PlayerLoc, Rotate)
--     self:K2_SetActorRotation(RealRotate, false, nil, false)
-- end

function BP_PlayerCharacter_C:ServerInteractiveMechanism(Id, PlayerId, NextStateId, InteractiveId, IsPlayer, OnlineInteractiveId)
    print(_G.LogTag,"lxz ServerInteractiveMechanism", Id, PlayerId)
    local Mechanism = Battle(self):GetEntity(Id)
    if IsPlayer then
        if Mechanism.CheckMontageInteractive then
            self:SetMechanismEid(Id, Mechanism:CheckMontageInteractive())
        else
            self:SetMechanismEid(Id, false)
        end
    end
    local InteractiveTag
    if Mechanism.CombatStateChangeComponent then
        if OnlineInteractiveId ~= -1 then
            Mechanism.RegionOnlineInteractiveMessage:Add(self.Eid, OnlineInteractiveId)
        end
        print(_G.LogTag,"lxz ServerInteractiveMechanism222", PlayerId, NextStateId)
        Mechanism:ChangeState("Interactive", PlayerId, NextStateId)
    else
        if Mechanism:CharacterInTag("Defeated") then
            Mechanism:Penalize(PlayerId)
        else
            Mechanism:OpenMechanism(PlayerId)
        end
        --没有状态组件，说明是怪物
        if Mechanism.InteractiveComponent then
            InteractiveTag = Mechanism.InteractiveComponent.InteractiveTag
        else
            InteractiveTag = Mechanism.InteractiveTag
        end
        self:SetCharacterTag(InteractiveTag)
    end
end

function BP_PlayerCharacter_C:ServerDeInteractiveMechanism(Id, PlayerId, IsSuccess, ReasonId, NextStateId, IsPlayer, OnlineInteractiveId)
    print(_G.LogTag,"lxz ServerDeInteractiveMechanism", PlayerId)
    local Mechanism = Battle(self):GetEntity(Id)
    if not Mechanism or not Mechanism.OpenMechanism then
        return
    end
    if IsPlayer then
        if Mechanism.CheckMontageInteractive then
            self:SetMechanismEid(0, Mechanism:CheckMontageInteractive())
        else
            self:SetMechanismEid(0, false)
        end
    end
    if ReasonId == nil or ReasonId ~= Const.ForceEndInteractive then
        print(_G.LogTag,"lxz ServerDeInteractiveMechanism2222", PlayerId)
        Mechanism:CloseMechanism(PlayerId, IsSuccess)
    else
        Mechanism:ForceCloseMechanism(PlayerId, IsSuccess)
    end
    if OnlineInteractiveId ~= -1 then
        Mechanism.RegionOnlineInteractiveMessage:Remove(self.Eid)
    end
end
function BP_PlayerCharacter_C:LeaveInteractiveTag(NewTag)
    if NewTag~="Idle" and self.MechanismEid~=0 then
        local Mechanism = Battle(self):GetEntity(self.MechanismEid)
        if Mechanism then
            local InteractiveComponent = Mechanism:GetComponentByClass(UChestInteractiveComponent:StaticClass())
            if InteractiveComponent then
                InteractiveComponent:ForceEndInteractive(self, true, Const.ForceEndInteractive)
            end
        end
    end
end

function BP_PlayerCharacter_C:LeaveSeatingTag(NewTag)
    self:LeaveInteractiveTag(NewTag)
    self.CapsuleComponent:SetCollisionResponseToChannel(ECollisionChannel.ECC_WorldStatic, ECollisionResponse.ECR_Block)
end


------------------------------------------轨道机关相关------------------------------------------

function BP_PlayerCharacter_C:TryEnterSlideMech()
    if self.IsFlyingToSlideMech then return end
    if self.IsInSlideMech and self.CurSlideMechEid > 0 then 
        self:TryLeaveSlideMech()
        return
    end
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if not GameState then return end
    -- 找到小于最大距离且角度符合的滑轨机关
    local PlayerLocation = self:K2_GetActorLocation()
    local Controller = self:GetController()
    if not Controller then return end
    local CanInteractiveDis = DataMgr.MovementParams["CanInteractiveDis"].ParamValue or 0
    local CanInteractiveAngle = DataMgr.MovementParams["CanInteractiveAngle"].ParamValue or 0
    local ControlRotation = Controller:GetControlRotation()
    local ForwardVector = UE4.UKismetMathLibrary.GetForwardVector(ControlRotation)

    local BestMech = nil
    local BestDist = math.huge

    local SlideMechMap = GameState.SlideMechanismMap:ToTable()
    for Eid, SlideMech in pairs(SlideMechMap) do
        if IsValid(SlideMech) then
            local MechLocation = SlideMech:K2_GetActorLocation()
            local Delta = MechLocation - PlayerLocation
            local Distance = Delta:Size()

            -- 距离检查
            if Distance <= CanInteractiveDis then
                -- 角度检查
                local DirToMech = Delta
                DirToMech:Normalize()
                local DotProduct = ForwardVector:Dot(DirToMech)
                local AngleRad = math.acos(math.clamp(DotProduct, -1, 1))
                local AngleDeg = math.deg(AngleRad)

                if AngleDeg <= CanInteractiveAngle then
                    -- 选择最近的那个
                    if Distance < BestDist then
                        BestDist = Distance
                        BestMech = SlideMech
                    end
                end
            end
        end
    end

    if BestMech then
        DebugPrint("TryEnterSlideMech ", BestMech.Eid, BestMech:GetName())
        BestMech:PlayerFirstEnterSlideMech(self)
    end
end

function BP_PlayerCharacter_C:BeginEnterSlideMech(MechEid)
    -- 通过MechEid获取机关
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if not GameState then return end

    local SlideMech = GameState.SlideMechanismMap:FindRef(MechEid)
    if not IsValid(SlideMech) then
        DebugPrint("BeginEnterSlideMech: SlideMech not found, Eid:", MechEid)
        return
    end

    -- 读取Spline组件的初始位置
    local SplineComp = SlideMech.Spline
    if not IsValid(SplineComp) then
        DebugPrint("BeginEnterSlideMech: SplineComponent not found on SlideMech")
        return
    end
    local OriginLoc = SplineComp:GetLocationAtSplinePoint(0, ESplineCoordinateSpace.World)
    local SplineStartLocation = SlideMech:GetClosedTransformInSpline(OriginLoc)

    self.SlideMechEid = MechEid

    -- 设置朝向
    local PlayerLocation = self:K2_GetActorLocation()
    local Direction = SplineStartLocation - PlayerLocation
    if Direction:Size() > 1.0 then
        local LookAtRotation = UE4.UKismetMathLibrary.FindLookAtRotation(PlayerLocation, SplineStartLocation)
        local PlayerRotation = self:K2_GetActorRotation()
        local TargetRotation = FRotator(PlayerRotation.Pitch, LookAtRotation.Yaw, PlayerRotation.Roll)
        self:K2_SetActorRotation(TargetRotation, false)
        local Controller = self:GetController()
        if Controller then
            local ControlRotation = Controller:GetControlRotation()
            Controller:SetControlRotation(FRotator(ControlRotation.Pitch, LookAtRotation.Yaw, ControlRotation.Roll))
        end
    end

    -- 移动参数
    local MoveSpeed = DataMgr.MovementParams["FlySpeed"] and DataMgr.MovementParams["FlySpeed"].ParamValue or 500
    local MoveTickInterval = 0.01

    -- 播放蒙太奇，Start段播完后会自动进入Loop段
    local AllCallback = {
        -- Start段播完的通知（需要蒙太奇在Start段末尾配一个AnimNotify）
        OnNotifyBegin = function()
            -- Start段结束，进入Loop段，开始移动玩家到Spline起点
            DebugPrint("zwkkk OnNotifyBegin")
            self:StartMoveToSplineOrigin(SplineStartLocation, MoveSpeed, MoveTickInterval)
        end,
        OnInterrupted = function()
            -- 蒙太奇被打断，清理移动定时器和状态
            self:CleanUpSlideMechEnter()
        end,
        -- OnCompleted = function()
        --     -- End段播完，正式进入滑轨逻辑
        --     self:OnSlideMechEnterCompleted()
        -- end,
    }

    self:ChangeToMasterSlideMech()
    SlideMech:OnSlideSplineCharacterReady()
    self.IsFlyingToSlideMech = true
    self:ForbidSkillsInHooking(true)
    self:DisableBattleWheel()
    self:AddForbidTag("SlideMech")
    self:SetActorEnableCollision(false)
    self:PlayActionMontage("Interactive", "Interactive_SlideSpline_01_Montage", AllCallback)
    self:ChangeGravityUseAnim(true, 0.0001, false, true, false)
    self:AddTimer(0.001, function()
        self:CheckAnimGravityScale()
    end, true, 0, "SlideMechGravity")
end

function BP_PlayerCharacter_C:StartMoveToSplineOrigin(TargetLocation, MoveSpeed, TickInterval)
    -- 移除之前可能存在的定时器
    self:RemoveTimer("SlideMechMoveToSpline")
    local AnimInstance = self.Mesh:GetAnimInstance()
    if AnimInstance then
        AnimInstance:Montage_JumpToSection("Loop")
    end

    self.SlideMechMoveTimer = self:AddTimer(TickInterval, function()
        local CurrentLocation = self:K2_GetActorLocation()
        local Delta = TargetLocation - CurrentLocation
        local Distance = Delta:Size()
        local StepDistance = MoveSpeed * TickInterval

        if Distance <= 40.0 then
            -- 已到达目标位置，设置到精确位置
            self:K2_SetActorLocation(TargetLocation, false, nil, false)
            -- 停止移动定时器
            self:RemoveTimer("SlideMechMoveToSpline")
            self.SlideMechMoveTimer = nil
            -- 跳转到End段
            local AnimInstance = self.Mesh:GetAnimInstance()
            if AnimInstance then
                AnimInstance:Montage_JumpToSection("End")
                self:OnSlideMechEnterCompleted()
            end
        else
            -- 按速度均匀移动
            local Direction = Delta
            Direction:Normalize()
            local NewLocation = CurrentLocation + Direction * StepDistance
            self:K2_SetActorLocation(NewLocation, false, nil, false)
        end
    end, true, 0, "SlideMechMoveToSpline")
end

function BP_PlayerCharacter_C:CleanUpSlideMechEnter()
    -- 清理移动定时器
    if self.SlideMechMoveTimer then
        self:RemoveTimer("SlideMechMoveToSpline")
        self.SlideMechMoveTimer = nil
    end
    
    self.IsFlyingToSlideMech = false
    self:ForbidSkillsInHooking(false)
    self:EnableBattleWheel()
    self:MinusForbidTag("SlideMech")
    self:SetActorEnableCollision(true)
    self:ChangeGravityUseAnim(false, 0.0);
    self:RemoveTimer("SlideMechGravity")
end

function BP_PlayerCharacter_C:OnSlideMechEnterCompleted()
    -- End段播放完毕，进入正式的滑轨移动逻辑
    DebugPrint("SlideMech Enter Completed, start sliding along spline")
    -- 清理移动相关状态
    if self.SlideMechMoveTimer then
        self:RemoveTimer("SlideMechMoveToSpline")
        self.SlideMechMoveTimer = nil
    end

    self.IsFlyingToSlideMech = false
    self:ForbidSkillsInHooking(false)
    self:EnableBattleWheel()
    self:MinusForbidTag("SlideMech")
    self:SetActorEnableCollision(true)
    self:ChangeGravityUseAnim(false, 0.0);
    self:RemoveTimer("SlideMechGravity")
    self:FirstInSlideMech()
end

function BP_PlayerCharacter_C:ChangeToMasterSlideMech()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then 
        self:ChangeRole(11301)
        return
    end
    DebugPrint("zwk ChangeRoleToSlideMech ", Avatar.WeitaSex, Avatar.Sex)

    local RegionId = Avatar:GetCurrentRegionId()
    if(not RegionId or DataMgr.SubRegion[RegionId] == nil) then
        self:ChangeRole(11301)
        return 
    end
    local PlayerIdentity = DataMgr.SubRegion[RegionId].SwitchPlayer
    if not PlayerIdentity then
        self:ChangeRole(11301)
        return 
    end
    local MasterGender = 1

    -- 临时存储角色当前状态
    self.HeroTempInfo = {
        RoleInfo = {
            PlayerHp = self:GetAttr("Hp"),
            PlayerSp = self:GetAttr("Sp"),
            PlayerES = self:GetAttr("ES"),
        },
        RangedWeapon = {
            BulletNum = self.RangedWeapon and self.RangedWeapon:GetAttr("BulletNum") or 0,
            MagazineBulletNum = self.RangedWeapon and self.RangedWeapon:GetAttr("MagazineBulletNum") or 0,
        },
    }
    Avatar.HeroTempInfo = self.HeroTempInfo

    if PlayerIdentity == "Player" then
        MasterGender = Avatar.Sex
    else
        MasterGender = Avatar.WeitaSex
    end

    local RoleId = MasterGender == 1 and 11301 or 11401
    self:ChangeRole(RoleId)

    local BattlePet = self:GetBattlePet()
    if BattlePet then
        BattlePet:HideBattlePet("Master", false)
    end
end

function BP_PlayerCharacter_C:ChangeBackToHeroSlideMech()
    self.SlideMechEid = 0
    self.CurSlideMechEid = 0
    self.IsInSlideMech = false
    self:ChangeRole()
    
    local BattlePet = self:GetBattlePet()
    if BattlePet then
        BattlePet:HideBattlePet("Master", false)
    end
end


function BP_PlayerCharacter_C:FirstInSlideMech()
    self.SlideMovingRate = 1
    local AccTime = DataMgr.MovementParams["AccTime"].ParamValue or 0
    if AccTime > 0 then
        self.SlideMovingRate = 0
        local LoopNum = math.ceil(AccTime / 0.02)
        local DeltaRate = 1 / LoopNum
        self:AddTimer(0.02, function()
            self.SlideMovingRate = math.clamp(self.SlideMovingRate + DeltaRate, 0, 1)
            if self.SlideMovingRate >= 1 then
                self:RemoveTimer("SlideAcc")
            end
        end, true, 0, "SlideAcc")
    end
    
    if self.SlideMechEid then
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        if GameState then
            local SlideMech = GameState.SlideMechanismMap:FindRef(self.SlideMechEid)
            if IsValid(SlideMech) then
                SlideMech:RealFirstInSlideMech(self)
                SlideMech:BeginSlideSplineMove(true)
            end
        end
    end
end

function BP_PlayerCharacter_C:TryLeaveSlideMech()
    if self.CurSlideMechEid <= 0 then return end
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if not GameState then return end
    local SlideMech = GameState.SlideMechanismMap:FindRef(self.CurSlideMechEid)
    if not IsValid(SlideMech) then return end
    if not SlideMech.CanExit then return end
    SlideMech:LeaveSlideMechanism(false)
end

------------------------------------------轨道机关相关End------------------------------------------

function BP_PlayerCharacter_C:ReceiveEndPlay(Reason)
    if self.ArmoryHelper then
        self.ArmoryHelper:DestroySelf()
    end
    
    self:TryCloseAllSkillUI()
    self:RefreshTeamMemberInfo("ReceiveEndPlay")
	--self:DungeonOtherPlayerLeave()
    EventManager:RemoveEvent(EventID.OnStartSkillFeature, self)
    EventManager:RemoveEvent(EventID.SetDefaultWeapon,self)
    EventManager:RemoveEvent(EventID.OnMainCharacterInitReady,self)
    EventManager:RemoveEvent(EventID.OnCharacterInitSuitRecover, self)
    EventManager:RemoveEvent(EventID.CloseLoading, self)
    EventManager:RemoveEvent(EventID.OnLevelDeliverBlackCurtainEnd, self)
    EventManager:RemoveEvent(EventID.OnRepBulletNum, self)
    EventManager:RemoveEvent(EventID.OnChangeNickName,self)
    EventManager:RemoveEvent(EventID.OnChangeTitle,self)
    self:UnBindControllerChangedDelegate()
end

function BP_PlayerCharacter_C:UnBindControllerChangedDelegate()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    GameInstance.OnPawnControllerChangedDelegates:Remove(self, self.OnPlayerControllerChanged)
end

-- function BP_PlayerCharacter_C:SetSafeLocation()
--     local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
--     local TalkManager = GameInstance:GetTalkManager()
--     if TalkManager.IsInSequence == true then return end

--     local GameMode = UE4.UGameplayStatics.GetGameMode(self)
--     local Movement = self:GetMovementComponent()

--     if (Movement.CurrentFloor.bBlockingHit and Movement.CurrentFloor.bWalkableFloor) or (self:CharacterInTag("Slide") and not self.IsInAir) then
--         self.LastSafeLocation = self.CurrentLocation
--         if self.SafeLocation:Num() > 0 and (self.CurrentLocation - self.SafeLocation:GetRef(self.SafeLocation:Num())):Size() <= 5 then 
--             return
--         end
--         self.SafeLocation:Add(self.CurrentLocation)
--         while self.SafeLocation:Num() > self.MaxSafeLocations do
--             self.SafeLocation:Remove(1)
--         end
--     elseif self.IsInAir and GameMode:IsInRegion() then
--         local HitResult = FHitResult()
        
--         self.OnFloorEndLocation = self.CurrentLocation
--         self.OnFloorEndLocation.Z = self.OnFloorEndLocation.Z - 1000

--         local Ret = UE4.UKismetSystemLibrary.LineTraceSingleByProfile(self, self.CurrentLocation, self.OnFloorEndLocation,
--             "SceneCollision", false, self.ActorsToIgnore, 0, HitResult, true, self.TraceColor, self.HitColor, 5)

--         if not Ret or not HitResult.bBlockingHit then return end
--         self.LastSafeLocation = HitResult.Location
--     end
-- end

function BP_PlayerCharacter_C:GetLastSafeLocation()
    return self.LastSafeLocation
end

--控制场景内静态网格体组件的刷光
function BP_PlayerCharacter_C:SetBrushStaticMeshScalarParameter(Value)
    if self.IsGetBrushStaticMesh == nil then
        self.BrushStaticMesh = {}  --刷光静态网格体
        self.IsGetBrushStaticMesh = false --是否已经遍历静态网格体
    end
    if self.IsGetBrushStaticMesh == false then
        local MeshName = Const.BrushStaticMesh
        local AllActors= TArray(AActor)
        UE4.UGameplayStatics.GetAllActorsOfClass(self, AStaticMeshActor, AllActors)
        local ActorTab = AllActors:ToTable()
        for i,v in pairs(ActorTab)  do
            if v.StaticMeshComponent ~= nil
            and v.StaticMeshComponent.StaticMesh ~= nil then
                for idx=1,#MeshName do
                    if v.StaticMeshComponent.StaticMesh:GetName() == MeshName[idx] then
                        table.insert(self.BrushStaticMesh,v.StaticMeshComponent)
                    end
                end
            end
        end
        self.IsGetBrushStaticMesh = true
    end
    for key,value in pairs(self.BrushStaticMesh) do
        local Material0 = value:CreateDynamicMaterialInstance(0)
        if IsValid(Material0) then
            Material0:SetScalarParameterValue("InteractiveScan", Value)
        end
        local Material1 = value:CreateDynamicMaterialInstance(1)
        if IsValid(Material1) then
            Material1:SetScalarParameterValue("InteractiveScan", Value)
        end
    end
end

function BP_PlayerCharacter_C:AddDisableInputTag(Tag)
    self.DisableInputTags:AddUnique(Tag)
    if self.DisableInputTags:Length() > 0 and self:GetController() and self:GetController():IsPlayerController() then
        self:DisableInput(self:GetController())
    end
end

function BP_PlayerCharacter_C:RemoveDisableInputTag(Tag)
    if self.DisableInputTags:Find(Tag) then
        self.DisableInputTags:RemoveItem(Tag)
    end
    if self.DisableInputTags:Length() <= 0 and self:GetController() and self:GetController():IsPlayerController() then
        self:EnableInput(self:GetController())
    end
end

function BP_PlayerCharacter_C:RemoveAllDisableInputTag()
    self.DisableInputTags:Clear()
    self:EnableInput(self:GetController())
end

function BP_PlayerCharacter_C:EnableInput(Controller)
    if self.DisableInputTags:Length() > 0 then
        return
    end
    self.Overridden.EnableInput(self, Controller)
end

-- function BP_PlayerCharacter_C:CheckActionRemap(ActionName)
--     if not self.InputReMapping then 
--         return false
--     end
--     if not self.InputReMapping[ActionName] then
--         return false
--     end
--     return true 
-- end

-- function BP_PlayerCharacter_C:CheckActionMapped(ActionName)
--     PrintTable({ActionName = ActionName,MappedActionName= self.MappedActionName}, 10)
--     if not self.MappedActionName then 
--         return false
--     end
--     if not self.MappedActionName[ActionName] then
--         return false
--     end
--     return true 
-- end

-- function BP_PlayerCharacter_C:CheckActionCanTrigger(ActionName, bActionMapTo)
--     local ActionTable = self.InputReMapping
--     local MappedTable = self.MappedActionName
--     if bActionMapTo then 
--         ActionTable = self.MappedActionName
--         MappedTable = self.InputReMapping
--     end
--     if not MappedTable then
--         return true
--     end
--     local ActionInfo = ActionTable[ActionName]
--     local MappedInfo = MappedTable[ActionInfo.ReMappingActionName]
--     if not MappedInfo then
--         return true
--     end
--     return MappedInfo.OriginKeyState == EInputEvent.IE_Released
-- end
    
-- function BP_PlayerCharacter_C:ChangeActionKeyState(ActionName, KeyState, bActionMapTo)
--     local ActionTable = self.InputReMapping
--     if bActionMapTo then 
--         ActionTable = self.MappedActionName
--     end
--     local ActionInfo = ActionTable[ActionName]

--     ActionTable[ActionName].OriginKeyState = KeyState
-- end

-- function BP_PlayerCharacter_C:GetActionReMappingTo(ActionName)
--     if not self.InputReMapping then 
--         return ""
--     end
--     local ActionInfo = self.InputReMapping[ActionName]
--     if not ActionInfo then
--         return ""
--     end
--     print(_G.LogTag, '111',  ActionInfo.ReMappingActionName)
--     return ActionInfo.ReMappingActionName
-- end



--切换战斗中快捷键显隐
function BP_PlayerCharacter_C:SwitchBattleShortcutKeysHidden()
    local CurrentHidden = EMCache:Get("BattleShortcutHudKeysHidden",true)
    local NewHidden = not CurrentHidden
    EMCache:Set("BattleShortcutHudKeysHidden",NewHidden,true)
    UIManager(self):SetBattleShortCutHudKeysHidden(NewHidden)
end

function BP_PlayerCharacter_C:GetSafeRegionLocation(EnterLocation)
	local Info = {}
    local Avatar = GWorld:GetAvatar()
    local CheckLocation = EnterLocation or self:GetRecentSafeLocation()
    local IsLocationValid = self:CheckLocationValid(CheckLocation)
    local CalcSubRegionId = self:GetRegionId(CheckLocation)
	if CheckLocation ~= Const.ZeroVector and CalcSubRegionId ~= -1 and IsLocationValid then
		Info.RegionId = CalcSubRegionId
        Info.Location = CheckLocation
		Info.Rotation = self:K2_GetActorRotation()
    else
        Info.RegionId = Avatar:GetLastRegionId()
        Info.Location = Avatar.LastRegionData:GetLocation()
        Info.Rotation = Avatar.LastRegionData:GetRotation()
	end
    -- DebugPrint("ZJT_ PlayerSyncLocation ", EnterLocation, CheckLocation, Info.Location, Info.RegionId, Avatar.CurrentRegionId)
	return Info
end

function BP_PlayerCharacter_C:ImmersionModel()
    self.Overridden.ImmersionModel(self)
    GMVariable.EnableShowBillboard = false
    local UIManager = UIManager(self)
    UIManager:HideAllComponentUI(self.IsImmersionModel, Const.ImmersionModelHideTag)
    local HeadUISubsystem = USubsystemBlueprintLibrary.GetWorldSubsystem(self, UNpcHeadUISubsystem) 
    if self.IsImmersionModel then
        require("EMLuaConst").IsHideJumpWord = true
        UIManager:AddUIToStateTagsCluster(1, "ImmersionModel", true)
        EventManager:AddEvent(EventID.OnAddWidgetComponent, self, self.OnAddWidgetComponent)
        if  HeadUISubsystem then 
            HeadUISubsystem:HideAllNpcHeadUI(true, "ImmersionModel")
        end
        MissionIndicatorManager:TriggerAllIndicatorVisible(false)
        --UIManager:AddUIManagerCurrentModeTag(Const.TalkHideTag)
    else
        require("EMLuaConst").IsHideJumpWord = false
        UIManager:AddUIToStateTagsCluster(1, "ImmersionModel")
        EventManager:RemoveEvent(EventID.OnAddWidgetComponent, self)
        if  HeadUISubsystem then 
            HeadUISubsystem:HideAllNpcHeadUI(false, "ImmersionModel")
        end
        MissionIndicatorManager:TriggerAllIndicatorVisible(true)
        --UIManager:RemoveUIManagerCurrentModeTag(Const.TalkHideTag)
    end

end

function BP_PlayerCharacter_C:OnAddWidgetComponent(WidgetInfo)
    local WidgetComponent = WidgetInfo.WidgetComponent
    if WidgetComponent then
        local Widget = WidgetComponent:GetWidget()
        if Widget then
            Widget:Hide(Const.ImmersionModelHideTag)
        end
    end
end

function BP_PlayerCharacter_C:UpdateBulletNumUI()
    self:AddDelayFrameFunc(
        function()
            if(self.TakeAimIndicator)then
                self.TakeAimIndicator:UpdateAmmoBarProgress(true)
            end

            local UIManager = UIManager(self)
            if (UIManager) then
                if (self.UIModePlatform == "PC") then
                    local BattleMainUI = UIManager:GetUIObj("BattleMain")
                    if (BattleMainUI ~= nil and BattleMainUI.Char_Skill ~= nil) then
                        if BattleMainUI.Char_Skill.OnChargeWeaponBullet then
                            BattleMainUI.Char_Skill:OnChargeWeaponBullet()
                        end
                    end
                elseif (self.UIModePlatform == "Mobile") then
                    local BattleMainUI = UIManager:GetUIObj("BattleMain")
                    if (BattleMainUI ~= nil and BattleMainUI.Char_Skill ~= nil) then
                        if BattleMainUI.Char_Skill.Bullet.UpdatePlayerWeaponInfo then
                            BattleMainUI.Char_Skill.Bullet:UpdatePlayerWeaponInfo()
                        end
                        if BattleMainUI.Char_Skill.AtkRanged.UpdateRangeWeaponButton then
                            BattleMainUI.Char_Skill.AtkRanged:UpdateRangeWeaponButton()
                        end
                    end
                end 
            end
        end)
end

function BP_PlayerCharacter_C:UpdateSkillUIInfo(ChangedSkills)
    if IsDedicatedServer(self) then
        return
    end
    if (self.UIModePlatform == "PC") then
        local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
        if (BattleMainUI ~= nil and BattleMainUI.Char_Skill ~= nil) then
            for k, v in pairs(ChangedSkills) do
                local Skill = self:GetSkill(v)
                if Skill then
                    local SkillBaseConfig = Skill.Data
                    BattleMainUI.Char_Skill:RefreshRoleTargetSkill(SkillBaseConfig.SkillType, Skill)
                    DebugPrint("@zyh123" ,v, SkillBaseConfig.SkillType)
                end
            end
            --else
            --BattleMainUI.Char_Skill:RefreshRoleSkillButton() 
            --end
        end
    elseif (self.UIModePlatform == "Mobile") then
        local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
        if (BattleMainUI ~= nil and BattleMainUI.Char_Skill ~= nil) then
            for k, v in pairs(ChangedSkills) do
                local Skill = self:GetSkill(v)
                if Skill then
                    local SkillBaseConfig = Skill.Data
                    BattleMainUI.Char_Skill:RefreshRoleTargetSkill(SkillBaseConfig.SkillType, Skill)
                end
            end
            --BattleMainUI.Char_Skill:RefreshRoleSkillButton(IsChanged)
            --end
        end
    end
end

--设置ESC设置系统的禁用状态 true为禁用 false/nil是开启
function BP_PlayerCharacter_C:SetESCMenuForbiddenState(IsForbidden)
    self.IsESCForbidden = IsForbidden or false
end

function BP_PlayerCharacter_C:GetESCMenuForbiddenState()
    if self.IsESCForbidden == nil then
        return false
    end
    return self.IsESCForbidden
end

function BP_PlayerCharacter_C:SetMaxMovingSpeed(Rate)
    Rate = math.max(0, Rate)
	self.PlayerSlideAtttirbute.NormalWalkSpeed = DataMgr.PlayerRotationRates["NormalWalkSpeed"].ParamentValue[1] * Rate
	self.PlayerSlideAtttirbute.CrouchWalkSpeed = DataMgr.PlayerRotationRates["CrouchWalkSpeed"].ParamentValue[1] * Rate
    self:SetWalkSpeed()
end

function BP_PlayerCharacter_C:SetMaxMovingSpeedByInfo(Info)
    self.PlayerSlideAtttirbute.NormalWalkSpeed = Info.NormalWalk
    self.PlayerSlideAtttirbute.CrouchWalkSpeed = Info.CrouchWalk
end

function BP_PlayerCharacter_C:TryOpenSkillUI(CharUIId, bIsOpenByBuff)
    DebugPrint("TryOpenSkillUI: ", CharUIId, bIsOpenByBuff)
    if not self:IsMainPlayer() then
        return
    end

    CharUIId = self:GetReplacedCharUIId(CharUIId)
    
    local GradeLevel = self:GetAttr("GradeLevel") or 0
    local CharUIInfo = DataMgr.BattleCharUI[CharUIId][GradeLevel]
	
    if bIsOpenByBuff or not CharUIInfo.TriggerBuffId then
        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
        local SceneMgrComponent = GameInstance:GetSceneManager()
        
        if (IsValid(SceneMgrComponent)) then
			local OpenUIFunctor  = function()
				local UIManager = GameInstance:GetGameUIManager()
				local UIObj = UIManager:GetUIObj(CharUIInfo.UIName)
				if UIObj then
					UIManager:UnLoadUI(CharUIInfo.UIName)
				end

				self.SkillUINames = self.SkillUINames or {}
				self.SkillUINames[CharUIInfo.UIName] = true
				UIObj = UIManager:LoadUINew(CharUIInfo.UIName, self, CharUIInfo.Params)
				if (UIObj and UIObj.InitBattleCharUI) then
					UIObj:InitBattleCharUI(CharUIId, GradeLevel)
				end
			end

			if bIsOpenByBuff and CharUIInfo.TriggerBuffDelay then
				-- 不受时间膨胀的影响
				self:AddTimer_Combat(CharUIInfo.TriggerBuffDelay, function()
					-- 调用前检测下Buff是否还在
					local Buffs = self.BuffManager and self.BuffManager.Buffs
					if Buffs then
						for _, Buff in pairs(Buffs) do
							if Buff.BuffId == CharUIInfo.TriggerBuffId then
								OpenUIFunctor()
								break
							end
						end
					end
				end, false, 0, nil, true)
			else
				OpenUIFunctor()
			end
        end
    end
end

function BP_PlayerCharacter_C:TryCloseSkillUI(CharUIId)
    DebugPrint("TryCloseSkillUI: ", CharUIId)
    if not self:IsMainPlayer() then
        return
    end
    
    CharUIId = self:GetReplacedCharUIId(CharUIId)

    local GradeLevel = self:GetAttr("GradeLevel") or 0
    local CharUIInfo = DataMgr.BattleCharUI[CharUIId][GradeLevel]

    if CharUIInfo then
        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
        local UIManager = GameInstance:GetGameUIManager()

        local UIObj = UIManager:GetUIObj(CharUIInfo.UIName)
        if UIObj then
            UIObj:RemoveSelf()
        end
        
        if self.SkillUINames and self.SkillUINames[CharUIInfo.UIName] then
            self.SkillUINames[CharUIInfo.UIName] = nil
        end
    end
end

function BP_PlayerCharacter_C:GetReplacedCharUIId(CharUIId)
    if self.CurrentSkinId then
        local SkinData = DataMgr.Skin[self.CurrentSkinId]
        if SkinData then
            local BattleCharUIMap = SkinData.BattleCharUIMap
            if BattleCharUIMap then
                if BattleCharUIMap[CharUIId] then
                    DebugPrint("gmy@BP_PlayerCharacter_C BP_PlayerCharacter_C:TryOpenSkillUI Skill Replaced",
                            CharUIId, BattleCharUIMap[CharUIId])
                    CharUIId = BattleCharUIMap[CharUIId]
                end
            end
        end
    end
    return CharUIId
end

function BP_PlayerCharacter_C:TryHideAllSkillUI()
    if not self:IsMainPlayer() then
        return
    end

    -- todo@gmy: 这种方式似乎隐藏不了buff skill ui
    local GradeLevel = self:GetAttr("GradeLevel") or 0
    local BattleCharInfo = DataMgr.BattleChar[self.CurrentRoleId]
    if BattleCharInfo.CharUIId then
        local ReplacedCharUIId = self:GetReplacedCharUIId(BattleCharInfo.CharUIId)
        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
        local UIManager = GameInstance:GetGameUIManager()
        local CharUIInfo = DataMgr.BattleCharUI[ReplacedCharUIId][GradeLevel]
        if CharUIInfo then
            local UIObj = UIManager:GetUIObj(CharUIInfo.UIName)
            if UIObj then
                --UIObj:SetVisibility(UE4.ESlateVisibility.Collapsed)
                UIObj:Hide()
            end
        end
    end
end

function BP_PlayerCharacter_C:TryCloseAllSkillUI()
    if self.SkillUINames then
        for UIName, bValid in pairs(self.SkillUINames) do
            if bValid then
                UIManager(self):UnLoadUINew(UIName)
            end
        end
    end
    self.SkillUINames = {}
end

function BP_PlayerCharacter_C:TryShowAllSkillUI()
    if not self:IsMainPlayer() then
        return
    end

    local GradeLevel = self:GetAttr("GradeLevel")
    local BattleCharInfo = DataMgr.BattleChar[self.CurrentRoleId]
    if BattleCharInfo.CharUIId then
        local ReplacedCharUIId = self:GetReplacedCharUIId(BattleCharInfo.CharUIId)
        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
        local UIManager = GameInstance:GetGameUIManager()
        local CharUIInfo = DataMgr.BattleCharUI[ReplacedCharUIId][GradeLevel]
        local UIObj = UIManager:GetUIObj(CharUIInfo.UIName)
        if UIObj then
            --UIObj:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            UIObj:Show()
        end
    end
end

function BP_PlayerCharacter_C:LeaveRecoveryTag(NewTag)
    self:TryShowAllSkillUI()
end

function BP_PlayerCharacter_C:TryEnterTalk()
    if self.EnterTalkDelegates then
        for _, EnterTalkDelegate in pairs(self.EnterTalkDelegates) do
            EnterTalkDelegate()
        end
        self.EnterTalkDelegates = nil
    end
end

function BP_PlayerCharacter_C:SetEndPointInfo(EndPointSeqEnable, EndPointLocation, EndPointRotation)
    self.EndPointSeqEnable = EndPointSeqEnable
    self.EndPointLocation = EndPointLocation
    self.EndPointRotation = EndPointRotation
end

function BP_PlayerCharacter_C:GetEndPointInfo()
    return self.EndPointSeqEnable, self.EndPointLocation, self.EndPointRotation
end

function BP_PlayerCharacter_C:OnPreDungeonSettlement()
    -- 如果角色死亡时进结算，关闭死亡界面
    self:OnRecoverDissolve()
    local BattleResurgenceUI = UIManager(self):GetUI(self:GetCurRecoveryUIName())
    if BattleResurgenceUI then 
        BattleResurgenceUI:ShowBattleMainUI()
    end
end

function BP_PlayerCharacter_C:GetDungeonSettlementWinMont(ScenePlayerIndex, WeaponMeleeOrRanged, SettlementData)
    local WinMont = "LevelFinish_Armory_Montage"
    local SkinData = DataMgr.Skin[self.CurrentSkinId]
    local ModelId = nil
    if SkinData ~= nil then
        ModelId = SkinData.SkinModelId
    end
    local ModelWinMont = "LevelFinish_Armory_"..ModelId.."_Montage"
    local PathExist = false
    DebugPrint("BP_PlayerCharacter_C:GetDungeonSettlementWinMont SkinId: ", self.CurrentSkinId, "ModelId: ", ModelId, "ModelWinMont", ModelWinMont)
    if ModelId and self:CheckLevelFinishMontagePath(ModelWinMont) then
        WinMont = ModelWinMont
        PathExist = true
    else
        local WeaponType = GWorld.GameInstance.ScenePlayers[ScenePlayerIndex].CurrentWeaponType or "Armory"
        if SettlementData and SettlementData.UseDefaultMontage then
            WeaponType = "Armory"
        end
        local WeaponWinMont = "LevelFinish_"..WeaponType.."_Montage"
        if self:CheckLevelFinishMontagePath(WeaponWinMont) then
            WinMont = WeaponWinMont
            PathExist = true
        end
        DebugPrint("BP_PlayerCharacter_C:GetDungeonSettlementWinMont WeaponType: ", WeaponType, "WeaponMeleeOrRanged: ", WeaponMeleeOrRanged, "WeaponWinMont", WeaponWinMont)
    end
    DebugPrint("BP_PlayerCharacter_C:GetDungeonSettlementWinMont WinMont: ", WinMont)
    return WinMont, PathExist
end

function BP_PlayerCharacter_C:OnDungeonSettlement(IsWin, Index, SettlementData)
    local PathExist = false
    if IsWin then
        -- local WeaponType = GWorld.GameInstance.ScenePlayers[Index].CurrentWeaponType or "Armory"
        -- if SettlementData and SettlementData.UseDefaultMontage then
        --     WeaponType = "Armory"
        -- end
        local WeaponMeleeOrRanged = GWorld.GameInstance.ScenePlayers[Index].CurrentWeaponMeleeOrRanged
        -- DebugPrint("BP_PlayerCharacter_C:OnDungeonSettlement WeaponType: ", WeaponType, "WeaponMeleeOrRanged: ", WeaponMeleeOrRanged)
        -- local WinMont = "LevelFinish_"..WeaponType.."_Montage"
        -- PathExist = self:CheckLevelFinishMontagePath(WinMont)
        -- if not PathExist then
        --     WinMont = "LevelFinish_Armory_Montage"
        -- end
        local WinMont, PathExistResult = self:GetDungeonSettlementWinMont(Index, SettlementData)
        PathExist = PathExistResult
        local BattleCharTag = self:GetBattleCharBodyType()
        local CameraParam = FVector(0, 0, 0)
        local CameraRotationParam = FRotator(0, 0, 0)
        if SettlementData then
            if SettlementData.CameraParam and SettlementData.CameraParam[BattleCharTag] then
                CameraParam.X = SettlementData.CameraParam[BattleCharTag][1]
                CameraParam.Y = SettlementData.CameraParam[BattleCharTag][2]
                CameraParam.Z = SettlementData.CameraParam[BattleCharTag][3]
            end
            if SettlementData.CameraRotationParam and SettlementData.CameraRotationParam[BattleCharTag] then
                CameraRotationParam.Pitch = -SettlementData.CameraRotationParam[BattleCharTag][2]
                CameraRotationParam.Yaw = SettlementData.CameraRotationParam[BattleCharTag][3]
                CameraRotationParam.Roll = -SettlementData.CameraRotationParam[BattleCharTag][1]
            end 
        end
        -- local RealParam = UE4.UKismetMathLibrary.TransformLocation(self:GetTransform(), CameraParam) - FVector(0, 0, self.CapsuleComponent:GetUnscaledCapsuleHalfHeight())
        -- local NewTranslation = UE4.UKismetMathLibrary.TransformLocation(self:GetTransform(), CameraParam)
        -- local CameraRotationParam = FRotator(0, 0, 0)
        -- if SettlementData.CameraRotationParam then
        --     CameraRotationParam = FRotator(SettlementData.CameraRotationParam[2],
        --                                 SettlementData.CameraRotationParam[3],
        --                                 SettlementData.CameraRotationParam[1])
        -- end
        DebugPrint("BP_PlayerCharacter_C:OnDungeonSettlement BattleCharTag", BattleCharTag, "CameraParam", CameraParam, "CameraRotationParam")
        -- self:K2_SetActorLocation(NewTranslation, false, nil, true)
        self:PlayDungeonSettlementSimpleSkillFeature(false, false, false, false, true, true, CameraParam, CameraRotationParam)
        -- NewTranslation = UE4.UKismetMathLibrary.TransformLocation(self:GetTransform(), -CameraParam)
        -- self:K2_SetActorLocation(NewTranslation, false, nil, true)
        self:PlayActionMontage("Interactive/LevelFinish", WinMont, {})
        self:SetEndPointOffset(Index, SettlementData)
        DebugPrint("BP_PlayerCharacter_C:OnDungeonSettlement PlayActionMontage: ", WinMont)
        if WeaponMeleeOrRanged then 
            self:ChangeUsingWeaponByType(WeaponMeleeOrRanged)
        end
    else
        local WinMont = "LevelFinish_Fail_Montage"
        local PlayerController = self:GetController()
        local ControlRotation = PlayerController:GetControlRotation()
        local CharacterRotation = self:K2_EMGetActorRotation()
        PlayerController:SetControlRotation(FRotator(ControlRotation.Pitch, CharacterRotation.Yaw + 180, ControlRotation.Roll))
        self:PlayActionMontage("Interactive/LevelFinish", WinMont, {})
        self:ResetOnSetEndPoint()
    end
    self:SetCharacterTag("LevelFinish")
    -- print(_G.LogTag, "OnDungeonSettlementByIndex", Index, CurrentWeaponType, CurrentWeaponMeleeOrRanged, SettlementData)
    if IsWin and GWorld.GameInstance.ScenePlayers[Index].CurrentWeaponType and PathExist then
        self.KeepWeaponOnHand = true
        if self.WeaponPos ~= 2 then 
            self:BindWeaponToHand()
        end
    end

    -- 如果角色死亡时进结算，关闭死亡界面
    -- self:OnRecoverDissolve()
    -- local BattleResurgenceUI = UIManager(self):GetUI(self:GetCurRecoveryUIName())
    -- if BattleResurgenceUI then 
    --     BattleResurgenceUI:ShowBattleMainUI()
    -- end
end

function BP_PlayerCharacter_C:PlayDungeonSettlementMVPMontage(FileName)
    -- self:PlayMontageByPath(Const.MVPMontagePath)
    DebugPrint("PlayDungeonSettlementMVPMontage FileName", FileName)
    -- '/Game/Asset/Char/Player/Char001_Heitao_J/Animation/Montage/Interactive/MVPShow/Heitao_MVPShow_01_Montage.Heitao_MVPShow_01_Montage'
    self:PlayActionMontage("Interactive/MVPShow", FileName, {})
    self:SetCharacterTag("LevelFinish")
end

function BP_PlayerCharacter_C:PlayDungeonSettlementMVPSequence(FolderPath,Offset)
    -- local BattleCharBodyType = self:GetBattleCharBodyType()
    local SequencePath = "/Game/Asset/Char/Player/Common/MVPShow/"..FolderPath.."/Sequence/"..FolderPath.."_MVPShow_Cam."..FolderPath.."_MVPShow_Cam"
    self:PlayMVPSequence(SequencePath,Offset)
end

function BP_PlayerCharacter_C:OnMVPSequenceFinish()
    local MVPUI = UIManager(self):GetUIObj("SettlementMVP")
    if MVPUI then
        MVPUI:OnSequenceFinish()
    end
    EventManager:FireEvent(EventID.OnMVPSequenceFinish)
end

-- function BP_PlayerCharacter_C:PlayDungeonSettlementFailDeadMontage()
--     local MontageFolder, MontagePrefix = self:GetHitMontageFolderAndPrefix()
--     if MontageFolder ~= nil then
--         local HitMontage = MontageFolder.."Combat/Hit/"..MontagePrefix.."Die"..Const.MontageSuffix.."."..MontagePrefix.."Die"..Const.MontageSuffix
--         local AnimationAsset = LoadObject(HitMontage)
--         if not AnimationAsset then
--             DebugPrint("Error: Load Montage Failed!!!", HitMontage)
--             return
--         end
--         self.Mesh:SetHiddenInGame(true)
--         self.PartsMesh:SetHiddenInGame(true)
--         self.PlayerAnimInstance:Montage_Play(AnimationAsset, 1.0, UE4.EMontagePlayReturnType.Duration, 3, true)
--     end
-- end

function BP_PlayerCharacter_C:CheckLevelFinishMontagePath(MontageSuffix)
    local RootPath = UBlueprintPathsLibrary.ProjectContentDir()
    local ModelId = self:GetCharModelComponent():GetCurrentModelId()
    local ModelData = DataMgr.Model[ModelId]
    local PlayerAnimPath = ModelData.MontageFolder or ""
    local Prefix = ModelData.MontagePrefix or ""
    if not Prefix then return false end
    PlayerAnimPath = string.gsub(PlayerAnimPath, "/Game/", RootPath)
    local MontPath = PlayerAnimPath.."Interactive/LevelFinish/"..Prefix..MontageSuffix..".uasset"
    DebugPrint("CheckLevelFinishMontagePath MontPath:", MontPath)
    if UBlueprintPathsLibrary.FileExists(MontPath) then
        return true
    end
    DebugPrint("CheckLevelFinishMontagePath: File not Exists")
    return false
end

function BP_PlayerCharacter_C:OnDungeonSettlementByIndex(Index, CurrentWeaponType, CurrentWeaponMeleeOrRanged, SettlementData)
    -- local WeaponType = CurrentWeaponType or "Armory"
    -- if SettlementData and SettlementData.UseDefaultMontage then
    --     WeaponType = "Armory"
    -- end
    local WeaponMeleeOrRanged = CurrentWeaponMeleeOrRanged
    -- local WinMont = "LevelFinish_"..WeaponType.."_Montage"
    -- local PathExist = self:CheckLevelFinishMontagePath(WinMont)
    -- if not PathExist then
    --     WinMont = "LevelFinish_Armory_Montage"
    -- end
    local WinMont, PathExist = self:GetDungeonSettlementWinMont(Index, WeaponMeleeOrRanged, SettlementData)
    self:PlayActionMontage("Interactive/LevelFinish", WinMont, {})
    self:SetEndPointOffset(Index, SettlementData)
    DebugPrint("BP_PlayerCharacter_C:OnDungeonSettlementByIndex PlayActionMontage: ", WinMont)
    if WeaponMeleeOrRanged then 
        self:ChangeUsingWeaponByType(WeaponMeleeOrRanged)
    end
    self:SetCharacterTag("LevelFinish")
    -- print(_G.LogTag, "OnDungeonSettlementByIndex", Index, CurrentWeaponType, CurrentWeaponMeleeOrRanged, SettlementData)
    if CurrentWeaponType and PathExist then
        self.KeepWeaponOnHand = true
        if self.WeaponPos ~= 2 then 
            self:BindWeaponToHand()
        end
    end
end

function BP_PlayerCharacter_C:SetMainPlayerDungeonSettlementTransform(IsMoveToTempScene, MainPlayerOriginLoc, MainPlayerOriginRot)
    if IsMoveToTempScene then
        -- 切换场景按表里配的位置来
        self:ResetIdle()
        local StartPoint = MainPlayerOriginLoc + FVector(0, 0, self.CapsuleComponent:GetUnscaledCapsuleHalfHeight())
        local EndPoint = MainPlayerOriginLoc + FVector(0, 0, -500)
        local HitResultLine = FHitResult()
        UE4.UKismetSystemLibrary.LineTraceSingle(self, StartPoint, EndPoint, ETraceTypeQuery.TraceScene, false, nil, EDrawDebugTrace.None, HitResultLine, true)
        local ImpactZ = HitResultLine.ImpactPoint.Z
        local NewTranslation = FVector(MainPlayerOriginLoc.X, MainPlayerOriginLoc.Y, ImpactZ + self.CapsuleComponent:GetUnscaledCapsuleHalfHeight())
        self:K2_SetActorLocationAndRotation(NewTranslation, MainPlayerOriginRot, false, nil, true)
    else
        local EMGameState = UE4.UGameplayStatics.GetGameState(self)
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
            return
        end
        -- 不切换场景，梦魇或区域副本
        self:ResetIdle()
        local EndPoint = MainPlayerOriginLoc + FVector(0, 0, -500)
        local HitResultLine = FHitResult()
        UE4.UKismetSystemLibrary.LineTraceSingle(self, MainPlayerOriginLoc, EndPoint, ETraceTypeQuery.TraceScene, false, nil, EDrawDebugTrace.None, HitResultLine, true)
        local ImpactZ = HitResultLine.ImpactPoint.Z
        local NewTranslation = FVector(MainPlayerOriginLoc.X, MainPlayerOriginLoc.Y, ImpactZ + self.CapsuleComponent:GetUnscaledCapsuleHalfHeight())
        self:K2_SetActorLocation(NewTranslation, false, nil, true)
        self:K2_SetActorRotation(MainPlayerOriginRot, false)
    end
end

function BP_PlayerCharacter_C:SetOtherPlayerDungeonSettlementTransform()
    self:ResetIdle()
    local CurrentLoc = self:K2_GetActorLocation()
    local StartPoint = CurrentLoc + FVector(0, 0, self.CapsuleComponent:GetUnscaledCapsuleHalfHeight())
    local EndPoint = CurrentLoc + FVector(0, 0, -500)
    local HitResultLine = FHitResult()
    UE4.UKismetSystemLibrary.LineTraceSingle(self, StartPoint, EndPoint, ETraceTypeQuery.TraceScene, false, nil, EDrawDebugTrace.None, HitResultLine, true)
    local ImpactZ = HitResultLine.ImpactPoint.Z
    local NewTranslation = FVector(CurrentLoc.X, CurrentLoc.Y, ImpactZ + self.CapsuleComponent:GetUnscaledCapsuleHalfHeight())
    self:K2_SetActorLocation(NewTranslation, false, nil, true)
end

function BP_PlayerCharacter_C:SetEndPointOffset(Index, SettlementData)
    local Offset = FVector(0, 0, 0)
    if SettlementData and SettlementData.SettlementOffset then
        Offset.X = SettlementData.SettlementOffset[Index][1]
        Offset.Y = SettlementData.SettlementOffset[Index][2]
        Offset.Z = SettlementData.SettlementOffset[Index][3]
    end
	local NewTranslation = UE4.UKismetMathLibrary.TransformLocation(self:GetTransform(), Offset)
	self:K2_SetActorLocation(NewTranslation, false, nil, true)
end

function BP_PlayerCharacter_C:ResetOnSetEndPoint()
    self.CharacterMovement.Velocity = FVector(0, 0, 0)
    self:AddGravityModifier(UE4.EGravityModifierTag.AnimNotify, 0)
	self:SetActorEnableCollision(false)
end

-- -- 获取玩家复活次数
-- function BP_PlayerCharacter_C:GetRecoveryCount()
--     ---@type UE.AEMPlayerState
--     local PlayerState = self.PlayerState
--     if PlayerState then 
--         return PlayerState.RecoveryCount
--     end

--     return self.RecoveryCount
-- end

-- -- 设置玩家复活次数
-- function BP_PlayerCharacter_C:SetRecoveryCount(Count)
--     local PlayerState = self.PlayerState
--     if PlayerState then 
--         PlayerState.RecoveryCount = Count
--     end 
--     self.RecoveryCount = Count
-- end

-- -- 获取玩家最大复活次数
-- function BP_PlayerCharacter_C:GetRecoveryMaxCount()
--     local PlayerState = self.PlayerState
--     local AdditionalRecoverTime = self:GetAttr("AdditionalRecoverTime") or 0
--     if PlayerState then 
--         -- DebugPrint("Tianyi@ ReocveryMaxCount " , PlayerState.RecoveryMaxCount) 
--         return PlayerState.RecoveryMaxCount < 0 and -1 or (PlayerState.RecoveryMaxCount + AdditionalRecoverTime)
--     end
--     return self.RecoveryMaxCount < 0 and -1 or (self.RecoveryMaxCount + AdditionalRecoverTime)
-- end

-- -- 设置玩家最大复活次数
-- function BP_PlayerCharacter_C:SetRecoveryMaxCount(Count)
--     local PlayerState = self.PlayerState
--     if PlayerState then 
--         PlayerState.RecoveryMaxCount = Count
--     end
--     self.RecoveryMaxCount = Count 
-- end

-------------------------------
-- -- 获取玩家复活魅影次数
-- function BP_PlayerCharacter_C:GetPhantomRecoveryCount()
--     ---@type UE.AEMPlayerState
--     local PlayerState = self.PlayerState
--     if PlayerState then 
--         return PlayerState.PhantomRecoveryCount
--     end

--     return self.PhantomRecoveryCount
-- end

-- 设置玩家复活魅影次数
-- function BP_PlayerCharacter_C:SetPhantomRecoveryCount(Count)
--     local PlayerState = self.PlayerState
--     if PlayerState then 
--         PlayerState.PhantomRecoveryCount = Count
--     end 
--     self.PhantomRecoveryCount = Count
-- end

-- -- 获取玩家最大复活魅影次数
-- function BP_PlayerCharacter_C:GetPhantomRecoveryMaxCount()
--     local PlayerState = self.PlayerState
--     if PlayerState then 
--         return PlayerState.PhantomRecoveryMaxCount
--     end
--     return self.PhantomRecoveryMaxCount
-- end

-- -- 设置玩家最大复活魅影次数
-- function BP_PlayerCharacter_C:SetPhantomRecoveryMaxCount(Count)
--     local PlayerState = self.PlayerState
--     if PlayerState then 
--         PlayerState.PhantomRecoveryMaxCount = Count
--     end
--     self.PhantomRecoveryMaxCount = Count 
-- end

-- function BP_PlayerCharacter_C:AddPhantomRecoveryCount(AddCount)
--     local PlayerState = self.PlayerState 
--     if PlayerState then
--         PlayerState.PhantomRecoveryCount = PlayerState.PhantomRecoveryCount + AddCount
--     end
--     self.PhantomRecoveryCount = self.PhantomRecoveryCount + AddCount
-- end

-- function BP_PlayerCharacter_C:CheckCanRecoverPhantom()
--     local PlayerState = self.PlayerState 
--     if PlayerState then 
--         return PlayerState.PhantomRecoveryMaxCount < 0 or PlayerState.PhantomRecoveryCount < PlayerState.PhantomRecoveryMaxCount 
--     end

--     return self.PhantomRecoveryMaxCount < 0 or self.PhantomRecoveryCount < self.PhantomRecoveryMaxCount
-- end


function BP_PlayerCharacter_C:CheckCanRecovery()
    if IsClient(self) then 
        local RecoveryCount = self:GetRecoveryCount()
        local RecoveryMaxCount = self:GetRecoveryMaxCount()
        return RecoveryMaxCount < 0 or RecoveryCount < RecoveryMaxCount
    else 
        return self.Super.CheckCanRecovery(self)
    end
end

-- function BP_PlayerCharacter_C:AddRecoveryCount(AddCount)
--     local PlayerState = self.PlayerState 
--     if PlayerState then
--         PlayerState.RecoveryCount = PlayerState.RecoveryCount + AddCount
--     end
--     self.RecoveryCount = self.RecoveryCount + AddCount
-- end

-- @zyh 手机触控已挪到C++
-- function BP_PlayerCharacter_C:OnInputTouchPressed(Location,FingerIndex)
--     DebugPrint("@zyh调试 手指按下", FingerIndex)
--     if(self.FirstTouchFinger == nil)then
--         self.FirstTouchFinger = FingerIndex
--         self.TouchStart = Location
--     elseif(self.SecondTouchFinger == nil)then
--         self.SecondTouchFinger = FingerIndex
--         local Distance = self:GetTwoPointDistance()
--         if Distance == nil then
--             return
--         end
--         self.CanScaleCamera = true
--         self.InitDistance = Distance
--     end
-- end

-- function BP_PlayerCharacter_C:OnInputTouchReleased(Location,FingerIndex)
--     DebugPrint("@zyh调试 手指送开", FingerIndex)
--     if(FingerIndex == self.FirstTouchFinger)then
--         self.FirstTouchFinger = nil
--     elseif(FingerIndex == self.SecondTouchFinger)then
--         self.SecondTouchFinger = nil
--         self.CanScaleCamera = false
--     end
-- end

-- function BP_PlayerCharacter_C:OnInputTouchMoved(Location,FingerIndex)
--     DebugPrint("@zyh调试 手指移动", FingerIndex)
--     DebugPrint("可以移动相机的手指序号", self.FirstTouchFinger)
--     if self.CanScaleCamera == true then
--         local Distance = self:GetTwoPointDistance()
--         if Distance == nil then
--             return
--         end
--         local DeltaDistance = self.InitDistance - Distance
--         if DeltaDistance > 100 then -- @zyh:不知道尺度多少 先写个值试试
--             self:ChangeCameraLengthOnMouseWheel(false)
--             self.InitDistance = Distance
--         elseif DeltaDistance < -100 then
--             self:ChangeCameraLengthOnMouseWheel(true)
--             self.InitDistance = Distance
--         end
--         -- Flag在手势引导内被设置，需要发送事件通知
--         if (self.NeedFireEventForZoomGuide) then
--             EventManager:FireEvent(EventID.ZoomInOutGesture)
--             self.NeedFireEventForZoomGuide = false
--         end
--     elseif self.FirstTouchFinger == FingerIndex then
--         local DiffDistance = self.TouchStart - Location
--         DebugPrint("移动的距离是", DiffDistance, "两点是", self.TouchStart, Location)
--         local DeltaSeconds = UE4.UGameplayStatics.GetWorldDeltaSeconds(self)
--         --DebugPrint("调试OnInputTouchMoved","相差时间：", DeltaSeconds, DeltaSeconds * DiffDistance.Y, DeltaSeconds * DiffDistance.X)
--         local AddPitch = math.clamp(DeltaSeconds * DiffDistance.Y * self.TurnSpeedPitch,-1 * self.TurnLimitPitch, self.TurnLimitPitch)
--         local AddYaw = math.clamp(DeltaSeconds * DiffDistance.X * self.TurnSpeedYaw,-1 * self.TurnLimitYaw, self.TurnLimitYaw)
--         self:AddCharacterPitchInput(AddPitch)
--         self:AddCharacterYawInput(AddYaw)
--         self.TouchStart = Location
--         -- Flag在手势引导内被设置，需要发送事件通知
--         if (self.NeedFireEventForLookAroundGuide) then
--             EventManager:FireEvent(EventID.MoveAroundGesture)
--             self.NeedFireEventForLookAroundGuide = false
--         end
--     else
--         return
--     end
-- end

-- function BP_PlayerCharacter_C:CleanInputWhenEnterTalk()
--     DebugPrint("进入Sequence清除手指触摸")
--     self.CanMoveCamera = false
--     self.CanScaleCamera = false
--     self.SecondTouchFinger = nil
--     self.FirstTouchFinger = nil
-- end

-- function BP_PlayerCharacter_C:GetTwoPointDistance()
--     local Controller = UGameplayStatics.GetPlayerController(self, 0)
--     local Touch1_X, Touch1_Y, Touch1_Pressed = Controller.GetInputTouchState(Controller, ETouchIndex.Touch1)
--     local Touch2_X, Touch2_Y, Touch2_Pressed = Controller.GetInputTouchState(Controller, ETouchIndex.Touch2)
--     if Touch1_Pressed and Touch2_Pressed then
--         return math.sqrt((Touch1_X - Touch2_X) *(Touch1_X - Touch2_X) + (Touch1_Y - Touch2_Y) * (Touch1_Y - Touch2_Y))
--     end
--     return nil
-- end

function BP_PlayerCharacter_C:SetIsJumpPadLaunched(value)
    self.PlayerAnimInstance.IsJumpPadLaunched = value
end

function BP_PlayerCharacter_C:SetIsJumpPadLaunching(value)
    self.PlayerAnimInstance.IsJumpPadLaunching = value
end

function BP_PlayerCharacter_C:GetBattleExtraInfo()
    local AvatarInfo = {}
    local PlayerHp = self:GetAttr("Hp")
    local PlayerSp = self:GetAttr("Sp")
    local DeathInfo = {
        RecoveryCount = self:GetRecoveryCount(),
        IsRealDead = false
    }
    if self:IsDead() then
        PlayerHp = self:GetAttr("MaxHp")
        PlayerSp = self:GetAttr("MaxSp")
        DeathInfo.RecoveryCount = math.min(DeathInfo.RecoveryCount + 1, self:GetRecoveryMaxCount())
    end
    AvatarInfo.RoleInfo = {
        Level = self:GetAttr("Level"),
        Exp = self:GetAttr("Exp"),
        PlayerHp = PlayerHp,
        PlayerSp = PlayerSp,
        DeathInfo = DeathInfo,
    }
    if self.MeleeWeapon then
        AvatarInfo.MeleeWeapon = {
            Level = self.MeleeWeapon:GetAttr("Level"),
            Exp = self.MeleeWeapon:GetAttr("Exp"),
        }
    end
    if self.RangedWeapon then
        AvatarInfo.RangedWeapon = {
            Level = self.RangedWeapon:GetAttr("Level"),
            Exp = self.RangedWeapon:GetAttr("Exp"),
            BulletNum = self.RangedWeapon:GetAttr("BulletNum") or 0,
            MagazineBulletNum = self.RangedWeapon:GetAttr("MagazineBulletNum") or 0,
        }
    end
    -- if self.UltraWeapon then
    --     AvatarInfo.UltraWeapon = {
    --         Level = self.UltraWeapon:GetAttr("Level"),
    --         Exp = self.UltraWeapon:GetAttr("Exp"),
    --     }
    -- end
    if self.UltraWeapons then
        AvatarInfo.UltraWeapons = {}
        for _, weapon in pairs(self.UltraWeapons) do
            table.insert(AvatarInfo.UltraWeapons, {
                Level = weapon:GetAttr("Level"),
                Exp = weapon:GetAttr("Exp"),
            })
        end
    end
    local PhantomTeammate = self:GetPhantomTeammates(false, true)
    for Index, Target in pairs(PhantomTeammate) do
        local PlayerHp = Target:GetAttr("Hp")
        local PlayerSp = Target:GetAttr("Sp")
        local DeathInfo = {
            RecoveryCount = Target:GetRecoveryCount(),
            IsRealDead = false
        }
        if Target:IsDead() then -- 如果目标此时已死亡，预扣一次复活次数
            if Target:IsRealDead() then
                DeathInfo.IsRealDead = true
            else
                DeathInfo.RecoveryCount = math.min(DeathInfo.RecoveryCount + 1, Target:GetRecoveryMaxCount())
            end
        end
        AvatarInfo["PhantomInfo" .. Index] = {}
        AvatarInfo["PhantomInfo" .. Index].RoleInfo = {
            Level = self:GetAttr("Level"),
            PlayerHp = PlayerHp,
            PlayerSp = PlayerSp,
            DeathInfo = DeathInfo,
        }
        local PhantomWeapon = Target:GetPhantomWeapon()
        if PhantomWeapon:HasTag(CommonConst.WeaponType.RangedWeapon) then
            AvatarInfo["PhantomInfo" .. Index].RangedWeapon = {
                BulletNum = PhantomWeapon:GetAttr("BulletNum") or 0,
                MagazineBulletNum = PhantomWeapon:GetAttr("MagazineBulletNum") or 0,
            }
        end
    end
    return AvatarInfo
end

function BP_PlayerCharacter_C:GetCurPhantomInfo()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    local CurPhantomInfo = {}

    local PhantomTeammate = self:GetPhantomTeammates()
    local PhantomTable = {}
    local WeaponToPhantom = {}
    for _, Teammate in pairs(PhantomTeammate) do
        if Teammate:IsPhantom() and (Teammate.IsSpawnByResource or Teammate.IsSpawnBySquad) then
            local MeleeWeapon = Teammate.MeleeWeapon
            local RangedWeapon = Teammate.RangedWeapon
            local WeaponId = nil
            if MeleeWeapon then
                WeaponId = MeleeWeapon.WeaponId
            elseif RangedWeapon then
                WeaponId = RangedWeapon.WeaponId
            end
            if WeaponId then
                WeaponToPhantom[WeaponId] = Teammate.CurrentRoleId
            end
            PhantomTable[Teammate.CurrentRoleId] = Teammate
        end
    end

    for _, Char in pairs(Avatar.Chars) do
        if PhantomTable[Char.CharId] then
            local Mods = {}
            local ModSuit = Char:GetModSuit()
            for _,v in pairs(ModSuit) do
                if v.ModEid and Avatar.Mods[v.ModEid] then
                    local Mod = Avatar.Mods[v.ModEid]
                    local ModInfo = {
                        ModId = Mod.ModId,
                        Level = Mod.Level
                    }
                    table.insert(Mods, ModInfo)
                end
            end
            CurPhantomInfo[Char.CharId] = {}
            CurPhantomInfo[Char.CharId].Character = {
                CharId = Char.CharId,
                Level = Char.Level,
                ModSuit = Mods
            }
        end
    end

    for _, Weapon in pairs(Avatar.Weapons) do
        local PhantomCharId = WeaponToPhantom[Weapon.WeaponId]
        if PhantomCharId then
            if CurPhantomInfo[PhantomCharId] then
                local Mods = {}
                local ModSuit = Weapon:GetModSuit()
                for _,v in pairs(ModSuit) do
                    if v.ModEid and Avatar.Mods[v.ModEid] then
                        local Mod = Avatar.Mods[v.ModEid]
                        local ModInfo = {
                            ModId = Mod.ModId,
                            Level = Mod.Level
                        }
                        table.insert(Mods, ModInfo)
                    end
                end
                CurPhantomInfo[PhantomCharId].Weapon = {
                    WeaponId = Weapon.WeaponId,
                    Level = Weapon.Level,
                    ModSuit = Mods
                }
            end
        end
    end

    return CurPhantomInfo
end

function BP_PlayerCharacter_C:RefreshTeamMemberInfo(OpType)
    if IsDedicatedServer(self) then
        -- DS上直接返回
        return
    end
    local PlayerAvatar = GWorld:GetAvatar()
    if ((not PlayerAvatar or GWorld:IsStandAlone()) or GameState(self).PlayerArray:Num() <= 1) then
        return
    end

    if (not self.PlayerState) then
        return
    end
	local MainPlayer = GWorld:GetMainPlayer()
    if (MainPlayer and MainPlayer.Eid == self.PlayerState.Eid) then
        -- 自己不处理
        return
    end
    local TeamData = TeamController:GetModel()
    local IsTeammate = TeamData:IsTeammateByAvatarEid(self.PlayerState.AvatarEidStr)

    if (IsTeammate) then
        -- 目前的话只有距离过远一种状态
        local State = AllPlayerBloodState.OverReach
        self.PlayerState.OnReceiveActorStateChangeDelegate:Broadcast(self.PlayerState.Eid, State, true, OpType == "ReceiveBeginPlay")
        -- local TargetEid = self.PlayerState.Eid
        -- local Entity = Battle(self):GetEntity(TargetEid)
        -- if (Entity and Entity.TeammateUI) then
        --     -- 处理一下队友过远
        --     Entity.TeammateUI:AddBloodState(TargetEid, State)
        -- end
    end
end

--region UStoryPlayableInterface
---@param OnFinished const FStoryPreEnterDelegate&
function BP_PlayerCharacter_C:PreEnterStory(OnFinished)
    if (self.bInStory) then
        StoryPlayableUtils:ExecuteStoryDelegate(OnFinished)
        return
    end

    self.bInStory = true
    self:CleanInputWhenEnterTalk()
    self:ReleaseFire()
    self:SetStealth(true, "Story")

    StoryPlayableUtils:ExecuteStoryDelegate(OnFinished)
end

function BP_PlayerCharacter_C:PreExitStory(OnFinished)
    if (not self.bInStory) then
        StoryPlayableUtils:ExecuteStoryDelegate(OnFinished)
        return
    end

    self.bInStory = false
    self:SetStealth(false, "Story")

    local TS = TalkSubsystem()
    if IsValid(TS) then
        TS:TalkHidePlayerCharacter(self, false, Const.TalkHideTag)
    end

    StoryPlayableUtils:ExecuteStoryDelegate(OnFinished)
end
--endregion

function BP_PlayerCharacter_C:_CheckCanChangeToMaster(ShowLog, CheckRegion)
    if not IsStandAlone(self) then
        if ShowLog then
            GWorld.logger.error("联机情况下，不能切换女主")
        end
        return false
    end
    if self:CheckSkillIsBan(ESkillName.SwitchMasterOrHero) then 
        if ShowLog then
            GWorld.logger.error("禁用切换女主和切回去英雄技能")
        end
        return false
    end
    if self:CheckSkillInActive(ESkillName.SwitchMasterOrHero) then
        if ShowLog then
            GWorld.logger.error("切换女主和切回去英雄技能未激活")
        end
        return false
    end
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local DungeonId = GWorld.GameInstance:GetCurrentDungeonId()
    if DungeonId and DungeonId > 0 then
        if ShowLog then
            GWorld.logger.error("副本内，不能切换女主")
        end
        return false
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        if ShowLog then
            GWorld.logger.error("没有连接服务器，不能切换女主")
        end
        return  false
    end

    -- local PlayerCharacterSuit = Avatar.Suits:GetSuitBase(CommonConst.SuitType.PlayerCharacterSuit)
    -- if PlayerCharacterSuit then
    --     local SwitchRoleId = PlayerCharacterSuit:GetSubSuitBase(CommonConst.PlayerCharacterSuit.SwitchRole)
    --     if SwitchRoleId ~= -1 then
    --         if ShowLog then
    --             GWorld.logger.error("剧情切了角色，不能切换女主")
    --         end
    --         return false
    --     end
    -- end

    local RegionId = Avatar:GetCurrentRegionId()
    if not RegionId or RegionId == 0 then
        if ShowLog then
            GWorld.logger.error("不在区域中或者区域编号出错，不能切换女主")
        end
        return false
    end

    local RegionInfo = DataMgr.SubRegion[RegionId]
    if not RegionInfo then
        if ShowLog then
            GWorld.logger.error("不在区域中或者区域编号出错，不能切换女主")
        end
        return false
    end

    return true
end

function BP_PlayerCharacter_C:CheckCanChangeToMaster(ShowLog, IsEnterRegion)
    self.CanChangeToMaster = self:_CheckCanChangeToMaster(ShowLog, true)
    if not(IsEnterRegion or self:CanEnterInteractive() and self:CharacterInTag('Idle') )then 
        if ShowLog then
            GWorld.logger.error("当前状态不允许切换女主")
        end
        self.CanChangeToMaster =  false
        return self.CanChangeToMaster
    end

    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not IsValid(GameMode) then
        self.CanChangeToMaster =  false
        if ShowLog then
            GWorld.logger.error("当前游戏模式无效, 不能切换女主")
        end
    else
        if GameMode:IsInDungeon() then
            if self:IsDungeonInBattle() then
                self.CanChangeToMaster = false
            end
        else
            if self:IsRegionInBattle() then
                self.CanChangeToMaster = false
            end
        end
    end

    return self.CanChangeToMaster
end

function BP_PlayerCharacter_C:CheckCanChangeBackToHero(ShowLog)
    return self:_CheckCanChangeToMaster(ShowLog, false)
end

function BP_PlayerCharacter_C:SwitchMasterOrHeroUIPerform()
    if not IsValid(self.BattleMainUI) then
        self.BattleMainUI = UIManager(self):GetUIObj("BattleMain")
    end
    if (self.BattleMainUI == nil or self.BattleMainUI.Char_Skill == nil) then
        return
    end
    self.BattleMainUI.Char_Skill:OnSwitchMasterOrHero()
end

function BP_PlayerCharacter_C:ChangeToMasterUIPerform()
    -- 发送隐藏血条事件
    EventManager:FireEvent(EventID.ShowOrHideMainPlayerBloodUI,false,"ChangeRoleToMaster")
    -- 改变技能面板形态
    if not IsValid(self.BattleMainUI) then
        self.BattleMainUI = UIManager(self):GetUIObj("BattleMain")
    end
    if (self.BattleMainUI == nil or self.BattleMainUI.Char_Skill == nil) then
        return
    end
    self.BattleMainUI.Char_Skill:OnChangeToMaster()
end

function BP_PlayerCharacter_C:ChangeBackToHeroUIPerform()
    -- 发送显示血条事件
    EventManager:FireEvent(EventID.ShowOrHideMainPlayerBloodUI,true,"ChangeRoleToMaster")
    -- 改变技能面板形态
    if not IsValid(self.BattleMainUI) then
        self.BattleMainUI = UIManager(self):GetUIObj("BattleMain")
    end
    if (self.BattleMainUI == nil or self.BattleMainUI.Char_Skill == nil) then
        return
    end
    self.BattleMainUI.Char_Skill:OnChangeBackToHero()
end

function BP_PlayerCharacter_C:SwitchMasterOrHero()
    --表现层
    self:SwitchMasterOrHeroUIPerform()
    -- 逻辑层
    if (self.IsSwitchFuncInCD) then
        return
    end
    
    if self.CurrentMasterBan then
        self:ChangeBackToHero()
    else
        self:ChangeToMaster(true)
    end
    self.IsSwitchFuncInCD = true
    self:AddTimer_Combat(1, function()
        self.IsSwitchFuncInCD = false
    end, false, 0, "SwitchFuncCDTimer")
end

function BP_PlayerCharacter_C:ChangeToMaster(ShowLog, IsEnterRegion)
    if not self:CheckCanChangeToMaster(ShowLog, IsEnterRegion) then
        return
    end
    if self.CurrentMasterBan then
        GWorld.logger.error("当前已经是主角状态，不能执行切主角操作")
        return 
    end

    -- 男女主选角暂时没有存档只能写死 111
    local MasterRoleId = 111
    local Avatar = GWorld:GetAvatar()

    local RegionId = Avatar:GetCurrentRegionId()
    print(_G.LogTag, "CheckCanChangeToMaster", RegionId)
    if(not RegionId or DataMgr.SubRegion[RegionId] == nil) then
        GWorld.logger.error("当前不在区域中，不能切换主角")
        return 
    end
    local PlayerIdentity = DataMgr.SubRegion[RegionId].SwitchPlayer
    if not PlayerIdentity then
        GWorld.logger.error("当前区域没有可切换角色，不能切换主角")
        return 
    end
    local MasterGender = 1
    if not Avatar then  
        GWorld.logger.error("没有正常登录，不能切换主角")
        return 
    end

    -- 临时存储角色当前状态
    self.HeroTempInfo = {
        RoleInfo = {
            PlayerHp = self:GetAttr("Hp"),
            PlayerSp = self:GetAttr("Sp"),
            PlayerES = self:GetAttr("ES"),
        },
        RangedWeapon = {
            BulletNum = self.RangedWeapon and self.RangedWeapon:GetAttr("BulletNum") or 0,
            MagazineBulletNum = self.RangedWeapon and self.RangedWeapon:GetAttr("MagazineBulletNum") or 0,
        },
    }
    Avatar.HeroTempInfo = self.HeroTempInfo

    if PlayerIdentity == "Player" then
        MasterGender = Avatar.Sex
    else
        MasterGender = Avatar.WeitaSex
    end
    print(_G.LogTag, "ChangeToMaster", MasterRoleId, MasterGender, PlayerIdentity)
    local MasterInfo = DataMgr.Player2RoleId[PlayerIdentity]
    if not MasterInfo then
        GWorld.logger.error("没有找到对应的主角信息，请检查导表")
        return 
    end
    local GenderInfo = MasterInfo[MasterGender]
    if not GenderInfo then 
        GWorld.logger.error("对应性别没有角色，请检查导表")
        return 
    end
    MasterRoleId = GenderInfo
    -- local ExtractInfo = {UseMasterRole = 1}
    -- print(_G.LogTag, "ChangeToMaster", MasterRoleId, ExtractInfo.UseMasterRole, MasterGender)
    self:ChangeRole(MasterRoleId, nil)
    self:RealChangeUsingWeapon(nil)
    self:ClearAllSuitItem()
    self:BanSkills()
    self.CurrentMasterBan = true
    -- local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar.CurrentMasterBan = true
    end
    self:CombindTwoKeyToOneCommand("Skill3", "SwitchMaster")
    self:ChangeToMasterUIPerform()

	self:DisableBattleWheel()

    local BattlePet = self:GetBattlePet()
    if BattlePet then
        BattlePet:HideBattlePet("Master", true)
    end
end

function BP_PlayerCharacter_C:ChangeBackToHero()
    if not self:CheckCanChangeBackToHero(true) then
        return
    end

    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	if not IsValid(GameMode) then
		return
	end
    if not self.CurrentMasterBan then
        GWorld.logger.error("当前不是女主状态，不能从女主切回军械库角色")
        return 
    end

    -- 恢复先前存储的角色状态
    self:RecoverBanSkills()
    self.NotChangeRoleTips = true
    self:RecoverHeroInfo()
    self:ChangeRole()
    self.NotChangeRoleTips = false
    self:WithChangeBackToHero()
end

function BP_PlayerCharacter_C:WithChangeBackToHero()
    self:SeparateTwoKeyToOneCommand("Skill3", "SwitchMaster")
    -- self:RecoverBanSkills()
    self:ChangeBackToHeroUIPerform()

    self:EnableBattleWheel()

    local BattlePet = self:GetBattlePet()
    if BattlePet then
        BattlePet:HideBattlePet("Master", false)
    end
end

function BP_PlayerCharacter_C:RecoverHeroInfo()
    local Avatar = GWorld:GetAvatar()
    local HeroTempInfo = self.HeroTempInfo or Avatar.HeroTempInfo
    if HeroTempInfo ~= nil then
        local Avatar = GWorld:GetAvatar()
        local PlayerController = self:GetController()
        local AvatarInfo = AvatarUtils:GetDefaultBattleInfo(Avatar)
        AvatarInfo = AvatarUtils:UpdateBattleInfo(AvatarInfo, HeroTempInfo)
        PlayerController:SetAvatarInfo(CommonUtils.ObjId2Str(Avatar.Eid), AvatarInfo)
        self.HeroTempInfo = nil
        Avatar.HeroTempInfo = nil
    end
end

function BP_PlayerCharacter_C:RecoverBanSkills()
    print(_G.LogTag, "RecoverBanSkills", self.CurrentRoleId)
    if self.CurrentMasterBan then
        self:UnBanSkills()
        self.CurrentMasterBan = false
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            Avatar.CurrentMasterBan = false
        end
    end
end

function BP_PlayerCharacter_C:OnBattleStateChanged(RegionInBattle)
    if(not RegionInBattle) then 
        return 
    end
    if not self.CurrentMasterBan then
        return

    end 
    print(_G.LogTag, "OnBattleStateChanged", RegionInBattle)
    self:ChangeBackToHero()

end
function BP_PlayerCharacter_C:BanSkills()
    local SkillNamesArray = TArray(0)
    for _,Skill in pairs(Const.AllSKillNames) do
        if not self:CheckSkillInActive(Skill) then 
            SkillNamesArray:Add(Skill)
        end
    end
    local Controller = self:GetController()
    if Controller then
        Controller:BanSkills(SkillNamesArray, "MasterBan")
    end
end

function BP_PlayerCharacter_C:UnBanSkills()
    local Controller = self:GetController()
    if Controller then
        Controller:UnBanSkills("MasterUnBan")
    end
end
function BP_PlayerCharacter_C:RegionBanSkills()
    local SkillNamesArray = TArray(0)
    for _,Skill in pairs(Const.AllSKillNames) do
        if not self:CheckSkillInActive(Skill) then 
            SkillNamesArray:Add(Skill)
        end
    end
    --SkillNamesArray:Add(ESkillName.SwitchMasterOrHero)
    local Controller = self:GetController()
    if Controller then
        Controller:BanSkills(SkillNamesArray, "RegionBan")
    end
end

function BP_PlayerCharacter_C:RegionUnBanSkills()
    local Controller = self:GetController()
    if Controller then
        Controller:UnBanSkills("RegionUnBan")
    end
end

function BP_PlayerCharacter_C:MoveAlongSplineBanSkills()
    local SkillNamesArray = TArray(0)
    for _,Skill in pairs(Const.AllSKillNames) do
        if not self:CheckSkillInActive(Skill) then 
            SkillNamesArray:Add(Skill)
        end
    end
    SkillNamesArray:Add(ESkillName.SwitchMasterOrHero)
    local Controller = self:GetController()
    if Controller then
        Controller:BanSkills(SkillNamesArray, "MoveAlongSpline")
    end
end

function BP_PlayerCharacter_C:MoveAlongSplineUnBanSkills()
    local Controller = self:GetController()
    if Controller then
        Controller:UnBanSkills("MoveAlongSpline")
    end
end

function BP_PlayerCharacter_C:ForbidActionWhileMoveAlongSpline(bForbid)
    local Controller = self:GetController()
    local SkillNamesArray = TArray(0)
    if Controller then
        if bForbid then
            local Skills = {
                ESkillName.Jump,
                ESkillName.Slide,
                ESkillName.BulletJump,
                ESkillName.Avoid,
                ESkillName.Crouch,
            }
            self.SplineMoveForbidAction = {}
            for _, SkillName in ipairs(Skills) do
                if not Controller:CheckSkillInActive(SkillName) then
                    table.insert(self.SplineMoveForbidAction, SkillName)
                    SkillNamesArray:Add(SkillName)
                end
            end
            Controller:InActiveSkills(SkillNamesArray,"MoveAlongSpline")
        else
            self.SplineMoveForbidAction = self.SplineMoveForbidAction or {}
            for _, SkillName in ipairs(self.SplineMoveForbidAction) do
                SkillNamesArray:Add(SkillName)
            end
            self.SplineMoveForbidAction = nil
            Controller:ActiveSkills(SkillNamesArray,"MoveAlongSpline")
        end
    end
end

function BP_PlayerCharacter_C:ForbidSkillsInHooking(bForbid)
    local Skills = {
        ESkillName.Fire,
        ESkillName.ChargeBullet,
        ESkillName.Attack,
        ESkillName.Jump,
        ESkillName.Avoid,
        ESkillName.Skill1,
        ESkillName.Skill2,
        ESkillName.Skill3,
        ESkillName.Slide,
    }
    local SkillNamesArray = TArray(0)
    for _,Skill in pairs(Skills) do
        SkillNamesArray:Add(Skill)
    end
    local Controller = self:GetController()
    if Controller then
        if bForbid then
            Controller:InActiveSkillsInHooking(SkillNamesArray)
        else
            Controller:ActiveSkillsEndHooking(SkillNamesArray)
        end
    end
end

function BP_PlayerCharacter_C:ForbidActiveSkills(bForbid)
    local Skills = {
        ESkillName.Skill1,
        ESkillName.Skill2,
        ESkillName.Skill3,
    }
    self:ForbidSkills(bForbid, Skills)
end

function BP_PlayerCharacter_C:ForbidAllSkillsByBuff(bForbid)
    local DisableSkillsBuffId = 311
    local BuffData = DataMgr.Buff[DisableSkillsBuffId]
    if not BuffData then return end
    local DisableSkills = BuffData.DisableSkills
    local Skills = {}
    for i,Skill in pairs(DisableSkills) do
        Skills[i] = ESkillName[Skill]
    end
    if bForbid then
        Battle(self):AddBuffToTarget(self, self, DisableSkillsBuffId, -1, nil, nil)
    else
        Battle(self):RemoveBuffFromTarget(self, self, DisableSkillsBuffId, false, -1)
    end
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManger = GameInstance:GetGameUIManager()
    local Widget = UIManger:GetUIObj("BattleMain")
    if not Widget then return end
	local SkillWidget = Widget.Char_Skill
    local StateName = bForbid and "Ban" or "UnBan"
    if not SkillWidget then return end
    for _,Skill in pairs(Skills) do
		SkillWidget:ChangeSkillButtonState(Skill, StateName)
	end
end

function BP_PlayerCharacter_C:ForbidAllSkills(bForbid)
    local Skills = {
        ESkillName.Skill1,
        ESkillName.Skill2,
        ESkillName.Skill3,
        ESkillName.Passive,
    }
    self:ForbidSkills(bForbid, Skills)
end

function BP_PlayerCharacter_C:ForbidMeleeSkills(bForbid)
    local Skills = {
        ESkillName.Attack,
        ESkillName.FallAttack,
        ESkillName.HeavyAttack,
        ESkillName.SlideAttack,
    }
    self:ForbidSkills(bForbid, Skills)
end

function BP_PlayerCharacter_C:ForbidRangedSkills(bForbid)
    local Skills = {
        ESkillName.Fire,
        ESkillName.ChargeBullet,
        ESkillName.HeavyShooting,
    }
    self:ForbidSkills(bForbid, Skills)
end

function BP_PlayerCharacter_C:ForbidSkills(bForbid, Skills)
    local SkillNamesArray = TArray(0)
    for _,Skill in pairs(Skills) do
        SkillNamesArray:Add(Skill)
    end
    local Controller = self:GetController()
    if Controller then
        if bForbid then
            Controller:InActiveSkills(SkillNamesArray, "Ban")
        else
            Controller:ActiveSkills(SkillNamesArray, "UnBan")
        end
    end
end

function BP_PlayerCharacter_C:AfterLoading(Eid)
    if self.AfterLoadingDone then 
        return
    end

    --如果缓存数据中开启了沉浸式模式，则进入沉浸式模式
    local bIsImmersionMode=EMCache:Get("ImmersionModel")
    if bIsImmersionMode then
        self:ImmersionModel()
    end
	self:RefreshCharUIByPlatform()

    -- 显示一下当前和鸣等级
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        if Avatar:CheckSubRegionType(nil, CommonConst.SubRegionType.Home) then
            self:CheckDraftCanProduce()
        end
    end

    -- 如果记录了需要播放落地动作则播放
    self.IsInDeliver = false
    self:SetActorHideTag("DeliveryMontage", false)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    if GameInstance and Eid and Eid == self.Eid then
        if GameInstance.ShouldPlayDeliveryEndMontage then
            local function NotifyBegin()
                DebugPrint("zwk OnDeliveryAfterLoadingMontageNotifyBegin")
                -- 动画通知移除Tag
                self:RemoveDisableInputTag("DeliverMontage")
            end
            local function Interrupted()
                DebugPrint("zwk OnDeliveryAfterLoadingInterrupted", GameInstance.ShouldPlayDeliveryEndMontage)
                self:RemoveDisableInputTag("DeliverMontage")
                GameInstance.ShouldPlayDeliveryEndMontage = false
            end
            local function Completed()
                DebugPrint("zwk OnDeliveryAfterLoadingMontageCompleted", GameInstance.ShouldPlayDeliveryEndMontage)
                GameInstance.ShouldPlayDeliveryEndMontage = false
            end
            local AllCallback = {
                OnNotifyBegin = NotifyBegin,
                OnInterrupted = Interrupted,
                OnCompleted = Completed
            }
            DebugPrint("zwk OnDeliveryAfterLoadingMontageBegin")

            if Avatar and Avatar.IsInRegionOnline and Avatar.CurrentOnlineType then
                self:ForceReSyncLocation()
                Avatar:SwitchOnlineState(Avatar.CurrentOnlineType, CommonConst.OnlineState.Normal)
            end

            self:ResetIdle()
            self:AddDisableInputTag("DeliverMontage")
            self:PlayTeleportAction(AllCallback, false, true, false)
            self.Mesh:GetAnimInstance():Montage_JumpToSection("End")

            local function RemoveDeliverTag()
                -- 保底移除一下
                if self.DisableInputTags:Find("DeliverMontage") then
                    DebugPrint("zwk RemoveDeliverTag")
                end
                self:RemoveDisableInputTag("DeliverMontage")
                self:SetActorHideTag("DeliveryMontage", false)
            end
            self:AddTimer(2, RemoveDeliverTag, false, 0)
        end
    end

    self.AfterLoadingDone = true
    self:AddTimer(1, function()
        self.AfterLoadingDone = false
    end)
    
    self:UpdateTeammateGesture()
end

function BP_PlayerCharacter_C:GetIsInDelivery()
    -- 一个比较宽泛的判断，现只用于联机座椅能否坐上去的判断
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local LoadingUI = GameInstance:GetLoadingUI()
    local bIsInLoading = LoadingUI and LoadingUI.bIsInLoading
    local bIsInBlackScreen = UIManager(self):GetUIObj("BlackScreenXiaobai")
    return bIsInLoading or bIsInBlackScreen or GameInstance.ShouldPlayDeliveryEndMontage or self.IsInDeliver
end

-- function BP_PlayerCharacter_C:CreateHitDirection(Attacker, OwnerPlayer, IsShiledDamage)
--     if not self.HitDirections then
--         self.HitDirections = {}
--         self.CurHitDirectionsNum = 0
--         local ConfigName = DataMgr.SystemUI["BattleHitDirection"].ConfigName
--         self.HitDirectionNum = ConfigName and DataMgr.SystemUIConfig[ConfigName].LimitCount or 4
--     end
--     local HitDirection = nil
--     if self.CurHitDirectionsNum>=self.HitDirectionNum and not self.HitDirections[self.CurHitDirectionsNum] then
--         return
--     elseif self.CurHitDirectionsNum>=self.HitDirectionNum or self.CurHitDirectionsNum>0 and self.HitDirections[self.CurHitDirectionsNum] and self.HitDirections[self.CurHitDirectionsNum].Finished then
--         local TS = TalkSubsystem()
--         if (not TS) or (not TS:IsGameUIHidden()) then
--         	HitDirection = table.remove(self.HitDirections, self.CurHitDirectionsNum)
-- 			HitDirection:Refresh(Attacker, OwnerPlayer, IsShiledDamage)
--             table.insert(self.HitDirections, 1, HitDirection)
--         end
--     else
--         self.CurHitDirectionsNum = self.CurHitDirectionsNum + 1
--         RunAsyncTask(self, "CreateHitDirectionHandler"..self.CurHitDirectionsNum, function(CoroutineObj)
--             local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
--             local UIManager = GameInstance:GetGameUIManager()
--             HitDirection = UIManager:LoadUIAsync("BattleHitDirection", CoroutineObj, Attacker, OwnerPlayer, IsShiledDamage)
--             table.insert(self.HitDirections, 1, HitDirection)
--         end)
--     end
-- end

function BP_PlayerCharacter_C:LoadHitDirection(HitDirectionsObject, Attacker)
    HitDirectionsObject.CurHitDirectionNum = HitDirectionsObject.CurHitDirectionNum + 1
    RunAsyncTask(self, "CreateHitDirectionHandler"..HitDirectionsObject.CurHitDirectionNum, function(CoroutineObj)
        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
        local UIManager = GameInstance:GetGameUIManager()
        local HitDirection = UIManager:LoadUIAsync("BattleHitDirection", CoroutineObj, Attacker, self)
        HitDirectionsObject:AddToQueue(HitDirection)
    end)
end

function BP_PlayerCharacter_C:TriggerBeAttacked()
    DebugPrint("BP_PlayerCharacter_C:TriggerBeAttacked")
    if self:IsMainPlayer() then 
        EventManager:FireEvent(EventID.MainPlayerBeAttacked, self)
    end
end

function BP_PlayerCharacter_C:DungeonOtherPlayerLeave()
	if not self:IsMainPlayer() and IsClient(self) then
		EventManager:FireEvent(EventID.OnDungeonOtherPlayerLeave, self)

		local UIObj = UIManager(self):GetUIObj("TeamToast")
		if UIObj then
			UIManager(self):UnLoadUINew("TeamToast")
		end
		UIManager(self):LoadUINew("TeamToast", self.PlayerState, false)
	end
end

function BP_PlayerCharacter_C:SetCollisionProfileOverlapAll(bSet)
    DebugPrint("BP_PlayerCharacter_C:SetCollisionProfileOverlapAll", bSet, self.CachedPlayerCollisionProfile)

    local bCurrentSet = self.CachedPlayerCollisionProfile ~= nil
    if (bCurrentSet == bSet) then
        --return
    end

    if bSet then
        self.CachedPlayerCollisionProfile = self.CapsuleComponent:GetCollisionProfileName()
        self.CapsuleComponent:SetCollisionResponseToAllChannels(UE4.ECollisionResponse.ECR_Overlap);
        if self.SkillBlockCapsule then
            self.SkillBlockCapsuleCachedCollision = self.SkillBlockCapsule:GetCollisionEnabled()
            self.SkillBlockCapsule:SetCollisionEnabled(ECollisionEnabled.NoCollision)
        end
    else
        self.CapsuleComponent:SetCollisionProfileName('Pawn', false)
        self.CachedPlayerCollisionProfile = nil
        if self.SkillBlockCapsule then
            self.SkillBlockCapsule:SetCollisionEnabled(self.SkillBlockCapsuleCachedCollision)
        end
    end
end

function BP_PlayerCharacter_C:NeedArmoryHelper()
    return GWorld:GetAvatar() ~= nil
end
function BP_PlayerCharacter_C:RequestDeadAsyncTravel(RespawnPointParams)
    self:DisablePlayerInputInDeliver(true)
    local GameInstance = GWorld.GameInstance
    ---@type BP_TalkContext_C
    local TalkContext = GameInstance:GetTalkContext()
    local UIManager = UIManager(GameInstance)
    local EMGameState = UE4.UGameplayStatics.GetGameState(self)
    local PlayerController = self:GetController()
    local bForceAsyncLoading = false
    local bResetCamera = false
    local Transform = RespawnPointParams.Transform

    local FadeOutCallback = function()
        UIManager:HideCommonBlackScreen("DeadAsyncTravel")
        local TaskIndicator = UIManager:GetUIObj("MainTaskIndicator")
        if IsValid(TaskIndicator) then
            TaskIndicator:SetVisibility(UE4.ESlateVisibility.Visible)
        end
        local SceneMgrComponent = GameInstance:GetSceneManager()
        local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        local LevelLoader = GameMode:GetLevelLoader()
        SceneMgrComponent:ShowOrHideAllSceneGuideIcon(true)
        self:EnableInput(PlayerController)
        if(IsValid(LevelLoader)) then
            local TargetLevelId = GameMode:GetLevelLoader():GetLevelIdByLocation(Transform.Translation)
            LevelLoader:RemoveArtLevelLoadedCompleteCallback(TargetLevelId)
        end
        self:DisablePlayerInputInDeliver(false)
        
        local StoryMgr = GWorld.StoryMgr
        if StoryMgr then
            StoryMgr:FailCurrentQuestWhenDead()
        end
    end

    local FadeInCallback=function()
        local GameInstance = GWorld.GameInstance
        local UIManager = GameInstance:GetGameUIManager()
        local SceneMgrComponent = GameInstance:GetSceneManager()
        SceneMgrComponent:ShowOrHideAllSceneGuideIcon(false)
        local TaskIndicator = UIManager:GetUIObj("MainTaskIndicator")
        if IsValid(TaskIndicator) then
            TaskIndicator:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        self:DisableInput()
        self:QuickRecovery()
        local GameMode = UE4.UGameplayStatics.GetGameMode(self)

        local SetActorTransform = function()
            GameMode:SetActorLocationAndRotationByTransform(0 ,Transform,true)
            self:SetSafeLocation()
            if bResetCamera then
                self:GetController():SetControlRotation(self:K2_GetActorRotation())
            end
        end

        local LevelLoader = GameMode:GetLevelLoader()

        self.DurationEnd = false
        self.TravelFinish = false
        local TryFadeOut = function()
            if self.DurationEnd and self.TravelFinish then
                self.DurationEnd = nil
                self.TravelFinish = nil
                FadeOutCallback()
            end
        end
        local TravelFinishCallback = function()
            self.TravelFinish = true
            TryFadeOut()
        end
        local DurationEndCallback = function()
            self.DurationEnd = true
            TryFadeOut()
        end

        GameMode:AddTimer(RespawnPointParams.ContinueTime, DurationEndCallback, false, 0, "CommonBlackScreenContinueTimer", true)

        if(IsValid(LevelLoader)) then
			local TargetLevelId = GameMode:GetLevelLoader():GetLevelIdByLocation(Transform.Translation)
			local CurrentLevelId = GameMode:GetLevelLoader():GetLevelIdByLocation(self:K2_GetActorLocation())
			local WorldCompositionSubsystem = GameMode:GetWCSubSystem()
            -- WC存在
            if WorldCompositionSubsystem then
                -- 强制异步加载场景
                if bForceAsyncLoading  then
                    WorldCompositionSubsystem:RequestAsyncTravel(TalkContext.Player, Transform, {TalkContext, TravelFinishCallback}, bResetCamera)
                -- 非强制异步加载场景
                else
                    -- TargetLocation的地面场景已加载，直接设置玩家位置
                    if WorldCompositionSubsystem:IsBigObjectLevelLoadedByLocation(Transform.Translation) then
                        SetActorTransform()
                        TravelFinishCallback()
                    else
                    -- 反之等场景加载后再设置玩家位置
                        WorldCompositionSubsystem:RequestAsyncTravel(TalkContext.Player, Transform, {TalkContext, TravelFinishCallback}, bResetCamera)
                    end
                end
                return
            -- WC不存在
            else
                --Do nothing
            end

            if LevelLoader:GetLevelLoaded(TargetLevelId) then
                SetActorTransform()
                TravelFinishCallback()
                return
            end

            if(TargetLevelId~=CurrentLevelId) then
                LevelLoader:BindArtLevelLoadedCompleteCallback(TargetLevelId, function()
                    SetActorTransform()
                    TravelFinishCallback()
                end)
                LevelLoader:LoadArtLevel(TargetLevelId)
            else
                SetActorTransform()
                TravelFinishCallback()
            end
        else
            SetActorTransform()
            TravelFinishCallback()
        end
    end

    UIManager:ShowCommonBlackScreen({
        BlackScreenHandle = "DeadAsyncTravel",
        BlackScreenText = GText(RespawnPointParams.FailBlackScreenText),
        InAnimationObj = self,
        InAnimationPlayTime = RespawnPointParams.FadeInTime or nil,
        InAnimationCallback = FadeInCallback,
        OutAnimationObj = self,
        OutAnimationCallback = nil,
        OutAnimationPlayTime = RespawnPointParams.FadeOutTime or nil,
    })
end

function BP_PlayerCharacter_C:TeleportToCloestTeleportPoint(OnTeleportSucceedDel, TargetLoc)
	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	if not GameMode then
		return false
	end
    if not GameMode:IsInRegion() then
        return
    end
	local WCSubsystem = GameMode:GetWCSubSystem()
	if not WCSubsystem then
		return
	end
	local RegionDataMgrSubSystem = GameMode:GetRegionDataMgrSubSystem()
	if not RegionDataMgrSubSystem then
		return
	end
	
	local GameState = UE4.UGameplayStatics.GetGameState(self)
	local ActorLocation = self:K2_GetActorLocation()
    if TargetLoc then
        ActorLocation = TargetLoc
    end
	local MinDistance = 2100000000
	local FinalStaticCreator = nil
	for _, StaticCreator in pairs(GameState.StaticCreatorMap) do
		if StaticCreator.UnitId == CommonConst.DeliveryAnchorMechanismUnitId and StaticCreator.UnitType == "Mechanism" then
			local LuaTableIndex = RegionDataMgrSubSystem:GetLuaDataIndex(StaticCreator.CreatedWorldRegionEid)
			if LuaTableIndex < 0 then
				goto continue
			end
			local bIsOpen = RegionDataMgrSubSystem.DataPool.RegionData[LuaTableIndex] and RegionDataMgrSubSystem.DataPool.RegionData[LuaTableIndex].State and RegionDataMgrSubSystem.DataPool.RegionData[LuaTableIndex].State.OpenState
			if not bIsOpen then
				goto continue
			end
			local Distance = ActorLocation:DistSquared(StaticCreator:K2_GetActorLocation())
			if MinDistance > Distance then
				MinDistance = Distance
				FinalStaticCreator = StaticCreator
			end
			::continue::
		end
	end
	if not FinalStaticCreator then
		for WorldRegionEid, CreatorId in pairs(RegionDataMgrSubSystem.CurRegionDeliverNew:ToTable()) do
            if RegionDataMgrSubSystem:CheckDeliverMechanismIsDefault(CreatorId) then
                FinalStaticCreator = GameState.StaticCreatorMap:FindRef(CreatorId)
                break
            end
		end
	end
	local PointIndex = 1
	if FinalStaticCreator then
        for _, Data in pairs(DataMgr.TeleportPoint) do
            if Data.StaticId == FinalStaticCreator.StaticCreatorId then
                PointIndex = Data.TeleportPointPos
            end
        end
    end
    -- local LevelId = FinalStaticCreator.WorldCompositionLevelId
    -- local LevelName = GameMode:GetWCSubSystem():GetParentLevelId(LevelId)
    local LevelName = GameMode:GetWCSubSystem():GetParentLevelIdByLocation(FinalStaticCreator and FinalStaticCreator:K2_GetActorLocation() or self.CurrentLocation)
	local WorldLoader = GameMode:GetLevelLoader()
	local TargtePoint = WorldLoader:GetStartPointByManager(LevelName, PointIndex)
	local Transform = TargtePoint:GetTransform()
	-- GameMode:HandleLevelDeliverBlackCurtainStart()
	WCSubsystem:RequestAsyncTravel(self, Transform, 
	{self, 
	function()
        if OnTeleportSucceedDel then OnTeleportSucceedDel() end
		-- GameMode:AddTimer(DataMgr.GlobalConstant.DeliveryBlackCurtainTime.ConstantValue, GameMode.HandleLevelDeliverBlackCurtainEnd, false, 0, "HandleLevelDeliver", true)
	end
	})
	return true
end

function BP_PlayerCharacter_C:InpActEvt_GlobalSlow_K2Node_InputActionEvent_1(Key)
    if TeamController and TeamController:GetTeamPopupBarOpen() then return end
    DebugPrint(LXYTag, "BP_PlayerCharacter_C:InpActEvt_GlobalSlow_K2Node_InputActionEvent_1")
    self.Overridden.InpActEvt_GlobalSlow_K2Node_InputActionEvent_1(self, Key)
end

function BP_PlayerCharacter_C:CallClientPrint_Lua(Text)
    print(LogTag, "服务器的输出为:" .. tostring(Text))
end

function BP_PlayerCharacter_C:SetEnableFallAtkDir()
    local bEnableFallAtkDir = EMCache:Get("EnableFallAtkDir")
    if bEnableFallAtkDir == nil then
        local OptionInfo = DataMgr.Option.FallAttackDirection
        local DefaultValue = OptionInfo.DefaultValue
        if CommonUtils.GetRuntimePlatform(self) == "Mobile" or (GWorld.GameInstance and GWorld.GameInstance:GetUseMapPhoneInPC()) then
            if OptionInfo.DefaultValueM then
                DefaultValue = OptionInfo.DefaultValueM
            end
        end
        bEnableFallAtkDir = true
        if DefaultValue == 'False' then
            bEnableFallAtkDir = false
        end
    end
    self:UpdateEnableFallAtkDir(bEnableFallAtkDir)
end

function BP_PlayerCharacter_C:UpdateEnableFallAtkDir(Enable)
    self.Overridden.UpdateEnableFallAtkDir(self, Enable)
    EMCache:Set("EnableFallAtkDir", Enable)
end

function BP_PlayerCharacter_C:GetCurrentCharUI()
    local BattleCharInfo = DataMgr.BattleChar[self.CurrentRoleId]
    if BattleCharInfo.CharUIId then
        return self:GetCharUIObj(BattleCharInfo.CharUIId)
    end
end

function BP_PlayerCharacter_C:GetCharUIObj(CharUIId)
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    if not IsValid(UIManager) then
        return nil
    end
    local GradeLevel = self:GetAttr("GradeLevel") or 0
    local CharUIInfo = DataMgr.BattleCharUI[CharUIId][GradeLevel]
    return UIManager:GetUIObj(CharUIInfo.UIName)
end

function BP_PlayerCharacter_C:K2_OnEndViewTarget(PC)
    EventManager:FireEvent(EventID.OnEndViewTarget)
end
function BP_PlayerCharacter_C:K2_OnBecomeViewTarget(PC)
    rawset(self, "Controller",PC)
    rawset(PC, "PlayerCameraManager",PC.PlayerCameraManager)
    EventManager:FireEvent(EventID.OnBecomeViewTarget)
end

function BP_PlayerCharacter_C:SetRegionOnlineState()
    local bAutoJoin = EMCache:Get("AutoJoin")
    if bAutoJoin == nil then
        local OptionInfo = DataMgr.Option.AutoJoin
        local DefaultValue = OptionInfo.DefaultValue
        if CommonUtils.GetRuntimePlatform(self) == "Mobile" then
            if OptionInfo.DefaultValueM then
                DefaultValue = OptionInfo.DefaultValueM
            end
        end
        bAutoJoin = true
        if DefaultValue == 'False' then
            bAutoJoin = false
        end
    end
    self:UpdateRegionOnlineState(bAutoJoin)
end
function BP_PlayerCharacter_C:UpdateRegionOnlineState(bOpen)
    self.bOpenRegionOnline = bOpen
    EMCache:Set("AutoJoin", bOpen)
end
function BP_PlayerCharacter_C:GetPlayerGender(bOpen)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        return Avatar.Sex
    else
        return 0
    end
end

function BP_PlayerCharacter_C:GetTeamMemberEidArray()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    if not TeamController or not TeamController:GetModel() or not GameInstance then
        return {}
    end
    local ScenceManager = GameInstance:GetSceneManager()
    if not ScenceManager or not ScenceManager.RegionOnlineCharacterInfo then
        return {}
    end
    local Team = TeamController:GetModel():GetTeam() or {}
    local Eids = {}
    for _,TeamMember in pairs(Team.Members or {}) do
        if TeamMember then
            table.insert(Eids,ScenceManager.RegionOnlineCharacterInfo[TeamMember.Uid])
        end
    end
    return Eids
end

function BP_PlayerCharacter_C:EnterRegionOnlineRegisterTeamEvent(bEnterRegionOnline)
    if not TeamController or not TeamController:GetModel() then
        return
    end
    local RegionSyncSubsys = UE4.URegionSyncSubsystem.GetInstance(self)
    if bEnterRegionOnline then
        TeamController:RegisterEvent(self,function (self,EventId,...)
            DebugPrint("EnterRegionOnlineRegisterTeamEvent  ".. EventId)
            if EventId == TeamCommon.EventId.TeamOnAddPlayer then
                local TeamMember = ...
                if RegionSyncSubsys and TeamMember and TeamMember.Eid then
                    RegionSyncSubsys:SetOnlinePlayerTeamMember(CommonUtils.ObjId2Str(TeamMember.Eid),true)
                end
            elseif EventId == TeamCommon.EventId.TeamOnDelPlayer then
                local TeamMember = ...
                if RegionSyncSubsys and TeamMember and TeamMember.Eid then
                    RegionSyncSubsys:SetOnlinePlayerTeamMember(CommonUtils.ObjId2Str(TeamMember.Eid),true)
                end
            elseif EventId == TeamCommon.EventId.TeamOnInit or EventId == TeamCommon.EventId.TeamLeave then
                local bIsTeamMember = EventId == TeamCommon.EventId.TeamOnInit
                local Team = ...
                local TeamData = Team or TeamController:GetModel():GetTeam()
                if not TeamData or not TeamData.Members then return end
                for _, Member in pairs(TeamData.Members) do
                    if RegionSyncSubsys then
                        RegionSyncSubsys:SetOnlinePlayerTeamMember(CommonUtils.ObjId2Str(Member.Eid),bIsTeamMember)
                    end
                end
            end
        end)
    else
        TeamController:UnRegisterEvent(self)
    end
end

function BP_PlayerCharacter_C:OnChangeNickName(NewNickName)
    self:EnableHeadWidget("Name", false)
    self:EnableHeadWidget("Name", true, NewNickName)
end

function BP_PlayerCharacter_C:OnChangeTitle(PrefixId, SuffixId, TitleFrameId)
    self:RefreshTitle(PrefixId, SuffixId, TitleFrameId)
end

function BP_PlayerCharacter_C:EnableNameWidget()
    EventManager:AddEvent(EventID.OnChangeNickName,self,self.OnChangeNickName)
    EventManager:AddEvent(EventID.OnChangeTitle,self,self.OnChangeTitle)
    local bFirtInit = self.HeadWidgetComponent == nil
    self:InitHeadWidgetComponent()
    if bFirtInit then
        self:EnableHeadWidget("Name", false)
        self:EnableHeadWidget("Title", false)
    end
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        self:OnChangeNickName(Avatar.Nickname)
        self:OnChangeTitle(Avatar.TitleBefore,Avatar.TitleAfter,Avatar.TitleFrame)
    end
    -- if self.HeadWidgetComponent then
    --     local Widget = self.HeadWidgetComponent:GetWidget()
    --     -- if Widget then
    --     --     Widget:SetUIVisibilityTag("MainPlayerDisableNameWidget",false)
    --     -- end
    -- end
end

function BP_PlayerCharacter_C:DisableNameWidget()
    if not self.HeadWidgetComponent then
        return
    end
    EventManager:RemoveEvent(EventID.OnChangeNickName,self)
    EventManager:RemoveEvent(EventID.OnChangeTitle,self)
    self:EnableHeadWidget("Name", false)
    self:EnableHeadWidget("Title", false)
    -- if self.HeadWidgetComponent then
    --     -- local Widget = self.HeadWidgetComponent:GetWidget()
    --     -- if Widget then
    --     --     Widget:SetUIVisibilityTag("MainPlayerDisableNameWidget",true)
    --     -- end

    -- end
end

function BP_PlayerCharacter_C:SetVirtualJoystickEnableMoveLockFromCache()
    local CachedVirtualJoystickEnableMoveLock = EMCache:Get("VirtualJoystickMoveLock")
    if CachedVirtualJoystickEnableMoveLock == nil then
        local DefaultValue =  true
        local DefaultValueString = nil
        local OptionInfo = DataMgr.Option.MoveLock
        if CommonUtils.GetRuntimePlatform(self) == "Mobile" and OptionInfo and OptionInfo.DefaultValueM then
            DefaultValueString = OptionInfo.DefaultValueM
        else
            DefaultValueString = OptionInfo.DefaultValue
        end
        if DefaultValueString == "False" then
            DefaultValue = false
        elseif DefaultValueString == "True" then
            DefaultValue = true
        end
        EMCache:Set("VirtualJoystickMoveLock", DefaultValue)
        CachedVirtualJoystickEnableMoveLock = DefaultValue
    end
    UIManager(self):SetVirtualJoystickEnableMoveLock(CachedVirtualJoystickEnableMoveLock)
end

function BP_PlayerCharacter_C:UpdateVirtualJoystickEnableMoveLock(bEnable)
    EMCache:Set("VirtualJoystickMoveLock", bEnable)
    UIManager(self):SetVirtualJoystickEnableMoveLock(bEnable)
end

AssembleComponents(BP_PlayerCharacter_C, {"GetDamageInstigatorCurrentAngle"})
return BP_PlayerCharacter_C