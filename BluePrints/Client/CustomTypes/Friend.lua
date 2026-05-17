local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local TimeUtils = require "Utils.TimeUtils"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties
-- if not CommonConst  then
-- end

---@class Friend
---@field Info AvatarInfo
local Friend = Class("Friend", CustomTypes.CustomAttr)
	---@type Friend 方便智能提示
	Friend.__Props__ = {
		Uid = prop.prop("Int", "client save"),
		Eid = prop.prop("ObjId", "client save"),
		-- HeadIconId = prop.prop("Int", "client save", 0),
		-- Nickname = prop.prop("Str","client save"),
		-- Level = prop.prop("Int","client save",0),
		-- IsOnline = prop.prop("Bool","client save",false),
		Remark = prop.prop("Str", "client save",""),
		Star = prop.prop("Bool", "client save", false),
		BecomeFriendTime = prop.prop("Int", "client save", 1765349474),
		-- LastLogoutTime = prop.prop("Float", "client save"),
		-- CurrentRegionId = prop.prop("Int", "client save",0),
		-- Signature = prop.prop("Str", "client save",""),
		-- 玩家信息
		Info = prop.prop("AvatarInfo.AvatarInfo", "client save"),
	}

	function Friend:Init(Uid)
        self.Uid = Uid
	end

	function Friend:IsOnMission()
		return self.Info.CurrentRegionId==0
	end

	function Friend:Update(Infos)
		self.Info:Update(Infos)
	end

	function Friend:Serialize()
		local info = self.Info:Serialize()
		return info
	end

	FormatProperties(Friend)

---@class FriendDict
local FriendDict = Class("FriendDict", CustomTypes.CustomDict)
	FriendDict.KeyType = BaseTypes.Int
	FriendDict.ValueType = Friend

	function FriendDict:NewFriend(Uid)
		return Friend(Uid)
	end

	function FriendDict:NewFriendByAvatarInfo(info)
		local friend = Friend(info.Uid)
		friend.Eid = info.Eid
		friend:Update(info)
		return friend
	end


---@class RecentMatchedFriend
---@field Info AvatarInfo
local RecentMatchedFriend = Class("RecentMatchedFriend", CustomTypes.CustomAttr)
	---@type RecentMatchedFriend 方便智能提示
	RecentMatchedFriend.__Props__ = {
		Uid = prop.prop("Int", "client save"),
		Eid = prop.prop("ObjId", "client save"),
		MatchTime = prop.prop("Int", "client save"), -- 匹配时间
		-- 玩家信息
		Info = prop.prop("AvatarInfo.AvatarInfo", "client save"),
	}

	function RecentMatchedFriend:Init(Uid)
        self.Uid = Uid
	end

	function RecentMatchedFriend:IsOnMission()
		return self.Info.CurrentRegionId==0
	end

	function RecentMatchedFriend:Update(Infos)
		self.Info:Update(Infos)
	end

	function RecentMatchedFriend:Serialize()
		local info = self.Info:Serialize()
		return info
	end

	FormatProperties(RecentMatchedFriend)


---@class RecentMatchedFriendDict
local RecentMatchedFriendDict = Class("RecentMatchedFriendDict", CustomTypes.CustomDict)
	RecentMatchedFriendDict.KeyType = BaseTypes.Int
	RecentMatchedFriendDict.ValueType = RecentMatchedFriend

	function RecentMatchedFriendDict:NewRecentMatchedFriend(Uid)
		return RecentMatchedFriend(Uid)
	end

	function RecentMatchedFriendDict:NewRecentMatchedFriendByAvatarInfo(info)
		local RecentMatchedFriend = RecentMatchedFriend(info.Uid)
		RecentMatchedFriend.Eid = info.Eid
		RecentMatchedFriend:Update(info)
		return RecentMatchedFriend
	end


---@class FriendRequest
local FriendRequest = Class("FriendRequest", CustomTypes.CustomAttr)
	---@type FriendRequest 方便智能提示
    FriendRequest.__Props__ = {
		Uid = prop.prop("Int", "client save"),
		-- HeadIconId = prop.prop("Int", "client save", 0),
		-- Nickname = prop.prop("Str","client save"),
		-- Level = prop.prop("Int","client save",0),
        Time = prop.prop("Int","client save",0),
        Remark = prop.prop("Str", "client save",""),
		-- Signature = prop.prop("Str", "client save",""),
		-- 玩家信息
		Info = prop.prop("AvatarInfo.AvatarInfo", "client save"),
	}

	function FriendRequest:Init(uid, remark, info)
        self.Uid = uid
		if remark then
			self.Remark = remark
		end
		if info then
			info.Uid = uid
			self.Info:Update(info)
		end
	end

	function FriendRequest:Update(info)
		self.Info:Update(info)
	end

	function FriendRequest:IsExpired()
		local MaxDay = DataMgr.GlobalConstant.FriendApplyDuration.ConstantValue
		return self.Time+MaxDay*CommonConst.SECOND_IN_DAY < TimeUtils.NowTime()
	end

	FormatProperties(FriendRequest)

---@class FriendRequestDict
local FriendRequestDict = Class("FriendRequestDict", CustomTypes.CustomDict)
    FriendRequestDict.KeyType = BaseTypes.Int
    FriendRequestDict.ValueType = FriendRequest
	function FriendRequestDict:NewFriendRequest(uid)
		return FriendRequest(uid)
	end

	function FriendRequestDict:NewFriendRequestByAvatarInfo(info)
		local friendRequest = FriendRequest(info.Uid)
		friendRequest:Update(info)
		return friendRequest
	end

return {
    Friend = Friend,
    FriendDict = FriendDict,
    FriendRequest = FriendRequest,
    FriendRequestDict = FriendRequestDict,
    RecentMatchedFriend = RecentMatchedFriend,
    RecentMatchedFriendDict = RecentMatchedFriendDict,
}
