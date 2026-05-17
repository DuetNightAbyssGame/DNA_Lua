

require "UnLua"
local M={}

local OnlineActionController = require "BluePrints.UI.WBP.BattleOnlineAction.OnlineActionController"
local OnlineActionModel = require "BluePrints.UI.WBP.BattleOnlineAction.OnlineActionModel"
local OnlineActionCommon=require "BluePrints.UI.WBP.BattleOnlineAction.OnlineActionCommon"
function M:InitBaseView(OpenReason)
    if not OpenReason then
        OpenReason=1
    end
    self.OpenReason=OpenReason

    self:StaticInit()

    self:BindEvent()

    self:DynamicInit()

    self:PlayAnimation(self.In)

    self:SetFocus()
end

function M:NotifyTick(InDeltaTime)
    if not IsValid(self) then return end
    self:ClearDeadItem()

    local DisplayedWidgets=self.List_Invite:GetDisplayedEntryWidgets()
    for i=1,DisplayedWidgets:Length() do
        local WidgetRef=DisplayedWidgets:GetRef(i)
        WidgetRef:NotifyTick()
    end
    -- if self.OpenReason == 1 then
    --     self:OnApplicationsTabSwitchOn()
    -- else
    --     self:OnInvitationsTabSwitchOn()
    -- end
end

--清理已经超时了的申请和邀请
-- WBP_Battle_OnlineActionBaseView: 清理过期项统一使用接口
function M:ClearDeadItem()
    local ItemsToRemove = {}
    local AllItems = self.List_Invite:GetListItems()
    if not AllItems then return end

    for i = 1, AllItems:Length() do
        local Item = AllItems:GetRef(i)
        if Item and Item.Content and (Item.Kind == 1 or Item.Kind == 3) and Item.Content.RemainTime <= 0 then
            table.insert(ItemsToRemove, Item)
        end
    end

    if #ItemsToRemove > 0 then
        local kind = self.OldTabID
        if self.Tab_OnlineAction and self.Tab_OnlineAction.GetCurrentTabInfo then
            local CurrentTabInfo = self.Tab_OnlineAction:GetCurrentTabInfo()
            if CurrentTabInfo then
                kind = CurrentTabInfo.TabId
            end
        end
        self:RemoveItemsAndAutoSwitch(ItemsToRemove, kind)
    end
end

-- function M:Tick(MyGeometry, InDeltaTime)
-- end

-- 静态初始化
function M:StaticInit()
    --self.BaseView:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
     -- CreateCommonKey({
--     KeyInfoList={
--         {
--             Type = "Text", 类型："Text"或" "Img"
--             Text = "Esc"   按键文本  KeyboardText.lua数据里的KeyText，找不到让策划配一个
--             ImgShortPath = "RightMouseButton", 按键短图片路径
--             ImgLongPath = "Texture2D'/Game/UI/UI_PNG/Common/Key/Icon_Mouse_Button.Icon_Mouse_Button'", 按键全图片路径
--         }, 如果有多个按键，按照顺序填写
--          
--     },
--     Desc = GText("UI_BACK"),    按键功能描述，没有别填
--     bLongPress = false     ,    是否长按，Button填，Show别填
-- }) 

    self.Text_Empty:SetText(GText("UI_RegionOnline_NoInvitation"))
    self.Text_Title:SetText(GText("UI_RegionOnline_CommonList"))
end
-- 事件绑定
function M:BindEvent()
    local ReturnClick=function()
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_return", "Click", nil)
        self:OnReturnKeyDown()
    end
    self.Btn_Close.btn_close.OnClicked:Add(self,ReturnClick)
    self.Tab_OnlineAction:BindEventOnTabSelected(self,self.OnTabSwitchOn)
end

-- 动态数据加载并更新
function M:DynamicInit()
    if self.OpenReason==1 then
        self.WS_Top:SetActiveWidgetIndex(0)
        self:InitTabs()
    else
        --self:InitTabs()  
        self.WS_Top:SetActiveWidgetIndex(1)
        self.Text_Title:SetText(GText("UI_RegionOnline_CommonList"))
        self:OnInvitationspageOpen()
    end
end
local ApplicationTab={
    TabKey="Applications",
    Text = GText("UI_RegionOnline_ApplyList") ,
    TabId = 1, 
    --TipsData = {TipsName , Icon }--上方提示内容
}
local NearbyPlayersTab={
    TabKey="NearbyPlayers",
    Text = GText("UI_RegionOnline_InviteNearby") ,
    TabId = 2, 
    --TipsData = {TipsName , Icon }--上方提示内容
}
local InvitationTab={
    TabKey="Invitations",
    Text = GText("UI_RegionOnline_InviteList") ,
    TabId = 3, 
    --TipsData = {TipsName , Icon }--上方提示内容
}

function M:InitTabs()
    local Tabs = {}
    if self.OpenReason == 1 or not self.OpenReason then
        Tabs = {ApplicationTab, NearbyPlayersTab,InvitationTab}
        -- if OnlineActionModel:HaveOtherInvitation() then
        --     table.insert(Tabs, InvitationTab)
        -- end
    elseif self.OpenReason == 2 then
        Tabs = {InvitationTab}
    else
        ScreenPrint("InitTabs: Unknown OpenReason 错误的打开原因，找不到对应Tab数据" .. tostring(self.OpenReason))
        Tabs = {InvitationTab}
    end
    local IsMobile = CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile"
    local ConfigData = {
        --PlatformName = "PC",
         LeftKey =  "Q",
         RightKey =  "E",
        -- LeftKey = "NotShow" ,
        -- RightKey = "NotShow" ,
        LeftGamePadKey = "LeftShoulder",
        RightGamePadKey = "RightShoulder",
        ChildWidgetName = "",
        ChildWidgetBPPath = "/Game/UI/WBP/Battle/Widget/Online_Action/WBP_Battle_OnlineAction_TabItem.WBP_Battle_OnlineAction_TabItem",
        Tabs=Tabs,
        SoundFunc = function(self)
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_03", "OnlineActionTabBtnClick", nil)
        end
        -- HoverSoundFunc = function,  悬浮音效播放
        -- SoundFuncReceiver = Obj,    音效播放接收对象
    }

    if self.OpenReason == 1 and not OnlineActionModel:HaveOtherApply() then
        self.Tab_OnlineAction:Init(ConfigData)
        -- 初始化后隐藏最后一个子项的分隔线
        self:HideLastTabItemLine()
        self.Tab_OnlineAction:SelectTab(2)
        --主人打开且没有申请
    elseif  self.OpenReason == 1 and OnlineActionModel:HaveOtherApply() then
        self.Tab_OnlineAction:Init(ConfigData)
        -- 初始化后隐藏最后一个子项的分隔线
        self:HideLastTabItemLine()
        self.Tab_OnlineAction:SelectTab(1)
        --打开且有申请
    elseif self.OpenReason == 2 then
        self:OnInvitationspageOpen()
    end
end

-- 仅用于联机动作页：隐藏 Tab 列表中最后一个子项的分隔线
function M:HideLastTabItemLine()
    local tab = self.Tab_OnlineAction
    if not tab or not tab.List_Tab then return end
    local count = tab.List_Tab:GetChildrenCount() or 0
    if count <= 0 then return end
    local last = tab.List_Tab:GetChildAt(count - 1)
    if not last then return end

    -- 针对联机动作的TabItem：按常见命名尝试隐藏分隔线控件
    if last.Line then
        last.Line:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end


--切换成ListView
function M:SwitchListView()
    self.WS_State:SetActiveWidgetIndex(0)
end

--ListView没有Item时,显示这个
function M:SwitchEmptyBG(Kind)
    if Kind ==1 then
        self.Text_Empty:SetText(GText("UI_RegionOnline_NoApplication"))
    elseif Kind ==2 then
        self.Text_Empty:SetText(GText("UI_RegionOnline_NoPlayer"))
    elseif Kind ==3 then
        self.Text_Empty:SetText(GText("UI_RegionOnline_NoInvitation"))
    end
    self.WS_State:SetActiveWidgetIndex(1)
end

function M:OnTabSwitchOn(TabWidget,TabInfo)
    if TabInfo.TabKey == "Applications" then
        self.TabKind=1
        self:SwitchListView(TabWidget,TabInfo)
        self:OnApplicationsTabSwitchOn(TabWidget,TabInfo)
    elseif TabInfo.TabKey == "NearbyPlayers" then
        self.TabKind=2
        self:SwitchEmptyBG(TabWidget,TabInfo)
        self:OnNearbyPlayersTabSwitchOn(TabWidget,TabInfo)
    elseif TabInfo.TabKey == "Invitations" then
        self.TabKind=3
        self:SwitchEmptyBG(TabWidget,TabInfo)
        self:OnInvitationsTabSwitchOn(TabWidget,TabInfo)
    end
end


-- 生成列表项 Kind 列表项类型 1申请，2附近玩家，3邀请
-- WBP_Battle_OnlineActionBaseView: 统一改造列表项的回调
function M:GenerateListItem(Kind,needAni)
    local Data, Cache
    local List = self.List_Invite
    -- 保持模型中“越晚收到越靠后”的插入顺序
    -- OnlineActionModel:SortByRemainTime(Kind, true)
    if Kind == 1 then
        Data = OnlineActionModel:GetApplyInfos()
        Cache = self.ApplyInfosCache
    elseif Kind == 2 then
        Data = OnlineActionModel:GetNearbyPlayerInfos()
        Cache = self.NearbyPlayersCache
    elseif Kind == 3 then
        Data = OnlineActionModel:GetInvitationInfos()
        Cache = self.InvitationInfosCache
    end

    if Data and next(Data) then
        self:SwitchListView()
        List:ClearListItems()

        if Kind == 2 then
            -- 附近玩家保持原顺序
            local MaxPlayerNum=OnlineActionModel:GetMaxPlayerNum()
            for index, ItemData in ipairs(Data) do
                local NewItem = NewObject(UIUtils.GetCommonItemContentClass())
                NewItem.Parent=self
                NewItem.Content = ItemData
                Cache:Add(NewItem)
                NewItem.Parent=self
                NewItem.CallbackObj=self
                NewItem.Kind=Kind
                NewItem.NeedAni=needAni
                NewItem.InvitationCallback=function (CallbackObj, Content, Index)
                    OnlineActionController:SendInvitation(Content, Index)
                end
                NewItem.MaxPlayerNum=MaxPlayerNum
                List:AddItem(NewItem)
                ::continue::
            end
        else
            -- 需求需要剩余时间越长的在上面，每次sort有点卡。申请/邀请倒序遍历：最新在尾部，倒序显示最新靠前
            for i = #Data, 1, -1 do
                local ItemData = Data[i]
                if Kind == 1 then
                    self:AddNewApplicationItem(ItemData, needAni)
                elseif Kind == 3 then
                    self:AddNewInvitationItem(ItemData, needAni)
                end
            end
        end
        if self.IsGamePad then
            self:FocusFirstItem()
        end
    else
        self:SwitchEmptyBG(Kind)
    end
end

function M:RemoveSameSeatApplications(InteractiveId)
    local itemsToRemove = {}
    local allListItems = self.List_Invite and self.List_Invite:GetListItems()
    if allListItems then
        for i = allListItems:Length(), 1, -1 do
            local Item = allListItems:GetRef(i)
            if Item and Item.Content.InteractiveId == InteractiveId then
                table.insert(itemsToRemove, Item)
            end
        end
    end
    self:RemoveItemsAndAutoSwitch(itemsToRemove, 1)
end
-- WBP_Battle_OnlineActionBaseView: 新增统一移除接口
function M:IsListHaveItem()
    local List = self.List_Invite
    return List and List:GetNumItems() > 0
end
--封装后的移除list的接口，如果移除后列表为空
function M:RemoveItemsAndAutoSwitch(Items, Kind)
    local List = self.List_Invite
    if not List then return end

    if Items then
        if  #Items >1  then --说明是uobj，只是一个Item
            for _, item in ipairs(Items) do
                if item then
                    List:RemoveItem(item)
                end
            end
        else
            List:RemoveItem(Items[1] or Items )
        end
    end

    if not self:IsListHaveItem() then
        local kindToUse = Kind
        if not kindToUse then
            local CurrentTabInfo = self.Tab_OnlineAction and self.Tab_OnlineAction.GetCurrentTabInfo and self.Tab_OnlineAction:GetCurrentTabInfo()
            if CurrentTabInfo and CurrentTabInfo.TabId then
                kindToUse = CurrentTabInfo.TabId
            else
                kindToUse = self.TabKind
            end
        end
        if kindToUse then
            self:SwitchEmptyBG(kindToUse)
        end
    end
end

function M:FocusFirstItem()
    self:AddTimer(0.01, function()
        if self:IsListHaveItem() then
            local Item = self.List_Invite:GetItemAt(0)
            self.List_Invite:BP_NavigateToItem(Item)
            self.List_Invite:BP_SetItemSelection(Item, true)
        else
            self:SetFocus()
        end
    end)
end

function M:OnTabSwitchOnBase(TabWidget,TabInfo)
    local TabId = TabInfo.TabId
    if   self.OldTabID and self.OldTabID<TabId then
        self:PlayAnimation(self.List_Change_R)
    elseif self.OldTabID and self.OldTabID>TabId then
        self:PlayAnimation(self.List_Change_L)
    end
    if  self.Key_Refuse then
        self.Key_Refuse:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    if self.Btn_Refuse then
        self.Btn_Refuse:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    self.OldTabID = TabId
    self.List_Invite:ClearListItems()

end
--申请列表Tab被选中
function M:OnApplicationsTabSwitchOn(TabWidget,TabInfo)
    --self:SwitchListView()
    self:OnTabSwitchOnBase(TabWidget,TabInfo)
    self:GenerateListItem(1)
end

-- 邀请附近Tab被选中
function M:OnNearbyPlayersTabSwitchOn(TabWidget,TabInfo)
    --self:SwitchEmptyBG()
    self:OnTabSwitchOnBase(TabWidget,TabInfo)
    self:GenerateListItem(2)
    if self.Key_Refuse then
        self.Key_Refuse:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.Btn_Refuse then
        self.Btn_Refuse:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

-- 邀请列表Tab被选中
function M:OnInvitationsTabSwitchOn(TabWidget,TabInfo)
    --self:SwitchEmptyBG()
    self:OnTabSwitchOnBase(TabWidget,TabInfo) 
    self:GenerateListItem(3)

end

--作为路人视角打开时对应
function M:OnInvitationspageOpen()
    self:GenerateListItem(3)
end


--向左切换Tab被选中
function M:OnLeftTabKeyDown()
    if self.Tab_OnlineAction.CurrentTab and self.Tab_OnlineAction.CurrentTab - 1 >= 1 then
        self.Tab_OnlineAction:TabToLeft()
    end
end

--向右切换Tab被选中
function M:OnRightTabKeyDown()
    if self.Tab_OnlineAction.CurrentTab and self.Tab_OnlineAction.CurrentTab + 1 <= #self.Tab_OnlineAction.Tabs then
        self.Tab_OnlineAction:TabToRight()
    end
end

function M:OnReceivedNewInvitation(InvitationInfo)
    if self.TabKind==3 or self.OpenReason==2 then
        local NewItem = self:AddNewInvitationItem(InvitationInfo,true)
        self.WS_State:SetActiveWidgetIndex(0)
        self:AddTimer(0.1, function()
            NewItem.NeedAni=false --如果Add后立刻出现在列表里，则需要动画，反之说明Add时列表满了不会立刻出现，则不需要动画
        end)
    end
    
end

function M:AddNewInvitationItem(InvitationInfo, NeedAni)
    local Kind = 3  
    local List = self.List_Invite
    local Cache = self.InvitationInfosCache
    local NewItem = NewObject(UIUtils.GetCommonItemContentClass())
    NewItem.Content = InvitationInfo
    NewItem.Parent = self
    Cache:Add(NewItem)
    NewItem.Parent = self
    NewItem.CallbackObj = self
    NewItem.Kind = Kind
    NewItem.NeedAni = NeedAni
    NewItem.AcceptCallback = function(CallbackObj, Content)
        OnlineActionController:SendAcceptInvitation(Content)
        self:ClearListAndSwitchEmpty(3)
        self:OnReturnKeyDown()
    end
    NewItem.RejectCallback = function(CallbackObj, Content)
        OnlineActionController:SendRejectInvitation(Content)
        self:RemoveItemsAndAutoSwitch(NewItem, 3)
    end
    List:AddItem(NewItem)
    return NewItem
end

function M:OnReceivedNewApplication(ApplicationInfo)
    if self.TabKind==1  then
        local NewItem = self:AddNewApplicationItem(ApplicationInfo,true)
        self.WS_State:SetActiveWidgetIndex(0)
        self:AddTimer(0.1, function()
            NewItem.NeedAni=false --如果Add后立刻出现在列表里，则需要动画，反之说明Add时列表满了不会立刻出现，则不需要动画
        end)
    end
end

function M:AddNewApplicationItem(ApplicationInfo, NeedAni)
    local Kind = 1
    local List = self.List_Invite
    local Cache = self.ApplyInfosCache
    local NewItem = NewObject(UIUtils.GetCommonItemContentClass())
    NewItem.Content = ApplicationInfo
    NewItem.Parent = self
    Cache:Add(NewItem)
    NewItem.Parent = self
    NewItem.CallbackObj = self
    NewItem.Kind = Kind
    NewItem.NeedAni = NeedAni
    NewItem.AcceptCallback = function(CallbackObj, Content)
        OnlineActionController:SendAcceptApplication(Content)
        self:ClearListAndSwitchEmpty(3)
    end
    NewItem.RejectCallback = function(CallbackObj, Content)
        OnlineActionController:SendRejectApplication(Content)
        self:RemoveItemsAndAutoSwitch(NewItem, 3)
    end
    List:AddItem(NewItem)
    return NewItem
end

function M:OnRefreshAllKeyDown()
    DebugPrint("OnRefreshAllKeyDown")
    if self.OpenReason==2 then
        self:GenerateListItem(3,true)
    end
    if self.TabKind==1 then
        self:GenerateListItem(1,true)
    elseif self.TabKind==2 then
        OnlineActionModel:FindPlayerAround()
        self:GenerateListItem(2,true)
    elseif self.TabKind==3 then
        self:GenerateListItem(3,true)
    end
end

function M:ClearListAndSwitchEmpty(kind)
    local List = self.List_Invite
    if not List then return end
    List:ClearListItems()
    local kindToUse = kind or (self.TabKind or 3)
    self:SwitchEmptyBG(kindToUse)
end

function M:OnRejectAllKeyDown()
    DebugPrint("OnRejectAllKeyDown")
    if self.TabKind==3 or self.OpenReason==2 then
        OnlineActionController:RejectAllInvitations()
        self:ClearListAndSwitchEmpty(3)
    elseif self.TabKind==1 then
        OnlineActionController:RejectAllApplications()
        self:ClearListAndSwitchEmpty(1)
    end
end

function M:OnReturnKeyDown()
    self:PlayAnimation(self.Out)
    self:UnbindAllFromAnimationFinished(self.Out)
    self:BindToAnimationFinished(self.Out, function()OnlineActionController:CloseView(self)
    self:MyClose()
    end)
end

function M:MyClose()
    -- TODO 界面关闭逻辑
    self.Super.Close(self)
end
return M