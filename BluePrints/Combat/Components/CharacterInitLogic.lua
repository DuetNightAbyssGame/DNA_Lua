
local EffectResults = require "BluePrints.Combat.BattleLogic.EffectResults"
local MiscUtils = require "Utils.MiscUtils"

---@type BP_CharacterBase_C
local Component = {}

-- 只注册初始化数据，尝试初始化
function Component:RegisterInfo(Info)
    if Info then
        self.InfoForInit = Info
    end

    self:TryInitCharacterInfo("InitInfo")
end

function Component:OnRep_ServerBornInfo()
    self.BornInfo = EffectResults.UnpackEffectStruct(self.ServerBornInfo)
    -- PrintTable({BornInfo=self.BornInfo,OnRep_BornInfo=1},10)
end

-- Todo: delete it, chenxiaokang
function Component:OnRep_ServerInitSuccessOld()
    -- 怪物死亡的时候会修改这个值
    if self.ServerInitSuccess==true then
        print(_G.LogTag, "OnRep_ServerInitSuccess")
        self.InfoForInit = self:GetInfoForInit()
        if self.IsFromCache then
            self.InfoForInit.InitType = "FromCache"
        end
        self:SetActorHideTag("login", true)
        self:TryInitCharacterInfo("InitInfo")
    end
end

function Component:GetInfoForInit()
    return {
        RoleId = self.CurrentRoleId,
        UnitId = self.UnitId,
        ShadowModelId = self.ShadowModelId,
    }
end

function Component:BeginInitInfo()
    print(_G.LogTag, "BeginInitInfo")
    if self.InitSuccess then
        Battle(self):ShowBattleError("CharacterInitLogic InitSuccess is true, do not init again", self.InitSuccess)
        return
    end
    self:InitCharacterInfo() 
end

function Component:InitCharacterInfoForRegionPlayer(Info)
    Info = Info or self.InfoForInit

    if not Info then
        print(_G.LogTag, "InitInfo is nil")
        return
    end
    self.CacheInfo = Info
    if(Info.AppearanceSuit) then 
        self.CurrentSkinId = Info.AppearanceSuit.SkinId
    else 
        self.CurrentSkinId = Info.SkinId
    end
    self.ShadowModelId = Info.ShadowModelId or 0
    self:PreInitInfo(Info)
    local PreloadComp = self:GetCharPreloadComp()
    if(PreloadComp) then 
        local Ids = self:ColletctPartMeshIds(Info.AppearanceSuit)
        PreloadComp:PreloadAssetsForRegionPlayer(Ids, {self, self.RegionPlayerPendingInit})
    else
        self:RegionPlayerPendingInit()
    end
end

function Component:RegionPlayerInitInfo(ObjId,EidOverride)
    local RegionSyncSubsys = UE4.URegionSyncSubsystem.GetInstance(self)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    if not RegionSyncSubsys then
        print(_G.LogTag, "RegionPlayerInitInfo RegionSyncSubsys is nil")
        return
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        print(_G.LogTag, "RegionPlayerInitInfo Avatar is nil")
        return
    end
    if not Avatar.OtherRoleInfo then
        print(_G.LogTag, "RegionPlayerInitInfo Avatar.TempRoleInfo is nil")
        return
    end
    if not CommonUtils.IsObjIdStr(ObjId) then
        print(_G.LogTag, "RegionPlayerInitInfo ObjId is  not a Legal ObjIdStr")
        return
    end
    local LuaObjId = CommonUtils.Str2ObjId(ObjId)
    local RoleInfo = Avatar.OtherRoleInfo[LuaObjId]
    if not RoleInfo then
        print(_G.LogTag, "RegionPlayerInitInfo RoleInfo is nil")
        return
    end
    if EidOverride and EidOverride > 0 then
        RoleInfo.Eid = EidOverride
    end
    self.CacheInfo = RoleInfo
    if(RoleInfo.AppearanceSuit) then 
        self.CurrentSkinId = RoleInfo.AppearanceSuit.SkinId
    else 
        self.CurrentSkinId = RoleInfo.SkinId
    end
    self.ShadowModelId = RoleInfo.ShadowModelId or 0
    self:PreInitInfo(RoleInfo)
    --Should  Already Preload In Other Process
    self:RegionPlayerPendingInit()
    self:AddInteractiveComponent()
    RoleInfo.CharEid = self.Eid
    if(self.RegionInterComp) then
        self.RegionInterComp:InitRegionInfo(self.Eid, LuaObjId)
    end
    if(self.RegionInterAddFriendComp) then
        self.RegionInterAddFriendComp:InitRegionInfo(self.Eid, LuaObjId)
    end
    if(self.RegionInterInviteTeamComp) then
        self.RegionInterInviteTeamComp:InitRegionInfo(self.Eid, LuaObjId)
    end
    if(self.RegionInterPersonInfoComp) then
        self.RegionInterPersonInfoComp:InitRegionInfo(self.Eid, LuaObjId)
    end
    EventManager:FireEvent(EventID.OnlineAddOtherPlayer, self.Eid, RoleInfo.Uid, self, LuaObjId)
    EventManager:FireEvent(EventID.AddRegionIndicatorInfo, self.Eid, RoleInfo.Uid, self:K2_GetActorLocation(), LuaObjId)
    self:RegisterOtherWorldPlayerCharacterToSubSystem(ObjId)
    print(_G.LogTag, "RegionPlayerInitInfo Spawn Other Player Character Success Init",RoleInfo.IsCrouching)
    if(RoleInfo.MountDatas and RoleInfo.MountDatas.MountId ~= 0) then 
        RoleInfo.IsCrouching = false
        self:EnableBattleMount(RoleInfo.MountDatas.MountId, 0, true)
    end
    if(RoleInfo.IsCrouching) then
        self:SetCrouch(true)
    else
        self:SetCrouch(false)
    end

end


function Component:ColletctPartMeshIds(AppearanceSuitInfo)
    if(not self.CharacterFashion) then 
        return {}
    end
    local PartMeshIds = {}
    self.CharacterFashion:ColletctPartMeshIds(AppearanceSuitInfo, PartMeshIds)
    return PartMeshIds
end



function Component:RegionPlayerPendingInit()
    print(_G.LogTag, "RegionPlayerPendingInit")
    if(not self.CacheInfo) then 
        return
    end
    local Info = self.CacheInfo
    if not self.InitSuccess then
        self:RealInitInfo(Info)
    end
end


-----------------------初始化流程开始-----------------------
-- 真正初始化角色，一般不直接调用，通过TryInitCharacterInfo走流程控制进这里以保证初始化过程中需要的前置条件都满足
function Component:InitCharacterInfo(Info)
    Info = Info or self.InfoForInit
    if not Info then
        print(_G.LogTag, "InitInfo is nil")
        return
    end
    self.CacheInfo = Info
    self:PreInitInfo(Info)
    if not self.InitSuccess and IsEmptyTable(self.WaitInitTags) then
        self:RealInitInfo(Info)
    end
    if self.FromArmory then 
        self.Mesh.bComponentUseFixedSkelBounds = false
        self.Mesh.bHasValidBodies = true
    end
end

function Component:AuthorityPreInitInfo(Info)
    if self.Eid == 0 then 
        if Info.Eid ~= nil then
            self:SetEid(Info.Eid)
        else
            local GameMode = UE4.UGameplayStatics.GetGameMode(self)
            if GameMode then
                self:SetEid(GameMode:GetBattleEid())
            end
        end
    end
    self:SetDirectSource(Info.DirectSource and Info.DirectSource.Eid)

    self:RawRemoveAllBuff(true)
    self:DestroyActorOnDead_CPP(false, EDeathReason.NoReason, true)
    self:ClearSkill()
    self:ClearAttrs()
    self:ServerResourceDisableBattleMount(true)
end

function Component:ClientPreInitInfo(Info)
    self:DestroyAllCreatures(ECreatureDeathWithCreator.Destroy, EDeathReason.CreatureRawDestroy)
end

-- 给魅影用的
function Component:UnpackAvatarInfoNew(Context)
    local AvatarInfo = Context:GetLuaTable("AvatarInfo")
    if not AvatarInfo then
        return
    end
    self.AvatarInfo = AvatarInfo
    local RoleInfo = AvatarInfo.RoleInfo
    if RoleInfo then
        for Key, Value in pairs(RoleInfo) do
            if type(Value) == 'number' then
                if not Context.IntParams:Find(Key) then
                    Context.IntParams:Add(Key, Value)
                end
            elseif type(Value) == 'boolean' then
                if not Context.BoolParams:Find(Key) then
                    Context.BoolParams:Add(Key, Value)
                end
            elseif type(Value) == 'table' then
                if not Context:GetLuaTable(Key) then
                    Context:AddLuaTable(Key, Value)
                end
            end
        end
    end

    if not Context:GetLuaTable("MeleeWeapon") then
        Context:AddLuaTable("MeleeWeapon", AvatarInfo.MeleeWeapon)
    end

    if not Context:GetLuaTable("RangedWeapon") then
        Context:AddLuaTable("RangedWeapon", AvatarInfo.RangedWeapon)
    end

    if not Context:GetLuaTable("UltraWeapons") then
        Context:AddLuaTable("UltraWeapons", AvatarInfo.UltraWeapons)
    end
end

function Component:UnpackAvatarInfo(Info)
    if Info.UseMasterRole then 
        return 
    end

    local AvatarInfo = Info.AvatarInfo
    if AvatarInfo then
        for Key, Value in pairs(AvatarInfo) do
            if not Info[Key] then
                Info[Key] = Value
            end
        end
    end
    Info.AvatarInfo = nil

    local RoleInfo = Info.RoleInfo
    if RoleInfo then
        for Key, Value in pairs(RoleInfo) do
            if not Info[Key] then
                Info[Key] = Value
            end
        end
    end
    Info.RoleInfo = nil
    -- PrintTable({Info=Info},10, "UnpackAvatarInfo")
end

-- 预处理数据
function Component:PreInitInfo(Info)
    self:UnpackAvatarInfo(Info)
    
    self.FromOtherWorld = Info.FromOtherWorld or false
    self.FromArmory = Info.FromArmory or false
    self.IsSettlementOtherRole = Info.IsSettlementOtherRole or false

    self.InfoForInit = Info
    if Info.ChangeRole then
        self:ResetIdle()
    end

    self:SetActorHideTag("login", true)

    if not self.BornInfo then
        self.BornInfo = EffectResults.Result()
    end
    
    if IsAuthority(self) then
        -- 只在服务器执行的逻辑
        self:AuthorityPreInitInfo(Info)
    else
        self:ClientPreInitInfo(Info)
    end
    
    self.InitSuccess = false
    self.UnitId = Info.UnitId
    self.PreRoleId = self.CurrentRoleId
    self:SetCurrentRoleId(Info.RoleId)
    self:SetExtraModelIds()
    self:PreloadSummonMonster(self.PreRoleId)
    self.BattleCharInfo = self:GetDataInfo(self.CurrentRoleId)

    -- if self:IsPlayer() or self:IsPhantom() then
    --     Battle(self):QuickRecovery(self.Eid)
    -- end

    -- 这个函数根据Info里的数据，重建Info

    -- 在RealInit前需要做的
    self.WaitInitTags = {}
    -- self.WaitShowModelTags = {}
    self.CacheInfo = Info
    self.bCharacterActive = true
    self.PlayDieEffect = false
    self.PlayBodyAccessoryEffect = false
end

-- 预加载资源
function Component:PreInitAssets(Info)
    -- if not self:GetWaitInitTag(Const.CharWaitInitTag.AssetsLoading) then
    --     return
    -- end

    -- self:PreloadAssetsLoadConfig()
    -- self:PreloadAssets(Info)
end

function Component:PrepareWaitInitTags()
    if not self.IsSimplePlayer and self:NeedPreloadAssets() then
        self:SetWaitInitTag(true, Const.CharWaitInitTag.AssetsLoading)
    end
    if not IsEmptyTable(self.WaitInitTags) then
        self:SetCharacterActive(false, "Init")
    end
end

-- 是否需要预加载
function Component:NeedPreloadAssets()
    if self.GetCharPreloadComp and self:GetCharPreloadComp() then
        return self:GetCharPreloadComp():NeedPreloadAssets()
    end
    return false
end

-- 是否需要资源缓存
function Component:NeedCacheLoadAssets()
    local IsPIE = UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(self)
    if IsPIE or IsDedicatedServer(self) then
        return false
    end
    
    local Res = false
    if self.GetCharPreloadComp and self:GetCharPreloadComp() then
        Res = self:GetCharPreloadComp():NeedCacheLoadAssets()
    end
    if Res then
        -- Loading中缓存的玩家资源放到Loading的末尾一起处理
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        print(_G.LogTag, "---NeedCacheLoadAssets---", GameState.bPreloadAssetsReady, self.DelayCacheLoadPlayerAssets)
        if not GameState.bPreloadAssetsReady then
            self.DelayCacheLoadPlayerAssets = true
            Res = false
        end
    end
    return Res
end

-- 真正初始化角色的函数
function Component:RealInitInfo(Info)
    if IsAuthority(self) and not self.FromOtherWorld then
        self:AuthorityInitInfo(Info)
        self:SnapShotInitInfo(Info)
    end

    self:CommonInitInfo(Info)
    if IsStandAlone(self) or not IsAuthority(self) then
        self:ClientInitInfo(Info)
    end

    self.ServerInitSuccess = true
    self.InitSuccess = true

    self:PostInitInfo(Info)

    if Info.PreReadyCallback then
        Info.PreReadyCallback(self)
    end

    self:OnCharacterReady(Info)
    self:SetIsCharacterReady(true)

    if Info.LoadFinishCallback then
        Info.LoadFinishCallback(self)
    end
    -- 缓存常用资源
    if self:NeedCacheLoadAssets() then
        self:GetCharPreloadComp():CacheLoadAssets()
    end
    
    self:OnCharacterInitOver()

    -- 处理特性特定武器开启怪物物理
    if not self:IsMainPlayer() then
        return
    end
    
    self.ShouldTickVisible = true
    if self.RangedWeapon == nil then
        return
    end

    local RangedWeaponId = self.RangedWeapon.WeaponId
    local WeaponData = DataMgr.BattleWeapon[RangedWeaponId]
    if WeaponData and WeaponData.IsForceEnablePhysics then
        if UE4.UCharacterFunctionLibrary.SetMonsterPhysicsForceEnable(self:GetWorld(), true) then
            DebugPrint("@gulinan RealInitInfo Enable physics, WeaponId: ", RangedWeaponId)
        end
    else
        if UE4.UCharacterFunctionLibrary.SetMonsterPhysicsForceEnable(self:GetWorld(), false) then
            DebugPrint("@gulinan RealInitInfo Disable physics, WeaponId: ", RangedWeaponId)
        end
    end
end

function Component:PostInitInfo(Info)
    if not self.bCharacterActive then
        self:SetCharacterActive(true, "Init")
    end

    if self:IsMonster() then
        self:DelayAdjustIfPossibleButAlwaysSpawn()
    end

    self.CacheInfo = nil
    if self:IsMainPlayer() then
        self:ClearInputCache()
    end
end

function Component:SetCharacterActive(bActive, Tag)
    self.bCharacterActive = bActive
    if not self.bCharacterActive then
        self:SetActorHideTag(Tag, true)
        self:AddGravityModifier(UE4.EGravityModifierTag.CharInit, 0)
        self:GetMovementComponent().Velocity = FVector(0,0,0)
        self.DefaultCapsuleCollisionType = self.CapsuleComponent:GetCollisionEnabled()
        self.CapsuleComponent:SetCollisionEnabled(ECollisionEnabled.NoCollision)
        if self.MonsterHitedCapsule then
            self.DefaultHitCapsuleCollisionType = self.MonsterHitedCapsule:GetCollisionEnabled()
            self.MonsterHitedCapsule:SetCollisionEnabled(ECollisionEnabled.NoCollision)
        else
            self.DefaultHitCapsuleCollisionType = ECollisionEnabled.NoCollision
        end
    else
        self:SetActorHideTag(Tag, false)
        self.CapsuleComponent:SetCollisionEnabled(self.DefaultCapsuleCollisionType)
        if self.MonsterHitedCapsule then
            self.MonsterHitedCapsule:SetCollisionEnabled(self.DefaultHitCapsuleCollisionType)
        end
        self:RemoveGravityModifier(UE4.EGravityModifierTag.CharInit)
    end
    -- DebugPrint("HYY CharacterInitLogic", self.Eid, bActive, self.CapsuleComponent:GetCollisionEnabled(), self.MonsterHitedCapsule and self.MonsterHitedCapsule:GetCollisionEnabled() or "nil", self.DefaultCapsuleCollisionType, self.DefaultHitCapsuleCollisionType)
end

function Component:SetWaitInitTag(bWait, Tag)
    self.WaitInitTags[Tag] = bWait or nil
    if IsEmptyTable(self.WaitInitTags) then
        self:RealInitInfo(self.CacheInfo)
    end
end

-- function Component:SetWaitShowModelTag(bWait, Tag)
--     self.WaitShowModelTags[Tag] = bWait or nil
--     if IsEmptyTable(self.WaitShowModelTags) then
--         self:RealShowModel()
--     end
-- end

-- function Component:RealShowModel()
-- end

function Component:GetWaitInitTag(Tag)
    return (not IsEmptyTable(self.WaitInitTags)) and self.WaitInitTags[Tag]
end

function Component:CommonInitInfo(Info)
    -- 公用逻辑
    -- PrintTable({FromOtherWorld=self.FromOtherWorld})
    Battle(self):AddEntity(self.Eid, self)

    self:InitCharacterTag()

    if Info.FromOtherWorld then
        -- 军械库角色。角色展示。区域联机
    else
        self:AddRoleSkill(self.CurrentRoleId, self:GetSkillInitInfo(Info.SkillInfos))
    end
    
    --if not MiscUtils.GetGameCofingSettings("bUseBlueprintMeshAndABP") then
    self.CurrentSkinId = Info.AppearanceSuit and Info.AppearanceSuit.SkinId or Info.SkinId
    self.ShadowModelId = Info.ShadowModelId or 0
    -- if not MiscUtils.GetGameCofingSettings("bUseBlueprintMeshAndABP") then 
    --     self:InitAttributeFromTable()
    -- end
    if(self.CurrentCompositeMesh) then 
        self.CurrentCompositeMesh = nil
    end
    self:LoadCurrentModel()
    self.EnableAnimGravity = 0
    self.UsingAnimGravity = false
    -- end
    self.bJetJump = false
    self.EnableAnimFly = false
    if(self.BattleCharInfo) then
        self.bJetJump = self.BattleCharInfo.EnableJetJump or false
        self.EnableAnimFly = self.BattleCharInfo.EnableAnimFly or false
    end
    print(_G.LogTag, "bJetJump", self.bJetJump)
    
    self:PlayerCommonInit(Info)
end

function Component:LoadCurrentModel()
    self:GetCharModelComponent():LoadCurrentModel()
end

function Component:AuthorityInitInfo(Info)
    self.UnitType = Info.UnitType
    if not self:IsAIControlled() then -- AI的这部分逻辑在RealInitInfo_CPP里完成
        local Level = Info.Level or 1
        self:SetAttr("Level", Level)
        self:SetCharLevel(Level)
        self:SetAttr("Exp", Info.Exp or 0)
        self:SetAttr("GradeLevel", Info.GradeLevel or Const.DefaultCharGrade)
        self:SetAttr("EnhanceLevel", Info.EnhanceLevel or 0)
        if Info.Camp then
            self:SetCamp(Info.Camp)
        end
        -- self.BattleCharInfo = self:GetDataInfo(self.CurrentRoleId)
    end
    self:SetTableAttr(Info.ReplaceAttrs)
    if self:IsPlayer() then
        self:SetStartLevelId()
    else
        self:UpdateCurrentLevelId()
        if self.CurrentLevelId:Length() > 0 then
            self:SetSpawnLevelId(self.CurrentLevelId:Get(1))
        end
    end

    self.AvatarQuestRoleID = Info.AvatarQuestRoleID or 0
end

function Component:SetPlayerInfo(Info)
    self.EndPointTransform = nil
    if Info.PlayerHp then
        self:SetAttr("Hp", math.min(Info.PlayerHp, self:GetAttr("MaxHp")))
        self:CalcHpPercent()
    end
    if Info.PlayerSp then
        self:SetAttr("Sp", math.min(Info.PlayerSp, self:GetAttr("MaxSp")))
    end
    if Info.PlayerES then
        self:SetAttr("ES", math.min(Info.PlayerES, self:GetAttr("MaxES")))
    end

    -- 恢复复活次数
    if Info.DeathInfo then
        self:SetDeathInfo(Info.DeathInfo)
    end
end

------------- ENDS -----------------
-- 原定移c++，因没有逻辑，暂时不移
function Component:SnapShotInitInfo(Info)
end


function Component:GetAvatarBuffList()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local PlayerController = nil
    local AvatarBuffs = nil
    if self:IsPhantom() then
        PlayerController = self.PhantomOwner:GetController()
    else
        PlayerController = self:GetController()
    end

    if GameMode and PlayerController then
        if IsStandAlone(PlayerController) then
            local Avatar = GWorld:GetAvatar()
            if Avatar then
                AvatarBuffs = Avatar.ServerBuffs
            end
        else    -- 考虑DS情况，无法获得每位玩家的Avatar对象，所以要靠Dump数据
            local AvatarEid = PlayerController.AvatarEidStr
            local AvatarInfo = GameMode.AvatarInfos[AvatarEid]
            if not AvatarInfo then return end
            AvatarBuffs = AvatarInfo.PlayerInfo.ServerBuffs
        end
    end

    return AvatarBuffs
end

function Component:GetAvatarBuffList_Cpp()
    local AvatarBuffs = self:GetAvatarBuffList() or {}
    local RetArr = TArray(UE4.FAvatarBuffInfo)
    if AvatarBuffs then
        for _, BuffInfo in pairs(AvatarBuffs) do
            local BuffInfoCpp = UE4.FAvatarBuffInfo()
            BuffInfoCpp.BuffId = BuffInfo.BuffId
            BuffInfoCpp.BuffLevel = BuffInfo.Level
            RetArr:Add(BuffInfoCpp)
        end
    end

    return RetArr
end


-- 施加服务端buff，考虑玩家和魅影
function Component:InitAvatarBuffs()
    local AvatarBuffs = self:GetAvatarBuffList()
    local Battle = Battle(self)
    if AvatarBuffs then 
        for _, BuffInfo in pairs(AvatarBuffs) do
            local BuffData = DataMgr.Buff[BuffInfo.BuffId]
            if (not BuffData) or (BuffData.IsAvatarBuff == 1 and not self:IsPlayer()) then    -- IsAvatarBuff==1时，只给玩家施加
                goto continue
            end
            if Battle then
                Battle:AddAvatarBuffToTarget(self, self, BuffInfo.BuffId, -1, 0, BuffInfo.Level)
            end

            ::continue::
        end
    end
end

function Component:ClientInitInfo(Info)
    if Info.FromOtherWorld then 
        self:SetCharacterTagIdle()
        return 
    end
    if self:IsPlayer() and not Info.ChangeRole then
        -- self:AddTimer(1.0, function()
            -- DebugPrint("Tianyi@ 222self = " .. self:GetName())
            -- DebugPrint("Controller: " .. self:GetController():GetName())
            -- DebugPrint("PlayerState: " .. self:GetController().PlayerState:GetName())
        -- end)

        -- DebugPrint("Tianyi@ 111 self = " .. self:GetName())
        -- DebugPrint("Controller: " .. self:GetController():GetName())
        -- DebugPrint("PlayerState: " .. self:GetController().PlayerState:GetName())
        if self:JudgeIfPlayLevelEnter() and not Info.ChangeRole then
            self:SetCharacterTag("LevelEnter")
            self.ShouldPlayEnterMontage = true
        else
            self:SetCharacterTagIdle()
        end
        
        self:InitUIWidgetComponent()
        if (IsValid(self.BillboardComponent)) then
            self.BillboardComponent:InitPlayerBillBoard(self,"Char")
        end
        if self.BP_RecoverInteractiveComponent then 
            self.BP_RecoverInteractiveComponent:InitCharInfo()
        end
        if self:IsMainPlayer() then
            if IsClient(self) or IsStandAlone(self) then
                self:SetupCameraControlComponent()
                self.UploadBDCTrackInfo = {}
            end
        end

        local PlayerState = self:GetEMPlayerState()
        if PlayerState then
            local WheelIndex = PlayerState.WheelIndex
            DebugPrint("gmy@CharacterInitLogic Component:ClientInitInfo", WheelIndex, self.SquadWheelIndex)
            if WheelIndex > 0 then
                self.SquadWheelIndex = WheelIndex
            else
                self.SquadWheelIndex = -1
            end
        end
    end

    -- DebugPrint("gmy@CharacterInitLogic Component:ClientInitInfo", self:GetLocalRole())
    if self:GetLocalRole() == Const.ROLE_AutonomousProxy and self:IsPlayer() then
        self:ServerNotifyAutonomousInit()
    end
end


function Component:FormatWeaponInfo(TempWeapon, DumpWeaponInfo)
    TempWeapon.SlotData = {}
    TempWeapon.ModData = {}
    TempWeapon.ModPassives = nil
    TempWeapon.SkillInfos = nil
    TempWeapon.ReplaceAttrs = nil
    TempWeapon.EnhanceLevel = DumpWeaponInfo.EnhanceLevel or 0
    TempWeapon.WeaponId = DumpWeaponInfo.WeaponId or 0
    TempWeapon.GradeLevel = DumpWeaponInfo.GradeLevel or 0
    TempWeapon.AppearanceInfo = DumpWeaponInfo
    TempWeapon.AppearanceInfo.EnhanceLevel = nil
    TempWeapon.AppearanceInfo.GradeLevel = nil
end

function Component:ClientPlayEnterMontage()
    if not self.ShouldPlayEnterMontage then return end
    -- self.ShouldPlayEnterMontage = false
    local Callback = { 
        OnCompleted = self.OnLevelEnterComplete,
        OnInterrupted = self.OnLevelEnterInterrupted
    }
    if self.PlayerAnimInstance then 
        self.PlayerAnimInstance:SetKawaiiPhysics_Cpp("LevelEnter")
    end

    if self.NpcAnimInstance then 
        self.NpcAnimInstance:SetKawaiiPhysics_Cpp("LevelEnter")
    end
    self:PlayActionMontage("Interactive/LevelFinish", "LevelEnter_Montage" , Callback)
end

function Component:OnCharacterReady(Info)

    self:SetActorHideTag("login", false)
    if Info.FromOtherWorld then
        if Info.IsDungeonEnd then
            self:ServerSetUpWeapons(Info.MeleeWeapon, Info.RangedWeapon, Info.UltraWeapons)
        else
            self:ServerSetUpWeapons(Info.MeleeWeapon, Info.RangedWeapon, nil)
        end
        if(Info.ShowWeapon) then 
            self:ChangeUsingWeaponByType(Info.ShowWeapon)
        end
        self.DontInitColor = true
        self:HandleModelFashion()
        self.Overridden.OnCharacterReady(self)
        self.Overridden.ReceiveBeginPlay(self)
        self:ReceiveOnCharacterReady()
        return
    end

    -- self.Overridden.ReceiveBeginPlay(self)
    -- self.Overridden.OnCharacterReady(self)
    self:GetBossDestructableComponent()
    local IsAut = IsAuthority(self)
    if IsAut then
        if not self:IsSummonMonster() then
            self:ServerSetRoleMod(Info.RoleId, Info.ModPassives, false)
        end

        self:ServerSetUpWeapons(Info.MeleeWeapon, Info.RangedWeapon, Info.UltraWeapons)
        self:InitAllWeaponModifier(Info.ReplaceAttrs)
       -- self:ServerSetUpAccessories()
        self:ServerSetUpDestructableBody()
        self:InitAvatarBuffs(Info)
        if Info.Pet and self:IsPlayer() then
            local PetId = Info.Pet.PetId
            local CurBattlePet = self:GetBattlePet()
            if PetId then
                local AffixList = TArray(0)
                if Info.Pet.EntryIds then
                    for i, EntryId in ipairs(Info.Pet.EntryIds) do
                        local Data = DataMgr.PetEntry[EntryId]
                        if Data then
                            AffixList:Add(EntryId)
                        end
                    end
                end
                if CurBattlePet and CurBattlePet.BattlePetId ~= 0 then
                    self:ServerRemoveBattlePet()
                end
                local PetLevel = Info.Pet.PetLevel or 1
                self:ServerSetBattlePet(PetId, PetLevel, true, AffixList)
            end
        end
    else
        if self.GetAccessories then
            for _, Accessory in pairs(self:GetAccessories()) do
                Accessory:InitAccessoryInfo(Accessory.AccessoryId)
            end
        end
    end
    print(_G.LogTag,"LXZ OnCharacterReady", self:GetName(), self:IsMainPlayer(), Info.ChangeRole)
    if self:IsMainPlayer() and not Info.ChangeRole then
        local FXPreloadGameInstanceSubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UE4.UFXPreloadGameInstanceSubsystem)
        if FXPreloadGameInstanceSubsystem then
            local ModelId = self:GetCharModelComponent():GetCurrentModelId()
            local ModelData = DataMgr.Model[ModelId]
            local Prefix = ModelData.MontagePrefix
            if Prefix and string.find(Prefix, "_") == string.len(Prefix) then
                Prefix = string.sub(Prefix, 1, -2)
                FXPreloadGameInstanceSubsystem:PreloadCharacterFX(Prefix)
            end
        end
        self:AddInteractiveTrigger()
        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
        local LoadingUI = GameInstance:GetLoadingUI()
        if LoadingUI and LoadingUI.bIsInLoading then -- 如果正在加载中，先禁用交互触发（WBP_CommonChangeSceneBg_C中结束加载时会重新打开）
            self:SetCanInteractiveTrigger(false, "Loading")
        end
    end
    self:SetInteractiveTriggerDistance(self:GetAttr("DropDistance"))
    if self:IsPlayer() and not Info.ChangeRole then
        local function ClientTryEndLoading()
            local GameState = UE4.URuntimeCommonFunctionLibrary.GetCurrentGameState(self)
            if not GameState.PlayerReady then
                GameState.PlayerReady = true
                GameState:TryEndLoading("PlayerReady")
            end
        end

        if IsAuthority(self) then
            -- 服务器初始化完成
            self:InitRegionBattleStateObject()
            if self:GetController() then
                local GameMode = UE4.UGameplayStatics.GetGameMode(self)
                local AvatarEidStr = self:GetController().AvatarEidStr
                if GameMode.LevelLoader and not GameMode.AlreadyInit then
                    GameMode.LevelLoader:SetInitTrans(self:GetOwner())
                end
                GameMode:OnCharacterReady(AvatarEidStr, self)
                GameMode:TryTriggerOnInit(AvatarEidStr)
                self:TryCreatePhantomBySquad(GameMode, AvatarEidStr)
            end
        else
            -- 客户端初始化完成
            ClientTryEndLoading()
        end

        -- 单机初始化完成
        if IsStandAlone(self) then
            ClientTryEndLoading()
        end
    end

    -- 联机服务器
    if IsDedicatedServer(self) and IsAuthority(self) then
        self.ServerBornInfo = self.BornInfo:ToEffectStruct()
    end

    -- self.DefaultCapsuleCollisionType = self.CapsuleComponent:GetCollisionEnabled()
    -- local HitCapsult = self.MonsterHitedCapsule
    -- self.DefaultHitCapsuleCollisionType = HitCapsult and HitCapsult:GetCollisionEnabled() or ECollisionEnabled.NoCollision
    self:ZeroComboCount(UE4.EClearComboReason.Timelimit)
    self.DontInitColor = true
    self:HandleModelFashion()

    self:RefreshActorHideTag()

    self.Overridden.OnCharacterReady(self)
    self.Overridden.ReceiveBeginPlay(self)
    self:ReceiveOnCharacterReady()

    if not self:IsMainPlayer() and (self:IsPlayer() or self:IsPhantom()) then
        EventManager:FireEvent(EventID.ShowTeammateBloodUI,self.Eid, self:IsPlayer(), self)
    end

    if self:IsMainPlayer() then
        if Info.ChangeRole then
            EventManager:FireEvent(EventID.ChangeRole)
        end
        local Controller = self:GetController()
        Controller:ForbidWeapon()
        if IsClient(self) or IsStandAlone(self) then
            -- 初始化主界面相关
            self:InitSceneStartUI()
        end
        EventManager:FireEvent(EventID.OnMainCharacterInitReady, self.Eid)
        EventManager:FireEvent(EventID.OnCharacterInitSuitRecover)
    else
        EventManager:FireEvent(EventID.OnCharacterInitReady, self.Eid)
    end

    -- PrintTable({ChangeRole=self})
    if self:IsPhantom() then
        EventManager:FireEvent(EventID.OnPhantomInitReady, self.Eid)
    end

    if Info.ChangeRole then
        self.WeaponPos = Const.Shoulder
        if not self:IsNPC() then
            self.EMAnimInstance = self.Mesh:GetAnimInstance()
            if self.EMAnimInstance and not self.EMAnimInstance.Begining then
                self.EMAnimInstance:AnimInstanceRestart()
            end
        else
            self.NpcAnimInstance = self.Mesh:GetAnimInstance()
            if self.NpcAnimInstance and not self.NpcAnimInstance.Begining then
                self.NpcAnimInstance:AnimInstanceRestart()
            end
        end
    end

    if IsAuthority(self) then
        self:SetPlayerInfo(Info)
    end
    self.InfoForInit.ChangeRole = true
end

function Component:TryCreatePhantomBySquad(GameMode, AvatarEidStr)
    if not GameMode:GetDungeonComponent() then                                      -- 只在副本里 且不是副本的临时场景召唤预设阵容魅影
        DebugPrint("TryCreatePhantomBySquad not Valid", self.Eid, AvatarEidStr)
        return
    end

    if URuntimeCommonFunctionLibrary.IsWorldCompositionEnabled(self) then           -- WC副本
        if GameMode.AlreadyInit then
            DebugPrint("TryCreatePhantomBySquad WC AlreadyInit, Create", self.Eid, AvatarEidStr)
            self:CreatePhantomBySquad(AvatarEidStr, GameMode)                       -- GameMode已走到OnInit，在此时机召唤魅影
        else
            DebugPrint("TryCreatePhantomBySquad WC, Register to OnInit", self.Eid, AvatarEidStr)
            GameMode.EMGameState:RegisterGameModeEvent("OnInit", self, function()
                DebugPrint("TryCreatePhantomBySquad WC, Create", self.Eid, AvatarEidStr)
                self:CreatePhantomBySquad(AvatarEidStr, GameMode)                   -- GameMode未走到OnInit，延迟到OnInit召唤魅影
            end)
        end
    else                                                                            -- 拼接关副本
        DebugPrint("TryCreatePhantomBySquad not WC, Create", self.Eid, AvatarEidStr)                                                                            -- 拼接关副本 
        self:CreatePhantomBySquad(AvatarEidStr, GameMode)                           -- 不变，在此时机召唤魅影
    end
end

function Component:HandleModelFashion()
    -- print(_G.LogTag, 'HandleModelFashionHandleModelFashion111')

    if not IsStandAlone(self) and not IsClient(self) then
        return
    end
    if not self.CharacterFashion then
        return
    end
    -- print(_G.LogTag, 'HandleModelFashionHandleModelFashion')
    self.CharacterFashion:CreateAllDynamicMaterialNew()
    if not self.BuffManager then 
        return 
    end
    if(self.BuffManager.ChangeModelId > 0) then
        return 
    end
    if self.DontInitColor then 
        self.DontInitColor = false
        return 
    end
    self.CharacterFashion:InitColorsWithInfo()
    -- self.CharacterFashion:ShowHideHorn(self.CharacterFashion.IsShowHorn)
end
function Component:GetBossDestructableComponent()
    -- if not self:IsMonster() then 
    --     return 
    -- end
    local PartComponents = self:K2_GetComponentsByClass(UDestructableBodyComponent:StaticClass())
    if PartComponents:Num() == 0 then 
        return
    end
    self.DestructParts = {}
    for Id, _Comp in pairs(PartComponents) do
        self.DestructParts[_Comp.PartId] = _Comp
    end
    if not self.SocketMap then 
        self.SocketMap = {}
    end
    if not self.HpNum then 
        self.HpNum = 0
    end
    self.MaxHpNum = PartComponents:Num()
end
-----------------------初始化流程结束-----------------------

function Component:PlayerCommonInit(Info)
    if (self:IsPlayer() or self:IsPhantom()) then
        -- self.OriginMeshTransform = self.Mesh:GetRelativeTransform()
        self:SetupActionLogicPramas()
        -- self:BindWeaponArm()
        self:InitAnimIntanceParam()
        self:InitAppearanceSuit(Info.AppearanceSuit or self.BornInfo.AppearanceSuit)
    end
end

function Component:GetNewSkinId(Context)
    if not Context then
        return CurrentSkinId
    end

    local Info = Context:GetLuaTable("AppearanceSuit") or self.BornInfo.AppearanceSuit
    if Info and Info.SkinId then
        return Info.SkinId
    end
    return CurrentSkinId
end

function Component:NewPlayerCommonInit(Context)
    if (self:IsPlayer() or self:IsPhantom()) then
        -- self.OriginMeshTransform = self.Mesh:GetRelativeTransform()
        self:SetupActionLogicPramas()
        -- self:BindWeaponArm()
        self:InitAnimIntanceParam()
        self:InitAppearanceSuit(Context:GetLuaTable("AppearanceSuit") or self.BornInfo.AppearanceSuit)
    end
end

function Component:InitAnimIntanceParam()
    if self.EMAnimInstance then 
        local ModelId = self:GetCharModelComponent():GetCurrentModelId()
        local ModelData = DataMgr.Model[ModelId]
        if self.EMAnimInstance.RunStopStartTime then
            self.EMAnimInstance.RunStopStartTime = ModelData.RunStopStartTime or Const.RunStopStartTime 
        end
        self:InitKawaiiParams(ModelData)
    end
    
    if self.NpcAnimInstance then 
        local ModelId = self:GetCharModelComponent():GetCurrentModelId()
        local ModelData = DataMgr.Model[ModelId]
        self.NpcAnimInstance.RunStopStartTime = ModelData.RunStopStartTime or Const.RunStopStartTime
        self:InitKawaiiParams(ModelData)
    end 
end

function Component:InitKawaiiParams(ModelData)
    -- self.KawaiiIdMap = {}
    if self.PlayerAnimInstance then
        if not ModelData.KawaiiIdList then 
            -- self.PlayerAnimInstance.bEnableKawaiiSetting = false or self.PlayerAnimInstance.ArtDebugSwitch
            local PlayerAnimInstance = self.PlayerAnimInstance
            local DefaultKawaiiLayer = UE4.EKawaiiLayerState.EKLS_Default
            if PlayerAnimInstance.ArtDebugSwitch then
                DefaultKawaiiLayer = UE4.EKawaiiLayerState.EKLS_Battle
            end
            PlayerAnimInstance:SetKawiiLayerState(DefaultKawaiiLayer)
            return 
        end
        for i, v in pairs(ModelData.KawaiiIdList) do 
            if DataMgr.KawaiiParams[v] then 
                local KawaiiType = DataMgr.KawaiiParams[v].KawaiiType
                self.KawaiiIdMap:Add(KawaiiType, v)
                print(_G.LogTag, 'InitKawaiiParamsInitKawaiiParams', KawaiiType, v)
            end
        end
        self.PlayerAnimInstance:SetKawaiiPhysics_Cpp("LevelEnter")
    end
   
    if self.NpcAnimInstance then 
        if ModelData.KawaiiIdList then 
            for i, v in pairs(ModelData.KawaiiIdList) do 
                if DataMgr.KawaiiParams[v] then 
                    local KawaiiType = DataMgr.KawaiiParams[v].KawaiiType
                    self.KawaiiIdMap:Add(KawaiiType, v)
                    print(_G.LogTag, 'InitKawaiiParamsInitKawaiiParams', KawaiiType, v)
                end
            end
        end
        self.NpcAnimInstance:SetKawaiiPhysics_Cpp("LevelEnter")
    end 
end

function Component:InitAppearanceSuit(AppearanceSuit)
    if AppearanceSuit then
        if self.CharacterFashion then
            self.CharacterFashion:InitAppearanceSuit(AppearanceSuit)
        end
        if(self.BornInfo)then
            self.BornInfo.AppearanceSuit = AppearanceSuit
        end
    else
        self:ClearAllSuitItem()
        self:InitPartMeshCompWithDefault()
    end
    local Avatar = GWorld:GetAvatar()
    if Avatar then 
        return
    end
    if not self.CharacterFashion then
        return
    end
    if AppearanceSuit then 
        return
    end
    AppearanceSuit = {}
    AppearanceSuit.AccessorySuit = self.CharacterFashion:GetDefaultAccessorySuit()
    self.CharacterFashion:InitAppearanceSuit(AppearanceSuit)
end

function Component:SetStartLevelId()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not GameMode then
        return
    end
    local levelLoader=GameMode:GetLevelLoader()
    if not levelLoader or not levelLoader.enterLevelID or type(levelLoader.enterLevelID)~='string' then
        return
    end
    local array=TArray('')
    array:Add(levelLoader.enterLevelID)
    self:SetCurrentLevelId(array)
end

-- function Component:UpdateCurrentLevelId()
--     local GameMode = UE4.UGameplayStatics.GetGameMode(self)
--     if not GameMode then
--         return
--     end
--     local levelLoader=GameMode:GetLevelLoader()
--     if not levelLoader then
--         return
--     end
--     local array = levelLoader:GetAllLevelIdByLocation(self:K2_GetActorLocation())
--     self:SetCurrentLevelId(array)
-- end

-- 播放 返回 true
function Component:JudgeIfPlayLevelEnter()
    if MiscUtils.IsSimulatedProxy(self) then  -- 只有主控端进LevelEnter
        return false 
    end
    if not GWorld:GetAvatar() then
        return false
    end
    local PlayerState = self:GetEMPlayerState()
    if PlayerState and PlayerState.bIsEMInactive == true then 
        DebugPrint("Tianyi@ 重连不需要LevelEnter")
        return false
    elseif not PlayerState then 
        DebugPrint("Tianyi@ PlayState is nullptr")
    end

    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    if GameInstance.NeedPlayTempSceneMonstage then
        GameInstance.NeedPlayTempSceneMonstage = false
        return false
    end
    local CurrentDungeonId = GameInstance and GameInstance:GetCurrentDungeonId()
    if CurrentDungeonId then
        if DataMgr.Dungeon[CurrentDungeonId] and DataMgr.Dungeon[CurrentDungeonId].IsPlayLevelEnter then
            return true
        end
    end
    return false
end

function Component:OnLuaCleanAllTimer()
    self:CleanTimer()
end

------------ 因区域配置需要放到玩家初始化后面 因此在角色身上注册恢复方法 ------------------
function Component:OnCharacterInitSuitRecover()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local Avatar = GWorld:GetAvatar()
    EventManager:RemoveEvent(EventID.OnCharacterInitSuitRecover, self)
    if self:IsMainPlayer() and IsValid(GameMode) and Avatar and Avatar:CheckCurrentSubRegion() then
        if IsClient(self) or IsStandAlone(self) then
            GameMode:InitRegionSuit(Avatar, Avatar:GetSubRegionId2RegionId())
        end
    end
end


function Component:SetInteractiveTriggerDistance(NewDropDistance)
    if not IsValid(self.InteractiveTriggerComponent) then return end
    self.InteractiveTriggerComponent:SetInteractiveTriggerDistance(NewDropDistance)
end

function Component:CreatePhantomBySquad(AvatarEidStr, GameMode)
    if nil == GameMode or nil == AvatarEidStr then
        DebugPrint("gmy@CharacterInitLogic Component:CreatePhantomBySquad", "invalid params", AvatarEidStr)
        return
    end

    local AvatarInfos = GameMode.AvatarInfos
    if nil == AvatarInfos then
        DebugPrint("gmy@CharacterInitLogic Component:CreatePhantomBySquad", "invalid AvatarInfos", AvatarEidStr)
        return
    end
    
    local AvatarInfo = AvatarInfos[AvatarEidStr]
    if nil == AvatarInfo then
        DebugPrint("gmy@CharacterInitLogic Component:CreatePhantomBySquad", "invalid AvatarInfo", AvatarEidStr)
        return
    end
    
    local PhantomInfo = AvatarInfo.PhantomInfo
    if PhantomInfo then
        for Index, Data in ipairs(PhantomInfo) do
            if Data.RoleInfo and Data.RoleInfo.RoleId then
                self:CreatePhantom(Data.RoleInfo.RoleId, 1, Data, {IsSpawnBySquad=1, TeamIndex = Index})
            end
        end 
    end
end

return Component
