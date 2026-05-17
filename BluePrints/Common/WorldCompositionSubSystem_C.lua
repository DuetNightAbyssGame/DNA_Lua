require "Unlua"

local M = Class("BluePrints.Common.TimerMgr")
local SettingUtils = require "Utils.SettingUtils"
local GameFlowUtils = require "Utils.GameFlowUtils"

-- 这两个函数临时弄一个版本， 之后看看怎么优化逻辑和制作
function M:OnAsyncTravelBegin_Lua(Player)
	if not self.TravelRequests then
		self.TravelRequests = {}
	end
	local Controller = Player
	local MovementComponent = Player:GetMovementComponent()
	-- local OriginalGravityScale = MovementComponent.GravityScale
	local OriginalMovementMode = MovementComponent.MovementMode
	local ParamsTable = {OriginalMovementMode}
	self.TravelRequests[Controller] = ParamsTable
 
	-- MovementComponent.GravityScale = 0
	MovementComponent:SetMovementMode(UE4.EMovementMode.Move_None)
	Player:AddDisableInputTag("WCAsyncTravel")
	Player:ResetIdle()
	UGameplayStatics.GetPlayerController(self, 0):SetViewTargetWithBlend(Player)--强制设回去，ViewTarget有可能不在角色身上

	local LevelLoader=UE4.UGameplayStatics.GetActorOfClass(self,UE4.ALevelLoader:StaticClass())
	if LevelLoader then
		LevelLoader:SetForceGCAfterLevelStreamedOut(true)
	end
	-- self.BOpenRegionDataTickLog=false
end

function M:AddOnAsyncTravelEnded(Obj, Func)
	if not self.Callbacks then
		self.Callbacks = {}
	end
	self.Callbacks[Obj] = Func
end

function M:OnPlayerLanded_Lua()
	if self.Callbacks then
		-- local func = function()
		for Obj, Func in pairs(self.Callbacks) do
			Func(Obj)
		end
		self.Callbacks = {}
		-- end
		-- 和黑屏UI的Timer + 黑屏关闭遮罩动效时间对上 
		-- self:AddTimer(DataMgr.GlobalConstant.DeliveryBlackCurtainTime.ConstantValue + 1, func, false, 0, "EnterLevelCallBack", true)
	end
end

function M:OnAsyncTravelEnded_Lua(Player)
	local Controller = Player
	local MovementComponent = Player:GetMovementComponent()
	if not self.TravelRequests or not self.TravelRequests[Controller] then
		return
	end
	-- local OriginalGravityScale = self.TravelRequests[Controller][1]
	-- if OriginalGravityScale <= 0.001 then
	-- 	OriginalGravityScale = 1
	-- end
	local OriginalMovementMode = self.TravelRequests[Controller][1]
	local Movement = Player:GetMovementComponent()
	if OriginalMovementMode == 5 then
		OriginalMovementMode = Movement.DefaultLandMovementMode
	end
	self.TravelRequests[Controller] = nil

	--MovementComponent.GravityScale = OriginalGravityScale
	MovementComponent:SetMovementMode(Movement.DefaultLandMovementMode)
	self:AddTimer(2,function()--OnPlayerLanded在C++里有2秒的延迟，为了和回调时间对齐这里也延迟
		Player:RemoveDisableInputTag("WCAsyncTravel")
	end)
	Player:AddMovementInput(Player:GetActorForwardVector() * 0.001)
	local LevelLoader=UE4.UGameplayStatics.GetActorOfClass(self,UE4.ALevelLoader:StaticClass())
	if LevelLoader then
		LevelLoader:SetForceGCAfterLevelStreamedOut(false)
	end

end

function M:ShowRegionError_Lua(Text, NeedDebugTrace, SendToQaWeb, ErrorType, ErrorTitle, IsFromCPP)
	local bDistribution = UE4.URuntimeCommonFunctionLibrary.IsDistribution()
    local bEnableShippingLog = UE4.URuntimeCommonFunctionLibrary.EnableLogInShipping()
    if bDistribution and not bEnableShippingLog then
        return
    end

	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return
	end

	local Space = "=========================================================\n"
	local ct = {
        Space,
        "报错文本:\n\r",
        tostring(Text), "\n",
    }

	if NeedDebugTrace then
		table.insert(ct, Space)

		table.insert(ct, "Traceback:\n\t")
		table.insert(ct, debug.traceback())
		table.insert(ct, "\n")
		table.insert(ct, Space)
		table.insert(ct, UBattleFunctionLibrary.GetTraceStack(50))
	end

	local FinalMsg = table.concat(ct)
	if UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(self) then
        ScreenPrint("区域报错:\n"..FinalMsg)
    end
	Avatar:SendToFeiShuForRegionMgr(FinalMsg, "区域报错 | ".. Avatar.CurrentRegionId)
	
	if SendToQaWeb then
		if IsFromCPP then
			ErrorType = Const.RegionErrorType[ErrorType]
			ErrorTitle = Const.RegionErrorTitle[ErrorTitle]
		end
		local TraceType = {
			first = GText("区域报错"),
			second = ErrorType,
			third = ErrorTitle,
		}
		local DescribeInfo = {
			title = GText("详细信息"),
			trace_content = FinalMsg,
		}
		Avatar:SendTraceToQaWeb(TraceType, DescribeInfo)
	end
end

function M:OnWaitForDataIdle_Lua()
    GWorld.StoryMgr:TryRestartStoryline()
end

function M:Initialize_Lua()
	EventManager:AddEvent(EventID.StartTalk, self, self.OnStartTalk)
	EventManager:AddEvent(EventID.EndTalk, self, self.OnEndTalk)
	self.AsyncTravelUseGameFlow = true
end

function M:Deinitialize_Lua()
	EventManager:RemoveEvent(EventID.StartTalk, self)
	EventManager:RemoveEvent(EventID.EndTalk, self)
end

function M:OnStartTalk()
	DebugPrint('WorldCompositionSubSystem','OnStartTalk')
	self.BOpenRegionDataTickLog = false
end

function M:OnEndTalk()
	DebugPrint('WorldCompositionSubSystem','OnEndTalk')
	self.BOpenRegionDataTickLog = true
end

function M:RemoveFlow()
	if not self.AsyncTravelUseGameFlow then
		return
	end
	DebugPrint('WC RemoveFlow',self.FlowId)
	if self.FlowId and self.FlowId >= 0 then
		GameFlowUtils:RemoveFlow(self.FlowId)
	end
end

function M:GetRealStreamingDistanceRatio(ScalabilityLevel, Platform)
	local Ratio = 1
	if Platform == "Android" then
		Ratio = Const.AndroidRealStreamingDistanceRatio[ScalabilityLevel] or Ratio
	elseif Platform == "IOS" then
		Ratio = Const.IOSRealStreamingDistanceRatio[ScalabilityLevel] or Ratio
	else
		Ratio = Const.PCRealStreamingDistanceRatio[ScalabilityLevel] or Ratio
	end
	return Ratio
end

function M:GetIsWCDungeonUnloadSmall()
    return Const.WCDungeonUnloadSmall
end

function M:GetWCDungeonDistanceRatio()
    return Const.WCDungeonDistanceRatio
end

function M:GetWCDungeonLevelProxyDistanceRatio()
    return Const.WCDungeonLevelProxyDistanceRatio
end

function M:GetFoliageQualityEMCache()
	local OptionName = "PlantEnhance"
	local OptionInfo = DataMgr.Option[OptionName]
	if not OptionInfo then
		DebugPrint("Error GetFoliageQualityEMCache OptionInfo is nil")
		return 2
	end
	local PlatformName = UGameplayStatics.GetPlatformName()
	local GameInstance =  GWorld.GameInstance
	local IsPhone =  (PlatformName == "IOS") or (PlatformName == "Android") or (GameInstance and GameInstance:GetUseMapPhoneInPC())
	local DefaultValue = 0
	if IsPhone then
		DefaultValue = OptionInfo.DefaultValueM
	else
		DefaultValue = OptionInfo.DefaultValue
	end
	local CacheValue = SettingUtils.GetEMCache(OptionInfo.EMCacheName, OptionInfo.EMCacheKey, DefaultValue - 1);
	DebugPrint("GetFoliageQualityEMCache", CacheValue, "DefaultValue", DefaultValue  - 1)
	return CacheValue
end

function M:IsFoliageLevelContain(TableFoliageLevel, IsPhone, PackageName)
	local FoliageStrTable = {}
	if IsPhone then
		FoliageStrTable = Const.HuaxuFoliagePhone[TableFoliageLevel]
	else
		FoliageStrTable = Const.HuaxuFoliagePC[TableFoliageLevel]
	end
	for _, v in pairs(FoliageStrTable) do
		if string.find(PackageName, v) then
			return true
		end
	end
	return false
end

--区域->WC副本直接切换的尝试
--基础顺序：
--1.清理带区域数据的Actor
--2.清理Battle内其他Actor
--3.清理区域数据
--4.卸载Design关卡
--5.卸载GameMode，GameState
--6.生成GameMode，GameState
--7.加载新Design关卡
--8.跑正常的区域/副本进入逻辑
function M:DestroyAllRegionDataAndEnterDungeon(DungeonId)
	if not DungeonId or not DataMgr.Dungeon[DungeonId] then
		return
	end
	local Data = DataMgr.Dungeon[DungeonId]
	self:PauseAndAsyncDestroyRegionData({self, function()
		local EidKeys = Battle(self):GetAllEntities():Keys()
		for _, Eid in pairs(EidKeys) do
			local Ent = Battle(self):GetEntity(Eid)
			if Ent and not Ent.BpBorn then
				if Ent.EMActorDestroy and (not Ent.IsPlayer or not Ent:IsPlayer()) then
					-- if Ent.IsPhantom and Ent:IsPhantom() and not Ent:IsDead() then
					--     local ContextCopy = Ent.CreateUnitContextCopy
					--     ContextCopy.BoolParams:Add("SkipInitWaitCheck", true)
					--     self.EMGameState.EventMgr:RegisterCreateData(Ent.Eid, ContextCopy)
					--     Ent.ReInitSkipLevelEnter = true
					--     Ent:TryInitCharacterInfo("InitInfo")
					-- 	local Location = AllLocations:GetRef(Index)
					-- 	local HalfHeight = Ent.CapsuleComponent:GetScaledCapsuleHalfHeight()
					-- 	Location.Z = Location.Z + HalfHeight
					-- 	Ent:K2_SetActorLocation(Location, false, nil, false)
					-- else
						Ent:EMActorDestroy(EDestroyReason.LevelUnloadedSaveGame)
					-- end
				elseif not Ent.IsPlayer or not Ent:IsPlayer() then--其他全部直接销毁
					Ent:Destroy()
				end
			end
		end

		self:ClearAllRegionData()--这里只清理数据，没有Actor
		self:UnloadDesignLevel(true)
		self:RefreshDungeonId()
		self:RespawnGameMode(true, DungeonId)
		self:LoadDesignLevel(true, DungeonId)

		self:AddTimer(0.5,function()
			local GameMode = UE4.UGameplayStatics.GetGameMode(self)
			GameMode:SetGameModeState(EGameModeState.EPrepare)
			GameMode:GetLevelLoader():LevelLoaderReady()
			GameMode:TryTriggerOnPrepare("BattleInit")
			GameMode:TryTriggerOnPrepare("GameModeBeginPlay")
			local Controller = UGameplayStatics.GetPlayerController(self, 0)
			local AvatarEidStr = Controller.AvatarEidStr
			if GameMode.LevelLoader and not GameMode.AlreadyInit then
				GameMode.LevelLoader:SetInitTrans(Controller)
			end
			GameMode:OnCharacterReady(AvatarEidStr, self)
			GameMode:TryTriggerOnInit(AvatarEidStr)
			local GameState = UGameplayStatics.GetGameState(self)
			GameState.EndLoadingSuccess = false
			GameState:TryEndLoading("PlayerReady")
		end)
	end})
end

return M