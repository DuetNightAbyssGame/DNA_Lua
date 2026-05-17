
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
local ModModel = ModController:GetModel()
local SlotToDrag = FVector2D()

-- --region Mod List Item Callback

local OnItemDragCancelled = function(ArmoryMod, Content, Operation, PointerEvent)
    ArmoryMod:ShowQuickEquipBtn(true)
    ArmoryMod:CloseLinkLine(Content.Uuid, Operation.DefaultDragVisual)
    local ListViewGeo = ArmoryMod.List_Select_Mod:GetCachedGeometry()
    local MousePos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(PointerEvent)
    if UE4.USlateBlueprintLibrary.IsUnderLocation(ListViewGeo, MousePos) then
        local SelectedStuff = ModModel:GetSelectStuff()
        if SelectedStuff and SelectedStuff.ModUuid == Content.Uuid then
            if IsValid(Content.UI) then
                Content.UI:SetIsSelected(true)
            end
        end
    end
end

local OnItemMouseButtonDownEarlyEvent = function(Entry, Content, MouseEvent)
    local Key = UKismetInputLibrary.PointerEvent_GetEffectingButton(MouseEvent)
    if Key == EKeys.LeftMouseButton and not Content.Uuid then
        return UWidgetBlueprintLibrary.DetectDragIfPressed(MouseEvent, Entry, UE4.EKeys.LeftMouseButton)
    elseif Key == EKeys.RightMouseButton and Content.Uuid then
        ModController:QuickEquipMod(Content.Uuid)
    end
end
-- local OnItemMouseButtonDownEvent = function(ArmoryMod, Content)
-- end
local OnItemMouseButtonUpEvent = function(ArmoryMod, Content, MouseEvent)
    -- 手柄有额外逻辑
    ArmoryMod:HandleGamepadModSelection(Content)
    local Key = MouseEvent and UKismetInputLibrary.PointerEvent_GetEffectingButton(MouseEvent) or EKeys.LeftMouseButton
    if Key == EKeys.LeftMouseButton then
        local SelectedStuff = ModModel:GetSelectStuff()
        if SelectedStuff and Content.Uuid == SelectedStuff.ModUuid then
            return
        end
        ModController:SetSelectedStuff(Content.Uuid, nil)
    end
end
local OnItemMouseEnterEvent = function(ArmoryMod, Entry, Content)
    if Entry.IsDraging then return end
    if(Content.IsNew)then
        ArmoryUtils:SetReddotRead(Content, true)
        Entry:DisableReddot()
    end
    -- 手柄有额外逻辑
    if ModController:IsGamepad() then
        -- 如果现在不是交换模式或者选中的是空槽位，需要自动选中
        local GamepadSelectedStuff = ModModel:GetGamePadSelectedStuff()
        local mod = nil
        if GamepadSelectedStuff and GamepadSelectedStuff.SlotId then
            local SlotUI = ArmoryMod["Mod_" .. GamepadSelectedStuff.SlotId]
            mod = SlotUI.SlotUIData:GetMod()
        end
        if not GamepadSelectedStuff then
            local SelectedStuff = ModModel:GetSelectStuff()
            if SelectedStuff and Content.Uuid == SelectedStuff.ModUuid then
                return
            end
            ModController:SetSelectedStuff(Content.Uuid, nil)
            ArmoryMod:SetKeySelectModGamePad(GText("UI_CTL_Select_Slot"))
            Entry.ItemDetails_MenuAnchor:SetAllowHover(false)
            Entry.ItemDetails_MenuAnchor:CloseItemDetailsWidget(true)
        else
            Entry.ItemDetails_MenuAnchor:SetConfirmDesc(GText("UI_CTL_Replace_SelectedMod"))

            local GamepadSelectedStuff = ModModel:GetGamePadSelectedStuff()
            local Case = ModCommon.CalcVolumeDiffCase.Change
            local Param1 = GamepadSelectedStuff.SlotId
            local Param2 = Content.Uuid
            if not Param1 then return end
            local _, CostDiff = ModModel:CalcModVolumeDiff(Case,ModModel:GetTarget(), Param1, Param2)
            ArmoryMod:SetModCostPreview(CostDiff + ArmoryMod.CachedCost, false, Param2)

            if not mod then
                local SelectedStuff = ModModel:GetSelectStuff()
                if SelectedStuff and Content.Uuid == SelectedStuff.ModUuid then
                    return
                end
                ModController:SetSelectedStuff(Content.Uuid, nil)
                ArmoryMod:SetKeySelectModGamePad(GText("UI_CTL_Select_Slot"))
                Entry.ItemDetails_MenuAnchor:SetAllowHover(false)
                Entry.ItemDetails_MenuAnchor:CloseItemDetailsWidget(true)
            end
        end
    end
end

local OnItemMouseLeaveEvent = function(ArmoryMod, Entry, Content)
    if ModController:IsGamepad() then
        ArmoryMod:SetKeySelectModGamePad(nil)
        Entry.ItemDetails_MenuAnchor:SetConfirmDesc(nil)
        Entry.ItemDetails_MenuAnchor:SetAllowHover(true)
        ArmoryMod:UpdateCostUI(ArmoryMod.CachedCost)
    end
end

local OnItemCreateDragWidget = function(ArmoryMod, Content)
    if not Content or not Content.bEnableDrag then return end
    if (not Content.Type or Content.Type ~= "Mod" or Content.StuffType ~= nil) then
        return
    end
    if ModModel:IsBugMod(Content.Uuid) then return end
    ArmoryMod:ShowQuickEquipBtn(false)
    ---@type Armory_Mod_Mid_Item_PC_C
    local DragUI = ModController:CreateDragUI(Content.Uuid)
    ArmoryMod:ShowLinkLine(Content.Uuid, DragUI)
    return DragUI
end

local OnItemDragLeave = function(ArmoryMod, Content, PointerEvent, DragWidget)
    local ListViewGeo = ArmoryMod.List_Select_Mod:GetCachedGeometry()
    local MousePos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(PointerEvent)
    if (not UE4.USlateBlueprintLibrary.IsUnderLocation(ListViewGeo, MousePos)) then
        ModController:SetSelectedStuff(nil, nil)
        DragWidget:SetVisibility(UIConst.VisibilityOp.Visible)
        ArmoryMod:ShowQuickEquipBtn(false)
        if ArmoryMod:IsExistTimer(ArmoryMod.LinkDelayTimer) then
            ArmoryMod:RemoveTimer(ArmoryMod.LinkDelayTimer)
            ArmoryMod.LinkDelayTimer = nil
        end
        local _, TimerKey = ArmoryMod:AddTimer(0.05, function()
            for i = 1, #ArmoryMod.SlotLineWidgets do
                local SlotLine = ArmoryMod.SlotLineWidgets[i]
                local DragLine = ArmoryMod.DragLineWidgets[i]
                SlotLine.Main:SetRenderOpacity(1)
                DragLine.Main:SetRenderOpacity(1)
            end
        end)
        ArmoryMod.LinkDelayTimer = TimerKey
    end
end

local OnItemRemovedFromFocusPathEvent = function(ArmoryMod, Entry)
    if ArmoryMod.CurInputDeviceType == ECommonInputType.Gamepad then return end
    if ArmoryMod.bItemDetailsClicked then 
        ArmoryMod.bItemDetailsClicked = false
        Entry:SetFocus()
        return 
    end
    if UIManager():IsHaveMenuAnchorOpen() then
        return
    end
    if ModModel:IsInPolarityEditMode() then return end
    if SystemGuideManager.RunningId == ArmoryMod.GuideId then return end
    ModController:SetSelectedStuff(nil, nil)
end

local OnDetailLockBtnClick = function()
    local ArmoryMod = ModController:GetView(nil)
    local Avatar = ModModel:GetAvatar()
    ArmoryMod.ItemDetailsWidget.Btn_Locked:ForbidBtn(true)
    local Content = ArmoryMod:GetContentBySelectStuff()
    if Content.IsLocked then
        UIManager(nil):ShowCommonPopupUI(100019, {
            RightCallbackFunction = function()
                ModController:OpenSeconderyPassword(Content.Uuid, ArmoryMod)
            end,
            CloseBtnCallbackFunction = function()
                ArmoryMod.ItemDetailsWidget.Btn_Locked:ForbidBtn(false)
                ArmoryMod.ItemDetailsWidget.Switcher_Lock:SetActiveWidgetIndex(0)
            end
        }, ArmoryMod)
    else
        Avatar:LockResourceInBag(CommonConst.AllType.Mod, Content.Uuid)
    end
end
-- endregion

---@type WBP_Armory_Mod_M_C|BP_UIState_C
local M = Class({"BluePrints.UI.BP_UIState_C"})
M._components = {
    --"BluePrints.UI.UIComponent.StarsUIComponent",
    "BluePrints.UI.WBP.Armory.Armory_List_Attr_Compoment",
    "BluePrints.UI.WBP.Armory.MainComponent.Armory_ReddotTree_Component",
    "BluePrints.UI.WBP.Armory.Mod.Armory_Mod_C_GamepadComp"
}

function M:GetContentBySelectStuff(SelectStuff)
    if not SelectStuff then
        SelectStuff = ModModel:GetSelectStuff()
    end
    local Content = nil
    if not SelectStuff:IsSlot() then
        Content = self.ModContents[SelectStuff.ModUuid]
    else
        Content = self.ModSlotUIs[SelectStuff.SlotId].ModContent
    end
    return Content
end

function M:GetContentByUuid(Uuid)
    local Content = self.ModContents[Uuid]
    if not Content then
        for _, SlotUI in pairs(self.ModSlotUIs) do
            if SlotUI.ModContent and Uuid == SlotUI.ModContent.Uuid then
                Content = SlotUI.ModContent
                break
            end
        end
    end
    return Content
end

---@param IsAbyss bool 蓝图变量，是否为大秘境中的Mod界面
function M:PreConstruct(InDesignTime)
    self.Overridden.PreConstruct(self, InDesignTime)
    if self.IsAbyss then
        self.List_Role.EntryWidgetClass = LoadClass('/Game/UI/WBP/Abyss/Widget/Unit/WBP_Abyss_TabItem.WBP_Abyss_TabItem')
    end
end

--region 构造、初始化、关闭
function M:Construct()
    M.Super.Construct(self)
    self.Text_ModVolume:SetText(GText("UI_COST_NAME"))
    self.Text_HIde:SetText(GText("UI_Armory_HideConflictMod"))
    self.List_Select_Mod.OnDragOver:Bind(self, self.OnListModScrollingByDrag)
    self.List_Select_Mod.OnCreateEmptyContent:Bind(self, self.CreateEmptyContent)
    self.List_Select_Mod.BP_OnEntryInitialized:Add(self, function(self, Content, Entry)
        if Content.bAutoFocusForMod then
            Entry:SetFocus()
            Content.bAutoFocusForMod = nil
        end
        Entry:SetNavigationRuleCustom(EUINavigation.Up, {self, self.OnListModNavigationMod})
    end)
    self.List_Role.BP_OnItemClicked:Add(self, self.OnTargetTabSelected)
    self.List_Role.BP_OnEntryInitialized:Add(self, self.OnTargetTabSpawned)
    self.Panel_Hint:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.ModShare:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Mod_Skill:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Mod_Skill:DisableScroll(true)
    self.Mod_Plan:SetVisibility(UIConst.VisibilityOp.Visible)
    -- self.Btn_CopyLink:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Btn_Share:SetVisibility(UIConst.VisibilityOp.Visible)
    self:CheckEnableBtnWhenAnyEquip()
    if self.Key_Gamepad then
        self.Key_Gamepad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self:InitAttrListField()
    self:InitCommonUI()
    self:InitButtons()
    self:InitKeyFunc()
    self:InitGamePad()
    self:InitRecommend()

    self.ModSlotUIs = {}
    self.ModContents = {}
    self.NowModCost = 0
    self.SlotLineWidgets = {}
    self.DragLineWidgets = {}

    ModController:RegisterEvent(self)

    if ModController:IsMobile() then
        return
    end
end

function M:InitKeyFunc()
    self.KeyFuncMap = {
        [EKeys.A.KeyName] = function() self.Tab_Atrr:TabToLeft() end,
        [EKeys.D.KeyName] = function() self.Tab_Atrr:TabToRight() end,
        [EKeys.V.KeyName] = function()
            if not ModModel:IsModUINormal() then return end
            if ModModel:GetCurrSelectMod() then
            ModController:OpenModIntensify()
            end
        end
    }
end

function M:InitButtons()

    self.Btn_EditPolarity:SetText(GText("UI_Mod_Polarity_Btn"))
    self.Btn_EditPolarity:BindEventOnClicked(self, function()
        ModController:StartPolarityEditMode()
    end)
    self.Btn_EditPolarity:BindForbidStateExecuteEvent(self, function()
        ModController:ShowToast(GText("UI_Mod_Polarity_Hint"))
    end)
    self.Btn_EditPolarity.SoundFunc = function()
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
    end

    self.Btn_Auto:SetText(GText("UI_Mod_AutoPutOn"))
    self.Btn_Auto:BindEventOnClicked(self, self.OnClickBtnAutoEquip)
    self.Btn_Auto:BindForbidStateExecuteEvent(self, function()
        ModController:ShowToast(GText("UI_COMMONPOP_TEXT_100067"))
    end)

    self.Btn_Discharge:SetText(GText("UI_Armory_Mod_RemoveAll"))
    self.Btn_Discharge:BindEventOnClicked(self, function()
        local Params = { RightCallbackFunction = function() 
            ModController:TakeOffSuitMod()
        end }
        Params.OnCloseCallbackObj = self
        Params.AutoFocus = true
        Params.OnCloseCallbackFunction = function()
            self:SetDefaultGamepadFocus()
        end
        UIManager():ShowCommonPopupUI(ModCommon.TakeOffSuitModDialog, Params, self)
    end)
    self.Btn_Discharge:BindForbidStateExecuteEvent(self, function()
        ModController:ShowToast(GText("UI_ModToast_EmptyCanNotRemoveAll"))
    end)
    -- self.Btn_Discharge:ForbidBtn(true)

    self.CheckBox_Mod:InitCommonCheckBox()
    self.CheckBox_Mod_Delegate = {
        Inst = self,
        Func = function()
            if ModModel:IsRecommendView() then
            else
                self:SetUpModList(true)
            end
        end
    }
    self.CheckBox_Mod:BindEventOnClicked(self.CheckBox_Mod_Delegate)

    self:RegisterListAttrBtn(self.List_Attribute)

    -- self.Btn_CopyLink:BindEventOnClicked(self, self.OnCopyLinkBtnClick)
    -- self.Btn_CopyLink:BindForbidStateExecuteEvent(self, function()
    --     ModController:ShowToast(GText("UI_Mod_Toast_CopyedFailedForEmpty"))
    -- end)
    self.Btn_Share:BindEventOnClicked(self, self.OnSharedBtnClick)
    -- self.Btn_Share:BindEventOnReleased(self, self.OnSharedBtnRelease)
end

function M:InitBtnPolarity()
    local Avatar = ModController:GetAvatar()
    if (Avatar:CheckUIUnlocked('Polarity')) then
        self.Btn_EditPolarity:SetVisibility(UIConst.VisibilityOp.Visible)
    else
        self.Btn_EditPolarity:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end

    if ModModel:IsModUICopyMode() or ModModel:IsModUIPreview() then -- 如果是打开别人或者自己分享的mod装配方案，隐藏该按钮
        self.Btn_EditPolarity:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:InitBtnImport()
    if ModModel:IsModUICopyMode() then
        local Target = ModModel:GetTarget()
        local ItemType
        if self.Type == "Char" then
            ItemType = CommonConst.ArmoryType.Char
        elseif self.Type == "Weapon" or self.Type == "UWeapon" then
            ItemType = CommonConst.ArmoryType.Weapon
        end
        local Owned = false
        local Avatar = GWorld:GetAvatar()
        local TargetType = self.Tag == "UWeapon" and "UWeapon" or self.Type
        for Uuid, Item in pairs(Avatar[TargetType .. "s"]) do
            if Item[ItemType .. "Id"] == Target[ItemType .. "Id"] then
                Owned = true
                break
            end
        end
        if Owned then
            self.Btn_Import:SetText(GText("UI_Mod_ImportPlan"))
            self.Btn_Import:BindEventOnClicked(self, self.OnClickBtnImport)
        else
            self.Btn_Import:SetText(GText("UI_Mod_NotOwned_" .. ItemType))
            self.Btn_Import:ForbidBtn(true)
        end
    end
end

function M:InitCommonUI()
    -- local SortCallback = function()
    --     local SortBy, SortType = self.Common_SortList_PC:GetSortInfos()
    --     ModModel:SetSortConf(SortBy, SortType)
    --     self:SetUpModList(true)
    -- end
    -- self.Common_SortList_PC:BindEventOnSelectionsChanged(self,SortCallback)
    -- self.Common_SortList_PC:BindEventOnSortTypeChanged(self,SortCallback)

    self.Sift:SetSiftModelId(ModCommon.ModSiftId)
    self.Sift:BindEventOnSelectionsChanged(self, function(_, SelectedItems, ItemDatas)
        ModModel:SetSiftConf(SelectedItems, ItemDatas)
        ModModel:FilterModsOfTarget()
        if ModModel:IsRecommendView() then
        else
            self:SetUpModList(true)
        end
    end)

    self.Common_PolarityList_PC:BindEventOnSelectionsChanged(self, function()
        if ModModel:IsRecommendView() then

        else
            self:SetUpModList(true)
        end
    end)

    local CloseCb = function() self:Close() end
    local LevelUpCb = function()
        ModController:OpenModIntensify()
    end
    self.BottomKeyInfo = {
        {KeyInfoList = {{Type="Text", Text="V", ClickCallback = LevelUpCb,Owner=self}},Desc=GText("UI_FUNC_LEVELUP")},
        {KeyInfoList = {{Type="Text", ImgShortPath="RightMouseButton"}}, Desc=GText("UI_Mod_QuickEquip")},
        {GamePadInfoList = {{Type="Img", ImgShortPath="A"}}, Desc=GText("UI_Tips_Ensure")},
        {KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=CloseCb,Owner=self}}, GamePadInfoList = {{Type="Img", ImgShortPath="B"}}, Desc=GText("UI_BACK")},
    }
    local TabKeyInfo = {}
    for _, KeyInfo in ipairs(self.BottomKeyInfo) do
        table.insert(TabKeyInfo, KeyInfo)
    end
    self.Tab_Mod:Init({
        TitleName = GText("MESSAGE_TITLE_LOADING_31_PC"),
        DynamicNode = {"Back", "ResourceBar", "BottomKey"},
        BottomKeyInfo = TabKeyInfo,
        InfoCallback = "NotShow",
        BackCallback = CloseCb,
        OwnerPanel = self,
        ForceHideTabs = false,
    })
    self:ShowTabResourceBar(false)
    self:ShowLevelUpBtn(false)

    self.Tab_Atrr:Init({Tabs = {
        { Text = GText("Mod_AttrTotal"), TabId = 1},
        { Text = GText("Mod_AttrDelta"), TabId = 2},
        },
        LeftGamePadKey = "LeftShoulder",
        RightGamePadKey = "RightShoulder",
    })
    self.Tab_Atrr:BindEventOnTabSelected(self,function(_,TabWidget)
        if self.CurrAttrTabIdx == TabWidget.Idx then return end
        if self.CurrAttrTabIdx ~= nil then
            self:InitAttrListField()
        end
        self.CurrAttrTabIdx = TabWidget.Idx
        self:UpdateAttrListImpl()
    end)

    self.Com_Search:BindEventOnContentChanged(self, function()
        if ModModel:IsRecommendView() then
        else
            self:SetUpModList(true)
        end
    end)
    self.Com_Search:SetHintText(GText("UI_Mod_SearchHint"))
end

function M:ReceiveEnterState(StackAction)
    M.Super.ReceiveEnterState(self, StackAction)
    if ModModel:IsInPolarityEditMode() then
        self:ShowTabResourceBar(true)
        if self.PolarityEditWidget then
            self.PolarityEditWidget:SetUpButtonWidget()
            self.PolarityEditWidget:SetCostNum()
            self.PolarityEditWidget:CheckIsAnySlotDirty()
        end
    end
    local SelectStuff = ModModel:GetSelectStuff()
    if SelectStuff and not ModController:IsGamepad() then
        if SelectStuff:IsSlot() then
            local SlotUI = self.ModSlotUIs[SelectStuff.SlotId]
            if SlotUI then
                self:UpdateSlotUIBySlotId(SelectStuff.SlotId)
                SlotUI:SetFocus()
            end
        elseif SelectStuff:IsModExist() then
            local Content = self:GetContentBySelectStuff(SelectStuff)
            if Content then
                if IsValid(Content.UI) then
                    Content.UI:SetFocus()
                else
                    Content.bAutoFocusForMod = true
                end
            end
        end
    end
end

function M:InitVisibilityWithCase()
    if not ModModel:IsModUINormal() then
        self.Panel_FilterSort:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Panel_Item:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Mod_Plan:SetVisibility(UIConst.VisibilityOp.Collapsed)
        -- self.Btn_CopyLink:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Btn_Share:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Panel_Btn:SetVisibility(UIConst.VisibilityOp.Collapsed)
        if ModModel:IsModUICopyMode() then
            self.Btn_Import:SetVisibility(UIConst.VisibilityOp.Visible)
        else
            self.Btn_Import:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    else
        self.Panel_FilterSort:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Panel_Item:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Mod_Plan:SetVisibility(UIConst.VisibilityOp.Visible)
        -- self.Btn_CopyLink:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Btn_Share:SetVisibility(UIConst.VisibilityOp.Visible)
        self:CheckEnableBtnWhenAnyEquip()
        self.Panel_Btn:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Btn_Discharge:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Btn_Auto:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Btn_Import:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self:ShowQuickEquipBtn(true)
    end
end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
    M.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
    if (Name ~= ModCommon.ArmoryMod) then
        self:SetComponent("BluePrints.UI.WBP.Abyss.Mod.Abyss_Mod_PC_Comp")
    end
    local MainUICase = nil
    self.Type, self.Tag, self.TabUuids, self.TabExInfos, self.CloseCallbackInfo, MainUICase, self.ReplaceChar = ...
    ModModel:SetMainUICase(MainUICase)
    self:InitVisibilityWithCase()
    self:InitTargetTab()
    self:InitBtnImport()
    self:InitBtnPolarity()
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "ArmoryModPage", nil)

    -- 武器删除第九个mod槽
    if self.Type == "Weapon" then
        self.Mod_9:SetVisibility(UIConst.VisibilityOp.Collapsed)
    elseif self.Type == "Char" then
        self.Mod_9.Panel_Aura:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end

    if ModModel:IsInPolarityEditMode() then
        ModController:StopPolarityEditMode()
    end

    -- Mod锁定状态变更
    self:AddDispatcher(EventID.OnUpdateBagItem, self, self.OnModLockChanged)
    self:SetFocus()
end

function M:OnModLockChanged(OpAction, ErrCode, Uuid)
    self:BlockAllUIInput(false)
    if (ErrCode ~= ErrorCode.RET_SUCCESS) then
        return
    end
    if OpAction == "StateChange" then
        local Content = self:GetContentByUuid(Uuid)
        local Mod = ModModel:GetMod(Uuid)
        if Content then
            Content.IsLocked = not Content.IsLocked
            if IsValid(Content.UI) and Mod then
                Content.UI:SetLock(Mod:IsLock() and 1 or 0)
            end
        end
        if self.ItemDetailsWidget.Btn_Locked:IsBtnForbidden() then
            local TipsId = Content.IsLocked and 7006 or 7007
            UIManager(self):ShowError(TipsId, nil, UIConst.Tip_CommonToast)
            self.ItemDetailsWidget.Btn_Locked:ForbidBtn(false)
        end
    end
end

function M:Close()
    if ModModel:IsInPolarityEditMode() then
        if self.PolarityEditWidget then
            self.PolarityEditWidget:Close()
        end
        return
    end
    if ModController.CurrUIName == ModCommon.ModImport then
        if self.ImportPanel then
            self.ImportPanel:Close()
        end
    end
    if (self.CloseCallbackInfo) then
        self.CloseCallbackInfo.Func(self.CloseCallbackInfo.Obj)
    end
    AudioManager(self):SetEventSoundParam(self, "ArmoryModPage", {ToEnd = 1})
    self:RemoveModReddotListen()
    self.Sift:Close()
    self.Sift:BindEventOnSelectionsChanged(nil,nil)
    self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    ModController:OnCloseView()
    M.Super.Close(self)
end

function M:Destruct()
    self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self:UnRegisterListAttrBtn()
    self.Btn_EditPolarity:UnBindEventOnClickedByObj(self)
    self.Btn_Auto:UnBindEventOnClickedByObj(self)
    self.Btn_Discharge:UnBindEventOnClickedByObj(self)
    -- self.Btn_CopyLink:UnBindEventOnClickedByObj(self)
    self.Btn_Share:UnBindEventOnClickedByObj(self)
    -- self.Btn_Share:UnBindEventOnReleased(self, self.OnSharedBtnRelease)
    self.CheckBox_Mod:UnBindEventOnClicked(self.CheckBox_Mod_Delegate)
    self.CheckBox_Mod:UnInitCommonCheckBox()
    self.List_Select_Mod.OnDragOver:Unbind()
    self.List_Select_Mod.OnCreateEmptyContent:Unbind()
    self.List_Select_Mod.BP_OnEntryInitialized:Clear()
    self.List_Role.BP_OnEntryInitialized:Remove(self, self.OnTargetTabSpawned)
    self.List_Role.BP_OnItemClicked:Remove(self, self.OnTargetTabSelected)
    self:UnbindAllFromAnimationFinished(self.LoadingPolarity_In)
    ModController:UnRegisterEvent(self)
    if (self.PolarityEditWidget) then
        self.PolarityEditWidget:RemoveFromParent()
        self.PolarityEditWidget = nil
    end
    self:StopModCostVX()
    self.BGAnchor:ClearChildren()
    M.Super.Destruct(self)
end
-- endregion

--region TargetTab
function M:ProcessCharTabExInfo(Info, CharContent, ...) 
    if Info then return end
    self.TargetCharUuid = CharContent.Target.Uuid
    if self.Tag == "Char" then 
        self.CurTargetTabContent = CharContent
    end
end
function M:ProcessWeaponTabExInfo(Info, WeaponContent, ...)
    if Info then return end
    local WeaponTag = ...
    if self.Tag == WeaponTag then
        self.CurTargetTabContent = WeaponContent
    end
end

function M:InitTargetTab()
    local Avatar = ModController:GetAvatar()
    local TabContents = {}

    for _, Uuid in ipairs(self.TabUuids) do
        local Char = Avatar.Chars[Uuid]
        local Info = self.TabExInfos and self.TabExInfos[Uuid] or nil
        if (Char) then
            local CharContent = ArmoryUtils:NewCharOrWeaponItemContent(Char, CommonConst.ArmoryType.Char, "Char", true)
            CharContent.Target = Char
            if Avatar.CurrentChar == Uuid then
                CharContent.bInGear = true
            end 
            self:ProcessCharTabExInfo(Info, CharContent)
            CharContent.IsSelect = false
            table.insert(TabContents, CharContent)
            goto continue1
        end
        local Weapon = Avatar.Weapons[Uuid] or Avatar.UWeapons[Uuid]
        if (Weapon) then
            local CurrWeapon
            local WeaponTag
            if Weapon:HasTag("Ultra") then
                WeaponTag = "UWeapon"
                if Weapon:Data().IsInvisible then
                    goto continue1
                end
                if (ModModel:IsModUINormal() and not Avatar:CheckUIUnlocked('UWeapon')) then
                    goto continue1
                end
                CurrWeapon = self.TargetCharUuid == Avatar.CurrentChar and Uuid
            elseif Weapon:HasTag("Melee") then
                WeaponTag = "Melee"
                CurrWeapon = Avatar.MeleeWeapon
            elseif Weapon:HasTag("Ranged") then
                WeaponTag = "Ranged"
                CurrWeapon = Avatar.RangedWeapon
            end
            local WeaponContent = ArmoryUtils:NewCharOrWeaponItemContent(Weapon, CommonConst.ArmoryType.Weapon,WeaponTag,true)
            WeaponContent.Target = Weapon
            self:ProcessWeaponTabExInfo(Info,WeaponContent,WeaponTag)
            if CurrWeapon == Uuid then
                WeaponContent.bInGear = true
            end
            WeaponContent.IsSelect = false
            table.insert(TabContents,WeaponContent)
        end
        ::continue1::
    end
    self.TabKey2Idx = {}
    for index, value in ipairs(TabContents) do
        self.TabKey2Idx[value.Tag] = index
    end

    self.List_Role_RealNum = #TabContents
    self.CurTargetTabContent.IsSelect = true
    self.List_Role:ClearListItems()
    for _, Content in ipairs(TabContents) do
        Content.Owner = self
        Content.IsNew = false
        Content.OnPreviewKeyDown = self.OnRoleListContentPreviewKeyDown
        self.List_Role:AddItem(Content)
    end
    self:ForceSelectNowTargetTab()
end

function M:OnRoleListContentPreviewKeyDown(KeyName)
    if (KeyName == "Gamepad_FaceButton_Bottom") then
        self.Mod_1:SetFocus()
        return UIUtils.Handled
    end
    return UIUtils.Unhandled
end

function M:ForceSelectNowTargetTab()
    local TargetTabContent = self.CurTargetTabContent
    self.CurTargetTabContent = nil
    self:OnTargetTabSelected(TargetTabContent)
end

function M:OnTargetTabSelected(TabContent)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_01", nil, nil)
    if TabContent == self.CurTargetTabContent then return end
    self:SyncTarget(TabContent)
    self:InitAttrListField()
    self:DirtyWorkForArmoryUI(TabContent)
    self.CurTargetTabContent = TabContent
    self:SetUpMainBody()

    self:ShowRecommendEntry(true)

    --重新注册红点回调
    if TabContent.Widget then
        self:OnTargetTabSpawned(TabContent, TabContent.Widget)
    end
end

function M:OnTargetTabSpawned(TabContent, UI)
    if not ModModel:IsModUINormal() then return end
    local Callback = function(_,Count)
        if Count>0 then
            UI:EMShowReddot(true, EReddotType.New)
        else 
            UI:EMShowReddot(false, EReddotType.New)
        end
    end
    if TabContent.IsSelect then
        self:AddModReddotListen(Callback, TabContent.Target)
    else
        self:AddModReddotListen(nil, TabContent.Target)
        local NodeName = self:_GetModReddotNodeName(TabContent.Target)
        local Node = ReddotManager.GetTreeNode(NodeName)
        Callback(nil, Node and Node.Count or 0)
    end
end

function M:SyncTarget(TargetContent)
    ModController:SyncTarget(TargetContent.Uuid)
    ModModel:FilterModsOfTarget()
    self.Type = TargetContent.Type
    self.Tag = TargetContent.Tag
end
-- endregion

-- region SetUp
function M:DirtyWorkForArmoryUI(TabContent)
    ModController:SetUICamera()
    self.CurrentMontageTags = {self.Type, TabContent.Tag, CommonConst.ArmoryType.Mod}
    ArmoryUtils:SetItemIsSelected(self.CurTargetTabContent, false)
    ArmoryUtils:SetItemIsSelected(TabContent, true)
end

function M:PlayTabInAnim()
    if (self.IsInit) then
        self:StopAnimation(self.TabSwitch)
    end
    self:PlayAnimation(self.TabSwitch)
end

function M:SequenceEvent_1()
    if (self.IsInit) then return end
    self.Overridden.SequenceEvent_1(self)
end

function M:StopDragDropping()
    if UWidgetBlueprintLibrary.IsDragDropping() then
        UWidgetBlueprintLibrary.CancelDragDrop()
        self:ShowQuickEquipBtn(true)
        self:ClearLinkLine()
    end
end

function M:SetUpMainBody()
    self:StopModCostVX()
    self:StopDragDropping()

    self:SetUpModTab()
    self:SetUpAttrList()
    self:SetUpFilterUI()
    self:SetUpModSlots()
    self:SetUpModList()
    self:SetUpModCost()
    self:SetUpCharSkillInfos()
    self:SetUpSuitSwitcher()
end

function M:SetUpModTab()
    if ModController:IsMobile() then
        self.Tab_Mod:LeaveViewSingleMode()
        self:ShowTabResourceBar(false)
    end
    local TargetName = ModModel.CopyModeSenderName or ModModel:GetTarget():GetName()
    self.Tab_Mod:UpdateTopTitle(GText("MESSAGE_TITLE_LOADING_31_PC") .. "/" .. TargetName)
    self:PlayTabInAnim()

    self.Btn_Auto:ForbidBtn(not next(ModModel.TargetMods))
end

function M:SetUpModList(bAnim)
    if bAnim == nil then bAnim = true end
    ModController:SetSelectedStuff(nil, nil)
    ModModel:SortMods()
    self.List_Select_Mod:ScrollToTop()
    self.List_Select_Mod:ClearListItems()
    self.needNavigation = false
    local FilterPolarity = self.Common_PolarityList_PC:GetFilterInfos()
    if #ModModel.CurModList ~= 0 then
        self.ModContents = {}
        for _, ModUuid in ipairs(ModModel.CurModList) do
            local Mod = ModModel:GetMod(ModUuid)

            if ModModel:IsRecommendModState() and not ModModel:FliterRecommendMod(Mod.ModId) then
                goto continue
            end

            if self:IsHideConflictMod() and Mod.ConflictUuids:Length() > 0 then
                goto continue
            end
            if not ModModel:DoModSearch(Mod, self:GetSearchText()) then
                goto continue
            end
            if ModModel:FilterSingleModOfTarget(FilterPolarity, false, Mod) then
                self:AddModContentToList(Mod)
                self.needNavigation = true
            end
            ::continue::
        end
    end
    self.List_Select_Mod:RequestFillEmptyContent()
    if bAnim then
        self.List_Select_Mod:RequestPlayEntriesAnim()
    end
end

function M:SetUpSuitSwitcher()
    if not self.Mod_Plan:IsVisible() then return end
    self.Mod_Plan:ResetWidget()
end

function M:SetUpCharSkillInfos()
    self.Panel_Skill:SetVisibility(UIConst.VisibilityOp.Collapsed)
    if not ModModel:IsModUINormal() then return end
    local Target = ModModel:GetTarget()
    if Target:GetTypeName() ~= "Char" then return end
    if not ModModel:GetAvatar():CheckUIUnlocked("Skill") then return end 
    self.Panel_Skill:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Mod_Skill:ClearListItems()
    for _, Skill in ipairs(Target.Skills) do
        local SkillData = DataMgr.Skill[Skill.SkillId]
        if SkillData and SkillData[1] and SkillData[1][0] and ModModel:IsOwnedBySkillTree(Skill.SkillId) then
            DebugPrint(WarningTag, "SetUpCharSkillInfos", Skill.SkillId)
            local Obj = NewObject(UIUtils.GetCommonItemContentClass())
            Obj.Parent = self
            Obj.Skill = Skill
            self.Mod_Skill:AddItem(Obj)
        end
    end
    local Count = self.Mod_Skill:GetNumItems()
    local LastObj = self.Mod_Skill:GetItemAt(Count - 1)
    LastObj.bHideLine = true
    local Spacing = self[string.format("SkillSpacing%s", Count)] or 0
    self.Mod_Skill.EntrySpacing = Spacing
    for _, Content in pairs(self.Mod_Skill:GetListItems()) do
        Content.LineOffset = Spacing * 0.5
    end
    self.Mod_Skill:RequestRefresh()
end

function M:SetUpAttrList()
    local AttrTabIdx = 1
    self.CurrAttrTabIdx = nil
    self.Tab_Atrr:SelectTab(AttrTabIdx)
end

function M:SetUpModCost()
    self.CachedCost = ModModel:GetCurrentSuitCost()
    self:UpdateCostUI(self.CachedCost)
end

function M:SetUpFilterUI()
    if not self.PolarityFilterConf then
        self.PolarityFilterConf = {}
        local SortedConfs = ModModel:GetSortedPolarityConfs()
        for _, PolarityInfo in pairs(SortedConfs) do 
            table.insert(self.PolarityFilterConf, {
                Polarity = PolarityInfo.Id,
            })
        end
    end
    self.Common_PolarityList_PC:Init(self.PolarityFilterConf)
    ModModel:SetSortConf(1, CommonConst.DESC)
    self.Common_SortList_PC:Init(self, {
        "UI_RARITY_NAME","UI_LEVEL_SELECT","UI_COST_NAME"
    }, ModModel.SortType)
end

function M:SetUpModSlots()
    ModModel:GenerateSlotUIDatas(ModModel:GetTarget().ModSuitIndex)
    local ModSuit = ModModel:GetTarget():GetModSuit()
    for SlotId, Slot in pairs(ModSuit) do
        local SlotUI = self["Mod_" .. SlotId]
        assert(SlotUI)
        self.ModSlotUIs[SlotId] = SlotUI
        SlotUI.Parent = self
        SlotUI:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        local Cb = function(SlotUI, PointerEvent, Operation)
            self:UpdateCostUI(self.CachedCost)
            self:ShowQuickEquipBtn(true)
            self:CloseLinkLine(Operation.Payload.Uuid, Operation.DefaultDragVisual)
        end
        SlotUI:SetCallbacks({
            OnDropCallback = Cb,
            OnDragCancelCallback = Cb,
            OnDragDetectedCallback = function(SlotUI, PointerEvent, Operation)
                self:ShowQuickEquipBtn(false)
                self:ShowLinkLine(Operation.Payload.Uuid, Operation.DefaultDragVisual)
            end,
            OnDragLeaveCallback = function(SlotUI, PointerEvent, Oparation)
                self:UpdateCostUI(self.CachedCost)
            end,
            OnDragEnterCallback = function(SlotUI, PointerEvent, Operation)
                local Case, Param1, Param2 = 0
                if Operation.Tag == "WBP_Com_Item_Universal_L_C" then
                    Case = ModCommon.CalcVolumeDiffCase.Change
                    Param1 = SlotUI.SlotUIData.SlotId
                    Param2 = Operation.Payload.Uuid
                    local _, CostDiff = ModModel:CalcModVolumeDiff(Case, ModModel:GetTarget(), Param1, Param2)
                    self:SetModCostPreview(CostDiff + self.CachedCost, false, Param2)
                elseif Operation.Tag == "ArmoryModSlot" then
                    Case = ModCommon.CalcVolumeDiffCase.Exchange
                    Param1 = Operation.InSlotUIData.SlotId
                    Param2 = SlotUI.SlotUIData.SlotId
                    local _, CostDiff = ModModel:CalcModVolumeDiff(Case, ModModel:GetTarget(), Param1, Param2)
                    self:SetModCostPreview(CostDiff + self.CachedCost, false)
                end
            end,
            OnRemovedFromFocusPathCallback = function(SlotUI, InFocusEvent)
                OnItemRemovedFromFocusPathEvent(self, SlotUI)
            end,
        })
        SlotUI:PlayRefresh()
        self:UpdateSlotUIBySlotId(SlotId)
    end
    ---隐藏多余的槽位
    for i = ModSuit:Length() + 1, ModCommon.MaxSlotCount do
        local SlotUI = self["Mod_" .. i]
        assert(SlotUI)
        SlotUI:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self:CheckEnableBtnWhenAnyEquip()
end
-- endregion

-- region ModController事件
function M:NotifyOnSuitNameEdited(TargetUuid, ModSuitIndex, NewName)
    self.Mod_Plan:OnEditSuitNameDone(ModSuitIndex, NewName)
end

function M:NotifyOnChangeModSuit(TargetUuid, ModSuitIndex)
    self:ForceSelectNowTargetTab()
end

function M:NotifyOnRevertEditSlotPolarity()
    self:UpdateAllSlotsUI()
    self:SetUpModCost()
end

function M:NotifyOnFoundModRepeat(ConflictSlotIds)
    AudioManager(self):PlayUISound(self, "event:/ui/common/mod_conflict", nil, nil)
    for _, ConflictSlotId in ipairs(ConflictSlotIds) do
        local SlotUI = self.ModSlotUIs[ConflictSlotId]
        if SlotUI then
            SlotUI:PlayConflictVX()
        end
    end
end

function M:NotifyOnPolarityModSelectedChanged(SelectedStuff, LastSelectedStuff)
    if LastSelectedStuff and LastSelectedStuff:IsSlot() then
        local ModSlotUI = self.ModSlotUIs[LastSelectedStuff.SlotId]
        if ModSlotUI then
            ModSlotUI:PlayNormalAnim()
        end
    end
end

function M:NotifyOnPendingEditSlotPolarity(SlotId)
    self:UpdateSlotUIBySlotId(SlotId)
    self:SetModCostPreview(ModModel.PolarityEditModeData.SuitCost)
end

function M:NotifyOnSelectStuffChanged(SelectedStuff, LastSelectedStuff)
    if LastSelectedStuff then
        if LastSelectedStuff:IsSlot() then
            local ModSlotUI = self.ModSlotUIs[LastSelectedStuff.SlotId]
            if ModSlotUI then
                ModSlotUI:PlayNormalAnim()
            end
            if LastSelectedStuff:IsModExist() then
                self:CloseModDetailPanel()
                self:ShowLevelUpBtn(false)
            end
        elseif LastSelectedStuff:IsModExist() then
            self:DoModItemSelected(LastSelectedStuff.ModUuid, false)
            self:CloseModDetailPanel()
            self:ShowLevelUpBtn(false)
        end
    end
    if SelectedStuff and SelectedStuff:IsModExist() then
        local CurrMod = ModModel:GetCurrSelectMod()
        self:ShowModDetailPanel(CurrMod, SelectedStuff.SlotId)
        self:ShowLevelUpBtn(true)
        self:DoModItemSelected(CurrMod.Uuid, true)
    end
    -- self:CheckEnablePolarityEditBtn()
end

function M:NotifyOnAutoEquipFinished()
    self.Btn_Auto:ForbidBtn(false)
    self:BlockAllUIInput(false)

    self:UpdateAttrListImpl()
    self:SetUpModList(false)

    self:RefreshModCostVX()
    AudioManager(self):PlayUISound(self, "event:/ui/armory/click_select_mod_equip", nil, nil)
    self:CheckEnableBtnWhenAnyEquip()

    self:SetDefaultGamepadFocus()
end

function M:NotifyOnAutoEquipTimeOut()
    self:NotifyOnAutoEquipFinished()
    -- self:ForceSelectNowTargetTab()
end

function M:NotifyOnAutoEquipAbort()
    self:NotifyOnAutoEquipFinished()
end

function M:NotifyOnTakeOffMod(TargetUuid, SuitIndex, SlotId, TakeOffModUuid)
    self:UpdateSlotUIBySlotId(SlotId)
    self:UpdateAttrListImpl()

    self:AppendModToListByUuid(TakeOffModUuid)
    self:CorrectModListWhenConflict()
    self:SortModListContent()

    self:RefreshModCostVX()
    self:CloseModDetailPanel()
    AudioManager(self):PlayUISound(self, "event:/ui/armory/click_select_mod_unequip", nil, nil)
    self:CheckEnableBtnWhenAnyEquip()
end

function M:NotifyOnTakeOffSuitMod(TargetUuid, SuitIndex)
    if ModModel:IsInImport() then return end
    self:UpdateAllSlotsUI()
    if not ModModel:IsInAutoEquip() then
        self:UpdateAttrListImpl()
        self:SetUpModList(false)
        self:RefreshModCostVX()
        self:CloseModDetailPanel()
        self:CheckEnableBtnWhenAnyEquip()
    else
        self:SetUpModCost()
    end
    AudioManager(self):PlayUISound(self, "event:/ui/armory/click_select_mod_unequip", nil, nil)
end

function M:NotifyOnChangeMod(TargetUuid, SuitIndex, SlotId, ModUuid,TakeOffModUuid)
    if ModModel:IsInImport() then return end
    self:UpdateSlotUIBySlotId(SlotId)
    if not ModModel:IsInAutoEquip() then
        self:UpdateAttrListImpl()
        self:AppendModToListByUuid(TakeOffModUuid)
        self:RemoveModToListByUuid(ModUuid)
        self:CorrectModListWhenConflict()
        self:SortModListContent()

        self:RefreshModCostVX()
        self:CloseModDetailPanel()
        AudioManager(self):PlayUISound(self, "event:/ui/armory/click_select_mod_equip", nil, nil)
        self:CheckEnableBtnWhenAnyEquip()
    end
end

function M:NotifyOnModLevelUp(OldModUuid, NewModUuid, bTakeOff, NewSelectedStuff, OldSelectedStuff)
    self:UpdateAttrListImpl()
    local NewMod = ModModel:GetMod(NewModUuid)
    local OldMod = ModModel:GetMod(OldModUuid)
    local SlotId = OldSelectedStuff.SlotId or (NewSelectedStuff and NewSelectedStuff.SlotId)
    if SlotId then
        if OldModUuid ~= NewModUuid then
            if OldMod and OldMod.Count > 0 then
                self:AppendModToListByUuid(OldModUuid)
            end
        end
        if bTakeOff then
            self:AppendModToListByUuid(NewModUuid)
            self:DoModItemSelected(NewModUuid, true)
        end
        self:UpdateSlotUIBySlotId(SlotId)
    else
        if OldModUuid ~= NewModUuid then
            if not OldMod or OldMod.Count == 0 then
                self:RemoveModToListByUuid(OldModUuid)
            end
            self:AppendModToListByUuid(NewModUuid)
            self:DoModItemSelected(NewModUuid, true)
        else
            self:UpdateModContent(NewMod)
        end
    end
    self:CorrectModListWhenConflict()
    self:SortModListContent()
    self:ScrollToMod(NewModUuid)
    self:SetUpModCost()
    if NewSelectedStuff then
        self:NotifyOnSelectStuffChanged(NewSelectedStuff, OldSelectedStuff)
    else
        self:ShowModDetailPanel(NewMod, SlotId)
    end
end

function M:NotifyOnForceCalcSlotsCost(DirtySlotIds)
    local bListDirty = false
    for SlotId, TakeOffModUuid in pairs(DirtySlotIds) do
        self:UpdateSlotUIBySlotId(SlotId)
        if ModModel:IsModUuidValid(TakeOffModUuid) then
            self:AppendModToListByUuid(TakeOffModUuid)
            bListDirty = true
        end
    end
    if bListDirty then
        self:UpdateAttrListImpl()
        self:CorrectModListWhenConflict()
        self:SortModListContent()
    end
end

function M:NotifyOnExchangeMod(TargetUuid, SuitIndex, OldSlotId, NowSlotId)
    self:UpdateSlotUIBySlotId(OldSlotId)
    self:UpdateSlotUIBySlotId(NowSlotId)
    AudioManager(self):PlayUISound(self, "event:/ui/armory/click_select_mod_equip", nil, nil)
    self:RefreshModCostVX()
end

function M:NotifyOnModCardLevelUp(ModUuid, Consumers, TakeOffSlotIds, RemoveUuids)
    if not table.isempty(TakeOffSlotIds) then
        for _, SlotId in ipairs(TakeOffSlotIds) do
            self:UpdateSlotUIBySlotId(SlotId)
        end
    end
    if not table.isempty(RemoveUuids) then
        for _, Uuid in ipairs(RemoveUuids) do
            self:RemoveModToListByUuid(Uuid)
        end
        self:CorrectModListWhenConflict()
        self:SortModListContent()
    end
end

function M:NotifyOnStartPolarityMode()
    self:CloseModDetailPanel()
    self:ShowQuickEquipBtn(false)
    self:ShowTabResourceBar(true)
    self.Mod_Plan:SetVisibility(UIConst.VisibilityOp.Collapsed)
    -- self.Btn_CopyLink:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Share:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:ShowRecommendEntry(false)

    local Delegate = nil
    Delegate = {self, function()
        self:BlockAllUIInput(false)
        self.List_Select_Mod:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Btn_EditPolarity:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.List_Role:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Btn_Auto:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Btn_Discharge:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Panel__Attr:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Panel_FilterSort:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self:UnbindAllFromAnimationFinished(self.LoadingPolarity_In)
        self:SetDefaultGamepadFocus()
        if self.PolarityEditWidget then
            self.PolarityEditWidget.Com_Cost.Key:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
        if ModController:IsPC() then
            self.Key_FocusList_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
            self.Key_SelectMod_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end}
    self:BindToAnimationFinished(self.LoadingPolarity_In, Delegate)
    self:PlayAnimationForward(self.LoadingPolarity_In)
    self:BlockAllUIInput(true, "SP_DisplayOnly")

    -- 打开极性编辑界面
    if (not self.PolarityEditWidget) then
        self.PolarityEditWidget = self:CreateWidgetNew(ModCommon.PolarityEditUI)
        local RootWidget = UIUtils.GetRootUWidget(self)
        RootWidget:AddChild(self.PolarityEditWidget)
        local WidgetSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.PolarityEditWidget)
        local Anchors = FAnchors()
        Anchors.Minimum = FVector2D(0, 0)
        Anchors.Maximum = FVector2D(1, 1)
        WidgetSlot:SetAnchors(Anchors)
        WidgetSlot:SetOffsets(FMargin(0, 0, 0, 0))
    end
    self.PolarityEditWidget:InitUIInfo(ModCommon.PolarityEditUI)
    self.PolarityEditWidget.Parent = self

    -- 更新已解锁的槽位
    self:UpdateAllSlotsUI()
    ModController:SetUICamera(self.PolarityCamOffset)
end

function M:NotifyOnStopPolarityMode()
    self.List_Select_Mod:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Btn_EditPolarity:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Mod_Plan:SetVisibility(UIConst.VisibilityOp.Visible)
    -- self.Btn_CopyLink:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Btn_Share:SetVisibility(UIConst.VisibilityOp.Visible)
    self:CheckEnableBtnWhenAnyEquip()
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        -- self.Btn_CopyLink:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Btn_Share:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.List_Role:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Btn_Auto:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Panel__Attr:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Btn_Discharge:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Panel_FilterSort:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    local Delegate = nil
    Delegate = {self, function()
        self:BlockAllUIInput(false)
        self:ShowQuickEquipBtn(true)
        self:ShowTabResourceBar(false)
        self:UnbindAllFromAnimationFinished(self.LoadingPolarity_In)
        self:SetDefaultGamepadFocus()
        if self.CurInputDeviceType == ECommonInputType.Gamepad then
            self.Key_FocusList_GamePad:SetVisibility(UIConst.VisibilityOp.Visible)
        end
        self.List_Role:SetFocus()

        self:ShowRecommendEntry(true)

    end}
    self:BindToAnimationFinished(self.LoadingPolarity_In, Delegate)
    self:PlayAnimationReverse(self.LoadingPolarity_In)
    self:BlockAllUIInput(true, "SP_DisplayOnly")
    self:RefreshModCostVX()
    -- 更新已解锁的槽位
    self:UpdateAllSlotsUI()
    ModController:SetUICamera(FVector(0, 0, 0))
end

function M:NotifyOnPolarityEditDone(TargetUuid)
    self:SetUpModList(false)
    self:UpdateAttrListImpl()
end
-- endregion

-- region 一些UI元素的动态显隐
function M:CheckEnableBtnWhenAnyEquip()
    if not ModModel:IsAnyModEquiped() then
        self.Btn_Discharge:ForbidBtn(true)
        -- self.Btn_CopyLink:ForbidBtn(true)
        self.ModShare:ForbidCopy(true)
    else
        self.Btn_Discharge:ForbidBtn(false)
        -- self.Btn_CopyLink:ForbidBtn(false)
        self.ModShare:ForbidCopy(false)
    end
end

-- function M:CheckEnablePolarityEditBtn()
--     local SelectedStuff = ModModel:GetSelectStuff()
--     if SelectedStuff and SelectedStuff:IsSlot() then
--         self.Btn_EditPolarity:ForbidBtn(false)
--     else
--         self.Btn_EditPolarity:ForbidBtn(true)
--     end
-- end

function M:AddTabItem(idx)
    if not self.Tab_Mod then
        return
    end
    local BottomKeyInfo = self.Tab_Mod.ConfigData.BottomKeyInfo
    BottomKeyInfo[idx] = self.BottomKeyInfo[idx]
end

function M:RemoveTabItem(idx)
    if not self.Tab_Mod then
        return
    end
    local BottomKeyInfo = self.Tab_Mod.ConfigData.BottomKeyInfo
    BottomKeyInfo[idx] = {}
end

function M:ShowQuickEquipBtn(bShow)
    if ModController:IsMobile() then return end
    if not ModModel:IsModUINormal() then bShow = false end
    if self.CurInputDeviceType == ECommonInputType.Gamepad then bShow = false end
    if not self.Tab_Mod then return end
    -- local QuickEquipBtn =self.Tab_Mod.BottomKeyWidget[3]
   if bShow then
        -- QuickEquipBtn :SetVisibility(UIConst.VisibilityOp.Visible)
        self:AddTabItem(2)
    else
        -- QuickEquipBtn :SetVisibility(UIConst.VisibilityOp.Collapsed)
        self:RemoveTabItem(2)
    end
    self.Tab_Mod:UpdateHotKeyInfo()
end

function M:ShowLevelUpBtn(bShow)
    if ModController:IsMobile() then return end
    if not ModModel:IsModUINormal() then bShow = false end
    if self.CurInputDeviceType == ECommonInputType.Gamepad then bShow = false end
    if not self.Tab_Mod then return end
    -- local LevelUpBtn = self.Tab_Mod.BottomKeyWidget[1]
    local SelectedMod = ModModel:GetCurrSelectMod()
    if bShow and SelectedMod and not SelectedMod:IsFinalMaxLevel() then
        -- LevelUpBtn :SetVisibility(UIConst.VisibilityOp.Visible)
        self:AddTabItem(1)
        local BottomKeyInfo = self.Tab_Mod.ConfigData.BottomKeyInfo[1]
        if SelectedMod:IsOriginalMaxLevel() then
            -- LevelUpBtn:SetDescription(GText("UI_FUNC_INCREASE"))
            BottomKeyInfo.Desc = GText("UI_FUNC_INCREASE")
        elseif SelectedMod:HasCardLevel() then
            -- LevelUpBtn:SetDescription(GText("UI_FUNC_LEVELUP"))
            BottomKeyInfo.Desc = GText("UI_FUNC_LEVELUP")
        end
    else
        -- LevelUpBtn :SetVisibility(UIConst.VisibilityOp.Collapsed)
        self:RemoveTabItem(1)
    end
    self.Tab_Mod:UpdateHotKeyInfo()
end


function M:ShowTabResourceBar(bShow)
    local ResourceBar = self.Tab_Mod.WBP_Com_Tab_ResourceBar or self.Tab_Mod.Panel_ResourceBar
    if bShow then
        ResourceBar :SetVisibility(UIConst.VisibilityOp.Visible)
    else
        ResourceBar :SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if (ResourceBar and ResourceBar.BindEvents) then
        ResourceBar:BindEvents(self, {
            OnRemovedFromFocusPath = self.OnResourceBarRemovedFromFocusPath
        })
    end
    self.Tab_Mod:UpdateResource()
end
-- endregion

-- region 冲突Mod关系连线
function M:ShowLinkLine(ModUuid, DragUI)
    self.SlotLineWidgets = {}
    self.DragLineWidgets = {}
    local SlotUIDatas = ModModel:GetSlotUIDatasWhichConflict(ModUuid)
    if table.isempty(SlotUIDatas) then return end
    for _,SlotUIData in ipairs(SlotUIDatas) do
        local SlotUI = self.ModSlotUIs[SlotUIData.SlotId]
        local bGolden = ModModel:IsRecommendedMod(SlotUIData, ModUuid)
        local SlotLine = SlotUI:ShowLinkLine(bGolden)
        local DragLine = DragUI:ShowLinkLine(bGolden)
        table.insert(self.SlotLineWidgets, SlotLine)
        table.insert(self.DragLineWidgets, DragLine)
        SlotLine.Main:SetRenderOpacity(0)
        DragLine.Main:SetRenderOpacity(0)
    end
    local _, TickerKey = self:AddTimer(0.01, self.TickLinkLine, true)
    self.LinkLineTicker = TickerKey
end

function M:TickLinkLine()
    if table.isempty(self.SlotLineWidgets) and table.isempty(self.DragLineWidgets) then
        return
    end
    for i = 1, #self.SlotLineWidgets do
        local SlotLineWidget = self.SlotLineWidgets[i]
        local DragLineWidget = self.DragLineWidgets[i]
        SlotToDrag.X, SlotToDrag.Y = 0, 0
        local SlotLineGeo = SlotLineWidget:GetTickSpaceGeometry()
        local DragLineGeo = DragLineWidget:GetTickSpaceGeometry()
        local SlotLinePos = USlateBlueprintLibrary.LocalToViewport(self, SlotLineGeo, SlotToDrag)
        local DragLinePos = USlateBlueprintLibrary.LocalToViewport(self, DragLineGeo, SlotToDrag)
        SlotToDrag.X = SlotLinePos.X - DragLinePos.X
        SlotToDrag.Y = SlotLinePos.Y - DragLinePos.Y
        local Dist = SlotToDrag:Size()
        local Angle = math.deg(math.acos(SlotToDrag.X / Dist))
        if SlotToDrag.Y < 0 then
            Angle = -Angle
        elseif SlotToDrag.Y >= 0 then
            Angle = Angle
        end
        SlotLineWidget:SetPosture(Dist, 180 + Angle)
        DragLineWidget:SetPosture(Dist, Angle)
    end
end

function M:CloseLinkLine(ModUuid, DragUI)
    self:ClearLinkLine()
    local SlotUIDatas = ModModel:GetSlotUIDatasWhichConflict(ModUuid)
    if table.isempty(SlotUIDatas) then return end
    for _,SlotUIData in ipairs(SlotUIDatas) do
        local SlotUI = self.ModSlotUIs[SlotUIData.SlotId]
        SlotUI:CloseLinkLine()
    end
    if IsValid(DragUI) then
        DragUI:CloseLinkLine()
    end
end

function M:ClearLinkLine()
    for _, Widget in pairs(self.SlotLineWidgets) do
        Widget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    for _, Widget in pairs(self.DragLineWidgets) do
        Widget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.SlotLineWidgets = {}
    self.DragLineWidgets = {}
    if self:IsExistTimer(self.LinkLineTicker) then
        self:RemoveTimer(self.LinkLineTicker)
        self.LinkLineTicker = nil
    end
    if self:IsExistTimer(self.LinkDelayTimer) then
        self:RemoveTimer(self.LinkDelayTimer)
        self.LinkDelayTimer = nil
    end
end
-- endregion

-- region Mod列表操作
function M:ScrollToMod(ModUuid)
    local ModContent = self:GetContentByUuid(ModUuid)
    if ModContent then
        self.List_Select_Mod:BP_ScrollItemIntoView(ModContent)
    end
end

function M:IsHideConflictMod()
    return self.CheckBox_Mod:IsChecked()
end

function M:GetSearchText()
    return self.Com_Search:GetText()
end

function M:DoModItemSelected(ModUuid, bSelected)
    local SelectedContent = self:GetContentByUuid(ModUuid)
    if SelectedContent then
        SelectedContent.IsSelected = bSelected
        if IsValid(SelectedContent.UI) then
            SelectedContent.UI:SetIsSelected(bSelected)
        end
    end
end

function M:RemoveModToListByUuid(ModUuid)
    local ModContent = self:GetContentByUuid(ModUuid)
    if ModContent then
        -- ModContent.IdleCount = ModContent.IdleCount - 1
        -- if ModContent.IdleCount ==0 then
        self.List_Select_Mod:RemoveItem(ModContent)
        self.ModContents[ModUuid] = nil
        -- end
    end
end

function M:AppendModToListByUuid(ModUuid)
    if not ModUuid then return end
    local TakeOffMod = ModModel:GetMod(ModUuid)
    local FilterPolarity = self.Common_PolarityList_PC:GetFilterInfos()
    if ModModel:FilterSingleModOfTarget(FilterPolarity, nil, TakeOffMod) then
        if ModModel:IsRecommendModState() and not ModModel:FliterRecommendMod(TakeOffMod.ModId) then
            return
        end

        -- local ExistContent = self.ModContents[ModUuid] 
        -- if ExistContent then
        --     ExistContent.IdleCount = ExistContent.IdleCount +1
        --     return
        -- end
        local LastIndex = self.List_Select_Mod:GetNumItems() - 1
        local LastContent = self.List_Select_Mod:GetItemAt(LastIndex)
        if LastContent.Uuid == nil then
            self.List_Select_Mod:RemoveItem(LastContent)
        end
        self:AddModContentToList(TakeOffMod)
    end
end

function M:CorrectModListWhenConflict()
    local ListItems = self.List_Select_Mod:GetListItems()
    local ConflictModContents = {}
    local ModContentInList = {}
    for _, Content in pairs(ListItems) do
        if Content.Uuid then
            local Mod = ModModel:GetMod(Content.Uuid)
            if Mod then
                -- Content.ShowWarningText = Mod.ConflictUuids:Length()>0 and or nil
                if IsValid(Content.UI) then
                    if Mod.ConflictUuids:Length() > 0 then
                        Content.UI:ShowContentWarning(GText("UI_Armory_Conflict"))
                    else
                        Content.UI:ShowContentWarning(nil)
                    end
                end
                if Mod.ConflictUuids:Length() > 0 then
                    table.insert(ConflictModContents, Content)
                end
                ModContentInList[Mod.Uuid] = Content
            end
        end
    end
    if self:IsHideConflictMod() then
        for _, Content in ipairs(ConflictModContents) do
            self:RemoveModToListByUuid(Content.Uuid)
        end
        for _, ModUuid in ipairs(ModModel.CurModList) do
            local Mod = ModModel:GetMod(ModUuid)
            if not ModContentInList[Mod.Uuid] and Mod.ConflictUuids:Length() <= 0 then
                self:AppendModToListByUuid(Mod.Uuid)
            end
        end
    end
end

function M:SortModListContent()
    local ListItems = self.List_Select_Mod:GetListItems()
    local SortBy, _ = self.Common_SortList_PC:GetSortInfos()
    ULowEntryExtendedStandardLibrary.SortObjectArrayDirectly(ListItems,
        {self, function(self, ModContent1, ModContent2)
            if ModContent2.Uuid == nil then return true end
            if ModContent1.Uuid == nil then return false end
            local Mod1 = ModModel:GetMod(ModContent1.Uuid)
            local Mod2 = ModModel:GetMod(ModContent2.Uuid)
            if Mod2 == nil then return true end
            if Mod1 == nil then return false end
            return ModModel.ModSortFunc[SortBy](Mod1, Mod2)
        end},false)
    self.List_Select_Mod:BP_SetListItems(ListItems)
    self.List_Select_Mod:RequestFillEmptyContent()
end

function M:AddModContentToList(Mod)
    local ModContent = self:CreateModContent(Mod,true, true)
    if not ModContent then return end
    self.ModContents[Mod.Uuid] = ModContent
    self.List_Select_Mod:AddItem(ModContent)
end

---@param Mod ModModel
function M:UpdateModContent(Mod)
    local ModContent = self:GetContentByUuid(Mod.Uuid)
    if not ModContent then return end
    ModContent.Level = Mod.Level
    ModContent.Cost = Mod.Cost
    ModContent.CardLevel = Mod.CurrentModCardLevel
    ModContent.IsSelected = ModModel:GetSelectStuff().ModUuid == Mod.Uuid
    if IsValid(ModContent.UI) then
        ModContent.UI:UpdateModItem(ModContent)
    end
end

function M:CreateModContent(Mod)
    if ModModel:IsEquipedInCurrSuit(Mod.Uuid) then
        return nil
    end
    local ModContent = ModModel:CreateModContent(Mod, true, true)
    ModContent.IsNew = ArmoryUtils:TryAddNewModReddot(Mod)
    ModContent.Parent = self
    if ModCommon.DebugMode then
        ModContent.bNewGlow = true
    end
    ModContent.IsShowDetails = ModController:IsPC()
    ModContent.MenuPlacement = EMenuPlacement.MenuPlacement_CenteredAboveAnchor
    ModContent.OnMouseButtonDownEarly = OnItemMouseButtonDownEarlyEvent
    ModContent.MouseButtonUpEvent = OnItemMouseButtonUpEvent
    ModContent.OnMouseEnter = OnItemMouseEnterEvent
    ModContent.OnMouseLeave = OnItemMouseLeaveEvent
    ModContent.OnDragLeave = OnItemDragLeave
    ModContent.CreateDragWidget = OnItemCreateDragWidget
    ModContent.OnDragCancelled = OnItemDragCancelled
    -- ModContent.AdjustBackGroundHeightDelay=0.5
    ModContent.OnRemovedFromFocusPathEvent = OnItemRemovedFromFocusPathEvent
    return ModContent
end

function M:CreateEmptyContent()
    local EmptyContent = NewObject(UIUtils.GetCommonItemContentClass())
    EmptyContent.Parent = self
    -- EmptyContent.MouseButtonDownEvent = OnItemMouseButtonDownEvent
    EmptyContent.OnDragLeave = OnItemDragLeave
    EmptyContent.CreateDragWidget = OnItemCreateDragWidget
    EmptyContent.OnMouseButtonDownEarly = OnItemMouseButtonDownEarlyEvent
    return EmptyContent
end
-- endregion

-- region 槽位和tips
function M:UpdateSlotUIBySlotId(SlotId)
    local SlotUI = self.ModSlotUIs[SlotId]
    local SlotUIData = ModModel:GetSlotUIData(SlotId)
    SlotUI:UpdateSlotUI(SlotUIData)
end

function M:UpdateAllSlotsUI()
    for SlotId, SlotUIData in pairs(ModModel.CurSlots) do
        self:UpdateSlotUIBySlotId(SlotId)
    end
end

function M:CloseModDetailPanel()
    if not IsValid(self.ItemDetailsWidget) then return end
    self:_SetPanelAttrVisibility(true)
    self.ItemDetailsWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    if ModModel:IsModUINormal() then
        self.Btn_Discharge:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Btn_Auto:SetVisibility(UIConst.VisibilityOp.Visible)
    end
    if (self.CurInputDeviceType == ECommonInputType.Gamepad) then
        self.Key_FocusList_GamePad:SetVisibility(UIConst.VisibilityOp.Visible)
    end
    self.IsOpenModDetailPanel = false
    self.bItemDetailsClicked = false
end

function M:_SetPanelAttrVisibility(bVisible)
    if self:IsExistTimer(self.PanelAttrTimer) then
        self:RemoveTimer(self.PanelAttrTimer)
        self.PanelAttrTimer = nil
    end
    if bVisible then
        local _, TimerKey = self:AddTimer(0.1, function()
            self.Panel__Attr:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            self.Panel_Btn:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        end)
        self.PanelAttrTimer = TimerKey
    else
        self.Panel__Attr:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Panel_Btn:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:ShowModDetailPanel(Mod, SlotId)
    if ModModel:IsBugMod(Mod.Uuid) then return end
    self:_SetPanelAttrVisibility(false)
    if not IsValid(self.ItemDetailsWidget) then
        self.ItemDetailsWidget = self.Tip_Mod
    end
    local SelectedContent = self:GetContentByUuid(Mod.Uuid)
    if SlotId then
        SelectedContent = self.ModSlotUIs[SlotId].ModContent
    end
    SelectedContent.bIsHoverState = false
    self.ItemDetailsWidget:SetVisibility(UIConst.VisibilityOp.Visible)
    self.ItemDetailsWidget:SetCallbacks({
        CallObj = self,
        OnMouseButtonDownCallback = self.PreventItemDeselect,
    })
    SelectedContent.LockedButtonClickCallBack = OnDetailLockBtnClick
    self.ItemDetailsWidget:RefreshItemInfo(SelectedContent, nil, true)
    self.ItemDetailsWidget:StopAllAnimations()
    if ModController:IsMobile() then
        self.ItemDetailsWidget:OverrideSizeX(self.PhoneItemTipsWidth)
    end
    AudioManager(self):PlayUISound(self, "event:/ui/armory/tip_show", nil, nil)
    self.ItemDetailsWidget:PlayAnimation(self.ItemDetailsWidget.In)
    self.Btn_Discharge:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Auto:SetVisibility(UIConst.VisibilityOp.Collapsed)
    if (self.CurInputDeviceType == ECommonInputType.Gamepad) then
        self.Key_FocusList_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.ItemDetailsWidget.Panel_Controller:SetVisibility(ESlateVisibility.Collapsed)
    self.IsOpenModDetailPanel = true
end
-- endregion

function M:OnKeyDown(MyGeometry, InKeyEvent)
    if (CommonUtils:IfExistSystemGuideUI(self)) then
        return UIUtils.Handled
    end
    local InKey = UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if ModController.CurrUIName == ModCommon.ModImport then
        if self.ImportPanel then
            local Handled = self.ImportPanel:OnKeyDown(MyGeometry, InKeyEvent)
            if Handled == UWidgetBlueprintLibrary.Handled() then
                return Handled
            end
        end
    end
    local KeyFunc = self.KeyFuncMap[InKeyName]
    if KeyFunc then KeyFunc() end
    -- 处理手柄按键
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        DebugPrint("thy    Key_IsGamepadKey", InKeyName)
        IsEventHandled = self:Handle_OnGamePadDown(InKeyName)
    end
    M.Super.OnKeyDown(self, MyGeometry, InKeyEvent)
    return UIUtils.Handled
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
    if (CommonUtils:IfExistSystemGuideUI(self)) then
        return UIUtils.Handled
    end
    local InKey = UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if ModController.CurrUIName == ModCommon.ModImport then
        if self.ImportPanel then
            local Handled = self.ImportPanel:OnKeyUp(MyGeometry, InKeyEvent)
            if Handled == UWidgetBlueprintLibrary.Handled() then
                return Handled
            end
        end
    end
    local KeyFunc = self.KeyFuncMap[InKeyName]
    if KeyFunc then KeyFunc() end
    -- 处理手柄按键
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        DebugPrint("jly    Key_IsGamepadKey", InKeyName)
        IsEventHandled = self:Handle_OnGamePadUp(InKeyName)
    end
    if (ModCommon.DebugMode and InKeyName == "Enter") then
        local SelectMod = ModModel:GetCurrSelectMod()
        if SelectMod then
            PrintTable(SelectMod, 3, "看看选中的Mod数据")
        end
    end

    M.Super.OnKeyDown(self, MyGeometry, InKeyEvent)
    return UIUtils.Handled
end
-- endregion

-- region 一些按钮的回调
function M:PreventItemDeselect()
    self.bItemDetailsClicked = true
end

function M:OnSharedBtnClick()
    self.ModShare:Show()
end

-- function M:OnSharedBtnRelease()
--     self.ModShare:SetFocus()
-- end

function M:OnClickBtnAutoEquip()
    local Callback = function()
        self.Btn_Auto:ForbidBtn(true)
        self:BlockAllUIInput(true)
        ModController:LaunchAutoEquipMod()
    end
    if ModModel:IsAnyModEquiped() then
        local Params = {RightCallbackFunction = Callback}
        Params.OnCloseCallbackObj = self
        Params.AutoFocus = true
        --不要瞎聚焦，否则会导致自动装配被Esc键退出打断，自动装配期间是不允许键盘和手柄交互的
        -- Params.OnCloseCallbackFunction = function()
        --     self:SetDefaultGamepadFocus()
        -- end
        UIManager():ShowCommonPopupUI(ModCommon.AutoEquipTakeOffDialog, Params, self)
    else
        Callback()
    end
end

function M:OnClickBtnImport()
    self.Btn_Import:ForbidBtn(true)
    self.ImportPanel = ModController:OpenView(ModCommon.ModImport, ModModel:GetTarget(), function()
        ModController.CurrUIName = ModCommon.ArmoryMod
        self.Btn_Import:ForbidBtn(false)
    end)
end

function M:OnListModScrollingByDrag(MyGeometry,PointerEvent)
    local DragOperation = UWidgetBlueprintLibrary.GetDragDroppingContent()
    if not DragOperation then return true end
    if DragOperation.Tag ~= "WBP_Com_Item_Universal_L_C" then return true end
    local DragUI = DragOperation.DefaultDragVisual
    if not IsValid(DragUI) then return true end
    DragUI:SetVisibility(UIConst.VisibilityOp.Collapsed)
    for i=1, #self.SlotLineWidgets do
        local SlotLine = self.SlotLineWidgets[i]
        local DragLine = self.DragLineWidgets[i]
        SlotLine.Main:SetRenderOpacity(0)
        DragLine.Main:SetRenderOpacity(0)
    end
    -- self:ShowQuickEquipBtn(true)
    return true
end
-- endregion

-- region 耐受值
function M:UpdateCostUI(NowCost)
    local MaxCost = ModModel:GetTargetMaxCost()
    self.Text_Volume_Now:SetText(NowCost)
    self.Text_Volume_Now:SetColorAndOpacity(self.ModCostNormalColor)
    self.Text_Volume_Max:SetText(MaxCost)
    self.Bar_CostPreview:SetVisibility(UIConst.VisibilityOp.Collapsed)
    local Percent = NowCost / MaxCost
    local Mat = self.Bar_Volume:GetDynamicMaterial()
    Mat:SetScalarParameterValue("Percent", Percent)
    if ModModel:IsInPolarityEditMode() and self.PolarityEditWidget then
        self.PolarityEditWidget:ShowWarning()
    else
        self.Panel_Hint:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:SetModCostPreview(PreviewCost, bWarning, ModUuid)
    if bWarning==nil then bWarning = true end
    self:SetUpModCost()
    if PreviewCost == self.CachedCost then 
        return
    end
    local MaxCost = ModModel:GetTargetMaxCost()
    if ModUuid then
        local Mod = ModModel:GetMod(ModUuid)
        local HaloSlot = ModModel:GetSlotUIData(ModCommon.MaxSlotCount)
        if Mod and HaloSlot and not HaloSlot:GetMod() then
            MaxCost = MaxCost + Mod:CalcExtralCharVolume()
            self.Text_Volume_Max:SetText(MaxCost)
        end
    end
    self.Bar_CostPreview:SetVisibility(UIConst.VisibilityOp.Visible)
    local Percent = self.CachedCost / MaxCost
    local PreviewPercent = math.min(PreviewCost / MaxCost, 1)
    local PreviewMat = self.Bar_CostPreview:GetDynamicMaterial()
    if PreviewCost < self.CachedCost then
        -- self.Text_Volume_Now:SetColorAndOpacity(self.ModCostSubColor)
        -- PreviewMat:SetScalarParameterValue("Percent", Percent)
        -- local Mat = self.Bar_Volume:GetDynamicMaterial()
        -- Mat:SetScalarParameterValue("Percent", PreviewPercent)
        -- self.Bar_Volume:SetBrushFromMaterial(Mat)
        -- self.Bar_CostPreview:SetColorAndOpacity(self.ModCostSubColor.SpecifiedColor)

        self.Bar_CostPreview:SetVisibility(UIConst.VisibilityOp.Collapsed)
        return
    elseif PreviewCost > MaxCost then
        self.Text_Volume_Now:SetColorAndOpacity(self.ModCostOverflowColor)
        PreviewMat:SetScalarParameterValue("Percent", PreviewPercent)
        self.Bar_CostPreview:SetColorAndOpacity(self.ModCostOverflowColor.SpecifiedColor)
        if bWarning then
            if ModModel:IsInPolarityEditMode() then
                self.PolarityEditWidget:ShowWarning(GText("UI_Mod_Cost_Overflow"))
            else
                self.Panel_Hint:SetText(ErrorCode:GetText(ErrorCode.RET_MOD_OVER_CHAR_MODVOLUME))
                self.Panel_Hint:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            end
        end
    elseif PreviewCost <= MaxCost then
        self.Text_Volume_Now:SetColorAndOpacity(self.ModCostAddColor)
        PreviewMat:SetScalarParameterValue("Percent", PreviewPercent)
        self.Bar_CostPreview:SetColorAndOpacity(self.ModCostAddColor.SpecifiedColor)
    end
    self.Text_Volume_Now:SetText(PreviewCost)
    self.Bar_CostPreview:SetBrushFromMaterial(PreviewMat)
end

function M:StopModCostVX()
    if (self:IsExistTimer(self.ModCostVXTimerKey)) then
        self:RemoveTimer(self.ModCostVXTimerKey)
        self.ModCostVXTimerKey = nil
    end
    ForceStopAsyncTask(self, "RefreshModCostVXTask")
end

function M:RefreshModCostVX()
    self:StopModCostVX()
    RunAsyncTask(self, "RefreshModCostVXTask", function(CoroutineObj)
        local CurrCost = ModModel:GetCurrentSuitCost()
        local CostDiff = CurrCost - self.CachedCost
        if CostDiff == 0 then
            self:SetUpModCost()
            return
        end
        local SpeedUpTime = 0
        if CostDiff > 0 then
            AudioManager(self):PlayUISound(self, "event:/ui/armory/cost_bar_grow", nil, nil)
        else
            AudioManager(self):PlayUISound(self, "event:/ui/armory/cost_bar_dec", nil, nil)
        end
        while (CostDiff ~= 0) do
            local _, TimerKey = self:AddTimer(0.05 / self.ModCostAnimSpeed, function()
                local CostInc = 1 << SpeedUpTime
                SpeedUpTime = math.min(SpeedUpTime + 1, 4)
                if CostDiff > 0 then
                    self.CachedCost = math.min(self.CachedCost + CostInc, CurrCost)
                elseif CostDiff < 0 then
                    self.CachedCost = math.max(self.CachedCost - CostInc, CurrCost)
                end
                self:UpdateCostUI(self.CachedCost)
                self.ModCostVXTimerKey = nil
                coroutine.resume(CoroutineObj, self)
            end)
            self.ModCostVXTimerKey = TimerKey
            coroutine.yield()
            CurrCost = ModModel:GetCurrentSuitCost()
            CostDiff = CurrCost - self.CachedCost
        end
    end)
end
-- endregion

-- region 属性列表
function M:IsModAdditionOnly()
    return self.CurrAttrTabIdx == 2
end

function M:GetCurrWeaponOwnerChar()
    local Avatar = ModModel:GetAvatar()
    return self.ReplaceChar or Avatar.Chars[self.TargetCharUuid]
end

function M:GetCurrentAttrs(Mod)
    local Avatar = ModModel:GetAvatar()
    local MeleeWeapon, RangedWeapon = nil, nil
    if Avatar.MeleeWeapon then
        MeleeWeapon = Avatar.Weapons[Avatar.MeleeWeapon]
    end
    if Avatar.RangedWeapon then
        RangedWeapon = Avatar.Weapons[Avatar.RangedWeapon]
    end
    local ExtraInfo = {MeleeWeapon = MeleeWeapon, RangedWeapon = RangedWeapon}
    local Attrs = {}
    if self.Type == "Weapon" or self.Type=="UWeapon" then 
        ExtraInfo.Char = self:GetCurrWeaponOwnerChar()
    end
    if Mod then
        ExtraInfo.ModSuit = ModModel:GetTarget().ModSuitIndex
        AvatarUtils:InitModInfo(Avatar, ExtraInfo, ModModel:GetTarget())
        if not ModModel:IsEquipedInCurrSuit(Mod.Uuid) then
            table.insert(ExtraInfo.ModData, Mod)
        else
            local Res,i = table.findValue(ExtraInfo.ModData, Mod, function(v, Target)
                return Target.Uuid == v.Uuid
            end)
            if Res then table.remove(ExtraInfo.ModData, i) end
        end
        Attrs = ModModel:GetTarget():DumpBattleAttr(Avatar, ExtraInfo).TotalValues or {}
    else
        Attrs = ModModel:GetTarget():DumpDefaultBattleAttr(Avatar,ExtraInfo).TotalValues or {}
    end
    if self.Type == "Char" then
        Attrs["ModVolume"] = ModModel:GetTargetMaxCost()
    end
    return Attrs
end

function M:GetPreviousAttrs(PureTargetAttrs)
    local PreAttrs = CommonUtils.CopyTable(self.Attrs)
    for k, v in pairs(PureTargetAttrs) do
        if PreAttrs[k] and type(v) == "number" then
            PreAttrs[k] = PreAttrs[k] + v
        end
    end
    return PreAttrs
end

function M:IsRecommendAttr(AttrKey)
    return ModModel:IsRecommendAttr(AttrKey)
end

function M:InitAttrListField()
    self.Attrs = {}
    self.ComparedAttrs = nil
    self.Index2AttrKey = {}
    self.ComparedTarget = false
end

function M:GetPureAttrsOfTarget()
    local WeaponOwnerChar = nil
    if self.Type == "Weapon" or self.Type == "UWeapon" then
        WeaponOwnerChar = self:GetCurrWeaponOwnerChar()
    end
    local PureTargetAttrs = ModModel:GetPureAttrsOfTarget(WeaponOwnerChar)
    return PureTargetAttrs
end

function M:UpdateAttrListImpl()
    local PureTargetAttrs = self:GetPureAttrsOfTarget()
    local bModAdditionOnly = self:IsModAdditionOnly()
    local PreAttrs = self:GetPreviousAttrs(bModAdditionOnly and PureTargetAttrs or {})
    local NowAttrs = self:GetCurrentAttrs()
    self.Index2AttrKey = {}
    self.ComparedTarget, self.ComparedAttrs, self.Attrs = 
        ModModel:GenerateAttrList(PreAttrs, NowAttrs, self.Index2AttrKey, false, PureTargetAttrs, bModAdditionOnly)
    if not self.ComparedTarget then 
        if table.isempty(self.ComparedAttrs) then
            self.List_Attribute:SetVisibility(UIConst.VisibilityOp.Visible)
            self:UpdateAttrListView(true, self.List_Attribute, bModAdditionOnly)
        end
        return
    end
    self:UpdateAttrListView(true, self.List_Attribute, bModAdditionOnly)
end
-- endregion

-- region 装备魔之楔推荐
function M:InitRecommend()
    -- self.Btn_Delete:SetData()
    self.Btn_Delete:SetClickCallback({
        Func = self.ClearRecommendFliter,
        Obj = self
    })
    self.Btn_Delete:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    self.Btn_Delete:SetGamePad(
    {
        KeyInfoList ={
            {
                Type = "Img",
                ImgShortPath = UIConst.GamePadImgKey.SpecialLeft,
                ClickCallback = self.FocusRecommendBtn, 
                Owner = self 
            }
        },
        bLongPress = true
    })
    self.Btn_Delete:SetData({OnFocusLeaveCallback = {Obj = self, Func = self.SetRecommendBtnState}})

    -- self.Btn_Recommend:SetData()
    self.Btn_Recommend:SetClickCallback({
        Func = self.GetRecommendRankData,
        Obj = self
    })
    self.Btn_Recommend:SetText(GText("UI_ModRecommandData"))
    self.Btn_Recommend:SetData({OnFocusLeaveCallback = {Obj = self, Func = self.SetRecommendBtnState}})

    self.Btn_Recommend:SetGamePad(
    {
        KeyInfoList ={
            {
                Type = "Img",
                ImgShortPath = UIConst.GamePadImgKey.SpecialLeft,
                ClickCallback = self.FocusRecommendBtn, 
                Owner = self 
            }
        },
        bLongPress = true
    })
    self.Btn_Recommend:SetGamePadIconVisible(true)

    self.Btn_Delete:SetNavigationRuleExplicit(EUINavigation.Right, self.Btn_Recommend)
end

function M:FocusRecommendBtn()
    if ModModel:IsRecommendModState() then
        self.Btn_Delete:SetFocus()
    else
        self.Btn_Recommend:SetFocus()
    end

    -- Gamepad_Special_Left冲突，这里需要复原
    self.IsFocusInSpecialItem = false
    self.Key_Gamepad:SetVisibility(UIConst.VisibilityOp.Visible)
end

function M:ClearRecommendFliter()
    self:ClearAllFliter()
    self.RecommendView:ClearFliter()
    self:OnRecommendFliterChange()

    if ModController:IsGamepad() then
        self.List_Role:SetFocus()
    end
end

function M:GetRecommendRankData()
    local Target = ModModel:GetTarget()
    local TargetType = Target:GetTypeName()
    local TargetId
    if TargetType == "Weapon" or TargetType == "UWeapon" then
        TargetId = Target.WeaponId
    elseif TargetType == "Char" then
        TargetId = Target.CharId
    end
    self:BlockAllUIInput(true, "SP_DisplayOnly")
    local Avatar = GWorld:GetAvatar()
    Avatar:GetModRankData(TargetType, TargetId, {
        Func = self.ShowRecommendView,
        Obj = self
    })
end

function M:ShowRecommendView(Data, UserCount)
    self:BlockAllUIInput(false)
    local Params = {
        TargetName = ModModel.CopyModeSenderName or ModModel:GetTarget():GetName(),
        FliterCallbackInfo = {
            Func = self.OnRecommendFliterChange,
            Obj = self,
        },
        HideCallbackInfo = {
            Obj = self,
            Func = self.OnRecommendViewHide
        },
        RankModData = Data,
        UserCount = UserCount
    }
    local Avatar = ModController:GetAvatar()
    for _, Uuid in ipairs(self.TabUuids) do
        local Char = Avatar.Chars[Uuid]
        if (Char) then
            Params.CharId = Char.CharId
        end
    end

    if not self.RecommendView then
        local RecommendView = self:CreateWidgetNew(ModCommon.ArmoryModRecommend)
        local RootWidget = UIUtils.GetRootUWidget(self)
        RootWidget:AddChild(RecommendView)
        self.RecommendView = RecommendView
        self.RecommendView:SetData(Params)
        self.RecommendView:SetVisibility(UIConst.VisibilityOp["Visible"])
        --self.RecommendView.List_Item:SetFocus()
        self.RecommendView:SetRecommendFocus()
    else
        self.RecommendView:SetVisibility(UIConst.VisibilityOp["Visible"])
        self.RecommendView:SetData(Params)
        --self.RecommendView.List_Item:SetFocus()
        self.RecommendView:SetRecommendFocus()
    end
    ModModel:SetRecommendView(true)
    self:PlayAnimation(self.Recommend_In)
end

function M:OnRecommendFliterChange()
    self:ShowRecommendEntry(true)

    self:SetUpModList(true)
end

function M:ShowRecommendEntry(IsShow)
    if not IsShow then
        self.Btn_Delete:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Btn_Recommend:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        return
    end

    if ModModel:IsRecommendModState() then
        self.Btn_Delete:SetVisibility(UIConst.VisibilityOp["Visible"])
        self.Btn_Delete:SetGamePadIconVisible(true)
        self.Btn_Recommend:SetGamePadIconVisible(false)
        self.Btn_Recommend:SetVisibility(UIConst.VisibilityOp["Visible"])
        self:ClearAllFliter()
    else
        self.Btn_Delete:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Btn_Delete:SetGamePadIconVisible(false)
        self.Btn_Recommend:SetGamePadIconVisible(true)
        self.Btn_Recommend:SetVisibility(UIConst.VisibilityOp["Visible"])
    end
end

function M:ClearAllFliter()
    self.Com_Search:ClearText()
    self.Sift:ClearSiftSelection()

    local Content = self.Common_PolarityList_PC.List:GetItemAt(0)
    Content.Entry:OnBtnClick(true)
    self.CheckBox_Mod:SetIsChecked(false, false)
end

function M:OnRecommendViewHide()
    if ModController:IsGamepad() then
        self.List_Role:SetFocus()
    end

    self:SetRecommendBtnState()
    self:PlayAnimation(self.Recommend_Out)
end

function M:SetRecommendBtnState()
    self:AddTimer(0.01, function()       
        if not self.Btn_Delete:HasAnyUserFocus() and not self.Btn_Recommend:HasAnyUserFocus() then
            if ModModel:IsRecommendModState() then
                self.Btn_Delete:SetGamePadIconVisible(true)
                self.Btn_Recommend:SetGamePadIconVisible(false)
            else
                self.Btn_Delete:SetGamePadIconVisible(false)
                self.Btn_Recommend:SetGamePadIconVisible(true)
            end
        end
    end, false, 0, "SetRecommendBtnState")
end
-- endregion

AssembleComponents(M)
return M
