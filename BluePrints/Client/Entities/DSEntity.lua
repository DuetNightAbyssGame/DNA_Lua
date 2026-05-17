local Class = _G.TypeClass
local AvatarEntity = require "BluePrints.Client.Wrapper.Entity".AvatarEntity
local Assemble = require "NetworkEngine.Common.Assemble"
local MiscUtils = require "Utils.MiscUtils"
local DSEntity = Class("DSEntity", AvatarEntity)
local bHookGameModeReadyForInitNext = false

DSEntity.__Component__ = {
    "BluePrints.Client.Entities.DSComponents.DSRewardsComponent",
    "BluePrints.Client.Entities.DSComponents.DSBattleComponent",
	"BluePrints.Client.Entities.CommonComponents.ResourceUseComponent",
	"BluePrints.Client.Entities.CommonComponents.AutoBattleTestComponent",
	"BluePrints.Client.Entities.DSComponents.DSTargetComponent",
	"Blueprints.Client.Entities.CommonComponents.GameModeWalnutComponent",
	"Blueprints.Client.Entities.CommonComponents.DungeonGameObjectComponent",
	"Blueprints.Client.Entities.CommonComponents.ServerGameControlComponent",
	"Blueprints.Client.Entities.DSComponents.DSServerDungeonComponent",
}

local bStatusInPreloading = false

function DSEntity:Init(eid)
	DSEntity.Super.Init(self, eid)
	self.bClientEntity = false
	self.bStartSuccess = false
end

function DSEntity:InitFromDict(attrs)
end

function DSEntity:CreateSuccess()
    self:CallServerMethod("OnCreateClientEntity", true)
end

function DSEntity:BecomePlayer(DSStatus)
	if DSStatus == CommonConst.DSRunningStatus.Preloading then
		bStatusInPreloading = true
	end
	DSEntity.Super.BecomePlayer(self)
end

function DSEntity:OnBecomePlayer()
	DSEntity.Super.OnBecomePlayer(self)
	self.logger.info("DSEntity OnBecomePlayer")
	self:EnterWorld()

	local BP_Avatar = GWorld.GameInstance:GetAvatar()
	if BP_Avatar then
		BP_Avatar:SetDSEntity(self)
	end
	self:StartSuccess()
	self:QueryHotfix()
end

function DSEntity:QueryHotfix()
	local index = GWorld.HotfixDataIndex or 0
	self:CallServerMethod("QueryHotfix", index)
end

function DSEntity:OnQueryHotfixSuccess(HotfixScript, HotfixIndex)
	ServerPrint("OnQueryHotfixSuccess", HotfixScript, HotfixIndex)
	-- 执行热更
	if HotfixIndex then
		require("HotFix").ExecHotFix(HotfixIndex, HotfixScript)
		GWorld.HotfixDataIndex = HotfixIndex
	end
end

function DSEntity:CallSkynetServerMethod(FuncName, ...)
	self:CallServerMethod(FuncName, ...)
end

function DSEntity:CallSkynetServerCallback(CallbackId, ...)
	self:CallServerMethod("CallSkynetServerCallback", CallbackId, ...)
end

-- DS启动成功，并通知skynet
function DSEntity:StartSuccess()
	self:TestHotUpdate()
	local GameInstance = GWorld.GameInstance
	local Pid = GameInstance:GetPID()
	local PPid = GameInstance:GetPPid()
	local DSVersion = MiscUtils.GetGameCofingSettings("DSVersion") or 0
	local LogPath = GameInstance:LogPath()
	local DSType = GameInstance.DSType
	if GameInstance.DSType ~= CommonConst.DSType.Root then
		local DungeonId = GameInstance.TargetDungeonId
		if not DungeonId then
			error("DungeonId is nil")
		end

		if WorldTravelSubsystem():GetCurrentSceneId() ~= DungeonId then
			self:ChangeMap(DungeonId)
		else
			GameInstance:UpdateNetDriverInfo()
		end
	end

	local Ip = GameInstance.LastUploadIp
	local Port = GameInstance.LastUploadPort
	local DSInfo = {
		Ip = Ip,
		Port = Port,
		Type = DSType,
		Pid = Pid,
		PPid = PPid,
		Hostnum = GameInstance.DSConnectHostnum,
		DSVersion = DSVersion,
		LogPath = LogPath,
		bDynamic = GameInstance.bDynamicNode,
		LocalUser = UE.UKismetSystemLibrary:GetPlatformUserName(),
		DungeonId = GameInstance.TargetDungeonId,
	}
	ServerPrint("Ip, Port, PID, PPID, DSVersion, LogPath", Ip, Port, Pid, PPid, DSVersion, LogPath)

	local callback = function (ret, LogParam)
		-- 到这里才算Init启动阶段成功，启动脚本退出，由逻辑服监控DS生命周期
		if DSVersion ~= 0 and DSType == CommonConst.DSType.Root then
			if bStatusInPreloading then
				self:StartPreload()
			else
				GameInstance:RecordRunningSuccess()
				self:HotUpdate()
			end

			self:UpdateDSLogSetting(LogParam) -- 只有DSRoot需要在启动时设置日志参数
		end
	end

	if GameInstance.DSType == CommonConst.DSType.Root and bStatusInPreloading then
		self:CallServer("StartSuccess", callback)
	else
		self:CallServer("StartSuccess", callback, DSInfo)
	end
	self.bStartSuccess = true
end

function DSEntity:UpdateNetDriverInfo(ip, port)
	if not self.bStartSuccess then
		return
	end

	if ip and port then
		self:CallServerMethod("UpdateNetDriverInfo", ip, port)
	end
end

-- 通知skynet玩家登录状况
function DSEntity:ConnectDSServerSuccess(AvatarEid, bReconnect)
	ServerPrint("ConnectDSServerSuccess", AvatarEid, bReconnect)
	self:CallSkynetServerMethod("ConnectDSServerSuccess", AvatarEid, bReconnect)
end

-- 通知skynet玩家断开DS
function DSEntity:DisconnectDSServerSuccess(AvatarEid)
	ServerPrint("DisconnectDSServerSuccess", AvatarEid)
	self:CallServerMethod("DisconnectDSServerSuccess", AvatarEid)
end


function DSEntity:CloseDS(Reason)
	self.logger.debug("CloseDS", Reason)
	GWorld.GameInstance:CloseDS(Reason)
end

function DSEntity:ChangeMap(DungeonId)
	ServerPrint("Change to Map: ", DungeonId)
	self:TryCreateServerDungeon(DungeonId)
	self.HasLeaveAvatars = {} -- 本地服重置玩家
	self.bBlock = false -- 本地服重置BlockEntrance
	GWorld.GameInstance:ChangeMapAsDedicatedServer(DungeonId)
end

function DSEntity:SystemRequireGameModeInitWithoutAnyPlayer()
	bHookGameModeReadyForInitNext = true
	local GameMode = GWorld.GameInstance:GetCurrentGameMode()
	GameMode:SetGameStartType(0)
end

function DSEntity:HookGameModeReady(GameMode)
	if self.IsAutoBattle then
		-- todo 挂AIController
		GameMode:TryTriggerOnRealInit() -- @SnowMoon ? DSEntity上没有AvatarEid啊？先去掉看看有没有问题
	end

	if bHookGameModeReadyForInitNext then
		GameMode:RealInit()
	end

	local GameInstance = GWorld.GameInstance
	if GameInstance.DSType == CommonConst.DSType.Child then
		-- 子节点通知DS集群，自己已经完成前置加载，可以开始Fork了
		self:CallServerMethod("FinishChangeMap", GameInstance.TargetDungeonId)
	end
end

function DSEntity:KickPlayer(PlayerId)
	local ret
	local GameMode = GWorld.GameInstance:GetCurrentGameMode()
	if PlayerId then
		ret = GameMode:KickPlayer(PlayerId)
	else
		ret = GameMode:KickAllPlayers()
	end

	self:CallServerMethod("OnKickPlayer", ret, PlayerId)
end

--TODO:PET
function DSEntity:ForkSubProcess(ForkNums, DSType, DungeonId)
	GWorld.GameInstance.TargetDungeonId = DungeonId
	GWorld.GameInstance:SetForkInfo(ForkNums, DSType)
	GWorld.GameInstance:StartFork()
end

function DSEntity:StartPreload()
	GWorld.GameInstance:GetDSAssetsManager():PreLoadAssets()
end

function DSEntity:QueryDeviceInfo(Callback)
	print(_G.LogTag, "QueryDeviceInfo")
	local Info = {}
	Info.CPUCores = GWorld.GameInstance:GetNumberOfCores()
	self:CallSkynetServerCallback(Callback, Info)
end

function DSEntity:TriggerCondition(ConditionId)
	self:CallServerMethod("TriggerCondition", ConditionId)
end

function DSEntity:HotUpdate()
	GWorld.GameInstance:GetDSAssetsManager():HotUpdate()
end

function DSEntity:HotPatch(bNeedRestart)
	GWorld.GameInstance:QuickRestartProcess(bNeedRestart, false)
end

function DSEntity:UpdateDSLogSetting(LogParam)
	local WhiteCategory = TArray(FName)
	local BlackCategory = TArray(FName)
	local WhiteContent = TArray("")
	local BlackContent = TArray("")
	local function AddToArray(Arr, T)
		for i=1, #T do
			Arr:Add(T[i])
		end
	end

	LogParam = LogParam or {}
	for k, v in pairs(LogParam) do
		if k == "WhiteCategory" then
			AddToArray(WhiteCategory, v)
		elseif k == "BlackCategory" then
			AddToArray(BlackCategory, v)
		elseif k == "WhiteContent" then
			AddToArray(WhiteContent, v)
		elseif k == "BlackContent" then
			AddToArray(BlackContent, v)
		end
	end
	GWorld.GameInstance:UpdateDSLogSetting(WhiteCategory, BlackCategory, WhiteContent, BlackContent)
end

-- 广播通知到所有逻辑服上的Avatar方法
function DSEntity:ServerMulticast(FuncName, ...)
	print(_G.LogTag, "ServerMulticast", FuncName)
	self:CallServerMethod("Multicast", FuncName, ...)
end

-- 调用逻辑服上某个Avatar的方法
function DSEntity:SendAvatar(AvatarEid, FuncName, ...)
	if not AvatarEid then
		print(_G.LogTag, "SendAvatar with nil AvatarEid")
		return
	end
	--print(_G.LogTag, "SendAvatar", CommonUtils.ObjId2Str(AvatarEid), FuncName)
	self:CallServerMethod("DSSendAvatar", AvatarEid, FuncName, ...)
end

function DSEntity:ServerConditionalMulticast(ConditionalAvatars, FuncName, ...)
	print(_G.LogTag, "ServerConditionalMulticast", FuncName)
	self:CallServerMethod("ConditionalMulticast", ConditionalAvatars, FuncName, ...)
end

function DSEntity:LeaveWorld()
end

--- TEST METHODS
function DSEntity:Ping()
	self:CallServerMethod("Echo")
end

function DSEntity:DSStat(Cmd)
	print(_G.LogTag, "DSStat", Cmd)
	GWorld.GameInstance:ExecuteCmd(Cmd)
end

function DSEntity:TestHotUpdate()
	print(_G.LogTag, "TestHotUpdate", false)
end

--- 发送战斗内错误信息 
---@param msg string
---@param msg_title string
function DSEntity:SendToFeishuForBattle(msg, msg_title)
	self:CallServerMethod("SendToFeishuForBattle", msg, msg_title)
end

-- local trace_type = {
-- 	first = "剧情",
-- 	second = "第一章",
-- 	third = "其余分类",
-- }
-- local describe_info = {
-- 	title = "test_trace",
-- 	trace_content = "test_content"
-- }
---@param trace_type table
---@param describe_info table
function DSEntity:SendTraceToQaWeb(trace_type, describe_info)
	self:CallServerMethod("SendTraceToQaWeb", trace_type, describe_info)
end

function DSEntity:BLog(...)
	self:CallServerMethod("DSBLog", ...)
end

-- 副本联机DS发送错误信息用（尽管接口叫Region）
function DSEntity:SendToFeiShuForRegionMgr(msg, msg_title)
	self:CallServerMethod("SendToFeiShuForRegionMgr", msg, msg_title)
end

function DSEntity:SendToFeishuForMonster(msg, msg_title)
	self:CallServerMethod("SendToFeiShuForMonster", msg, msg_title)
end


Assemble.AssembleComponents(DSEntity)
return DSEntity
