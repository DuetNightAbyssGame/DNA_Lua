--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR zhangdongxu
-- @DATE 2024年3月7日
--
require "UnLua"
local RougeConst = require "BluePrints.UI.UI_PC.RougeLike.RougeAchive.RougeConst"
---@class WBP_Rouge_Shop_Item_P_C:WBP_Shop_Item_Base_C
local M = Class("BluePrints.UI.Shop.WBP_Shop_Item_Base_C")

function M:Construct()
    self.bHover = false
    self.Text_SoldOut:SetText(GText("UI_SHOP_SOLDOUT"))
    self.Button_Item.OnHovered:Add(self, self.OnBtnHovered)
    self.Button_Item.OnUnhovered:Add(self, self.OnBtnUnhovered)
    self.Button_Item.OnPressed:Add(self, self.OnBtnPressed)
    self.Button_Item.OnClicked:Add(self, self.OnBtnClicked)
end

function M:Destruct()
    self:ClearListenEvent()
end

function M:OnListItemObjectSet(Content)
    self:StopAllAnimations()
    self:ResetItem()
    self.Content = Content
    self.Content.SelfWidget = self
    self.ItemId = Content.ItemId
    if not self.ItemId or not self.ItemId == 0 then
        self.Com_Item_Shop:Init(self.Content)
        self:InitEmptyItem()
        return
    end
    self.ShopId = Content.ShopId
    self.ItemType = Content.ShopItemType
    local ItemData = DataMgr["RougeLike"..self.ItemType][self.ItemId]
    -- 肉鸽商品名称
    local Name = ItemData.Name
    self.Text_Name:SetText(GText(Name))

    -- BuffIcon
    local BuffIconPath = ItemData.TypeIcon
    if self.ItemType == "Blessing" then
        self.Group_Buff:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self:SetBuffType(BuffIconPath)
    else
        self.Group_Buff:SetVisibility(ESlateVisibility.Collapsed)
    end

    --- 初始化道具框底板
    local ItemContent = {}
    ItemContent.ShopItemId = self.Content.ItemId
    ItemContent.Icon = ItemData.Icon
    ItemContent.Rarity = ItemData[self.ItemType.."Rarity"] + 2
    self.Com_Item_Shop:Init(ItemContent)

    -- 是否售罄
    self.IsSoldOut = Content.IsSoldOut
    if self.IsSoldOut then
        self.Panel_SoldOut:SetVisibility(ESlateVisibility.Visible)
    else
        self.Panel_SoldOut:SetVisibility(ESlateVisibility.Collapsed)
    end

    -- 是否可升级
    self.IsCanLevelUp = false
    self:SetIsCanLevelUp()
    
    -- 价格
    self.Discount = Content.Discount
    local Prices = ItemData.ShopPrices
    self:SetPrice(math.floor(Prices * self.Discount))
    self.RealPrices = math.floor(Prices * self.Discount)

    if Content.IsSelect then
        self:SetSelect()
    else
        self:SetUnSelect()
    end

    self:InitListenEvent()

    -- 是否已被收录
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    if Avatar.RougeLike:IsManualUnlocked(CommonConst.RougeLikeManualType[self.ItemType], self.ItemId) then
        self.Group_ArchiveSign:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.Group_ArchiveSign:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end

function M:InitListenEvent()
    -- 刷新一些基础信息
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end

    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function M:ClearListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        return
    end
    local IsGamePad = CurInputDevice == ECommonInputType.Gamepad
    if IsGamePad then
    end

    self.CurInputDeviceType = CurInputDevice
end

-- --- 设置商品图标
-- function M:SetIcon(IconPath)
--     if not IconPath then
--         return
--     end
--     if self.ItemType == "Blessing" then
--         self.WS_Item:SetActiveWidgetIndex(0)
--         self.WBP_Rouge_BlessIcon:StopAllAnimations()
--         if self.Rarity == 1 then
--             self.WBP_Rouge_BlessIcon:PlayAnimation(self.WBP_Rouge_BlessIcon.Blue)
--         elseif self.Rarity == 2 then
--             self.WBP_Rouge_BlessIcon:PlayAnimation(self.WBP_Rouge_BlessIcon.Purple)
--         elseif self.Rarity == 3 then
--             self.WBP_Rouge_BlessIcon:PlayAnimation(self.WBP_Rouge_BlessIcon.Yellow)
--         end
--         local IconDynaMaterial = self.WBP_Rouge_BlessIcon.Image_Icon:GetDynamicMaterial()
--         if(IsValid(IconDynaMaterial))then
--             IconDynaMaterial:SetTextureParameterValue("MainTex",LoadObject(IconPath))
--         end
--     elseif self.ItemType == "Treasure" then
--         self.WS_Item:SetActiveWidgetIndex(1)
--         self.Image_TreasureIcon:SetBrushResourceObject(LoadObject(IconPath))
--     end
-- end

-- --- 设置稀有度
-- function M:SetRarity(Rarity)
--     local Quality, QualityLine
--     if Rarity > 0 and Rarity <= 3 then
--         Quality = self["Img_Quality_"..Rarity]
--         QualityLine = self["Img_QualityLine_"..Rarity]
--      elseif Rarity > 3 then
--         Quality = self.Img_Quality_4
--         QualityLine = self.Img_QualityLine_4
--     end
--     self.Bg_Base2:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToLinearColor("000000CC"))
--     self.Img_Quality:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
--     self.Img_Quality:SetBrushTintColor(Quality)
--     self.Img_QualityLine:SetBrushResourceObject(QualityLine)
-- end

--- 设置是否可升级标志
function M:SetIsCanLevelUp()
    self.Group_CanUpgrade:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if self.ItemType == "Blessing" then
        local RougeLikeManager = GWorld.RougeLikeManager
        if not self.IsSoldOut then
            for Id, Count in pairs(RougeLikeManager.Blessings) do
                if Id == self.ItemId then
                    self.IsCanLevelUp = true
                    self.Group_CanUpgrade:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                end
            end
        end
    end
end

function M:SetBuffType(IconPath)
    if not IconPath then
        return
    end
    self.Image_BuffType:SetVisibility(ESlateVisibility.Visible)
    self.Image_BuffType:SetBrushResourceObject(LoadObject(IconPath))
end

function M:SetPrice(Prices)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self.Img_Currency:SetBrushResourceObject(ItemUtils.GetItemIcon(Avatar:GetCurrentRougeLikeTokenId(), "Resource"))
    self.Text_Price:SetText(Prices)
    local CurrentCount = Avatar:GetCurrentRougeLikeToken()
    if CurrentCount < Prices then
        self.Text_Price:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("DA2A4A"))
    else
        self.Text_Price:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("FFFFFF"))
    end
    self.Text_Undiscounted_Price:SetVisibility(UE4.ESlateVisibility.Collapsed)
end


function M:ResetItem()
    self.Com_Item_Shop:PlayAnimation(self.Com_Item_Shop.Normal)
    self.Group_Item:SetVisibility(ESlateVisibility.Visible)
    self.Panel_SoldOut:SetVisibility(UIConst.VisibilityOp["Collapsed"])
end


function M:SetSelect()
    -- EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
    self.Com_Item_Shop:PlayAnimation(self.Com_Item_Shop.Click)
    EventManager:FireEvent(EventID.OnRougeShopItemSelect, self.Content, self.ItemType, self.ItemId, self.ShopId, self.RealPrices, self.IsSoldOut, self.IsCanLevelUp)
    self.Content.IsSelect = true
end

function M:SetUnSelect()
    -- if EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.Click) then
    --     EMUIAnimationSubsystem:EMStopAnimation(self, self.Click)
    -- end
    -- EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
    self.Com_Item_Shop:StopAllAnimations()
    self.Com_Item_Shop:PlayAnimation(self.Com_Item_Shop.Normal)
    self.Content.IsSelect = false
end

function M:OnBtnHovered()
    if self.Content.IsSelect then
        return
    end
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        self:SetSelect()
    else
        self.Com_Item_Shop:StopAllAnimations()

        -- EMUIAnimationSubsystem:EMPlayAnimation(self, self.Hover)
        self.Com_Item_Shop:PlayAnimation(self.Com_Item_Shop.Hover)
    end
end

function M:OnBtnUnhovered()
    if self.Content.IsSelect then
        return
    end
    self.Com_Item_Shop:StopAllAnimations()

    -- EMUIAnimationSubsystem:EMPlayAnimation(self, self.UnHover)
    self.Com_Item_Shop:PlayAnimation(self.Com_Item_Shop.UnHover)
end

function M:OnBtnPressed()
    if self.Content.IsSelect then
        return
    end
    -- EMUIAnimationSubsystem:EMPlayAnimation(self, self.Press)
    self.Com_Item_Shop:PlayAnimation(self.Com_Item_Shop.Press)
end


function M:OnBtnClicked()
    if self.Content.IsSelect then
        return
    end
    self.Content.IsSelect = true
    EventManager:FireEvent(EventID.OnRougeShopItemSelect, self.Content, self.ItemType, self.ItemId, self.ShopId, self.RealPrices, self.IsSoldOut, self.IsCanLevelUp)
    -- EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
    self.Com_Item_Shop:PlayAnimation(self.Com_Item_Shop.Click)
end

function M:OnAnimationFinished(Anim)
    if Anim == self.UnHover then
        -- EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
    end
end

return M