local ModModel = ModController:GetModel()
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"

local SetItemChosen = function(Content,bChosen)
    if not Content then return end
    if Content.IsChosen == bChosen then return end
    Content.IsChosen = bChosen
    if IsValid(Content.UI) then
        Content.UI:SetIsChosen(bChosen)
    end
end

local SetItemSelected = function(Content, bSelected)
    if not Content then return end
    if Content.IsSelected == bSelected then return end
    Content.IsSelected = bSelected
    if IsValid(Content.UI) then
        Content.UI:SetIsSelected(bSelected)
    end
end

---@param IntensifyMain WBP_Armory_Intensify_P_C
local OnItemMouseButtonUpEvent = function(IntensifyMain, Content,MouseEvent)
    IntensifyMain:SelectContentChanged(Content)
    if not Content.bShadow then
        if Content.IsLocked then
            UIManager():ShowUITip(UIConst.Tip_CommonToast, GText("UI_ModEnhance_Locked"))
            return
        end
        if not Content.IsChosen or Content.ModId == 0 then
            local Res = IntensifyMain.EnhanceWidget:AddComsumerItem(Content)
            if Res then
                SetItemChosen(Content, true)
            end
        else
            SetItemChosen(Content, false)
            IntensifyMain.EnhanceWidget:OnItemMinusBtnClick(Content)
        end
    else
        ModController:ShowToast(GText("UI_ModCardLevelUp_NotGet"))
    end
end

---@type WBP_Armory_Intensify_P_C|WBP_Armory_Intensify_M_C
local Component = {}

function Component:OnDetailLockBtnClickComp()
    if (not self.ItemDetailsContent) then
        return
    end
    local Avatar = GWorld:GetAvatar()
    if self.ItemDetailsContent.IsLocked then
        local CancelFunc = function()
            self.ItemDetailsWidget.Btn_Locked:ForbidBtn(false)
            self.ItemDetailsWidget.Switcher_Lock:SetActiveWidgetIndex(0)
        end
        local ConfirmFunc = function()
            ModController:OpenSeconderyPassword(self.ItemDetailsContent.Uuid, self)
        end
        UIManager(self):ShowCommonPopupUI(100019,{
            RightCallbackFunction = ConfirmFunc, 
            CloseBtnCallbackFunction = CancelFunc,
        },self)
    else
        self:BlockAllUIInput(true)
        Avatar:LockResourceInBag(CommonConst.AllType.Mod, self.ItemDetailsContent.Uuid)
    end
end

function Component:OnBagItemLockedOrUnlocked(OpAction, ErrCode, ...)
    self:BlockAllUIInput(false)
    if (not ErrorCode:Check(ErrCode)) then
        return
    end
    if OpAction == "StateChange" then
        self.ItemDetailsContent.IsLocked = not self.ItemDetailsContent.IsLocked
        if(self.ItemDetailsContent.SelfWidget)then
            if self.ItemDetailsContent.IsLocked then
                self.ItemDetailsContent.SelfWidget:SetLock(1)
                self.ItemDetailsContent.LockType = 1
            else
                self.ItemDetailsContent.SelfWidget:SetLock(0)
                self.ItemDetailsContent.LockType = 0
            end
        end
        if(self.ItemDetailsWidget)then
            local TipsId = self.ItemDetailsContent.IsLocked and 7006 or 7007
            self.SetTipLockAfterRPCBackFunc(self.ItemDetailsContent.IsLocked)
            UIManager(self):ShowError(TipsId, nil, UIConst.Tip_CommonToast)
        end
    end
end

function Component:OnListItemClicked(ItemContent)
    if ItemContent.ItemType or ItemContent.Type then
        self:ShowItemDetails(true, ItemContent,false, true)
    end
end

function Component:OnItemIsHoverChanged(ItemContent, bHovered)
    if self.CurInputDeviceType ~= ECommonInputType.Gamepad then
        return
    end
    --self:ShowItemDetails(false, nil, true)
    if self.bListExpand and not self:IsInLSMode() then
        if ItemContent.ItemType or ItemContent.Type then
            self:ShowItemDetails(true, ItemContent, true,true)
        end
    end
end


function Component:InitEnhanceComp(...)
    ModController:RegisterEvent(self)

    self.Panel_Limit:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Text_Limit:SetText(GText("UI_ModEnhance_Max"))
    self.Panel_Element:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Panel_Mod:SetVisibility(UIConst.VisibilityOp.Visible)
    self.PanelModSlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Panel_Mod)
    self.Panel_Info:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Stats:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WidgetSwitcher_Mode:SetActiveWidgetIndex(1)
    self.Selective_Listing:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Selective_Listing.TileView_Select_Role.EntryWidgetClass = LoadClass('/Game/UI/WBP/Armory/Widget/Unit/WBP_Armory_Item_L_Mod.WBP_Armory_Item_L_Mod')

    self.Btn_Enhance:SetText(GText("UI_FUNC_INCREASE"))
    self.Btn_Enhance:BindEventOnClicked(self, self.OnBtnEnhanceClick)
    self.Btn_Enhance:BindForbidStateExecuteEvent(self, function()
        if self.bDisableWarning then return end
        ModController:ShowToast(GText("UI_Mod_Toast_EnhanceNotEnough"))
    end)
    self.Btn_Enhance:ForbidBtn(true)

    self.Btn_Auto:SetText(GText("UI_WeaponStrength_Auto"))
    self.Btn_Auto:BindEventOnClicked(self, self.OnBtnAutoClick)
    self:InitTab(GText("UI_Armory_Mod")..GText("UI_FUNC_INCREASE").."/"..GText(self.Target:GetName()))

    local User, Target, SubWidget, Params = ...
    ---@type Mod
    self.Target = Target
    self.Type = User or Target:GetTypeName()
    self.CurrentMode = Params.BehaviourType
    self.PreviewLevel = self.Target.CurrentModCardLevel +1
    self.bTakeOff = false
    self:InitEnhanceWidget()
    self:AddTimer(0.2, self.RefreshBaseInfo)
    self:AddDispatcher(EventID.OnUpdateBagItem, self, self.OnBagItemLockedOrUnlocked)
    self:UpdateTopResourceBar()
    ModModel:GenerateEnhanceData()
end

function Component:SelectContentChanged(Content)
    SetItemSelected(self.SelectedModContent, false)
    if not self.SelectedModContent or Content~=self.SelectedModContent then
        self.SelectedModContent = Content
        SetItemSelected(self.SelectedModContent, true)
    end
end

function Component:InitEnhanceWidget()
    if not self.EnhanceWidget then
        ---@type WBP_Armory_ModEnhance_C
        self.EnhanceWidget = self:CreateWidgetNew(ModCommon.ModEnhance)
        self.VB_Node:AddChild(self.EnhanceWidget)
    end
    local Params = {
        Parent = self, Target = self.Target, Type=self.Type,
        NowLevel = self.Target.CurrentModCardLevel,
        MaxLevel = self.Target.ModCardLevelMax
    }
    self.EnhanceWidget:SetCallbacks({
        OnItemAddClickCallback = self.OnItemAddClickCallback,
        OnModItemMoveCallback = self.OnModItemMoveCallback,
        OnPreviewLevelChangedCallback = self.OnPreviewLevelChangedCallback,
        OnItemMinusBtnClickCallback = self.OnItemMinusBtnClickCallback,
        OnLevelUpSuccessCallback = self.OnLevelUpSuccessCallback,
        OnLevelUpSuccessFinishedCallback = self.OnLevelUpSuccessFinishedCallback,
        OnLevelUpFinalCallback = self.Close,
        OnComsumerCountChangeCb = self.OnComsumerCountChangeCb,
    })
    self.EnhanceWidget:Init(Params)

    self:SetModDataUI()
    self:PlayModUICameraAnim()

    self.Btn_Enhance:SetDefaultGamePadImg("Y")
    self.Btn_Auto:SetDefaultGamePadImg("X")
end

function Component:OnComsumerCountChangeCb(_, NowComsumerCount)
    self:SetAutoBtnText(NowComsumerCount)
    if NowComsumerCount >= self.EnhanceWidget.MaxComsumerCount then 
        self.Btn_Enhance:ForbidBtn(false)
    else
        self.Btn_Enhance:ForbidBtn(true)
    end
end

function Component:SetAutoBtnText(NowComsumerCount)
    if NowComsumerCount >0 then
        self.Btn_Auto:SetText(GText("ModFilter_ClearAll"))
    else
        self.Btn_Auto:SetText(GText("UI_WeaponStrength_Auto"))
    end
end

function Component:OnBtnAutoClick()
    if not self.bListExpand then
        self:OnExpandList(true,true)
        if #self.Selective_Listing.FilteredContents == 0 then
            ModController:ShowToast(GText("UI_Toast_WeaponStrength_NoAuto"))
            return
        end
    end
    if self.EnhanceWidget.ComsumerCount >0 then
        self.EnhanceWidget:RemoveAllAddedComsumer()
    else
        local AutoSelectContents = {}
        local PendingEnhanceResList = {}
        local i=1
        while i <= #self.Selective_Listing.FilteredContents do
            if #AutoSelectContents >= self.EnhanceWidget.MaxComsumerCount then
                break
            end
            local Content = self.Selective_Listing.FilteredContents[i]
            if (Content.IsLocked) or (Content.Level and Content.Level>0) or Content.bShadow then
            elseif Content.Count and Content.Count > 0  then
            else
                SetItemChosen(Content, true)
                table.insert(AutoSelectContents, Content)
            end
            i = i+1 
        end
        local ConfrimContentInfo = {}
        for i = 1, self.EnhanceWidget.MaxComsumerCount-#AutoSelectContents do
            if i > #PendingEnhanceResList and
                (not ConfrimContentInfo.Count and ConfrimContentInfo.Count==0) 
                or #PendingEnhanceResList==0 then
                break
            end
            if ConfrimContentInfo.Count == nil or ConfrimContentInfo.Count == 0 then
                ConfrimContentInfo.Content = PendingEnhanceResList[i]
                ConfrimContentInfo.Count = ConfrimContentInfo.Content.Count
                SetItemChosen(ConfrimContentInfo.Content, true)
            end
            if ConfrimContentInfo.Count and ConfrimContentInfo.Count > 0 then
                ConfrimContentInfo.Count = ConfrimContentInfo.Count - 1
            end
            local Content = ConfrimContentInfo.Content
            table.insert(AutoSelectContents, Content)
        end
        if table.isempty(AutoSelectContents) then
            ModController:ShowToast(GText("UI_Toast_WeaponStrength_NoAuto"))
            return
        end
        self.EnhanceWidget:AddComsumerItems(AutoSelectContents)
    end
end

function Component:OnBtnEnhanceClick()
    if self.CurrentMode ~= ModCommon.Enhance then return end
    local Comsumers,bAnyLevelUp = self.EnhanceWidget:GetComsumersParam()
    local Callback = function ()
        ModController:TryOpenOverCostWarningDialog(self.Target, self.PreviewLevel+self.Target.MaxLevel, function() 
            ModController:SendModCardLevelUp(self.Target, Comsumers, self.bTakeOff)
        end, self)
    end
    PrintTable(Comsumers,3,"Mod增幅参数打印")
    local PopupId = bAnyLevelUp and ModCommon.ModCardlevelDialog2 or ModCommon.ModCardlevelDialog
    local bHideItemTips = true
    for ModId, Comsumer in pairs(Comsumers) do
        for ModUuid, Count in pairs(Comsumer) do
            if ModModel:IsEquipedInCurrSuit(ModUuid) then
                local Mod = ModModel:GetMod(ModUuid)
                if (Mod.IsOriginal and Mod.Count<=Count) or (not Mod.IsOriginal) then
                    bHideItemTips = false
                    break
                end
            end
        end
        if not bHideItemTips then break end
    end
    UIManager(self):ShowCommonPopupUI(PopupId, {
        RightCallbackFunction = Callback, HideItemTips = bHideItemTips
    }, self)
end

function Component:RealCloseComp()
    self.Btn_Enhance:UnBindEventOnClickedByObj(self)
    self.Btn_Auto:UnBindEventOnClickedByObj(self)
    self:CloseForModCommon()
    ModModel:DisposeEnhanceData()
end

--region 左侧列表相关
function Component:RefreshListComp()
    local ModContents = {}
    self.IncId2ModContent = {}
    local IncId = 0
    for _,ResId in ipairs(self.Target.CardLevelNeedResourceId or {}) do
        local Res = ModModel:GetAvatar().Resources[ResId]
        if Res then
            local Obj = ArmoryUtils:NewResourceItemContent(Res)
            Obj.IncId = IncId
            Obj.Count = Res.Count
            Obj.Level = nil
            Obj.CardLevel = 0
            Obj.ModId = 0
            Obj.Parent = self
            Obj.bEnhance= true
            --Obj.AdjustBackGroundHeightDelay = 0.1
            Obj.MouseButtonUpEvent = OnItemMouseButtonUpEvent
            table.insert(ModContents, Obj)
            self.IncId2ModContent[IncId] = Obj
            IncId = IncId +1
        end
    end
    local ValidModId = {}
    for Uuid,_ in pairs(ModModel.TargetMods) do
        local Mod = ModModel:GetMod(Uuid)
        if self.Target:IsCardLevelNeedModId(Mod.ModId) and Uuid ~= self.Target.Uuid then 
            ValidModId[Mod.ModId] = 1
            for i=1, Mod.Count do
                local Obj = ModModel:CreateModContent(Mod, nil, true)
                Obj.IncId = IncId
                Obj.Parent = self
                Obj.bEnhance = true
                Obj.MouseButtonUpEvent = OnItemMouseButtonUpEvent
                table.insert(ModContents ,Obj)
                self.IncId2ModContent[IncId] = Obj
                IncId = IncId+1
            end
        end
    end
    for _,ModId in pairs(self.Target.CardLevelNeedModId or {}) do
        if not ValidModId[ModId] then
            local Mod = ModModel:CreateEnhanceInvalidMod(IncId, ModId)
            local Obj = ModModel:CreateModContent(Mod, nil, true)
            Obj.IncId = IncId
            Obj.Parent = self
            Obj.bEnhance = true
            Obj.MouseButtonUpEvent = OnItemMouseButtonUpEvent
            Obj.bShadow = true
            table.insert(ModContents, Obj)
            self.IncId2ModContent[IncId] = Obj
            IncId = IncId +1
        end
    end
    self:SortSelectiveList(ModContents, 1, CommonConst.ASC)
    self.Selective_Listing:Init(self,{
        ItemContents = ModContents, 
        SortType = CommonConst.ASC,
        OrderByDisplayNames = {"UI_LEVEL_SELECT",},
    })
    self.Selective_Listing:SetEmptyStateText("")
    self.Btn_Auto:ForbidBtn(false)
    if #ModContents == 0 then
        self.Selective_Listing:SetEmptyStateText(GText("UI_Armory_ModListIsEmpty"))
    end
    self.Selective_Listing:SetTitle(GText("UI_ModCardLevelUp_Title"))
end

function Component:SortSelectiveList(InOutContentArray,SortBy, SortType)
    self.SortType = SortType
    if not self.SortFunc then
        self.SortFunc = {}
        self.SortFunc[-1] = function(M1,M2)
            local Mod1 = ModModel:GetMod(M1.Uuid)
            local Mod2 = ModModel:GetMod(M2.Uuid)
            if Mod1.Count ~= Mod2.Count then
                return not CommonUtils:Compare(Mod1.Count, Mod2.Count, self.SortType) 
            end
            if Mod1.Level ~= Mod2.Level then 
                return CommonUtils:Compare(Mod1.Level, Mod2.Level, self.SortType) 
            end
            if M1.CardLevel ~= M2.CardLevel then 
                return CommonUtils:Compare(M1.CardLevel, M2.CardLevel, self.SortType) 
            end
            return CommonUtils:Compare(M1.UnitId, M2.UnitId, self.SortType)
        end
        self.SortFunc[1] = function(M1, M2)
            if M1.ModId == 0 and M2.ModId == 0 then
                return true
            end
            if M1.ModId == self.Target.ModId and M2.ModId == self.Target.ModId then
                return self.SortFunc[-1](M1, M2)
            end
            if M1.ModId == 0 then return true end
            if M2.ModId == 0 then return false end
            if M1.ModId == self.Target.ModId then return true end
            if M2.ModId == self.Target.ModId then return false end
            return self.SortFunc[-1](M1, M2)
        end
    end
    table.sort(InOutContentArray, self.SortFunc[SortBy])
    self.SortType = nil
end
--endregion


function Component:ReceiveEnterStateComp()
    self:OnExpandList(self.bListExpand, true)
    if self.EnhanceWidget then
        local Params = {
            Parent = self, Target = self.Target, Type=self.Type,
            NowLevel = self.Target.CurrentModCardLevel,
            MaxLevel = self.Target.ModCardLevelMax
        }
        self.EnhanceWidget:UpdateWidgetData(Params)
    end
end

function Component:OnItemAddClickCallback()
    if not self.bListExpand then
        self:OnExpandList(true, true)
    else
        ModController:ShowToast(GText("UI_Armory_Toast_Material"))
    end
end

function Component:OnModItemMoveCallback(MoveModConent)
    local Content = self.IncId2ModContent[MoveModConent.IncId]
    Content.IndexInEnhance = MoveModConent.IndexInEnhance
end

function Component:OnPreviewLevelChangedCallback(InPreviewLevel)
    local Attrs, ComparedAttrs = {},{}
    self.PreviewLevel = InPreviewLevel
    if self.PreviewLevel == self.Target.CurrentModCardLevel then
        ComparedAttrs = nil
    end
    local DesireLevel = self.PreviewLevel+self.Target.MaxLevel
    self:UpdateModCostUI(Attrs, ComparedAttrs,DesireLevel)
    self:UpdateAttrListUI(Attrs, ComparedAttrs, DesireLevel) 
    local RealLevel = self.Target.CurrentModCardLevel+self.Target.MaxLevel
    local Desc =ArmoryUtils:GenModPassiveEffectDesc(self.Target:Data(), RealLevel, DesireLevel)
    self:SetAutoBtnText(self.EnhanceWidget.ComsumerCount)
    self.EnhanceWidget:UpdateCostBar(InPreviewLevel)
    return Attrs, ComparedAttrs, Desc
end

function Component:OnItemMinusBtnClickCallback(DelContent)
    if not self.bListExpand then
        self:OnExpandList(true,true)
    end
    self:SetAutoBtnText(self.EnhanceWidget.ComsumerCount)
    local Content = self.IncId2ModContent[DelContent.IncId]
    Content.IndexInEnhance = nil
    if Content.Type=="Mod" then
        SetItemChosen(Content, false)
    elseif not self.EnhanceWidget.Uuid2Count[Content.ItemId] then
        SetItemChosen(Content, false)
    end
end

function Component:OnLevelUpSuccessCallback()
    local Attrs = {}
    local NowLevel = self.Target.CurrentModCardLevel+self.Target.MaxLevel
    self:UpdateModCostUI(Attrs, nil, NowLevel)
    self:UpdateAttrListUI(Attrs, nil, NowLevel)
    self:UpdateTopResourceBar()
    local Desc =ArmoryUtils:GenModPassiveEffectDesc(self.Target:Data(), NowLevel)
    return Attrs, Desc
end

function Component:NotifyOnModCardLevelUp(ModUuid, Comsumers)
    self.Target = ModModel:GetMod(ModUuid)
    self:OnBackgroundClicked()
    self:OnExpandList(false, true)
    self:ShowWarning(false)
    self.Btn_Auto:ForbidBtn(true)
    self.Btn_Enhance:ForbidBtn(true)
    self.bDisableWarning = true
    if self.Target:IsFinalMaxLevel() then
        self.Panel_Limit:SetVisibility(UIConst.VisibilityOp.Visible)
    end
    self.EnhanceWidget:OnLevelUpSuccess()
end

function Component:OnLevelUpSuccessFinishedCallback()
    self:OnExpandList(true, true)
    self.PreviewLevel = self.PreviewLevel+1
    local Params = {
        Parent = self, Target = self.Target, Type=self.Type,
        NowLevel = self.Target.CurrentModCardLevel,
        MaxLevel = self.Target.ModCardLevelMax
    }
    self.EnhanceWidget:UpdateWidgetData(Params)
    self.bDisableWarning = false
end

function Component:OnBackgroundClickedComp()
    self:SelectContentChanged(nil)
    if self.bItemDetailsShowed then
        self:ShowItemDetails(false)
    end
end

--region 手柄相关
function Component:RefreshOpInfoByInputDeviceComp(CurInputDevice, CurGamepadName)
    self.CurInputDeviceType = CurInputDevice
    if (CurInputDevice == ECommonInputType.Gamepad) then
        self:ReNavigateToListItem()
        local Item =self.Selective_Listing:GetItemAt(0)
        if Item and Item.UI then
            self.Selective_Listing.Common_Sort_List.Btn_Filter_List:SetNavigationRuleExplicit(EUINavigation.Up, Item.UI)
        end

        -- 遍历self.EnhanceWidget.Item_1到Item_5，设置导航规则
        for i = 1, 5 do
            local Item = self.EnhanceWidget["Item_" .. i]
            if Item then
                Item:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
                Item:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
            end
        end
        self:ShowCheckBtn(false)
        self:ShowChooseBtn(true)
    end
end

function Component:OnFocusReceivedComp(MyGeometry, InFocusEvent)
    if (self.CurInputDeviceType == ECommonInputType.Gamepad) then
        self:ReNavigateToListItem()
    end
end

--重新导航至子Tab栏
function Component:ReNavigateToListItem()
    if(self.bListExpand)then
        if self.Selective_Listing.TileView_Select_Role:GetNumItems() > 0 then
            -- 导航到当前选中的item
            local SelectedItem = self.Selective_Listing.TileView_Select_Role:BP_GetSelectedItem()
            if SelectedItem then
                self.Selective_Listing.TileView_Select_Role:BP_NavigateToItem(SelectedItem)
            else
                self.Selective_Listing.TileView_Select_Role:NavigateToIndex(0)
            end
        else
            self.EnhanceWidget.Item_1:SetFocus()
        end
    else
        self.EnhanceWidget.Item_1:SetFocus()
    end
end

function Component:OnKeyDownComp(MyGeometry, InKeyName)
    if InKeyName == UIConst.GamePadKey.FaceButtonLeft then --X
        self.Btn_Auto:OnBtnClicked()
    elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then --Y
        self.Btn_Enhance:OnBtnClicked()
    elseif InKeyName == UIConst.GamePadKey.LeftThumb then --L键
        self.Selective_Listing.Common_Sort_List.Btn_Filter_List:SetFocus()
    elseif InKeyName == UIConst.GamePadKey.RightThumb then
        self.Tab_Intensify:Handle_KeyEventOnGamePad(InKeyName, "KeyDown")
    end
end

function Component:OnKeyUpComp(MyGeometry, InKeyName)
    if InKeyName == UIConst.GamePadKey.SpecialRight then
        local DetailContent = self.ItemDetailsWidget.Content
        if self.ItemDetailsWidget:IsVisible() and DetailContent then
            self.ItemDetailsWidget.Btn_Locked:OnBtnPressed()
            self.ItemDetailsWidget.Btn_Locked:OnBtnReleased()
        end
    end
end

--endregion 手柄相关

return Component