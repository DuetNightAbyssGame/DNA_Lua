local ActivityModel = require "BluePrints.UI.WBP.Activity.ActivityModel"
local ActivityCommon = require "BluePrints.UI.WBP.Activity.ActivityCommon"
local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"
local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"

---@class ActivityController:Controller
local M=Class("BluePrints.Common.MVC.Controller")

--region 生命周期
function M:Init()
    M.Super.Init(self)
    EventManager:AddEvent(EventID.OnDailyRefresh, self, self.OnRefreshInNextDay)
    EventManager:AddEvent(EventID.OnActivityTimeOpen, self, self.OnRefreshWithActivityOpen)
    EventManager:AddEvent(EventID.OnActivityTimeOpenClose, self, self.OnRefreshWithActivityClose)
    EventManager:AddEvent(EventID.OnActivityComplete, self, self.OnRefreshWithActivityClose)
    EventManager:AddEvent(EventID.OnRechargeFinished, self, self.OnRechargeFinished)
    self:RefreshDoubleModDropEventID()
end

function M:GetEventName()
    return EventID.ActivityControllerEvent
end

function M:Destory()
    M.Super.Destory(self)
    EventManager:RemoveEvent(EventID.OnDailyRefresh, self)
    EventManager:RemoveEvent(EventID.OnActivityTimeOpen, self)
    EventManager:RemoveEvent(EventID.OnActivityTimeOpenClose, self)
    EventManager:RemoveEvent(EventID.OnActivityComplete, self)
    EventManager:RemoveEvent(EventID.OnRechargeFinished, self)
end

-- 跨天刷新
function M:OnRefreshInNextDay()
    self:NotifyEvent(ActivityCommon.EventId.OnRefreshInNextDay)
    -- 尝试增加一下需要跨天刷新的红点
    for key, ActivityId in pairs(ActivityCommon.NeedRefreshInNextDay) do
        ActivityUtils.TryAddActivityReddotCommon("Red", ActivityId)
    end
    if DataMgr.EventMain then
        for ActivityId, EventData in pairs(DataMgr.EventMain) do
            if EventData.EventTypeId == ActivityCommon.EventAllTypeId.DailyLogin then
                ActivityUtils.TryAddActivityReddotCommon("Red", ActivityId)
            end
        end
    end
end

-- 活动开始刷新
function M:OnRefreshWithActivityOpen(ActivityId)
    -- self:NotifyEvent(ActivityCommon.EventId.OnRefreshWithActivityOpen)
    -- 尝试在活动开启的时候增加一下红点
    ActivityUtils.TryAddActivityReddotCommon("Red", ActivityId)
    self:RefreshDoubleModDropEventID()
end

-- 活动结束刷新
function M:OnRefreshWithActivityClose(ActivityId)
    -- self:NotifyEvent(ActivityCommon.EventId.OnRefreshWithActivityClose)
    -- 尝试在活动关闭的时候移除一下红点
    ActivityUtils.TryClearActivityReddotCommon(ActivityId)
    self:RefreshDoubleModDropEventID()
end

-- 累充活动刷新
function M:OnRechargeFinished(Result, GoodsId, ShopItems)
    if Result == ErrorCode.RET_SUCCESS then
        if DataMgr.PayGoods[GoodsId] then
            for ActivityId, _ in pairs(DataMgr.CumulativeTopUpEvent) do
                ActivityUtils.TryClearActivityReddotCommon(ActivityId)
            end
        end
    end
end

function M:GetModel()
    return ActivityModel
end
--endregion

--这里刷新双倍mode的活动id
function M:RefreshDoubleModDropEventID()
    self.DoubleModDropEventID = 0
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return self.DoubleModDropEventID ,false
    end

   local DoubleModDrop = Avatar.DoubleModDrop
    if not DoubleModDrop then
        return self.DoubleModDropEventID ,false
    end
    for EventId, value in pairs(DoubleModDrop) do
        if (Avatar.ActivityTimeOpen and Avatar.ActivityTimeOpen[EventId]) then
            -- 活动在服务端处于开启时间
            self.DoubleModDropEventID = EventId
            return self.DoubleModDropEventID ,true
        end
    end
end

function M:GetDoubleModDropEventID()
    return self.DoubleModDropEventID
end

_G.ActivityController = M
return M