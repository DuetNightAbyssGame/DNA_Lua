local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"

local Component = {}

function Component:EnterWorld()
    EventManager:AddEvent(EventID.OnLoginSuccess, self, self.OnLoginSuccess)
end

function Component:LeaveWorld()
    EventManager:RemoveEvent(EventID.OnLoginSuccess, self)
end

-- 获取变身道具
function Component:FoolsDayGetTransformResource()
    self.logger.info("FoolsDayGetTransformResource")
    self:CallServerMethod("FoolsDayGetTransformResource")
end

-- 是否已获得变身道具
function Component:CheckTransformResourceIsGot()
    local ResourceId = DataMgr.EventConstant.TransformResourceID.ConstantValue
    if self.Resources[ResourceId] and self.Resources[ResourceId].Count and self.Resources[ResourceId].Count > 0 then
        return true
    else
        return false
    end
end

-- 解锁变身道具
function Component:FoolsDayUnlockTransform(TransformID)
    self.logger.info("RaidSeasonGetPreRaidRankInfo")
    self:CallServerMethod("FoolsDayUnlockTransform",TransformID)
end

-- 获取我的所有图片Id
function Component:GetMyFoolsDayPhotoIds()
    return self.FoolsDayPhotos
end

-- 删除我的图片
function Component:FoolsDayDelPhoto(UniqueId, InCallback)
    local function Callback(Ret)
        self.logger.info("FoolsDayDelPhoto ", Ret, UniqueId)
        if InCallback then
            InCallback(Ret)
        end
    end
    self:CallServer("FoolsDayDelPhoto",Callback,UniqueId)
end

-- 使用图片Id获取图片数据
function Component:FoolsDayGetPhotoData(UniqueIds, InCallback)
    local function Callback(Ret, PhotoDocs)
        self.logger.info("FoolsDayGetPhotoData ", Ret, UniqueIds and #UniqueIds, PhotoDocs and #PhotoDocs)
        if ErrorCode:Check(Ret) then
            if InCallback then
                InCallback(PhotoDocs)
            end
        end
    end
    self:CallServer("FoolsDayGetPhotoData",Callback,UniqueIds)
end

-- 获取最新图片列表
function Component:FoolsDayGetFreshestRankList(StartIndex, Count, InCallback)
    local function Callback(Ret, PhotoDocs)
        self.logger.info("FoolsDayGetFreshestRankList ", Ret, StartIndex, Count, PhotoDocs and #PhotoDocs)
        if ErrorCode:Check(Ret) then
            if InCallback then
                InCallback(PhotoDocs)
            end
        end
    end
    self:CallServer("FoolsDayGetFreshestRankList",Callback,StartIndex,Count)
end

-- 获取最热图片列表
function Component:FoolsDayGetLikeRankList(StartIndex, Count, InCallback)
    local function Callback(Ret, PhotoDocs)
        self.logger.info("FoolsDayGetLikeRankList ", Ret, StartIndex, Count, PhotoDocs and #PhotoDocs)
        if ErrorCode:Check(Ret) then
            if InCallback then
                InCallback(PhotoDocs)
            end
        end
    end
    self:CallServer("FoolsDayGetLikeRankList",Callback,StartIndex,Count)
end

-- 点赞图片
function Component:FoolsDayLikePhoto(PhotoId, LikeType, InCallback)
    local function Callback(Ret)
        self.logger.info("FoolsDayLikePhoto ", Ret, PhotoId, LikeType)
        if InCallback then
            InCallback(Ret)
        end
    end
    self:CallServer("FoolsDayLikePhoto",Callback,PhotoId,LikeType)
end

-- 取消点赞（暂无使用场景）
function Component:FoolsDayUnlikePhoto(PhotoId, LikeType, InCallback)
    local function Callback(Ret)
        self.logger.info("FoolsDayUnlikePhoto ", Ret, PhotoId, LikeType)
        if InCallback then
            InCallback(Ret)
        end
    end
    self:CallServer("FoolsDayUnlikePhoto",Callback,PhotoId,LikeType)
end

-- 获取图片是否被我点赞过
function Component:GetIsFoolsDayPhotoLiked(PhotoId, LikeType)
    if not self.FoolsDayLikeRecord[PhotoId] then
        return false
    end
    if not self.FoolsDayLikeRecord[PhotoId].Records[LikeType] then
        return false
    end
    return true
end

function Component:RefreshAprilFoolDayTransformResourceReddot()
    if not ReddotManager.GetTreeNode("AprilFoolDayTransformResource") then
        ReddotManager.AddNodeEx("AprilFoolDayTransformResource")
    end
    ReddotManager.ClearLeafNodeCount("AprilFoolDayTransformResource", true)
    if ActivityUtils.CheckEventIsInActiveTime(DataMgr.EventConstant.AFDayEvent2026ID.ConstantValue) and not self:CheckTransformResourceIsGot() then
        ReddotManager.IncreaseLeafNodeCount("AprilFoolDayTransformResource", 1)
    end
end

function Component:RefreshAprilFoolDayReddotNewReddot()
    if not ReddotManager.GetTreeNode("AprilFoolDayRewardNew") then
        ReddotManager.AddNodeEx("AprilFoolDayRewardNew")
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("AprilFoolDayRewardNew")
    if ActivityUtils.CheckEventIsInActiveTime(DataMgr.EventConstant.AFDayEvent2026ID.ConstantValue) then
        ReddotManager.ClearLeafNodeCount("AprilFoolDayRewardNew")
        if not CacheDetail or not CacheDetail.DoNotShowNew then
            ReddotManager.IncreaseLeafNodeCount("AprilFoolDayRewardNew", 1)
        end
    else
        ReddotManager.ClearLeafNodeCount("AprilFoolDayRewardNew", true)
    end
end

function Component:OnLoginSuccess()
    self:RefreshAprilFoolDayReddotNewReddot()
    self:RefreshAprilFoolDayTransformResourceReddot()
end

-- 图片被运营下架，通知客户端
function Component:FoolsDayPhotoHasDeleted(UniqueId)
    local FoolsDayMain = UIManager(GWorld.GameInstance):GetUIObj("AprilFoolsDayMain")
    if IsValid(FoolsDayMain) then
        FoolsDayMain:OnPhotoDeletedOnServer(UniqueId)
    end
end

return Component