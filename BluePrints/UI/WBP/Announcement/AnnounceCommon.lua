local CssCode = require "BluePrints.UI.WBP.Announcement.WebSource.CssCode"
local JsCode = require "BluePrints.UI.WBP.Announcement.WebSource.JsCode"
local HtmlCode = require "BluePrints.UI.WBP.Announcement.WebSource.HtmlCode"
local CodeVersion = require "BluePrints.UI.WBP.Announcement.WebSource.CodeVersion"

local AnnounceCommon = {
    ContentUIStyle = {
        ImageOnly = 0,
        Default = 1,
    },

    TabTag = {
        System = 1,
        Activity = 2,
        News = 3,
    },

    ShowTag = {
        InLogin = 1,
        InGame = 2,
    },

    -- --特殊的独立渠道，其下没有子渠道，忽略子渠道检测
    -- SpecialChannelName = {
    --     --bilibili
    --     bilibili = 1,
    --     --wegame
    --     wegame = 1,
    -- },

    PlatformName = string.lower(UE4.UUIFunctionLibrary.GetDevicePlatformName(GWorld.GameInstance)),
    AnnounceWeb = UEMPathFunctionLibrary.GetProjectSavedDirectory().."AnnounceWeb/",
    FontTypeMap = {
        [CommonConst.SystemLanguages.CN] = "woff",
        [CommonConst.SystemLanguages.EN] = "woff",
        [CommonConst.SystemLanguages.KR] = "woff",
        [CommonConst.SystemLanguages.TC] = "woff",
        [CommonConst.SystemLanguages.JP] = "woff",
        [CommonConst.SystemLanguages.FR] = "woff",
    },

    --[2024-12-06 18:03~2025-01-01 00:00]
    LongYMDHMFormat = "(%d+)-(%d+)-(%d+)%s*(%d+)%s*:%s*(%d+)%s*~%s*(%d+)-(%d+)-(%d+)%s*(%d+)%s*:%s*(%d+)",
    LongTimeFormat  = "(%[%s*%d+-%d+-%d+%s*%d+%s*:%s*%d+%s*~%s*%d+-%d+-%d+%s*%d+%s*:%s*%d+%s*%])",
    --[2024-12-06 18:03~00:00]
    ShortYMDHMFormat= "(%d+)-(%d+)-(%d+)%s*(%d+)%s*:%s*(%d+)%s*~%s*(%d+)%s*:%s*(%d+)",
    ShortTimeFormat = "(%[%s*%d+-%d+-%d+%s*%d+%s*:%s*%d+%s*~%s*%d+%s*:%s*%d+%s*%])",
    --[2024-12-06 18:03]
    OneYMDHMFormat  = "(%d+)-(%d+)-(%d+)%s*(%d+)%s*:%s*(%d+)",
    OneTimeFormat   ="(%[%s*%d+-%d+-%d+%s*%d+%s*:%s*%d+%s*%])",

    FontSizeFormat = "(font%-size%s*:%s*%d*.?%d+pt)",
    FontScale = 1.13, --中台的公告字体数值有问题，需要乘一个缩放

    TableTagFormat = "(</?table>)",
}


AnnounceCommon.Version = CodeVersion
--插入网页脚本版本号，避免浏览器缓存干扰
AnnounceCommon.HtmlBody1 = string.format(HtmlCode.HtmlBody1, "%s", "%s",CodeVersion, CodeVersion, "%s")
AnnounceCommon.ImageOnlyContent = HtmlCode.ImageOnlyContent
AnnounceCommon.DefaultContent = HtmlCode.DefaultContent
AnnounceCommon.CssContent = CssCode
AnnounceCommon.JsContent = JsCode

AnnounceCommon.MainUIId = 12


_G.AnnounceCommon = AnnounceCommon
return AnnounceCommon