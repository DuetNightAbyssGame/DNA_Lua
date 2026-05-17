local Component = {}

function Component:CheckWeaponSkinEnough(CheckData)
    for WeaponSkinId, Count in pairs(CheckData) do
		local WeaponSkin = self.OwnedWeaponSkins[WeaponSkinId]
		if not WeaponSkin then
			return false
		end
	end
	return true
end

function Component:CheckWeaponAccessoryEnough(CheckData)
    for WeaponAccessoryId, Count in pairs(CheckData) do
		if not self.WeaponAccessorys:HasValue(WeaponAccessoryId) then
            return false
        end
	end
	return true
end

function Component:CheckSkinEnough(CheckData)
    for CharSkinId, Count in pairs(CheckData) do
        local SkinInfo = DataMgr.Skin[CharSkinId]
        if not SkinInfo or not SkinInfo.CharId then
            return false
        end
        local CharId = SkinInfo.CharId
        local CharInfo = DataMgr.Char[CharId]
        if not CommonUtils.HasValue(CharInfo.SkinId, CharSkinId) then return false end
        local CommonChar = self.CommonChars[CharId]
        if CommonChar then
            if CommonChar.OwnedSkins[CharSkinId] == nil then
                return false
            end
        else
            local OtherCharSkin = self.OtherCharSkins[CharId]
            if not OtherCharSkin then
                return false
            end
            if not OtherCharSkin:HasValue(CharSkinId) then
                return false
            end
        end
    end
    return true
end

function Component:CheckCharAccessoryEnough(CheckData)
    if next(CheckData) == nil then
        return true
    end
    for CharAccessoryId, _ in pairs(CheckData) do
        if not  DataMgr.CharAccessory[CharAccessoryId] then
            return false
        end
        if not self.CharAccessorys:HasValue(CharAccessoryId) then
            return false
        end
    end
    return true
end

function Component:CheckHairEnough(CheckData)
    for CharHairId, Count in pairs(CheckData) do
        local HairInfo = DataMgr.Hair[CharHairId]
        if not HairInfo then
            return false
        end
        if HairInfo.IsCommon then
            if not self.CommonCharHairs[CharHairId] then
                return false
            end
        else
            local CharId = HairInfo.CharId
            local CommonChar = self.CommonChars[CharId]
            if CommonChar then
                if CommonChar.OwnedHairs[CharHairId] == nil then
                    return false
                end
            else
                local OtherCharHair = self.OtherCharHairs[CharId]
                if not OtherCharHair then
                    return false
                end
                if not OtherCharHair:HasValue(CharHairId) then
                    return false
                end
            end
        end
    end
    return true
end

--获取角色某套外观方案的配饰自定义参数
function Component:GetCharAccessoryCustomParams(CharUuid,AppearanceIndex,AccessoryId)
    if not CharUuid then return end
    local Char = self.Chars[CharUuid]
    if not Char then return end
    local AppearanceSuit = Char:GetAppearance(AppearanceIndex)
    if not AppearanceSuit then return end
    if AppearanceSuit.AccessoryCustomParams and AppearanceSuit.AccessoryCustomParams[AccessoryId] then
        return SerializeUtils:UnSerialize(AppearanceSuit.AccessoryCustomParams[AccessoryId])
    end
    return nil
end

function Component:AddNewCharAppearance()
    local function Callback(Ret)
        DebugPrint("ZJT_ AddNewCharAppearance ", Ret)
    end
    self:CallServer("AddNewCharAppearance", Callback, self.CurrentChar)
end

function Component:SwitchCurrentCharAppearance(CharUuid, AppearanceIndex)
    CharUuid = CharUuid or self.CurrentChar
    local function Callback(Ret)
        DebugPrint("ZJT_ SwitchCurrentCharAppearance", Ret)
        EventManager:FireEvent(EventID.OnCharAppearanceChanged,Ret,CharUuid, AppearanceIndex)
    end
    self:CallServer("SwitchCurrentCharAppearance", Callback, CharUuid, AppearanceIndex)
end

function Component:SetCharAppearanceAccessory(CharUuid, AppearanceIndex, AccessoryId,CustomParams)
    DebugPrint("ZJT_ SetCharAppearanceAccessory Begin", CharUuid, AppearanceIndex, AccessoryId,CustomParams)
    CharUuid = CharUuid or self.CurrentChar
    CustomParams = CustomParams or {}
    local function Callback(Ret)
        DebugPrint("ZJT_ OnSetCharAppearanceAccessory Callback ", Ret)
        EventManager:FireEvent(EventID.OnCharAccessorySetted,Ret,CharUuid, AppearanceIndex, AccessoryId,CustomParams)
    end
    self:CallServer("SetCharAppearanceAccessory", Callback, CharUuid, AppearanceIndex, AccessoryId,CustomParams)
end


function Component:RemoveCharAppearanceAccessory(CharUuid, AppearanceIndex, AccessoryId)
    CharUuid = CharUuid or self.CurrentChar
    local function Callback(Ret)
        DebugPrint("ZJT_ RemoveCharAppearanceAccessory ", Ret)
        EventManager:FireEvent(EventID.OnCharAccessoryRemoved,Ret,CharUuid, AppearanceIndex, AccessoryId)
    end
    self:CallServer("RemoveCharAppearanceAccessory", Callback, CharUuid, AppearanceIndex, AccessoryId)
end

function Component:SetCharSkinShowPart(CharUuid, SkinId, IsShowPartMesh)
    local function Callback( Ret )
        self.logger.debug("ZJT_ 1 SetCharSkinShowPart ServerCallClient ", Ret, CharUuid, SkinId, IsShowPartMesh)
        EventManager:FireEvent(EventID.OnCharShowPartMesh,Ret,CharUuid, SkinId, IsShowPartMesh)
    end
    self:CallServer("SetCharSkinShowPart", Callback, CharUuid, SkinId, IsShowPartMesh)
end

function Component:ChangeCharAppearanceSkin(CharUuid, AppearanceIndex, SkinId)
    DebugPrint("ZJT_ ChangeCharAppearanceSkin", CharUuid, AppearanceIndex, SkinId)
    local function Callback(Ret)
        DebugPrint("ZJT_ OnChangeCharAppearanceSkin ", Ret)
        EventManager:FireEvent(EventID.OnCharSkinChanged,Ret,CharUuid, AppearanceIndex, SkinId)
    end
    self:CallServer("ChangeCharAppearanceSkin", Callback, CharUuid, AppearanceIndex, SkinId)
end

function Component:SetCharCornerVisibility(CharUuid, AppearancIndex, IsVisible)
    CharUuid = CharUuid or self.CurrentChar
    local function Callback(Ret)
        DebugPrint("ZJT_ SetCharCornerVisibility ", Ret)
        EventManager:FireEvent(EventID.OnCharCornerVisibilityChanged,Ret,CharUuid, AppearancIndex, IsVisible)
    end
    self:CallServer("SetCharCornerVisibility", Callback, CharUuid, AppearancIndex, IsVisible)
end

--角色皮肤升级
function Component:UpCharSkinLevel(InCallback, SkinId, NewLevel)
    self.logger.debug("UpCharSkinLevel Begin",SkinId, NewLevel)
	local function Callback(Ret)
		self.logger.debug("UpCharSkinLevel Callback", Ret,SkinId,NewLevel)
        if InCallback then
            InCallback(Ret)
        end
    end
	self:CallServer("UpCharSkinLevel",Callback,SkinId,NewLevel)
end

--切换角色皮肤选中的等级
function Component:SwitchCharSkinSelectedLevel(InCallback, SkinId, NewLevel)
    self.logger.debug("SwitchCharSkinSelectedLevel Begin",SkinId, NewLevel)
	local function Callback(Ret)
		self.logger.debug("SwitchCharSkinSelectedLevel Callback", Ret,SkinId,NewLevel)
        if InCallback then
            InCallback(Ret,SkinId,NewLevel)
        end
    end
	self:CallServer("SwitchCharSkinSelectedLevel",Callback,SkinId,NewLevel)
end

--改变武器配饰
function Component:ChangeWeaponAppearanceAccessory(WeaponUuid,AccessoryId)
    self.logger.debug("ChangeWeaponAppearanceAccessory Begin",CommonUtils.ObjId2Str(WeaponUuid),AccessoryId)
	local function callback(Ret)
		self.logger.debug("ChangeWeaponAppearanceAccessory callback", Ret,AccessoryId)
		EventManager:FireEvent(EventID.OnWeaponAccessoryChanged, Ret,WeaponUuid,AccessoryId)
    end
	self:CallServer("ChangeWeaponAppearanceAccessory", callback, WeaponUuid,AccessoryId)
end

--卸下武器配饰
function Component:RemoveWeaponAppearanceAccessory(WeaponUuid, AccessoryId)
    self.logger.debug("RemoveWeaponAppearanceAccessory Begin",CommonUtils.ObjId2Str(WeaponUuid),AccessoryId)
    local function Callback(Ret)
        self.logger.debug("RemoveWeaponAppearanceAccessory callback", Ret,AccessoryId)
        EventManager:FireEvent(EventID.OnWeaponAccessoryChanged, Ret,WeaponUuid,AccessoryId)
    end
    self:CallServer("RemoveWeaponAppearanceAccessory", Callback, WeaponUuid, AccessoryId)
end

--改变武器皮肤
function Component:ChangeWeaponAppearanceSkin(WeaponUuid,SkinId)
    self.logger.debug("ZJT_ ChangeWeaponAppearanceSkin Start", CommonUtils.ObjId2Str(WeaponUuid),SkinId)
	local function callback(Ret)
		self.logger.debug("ZJT_ OnChangeWeaponAppearanceSkin callback", Ret,SkinId)
		EventManager:FireEvent(EventID.OnWeaponSkinChanged, Ret,WeaponUuid,SkinId)
	end
	self:CallServer("ChangeWeaponAppearanceSkin", callback, WeaponUuid,SkinId)
end

--切换武器皮肤染色当前生效的方案
function Component:SwitchCurrentWeaponSkinColorPlan(WeaponUuid,SkinId,NewPlanIndex)
    self.logger.debug("SwitchCurrentWeaponSkinColorPlan Start", CommonUtils.ObjId2Str(WeaponUuid),SkinId,NewPlanIndex)
    local function callback(Ret)
		self.logger.debug("SwitchCurrentWeaponSkinColorPlan callback", Ret,SkinId,NewPlanIndex)
		EventManager:FireEvent(EventID.OnWeaponSkinColorPlanChanged, Ret,WeaponUuid, SkinId, NewPlanIndex)
	end
	self:CallServer("SwitchCurrentWeaponSkinColorPlan", callback, WeaponUuid,SkinId,NewPlanIndex)
end

--武器皮肤染色
---@param NewColorWithPart {Part:ColorId} key-武器部位 value-新颜色Id
function Component:ChangeWeaponSkinColors(WeaponUuid,SkinId,PlanIndex,NewColorWithPart)
	self.logger.debug("ChangeWeaponSkinColors Start", CommonUtils.ObjId2Str(WeaponUuid),SkinId)
	local function callback(Ret)
		EventManager:FireEvent(EventID.OnWeaponColorsChanged, Ret,WeaponUuid,SkinId,PlanIndex,NewColorWithPart)
		self.logger.debug("ZJT_ OnChangeWeaponSkinColors callback", Ret,SkinId,PlanIndex)
	end
	self:CallServer("ChangeWeaponSkinColors", callback, WeaponUuid,SkinId,PlanIndex,NewColorWithPart)
end

--武器皮肤特殊染色
function Component:ChangeWeaponSkinSpecialColor(WeaponUuid,SkinId,PlanIndex,NewColor)
	self.logger.debug("ChangeWeaponSkinSpecialColor Start", CommonUtils.ObjId2Str(WeaponUuid),SkinId,PlanIndex,NewColor)
	local function callback(Ret)
		self.logger.debug("ChangeWeaponSkinSpecialColor callback", Ret,SkinId)
		EventManager:FireEvent(EventID.OnWeaponColorsChanged, Ret,WeaponUuid,SkinId,PlanIndex,NewColor)
	end
	self:CallServer("ChangeWeaponSkinSpecialColor", callback, WeaponUuid,SkinId,PlanIndex,NewColor)
end

function Component:UpdateCharAppearanceSuitName(CharUuid, AppearanceIndex, NewName)
    local function Callback(Ret)
        self.logger.debug("ZJT_ UpdateCharAppearanceSuitName ", Ret, NewName)
		EventManager:FireEvent(EventID.OnCharAppearanSuitRenamed, Ret,CharUuid, AppearanceIndex, NewName)
    end
    self:CallServer("UpdateCharAppearanceSuitName", Callback, CharUuid, AppearanceIndex, NewName)
end


function Component:UpdateWeaponAppearanceSuitName(WeaponUuid, NewName)
    local function Callback(Ret)
        self.logger.debug("ZJT_ UpdateWeaponAppearanceSuitName ", Ret,NewName)
		EventManager:FireEvent(EventID.OnWeaponAppearanSuitRenamed, Ret,WeaponUuid, NewName)
    end
    self:CallServer("UpdateWeaponAppearanceSuitName", Callback, WeaponUuid, NewName)
end


function Component:SwitchCurrentCharSkinColorPlan(SkinId, NewPlanIndex)
    local function Callback(Ret)
        self.logger.debug("ZJT_ ServerCallClient SwitchCurrentCharSkinColorPlan ",Ret, SkinId, NewPlanIndex)
		EventManager:FireEvent(EventID.OnCharSkinColorPlanChanged, Ret,SkinId, NewPlanIndex)
    end
    self:CallServer("SwitchCurrentCharSkinColorPlan",Callback, SkinId, NewPlanIndex)
end

function Component:ChangeCharSkinColors(SkinId, NewColorWithPart, PlanIndex)
    PlanIndex = PlanIndex or 1
	if type(NewColorWithPart) ~= "table" or not SkinId or not DataMgr.Skin[SkinId] then return end
	local function Callback(Ret)
		self.logger.debug("ChangeCharSkinColors, Ret",Ret,SkinId, NewColorWithPart, PlanIndex)
		EventManager:FireEvent(EventID.OnCharColorsChanged, Ret, SkinId,NewColorWithPart)
	end
	self:CallServer("ChangeCharSkinColors", Callback, SkinId, PlanIndex, NewColorWithPart)
end

--切换角色发型
function Component:ChangeCharAppearanceHair(CharUuid, AppearanceIndex, NewHairId)
	self.logger.debug("ChangeCharAppearanceHair Start", CommonUtils.ObjId2Str(CharUuid),NewHairId)
	local function Callback(Ret)
		self.logger.debug("ChangeCharAppearanceHair Callback", Ret, AppearanceIndex, NewHairId)
        EventManager:FireEvent(EventID.OnCharHairChanged,Ret,CharUuid, AppearanceIndex, NewHairId)
	end
	self:CallServer("ChangeCharAppearanceHair", Callback, CharUuid, AppearanceIndex, NewHairId)
end

--切换角色发型染色当前生效的方案
function Component:SwitchCurrentCharHairColorPlan(HairId,NewPlanIndex)
    self.logger.debug("SwitchCurrentCharHairColorPlan Start", HairId,NewPlanIndex)
	local function Callback(Ret)
		self.logger.debug("SwitchCurrentCharHairColorPlan Callback", Ret, HairId,NewPlanIndex)
		EventManager:FireEvent(EventID.OnCharHairColorPlanChanged, Ret,HairId, NewPlanIndex)
	end
	self:CallServer("SwitchCurrentCharHairColorPlan", Callback, HairId,NewPlanIndex)
end

--切换角色发型染色
function Component:ChangeCharHairColors(HairId, NewColorWithPart, PlanIndex)
    self.logger.debug("ChangeCharHairColors Start", HairId, NewColorWithPart, PlanIndex)
	local function Callback(Ret)
		self.logger.debug("ChangeCharHairColors Callback", Ret, HairId, NewColorWithPart, PlanIndex)
		EventManager:FireEvent(EventID.OnCharHairColorsChanged, Ret, NewColorWithPart, PlanIndex)
	end
	self:CallServer("ChangeCharHairColors", Callback, HairId, PlanIndex, NewColorWithPart)
end

return Component