--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
local UIUtils = require "Utils.UIUtils"

---左下展开按钮列表，用于角色、武器、宠物切换
---@type Armory_ExpandListComponent|WBP_Armory_Main_P_C|WBP_Armory_Main_M_C
local M = {}

function M:Construct()
    --元素类型、元素显示名称
    self.CharFilterTags,self.CharFilterNames = UIUtils.GetAllElementTypes()
    self.CharFilterIcons = {}
    for key, Tag in pairs(self.CharFilterTags) do
        local IconName = "Armory_" .. Tag
        table.insert(self.CharFilterIcons,"/Game/UI/Texture/Dynamic/Atlas/Armory/T_" .. IconName .. ".T_" .. IconName)
    end
    --武器tag、显示名称
    self.MeleeFilterTags,self.MeleeFilterNames,self.RangedFilterTags,self.RangedFilterNames = UIUtils.GetAllWeaponTags()
    self.MeleeFilterIcons = {}
    self.Melee2Icon={}
    for _, Tag in ipairs(self.MeleeFilterTags) do
        local Data = DataMgr.WeaponTag[Tag]
        table.insert(self.MeleeFilterIcons,Data and Data.Icon)
        self.Melee2Icon[Tag]=Data.Icon
    end
    self.RangedFilterIcons = {}

    self.Ranged2Icon={}
    for _, Tag in ipairs(self.RangedFilterTags) do
        local Data = DataMgr.WeaponTag[Tag]
        table.insert(self.RangedFilterIcons,Data and Data.Icon)
        self.Ranged2Icon[Tag]=Data.Icon
    end


    self.Btn_Selective:BindEventOnClicked(self,self.OnExpandListButtonClicked)

    self.IsListExpanded = false
end

function M:CreateWeaponFilterTags()
    if(not self.ComparedWeaponName or not self[self.ComparedWeaponName])then
        return
    end
    local _concat = function(FromTable,ToTable)
        table.move(FromTable,1,#FromTable,#ToTable + 1,ToTable)
    end
    self.WeaponFilterTags = {}
    self.WeaponFilterNames = {}
    self.WeaponFilterIcons = {}
    if(self.bFromArchive)then
        if(self[self.ComparedWeaponName]:HasTag(CommonConst.WeaponType.MeleeWeapon))then
            _concat(self.MeleeFilterTags,self.WeaponFilterTags)
            _concat(self.MeleeFilterNames,self.WeaponFilterNames)
            _concat(self.MeleeFilterIcons,self.WeaponFilterIcons)
        else
            _concat(self.RangedFilterTags,self.WeaponFilterTags)
            _concat(self.RangedFilterNames,self.WeaponFilterNames)
            _concat(self.RangedFilterIcons,self.WeaponFilterIcons)
        end
    else
        _concat(self.MeleeFilterTags,self.WeaponFilterTags)
        _concat(self.RangedFilterTags,self.WeaponFilterTags)
        _concat(self.MeleeFilterNames,self.WeaponFilterNames)
        _concat(self.RangedFilterNames,self.WeaponFilterNames)
        _concat(self.MeleeFilterIcons,self.WeaponFilterIcons)
        _concat(self.RangedFilterIcons,self.WeaponFilterIcons)
    end
end

function M:InitUIInfo()
    --排序依据
    if(self.bFromArchive)then
        self.Arr_OrderBy = {"UI_LEVEL_SELECT",}
        self.CommonOrderByAttrNames = {"SortPriority","UnitId"}
    else
        self.Arr_OrderBy = {"UI_LEVEL_SELECT",}
        self.CommonOrderByAttrNames = {"Level","SortPriority","UnitId"}
    end
    self.CharOrderByDisplayNames = self.Arr_OrderBy
    self.MeleeOrderByDisplayNames = self.Arr_OrderBy
    self.RangedOrderByDisplayNames = self.Arr_OrderBy
    self.WeaponOrderByDisplayNames = self.Arr_OrderBy
    self.PetOrderByDisplayNames = {"UI_LEVEL_SELECT","UI_RARITY_NAME"}
    self.ResourcePetOrderByDisplayNames = {"UI_RARITY_NAME","Pet_Affix_Type"}
    self.CharOrderByAttrNames = self.CommonOrderByAttrNames
    self.MeleeOrderByAttrNames = self.CommonOrderByAttrNames
    self.RangedOrderByAttrNames = self.CommonOrderByAttrNames
    self.WeaponOrderByAttrNames = self.CommonOrderByAttrNames
    self.PetOrderByAttrNames = {"BreakNum","Level","Rarity","SortPriority","UnitId"}
    self.ResourcePetOrderByAttrNames = {"_PetEntryRarity","_PetEntryId","SortPriority","UnitId"}
end

function M:CreateFilters(InTags,InTexts,InIcons,ExcelWeaponTags)
    local Filters = {}
    for i, value in ipairs(InTags) do
        table.insert(Filters,{
            Tag = value,
            Text = InTexts[i],
            Icon = InIcons[i],
            bShowRecommend = ExcelWeaponTags and CommonUtils.HasValue(ExcelWeaponTags,value)
        })
    end
    return Filters
end

function M:OnBackKeyDown()
    if(not self.IsListExpanded)then
        return
    end
    return self:OnBackBtnClicked()
end

function M:OnBackBtnClicked()
    if(not self.IsListExpanded)then
        return
    end
    self:ExpandList(false)
end

---展开列表按钮点击时
function M:OnExpandListButtonClicked()
    self:OnExpandListKeyDown()
end

---展开列表快捷键按下时
function M:OnExpandListKeyDown()
    self:ExpandList(not self.IsListExpanded)
end

function M:ResetMainTabStyle(IsListExpanded)
    if(IsListExpanded)then
        local MainTabName = self.CurMainTab.Name
        local TitleName = ""
        local RoleName = ""

        if(MainTabName == ArmoryUtils.ArmoryMainTabNames.Char)then
            TitleName = GText("UI_Armory_Replace_Character").."/"
            RoleName = self.CharMain_CmpContent.UnitName
        elseif MainTabName == ArmoryUtils.ArmoryMainTabNames.Pet then
            if(self.CurPetTabIdx == 1)then
                TitleName = GText("UI_Armory_Replace_Pet").."/"
            else
                TitleName = ""
            end
            RoleName = self.PetMain_CmpContent.UnitName
        else
            TitleName = GText("UI_Armory_Replace_Weapon").."/"
            RoleName = self[self.CmpContentName].UnitName
        end
        if(self.IsPreviewMode)then
            TitleName = GText("UI_Preview_Switch").."/"
        end
        self.TitleName = TitleName .. RoleName
        self:UpdateMainTabs({})
        self.Tab_Arm:UpdateTopTitle(self.TitleName)
        -- self:InitMainTabsStyle(
        --     {
        --         TitleName = TitleName .."/".. RoleName,
        --         Tabs = {},
        --         DynamicNode={
        --             "Back",
        --             -- "Tip",
        --             "BottomKey",
        --         },
        --         BottomKeyInfo = {},
        --         StyleName = "Text",
        --         BackCallback = self.OnBackBtnClicked,
        --         OwnerPanel = self,
        --     }
        --     ,true
        -- )
        if(not self.IsPC)then
            self.Tab_Arm.Panel_Tab:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        end
    else
        self:InitMainTabsStyle(self.MainTabsStyle,true)
        local CurMainTabIdx = self.MainTabName2Idx[self.CurMainTab.Name]
        self:UpdateMainTabs(self.MainTabs)
        if(CurMainTabIdx)then
            self.Tab_Arm:SelectTab(CurMainTabIdx)
        end
    end
end

function M:SetReceivedEvent(IsReceive)
    self.ComponentReceivedEvent["Back"] = IsReceive
    self.ComponentReceivedEvent["WheelScroll"] = IsReceive
    self.ComponentReceivedEvent["OnClose"] = IsReceive
    self.ComponentReceivedEvent["ReceiveEnterState"] = IsReceive
    self.ComponentReceivedEvent["RoleUp"] = IsReceive
    self.ComponentReceivedEvent["RoleDown"] = IsReceive
    self.ComponentReceivedEvent["OnLeftThumbstickKeyDown"] = IsReceive
    self.ComponentReceivedEvent["OnLeftThumbstickKeyUp"] = IsReceive
    self.ComponentReceivedEvent["InitKeySetting"] = IsReceive
    self.ComponentReceivedEvent["GetDesiredFocusTargetInfo"] = IsReceive
    self.ComponentReceivedEvent["OnGetSubUINavigationInfo"] = IsReceive
    self.ComponentReceivedEvent["SelectRoleListItem"] = IsReceive
end

---开关列表
function M:ExpandList(IsListExpanded)
    if(IsListExpanded)then
        self.IsListExpanded = true
        self.ExcelWeaponTags = nil

        self:SetReceivedEvent(IsListExpanded)
        self:ResetMainTabStyle(IsListExpanded)
        if(self.CurMainTab.Name == ArmoryUtils.ArmoryMainTabNames.Melee or self.CurMainTab.Name == ArmoryUtils.ArmoryMainTabNames.Ranged)then
            self.ExcelWeaponTags = UIUtils.GetExcelWeaponTags(self.ComparedChar.CharId)
        end
        self:CreateWeaponFilterTags()
        if(self[self.CurMainTab.Name .. "FilterTags"])then
            self.Filters = self:CreateFilters(self[self.CurMainTab.Name .. "FilterTags"],
                                            self[self.CurMainTab.Name .. "FilterNames"],
                                            self[self.CurMainTab.Name .. "FilterIcons"],
                                            self.ExcelWeaponTags)
        else
            self.Filters = nil
        end
        --@note WBP_Armory_Selective_Listing Init 用例
        self.Selective_Listing:BindEvents(self,{
            OnListItemClicked = self.OnExpandListItemClicked,
            OnListItemSelectionChanged = self.OnExpandListItemSelectionChanged,
            OnEntryInitialized = self.OnExpandListEntryInitialized,
            SortFuncion = self.ExpandList_SortItemContents,
            FilterFunction = self.FilterItemContents,
        })
        local SortFuncName = self.CurMainTab.Name .. "Main_SortItemContents"
        rawset(self,SortFuncName,self["Replaced_" .. SortFuncName])
        local OrderByDisplayNames
        if(self.CurMainTab.Name == ArmoryUtils.ArmoryMainTabNames.Pet
        and self.PetItemContentsArray == self.ResourcePetItemContentsArray)then
            OrderByDisplayNames = self.ResourcePetOrderByDisplayNames
        else
            OrderByDisplayNames = self[self.CurMainTab.Name .. "OrderByDisplayNames"]
        end
        self.Selective_Listing:Init(self,{
            Filters = self.Filters,
            OrderByDisplayNames = OrderByDisplayNames,
            SortIdx = self:GetCurSortIdx() or 1,
            SortType = self:GetCurSortType() or CommonConst.DESC,
            ItemContents = self[self.CurMainTab.Name .. "ItemContentsArray"],
        })

        local LastCameraTags = self.ActorController.LastCameraTags
        if(LastCameraTags)then
            self.LastCameraTagsBeforeExpandList = {
                table.unpack(LastCameraTags)
            }
            self.ActorController:SetArmoryCameraTag(LastCameraTags[1],LastCameraTags[2],"Switch",LastCameraTags[4])
        end
        self.Tab_L_Visibility = self.Tab_L:GetVisibility()
        self.Panel_SubTab_Visibility = self.Panel_SubTab:GetVisibility()
        self.Tab_PetAlive_Visibility =  self.Tab_PetAlive:GetVisibility()
        self.Tab_PetAlive:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self:HideLeftPanels(IsListExpanded)
        if(self.CurMainTab.Name == ArmoryUtils.ArmoryMainTabNames.Char)then
            self.Selective_Listing:SetEmptyStateText(GText("UI_Armory_Char_Empty"))
        elseif(self.CurMainTab.Name == ArmoryUtils.ArmoryMainTabNames.Pet)then
            self.Selective_Listing:SetEmptyStateText(GText("UI_Armory_Pet_Empty"))
        else
            self.Selective_Listing:SetEmptyStateText(GText("UI_Armory_Weapon_Empty"))
        end
        self.Selective_Listing:PlayInAnim()
        self.Selective_Listing:SetFocusToList()
        if(self.IsPC)then
            self:InitKeySetting()
        end
    else
        self.IsListExpanded = false
        self.Selective_Listing:PlayOutAnim()
        self:PlayAnimation(self.RoleList_In)
        self:PlayAnimation(self.BG_BackFirst)
        self.Panel_SubTab:SetVisibility(self.Tab_L_Visibility)
        self.Tab_L:SetVisibility(self.Panel_SubTab_Visibility)
        self.Tab_PetAlive:SetVisibility(self.Tab_PetAlive_Visibility)
        self:SetReceivedEvent(IsListExpanded)
        self:ResetMainTabStyle(IsListExpanded)
        local LastCameraTags = self.ActorController.LastCameraTags
        if(LastCameraTags)then
            local CameraTags = {
                table.unpack(LastCameraTags)
            }
            if(CameraTags[3] == "Switch")then
                CameraTags[3] = self.LastCameraTagsBeforeExpandList[3]
            end
            self.ActorController:SetArmoryCameraTag(table.unpack(CameraTags))
        end
        self:SetAllReddotRead()
        self:SortItemContents()
        self:InitRoleList()
        if(self.GetDesiredFocusTargetInfo)then
            local Info = {}
            self:GetDesiredFocusTargetInfo(Info)
            if(Info.Widget)then
                Info.Widget:SetFocus()
            else
                self:SetFocus()
            end
        end
        if(self.IsPC)then
            self:InitKeySetting()
        end
    end
end

function M:UpdataExpandList()
end

function M:OnWeaponGradeLevelUp()
    if(not self.IsListExpanded)then
        return
    end
    -- self.Selective_Listing:Init(self,{
    --     Filters = self.Filters,
    --     OrderByDisplayNames = self[self.CurMainTab.Name .. "OrderByDisplayNames"],
    --     SortType = CommonConst.DESC,
    --     ItemContents = self[self.CurMainTab.Name .. "ItemContentsArray"],
    -- })
end

---列表的项目点击时
function M:OnExpandListItemClicked(Content)
    if(not self.IsListExpanded)then
        return
    end
    if(not Content.Uuid)then
        return
    end
    self:CallFunctionByName(self.CurMainTab.Name .. "Main_OnRoleListItemClicked",Content)
end

function M:SelectRoleListItem(Content)
    if(not self.IsListExpanded)then
        return
    end
    self:CallFunctionByName(self.CurMainTab.Name .. "Main_SelectRoleListItem",Content)
    self:ResetMainTabStyle(self.IsListExpanded)
    self:HideLeftPanels()
end

---列表的项目选中时
function M:OnExpandListItemSelectionChanged(Content,IsSelected)
    if(not self.IsGamepadInput or not IsSelected)then
        return
    end
    self:OnExpandListItemClicked(Content)
end

function M:OnExpandListEntryInitialized(Content,Widget)
    if(self.CurMainTab.Name == ArmoryUtils.ArmoryMainTabNames.Pet)then
        if(not Content.IsResourcePet)then
            Widget:SetLevel(Content.Level)
        end
    end
end

function M:HideLeftPanels()
    self.Tab_L:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    self.Panel_SubTab:SetVisibility(UIConst.VisibilityOp["Collapsed"])
end

function M:InitRoleList()
    if(self.IsListExpanded)then
        self.Selective_Listing:Resort()
    end
end

function M:Replaced_SortItemContent(InOutContentArray)
    if(not self:GetCurSortIdx())then
        return
    end
    self:ExpandList_SortItemContents(InOutContentArray,self:GetCurSortIdx(), self:GetCurSortType())
end

function M:Replaced_CharMain_SortItemContents()
    self:Replaced_SortItemContent(self.CharItemContentsArray)
end

function M:Replaced_MeleeMain_SortItemContents()
    self:Replaced_SortItemContent(self.WeaponItemContentsArray)
end

function M:Replaced_RangedMain_SortItemContents()
    self:Replaced_SortItemContent(self.WeaponItemContentsArray)
end

function M:Replaced_WeaponMain_SortItemContents()
    self:Replaced_SortItemContent(self.WeaponItemContentsArray)
end

function M:Replaced_PetMain_SortItemContents()
    self:Replaced_SortItemContent(self.PetItemContentsArray)
end

function M:SetCurSortType(SortType)
    if(self.CurMainTab.Name == ArmoryUtils.ArmoryMainTabNames.Pet)then
        if(self.PetItemContentsArray == self.ResourcePetItemContentsArray)then
            rawset(self,"Resource" .. self.CurMainTab.Name .. "SortType",SortType)
            return
        end
    end
    rawset(self,self.CurMainTab.Name .. "SortType",SortType)
end

function M:GetCurSortType()
    if(self.CurMainTab.Name == ArmoryUtils.ArmoryMainTabNames.Pet)then
        if(self.PetItemContentsArray == self.ResourcePetItemContentsArray)then
            return rawget(self,"Resource" .. self.CurMainTab.Name .. "SortType")
        end
    end
    return rawget(self,self.CurMainTab.Name .. "SortType")
end

function M:SetCurSortIdx(SortIdx)
    if(self.CurMainTab.Name == ArmoryUtils.ArmoryMainTabNames.Pet)then
        if(self.PetItemContentsArray == self.ResourcePetItemContentsArray)then
            rawset(self,"Resource" .. self.CurMainTab.Name .. "SortIdx",SortIdx)
            return
        end
    end
    rawset(self,self.CurMainTab.Name .. "SortIdx",SortIdx)
end

function M:GetCurSortIdx()
    if(self.CurMainTab.Name == ArmoryUtils.ArmoryMainTabNames.Pet)then
        if(self.PetItemContentsArray == self.ResourcePetItemContentsArray)then
            return rawget(self,"Resource" .. self.CurMainTab.Name .. "SortIdx")
        end
    end
    return rawget(self,self.CurMainTab.Name .. "SortIdx")
end

function M:ExpandList_SortItemContents(InOutContentArray,SortIdx, SortType)
    self:SetCurSortIdx(SortIdx)
    self:SetCurSortType(SortType)
    local FirtContent = self[self.CurMainTab.Name .. "Main_CurContent"]
    local SortAttrNames
    local Func = self[self.CurMainTab.Name .. "_GetSortAttrNames"]
    if(Func)then
        SortAttrNames = Func(self,SortIdx)
    else
        SortAttrNames = self:Common_GetSortAttrNames(SortIdx)
    end
    ArmoryUtils:SortItemContents(InOutContentArray,SortAttrNames,SortType,FirtContent,
                    function(a,b)
                        if(a.IsOwned or b.IsOwned)then
                            return ArmoryUtils.IsOwnedCmpFunc(a,b)
                        end
                        if a.Unlockable ~= b.Unlockable then
                            if a.Unlockable then
                                return true
                            else
                                return false
                            end
                        end
                    end)
end

function M:Common_GetSortAttrNames(SortIdx)
    local OrderAttrNames = self[self.CurMainTab.Name .. "OrderByAttrNames"]
    local SortAttrNames = {OrderAttrNames[SortIdx]}
    for index, value in ipairs(OrderAttrNames) do
        if(index ~= SortIdx)then
            table.insert(SortAttrNames,value)
        end
    end
    return SortAttrNames
end

function M:Pet_GetSortAttrNames(SortIdx)
    local SortAttrNames
    if(self.PetItemContentsArray == self.UseablePetItemContentsArray)then
        local OrderByAttrNames = self.PetOrderByAttrNames
        if(SortIdx == 2)then
            SortAttrNames = {"Rarity"}
            for index, value in ipairs(OrderByAttrNames) do
                if(value ~= SortAttrNames[1])then
                    table.insert(SortAttrNames,value)
                end
            end
        else
            SortAttrNames = OrderByAttrNames
        end
    else
        if(SortIdx == 1)then
            SortAttrNames = self.ResourcePetOrderByAttrNames
        else
            SortAttrNames = {"_PetEntryId"}
            for index, value in ipairs(self.ResourcePetOrderByAttrNames) do
                if(value ~= SortAttrNames[1])then
                    table.insert(SortAttrNames,value)
                end
            end
        end
    end
    return SortAttrNames
end

function M:FilterItemContents(InContentArray, FilterIdxes)
    --过滤数据对象
    local TabName = self.CurMainTab.Name
    local FilteredItems = {}
    local FilterFunc
    if(TabName == ArmoryUtils.ArmoryMainTabNames.Char)then
        FilterFunc = function(FilterTag,Content)
            local Data = DataMgr.BattleChar[Content.UnitId]
            return FilterTag == Data.Attribute
        end
    elseif(TabName == ArmoryUtils.ArmoryMainTabNames.Melee
            or TabName == ArmoryUtils.ArmoryMainTabNames.Ranged
            or TabName == ArmoryUtils.ArmoryMainTabNames.Weapon)then
        FilterFunc = function(FilterTag,Content)
            local Data = DataMgr.BattleWeapon[Content.UnitId]
            local Tags = Data and Data.WeaponTag
            if(not Tags)then return end
            for key, value in pairs(Tags) do
                if(value == FilterTag)then
                    return true
                end
            end
        end
    elseif(TabName == ArmoryUtils.ArmoryMainTabNames.Pet)then
        FilterFunc = function()
            return true
        end
    end
    local bShowSubTile = false
    if(FilterFunc)then
        for _, Content in ipairs(InContentArray) do
            if(FilterIdxes and next(FilterIdxes))then
                for _, Idx in ipairs(FilterIdxes) do
                    local Tag = self[TabName .. "FilterTags"][Idx]
                    if(self.ExcelWeaponTags and CommonUtils.HasValue(self.ExcelWeaponTags,Tag))then
                        bShowSubTile = true
                    end
                    if(FilterFunc(Tag,Content))then
                        table.insert(FilteredItems,Content)
                        break
                    end
                end
            else
                table.insert(FilteredItems,Content)
            end
        end
    end
    --设置列表副标题
    if(bShowSubTile)then
        self.Selective_Listing:SetSubTitle(GText("UI_Armory_CharExcelWeapon"))
    end
    return FilteredItems
end

function M:OnArmoryModClosed(Type,Tag)
    if(not self.IsListExpanded)then
        return
    end
    self:UpdateMontageAndCamera()
end

function M:RealClose()
    if(not self.IsListExpanded)then
        return
    end
    self:ExpandList(false)
end

function M:ReceiveEnterState(StackAction)
    if(not self.IsListExpanded)then
        return
    end
end

--#region 交互事件
function M:InitKeySetting()
    if(not self.IsListExpanded)then
        return
    end
    self:InitKeySettingCommon()
    self:CallFunctionByName("ExpandList_" .. self.CurMainTab.Name .. "Main_InitKeySetting",self.KeyDownEvents,self.KeyUpEvents,self.BottomKeyInfo)
    self:UpdateBottomKeyInfo(self.BottomKeyInfo)
end

function M:ExpandList_CharMain_InitKeySetting(KeyDownEvents,KeyUpEvents,BottomKeyInfo)
    if(not self.bHideSquadBuildBtn or not self.IsPreviewMode)then
        self:AddKeyEvents(KeyDownEvents,self.MenuKeyDownEvents)
    end
    self:AddKeyEvents(KeyDownEvents,
                        self.LeftThumbstickKeyDownEvents,
                        self.CommonKeyDownEvents)
    if(self.CurSubTab.Name == ArmoryUtils.ArmorySubTabNames.Attribute)then
        if(not self.AttributeButtonStyleParams[1].ForbidBtn and not self.IsPreviewMode)then
            self:AddKeyEvents(KeyDownEvents,self.UpgradeKeyDownEvents)
        end
    end
    table.insert(BottomKeyInfo,self.ESCKeyInfoList)
end

function M:ExpandList_MeleeMain_InitKeySetting(KeyDownEvents,KeyUpEvents,BottomKeyInfo)
    self:ExpandList_WeaponMain_InitKeySetting(KeyDownEvents,KeyUpEvents,BottomKeyInfo)
end

function M:ExpandList_RangedMain_InitKeySetting(KeyDownEvents,KeyUpEvents,BottomKeyInfo)
    self:ExpandList_WeaponMain_InitKeySetting(KeyDownEvents,KeyUpEvents,BottomKeyInfo)
end

function M:ExpandList_WeaponMain_InitKeySetting(KeyDownEvents,KeyUpEvents,BottomKeyInfo)
    if(not self.bHideSquadBuildBtn or not self.IsPreviewMode)then
        self:AddKeyEvents(KeyDownEvents,self.MenuKeyDownEvents)
    end
    self:AddKeyEvents(KeyDownEvents,
                        self.LeftThumbstickKeyDownEvents,
                        self.CommonKeyDownEvents)
    self:AddKeyEvents(KeyUpEvents,self.LeftThumbstickKeyUpEvents)
    if(self.WeaponTag ~= CommonConst.ArmoryTag.UWeapon and not self.IsPreviewMode)then
        if(self.CurSubTab.Name == ArmoryUtils.ArmorySubTabNames.Attribute)then
            if(not self.AttributeButtonStyleParams[1].ForbidBtn)then
                self:AddKeyEvents(KeyDownEvents,self.UpgradeKeyDownEvents)
            end
        end
    end
    table.insert(self.BottomKeyInfo,self.ESCKeyInfoList)
end

function M:ExpandList_PetMain_InitKeySetting(KeyDownEvents,KeyUpEvents,BottomKeyInfo)
    if(not self.bHideSquadBuildBtn or not self.IsPreviewMode)then
        self:AddKeyEvents(KeyDownEvents,self.MenuKeyDownEvents)
    end
    self:AddKeyEvents(KeyDownEvents,self.CommonKeyDownEvents,self.LeftThumbstickKeyDownEvents)
    if(self.CurSubTab.Name == ArmoryUtils.ArmorySubTabNames.Attribute)then
        if(not self.SubUIButtonStyleInfo[1].ForbidBtn)then
            self:AddKeyEvents(KeyDownEvents,self.UpgradeKeyDownEvents)
        end
    end
    table.insert(BottomKeyInfo,self.ESCKeyInfoList)
end

function M:InitKeySettingCommon()
    if(self.IsListExpanded)then
        self:AddKeyEvents(self.KeyDownEvents,self.ViewKeyDownEvents)
    elseif(self.BoxWidget:IsVisible())then
        self:AddKeyEvents(self.KeyDownEvents,self.ViewKeyDownEvents)
    end
end

function M:CharMain_OnViewKeyDown()
    self:ExpandList_OnViewKeyDown()
end

function M:WeaponMain_OnViewKeyDown()
    self:ExpandList_OnViewKeyDown()
end

function M:PetMain_OnViewKeyDown()
    self:ExpandList_OnViewKeyDown()
end

function M:ExpandList_OnViewKeyDown()
    if(self.IsListExpanded)then
        self:ExpandList(false)
    elseif(self.BoxWidget:IsVisible())then
        self:ExpandList(true)
    end
end

function M:OnLeftThumbstickKeyDown()
    if(not self.IsListExpanded)then
        return
    end
    self.Selective_Listing:SetSortWidgetFocus()
end

function M:OnBackgroundClicked()
    if(self.IsListExpanded)then
        self:ExpandList(false)
    end
end

function M:CharMain_OnFocusReceived(ReplyInfo)
    self:ExpandList_OnFocusReceived(ReplyInfo)
end
function M:WeaponMain_OnFocusReceived(ReplyInfo)
    self:ExpandList_OnFocusReceived(ReplyInfo)
end
function M:PetMain_OnFocusReceived(ReplyInfo)
    self:ExpandList_OnFocusReceived(ReplyInfo)
end
function M:ExpandList_OnFocusReceived(ReplyInfo)
    if(not self.IsListExpanded)then
        return
    end
    ReplyInfo.Reply = UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self.Selective_Listing)
    ReplyInfo.IsHandled = true
end

function M:GetDesiredFocusTargetInfo(Info)
    if(self.IsListExpanded)then
        if(self.CurrentSubUI and self.CurrentSubUI.UnlockDialog)then
            Info.Widget = self.CurrentSubUI.UnlockDialog
            return
        end
        Info.Widget = self.Selective_Listing
    end
end

function M:OnGetSubUINavigationInfo(Info,NavigationDirection)
    if(not self.IsListExpanded)then
        return
    end
    if(NavigationDirection == EUINavigation.Left)then
        Info.Widget = self.Selective_Listing
    end
end

--#endregion 交互事件

function M:PetMain_Init()
    if(not self.IsListExpanded)then
        return
    end
    self:ExpandList(true)
end

function M:WeaponMain_Init()
    if(not self.IsListExpanded)then
        return
    end
    self:ExpandList(true)
end

function M:CharMain_Init()
    if(not self.IsListExpanded)then
        return
    end
    self:ExpandList(true)
end

function M:ExpandList_OnItemContentsChanged()
    if(not self.IsListExpanded)then
        return
    end
    self.Selective_Listing:SetItemContents(self[self.CurMainTab.Name .. "ItemContentsArray"])
    local Item = self.Selective_Listing:GetSelectedListItem()
    if(Item)then
        self.Selective_Listing:ScrollItemIntoView(Item)
    end
end

function M:OnNewCharObtained()
    self:ExpandList_OnItemContentsChanged()
end

function M:OnNewWeaponObtained()
    self:ExpandList_OnItemContentsChanged()
end

function M:OnWeaponDeleted()
    self:ExpandList_OnItemContentsChanged()
end

function M:OnNewPetObtained()
    self:ExpandList_OnItemContentsChanged()
end

function M:OnPetDeleted()
    self:ExpandList_OnItemContentsChanged()
end

return M
