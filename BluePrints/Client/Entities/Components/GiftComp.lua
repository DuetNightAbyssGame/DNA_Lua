local GiftController = require "BluePrints.UI.WBP.Gift.GiftController"
local Component = {}

function Component:EnterWorld()
    GiftController:Init()
end

function Component:LeaveWorld()
    GiftController:Destory()
end
-- 更新发送礼物记录缓存，进游戏时或者数据改变时服务端会发rpc调用
---@param SendGiftRecordCache table {[Uid] = {[ShopItemId] = Count,[ShopItemId2] = Count2}..}
function Component:UpdateSendGiftRecordCache(SendGiftRecordCache)
    DebugPrint("UpdateSendGiftRecordCache")
    DebugPrintTable(SendGiftRecordCache)
	self.SendGiftRecordCache = SendGiftRecordCache
end

--- func desc
---@param InCallBack function(ErrCode, ...)
---@param Uid 要校验对象的Uid
---@param ShopItemId 要校验的商店物品Id
function Component:CheckCanRecvShopItemGift(InCallBack,Uid,ShopItemId)
    local Callback = function(ErrCode, ...)
        DebugPrint("CheckCanRecvShopItemGift 收到回调".. ErrCode, ...)
        if ErrCode ~= ErrorCode.RET_SUCCESS then
            --GiftController:CheckError(ErrCode)
            DebugPrint("CheckCanRecvShopItemGift 错误码".. ErrCode)
        end
        InCallBack(ErrCode, ...)
    end
    self:CallServer("CheckCanRecvShopItemGift", Callback, Uid, ShopItemId)
end

--商店的SDK订单礼物 @蒋帅
function Component:RequestSendShopOrderGift(CallbackInfo, GoodsId ,Uid ,Content)
    local Callback = function(ErrCode, ...)
        CallbackInfo.Func(CallbackInfo.Obj, ErrCode, ...)
    end
    self:CallServer("RequestSendShopOrderGift",Callback, GoodsId ,Uid ,Content)
end

--商店的扣资源礼物 @蒋帅
function Component:RequestSendShopResourceGift(CallbackInfo,Uid,ShopItemId,Count,Content,SecondaryPassWord)
    local Callback = function(ErrCode, ...)
        CallbackInfo.Func(CallbackInfo.Obj, ErrCode, ...)
        local Index = ...
        if ErrCode == ErrorCode.RET_SUCCESS then
            ChatController:SendGiftMessage(Uid,Index)
            --TEST
            -- ChatController:SendGiftReceivedMessage(Uid,Index)
            EventManager:FireEvent(EventID.OnSendGiftFinished)
        end
    end
    self:CallServer("RequestSendShopResourceGift",Callback,Uid,ShopItemId,Count,Content,SecondaryPassWord)
end

--收礼方领取礼物成功后，通知送礼方
function Component:NotifyGiftMailGot(Index, Time)
    ScreenPrint("NotifyGiftMailGot",Index, Time)
    self.SentGiftRecords[Index].bGiftMailGot = true
    local RecvGiftRecords = self.SentGiftRecords
    local GiftData = nil
    if RecvGiftRecords and CommonUtils.Size(RecvGiftRecords) > 0 then
        GiftData = RecvGiftRecords[Index]
    end
    -- ChatController:SendGiftReceivedMessage(GiftData.Uid,Index)
end

--收礼方领取礼物成功后，通知自己
function Component:NotifyGetGiftMailItemSuccess(Index)
    ScreenPrint("NotifyGetGiftMailItemSuccess",Index)
    local RecvGiftRecords = self.RecvGiftRecords
    local GiftData = nil
    if RecvGiftRecords and CommonUtils.Size(RecvGiftRecords) > 0 then
        GiftData = RecvGiftRecords[Index]
    end

    local FriendData= FriendController:GetModel():GetFriendDict()[GiftData.Uid]
    if not FriendData then
		--收礼的时候，发现好友被删除，则不发送协议
		return
	end
    
    ChatController:SendGiftReceivedMessage(GiftData.Uid,Index)
end

-- --直购订单礼物（战令月卡）@蒋帅
-- function Component:RequestSendOrderGift(CallbackInfo,Uid,GoodsId,Content)
--     local Callback = function(ErrCode, ...)
--         CallbackInfo.Func(CallbackInfo.Obj, ErrCode, ...)
--     end
--     self:CallServer("RequestSendOrderGift",Callback,Uid,GoodsId,Content)
-- end

return Component