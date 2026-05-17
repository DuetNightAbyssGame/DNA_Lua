local M = Class("BluePrints.Common.MVC.Model")
local TimeUtils = require "Utils.TimeUtils"
local GMVariable = require "BluePrints.UI.GMInterface.GMVariable"

function M:Init()
    M.Super.Init(self)
    self.Friends = {}
end

function M:GetFriends()
    self.Friends = {}
    local AvatarFriends = self:GetAvatar().Friends
    if not AvatarFriends then
        return self.Friends
    end
    for FriendId, Friend in pairs(AvatarFriends) do
        if GMVariable.IgnoreGiftShopFriendLimit or self:GetFriendDay(FriendId) >= self:GetGiftNeedFriendTime() then
            table.insert(self.Friends, Friend)
        end
    end
    return self.Friends
end
--经过导表脚本预处理过的数据，获取所有可作为礼物的ShopItemId
function M:GetAllGiftItemIds()
   return DataMgr["GiftIdMap"] or {}
end

--获得对应subtab的所有ShopItemId
function M:GetGiftIdsByGiftSubTabId(SubTabId)
    return DataMgr["GiftSubTabId2ShopItemIds"][SubTabId] or {}
end

--获取当前已消耗送礼额度和总额度
function M:GetTotalGiftQuota()
    return  self:GetAvatar().ConsumeGiftQuota , self:GetAvatar().TotalGiftQuota 
end
--获取剩余送礼次数和总次数
function M:GetTotalGiftCount()
    local  LeftCount = DataMgr["GiftConstant"].GiftCountPerMonth_S.ConstantValue1-self:GetAvatar().CurrentMonthSendGiftCount
    return  LeftCount > 0 and LeftCount or 0 , DataMgr["GiftConstant"].GiftCountPerMonth_S.ConstantValue1
end
--获取送礼所需历来的等级
function M:GetGiftLevel()
    return DataMgr["GiftConstant"].GiftLimitLevel.ConstantValue1 or 5
end
--获取成为好友的天数
function M:GetFriendDay(FriendId)
    if not FriendId then return 0 end
    local Friends = self:GetAvatar().Friends
    if not Friends then return 0 end
    local Friend = Friends[FriendId]
    if not Friend or not Friend.BecomeFriendTime or Friend.BecomeFriendTime <= 0 then
        return 0
    end
    return math.floor((TimeUtils.NowTime() - Friend.BecomeFriendTime) / 86400)
end
--获取送礼所需的好好友天数
function M:GetGiftNeedFriendTime()
    return DataMgr["GiftConstant"].KeepFriendshipTime.ConstantValue1 or 14
end
--是否等级符合送礼要求
function M:LevelCanSendGift()
    return self:GetAvatar().Level >= self:GetGiftLevel()
end

--获取对应商品已发送次数
---@param ShopItemId any
---@param Uid   number  目标用户Id
function M:GetGiftHadSendCount(ShopItemId,Uid)
    if not ShopItemId then
        return 0
    end
    local Cache=self:GetAvatar().SendGiftRecordCache and self:GetAvatar().SendGiftRecordCache[Uid]
    if not Cache then
        return 0
    end
    local SentTimes= Cache[ShopItemId] or 0
    return SentTimes 
end

function M:Destory()
    M.Super.Destory(self)
end
_G.GiftModel=M
return M
