local Component = {}

function Component:EnterWorld()
    self:InitFishMapReddot()
end

--获取已钓到鱼的数量，返回累计上鱼总数、普通鱼总数、变异鱼总数、鱼王总数
function Component:GetFishCount()
    local TotalFish = 0
    local NormalFish = 0
    local VariantFish = 0
    local KingFish = 0
    for key,value in pairs(self.Fishes) do
        local FishInfo = DataMgr.Fish[key]
        if FishInfo then
            if FishInfo.FishType == 1 then
                NormalFish = NormalFish + value[1]
            elseif FishInfo.FishType == 2 then
                VariantFish = VariantFish + value[1]
            elseif FishInfo.FishType == 3 then
                KingFish = KingFish + value[1]
            end
            TotalFish = TotalFish + value[1]
        end
    end
    return TotalFish,NormalFish,VariantFish,KingFish
end

--通过鱼Id获取已经钓到的鱼数量
function Component:GetFishCountByFishId(FishId)
    local FishCount = 0
    if FishId and self.Fishes[FishId] then
        local Fish = self.Fishes[FishId]
        FishCount = FishCount + Fish[1]
    end
    return FishCount
end

--获取鱼的最大尺寸，-1表示未钓到该鱼
function Component:GetFishMaxSize(FishId)
    local FishSize = CommonConst.FishSystemNoParam * CommonConst.FishSizeScale
    if self.Fishes[FishId] then
        FishSize = self.Fishes[FishId][2]
    end
    local FishInfo = DataMgr.Fish[FishId]
    if FishInfo.VariationFishId then
        for key,value in pairs(FishInfo.VariationFishId) do
            if self.Fishes[value] then
                FishSize = math.max(FishSize,self.Fishes[value][2])
            end
        end
    end
    FishSize = FishSize / CommonConst.FishSizeScale
    self.logger.debug("GetFishMaxSize",FishId,FishSize)
    return FishSize
end

--开始钓鱼，抛竿。鱼池Id，鱼竿Id，鱼饵Id,小鱼Id
function Component:OnFishStart(FishingSpotId,FishingRodId,FishingLureId,FishId)
    self.logger.debug("OnFishStart Begin",FishingSpotId,FishingRodId,FishingLureId, FishId)
    local function Callback(Ret)
		self.logger.debug("OnFishStart Callback", Ret,FishingSpotId,FishingRodId,FishingLureId,FishId)
	end
    self:CallServer("OnFishStart", Callback,FishingSpotId,FishingRodId,FishingLureId,FishId)
end

--鱼上钩回调
function Component:OnFishHook(FishId,IsSmall2Big)
    self.logger.debug("OnFishHook",FishId,IsSmall2Big)
    EventManager:FireEvent(EventID.OnFishHook, FishId, IsSmall2Big)
end

--中止钓鱼
function Component:OnFishStop(FishingSpotId)
    self:CallServerMethod("OnFishStop",FishingSpotId)
end

--完成钓鱼小游戏，是否成功,是否继续以小钓大
function Component:OnCompleteFishGame(IsSuccess, callback)
    self.logger.debug("OnCompleteFishGame Begin",IsSuccess)
    local function Callback(Ret,FishId,FishSize,RewardReturn)
		self.logger.debug("OnCompleteFishGame Callback", Ret,FishId,FishSize,IsSuccess,RewardReturn)
        if callback then
            callback(Ret, FishId, FishSize, IsSuccess, RewardReturn)
        end
	end
    self:CallServer("OnCompleteFishGame", Callback,IsSuccess)
end

function Component:GMSimulateFish(FishData)
    self.logger.debug("模拟钓鱼成功，您用鱼竿:"..FishData.FishingRodId.."和鱼饵:"..FishData.FishingLureId.."在钓鱼点："..FishData.FishingSpotId.."钓到了一条尺寸为："..FishData.FishSize.."的鱼:"..FishData.FishId..
    "，鱼上钩所需时间为："..FishData.FishHookDuration,",该鱼是否变异：",FishData.IsVariant,
    ",是否触发以小钓大：",FishData.IsSmall2Big,"获得的额外奖励Id:",FishData.ExtraRewardId,"获得的额外宠物Id:",FishData.ExtraPetId)
end

function Component:InitFishMapReddot()
    local Node = ReddotManager.GetTreeNode("AnglingMap")
    if not Node then
        Node = ReddotManager.AddNode("AnglingMap",nil,1)
    end
    local EMCache = require "EMCache.EMCache"
    local UnLockData = EMCache:Get("FishMapUnLockData", true)
    if not UnLockData then
        UnLockData = {}
        for FishId, FishData in pairs(self.Fishes) do
            ReddotManager.IncreaseLeafNodeCount("AnglingMap", 1)
            UnLockData[FishId] = 0
        end
        EMCache:Set("FishMapUnLockData", UnLockData, true)
    end
end

function Component:GMAddFishMapUnLockData()
    local EMCache = require "EMCache.EMCache"
    local UnLockData = EMCache:Get("FishMapUnLockData", true)
    if not UnLockData then
        UnLockData = {}
    end
    for FishId,FishData in pairs(DataMgr.Fish) do
        UnLockData[tostring(FishId)] = 2
    end
    EMCache:Set("FishMapUnLockData", UnLockData, true)
end

function Component:GetFishAchvReward(AchvId, cb)
    self.logger.debug("GetFishAchvReward Begin",AchvId)
	local function Callback(Ret, RewardReturn)
		self.logger.debug("GetFishAchvReward Callback ", Ret, RewardReturn)
        cb(Ret, RewardReturn)
	end
	self:CallServer("GetFishAchvReward", Callback, AchvId)
end

function Component:GetAllFishAchvReward(cb)
    self.logger.debug("GetFishAchvReward Begin")
	local function Callback(Ret, RewardReturn)
		self.logger.debug("GetFishAchvReward Callback ", Ret, RewardReturn)
        cb(Ret, RewardReturn)
	end
	self:CallServer("GetAllFishAchvReward", Callback)
end

--钓鱼点激活
function Component:OnActivateFishingSpot(FishingSpotId)
    self.logger.debug("OnActivateFishingSpot",FishingSpotId)
end
return Component