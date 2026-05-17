require "UnLua"

---@class SelectItemToSubListComponent
local Component = {}

-- 这个需要继承的自己实现
-- 生成此Index自身拥有的Item
-- function Component:InitFilteredContents(Index)
-- end

-- 这个也需要自己实现，用来判断是否已经达到最大数量了
-- function Component:PreviewLevelMax()
--     return false
-- end

local LongPressTimerInterval = 0.1
local LongPressThreshold = 0.8
local SpeedUpInterval = 1.0  -- 加速间隔：1秒
local MaxSpeedMultiplier = 16  -- 最大加速倍率：16倍
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"

function Component:InitListView(LeftList, RightList, SortList)
    self.SortList = SortList
    if self.SortList then
        self.SortList:Init(self, {"UI_SHOWNPC_LIST_CONT_1"}, CommonConst.DESC)
        self.SortList:BindEventOnSelectionsChanged(self,self.OnSortListSelectionsChanged)
        self.SortList:BindEventOnSortTypeChanged(self,self.OnSortTypeChanged)
    end
    self.LeftList = LeftList
    self.RightList = RightList
end

---排序依据选项选中时
function Component:OnSortListSelectionsChanged()
    local SortByIdx, SortType = self.SortList:GetSortInfos()
    self:SortSelectiveList(self.FilteredContents,SortByIdx, SortType)
    self:FillListItem()
end

---升序降序改变时
function Component:OnSortTypeChanged()
    local SortByIdx, SortType = self.SortList:GetSortInfos()
    self:SortSelectiveList(self.FilteredContents,SortByIdx, SortType)
    self:FillListItem()
end

function Component:SortSelectiveList(InOutContentArray, SortBy, SortType)
    self.SortType = SortType
    if not self.SortFunc then
        self.SortFunc = {}
        self.SortFunc[1] =  function(P1, P2)
            if P1.Rarity ~= P2.Rarity then return CommonUtils:Compare(P1.Rarity, P2.Rarity, self.SortType) end
            return CommonUtils:Compare(P2.Id, P1.Id, self.SortType)
        end
    end
    table.sort(InOutContentArray, self.SortFunc[SortBy])
    self.SortType = nil
end


function Component:FillListItem()
    self.LeftList:ClearListItems()
    self.LastSelectedListContent = nil
    for i, value in ipairs(self.FilteredContents) do
        value.IndexInList= i - 1
        if(value.IsSelect)then
            self.LastSelectedListContent = value
        end
        self.LeftList:AddItem(value)
    end
    if(not self.LastSelectedListContent)then
        self.LastSelectedListContent = self.FilteredContents[1]
    end
    self.LeftList:RequestFillEmptyContent()
    if #self.FilteredContents == 0 then
        self.LeftList:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Panel_Empty_Search:SetVisibility(UIConst.VisibilityOp.Visible)
    else
        self.LeftList:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Panel_Empty_Search:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function Component:CreateSlotContent(i)
    local EmptyContent = NewObject(UIUtils.GetCommonItemContentClass())
    EmptyContent.Index = i
    self:ReInitSlotContent(EmptyContent)
    return EmptyContent
end

function Component:ReInitSlotContent(Content)
    Content.ParentUI = self
    if Content.Index<=self.PreConsumeCount then
        Content.NotInteractive = false
        Content.OnMouseButtonDownEvent = {Obj = self, Callback = function()
            if Content.UnitId then
                self:OnMinusStart(Content)
                Content.ParentUI:OnRightListSelectedChanged(Content)
            end
        end}
        local function HandleMinusRelease()
            if Content.UnitId then
                if not self.MinusPressed then
                    self:OnItemMinusBtnClick(Content)
                else
                    self:OnMinusEnd()
                end
            else
                if self.MinusPressed then
                    --播放通用材料点击音效
                    AudioManager(self):PlayItemSound(self, self.MinusContent.UnitId, "Click", self.MinusContent.ItemType)
                else
                    --播放未装配格子点击音效
                    AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
                    self:OnExpandList(true, false)
                    Content.ParentUI:OnRightListSelectedChanged(Content)
                end
            end
            self.MinusPressed = false
        end
        Content.OnMouseButtonUpEvents = {Obj = self, Callback = function()
            HandleMinusRelease()
        end}
        Content.OnMouseEnterEvent = {Obj = self, Callback = function()
            self.CurrentWidget = Content.SelfWidget
        end}
        Content.OnMouseLeaveEvent = {Obj = self, Callback = function()
            self:OnMinusEnd()
            self.CurrentWidget = nil
        end}
    else
        Content.NotInteractive = true
        Content.OnMouseButtonUpEvents = nil
    end
end

function Component:OnRightListSelectedChanged(SelectedContent)
    if not SelectedContent then
        DebugPrint("JLY SelectedContent is nil")
    else
        DebugPrint("JLY SelectedContent not nil" )
    end
    local DisplayedWidgets = self.RightList:GetDisplayedEntryWidgets()
    for _, Widget in pairs(DisplayedWidgets) do
        if Widget.Content ~= SelectedContent then
            Widget.Content.IsSelect = false
            Widget.Item:PlayAnimation(Widget.Item.Normal)
        end
    end
    if SelectedContent then
        SelectedContent.IsSelect = true
        if SelectedContent.SelfWidget and SelectedContent.SelfWidget.Item then
            SelectedContent.SelfWidget.Item:PlayAnimation(SelectedContent.SelfWidget.Item.Click)
        end
    end
end

function Component:InitPreConsumeList()
    self.SelectedCount = 0                    -- 已选择的数量
    self.PreConsumeList = {}                  -- 预消耗列表
    self.ListWidgets = {}                     -- 列表控件数组
    self.MinusPressed = false                 -- 是否正在长按
    self.MinusPressTime = 0                   -- 长按时间
    self.MinusContent = nil                   -- 长按的内容
    self.MinusTimer = nil                     -- 长按定时器
    self.CurrentWidget = nil                  -- 当前控件
    
    -- 创建5个空槽位
    for i = 1, self.PreConsumeCount do
        local EmptyContent = self:CreateSlotContent(i)
        table.insert(self.PreConsumeList, EmptyContent)
    end
    
    -- 同步到ListView显示
    self.RightList:ClearListItems()
    for i,Content in pairs(self.PreConsumeList) do
        Content.Index = i
        Content.ParentUI = self
        self.RightList:AddItem(Content)
    end
end

function Component:CopyItemToConsumeList(AddContent, Count)
    self.SelectedCount = self.SelectedCount + 1  -- 选择数量+1
    
    -- 重新构建整个列表
    self.PreConsumeList = {}
    local PreConsumeArray = self.ListWidgets
    
    local Avatar = GWorld:GetAvatar()
    for i, Widget in pairs(PreConsumeArray) do
        local Content = Widget.Content
        if i == self.SelectedCount then
            -- 通用资源（如经验材料）
            local Target = Avatar.Resources[AddContent.Id]
            assert(Target and Target.Count>0, "通用材料不存在或已耗尽")
            Content = ArmoryUtils:NewResourceItemContent(Target)
            Content.Count = Count or 1
            Content.Index = i
            self:ReInitSlotContent(Content)
        end
        table.insert(self.PreConsumeList, Content)
    end
    self:UpdatePreConsumeList(self.PreConsumeList)
end

function Component:OnItemMinusBtnClick(DelContent)
    if not DelContent then return end
    
    self.PreConsumeList = {}
    local PreConsumeArray = self.ListWidgets
    
    for i, Widget in pairs(PreConsumeArray) do
        local Content = Widget.Content
        if Content.Index == DelContent.Index then
            goto continue  -- 跳过要删除的物品
        end
        if Content.Index > DelContent.Index then
            Content.Index = Content.Index - 1  -- 重新编号
            self:ReInitSlotContent(Content)
        end
        table.insert(self.PreConsumeList, Content)
        ::continue::
    end
    
    -- 补充空槽位
    for i = #self.PreConsumeList +1, self.PreConsumeCount do
        local EmptyContent = self:CreateSlotContent(i)
        EmptyContent.bEmpty = true
        table.insert(self.PreConsumeList, EmptyContent)
    end
    
    self.SelectedCount = self.SelectedCount - 1
    self:UpdatePreConsumeList(self.PreConsumeList)
end

function Component:OnMinusStart(Content, Index)
    if not self.MinusPressed then
        self.MinusPressed = true
        self.MinusPressTime = 0
        self.MinusContent = Content or self:GetCurrentContent()
        if Index then
            self.MinusContent = self.ListWidgets[Index].Content
        end
        self.MinusTimer = self:AddTimer(LongPressTimerInterval, self.UpdateMinus, true, 0, nil, true)
        self:RemoveCurrentContent()
    end
end

function Component:OnMinusEnd()
    if self.MinusPressed then
        self.MinusPressed = false
        if(self.MinusTimer)then
            self:RemoveTimer(self.MinusTimer)
            self.MinusTimer = nil
        end
    end
end

function Component:UpdateMinus()
    if self.MinusPressed then
        self.MinusPressTime = self.MinusPressTime + LongPressTimerInterval
        if self.MinusPressTime >= LongPressThreshold then
            self:RemoveCurrentContent()
        end
    end
end

function Component:RemoveCurrentContent()
    local Content = self.MinusContent
    if not Content or not Content.UnitId then return end
    
    Content.Count = Content.Count - 1
    self:SetResourceCount(Content.UnitId, Content.Count)
    if Content.Count > 0 then
        Content.SelfWidget:SetCount(Content.Count)
    else
        self:OnItemMinusBtnClick(Content)
        if(self.MinusTimer)then
            self:RemoveTimer(self.MinusTimer)
            self.MinusTimer = nil
        end
    end
    self:UpdateAddProgress()
end

function Component:GetCurrentContent()
    return self.CurrentWidget and self.CurrentWidget.Content
end

function Component:SetResourceCount(ResourceId, Cnt)
    local Content = self.ContentMap[ResourceId]
    if not Content or not Content.SelfWidget then
        Content.SelectNeedCount = Cnt > 0 and Cnt or nil
        return
    end
    local Widget = Content.SelfWidget
    Widget:SetSelectNum(Cnt>0 and Cnt or nil)
end

function Component:ClearResourceCnt()
    for Uuid, _ in pairs(self.ContentMap or {}) do
        self:SetResourceCount(Uuid, 0)
    end
end

function Component:UpdatePreConsumeList(PreConsumeList)
    local PreConsumeArray = self.ListWidgets
    for i,Widget in pairs(PreConsumeArray) do
        local NewContent = PreConsumeList[i]
        NewContent.bAllUseAsyncLoadWidget = false
        Widget:Init(NewContent)
        self:OnPreConsumeListGenerated(NewContent, Widget)
        end
    if self.CurrentWidget then
        self.CurrentWidget.Item:PlayAnimation(self.CurrentWidget.Item.Hover)
    end
    self:UpdateAutoBtnText()
end

function Component:UpdateAutoBtnText()
    local Content = nil
    if #self.ListWidgets ~= 0 then
        Content = self.ListWidgets[1].Content
    end
    if Content and Content.Count and Content.Count > 0 then
        self.Btn_Auto:SetText(GText("UI_WeaponStrength_Clear"))
        self.Btn_Delivery:ForbidBtn(false)
    else
        self.Btn_Auto:SetText(self.Btn_AutoText)
        self.Btn_Delivery:ForbidBtn(true)
    end
end

function Component:OnPreConsumeListGenerated(Content, Widget)
    ---@type TArray<WBP_Com_item_Universal_L_C>
    local Index = Content.Index
    self.ListWidgets[Index] = Widget
    local LastWidget = Index>1 and self.ListWidgets[Index-1] or nil
    if Content.Index <= self.PreConsumeCount then
        if LastWidget then
            LastWidget:SetNavigationRuleExplicit(EUINavigation.Right, Widget)
            Widget:SetNavigationRuleExplicit(EUINavigation.Left, LastWidget)
        else
            Widget:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
        end
        Widget:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    else
        Widget:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
        Widget:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    end
    if Content.UnitId then
        Widget:SetAdd(false)
        Widget:SetItemMinus(true)
        local MinusBtn = Widget.MinusWidget and Widget.MinusWidget.Btn_Minus
        if not MinusBtn then return end
        Widget.MinusWidget.Btn_Minus:BindEventOnPressed(self, function()
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_minus", nil, nil)
            self:OnMinusStart(nil, Index)
        end)
        Widget.MinusWidget.Btn_Minus:BindEventOnReleased(self, self.OnMinusEnd)
    else
        Widget:SetAdd(not Content.NotInteractive)
        Widget:SetItemMinus(false)
    end
end

function Component:ClearListItems()
    self.PreConsumeList = {}
    -- 重置所有槽位为空
    for i= self.PreConsumeCount, 1, -1 do 
        local EmptyContent = self:CreateSlotContent(self.PreConsumeCount-i+1)
        table.insert(self.PreConsumeList, EmptyContent)
    end
    
    self:UpdatePreConsumeList(self.PreConsumeList)
    self:ClearResourceCnt()
    self.SelectedCount = 0
end

function Component:OnPlusStart(Content)
    if not self.PlusPressed then
        self.PlusPressed = true
        self.PlusPressTime = 0
        self.PlusContent = Content
        self.PlusSpeedMultiplier = 1  -- 初始加速倍率为1
        self.PlusLastSpeedUpTime = 0  -- 上次加速的时间点
        self.PlusTimer = self:AddTimer(LongPressTimerInterval, self.UpdatePlus, true, 0, nil, true)
        self:AddResource()
    end
end

function Component:OnPlusEnd()
    if self.PlusPressed then
        if(self.PlusTimer)then
            self:RemoveTimer(self.PlusTimer)
            self.PlusTimer = nil
        end
        self.PlusPressed = false
        self.PlusSpeedMultiplier = 1  -- 重置加速倍率
        self.PlusLastSpeedUpTime = 0
    end
end

function Component:UpdatePlus()
    if self.PlusPressed then
        self.PlusPressTime = self.PlusPressTime + LongPressTimerInterval
        
        -- 检查是否需要加速（每1秒加速一次）
        if self.PlusPressTime >= LongPressThreshold then
            local timeSinceLastSpeedUp = self.PlusPressTime - self.PlusLastSpeedUpTime
            if timeSinceLastSpeedUp >= SpeedUpInterval then
                -- 加速：倍率x2，但不超过上限
                if self.PlusSpeedMultiplier < MaxSpeedMultiplier then
                    self.PlusSpeedMultiplier = math.min(self.PlusSpeedMultiplier * 2, MaxSpeedMultiplier)
                    self.PlusLastSpeedUpTime = self.PlusPressTime
                end
            end
            self:AddResource()
        end
    end
end

function Component:FindSelectedContent(Id)
    local PreConsumeArray = self.ListWidgets
    for i, Widget in pairs(PreConsumeArray) do
        local Content = Widget.Content
        if Content.UnitId and Content.UnitId == Id then
            return Content
        end
    end
    return nil
end

function Component:GetConsumeContents()
    local PreConsumeArray = self.ListWidgets
    local ConsumeContents = {}
    for i, Widget in pairs(PreConsumeArray) do
        local Content = Widget.Content
        table.insert(ConsumeContents,Content)
    end
    return ConsumeContents
end

function Component:AddResource()
    local PlusContent = self.PlusContent
    if not PlusContent then
        return
    end
    
    -- 获取当前加速倍率，如果没有则默认为1
    local speedMultiplier = self.PlusSpeedMultiplier or 1
    
    local CurContent = self:FindSelectedContent(PlusContent.Id)
    local emptyIndex = nil
    local ConsumeContents = self:GetConsumeContents()
    for i = 1, self.PreConsumeCount do
        if (not ConsumeContents[i].UnitId) then
            emptyIndex = i
            break
        end
    end
    
    if (not CurContent) and emptyIndex then
        -- 首次添加，只添加1个
        self:CopyItemToConsumeList(PlusContent)
        self:SetResourceCount(PlusContent.Id, 1)
    elseif (not CurContent) and not emptyIndex then
        return
    else
        if self:PreviewLevelMax(PlusContent.Id) then
            if not self.bAutoSelecting then
                UIManager(self):ShowUITip(UIConst.Tip_CommonToast,GText("Max_Level_Achieved"),1.5)
            end
            if(self.PlusTimer)then
                self:RemoveTimer(self.PlusTimer)
                self.PlusTimer = nil
            end
            return
        end
        
        -- 计算剩余可添加数量（基于资源总数）
        local remainingCount = PlusContent.Count - CurContent.Count
        if remainingCount <= 0 then
            return
        end
        
        -- 检查是否需要考虑 NeedNum 限制
        local needNumLimit = nil
        if self.NeedNum and self.NeedNum[PlusContent.Id] then
            local NeedNum = self.NeedNum[PlusContent.Id]
            -- 第三阶段且 SelectedIndex == 3 时，可以无限提交，不需要考虑 NeedNum 限制
            local isThirdStageUnlimited = (self.CurStep == 3 and self.SelectedIndex == 3)
            if not isThirdStageUnlimited then
                -- 计算基于 NeedNum 的剩余可添加数量
                needNumLimit = NeedNum - CurContent.Count
                if needNumLimit < 0 then
                    needNumLimit = 0
                end
            end
        end
        
        -- 综合两个限制：资源总数限制和 NeedNum 限制
        if needNumLimit ~= nil then
            remainingCount = math.min(remainingCount, needNumLimit)
        end
        
        if remainingCount <= 0 then
            return
        end
        
        -- 根据加速倍率计算本次要添加的数量，但不能超过剩余数量
        local addCount = math.min(speedMultiplier, remainingCount)
        
        -- 添加资源
        CurContent.Count = CurContent.Count + addCount
        CurContent.SelfWidget:SetCount(CurContent.Count)
        self:SetResourceCount(CurContent.UnitId, CurContent.Count)
        
        -- 如果已经达到上限，停止长按
        -- 需要同时检查资源总数和 NeedNum 限制
        local reachedMax = false
        if CurContent.Count >= PlusContent.Count then
            reachedMax = true
        elseif needNumLimit ~= nil and CurContent.Count >= (self.NeedNum[PlusContent.Id] or 0) then
            reachedMax = true
        end
        
        if reachedMax then
            if(self.PlusTimer)then
                self:RemoveTimer(self.PlusTimer)
                self.PlusTimer = nil
            end
            self.PlusPressed = false
            self.PlusSpeedMultiplier = 1
            self.PlusLastSpeedUpTime = 0
        end
    end
    self:UpdateAddProgress()
end


---显隐详情
function Component:ShowItemDetails(bShow, Content)
    self.bItemDetailsShowed = bShow
    if(bShow)then
        if(self.ItemDetailsContent ~= Content)then
            if (not self.ItemDetailsContent or self.ItemDetailsContent.Type ~= Content.Type) then
                self:RefreshItemDetailWidget(Content)
            end
            self.ItemDetailsWidget:RefreshItemInfo(Content, true)
            self.ItemDetailsWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            self.ItemDetailsWidget:StopAnimation(self.ItemDetailsWidget.Out)
            self.ItemDetailsWidget:PlayAnimation(self.ItemDetailsWidget.In)
        end
    elseif self.ItemDetailsWidget then
        self.ItemDetailsWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.ItemDetailsWidget:StopAnimation(self.ItemDetailsWidget.In)
        self.ItemDetailsWidget:PlayAnimation(self.ItemDetailsWidget.Out)
    end
    self.ItemDetailsContent = Content
    if (self.CurInputDeviceType == ECommonInputType.Gamepad) then
        self.ItemDetailsWidget.Panel_Controller:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function Component:RefreshItemDetailWidget(Content)
    if self.ItemDetailsWidget then
        self.ItemDetailsWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.ItemDetailsWidget = self:CreateWidgetNew("ItemDetailsMain")
    self.Pos_Tips:AddChild(self.ItemDetailsWidget)
    self.ItemDetailsWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

return Component