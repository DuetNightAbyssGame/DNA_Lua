local Component = {}
local TimeUtils = require "Utils.TimeUtils"

--检测商品是否能被购买
--不可购买情况：
--商品不存在；
--商品已下架；
--商品购买次数已达上限,不能被购买；
--所购买的商品数量大于商品剩余购买次数；
--已购买互斥商品；
--未购买完前置商品；
--唯一持有商品已拥有；
--解锁条件不满足；

---是否存在前置商品可购买
function Component:CheckShopItemHasRequire(ShopItemId)
	local Require = DataMgr.ShopItem[ShopItemId].Require
    if Require then
        local RequireItem = self.ShopItems[Require]
        if RequireItem then
            if RequireItem:IsCanBeChased() then
		        return true
            end
        else
            return true
        end
    end
	return false
end

---是否存在互斥商品可购买
function Component:CheckShopItemHasRexclusionGroup(ShopItemId)
	local RexclusionGroup = DataMgr.ShopItem[ShopItemId].RexclusionGroup
    if RexclusionGroup then
        for index,RexclusionGroupId in pairs(RexclusionGroup) do
            local ExclusionItemList = DataMgr.RexclusionGroup2ShopItem[RexclusionGroupId]
            for index,ExclusionItemId in pairs(ExclusionItemList) do
                local ExclusionItem = self.ShopItems[ExclusionItemId]
                if ExclusionItemId ~= ShopItemId and  ExclusionItem and ExclusionItem.AlreadyPurchaseTimes > 0 then
                    return true
                end
            end
        end
    end
	return false
end

---是否已持有该唯一商品
function Component:CheckShopItemUnique(ShopItemId)
	local ItemType = DataMgr.ShopItem[ShopItemId].ItemType
    local ItemId = DataMgr.ShopItem[ShopItemId].TypeId
	if ItemType ~= "Reward" then
		local TypeInfo = DataMgr.RewardType[ItemType]
		if not TypeInfo then return false end
		if TypeInfo.UniqueType then
			local CheckFuncName = "Check"..ItemType.."Enough"
			local CheckMethod = self[CheckFuncName]
			if not CheckMethod then return true end
			if CheckMethod(self,{[ItemId] = 1}) then return true end
		end
	end
	return false
end

---商品是否处于上架期间
function Component:CheckIsEffective(ShopItemId)
	local ShopItemData = DataMgr.ShopItem[ShopItemId]
    local CurTime = TimeUtils.NowTime()
	local StartTime = ShopItemData.StartTime
	local EndTime = ShopItemData.EndTime
	if StartTime and StartTime <= CurTime then
		if EndTime and EndTime <= CurTime then
			return false
		end
		return true
	end
    return false
end

---获取商品已购买次数
function Component:GetShopItemAlreadyPurchaseTimes(ShopItemId)
	if not ShopItemId then
		return 0
	end
    local ShopItem = self.ShopItems[ShopItemId]
	if ShopItem then
		return ShopItem.AlreadyPurchaseTimes
	end
	return 0
end

---商品是否存在首次购买奖励
function Component:CheckIsFirstBonus(ShopItemId)
	if not DataMgr.FirstBonusNum[ShopItemId] then
		return false
	end
	if self:GetShopItemAlreadyPurchaseTimes(ShopItemId) > 0 then
		return false
	end
	return true
end

---商品解锁所需战斗积分是否充足,true-充足，false-不足
function Component:CheckShopItemUnlockRaidPoint(ShopItemId)
	if not ShopItemId then
		return false
	end
    local ShopItemData = DataMgr.ShopItem[ShopItemId]
	if ShopItemData.UnlockRaidPoint then
        local MaxRaidScore = AvatarUtils:GetRaidSeasonMaxScore(self) or 0
        if ShopItemData.UnlockRaidPoint > MaxRaidScore then
            return false
        end
    end
	return true
end

---商品解锁所需条件是否满足,true-满足，false-不满足
function Component:CheckShopItemCondition(ShopItemId)
	if not ShopItemId then
		return false
	end
    local ShopItemData = DataMgr.ShopItem[ShopItemId]
	if ShopItemData.ItemCondition and (not self:CheckCondition(ShopItemData.ItemCondition)) then
        return false
    end
	return true
end

---检查商品是否可购买
function Component:CheckShopItemCanPurchase(ShopItemId,Count)
	local ShopItem = self.ShopItems[ShopItemId]
	local ShopItemData = DataMgr.ShopItem[ShopItemId]
	local ShopItemCount = Count or 1
	if not ShopItemData then return false end
	if ShopItemData.UnlockLevel and ShopItemData.UnlockLevel > self.Level then
		return false
	end
	if not self:CheckShopItemUnlockRaidPoint(ShopItemId) then
        return false
    end
	if not self:CheckIsEffective(ShopItemId) then
		return false
	end
	if not self:CheckShopItemCondition(ShopItemId) then
		return false
	end

	if self:CheckShopItemHasRequire(ShopItemId) then
		return false
	end

	if self:CheckShopItemHasRexclusionGroup(ShopItemId) then
		return false
	end

	if self:CheckShopItemUnique(ShopItemId) then
		return false
	end

	if ShopItem then
		if not ShopItem:IsCanBeChased() then
			return false
		end
		if ShopItem:IsPurchaseLimit() and ShopItemCount > ShopItem.RemainPurchaseTimes then
			return false
		end
	end
	return true
end

--购买商品 NotShow为true的时候不显示获得物品弹窗，默认显示
--VoucherId为抵扣券id，如果为-1，则不使用代币购买
function Component:PurchaseShopItem(ShopItemId,Count,NotShow, PurchaseCallback,VoucherId)
	if DataMgr.ShopItem2PayGoods[ShopItemId] then
		self.logger.info("PurchaseShopItem is Paygood", ShopItemId,Count)
		local ShopMain = UIManager(GWorld.GameInstance):GetUIObj("ShopMain")
        if ShopMain then
            ShopMain:BlockAllUIInput(false)
        end

		local CommonShopActivity = UIManager(GWorld.GameInstance):GetUIObj("ShopActivity")
        if CommonShopActivity then
            CommonShopActivity:BlockAllUIInput(false)
        end
		return
	end
	VoucherId = VoucherId or -1
    self.logger.info("PurchaseShopItem", ShopItemId,Count,VoucherId)

	---免费商品红点
	local bFreeBefore = nil
	local ReddotNodeName = nil
	local ItemConf = DataMgr.ShopItem[ShopItemId]
	if ItemConf and ItemConf.SubTabId then
		ReddotNodeName = DataMgr.ShopTabSub[ItemConf.SubTabId].ReddotNode
		if ReddotNodeName then
			bFreeBefore = ShopUtils:IsFree(ShopItemId)
		end
	end

	local function Callback(Ret,PackRewards)
		EventManager:FireEvent(EventID.OnPurchaseShopItem, Ret, ShopItemId,Count)
		local ShopMain = UIManager(GWorld.GameInstance):GetUIObj("ShopMain")
        if ShopMain then
            ShopMain:BlockAllUIInput(false)
        end
		
		local CommonShopActivity = UIManager(GWorld.GameInstance):GetUIObj("ShopActivity")
		if CommonShopActivity then
			CommonShopActivity:BlockAllUIInput(false)
		end
		
		local SkinPreview = UIManager(GWorld.GameInstance):GetUIObj("SkinPreview")
		if SkinPreview then
			SkinPreview:BlockAllUIInput(false)
		end
		self.logger.info("PurchaseShopItem callback", Ret, ShopItemId,Count,PackRewards)

		if ShopMain then
			ShopMain.NotNeedPlayEntryAnimation = true
			ShopMain:RefreshSubTabData(ShopMain.CurSubTabMap, true, true)
		end
		if CommonShopActivity then
			CommonShopActivity:RefreshSubTabData(CommonShopActivity.CurSubTabMap, true, true)
		end
		local ActivityShop = UIManager(GWorld.GameInstance):GetUIObj("ActivityShop")
		if ActivityShop then
			ActivityShop:UpdateShopDetail(ActivityShop.CurSubTabMap)
		end
		if SkinPreview then
			SkinPreview:RefreshPurchaseState()
		end
		if Ret == ErrorCode.RET_SUCCESS then
			local ShopItemData = DataMgr.ShopItem[ShopItemId]
			if not NotShow then
				UIManager(GWorld.GameInstance):UnLoadUI("ShopItemSingle")
				UIManager(GWorld.GameInstance):UnLoadUI("ShopItemPackage")
				UIUtils.ShowGetItemPageAndOpenBagIfNeeded(ShopItemData.ItemType, ShopItemData.TypeId, ShopItemData.TypeNum*Count, PackRewards, ShopItemData.IsSpPopup, nil, nil)
			end
			EventManager:FireEvent(EventID.OnPurchaseShopItemSuccess, Ret, ShopItemData.TypeId, Count, PackRewards)
		else
			UIManager(GWorld.GameInstance):ShowError(Ret,1.0,"CommonToastMain")
		end

		---免费商品红点
		if ReddotNodeName then
			local bFree = ShopUtils:IsFree(ShopItemId)
			if bFree == false and bFreeBefore == true then
				ReddotManager.DecreaseLeafNodeCount(ReddotNodeName, 1, {ShopItemId = ShopItemId})
			end
		end

		if PurchaseCallback then
			PurchaseCallback(Ret)
		end
	end
	self:CallServer("PurchaseShopItem", Callback, ShopItemId,Count,VoucherId)
end

--商城刷新
function Component:OnRefreshShop(ServerTime)
	self.logger.info("--OnRefreshShop--",TimeUtils.TimeToStr(ServerTime))
	local TimeOffset = ServerTime - TimeUtils.NowTime()
	if TimeOffset>0 then
		TimeUtils.SetTimeOffset(TimeOffset)
	end
	---@type Shop_Main_PC_C
	local ShopMain = UIManager(GWorld.GameInstance):GetUIObj("ShopMain")
	if ShopMain then
		ShopMain:RefreshSubTabData(ShopMain.CurSubTabMap, true, true)
	end
	for SubTabId, ShopTabConf in pairs(DataMgr.ShopTabSub) do
		local NodeName = ShopTabConf.ReddotNode
		if NodeName then
			local Node = ReddotManager.GetTreeNode(NodeName)
			if Node and Node.RefreshCacheDetail then
				local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(NodeName)
				local DeltaCount = Node:RefreshCacheDetail({Detail=CacheDetail})
				if DeltaCount>0 then
					ReddotManager.IncreaseLeafNodeCount(NodeName,DeltaCount)
				elseif DeltaCount<0 then
					ReddotManager.DecreaseLeafNodeCount(NodeName,-DeltaCount)
				end
			end
		end
	end
end

--购买月石类商品，月石不足时自动兑换月石晶胚
function Component:PurchaseShopItemUseCoin1(ShopItemId,Count,InCallBack)
    self.logger.info("PurchaseShopItemUseCoin1 Begin", ShopItemId,Count)
	local function Callback(Ret,PackRewards)
		self.logger.info("PurchaseShopItemUseCoin1 callback", Ret, ShopItemId,Count,PackRewards)
		if InCallBack then
			InCallBack(Ret, ShopItemId,Count,PackRewards)
		end
	end
	self:CallServer("PurchaseShopItemUseCoin1", Callback, ShopItemId,Count)
end

--是否需要显示增强红点,true-需要/未清除，false-已清除/不需要
function Component:CheckShopItemEnhanceRedDot(ShopItemId)

	if not self:CheckIsEffective(ShopItemId) then
		return false
	end

	if not ShopItemId then return false end
	local ShopItemData = DataMgr.ShopItem[ShopItemId]
	if not ShopItemData then return false end
	if not ShopItemData.EnhanceRedDot then return false end
	local ShopItem = self.ShopItems[ShopItemId]
	if not ShopItem then return true end
	if ShopItem.EnhanceRedDotCleaned then return false end
	return true
end

--清除商品增强红点
function Component:CleanShopItemEnhanceRedDot(ShopItemId, InCallback)
	self.logger.info("CleanShopItemEnhanceRedDot Begin", ShopItemId)
	local function Callback(Ret)
		self.logger.info("CleanShopItemEnhanceRedDot callback", Ret, ShopItemId)

		-- 增强商品红点
		local ShopItemConf = DataMgr.ShopItem[ShopItemId]
		if ShopItemConf and ShopItemConf.SubTabId then
			local ReddotNodeName = DataMgr.ShopTabSub[ShopItemConf.SubTabId].ReddotNode
			if ReddotNodeName then
				ReddotManager.DecreaseLeafNodeCount(ReddotNodeName, 1, {ShopItemId = ShopItemId})
			end
		end

		if InCallback then
			InCallback()
		end
	end
	self:CallServer("CleanShopItemEnhanceRedDot", Callback, ShopItemId)
end

--是否需要售罄展示,true-需要，false-不需要/不属于
function Component:CheckShopItemSoldOutDisplay(ShopItemId)
	if not ShopItemId then return false end
	local ShopItemData = DataMgr.ShopItem[ShopItemId]
	if not ShopItemData then return false end
	local ShopItem = self.ShopItems[ShopItemId]
	if not ShopItem then return false end

	-- 已售完 且 未下架
	if ShopItem.RemainPurchaseTimes ~= 0 or not self:CheckIsEffective(ShopItemId) then
		return false
	end

	if ShopItemData.RefreshTime ~= nil then
		-- 周期礼包
		return true
	else
		-- 非周期礼包
		return ShopItemData.PurchaseLimit > 0 and ShopItemData.SoldOutDisplay == true
	end
end

return Component