--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Mounts_License_DialogItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Key_Consume:SetVisibility(UIConst.VisibilityOp.Collapsed)
    EventManager:AddEvent(EventID.OnGetLicense, self, self.OnGetLicense)
    self:BindLicenseItemBtnEvent()
end

function M:OnGetLicense()
    self:InitLicenseUI()
end

function M:InitLicenseItem(LicenseId, Parent)
    self.LicenseId = LicenseId
    self.ParentWidget = Parent
    self:InitLicenseUI()
    self:OnUpdateUIStyleByInputTypeChange()
end

function M:OnUpdateUIStyleByInputTypeChange()
end

function M:InitLicenseUI()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local IsFake = self.LicenseId == 0
    if IsFake then
        self.WS_State:SetActiveWidgetIndex(2)
        self.Text_Area:SetText(GText("UI_REGISTER_COMINGSOON"))
    else
        local ConfigData = DataMgr.FlyLicense[self.LicenseId]
        self.Text_Area:SetText(GText(ConfigData.Name))
        local Obj = LoadObject(ConfigData.Photo)
        local IconDynaMaterial = self.Img_Cover:GetDynamicMaterial()
        if IconDynaMaterial then
            IconDynaMaterial:SetTextureParameterValue("MainTex", Obj)
        end
        IconDynaMaterial = self.Img_Cover_UnActivate:GetDynamicMaterial()
        if IconDynaMaterial then
            IconDynaMaterial:SetTextureParameterValue("MainTex", Obj)
        end
        if Avatar:HasMountLicenseById(self.LicenseId) then
            self.WS_State:SetActiveWidgetIndex(0)
            self.Text_Activated:SetText(GText("UI_Mount_Activated"))
            self.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
        else
            local Resource = ConfigData.Resource and Avatar.Resources[ConfigData.Resource[1]]
            self.WS_State:SetActiveWidgetIndex(1)
            local ResRarity = ItemUtils.GetItemRarity(ConfigData.Resource[1], "Resource")
            local ResourceIcon = ItemUtils.GetItemIconPath(ConfigData.Resource[1], "Resource")
            self.Icon_Piece:Init({
                UIName = "MountLicense",
                IsShowDetails = true,
                Id = ConfigData.Resource[1],
                ItemType = "Resource",
                Rarity = ResRarity,
                Icon = ResourceIcon,
            })
            local Count = Resource and Resource.Count or 0
            self.Num_Hold:SetText(Count)
            self.Num_Need:SetText("1")
            self.Reddot:SetVisibility(Avatar:HasLicenseResource(self.LicenseId) and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
            if Count < 1 then
                self.Num_Hold:SetColorAndOpacity(self.Color_NotEnough)
            else
                self.Num_Hold:SetColorAndOpacity(self.Color_Normal)
            end
        end
    end
end

function M:BindLicenseItemBtnEvent()
    self:UnBindLicenseBtnEvent()
    self.Btn_Area.OnClicked:Add(self, self.OnLicenseItemBtn_OnClicked)
    self.Btn_Area.OnHovered:Add(self, self.OnLicenseItemBtn_OnHovered)
    self.Btn_Area.OnUnhovered:Add(self, self.OnLicenseItemBtn_OnUnhovered)
    self.Btn_Area.OnPressed:Add(self, self.OnLicenseItemBtn_OnPressed)
end

function M:OnLicenseItemBtn_OnClicked()
    if self.LicenseId == 0 then
        return 0
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Click)
    UIManager(self):LoadUINew("MountLicenseUnlockDialog", self.LicenseId, self)
    AudioManager(self):PlayUISound(self, "event:/ui/common/battle_pass_btn_click_mid", nil, nil)
end

function M:OnLicenseItemBtn_OnHovered()
    if self.LicenseId == 0 then
        return 0
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
end

function M:OnLicenseItemBtn_OnUnhovered()
    if self.LicenseId == 0 then
        return 0
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.UnHover)
end

function M:OnLicenseItemBtn_OnPressed()
    if self.LicenseId == 0 then
        return 0
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Press)
end

function M:OnAnimationFinished(Animation)
    if Animation == self.UnHover then
        self:PlayAnimation(self.Normal)
    end
end

function M:Destruct()
    EventManager:RemoveEvent(EventID.OnGetLicense, self)
    self:UnBindLicenseBtnEvent()
end

function M:UnBindLicenseBtnEvent()
    self.Btn_Area.OnClicked:Clear()
    self.Btn_Area.OnHovered:Clear()
    self.Btn_Area.OnUnhovered:Clear()
    self.Btn_Area.OnPressed:Clear()
end

return M
