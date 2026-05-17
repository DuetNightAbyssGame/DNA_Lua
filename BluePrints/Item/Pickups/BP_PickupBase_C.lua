require "UnLua"
local UIUtils = require "Utils.UIUtils"
local CommonConst = require "CommonConst"
local PickupUseComponent = require "BluePrints.Item.Pickups.PickupUseComponent"
---@type BP_PickupBase_C
local BP_PickupBase_C = Class( {"BluePrints.Item.SceneItemBase"} )

function BP_PickupBase_C:AuthorityInitInfo(Info)
	self.MoveSpeed = 3000
	-- if Const.UseNewCreateUnit then
    --     return
    -- end
	-- BP_PickupBase_C.Super.AuthorityInitInfo(self,Info)
	-- if Info.ItemLevelId then
	-- 	self:SetLevelId(Info.ItemLevelId)
	-- end
	-- self:AuthorityInitInfoCpp(Info.Eid)
	-- self:SetExtra(Info.bExtra)
end
--客户端生成走的初始化流程
function BP_PickupBase_C:ClientCreateInitInfo(Info)
	-- if Const.UseNewCreateUnit then
    --     return
    -- end
	-- self:SetLevelId(Info.ItemLevelId)
	-- self.Data = DataMgr[Info.UnitType][Info.UnitId]
	-- self:ClientInitInfo(Info)
	-- self:RegisterPickupToGameState()
	-- self:SetExtra(Info.bExtra)
	-- self.InitSuccess = true
	-- self.IsPickupBase = true
	-- self:CommonInitInfo_Cpp()
end

function BP_PickupBase_C:CreateRegionData()
	local Location=self:K2_GetActorLocation()
	local Rotation=self:K2_GetActorRotation()
	self.RegionData = {
        Location = {
			[1] = Location.X,
			[2] = Location.Y,
			[3] = Location.Z
		},
        Rotation = {
			[1] = Rotation.Pitch,
			[2] = Rotation.Yaw,
			[3] = Rotation.Roll
		}
    }
end

function BP_PickupBase_C:GetRarity()
	return self.Rarity
end

function BP_PickupBase_C:CheckUnitNeedStorage()
	return self.RegionDataType ~= ERegionDataType.RDT_None
end

function BP_PickupBase_C:CheckRarity(TargetRarity)
	TargetRarity = TargetRarity or 3
	return self.Data.Rarity >= TargetRarity
end

function BP_PickupBase_C:ClientInitInfo(Info)
	self.MoveSpeed = 3000
	-- if Const.UseNewCreateUnit then
    --     return
    -- end
    -- BP_PickupBase_C.Super.ClientInitInfo(self,Info)
	-- self.ProjectFlyOverForce = 5000
	-- if not URuntimeCommonFunctionLibrary.UseCppRegionData(self) then
	-- 	if IsClient(self) then
	-- 		self.Eid = Info.Eid or self.Eid -- 初始化Eid--客户端掉落会有eid，DS掉落则不会有，靠属性同步
	-- 	end
	-- end
	-- self:InitEffectColor()
	-- self:ClientCreateInitInfoCpp(Info.UnitId, Info.ReasonType, Info.SourceEid)
	-- if self.IsFromSnapShot then
	-- 	self.LaunchDirection=FVector(0,0,0)
	-- end
	-- -- 获取Audio稀有度
	-- self:GetAudioRarity()
	-- if self.BProjectile then
	-- 	-- 掉落物飞出的声音
	-- 	AudioManager(self):PlayDropProjectileSe(self, self.AudioRarity)
	-- 	self.bNoProjectileMode = UUIFunctionLibrary.GetDevicePlatformName(self) == "Android"
	-- 	self:ChangeState(EPickupProjectileState.Projectile)
	-- elseif self.BUseGravityWhenNoProjectile then
	-- 	self:ChangeState(EPickupProjectileState.Falling)
	-- else
	-- 	self:ChangeState(EPickupProjectileState.Idle)
	-- end
	-- if self.Data.GuideIconBPPath ~= nil then		
	-- 	-- self:CheckIsNeedShowGuide()
	-- 	-- self:AddTimer(0.5, self.CheckIsNeedShowGuide, true,0,"CheckIsNeedShowGuide")
	-- 	self:InitShowGuideTimer()
	-- end
end

function BP_PickupBase_C:CheckIsNeedShowGuideCallback(IsShowInMinimap, IsAllConditionAchieve)
	DebugPrint("BP_PickupBase_C:CheckIsNeedShowGuideCallback IsShowInMinimap", IsShowInMinimap, "IsAllConditionAchieve", IsAllConditionAchieve)
	local ItemInfo = self.Data
	if ItemInfo == nil then
		if IsValid(self.GuideIconComponent) then
			if self.GuideIconComponent:GetWidget() then
				self.GuideIconComponent:SetWidgetHiddenByTag(true, "Pickup")
			end
			self.GuideIconComponent:SetHiddenInGame(true)
		end
		DebugPrint("BP_PickupBase_C:iteminfo nil")
		return
	end
	if IsAllConditionAchieve then
		if IsShowInMinimap then
			EventManager:FireEvent(EventID.ShowDropInMinimap, self, true)
			if IsValid(self.GuideIconComponent) then
				if self.GuideIconComponent:GetWidget() then
					self.GuideIconComponent:SetWidgetHiddenByTag(true, "Pickup")
				end
				self.GuideIconComponent:SetHiddenInGame(true)
			end
		else 
			if not IsValid(self.GuideIconComponent) then
				self:CreateAndAddGuideIconComponent()
			end
			local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)	
			self.GuideIconComponent:InitGuide(self, self.ToCharacter or PlayerCharacter, ItemInfo.GuideIconBPPath, self.GuideIconOffsetZ)
			if self.GuideIconComponent:GetWidget() then
				self.GuideIconComponent:SetWidgetHiddenByTag(false, "Pickup")
			end
			self.GuideIconComponent:SetHiddenInGame(false)
		end
	else
		if IsShowInMinimap then
			EventManager:FireEvent(EventID.ShowDropInMinimap, self, false)
			if IsValid(self.GuideIconComponent) then
				if self.GuideIconComponent:GetWidget() then
					self.GuideIconComponent:SetWidgetHiddenByTag(true, "Pickup")
				end
				self.GuideIconComponent:SetHiddenInGame(true)
			end
		else 
			if IsValid(self.GuideIconComponent) then
				if self.GuideIconComponent:GetWidget() then
					self.GuideIconComponent:SetWidgetHiddenByTag(true, "Pickup")
				end
				self.GuideIconComponent:SetHiddenInGame(true)
			end
		end
	end
	return IsAllConditionAchieve
end

-- function BP_PickupBase_C:ClearGuideIconComponent()
-- 	if IsValid(self.GuideIconComponent) then
-- 		self.GuideIconComponent:ClearComponent()
-- 		self:RemoveTimer("CheckIsNeedShowGuide")
-- 	end
-- 	EventManager:FireEvent(EventID.ShowDropInMinimap,self,false)
-- end

-- function BP_PickupBase_C:CanBePickedUpForFunc(Character, InUseEffectType)
-- 	if PickupUseComponent.CanBePickedUpFuncMap[InUseEffectType] == nil and InUseEffectType ~= "None" then
-- 		return false
-- 	elseif self.UseEffectType == "None" then
-- 		return true
-- 	else
-- 		return PickupUseComponent.CanBePickedUpFuncMap[InUseEffectType](PickupUseComponent, Character, self)
-- 	end
-- end

-- function BP_PickupBase_C:InitActorInfo(Info)
--     BP_PickupBase_C.Super.InitActorInfo(self,Info)
-- end

function BP_PickupBase_C:OnActorReady(Info)
	BP_PickupBase_C.Super.OnActorReady(self, Info)
	if PickupUseComponent.PostInitFuncMap[self.UseEffectType] ~= nil then
		PickupUseComponent.PostInitFuncMap[self.UseEffectType](PickupUseComponent, self)
	end
	local AttachActor = Info:FindObjectParams("AttachActor")
	if AttachActor then
		self:K2_AttachToActor(AttachActor, "", UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.SnapToTarget)
	end
end
--这里是调用 恢复效果函数在拾取的时候进行
-- function BP_PickupBase_C:GivePickupTo(Character)
-- 	if PickupUseComponent.UseEffectTypeFuncMap[self.UseEffectType] ~= nil then
-- 		PickupUseComponent.UseEffectTypeFuncMap[self.UseEffectType](PickupUseComponent, Character, self)
-- 	end
-- 	if self.IsShowJumping then
-- 		self.ToCharacter:PlayDrop_InCharacter(self)
-- 	end
-- 	self.ToCharacter = nil
-- end

-- 掉落物被拾取后的表现
function BP_PickupBase_C:OnPickedUp(Character)
	self:InvokeSource()
	self:OnClientPickUp(Character)
end
function BP_PickupBase_C:OnClientPickUp(Character)
    if IsDedicatedServer(self) then return end
	local DropData = self.Data
	if Character:IsMainPlayer() then
		local NumFunc = PickupUseComponent.ClientGetItemCountFuncMap[DropData.UseEffectType]
		local Avatar = GWorld:GetAvatar()
		if(Avatar) then 
			local Rewards = {[self.UnitId]= (NumFunc and NumFunc(self.UnitId) or 1)}
			Avatar:ShowRewardUI(Rewards, "Drop")
		else
			UIUtils.ShowGotItemTipsUI("Drop", self.ItemId, NumFunc and NumFunc(self.UnitId) or nil)
		end
		-- 掉落物拾取的声音,只在玩家自己的客户端运行
		local PickUpSeId = DataMgr.Drop[self.UnitId] and DataMgr.Drop[self.UnitId].PickUpAudioPath
		if PickUpSeId then
			AudioManager(self):PlaySeById(self, PickUpSeId)
		else
			AudioManager(self):PlayDropPickupSe(self, self.AudioRarity)
		end
	end
end

function BP_PickupBase_C:OnRep_ServerInitSuccess()
    -- if self.ServerInitSuccess and not self.InitSuccess then
		-- self:K2_SetActorLocation(self.ServerInitLocation,false,nil,false)
    -- end
	-- BP_PickupBase_C.Super.OnRep_ServerInitSuccess(self)
	if not self.ServerInitSuccess then
		self.InitSuccess=false
	end
end

function BP_PickupBase_C:OnRep_ServerInitCount()
	self.InitSuccess=false
	self:K2_SetActorLocation(self.ServerInitLocation,false,nil,false)
	self.InfoForInitNew.UnitId = self.UnitId
	self.InfoForInitNew.UnitType = self.UnitType
    self:TryInitActorInfo("InitInfo")
end

-- 因为超出最大掉落数量而被销毁时调用
function BP_PickupBase_C:DestroyByExceedMaxDropNum()
	if PickupUseComponent.ExceedMaxDropNumFuncMap[self.UseEffectType] ~= nil then
		PickupUseComponent.ExceedMaxDropNumFuncMap[self.UseEffectType](PickupUseComponent, self)
	end
end

function BP_PickupBase_C:SetLifeTime(LifeTime, Reason)
    DebugPrint("THY_ 当前死亡的机关名称为： ", self:GetName(), self.UnitType, LifeTime, Reason, self.IsCache)
    if self.IsCache then return end
    local function TryDestroy()
        self:EMActorDestroy(Reason)
    end
    self:AddTimer(LifeTime, TryDestroy, false)
end

function BP_PickupBase_C:TriggerFallingCallable()
    DebugPrint("OtherActor is Falling Dead. ActorName: ", self:GetName(), ", UnitId: ", self.UnitId, ", Eid: ", self.Eid, ", CreatorId: ", self.CreatorId, " CreatorType: ", self.CreatorType, ", BornPos: ", self.BornPos)
    self:SetLifeTime(1.0, EDeathReason.TriggerFalling)
end

function BP_PickupBase_C:TriggerWaterFallingCallable()
    self:TriggerFallingCallable()
end

function BP_PickupBase_C:GetItemId()
	return self.UnitId
end

function BP_PickupBase_C:InvokeSource_lua()
	print(_G.LogTag,"LXZ InvokeSource_lua", self.SourceEid)
	if not self.SourceEid then
		return
	end
	EventManager:FireEvent(EventID.OnItemPickedUp,self.SourceEid)
end


function BP_PickupBase_C:RedirectRarity()
	local HandleEffectTypeFunctionName = "Handle"..self.UseEffectType
	if self[HandleEffectTypeFunctionName] then
		self[HandleEffectTypeFunctionName](self)
	end
end

function BP_PickupBase_C:HandleGetResource()
	self.Rarity = DataMgr.Resource[self.UseParam].Rarity
end

function BP_PickupBase_C:HandleGetMod()
	self.Rarity = DataMgr.Mod[self.UseParam].Rarity
end

-- 已移到c++
-- function BP_PickupBase_C:SnapShotInitInfo(Info)
-- 	BP_PickupBase_C.Super.SnapShotInitInfo(self,Info)
-- 	if Info.LevelName == nil then
-- 		return
-- 	end
-- 	self.IsFromSnapShot = true
-- end

function BP_PickupBase_C:AddPickupBaseToCache_Lua()--TODO,后续考虑加入ondestroy
	-- self.SubRegionId=nil
	-- self:ClearGuideIconComponent()
end

-- function BP_PickupBase_C:InitEffectColor()
-- 	self.Rarity2Color={}
-- 	self.Rarity2Color[2]=self.NS_Item_Base_Chara_Green
-- 	self.Rarity2Color[3]=self.NS_Item_Base_Chara_Blue
-- 	self.Rarity2Color[4]=self.NS_Item_Base_Chara_Pro
-- 	self.Rarity2Color[5]=self.NS_Item_Base_Fly_Ultra
-- end

-- function BP_PickupBase_C:GetEffectColor()
-- 	return self.Rarity2Color[self.Rarity]
-- end

function BP_PickupBase_C:OnEMActorDestroy(DestroyReason)
	BP_PickupBase_C.Super.OnEMActorDestroy(self,DestroyReason)
	if DestroyReason~=EDestroyReason.Pickup then
		return
	end
	EventManager:RemoveEvent(EventID.OnPlayerGetResource, self)
	if self.UseEffectType=="GetResource" or self.UseEffectType=="GetMod" or self.UseEffectType=="GetWeapon" then--需要服务器获得回调
		return
	end
	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	if not GameMode then return end
	local CallbackMap = GameMode.PickUpSuccessCallback
	if CallbackMap and CallbackMap[self.UnitId] then
		local CopyTable = CommonUtils.DeepCopy(CallbackMap[self.UnitId])
		for _,Callback in pairs(CopyTable) do
			Callback()
		end
	end
end

function BP_PickupBase_C:WaitForGetResourece()
	EventManager:AddEvent(EventID.OnPlayerGetResource, self, self.OnPlayerGetResource)
end

function BP_PickupBase_C:OnPlayerGetResource(ResourceId, ExtraInfo)
	if ResourceId == self.UseParam and ExtraInfo and ExtraInfo.WorldRegionEid == self.WorldRegionEid then
		DebugPrint('Pickup OnPlayerGetResource:',self:GetName(), self.UnitId, self.CreatorId, self.WorldRegionEid)
		self:AfterPick()
		EventManager:RemoveEvent(EventID.OnPlayerGetResource, self)
	end
end

function BP_PickupBase_C:ReceiveEndPlay()
	BP_PickupBase_C.Super.ReceiveEndPlay(self)
	EventManager:RemoveEvent(EventID.OnPlayerGetResource, self)
end

function BP_PickupBase_C:WCOnEMActorDestroy(DestroyReason, GameMode)
    local WCSubSystem = GameMode:GetWCSubSystem()
    if not IsValid(WCSubSystem) then 
        return 
    end

    -- if GameMode:IsInRegion() then 
    	if self.BpBorn and (not self:CheckManuItemRegionStorage() or DestroyReason == EDestroyReason.RecoverSubRegionDataCacheButBpBornHasAlreadyDead) then
    		return
    	end
        -- NewRegionEnable
    	if self.WorldRegionEid == "" then
    		if self.Data then
    			GWorld.logger.errorlog("Error : Actor在Destroy时没有赋值WorldRegionEid", self.UnitId, self.UnitType, self.Eid)
    		end
    	else
			if not WCSubSystem.IsInDungeon and self.UseEffectType == "GetResource" then
				local Avatar = GWorld:GetAvatar()
				if Avatar then
					Avatar:RegionActorDead(self, DestroyReason, self.SubRegionId, self.LevelName, true)
				end
			else
				GameMode:GetRegionDataMgrSubSystem():DeadRegionActorData(self, DestroyReason)
			end
    	end
    -- end
    
    WCSubSystem:UnregisterEntryToWorldComposition(self)
end

return BP_PickupBase_C
