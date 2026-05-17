local IdManager = require "NetworkEngine.Common.IdManager"
local LogManager= require "NetworkEngine.Common.LogManager"
local StoryManager = require 'BluePrints.Story.StoryMgr'
local MiscUtils = require "Utils.MiscUtils"

---@class GWorld
local GWorld = {}
GWorld.logger = LogManager:GenClientLogger()
GWorld.GameInstance = nil
GWorld.NetworkMgr = nil
GWorld.EntityManager = nil
GWorld.EntityFactory = nil
GWorld.IdManager = IdManager
GWorld.ServerListMgr = nil
GWorld.CachedUI = {}
GWorld.BP_Avatar = nil

GWorld.LimitCallMethods = {}
GWorld.GlobalCallbackId = 0

GWorld.StoryMgr = StoryManager()

GWorld.bDebugServer = false
GWorld.IsForbidEntityMessage = false

-- 默认的显示设备
---@type  "'Mobile'" | "'PC'"
GWorld.DefaultDevice = nil

-- 是否 是开发版本
GWorld.IsDev = true

GWorld.EnterMode = ""

GWorld.EnterPlatform = ""

-- 服务器大区
-- 国服：China
-- 港澳台：HMT
-- 亚服：Asian
-- 美服：America
-- 欧服：Europe
GWorld.ChooseServerArea = "China"
GWorld.ServerAreaToGroupId = {
	Asian = 1001,
	HMT = 1002,
	Europe = 1003,
	America = 1004,
	China = 1005
}
GWorld.DevServerAreaToGroupId = {
	America = 501,
	Asian = 502,
	Europe = 503,
	HMT = 504,
	China = 101
}
-- 查询到的avatar信息
GWorld.GetAvatarInfos = nil

-- 系统开关
GWorld.IsOpenWroldRegion = false

-- hotfix
GWorld.HotfixDataIndex = DataMgr.HotfixData.index

function GWorld:IsGlobalServer()
	return AHotUpdateGameMode.IsGlobalPak()
end
function GWorld:IsChinaServer()
	return (AHotUpdateGameMode.IsGlobalPak() == false)
end

function GWorld:OpenWorldRegionState()
	GWorld.IsOpenWroldRegion = true
end

function GWorld:CloseWorldRegionState()
	GWorld.IsOpenWroldRegion = false
end

function GWorld:GetWorldRegionState()
	return GWorld.IsOpenWroldRegion
end

function GWorld:GenCallbackId()
	self.GlobalCallbackId = self.GlobalCallbackId + 1
	return self.GlobalCallbackId
end


function GWorld:GetBPAvatar()
	return self.BP_Avatar
end

-- @SnowMoon 获取作为客户端时与逻辑服通信的实体
function GWorld:GetAvatar()
	if self.BP_Avatar then
		return self.BP_Avatar:GetClientAvatar()
	end
	return nil
end

-- @SnowMoon 获取作为DS时与逻辑服通信的实体
function GWorld:GetDSEntity()
	if self.BP_Avatar then
		return self.BP_Avatar:GetDSEntity()
	end

	return nil
end

-- @SnowMoon 不关心自己的角色，获取与逻辑服通信的实体
function GWorld:GetServerEntity()
	if not self.BP_Avatar then
		return nil
	end

	local Entity = self.BP_Avatar:GetClientAvatar()
	if Entity then
		return Entity
	end

	Entity = self.BP_Avatar:GetDSEntity()
	if Entity then
		return Entity
	end

	return nil
end

function GWorld:DSBLog(...)
	local DSEntity = self:GetDSEntity()
	if not DSEntity then
		return
	end

	DSEntity:BLog(...)
end

function GWorld:GetCurrentTime()
	return UE4.UGameplayStatics.GetTimeSeconds(self.GameInstance)
end


-- 判断skynet和与之对应的客户端
function GWorld:IsSkynetServer()
	return false
end

---@return APlayerCharacter
function GWorld:GetMainPlayer()
	if self.GameInstance then
		local PC = UE4.UGameplayStatics.GetPlayerController(self.GameInstance, 0)
		if IsValid(PC) and PC.GetMyPawn then
			return PC:GetMyPawn()
		end
	end
	return nil
end

function GWorld:ForbidEntityMessage(flag)
	GWorld.IsForbidEntityMessage = tonumber(flag) == 1 and true or false
end

----------------------------------- 判断UE4的NetMode begin -----------------------------------
function GWorld:IsStandAlone()
	return IsStandAlone(self.GameInstance)
end

function GWorld:IsDedicatedServer()
	-- 开发模式下，由于TestScene与Ds公用lua虚拟机，这个值不能缓存
	if GWorld.IsDev then
		return IsDedicatedServer(self.GameInstance) 
	end
	if GWorld._IsDedicatedServer == nil then
		GWorld._IsDedicatedServer = IsDedicatedServer(self.GameInstance)
	end
	return GWorld._IsDedicatedServer
end

function GWorld:IsListenServer()
	return MiscUtils.IsListenServer(self.GameInstance)
end

function GWorld:IsClient()
	return IsClient(self.GameInstance)
end
----------------------------------- 判断UE4的NetMode end -----------------------------------


----------------------------------- GameMode -----------------------------------
GWorld.GameModeIndex = 0
GWorld.GameModes = {}
GWorld._CurrentGameMode = nil
GWorld.GameModeNumber = 0
local OldGetGameMode = UE4.UGameplayStatics.GetGameMode
UE4.UGameplayStatics.GetGameMode = function( ... )
	if GWorld._CurrentGameMode then
		return GWorld._CurrentGameMode
	end
	return OldGetGameMode(...)
end

local Key_GetFName = UE4.UFormulaFunctionLibrary.Key_GetFName
UE4.UFormulaFunctionLibrary.Key_GetFName = function(Key)
	local KeyName = Key_GetFName(Key)
	if KeyName == "^" and UUIFunctionLibrary.IsFRKeyboard() then
		return "RightBracket"
	end
	return KeyName
end

function GWorld:AddGameMode(GameMode)
	self.GameModeIndex = self.GameModeIndex + 1
	-- DebugPrint("CZC:AddGameMode:" .. tostring(self.GameModeIndex))
	self.GameModes[self.GameModeIndex] = GameMode
	self.GameModeNumber = self.GameModeNumber + 1
	self._CurrentGameMode = GameMode
	if self.GameModeNumber > 1 then
		-- Battle(GameMode):ShowBattleError("同时存在两个GameMode，具体信息请看本地日志" .. PrintTable(self.GameModes))
		self._CurrentGameMode = nil
	end
	return self.GameModeIndex
end

function GWorld:RemoveGameMode(GameModeIndex)
	-- DebugPrint("CZC:RemoveGameMode:" .. tostring(GameModeIndex))
	GWorld.GameModeNumber = GWorld.GameModeNumber - 1
	self.GameModes[self.GameModeIndex] = nil
	self._CurrentGameMode = nil
end
----------------------------------- GameMode -----------------------------------

----------------------------------- GameState -----------------------------------
GWorld.GameStateIndex = 0
GWorld.GameStates = {}
GWorld._CurrentGameState = nil
GWorld.GameStateNumber = 0
local OldGetGameState = UE4.UGameplayStatics.GetGameState
UE4.UGameplayStatics.GetGameState = function( ... )
	if URuntimeCommonFunctionLibrary.IsPlayInEditor(...) then
		return OldGetGameState(...)	
	end
	if GWorld._CurrentGameState then
		return GWorld._CurrentGameState
	end
	return OldGetGameState(...)
end

function GWorld:AddGameState(GameState)
	self.GameStateIndex = self.GameStateIndex + 1
	-- DebugPrint("CZC:AddGameState:" .. tostring(self.GameStateIndex))
	self.GameStates[self.GameStateIndex] = GameState
	self.GameStateNumber = self.GameStateNumber + 1
	self._CurrentGameState = GameState
	if self.GameStateNumber > 1 then
		-- Battle(GameState):ShowBattleError("同时存在两个GameState，具体信息请看本地日志" .. PrintTable(self.GameStates))
		self._CurrentGameState = nil
	end
	return self.GameStateIndex
end

function GWorld:RemoveGameState(GameStateIndex)
	-- DebugPrint("CZC:RemoveGameState:" .. tostring(GameStateIndex))
	GWorld.GameStateNumber = GWorld.GameStateNumber - 1
	self.GameStates[self.GameStateIndex] = nil
	self._CurrentGameState = nil
end
----------------------------------- GameState -----------------------------------



return GWorld
