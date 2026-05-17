--
-- DESCRIPTION
-- 通用团队构建槽位Widget，用于TeamSelectComponent
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local TeamSelectComponent = require "BluePrints.UI.UI_PC.Common.TeamSelectComponent"

---@type WBP_Com_TeamBuild_Slot_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

local DefaultSoundPath = "event:/ui/common/click_mid"

function M:Construct()
    self.Checked = false
    self.CurrentClickIsForbid = false
    self.IsForbidden = false
    self.IsEmpty = true
    self.WeaponType = "Melee"
    
    -- 初始化UI引用（根据实际蓝图结构调整）
    self.Icon_Item = self.Item and self.Item.Image_Bg or self.Image_Bg
    self.Icon_Empty = self.Item and self.Item.Image_Empty or self.Image_Empty
    self.Img_Quality = self.Item and self.Item.Image_Quality or self.Image_Quality
    
    self:BindButtonPerformances()
    
    if self.Img_Quality then
        self.Img_Quality:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function M:Destruct()
    self:UnBindButtonPerformances()
end

-- 初始化槽位
-- @param SlotName 槽位名称（ESlotName枚举值）
-- @param LineupPage TeamSelectComponent实例
function M:Init(SlotName, LineupPage)
    self.SlotName = SlotName
    self.LineupPage = LineupPage
    self.IsForbidden = false
    self.CurrentClickIsForbid = false
    
    if self.Icon_Empty then
        self.Icon_Empty:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    self:SetEmptyIcon()
    self:SetIsChecked(false)
    if SlotName == TeamSelectComponent.ESlotName.Pet then
        self.VX_Pet_Up:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.VX_OutGlow:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self:PlayAnimation(self.Pet_Loop)
    end
end

-- 更新槽位内容
-- @param Content 物品Content对象
function M:Update(Content)
    if not Content then
        self:Clear()
        return
    end
    
    -- 检查内容兼容性
    if not self:IsContentCompatible(Content) then
        self:Clear()
        return
    end
    
    self.Uuid = Content.Uuid
    self.UnitId = Content.UnitId
    self.IsTryout = Content.IsTryout or false
    self.Type = Content.Type
    
    -- 更新Uuid2SlotMap
    if self.LineupPage and self.LineupPage.Uuid2SlotMap then
        self.LineupPage.Uuid2SlotMap[self.Uuid] = {
            SlotName = self.SlotName,
        }
    end
    
    -- 更新空状态
    if self.IsEmpty then
        self.IsEmpty = false
        if self.Icon_Empty then
            self.Icon_Empty:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        -- 如果是魅影角色槽位，解除对应武器槽位的 forbidden 状态
        if self.WeaponSlot then
            self.WeaponSlot:SetForbidden(false)
        end
    end
    
    -- 设置音效路径
    self:SetSoundPath(Content.Type)
    
    -- 更新显示
    self:SetRarity(Content.Rarity)
    -- 只有主角色槽位（Char）使用GachaIcon，魅影角色和武器/宠物都使用Icon
    local IconPath = nil
    if self.SlotName == TeamSelectComponent.ESlotName.Char then
        -- 主角色槽位：优先使用GachaIcon，如果没有则使用Icon
        IconPath = Content.GachaIcon or Content.Icon
    else
        -- 魅影角色、武器、宠物：使用Icon
        IconPath = Content.Icon
    end
    self:SetIcon(IconPath)
    self:PlayRefreshAnim()

    if Content.IsTryout and Content.Tag ~= "Pet" then
        self.Text_TryOut:SetText(GText("UI_Wuyousheng_ArmoryTrial"))
        self.Text_TryOut:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.SizeBox_TryOut:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Text_TryOut:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.SizeBox_TryOut:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

-- 检查内容是否兼容
function M:IsContentCompatible(Content)
    if not Content then
        return false
    end
    
    local SlotType = TeamSelectComponent.SlotName2Type[self.SlotName]
    if not SlotType then
        return false
    end
    
    if Content.Type == "Weapon" then
        if SlotType == "Weapon" then
            -- 魅影武器槽位可以装备任何类型武器
            return true
        end
        -- 其他武器槽位需要检查Tag
        if SlotType == Content.Tag then
            return true
        end
    elseif Content.Type == SlotType then
        return true
    end
    
    return false
end

-- 设置音效路径
function M:SetSoundPath(Type)
    if Type == "Char" then
        self.SoundPath = "event:/ui/armory/click_select_role"
    elseif Type == "Weapon" then
        self.SoundPath = "event:/ui/armory/click_select_weapon"
    elseif Type == "Pet" then
        self.SoundPath = "event:/ui/common/click_select_pet"
    else
        self.SoundPath = DefaultSoundPath
    end
end

-- 设置稀有度
function M:SetRarity(Rarity)
    if not Rarity or not self.Img_Quality then
        if self.Img_Quality then
            self.Img_Quality:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        return
    end
    
    self.Img_Quality:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    
    -- 优先尝试使用Item下的动态稀有度图片（角色槽位方式）
    if self.Item then
        local RarityTexture = self.Item["Img_Quality_"..Rarity]
        if RarityTexture then
            self.Img_Quality:SetBrushResourceObject(RarityTexture)
            return
        end
    end
    
    -- 否则使用Material的Index参数（通用方式）
    if self.Icon_Item then
        local IconDynaMaterial = self.Icon_Item:GetDynamicMaterial()
        if IconDynaMaterial then
            IconDynaMaterial:SetScalarParameterValue("Index", Rarity)
        end
    end
end

-- 设置图标
function M:SetIcon(IconPath)
    if not IconPath or not self.Icon_Item then
        self:SetEmptyIcon()
        return
    end
    
    local IconDynaMaterial = self.Icon_Item:GetDynamicMaterial()
    if IconDynaMaterial then
        IconDynaMaterial:SetTextureParameterValue("IconMap", LoadObject(IconPath))
        IconDynaMaterial:SetScalarParameterValue("IconMapOpacity", 1)
        IconDynaMaterial:SetScalarParameterValue("BGLightHeight", 0)
    end
end

-- 设置空图标
function M:SetEmptyIcon()
    if not self.Icon_Item then
        return
    end
    self.SizeBox_TryOut:SetVisibility(UIConst.VisibilityOp.Collapsed)
    local IconDynaMaterial = self.Icon_Item:GetDynamicMaterial()
    if(IconDynaMaterial)then
        IconDynaMaterial:SetScalarParameterValue("IconMapOpacity",0)
        IconDynaMaterial:SetScalarParameterValue("BGLightHeight", 1)
    end
    if not self.Select then
        self:PlayAnimation(self.Normal)
    end
end

-- 清空槽位
function M:Clear()
    if self.IsEmpty then
        return false
    end
    
    self.IsEmpty = true
    
    -- 清除Uuid2SlotMap
    if self.LineupPage and self.LineupPage.Uuid2SlotMap and self.Uuid then
        self.LineupPage.Uuid2SlotMap[self.Uuid] = nil
    end
    
    self.Uuid = nil
    self.WeaponType = "Melee"
    self.Content.bSelectTag = false
    self.Content = nil  -- 清空Content引用
    
    self:SetEmptyIcon()
    
    if self.Icon_Empty then
        self.Icon_Empty:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    
    if self.Img_Quality then
        self.Img_Quality:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    
    -- 如果是魅影角色槽位，清除对应武器槽位并设置为 forbidden
    if self.WeaponSlot then
        if self.WeaponSlot.Uuid and self.LineupPage and self.LineupPage.UpdateSingleTeamIcon then
            self.LineupPage:UpdateSingleTeamIcon(self.WeaponSlot.Uuid, false, self.WeaponSlot.WeaponType)
        end
        self.WeaponSlot:Clear()
        self.WeaponSlot:SetForbidden(true)
    end
    
    self:PlayRemindAnim()
    
    return true
end

-- 设置选中状态
function M:SetIsChecked(IsChecked)
    if self.Checked == IsChecked then
        return
    end
    
    self.Checked = IsChecked
    if IsChecked then
        self:PlayButtonSelectAnim()
    else
        self:SwitchNormalAnimation()
        if self.IsForbidden then
            self:PlayButtonForbidAnim()
        end
    end
end

-- 设置禁用状态
function M:SetForbidden(IsForbid)
    if self.IsForbidden == IsForbid then
        return
    end
    
    self.IsForbidden = IsForbid
    self.Btn_Click:SetForbidden(IsForbid)
    if IsForbid then
        self:PlayButtonForbidAnim()
    else
        self:PlayButtonUnForbidAnim()
    end
end

-- 点击事件
function M:OnClicked(bNotToList)
    if self.LineupPage then
        -- 调用TeamSelectComponent的OnSlotClicked方法
        if self.LineupPage.OnSlotClicked then
            self.LineupPage:OnSlotClicked(self.SlotName)
        end
        if self.LineupPage.IsUseGamePad then
            self.LineupPage:ChangeFocusMode(2)
            self.LineupPage.FocusWidget = self
            self.LineupPage:AddTimer(0.1, function()
                self.LineupPage.List_Select:SetFocus()
            end)
        end
    end
end

-- 禁用点击事件
function M:OnForbiddenClicked()
    UIManager(GWorld.GameInstance):ShowUITip(UIConst.Tip_CommonToast, GText("Abyss_Sigil_ConditionsAreNot"))
end

-------------------------------- 按钮 绑定/解绑 相关 -----------------------------------
function M:BindButtonPerformances()
    local Btn = self.Item and self.Item.Btn_Click or self.Btn_Click
    if not Btn then
        return
    end
    
    Btn.OnClicked:Add(self, self.OnBtnClicked)
    Btn.OnPressed:Add(self, self.OnBtnPressed)
    Btn.OnReleased:Add(self, self.OnBtnReleased)
    
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        Btn.OnHovered:Add(self, self.OnBtnHovered)
        Btn.OnUnhovered:Add(self, self.OnBtnUnhovered)
    end
end

function M:UnBindButtonPerformances()
    local Btn = self.Item and self.Item.Btn_Click or self.Btn_Click
    if not Btn then
        return
    end
    
    Btn.OnClicked:Clear()
    Btn.OnPressed:Clear()
    Btn.OnReleased:Clear()
    
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        Btn.OnHovered:Clear()
        Btn.OnUnhovered:Clear()
    end
end

-------------------------------- 按钮动画相关 -----------------------------------
function M:SwitchNormalAnimation()
    self:StopAllAnimations()
    if self.Normal then
        self:PlayAnimation(self.Normal)
    end
end

function M:PlayButtonClickSound()
    if self.IsEmpty then
        AudioManager(self):PlayUISound(self, DefaultSoundPath, nil, nil)
    else
        AudioManager(self):PlayUISound(self, self.SoundPath or DefaultSoundPath, nil, nil)
    end
end

function M:PlayButtonClickAnimation()
    self:StopAllAnimations()
    if self.Click then
        self:PlayAnimation(self.Click)
    end
end

function M:OnBtnClicked(bNotPlaySound, bNotToList)
    -- Press时按钮的状态和现在不一样, 直接返回
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

function M:PlayButtonPressAnim()
    self:StopAllAnimations()
    if self.Press then
        self:PlayAnimation(self.Press)
    end
end

function M:OnBtnPressed()
    if self.Checked == true then
        return
    end
    
    if self.IsForbidden == true then
        self.CurrentClickIsForbid = true
        return
    end
    
    self.CurrentClickIsForbid = false
    self.IsPressing = true
    self:PlayButtonPressAnim()
end

function M:PlayButtonHoverAnim()
    self:StopAllAnimations()
    if self.Hover then
        self:PlayAnimation(self.Hover)
    end
end

function M:OnBtnHovered()
    if self.Checked == true then
        return
    end
    
    if self.IsForbidden == true then
        return
    end
    
    self.IsHovering = true
    self:PlayButtonHoverAnim()
end

function M:PlayButtonReleaseButHoverAnim()
    self:StopAllAnimations()
    self:PlayButtonHoverAnim()
end

function M:PlayButtonReleaseAndUnHoverAnim()
    self:StopAllAnimations()
    self:SwitchNormalAnimation()
end

function M:OnBtnReleased()
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

function M:PlayButtonUnHoverAnim()
    self:StopAllAnimations()
    self:SwitchNormalAnimation()
end

function M:OnBtnUnhovered()
    self.IsHovering = false
    
    if self.Checked == true then
        return
    end
    
    if self.IsForbidden ~= true and not self.IsPressing then
        self:PlayButtonUnHoverAnim()
    end
end

function M:PlayButtonForbidAnim()
    self:StopAllAnimations()
    if self.Item then
        self.Item:StopAllAnimations()
    end
    
    if self.Forbidden then
        self:PlayAnimation(self.Forbidden)
    end
end

function M:PlayButtonUnForbidAnim()
    self:StopAllAnimations()
    if self.Item then
        self.Item:StopAllAnimations()
    end
    
    if self.IsHovering then
        self:PlayButtonHoverAnim()
    else
        self:SwitchNormalAnimation()
    end
end

function M:PlayButtonSelectAnim()
    self:StopAllAnimations()
    if self.Select then
        self:PlayAnimation(self.Select)
    end
end

function M:PlayRemindAnim()
    if self.Remind then
        self:PlayAnimation(self.Remind)
    end
end

function M:PlayRefreshAnim()
    self:StopAllAnimations()
    if self.Refresh then
        self:PlayAnimation(self.Refresh)
    end
end

return M

