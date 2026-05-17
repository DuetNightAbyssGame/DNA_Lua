local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties


local Mount = Class("Mount", CustomTypes.CustomAttr)
    Mount.__Props__ = {
        MountId = prop.prop("Int", "client save"),
        BattleMountId = prop.getter("Data", "BattleMountId"),
        MountRarity = prop.getter("Data", "MountRarity"),
        ResourceId = prop.getter("Data", "ResourceId"),
        -- 装扮过的皮肤
		UsedSkins = prop.prop("Appearance.SkinDict", "client save"),
        -- 当前外观
		CurrentAppearanceIndex = prop.prop("Int", "client save", 1),
		-- 外观配置
		AppearanceSuits = prop.prop("Appearance.AppearanceList", "client save"),
    }
    function Mount:Init(MountId)
        self.MountId = MountId
        self:InitAppearance()
    end

    function Mount:InitAppearance()
        self.AppearanceSuits:AddMountAppearance(self.MountId)
        -- 初始化皮肤列表
		self.UsedSkins:GetNewSkin(self.MountId, CommonConst.SkinType.Mount)
    end

    function Mount:GetAppearance()
        return self.AppearanceSuits[self.CurrentAppearanceIndex]
    end

    function Mount:AddSkin(SkinId)
		return self.UsedSkins:GetNewSkin(SkinId, CommonConst.SkinType.Mount)
	end

	function Mount:GetSkin(SkinId)
		return self.UsedSkins:GetSkin(SkinId)
	end

    function Mount:Data()
        return DataMgr.Mount[self.MountId]
    end

    FormatProperties(Mount)
local MountShareData = Class("MountShareData", CustomTypes.CustomAttr)
    MountShareData.__Props__ = {
        LevelId = prop.prop("Int", "client save"),
        State = prop.prop("Int", "client save"),
        PretextBreakLevel = prop.getter("Data", "PretextBreakLevel"),
    }
    function MountShareData:Data()
        return DataMgr.MountLevel[self.LevelId]
    end

    FormatProperties(MountShareData)


local MountShareDataDict = Class("MountShareDataDict", CustomTypes.CustomDict)
    MountShareDataDict.KeyType = BaseTypes.Int
    MountShareDataDict.ValueType = MountShareData

    function MountShareDataDict:NewMountShareData(LevelId)
        return MountShareData(LevelId)
    end

    function MountShareDataDict:GetMountShareData(LevelId)
        return self[LevelId]
    end

    function MountShareDataDict:GetNewMountShareData(LevelId)
        if not self[LevelId] then
            self[LevelId] = self:NewMountShareData(LevelId)
        end
        return self[LevelId]
    end

local MountDict = Class("MountDict", CustomTypes.CustomDict)
    MountDict.KeyType = BaseTypes.Int
    MountDict.ValueType = Mount

    function MountDict:NewMount(MountId)
        return Mount(MountId)
    end
    function MountDict:GetMount(MountId)
        return self[MountId]
    end

    function MountDict:GetNewMount(MountId)
        if not self[MountId] then
            self[MountId] = self:NewMount(MountId)
        end
        return self[MountId]
    end

return {
    MountShareDataDict = MountShareDataDict,
    MountDict = MountDict,
    MountShareData = MountShareData,
    Mount = Mount,
}