local EMCache = require "EMCache.EMCache"

local WBP_Rouge_FilterSort_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_Rouge_FilterSort_C:Construct()
    self.RomanNum = {
        "Ⅰ","Ⅱ","Ⅲ","Ⅳ","Ⅴ",
        "Ⅵ","Ⅶ","Ⅷ","Ⅸ","Ⅹ",
        "Ⅺ","Ⅻ"
    }
	--self:AddDispatcher(EventID.OnMenuClose,self,self.OnListClosed)
    self.Btn_Filter_List.OnClicked:Add(self, self.ListOpenBtnClicked)
    self.Btn_Filter_List.OnPressed:Add(self, self.OnBtn_Filter_List_Pressed)
    self.Btn_Filter_List.OnHovered:Add(self, self.OnBtn_Filter_List_Hovered)
    self.Btn_Filter_List.OnUnhovered:Add(self, self.OnBtn_Filter_List_Unhovered)
end

function WBP_Rouge_FilterSort_C:ChangeSelectedItem(Index)
	self.SelectedItem.IsSelected = false
	self.SelectedItem = self.List:GetItemAt(Index)
	self.SelectedItem.IsSelected = true
	self.Text_Filterlist:SetText(self.SelectedItem.Text)
    --self:UpdateSortInfos()
end

function WBP_Rouge_FilterSort_C:SetUnLockTable(UnLockedDifficulty, DifficultyLevel)
	self.UnLockedDifficulty = UnLockedDifficulty
    self.DifficultyLevel = DifficultyLevel
end

function WBP_Rouge_FilterSort_C:OnListItemClicked(Content)
    if(self.IsListOutAnimPlaying)then
        return
    end
    Content.IsSelected = true
    --Content.Entry:OnEntrySelectionChanged()
    if(self.SelectedItem ~= Content)then
        self.SelectedItem.IsSelected = false
        self.SelectedItem.Entry:OnEntrySelectionChanged()
        self.SelectedItem = Content
    --else
    --    return
    end
    -- local SortItem,SortType = self:UpdateSortInfos()
    self.Text_Filterlist:SetText(self.SelectedItem.Text)
    -- if(self.Event_OnSelectionsChanged)then
    --     self.Event_OnSelectionsChanged(self.Obj_OnSelectionsChanged,SortItem, SortType)
    -- end
    self:OnListClosed()
    --EventManager:FireEvent(EventID.OnMenuClose)
end

function WBP_Rouge_FilterSort_C:SwitchClose()
    self.IsListViewOpened = false
    self.Filter_List:SetVisibility(UIConst.VisibilityOp["Collapsed"])
end

function WBP_Rouge_FilterSort_C:SetFirstSelectedItem()
    local RougeLikeDifficulty = EMCache:Get("RougeLikeDifficulty",true)
    for Index,DifficultyId in pairs(self.UnLockedDifficulty) do
        if DifficultyId == RougeLikeDifficulty then
            self:ChangeSelectedItem(Index-1)
            return
        end
    end
end

function WBP_Rouge_FilterSort_C:ListOpenBtnClicked()
    self:PlayAnimation(self.Click)
    self.Filter_List:SetVisibility(UIConst.VisibilityOp["HitTestInvisible"])
    AudioManager(self):PlayUISound(self, "event:/ui/roguelike/difficulty_click", nil, nil)
    if(self.SortBy_List)then
        if(self.IsListViewOpened)then
            self:PlayListOutnAnim()
            --EventManager:FireEvent(EventID.OnMenuClose)
            self.IsListViewOpened = false
        else
            --EventManager:FireEvent(EventID.OnMenuClose,true)
            self:PlayListInAnim()
            self.IsListViewOpened = true
        end
    else
        self.Filter_List:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

function WBP_Rouge_FilterSort_C:Init(SortBy_List, SortType)
    self.CurSortType = SortType or CommonConst.DESC
    self.SortBy_List = SortBy_List or {}
    self.IsListViewOpened = false
    self.SelectedItem = nil
    self.IsListInAnimPlaying = false
    self.IsListOutAnimPlaying = false
    self.Filter_List:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    self.List:ClearListItems()
    self.Text_Filterlist:SetText("")
    if(SortBy_List and #SortBy_List > 0)then
        self.Text_Filterlist:SetText(GText(SortBy_List[1]))
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        Obj.Text = GText(SortBy_List[1])
        Obj.IsSelected = true
        Obj.Mode = "Single"
        Obj.Index = 1
        Obj.Owner = self
        self.SelectedItem = Obj
        self.List:AddItem(Obj)
        for i=2,#SortBy_List do
            Obj = NewObject(UIUtils.GetCommonItemContentClass())
            Obj.Text = GText(SortBy_List[i])
            Obj.Mode = "Single"
            Obj.Index = i
            Obj.Owner = self
            Obj.IsSelected = false
            self.List:AddItem(Obj)
        end
        self.Btn_Filter_List:SetVisibility(UIConst.VisibilityOp["Visible"])
    else
        self.Btn_Filter_List:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
    --self:UpdateSortInfos()
    if(self.CurSortType == CommonConst.ASC)then
        self.Sort_Type:SetRenderTransformAngle(0)
    else
        self.Sort_Type:SetRenderTransformAngle(180)
    end
end

function WBP_Rouge_FilterSort_C:OnBtn_Filter_List_Pressed() 
    self:StopAnimation(self.Hover)
    self:PlayAnimation(self.Press)
end

function WBP_Rouge_FilterSort_C:OnBtn_Filter_List_Hovered() 
    self:StopAnimation(self.Normal)
    self:PlayAnimation(self.Hover)
end

function WBP_Rouge_FilterSort_C:OnBtn_Filter_List_Unhovered()
    self:StopAnimation(self.Hover)
    self:PlayAnimation(self.Normal)
end

function WBP_Rouge_FilterSort_C:OnBtn_SortType_Hovered()
    self:PlayAnimation(self.Hover_Btn)
end

function WBP_Rouge_FilterSort_C:OnBtn_SortType_Unhovered()
    self:PlayAnimationReverse(self.Hover_Btn)
end

function WBP_Rouge_FilterSort_C:PlayListInAnim()
    --播放ListItem逐个进入的动画
    self:StopListOutAnim()
    self.IsListInAnimPlaying = true
    local WarpFunc = function()
        self.Filter_List:SetRenderOpacity(1)
        self:StopAnimation(self.List_Out)
        self:PlayAnimation(self.List_In)
        local Entrys = self.List:GetDisplayedEntryWidgets()
        local Len = Entrys:Length()
        local TotalTime = 0
        for i=Len,1,-1 do
            local func = function()
                Entrys[i]:SetRenderOpacity(1)
                Entrys[i]:PlayInAnim()
            end
            Entrys[i]:SetRenderOpacity(0)
            TotalTime = TotalTime + 0.02
            self:AddTimer(TotalTime,func,false,0,"ListEntryInAnim"..i)
        end
        local EndTime = self.List_In:GetEndTime()
        TotalTime = math.max(EndTime,TotalTime)
        if(TotalTime > 0)then
            TotalTime = TotalTime + Entrys[1]:GetInAnimTime()
            local EndListInAnimPlaying = function()
                self.IsListInAnimPlaying = false
            end
            self:AddTimer(TotalTime,EndListInAnimPlaying,false,0,"ListInAnimPlaying")
        else
            self.IsListInAnimPlaying = false
        end
    end
    --本帧不能得到Entrys的数量，所以等待一帧
    self:AddTimer(0.01,WarpFunc,false,0,"List_In")
    self.Filter_List:SetRenderOpacity(0)
    self.Filter_List:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
end

function WBP_Rouge_FilterSort_C:StopListInAnim()
    self:RemoveTimer("List_In")
    self:RemoveTimer("ListInAnimPlaying")
    local Entrys = self.List:GetDisplayedEntryWidgets()
    local Len = Entrys:Length()
    for i=Len,1,-1 do
        self:RemoveTimer("ListEntryInAnim"..i)
    end
end

function WBP_Rouge_FilterSort_C:PlayListOutnAnim()
    self:StopListInAnim()
    self.IsListOutAnimPlaying = true
    local Entrys = self.List:GetDisplayedEntryWidgets()
    local Len = Entrys:Length()
    if(Len <= 0)then
        self.IsListOutAnimPlaying = false
        self.Filter_List:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        return
    end
    local TotalTime = 0.01
    -- for i=1,Len do
    --     local func = function()
    --         Entrys[i]:PlayOutAnim()
    --     end
    --     TotalTime = TotalTime + 0.01
    --     self:AddTimer(TotalTime,func,false,0,"List"..Idx.."EntryOutAnim"..i)
    -- end
    TotalTime = TotalTime + Entrys[1]:GetOutAnimTime()
    if(self.List_Out)then
        local EndTime = self.List_Out:GetEndTime()
        local TimeToPlayFilterOutAnim = TotalTime - EndTime
        if(TimeToPlayFilterOutAnim > 0)then
            local func = function()
                self:StopAnimation(self.List_In)
                self:PlayAnimation(self.List_Out)
            end
            self:AddTimer(TimeToPlayFilterOutAnim,func,false,0,"ListBG_OutAnim")
        else
            self:PlayAnimation(self.List_Out)
            TotalTime = EndTime
        end
    end
    local ListOutAnimPlayEnd = function()
        self.IsListOutAnimPlaying = false
        self.Filter_List:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
    self:AddTimer(TotalTime,ListOutAnimPlayEnd,false,0,"ListOutAnimPlaying")
end

function WBP_Rouge_FilterSort_C:StopListOutAnim()
    self:RemoveTimer("ListOutAnimPlaying")
    self:RemoveTimer("ListBG_OutAnim")
    local Entrys = self.List:GetDisplayedEntryWidgets()
    local Len = Entrys:Length()
    for i=1,Len do
        self:AddTimer("ListEntryOutAnim"..i)
    end
end

function WBP_Rouge_FilterSort_C:OnListClosed()
    if(self.SortBy_List)then
        if(self.IsListViewOpened)then
            self:PlayListOutnAnim()
            self.IsListViewOpened = false
        end
    else
        self.Filter_List:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

function WBP_Rouge_FilterSort_C:GetSortInfos()
    if self.SelectedItem and self.SelectedItem.Index then
        return self.SelectedItem.Index
    else
        return nil
    end
end

return WBP_Rouge_FilterSort_C