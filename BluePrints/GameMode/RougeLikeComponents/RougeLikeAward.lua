--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--



---@type BP_RougeLikeManager_C
local UIUtils = require "Utils.UIUtils"
local Component = {}


--UpdateInfo = {
--	Type = "Treasure"/"Blessing"
--	Event = "Add"/"Remove"/"Upgrade"/"3Choose1"/"Mark"
--	AwardsId = {
--		{ItemId = num},
--		{ItemId = num},
--	}
--}

function Component:TriggerShowDedicatedSettlemenUI()
	local RougeGameSettlement = UIManager(self):GetUIObj("RougeGameSettlement")
	if IsValid(RougeGameSettlement) then
		RougeGameSettlement:InitRewardAndShow(self.DedicatedSettlemenRewards)
	end
	self.DedicatedSettlemenRewards = nil
end

function Component:OnUpdateAward(UpdateInfo)
	if self.IsLoading then -- 如果此时还在Loading，延迟发奖逻辑直到CloseLoading
		self.UpdateInfo = UpdateInfo
		return
	end
	-- 延迟1.5s播3选1
	local IsEventAward = self.bHandleEventTime
	self:PrintUpdateInfo(UpdateInfo)
	local function _Callback( ... )
		self.AwardList = {}
		self:ShowRougeAward(UpdateInfo, IsEventAward)
	end
	local RoomInfo = DataMgr.RougeLikeRoom[self.RoomId]
	local TypeInfo = DataMgr.RougeLikeRoomType[RoomInfo.RoomType]
	if TypeInfo.EnableAwardDelay and self.IsPassRoomAward then
		self:AddTimer(1.5, _Callback)
	else
		_Callback()
	end
end

function Component:TryEventPassRoom()
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	assert(GameMode, "GameMode不存在")
	if self.bHandleEventTime then
		if self.RandomBlessings:Num() <= 0 and self.RandomTreasures:Num() <= 0 then
			--GameMode:PostCustomEvent("EventPassRoom")
			EventManager:FireEvent(EventID.OnRougeDealEventReward)
		end
	end
end

function Component:ListenDealRewardEvent()
	DebugPrint("RougeLikeManager:ListenDealRewardEvent RoomId:", self.RoomId)
	self.IsListeningDealRewardEvent = true
	EventManager:AddEvent(EventID.OnRougeDealEventReward, self, self.OnEventRewardDeal)
end

function Component:OnEventRewardDeal()
	self.IsListeningDealRewardEvent = false
	DebugPrint("RougeLikeManager:OnEventRewardDeal RoomId:", self.RoomId)
	EventManager:RemoveEvent(EventID.OnRougeDealEventReward, self)
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	GameMode:PostCustomEvent("EventPassRoom")
end

function Component:ShowRougeAward(UpdateInfo, IsEventAward)

	self:FillAwardList(UpdateInfo)
	--if AppendInfo and AppendInfo.Blessings then
	--	local Blessings = AppendInfo.Blessings
	--	-- @SnowMoon 发回来的是一个table，虽然里面只有一个，万一以后扩展成多个先预留延展性
	--	for _,BlessingItemId in ipairs(Blessings) do
	--		--local BlessingItemId = v
	--		DebugPrint("1选1刻印编号为：", BlessingItemId)
	--		self:FillAwardList("Blessing", {BlessingItemId})
	--	end
	--elseif AppendInfo and AppendInfo.RandomBlessings and #AppendInfo.RandomBlessings > 0 then
	--	self:FillAwardList("Blessing", AppendInfo.RandomBlessings)
	--end
	--
	--if AppendInfo and AppendInfo.Treasures then
	--	-- 1个奖励的选项只做客户端逻辑，实际服务端已经发了
	--	local Treasures = AppendInfo.Treasures
	--	for _, TreasureItemId in ipairs(Treasures) do
	--		--local TreasureItemId = Treasures[1]
	--		DebugPrint("1选1宝物编号为：", TreasureItemId)
	--		self:FillAwardList("Treasure", {TreasureItemId})
	--	end
	--elseif AppendInfo and AppendInfo.RandomTreasures and  #AppendInfo.RandomTreasures > 0 then
	--	self:FillAwardList("Treasure", AppendInfo.RandomTreasures)
	--end
	if not self.IsGettingAward then
		self:ShowNextAward(self.AwardList, IsEventAward)
	end

end

function Component:FillAwardList(UpdateInfo)
	--local InfoList = {}
	--local AwardNum
	--if type(RandomItems) == "table" then
	--	AwardNum = CommonUtils.Size(RandomItems)
	--else
	--	AwardNum = RandomItems:Length()
	--end
	--for _, AwardId in ipairs(UpdateInfo.AwardsId) do
	--	table.insert(InfoList, {ItemId = AwardId})
	--end
	--local ItemSelectInfo = {
	--	AwardType = Type,
	--	Event = Event,
	--	InfoList = InfoList,
	--}
	if self.IsGettingAward then
		DebugPrint("@zyh 正在弹出奖励信息，新进奖励塞进BackUp")
		table.insert(self.BackUpAwardList, UpdateInfo) -- 如果正在领奖的时候有新的奖励进来，先放进后备List
	else
		table.insert(self.AwardList, UpdateInfo)
	end
end

function Component:ShowNextAward(AwardList, IsEventAward)
	self.IsGettingAward = false
	if next(AwardList) == nil then
		if not self.BackUpAwardList or next(self.BackUpAwardList) == nil then
			return
		else
			-- 如果后备List里还有没领取的奖励，继续发奖
			AwardList = CommonUtils.DeepCopy(self.BackUpAwardList)
			self.BackUpAwardList = {}
		end
	end
	self.IsGettingAward = true

	---------------------------------------------------------------
	local Type = AwardList[1].Type
	local Event = AwardList[1].Event
	if Event == "3Choose1" then -- 三选一情况
		if  Type == "Blessing" then
			UIManager(self):LoadUINew("Rouge_Blessing_3Choose1", AwardList, IsEventAward)
		else
			UIManager(self):LoadUINew("Rouge_Treasure_3Choose1", AwardList, IsEventAward)
		end
	elseif Event == "Add" then -- 直接增加
		-- todo: 目前只支持弹一个 后续支持弹多个
		local InfoDatas={}
		local InfoDataList={}
		for _, value in pairs(AwardList[1].AwardsId) do
			local RandomInfo
			if  Type == "Blessing" then
				local BlessingId = value.ItemId
				RandomInfo = DataMgr.RougeLikeBlessing[BlessingId]
			else
				local TreasureId = value.ItemId
				RandomInfo = DataMgr.RougeLikeTreasure[TreasureId]
			end
			table.insert(InfoDataList,RandomInfo)
		end
		InfoDatas.Islose=false
		InfoDatas.InfoDataList=InfoDataList
		if AwardList[1].UseDedicatedSettlementUI then
			if not self.DedicatedSettlemenRewards then
				self.DedicatedSettlemenRewards = {}
			end
			for _, Info in pairs(InfoDatas.InfoDataList) do
				table.insert(self.DedicatedSettlemenRewards,Info)
			end
			table.remove(self.AwardList,1)
			self:ShowNextAward(self.AwardList)
		else
			UIManager(self):LoadUINew(UIConst.GetItemsTip,InfoDatas, AwardList)
		end
	elseif Event == "Upgrade" then -- 升级
		-- todo: 目前只支持弹一个 后续如果要弹多个再说
		local Params={}
		Params.ItemId = AwardList[1].AwardsId[1].ItemId
		Params.OldLevel = AwardList[1].AwardsId[1].OldLevel
		Params.NewLevel= AwardList[1].AwardsId[1].NewLevel
		UIManager(self):LoadUINew(UIConst.UpgradeTip, Params)
	elseif Event == "Remove" then -- 被移除
		-- todo: 目前没有移除的UI 
		local InfoDatas={}
		local InfoDataList={}
		for index, value in pairs(AwardList[1].AwardsId) do
			local RandomInfo
			if  Type == "Blessing" then
				local BlessingId = value.ItemId
				RandomInfo = DataMgr.RougeLikeBlessing[BlessingId]
			else
				local TreasureId = value.ItemId
				RandomInfo = DataMgr.RougeLikeTreasure[TreasureId]
			end
			table.insert(InfoDataList,RandomInfo)
		end
		InfoDatas.Islose=true
		InfoDatas.InfoDataList=InfoDataList
		UIManager(self):LoadUINew(UIConst.GetItemsTip,InfoDatas, AwardList)
	elseif Event == "Mark" then
		self:TriggerShowDedicatedSettlemenUI()
	end
	
	
	--DebugPrint("@zyh", CommonUtils.Size(AwardList[1].InfoList))
	--PrintTable(AwardList, 4)
	--if  CommonUtils.Size(AwardList[1].InfoList) == 1 then
	--	local RandomInfo
	--	if  AwardList[1].AwardType=="Blessing" then
	--		local RandomBlessingId = AwardList[1].InfoList[1].ItemId
	--		RandomInfo = DataMgr.RougeLikeBlessing[RandomBlessingId]
	--	else
	--		local RandomTreasureId = AwardList[1].InfoList[1].ItemId
	--		RandomInfo = DataMgr.RougeLikeTreasure[RandomTreasureId]
	--	end
	--	UIManager(self):LoadUINew(UIConst.GetItemsTip,RandomInfo, AwardList)
	--else
	--	local UIManager = GWorld.GameInstance:GetGameUIManager()
	--	if  AwardList[1].AwardType=="Blessing" then
	--		UIManager:LoadUINew("Rouge_Blessing_3Choose1", AwardList, IsEventAward)
	--	else
	--		UIManager:LoadUINew("Rouge_Treasure_3Choose1", AwardList, IsEventAward)
	--	end
	--end
end

function Component:OnChooseAwardFinished()
	-- 废弃了应该是
	-- DebugPrint("RougeLikeManager: OnChooseAwardFinished")
	-- if self.CurRougeStage == ERougeStage.PopUp3Choose1 then			-- @ljl 目前仅有肉鸽事件关需要，选了三选一后，将当前阶段设为PassRoom
	-- 	self.CurRougeStage = ERougeStage.PassRoom					-- 普通战斗关在OnPassRoom时就已到PassRoom了
	-- end
	-- self:TriggerRecordProgressData()
end

function Component:AddTreasures(TreasureId, Level)
	if not self.Treasures:FindRef(TreasureId) then
		self.PlayerCharacter = UGameplayStatics.GetPlayerCharacter(self, 0)
		local TreasureData = DataMgr.RougeLikeTreasure[TreasureId]
		if self.PlayerCharacter and self.PlayerCharacter.InitSuccess and TreasureData then
			local ModEquip = TreasureData.ModEquip
			local ModId = TreasureData.TreasureMod
			DebugPrint("Mod编号", ModId, "Mod装备位置", ModEquip)
			if ModId and ModEquip then
				self:AddModById(ModId, ModEquip, Level)
			end
			local ClientBuild = TreasureData.ClientBuild
			if ClientBuild and ClientBuild.GroupDiscount then
				self.BlessingGroupDiscount = self.BlessingGroupDiscount + ClientBuild.GroupDiscount
			end
			self:AddTreasureGroup(TreasureId,false)
		else
			self.NeedInitTreasures = true -- 如果此时PlayerCharacter没初始化成功，打个Flag
		end
	else
		DebugPrint("Treasure", TreasureId, "已存在 请勿重复添加")
	end
end

function Component:RemoveTreasures(TreasureId)
	if self.Treasures:FindRef(TreasureId) then
		local Level = self.Treasures:Find(TreasureId).Level
		self:UpgradeModById("Treasure", TreasureId, Level, nil)
		self.TreasureGroup:Add(TreasureId, self.TreasureGroup:Find(TreasureId) - 1)
	else
		DebugPrint("Treasure", TreasureId, "不存在 无法移除")
	end
	-- 移除Treasure之后重新计算一次套装效果
	self.PlayerCharacter = UGameplayStatics.GetPlayerCharacter(self, 0)
	self:ReCountTreasureGroup(true)
end

function Component:AddTreasureGroup(TreasureId,NoNeedActiveUI)
	local ThisTreasureGroup = DataMgr.RougeLikeTreasure[TreasureId].TreasureGroup
	if self.TreasureGroup:Find(ThisTreasureGroup) then
		self.TreasureGroup:Add(ThisTreasureGroup, self.TreasureGroup:Find(ThisTreasureGroup) + 1)
	else
		self.TreasureGroup:Add(ThisTreasureGroup, 1);
	end
	self:UpdateTreasureGroup(ThisTreasureGroup,NoNeedActiveUI)
end


-- 重新计算一次套装效果
function Component:ReCountTreasureGroup(NoNeedActiveUI)
	for GroupId, _ in pairs(self.TreasureGroup) do
		self:UpdateTreasureGroup(GroupId,NoNeedActiveUI)
	end
end

function Component:UpdateTreasureGroup(GroupId,NoNeedActiveUI)
	local CurrentCount = self.TreasureGroup:Find(GroupId)
	local GroupTable = DataMgr.TreasureGroup[GroupId]
	if not GroupTable or not GroupTable.ActivateNeed then
		return
	end
	local ActiveNeedCount = #GroupTable.ActivateNeed
	if not NoNeedActiveUI and CurrentCount >= ActiveNeedCount then
		self.NeedActivateList[GroupId] = true
	end
end

function Component:AddBlessings(BlessingId, Level)
	if not self.Blessings:FindRef(BlessingId) then
		self.PlayerCharacter = UGameplayStatics.GetPlayerCharacter(self, 0)
		if self.PlayerCharacter and self.PlayerCharacter.InitSuccess then
			local ModEquip = DataMgr.RougeLikeBlessing[BlessingId].ModEquip
			local ModId = DataMgr.RougeLikeBlessing[BlessingId].BlessingMod
			DebugPrint("Mod编号", ModId, "Mod装备位置", ModEquip)
			if ModId and ModEquip then
				self:AddModById(ModId, ModEquip, Level)
			end
			self:AddBlessingGroup(BlessingId, self.PlayerCharacter)
		else
			self.NeedInitBlessings = true
		end
	else
		DebugPrint("Blessing", BlessingId, "已存在 请勿重复添加")
	end
end

function Component:RemoveBlessings(BlessingId)
	if self.Blessings:FindRef(BlessingId) then
		local Level = self.Blessings:Find(BlessingId).Level
		-- Mod的等级从0开始 但祝福宝物等级从1开始 需要-1
		self:UpgradeModById("Blessing", BlessingId, Level - 1, nil)
		local GroupId = DataMgr.RougeLikeBlessing[BlessingId].BlessingGroup
		self.BlessingGroup:Add(GroupId, self.BlessingGroup:Find(GroupId) - 1)
	else
		DebugPrint("Blessing", BlessingId, "不存在 无法移除")
	end
	-- 移除Blessing之后重新计算一次套装效果
	self.PlayerCharacter = UGameplayStatics.GetPlayerCharacter(self, 0)
	self:ReCountBlessingGroup(self.PlayerCharacter, true)
end

function Component:AddBlessingGroup(BlessingId, PlayerCharacter, NoNeedActiveUI)
	local ThisBlessingGroup = DataMgr.RougeLikeBlessing[BlessingId].BlessingGroup
	if self.BlessingGroup:Find(ThisBlessingGroup) then
		self.BlessingGroup:Add(ThisBlessingGroup, self.BlessingGroup:Find(ThisBlessingGroup) + 1)
	else
		self.BlessingGroup:Add(ThisBlessingGroup, 1);
	end
	self:UpdateBlessingGroup(ThisBlessingGroup, PlayerCharacter, NoNeedActiveUI)
end

-- 重新计算一次套装效果
function Component:ReCountBlessingGroup(PlayerCharacter, NoNeedActiveUI)
	for GroupId, _ in pairs(self.BlessingGroup) do
		self:UpdateBlessingGroup(GroupId, PlayerCharacter, NoNeedActiveUI)
	end
end

function Component:UpdateBlessingGroup(GroupId, PlayerCharacter, NoNeedActiveUI)
	local GroupPassiveEffects = DataMgr.BlessingGroup[GroupId].PassiveEffects
	for _, PassiveEffectId in ipairs(GroupPassiveEffects) do
		local PassiveEffectActor = PlayerCharacter:GetPassiveEffectById(PassiveEffectId)
		if not PassiveEffectActor then
			PassiveEffectActor = PlayerCharacter:AddPassiveEffectByRole(PlayerCharacter.CurrentRoleId, PassiveEffectId, 0)
		end
		local CurrentCount = self.BlessingGroup:Find(GroupId)
		local CurGroupLevel = 0
		for i, Threshold in ipairs(DataMgr.BlessingGroup[GroupId].ActivateNeed) do
			if CurrentCount < Threshold + self.BlessingGroupDiscount then
				break
			else
				CurGroupLevel = i
			end
		end
		if PassiveEffectActor:GetSkillLevel() ~= CurGroupLevel then
			DebugPrint("@zyh 当前的套装:", GroupId, "激活层数:", CurGroupLevel)
			PassiveEffectActor:SetSkillLevel(CurGroupLevel)
			if not NoNeedActiveUI then
				self.NeedActivateList[GroupId] = CurGroupLevel
			end
		end
	end
end

-- 在获取祝福的弹窗结束之后,判断是否需要出套装激活弹窗
function Component:OnGetAwardUIClose()
	for BlessingGroupId,_ in pairs(self.BlessingGroup) do
		--local ThisBlessingGroup = DataMgr.RougeLikeBlessing[BlessingId].BlessingGroup
		if self.NeedActivateList[BlessingGroupId] then
			self:AddTimer(0.1, function()
				UIManager(self):LoadUINew("Rouge_SuitActivate", BlessingGroupId, self.NeedActivateList[BlessingGroupId])
				self.NeedActivateList[BlessingGroupId] = nil
			end, false, nil, nil, true)
			return
		end
	end
	for TreasureGroupId,_ in pairs(self.TreasureGroup) do
		if self.NeedActivateList[TreasureGroupId] then
			self:AddTimer(0.1, function()
				local bTreasure = true
				UIManager(self):LoadUINew("Rouge_SuitActivate", TreasureGroupId, self.NeedActivateList[TreasureGroupId],bTreasure)
			end, false, nil, nil, true)
			self.NeedActivateList[TreasureGroupId] = nil
			return
		end
	end
end

function Component:AddTalents(TalentId, Level)
	if not self.Talents:Find(TalentId) then
		self.PlayerCharacter = UGameplayStatics.GetPlayerCharacter(self, 0)
		if self.PlayerCharacter and self.PlayerCharacter.InitSuccess then
			--DebugPrint(self.PlayerCharacter.InitSuccess, self.PlayerCharacter, self.PlayerCharacter.RangedWeapon, self.PlayerCharacter.MeleeWeapon, "@zyh调试1")
			local ModId=DataMgr.RougeLikeTalent[TalentId].TalentMod
			local ModEquip=DataMgr.RougeLikeTalent[TalentId].ModEquip
			DebugPrint("Mod编号", ModId, "Mod装备位置", ModEquip)
			if ModId and ModEquip then
				self:AddModById(ModId, ModEquip, Level)
			end
			self:ResetCharacterAttr()
		else
			self.NeedInitTalents = true -- 如果此时PlayerCharacter没初始化成功，打个Flag
		end
	else
		DebugPrint("Talent", TalentId, "已存在 请勿重复添加")
	end
end

--function Component:InitRougeMods()
--	if self.NeedInitBlessings then
--		self.PlayerCharacter = UGameplayStatics.GetPlayerCharacter(self, 0)
--		for BlessingId, AwardInfo in pairs(self.Blessings) do
--			local ModEquip = DataMgr.RougeLikeBlessing[BlessingId].ModEquip
--			local ModId = DataMgr.RougeLikeBlessing[BlessingId].BlessingMod
--			DebugPrint("Mod编号", ModId, "Mod装备位置", ModEquip)
--			if ModId and ModEquip then
--				self:AddModById(ModId, ModEquip, AwardInfo.Level-1)
--			end
--			self:AddBlessingGroup(BlessingId, self.PlayerCharacter, true)
--		end
--	end
--	if self.NeedInitTreasures then
--		self.PlayerCharacter = UGameplayStatics.GetPlayerCharacter(self, 0)
--		for TreasureId, AwardInfo in pairs(self.Treasures) do
--			local ModEquip = DataMgr.RougeLikeTreasure[TreasureId].ModEquip
--			local ModId = DataMgr.RougeLikeTreasure[TreasureId].TreasureMod
--			DebugPrint("Mod编号", ModId, "Mod装备位置", ModEquip)
--			if ModId and ModEquip then
--				self:AddModById(ModId, ModEquip, AwardInfo.Level-1)
--			end
--			local ClientBuild = DataMgr.RougeLikeTreasure[TreasureId].ClientBuild
--			if ClientBuild and ClientBuild.GroupDiscount then
--				self.BlessingGroupDiscount = self.BlessingGroupDiscount + ClientBuild.GroupDiscount
--			end
--			self:ReCountBlessingGroup(self.PlayerCharacter, true)
--		end
--	end
--	if self.NeedInitTalents then
--		self.PlayerCharacter = UGameplayStatics.GetPlayerCharacter(self, 0)
--		for TalentId, Level in pairs(self.Talents) do
--			local ModId=DataMgr.RougeLikeTalent[TalentId].TalentMod
--			local ModEquip=DataMgr.RougeLikeTalent[TalentId].ModEquip
--			DebugPrint("Mod编号", ModId, "Mod装备位置", ModEquip)
--			if ModId and ModEquip then
--				self:AddModById(ModId, ModEquip, Level-1)
--			end
--			self:ResetCharacterAttr()
--		end
--	end
--end

function Component:AddModById(ModId, ModEquip, Level)
	local IsRangedUltra
	local IsMeleeUltra
	if ModEquip == "RangedWeapon" or ModEquip == "MeleeWeapon" then
		if self.PlayerCharacter.UltraWeapon then
			local WeaponId = self.PlayerCharacter.UltraWeapon.WeaponId
			local WeaponTags = DataMgr.BattleWeapon[WeaponId].WeaponTag
			if (CommonUtils.HasValue(WeaponTags, "Ranged")) then
				IsRangedUltra = true
			end
			if (CommonUtils.HasValue(WeaponTags, "Melee")) then
				IsMeleeUltra = true
			end
		end
	end
	if ModEquip == "Role" then
		self.PlayerCharacter:SetAttrByMod(ModId, Level)
	elseif ModEquip == "RangedWeapon" and self.PlayerCharacter.RangedWeapon then
		self.PlayerCharacter.RangedWeapon:SetAttrByMod(ModId, Level)
		if IsRangedUltra then
			self.PlayerCharacter.UltraWeapon:SetAttrByMod(ModId, Level)
		end
	elseif ModEquip == "MeleeWeapon" and self.PlayerCharacter.MeleeWeapon then
		self.PlayerCharacter.MeleeWeapon:SetAttrByMod(ModId, Level)
		if IsMeleeUltra then
			self.PlayerCharacter.UltraWeapon:SetAttrByMod(ModId, Level)
		end
	end
	self:AddPassiveEffectById(ModId, ModEquip,Level)
end

function Component:AddPassiveEffectById(ModId, ModEquip,Level)
	if not ModId then
		return
	end
	local IsRangedUltra
	local IsMeleeUltra
	if ModEquip == "RangedWeapon" or ModEquip == "MeleeWeapon" then
		if self.PlayerCharacter.UltraWeapon then
			local WeaponId = self.PlayerCharacter.UltraWeapon.WeaponId
			local WeaponTags = DataMgr.BattleWeapon[WeaponId].WeaponTag
			if (CommonUtils.HasValue(WeaponTags, "Ranged")) then
				IsRangedUltra = true
			end
			if (CommonUtils.HasValue(WeaponTags, "Melee")) then
				IsMeleeUltra = true
			end
		end
	end
	local ModData = DataMgr.Mod[ModId]
	local PassiveEffects = ModData.PassiveEffects
	if PassiveEffects then
		for _, PassiveEffectId in pairs(PassiveEffects) do
			if ModEquip == "Role" then
				self.PlayerCharacter:AddPassiveEffectByRole(self.PlayerCharacter.CurrentRoleId, PassiveEffectId, Level)
				if self.PlayerCharacter.ModPassives then
					local IsExist = false
					for _, PassiveInfo in ipairs(self.PlayerCharacter.ModPassives) do
						if PassiveInfo[1] == PassiveEffectId then
							IsExist = true
							break
						end
					end
					if not IsExist then
						local SummonInherit = ModData.SummonInherit
						table.insert(self.PlayerCharacter.ModPassives, {PassiveEffectId, Level, SummonInherit})
					end
				end
			elseif ModEquip == "RangedWeapon" and self.PlayerCharacter.RangedWeapon then
				self.PlayerCharacter:AddPassiveEffectByWeapon(self.PlayerCharacter.RangedWeapon, PassiveEffectId, Level)
				if IsRangedUltra then
					self.PlayerCharacter:AddPassiveEffectByWeapon(self.PlayerCharacter.UltraWeapon, PassiveEffectId, Level)
				end
			elseif ModEquip == "MeleeWeapon" and self.PlayerCharacter.MeleeWeapon then
				self.PlayerCharacter:AddPassiveEffectByWeapon(self.PlayerCharacter.MeleeWeapon, PassiveEffectId, Level)
				if IsMeleeUltra then
					self.PlayerCharacter:AddPassiveEffectByWeapon(self.PlayerCharacter.UltraWeapon, PassiveEffectId, Level)
				end
			end
		end
	end
end	

function Component:RemovePassiveEffectById(ModId)
	if not ModId then
		return
	end
	local ModData = DataMgr.Mod[ModId]
	local PassiveEffects = ModData.PassiveEffects
	if PassiveEffects then
		for _, PassiveEffectId in pairs(PassiveEffects) do
			self.PlayerCharacter:RemovePassiveEffectByEffectId(PassiveEffectId)
		end
	end
end

-- 升级对应的Mod/如果不传UpgradeLevel,可作为移除Mod使用
function Component:UpgradeModById(AwardType,AwardId,CurrentLevel,UpgradeLevel)
	local ModId=nil
	local ModEquip=nil
	self.PlayerCharacter = UGameplayStatics.GetPlayerCharacter(self, 0)
	assert(self.PlayerCharacter.InitSuccess, "PlayerCharacter还未初始化成功，无法对刻印进行升级")
	AwardId=tonumber(AwardId)
	if AwardType=="Blessing" then
		ModId=DataMgr.RougeLikeBlessing[AwardId].BlessingMod
		ModEquip=DataMgr.RougeLikeBlessing[AwardId].ModEquip
	elseif AwardType=="Treasure" then
	 	ModEquip = DataMgr.RougeLikeTreasure[AwardId].ModEquip
	 	ModId = DataMgr.RougeLikeTreasure[AwardId].TreasureMod
	elseif AwardType == "Talent" then
		ModId=DataMgr.RougeLikeTalent[AwardId].TalentMod
		ModEquip=DataMgr.RougeLikeTalent[AwardId].ModEquip
	end


	local IsRangedUltra
	local IsMeleeUltra
	if ModEquip == "RangedWeapon" or ModEquip == "MeleeWeapon" then
		if self.PlayerCharacter.UltraWeapon then
			local WeaponId = self.PlayerCharacter.UltraWeapon.WeaponId
			local WeaponTags = DataMgr.BattleWeapon[WeaponId].WeaponTag
			if (CommonUtils.HasValue(WeaponTags, "Ranged")) then
				IsRangedUltra = true
			end
			if (CommonUtils.HasValue(WeaponTags, "Melee")) then
				IsMeleeUltra = true
			end
		end
	end
	
	if ModEquip == "Role" then
		self.PlayerCharacter:SetAttrByMod(ModId,CurrentLevel,true)
		if UpgradeLevel then
			self.PlayerCharacter:SetAttrByMod(ModId,UpgradeLevel)
		end
	elseif ModEquip == "RangedWeapon" and self.PlayerCharacter.RangedWeapon then
		self.PlayerCharacter.RangedWeapon:SetAttrByMod(ModId,CurrentLevel,true)
		if UpgradeLevel then
			self.PlayerCharacter.RangedWeapon:SetAttrByMod(ModId,UpgradeLevel)
		end
		if IsRangedUltra then
			self.PlayerCharacter.UltraWeapon:SetAttrByMod(ModId, CurrentLevel, true)
			if UpgradeLevel then
				self.PlayerCharacter.UltraWeapon:SetAttrByMod(ModId, UpgradeLevel)
			end
		end
	elseif ModEquip == "MeleeWeapon" and self.PlayerCharacter.MeleeWeapon then
		self.PlayerCharacter.MeleeWeapon:SetAttrByMod(ModId,CurrentLevel,true)
		if UpgradeLevel then
			self.PlayerCharacter.MeleeWeapon:SetAttrByMod(ModId,UpgradeLevel)
		end
		if IsMeleeUltra then
			self.PlayerCharacter.UltraWeapon:SetAttrByMod(ModId, CurrentLevel, true)
			if UpgradeLevel then
				self.PlayerCharacter.UltraWeapon:SetAttrByMod(ModId, UpgradeLevel)
			end
		end
	end
	self:RemovePassiveEffectById(ModId)
	if UpgradeLevel then
		self:AddPassiveEffectById(ModId, ModEquip, UpgradeLevel)
	end
end


function Component:ShowTokenTips(Count)
	self:AddTimer(0.1, function()
		DebugPrint("代币数量", Count)
		local Avatar = GWorld:GetAvatar()
		local TokenId = Avatar and Avatar:GetCurrentRougeLikeTokenId()
		local RewardInfo = DataMgr.Resource[TokenId]
		self.RewardList = {
			{
				ItemId = TokenId,
				ItemType = "Resource",
				Count = Count,
				Rarity = RewardInfo.Rarity,
			}
		}
		UIUtils.ShowHudReward(GText("RL_GetToken"), self.RewardList)
	end, nil, nil, nil, false)
end

function Component:ResetCharacterAttr()
	-- 天赋不走mod初始化流程，需要重新设置一次
	self.PlayerCharacter:SetAttr("InitSp", self.PlayerCharacter:GetAttr("MaxSp"))
	local Info = self.PlayerCharacter.InfoForInit
	if Info.PlayerHp then
		self.PlayerCharacter:SetAttr("Hp", math.min(Info.PlayerHp, self.PlayerCharacter:GetAttr("MaxHp")))
	else
		self.PlayerCharacter:SetAttr("Hp", self.PlayerCharacter:GetAttr("MaxHp"))
	end
	if Info.PlayerEs then
		self.PlayerCharacter:SetAttr("ES", math.min(Info.PlayerEs, self.PlayerCharacter:GetAttr("MaxES")))
	else
		self.PlayerCharacter:SetAttr("ES", self.PlayerCharacter:GetAttr("MaxES"))
	end
	if Info.PlayerSp then
		self.PlayerCharacter:SetAttr("Sp", math.min(Info.PlayerSp, self.PlayerCharacter:GetAttr("InitSp")))
	else
		self.PlayerCharacter:SetAttr("Sp", self.PlayerCharacter:GetAttr("InitSp"))

	end
end

function Component:PrintUpdateInfo(UpdateInfo)
	-- 打印每次UpdateInfo,便于调试
	local Type = UpdateInfo.Type
	local Event = UpdateInfo.Event
	DebugPrint("@zyh 本次奖励的UpdateInfo为： Type: ", Type, "Event:", Event)
	PrintTable(UpdateInfo.AwardsId, 4)
end

return Component
