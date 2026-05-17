local Component = {}

function Component:EnterWorld()
    EventManager:AddEvent(EventID.OnLoginSuccess, self, self.CheckReddot)
end

function Component:LeaveWorld()
    EventManager:RemoveEvent(EventID.OnLoginSuccess, self)
end

function Component:CheckReddot()
    local EventId = 103020

    local PlayerAvatar = self
    local AccessoryDrop = PlayerAvatar.AccessoryDrops[EventId]
    if not AccessoryDrop then
        return
    end
    local TryOutServerData = PlayerAvatar.CharTrial[EventId]

    local AccessDropConfig = DataMgr.BoxDrop[EventId]
    local BoxCoin = GWorld:GetAvatar().Resources[AccessDropConfig.BoxCoinId]
    local OwnBoxCoinAmount = BoxCoin and BoxCoin.Count or 0
    local CoinPerBox = AccessDropConfig.CoinPerBox
    local BoxCount = OwnBoxCoinAmount > 0 and math.floor(OwnBoxCoinAmount / CoinPerBox) or 0
    local TodayCanOpenBoxCount = BoxCount > AccessoryDrop.CurDropBoxNum and AccessoryDrop.CurDropBoxNum or BoxCount
    if TodayCanOpenBoxCount > 0 then
        ReddotManager.IncreaseLeafNodeCount("Acti_AccessoryDrop01", 1, {
            CacheKey = "Red",
            EventId = EventId
        })
    else
        ReddotManager.DecreaseLeafNodeCount("Acti_AccessoryDrop01", 1, {
            CacheKey = "Red",
            EventId = EventId
        })
    end
    DebugPrint("hzq Component:_OnLoginSuccess()")
end

function Component:_OnLoginSuccess()

end

function Component:_OnPropChangeAccessoryDrops(keys)
    if CommonUtils.Size(keys) > 0 then
        if keys[1] == 103020 then
            self:CheckReddot()
        end
    end
end

function Component:_OnPropChangeResources(keys)
    if CommonUtils.Size(keys) > 0 then
        if keys[1] == 221 then
            self:CheckReddot()
        end
    end
end

function Component:OpenAccesorryBox(InCallBack)
    self.logger.info("OpenAccesorryBox")
    local function Cb(ErrCode, Reward)
        DebugPrint("OpenAccesorryBox", ErrorCode:Name(ErrCode), Reward)
        if InCallBack then
            InCallBack.Func(InCallBack.Obj, Reward)
        end
    end
    self:CallServer("OpenAccesorryBox", Cb)
end

return Component
