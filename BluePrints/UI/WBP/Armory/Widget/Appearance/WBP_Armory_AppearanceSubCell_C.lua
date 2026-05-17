--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Armory_AppearanceSubCell_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

local RarityColorName = {
    [6] = "Img_Quality_Red",
    [5] = "Img_Quality_Gold",
    [4] = "Img_Quality_Purple",
    [3] = "Img_Quality_Blue",
    [2] = "Img_Quality_Green",
    [1] = "Img_Quality_Grey",
    [0] = "Img_Quality_NoQuality",
}
function M:Construct()
    self.Button_Area.OnClicked:Clear()
    self.Button_Area.OnHovered:Add(self, self.OnBtnHovered)
    self.Button_Area.OnUnhovered:Add(self, self.OnBtnUnhovered)
    self.Button_Area.OnPressed:Add(self, self.OnBtnPressed)
    self.Button_Area.OnClicked:Add(self,self.OnClicked)
    self.New:SetVisibility(UIConst.VisibilityOp["Collapsed"])
end

function M:OnListItemObjectSet(Content)
    self.Content = Content
    self.Owner = Content.Owner
    self._OnAddedToFocusPath = Content.OnAddedToFocusPath
    self._OnRemovedFromFocusPath = Content.OnRemovedFromFocusPath
    self.Content.Entry = self
    self.IsPreviewMode = Content.IsPreviewMode
    self.ItemId = Content.AccessoryId
    self.TipType = Content.TipType
    self.IsDressed = Content.IsDressed
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
    self:SetIcon(Content.IconPath,Content.IsNoneIcon)
    self:SetRarity(Content.Rarity)
    self:SetReddot(Content.IsNew)
    self.IsCharacterTrialMode = Content.IsCharacterTrialMode
    self:InitButton()
end

function M:BP_OnEntryReleased()
    if (self.Content) then
        self.Content.Entry = nil
    end
end

function M:OnClicked()
    if (self.Content and self.Content.OnClicked) then
        if self.IsPreviewMode then
            -- 显示外观tip
            local Content = {
                ItemType = self.TipType,
                ItemId = self.ItemId,
                -- Uuid = self.Content.Uuid,
                -- MenuPlacement = self.Content.MenuPlacement,
                -- UIName = self.Content.UIName,
                bCustomStype = true,
            }
            local AccessoryDefaultValue = DataMgr.GlobalConstant.EmptyCharAccessoryID.ConstantValue
            if self.Content.AccessoryId ~= AccessoryDefaultValue and self.Content.AccessoryId ~= -1 and self.ItemDetails_MenuAnchor then
                self.ItemDetails_MenuAnchor.ParentWidget = self
                self.ItemDetails_MenuAnchor:OpenItemDetailsWidget(false, Content)
                self:SetSelect()
            end
        else
            self.Content.OnClicked(self.Content.Owner)
            self:SetSelect()
        end
        if self.IsCharacterTrialMode then
            self.Content.OnClicked(self.Content.Owner)
            self:SetSelect()
        end
    end
end

function M:SetReddot(IsNew)
    self:SetIsNew(IsNew)
end

function M:SetIsNew(IsNew)
    if(IsNew)then
        self.New:SetVisibility(UIConst.VisibilityOp["HitTestInvisible"])
    else
        self.New:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

function M:SetIcon(IconPath,IsNoneIcon)
    local Icon = IconPath and LoadObject(IconPath)
    if(IsNoneIcon)then
        self.WS_Img:SetActiveWidgetIndex(1)
        if(Icon)then
            self.Icon_Accessory:SetBrushResourceObject(Icon)
        end
    else
        self.WS_Img:SetActiveWidgetIndex(0)
        if(Icon)then
            local IconDynaMaterial = self.Img_Accessory:GetDynamicMaterial()
            if(IconDynaMaterial)then
                IconDynaMaterial:SetTextureParameterValue("IconMap",Icon)
            end
        end
    end
end

function M:SetRarity(Rarity)
    if(RarityColorName[Rarity])then
        self.Img_Quality:SetBrush(self[RarityColorName[Rarity]])
    else
        self.Img_Quality:SetBrush(self[RarityColorName[0]])
    end
end

function M:InitButton()
    if not self.IsPreviewMode or self.IsCharacterTrialMode then
        return
    end
    local AccessoryDefaultValue = DataMgr.GlobalConstant.EmptyCharAccessoryID.ConstantValue
    if self.Content.AccessoryId == nil or self.Content.AccessoryId == AccessoryDefaultValue or self.Content.AccessoryId == -1 then
        self.Button_Area:SetIsEnabled(false)
    else
        self.Button_Area:SetIsEnabled(true)
    end
end

function M:SetSelect()
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
    self.Content.IsSelect = true
end

function M:SetUnSelect()
    if EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.Click) then
        EMUIAnimationSubsystem:EMStopAnimation(self, self.Click)
    end
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
    self.Content.IsSelect = false
end

function M:OnBtnHovered()
    if self.Content.IsSelect then
        return
    end
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        self:SetSelect()
    else
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Hover)
    end
end

function M:OnBtnUnhovered()
    if self.Content.IsSelect then
        return
    end
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.UnHover)
end

function M:OnBtnPressed()
    if self.Content.IsSelect then
        return
    end
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Press)
end

function M:OnAddedToFocusPath()
    if(self._OnAddedToFocusPath)then
        self._OnAddedToFocusPath(self.Owner,self.Content)
    end
end

function M:OnRemovedFromFocusPath()
    if(self._OnRemovedFromFocusPath)then
        self._OnRemovedFromFocusPath(self.Owner,self.Content)
    end
end

return M

