--
-- DESCRIPTION
-- 通用阵容预设槽位Widget，用于SquadBuildComponent
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local SquadBuildComponent = require "BluePrints.UI.UI_PC.Common.SquadBuildComponent"

---@type WBP_Com_TeamBuild_Slot_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

local DefaultSoundPath = "event:/ui/common/click_mid"

function M:Construct()
    self.Checked = false
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

    self.Minus.Btn_Minus.Button_Area.OnClicked:Add(self, self.OnMinusClicked)
    self.Panel_Text:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:Destruct()
    self:UnBindButtonPerformances()
end

-- 初始化槽位
-- @param SlotName 槽位名称（ESlotName枚举值）
-- @param LineupPage SquadBuildComponent实例
function M:Init(SlotName, LineupPage)
    self.SlotName = SlotName
    self.LineupPage = LineupPage
    self.IsForbidden = false
    
    if self.Icon_Empty then
        self.Icon_Empty:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    self:SetEmptyIcon()
    self:SetIsChecked(false)
    if SlotName == SquadBuildComponent.ESlotName.Pet then
        self:PlayAnimation(self.Pet_Loop)
    else
        self:PlayAnimation(self.Pet_Off)
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
    
    -- 如果该Uuid已经被装备到其他槽位，先清除之前槽位
    if self.LineupPage and self.LineupPage.Uuid2SlotMap then
        local OldSlotInfo = self.LineupPage.Uuid2SlotMap[self.Uuid]
        if OldSlotInfo and OldSlotInfo.SlotName ~= self.SlotName then
            local OldSlotWidget = self.LineupPage.Slots and self.LineupPage.Slots[OldSlotInfo.SlotName]
            if OldSlotWidget and OldSlotWidget.Uuid == self.Uuid and OldSlotWidget.Clear then
                self.LineupPage.Uuid2SlotMap[self.Uuid] = nil
            end
        end
        -- 更新Uuid2SlotMap
        self.LineupPage.Uuid2SlotMap[self.Uuid] = { SlotName = self.SlotName }
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
    if self.SlotName == SquadBuildComponent.ESlotName.Char then
        -- 主角色槽位：优先使用GachaIcon，如果没有则使用Icon
        IconPath = Content.GachaIcon or Content.Icon
    else
        -- 魅影角色、武器、宠物：使用Icon
        IconPath = Content.Icon
    end
    self:SetIcon(IconPath)
    self:PlayRefreshAnim()

    if Content.IsTryout and Content.Tag ~= "Pet" then
        self.Text_Trial:SetText(GText("UI_Wuyousheng_ArmoryTrial"))
        self.Text_Trial:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Panel_Trial:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Text_Trial:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Panel_Trial:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end

    if Content.NeedShowModIndexInfo and Content.ModSuitIndex then
        self.Panel_Text:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        local SuitName = GText(string.format("Mod_SuitName_%s",Content.ModSuitIndex))
        self.Text_Name:SetText(SuitName)
    else
        self.Panel_Text:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end

    self.Minus:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

-- 检查内容是否兼容
function M:IsContentCompatible(Content)
    if not Content then
        return false
    end
    
    local SlotType = SquadBuildComponent.SlotName2Type[self.SlotName]
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
    self.Panel_Trial:SetVisibility(UIConst.VisibilityOp.Collapsed)
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
    self.Panel_Text:SetVisibility(UIConst.VisibilityOp.Collapsed)
    if self.Content == nil then
        return
    end
    self.IsEmpty = true
    
    -- 清除Uuid2SlotMap
    if self.LineupPage and self.LineupPage.Uuid2SlotMap and self.Uuid then
        self.LineupPage.Uuid2SlotMap[self.Uuid] = nil
    end
    
    self.Uuid = nil
    self.WeaponType = "Melee"
    self.Content.bInGear = false
    self.Content.IsChosen = false
    self.Content.WeaponMiniPhantomIconCharId = nil
    if self.Content.SelfWidget then
        self.Content.SelfWidget:SetInGear(false)
        self.Content.SelfWidget:SetWeaponMiniPhantomIcon(nil)
    end
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

    self.Minus:SetVisibility(UIConst.VisibilityOp.Collapsed)
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
    if IsForbid then
        self:PlayButtonForbidAnim()
    else
        self:PlayButtonUnForbidAnim()
    end
end

-- 点击事件
function M:OnClicked(bNotToList)
    if self.LineupPage then
        -- 调用SquadBuildComponent的OnSlotClicked方法
        if self.LineupPage.OnSlotClicked then
            self.LineupPage:OnSlotClicked(self.SlotName)
        end
    end
end

-- 禁用点击事件
function M:OnForbiddenClicked()
    UIManager(GWorld.GameInstance):ShowUITip(UIConst.Tip_CommonToast, GText("Abyss_Sigil_ConditionsAreNot"))
    
    -- 如果是魅影武器槽位，让对应的魅影角色槽位播放闪烁动画
    if self.SlotName == SquadBuildComponent.ESlotName.PhantomWeapon1 or 
       self.SlotName == SquadBuildComponent.ESlotName.PhantomWeapon2 then
        local PhantomSlotName = (self.SlotName == SquadBuildComponent.ESlotName.PhantomWeapon1) and 
                                SquadBuildComponent.ESlotName.Phantom1 or 
                                SquadBuildComponent.ESlotName.Phantom2
        
        if self.LineupPage and self.LineupPage.Slots then
            local PhantomSlot = self.LineupPage.Slots[PhantomSlotName]
            if PhantomSlot and PhantomSlot.PlayFlashRedAnim then
                PhantomSlot:PlayFlashRedAnim()
            end
        end
    end
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
    if self.Item then
        self.Item:StopAllAnimations()
    end
    if self.Normal then
        self:PlayAnimation(self.Normal)
    end
    if self.Item and self.Item.Normal then
        self.Item:PlayAnimation(self.Item.Normal)
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
    if self.Item then
        self.Item:StopAllAnimations()
    end
    if self.Click then
        self:PlayAnimation(self.Click)
    end
    if self.Item and self.Item.Click then
        self.Item:PlayAnimation(self.Item.Click)
    end
end

function M:OnBtnClicked(bNotPlaySound, bNotToList)
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
    if self.Item then
        self.Item:StopAllAnimations()
    end
    if self.Press then
        self:PlayAnimation(self.Press)
    end
    if self.Item and self.Item.Press then
        self.Item:PlayAnimation(self.Item.Press)
    end
end

function M:OnBtnPressed()
    if self.Checked == true then
        return
    end

    self.IsPressing = true
    self:PlayButtonPressAnim()
end

function M:PlayButtonHoverAnim()
    self:StopAllAnimations()
    if self.Item then
        self.Item:StopAllAnimations()
    end
    if self.Hover then
        self:PlayAnimation(self.Hover)
    end
    if self.Item and self.Item.Hover then
        self.Item:PlayAnimation(self.Item.Hover)
    end
end

function M:OnBtnHovered()
    if self.LineupPage.IsUseGamePad then
        self.LineupPage.FocusWidget = self
        if self.LineupPage.UpdateGamepadKeyInfoByHasItem then
            DebugPrint("self.IsEmpty: " .. tostring(self.IsEmpty), self.Type)
            self.LineupPage:UpdateGamepadKeyInfoByHasItem(not self.IsEmpty)
        end
    end
    if self.Checked == true then
        return
    end
    
    self.IsHovering = true
    self:PlayButtonHoverAnim()
end

function M:PlayButtonReleaseButHoverAnim()
    self:StopAllAnimations()
    if self.Item then
        self.Item:StopAllAnimations()
    end
    self:PlayButtonHoverAnim()
end

function M:PlayButtonReleaseAndUnHoverAnim()
    self:StopAllAnimations()
    if self.Item then
        self.Item:StopAllAnimations()
    end
    self:SwitchNormalAnimation()
end

function M:OnBtnReleased()
    self.IsPressing = false
    
    if self.Checked == true then
        return
    end
    
    if not self.IsHovering then
        self:PlayButtonReleaseAndUnHoverAnim()
    else
        self:PlayButtonReleaseButHoverAnim()
    end
end

function M:PlayButtonUnHoverAnim()
    self:StopAllAnimations()
    if self.Item then
        self.Item:StopAllAnimations()
    end
    self:SwitchNormalAnimation()
end

function M:OnBtnUnhovered()
    self.IsHovering = false
    
    if self.Checked == true then
        return
    end
    
    if not self.IsPressing then
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
    if self.Item and self.Item.Forbidden then
        self.Item:PlayAnimation(self.Item.Forbidden)
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
    if self.Item then
        self.Item:StopAllAnimations()
    end
    if self.Select then
        self:PlayAnimation(self.Select)
    end
    if self.Item and self.Item.Select then
        self.Item:PlayAnimation(self.Item.Select)
    end
end

function M:PlayRemindAnim()
    if self.Remind then
        self:PlayAnimation(self.Remind)
    end
    if self.Item and self.Item.Remind then
        self.Item:PlayAnimation(self.Item.Remind)
    end
end

function M:PlayRefreshAnim()
    self:StopAllAnimations()
    if self.Item then
        self.Item:StopAllAnimations()
    end
    if self.Refresh then
        self:PlayAnimation(self.Refresh)
    end
    if self.Item and self.Item.Refresh then
        self.Item:PlayAnimation(self.Item.Refresh)
    end
end

function M:PlayFlashRedAnim()
    self:StopAllAnimations()
    if self.Item then
        self.Item:StopAllAnimations()
    end
    if self.FlashRed then
        self:PlayAnimation(self.FlashRed)
    end
    if self.Item and self.Item.FlashRed then
        self.Item:PlayAnimation(self.Item.FlashRed)
    end
end

function M:OnMinusClicked()
    if not self.LineupPage or self.IsEmpty then
        return
    end
    
    -- 获取当前槽位的Content
    local CurContent = self.Content
    if not CurContent then
        return
    end
    
    -- 获取槽位类型
    local Type = SquadBuildComponent.SlotName2Type[self.SlotName]
    if not Type then
        return
    end
    
    -- 确定Type（用于后续的UpdateCurrentUuid）
    if Type == "Weapon" then
        -- 如果有Content，根据Content.Tag确定Type；否则使用WeaponType
        if CurContent and CurContent.Tag then
            Type = CurContent.Tag  -- Content.Tag 是 "Melee" 或 "Ranged"
        else
            Type = self.WeaponType or "Melee"
        end
    end
    
    -- 清空槽位
    self.LineupPage:ClearSlot(self.SlotName)
    
    -- 取消选中状态
    self.LineupPage:SetContentIsChosen(CurContent, false)
    
    -- 更新对应的CurrentUuid
    self.LineupPage:UpdateCurrentUuid(Type, nil)
    
    -- 如果取消装备的是角色，检查并更新冲突状态
    if Type == "Char" then
        self.LineupPage:UpdateCharConflict()
    end
    
    -- 触发左侧物品列表变化回调
    if self.LineupPage.OnLeftItemContentChanged then
        self.LineupPage:OnLeftItemContentChanged()
    end

    if self.LineupPage.IsUseGamePad then
        if self.LineupPage.UpdateGamepadKeyInfoByHasItem then
            self.LineupPage:UpdateGamepadKeyInfoByHasItem(not self.IsEmpty)
        end
    end
end

function M:SetLockState(IsLock)
    if IsLock then
        self.WS_Type:SetActiveWidgetIndex(1)
    else
        self.WS_Type:SetActiveWidgetIndex(0)
    end
end

return M

