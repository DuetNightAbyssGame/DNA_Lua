--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Armory_AppearanceItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C",})
M._components = {"BluePrints.UI.BP_EMUserWidgetUtils_C",}

--function M:Initialize(Initializer)
--end

local RarityColorName = {
    [6] = "Img_Quality_Red",
    [5] = "Img_Quality_Gold",
    [4] = "Img_Quality_Purple",
    [3] = "Img_Quality_Blue",
}

function M:Construct()
    self:PlayAnimation(self.Stain_Out,0,1,0,1000)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:OnListItemObjectSet(Content)
    rawset(Content,"Widget",self)
    rawset(self,"Content",Content)
    rawset(self,"Owner",Content.Owner)
    rawset(self,"_OnAddedToFocusPath",Content.OnAddedToFocusPath)
    rawset(self,"_OnRemovedFromFocusPath",Content.OnRemovedFromFocusPath)
    rawset(self,"IsPreviewMode",Content.IsPreviewMode)
    rawset(self,"bFormPersonalPage",Content.bFormPersonalPage)
    rawset(self,"IsCharacterTrialMode",Content.IsCharacterTrialMode)
    rawset(self,"IsTargetUnowned",Content.IsTargetUnowned)
    rawset(self,"bSelectTag",Content.bSelectTag)
    rawset(self,"bDyeable",Content.bDyeable)
    rawset(self,"Type",Content.Type)
    rawset(self,"ItemType",Content.ItemType)
    rawset(self,"DyeInfos",Content.DyeInfos)
    rawset(self,"DyePlanIndex",Content.DyePlanIndex)
    rawset(self,"SpecialColor",Content.SpecialColor)
    rawset(self,"ItemId",Content.ItemId)
    rawset(self,"TipType",Content.TipType)
    rawset(self,"LockType",Content.LockType)
    rawset(self,"Rarity",Content.Rarity)
    rawset(self,"NoState",Content.NoState)
    rawset(self,"bHasGot",Content.bHasGot)
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
    if(rawget(Content,"IsEmpty"))then
        self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.WS_State:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.WS_Img:SetActiveWidgetIndex(1)
    else
        self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.WS_State:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.WS_Img:SetActiveWidgetIndex(0)
    end
    self:SetIcon(Content.IconPath or Content.Icon)
    self:SetDyeable(Content.bDyeable)
    self:SetRarity(Content.Rarity)
    --self:InitPreviewView() -- 先注掉等蓝图加控件
    self:InitTextStyle()
    self:SetReddot(Content.RedDotType)
    self:SetSelected(Content.IsSelect)
end

function M:SetReddot(RedDotType)
    if (RedDotType == UIConst.RedDotType.NewRedDot)then
        self.New:SetVisibility(UIConst.VisibilityOp["HitTestInvisible"])
    else
        self.New:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

function M:SetItemSelect(bSelectTag)
    self.bSelectTag = bSelectTag
    self:InitTextStyle()
end

function M:SetRarity(Rarity)
    if(RarityColorName[Rarity])then
        self.Img_Quality:SetBrush(self[RarityColorName[Rarity]])
    end
end

function M:InitTextStyle()
    if(self.NoState)then
        self.WS_State:SetVisibility(UIConst.VisibilityOp.Collapsed)
        return
    end
    
    if(self.ItemType == CommonConst.DataType.Skin)then
        if(self.bSelectTag)then
            self.Text_Disable:SetText(GText("UI_Skin_NoChar"))
        else
            self.Text_Disable:SetText(GText("UI_Skin_Forbid"))
        end
    else
        if(self.bSelectTag)then
            self.Text_Disable:SetText(GText("UI_Skin_NoWeapon"))
        else
            self.Text_Disable:SetText(GText("UI_Skin_Forbid"))
        end
    end
    
    self.WS_State:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    if(self.bSelectTag)then
        if(self.IsCharacterTrialMode)then
            self.WS_State:SetActiveWidgetIndex(1)
            self.Text_TryOut:SetText(GText("UI_CharPreview_Accessory_In_Trial"))
        elseif(self.IsTargetUnowned)then
            self.WS_State:SetActiveWidgetIndex(3)
        else
            self.WS_State:SetActiveWidgetIndex(0)
        end
        self:StopAnimation(self.Lock)
        self:PlayAnimation(self.Locked_Normal)
    elseif (self.LockType) then
        self.WS_State:SetActiveWidgetIndex(2)
        self:StopAnimation(self.Locked_Normal)
        self:PlayAnimation(self.Lock)
    elseif(self.IsTargetUnowned)then
        self.WS_State:SetActiveWidgetIndex(3)
    elseif (self.bHasGot) then
        self.WS_State:SetActiveWidgetIndex(4)
        self.Text_Have:SetText(GText("UI_SHOP_ALREADYOWNED"))
    else
        self.WS_State:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self:StopAnimation(self.Lock)
        self:PlayAnimation(self.Locked_Normal)
    end
end

function M:BP_OnEntryReleased()
    if (self.Content) then
        self.Content.Widget = nil
    end
end

function M:OnClicked()
    if(not self.Content)then 
        return
    end
    AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_large", nil, nil)
    if (self.Content and self.Content.OnClicked) then
        if self.bFormPersonalPage then
            -- 显示外观tip
            local Content = {
                ItemType = self.TipType,
                ItemId = self.ItemId,
                -- Uuid = self.Content.Uuid,
                -- MenuPlacement = self.Content.MenuPlacement,
                -- UIName = self.Content.UIName,
                bCustomStype = true,
            }
            -- 因为武器会获取不到ItemId DataMgr.WeaponSkin[SkinId] 拿不到
            if self.ItemId ~= nil and self.ItemId ~= -1  and self.ItemDetails_MenuAnchor then
                self.ItemDetails_MenuAnchor.ParentWidget = self
                self.ItemDetails_MenuAnchor:OpenItemDetailsWidget(false, Content)
            end
        else
            self.Content.OnClicked(self.Owner,self.Content)
        end
    end
end

function M:SetIcon(IconPath)
    local IconDynaMaterial = self.Img_Avatar:GetDynamicMaterial()
    if(IconDynaMaterial and IconPath)then
        IconDynaMaterial:SetTextureParameterValue("IconMap",LoadObject(IconPath))
    end
end

function M:SetDyeable(bDyeable)
    if bDyeable then
        self.Tag_Dye:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
        self.Tag_Dye:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

-- 初始化皮等级
function M:InitSkinLevel()
    self.Panel_Level:SetVisibility(UIConst.VisibilityOp["Collapsed"])

    local Content = self.Content
    local Condition1 = (Content.Type == "Char") and (Content.ItemId)
    local Condition2 = (Content.CharId) and (Content.SkinId)

    local SkinId = (Condition1 or Condition2)
    if not SkinId then
        return
    end

    local CharId = (DataMgr.Skin[SkinId]) and (DataMgr.Skin[SkinId].CharId)
    if not CharId then
        return
    end

    -- 皮肤可以升级
    local SKinUpData = DataMgr.SkinUpgrade[SkinId]
    if not SKinUpData then
        return
    end

    self:UpdateSKinLevel(1)

    local Avatar = GWorld:GetAvatar()
    if(not Avatar or not Avatar.CommonChars)then
        return
    end

    -- 已拥有该皮肤
    local CommonChar = Avatar.CommonChars[CharId]
    local SkinData = CommonChar and CommonChar.OwnedSkins[SkinId]
    if not SkinData then
        return
    end

    self:UpdateSKinLevel(SkinData.SelectedLevel or SkinData.Level)
end

-- 更新皮肤等级
function M:UpdateSKinLevel(Level)
    if Level < 1 then
        self.Panel_Level:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        return
    end

    self.Panel_Level:SetVisibility(UIConst.VisibilityOp["HitTestInvisible"])
    self.Text_Level:SetText(Level)
end

-- 适配预览界面
function M:InitPreviewView()
    if not self.bFormPersonalPage then
        return
    end

    if self.bDyeable then
        self.DefaultColorId = DataMgr.GlobalConstant[self.Type.."DefaultColor"].ConstantValue
        if self.SpecialColor ~= nil and DataMgr.SpecialSwatch[self.SpecialColor] then
            -- 武器特殊染色
            local MaterialInstance = LoadObject(DataMgr.SpecialSwatch[self.SpecialColor].MaterialPath)
            self.Image_SPDye:SetBrushResourceObject(MaterialInstance)
            self.List_Color:SetVisibility(UIConst.VisibilityOp["Collapsed"])
            self.Image_SPDye:SetVisibility(UIConst.VisibilityOp["HitTestInvisible"])
        else
            -- 普通染色
            self.List_Color:ClearListItems()
            local DyeDetialInfo
            if self.DyeInfos == nil or self.DyeInfos:Length() == 0
            or self.DyeInfos[self.DyePlanIndex] == nil or self.DyeInfos[self.DyePlanIndex]:Length() == 0 then
                DyeDetialInfo = self:CreateDefaultSkin().Colors
            else
                DyeDetialInfo = self.DyeInfos[self.DyePlanIndex]
            end
            for index, ColorIndex in ipairs(DyeDetialInfo) do
                local Content =  NewObject(UIUtils.GetCommonItemContentClass())
                Content.ColorId = ColorIndex
                self.List_Color:AddItem(Content)
            end
            self.List_Color:SetVisibility(UIConst.VisibilityOp["HitTestInvisible"])
            self.Image_SPDye:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        end
    else
        self.List_Color:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

-- 获取默认配色
function M:CreateDefaultSkin()
    local ColorPartCount = DataMgr.GlobalConstant[self.Type.."ColorPart"].ConstantValue
    local Skin = {Colors = {}, SpecialColor = self.DefaultColorId}
    for i = 1, ColorPartCount, 1 do
        Skin.Colors[i] = self.DefaultColorId
    end
    return Skin
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

function M:SetSelected(IsSelected)
    if(IsSelected)then
        self:SetSelect()
    else
        self:SetUnSelect()
    end
end

function M:SetIsSelected(IsSelected)
    if(IsSelected)then
        self:SetSelect()
    else
        self:SetUnSelect()
    end
end

function M:SetSelect()
    if self.IsPreviewMode then
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Select_Click)
    else
        EMUIAnimationSubsystem:EMStopAnimation(self, self.Normal)
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
    end
end

function M:SetUnSelect()
    if EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.Click) then
        EMUIAnimationSubsystem:EMStopAnimation(self, self.Click)
    end
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
end

function M:OnBtnHovered()
    if not self.Content or self.Content.IsSelect then
        return
    end
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        self:SetSelect()
    elseif self.CurInputDeviceType == ECommonInputType.Touch then
        return
    else
        AudioManager(self):PlayUISound(nil, "event:/ui/common/hover_btn_large", nil, nil)
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Hover)
    end
end

function M:OnBtnUnhovered()
    if self.Content.IsSelect then
        return
    end
    if self.CurInputDeviceType == ECommonInputType.Touch then
        return
    end
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
end

function M:OnBtnReleased()
    if self.Content.IsSelect then
        return
    end
    EMUIAnimationSubsystem:EMStopAnimation(self, self.Press)
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
end

function M:OnBtnPressed()
    if self.Content.IsSelect then
        return
    end
    EMUIAnimationSubsystem:EMStopAnimation(self, self.Normal)
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Press)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self.Button_Area)
end

AssembleComponents(M)

return M

