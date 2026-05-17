local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"

---@type Armory_ActorController
local M = {}

function M:Init(Params)
end

--#region 坐骑创建和销毁

---创建坐骑
function M:CreateMount(MountId)
    local Player = self:GetPlayerActor()
    if not Player then
        return
    end
    local MountConfig = DataMgr.Mount[MountId]
    if not MountConfig.BattleMountId then
        return
    end
    if MountConfig.MountDisplayScale then
        Player:SetActorScale3D(FVector(MountConfig.MountDisplayScale, MountConfig.MountDisplayScale, MountConfig.MountDisplayScale))
    else
        Player:SetActorScale3D(Const.OneVector)
    end
    if not Player.OriginalLocation then
        Player.OriginalLocation = Player:K2_GetActorLocation()
    end
    if MountConfig.MountLocOffset then
        local OffsetX = MountConfig.MountLocOffset[1] and MountConfig.MountLocOffset[1] or 0
        local OffsetY = MountConfig.MountLocOffset[2] and MountConfig.MountLocOffset[2] or 0
        local OffsetZ = MountConfig.MountLocOffset[3] and MountConfig.MountLocOffset[3] or 0
        local Offset = FVector(OffsetX, OffsetY, OffsetZ)
        Player:K2_SetActorLocation(Player.OriginalLocation + Offset, false, nil, false)
    else
        Player:K2_SetActorLocation(Player.OriginalLocation, false, nil, false)
    end
    Player:EnableBattleMountOnDisplay(MountConfig.BattleMountId)
    self:PlayMountMontageOnDisplay()
    self.CurRiddingMount = MountId
    self:HidePlayerActorInternal(self:GetReflectionActor(Player),"ReflectionHideByMount",true)
    self.bEnableReflectionBeforeMount = self.bEnableReflection
    self.bEnableReflection = false
end

function M:RefreshMount()
    if not self.CurRiddingMount then
        return
    end
    local Player = self:GetPlayerActor()
    if not Player then
        return
    end
    local MountConfig = DataMgr.Mount[self.CurRiddingMount]
    Player:EnableBattleMountOnDisplay(MountConfig.BattleMountId)
end

function M:PlayMountMontageOnDisplay()
    if not self.ArmoryPlayer then
        return
    end
    local ArmoryPlayer = self.ArmoryPlayer
    self.DelayFrame = 30
    if self.DelayFrame and self.DelayFrame > 0 then
        self:HidePlayerAndMount(true)
        self:PlayDisappearFX(ArmoryPlayer.FXComponent,function()
            if self.bClosed or self.bDestructed or not self.IsControled then
                return
            end
            self:PlayAppearFX(ArmoryPlayer.FXComponent)
            self:HidePlayerAndMount(false)
            self:PlayMountMontage()
            if(self.LastDelayCameraTags)then
                self:SetArmoryCameraTag(table.unpack(self.LastDelayCameraTags))
            end
        end)
    else
        self:PlayMountMontage()
    end
end

function M:PlayMountMontage()
    local Player = self:GetPlayerActor()
    if not Player or not Player.CurMount then
        return
    end
    local MountId = Player.CurMount.UnitId
    local MountConfig = DataMgr.Mount[MountId]
    if not MountConfig then
        return
    end
    local MontagePath = MountConfig.AnimPath
    if not MontagePath then
        return
    end
    Player.CurMount:PlayMontageByPath(MontagePath)
end

---隐藏角色在坐骑上
function M:HidePlayerOnMount(IsHide)
    local Player = self:GetPlayerActor()
    if not Player then
        return
    end
    self:HidePlayerActorOnDisplayMount("ActorController_HidePlayerBeforeMount", IsHide)
end

function M:HidePlayerAndMount(IsHide)
    local Player = self:GetPlayerActor()
    if not Player or not Player.CurMount then
        return
    end
    self:HidePlayerActorOnDisplayMount("ActorController_HidePlayerPlayMount", IsHide)
    Player.CurMount:SetActorHideTag("ActorController_HidePlayerPlayMount", IsHide)
end

function M:HidePlayerActorOnDisplayMount(Tag, IsHidden, bDontSaveTag)
    if(not IsValid(self.ArmoryPlayer))then
        return
    end
    if(not bDontSaveTag)then
        self.PlayerActorHideTags[Tag] = IsHidden
    end
    self.ArmoryPlayer:SetActorHideTag(Tag, IsHidden, true, false)
    self.ArmoryPlayer:HideAllEffectCreature(Tag, IsHidden)
end

function M:GetArmoryPlayerRotation()
    local Player = self:GetPlayerActor()
    if not Player then
        return
    end
    return Player:K2_GetActorRotation()
end

function M:SetArmoryPlayerRotation(PlayerRot)
    if not PlayerRot then
        return
    end
    local Player = self:GetPlayerActor()
    if not Player then
        return
    end
    return Player:K2_SetActorRotation(PlayerRot, false, nil, false)
end

---销毁坐骑
function M:DestroyMount()
    local Player = self:GetPlayerActor()
    if not Player or not self.CurRiddingMount then
        return
    end
    Player:DisableBattleMount(true)
    self.CurRiddingMount = nil
    self.bEnableReflection = self.bEnableReflectionBeforeMount
    self:HidePlayerActorInternal(self:GetReflectionActor(Player),"ReflectionHideByMount",false)
end

--#endregion 坐骑创建和销毁

--#region 坐骑染色

---获取坐骑Actor
function M:GetMountActor()
    local Player = self:GetPlayerActor()
    if not Player then
        return nil
    end
    -- 通过Player的CurMount属性获取坐骑Actor
    return Player.CurMount
end

---改变坐骑皮肤全部染色
function M:ChangeMountSkinColor(Colors)
    local MountActor = self:GetMountActor()
    if not MountActor then
        return
    end
    -- 如果坐骑有CharacterFashion或类似接口，调用InitSkinColors
    if MountActor.CharacterFashion then
        MountActor.CharacterFashion:InitSkinColors(Colors)
    elseif MountActor.InitMountColors then
        MountActor:InitMountColors(Colors)
    end
end

---改变坐骑部位染色
function M:ChangeMountPartColor(PartIdx, Color, Fresnel)
    local MountActor = self:GetMountActor()
    if not MountActor then
        return
    end
    
    -- 尝试通过CharacterFashion改变部位颜色
    local CharacterFashion = MountActor.CharacterFashion
    if CharacterFashion and CharacterFashion.ChangePartColor then
        CharacterFashion:ChangePartColor(PartIdx, Color, Fresnel)
    elseif MountActor.ChangeMountPartColor then
        MountActor:ChangeMountPartColor(PartIdx, Color, Fresnel)
    else
        -- 尝试通过函数名调用，类似角色的方式
        local FunctionName = "SetMountTintColor"..PartIdx
        local Func = MountActor[FunctionName]
        if Func then
            Func(MountActor, Color)
            if Fresnel then
                local FresnelFunctionName = "SetMountFresnel"..PartIdx
                local FresnelFunc = MountActor[FresnelFunctionName]
                if FresnelFunc then
                    FresnelFunc(MountActor, Fresnel)
                end
            end
        end
    end
end

---开始坐骑部位高亮动画
function M:StartMountPartHighLight(LastColor, PartIdx, HighLightColor, Curve)
    local MountActor = self:GetMountActor()
    if not MountActor then
        return
    end
    
    local FunctionName = "SetMountTintColor"..PartIdx
    local Func = MountActor[FunctionName]
    if not Func then
        -- 尝试通过CharacterFashion
        local CharacterFashion = MountActor.CharacterFashion
        if CharacterFashion then
            Func = CharacterFashion[FunctionName]
        end
    end
    
    if not Func then
        return
    end
    
    local _TickFrequency = 0.033
    local _, MaxTime = Curve:GetTimeRange()
    local PassedTime = 0
    local Alpha
    
    self.ArmoryHelper:AddTimer(_TickFrequency, function()
        PassedTime = PassedTime + _TickFrequency
        if PassedTime >= MaxTime then
            self:StopMountPartHighLight(PartIdx)
            self:ChangeMountPartColor(PartIdx, LastColor)
            return
        end
        Alpha = Curve:GetFloatValue(PassedTime)
        local LerpedColor = UKismetMathLibrary.LinearColorLerp(HighLightColor, LastColor, Alpha)
        self:ChangeMountPartColor(PartIdx, LerpedColor)
    end, true, 0.0, FunctionName, true)
end

---停止坐骑部位高亮动画
function M:StopMountPartHighLight(PartIdx)
    local FunctionName = "SetMountTintColor"..PartIdx
    self.ArmoryHelper:RemoveTimer(FunctionName)
end

--#endregion 坐骑染色

function M:Component_DestroyActors()
end

return M

