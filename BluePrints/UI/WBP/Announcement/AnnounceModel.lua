local AnnounceCommon = require "BluePrints.UI.WBP.Announcement.AnnounceCommon"
local Utils = require "Utils"
local CdnTool = require "BluePrints.UI.GameLogin.CdnTool"
local MiscUtils = require "Utils.MiscUtils"

---@class AnnounceModel
local M = Class("BluePrints.Common.MVC.Model")

function M:Init()
    if not Utils then 
        Utils = require "Utils"
    end
    self:Destory()
    self.IsDestroied = nil
    self.LastConfs = {}
    self.Confs = {}
    self.FutureConfs = {}
    self.AddedConfIds = {}
    self._AnnouncementDirty = true
    self.OldReddotCache = {}
    self.HasNewAdd = false
    self.AHSS = UE.UAnnounceHttpServerSubsystem.GetInstance(GWorld.GameInstance)
    self.AHSS:StartAnnouncementServer()
    if AnnounceController.bNewUI then
        M.LoadHtmlContent = M.LoadHtmlContentV2
        M._ParseContent = M._ParseContentV2
    end
end

function M:GetAvatar()
    return GWorld:GetAvatar()
end

function M:ResetConf()
    self.Confs = {}
    self.AddedConfIds = {}
end

--region 解析公告内容里的时间文本
function M:_GetTimeZone()
    --return TimeUtils.GetCurrentTimeZone()
    --@todo 目前Account无法同步服务器时间，暂用本地时间，之后再处理
    if not self.LocalTimeZone then
        self.LocalTimeZone = CommonUtils.GetTimeZone()
    end
    return self.LocalTimeZone
end

function M:_GetFontPath(Conf)
    local TextLang = CommonConst.SystemLanguage
    if Conf and Conf.Language ~= TextLang then
        TextLang = CommonConst.SystemLanguages[Conf.Language]
    end
    local Postfix =  AnnounceCommon.FontTypeMap[TextLang]
    local FontFile = string.format("%s.%s",TextLang, Postfix)
    local FontPath = AnnounceCommon.AnnounceWeb.."Fonts/"..FontFile
    local FontUrl = CdnTool:CdnUrl().."/OperationGameNotice/Resource/Fonts/"..FontFile
    DebugPrint("FontUrl/////",FontUrl)
    return FontPath, string.format("font/%s", Postfix), FontUrl ,FontFile
end

function M:LoadHtmlContentV2(Conf, Callback, ContentSize)
    --应用多开的时候，HttpServer有可能会失效，打开公告的时候尝试再Listen一下
    if AnnounceController:IsPC() then
        self.AHSS:StartAnnouncementServer()
    end
    local HtmlPath = URuntimeCommonFunctionLibrary.ConvertRelativePathToFull(AnnounceCommon.AnnounceWeb..string.format('%s.html',Conf.NoticeID));
    local Cb = function()
        local HtmlText = Conf.NoticeContent
        if not Conf.HtmlUrl or not UBlueprintPathsLibrary.FileExists(HtmlPath) then
            URuntimeCommonFunctionLibrary.SaveFile(HtmlPath, HtmlText)
        end
        Conf.HtmlUrl = string.format("http://localhost:%s/AnnounceWeb/%s.html", self.AHSS:GetPortId(), Conf.NoticeID)
        Callback(Conf.HtmlUrl, HtmlText)
    end
    if not Conf.HtmlUrl then
        self:LoadResource(false,Cb,Conf)
        return
    end
    Cb()
end

function M:LoadHtmlContent(Conf, Callback, ContentSize)
    --应用多开的时候，HttpServer有可能会失效，打开公告的时候尝试再Listen一下
    if AnnounceController:IsPC() then
        self.AHSS:StartAnnouncementServer()
    end
    local HtmlPath = URuntimeCommonFunctionLibrary.ConvertRelativePathToFull(AnnounceCommon.AnnounceWeb..string.format('%s.html',Conf.NoticeID));
    local Cb = function()
        local HtmlText = ""
        local RootDir = "http://localhost:"..self.AHSS:GetPortId()
        if AnnounceCommon.PlatformName == CommonConst.CHANNEL_OS.IOS then
            RootDir = URuntimeCommonFunctionLibrary.ConvertRelativePathToFull(UEMPathFunctionLibrary.GetProjectSavedDirectory())
        end
        Conf.NoticeContent = self:ParseTimeOfContent(Conf.NoticeContent)
        Conf.NoticeContent = self:ParseHTMLContent(Conf.NoticeContent)
        local OneRem = 100/(ContentSize/100)*AnnounceCommon.FontScale
        HtmlText = string.format(AnnounceCommon.HtmlBody1, OneRem, RootDir, Conf.NoticeContent)
        ---DebugPrint(LXYTag,"看看HtmlText\n",HtmlText)
        if not Conf.HtmlUrl or not UBlueprintPathsLibrary.FileExists(HtmlPath) then
            URuntimeCommonFunctionLibrary.SaveFile(HtmlPath, HtmlText)
        end
        if AnnounceCommon.PlatformName ~= CommonConst.CHANNEL_OS.IOS then
            local _,_,_,FontFile = self:_GetFontPath(Conf)
            local FontUrl = string.format("http://localhost:%s/AnnounceWeb/Fonts/%s", self.AHSS:GetPortId(), FontFile)
            local FontFileParam = string.format("?fontUrl=%s",FontUrl)
            local Param2 = string.format("&disableScroll=%s", Conf.UIStyle == AnnounceCommon.ContentUIStyle.ImageOnly)
            local RawUrl = string.format("http://localhost:%s/AnnounceWeb/%s.html", self.AHSS:GetPortId(), Conf.NoticeID)
            Conf.HtmlUrl = RawUrl..FontFileParam..Param2
        else
            HtmlPath = MiscUtils.CorrectUrl(HtmlPath)
            local FontPath = self:_GetFontPath(Conf)
            FontPath = MiscUtils.CorrectUrl(FontPath)
            local FontUrl = URuntimeCommonFunctionLibrary.ConvertRelativePathToFull(FontPath)
            local FontFileParam = string.format("?fontUrl=file://%s",FontUrl)
            local Param2 = string.format("&disableScroll=%s", Conf.UIStyle == AnnounceCommon.ContentUIStyle.ImageOnly)
            Conf.HtmlUrl = "file://"..HtmlPath..FontFileParam..Param2
        end
        DebugPrint(LXYTag, "看公告页面的URL", Conf.HtmlUrl)
        if Conf.UIStyle == AnnounceCommon.ContentUIStyle.ImageOnly and Conf.HasLinkImage == nil then
            Conf.HasLinkImage = string.match(HtmlText, "<a%s+[^>]*href%s*=%s*[\"']([^\"']+)[\"'][^>]*>%s*<img") ~= nil
        end
        Callback(Conf.HtmlUrl, HtmlText)
    end
    if not Conf.HtmlUrl then
        self:LoadResource(false,Cb,Conf)
        return
    end
    Cb()
end

function M:LoadResource(bForceLoad, Cb, Conf)
    local CachedVer = EMCache:Get("AnnounceVersion")
    if CachedVer ~= AnnounceCommon.Version then
        UBlueprintFileUtilsBPLibrary.DeleteDirectory(AnnounceCommon.AnnounceWeb, true, true)
        EMCache:Set("AnnounceVersion", AnnounceCommon.Version)
    end
    if self.bFontLoading then
        UIManager(GWorld.GameInstance):ShowUITip(UIConst.Tip_CommonToast ,GText("UI_Toast_NetDelay"))
        return
    end
    local Callback = function(Url, Path, Response) 
        try{exec = function() 
            if not Response or Response == "" then 
                DebugPrint(WarningTag, LXYTag, "公告没有拉到脚本",Url)
                return 
            end 
            URuntimeCommonFunctionLibrary.SaveFile(Path, Response)
        end,
        catch = function(e)
            print(ErrorTag, e.."\n"..debug.traceback())
        end,}
    end
    local JsPath = AnnounceCommon.AnnounceWeb.."Script/Announce.js"
    if not UBlueprintPathsLibrary.FileExists(JsPath) or bForceLoad then
        Callback(JsPath, JsPath, AnnounceCommon.JsContent)
    end
    local CssPath = AnnounceCommon.AnnounceWeb.."Script/Announce.css"
    if not UBlueprintPathsLibrary.FileExists(JsPath) or bForceLoad then
        Callback(CssPath, CssPath, AnnounceCommon.CssContent)
    end
    local ImageUrl = CdnTool:CdnUrl().."/OperationGameNotice/Resource/Image/TitleBg.png"
    local ImagePath = AnnounceCommon.AnnounceWeb.."Image/TitleBg.png"
    URuntimeCommonFunctionLibrary.HttpGetAndSave(ImageUrl, ImagePath, "image/png",{GWorld.GameInstance, function(_,bSuccess)
    end}, bForceLoad)
    
    local FontPath,ContentType,FontUrl = self:_GetFontPath(Conf)
    if not UBlueprintPathsLibrary.FileExists(FontPath) then
        DebugPrint(LXYTag, "检测到字体不存在，通过httpget获取字体")
        self.bFontLoading = true
        local Delegate = {GWorld.GameInstance, function(_,bSuccess)
            self.bFontLoading = false
            if not bSuccess then
                DebugPrint(WarningTag, LXYTag, "网络太差，公告没有拉到字体",FontUrl)
            end
            if Cb then Cb() end
        end}
        UE.URuntimeCommonFunctionLibrary.HttpGetAndSave(FontUrl, FontPath, ContentType, Delegate, bForceLoad)
    else
        self.bFontLoading = false
        if Cb then Cb() end
    end
end

function M:_AddFormatArg(Args, ArgName, ArgValue)
    local Arg = FFormatArgumentData()
    Arg.ArgumentValueType = EFormatArgumentType.Text
    ArgValue = ArgValue<10 and "0"..ArgValue or tostring(ArgValue)
    Arg.ArgumentName, Arg.ArgumentValue= ArgName, ArgValue
    Args:Add(Arg)
end

function M:_TranslateTime(Year, Month, Day, Hour, Minute, DstTimeZone, SrcTimeZone)
    if not SrcTimeZone then SrcTimeZone = 8 end
    Year, Month, Day, Hour, Minute = tonumber(Year), tonumber(Month), tonumber(Day), tonumber(Hour), tonumber(Minute)
    local Timestamp = os.time({year=Year, month=Month, day=Day, hour=Hour, min=Minute, sec=0})
    Timestamp = Timestamp + (DstTimeZone-SrcTimeZone) *3600
    local Date = os.date("*t", Timestamp)
    Year, Month, Day, Hour, Minute = Date.year, Date.month, Date.day, Date.hour,Date.min
    return Year, Month, Day, Hour, Minute
end

function M:_MakeTimeStrReal(YY,MM,DD,H,M,YY1,MM1,DD1,H1,M1, TimeZone, TZStr)
    if not TZStr then TZStr = "" end
    local Year,Month,Day,Hour,Minute = self:_TranslateTime(YY, MM, DD, H, M, TimeZone)
    local TimeArgs = TArray(FFormatArgumentData)
    self:_AddFormatArg(TimeArgs, "YY", Year)
    self:_AddFormatArg(TimeArgs, "MM", Month)
    self:_AddFormatArg(TimeArgs, "DD", Day)
    self:_AddFormatArg(TimeArgs, "H", Hour)
    self:_AddFormatArg(TimeArgs, "M", Minute)
    if (YY1 and MM1 and DD1 and M1 and H1) then
        local Year1,Month1,Day1,Hour1,Minute1 = self:_TranslateTime(YY1, MM1, DD1, H1, M1, TimeZone)
        if (Day ~= Day1 or Month~=Month1 or Year~=Year1) then
            self:_AddFormatArg(TimeArgs, "YY1", Year1)
            self:_AddFormatArg(TimeArgs, "MM1", Month1)
            self:_AddFormatArg(TimeArgs, "DD1", Day1)
        end
        self:_AddFormatArg(TimeArgs, "H1", Hour1)
        self:_AddFormatArg(TimeArgs, "M1", Minute1)
    end
    if (TimeArgs:Length() == 7) then
        return UKismetTextLibrary.Format(GText("AnnouncementTimeFormatShort"), TimeArgs)..TZStr
    elseif (TimeArgs:Length() == 10) then
        return UKismetTextLibrary.Format(GText("AnnouncementTimeFormatLong"),TimeArgs)..TZStr
    elseif (TimeArgs:Length() == 5) then
        return UKismetTextLibrary.Format(GText("AnnouncementTimeFormatOne"),TimeArgs)..TZStr
    end
end

function M:_MakeTimeStrCN(YY,MM,DD,H,M,YY1,MM1,DD1,H1,M1,TimeZone)
    return self:_MakeTimeStrReal(YY,MM,DD,H,M,YY1,MM1,DD1,H1,M1, TimeZone)
end

function M:_MakeTimeStrJP(YY,MM,DD,H,M,YY1,MM1,DD1,H1,M1,TimeZone)
    local AutoTZStr=GText("AnnouncementAutoTimeZone")
    --local FixedTZStr = GText("AnnouncementFixedTimeZone")
    local AutoTimeStr = self:_MakeTimeStrReal(YY,MM,DD,H,M,YY1,MM1,DD1,H1,M1, TimeZone, AutoTZStr)
    -- local FixedTimeStr = self:_MakeTimeStrReal(YY,MM,DD,H,M,YY1,MM1,DD1,H1,M1, 9, FixedTZStr)
    return AutoTimeStr --.."|"..FixedTimeStr
end

function M:_MakeTimeStrEN(YY,MM,DD,H,M,YY1,MM1,DD1,H1,M1,TimeZone)
    local AutoTZStr= string.format(GText("AnnouncementAutoTimeZone"), TimeZone>=0 and "+"..TimeZone or TimeZone)
    return self:_MakeTimeStrReal(YY,MM,DD,H,M,YY1,MM1,DD1,H1,M1, TimeZone, AutoTZStr)
end

function M:_MakeTimeStrKR(YY,MM,DD,H,M,YY1,MM1,DD1,H1,M1,TimeZone)
    return self:_MakeTimeStrJP(YY,MM,DD,H,M,YY1,MM1,DD1,H1,M1,TimeZone)
end

function M:_MakeTimeStrTC(YY,MM,DD,H,M,YY1,MM1,DD1,H1,M1,TimeZone)
    return  self:_MakeTimeStrEN(YY,MM,DD,H,M,YY1,MM1,DD1,H1,M1,TimeZone)
end

function M:_MakeNewTimeStr(YY,MM,DD,H,M,YY1,MM1,DD1,H1,M1)
    local Language = CommonConst.SystemLanguage
    local Tag = ""
    if Language == CommonConst.SystemLanguages.CN then
        Tag = 'CN'
    elseif Language == CommonConst.SystemLanguages.TC then
        Tag = 'TC'
    elseif Language == CommonConst.SystemLanguages.EN then
        Tag = 'EN'
    elseif Language == CommonConst.SystemLanguages.JP then
        Tag = 'JP'
    elseif Language == CommonConst.SystemLanguages.KR then
        Tag = 'KR'
    end
    local TimeZone = self:_GetTimeZone()
    return self["_MakeTimeStr"..Tag](self,YY,MM,DD,H,M,YY1,MM1,DD1,H1,M1, TimeZone)
end

function M:ParseTimeOfContent(Content)
    local Replacement = {}
    for TimeStr in string.gmatch(Content, AnnounceCommon.LongTimeFormat) do
        if not Replacement[TimeStr] then
            local YY,MM,DD,H,M,YY1,MM1,DD1,H1,M1 = string.gmatch(TimeStr,AnnounceCommon.LongYMDHMFormat)()
            local NewTimeStr = self:_MakeNewTimeStr(YY,MM,DD,H,M,YY1,MM1,DD1,H1,M1)
            Replacement[TimeStr] = NewTimeStr
        end
    end
    for TimeStr in string.gmatch(Content, AnnounceCommon.ShortTimeFormat) do
        if not Replacement[TimeStr] then
            local  YY,MM,DD,H,M,H1,M1 = string.gmatch(TimeStr,AnnounceCommon.ShortYMDHMFormat)()
            local YY1,MM1,DD1 = YY,MM,DD
            local NewTimeStr = self:_MakeNewTimeStr(YY,MM,DD,H,M,YY1,MM1,DD1,H1,M1)
            Replacement[TimeStr] = NewTimeStr
        end
    end
    for TimeStr in string.gmatch(Content, AnnounceCommon.OneTimeFormat) do
        if not Replacement[TimeStr] then
            local YY,MM,DD,H,M = string.gmatch(TimeStr, AnnounceCommon.OneYMDHMFormat)()
            local NewTimeStr = self:_MakeNewTimeStr(YY,MM,DD,H,M)
            Replacement[TimeStr] = NewTimeStr
        end
    end
    for Old, New in pairs(Replacement) do
        Content = UKismetStringLibrary.ReplaceInline(Content, Old, New)
    end
    return Content
end

function M:_MakeNewFontSizeStr(Val)
    local pt = tonumber(Val)
    local rem = (pt*(96/72))/100
    return string.format("font-size:%srem",rem)
end

function M:ParseHTMLContent(Content)
    local Replacement = {}
    for FontSizeStr in string.gmatch(Content, AnnounceCommon.FontSizeFormat) do
        if not Replacement[FontSizeStr] then
            local FontSizeVal = string.gmatch(FontSizeStr, "(%d+)")()
            local NewFontSizeStr = self:_MakeNewFontSizeStr(FontSizeVal)
            Replacement[FontSizeStr] = NewFontSizeStr
        end
    end
    for TableTagStr in string.gmatch(Content, AnnounceCommon.TableTagFormat) do
        if not Replacement[TableTagStr] then
            local Slash = string.gmatch(TableTagStr, "(/)")()
            local NewPTagStr = Slash and "</p>" or "<p>"
            Replacement[TableTagStr] = NewPTagStr
        end
    end
    for Old, New in pairs(Replacement) do
        Content = UKismetStringLibrary.ReplaceInline(Content, Old, New)
    end
    return Content
end
--endregion

--region 红点
function M:_ResetReddot()
    if not ReddotManager.GetTreeNode(DataMgr.ReddotNode.AnnouncementItems.Name) then
        ReddotManager.AddNode(DataMgr.ReddotNode.AnnouncementItems.Name)
    end
    local Nodes = {"ActivityAnnouncement","SystemAnnouncement","NewsAnnouncement"}
    for _, NodeName in ipairs(Nodes) do
        if not self.OldReddotCache[NodeName] then
            self.OldReddotCache[NodeName] = CommonUtils.DeepCopy(ReddotManager.GetLeafNodeCacheDetail(NodeName))
        end
        ReddotManager.ClearLeafNodeCount(NodeName)
        local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(NodeName)
        local DelKeys = {}
        for Key, Value in pairs(CacheDetail) do
            if Value then 
                table.insert(DelKeys, Key) 
            end
        end
        for _, DelKey in ipairs(DelKeys) do
            CacheDetail[DelKey] = nil
        end
    end
    ReddotManager.ClearLeafNodeCount("AnnouncementDirty")
end

function M:_TryAddReddotCacheDetail(Conf)
    local CacheKey = tostring(Conf.NoticeID)
    local ReddotName = self:GetReddotNameByConf(Conf)
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotName)
    if CacheDetail and CacheDetail[CacheKey]==nil then
        CacheDetail[CacheKey] = true
        if not self.OldReddotCache[ReddotName][CacheKey] then
            self.HasNewAdd = true
        end
    end
    if CacheDetail[CacheKey] then 
        ReddotManager.IncreaseLeafNodeCount(ReddotName)
    end
end

function M:GetReddotNameByConf(Conf)
    if Conf.TabTag == AnnounceCommon.TabTag.Activity then
        return "ActivityAnnouncement"
    elseif Conf.TabTag == AnnounceCommon.TabTag.System then
        return "SystemAnnouncement"
    elseif Conf.TabTag == AnnounceCommon.TabTag.News then
        return "NewsAnnouncement"
    end
end

function M:TrySubReddotCacheDetail(Conf)
    local CacheKey = tostring(Conf.NoticeID)
    local ReddotName = self:GetReddotNameByConf(Conf)
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotName)
    if CacheDetail and CacheDetail[CacheKey] then
        CacheDetail[CacheKey] = false
        ReddotManager.DecreaseLeafNodeCount(ReddotName)
    end
end

function M:_SyncReddotCache()
    -- TODO 和下面函数合并一下
    local CacheDetail1 = ReddotManager.GetLeafNodeCacheDetail("SystemAnnouncement")
    local CacheDetail2 = ReddotManager.GetLeafNodeCacheDetail("ActivityAnnouncement")
    local CacheDetail3 = ReddotManager.GetLeafNodeCacheDetail("NewsAnnouncement")

    local ExistConf = {}
    for _,Conf in ipairs(self.Confs) do
        ExistConf[tostring(Conf.NoticeID)] = Conf
    end
    self:_RealSyncReddotCache(CacheDetail1, ExistConf, "SystemAnnouncement")
    self:_RealSyncReddotCache(CacheDetail2, ExistConf, "ActivityAnnouncement")
    self:_RealSyncReddotCache(CacheDetail3, ExistConf, "NewsAnnouncement")
end

function M:_RealSyncReddotCache(CacheDetail, ExistConf, ReddotName)
    for Key,Value in pairs(CacheDetail or {}) do
        if not ExistConf[Key] or self:GetReddotNameByConf(ExistConf[Key])~=ReddotName then
            CacheDetail[Key] = nil
        end
    end
end
--endregion

function M:MarkDirty(bDirty)
    self._AnnouncementDirty = bDirty
    if bDirty then
        DebugPrint("[zhangyuhang] self:MakeDirty 准备重新请求公告")
    end
end

function M:IsDirty()
    return self._AnnouncementDirty
end

function M:CacheLastConf()
    self.LastConfs = {}
    for _, Conf in ipairs(self.Confs) do
        self.LastConfs[Conf.NoticeID] = Conf
    end
end

function M:_SortConfs()
    local SortFunc = function(a,b)
        if a.Local ~= b.Local then return a.Local < b.Local end
        if a.Sort ~= b.Sort then return a.Sort > b.Sort end
        if a.StartTimestamp ~= b.StartTimestamp then return a.StartTimestamp > b.StartTimestamp end
    end
    table.sort(self.Confs, SortFunc)
end


function M:_AddNewConf(Info,ShowTag)
    if self.AddedConfIds[Info.UniqueId] then
        return            
    end
    self.AddedConfIds[Info.UniqueId] = true
    DebugPrint(LogTag, LXYTag, "解析公告",Info.UniqueId)
    local Conf = {
        NoticeID = Info.UniqueId,
        StartTimestamp = Info.StartTimestamp or os.time(),
        EndTimestamp = Info.EndTimestamp or nil,
        Sort = tonumber(Info.ClientOnly.notice_sort or "0"),
        TabTag = tonumber(Info.ClientOnly.TypeTag) or AnnounceCommon.TabTag.System,
        UIStyle = tonumber(Info.ClientOnly.UIStyle) or 1,
        SubTitleInfos = {},
        ShowTags = {}, 
        Local = 0,
        HtmlUrl = nil,
    }
    self:_ParseShowTag(Conf, Info)
    if not Conf.ShowTags[ShowTag] then
        DebugPrint(LXYTag, Info.UniqueId.."公告不在这个场合显示, 当前游戏场合："..ShowTag)
        return
    end

    if (not self:CheckPakInfos(Info)) then
        DebugPrint(LXYTag, Info.UniqueId.. "公告PakInfo渠道检测不通过|PakInfo")
        return
    end

    -- 解析Info的渠道信息
    if(not self:CheckChannel(Info)) then 
        DebugPrint(LXYTag, Info.UniqueId.." 公告渠道检测不通过|Channel")
        return
    end

    if(not self:CheckSubChannel(Info)) then 
        DebugPrint(LXYTag, Info.UniqueId.." 公告子渠道检测不通过|SubChannel")
        return
    end

    if (self:IsExpired(Conf)) then 
        DebugPrint(LXYTag, Info.UniqueId.." 公告已过期")
        return
    end

    if (self:IsFutureNotice(Conf)) then
        self.FutureConfs[Info.UniqueId] = {Info = Info, ShowTag = ShowTag}
        DebugPrint(LXYTag, Info.UniqueId.." 将来的公告已缓存")
        return
    end

    -- utc时间转换    注意跨天的情况    
    local timeZoneOffset = CommonUtils.GetTimeZone()
    -- 打印时区和当前日期
    local TimeZonePostfix = " (UTC+"..timeZoneOffset..")"

    Conf.NoticeDate = GDate_YMD_Timestamp(math.floor(Conf.StartTimestamp+0.5))..TimeZonePostfix
    Conf.EndDate = Conf.EndTimestamp and GDate_YMD_Timestamp(math.floor(Conf.EndTimestamp+0.5))..TimeZonePostfix
    self:_ParseContent(Conf, Info)
    if (Conf.NoticeTitle=="" or Conf.NoticeContent=="") then 
        DebugPrint(LXYTag, ErrorTag, Info.UniqueId.." 公告当前语言的内容为空！！当前游戏语言："..CommonConst.SystemLanguage)
        return 
    end
    ---红点缓存
    self:_TryAddReddotCacheDetail(Conf)
    table.insert(self.Confs,Conf)
end

function M:_ParseContentV2(Conf, Info)
    Conf.NoticeTitle = ""
    local bNeedDefaultEnglish = true
    for _,Text in pairs(Info.ClientOnly.pageContents or {}) do
        if self:_TestContentLangPass(Text) then
            Conf.Language = Text.language
            Conf.SubTitleInfos = Text.subTitleInfos
            Conf.NoticeContent = Text.htmlCode
            Conf.NoticeTitle = Info.Title
            bNeedDefaultEnglish = false
            break
        else
            DebugPrint(LXYTag, Info.UniqueId.." 公告语言对不上 跳过"..Info.Title) 
        end
    end
    if bNeedDefaultEnglish then
        for _,Text in pairs(Info.ClientOnly.pageContents or {}) do
            if CommonConst.SystemLanguages[Text.language] == CommonConst.SystemLanguages.EN then 
                DebugPrint(LXYTag, Info.UniqueId.." 公告语言默认选择英语") 
                Conf.Language = Text.language
                Conf.SubTitleInfos = Text.subTitleInfos
                Conf.NoticeContent = Text.htmlCode
                Conf.NoticeTitle = Info.Title
                bNeedDefaultEnglish = false
                break
            end
        end
    end
end

function M:_ParseContent(Conf, Info)
    ---根据系统语言获取对应文本
    Conf.NoticeTitle ,Conf.NoticeContent = "", ""
    local bNeedDefaultEnglish = true
    for _,Text in pairs(Info.Content or {}) do
        if self:_TestContentLangPass(Text) then 
            Conf.Language = Text.language
            Conf.NoticeTitle = Text.title
            if Conf.UIStyle == AnnounceCommon.ContentUIStyle.Default then
                if not Text.title1 or Text.title1 == "" then
                    Text.title1 = Text.title
                end
                Conf.NoticeContent = string.format(AnnounceCommon.DefaultContent,Text.title1,Text.body)
            elseif Conf.UIStyle == AnnounceCommon.ContentUIStyle.ImageOnly then
                Conf.NoticeContent = string.format(AnnounceCommon.ImageOnlyContent,Text.noticeImageURL,Text.noticeImage)
            else
                DebugPrint(LXYTag, ErrorTag, "未定义的公告内容样式："..Conf.UIStyle)
            end
            bNeedDefaultEnglish = false
            break
        else
            DebugPrint(LXYTag, Info.UniqueId.." 公告语言对不上 跳过"..Text.title) 
        end
    end
    if bNeedDefaultEnglish then
        for _,Text in pairs(Info.Content or {}) do
            if CommonConst.SystemLanguages[Text.language] == CommonConst.SystemLanguages.EN then 
                DebugPrint(LXYTag, Info.UniqueId.." 公告语言默认选择英语") 
                Conf.Language = Text.language
                Conf.NoticeTitle = Text.title
                if Conf.UIStyle == AnnounceCommon.ContentUIStyle.Default then
                    if not Text.title1 or Text.title1 == "" then
                        Text.title1 = Text.title
                    end
                    Conf.NoticeContent = string.format(AnnounceCommon.DefaultContent,Text.title1,Text.body)
                elseif Conf.UIStyle == AnnounceCommon.ContentUIStyle.ImageOnly then
                    Conf.NoticeContent = string.format(AnnounceCommon.ImageOnlyContent,Text.noticeImageURL,Text.noticeImage)
                else
                    DebugPrint(LXYTag, ErrorTag, "未定义的公告内容样式："..Conf.UIStyle)
                end
                bNeedDefaultEnglish = false
                break
            end
        end
    end
end

--region Conf解析与合法性校验

function M:_TestContentLangPass(Text)
    local TextLang = CommonConst.SystemLanguages[Text.language]
    local bLangPass = CommonConst.SystemLanguage == TextLang
    local bChineseDefault = TextLang == CommonConst.SystemLanguages.TC and CommonConst.SystemLanguage == CommonConst.SystemLanguages.CN
    return bLangPass or bChineseDefault
end


---@note 由于后台发来的时间戳是UTC时间戳，客户端也需要用UTC时间戳计算，即os.time()
function M:IsExpired(Conf)
    if not Conf.EndTimestamp then return false end
    local NowTimestamp = os.time()
    local Res = false
    if Conf.EndTimestamp < NowTimestamp then
        Res = true
    end
    --过期公告红点缓存也要清理掉
    if Res then
        self:TrySubReddotCacheDetail(Conf)
    end
    return Res
end

function M:IsFutureNotice(Conf)
    if not Conf.StartTimestamp then return false end
    local NowTimestamp = os.time()
    return Conf.StartTimestamp > NowTimestamp
end


function M:_ParseShowTag(Conf, Info)
    if MiscUtils.IsNilOrEmpty(Info.ClientOnly.noticeType) then
        Conf.ShowTags = {1,1}
        return
    end
    local ShowTags = string.split(Info.ClientOnly.noticeType, ",")
    for _, ShowTag in ipairs(ShowTags) do
        if not tonumber(ShowTag) then
            Conf.ShowTags = {1,1}
            break
        end
        DebugPrint(LXYTag, "公告允许显示的场合："..ShowTag)
        Conf.ShowTags[tonumber(ShowTag)] = 1
    end
end

--M.bIndepChannel = false
function M:CheckChannel(Info)
    local ChannelId = Utils.HeroUSDKSubsystem():GetChannelId()
    if not ChannelId then
        DebugPrint(WarningTag, "本包没有ChannelId，跳过公告渠道检测") 
        return true 
    end
    if not DataMgr.ChannelInfo[ChannelId] then 
        DebugPrint(WarningTag, string.format("ChannelInfo表里没有定义这种ChannelId:%s, 跳过公告渠道检测", ChannelId))
        return true 
    end
    local Provider = ChannelId ~=-1 and DataMgr.ChannelInfo[ChannelId].Provider
    if Info.Channels and type(Info.Channels) ~="table" then
        DebugPrint(WarningTag, "AnnounceModel:CheckChannel  Info.Channels 后台传来的类型非法！！！不是Table !!!!!",Info.Channels)
        return true
    end
    if table.isempty(Info.Channels) then 
        DebugPrint(WarningTag, "#Info.Channels 是空的 !!!!") 
        return true
    end
    DebugPrint(TXTTag, "看看这个包的SdkChannelId："..ChannelId.." 和平台："..AnnounceCommon.PlatformName)
    if ChannelId == -1 then DebugPrint(WarningTag, "开发环境的ChannelId是-1，跳过渠道检测") return true end
    PrintTable(Info.Channels, 2, "看看公告自身的ChannelId ")
    for i,Channel in pairs(Info.Channels) do
        if (not table.isempty(Channel)) and ((Channel.code == Provider) or (Channel.code == ChannelId)) then
            -- if AnnounceCommon.SpecialChannelName[Provider] then
            --     self.bIndepChannel = true
            -- end
            return true
        end
    end
    return false 
end


function M:CheckPakInfos(Info)
    if table.isempty(Info.pakInfos) then 
        DebugPrint(WarningTag, "Info.packInfos是空的")
        return true
    end
    local DummyInfo = {Channels = {}, img_channel_id = {}}
    for _, pakInfo in ipairs(Info.pakInfos) do
        local EInfo = DataMgr.ExamineInfo[pakInfo.code]
        table.insert(DummyInfo.Channels, {code = EInfo.ChannelID})
        table.insert(DummyInfo.img_channel_id, {code = EInfo.MirrorChannelID})
    end
    return self:CheckChannel(DummyInfo) and self:CheckSubChannel(DummyInfo)
end

function M:CheckSubChannel(Info)
    -- if self.bIndepChannel then
    --     DebugPrint("独立渠道忽略子渠道检测...")
    --     self.bIndepChannel = false
    --     return true
    -- end
    local SubChannelId = Utils.HeroUSDKSubsystem():GetMirrorChannelId()
    local Provider = SubChannelId ~= -1 and DataMgr.ImgChannelInfo[SubChannelId].Provider
    if Info.img_channel_id and type(Info.img_channel_id) ~="table" then
        DebugPrint(WarningTag, "AnnounceModel:CheckSubChannel Info.img_channel_id 后台传来的类型非法！！！不是Table !!!!!",Info.img_channel_id) 
        return true
    end
    if table.isempty(Info.img_channel_id) then 
        DebugPrint(WarningTag, "Info.img_channel_id 是空的 !!!!!") 
        return true 
    end
    DebugPrint(TXTTag, "看看这个包的(Sub)MirrorChannelId："..SubChannelId)
    if SubChannelId == -1 then DebugPrint(WarningTag, "开发环境的(Sub)MirrorChannelId是-1，跳过渠道检测") return true end
    PrintTable(Info.img_channel_id, 2, "看看公告自身的(Sub)MirrorChannelId")
    for i,SubChannel in pairs(Info.img_channel_id) do
        if (tonumber(SubChannel.code) == SubChannelId) or (SubChannel.code == Provider) then
            return true
        end
    end
    return false
end

-- ---@param Code string
-- ---@return number
-- ---	China = 0 UMETA(DisplayName = "国内"),
-- 	-- Global = 1 UMETA(DisplayName = "全球"),
-- 	-- Steam =2,
-- 	-- Bilibili
-- function M:IndexSDKChannel(Code)
--     Code = tonumber(Code)
--     if DataMgr.ChannelInfo[Code] then
--         return DataMgr.ChannelInfo[Code].SDKChannelId
--     end
--     DebugPrint(TXTTag, "未找到渠道ID："..Code)
--     return CommonConst.SDKChannelId.None
-- end

function M:CheckPlatform(Code)
    Code = tonumber(Code)
    if AnnounceCommon.PlatformName == DataMgr.ChannelInfo[Code].OS then
        return true
    end
    return false
end
--endregion


function M:ResetNew()
    self.HasNewAdd = false
end


function M:TrySetServerAreaNew(HostId)
    local CacheDetail = EMCache:Get("VisitedHostTableForAnnouncement") or {}
    if CacheDetail["Server"..HostId]~=nil then return end
    CacheDetail["Server"..HostId] = 1
    EMCache:Set("VisitedHostTableForAnnouncement", CacheDetail)
    self.HasNewAdd = true
    ----新服，但是公告已经没有新的了
    -- local ReddotNode = ReddotManager.GetTreeNode(DataMgr.ReddotNode.AnnouncementItems.Name)
    -- if(ReddotNode) then
    --     self.HasNewAdd = self.HasNewAdd and ReddotNode.Count>0
    -- end
end

-- 激活活跃公告
function M:_ActivateScheduledNotices()
    local ToRemove = {}
    for id, value in pairs(self.FutureConfs or {}) do
        if not self:IsFutureNotice(value.Info) then
            self:_AddNewConf(value.Info, value.ShowTag)
            table.insert(ToRemove, id)
        end
    end
    if not table.isempty(ToRemove) then
        for _, id in ipairs(ToRemove) do
            self.FutureConfs[id] = nil
        end
        self:_SortConfs()
        self:_SyncReddotCache()
    end
end

-- 移出失效公告
function M:_RemoveExpiredNotices()
    for i = #self.Confs, 1, -1 do
        local Conf = self.Confs[i]
        if self:IsExpired(Conf) then
            self.AddedConfIds[Conf.NoticeID] = nil
            table.remove(self.Confs, i)
        end
    end
    -- IsExpired处理了过期红点
end

function M:FilterConfForUI(TabTag, ShowTag)
    self:_ActivateScheduledNotices()
    self:_RemoveExpiredNotices()

    local RetConfs = {}
    for _, Conf in pairs(self.Confs) do
        if TabTag == Conf.TabTag and Conf.ShowTags[ShowTag] then
            table.insert(RetConfs, Conf)
        end
    end
    return RetConfs
end

function M:UrlDecode(s)
    s = string.gsub(s, '%%(%x%x)', function(h) 
        return string.char(tonumber(h, 16)) 
    end)
    return s
end


return M