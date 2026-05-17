local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"

---@type SkinPreview_DescriptionUpdaterComponent
local M = {}

--- 根据 ItemData 更新2D描述UI
function M:UpdateDescription(ItemData)
    local itemType = ItemData.ItemType
    if itemType == "Skin" then
        self:UpdateCharSkinDescription(ItemData)
    elseif itemType == "Hair" then
        self:UpdateHairDescription(ItemData)
    elseif itemType == "WeaponSkin" then
        self:UpdateWeaponSkinDescription(ItemData)
    elseif itemType == "CharAccessory" then
        self:UpdateCharAccessoryDescription(ItemData)
    elseif itemType == "WeaponAccessory" then
        self:UpdateWeaponAccessoryDescription(ItemData)
    elseif itemType == "Resource" then
        if ItemData.ResourceSType == "GestureItem" then
            self:UpdateCharGestureDescription(ItemData)
        -- elseif ItemData.ResourceSType == "MountItem" then
        --     self:UpdateMountDescription(ItemData)
        end
    elseif itemType == "Mount" then
        self:UpdateMountDescription(ItemData)
    end
end

--- 更新角色皮肤描述
function M:UpdateCharSkinDescription(SkinInfo)
    local SkinData = DataMgr.Skin[SkinInfo.TypeId]
    if not SkinData then return end

    local CharInfo = DataMgr.Char[SkinData.CharId]
    if not CharInfo then return end

    self.Text_CharName:SetText(GText(CharInfo.CharName))
    self.Text_SkinName:SetText(GText(SkinData.SkinName))
    -- self.Text_SkinName_World:SetText(EnText(SkinData.SkinName))
    self.Text_Info:SetText(GText(SkinData.SkinDescribe))
    self.Tag_Quality:Init(SkinData.Rarity)
    self:UpdateSkinNameFontByRarity(SkinData.Rarity)
    self:HideZoomKey(false)

    self.Tag_Quality:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.HorizontalBox_Color:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Tab_Change:SetVisibility(ESlateVisibility.Collapsed)
    self.WBP_Mounts:SetVisibility(ESlateVisibility.Collapsed)

    -- 设置角色元素图标
    local ElementType = DataMgr.BattleChar[SkinData.CharId].Attribute
    if ElementType then
        local IconName = "Armory_" .. ElementType
        local AttributeIcon = LoadObject('/Game/UI/Texture/Dynamic/Atlas/Armory/T_' .. IconName .. ".T_" .. IconName)
        self.Image_Element:SetBrushResourceObject(AttributeIcon)
        self.Image_Element:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Image_Element:SetVisibility(ESlateVisibility.Collapsed)
    end

    -- 角色玩家是否拥有
    if self.Avatar:CheckCharEnough({[SkinData.CharId] = 1}) then
        self.Text_Char_None:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.Text_Char_None:SetText(GText("UI_SkinPreview_CharNotOwned"))
        self.Text_Char_None:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end

--- 更新Hair描述
function M:UpdateHairDescription(SkinInfo)
    local HairData = DataMgr.Hair[SkinInfo.TypeId]
    if not HairData then return end

    self.Text_CharName:SetText(GText("UI_Hair_Name"))
    self.Text_SkinName:SetText(GText(HairData.Name))
    -- self.Text_SkinName_World:SetText(EnText(HairData.Name))
    self.Text_Info:SetText(GText(HairData.HairDescribe))
    self.Tag_Quality:Init(HairData.Rarity)
    self:UpdateSkinNameFontByRarity(HairData.Rarity)
    self:HideZoomKey(false)

    self.Tag_Quality:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Text_Char_None:SetVisibility(ESlateVisibility.Collapsed)
    self.HorizontalBox_Color:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Tab_Change:SetVisibility(ESlateVisibility.Collapsed)
    self.WBP_Mounts:SetVisibility(ESlateVisibility.Collapsed)

    -- 设置Hair图标
    local AccessoryIconPath = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Fashion_Hair.T_Tab_Fashion_Hair"
    if AccessoryIconPath then
        local AccessoryIcon = LoadObject(AccessoryIconPath)
        self.Image_Element:SetBrushResourceObject(AccessoryIcon)
        self.Image_Element:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Image_Element:SetVisibility(ESlateVisibility.Collapsed)
    end
end

--- 更新角色配饰描述
function M:UpdateCharAccessoryDescription(SkinInfo)
    local AccessoryData = DataMgr.CharAccessory[SkinInfo.TypeId]
    if not AccessoryData then return end

    self.Text_CharName:SetText(GText(UIConst.AccessoryTypeTextMap[AccessoryData.AccessoryType]))
    self.Text_SkinName:SetText(GText(AccessoryData.Name))
    -- self.Text_SkinName_World:SetText(EnText(AccessoryData.Name))
    self.Text_Info:SetText(GText(AccessoryData.Des))
    self.Tag_Quality:Init(AccessoryData.Rarity)
    self:UpdateSkinNameFontByRarity(AccessoryData.Rarity)
    self:HideZoomKey(false)

    self.Tag_Quality:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Text_Char_None:SetVisibility(ESlateVisibility.Collapsed)
    self.HorizontalBox_Color:SetVisibility(ESlateVisibility.Collapsed)
    self.Tab_Change:SetVisibility(ESlateVisibility.Collapsed)
    self.WBP_Mounts:SetVisibility(ESlateVisibility.Collapsed)

    -- 设置配饰图标
    local AccessoryIconPath = ArmoryUtils:GetCharNoneAccessoryIconPaths()[AccessoryData.AccessoryType]
    if AccessoryIconPath then
        local AccessoryIcon = LoadObject(AccessoryIconPath)
        self.Image_Element:SetBrushResourceObject(AccessoryIcon)
        self.Image_Element:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Image_Element:SetVisibility(ESlateVisibility.Collapsed)
    end
end

--- 更新角色动作描述
function M:UpdateCharGestureDescription(SkinInfo)
    local GestureData = DataMgr.Resource[SkinInfo.TypeId]
    if not GestureData or GestureData.ResourceSType ~= "GestureItem" then return end

    self.Text_CharName:SetText(GText("UI_Preview_GestureItem"))
    self.Text_SkinName:SetText(GText(GestureData.ResourceName))
    -- self.Text_SkinName_World:SetText(EnText(GestureData.ResourceName))
    self.Text_Info:SetText(GText(GestureData.DetailDes))
    self.Tag_Quality:Init(GestureData.Rarity)
    self:UpdateSkinNameFontByRarity(GestureData.Rarity)
    self:HideZoomKey(false)

    self.Tag_Quality:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Text_Char_None:SetVisibility(ESlateVisibility.Collapsed)
    self.HorizontalBox_Color:SetVisibility(ESlateVisibility.Collapsed)
    self.Tab_Change:SetVisibility(ESlateVisibility.Collapsed)
    self.WBP_Mounts:SetVisibility(ESlateVisibility.Collapsed)

    -- 设置展示动作的图标
    local GestureIconPath = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Action.T_Tab_Action"
    local GestureIcon = nil
    if GestureIconPath then
        GestureIcon = LoadObject(GestureIconPath)
    end

    if GestureIcon then
        self.Image_Element:SetBrushResourceObject(GestureIcon)
        self.Image_Element:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Image_Element:SetVisibility(ESlateVisibility.Collapsed)
    end
end

--- 更新武器皮肤描述
function M:UpdateWeaponSkinDescription(SkinInfo)
    local WeaponSkinData = DataMgr.WeaponSkin[SkinInfo.TypeId]
    if not WeaponSkinData then return end

    self.Text_SkinName:SetText(GText(WeaponSkinData.Name))
    -- self.Text_SkinName_World:SetText(EnText(WeaponSkinData.Name))
    self.Text_Info:SetText(GText(WeaponSkinData.Dec))
    self.Tag_Quality:Init(WeaponSkinData.Rarity)
    self:UpdateSkinNameFontByRarity(WeaponSkinData.Rarity)
    self:HideZoomKey(true)

    self.Tag_Quality:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Text_Char_None:SetVisibility(ESlateVisibility.Collapsed)
    self.HorizontalBox_Color:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Tab_Change:SetVisibility(ESlateVisibility.Collapsed)
    self.WBP_Mounts:SetVisibility(ESlateVisibility.Collapsed)

    local WeaponTypeInfo = DataMgr.WeaponTypeContrast[WeaponSkinData.ApplicationType]
    if not WeaponTypeInfo then
        return
    end
    -- 设置武器种类名称和图标
    self.Text_CharName:SetText(string.format(GText("UI_SkinPreview_WeaponType"), GText(WeaponTypeInfo.WeaponTagTextmap)))

    if WeaponTypeInfo.Icon then
        local TagIcon = LoadObject(WeaponTypeInfo.Icon)
        self.Image_Element:SetBrushResourceObject(TagIcon)
        self.Image_Element:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self.Image_Element:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

--- 更新武器配饰描述
function M:UpdateWeaponAccessoryDescription(SkinInfo)
    local WeaponAccessoryData = DataMgr.WeaponAccessory[SkinInfo.TypeId]
    if not WeaponAccessoryData then return end

    self.Text_CharName:SetText(GText(UIConst.AccessoryTypeTextMap[SkinInfo.ItemType]))
    self.Text_SkinName:SetText(GText(WeaponAccessoryData.Name))
    -- self.Text_SkinName_World:SetText(EnText(WeaponAccessoryData.Name))
    self.Text_Info:SetText(GText(WeaponAccessoryData.Des))
    self.Tag_Quality:Init(WeaponAccessoryData.Rarity)
    self:UpdateSkinNameFontByRarity(WeaponAccessoryData.Rarity)
    self:HideZoomKey(true)

    self.Tag_Quality:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Text_Char_None:SetVisibility(ESlateVisibility.Collapsed)
    self.Image_Element:SetVisibility(ESlateVisibility.Collapsed)
    self.HorizontalBox_Color:SetVisibility(ESlateVisibility.Collapsed)
    self.Tab_Change:SetVisibility(ESlateVisibility.Visible)
    self.WBP_Mounts:SetVisibility(ESlateVisibility.Collapsed)
end

--- 更新坐骑描述
function M:UpdateMountDescription(ItemData)
    if not ItemData.TypeId then return end
    local MountData = DataMgr.Mount[ItemData.TypeId]
    if not MountData then return end
    
    self.Text_CharName:SetText(GText("UI_Mount"))
    self.Text_SkinName:SetText(GText(MountData.MountName))
    self.Text_Info:SetText(GText(MountData.MountDes))
    self.Tag_Quality:Init(MountData.MountRarity)
    self:UpdateSkinNameFontByRarity(MountData.MountRarity)
    self.WBP_Mounts:SetVisibility(ESlateVisibility.Collapsed)

    self.Text_Char_None:SetVisibility(ESlateVisibility.Collapsed)
    self.Image_Element:SetVisibility(ESlateVisibility.Collapsed)
    self.Tab_Change:SetVisibility(ESlateVisibility.Collapsed)
    self.HorizontalBox_Color:SetVisibility(ESlateVisibility.Collapsed)

    -- 设置坐骑图标
    local MountIconPath = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Mounts.T_Tab_Mounts"
    if MountIconPath then
        local MountIcon = LoadObject(MountIconPath)
        self.Image_Element:SetBrushResourceObject(MountIcon)
        self.Image_Element:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Image_Element:SetVisibility(ESlateVisibility.Collapsed)
    end
end

return M