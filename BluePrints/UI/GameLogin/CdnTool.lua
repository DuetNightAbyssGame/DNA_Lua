local CdnTool = {}
local Private = {}
local CdnPath = require "BluePrints/UI/GameLogin/CdnPath"
local Json = require "rapidjson"

local print = function(...)
	print(_G.LogTag,"CdnTool",... )
end

function Private.JsonFileToTable(Content)
	local ok, Tb = pcall(Json.decode, Content)
	if not ok then
		print("[Private.JsonFileToTable] Json.decode Error:", Content)
		return false
	end
	return true, Tb
end

function Private.LuaFileToTable(Content)
	local loadFunction, errorMessage = load(Content)
	if errorMessage then
		print("[Private.LuaFileToTable] Content Error:",Content)
		return false
	end
	local tb = loadFunction()
	if not tb or type(tb) ~= "table" then
		print("[Private.LuaFileToTable] Content is not a table:",Content)
		return false
	end
	return true, tb
end

function Private.CdnGet(CdnUrls,Path,ToTableFunc,Cb)
	local CurrentUrlIndex = 1
	local HttpGetCb 
	HttpGetCb = function (Content)
		print("[Private.CdnGet] URL",CdnUrls[CurrentUrlIndex] .. Path,"Content",Content)
		local ok, Tb = ToTableFunc(Content)
		if ok then
			-- print("[Private.CdnGet] Get Success", Content)
			return Cb(Tb,Content)
		else
			CurrentUrlIndex = CurrentUrlIndex + 1
			if CurrentUrlIndex > #CdnUrls then
				print("[Private.CdnGet] All Failed:", Path)
				return Cb(nil)
			end
			print("[Private.CdnGet] TryAgain Count:",CurrentUrlIndex , CdnUrls[CurrentUrlIndex] .. Path)
			UE.URuntimeCommonFunctionLibrary.HttpGet(CdnUrls[CurrentUrlIndex] .. Path, {GWorld.GameInstance, function (_,Content) HttpGetCb(Content) end})
		end
	end
	print("[Private.CdnGet] First Get:", CdnUrls[CurrentUrlIndex] .. Path)
	UE.URuntimeCommonFunctionLibrary.HttpGet(CdnUrls[CurrentUrlIndex] .. Path, {GWorld.GameInstance, function (_,Content) HttpGetCb(Content) end})
end

function Private.CdnGetLuaTable(CdnUrls,Path,Cb)
	Private.CdnGet(CdnUrls,Path,Private.LuaFileToTable,Cb)
end

function Private.CdnGetJson(CdnUrls,Path,Cb)
	Private.CdnGet(CdnUrls,Path,Private.JsonFileToTable,Cb)
end

function Private.TryUpdateFileOrUseCache(CdnUrls,VersionFilePath,FilePath,ToTable,Cb)
	print("[Private.TryUpdateFileOrUseCache] VersionFilePath:", VersionFilePath)
	print("[Private.TryUpdateFileOrUseCache] FilePath:", FilePath)

	local CacheFilePath = UEMPathFunctionLibrary.GetProjectSavedDirectory() .. FilePath
	local CacheFileContent = UE4.URuntimeCommonFunctionLibrary.LoadFile(CacheFilePath)
	-- print("[Private.TryUpdateFileOrUseCache] CacheFileContent:", CacheFileContent)
	local ok, CacheTable = ToTable(CacheFileContent)
	if not ok then
		print("[Private.TryUpdateFileOrUseCache] CacheFileContent is Error:",CacheFileContent)
	end
	
	CacheTable = CacheTable or {}
	local LocalVersion = CacheTable.Version or -1

	print("[Private.TryUpdateFileOrUseCache] LocalVersion:", LocalVersion )

	--拿CDN上的Version
	Private.CdnGet(CdnUrls,VersionFilePath,ToTable, function (VersionTable)
		VersionTable = VersionTable or {}
		local CDNVersion = VersionTable.Version or 0
		print("[Private.TryUpdateFileOrUseCache] CDNVersion:",CDNVersion)
		if CDNVersion == LocalVersion then
			print("[Private.TryUpdateFileOrUseCache] LocalVersion == CDNVersion, CacheTable:", LocalVersion)
			CacheTable.Version = nil
			return Cb(CacheTable)
		else
			--拿CDN上的Table
			Private.CdnGet(CdnUrls,FilePath,ToTable,function (ContentTable,Content)
				if not ContentTable then
					print("[Private.TryUpdateFileOrUseCache] Content is nil")
					return Cb(nil)
				end
				if ContentTable.Version ~= CDNVersion then
					print("[Private.TryUpdateFileOrUseCache] Version Not Match, VersionFile:",CDNVersion," ContentVersion:",ContentTable.Version)
				end
				UE.URuntimeCommonFunctionLibrary.SaveFile(CacheFilePath, Content)
				ContentTable.Version = nil
				return Cb(ContentTable)
			end)
		end
	end)
end



function CdnTool:GetGameNotice(ServerID,Cb)
	Private.TryUpdateFileOrUseCache(CdnPath:CdnUrl(ServerID),CdnPath:GameNoticeVersion(ServerID),CdnPath:GameNotice(ServerID),Private.LuaFileToTable,Cb,ServerID)
end

function CdnTool:GetMaintenance(ServerID,Cb)
	Private.CdnGetJson(CdnPath:CdnUrl(ServerID),CdnPath:Maintenance(ServerID),Cb)
end
function CdnTool:GetMaintenanceInterceptUrl(ServerID,Cb)
	Private.CdnGetJson(CdnPath:CdnUrl(ServerID),CdnPath:MaintenanceInterceptUrl(ServerID),Cb)
end

function CdnTool:GetGMUrlLink(Path,Cb)
	Private.CdnGetJson(CdnPath:CdnUrl(),Path,Cb)
end

function CdnTool:CdnUrl()
	return CdnPath:CdnUrl()[1]
end

function CdnTool:GetServerList(Cb)
	local CdnUrls = CdnPath:CdnUrl()
	Private.CdnGetLuaTable(CdnUrls, CdnPath:ServerList(), function (ContentTable, Content) 
		if not ContentTable then
			print("[CdnTool:CBT3GetGateIpPort] Cdn ServerListFile is nil",Content)
			Cb(nil) 
			return
		end
		print("[CdnTool:CBT3GetGateIpPort] ServerList Update Success",Content)
		Cb(ContentTable)
	end)
end

function CdnTool:GetCdnHideData(HostId)
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		GWorld.logger.error("执行GetCdnHideData出错，Avatar不存在!!!")
		return
	end
	-- local ChanelString=GWorld.ServerListMgr:GetChanelString()
	-- if not ChanelString then
	-- 	return
	-- end
	local HideDataPath = CdnPath:GetHideUICtrl(HostId)
	print("[CdnTool] 开始执行GetCdnHideData, Url:", HideDataPath)
	Private.CdnGetJson(CdnPath:CdnUrl(HostId),HideDataPath, function (Infos)
		try ({
			exec = function() 
				if not Infos then
					print("执行GetCdnHideData出错，没取到CdnData,CdnPath:"..tostring(CdnPath:CdnUrl(HostId))..HideDataPath)
					return
				end
				local Avatar = GWorld:GetAvatar()
				if not Avatar then
					GWorld.logger.error("执行GetCdnHideData出错，json解析失败!!!")
					return
				end
				local ExamineKey=GWorld.ServerListMgr:GetExamineKey()
				if not ExamineKey then
					print("执行GetCdnHideData出错，ExamineKey为空,CdnPath:"..tostring(CdnPath:CdnUrl(HostId))..HideDataPath)
					return
				end
				if not Infos[ExamineKey] then
					print("执行GetCdnHideData出错，收到的数据中没有对应ExamineKey数据,CdnPath:"..tostring(CdnPath:CdnUrl(HostId))..HideDataPath,"当前ExamineKey:"..ExamineKey)
					return
				end
				Avatar.CdnHideData = Infos[ExamineKey]
				PrintTable(Avatar.CdnHideData, 10, "CdnHideData")
				print("[CdnTool] 执行GetCdnHideData成功, Url:", HideDataPath, ",可以通过gm PrintTable(A.CdnHideData)查看详细数据。")
			end
			,
			catch = function(e)
				-- print(e)
				GWorld.logger.error("执行GetCdnHideData出错，未知错误\n"..tostring(e))
			end,
			final = function ()
			end
		})
	end)
end

function CdnTool:GetAllAvatars(Account, Callback)
	GWorld.NetworkMgr.IsQuickLogin = false

	local function OnGetServerList(Servers)
		if not Servers or CommonUtils.Size(Servers) == 0 then
			print("[CdnTool:GetAllAvatars] ServerList is nil", Servers)
			Callback(false, "Get ServerList Failed")
			return
		end

		local _ServerList = {}
		if not AHotUpdateGameMode.IsGlobalPak() then
			for _, ServerInfo in pairs(Servers) do
				table.insert(_ServerList, ServerInfo)
			end
		else
			local RegionCode = HeroUSDKSubsystem():GetCountryCode()
			if RegionCode then
				local RegionCodeData = DataMgr.CountryRegionCode[RegionCode]
				if RegionCodeData and RegionCodeData.ServerArea then
					for _, ServerInfo in pairs(Servers) do
						if ServerInfo.area == RegionCodeData.ServerArea then
							table.insert(_ServerList, ServerInfo)
						end
					end
				end
			end
			if #_ServerList == 0 then
				for _, ServerInfo in pairs(Servers) do
					table.insert(_ServerList, ServerInfo)
				end
			end
		end
		local RandomIndex = math.random(1, #_ServerList)
		local Info = _ServerList[RandomIndex]
		GWorld.NetworkMgr:ConnectServer(Info.hostnum, Info.ip, Info.port, Account, false, true)
		Callback(true, "Start Connect Server, Please Wait...", Servers)
	end

	self:GetServerList(OnGetServerList)
end

return CdnTool