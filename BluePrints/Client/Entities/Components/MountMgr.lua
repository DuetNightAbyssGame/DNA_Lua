local Component = {}

function Component:EnterWorld()
	self.logger.debug("ZJT_ EnterWorld MountMgr ")
    self:InitMountRedDotInfo()
    EventManager:RemoveEvent(EventID.OnPropSetResources, self)
    EventManager:AddEvent(EventID.OnPropSetResources, self, self.OnGetFlyLicenseResource)
end

function Component:OnGetFlyLicenseResource()
    self:TryAddMountItemNewRedDot()
    self:TryAddLicenseItemNewRedDot()
end

function Component:InitMountRedDotInfo()
    ReddotManager.AddNodeEx("Mounts_Root")
    self:TryAddMountItemNewRedDot()
    self:TryAddLicenseItemNewRedDot()
end

function Component:CheckMountEnough(CheckData)
    for MountId, Count in pairs(CheckData) do
        --坐骑是唯一的与数量无关
        if not self.Mounts[MountId] then
            self.logger.debug("[Mount] CheckMountEnough fail: not owned", "MountId=", MountId, "Count=", Count)
            return false
        end
    end
    return true
end

function Component:InitMountRedDotInfo()
    ReddotManager.AddNodeEx("Mounts_Root")
    self:TryAddMountItemNewRedDot()
    self:TryAddLicenseItemNewRedDot()
end

function Component:TryAddMountItemNewRedDot()
    if not ReddotManager.GetTreeNode("Mount_Item") then
        ReddotManager.AddNode("Mount_Item")
    end
    ReddotManager.ClearLeafNodeCount("Mount_Item")
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("Mount_Item")
    local IncreaseNum = 0
    for MountId, _ in pairs(self.Mounts) do
        if not CacheDetail[MountId] then
            IncreaseNum = IncreaseNum + 1
        end
    end
    if IncreaseNum > 0 then
        ReddotManager.IncreaseLeafNodeCount("Mount_Item", IncreaseNum)
    end
end

function Component:TryAddLicenseItemNewRedDot()
    if not ReddotManager.GetTreeNode("MountLicense_Item") then
        ReddotManager.AddNode("MountLicense_Item")
    end
    ReddotManager.ClearLeafNodeCount("MountLicense_Item")
    local IncreaseNum = 0
    local FlyLicenseConfig = DataMgr.FlyLicense
    for Id, Data in pairs(FlyLicenseConfig) do
        local Resource = Data.Resource and self.Resources[Data.Resource[1]]
        if not self.MountFlyLicenses[Id] and Resource and Resource.Count >= 1 then
            IncreaseNum = IncreaseNum + 1
        end
    end
    if IncreaseNum > 0 then
        ReddotManager.IncreaseLeafNodeCount("MountLicense_Item", IncreaseNum)
    end
end

function Component:HasLicenseResource(LicenseId)
    local FlyLicenseConfig = DataMgr.FlyLicense[LicenseId]
    local Resource = FlyLicenseConfig.Resource and self.Resources[FlyLicenseConfig.Resource[1]]
    return Resource and Resource.Count >= 1
end

function Component:MountLevelUp(TargetLevel)
    local function Callback(Ret)
        self.logger.debug("ZJT_ MountLevelUp ", TargetLevel, Ret)
    end
    self:CallServer("MountLevelUp", Callback, TargetLevel)
end

function Component:LevelUpFlyLicense(FlyLicenseId, ResourceId, CallBack)
    local function Callback(Ret)
        self.logger.debug("ZJT_ LevelUpFlyLicense ", Ret, FlyLicenseId, ResourceId)
        if CallBack then
            CallBack(Ret)
        end
    end

    self:CallServer("LevelUpFlyLicense", Callback, FlyLicenseId, ResourceId)
end

function Component:SetMountAppearanceAccessory(MountId, AppearanceIndex, AccessoryId)
    local function Callback(Ret)
        self.logger.debug("ZJT_ SetMountAppearanceAccessory ", Ret, MountId, AppearanceIndex, AccessoryId)
    end

    self:CallServer("SetMountAppearanceAccessory", Callback, MountId, AppearanceIndex, AccessoryId)
end

function Component:RemoveMountAppearanceAccessory(MountId, AppearanceIndex, AccessoryId)
    local function Callback(Ret)
        self.logger.debug("ZJT_ RemoveMountAppearanceAccessory ", Ret, MountId, AppearanceIndex, AccessoryId)
    end

    self:CallServer("RemoveMountAppearanceAccessory", Callback, MountId, AppearanceIndex, AccessoryId)
end


function Component:SwitchCurrentMountSkinColorPlan(MountId, NewPlanIndex)
    local function Callback(Ret)
        self.logger.debug("ZJT_ SwitchCurrentMountSkinColorPlan ", Ret, MountId, NewPlanIndex)
    end

    self:CallServer("SwitchCurrentMountSkinColorPlan", Callback, MountId, NewPlanIndex)
end

function Component:ChangeMountSkinColors(MountId,SkinId,PlanIndex,NewColorWithPart)
    local function Callback(Ret)
        self.logger.debug("ZJT_ SwitchCurrentMountSkinColorPlan ", Ret, MountId,SkinId,PlanIndex,NewColorWithPart)
    end

    self:CallServer("SwitchCurrentMountSkinColorPlan", Callback, MountId,SkinId,PlanIndex,NewColorWithPart)
end

function Component:UpdateMountAppearanceSuitName( MountId, NewName)
    local function Callback(Ret)
        self.logger.debug("ZJT_ UpdateMountAppearanceSuitName ", Ret, MountId, NewName)
    end

    self:CallServer("SwitchCurrentMountSkinColorPlan", Callback, MountId, NewName)
end

function Component:HasMountById(MountId)
    return self.Mounts[MountId] ~= nil
end

function Component:HasMountLicenseById(LicenseId)
    return self.MountFlyLicenses[LicenseId] ~= nil    
end

function Component:CheckMountCanFly(MountId)
    local Succ, EorrCode = self:CheckMountCanFlyWithCode(MountId)
    return ErrorCode:Check(EorrCode)
end

function Component:CheckMountCanFlyWithCode(MountId)
    self.logger.debug("[Mount] MountTryFly enter", "MountId=", MountId)
    local ErrCode = ErrorCode.RET_SUCCESS

    if not self.Mounts[MountId] then
        self.logger.info("[Mount] MountTryFly mount not owned", "MountId=", MountId)
        ErrCode = ErrorCode.RET_REGION_MOUNT_NOT_OWNED
        return false, ErrCode
    end

    -- SubRegion 的 FlyLicense 字段
    local SubRegionId = self:GetCurrentRegionId() --虽然是GetCurrentRegionId 但是应该返回的就是SubRegionId 这函数命名有点迷
    local SubRegionInfo = DataMgr.SubRegion[SubRegionId]
    if not SubRegionInfo or SubRegionInfo.FlyLicense == -1  then
        self.logger.error("[Mount] MountTryFly SubRegion Cant Fly", SubRegionId)
        ErrCode = ErrorCode.RET_REGION_SUB_REGION_CANT_FLY
        return false, ErrCode
    end

    local MountInfo = DataMgr.Mount[MountId]
    if not MountInfo then
        self.logger.error("[Mount] MountTryFly mount config missing", "MountId=", MountId)
        ErrCode = ErrorCode.RET_REGION_MOUNT_DATA_NOT_EXIST
        return false, ErrCode
    end

    if MountInfo.FlyLicense == 1 then --策划说1就需要检查执照
        if not self.MountFlyLicenses[SubRegionInfo.FlyLicense] then
            self.logger.info("[Mount] MountTryFly fly license not owned", "FlyLicenseId=", SubRegionInfo.FlyLicense)
            ErrCode = ErrorCode.RET_REGION_MOUNT_FLY_LICENSE_NOT_OWNED
            return false, ErrCode
        end
    end

    self.logger.debug("[Mount] MountTryFly success", "MountId=", MountId)
    return true, ErrCode
end

return Component