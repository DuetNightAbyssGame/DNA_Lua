local ModModel = ModController:GetModel()
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"

---@class ModLevelUp_Comp:WBP_Armory_Intensify_P_C
local Component = {}

function Component:InitLevelUpComp(...)
    ModController:RegisterEvent(self)
    
    self.Panel_Max:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Text_Max:SetText(GText("Max_Level_Achieved"))
    self.Panel_Element:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Panel_Mod:SetVisibility(UIConst.VisibilityOp.Visible)
    self.PanelModSlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Panel_Mod)
    self.Panel_Info:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Stats:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WidgetSwitcher_Mode:SetActiveWidgetIndex(0)
    self.Selective_Listing:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)

    self.Btn_Upgrade:SetText(GText("UI_FUNC_LEVELUP"))
    self.Btn_Upgrade:SetDefaultGamePadImg("Y")
    self.Btn_Upgrade:BindEventOnClicked(self, self.OnBtnUpgradeClick)
    -- self.Btn_Upgrade:BindForbidStateExecuteEvent(self, function()
    --     if self.bDisableWarning then return end
    --     ModController:ShowToast(GText("UI_Mod_Toast_ResourceLack"))
    -- end)
    self:InitTab(GText("UI_Armory_Mod")..GText("UI_FUNC_LEVELUP").."/"..GText(self.Target:GetName()))
    self:ShowWarning(false)


    local User,Target,SubWidget,Params = ...
    ---@type Mod
    self.Target = Target
    self.Type = User or Target:GetTypeName()
    self.CurrentMode = Params.BehaviourType
    self.PreviewLevel = self.Target.Level +1
    self.bTakeOff = false
    self:InitLevelUpWidget()
    self:AddTimer(0.2, self.RefreshBaseInfo)

    self:UpdateTopResourceBar()
end

function Component:OnBtnUpgradeClick()
    if self.CurrentMode ~= ModCommon.LevelUp then return end
    if self.bDisableWarning then return end
    if not self.CanUpgrade then
        ModController:ShowToast(GText("UI_Mod_Toast_ResourceLack"))
        return
    end
    local Callback = function() 
        ModController:SendModLevelUp(self.Target, self.PreviewLevel, self.bTakeOff)
    end
    ModController:TryOpenOverCostWarningDialog(self.Target, self.PreviewLevel, Callback, self)
end

function Component:InitLevelUpWidget()
    if not self.LevelUpWidget then
         ---@type WBP_Armory_Upgrade_C
        self.LevelUpWidget = self:CreateWidgetNew(ModCommon.ModLevelUp)
        self.VB_Node:AddChild(self.LevelUpWidget)
    end
    local Params = {
        Parent = self, Target = self.Target, Type = self.Type,
        NowLevel = self.Target.Level,
        MaxLevel = self.Target.MaxLevel,
        MinLevel = self.PreviewLevel,
    }
    self.LevelUpWidget:SetCallbacks({
        OnBtnClickCallback = self.OnLevelChangeBtnClick,
        OnLevelUpSuccessCallback = self.OnLevelUpSuccessCallback,
        OnLevelUpAnimFinishedCallback = self.OnLevelUpAnimFinishedCallback,
        OnLevelUpFinalCallback = self.Close
    })
    self.LevelUpWidget:Init(Params)

    
    self:SetModDataUI()
    self:PlayModUICameraAnim()
    
end

function Component:ReceiveEnterStateComp()
    self:UpdateResourceUI()
end

function Component:UpdateResourceUI(bEmpty)
    local Count = 0
    local MaxCount = self.Item_1:GetParent():GetChildrenCount()
    if not bEmpty then
        local ResourceUse = self.Target:GetLevelUpItems(self.Target.Level, self.PreviewLevel)
        local Avatar = ModModel:GetAvatar()
        local CanUpgrade = Avatar:CheckEnough(ResourceUse)
        -- self.Btn_Upgrade:ForbidBtn(not CanUpgrade)
        self.CanUpgrade = CanUpgrade
        if self.PreviewLevel < self.Target.MaxLevel and self:CheckCanUpgrade(self.PreviewLevel + 1) then
            self.LevelUpWidget:ForbidIncBtn(false)
        else
            self.LevelUpWidget:ForbidIncBtn(true)
        end
        for ResourceId, ResCount in pairs(ResourceUse) do
            if Count >= MaxCount then
                self.LevelUpWidget:ForbidIncBtn(true)
                DebugPrint(ErrorTag,LXYTag,"所需升级道具的种类已经超过上限了！！！")
                break
            end
            Count = Count+1
            local OwnedResource = Avatar.Resources[ResourceId]
            local ResourceConf = DataMgr.Resource[ResourceId]
            local FakeContent = {
                ItemType = CommonConst.DataType.Resource,
                Id = ResourceId,
                NeedCount = ResCount or 0,
                Count = OwnedResource and OwnedResource.Count or 0,
                Icon = ResourceConf.Icon,
                Rarity = ResourceConf.Rarity or 1,
                IsShowDetails = true,
                MenuPlacement = EMenuPlacement.MenuPlacement_MenuLeft,
            }
            self["Item_"..Count]:Init(FakeContent)
            local Events = {}
            Events.OnMenuOpenChanged = self.ItemMenuAnchorChanged
            self["Item_"..Count]:BindEvents(self, Events)
        end
    end
    for i = Count+1, MaxCount do
        self["Item_"..i]:Init({Id = 0, UnitId = 0})
    end
end

function Component:OnLevelChangeBtnClick(PreviewLevel)
    local Attrs, ComparedAttrs = {}, {}
    self.PreviewLevel = PreviewLevel
    self:UpdateModCostUI(Attrs, ComparedAttrs, self.PreviewLevel)
    self:UpdateAttrListUI(Attrs, ComparedAttrs, self.PreviewLevel)
    self:UpdateResourceUI()
    local Desc =ArmoryUtils:GenModPassiveEffectDesc(self.Target:Data(), self.Target.Level, self.PreviewLevel)
    return Attrs, ComparedAttrs, Desc
end

---接收ModController分发的升级成功通知
function Component:NotifyOnModLevelUp(OldModUuid, NewModUuid, bTakeOff)
    self.Target = ModModel:GetMod(NewModUuid)
    -- self.Btn_Upgrade:ForbidBtn(true)
    self.bDisableWarning = true
    self:UpdateResourceUI(true)
    self:ShowWarning(false)
    if self.Target:IsOriginalMaxLevel() then
        self.Panel_Max:SetVisibility(UIConst.VisibilityOp.Visible)
    end
    self.LevelUpWidget:OnLevelUpSuccess()
end


function Component:RealCloseComp()
    self.Btn_Upgrade:UnBindEventOnClickedByObj(self)
    self:CloseForModCommon()
end

function Component:OnLevelUpSuccessCallback()
    local Attrs = {}
    self:UpdateModCostUI(Attrs, nil, self.Target.Level)
    self:UpdateAttrListUI(Attrs, nil, self.Target.Level)
    local Desc =ArmoryUtils:GenModPassiveEffectDesc(self.Target:Data(), self.Target.Level)
    self.Btn_Upgrade:ForbidBtn(true)
    return Attrs, Desc
end

function Component:OnLevelUpAnimFinishedCallback()
    self.PreviewLevel = self.PreviewLevel+1
    local Params = {
        Parent = self, Target = self.Target, Type = self.Type,
        NowLevel = self.Target.Level,
        MaxLevel = self.Target.MaxLevel,
        MinLevel = self.PreviewLevel,
    }
    self.LevelUpWidget:UpdateWidgetData(Params)
    self.Btn_Upgrade:ForbidBtn(false)
    self.bDisableWarning = false
    if self.Key_Consume and self.CurInputDeviceType == ECommonInputType.Gamepad then
        self.Key_Consume:SetVisibility(UIConst.VisibilityOp.Visible)
        self:SetFocus()
    end
end

function Component:CheckCanUpgrade(TargetLevel)
    local ResourceUse = self.Target:GetLevelUpItems(self.Target.Level, TargetLevel)
    local Avatar = ModModel:GetAvatar()
    local CanUpgrade = Avatar:CheckEnough(ResourceUse)
    return CanUpgrade
end

function Component:GetMaxCanUpgradeLevel()
    local ComparedLevel = self.Target.Level + 1
    if ComparedLevel >= self.Target.MaxLevel then
        return self.Target.MaxLevel
    end
    local ToLevel = ComparedLevel
    repeat
        local Res = self:CheckCanUpgrade(ComparedLevel)
        if Res then
            ToLevel = ComparedLevel
        end
        ComparedLevel = ComparedLevel + 1
        if (ComparedLevel > self.Target.MaxLevel) then
            break
        end
    until not Res
    return ToLevel
end

--region 手柄相关
function Component:RefreshOpInfoByInputDeviceComp(CurInputDevice, CurGamepadName)
    self.CurInputDeviceType = CurInputDevice
    if (CurInputDevice == ECommonInputType.Gamepad) then
        self:ReNavigateToListItem()
        if self.Key_Consume then
            self.Key_Consume:SetVisibility(UIConst.VisibilityOp.Visible)
            self:ShowCheckBtn(false)
            self:ShowChooseBtn(false)
        end
        if self.LevelUpWidget.WidgetSwitcher_Min then
            self.LevelUpWidget.WidgetSwitcher_Min:SetActiveWidgetIndex(1)
            self.LevelUpWidget.WidgetSwitcher_Minus:SetActiveWidgetIndex(1)
            self.LevelUpWidget.WidgetSwitcher_Add:SetActiveWidgetIndex(1)
            self.LevelUpWidget.WidgetSwitcher_Max:SetActiveWidgetIndex(1)
        end

        self.Item_1:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
        self.Item_5:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
        for i = 1, 4 do
            self["Item_"..i]:SetNavigationRuleExplicit(EUINavigation.Right, self["Item_"..(i+1)])
            self["Item_"..(i+1)]:SetNavigationRuleExplicit(EUINavigation.Left, self["Item_"..i])
        end
        for i = 1, 5 do
            self["Item_"..i]:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
            self["Item_"..i]:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
        end
    else
        if self.Key_Consume then
            self.Key_Consume:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
        if self.LevelUpWidget.WidgetSwitcher_Min then
            self.LevelUpWidget.WidgetSwitcher_Min:SetActiveWidgetIndex(0)
            self.LevelUpWidget.WidgetSwitcher_Minus:SetActiveWidgetIndex(0)
            self.LevelUpWidget.WidgetSwitcher_Add:SetActiveWidgetIndex(0)
            self.LevelUpWidget.WidgetSwitcher_Max:SetActiveWidgetIndex(0)
        end
    end
end

function Component:OnFocusReceivedComp(MyGeometry, InFocusEvent)
    if (self.CurInputDeviceType == ECommonInputType.Gamepad) then
        self:ReNavigateToListItem()
        self.Key_Consume:SetVisibility(UIConst.VisibilityOp.Visible)
    end
end

--重新导航至子Tab栏
function Component:ReNavigateToListItem()
    if CommonUtils:IfExistSystemGuideUI(self) then
        return
    end
    if(self.bListExpand)then
        if self.Selective_Listing.TileView_Select_Role:GetNumItems() > 0 then
            self.Selective_Listing.TileView_Select_Role:NavigateToIndex(0)
        end
    else
        self:SetFocus()
    end
end

function Component:OnKeyDownComp(MyGeometry, InKeyName)
    if InKeyName == EKeys.Add.KeyName then
        self.LevelUpWidget.Btn_Add.Btn.OnClicked:Broadcast()
        return true
    elseif InKeyName == UIConst.GamePadKey.FaceButtonRight and self.IsFocusInItem then
        self:SetFocus()
        self.IsFocusInItem = false
        self.Key_Consume:SetVisibility(UIConst.VisibilityOp.Visible)
        self:ShowCheckBtn(false)
        return true
    elseif InKeyName == EKeys.Subtract.KeyName then
        self.LevelUpWidget.Btn_Minus.Btn.OnClicked:Broadcast()
        return true
    elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
        self:OnBtnUpgradeClick()
        return true
    elseif InKeyName == UIConst.GamePadKey.LeftTriggerThreshold then
        self.LevelUpWidget.Btn_Minus.Btn.OnClicked:Broadcast()
        return true
    elseif InKeyName == UIConst.GamePadKey.RightTriggerThreshold then
        self.LevelUpWidget.Btn_Add.Btn.OnClicked:Broadcast()
        return true
    elseif InKeyName == UIConst.GamePadKey.DPadLeft then
        self.LevelUpWidget.Btn_Min.Btn.OnClicked:Broadcast()
        return true
    elseif InKeyName == UIConst.GamePadKey.DPadRight then
        self.LevelUpWidget.Btn_Max.Btn.OnClicked:Broadcast()
        return true
    elseif InKeyName == UIConst.GamePadKey.LeftThumb then
        self.IsFocusInItem = true
        self.Item_1:SetFocus()
        self.Key_Consume:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self:ShowCheckBtn(true)
        return true
    elseif InKeyName == UIConst.GamePadKey.RightThumb then
        self.Tab_Intensify:Handle_KeyEventOnGamePad(InKeyName, "KeyDown")
        return true
    end
    return false
end

function Component:OnPreviewKeyDownComp(MyGeometry, InKeyName)
    if InKeyName == UIConst.GamePadKey.DPadLeft then
        self.LevelUpWidget.Btn_Min.Btn.OnClicked:Broadcast()
        return true
    elseif InKeyName == UIConst.GamePadKey.DPadRight then
        self.LevelUpWidget.Btn_Max.Btn.OnClicked:Broadcast()
        return true
    end
    return false
end

--endregion 手柄相关

return Component