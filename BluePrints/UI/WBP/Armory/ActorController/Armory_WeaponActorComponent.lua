local BattleDumpUtils = require "BluePrints.Client.BattleDumpUtils"
local HitResult = FHitResult()

---@type Armory_ActorController
local M = {}

function M:Init()
    self.WeaponCoroutineMap = {}
    self.WeaponCoroutineArray = {}
end

local MakeUncalculatedTrans = function(self)
    return UE4.UKismetMathLibrary.MakeTransform(self.UncalculatedTrans.Translation, self.UncalculatedTrans.Rotation:ToRotator(), FVector(1, 1, 1))
end

local WeaponHelperZOffset = 90

local _InitWeaponHelperTrans = function(self)
    local TargetTrans = MakeUncalculatedTrans(self)
    if(self.bPreviewSceneLoaded)then
        TargetTrans.Translation.Z = TargetTrans.Translation.Z + WeaponHelperZOffset
    end
    local OriginalRotation = FRotator(0,0,0)
    self.ArmoryHelper:SetOriginalRotation(OriginalRotation)
    TargetTrans.Rotation = OriginalRotation:ToQuat()
    self.ArmoryHelper.OriginalRootTrans = TargetTrans--self.ArmoryHelper:GetTransform()
    local WeaponHelper = self.ArmoryHelper:CreateOrGetWeaponHelper()
    WeaponHelper:K2_SetActorTransform(TargetTrans,false,HitResult,false)
    self.ArmoryHelper:SetViewActor(WeaponHelper)
    if(self.bEnableReflection)then
        local WeaponReflectionHelper = self.ArmoryHelper:CreateOrGetWeaponReflectionHelper()
        local ReflectionTrans =  UE4.UKismetMathLibrary.MakeTransform(TargetTrans.Translation, TargetTrans.Rotation:ToRotator(), TargetTrans.Scale3D)
        ReflectionTrans.Translation.Z = ReflectionTrans.Translation.Z - WeaponHelperZOffset * 2
        ReflectionTrans.Scale3D.Z = ReflectionTrans.Scale3D.Z*-1
        WeaponReflectionHelper:K2_SetActorTransform(ReflectionTrans,false,HitResult,false)
    end
end

local _RemoveWeaponCoroutine = function(self,CoroutineName)
    local Idx = self.WeaponCoroutineMap[CoroutineName]
    if(Idx)then
        table.remove(self.WeaponCoroutineArray,Idx)
        self.WeaponCoroutineMap[CoroutineName] = nil
        for name, index in pairs(self.WeaponCoroutineMap) do
            if index > Idx then
                self.WeaponCoroutineMap[name] = index - 1
            end
        end
    end
end

local _AddWeaponCoroutine = function(self,CoroutineName,Co)
    _RemoveWeaponCoroutine(self,CoroutineName)
    table.insert(self.WeaponCoroutineArray,Co)
    self.WeaponCoroutineMap[CoroutineName] = #self.WeaponCoroutineArray
end

local _FindWeaponCoroutine = function(self,CoroutineName)
    local Idx = self.WeaponCoroutineMap[CoroutineName]
    if(Idx)then
        return self.WeaponCoroutineArray[Idx]
    end
end

function M:DoSomethingWithWeapon(BehaviorName,Func,...)
    local Co = _FindWeaponCoroutine(self,BehaviorName)
    if(Co)then
        local Status = coroutine.status(Co)
        if (Status == "running" or Status == "suspended") then
            coroutine.close(Co)
            _RemoveWeaponCoroutine(self,BehaviorName)
        end
    end
    Co = coroutine.create(Func)
    _AddWeaponCoroutine(self,BehaviorName,Co)
    coroutine.resume(Co,...)
end

function M:DoDeferedWeaponBehavior()
    local WeaponCoroutineArray = {}
    for _, value in ipairs(self.WeaponCoroutineArray) do
        table.insert(WeaponCoroutineArray,value)
    end
    self.WeaponCoroutineArray = {}
    self.WeaponCoroutineMap = {}
    for _, Co in ipairs(WeaponCoroutineArray) do
        coroutine.resume(Co)
    end
end

---武器是否正在加载
function M:IsWeaponActorLoading()
    return self.IsArmoryWeaponLoading
end

---切换武器模型
function M:ChangeWeaponModel(WeaponData,bIfNoDelay,bForceChange)
    self:ResetActorRotation()
    local PlayCharacter = self:GetPlayerActor()
    if(self.CurrentWeaponInfo == WeaponData and PlayCharacter)then
        local WeaponTag = (WeaponData:HasTag("Melee") and "Melee") or "Ranged"
        local PlayerWeapon = PlayCharacter[WeaponTag.."Weapon"]
        if(PlayerWeapon and not bForceChange)then
            --角色已经有相同武器，不需要更换
            return
        end
    end
    local OldWeaponData = self.CurrentWeaponInfo
    if(self.IsPreviewMode
    and (not PlayCharacter or PlayCharacter.bHidden)
    and self.ViewActorType == self.ViewActorTypes.SingleWeapon)then
        if(OldWeaponData == WeaponData and not bForceChange)then
            --相同武器，不需要更换
            return
        end
        --仅武器无角色
        return self:ChangeSingleWeapon(WeaponData,bIfNoDelay)
    end
    self.bPlaySameMontage = true
    return self:ChangePlayerWeapon(WeaponData,PlayCharacter)
end

function M:PlayWeaponAppearFX()
    local _PlayWeaponAppearFX = function(...)
        local WeaponActor = self:GetWeaponActor()
        if(WeaponActor)then
            self:PlayAppearFX(WeaponActor.FXComponent)
        end
        --TODO:倒影特效
    end
    self:DoSomethingWithWeapon("PlayWeaponAppearFX",_PlayWeaponAppearFX)
end

function M:ChangePlayerWeapon(WeaponData,Player)
    self.CurrentWeaponInfo = WeaponData
    self.CurrentWeaponAppearanceInfo = WeaponData:DumpAppearanceInfo()
    local WeaponTag = (WeaponData:HasTag("Melee") and "Melee") or "Ranged"
    local ChangePlayerWeaponInternal = function(PlayCharacter)
        if(PlayCharacter == nil)then return end
        self:DestroyPlayerWeapon(PlayCharacter,WeaponTag)
        local Avatar = self:GetAvatar()
        if(not Avatar)then
            return
        end
        local WeaponInfos = AvatarUtils:GetWeaponBattleInfo(Avatar, WeaponData)
        WeaponInfos = WeaponInfos and WeaponInfos[WeaponTag.."Weapon"]
        local Weapon= PlayCharacter:AddWeapon(WeaponData.WeaponId,WeaponInfos)
        Weapon:InitWeaponAppearance(WeaponData:DumpAppearanceInfo())
        PlayCharacter.UsingWeapon = Weapon
        Weapon:SetWeaponTypeChanged(true)
        Weapon:SetActorHiddenInGame(true)
        Weapon:OnWeaponReady()
    end
    ChangePlayerWeaponInternal(Player)
    local PlayerReflection = self:GetReflectionActor(Player)
    ChangePlayerWeaponInternal(PlayerReflection)
end

function M:DestoryPlayerMeleeWeapon(PlayCharacter)
    self:DestroyPlayerWeapon(PlayCharacter,"Melee")
end

function M:DestroyPlayerWeapon(PlayCharacter,WeaponTag)
    WeaponTag = WeaponTag or "Melee"
    PlayCharacter = PlayCharacter or self.ArmoryPlayer
    local PlayerWeapon = PlayCharacter[WeaponTag.."Weapon"]
    if(PlayerWeapon)then
        PlayCharacter.Weapons:Remove(PlayerWeapon.WeaponId)
        PlayerWeapon:Destroy()
    end
    PlayCharacter[WeaponTag.."Weapon"]=nil
end

function M:AddPlayerUltraWeapons(Player)
    local Avatar = self.CurrentCharFromAvatar or self:GetAvatar()
    local UltraWeapons = BattleDumpUtils:GetDefaultUltraWeaponInfo(Avatar, self.CurrentCharInfo)
    for Index, value in ipairs(UltraWeapons) do
        local WeaponInfos = AvatarUtils:GetWeaponBattleInfo(Avatar, value.UltraWeapon)
        local WeaponInfo
        if(WeaponInfos.MeleeWeapon.WeaponId)then
            WeaponInfo = WeaponInfos.MeleeWeapon
        elseif(WeaponInfos.RangedWeapon.WeaponId)then
            WeaponInfo = WeaponInfos.RangedWeapon
        end
        Player:AddWeapon(WeaponInfo.WeaponId,WeaponInfo,Index)
    end
end

function M:ChangePlayerWeaponByType(WeaponType,Player)
    Player = Player or self.ArmoryPlayer
    Player:ChangeUsingWeaponByType(nil)
    if(WeaponType == nil)then
        return
    end
    local Weapon = Player:GetWeaponByWeaponTag(self.LastMontageAndCameraTag,1)
    local Avatar = self:GetAvatar()
    if(not Avatar)then
        return
    end
    if(Weapon == nil)then
        local WeaponData
        if(WeaponType == "Melee")then
            WeaponData = Avatar.Weapons[Avatar.MeleeWeapon]
        elseif(WeaponType == "Ranged")then
            WeaponData = Avatar.Weapons[Avatar.RangedWeapon]
        else
            return
        end
        self:ChangePlayerWeapon(WeaponData,Player)
    end
    Player:ChangeUsingWeaponByType(self.LastMontageAndCameraTag)
    if(Player.UsingWeapon)then
        Player.UsingWeapon:SetWeaponTypeChanged(true)
    end
end

---切换独立武器模型
function M:ChangeSingleWeapon(WeaponData,bNoFX)
    self.ViewActorType = self.ViewActorTypes.SingleWeapon
    self.CurrentWeaponInfo = WeaponData
    self.CurrentWeaponAppearanceInfo = WeaponData:DumpAppearanceInfo()
    self:BeforeViewActorChanged()
    self:SetSingleWeaponCamera(WeaponData)
    if(self.IsArmoryWeaponLoading)then
        self.NextWeaponDataToLoad = WeaponData
        return
    end
    self.NextWeaponDataToLoad = nil
    self.IsArmoryWeaponLoading = true
    local FXComponent
    if(IsValid(self.ArmoryWeapon))then
        FXComponent = self.ArmoryWeapon.FXComponent
    end
    FXComponent = FXComponent or (self.ArmoryPlayer and self.ArmoryPlayer.FXComponent)

    local UIManager = UIManager(self.ViewUI)
    UIManager:CreateShowWeapon(self,{
        WeaponId = WeaponData.WeaponId,
        AppearanceInfo = WeaponData:DumpAppearanceInfo(),
        bEnableReflection = self.bEnableReflection,
    },function(WeaponActor,WeaponReflection)
        self:OnArmoryWeaponLoaded(WeaponActor,WeaponReflection)
        self:SetWeaponActorEnhanceLevel(WeaponData.EnhanceLevel)
    end)
    if(bNoFX)then
        return true
    end
    self:HideWeaponActor("WeaponDisappearFX",true)
    self.DelayFrame = 30
    self:PlayDisappearFX(FXComponent,function()
        self:HideWeaponActor("WeaponDisappearFX",false)
        self:PlayWeaponAppearFX()
    end)
    return true
end

function M:GetSingleWeaponTag(WeaponData)
    local WeaponHelper = self.ArmoryHelper:CreateOrGetWeaponHelper()
    if(not WeaponHelper)then
        return
    end
    WeaponData = WeaponData or self.CurrentWeaponInfo
    if(self.SingleWeaponTagFrom == WeaponData)then
        return self.SingleWeaponTag
    end
    local Tags = WeaponData:GetTags()
    local Tag2Distance = WeaponHelper.CamDistance:ToTable()
    for key, value in pairs(Tags) do
        if(Tag2Distance[key])then
            self.SingleWeaponTag = key
            self.SingleWeaponTagFrom = WeaponData
            return self.SingleWeaponTag
        end
    end
end

function M:SetSingleWeaponCameraStartInfo(WeaponData)
    _InitWeaponHelperTrans(self)
    local WeaponHelper = self.ArmoryHelper:CreateOrGetWeaponHelper()
    local WeaponTag = self:GetSingleWeaponTag(WeaponData)
    local Distance = WeaponHelper.CamDistance:ToTable()[WeaponTag] or 0
    local ViewActorLocation = self.ArmoryHelper:K2_GetActorLocation()
    local Rotation = UKismetMathLibrary.FindLookAtRotation(ViewActorLocation + WeaponHelper:GetActorRightVector(), ViewActorLocation)
    local Offset = UKismetMathLibrary.GetForwardVector(Rotation) * - Distance
    local Location = ViewActorLocation + Offset
    self.ArmoryHelper:SetCameraStartInfo(Location,Rotation)
end

function M:SetSingleWeaponCamera(WeaponData, bKeepTransform)
    if not bKeepTransform then
        _InitWeaponHelperTrans(self)
    end
    local WeaponHelper = self.ArmoryHelper:CreateOrGetWeaponHelper()
    local WeaponTag = self:GetSingleWeaponTag(WeaponData)
    local Distance = WeaponHelper.CamDistance:ToTable()[WeaponTag] or 0
    local ViewActorLocation = self.ArmoryHelper:K2_GetActorLocation()
    local CalcRightVector
    if bKeepTransform then
        CalcRightVector = UKismetMathLibrary.GetRightVector(FRotator(0, 0, 0))
    else
        CalcRightVector = WeaponHelper:GetActorRightVector()
    end
    local Rotation = UKismetMathLibrary.FindLookAtRotation(ViewActorLocation + CalcRightVector, ViewActorLocation)
    local Offset = UKismetMathLibrary.GetForwardVector(Rotation) * - Distance
    if self.ExCameraOffset then
        Offset = Offset + self.ExCameraOffset
    end
    self.ArmoryHelper:TransformCamera(Offset,Rotation,0.5)
    local FOV = 70
    if(WeaponHelper.CamFOV)then
        FOV = WeaponHelper.CamFOV:ToTable()[WeaponTag] or 70
    end
    self.ArmoryHelper:StartFOVAnim(FOV,0.5,14)
    local MinDistance = WeaponHelper.CamDistance_Min:ToTable()[WeaponTag] or 0
    local MinLocation = UKismetMathLibrary.GetForwardVector(Rotation) * -MinDistance
    local MaxDistance = WeaponHelper.CamDistance_Max:ToTable()[WeaponTag] or 0
    local MaxLocation = UKismetMathLibrary.GetForwardVector(Rotation) * -MaxDistance
    if self.ExCameraOffset then
        MaxLocation = MaxLocation + self.ExCameraOffset
        self.ExCameraOffset = nil
    end
    self.ArmoryHelper:SetCameraScrollRange(MinLocation, MaxLocation, 0.5)
    if(MinDistance ~= 0 or MaxDistance ~= 0)then
        self.ArmoryHelper.EnableCameraScrolling = true
    end
end

---武器加载完成回调
function M:OnArmoryWeaponLoaded(WeaponActor,WeaponReflection)
    self.IsArmoryWeaponLoading = false
    if(self.bDestructed)then
        DebugPrint("Error: 预览武器加载完成回调错误，可能是ActorController没有正确销毁")
        return
    end
    if(self.NextWeaponDataToLoad)then
        self:ChangeSingleWeapon(self.NextWeaponDataToLoad)
        return
    end
    self.ArmoryWeapon = WeaponActor
    self:SetReflectionActor(WeaponActor,WeaponReflection)
    self:SetReflectionActor(self.ArmoryHelper:CreateOrGetWeaponHelper(),self.ArmoryHelper:CreateOrGetWeaponReflectionHelper())
    CommonUtils:SetActorTickableWhenPaused(WeaponActor,true)
    self:SetAccessoriesTickableWhenPaused(WeaponActor.Accessories)
    self.ArmoryHelper:SetWeapon(self.ArmoryWeapon,self:GetReflectionActor(self.ArmoryWeapon))
    self.ArmoryHelper:SetViewActor(self.ArmoryWeapon)
    if(WeaponReflection)then
        CommonUtils:SetActorTickableWhenPaused(WeaponReflection,true)
        self:SetAccessoriesTickableWhenPaused(WeaponReflection.Accessories)
    end
    self:ResetActorRotation()
    self:DoDeferedWeaponBehavior()
    if(self.ViewActorType ~= self.ViewActorTypes.SingleWeapon)then
        self:HideWeaponActor(self.UIName,true)
    end
end


---获取武器Actor，独立武器优先
function M:GetWeaponActor()
    if(self.IsArmoryWeaponLoading)then
        if(coroutine.isyieldable())then
            coroutine.yield()
        else
            return
        end
    end
    if(IsValid(self.ArmoryWeapon))then
        return self.ArmoryWeapon
    end
    if(not self.ArmoryPlayer or not self.CurrentWeaponInfo)then
        return
    end
    if(self.CurrentWeaponInfo:HasTag("Melee"))then
        return self.ArmoryPlayer.MeleeWeapon
    else
        return self.ArmoryPlayer.RangedWeapon
    end
end

function M:GetWeaponActorAsync(Callback,Owner)
    local _GetWeaponActorAsync = function(Callback,Owner)
        local WeaponActor = self:GetWeaponActor()
        if(Callback)then
            Callback(Owner,WeaponActor)
        end
    end
    self:DoSomethingWithWeapon("GetWeaponActorAsync",_GetWeaponActorAsync,Callback,Owner)
end

---获取独立武器Actor
function M:GetSingleWeaponActor()
    if(self.IsArmoryWeaponLoading)then
        if(coroutine.isyieldable())then
            coroutine.yield()
        else
            return
        end
    end
    if(IsValid(self.ArmoryWeapon))then
        return self.ArmoryWeapon
    end
end

function M:GetSingleWeaponReflection()
    --TODO:
end

---获取玩家武器Actor
function M:GetPlayerWeaponActor()
    if(self.IsArmoryWeaponLoading)then
        if(coroutine.isyieldable())then
            coroutine.yield()
        else
            return
        end
    end
    if(not self.ArmoryPlayer or not self.CurrentWeaponInfo)then
        return
    end
    if(self.CurrentWeaponInfo:HasTag("Melee"))then
        return self.ArmoryPlayer.MeleeWeapon
    else
        return self.ArmoryPlayer.RangedWeapon
    end
end

function M:HideWeaponActor(Tag,IsHidden)
    local _HideWeaponActor = function(...)
        local WeaponActor = self:GetWeaponActor()
        local func = function(Actor)
            if(Actor)then
                if(Tag)then
                    Actor:SetActorHideTag(Tag,IsHidden)
                else
                    Actor:SetActorHiddenInGame(IsHidden)
                end
            end
        end
        func(WeaponActor)
        func(self:GetReflectionActor(WeaponActor))
    end
    self:DoSomethingWithWeapon("HideWeaponActor",_HideWeaponActor)
end

function M:BeforeViewActorChanged()
    if(self.ViewActorType == self.ViewActorTypes.SingleWeapon)then
        self:HideWeaponActor(self.UIName,true)
    end
end

function M:AfterViewActorChanged()
    self:HideWeaponActor(self.UIName,false)
end

function M:WeaponLvUpOrBreakUp()
    local WeaponLvUpOrBreakUpInternal = function(WeaponActor)
        if(WeaponActor == nil)then return end
        WeaponActor.FXComponent:PlayEffectByIDParams(304, {bTickEvenWhenPaused = true,NotAttached = true})
    end
    WeaponLvUpOrBreakUpInternal(self.ArmoryPlayer.UsingWeapon)
    WeaponLvUpOrBreakUpInternal(self:GetReflectionActor(self.ArmoryPlayer.UsingWeapon))
end

function M:Component_DestroyActors()
    self.CurrentWeaponInfo = nil
    local UIManager = UIManager(self.ViewUI)
    if(IsValid(self.ArmoryWeapon))then
        self.ArmoryWeapon:SetActorHideTag(self.UIName,false)
    end
    UIManager:DestroyShowWeapon(self)
end


return M