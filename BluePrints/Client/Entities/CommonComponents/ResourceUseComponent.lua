local RewardBox = require "BluePrints.Client.CustomTypes.SimpleRewardBox"
local Component = {}

function Component:EnterWorld()
	self.logger.debug("ZJT_ EnterWorld ResourceUseComponent ")
end

function Component:UseItemInBattle(AvatarEid, ResourceId, Info, Reason)
    -- 战斗自动跑测接口重定向
    if self.IsAutoBattle then
        self:BattleTestUseItemInBattle(AvatarEid, ResourceId, Info, Reason)
        return
    end

    local ResourceInfo = DataMgr.Resource[ResourceId]
    if not ResourceInfo then return end
    local UseEffectType = ResourceInfo.UseEffectType
    local UseBPFunction = ResourceInfo.UseBPFunction
	local UseAddLevelTag = ResourceInfo.UseAddLevelTag
    local PlayAnim = ResourceInfo.PlayAnim
    local PlayArmoryAnim = ResourceInfo.PlayArmoryAnim
    
    local PlayerController = UE4.URuntimeCommonFunctionLibrary.GetPlayerControllerByAvatarEid(GWorld.GameInstance,  CommonUtils.ObjId2Str(AvatarEid))
    if not IsValid(PlayerController) then return end
    local PlayerCharacter = PlayerController:GetMyPawn():Cast(UE4.APlayerCharacter)
    if not IsValid(PlayerCharacter) then return end
    
    if UseEffectType and self["ResourceUseEffect"..UseEffectType] then
        self["ResourceUseEffect"..UseEffectType](self, ResourceInfo, PlayerCharacter, Info, Reason)
    end

    -- 手势动作
    if UseBPFunction or PlayAnim or PlayArmoryAnim then
        DebugPrint("gmy@Component:UseItemInBattle UseBPFunction", UseBPFunction, self.IsInRegionOnline, self.CurrentOnlineType)
        PlayerCharacter.FlyMount = false
        PlayerCharacter:InvokeResourceBPFunction(ResourceId)
        EventManager:FireEvent(EventID.OnTheaterPerform, ResourceId)
        
        -- 埋点
        local TrackInfo = {}
        TrackInfo.char_id = self:GetCurrentCharConfigID() or 0
        TrackInfo.map_id = WorldTravelSubsystem():GetCurrentSceneId() or 0
        TrackInfo.sub_region_id = self.CurrentRegionId or 0
        TrackInfo.resource_id = ResourceId or 0
        HeroUSDKSubsystem():UploadTrackLog_Lua("gesture_use", TrackInfo)

        -- 限定条件，只有区域联机+手势动作的情况下才能发rpc
        if self.IsInRegionOnline and self.CurrentOnlineType then
            self:RequestUseGestureOnline(PlayerCharacter, ResourceId)
        end
    end

    if UseAddLevelTag then
        -- 先限定InfiniteBattleItem类型配置才有效
        if ResourceInfo.Type and ResourceInfo.Type == "InfiniteBattleItem" then
            DebugPrint("gmy@Component:UseItemInBattle  UseAddLevelTag",  UseAddLevelTag)
            PlayerCharacter:AddUseResourceLevelTag(ResourceId)
        end
    end
    
    if not IsDedicatedServer(PlayerCharacter) then
        -- 使用成功音效
        AudioManager(self):PlayUISound(self, "event:/ui/common/combat_bag_hide_use_item", "BattleItemUse", nil)
    end
end

function Component:RequestUseGestureOnline(PlayerCharacter, GestureResourceId)
    DebugPrint("gmy@ResourceUseComponent Component:RequestUseGestureOnline", GestureResourceId)
    local ResourceInfo = DataMgr.Resource[GestureResourceId]
    if not ResourceInfo then return end
    local ResourceIsMountId = self:ResourceIsMount(ResourceInfo)
    if(ResourceIsMountId) then 
        self:SendMountRequest(PlayerCharacter, GestureResourceId, ResourceIsMountId)
    end
    local bIsUpdateState = not ResourceInfo.bIsNoLoopAction
    PlayerCharacter.CurResourceId = GestureResourceId
    self:SwitchOnlineState(self.CurrentOnlineType, CommonConst.OnlineState.UseWheel, {ResourceId = GestureResourceId}, bIsUpdateState)
end
function Component:SendMountRequest(PlayerCharacter, GestureResourceId, ResourceIsMountId)
    if PlayerCharacter.CurrentMountId ~= 0 and  PlayerCharacter:IsInRideMove() then 
        self:RequestUseCreateMount(self.CurrentOnlineType,GestureResourceId, ResourceIsMountId, 0)
    elseif(PlayerCharacter.CurrentMountId ~= 0 and  not PlayerCharacter:IsInRideMove()) then 
        self:RequestDeadRegionOnlineMount(self.CurrentOnlineType, 0)
    else
        self:RequestDeadRegionOnlineMount(self.CurrentOnlineType, 0)
    end
end
function Component:ResourceIsMount(ResourceInfo)
    if(not ResourceInfo) then 
        return nil
    end
    if not ResourceInfo.UseBPFunction then 
        return nil
    end
    if ResourceInfo.UseBPFunction ~= "MountOn" then 
        return nil
    end
    if not ResourceInfo.FunctionVars then 
        return nil
    end
    if not ResourceInfo.FunctionVars.Id then 
        return nil
    end
    return ResourceInfo.FunctionVars.Id
end

function Component:RequestCancelGestureOnline(PlayerCharacter)
    DebugPrint("gmy@ResourceUseComponent Component:RequestCancelGestureOnline")
    PlayerCharacter.CurResourceId = 0
    self:SwitchOnlineState(self.CurrentOnlineType, CommonConst.OnlineState.UseWheel, {ResourceId = 0})
end

function Component:BattleTestUseItemInBattle(AvatarEid, ResourceId, Info, Reason)
    print(_G.LogTag, "BattleTestUseItemInBattle", ResourceId, Reason)
    self.AutoTestRobotInfo = self.AutoTestRobotInfo  or {}
    table.insert(self.AutoTestRobotInfo,Info.RoleInfo.RoleId)
    local ResourceInfo = DataMgr.Resource[ResourceId]
    if not ResourceInfo then return end
    local UseEffectType = ResourceInfo.UseEffectType
    local UseBPFunction = ResourceInfo.UseBPFunction

    if UseEffectType or UseBPFunction then
        local PlayerCharacter = self.Player

        if UseEffectType and self["ResourceUseEffect"..UseEffectType] then
            self["ResourceUseEffect"..UseEffectType](self, ResourceInfo, PlayerCharacter, Info, Reason)
        end

        if UseBPFunction then
            DebugPrint("gmy@Component:UseItemInBattle UseBPFunction", UseBPFunction)
            PlayerCharacter.FlyMount = false
            PlayerCharacter:InvokeResourceBPFunction(ResourceId)
        end
    end
end

function Component:ResourceUseEffectAddHPValue(ResourceInfo, PlayerCharacter, Info, Reason)
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    if not GameMode then return end
    local Drops = {}
    local DropCountTable = {}
    local NormalTag = RewardBox:GetTag("Normal")
    DropCountTable[tostring(NormalTag)] = ResourceInfo.UseParam
    Drops[CommonConst.ResourceUseEffectDrop[ResourceInfo.UseEffectType]] = DropCountTable
    local LocTransform = PlayerCharacter:GetTransform()
    GameMode:HandleRewardDrop(Drops, Reason, LocTransform, nil, nil)
end


function Component:ResourceUseEffectAddAmmo(ResourceInfo, PlayerCharacter, Info, Reason)
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    if not GameMode then return end
    local Drops = {}
    local DropCountTable = {}
    local NormalTag = RewardBox:GetTag("Normal")
    DropCountTable[tostring(NormalTag)] = ResourceInfo.UseParam
    Drops[CommonConst.ResourceUseEffectDrop[ResourceInfo.UseEffectType]] = DropCountTable
    local LocTransform = PlayerCharacter:GetTransform()
    GameMode:HandleRewardDrop(Drops, Reason, LocTransform, nil, nil)
end

function Component:ResourceUseEffectAddSPValue(ResourceInfo, PlayerCharacter, Info, Reason)
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    if not GameMode then return end
    local Drops = {}
    local DropCountTable = {}
    local NormalTag = RewardBox:GetTag("Normal")
    DropCountTable[tostring(NormalTag)] = ResourceInfo.UseParam
    Drops[CommonConst.ResourceUseEffectDrop[ResourceInfo.UseEffectType]] = DropCountTable
    local LocTransform = PlayerCharacter:GetTransform()
    GameMode:HandleRewardDrop(Drops, Reason, LocTransform, nil, nil)
end

function Component:ResourceUseEffectCallPhantom(ResourceInfo, PlayerCharacter, Info, Reason)
    PrintTable({ResourceUseEffectCallPhantom = Info, Reason = Reason},4)
    -- Info = {RoleInfo = Info}
    PlayerCharacter:CreatePhantom(ResourceInfo.UseParam, 1, Info, {IsSpawnByResource=1})
end

-- 回收召唤出来的全部魅影
function Component:ResourceUseEffectCancelPhantom(ResourceInfo, PlayerCharacter, Info, Reason)
    PrintTable({ResourceUseEffectCallPhantom = Info, Reason = Reason},4)
    -- Info = {RoleInfo = Info}
    UE4.UPhantomFunctionLibrary.CancelAllPhantom(PlayerCharacter, EDestroyReason.PhantomUseResource)
end

function Component:ResourceUseEffectUseBattleProp(ResourceInfo, PlayerCharacter, Info, Reason)
    DebugPrint("gmy@ResourceUseComponent Component:ResourceUseEffectUseBattleProp", ResourceInfo, PlayerCharacter, Info, Reason, ResourceInfo and ResourceInfo.UseParam)

    if PlayerCharacter then
        PlayerCharacter:ResourceUseBattleProp(ResourceInfo.UseParam)
    end
end

function Component:ResourceUseEffectCreateMechanism(ResourceInfo, PlayerCharacter, Info, Reason)
    print(_G.LogTag,"LXZ ResourceUseEffectCreateMechanism", ResourceInfo.UseParam)
    if not self.IsInRegionOnline or not self.CurrentOnlineType then
        return
    end
    if not ResourceInfo.UseParam then
        return
    end
    local MechanismData = DataMgr.Mechanism[ResourceInfo.UseParam]
    if not MechanismData then
        return
    end
    local Start = PlayerCharacter:K2_GetActorLocation()
    local HitResult = FHitResult()
    if MechanismData.UnitParams and MechanismData.UnitParams.InterPoint then
        for i, v in pairs(MechanismData.UnitParams.InterPoint) do
            local End = FVector(v[1], v[2], v[3])
            local bHit = UE4.UKismetSystemLibrary.LineTraceSingle(self,Start,End,ETraceTypeQuery.TraceScene,false,nil,2,HitResult,false)
            if bHit then
                return
            end
        end
    end
    local InteractiveIdList = {}
    if ResourceInfo.InteractPlayerNum then
        for i = 0, ResourceInfo.InteractPlayerNum - 1 do
            table.insert(InteractiveIdList, i)
        end
    end
    self:UseCreateMechanism(self.CurrentOnlineType, ResourceInfo.ResourceId, ResourceInfo.UseParam, InteractiveIdList)
end

-- 用来设置创建盗宝怪
function Component:DSSetRefreshRobberMonster(NewValue)
    self.logger.debug("ZJT_ DSSetRefreshRobberMonster ", NewValue)
    self:Multicast("SetRefreshRobberMonster", NewValue)
end


function Component:UseHeadResource(CharUuid, AppearanceIndex, AccessoryId)
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	if(not PlayerCharacter) then 
		return
	end

	if(not PlayerCharacter.CharacterFashion) then 
		return 
	end
	local CharFashion = PlayerCharacter.CharacterFashion
    if not CharFashion.Type2Id then 
        self.logger.debug("Player Not Init Yet")
        return 
    end
    if(not DataMgr.CharAccessory) then 
        self.logger.error("DataMgr.CharAccessory Not Init Yet")
        return
    end
    if(not DataMgr.CharAccessory[AccessoryId]) then 
        self.logger.error("Doesn't has this AccessoryId" , AccessoryId)
        return
    end
    local AccessoryType = DataMgr.CharAccessory[AccessoryId].AccessoryType
	-- if CharFashion then
	CharFashion:ChangeAccessory(AccessoryId, AccessoryType)
end

function Component:ResourceUseEffectUseAFDGesture(ResourceInfo, PlayerCharacter, Info, Reason)
    DebugPrint("gmy@ResourceUseComponent Component:ResourceUseEffectUseAFDGesture", ResourceInfo, PlayerCharacter, Info, Reason, ResourceInfo and ResourceInfo.UseParam)

    -- TODO: 随机出TransformAFDayEvent中的ID
    UIManager():LoadUINew("AprilFoolDayRandomTrans")
end

return Component