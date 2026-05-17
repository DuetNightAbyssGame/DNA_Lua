local ServerInfo = {}
function ServerInfo:New(info)
	local server = {}
	self.__index = self
	setmetatable(server, self)
	server:Init(info)
	return server
end

function ServerInfo:Init(info)
	-- 服务器id
	self.ServerId = info.hostnum or 0
	-- 服务器地区
	-- 国服：China
	-- 港澳台：HMT
	-- 亚服：Asian
	-- 美服：America
	-- 欧服：Europe
	self.Area = info.area or "China"
	-- 游戏服显示名称
	self.ServerName = info.name or ''
	-- 服务器对应的gate列表 {{ip, port}, {ip, port}, {ip, port}}
	self.ServerGateList = {}
	-- 渠道
	self.Channel = info.channel or ''
	-- 开服时间
	self.StartTime = info.start_time or ''
	-- 服务器语言
	self.ServerLanguage = info.language or ''
	-- 服务器是否被推荐
	self.IsRecommend = info.is_recommend or false
	-- 服务器推荐权重
	self.RecommendWeight = info.recommend_weight or 0
	-- 是否测试服
	self.IsDev = info.is_dev or false
	-- 是否是docker服
	self.IsDocker = info.is_docker or false
end

function ServerInfo:AddToGateList(gate_host)
	self.ServerGateList[#self.ServerGateList+1] = gate_host
end


local ServerListMgr = {}

ServerListMgr.Servers = {}

function ServerListMgr:QueryServerListCb(data)
	DebugPrint("QueryServerListCb", data)
	if not data or data == "" then
		DebugPrint("QueryServerList error, no data")
		return
	end
	local loadFunction, errorMessage = load(data)
    if errorMessage then
		DebugPrint("QueryServerList error, message is:",data)
		if GWorld.IsDev then
			self:AddDevServerList()
		else
			self:HandleServerList()
		end
        return
    end

    data = loadFunction()
	if data then
		self:GenerateServerList(data)
	end
	if GWorld.IsDev then
		self:AddDevServerList()
	else
		self:HandleServerList()
	end
end

function ServerListMgr:GenerateServerList(data)
	DebugPrint("GenerateServerList")
	for server_id, info in pairs(data) do
		local server = self.Servers[server_id]
		if not server then
			server = ServerInfo:New(info)
		end
		for index, v in ipairs(info.gateList) do
			server:AddToGateList({v.ip, v.port})
		end
		self.Servers[server_id] = server
	end
end

function ServerListMgr:AddDevServerList()
	DebugPrint("AddDevServerList")
	local DevServerList = require "BluePrints/UI/GameLogin/DevServerList"
	for server_id, info in pairs(DevServerList) do
		repeat
			if self.Servers[server_id] then
				break
			end
			info.is_dev = true
			local server = ServerInfo:New(info)
			local ip = info.ip
			local port = info.port
			server:AddToGateList({ip, port})
			self.Servers[server_id] = server
		until true
	end
	self:HandleServerList()
end

function ServerListMgr:HandleServerList()
	DebugPrint("HandleServerList begin")
	self.ServerAreaDict = {
		China = {},
		HMT = {},
		Asian = {},
		America = {},
		Europe = {}
	}
	if next(self.Servers) == nil then
		return
	end
	for server_id, server in pairs(self.Servers) do
		if not self.ServerAreaDict[server.Area] then
			self.ServerAreaDict[server.Area] = {}
		end
		local ServerArea = self.ServerAreaDict[server.Area]
		ServerArea[#ServerArea+1] = server
	end

	local function cmp(s1, s2)
		if s1.IsRecommend and s2.IsRecommend then
			if s1.RecommendWeight == s2.RecommendWeight then
				return s2.ServerId > s1.ServerId
			else
				return s1.RecommendWeight > s2.RecommendWeight
			end
		elseif s1.IsRecommend then
			return true
		elseif s2.IsRecommend then
			return false
		else
			return s2.ServerId > s1.ServerId
		end
	end
	local all_server = self.ServerAreaDict[self:GetServerArea()]
	table.sort(all_server, cmp)
	DebugPrint("HandleServerList end")
	-- PrintTable(self.ServerAreaDict, 5)


	if self.GetServerListCb then
		self.GetServerListCb(all_server)
	end
end

function ServerListMgr:GetServerArea()
	return GWorld.ChooseServerArea
end

function ServerListMgr:GetServers()
	if self.ServerAreaDict then
		return self.ServerAreaDict[self:GetServerArea()]
	end
end

function ServerListMgr:GetExamineKey()
	-- if HeroUSDKSubsystem(GWorld.GameInstance):IsBilibili() then
	-- 	return "Bilibili"
	-- end
	-- if HeroUSDKSubsystem(GWorld.GameInstance):IsGlobalSDK() then
	-- 	return "Global"
	-- end
		--local ChannelInfo=DataMgr.ChannelInfo[ChannelId].
		-- if ChannelInfo and ChannelInfo.SDKChannelId == CommonConst.SDKChannelId.China then
		-- 	return "CnOfficial"
		-- end
	local ChannelId=HeroUSDKSubsystem(GWorld.GameInstance):GetChannelId()
	local MirrorChannelId = HeroUSDKSubsystem(GWorld.GameInstance):GetMirrorChannelId()
	local ExamineKey = nil
	 for _, v in pairs(DataMgr.ExamineInfo) do
        if v.ChannelID and v.ChannelID == ChannelId then
			if v.MirrorChannelID then
                if v.MirrorChannelID == MirrorChannelId then
                    ExamineKey = v.ExamineKey
                    break
                end
            else
    	        ExamineKey = v.ExamineKey
            end
        end
    end
	if ExamineKey then
		return ExamineKey
	else
		print("执行GetCdnHideData出错，当前ChannelId:"..tostring(ChannelId).."当前MirrorChannelId:"..tostring(MirrorChannelId).."ExamineInfo中没有对应的ChannelId")
	end
end

return ServerListMgr