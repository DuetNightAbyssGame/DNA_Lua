local FriendController = require "BluePrints.UI.WBP.Friend.FriendController"
local ChatController = require "BluePrints.UI.WBP.Chat.ChatController"
local FriendCommon = require "BluePrints.UI.WBP.Friend.FriendCommon"
local GiftController = require "BluePrints.UI.WBP.Gift.GiftController"
local Decorator = require("BluePrints.Client.Wrapper.Decorator")
local Component = {}
Decorator:ApplyDecorator(Component)


function Component:EnterWorld()
    FriendController:Init()
end

function Component:LeaveWorld()
    FriendController:Destory()
end

--好友列表 属性变更通知
function Component:_OnPropChangeFriends(keys)
    if not GWorld:GetAvatar() then return end
    FriendController:GetModel():GetFriendList(true)
    if CommonUtils.Size(keys) == 1 then
        local FriendUid = keys[1]
        if not self.Friends[FriendUid] then 
            FriendController:RecvDeleteFriend(ErrorCode.RET_SUCCESS, FriendUid)
        else
            FriendController:RecvAddFriend(ErrorCode.RET_SUCCESS, FriendUid, false)
        end
    end
end
--好友申请收件箱 属性变更通知
function Component:_OnPropChangeFriendRequestReceiveBox(keys)
    if not GWorld:GetAvatar() then return end
    FriendController:GetModel():GetFriendRequestList(true)
    FriendController:GetModel():AddReddotCount()
end
-- --黑名单 属性变更通知
-- function Component:_OnPropChangeBlacklist(keys)
-- end
-- --最近匹配的玩家 属性变更通知
-- function Component:_OnPropChangeRecentMatchList(keys)
-- end
-- --推荐好友列表 属性变更通知
-- function Component:_OnPropChangeRecommendFriendList(keys)
-- end

function Component:RealUpdateFriendInfo(info)
    PrintTable(info,3,"RealUpdateFriendInfo")
    local uid = info.Uid
    if not uid then return end
    local friend = self.Friends[uid]
    if not friend then return end
    friend:Update(info)
    FriendController:RecvRealUpdateFriendInfo(info)
end

--发起申请
Component:BlockAllUIInput("FriendSendAddRequest")
function Component:FriendSendAddRequest(Uid,Remark)
	self.logger.info("FriendSendAddRequest",Uid,Remark)
    local function Cb(ErrCode)
        DebugPrint("FriendSendAddRequest",ErrorCode:Name(ErrCode))
        FriendController:RecvResponse(FriendCommon.EventId.AddFriend, ErrCode, Uid)
    end
	self:CallServer("FriendSendAddRequest", Cb,Uid,tostring(Remark) or "") 
end

--同意好友申请
function Component:FriendAgreeAddRequest(Uid,Coroutine)
    self.logger.info("FriendAgreeAddRequest",Uid)
    local function Cb(ErrCode)
        DebugPrint("FriendAgreeAddRequest",ErrorCode:Name(ErrCode))
        FriendController:RecvAgreeAdd(ErrCode, Uid, Coroutine)
    end
	self:CallServer("FriendAgreeAddRequest", Cb,Uid) 
end

--拒绝好友申请
function Component:FriendRefuseAddRequest(Uid,FriendName,Coroutine)
	self.logger.info("FriendRefuseAddRequest",Uid)
    local function Cb(ErrCode)
        DebugPrint("FriendRefuseAddRequest",ErrorCode:Name(ErrCode))
        FriendController:RecvRefuseAdd(ErrCode,Uid,FriendName, Coroutine)
    end
	self:CallServer("FriendRefuseAddRequest", Cb,Uid) 
end

--删除好友
function Component:FriendSendDeleteRequest(Uid,FriendName)
	self.logger.info("FriendSendDeleteRequest",Uid)
    local function Cb(ErrCode)
        DebugPrint("FriendSendDeleteRequest",ErrorCode:Name(ErrCode))
        FriendController:RecvResponse(FriendCommon.EventId.DeleteFriend,ErrCode,Uid,FriendName)
    end
	self:CallServer("FriendSendDeleteRequest", Cb,Uid) 
end

function Component:FriendSetRemark(Uid,Remark)
	self.logger.info("FriendSetRemark",Uid,Remark)
    local function Cb(ErrCode)
        DebugPrint("FriendSetRemark",ErrorCode:Name(ErrCode))
        FriendController:RecvResponse(FriendCommon.EventId.SetRemark,ErrCode,Uid,Remark)
    end
	self:CallServer("FriendSetRemark", Cb,Uid,Remark) 
end

function Component:FriendSetStar(Uid, bStar)
	self.logger.info("FriendSetStar",Uid)
    local function Cb(ErrCode)
        DebugPrint("FriendSetStar",ErrorCode:Name(ErrCode))
        FriendController:RecvResponse(FriendCommon.EventId.SetStar,ErrCode, Uid,bStar)
    end
	self:CallServer("FriendSetStar", Cb,Uid) 
end

function Component:FriendCancleStar(Uid, bStar)
	self.logger.info("FriendCancleStar",Uid)
    local function Cb(ErrCode)
        DebugPrint("FriendCancleStar",ErrorCode:Name(ErrCode))
        FriendController:RecvResponse(FriendCommon.EventId.SetStar,ErrCode, Uid,bStar)
    end
	self:CallServer("FriendCancleStar", Cb,Uid) 
end

function Component:FriendSearch(Uid)
	self.logger.info("FriendSearch",Uid)
    local function Cb(ErrCode,AvatarInfo)
        DebugPrint("FriendSearch",ErrorCode:Name(ErrCode))
        PrintTable(AvatarInfo,10,"FriendSearch")
        FriendController:RecvResponse(FriendCommon.EventId.Search,ErrCode,Uid,AvatarInfo)
    end
	self:CallServer("FriendSearch", Cb,Uid) 
end

function Component:FriendUpdateMatchList(Uid)
	self.logger.info("FriendUpdateMatchList",Uid)
end

-- function Component:TestAddBlackList()
--     self.logger.info("FriendAddBlackList")
--     local function Cb(ErrCode)
--         DebugPrint("FriendAddBlackList",ErrorCode:Name(ErrCode))
--     end
-- 	self:CallServer("FriendAddBlacklist", Cb,30831131181, "SSSSS", 1221, 3) 
-- end

function Component:FriendAddBlackList(Uid,FriendInfo)
	self.logger.info("FriendAddBlackList",Uid)
    local Nickname = FriendInfo.Nickname
    local Level = FriendInfo.Level
    local HeadIconId = FriendInfo.HeadIconId
    local function Cb(ErrCode)
        DebugPrint("FriendAddBlackList",ErrorCode:Name(ErrCode))
        FriendController:RecvResponse(FriendCommon.EventId.AddBlackList,ErrCode,Uid,Nickname)
    end
	self:CallServer("FriendAddBlacklist", Cb,Uid, FriendInfo)
end

function Component:FriendCancleBlackList(Uid,Nickname)
	self.logger.info("FriendCancleBlackList",Uid)
    local function Cb(ErrCode)
        DebugPrint("FriendCancleBlackList",ErrorCode:Name(ErrCode))
        FriendController:RecvResponse(FriendCommon.EventId.CancelBlackList,ErrCode, Uid,Nickname)
    end
	self:CallServer("FriendCancleBlacklist", Cb,Uid) 
end

Component:BlockAllUIInput("FriendGenerateRecommendList")
function Component:FriendGenerateRecommendList()
	self.logger.info("FriendGenerateRecommendList")
    local function Cb(ErrCode)
        DebugPrint("FriendGenerateRecommendList",ErrorCode:Name(ErrCode),CommonUtils.Size(CommonUtils.BinaryDump(self.RecommendFriendList)))
        FriendController:RecvResponse(FriendCommon.EventId.GetRecommandList,ErrCode)
    end
	self:CallServer("FriendGenerateRecommendList", Cb) 
end

function Component:RefreshFriendData()
	self.logger.info("RefreshFriendData")
    local function Cb(ErrCode)
        DebugPrint("RefreshFriendData",ErrorCode:Name(ErrCode))
        FriendController:RecvResponse(FriendCommon.EventId.RefreshFriend, ErrCode)
    end
    self:CallServer("RefreshFriendData",Cb)
end

function Component:RefreshRecentMatchedFriend()
	self.logger.info("RefreshRecentMatchedFriend")
    local function Cb(ErrCode)
        DebugPrint("RefreshRecentMatchedFriend", ErrorCode:Name(ErrCode))
        FriendController:RecvResponse(FriendCommon.EventId.RefreshMatchFriend, ErrCode)
    end
    self:CallServer("RefreshRecentMatchedFriend", Cb)
end

--@note 之前发送的好友申请通过的通知
function Component:FriendAutoAddNotify(Uid)
	self.logger.info("FriendAutoAddNotify",Uid)
end
return Component