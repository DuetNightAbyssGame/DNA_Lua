--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Armory_Selective_Listing_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C","BluePrints.Common.TimerMgr"})

function M:Construct()
    self.Overridden.Construct(self)
    self.Pos_Tips:ClearChildren()
    self:AddTimer(0.1,function()
        --优化构造速度
        self.Bg_Dialog.Text_MailDetail_Empry:SetText("")
        self.List_RedDotTop:PlayAnimation(self.List_RedDotTop.Loop_T,0,0)
        self.List_New_Top:PlayAnimation(self.List_New_Top.Loop_T,0,0)
        self.List_New_Bottom:PlayAnimation(self.List_New_Bottom.Loop_D,0,0)
        self.List_RedDotBottom:PlayAnimation(self.List_RedDotBottom.Loop_D,0,0)
        self.List_RedDotTop.Btn_Click.OnClicked:Add(self, self.OnTopReddotClicked)
        self.List_New_Top.Btn_Click.OnClicked:Add(self, self.OnTopReddotClicked)
        self.List_New_Bottom.Btn_Click.OnClicked:Add(self, self.OnBottomReddotClicked)
        self.List_RedDotBottom.Btn_Click.OnClicked:Add(self, self.OnBottomReddotClicked)
    end,false,0,"DelayConstruct",true)
    --self.bIsFocusable = true
end

function M:OnListItemInited(Content, EntryUI)
    self:UpdateReddot()
    if(self.Event_OnEntryInitialized)then
        self.Event_OnEntryInitialized(self.EventReceiver,Content,EntryUI)
    end
end

---@alias ParamType {Filters:table, FilterMod:string, SortType:string,ItemContents:table<UObject>,OrderByDisplayNames:tabel<string>,SubTitle:string}
---@param Parent UIWiget
---@param Params ParamType
function M:Init(Parent,Params)
    self.Parent = Parent
    self.Params = Params
    self.Filters = Params.Filters or {}
    self.FilterMod = Params.FilterMod or "Single"
    self.FilterIdxes = {}
    self.OrderByDisplayNames = Params.OrderByDisplayNames
    self.SortIdx = Params.SortIdx
    self.SortType = Params.SortType
    self.AllItemContents = Params.ItemContents
    self.EMListView_Filter:ClearListItems()
    self.SelectedFilterContents = {}
    self.FilteredContents = {}
    self.LastSelectedFilterContent = nil
    if(self.AllItemContents)then
        for index, value in ipairs(self.AllItemContents) do
        table.insert(self.FilteredContents,value)
        end
    end

    self.FilterContentObj_All = nil
    if(#self.Filters>0)then
        self.FilterContentObj_All = NewObject(UIUtils.GetCommonItemContentClass())
        self.FilterContentObj_All.IsSelect = true
        self.FilterContentObj_All.Index = 0
        self.FilterContentObj_All.Icon = '/Game/UI/Texture/Static/Atlas/Armory/T_Armory_Select.T_Armory_Select'
        self.FilterContentObj_All.IsSelected = true
        self.FilterContentObj_All.Owner = self
        self.LastSelectedFilterContent = self.FilterContentObj_All
        self.EMListView_Filter:AddItem(self.FilterContentObj_All)
        self.Panel_FilterTab:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self:SetTitle(GText("UI_ALL"))
    else
        self:SetTitle(nil)
        self.Panel_FilterTab:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end

    self:SetSubTitle(Params.SubTitle)

    for Index, Tag in ipairs(self.Filters) do
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        for key, value in pairs(Tag) do
            Obj[key] = value
        end
        Obj.Index = Index
        Obj.Owner = self
        self.EMListView_Filter:AddItem(Obj)
    end

    self.Common_Sort_List:Init(self.Parent,
                                self.OrderByDisplayNames,
                                self.SortType or CommonConst.DESC,
                                {SortBy = self.SortIdx,
                                OnGetBackFocusWidget = function(_self,MyGeometry, InKeyEvent)
                                    return self:OnSortListWidgetBack(MyGeometry, InKeyEvent)
                                end,
                                OnAddedToFocusPath = function()
                                    self:OnSortListAddedToFocusPath()
                                end,
                                OnRemovedFromFocusPath = function()
                                    self:OnSortListRemovedFromFocusPath()
                                end })
    self.Common_Sort_List:BindEventOnSelectionsChanged(self,self.OnSortListSelectionsChanged)
    self.Common_Sort_List:BindEventOnSortTypeChanged(self,self.OnSortTypeChanged)
    self.Bg_Dialog.Not_Have:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:FillListView()
    self:InitNavigationRules()
end

function M:SetItemContents(ItemContents)
    self.AllItemContents = ItemContents
    self:UpdateFilterInfos()
    if(self.Event_FilterFunction)then
        self.FilteredContents = self.Event_FilterFunction(self.EventReceiver,self.AllItemContents,self.FilterIdxes) or {}
        if(self.Event_SortFuncion)then
            local SortBy, SortType = self.Common_Sort_List:GetSortInfos()
            self.Event_SortFuncion(self.EventReceiver,self.FilteredContents,SortBy, SortType)
        end
        self:FillListView()
        self:RegenerateAllEntries()
    end
end

function M:BindEvents(EventReceiver,Events)
    self.EventReceiver = EventReceiver
    self.Event_OnListItemClicked = Events.OnListItemClicked
    self.Event_OnListItemSelectionChanged = Events.OnListItemSelectionChanged
    self.Event_SortFuncion = Events.SortFuncion
    self.Event_FilterFunction = Events.FilterFunction
    self.Event_OnListItemInited = Events.OnListItemInited
    self.Event_OnEntryInitialized = Events.OnEntryInitialized
    self.Event_OnItemIsHoverChanged =  Events.OnItemIsHoverChanged
end

function M:SetSortWidgetFocus()
    self.Common_Sort_List:SetFocus()
end

function M:SetFocusToList()
    self.TileView_Select_Role:SetFocus()
    if(self.LastSelectedListContent)then
        self.TileView_Select_Role:BP_CancelScrollIntoView()
        self.TileView_Select_Role:BP_SetSelectedItem(self.LastSelectedListContent)
        self.TileView_Select_Role:BP_ScrollItemIntoView(self.LastSelectedListContent)
        self.TileView_Select_Role:BP_NavigateToItem(self.LastSelectedListContent)
    end
end

function M:OnListItemClicked(Content)
    if(self.Event_OnListItemClicked)then
        self.Event_OnListItemClicked(self.EventReceiver,Content)
    end
end

function M:OnListItemSelectionChanged(Content,IsSelected)
    if(IsSelected)then
        self.LastSelectedListContent = Content
    end
    if(self.Event_OnListItemSelectionChanged)then
        self.Event_OnListItemSelectionChanged(self.EventReceiver,Content,IsSelected)
    end
end

function M:OnItemIsHoverChanged(Content)
    if(self.Event_OnItemIsHoverChanged)then
        self.Event_OnItemIsHoverChanged(self.EventReceiver,Content)
    end
end

---筛选器选项选中改变时
function M:OnFilterListItemClicked(Content)
    self.LastSelectedFilterContent = Content
    if(self.FilterMod == "Single")then
        if(Content.IsSelected)then
            return
        end
        for Tag, Value in pairs(self.SelectedFilterContents) do
            if(Value ~= Content)then
                self:SetFilterContentIsSelected(Value,false)
                self.SelectedFilterContents[Tag] = nil
            end
        end
        if(self.FilterContentObj_All ~= Content)then
            self:SetFilterContentIsSelected(self.FilterContentObj_All,false)
            self:SetTitle(GText(Content.Text))
        else
            self:SetTitle(GText("UI_ALL"))
        end
        self:SetSubTitle(self.Params.SubTitle)
        self:SetFilterContentIsSelected(Content,true)
    else
        --TODO多选
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_sort_tab", nil, nil)
    self:UpdateFilterInfos()
    if(self.Event_FilterFunction)then
        self.FilteredContents = self.Event_FilterFunction(self.EventReceiver,self.AllItemContents,self.FilterIdxes) or {}
        if(self.Event_SortFuncion)then
            local SortBy, SortType = self.Common_Sort_List:GetSortInfos()
            self.Event_SortFuncion(self.EventReceiver,self.FilteredContents,SortBy, SortType)
        end
        self:FillListView()
        self.TileView_Select_Role:ScrollToTop()
    end
end

function M:SetFilterContentIsSelected(Content,IsSelected)
    Content.IsSelected = IsSelected
    if(Content.UI)then
        Content.UI:SetIsSelected(Content.IsSelected)
    end
    if(Content.Tag)then
        self.SelectedFilterContents[Content.Tag] = Content
    end
end

function M:UpdateFilterInfos()
    local Indexes = {}
    local bHasItem = (next(self.SelectedFilterContents) ~= nil)
    local Items = self.EMListView_Filter:GetListItems()
    local Len = Items:Length()
    if(bHasItem)then
        for i = 2,Len do
            if(self.SelectedFilterContents[Items[i].Tag])then
                table.insert(Indexes,Items[i].Index)
            end
        end
    else
        for i = 2,Len do
            table.insert(Indexes,Items[i].Index)
        end
    end
    self.FilterIdxes = Indexes
    return self.FilterIdxes
end

function M:Resort()
    self:OnSortListSelectionsChanged()
end

---排序依据选项选中时
function M:OnSortListSelectionsChanged()
    local SortBy, SortType = self.Common_Sort_List:GetSortInfos()
    if(self.Event_SortFuncion)then
        self.Event_SortFuncion(self.EventReceiver,self.FilteredContents,SortBy, SortType)
        self:FillListView()
    end
end

---升序降序改变时
function M:OnSortTypeChanged()
    local SortBy, SortType = self.Common_Sort_List:GetSortInfos()
    if(self.Event_SortFuncion)then
        self.Event_SortFuncion(self.EventReceiver,self.FilteredContents,SortBy, SortType)
        self:FillListView()
    end
end

function M:NavigateToItem(Content)
    self.TileView_Select_Role:BP_NavigateToItem(Content)
end

function M:ScrollItemIntoView(Content)
    self.TileView_Select_Role:BP_ScrollItemIntoView(Content)
end

function M:GetSelectedListItem()
    return self.LastSelectedListContent
end

function M:FillListView()
    self:PlayAnimation(self.List_Change)
    self.TileView_Select_Role:ClearListItems()
    self.LastSelectedListContent = nil
    for i, value in ipairs(self.FilteredContents) do
        value.IndexInList= i-1
        if(value.IsSelect)then
            self.LastSelectedListContent = value
        end
        self.TileView_Select_Role:AddItem(value)
    end
    if(not self.LastSelectedListContent)then
        self.LastSelectedListContent = self.FilteredContents[1]
    end
    if(#self.FilteredContents <= 0)then
        self.Bg_Dialog.Not_Have:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.TileView_Select_Role:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        self.Bg_Dialog.Not_Have:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.TileView_Select_Role:SetVisibility(UIConst.VisibilityOp.Visible)
        self:AddTimer(0.01, function()
            local ItemUIs = self.TileView_Select_Role:GetDisplayedEntryWidgets()
            local  XCount, YCount = UIUtils.GetTileViewContentMaxCount(self.TileView_Select_Role,"XY")
            local ItemLen = ItemUIs:Length()
            local RestCount = XCount * YCount - ItemLen
            if(RestCount <= 0)then
                RestCount = XCount - #self.FilteredContents % XCount
            end
            self:FillEmptyItems(RestCount)
            --注掉这句话是因为ListView生成Item期间再重新生成一次而且Icon异步加载失败的话会导致Icon错乱
            --self.TileView_Select_Role:RegenerateAllEntries()
			if self.Event_OnListItemInited then
			    self.Event_OnListItemInited(self.EventReceiver)
			end
        end,false, 0, "DelayAddEmptyItem",true)
    end
    self:UpdateReddot()
end

function M:OnListEntryReleased()
    --self:UpdateReddot()
end

function M:UpdateReddot()
    self:AddTimer(0.2,function()
        local MinEntryIdx,MaxEntryIdx = UIUtils.GetMinAndMaxDisplayedItemIndex(self.TileView_Select_Role)
        local AllItems = self.TileView_Select_Role:GetListItems():ToTable()
        local ShowTopRed = false
        local ShowTopNew = false
        local ShowBottomRed = false
        local ShowBottomNew = false
        for i=MinEntryIdx-1,1,-1 do
            if(AllItems[i].RedDotType == UIConst.RedDotType.CommonRedDot)then
                ShowTopRed = true
                break
            elseif(AllItems[i].RedDotType == UIConst.RedDotType.NewRedDot)then
                ShowTopNew = true
            end
        end
        for i=MaxEntryIdx+1,#AllItems,1 do
            if(AllItems[i].RedDotType == UIConst.RedDotType.CommonRedDot)then
                ShowBottomRed = true
                break
            elseif(AllItems[i].RedDotType == UIConst.RedDotType.NewRedDot)then
                ShowBottomNew = true
            end
        end
        if(ShowTopRed)then
            self.List_RedDotTop:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            self.List_New_Top:SetVisibility(UIConst.VisibilityOp.Collapsed)
        elseif(ShowTopNew)then
            self.List_RedDotTop:SetVisibility(UIConst.VisibilityOp.Collapsed)
            self.List_New_Top:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        else
            self.List_RedDotTop:SetVisibility(UIConst.VisibilityOp.Collapsed)
            self.List_New_Top:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end

        if(ShowBottomRed)then
            self.List_RedDotBottom:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            self.List_New_Bottom:SetVisibility(UIConst.VisibilityOp.Collapsed)
        elseif(ShowBottomNew)then
            self.List_RedDotBottom:SetVisibility(UIConst.VisibilityOp.Collapsed)
            self.List_New_Bottom:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        else
            self.List_RedDotBottom:SetVisibility(UIConst.VisibilityOp.Collapsed)
            self.List_New_Bottom:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end,false, 0, "DelayUpdateReddot",true)
end

function M:OnTopReddotClicked()
    local MinEntryIdx,MaxEntryIdx = UIUtils.GetMinAndMaxDisplayedItemIndex(self.TileView_Select_Role)
    local AllItems = self.TileView_Select_Role:GetListItems():ToTable()
    for i=MinEntryIdx-1,1,-1 do
        if(AllItems[i].RedDotType)then
            self.TileView_Select_Role:BP_ScrollItemIntoView(AllItems[i])
            break
        end
    end
end

function M:OnBottomReddotClicked()
    local MinEntryIdx,MaxEntryIdx = UIUtils.GetMinAndMaxDisplayedItemIndex(self.TileView_Select_Role)
    local AllItems = self.TileView_Select_Role:GetListItems():ToTable()
    for i=MaxEntryIdx+1,#AllItems,1 do
        if(AllItems[i].RedDotType)then
            self.TileView_Select_Role:BP_ScrollItemIntoView(AllItems[i])
            break
        end
    end
end

function M:RegenerateAllEntries()
    self.TileView_Select_Role:RegenerateAllEntries()
end

function M:FillEmptyItems(Count)
    for i = 1, Count do
        self.TileView_Select_Role:AddItem(NewObject(UIUtils.GetCommonItemContentClass()))
    end
end

function M:AttachTipsWidget(Widget)
    self.Pos_Tips:AddChild(Widget)
end

-- function M:ShowTipsWidget(bShow)
--     self.bTipsWidgetShowed = bShow
--     if(bShow)then
--         self.Pos_Tips:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
--     else
--         self.Pos_Tips:SetVisibility(UIConst.VisibilityOp.Collapsed)
--     end
-- end

function M:IsTipsWidgetShowed()
    return self.bTipsWidgetShowed
end

function M:SetEmptyStateText(Text)
    self.Bg_Dialog.Text_MailDetail_Empry:SetText(Text)
end

function M:SetTitle(Title)
    if(Title)then
        self.Panel_Recommend:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Weapon_Recommend:SetText(Title)
    else
        self.Panel_Recommend:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

function M:SetSubTitle(Title)
    if(not Title)then
        self.Text_Commond:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Split:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    else
        self.Text_Commond:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Split:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Text_Commond:SetText(Title)
    end
end

function M:ScrollItemIntoView(Content)
    if(Content)then
        self.TileView_Select_Role:BP_ScrollItemIntoView(Content)
    end
end

function M:PlayInAnim()
    AudioManager(self):PlayUISound(self, "event:/ui/common/sub_panel_expand", "Selective_Listing_In", nil)
    self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self:StopAnimation(self.Out)
    self:PlayAnimation(self.In)
end

function M:PlayOutAnim()
    AudioManager(self):PlayUISound(self, "event:/ui/common/sub_panel_expand", "Selective_Listing_In", {ToEnd = 1})
    self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self:StopAnimation(self.In)
    self:PlayAnimation(self.Out)
end

function M:Destruct()
    if(AudioManager(self):IsSoundPlaying(self, "Selective_Listing_In"))then
        AudioManager(self):SetEventSoundParam(self, "Selective_Listing_In", {ToEnd = 1})
    end
    self:RemoveTimer("DelayAddEmptyItem")
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self.TileView_Select_Role)
end

function M:GetItemAt(Index)
    return self.TileView_Select_Role:GetItemAt(Index)
end

function M:WBP_Armory_Selective_Listing_Out()
    if self.HB_Main:IsVisible() then
        self.Overridden.WBP_Armory_Selective_Listing_Out(self)
    end
end

--#region 导航逻辑

function M:InitNavigationRules()
    self.TileView_Select_Role:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self.TileView_Select_Role:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    self.TileView_Select_Role:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
    self.TileView_Select_Role:SetNavigationRuleCustom(EUINavigation.Left,{self,self.OnRoleListNavigation})

    self.EMListView_Filter:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self.EMListView_Filter:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    self.EMListView_Filter:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
    self.EMListView_Filter:SetNavigationRuleCustom(EUINavigation.Right,{self,self.OnFilterListNavigation})

    self.TileView_Select_Role.bWrapHorizontalNavigation = not self.Panel_FilterTab:IsVisible()
end

function M:OnRoleListNavigation(NavigationDirection)
    if(NavigationDirection == EUINavigation.Left)then
        self.EMListView_Filter:BP_SetSelectedItem(self.LastSelectedFilterContent)
        self.EMListView_Filter:BP_NavigateToItem(self.LastSelectedFilterContent)
        return self.EMListView_Filter
    end
    return self.TileView_Select_Role
end

function M:OnFilterListNavigation(NavigationDirection)
    if(NavigationDirection == EUINavigation.Right)then
        self.TileView_Select_Role:BP_SetSelectedItem(self.LastSelectedListContent)
        self.TileView_Select_Role:BP_NavigateToItem(self.LastSelectedListContent)
        return self.TileView_Select_Role
    end
    return self.EMListView_Filter
end

function M:OnSortListWidgetBack(MyGeometry, InKeyEvent)
    if(self.LastFocusList:IsVisible())then
        return self.LastFocusList
    end
end

function M:OnSortListAddedToFocusPath()
    if(UIUtils.HasAnyFocus(self.EMListView_Filter))then
        self.LastFocusList = self.EMListView_Filter
    else
        self.LastFocusList = self.TileView_Select_Role
    end
end

function M:OnSortListRemovedFromFocusPath()
    -- if(self:IsVisible())then
    --     local FocusSuccess = self.bAutoFocus and self:FocusToSavedWidget()
    --     if(not FocusSuccess)then
    --         self.TileView_Select_Role:SetFocus()
    --         self.TileView_Select_Role:BP_SetSelectedItem(self.LastSelectedListContent)
    --         self.TileView_Select_Role:BP_NavigateToItem(self.LastSelectedListContent)
    --     end
    --     -- if(not self:FocusToSavedWidget())then
    --     --     self:AddTimer(0.01, function()
    --     --         if(self:IsVisible())then
                    
    --     --         end
    --     --     end,false, 0, "DelaySetRoleListFocus",true)
    --     -- end
    -- end
end

--#endregion 导航逻辑

return M
