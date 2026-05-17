
require "UnLua"

local UpgradeUtils = {}

UpgradeUtils.GetMaxLevel = function(Target,Type)
    if Type == "Char" then
        local EnhanceLevel = Target.EnhanceLevel or 0
        local Data = DataMgr.Char[Target.CharId]
        local MaxLevel = Data and Data.CharMaxLevel
        local BreakData = DataMgr.CharBreak[Target.CharId]
        local NextBreakLevelInfo = BreakData and BreakData[EnhanceLevel + 1]
        return (NextBreakLevelInfo and NextBreakLevelInfo.CharBreakLevel) or MaxLevel,MaxLevel
    elseif Type == "Weapon" then
        local EnhanceLevel = Target.EnhanceLevel or 0
        local Data = DataMgr.Weapon[Target.WeaponId] or DataMgr.UWeapon[Target.WeaponId]
        local MaxLevel = Data and Data.WeaponMaxLevel
        local BreakData = DataMgr.WeaponBreak[Target.WeaponId]
        local NextBreakLevelInfo = BreakData and BreakData[EnhanceLevel + 1]
        return (NextBreakLevelInfo and NextBreakLevelInfo.WeaponBreakLevel) or MaxLevel,MaxLevel
    elseif Type == "Pet" then
        local BreakNum = Target.BreakNum or 0
        local Data = DataMgr.Pet[Target.PetId]
        local MaxLevel = Data and Data.PetMaxLevel
        local BreakData = DataMgr.PetBreak[Target.PetId]
        local BreakLevelInfo = BreakData and BreakData[BreakNum]
        return BreakLevelInfo and BreakLevelInfo.PetBreakLevel, MaxLevel
    end
end

UpgradeUtils.CalcCharOrWeaponLevelUp = function(Target,Type,Level,ComparedLevel)
    --计算升级信息（经验、银币）
    local Res = {
        CanUpgrade = false,
        CashConsume = 0,
        ExpConsume = 0,
        ExpNeed = 0,
        ErrorText = "",
        ResourceUse = {}
    }
    local Avatar = GWorld:GetAvatar()
    if(Avatar == nil or ComparedLevel - Level <= 0)then
        --ErrorText = "升级参数错误"
        return Res
    end
    local AllTargets = Avatar[(Type or "") .. "s"]
    if(AllTargets == nil or AllTargets[Target.Uuid] == nil)then
        --ErrorText = "目标不存在"
        return Res
    end
    if(ComparedLevel > UpgradeUtils.GetMaxLevel(Target,Type))then
        return Res
    end
    Res.ExpNeed = UpgradeUtils.CalcExpNeed(Target,Type,ComparedLevel)
    if(Res.ExpNeed == nil or Res.ExpNeed <= 0)then
        --ErrorText = "经验计算出现错误"
        return Res
    end
	local ExpResources = {}
    local AssumeExpResources = {}
	local AllResourceExpSum = 0
    local ExpIds={}
	if DataMgr.ResourceSType2Resource and DataMgr.ResourceSType2Resource[Type.."Exp"] then
		ExpIds = DataMgr.ResourceSType2Resource[Type.."Exp"]
	end
	local Length = #ExpIds
    for i=1,Length do
        local mResourceId = ExpIds[i]
        local TempTable = Avatar.Resources[mResourceId] or {Count = 0}
		local Resource = {  ResourceId = mResourceId,
                            Count = TempTable.Count,
                            UseParam = DataMgr.Resource[mResourceId].UseParam}
		AllResourceExpSum = AllResourceExpSum + Resource.Count * Resource.UseParam
        ExpResources[i] = Resource
        AssumeExpResources[i] = { ResourceId = Resource.ResourceId, UseParam = Resource.UseParam,Count = 1000000}
	end
    if AllResourceExpSum<Res.ExpNeed then
        Res.ErrorText = "LevelUp_Insufficient_Exp"
        local res = Target["Calculate" .. Type .. "LevelUpResources"](Target,Res.ExpNeed,AssumeExpResources)
        Res.ResourceUse = res.ResourceUse
        Res.ExpConsume = res.ExpConsume
        Res.CashConsume = UpgradeUtils.CalcCashConsume(Target,Type,Res.ExpConsume,Res.ExpNeed,Level,ComparedLevel)
		return Res
	else
        local res = Target["Calculate" .. Type .. "LevelUpResources"](Target,Res.ExpNeed,ExpResources)
        Res.ResourceUse = res.ResourceUse
        Res.ExpConsume = res.ExpConsume
	end
    Res.CashConsume = UpgradeUtils.CalcCashConsume(Target,Type,Res.ExpConsume,Res.ExpNeed,Level,ComparedLevel)
    if(Res.CashConsume <= 0)then
        --ErrorText = "银币计算出现错误"
		return Res
    end

    local Cash = Avatar.Resources[CommonConst.Coins.Coin2] or {Count = 0}
	if Cash.Count < Res.CashConsume then
        Res.ErrorText = "Insufficient_Cash"
		return Res
	end
    Res.CanUpgrade = true
    return Res
end

UpgradeUtils.CalcCashConsume = function(Target,Type,ExpConsume,ExpNeed,Level,ComparedLevel)
    --计算银币花费
    local CashConsume = -1
    if(Level >= ComparedLevel or Target.Level ~= Level)then
        return CashConsume
    end
    local LevelUpData
    if(Type == "Char")then
        LevelUpData = DataMgr.LevelUp
    elseif(Type == "Weapon")then
        LevelUpData = DataMgr.WeaponLevelUp
    end
    local Exp = ExpConsume
    local ExpToMax = (LevelUpData[Level][Type.."LevelMaxExp"] - Target.Exp)
    CashConsume = ExpToMax * LevelUpData[Target.Level].CashToExp
    Exp = Exp - ExpToMax
    for i=Level + 1,ComparedLevel-1 do
        CashConsume = CashConsume + LevelUpData[i][Type.."LevelMaxExp"] * LevelUpData[i].CashToExp
        Exp = Exp - LevelUpData[i][Type.."LevelMaxExp"]
    end
    CashConsume = CashConsume + Exp * LevelUpData[ComparedLevel].CashToExp
    CashConsume = math.ceil(CashConsume)
    if(ExpConsume - Exp ~= ExpNeed)then
        return -1
    end
    return CashConsume
end

UpgradeUtils.CalcExpNeed = function(Target, Type, Level)
    --计算升级所需经验
    local LevelUpData
    if(Type == "Char")then
        LevelUpData = DataMgr.LevelUp
    elseif(Type == "Weapon")then
        LevelUpData = DataMgr.WeaponLevelUp
    end
    if(#LevelUpData < Level)then
        return -1
    end
    local ExpNeed = 0
	for i = Target.Level,Level-1,1 do
		ExpNeed = ExpNeed + LevelUpData[i][Type.."LevelMaxExp"]
	end
	ExpNeed = ExpNeed - Target.Exp
    return ExpNeed
end

UpgradeUtils.CalcBreakLevelUp = function(Target,Type,BreakLevel)
    --计算突破材料是否足够
    local TargetId
    if(Type == "Char")then
        TargetId = Target.CharId
    elseif(Type == "Weapon")then
        TargetId = Target.WeaponId
    end
    local Res = {
        CanUpgrade = false,
        FirstUpgrade = false,
        AvataLevelEnough = false,
        ResourceEnough = false,
        BreakHintText = "",
        ResourceUse = {}
    }
    local Avatar = GWorld:GetAvatar()
    local Data = nil
    if(DataMgr[Type.."Break"][TargetId])then
        Data = DataMgr[Type.."Break"][TargetId][BreakLevel]
    end
    if(Data == nil or Avatar == nil)then
        return Res
    end
    Res.CanUpgrade = true
    for i=1,4 do
        if(Data.ItemId[i] and Data.ItemNum[i])then
            local ResourceInfo = {}
            ResourceInfo.ResourceId = Data.ItemId[i]
            ResourceInfo.Count = Data.ItemNum[i]
            local Resource = Avatar.Resources[ResourceInfo.ResourceId] or {Count = 0}
            if(Resource.Count < ResourceInfo.Count)then
                Res.BreakHintText = "BreakLevelUp_Insufficient_Resources"
                Res.CanUpgrade = false
            end
            table.insert(Res.ResourceUse,ResourceInfo)
        end
    end
    Res.ResourceEnough = Res.CanUpgrade
    local BreakLimitLevelData = DataMgr.GlobalConstant["BreakLimitLevel_"..BreakLevel]
    if(BreakLimitLevelData and Avatar.Level < BreakLimitLevelData.ConstantValue)then
        Res.CanUpgrade = false
        Res.BreakHintText = string.format(GText("UI_COMMONPOP_TEXT_100030"), math.ceil(BreakLimitLevelData.ConstantValue))
        return Res
    end
    Res.AvataLevelEnough = true
    if(Target.Level < Data[Type .. "BreakLevel"])then
        Res.CanUpgrade = false
        return Res
    end
    if Res.CanUpgrade then
        local TargetBreakKey = table.concat({Type,"Break",".",TargetId,".",BreakLevel})
        if not Avatar.CollectRewardExpRecord[TargetBreakKey] then
            Res.FirstUpgrade = true
            Res.BreakHintText = string.format(GText("UI_Armory_WeaponBreakExp"), math.ceil(BreakLevel), math.ceil(Data.CollectRewardExp))
        end
    end
    return Res
end

UpgradeUtils.CheckCharCanUpgradeCardLevel = function(Char)
    local MaxGradeLevel = tonumber(DataMgr.GlobalConstant.CharCardLevelMax.ConstantValue)
    local Avatar = GWorld:GetAvatar()
    if(not Avatar)then
        return
    end
    if Char.GradeLevel >= MaxGradeLevel then
        return false
    end
    local Data = DataMgr.CharCardLevelUp[Char.CharId]
    if(not Data or not Data[Char.GradeLevel])then
        return false
    end
    local CharGradeLevelUpInfo = Data[Char.GradeLevel]
    local ResourceNeeded = Char:CalculateCharGradeLevelUpResources(CharGradeLevelUpInfo)
    for ResourceId, Value in pairs(ResourceNeeded) do
        if not Avatar.Resources[ResourceId] or Avatar.Resources[ResourceId].Count < Value then
            return false
        end
    end
    return true
end

-- 检查角色是否可以升级第7级（Ultra等级）
UpgradeUtils.CheckCharCanUpgradeUltraCardLevel = function(Char)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    -- 已经解锁了
    if Char:IsExtraGradeLevelUnlocked() then
        return false
    end
    -- 前6级必须满级
    local MaxGradeLevel = tonumber(DataMgr.GlobalConstant.CharCardLevelMax.ConstantValue)
    if Char.GradeLevel < MaxGradeLevel then
        return false
    end
    -- 必须在UltraCharCardLevelUp表中有数据
    if not Char:HasUltraGradeLevel() then
        return false
    end
    local ResourceNeeded = Char:CalculateCharUltraGradeLevelUpResources()
    for _, ResourceInfo in ipairs(ResourceNeeded) do
        local ResourceId = ResourceInfo.Id
        local Value = ResourceInfo.Num
        if not Avatar.Resources[ResourceId] or Avatar.Resources[ResourceId].Count < Value then
            return false
        end
    end
    return true
end

local ResourcesForUpgrade = nil
UpgradeUtils.IsResourceForUpgrade = function(ResourceId)
    if(not ResourcesForUpgrade)then
        ResourcesForUpgrade = {}
        for key, value in pairs(DataMgr.WeaponBreak) do
            for k, v in pairs(value) do
                for key, id in pairs(v.ItemId) do
                    ResourcesForUpgrade[id] = true
                end
            end
        end
    
        for key, value in pairs(DataMgr.CharBreak) do
            for k, v in pairs(value) do
                for key, id in pairs(v.ItemId) do
                    ResourcesForUpgrade[id] = true
                end
            end
        end
    end
    return ResourcesForUpgrade[ResourceId]
end

UpgradeUtils.CheckPetCanBreakLevelUp = function(Target)
    if(Target:IsMaxLevelBeforeBreak() and not Target:IsMaxBreak())then
        local Avatar = GWorld:GetAvatar()
        local BreakData = DataMgr.PetBreak[Target.PetId][Target.BreakNum]
        local ConsumeIds = BreakData.ConsumePetId
        for _,Pet in pairs(Avatar.Pets) do
            for _, Id in pairs(ConsumeIds) do
                if Pet.UniqueId ~= Target.UniqueId and Id == Pet.PetId and Avatar.CurrentPet ~= Pet.UniqueId then
                    return true
                end
            end
        end
        local ConsumeResources = BreakData.ConsumeResource or {}
        for ResourceId,_ in pairs(ConsumeResources) do
            local Resource = Avatar.Resources[ResourceId]
            if(Resource and Resource.Count>0) then
                return true
            end
        end
    end
end

return UpgradeUtils