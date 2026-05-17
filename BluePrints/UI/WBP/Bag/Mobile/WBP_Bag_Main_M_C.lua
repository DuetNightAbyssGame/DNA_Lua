--
-- DESCRIPTION
-- 包裹主界面
-- @COMPANY **
-- @AUTHOR ** hy
-- @DATE ${date} ${time}
--

require "UnLua"
local CommonUtils = require "Utils.CommonUtils"
local EMCache = require "EMCache.EMCache"
local StuffIconObject = require "BluePrints.UI.WBP.Bag.Widget.BagStuffIconObject"
local BagCommon = require "BluePrints.UI.WBP.Bag.BagCommon"

---@type WBP_Bag_Main_M_C
local WBP_Bag_Main_M_C = Class({"BluePrints.UI.BP_UIState_C", "BluePrints.UI.WBP.Bag.BagBase"})

WBP_Bag_Main_M_C._components = {
    "BluePrints.UI.UIComponent.CoroutineComponent",
    "BluePrints.UI.UI_PC.Common.LSFocusComp",
    "BluePrints.UI.WBP.Bag.Widget.BagMainPageView",
    "BluePrints.UI.UI_PC.Common.HorizontalListViewResizeComp"
}

function WBP_Bag_Main_M_C:Initialize(Initializer)
    self.Super.Initialize(self)
    self.OwnerPlayer = nil
    self.NpcId = BagCommon.NpcId                           -- 界面的NpcId
    self.NeedSelectStuffId = nil                           -- 用于进入界面是初始选中某个道具
    self.NeedSelectGridIndex = -1                          -- 需要选中的某个格子的索引
    self.CurTabId = nil                                    -- 当前的TabId
    self.IsNeedPlayNpcAnim = true                          -- 是否播放Npc退场动画
    self.BagCurState = BagCommon.AllBagState.NormalState   -- 当前背包的状态
    -- self.LastBagState = nil                             -- 背包上一个状态
    self.LoadMode = "FrameBlocking"
    --元素类型、元素显示名称
    self.ElmtTypes,self.Filters2 = UIUtils.GetAllElementTypes()
    self.IsLoadCompleted = false
    self.DesireSaleStuffObjList = {}    -- 所有期望出售道具的列表
    self.DesireResolveWeaponList = {}   -- 所有期望分解的武器列表
    self.AllTabInfo = {}                -- 所有的Tab信息
    self.CurSelectGridIndex = 1         -- 当前选中的Grid编号
    self.CurSelectStuffContent = nil    -- 当前选中的StuffContent
    self.CurFocusWidget = nil           -- 当前聚焦的Widget名称
    -- self.OriginalModsEquiped = {}       -- 原始Mod是否被装配
end

function WBP_Bag_Main_M_C:Construct()
    self.Super.Construct(self)
    self:InitMultiSelectWidget()
end

function WBP_Bag_Main_M_C:OnFocusReceived(MyGeometry, InFocusEvent)
    self:RefreshBottomKeyInfo()
    return WBP_Bag_Main_M_C.Super.OnFocusReceived(self,MyGeometry, InFocusEvent)
end

function WBP_Bag_Main_M_C:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", BagCommon.MainUIName, nil)
    self.CurTabId, self.NeedSelectStuffId, self.OwnerPlayer = ...
    self.OpenKey = CommonUtils:GetActionMappingKeyName("OpenBag")
    self.CurPlatformName = CommonUtils.GetDeviceTypeByPlatformName(self)

    if (self.OwnerPlayer == nil or not UE4.UKismetSystemLibrary.IsValid(self.OwnerPlayer)) then
        self.OwnerPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    end
    if (self.LoadMode == "FrameBlocking") then
        self:InitCoroutine(true)
    end
    self:SwitchToNpcCamera(true)
    -- local SpawnNpcConfig = DataMgr.SpawnNPC[self.NpcId]
    -- self:UpdateNpcDialogue(SpawnNpcConfig.StartDialogue)
    self:PlayInAnim()
end

function WBP_Bag_Main_M_C:ReceiveEnterState(StackAction)
    self.Super.ReceiveEnterState(self, StackAction)
    if (StackAction == 1) then
        -- 跳转回来的时候刷新一下内容
        self:UpdatePageInfoFromStackAction()
        -- 重新设置一下镜头
        --self:SwitchToNpcCamera()
    end
end

function WBP_Bag_Main_M_C:ReceiveExitState(StackAction)
    self.Super.ReceiveExitState(self, StackAction)
    if (StackAction == 0) then
        -- 跳转出去的时候进行一些操作
        local SellPageMainUI = UIManager(self):GetUI(BagCommon.BagStuffSelectUIName)
        if (SellPageMainUI ~= nil) then
            SellPageMainUI:PlayOutAnim()
        end
    end
end

function WBP_Bag_Main_M_C:SwitchToNpcCamera(bNpcCamera)
    if (bNpcCamera) then
        UIManager(self):SwitchUINpcCamera(bNpcCamera, BagCommon.MainUIName, self.NpcId, {IsHaveInOutAnim=self.IsNeedPlayNpcAnim})
    else
        UIManager(self):SwitchUINpcCamera(bNpcCamera, BagCommon.MainUIName, self.NpcId, 
        {bDestroyNpc=true, IsHaveInOutAnim=self.IsNeedPlayNpcAnim})
    end
end

function WBP_Bag_Main_M_C:Close()
    EMCache:Set(BagCommon.BagCacheDataName, self.CurTabId, true)
    local SellPageMainUI = UIManager(self):GetUIObj(BagCommon.BagStuffSelectUIName)
    if (SellPageMainUI ~= nil) then
        SellPageMainUI:Close()
    end
    self.List_Item:ClearListItems()
    self:CleanCoroutine()
    local PlayerCharacter=UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    if (IsValid(PlayerCharacter) and PlayerCharacter.IsInAir) then
        self.IsNeedPlayNpcAnim = false
    end
    self:SwitchToNpcCamera()
    self.Super.Close(self)
end

function WBP_Bag_Main_M_C:Destruct()
    self:HorizontalListViewResize_TearDown()
    ReddotManager.RemoveListener("Bag_Consume", self)
    self.Super.Destruct(self)
    if(self.GoToArmoryWhenClose)then
        local PlayerCharacter=UE4.UGameplayStatics.GetPlayerCharacter(self,0)
        if PlayerCharacter:CanEnterInteractive() then
            UIManager(self):LoadUINew('ArmoryMain')
        end
    end
end

function WBP_Bag_Main_M_C:Tick(MyGeometry, InDeltaTime)
    self.Overridden.Tick(self,MyGeometry,InDeltaTime)
    if (self.LoadMode ~= "FrameBlocking" or self.IsLoadCompleted == true) then
        return
    end
    self.IsLoadCompleted = self:StartCoroutine()
end

function WBP_Bag_Main_M_C:GetStuffServerData(StuffUnitId, StuffType, FishInfo)
    local PlayerAvatar = GWorld:GetAvatar()
    local StuffServerData = nil
    if (PlayerAvatar == nil) then
        return StuffServerData
    end
    if (StuffType == BagCommon.StuffType.Weapon) then
        StuffUnitId = self:GetStuffObjId(StuffUnitId)
        StuffServerData = PlayerAvatar.Weapons[StuffUnitId]
    elseif (StuffType == BagCommon.StuffType.Mod) then
        StuffUnitId = self:GetStuffObjId(StuffUnitId)
        StuffServerData = PlayerAvatar.Mods[StuffUnitId]
    elseif (StuffType == BagCommon.StuffType.Resource) then
        if (type(StuffUnitId) =="string") then
            if (string.find(StuffUnitId, "_")) then
                local StuffUnitIdList = Split(StuffUnitId, "_")
                StuffUnitId = math.tointeger(StuffUnitIdList[1])
            else
                StuffUnitId = math.tointeger(StuffUnitId)
            end
        end
        StuffServerData = PlayerAvatar.Resources[StuffUnitId]
        if StuffServerData and FishInfo then
            local FishSize2Count = BagCommon:GetFishSize2Count(StuffUnitId)
            if FishSize2Count and not Utils.IsEmptyTable(FishSize2Count) then
                local FishCount = FishSize2Count[FishInfo.Size]
                if FishCount and FishCount > 0 then
                    FishInfo = {Size = FishInfo.Size, Count = FishCount }
                    StuffServerData.FishInfo = FishInfo
                end
            end
        end
    elseif (StuffType == BagCommon.StuffType.Draft) then
        if (type(StuffUnitId) =="string") then
            StuffUnitId = math.tointeger(StuffUnitId)
        end
        StuffServerData = PlayerAvatar.Drafts[StuffUnitId]
    end
    return StuffServerData
end

function WBP_Bag_Main_M_C:InitTabInfo()
    for key, BagTabData in pairs(DataMgr.BagTab) do
        table.insert(self.AllTabInfo, {Text=GText(BagTabData.TabName), IconPath=BagTabData.Icon, TabId=key,
                        SortId=BagTabData.Sequence, ItemDefaultCapcity=BagTabData.TabDefaultSlot})
    end

    self.Tab_Bag:Init({Tabs=self.AllTabInfo, DynamicNode={"ResourceBar",},
                        StyleName="Image", OwnerPanel=self, TitleName=GText("MAIN_UI_BAG"), BackCallback=self.OnReturnKeyDown})
    self.Tab_Bag:BindEventOnTabSelected(self, self.TabBagItemClick)

    -- 消耗品的红点相关
    self:SetConsumeReddot()
    self:BindReddotTreeEvents()

    self.AllStuffData = {}       -- 所有物品数据列表
    self.FilteredStuffData = {} -- 筛选后的物品数据列表
    self:AddDelayFrameFunc(
        function()
            local BagSelectTabId = self.CurTabId
            if (BagSelectTabId == nil) then
                BagSelectTabId = EMCache:Get(BagCommon.BagCacheDataName, true)
            end
            if (self.BagCurState == BagCommon.AllBagState.NormalState) then
                if (BagSelectTabId ~= nil) then
                    self.Tab_Bag:SelectTabById(BagSelectTabId)
                else
                    self.Tab_Bag:SelectTabById(BagCommon.DefaultSelectTabId) 
                end 
            end
        end, 2, "BagInitTabInfo")
end

--region 背包消耗品红点相关
function WBP_Bag_Main_M_C:SetConsumeReddot()
    local BagConsumeNode = ReddotManager.GetTreeNode("Bag_Consume")
    if not BagConsumeNode then
        BagConsumeNode = ReddotManager.AddNodeEx("Bag_Consume", nil, 1)
    end
    local BagConsumeNodeDetails = BagConsumeNode.Cache.Detail
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local PlayerStuffs = Avatar.Resources
        for _, StuffServerData in pairs(PlayerStuffs) do
            -- 道具相关
            local StuffConfigData = StuffServerData:Data()
            if (StuffConfigData and StuffConfigData.MaterialClassify == BagCommon.ItemTypeToTabId.ConsumableItem) then
                local StuffData = StuffIconObject:GetItemStuffData(StuffServerData, self, self.OnListSelectStuffClicked)
                if BagConsumeNodeDetails[StuffData.StuffId] == nil then
                    ReddotManager.IncreaseLeafNodeCount("Bag_Consume", StuffData.StuffCount)
                    BagConsumeNodeDetails[StuffData.StuffId] = {
                        StuffCount = StuffData.StuffCount,
                        ClickedCount = 0,
                        ShowReddot = true
                    }
                else
                    if BagConsumeNodeDetails[StuffData.StuffId].StuffCount ~= StuffData.StuffCount then
                        ReddotManager.IncreaseLeafNodeCount("Bag_Consume", StuffData.StuffCount - BagConsumeNodeDetails[StuffData.StuffId].StuffCount)
                        BagConsumeNodeDetails[StuffData.StuffId].StuffCount = StuffData.StuffCount
                        BagConsumeNodeDetails[StuffData.StuffId].ShowReddot = true
                    end
                end
            end
        end
    end
end

function WBP_Bag_Main_M_C:BindReddotTreeEvents()
    ReddotManager.AddListener("Bag_Consume", self, function()
        self:UpdateTabReddot(BagCommon.ItemTypeToTabId.ConsumableItem)
    end)
end

function WBP_Bag_Main_M_C:UpdateTabReddot(TabIdx)
    local BagConsumeNode = ReddotManager.GetTreeNode("Bag_Consume")
    local BagConsumeNodeCount = BagConsumeNode.Count
    DebugPrint("Yihan@ UpdateTabReddot", BagConsumeNodeCount)
    self.Tab_Bag:ShowTabRedDotByTabId(TabIdx, false, BagConsumeNodeCount > 0)
end

-- endregion

function WBP_Bag_Main_M_C:OnSiftSelectionsChanged(SelectedItems, ItemDatas)
    -- 当筛选器的选择项发生变化时，更新 Mod 列表
    self.SelectedSiftItems = SelectedItems
    self.SiftItemDatas = ItemDatas
    self:RefreshStuffListItem(true)
	-- self:SetFocus_Lua()
end

function WBP_Bag_Main_M_C:FillPlayerDataByTypeInFrame(TabId, NeedDelayJump)
    local Avatar = GWorld:GetAvatar()
    if (Avatar == nil) then
        DebugPrint("Avatar is nil, Not Connect to Server")
        return
    end
    local PlayerStuffs, AllWeaponCount = nil, 0
    self.NeedSelectGridIndex = -1
    if (TabId == BagCommon.ItemTypeToTabId.MeleeWeapon or TabId == BagCommon.ItemTypeToTabId.RangedWeapon) then
        PlayerStuffs = Avatar.Weapons
    elseif (TabId == BagCommon.ItemTypeToTabId.Mod) then
        PlayerStuffs = Avatar.Mods
    elseif (TabId == BagCommon.ItemTypeToTabId.Draft) then
        PlayerStuffs = Avatar.Drafts
    else
        PlayerStuffs = Avatar.Resources
    end
    -- self.List_Item:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    if (PlayerStuffs ~= nil) then
        local ReasultStuffData, IsMultiData = {}, false
        for Id, StuffServerData in pairs(PlayerStuffs) do
            local StuffData = nil
            if (TabId == BagCommon.ItemTypeToTabId.MeleeWeapon or TabId == BagCommon.ItemTypeToTabId.RangedWeapon) then
                -- 武器相关
                AllWeaponCount = AllWeaponCount + 1
                if ((TabId == BagCommon.ItemTypeToTabId.MeleeWeapon and StuffServerData:HasTag("Melee")) or (TabId == BagCommon.ItemTypeToTabId.RangedWeapon and StuffServerData:HasTag("Ranged"))) then
                    StuffData = StuffIconObject:GetWeaponStuffData(StuffServerData, self,self.OnListSelectStuffClicked)
                end
                if (StuffData ~= nil) then
                    StuffData.IsEquipped = self:GetIsStuffIsEquiped(StuffData)
                end
            elseif (TabId == BagCommon.ItemTypeToTabId.Mod) then
                -- Mod相关
                StuffData = StuffIconObject:GetModStuffData(StuffServerData, self,self.OnListSelectStuffClicked) 
                if (StuffData ~= nil) then
                    StuffData.IsEquipped = self:GetIsStuffIsEquiped(StuffData)
                end
            elseif (TabId == BagCommon.ItemTypeToTabId.Draft) then
                -- 铸造图纸相关
                local DraftConfigData = StuffServerData:Data()
                if (DraftConfigData and DraftConfigData.ShowInBag and StuffServerData.Count > 0) then
                    StuffData = StuffIconObject:GetDraftsStuffData(StuffServerData, self, self.OnListSelectStuffClicked)
                end
            else
                -- 道具相关
                local StuffConfigData = StuffServerData:Data()
                if (StuffConfigData and StuffConfigData.MaterialClassify == TabId) then
                     if (TabId == BagCommon.ItemTypeToTabId.FishItem) 
                            and (BagCommon:IsFishResource(StuffConfigData.ResourceId)) then  -- 鱼类资源特殊处理
                        local FishSize2Count = BagCommon:GetFishSize2Count(StuffConfigData.ResourceId)
                        if FishSize2Count and not Utils.IsEmptyTable(FishSize2Count) then
                            StuffData = {}
                            IsMultiData = true
                            for Size, Count in pairs(FishSize2Count) do
                                StuffServerData.FishInfo = {Size = Size, Count = Count}
                                local TempStuffData = StuffIconObject:GetItemStuffData(StuffServerData, self, self.OnListSelectStuffClicked)
                                table.insert(StuffData, TempStuffData)
                            end
                        end
                    else
                        IsMultiData = false
                        StuffData = StuffIconObject:GetItemStuffData(StuffServerData, self, self.OnListSelectStuffClicked)
                    end
                end
            end
            if (StuffData ~= nil) then
                if (IsMultiData) then
                    for index, value in ipairs(StuffData) do
                        table.insert(ReasultStuffData, value)
                    end
                else
                    table.insert(ReasultStuffData, StuffData)
                end
            end
        end
        -- 保存所有物品数据
        self.AllStuffData = ReasultStuffData
        ReasultStuffData = self:FilterStuffDataBySift(self.AllStuffData)
        local FinalStuffData = {}
        if (#ReasultStuffData > 1) then
            FinalStuffData = self:SortAllItemsByType(ReasultStuffData)
        else
            FinalStuffData = ReasultStuffData
        end
        local BagItemCount = #self.AllStuffData
        self:RefreshItemViewByItemCount(BagItemCount, #FinalStuffData)

        if (#FinalStuffData > 0) then
            local ListViewSize = UIManager(self):GetWidgetRenderSize(self.OverLay_List)
            local EmptyGridCount, RowCount, ColCount = self:RefreshListViewEmptyGrid(self.List_Item, #FinalStuffData, ListViewSize)
            -- 添加加载完成回调
            local bNeedShowWarningDialog = AllWeaponCount >= BagCommon.MaxWeaponCount
            self:AddCompletedCallback(self.OnFrameLoadCompleted, self, false, RowCount * ColCount, bNeedShowWarningDialog)
            for Index = 1, EmptyGridCount, 1 do
                table.insert(FinalStuffData, {Uuid="", StuffType="EmptyGrid", StuffCount=0, StuffIcon=nil, ParentWidget=self})
            end
            for i, OrderStuffData in ipairs(FinalStuffData) do
                if (self.CurTabId == TabId) then
                    if (self.BagCurState == BagCommon.AllBagState.ChooseSaleState) then
                        OrderStuffData.IsSelect = false
                    elseif (self.NeedSelectStuffId ~= nil) then
                        OrderStuffData.IsSelect = OrderStuffData.Uuid == self.NeedSelectStuffId
                    -- else
                    --     OrderStuffData.IsSelect = i == 1
                    end
                    if (OrderStuffData.IsSelect) then
                        self.NeedSelectGridIndex = math.max(i - 1, 0)
                    end
                    OrderStuffData.GridIndex = i
                    OrderStuffData.AnimNameWithCreate = i <= RowCount * ColCount and "In" or nil
                    local StuffObj = StuffIconObject:CreateBagItemContent(OrderStuffData)

                    -- 背包消耗品红点相关
                    if self.CurTabId == BagCommon.ItemTypeToTabId.ConsumableItem and StuffObj and StuffObj.StuffId then
                        DebugPrint("Yihan@ FillPlayerDataByTypeInFrame:StuffObj.StuffId", StuffObj.StuffId)
                        local BagConsumeNodeDetails = ReddotManager.GetLeafNodeCacheDetail("Bag_Consume")
                        if BagConsumeNodeDetails[StuffObj.StuffId].ShowReddot then
                            StuffObj.RedDotType = UIConst.RedDotType.CommonRedDot
                        else
                            StuffObj.RedDotType = nil
                        end
                    else
                        StuffObj.RedDotType = nil
                    end

                    self.List_Item:AddItem(StuffObj)
                    -- if (i % RowCount == 0 and i % 2 == 0) then
                    if (i % 11 == 0) then
                        -- todo 不知道为什么这里改成固定的一个数tick占用的时间就少很多了，以后有空再研究一下
                        coroutine.yield()
                    end
                end
            end 
            -- 如果前面没有填充过空格子，则需要计算最后一行的空格子个数，并一次性填充
            if (EmptyGridCount <= 0) then
                EmptyGridCount = self:GetEmptyItemCountInLastLine(self.List_Item, #FinalStuffData)
                for Index = 1, EmptyGridCount, 1 do
                    local EmptyStuffData = {Uuid="", StuffType="EmptyGrid", StuffCount=0, StuffIcon=nil, ParentWidget=self}
                    EmptyStuffData.IsSelect = false
                    EmptyStuffData.GridIndex = Index + #FinalStuffData
                    EmptyStuffData.AnimNameWithCreate = Index <= RowCount * ColCount and "In" or nil
                    local StuffObj = StuffIconObject:CreateBagItemContent(EmptyStuffData)
                    self.List_Item:AddItem(StuffObj)
                end
            end
        else
            self:JumpToSelectItem(NeedDelayJump)
        end
    end
end

-- 分帧加载完成回调
function WBP_Bag_Main_M_C:OnFrameLoadCompleted(NeedDelayJump, AnimGridCount, bNeedShowWarningDialog)
    local AllItemCount = self.List_Item:GetNumItems()
    -- 策划希望只有第一次加载出来的Item有动画
    for i = 0, AllItemCount - 1, 1 do
        if (i > AnimGridCount) then
            break
        end
        local ItemObj = self.List_Item:GetItemAt(i)
        if (ItemObj) then
            ItemObj.AnimNameWithCreate = false
        end
    end
    self.OverLay_List:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- self.List_Item:SetVisibility(UE4.ESlateVisibility.Visible)
    ---分帧加载完后，用这个接口算一下滚动条的显隐状态
    UIUtils.GetTileViewContentMaxCount(self.List_Item)
    self:JumpToSelectItem(NeedDelayJump)
    self.NeedSelectStuffId = nil

    if (bNeedShowWarningDialog) then
        local LastWeaponTooMoreWarningTimeStamp = EMCache:Get(BagCommon.LastWeaponTooMoreWarningTimeStamp, true)
        if (LastWeaponTooMoreWarningTimeStamp and LastWeaponTooMoreWarningTimeStamp > TimeUtils.TimestampLastClock(0)) then
            -- 处于当天不需要提示期间
            self:SetFocus_Lua()
        else
            local CommonDialog = UIManager(self):GetUIObj("CommonDialog")
            if (CommonDialog == nil) then
                local ConfirmParams = {}
                ConfirmParams.RightCallbackFunction = function(_, Data) 
                    local NowTime = TimeUtils.NowTime()
                    EMCache:Set(BagCommon.LastWeaponTooMoreWarningTimeStamp, NowTime, true)
                end
                self.List_Item:BP_CancelScrollIntoView()
                UIManager(self):ShowCommonPopupUI(100227, ConfirmParams, self)
            else
                self:SetFocus_Lua()
            end
        end
    else
        self:SetFocus_Lua()
    end
end

function WBP_Bag_Main_M_C:RefreshDetail(GridIndex, StuffUuid)
    if (GridIndex == -1 or self.CurSelectStuffContent == nil) then
        self.List_Item:BP_ClearSelection()
        self.Panel_Detail:SetVisibility(UE4.ESlateVisibility.Collapsed)
        return
    end
    local StuffServerData = nil
    if (self.CurTabId == BagCommon.ItemTypeToTabId.MeleeWeapon or self.CurTabId == BagCommon.ItemTypeToTabId.RangedWeapon) then
        StuffServerData = self:GetStuffServerData(StuffUuid, BagCommon.StuffType.Weapon)
    elseif (self.CurTabId == BagCommon.ItemTypeToTabId.Mod) then
        StuffServerData = self:GetStuffServerData(StuffUuid, BagCommon.StuffType.Mod)
    elseif (self.CurTabId == BagCommon.ItemTypeToTabId.Draft) then
        StuffServerData = self:GetStuffServerData(StuffUuid, BagCommon.StuffType.Draft)
    else
        StuffServerData = self:GetStuffServerData(StuffUuid, BagCommon.StuffType.Resource, self.CurSelectStuffContent.FishInfo)
    end
    if (StuffServerData == nil) then
        DebugPrint("WBP_Bag_Main_M_C== RefreshDetail Error, StuffServerData is nil, StuffUuid is ", StuffUuid)
        return
    end
    -- 通用信息设置
    local StuffConfigData = StuffServerData:Data()
    local DetailPanelAnim = "Refresh"
    if (not self.Panel_Detail:IsVisible()) then
        DetailPanelAnim = "In"
    end
    self.Panel_Detail:RefreshInfoByData(self.CurSelectStuffContent, StuffServerData, StuffConfigData, self, DetailPanelAnim)
    self:RefreshDetailView(StuffConfigData)
end

--region EnterStuffChoose 进入出售状态
function WBP_Bag_Main_M_C:EnterStuffSellState()
    -- 判断条件是否能进入出售状态
    if (not self.Button_Sell:IsVisible()) then
        DebugPrint("WBP_Bag_Main_P_C===EnterStuffSellState not Success, Because Button_Sell is not Visible!!")
        return
    end
    local TitleName = GText("UI_BAG_Sell")
    -- self.LastBagState = self.BagCurState
    if (self.CurTabId == BagCommon.ItemTypeToTabId.Mod) then
        TitleName = GText("UI_Bag_ModExtract")
        self.HB_Check:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
        self:StartMultiSelectWidget()
    elseif (self.CurTabId == BagCommon.ItemTypeToTabId.FishItem) then
        self.HB_Check:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
        self:StartMultiSelectWidget()
    end
    self.Tab_Bag:EnterViewSingleMode(TitleName)

    self.BagCurState = BagCommon.AllBagState.ChooseSaleState
    self.DesireSaleStuffObjList = {}
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if (UIManager ~= nil) then
        local SelectStuffDatas = nil
        if (self.CurSelectStuffContent and self.CurSelectStuffContent.StuffType == BagCommon.TabIdToStuffType[self.CurTabId]) then
            if (self:CheckIsCanAddToSaleList(self.CurSelectStuffContent, false)) then
                local StuffUuid = self.CurSelectStuffContent.Uuid
                local StuffServerData = self:GetStuffServerData(StuffUuid, self.CurSelectStuffContent.StuffType, self.CurSelectStuffContent.FishInfo)
                if (self.CurTabId == BagCommon.ItemTypeToTabId.Mod) then
                    -- Mod相关
                    SelectStuffDatas = StuffIconObject:GetModStuffData(StuffServerData, nil, "ClickChooseStuff")
                elseif (self.CurTabId == BagCommon.ItemTypeToTabId.Draft) then
                    -- 铸造图纸相关
                    SelectStuffDatas = StuffIconObject:GetDraftsStuffData(StuffServerData, nil, "ClickChooseStuff")
                else
                    -- 道具相关
                    if self.CurSelectStuffContent.FishInfo then
                        StuffServerData.FishInfo = self.CurSelectStuffContent.FishInfo
                    end
                    SelectStuffDatas = StuffIconObject:GetItemStuffData(StuffServerData, nil, "ClickChooseStuff")
                end

                local StuffStateTagInfo = {
                    Name = "IsToChoose",
                    ExtraData = { 1, SelectStuffDatas.StuffCount, SelectStuffDatas.Price, SelectStuffDatas.CoinId,
                        self.RemoveBagItemInList }
                }
                self.CurSelectStuffContent.StateTagInfo = StuffStateTagInfo
                if (self.CurSelectStuffContent.SelfWidget) then
                    self.CurSelectStuffContent.SelfWidget:SetStuffStyleByStateTag(self.CurSelectStuffContent)
                end
                self.DesireSaleStuffObjList[StuffUuid] = self.CurSelectStuffContent
            else
                if (self.CurSelectStuffContent.SelfWidget) then
                    self.CurSelectStuffContent.SelfWidget:SetSelected(false)
                else
                    self.CurSelectStuffContent.IsSelect = false
                end
            end
        end

        -- 播放动画并打开售卖界面
        if self:IsAnimationPlaying(self.Sell_Close) then
            self:StopAnimation(self.Sell_Close)
        end
        self:PlayAnimation(self.Sell)
        UIManager:LoadUI(UIConst.BAGSTUFFSALESELECTMOBILE, BagCommon.BagStuffSelectUIName, BagCommon.BagSellPageZOrder, self, self.LeaveStuffSellState, 
                            self.RemoveItemSaleState, self.RealToSaleItems, SelectStuffDatas, BagCommon.BagItemSelectOpMode.SellMode)
    end
    -- 取消当前选中
    self:CancelStuffClickAndHideDetail()
    -- 隐藏Npc对话内容
    -- self:UpdateNpcDialogue()
    -- self.Button_DetailClose:SetVisibility(UE4.ESlateVisibility.Collapsed) 
    self:UpdateAllItemsStyle(false)
end

function WBP_Bag_Main_M_C:LeaveStuffSellState()
    self.Tab_Bag:LeaveViewSingleMode()
    -- self.LastBagState = self.BagCurState
    self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
    self:ResetMultiSelectWidget()

    self.BagCurState = BagCommon.AllBagState.NormalState
    self:RecoverAllItemsStyle()

    -- 取消当前选中
    self:CancelStuffClickAndHideDetail()
    self:SetFocus_Lua()
    -- 关闭的时候需要重新打开详情，所以不需要在这里恢复
    -- self.Panel_Detail.Panel_Button:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- if (self.Panel_Detail.IsCanLocked) then
    --     self.Panel_Detail.Btn_Locked:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- end

    -- self.Button_DetailClose:SetVisibility(UE4.ESlateVisibility.Visible) 
    if self:IsAnimationPlaying(self.Sell) then
        self:StopAnimation(self.Sell)
    end
    self:PlayAnimation(self.Sell_Close)
end

function WBP_Bag_Main_M_C:RealToSaleItems(AllStuffContentList, AllStuffSellInfo)
    self:RecoverAllItemsStyle()
    local PlayerAvatar = GWorld:GetAvatar()
    local ModList, ResourceList, DraftsList = {}, {}, {}
    local IntegerUuid
    for k, v in pairs(AllStuffContentList) do
        if (v.StuffType == BagCommon.StuffType.Mod) then
            local StuffUuid = self:GetStuffObjId(v.Uuid)
            ModList[StuffUuid] = {Count=AllStuffSellInfo[k], CurrentModCount=v.Count}
        elseif (v.StuffType == BagCommon.StuffType.Draft) then
            DraftsList[v.UnitId] = AllStuffSellInfo[k]
        elseif (v.StuffType == BagCommon.StuffType.Resource) then
            IntegerUuid = v.UnitId
            if BagCommon:IsFishResource(IntegerUuid) then
                ResourceList[IntegerUuid] = ResourceList[IntegerUuid] or {}
                table.insert(ResourceList[IntegerUuid], {Count=AllStuffSellInfo[k], Size=v.FishInfo.Size})
            else
                ResourceList[IntegerUuid] = {Count=AllStuffSellInfo[k], CurrentResourceCount=v.Count}
            end
        end
    end
    -- 出售Mod以及道具、铸造图纸
    if (not IsEmptyTable(ModList)) then
        PlayerAvatar:ModBulkDecompose(ModList)
    end
    if (not IsEmptyTable(ResourceList)) then
        if BagCommon:IsFishResource(IntegerUuid) then
            PlayerAvatar:ResourceBulkSaleFish(ResourceList)
        else
            PlayerAvatar:ResourceBulkSale(ResourceList)
        end
    end
    if (not IsEmptyTable(DraftsList)) then
        PlayerAvatar:DraftSale(DraftsList)
    end
end
--endregion

--region EnterWeaponResolve 进入武器分解
function WBP_Bag_Main_M_C:EnterWeaponResolveState()
    -- 判断条件是否能进入分解状态
    if (not self.Button_Sell:IsVisible()) then
        DebugPrint("WBP_Bag_Main_P_C===EnterWeaponResolveState not Success, Because Button_Sell is not Visible!!")
        return
    end
    self.Tab_Bag:EnterViewSingleMode(GText("UI_Bag_Decompose"))
    -- self.LastBagState = self.BagCurState
    self.HB_Check:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
    self:StartMultiSelectWidget()

    self.BagCurState = BagCommon.AllBagState.WeaponResolveState
    self.DesireResolveWeaponList = {}
    -- 取消当前选中
    local SelectStuffDatas = nil
    if (self.CurSelectStuffContent and self.CurSelectStuffContent.StuffType == BagCommon.TabIdToStuffType[self.CurTabId]) then
        if (self:CheckIsCanAddToSaleList(self.CurSelectStuffContent, false)) then
            local StuffUuid = self.CurSelectStuffContent.Uuid
            local StuffServerData = self:GetStuffServerData(StuffUuid, self.CurSelectStuffContent.StuffType)
            SelectStuffDatas = StuffIconObject:GetWeaponStuffData(StuffServerData, nil, "ClickChooseStuff")

            local function RemoveWeaponCallback()
                EventManager:FireEvent(EventID.OnRemoveBagItemInList, StuffUuid)
            end
            local StuffStateTagInfo = {Name="IsToChoose",  ExtraData={1, SelectStuffDatas.StuffCount, SelectStuffDatas.Price, SelectStuffDatas.CoinId,RemoveWeaponCallback}}
            self.CurSelectStuffContent.StateTagInfo = StuffStateTagInfo
            if (self.CurSelectStuffContent.SelfWidget) then
                self.CurSelectStuffContent.SelfWidget:SetStuffStyleByStateTag(self.CurSelectStuffContent)
            end
            self.DesireResolveWeaponList[StuffUuid] = self.CurSelectStuffContent
        else
            if (self.CurSelectStuffContent.SelfWidget) then
                self.CurSelectStuffContent.SelfWidget:SetSelected(false)
            else
                self.CurSelectStuffContent.IsSelect = false
            end
        end
    end
    -- 关闭详情面版
    self:CancelStuffClickAndHideDetail()

    -- 播放动画并打开售卖界面
    if self:IsAnimationPlaying(self.Sell_Close) then
        self:StopAnimation(self.Sell_Close)
    end
    self:PlayAnimation(self.Sell)
    UIManager(self):LoadUI(UIConst.BAGSTUFFSALESELECTMOBILE, BagCommon.BagStuffSelectUIName, BagCommon.BagSellPageZOrder, self, self.LeaveWeaponResolveState, 
                            self.RemoveWeaponResolveState, self.RealToResolveWeapon, SelectStuffDatas, BagCommon.BagItemSelectOpMode.ResolveMode)

    self:UpdateAllItemsStyle(false)
end

function WBP_Bag_Main_M_C:LeaveWeaponResolveState()
    self.Tab_Bag:LeaveViewSingleMode()
    -- self.LastBagState = self.BagCurState
    self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
    self:ResetMultiSelectWidget()

    self.BagCurState = BagCommon.AllBagState.NormalState
    self.DesireResolveWeaponList = {}
    self:RecoverAllItemsStyle()

    -- 取消当前选中
    self:CancelStuffClickAndHideDetail()

    self:SetFocus_Lua()
    -- 关闭的时候需要重新打开详情，所以不需要在这里恢复
    -- self.Panel_Detail.Panel_Button:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- if (self.Panel_Detail.IsCanLocked) then
    --     self.Panel_Detail.Btn_Locked:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- end

    -- self.Button_DetailClose:SetVisibility(UE4.ESlateVisibility.Visible) 
    if self:IsAnimationPlaying(self.Sell) then
        self:StopAnimation(self.Sell)
    end
    self:PlayAnimation(self.Sell_Close)
end

function WBP_Bag_Main_M_C:RealToResolveWeapon(AllWeaponContentList)
    -- 真正分解武器
    self:RecoverAllItemsStyle()
    local PlayerAvatar = GWorld:GetAvatar()
    local AllWeaponUuid = {}
    for k, v in pairs(AllWeaponContentList) do
        local WeaponUuid = self:GetStuffObjId(v.Uuid)
        table.insert(AllWeaponUuid, WeaponUuid)
    end
    PlayerAvatar:WeaponBulkBreakDown(AllWeaponUuid)
end
--endregion

function WBP_Bag_Main_M_C:UpdateNpcDialogue(DialogueId)
    if (DialogueId == nil) then
        self.Panel_Dialogue:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        local DialogueInfo = DataMgr.NPCDialogue[DialogueId]
        if (DialogueInfo ~= nil) then
            self.Text_Dialogue:SetText(GText(DialogueInfo.Content))
            self.Panel_Dialogue:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible) 
        else
            self.Panel_Dialogue:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end
end

function WBP_Bag_Main_M_C:RefreshBottomKeyInfo(FocusTypeName)
    FocusTypeName = FocusTypeName or "DefaultWidget"
    if (self.CurFocusWidget == FocusTypeName) then
        return
    end

    self.CurFocusWidget = FocusTypeName
end

--- =============================== 一些输入事件和点击回调函数 =============================================
function WBP_Bag_Main_M_C:UpdateUIStyleInPlatform(IsUseGamePad)
    -- 更新操作模式
end

function WBP_Bag_Main_M_C:TabBagItemClick(TabWidget)
    local TabId = TabWidget:GetTabId()
    self.CurTabId = TabId
    self.Sift:Close()
     -- 获取对应的 SiftModelId
    self.SiftModelId = BagCommon.SiftModelIds[self.CurTabId]
    if self.Sift then
         self.Sift:SetSiftModelId(self.SiftModelId)
    end
    if self.CurTabId ~= BagCommon.ItemTypeToTabId.MeleeWeapon and self.CurTabId ~= BagCommon.ItemTypeToTabId.RangedWeapon
    and self.CurTabId ~= BagCommon.ItemTypeToTabId.Mod and self.CurTabId ~= BagCommon.ItemTypeToTabId.Resource then
        self.Sift:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    else
        self.Sift:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    end

    self.Button_Sell:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    self.Filter:Init(self, BagCommon.SortFilters[self.CurTabId or BagCommon.ItemTypeToTabId.Resource], CommonConst.DESC)

    self.Panel_Detail:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.OverLay_List:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
    -- self.List_Item:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self:FillWithListViewData(TabId, true)
end

function WBP_Bag_Main_M_C:OnListSelectStuffClicked(Content)
    if (Content.Type == "EmptyGrid") then
        -- 点击了空的Item
        return
    end
    local GridIndex, StuffUuid, AddNum = Content.GridIndex, Content.Uuid,Content.AddNum
    self:ClickChooseStuff(GridIndex, StuffUuid, AddNum)
end

function WBP_Bag_Main_M_C:ClickChooseStuff(GridIndex, StuffUuid, AddNum)
    if (self.BagCurState == BagCommon.AllBagState.NormalState and IsValid(self.CurSelectStuffContent) and self.CurSelectStuffContent.Uuid == StuffUuid) then
        -- 普通状态下，选中同一个Item不需要有效果
        DebugPrint("WBP_Bag_Main_P_C=== ClickChooseStuff, Click the same Item, no need to process!!")
        return
    end
    self.CurSelectGridIndex = GridIndex
    if (IsValid(self.CurSelectStuffContent)) then
        -- local IsCancelSelect = self.CurSelectStuffContent.Uuid == StuffUuid and self.CurSelectStuffContent.IsSelect 
        if (self.CurSelectStuffContent.SelfWidget) then
            self.CurSelectStuffContent.SelfWidget:SetSelected(false)
        else
            self.CurSelectStuffContent.IsSelect = false
        end 
    end
    self.CurSelectStuffContent = self.List_Item:GetItemAt(math.max(GridIndex - 1, 0))
    if (self.CurSelectStuffContent and self.CurSelectStuffContent.SelfWidget) then
        self.CurSelectStuffContent.SelfWidget:SetSelected(true)
    end
    -- 隐藏Npc对话内容
    -- self:UpdateNpcDialogue()
    self:RefreshDetail(GridIndex, StuffUuid)
    self:RefreshSaleItemSelect(StuffUuid, GridIndex,AddNum)
    self:RefreshResolveWeaponSelect(StuffUuid, GridIndex)
end

function WBP_Bag_Main_M_C:CancelStuffClickAndHideDetail()
    -- 取消当前选中
    self.CurSelectStuffContent = nil
    self:RefreshDetail(-1, nil)
    -- 隐藏右侧详情面板一部分内容
    self.Panel_Detail.Panel_Button:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function WBP_Bag_Main_M_C:OnKeyDown(MyGeometry, InKeyEvent)
    if(CommonUtils:IfExistSystemGuideUI(self)) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadButtonDown(InKeyName)
    else
        if (InKeyName == self.OpenKey) then
            IsEventHandled = true
            self:OnTryToCloseMainPage()
        else
            IsEventHandled = self.Tab_Bag:Handle_KeyEventOnTouch(InKeyName) 
        end 
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

function WBP_Bag_Main_M_C:OnGamePadButtonDown(InKeyName)
    local IsEventHandled = false
    if (InKeyName == UIConst.GamePadKey.FaceButtonLeft) then
        IsEventHandled = self:Handle_KeyDownOnGamePad()
    else
        IsEventHandled = self.Tab_Bag:Handle_KeyEventOnGamePad(InKeyName)
    end
    return IsEventHandled
end

function WBP_Bag_Main_M_C:Handle_KeyDownOnGamePad()
    -- 处理手柄相关的交互事件
    return true
end

function WBP_Bag_Main_M_C:OnReturnKeyDown()
    -- 返回上一级
    -- UIUtils.PlayCommonBtnSe(self)
    local SellPageMainUI = UIManager(self):GetUI(BagCommon.BagStuffSelectUIName)
    if (SellPageMainUI ~= nil) then
        SellPageMainUI:PlayOutAnim()
        return
    end
    if (self:CheckIsCanCloseSelf()) then
        self:PlayOutAnim()
    end
end

function WBP_Bag_Main_M_C:OnTryToCloseMainPage()
    -- 直接关闭背包
    local SellPageMainUI = UIManager(self):GetUI(BagCommon.BagStuffSelectUIName)
    if (SellPageMainUI ~= nil) then
        -- 出售状态下，不允许快捷关闭
        return
    end
    if (self:CheckIsCanCloseSelf()) then
        -- UIUtils.PlayCommonBtnSe(self)
        self:PlayOutAnim()
    end
end

AssembleComponents(WBP_Bag_Main_M_C)
return WBP_Bag_Main_M_C
