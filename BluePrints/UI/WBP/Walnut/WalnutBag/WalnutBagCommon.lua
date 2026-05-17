local WalnutBagCommon = {
    ReddotName = "WalnutBag",

    WalnutItemType = {
        "ChaosWalnut",              -- 混乱密函
        "NeutralWalnut",            -- 中立密函
        "OrderWalnut",              -- 守序密函
    },

    WalnutItemTypeToTabId = {
        AllWalnut       = 1,      -- 所有密函
        ChaosWalnut     = 2,      -- 混乱密函
        NeutralWalnut   = 3,      -- 中立密函
        OrderWalnut     = 4,      -- 守序密函
    },

    WalnutSearchMaxLen = 20,

    DefaultSelectTabId = 1,

    UIName = "WalnutBagMain",

    WalnutTypeName = "Walnut",

    NpcId = 900005,

    MaxRewardCount = 6,

    ReddotName = "WalnutBagItems",

    AllOptionName = {
        TabClick = "TabClick",
        SearchClick = "SearchClick",
        ShowNotHaveClick = "ShowNotHaveClick",
    },

    WalnutSelectUIName = "WalnutSelectToList",

    WalnutBagSellPageZOrder = 56,
}

return WalnutBagCommon