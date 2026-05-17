require "UnLua"
local EMCache = require "EMCache.EMCache"
local StrLib = require "BluePrints.Common.DataStructure"
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
local TimeUtils = require "Utils.TimeUtils"
local RewardBox = require "BluePrints.Client.CustomTypes.SimpleRewardBox"
local SkillUtils = require "Utils.SkillUtils"
local Utils = require "Utils"
local MiscUtils = require "Utils.MiscUtils"
local BagCommon = require "BluePrints.UI.WBP.Bag.BagCommon"
local GameFlowUtils = require "Utils.GameFlowUtils"

local Deque = StrLib.Deque
---@class UIUtils
---@field private _ItemObjectClass TSubclassOf<CommonItemContent_C>
local UIUtils = Class()
UIUtils._components = {
    "BluePrints.Combat.Components.UIHitFeedbackComponent",
}

UIUtils.Handled = UE4.UWidgetBlueprintLibrary.Handled()
UIUtils.Handle = UIUtils.Handled
UIUtils.Unhandled = UE4.UWidgetBlueprintLibrary.Unhandled()

function UIUtils.ShowGotItemTipsUI(TableTypeName, ItemId, ItemCount, AdditionalParam)
	local ItemData = DataMgr[TableTypeName][ItemId]
	if not ItemData or not ItemData.Icon then
		return
	end
	local GameInstance = GWorld.GameInstance
    local Player = UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
	---@type BP_UIManagerComponent_C
	local UIManager = GameInstance:GetGameUIManager()
    local PickUpCache = EMCache:Get("PickUp",true) or {}
    --  新物品
    local IsSpecialReward = false
    if TableTypeName == "Pet" then
        IsSpecialReward = true
    end
    if TableTypeName == "Resource" or TableTypeName == "Mod" then
        if ItemData.Type ~= "Ordinary" then
            IsSpecialReward = true
        end
    end
    if ItemData.UseEffectType ~= "GetResource" and ItemData.UseEffectType ~= "GetWeapon" and ItemData.UseEffectType~= "GetMod" or TableTypeName == "Pet" then
        local BattleMain = UIManager:GetUIObj("BattleMain")
        if not BattleMain then
            DebugPrint("ZDX BattleMain is nil")
            return
        end
        local PickUpUI
        local bNew = PickUpCache[TableTypeName] == nil or PickUpCache[TableTypeName][ItemId] == nil
        -- 如果是新物品 or 贵重物品，加入UITopTipsList队列
        if bNew or IsSpecialReward then
            -- PickUpUI = BattleMain.Common_PropIntro_PC
            if BattleMain.Pos_SpecialDrops and not BattleMain.Pos_SpecialDrops:HasAnyChildren() then
                PickUpUI = UIManager:_CreateWidgetNew("BattleSpecialDrops")
                BattleMain.Pos_SpecialDrops:AddChildToOverlay(PickUpUI)
            elseif BattleMain.Pos_Drops then
                PickUpUI = BattleMain.Pos_SpecialDrops:GetChildAt(0)
            end
            if PickUpUI then
                if PickUpUI.bShowing and PickUpUI.ItemType ~= "Pet" and PickUpUI.ItemType == TableTypeName and PickUpUI.ItemId == ItemId then
                    PickUpUI.ItemCount = PickUpUI.ItemCount + ItemCount
                    PickUpUI.Text_Num:SetText(PickUpUI.ItemCount)
                    return
                end
                if PickUpUI.ItemDataInfoDict[TableTypeName] and PickUpUI.ItemDataInfoDict[TableTypeName][ItemId] and not PickUpUI.ItemDataInfoDict[TableTypeName][ItemId].IsNew then
                    PickUpUI.ItemDataInfoDict[TableTypeName][ItemId].ItemCount = PickUpUI.ItemDataInfoDict[TableTypeName][ItemId].ItemCount + ItemCount
                else
                    PickUpUI.UITopTipsList:PushBack({ItemId = ItemId, ItemType = TableTypeName})
                    if not PickUpUI.ItemDataInfoDict[TableTypeName] then
                        PickUpUI.ItemDataInfoDict[TableTypeName] = {}
                    end
                    if not PickUpUI.ItemDataInfoDict[TableTypeName][ItemId] then
                        PickUpUI.ItemDataInfoDict[TableTypeName][ItemId] = {ItemId = ItemId, ItemType = TableTypeName, ItemCount = ItemCount, IsNew = bNew, AdditionalParam = AdditionalParam}
                    end
                end
                -- PickUpUI.UITopTipsList:PushBack({ItemId = ItemId, ItemType = TableTypeName, ItemCount = ItemCount, IsNew = PickUpCache[TableTypeName] == nil or PickUpCache[TableTypeName][ItemId] == nil, AdditionalParam = AdditionalParam})
            end
            if PickUpCache[TableTypeName] == nil then
                PickUpCache[TableTypeName] = {}
            end
            if PickUpCache[TableTypeName][ItemId] == nil then
                PickUpCache[TableTypeName][ItemId] = 1
                EMCache:Set("PickUp",PickUpCache,true)
            end
            PickUpUI:PopSpecialDropQueue()
        end
        -- 如果是普通物品，展示UI
        if not IsSpecialReward and not bNew then
            -- if BattleMain.Pos_Drops then
            --     BattleMain.Pos_Drops:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            -- end
            BattleMain:SetSubSystemVisibility("Pos_Drops", ESlateVisibility.SelfHitTestInvisible)
            if BattleMain.Pos_Drops and not BattleMain.Pos_Drops:HasAnyChildren() then
                PickUpUI = UIManager:_CreateWidgetNew("BattleNormalDrops")
                BattleMain.Pos_Drops:AddChildToOverlay(PickUpUI)
            elseif BattleMain.Pos_Drops then
                PickUpUI = BattleMain.Pos_Drops:GetChildAt(0)
            end
            if PickUpUI then
                -- PickUpUI:OnUpdateTips(ItemId, ItemCount, TableTypeName)
                table.insert(PickUpUI.TickWaitingList, {ItemId = ItemId, ItemCount = ItemCount, TableName = TableTypeName})
                PickUpUI:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
                -- PickUpUI:ShowDropItem(ItemId, ItemCount, TableTypeName)
            end
        end
    end
end

---@class RewardInfo @奖励信息
---@field ItemType string @Item类型
---@field ItemId number @ItemID
---@field Count number @Item数量
---@field Rarity number @Item稀有度
--- 轻量获得物品UI
---@param TitleText string @奖励标题
---@param RewardInfoList RewardInfo[] @奖励信息列表
function UIUtils.ShowHudReward(TitleText, RewardInfoList)
    -- 加入流程管理
    local GameInstance = GWorld.GameInstance
	---@type BP_UIManagerComponent_C
	local UIManager = GameInstance:GetGameUIManager()
    local RewardUI = nil
    GameFlowUtils:AddFlow("ShowHudReward", {
        GWorld.GameInstance, function(_, Flow)
            RewardUI = UIManager:LoadUINew("CommonHudReward",TitleText, RewardInfoList)
            if RewardUI then
                RewardUI:InitRewardInfo(TitleText, RewardInfoList)
                UIManager:AddFlow("CommonHudReward", Flow)
            end
        end
    })
    -- local RewardUI = UIManager:LoadUINew("CommonHudReward",TitleText, RewardInfoList)

    -- RewardUI:InitRewardInfo(TitleText, RewardInfoList)
    -- local SpecialLst = {}
    -- local WeaponLst = {}
    -- for _, info in ipairs(RewardInfoList) do
    --     if info.ItemType == "Char" then
    --         table.insert(SpecialLst, info)
    --     elseif info.ItemType == "Weapon" then
    --         table.insert(WeaponLst, info)
    --     end
    -- end
    -- table.sort(SpecialLst, function(a, b)
    --     return a.Rarity > b.Rarity
    -- end)
    -- table.sort(WeaponLst, function(a, b)
    --     return a.Rarity > b.Rarity
    -- end)
    -- for _, info in ipairs(WeaponLst) do
    --     talbe.insert(SpecialLst, info)
    -- end

    -- local GameInstance = GWorld.GameInstance
	-- ---@type BP_UIManagerComponent_C
	-- local UIManager = GameInstance:GetGameUIManager()

    -- local UI = nil
    -- local AsyncFunc = coroutine.create(function()
    --     local co = coroutine.running()
    --     for _, info in ipairs(SpecialLst) do
    --         if not UI then 
    --             UI = UIManager:CreateWidgetNew('GachaOnce')
    --             UI:AddToViewPort()
    --         end
    --         UI:CommonInit({
    --             TargetId = info.ItemId,
    --             Sign = info.ItemType == "Char" and CommonConst.GachaCharType or CommonConst.GachaWeaponType,
    --             Rarity = info.Rarity,
    --             CallbackObj = self,
    --             CallbackFunc = function()
    --                 coroutine.resume(co)
    --             end
    --         })
    --         coroutine.yield()
    --     end

    --     local RewardUI = UIManager:LoadUINew("CommonHudReward",TitleText, RewardInfoList)
    --     RewardUI:InitRewardInfo(TitleText, RewardInfoList)
    -- end)
    -- coroutine.resume(AsyncFunc)


    -- local RewardUI = UIManager:LoadUINew("CommonHudReward",TitleText, RewardInfoList)

    -- RewardUI:InitRewardInfo(TitleText, RewardInfoList)
    return RewardUI
end

--- @param Rewards Rewards 服务器下发的的Reward信息
function UIUtils.ShowHudRewardConvert(TitleText, Rewards)
    local List = {}
    for Types, Table in pairs(Rewards) do
        local Type = Types
        Type = string.match(Type, "^(.*)s$") or Type
        for Id, v in pairs(Table) do
            local Count = 0
            for SourceType, Num in pairs(v) do
                Count = Count + Num
            end
            table.insert(List, {
                ItemId = Id,
                ItemType = Type,
                Count = Count,
                Rarity = ItemUtils.GetItemRarity(Id, Type),
            })
        end
    end
    return UIUtils.ShowHudReward(TitleText, List)
end

---@param ItemType string   @单个物品的类型
---@param ItemId number     @单个物品的Id
---@param Count number      @单个物品的数量
---@param PurchaseRewards table @服务器的RewardBox结构
---@param bSpecial boolean      @是否使用特殊弹窗
---@param func function         @关闭弹窗的回调
---@param ParentWidget Widget   @打开弹窗的控件
---@param IsReAttachFocusToPage boolean  @是否重新AttachFocus到打开的UI
---@param bIsNew boolean        @是否是新物品
function UIUtils.ShowGetItemPage(ItemType, ItemId, Count, PurchaseRewards, bSpecial, func, ParentWidget, IsReAttachFocusToPage, bOnlyItemPage, bIsNew, ToastText)
    -- 加入流程管理
    GameFlowUtils:AddFlow("GetItemPage", {
        GWorld.GameInstance, function(_, Flow)
            local UIName = bSpecial and "GetItemPageSP" or "GetItemPage"
            UIUtils.ShowGetItemPageInternal(ItemType, ItemId, Count, PurchaseRewards, bSpecial, func, ParentWidget, IsReAttachFocusToPage, bOnlyItemPage, bIsNew, ToastText)
            local UIManager = GWorld.GameInstance:GetGameUIManager()
            UIManager:AddFlow(UIName, Flow)
        end
    })
end

function UIUtils.ShowGetItemPageInternal(ItemType, ItemId, Count, PurchaseRewards, bSpecial, func, ParentWidget, IsReAttachFocusToPage, bOnlyItemPage, bIsNew, ToastText)
    if not ItemType then
        ItemType = -1
    end
    if not ItemId then
        ItemId = -1
    end
    if not Count then
        Count = -1
    end
    if not func then
        func = -1
    end
    if not ParentWidget then
        ParentWidget = -1
    end
    if not IsReAttachFocusToPage then
        IsReAttachFocusToPage = false
    end

    local SystemUIName = "GetItemPage"
    if bSpecial then
        SystemUIName = "GetItemPageSP"
    end
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    local ShowFinish = function()
        if ItemType == "Char" and not bIsNew then
            local CharData = DataMgr.Char[ItemId]
            local RegainItemId = CharData and CharData.RegainCharItemId or nil
            local RegainItemCount = CharData and CharData.RegainCharItemNum or nil
            UIManager:LoadUINew(SystemUIName,"Resource", RegainItemId, RegainItemCount, PurchaseRewards, func, ParentWidget,IsReAttachFocusToPage, ToastText)
        else
            UIManager:LoadUINew(SystemUIName,ItemType, ItemId, Count, PurchaseRewards, func, ParentWidget,IsReAttachFocusToPage, ToastText)
        end
    end
    if PurchaseRewards then
        UIUtils.ShowGetCharWeaponPage(PurchaseRewards, ShowFinish, nil, nil, bOnlyItemPage)
    else
        local TargetTable = {}
        TargetTable[ItemType..'s'] = {[ItemId] = Count}
        UIUtils.ShowGetCharWeaponPage(TargetTable, ShowFinish, nil, nil, bOnlyItemPage)
    end
end

---@param TargetTable table      @展示集合{Skins = {},Chars= {},WeaponSkins = {},Weapons = {}}
---@param CallbackFunc function  @关闭弹窗的回调
---@param ParentWidget Widget    @打开弹窗的控件
---@param bGacha boolean            @是否是抽卡
function UIUtils.ShowGetCharWeaponPage(TargetTable, CallbackFunc, ParentWidget,bGacha, bOnlyItemPage)
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    local ShowSort = {
        {   
            ShowType = CommonConst.DataType.Skin ,
            UIName = "GetCharPage",
        },
        {
            ShowType = CommonConst.DataType.Char ,
            UIName = "GetCharPage",
        },
        {
            ShowType = CommonConst.DataType.WeaponSkin ,
            UIName = "GetWeaponPage",
        },
        {
            ShowType = CommonConst.DataType.Weapon ,
            UIName = "GetWeaponPage",
        },
        {
            ShowType = CommonConst.DataType.Resource ,
            UIName = "GetCharPage",
        },
    }
    local AsyncFunc = coroutine.create(function()
        local co = coroutine.running()
        for _, ShowData in ipairs(ShowSort) do
            local ShowType = ShowData.ShowType
            local TargetList
            if TargetTable then
                TargetList = TargetTable[ShowType..'s']
            end

            if bOnlyItemPage then
                TargetList = nil
            end
            
            if TargetList and next(TargetList) then
                local ShowTargetList = {}
                for Id, Count in pairs(TargetList) do
                    local NeedInsert = true
                    if ShowType == CommonConst.DataType.Resource
                        and not ItemUtils.CheckGestureItemResourceNeedDisplay(Id) then
                        NeedInsert = false
                    end
                    if ShowType == CommonConst.DataType.Skin
                    and not ItemUtils.CheckGestureSkinNeedDisplay(Id) then
                        NeedInsert = false
                    end
                    if NeedInsert then
                        if bGacha then
                            for i = 1,Count,1 do
                                table.insert(ShowTargetList, Id)
                            end
                        else
                            table.insert(ShowTargetList, Id)
                        end
                    end
                end
                if ShowTargetList and next(ShowTargetList) then
                    local ShowTargetParams = {
                        TargetIdList = ShowTargetList,
                        TargetType = ShowType,
                        CallbackFunc = function()
                            coroutine.resume(co)
                        end,
                        bGacha = bGacha,
                    }
                    UIManager:LoadUINew(ShowData.UIName,ShowTargetParams)
                    coroutine.yield()
                end
            end
        end
        if CallbackFunc then
            CallbackFunc(ParentWidget)
        end
    end)
    coroutine.resume(AsyncFunc)
end


---@param ItemType string   @单个物品的类型
---@param ItemId number     @单个物品的Id
---@param Count number      @单个物品的数量
---@param PurchaseRewards table @服务器的RewardBox结构
---@param bSpecial boolean      @是否使用特殊弹窗
---@param func function         @关闭弹窗的回调
---@param ParentWidget Widget   @打开弹窗的控件
---@param IsReAttachFocusToPage boolean  @是否重新AttachFocus到打开的UI
function UIUtils.ShowGetItemPageAndOpenBagIfNeeded(ItemType, ItemId, Count, PurchaseRewards, bSpecial, func, ParentWidget, IsReAttachFocusToPage, bOnlyItemPage, bIsNew, ToastText)
    local needOpenBag = false
    local OpenBagId = nil
    local ToastText = ToastText or nil
    local bHasGestureItem = false
    if PurchaseRewards and PurchaseRewards["Resources"] then
        for Id, resource in pairs(PurchaseRewards["Resources"]) do
            local RewardData = DataMgr.Resource[Id]
            if RewardData and RewardData.MaterialClassify == BagCommon.ItemTypeToTabId.ConsumableItem then
                needOpenBag = true
                OpenBagId = tostring(Id)
            end
            if RewardData and RewardData.ResourceSType == "GestureItem" then
                bHasGestureItem = true
            end
        end
    elseif ItemId then
        local RewardData = DataMgr.Resource[ItemId]
        if RewardData and RewardData.MaterialClassify == BagCommon.ItemTypeToTabId.ConsumableItem then
            needOpenBag = true
            OpenBagId = tostring(ItemId)
        end
        if RewardData and RewardData.ResourceSType == "GestureItem" then
            bHasGestureItem = true
        end
    end
    if bHasGestureItem and ToastText == nil then
        ToastText = GText("UI_GestureItem_Goto_Bag")
    end
    local callback = function()
        if needOpenBag then
            local Params = {}
            Params.LeftCallbackFunction = func
            Params.RightCallbackFunction = function (Obj, Result, PopUI)
                UIUtils.OpenSystem(2,false,BagCommon.ItemTypeToTabId.ConsumableItem,OpenBagId)
            end
            local UIManager = GWorld.GameInstance:GetGameUIManager()
            UIManager:ShowCommonPopupUI(100250, Params)
        else
            if func then
                func()
            end
        end
    end
    UIUtils.ShowGetItemPage(ItemType, ItemId, Count, PurchaseRewards, bSpecial, callback, ParentWidget, IsReAttachFocusToPage, bOnlyItemPage, bIsNew, ToastText)
end


--- 获取通用拖拽UI数据的类
---@return TSubclassOf<CommonDragDropOperation_C>
function UIUtils.GetCommonDragDropOperationClass()
    if not UIUtils._DragDropOperationClass then
        UIUtils._DragDropOperationClass = MiscUtils.LazyLoadClass('/Game/UI/Blueprint/CommonDragDropOperation.CommonDragDropOperation_C', true)
    end
    return UIUtils._DragDropOperationClass:get()
end

--region ListView相关的公共方法
--- 获取通用列表数据项的类
---@return TSubclassOf<CommonItemContent_C>
function UIUtils.GetCommonItemContentClass()
    if(not UIUtils._ItemObjectClass) then
        UIUtils._ItemObjectClass = MiscUtils.LazyLoadClass('/Game/UI/Blueprint/CommonItemContent.CommonItemContent_C', true)
    end
    return UIUtils._ItemObjectClass:get()
end

---计算ListView的最大ScrollOffset，要求ListView每个格子尺寸相同
function UIUtils.GetMaxScrollOffsetOfListView(ListView)
    local ItemUIs = ListView:GetDisplayedEntryWidgets()
    if(ItemUIs:Length()==0) then return 0 end
    local ItemSize = UIManager(ListView):GetWidgetRenderSize(ItemUIs:GetRef(1))
    local ListSize = UIManager(ListView):GetWidgetRenderSize(ListView)
    if ListSize == 0 then 
        ListView:ForceLayoutPrepass()
        ListSize = UIManager:GetWidgetRenderSize(ListView)
    end
    local ItemNum = ListView:GetNumItems()
    local MaxScrollOffset = 0
    if ListView.Orientation == EOrientation.Orient_Horizontal then 
        MaxScrollOffset = ((ItemNum-1)*ListView.EntrySpacing + ItemNum*ItemSize.X - ListSize.X)/ItemSize.X
    elseif ListView.Orientation == EOrientation.Orient_Vertical then 
        MaxScrollOffset = ((ItemNum-1)*ListView.EntrySpacing + ItemNum*ItemSize.Y - ListSize.Y)/ItemSize.Y
    end
    return MaxScrollOffset
end

local CountPad = 0.05

---@deprecated
---(做空格填充则不推荐，最好使用RequestFillEmptyContent)
---计算ListView的显示窗口内可以填充Item的最大个数，有考虑到EntrySpacing，结果准确
---@param ListView UListView ListView控件
---@param ItemUIs TArray<UWidget> 通过ListView:GetDisplayedEntryWidgets获取的列表
---@param bDontChangeScrollbar boolean 是否不改变滑动条的可见性
---@param bDontSetEmptyGridItemCount boolean 是否不设置无法导航的空格个数（设置了之后会导致空格无法被导航到）
---@return number
function UIUtils.GetListViewContentMaxCount(ListView, ItemUIs, bDontChangeScrollbar, bDontSetEmptyGridItemCount)
    if not ListView:IsVisible() then 
        Utils.Traceback(WarningTag, LXYTag.."UIUtils.GetListViewContentMaxCount：ListView必须是可见的")
        return 0
    end
    if not ItemUIs then 
        ItemUIs = ListView:GetDisplayedEntryWidgets()
    end
    if ItemUIs:Length()==0 then
        Utils.Traceback(WarningTag, LXYTag.."UIUtils.GetListViewContentMaxCount：ListView必须先生成一个ItemUI才能准确计算个数")
        return 0
    end
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local ListSize = UIManager:GetWidgetRenderSize(ListView)
    local Parent = ListView:GetParent()
    if Parent:Cast(UScrollBox) then
        ListSize = UIManager:GetWidgetRenderSize(Parent)
    end
    local ItemSize = UIManager:GetWidgetRenderSize(ItemUIs:GetRef(1).WidgetTree.RootWidget)
    if ListView.Orientation == EOrientation.Orient_Horizontal then 
        ListSize,ItemSize = ListSize.X,ItemSize.X + ListView.EntrySpacing
    elseif ListView.Orientation == EOrientation.Orient_Vertical then 
        ListSize,ItemSize = ListSize.Y,ItemSize.Y + ListView.EntrySpacing
    end
    local RawCount = (ListSize/ItemSize)-(ListView.EntrySpacing/ItemSize)
    local Count = math.ceil(RawCount-CountPad)
    if bDontChangeScrollbar then
        ListView:SetScrollbarVisibility(UIConst.VisibilityOp.Collapsed)
    else
        ListView:SetScrollbarVisibility(UIConst.VisibilityOp.Hidden)
    end
    if ListView.SetControlScrollbarInside then
        ListView:SetControlScrollbarInside(false)
    end

    local CurItemCount = ListView:GetNumItems()
    if (Count-RawCount>CountPad  and not bDontChangeScrollbar) or CurItemCount>Count then
        if ListView.SetControlScrollbarInside then
            ListView:SetControlScrollbarInside(true)
        end
    end
    if CommonUtils.GetDeviceTypeByPlatformName()=="Mobile" and ListView.bControlScrollbarInside then
        if ListView.SetControlScrollbarInside then
            ListView:SetControlScrollbarInside(false)
        end
        ListView:SetScrollbarVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end

    if (CurItemCount > 0) then
        local EmptyItemNum = not bDontSetEmptyGridItemCount and math.max(0, Count - CurItemCount) or 0
        ListView:SetEmptyGridItemCount(EmptyItemNum)
    else
        DebugPrint(ErrorTag,"GetListViewContentMaxCount: 当前列表没有填充过Item, 请手动调用列表的SetEmptyGridItemCount来设置空态格子数")
    end

    DebugPrint("ListViewCount", RawCount,Count)
    return Count
end

---@deprecated
---(做空格填充则不推荐，最好使用RequestFillEmptyContent)
---计算TileView的显示窗口内可以填充Item的最大个数，有考虑到滑动条尺寸，结果准确
---@param TileView UTileView
---@param Option  "'X'" | "'Y'" | "'XY'" | "nil"
---@param bDontChangeScrollbar boolean 是否不改变滑动条的可见性
---@param bDontSetEmptyGridItemCount boolean 是否不设置无法导航的空格个数（设置了之后会导致空格无法被导航到）
---@return number
function UIUtils.GetTileViewContentMaxCount(TileView, Option, bDontChangeScrollbar, bDontSetEmptyGridItemCount)
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local ListSize = UIManager:GetWidgetRenderSize(TileView)
    local Parent = TileView:GetParent()
    if Parent:Cast(UScrollBox) then
        ListSize = UIManager:GetWidgetRenderSize(Parent)
    end
    local ListSizeX,ItemSizeX = ListSize.X,TileView:GetEntryWidth()
    local ListSizeY,ItemSizeY = ListSize.Y,TileView:GetEntryHeight()

    local XCount, YCount = 0,0
    if bDontChangeScrollbar then
        TileView:SetScrollbarVisibility(ESlateVisibility.Collapsed)
    else    
        TileView:SetScrollbarVisibility(ESlateVisibility.Hidden)
    end
    if TileView.SetControlScrollbarInside then
        TileView:SetControlScrollbarInside(false)
    end
    if (TileView.Orientation == EOrientation.Orient_Horizontal) then
        --Horizontal只有一行，且滑动条尺寸不会挤兑格子生成，故不考虑
        local RawXCount = (ListSizeX/ItemSizeX)
        XCount = math.ceil(RawXCount -CountPad )
        if  (XCount-RawXCount>CountPad  and not bDontChangeScrollbar) then
            if TileView.SetControlScrollbarInside then
                TileView:SetControlScrollbarInside(true)
            end
        end
        YCount = 1
    elseif (TileView.Orientation == EOrientation.Orient_Vertical) then
        local ScrollBarSize = TileView.ScrollBarDesireSize
        XCount = math.floor((ListSizeX-ScrollBarSize)/ItemSizeX)
        local RawYCount = (ListSizeY/ItemSizeY)
        YCount = math.ceil(RawYCount -CountPad)
        DebugPrint("TileViewCount", RawYCount,YCount)
        if (YCount-RawYCount>CountPad and not bDontChangeScrollbar) then
            if TileView.SetControlScrollbarInside then
                TileView:SetControlScrollbarInside(true)
            end
        end
    end
    if TileView:GetNumItems()>XCount*YCount then
        if TileView.SetControlScrollbarInside then
            TileView:SetControlScrollbarInside(true)
        end
    end
    if CommonUtils.GetDeviceTypeByPlatformName()=="Mobile" and TileView.bControlScrollbarInside then
        if TileView.SetControlScrollbarInside then
            TileView:SetControlScrollbarInside(false)
        end
        TileView:SetScrollbarVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    local CurItemCount = TileView:GetNumItems()
    if (CurItemCount > 0) then
        local EmptyItemNum = 0
        if (not bDontSetEmptyGridItemCount) then
            if (CurItemCount - XCount * YCount <= 0) then
                EmptyItemNum = XCount * YCount - CurItemCount
            else
                EmptyItemNum = XCount - CurItemCount % XCount
            end
        end
        TileView:SetEmptyGridItemCount(EmptyItemNum)
    else
        DebugPrint(ErrorTag,"GetTileViewContentMaxCount: 当前列表没有填充过Item, 请手动调用列表的SetEmptyGridItemCount来设置空态格子数")
    end

    if (not Option) then
        return XCount*YCount
    elseif Option == "X" then
        return XCount
    elseif Option == "Y" then
        return YCount
    elseif Option == "XY" then
        return XCount, YCount
    end
    assert(false,"UIUtils.GetTileViewContentMaxCount: Option参数错误")
end

---@deprecated
---(不推荐，最好使用RequestPlayEntriesAnim)
--- ListView格子播放In动画接口
---@alias PlayListViewFramingInAnimation_Params {Interval:number, AnimName:string, Visibility:number, ListViewOpacity:number, bInteractableInAnim:boolean, Callback:fun():void, }
---@param UIState BP_UIState|TimerMgr UIState
---@param ListView UListViewBase ListView
---@param Params PlayListViewFramingInAnimation_Params 额外可选参数
---@return Deque<string> TimerKeys 如果需要打断动画，需要缓存这里产生的定时器Keys
function UIUtils.PlayListViewFramingInAnimation(UIState, ListView, Params)
    Params = Params or {Interval = nil, AnimName = nil, Visiblity = nil, Callback = nil, ListViewOpacity = nil, bInteractableInAnim = nil}
    local Interval = (Params.Interval~=nil and Params.Interval~=0) and Params.Interval or 0.0333
    local AnimName = Params.AnimName~=nil and Params.AnimName or "In"
    local TimerKeys = Deque.New()
    ListView:SetRenderOpacity(0)
    if Params.bInteractableInAnim == false then
        ListView:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end
	local _,TimerKey = UIState:AddTimer(0.01,function()
        ListView:SetRenderOpacity(Params.ListViewOpacity or 1)
		local DisplayedEntries = ListView:GetDisplayedEntryWidgets()
        local NumPerLine = 1
        if ListView:IsA(UTileView) and ListView.GetNumItemsPerLine then
            NumPerLine = ListView:GetNumItemsPerLine()
        end
        local ColunmCount = math.floor(DisplayedEntries:Num()/NumPerLine)
	    for i=1,ColunmCount do
            local LineWidgets = {}
            local VisitedCount = (i-1)*NumPerLine
            for j=1, NumPerLine do
                ---@type Armory_Mod_Polarity_Item
                local Entry = DisplayedEntries:GetRef(VisitedCount +j)
                Entry:StopAnimation(Entry[AnimName])
                Entry:SetVisibility(UIConst.VisibilityOp.Collapsed)
                table.insert(LineWidgets, Entry)
            end
            local _,TimerKey = nil,nil
            _,TimerKey = UIState:AddTimer(i * Interval, function()
                local Visiblity = Params.Visibility~=nil and Params.Visibility or UIConst.VisibilityOp.Visible
                for _, Entry in ipairs(LineWidgets) do
                    Entry:SetVisibility(Visiblity)
                    Entry:StopAllAnimations()
                    Entry:PlayAnimation(Entry[AnimName])
                end
                TimerKeys:PopFront()
                if TimerKeys:IsEmpty() then 
                    if Params.bInteractableInAnim == false then
                        ListView:SetVisibility(UIConst.VisibilityOp.Visible)
                    end
                    if Params.Callback then Params.Callback() end
                end
            end, false,0,nil,true)
            TimerKeys:PushBack(TimerKey)
	    end
        TimerKeys:PopFront()
	end,false,0,nil,true)
	TimerKeys:PushBack(TimerKey)
    return TimerKeys
end

---@deprecated
---(不推荐，最好使用RequestPlayEntriesAnim)
--- 隐藏ListView的所有Entry
--- 建议在界面的关闭动画结束后，与PlayListViewFramingInAnimation成对调用，还原Entry的初始状态以待下次再播放In动画
---@alias StopListViewFramingInAnimation_Params {UIState:BP_UIState, TimerKeys: Deque<string>,Visibility:number}
---@param ListView UListViewBase
---@param Params StopListViewFramingInAnimation_Params 可选参数
function UIUtils.StopListViewFramingInAnimation(ListView, Params)
    Params = Params or {UIState=nil, TimerKeys=nil,Visibility = UIConst.VisibilityOp.Visible}
    ListView:SetRenderOpacity(0)
    local DisplayedEntries = ListView:GetDisplayedEntryWidgets()
    for i=1,DisplayedEntries:Length() do
        ---@type Armory_Mod_Polarity_Item
        local Entry = DisplayedEntries:GetRef(i)
        ---强行将列表格子的动画状态重置为normal
        if Entry["Normal"] then
            Entry:PlayAnimationForward(Entry.Normal,10000)
        end
        Entry:SetVisibility(Params.Visibility and Params.Visibility or UIConst.VisibilityOp.Visible)
    end
    ---结束PlayListViewFramingInAnimation产生的定时器，用来打断之前播放的动画
    if not Params.TimerKeys or not Params.UIState then return end
    for _, TimerKey in ipairs(Params.TimerKeys:ToArr()) do
        if Params.UIState:IsExistTimer(TimerKey) then
            Params.UIState:RemoveTimer(TimerKey,true)
        end
    end
end
--endregion

--region ListView和ScrollBox的红点超屏提示的相关接口

--- 更新ListView边缘提示（红点和NEW标志），当内容超出屏幕范围时显示提示；
--- 此函数不依赖当前正在显示的特定条目，而是每次调用通过遍历整个列表项计算是否需要显示提示。
---@param ListView UEMListView(不支持UEMScrollBox) 目标List,不可为nil
---@param List_FrontRedDot WBP_Com_List_RedDot 列表顶部的红点,可为nil
---@param List_BackRedDot WBP_Com_List_RedDot 列表底部的红点,可为nil
---@param List_FrontNew WBP_Com_List_New 列表顶部的NEW标志,可为nil
---@param List_BackNew WBP_Com_List_New 列表底部的NEW标志,可为nil
---@param ReddotAndNewCalFunc function 每种ListView的Item是否有红点和NEW的自定义计算函数,参数固定为每个Item初始化的Content
function UIUtils.UpdateListReddot(ListView, List_FrontRedDot, List_BackRedDot, List_FrontNew, List_BackNew, ReddotAndNewCalFunc)
    if not ListView then return end
    local PartialStart = TArray(UObject)
    local FullyVisible = TArray(UObject)
    local PartialEnd = TArray(UObject)
    ListView:GetEntryWidgetsVisibilityState(PartialStart, FullyVisible, PartialEnd)
    PartialStart = PartialStart:ToTable()
    FullyVisible = FullyVisible:ToTable()
    PartialEnd = PartialEnd:ToTable()
    local AllItems = ListView:GetListItems():ToTable()
    if #AllItems == 0 then return end
    local function GetWidgetContentArray(widgets)
        local result = {}
        for _, w in ipairs(widgets) do
            if w.Content then table.insert(result, w.Content) end
        end
        return result
    end
    local PartiallyOutOfStartItems = GetWidgetContentArray(PartialStart)
    local FullyVisibleItems = GetWidgetContentArray(FullyVisible)
    local PartiallyOutOfEndItems = GetWidgetContentArray(PartialEnd)
    local function GetItemIndex(Item)
        for i, v in ipairs(AllItems) do
            if v == Item then return i end
        end
        return nil
    end
    local TopIndex = 1
    local BottomIndex = #AllItems
    if #FullyVisibleItems > 0 or #PartiallyOutOfStartItems > 0 or #PartiallyOutOfEndItems > 0 then
        local TopItem = PartiallyOutOfStartItems[1] or FullyVisibleItems[1] or PartiallyOutOfEndItems[1]
        local BottomItem = PartiallyOutOfEndItems[#PartiallyOutOfEndItems] or FullyVisibleItems[#FullyVisibleItems] or PartiallyOutOfStartItems[#PartiallyOutOfStartItems]
        local function GetIndexByItem(Item)
            for i, v in ipairs(AllItems) do
                if v == Item then return i end
            end
            return nil
        end
        TopIndex = TopItem and GetIndexByItem(TopItem) or 1
        BottomIndex = BottomItem and GetIndexByItem(BottomItem) or #AllItems
    end
    local FullyOutOfStartItems = {}
    local FullyOutOfEndItems = {}
    for i, item in ipairs(AllItems) do
        if TopIndex and i < TopIndex then
            table.insert(FullyOutOfStartItems, item)
        elseif BottomIndex and i > BottomIndex then
            table.insert(FullyOutOfEndItems, item)
        end
    end
    local FrontIndicatorItems = {}
    for _, v in ipairs(FullyOutOfStartItems) do table.insert(FrontIndicatorItems, v) end
    for _, v in ipairs(PartiallyOutOfStartItems) do table.insert(FrontIndicatorItems, v) end

    local BackIndicatorItems = {}
    for _, v in ipairs(FullyOutOfEndItems) do table.insert(BackIndicatorItems, v) end
    local bHasFrontReddot, bHasBackReddot = false, false
    local bHasFrontNew, bHasBackNew = false, false
    local function CheckIndicators(ItemList)
        for _, item in ipairs(ItemList) do
            local hasRed, hasNew = false, false
            if ReddotAndNewCalFunc then
                hasRed, hasNew = ReddotAndNewCalFunc(item)
            end
            local idx = GetItemIndex(item)
            if idx and TopIndex and BottomIndex then
                if idx <= TopIndex then
                    if hasRed then bHasFrontReddot = true end
                    if hasNew and not hasRed then bHasFrontNew = true end
                elseif idx >= BottomIndex then
                    if hasRed then bHasBackReddot = true end
                    if hasNew and not hasRed then bHasBackNew = true end
                end
            end
        end
    end
    CheckIndicators(FrontIndicatorItems)
    CheckIndicators(BackIndicatorItems)
    local FrontAnim = "Loop_T"
    local BackAnim = "Loop_D"
    if ListView.Orientation == UE.EOrientation.Orient_Horizontal then 
        FrontAnim = "Loop_L"
        BackAnim = "Loop_R"
    end
    local function SetListIndicator(Widget, bVisible, AnimName)
        if not Widget then return end
        local AnimObject = Widget[AnimName]
        if bVisible then
            Widget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            if AnimObject and not Widget:IsAnimationPlaying(AnimObject) then
                Widget:PlayAnimation(AnimObject, 0, 0)
            end
        else
            Widget:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end

    SetListIndicator(List_FrontRedDot, bHasFrontReddot, FrontAnim)
    SetListIndicator(List_FrontNew, not bHasFrontReddot and bHasFrontNew, FrontAnim)
    SetListIndicator(List_BackRedDot, bHasBackReddot, BackAnim)
    SetListIndicator(List_BackNew, not bHasBackReddot and bHasBackNew, BackAnim)
end


--- 更新ScrollBox边缘提示（红点和NEW标志），当内容超出屏幕范围时显示提示；
--- 此函数不依赖当前正在显示的特定条目，而是每次调用通过遍历整个列表项计算是否需要显示提示。
---@param TargetScrollBox UEMScrollBox 目标ScrollBox,不可为nil
---@param ScrollBox_FrontRedDot WBP_Com_List_RedDot 列表顶部的红点,可为nil
---@param ScrollBox_BackRedDot WBP_Com_List_RedDot 列表底部的红点,可为nil
---@param ScrollBox_FrontNew WBP_Com_List_New 列表顶部的NEW标志,可为nil
---@param ScrollBox_BackNew WBP_Com_List_New 列表底部的NEW标志,可为nil
---@param ReddotAndNewCalFunc function 每种ScrollBox的Child是否有红点和NEW的自定义计算函数,参数固定为每个ChildWdiget，每个ScrollBox仅支持一种计算方式
function UIUtils.UpdateScrollBoxReddot(TargetScrollBox, ScrollBox_FrontRedDot, ScrollBox_BackRedDot, ScrollBox_FrontNew, ScrollBox_BackNew,ReddotAndNewCalFunc)
    if not TargetScrollBox then return end
    local OutFullyOutOfStartArray = TArray(UObject)
    local OutPartiallyOutOfStartArray = TArray(UObject)
    local OutFullyVisibleArray = TArray(UObject)
    local OutPartiallyOutOfEndArray = TArray(UObject)
    local OutFullyOutOfEndArray = TArray(UObject)
    TargetScrollBox:GetChildWidgetsPosInScrollBox(OutFullyOutOfStartArray,OutPartiallyOutOfStartArray,OutFullyVisibleArray,OutPartiallyOutOfEndArray,OutFullyOutOfEndArray)
    -- local tbFullyVisible = OutFullyVisibleArray:ToTable()
    -- local tbPartiallyOutOfEnd = OutPartiallyOutOfEndArray:ToTable()
    local bHasFrontReddot = false
    local bHasBackReddot = false
    local bHasFrontNew = false
    local bHasBackNew = false
    local function CalbHas(TargetTable)
        local HasReddot = false
        local HasNew = false
        for _, Widget in pairs(TargetTable) do
            local bHasReddot, bHasNew
            if ReddotAndNewCalFunc ~= nil then
                bHasReddot, bHasNew = ReddotAndNewCalFunc(Widget)
            else
                bHasReddot, bHasNew = false, false
            end
            if bHasReddot then
                HasReddot = true
            end
            if bHasNew then
                HasNew = true
            end
        end
        return HasReddot,HasNew
    end
    local TableHasReddot = false
    local TableHasNew = false
    TableHasReddot,TableHasNew = CalbHas(OutFullyOutOfStartArray:ToTable())--完全超出前端ScrollBox的table有红点和new
    if TableHasReddot then bHasFrontReddot = true end
    if TableHasNew then bHasFrontNew = true end
    TableHasReddot,TableHasNew = CalbHas(OutPartiallyOutOfStartArray:ToTable())--部分超出前端ScrollBox的table有红点和new
    if TableHasReddot then bHasFrontReddot = true end
    if TableHasNew then bHasFrontNew = true end
    TableHasReddot,TableHasNew = CalbHas(OutFullyOutOfEndArray:ToTable())--完全超出后端ScrollBox的table有红点和new
    if TableHasReddot then bHasBackReddot = true end
    if TableHasNew then bHasBackNew = true end

    local FrontAnim = "Loop_T"
    local BackAnim = "Loop_D"
    if TargetScrollBox.Orientation == EOrientation.Orient_Horizontal then 
        FrontAnim = "Loop_L"
        BackAnim = "Loop_R"
    end

    local function SetListIndicator(Widget, bVisible, AnimName)
        if not Widget then return end
        local AnimObject = Widget[AnimName]
        if bVisible then
            --print("lgc@ bVisible",Widget:GetName())
            Widget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            if AnimObject and (not Widget:IsAnimationPlaying(AnimObject)) then
                Widget:PlayAnimation(AnimObject, 0, 0)
            end
        else
            Widget:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end
    print("lgc@ :",
        "bHasFrontReddot",tostring(bHasFrontReddot),"bHasBackReddot",tostring(bHasBackReddot),
        "bHasFrontNew",tostring(bHasFrontNew),"bHasBackNew",tostring(bHasBackNew))
    --Front
    if ScrollBox_FrontRedDot then
        SetListIndicator(ScrollBox_FrontRedDot, bHasFrontReddot, FrontAnim)
    end
    if ScrollBox_FrontNew then
        local showTopNew = (not bHasFrontReddot) and bHasFrontNew
        SetListIndicator(ScrollBox_FrontNew, showTopNew, FrontAnim)
    end
    --Back
    if ScrollBox_BackRedDot then
        SetListIndicator(ScrollBox_BackRedDot, bHasBackReddot, BackAnim)
    end
    if ScrollBox_BackNew then
        local showBottomNew = (not bHasBackReddot) and bHasBackNew
        SetListIndicator(ScrollBox_BackNew, showBottomNew, BackAnim)
    end
end

--- 更新ScrollBox边缘提示（Arrow标志），当内容超出屏幕范围时显示提示；
---@param ScrollBox UEMScrollBox 目标ScrollBox,不可为nil
---@param List_ArrowTop WBP_Com_List_Arrow 列表顶部的箭头,可为nil
---@param List_ArrowBottom WBP_Com_List_Arrow 列表底部的箭头,可为nil
---@param MaxOffset number 最大偏移量阈值,当距离前端或后端小于等于此值时隐藏箭头,可为nil
function UIUtils.UpdateScrollBoxArrow(ScrollBox, List_ArrowTop, List_ArrowBottom, MaxOffset)
    if not ScrollBox then return end
    local Offset = ScrollBox:GetScrollOffset()
    local EndOffset = ScrollBox:GetScrollOffsetOfEnd()
    MaxOffset = MaxOffset or 0
    if List_ArrowTop then
        if Offset > 0 and Offset > MaxOffset then
            List_ArrowTop:SetVisibility(ESlateVisibility.Visible)
        else
            List_ArrowTop:SetVisibility(ESlateVisibility.Collapsed)
        end
    end
    if List_ArrowBottom then
        local DistanceToEnd = EndOffset - Offset
        if Offset < EndOffset and DistanceToEnd > MaxOffset then
            List_ArrowBottom:SetVisibility(ESlateVisibility.Visible)
        else
            List_ArrowBottom:SetVisibility(ESlateVisibility.Collapsed)
        end
    end
end

--- 更新ListView边缘提示（Arrow标志），当内容超出屏幕范围时显示提示；
---@param ListView UEMListView 目标List,不可为nil
---@param List_ArrowTop WBP_Com_List_Arrow 列表顶部的箭头,可为nil
---@param List_ArrowBottom WBP_Com_List_Arrow 列表底部的箭头,可为nil
function UIUtils.UpdateListArrow(ListView, List_ArrowTop, List_ArrowBottom)
    if not ListView then return end
    local DisplayedWidgets = ListView:GetDisplayedEntryWidgets():ToTable()
    local ListItems = ListView:GetListItems():ToTable()
    if #DisplayedWidgets == 0 or #ListItems == 0 then
        if List_ArrowTop then
            List_ArrowTop:SetVisibility(ESlateVisibility.Collapsed)
        end
        if List_ArrowBottom then
            List_ArrowBottom:SetVisibility(ESlateVisibility.Collapsed)
        end
        return
    end
    local VisibleIndexMin = 100000
    local VisibleIndexMax = -1
    for _, Widget in ipairs(DisplayedWidgets) do
        local ItemObject = Widget.Content
        local Index = ListView:GetIndexForItem(ItemObject)
        if Index then
            VisibleIndexMin = math.min(VisibleIndexMin, Index)
            VisibleIndexMax = math.max(VisibleIndexMax, Index)
        end
    end
    if List_ArrowTop then
        local bShowTopArrow = VisibleIndexMin > 0
        List_ArrowTop:SetVisibility(bShowTopArrow and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
    end
    if List_ArrowBottom then
        local bShowBottomArrow = VisibleIndexMax < (#ListItems - 1)
        List_ArrowBottom:SetVisibility(bShowBottomArrow and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
    end
end

--- 更新ListView边缘提示（红点和Arrow标志），当内容超出屏幕范围时显示提示；
--- 此函数不依赖当前正在显示的特定条目，而是每次调用通过遍历整个列表项计算是否需要显示提示。
---@param ListView UEMListView(不支持UEMScrollBox) 目标List,不可为nil
---@param List_FrontRedDot WBP_Com_List_RedDot 列表顶部的红点,可为nil
---@param List_BackRedDot WBP_Com_List_RedDot 列表底部的红点,可为nil
---@param List_ArrowTop WBP_Com_List_Arrow 列表顶部的箭头,可为nil
---@param List_ArrowBottom WBP_Com_List_Arrow 列表底部的箭头,可为nil
---@param ReddotCalFunc function 每种ListView的Item是否有红点的自定义计算函数,参数固定为每个Item初始化的Content
function UIUtils.UpdateListArrowAndReddot(ListView, List_FrontRedDot, List_BackRedDot, List_ArrowTop, List_ArrowBottom, ReddotCalFunc)
    if not ListView then return end
    local TargetList = ListView

    local PartialStart = TArray(UObject)
    local FullyVisible = TArray(UObject)
    local PartialEnd = TArray(UObject)
    ListView:GetEntryWidgetsVisibilityState(PartialStart, FullyVisible, PartialEnd)
    PartialStart = PartialStart:ToTable()
    FullyVisible = FullyVisible:ToTable()
    PartialEnd = PartialEnd:ToTable()
    local ListItems = ListView:GetListItems():ToTable()
    if #ListItems == 0 then return end
    local function GetWidgetContentArray(widgets)
        local result = {}
        for _, w in ipairs(widgets) do
            if w.Content then table.insert(result, w.Content) end
        end
        return result
    end
    local PartiallyOutOfStartItems = GetWidgetContentArray(PartialStart)
    local FullyVisibleItems = GetWidgetContentArray(FullyVisible)
    local PartiallyOutOfEndItems = GetWidgetContentArray(PartialEnd)
    local function GetItemIndex(Item)
        for i, v in ipairs(ListItems) do
            if v == Item then return i end
        end
        return nil
    end
    table.sort(PartiallyOutOfStartItems, function(a, b) return GetItemIndex(a) < GetItemIndex(b) end)
    table.sort(PartiallyOutOfEndItems, function(a, b) return GetItemIndex(a) > GetItemIndex(b) end)
    
    local TopItem = nil
    local TopIndex = 1
    local BottomItem = nil
    local BottomIndex = #ListItems
    if #FullyVisibleItems > 0 or #PartiallyOutOfStartItems > 0 or #PartiallyOutOfEndItems > 0 then
        TopItem = PartiallyOutOfStartItems[1] or FullyVisibleItems[1] or PartiallyOutOfEndItems[1]
        BottomItem = PartiallyOutOfEndItems[1] or FullyVisibleItems[#FullyVisibleItems] or PartiallyOutOfStartItems[1]
        TopIndex = TopItem and GetItemIndex(TopItem) or 1
        BottomIndex = BottomItem and GetItemIndex(BottomItem) or #ListItems
    end
    local FullyOutOfStartItems = {}
    local FullyOutOfEndItems = {}
    for i, item in ipairs(ListItems) do
        if TopIndex and i < TopIndex then
            table.insert(FullyOutOfStartItems, item)
        elseif BottomIndex and i > BottomIndex then
            table.insert(FullyOutOfEndItems, item)
        end
    end
    local FrontIndicatorItems = {}
    for _, v in ipairs(FullyOutOfStartItems) do table.insert(FrontIndicatorItems, v) end
    for _, v in ipairs(PartiallyOutOfStartItems) do table.insert(FrontIndicatorItems, v) end
    local BackIndicatorItems = {}
    for _, v in ipairs(FullyOutOfEndItems) do table.insert(BackIndicatorItems, v) end
    local bHasFrontReddot, bHasBackReddot = false, false
    local function CheckIndicators(ItemList)
        for _, item in ipairs(ItemList) do
            local hasRed = false, false
            if ReddotCalFunc then
                hasRed = ReddotCalFunc(item)
            end
            local idx = GetItemIndex(item)
            if idx and TopIndex and BottomIndex then
                if idx <= TopIndex then
                    if hasRed then bHasFrontReddot = true end
                elseif idx >= BottomIndex then
                    if hasRed then bHasBackReddot = true end
                end
            end
        end
    end
    CheckIndicators(FrontIndicatorItems)
    CheckIndicators(BackIndicatorItems)

    if not FullyVisible or #FullyVisible <= 3 then 
        -- 隐藏所有指示器
        if List_FrontRedDot then List_FrontRedDot:SetVisibility(ESlateVisibility.Collapsed) end
        if List_BackRedDot then List_BackRedDot:SetVisibility(ESlateVisibility.Collapsed) end
        if List_ArrowTop then List_ArrowTop:SetVisibility(ESlateVisibility.Collapsed) end
        if List_ArrowBottom then List_ArrowBottom:SetVisibility(ESlateVisibility.Collapsed) end
        return
    end
    if not ListItems or #ListItems == 0 then 
        -- 隐藏所有指示器
        if List_FrontRedDot then List_FrontRedDot:SetVisibility(ESlateVisibility.Collapsed) end
        if List_BackRedDot then List_BackRedDot:SetVisibility(ESlateVisibility.Collapsed) end
        if List_ArrowTop then List_ArrowTop:SetVisibility(ESlateVisibility.Collapsed) end
        if List_ArrowBottom then List_ArrowBottom:SetVisibility(ESlateVisibility.Collapsed) end
        return
    end
    if #FullyVisible >= #ListItems then 
        -- 所有项目都可见，隐藏所有指示器
        if List_FrontRedDot then List_FrontRedDot:SetVisibility(ESlateVisibility.Collapsed) end
        if List_BackRedDot then List_BackRedDot:SetVisibility(ESlateVisibility.Collapsed) end
        if List_ArrowTop then List_ArrowTop:SetVisibility(ESlateVisibility.Collapsed) end
        if List_ArrowBottom then List_ArrowBottom:SetVisibility(ESlateVisibility.Collapsed) end
        return
    end

    local FrontAnim = "Loop_T"
    local BackAnim = "Loop_D"
    if TargetList.Orientation == EOrientation.Orient_Horizontal then 
        FrontAnim = "Loop_L"
        BackAnim = "Loop_R"
    end

    local function SetListIndicator(Widget, bVisible, AnimName)
        if not Widget then return end
        local AnimObject = Widget[AnimName]
        if bVisible then
            Widget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            if AnimObject and (not Widget:IsAnimationPlaying(AnimObject)) then
                Widget:PlayAnimation(AnimObject, 0, 0)
            end
        else
            Widget:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end

    -- 计算箭头显示逻辑
    local bShowTopArrow = TopIndex > 1
    local bShowBottomArrow = BottomIndex < #ListItems
    if not BottomItem or BottomItem.IsEmpty then
        bShowBottomArrow = false
    end

    --Front - 红点优先，没有红点才显示箭头
    if List_FrontRedDot then
        SetListIndicator(List_FrontRedDot, bHasFrontReddot, FrontAnim)
    end
    if List_ArrowTop then
        local bShowArrow = bShowTopArrow and not bHasFrontReddot
        List_ArrowTop:SetVisibility(bShowArrow and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
    end

    --Back - 红点优先，没有红点才显示箭头
    if List_BackRedDot then
        SetListIndicator(List_BackRedDot, bHasBackReddot, BackAnim)
    end
    if List_ArrowBottom then
        local bShowArrow = bShowBottomArrow and not bHasBackReddot
        List_ArrowBottom:SetVisibility(bShowArrow and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
    end
end

--- 一次性绑定ScrollBox的红点和新消息指示器，并添加点击事件处理
--- 在UI初始化时调用一次即可完成所有绑定和跳转逻辑
---@param TargetScrollBox UEMScrollBox 目标ScrollBox,不可为nil
---@param ScrollBox_FrontRedDot WBP_Com_List_RedDot 列表顶部的红点,可为nil
---@param ScrollBox_BackRedDot WBP_Com_List_RedDot 列表底部的红点,可为nil
---@param ScrollBox_FrontNew WBP_Com_List_New 列表顶部的NEW标志,可为nil
---@param ScrollBox_BackNew WBP_Com_List_New 列表底部的NEW标志,可为nil
---@param ReddotAndNewCalFunc function 每种ScrollBox的Child是否有红点和NEW的自定义计算函数,参数固定为每个ChildWdiget，每个ScrollBox仅支持一种计算方式
function UIUtils.BindScrollBoxReddotAndNewClickEvent(TargetScrollBox, ScrollBox_FrontRedDot, ScrollBox_BackRedDot, ScrollBox_FrontNew, ScrollBox_BackNew, ReddotAndNewCalFunc)
    if not TargetScrollBox then return end
    local function BindClickEvent(indicator, isFront, isReddot)
        if not indicator or not indicator.Btn_Click then return end
        indicator.Btn_Click.OnClicked:Clear()
        indicator.Btn_Click.OnHovered:Clear()
        indicator.Btn_Click.OnHovered:Add(TargetScrollBox,function()
            AudioManager(indicator):PlayUISound(nil, "event:/ui/common/red_point_out_bound", nil, nil)
        end)
        indicator.Btn_Click.OnClicked:Add(TargetScrollBox,function()
            AudioManager(indicator):PlayUISound(nil, "event:/ui/common/click_btn_small", nil, nil)
            local OutFullyOutOfStartArray = TArray(UObject)
            local OutPartiallyOutOfStartArray = TArray(UObject)
            local OutFullyVisibleArray = TArray(UObject)
            local OutPartiallyOutOfEndArray = TArray(UObject)
            local OutFullyOutOfEndArray = TArray(UObject)
            TargetScrollBox:GetChildWidgetsPosInScrollBox(
                OutFullyOutOfStartArray, 
                OutPartiallyOutOfStartArray, 
                OutFullyVisibleArray, 
                OutPartiallyOutOfEndArray, 
                OutFullyOutOfEndArray)
            local targetWidgets = {}
            if isFront then
                for _, widget in ipairs(OutFullyOutOfStartArray:ToTable()) do
                    table.insert(targetWidgets, widget)
                end
                for _, widget in ipairs(OutPartiallyOutOfStartArray:ToTable()) do
                    table.insert(targetWidgets, widget)
                end
                for _, widget in ipairs(targetWidgets) do
                    local bHasReddot, bHasNew = ReddotAndNewCalFunc(widget)
                    if (isReddot and bHasReddot) or (not isReddot and bHasNew) then
                        TargetScrollBox:ScrollWidgetIntoView(widget, true)
                        return
                    end
                end
            else
                for _, widget in ipairs(OutPartiallyOutOfEndArray:ToTable()) do
                    table.insert(targetWidgets, widget)
                end
                for _, widget in ipairs(OutFullyOutOfEndArray:ToTable()) do
                    table.insert(targetWidgets, widget)
                end
                for i = #targetWidgets, 1, -1 do
                    local widget = targetWidgets[i]
                    local bHasReddot, bHasNew = ReddotAndNewCalFunc(widget)
                    if (isReddot and bHasReddot) or (not isReddot and bHasNew) then
                        TargetScrollBox:ScrollWidgetIntoView(widget, true)
                        return
                    end
                end
            end
        end)
    end
    BindClickEvent(ScrollBox_FrontRedDot, true, true)
    BindClickEvent(ScrollBox_BackRedDot, false, true)
    BindClickEvent(ScrollBox_FrontNew, true, false)
    BindClickEvent(ScrollBox_BackNew, false, false)
    local function PlayNormalAnim(Target)
        if Target and Target.Normal and Target.PlayAnimation then
            Target:PlayAnimation(Target.Normal)
        end
    end
    PlayNormalAnim(ScrollBox_FrontRedDot)
    PlayNormalAnim(ScrollBox_BackRedDot)
    PlayNormalAnim(ScrollBox_FrontNew)
    PlayNormalAnim(ScrollBox_BackNew)
end


--- 获取ListView中所有Item的可见性状态，包括未实例化的Item
--- 类似于GetChildWidgetsPosInScrollBox，但返回的是Item数组而不是Widget数组
---@param ListView UEMListView 目标ListView,不可为nil
---@param OutFullyOutOfStartArray table 完全超出前端的Item数组
---@param OutPartiallyOutOfStartArray table 部分超出前端的Item数组
---@param OutFullyVisibleArray table 完全可见的Item数组
---@param OutPartiallyOutOfEndArray table 部分超出后端的Item数组
---@param OutFullyOutOfEndArray table 完全超出后端的Item数组
function UIUtils.GetListViewEntryItemsVisibilityState(ListView, OutFullyOutOfStartArray, OutPartiallyOutOfStartArray, OutFullyVisibleArray, OutPartiallyOutOfEndArray, OutFullyOutOfEndArray)
    if not ListView then return end
    for i = #OutFullyOutOfStartArray, 1, -1 do
        table.remove(OutFullyOutOfStartArray, i)
    end
    for i = #OutPartiallyOutOfStartArray, 1, -1 do
        table.remove(OutPartiallyOutOfStartArray, i)
    end
    for i = #OutFullyVisibleArray, 1, -1 do
        table.remove(OutFullyVisibleArray, i)
    end
    for i = #OutPartiallyOutOfEndArray, 1, -1 do
        table.remove(OutPartiallyOutOfEndArray, i)
    end
    for i = #OutFullyOutOfEndArray, 1, -1 do
        table.remove(OutFullyOutOfEndArray, i)
    end
    local AllItems = ListView:GetListItems():ToTable()
    if #AllItems == 0 then return end
    local PartialStart = TArray(UObject)
    local FullyVisible = TArray(UObject)
    local PartialEnd = TArray(UObject)
    ListView:GetEntryWidgetsVisibilityState(PartialStart, FullyVisible, PartialEnd)
    local function GetWidgetContentArray(widgets)
        local result = {}
        for _, w in ipairs(widgets) do
            if w.Content then table.insert(result, w.Content) end
        end
        return result
    end
    local PartiallyOutOfStartItems = GetWidgetContentArray(PartialStart:ToTable())
    local FullyVisibleItems = GetWidgetContentArray(FullyVisible:ToTable())
    local PartiallyOutOfEndItems = GetWidgetContentArray(PartialEnd:ToTable())
    local function GetItemIndex(Item)
        for i, v in ipairs(AllItems) do
            if v == Item then return i end
        end
        return nil
    end
    local TopIndex = 1
    local BottomIndex = #AllItems
    if #FullyVisibleItems > 0 or #PartiallyOutOfStartItems > 0 or #PartiallyOutOfEndItems > 0 then
        local TopItem = PartiallyOutOfStartItems[1] or FullyVisibleItems[1] or PartiallyOutOfEndItems[1]
        local BottomItem = PartiallyOutOfEndItems[#PartiallyOutOfEndItems] or FullyVisibleItems[#FullyVisibleItems] or PartiallyOutOfStartItems[#PartiallyOutOfStartItems]
        TopIndex = TopItem and GetItemIndex(TopItem) or 1
        BottomIndex = BottomItem and GetItemIndex(BottomItem) or #AllItems
    end
    for i, item in ipairs(AllItems) do
        if i < TopIndex then
            table.insert(OutFullyOutOfStartArray, item)
        elseif i > BottomIndex then
            table.insert(OutFullyOutOfEndArray, item)
        else
            local found = false
            for _, visibleItem in ipairs(PartiallyOutOfStartItems) do
                if visibleItem == item then
                    table.insert(OutPartiallyOutOfStartArray, item)
                    found = true
                    break
                end
            end
            if not found then
                for _, visibleItem in ipairs(FullyVisibleItems) do
                    if visibleItem == item then
                        table.insert(OutFullyVisibleArray, item)
                        found = true
                        break
                    end
                end
            end
            if not found then
                for _, visibleItem in ipairs(PartiallyOutOfEndItems) do
                    if visibleItem == item then
                        table.insert(OutPartiallyOutOfEndArray, item)
                        found = true
                        break
                    end
                end
            end
        end
    end
end

--- 一次性绑定ListView的红点和新消息指示器，并添加点击事件处理
--- 在UI初始化时调用一次即可完成所有绑定和跳转逻辑
---@param TargetListView UEMListView 目标ListView,不可为nil
---@param ListView_FrontRedDot WBP_Com_List_RedDot 列表顶部的红点,可为nil
---@param ListView_BackRedDot WBP_Com_List_RedDot 列表底部的红点,可为nil
---@param ListView_FrontNew WBP_Com_List_New 列表顶部的NEW标志,可为nil
---@param ListView_BackNew WBP_Com_List_New 列表底部的NEW标志,可为nil
---@param ReddotAndNewCalFunc function 每种ListView的Item是否有红点和NEW的自定义计算函数,参数固定为每个Item，每个ListView仅支持一种计算方式
function UIUtils.BindListViewReddotAndNewClickEvent(TargetListView, ListView_FrontRedDot, ListView_BackRedDot, ListView_FrontNew, ListView_BackNew, ReddotAndNewCalFunc)
    if not TargetListView then return end
    local function BindClickEvent(indicator, isFront, isReddot)
        if not indicator or not indicator.Btn_Click then return end
        indicator.Btn_Click.OnClicked:Clear()
        indicator.Btn_Click.OnHovered:Clear()
        indicator.Btn_Click.OnHovered:Add(TargetListView,function()
            AudioManager(indicator):PlayUISound(nil, "event:/ui/common/red_point_out_bound", nil, nil)
        end)
        indicator.Btn_Click.OnClicked:Add(TargetListView, function()
            AudioManager(indicator):PlayUISound(nil, "event:/ui/common/click_btn_small", nil, nil)
            local OutFullyOutOfStartArray = {}
            local OutPartiallyOutOfStartArray = {}
            local OutFullyVisibleArray = {}
            local OutPartiallyOutOfEndArray = {}
            local OutFullyOutOfEndArray = {}
            UIUtils.GetListViewEntryItemsVisibilityState(
                TargetListView,
                OutFullyOutOfStartArray,
                OutPartiallyOutOfStartArray,
                OutFullyVisibleArray,
                OutPartiallyOutOfEndArray,
                OutFullyOutOfEndArray
            )
            local targetItems = {}
            if isFront then
                for _, item in ipairs(OutFullyOutOfStartArray) do
                    table.insert(targetItems, item)
                end
                for _, item in ipairs(OutPartiallyOutOfStartArray) do
                    table.insert(targetItems, item)
                end
                for _, item in ipairs(targetItems) do
                    local bHasReddot, bHasNew = ReddotAndNewCalFunc(item)
                    if (isReddot and bHasReddot) or ((not isReddot) and bHasNew) then
                        TargetListView:ScrollItemIntoViewWithAnim(item,true,UE4.EDescendantScrollDestination.TopOrLeft)
                        return
                    end
                end
            else
                for _, item in ipairs(OutPartiallyOutOfEndArray) do
                    table.insert(targetItems, item)
                end
                for _, item in ipairs(OutFullyOutOfEndArray) do
                    table.insert(targetItems, item)
                end
                for i = #targetItems, 1, -1 do
                    local item = targetItems[i]
                    local bHasReddot, bHasNew = ReddotAndNewCalFunc(item)
                    if (isReddot and bHasReddot) or ((not isReddot) and bHasNew) then
                        TargetListView:ScrollItemIntoViewWithAnim(item,true,UE4.EDescendantScrollDestination.BottomOrRight)
                        return
                    end
                end
            end
        end)
    end
    BindClickEvent(ListView_FrontRedDot, true, true)
    BindClickEvent(ListView_BackRedDot, false, true)
    BindClickEvent(ListView_FrontNew, true, false)
    BindClickEvent(ListView_BackNew, false, false)
    local function PlayNormalAnim(Target)
        if Target and Target.Normal and Target.PlayAnimation then
            Target:PlayAnimation(Target.Normal)
        end
    end
    PlayNormalAnim(ListView_FrontRedDot)
    PlayNormalAnim(ListView_BackRedDot)
    PlayNormalAnim(ListView_FrontNew)
    PlayNormalAnim(ListView_BackNew)
end

--endregion

-- ---脚本层支持鼠标自由拖拽ListView
-- ---@param ListView UListView
-- ---@param MouseEvent FPointerEvent
-- ---@param MouseSpeed number [@opt(可选)]
-- function UIUtils.ManualDragListView(ListView, PointerEvent, MouseSpeed)
--     if MouseSpeed == nil then MouseSpeed = 0.05 end
--     local MousePos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(PointerEvent)
--     if (not UE4.USlateBlueprintLibrary.IsUnderLocation(ListView:GetCachedGeometry(),MousePos)) then return end
--     local MouseDelta = UE4.UKismetInputLibrary.PointerEvent_GetCursorDelta(PointerEvent)
--     --DebugPrint("UIUtils.ManualDragListView",MouseDelta.X, MouseDelta.Y)
--     if ListView.Orientation == EOrientation.Orient_Horizontal then 
--         MouseDelta = math.clamp(-MouseDelta.X*MouseSpeed, -1, 1)
--     elseif ListView.Orientation == EOrientation.Orient_Vertical then 
--         MouseDelta = math.clamp(-MouseDelta.Y*MouseSpeed, -1, 1)
--     end
--     --DebugPrint("UIUtils.ManualDragListView",MouseDelta)
--     local MaxScrollOffset = UIUtils.GetMaxScrollOffsetOfListView(ListView)
--     if MaxScrollOffset == 0 then return end
--     local ScrollOffset = math.clamp(ListView:GetScrollOffset()+MouseDelta*ListView.WheelScrollMultiplier, 0 , MaxScrollOffset)
--     ListView:SetScrollOffset(ScrollOffset)
-- end

-- --- 检测鼠标是否在某个控件内，仅支持矩形控件，且没有考虑scale
-- ---@param Widget UWidget
-- ---@return boolean
-- function UIUtils.CheckMouseInside(Widget)
--     if not Widget then return false end
--     if Widget:GetVisibility() == ESlateVisibility.Collapsed then return false end
--     local MousePos = UWidgetLayoutLibrary.GetMousePositionOnPlatform()
--     local WidgetGeo = Widget:GetTickSpaceGeometry()
--     local WidgetPos = USlateBlueprintLibrary.LocalToAbsolute(WidgetGeo,FVector2D(0,0))
--     local WidgetSize =  Widget:GetDesiredSize()
--     local WidgetXMax = WidgetPos.X + WidgetSize.X*0.5
--     local WidgetXMin = WidgetPos.X - WidgetSize.X*0.5
--     local WidgetYMax = WidgetPos.Y + WidgetSize.Y*0.5
--     local WidgetYMin = WidgetPos.Y - WidgetSize.Y*0.5
--     if (MousePos.X < WidgetXMax) and MousePos.X >WidgetXMin and
--        (MousePos.Y < WidgetYMax) and MousePos.Y >WidgetYMin then
--         return true
--     end
--     return false
-- end

---@param SystemId Int 系统UI在表MainUI里的EnterId,必填
---@param Option Bool 是否是ESC菜单, 后面有参数的话必填
---@param ... 加载ui传入的参数 目前最多五个
--- 右上角系统列表通用打开逻辑
function UIUtils.OpenSystem(SystemId,Option, ...)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    if not Player or not IsValid(Player) then return end
    local SystemData = DataMgr.MainUI[SystemId]
    local SystemUIName
    if SystemData and SystemData.SystemUIName then
        SystemUIName = SystemData.SystemUIName
    else
        return
    end
    local NeedAnimation = false
    if SystemData.ShowCondition or SystemData.EscShowCondition then
        NeedAnimation = true
    end
    if  SystemData and UIUtils.CheckCdnHide(SystemUIName,true) then
        return
    end
	local SystemUI = DataMgr.SystemUI[SystemUIName]
	if not UIUtils.CheckSystemCanOpen(SystemUI) then
		return
	end
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local MenuUI = UIManager:GetUI(UIConst.MenuWorld)
    local IsEscMenu = false
    if type(Option) == "boolean" then
        IsEscMenu = true
    elseif type(Option) == "string" then
        MenuUI[Option] = true
    end
    local UIUnlockRuleName = SystemData.UIUnlockRuleName
    if SystemId == CommonConst.ArmoryEnterId then
        -- 军械库规则：是否能进入交互状态&(是否处于Idle状态or处于Skill能打断状态),如果处于技能状态需要取消技能
        local bInSkillAndSafeToCancel = Player:CharacterInTag('Skill') and Player:IsSafeToCancelSkill()
        if Player:CanEnterInteractive()
            and (Player:CharacterInTag('Idle') or bInSkillAndSafeToCancel)
            and Player.PlayerAnimInstance
            and ((Player.PlayerAnimInstance.IdletagName == "0" or Player.PlayerAnimInstance.IdletagName == "EmoIdle")) then
            if UIUtils.CheckSystemIsUnlock(SystemUIName,UIUnlockRuleName,IsEscMenu,NeedAnimation, ...) then
                if bInSkillAndSafeToCancel then 
                    Player:StopSkill(UE.ESkillStopReason.ArmoryCancel) 
                end 
            end
        else
            if not IsEscMenu then
                UIManager:ShowUITip(UIConst.Tip_CommonTop,GText("UI_Toast_Armory_Forbid"))
            else
                -- if ( MenuUI ~= nil) then
                --     MenuUI:SetFocus()
                -- end
                UIManager:ShowUITip(UIConst.Tip_CommonToast,GText("UI_Toast_Armory_Forbid"))
            end
        end
    elseif SystemUIName == "NpcSwitchMain" then
        if Player:IsSeating() then
            UIManager:ShowUITip(UIConst.Tip_CommonTop,GText("UI_Toast_NpcSwitch_Forbid"))
        else
            UIUtils.CheckSystemIsUnlock(SystemUIName,UIUnlockRuleName,IsEscMenu,NeedAnimation,...)
        end
    elseif SystemUIName == "ShopMain" then
        UIUtils.CheckSystemIsUnlock(SystemUIName,UIUnlockRuleName,IsEscMenu,NeedAnimation,nil,nil,nil,"Shop")

    else
        UIUtils.CheckSystemIsUnlock(SystemUIName,UIUnlockRuleName,IsEscMenu,NeedAnimation,...)
    end
end

--系统打开条件判断
function UIUtils.CheckSystemCanOpen(SystemUI)
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    if (SystemUI and SystemUI.CombatconditionIdList ~= nil) then
        local IsConditionSuccess, TargetConditionIdx = true, nil
        for i, v in ipairs(SystemUI.CombatconditionIdList) do
            local TraceInfo="From Guide_Touch:Init"
            if (not Battle(Player):CheckConditionNew(v, Player, nil,TraceInfo)) then
                IsConditionSuccess = false
                TargetConditionIdx = i
                break
            end
        end
        if (not IsConditionSuccess) then
            if (SystemUI.ConditiontextList and SystemUI.ConditiontextList[TargetConditionIdx] ~= nil) then
                DebugPrint("The UI Load in fail, Because Combatcondition is not met, The CombatconditionId is", SystemUI.CombatconditionIdList[TargetConditionIdx])
                UIManager:ShowUITip(UIConst.Tip_CommonTop, GText(SystemUI.ConditiontextList[TargetConditionIdx]))
                -- --临时处理加载Toast之后的Focus问题
                -- local MenuUI = UIManager:GetUI(UIConst.MenuWorld)
                -- if ( MenuUI ~= nil) then
                --     MenuUI:SetFocus()
                -- end
            end 
            return false 
        end
    end
    return true
end

--系统解锁条件判断
function UIUtils.CheckSystemIsUnlock(SystemUIName,UIUnlockRuleName,IsEscMenu,NeedAnimation,...)
    local Param1,Param2,Param3,Param4,Param5 = ...
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    if UIUnlockRuleName then
        local UIUnlockRule = DataMgr.UIUnlockRule
        local UIUnlockRuleId = UIUnlockRule[UIUnlockRuleName].UIUnlockRuleId
        local OpenDescs=UIUnlockRule[UIUnlockRuleName].OpenSystemDesc
        local OpenConditionId=UIUnlockRule[UIUnlockRuleName].OpenConditionId
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            local bUnlocked = Avatar:CheckUIUnlocked(UIUnlockRuleId)
            if bUnlocked then
                local IsCanOpen,FailedIdIndex = Avatar:CheckSystemUICanOpen(UIUnlockRuleId)
                if (IsCanOpen) then
                    UIUtils.FinalOpenSystem(SystemUIName,IsEscMenu,NeedAnimation,Param1,Param2,Param3,Param4,Param5)
                    return true
                else
                    if #OpenConditionId ==#OpenDescs then
                        for _, Value in pairs(FailedIdIndex) do
                            UIManager:ShowUITip(UIConst.Tip_CommonToast, OpenDescs[Value])
                        end
                    else
                        UIManager:ShowUITip(UIConst.Tip_CommonToast, OpenDescs[1])
                    end
                end
            else
                UIManager:ShowUITip(UIConst.Tip_CommonToast, UIUnlockRule[UIUnlockRuleName].UIUnlockDesc)
            end
        end
    else
        UIUtils.FinalOpenSystem(SystemUIName,IsEscMenu,NeedAnimation,...)
        return true
    end
    return false
end

--条件判断完成之后进行系统打开逻辑
function UIUtils.FinalOpenSystem(SystemUIName,IsEscMenu,NeedAnimation,...)
    local Params = {...}
    -- if SystemUIName == "AnnouncementMain" then
    --     UIUtils.FinalOpenSystemInternal(SystemUIName,IsEscMenu,NeedAnimation, table.unpack(Params))
    -- else
        GameFlowUtils:AddFlow("OpenSystemUI", {
            GWorld.GameInstance, function(_, Flow)
                local UIManager = GWorld.GameInstance:GetGameUIManager()
                local ExistUIObj = UIManager:GetUI(SystemUIName)
                if (IsValid(ExistUIObj)) then
                    DebugPrint("JLY 系统ui重复打开，请检查逻辑, Name is ", SystemUIName)
                    -- 是否已经存在了这个UI对象，则直接返回
                    GameFlowUtils:RemoveFlow(Flow)
                else
                    UIUtils.FinalOpenSystemInternal(SystemUIName,IsEscMenu,NeedAnimation, table.unpack(Params))
                    UIManager:AddFlow(SystemUIName, Flow)
                end 
            end
        })
    --end
end

--条件判断完成之后进行系统打开逻辑
function UIUtils.FinalOpenSystemInternal(SystemUIName,IsEscMenu,NeedAnimation,...)
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    if IsEscMenu then
        if SystemUIName == "AnnouncementMain" then
            UIManager:LoadUINew(SystemUIName,nil,nil,AnnounceCommon.ShowTag.InGame,...)
            return
        end
        UIManager:LoadUINew(SystemUIName,...)
        return
    else
        local BattleMainUI = UIManager:GetUI('BattleMain')
        if (BattleMainUI ~= nil and BattleMainUI.Char_Skill ~= nil and type(BattleMainUI.Char_Skill.HandleEventByInterrupt) == "function") then
            BattleMainUI.Char_Skill:HandleEventByInterrupt() 
        end
        if (BattleMainUI ~= nil and (not IsEscMenu) and NeedAnimation) then
            BattleMainUI:PlayOutAnim(nil,nil,SystemUIName)
            local UI = UIManager:LoadUINew(SystemUIName,...)
            if UI == nil then
                BattleMainUI:RemovePlayInOutSystems(SystemUIName)
                BattleMainUI:TryRecoverUI()
            else
                --系统打开前关闭toast界面
                -- local UITipList = UIManager:GetUI("CommonTopToastList")
                -- if (UITipList ~= nil) then
                --     UITipList:RealClose()
                -- end
            end
        else
            UIManager:LoadUINew(SystemUIName,...)
        end
    end
end

function UIUtils.OpenEsc()
    --大招动画期间屏蔽ESC
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance,0)
    if Player and Player.SkillFeature then
        return
    end
    if Player:GetESCMenuForbiddenState() then
        return
    end
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local Avatar = GWorld:GetAvatar()
    --Esc容错处理,一些高优先级的UI播放动效时无法打开Esc TODO:封装成接口
    local SystemUIConfig = DataMgr.SystemUI[UIConst.CommonSetUP]
    if SystemUIConfig and SystemUIConfig.Params.BlockedUIName then
        for _, UIName in ipairs(SystemUIConfig.Params.BlockedUIName) do
            local  BlockedUI = UIManager:GetUIObj(UIName)
            if BlockedUI and BlockedUI:IsPlayingAnimation() then
                return
            end
        end
    end
    if UIUtils.IsMenuWorld() then
        UIManager:LoadUINew(UIConst.MenuWorld)
    else
        UIManager:LoadUINew(UIConst.MenuLevel)
    end
end

function UIUtils.IsMenuWorld()
    local DungeonId = GWorld.GameInstance:GetCurrentDungeonId()
    local Avatar = GWorld:GetAvatar()
    if Avatar and DungeonId and DungeonId <= 0 then
        local InHardBoss=Avatar:IsInHardBoss()
        local SpecialQuestChange=false
        if Avatar:IsInSpecialQuest() then
            local SpecialQuestConfig = DataMgr.SpecialQuestConfig[Avatar.SpecialQuestId]
            if SpecialQuestConfig and SpecialQuestConfig.UniversalConfigId then
                local UniversalConfig = DataMgr.UniversalConfig[SpecialQuestConfig.UniversalConfigId]
                if UniversalConfig and UniversalConfig.IfChangeESC then
                    SpecialQuestChange=true
                end
            end
        end
        if InHardBoss or (Avatar.SpecialQuestId and SpecialQuestChange)  then
            return false
        else
          return true
        end
    else
        return false
    end
end

function UIUtils.PlayBattleMainInAnim()
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local BattleMainUI = UIManager:GetUI('BattleMain')
    if (BattleMainUI ~= nil) then
        BattleMainUI:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        BattleMainUI:TryRecoverUI()
    end
end

function UIUtils.CheckAndPlayBattleMainInAnim(UIName)
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local BattleMainUI = UIManager:GetUI('BattleMain')
    if (BattleMainUI ~= nil) then
        BattleMainUI:UnLoadSystem(UIName)
    end
end

--region 通用按钮音效
UIUtils.PlayCommonBtnSe = function (context)
    -- print(_G.LogTag, UE4.UKismetSystemLibrary.GetDisplayName(context))
    UE4.UFMODBlueprintStatics.PlayEvent2D(nil, UE4.UFMODBlueprintStatics.FindEventbyName("event:/ui/common/click"))
end
UIUtils.PlayCommonForbiddenBtnSe = function (context)
    UE4.UFMODBlueprintStatics.PlayEvent2D(nil, UE4.UFMODBlueprintStatics.FindEventbyName("event:/ui/common/click_btn_disable"))
end
--endregion

UIUtils.GetAllElementTypes = function()
    if(not UIUtils.ElementTypes)then
        UIUtils.ElementTypes = {}
        UIUtils.ElementTypeNames = {}
        local list = {}
        for id, value in pairs(DataMgr.Attribute) do
            if(value.DisplayPriority)then
                table.insert(list,value)
            end
        end
        table.sort(list,function(a,b) return a.DisplayPriority < b.DisplayPriority end)
        for index, value in ipairs(list) do
            table.insert(UIUtils.ElementTypes,value.ID)
            table.insert(UIUtils.ElementTypeNames,"UI_Attr_" .. value.ID .. "_Name")
        end
    end
    return  UIUtils.ElementTypes, UIUtils.ElementTypeNames
end

UIUtils.GetAllWeaponTags = function()
    if(not UIUtils.MeleeTags or not UIUtils.RangedTags)then
        UIUtils.MeleeTags = {}
        UIUtils.MeleeTagNames = {}
        UIUtils.RangedTags = {}
        UIUtils.RangedTagNames = {}
        local list = {}
        for WeaponTag, value in pairs(DataMgr.WeaponTag) do
            if(value.WeaponTagfilter == "MeleeType")then
                table.insert(UIUtils.MeleeTags,WeaponTag)
            elseif(value.WeaponTagfilter == "RangedType")then
                table.insert(UIUtils.RangedTags,WeaponTag)
            end
        end
        table.sort(UIUtils.MeleeTags)
        table.sort(UIUtils.RangedTags)
        for _, WeaponTag in ipairs(UIUtils.MeleeTags) do
            table.insert(UIUtils.MeleeTagNames,DataMgr.WeaponTag[WeaponTag].WeaponTagTextmap or "")
        end
        for _, value in ipairs(UIUtils.RangedTags) do
            table.insert(UIUtils.RangedTagNames,DataMgr.WeaponTag[value].WeaponTagTextmap or "")
        end
    end
    return  UIUtils.MeleeTags, UIUtils.MeleeTagNames, UIUtils.RangedTags, UIUtils.RangedTagNames
end

UIUtils.CanApplyWeaponSkin = function(WeaponId,SkinApplicationType)
    local Data = DataMgr.Weapon[WeaponId]
    if(Data and Data.SkinApplicationType)then
        for key, value in pairs(Data.SkinApplicationType) do
            if(value == SkinApplicationType)then
                return true
            end
        end
    end
    return false
end

function UIUtils.ShowDungeonRewardUI(Rewards, Reason, TableTypeName)
    if not Rewards then
        return
    end
    if not IsStandAlone(GWorld.GameInstance) and not IsClient(GWorld.GameInstance) then
        return
    end

    local TalkContext = GWorld.GameInstance:GetTalkContext()
    if(TalkContext:HasHiddenGameUI()) then
        table.insert(GWorld.GameInstance.CacheShowRewardUIParams, {Rewards,Reason,TableTypeName})
        return
    end

    for ItemId, Count in pairs(Rewards) do
        if type(Count) == "table" then
            Count = RewardBox:GetCount(Count)
        end
        UIUtils.ShowGotItemTipsUI(TableTypeName, ItemId, Count)
    end
end

function UIUtils.OnGetRewardShowUI(Rewards, Reason)
    UIUtils.ShowDungeonRewardUI(Rewards.Resources, Reason, "Resource")
    UIUtils.ShowDungeonRewardUI(Rewards.Weapons, Reason, "Weapon")
    UIUtils.ShowDungeonRewardUI(Rewards.Mods, Reason, "Mod")
end


function UIUtils.GenRougeBlessingDesc(BlessingId,ModLevel,ComparedGradeLevel)
	local ItemData = DataMgr.RougeLikeBlessing[BlessingId]
	local ModData=DataMgr.Mod[ItemData.BlessingMod]
	local DescStr =GText(ItemData.Desc)
	if ItemData then
		for i, Attr in pairs(ModData.AddAttrs or {}) do
			local AttrConf=DataMgr.AttrConfig[Attr.AttrName]
			if not AttrConf then goto continue end
			local OldValue,OldValStr =UIUtils.GenRougeModAttrData(Attr,ModLevel, AttrConf, ItemData.BlessingMod)
            local index= string.find(OldValStr,'%%',1)
            if index then
                OldValStr=OldValStr..'%'
            end
            if(ComparedGradeLevel)then
                local ComparedValue,ComparedValueStr =UIUtils.GenRougeModAttrData(Attr,ComparedGradeLevel, AttrConf, ItemData.BlessingMod)
                if(index)then
                    ComparedValueStr = ComparedValueStr .. '%'
                end
                if(OldValStr ~= ComparedValueStr)then
                    OldValStr= OldValStr .. "->" .. ComparedValueStr
                end
            end
			DescStr =string.gsub(DescStr, "#"..i,OldValStr)
			::continue::
		end
        DescStr=UIUtils.GenRougeModPassiveEffectDesc(DescStr, ModData,ModLevel,ComparedGradeLevel,false,true)
	end
	return DescStr
end

function UIUtils.GenRougeBlessingSimpleDesc(BlessingId)
	local ItemData = DataMgr.RougeLikeBlessing[BlessingId]
	local DescStr =GText(ItemData.SimpleDesc)
	return DescStr
end

function UIUtils.GenRougeModPassiveEffectDesc(Desc,ModConf, BaseLevel, ExpectLevel,CastTo,ForbidFormat)
    if not ArmoryUtils then
        ArmoryUtils=require "BluePrints.UI.WBP.Armory.ArmoryUtils"
    end
    ExpectLevel = ExpectLevel == nil and BaseLevel or ExpectLevel
    for i, DescValue in pairs(ModConf.DescValues or {}) do 
        local Percent = string.match(DescValue, "%%") or ""
        local ValStr = ArmoryUtils:_ModAttrGrowDesc2(DescValue, BaseLevel,  BaseLevel,Percent,CastTo,ForbidFormat) or ""
        ValStr = ValStr=="" and ArmoryUtils:_SkillGrowDesc(DescValue, BaseLevel,  BaseLevel,Percent,CastTo,ForbidFormat) or ValStr
        if(ExpectLevel)then
            local ComparedValStr = ArmoryUtils:_ModAttrGrowDesc2(DescValue, ExpectLevel, ExpectLevel,Percent,CastTo,ForbidFormat) or ""
            ComparedValStr  = ComparedValStr=="" and ArmoryUtils:_SkillGrowDesc(DescValue, ExpectLevel, ExpectLevel,Percent,CastTo,ForbidFormat) or ComparedValStr
            if( ValStr ~= ComparedValStr )then
                ValStr=  ValStr .. "->" .. ComparedValStr 
            end
        end
        Desc = string.gsub(Desc, "$"..i, ValStr)
    end
    return Desc
end

function UIUtils.GenRougeTreasureDesc(TreasureId)
    if not ArmoryUtils then
        ArmoryUtils=require "BluePrints.UI.WBP.Armory.ArmoryUtils"
    end
	local ItemData = DataMgr.RougeLikeTreasure[TreasureId]
	if ItemData then
        local DescStr =GText(ItemData.Desc)
        local ModData=DataMgr.Mod[ItemData.TreasureMod]
        if not ItemData.ServerBuild and not ItemData.ClientBuild and not ModData then
            local String=tostring(TreasureId).."号宝物不是ServerBuild与ClientBuild，但Mod数据为空请策划检查"
            UE.ARougeLikeManager.ShowRougeLikeError(String)
        end
        if ModData then
            for i, Attr in pairs(ModData.AddAttrs or {}) do
                local AttrConf=DataMgr.AttrConfig[Attr.AttrName]
                if not AttrConf then goto continue end
                local OldValue,OldValStr =UIUtils.GenRougeModAttrData(Attr,0, AttrConf, ItemData.TreasureMod)
                local Percent = string.match(OldValStr, "%%") or ""
                DescStr =string.gsub(DescStr, "#"..i,OldValStr..Percent)
                ::continue::
            end
            DescStr=UIUtils.GenRougeModPassiveEffectDesc(DescStr, ModData,0,nil,false,true)
        end
        DescStr=UIUtils.GenRougeServerDesc(DescStr,ItemData,0)
        return DescStr
    else
        local String=tostring(TreasureId).."号宝物数据为空请策划检查"
        UE.ARougeLikeManager.ShowRougeLikeError(String)
	end
end

function UIUtils.GenRougeServerDesc(Desc,TreasureConf, BaseLevel)
    for i, DescValue in pairs(TreasureConf.ServerBuildValue or {}) do 
        local Percent = string.match(DescValue, "%%") or ""
        local ValStr = ""
        ValStr =SkillUtils.CalcSkillDesc(DescValue,BaseLevel)..Percent
        Desc = string.gsub(Desc, "@"..i, ValStr)
    end
    return Desc
end

--- 获取当前宝物对应宝物组已获取的总数
function UIUtils.GetRealCurrentTreasureGroupNum(TreasureId)
    local Num=0
    if UE.ARougeLikeManager then
        local TreasureGroupData=DataMgr.TreasureGroup
        local TreasureData=DataMgr.RougeLikeTreasure
        if not TreasureData[TreasureId] or not TreasureData[TreasureId].TreasureGroup then
            return 0
        end
        local GroupId=TreasureData[TreasureId].TreasureGroup
        if not TreasureGroupData[GroupId] then
            return 0
        end
        for _,value in pairs( TreasureGroupData[GroupId].ActivateNeed) do
            if  UE.ARougeLikeManager.IsTreasureExist(GWorld.GameInstance,value) then
                Num=Num+1
            end
        end
        return Num
    end
    return Num
end

function UIUtils.GetCurrentTreasureGroupNum(TreasureId)
    local Num=0
    if UE.ARougeLikeManager then
        local TreasureGroupData=DataMgr.TreasureGroup
        local TreasureData=DataMgr.RougeLikeTreasure
        if not TreasureData[TreasureId] or not TreasureData[TreasureId].TreasureGroup then
            return 0
        end
        local GroupId=TreasureData[TreasureId].TreasureGroup
        if not TreasureGroupData[GroupId] then
            return 0
        end
        for _,value in pairs( TreasureGroupData[GroupId].ActivateNeed) do
            if value~=TreasureId and  UE.ARougeLikeManager.IsTreasureExist(GWorld.GameInstance,value) then
                Num=Num+1
            end
        end
        return Num
    end
    return Num
end

function UIUtils.GetTreasureGroupNum(TreasureId)
    local Num=0
    if UE.ARougeLikeManager then
        local TreasureGroupData=DataMgr.TreasureGroup
        local TreasureData=DataMgr.RougeLikeTreasure
        if not TreasureData[TreasureId] or not TreasureData[TreasureId].TreasureGroup then
            return 0
        end
        local GroupId=TreasureData[TreasureId].TreasureGroup
        if not TreasureGroupData[GroupId] or not TreasureGroupData[GroupId].ActivateNeed then
            return 0
        end
        Num=#TreasureGroupData[GroupId].ActivateNeed
        return Num
    end
    return Num
end


function UIUtils.GenRougeTreasureSimpleDesc(TreasureId)
	local ItemData = DataMgr.RougeLikeTreasure[TreasureId]
	local DescStr =GText(ItemData.SimpleDesc)
	return DescStr
end

function UIUtils.GenRougeTalentDesc(TalentId)
	local ItemData = DataMgr.RougeLikeTalent[TalentId]
	local ModData=DataMgr.Mod[ItemData.TalentMod]
	local DescStr =GText(ItemData.Desc)
	if ItemData then
        if ModData then
            for i, Attr in pairs(ModData.AddAttrs or {}) do
                local AttrConf=DataMgr.AttrConfig[Attr.AttrName]
                if not AttrConf then goto continue end
                local OldValue,OldValStr =UIUtils.GenRougeModAttrData(Attr,0, AttrConf, ItemData.TalentMod)
                local Percent = string.match(OldValStr, "%%") or ""
                DescStr =string.gsub(DescStr, "#"..i,OldValStr..Percent)
                ::continue::
            end
            DescStr=UIUtils.GenRougeModPassiveEffectDesc(DescStr, ModData,0)
        end
        DescStr=UIUtils.GenRougeServerDesc(DescStr,ItemData,0)
	end
	return DescStr
end

function UIUtils.GetLeftTimeStrStyle1(EndTime, StartTime)
    if EndTime and type(EndTime) == 'table' then
        EndTime = EndTime.GetTime()
    end
    if StartTime and type(StartTime) == 'table' then
        StartTime = StartTime.GetTime()
    end
    if TimeUtils.NowTime() >= EndTime then
        return "TimeOut"
    end
    local FixEndTime = URuntimeCommonFunctionLibrary.GetDateTimeFromUnixTime(EndTime)
    local FixStartTime = URuntimeCommonFunctionLibrary.GetDateTimeFromUnixTime(StartTime or TimeUtils.NowTime())
    local RemainTime = UKismetMathLibrary.Subtract_DateTimeDateTime(FixEndTime, FixStartTime)
    local RemainTimeStr = ""
    local TimeCount = 0
    if UKismetMathLibrary.GetDays(RemainTime) > 0 then
        TimeCount = TimeCount + 1
        RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_DAY"), UKismetMathLibrary.GetDays(RemainTime))
    end
    if UKismetMathLibrary.GetHours(RemainTime) > 0 or TimeCount == 1 then
        TimeCount = TimeCount + 1
        RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_HOUR"), UKismetMathLibrary.GetHours(RemainTime))
    end
    if (UKismetMathLibrary.GetMinutes(RemainTime) > 0 and TimeCount < 2) or TimeCount == 1 then
        TimeCount = TimeCount + 1
        RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_MINUTE"), UKismetMathLibrary.GetMinutes(RemainTime))
    end
    if (UKismetMathLibrary.GetSeconds(RemainTime) > 0 and TimeCount < 2) or TimeCount == 1 then
        TimeCount = TimeCount + 1
        RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_SECOND"), UKismetMathLibrary.GetSeconds(RemainTime))
    end
    return RemainTimeStr
end

function UIUtils.GetLeftTimeStrStyle2(EndTime, StartTime)
    if EndTime and type(EndTime) == 'table' then
        EndTime = EndTime.GetTime()
    end
    if StartTime and type(StartTime) == 'table' then
        StartTime = StartTime.GetTime()
    end
    if (EndTime == nil or TimeUtils.NowTime() >= EndTime) then
        return {{TimeType="Min", TimeValue=0}, {TimeType="Sec", TimeValue=0}}, 0
    end
    local FixEndTime = URuntimeCommonFunctionLibrary.GetDateTimeFromUnixTime(EndTime + 0)
    local FixStartTime = URuntimeCommonFunctionLibrary.GetDateTimeFromUnixTime((StartTime and StartTime + 0) or TimeUtils.NowTime())
    local RemainTime = UKismetMathLibrary.Subtract_DateTimeDateTime(FixEndTime, FixStartTime)
    local RemainTimeDict = {}
    local TimeCount = 0

    local LeftDayTime = UKismetMathLibrary.GetDays(RemainTime)
    if LeftDayTime > 0 then
        TimeCount = TimeCount + 1
        table.insert(RemainTimeDict, {TimeType="Day", TimeValue=LeftDayTime})
    end

    local LeftHourTime = UKismetMathLibrary.GetHours(RemainTime)
    if (LeftHourTime > 0 or TimeCount == 1) then
        TimeCount = TimeCount + 1
        table.insert(RemainTimeDict, {TimeType="Hour", TimeValue=LeftHourTime})
    end

    local LeftMinuteTime = UKismetMathLibrary.GetMinutes(RemainTime)
    if (TimeCount <= 1) then
        TimeCount = TimeCount + 1
        table.insert(RemainTimeDict, {TimeType="Min", TimeValue=LeftMinuteTime})
    end

    local LeftSecondTime = UKismetMathLibrary.GetSeconds(RemainTime)
    if (LeftSecondTime > 0 and TimeCount < 2) or TimeCount == 1 then
        TimeCount = TimeCount + 1
        table.insert(RemainTimeDict, {TimeType="Sec", TimeValue=LeftSecondTime})
    end
    return RemainTimeDict, TimeCount
end

function UIUtils.GenRougeModAttrData(ModAttrConf, ModLevel, AttrConf, ModId)
    if not ArmoryUtils then
        ArmoryUtils=require "BluePrints.UI.WBP.Armory.ArmoryUtils"
    end
    local IsRate = ModAttrConf.Rate~=nil
    local Value = ArmoryUtils:CalcModAttrByLevel(ModAttrConf, ModLevel, nil,ModId)
    local ValueStr = CommonUtils.AttrValueToString(AttrConf, Value,IsRate,true)
    return Value,ValueStr
end

function UIUtils.SwitchGuideHead(RawName, MID)
    local Path = '/Game/UI/Blueprint/EMUIFunctionLibrary'
    local UIFunctionLibClass = LoadClass(Path)
    if UIFunctionLibClass then
        return UIFunctionLibClass.SwitchGuideHead(RawName, MID)
    else
        DebugPrint("Error: UIFunctionLibClass不存在，路径", Path)
        return false
    end
end

function UIUtils.ShowActionRecover(Obj)
    --体力系统删除，先注释了
    -- local Params = {}
    -- --Params.RightCallbackObj = self
    -- Params.RightCallbackFunction = function (Obj, Result, PopUI)
    --     local UIManager =  GWorld.GameInstance:GetGameUIManager()
    --     --UIManager:LoadUI(UIConst.RecoverUI,"RecoverUI",99)
    --     UIManager:ShowCommonPopupUI(100185, {},Obj)
    --     PopUI.ParentWidget = UIObj
    -- end
    -- local UIManager = GWorld.GameInstance:GetGameUIManager()
    -- UIManager:ShowCommonPopupUI(100094, Params,Obj)
end

-- 获取角色的名称，对于线上的玩家，显示NickName； 对于魅影，显示CharName
function UIUtils.GetCharName(Character)
    if Character:IsPlayer() then 
        return Character:GetNickName()
    elseif Character:IsPhantom() then  
        return UIUtils.GetPhantomName(Character)
    end

    return "nil"
end

function UIUtils.GetPhantomName(Character)
    if not (Character and Character:IsPhantom()) then 
        return "nil"
    end

    local ShowName = ""
    local NameKey = DataMgr.BattleChar[Character.CurrentRoleId].CharName
    if string.find(DataMgr.TextMap_ContentEN[NameKey].ContentEN, "{nickname") and not IsStandAlone(Character) then
        local PhantomState = GameState(Character):GetPhantomState(Character.Eid)
        if not PhantomState then
            local PhantomOwner = Character.PhantomOwner
            if PhantomOwner then
                local OwnerState = GameState(Character):GetPlayerState(PhantomOwner.Eid)
                if OwnerState and OwnerState.PlayerName then
                    ShowName = OwnerState.PlayerName
                end
            end
        else
            local PhantomOwnerEid = PhantomState.OwnerEid
            if PhantomOwnerEid then
                local OwnerState = GameState(Character):GetPlayerState(PhantomOwnerEid)
                if OwnerState and OwnerState.PlayerName then
                    ShowName = OwnerState.PlayerName
                else
                    ShowName = GText(NameKey)
                end
            else
                ShowName = "<ERROR>"
            end
        end
    -- 普通魅影
    else
        ShowName = GText(NameKey)
    end

    return ShowName
end

function UIUtils.UtilsGetCurrentInputType()
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(GWorld.GameInstance)
    if IsValid(GameInputModeSubsystem) then
        return GameInputModeSubsystem:GetCurrentInputType()
    end
    return ECommonInputType.MouseAndKeyboard
end

function UIUtils.IsKeyboardInput()
    local InputType = UIUtils.UtilsGetCurrentInputType()
    return InputType == UE4.ECommonInputType.MouseAndKeyboard and CommonUtils.GetDeviceTypeByPlatformName() == "PC"
end

function UIUtils.IsGamepadInput()
    local InputType = UIUtils.UtilsGetCurrentInputType()
    return InputType == UE4.ECommonInputType.Gamepad
end

function UIUtils.IsMobileInput()
    return CommonUtils.GetDeviceTypeByPlatformName() == "Mobile"
end

function UIUtils.IsPCInput()
    return CommonUtils.GetDeviceTypeByPlatformName() == "PC"
end

function UIUtils.UtilsGetCurrentGamepadName()
    if (CommonUtils.GetDeviceTypeByPlatformName()=="Mobile") then
        return "Generic"
    end
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(GWorld.GameInstance)
    if IsValid(GameInputModeSubsystem) then
        return GameInputModeSubsystem:GetCurrentGamepadName()
    end
    return "Generic"
end

---@param KeyIconName string 按键的名称（比如：RS、A、B）
---@param GamepadName string 手柄的类型名 （PS、Xbox、Generic）
function UIUtils.UtilsGetKeyIconPathInGamepad(KeyIconName, GamepadName)
    if (GamepadName == nil) then
        GamepadName = UIUtils.UtilsGetCurrentGamepadName()
    end
    local FixPath, ImgPath = nil, nil
    local ReplaceKey = string.gsub(KeyIconName, " ", "_")
    if (GamepadName == "PS") then
        FixPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Key/PS5/T_Key_%s.T_Key_%s'"
    else
        FixPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Key/XBOX/T_Key_%s.T_Key_%s'"
    end
    ImgPath = string.format(FixPath, ReplaceKey, ReplaceKey)
    return ImgPath
end

function UIUtils.UtilsGetKeyIconPathInGamepadByInstruction(KeyIconName, GamepadName)
    if (GamepadName == nil) then
        GamepadName = UIUtils.UtilsGetCurrentGamepadName()
    end
    local FixPath, ImgPath = nil, nil
    local ReplaceKey = string.gsub(KeyIconName, " ", "_")
    if (GamepadName == "PS") then
        FixPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Instruction/PS5/T_Key_%s.T_Key_%s'"
    else
        FixPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Instruction/XBOX/T_Key_%s.T_Key_%s'"
    end
    ImgPath = string.format(FixPath, ReplaceKey, ReplaceKey)
    return ImgPath
end


function UIUtils.GetNoneAccessoryIconPath()
    return '/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_Forbid.T_Armory_Forbid'
end


function UIUtils.TrySubReddotCacheDetail(Id,ReddotName)
    local CacheKey = tostring(Id)
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotName)
    if CacheDetail and CacheDetail[CacheKey] then
        CacheDetail[CacheKey] = false
        ReddotManager.DecreaseLeafNodeCount(ReddotName)
    end
end

function UIUtils.TryAddReddotCacheDetail(Id,ReddotName)
    local CacheKey = tostring(Id)
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotName)
    if CacheDetail and not CacheDetail[CacheKey] then
        CacheDetail[CacheKey] = true
        ReddotManager.IncreaseLeafNodeCount(ReddotName)
    end
end
function UIUtils.TrySubReddotCacheDetailNumber(Id,ReddotName)
    local CacheKey = Id
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotName)
    if CacheDetail and CacheDetail[CacheKey] then
        CacheDetail[CacheKey] = false
        ReddotManager.DecreaseLeafNodeCount(ReddotName)
    end
end

function UIUtils.TryAddReddotCacheDetailNumber(Id,ReddotName)
    local CacheKey = Id
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotName)
    if CacheDetail and not CacheDetail[CacheKey] then
        CacheDetail[CacheKey] = true
        ReddotManager.IncreaseLeafNodeCount(ReddotName)
    end
end


function UIUtils.SetReddotTreeLeafNodeCount(ReddotName, Count)
    local Node = ReddotManager.GetTreeNode(ReddotName)
    assert(Node, "[jiangtianyi]ReddotManager.SetReddotTreeLeafNodeCount: Failed to find leaf node ".. ReddotName)
    local CurrentCount = Node.Count 
    if CurrentCount > Count then 
        ReddotManager.DecreaseLeafNodeCount(ReddotName, CurrentCount - Count)
    elseif CurrentCount < Count then 
        ReddotManager.IncreaseLeafNodeCount(ReddotName, Count - CurrentCount)
    end
end

function UIUtils.GetExcelWeaponTagString(CharId)
    local Data = DataMgr.BattleChar[CharId]
    local ExcelWeaponTags = Data and Data.ExcelWeaponTags
    if(ExcelWeaponTags)then
        local TagString
        if(type(ExcelWeaponTags) == "table")then
            TagString = GText(DataMgr.WeaponTag[ExcelWeaponTags[1]].WeaponTagTextmap)
            for i = 2, #ExcelWeaponTags do
                TagString = TagString .. "/".. GText(DataMgr.WeaponTag[ExcelWeaponTags[i]].WeaponTagTextmap)
            end
        else
            TagString = GText(DataMgr.WeaponTag[ExcelWeaponTags].WeaponTagTextmap)
        end
        return TagString
    end
end

function UIUtils.GetExcelWeaponTags(CharId)
    local Data = DataMgr.BattleChar[CharId]
    local ExcelWeaponTags = Data and Data.ExcelWeaponTags
    local Tags = {}
    if(ExcelWeaponTags)then
        if(type(ExcelWeaponTags) == "table")then
            table.insert(Tags,ExcelWeaponTags[1])
            for i = 2, #ExcelWeaponTags do
                table.insert(Tags,ExcelWeaponTags[i])
            end
        else
            table.insert(Tags,ExcelWeaponTags)
        end
        return Tags
    end
end

function UIUtils.GetDispathchColorNameByType(Type)
    if Type == "Battle" then
        return "Red"
    elseif Type == "Collect" or Type == "Mine" or Type == "Fish" or Type == "Pet" then
        return "Blue"
    elseif Type == "Benefit" or Type == "Morality" or Type == "Wisdom" or Type == "Empathy" or Type == "Chaos" then
        return "Green"
    elseif Type == "Workaholic" or Type == "Rigorous" or Type == "Skilled" or Type == "Lucky" then
        return "Special"
    end
end

function UIUtils.NumberToChinese(Num)
    local ChineseNums = {
        "零", "一", "二", "三", "四",
        "五", "六", "七", "八", "九"
    }
    return ChineseNums[Num + 1]
end

---@param UIState table TimerMgr
---@param TextWidget Widget 文本控件
---@param OrigNum number 初始值
---@param AddNum number 增加的数值(可以负数)
---@param UpdateDestTotalTime number 滚动总时间
---@param IntervalTime number 间隔时间
function UIUtils.RollingNumberEffect(UIState, TextWidget, OrigNum, AddNum, UpdateDestTotalTime, IntervalTime)
    TextWidget:SetText(Utils.FormatNumber(OrigNum, false))
    UpdateDestTotalTime = UpdateDestTotalTime or 1
    IntervalTime = IntervalTime or 0.01
    local DestNum = OrigNum + AddNum
    local IsDone = false
    local AddNumPerTime = AddNum / (UpdateDestTotalTime / IntervalTime)
    UIState:AddTimer(IntervalTime, function()
        if IsDone then
            UIState:RemoveTimer("UpdateNum")
            return
        end
        OrigNum = OrigNum + AddNumPerTime
        if AddNumPerTime < 0 then
            OrigNum = math.max(OrigNum, DestNum)
        else
            OrigNum = math.min(OrigNum, DestNum)
        end
        
        if OrigNum == DestNum then
            IsDone = true
        end
        TextWidget:SetText(Utils.FormatNumber(OrigNum, false))
    end, true, 0, "UpdateNum", true)
    return DestNum
end

function UIUtils.GenAbyssEntryDesc(Desc,EntryConf, BaseLevel, ExpectLevel)
    if not ArmoryUtils then
        ArmoryUtils=require "BluePrints.UI.WBP.Armory.ArmoryUtils"
    end
    ExpectLevel = ExpectLevel == nil and BaseLevel or ExpectLevel
    for i, DescValue in pairs(EntryConf or {}) do 
        local Percent = string.match(DescValue, "%%") or ""
        local ValStr =  ArmoryUtils:_ModAttrGrowDesc2(DescValue, BaseLevel,  BaseLevel,Percent) or ""
        ValStr = ValStr=="" and SkillUtils.CalcSkillDesc(DescValue,BaseLevel)..Percent or ValStr
        if(ExpectLevel)then
            local ComparedValStr = ArmoryUtils:_ModAttrGrowDesc2(DescValue, ExpectLevel, ExpectLevel,Percent) or ""
            ComparedValStr  = ComparedValStr=="" and SkillUtils.CalcSkillDesc(DescValue,BaseLevel)..Percent or ComparedValStr
            if( ValStr ~= ComparedValStr )then
                ValStr=  ValStr .. "->" .. ComparedValStr 
            end
        end
        Desc = string.gsub(Desc, "#"..i, ValStr)
    end
    return Desc
end

function UIUtils.GenerateArmoryPreviewParamsBySquadInfo(InOutParams,SquadInfo)
    local ModUuid = 1
	local InitTargetModInfo = function(TargetInfo,Target)
        if(not TargetInfo.ModData)then return end
        local ModSlotPolarity = Target and Target.ModSlotPolarity or {}
        TargetInfo.ModSuitIndex = 1
        TargetInfo.SlotData ={}
        for i, value in ipairs(TargetInfo.ModData) do
            value.Uuid = ModUuid
            TargetInfo.SlotData[i] = {SlotId = i,Polarity = ModSlotPolarity[i] or -1,ModEid = ModUuid}
            ModUuid = ModUuid +1
        end
    end
	local Avatar = InOutParams.Avatar or GWorld:GetAvatar()
    local AvatarBattleInfo = AvatarUtils:GetDefaultBattleInfo(Avatar,SquadInfo) or {}
	InitTargetModInfo(AvatarBattleInfo.RoleInfo,SquadInfo.Char)
    InOutParams.PreviewCharInfos = {AvatarBattleInfo.RoleInfo}
	InitTargetModInfo(AvatarBattleInfo.MeleeWeapon,SquadInfo.MeleeWeapon)
	InitTargetModInfo(AvatarBattleInfo.RangedWeapon,SquadInfo.RangedWeapon)
    InOutParams.PreviewWeaponInfos = {AvatarBattleInfo.MeleeWeapon,AvatarBattleInfo.RangedWeapon}
    InOutParams.PreviewUWeaponInfos = {}
    if(AvatarBattleInfo.UltraWeapons)then
        for i, value in ipairs(AvatarBattleInfo.UltraWeapons) do
			InitTargetModInfo(value,SquadInfo.UltraWeapons[i])
            table.insert(InOutParams.PreviewUWeaponInfos,value)
        end
    end
    return InOutParams
end

function UIUtils.LoadSkillIconById(SkillId)
    local SkillData = DataMgr.Skill[SkillId]
    local Data = SkillData and SkillData[1] and SkillData[1][0]
    local Icon = nil
    if(Data)then
        local IconName = Data.SkillBtnIcon
        if(IconName)then
            Icon = LoadObject("/Game/UI/Texture/Dynamic/Atlas/Skill/T_"..IconName..".T_"..IconName)
        end
    end
    Icon = Icon or LoadObject('/Game/UI/Texture/Dynamic/Atlas/Skill/T_Skill_Heitao_Skill01.T_Skill_Heitao_Skill01')
    return Icon
end

function UIUtils.CalcWidgetCenter(Widget)
    local Geometry = Widget:GetTickSpaceGeometry()
    local LocalCenter = USlateBlueprintLibrary.GetLocalSize(Geometry) / 2
    return USlateBlueprintLibrary.LocalToAbsolute(Geometry,LocalCenter)
end

-- 查询一个ScrollBox是否可以滑动，如果不准建议延迟一帧或者等动画结束
---@param Widget ScrollBox 
function UIUtils.CheckScrollBoxCanScroll(Widget)
    local Offset = Widget:GetScrollOffsetOfEnd()
    return Offset > 5
end

---使用AnalogInputEvent传递的事件驱动ScrollBoxgundong
---@param ScrollBox UScrollBox 需要滚动的ScrollBox
---@param InAnalogInputEvent FInputAnalogEvent 输入事件
---@param Velocity number 滚动速度
---@param DeadZone number 摇杆死区
function UIUtils.ScrollBoxByGamepad(ScrollBox, InAnalogInputEvent, Velocity, DeadZone)
    Velocity = Velocity or 20
    DeadZone = DeadZone or 5

    local DeltaOffset = (-1) * UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * Velocity
    if math.abs(DeltaOffset) < DeadZone then return end    -- 摇杆死区
    local CurrentOffset = ScrollBox:GetScrollOffset()
    local OffsetToEnd = ScrollBox:GetScrollOffsetOfEnd()
    local NextOffset = math.clamp(CurrentOffset + DeltaOffset, 0, OffsetToEnd)
    ScrollBox:SetScrollOffset(NextOffset)
end

function UIUtils.HasAnyFocus(Widget)
    return Widget:HasAnyUserFocus() or Widget:HasFocusedDescendants()
end

-- 传ActionName, 返回对应ImgShortPath的List
function UIUtils.GetIconListByActionName(ActionName)
    local GamepadLayout = EMCache:Get("GamepadLayout") or tonumber(DataMgr.Option["GamepadPreset"].DefaultValue)
    local IconList
    local ActionData = DataMgr.GamepadMap[ActionName]
    if ActionData then
        IconList = ActionData.GamepadIcon[GamepadLayout]
    else
        print(_G.ErrorTag, ActionName, "：此Action没有对应的键位，请检查拼写或检查GamepadSet表里是否有填写")
    end
    if not IconList then
        print(_G.ErrorTag, ActionName, "：目前的预设方案没有对应的键位，请检查GamepadSet表里是否有填写")
    else
        return IconList
    end
end

function UIUtils.GetIconListByActionNameAndSetNum(ActionName, Num)
    local ActionData = DataMgr.GamepadMap[ActionName]
    if ActionData then
        return ActionData.GamepadIcon[Num]
    end
end

--region 文本框相关的轮子
---@alias UniversalTextBlock URichTextBlock|UTextBlock|UMultiLineEditableText|UMultiLineEditableText 

---获取文本控件字体数据的轮子
---@param TextWidget UniversalTextBlock 文本框
---@return FSlateFontInfo
function UIUtils.GetTextFont(TextWidget)
    assert(TextWidget:IsA(UTextLayoutWidget), "UIUtils.GetTextFont, 错误，参数TextWidget必须是文本控件")
    ---@type FSlateFontInfo
    local Font = nil
    if TextWidget:IsA(URichTextBlock) then
        if TextWidget.bOverrideDefaultStyle then
            Font = TextWidget.DefaultTextStyleOverride.Font
        else
            Font = TextWidget.DefaultTextStyle.Font
        end
    elseif TextWidget:IsA(UTextBlock) then
        Font = TextWidget.Font
    elseif TextWidget:IsA(UMultiLineEditableText) then
        Font = TextWidget.WidgetStyle.Font
    elseif TextWidget:IsA(UMultiLineEditableTextBox) then
        Font = TextWidget.WidgetStyle.Font
    end
    if not Font then
        GWorld.logger.error("UIUtils.GetTextFont 参数TextWidget是不支持的文本文本控件，其他文本控件类型有需要的再考虑扩展")
    end
    return Font
end

function UIUtils.CheckCdnHide(UIName,ShowToast)
    local Avatar = GWorld:GetAvatar()
    local UIData={}
    if Avatar and Avatar.CdnHideData and Avatar.CdnHideData.game_ui then
        UIData = Avatar.CdnHideData.game_ui
    else
        return false
    end
    for _, MainUIConfig in pairs(DataMgr.MainUI) do
        if UIName==MainUIConfig.SystemUIName then
            for __, Data in pairs(UIData) do
                if Data.config==false then
                    for ___,HideUIName in pairs(Data.gameCtrlGameUI) do
                        if HideUIName==MainUIConfig.Name then
                            UIUtils.ShowMainUIFobidToast(MainUIConfig)
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

function UIUtils.ShowMainUIFobidToast(MainUIConfig)
    if MainUIConfig.UIUnlockRuleName then
        local UIUnlockRule = DataMgr.UIUnlockRule
        local OpenDescs=UIUnlockRule[MainUIConfig.UIUnlockRuleName].OpenSystemDesc
        if OpenDescs then
            local UIManager = GWorld.GameInstance:GetGameUIManager()
            if UIManager then
                UIManager:ShowUITip(UIConst.Tip_CommonToast, OpenDescs[1])
            end
        end
    end
end


---计算单行文本的文本框期望高度
---@param TextWidget UniversalTextBlock 文本框
---@return number
function UIUtils.CalcOnelineTextDesireHeight(TextWidget)
    assert(TextWidget:IsA(UTextLayoutWidget), "UIUtils.CalcOnelineTextDesireHeight, 错误，参数TextWidget必须是文本控件")
    local Font = UIUtils.GetTextFont(TextWidget)
    if not Font then return end
    --计算单行文本的文本框高度的核心算法
    local FontHeight = UUIFunctionLibrary.GetFontHeight(Font)*TextWidget.LineHeightPercentage
    local OnelineDesireHeight = TextWidget.Margin.Top+TextWidget.Margin.Bottom+FontHeight
    return OnelineDesireHeight
end

---根据行数设置文本的对齐方式（默认单行居中，多行居左）
---@param TextWidget UniversalTextBlock 文本框
---@param bForceCenter boolean @[opt] 该项为true，且当Justifications有居中的枚举时，强制文本居中
---@param ExpectLine number @[opt] 设置要检测的行数，默认一行
---@param Justifications table<ETextJustify> @[opt] 设置文本对齐方式，第一个参数为不超过检测行数的对齐方式，第二个参数反之
function UIUtils.SetTextJustificationByLineCount(TextWidget, bForceCenter ,ExpectLine, Justifications) 
    assert(TextWidget:IsA(UTextLayoutWidget), "UIUtils.LayoutTextByLineRule, 错误，参数TextWidget必须是文本控件")
    local DesireHeight = TextWidget:GetDesiredSize().Y
    if DesireHeight == 0 then
        TextWidget:ForceLayoutPrepass()
        DesireHeight = TextWidget:GetDesiredSize().Y
    end
    if DesireHeight == 0 then
        GWorld.logger.error("UIUtils.LayoutTextByLineRule 参数TextWidget没有绘制完或者自身高度就是0，无法判断什么时候该换行")
        return
    end
    if not ExpectLine then ExpectLine = 1 end
    if not Justifications then 
        Justifications = { ETextJustify.Center, ETextJustify.Left }
    end
    if bForceCenter then
        for _,Justification in ipairs(Justifications) do
            if Justification == ETextJustify.Center then
                TextWidget:SetJustification(Justification)
                return
            end
        end
    end
    local Factor = 0.5
    ---手柄按键太大了，需要特殊处理
    if (UIUtils.IsGamepadInput()) then
        local Text = TextWidget:GetText()
        if string.match(Text, "<img.-%s*></>") then
            Factor = 1
        end
    end

    local OnelineDesireHeight = UIUtils.CalcOnelineTextDesireHeight(TextWidget)
    if DesireHeight<=OnelineDesireHeight*(ExpectLine+Factor) then
        TextWidget:SetJustification(Justifications[1])
    else
        TextWidget:SetJustification(Justifications[2])
    end
end
--endregion

function UIUtils.LoadPreviewSkillDetails(Parent,Params)
    if(not Parent)then
        return
    end
    Params = Params or {}
    local UIConfig = DataMgr.SystemUI.SkillDetails
    local GameInstance = GWorld.GameInstance
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    local CharInfo = {}
    local WeaponInfos = {}
    local MeleeWeaponInfo
    local RangedWeaponInfo
    local InitInfo
    if not IsStandAlone(Player) then
        -- InitInfo = Player.BornInfo
        -- CharInfo = CommonUtils.CopyTable(Player.BornInfo)
        local Avatar=GWorld:GetAvatar()
        for _, Value in pairs(Avatar.Chars) do
            if Value.CharId==Player.CurrentRoleId then
                CharInfo=AvatarUtils:GetCharBattleInfo(Avatar, Value, Value.ModSuitIndex).RoleInfo
                break
            end
        end
    else
        InitInfo = Player.InfoForInit
        CharInfo = CommonUtils.CopyTable(Player.InfoForInit)
    end
    if(InitInfo)then
        if(InitInfo.MeleeWeapon)then
            MeleeWeaponInfo = CommonUtils.CopyTable(InitInfo.MeleeWeapon)
            if(MeleeWeaponInfo)then
                table.insert(WeaponInfos,MeleeWeaponInfo)
            end
        end
        if(InitInfo.RangedWeapon)then
            RangedWeaponInfo = CommonUtils.CopyTable(InitInfo.RangedWeapon)
            if(RangedWeaponInfo)then
                table.insert(WeaponInfos,RangedWeaponInfo)
            end
        end
    end
    CharInfo.ModSuitIndex = CharInfo.ModSuitIndex or 1
    CharInfo.SlotData = CharInfo.SlotData or {}
    for index, value in ipairs(CharInfo.ModData or {}) do
        CharInfo.SlotData[index] = CharInfo.SlotData[index] or {}
        local SlotData = CharInfo.SlotData[index]
        SlotData.SlotId = SlotData.SlotId or index
        SlotData.Polarity = SlotData.Polarity or -1
        if(not value.Uuid or value.Uuid == "" or value.Uuid == 0 or value.Uuid == -1)then
            value.Uuid = index
        end
        if(not SlotData.ModEid or SlotData.ModEid == "" or SlotData.ModEid == 0 or SlotData.ModEid == -1)then
            SlotData.ModEid = value.Uuid
        end
    end
    UIManager(Parent):LoadUI(UIConst.LoadInConfig, UIConfig.UIName,Parent:GetZOrder(),
    {   OnClosedObj = Parent,
        OnClosedCallback = Params.OnClosedCallback,
        PreviewCharInfos = {CharInfo},
        PreviewWeaponInfos = WeaponInfos,
        MeleeWeapon = MeleeWeaponInfo,
        RangedWeapon = RangedWeaponInfo,
        IsPreviewMode = true,})
end

function UIUtils.GenRougeCombatTermDesc(SkillDesc, Terms)
    local results = {SkillDesc}
    UIUtils.AddHyperLink(results,Terms,1)
    local DescText = ""
    for index, value in ipairs(results) do
        DescText = DescText .. value
    end
    return DescText
end

function UIUtils.AddHyperLink(StrArray,Terms,TermIdx)
    if(TermIdx > #Terms)then
        return
    end
    local Term = GText(DataMgr.CombatTerm[Terms[TermIdx]].CombatTerm)
    local LStr,RStr,bSuccess = UKismetStringLibrary.Split(StrArray[#StrArray],Term)
    if(not bSuccess)then
        UIUtils.AddHyperLink(StrArray,Terms,TermIdx+1)
    else
        StrArray[#StrArray] = LStr
        UIUtils.AddHyperLink(StrArray,Terms,TermIdx+1)
        table.insert(StrArray,'<H_Under>' .. Term .. '</>')
        table.insert(StrArray,RStr)
        UIUtils.AddHyperLink(StrArray,Terms,TermIdx)
    end
end

---处理名词解释超链接点击事件
---@param TargetWidget       目标控件，用于显示弹窗的父控件
---@param Terms Table        名词解释ID数组
---@param ClickTerm string   被点击的名词解释ID，用于定位当前选中项
function UIUtils.OnDefinitionLinkClicked(TargetWidget, Terms, ClickTerm)
    if not TargetWidget or not Terms or not next(Terms) then
        return
    end
    local Params = {
        DefinitionItems = {}
    }
    for i, ExplanationId in ipairs(Terms) do
        local TermData = DataMgr.CombatTerm[ExplanationId]
        if not TermData then
            goto continue
        end
        if ClickTerm == ExplanationId then
            Params.CurrentItemIndex = i - 1
        end
        local TermName = GText(TermData.CombatTerm)
        table.insert(Params.DefinitionItems, {
            Index = i - 1,
            Name = TermName,
            Des = GText(TermData.CombatTermExplaination),
        })
        ::continue::
    end
    -- 名词解释弹窗会被保存在DefinitionWidget中
    TargetWidget.DefinitionWidget = UIManager(TargetWidget):ShowCommonPopupUI(100266, Params)
end

---递归添加名词解释超链接到字符串数组中
function UIUtils.AddDefinitionHyperLink(StrArray,Terms,TermIdx)
    if(TermIdx > #Terms)then
        return
    end
    local ExplanationId = Terms[TermIdx]
    if(not DataMgr.CombatTerm[ExplanationId])then
        return
    end
    local Term = GText(DataMgr.CombatTerm[Terms[TermIdx]].CombatTerm)
    local LStr, RStr, bSuccess = UKismetStringLibrary.Split(StrArray[#StrArray],Term)
    if(not bSuccess)then
        UIUtils.AddDefinitionHyperLink(StrArray, Terms, TermIdx+1)
    else
        StrArray[#StrArray] = LStr
        UIUtils.AddDefinitionHyperLink(StrArray, Terms, TermIdx+1)
        table.insert(StrArray, table.concat({'<a href="', Terms[TermIdx], '"', ' color="#E0A24A">', Term, '</>'}))
        table.insert(StrArray, RStr)
        UIUtils.AddDefinitionHyperLink(StrArray, Terms, TermIdx)
    end
end

---设置文本控件的名词解释超链接文本
---@param TargetTextWidget Widget   目标文本控件，RichTextBlock类型
---@param Terms Table               名词解释ID数组
function UIUtils.SetDefinitionText(TargetTextWidget, Terms)
    if not TargetTextWidget or not Terms or not Terms then
        return
    end
    local TargetText = tostring(TargetTextWidget:GetText())
    local Results = {TargetText}
    UIUtils.AddDefinitionHyperLink(Results, Terms, 1)
    local DescText = table.concat(Results)
    --TargetTextWidget:SetJustification(ETextJustify.Left)
    TargetTextWidget:SetText(GText(DescText))
end

---初始化名词解释文本控件的通用接口
---@param TargetWidget     Widget       目标控件，用于绑定点击事件和显示弹窗的父控件
---@param TargetTextWidget Widget       目标文本控件，RichTextBlock类型，用于显示带超链接的文本
---@param TermsStr string               名词解释数组的字段名，对应TargetWidget中存储名词解释ID数组的字段名
---@param CustomClickCallback function  自定义点击回调函数，可选参数，用于覆盖默认点击事件
function UIUtils.InitDefinitionTextWidget(TargetWidget, TargetTextWidget, TermsStr, CustomClickCallback)
    if not TargetWidget or not TargetTextWidget then
        return
    end
    local DecoratorClass = UE.UClass.Load("/Game/UI/Blueprint/BP_HyperLinkDecorator.BP_HyperLinkDecorator_C")
    local Decorator = TargetTextWidget:GetDecoratorByClass(DecoratorClass)
    if(Decorator)then
        Decorator.BP_OnClicked:Clear()
        Decorator.BP_OnClicked:Add(TargetWidget, function(InTargetWidget, InClickTerm)
            if not InTargetWidget then return end
            if CustomClickCallback and type(CustomClickCallback) == "function" then
                CustomClickCallback(InTargetWidget, TargetWidget[TermsStr], InClickTerm)
            else
                UIUtils.OnDefinitionLinkClicked(TargetWidget, TargetWidget[TermsStr], InClickTerm)
            end
        end)
    end
    TargetWidget:AddDelayFrameFunc(function()
        if TargetWidget and TargetWidget.bSkipDefinitionAutoInit then
            return
        end
        UIUtils.SetDefinitionText(TargetTextWidget, TargetWidget[TermsStr])
    end, 2, "UpdateTargetTextFunc")
end

function UIUtils.AddPositioningTagToPanel(Panel,CharId)
    if(not Panel or not CharId)then
        return
    end
    local WidgetCount = 0
    local Data = DataMgr.BattleChar[CharId]
    if(Data and Data.Positioning)then
        local IconWidget = Panel:GetChildAt(0)
        if not IconWidget then
            return
        end
        local UIManager = UIManager(Panel)
        local IconWidgetClass = UGameplayStatics.GetObjectClass(IconWidget)
        for _, value in pairs(Data.Positioning) do
            local PData = DataMgr.Positioning[value]
            if(PData)then
                IconWidget = Panel:GetChildAt(WidgetCount)
                if(not IconWidget)then
                    IconWidget = UIManager:CreateWidget(IconWidgetClass)
                    Panel:AddChild(IconWidget)
                end
                if(PData.Icon)then
                    IconWidget:SetIcon(LoadObject(PData.Icon))
                end
                WidgetCount = WidgetCount + 1
            end
        end
    end
    
    if(WidgetCount > 0)then
        Panel:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        local Start,End = WidgetCount,Panel:GetChildrenCount() - 1
        for i = End,Start,-1 do
            Panel:RemoveChildAt(i)
        end
    else
        Panel:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function UIUtils.GetCharMiniIconPath(CharId)
    local PhantomGuideIconImg = "T_Normal_" .. DataMgr.BattleChar[CharId].GuideIconImg
    return "Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Mini/"..PhantomGuideIconImg.."."..PhantomGuideIconImg.."'"
end

-- 可以输入 lua.do UIUtils:OpenPopupToArmory()测试
-- 打开跳转军械库的弹窗，弹窗在军械库关闭后会重新弹出
---@param OtherPopupParms table 自定义其他弹窗参数，作为ShowCommonPopupUI时的Parms
---  自定义参数如果使用了RightCallbackFunction，RightCallbackObj，OnCloseCallbackFunction会覆盖原来的，谨慎使用
function UIUtils:OpenPopupToArmory(OtherPopupParms)

    local OpenArmoryFromPopup = function(Obj, Data, DialogWidget)
        DialogWidget.ClickResult = true
    end
    ---用OnDialogClosedCallback而不是RightCallbackFunction的原因是军械库界面会暂停弹窗关闭动画，导致关闭界面后还有老的弹窗残留
    local OnDialogClosedCallback = function(Obj, Data, DialogWidget)
        if DialogWidget.ClickResult == true then
            DebugPrint("OpenArmoryFromPopup")
            PageJumpUtils:JumpToTargetPageByJumpId(52)
            local ArmoryMain = UIManager(self):GetUIObj("ArmoryMain")
            if ArmoryMain then
                UIManager(self):GetUIObj("ArmoryMain").OnCloseDelegate = {nil, function()
                    UIUtils:OpenPopupToArmory()
                end, self}
            else
                ScreenPrint("没有找到军械库界面，关闭界面后不会打开弹窗。")
            end

        end
    end
    local Parms = {
        RightCallbackFunction = OpenArmoryFromPopup,
        RightCallbackObj = self,
        OnCloseCallbackFunction = OnDialogClosedCallback
    }

    UIManager(self):ShowCommonPopupUI(100217, Parms, self)
end

---根据称号ID计算得出完整的称号文字
function UIUtils.CalculateHoleTitle(TitleBefore,TitleAfter)
    local TitleBeforeText, TitleAfterText = nil, nil
    if TitleBefore ~= -1 and DataMgr.Title[TitleBefore] then
        TitleBeforeText = DataMgr.Title[TitleBefore].Name or nil
    end
    if TitleAfter ~= -1 and DataMgr.Title[TitleAfter].Name then
        TitleAfterText = DataMgr.Title[TitleAfter].Name or nil
    end

    if TitleBeforeText then
        TitleBeforeText=GText(TitleBeforeText) or ""
    end
    if TitleAfterText then
        TitleAfterText=GText(TitleAfterText) or ""
    end

    local  WholeTitle=(TitleBeforeText or "")..(TitleAfterText or "")
    if CommonConst.SystemLanguage == CommonConst.SystemLanguages.FR then
        WholeTitle = (TitleAfterText or " ")..(TitleBeforeText and string.format(" %s",TitleBeforeText) or " ")
    end
    return WholeTitle
end

---获取整理好的称号表
function UIUtils.GetSortedTitleTable()

    local Avatar = GWorld:GetAvatar()
    local PrefixTitles = {}
    local SuffixTitles = {}
    local AllTitles = Avatar.Titles
    for index, value in pairs(AllTitles) do
        if DataMgr.Title[index] then
            local TitleData = DataMgr.Title[index]
            local TitleContent = {
                Name = TitleData.Name,
                TitleID = TitleData.TitleID
            }

            if TitleData.IfSuffix then
                table.insert(SuffixTitles, TitleContent)
            else
                table.insert(PrefixTitles, TitleContent)
            end
        end
        -- body
    end
    return PrefixTitles, SuffixTitles
end
--- 根据稀有度Text的材质内换色
---@param UI 传入UI Widget  self即可
---@param Text 传入Text Widget
---@param Rarity 传入稀有度
function UIUtils:SetTextColorInMaterialByRarity(UI,Text, Rarity)
    -- 设置稀有度颜色
    local FontMaterial = Text:GetDynamicFontMaterial()
    if Rarity == 5 then
        FontMaterial:SetTextureParameterValue("IconTex", UI.Img_Text_5)
    elseif Rarity == 4 then
        FontMaterial:SetTextureParameterValue("IconTex", UI.Img_Text_4)
    elseif Rarity == 3 then
        FontMaterial:SetTextureParameterValue("IconTex", UI.Img_Text_3)
    elseif Rarity == 2 then
        FontMaterial:SetTextureParameterValue("IconTex", UI.Img_Text_2)
    elseif Rarity == 1 then
        FontMaterial:SetTextureParameterValue("IconTex", UI.Img_Text_1)
    else
        FontMaterial:SetTextureParameterValue("IconTex", UI.Img_Text_0)
    end
end

---设置称号显示的通用接口
---@param TitleWidget     称号显示控件,通常是self.Title(Overlay类型)
---@param TitleInfo Table 用户称号信息，包含TitleBefore,TitleAfter,TitleFrame即可
---@param bPlayInAnimation boolean 是否播放In动效
function UIUtils.SetTitle(TitleWidget, TitleInfo, bPlayInAnimation)
    if TitleWidget then
        TitleWidget:ClearChildren()
        TitleWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        return
    end
    if not TitleInfo then
        return
    end
    local PrefixId = TitleInfo.TitleBefore
    local SuffixId = TitleInfo.TitleAfter
    local TitleFrameId = TitleInfo.TitleFrame
    if (not PrefixId or PrefixId <= 0) and (not SuffixId or SuffixId <= 0) then
        return
    end
    TitleWidget:SetVisibility(UIConst.VisibilityOp.Visible)
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    if UIManager and UIManager.LoadTitleFrameWidget then
        local TitleFrameWidget = UIManager:LoadTitleFrameWidget(TitleFrameId or -1)
        if TitleFrameWidget then
            local SlotWidget = TitleWidget:AddChild(TitleFrameWidget)
            if SlotWidget then
                if TitleFrameWidget.SetTitleContent then
                    TitleFrameWidget:SetTitleContent(PrefixId, SuffixId)
                elseif TitleFrameWidget.SetTitle then
                    TitleFrameWidget:SetTitle(PrefixId, SuffixId)
                elseif TitleFrameWidget.SetEmpty and ((not PrefixId or PrefixId <= 0) and (not SuffixId or SuffixId <= 0)) then
                    TitleFrameWidget:SetEmpty()
                end
            end
            if bPlayInAnimation and TitleFrameWidget.In then
                TitleFrameWidget:PlayAnimation(TitleFrameWidget.In)
            end
        end
    end
end

function UIUtils.SetUpScrollBox(ScrollBox)
    if not ScrollBox then
        DebugPrint("Invalid scroll box parameter")
        return
    end

    if UIUtils.IsMobileInput() then
        ScrollBox:SetControlScrollbarInside(false)
    else 
        ScrollBox:SetScrollBarVisibility(UIConst.VisibilityOp.Hidden)
        ScrollBox:SetControlScrollbarInside(true)
    end
end

---@note 返回UUserWidget的RootWidget
---@param UEMUserWidget or UUIState or UUSerWidget
-- @return UWidget
function UIUtils.GetRootUWidget(Widget)
    if not Widget then
        return nil
    end
    
    if Widget.GetUWidgetSoul then
        return Widget:GetUWidgetSoul()
    elseif Widget.WidgetTree and Widget.WidgetTree.RootWidget then
        return Widget.WidgetTree.RootWidget
    end
    
    return nil
end

function UIUtils:GatFastKeyInfo(Key,Des)
    Key=Key or "A"
    local KeyInfo={
        KeyInfoList = {{
            Type = "Img",
            ImgShortPath = Key
        }},
         Desc =Des, 
    }
    return KeyInfo
end

function UIUtils.GetDynamicRewardInfo(DynamicRewardId, Timestamp)
	Timestamp = Timestamp or TimeUtils.NowTime()
	local DynamicRewardData = DataMgr.DynamicReward[DynamicRewardId]
	if not DynamicRewardData then
		return
	end
	for Index, RewardInfo in pairs(DynamicRewardData) do
        if Timestamp >= RewardInfo.StartTime and Timestamp <= RewardInfo.EndTime then
            return RewardInfo
        end
	end
end

---@note 根据传入时间戳获取 剩余时间 具体规则为：超过一天显示 XX天XX时、不足一天显示 XX时XX分 、 不足1小时显示 XX分XX秒
---@param EndTimestamp 时间戳
---@param bUseCharFormat 是否使用字符格式 如 30分15秒 -> 30:15
-- @return string
function UIUtils.GetRemainingTimeByTimestamp(EndTimestamp, bUseCharFormat)
	local NextRefreshTime = EndTimestamp
	local CurrentTime = TimeUtils.NowTime()
	local RemainRefreshTime = NextRefreshTime - CurrentTime
    if RemainRefreshTime < 0 then
        RemainRefreshTime = 0
    end
	local RemainTimeStr = ""
    local CharFormat = "%02d:"
    local TimeCount = 0
    if RemainRefreshTime > 24 * 60 * 60 then
        TimeCount = TimeCount + 1
        local Str = bUseCharFormat and CharFormat or "UI_Time_Day_NotHighlight"
        RemainTimeStr = RemainTimeStr .. string.format(GText(Str), math.floor(RemainRefreshTime / (24 * 60 * 60)))
        RemainRefreshTime = RemainRefreshTime % (24 * 60 * 60)
    end
    if RemainRefreshTime > 60 * 60 or TimeCount == 1 then
        TimeCount = TimeCount + 1
        local Str = bUseCharFormat and CharFormat or "UI_Time_Hour_NotHighlight"
        RemainTimeStr = RemainTimeStr .. string.format(GText(Str), math.floor(RemainRefreshTime / (60 * 60)))
        RemainRefreshTime = RemainRefreshTime % (60 * 60)
    end
    if (RemainRefreshTime > 60 and TimeCount < 2) or TimeCount == 0 then
        TimeCount = TimeCount + 1
        local Str = bUseCharFormat and CharFormat or "UI_Time_Minute_NotHighlight"
        RemainTimeStr = RemainTimeStr .. string.format(GText(Str), math.floor(RemainRefreshTime / 60))
        RemainRefreshTime = RemainRefreshTime % 60
    end
    if (RemainRefreshTime > 0 and TimeCount < 2) or TimeCount == 1 then
        TimeCount = TimeCount + 1
        local Str = bUseCharFormat and CharFormat or "UI_Time_Second_NotHighlight"
        RemainTimeStr = RemainTimeStr .. string.format(GText(Str), RemainRefreshTime)
    end
    if bUseCharFormat then
        -- 去掉最后一个冒号
        RemainTimeStr = string.sub(RemainTimeStr, 1, -2)
    end
    return RemainTimeStr
end

function UIUtils:LongPressKey(KeyWidget, func, Speed)
    if KeyWidget:IsAnimationPlaying(KeyWidget.LongPress)  then
        return
    end

    -- 开始播放长按“蓄力”音效，并使用 "LongPress" 作为可中断的标签
    AudioManager(KeyWidget):PlayUISound(KeyWidget, "event:/ui/common/btn_press", "LongPress", nil)

    KeyWidget:UnbindAllFromAnimationFinished(KeyWidget.LongPress)
    KeyWidget:BindToAnimationFinished(KeyWidget.LongPress, function()
        if not KeyWidget.IsLongPressing then
            -- 如果长按被中断，音效已在 StopLongPressKey 中停止
            return
        end
        -- 长按成功，停止“蓄力”音效
        AudioManager(KeyWidget):StopSound(KeyWidget, "LongPress")

        if func then func() end
        KeyWidget:PlayAnimation(KeyWidget.Normal)
        KeyWidget.IsLongPressing = false
    end)

    if not KeyWidget then
        return
    end
    KeyWidget.IsLongPressing = true
    KeyWidget:PlayAnimation(KeyWidget.LongPress)
end

function UIUtils:StopLongPressKey(KeyWidget)
    if not KeyWidget.IsLongPressing then
        return
    end
    
    -- 中断长按，通过标签 "LongPress" 停止正在播放的“蓄力”音效
    AudioManager(KeyWidget):StopSound(KeyWidget, "LongPress")

    KeyWidget:UnbindAllFromAnimationFinished(KeyWidget.LongPress)
    KeyWidget:StopAllAnimations()
    KeyWidget:PlayAnimation(KeyWidget.Normal)
    KeyWidget.IsLongPressing = false
end
---获取列表显示条目的最小和最大索引
---@param ListWidget UListView 列表控件
function UIUtils.GetMinAndMaxDisplayedItemIndex(ListWidget)
    local Entries = ListWidget:GetDisplayedEntryWidgets():ToTable()
    local MinEntryIdx = #Entries
    local MaxEntryIdx = 0
    for _, Entry in ipairs(Entries) do
        local index = ListWidget:GetIndexForItem(UUserObjectListEntryLibrary.GetListItemObject(Entry)) + 1
        if(index < MinEntryIdx)then
            MinEntryIdx = index
        end
        if(index > MaxEntryIdx)then
            MaxEntryIdx = index
        end
    end
    return MinEntryIdx,MaxEntryIdx
end
--打开多人挑战界面
---@param ChallengeId number 多人挑战ID 在MultiplayerChallenge表中
function UIUtils.OpenMultiplayerChallengeLevelChoose(ChallengeId)
    local GameInstance = GWorld.GameInstance
	local UIManager = GameInstance:GetGameUIManager()
    UIManager:LoadUINew("MultiplayerChallenge", ChallengeId )
end

-- @description 秘密设置焦点，不显示光标过渡
function UIUtils.SetFocusSecretly(Widget)
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(Widget)
    GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
    Widget:SetFocus()
    local StageTimerMgr = require "BluePrints.Common.StageTimerMgr"
    StageTimerMgr.AddTimer(Widget,0.25, function()
           GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
    end,nil,nil,nil,true,UE4.ETickingGroup.TG_EndPhysics)
    --Widget:SetNavigateMovingDurationTime(0.2)
end
-- 临时隐藏导航光标
---@param HideTime number 隐藏时间
function UIUtils.HideNavigateWidgetTemporarily(HideTime)
    if not HideTime or HideTime <= 0 then
        return
    end
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(GWorld.GameInstance)
    if not GameInputModeSubsystem then
        return
    end
    GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
    local StageTimerMgr = require "BluePrints.Common.StageTimerMgr"
    StageTimerMgr.AddTimer(GWorld.GameInstance, HideTime, function()
        GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
    end, false, HideTime, "UIUtils_HideNavigateWidgetTemporarily", true, UE4.ETickingGroup.TG_EndPhysics)
end

-- 获取在父节点下的相对位置
--@param SubWidget UWidget 需要计算坐标位置的控件
--@param ScreenPosition FVector2D 屏幕坐标
--@param TouchPointLocalOffset FVector2D 触摸点相对于控件左上角的偏移
--@return FVector2D 父节点下的相对位置，可以用于放置子控件SetPosition
function UIUtils.GetRelativePositionInParent(SubWidget, ScreenPosition, TouchPointLocalOffset)
    -- 第一步：将屏幕坐标转换为当前 Widget 的本地坐标
    local RootLayoutWidget = SubWidget:GetParent() or SubWidget
    local WidgetGeometry = RootLayoutWidget:GetCachedGeometry()
    local LocalPosInWidget = UE4.USlateBlueprintLibrary.AbsoluteToLocal(WidgetGeometry, ScreenPosition)
    local LocalWidgetSize = UE4.USlateBlueprintLibrary.GetLocalSize(WidgetGeometry)

    -- 第二步：获取当前 Widget 在其父容器中的位置
    local Slot = RootLayoutWidget.Slot
    if Slot then
        local WidgetPositionInParent = FVector2D(Slot:GetPosition().X, Slot:GetPosition().Y)

        -- 第三步：计算在父节点下的相对位置
        -- LocalPosInWidget 是相对于当前Widget左上角的位置
        -- 加上当前Widget在父容器中的位置，就是相对于父容器左上角的位置
        local LocalOffsetValue =  nil
        local SubWidgetGeometry = SubWidget:GetCachedGeometry()
        local RenderLocalScale = SubWidget and SubWidget.RenderTransform.Scale.X or 1.0
        local LocalSubWidgetSize = UE4.USlateBlueprintLibrary.GetLocalSize(SubWidgetGeometry)
        local SubWidgetAnchors = SubWidget.Slot:GetAnchors()
        local SubWidgetAligment = SubWidget.Slot:GetAlignment()

        -- 如果没传就默认取控件中心点
        if (TouchPointLocalOffset == nil) then
            TouchPointLocalOffset = FVector2D(LocalSubWidgetSize.X / 2, LocalSubWidgetSize.Y / 2)
        end        
        local DeltaWidthX = LocalSubWidgetSize.X * (1 - RenderLocalScale) * (TouchPointLocalOffset.X / LocalSubWidgetSize.X - 0.5)
        local DeltaWidthY = LocalSubWidgetSize.Y * (1 - RenderLocalScale) * (TouchPointLocalOffset.Y / LocalSubWidgetSize.Y - 0.5)

        LocalOffsetValue = FVector2D(
            LocalSubWidgetSize.X * (SubWidgetAligment.X - TouchPointLocalOffset.X / LocalSubWidgetSize.X),
            LocalSubWidgetSize.Y * (SubWidgetAligment.Y - TouchPointLocalOffset.Y / LocalSubWidgetSize.Y)
        )

        local CacluAnchors_X = math.max(SubWidgetAnchors.Maximum.X, SubWidgetAnchors.Minimum.X)
        local CacluAnchors_Y = math.max(SubWidgetAnchors.Maximum.Y, SubWidgetAnchors.Minimum.Y)

        local RelativePosInParent = FVector2D(
            WidgetPositionInParent.X + LocalPosInWidget.X - LocalWidgetSize.X * CacluAnchors_X + LocalOffsetValue.X + DeltaWidthX,
            WidgetPositionInParent.Y + LocalPosInWidget.Y - LocalWidgetSize.Y * CacluAnchors_Y + LocalOffsetValue.Y + DeltaWidthY
        )

        return RelativePosInParent
    end
    
    return LocalPosInWidget -- 如果没有父节点，返回Widget本地坐标
end

-- @description 将屏幕坐标转换为子控件相对于父控件的本地坐标
-- @param WorldContextObject UObject 上下文对象
-- @param SubWidget UWidget 需要计算坐标位置的控件
-- @param ScreenPosition FVector2D 屏幕坐标
-- @param TouchPointLocalOffset FVector2D 触摸点相对于控件左上角的偏移
function UIUtils.ConvertScreenToChildLocalPosition(WorldContextObject, SubWidget, ScreenPosition, TouchPointLocalOffset)
    local RootLayoutWidget = SubWidget:GetParent() or SubWidget
    local LayoutWidgetGeometry = RootLayoutWidget:GetCachedGeometry()
    local ScreenLocalPosInWidget = UE4.USlateBlueprintLibrary.AbsoluteToLocal(LayoutWidgetGeometry, ScreenPosition)
    -- local LayoutWidgetLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(LayoutWidgetGeometry)

    local Slot = SubWidget.Slot
    if Slot then
        local LocalWidgetPositionInParent = FVector2D(Slot:GetPosition().X, Slot:GetPosition().Y)

        -- 获取左上角的绝对坐标
        local SubWidgetAbsolutePosition = UIManager(WorldContextObject):GetWorldPosition(SubWidget)
        local SubWidgetGeometry = SubWidget:GetCachedGeometry()
        -- 获取子控件的绝对大小和本地大小
        local SubWidgetAbsoluteSize = UE4.USlateBlueprintLibrary.GetAbsoluteSize(SubWidgetGeometry)
        local SubWidgetLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(SubWidgetGeometry)
        -- 计算当前触控点在绝对坐标系下的位置
        local TouchPointAbsolutePos = FVector2D(
            SubWidgetAbsolutePosition.X + SubWidgetAbsoluteSize.X * (TouchPointLocalOffset.X / SubWidgetLocalSize.X),
            SubWidgetAbsolutePosition.Y + SubWidgetAbsoluteSize.Y * (TouchPointLocalOffset.Y / SubWidgetLocalSize.Y)
        )
        -- 将触控点的绝对位置转换为子控件平级的本地坐标
        local TouchPointLocalPosInWidget = UE4.USlateBlueprintLibrary.AbsoluteToLocal(LayoutWidgetGeometry, TouchPointAbsolutePos)

        local DeltaValueX = ScreenLocalPosInWidget.X - TouchPointLocalPosInWidget.X
        -- local DeltaValueX = math.max(-LayoutWidgetLocalSize.X, math.min(DeltaValueX, LayoutWidgetLocalSize.X))
        local DeltaValueY = ScreenLocalPosInWidget.Y - TouchPointLocalPosInWidget.Y
        -- local DeltaValueY = math.max(-LayoutWidgetLocalSize.Y, math.min(DeltaValueY, LayoutWidgetLocalSize.Y))

        -- 最终计算在父节点下的相对位置
        local RelativePosInParent = FVector2D(
            LocalWidgetPositionInParent.X + DeltaValueX,
            LocalWidgetPositionInParent.Y + DeltaValueY
        )

        return RelativePosInParent
    end
    
    return ScreenLocalPosInWidget -- 如果没有插槽，返回Widget本地坐标
end

function UIUtils.RefreshFeinaRewardReddot()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local Node = ReddotManager.GetTreeNode("FeinaEventReward")
    if not Node then
        ReddotManager.AddNodeEx("FeinaEventReward")
    end
    ReddotManager.ClearLeafNodeCount("FeinaEventReward",true)
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("FeinaEventReward")
    for Id,Info in pairs(DataMgr.FeinaEvent) do
        local AllDungeonHasReward = false
        for _, DungeonId in pairs(Info.DungeonId) do
            local RewardsGot=Avatar:GetFeinaRewardInfo(DungeonId)
            if RewardsGot then
                local HasRewardToGet = false
                for RewardIndex, State in pairs(RewardsGot) do
                    if State==1 then
                        if not CacheDetail[Id] then
                            CacheDetail[Id] = {}
                        end
                        if not CacheDetail[Id][DungeonId] then
                            CacheDetail[Id][DungeonId]={}
                        end
                        if not CacheDetail[Id][DungeonId][RewardIndex] then
                            CacheDetail[Id][DungeonId][RewardIndex] = 1
                        end
                        ReddotManager.IncreaseLeafNodeCount("FeinaEventReward")
                        HasRewardToGet = true
                        AllDungeonHasReward = true
                    elseif State ==2 then
                        if CacheDetail[Id] and CacheDetail[Id][DungeonId] and CacheDetail[Id][DungeonId][RewardIndex] then
                            CacheDetail[Id][DungeonId][RewardIndex] = nil
                        end
                    end
                end
                if not HasRewardToGet then
                    if CacheDetail[Id] and CacheDetail[Id][DungeonId] then
                        CacheDetail[Id][DungeonId] = nil
                    end
                end
            end
        end
        if not AllDungeonHasReward then
            if CacheDetail[Id] then
                CacheDetail[Id] = nil
            end
        end
    end
end

function UIUtils.ShouldDisplayItem(DataType,Id)
    return CommonUtils.IsCurrentTimeRealease(DataType,Id) and CommonUtils.IsCurrentVersionRealease(DataType,Id)
end

function UIUtils.CanOpenSkinPreview(ItemType, TypeId)
    if UIConst.SkinPreviewItemTypes[ItemType] then
        return true
    end
    
    if ItemType == "Resource" then
        local ResData = DataMgr.Resource[TypeId]
        return ResData and (ResData.ResourceSType == "GestureItem" and not UIConst.LimitPreviewResource[ResData.ResourceId])
    end
    
    return false
end

AssembleComponents(UIUtils)
return UIUtils
