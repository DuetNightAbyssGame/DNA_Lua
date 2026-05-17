local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties



---@class Resource
local Resource = Class("Resource", CustomTypes.CustomAttr)
	Resource.__Props__ = {
		-- 物品id
		ResourceId = prop.prop("Int", "client save"),
		-- 数量
		Count = prop.prop("Int", "client save"),
		-- 状态
		Status = prop.prop("Int", "client save", 0),  -- 0:解锁，1:锁定
		-- 魅影装备的武器
		WeaponUuid = prop.prop("ObjId", "client save"),
		-- 与坐骑进行绑定
		MountId = prop.prop("Int", "client save"),
		-- 资源名
		ResourceName = prop.getter("Data", "ResourceName"),
		-- 类型
		Type = prop.getter("Data", "Type"),
		-- 子类型
		ResourceSType = prop.getter("Data", "ResourceSType"),
		-- 稀有度
		Rarity = prop.getter("Data", "Rarity"),
		-- 使用效果
		UseEffectType = prop.getter("Data", "UseEffectType"),
		-- 使用参数
		UseParam = prop.getter("Data","UseParam"),
		-- 描述
		Description = prop.getter("Data", "Description"),
		-- 图标
		Icon = prop.getter("Data", "Icon"),
		-- 背包分类
		MaterialClassify = prop.getter("Data", "MaterialClassify"),
		-- 售卖获得货币类型
		ResourceToCoinType = prop.getter("Data", "ResourceToCoinType"),
		-- 物品售价
		ResourceValue = prop.getter("Data", "ResourceValue"),
		-- 战斗道具携带数量限制
		BattleItemLimit = prop.getter("Data", "BattleItemLimit"),
		-- 是否创建区域战斗机关
		CreateMechanism = prop.getter("Data", "CreateMechanism"),
		
	}

	function Resource:Init(ResourceId)
		if not ResourceId then
			return
		end
		self.ResourceId = ResourceId
	end


	function Resource:IsValid()
		return self.Count > 0
	end

	function Resource:Data()
		return DataMgr.Resource[self.ResourceId]
	end

	function Resource:IsBattleItem()
		return self.Type == "BattleItem"
	end

	function Resource:IsInfiniteBattleItem()
		return self.Type == "InfiniteBattleItem"
	end
	
	function Resource:SubTypeIsGestureItem()
		if not self.ResourceSType then return false end
		return self.ResourceSType == "GestureItem"
	end

	function Resource:IsPhantomItem()
		return self.ResourceSType == "PhantomItem"
	end

	function Resource:IsMountItem()
		return self.ResourceSType == "MountItem"
	end

	function Resource:AddCount(count)
		if type(count) == "number" and count > 0 then
			if self:IsInfiniteBattleItem() then
				self.Count = 1
			else
				self.Count = self.Count + count
			end
			return true
		end
		return false
	end

	function Resource:ReduceCount(count)
		if type(count) == "number" and count > 0 then
			if self:IsInfiniteBattleItem() then
				self.Count = 1
			else
				self.Count = self.Count - count
			end
			return true
		end
		return false
	end

	function Resource:IsLock()
		return self.Status == CommonConst.CommonStatus.Lock
	end

	function Resource:Lock()
		if not self:IsLock() then
			self.Status = CommonConst.CommonStatus.Lock
			return true
		end
		return false
	end

	function Resource:UnLock()
		if self:IsLock() then
			self.Status = CommonConst.CommonStatus.UnLock
			return true
		end
		return false
	end

	function Resource:GetStatus()
		return self.Status
	end

	FormatProperties(Resource)

---@class ResourceDict
local ResourceDict = Class("ResourceDict", CustomTypes.CustomDict)
	ResourceDict.KeyType = BaseTypes.Int
	ResourceDict.ValueType = Resource

	---@return Resource
	function ResourceDict:NewResource(ResourceId)
		return Resource(ResourceId)
	end

	---@return Resource
	function ResourceDict:GetResource(ResourceId)
		if self[ResourceId] == nil then
			self[ResourceId] = self:NewResource(ResourceId)
		end
		return self[ResourceId]
	end

	---@return number
	function ResourceDict:QueryResourceCount(ResourceId)
		if self[ResourceId] == nil then
			return 0
		end
		return self[ResourceId].Count
	end

	function ResourceDict:ClearResource(ResourceId)
		self[ResourceId] = nil
	end

return {Resource = Resource, ResourceDict = ResourceDict}
