--
-- DESCRIPTION
-- 称号内容选择列表
-- @COMPANY **
-- @AUTHOR 叶轲
-- @DATE ${date} ${time}
-- 循环列表写吐了
--[[
--目前的循环列表会在头尾插入一段数量等于容器可显示widget数量的widget，可当滚动接近首段/末尾时瞬间切换
offset来实现循环效果，如实际数据20个，列表可显示8个widget，则一共会有36个widget
--offset0对应的是实际数据的第1个，中间item是实际数据(realindex)的第4个，对应的list里的index是3
--offset10对应的是数据的第11个，中间item是填充数据的第14个，也就是(realindex)的6，对应的list里的index是13
想要停在(realindex)的11 需要设置offset为15因为，15对应露出的第一个虚假idx是16，而16+3对应中间的19，19-8正好是11
]]
require "UnLua"

---@type WBP_PersonalInfo_Title_TitleContent_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C", "BluePrints.Common.TimerMgr"})
local Unhandled = UE4.UWidgetBlueprintLibrary.Unhandled()
local Handled = UE4.UWidgetBlueprintLibrary.Handled()

local EnableLog = false -- 是否开启日志
local ScreenPrint=DebugPrint --注释掉以开启调试
-- M._components = {"BluePrints.UI.WBP.PersonInfo.Base.PersonInfoEntryBaseView"}
---仅初始化lua变量时使用，千万不要有控件操作！！
function M:Initialize()
    self.OriginalPreItemCount = 0 -- 
    self.OriginalSuffixItemCount = 0 -- 

    self.FullFillCount = 0 -- 一屏可显示项数，计算居中偏移量用
    self.CenterOffset = 0 -- 居中偏移量

    self.SelectPrefixTitleItem = nil -- 选中的称号前缀Item
    self.SelectSuffixTitleItem = nil -- 选中的称号后缀Item

    self.SuffixTitleContents = nil -- 真正Item的数量表
    self.PrefixTitleContents = nil

    self.LoopStartIdx = nil -- 循环开始的索引
    self.LoopEndIdx = nil -- 循环结束的索引

    self.AnalogControlProgress = 0
    self.IsFocusPrefix = true

    self.MinObjCount = 16-- 最小的obj数量，

    self.AnalogControlSpeed = self.AnalogControlSpeed or 10 -- 用于控制手柄摇杆滚动速度，蓝图已声明
    self.AnalogControlProgress = 0 -- 用于控制手柄摇杆滚动的进度条
end
function M:Construct()
    self:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    self:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    self:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    self.AnalogControlCd = 0.2
    self.List01 = self.List_Title01
    self.List02 = self.List_Title02
    if CommonConst.SystemLanguage == CommonConst.SystemLanguages.FR then
        self.List01 = self.List_Title02
        self.List02 = self.List_Title01
    end
    self:SetFocus()
end
function M:InitBaseView()
    -- 读取拥有的称号
    local Avatar = GWorld:GetAvatar()
    local PrefixTitles = {}
    self.PrefixTitles = PrefixTitles
    local SuffixTitles = {}
    self.SuffixTitles = SuffixTitles
    local AllTitles = Avatar.Titles
    self.UsedPrefixTitleID = Avatar.TitleBefore
    self.UsedSuffixTitleID = Avatar.TitleAfter
    self.UsedPrefixTitle = nil
    self.UsedSuffixTitle = nil
    for index, value in pairs(AllTitles) do
        if DataMgr.Title[index] then
            local TitleData = DataMgr.Title[index]
            local TitleContent = {
                Name = TitleData.Name,
                TitleID = TitleData.TitleID
            }
            -- for i=1,5 do
            if TitleData.IfSuffix then
                table.insert(SuffixTitles, TitleContent)
            else
                table.insert(PrefixTitles, TitleContent)
            end
            -- end
        end
        -- body
    end
    table.sort(PrefixTitles, function(a, b)
        return a.TitleID < b.TitleID
    end)
    table.sort(SuffixTitles, function(a, b)
        return a.TitleID < b.TitleID
    end)
    -- 把称号转换成Item
    local PrefixTitleContents = {}
    local SuffixTitleContents = {}
    self.SuffixTitleContents = SuffixTitleContents
    self.PrefixTitleContents = PrefixTitleContents

    local ItemContent = 0 -- 当前的循环列表实现会多个Item使用一个Obj,而两个widget使用同一个obj会出错，因而Obj少了会出错，所以强行生成几个，根本解决方案待思考
    while (ItemContent < self.MinObjCount) do
        local EmptyTitle1 = NewObject(UIUtils.GetCommonItemContentClass())
        EmptyTitle1.Name = "-"
        EmptyTitle1.TitleID = -1
        EmptyTitle1.RealIndex = #PrefixTitleContents + 1
        if self.UsedPrefixTitleID == -1 and self.UsedPrefixTitle == nil then
            self.UsedPrefixTitle = EmptyTitle1
        end
        self.List01:AddItem(EmptyTitle1)

        table.insert(PrefixTitleContents, EmptyTitle1)

        for index, value in pairs(PrefixTitles) do
            -- body
            local PrefixTitle = NewObject(UIUtils.GetCommonItemContentClass())
            PrefixTitle.Name = value.Name
            PrefixTitle.TitleID = value.TitleID
            PrefixTitle.RealIndex = #PrefixTitleContents + 1
            self.List01:AddItem(PrefixTitle)
            table.insert(PrefixTitleContents, PrefixTitle)
            if self.UsedPrefixTitleID == value.TitleID and self.UsedPrefixTitle == nil then
                self.UsedPrefixTitle = PrefixTitle
            end

        end
        ItemContent = #PrefixTitleContents

    end
    ItemContent = 0
    while (ItemContent < self.MinObjCount) do
        local EmptyTitle2 = NewObject(UIUtils.GetCommonItemContentClass())
        EmptyTitle2.Name = "-"
        EmptyTitle2.TitleID = -1
        EmptyTitle2.RealIndex = 1
        if self.UsedSuffixTitleID == -1 and self.UsedSuffixTitle == nil then
            self.UsedSuffixTitle = EmptyTitle2
        end
        self.List02:AddItem(EmptyTitle2)
        table.insert(SuffixTitleContents, EmptyTitle2)
        for index, value in pairs(SuffixTitles) do
            -- body
            -- for i = 1, 20 do
            local SuffixTitle = NewObject(UIUtils.GetCommonItemContentClass())
            SuffixTitle.Name = value.Name
            SuffixTitle.TitleID = value.TitleID
            SuffixTitle.RealIndex = #SuffixTitleContents + 1
            self.List02:AddItem(SuffixTitle)
            table.insert(SuffixTitleContents, SuffixTitle)
            if self.UsedSuffixTitleID == value.TitleID and self.UsedSuffixTitle == nil then
                self.UsedSuffixTitle = SuffixTitle
            end
            -- end
        end
        ItemContent = #SuffixTitleContents
    end

    self.OriginalPreItemCount = #PrefixTitleContents
    self.OriginalSuffixItemCount = #SuffixTitleContents

    -- 初始化List
    local fakeidx = 0
    self.List01.OnCreateEmptyContent:Bind(self, function(self)
        fakeidx = fakeidx + 1
        local obj = NewObject(UIUtils.GetCommonItemContentClass())
        ----ScreenPrint("fakeidx:" .. fakeidx)
        obj.Name = fakeidx + 1
        return obj
    end)
    self.List02.OnCreateEmptyContent:Bind(self, function(self)
        return NewObject(UIUtils.GetCommonItemContentClass())
    end)
    self.List01:SetIsEnableScrollAnimation(true)
    self.List02:SetIsEnableScrollAnimation(true)
    self.List01:RequestLoopListInit()
    self.List02:RequestLoopListInit()

    self:BindListViewEvents()

    -- 延迟初始化布局参数
    self:AddTimer(0.1, function()
        self:CalculateLayoutParams()
        self:InitSelect()
    end, nil, nil, nil, true)
    if EnableLog then
    self:AddTimer(1, function()
        local currentOffset = self.List01:GetScrollOffset()
        ScreenPrint("位置报时:currentOffset:" .. currentOffset .. "后最  " .. self.List02:GetScrollOffset())
    end, true, nil, nil, true)
end

end 
function M:InitSelect(bSmoothScroll)
    local Item = self:GetAutoSelectTitle(true)
    self:ScrollToItem(Item, true, bSmoothScroll)
    --ScreenPrint("------------前缀初始化:ItemOffset:" .. " 选中的Item" .. ((Item and Item.Name) or " 空 "))
    self:SelectTitle(Item, true)
    local Item2 = self:GetAutoSelectTitle(false)
    --ScreenPrint("------------后缀初始化:ItemOffset:" .. " 选中的Item" .. ((Item2 and Item2.Name) or " 空 "))
    self:ScrollToItem(Item2, false, bSmoothScroll)
    self:SelectTitle(Item2, false)
    self.bHaveInit = true
end

function M:GetAutoSelectTitle(bIsPrefix)
    if bIsPrefix then
        if self.UsedPrefixTitleID and self.UsedPrefixTitle then
            return self.UsedPrefixTitle
        else
            local currentOffset = self.List01:GetScrollOffset()
            local NewItem = self:ItemOffset2SelectContent(currentOffset, true)
            return NewItem
        end
    else
        if self.UsedSuffixTitleID and self.UsedSuffixTitle then
            return self.UsedSuffixTitle
        else
            local currentOffset = self.List02:GetScrollOffset()
            local NewItem = self:ItemOffset2SelectContent(currentOffset, false)
            return NewItem
        end
    end
end

-- function M:Tick(MyGeometry, InDeltaTime)
-- end

-- function M:Destruct()
-- end

function M:BindListViewEvents()
    self.List01.OnListViewScrolled:Add(self, self.OnPrefixTitleScrolled)
    self.List01.OnMouseButtonUp:Add(self, self.OnPrefixTitleMouseUp)
    self.List01.OnMouseButtonDown:Add(self, self.OnPrefixTitleMouseDown)
    self.List02.OnListViewScrolled:Add(self, self.OnSuffixTitleScrolled)
    self.List02.OnMouseButtonUp:Add(self, self.OnSuffixTitleMouseUp)
    self.List02.OnMouseButtonDown:Add(self, self.OnSuffixTitleMouseDown)
end

function M:OnPrefixTitleMouseDown()
    ScreenPrint("------------前缀标题鼠标按下")
    self.bIsPrefixTitleDown = true
end
function M:OnSuffixTitleMouseDown()
    ScreenPrint("------------后缀标题鼠标按下")
    self.bIsSuffixTitleDown = true
end
function M:CalculateLayoutParams()
    --计算屏幕中显示者的Widget数量
    self.FullFillCount = self.List01:GetFullFillItemCount()
    DebugPrint("称号系统：FullFillCount:" .. self.FullFillCount)
    -- 计算垂直居中偏移（项数的一半）
    self.CenterOffset = (self.FullFillCount-1) / 2
    DebugPrint("称号系统：CenterOffset:" .. self.CenterOffset)

    self.LoopStartIdx = self.FullFillCount--8
    self.LoopEndIdx = self.FullFillCount + self.OriginalPreItemCount

    DebugPrint("称号系统：LoopStartIdx:".. self.LoopStartIdx.. " LoopEndIdx:".. self.LoopEndIdx)
    DebugPrint("   称号系统OriginalPreItemCount:".. self.OriginalPreItemCount.. " OriginalSuffixItemCount:".. self.OriginalSuffixItemCount)

end

-- 滚动事件处理
function M:OnPrefixTitleScrolled(ItemOffset, DistanceRemaining)
    if not self.bHaveInit then
        return
    end
    if self.LastPreListOffSet and math.abs(ItemOffset-self.LastPreListOffSet)<0.001 and not self.bIsPrefixTitleDown then
        self:EndScroll(true, function()
            self:SetToClosestItem(true)
        end)
    end
    self.LastPreListOffSet=ItemOffset
    ScreenPrint("-------------滚动中:ItemOffset:" .. ItemOffset .. " DistanceRemaining:" .. DistanceRemaining)
    self:ChangeSelectPrefixTitle()
end
-- 滚动事件处理
function M:OnSuffixTitleScrolled(ItemOffset, DistanceRemaining)
    ScreenPrint("-------------滚动中:ItemOffset:" .. ItemOffset .. " DistanceRemaining:" .. DistanceRemaining)
    if not self.bHaveInit then
        return
    end
        if self.LastSufListOffSet and math.abs(ItemOffset-self.LastSufListOffSet)<0.001 and not self.bIsSuffixTitleDown then
        self:EndScroll(false, function()
            self:SetToClosestItem(false)
        end)
    end
    self.LastSufListOffSet=ItemOffset
    -- 更新选中项
    self:ChangeSelectSuffixTitle()
end

function M:ChangeSelectPrefixTitle(Aim)
    local currentOffset = Aim or self.List01:GetScrollOffset()
    local NewItem = self:ItemOffset2SelectContent(currentOffset, true)

    if NewItem == self.SelectPrefixTitleItem then
        return
    end
    ScreenPrint("------------切换了:ItemOffset:" .. currentOffset .. "旧的Item " ..
                     ((self.SelectPrefixTitleItem and self.SelectPrefixTitleItem.Name) or " 空 ") .. " 新的Item" ..
                     NewItem.Name)

    self:SelectTitle(NewItem, true)

end
function M:ChangeSelectSuffixTitle()
    local currentOffset = self.List02:GetScrollOffset()
    local NewItem = self:ItemOffset2SelectContent(currentOffset, false)
    if NewItem == self.SelectSuffixTitleItem then
        return
    end
    if NewItem == nil then
        return
    end
    ScreenPrint("------------切换了:ItemOffset:" .. currentOffset .."旧的Item ".. ((self.SelectSuffixTitleItem and self.SelectSuffixTitleItem.Name) or " 空 ")  .. " 新的Item" .. NewItem.Name )
    self:SelectTitle(NewItem, false)

end
function M:CancelSelectTitle(Item)
    if Item then
        Item.IsSelected = false
    end
    if Item and Item.UI then
         ScreenPrint("------------取消选中了 " .. (Item and Item.Name)..Item.UI.Text_Title:GetText() or " 空 " .. (Item and Item.ReallyIdx) or
                         " 空id ")
        Item.UI.Text_Title:SetRenderOpacity(0.4)
    end
end
function M:ScrollandSelectTitle(Item, bIsPrefix)
    local RealIdx = Item.RealIndex
    local list
    if bIsPrefix then
        list = self.List01
    else
        list = self.List02
    end
    list:ScrollIndexIntoView(math.floor(self.FullFillCount - self.CenterOffset + RealIdx + 0.5))
    self:Addtimer(1, function()
        self:SelectTitle(Item, bIsPrefix)
    end, nil, nil, nil, true)
end
function M:SelectTitle(Item, bIsPrefix)
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("Title")
    UIUtils.TrySubReddotCacheDetailNumber(Item.TitleID,"Title")
    self:AddTimer(0.05, function()
        self:ReallySelectTitle(Item, bIsPrefix)
end, nil, nil, bIsPrefix and "前缀" or "后缀", true)
end

function M:ReallySelectTitle(Item, bIsPrefix)
    if bIsPrefix then
        if Item==self.SelectPrefixTitleItem then
            return
        end
    else
        if Item==self.SelectSuffixTitleItem then
            return
        end
    end
    if Item.UI then
        local oldItem = bIsPrefix and self.SelectPrefixTitleItem or self.SelectSuffixTitleItem
        ScreenPrint("------------真正切换了 " .. (bIsPrefix and "前缀  " or "后缀  ") .. "旧的Item " ..
        ((oldItem and oldItem.Name) or " 空 ")..
        ((oldItem and oldItem.UI and oldItem.UI.Text_Title:GetText() ) or " 空 ") .. " 新的Item" ..
        Item.Name..Item.UI.Text_Title:GetText())
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/roll_list_change",nil, nil)
    if bIsPrefix then
        self:CancelSelectTitle(self.SelectPrefixTitleItem)
        self.SelectPrefixTitleItem = Item
        self.SelectPrefixID = self.SelectPrefixTitleItem.TitleID
        self.SelectPrefixTitleItem.IsSelected = true
    else
        self:CancelSelectTitle(self.SelectSuffixTitleItem)
        self.SelectSuffixTitleItem = Item
        self.SelectSuffixID = self.SelectSuffixTitleItem.TitleID
        self.SelectSuffixTitleItem.IsSelected = true
    end
    if Item.UI then
        Item.UI.Text_Title:SetRenderOpacity(1)
    end

    self.FatherPage:OnTietleContentChange(self.SelectPrefixID, self.SelectSuffixID)

    --红点相关
    if Item.IsNew then
        Item.UI:SetNotNew()
        local list
        if bIsPrefix then
            list = self.List01
        else
            list = self.List02
        end
        local GetDisplayedEntryWidgets = list:GetDisplayedEntryWidgets()
        for index, value in pairs(GetDisplayedEntryWidgets) do
            -- body
            if value.Item and  value.Item.TitleID== Item.TitleID then
                value:SetNotNew()
            end
        end
    end
end
function M:OnSelectTitleChange()
    self.SelectSuffixID = self.SelectSuffixTitleItem.TitleID
    self.SelectPrefixID = self.SelectPrefixTitleItem.TitleID
end
function M:GetCurrentSelectTitle()
    self.UsedPrefixTitle=self.SelectPrefixTitleItem
    self.UsedSuffixTitle=self.SelectSuffixTitleItem
    --重置一下使用称号，防止切换tab后InitSelect()变成老称号
    return self.SelectPrefixID, self.SelectSuffixID
end
function M:ItemOffset2SelectContent(currentOffset, IsPrefix)

    local list = IsPrefix and self.List01 or self.List02
    local originalCount = IsPrefix and self.OriginalPreItemCount or self.OriginalSuffixItemCount

    -- 将滚动偏移四舍五入到最近整数
    local aimOffset = math.floor(currentOffset + 0.5)
    -- 映射到“居中”的列表索引（包含填充段）
    local centerListIdx = math.floor(aimOffset + self.CenterOffset + 0.5)
    -- 转成真实数据索引（1..N）
    local realIdx = centerListIdx - self.FullFillCount
    realIdx = ((realIdx - 1) % originalCount) + 1
    -- 补回填充段，拿到列表索引
    local listIdx = realIdx + self.FullFillCount

    return list:GetItemAt(listIdx)
end
-- 鼠标释放时定位到最近项
function M:OnPrefixTitleMouseUp()
    self.bIsPrefixTitleDown = false
    self:SetToClosestItem(true)
end
function M:OnSuffixTitleMouseUp()
    self.bIsSuffixTitleDown = false
    self:SetToClosestItem(false)
end

--- 滚动到指定项 
---@param Item any
---@param IsPrefix any
function M:ScrollToItem(Item, IsPrefix, bSmoothScroll)
    bSmoothScroll = bSmoothScroll== nil and true
    local List
    local OriginalItemCount
    if IsPrefix then
        List = self.List01
        OriginalItemCount = self.OriginalPreItemCount
    else
        List = self.List02
        OriginalItemCount = self.OriginalSuffixItemCount
    end

    local currentOffset = List:GetScrollOffset()
    -- 规范化当前偏移到安全区间
    if currentOffset < self.LoopStartIdx then
        currentOffset = currentOffset + OriginalItemCount
    elseif currentOffset > self.LoopEndIdx then
        currentOffset = currentOffset - OriginalItemCount
    end

    local CurrentIten
    if IsPrefix then
        CurrentIten = self.SelectPrefixTitleItem
    else
        CurrentIten = self.SelectSuffixTitleItem 
    end
    ScreenPrint((CurrentIten and CurrentIten.RealIndex) or (self.LoopStartIdx .. "ssss" .. Item.RealIndex))
    -- 计算目标中心偏移，并规范化到安全区间
    local function NormalizeOffset(offset)
        if  offset < self.LoopStartIdx then
            offset = offset + OriginalItemCount
        end
        if  offset > self.LoopEndIdx then
            offset = offset - OriginalItemCount
        end
        return offset
    end

    local targetOffset = math.floor(Item.RealIndex + self.CenterOffset)
    targetOffset = NormalizeOffset(targetOffset)
    currentOffset = NormalizeOffset(currentOffset)

    local delta = targetOffset - currentOffset
    local threshold = self.FullFillCount * 2 -- 现在滚动距离过大时选中项会有问题，所以这里设置一个阈值，当滚动距离超过阈值时，才会选中项

    if math.abs(delta) > threshold then
        -- 优先下滚；若下滚会越界，则改为上滚
        local safeMin, safeMax = self.LoopStartIdx + 1, self.LoopEndIdx - 1
        local downCutRaw = targetOffset - self.FullFillCount
        local upCutRaw   = targetOffset + self.FullFillCount
        local useUp = (downCutRaw < safeMin) or (downCutRaw > safeMax)

        local cutOffset = NormalizeOffset(useUp and upCutRaw or downCutRaw)
        -- 规范化后仍避免落到边界
        if cutOffset <= self.LoopStartIdx then
            cutOffset = self.LoopStartIdx + 1
        elseif cutOffset >= self.LoopEndIdx then
            cutOffset = self.LoopEndIdx - 1
        end

        if not bSmoothScroll then
            List:SetCurrentScrollOffset(cutOffset - 0.01) -- 误差驱动刷新
        else
            List:SetCurrentScrollOffset(cutOffset)
        end
        List:SetScrollOffset(targetOffset)
    else
        if not bSmoothScroll then
            List:SetCurrentScrollOffset(targetOffset - 0.01)
        end
        List:SetScrollOffset(targetOffset)
    end

    self:SelectTitle(Item, IsPrefix)
    DebugPrint("ScrollToItem" .. targetOffset .. "目前偏移" .. List:GetScrollOffset() .. "选中item的realidx" .. (CurrentIten and CurrentIten.RealIndex or self.LoopStartIdx))

end

function M:GetScrollIndexbyRealIdx(RealIdx, IsUp)
    if IsUp then
        return RealIdx - 3 + self.FullFillCount
    else
        return RealIdx + 3 + self.FullFillCount
    end
end
-- 定位到最近项
function M:SetToClosestItem(IsPrefix)
    local List
    local OriginalItemCount
    if IsPrefix then
        List = self.List01
        OriginalItemCount = self.OriginalPreItemCount
    else
        List = self.List02
        OriginalItemCount = self.OriginalSuffixItemCount
    end

    local currentOffset = List:GetScrollOffset()
    if currentOffset > OriginalItemCount then
        currentOffset = currentOffset - OriginalItemCount
    end
    ScreenPrint("-------------定位到最近项:currentOffset:" .. currentOffset)
    List:SetCurrentScrollOffset(currentOffset)
    -- if currentOffset<self.LoopStartIdx then--防止滚动动画异常，切换到安全范围，防止触发移动
    --     if IsPrefix then
    --         currentOffset=self.OriginalPreItemCount+currentOffset
    --     else
    --         currentOffset=self.OriginalSuffixItemCount+currentOffset
    --     end
    --     List:SetCurrentScrollOffset(currentOffset)
    -- end
    -- if currentOffset>self.LoopEndIdx then
    --     if IsPrefix then
    --         currentOffset=currentOffset-self.OriginalPreItemCount
    --     else
    --         currentOffset=currentOffset-self.OriginalSuffixItemCount
    --     end
    --     List:SetCurrentScrollOffset(currentOffset)
    -- end

    local aim = math.floor(currentOffset + 0.5)
    aim = math.floor(aim + 0.5)
    List:SetScrollOffset(aim)


end
function M:EndScroll(bIsPrefix,EndCallBack)
    local List
    if bIsPrefix then
        List = self.List01
    else
        List = self.List02
    end
    local aim = math.floor( List:GetScrollOffset() + 0.5)
        List:ScrollIndexIntoView(aim)
    self:AddTimer(0.01, function()
        --目前缺少停止滚动的函数，但是ScrollIndexIntoView能停止输入带来的滚动，所有调用一下在停止
        List:BP_CancelScrollIntoView()
        List:SetScrollOffset(aim)
    end)
    ScreenPrint("EndScroll:aim:" .. aim)
    if EndCallBack then
        EndCallBack(self)
    end
end
function M:SetItemToMiddle(item, bIsPrefix)
    local CurrentItem
    if bIsPrefix then
        CurrentItem = self.SelectPrefixTitleItem
    else
        CurrentItem = self.SelectSuffixTitleItem
    end
    if item.RealIndex > (CurrentItem.RealIndex or self.LoopStartIdx)  then
        self:ScrollDownToItem(CurrentItem, bIsPrefix)
    else
        self:ScrollUpToItem(CurrentItem, bIsPrefix)
    end
end
function M:RandomSelectTitle()
    -- 解决"number has no integer representation"错误：将种子转换为整数
    local now = os.clock()  -- 毫秒级时间（可能带小数）
    local seed = os.time() * 1000 + math.floor(now * 1000)  -- 转换为整数（毫秒级时间戳）
    math.randomseed(seed)
    math.random()  -- 丢弃第一个随机数，提高随机性

    -- 生成前缀随机索引
    local randomIdx1 = math.random(1, #self.PrefixTitles)
    local randomItem1 = self.List01:GetItemAt(randomIdx1 + self.FullFillCount)
    
    -- 生成后缀随机索引
    local randomIdx2 = math.random(1, #self.SuffixTitles)
    local randomItem2 = self.List02:GetItemAt(randomIdx2 + self.FullFillCount)
    
    ScreenPrint("随机选中了 ".. GText(randomItem1.Name).. " ".. GText(randomItem2.Name).. " time "..os.time())
    self:ScrollToItem(randomItem1, true)
    self:ScrollToItem(randomItem2, false)
end

---往上滚动一格
function M:ScrollUp(IsPrefix)
    -- --ScreenPrint("ScrollUp:IsPrefix:".. IsPrefix)
    local List, OriginalItemCount
    if IsPrefix then
        OriginalItemCount = self.OriginalPreItemCount
        List = self.List01
    else
        OriginalItemCount = self.OriginalSuffixItemCount
        List = self.List02
    end
    local currentOffset = List:GetScrollOffset()
    local AimOffset = currentOffset - 1

    if AimOffset < self.LoopStartIdx then
        currentOffset = currentOffset + OriginalItemCount
        AimOffset = AimOffset + OriginalItemCount
        List:SetCurrentScrollOffset(currentOffset)
    end
    List:SetCurrentScrollOffset(currentOffset)
    AimOffset = math.floor(AimOffset + 0.5)
    List:SetScrollOffset(AimOffset)
end
-- 往下滚动一格
function M:ScrollDown(IsPrefix)
    local List
    local originalItemCount
    if IsPrefix then
        List = self.List01
        originalItemCount = self.OriginalPreItemCount
    else
        List = self.List02
        originalItemCount = self.OriginalSuffixItemCount
    end
    local currentOffset = List:GetScrollOffset()
    if currentOffset > originalItemCount + 1 then
        --ScreenPrint("超出界限，无缝向上")
        currentOffset = currentOffset - originalItemCount
        List:SetCurrentScrollOffset(currentOffset)
    end
    local AimOffset = currentOffset + 1
    AimOffset = math.floor(AimOffset + 0.5)
    List:SetScrollOffset(AimOffset)
end
function M:OnGamePadUp()
end

function M:GamepadFocusLeft()
    if self.IsFocusPrefix == true then
        return
    end
    self.IsFocusPrefix = true
    self:PlayAnimation(self.GamePad_SelectL)
end
function M:GamepadFocusRight()
    if self.IsFocusPrefix == false then
        return
    end
    self.IsFocusPrefix = false
    self:PlayAnimation(self.GamePad_SelectR)
end
function M:IsFocusBeforeTitle()
    return self.IsFocusPrefix
end


function M:OnPreViewKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false

    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        self.IsGamePad = true
        IsEventHandled = self:OnPreviewGamePadDown(InKeyName)
    end
    return Unhandled
end
function M:OnPreviewGamePadDown(InKeyName)
    if InKeyName == Const.GamepadDPadLeft or InKeyName == Const.LeftStickLeft then
        self:GamepadFocusLeft()
        return true
    elseif InKeyName == Const.GamepadDPadRight or InKeyName == Const.LeftStickRight then
        self:GamepadFocusRight()
        return true
    elseif InKeyName == Const.GamepadDPadUp or InKeyName == Const.Gamepad_RightStick_Up then
        local IsPrefix = self:IsFocusBeforeTitle()
        self:ScrollUp(IsPrefix)

    elseif InKeyName == Const.GamepadDPadDown or InKeyName == Const.Gamepad_RightStick_Down then
        local IsPrefix = self:IsFocusBeforeTitle()
        self:ScrollDown(IsPrefix)
    end
    return Handled
end
function M:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        self.IsGamePad = true
        IsEventHandled = self:OnGamePadDown(InKeyName)
    else
        self.IsGamePad = false
    end
    IsEventHandled = false
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end
function M:OnGamePadDown(InKeyName)
    local IsEventHandled = false
    if (InKeyName == "Gamepad_DPad_Up") then
       -- self:OnGamePadUp()
    elseif (InKeyName == "Gamepad_DPad_Down") then
        --self:OnGamePadDown()
    elseif (InKeyName == UIConst.GamePadKey.FaceButtonBottom) then
        if self.FatherPage:IsCanChangeTitle() then
        self.FatherPage:OnComfirmBtnClick()
        end
    elseif (InKeyName == UIConst.GamePadKey.FaceButtonLeft) then
        if self.FatherPage:IsRandomBtnCanClick() then
        self.FatherPage:OnRandomBtnClick()
        end
    end
end
--处理摇杆输入
function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == UIConst.GamePadKey.LeftAnalogY) then
        local DeltaOffset = (-1) * UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
        --ScreenPrint("手柄=滚动中DeltaOffset:" .. DeltaOffset)
        self:OnAnalogAccumulate(DeltaOffset * self.AnalogControlSpeed)
    elseif (InKeyName == UIConst.GamePadKey.LeftAnalogX) then
        local DeltaOffset = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
        if DeltaOffset <= -1 then
            self:ClearnAnalogAccumulate()
            self:GamepadFocusLeft()
        elseif DeltaOffset >= 1 then
            self:ClearnAnalogAccumulate()
            self:GamepadFocusRight()
        end
    end
    return Unhandled
end
function M:OnAnalogSensitiveChange(Delta)
    if not self.IsInCD and 0 then
        if Delta > 0.7 then
            self:ScrollDown(self:IsFocusBeforeTitle())
        elseif Delta < -0.7 then
            self:ScrollUp(self:IsFocusBeforeTitle())
        end
        self.IsInCD = true
        self:AddTimer(self.AnalogControlCd or 0.1, function()
            self.IsInCD = false
        end, nil, nil, nil, true)
    else
         self:OnAnalogAccumulate(Delta)
    end

end
function M:OnAnalogAccumulate(Delta)
    self.AnalogControlProgress=self.AnalogControlProgress+Delta
    if  self.AnalogControlProgress<-100 then
        self.AnalogControlProgress=100+self.AnalogControlProgress
        self:ScrollUp(self:IsFocusBeforeTitle())
    elseif  self.AnalogControlProgress>100 then
        self.AnalogControlProgress=-100+self.AnalogControlProgress
        self:ScrollDown(self:IsFocusBeforeTitle())
    end
end
function M:ClearnAnalogAccumulate()
    self.AnalogControlProgress=0
end

function M:InitGamepadView()
    if self.IsFocusPrefix then
        self:PlayAnimation(self.GamePad_SelectL)
    else
        self:PlayAnimation(self.GamePad_SelectR)
    end
    self.Panel_GamepadVX:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)

end
function M:InitKeyboardView()
    self.Panel_GamepadVX:SetVisibility(UIConst.VisibilityOp.Collapsed)
end
function M:Destruct()
    self:CleanTimer()
end

return M
