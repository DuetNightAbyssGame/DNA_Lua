

---注意：Controller里有两个纯虚函数，必须要在子类实现，否则会报错。
---现有结构修改Controller热重载时Controller会被换成另一个表，但有的地方还残留旧的引用，建议修改后重新启动游戏
---@class Controller
---@field Super Controller
local M=Class()

--region 初始化
function M:Init()
    self:GetModel():Init()
    --留个引用，避免热更时失效?
    self._Model = self:GetModel()
    self:GetEventName()
    self.bInited = true
    self.bTipIgnoreBattle = false
    self.Platform = CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance)
    ---@type BP_UIManagerComponent_C
    GWorld.GameInstance:BindGamepadEvent()
    self.IsDestroied = nil
    self.TimerKeys = {}
end

function M:Destory()
    self.bInited = false
    for TimerKey in pairs(self.TimerKeys or {}) do
        self:StopTimer(TimerKey)
    end
    local EventName = self:GetEventName()
    if EventName then
        EventManager.EventDic[EventName] = nil
    end
    self:GetModel():Destory()
    self._Model = nil
    GWorld.GameInstance:UnBindGamepadEvent()
    self.IsDestroied = true
end

---@type AvatarInfo
function M:GetAvatar()
    return self:GetModel():GetAvatar()
end
--endregion

--region 必须要实现的纯虚函数
function M:GetModel()
    assert(false, "请在你继承的Controller里实现你的 GetModel()")
end

function M:GetEventName()
    assert(false, "请在你继承的Controller里实现你的 GetEventName()")
end
--endregion

--region 界面操作 
--OpenView只支持单例界面，多实例界面最好自己管理，不推荐用这个
function M:OpenView(WorldContext,ViewNameOrMainUIId, ...)
    assert(ViewNameOrMainUIId, "ViewName is nil")
    local ViewName = nil
    local ViewObj
    if type(ViewNameOrMainUIId) == "string" then
        ViewName = ViewNameOrMainUIId
        if not WorldContext then WorldContext = GWorld.GameInstance end
        ViewObj = self:GetUIMgr(WorldContext):LoadUINew(ViewName, ...)
    elseif type(ViewNameOrMainUIId) == "number" then
        local MainUIId = ViewNameOrMainUIId
        local MainUIConf = DataMgr.MainUI[MainUIId]
        if MainUIConf then
            UIUtils.OpenSystem(MainUIId, ...)
            ViewName = MainUIConf.SystemUIName
            ViewObj = self:GetView(WorldContext, ViewName)
        end
        local PopupId = ViewNameOrMainUIId
        local PopupConf = DataMgr.CommonPopupUIContext[PopupId]
        if PopupConf then
            local Params = ...
            ViewObj = self:OpenPopUp(WorldContext, PopupId, Params)
        end
    end
    return ViewObj
end

function M:OpenPopUp(WorldContext, PopupId, Params)
    assert(PopupId, "PopupId is nil")
    return self:GetUIMgr(WorldContext):ShowCommonPopupUI(PopupId, Params, WorldContext)
end

function M:GetView(WorldContext, ViewName)
    assert(ViewName, "ViewName is nil")
    if not WorldContext then WorldContext = GWorld.GameInstance end
    assert(IsValid(WorldContext), "WorldContext is not valid")
    local ViewObj = self:GetUIMgr(WorldContext):GetUIObj(ViewName)
    return ViewObj
end

function M:OpenViewAsync(WorldContext, ViewName, Coroutine, ...)
    assert(ViewName, "ViewName is nil")
    if not WorldContext then WorldContext = GWorld.GameInstance end
    local ViewObj = self:GetUIMgr(WorldContext):LoadUIAsync(ViewName, Coroutine, ...)
    return ViewObj
end

function M:GetViewAsync(WorldContext, ViewName, Coroutine)
    assert(ViewName, "ViewName is nil")
    if not WorldContext then WorldContext = GWorld.GameInstance end
    assert(IsValid(WorldContext), "WorldContext is not valid")
    local ViewObj = self:GetUIMgr(WorldContext):GetUIObjAsync(ViewName,Coroutine)
    return ViewObj
end

function M:ShowToast(Text, Duration, ExtraData)
    if Duration == nil then Duration = 1.5 end
    if Text == nil then Text = GText("UI_REGISTER_COMINGSOON") end
    DebugPrint(LXYTag, "Controller::ShowToast::Content", Text)
    local TipType = UIConst.Tip_CommonToast
    local BattleView = self:GetUIMgr():GetUIObj(DataMgr.SystemUI.BattleMain.UIName)
    if BattleView:IsVisible() and not self.bTipIgnoreBattle then
        TipType = UIConst.Tip_CommonTop
    end
    self:GetUIMgr():ShowUITip(TipType,Text,Duration,false, ExtraData)
end

function M:CheckError(ErrCode, bShowTip, ...)
    if ErrCode == ErrorCode.RET_SUCCESS then
        return true 
    end
    if bShowTip == nil then bShowTip = true end
    local TipType = UIConst.Tip_CommonToast
    local BattleView = self:GetUIMgr():GetUIObj(DataMgr.SystemUI.BattleMain.UIName)
    if BattleView and BattleView:IsVisible() and not self.bTipIgnoreBattle then
        TipType = UIConst.Tip_CommonTop
    end
    DebugPrint(LXYTag, "Controller::CheckError::ErrCode", ErrorCode:Name(ErrCode))
    if bShowTip then
        self:GetUIMgr():ShowError(ErrCode, 1.5, TipType,...)
    end
    return false
end

---@return BP_UIManagerComponent_C
function M:GetUIMgr(WorldContext)
    if IsValid(self.UIManager) then
        return self.UIManager
    end
    if not WorldContext then WorldContext = GWorld.GameInstance end
    self.UIManager = UIManager(WorldContext)
    return self.UIManager
end
--endregion

--region 事件(前一版自己写的事件分发太屎了，还是用EventManager吧... 简单高效)
---@param EventFunc fun(EventObj:any, EventId:string, params:...)
function M:RegisterEvent(EventObj,EventFunc)
    if not EventFunc then
        EventFunc = function(self, EventId, ...)
            local Func = self["Notify"..EventId]
            if Func then Func(self, ...) end
        end
    end
    if EventObj.AddDispatcher then
        EventObj:AddDispatcher(self:GetEventName(), EventObj,EventFunc)
        --EventManager:AddEvent(self:GetEventName(), EventObj, EventFunc)
    else
        EventManager:AddEvent(self:GetEventName(), EventObj, EventFunc)
    end
end

function M:UnRegisterEvent(EventObj)
    if EventObj.RemoveDispatcher then
        EventObj:RemoveDispatcher(self:GetEventName())
        --EventManager:RemoveEvent(self:GetEventName(), EventObj)
    else
        EventManager:RemoveEvent(self:GetEventName(), EventObj)
    end
end

function M:NotifyEvent(EventId, ...)
    EventManager:FireEvent(self:GetEventName(), EventId, ...)
end
--endregion

--region 全局定时器
function M:AddTimer(Interval, Func, IsLoop, Delay, Key, IsRealTime, ...)
    if not self.TimerKeys then self.TimerKeys = {} end
    if IsRealTime == nil then IsRealTime = true end
    if not IsValid(GWorld.GameInstance) then return end
    local _,TimerKey, TimerInfo = nil, nil, nil
    local TempFunc = function(...)
        if not IsLoop then
            self.TimerKeys[TimerKey] = nil
        end
        Func(...)
    end
    _,TimerKey = GWorld.GameInstance:AddTimer(Interval, TempFunc, IsLoop, Delay, Key, IsRealTime, ...)
    self.TimerKeys[TimerKey] = 1
    DebugPrint(self:GetEventName() .." Controller:AddTimer "..TimerKey)
    return TimerKey
end

function M:StopTimer(TimerKey)
    if not self.TimerKeys then self.TimerKeys = {} end
    if not TimerKey then return end
    DebugPrint(self:GetEventName() .."Controller:StopTimer "..TimerKey)
    if not IsValid(GWorld.GameInstance) then return end
    if not self.TimerKeys[TimerKey] then return end
    if GWorld.GameInstance:IsExistTimer(TimerKey) then
        GWorld.GameInstance:RemoveTimer(TimerKey, true)
        self.TimerKeys[TimerKey]= nil
    end
end

function M:IsExistTimer(TimerKey)
    if not self.TimerKeys then self.TimerKeys = {} end
    if not self.TimerKeys[TimerKey] then return false end
    return GWorld.GameInstance:IsExistTimer(TimerKey)
end
--endregion

function M:IsPC()
    return self.Platform == CommonConst.CLIENT_DEVICE_TYPE.PC
end

function M:IsGamepad()
    return GWorld.GameInstance.CurInputDeviceType == ECommonInputType.Gamepad
end

function M:GetInputDeviceName()
    return GWorld.GameInstance.CurInputDeviceName
end

function M:IsMobile()
    return self.Platform == CommonConst.CLIENT_DEVICE_TYPE.MOBILE
end

return M