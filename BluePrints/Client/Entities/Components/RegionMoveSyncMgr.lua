local Decorator = require "BluePrints.Client.Wrapper.Decorator"

local Component = {}
local LuaConst = require("EMLuaConst")


function Component:InitMoveSyncMgr()
    self.OtherRoleInfo = {}

end

-- function Component:AddRoleToCreate(ObjId, RoleInfo)
--     if LuaConst.RegionSyncSubsysEnable then 
--         self:RegionSyncAddRoleToCreate(ObjId, RoleInfo)
--         return
--     end
-- end

-- function Component:RemoveRoleInfoAndDestroy(ObjId, RoleInfo)
--     if LuaConst.RegionSyncSubsysEnable then 
--         self:RegionSyncRemoveRoleAndDestroy(ObjId, RoleInfo)
--         return
--     end
-- end

function Component:DestoryAllOthers()
    if not self.OtherRoleInfo then
        return
    end
    for k, v in pairs(self.OtherRoleInfo) do
		self:RegionSyncRemoveRoleAndDestroy(v.ObjectId, v)
	end
    self.OtherRoleInfo = {}
end

function Component:NotifyCharacterStartSync(RegionOnlineId)
    local GameInstance = GWorld.GameInstance
	--local PlayerController = UE4.UGameplayStatics.GetPlayerController(GameInstance, 0)
    local RegionSycnSubsys = UE4.URegionSyncSubsystem.GetInstance(GameInstance)
    if RegionSycnSubsys then
        RegionSycnSubsys.RegionOnlineId = RegionOnlineId
        RegionSycnSubsys:ClearAllRoleBornInfo()
    end
    NPCCreateSubSystem(GameInstance):SetIsOnlineState(true, RegionOnlineId)
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    if Player then
        Player:EnableRegionSync(true, RegionOnlineId)
    end
    -- Player:RegionBanSkills()
    -- Player:AddForbidTag("Region")
    local OldState = self.IsInRegionOnline
    EventManager:FireEvent(EventID.OnlineRegionChange, OldState, true)
end

function Component:NotifyCharacterEndSync(...)
    local GameInstance = GWorld.GameInstance
    local RegionSycnSubsys = UE4.URegionSyncSubsystem.GetInstance(GameInstance)
    if RegionSycnSubsys then
        RegionSycnSubsys.RegionOnlineId = 0
    end
    NPCCreateSubSystem(GameInstance):SetIsOnlineState(false)
	--local PlayerController = UE4.UGameplayStatics.GetPlayerController(GameInstance, 0)
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    if Player then
        Player:EnableRegionSync(false, 0)
    end
    -- Player:RegionUnBanSkills()
    -- Player:MinusForbidTag("Region")
    local OldState = self.IsInRegionOnline
    EventManager:FireEvent(EventID.OnlineRegionChange, OldState, false)
end

function Component:SendSyncInfo(SyncInfo, ActionBaseInfo)
    -- PrintTable({SendSyncInfo_SyncInfo = SyncInfo}, 3)
    SyncInfo.ActionBaseInfo = ActionBaseInfo
    self:UploadPlayerMessage(self.CurrentOnlineType, SyncInfo) 
end

-- function Component:HandChangeRoleInfo(ObjId, RoleInfo)
--     -- PrintTable({HandChangeRoleInfo_ObjId = ObjId, OtherRoleInfo = RoleInfo}, 3)
--     if LuaConst.RegionSyncSubsysEnable then 
--         self:RegionSyncChangeRoleInfo(ObjId, RoleInfo)
--         return
--     end
-- end

-- function Component:HandleSwitchWeapon(ObjId, Message, Type)
--     if LuaConst.RegionSyncSubsysEnable then 
--         self:RegionSyncChangeWeaponInfo(ObjId, Message, Type)
--         return
--     end
-- end

-- function Component:HandleChangeUsingWeaponType(ObjId, RoleInfo)
--     if LuaConst.RegionSyncSubsysEnable then 
--         self:RegionSyncChangeUsingWeaponType(ObjId, RoleInfo)
--         return
--     end
-- end

-- function Component:HandleMovePack(ObjId, MoveInfo)
--     if LuaConst.RegionSyncSubsysEnable then 
--         self:RegionSyncUpdateMoveInfo(ObjId, MoveInfo)
--         return
--     end
-- end
function Component:HandleActionPack(ObjId, MoveInfo)
    -- if LuaConst.RegionSyncSubsysEnable then 
    local RoleInfo = self:GetRoleInfo(ObjId)
    if RoleInfo and MoveInfo.ActionBaseInfo then
        local CrouchInt = MoveInfo.ActionBaseInfo.IsCrouching
        RoleInfo.IsCrouching = (CrouchInt ~= nil and CrouchInt > 0.1)
        print(_G.LogTag, "RegionPlayerInitInfo Spawn Other Player Character Success",RoleInfo.IsCrouching, CrouchInt)

    end
    local Player = self:GetBornedChar(ObjId)
    if not Player then
        return
    end
    print(_G.LogTag, " HandleActionPack",  "IsCrouching",Player)
    if MoveInfo.ActionBaseInfo then 
        Player:UpdateActionLocAndRot(MoveInfo)
    end
    local IsStateFeature = Player:IsStateFeature(MoveInfo)
    Player:CacheAction("ReceivePrepareInfo_Lua", MoveInfo)
    if Player:CanRegionSyncDoAction_Immeditately() or IsStateFeature then 
        print(_G.LogTag,"[RegionOnline] DoRegionCacheAction DoAction_Immeditately",IsStateFeature, MoveInfo.ClassName)
        Player:DoRegionCacheAction()
    else
        print(_G.LogTag,"[RegionOnline] DoRegionCacheAction CacheAction",MoveInfo.ClassName)    
    end
        -- return
    -- end
end

function Component:HandleHidePack(ObjId, MoveInfo)
    -- if LuaConst.RegionSyncSubsysEnable then
    print(_G.LogTag, "ReceiveHideInfo_LuaHandleHidePack", MoveInfo.ActorVisible) 
    local Player = self:GetBornedChar(ObjId)
    if Player then 
        Player:ReceiveHideInfo_Lua(MoveInfo)
    end
    --     return
    -- end
end
function Component:ReceiveStopActionPack(ObjId, SyncInfo)
    -- if LuaConst.RegionSyncSubsysEnable then
    local RoleInfo = self:GetRoleInfo(ObjId)
    if RoleInfo and SyncInfo.ActionBaseInfo then
        local CrouchInt = SyncInfo.ActionBaseInfo.IsCrouching
        RoleInfo.IsCrouching = (CrouchInt ~= nil and CrouchInt > 0.1)
    end
    local Player = self:GetBornedChar(ObjId)
    if Player then 
        Player:ReceiveStopActionInfo_Lua(SyncInfo)
    end
    --     return
    -- end
end

function Component:RegionSyncSystemValid(ObjId)
    if not ObjId then 
		self.logger.error("[RegionOnline] EnterWorldRole is Illegal ObjectId is nil")
		return false
	end
    local GameInstance   = GWorld.GameInstance
    if not GameInstance then
        self.logger.error("[RegionOnline] Game Not Start Yet, GameInstance is nil")
        return false
    end
    local RegionSycnSubsys = UE4.URegionSyncSubsystem.GetInstance(GameInstance)
    if not RegionSycnSubsys then
        self.logger.error("[RegionOnline] RegionSycnSubsys is nil")
        return false
    end
    return true
end

function Component:RegionSyncAddRoleToCreate(ObjId, RoleInfo)
    DebugPrint("[RegionOnline] RegionSyncAddRoleToCreate", ObjId, RoleInfo)
    if not self:RegionSyncSystemValid(ObjId) then
        return
    end
    local GameInstance = GWorld.GameInstance
    local RegionSycnSubsys = UE4.URegionSyncSubsystem.GetInstance(GameInstance)
    local ObjIdStr = CommonUtils.ObjId2Str(ObjId)
    if not RegionSycnSubsys:CanAddThisRole(ObjIdStr) then
        self.logger.error("[RegionOnline] RegionSycnSubsys:CanAddThisRole is false")
        return
    end
    local Location = Const.ZeroVector
    local Rotation = Const.ZeroRotator
    if(RoleInfo.ActionBaseInfo) and RoleInfo.ActionBaseInfo.Location then 
        Location = FVector(RoleInfo.ActionBaseInfo.Location.X, RoleInfo.ActionBaseInfo.Location.Y, RoleInfo.ActionBaseInfo.Location.Z)
    end
    if(RoleInfo.ActionBaseInfo) and RoleInfo.ActionBaseInfo.Rotation then
        Rotation = FRotator(RoleInfo.ActionBaseInfo.Rotation.Pitch, RoleInfo.ActionBaseInfo.Rotation.Yaw, RoleInfo.ActionBaseInfo.Rotation.Roll)
    end 

    local bIsTeamMember = false
    if TeamController and TeamController:GetModel() then
        local Team = TeamController:GetModel():GetTeam() or {}
        for _,TeamMember in pairs(Team.Members or {}) do
            if TeamMember and TeamMember.Eid == ObjId then
                bIsTeamMember = true
                break
            end
        end
    end

    DebugPrint("[RegionOnline] RegionSyncUpdate AddRoleToCreate At ", ObjId, Location, Rotation)
    RegionSycnSubsys:AddRoleToRegionSys(ObjIdStr, Location, Rotation,bIsTeamMember)
    self.OtherRoleInfo[ObjId] = {}
    local CharInfo = RoleInfo.CharInfo
    local TempRoleInfo = self.OtherRoleInfo[ObjId]
    TempRoleInfo.IsCrouching = false
    if(RoleInfo.ActionBaseInfo) then 
        local CrouchInt = RoleInfo.ActionBaseInfo.IsCrouching
        TempRoleInfo.IsCrouching = (CrouchInt ~= nil and CrouchInt > 0.1)
        print(_G.LogTag, "RegionPlayerInitInfo Spawn Other Player Character Success",TempRoleInfo.IsCrouching, CrouchInt)
        TempRoleInfo.ForceSyncLocation = RoleInfo.ActionBaseInfo.ForceSyncLocation
    end
    TempRoleInfo.FromOtherWorld = true
	TempRoleInfo.ObjectId = ObjId
	TempRoleInfo.RoleId = CharInfo.CharId
    TempRoleInfo.SkinId = CharInfo.SkinId
    TempRoleInfo.HairId = CharInfo.HairId
    TempRoleInfo.Uid = RoleInfo.AvatarInfo.Uid
    TempRoleInfo.AppearanceSuit = {}
    TempRoleInfo.CurrentPet = RoleInfo.CurrentPet
    TempRoleInfo.CurResourceId = RoleInfo.CurResourceId
    TempRoleInfo.CurrentState = RoleInfo.CurrentState
    TempRoleInfo.MountDatas = {}
    local MountData = TempRoleInfo.MountDatas
    MountData.MountId = RoleInfo.MountDatas.MountId
    MountData.MountState = RoleInfo.MountDatas.MountState
    local InResource = TempRoleInfo.CurResourceId and TempRoleInfo.CurResourceId ~= 0
    local InState = TempRoleInfo.CurrentState and TempRoleInfo.CurrentState ~= 0
    local InMount = TempRoleInfo.MountDatas and TempRoleInfo.MountDatas.MountId and TempRoleInfo.MountDatas.MountId ~= 0
    if (InResource or InState or InMount) then
        TempRoleInfo.IsCrouching = false
    end
    local SuitTalble =  TempRoleInfo.AppearanceSuit
    SuitTalble.IsCornerVisible = CharInfo.IsCornerVisible
    SuitTalble.IsShowPartMesh = CharInfo.IsShowPartMesh
    SuitTalble.AccessorySuit = CharInfo.AccessorySuit
    SuitTalble.Colors = CharInfo.Colors
    SuitTalble.SkinId = CharInfo.SkinId
    SuitTalble.HairId= CharInfo.HairId
    SuitTalble.HairColors = CharInfo.HairColors
    SuitTalble.AccessoryCustomParams = CharInfo.AccessoryCustomParams
    if(RoleInfo.WeaponInfo)then 
        local MeleeWeapon = {}
        if(RoleInfo.WeaponInfo.MeleeWeapon) then
            Utils.FormatWeaponInfo(MeleeWeapon, RoleInfo.WeaponInfo.MeleeWeapon)
        end
        TempRoleInfo.MeleeWeapon = MeleeWeapon
        local RangedWeapon = {}
        if(RoleInfo.WeaponInfo.RangedWeapon) then
            Utils.FormatWeaponInfo(RangedWeapon, RoleInfo.WeaponInfo.RangedWeapon)
        end
        TempRoleInfo.RangedWeapon = RangedWeapon
    end
    TempRoleInfo.ShowWeapon = RoleInfo.ShowWeapon
	PrintTable({CZC_AddRoleToCreate_RoleInfo = TempRoleInfo, RoleInfo = RoleInfo, AvatarId = ObjId}, 100)
end

function Component:RegionSyncChangeRoleInfo(ObjId, RoleInfo)
    if not self:RegionSyncSystemValid(ObjId) then
        return
    end
    local GameInstance = GWorld.GameInstance
    local RegionSycnSubsys = UE4.URegionSyncSubsystem.GetInstance(GameInstance)
    local ObjIdStr = CommonUtils.ObjId2Str(ObjId)
    if not RegionSycnSubsys:ObjIdValidation(ObjIdStr) then
        self.logger.error("RegionSycnSubsys:ObjIdValidation is false")
        return
    end
    if not self.OtherRoleInfo[ObjId] then
        self.logger.error("Init Info is empty ", ObjId)
        return
    end
    local TempRoleInfo = self.OtherRoleInfo[ObjId]
    local CharInfo = RoleInfo.CharInfo
	TempRoleInfo.ObjectId = ObjId
	TempRoleInfo.RoleId = CharInfo.CharId
    TempRoleInfo.SkinId = CharInfo.SkinId
    TempRoleInfo.AppearanceSuit = {}
    local SuitTalble =  TempRoleInfo.AppearanceSuit
    SuitTalble.IsCornerVisible = CharInfo.IsCornerVisible
    SuitTalble.IsShowPartMesh = CharInfo.IsShowPartMesh
    SuitTalble.AccessorySuit = CharInfo.AccessorySuit
    SuitTalble.Colors = CharInfo.Colors
    SuitTalble.SkinId = CharInfo.SkinId
    SuitTalble.HairId= CharInfo.HairId
    SuitTalble.HairColors = CharInfo.HairColors
    SuitTalble.AccessoryCustomParams = CharInfo.AccessoryCustomParams
    if(RoleInfo.WeaponInfo)then 
        local MeleeWeapon = {}
        if(RoleInfo.WeaponInfo.MeleeWeapon) then
            Utils.FormatWeaponInfo(MeleeWeapon, RoleInfo.WeaponInfo.MeleeWeapon)
        end
        TempRoleInfo.MeleeWeapon = MeleeWeapon
        local RangedWeapon = {}
        if(RoleInfo.WeaponInfo.RangedWeapon) then
            Utils.FormatWeaponInfo(RangedWeapon, RoleInfo.WeaponInfo.RangedWeapon)
        end
        TempRoleInfo.RangedWeapon = RangedWeapon
    end
    TempRoleInfo.ShowWeapon = RoleInfo.ShowWeapon or "Melee"
    TempRoleInfo.IsCrouching = false
    TempRoleInfo.ReInit = true
    PrintTable({RoleInfoUpdated = TempRoleInfo, AvatarId = ObjId , BornState = RegionSycnSubsys:GetRoleBornState(ObjIdStr)}, 100)
    if(RegionSycnSubsys:GetRoleBornState(ObjIdStr) <= UE4.ERegionCharBornState.EBS_WatiForPreload) then
        return
    end
    RegionSycnSubsys:OnRoleInfoNeedUpdate(ObjIdStr)
end

function Component:RegionSyncChangeWeaponInfo(ObjId, Message, Type)
    if not self:RegionSyncSystemValid(ObjId) then
        return
    end
    local GameInstance = GWorld.GameInstance
    local RegionSycnSubsys = UE4.URegionSyncSubsystem.GetInstance(GameInstance)
    local ObjIdStr = CommonUtils.ObjId2Str(ObjId)
    if not RegionSycnSubsys:ObjIdValidation(ObjIdStr) then
        self.logger.error("RegionSycnSubsys:ObjIdValidation is false")
        return
    end
    if not self.OtherRoleInfo[ObjId] then
        self.logger.error("Init Info is empty ", ObjId)
        return
    end
    local TempRoleInfo = self.OtherRoleInfo[ObjId]
    if(Message.WeaponInfo)then 
        local TempWeaponInfo = {}
        Utils.FormatWeaponInfo(TempWeaponInfo, Message.WeaponInfo)
        TempRoleInfo[Type .. "Weapon"] = TempWeaponInfo
    end
    TempRoleInfo.ShowWeapon = "Melee"
    PrintTable({WeaponInfoUpdated = TempRoleInfo, AvatarId = ObjId , BornState = RegionSycnSubsys:GetRoleBornState(ObjIdStr)}, 100)

    if(RegionSycnSubsys:GetRoleBornState(ObjIdStr) <= UE4.ERegionCharBornState.EBS_WatiForPreload) then
        return
    end
    RegionSycnSubsys:OnRoleInfoNeedUpdate(ObjIdStr)
end

function Component:RegionSyncChangeUsingWeaponType(ObjId, RoleInfo)
    if not self:RegionSyncSystemValid(ObjId) then
        return
    end
    local GameInstance = GWorld.GameInstance
    local RegionSycnSubsys = UE4.URegionSyncSubsystem.GetInstance(GameInstance)
    local ObjIdStr = CommonUtils.ObjId2Str(ObjId)
    if not RegionSycnSubsys:ObjIdValidation(ObjIdStr) then
        self.logger.error("RegionSycnSubsys:ObjIdValidation is false")
        return
    end
    if not self.OtherRoleInfo[ObjId] then
        self.logger.error("Init Info is empty ", ObjId)
        return
    end
    local TempRoleInfo = self.OtherRoleInfo[ObjId]
    TempRoleInfo.ShowWeapon = RoleInfo.ShowWeapon
    if(RegionSycnSubsys:GetRoleBornState(ObjIdStr) <= UE4.ERegionCharBornState.EBS_WaitForBorn) then
        return
    end
    local BornedChar = RegionSycnSubsys:GetBornedChar(ObjIdStr)
    if(not BornedChar) then
        self.logger.error("Character is not Created yet", ObjId)
        return
    end
    if not BornedChar[RoleInfo.ShowWeapon .. "Weapon"] then
        self.logger.error("Character Doesn't have this weapon ", RoleInfo.ShowWeapon, ObjId)
        return
    end
    BornedChar:ChangeUsingWeaponByType(RoleInfo.ShowWeapon)
end

function Component:RegionSyncUpdateMoveInfo(ObjId, MoveInfo)
    if not self:RegionSyncSystemValid(ObjId) then
        return
    end
    local GameInstance = GWorld.GameInstance
    local RegionSycnSubsys = UE4.URegionSyncSubsystem.GetInstance(GameInstance)
    local ObjIdStr = CommonUtils.ObjId2Str(ObjId)
    if not RegionSycnSubsys:ObjIdValidation(ObjIdStr) then
        self.logger.error("RegionSycnSubsys:ObjIdValidation is false")
        return
    end
    local TempRoleInfo = self.OtherRoleInfo[ObjId]
    if TempRoleInfo then 
        TempRoleInfo.CurResourceId = MoveInfo.CurResourceId
    end
    local ActorLoc = FVector(MoveInfo.Location.X, MoveInfo.Location.Y, MoveInfo.Location.Z)
    local ActorRot = FRotator(MoveInfo.Rotation.Pitch, MoveInfo.Rotation.Yaw, MoveInfo.Rotation.Roll)
    RegionSycnSubsys:UpdateRoleLocAndRot(ObjIdStr, ActorLoc, ActorRot)
    -- DebugPrint("[RegionOnline] RegionSyncUpdate MoveInfo At ", ObjId, ActorLoc, ActorRot)
    if(RegionSycnSubsys:GetRoleBornState(ObjIdStr) <= UE4.ERegionCharBornState.EBS_WaitForBorn) then
        return
    end
    if(MoveInfo.ActionBaseInfo) then 
        local CrouchInt = MoveInfo.ActionBaseInfo.IsCrouching
        TempRoleInfo.IsCrouching = (CrouchInt ~= nil and CrouchInt > 0.1)
        print(_G.LogTag, "RegionPlayerInitInfo Spawn Other Player Character Success",TempRoleInfo.IsCrouching, CrouchInt)
    end
    MoveInfo.IsCrouching = TempRoleInfo.IsCrouching
    local BornedChar = RegionSycnSubsys:GetBornedChar(ObjIdStr)
    if(not BornedChar) then
        self.logger.error("Character is not Created yet", ObjId)
        return
    end

    BornedChar:UpdateCharacterMoveInfo(MoveInfo)
    if RegionSycnSubsys.LocalPlayerChar then 
        RegionSycnSubsys.LocalPlayerChar:CanPlayerBeInterCandidate(BornedChar.Eid, ActorLoc)
    end
end

function Component:RegionSyncRemoveRoleAndDestroy(ObjId, RoleInfo)
    if not self:RegionSyncSystemValid(ObjId) then
        return
    end
    local GameInstance = GWorld.GameInstance
    local RegionSycnSubsys = UE4.URegionSyncSubsystem.GetInstance(GameInstance)
    local ObjIdStr = CommonUtils.ObjId2Str(ObjId)
    if RegionSycnSubsys:ObjIdValidation(ObjIdStr) then
        RegionSycnSubsys:RemoveRoleBornInfo(ObjIdStr, true)
    end
    local TempRoleInfo = self.OtherRoleInfo[ObjId]
    if TempRoleInfo then 
        EventManager:FireEvent(EventID.OnlineRemoveOtherPlayer, TempRoleInfo.Uid)
        self.OtherRoleInfo[ObjId] = nil
    end
    
    if TempRoleInfo then 
        EventManager:FireEvent(EventID.RemoveRegionIndicatorInfo, TempRoleInfo.Uid)
    end
    
end
return Component