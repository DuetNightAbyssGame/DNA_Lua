--
-- DESCRIPTION
-- 背包View （PC、移动端公用）
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local BagCommon = require "BluePrints.UI.WBP.Bag.BagCommon"

local M = {}

function M:PlayInAnim()
    if (self.OwnerPlayer == nil or not UE4.UKismetSystemLibrary.IsValid(self.OwnerPlayer)) then
        self.OwnerPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    end
    self:RefreshOtherInfo()
    self:InitTabInfo()
    self:InitListenEvent()
    -- self:BindToAnimationFinished(self.In, {self, PlayAnimFinished})
    -- self.InitWheelScrollMultiplier = self.List_Item.WheelScrollMultiplier
    self:PlayAnimationForward(self.In)
end

function M:PlayOutAnim()
    AudioManager(self):SetEventSoundParam(self, BagCommon.MainUIName, {ToEnd=1})
    if (self.Panel_Detail.IsSkillTipsOpened) then
        self.Common_Skill_Effect_Tips_PC:PlayOutAnim()
    end
    -- local SpawnNpcConfig = DataMgr.SpawnNPC[self.NpcId]
    -- self:UpdateNpcDialogue(SpawnNpcConfig.EndDialogue)
    self:MarkToRemove(true)
    self:BindToAnimationFinished(self.Out, {self, self.Close})
    self:PlayAnimationForward(self.Out)
    -- 在关闭的同时恢复镜头
    self:DoRecoverCamera()
end

function M:CheckIsCanCloseSelf()
    if (self:IsAnimationPlaying(self.In)) then
        return false
    end
    return true
end

function M:InitListenEvent()
    self:AddDispatcher(EventID.OnUpdateBagItem, self, self.OnUpdateBagItemByAction)
end

function M:RefreshAllGridIndex()
    local AllItemCount = self.List_Item:GetNumItems()
    for i = 0, AllItemCount - 1, 1 do
        local ItemObj = self.List_Item:GetItemAt(i)
        if (ItemObj) then
            ItemObj.GridIndex = i + 1
        end
    end
end

function M:RefreshAllStuffCount()
    local AllItemCount = self.List_Item:GetNumItems()
    for i = 0, AllItemCount - 1, 1 do
        local ItemObj = self.List_Item:GetItemAt(i)
        if (ItemObj) then
            local StuffServerData = self:GetStuffServerData(ItemObj.Uuid, "Resource")
            if (ItemObj.SelfWidget) then
                ItemObj.SelfWidget:SetCount(StuffServerData.Count)
            else
                ItemObj.Count = StuffServerData.Count
            end
        end
    end
end

function M:RefreshOtherInfo()
    -- 刷新一些固定的UI信息(只在初始化的时候刷新一次)
    -- local SpawnNpcConfig = DataMgr.SpawnNPC[self.NpcId]
    -- self.Title_Dialogue:SetText(GText(SpawnNpcConfig.NPCName))

    self.Text_Empty:SetText(GText("UI_BAG_EMPTY"))
    self.Text_Empty_World:SetText(EnText("UI_BAG_EMPTY"))
    self.Text_Empty_Search:SetText(GText("Backpack_SiftEmpty"))
    self.Filter:BindEventOnSelectionsChanged(self, self.BindEventOnSelectionsChanged)
    self.Filter:BindEventOnSortTypeChanged(self, self.BindEventOnSortTypeChanged)
    self.Filter.Btn_SortType:SetNavigationRuleExplicit(EUINavigation.Right, self.Sift)


    --Sift筛选
    self.Sift:BindEventOnSelectionsChanged(self, self.OnSiftSelectionsChanged)
    self.Sift.Img_Key_L:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Sift:BindEventOnAddedToFocusPath(self,self.OnSiftAddedToFocusPath)
    self.Sift:BindEventOnRemovedFromFocusPath(self,self.OnSiftRemovedFromFocusPath)
    -- self.Sift:SetNavigationRuleExplicit(EUINavigation.Left, self.Filter.Btn_SortType)
    -- self.Sift:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    -- self.Sift:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    self:AddLSFocusTarget(nil, {self.Filter, self.Sift})

    self.Button_Sell:SetGamePadImg("X")
    self.Button_Sell:BindEventOnClicked(self, self.EnterToSpecialState)
    self.Button_DetailClose.OnClicked:Add(self,self.OnClickBlank)
    -- self.Panel_Detail.Btn01:BindEventOnClicked(self, self.OnClickGoToAmory)
    self.Panel_Detail.Btn_Locked:BindEventOnClicked(self, self.ClickToUnlockStuff)
    self.Panel_Detail:InitCommonInfo()

    self.List_Item.BP_OnItemSelectionChanged:Add(self, self.OnSelectStuffItemChanged)
end

function M:EnterToSpecialState()
    if (self.CurTabId == BagCommon.ItemTypeToTabId.MeleeWeapon or self.CurTabId == BagCommon.ItemTypeToTabId.RangedWeapon) then
        self:EnterWeaponResolveState()
    else
        self:EnterStuffSellState()
    end
end

function M:RefreshDetailView(StuffConfigData)
    if (self.BagCurState == BagCommon.AllBagState.NormalState) then  
        if (self.CurTabId == BagCommon.ItemTypeToTabId.MeleeWeapon or self.CurTabId == BagCommon.ItemTypeToTabId.RangedWeapon 
                        or self.CurTabId == BagCommon.ItemTypeToTabId.Mod) then
            -- 武器相关、Mod相关
            self.Panel_Detail:UpdateBottomSingleBtnInfo("WeaponAndMod", self.OnClickGoToAmory, self)
        elseif (self.CurTabId == BagCommon.ItemTypeToTabId.Resource) then
            -- 材料相关
            if (StuffConfigData.ResourceSType == BagCommon.MountTypeInResource) then
                local WrapMountFunc = function()
                    local MountItemVarData = StuffConfigData.FunctionVars
                    if (MountItemVarData) then
                        PageJumpUtils:JumpToTargetPageByJumpId(BagCommon.MountJumpId, MountItemVarData.Id)
                    else
                        DebugPrint("BagMainPageView== RefreshDetailView DataMgr Resource of Mount FunctionVars is nil!!!")
                    end
                end
                self.Panel_Detail:UpdateBottomSingleBtnInfo("Mount", WrapMountFunc, self)
            else
                self.Panel_Detail:UpdateBottomSingleBtnInfo("Other", nil, self)
            end
        elseif (self.CurTabId == BagCommon.ItemTypeToTabId.ReadItem) then
            -- Resource之中阅读物相关相关
            local WrapReadFunc = function()
                UIManager(self):LoadUINew("ItemInformation", StuffConfigData.ResourceId, "Read", self, true)
            end
            self.Panel_Detail:UpdateBottomSingleBtnInfo("Read", WrapReadFunc, self)
        elseif (self.CurTabId == BagCommon.ItemTypeToTabId.FishItem) then
            -- 钓鱼相关
            local WrapFishFunc = function()
                local Params = {FishResourceId = StuffConfigData.ResourceId}
                PageJumpUtils:JumpToAnglingMap(Params)
            end
            self.Panel_Detail:UpdateBottomSingleBtnInfo("Fish", WrapFishFunc, self, "AnglingMap")
        elseif (self.CurTabId == BagCommon.ItemTypeToTabId.ConsumableItem) then
            -- 消耗品相关
            local WrapConsumeFunc = function()
                self:OnClickGoToUseConsume(StuffConfigData)
                -- 消除红点操作
                self:ClearConsumableItemReddot(StuffConfigData)
                self.Panel_Detail:SetConsumableItemButtonReddot("Bag_Consume")
            end
            self.Panel_Detail:UpdateBottomSingleBtnInfo("ConsumableItem", WrapConsumeFunc, self, "Bag_Consume")
        else
            self.Panel_Detail:UpdateBottomSingleBtnInfo("Other", nil, self)
        end
    else
        self.Panel_Detail:UpdateBottomSingleBtnInfo("Other", nil, self)
    end
    self.Panel_Detail:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

function M:RefreshItemViewByItemCount(AllItemCount,SiftItemCount)
    self:RefreshButtonInfoInDiffTab()
    if (AllItemCount <= 0) then
        self.GameInputModeSubsystem:SetNavigateWidgetVisibility(false)
        self.Panel_Detail:SetVisibility(UE4.ESlateVisibility.Hidden)
        self.Panel_Content:SetRenderOpacity(0.0)
        self.Panel_Content:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        self.Panel_Empty:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        -- self:SetFocus_Lua()
    elseif (SiftItemCount <= 0) then
        -- 当背包有物品，但筛选后无物品时，不显示Panel_Empty，保留Panel_Content
        self.Panel_Content:SetRenderOpacity(1.0)
        self.Panel_Content:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Panel_Empty_Search:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Panel_Empty:SetVisibility(UE4.ESlateVisibility.Collapsed)
        -- self:SetFocus_Lua()
    else
        -- 当背包有物品，且筛选后有物品时，正常显示
        self.Panel_Content:SetRenderOpacity(1.0)
        self.Panel_Content:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Panel_Empty_Search:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Panel_Empty:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function M:RecoverAllItemsStyle()
    -- 恢复背包Item样式
    local AllItemCount = self.List_Item:GetNumItems()
    for i = 0, AllItemCount - 1, 1 do
        local ItemObj = self.List_Item:GetItemAt(i)
        ItemObj.IsSelect = false
        if (ItemObj and ItemObj.StuffType ~= "EmptyGrid") then
            ItemObj.StateTagInfo = {Name="Normal"}
            if (ItemObj.SelfWidget) then
                ItemObj.SelfWidget:SetStuffStyleByStateTag(ItemObj)
                ItemObj.SelfWidget:SetSelected(false)
                ItemObj.AddNum = 0
            end
        end
    end
end

function M:AfterFillDataInfo()
    local AllItemCount = self.List_Item:GetNumItems()
    if (AllItemCount > 0 and self.BagCurState ~= BagCommon.AllBagState.NormalState) then
        if (self.BagCurState == BagCommon.AllBagState.ChooseSaleState) then
            for i = 0, AllItemCount - 1, 1 do
                local ItemObj = self.List_Item:GetItemAt(i)
                if (self.DesireSaleStuffObjList[ItemObj.Uuid] ~= nil) then
                    self.DesireSaleStuffObjList[ItemObj.Uuid] = ItemObj
                end
            end
        elseif (self.BagCurState == BagCommon.AllBagState.WeaponResolveState) then
            for i = 0, AllItemCount - 1, 1 do
                local ItemObj = self.List_Item:GetItemAt(i)
                if (self.DesireResolveWeaponList[ItemObj.Uuid] ~= nil) then
                    self.DesireResolveWeaponList[ItemObj.Uuid] = ItemObj
                end
            end
        end
        self:UpdateAllItemsStyle(false)
    end
    if (self.CurTabId == BagCommon.ItemTypeToTabId.MeleeWeapon) then
        -- 近战武器
    elseif (self.CurTabId == BagCommon.ItemTypeToTabId.RangedWeapon) then
        -- 远程武器
    elseif (self.CurTabId == BagCommon.ItemTypeToTabId.Mod) then
        -- Mod相关
    elseif (self.CurTabId == BagCommon.ItemTypeToTabId.Resource) then
        -- 材料
    elseif (self.CurTabId == BagCommon.ItemTypeToTabId.TaskItem) then
        -- 任务道具
    elseif (self.CurTabId == BagCommon.ItemTypeToTabId.ReadItem) then
        -- 阅读物道具
    else
        -- 其他
    end
    -- 重置需要选中StuffId
    self.NeedSelectStuffId = nil
end

function M:UpdateAllItemsStyle(IsNeedDalay)
    -- 设置背包Item样式
    if (IsNeedDalay) then
        if self:IsExistTimer("DelayToSetItemStyle") then
            self:RemoveTimer("DelayToSetItemStyle")
        end
        self:AddTimer(0.1, self.DelayToSetItemStyle, false, 0, "DelayToSetItemStyle")
    else
        self:DelayToSetItemStyle()
    end
end

function M:DelayToSetItemStyle()
    local AllItemCount = self.List_Item:GetNumItems()
    for i = 0, AllItemCount - 1, 1 do
        local ItemObj = self.List_Item:GetItemAt(i)
        if (ItemObj and ItemObj.StuffType ~= "EmptyGrid") then
            local IsNeedGrey, NotChooseExtraData = false, nil
            if (self.BagCurState == BagCommon.AllBagState.ChooseSaleState) then
                IsNeedGrey = (ItemObj.LockType ~= 0 or ItemObj.Price == -1 or (ItemObj.StuffType ~= BagCommon.StuffType.Mod and self:GetIsStuffIsEquiped(ItemObj)))
                if (not IsNeedGrey) then
                    NotChooseExtraData = {ItemObj.Count, ItemObj.Price, ItemObj.CoinId}
                end
            elseif (self.BagCurState == BagCommon.AllBagState.WeaponResolveState) then
                IsNeedGrey = (ItemObj.LockType ~= 0 or ItemObj.Price == -1 or self:GetIsStuffIsEquiped(ItemObj))
                if (not IsNeedGrey) then
                    NotChooseExtraData = {ItemObj.Count, ItemObj.Price, ItemObj.CoinId}
                end
            end
            local IsInChooseList = self.DesireSaleStuffObjList[ItemObj.Uuid] ~= nil or self.DesireResolveWeaponList[ItemObj.Uuid] ~= nil
            if (IsInChooseList) then
                local SellPageMainUI = UIManager(self):GetUI(BagCommon.BagStuffSelectUIName)
                local function RemoveStuffCallback()
                    EventManager:FireEvent(EventID.OnRemoveBagItemInList, ItemObj.Uuid)
                end
                ItemObj.StateTagInfo = {Name="IsToChoose", ExtraData={SellPageMainUI.NeedDealWithStuffCount[ItemObj.Uuid] or 1, 
                                        ItemObj.Count, ItemObj.Price, ItemObj.CoinId, RemoveStuffCallback}, IsShowGrey=IsNeedGrey}
            else
                ItemObj.StateTagInfo = {Name="Normal", ExtraData=NotChooseExtraData, IsShowGrey=IsNeedGrey}
            end
            if (ItemObj.SelfWidget) then
                ItemObj.SelfWidget:SetStuffStyleByStateTag(ItemObj)
            end
        end
    end
end

function M:OnRefreshSaleSelectNum(StuffUuid, CurNum)
    local TargetItem = self.DesireSaleStuffObjList[StuffUuid]
    if (IsValid(TargetItem)) then
        if (TargetItem.StateTagInfo and TargetItem.StateTagInfo.ExtraData) then
            TargetItem.StateTagInfo.ExtraData[1] = CurNum
        end
        if (TargetItem.SelfWidget) then
           --TargetItem.SelfWidget:SetSelectNum(Utils.FormatNumber(CurNum, true), Utils.FormatNumber(TargetItem.Count, true))
            TargetItem.SelfWidget:SetSelectNum(Utils.FormatNumber(CurNum, true))
        end
    end
end

--列表铺满适配之后，其他控件的跟随适配
function M:OnHorizontalListViewResizeDone(NewViewportSizeX, SizeX)
    local EmptySlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.HB_Empty)
    local Offsets = EmptySlot:GetOffsets()
    Offsets.Right = NewViewportSizeX - SizeX - Offsets.Left
    EmptySlot:SetOffsets(Offsets)
end

function M:RefreshListViewEmptyGrid(ListViewObj, CurItemCount, ListViewSize)
    -- ListViewObj: 滑动对象  CurItemCount: 内容Item个数  ListViewSize: 列表大小（可选）
    -- 刷新滑动条，并且获取空格子个数
    if (ListViewSize == nil) then
        ListViewSize = UIManager(self):GetWidgetRenderSize(ListViewObj)
    end

    local ListSizeX,ItemSizeX = ListViewSize.X,ListViewObj:GetEntryWidth()
    local ListSizeY,ItemSizeY = ListViewSize.Y,ListViewObj:GetEntryHeight()

    local XCount, YCount = 0,0

    local ScrollBarSize = ListViewObj.ScrollBarDesireSize
    XCount = math.floor((ListSizeX - ScrollBarSize) / ItemSizeX)
    local RawYCount = (ListSizeY / ItemSizeY)
    YCount = math.ceil(RawYCount - 0.05)
    DebugPrint("RefreshListViewEmptyGrid TileViewCount", RawYCount,YCount)
    ListViewObj:SetScrollbarVisibility(UIConst.VisibilityOp.Hidden)
    if (YCount-RawYCount> 0.05 or ListViewObj:GetNumItems()> XCount* YCount) then
        ListViewObj:SetControlScrollbarInside(true)
    end

    if (CommonUtils.GetDeviceTypeByPlatformName()== CommonConst.CLIENT_DEVICE_TYPE.MOBILE and ListViewObj.bControlScrollbarInside) then
        ListViewObj:SetControlScrollbarInside(false)
        ListViewObj:SetScrollbarVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end

    local EmptyItemNum = 0
    if (CurItemCount - XCount * YCount <= 0) then
        EmptyItemNum = XCount * YCount - CurItemCount
        ListViewObj:SetEmptyGridItemCount(EmptyItemNum)
    end
    return EmptyItemNum, XCount, YCount
end

function M:GetEmptyItemCountInLastLine(ListViewObj, CurItemCount)
    local CurMaxItemCount = ListViewObj:GetScrollOffsetOfEnd()
    local EmptyItemNum = math.floor(CurMaxItemCount - CurItemCount)
    ListViewObj:SetEmptyGridItemCount(EmptyItemNum)
    return EmptyItemNum
end

-- 点击开启按钮消除该消耗品的红点
function M:ClearConsumableItemReddot(StuffConfigData)
    DebugPrint("Yihan@ ClearConsumableItemReddot", StuffConfigData.ResourceId)
    local BagConsumeNode = ReddotManager.GetTreeNode("Bag_Consume")
    local Avatar = GWorld:GetAvatar()
    if BagConsumeNode and Avatar then
        local BagConsumeNodeDetails = BagConsumeNode.Cache.Detail
        local StuffId = StuffConfigData.ResourceId
        if BagConsumeNodeDetails and BagConsumeNodeDetails[StuffId] then
            BagConsumeNodeDetails[StuffId].ShowReddot = false
            ReddotManager.DecreaseLeafNodeCount("Bag_Consume", BagConsumeNodeDetails[StuffId].StuffCount - BagConsumeNodeDetails[StuffId].ClickedCount)
            BagConsumeNodeDetails[StuffId].ClickedCount = Avatar:GetResourceNum(StuffId)
        end
        local ContentItems = self.List_Item:GetListItems()
        for i = 1, ContentItems:Length() do
            local ContentItem = ContentItems:GetRef(i)
            if ContentItem.StuffId == StuffId then
                local CurWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Item, self.List_Item:GetIndexForItem(ContentItem))
                CurWidget:SetRedDot(nil)
            end
        end
    end
end

return M
