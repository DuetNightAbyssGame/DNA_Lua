local GiftModel = require("BluePrints.UI.WBP.Gift.GiftModel")
local GiftCommon = require("BluePrints.UI.WBP.Gift.GiftCommon")
local FriendController = require "BluePrints.UI.WBP.Friend.FriendController"
local GMVariable = require "BluePrints.UI.GMInterface.GMVariable"

---@class GiftController:Controller
local M = Class("BluePrints.Common.MVC.Controller")

---生命周期相关
function M:Init()
    M.Super.Init(self)
end

function M:Destory()
    M.Super.Destory(self)
end
---生命周期相关End

-- 打开界面相关
--[[
打开选择送礼对象弹窗
lua.do GiftController:OpenSelectFriendPopup(160101) 
lua.do GiftController:OpenSelectFriendPopup(120108)
lua.do GiftController:OpenSelectFriendPopup(160107)
]]
function M:OpenSelectFriendPopup(ShopItemId, ParentWidget)
    DebugPrint("GiftSystem: OpenSelectFriendPopup", ShopItemId)
    UIManager():ShowCommonPopupUI(GiftCommon.SelectFriendPopupId, { ShopItemId = ShopItemId }, ParentWidget)
end

function M:OpenGiftShopMain(FriendUid)
    UIManager():LoadUINew(GiftCommon.GiftShopViewName,{FriendUid=FriendUid})
end

-- GM调试：自动选择一个好友进入礼物商店
-- 使用方式：lua.do GiftController:OpenGiftShopMainGM()
function M:OpenGiftShopMainGM()
    local FriendUid = nil
    -- 优先使用好友模块的缓存列表（返回的是Uid数组）
    local FriendModel = FriendController:GetModel()
    if FriendModel and FriendModel.GetFriendList then
        local FriendList = FriendModel:GetFriendList()  -- 返回 (FriendList, OnlineList)
        if type(FriendList) == "table" and #FriendList > 0 then
            FriendUid = FriendList[1]
        end
    end
    -- 兜底：直接遍历Avatar上的Friends字典，取任意一个Uid
    if not FriendUid then
        local FriendDict = self:GetAvatar().Friends
        if FriendDict then
            for uid, _ in pairs(FriendDict) do
                FriendUid = uid
                break
            end
        end
    end
    -- 没有好友则传nil，界面将按默认流程，不会报错
    return self:OpenGiftShopMain(FriendUid)
end
--送礼商店切换好友弹窗
function M:OpenChangeFriendPopup(FriendUid,FriendChangeCallBack,ParentWidget)
    UIManager():ShowCommonPopupUI(GiftCommon.ChangeFriendPopupId, { FriendUid = FriendUid,FriendChangeCallBack=FriendChangeCallBack,},ParentWidget)
end
--打开送礼条件不满足弹窗
function M:OpenCanNotSendPopup(FriendId)
    UIManager():ShowCommonPopupUI(GiftCommon.CanNotSendGiftPopupId, { FriendId = FriendId })
end

function M:OpenPersonInfoPage(Uid)
    local Dialog = UIManager(self):GetUIObj("CommonDialog")
    if Dialog then
        Dialog:Hide("OpenPersonInfoPage")
    end
    self:GetAvatar():CheckOtherPlayerPersonallInfo(Uid)

end
---打开界面相关End
-- 检查送礼条件是否满足，不满足返回false并打开弹窗，
-- 否则返回true
-- @param FriendUid number 好友id 可选，不传则不检查是否满足好友天数
function M:CheckCanSendGift(FriendUid)
    if not GiftModel:LevelCanSendGift() then
        return false
    end

    if FriendUid then
        if not GMVariable.IgnoreGiftShopFriendLimit then
            local FriendDay = GiftModel:GetFriendDay(FriendUid)
            if FriendDay < GiftModel:GetGiftNeedFriendTime() then
                return false
            end
        end
    end

    -- 检查本月送礼次数是否已达上限
    local LeftCount, LimitCount = GiftModel:GetTotalGiftCount()
    if LeftCount <= 0 then
        return false
    end
    return true
end

function M:IsInGiftShop()
    return UIManager(self):GetUIObj(GiftCommon.GiftShopViewName) ~= nil
end

function M:GetGiftMainPage()
    return UIManager(self):GetUIObj(GiftCommon.GiftShopViewName)
end

--送完礼物后如果存在商城外观预览界面则直接关掉，直接回到商店界面
function M:OnSendGiftFinished()
    local SkinPreview = UIManager(self):GetUIObj("SkinPreview")
    if SkinPreview then
        SkinPreview:Close()
    end
end

function M:GetModel()
    return GiftModel
end

function M:GetEventName()
    return EventID.GiftControllerEvent
end

function M:TryToSendGift(OtherUid, ShopItemId)
    local function CallBack(ErrCode, ...)
        DebugPrint("TryToSendGift", ErrCode, ...)
        if ErrCode == ErrorCode.RET_SUCCESS then
           self:OpenGiftCardView(OtherUid, ShopItemId,1)
        elseif ErrCode == ErrorCode.GIFT_RECIPIENT_INVENTORY_FULL then
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_SendGift_AlreadyHave"))
        elseif ErrCode == ErrorCode.GIFT_RECIPIENT_REGION_CODE_RESTRICTED then
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_SendGift_CantSendRegion"))
        else
            --UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_SendGift_CantSendOther"))
            self:CheckError(ErrCode)
        end
    end
    self:GetAvatar():CheckCanRecvShopItemGift(CallBack,OtherUid, ShopItemId)
end

---@param OtherUid number 送礼者或者收礼者的id
---@param ShopItemId number 商品id
---@param GreetingsMode number 发送礼物传1，接收礼物传2
function M:OpenGiftCardView(OtherUid, ShopItemId, GreetingsMode, Mail)
    if  GreetingsMode == 1 then
        local FriendData= FriendController:GetModel():GetFriendDict()[OtherUid]
        if not FriendData then
            --如果此时拿不到好友数据，说明好友突然被删除了
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_SendGift_NoLongerFriend"))
            return
        end
    else 
        local FriendData= FriendController:GetModel():GetFriendDict()[OtherUid]
        if not FriendData then
            local OpenGiftCardView = function(OtherPlayerInfo)
                local Dialog = UIManager(self):GetUIObj("CommonDialog")
                if Dialog then
                    Dialog:Close()
                end

                M.Super.OpenView(self, self:GetUIMgr(), GiftCommon.GiftGetViewName, OtherUid, ShopItemId, GreetingsMode, Mail, OtherPlayerInfo)
            end

            GWorld:GetAvatar():GetOtherPlayerPersonallInfo(OtherUid, { Func = OpenGiftCardView })
            return 
        end
    end

    local Dialog = UIManager(self):GetUIObj("CommonDialog")
    if Dialog then
        Dialog:Close()
    end

    return M.Super.OpenView(self, self:GetUIMgr(), GiftCommon.GiftGetViewName, OtherUid, ShopItemId, GreetingsMode, Mail)
end

--region RPC
function M:SendToShopOrderGift(GoodsId, Uid, Content)
    local CallbackInfo = {Func = self.RecvToShopOrderGift, Obj=self}
    self:GetAvatar():RequestSendShopOrderGift(CallbackInfo,GoodsId, Uid,Content)
end
function M:RecvToShopOrderGift(ErrCode, ...)
    if ErrCode ~= ErrorCode.RET_SUCCESS then
        self:CheckError(ErrCode)
        return
    end
    self:NotifyEvent(GiftCommon.EventId.ToShopOrderGift)
end

function M:SendToShopResourceGift(Uid,ShopItemId,Count,Content, Handler)
    local CallbackInfo = { Func = function(_Self,ErrCode, ...)
        _Self:RecvToShopResourceGift(ErrCode, ...)
        Handler.Func(Handler.Obj, ErrCode, ...)
    end, Obj=self}

    --第五个参数是二级密码，暂时用空字符串替代
    self:GetAvatar():RequestSendShopResourceGift(CallbackInfo,Uid,ShopItemId,Count,Content,"")
end

function M:RecvToShopResourceGift(ErrCode, ...)
    if ErrCode ~= ErrorCode.RET_SUCCESS then
        self:CheckError(ErrCode)
        return
    end

    self:NotifyEvent(GiftCommon.EventId.ToShopResourceGift)
end


-- function M:SendToOrderGift(Uid,ShopItemId,Count,Content)
--     local CallbackInfo = {Func = self.RecvToOrderGift, Obj=self}
--     self:GetAvatar():RequestSendOrderGift(CallbackInfo,Uid,GoodsId,Content)
-- end
-- function M:RecvToOrderGift(ErrCode, ...)
--     --- todo：处理ErrCode并分发事件
-- end

--endregion

function M:GetSenderName(MailUniqueId, IsStar)
    local Avatar = GWorld:GetAvatar()
    local Mail
    if IsStar then
        Mail = Avatar.StarMails[MailUniqueId]
    else
        Mail = Avatar.MailInbox[MailUniqueId]
    end
    return Mail.Nickname
end


_G.GiftController = M

return M
