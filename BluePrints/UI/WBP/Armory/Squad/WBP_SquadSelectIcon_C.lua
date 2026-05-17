---@type WBP_Build_SelectSlot_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

--function M:Initialize(Initializer)
--end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

local SQUAD_ICON_TYPE =
{
    CHAR_ICON = "Char",             -- 角色
    WEAPON_ICON = "Weapon",         -- 武器
    BATTLE_WHEEL_ICON = "Wheel",    -- 战斗轮盘
    PET_ICON = "Pet",               -- 宠物
    EMPTY_PET_ICON = "EmptyPet",    -- 空宠物
    EMPTY_ICON = "Empty",           -- 空
}

local EMPTY_PET_ICON_PATH = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Pet.T_Tab_Pet'"

function M:InitIcon(SquadIconType, IconPath, ...)
    --DebugPrint("gmy@WBP_SquadSelectIcon_C M:InitIcon", SquadIconType, IconPath, ...)
    if SquadIconType == SQUAD_ICON_TYPE.CHAR_ICON then
        self:SetCharIcon(IconPath, ...)
    elseif SquadIconType == SQUAD_ICON_TYPE.WEAPON_ICON then
        self:SetWeaponIcon(IconPath, ...)
    elseif SquadIconType == SQUAD_ICON_TYPE.BATTLE_WHEEL_ICON then
        self:SetWheelIcon(IconPath, ...)
    elseif SquadIconType == SQUAD_ICON_TYPE.PET_ICON then
        self:SetPetIcon(IconPath, ...)
    elseif SquadIconType == SQUAD_ICON_TYPE.EMPTY_ICON then
        self:SetEmptyIcon(IconPath, ...)
    elseif SquadIconType == SQUAD_ICON_TYPE.EMPTY_PET_ICON then
        self:SetEmptyPetIcon(IconPath, ...)
    else
        assert(false, "Invalid SquadIconType: " .. SquadIconType)
    end
end

function M:SetCharIcon(IconPath, ...)
    self.WidgetSwitcher_Head:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Panel_Level:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Switch_Type:SetActiveWidgetIndex(0)
    self.WidgetSwitcher_Head:SetActiveWidgetIndex(0)
    self.Panel_Level:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    --self.Img_Avatar:SetBrushResourceObject(LoadObject(IconPath))
    local IconDynaMaterial = self.Img_Avatar:GetDynamicMaterial()
    IconDynaMaterial:SetTextureParameterValue("IconMap", LoadObject(IconPath))

    local Level = ...
    self.Text_Level:SetText(tostring(Level))
end

function M:SetWeaponIcon(IconPath, ...)
    self:PlayAnimation(self.Normal)
    self.WidgetSwitcher_Head:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Panel_Level:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Switch_Type:SetActiveWidgetIndex(0)
    self.WidgetSwitcher_Head:SetActiveWidgetIndex(1)
    self.Panel_Level:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    --self.Img_Weapon:SetBrushResourceObject(LoadObject(IconPath))
    local IconDynaMaterial = self.Img_Weapon:GetDynamicMaterial()
    IconDynaMaterial:SetTextureParameterValue("IconMap", LoadObject(IconPath))

    local Level = ...
    self.Text_Level:SetText(tostring(Level))
end

function M:SetWheelIcon(IconPath, ...)
    self.WidgetSwitcher_Head:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Panel_Level:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Switch_Type:SetActiveWidgetIndex(1)
    self.Panel_Level:SetVisibility(UE4.ESlateVisibility.Collapsed)

    local WheelIndex = ...
    local WheelIndexText = Const.RomanNum[WheelIndex]
    self.Text_Num:SetText(WheelIndexText)
end

function M:SetPetIcon(IconPath, ...)
    self.WidgetSwitcher_Head:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Panel_Level:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Switch_Type:SetActiveWidgetIndex(0)
    self.WidgetSwitcher_Head:SetActiveWidgetIndex(0)
    self.Panel_Level:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

    local IconDynaMaterial = self.Img_Avatar:GetDynamicMaterial()
    IconDynaMaterial:SetTextureParameterValue("IconMap", LoadObject(IconPath))

    local Level = ...
    self.Text_Level:SetText(tostring(Level))
end

function M:SetEmptyPetIcon(IconPath, ...)
    self.WidgetSwitcher_Head:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Panel_Level:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Switch_Type:SetActiveWidgetIndex(0)
    self.WidgetSwitcher_Head:SetActiveWidgetIndex(2)
    self.Empty_Pet:SetBrushResourceObject(LoadObject(EMPTY_PET_ICON_PATH))

    local Level = ...
    self.Text_Level:SetText(tostring(Level))
end

function M:SetEmptyIcon(IconPath, ...)
    self:PlayAnimation(self.EmptyRed)
    self.WidgetSwitcher_Head:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_Level:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:OnAnimationFinished(InAnimation)
    if InAnimation == self.FlashRed then
        self:SetEmptyIcon()
    end
end

return M
