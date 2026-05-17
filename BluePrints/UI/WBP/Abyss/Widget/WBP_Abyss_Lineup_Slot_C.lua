
local WBP_Abyss_Lineup_Slot_C = Class("BluePrints.UI.BP_EMUserWidget_C")

local DefaultSoundPath = "event:/ui/common/click_mid"

local SlotName2Type = require 'BluePrints.UI.UI_PC.Abyss.WBP_Abyss_Lineup_C'.SlotName2Type

function WBP_Abyss_Lineup_Slot_C:Construct()
    self.Checked = false 
    self.CurrentClickIsForbid = false
	self.IsForbidden = false
	self.IsEmpty = true
	self.DungeonIndex = -1
	self.WeaponType = "Melee"
    self.Icon_Item = self.Item.Image_Bg
    self.Icon_Empty = self.Item.Image_Empty
    self.Img_Quality = self.Item.Image_Quality
	self:BindButtonPerformances()
    self.Img_Quality:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function WBP_Abyss_Lineup_Slot_C:Destruct()
	self:UnBindButtonPerformances()
end

function WBP_Abyss_Lineup_Slot_C:Init(Name, LineupPage, DungeonIndex, bExpanded)
	self.SlotName = Name
    self.IsExpanded = bExpanded
	self.LineupPage = LineupPage
	self.DungeonIndex = DungeonIndex
    self.IsForbidden = false
	self.CurrentClickIsForbid = false
    self.Icon_Empty:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self:SetEmptyIcon()
	self:SetIsChecked(false)
end

function WBP_Abyss_Lineup_Slot_C:Update(Content)
	if not self:IsContentCompatible(Content) then
		self:Clear()
        return
	end

	self.Uuid = Content.Uuid
	local Uuid2SlotMap = self.LineupPage.Uuid2SlotMap
	if Uuid2SlotMap then
		Uuid2SlotMap[self.Uuid] = {
			SlotName = self.SlotName,
			DungeonIndex = self.DungeonIndex
		}
	end

	if self.IsEmpty then
		self.IsEmpty = false
		self.Icon_Empty:SetVisibility(UE4.ESlateVisibility.Collapsed)
		if self.WeaponSlot then
			self.WeaponSlot:SetForbidden(false)
		end
	end

    self:SetSoundPath(Content.Type)
    self:SetRarity(Content.Rarity)
	self:SetIcon(Content.Icon)
	self:PlayRefreshAnim()
end

function WBP_Abyss_Lineup_Slot_C:IsContentCompatible(Content)
    if not Content then
        return false
    end
    local Type = SlotName2Type[self.SlotName]
    if Content.Type == "Weapon" then
        if Type == "Weapon" then
            -- 魅影武器槽位可以装备任何类型武器
            return true
        end
        if Type == Content.Tag then
            -- 其他武器槽位只能装备Tag和自己类型相同的武器
            return true
        end
    elseif Content.Type == Type then
        return true
    end
    return false
end

function WBP_Abyss_Lineup_Slot_C:SetSoundPath(Type)
    if Type == "Char" then
        self.SoundPath = "event:/ui/armory/click_select_role"
    elseif Type == "Weapon" then
        self.SoundPath = "event:/ui/armory/click_select_weapon"
    elseif Type == "Pet" then
        self.SoundPath = "event:/ui/common/click_select_pet"
    end
end

function WBP_Abyss_Lineup_Slot_C:SetRarity(Rarity)
    if not Rarity then
        self.Img_Quality:SetVisibility(UE4.ESlateVisibility.Collapsed)
        DebugPrint("lhr@WBP_Abyss_Lineup_Slot_C:SetRarity@ 稀有度无效")
        return
    end
    if self.IsExpanded then
        self.Img_Quality:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    local IconDynaMaterial = self.Icon_Item:GetDynamicMaterial()
    if(IconDynaMaterial)then
        IconDynaMaterial:SetScalarParameterValue("Index",Rarity)
    end
end

function WBP_Abyss_Lineup_Slot_C:SetIcon(IconPath)
    if not IconPath then
        DebugPrint("lhr@WBP_Abyss_Lineup_Slot_C:SetIcon@ 图标路径无效")
        self:SetEmptyIcon()
        return
    end
	local IconDynaMaterial = self.Icon_Item:GetDynamicMaterial()
    if(IconDynaMaterial)then
        IconDynaMaterial:SetScalarParameterValue("IconMapOpacity",1)
        IconDynaMaterial:SetTextureParameterValue("IconMap",LoadObject(IconPath))
    end
end

function WBP_Abyss_Lineup_Slot_C:SetEmptyIcon()
    local IconDynaMaterial = self.Icon_Item:GetDynamicMaterial()
    if(IconDynaMaterial)then
        IconDynaMaterial:SetScalarParameterValue("IconMapOpacity",0)
    end
end

function WBP_Abyss_Lineup_Slot_C:Clear()
	if self.IsEmpty then
		return false
	end
	self.IsEmpty = true
	local Uuid2SlotMap = self.LineupPage.Uuid2SlotMap
	if Uuid2SlotMap then
		Uuid2SlotMap[self.Uuid] = nil
	end
	self.Uuid = nil
	self.WeaponType = "Melee"
	self:SetEmptyIcon()
	self.Icon_Empty:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
	self:PlayRemindAnim()
	if self.WeaponSlot then
		if self.WeaponSlot.Uuid ~= nil and self.LineupPage.UpdateSingleTeamIcon then
			self.LineupPage:UpdateSingleTeamIcon(self.WeaponSlot.Uuid, false, self.WeaponSlot.WeaponType)
		end
		self.WeaponSlot:Clear()
		self.WeaponSlot:SetForbidden(true)
	end
    self.Img_Quality:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return true
end

function WBP_Abyss_Lineup_Slot_C:Expand()
    self.IsExpanded = true
    if not self.IsEmpty then
        self.Img_Quality:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
end

function WBP_Abyss_Lineup_Slot_C:Collapse()
    self.IsExpanded = false
    if not self.IsEmpty then
        self.Img_Quality:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function WBP_Abyss_Lineup_Slot_C:OnClicked(bNotToList)
	if self.LineupPage then
		self.LineupPage:SlotSelectionChanged(self.SlotName, self.DungeonIndex, not bNotToList)
	else
		DebugPrint("lhr@WBP_Abyss_Lineup_Slot_C:OnClicked，阵容配置界面失效")
	end
end

function WBP_Abyss_Lineup_Slot_C:OnForbiddenClicked()
    UIManager(GWorld.GameInstance):ShowUITip(UIConst.Tip_CommonToast, GText("Abyss_Sigil_ConditionsAreNot"))
	return
end

-------------------------------- 按钮 绑定/解绑 相关 -----------------------------------
function WBP_Abyss_Lineup_Slot_C:BindButtonPerformances()
    self.Item.Btn_Click.OnClicked:Add(self, self.OnBtnClicked)
    self.Item.Btn_Click.OnPressed:Add(self, self.OnBtnPressed)
    self.Item.Btn_Click.OnReleased:Add(self, self.OnBtnReleased)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Item.Btn_Click.OnHovered:Add(self, self.OnBtnHovered)
        self.Item.Btn_Click.OnUnhovered:Add(self, self.OnBtnUnhovered)
    end
end

function WBP_Abyss_Lineup_Slot_C:UnBindButtonPerformances()
    if not self.Btn_Click then
        return
    end
    self.Item.Btn_Click.OnClicked:Clear()
    self.Item.Btn_Click.OnPressed:Clear()
    self.Item.Btn_Click.OnReleased:Clear()
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Item.Btn_Click.OnHovered:Clear()
        self.Item.Btn_Click.OnUnhovered:Clear()
    end
end
-------------------------------- 按钮 Click Press Release Hover UnHover Select 相关表现 -----------------------------------

----------------------------------------- 按钮 Normal -----------------------------------------------
function WBP_Abyss_Lineup_Slot_C:SwitchNormalAnimation()
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
    self.Item:StopAllAnimations()
    self.Item:PlayAnimation(self.Item.Normal)
end

----------------------------------------- 按钮 Click -----------------------------------------------
function WBP_Abyss_Lineup_Slot_C:PlayButtonClickSound()
    if self.IsEmpty then
        AudioManager(self):PlayUISound(self, DefaultSoundPath, nil, nil)
    else
        AudioManager(self):PlayUISound(self, self.SoundPath or DefaultSoundPath, nil, nil)
    end
end

function WBP_Abyss_Lineup_Slot_C:PlayButtonClickAnimation()
    self.Item:StopAllAnimations()
    self.Item:PlayAnimation(self.Item.Click)
end

function WBP_Abyss_Lineup_Slot_C:OnBtnClicked(bNotPlaySound, bNotToList)
    -- Press 时按钮的状态和现在不一样, 直接返回
    if self.CurrentClickIsForbid ~= self.IsForbidden then
        return
    end
    if self.IsForbidden == true then
        self:OnForbiddenClicked()
    else
	    if self.Checked == false then
            if not bNotPlaySound then
	           self:PlayButtonClickSound()
            end
        	self:PlayButtonClickAnimation()
	    end
        self:OnClicked(bNotToList)
    end
end
----------------------------------------- 按钮 Click -----------------------------------------------

----------------------------------------- 按钮 Press -----------------------------------------------
function WBP_Abyss_Lineup_Slot_C:PlayForbiddenButtonPressSound()
    UIUtils.PlayCommonForbiddenBtnSe(self)
end

function WBP_Abyss_Lineup_Slot_C:PlayButtonPressAnim()
    self.Item:StopAllAnimations()
    self.Item:PlayAnimation(self.Item.Press)
end

function WBP_Abyss_Lineup_Slot_C:OnBtnPressed()
	if self.Checked == true then
		return
	end
    if self.IsForbidden == true then
        self.CurrentClickIsForbid = true
        -- self:PlayForbiddenButtonPressSound()
        return
    end
    self.CurrentClickIsForbid = false
    self.IsPressing = true
    self:PlayButtonPressAnim()
end
----------------------------------------- 按钮 Press -----------------------------------------------

----------------------------------------- 按钮 Hover -----------------------------------------------
function WBP_Abyss_Lineup_Slot_C:PlayButtonHoverAnim()
    self.Item:StopAllAnimations()
    self.Item:PlayAnimation(self.Item.Hover)
end

function WBP_Abyss_Lineup_Slot_C:OnBtnHovered()
	if self.Checked == true then
		return
	end
    if self.IsForbidden == true then
        return
    end
    self.IsHovering = true
    self:PlayButtonHoverAnim()
end

function WBP_Abyss_Lineup_Slot_C:SetBtnHovered(IsHovered)
    if IsHovered then 
        self:OnBtnHovered()
    else 
        self:OnBtnUnhovered()
    end
end 

----------------------------------------- 按钮 Hover -----------------------------------------------

----------------------------------------- 按钮 Release -----------------------------------------------
function WBP_Abyss_Lineup_Slot_C:PlayButtonReleaseButHoverAnim()
    self:StopAllAnimations()
    self:PlayButtonHoverAnim()
end

function WBP_Abyss_Lineup_Slot_C:PlayButtonReleaseAndUnHoverAnim()
    self:StopAllAnimations()
    self:SwitchNormalAnimation()
end

function WBP_Abyss_Lineup_Slot_C:OnBtnReleased()
    self.IsPressing = false
	if self.Checked == true then
		return
	end
    if self.IsForbidden ~= true and not self.IsHovering then
        self:PlayButtonReleaseAndUnHoverAnim()
    elseif self.IsForbidden ~= true then
        self:PlayButtonReleaseButHoverAnim()
    end
end
----------------------------------------- 按钮 Release -----------------------------------------------

----------------------------------------- 按钮 UnHover -----------------------------------------------
function WBP_Abyss_Lineup_Slot_C:PlayButtonUnHoverAnim()
    self:StopAllAnimations()
    self:SwitchNormalAnimation()
end

function WBP_Abyss_Lineup_Slot_C:OnBtnUnhovered()
    self.IsHovering = false
	if self.Checked == true then
		return
	end
    if self.IsForbidden ~= true and not self.IsPressing then
        self:PlayButtonUnHoverAnim()
    end
end
----------------------------------------- 按钮  UnHover -----------------------------------------------

----------------------------------------- 按钮 Forbid -----------------------------------------------
function WBP_Abyss_Lineup_Slot_C:PlayButtonForbidAnim()
    self:StopAllAnimations()
    self.Item:StopAllAnimations()
    self:PlayAnimation(self.Forbidden)
    --self:PlayRemindAnim()
end

function WBP_Abyss_Lineup_Slot_C:PlayButtonUnForbidAnim()
    self:StopAllAnimations()
    self.Item:StopAllAnimations()
    if self.IsHovering then
        self:PlayButtonHoverAnim()
    else
        self:SwitchNormalAnimation()
    end
end

function WBP_Abyss_Lineup_Slot_C:SetForbidden(IsForbid)
    if IsForbid == true then
        self.IsForbidden = true
        self:PlayButtonForbidAnim()
    else
        self.IsForbidden = false
        self:PlayButtonUnForbidAnim()
    end
end
----------------------------------------- 按钮 Forbid -----------------------------------------------

----------------------------------------- 按钮 Select -----------------------------------------------

function WBP_Abyss_Lineup_Slot_C:PlayButtonSelectAnim()
    self.Item:StopAllAnimations()
    self.Item:PlayAnimation(self.Item.Select)
end
----------------------------------------- 按钮 Select -----------------------------------------------

function WBP_Abyss_Lineup_Slot_C:SetIsChecked(IsChecked)
    if self.Checked == false and IsChecked == true then
        self.Checked = true
        self:PlayButtonSelectAnim()
    elseif self.Checked == true and IsChecked == false then
        self.Checked = false
        self:SwitchNormalAnimation()
        if self.IsForbidden then
            self:PlayButtonForbidAnim()
        end
    end
end

function WBP_Abyss_Lineup_Slot_C:PlayRemindAnim()
    self:PlayAnimation(self.Remind)
end

function WBP_Abyss_Lineup_Slot_C:PlayRefreshAnim()
	self.Item:StopAllAnimations()
    self.Item:PlayAnimation(self.Item.Refresh)
end

return WBP_Abyss_Lineup_Slot_C