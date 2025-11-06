local EMCache = require("EMCache.EMCache")
local AnnounceCommon = require("BluePrints.UI.WBP.Announcement.AnnounceCommon")
local Utils = require("Utils")
local CdnTool = require("BluePrints/UI/GameLogin/CdnTool")
local MiscUtils = require("Utils.MiscUtils")
local M = Class()
local SubReddotKeys = {
  "SystemAnnouncement",
  "ActivityAnnouncement",
  "NewsAnnouncement"
}

function M:Init()
  if AnnounceCommon.bUseWeb then
    M.GetAnnouncementDataAsync = M.GetAnnouncementDataAsync_UseWeb
  end
  if not Utils then
    Utils = require("Utils")
  end
  M.bInit = false
  M.LastConfs = {}
  M.Confs = {}
  M.FutureConfs = {}
  M.PendingCo = nil
  M.HasNewAdd = false
  M.bFontLoading = false
  M._AnnouncementDirty = true
  M:LoadResource(true)
end

function M:_GetFontPath()
  local Postfix = AnnounceCommon.FontTypeMap[CommonConst.SystemLanguage]
  local FontFile = string.format("%s.%s", CommonConst.SystemLanguage, Postfix)
  local FontPath = AnnounceCommon.AnnounceWeb .. "Fonts/" .. FontFile
  local FontUrl = CdnTool:CdnUrl() .. "/OperationGameNotice/Resource/Fonts/" .. FontFile
  return FontPath, string.format("font/%s", Postfix), FontUrl, FontFile
end

function M:LoadHtmlContent(Conf, Callback, ContentSize)
  local HtmlPath = URuntimeCommonFunctionLibrary.ConvertRelativePathToFull(AnnounceCommon.AnnounceWeb .. string.format("%s.html", Conf.NoticeID))
  
  local function Cb()
    local HtmlText = ""
    local RootDir = "http://localhost:1559"
    if AnnounceCommon.PlatformName == CommonConst.CHANNEL_OS.IOS then
      RootDir = URuntimeCommonFunctionLibrary.ConvertRelativePathToFull(UEMPathFunctionLibrary.GetProjectSavedDirectory())
    end
    Conf.NoticeContent = M:ParseTimeOfContent(Conf.NoticeContent)
    HtmlText = string.format(AnnounceCommon.HtmlBody1, RootDir, Conf.NoticeContent)
    DebugPrint(LXYTag, "看看HtmlText\n", HtmlText)
    if not Conf.HtmlUrl or not UBlueprintPathsLibrary.FileExists(HtmlPath) then
      URuntimeCommonFunctionLibrary.SaveFile(HtmlPath, HtmlText)
    end
    if AnnounceCommon.PlatformName ~= CommonConst.CHANNEL_OS.IOS then
      local _, _, _, FontFile = M:_GetFontPath()
      local FontUrl = string.format("http://localhost:1559/AnnounceWeb/Fonts/%s", FontFile)
      local FontFileParam = string.format("?fontUrl=%s", FontUrl)
      local FontSizeParam = string.format("&ContentSize=%s", ContentSize)
      local RawUrl = string.format("http://localhost:1559/AnnounceWeb/%s.html", Conf.NoticeID)
      Conf.HtmlUrl = RawUrl .. FontFileParam .. FontSizeParam
    else
      HtmlPath = MiscUtils.CorrectUrl(HtmlPath)
      local FontPath = M:_GetFontPath()
      FontPath = MiscUtils.CorrectUrl(FontPath)
      local FontUrl = URuntimeCommonFunctionLibrary.ConvertRelativePathToFull(FontPath)
      local FontFileParam = string.format("?fontUrl=file://%s", FontUrl)
      DebugPrint("看看公告页面的字体大小", ContentSize)
      local FontSizeParam = string.format("&ContentSize=%s", ContentSize)
      Conf.HtmlUrl = "file://" .. HtmlPath .. FontFileParam .. FontSizeParam
    end
    DebugPrint(LXYTag, "看公告页面的URL", Conf.HtmlUrl)
    Callback(Conf.HtmlUrl, HtmlText)
  end
  
  if not Conf.HtmlUrl then
    M:LoadResource(false, Cb)
    return
  end
  Cb()
end

function M:LoadResource(bForceLoad, Cb)
  if M.bFontLoading then
    UIManager(GWorld.GameInstance):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Toast_NetDelay"))
    return
  end
  
  local function Callback(Url, Path, Response)
    try({
      exec = function()
        if not Response or "" == Response then
          DebugPrint(WarningTag, LXYTag, "公告没有拉到脚本", Url)
          return
        end
        URuntimeCommonFunctionLibrary.SaveFile(Path, Response)
      end,
      catch = function(e)
        print(ErrorTag, e .. "\n" .. debug.traceback())
      end
    })
  end
  
  local JsPath = AnnounceCommon.AnnounceWeb .. "Script/Announce.js"
  if not UBlueprintPathsLibrary.FileExists(JsPath) or bForceLoad then
    Callback(JsPath, JsPath, AnnounceCommon.JsContent)
  end
  local CssPath = AnnounceCommon.AnnounceWeb .. "Script/Announce.css"
  if not UBlueprintPathsLibrary.FileExists(JsPath) or bForceLoad then
    Callback(CssPath, CssPath, AnnounceCommon.CssContent)
  end
  local ImageUrl = CdnTool:CdnUrl() .. "/OperationGameNotice/Resource/Image/TitleBg.png"
  local ImagePath = AnnounceCommon.AnnounceWeb .. "Image/TitleBg.png"
  URuntimeCommonFunctionLibrary.HttpGetAndSave(ImageUrl, ImagePath, "image/png", {
    GWorld.GameInstance,
    function(_, bSuccess)
    end
  }, bForceLoad)
  local FontPath, ContentType, FontUrl = M:_GetFontPath()
  if not UBlueprintPathsLibrary.FileExists(FontPath) then
    DebugPrint(LXYTag, "检测到字体不存在，通过httpget获取字体")
    M.bFontLoading = true
    local Delegate = {
      GWorld.GameInstance,
      function(_, bSuccess)
        M.bFontLoading = false
        if not bSuccess then
          DebugPrint(WarningTag, LXYTag, "网络太差，公告没有拉到字体", FontUrl)
          return
        end
        if Cb then
          Cb()
        end
      end
    }
    UE.URuntimeCommonFunctionLibrary.HttpGetAndSave(FontUrl, FontPath, ContentType, Delegate, bForceLoad)
  elseif Cb then
    Cb()
  end
end

function M:_GetTimeZone()
  if not M.LocalTimeZone then
    M.LocalTimeZone = CommonUtils.GetTimeZone()
  end
  return M.LocalTimeZone
end

function M:_AddFormatArg(Args, ArgName, ArgValue)
  local Arg = FFormatArgumentData()
  Arg.ArgumentValueType = EFormatArgumentType.Text
  ArgValue = ArgValue < 10 and "0" .. ArgValue or tostring(ArgValue)
  Arg.ArgumentName, Arg.ArgumentValue = ArgName, ArgValue
  Args:Add(Arg)
end

function M:_TranslateTime(Year, Month, Day, Hour, Minute, DstTimeZone, SrcTimeZone)
  SrcTimeZone = SrcTimeZone or 8
  Year, Month, Day, Hour, Minute = tonumber(Year), tonumber(Month), tonumber(Day), tonumber(Hour), tonumber(Minute)
  local Timestamp = os.time({
    year = Year,
    month = Month,
    day = Day,
    hour = Hour,
    min = Minute,
    sec = 0
  })
  Timestamp = Timestamp + (DstTimeZone - SrcTimeZone) * 3600
  local Date = os.date("*t", Timestamp)
  Year, Month, Day, Hour, Minute = Date.year, Date.month, Date.day, Date.hour, Date.min
  return Year, Month, Day, Hour, Minute
end

function M:_MakeTimeStrReal(YY, MM, DD, H, M, YY1, MM1, DD1, H1, M1, TimeZone, TZStr)
  TZStr = TZStr or ""
  local Year, Month, Day, Hour, Minute = self:_TranslateTime(YY, MM, DD, H, M, TimeZone)
  local TimeArgs = TArray(FFormatArgumentData)
  self:_AddFormatArg(TimeArgs, "YY", Year)
  self:_AddFormatArg(TimeArgs, "MM", Month)
  self:_AddFormatArg(TimeArgs, "DD", Day)
  self:_AddFormatArg(TimeArgs, "H", Hour)
  self:_AddFormatArg(TimeArgs, "M", Minute)
  if YY1 and MM1 and DD1 and M1 and H1 then
    local Year1, Month1, Day1, Hour1, Minute1 = self:_TranslateTime(YY1, MM1, DD1, H1, M1, TimeZone)
    if Day ~= Day1 or Month ~= Month1 or Year ~= Year1 then
      self:_AddFormatArg(TimeArgs, "YY1", Year1)
      self:_AddFormatArg(TimeArgs, "MM1", Month1)
      self:_AddFormatArg(TimeArgs, "DD1", Day1)
    end
    self:_AddFormatArg(TimeArgs, "H1", Hour1)
    self:_AddFormatArg(TimeArgs, "M1", Minute1)
  end
  if 7 == TimeArgs:Length() then
    return UKismetTextLibrary.Format(GText("AnnouncementTimeFormatShort"), TimeArgs) .. TZStr
  elseif 10 == TimeArgs:Length() then
    return UKismetTextLibrary.Format(GText("AnnouncementTimeFormatLong"), TimeArgs) .. TZStr
  elseif 5 == TimeArgs:Length() then
    return UKismetTextLibrary.Format(GText("AnnouncementTimeFormatOne"), TimeArgs) .. TZStr
  end
end

function M:_MakeTimeStrCN(YY, MM, DD, H, M, YY1, MM1, DD1, H1, M1, TimeZone)
  return self:_MakeTimeStrReal(YY, MM, DD, H, M, YY1, MM1, DD1, H1, M1, TimeZone)
end

function M:_MakeTimeStrJP(YY, MM, DD, H, M, YY1, MM1, DD1, H1, M1, TimeZone)
  local AutoTZStr = GText("AnnouncementAutoTimeZone")
  local AutoTimeStr = self:_MakeTimeStrReal(YY, MM, DD, H, M, YY1, MM1, DD1, H1, M1, TimeZone, AutoTZStr)
  return AutoTimeStr
end

function M:_MakeTimeStrEN(YY, MM, DD, H, M, YY1, MM1, DD1, H1, M1, TimeZone)
  local AutoTZStr = string.format(GText("AnnouncementAutoTimeZone"), TimeZone >= 0 and "+" .. TimeZone or TimeZone)
  return self:_MakeTimeStrReal(YY, MM, DD, H, M, YY1, MM1, DD1, H1, M1, TimeZone, AutoTZStr)
end

function M:_MakeTimeStrKR(YY, MM, DD, H, M, YY1, MM1, DD1, H1, M1, TimeZone)
  return self:_MakeTimeStrJP(YY, MM, DD, H, M, YY1, MM1, DD1, H1, M1, TimeZone)
end

function M:_MakeTimeStrTC(YY, MM, DD, H, M, YY1, MM1, DD1, H1, M1, TimeZone)
  return self:_MakeTimeStrEN(YY, MM, DD, H, M, YY1, MM1, DD1, H1, M1, TimeZone)
end

function M:_MakeNewTimeStr(YY, MM, DD, H, M, YY1, MM1, DD1, H1, M1)
  local Language = CommonConst.SystemLanguage
  local Tag = ""
  if Language == CommonConst.SystemLanguages.CN then
    Tag = "CN"
  elseif Language == CommonConst.SystemLanguages.TC then
    Tag = "TC"
  elseif Language == CommonConst.SystemLanguages.EN then
    Tag = "EN"
  elseif Language == CommonConst.SystemLanguages.JP then
    Tag = "JP"
  elseif Language == CommonConst.SystemLanguages.KR then
    Tag = "KR"
  end
  local TimeZone = self:_GetTimeZone()
  return self["_MakeTimeStr" .. Tag](self, YY, MM, DD, H, M, YY1, MM1, DD1, H1, M1, TimeZone)
end

function M:ParseTimeOfContent(Content)
  local Replacement = {}
  for TimeStr in string.gmatch(Content, AnnounceCommon.LongTimeFormat) do
    if not Replacement[TimeStr] then
      local YY, MM, DD, H, M, YY1, MM1, DD1, H1, M1 = string.gmatch(TimeStr, AnnounceCommon.LongYMDHMFormat)()
      local NewTimeStr = self:_MakeNewTimeStr(YY, MM, DD, H, M, YY1, MM1, DD1, H1, M1)
      Replacement[TimeStr] = NewTimeStr
    end
  end
  for TimeStr in string.gmatch(Content, AnnounceCommon.ShortTimeFormat) do
    if not Replacement[TimeStr] then
      local YY, MM, DD, H, M, H1, M1 = string.gmatch(TimeStr, AnnounceCommon.ShortYMDHMFormat)()
      local YY1, MM1, DD1 = YY, MM, DD
      local NewTimeStr = self:_MakeNewTimeStr(YY, MM, DD, H, M, YY1, MM1, DD1, H1, M1)
      Replacement[TimeStr] = NewTimeStr
    end
  end
  for TimeStr in string.gmatch(Content, AnnounceCommon.OneTimeFormat) do
    if not Replacement[TimeStr] then
      local YY, MM, DD, H, M = string.gmatch(TimeStr, AnnounceCommon.OneYMDHMFormat)()
      local NewTimeStr = self:_MakeNewTimeStr(YY, MM, DD, H, M)
      Replacement[TimeStr] = NewTimeStr
    end
  end
  for Old, New in pairs(Replacement) do
    Content = UKismetStringLibrary.ReplaceInline(Content, Old, New)
  end
  return Content
end

function M:_ResetReddot()
  if not ReddotManager.GetTreeNode(DataMgr.ReddotNode.AnnouncementItems.Name) then
    ReddotManager.AddNode(DataMgr.ReddotNode.AnnouncementItems.Name)
  end
  ReddotManager.ClearLeafNodeCount("ActivityAnnouncement")
  ReddotManager.ClearLeafNodeCount("SystemAnnouncement")
  ReddotManager.ClearLeafNodeCount("NewsAnnouncement")
  ReddotManager.ClearLeafNodeCount("AnnouncementDirty")
end

function M:_TryAddReddotCacheDetail(Conf)
  local CacheKey = tostring(Conf.NoticeID)
  local ReddotName = M:GetReddotNameByConf(Conf)
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotName)
  if CacheDetail and nil == CacheDetail[CacheKey] then
    CacheDetail[CacheKey] = true
    M.HasNewAdd = true
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
  local ReddotName = M:GetReddotNameByConf(Conf)
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotName)
  if CacheDetail and CacheDetail[CacheKey] then
    CacheDetail[CacheKey] = false
    ReddotManager.DecreaseLeafNodeCount(ReddotName)
  end
  M:_UpdateAnnouncementReddotState()
end

function M:_SyncReddotCache()
  local CacheDetail1 = ReddotManager.GetLeafNodeCacheDetail("SystemAnnouncement")
  local CacheDetail2 = ReddotManager.GetLeafNodeCacheDetail("ActivityAnnouncement")
  local CacheDetail3 = ReddotManager.GetLeafNodeCacheDetail("NewsAnnouncement")
  local ExistConf = {}
  for _, Conf in ipairs(M.Confs) do
    ExistConf[tostring(Conf.NoticeID)] = Conf
  end
  M:_RealSyncReddotCache(CacheDetail1, ExistConf, "SystemAnnouncement")
  M:_RealSyncReddotCache(CacheDetail2, ExistConf, "ActivityAnnouncement")
  M:_RealSyncReddotCache(CacheDetail3, ExistConf, "NewsAnnouncement")
end

function M:_RealSyncReddotCache(CacheDetail, ExistConf, ReddotName)
  for Key, Value in pairs(CacheDetail or {}) do
    if not ExistConf[Key] or M:GetReddotNameByConf(ExistConf[Key]) ~= ReddotName then
      CacheDetail[Key] = nil
    end
  end
end

function M:_UpdateAnnouncementReddotState()
  local Ret = false
  for _, ReddotKey in ipairs(SubReddotKeys) do
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotKey)
    for _, value in pairs(CacheDetail or {}) do
      if true == value then
        Ret = true
        break
      end
    end
    if Ret then
      break
    end
  end
  if Ret then
    ReddotManager.IncreaseLeafNodeCount("AnnouncementDirty")
  else
    ReddotManager.ClearLeafNodeCount("AnnouncementDirty")
  end
  return Ret
end

function M:_GetLocalAnnouncement()
  if not DataMgr.SystemNotice then
    return
  end
  for _, Conf in pairs(DataMgr.SystemNotice) do
    local NoticeDateParts = Conf.NoticeDate and Split(Conf.NoticeDate, "-")
    local StartTimestamp = NoticeDateParts and os.time({
      year = NoticeDateParts[1],
      month = NoticeDateParts[2],
      day = NoticeDateParts[3]
    }) or os.time()
    local EndDateParts = Conf.EndDate and Split(Conf.EndDate, "-")
    local EndTimestamp = EndDateParts and os.time({
      year = EndDateParts[1],
      month = EndDateParts[2],
      day = EndDateParts[3]
    })
    Conf = {
      NoticeID = Conf.NoticeID,
      NoticeTitle = GText(Conf.NoticeTitle),
      NoticeContent = GText(Conf.NoticeContent),
      NoticeStyle = Conf.NoticeStyle,
      NoticeTag = Conf.NoticeTag,
      NoticeBanner = Conf.NoticeBanner,
      NoticeDate = Conf.NoticeDate and Conf.NoticeDate .. " (UTC+8)",
      EndDate = Conf.EndDate and Conf.EndDate .. " (UTC+8)",
      StartTimestamp = StartTimestamp,
      EndTimestamp = EndTimestamp,
      Sort = Conf.NoticeID,
      Local = 1
    }
    M:_TryAddReddotCacheDetail(Conf)
    table.insert(M.Confs, Conf)
  end
end

function M:GetAnnouncementDataAsync(ShowTag, Coroutine, HostId)
  if GWorld:GetAvatar() then
    if not M._AnnouncementDirty then
      return
    end
    M:MarkDirty(false)
  end
  if nil == HostId then
    local PlayerAvatar = GWorld:GetAvatar()
    if PlayerAvatar and PlayerAvatar.Hostnum then
      HostId = tonumber(PlayerAvatar.Hostnum)
    else
      Utils.Traceback(ErrorTag, LXYTag .. "HostId不存在，不知道你选了什么服...")
      return
    end
  end
  ForceStopAsyncTask(M, "PendingCo")
  M.PendingCo = Coroutine
  M:_CacheLastConf()
  M.Confs = {}
  M.bInit = true
  if 0 ~= DataMgr.GlobalConstant.UseLocalSystemNotice.ConstantValue then
    M:_GetLocalAnnouncement()
  end
  M:_ResetReddot()
  DebugPrint("[Laixiaoyang] M:GetAnnoucementDataAsync 拉取后台游戏公告数据...")
  CdnTool:GetGameNotice(HostId, function(Infos)
    try({
      exec = function()
        if IsEmptyTable(Infos) then
          DebugPrint(WarningTag, LXYTag, "公告Json解析不出内容")
          return
        end
        for Key, Info in pairs(Infos) do
          DebugPrint(LogTag, LXYTag, "解析公告", Info.UniqueId)
          local Conf = {
            NoticeID = Info.UniqueId,
            StartTimestamp = Info.StartTimestamp or os.time(),
            EndTimestamp = Info.EndTimestamp or nil,
            NoticeBanner = Info.ClientOnly.BannerPath or "",
            NoticeStyle = tonumber(Info.ClientOnly.UIStyle) or 1,
            NoticeTag = tonumber(Info.ClientOnly.TypeTag) or 1,
            Sort = tonumber(Info.ClientOnly.notice_sort or "0"),
            TabTag = tonumber(Info.ClientOnly.TypeTag) or AnnounceCommon.TabTag.System,
            ShowTags = {},
            Local = 0
          }
          M:_ParseShowTag(Conf, Info)
          if not Conf.ShowTags[ShowTag] then
            DebugPrint(LXYTag, Info.UniqueId .. "公告不在这个场合显示")
          elseif not M:CheckChannel(Info) then
            DebugPrint(LXYTag, Info.UniqueId .. " 公告渠道检测不通过")
          else
            if not M:CheckSubChannel(Info) then
              DebugPrint(LXYTag, Info.UniqueId .. " 公告子渠道检测不通过")
              return
            end
            if M:IsExpired(Conf) then
              DebugPrint(LXYTag, Info.UniqueId .. " 公告已过期")
            else
              local timeZoneOffset = CommonUtils.GetTimeZone()
              local TimeZonePostfix = " (UTC+" .. timeZoneOffset .. ")"
              Conf.NoticeDate = GDate_YMD_Timestamp(math.floor(Conf.StartTimestamp + 0.5)) .. TimeZonePostfix
              Conf.EndDate = Conf.EndTimestamp and GDate_YMD_Timestamp(math.floor(Conf.EndTimestamp + 0.5)) .. TimeZonePostfix
              Conf.NoticeTitle, Conf.NoticeContent = "", ""
              for _, Text in pairs(Info.Content or {}) do
                if CommonConst.SystemLanguage ~= CommonConst.SystemLanguages[Text.language] then
                  DebugPrint(LXYTag, Info.UniqueId .. " 公告语言对不上 跳过" .. Text.title)
                else
                  Conf.NoticeTitle = Text.title or ""
                  Conf.NoticeContent = Text.body or ""
                  Conf.NoticeContent = string.gsub(Conf.NoticeContent, "<n>", "\n")
                  Conf.NoticeBanner = Text.BannerPath
                  break
                end
              end
              if "" == Conf.NoticeTitle or "" == Conf.NoticeContent then
                print(_G.LogTag, Info.UniqueId .. " 公告当前语言的文本为空！！当前语言：" .. CommonConst.SystemLanguage)
              else
                M:_TryAddReddotCacheDetail(Conf)
                table.insert(M.Confs, Conf)
              end
            end
          end
        end
      end,
      catch = function(e)
        print(ErrorTag, e .. "\n" .. debug.traceback())
      end,
      final = function()
        self:_SortConfs()
        self:_SyncReddotCache()
        if M.PendingCo then
          coroutine.resume(M.PendingCo)
          M.PendingCo = nil
        end
      end
    })
  end)
  if M.PendingCo then
    coroutine.yield()
  end
end

function M:MarkDirty(bDirty)
  M._AnnouncementDirty = bDirty
  if bDirty then
    DebugPrint("[zhangyuhang] M:MakeDirty 准备重新请求公告")
  end
end

function M:UpdateAnnouncementDataInGame()
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    M:GetAnnouncementDataAsync_UseWeb(AnnounceCommon.ShowTag.InGame, nil, Avatar.Hostnum)
  end
  M:_ActivateScheduledNotices()
  return M:_UpdateAnnouncementReddotState()
end

function M:_CacheLastConf()
  M.LastConfs = {}
  for _, Conf in ipairs(M.Confs) do
    M.LastConfs[Conf.NoticeID] = Conf
  end
end

function M:_SortConfs()
  local function SortFunc(a, b)
    if a.Local ~= b.Local then
      return a.Local < b.Local
    end
    if a.Sort ~= b.Sort then
      return a.Sort > b.Sort
    end
    if a.StartTimestamp ~= b.StartTimestamp then
      return a.StartTimestamp > b.StartTimestamp
    end
  end
  
  table.sort(M.Confs, SortFunc)
end

function M:GetAnnouncementDataAsync_UseWeb(ShowTag, Coroutine, HostId)
  if GWorld:GetAvatar() then
    if not M._AnnouncementDirty then
      return
    end
    M:MarkDirty(false)
  end
  if nil == HostId then
    local PlayerAvatar = GWorld:GetAvatar()
    if PlayerAvatar and PlayerAvatar.Hostnum then
      HostId = tonumber(PlayerAvatar.Hostnum)
    else
      Utils.Traceback(ErrorTag, LXYTag .. "HostId不存在，不知道你选了什么服...")
      return
    end
  end
  ForceStopAsyncTask(M, "PendingCo")
  M.PendingCo = Coroutine
  M:_CacheLastConf()
  M.Confs = {}
  M.bInit = true
  M:_ResetReddot()
  DebugPrint("[Laixiaoyang] M:GetAnnoucementDataAsync 拉取后台游戏公告数据...")
  CdnTool:GetGameNotice(HostId, function(Infos)
    try({
      exec = function()
        if IsEmptyTable(Infos) then
          DebugPrint(WarningTag, LXYTag, "公告Json解析不出内容")
          return
        end
        for Key, Info in pairs(Infos) do
          M:_AddNewConf(Info, ShowTag)
        end
      end,
      catch = function(e)
        print(ErrorTag, e .. "\n" .. debug.traceback())
      end,
      final = function()
        self:_SortConfs()
        self:_SyncReddotCache()
        if M.PendingCo then
          coroutine.resume(M.PendingCo)
          M.PendingCo = nil
        end
      end
    })
  end)
  if M.PendingCo then
    coroutine.yield()
  end
end

function M:_AddNewConf(Info, ShowTag)
  DebugPrint(LogTag, LXYTag, "解析公告", Info.UniqueId)
  local Conf = {
    NoticeID = Info.UniqueId,
    StartTimestamp = Info.StartTimestamp or os.time(),
    EndTimestamp = Info.EndTimestamp or nil,
    NoticeBanner = Info.ClientOnly.BannerPath or "",
    NoticeStyle = tonumber(Info.ClientOnly.UIStyle) or 1,
    NoticeTag = tonumber(Info.ClientOnly.TypeTag) or 1,
    Sort = tonumber(Info.ClientOnly.notice_sort or "0"),
    TabTag = tonumber(Info.ClientOnly.TypeTag) or AnnounceCommon.TabTag.System,
    UIStyle = tonumber(Info.ClientOnly.UIStyle) or 1,
    ShowTags = {},
    Local = 0,
    HtmlUrl = nil
  }
  M:_ParseShowTag(Conf, Info)
  if not Conf.ShowTags[ShowTag] then
    DebugPrint(LXYTag, Info.UniqueId .. "公告不在这个场合显示, 当前游戏场合：" .. ShowTag)
    return
  end
  if not M:CheckChannel(Info) then
    DebugPrint(LXYTag, Info.UniqueId .. " 公告渠道检测不通过")
    return
  end
  if not M:CheckSubChannel(Info) then
    DebugPrint(LXYTag, Info.UniqueId .. " 公告子渠道检测不通过")
    return
  end
  if M:IsExpired(Conf) then
    DebugPrint(LXYTag, Info.UniqueId .. " 公告已过期")
    return
  end
  if M:IsFutureNotice(Conf) then
    self.FutureConfs[Info.UniqueId] = {Info = Info, ShowTag = ShowTag}
    DebugPrint(LXYTag, Info.UniqueId .. " 将来的公告已缓存")
    return
  end
  local timeZoneOffset = CommonUtils.GetTimeZone()
  local TimeZonePostfix = " (UTC+" .. timeZoneOffset .. ")"
  Conf.NoticeDate = GDate_YMD_Timestamp(math.floor(Conf.StartTimestamp + 0.5)) .. TimeZonePostfix
  Conf.EndDate = Conf.EndTimestamp and GDate_YMD_Timestamp(math.floor(Conf.EndTimestamp + 0.5)) .. TimeZonePostfix
  M:_ParseContent(Conf, Info)
  if "" == Conf.NoticeTitle or "" == Conf.NoticeContent then
    DebugPrint(LXYTag, ErrorTag, Info.UniqueId .. " 公告当前语言的内容为空！！当前游戏语言：" .. CommonConst.SystemLanguage)
    return
  end
  M:_TryAddReddotCacheDetail(Conf)
  table.insert(M.Confs, Conf)
end

function M:IsExpired(Conf)
  if not Conf.EndTimestamp then
    return false
  end
  local NowTimestamp = os.time()
  local Res = false
  if NowTimestamp > Conf.EndTimestamp then
    Res = true
  end
  if Res then
    M:TrySubReddotCacheDetail(Conf)
  end
  return Res
end

function M:IsFutureNotice(Conf)
  if not Conf.StartTimestamp then
    return false
  end
  local NowTimestamp = os.time()
  return NowTimestamp < Conf.StartTimestamp
end

function M:_ParseContent(Conf, Info)
  Conf.NoticeTitle, Conf.NoticeContent = "", ""
  for _, Text in pairs(Info.Content or {}) do
    if CommonConst.SystemLanguage == CommonConst.SystemLanguages[Text.language] then
      Conf.NoticeTitle = Text.title
      if Conf.NoticeStyle == AnnounceCommon.ContentUIStyle.Default then
        if not Text.title1 or "" == Text.title1 then
          Text.title1 = Text.title
        end
        Conf.NoticeContent = string.format(AnnounceCommon.DefaultContent, Text.title1, Text.body)
      elseif Conf.NoticeStyle == AnnounceCommon.ContentUIStyle.ImageOnly then
        Conf.NoticeContent = string.format(AnnounceCommon.ImageOnlyContent, Text.noticeImageURL, Text.noticeImage)
      else
        DebugPrint(LXYTag, ErrorTag, "未定义的公告内容样式：" .. Conf.NoticeStyle)
      end
      return
    else
      DebugPrint(LXYTag, Info.UniqueId .. " 公告语言对不上 跳过" .. Text.title)
    end
  end
end

function M:_ParseShowTag(Conf, Info)
  if MiscUtils.IsNilOrEmpty(Info.ClientOnly.noticeType) then
    Conf.ShowTags = {1, 1}
    return
  end
  local ShowTags = string.split(Info.ClientOnly.noticeType, ",")
  for _, ShowTag in ipairs(ShowTags) do
    if not tonumber(ShowTag) then
      Conf.ShowTags = {1, 1}
      break
    end
    DebugPrint(LXYTag, "公告允许显示的场合：" .. ShowTag)
    Conf.ShowTags[tonumber(ShowTag)] = 1
  end
end

M.bIndepChannel = false

function M:CheckChannel(Info)
  local ChannelId = Utils.HeroUSDKSubsystem():GetChannelId()
  if not ChannelId then
    DebugPrint(ErrorTag, "本包没有ChannelId，跳过公告渠道检测")
    return true
  end
  if not DataMgr.ChannelInfo[ChannelId] then
    DebugPrint(ErrorTag, string.format("ChannelInfo表里没有定义这种ChannelId:%s, 跳过公告渠道检测", ChannelId))
    return true
  end
  local Provider = -1 ~= ChannelId and DataMgr.ChannelInfo[ChannelId].Provider
  if Info.Channels and type(Info.Channels) ~= "table" then
    DebugPrint(ErrorTag, "AnnounceUtils:CheckChannel  Info.Channels 后台传来的类型非法！！！不是Table !!!!!", Info.Channels)
    return true
  end
  if table.isempty(Info.Channels) then
    DebugPrint(ErrorTag, "#Info.Channels 是空的 !!!!")
    return true
  end
  DebugPrint(TXTTag, "看看这个包的SdkChannelId：" .. ChannelId .. " 和平台：" .. AnnounceCommon.PlatformName)
  if -1 == ChannelId then
    DebugPrint(WarningTag, "开发环境的ChannelId是-1，跳过渠道检测")
    return true
  end
  PrintTable(Info.Channels, 2, "看看公告自身的ChannelId ")
  for i, Channel in pairs(Info.Channels) do
    if Channel.code == Provider or Channel.code == ChannelId then
      if AnnounceCommon.SpecialChannelName[Provider] then
        M.bIndepChannel = true
      end
      return true
    end
  end
  return false
end

function M:ResetConf()
  M.bInit = false
  M.Confs = {}
end

function M:CheckSubChannel(Info)
  if M.bIndepChannel then
    DebugPrint("独立渠道忽略子渠道检测...")
    M.bIndepChannel = false
    return true
  end
  local SubChannelId = Utils.HeroUSDKSubsystem():GetMirrorChannelId()
  local Provider = -1 ~= SubChannelId and DataMgr.ImgChannelInfo[SubChannelId].Provider
  if Info.img_channel_id and type(Info.img_channel_id) ~= "table" then
    DebugPrint(ErrorTag, "AnnounceUtils:CheckSubChannel Info.img_channel_id 后台传来的类型非法！！！不是Table !!!!!", Info.img_channel_id)
    return true
  end
  if table.isempty(Info.img_channel_id) then
    DebugPrint(ErrorTag, "Info.img_channel_id 是空的 !!!!!")
    return true
  end
  DebugPrint(TXTTag, "看看这个包的(Sub)MirrorChannelId：" .. SubChannelId)
  if -1 == SubChannelId then
    DebugPrint(WarningTag, "开发环境的(Sub)MirrorChannelId是-1，跳过渠道检测")
    return true
  end
  PrintTable(Info.img_channel_id, 2, "看看公告自身的(Sub)MirrorChannelId")
  for i, SubChannel in pairs(Info.img_channel_id) do
    if tonumber(SubChannel.code) == SubChannelId or SubChannel.code == Provider then
      return true
    end
  end
  return false
end

function M:CheckPlatform(Code)
  Code = tonumber(Code)
  if AnnounceCommon.PlatformName == DataMgr.ChannelInfo[Code].OS then
    return true
  end
  return false
end

function M:ResetNew()
  M.HasNewAdd = false
end

function M:TrySetServerAreaNew(HostId)
  local CacheDetail = EMCache:Get("VisitedHostTableForAnnouncement") or {}
  if CacheDetail["Server" .. HostId] ~= nil then
    return
  end
  CacheDetail["Server" .. HostId] = 1
  EMCache:Set("VisitedHostTableForAnnouncement", CacheDetail)
  M.HasNewAdd = true
end

function M:_ActivateScheduledNotices()
  local ToRemove = {}
  for id, value in pairs(M.FutureConfs or {}) do
    if not M:IsFutureNotice(value.Info) then
      M:_AddNewConf(value.Info, value.ShowTag)
      table.insert(ToRemove, id)
    end
  end
  if not table.isempty(ToRemove) then
    for _, id in ipairs(ToRemove) do
      M.FutureConfs[id] = nil
    end
    self:_SortConfs()
    self:_SyncReddotCache()
  end
end

function M:_RemoveExpiredNotices()
  for i = #M.Confs, 1, -1 do
    local Conf = M.Confs[i]
    if M:IsExpired(Conf) then
      table.remove(M.Confs, i)
    end
  end
end

function M:FilterConfForUI(TabTag, ShowTag)
  M:_ActivateScheduledNotices()
  M:_RemoveExpiredNotices()
  local RetConfs = {}
  for _, Conf in pairs(M.Confs) do
    if TabTag == Conf.TabTag and Conf.ShowTags[ShowTag] then
      table.insert(RetConfs, Conf)
    end
  end
  return RetConfs
end

function M:OpenAnnouncementMain(ShowTag, bNeedRequest, HostId, ParentWidget, Coroutine)
  if M.bFontLoading then
    UIManager(GWorld.GameInstance):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Toast_NetDelay"))
    return
  end
  local CurMode = UIUtils.UtilsGetCurrentInputType()
  local PlatformName = CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance)
  if CurMode == ECommonInputType.Gamepad then
    PlatformName = "GamePad"
  end
  local Params = {
    bNeedRequest = bNeedRequest,
    HostId = HostId,
    ShowTag = ShowTag,
    CurrTabIdx = 1,
    TabConfigData = {
      PlatformName = PlatformName,
      Tabs = {
        {
          Text = GText(DataMgr.NoticeTab[1].Text),
          TabId = 1,
          Icon = DataMgr.NoticeTab[1].IconPath
        },
        {
          Text = GText(DataMgr.NoticeTab[2].Text),
          TabId = 2,
          Icon = DataMgr.NoticeTab[2].IconPath
        },
        {
          Text = GText(DataMgr.NoticeTab[3].Text),
          TabId = 3,
          Icon = DataMgr.NoticeTab[3].IconPath
        }
      },
      ChildWidgetBPPath = "WidgetBlueprint'/Game/UI/WBP/Announcement/Widget/WBP_Announcement_TabItem.WBP_Announcement_TabItem'"
    }
  }
  UIManager(GWorld.GameInstance):ShowCommonPopupUI(100134, Params, ParentWidget, Coroutine)
end

function M:UrlDecode(s)
  s = string.gsub(s, "%%(%x%x)", function(h)
    return string.char(tonumber(h, 16))
  end)
  return s
end

return M
