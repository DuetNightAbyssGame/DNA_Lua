local ModController = require "BluePrints.UI.WBP.Armory.Mod.Utils.ModController"
--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Build_Slot_P_C
local WBP_Build_Slot_P_C = Class({"BluePrints.UI.BP_EMUserWidget_C","BluePrints.Common.TimerMgr","BluePrints.Common.DelayFrameComponent"})

--function M:Initialize(Initializer)
--end

function WBP_Build_Slot_P_C:Construct()
    self:InitBtn()
    self.ItemInfo = nil
    self.Item:BindToAnimationFinished(self.Item.Click, {self, function()
        self.Item:PlayAnimation(self.Item.Select)
    end})
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function WBP_Build_Slot_P_C:InitSlot(Params)
    self.Params = Params
    self.Owner = Params.Owner
    self.Uuid = Params.Uuid
    self.Id = Params.Id
    self.Type = Params.Type or "Melee"
    self.ModSuit = Params.ModSuit
    self.Num = Params.Num
    self.Rarity = Params.Rarity
    self.IsEmpty = true
    self.IsAddSquad = Params.IsAddSquad

    if self.Uuid == "" or self.Uuid == nil then
        self.IsEmpty = true
    else
        self.IsEmpty = false
    end

    --检查是不是魅影武器 是魅影武器则获取对应魅影角色组件
    self:CheckIsPhantomWeapon()
    --是武器的话 给武器上装备图标
    self:UpdateListItemState(Params.ItemInfo)
    --检测槽位是否需要添加缺失态
    self:CheckIsNeedLackState()
    --设置装备的魔之楔名称文本
    self:SetTitleName()
    --更新图标
    self:UpdateIcon()
    --设置品质角标
    self:GetItemRarity()
    --检查是否是炫彩宠物
    self:CheckIsColorfulPet()
    --更新当前阵容数据变更信息
    self:UpdateCurSquadInfo()
    --设置可删除图标
    self:AddDelelteIcon()
    --检查点击状态
    self:CheckClick()

    self.Item:Init({
        Owner = self,
    })
end

function WBP_Build_Slot_P_C:PlayRefreshAnimation()
    if not self.IsEmpty then
        self.Item:PlayAnimation(self.Item.Refresh)
    end
end

--检查Uuid是否合法
function WBP_Build_Slot_P_C:CheckUuidIsVaild()
    if self.IsEmpty then
        return true
    end
    local Avatar = GWorld:GetAvatar()
    local IsValid = false
    if Avatar then
        if self.Type == "Char" then
            IsValid = Avatar.Chars[self.Uuid] and true
        elseif self.Type == "Pet" then
            IsValid = Avatar.Pets[self.Uuid] and true
        elseif self.Type == "Melee" then
            IsValid = Avatar.Weapons[self.Uuid] and true
        elseif self.Type == "Ranged" then
            IsValid = Avatar.Weapons[self.Uuid] and true
        end
        if not IsValid then
            self:ClearSlot()
        end
    else
        self:ClearSlot()
    end
    return IsValid
end

function WBP_Build_Slot_P_C:AddDelelteIcon()
    if self.Uuid and self.Id and self.Owner.IsInEditor then
        self.Minus.Btn_Minus.Button_Area.OnClicked:Clear()
        self.Minus.Btn_Minus.Button_Area.OnClicked:Add(self, self.ClearSlot)
        self:SwitchDeleteIconVisible()
        --self.Minus:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Minus.Btn_Minus.Button_Area.OnClicked:Clear()
        self.Minus:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function WBP_Build_Slot_P_C:CheckIsColorfulPet()
    if not (self.Uuid and self.Id and self.Item.VX_Colorful) then
        self.Item.VX_Colorful:SetVisibility(ESlateVisibility.Collapsed)
        return
    end
    if self.Type == "Pet" then
        local Premium = DataMgr.Pet[self.Id].Premium
        if Premium and Premium == 1 then
            self.Item.VX_Colorful:SetVisibility(ESlateVisibility.Visible)
        else
            self.Item.VX_Colorful:SetVisibility(ESlateVisibility.Collapsed)
        end
    else
        self.Item.VX_Colorful:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function WBP_Build_Slot_P_C:UpdateListItemState(CurItemInfo)
    if CurItemInfo and self.ItemInfo and self.ItemInfo.Uuid == CurItemInfo.Uuid then
        return
    end
    self.ItemInfo = CurItemInfo
    if CurItemInfo then
        self.ItemInfo.IsSelected = true
        if self.ItemInfo.SelfWidget then
            if self.IsPhantomWeapon then
                self.ItemInfo.SelfWidget:SetWeaponMiniPhantomIcon(self.WeaponOnwerWidget.Id)
            else
                self.ItemInfo.SelfWidget:SetInGear(self.ItemInfo.IsSelected)
            end
        end
    end
end

function WBP_Build_Slot_P_C:ClearItemFlag()
    if self.ItemInfo then
        self.ItemInfo.IsSelected = false
        if self.ItemInfo.SelfWidget then
            self.ItemInfo.SelfWidget:SetWeaponMiniPhantomIcon()
            self.ItemInfo.SelfWidget:SetInGear(self.ItemInfo.IsSelected)
        end
    end
end

function WBP_Build_Slot_P_C:ShowListItemStateOnce(CurItemInfo)
    if CurItemInfo then
        if self.IsPhantomWeapon then
            CurItemInfo.SelfWidget:SetWeaponMiniPhantomIcon(self.WeaponOnwerWidget.Id)
        else
            CurItemInfo.SelfWidget:SetInGear(true)
        end
    end
end

function WBP_Build_Slot_P_C:CheckClick()
    if self.IsClicking then
        self.Item:PlayAnimation(self.Item.Select)
    else
        self.Item:PlayAnimation(self.Item.Normal)
    end
end

function WBP_Build_Slot_P_C:UpdateCurSquadInfo()

    if self.IsPhantomWeapon and self.Num then
        self.Owner:UpdateCurSquadInfo("PhantomWeapon"..self.Num, self.Uuid or "")
    elseif self.Type == "Char" then
        self.Owner:UpdateCurSquadInfo("Phantom"..string.sub(self:GetName(), -1), self.Uuid or "")
    elseif self.Type == "Pet" then
        self.Owner:UpdateCurSquadInfo("Pet", self.Uuid or 0)
    elseif self.Type == "Melee" then
        self.Owner:UpdateCurSquadInfo("MeleeWeapon", self.Uuid or "")
        self.Owner:UpdateCurSquadInfo("MeleeWeaponModSuit", self.ModSuit or 0)
    elseif self.Type == "Ranged" then
        self.Owner:UpdateCurSquadInfo("RangedWeapon", self.Uuid or "")
        self.Owner:UpdateCurSquadInfo("RangedWeaponModSuit", self.ModSuit or 0)
    end
end

function WBP_Build_Slot_P_C:GetItemRarity()
    if not self.Id then 
        self.Item.Image_Quality:SetVisibility(ESlateVisibility.Collapsed)
        return 
    end
        
    if self.Type == "Char" then
        local CharInfo = DataMgr.Char[self.Id]
        if CharInfo then
            return self:SetItemRarity(CharInfo.CharRarity)
        end
    elseif self.Type == "Pet" then
        local PetInfo = DataMgr.Pet[self.Id]
        if PetInfo then
            self.Panel_Text:SetVisibility(ESlateVisibility.Collapsed)
            self:SetModTextBgVisbile(false)
            return self:SetItemRarity(PetInfo.Rarity)
        end
    else
        local WeaponInfo = DataMgr.Weapon[self.Id]
        if WeaponInfo then
            return self:SetItemRarity(WeaponInfo.WeaponRarity)
        end
    end
end

 --设置品质色
 function WBP_Build_Slot_P_C:SetItemRarity(Rarity)
    if Rarity then
        self.Item.Image_Bg:GetDynamicMaterial():SetScalarParameterValue("Index", Rarity)
        -- self.Item.Image_Quality:SetVisibility(ESlateVisibility.Visible)
        -- self.Item.Image_Quality:SetBrushResourceObject(self.Item["Img_Quality_"..Rarity])
    else
        self.Item.Image_Quality:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function WBP_Build_Slot_P_C:CheckIsNeedLackState()
    if self.Owner.IsInEditor or self.IsAddSquad then
        self.Panel_Lack_Phantom:SetVisibility(ESlateVisibility.Collapsed)
        self.Panel_Lack:SetVisibility(ESlateVisibility.Collapsed)
        return
    end
    if self.IsPhantomWeapon and self.WeaponOnwerWidget then
        if self.WeaponOnwerWidget.Id or self.WeaponOnwerWidget.Uuid then
            if not (self.Uuid and self.Id) then
                self.Panel_Lack_Phantom:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
                self.Text_Lack_Phantom:SetText(GText("UI_Squad_UnessentialMiss_Tips"))
            else
                self.Panel_Lack_Phantom:SetVisibility(ESlateVisibility.Collapsed)
            end
        else
            self.Panel_Lack_Phantom:SetVisibility(ESlateVisibility.Collapsed)
        end
    elseif self.Owner.PlayerForceSlot[self:GetName()] then
        if not (self.Uuid and self.Id) then
            self.Panel_Lack:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.Text_Lack:SetText(GText("UI_Squad_EssentialMiss_Tips"))
        else
            self.Panel_Lack:SetVisibility(ESlateVisibility.Collapsed)
        end
    end
end

function WBP_Build_Slot_P_C:WeakClearSlotInfo()
    self.Uuid = nil
    self.Id = nil
end

function WBP_Build_Slot_P_C:PlayNormalAnimation()
    self.Item:PlayAnimation(self.Item.Normal)
end

function WBP_Build_Slot_P_C:GetParams()
    return self.Params
end

--清空Slot
function WBP_Build_Slot_P_C:ClearSlot(IsAddSquad)
    local Params = {
        Owner = self.Owner,
        Type = self.Type,
        IsAddSquad = IsAddSquad, -- 用于判断是不是正在进行增加预设的标识，正常InitSlot是没有的
    }
    self.IsEmpty = true
    if self.ItemInfo and self.ItemInfo.SelfWidget then
        self.ItemInfo.SelfWidget:SetInGear(false)
        self.ItemInfo.SelfWidget:SetWeaponMiniPhantomIcon()
    end
    self.ItemInfo = nil
    self:InitSlot(Params)
    if self:GetName() == "Head_Phantom01" then
        self.Owner.PhantomSlot.Weapon_Phantom01:ClearSlot(IsAddSquad)
    elseif self:GetName() == "Head_Phantom02" then
        self.Owner.PhantomSlot.Weapon_Phantom02:ClearSlot(IsAddSquad)
    end
end

function WBP_Build_Slot_P_C:CheckIsPhantomWeapon()
    self.IsPhantomWeapon, self.Num = self:IsSubstringContained(self:GetName(), "Weapon_Phantom")
    if self.IsPhantomWeapon then
        self.WeaponOnwerWidget = self.Owner["Head_Phantom0"..self.Num]
    end
end

function WBP_Build_Slot_P_C:IsSubstringContained(parentStr, subStr)
    local startPos, endPos = string.find(parentStr, subStr)
    if startPos ~= nil then
        return startPos ~= nil, string.sub(parentStr, -1) 
    end
    return nil, nil
end

function WBP_Build_Slot_P_C:PlaySound()
    if self:GetName() == "Head_Phantom01" or self:GetName() == "Head_Phantom02" then
        if self.Id then
            AudioManager(self):PlayUISound(nil, "event:/ui/armory/click_select_role", nil, nil)
        else
            AudioManager(self):PlayUISound(nil, "event:/ui/common/click_mid", nil, nil)
        end
    elseif self:GetName() == "Pet" then
        if self.Id then
            AudioManager(self):PlayUISound(nil, "event:/ui/common/click_select_pet", nil, nil)
        else
            AudioManager(self):PlayUISound(nil, "event:/ui/common/click_mid", nil, nil)
        end
    else
        if self.Id then
            AudioManager(self):PlayUISound(nil, "event:/ui/armory/click_select_weapon", nil, nil)
        else
            AudioManager(self):PlayUISound(nil, "event:/ui/common/click_mid", nil, nil)
        end
    end
end

function WBP_Build_Slot_P_C:OnClickCallback()

    self:PlaySound()

    if self.Owner.IsInClickCD then
        DebugPrint("thy    InClickCD")
        return
    end

    --手柄切换聚焦区域
    if self.IsClicking then
        self.Owner:FocusOnItemList()
        return
    end

    --开启CD
    self.MyClickCD = self.Owner.ClickCD
    self.AlreadyRemoved = false
    self.Owner.IsInClickCD = true
    self:AddTimer(0.05, function()
        self.MyClickCD = math.max(self.MyClickCD - 0.05, 0)
        if self.MyClickCD == 0 and (not self.AlreadyRemoved)then
            self.Owner.IsInClickCD = false
            self.AlreadyRemoved = true
            self:RemoveTimer("ClickCD")
            return
        end
    end, true, 0, "ClickCD",true)

    if self.IsPhantomWeapon then
        if not self.WeaponOnwerWidget.Id then
            self.WeaponOnwerWidget.Item:PlayAnimation(self.WeaponOnwerWidget.Item.FlashRed)
            self.Item:StopAllAnimations()
            self.Item:PlayAnimation(self.Item.Hover)
            --弹出toast提示
            UIManager(self):ShowUITip("CommonToastMain", GText("UI_Squad_SigilMiss_Toast"))
            return
        end
        self.Owner:PhantomWeaponTypeChanged(self.Type)
    else
        self.Owner:PhantomWeaponTypeChanged()
    end

    if self.Type == "Pet" then
        self.Owner.List_Build:SetEmptyText(GText("UI_Armory_Pet_Empty"))
    elseif self.Type == "Char" then
        self.Owner.List_Build:SetEmptyText(GText("UI_Armory_Char_Empty"))
    else
        self.Owner.List_Build:SetEmptyText(GText("UI_Armory_Weapon_Empty"))
    end

    self.Owner:SwitchToSelectItemList(self, self.Type)
    --进入编辑状态需要隐藏缺失态
    self:CheckIsNeedLackState()
    self.IsClicking = true
    self.Item:PlayAnimation(self.Item.Click)
end

--设置图标
function WBP_Build_Slot_P_C:UpdateIcon()

    self.Item.Image_Bg:SetVisibility(ESlateVisibility.Visible)
    self.Item.Image_Empty:SetVisibility(ESlateVisibility.Collapsed)

    if self.Uuid == "" or self.Uuid == 0 or (not self.Uuid) or (self.Type == "Pet" and not self:GetPetId()) then
        self.Item.Image_Empty:SetVisibility(ESlateVisibility.Visible)
        self.Item.Image_Bg:GetDynamicMaterial():SetScalarParameterValue("IconMapOpacity",0)
        return
    end

    local IconPath = nil
    if self.Type == "Char" and self.Id then--角色
        IconPath = DataMgr.Char[self.Id].GUIPathVariable
    elseif self.Type == "Pet" and self.Uuid then--宠物
        IconPath = "Texture2D'"..DataMgr.Pet[self:GetPetId()].Icon.."'"
        self:SetImage(nil, IconPath)
        return
    else--武器
        if self.Id then
            IconPath = DataMgr.Weapon[self.Id].GUIPathVariableName
            --还是不存在说明策划那边没有配置地址
            if not IconPath then
                --DebugPrint("缺少图片资源: IconPath = " .. IconPath)
                return
            end
            IconPath = DataMgr.Weapon[self.Id].GUIPathVariableType.."_"..IconPath
        end
    end
    if IconPath then
        self:SetImage(IconPath)
    end
end

function WBP_Build_Slot_P_C:GetPetId()
    if self.Owner.Avatar and self.Owner.Avatar.Pets[self.Uuid] then
        return self.Owner.Avatar.Pets[self.Uuid].Props.PetId
    end
end

function WBP_Build_Slot_P_C:SetModTextBgVisbile(bShow)
    local DynamciMaterial = self.Item.Image_Bg:GetDynamicMaterial()
    if DynamciMaterial then
        DynamciMaterial:SetScalarParameterValue("TextBGOpacity", bShow and self.Item.TaskBG_Opacity or 0)
    end
end

function WBP_Build_Slot_P_C:SwitchDeleteIconVisible()
    if self.Owner.CurInputDeviceType == ECommonInputType.Gamepad then
        self.Minus:SetVisibility(ESlateVisibility.HitTestInvisible)
    else
        self.Minus:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end

--设置文本
function WBP_Build_Slot_P_C:SetTitleName()
    if not (self.Uuid and self.Id) then
        self.Panel_Text:SetVisibility(ESlateVisibility.Collapsed)
        self:SetModTextBgVisbile(false)
        return
    end
    --魅影和武器现在要需要显示材质色
    if self.Owner.PhantomSlot[self:GetName()] then
        self.Panel_Text:SetVisibility(ESlateVisibility.Collapsed)
        self:SetModTextBgVisbile(false)
        return
    else
        self.Panel_Text:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self:SetModTextBgVisbile(true)
    end
    if not self.Owner:CheckSlotTypeIsAboutMainRole(self) then
        self.Panel_Text:SetVisibility(ESlateVisibility.Collapsed)
        self:SetModTextBgVisbile(false)
        return
    end
    if not self.ModSuit then
        self.Panel_Text:SetVisibility(ESlateVisibility.Collapsed)
        self:SetModTextBgVisbile(false)
        return
    end
    self.Panel_Text:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self:SetModTextBgVisbile(true)
    ModController:SyncTarget(self.Uuid)
    local SuitName = ModController:GetModel():GetSuitName(self.ModSuit)
    self.Text_Name:SetText(SuitName)
end

function WBP_Build_Slot_P_C:GetItemId()
    return self.Uuid
end

function WBP_Build_Slot_P_C:GetIsEmpty()
    return self.IsEmpty
end

--设置图标
function WBP_Build_Slot_P_C:SetImage(ImgShortPath, ImgLongPath)
    local ImgPath, Img = nil, nil
    local FixPath  = ""
    if (ImgShortPath) then
        if self.Type == "Char" then
            FixPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Avatar/T_Head_%s.T_Head_%s'"
        else
            FixPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Weapon/T_Head_%s.T_Head_%s'"
        end
        local ReplaceKey = string.gsub(ImgShortPath, " ", "_")
        ImgPath = string.format(FixPath, ReplaceKey, ReplaceKey)
        Img = LoadObject(ImgPath)
        if (not IsValid(Img)) then
            -- 尝试去手柄目录下寻找图片
            if self._GetCurrentGamepadName then 
                ImgPath = UIUtils.UtilsGetKeyIconPathInGamepad(ImgShortPath, self:_GetCurrentGamepadName())
                Img = LoadObject(ImgPath)
            end
        end
    else
        Img = LoadObject(ImgLongPath)
    end
    if (not IsValid(Img)) then
        DebugPrint("缺少图片资源: ImgPath = " .. ImgPath)
        return
    end
    --self.Img_Item:SetBrushResourceObject(Img)
    local IconDynaMaterial = self.Item.Image_Bg:GetDynamicMaterial()
    if IconDynaMaterial then
        IconDynaMaterial:SetTextureParameterValue("IconMap",Img)
        IconDynaMaterial:SetScalarParameterValue("IconMapOpacity",1)
    end
end

----------------------------------------------------------------------------
function WBP_Build_Slot_P_C:InitBtn()
    self.Item.Btn_Click.OnClicked:Add(self, function() self:OnBtnClickClicked() end)
    self.Item.Btn_Click.OnPressed:Add(self, function() self:OnBtnClickPressed() end)
    self.Item.Btn_Click.OnHovered:Add(self, function() self:OnBtnClickHovered() end)
    self.Item.Btn_Click.OnUnhovered:Add(self, function() self:OnBtnClickUnhovered() end)
end

----------------------------点击按钮事件Start-------------------------------------
function WBP_Build_Slot_P_C:OnBtnClickClicked()
    if self.OnClickCallback then
        self:OnClickCallback()
    end
end
function WBP_Build_Slot_P_C:OnBtnClickPressed()
    if self.IsClicking then
        return
    end
    self.Item:StopAllAnimations()
    self.Item:PlayAnimation(self.Item.Press)
end
function WBP_Build_Slot_P_C:OnBtnClickHovered()
    if self.IsClicking then
        return
    end
    self.Item:StopAllAnimations()
    self.Item:PlayAnimation(self.Item.Hover)
end
function WBP_Build_Slot_P_C:OnBtnClickUnhovered()
    if self.IsClicking then
        return
    end
    self.Item:StopAllAnimations()
    self.Item:PlayAnimation(self.Item.UnHover)
end

function WBP_Build_Slot_P_C:OnFocusReceived(MyGeometry, InFocusEvent)
    if self.Owner.IsInEditor then
        if self.Owner.CurFocusSlot and (self.Owner.CurFocusSlot.Uuid and self.Owner.CurFocusSlot.Uuid ~= 0) then
            self.Owner:InitBottomTab(false, 3)
        else
            self.Owner:InitBottomTab(false, 2)
        end
    end
    return true
end
------------------------------点击按钮事件End--------------------------------

return WBP_Build_Slot_P_C
