
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"

---仅包含本地缓存数据
---@class CharModel
local M = Class()

local _CardLevelResourceToUuids = {}
local _CardLevelResourceToCharIds = {}
local _UuidToCardLevelResourceId = {}
local _SkinIdToCharId = {}
local _HairIdToCharId = {}
local _CharAccessoryMap = {}
local _CharReward = {CharBreak = {}}
local _CharIdToUuid = {}
local _UuidToCharId = {}
local _DefaultAccessories = ArmoryUtils:GetDefaultCharAccessoryIds()

local MappingChar = function(Char)
    if(Char == nil)then return end
    _CharIdToUuid[Char.CharId] = Char.Uuid
    _UuidToCharId[Char.Uuid] = Char.CharId
	local CardLevelUpData = DataMgr.CharCardLevelUp[Char.CharId]
	local Rid = CardLevelUpData and CardLevelUpData[0] and CardLevelUpData[0].ResourceId1
	if(Rid)then
		_CardLevelResourceToUuids[Rid] = _CardLevelResourceToUuids[Rid] or {}
        _CardLevelResourceToUuids[Rid][Char.Uuid] = true
        _UuidToCardLevelResourceId[Char.Uuid] = Rid
		return true
	end
end

local MappingCardLevelResource2CharIds = function()
    _CardLevelResourceToCharIds = {}
    for CharId, value in pairs(DataMgr.CharCardLevelUp) do
        local Rid = value[0] and value[0].ResourceId1
        if(Rid)then
            _CardLevelResourceToCharIds[Rid] = _CardLevelResourceToCharIds[Rid] or {}
            _CardLevelResourceToCharIds[Rid][CharId] = true
        end
    end
end

local MappingSkin = function(CommonChar)
    if(CommonChar == nil)then return end
    local CharId = CommonChar.CharId
    for SkinId, Skin in pairs(CommonChar.OwnedSkins or {}) do
        _SkinIdToCharId[SkinId] = CharId
    end
end

local MappingHair = function(CommonChar)
    if(CommonChar == nil)then return end
    local CharId = CommonChar.CharId
    for HairId, Hair in pairs(CommonChar.OwnedHairs or {}) do
        _HairIdToCharId[HairId] = CharId
    end
end

local MappingReward = function(Avatar)
    local Strings
    local CharId
    for Keys, _ in pairs(Avatar.StoredCollectReward or {}) do
        Strings = string.split(Keys, ".")
        if(_CharReward[Strings[1]] and Strings[2] and Strings[3])then
            CharId = tonumber(Strings[2])
            if(DataMgr.Char[CharId])then
                _CharReward[Strings[1]][CharId] = _CharReward[Strings[1]][CharId] or {}
                _CharReward[Strings[1]][CharId][Strings[3]] = true
            end
        end
    end
end

function M:GetCharIdBySkinId(SkinId)
    return _SkinIdToCharId[SkinId]
end

function M:GetCharIdByHairId(HairId)
    return _HairIdToCharId[HairId]
end

function M:GetUuidsByCardLevelResource(ResourceId)
    return _CardLevelResourceToUuids[ResourceId]
end

function M:GetUuidByCharId(CharId)
    return _CharIdToUuid[CharId]
end

function M:GetCharIdsByCardLevelResource(ResourceId)
    return _CardLevelResourceToCharIds[ResourceId]
end

function M:IsCharHasReward(CharId)
    local CharBreak = _CharReward.CharBreak[CharId]
    if(CharBreak and next(CharBreak))then
        return true
    end
    return false
end

function M:GetCharRewardInfo()
    return _CharReward
end

function M:Init(Avatar)
    _UuidToCardLevelResourceId = {}
    _CardLevelResourceToUuids = {}
    _SkinIdToCharId = {}
    _HairIdToCharId = {}
    _CharAccessoryMap = {}
    _CharReward = {CharBreak = {}}
    _CharIdToUuid = {}
    _UuidToCharId = {}
    if(not Avatar)then return end
    if(Avatar.Chars)then
        for Uuid, Char in pairs(Avatar.Chars) do
            MappingChar(Char)
            MappingSkin(Avatar.CommonChars[Char.CharId])
            MappingHair(Avatar.CommonChars[Char.CharId])
        end
    end
    MappingCardLevelResource2CharIds()
    if(Avatar.CharAccessorys)then
        for _, AccessoryId in pairs(Avatar.CharAccessorys) do
            _CharAccessoryMap[AccessoryId] = true
        end
    end
    MappingReward(Avatar)
    EventManager:AddEvent(EventID.OnCharCardLevelResourcesChanged, self, self.OnCharCardLevelResourcesChanged)
    EventManager:AddEvent(EventID.OnCharDeleted, self, self.OnCharDeleted)
    EventManager:AddEvent(EventID.OnCharExtraGradeItemClick, self, self.OnCharExtraGradeItemClick)
    try({
        exec = function()
            ArmoryUtils:CreateReddotInfos(CommonConst.DataType.Char)
            ArmoryUtils:CreateReddotInfos(CommonConst.DataType.Char..ArmoryUtils.ArmorySubTabNames.Appearance)
            ArmoryUtils:CreateReddotInfos(CommonConst.DataType.Char..Const.Skill)
            ArmoryUtils:CreateReddotInfos(ArmoryUtils.FilesTabType[1])
            ArmoryUtils:CreateReddotInfos(ArmoryUtils.FilesTabType[2])
        end,
        catch = function (err)
            local trace = debug.traceback()
            err = err or ""
            DebugPrint("Error: 角色红点数据创建失败！".."\n"..trace)
        end,
    })
    self.Inited = true
end

function M:GetCardLevelResourceByUuid(Uuid)
    return _UuidToCardLevelResourceId[Uuid]
end

---同卡素材数量改变时
function M:OnCharCardLevelResourcesChanged(ResourceId,CharId,CharUuid)
    local Avatar = GWorld:GetAvatar()
    local Char = Avatar.Chars[CharUuid]
    if(Char)then
        local IsNew = ArmoryUtils:TryAddNewUltraGradeCharReddot(Char)
        ArmoryUtils:SetItemReddotRead({ItemType = CommonConst.DataType.Char,Uuid = CharUuid, IsNew = IsNew},false,true)
        ArmoryUtils:TryAddNewCharReddot(Char, CommonUtils.ObjId2Str(CharUuid))
    else
        ArmoryUtils:_SetReddotReadCommon(CharId, DataMgr.ReddotNode.UnlockableChar.Name,true)
        ArmoryUtils:TryAddUnlockableCharReddot(CharId)
    end
end

---新增Ultra命座点击时
function M:OnCharExtraGradeItemClick(CharUuid)
    local Avatar = GWorld:GetAvatar()
    local Char = Avatar.Chars[CharUuid]
    if(Char)then
        ArmoryUtils:SetItemReddotRead({ItemType = CommonConst.DataType.Char,Uuid = CharUuid,IsNew = false},false,true)
    end
end

---新增角色时
function M:OnNewCharObtained(CharUuid)
    if(not self.Inited)then return end
    local Avatar = GWorld:GetAvatar()
    local Char = Avatar.Chars[CharUuid]
    if(Char)then
        MappingChar(Char)
        ArmoryUtils:_SetReddotReadCommon(Char.CharId,DataMgr.ReddotNode.UnlockableChar.Name,true)
        ArmoryUtils:TryAddNewCharReddot(Char, CommonUtils.ObjId2Str(CharUuid))
    end
end

---删除角色时
function M:OnCharDeleted(CharUuid)
    if(not self.Inited)then return end
    local CharId = _UuidToCharId[CharUuid]
    local CardLevelResourceId = _UuidToCardLevelResourceId[CharUuid]
    if(CharId)then
        ArmoryUtils:_SetReddotReadCommon(CharId,DataMgr.ReddotNode.UnlockableChar.Name,true)
    end
    _UuidToCharId[CharUuid] = nil
    _CharIdToUuid[CharId] = nil
    _UuidToCardLevelResourceId[CharUuid] = nil
    if(_CardLevelResourceToUuids[CardLevelResourceId])then
        for Uuid, _ in pairs(_CardLevelResourceToUuids[CardLevelResourceId]) do
            if(Uuid == CharUuid)then
                _CardLevelResourceToUuids[CardLevelResourceId][Uuid] = nil
                break
            end
        end
    end
    ArmoryUtils:SetItemReddotRead({ItemType = CommonConst.DataType.Char,Uuid = CharUuid,UnitId = CharId},true,true,true)
end

---新获得角色皮肤时
function M:OnNewCharSkinObtained(SkinId,CharId)
    if(not self.Inited)then return end
    _SkinIdToCharId[SkinId] = CharId
    if(not CommonUtils.IsCurrentVersionRealease(CommonConst.DataType.Skin,SkinId))then
        return
    end
    if(SkinId ~= CharId)then
        ArmoryUtils:TryAddNewCharSkinReddot(SkinId,CharId)
    end
end

---新获得发型时
function M:OnNewCharHairObtained(HairId,CharId)
    if(not self.Inited)then return end
    _HairIdToCharId[HairId] = CharId
    if(not CommonUtils.IsCurrentVersionRealease(CommonConst.DataType.Hair,HairId))then
        return
    end
    if(HairId ~= CharId)then
        ArmoryUtils:TryAddNewCharHairReddot(HairId,CharId)
    end
end

---新获得角色配饰时
function M:OnNewCharAccessoryObtained(AccessoryId)
    if(not self.Inited)then return end
    _CharAccessoryMap[AccessoryId] = true
    local CharAccessoryData = DataMgr.CharAccessory[AccessoryId]
    if not CharAccessoryData or _DefaultAccessories[CharAccessoryData.AccessoryType] == AccessoryId then
        return
    end
    if(not CommonUtils.IsCurrentVersionRealease(CommonConst.DataType.CharAccessory,AccessoryId))then
        return
    end
    if(CharAccessoryData.Skin)then
        for _, SkinId in pairs(CharAccessoryData.Skin) do
            ArmoryUtils:TryAddNewCharAccessoryReddot(AccessoryId, SkinId)
        end
    else
        ArmoryUtils:TryAddNewCharAccessoryReddot(AccessoryId)
    end
end

---奖励列表变更时检查红点
function M:OnPropChangeStoredCollectReward(Strings)
    if(not self.Inited)then return end
    if(_CharReward[Strings[1]] and Strings[2] and Strings[3])then
        local CharId = tonumber(Strings[2])
        if(not DataMgr.Char[CharId])then
            return
        end
        _CharReward[Strings[1]][CharId] = _CharReward[Strings[1]][CharId] or {}
        local Reward = _CharReward[Strings[1]][CharId]
        if(Reward[Strings[3]])then
            Reward[Strings[3]] = nil
            if(next(Reward) == nil)then
                ArmoryUtils:_SetReddotReadCommon(CharId, DataMgr.ReddotNode.CharReward.Name,true)
            end
        else
            Reward[Strings[3]] = true
            ArmoryUtils:TryAddCharRewardReddot(CharId)
        end
        EventManager:FireEvent(EventID.OnCharRewardStateChanged, CharId)
    end
end

function M:IsCharAccessoryExist(AccessoryId)
    return not not _CharAccessoryMap[AccessoryId]
end

function M:Destory()
    self.Inited = false
    _CardLevelResourceToUuids = {}
    _CardLevelResourceToCharIds = {}
    _UuidToCardLevelResourceId = {}
    _SkinIdToCharId = {}
    _HairIdToCharId = {}
    _CharAccessoryMap = {}
    _CharReward = {CharBreak = {}}
    _CharIdToUuid = {}
    _UuidToCharId = {}

    EventManager:RemoveEvent(EventID.OnCharCardLevelResourcesChanged, self)
    EventManager:RemoveEvent(EventID.OnCharDeleted, self)

end


return M