
require "UnLua"
local EMCache = require "EMCache.EMCache"
local msgpack = require "msgpack_core"
local SettingUtils = require "Utils.SettingUtils"

local BP_SinglePlayerController_C = Class()

BP_SinglePlayerController_C._components = {
	"BluePrints.Char.CharacterComponent.DedicatedServerGMComponent", -- RPC给DedicatedServer的GM
}


function BP_SinglePlayerController_C:Initialize(Initializer)
end

--function BP_SinglePlayerController_C:UserConstructionScript()
--end

function BP_SinglePlayerController_C:ReceiveBeginPlay()
	self.DisableRotaionInputTags = {}
	self.DisablePitchRotationInputTags = {}
	self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
	if(IsValid(self.GameInputModeSubsystem)) then
		self:SetForceFeedbackFromCache() -- 设置手柄震动开关
		self:SetForceFeedbackScaleFromCache() -- 设置震动强度
		self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.ChangeForceFeedbackByDevice)
	end
end

--function BP_SinglePlayerController_C:ReceiveEndPlay()
--end

-- function BP_SinglePlayerController_C:ReceiveTick(DeltaSeconds)
-- end

--function BP_SinglePlayerController_C:ReceiveActorBeginOverlap(OtherActor)
--end

--function BP_SinglePlayerController_C:ReceiveActorEndOverlap(OtherActor)
--end

function BP_SinglePlayerController_C:GetDefaulAvatarInfo()
	return AvatarUtils:GetDefaultAvatarInfo()
end

function BP_SinglePlayerController_C:GetAvatarInfo()
	return self.AvatarInfo or self:GetDefaulAvatarInfo()
end

function BP_SinglePlayerController_C:SetAvatarInfo(AvatarEidStr, AvatarInfo)
	self.AvatarId = CommonUtils.Str2ObjId(AvatarEidStr)
	self.AvatarEidStr = AvatarEidStr
	self.AvatarInfo = AvatarInfo
	local WheelIndex = AvatarInfo.WheelIndex or 0
	self.PlayerState:SetWheelIndex(WheelIndex)
end

function BP_SinglePlayerController_C:GetRoleId()
	local RoleId = self:_GetRoleId()
	return RoleId or Const.DefaultRoleId
end

function BP_SinglePlayerController_C:_GetRoleId()
	if not self.AvatarInfo then
		return
	end
	local RoleInfo = self.AvatarInfo.RoleInfo
	if not RoleInfo then
		return
	end
	return RoleInfo.RoleId
end

function BP_SinglePlayerController_C:GetSkillInfos()
	if not self.AvatarInfo then
		return
	end
	local RoleInfo = self.AvatarInfo.RoleInfo
	if not RoleInfo then
		return
	end
	return RoleInfo.SkillInfos
end

function BP_SinglePlayerController_C:GetReplaceAttrs()
	if not self.AvatarInfo then
		return
	end
	local RoleInfo = self.AvatarInfo.RoleInfo
	if not RoleInfo then
		return
	end
	return RoleInfo.Attrs
end

function BP_SinglePlayerController_C:GetPlayerLevel()
	if not self.AvatarInfo then
		return
	end
	local RoleInfo = self.AvatarInfo.RoleInfo
	if not RoleInfo then
		return
	end
	return RoleInfo.Level
end

function BP_SinglePlayerController_C:GetPlayerExp()
	if not self.AvatarInfo then
		return
	end
	local RoleInfo = self.AvatarInfo.RoleInfo
	if not RoleInfo then
		return
	end
	return RoleInfo.Exp
end

function BP_SinglePlayerController_C:GetEnhanceLevel()
	if not self.AvatarInfo then
		return
	end
	local RoleInfo = self.AvatarInfo.RoleInfo
	if not RoleInfo then
		return
	end
	return RoleInfo.EnhanceLevel
end

function BP_SinglePlayerController_C:GetGradeLevel()
	if not self.AvatarInfo then
		return
	end
	local RoleInfo = self.AvatarInfo.RoleInfo
	if not RoleInfo then
		return
	end
	return RoleInfo.GradeLevel
end

function BP_SinglePlayerController_C:GetModPassives()
	if not self.AvatarInfo then
		return
	end
	local RoleInfo = self.AvatarInfo.RoleInfo
	if not RoleInfo then
		return
	end
	return RoleInfo.PassiveEffects
end

function BP_SinglePlayerController_C:GetMeleeWeapon()
	local MeleeWeapon = nil
	if self.AvatarInfo then
		MeleeWeapon = self.AvatarInfo.MeleeWeapon
	end
	if MeleeWeapon then
		return MeleeWeapon
	end
	if Const.DeafaultMeleeWeapon then
		return {WeaponId = Const.DeafaultMeleeWeapon}
	end
end

function BP_SinglePlayerController_C:GetUltraWeapon()
	if not self.AvatarInfo then
		return
	end
	return self.AvatarInfo.UltraWeapon
end

function BP_SinglePlayerController_C:GetRangedWeapon()
	local MeleeWeapon = nil
	if self.AvatarInfo then
		local RangedWeapon = self.AvatarInfo.RangedWeapon
		if RangedWeapon then
			return RangedWeapon
		end
	end
	if Const.DeafaultRangedWeapon then
		return {WeaponId = Const.DeafaultRangedWeapon}
	end
end

function BP_SinglePlayerController_C:GetSkinId()
	if not self.AvatarInfo then
		return
	end
	local RoleInfo = self.AvatarInfo.RoleInfo
	if not RoleInfo then
		return
	end
	return RoleInfo.SkinId
end

-- 单纯的禁用技能，无论技能是否被激活，且不进入未激活列表
function BP_SinglePlayerController_C:BanSkills(BanSkillNames, BanType)
	local len = BanSkillNames:Num()
    if len <= 0 then
        print("BanSkillNames array is nil")
        return
    end
	for i=1,len do
		print(_G.LogTag, "BanSkill", BanSkillNames[i])
		self.CurrentBanSkills:AddUnique(BanSkillNames[i])
		if not self:CheckSkillInActive(BanSkillNames[i]) then 
			self:SetSkillButtonVisibility(BanSkillNames[i], BanType)
        	EventManager:FireEvent(EventID.OnSkillInActive, BanSkillNames[i])
		end
    end
end

-- 单纯的解禁用技能，若技能原本就未被激活，并不激活
function BP_SinglePlayerController_C:UnBanSkills(UnBanType)
	local SkillsShouldUnBan = {}
	-- for _, BanSkillName in pairs(self.CurrentBanSkills) do
	-- 	print(_G.LogTag, "UnBanSkill111", BanSkillName, self:CheckSkillInActive(BanSkillName))
	-- end
	for id, BanSkillName in pairs(self.CurrentBanSkills) do
		-- print(_G.LogTag, "UnBanSkill", BanSkillName, self:CheckSkillInActive(BanSkillName))
		if not self:CheckSkillInActive(BanSkillName) then
			SkillsShouldUnBan[BanSkillName] = 1
			self:SetSkillButtonVisibility(BanSkillName, UnBanType)
        	EventManager:FireEvent(EventID.OnSkillActive, BanSkillName)
		end
	end
	for BanSkillName, _ in pairs(SkillsShouldUnBan) do
		print(_G.LogTag, "UnBanSkill222", BanSkillName, self:CheckSkillInActive(BanSkillName))
		self.CurrentBanSkills:RemoveItem(BanSkillName)
	end
	-- for _, BanSkillName in pairs(self.CurrentBanSkills) do
	-- 	print(_G.LogTag, "UnBanSkill333", BanSkillName, self:CheckSkillInActive(BanSkillName))
	-- end
end

--激活技能，可能是禁用的激活也可能是教学激活
function BP_SinglePlayerController_C:ActiveSkills(ActiveSkillNames, ActiveType)
    local len = ActiveSkillNames:Num()
    if len <= 0 then
        print("ActoveSkillNames array is nil")
        return
    end
    for i=1,len do
        local ret = self:DoActiveSkill(ActiveSkillNames[i])
        if ret then
        	EventManager:FireEvent(EventID.OnSkillActive, ActiveSkillNames[i])
        end
		if ActiveType == "UnBan" and self.CurrentBanSkills:Contains(ActiveSkillNames[i]) then
			self.CurrentBanSkills:RemoveItem(ActiveSkillNames[i])
		end
		if(self.CurrentBanSkills:Contains(ActiveSkillNames[i])) then
			self:SetSkillButtonVisibility(ActiveSkillNames[i], "Ban")
		else
			self:SetSkillButtonVisibility(ActiveSkillNames[i], ActiveType)
		end
    end
end

--禁用技能，可能是神庙的禁用也可能是教学禁用
function BP_SinglePlayerController_C:InActiveSkills(InActiveSkillNames, InActiveType)
    local len = InActiveSkillNames:Num()
    if len <= 0 then
        print("InActoveSkillNames array is nil")
        return
    end
	print(_G.LogTag, "InActiveSkills", InActiveSkillNames, InActiveType)
    for i=1,len do
        local ret = self:DoInActiveSkill(InActiveSkillNames[i])
        if ret then
        	EventManager:FireEvent(EventID.OnSkillInActive, InActiveSkillNames[i])
        end
		if InActiveType == "Ban" and not self.CurrentBanSkills:Contains(InActiveSkillNames[i]) then
			self.CurrentBanSkills:Add(InActiveSkillNames[i])
		end
		self:SetSkillButtonVisibility(InActiveSkillNames[i], InActiveType)
    end
end

function BP_SinglePlayerController_C:EmptySkills(EmptySkillNames)
	local len = #EmptySkillNames
	if len <= 0 then
		print("EmptySkillNames array is nil")
		return
	end
	print(_G.LogTag, "EmptySkillNames", EmptySkillNames)
	for i = 1, len do
		local ret = self:DoInActiveSkill(EmptySkillNames[i])
		if ret then
			EventManager:FireEvent(EventID.OnSkillInActive, EmptySkillNames[i])
		end
		self:SetSkillButtonVisibility(EmptySkillNames[i], "Empty")
	end
end

function BP_SinglePlayerController_C:UnEmptySkills(UnEmptySkillNames)
	local len = #UnEmptySkillNames
	if len <= 0 then
		print("EmptySkillNames array is nil")
		return
	end
	print(_G.LogTag, "EmptySkillNames", UnEmptySkillNames)
	for i = 1, len do
		local ret = self:DoActiveSkill(UnEmptySkillNames[i])
		if ret then
			EventManager:FireEvent(EventID.OnSkillActive, UnEmptySkillNames[i])
		end
		self:SetSkillButtonVisibility(UnEmptySkillNames[i], "UnEmpty")
	end
end

function BP_SinglePlayerController_C:InActiveSkillsInHooking(HookingSkillNames)
	local len = HookingSkillNames:Num()
	if len <= 0 then
		print("InActiveSkillsInHooking SkillNames array is nil")
		return
	end
	print(_G.LogTag, "HookingSkillNames", HookingSkillNames)
	for i = 1, len do
		if not self:CheckSkillInActive(HookingSkillNames[i]) then
			local ret = self:DoInActiveSkill(HookingSkillNames[i])
			if ret then
				EventManager:FireEvent(EventID.OnSkillInActive, HookingSkillNames[i])
			end
			self:SetSkillButtonVisibility(HookingSkillNames[i], "Hooking")
		end
	end
end

function BP_SinglePlayerController_C:ActiveSkillsEndHooking(EndHookingSkillNames)
	local len = EndHookingSkillNames:Num()
	if len <= 0 then
		print("ActiveSkillsEndHooking SkillNames array is nil")
		return
	end
	print(_G.LogTag, "EndHookingSkillNames", EndHookingSkillNames)
	for i = 1, len do
		if self:CheckSkillInActive(EndHookingSkillNames[i]) then
			if self:GetSkillState(EndHookingSkillNames[i]) == "Hooking" then
				local ret = self:DoActiveSkill(EndHookingSkillNames[i])
				if ret then
					EventManager:FireEvent(EventID.OnSkillActive, EndHookingSkillNames[i])
				end
				self:SetSkillButtonVisibility(EndHookingSkillNames[i], "EndHooking")
			end
		end
	end
end

function BP_SinglePlayerController_C:SetAndForbidWeaponByWeaponTag(WeaponTags, bForbid, ForbidTag, bHideWhenForbid)
    self:SetForbiddenWeapon(WeaponTags, bForbid, ForbidTag, bHideWhenForbid)
    self:ForbidWeapon()
end

function BP_SinglePlayerController_C:SetForbiddenWeapon(WeaponTags, bForbid, ForbidTag, bHideWhenForbid)
	if not self.ForbiddenWeaponInfo then
		self.ForbiddenWeaponInfo = {}
	end
	for _, WeaponTag in pairs(WeaponTags) do
		if not self.ForbiddenWeaponInfo[WeaponTag] then
			self.ForbiddenWeaponInfo[WeaponTag] = {}
		end
		self.ForbiddenWeaponInfo[WeaponTag][ForbidTag] = {
			bForbid = bForbid,
			bHideWhenForbid = bHideWhenForbid
		}
	end
end

function BP_SinglePlayerController_C:ForbidWeapon()
	local Player = self:GetMyPawn()
	if self.ForbiddenWeaponInfo then
		for WeaponTag, ForbidTagAndInfo in pairs(self.ForbiddenWeaponInfo) do
			for ForbidTag, Info in pairs(ForbidTagAndInfo) do
				Player:ForbidWeaponByWeaponTag(WeaponTag, Info.bForbid, ForbidTag, Info.bHideWhenForbid)
			end
		end
	end
end

function BP_SinglePlayerController_C:SetSkillButtonVisibility(SkillName, StateName)
	self.SkillStates:Add(SkillName, StateName)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManger = GameInstance:GetGameUIManager()
    local Widget = UIManger:GetUIObj("BattleMain")
    if not Widget then
        print(_G.LogTag, "UIManager get widget BattleMain failed")
        return
    end
	Widget = Widget.Char_Skill
	if not Widget then
		print(_G.LogTag, "BattleMain上找不到Char_Skill这个控件")
		return
	end
	Widget:ChangeSkillButtonState(SkillName, StateName)
end

function BP_SinglePlayerController_C:K2_ClientWasKicked(Reason)
	print(_G.LogTag, "Client was Kicked For the Reason", Reason);
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return
	end

	Avatar:OnClientWasKicked(Reason)
	local bVoteStart = Reason == "VoteStart"
	local bPlayEnd = Reason == "PlayEnd"
	if bVoteStart or bPlayEnd then
		Avatar:ExitDungeon()

		if bVoteStart then
			local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)

			local LoadingUI = GameInstance:GetLoadingUI()
			if LoadingUI then
				LoadingUI:AddDynamic(function()
					UIManager(self):ShowUITip("CommonToastMain", GText("UI_SYSTEM_VOTEKICK"), 3)
				end)
			end
		end
		return
	end

	GWorld.NetworkMgr:DisconnectAndReturnLogin()
end

function BP_SinglePlayerController_C:RealShowDungeonPickUpRewardUI(Params, RewardType)
	DebugPrint("RealShowDungeonPickUpRewardUI", RewardType, Params:Get(3))
	local Rewards
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return
	end

	local Tag = Params:Get(3) == 1 and "Extra" or "Normal"
	local InnerTag = Avatar.CachedDungeonRewards:GetTag(Tag)
	if RewardType == CommonConst.DataType.Resource then
		Rewards = RewardUtils:GetResources({}, Params:Get(1), Params:Get(2))
		Avatar.CachedDungeonRewards:AddResource(Rewards, nil, InnerTag)
		UIUtils.ShowDungeonRewardUI(Rewards, CommonConst.RewardReason.MonsterDead, "Resource")
	elseif RewardType == CommonConst.DataType.Mod then
		Rewards = RewardUtils:GetMod(Params:Get(1))
		Avatar.CachedDungeonRewards:AddMod(Rewards, nil, InnerTag)
		UIUtils.ShowDungeonRewardUI(Rewards, CommonConst.RewardReason.MonsterDead, "Mod")
	end
	--DebugPrintTable(Avatar.CachedDungeonRewards, 5)
end

function BP_SinglePlayerController_C:GetCurrentDungeonRewards(Rewards)
	local DSEntity = GWorld:GetDSEntity()
	if not DSEntity then
		print(_G.LogTag, "GetCurrentDungeonRewards DSEntity is nil")
		return
	end

	local CurrentRewardsTable = DSEntity:GetCurrentRewards(self.AvatarEidStr)
	local RewardsBytes = msgpack.pack(CurrentRewardsTable)
	Rewards:SetBytes(RewardsBytes, #RewardsBytes)
end

function BP_SinglePlayerController_C:SendCurrentDungeonRewards_Lua(Rewards)
	local RewardsBytes = Rewards:GetBytes()
	if not RewardsBytes then
		return
	end

	local RewardsTable = msgpack.unpack(RewardsBytes)
	--PrintTable(RewardsTable, 5)
	local Avatar = GWorld:GetAvatar()
	if Avatar then
		Avatar:CacheDungeonRewards(RewardsTable)
	end
end

function BP_SinglePlayerController_C:NotifyClientToCloseLoading_Lua(bInActivePlayer)
	print(_G.LogTag, "CloseLoading", bInActivePlayer)

	local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)

	local EnterSuccessFunc = function ()
		local Avatar = GWorld:GetAvatar()
		if Avatar then
			Avatar:AvatarStatusEnterSuccess()
		end

		print(_G.LogTag, "EnterSuccessFunc FireEvent")
		EventManager:FireEvent(EventID.OnNotifyClientToCloseLoading)

		if not IsValid(self) then
			return
		end
		local Player = self:GetMyPawn()
		if Player and not Player:IsDead() then
			if not bInActivePlayer then
				Player:ClientPlayEnterMontage()
			else
				Player:SetCharacterTagIdle()
			end
		end
	end
	local UI = GameInstance:GetLoadingUI()
	if UI then
		UI:AddDynamic(EnterSuccessFunc)
		UI:AddQuene(Const.MaxLoadingPercentage)
	else
		EnterSuccessFunc()
	end

	local Player = self:GetMyPawn()
	if not Player then
		DebugPrint("NotifyClientToCloseLoading 拿不到Player")
		return
	end
	Player:RemoveGravityModifier(UE4.EGravityModifierTag.LoadLevel)

	-- 关加载界面的时候，统一更新客户端UI的状态
	local GameState = UE4.UGameplayStatics.GetGameState(self)
	if GameState then
		DebugPrint("NotifyClientToCloseLoading 触发OnRep_DungeonEvent_Lua IsCanFreshDungeonEvent", GameState.IsCanFreshDungeonEvent)
		-- 确保只触发一次
		if not GameState.IsCanFreshDungeonEvent then
			GameState.IsCanFreshDungeonEvent = true
			GameState:OnRep_DungeonEvent_Lua()
		end
		GameState:OnRep_GuideEids()

		local LevelLoader = GameState:GetCurrentLevelLoader()
		if LevelLoader and LevelLoader.IsWorldLoader and IsClient(self) then
			self:SetViewTargetWithBlend(Player)
		end

		-- 指引相关
		local PlayerState = GameState:GetPlayerState(Player.Eid)
		if PlayerState then
			PlayerState:OnRep_PlayerGuideEids()
		end

		-- for _, v in pairs(GameState.PlayerArray) do
		-- 	local SceneMgrComponent = GameInstance:GetSceneManager()
		-- 	if (IsValid(SceneMgrComponent)) and v.Eid ~= Player.Eid then
		-- 		SceneMgrComponent:UpdateSceneOtherPlayerGuide(v.Eid, "Enter")
		-- 	end
		-- end
	else
		DebugPrint("NotifyClientToCloseLoading 拿不到GameState")
	end
end

-- 当前玩家是否已经完成结算
function BP_SinglePlayerController_C:IsPlayEnd()
	if not IsDedicatedServer(self) then
		return false
	end

	if GWorld.bDebugServer then
		return false
	end

	local DSEntity = GWorld:GetDSEntity()
	if DSEntity and rawget(DSEntity.HasLeaveAvatars, self.AvatarEidStr) ~= nil then
		return true
	end

	return false
end

function BP_SinglePlayerController_C:OnNetCleanup_Lua(UConnection)
end

function BP_SinglePlayerController_C:OnRealDisconnect_Lua()
	local GameMode = GWorld.GameInstance:GetCurrentGameMode()
	GameMode:ForceFinishPlayerByFailed({self.AvatarEidStr})
end

function BP_SinglePlayerController_C:SetBornTrans()
	local GameMode = GWorld.GameInstance:GetCurrentGameMode()
	if GameMode.LevelLoader then
		GameMode.LevelLoader:SetEnteredPlayerTrans(self);
	end
end

-- 接收游戏结束开始结算通知
function BP_SinglePlayerController_C:NotifyClientGameEnd_Lua(IsWin, ScenePlayers, PlayerEndReason)
	local PlayerCharacter = self:GetMyPawn()
	PlayerCharacter:DisableInput(self)

	local MessageStr = ScenePlayers:GetBytes()
	-- local msgpack = require "msgpack_core"
	-- local UnpackMsg = msgpack.unpack(MessageStr)
	--PrintTable(UnpackMsg, 5)

	-- 收到场景服结算rpc，到结算真正开始期间的标识
	GWorld.GameInstance.IsDSOnDungeonFinish = true

	local RealNotifyClientGameEnd_Lua = function ()
		print(_G.LogTag, "DedicatedServer_OnDungeonFinish RealNotifyClientGameEnd_Lua  IsWin", IsWin, MessageStr, PlayerEndReason)
		if self.ReconnectTag then
			EventManager:RemoveEvent(EventID.CloseLoading, self)	-- 仅在触发保底、AddEvent后,才Remove
		end

		-- 如果有复活UI，隐藏
		local UIBattleMain = UIManager(self):GetUI("BattleMain")
		UIBattleMain:HidePlayerDeadUI()

		local Avatar = GWorld:GetAvatar()
		if not Avatar then
			print(_G.LogTag, "Avatar is nil")
			return
		end

		local BattleInfo
		if Avatar:IsInDungeon() then
			BattleInfo = GWorld.GameInstance:GetCurrentDungeonId()
		elseif Avatar:IsInHardBoss() then
			BattleInfo = Avatar.HardBossInfo
		end

		local msgpack = require "msgpack_core"
		--local MessageStr = ScenePlayers:GetBytes()	-- ScenePlayers可能会丢，所以移到外面了
		--local UnpackMsg = msgpack.unpack(MessageStr)
		--PrintTable(UnpackMsg, 5)
		GWorld.GameInstance:OnPlayerControllerGameEnd(IsWin, BattleInfo, msgpack.unpack(MessageStr))

		if PlayerEndReason == "OnTimeoutInit" then
			GameState(self):ShowDungeonToast_Lua("UI_HardBossDg_LoadingTimeOut", 2, EToastType.Common)
		end
	end

	if GWorld.GameInstance:GetLoadingUI() then
		-- 断线重连后，客户端已收到NotifyClientToCloseLoading，但LoadingUI尚未关闭，导致结算流程卡死的处理
		print(_G.LogTag, "DedicatedServer_OnDungeonFinish GetLoading", IsWin, MessageStr)
		self.ReconnectTag = true
		EventManager:AddEvent(EventID.CloseLoading, self, RealNotifyClientGameEnd_Lua)
		return
	end

	print(_G.LogTag, "DedicatedServer_OnDungeonFinish NotifyClientGameEnd_Lua", IsWin, MessageStr)
	RealNotifyClientGameEnd_Lua()
end

function BP_SinglePlayerController_C:AddDisableRotationInputTag(Tag)
    self.DisableRotaionInputTags[Tag] = 1
    self.bLockRotate = true
end

function BP_SinglePlayerController_C:RemoveDisableRotationInputTag(Tag)
    self.DisableRotaionInputTags[Tag] = nil
    self:EnableRotationInput()
end

function BP_SinglePlayerController_C:RemoveAllDisableRotationInputTag()
    self.DisableRotaionInputTags = {}
    self:EnableRotationInput()
end

function BP_SinglePlayerController_C:EnableRotationInput()
    if not next(self.DisableRotaionInputTags) then
        self.bLockRotate = false
    end
end

function BP_SinglePlayerController_C:AddDisablePitchRotationInputTag(Tag)
	self.DisablePitchRotationInputTags[Tag] = 1
	self.bLockPitchRotate = true
end

function BP_SinglePlayerController_C:RemoveDisablePitchRotationInputTag(Tag)
	self.DisablePitchRotationInputTags[Tag] = nil
	self:EnablePitchRotationInput()
end

function BP_SinglePlayerController_C:RemoveAllDisablePitchRotationInputTag()
	self.DisablePitchRotationInputTags = {}
	self:EnablePitchRotationInput()
end

function BP_SinglePlayerController_C:EnablePitchRotationInput()
	if not next(self.DisablePitchRotationInputTags) then
		self.bLockPitchRotate = false
	end
end

function BP_SinglePlayerController_C:CheckDedicatedServerCondition_Lua(ConditionCheckId, ConditionString)
	local ConditionValue = 0
	local ConditionName, Params = ConditionUtils:UnpackParams(ConditionString)

	if ConditionUtils["Judge"..ConditionName](nil, Params) then
		ConditionValue = 1
	end

	if IsDedicatedServer(self) then
		self:OnCheckDedicatedServerCondition(ConditionCheckId, ConditionString, ConditionValue)
	else
		self:OnCheckDedicatedServerCondition_Lua(ConditionCheckId, ConditionString, ConditionValue)
	end
end

function BP_SinglePlayerController_C:OnCheckDedicatedServerCondition_Lua(ConditionCheckId, ConditionString, ConditionValue)
	print(_G.LogTag, "OnCheckDedicatedServerCondition_Lua")
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return
	end

	Avatar:OnCheckDedicatedServerCondition(ConditionCheckId, ConditionString, ConditionValue)
end

function BP_SinglePlayerController_C:GetCombatStatistics()
	---@type BP_PlayerCharacter_C
	local PlayerCharacter = self:GetMyPawn()
	if not PlayerCharacter then
		return {}
	end
	if not PlayerCharacter.UploadBDCTrackInfo then
		return {}
	end

	local Json = require "rapidjson"

	-- local WeaponUseInfo = (PlayerCharacter.UploadBDCTrackInfo and PlayerCharacter.UploadBDCTrackInfo.WeaponUseCount) and PlayerCharacter.UploadBDCTrackInfo.WeaponUseCount or {}
	-- local SkillUseInfo = (PlayerCharacter.UploadBDCTrackInfo and PlayerCharacter.UploadBDCTrackInfo.SkillUseCount) and PlayerCharacter.UploadBDCTrackInfo.SkillUseCount or {}

	local BDCUploadSystem = USubsystemBlueprintLibrary.GetWorldSubsystem(self, UBDCUploadSubsystem)
	
	local WeaponUseInfoStr = BDCUploadSystem:GetUploadBDCTrackStructInfo("weapon_skill_usage_json")
	local SkillUseInfoStr = BDCUploadSystem:GetSkillUsageTrackInfo()
	local CondemnSkillCount = BDCUploadSystem:GetCondemnSkillUseCount()

	local Ret = 
	{
		weapon_skill_usage_json = WeaponUseInfoStr ~= "" and Json.decode(WeaponUseInfoStr) or {},
		skill_usage_json = SkillUseInfoStr ~= "" and Json.decode(SkillUseInfoStr) or {},
		player_hurt_number = PlayerCharacter:GetTakedDamage(),
		player_damage_number = PlayerCharacter:GetFinalDamage(),
		bullet_jump_number = PlayerCharacter:GetBulletJumpCount(),
		sliding_tackle_number = PlayerCharacter:GetSlideCount(),
		jump_number = (PlayerCharacter.UploadBDCTrackInfo and PlayerCharacter.UploadBDCTrackInfo.JumpCount) and PlayerCharacter.UploadBDCTrackInfo.JumpCount or 0,
		double_jump_number = (PlayerCharacter.UploadBDCTrackInfo and PlayerCharacter.UploadBDCTrackInfo.JumpSecondCount) and PlayerCharacter.UploadBDCTrackInfo.JumpSecondCount or 0,
		climb_wall_number = (PlayerCharacter.UploadBDCTrackInfo and PlayerCharacter.UploadBDCTrackInfo.JumpWallCount) and PlayerCharacter.UploadBDCTrackInfo.JumpWallCount or 0,
		fly_shoot_number = PlayerCharacter:GetFlyShootCount(),
		sentence_number = CondemnSkillCount or 0,
		death_number = (PlayerCharacter.UploadBDCTrackInfo and PlayerCharacter.UploadBDCTrackInfo.DeadCount) and PlayerCharacter.UploadBDCTrackInfo.DeadCount or 0,
		recovery_number = (PlayerCharacter.UploadBDCTrackInfo and PlayerCharacter.UploadBDCTrackInfo.RecoveryCount) and PlayerCharacter.UploadBDCTrackInfo.RecoveryCount or 0,
		phantom_damage_json = PlayerCharacter:GetAllPhantomDamage():ToTable(),
		phantom_json = PlayerCharacter:GetCurPhantomInfo(),
	}
	return Ret
end

---@param IsOpenStoryMode boolean
function BP_SinglePlayerController_C:SetStoryModeState(IsOpenStoryMode)
	local GameState = UE4.UGameplayStatics.GetGameState(self)
	if (GameState == nil) then
		DebugPrint("Error: GameState is nil")
		return
	end

	self.IsInStoryMode = IsOpenStoryMode

	local IsInStoryModeString = "F"
	if IsOpenStoryMode then
		IsInStoryModeString = "T"
	end
	GameState:TriggerCondition("InStoryMode", IsInStoryModeString)

	local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
    if BattleMainUI then
        BattleMainUI:InitBtnList()
    end

	if IsOpenStoryMode then
		AudioManager(self):AddAuANotifyForbidTag("StoryMode")
	else
		AudioManager(self):RemoveAuANotifyForbidTag("StoryMode")
	end
end

function BP_SinglePlayerController_C:GetStoryModeState()
	return self.IsInStoryMode 
end

function BP_SinglePlayerController_C:SetForceFeedbackFromCache()
	local GamepadForceFeedback = EMCache:Get("ForceFeedback")
	local CurMode = self.GameInputModeSubsystem:GetCurrentInputType()
	DebugPrint("@zyh 获取到的GamepadForceFeedback", GamepadForceFeedback)
	if GamepadForceFeedback == nil then
		local DefaultFeedback = DataMgr.Option["ForceFeedback"].DefaultValue
		if DefaultFeedback == "True" then
			DefaultFeedback = true
		else
			DefaultFeedback = false	
		end
		EMCache:Set("ForceFeedback", DefaultFeedback)
		if(CurMode == ECommonInputType.Gamepad) then
			self.bForceFeedbackEnabled = DefaultFeedback
		else
			self.bForceFeedbackEnabled = false
		end
	else
		if(CurMode == ECommonInputType.Gamepad) then
			self.bForceFeedbackEnabled = GamepadForceFeedback
		else
			self.bForceFeedbackEnabled = false
		end
	end
end

function BP_SinglePlayerController_C:SwitchForceFeedback(bForceFeedback)
	local CurMode = self.GameInputModeSubsystem:GetCurrentInputType()
	if(CurMode == ECommonInputType.Gamepad) then
		self.bForceFeedbackEnabled = bForceFeedback
	end
	EMCache:Set("ForceFeedback", bForceFeedback)
end

function BP_SinglePlayerController_C:ChangeForceFeedbackByDevice(CurInputDevice, CurGamepadName)
	if(CurInputDevice == ECommonInputType.Gamepad) then
		local GamepadForceFeedback = EMCache:Get("ForceFeedback")
		self.bForceFeedbackEnabled = GamepadForceFeedback
	else
		self.bForceFeedbackEnabled = false
	end
end

function BP_SinglePlayerController_C:SetForceFeedbackScaleFromCache()
	local FeedbackScale = EMCache:Get("ForceFeedbackScale")
	local ScaleValue
	if not FeedbackScale then
		local DefaultScale = DataMgr.Option["ForceFeedbackScale"] and tonumber(DataMgr.Option["ForceFeedbackScale"].SubOptionDefaultValue[2]) or 2
		ScaleValue = Const.ForceFeedbackScale[DefaultScale]
		EMCache:Set("ForceFeedbackScale", DefaultScale)
	else
		ScaleValue = Const.ForceFeedbackScale[FeedbackScale]
	end
	self.ForceFeedbackScale = ScaleValue
end

function BP_SinglePlayerController_C:SwitchForceFeedbackScale(Scale)
	local ScaleValue = Const.ForceFeedbackScale[Scale]
	self.ForceFeedbackScale = ScaleValue
	EMCache:Set("ForceFeedbackScale", Scale)
	local ForceEffectObject = LoadObject('/Game/AssetDesign/Controller/FE_Light.FE_Light')
	if ForceEffectObject then
		self:K2_ClientPlayForceFeedback(ForceEffectObject, "SettingTest", false, true, false)
	end
end

function BP_SinglePlayerController_C:GetEmCache(OptionId)
	local Res = SettingUtils.GetEMCacheForBL(OptionId)
	if type(Res) == "number" then
		return Res, false
	elseif type(Res) == "boolean" then
		return -1, Res
	end
	return -1, false
end

AssembleComponents(BP_SinglePlayerController_C)
return BP_SinglePlayerController_C
