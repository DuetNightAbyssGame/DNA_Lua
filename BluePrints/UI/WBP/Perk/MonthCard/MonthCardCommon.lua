--- 月卡常量相关

local MonthCardCommon = {}

MonthCardCommon.UIName = "MonthCardPageMain"

MonthCardCommon.PopUpName = "MonthCardPopup"

-- --- 多语言图片相关
--  MonthCardCommon.ImageTitlePath = {
--     [CommonConst.SystemLanguages.CN] = "/Game/UI/Texture/Dynamic/Image/Lang/ZH_CHS/T_Shop_MonthCardTitle.T_Shop_MonthCardTitle",
--     [CommonConst.SystemLanguages.TC] = "/Game/UI/Texture/Dynamic/Image/Lang/ZH_CHT/T_Shop_MonthCardTitle.T_Shop_MonthCardTitle",
--     [CommonConst.SystemLanguages.EN] = "/Game/UI/Texture/Dynamic/Image/Lang/EN/T_Shop_MonthCardTitle.T_Shop_MonthCardTitle",
--     [CommonConst.SystemLanguages.JP] = "/Game/UI/Texture/Dynamic/Image/Lang/JP/T_Shop_MonthCardTitle.T_Shop_MonthCardTitle",
--     [CommonConst.SystemLanguages.KR] = "/Game/UI/Texture/Dynamic/Image/Lang/KR/T_Shop_MonthCardTitle.T_Shop_MonthCardTitle",
-- }

-- MonthCardCommon.TextPurchased = "月卡生效中（待配置TEXT_MAP）"
-- MonthCardCommon.TextNotPurchased = "月卡未购买（待配置TEXT_MAP）"
MonthCardCommon.TextTitleBack = "UI_MonthlyCard_Title_2"
MonthCardCommon.TextTitleFront = "UI_MonthlyCard_Title_1"

MonthCardCommon.TextGetReward = "UI_MonthlyCard_BuyReward"
MonthCardCommon.TextEveryDayGetReward = "UI_MonthlyCard_DailyReward"

MonthCardCommon.TextBuyButton = "UI_MonthlyCard_Buy"

MonthCardCommon.TextLastDay = "UI_MonthlyCard_DateRemain"
MonthCardCommon.TextNotValidMohthCard = "UI_MonthlyCard_None"

MonthCardCommon.TextMonthCardDetail = "UI_MonthlyCard_Detail_1"

MonthCardCommon.TextMonthCardInfo = "UI_MonthlyCard_Detail_2"

MonthCardCommon.RefreshMonthCardLeftDaysKey = "RefreshMonthCardLeftDays"

MonthCardCommon.TextToastCannotPurchase = "UI_MonthlyCard_BuyMax"

MonthCardCommon.TextMonthCardPopTitle = "UI_MonthlyCard_Name"

MonthCardCommon.TextMonthCardPopTimeTitle = "UI_MonthlyCard_DateRemain"
MonthCardCommon.TextMonthCardPopTime = "UI_SHOP_REMAINTIME_DAY"
MonthCardCommon.TextMonthCardPopContinueTip = "UI_Anyplace_Open"
MonthCardCommon.TextMonthCardPopCloseTip = "UI_Armory_ClickEmpty"

MonthCardCommon.TextMonthCardPopCloseTipGamepad = "UI_CTL_Continue"

MonthCardCommon.TextMonthCardVaildTime = "UI_MonthlyCard_SellRemain"

MonthCardCommon.EventId = {
    TimeTick = "TimeTick", --每秒事件，刷新时长相关显示
    MonthCardRefresh = "MonthCardRefresh", --当前售卖月卡刷新事件（只刷新，不代表状态变化了）
    PurchaseStateRefresh = "PurchaseStateRefresh", --可购买状态刷新事件
    PurchasedRefresh = "PurchasedRefresh", --月卡购买状态刷新事件
}

return MonthCardCommon