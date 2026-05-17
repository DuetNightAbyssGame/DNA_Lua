local ModCommon = require "BluePrints.UI.WBP.Armory.Mod.Utils.ModCommon"
local ModDatas = require("BluePrints.UI.WBP.Armory.Mod.Utils.ModDatas")
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
local SkillUtils = require "Utils.SkillUtils"
local MiscUtils = require "Utils.MiscUtils"
local CommonUtils = require "Utils.CommonUtils"
local Mod = require("BluePrints.Client.CustomTypes.Mod").Mod
local ModSlotUIData = ModDatas.ModSlotUIData
local SelectedStuff = ModDatas.SelectedStuff
local PolarityEditModePayload = ModDatas.PolarityEditModePayload
local AutoEquipPayload = ModDatas.AutoEquipPayload


---@class ModModel:Model
---@type SelectedStuff SelectedStuff
local M=Class("BluePrints.Common.MVC.Model")

M._components = {
    "BluePrints.UI.WBP.Armory.Mod.Utils.ModModel_CopyModeComp",
    "BluePrints.UI.WBP.Armory.ModModel_DyePlanCopyModeComp",
}

--region 重写基类的函数
function M:Init()
    M.Super.Init(self)
    self:InitSortFunc()
    self.TargetType = nil
    self.CurModTarget = nil
    self.TargetMods = {} ---当前Target实际Mod集合 
    self:ResetUIData()
    self.SuitInfoCopyed = nil
    self.Context = {}
end

function M:Destory()
    self.CurModTarget = nil
    self.TargetType = nil
    self.SuitInfoCopyed = nil
    self.TargetMods = {} ---当前Target实际Mod集合
    self:ResetUIData()
    M.Super.Destory(self)
end

function M:GetAvatar()
    if self:IsInImport() then
        return M.Super.GetAvatar(self)
    end
    if self.DummyAvatar_CopyMode then
        return self.DummyAvatar_CopyMode
    end
    return ArmoryUtils:GetAvatar()
end

function M:ResetUIData()
    self.CurModList = {} ---UI上的Mod列表 
    self.CurModToIndex = {}
    self.CurSlots = {}
    self.EquipedMods = {}
    self.PolarityEditModeData = nil
    self.AutoEquipData = nil
    self.SortType = CommonConst.DESC
    self.SortBy = 1
    self.SelectedSiftItems = nil
    self.SelectedStuff = nil
    self.SiftItemDatas = nil
    self.CurSelectMod = nil
    self.MainUICase = ModCommon.MainUICase.Normal
    self.GamePadSelectedStuff = nil -- 手柄模式选中的Mod
    self.DummyAvatar_CopyMode = nil
    self.CopyModeSenderName = nil

    self.CurRecommendModIdList = nil -- 装备魔之楔推荐
end
-- endregion

-- region 主要数据的刷新和计算
function M:GenerateSlotUIDatas(SuitIndex)
    if not self.CurModTarget then return end
    self.CurSlots = {}
    self.EquipedMods = {}
    for SlotId, Slot in pairs(self:GetTarget():GetModSuit(SuitIndex)) do
        local NewSlotUIData = ModSlotUIData.New()
        NewSlotUIData:Init(SlotId, self:GetTarget())
        self.CurSlots[SlotId] = NewSlotUIData
        if NewSlotUIData.ModEid then
            self:SetEquipedMod(SlotId, NewSlotUIData.ModEid)
        end
    end
end

function M:CreateModContent(Mod, IsArmoryMod, bNeedLock)
    local ModContent = ArmoryUtils:NewModItemContent(Mod)
    ModContent.IsArmoryMod = IsArmoryMod -- 给tips区分军械库的Modtips
    ModContent.bEnableDrag = true
    ModContent.IsSelected = false
    ModContent.bDontOpenTipsWhenClick = true
    ModContent.bAura = false
    local ApplySlot = Mod:Data().ApplySlot
    if ApplySlot and #ApplySlot == 1 and table.findValue(ApplySlot, 9) then
        ModContent.bAura = true
    end
    if Mod.Level > 0 and bNeedLock then
        ModContent.LockType = Mod.LockState
        ModContent.IsLocked = Mod:IsLock()
    end
    return ModContent
end

function M:SetMainUICase(MainUICase)
    self.MainUICase = MainUICase
end

function M:SetSelectedStuff(ModUuid, SlotId)
    if self:IsInPolarityEditMode() then
        self.PolarityEditModeData:SetSelectedStuff(SlotId)
        return
    end
    if not ModUuid and not SlotId then
        self.SelectedStuff = nil
        self.CurSelectMod = nil
        return
    end
    self.SelectedStuff = SelectedStuff.New()
    self.SelectedStuff.ModUuid = ModUuid
    self.SelectedStuff.SlotId = SlotId
    self:_SetCurrSelectMod(ModUuid)
end

function M:SetEquipedMod(SlotId, ModUuid)
    if not self.EquipedMods[ModUuid] then
        self.EquipedMods[ModUuid] = {}
    end
    table.insert(self.EquipedMods[ModUuid], SlotId)
end

function M:RemoveEquipedMod(SlotId, ModUuid)
    if self.EquipedMods[ModUuid] then
        local Res, i = table.findValue(self.EquipedMods[ModUuid], SlotId)
        if Res then
            table.remove(self.EquipedMods[ModUuid], i)
        end
        if table.isempty(self.EquipedMods[ModUuid]) then
            self.EquipedMods[ModUuid] = nil
        end
    end
end

function M:CalcQuickEquipSlotsList(ModUuid)
    local SortedSlots = {}
    local Mod = self:GetMod(ModUuid)
    if not Mod then return SortedSlots end
    for SlotId, SlotUIData in pairs(self.CurSlots) do
        if not self:IsSpecificSlot(ModUuid, SlotId) then 
            goto continue1 
        end
        if SlotUIData:InState(ModCommon.SlotState.UnLock) and not SlotUIData:InState(ModCommon.SlotState.Used) then
            table.insert(SortedSlots, SlotUIData)
        end
        ::continue1::
    end
    local SortFunc = function(SlotUIData1, SlotUIData2)
        if Mod.Polarity == SlotUIData1:GetPolarity() and Mod.Polarity == SlotUIData2:GetPolarity() then
            return SlotUIData1.SlotId < SlotUIData2.SlotId
        end
        if Mod.Polarity == SlotUIData1:GetPolarity() then return true end
        if Mod.Polarity == SlotUIData2:GetPolarity() then return false end
        if Mod.Polarity ~= CommonConst.NonePolarity then
            if SlotUIData1:GetPolarity() == CommonConst.NonePolarity and SlotUIData2:GetPolarity() == CommonConst.NonePolarity then
                return SlotUIData1.SlotId < SlotUIData2.SlotId
            end
            if CommonConst.NonePolarity == SlotUIData1:GetPolarity() then return true end
            if CommonConst.NonePolarity == SlotUIData2:GetPolarity() then return false end
        end
        return SlotUIData1.SlotId < SlotUIData2.SlotId
    end
    table.sort(SortedSlots, SortFunc)
    return SortedSlots
end

function M:AddMod(ModUuid)
    self:GenerateModRepeatData(ModUuid)
    table.insert(self.CurModList, ModUuid)
    self:SortMods()
end

function M:RemoveMod(ModUuid)
    local Index = self.CurModToIndex[ModUuid]
    if Index then
        local ModUuid = self.CurModList[Index]
        table.remove(self.CurModList, Index)
        self.CurModToIndex[ModUuid] = nil
    end
end

--生成Mod重复组数据
function M:GenerateModRepeatData(ModUuid, Target)
    if not Target then Target = self:GetTarget() end
    local Tag = self.TargetType
    local SuitIndex = Target.ModSuitIndex
    local ModSuit = {}
    for SlotId, Slot in pairs(Target:GetModSuit(SuitIndex)) do
        if self:IsModUuidValid(Slot.ModEid) then
            ModSuit[SlotId] = Slot.ModEid
        else ModSuit[SlotId] = -1 end
    end
    local Res,OtherConflictMods = AvatarUtils:CheckModRepeat(self:GetAvatar(),Tag, Target.Uuid, SuitIndex,ModUuid, ModSuit)
    local Mod = self:GetMod(ModUuid)
    if not Mod then return end
    Mod.ConflictUuids:Clear()
    if not Res then
        local UsedUuid = {}
        for _,OtherConflictMod in ipairs(OtherConflictMods or {}) do
            if OtherConflictMod and (not self:IsEquipedInCurrSuit(ModUuid)) and 
             OtherConflictMod.Uuid ~=ModUuid and (not UsedUuid[OtherConflictMod.Uuid]) then
                Mod.ConflictUuids:Append(OtherConflictMod.Uuid)
                UsedUuid[OtherConflictMod.Uuid] = 1
            end
        end
    end
end

function M:_SetCurrSelectMod(ModUuid)
    if not ModUuid then
        self.CurSelectMod = nil
    else
        local Mod = self:GetMod(ModUuid)
        self.CurSelectMod = Mod
    end
end

function M:SetTarget(Target)
    self:ClearRecommendData()
    self:CalcModSuitTotalCost(Target, Target.ModSuitIndex ,true)
    self.CurModTarget = Target.Uuid
    self.TargetType = Target:GetTypeName()
    self.TargetMods = {}
    for ModUuid, Mod in pairs(self:GetAvatar().Mods) do
        if self:IsModMatchApplicationType(Mod) then
            self.TargetMods[ModUuid] = ModUuid
        end
    end
    self:UpdateConflictMods()
end

--计算Mod套装的耐受值总量
function M:CalcModSuitTotalCost(Target, ModSuitIndex, bCache)
    if not ModSuitIndex then ModSuitIndex = Target.ModSuitIndex end
    local Cost = AvatarUtils:GetModCostInSuit_SwitchMod(self:GetAvatar(), Target:GetTypeName(), 
        Target.Uuid, ModSuitIndex,nil,nil, function(_,Avatar, Tag, Uuid, ModSuitIndex)
            local ModSuit = AvatarUtils:GetTargetModSuit(Target, ModSuitIndex)
            if not ModSuit then 
                return false, 0, {}, {}, ModSuit, Target
            end
            ModSuit = {}
            for SlotId, Slot in pairs(Target:GetModSuit(ModSuitIndex)) do
                if self:IsModUuidValid(Slot.ModEid) then
                    ModSuit[SlotId] = Slot.ModEid
                else ModSuit[SlotId] = -1 end
            end
            return true, 0, {}, {}, ModSuit, Target
        end)
    if bCache then
        Target:SetModSuitCost(Cost, ModSuitIndex)
    end
    return Cost
end

--计算装配前后的耐受值差值
---@param Case number ModCommon.CalcVolumeDiffCase的枚举值，区分是槽位互换还是普通装卸
---@param Target Char|Weapon|UWeapon 当前Mod系统操作的目标宿主，可以是武器和角色
---@param ... table Case为Exchange则是两个槽位，case为Change则是槽位Id和ModUuid
---@return bool,number 耐受值是否爆表,耐受值差值
function M:CalcModVolumeDiff(Case, Target, ...)
    local MaxModVolume = Target:GetModVolume()
    local ModSuitIndex = Target.ModSuitIndex
    local CurrentModVolume = self:CalcModSuitTotalCost(Target, ModSuitIndex)
    local PreviewModVolume = CurrentModVolume
    if Case == ModCommon.CalcVolumeDiffCase.Exchange then
        local SSlotId , TSlotId = ...
        local SModSlot = Target:GetModSuit(ModSuitIndex)[SSlotId]
        local TModSlot = Target:GetModSuit(ModSuitIndex)[TSlotId]
        local SModSlotModUuid = SModSlot.ModEid
        local TModSlotModUuid = TModSlot.ModEid
        SModSlot.ModEid = TModSlotModUuid
        TModSlot.ModEid = SModSlotModUuid
        PreviewModVolume = self:CalcModSuitTotalCost(Target, ModSuitIndex)
        TModSlot.ModEid = TModSlotModUuid
        SModSlot.ModEid = SModSlotModUuid
    elseif Case == ModCommon.CalcVolumeDiffCase.Change then
        local SlotId, ModUuid = ...
        local ModSlot = Target:GetModSuit(ModSuitIndex)[SlotId]
        local ModSlotModUid = ModSlot.ModEid
        ModSlot.ModEid = ModUuid or ""
        PreviewModVolume = self:CalcModSuitTotalCost(Target, ModSuitIndex)
        ModSlot.ModEid = ModSlotModUid
        local Mod = self:GetMod(ModUuid)
        if Mod then
            MaxModVolume = MaxModVolume + Mod:CalcExtralCharVolume()
        end
    -- elseif Case == ModCommon.CalcVolumeDiffCase.TakeOff then
    --     local SlotId, ModUuid = ...
    --     local ModSlot = Target:GetModSuit(ModSuitIndex)[SlotId]
    --     local ModSlotModUid = ModSlot.ModEid
    --      @todo ....
    end
    if PreviewModVolume > MaxModVolume then
        return false , PreviewModVolume-CurrentModVolume
    end
    return true, PreviewModVolume-CurrentModVolume
end

--计算一个槽位考虑到所有加成效果的真实耐受值
---@param SlotId number 槽位Id
---@param SuitInfo Char|Weapon|UWeapon|{GetModSuit:fun():ModSlots} 套装信息 或 当前Mod系统操作的目标宿主
---@param ModInfo Mod|{Polarity:number, Cost:number} 槽位上的Mod或者待定装备的Mod，前者能计算真实耐受值，后者能计算预装卸情况的真实耐受值
---@param SlotPolarity Int 额外的槽位极性，槽位极性可能会变，作为预览
function M:CalcSlotRealCost(SlotId, SuitInfo, ModInfo,SlotPolarity)
    local ModSuit = SuitInfo:GetModSuit()
    local TargetSlot = ModSuit[SlotId]
    local ReduceCost = 0
    for _,Slot in pairs(ModSuit) do
        local SlotMod = self:GetAvatar().Mods[Slot.ModEid]
        if SlotMod and (not table.isempty(SlotMod.ReducePolarityEffect)) and SlotMod.ReducePolarityEffect[1] == ModInfo.Polarity then
            ReduceCost = ReduceCost + SlotMod.ReducePolarityEffect[2]
        end
    end
    local SlotCost = TargetSlot:GetModCost(ModInfo.Polarity, ModInfo.Cost, SlotPolarity)
    return math.max(0, SlotCost - ReduceCost)
end

---强制更新其他槽位的耐受值，因为有些mod有减耗效果，会改变其他同极性槽位mod的耐受值
function M:ForceCalcSlotsCost(ExcludeModUuid, bTakeOff)
    local ExcludeMod = self:GetMod(ExcludeModUuid)
    local DirtySlotIds = {}
    ---@param SlotUIData ModSlotUIData
    for SlotId, SlotUIData in pairs(self.CurSlots) do
        local ModUuid = SlotUIData.ModEid
        if ModUuid and ModUuid ~= ExcludeModUuid then
            local Mod = self:GetMod(ModUuid)
            if ExcludeMod.AddCharModCost or (Mod.Polarity == ExcludeMod.ReducePolarityEffect[1]) then
                self.CurSlots[SlotId] = ModSlotUIData.New()
                self.CurSlots[SlotId]:Init(SlotId, self:GetTarget(),SlotUIData.bEquiping)
                if not self:IsModUuidValid(self.CurSlots[SlotId].ModEid) then
                    self:RemoveEquipedMod(SlotId, ModUuid)
                    DirtySlotIds[SlotId] = ModUuid
                else
                    DirtySlotIds[SlotId] = ""
                end
            end
        elseif bTakeOff then
            self.CurSlots[SlotId]:SetModEid(nil)
        end
    end
    return DirtySlotIds
end

function M:UpdateConflictMods()
    for i, ModUuid in ipairs(self.CurModList) do
        self:GenerateModRepeatData(ModUuid)
    end
end
--endregion

--region 获取主要数据的接口
function M:GetSelectStuff()
    if self:IsInPolarityEditMode() then
        return self.PolarityEditModeData.SelectedStuff
    end
    return self.SelectedStuff
end

---@return ModSlotUIData
function M:GetSlotUIData(SlotId)
    return self.CurSlots[SlotId]
end

function M:GetSlotIdsWhichEquiped(ModUuid)
    return self.EquipedMods[ModUuid]
end

function M:IsModIdEquiped(ModId)
    local Mods = self:GetAvatar().Mods
    for ModUuid, _ in pairs(self.EquipedMods) do
        local Mod = Mods[ModUuid]
        if Mod.ModId == ModId then
            return true
        end
    end

    return false 
end

function M:IsEquipedInCurrSuit(ModUuid)
    local ClientRes = not table.isempty(self:GetSlotIdsWhichEquiped(ModUuid))
    local ServerRes = false
    local Target = self:GetTarget()
    for _, Uuid in ipairs(AvatarUtils:GetTargetModSuit(Target, Target.ModSuitIndex)) do
        if ModUuid == Uuid then
            ServerRes = true
            break
        end
    end
    return ClientRes or ServerRes
end

function M:GetModCountById(Id)
    local Count = 0
    for _, Mod in pairs(self:GetAvatar().Mods) do
        if Mod.ModId == Id then
            Count = Count + Mod.Count
        end
    end
    return Count
end

---获取与Mod有冲突关系的槽位数据
---@param ModUuid ObjId 待查询Mod
---@return ModSlotUIData 与待查询Mod有冲突关系的槽位
function M:GetSlotUIDatasWhichConflict(ModUuid)
    local Res = {}
    local Mod = self:GetMod(ModUuid)
    if not Mod or Mod.ConflictUuids:Length()==0 then
        return Res
    end
    for _,ConflictUuid in ipairs(Mod.ConflictUuids) do
        local SlotIds = self:GetSlotIdsWhichEquiped(ConflictUuid) or {}
        for _, SlotId in ipairs(SlotIds) do
            table.insert(Res, self.CurSlots[SlotId])
        end
    end
    return Res
end

function M:IsAnyModEquiped()
    if self:IsInImport() then
        local Target = self:GetTarget()
        local ModSuit = Target:GetModSuit()
        return not ModSuit:IsAllEmpty()
    end
    return  not table.isempty(self.EquipedMods)
end

---@return Char|Weapon|UWeapon
function M:GetTarget()
    if not self.TargetType then return nil end
    if self.TargetType == CommonConst.DataType.Char then
        return self:GetAvatar().Chars[self.CurModTarget]
    elseif self.TargetType == CommonConst.DataType.Weapon then
        return self:GetAvatar().Weapons[self.CurModTarget]
    elseif self.TargetType == CommonConst.ArmoryTag.UWeapon then
        return self:GetAvatar().UWeapons[self.CurModTarget]
    end
end

---@return Mod
function M:GetCurrSelectMod()
    return self.CurSelectMod
end

-- --判断mod是否可放置于指定槽位中
function M:IsSpecificSlot(ModUuid, SlotId)
    local Mod = self:GetMod(ModUuid)
    return self:IsSpecificSlotByMod(Mod, SlotId)
end

-- --判断mod是否可放置于指定槽位中
function M:IsSpecificSlotByMod(Mod, SlotId)
    local SpecificSlots = Mod:Data().ApplySlot
    if table.isempty(SpecificSlots) then 
        return true
    end
    for _, CSlotId in ipairs(SpecificSlots) do
        if CSlotId == SlotId then
            return true
        end
    end
    return false
end

--通过ModUuid获取Mod
---@return Mod
function M:GetMod(ModUuid)
    if not self:IsModUuidValid(ModUuid) then return end
    local _Mod = self:GetAvatar().Mods[ModUuid]
    if not _Mod and self.InvalidMods then
        return self.InvalidMods[ModUuid]
end
    return _Mod
end

function M:IsBugMod(ModUuid)
    if not GWorld.IsDev then return false end
    local Mod = self:GetMod(ModUuid)
    local ModConf = Mod:Data()
    local GenDesc = ArmoryUtils:GenModPassiveEffectDesc(ModConf, Mod.Level)
    if GenDesc == ModConf.PassiveEffectsDesc then
        GWorld.logger.error(string.format("ModId: %s 的被动描述没有填好 描述文本:%s", Mod.ModId, GenDesc))
        return true
    end
    for _, AddAttr in ipairs(ModConf.AddAttrs or {}) do
        AddAttr = SkillUtils.GrowProxyBySkillLevel('Mod', Mod.ModId, Mod.Level, AddAttr)
        local AttrVal = AddAttr.Value or AddAttr.Rate
        if type(AttrVal) ~= "number" then
            GWorld.logger.error(string.format(
                "ModId: %s 的属性配置有问题，属性名%s的索引%s找不到相关的成长配置\n(AllowModMultiplier:%s)",
                Mod.ModId, AddAttr.AttrName, AttrVal, AddAttr.AllowModMultiplier or "无"))
            return true
        end
    end
    return false
end

function M:IsModUuidValid(ModUuid)
    if type(ModUuid) == "number" then
        return ModUuid ~= -1
    end
    if type(ModUuid) == "string" then
        return not string.isempty(ModUuid)
    end
    return false
end

--获取当前套装魔之楔耐受值
function M:GetCurrentSuitCost(Target)
    if not Target then Target = self:GetTarget() end
    return Target:GetModSuitCost()
end

--获取Target的耐受值上限
function M:GetTargetMaxCost(Target)
    if not Target then Target = self:GetTarget() end
    return Target:GetModVolume()
end

--获取Mod槽位
---@return ModSlot
function M:GetModSlot(Target, SlotId, SuitIndex)
    local ModSuit = Target:GetModSuit(SuitIndex)
    local ModSlot = ModSuit[SlotId]
    return ModSlot
end

---@param SlotUIData ModSlotUIData
function M:IsRecommendedMod(SlotUIData, ModUuid)
    if not SlotUIData.ModEid then return false end
    local SlotMod = self:GetMod(SlotUIData.ModEid)
    local OtherMod = self:GetMod(ModUuid)
    local Case = ModCommon.CalcVolumeDiffCase.Change
    local Target = self:GetTarget() 
    local Res, CostDiff = self:CalcModVolumeDiff(Case, Target, SlotUIData.SlotId, ModUuid)
    if Res and OtherMod.Rarity > SlotMod.Rarity then
        return true
    end
    return false
end

function M:IsOwnedBySkillTree(SkillId)
    local Target= self:GetTarget()
    if not Target or Target:GetTypeName() ~= "Char" then return false end
    local SkillTreeInfo = Target.SkillTree
    for BranchIdx, BranchInfo in ipairs(SkillTreeInfo) do
        local NodeInfo = BranchInfo[1]
        if NodeInfo:IsSkill() and NodeInfo.TargetId == SkillId and NodeInfo.SkillOrAttr == 0 then
            return true
        end
    end
    return false
end

function M:GetSuitName(SuitIndex, Target)
    if not Target then Target = self:GetTarget() end
    if not SuitIndex then SuitIndex = Target.ModSuitIndex end
    if Target and Target.Uuid == 1 and Target.CharId then --临时角色没有ModSuitsName
        local RealAvatar = ArmoryUtils:GetAvatar()
        if RealAvatar and RealAvatar.Chars then
            for CharUuid, RealChar in pairs(RealAvatar.Chars) do
                if RealChar.CharId == Target.CharId then
                    local RealSuitName = RealChar.ModSuitsName[SuitIndex]
                    if not string.isempty(RealSuitName) then
                        return RealSuitName
                    end
                    break
                end
            end
        end
    end
    local SuitName = Target.ModSuitsName[SuitIndex]
    if string.isempty(SuitName) then
        SuitName = GText(string.format("Mod_SuitName_%s",SuitIndex))
    end
    return SuitName
end

function M:GetPolarityText(Polarity)
    return DataMgr.ModPolarity[Polarity].Char or ""
end

function M:GetSortedPolarityConfs()
    local SortedConfs = MiscUtils.Values(DataMgr.ModPolarity)
    table.sort(SortedConfs, function(a, b) return a.Id < b.Id end)
    return SortedConfs
end

function M:IsModUINormal()
    return self.MainUICase == ModCommon.MainUICase.Normal
end

function M:IsModUICopyMode()
    return self.MainUICase == ModCommon.MainUICase.CopyMode
end

function M:IsModUIPreview()
    return self.MainUICase == ModCommon.MainUICase.Preview
end
--endregion

--region 筛选和排序
function M:FilterModsOfTarget()
    if not self.CurModTarget then return end
    self.CurModList = {}
    for ModUuid, _ in pairs(self.TargetMods) do
        local Mod = self:GetMod(ModUuid)
        if self:FilterSingleModOfTarget(CommonConst.NonePolarity, false, Mod) then
            self:GenerateModRepeatData(Mod.Uuid)
            table.insert(self.CurModList, Mod.Uuid)
        end
    end
    self:SortMods()
end

function M:IsModMatchApplicationType(Mod)
    if not Mod or not Mod.ApplicationType then
        return false
    end
    if not self:GetTarget():HasApplicationType(Mod.ApplicationType) then
        return false
    end
    return true
end

function M:IsModMatchPolarity(Mod,Polarity, bStrictMatch)
    if Mod.Polarity ~= Polarity then
        if bStrictMatch or Polarity>0 then
            return false
        end
    end
    return true
end

function M:FilterSingleModOfTarget(Polarity, bStrictMatch, Mod)
    if not self:IsModMatchApplicationType(Mod) then
        return false
    end
    if not self:IsModMatchPolarity(Mod, Polarity, bStrictMatch) then
        return false
    end
    if not self:IsModMatchSift(Mod) then
        return false
    end
    return true
end

function M:InitSortFunc()
    if not self.ModSortFunc then
        self.ModSortFunc = {
            [2] = function(x,y)
                if type(x) ~= "table" and type(y) ~= "table" then
                    x = self:GetMod(x)
                    y = self:GetMod(y)
                end
                if x.Level ~= y.Level then return self:_Compare(x.Level, y.Level) end
                if x.Rarity ~= y.Rarity then return self:_Compare(x.Rarity,y.Rarity) end
                if x.Cost ~= y.Cost then return self:_Compare(x.Cost,y.Cost) end
                if x.Polarity~=y.Polarity then return self:_Compare(y.Polarity, x.Polarity) end
                return self:_Compare(y.ModId, x.ModId)
            end,
            [1] = function(x,y)
                if type(x) ~= "table" and type(y) ~= "table" then
                    x = self:GetMod(x)
                    y = self:GetMod(y)
                end
                if x.Rarity ~= y.Rarity then return self:_Compare(x.Rarity, y.Rarity) end
                if x.Level ~= y.Level then return self:_Compare(x.Level, y.Level) end
                if x.Cost ~= y.Cost then return self:_Compare(x.Cost,y.Cost) end
                if x.Polarity~=y.Polarity then return self:_Compare(y.Polarity, x.Polarity) end
                return self:_Compare(y.ModId, x.ModId)
            end,
            [3] = function(x,y)
                if type(x) ~= "table" and type(y) ~= "table" then
                    x = self:GetMod(x)
                    y = self:GetMod(y)
                end
                if x.Cost ~= y.Cost then return self:_Compare(x.Cost,y.Cost) end
                if x.Rarity ~= y.Rarity then return self:_Compare(x.Rarity,y.Rarity) end
                if x.Level ~= y.Level then return self:_Compare(x.Level, y.Level) end
                if x.Polarity~=y.Polarity then return self:_Compare(y.Polarity, x.Polarity) end
                return self:_Compare(y.ModId, x.ModId)
            end,
        }
    end
end

function M:_Compare(x, y)
    return CommonUtils:Compare(x,y,self.SortType)
end

function M:SetSortConf(SortBy, SortType)
    if SortType and SortType ~= self.SortType then
        self.SortType = SortType
    end
    if SortBy and SortBy ~= self.SortBy then
        self.SortBy = SortBy
    end
end

function M:SetSiftConf(SelectedItems, ItemDatas)
    self.SelectedSiftItems = SelectedItems
    self.SiftItemDatas = ItemDatas
end

function M:SortMods()
    table.sort(self.CurModList, self.ModSortFunc[self.SortBy])
    self.CurModToIndex = {}
    for i, ModUuid in ipairs(self.CurModList) do
        self.CurModToIndex[ModUuid] = i
    end
end

-- Mod高级筛选 判断 ModItem 是否符合 sift 筛选条件
function M:IsModMatchSift(ModItem)
    if table.isempty(self.SelectedSiftItems) then
        return true
    end
    local fieldMapping = {}
    local SubIds = DataMgr.SiftModel[ModCommon.ModSiftId].SubId -- 获取 SubId 列表
    for i, SiftId in ipairs(SubIds) do
        local SiftData = DataMgr.SiftDimens[SiftId] -- 获取对应的 SiftData
        fieldMapping[i] = SiftData.SelectionField[1] -- 按顺序存储 SelectionField
    end

    for i, SiftItem in pairs(self.SelectedSiftItems) do
        -- 获取对应的 ModItem 字段值
        local FieldName = fieldMapping[i]
        local modFieldValue = nil
        if FieldName == "FilterTag" then
            modFieldValue = ModItem.FilterTag
        else
            modFieldValue = ModItem[FieldName]
            if FieldName == "Level" and type(modFieldValue) == "number" and modFieldValue > 1 then
                modFieldValue = 1
            end
            if FieldName == "bAura" then
                local bAura = ModItem:IsAura()
                if bAura then
                    modFieldValue = 1
                else
                    modFieldValue = 0
                end
            end
            if type(modFieldValue) == "number" then
                modFieldValue = tostring(modFieldValue)
            end
        end
        if not modFieldValue then return false end
        
        -- 根据索引从 SiftItemDatas 中获取对应的筛选值
        local siftValues = {}
        for _, index in pairs(SiftItem) do
            local siftValue = self.SiftItemDatas[i].SelectionDatas[index]
            if siftValue then
                table.insert(siftValues, siftValue)
            end
        end

        -- 检查 modFieldValue 是否匹配当前筛选字段的任意一个值
        local matched = false
        if fieldMapping[i] == "FilterTag" then
            for _, tagValue in ipairs(modFieldValue) do
                for _, siftValue in ipairs(siftValues) do
                    if tagValue == siftValue then
                        matched = true
                        break
                    end
                end
                if matched then break end
            end
        else
            for _, siftValue in ipairs(siftValues) do
                if modFieldValue == siftValue then
                    matched = true
                    break
                end
            end
        end
        if not matched then return false end
    end
    return true
end

function M:DoModSearch(Mod, SearchText)
    if (string.isempty(SearchText)) then
        return true
    end
    if string.find(Mod:GetName(),SearchText) then
        return true
    end
    local ModConf = Mod:Data()
    if  ModConf.AddAttrs then
        for _, ModAttr in ipairs(ModConf.AddAttrs) do
            local AttrConfig = DataMgr.AttrConfig[ModAttr.AttrName]
            if AttrConfig and string.find(GText(AttrConfig.Name),SearchText) then
                return true
            end
        end
    end
    if (ModConf.PassiveEffectsDesc) then
        if string.find(GText(ModConf.PassiveEffectsDesc) ,SearchText) then
            return true
        end
    end
    if ModConf.FilterTag then
        for _,Tag in ipairs(ModConf.FilterTag) do
            if string.find(GText(Tag), SearchText) then
                return true
            end
        end
    end
    return false
end
--endregion

--region 极性编辑相关的数据处理
function M:StartPolarityEditMode()
    local SelectedStuff = self:GetSelectStuff()
    self.PolarityEditModeData = PolarityEditModePayload.New(self:GetCurrentSuitCost())
    if SelectedStuff and SelectedStuff:IsSlot() then
        self.PolarityEditModeData:SetSelectedStuff(SelectedStuff.SlotId)
    end
    ---@param SlotUIData ModSlotUIData
    for SlotId, SlotUIData in pairs(self.CurSlots) do
        SlotUIData:SetPolarityEditMode(true)
    end
end

function M:StopPolarityEditMode()
    self.PolarityEditModeData = nil
    ---@param SlotUIData ModSlotUIData
    for SlotId, SlotUIData in pairs(self.CurSlots) do
        SlotUIData:SetPolarityEditMode(false)
    end
end

function M:IsInPolarityEditMode()
    return self.PolarityEditModeData ~= nil
end
--endregion

--region 自动装配数据处理
function M:IsInAutoEquip()
    return self.AutoEquipData~=nil
end

function M:StartAutoEquip(CoroutineObj, ModSuitCopyInfo)
    self.AutoEquipData = AutoEquipPayload.New(CoroutineObj)
    self.ModListForAutoEquip = {}
    if not ModSuitCopyInfo then
        for ModUuid, _ in pairs(self.TargetMods) do
            local Mod = self:GetMod(ModUuid)
            if self:IsModMatchApplicationType(Mod) then
                table.insert(self.ModListForAutoEquip, Mod.Uuid)
            end
        end
    else
        for SlotId, SlotData in ipairs(ModSuitCopyInfo.ModsInfo) do
            local ModId = SlotData[2]
            local Mods = self:GetAvatar():GetModsByModId(ModId)
            for _, Mod in ipairs(Mods) do
                if self:IsModMatchApplicationType(Mod) then
                    table.insert(self.ModListForAutoEquip, Mod.Uuid)
                end
            end
        end
    end

    if not self.SortSlotForAutoEquip then
        self.SortSlotForAutoEquip = function(Id1, Id2)
            local Slot1 = self:GetSlotUIData(Id1)
            local Slot2 = self:GetSlotUIData(Id2)
            
            local polarity1 = Slot1:GetPolarity()
            local polarity2 = Slot2:GetPolarity()
            
            local bAuraSlot1 = (Id1 == ModCommon.MaxSlotCount)
            local bAuraSlot2 = (Id2 == ModCommon.MaxSlotCount)
            
            -- 优先处理光环槽位
            if bAuraSlot1 and not bAuraSlot2 then
                return true
            elseif not bAuraSlot1 and bAuraSlot2 then
                return false
            end
            
            -- 然后按极性排序
            if polarity1 ~= polarity2 then
                return polarity1 > polarity2
            end
            
            -- 最后按ID排序
            return Id1 < Id2
        end
    end
end

function M:StopAutoEquip()
    self.AutoEquipData = nil
    self.ModListForAutoEquip = nil
end

---@param SlotUIData ModSlotUIData
function M:PickSuitableModForSlot(SlotUIData, bAllSlotPolarized)
    --筛选特定极性的Mod列表
    local FilteredList = self:_FilterListOfPolarity(SlotUIData:GetPolarity(),false,SlotUIData)
    --先把冲突的Mod剔除，没有合适的Mod可以顺利流转到无极性列表的筛选过程
    local ModPendingList = {}
    for _, Mod in ipairs(FilteredList) do
        if Mod.ConflictUuids:Length()==0 then
            table.insert(ModPendingList, Mod)
        end
    end
    local bNeedOneMore = false
    ---对无极性的mod筛选
    if #ModPendingList == 0 then --没有极性合适的Mod就抓无极性的列表
       ModPendingList = self:_FilterListOfPolarity(CommonConst.NonePolarity, true,SlotUIData)
    else bNeedOneMore = true end
    --无极性列表也没有，在槽位没极性或者剩余槽位都是有极性（AllPolarized），才抓所有Mod
    if #ModPendingList == 0 and (SlotUIData:GetPolarity()==CommonConst.NonePolarity or bAllSlotPolarized) then
        ModPendingList = self:_FilterListOfPolarity(CommonConst.NonePolarity,false,SlotUIData)
    end
    --还抓不到Mod就直接返回算了
    if #ModPendingList == 0 then return 0 end

    -- 耐受值排序
    local TempSortType = self.SortType
    self.SortType = 2  --暂时调整为降序排列
    table.sort(ModPendingList, self.ModSortFunc[2])
    self.SortType = TempSortType

    local Mod = self:_PickSuitableModInPendingList(ModPendingList, SlotUIData)
    if Mod then return Mod end

    if bNeedOneMore then
        local OneMorePendingList = self:_FilterListOfPolarity(CommonConst.NonePolarity, true,SlotUIData)
        Mod = self:_PickSuitableModInPendingList(OneMorePendingList, SlotUIData)
        if Mod then return Mod end
    end

    return nil
end

function M:_FilterListOfPolarity(Polarity, bStrictMatch, SlotUIData)
    local ModPendingList = {}
    for _, ModUuid in ipairs(self.ModListForAutoEquip) do
        local Mod = self:GetMod(ModUuid)
        if self:IsModMatchPolarity(Mod, Polarity, bStrictMatch) then
            local IsAuraSlot = SlotUIData:IsAura()
            if (IsAuraSlot and Mod:IsAura()) or not IsAuraSlot then
                table.insert(ModPendingList, Mod)
            end
        end
    end
    return ModPendingList
end

function M:_PickSuitableModInPendingList(ModPendingList, SlotUIData)
    ---@param Mod Mod
    for _, Mod in ipairs(ModPendingList) do
        if Mod.ConflictUuids:Length()>0 then goto continue end
        if self.AutoEquipData:IsModEquiped(Mod.Uuid) then goto continue end
        if not self:IsSpecificSlot(Mod.Uuid, SlotUIData.SlotId) then goto continue end
        if self:IsBugMod(Mod.Uuid) then goto continue end
        local Case = ModCommon.CalcVolumeDiffCase.Change
        local Res,_ = self:CalcModVolumeDiff(Case, self:GetTarget(), SlotUIData.SlotId, Mod.Uuid)
        if Res then 
            self.AutoEquipData:SetEquipMod(Mod.Uuid)
            return Mod 
        end
        ::continue::
    end
    return nil
end
--endregion

--region 属性列表相关数据接口
function M:GetPureAttrsOfTarget(WeaponOwnerChar, Target)
    if not Target then Target = self:GetTarget() end
    local PureTargetAttrs = {}
    local ExtraInfo = {}
    if( WeaponOwnerChar)then
        ExtraInfo = {Char = WeaponOwnerChar} 
    end
    PureTargetAttrs = Target:DumpBattleAttr(self:GetAvatar(), ExtraInfo).TotalValues or {}
    return PureTargetAttrs
end

function M:GenerateAttrList(PreAttrs, NowAttrs, Index2AttrKey, bPinned, PureTargetAttrs,bModAdditionOnly,ExtraVolume)
    local Target = self:GetTarget()
    local DisplayAttrs = {}
    local Type = Target:GetTypeName()
    if Type == CommonConst.ArmoryTag.UWeapon then
        Type = CommonConst.DataType.Weapon
    end
    local Tag = (Type == "Char" and "Char") or (Target:HasTag("Melee") and "Melee") or "Ranged"
    local TargetId = Target[Type .. "Id"]

    --过滤出要显示的属性
    if(Type == CommonConst.DataType.Char)then
        for id, value in pairs(NowAttrs) do
            if CommonUtils:ShouldDisplayAttr(id, value, Type, Tag,TargetId) then
                table.insert(Index2AttrKey, id)
                DisplayAttrs[id] = value
            end
        end
        DisplayAttrs["ModVolume"] = PreAttrs["ModVolume"]
        if ExtraVolume then
            DisplayAttrs["ModVolume"] = DisplayAttrs["ModVolume"] + ExtraVolume
        end
    else
        ArmoryUtils:InsertWeaponTypeImpl(TargetId,NowAttrs)
        local WeaponTypeKey = "WeaponType"
        if(NowAttrs[WeaponTypeKey])then
            table.insert(Index2AttrKey, WeaponTypeKey)
            DisplayAttrs[WeaponTypeKey] = NowAttrs[WeaponTypeKey]
        end
        local WeaponAttrData = DataMgr.BattleWeaponAttr
        for id, Data in pairs(WeaponAttrData) do
            local value = NowAttrs[id] or PureTargetAttrs[id] 
            if next(PreAttrs) and not PreAttrs[id] then
                if value == NowAttrs[id] then
                    PreAttrs[id] = PureTargetAttrs[id] 
                else
                    PreAttrs[id] = value
                end
            end
            if CommonUtils:ShouldDisplayAttr(id, value,Type,Tag,TargetId) then
                table.insert(Index2AttrKey, id)
                DisplayAttrs[id] = value
            end
        end
    end
    NowAttrs = DisplayAttrs
   
    --计算仅Mod加成部分的数值
    if bModAdditionOnly then
        for key, value in pairs(PureTargetAttrs or {}) do
            if  type(value)=="number" then
                if NowAttrs[key] then
                    NowAttrs[key] = NowAttrs[key] - value
                end
                if PreAttrs[key] then
                    PreAttrs[key] = PreAttrs[key] - value
                end
            end
        end
    end
    
    --看看属性有没有diff
    local bDiff = false
    if not table.isempty(PreAttrs) then
        local TempAttr = CommonUtils.TableLength(NowAttrs)>CommonUtils.TableLength(PreAttrs) and NowAttrs or PreAttrs
        for key, value in pairs(TempAttr) do
            local IsValueChange = PreAttrs[key] ~= NowAttrs[key]
            local IsKeyAdded = not PreAttrs[key] and NowAttrs[key]
            local IsKeyRemoved = PreAttrs[key] and not NowAttrs[key]
            local IsShowAttr = CommonUtils:ShouldDisplayAttr(key, NowAttrs[key],Type,Tag,TargetId)
            if (IsValueChange or IsKeyAdded and IsShowAttr) or IsKeyRemoved then
                bDiff = true
                break
            end
        end
    end
    
    --排序属性列表
    if Type == "UWeapon" then Tag = "UWeapon" end
    local sortType = 'SortIndex'..ModCommon.AttrSortIndexes[Tag]
    table.sort(Index2AttrKey,function(x,y)
        local Res = DataMgr.AttrConfig[x][sortType] < DataMgr.AttrConfig[y][sortType]
        if bPinned then
            local bXValueChange = PreAttrs[x] ~= NowAttrs[x] or (not PreAttrs[x] and NowAttrs[x])
            local bYValueChange = PreAttrs[y] ~= NowAttrs[y] or (not PreAttrs[y] and NowAttrs[y])
            if bXValueChange ==  bYValueChange then
                return Res
            end
            if bXValueChange then return true end
            if bYValueChange then return false end
        end
        return Res
    end)
    return bDiff,PreAttrs, NowAttrs
end

function M:IsRecommendAttr(AttrKey)
    local Target = self:GetTarget()
    for _, Key in ipairs(Target:BattleData().RecommendAttr or {}) do
        if AttrKey == Key then return true end
    end
    return false
end
--endregion

--region Mod养成那边用到的公共数据方法
function M:GenerateEnhanceData()
    self.InvalidMods = {}
end

function M:CreateEnhanceInvalidMod(DummyUuid, ModId)
    local InvalidMod = Mod(DummyUuid, ModId, 0)
    InvalidMod.Count = 0
    self.InvalidMods[DummyUuid] = InvalidMod
    return InvalidMod
end

function M:DisposeEnhanceData()
    self.InvalidMods = nil
end

function M:_GenerateModUserOverCostMsg(TargetMod, PreviewLevel, User, Res)
    if not User then 
        DebugPrint(ErrorTag, LXYTag, "Mod的User不应该为空，Mod的反向引用Uuid列表有问题， Mod：",TargetMod:GetName())
        return
    end
    local ExtraVolume = TargetMod:CalcExtralCharVolume(TargetMod:ExpectCost(PreviewLevel))
    for i, ModSlots in ipairs(User.ModSuits or {}) do
        if i == User.ModSuitIndex and User.Uuid == self:GetTarget().Uuid then goto continue3 end
        local MaxCost = User:GetModVolume() + ExtraVolume
        local bOverflow = false
        local SlotIds = {}
        for SlotId, SlotData in ipairs(User.ModSuits[i]) do
            if SlotData.ModEid == TargetMod.Uuid then
                table.insert(SlotIds, SlotId)
            end
        end
        for _,SlotId in ipairs(SlotIds) do
            local SlotUIData = self:GetSlotUIData(SlotId)
            local SuitInfo = {GetModSuit=function() return ModSlots end}
            local ModInfo = {Polarity = TargetMod.Polarity, Cost = TargetMod:ExpectCost(PreviewLevel)}
            local RealModCost = self:CalcSlotRealCost(SlotUIData.SlotId, SuitInfo, ModInfo)
            local SrcModCost = self:CalcSlotRealCost(SlotUIData.SlotId, SuitInfo, TargetMod)
            local NewCost = self:CalcModSuitTotalCost(User, i) + RealModCost - SrcModCost + ExtraVolume
            if MaxCost < NewCost then
                bOverflow = true
                break
            end
        end
        if bOverflow then
            table.insert(Res, {User:GetName(), self:GetSuitName(i, User)})
        end
        ::continue3::
    end
end

function M:GetOtherModUserOverCostMsg(TargetMod, PreviewLevel)
    local Res = {}
    local VisitedUuid = {}
    if TargetMod:IsAura() then return Res end
    for _, UserUuid in pairs(TargetMod.CharUuids) do
        if not VisitedUuid[UserUuid] then
            local User = self:GetAvatar().Chars[UserUuid]
            self:_GenerateModUserOverCostMsg(TargetMod, PreviewLevel, User ,Res)
            VisitedUuid[UserUuid] = true
        end
    end
    for _, UserUuid in pairs(TargetMod.WeaponUuids) do
        if not VisitedUuid[UserUuid] then
            local User = self:GetAvatar().Weapons[UserUuid]
            User = User or self:GetAvatar().UWeapons[UserUuid]
            self:_GenerateModUserOverCostMsg(TargetMod, PreviewLevel, User ,Res)
            VisitedUuid[UserUuid] = true
        end
    end
    return Res
end

function M:UpdateModAttrListForIntensify(Attrs, ComparedAttrs, TargetMod,InPreviewLevel)
    local ModConf = TargetMod:Data()
    for _, Attr in pairs(ModConf.AddAttrs or {}) do
        local AttrConf=DataMgr.AttrConfig[Attr.AttrName]
        if not AttrConf then goto continue2 end
        local OldValue,OldValStr = ArmoryUtils:GenModAttrData(Attr, TargetMod.Level, AttrConf, ModConf.Id)
        table.insert(Attrs,{AttrName = GText(AttrConf.Name), AttrValue = OldValStr})
        local NewValue,NewValStr = ArmoryUtils:GenModAttrData(Attr, InPreviewLevel, AttrConf, ModConf.Id)
        local DiffValue = NewValue-OldValue
        if ComparedAttrs then
            table.insert(ComparedAttrs,{AttrValue=NewValStr, Delta=DiffValue})
        end
        ::continue2::
    end
end

function M:UpdateModCostPreviewForIntensify(Attrs,ComparedAttrs, TargetMod, InPreviewLevel)
    local bTakeOff = false
    local OldCost = TargetMod.Cost
    local ExtraCostVolume = TargetMod:CalcExtralCharVolume()
    table.insert(Attrs, {AttrName = GText("UI_Select_Cost"), AttrValue = OldCost})
    if TargetMod.AddCharModCost then
        table.insert(Attrs, {AttrName= GText("UI_Mod_CostIncrease"), AttrValue="+"..ExtraCostVolume})
    end
    if ComparedAttrs then
        local NewCost = TargetMod:ExpectCost(InPreviewLevel)
        local DiffCost = NewCost-OldCost
        table.insert(ComparedAttrs,{AttrValue=NewCost, Delta=DiffCost, 
            CalcColorType = function(Delta)
                return Delta< 0 and "Positive" or "Nagative"
            end})
        if TargetMod.AddCharModCost then
            local NewExtraCostVolume = TargetMod:CalcExtralCharVolume(NewCost)
            local DiffExtraCostVolume = NewExtraCostVolume-ExtraCostVolume
            table.insert(ComparedAttrs,{AttrValue="+"..NewExtraCostVolume, Delta=DiffExtraCostVolume})
        end
        local SelectedStuff = self:GetSelectStuff()
        if not SelectedStuff or not SelectedStuff:IsSlot() then return end
        local SlotId = SelectedStuff.SlotId
        local SlotUIData = self:GetSlotUIData(SlotId)
        OldCost = SlotUIData.UICost
        local FakeMod = {Polarity = TargetMod.Polarity, Cost=NewCost}
        NewCost = self:CalcSlotRealCost(SlotId, self:GetTarget(),FakeMod)
        DiffCost = NewCost- OldCost
        local RestCost = self:GetTargetMaxCost()+ExtraCostVolume-self:GetCurrentSuitCost()
        if DiffCost > RestCost then
            bTakeOff = true
        else
            bTakeOff = false
        end
    end
    return bTakeOff
end
-- endregion

-- region 手柄相关
-- 因为手柄模式下，Mod选中和删除会有特殊逻辑，所以需要单独设置，单独管理一下
function M:SetGamePadSelectedStuff(ModUuid, SlotId)
    if not ModUuid and not SlotId then
        self.GamePadSelectedStuff = nil
        return
    end
    self.GamePadSelectedStuff = SelectedStuff.New()
    self.GamePadSelectedStuff.ModUuid = ModUuid
    self.GamePadSelectedStuff.SlotId = SlotId
end

function M:GetGamePadSelectedStuff()
    return self.GamePadSelectedStuff
end
-- endregion

-- region 引导补丁
function M:FetchRunningGuide()
    self.bRunningGuide = CommonUtils:IfExistSystemGuideUI()
end

function M:GetOnceRunningGuide()
    local bRunning = self.bRunningGuide
    self.bRunningGuide = false
    return bRunning
end
-- endregion

-- region 蓝色、紫色 Mod转化
function M:GetConvertMods(CurConvertPoolId)
    -- 显示mod
    local ShowMods = {}
    -- --用于显示数量
    -- local ModMap = {}
    local Mods = self:GetAvatar().Mods

    for _, Mod in pairs(Mods) do
        local ConvertPoolId, ConvertWeight = Mod:GetConvert()
        if ConvertPoolId then
            if ConvertPoolId == CurConvertPoolId or CurConvertPoolId == nil then
                -- local IsContain = false
                -- if Mod.Level == 0 then
                --     for _, ShowMod in pairs(ShowMods) do
                --         if ShowMod.ModId == Mod.ModId and ShowMod.Level == 0 then
                --             IsContain = true
                --         end
                --     end
                -- end
                -- if not IsContain then
                table.insert(ShowMods, Mod)
                -- end
            end
        end
    end
    return ShowMods
end
-- endregion

-- region 装备魔之楔推荐
--左侧tab切换的时候需要清除数据
function M:ClearRecommendData()
    self:SetRecommendModIdList({})
end

---@param state true|false
function M:SetRecommendView(state)
    self.RecommendViewState = state
end

function M:IsRecommendView()
    return self.RecommendViewState
end

function M:IsRecommendModState()
    return self.CurRecommendModIdList and #self.CurRecommendModIdList > 0
end

---@param ModIdList 已经排序：从左往右推荐率递减
function M:SetRecommendModIdList(ModIdList)
    local OwnedMods = self:GetAvatar().Mods
    self.CurRecommendModIdList = ModIdList
end

function M:GetRecommendModUuidList()
    local OwnedMods = self:GetAvatar().Mods
    local CurRecommendModUuidList = {}

    if self.CurRecommendModIdList then
        -- 同一ModId：未养成Mod和多个已养成Mod
        for _, ModId in pairs(self.CurRecommendModIdList) do
            for _, Mod in pairs(OwnedMods) do
                if Mod.ModId == ModId then
                    table.insert(CurRecommendModUuidList, Mod.Uuid)
                end
            end
        end
    end

    return CurRecommendModUuidList
end

function M:FliterRecommendMod(CurModId)
    if self.CurRecommendModIdList then
        for _, ModId in pairs(self.CurRecommendModIdList) do
            if ModId == CurModId then
                return true
            end
        end
        return false
    end

    return true
end
--endregion 

function M:GetModFullNameByConf(ModId)
    local ModInfo = DataMgr.Mod[ModId]
    if CommonConst.SystemLanguage == CommonConst.SystemLanguages.FR then
        return string.format("%s %s",GText(ModInfo.Name),GText(ModInfo.TypeName))
    end
    return GText(ModInfo.TypeName)..GText(ModInfo.Name)
end

AssembleComponents(M)
return M