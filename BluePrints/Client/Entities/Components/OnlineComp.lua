local pb = require "pb"
local Decorator = require "BluePrints.Client.Wrapper.Decorator"


local MessageTypeToFunc = {
	EnterRegionOnline = "HandleEnterRegionOnline",
	LeaveRegionOnline = "HandleLeaveRegionOnline",
	Move = "HandleMove",
	Action = "HandleAction",
	StopAction = "HandleStopAction",
	Hide = "HandleHide",
	NicknameChange = "HandleNicknameChange",
	LevelChange = "HandleLevelChange",
	CurrentPetChange = "HandleCurrentPetChange",
	CharInfoChange = "HandleCharInfoChange",
	UseExpression = "HandleUseExpression",
	TitleChange = "HandleTitleChange",
	OnLeaveRegionOnlineItem = "HandleOnLeaveRegionOnlineItem",
	OnUseRegionOnlineItem = "HandleOnUseRegionOnlineItem",
	OnChangeRegionOnlineItemState = "HandleOnChangeRegionOnlineItemState",
	OnDeadRegionOnlineItem = "HandleOnDeadRegionOnlineItem",
	OnUseCreateMount = "HandleOnUseCreateMount",
	OnDeadRegionOnlineMount = "HandleOnDeadRegionOnlineMount",
	OnChangeRegionOnlineMount = "HandleOnChangeRegionOnlineMount",
	ShareMountDatasChange = "HandleShareMountDatasChange",
	SwitchMeleeWeapon = "HandleSwitchMeleeWeapon",
	SwitchRangedWeapon = "HandleSwitchRangedWeapon",
	SwitchShowWeapon = "HandleSwitchShowWeapon",
	UseGouSuo = "HandleUseGouSuo",
	SwitchOnlineState = "HandleSwitchOnlineState",
	HeadFrame = "HandleHeadFrame",
	HeadIcon = "HandleHeadIcon",
	TransformAFDay = "HandleTransformAFDay",
}

local Component = {}

function Component:EnterWorld()
	self.IsInRegionOnline = false
	self.CurrentOnlineType = -1
	self.PreEnterSubRegionId = -1
	self.RegionAvatars = {}
	self:InitMoveSyncMgr()
end

function Component:RequestEnterOnline(online_type, ShowWeapon, CurrentState, PlayerInfo)
	self.logger.debug("[OnlineComp] CZC RequestEnterOnline: ".. online_type, self.IsInRegionOnline)
	self.PreEnterSubRegionId = online_type
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	local RegionPlayerInfo = {
		MountInfo = {
			MountId = Player.CurrentMountId,
			MountState = 0
		},
		WeaponInfo = {
			ShowWeapon = ShowWeapon or CommonConst.OnlineShowWeapon.Melee
		},
		UseMechanism = {
			UseState = 0,
			UniqueId = 0,
		},
		CurrentState = CurrentState or CommonConst.OnlineState.Normal,
		UseTargetParam = {},
		ActionBaseInfo = Player:GetPlayerLocationAndRotation()
	}
	self:CallServerMethod("RequestEnterOnline", online_type, RegionPlayerInfo)
end

function Component:OnRequestEnterOnline(online_type, ret, others, GlobalRegionItemCache, online_id)
	self.logger.debug("[OnlineComp] CZC OnRequestEnterOnline: ".. online_type .. " ret: ".. ret)
	if ret ~= ErrorCode.RET_SUCCESS then
		return
	end
	self:NotifyCharacterStartSync(online_type)
	self.IsInRegionOnline = true
	self.PreEnterSubRegionId = -1
	self.RegionAvatars = others
	self.CurrentOnlineType = online_type
	self.GlobalRegionItemCache = GlobalRegionItemCache

	if not others then
		return
	end
	PrintTable({OnRequestEnterOnline_others = others, GlobalRegionItemCache = GlobalRegionItemCache},10)
	for i, v in pairs(others) do
		self:RegionSyncAddRoleToCreate(i, v)
		self:InitOnlineStateData(i, v)
	end
	self:InitMechanismUser(GlobalRegionItemCache)
	self.InWorldChatChannel[CommonConst.ChatChannel.RegionOnline] = true
	if ChatController then
		ChatController:SendRequestEnterChatChannel(ChatCommon.ChannelDef.Region)
	end

	local OnlineActionController = require "BluePrints.UI.WBP.BattleOnlineAction.OnlineActionController"
	OnlineActionController:Init(true)
end

function Component:ActiveSwitchToRegionOnlineChannel(online_type, online_id, ShowWeapon, CurrentState, PlayerInfo)
	self.logger.debug("[OnlineComp] CZC ActiveSwitchToRegionOnlineChannel: " .. online_type, online_id, self.IsInRegionOnline)
	self.PreEnterSubRegionId = online_type
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	local RegionPlayerInfo = {
		MountInfo = {
			MountId = Player.CurrentMountId,
			MountState = 0
		},
		WeaponInfo = {
			ShowWeapon = ShowWeapon or CommonConst.OnlineShowWeapon.Melee
		},
		UseMechanism = {
			UseState = 0,
			UniqueId = 0,
		},
		CurrentState = CurrentState or CommonConst.OnlineState.Normal,
		UseTargetParam = {},
		ActionBaseInfo = Player:GetPlayerLocationAndRotation()
	}
	self:CallServerMethod("ActiveSwitchToRegionOnlineChannel", online_type, online_id, RegionPlayerInfo)
end

function Component:OnActiveSwitchToRegionOnlineChannel(online_type, online_id, ret, others, GlobalRegionItemCache)
	self.logger.debug(string.format("[OnlineComp] CZC OnActiveSwitchToRegionOnlineChannel: %s, id: %s ret: %s", online_type, online_id, ret))
	if ret ~= ErrorCode.RET_SUCCESS then
		return
	end
	self:NotifyCharacterStartSync(online_type)
	self.IsInRegionOnline = true
	self.PreEnterSubRegionId = -1
	self.RegionAvatars = others
	self.CurrentOnlineType = online_type
	self.GlobalRegionItemCache = GlobalRegionItemCache

	if not others then
		return
	end
	PrintTable({OnRequestEnterOnline_others = others, GlobalRegionItemCache = GlobalRegionItemCache},10)
	for i, v in pairs(others) do
		self:RegionSyncAddRoleToCreate(i, v)
		self:InitOnlineStateData(i, v)
	end
	self:InitMechanismUser(GlobalRegionItemCache)
	self.InWorldChatChannel[CommonConst.ChatChannel.RegionOnline] = true
	if ChatController then
		ChatController:SendRequestEnterChatChannel(ChatCommon.ChannelDef.Region)
	end

	local OnlineActionController = require "BluePrints.UI.WBP.BattleOnlineAction.OnlineActionController"
	OnlineActionController:Init(true)
end

function Component:RequestLeaveOnline(online_type)
	self.logger.debug("[OnlineComp] CZC RequestLeaveOnline: ".. online_type)
	self:CallServerMethod("RequestLeaveOnline", online_type)
end

function Component:OnRequestLeaveOnline(online_type, ret)
	--手动退出登录不会走这里的流程，注意一下
	self.logger.debug("[OnlineComp] CZC OnRequestLeaveOnline: ".. online_type.. " ret: ".. ret)
	if ret ~= ErrorCode.RET_SUCCESS then
		return
	end
	self:DestoryAllOthers()
	self:NotifyCharacterEndSync()
	self.IsInRegionOnline = false
	self.RegionAvatars = {}
	self.CurrentOnlineType = -1
	self.PreEnterSubRegionId = -1
	self.InWorldChatChannel[CommonConst.ChatChannel.RegionOnline] = false
	if ChatController then
		ChatController:SendRequestLeaveChatChannel(ChatCommon.ChannelDef.Region)
	end

	local OnlineActionController = require "BluePrints.UI.WBP.BattleOnlineAction.OnlineActionController"
	if OnlineActionController then
		OnlineActionController:Destory()
	end
end

function Component:UseExpression(online_type, expression_id)
	DebugPrint("gmy@OnlineComp Component:UseExpression", online_type, expression_id)
end


function Component:GetActionMessage(real_message, message)
	for k, v in pairs(message.IntMap) do
		message[k] = v
	end
	for k, v in pairs(message.FloatMap) do
		message[k] = v
	end
	for k, v in pairs(message.EnumMap) do
		message[k] = v
	end
	for k, v in pairs(message.VectorMap) do
		message[k] = v
	end
	for k, v in pairs(message.RotatorMap) do
		message[k] = v
	end
	message.IntMap = nil
	message.FloatMap = nil
	message.EnumMap = nil
	message.VectorMap = nil
	message.RotatorMap = nil
	real_message.Action = message
end
function Component:UploadPlayerMessage(online_type, message)
	-- 目前支持 3 中消息类型：Move Action StopAction Hide
	if not CommonConst.OnlineClientMessageType[message.Type] then
		return
	end
	local real_message = {}
	real_message.Type = message.Type
	if message.Type == "Action" and not message.UsingActionNew then
		self:GetActionMessage(real_message, message)
	else
		real_message[message.Type] = message
	end

	local message_str = pb.encode(".OnlineClientMessage", real_message)
	local callback = function(ret)
	end
	self:CallServer("UploadPlayerOnlineClientMessage", callback, online_type, message_str)
end


function Component:RegionOnlineRequests(normal_messages, pb_messages)
	-- self.logger.debug("RegionOnlineRequests")
	for i, message in ipairs(normal_messages) do
		self:HandleSingleRegionOnlineRequest(message)
	end
	for i, message_str in ipairs(pb_messages) do
		local message = pb.decode(".OnlineClientMessage", message_str)
		local real_message = message[message.Type]
		if real_message then
			real_message.Sender = message.Sender
			self:HandleSingleRegionOnlineRequest(real_message)
		end
	end
end
function Component:HandleSingleRegionOnlineRequest(message)
	local MType = message.Type
	local func = MessageTypeToFunc[MType]
	if func and self[func] then
		self[func](self, message)
	end
end

function Component:HandleEnterRegionOnline(message)
	PrintTable({HandleEnterRegionOnline = message}, 10)
	self:RegionSyncAddRoleToCreate(message.Sender, message)
    self:InitOnlineStateData(message.Sender, message)
	self.RegionAvatars[message.Sender] = {
		CharInfo = message.CharInfo,
		CurrentPet = message.CurrentPet,
		AvatarInfo = message.AvatarInfo,
		RegionOnlineItem = message.RegionOnlineItem,
		GlobalRegionItemCache = message.GlobalRegionItemCache
	}
	self:InitMechanismUser(message.GlobalRegionItemCache)
end

function Component:HandleLeaveRegionOnline(message)
	PrintTable({HandleLeaveRegionOnline = message}, 10)
	self:HandleLeaveRegionMechanism(message)
	self:RegionSyncRemoveRoleAndDestroy(message.Sender, message)
	self.RegionAvatars[message.Sender] = nil
	if self.DeliveryStates then
		self.DeliveryStates[message.Sender] = nil
	end
end

function Component:HandleSwitchMeleeWeapon(message)
	PrintTable({HandleSwitchMeleeWeapon = message}, 10)
	self:RegionSyncChangeWeaponInfo(message.Sender, message, "Melee")
end

function Component:HandleSwitchRangedWeapon(message)
	PrintTable({HandleSwitchRangedWeapon = message}, 10)
	self:RegionSyncChangeWeaponInfo(message.Sender, message, "Ranged")
end

function Component:HandleSwitchShowWeapon(message)
	PrintTable({HandleSwitchShowWeapon = message}, 10)
	self:RegionSyncChangeUsingWeaponType(message.Sender, message)
end

function Component:InitOnlineStateData(ObjId, RoleInfo)
	DebugPrint("gmy@OnlineComp Component:InitOnlineStateData", ObjId, RoleInfo, RoleInfo.AFDayTransformId)
	
	self.RoleUseTargetParam = self.RoleUseTargetParam or {}
	self.RoleUseTargetParam[ObjId] = RoleInfo.UseTargetParam
	self.DeliveryStates = self.DeliveryStates or {}
	if RoleInfo.CurrentState == CommonConst.OnlineState.UseDelivery then
		self.DeliveryStates[ObjId] = true
	else
		self.DeliveryStates[ObjId] = false
	end
	
	self.AFDayTransformId = RoleInfo.AFDayTransformId or -1
end

function Component:HandleSwitchOnlineState(Message)
	PrintTable({HandleSwitchOnlineState = Message}, 10)
	local TempRoleInfo = self:GetRoleInfo(Message.Sender)
	if(TempRoleInfo) then 
		TempRoleInfo.IsCrouching = false
	end
	local Player = self:GetBornedChar(Message.Sender)
	if Player then 
		Player.OtherWorldCrouching = false
		Player:SetCrouch(false)
	end
	self:HandleGestureState(Message, false)
	self:HandleFish(Message)
	self:HandleDelivery(Message)
end

--- Actor初始化完成后调用的
function Component:InitOnlineStateAfterBorn(ObjId, RoleInfo)
	DebugPrint("gmy@OnlineComp Component:InitOnlineStateAfterBorn", ObjId, RoleInfo)

	if self.RoleUseTargetParam then
		local UseTargetParam = self.RoleUseTargetParam[ObjId]
		local TempRoleInfo = self:GetRoleInfo(ObjId)
		if(TempRoleInfo) then 
			TempRoleInfo.IsCrouching = false
		end
		local Player = self:GetBornedChar(ObjId)
		if Player then 
			Player.OtherWorldCrouching = false
			Player:SetCrouch(false)
		end
		self:HandleGestureState({ Sender = ObjId, UseTargetParam = UseTargetParam }, true)
		self:HandleFish({Sender = ObjId, UseTargetParam = UseTargetParam })
		self:HandleTransformAFDay({ Sender = ObjId, TransformID = self.AFDayTransformId or -1 })
	end
	self:HandleMechanism(self.RegionAvatars, self.GlobalRegionItemCache, ObjId)
	self:TryPlayEndDelivery(ObjId, RoleInfo)
end

function Component:HandleGestureState(Message, bIsInit)
	DebugPrint("gmy@OnlineComp Component:HandleGestureState", Message.Sender, Message.UseTargetParam, Message.UseTargetParam and Message.UseTargetParam.ResourceId)
	-- 检查角色是否创建
	if Message and Message.UseTargetParam and Message.UseTargetParam.ResourceId then
		local ResourceId = Message.UseTargetParam.ResourceId
		local Player = self:GetBornedChar(Message.Sender)
		DebugPrint("gmy@OnlineComp Component:HandleGestureState2", 
				ResourceId, Player, Player and Player:GetName(), Player and Player.CurResourceId, Message.Sender, Message.State, Message.UseTargetParam)
		if(bIsInit) then 
			local ResourceInfo = DataMgr.Resource[ResourceId]
    		
			local ResourceIsMountId = nil
			if(ResourceInfo) then
    			ResourceIsMountId = self:ResourceIsMount(ResourceInfo)
			end
			if(ResourceIsMountId) then 
				return
			end
		end
		if Player then
			local ResourceInfo = DataMgr.Resource[ResourceId]
			if ResourceInfo then
				DebugPrint("gmy@OnlineComp Component:HandleGestureState3", ResourceId, Player.CurResourceId)
				--if ResourceId ~= Player.CurResourceId then
					local ActionBaseInfo = Message.ActionBaseInfo
					if ActionBaseInfo then
						local Loc = ActionBaseInfo.Location
						local Rot = ActionBaseInfo.Rotation
						PrintTable({HandleGestureState = {Loc = Loc, Rot = Rot}}, 10)
						Player:K2_SetActorLocationAndRotation(FVector(Loc.X, Loc.Y, Loc.Z), FRotator(Rot.Pitch, Rot.Yaw, Rot.Roll), false, nil, false)
					end
					local ArmoryActionId = ResourceInfo.PlayArmoryAnim
					if ArmoryActionId then
						local ActionName = Const.ArmoryActionIdToArmoryTag[ArmoryActionId]
						if ActionName == Const.Melee then
							local WeaponInfo = Player.WeaponInfo and Player.WeaponInfo.MeleeWeapon
							if WeaponInfo then
								local WeaponId = WeaponInfo.WeaponId
								if Player.MeleeWeapon and Player.MeleeWeapon.WeaponId ~= WeaponId then
									-- 销毁之前的武器
									Player.Weapons:Remove(WeaponId)
									Player.MeleeWeapon:Destroy()
									Player.MeleeWeapon = nil
								end

								if nil == Player.MeleeWeapon then
									Player.MeleeWeapon = Player:SpawnShowWeapon(WeaponId, nil, nil, nil, WeaponInfo)
									Player:RawAddWeapon(Player.MeleeWeapon)
								end
							end
						elseif ActionName == Const.Ranged then
							local WeaponInfo = Player.WeaponInfo and Player.WeaponInfo.RangedWeapon
							if WeaponInfo then
								local WeaponId = WeaponInfo.WeaponId

								if Player.RangedWeapon and Player.RangedWeapon.WeaponId ~= WeaponId then
									-- 销毁之前的武器
									Player.Weapons:Remove(WeaponId)
									Player.RangedWeapon:Destroy()
									Player.RangedWeapon = nil
								end
								if nil == Player.RangedWeapon then
									Player.RangedWeapon = Player:SpawnShowWeapon(WeaponId, nil, nil, nil, WeaponInfo)
									Player:RawAddWeapon(Player.RangedWeapon)
								end
							end
						end
					end
				
					if bIsInit then
						Player:InitShowResourceBPFunction(ResourceId)
					else
						Player:InvokeResourceBPFunction(ResourceId)
					end
				--end
			else
				-- ResourceId是0或者错误ID
				DebugPrint("gmy@OnlineComp Component:HandleGestureState ResetIdleTag", Player.PlayerAnimInstance)
				if Player.PlayerAnimInstance then
					Player.PlayerAnimInstance:ResetIdleTag()
				end
			end

			Player.CurResourceId = ResourceId
		end
	end
end

function Component:HandleMove(message)
	local sender_info = self.RegionAvatars[message.Sender]
	if sender_info and sender_info.CurResourceId ~= 0 and message.CurResourceId == 0 then
		sender_info.CurResourceId = 0
		sender_info.WeaponInfo = nil
	end
	self:RegionSyncUpdateMoveInfo(message.Sender, message)
end

function Component:HandleAction(message)
	self:HandleActionPack(message.Sender, message)
end

function Component:HandleHide(message)
	self:HandleHidePack(message.Sender, message)
end

function Component:HandleStopAction(message)
	self:ReceiveStopActionPack(message.Sender, message)
end

function Component:HandleNicknameChange(message)
	local SenderInfo = self.RegionAvatars[message.Sender]
	if SenderInfo then
		SenderInfo.AvatarInfo.Nickname = message.Nickname
		EventManager:FireEvent(EventID.OnlineRegionNickNameChange, message.Sender, SenderInfo.AvatarInfo.Uid)
	end
end

function Component:HandleHeadFrame(message)
	local SenderInfo = self.RegionAvatars[message.Sender]
	if SenderInfo then
		SenderInfo.AvatarInfo.HeadFrameId = message.HeadFrameId
	end
end

function Component:HandleHeadIcon(message)
	local SenderInfo = self.RegionAvatars[message.Sender]
	if SenderInfo then
		SenderInfo.AvatarInfo.HeadIconId = message.HeadIconId
	end
end

function Component:HandleTransformAFDay(message)
	DebugPrint("gmy@OnlineComp Component:HandleTransformAFDay", message.Sender, message.TransformID)
	PrintTable({HandleTransformAFDay_Msg = message}, 5)

	local Eid = message.Sender
	local Player = self:GetBornedChar(Eid)

	if nil == Player then
		DebugPrint("gmy@OnlineComp Component:HandleTransformAFDay", "Player is nil for Eid:", message.Sender)
		return
	end
	
	local TransformID = message.TransformID
	if TransformID <= 0 then
		Player:CancelAFDTransform()
	else
		Player:ApplyAFDTransform(TransformID)
	end
end

function Component:HandleLevelChange(message)
	local SenderInfo = self.RegionAvatars[message.Sender]
	if SenderInfo then
		SenderInfo.AvatarInfo.Level = message.Level
	end
end

function Component:HandleCurrentPetChange(message)
	local SenderInfo = self.RegionAvatars[message.Sender]
	if SenderInfo then
		SenderInfo.CurrentPet = message.CurrentPet
	end
	local RoleInfo = self:GetRoleInfo(message.Sender)
	if RoleInfo then
		RoleInfo.CurrentPet = message.CurrentPet
	end
end

function Component:HandleCharInfoChange(message)
	local SenderInfo = self.RegionAvatars[message.Sender]
	if SenderInfo then
		SenderInfo.CharInfo = message.CharInfo
	end
	self:RegionSyncChangeRoleInfo(message.Sender, message)
end

function Component:HandleTitleChange(message)
	local SenderInfo = self.RegionAvatars[message.Sender]
	if SenderInfo then
		if message.TitleBefore then
			SenderInfo.AvatarInfo.TitleBefore = message.TitleBefore
		end
		if message.TitleAfter then
			SenderInfo.AvatarInfo.TitleAfter = message.TitleAfter
		end
		if message.TitleFrame then
			SenderInfo.AvatarInfo.TitleFrame = message.TitleFrame
		end
	end
	if SenderInfo then
		EventManager:FireEvent(EventID.OnlineRegionTitleChange, message.Sender, SenderInfo.AvatarInfo.Uid, SenderInfo.AvatarInfo.TitleBefore,  
		SenderInfo.AvatarInfo.TitleAfter, SenderInfo.AvatarInfo.TitleFrame)
	end
end

function Component:HandleMechanism(RegionAvatars, GlobalRegionItemCache, AvatarEid)
	local Player = self:GetBornedChar(AvatarEid)
	local GameState = UE4.UGameplayStatics.GetGameState(Player)
	local Table = self:GetMechanismUser(AvatarEid)
	print(_G.LogTag,"LXZ HandleMechanism", Table)
	if Table and Table.UniqueId and Table.PointIdx then
		local Mechanism = GameState.RegionOnlineMechanismMap:Find(Table.UniqueId)
		if Player and Mechanism then
			local InteractiveComp = Mechanism.ChestInteractiveComponent
			Player:InteractiveMechanism(Mechanism.Eid, Player.Eid, InteractiveComp.NextStateId, InteractiveComp.CommonUIConfirmID, true, Table.PointIdx)
		end
	end
	
	local Avatar = RegionAvatars[AvatarEid]
	local RegionOnlineItem = Avatar.RegionOnlineItem
	print(_G.LogTag,"LXZ HandleMechanism222", RegionOnlineItem, Player:GetName())
	PrintTable(RegionOnlineItem, 10)
	if RegionOnlineItem then
		for UniqueId, message in pairs(RegionOnlineItem) do
			if message.StateComponent then
				for PointIdx, Table in pairs(message.StateComponent) do
					if Table.UseEid then
						self:UpdateMechanismUser(UniqueId, PointIdx, Table.UseEid, true)
					end
				end
			end
			local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
			if not GameState.RegionOnlineMechanismMap:FindRef(UniqueId) then
				local Loc = message.Location
				local Rot = message.Rotation
				local Context = AEventMgr.CreateUnitContext()
				Context.UnitType = "Mechanism"
				Context.UnitId = message.UnitId
				Context.Loc = FVector(Loc.X, Loc.Y, Loc.Z)
				Context.Rotation = FRotator(Rot.Pitch, Rot.Yaw, Rot.Roll)
				local Sender = CommonUtils.ObjId2Str(message.OwnerAvatarEid)
				Context.NameParams:Add("Sender", Sender)
				Context.NameParams:Add("UniqueId", UniqueId)
				GameState.EventMgr:CreateUnitNew(Context, true)
			else
				local Mechanism = GameState.RegionOnlineMechanismMap:Find(UniqueId)
				if Player and Mechanism and message.StateComponent then
					for PointIdx, Table in pairs(message.StateComponent) do
						if Table.UseEid == AvatarEid then
							local InteractiveComp = Mechanism.ChestInteractiveComponent
							Player:InteractiveMechanism(Mechanism.Eid, Player.Eid, InteractiveComp.NextStateId, InteractiveComp.CommonUIConfirmID, true, PointIdx)
						end
					end
				end
			end
			PrintTable(message, 10)
			-- self:UpdateMechanismUser(UniqueId, 1, message.OwnerAvatarEid, true)
		end
	end
end


function Component:HandleLeaveRegionMechanism(message)
	print(_G.LogTag,"LXZ HandleLeaveRegionMechanism")
	PrintTable(message, 10)
	if message.Sender == self.Eid then
		return
	end
	--清空离开的人对机关的占用
	local Table = self:GetMechanismUser(message.Sender)
	if Table and Table.UniqueId and Table.PointIdx then
		self:RealDeInteractive({
			UniqueId = Table.UniqueId,
			InteractiveId = Table.PointIdx,
			Sender = message.Sender
		})
	end

	--删除离开的人创建的机关
	self:RealDeadRegionOnlineItem(UniqueId, message.Sender, true)
end

function Component:InitMechanismUser(GlobalRegionItemCache)
	print(_G.LogTag,"LXZ HandleMechanism InitMechanismUser", GlobalRegionItemCache)
	PrintTable(GlobalRegionItemCache, 10)
	for i, ItemCache in pairs(GlobalRegionItemCache) do
		local UniqueId = ItemCache.UniqueId
		local StateComponent = ItemCache.StateComponent
		if UniqueId and StateComponent then
			for PointIdx, UserTable in pairs(StateComponent) do
				print(_G.LogTag,"LXZ HandleMechanism InitMechanismUser222", PointIdx, UserAvatarEid)
				if UserTable.UseEid then
					self:UpdateMechanismUser(UniqueId, PointIdx, UserTable.UseEid, true)
				end
			end
		end
	end
end

function Component:UpdateMechanismUser(UniqueId, PointIdx, AvatarEid, bAdd)
	local UserAvatarEid = CommonUtils.ObjId2Str(AvatarEid)
	print(_G.LogTag,"LXZ HandleMechanism UpdateMechanismUser", UniqueId, PointIdx, UserAvatarEid, bAdd)
	if not self.Mechanism2User then
		self.Mechanism2User = {}
	end
	if not self.User2Mechanism then
		self.User2Mechanism = {}
	end
	if not self.Mechanism2User[UniqueId] then
		self.Mechanism2User[UniqueId] = {}
	end
	if bAdd then
		print(_G.LogTag,"LXZ HandleMechanism UpdateMechanismUser222", UniqueId, PointIdx, UserAvatarEid, bAdd)
		self.User2Mechanism[UserAvatarEid] = {UniqueId = UniqueId, PointIdx = PointIdx}
		self.Mechanism2User[UniqueId][PointIdx] = UserAvatarEid
	else
		self.User2Mechanism[UserAvatarEid] = nil
		self.Mechanism2User[UniqueId][PointIdx] = nil
	end
end

function Component:GetMechanismUser(AvatarEid)
	print(_G.LogTag,"LXZ GetMechanismUser")
	if not self.User2Mechanism then
		return nil
	end
	local UserAvatarEid = CommonUtils.ObjId2Str(AvatarEid)
	print(_G.LogTag,"LXZ GetMechanismUser111", UserAvatarEid)
	return self.User2Mechanism[UserAvatarEid]
end

--------------------------------------------钓鱼动作-------------------------------------------------------
function Component:HandleFish(message)
	if message and message.UseTargetParam then
		local TempRoleInfo = self:GetRoleInfo(message.Sender)
		if(TempRoleInfo) then 
			TempRoleInfo.IsCrouching = false
		end
		local Player = self:GetBornedChar(message.Sender)
		if Player then
			local FishRodId = message.UseTargetParam.FishingRodId
			if FishRodId and FishRodId ~= 0 then
				local Creatures = Player:GetEffectCreatureByTag("Fish")
				if Creatures:Length() == 0 then
					local CreatorId = message.UseTargetParam.CreatorId
					if CreatorId and CreatorId ~= 0 then
						local GameState = UE4.UGameplayStatics.GetGameState(self)
						local Creator = GameState.StaticCreatorMap:Find(CreatorId)
						local FishingSpot
						if Creator and Creator.ChildEids:Length() > 0 then
							FishingSpot = GameState.Battle:GetEntity(Creator.ChildEids:GetRef(1))
						else
							FishingSpot = GameState.ManualActiveCombat:Find(CreatorId)
						end
						if FishingSpot then
							FishingSpot:SetFishingSpotLocation(Player)
						end
					end
					Player:AsyncCreateEffectCreature(30101, FTransform(), true, nil)
				end
				local function UpdateFishingRod()
					self:UpdateFishingRodModelId(Player, FishRodId)
				end
				Player:AddTimer(0.1, UpdateFishingRod, true, -0.1, "UpdateFishingRodModelId", false, FishRodId)
			end
			local FishId = message.UseTargetParam.FishId
			if FishId and FishId ~= 0 then
				local MontageData = DataMgr.FishingMontage[FishId]
				if MontageData and MontageData.MontageName then
					if Player.FishMontageId ~= FishId then
						Player.FishMontageId = FishId
						Player:PlayActionMontage("Interactive/Fishing", MontageData.MontageName, {}, false)
					end
				else
					local AnimInstance = Player.Mesh:GetAnimInstance()
					local Montage = AnimInstance:GetCurrentActiveMontage()
					if Montage then
						AnimInstance:Montage_Stop(0, Montage)
						Player:RemoveTimer("UpdateFishingRodModelId")
						Player:RemoveEffectCreature(30101)
					end
					Player.FishMontageId = FishId
				end
			end
		end
	end
end

function Component:UpdateFishingRodModelId(Player, FishingRodId)
    local IdList = DataMgr.FishingRod[FishingRodId].EffectCreatureId
    local Creatures = Player:GetEffectCreatureByTag("Fish")
	if Creatures:Length() == 0 then
        return
    end
    Player:RemoveTimer("UpdateFishingRodModelId")
    for i, Id in pairs(IdList) do
        for j, Creature in pairs(Creatures) do
            if Id == Creature.EffectCreatureId then
                local FishingRodData = DataMgr.FishingRod[FishingRodId]
                local ModelId = FishingRodData.MeshResourceId
                local MaterialPath = FishingRodData.MaterialPath
                local MaterialParam = FishingRodData.MaterialParam
                Player:UpdateEffectCreatureModel(Id, ModelId)
				local EffectId = FishingRodData.EffectId
                if Creature.FishingRodEffectId ~= EffectId then
                    Creature.FXComponent:StopEffectByID(Creature.FishingRodEffectId, true)
                    Creature.FishingRodEffectId = EffectId
                    Creature.FXComponent:PlayEffectByID(EffectId)
                end
                self:UpdateFishingRodMaterial(Player, Id, MaterialPath, MaterialParam)
            end
        end
    end
end

function Component:UpdateFishingRodMaterial(Player, EffectCreatureId, MaterialPath, MaterialParam)
	local EffectCreatures = Player:GetEffectCreatureById(EffectCreatureId)
	for i = EffectCreatures:Num(), 1, -1 do
		local EffectCreature = EffectCreatures:GetRef(i)
		if IsValid(EffectCreature) then
			if MaterialPath then
				local Material = LoadObject(MaterialPath)
				EffectCreature.SkeletalMesh:SetMaterial(0, Material)
			end
			EffectCreature.FishMaterial = EffectCreature.SkeletalMesh:CreateAndSetMaterialInstanceDynamic(0)
			EffectCreature.SkeletalMesh:SetMaterial(0, EffectCreature.FishMaterial)
			if MaterialParam then
				EffectCreature.FishMaterial:SetScalarParameterValue("PartSelect", MaterialParam)
			end
		end
	end
end
--------------------------------------------钓鱼动作-------------------------------------------------------

--------------------------------------------传送-------------------------------------------------------
function Component:HandleDelivery(Message)
	if Message.State == CommonConst.OnlineState.UseDelivery then
		if self.DeliveryStates then
			self.DeliveryStates[Message.Sender] = true
		end
		DebugPrint("zwk Component:HandleSwitchOnlineState BeginDelivery")
		-- 传送起飞动作
		local TempRoleInfo = self.OtherRoleInfo[Message.Sender]
		if TempRoleInfo then
			TempRoleInfo.IsCrouching = false
			local Player = self:GetBornedChar(Message.Sender)
			if Player then
				local function HidePlayer()
					-- 设置隐藏角色
					Player:SetActorHideTag("DeliveryMontage", true)
				end
				local AllCallback = {
					OnNotifyBegin = HidePlayer,
				}
				Player:InitCharacterInfo(Player.InfoForInit)
				Player:ResetIdle()
				Player:PlayTeleportAction(AllCallback, false, true, false)
				-- 保底定时器再隐藏一下角色
				Player:AddTimer(3, HidePlayer, false, 0, "DeliveryHide_" .. Message.Sender)
			end
		end
	elseif Message.State == CommonConst.OnlineState.Normal and Message.PreState == CommonConst.OnlineState.UseDelivery then
		DebugPrint("zwk Component:HandleSwitchOnlineState EndDelivery")
		-- 传送落地
		self:PlayEndDelivery(Message.Sender)
	end
end

function Component:PlayEndDelivery(Sender)
	local TempRoleInfo = self.OtherRoleInfo[Sender]
	if TempRoleInfo then
		local Player = self:GetBornedChar(Sender)
		if Player and self.DeliveryStates and self.DeliveryStates[Sender] then
			DebugPrint("zwk Component:HandleSwitchOnlineState 播放落地动作 ", Player:GetName(), self.DeliveryStates)
			Player:RemoveTimer("DeliveryHide_" .. Sender)
			Player:SetActorHideTag("DeliveryMontage", false)
			local AllCallback = {

			}
			Player:PlayTeleportAction(AllCallback, false, true, false)
			Player.Mesh:GetAnimInstance():Montage_JumpToSection("End")
			if self.DeliveryStates then
				self.DeliveryStates[Sender] = false
			end
		end
	end
end

function Component:TryPlayEndDelivery(ObjId, RoleInfo)
	-- if (RoleInfo and RoleInfo.CurrentState == CommonConst.OnlineState.UseDelivery) or (self.DeliveryStates and self.DeliveryStates[ObjId]) then
	if self.DeliveryStates and self.DeliveryStates[ObjId] then
		self:PlayEndDelivery(ObjId)
	end
end
--------------------------------------------传送-------------------------------------------------------

------------------------------------------- 联机机关 -------------------------------------------
------------------------------------------- 联机机关 -------------------------------------------

--- 只有主机可以销毁机关
--- 机关是整体销毁
--- 客户端需要补充判断是否是主机
function Component:RequestDeadRegionOnlineItem(online_type, SenderEid, UniqueId)
	print(_G.LogTag,"LXZ RequestDeadRegionOnlineItem2222")
	local function Callback(Ret)
		self.logger.debug("ZJT_ RequestDeadRegionOnlineItem ", Ret, online_type, UniqueId)
		if Ret == 0 then
			self:RealDeadRegionOnlineItem(UniqueId, SenderEid, false)
		end
	end
	self:CallServer("RequestDeadRegionOnlineItem", Callback, online_type, UniqueId)
end
--- 联机动作相关 发起申请
--- 需要屏蔽主机请求 主机不能交互自己的机关
--- online_type 在线模式 ExpressionId所属机关Id OwnerEid主机Eid
--- UniqueId交互的分机关唯一ID NewState 新的交互状态
--- 交互后会有主机应答30秒倒计时 该函数最多30秒收到回调函数
function Component:RequestChangeRegionOnlineItemState(online_type, UniqueId, OwnerEid, InteractiveId, NewState, IsGlobal, bInMobile)
	ScreenPrint("客户端发起联机动作申请 RequestChangeRegionOnlineItemState online_type："..tostring(online_type).." ，UniqueId："..tostring(UniqueId).." ，OwnerEid："..CommonUtils.ObjId2Str(OwnerEid).." ，InteractiveId："..tostring(InteractiveId).." ，NewState："..tostring(NewState))
	self.logger.debug("ZJT_ RequestChangeRegionOnlineItemState ", online_type, UniqueId, OwnerEid, InteractiveId, NewState, CommonUtils.ObjId2Str(OwnerEid))
	local function Callback(Ret, Message)
		local Player = UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
		if Player then
			Player.WaitRegionOnlineSeatCB = false
		end
		if Ret==0 then
			EventManager:FireEvent(EventID.OnReceivedOnlineActionApplicationAgree, OwnerEid, UniqueId, InteractiveId)
			local message = {
				UniqueId = UniqueId, 
				InteractiveId = InteractiveId,
				Sender = Message.SenderEid,
				RequestEid = Message.SenderEid,
				IsGlobalOnlineItem = IsGlobal
			}
			self:RealInteractive(message)
			ScreenPrint("联机动作申请成功")
		elseif  Ret==52015 or Ret==52025 then --52015服务器超时拒绝 52025被客户端拒绝
			ScreenPrint("联机动作申请超时拒绝")
			EventManager:FireEvent(EventID.OnReceivedOnlineActionApplicationReject, OwnerEid, UniqueId, InteractiveId)
		else
			-- local OnlineActionController =require "BluePrints.UI.WBP.BattleOnlineAction.OnlineActionController"
			-- OnlineActionController:ShowToastByErrorCode(Ret,false)
			ScreenPrint("联机动作申请失败 错误码："..tostring(Ret))
		end
		self.logger.debug("ZJT_ RequestChangeRegionOnlineItemState Callback ", Ret, online_type, UniqueId, OwnerEid, InteractiveId, NewState)
	end
	self:CallServer("RequestChangeRegionOnlineItemState", Callback, online_type, UniqueId, OwnerEid, InteractiveId, NewState, bInMobile)
end

--- 这里指的是玩家离开交互的机关 例如从车上下来 需要告知主机其他玩家占用解除
--- online_type 在线模式 ExpressionId所属机关Id OwnerEid主机Eid
--- UniqueId交互的分机关唯一ID
function Component:RequestLeaveRegionOnlineItem(online_type, UniqueId, OwnerEid, InteractiveId, bInMobile)
	self.logger.debug("ZJT_ RequestLeaveRegionOnlineItem ", online_type, UniqueId, CommonUtils.ObjId2Str(OwnerEid), InteractiveId, CommonUtils.ObjId2Str(OwnerEid))
	local function Callback(Ret)
		self.logger.debug("ZJT_ RequestLeaveRegionOnlineItem CallBack ", Ret, online_type, UniqueId, OwnerEid, InteractiveId)
		if Ret == 0 then
			local message = {
				Sender = self.Eid,
				UniqueId = UniqueId,
				InteractiveId = InteractiveId
			}
			self:RealDeInteractive(message)
		end
	end

	self:CallServer("RequestLeaveRegionOnlineItem", Callback, online_type, UniqueId, OwnerEid, InteractiveId, bInMobile)
end
--- 联机动作相关 收到申请
--- 收到申请，玩家向主机发起交互申请 主机可以选择拒绝或者同意
--- ServerCallClient 30秒未处理自动拒绝
--- RequestEid 请求玩家的Eid
function Component:RequestUseOwnerRegionOnlineItem(RequestEid, UniqueId, InteractiveId)
	--self:OnRequestUseOwnerRegionOnlineItem(RequestEid, true, UniqueId,InteractiveId)
	ScreenPrint("收到申请 RequestUseOwnerRegionOnlineItem RequestEid："..tostring(CommonUtils.ObjId2Str(RequestEid)).." ，UniqueId："..tostring(UniqueId).." ，InteractiveId："..tostring(InteractiveId))
	EventManager:FireEvent(EventID.ReceivedOthersOnlineActionApplication, RequestEid, UniqueId, InteractiveId)
	self.logger.debug("ZJT_ 111 RequestUseOwnerRegionOnlineItem ", CommonUtils.ObjId2Str(RequestEid))
end
--- 联机动作相关 回复申请
--- 主机返回玩家申请交互结果
function Component:OnRequestUseOwnerRegionOnlineItem(RequestEid, RequestRes, UniqueId, InteractiveId)
	ScreenPrint("回复申请 OnRequestUseOwnerRegionOnlineItem RequestEid："..tostring(CommonUtils.ObjId2Str(RequestEid)).." ，RequestRes："..tostring(RequestRes).." ，UniqueId："..tostring(UniqueId).." ，InteractiveId："..tostring(InteractiveId))
	local function Callback(Ret, RequestEid, RequestRes, UniqueId, InteractiveId)
		ScreenPrint("回复申请 OnRequestUseOwnerRegionOnlineItem 服务端返回结果 Ret："..tostring(Ret).." ，UniqueId："..tostring(UniqueId).." ，InteractiveId："..tostring(InteractiveId))
		self.logger.debug("ZJT_ OnRequestUseOwnerRegionOnlineItem ", Ret,  self.CurrentOnlineType, RequestRes, UniqueId, InteractiveId)
		if Ret ~= 0 then
			local OnlineActionController =require "BluePrints.UI.WBP.BattleOnlineAction.OnlineActionController"
			OnlineActionController:ShowToastByErrorCode(Ret,false)
		end
	end
	self:CallServer("OnRequestUseOwnerRegionOnlineItem", Callback,  self.CurrentOnlineType, RequestEid, RequestRes, UniqueId, InteractiveId)
end


--- 创建区域联机交互机关或者物品
--- 目前只有战斗轮盘
function Component:UseCreateMechanism(online_type, ResourceId, UnitId, CreateMechanism)
	CreateMechanism = CreateMechanism or {}
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	local Location = Player:GetRecentSafeLocation()
	Location.Z = Location.Z - Player.CapsuleComponent:GetScaledCapsuleHalfHeight()
	local PlayerLocation = CommonUtils.LocationToTable(Location)
	local PlayerRotation = CommonUtils.RotationToTable(Player: K2_GetActorRotation())
	local CreateMechanismInfo = {
		ResourceId = ResourceId,
		UnitId = UnitId,
		Location = PlayerLocation,
		Rotation = PlayerRotation,
		CreateMechanism = CreateMechanism,
		UnitType = "Mechanism",
	}
	local function Callback(Ret, UniqueId)
		if Ret == 0 then
			CreateMechanismInfo.Sender = self.Eid
			CreateMechanismInfo.UniqueId = UniqueId
			if Player.PlayerAnimInstance and Player.PlayerAnimInstance.IdleTagName == "Gesture01_Idle" then
				self:RealCreateMechanism(CreateMechanismInfo)
				local OnlineActionController = require "BluePrints.UI.WBP.BattleOnlineAction.OnlineActionController"
				OnlineActionController:OnCreatOnlineAction(UniqueId)
			else
				self:RequestDeadRegionOnlineItem(self.CurrentOnlineType, self.Eid, UniqueId)
			end
		end
		self.logger.debug("ZJT_ UseCreateMechanism ", Ret, online_type, ResourceId, UniqueId)
	end
	self:CallServer("UseCreateMechanism", Callback, online_type, CreateMechanismInfo)
end

--- 切换当前玩家状态 NewState 新的状态 UseTargetParam额外的状态 例如子状态
function Component:SwitchOnlineState(online_type, NewState, UseTargetParam, IsUpdateState)
	-- 不传则默认更新状态
	if IsUpdateState == nil then
		IsUpdateState = true
	end
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	if self.IsInRegionOnline then
		Player.CurrentOnlineState = NewState or CommonConst.OnlineState.Normal
	end
	local Message = {
		Type = "SwitchOnlineState",
		State = NewState or CommonConst.OnlineState.Normal,
		UseTargetParam = UseTargetParam or { },
		IsUpdateState = IsUpdateState,
		ActionBaseInfo = Player:GetPlayerLocationAndRotation(),
	}
	DebugPrint("gmy@OnlineComp Component:SwitchOnlineState", NewState)
	self:UploadPlayerMessage(online_type, Message)
end

function Component:UseGouSuoMessage(online_type, CreatorId)
	local Message = {
		Type = "UseGouSuo",
		CreatorId = CreatorId,
	}
	self:UploadPlayerMessage(online_type, Message)
end

function Component:HandleUseGouSuo(Message)
	local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
	local Creator = GameState.StaticCreatorMap:FindRef(Message.CreatorId)
	if not Creator then
		return
	end
	local Player = self:GetBornedChar(Message.Sender)
	if not Player then
		return
	end
	for i = 1, Creator.ChildEids:Length() do
		local Eid = Creator.ChildEids:GetRef(i)
		local Hook = GameState.Battle:GetEntity(Eid)
		if Hook then
			Hook.HookInteractiveComponent:StartInteractive(Player)
		end
	end
end

--- 主机发起创建坐骑
function Component:RequestUseCreateMount(online_type, ResourceId, MountId, UseState)
	local function Callback(Ret)
		self.logger.debug("ZJT_ RequestUseCreateMount ", Ret)
	end
	self:CallServer("RequestUseCreateMount",Callback, online_type, ResourceId, MountId, UseState)
end
--- 联机动作相关 发起邀请
--- 主机主动发起对其他玩家发起邀请物品交互
--- 本机Eid 邀请玩家的EId 物品的唯一ID 交互ID 机关要变化的状态
function Component:RequestHostInvitationOther(InvitationEid, UniqueId, InteractiveId, NewState)
	ScreenPrint("客户端发起邀请 RequestHostInvitationOther InvitationEid："..CommonUtils.ObjId2Str(InvitationEid).." ，UniqueId："..tostring(UniqueId).." ，InteractiveId："..tostring(InteractiveId).." ，NewState："..tostring(NewState))
	local  Callback= function (Ret)
		ScreenPrint("客户端发起邀请结果 Ret："..tostring(Ret).." ，UniqueId："..tostring(UniqueId).." ，InteractiveId："..tostring(InteractiveId).." ，NewState："..tostring(NewState))
		if  Ret==52015 or Ret==52025 then --52015服务器超时拒绝 52025被客户端拒绝
			EventManager:FireEvent(EventID.OnReceivedOnlineActionInvitationReject, InvitationEid, UniqueId, InteractiveId, NewState)
		elseif Ret==0 then
			EventManager:FireEvent(EventID.OnReceivedOnlineActionInvitationAgree, InvitationEid, UniqueId, InteractiveId, NewState)
		elseif Ret==52024 then --52024 正在等待回复
        	UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_RegionOnline_Invite_Inviting"))
		else
			-- local OnlineActionController =require "BluePrints.UI.WBP.BattleOnlineAction.OnlineActionController"
			-- OnlineActionController:ShowToastByErrorCode(Ret,true)
			ScreenPrint("客户端发起邀请结果 未知错误 Ret："..tostring(Ret).." ，UniqueId："..tostring(UniqueId).." ，InteractiveId："..tostring(InteractiveId).." ，NewState："..tostring(NewState))
		end
		self.logger.debug("ZJT_ RequestHostInvitationOther ", Ret)
	end
	self:CallServer("RequestHostInvitationOther",Callback, self.CurrentOnlineType, self.Eid, InvitationEid, UniqueId, InteractiveId, NewState or 1)
end
--- 联机动作相关 回复邀请
--- 收到他人邀请动作后，拒绝/接受他人邀请
--- 其他客户端接收到 主机玩家对于某一物品的邀请消息
--- 返回玩家的选择 同意邀请 拒绝邀请 InviterEid 拥有该交互机关的Eid
function Component:OnRequestOtherUserRegionOnlineItem(InviterEid, RequestRes, UniqueId, InteractiveId)
	ScreenPrint("回复邀请 OnRequestOtherUserRegionOnlineItem  InviterEid："..CommonUtils.ObjId2Str(InviterEid).." ，RequestRes："..tostring(RequestRes).." ，UniqueId："..tostring(UniqueId).." ，InteractiveId："..tostring(InteractiveId))
	local function Callback(Ret)
		ScreenPrint("回复邀请结果 Ret："..tostring(Ret).." ，UniqueId："..tostring(UniqueId).." ，InteractiveId："..tostring(InteractiveId))
		self.logger.debug("ZJT_ OnRequestOtherUserRegionOnlineItem ", Ret,  self.CurrentOnlineType, RequestRes)
		if Ret==0 then
			local message = {
				UniqueId = UniqueId, 
				InteractiveId = InteractiveId,
				Sender = self.Eid,
				RequestEid = self.Eid,
				IsGlobalOnlineItem = false
			}
			self:RealInteractive(message)
		EventManager:FireEvent(EventID.OnReceivedOnlineActionInvitationAgree, InviterEid, UniqueId, InteractiveId)
		else
			local OnlineActionController =require "BluePrints.UI.WBP.BattleOnlineAction.OnlineActionController"
			OnlineActionController:ShowToastByErrorCode(Ret,true)
		end
	end
	self:CallServer("OnRequestOtherUserOnlineItem", Callback,  self.CurrentOnlineType, InviterEid, RequestRes, UniqueId, InteractiveId)
end
--- 服务端调用，通知客户端收到了邀请
--- 联机动作相关 收到邀请
--- 其他客户端接收到 主机玩家对于某一物品的邀请消息
--- 主机Eid 物品唯一ID 物品交互ID
function Component:RequestOtherUserRegionOnlineItem(OwnerEid, UniqueId, InteractiveId)
	--self.OwnerEid = OwnerEid
	ScreenPrint("客户端收到邀请 RequestOtherUserRegionOnlineItem OwnerEid："..CommonUtils.ObjId2Str(OwnerEid).." ，UniqueId："..tostring(UniqueId).." ，InteractiveId："..tostring(InteractiveId))
	--self:OnRequestOtherUserRegionOnlineItem( OwnerEid, true, UniqueId,InteractiveId)
	EventManager:FireEvent(EventID.ReceivedOthersOnlineActionInvitation, OwnerEid, UniqueId, InteractiveId)
	-- self:OnRequestOtherUserRegionOnlineItem(OwnerEid, true,UniqueId, InteractiveId)
end


-- 主机发起回收坐骑
function Component:RequestDeadRegionOnlineMount(online_type, MountId)
	local function Callback(Ret)
		self.logger.debug("ZJT_ RequestDeadRegionOnlineMount ", Ret)
	end
	self:CallServer("RequestDeadRegionOnlineMount",Callback, online_type, MountId)
end
-- 主机发起改变坐骑的状态
function Component:RequestChangeRegionOnlineMount(online_type, MountId, MountState)
	local function Callback(Ret)
		self.logger.debug("ZJT_ RequestDeadRegionOnlineMount ", Ret)
	end
	self:CallServer("RequestDeadRegionOnlineMount",Callback, online_type, MountId, MountState)
end
-- 广播 除主机外客户端接收 各个客户端都能接受该消息 例如改变玩家骑乘还是下马
function Component:HandleOnChangeRegionOnlineMount(Message)
	PrintTable({OnChangeRegionOnlineMount = Message}, 10)
end

function Component:RequestSendSuccess(Type)
	self.logger.debug("ZJT_ 请求发送成功 ", Type)
	if Type=="OtherUser" then
		UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_RegionOnline_Invitation_Sent"))
		return
	end
	if Type=="UseOwner" then

		return
	end
end


-- 广播 除主机外客户端接收
function Component:HandleShareMountDatasChange(Message)
	PrintTable({ShareMountDatasChange = Message}, 10)
end
-- 广播 各个客户端都能接受该消息 通知玩家某个主机玩家回收坐骑
-- 广播 各个客户端都能接受该消息 通知玩家某个主机玩家回收坐骑
function Component:HandleOnDeadRegionOnlineMount(Message)
	PrintTable({OnDeadRegionOnlineMount = Message}, 10)
	PrintTable({Message = Message}, 10)
	if Message.Sender == self.Eid then
		return
	end
	local ObjId = Message.Sender 
	local TempRoleInfo = self:GetRoleInfo(ObjId)
	if not TempRoleInfo then
		print(_G.LogTag, "Not a legal roleinfo")
		return
	end
	if not TempRoleInfo.MountDatas then 
		print(_G.LogTag, "TempRoleInfo.MountDatas not exist")
		return
	end
	TempRoleInfo.MountDatas.MountId = 0


end
-- 广播 各个客户端都能接受该消息 通知玩家某个主机玩家创建坐骑
function Component:HandleOnUseCreateMount(Message)
	PrintTable({OnUseCreateMount = Message}, 10)
	PrintTable({Message = Message}, 10)
	if Message.Sender == self.Eid then
		return
	end
	local ObjId = Message.Sender 
	local TempRoleInfo = self:GetRoleInfo(ObjId)
	if not TempRoleInfo then
		print(_G.LogTag, "Not a legal roleinfo")
		return
	end
	if not TempRoleInfo.MountDatas then 
		print(_G.LogTag, "TempRoleInfo.MountDatas not exist")
		return
	end
	TempRoleInfo.MountDatas.MountId = Message.MountId or 0
end
----- 通知当前玩家接收某一个玩家离开交互机关
function Component:HandleOnLeaveRegionOnlineItem(message)
	self.logger.debug("ZJT_ HandleOnLeaveRegionOnlineItem "..CommonUtils.ObjId2Str(self.Eid))
	PrintTable({message = message}, 10)
	if message.Sender == self.Eid then
		return
	end
	self:RealDeInteractive(message)
end
----- 通知当前玩家接收某一个玩家创建交互机关
function Component:HandleOnUseRegionOnlineItem(message)
	self.logger.debug("ZJT_ HandleOnUseRegionOnlineItem ")
	PrintTable({message = message}, 10)
	self:RealCreateMechanism(message)
end
----- 通知当前玩家接收某一个玩家交互机关状态改变
function Component:HandleOnChangeRegionOnlineItemState(message)
	-- self.logger.debug("ZJT_ HandleOnChangeRegionOnlineItemState "..CommonUtils.ObjId2Str(self.Eid),debug.traceback())
	PrintTable({message = message}, 10)
	if message.Sender == self.Eid then
		return
	end
	self:RealInteractive(message)
end
----- 通知当前玩家接收某一个玩家销毁机关
function Component:HandleOnDeadRegionOnlineItem(message)
	print(_G.LogTag,"LXZ RequestDeadRegionOnlineItem3333")
	self.logger.debug("ZJT_ HandleOnDeadRegionOnlineItem ")
	PrintTable({message = message}, 10)
	self:RealDeadRegionOnlineItem(message.UniqueId, message.Sender, false)
end

function Component:RealCreateMechanism(message)
	local Loc = message.Location
	local Rot = message.Rotation
	local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
	local Context = AEventMgr.CreateUnitContext()
	Context.UnitType = "Mechanism"
	Context.UnitId = message.UnitId
	Context.Loc = FVector(Loc.X, Loc.Y, Loc.Z)
	Context.Rotation = FRotator(Rot.Pitch, Rot.Yaw, Rot.Roll)

	local Sender = CommonUtils.ObjId2Str(message.Sender)
	local ResourceId = message.ResourceId
	Context.NameParams:Add("Sender", Sender)
	Context.NameParams:Add("UniqueId", message.UniqueId)
	Context.IntParams:Add("ResourceId", ResourceId)
	print(_G.LogTag,"LXZ ResourceUseEffectCreateMechanism Real", Context.UnitId, Sender, self.Eid)
	GameState.EventMgr:CreateUnitNew(Context, true)

    GameState:RegisterPlayerMechanismRegionOnline(Sender, message.UniqueId)
end

function Component:RealInteractive(message)
	PrintTable(message, 10)
	self:UpdateMechanismUser(message.UniqueId, message.InteractiveId, message.Sender, true)
	local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
	local Player
	if message.RequestEid then
		if message.RequestEid == self.Eid then
			Player = UGameplayStatics.GetPlayerCharacter(GameState, 0)
		else
			Player = self:GetBornedChar(message.RequestEid)
		end
	else
		Player = self:GetBornedChar(message.Sender)
	end
	local Mechanism = GameState.RegionOnlineMechanismMap:Find(message.UniqueId)
	print(_G.LogTag,"LXZ HandleOnChangeRegionOnlineItemState111", message.UniqueId, Mechanism, message.IsGlobalOnlineItem)
	if message.Sender == self.Eid then
		if not Player or not Mechanism or not Mechanism:IsCanOnlineInteractive(Player) then
			self:RequestLeaveRegionOnlineItem(self.CurrentOnlineType, message.UniqueId, self.Eid, message.InteractiveId)
			return
		end
		local InteractiveComp = Mechanism.ChestInteractiveComponent
		print(_G.LogTag,"LXZ HandleOnChangeRegionOnlineItemState222", Mechanism.Eid, Player.Eid, InteractiveComp.NextStateId, InteractiveComp.CommonUIConfirmID, message.InteractiveId)
		Player:InteractiveMechanism(Mechanism.Eid, Player.Eid, InteractiveComp.NextStateId, InteractiveComp.CommonUIConfirmID, true, message.InteractiveId)
	else
		if not Mechanism then
			return
		end
		local InteractiveComp = Mechanism.ChestInteractiveComponent
		print(_G.LogTag,"LXZ HandleOnChangeRegionOnlineItemState333", Mechanism.Eid, Player.Eid, InteractiveComp.NextStateId, InteractiveComp.CommonUIConfirmID, message.InteractiveId)
		Player:InteractiveMechanism(Mechanism.Eid, Player.Eid, InteractiveComp.NextStateId, InteractiveComp.CommonUIConfirmID, true, message.InteractiveId)
	end
end
	
function Component:RealDeInteractive(message)
	self:UpdateMechanismUser(message.UniqueId, message.InteractiveId, message.Sender, false)
	local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
	local Player = self:GetBornedChar(message.Sender)
	if message.Sender == self.Eid then
		Player = UGameplayStatics.GetPlayerCharacter(GameState, 0)
	end
	local Mechanism = GameState.RegionOnlineMechanismMap:Find(message.UniqueId)
	print(_G.LogTag,"LXZ HandleOnLeaveRegionOnlineItem RealDeInteractive", message.UniqueId)
	if not Player then
		return
	end
	if not Mechanism then
		return
	end
	print(_G.LogTag,"LXZ HandleOnLeaveRegionOnlineItem RealDeInteractive", message.UniqueId, Mechanism:GetName(), Player:GetName())
	local InteractiveComp = Mechanism.ChestInteractiveComponent
	Player:DeInteractiveMechanism(Mechanism.Eid, Player.Eid, 0, true, InteractiveComp.NextStateId, true, message.InteractiveId)		
end

function Component:RealDeadRegionOnlineItem(UniqueId, SenderEid, bAllClear)
	local GameState = UGameplayStatics.GetGameState(GWorld.GameInstance)
	local AvatarEid = CommonUtils.ObjId2Str(SenderEid)
	if not bAllClear then
		GameState:RemoveMechanismRegionOnline(UniqueId, EDestroyReason.OwnerTagChange)
		GameState:RemovePlayerMechanismRegionOnline(AvatarEid, UniqueId, false)
	else
		local UniqueIdList = GameState.PlayerRegionOnlineMechanismMap:Find(AvatarEid)
		if not UniqueIdList then
			return
		end
		for i, UniqueId in pairs(UniqueIdList.Array) do
			GameState:RemoveMechanismRegionOnline(UniqueId, EDestroyReason.OwnerLeaveRegion)
		end
		GameState:RemovePlayerMechanismRegionOnline(AvatarEid, "", true)
	end
end


------------------------------------------- 联机机关 -------------------------------------------
------------------------------------------- 联机机关 -------------------------------------------

function Component:GetBornedChar(ObjId)
    local RegionSycnSubsystem = UE4.URegionSyncSubsystem.GetInstance(GWorld.GameInstance)
    if not RegionSycnSubsystem then
    	return nil
    end
    local ObjIdStr = CommonUtils.ObjId2Str(ObjId)
    local BornedChar = RegionSycnSubsystem:GetBornedChar(ObjIdStr)
    return BornedChar
end

function Component:GetRoleInfo(ObjId)
    return self.OtherRoleInfo[ObjId]
end

function Component:GetRoleBornedEid(ObjId)
	local RegionSycnSubsystem = UE4.URegionSyncSubsystem.GetInstance(GWorld.GameInstance)
    if not RegionSycnSubsystem then
    	return nil
    end
    local ObjIdStr = CommonUtils.ObjId2Str(ObjId)
    local Eid = RegionSycnSubsystem:GetEntityEid(ObjIdStr)
    return Eid
end

function Component:UpdateTotatlOnlineTime()
	self.logger.debug("ZJT_ UpdateTotatlOnlineTime ", self.TotalRegionOnlineTime)
end

function Component:RegionOnlineTransformAFDay(TransformId)
	DebugPrint("gmy@OnlineComp Component:RegionOnlineTransformAFDay", TransformId)
	
	-- TODO: 先判断下是不是在区域联机状态
	if not self.IsInRegionOnline then
		return
	end

	local function Callback(Ret)
		DebugPrint("gmy@OnlineComp Callback", Ret)
	end
	self:CallServer("RegionOnlineTransformAFDay", Callback, TransformId)
end

-------------------------------------------------------------------
------------------------- 获得区域频道信息 -------------------------
-------------------------------------------------------------------
function Component:QueryRegionOnlineChannelState(online_type, ids)
	local function callback(ret, info)
		
	end
	self:CallServer("QueryRegionOnlineChannelState", callback, online_type, ids)
end

function Component:QueryRegionOnlineChannelCount(online_type)
	local function callback(ret, info)
		
	end
	self:CallServer("QueryRegionOnlineChannelCount", callback, online_type)
end

return Component