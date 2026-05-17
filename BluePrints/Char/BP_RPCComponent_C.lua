local RewardBox = require "BluePrints.Client.CustomTypes.SimpleRewardBox"
require "UnLua"

local BP_RPCComponent_C = Class()

--function BP_RPCComponent_C:Initialize(Initializer)
--end

--function BP_RPCComponent_C:ReceiveBeginPlay()
--end

--function BP_RPCComponent_C:ReceiveEndPlay()
--end

function BP_RPCComponent_C:OnRequestGuideInfo_Lua(GuideInfo)
	DebugPrint("获取序列化数据:", GuideInfo, GuideInfo.SnapShotId, GuideInfo.Loc, GuideInfo.UnitId, GuideInfo.UnitType, GuideInfo.Level, GuideInfo.CurrentLevelId)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local SceneMgr = GameInstance:GetSceneManager()
	if (SceneMgr ~= nil) then
		SceneMgr:SetGuideActorInfo(GuideInfo)
	end
end

function BP_RPCComponent_C:SetEndPointTransform_Lua()
	local Owner = self:GetOwner()
	if not Owner:IsPlayer() then
		return
	end
	local EndPointSeqEnable, EndPointLocation, EndPointRotation = Owner:GetEndPointInfo()
	if not EndPointSeqEnable then
		return
	end

	Owner:ResetIdle()
	local NewTranslation = EndPointLocation + FVector(0, 0, Owner.CapsuleComponent:GetUnscaledCapsuleHalfHeight())
	Owner:K2_SetActorLocationAndRotation(NewTranslation, EndPointRotation, false, nil, true)
end

function BP_RPCComponent_C:SetVariableBool_Lua(VariableName, Variable, TargetEid)
	local Target = Battle(self):GetEntity(TargetEid)
	if not IsValid(Target) then
		return
	end
	Target[VariableName] = Variable
end

-- Client
function BP_RPCComponent_C:RequestSabotageGuideInfo_Client(Owner, Callback)
	DebugPrint("BP_RPCComponent_C: ClientRequest Owner:", Owner:GetName())
	if GameState(self) and GameState(self).GameModeType ~= "Sabotage" then
		DebugPrint("BP_RPCComponent_C: ClientRequest Not In Sabotage")
		return
	end
	self.SabotageGuideEvent:Add(Owner, Callback)
	self:RequestSabotageGuideInfo()
end

-- Server
function BP_RPCComponent_C:RequestSabotageGuideInfo_Lua()
	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	if not GameMode or not GameMode:GetDungeonComponent() then
		return
	end
	local SabotageGuideInfo = GameMode:GetDungeonComponent().SabotageMonsterGuide
	local DeathSabotageGuideInfo = GameMode:GetDungeonComponent().DeathSabotageMonsterGuide
	local GuideOrder = GameMode:GetDungeonComponent().GuideOrder
	local ResEid = TArray(0)
	local ResUnitId = TArray(0)

	for index, Eid in pairs(GuideOrder) do
		if not DeathSabotageGuideInfo[Eid] then
			ResEid:Add(Eid)
			ResUnitId:Add(SabotageGuideInfo[Eid])
		else
			ResEid:Add(0)
			ResUnitId:Add(0)
		end
	end

 	-- for i, j in pairs(SabotageGuideInfo) do
	-- 	if not DeathSabotageGuideInfo[i] then
	-- 		ResEid:Add(i)
	-- 		ResUnitId:Add(j)
	-- 	end
 	-- end

	DebugPrint("BP_RPCComponent_C:Server: RequestSabotageGuideInfo_Lua")
	PrintTable(ResEid:ToTable(), 3)
	PrintTable(ResUnitId:ToTable(), 3)
 	self:OnRequestSabotageGuideInfo(ResEid, ResUnitId)
end

-- Client
function BP_RPCComponent_C:OnRequestSabotageGuideInfo_Lua(Eids, UnitIds)
	DebugPrint("BP_RPCComponent_C: ClientRep: OnRequestSabotageGuideInfo_Lua")
	PrintTable(Eids:ToTable(), 3)
	PrintTable(UnitIds:ToTable(), 3)
	self.SabotageGuideEvent:Broadcast(Eids, UnitIds)
	self.SabotageGuideEvent:Clear()

	-- local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
	-- local UIManager = GameInstance:GetGameUIManager()
	-- if UIManager then
	-- 	local SabotageUI = UIManager:GetUIObj("DungeonSabotageFloat")
	-- 	SabotageUI:UpdateGuide(Eids, UnitIds)
	-- end
end

function BP_RPCComponent_C:OnDungeonSettlement_Server_Lua(bIsWin)
	self:SetEndPointTransform() -- 服务端执行，设置位置。
	self:OnDungeonSettlement_Client(bIsWin)
end

function BP_RPCComponent_C:OnDungeonSettlement_Client_Lua(bIsWin)
	local Owner = self:GetOwner()
	self:SetEndPointTransform_Lua() -- 客户端再执行一次，未知原因，服务端旋转未同步到客户端，因此再设置一次。
	Owner:OnDungeonSettlement(bIsWin)
end

function BP_RPCComponent_C:OnPlayerFallTriggerClient_Lua(Rotation)
	local Player = self:GetOwner()
    if not Player or not Player:IsPlayer() then
        return
    end
	if Rotation then
		-- 旋转不同步，客户端再设一次
		Player:K2_SetActorRotation(Rotation, false, nil, false)
		Player:GetController():SetControlRotation(Rotation)
	end
	Player:ResetIdle()
end

function BP_RPCComponent_C:OnTriggerFallTriggerEdge_Lua(OtherActor, Transform, MaxDis, DefaultEnable, FallTrigger)
	DebugPrint("zwkkk OnTriggerFallTriggerEdge_Lua rpc调用 ", OtherActor, Transform, MaxDis, DefaultEnable, FallTrigger)
	local Player = self:GetOwner()
	if not Player then
		return
	end
	local Loc = FVector(Transform.Translation.X, Transform.Translation.Y, Transform.Translation.Z)
	local Rot = Transform.Rotation:ToRotator()
    local PopupId = 100268
    local Params = {}
	local Teleport = function ()
		local Trans = FTransform(Rot:ToQuat(), Loc)
		self:TriggerGameModeFalling(Player, Trans, MaxDis, DefaultEnable)
	end
    Params.RightCallbackObj = self
    Params.RightCallbackFunction = self.ExitDungeon
    Params.LeftCallbackObj = self
    Params.LeftCallbackFunction = Teleport
	Params.CloseBtnCallbackObj = self
	Params.CloseBtnCallbackFunction = Teleport
    UIManager(self):ShowCommonPopupUI(PopupId, Params, self)
end

function BP_RPCComponent_C:ExitDungeon()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:ExitBattle(false, true)
    end
end

function BP_RPCComponent_C:OnPlayerEnterDungeonEdge_Lua(IsEnter)
	local Player = self:GetOwner()
    if not Player or not Player:IsPlayer() then
        return
    end
	if IsEnter then
		-- 后处理 + Toast
		Player:VignetteBegin()
		UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_LEAVE_DUNGEONEDGE"))
	else
		-- 移除后处理
		Player:VignetteEnd()
	end
end

function BP_RPCComponent_C:GMServerGetDrop_Lua(DropId, Count)
	local GameInstance = UGameplayStatics.GetGameInstance(self)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local DropInfo = DataMgr.Drop[DropId]
    local PlayerCharacter = self:GetOwner()
    local Rotation = PlayerCharacter:K2_GetActorRotation()
    local SpawnLocation = PlayerCharacter:K2_GetActorLocation() + FVector(400,0,0)
    if not DropInfo or Count <= 0 then
        return
    end
    local Transform = UE4.UKismetMathLibrary.MakeTransform(SpawnLocation, Rotation , UE4.FVector(1, 1, 1))
    local Drops = {}
    local DropCountTable = {}
	local NormalTag = RewardBox:GetTag("Normal")
    DropCountTable[tostring(NormalTag)] = Count
    Drops[DropId] = DropCountTable
	GameMode:HandleRewardDrop(Drops, CommonConst.RewardReason.REASON_GM_SPAWN, Transform, {}, nil)
end

function BP_RPCComponent_C:NotifyServerPlaySequenceFinish_Lua(PlayerEid)
	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	GameMode:TriggerDungeonComponentFun("ClientPlayOpeningFinish", PlayerEid)
end

function BP_RPCComponent_C:NotifyClientShowTeleportToast()
    EventManager:FireEvent(EventID.OnTeleportReady)
end

return BP_RPCComponent_C
