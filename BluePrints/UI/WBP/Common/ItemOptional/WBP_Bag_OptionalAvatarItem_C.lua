--
-- DESCRIPTION
-- 背包自选角色、武器、魔灵弹窗
-- @COMPANY **
-- @AUTHOR ** HongYang
-- @DATE 2025-05-20 10:00:00
--

require "UnLua"

local BagCommon = require "BluePrints.UI.WBP.Bag.BagCommon"

local M = Class({"BluePrints.UI.BP_UIState_C"})

-- ItemData:
-- {
-- 必填：
--     StuffId
--     Rarity
--     Index
--     StuffName
--     StuffType
--     HaveCountNumber          拥有数量
--     StuffIcon                道具图标
--     IsCanSelect              是否可选择,默认true
-- 选填：
--     ResourceId               所消耗的道具Id
--     OptionalId               自选奖励礼包Id
--     UIName
--     ArrtIcon                 元素图标 
--     Count                    可获得道具数量
-- }

function M:Construct()
    self.Item.ItemDetails_MenuAnchor:SetLastFocusWidget(self)
    self.Item.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Add(self,self.OnMenuOpenChanged)
end

function M:Destruct()
    self.Item.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Remove(self,self.OnMenuOpenChanged)
    -- self.Btn_Check:UnBindEventOnClicked(self,self.OnBtnCheckClicked)
    -- self.Btn_Check:UnbindEventOnHover(self,self.OnBtnChooseHovered)
    -- self.Btn_Check:UnbindEventOnUnhover(self,self.OnBtnChooseUnHovered)
end

function M:Init(ItemType, ItemData, ChooseCallback, ParentWidget, ...)
    if not ItemType then return end
    if not self._components then
        if ItemType == BagCommon.OptionalItemType.Weapon then
            self._components = {
                "BluePrints.UI.WBP.Common.ItemOptional.Components.WBP_Weapon_Item_Comp_C",
            }
        elseif ItemType == BagCommon.OptionalItemType.Avatar then
            self._components = {
                "BluePrints.UI.WBP.Common.ItemOptional.Components.WBP_Char_Item_Comp_C",
            }
        elseif ItemType == BagCommon.OptionalItemType.Pet then
            self._components = {
                "BluePrints.UI.WBP.Common.ItemOptional.Components.WBP_Pet_Item_Comp_C",
            }
        end
        AssembleComponents(self)
    end
    self.ChooseCallback = ChooseCallback
    self.ParentWidget = ParentWidget
    self.ItemType = ItemType
    self.ChooseDataInfo = {ResourceId = ItemData.ResourceId, OptionalId = ItemData.OptionalId, ChooseId = ItemData.StuffId, ChooseIndex = ItemData.Index, 
                            ChooseName = ItemData.StuffName, ChooseWidget = self}
    self.Content = ItemData
    self:InitCommonView(ItemData)
    if ItemType == BagCommon.OptionalItemType.Weapon then
        self:InitSpecialView(ItemData, ...)
    elseif ItemType == BagCommon.OptionalItemType.Avatar then
        self:InitSpecialView(ItemData, ...)
    elseif ItemType == BagCommon.OptionalItemType.Pet then
        self:InitSpecialView(ItemData, ...)
    end
end

function M:InitLimitedPrizePoolItemInfo(ItemType, ItemData, ChooseCallback, ParentWidget, ...)
    self.ChooseCallback = ChooseCallback
    self.ParentWidget = ParentWidget
    self.ItemType = ItemType
    -- self.ChooseDataInfo = {ResourceId = ItemData.ResourceId, OptionalId = ItemData.OptionalId, ChooseId = ItemData.StuffId, ChooseIndex = ItemData.Index, 
    --                         ChooseName = ItemData.StuffName, ChooseWidget = self}
    self.ChooseDataInfo = ItemData
    self.ChooseDataInfo.ChooseWidget = self
    self.Content = ItemData
    self:InitCommonView(ItemData)
    local HaveCountNumber = ItemData.HaveCountNumber
    local NameWithNum = ItemData.StuffName.." × "..tostring(HaveCountNumber)
    self.Text_Name:SetText(NameWithNum)

    local UniqueType = DataMgr.RewardType[ItemType].UniqueType
    -- if UniqueType and ItemData.HaveCountNumber > 0 then
    if ItemData.HaveCountNumber > 0 then
        self.Panel_Got:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.WidgetSwitcher_Info:SetActiveWidgetIndex(3)
        self.Text_Got:SetText(GText("已拥有 待包装"))
        self.IsGotLimitedPrize = true
    else
        self.Panel_Got:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.WidgetSwitcher_Info:SetActiveWidgetIndex(1)
        self.Text_NotHold:SetText(GText("未拥有 待包装"))
        self.IsGotLimitedPrize = false
    end
    self.WidgetSwitcher_Level:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WB_Star:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

-- 初始化通用视图
function M:InitCommonView(ItemData)
    -- 名称
    self.Text_Name:SetText(ItemData.StuffName)
    -- 元素
    if (ItemData.AttrIcon) then
        if (type(ItemData.AttrIcon) == "string")then
            self.Image_Element:SetBrushResourceObject(LoadObject(ItemData.AttrIcon))
        else
            self.Image_Element:SetBrushResourceObject(ItemData.AttrIcon)
        end
        self.Image_Element:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Image_Element:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    -- 星级
    local StarNum = ItemData.Rarity
    for i = 1, BagCommon.RarityColorInfo.Yellow do
        local StarWidget = self["Star_"..i]
        if i <= StarNum then
            StarWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        else
            StarWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end
    self:SetIcon(ItemData.StuffIcon)
    self:SetRarity(ItemData.Rarity)
    self.Btn_Check:BindEventOnClicked(self,self.OnBtnCheckClicked)
    -- self.Btn_Check:BindEventOnHover(self,self.OnBtnChooseHovered)
    -- self.Btn_Check:BindEventOnUnhover(self,self.OnBtnChooseUnHovered)
    self.Button_Area.OnClicked:Add(self, self.OnBtnChooseClicked)
    self.Btn_Check.AudioEventPath = "event:/ui/common/click_btn_small"
    -- self.Button_Area.OnHovered:Add(self, self.OnBtnChooseHovered)
    -- self.Button_Area.OnUnhovered:Add(self, self.OnBtnChooseUnHovered)

    --- 关闭菜单锚
    -- if self.Item.ItemDetails_MenuAnchor then
    --     self.Item.ItemDetails_MenuAnchor:CloseItemDetailsWidget()
    -- end
end


function M:SetIcon(IconPath, bAsyncLoadIcon)
    -- 是否需要异步加载图标
    if (bAsyncLoadIcon) then
        -- self.Item.Item_BG:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self:LoadTextureAsync(IconPath,function(Texture)
            if not Texture then
                Texture = LoadObject("Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Monster/T_Head_Empty.T_Head_Empty'")
                DebugPrint(ErrorTag,string.format("用错图标路径了！！！这里用默认的图标顶一下\n 错误的路径是：%s",IconPath))
            end
            if(Texture)then
                local __IconDynaMaterial = self.Item.Item_BG:GetDynamicMaterial()
                if(__IconDynaMaterial)then
                    __IconDynaMaterial:SetTextureParameterValue("IconMap", Texture)
                end
                -- self.Item.Item_BG:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
            end
        end,"LoadIcon")
    else
        assert(IconPath, "道具框传入Icon路径为空")
        local Icon = LoadObject(IconPath)
        if not Icon then
            Icon = LoadObject("Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Monster/T_Head_Empty.T_Head_Empty'")
            DebugPrint(ErrorTag,string.format("用错图标路径了！！！这里用默认的图标顶一下\n 错误的路径是：%s",IconPath))
        end
        local DynamicMaterial = self.Item.Item_BG:GetDynamicMaterial()
        if not IsValid(DynamicMaterial) then
            DebugPrint("ZDX_DynamicMaterial不合法")
        end
        DynamicMaterial:SetTextureParameterValue("IconMap", Icon)
    end
end

function M:SetSelected(IsSelected)
    -- if self.IsSelected == IsSelected then
    --     return
    -- end
    self.IsSelected = IsSelected
    self.Item:StopAllAnimations()
    if IsSelected then
        self.Item:PlayAnimation(self.Item.Click)
        self:PlayAnimation(self.Click)
        self.Item_Select:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Item:PlayAnimation(self.Item.Normal)
        self.Item_Select:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end 
end

function M:SetRarity(Rarity)
    -- local DynamicMaterial = self.Item.Item_BG:GetDynamicMaterial()
    -- DynamicMaterial:SetScalarParameterValue("IconOpacity", 1)
    -- DynamicMaterial:SetScalarParameterValue("HoverOpacity", 1)
    -- if not IsValid(DynamicMaterial) then
    --     DebugPrint("ZDX_DynamicMaterial不合法")
    -- end
    -- --- 无品质
    -- if not Rarity or Rarity < 1 or Rarity > 5 then
    --     DynamicMaterial:SetVectorParameterValue("BGPanelColor", self.Item.Color_NoQuality)
    --     DynamicMaterial:SetScalarParameterValue("HasQualityLight", 0)
    --     DynamicMaterial:SetScalarParameterValue("QualityLineHeight", 0)
    --     return
    -- end
    -- DynamicMaterial:SetVectorParameterValue("BGPanelColor", self.Item.Color_HasQuality)
    -- DynamicMaterial:SetScalarParameterValue("HasQualityLight", 1)
    -- DynamicMaterial:SetScalarParameterValue("QualityLineHeight", 0.09)
    -- local ImgHover = self.Item["Img_Hover_"..Rarity]
    -- local QualityLine_Color = self.Item["Line_"..Rarity]
    -- local QualityLight_Color = self.Item["Light_"..Rarity]
    -- DynamicMaterial:SetTextureParameterValue("HoverTex", ImgHover)
    -- DynamicMaterial:SetVectorParameterValue("QualityLineColor", QualityLine_Color)
    -- DynamicMaterial:SetVectorParameterValue("QualityLightColor", QualityLight_Color)
    self.Item:SetRarity(Rarity)
end

function M:OnAddedToFocusPath(InFocusEvent)
    if (UIUtils.IsGamepadInput()) then
        self:OnBtnChooseHovered()
        if (self.ParentWidget) then
            self.ParentWidget:ScrollToTargetItem(self)
        end
    end
end

function M:OnRemovedFromFocusPath(InFocusEvent)
    if (UIUtils.IsGamepadInput()) then
        self:OnBtnChooseUnHovered()
    end
end

function M:CheckIsInHovered()
    return self.IsInHovered
end

function M:OnMenuOpenChanged(bIsOpen)
    self.IsShowTips = bIsOpen
    if(self.Event_OnMenuOpenChanged)then
        self.Event_OnMenuOpenChanged(self.ParentWidget, bIsOpen)
    end
end

--region 供Component重载的函数
function M:InitSpecialView(ItemData, ...)
end

function M:OnBtnCheckClicked()
     -- if (self.ParentWidget) then
    --     self.ParentWidget:HideSelf(true)
    -- end
    if (self.ParentWidget) then
        if self.ParentWidget.IsLimitedPrizePool then
            self:OnBtnCheckClickedLimitedPrizePool()
            return
        end
        self.ParentWidget:CloseDialog()
    end

    -- 跳转到展示界面
    if self.ItemType == BagCommon.OptionalItemType.Weapon then
        local BagMainPage = UIManager(self):GetUIObj("BagMain")
        UIManager(self):LoadUINew("ArmoryDetail",{
            OnCloseDelegate = {BagMainPage, BagMainPage.ReClickGoToUseConsume},
            PreviewWeaponIds = {self.Content.StuffId},
            EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
            bHideBoxBtn = true, --隐藏左下角列表展开按钮
            bNoEndCamera = true,  --不需要收场镜头
            bHideCharAppearance = true,  --隐藏角色外观
            bHideWeaponAppearance = true,  --隐藏武器外观
        })
    elseif self.ItemType == BagCommon.OptionalItemType.Avatar then
        local BagMainPage = UIManager(self):GetUIObj("BagMain")
        UIManager(self):LoadUINew("ArmoryDetail",{
            OnCloseDelegate = {BagMainPage, BagMainPage.ReClickGoToUseConsume},
            PreviewCharIds = {self.Content.StuffId},
            EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
            bHideBoxBtn = true, --隐藏左下角列表展开按钮
            bNoEndCamera = true,  --不需要收场镜头
            bHideCharAppearance = true,  --隐藏角色外观
            bHideWeaponAppearance = true,  --隐藏武器外观
        })
    elseif self.ItemType == BagCommon.OptionalItemType.Pet then
        local BagMainPage = UIManager(self):GetUIObj("BagMain")
        UIManager(self):LoadUINew("ArmoryDetail",{
            OnCloseDelegate = {BagMainPage, BagMainPage.ReClickGoToUseConsume},
            PreviewPetIds = {self.Content.StuffId},
            EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
            bHideBoxBtn = true, --隐藏左下角列表展开按钮
            bNoEndCamera = true,  --不需要收场镜头
            bHideCharAppearance = true,  --隐藏角色外观
            bHideWeaponAppearance = true,  --隐藏武器外观
        })
    end
    -- AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", "ClickCheck", nil)
    

    -- 点击显示Tips，且Tips已经显示时
    -- if (not self.Item.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor:IsOpen()) then
    --     local Content = {ItemType = self.Content.StuffType, ItemId = self.Content.StuffId, Uuid = self.Content.Uuid, 
    --                         MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight, UIName = self.Content.UIName}
    --     self.Item.ItemDetails_MenuAnchor:OpenItemDetailsWidget(false, Content)
    --     -- AudioManager(self):PlayItemSound(self, self.Id, "Click", self.Content.StuffType)
    -- end
end

function M:OnBtnCheckClickedLimitedPrizePool()
    local ParentWidget = self.ParentWidget
    local CallbackWidget = nil
    local DelegateTable = nil

    if ParentWidget then
        CallbackWidget = ParentWidget.ParentWidget
        if CallbackWidget then
            DelegateTable = {CallbackWidget, CallbackWidget.RestoreSelectWidget}
        end
        ParentWidget:StoreChooseInfo()
    end

    -- 跳转到展示界面
    if self.ItemType == BagCommon.OptionalItemType.Weapon then
        if (self.ParentWidget) then
            self.ParentWidget:CloseDialog()
        end
        UIManager(self):LoadUINew("ArmoryDetail",{
            OnCloseDelegate = DelegateTable,
            PreviewWeaponIds = {self.Content.StuffId},
            EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
            bHideBoxBtn = true, --隐藏左下角列表展开按钮
            bNoEndCamera = true,  --不需要收场镜头
            bHideCharAppearance = true,  --隐藏角色外观
            bHideWeaponAppearance = true,  --隐藏武器外观
        })
    elseif self.ItemType == BagCommon.OptionalItemType.Avatar then
        if (self.ParentWidget) then
            self.ParentWidget:CloseDialog()
        end
        UIManager(self):LoadUINew("ArmoryDetail",{
            OnCloseDelegate = DelegateTable,
            PreviewCharIds = {self.Content.StuffId},
            EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
            bHideBoxBtn = true, --隐藏左下角列表展开按钮
            bNoEndCamera = true,  --不需要收场镜头
            bHideCharAppearance = true,  --隐藏角色外观
            bHideWeaponAppearance = true,  --隐藏武器外观
        })
    elseif self.ItemType == BagCommon.OptionalItemType.Pet then
        if (self.ParentWidget) then
            self.ParentWidget:CloseDialog()
        end
        UIManager(self):LoadUINew("ArmoryDetail",{
            OnCloseDelegate = DelegateTable,
            PreviewPetIds = {self.Content.StuffId},
            EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
            bHideBoxBtn = true, --隐藏左下角列表展开按钮
            bNoEndCamera = true,  --不需要收场镜头
            bHideCharAppearance = true,  --隐藏角色外观
            bHideWeaponAppearance = true,  --隐藏武器外观
        })
    else
        if (self.ParentWidget) then
            self.ParentWidget:CloseDialog()
        end
        UIManager(self):LoadUINew("ArmoryDetail",{
            OnCloseDelegate = DelegateTable,
            PreviewPetIds = {602},
            EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
            bHideBoxBtn = true, --隐藏左下角列表展开按钮
            bNoEndCamera = true,  --不需要收场镜头
            bHideCharAppearance = true,  --隐藏角色外观
            bHideWeaponAppearance = true,  --隐藏武器外观
        })
        -- if (not self.Item.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor:IsOpen()) then
        --     local Content = {ItemType = self.Content.StuffType, ItemId = self.Content.StuffId, Uuid = self.Content.Uuid, 
        --                         MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight, UIName = self.Content.UIName}
        --     self.Item.ItemDetails_MenuAnchor:OpenItemDetailsWidget(false, Content)
        -- end
    end
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
    self:OnBtnChooseHovered()
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
    self:OnBtnChooseUnHovered()
end

function M:OnBtnChooseClicked()
    if UIUtils.IsGamepadInput() and self.IsSelected then 
        return true
    end

    if self.IsGotLimitedPrize then
        local IsForbiddenChoose = false
        local ItemData = self.ChooseDataInfo
        -- local UniqueType = DataMgr.RewardType[self.ItemType].UniqueType
        -- if UniqueType and ItemData.HaveCountNumber > 0 then
        if ItemData and ItemData.HaveCountNumber and ItemData.HaveCountNumber > 0 then
            IsForbiddenChoose = self.ParentWidget:IsForbiddenChoose()
        end
        if IsForbiddenChoose then
            -- local CallbackData = self.ChooseDataInfo
            -- CallbackData.IsCanSelect = false
            -- if (type(self.ChooseCallback) == "function") then
            --     self.ChooseCallback(self.ParentWidget, false, CallbackData)
            --     return
            -- end
            local UIManager = GWorld.GameInstance:GetGameUIManager()
            UIManager:ShowUITip(UIConst.Tip_CommonToast,"testtext   该奖励已获得" )
            return
        end
    end

    local bNewSelectState = not self.IsSelected
    self:SetSelected(bNewSelectState)
    local CallbackData = nil
    if (bNewSelectState) then
        CallbackData = self.ChooseDataInfo
    end
    if (type(self.ChooseCallback) == "function") then
        self.ChooseCallback(self.ParentWidget, bNewSelectState, CallbackData)
    end

    -- 这里角色itemtype被记录为了Avatar,但是应该读char表
    local ItemType = self.ItemType
    if self.ItemType == BagCommon.OptionalItemType.Avatar then
        ItemType = "Char"
    end
    AudioManager(self):PlayItemSound(self, self.ChooseDataInfo.ChooseId, "Click", ItemType)
    return true
end

function M:OnBtnChooseHovered()
    if (CommonUtils.GetDeviceTypeByPlatformName(self) == CommonConst.CLIENT_DEVICE_TYPE.MOBILE) then
        return
    end
    if (self.IsSelected) then
        return
    end
    if (not self.IsInHovered) then
        self.Item:StopAllAnimations()
        self.Item:PlayAnimation(self.Item.Hover)
    end
    self.IsInHovered = true
end

function M:OnBtnChooseUnHovered()
    if (CommonUtils.GetDeviceTypeByPlatformName(self) == CommonConst.CLIENT_DEVICE_TYPE.MOBILE) then
        return
    end
    if (self.IsSelected) then
        return
    end
    if (self.IsInHovered) then
        self.Item:StopAllAnimations()
        self.Item:PlayAnimation(self.Item.UnHover)
    end
    self.IsInHovered = false
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    self:AddTimer(0,function()
        if UIUtils.IsGamepadInput() then
            self:OnBtnChooseClicked()
        end
    end)
    -- if UIUtils.IsGamepadInput() then
    --     self:OnBtnChooseClicked()
    -- end
    return true
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if InKeyName == "Gamepad_FaceButton_Bottom" then
        -- 重新启用，A键领取
        -- self:OnBtnChooseClicked()
        -- IsEventHandled = true
    end
    return IsEventHandled
end

--endregion

return M
