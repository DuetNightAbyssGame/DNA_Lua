--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
local FSM = require("Blueprints.UI.FocusStateMachine")

---@type WBP_Armory_BattleMenu_Config_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

--function M:Initialize(Initializer)
--end

local FocusStates = {WeaponList = "WeaponList", PhamtomList = "PhamtomList",SortWidget = "SortWidget",SiftWidget = "SiftWidget"}

function M:Construct()
    M.Super.Construct(self)
    self:InitKeySetting()
    self:AddDispatcher(EventID.OnEquipAssisterWeapon, self, self.OnAssisterWeaponEquiped)
    self:AddDispatcher(EventID.OnTakeOffAssisterWeapon, self, self.OnTakeOffAssisterWeapon)
    self:AddDispatcher(EventID.OnJumpToPage, self, self.OnJumpToPage)
    self:AddDispatcher(EventID.OnJumpBackToPage, self, self.OnJumpBackToPage)
    self:AddDispatcher(EventID.OnResourcesChanged, self, self.OnResourcesChanged)
    self:AddDispatcher(EventID.OnNewWeaponObtained, self, self.OnNewWeaponObtained)
    self:AddDispatcher(EventID.OnWeaponDeleted, self, self.OnWeaponDeleted)
    self:AddDispatcher(EventID.OnWeaponLevelUp,self,self.OnWeaponUpgraded)
    self:AddDispatcher(EventID.OnWeaponBreakLevelUp,self,self.OnWeaponUpgraded)
    self:AddDispatcher(EventID.OnWeaponGradeLevelUp, self, self.OnWeaponGradeLevelUp)
    self.WB_Tag:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Text_Weapon:SetText(GText("UI_Weapons_Carried"))
    self.Empty.Text_Empty:SetText(GText("UI_Armory_Weapon_Empty"))
    --self:AddDispatcher(EventID.OnWeaponLevelUp,self,self.OnWeaponUpgraded)
    self.Btn_Close.OnClicked:Add(self,self.OnBackGroundBtnClicked)
    self.SelectedSiftItems = {}
    --属性列表排序类型
    self.AttrSortIndexes = {["Char"] = 1, ["Melee"] = 2, ["Ranged"] = 3, ["UWeapon"] = 4}
    --排序依据
    self.Arr_OrderBy = {"UI_LEVEL_SELECT"}
    self.OrderByAttrNames = {"Level","SortPriority","Id"}
    --武器tag、显示名称
    self.MeleeFilterTags,self.MeleeFilterTagNames,self.RangedFilterTags,self.RangedFilterTagNames = UIUtils.GetAllWeaponTags()
    local WeaponTabs = DataMgr.SigilWeaponTab
    self.Tab_Switch:Init({
        LeftKey = self.TabLeftKey,
        RightKey = self.TabRightKey,
        ChildWidgetName = "TabSubIconTextItemHorizon",
        Tabs = {
            {Text = GText("UI_Armory_Meleeweapon"),Idx = 1,
            IconPath = WeaponTabs[1].IconPath},
            {Text = GText("UI_Armory_Longrange"),Idx = 2,
            IconPath = WeaponTabs[2].IconPath},
        },
        SoundFunc = function()
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_02", nil, nil)
        end,
        SoundFuncReceiver = self,
    })
    self.Tab_Switch:BindEventOnTabSelected(nil,nil)
    self.Tab_Switch:BindEventOnTabSelected(self,self.OnWeaponTabSelected)
    --初始化筛选器
    self.SiftTag2Id = {["Melee"] = 1003,["Ranged"] = 1004,}
    self.Com_Sort:Init(self,self.Arr_OrderBy,CommonConst.DESC,{
            OnAddedToFocusPath = self.OnSortWidgetAddedToFocusPath,
            OnRemovedFromFocusPath = self.OnSortWidgetRemovedFromFocusPath,
            OnGetBackFocusWidget = self.OnSortWidgetGetBackFocusWidget,})
    self.Com_Sort:BindEventOnSelectionsChanged(self,self.OnSortListSelectionsChanged)
    self.Com_Sort:BindEventOnSortTypeChanged(self,self.OnSortTypeChanged)

    self.List_Weapon.BP_OnItemClicked:Clear()
    self.List_Weapon.BP_OnItemClicked:Add(self,self.OnWeaponListClicked)
    self.List_PhantomTab.BP_OnItemClicked:Clear()
    self.List_PhantomTab.BP_OnItemClicked:Add(self,self.OnPhantomListClicked)

    self.List_Weapon.BP_OnItemSelectionChanged:Clear()
    self.List_Weapon.BP_OnItemSelectionChanged:Add(self,self.OnWeaponListSelectionChanged)
    self.List_PhantomTab.BP_OnItemSelectionChanged:Clear()
    self.List_PhantomTab.BP_OnItemSelectionChanged:Add(self,self.OnPhantomListSelectionChanged)

    self.List_Weapon.BP_OnEntryInitialized:Clear()
    self.List_Weapon.BP_OnEntryInitialized:Add(self,self.OnWeaponListEntryInitialized)

    self.Btn_Check:BindEventOnClicked(self,self.OnGoToCharBtnClicked)
    self.Text_Weapon_Recommend:SetText(GText("UI_Recommend_Weapon"))
    self.CheckBox_Recommend:BindEventOnClicked({Inst = self,Func = self.OnCheckBoxStateChanged})
    self.CheckBox_Recommend:SetKey("Img", "RS", function() end)
    self.Key_Check_GamePad:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "Menu",
            },
        },
        Desc = GText("UI_CTL_Details")
    })
    self.Com_Sift.Img_Key_L:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Com_Sift:BindEventOnAddedToFocusPath(self,self.OnSiftWidgetAddedToFocusPath)
    self.Com_Sift:BindEventOnRemovedFromFocusPath(self,self.OnSiftWidgetRemovedFromFocusPath)
    self.Com_Sift:SetSiftPreviewSideWidget(true,true)
    self.Btn_Equip:BindEventOnClicked(self,self.OnBtnEquipClicked)
    self.Btn_Equip:TryOverrideSoundFunc(function()
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
    end)
    self.Btn_GoToUpgrade:BindEventOnClicked(self,self.OnBtnGoToUpgradeClicked)
    self.Btn_GoToUpgrade:SetText(GText("BattleWheel_JumptoArmory"))
    self.Btn_GoToUpgrade:SetGamePadImg("Y")
    self.List_Weapon.OnCreateEmptyContent:Bind(self, function(self)
        return NewObject(UIUtils.GetCommonItemContentClass())
    end)
    self.FSM = FSM:New(self,{StateNames = FocusStates,
    OnStateChanged = self.OnFocusChanged,
    CheckFunction = self.IsFocusStateValid})
    self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType())
end

function M:InitKeySetting()
    self.Escape = "Escape"
    self.TabLeftKey = "A"
    self.TabRightKey = "D"
    self.KeyDownEvent = {}
    self.KeyDownEvent[self.TabLeftKey] = self.OnTabLeftKeyDown
    self.KeyDownEvent[self.TabRightKey] = self.OnTabRightKeyDown
    self.KeyDownEvent[UIConst.GamePadKey.LeftTriggerThreshold] = self.OnTabLeftKeyDown
    self.KeyDownEvent[UIConst.GamePadKey.RightTriggerThreshold] = self.OnTabRightKeyDown
    self.KeyDownEvent[UIConst.GamePadKey.LeftThumb] = self.OnLeftThumbKeyDown
    self.KeyDownEvent[UIConst.GamePadKey.RightThumb] = self.OnRightThumbKeyDown
    
    self.KeyDownEvent[UIConst.GamePadKey.SpecialRight] = self.OnSpecialRightKeyDown

    self.KeyDownEvent[UIConst.GamePadKey.FaceButtonTop] = self.OnFaceButtonTopKeyDown
    self.KeyDownEvent[UIConst.GamePadKey.FaceButtonLeft] = self.OnFaceButtonLeftKeyDown

    self.KeyDownEvent[UIConst.GamePadKey.FaceButtonRight] = self.OnBackKeyDown
    self.KeyDownEvent[self.Escape] = self.OnBackKeyDown
end

function M:OnTabLeftKeyDown()
    self.Tab_Switch:TabToLeft()
    if(self.FSM:Peak().Name == FocusStates.WeaponList)then
        if(#self.FilteredItems <= 0)then
            return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self.List_PhantomTab),true
        else
            return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self:NavigateToWeaponList()),true
        end
    end
end

function M:OnTabRightKeyDown()
    self.Tab_Switch:TabToRight()
    if(self.FSM:Peak().Name == FocusStates.WeaponList)then
        if(#self.FilteredItems <= 0)then
            return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self.List_PhantomTab),true
        else
            return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self:NavigateToWeaponList()),true
        end
    end
end

function M:OnLeftThumbKeyDown()
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self.Com_Sort),true
end

function M:OnRightThumbKeyDown()
    self.CheckBox_Recommend:OnClicked()
    local StateName = self.FSM:Peak().Name
    if(StateName == FocusStates.WeaponList)then
        if(self.ComWeaponContent and self.List_Weapon:GetIndexForItem(self.ComWeaponContent) >= 0 )then
            -- local Content = self.List_Weapon:GetItemAt(0)
            -- if(Content.WeaponUuid)then
            --     self.ComWeaponContent = Content
            -- end
            return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self:NavigateToWeaponList()),true
        else
            return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self:NavigateToPhantomList()),true
        end
    end
end

function M:OnFaceButtonTopKeyDown()
    self:OnGoToWeaponBtnClicked()
end

function M:OnBtnGoToUpgradeClicked()
    self:OnGoToWeaponBtnClicked()
end

function M:OnSpecialRightKeyDown()
    self:OnGoToCharBtnClicked()
end

function M:OnFaceButtonLeftKeyDown()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InputEvent = UWidgetBlueprintLibrary.GetInputEventFromKeyEvent(InKeyEvent)
    if(UKismetInputLibrary.InputEvent_IsRepeat(InputEvent))then
        return UIUtils.Handled
    end
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if(self.KeyDownEvent[InKeyName])then
        local Reply,IsHandled = self.KeyDownEvent[InKeyName](self)
        if(IsHandled)then
            return Reply
        end
    end
    return UIUtils.Handled
end

function M:OnBackKeyDown()
    if(self.IsGamepadInput and self.FSM:Peak().Name == FocusStates.SortWidget)then
        self.FSM:Pop()
        return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self:GetDesiredFocusTarget()),true
    else
        self:Close()
    end
end

function M:InitUIInfo(Name, IsInUIMode, EventList, Params)
    M.Super.InitUIInfo(self, Name, IsInUIMode, EventList, Params)
    self.Parent = Params.Parent
    self.InitPhantomRId = Params.PhantomRId
    self.OnClosedCbFunc = Params.OnClosedCbFunc
    self.OnClosedCbObj = Params.OnClosedCbObj

    self:SetVisibility(UIConst.VisibilityOp["Visible"])
    self:BlockAllUIInput(true,"SP_DisplayOnly")
    self:InitPhantomContents()
    self:SortPhantomContents()
    self.CurPhantomContent = self.PhantomContentArray[1]
    self:InitWeaponContents()
    self:InitPhantomList()
    self:OnPhantomSelected(self.CurPhantomContent,true)
    self:InitNavigationRules()
    AudioManager(self):PlayUISound(self, "event:/ui/common/preset_team_panel_expand", "Open", nil)
end

function M:OnLoaded(...)
    M.Super.OnLoaded(self, ...)
    self:BlockAllUIInput(false)
    self:SetFocus()
end

local AddWeaponContent = function(self,Weapon)
    local Avatar = ArmoryUtils:GetAvatar()
    if(not Weapon:HasTag("Ultra"))then
        local Tag = (Weapon:HasTag("Melee") and "Melee") or "Ranged"
        local Content = ArmoryUtils:NewCommonItemContent(Weapon, "Weapon")
        if(Weapon.Uuid == Avatar.MeleeWeapon or Weapon.Uuid == Avatar.RangedWeapon)then
            Content.IsMainCharEquipped = true
            pcall(function ()
                local Data = DataMgr.Char[Avatar.Chars[Avatar.CurrentChar].CharId]
                Content.TipsText = string.format(GText("UI_BattleWheel_CharHasEquiped"),GText(Data.CharName))
            end)
        end
        Content.bHideGamePad = true
        Content.Level = Weapon.Level
        Content.Tag = Tag
        Content.AssisterId = Weapon.AssisterId
        if(self.CurPhantomContent)then
            Content.bSelectTag = Weapon.AssisterId == self.CurPhantomContent.UnitId
        end
        Content.IsNew = false
        Content.bNotFocus = true
        Content.OnAddedToFocusPathEvent = {Obj = self,Callback = self.OnWeaponItemAddedToFocusPath,Params = Content}
        Content.OnRemovedFromFocusPathEvent = {Obj = self,Callback = self.OnWeaponItemRemovedFromFocusPath,Params = Content}
        self[Tag.."_BP_ListItemContents"]:Add(Content)
        self[Tag.."ContentMap"][Weapon.Uuid] = Content
        self.WeaponContentMap[Weapon.Uuid] = Content
        table.insert(self[Tag.."ContentArray"],Content)
        return Content
    end
end

local RemoveWeaponContent = function(self,WeaponUuid)
    local IsMelee = false
    if(self.MeleeContentMap[WeaponUuid])then
        IsMelee = true
    end
    self.MeleeContentMap[WeaponUuid] = nil
    self.RangedContentMap[WeaponUuid] = nil
    self.WeaponContentMap[WeaponUuid] = nil
    if(IsMelee)then
        for index, value in ipairs(self.MeleeContentArray) do
            if(value.Uuid == WeaponUuid)then
                table.remove(self.MeleeContentArray,index)
                self.Melee_BP_ListItemContents:RemoveItem(value)
                break
            end
        end
    else
        for index, value in ipairs(self.RangedContentArray) do
            if(value.Uuid == WeaponUuid)then
                table.remove(self.RangedContentArray,index)
                self.Ranged_BP_ListItemContents:RemoveItem(value)
                break
            end
        end
    end
end
---初始化所有Content并保存为蓝图对象
function M:InitWeaponContents()
    local Avatar = GWorld:GetAvatar()
    self.WeaponTags = {"Melee","Ranged"}
    for index, Tag in ipairs(self.WeaponTags) do
        self[Tag.."ContentMap"] = {}
        self[Tag.."ContentArray"] = {}
        self.WeaponContentMap = {}
        self[Tag.."_BP_ListItemContents"]:Clear()
    end
    for _,Weapon in pairs(Avatar.Weapons) do
        AddWeaponContent(self,Weapon)
    end
end

--#region 武器相关

function M:OnWeaponTabSelected(Tab)
    if(Tab.Idx == 1)then
        self:OnMeleeWeaponTabClicked()
    else
        self:OnRangedWeaponTabClicked()
    end
end

---近战Tab点击时
function M:OnMeleeWeaponTabClicked()
    self:SwitchListContentsTag(self.WeaponTags[1])
end

---远程Tab点击时
function M:OnRangedWeaponTabClicked()
    self:SwitchListContentsTag(self.WeaponTags[2])
end

function M:SwitchListContentsTag(Tag)
    self.CurWeaponTag = Tag
    self.Com_Sift:Close()
    self.SelectedSiftItems = {}
    self.SiftItemDatas = {}
    self.Com_Sift:SetSiftModelId(self.SiftTag2Id[Tag])
    self.Com_Sift:BindEventOnSelectionsChanged(self, self.OnFilterSelectionsChanged)
    local ComWeaponContentBefore = self.ComWeaponContent
    if(self.ComWeaponContent)then
        local Content = self[self.CurWeaponTag.."ContentMap"][self.ComWeaponContent.Uuid]
        if(not Content)then
            ArmoryUtils:SetItemIsSelected(self.ComWeaponContent,false)
        end
        self.ComWeaponContent = Content
    end
    if(ComWeaponContentBefore and self.ComWeaponContent and self.ComWeaponContent.Uuid == ComWeaponContentBefore.Uuid)then
        self:ShowWeaponTips(true)
    else
        self:ShowWeaponTips(false)
    end
    self:UpdateWeaponTips(self.ComWeaponContent)
    self:UpdateEquipBtn(self.ComWeaponContent)
    self:OnFilterSelectionsChanged(self.SelectedSiftItems,self.SiftItemDatas)
end

function M:InitWeaponTabs(PhantomContent)
    self.CurWeaponContent = nil
    if(not PhantomContent)then
        return
    end
    local WeaponUuid = ArmoryUtils:GetPhantomWeaponUuid(PhantomContent.UnitId)
    local Avatar = ArmoryUtils:GetAvatar()
    local Weapon  = WeaponUuid and Avatar.Weapons[WeaponUuid]
    local WeaponTagBefore = self.CurWeaponTag
    if(Weapon)then
        self.CurWeaponTag = (Weapon:IsMelee() and "Melee") or "Ranged"
        self.CurWeaponContent = self[self.CurWeaponTag.."ContentMap"][WeaponUuid]
        ArmoryUtils:SetItemSelectTag(self.CurWeaponContent,true)
    else
        self.CurWeaponTag = self.CurWeaponTag or "Melee"
    end
    if(WeaponTagBefore and self.CurWeaponTag == WeaponTagBefore)then
        if(self.CurWeaponTag == "Melee")then
            self:OnMeleeWeaponTabClicked()
        else
            self:OnRangedWeaponTabClicked()
        end
    else
        if(self.CurWeaponTag == "Melee")then
            self.Tab_Switch:SelectTab(1)
        else
            self.Tab_Switch:SelectTab(2)
        end
    end
end

function M:OnWeaponListClicked(Content)
    if(self.IsGamepadInput)then
        self:OnWeaponListGamepadClicked(Content)
    else
        self:OnWeaponSelected(Content)
    end
end

---武器列表项选中时
function M:OnWeaponSelected(Content)
    if(not Content or not Content.Uuid or self.ComWeaponContent == Content)then
        return
    end
    ArmoryUtils:SetItemIsSelected(self.ComWeaponContent,false)
    self.ComWeaponContent = Content
    ArmoryUtils:SetItemIsSelected(self.ComWeaponContent,true)
    local Avatar = GWorld:GetAvatar()
    self.ComparedTarget = Avatar.Weapons[self.ComWeaponContent.Uuid]

    self:UpdateWeaponTips(self.ComWeaponContent)
    self:UpdateEquipBtn(self.ComWeaponContent)
    self:ShowWeaponTips(true)
end

function M:UpdateWeaponTips(Content)
    if(Content)then
        self.Tips_Weapon:RefreshItemInfo(Content,true)
        self.Tips_Weapon:SetConflictLine(Content.IsMainCharEquipped, Content.TipsText, 1)
        --if(Content.IsMainCharEquipped)then
        --     self.Tips_Weapon:InitButtonEvent()
        -- else
        --     self.Tips_Weapon:InitButtonEvent({
        --         ButtonClickCallBack = function()
        --             self:OnGoToWeaponBtnClicked()
        --         end,
        --         ButtonClickText = "BattleWheel_JumptoArmory"
        --     })
        -- end
    end
end

function M:UpdateEquipBtn(Content)
    if(Content)then
        if(Content.IsMainCharEquipped)then
            self.Btn_Equip:SetText(GText("UI_Armory_Weapon_Equipe"))
            self.Btn_Equip:ForbidBtn(true)
            self.Btn_GoToUpgrade:ForbidBtn(true)
        elseif(Content == self.CurWeaponContent)then
            self.Btn_Equip:SetText(GText("UI_Armory_Weapon_Remove"))
            self.Btn_Equip:ForbidBtn(false)
            self.Btn_GoToUpgrade:ForbidBtn(false)
        else
            self.Btn_Equip:SetText(GText("UI_Armory_Weapon_Equipe"))
            self.Btn_Equip:ForbidBtn(false)
            self.Btn_GoToUpgrade:ForbidBtn(false)
        end
    else
        self.Btn_Equip:SetText(GText("UI_Armory_Unselected_Weapon"))
        self.Btn_Equip:ForbidBtn(true)
        self.Btn_GoToUpgrade:ForbidBtn(true)
    end
end

--安装、卸载按钮点击时
function M:OnBtnEquipClicked()
    local Avatar = GWorld:GetAvatar()
    if(self.ComWeaponContent)then
        if(self.ComWeaponContent == self.CurWeaponContent)then
            --卸载
            self:BlockAllUIInput(true)
            Avatar:TakeOffAssisterWeapon(self.CurPhantomContent.UnitId,self.ComWeaponContent.Uuid)
        else
            --安装
            local Weapon = Avatar.Weapons[self.ComWeaponContent.Uuid]
            if(Weapon.AssisterId and Weapon.AssisterId ~= 0)then
                local Params = {
                    ShortText = string.format(  GText(DataMgr.CommonPopupUIContext[100044].PopoverText),
                                                GText(Weapon.WeaponName),
                                                GText(Avatar.Resources[Weapon.AssisterId].ResourceName)),
                    RightCallbackObj = self,
                    RightCallbackFunction = self.OnPopupConfirm,
                }
                UIManager(self):ShowCommonPopupUI(100044,Params,self)
            else
                self:BlockAllUIInput(true)
                Avatar:EquipAssisterWeapon(self.CurPhantomContent.UnitId, self.ComWeaponContent.Uuid)
            end
        end
    end
end

function M:OnPopupConfirm()
    self:BlockAllUIInput(true)
    local Avatar = GWorld:GetAvatar()
    Avatar:EquipAssisterWeapon(self.CurPhantomContent.UnitId, self.ComWeaponContent.Uuid)
end

---服务器协战印记装备武器
function M:OnAssisterWeaponEquiped(Ret,AssisterId, WeaponUuid)
    self:BlockAllUIInput(false)
    if(not ErrorCode:Check(Ret))then
        return
    end
    ArmoryUtils:SetItemSelectTag(self.CurWeaponContent,false)
    self.CurWeaponContent = self.WeaponContentMap[WeaponUuid]
    ArmoryUtils:SetItemSelectTag(self.CurWeaponContent,true)
    --self:UpdateWeaponTips(self.ComWeaponContent)
    self:UpdateEquipBtn(self.ComWeaponContent)
    self:UpdateAllPhantomAndWeaponIcon()
    self:UpdatePhantomWeaponCount(self.CurPhantomContent)
    AudioManager(self):PlayUISound(self, "event:/ui/common/weapon_replace", nil, nil)
end

---服务器卸下武器
function M:OnTakeOffAssisterWeapon(Ret,AssisterId, WeaponUuid)
    self:BlockAllUIInput(false)
    if(not ErrorCode:Check(Ret))then
        return
    end
    ArmoryUtils:SetItemSelectTag(self.CurWeaponContent,false)
    self.CurWeaponContent = nil
    self:UpdateEquipBtn(self.ComWeaponContent)
    self:UpdateAllPhantomAndWeaponIcon()
    if self.ComWeaponContent.SelfWidget then
        self.ComWeaponContent.SelfWidget:Init(self.ComWeaponContent)
    end
    self:UpdatePhantomWeaponCount(self.CurPhantomContent)
end

function M:ShowWeaponTips(IsShow)
    if(IsShow == self.IsWeaponTipsShowed)then
        return
    end
    self.IsWeaponTipsShowed = IsShow
    if(IsShow)then
        self.Tips_Weapon:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Tips_Weapon:PlayInAnim()
    else
        ArmoryUtils:SetItemIsSelected(self.ComWeaponContent,false)
        self.ComWeaponContent = nil
        self.Tips_Weapon:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Tips_Weapon:PlayOutAnim()
    end
end

--#endregion 武器相关

--#region 协战印记相关

local AddPhantomContent = function(self,Resource,CharId2Char)
    local Content = self:NewResourceItemContent(Resource)
    if(Content)then
        if(not CharId2Char)then
            CharId2Char = {}
            local Avatar  = ArmoryUtils:GetAvatar()
            for key, value in pairs(Avatar.Chars) do
                CharId2Char[value.CharId] = value
            end
        end
        if(not CharId2Char[Content.CharId])then
            return
        end
        Content.WeaponUuid = Resource.WeaponUuid
        Content.Char = CharId2Char[Content.CharId]
        Content.Level = Content.Char and Content.Char.Level
        table.insert(self.PhantomContentArray,Content)
        self.PhantomContentMap[Content.UnitId] = Content
        self.Resource_BP_ListItemContents:Add(Content)
        if(self.InitPhantomRId == Content.UnitId)then
            self.CurPhantomContent = Content
        end
        return Content
    end
end

function M:InitPhantomContents()
    self.PhantomContentMap = {}
    self.PhantomContentArray = {}
    self.Resource_BP_ListItemContents:Clear()
    self.CurPhantomContent = nil

    local Avatar  = ArmoryUtils:GetAvatar()

    local CharId2Char = {}
    for key, value in pairs(Avatar.Chars) do
        CharId2Char[value.CharId] = value
    end

    for Rid, Resource in pairs(Avatar.Resources) do
        AddPhantomContent(self,Resource,CharId2Char)
    end
end

---更新协战印记等级
function M:UpdatePhantomsLevel()
    for index, value in ipairs(self.PhantomContentArray) do
        if(value.Widget)then
            value.Widget:SetLevel(value.Char and value.Char.Level)
        end
    end
end

function M:SortPhantomContents()
    ArmoryUtils:SortItemContents(self.PhantomContentArray,{"Rarity","UnitId"},CommonConst.DESC,self.CurPhantomContent)
end

function M:InitPhantomList()
    self.List_PhantomTab:ClearListItems()
    for index, value in ipairs(self.PhantomContentArray) do
        self.List_PhantomTab:AddItem(value)
    end
end

function M:NewResourceItemContent(ServerData)
    local Data = ServerData:Data()
    if(not Data or ServerData.ResourceSType ~= "PhantomItem")then
        return
    end
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.Owner = self
    Obj.Count = GText("INFINITY_SYMBOL") --用于列表的显示数量
    Obj.Type = CommonConst.DataType.Resource
    Obj.UnitId = ServerData.ResourceId
    Obj.ResourceSType = ServerData.ResourceSType
    Obj.IsEquiped = false
    Obj.Rarity = Data.Rarity or 0
    Obj.Icon = Data.Icon
    Obj.CharId = Data.UseParam
    Obj.OnAddedToFocusPath = self.OnPhantomItemAddedToFocusPath
    Obj.OnRemovedFromFocusPath = self.OnPhantomItemRemovedFromFocusPath
    return Obj
end

--更新协战印记信息
function M:UpdatePhantomInfo(Content)
    self.WB_Tag:SetVisibility(UIConst.VisibilityOp.Collapsed)
    Content = Content or self.CurPhantomContent
    local Avatar = ArmoryUtils:GetAvatar()
    local PhantomResource = Avatar.Resources[Content.UnitId]
    local ResourceData = PhantomResource and PhantomResource:Data()
    if(not ResourceData)then
        return
    end
    self:UpdatePhantomWeaponCount(Content)
    self.Text_PhantomName:SetText(GText(ResourceData.ResourceName))
    local BattleCharData = DataMgr.BattleChar[PhantomResource.UseParam]
    if(not BattleCharData)then
        return
    end
    local ElmtType = BattleCharData.Attribute or ""
    local IconName = "Armory_" .. ElmtType
    local AttributeIcon = LoadObject('/Game/UI/Texture/Dynamic/Atlas/Armory/T_' .. IconName .. ".T_" ..IconName)
    self.Icon_Attribute:SetBrushResourceObject(AttributeIcon)

    UIUtils.AddPositioningTagToPanel(self.WB_Tag,PhantomResource.UseParam)
end

function M:UpdatePhantomWeaponCount(Content)
    Content = Content or self.CurPhantomContent
    local Avatar = ArmoryUtils:GetAvatar()
    local PhantomResource = Avatar.Resources[Content.UnitId]
    local ResourceData = PhantomResource and PhantomResource:Data()
    if(not ResourceData)then
        return
    end
    if(PhantomResource.WeaponUuid and PhantomResource.WeaponUuid ~= "")then
        self.Text_Num:SetText("1")
    else
        self.Text_Num:SetText("0")
    end
end

function M:SetWeaponIsEquipped(PhantomContent,IsEquipped)
    if(PhantomContent and self.CurWeaponTag)then
        local Avatar = ArmoryUtils:GetAvatar()
        local Resource = Avatar.Resources[PhantomContent.UnitId]
        if(Resource and Resource.WeaponUuid)then
            local WeaponContent = self[self.CurWeaponTag.."ContentMap"][Resource.WeaponUuid]
            ArmoryUtils:SetItemSelectTag(WeaponContent,IsEquipped)
        end
    end
end

function M:OnPhantomListClicked(Content)
    if(self.IsGamepadInput)then
        self:OnPhantomListGamepadClicked(Content)
    else
        self:OnPhantomSelected(Content)
    end
end

function M:OnPhantomSelected(Content,bForceUpdate)
    if(Content == self.CurPhantomContent and not bForceUpdate)then
        return
    end
    ArmoryUtils:SetItemIsSelected(self.CurPhantomContent,false)
    self:SetWeaponIsEquipped(self.CurPhantomContent,false)
    self.CurPhantomContent = Content
    ArmoryUtils:SetItemIsSelected(self.CurPhantomContent,true)
    self:SetWeaponIsEquipped(self.CurPhantomContent,true)
    self:UpdatePhantomInfo(self.CurPhantomContent)
    self:InitWeaponTabs(self.CurPhantomContent)
    self.List_Weapon:BP_ScrollItemIntoView(Content)
end

function M:UpdateAllPhantomAndWeaponIcon()
    local Avatar = GWorld:GetAvatar()
    for _, Content in pairs(self.PhantomContentArray) do
        if(Content.Widget)then
            Content.Widget:SetWeaponIcon(Content.UnitId)
        end
        local resource = Avatar.Resources[Content.UnitId]
        
        --- 刷新武器列表
        local WeaponUuidBefore = Content.WeaponUuid
        if(WeaponUuidBefore)then
            local WeaponContent = WeaponUuidBefore and self.WeaponContentMap[WeaponUuidBefore]
            if(WeaponContent and WeaponContent.SelfWidget)then
                WeaponContent.SelfWidget:Init(WeaponContent)
            end
        end
        local WeaponUuid = resource and resource.WeaponUuid
        Content.WeaponUuid = WeaponUuid
        local WeaponContent = WeaponUuid and self.WeaponContentMap[WeaponUuid]
        if(WeaponContent and WeaponContent.SelfWidget)then
            WeaponContent.SelfWidget:Init(WeaponContent)
        end
    end
    --隐藏魅影图标
    ArmoryUtils:SetItemSelectTag(self.CurWeaponContent,true)
end

--#endregion 协战印记相关

--#region 排序、筛选

---筛选器选项选中改变时
function M:OnFilterSelectionsChanged(SelectedItems, ItemDatas)
    self.SelectedSiftItems = SelectedItems or {}
    self.SiftItemDatas = ItemDatas or {}
    self.FilteredItems = {}
    self.FilteredItems = self:FilterWeaponContents(self[self.CurWeaponTag.."ContentArray"])
    if(self.bRecommendWeapon)then
        self.FilteredItems = self:FilterRecommendWeapon(self.FilteredItems)
    end
    self:SortWeaponContents(self.FilteredItems)
    self:InitWeaponList()
end

---排序依据选项选中改变时
function M:OnSortListSelectionsChanged(SortBy, SortType)
    self:SortWeaponContents(self.FilteredItems)
    self:InitWeaponList()
end

---排序类型改变时（升序、降序）
function M:OnSortTypeChanged(SortType)
    self:SortWeaponContents(self.FilteredItems)
    self:InitWeaponList()
end

---筛选武器
function M:FilterWeaponContents(InContentArray)
    --过滤数据对象
    local Result = {}
    local Avatar = ArmoryUtils:GetAvatar()
    local Contants = InContentArray
    if(self.SelectedSiftItems[1])then
        for key, Content in pairs(Contants) do
            local Weapon = Avatar.Weapons[Content.Uuid]
            for _, TagIdx in pairs(self.SelectedSiftItems[1]) do
                if(Weapon:HasTag(self.SiftItemDatas[1].SelectionDatas[TagIdx]))then
                    table.insert(Result,Content)
                    break
                end
            end
        end
        Contants = Result
        --Result = {}
    end
    Result = Contants
    return Result
end

--排序武器
function M:SortWeaponContents(InOutArr)
    local SortBy, SortType = self.Com_Sort:GetSortInfos()
    local SortByAttrNames = {self.OrderByAttrNames[SortBy]}
    for index, value in ipairs(self.OrderByAttrNames) do
        if(index ~= SortBy)then
            table.insert(SortByAttrNames,value)
        end
    end
    ArmoryUtils:SortItemContents(InOutArr,SortByAttrNames,SortType,self.CurWeaponContent)
end

function M:InitWeaponList(bDontScroll)
    self.List_Weapon:ClearListItems()
    for _, value in ipairs(self.FilteredItems) do
        if(value == self.ComWeaponContent)then
            value.IsSelect = true
        end
        self.List_Weapon:AddItem(value)
    end
    if(not bDontScroll)then
        self.List_Weapon:ScrollToTop()
    end
    if(#self.FilteredItems > 0)then
        self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
        self.List_Weapon:RequestFillEmptyContent()
    else
        self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
    end
    -- if(#self.FilteredItems <= 0)then
    --     self:FillEmptyItems(1)
    -- end
    -- self:AddTimer(0.01, function()
    --     local ItemUIs = self.List_Weapon:GetDisplayedEntryWidgets()
    --     local RestCount = UIUtils.GetTileViewContentMaxCount(self.List_Weapon)-ItemUIs:Length()
    --     --self:FillEmptyItems(RestCount)
    --     -- --刷新列表显示项，防止错位
    --     -- self.List_Weapon:RegenerateAllEntries()
    --     self.List_Weapon:ScrollToTop()
    -- end,false, 0, "DelayAddEmptyItem")
end

function M:FillEmptyItems(Count)
    for i = 1, Count do
        self.List_Weapon:AddItem(NewObject(UIUtils.GetCommonItemContentClass()))
    end
end

--推荐武器勾选改变时
function M:OnCheckBoxStateChanged(IsChecked)
    self.bRecommendWeapon = IsChecked
    if(IsChecked)then
        self.FilteredItems = self:FilterRecommendWeapon(self.FilteredItems)
    else
        self.FilteredItems = self:FilterWeaponContents(self[self.CurWeaponTag.."ContentArray"])
        self:SortWeaponContents(self.FilteredItems)
    end
    self:InitWeaponList()
end

--筛选推荐武器
function M:FilterRecommendWeapon(InContentArray)
    local Result = {}
    local Data = DataMgr.Resource[self.CurPhantomContent.UnitId]
    if(not Data)then
        return Result
    end
    local ExcelWeaponTags = UIUtils.GetExcelWeaponTags(Data.UseParam)
    local Avatar = ArmoryUtils:GetAvatar()
    for _, Content in ipairs(InContentArray) do
        local Weapon = Avatar.Weapons[Content.Uuid]
        for _, Tag in pairs(ExcelWeaponTags) do
            if(Weapon:HasTag(Tag))then
                table.insert(Result,Content)
                break
            end
        end
    end
    return Result
end

function M:OnResourcesChanged(ResourceId)
    local Avatar = ArmoryUtils:GetAvatar()
    local Resource = Avatar.Resources[ResourceId]
    if(not Resource)then
        return
    end
    if(not self.PhantomContentMap[ResourceId])then
        local Content = AddPhantomContent(self,Resource)
        if(Content)then
            self:SortPhantomContents()
            self:InitPhantomList()
            self.List_PhantomTab:RegenerateAllEntries()
        end
    end
end

function M:OnNewWeaponObtained(WeaponUuid)
    local Avatar = ArmoryUtils:GetAvatar()
    local Weapon = Avatar.Weapons[WeaponUuid]
    if(not Weapon)then
        return
    end
    local Content = AddWeaponContent(self,Weapon)
    if(Content)then
        self:OnFilterSelectionsChanged(self.SelectedSiftItems,self.SiftItemDatas)
    end
end

function M:OnWeaponDeleted(WeaponUuid)
    if(not self.WeaponContentMap[WeaponUuid])then
        return
    end
    RemoveWeaponContent(self,WeaponUuid)
    self:OnFilterSelectionsChanged(self.SelectedSiftItems,self.SiftItemDatas)
    self:UpdateAllPhantomAndWeaponIcon()
    self:UpdatePhantomWeaponCount(self.CurPhantomContent)
end

function M:UpdateWeaponContentAfterPropChanged(WeaponUuid)
    if(not self.WeaponContentMap[WeaponUuid])then
        return
    end
    local Avatar = GWorld:GetAvatar()
    local Weapon = Avatar.Weapons[WeaponUuid]
    if(not Weapon)then
        return
    end
    local Content = self.WeaponContentMap[WeaponUuid]
    ArmoryUtils:SetItemLevel(Content,Weapon.Level)
    self:UpdateWeaponTips(self.ComWeaponContent)
end

function M:OnWeaponUpgraded(Ret,WeaponUuid)
    self:UpdateWeaponContentAfterPropChanged(WeaponUuid)
end

function M:OnWeaponGradeLevelUp(Ret,WeaponUuid,CurrentGradeLevel,ConsumeWeaponUuids)
    self:UpdateWeaponContentAfterPropChanged(WeaponUuid)
end

--#endregion 排序、筛选

function M:OnBackGroundBtnClicked()
    if(self.IsWeaponTipsShowed)then
        self:ShowWeaponTips(false)
        self:UpdateEquipBtn(self.ComWeaponContent)
    else
        self:Close()
    end
end

function M:Close()
    self.Super.Close(self)
    AudioManager(self):SetEventSoundParam(self, "Open", { ToEnd = 1 })
    if(self.OnClosedCbFunc)then
        self.OnClosedCbFunc(self.OnClosedCbObj)
    end
end

function M:OnJumpToPage(FromPage, ToPage)
    if(ToPage and self:IsVisible())then
        self.FromPage = FromPage
        self.JumpToPage = ToPage
        self:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

function M:OnJumpBackToPage(FromPage, ToPage)
    if(self.JumpToPage and self.JumpToPage == FromPage and self.FromPage == ToPage)then
        self:SetVisibility(UIConst.VisibilityOp["Visible"])
        self.JumpToPage = nil
        self.FromPage = nil
    end
end

function M:OnGoToCharBtnClicked()
    if(not self.CurPhantomContent)then
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    if(not self.CurPhantomContent.Char)then
        return
    end
    self:GoToArmory({
        Title = GText("UI_Char_Enhancement"),
        CharUuids = {self.CurPhantomContent.Char.Uuid},
        MainTabName = ArmoryUtils.ArmoryMainTabNames.Char,
        bHideMeleeTab = true,
        bHideRangedTab = true,
        bHideWeaponTab = true,
    })
end

function M:OnGoToWeaponBtnClicked()
    if(not self.ComWeaponContent)then
        return
    end

    local Params = {
        Title = GText("UI_Weapon_Enhancement"),
        CharUuids = {self.CurPhantomContent.Char.Uuid},
        WeaponUuids = {self.ComWeaponContent.Uuid},
        bHideCharTab = true,
        bHideUltraTab = true,
    }
    if(self.ComWeaponContent.Tag == ArmoryUtils.ArmoryMainTabNames.Melee)then
        Params.MainTabName = ArmoryUtils.ArmoryMainTabNames.Melee
        Params.bHideRangedTab = true
        Params.bHideWeaponTab = true
    else
        Params.MainTabName = ArmoryUtils.ArmoryMainTabNames.Ranged
        Params.bHideMeleeTab = true
        Params.bHideWeaponTab = true
    end
    self:GoToArmory(Params)
end

function M:GoToArmory(Params)
    if(self.Parent and self.Parent.ActorController)then
        self.LastActorModelInfo = self.Parent.ActorController.CurrentCharInfo
    end
    Params.bNoEndCamera = true
    Params.bHideSquadBuildBtn = true
    Params.bHideBoxBtn = true
    Params.bHideDeployBtn = true
    Params.bHidePetTab = true
    Params.bHideBattleWheel = true
    Params.OnCloseDelegate = {self,self.OnArmoryDetailClosed}
    local ArmoryDetail = UIManager(self):LoadUINew("ArmoryDetail",Params)
    if(IsValid(ArmoryDetail))then
        self:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:OnArmoryDetailClosed()
    self:SetFocus()
    if(self.Parent and self.Parent.ActorController)then
        self.Parent.ActorController:ChangeCharModel(self.LastActorModelInfo)
    end
end


--#region 手柄相关

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    self.IsGamepadInput = CurInputDevice == ECommonInputType.Gamepad
    if(self.IsGamepadInput and self.IsInFocusPath and not self:IsFocusStateWidgetHasAnyFocus(self.FSM:Peak()))then
        --保底措施，以防意外情况导致聚焦不在任何合法热区
        self:NavigateToPhantomList():SetFocus()
    end
    self:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    M.Super.OnUpdateUIStyleByInputTypeChange(self,CurInputDevice, CurGamepadName)
    if(self.IsInFocusPath)then
        self:OnFocusChanged()
    end
end

function M:OnFocusChanged()
    if(self.IsGamepadInput)then
        self.CheckBox_Recommend.Com_KeyImg:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.WidgetSwitcher_MP:SetActiveWidgetIndex(1)
    else
        self.CheckBox_Recommend.Com_KeyImg:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.WidgetSwitcher_MP:SetActiveWidgetIndex(0)
    end
end

function M:IsFocusStateValid(State)
    local StateName = State.Name
    if(StateName == FocusStates.WeaponList)then
        return State.Content and self.List_Weapon:GetIndexForItem(State.Content) >= 0
    elseif(StateName == FocusStates.PhamtomList)then
        return State.Content and self.List_PhantomTab:GetIndexForItem(State.Content) >= 0
    end
    return true
end

function M:NavigateToPhantomList()
    if(self.CurPhantomContent)then
        self.List_PhantomTab:BP_CancelScrollIntoView()
        self.List_PhantomTab:BP_SetSelectedItem(self.CurPhantomContent)
        self.List_PhantomTab:BP_NavigateToItem(self.CurPhantomContent)
    end
    return self.List_PhantomTab
end

function M:NavigateToWeaponList()
    local Content = self.ComWeaponContent or self.List_Weapon:GetItemAt(0)
    if(Content)then
        self.List_Weapon:BP_CancelScrollIntoView()
        self.List_Weapon:BP_SetSelectedItem(Content)
        self.List_Weapon:BP_NavigateToItem(Content)
        return self.List_Weapon
    end
    return self
end

function M:OnAddedToFocusPath()
    self.IsInFocusPath = true
    if(self._OnAddedToFocusPath)then
        self._OnAddedToFocusPath(self.Parent)
    end
end

function M:OnRemovedFromFocusPath()
    self.IsInFocusPath = false
    if(self._OnRemovedFromFocusPath)then
        self._OnRemovedFromFocusPath(self.Parent)
    end
end

function M:OnWeaponItemAddedToFocusPath(Content)
    if(self.FSM:Peak().Name == FocusStates.PhamtomList)then
        self.FSM:Pop()
    end
    self.FSM:Push({Name = FocusStates.WeaponList,Content = Content})
end

function M:OnWeaponItemRemovedFromFocusPath()
end

function M:OnPhantomItemAddedToFocusPath(Content)
    if(self.FSM:Peak().Name == FocusStates.WeaponList)then
        self.FSM:Pop()
    end
    self.FSM:Push({Name = FocusStates.PhamtomList,Content = Content})
end

function M:OnPhantomItemRemovedFromFocusPath(Content)
end

function M:OnSortWidgetAddedToFocusPath(Widget)
    self.FSM:Push({Name = FocusStates.SortWidget,Content = Widget})
end

function M:OnSortWidgetRemovedFromFocusPath()
end

function M:OnSiftWidgetAddedToFocusPath(Widget)
    self.FSM:Push({Name = FocusStates.SortWidget,Content = Widget})
end

function M:OnSiftWidgetRemovedFromFocusPath()
end

function M:OnSortWidgetGetBackFocusWidget()
    self.FSM:Pop()
    if(self.FSM:Peak().Name == FocusStates.WeaponList)then
        return self:NavigateToWeaponList()
    else
        return self:NavigateToPhantomList()
    end
end

function M:IsFocusStateWidgetHasAnyFocus(State)
    local StateName = State.Name
    if(StateName == FocusStates.WeaponList)then
        return UIUtils.HasAnyFocus(self.List_Weapon)
    elseif(StateName == FocusStates.PhamtomList)then
        return UIUtils.HasAnyFocus(self.List_PhantomTab)
    elseif(StateName == FocusStates.SortWidget)then
        return UIUtils.HasAnyFocus(self.Com_Sort) or UIUtils.HasAnyFocus(self.Com_Sift)
    end
end

function M:InitNavigationRules()
    self.List_Weapon:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self.List_Weapon:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    self.List_Weapon:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
    self.List_PhantomTab:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self.List_PhantomTab:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    self.List_PhantomTab:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)

    self.List_Weapon:SetNavigationRuleExplicit(EUINavigation.Right, self.List_PhantomTab)
    self.List_PhantomTab:SetNavigationRuleCustom(EUINavigation.Left, {self,function(_self)
        if(self.WidgetSwitcher_State:GetActiveWidgetIndex() == 0)then
            return self.List_Weapon
        else
            return self.List_PhantomTab
        end
    end})
    self.Com_Sort:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self.Com_Sort:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    self.Com_Sort:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
    self.Com_Sift:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self.Com_Sift:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    self.Com_Sift:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
    
    self.Com_Sort:SetNavigationRuleExplicit(EUINavigation.Right, self.Com_Sift)
    self.Com_Sift:SetNavigationRuleExplicit(EUINavigation.Left, self.Com_Sort)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    local Reply = M.Super.OnFocusReceived(self,MyGeometry, InFocusEvent)
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self:GetDesiredFocusTarget())
end

function M:GetDesiredFocusTarget()
    local State = self.FSM:Peak()
    local StateName = State.Name
    if(StateName == FocusStates.WeaponList)then
        return self:NavigateToWeaponList()
    elseif(StateName == FocusStates.PhamtomList)then
        return self:NavigateToPhantomList()
    elseif(StateName == FocusStates.SortWidget)then
        if(IsValid(State.Widget))then
            return State.Widget
        else
            return self.Com_Sort
        end
    else
        return self:NavigateToPhantomList()
    end
end

function M:OnWeaponListSelectionChanged(Content,IsSelected)
    if(not IsSelected or not self.IsGamepadInput)then
        return
    end
    self:OnWeaponSelected(Content)
end

local _NavigatePosOffsetPercent = FVector2D(0,0.5)
local _NavigatePosOffsetAlignment = FVector2D(0.8,0.5)
function M:OnWeaponListEntryInitialized(Content,Widget)
    if(Content.bSelectTag)then
        Widget:SetWeaponPhantomIcon(nil)
    else
        Widget:SetWeaponPhantomIcon(Content.Uuid)
    end
    Widget.ShowWarningText = GText("UI_BattleWheel_CharHasEquipedShort")
    Widget:SetItemConflict(Content.IsMainCharEquipped)
    
    local Index = self.List_Weapon:GetIndexForItem(Content)
    if(Index + 1 >= #self.FilteredItems)then
        Widget:SetNavigationRuleExplicit(EUINavigation.Right, self.List_PhantomTab)
    else
        local NextContent = self.List_Weapon:GetItemAt(Index + 1)
        if(NextContent and NextContent.Uuid)then
            Widget:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Escape)
        else
            Widget:SetNavigationRuleExplicit(EUINavigation.Right, self.List_PhantomTab)
        end
    end
    Widget:SetNavigatePosOffsetAlignment(_NavigatePosOffsetAlignment)
    Widget:SetNavigatePosOffsetPercent(_NavigatePosOffsetPercent)
    Widget:SetNavigatePosAngle(-90)
end

function M:OnPhantomListSelectionChanged(Content,IsSelected)
    if(not IsSelected or not self.IsGamepadInput)then
        return
    end
    self:OnPhantomSelected(Content)
end

function M:OnPhantomListGamepadClicked(Content)
    self:OnBtnEquipClicked()
end

function M:OnWeaponListGamepadClicked(Content)
    self:OnBtnEquipClicked()
end

--#endregion 手柄相关

return M
