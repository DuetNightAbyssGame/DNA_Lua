local Component = {}


function Component:InitCharSetCharAppearanceAccessory(Char, Reason)
    if not Char then return end
    local DefaultAccessory = Char.DefaultAccessory
    if not DefaultAccessory then return end
    for AccessoryType, AccessoryId in pairs(DefaultAccessory) do
        self:AddAccessory(AccessoryId, Reason)
        local CharAccessoryTypeIndex = CommonConst.NewCharAccessoryTypes[AccessoryType]
        for AppearanceIndex, AppearanceSuit in pairs(Char.AppearanceSuits) do
            -- self.logger.debug("ZJT_ InitCharSetCharAppearanceAccessory ",AccessoryId, AppearanceSuit, CharAccessoryTypeIndex, DefaultAccessory, AccessoryType)
            if CharAccessoryTypeIndex and AppearanceSuit.Accessory[CharAccessoryTypeIndex] then 
                AppearanceSuit.Accessory[CharAccessoryTypeIndex] = AccessoryId
            end
        end
    end
end
function Component:GMAddWeaponSkin(SkinId, Reason)
	local SkinInfo = DataMgr.WeaponSkin[SkinId]
	if not SkinInfo or SkinInfo.GMNot == 1 then
		return
	end
	self:AddWeaponSkin(SkinId,Reason,true)
end

function Component:AddWeaponSkin(SkinId, Reason, GiveNotOpen)
    local SkinInfo = DataMgr.WeaponSkin[SkinId]
	if not SkinInfo then return end
	GiveNotOpen = GiveNotOpen or false
	if not SkinInfo or (SkinInfo.IsNotOpen and not GiveNotOpen) then
		return
	end
	if self.OwnedWeaponSkins[SkinId] then
		return
	end
	self.OwnedWeaponSkins[SkinId] = os.time()
end

function Component:GMAddWeaponAccessory(AccessoryId, Reason)
    local Info =  DataMgr.WeaponAccessory[AccessoryId]
	if not Info or Info.GMNot == 1 then
		return
	end
    self:AddWeaponAccessory(AccessoryId,Reason, true)
end

function Component:AddWeaponAccessory(AccessoryId, Reason,GiveNotOpen)
    if not AccessoryId then return end
    GiveNotOpen = GiveNotOpen or false
    local Info =  DataMgr.WeaponAccessory[AccessoryId]
	if not Info or (Info.IsNotOpen and not GiveNotOpen) then return end
    if self.WeaponAccessorys:HasValue(AccessoryId) then return end
    self.WeaponAccessorys:Append(AccessoryId)
end
return Component