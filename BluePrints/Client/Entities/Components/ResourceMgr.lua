local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
local Component = {}

function Component:EnterWorld()
	ArmoryUtils:CreateReddotInfos(CommonConst.DataType.Resource)
end

function Component:_OnPropChangeResources(Keys)
	local ResourceId = Keys and Keys[1]
	if(ResourceId)then
		--通知材料数量改变
		EventManager:FireEvent(EventID.OnResourcesChanged,ResourceId)
	end
end

function Component:GetResourceNum(ResourceId)
	local Resource = self.Resources[ResourceId] 
	if not Resource then return 0 end 
	return Resource.Count
end

function Component:CheckEnough(Resources)
	for ResourceId, Count in pairs(Resources) do
		local Resource = self.Resources[ResourceId]
		if not Resource then
			return false
		end
		if Resource.Count < Count then
			return false
		end
	end
	return true
end

function Component:CheckResourceEnough(Resources)
	return self:CheckEnough(Resources)
end

function Component:ResourceSale(ResourceId, Count)
	self.logger.info("ResourceSale", ResourceId, Count)
	local function callback(Ret)
		self.logger.info("ResourceSale callback", Ret, ResourceId, Count)
		EventManager:FireEvent(EventID.OnUpdateBagItem, "SaleItems", Ret, ResourceId, Count)
	end
	self:CallServer("ResourceSale", callback, ResourceId, Count)
end

function Component:ResourceBulkSale(SaleResources)
	if not SaleResources or type(SaleResources) ~= "table" then
		return
	end
	local function callback(Ret, SaleSucc, SaleFali)
		self.logger.info("ZJT_ ResourceBulkSale callback", Ret, SaleFali)
		EventManager:FireEvent(EventID.OnUpdateBagItem, "ResourceBulkSale", Ret, SaleSucc, SaleFali)
	end
	self:CallServer("ResourceBulkSale", callback, SaleResources)
end

-- 锁定
function Component:LockResourceInBag(Tag, Id, FishSize)
	FishSize = FishSize or 0
	local function callback(Ret)
		self.logger.info("zjt_ LockResourceInBag callback", Ret, Id, Tag)
		local OpAction = (0 == FishSize) and "StateChange" or "FishStateChange"
		EventManager:FireEvent(EventID.OnUpdateBagItem, OpAction, Ret, Id, FishSize)
	end
	if Tag == CommonConst.AllType.Resource then
		self:CallServer("LockResourceInBag", callback, Id, FishSize)
	elseif Tag == CommonConst.AllType.Weapon then
		self:CallServer("LockWeaponInBag", callback, Id)
	elseif Tag == CommonConst.AllType.Mod then
		self:CallServer("LockModInBag", callback, Id)
	end
end

-- 解锁
function Component:UnLockResourceInBag(Tag, Id, FishSize,SecondaryPassword)
	FishSize = FishSize or 0
	SecondaryPassword = SecondaryPassword or ""
	local function callback(Ret)
		self.logger.info("UnLockResourceInBag callback", Ret, Id)
		local OpAction = (0 == FishSize) and "StateChange" or "FishStateChange"
		EventManager:FireEvent(EventID.OnUpdateBagItem, OpAction, Ret, Id, FishSize)
	end
	if Tag == CommonConst.AllType.Resource then
		self:CallServer("UnLockResourceInBag", callback, Id, FishSize)
	elseif Tag == CommonConst.AllType.Weapon then
		if (CommonUtils.IsObjId(Id)) then
			self:CallServer("UnLockWeaponInBag", callback, Id,SecondaryPassword)
		else
			-- local ErrorLog = string.format("::Error:: UnLockResourceInBag= 在军械库或者背包中解锁武器Rpc参数非法")
			-- UIManager(self):ShowUIError(UIConst.ErrorCategory.Bag, ErrorLog, true)
			DebugPrint("::Error:: UnLockResourceInBag= 在军械库或者背包中解锁武器Rpc参数非法: 传过来的不是一个ObjId")
		end
	elseif Tag == CommonConst.AllType.Mod then
		self:CallServer("UnLockModInBag", callback, Id,SecondaryPassword)
	end
end


-- 切换轮盘配置
function Component:ChangeWheel(TargetIndex)
	local function callback(ret)
		EventManager:FireEvent(EventID.OnChangeWheel, ret)
	end
	self:CallServer("ChangeWheel", callback, TargetIndex)
end

-- 装备
function Component:ChangeBattleWheel(WheelIndex, SlotId, ResourceId)
	local function callback(ret)
		self.logger.debug("ChangeBattleWheel", ret, WheelIndex, SlotId, ResourceId)
		EventManager:FireEvent(EventID.OnChangeBattleWheel, ret, WheelIndex, SlotId, ResourceId)
	end
	self:CallServer("ChangeBattleWheel", callback, WheelIndex, SlotId, ResourceId)
end

-- 交换
function Component:ExchangeBattleWheel(WheelIndex, SlotId, TargetSlotId)
	local function callback(ret)
		EventManager:FireEvent(EventID.OnExchangeBattleWheel, ret,WheelIndex, SlotId, TargetSlotId)
	end
	self:CallServer("ExchangeBattleWheel", callback, WheelIndex, SlotId, TargetSlotId)
end

-- 卸载
function Component:TakeOffBattleWheel(WheelIndex, SlotId)
	local function callback(ret)
		EventManager:FireEvent(EventID.OnTakeOffBattleWheel,ret,WheelIndex, SlotId)
	end
	self:CallServer("TakeOffBattleWheel", callback, WheelIndex, SlotId)
end

-- 给魅影装备武器
function Component:EquipAssisterWeapon(AssisterId, WeaponUuid)
	local function callback(ret)
		EventManager:FireEvent(EventID.OnEquipAssisterWeapon,ret,AssisterId, WeaponUuid)
	end
	self:CallServer("EquipAssisterWeapon", callback, AssisterId, WeaponUuid)
end


function Component:TakeOffAssisterWeapon(AssisterId, WeaponUuid)
	local function Callback( Ret )
		self.logger.info("ZJT_ TakeOffAssisterWeapon ServerCallClient ", Ret, AssisterId, WeaponUuid)
		EventManager:FireEvent(EventID.OnTakeOffAssisterWeapon,Ret,AssisterId, WeaponUuid)
	end
	self:CallServer("TakeOffAssisterWeapon", Callback, AssisterId, WeaponUuid)
end


-- 使用战斗轮盘中的道具
function Component:UseWheelItemInBattle(ResourceId, UseWheelItemInBattleCallBack)
	ResourceId = tonumber(ResourceId)
	local InBattleWheelMenuModel = require "BluePrints.UI.WBP.Battle.Widget.Battle_Menu.InBattleWheelMenuModel"
	local function callback(ret)
		self.logger.debug("ZJT_ UseItemInBattle ServerCallClient ", ret)
		local CheckRet = ErrorCode:Check(ret)
		if CheckRet then
			InBattleWheelMenuModel:UpdateInBattleWheelPropUseData(ResourceId)
		end
		if UseWheelItemInBattleCallBack then
			UseWheelItemInBattleCallBack(CheckRet)
		end
	end
	self:CallServer("UseItemInBattle", callback, ResourceId)
end

function Component:UseResourceInBag(ResourceId,Count,InCallBack)
	local function callback(ErrCode, ...)
		self.logger.info("UseResourceInBag", ErrorCode:Name(ErrCode))
		ErrorCode:Check(ErrCode)
		if InCallBack then
			InCallBack(...)
		end
	end
	self:CallServer("UseResourceInBag", callback, tonumber(ResourceId),tonumber(Count))
end

-- 使用自选道具
function Component:UseOptResourceInBag(ResourceId,OptIdxList,InCallBack)
	DebugPrint("gmy@ResourceMgr Component:UseOptResourceInBag", ResourceId,OptIdxList)
	local function callback(ErrCode)
		self.logger.info("UseOptResourceInBag", ErrorCode:Name(ErrCode))
		if ErrorCode:Check(ErrCode) then
			-- 将背包消耗品的红点缓存的个数减去使用的数量
			local BagConsumeNode = ReddotManager.GetTreeNode("Bag_Consume")
			local BagConsumeNodeDetails = BagConsumeNode.Cache.Detail
			local Avatar = GWorld:GetAvatar()
			if BagConsumeNode and BagConsumeNode.Cache.Detail[ResourceId] then
				BagConsumeNodeDetails[ResourceId].ClickedCount = Avatar:GetResourceNum(ResourceId)
				BagConsumeNodeDetails[ResourceId].StuffCount = Avatar:GetResourceNum(ResourceId)
			end
		end
		if InCallBack then
			InCallBack(ErrCode)
		end
	end
	self:CallServer("UseOptResourceInBag", callback, tonumber(ResourceId), OptIdxList)
end




function Component:ChangeWheelName(NewName, WheelIndex)
	local function Callback(Ret)
		self.logger.debug("ZJT_ ChangeWheelName ServerCallClient Ret ", Ret)
		EventManager:FireEvent(EventID.OnWheelNameChanged,Ret,NewName, WheelIndex)
	end
	self:CallServer("ChangeWheelName", Callback, NewName, WheelIndex)
end

function Component:TakeOffAllBattleWheel(WheelIndex)
	local function Callback(Ret)
		self.logger.debug("ZJT_ TakeOffAllBattleWheel ServerCallClient Ret ", Ret)
		EventManager:FireEvent(EventID.OnWheelItemCleared,Ret,WheelIndex)
	end
	self:CallServer("TakeOffAllBattleWheel", Callback, WheelIndex)
end

--月石晶胚（付费道具）转换成月石，CommonConst.Coins
function Component:TransformCoin4ToCoin1(Count, InCallBack)
	self.logger.debug("TransformCoin4ToCoin1 Begin ",Count)
	local function Callback(Ret)
		self.logger.debug("TransformCoin4ToCoin1 Callback ",Ret,Count)
		if InCallBack then
			InCallBack(Count)
		end
	end
	self:CallServer("TransformCoin4ToCoin1", Callback, Count)
end


function Component:ResourceBulkSaleFish(SaleResources)
	if not SaleResources or type(SaleResources) ~= "table" then
		return
	end
	local function Callback(Ret, SaleSucc, SaleSuccTransformResource)
		self.logger.info("ResourceBulkSaleFish callback", Ret, SaleSucc, SaleSuccTransformResource)
		EventManager:FireEvent(EventID.OnUpdateBagItem, "FishResourceBulkSale", Ret, SaleSucc, SaleSuccTransformResource)
	end
	self:CallServer("ResourceBulkSaleFish", Callback, SaleResources)
end

function Component:WalnutBulkSale(SaleWalnuts)
	local function Callback(Ret, SaleFucc)
		self.logger.debug("ZJT_ WalnutBulkSale ", Ret, SaleFucc)
		EventManager:FireEvent(EventID.OnUpdateWalnutItem, "WalnutBulkSale", Ret, SaleFucc)
	end
	self:CallServer("WalnutBulkSale", Callback, SaleWalnuts)
end

function Component:GetStoredCollectReward(Callback, RewardPaths)
	local cb = function (ret, Rewards)
		if not ErrorCode:Check(ret) then
			return
		end

		if Callback then
			Callback(ret, Rewards)
		end
	end
	self:CallServer("GetStoredCollectReward", cb, RewardPaths)
end

return Component
