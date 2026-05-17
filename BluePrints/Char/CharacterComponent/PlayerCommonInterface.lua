local EMCache = require "EMCache.EMCache"
local TaskUtils = require "BluePrints.UI.TaskPanel.TaskUtils"
local MiscUtils = require "Utils.MiscUtils"

local PlayerCommonInterface = {}

function PlayerCommonInterface:PlayerCharacterInitialize()
    -- self.bBlockMoveInput = false
    self.bWeaponByHand = false
    self.WeaponPos = Const.Shoulder
    self.bGotControllerPitchInput = false
    self.bGotControllerYawInput = false
    self.fNoControlRotationInputTime = 0.0
    --self.KeepWeaponOnHand = false
    self:InitActionLogicParamas()
    self.LookAtTag = self:AddOneSwitchTag(self.OnSetLookAtTag)
    -- 是否可交互触发
    self.bForbidInteractiveTrigger = false


    -- 视角灵敏度
    self:UpdateCameraSensitivityFromCache()
    self:SetPlayerCameraSensitivityByType("Normal")
    
end

function PlayerCommonInterface:PrintCameraSensitivity(self)
    DebugPrint("Tianyi@ Current Pitch Sensivity: " .. tostring(self.CameraPitchSensitivity) .. " Current Yaw Sensivity: " .. tostring(self.CameraYawSensitivity))   
    DebugPrint("Tianyi@ CameraPitchSensitivity_Normal: " .. tostring(self.CameraPitchSensitivity_Normal) .. " CameraYawSensitivity_Normal: " .. tostring(self.CameraYawSensitivity_Normal))
    DebugPrint("Tianyi@ CameraPitchSensitivity_Shoot: " .. tostring(self.CameraPitchSensitivity_Shoot) .. " CameraYawSensitivity_Shoot: " .. tostring(self.CameraYawSensitivity_Shoot))
    DebugPrint("Tianyi@ GamepadCameraPitchSensitivity_Normal: " .. tostring(self.GamepadCameraPitchSensitivity_Normal) .. " GamepadCameraYawSensitivity_Normal: " .. tostring(self.GamepadCameraYawSensitivity_Normal))
    DebugPrint("Tianyi@ GamepadCameraPitchSensitivity_Shoot: " .. tostring(self.GamepadCameraPitchSensitivity_Shoot) .. " GamepadCameraYawSensitivity_Shoot: " .. tostring(self.GamepadCameraYawSensitivity_Shoot))
    DebugPrint("Tianyi@ TurnSpeedPitch: " .. tostring(self.TurnSpeedPitch))
    DebugPrint("Tianyi@ TurnSpeedYaw: " .. tostring(self.TurnSpeedYaw))
end

function PlayerCommonInterface:SetPlayerCameraSensitivityByType(Type, bController)
    if Type == "Normal" then
        if UIUtils.IsGamepadInput() then
            self.CameraPitchSensitivity = self.GamepadCameraPitchSensitivity_Normal
            self.CameraYawSensitivity = self.GamepadCameraYawSensitivity_Normal
        else
            self.CameraPitchSensitivity = self.CameraPitchSensitivity_Normal
            self.CameraYawSensitivity = self.CameraYawSensitivity_Normal
        end
    elseif Type == "Shooting" then
        if UIUtils.IsGamepadInput() then
            self.CameraPitchSensitivity = self.GamepadCameraPitchSensitivity_Shoot
            self.CameraYawSensitivity = self.GamepadCameraYawSensitivity_Shoot
        else
            self.CameraPitchSensitivity = self.CameraPitchSensitivity_Shoot
            self.CameraYawSensitivity = self.CameraYawSensitivity_Shoot
        end
    end
    -- DebugPrint("Tianyi@ Current Pitch Sensivity: " .. tostring(self.CameraPitchSensitivity) .. " Current Yaw Sensivity: " .. tostring(self.CameraYawSensitivity))
end

function PlayerCommonInterface:SetPlayerCameraSensitivityCannon()
    self.CameraPitchSensitivity_Normal = self.CameraPitchSensitivity_Shoot
    self.CameraYawSensitivity_Normal = self.CameraYawSensitivity_Shoot
    self.GamepadCameraPitchSensitivity_Normal = self.GamepadCameraPitchSensitivity_Shoot
    self.GamepadCameraYawSensitivity_Normal = self.GamepadCameraYawSensitivity_Shoot
end

function PlayerCommonInterface:UpdateGamePadCameraSensitivityFromCache()
    local CachedCameraPitch = EMCache:Get("GamepadCameraPitch")
    if not CachedCameraPitch then
        local DefaultValue =  tonumber(DataMgr.Option["GamePadVerticalSensitivity"].DefaultValue or 1.0) / (DataMgr.Option["GamePadVerticalSensitivity"].ScrollMappingScale or 1.0)
        EMCache:Set("GamepadCameraPitch", DefaultValue)
        CachedCameraPitch = DefaultValue
    end
    self.GamepadCameraPitchSensitivity_Normal = CachedCameraPitch

    local CachedCameraPitchOnShoot = EMCache:Get("GamepadCameraPitchOnShoot")
    if not CachedCameraPitchOnShoot then
        local DefaultValue = tonumber(DataMgr.Option["GamePadVerticalSensitivityOnShooting"].DefaultValue or 1.0) / (DataMgr.Option["GamePadVerticalSensitivityOnShooting"].ScrollMappingScale or 1.0)
        EMCache:Set("GamepadCameraPitchOnShoot", DefaultValue)
        CachedCameraPitchOnShoot = DefaultValue
    end
    self.GamepadCameraPitchSensitivity_Shoot = CachedCameraPitchOnShoot

    local CachedCameraYaw = EMCache:Get("GamepadCameraYaw")
    if not CachedCameraYaw then
        local DefaultValue = tonumber(DataMgr.Option["GamePadHorizontalSensitivity"].DefaultValue or 1.0) / (DataMgr.Option["GamePadHorizontalSensitivity"].ScrollMappingScale or 1.0)
        EMCache:Set("GamepadCameraYaw", DefaultValue)
        CachedCameraYaw = DefaultValue
    end
    self.GamepadCameraYawSensitivity_Normal = CachedCameraYaw

    local CachedCameraYawOnShoot = EMCache:Get("GamepadCameraYawOnShoot")
    if not CachedCameraYawOnShoot then
        local DefaultValue = tonumber(DataMgr.Option["GamePadHorizontalSensitivityOnShooting"].DefaultValue or 1.0) / (DataMgr.Option["GamePadHorizontalSensitivityOnShooting"].ScrollMappingScale or 1.0)
        EMCache:Set("GamepadCameraYawOnShoot", DefaultValue)
        CachedCameraYawOnShoot = DefaultValue
    end
    self.GamepadCameraYawSensitivity_Shoot = CachedCameraYawOnShoot
end

function PlayerCommonInterface:UpdateKeyBoardCameraSensitivityFromCache()
    local CachedCameraPitch = EMCache:Get("CameraPitch")
    if not CachedCameraPitch then
        local DefaultValue =  tonumber(DataMgr.Option["VerticalSensitivity"].DefaultValue or 1.0) / (DataMgr.Option["VerticalSensitivity"].ScrollMappingScale or 1.0)
        EMCache:Set("CameraPitch", DefaultValue)
        CachedCameraPitch = DefaultValue
    end
    self.CameraPitchSensitivity_Normal = CachedCameraPitch

    local CachedCameraPitchOnShoot = EMCache:Get("CameraPitchOnShoot")
    if not CachedCameraPitchOnShoot then
        local DefaultValue = tonumber(DataMgr.Option["VerticalSensitivityOnShooting"].DefaultValue or 1.0) / (DataMgr.Option["VerticalSensitivityOnShooting"].ScrollMappingScale or 1.0)
        EMCache:Set("CameraPitchOnShoot", DefaultValue)
        CachedCameraPitchOnShoot = DefaultValue
    end
    self.CameraPitchSensitivity_Shoot = CachedCameraPitchOnShoot

    local CachedCameraYaw = EMCache:Get("CameraYaw")
    if not CachedCameraYaw then
        local DefaultValue = tonumber(DataMgr.Option["HorizontalSensitivity"].DefaultValue or 1.0) / (DataMgr.Option["HorizontalSensitivity"].ScrollMappingScale or 1.0)
        EMCache:Set("CameraYaw", DefaultValue)
        CachedCameraYaw = DefaultValue
    end
    self.CameraYawSensitivity_Normal = CachedCameraYaw

    local CachedCameraYawOnShoot = EMCache:Get("CameraYawOnShoot")
    if not CachedCameraYawOnShoot then
        local DefaultValue = tonumber(DataMgr.Option["HorizontalSensitivityOnShooting"].DefaultValue or 1.0) / (DataMgr.Option["HorizontalSensitivityOnShooting"].ScrollMappingScale or 1.0)
        EMCache:Set("CameraYawOnShoot", DefaultValue)
        CachedCameraYawOnShoot = DefaultValue
    end
    self.CameraYawSensitivity_Shoot = CachedCameraYawOnShoot
end

-- 读取缓存中配置的灵敏度
function PlayerCommonInterface:UpdateCameraSensitivityFromCache(Type, bController)
    self:UpdateGamePadCameraSensitivityFromCache() 
    self:UpdateKeyBoardCameraSensitivityFromCache()
end

function PlayerCommonInterface:BeforeBeginPlay()
    self.CheckAnimNotifyOnZeroFrame = false
    self.MaxSafeLocations = 10
end

function PlayerCommonInterface:AfterBeginPlay()
    self.WeaponPos = Const.Shoulder
    if self.PlayerAnimInstance then
        self.PlayerAnimInstance.WeaponPos = self.WeaponPos
    end
    self:SetupActionGroups()
    self:InitPostProcessSettings()
end

-- function PlayerCommonInterface:SetupActionGroups()
--     self:AddToActionGroups("Battle", "Attack")
--     self:AddToActionGroups("Battle", "Jump")
--     self:AddToActionGroups("Battle", "Slide")
--     self:AddToActionGroups("Battle", "BulletJump")
--     self:AddToActionGroups("Battle", "Skill1")
--     self:AddToActionGroups("Battle", "Skill2")
--     self:AddToActionGroups("Battle", "Skill3")
--     self:AddToActionGroups("Battle", "Fire")
--     self:AddToActionGroups("Battle", "Reload")
--     self:AddToActionGroups("Battle", "ChargeBullet")
--     self:AddToActionGroups("Battle", "Avoid")
--     self:AddToActionGroups("Battle", "SwitchCrouch")
--     self:AddToActionGroups("Battle", "Locomotion")
--     self:AddToActionGroups("Region", "SwitchMaster")

--     -- self:AddToActionGroups("Flying", "Slide")
--     self:AddToActionGroups("Flying", "BulletJump")
	
-- 	self:InitBattleWheelForbidGroup()
-- end

-- function PlayerCommonInterface:InitAttributeFromTable(InitFromAnimInst)
--     local ParamNameTable = {
--         "NormalWalkSpeed",
--         "CrouchWalkSpeed",
--     }
--     for i, v in pairs(ParamNameTable) do
--         self.PlayerSlideAtttirbute[v] = DataMgr.PlayerRotationRates[v].ParamentValue[1]
--         if InitFromAnimInst and self.PlayerAnimInstance.MovementAttr[v] ~= 0 and self.PlayerAnimInstance.MovementAttr[v] ~= nil then 
--             self.PlayerSlideAtttirbute[v] = self.PlayerAnimInstance.MovementAttr[v]
--         end
--     end
-- end

function PlayerCommonInterface:LoadFinished()
    print("LoadFinished")
end


function PlayerCommonInterface:LatenTick(DeltaSeconds)
    -- self:CheckWalkCancelMontage()
    -- self:ProcessJumpActionInTick(DeltaSeconds)
end
-- function PlayerCommonInterface:HandleInputCacheInTick()
-- end


function PlayerCommonInterface:ProcessItemsOnTouchTick()
    self:ProcessItemsOnTouch()
end
-- function PlayerCommonInterface:MergeDefaultMesh()
--     self:MergeDefault()
-- end


-- @zyh 输入相关移到C++
--function PlayerCommonInterface:AddCharacterPitchInput(Val)
--    local Controller = self:GetController()
--    self.bGotControllerPitchInput = (Controller ~= nil) and not Controller.bLockRotate and not Controller.bLockPitchRotate and (Val ~= 0.0)
--    if self.bGotControllerPitchInput then
--        self:AddControllerPitchInput(-Val * (self.CameraPitchSensitivity or 1.0))
--    end
--    if Const.PlayerBreakOpenAim and Val ~= 0 then
--        self.OpenAimShootingLocation = Const.ZeroVector
--    end
--
--    self.IsFixHelpAimSpeedRate = Val ~= 0
--    if Val ~= 0 and self.CameraRotationComponent then
--        self.CameraRotationComponent:AddPitchInput(Val)
--    end
--end

function PlayerCommonInterface:ReturnIdle(FromNoAsset)
    self:SetCharacterTagIdle()
    self.KeepWeaponOnHand = false
    self:ServerSetCharacterTag("Idle")
end

--function PlayerCommonInterface:AddCharacterYawInput(Val)
--    local Controller = self:GetController()
--    self.bGotControllerYawInput = (Controller ~= nil) and not Controller.bLockRotate and (Val ~= 0.0)
--    if self.bGotControllerYawInput then
--        -- print(_G.LogTag, "AddCharacterYawInput", Val, self.CameraYawSensitivity)
--        self:AddControllerYawInput(Val * (self.CameraYawSensitivity or 1.0))
--    end
--    if Const.PlayerBreakOpenAim and Val ~= 0 then
--        self.OpenAimShootingLocation = Const.ZeroVector
--    end
--    self.IsFixHelpAimSpeedRate = Val ~= 0
--    if Val ~= 0 and self.CameraRotationComponent then
--        self.CameraRotationComponent:AddYawInput(Val)
--    end
--end

function PlayerCommonInterface:SetLogMask(MaskName)
    print('LogInfo', MaskName)
    _G.LogTag = MaskName
end


-- function PlayerCommonInterface:MoveForward(Val)
--     local v = math.max(math.min(Val, 1.0), -1.0)
--     self.MoveInputCache:Set(v, self.MoveInputCache.Y, self.MoveInputCache.Z)
--     if self:EndingInteractive() then 
--         return 
--     end
--     if self.ForbidInput then
--         return
--     end
-- 	self.MoveInput = FVector(v, self.MoveInput.Y, self.MoveInput.Z)
--     -- self.MoveInputCache:Set(0, self.MoveInputCache.Y, self.MoveInputCache.Z)
-- end

-- function PlayerCommonInterface:MoveRight(Val)
--     local v = math.max(math.min(Val, 1.0), -1.0)
--     self.MoveInputCache:Set(self.MoveInputCache.X, v, self.MoveInputCache.Z)
--     if self:EndingInteractive() then 
--         return 
--     end
--     if self.ForbidInput then
--         return
--     end
-- 	self.MoveInput:Set(self.MoveInput.X, v, self.MoveInput.Z)
--     -- self.MoveInputCache:Set(self.MoveInputCache.X, 0, self.MoveInputCache.Z)
-- end

-- function  PlayerCommonInterface:EndingInteractive()
--     if self.bShouldStopInteractive then
--         if self.bShouldBroadcastEndInteractive then
--             self.OnInteractiveDelegate:Broadcast(self)
--         end
--         self.bShouldStopInteractive = false
--         self.bShouldBroadcastEndInteractive = false
--         return true
--     end
--     return false
-- end

function PlayerCommonInterface:SetEmoIdleEnabled(IsEnable, IsChangeRefreshNow)
    if(self.PlayerAnimInstance) then
        self.PlayerAnimInstance:SetEmoIdleEnabled(IsEnable, IsChangeRefreshNow)
    end
end

-- function PlayerCommonInterface:SetArmoryTag(EnterArmory)

-- end

function PlayerCommonInterface:KawaiiSwitch(Enabled)
    if self.PlayerAnimInstance then 
        self.PlayerAnimInstance:EnableKawaiiSettings(Enabled)
        
    end

end


function PlayerCommonInterface:StopArmoryIdle()
    self:ShouldEnableHandIk()
    self.PlayerAnimInstance:Montage_StopSlotByName(0, "ArmoryIdle");
end

function PlayerCommonInterface:SetArmoryIdleTag(bHideUntilLoop)
    if not self.PlayerAnimInstance then 
        return 
    end
    self:ShouldEnableHandIk()
    self.PlayerAnimInstance:SetArmoryIdleTag(bHideUntilLoop)

end



-- function PlayerCommonInterface:OnMontageEned_Idle(MontageAsset, bInterrupt)
--     if not self.PlayerAnimInstance then 
--         return 
--     end
--     self.PlayerAnimInstance.OnMontageBlendingOut:Remove(self, self.OnMontageEned_Idle)
--     if bInterrupt then 
--         return 
--     end
--     local MontageFolder = DataMgr.Model[self.ModelId].MontageFolder
--     local MontagePrefix = DataMgr.Model[self.ModelId].MontagePrefix
--     local MontagePath = MontageFolder .. 'Armory/'..MontagePrefix.. self.PlayerAnimInstance.IdleTag .. '_Idle_Montage'
--     self:PlayMontageByPath(MontagePath)
--     print(_G.LogTag, "OnMontageEned_Idle", MontageAsset, bInterrupt)

-- end

-- function PlayerCommonInterface:StartJump()
--     self:PlayerDoJump()
-- end

function PlayerCommonInterface:CancelSkill(JumpStage, bStillHoldFire)
end

function PlayerCommonInterface:CalcVectorAngle(Vector1, Vector2)
    Vector1:Normalize()
    Vector2:Normalize()
    local DotResult = Vector1:Dot(Vector2)
    local CosToAngle = UE4.UKismetMathLibrary.DegAcos(DotResult)
    return CosToAngle
end

-- function PlayerCommonInterface:StopJump()
--     -- if self:CheckForbidInput() then
--     --     print('22222222222zjy')
--     --     return
--     -- end
--     self:PlayerStopJump()
-- end

function PlayerCommonInterface:IsLocalPlayer()
    if URuntimeCommonFunctionLibrary.ObjIsChildOf(self:GetController(), APlayerController)
        and (IsStandAlone(self) or MiscUtils.IsAutonomousProxy(self)) then
        return true
    end
    return false
end

function PlayerCommonInterface:UpdatePlayerTaskInfo()
    -- 初始化角色任务信息
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    local SceneComponentMgr = GameInstance:GetSceneManager()
    if (SceneComponentMgr == nil or UIManager == nil) then
        return
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local TaskBarWidget = nil
    local BattleMainUI = UIManager:GetUIObj("BattleMain")
    if BattleMainUI ~= nil and BattleMainUI.Pos_TaskBar ~= nil and BattleMainUI.Pos_TaskBar:GetChildrenCount() == 0 then
        TaskBarWidget = BattleMainUI:CreateWidgetNew("TaskBar")
        if TaskBarWidget ~= nil then
            BattleMainUI.Pos_TaskBar:AddChildToOverlay(TaskBarWidget)
        end
        local QuestChain = Avatar.QuestChains[Avatar.TrackingQuestChainId]
        if not QuestChain or (QuestChain and QuestChain:IsFinish()) then
            BattleMainUI.Pos_TaskBar:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end  
    elseif  BattleMainUI ~= nil and BattleMainUI.Pos_TaskBar ~= nil then
        TaskBarWidget = BattleMainUI.Pos_TaskBar:GetChildAt(0)
    end
    local UnlockMainStoryChain = TaskUtils:GetUnlockMainStory()
    if UnlockMainStoryChain then
        if TaskBarWidget then
            TaskBarWidget:UpdateUnlockMainStory(UnlockMainStoryChain)
        end
        
    else
        if TaskBarWidget then
            TaskBarWidget.Panel_Lock:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end 
    end

    local IconTexture = TaskUtils:GetIconTextureByTrackQuestChainType()
    if IconTexture then
        if TaskBarWidget then
            TaskBarWidget.Icon_GuidePoint:SetBrushResourceObject(IconTexture)
        end    
    end
end

function PlayerCommonInterface:InitSceneStartUI()
end

function PlayerCommonInterface:UpdatePlayerBloodEffectInfo()
end

function PlayerCommonInterface:Landed()
    if not self:PlayerLanded()then 
        return 
    end
    self.Super.Landed(self)
    if self:CharacterInTag("LandHeavy") then 
        return  
    end
end


function PlayerCommonInterface:Impending()
    if not self:PlayerImpending() then 
        return 
    end
    -- self.Super.Impending(self)
end


function PlayerCommonInterface:StartSlide()
end

-- function PlayerCommonInterface:StopSlide()
-- end

function PlayerCommonInterface:EnterHitFlyTag()
    if self.PlayerAnimInstance then
        self:SetCurrentJumpState(Const.NormalState)
        self:SetRotationRate("OnGround")
    end
end

function PlayerCommonInterface:GetDamageInstigatorCurrentAngle(Attacker)
end

function PlayerCommonInterface:TryToUpdateScreenEffect(DamageFrom, EnergyShieldReduce)
  
end

function PlayerCommonInterface:SkillEnd(Owner, SkillId)
end

-- function PlayerCommonInterface:SetRotationRate(StateName)
--     if self:CharacterInTag("Shooting") and self.RotState == "Shooting" then 
--         return 
--     end
--     if self:IsFlying() then 
--         StateName = "Flying"
--     end
--     local r = DataMgr.PlayerRotationRates[StateName]
--     if r then
--         local Movement = self:GetMovementComponent()
--         Movement.RotationRate = FRotator(r.ParamentValue[1],r.ParamentValue[2],r.ParamentValue[3])
--         self.RotState = StateName

--     end
-- end

function PlayerCommonInterface:PressFire()
end

-- function PlayerCommonInterface:StartFire()

-- end

function PlayerCommonInterface:ResetJumpState(KeepJumpCount)
    self:SetCurrentJumpState(Const.NormalState)
    if not KeepJumpCount then
        self.JumpCount = 0
        self.BulletJumpCount = 0
    end
    self.AutoSyncProp.IsBulletJumping = false
    self.StartBulletJumpTime = -1
    self.ForbidSlide = false
    local Movement = self:GetMovementComponent()
    -- Movement.bOrientRotationToMovement = true
    self.ForbidOrient = false
    self:ChangeOrientControll()
    self:ResetCapRot()
end

function PlayerCommonInterface:ResetJumpState_Lua()
    if self.LuaTimerHandles["BulletJump"] then
        self:RemoveTimer(self.LuaTimerHandles["BulletJump"])
        self.LuaTimerHandles["BulletJump"] = nil
    end
    if self.BulletJumpDirectionInfo then
        self.BulletJumpDirectionInfo = nil
        -- self.bBulletJumpControlGravity = false
    end
    self.AutoSyncProp.IsBulletJumping = false
end

-- function PlayerCommonInterface:CheckCanShoot()
-- end

-- function PlayerCommonInterface:UpdateShootingUIByMode(ShowMode, IsForce)
-- end


function PlayerCommonInterface:ReleaseFire()
end

function PlayerCommonInterface:StopFire(bStillHoldFire)
end

-- function PlayerCommonInterface:EnterIdleTag()
--     -- self.Super.EnterIdleTag(self)
--     self:SetRotationRate("OnGround")
--     -- self:GetMovementComponent().bOrientRotationToMovement = true
--     self:ChangeOrientControll()
--     if not self:IsAnimCrouch() then 
--         -- self:ResetCapSize()
--     end
-- end

function PlayerCommonInterface:EnterWalkingTag()
    self:SetRotationRate("OnGround")
    if not self:IsAnimCrouch() then 
        -- self:ResetCapSize()
    end
end


function PlayerCommonInterface:CheckKeepBoneHit()
end

function PlayerCommonInterface:ApplyEffectBoneHit(DamageCauser, EffectParamentTable)
end

function PlayerCommonInterface:EndBoneHit()
    self.PlayerAnimInstance.InBoneHit = false
end

function PlayerCommonInterface:ChangeToNewWeapon(WeaponId)
    local WeaponData = DataMgr.BattleWeapon[WeaponId]
    if not WeaponData then
        ScreenPrint("请输入正确的武器编号:" .. tostring(WeaponId))
        return
    end

    local Avatar = GWorld:GetAvatar()
    if Avatar then
        ScreenPrint("连接服务器情况下，请在军械库更换武器")
        return
    end

    if not IsAuthority(self) then
        ScreenPrint('多人联机模式不能换武器')
        return
    end

    local function HasTag(WeaponData, Tag)
        local WeaponTag = WeaponData.WeaponTag
        if not WeaponTag then
            return false
        end

        for _, _Tag in pairs(WeaponTag) do
            if Tag == _Tag then
                return true
            end
        end
        return false
    end

    if HasTag(WeaponData, "Ultra") then
        ScreenPrint('无法更换显赫武器')
        return
    end

    if HasTag(WeaponData, "Condemn") then
        ScreenPrint('无法更换处刑武器')
        return
    end

    local IsMelee = HasTag(WeaponData, "Melee")
    local NewWeapons = {}
    table.insert(NewWeapons, {WeaponId = WeaponId, Weight = 1.5})
    for _WeaponId, _Weapon in pairs(self.Weapons) do
        -- 不是子武器
        if not _Weapon.IsChild then
            if _Weapon:HasTag('Ultra') or _Weapon:HasTag('Condemn') then
                table.insert(NewWeapons, {WeaponId = _WeaponId, Weight = 3})
            elseif IsMelee then
                if not _Weapon:HasTag('Melee') then
                    -- 远程武器
                    table.insert(NewWeapons, {WeaponId = _WeaponId, Weight = 2})
                end
            else
                if not _Weapon:HasTag('Ranged') then
                    -- 近战武器
                    table.insert(NewWeapons, {WeaponId = _WeaponId, Weight = 1})
                end
            end
        end
    end
    table.sort(NewWeapons,  function(a, b)
        return a.Weight < b.Weight
    end)
    local CurSkill = self:GetCurrentSkill()
    if CurSkill then
        self:StopSkill(UE.ESkillStopReason.ForceCancel)
    end
    self:ClearWeapon()
    -- PrintTable({NewWeapons=NewWeapons},10)
    for _, WeaponInfo in pairs(NewWeapons) do
        local Weapon = self:AddWeapon(WeaponInfo.WeaponId)
        Weapon:UnBindWeaponFromHand()
        Weapon:ShouldHideWeapon(true, true)
        Weapon:UnBindWeaponFromHand()
    end
    self:ChangeUsingWeaponByType("Melee")
end
function PlayerCommonInterface:AnimIdleStart()  

end

function PlayerCommonInterface:StartJump()
    self:PlayerDoJump()
    if (self.NeedJumpEvent) then
        EventManager:FireEvent(EventID.OnJumpPressed)
    end
end

function PlayerCommonInterface:SetDebugDrawTest(Debugable)
    _G.DrawDebugTest = Debugable
end


function PlayerCommonInterface:SetCanInteractiveTrigger(bIsCanTrigger, Tag)
    local Tag = Tag or "Default"

    self.DisableInteractiveTriggerTagMap = self.DisableInteractiveTriggerTagMap or {}
    if (bIsCanTrigger) then
        self.DisableInteractiveTriggerTagMap[Tag] = nil
    else
        self.DisableInteractiveTriggerTagMap[Tag] = true
    end

    local bForbidInteractiveTrigger = next(self.DisableInteractiveTriggerTagMap) ~= nil
    if (self.bForbidInteractiveTrigger == bForbidInteractiveTrigger) then
        return
    end

    self.bForbidInteractiveTrigger = bForbidInteractiveTrigger
    if(self.InteractiveTriggerComponent)then
        self.InteractiveTriggerComponent:SetIsCanTrigger(not bForbidInteractiveTrigger)
    end
end

function PlayerCommonInterface:CheckCanInteractiveTrigger()
    return not self.bForbidInteractiveTrigger
end

function PlayerCommonInterface:RefreshRegionNameInfo(UId, ObjId)
    local Name = ""
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local RegionAvatars = Avatar.RegionAvatars or {}
        local OtherAvatar = RegionAvatars[ObjId]
        Name = OtherAvatar and OtherAvatar.AvatarInfo.Nickname
    end
    local Member, Pos = TeamController:GetModel():GetTeamMember(UId)
    self:EnableHeadWidget("Name", false)
    local Style = "Player"
    if Pos == 0 or not Pos then
        Style = nil
    end
    self:EnableHeadWidget("Name", true, Name, Style, Pos)
end
function PlayerCommonInterface:RefreshTitleInfo(ObjId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    -- if Avatar then
    local RegionAvatars = Avatar.RegionAvatars or {}
    local OtherAvatar = RegionAvatars[ObjId]
    if not OtherAvatar or not OtherAvatar.AvatarInfo then
        return 
    end
    local PrefixId = OtherAvatar.AvatarInfo.TitleBefore
    local SuffixId = OtherAvatar.AvatarInfo.TitleAfter
    local TitleFrameId = OtherAvatar.AvatarInfo.TitleFrame
    print(_G.LogTag, "RefreshTitleInfo", PrefixId, SuffixId, TitleFrameId)
    self:RefreshTitle(PrefixId, SuffixId, TitleFrameId)
    -- end
end
function PlayerCommonInterface:EnableTitle(PrefixId, SuffixId, TitleFrameId)
    self:EnableHeadWidget("Title", true, PrefixId, SuffixId, TitleFrameId)
end

function PlayerCommonInterface:DisableTitle()
    self:EnableHeadWidget("Title", false)
end

function PlayerCommonInterface:RefreshTitle(PrefixId, SuffixId, TitleFrameId)
    self:DisableTitle()
    self:EnableTitle(PrefixId, SuffixId, TitleFrameId)
end

function PlayerCommonInterface:PlayEmoji(EmojiPath)
    self:EnableHeadWidget("Bubble_Emoji", true, EmojiPath)
end

function PlayerCommonInterface:StopEmoji()
    self:EnableHeadWidget("Bubble_Emoji", false)
end

function PlayerCommonInterface:InitBattleWheelForbidGroup()
	local ActionAllow = {
		["W"] = true,
		["A"] = true,
		["S"] = true,
		["D"] = true,
		["OpenBattleWheel"] = true,
        ["Fire"] = true,
	}

	-- 遍历KeyboardMap
	local KeyboardMap = DataMgr.KeyboardMap
	for ActionName, _ in pairs(KeyboardMap) do
		if not ActionAllow[ActionName] then
			self:AddToActionGroups("BattleWheelForbid", ActionName)
		end
	end
end

function PlayerCommonInterface:DisablePlayerInputInDeliver(bDisable)
    UIManager(self):SetBannedActionCallback("InDeliver", bDisable)
end

return PlayerCommonInterface