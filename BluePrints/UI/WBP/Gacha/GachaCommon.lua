--- 月卡常量相关

local GachaCommon = {}

GachaCommon.UIName = "GachaMain"
GachaCommon.GachaItemTypeMap = {
    [0] = "Char",
    [1] = "Weapon",
    [2] = "Skin",
    [3] = "WeaponSkin",
    [4] = "CharAccessory",
    [5] = "WeaponAccessory",
    [6] = "Resource",
}
GachaCommon.GACHA_PROBABILITY_BASE = 10000 --抽卡概率计算分母

GachaCommon.GachaOneResult = 1 --单次结果数量
GachaCommon.GachaTenResults = 10 --十次结果数量

GachaCommon.GachaType = {
    NORMAL = "GACHA_SKIN_TYPE_NORMAL",
    SPECIAL = "GACHA_SKIN_TYPE_SPECIAL",
}

GachaCommon.RarityName = {
    [6] = "UI_SkinGacha_Skin_Red",
    [5] = "UI_SkinGacha_Skin_Gold",
    [4] = "UI_SkinGacha_Skin_Purple",
    [3] = "UI_SkinGacha_Skin_Blue",
}

GachaCommon.ItemRarityName = {
    [6] = "UI_SkinGacha_Item_Red",
    [5] = "UI_SkinGacha_Item_Gold",
    [4] = "UI_SkinGacha_Item_Purple",
    [3] = "UI_SkinGacha_Item_Blue",
    [2] = "UI_SkinGacha_Item_Green",
    [1] = "UI_SkinGacha_Item_White",
}

GachaCommon.BgWidget = {
    [1] = "WidgetBlueprint'/Game/UI/WBP/GachaNew/Widget/GachaGet/WBP_GachaGet_Widget_Normal.WBP_GachaGet_Widget_Normal'",
    [2] = "WidgetBlueprint'/Game/UI/WBP/GachaNew/Widget/GachaGet/WBP_GachaGet_Widget_SuperCoin.WBP_GachaGet_Widget_SuperCoin'",
    [3] = "WidgetBlueprint'/Game/UI/WBP/GachaNew/Widget/GachaGet/WBP_GachaGet_Widget_SuperCoin_Max.WBP_GachaGet_Widget_SuperCoin_Max'"
}
return GachaCommon