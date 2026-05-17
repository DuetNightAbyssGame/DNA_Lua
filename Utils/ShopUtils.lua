require "UnLua"
local TimeUtils = require "Utils.TimeUtils"
local HeroUSDKUtils = require "Utils.HeroUSDKUtils"
local MonthCardModel = require "BluePrints.UI.WBP.Perk.MonthCard.MonthCardModel"
local M = {}

--------------------------------------------------- 客户端充值接口 ---------------------------------------------------  

function M:IsCanOpenPay(bOpen)
    return true
    -- if bOpen and Const.bForceOpenPay then
    --     return true
    -- end

    -- return not UE.AHotUpdateGameMode.IsGlobalPak()
end

--- 获取SDK账号注册时的地区编码
function M:GetSDKRegisterRegionCode()
    local DefaultRegion = "CN"
    if UE.AHotUpdateGameMode.IsGlobalPak() then
        DefaultRegion = "US"
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return DefaultRegion
    end
    local RegionCode = Avatar.SdkRegisterRegionCode
    if not RegionCode or RegionCode == "" or not DataMgr.CountryRegionCode[RegionCode] then
        RegionCode = DefaultRegion
    end
    return RegionCode
end

--- 获取当前地区的编码
function M:GetRegionCode()
    local DefaultRegion = "CN"
    if UE.AHotUpdateGameMode.IsGlobalPak() then
        DefaultRegion = "US"
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return DefaultRegion
    end
    local RegionCode = Avatar.SdkLoginRegionCode
    if not RegionCode or RegionCode == "" or not DataMgr.CountryRegionCode[RegionCode] then
        RegionCode = DefaultRegion
    end
    return RegionCode
end
--- 获取当前地区对应的货币符号
function M:GetCurrencyType()
    local DefaultRegion = "CN"
    if UE.AHotUpdateGameMode.IsGlobalPak() then
        DefaultRegion = "US"
    end
    local RegionCode = self:GetRegionCode()
    if not DataMgr.CountryRegionCode[RegionCode] then
        return DataMgr.CountryRegionCode[DefaultRegion].MoneySymbol
    end
    return DataMgr.CountryRegionCode[RegionCode].MoneySymbol
end

--- 获取当前地区对应的商品价格字段
function M:GetCurrencyPrice()
    local DefaultRegion = "CN"
    if UE.AHotUpdateGameMode.IsGlobalPak() then
        DefaultRegion = "US"
    end
    local RegionCode = self:GetRegionCode()
    if not DataMgr.CountryRegionCode[RegionCode] then
        return DataMgr.CountryRegionCode[DefaultRegion].MoneyCode
    end
    return "Price"..DataMgr.CountryRegionCode[RegionCode].MoneyCode
end
--- 商城是否存在免费物品
function M:HasFreeShop(ShopType)
    local ItemIds = {}
    for _, MainTabId in pairs(DataMgr.Shop[ShopType].MainTabId) do
        local Data = DataMgr.ShopItem2ShopTab[MainTabId]
        assert(Data, "未找到对应商城主页签:"..MainTabId)
    -- for _, Data in pairs(DataMgr.ShopItem2ShopTab) do
        for _, ShopItemData in pairs(Data) do
            for _, ItemId in pairs(ShopItemData) do
                if self:IsFree(ItemId) then
                    table.insert(ItemIds, ItemId)
                end
            end
        end
    end
    return #ItemIds>0, ItemIds
end

function M:HasNewShop(ShopType)
    local ItemIds = {}
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false, ItemIds
    end
    for _, MainTabId in pairs(DataMgr.Shop[ShopType].MainTabId) do
        local Data = DataMgr.ShopItem2ShopTab[MainTabId]
        assert(Data, "未找到对应商城主页签:"..MainTabId)
        for _, ShopItemData in pairs(Data) do
            for _, ItemId in pairs(ShopItemData) do
                if Avatar:CheckShopItemEnhanceRedDot(ItemId) then
                    table.insert(ItemIds, ItemId)
                end
            end
        end
    end
    return #ItemIds>0, ItemIds
end

--- 判断商品是否免费：1.商品价格为0 2.商品可购买
function M:IsFree(ShopItemId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    if self:GetShopItemPrice(ShopItemId) == 0 and Avatar:CheckShopItemCanPurchase(ShopItemId) then
        return true
    end
    return false
end

--- 获取商品折扣信息
function M:GetShopItemCutoffData(ShopItemId)
    if not DataMgr.ShopItem2Cutoff[ShopItemId] then
        return
    end
    for _, CutoffId in pairs(DataMgr.ShopItem2Cutoff[ShopItemId]) do
        local CutoffData = DataMgr.Cutoff[CutoffId]
        local NowTime = TimeUtils.NowTime()
        if NowTime > CutoffData.CutoffStartTime and (not CutoffData.CutoffEndTime or NowTime < CutoffData.CutoffEndTime) then
            return CutoffData
        end
    end
end

-- 计算商品真实价格
function M:GetShopItemPrice(ShopItemId, VoucherId)
    local ShopItemData = DataMgr.ShopItem[ShopItemId]
    assert(ShopItemData, "商品不存在："..ShopItemId)
    if DataMgr.ShopItem2PayGoods[ShopItemId] then
        local PayGoodData = DataMgr.PayGoods[DataMgr.ShopItem2PayGoods[ShopItemId]]
        assert(PayGoodData, "充值商品对应信息不存在:"..DataMgr.ShopItem2PayGoods[ShopItemId])
        local PriceType = self:GetCurrencyPrice()
        local Price = PayGoodData[PriceType]
        return Price
    end
    local CutoffData = self:GetShopItemCutoffData(ShopItemId)
    local ShopItemPrice = ShopItemData.Price or 0
    if CutoffData then
        ShopItemPrice = CutoffData.CutoffPrice or ShopItemData.Price
    end
    ShopItemPrice = self:GetPriceAfterDiscount(ShopItemId, ShopItemPrice, VoucherId)
    return ShopItemPrice
end

--- 获取商城物品剩余限购次数
function M:GetShopItemPurchaseLimit(ShopItemId)
    if not ShopItemId then
        return 0
    end
    local Avatar = GWorld:GetAvatar()
	local ShopData = DataMgr.ShopItem[ShopItemId]
    local ShopNetData = Avatar.ShopItems[ShopItemId]
    local PurchaseLimit
    if not ShopNetData or not ShopNetData.RemainPurchaseTimes then
        if ShopData then
            PurchaseLimit = ShopData.PurchaseLimit
        end
    else
        PurchaseLimit = ShopNetData.RemainPurchaseTimes
    end
    return PurchaseLimit or -1
end
--获取剩余可赠送次数 -1则代表无次数限制
function M:GetGiftItemPurchaseLimit(ShopItemId,Uid)
    if not ShopItemId then
        ScreenPrint("没有传入商品:"..ShopItemId)
        return -1
    end
    local ShopData = DataMgr.ShopItem[ShopItemId]
    if not ShopData then
        ScreenPrint("商品不存在 SendGiftLimit:"..ShopItemId)
        return -1
    end
    local MaxTimes=ShopData.SendGiftLimit
    if not MaxTimes then
        return -1
    end
    local SentTimes=GiftModel:GetGiftHadSendCount(ShopItemId,Uid)
    local remain = MaxTimes - (SentTimes or 0)
    if remain < 0 then
        remain = 0
    end
    return remain
end
--获取商品最大赠送次数 -1则代表无次数限制
function M:GetGiftItemPurchaseTotalLimit(ShopItemId)
    if not ShopItemId then
        ScreenPrint("没有传入商品:"..ShopItemId)
        return -1
    end
    local MaxTimes = DataMgr.ShopItem[ShopItemId].SendGiftLimit
    if not MaxTimes then
        return -1
    end
    return MaxTimes
end

--- 获取当前上下文下的剩余和总限购（送礼/普通自动判断）
--- @param ShopItemId number 商品ID
--- @return number Remain, number Total
function M:GetContextRemainAndTotal(ShopItemId)
    local InGift = GiftController and GiftController:IsInGiftShop()
    if InGift then
        local GiftMain = GiftController and GiftController:GetGiftMainPage() or nil
        local Uid = GiftMain and GiftMain.FriendUid or nil
        local Remain = self:GetGiftItemPurchaseLimit(ShopItemId, Uid)
        local Total = self:GetGiftItemPurchaseTotalLimit(ShopItemId)
        return Remain, Total
    else
        local Remain = self:GetShopItemPurchaseLimit(ShopItemId)
        local ShopData = DataMgr.ShopItem[ShopItemId]
        local Total = ShopData and ShopData.PurchaseLimit or -1
        return Remain, Total
    end
end

--- 统一格式化限购文本：在有限制时返回 "标题+Remain/Total"，无限制返回空字符串
--- @param ShopItemId number 商品ID
--- @return string 限购文本或空字符串
function M:GetUnifiedLimitText(ShopItemId,InCludeText)
    local Remain, Total = self:GetContextRemainAndTotal(ShopItemId)
    if Remain == -1 or Total == -1 or Remain < 0 or Total < 0 then
        return ""
    end
    if InCludeText then  
        local InGift = GiftController and GiftController:IsInGiftShop() 
        local Key = InGift and "UI_SendGift_GiftItemMax" or "UI_SHOP_SHOPITEMLIMIT"
        return GText(Key)..Remain.."/"..Total
    end
    return Remain.."/"..Total
end
--- 是否显示折扣/超值文案（统一逻辑）
--- @param ShopItemId number 商品ID
--- @param ShopItemData table 商店商品配置（需包含 ShowBonus）
--- @return boolean 是否显示折扣
--- 说明：
--- - 送礼商店：ShowBonus 且（Unlimited 或 Remain>0）显示
--- - 普通商店：ShowBonus 且 非 SoldOutDisplay 显示
function M:ShouldShowDiscount(ShopItemId, ShopItemData)
    if not ShopItemData or not ShopItemData.ShowBonus then
        return false
    end
    local InGift = GiftController and GiftController:IsInGiftShop()
    if InGift then
        local Remain, Total = self:GetContextRemainAndTotal(ShopItemId)
        return (Remain == -1 or Total == -1) or (Remain > 0)
    else
        local Avatar = GWorld:GetAvatar()
        if not Avatar then return false end
        return not Avatar:CheckShopItemSoldOutDisplay(ShopItemId)
    end
end

--- 是否播放售罄入场动画（统一逻辑）
--- @param ShopItemId number 商品ID
--- @return boolean 是否播放售罄动画
function M:ShouldPlaySoldOutAnimation(ShopItemId)
    local Remain, Total = self:GetContextRemainAndTotal(ShopItemId)
    local Unlimited = (Remain == -1) or (Total == -1)
    return not (Unlimited or Remain > 0)
end

function M:GetGiftItemCanShow(ShopItemId,Uid)
    assert(DataMgr.ShopItem[ShopItemId], "商品不存在:"..ShopItemId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    if not Avatar:CheckIsEffective(ShopItemId) then
        return false
    end
    if self:GetGiftItemPurchaseLimit(ShopItemId,Uid) == 0 and not DataMgr.ShopItem[ShopItemId].RefreshTime and not DataMgr.ShopItem[ShopItemId].SoldOutDisplay then
        return false
    end
    if Avatar:CheckShopItemHasRequire(ShopItemId) then
        return false
    end
    if Avatar:CheckShopItemHasRexclusionGroup(ShopItemId) then
        return false
    end
    return true
end

--- 获取印象商城物品剩余限购次数
function M:GetImprShopItemPurchaseLimit(ShopItemId)
    local AvailableTime = 0
    local ShopItemData = DataMgr.ImpressionShop[ShopItemId]
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local Info = Avatar.ImpressionShops[ShopItemData.ImpressionShopId]
        if ShopItemData.PurchaseLimit and Info then
            local LimitTime = ShopItemData.PurchaseLimit
            AvailableTime = LimitTime - Info.AlreadyPurchaseTimes
        else
            AvailableTime = -1
        end
    end
    return AvailableTime
end

--- 判断是否显示该商品
function M:GetShopItemCanShow(ShopItemId)
    assert(DataMgr.ShopItem[ShopItemId], "商品不存在："..ShopItemId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    -- --- 如果是充值类商品，全部依赖服务器判断
    -- if DataMgr.ShopItem2PayGoods[ShopItemId] then
    --     return Avatar:CheckShopItemCanPurchase(ShopItemId)
    -- end

    --- 商城系统-是否处于上架期间
    if not Avatar:CheckIsEffective(ShopItemId) then
        return false
    end
    --- 商城系统-永久限购商品，限购次数为0后隐藏(并且非SoldOutDisplay)
    if self:GetShopItemPurchaseLimit(ShopItemId) == 0 and not DataMgr.ShopItem[ShopItemId].RefreshTime and not DataMgr.ShopItem[ShopItemId].SoldOutDisplay then
        return false
    end

    --- 商城系统-存在前置商品未购买
    if Avatar:CheckShopItemHasRequire(ShopItemId) then
        return false
    end

    --- 商城系统-存在互斥商品未购买
    if Avatar:CheckShopItemHasRexclusionGroup(ShopItemId) then
        return false
    end

    --- 商城系统-已持有唯一商品（并且非SoldOutDisplay）
    if Avatar:CheckShopItemUnique(ShopItemId) and not DataMgr.ShopItem[ShopItemId].SoldOutDisplay then
        return false
    end

    return true
end

--- 获取商品上次刷新时间
function M:GetRefreshTime(ItemId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local ShopNetData = Avatar.ShopItems[ItemId]
    --- 如果服务器上数据存在，直接采用服务器的数据
    if ShopNetData and ShopNetData.LastRefreshTime then
        return ShopNetData.LastRefreshTime
    end

    local ShopItemRefreshTimeType = {
        NOREFRESH = 0,
        HOUR = 1,
        DAY = 2,
        WEEK = 3,
        MONTH = 4,
    }
    local ShopItemInfo = DataMgr.ShopItem[ItemId]
    local RefreshTime = ShopItemInfo.RefreshTime
    local RefreshTimeType = ShopItemRefreshTimeType['NOREFRESH']
    if RefreshTime then
        for key,value in pairs(RefreshTime) do
            if ShopItemRefreshTimeType[key] then
                RefreshTimeType = ShopItemRefreshTimeType[key]
            end
        end
    end
    local StartTime
    local LastRefreshTime
    if ShopItemInfo.NewRefreshBeginTime then
        StartTime = ShopItemInfo.NewRefreshBeginTime
    else
        StartTime = TimeUtils.DataToTimestamp(CommonConst.ShopRefreshBeginTime[1],
                                            CommonConst.ShopRefreshBeginTime[2],
                                            CommonConst.ShopRefreshBeginTime[3],
                                            CommonConst.ShopRefreshBeginTime[4],
                                            CommonConst.ShopRefreshBeginTime[5],
                                            CommonConst.ShopRefreshBeginTime[6])
    end
    if RefreshTimeType == ShopItemRefreshTimeType['HOUR'] then
        local year, month, day, hour, min, sec = TimeUtils.TimestampToData(StartTime)
        LastRefreshTime = TimeUtils.DataToTimestamp(year, month, day, hour,0,0)
    elseif RefreshTimeType == ShopItemRefreshTimeType['DAY'] then
        local year, month, day, hour, min, sec = TimeUtils.TimestampToData(StartTime)
        local refresh_hms = CommonConst.GAME_REFRESH_HMS
        LastRefreshTime = TimeUtils.DataToTimestamp(year, month, day, table.unpack(refresh_hms))
    elseif RefreshTimeType == ShopItemRefreshTimeType['WEEK'] then
        StartTime = StartTime - CommonConst.SECOND_IN_WEEKDAY
        local refresh_hms = CommonConst.GAME_REFRESH_HMS
        LastRefreshTime = TimeUtils.NextWeeklyRefreshTime(StartTime,refresh_hms)
    elseif RefreshTimeType == ShopItemRefreshTimeType['MONTH'] then
        local year, month, day, hour, min, sec = TimeUtils.TimestampToData(StartTime)
        local refresh_hms = CommonConst.GAME_REFRESH_HMS
        LastRefreshTime = TimeUtils.DataToTimestamp(year, month, 1, table.unpack(refresh_hms))
    else
        LastRefreshTime = StartTime
    end
    return LastRefreshTime
end

-- 计算限时刷新时间
function M:RefreshShopRefreshTime(RefreshTime, Widget, ShopItemId)
    local ShopRefreshBeginTime = CommonConst.ShopRefreshBeginTime
    local StartTime = os.time{year=ShopRefreshBeginTime[1], month=ShopRefreshBeginTime[2], day=ShopRefreshBeginTime[3], 
    hour=ShopRefreshBeginTime[4], min=ShopRefreshBeginTime[5], sec=ShopRefreshBeginTime[6]}
    if ShopItemId then
        local LastRefreshTime = M:GetRefreshTime(ShopItemId)
        -- 断线重连早期没有 Avatar，GetRefreshTime 会返回 nil。
        -- 此时直接退出并移除定时器，避免 nil 算术报错。
        if not LastRefreshTime then
            if self and self.RemoveTimer then
                self:RemoveTimer("RefreshTimeTimer")
    end
            return
        end
        StartTime = LastRefreshTime
    end
    -- 转换为表结构
    local NextRefreshTimeTable = os.date("*t", StartTime)
    -- 计算下次刷新时间
    -- 如果单位是Hour、Day、Week，直接计算起始日期到当前日期时间差，求余数
    -- 如果单位是Month，则从起始日开始增加月数找到下一次刷新的时间
    local CurrentTime = TimeUtils.NowTime()
    local Interval = 0
    local timeDifference = 0
    local RemainRefreshTime = 0
    if RefreshTime.HOUR then
        Interval = RefreshTime.HOUR * 60 * 60
        timeDifference = CurrentTime - StartTime
        RemainRefreshTime = Interval - (timeDifference % Interval)
    elseif RefreshTime.DAY then
        Interval = RefreshTime.DAY * 60 * 60 * 24
        timeDifference = CurrentTime - StartTime
        RemainRefreshTime = Interval - (timeDifference % Interval)
    elseif RefreshTime.WEEK then
        StartTime = StartTime - CommonConst.SECOND_IN_WEEKDAY
        local refresh_hms = CommonConst.GAME_REFRESH_HMS
        local LastRefreshTime = TimeUtils.NextWeeklyRefreshTime(StartTime,refresh_hms)
        Interval = RefreshTime.WEEK * 7 * 60 * 60 * 24
        timeDifference = CurrentTime - LastRefreshTime
        RemainRefreshTime = Interval - (timeDifference % Interval)
    elseif RefreshTime.MONTH then
        local NowRealTime = os.date("*t", TimeUtils.NowTime())
        while (M:IsLaterThanNow(NextRefreshTimeTable, NowRealTime) == false) do
            if NextRefreshTimeTable.month + RefreshTime.MONTH > 12 then
                NextRefreshTimeTable.year = NextRefreshTimeTable.year + 1
                NextRefreshTimeTable.month = NextRefreshTimeTable.month + RefreshTime.MONTH - 12
            else
                NextRefreshTimeTable.month = NextRefreshTimeTable.month + RefreshTime.MONTH
            end
        end
        local NextRefreshTime = os.time(NextRefreshTimeTable)
        RemainRefreshTime = os.difftime(NextRefreshTime, TimeUtils.NowTime())
    end
    local RemainTimeStr = M:GetRefreshTimeStr(RemainRefreshTime)
    Widget:SetText(RemainTimeStr)
end

--- 获取倒计时文本
function M:GetRefreshTimeStr(RefreshTime)
    local RemainTimeStr = ""
    local TimeCount = 0
    if RefreshTime > 24 * 60 * 60 then
        TimeCount = TimeCount + 1
        RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_DAY"), math.floor(RefreshTime / (24 * 60 * 60)))
        RefreshTime = RefreshTime % (24 * 60 * 60)
    end
    if RefreshTime > 60 * 60 or TimeCount == 1 then
        TimeCount = TimeCount + 1
        RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_HOUR"), math.floor(RefreshTime / (60 * 60)))
        RefreshTime = RefreshTime % (60 * 60)
    end
    if (RefreshTime > 60 and TimeCount < 2) or TimeCount == 1 then
        TimeCount = TimeCount + 1
        RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_MINUTE"), math.floor(RefreshTime / 60))
        RefreshTime = RefreshTime % 60
    end
    if (RefreshTime > 0 and TimeCount < 2) or TimeCount == 1 then
        TimeCount = TimeCount + 1
        RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_SECOND"), math.floor(RefreshTime))
    end
    return RemainTimeStr
end

--- 获取下架倒计时文本
function M:UpdateLimitTime(ShopItemEndTime)
    local StartTiem = URuntimeCommonFunctionLibrary.GetDateTimeFromUnixTime(TimeUtils.NowTime())
    local EndTime = URuntimeCommonFunctionLibrary.GetDateTimeFromUnixTime(ShopItemEndTime and ShopItemEndTime.GetTime())
    local RemainTime = UKismetMathLibrary.Subtract_DateTimeDateTime(EndTime, StartTiem)
    local RemainTimeStr = ""
    local TimeCount = 0
    if UKismetMathLibrary.GetDays(RemainTime) > 0 then
        TimeCount = TimeCount + 1
        RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_DAY"), UKismetMathLibrary.GetDays(RemainTime))
    end
    if UKismetMathLibrary.GetHours(RemainTime) > 0 or TimeCount == 1 then
        TimeCount = TimeCount + 1
        RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_HOUR"), UKismetMathLibrary.GetHours(RemainTime))
    end
    if (UKismetMathLibrary.GetMinutes(RemainTime) > 0 and TimeCount < 2) or TimeCount == 1 then
        TimeCount = TimeCount + 1
        RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_MINUTE"), UKismetMathLibrary.GetMinutes(RemainTime))
    end
    if (UKismetMathLibrary.GetSeconds(RemainTime) > 0 and TimeCount < 2) or TimeCount == 1 then
        TimeCount = TimeCount + 1
        RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_SECOND"), UKismetMathLibrary.GetSeconds(RemainTime))
    end
    return string.format(GText("UI_SHOP_REMAINTIME"), RemainTimeStr)
end

--计算当前时间是否晚于Time
function M:IsLaterThanNow(Time, NowRealTime)
    local CurrentYear = NowRealTime.year
    local CurrentMonth = NowRealTime.month
    local CurrentDay = NowRealTime.day
    local CurrentHour = NowRealTime.hour
    if CurrentYear > Time.year then
        return false
    elseif CurrentYear == Time.year then
        if CurrentMonth > Time.month then
            return false;
        elseif CurrentMonth == Time.month then
            if CurrentDay > Time.day then
                return false
            elseif CurrentDay == Time.day then
                if CurrentHour >= Time.hour then
                    return false
                end
            end
        end
    end
    return true
end

--- 判断能否购买：失败原因：0:可购买 1:售罄 2:货币不足 3:等级限制 4:月石不足 5:月石晶胚不足 6:已持有唯一商品 7:工会战积分不足
function M:CanPurchase(ShopItemData, PriceType, Price)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    ShopItemData.PurchaseFailRes = 0
    local ShopItemRemainTimes = self:GetShopItemPurchaseLimit(ShopItemData.ItemId)
    if ShopItemRemainTimes == 0 then
        ShopItemData.PurchaseFailRes = 1
        return false
    end
    if Avatar:CheckShopItemUnique(ShopItemData.ItemId) then
        ShopItemData.PurchaseFailRes = 6
        return false
    end
    if ShopItemData.UnlockLevel and Avatar.Level < ShopItemData.UnlockLevel then
        ShopItemData.PurchaseFailRes = 3
        return false
    end
    if not Avatar:CheckShopItemUnlockRaidPoint(ShopItemData.ItemId) then
        ShopItemData.PurchaseFailRes = 7
        return false
    end
    if DataMgr.ShopItem2PayGoods[ShopItemData.ItemId] then
        return true
    end
    local PriceCount = Avatar.Resources[PriceType] and Avatar.Resources[PriceType].Count or 0
    if PriceCount < Price then
        if ShopItemData.PriceType == CommonConst.Coins.Coin1 then
            local totalCount = PriceCount + (Avatar.Resources[CommonConst.Coins.Coin4] and Avatar.Resources[CommonConst.Coins.Coin4].Count or 0)
            if totalCount >= Price then
                ShopItemData.PurchaseFailRes = 4
            else
                ShopItemData.PurchaseFailRes = 5
            end
            return true
        elseif ShopItemData.PriceType == CommonConst.Coins.Coin4 then
            ShopItemData.PurchaseFailRes = 5
            return true
        end
        ShopItemData.PurchaseFailRes = 2
        return false
    end
    return true
end

function M:Purchase(ShopItemData, ParentWidget)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    if DataMgr.ShopItem2PayGoods[ShopItemData.ItemId] then
        if ShopItemData.PurchaseFailRes == 0 then
            local Avatar = GWorld:GetAvatar()
            if not Avatar then
                return false
            end
            if not HeroUSDKSubsystem():IsHeroSDKEnable() then
                local GMFunctionLibrary = require "BluePrints.UI.GMInterface.GMFunctionLibrary"
                GMFunctionLibrary.ExecConsoleCommand(GWorld.GameInstance,"sgm pgi "..DataMgr.ShopItem2PayGoods[ShopItemData.ItemId])
                return
            end
            Avatar:RequestPay(DataMgr.ShopItem2PayGoods[ShopItemData.ItemId], function(ret, OrderId, CallbackUrl)
                if not ErrorCode:Check(ret) then 
                    return 
                end
                local PaymentParameters = FHeroUPaymentParameters()
                PaymentParameters.goodsId = DataMgr.ShopItem2PayGoods[ShopItemData.ItemId]
                PaymentParameters.cpOrder = OrderId
                PaymentParameters.callbackUrl = CallbackUrl

                local GameRoleInfo = HeroUSDKUtils.GenHeroHDCGameRoleInfo()
                local ItemName = ""
                ItemName = GText(ItemUtils:GetDropName(ShopItemData.TypeId, ShopItemData.ItemType))
    
                HeroUSDKSubsystem():HeroSDKPay(PaymentParameters, GameRoleInfo, ItemName);
                local TrackInfo = {}
                TrackInfo.product_id = DataMgr.ShopItem2PayGoods[ShopItemData.ItemId]
                if ShopItemData.ItemId then
                    TrackInfo.item_id = ShopItemData.ItemId
                    TrackInfo.product_type = DataMgr.ShopItem[ShopItemData.ItemId].ItemType
                end
                TrackInfo.game_order_id = OrderId
                TrackInfo.order_create_time = TimeUtils.NowTime()
                HeroUSDKSubsystem(self):UploadTrackLog_Lua("charge_client", TrackInfo)
            end)
        else
            UIManager(self):ShowError(ErrorCode.RET_SHOPITEM_REMAIN_PURCHASE_TIMES_EQUAL_ZERO,1.0,"CommonToastMain")
        end
        return
    end
    if ShopItemData.PurchaseFailRes ~= 0 then
        if ShopItemData.PurchaseFailRes == 1 then
            UIManager(GWorld.GameInstance):ShowError(ErrorCode.RET_SHOPITEM_REMAIN_PURCHASE_TIMES_EQUAL_ZERO, 1.0, "CommonToastMain")
        elseif ShopItemData.PurchaseFailRes == 2 then
            UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Shop_Toast_No_Coin"), GText(DataMgr.Resource[ShopItemData.PriceType].ResourceName)), 1.0)
        elseif ShopItemData.PurchaseFailRes == 3 then
            UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Shop_Toast_Locked"), ShopItemData.UnlockLevel), 1.0)
        elseif ShopItemData.PurchaseFailRes == 7 then
            UIManager(self):ShowUITip("CommonToastMain", string.format(GText("RaidDungeon_Shop_Locked"), ShopItemData.UnlockRaidPoint), 1.0)
        elseif ShopItemData.PurchaseFailRes == 6 then
            UIManager(GWorld.GameInstance):ShowError(ErrorCode.RET_SHOPITEM_UNIQUE_ALREDAY_OWNED,1.0,"CommonToastMain")
        elseif ShopItemData.PurchaseFailRes == 4 then
            local PopUpId =  100136
            local Avatar = GWorld:GetAvatar()
            if not Avatar then
                return
            end
            local ItemName = ItemUtils:GetDropName(ShopItemData.TypeId, ShopItemData.ItemType)

            local PriceCount = Avatar.Resources[ShopItemData.PriceType] and Avatar.Resources[ShopItemData.PriceType].Count or 0

            local PopoverText = GText(DataMgr.CommonPopupUIContext[PopUpId].PopoverText)
            if string.find(PopoverText,'&ResourceName&') then
                PopoverText = string.gsub(PopoverText,'&ResourceName&', GText(DataMgr.Resource[CommonConst.Coins.Coin4].ResourceName))
            end
            if string.find(PopoverText,'&ResourceName1&') then
                PopoverText = string.gsub(PopoverText,'&ResourceName1&', GText(DataMgr.Resource[CommonConst.Coins.Coin4].ResourceName))
            end
            if string.find(PopoverText,'&ResourceName2&') then
                PopoverText = string.gsub(PopoverText,'&ResourceName2&', GText(ItemName))
            end
            if string.find(PopoverText,'&Num1&') then
                PopoverText = string.gsub(PopoverText,'&Num1&',ParentWidget.CurrentCount * ParentWidget.UnitPrice - PriceCount)
            end
            if string.find(PopoverText,'&Num2&') then
                PopoverText = string.gsub(PopoverText,'&Num2&',ParentWidget.CurrentCount)
            end

            local Confirm = function()
                local Coin4Count = 0
                if Avatar.Resources[CommonConst.Coins.Coin4] then
                    Coin4Count =  Avatar.Resources[CommonConst.Coins.Coin4].Count
                end
                if ParentWidget.CurrentCount * ParentWidget.UnitPrice - PriceCount > Coin4Count then
                    local JumpToShop = function()
                        PageJumpUtils:JumpToShopPage(CommonConst.GachaJumpToShopMainTabId,nil,nil, "Shop")
                    end
                    local Params = {}
                    Params.Title = GText("UI_COMMONPOP_TITLE_100137")
                    Params.ShortText = GText("UI_COMMONPOP_TEXT_100137")
                    Params.LeftCallbackObj = self
                    Params.RightCallbackObj = self
                    Params.RightCallbackFunction = JumpToShop
                    UIManager(self):ShowCommonPopupUI(100137,Params, self)
                else
                    self:SendExchangeRequest(ShopItemData.ItemId, ParentWidget.CurrentCount)
                end
            end
            
            local ItemList = {}
            local Coin4Count = Avatar.Resources[CommonConst.Coins.Coin4] and Avatar.Resources[CommonConst.Coins.Coin4].Count or 0
            table.insert(ItemList,{ItemId = CommonConst.Coins.Coin4,
                ItemType = CommonConst.ItemType.Resource,
                ItemNum = Coin4Count,
                ItemNeed = ParentWidget.CurrentCount * ParentWidget.UnitPrice - PriceCount})
            local Params = {
                RightCallbackFunction = Confirm,
                ItemList = ItemList,
                ShortText = PopoverText
            }
            UIManager(self):ShowCommonPopupUI(PopUpId,Params)
        elseif ShopItemData.PurchaseFailRes == 5 then
            local JumpToShop = function()
                PageJumpUtils:JumpToShopPage(CommonConst.GachaJumpToShopMainTabId,nil,nil, "Shop")
            end
            local Params = {}
            Params.Title = GText("UI_COMMONPOP_TITLE_100138")
            Params.ShortText = GText("UI_COMMONPOP_TEXT_100198")
            Params.LeftCallbackObj = ParentWidget
            Params.RightCallbackObj = ParentWidget
            Params.RightCallbackFunction = JumpToShop
            UIManager(self):ShowCommonPopupUI(100137,Params, ParentWidget.ParentWidget)
        end
        return
    end
    local ShopMain = UIManager(self):GetUIObj("ShopMain")
    ShopMain:BlockAllUIInput(true)
    Avatar:PurchaseShopItem(ShopItemData.ItemId, 1)
end

function M:SendPurchaseRequest(ShopItemId, CurrentCount, VoucherId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    Avatar:PurchaseShopItem(ShopItemId, CurrentCount, nil, nil, VoucherId)
    local ShopMain = UIManager(self):GetUIObj("ShopMain")
    local ShopActivity = UIManager(self):GetUIObj("ActivityShop")
    local CommonShopActivity = UIManager(self):GetUIObj("ShopActivity")
    if ShopMain then
        ShopMain:BlockAllUIInput(true)
    end
    if ShopActivity then
        ShopActivity:BlockAllUIInput(true)
    end
    if CommonShopActivity then
        CommonShopActivity:BlockAllUIInput(true)
    end
end

function M:SendExchangeRequest(ShopItemId, CurrentCount, NotShow)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local Callback = function(Ret,ShopItemId,Count,PackRewards)
        EventManager:FireEvent(EventID.OnPurchaseShopItem, Ret, ShopItemId,CurrentCount)
		local ShopMain = UIManager(GWorld.GameInstance):GetUIObj("ShopMain")
        if ShopMain then
            ShopMain:BlockAllUIInput(false)
        end
        local SkinPreview = UIManager(GWorld.GameInstance):GetUIObj("SkinPreview")
		if SkinPreview then
			SkinPreview:BlockAllUIInput(false)
		end
		if Ret == ErrorCode.RET_SUCCESS then
			local ShopItemData = DataMgr.ShopItem[ShopItemId]
			if not NotShow then
				UIManager(GWorld.GameInstance):UnLoadUI("ShopItemSingle")
				UIManager(GWorld.GameInstance):UnLoadUI("ShopItemPackage")
				UIUtils.ShowGetItemPageAndOpenBagIfNeeded(ShopItemData.ItemType, ShopItemData.TypeId, ShopItemData.TypeNum*Count, PackRewards, ShopItemData.IsSpPopup)
			end
			EventManager:FireEvent(EventID.OnPurchaseShopItemSuccess, Ret, ShopItemData.TypeId, CurrentCount, PackRewards)
		elseif Ret == ErrorCode.RET_SHOPITEM_IS_NOT_VALID then
			UIManager(GWorld.GameInstance):UnLoadUI("ShopItemSingle")
			UIManager(GWorld.GameInstance):UnLoadUI("ShopItemPackage")
			UIManager(GWorld.GameInstance):ShowError(Ret,1.0,"CommonToastMain")
		elseif Ret == ErrorCode.RET_SHOPITEM_MONEY_NEEDED_NOT_ENOUGH then
			UIManager(GWorld.GameInstance):ShowError(Ret,1.0,"CommonToastMain")
		elseif Ret == ErrorCode.RET_SHOPITEM_REMAIN_PURCHASE_TIMES_EQUAL_ZERO then
			UIManager(GWorld.GameInstance):ShowError(Ret,1.0,"CommonToastMain")
		end
		if ShopMain then
			ShopMain:RefreshSubTabData(ShopMain.CurSubTabMap, true, true)
		end
        if SkinPreview then
			SkinPreview:RefreshPurchaseState()
		end
    end
    Avatar:PurchaseShopItemUseCoin1(ShopItemId, CurrentCount, Callback)

end

function M:ShowPurchaseDialog(ItemType, ItemId, ShopType, UIName)
    if not ItemType or not ItemId then
        return
    end
    if not ShopType then
        ShopType = "Shop"
    end
    if not (DataMgr.ShopItem2ShopSubId[ItemType] and DataMgr.ShopItem2ShopSubId[ItemType][ShopType] and DataMgr.ShopItem2ShopSubId[ItemType][ShopType][ItemId]) 
        and DataMgr.ShopItem2ShopSubId[ItemType][ShopType][ItemId].ShopItemId then
        return false
    end
    local SelectShopItemId
    for _, ShopItemData in ipairs(DataMgr.ShopItem2ShopSubId[ItemType][ShopType][ItemId]) do
        if ShopUtils:GetShopItemCanShow(ShopItemData.ShopItemId) and ShopUtils:GetShopItemPurchaseLimit(ShopItemData.ShopItemId) ~= 0 then
            SelectShopItemId = ShopItemData.ShopItemId
            break
        end
    end
    if not SelectShopItemId then
        return false
    end
    local ShopItemData = setmetatable({}, {__index = DataMgr.ShopItem[SelectShopItemId]})
    local FundId = ShopItemData.PriceType
    local FundNeed = ShopUtils:GetShopItemPrice(ShopItemData.ItemId)
    ShopUtils:CanPurchase(ShopItemData, FundId, FundNeed)
    if DataMgr.ShopItem2PayGoods[ShopItemData.ItemId] then
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
            return false
        end
        if not HeroUSDKSubsystem():IsHeroSDKEnable() then
            local GMFunctionLibrary = require "BluePrints.UI.GMInterface.GMFunctionLibrary"
            GMFunctionLibrary.ExecConsoleCommand(self:GetGameInstance(),"sgm pgi "..DataMgr.ShopItem2PayGoods[ShopItemData.ItemId])
            return
        end
        Avatar:RequestPay(DataMgr.ShopItem2PayGoods[ShopItemData.ItemId], function(ret, OrderId, CallbackUrl)
            if not ErrorCode:Check(ret) then 
                return 
            end
            local PaymentParameters = FHeroUPaymentParameters()
            PaymentParameters.goodsId = DataMgr.ShopItem2PayGoods[ShopItemData.ItemId]
            PaymentParameters.cpOrder = OrderId
            PaymentParameters.callbackUrl = CallbackUrl

            local GameRoleInfo = HeroUSDKUtils.GenHeroHDCGameRoleInfo()

            HeroUSDKSubsystem():HeroSDKPay(PaymentParameters, GameRoleInfo);
        end)
    else
        AudioManager(self):PlayItemSound(self,ShopItemData.TypeId,"Click",ShopItemData.ItemType)
        local RemainTimes = ShopUtils:GetShopItemPurchaseLimit(ShopItemData.ItemId)
        local ItemData = DataMgr[ShopItemData.ItemType][ShopItemData.TypeId]
        local bForbidden = not ShopUtils:CanPurchase(ShopItemData, ShopItemData.PriceType, ShopUtils:GetShopItemPrice(ShopItemData.ItemId))
        local CommonPopupUIID
        if UIUtils.CanOpenSkinPreview(ShopItemData.ItemType, ShopItemData.TypeId) then
            UIManager(self):LoadUINew("SkinPreview", ShopItemData, self)
        elseif ShopItemData.ItemType == "Reward" and (DataMgr.Reward[ItemData.RewardId].Mode == "Fixed" or DataMgr.Reward[ItemData.RewardId].Mode == "Once") then
            if ShopItemData.Bg == 1 then
                UIManager(self):LoadUINew("PayGiftPopup_Yellow", ShopItemData, self)
            elseif ShopItemData.Bg == 2 then
                UIManager(self):LoadUINew("PayGiftPopup_Purple", ShopItemData, self)
            else
                UIManager(self):LoadUINew("PayGiftPopup_Purple", ShopItemData, self)
            end
        else
            if RemainTimes == 0 or ShopItemData.PurchaseFailRes == 6 then
                CommonPopupUIID = 100042
            else
                CommonPopupUIID = 100041
            end
        end
        if not CommonPopupUIID then
            return
        end
        local Funds = {}
        Funds[1] = {}
        Funds[1].FundId = ShopItemData.PriceType
        Funds[1].FundNeed = ShopUtils:GetShopItemPrice(ShopItemData.ItemId)
        local ShopUIName = DataMgr.Shop[ShopType].ShopUIName

        ---@type WBP_Common_Dialog_PC_C
        local CommonDialog = UIManager(self):ShowCommonPopupUI(CommonPopupUIID, { ShopItemData = ShopItemData, ShopType = 0, Funds = Funds, ShowParentTabCoin = true, UIName = UIName,
            LeftCallbackObj = self,
            LeftCallbackFunction = function(Obj, PackageData)
                local Shop = UIManager(self):GetUIObj(ShopUIName)
                if Shop then
                    Shop:SetFocus()
                end
            end,
            RightCallbackObj = self,
            RightCallbackFunction = function(Obj, PackageData)
                PackageData.Content_1.CallFunc(PackageData.Content_1.CallObj)
            end,
            ForbiddenRightCallbackObj = self,
            ForbiddenRightCallbackFunction = function(Obj, PackageData)
                PackageData.Content_1.CallFunc(PackageData.Content_1.CallObj)
            end,
            DontFocusParentWidget = true,
            CloseBtnCallbackObj = self,
            CloseBtnCallbackFunction = function(Obj, PackageData)
                local Shop = UIManager(self):GetUIObj(ShopUIName)
                if Shop then
                    Shop:SetFocus()
                end
            end,
            ForbidRightBtn = not ShopUtils:CanPurchase(ShopItemData, Funds[1].FundId, Funds[1].FundNeed)
        }, UIManager(self):GetUIObj(ShopUIName))
    end

end

--- 获取当前商品所需充值金额
function M:GetNeedRechargeCount(ShopItemId, PriceType, CostNum, VoucherId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local OwnedResource = Avatar.Resources[PriceType]
    local OwnedCurrencyAmount = OwnedResource and OwnedResource.Count or 0
    local Cost = 0
    if CostNum and CostNum ~= 0 then
        Cost = CostNum
    end
    if ShopItemId then
        Cost = ShopUtils:GetShopItemPrice(ShopItemId, VoucherId) or 0
    end
    if CommonConst.Coins.Coin1 == PriceType then
        local Coin4Data = Avatar.Resources[CommonConst.Coins.Coin4]
        local Coin4Count = Coin4Data and Coin4Data.Count or 0
        OwnedCurrencyAmount = OwnedCurrencyAmount + Coin4Count
    end
    local NeedCount = Cost - OwnedCurrencyAmount
    if NeedCount <= 0 then
        return 0
    end
    return NeedCount
end

--- 获取当前商品所需直充商品的信息
function M:GetRechargeItem(ShopItemId, PriceType, CostNum, VoucherId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local OwnedResource = Avatar.Resources[PriceType]
    local OwnedCurrencyAmount = OwnedResource and OwnedResource.Count or 0
    if CommonConst.Coins.Coin1 == PriceType then
        local Coin4Data = Avatar.Resources[CommonConst.Coins.Coin4]
        local Coin4Count = Coin4Data and Coin4Data.Count or 0
        OwnedCurrencyAmount = OwnedCurrencyAmount + Coin4Count
    end
    local Cost = 0
    if CostNum and CostNum ~= 0 then
        Cost = CostNum
    end
    if ShopItemId then
        Cost = ShopUtils:GetShopItemPrice(ShopItemId, VoucherId) or 0
    end
    local NeedCount = Cost - OwnedCurrencyAmount
    if NeedCount <= 0 then
        return
    end
    local NeedShopItemData
    for i, Id in ipairs(Const.ReChargeLst) do
        if DataMgr.ShopItem[Id] then
            local Count = DataMgr.ShopItem[Id].TypeNum
            if Avatar:CheckIsFirstBonus(Id) then
                Count = Count + DataMgr.FirstBonusNum[Id].FirstBonusNum
            else
                Count = Count + DataMgr.FirstBonusNum[Id].BonusNum
            end
            NeedShopItemData = DataMgr.ShopItem[Id]
            if Count >= NeedCount then
                break
            end
        end
    end
    return NeedShopItemData
end

-- 注册关闭获取道具页面回调
function M:SetCloseGetItemPageCallback(Params)
    self.CloseGetItemPageCallback = Params.CloseGetItemPageCallback
end

-- 获取关闭获取道具页面回调
function M:GetCloseGetItemPageCallback()
    local Callback = self.CloseGetItemPageCallback
    self.CloseGetItemPageCallback = nil
    return Callback
end


function M:GetCharWeaponHasLevelMax(ShopItemId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local ShopItemData = DataMgr.ShopItem[ShopItemId]
    if ShopItemData.ItemType == "Walnut" then
        local WalnutData = DataMgr.Walnut[ShopItemData.TypeId]
        local GradeLevel = 0
        if WalnutData.MainRewardType == "Char" then
            for CharUid, Data in pairs(Avatar.Chars) do
                if Data.CharId == WalnutData.MainRewardId then
                    if DataMgr.UltraCharCardLevelUp[Data.CharId] and Data.ExtraGradeLevel > 0 then
                        return true
                    end
                    GradeLevel = Data.GradeLevel
                    break
                end
            end
            if not DataMgr.UltraCharCardLevelUp[WalnutData.MainRewardId] and GradeLevel == DataMgr.GlobalConstant.CharCardLevelMax.ConstantValue then
                return true
            end
        elseif WalnutData.MainRewardType == "Weapon" then
            for WeaponUid, Data in pairs(Avatar.Weapons) do
                if Data.WeaponId == WalnutData.MainRewardId then
                    if Data.GradeLevel >= DataMgr.WeaponCardLevel[Data.WeaponId].CardLevelMax then
                        return true
                    end
                end
            end
        end
    end
    return false
end

---------------------------------------------- Banner相关 ----------------------------------------------
--- 获取当前有效Banner页

local ForbiddenBannerBp = {
    ["WBP_Shop_Banner_MonthCard"] = true
}


--- 获取Banner页数据，bSwitchTab表示是否是第一个轮播的Banner信息
function M:GetBannerInfo(bSwitchTab)
    local BannerIdDict = {}
    local BannerData = {}
    local SmallBannerData = {}
    local SoldOutBannerData = {}
    local Time = TimeUtils.NowTime()
    local bForbiddenPurchase = not self:IsCanOpenPay(true)
    for _, v in pairs(DataMgr.ShopBannerTab) do
        if v.IsSwitchTab == bSwitchTab then
            if ((not bForbiddenPurchase) or (not ForbiddenBannerBp[v.Bp])) and Time >= v.StartTime then
                local isExpired = v.EndTime and Time > v.EndTime
                if not isExpired then
                    if v.ShortTabSequence then
                        table.insert(SmallBannerData, v)
                    else
                        if v.BannerType == UIConst.ShopBannerType.DailyPack then
                            local DisplayableItems = self:GetDailyPackShopItemInfo(v.Id)
                            --- 无有效分日礼包
                            if #DisplayableItems == 0 then
                                goto continue
                            end
                        end
                        local DailyPackSoldOut = v.BannerType == UIConst.ShopBannerType.DailyPack and self:ShouldSinkDailyPackTab(v)
                        local MonthCardSoldOut = v.BannerType == UIConst.ShopBannerType.MonthCard and MonthCardModel:IsMonthCardPurchased()
                        if (v.SoldOutSinkBanner and v.ItemId and self:GetShopItemPurchaseLimit(v.ItemId) == 0) or MonthCardSoldOut or DailyPackSoldOut then
                            table.insert(SoldOutBannerData, v)
                        else
                            table.insert(BannerData, v)
                        end
                        BannerIdDict[v.Id] = true
                    end
                else
                    if v.BannerType == UIConst.ShopBannerType.DailyPack then
                        if not self:ShouldHideDailyPackTab(v) then
                            table.insert(SoldOutBannerData, v)
                            BannerIdDict[v.Id] = true
                        end
                    end
                end
            end
        end
        ::continue::
    end
    table.sort(SmallBannerData, function(a, b)
        return a.ShortTabSequence < b.ShortTabSequence
    end)

    table.sort(BannerData, function(a,b )
        return a.Sequence < b.Sequence
    end)
    table.sort(SoldOutBannerData, function(a,b )
        return a.Sequence < b.Sequence
    end)
    local Res = {}
    for _, ShopData in ipairs(BannerData) do
        table.insert(Res, ShopData)
    end
    for _, ShopData in ipairs(SoldOutBannerData) do
        table.insert(Res, ShopData)
    end
    return Res, BannerIdDict, SmallBannerData
end

---------------------------------------------- 整合页相关 ----------------------------------------------

function M:GetComplexInfo(SubTabId)
    local ComplexData = {}
    for _, v in pairs(DataMgr.ComplexTab) do
        if v.SubTabId == SubTabId then
            table.insert(ComplexData, v)
        end
    end

    table.sort(ComplexData, function(a, b)
        return a.EntrySort > b.EntrySort
    end)
    return ComplexData
end

---------------------------------------------- 商城外观预览相关 -------------------------------------------

function M:GetShopSkinList()
    local Shop = UIManager(self):GetLastJumpPage()
    if Shop then
        return Shop.Index2ShopSkin, Shop.ShopSkin2Index, Shop.SkinCount
    end

    local ShopMain = UIManager(self):GetUIObj("ShopMain")
    if ShopMain then
        return ShopMain.Index2ShopSkin, ShopMain.ShopSkin2Index, ShopMain.SkinCount
    end

    local ShopActivity = UIManager(self):GetUIObj("ActivityShop")
    if ShopActivity then
        return ShopActivity.Index2ShopSkin, ShopActivity.ShopSkin2Index, ShopActivity.SkinCount
    end

    local CommonShopActivity = UIManager(self):GetUIObj("ShopActivity")
    if CommonShopActivity then
        return CommonShopActivity.Index2ShopSkin, CommonShopActivity.ShopSkin2Index, CommonShopActivity.SkinCount
    end

    return nil
end

---根据道具id查询商品
function M:GetShopItemDataById(Id,ShopItemType,bCheck)
    local TypeId2ShopItems = DataMgr.TypeId2ShopItem[ShopItemType]
    TypeId2ShopItems = TypeId2ShopItems and TypeId2ShopItems[Id]
    local ShopItemId
    local ShopItemData
    if(TypeId2ShopItems)then
        local Priority = nil
        for _, value in pairs(TypeId2ShopItems) do
            local Data = DataMgr.ShopItem[value]
            if(Data and (Priority == nil or Priority < (Data.IsAccessItem or Priority)))then
                local bChecked
                if(bCheck)then
                    Data = setmetatable({}, {__index = Data})
                    bChecked = self:GetShopItemCanShow(value) and self:CanPurchase(Data,nil,0)
                else
                    bChecked = true
                end
                if(bChecked)then
                    Priority = Data.IsAccessItem
                    ShopItemId = value
                    ShopItemData = Data
                end
            end
        end
    end
    return ShopItemId,ShopItemData
end

---------------------------------------------- 分日礼包相关 -------------------------------------------

function M:GetDailyPackShopItemInfo(BannerId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return {}
    end

    local DailyPackShopItemInfo = {}
    for _, DailyPackData in pairs(DataMgr.DailyPack) do
        if DailyPackData.BannerId == BannerId then
            local ShopItemId = DataMgr.PayGoods[DailyPackData.GoodsId].ItemId
            if not ShopItemId then
                DebugPrint("请检查一下分日礼包对应的PayGoods:["..tostring(DailyPackData.GoodsId).."] 是否填写了商店商品ID")
                goto continue
            end

            local ShopData = DataMgr.ShopItem[ShopItemId]
            if not ShopData then
                DebugPrint("请检查一下分日礼包对应的商店商品ID:["..tostring(ShopItemId).."] 是否存在")
                goto continue
            end

            local ShouldShow = false
            if Avatar:CheckIsEffective(ShopItemId) then
                ShouldShow = true
            else
                if self:ShouldShowCompletionTime(ShopData.TypeId) then
                    ShouldShow = true
                else
                    DebugPrint("请检查一下分日礼包对应的商店商品ID:["..tostring(ShopItemId).."] 是否在上架时间内")
                end
            end

            if ShouldShow then
                local PlayerDailyPack = Avatar.DailyPacks[ShopData.TypeId]
                local AugmentedData = setmetatable({}, {__index = ShopData})
                AugmentedData.Reward = DailyPackData.Reward
                if PlayerDailyPack then
                    AugmentedData.ExpiredTime = PlayerDailyPack.ExpiredTime
                    AugmentedData.State = PlayerDailyPack.State
                    AugmentedData.Count = PlayerDailyPack.Count
                    AugmentedData.RewardGot = PlayerDailyPack.RewardGot
                end

                table.insert(DailyPackShopItemInfo, AugmentedData)
            end
        end
        ::continue::
    end

    -- local Avatar = GWorld:GetAvatar()
    -- if not Avatar then
    --     return
    -- end
    -- local DailyPackShopItemInfo = {}
    -- for _, DailyPackData in pairs(DataMgr.DailyPack) do
    --     if DailyPackData.BannerId == BannerId then
    --         local ShopItemId = DataMgr.PayGoods[DailyPackData.GoodsId].ItemId
    --         local ShopData = DataMgr.ShopItem[ShopItemId]
    --         local PlayerDailyPack = Avatar.DailyPacks[ShopData.TypeId]
    --         ShopData = setmetatable({}, {__index = ShopData})
    --         ShopData.Reward = DailyPackData.Reward
    --         if Avatar:CheckIsEffective(ShopItemId) then
    --             if PlayerDailyPack then
    --                 ShopData.ExpiredTime = PlayerDailyPack.ExpiredTime
    --                 ShopData.State = PlayerDailyPack.State
    --                 ShopData.Count = PlayerDailyPack.Count
    --                 ShopData.RewardGot = PlayerDailyPack.RewardGot
    --             end
    --             table.insert(DailyPackShopItemInfo, ShopData)
    --         else
    --             if PlayerDailyPack then
    --                 local CurTime = TimeUtils.NowTime()
    --                 if CurTime < PlayerDailyPack.ExpiredTime and PlayerDailyPack.State == 1 then
    --                     ShopData.ExpiredTime = PlayerDailyPack.ExpiredTime
    --                     ShopData.State = PlayerDailyPack.State
    --                     ShopData.Count = PlayerDailyPack.Count
    --                     ShopData.RewardGot = PlayerDailyPack.RewardGot
    --                     table.insert(DailyPackShopItemInfo, ShopData)
    --                 end
    --             end
    --         end
    --     end
    -- end
    table.sort(DailyPackShopItemInfo, function(A, B)
        local SequenceA = A.Sequence
        local SequenceB = B.Sequence
        return SequenceA < SequenceB
    end)
    return DailyPackShopItemInfo
end

function M:ShouldShowRemainingTime(ShopItemId)
    if not ShopItemId then
        return false
    end

    local ShopItemData = DataMgr.ShopItem[ShopItemId]
    if not ShopItemData then
        return false
    end

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end

    if not Avatar:CheckIsEffective(ShopItemId) then
        return false
    end

    if not ShopItemData.PurchaseLimit or ShopItemData.PurchaseLimit <= 0 then
        return true
    end

    local PlayerShopItem = Avatar.ShopItems[ShopItemId]
    if not PlayerShopItem then
        return true
    end

    return PlayerShopItem.RemainPurchaseTimes > 0
end

function M:ShouldShowCompletionTime(DailyPackId)
    if not DailyPackId then
        return false
    end

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end

    local PlayerDailyPack = Avatar.DailyPacks[DailyPackId]

    if not PlayerDailyPack then
        return false
    end

    local StartTiem = URuntimeCommonFunctionLibrary.GetDateTimeFromUnixTime(TimeUtils.NowTime())
    local EndTime = URuntimeCommonFunctionLibrary.GetDateTimeFromUnixTime(PlayerDailyPack.ExpiredTime)
    local RemainTime = UKismetMathLibrary.Subtract_DateTimeDateTime(EndTime, StartTiem)

    return PlayerDailyPack.State == 1 and UKismetMathLibrary.GetDays(RemainTime) > 0

end

function M:GetDailyPackItemsForBanner(BannerId)
    local DailyPackItems = {}
    for _, DailyPackData in pairs(DataMgr.DailyPack) do
        if DailyPackData.BannerId == BannerId then
            if DataMgr.PayGoods[DailyPackData.GoodsId] then
                local ShopItemId = DataMgr.PayGoods[DailyPackData.GoodsId].ItemId
                if DataMgr.ShopItem[ShopItemId] then
                    table.insert(DailyPackItems, DataMgr.ShopItem[ShopItemId])
                end
            end
        end
    end
    return DailyPackItems
end

function M:ShouldSinkDailyPackTab(BannerData)
    if not BannerData then
        return false
    end

    local DailyPackItems = self:GetDailyPackItemsForBanner(BannerData.Id)

    if #DailyPackItems == 0 then
        return false
    end

    local Avatar = GWorld:GetAvatar()
    if not Avatar then return false end

    for _, itemData in ipairs(DailyPackItems) do
        local PlayerShopItem = Avatar.ShopItems[itemData.ItemId]
        if not PlayerShopItem or PlayerShopItem.RemainPurchaseTimes > 0 then
            return false
        end
    end

    return true
end

function M:ShouldHideDailyPackTab(BannerData)
    if not BannerData then
        return false
    end

    local DailyPackItems = self:GetDailyPackItemsForBanner(BannerData.Id)

    if #DailyPackItems == 0 then
        return true
    end

    local Avatar = GWorld:GetAvatar()
    if not Avatar then return false end
    local NowTime = TimeUtils.NowTime()

    for _, itemData in ipairs(DailyPackItems) do
        local DailyPackId = itemData.TypeId
        -- local PlayerDailyPack = Avatar.DailyPacks[DailyPackId]
        -- local isStillActive = PlayerDailyPack and PlayerDailyPack.ExpiredTime > NowTime and PlayerDailyPack.State == 1
        local isStillActive = self:ShouldShowCompletionTime(DailyPackId)

        if isStillActive then
            return false
        end
    end

    return true
end

--- 获取剩余领取文本
function M:UpdateRewardEndTime(ShopItemExpiredTime)
    local StartTime = URuntimeCommonFunctionLibrary.GetDateTimeFromUnixTime(TimeUtils.NowTime())
    local EndTime = URuntimeCommonFunctionLibrary.GetDateTimeFromUnixTime(ShopItemExpiredTime)
    local RemainTime = UKismetMathLibrary.Subtract_DateTimeDateTime(EndTime, StartTime)
    local RemainTimeStr = ""
    if UKismetMathLibrary.GetDays(RemainTime) > 0 then
        RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_DAY"), UKismetMathLibrary.GetDays(RemainTime))
    end
    return string.format(GText("UI_SHOP_REMAINTIME"), RemainTimeStr)
end

---------------------------------------------- 送礼相关 -------------------------------------------

function M:CanSendGift()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    local PlayerLevel = Avatar.Level or 0
    if DataMgr.GiftConstant.GiftLimitLevel and PlayerLevel < DataMgr.GiftConstant.GiftLimitLevel.ConstantValue1 then
        return false
    end
    local SendGiftCount = Avatar.CurrentMonthSendGiftCount or 0
    if DataMgr.GiftConstant.GiftCountPerMonth_S and SendGiftCount >= DataMgr.GiftConstant.GiftCountPerMonth_S.ConstantValue1 then
        return false
    end
    local ConsumeGiftQuota, TotalGiftQuota = Avatar.ConsumeGiftQuota, Avatar.TotalGiftQuota
    if ConsumeGiftQuota >= TotalGiftQuota then
        return false
    end
    return true
end

--- 0:可购买 1:售罄 2:货币不足 3:等级限制 4:月石不足 5:月石晶胚不足 6:已持有唯一商品 7:工会战积分不足
function M:ShowSendGiftButton(ShopItemData)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    if Avatar.BanGiftSend then
        return false
    end
    if not ShopItemData then
        return false
    end
    if ShopItemData.PurchaseFailRes == 0 then
        return true
    elseif ShopItemData.PurchaseFailRes == 1 then
        return true
    elseif ShopItemData.PurchaseFailRes == 2 then
        return true
    elseif ShopItemData.PurchaseFailRes == 3 then
        return false
    elseif ShopItemData.PurchaseFailRes == 4 then
        return true
    elseif ShopItemData.PurchaseFailRes == 5 then
        return true
    elseif ShopItemData.PurchaseFailRes == 6 then
        return false
    elseif ShopItemData.PurchaseFailRes == 7 then
        return true
    end
    return false
end

function M:OpenChooseGiftTarget(ShopItemId, ParentWidget)
    if not ShopItemId then
        return
    end
    GiftController:OpenSelectFriendPopup(ShopItemId, ParentWidget)
end

function M:OpenForbidGiftChooseTip()
    GiftController:OpenCanNotSendPopup()
end


---------------------------------------------- 商品解锁条件相关 -------------------------------------------

function M:CheckShopItemCondition(ShopItemData)
    if not ShopItemData then
        return true
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return true
    end
    return ShopItemData.ItemCondition and (not Avatar:CheckCondition(ShopItemData.ItemCondition))
end

function M:OpenLockConditionPopup(ShopItemData)
    if not ShopItemData then
        return
    end
    local Params = {}
    Params.ItemConditions = ShopItemData.ItemCondition
    UIManager(self):ShowCommonPopupUI(100292, Params)
end

---------------------------------------------- 商品折扣券相关 -------------------------------------------

function M:GetValidVouchers(ShopItemData)
    local ValidVouchers = {}

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return ValidVouchers
    end

    if DataMgr.ShopItem2PayGoods and DataMgr.ShopItem2PayGoods[ShopItemData.ItemId] then
        return ValidVouchers
    end

    if ShopItemData.PurchaseLimit ~= 1 then
        return ValidVouchers
    end

    local RealPrice = self:GetShopItemPrice(ShopItemData.ItemId)
    for VoucherId, VoucherInfo in pairs(DataMgr.Voucher) do
        local ResId = VoucherInfo.ResourceId
        local PlayerRes = Avatar.Resources[ResId]
        local LimitedInfo = ItemUtils.GetItemLimitedInfo(ResId)

        if PlayerRes and PlayerRes.Count > 0 then
            local bIsValidItem = false
            if VoucherInfo.ItemId and #VoucherInfo.ItemId > 0 then
                for _, TargetId in ipairs(VoucherInfo.ItemId) do
                    if TargetId == ShopItemData.ItemId then
                        bIsValidItem = true
                        break
                    end
                end
            else
                if VoucherInfo.CoinResourceId == ShopItemData.PriceType then
                    bIsValidItem = true
                end
            end

            if bIsValidItem then
                local Threshold = VoucherInfo.ThresholdPrice or 0
                if RealPrice >= Threshold then
                    local MergedData = {}
                    local ResConfig = DataMgr.Resource[ResId]
                    if ResConfig then
                        for k, v in pairs(ResConfig) do MergedData[k] = v end
                    end
                    for k, v in pairs(VoucherInfo) do MergedData[k] = v end
                    MergedData.VoucherNum = PlayerRes.Count
                    MergedData.ActualDiscount = math.min(VoucherInfo.DiscountPrice or 0, RealPrice)
                    MergedData.ExpireTime = LimitedInfo and LimitedInfo.EndTime or math.huge
                    table.insert(ValidVouchers, MergedData)
                end
            end
        end
    end

    table.sort(ValidVouchers, function(a, b)
        local isSpecificA = (a.ItemId ~= nil and #a.ItemId > 0)
        local isSpecificB = (b.ItemId ~= nil and #b.ItemId > 0)
        
        if isSpecificA ~= isSpecificB then 
            return isSpecificA 
        end

        local actualA = a.ActualDiscount or 0
        local actualB = b.ActualDiscount or 0
        if actualA ~= actualB then
            return actualA > actualB
        end
        
        local discountA = a.DiscountPrice or 0
        local discountB = b.DiscountPrice or 0
        if discountA ~= discountB then
            return discountA < discountB
        end

        local timeA = a.ExpireTime
        local timeB = b.ExpireTime
        if timeA ~= timeB then
            return timeA < timeB
        end
        
        return (a.VoucherId or 0) < (b.VoucherId or 0)
    end)

    return ValidVouchers
end

function M:GetBestVoucher(ValidVouchers)
    if ValidVouchers and #ValidVouchers > 0 then
        return ValidVouchers[1] -- 排序后的第一个就是最优折扣
    end
    return nil
end

function M:GetPriceAfterDiscount(ShopItemId, ShopItemPrice, VoucherId)
    if not VoucherId or VoucherId <= 0 then
        return ShopItemPrice
    end

    local ShopItemData = DataMgr.ShopItem[ShopItemId]
    if not ShopItemData then
        return ShopItemPrice 
    end

    if DataMgr.ShopItem2PayGoods[ShopItemId] or ShopItemData.PurchaseLimit ~= 1 then
        DebugPrint(string.format("[Warning] GetPriceAfterDiscount: Item %d is NOT allowed to use vouchers!", ShopItemId))
        return ShopItemPrice
    end

    local VoucherInfo = DataMgr.Voucher[VoucherId]
    if VoucherInfo then
        local Threshold = VoucherInfo.ThresholdPrice or 0
        if ShopItemPrice >= Threshold then
            local Discount = VoucherInfo.DiscountPrice or 0
            ShopItemPrice = math.max(ShopItemPrice - Discount, 0)
        else
            DebugPrint(string.format("[Warning] GetPriceAfterDiscount: Voucher %d threshold (%d) not met for Item %d (Price: %d)", VoucherId, Threshold, ShopItemId, ShopItemPrice))
        end
    else
        DebugPrint("[Error] GetPriceAfterDiscount: Invalid VoucherId passed: " .. tostring(VoucherId))
    end

    return ShopItemPrice
end

-- 判断该商品是否具有可使用的折扣券
function M:HasAnyVoucherConfig(ShopItemId)
    local ShopItemData = DataMgr.ShopItem[ShopItemId]
    if not ShopItemData then return false end

    if DataMgr.ShopItem2PayGoods[ShopItemId] or ShopItemData.PurchaseLimit ~= 1 then
        return false
    end

    for _, VoucherInfo in pairs(DataMgr.Voucher or {}) do
        
        if VoucherInfo.ItemId and #VoucherInfo.ItemId > 0 then
            for _, TargetId in ipairs(VoucherInfo.ItemId) do
                if TargetId == ShopItemId then
                    return true
                end
            end
        end
        
    end

    return false
end

return M
