require "UnLua"
local PageJumpFunctionLibrary = require "Utils.PageJumpFunctionConfig"
local GachaModel = require "BluePrints.UI.WBP.Gacha.GachaModel"
local ActivityUtils = require "BluePrints.UI.WBP.Activity.ActivityUtils"
local GameFlowUtils = require "Utils.GameFlowUtils"
local PageJumpUtils = {}

-------------------------------------------------------注意事项-------------------------------------------------------
--- PageJumpUtils分两部分：如果你的需求需要创建AccessItem请看第一部分，如果你只是寻找跳转接口请直接看第二部分

--- 一、生成跳转途径AccessItem
--- 这一部分可以根据传入的信息，生成跳转途径AccessItem，实现点击AccessItem进行跳转

--- 二、公共的跳转接口
--- 这一部分仅仅为跳转的接口，按需调用即可

--region 第一部分 创建获取途径
--- 设置物品获取途径
---@param ItemWidget Widget @需要加载获取途径Widget的父级Widget，如果传入不是UIState类型的Widget，请自行实现CreateWidgetNew方法
---@param ItemId number @物品ID
---@param ItemType string @物品类型
---@param AccessKey string @获取途径Key(对应DataMgr.Access)
function PageJumpUtils:GetItemAccess(ItemWidget, ItemId, ItemType, AccessKey, UIName, ReturnCallBack)
    local AccessData = DataMgr.Access[AccessKey]
    assert(AccessData, "找不到AccessData："..AccessKey)
    local AccessText = GText(AccessData.AccessText)

    self.UIPageName = nil
    if UIName then
        self.UIPageName = UIName
    elseif ItemWidget.UIName then
        self.UIPageName = ItemWidget.UIName
    end
    local ShopType
    if string.sub(AccessKey, 1, 5) == "Shop_" and AccessKey ~= "Shop_Pack" then
        ShopType = AccessData.AccessParam
        AccessKey = "Shop"
    end
    if string.sub(AccessKey, 1, 14) == "ImpressionShop" then
        AccessKey = "ImpressionShop"
    end

    local CommonParam = {}
    CommonParam.ItemWidget = ItemWidget
    CommonParam.AccessKey = AccessKey
    CommonParam.AccessText = AccessText
    CommonParam.UIName = self.UIPageName
    CommonParam.UIUnlockRuleId = AccessData.UIUnlockRuleId
    CommonParam.AccessParam = AccessData.AccessParam

    ---1、如果该次跳转仅需要判断系统UIUnlockRuleId是否能跳转请参考商店写法；
    ---函数请返回： 一个bool值表示是否生成对应AccessKey的获取途径；JumpToPage 表示AccessItem的点击回调

    ---如果该次跳转还需额外判断是否可跳转(如拼接关内某个子关卡是否解锁)，如果一个Accesskey存在多个跳转途径，请参考Dungeon写法
    ---请自定义额外判断逻辑以及添加AccessItem
    
    if AccessData.AccessRule == "InterfaceJump" then
        local AccessItem = self:CreateAccessItem(ItemWidget, AccessKey)
        AccessItem.Text_Method:SetText(GText(AccessText))
        AccessItem.Text_Method02:SetText(GText(AccessText))
        AccessItem.Text_Method01:SetText(GText(AccessText))
        local InterfaceJumpId = tonumber(AccessData.AccessParam)
        if not DataMgr.InterfaceJump[InterfaceJumpId] then
            return
        end
        local PlayerAvatar = GWorld:GetAvatar()
        AccessItem.IsText = false
        AccessItem.IsInteractive = true
        AccessItem.IsUnLock = false
        AccessItem.Switch_Type:SetActiveWidgetIndex(0)
        if (not ConditionUtils.CheckCondition(PlayerAvatar, DataMgr.InterfaceJump[InterfaceJumpId].PortalUnlockCondition)) then
            AccessItem.IsUnLock = true
            AccessItem.Switch_Type:SetActiveWidgetIndex(1)
        else
            local GameInstance = GWorld.GameInstance
            local UIManager = GameInstance:GetGameUIManager()
            local bIsCanOpen, FailedIdIndex = PlayerAvatar:CheckSystemUICanOpen(AccessData.UIUnlockRuleId)
            if bIsCanOpen then
                if self.UIPageName and DataMgr.SystemUI[self.UIPageName] and DataMgr.SystemUI[self.UIPageName].IsBanAccess then
                    AccessItem.JumpFunc = function()
                        UIManager:ShowUITip("CommonToastMain", GText("UI_COMMONPOP_TITLE_100059"))
                    end
                else
                    AccessItem.JumpFunc = function()
                        self:JumpToTargetPageByJumpId(InterfaceJumpId)
                    end
                end
            else
                local OpenConditionId = DataMgr.UIUnlockRule[AccessData.UIUnlockRuleId].OpenConditionId
                local OpenDescs = DataMgr.UIUnlockRule[AccessData.UIUnlockRuleId].OpenSystemDesc
                local ToastContent
                if #OpenConditionId ==#OpenDescs then
                    for _, Value in pairs(FailedIdIndex) do
                        ToastContent = OpenDescs[Value]
                    end
                else
                    ToastContent = OpenDescs[1]
                end
                --- 显示界面打开失败提示
                AccessItem.JumpFunc = function()
                    UIManager:ShowUITip("CommonToastMain", ToastContent)
                end
            end
        end
        ItemWidget.Method:AddChild(AccessItem)
        return
    end
    

    -- 跳转拼接
    if AccessKey == "Dungeon" or AccessKey == "MonsterStrong" then
        local bFromPlay = false
        if self.UIPageName == "StyleOfPlay" then
            bFromPlay = true
        end
        self:CreateJumpToDungeonAccess(CommonParam, ItemType, ItemId, bFromPlay)
        return
    end
        
    if string.sub(AccessKey, 1, 14) == "Dungeon_ModTab" then
        self:CreateJumpToDungeonModAccess(CommonParam, ItemType, ItemId)
        return
    end


    --@todo 全部自定义接口后删除
    local AccessItem = self:CreateAccessItem(ItemWidget, AccessKey)
    AccessItem.Btn_Click:SetVisibility(ESlateVisibility.Visible)
    if AccessKey == "Shop_Pack" then
        if not DataMgr.ShopItem2RewardPack[ItemType] or not DataMgr.ShopItem2RewardPack[ItemType][ItemId] then
            return
        end
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
            return
        end
        local ResItemData
        for _, ItemData in ipairs(DataMgr.ShopItem2RewardPack[ItemType][ItemId]) do
            local AccessItem = self:CreateAccessItem(ItemWidget, AccessKey)
            if Avatar:CheckShopItemCanPurchase(ItemData.ShopItemId) then
                if not (ResItemData and ResItemData.TypeId < ItemData.TypeId) then
                    ResItemData = ItemData
                end
            end
        end
        if not ResItemData then
            return
        end
        local res, JumpToPage = self:CreateJumpToShopAccess("Reward", ResItemData.ShopType, ResItemData.TypeId, nil, ReturnCallBack)
        if not res then
            return
        end
        self:ProcessAccessItem(AccessItem, AccessText, self.UIPageName, AccessData.UIUnlockRuleId, JumpToPage)
        ItemWidget.Method:AddChild(AccessItem)
        return
    end
    -- 跳转商城
    if AccessKey == "Shop" then
        CommonParam.AccessItem = AccessItem
        local res, JumpToPage = self:CreateJumpToShopAccess(ItemType, ShopType, ItemId, CommonParam, ReturnCallBack)
        if not res then
            return
        end
        -- self:ProcessAccessItem(AccessItem, AccessText, self.UIPageName, AccessData.UIUnlockRuleId,JumpToPage)
        ItemWidget.Method:AddChild(CommonParam.AccessItem)
        return
    end
    -- 跳转印象商店
    if AccessKey == "ImpressionShop" then
        CommonParam.AccessItem = AccessItem
        local res, JumpToPage = self:CreateJumpToImpressionShopAccess(ItemId, CommonParam)
        if not res then
            return
        end
        ItemWidget.Method:AddChild(CommonParam.AccessItem)
        return
    end

    -- 跳转密函委托
    if AccessKey == "Walnut" then
        self:CreateJumpToWalnutBag(CommonParam, ItemType, ItemId)
        return
    end

    -- 跳转铸造
    if AccessKey == "Forging" then
        local res, JumpToPage, NewText = self:CreateJumpToForge(AccessItem, ItemType, ItemId, AccessText)
        if not res then
            return
        end
        self:ProcessAccessItem(AccessItem, NewText, self.UIPageName, AccessData.UIUnlockRuleId,JumpToPage)
        ItemWidget.Method:AddChild(AccessItem)
        return
    end

    -- 跳转到据点
    if AccessKey == "Home" then
        local res, JumpToPage = self:CreateJumpToHome(AccessItem)
        if not res then
            return
        end
        self:ProcessAccessItem(AccessItem, AccessText, self.UIPageName, AccessData.UIUnlockRuleId,JumpToPage)
        ItemWidget.Method:AddChild(AccessItem)
        return
    end

    -- 跳转梦魇残声
    if AccessKey == "HardBoss" then
        CommonParam.AccessItem = AccessItem
        if self:CreateJumpToHardBoss(ItemId, CommonParam) then
            ItemWidget.Method:AddChild(CommonParam.AccessItem)
        end
        return
    end

    -- 大秘境跳转
    if AccessKey == "Abyss" then
        CommonParam.AccessItem = AccessItem
        if self:CreateJumpToAbyss(ItemId, CommonParam) then
            ItemWidget.Method:AddChild(CommonParam.AccessItem)
        end
        return
    end

    -- 处理纯文本的情况
    self:ProcessAccessItem(AccessItem, AccessText, self.UIPageName, AccessData.UIUnlockRuleId, nil)
    AccessItem.Btn_Click:SetVisibility(ESlateVisibility.Collapsed)
    ItemWidget.Method:AddChild(AccessItem)
end


--- 创建获取途径Widget
function PageJumpUtils:CreateAccessItem(ItemWidget,AccessKey)
    --- 获取途径Widget
    ---@type Common_ItemDetails_Access_Item_C
    local AccessItem = ItemWidget:CreateWidgetNew("ItemDetailAccess")
    AccessItem.Parent = ItemWidget
    ---记录当前Item要跳转的途径以及解锁状态，以便后续排序
    AccessItem.Access = AccessKey
    AccessItem.IsUnLock = true
    if string.sub(AccessKey, 1, 5) == "Text_" then
        AccessItem.IsText = true
    end
    return AccessItem
end

--- 创建获取途径Widget
---@param AccessItem Widget @获取途径Widget
---@param AccessText string @获取途径文本
---@param UIName string @当前跳转所依赖SystemUI表对应UIName
---@param UIUnlockRuleId string @解锁规则ID
---@param JumpPageFunc function @跳转页面函数
---@param CustomCheckUnlock function @自定义判断解锁函数(例如用于判断拼接关是否解锁)
---@param CustomCheckUnlockParma table @自定义判断解锁函数参数
---@param bNotCheck boolean @是否使用通用CheckSystemUICanOpen来检查是否能跳转
function PageJumpUtils:ProcessAccessItem(AccessItem, AccessText, UIName, UIUnlockRuleId, JumpPageFunc, CustomCheckUnlock, CustomCheckUnlockParma, bNotCheck)
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    AccessItem.Text_Method:SetText(GText(AccessText))
    AccessItem.Text_Method02:SetText(GText(AccessText))
    AccessItem.Text_Method01:SetText(GText(AccessText))
    if not UIName then
        DebugPrint("ZDX UIName is nil")
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    if not UIUnlockRuleId then
        AccessItem.Switch_Type:SetActiveWidgetIndex(2)
        return
    end
    local bUnlocked = Avatar:CheckUIUnlocked(UIUnlockRuleId)
    -- 如果对应系统未解锁
    if not bUnlocked then
        AccessItem.Text_Method:SetText(GText("UI_Npc_Name_Wenhao"))
        AccessItem.Text_Method02:SetText(GText("UI_Npc_Name_Wenhao"))
        AccessItem.Text_Method01:SetText(GText("UI_Npc_Name_Wenhao"))
        AccessItem.IsText = true
        AccessItem.IsUnLock = true
        AccessItem.Switch_Type:SetActiveWidgetIndex(1)
        return
    end
    -- 如果有跳转函数，则设置AccessItem的跳转函数
    if JumpPageFunc then
        AccessItem.IsInteractive = true
        AccessItem.Switch_Type:SetActiveWidgetIndex(0)
        local bIsCanOpen, FailedIdIndex = Avatar:CheckSystemUICanOpen(UIUnlockRuleId)
        if bIsCanOpen or bNotCheck then
            if not DataMgr.SystemUI[UIName] then
                DebugPrint("传入的UIName未在SystemUI中找到：", UIName)
            elseif DataMgr.SystemUI[UIName].IsBanAccess then
                JumpPageFunc = function()
                    UIManager:ShowUITip("CommonToastMain", GText("UI_COMMONPOP_TITLE_100059"))
                end
            end
        else
            local OpenConditionId = DataMgr.UIUnlockRule[UIUnlockRuleId].OpenConditionId
            local OpenDescs = DataMgr.UIUnlockRule[UIUnlockRuleId].OpenSystemDesc
            local ToastContent
            if #OpenConditionId ==#OpenDescs then
                for _, Value in pairs(FailedIdIndex) do
                    ToastContent = OpenDescs[Value]
                end
            else
                ToastContent = OpenDescs[1]
            end
            --- 显示界面打开失败提示
            JumpPageFunc = function()
                UIManager:ShowUITip("CommonToastMain", ToastContent)
            end
        end
        AccessItem.JumpFunc = JumpPageFunc
    -- 如果是纯文本，则不设置跳转函数
    else
        AccessItem.IsText = true
        AccessItem.IsInteractive = false
        AccessItem.Switch_Type:SetActiveWidgetIndex(2)
    end
    -- 如果需要自定义判断是否解锁，请自行传入
    if CustomCheckUnlock then
        CustomCheckUnlock(AccessItem, UIName)
    end
end

function PageJumpUtils:IsValidAccess(UIUnlockRuleId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local bUnlocked = Avatar:CheckUIUnlocked(UIUnlockRuleId)
    if(not bUnlocked)then
        return false
    end
    local bIsCanOpen, FailedIdIndex = Avatar:CheckSystemUICanOpen(UIUnlockRuleId)
    return bIsCanOpen
end

--- 关闭可能出现的前置窗口
--- 通用弹窗
--- 核桃弹窗
function PageJumpUtils:CloseFrontDialog()
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()

    local CommonDialog = UIManager:GetUI("CommonDialog");
    if CommonDialog then
        if CommonDialog.CloseBtnCallbackFunction then
            local Data = CommonDialog:PackageResult()
            CommonDialog.CloseBtnCallbackFunction(CommonDialog.CloseBtnCallbackObj,Data)
        end
        CommonDialog:Close()
    end
    local WalnutRewardDialog = UIManager:GetUI("WalnutRewardDialog")
    if WalnutRewardDialog then
        WalnutRewardDialog:Close()
    end

    local PurchasePackageDialog = UIManager:GetUI("PayGiftPopup_Yellow") or UIManager:GetUI("PayGiftPopup_Purple")
    if PurchasePackageDialog then
        PurchasePackageDialog:Close()
    end

    local ForgePathDialog = UIManager:GetUI("ForgePathView")
    if ForgePathDialog then
        ForgePathDialog:Close()
    end

    local FeinaRewardPage=UIManager:GetUI("FeinaEventReward")
    if FeinaRewardPage then
        FeinaRewardPage:Close()
    end

    local GuildWarRewardPop = UIManager:GetUI("GuildWarRewardPop")
    if GuildWarRewardPop then
        GuildWarRewardPop:OnReturnKeyDown()
    end

    local WalnutChoiceUI = UIManager:GetUI("WalnutChoice")
    if WalnutChoiceUI then
        if WalnutChoiceUI.CloseByEscape then
            WalnutChoiceUI:CloseByEscape()
        else
            WalnutChoiceUI:Close()
        end
    end
end

--- 对ItemAccess进行排序
--- 排序规则：已解锁可跳转>未解锁可跳转>不可跳转
---@param ItemsContainer Widget @ItemAccess的父级Widget
function PageJumpUtils:SortAccessItem(ItemsContainer)
    local AccessItems = ItemsContainer:GetAllChildren():ToTable()
    for i = 1, #AccessItems do
        AccessItems[i].Index = i
    end
    ItemsContainer:ClearChildren()
    table.sort(AccessItems, function(A, B)
        if A.IsUnLock and B.IsUnLock then
            if A.IsText and B.IsText then
                return A.Index < B.Index
            end
            if A.IsText or B.IsText then
                return not A.IsText
            end
            return A.Index < B.Index
        end
        if A.IsUnLock or B.IsUnLock then
            return not A.IsUnLock
        end
        if A.IsText and B.IsText then
            return A.Index < B.Index
        end
        if A.IsText or B.IsText then
            return not A.IsText
        end
        return A.Index < B.Index
    end)
    for _, Item in pairs(AccessItems) do
        ItemsContainer:AddChild(Item)
    end
end
--- 判断 AccessKey 是否可以跳转（不创建 AccessItem）
---@param ItemId number @物品ID
---@param ItemType string @物品类型
---@param AccessKey string @获取途径Key(对应DataMgr.Access)
---@param UIName string @当前UI名称（可选）
---@return boolean @是否可以跳转
function PageJumpUtils:CanJumpByAccessKey(ItemId, ItemType, AccessKey, UIName)
    local AccessData = DataMgr.Access[AccessKey]
    if not AccessData then
        return false
    end
    
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    
    UIName = UIName or nil
    local ShopType
    local ActualAccessKey = AccessKey
    if string.sub(AccessKey, 1, 5) == "Shop_" and AccessKey ~= "Shop_Pack" then
        ShopType = AccessData.AccessParam
        ActualAccessKey = "Shop"
    elseif string.sub(AccessKey, 1, 14) == "ImpressionShop" then
        ActualAccessKey = "ImpressionShop"
    end
    
    -- InterfaceJump 类型
    if AccessData.AccessRule == "InterfaceJump" then
        local InterfaceJumpId = tonumber(AccessData.AccessParam)
        if InterfaceJumpId and DataMgr.InterfaceJump[InterfaceJumpId] then
            if ConditionUtils.CheckCondition(Avatar, DataMgr.InterfaceJump[InterfaceJumpId].PortalUnlockCondition) then
                local bIsCanOpen, _ = Avatar:CheckSystemUICanOpen(AccessData.UIUnlockRuleId)
                return bIsCanOpen
            end
        end
        return false
    end
    
    -- Shop 类型
    if ActualAccessKey == "Shop" then
        if not ShopType or not DataMgr.ShopItem2ShopSubId[ItemType] or not DataMgr.ShopItem2ShopSubId[ItemType][ShopType] or not DataMgr.ShopItem2ShopSubId[ItemType][ShopType][ItemId] then
            return false
        end
        local ShopDatas = setmetatable({}, {__index = DataMgr.ShopItem2ShopSubId[ItemType][ShopType][ItemId]})
        if not ShopDatas or not next(ShopDatas) then
            return false
        end
        table.sort(ShopDatas, function(a, b)
            return a.AccessOrder or 0 > b.AccessOrder or 0
        end)
        for _, Data in ipairs(ShopDatas) do
            if ShopUtils:GetShopItemCanShow(Data.ShopItemId) and ShopUtils:GetShopItemPurchaseLimit(Data.ShopItemId) ~= 0 then
                local SubTabId = Data.SubTabId
                local MainTabId = DataMgr.ShopTabSub[SubTabId].MainTabId
                local ShopMainTabData = DataMgr.ShopTabMain[MainTabId]
                local SubShopTabData = DataMgr.ShopTabSub[SubTabId]
                if ShopMainTabData.ConditionId then
                    if not Avatar.CheckUIUnlocked(Avatar, ShopMainTabData.ConditionId) then
                        if SubShopTabData.UnlockHide then
                            return false
                        end
                    end
                end
                if SubShopTabData.ConditionId then
                    if not Avatar.CheckUIUnlocked(Avatar, SubShopTabData.ConditionId) then
                        if SubShopTabData.UnlockHide then
                            return false
                        end
                    end
                end
                -- 检查系统解锁
                if AccessData.UIUnlockRuleId then
                    local bUnlocked = Avatar:CheckUIUnlocked(AccessData.UIUnlockRuleId)
                    if not bUnlocked then
                        return false
                    end
                    local bIsCanOpen, _ = Avatar:CheckSystemUICanOpen(AccessData.UIUnlockRuleId)
                    if not bIsCanOpen then
                        return false
                    end
                end
                return true
            end
        end
        return false
    end
    
    -- Walnut 类型
    if ActualAccessKey == "Walnut" then
        local WalnutData = DataMgr["Walnut"][ItemId]
        if not WalnutData then
            return false
        end
        -- Walnut 类型通常可以跳转（跳转到背包或关卡）
        return true
    end
    
    -- Dungeon 类型
    if ActualAccessKey == "Dungeon" then
        local DungeonAccess = DataMgr.Resource2Dungeon[ItemType]
        if not DungeonAccess or not DungeonAccess[ItemId] then
            return false
        end
        -- 检查系统解锁
        if AccessData.UIUnlockRuleId then
            local bUnlocked = Avatar:CheckUIUnlocked(AccessData.UIUnlockRuleId)
            if not bUnlocked then
                return false
            end
        end
        return true
    end
    
    -- MonsterStrong 类型
    if ActualAccessKey == "MonsterStrong" then
        local DungeonAccess = DataMgr.Reward2MonsterDungeon[ItemType]
        if not DungeonAccess or not DungeonAccess[ItemId] then
            return false
        end
        -- 检查系统解锁
        if AccessData.UIUnlockRuleId then
            local bUnlocked = Avatar:CheckUIUnlocked(AccessData.UIUnlockRuleId)
            if not bUnlocked then
                return false
            end
        end
        return true
    end
    
    -- ImpressionShop 类型
    if ActualAccessKey == "ImpressionShop" then
        if not DataMgr.ImpressionShopItem2Shop[ItemId] then
            return false
        end
        local ShopDatas = setmetatable({}, {__index = DataMgr.ImpressionShopItem2Shop[ItemId]})
        if not ShopDatas or next(ShopDatas) then
            return false
        end
        local ImpressionShopItemDatas = DataMgr.ImpressionShop
        for _, ImpressionShopItemId in ipairs(ShopDatas) do
            if ShopUtils:GetImprShopItemPurchaseLimit(ImpressionShopItemId) ~= 0 then
                local ShopData = ImpressionShopItemDatas[ImpressionShopItemId]
                local ImprShopData = DataMgr.ImpressionShopInfo[ShopData.RegionId]
                if ImprShopData.ShopUnlockRuleId then
                    if not ConditionUtils.CheckCondition(Avatar, ImprShopData.ShopUnlockRuleId) then
                        return false
                    end
                end
                -- 检查系统解锁
                if AccessData.UIUnlockRuleId then
                    local bUnlocked = Avatar:CheckUIUnlocked(AccessData.UIUnlockRuleId)
                    if not bUnlocked then
                        return false
                    end
                end
                return true
            end
        end
        return false
    end
    
    -- Shop_Pack 类型
    if AccessKey == "Shop_Pack" then
        if not DataMgr.ShopItem2RewardPack[ItemType] or not DataMgr.ShopItem2RewardPack[ItemType][ItemId] then
            return false
        end
        local ResItemData
        for _, ItemData in ipairs(DataMgr.ShopItem2RewardPack[ItemType][ItemId]) do
            if Avatar:CheckShopItemCanPurchase(ItemData.ShopItemId) then
                if not (ResItemData and ResItemData.TypeId < ItemData.TypeId) then
                    ResItemData = ItemData
                end
            end
        end
        if not ResItemData then
            return false
        end
        return true
    end
    
    -- HardBoss 类型
    if ActualAccessKey == "HardBoss" then
        local bSystemUnlocked = false
        if AccessData.UIUnlockRuleId then
            bSystemUnlocked = Avatar:CheckUIUnlocked(AccessData.UIUnlockRuleId)
        end
        
        local TargetDifficultyID = nil
        local HardBossDifficultyIds = {}
        for _,HardBossData in pairs(DataMgr.HardbossMain) do
            for _,DifficultyId in pairs(HardBossData.DifficultyId) do
                table.insert(HardBossDifficultyIds, DifficultyId)
            end
        end
        local HardBossDifficulty = DataMgr.HardBossDifficulty
        local HardBossDifficultySorted = {}
        for _,DifficultyId in pairs(HardBossDifficultyIds) do
            table.insert(HardBossDifficultySorted, HardBossDifficulty[DifficultyId])
        end
        table.sort(HardBossDifficultySorted, function (a, b)
            return a.DifficultyID < b.DifficultyID
        end)
        for _,HardBossDifficultyData in ipairs(HardBossDifficultySorted) do
            local DynamicRewardId = HardBossDifficultyData.DifficultyReward
            local DynamicRewardInfo = UIUtils.GetDynamicRewardInfo(DynamicRewardId)
            if DynamicRewardInfo then
                local RewardInfo = DataMgr.RewardView[DynamicRewardInfo.RewardView]
                if RewardInfo then
                    local Ids = RewardInfo.Id or {}
                    for i = 1, #Ids do
                        local Id = Ids[i]
                        if ItemId == Id then
                            TargetDifficultyID = HardBossDifficultyData.DifficultyID
                            break
                        end
                    end
                end
            end
            if TargetDifficultyID then
                break
            end
        end
        
        if not TargetDifficultyID then
            return false
        end
        
        local bDifficultyUnlocked = Avatar:CheckHardBossCondition(TargetDifficultyID)
        return bSystemUnlocked and bDifficultyUnlocked
    end
    
    -- Abyss 类型
    if ActualAccessKey == "Abyss" then
        local AbyssSeasonId = Avatar.CurrentAbyssSeasonId
        if not AbyssSeasonId or not DataMgr.AbyssSeasonList[AbyssSeasonId] then
            return false
        end
        local EventId = DataMgr.AbyssSeasonList[AbyssSeasonId].EventId
        if not EventId or not DataMgr.EventPortal[EventId] then
            return false
        end
        local RewardPreviewId = DataMgr.EventPortal[EventId].RewardPreview
        if not RewardPreviewId or not DataMgr.RewardView[RewardPreviewId] then
            return false
        end
        local RewardInfo = DataMgr.RewardView[RewardPreviewId]
        if not RewardInfo then
            return false
        end
        local Ids = RewardInfo.Id or {}
        for i = 1, #Ids do
            local Id = Ids[i]
            if ItemId == Id then
                return true
            end
        end
        return false
    end
    
    -- 其他类型默认返回 false
    return false
end

--- 根据 AccessKey 获取跳转函数并执行（不创建 AccessItem）
---@param ItemId number @物品ID
---@param ItemType string @物品类型
---@param AccessKey string @获取途径Key(对应DataMgr.Access)
---@param UIName string @当前UI名称（可选）
---@return boolean @是否成功执行跳转
function PageJumpUtils:ExecuteJumpByAccessKey(ItemId, ItemType, AccessKey, UIName)
    local AccessData = DataMgr.Access[AccessKey]
    if not AccessData then
        DebugPrint("ExecuteJumpByAccessKey: 找不到AccessData："..AccessKey)
        return false
    end
    
    UIName = UIName or nil
    local ShopType
    local ActualAccessKey = AccessKey
    if string.sub(AccessKey, 1, 5) == "Shop_" and AccessKey ~= "Shop_Pack" then
        ShopType = AccessData.AccessParam
        ActualAccessKey = "Shop"
    elseif string.sub(AccessKey, 1, 14) == "ImpressionShop" then
        ActualAccessKey = "ImpressionShop"
    end
    
    -- InterfaceJump 类型
    if AccessData.AccessRule == "InterfaceJump" then
        local InterfaceJumpId = tonumber(AccessData.AccessParam)
        if InterfaceJumpId and DataMgr.InterfaceJump[InterfaceJumpId] then
            local PlayerAvatar = GWorld:GetAvatar()
            if PlayerAvatar and ConditionUtils.CheckCondition(PlayerAvatar, DataMgr.InterfaceJump[InterfaceJumpId].PortalUnlockCondition) then
                local bIsCanOpen, FailedIdIndex = PlayerAvatar:CheckSystemUICanOpen(AccessData.UIUnlockRuleId)
                if bIsCanOpen then
                    self:JumpToTargetPageByJumpId(InterfaceJumpId)
                    return true
                end
            end
        end
        return false
    end
    
    -- Shop 类型
    if ActualAccessKey == "Shop" then
        local CommonParam = {}
        CommonParam.ItemWidget = nil -- 不需要创建 AccessItem
        CommonParam.AccessKey = ActualAccessKey
        CommonParam.AccessText = GText(AccessData.AccessText)
        CommonParam.UIName = UIName
        CommonParam.UIUnlockRuleId = AccessData.UIUnlockRuleId
        CommonParam.AccessParam = AccessData.AccessParam
        
        local res, JumpToPage = self:CreateJumpToShopAccess(ItemType, ShopType, ItemId, CommonParam)
        if res and JumpToPage then
            JumpToPage()
            return true
        end
        return false
    end
    
    -- Walnut 类型
    if ActualAccessKey == "Walnut" then
        self:CloseFrontDialog()
        local WalnutData = DataMgr["Walnut"][ItemId]
        if WalnutData then
            local Avatar = GWorld:GetAvatar()
            if Avatar then
                local WalnutCount = Avatar.Walnuts.WalnutBag[ItemId] or 0
                if WalnutCount ~= 0 then
                    self:JumpToWalnutDungeonPage(WalnutData.WalnutType, ItemId)
                else
                    self:JumpToWalnutBagPage(WalnutData.WalnutType + 1, ItemId)
                end
                return true
            end
        end
        return false
    end
    
    -- Dungeon 类型
    if ActualAccessKey == "Dungeon" then
        local DungeonAccess = DataMgr.Resource2Dungeon[ItemType]
        if not DungeonAccess or not DungeonAccess[ItemId] then
            return false
        end
        
        local bFromPlay = false
        if UIName == "StyleOfPlay" then
            bFromPlay = true
        end
        
        local DungeonId = self:GetAccessDungeon(DungeonAccess[ItemId])
        if DungeonId then
            self:JumpToDungeonPage(DungeonId, 1, nil, bFromPlay)
            return true
        end
        return false
    end
    
    -- MonsterStrong 类型
    if ActualAccessKey == "MonsterStrong" then
        local DungeonAccess = DataMgr.Reward2MonsterDungeon[ItemType]
        if not DungeonAccess or not DungeonAccess[ItemId] then
            return false
        end
        
        local bFromPlay = false
        if UIName == "StyleOfPlay" then
            bFromPlay = true
        end
        
        local DungeonList = {}
        for _, v in pairs(DungeonAccess[ItemId]) do
            table.insert(DungeonList, v)
        end
        
        if #DungeonList == 0 then
            return false
        end
        
        table.sort(DungeonList, function(a, b)
            return a.DungeonId < b.DungeonId
        end)
        
        -- 选择第一个可解锁的关卡，如果没有则选择第一个
        local TargetDungeon = nil
        local DungeonInfo = DataMgr.Dungeon
        for _, Value in ipairs(DungeonList) do
            local DungeonId = Value.DungeonId
            if DungeonInfo[DungeonId] then
                -- 检查关卡是否解锁
                if self:CheckDungeonCondition(DungeonInfo[DungeonId].Condition) then
                    -- 检查拼接关入口是否解锁
                    local bCanJump = true
                    if DataMgr.Dungeon2Select[DungeonId] then
                        bCanJump = self:CheckDungeonCondition(DataMgr.SelectDungeon[DataMgr.Dungeon2Select[DungeonId]].Condition)
                    elseif DataMgr.Dungeon2SubDungeon[DungeonId] and DataMgr.Dungeon2Select[DataMgr.Dungeon2SubDungeon[DungeonId]] then
                        bCanJump = self:CheckDungeonCondition(DataMgr.SelectDungeon[DataMgr.Dungeon2Select[DataMgr.Dungeon2SubDungeon[DungeonId]]].Condition)
                    end
                    if bCanJump then
                        TargetDungeon = Value
                        break
                    end
                end
            end
        end
        
        -- 如果没有可解锁的，使用第一个
        if not TargetDungeon then
            TargetDungeon = DungeonList[1]
        end
        
        if TargetDungeon then
            self:JumpToDungeonPage(TargetDungeon.DungeonId, 2, TargetDungeon.MonsterId, bFromPlay)
            return true
        end
        return false
    end
    
    -- ImpressionShop 类型
    if ActualAccessKey == "ImpressionShop" then
        local CommonParam = {}
        CommonParam.ItemWidget = nil
        CommonParam.AccessKey = ActualAccessKey
        CommonParam.AccessText = GText(AccessData.AccessText)
        CommonParam.UIName = UIName
        CommonParam.UIUnlockRuleId = AccessData.UIUnlockRuleId
        CommonParam.AccessParam = AccessData.AccessParam
        
        local res, JumpToPage = self:CreateJumpToImpressionShopAccess(ItemId, CommonParam)
        if res and JumpToPage then
            JumpToPage()
            return true
        end
        return false
    end
    
    -- Shop_Pack 类型
    if AccessKey == "Shop_Pack" then
        if not DataMgr.ShopItem2RewardPack[ItemType] or not DataMgr.ShopItem2RewardPack[ItemType][ItemId] then
            return false
        end
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
            return false
        end
        local ResItemData
        for _, ItemData in ipairs(DataMgr.ShopItem2RewardPack[ItemType][ItemId]) do
            if Avatar:CheckShopItemCanPurchase(ItemData.ShopItemId) then
                if not (ResItemData and ResItemData.TypeId < ItemData.TypeId) then
                    ResItemData = ItemData
                end
            end
        end
        if not ResItemData then
            return false
        end
        local res, JumpToPage = self:CreateJumpToShopAccess("Reward", ResItemData.ShopType, ResItemData.TypeId, nil)
        if res and JumpToPage then
            JumpToPage()
            return true
        end
        return false
    end
    
    -- HardBoss 类型
    if ActualAccessKey == "HardBoss" then
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
            return false
        end
        
        local bSystemUnlocked = false
        if AccessData.UIUnlockRuleId then
            bSystemUnlocked = Avatar:CheckUIUnlocked(AccessData.UIUnlockRuleId)
        end
        
        local TargetDifficultyID = nil
        local bDifficultyUnlocked = false
        local HardBossDifficultyIds = {}
        for _,HardBossData in pairs(DataMgr.HardbossMain) do
            for _,DifficultyId in pairs(HardBossData.DifficultyId) do
                table.insert(HardBossDifficultyIds, DifficultyId)
            end
        end
        local HardBossDifficulty = DataMgr.HardBossDifficulty
        local HardBossDifficultySorted = {}
        for _,DifficultyId in pairs(HardBossDifficultyIds) do
            table.insert(HardBossDifficultySorted, HardBossDifficulty[DifficultyId])
        end
        table.sort(HardBossDifficultySorted, function (a, b)
            return a.DifficultyID < b.DifficultyID
        end)
        for _,HardBossDifficultyData in ipairs(HardBossDifficultySorted) do
            if bDifficultyUnlocked then
                break
            end
            local DynamicRewardId = HardBossDifficultyData.DifficultyReward
            local DynamicRewardInfo = UIUtils.GetDynamicRewardInfo(DynamicRewardId)
            if DynamicRewardInfo then
                local RewardInfo = DataMgr.RewardView[DynamicRewardInfo.RewardView]
                if RewardInfo then
                    local Ids = RewardInfo.Id or {}
                    for i = 1, #Ids do
                        local Id = Ids[i]
                        if ItemId == Id then
                            TargetDifficultyID = HardBossDifficultyData.DifficultyID
                            if Avatar:CheckHardBossCondition(HardBossDifficultyData.DifficultyID) then
                                bDifficultyUnlocked = true
                                break
                            end
                        end
                    end
                end
            end
        end
        
        if not TargetDifficultyID then
            return false
        end
        
        local bIsUnLock = bSystemUnlocked and bDifficultyUnlocked
        if not bIsUnLock then
            local UIManager = GWorld.GameInstance:GetGameUIManager()
            UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("Toast_Access_HardBossUnlock"))
            return false
        end
        
        local TargetHardBossId = nil
        for _,HardBossData in pairs(DataMgr.HardbossMain) do
            for _,DifficultyId in pairs(HardBossData.DifficultyId) do
                if DifficultyId == TargetDifficultyID then
                    TargetHardBossId = HardBossData.HardBossId
                    break
                end
            end
            if TargetHardBossId then
                break
            end
        end
        
        if TargetHardBossId then
            self:JumpToStyleOfPlaySubUI("HardBossMain", TargetHardBossId)
            return true
        end
        return false
    end
    
    -- Abyss 类型
    if ActualAccessKey == "Abyss" then
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
            return false
        end
        
        local AbyssSeasonId = Avatar.CurrentAbyssSeasonId
        if not AbyssSeasonId or not DataMgr.AbyssSeasonList[AbyssSeasonId] then
            return false
        end
        
        local EventId = DataMgr.AbyssSeasonList[AbyssSeasonId].EventId
        if not EventId or not DataMgr.EventPortal[EventId] then
            return false
        end
        
        local RewardPreviewId = DataMgr.EventPortal[EventId].RewardPreview
        if not RewardPreviewId or not DataMgr.RewardView[RewardPreviewId] then
            return false
        end
        
        local RewardInfo = DataMgr.RewardView[RewardPreviewId]
        if not RewardInfo then
            return false
        end
        
        local Ids = RewardInfo.Id or {}
        local bShowItem = false
        for i = 1, #Ids do
            local Id = Ids[i]
            if ItemId == Id then
                bShowItem = true
                break
            end
        end
        
        if not bShowItem then
            return false
        end

        return self:JumpToAbyssMainNormal()
    end
    return false
end

--------------------------------------------------获取途径AccessItem跳转接口--------------------------------------------------
--region 委托相关跳转
function PageJumpUtils:CreateJumpToDungeonAccess(CommonParam, ItemType, ItemId, bFromPlay)
    local DungeonAccess
    local DungeonList = {}
    local DeputeType = 1
    if CommonParam.AccessKey == "Dungeon" then
        DungeonAccess = DataMgr.Resource2Dungeon[ItemType][ItemId]
        if not DungeonAccess then
            return
        end
        local DungeonId = self:GetAccessDungeon(DungeonAccess)
        table.insert(DungeonList, DungeonId)
    else
        DeputeType = 2
        DungeonAccess = DataMgr.Reward2MonsterDungeon[ItemType][ItemId]
        if not DungeonAccess then
            return
        end
        for _, v in pairs(DungeonAccess) do
            table.insert(DungeonList, v)
        end

        table.sort(DungeonList, function(a, b)
            return a.DungeonId < b.DungeonId
        end)
    end
    for _, Value in ipairs(DungeonList) do
        local AccessItem = self:CreateAccessItem(CommonParam.ItemWidget, CommonParam.AccessKey)
        local DungeonInfo = DataMgr.Dungeon
        local DungeonId, MonsterId, DungeonAccessText
        if CommonParam.AccessKey == "Dungeon" then
            DungeonId = Value
            assert(DungeonInfo[DungeonId], "找不到DungeonInfo["..DungeonId.."]")
            DungeonAccessText = CommonParam.AccessText..GText(DungeonInfo[DungeonId].DungeonName)
        elseif CommonParam.AccessKey == "MonsterStrong" then
            DungeonId = Value.DungeonId
            MonsterId = Value.MonsterId
            assert(DungeonInfo[DungeonId], "找不到DungeonInfo["..DungeonId.."]")
            DungeonAccessText = GText(DataMgr.Monster[DataMgr.ModDungeonMonReward[MonsterId].MonsterUnitId].UnitName).." Lv."..DataMgr.Dungeon[DungeonId].DungeonLevel
        end
        -- 跳转对应拼接关接口
        local JumpToPage = function()
            self:JumpToDungeonPage(DungeonId, DeputeType, MonsterId, bFromPlay)
        end
        -- 判断拼接关Item是否解锁
        local CustomCheckUnlock = function(AccessItem, UIName)
            if AccessItem.IsInteractive == true then
                --- 如果拼接关入口未解锁 或 拼接关副本未解锁，则设置AccessItem不可交互，并设置跳转函数为CheckCondition弹对应Failed Toast
                --- 判断当前关卡是否解锁
                if self:CheckDungeonCondition(DungeonInfo[DungeonId].Condition) == false or
                --- 如果是普通关卡，通过拼接关Id获取对应拼接关，判断拼接关副本入口是否解锁
                (DataMgr.Dungeon2Select[DungeonId] and self:CheckDungeonCondition(DataMgr.SelectDungeon[DataMgr.Dungeon2Select[DungeonId]].Condition) == false) or
                --- 如果是子级关卡，通过拼接关Id获取父级拼接关Id，判断父级拼接关副本入口是否解锁
                (DataMgr.Dungeon2SubDungeon[DungeonId] and DataMgr.Dungeon2Select[DataMgr.Dungeon2SubDungeon[DungeonId]] and self:CheckDungeonCondition(DataMgr.SelectDungeon[DataMgr.Dungeon2Select[DataMgr.Dungeon2SubDungeon[DungeonId]]].Condition) == false) then
                    AccessItem.IsInteractive = false
                    AccessItem.IsUnLock = true
                    AccessItem.Switch_Type:SetActiveWidgetIndex(1)
                    local CheckDungeon = function()
                        if DataMgr.Dungeon2Select[DungeonId] then
                            if self:CheckDungeonCondition(DungeonInfo[DungeonId].Condition, true) then
                                self:CheckDungeonCondition(DataMgr.SelectDungeon[DataMgr.Dungeon2Select[DungeonId]].Condition, true)
                            end
                        elseif DataMgr.Dungeon2SubDungeon[DungeonId] then
                            if self:CheckDungeonCondition(DungeonInfo[DungeonId].Condition, true) then
                                self:CheckDungeonCondition(DataMgr.SelectDungeon[DataMgr.Dungeon2Select[DataMgr.Dungeon2SubDungeon[DungeonId]]].Condition, true)
                            end
                        end
                    end
                    AccessItem.JumpFunc = CheckDungeon
                    if DataMgr.SystemUI[UIName]then
                        if not DataMgr.SystemUI[UIName].IsBanAccess then
                            AccessItem.JumpFunc = CheckDungeon
                        end
                    end
                end
            end
        end
        self:ProcessAccessItem(AccessItem, DungeonAccessText, CommonParam.UIName, CommonParam.UIUnlockRuleId, JumpToPage, CustomCheckUnlock)
        CommonParam.ItemWidget.Method:AddChild(AccessItem)
    end
end

function PageJumpUtils:CreateJumpToDungeonModAccess(CommonParam, ItemType, ItemId)
    assert(DataMgr.ModSelectDungeon[CommonParam.AccessParam], "Mod委托本配置参数错误, ", CommonParam.AccessKey)
    local AccessItem = self:CreateAccessItem(CommonParam.ItemWidget, CommonParam.AccessKey)
    local DungeonAccessText = GText(CommonParam.AccessText).." Lv."..GText(CommonParam.AccessParam)
    local JumpToPage
    JumpToPage = function()
        self:CloseFrontDialog()
        if CommonParam.UIName == "DeputeDetail" then
            local GameInstance = GWorld.GameInstance
            local UIManager = GameInstance:GetGameUIManager()
        
            local StyleOfPlay = UIManager:GetUIObj("StyleOfPlay")
            if StyleOfPlay.CurTabId == "DungeonSelect" then
                StyleOfPlay.CurSubUI.IsFromJump = false
            end
        end
        self:JumpToStyleOfPlaySubUI("NewDeputeRoot", "NightBook", CommonParam.AccessParam)
    end
    local CustomCheckUnlock = function(AccessItem, UIName)
        if AccessItem.IsInteractive == true then
            if not self:CheckDungeonCondition(DataMgr.ModSelectDungeon[CommonParam.AccessParam].Condition) then
                AccessItem.IsInteractive = false
                AccessItem.IsUnLock = false
                AccessItem.Switch_Type:SetActiveWidgetIndex(1)
                local CheckDungeon = function()
                    PageJumpUtils:CheckDungeonCondition(DataMgr.ModSelectDungeon[CommonParam.AccessParam].Condition, true)
                end
                AccessItem.JumpFunc = CheckDungeon
                if DataMgr.SystemUI[UIName]then
                    if not DataMgr.SystemUI[UIName].IsBanAccess then
                        AccessItem.JumpFunc = CheckDungeon
                    end
                end
            end
        end
    end
    self:ProcessAccessItem(AccessItem, DungeonAccessText, CommonParam.UIName, CommonParam.UIUnlockRuleId, JumpToPage, CustomCheckUnlock)
    CommonParam.ItemWidget.Method:AddChild(AccessItem)
end

---获取拼接关跳转途径
---当前逻辑:
---1.跳转到已解锁的等级最高关卡
---2.如果没有解锁的关卡，则跳转到等级最低关卡
---@param DungeonAccess table @可以获得该物品的拼接关table
function PageJumpUtils:GetAccessDungeon(DungeonAccess)
    local IsDungeonUnlocked = false
    local MaxLevelDungeonId, MinLevelDungeonId
    local MaxLevel, MinLevel = 0, 999
    local DungeonData = DataMgr.Dungeon
    for _, DungeonId in pairs(DungeonAccess) do
        --- 如果当前DungeonId是正常关卡，则判断是否配在了SelectDungeon的DungeonList中
        --- 如果当前DungeonId是子级关卡，则判断其父级关卡是否配在了SelectDungeon的DungeonList中
        if DataMgr.Dungeon2Select[DungeonId] or
        DataMgr.Dungeon2Select[DataMgr.Dungeon2SubDungeon[DungeonId]] then
            if self:CheckDungeonCondition(DungeonData[DungeonId].Condition) and
            (not MaxLevelDungeonId or MaxLevel < DataMgr.Dungeon[DungeonId].DungeonLevel or
            (MaxLevel == DataMgr.Dungeon[DungeonId].DungeonLevel and DungeonId > MaxLevelDungeonId)) then
                IsDungeonUnlocked = true
                MaxLevel = DataMgr.Dungeon[DungeonId].DungeonLevel
                MaxLevelDungeonId = DungeonId
            end
            if not MinLevelDungeonId or MinLevel > DataMgr.Dungeon[DungeonId].DungeonLevel or (MinLevel == DataMgr.Dungeon[DungeonId].DungeonLevel and DungeonId < MinLevelDungeonId) then
                MinLevel = DataMgr.Dungeon[DungeonId].DungeonLevel
                MinLevelDungeonId = DungeonId
            end
        end
    end
    return IsDungeonUnlocked and MaxLevelDungeonId or MinLevelDungeonId
end
---检查拼接关是否解锁
---@param Conditions table @拼接关解锁条件
function PageJumpUtils:CheckDungeonCondition(Conditions, bShowFailed)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    if not Conditions then
        return true
    end
    for _, ConditionId in pairs(Conditions) do
        if ConditionUtils.CheckCondition(Avatar, ConditionId, bShowFailed) == false then
            return false
        end
    end
    return true
end

--region 商城相关跳转
function PageJumpUtils:CreateJumpToShopAccess(ItemType, ShopType, ItemId, CommonParam, ReturnCallBack)
    if not DataMgr.ShopItem2ShopSubId[ItemType][ShopType][ItemId] then
        return
    end
    local ShopDatas = setmetatable({}, {__index = DataMgr.ShopItem2ShopSubId[ItemType][ShopType][ItemId]})
    if not ShopDatas or next(ShopDatas) then
        return
    end
    -- table.sort(ShopDatas, function(a, b)
    --     return a.AccessOrder or 0 > b.AccessOrder or 0
    -- end)
    local ShopData
    for _, Data in ipairs(ShopDatas) do
        if ShopUtils:GetShopItemCanShow(Data.ShopItemId) and ShopUtils:GetShopItemPurchaseLimit(Data.ShopItemId) ~= 0 then
            ShopData = Data
            break
        end
    end
    if not ShopData then
        return false
    end
    -- 商品货架ID
    local ShopItemId =  ShopData.ShopItemId
    local SubTabId = ShopData.SubTabId
    local MainTabId = DataMgr.ShopTabSub[SubTabId].MainTabId
    ReturnCallBack = ReturnCallBack or {}
    -- 跳转对应商城页面接口
    local JumpToPage = function()
        self:CloseFrontDialog()
        self:JumpToShopPage(MainTabId, SubTabId, ShopItemId, ShopType, ReturnCallBack.CallBack, ReturnCallBack.CallBackObj)
    end

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    local RawCustomCheckUnlock = function()
        local Result = {}
        local ShopMainTabData = DataMgr.ShopTabMain[MainTabId]
        local SubShopTabData = DataMgr.ShopTabSub[SubTabId]
        if ShopMainTabData.ConditionId then
            if not Avatar.CheckUIUnlocked(Avatar, ShopMainTabData.ConditionId) then
                if SubShopTabData.UnlockHide then
                    return false
                end
                Result.IsInteractive = false
                Result.IsUnLock = false
                Result.ActiveWidgetIndex = 1
                local CheckShopTab = function()
                    Avatar.CheckUIUnlocked(Avatar, ShopMainTabData.ConditionId, true)
                end
                Result.JumpFunc = CheckShopTab
                Result.bLocked = true
            end
        end

        if not Result.bLocked and SubShopTabData.ConditionId then
            if not Avatar.CheckUIUnlocked(Avatar, SubShopTabData.ConditionId) then
                if SubShopTabData.UnlockHide then
                    return false
                end
                Result.IsInteractive = false
                Result.IsUnLock = false
                Result.ActiveWidgetIndex = 1
                local CheckShopTab = function()
                    Avatar.CheckUIUnlocked(Avatar, SubShopTabData.ConditionId, true)
                end
                Result.JumpFunc = CheckShopTab
                Result.bLocked = true
            end
        end
        return Result
    end

    local CustomCheckUnlock = function(AccessItem, UIName)
        if AccessItem.IsInteractive == true then
            local Result = RawCustomCheckUnlock()
            if(Result.bLocked)then
                AccessItem.IsInteractive = Result.IsInteractive
                AccessItem.IsUnLock = Result.IsUnLock
                AccessItem.Switch_Type:SetActiveWidgetIndex(Result.ActiveWidgetIndex)
                AccessItem.JumpFunc = Result.JumpFunc
            end
        end
    end
    local ShopMainTabData = DataMgr.ShopTabMain[MainTabId]
    local SubShopTabData = DataMgr.ShopTabSub[SubTabId]
    if ShopMainTabData.ConditionId then
        if not Avatar.CheckUIUnlocked(Avatar, ShopMainTabData.ConditionId) then
            if SubShopTabData.UnlockHide then
                return false
            end
        end
    end

    if SubShopTabData.ConditionId then
        if not Avatar.CheckUIUnlocked(Avatar, SubShopTabData.ConditionId) then
            if SubShopTabData.UnlockHide then
                return false
            end
        end
    end
    if CommonParam then
        self:ProcessAccessItem(CommonParam.AccessItem, CommonParam.AccessText, CommonParam.UIName, CommonParam.UIUnlockRuleId,JumpToPage, CustomCheckUnlock)
    end

    return true, (not RawCustomCheckUnlock().bLocked and JumpToPage)
end

--region 印象商店跳转
function PageJumpUtils:CreateJumpToImpressionShopAccess(ItemId, CommonParam)
    if not DataMgr.ImpressionShopItem2Shop[ItemId] then
        return false
    end
    local ShopDatas = setmetatable({}, {__index = DataMgr.ImpressionShopItem2Shop[ItemId]})
    if not ShopDatas or next(ShopDatas) then
        return false
    end
    local PlayerAvatar = GWorld:GetAvatar()
    local ImpressionShopDatas = DataMgr.ImpressionShopInfo
    local ImpressionShopItemDatas = DataMgr.ImpressionShop
    local SortByShopUnlock = function(RegionIdA, RegionIdB)
        local ShopDataA, ShopDataB = ImpressionShopDatas[RegionIdA], ImpressionShopDatas[RegionIdB]
        local ShopAUnlocked = ConditionUtils.CheckCondition(PlayerAvatar, ShopDataA.ShopUnlockRuleId)
        local ShopBUnlocked = ConditionUtils.CheckCondition(PlayerAvatar, ShopDataB.ShopUnlockRuleId)
        return (ShopAUnlocked) and (not ShopBUnlocked)
    end
    local SortByFloatField = function(ItemA, ItemB, Field)
        if ItemA[Field] == nil then
            return false
        end
        return ItemA[Field] < ItemB[Field]
    end
    table.sort(ShopDatas, function(A, B)
        local a, b = ImpressionShopItemDatas[A], ImpressionShopItemDatas[B]
        if SortByShopUnlock(a.RegionId, b.RegionId) then
            return true
        elseif SortByShopUnlock(b.RegionId, a.RegionId) then
            return false
        elseif SortByFloatField(a, b, "RegionId") then
            return true
        elseif SortByFloatField(b, a, "RegionId") then
            return false
        else
            return SortByFloatField(a, b, "ImpressionShopId")
        end
    end)
    local ShopItemId
    for _, ImpressionShopItemId in ipairs(ShopDatas) do
        if ShopUtils:GetImprShopItemPurchaseLimit(ImpressionShopItemId) ~= 0 then
            ShopItemId = ImpressionShopItemId
            break
        end
    end
    if not ShopItemId then
        return false
    end
    -- 商品货架ID
    local ShopData = ImpressionShopItemDatas[ShopItemId]
    local SubTabId = ShopData.SubTabId
    local MainTabId = DataMgr.ImpressionShopSubTab[SubTabId].MainTabId
    -- 跳转对应商城页面接口
    local JumpToPage = function()
        self:CloseFrontDialog()
        self:JumpToImprShop(MainTabId, SubTabId, ShopItemId)
    end

    local AccessItem = CommonParam.AccessItem
    AccessItem.IsUnLock = true
    AccessItem.IsInteractive = true
    AccessItem.Switch_Type:SetActiveWidgetIndex(0)
    AccessItem.JumpFunc = JumpToPage

    local ImprShopData = ImpressionShopDatas[ShopData.RegionId]
    if ImprShopData.ShopUnlockRuleId then
        if not ConditionUtils.CheckCondition(PlayerAvatar, ImprShopData.ShopUnlockRuleId) then
            AccessItem.Switch_Type:SetActiveWidgetIndex(1)
            local CheckShopTab = function()
                UIManager(GWorld.GameInstance):ShowUITip("CommonToastMain", GText("UI_LockTips_ImpShopAccess"))
            end
            AccessItem.JumpFunc = CheckShopTab
        end
    end

    local AccessText = ImprShopData.ShopName or CommonParam.AccessText
    AccessItem.Text_Method:SetText(GText(AccessText))
    AccessItem.Text_Method02:SetText(GText(AccessText))
    AccessItem.Text_Method01:SetText(GText(AccessText))

    return true, JumpToPage
end

--region 据点相关跳转
function PageJumpUtils:CreateJumpToHome(AccessItem)
    local JumpToPage = function()
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
            return
        end
        local GameInstance = GWorld.GameInstance
        local UIManager = GameInstance:GetGameUIManager()
        if Avatar:CheckSubRegionType(nil, CommonConst.SubRegionType.Home) then
            UIManager:ShowUITip("CommonToastMain", GText("UI_TOAST_FORGING_WARNING"))
        end

        self:CloseFrontDialog()
        UIManager:ShowCommonPopupUI(100037, { 
            RightCallbackObj = self,
            RightCallbackFunction = function(Obj, PackageData)
                local GameMode = UE.UGameplayStatics.GetGameMode(AccessItem)
                GameMode:HandleLevelDeliver(1, 210101, 1)
            end,
            ForbiddenRightCallbackObj = self}, 
        AccessItem)
    end
    return true, JumpToPage
end

--region 委托背包跳转
function PageJumpUtils:CreateJumpToWalnutBag(CommonParam, ItemType, ItemId)
    local WalnutAccess = DataMgr.Item2WalnutIdMap[ItemType][ItemId]
    if not WalnutAccess then
        DebugPrint("ZDX: ItemId:"..ItemId.." not found in Item2WalnutIdMap Config")
        return
    end
    local WalnutList = {}
    for _, v in pairs(WalnutAccess) do
        table.insert(WalnutList, v)
    end

    table.sort(WalnutList, function(a, b)
        return a < b
    end)
    local Avatar = GWorld:GetAvatar()
    if Avatar == nil then
        return
    end
    for _, Value in ipairs(WalnutList) do
        local AccessItem = self:CreateAccessItem(CommonParam.ItemWidget, CommonParam.AccessKey)
        local WalnutConfigData = DataMgr.Walnut[Value]
        local WalnutCount = 0
        if Avatar.Walnuts.WalnutBag[Value] then
            WalnutCount = Avatar.Walnuts.WalnutBag[Value]
        end
        local WalnutAccessText = string.format("%s %s%d", GText(WalnutConfigData.Name),  GText("UI_Bag_Sellconfirm_Hold"),WalnutCount)

        local JumpToPage = function()
            self:CloseFrontDialog()
            self:JumpToWalnutBagPage(WalnutConfigData.WalnutType + 1, WalnutConfigData.WalnutId)
        end

        if WalnutCount ~= 0 then
            JumpToPage = function()
                self:CloseFrontDialog()
                self:JumpToWalnutDungeonPage(WalnutConfigData.WalnutType, Value)
            end
        end
        self:ProcessAccessItem(AccessItem, WalnutAccessText, CommonParam.UIName, CommonParam.UIUnlockRuleId, JumpToPage)
        CommonParam.ItemWidget.Method:AddChild(AccessItem)
    end
end

--region 铸造跳转
function PageJumpUtils:CreateJumpToForge(AccessItem, ItemType, ItemId, AccessText)
    if not (DataMgr.Item2DraftIdMap[ItemType] and DataMgr.Item2DraftIdMap[ItemType][ItemId] and DataMgr.Item2DraftIdMap[ItemType][ItemId].DraftIds) then 
        return false
    end
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    local DraftId = DataMgr.Item2DraftIdMap[ItemType][ItemId].DraftIds[1]
    local JumpToPage = function()
        local PlayerAvatar = GWorld:GetAvatar()
        local AvatarDrafts = PlayerAvatar.Drafts
        if not (AvatarDrafts and AvatarDrafts[DraftId]) then
            -- 暂未获得该材料的铸造设计稿
            -- UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("Forge_InterfaceJump_Locked"))
            -- return
            self:JumpToForgeCompendiumPathByDraftId(DraftId)
            return
        end
        self:CloseFrontDialog()

        -- 如果是跳转到铸造，把图鉴关掉
        local CompendiumPage = UIManager:GetUI("ForgeCompenduim")
        if CompendiumPage then 
            CompendiumPage:Close()
        end
        
        self:JumpToForgePageByDraftId(DraftId)
        -- end

        -- 如果跳转到铸造，把重铸界面关掉
        local ConvertPage = UIManager:GetUI("ForgeConvertMain")
        if ConvertPage then 
            ConvertPage:Close()
        end
        -- end
    end

    local ForgeDataModel = require "Blueprints.UI.Forge.ForgeDataModel"
    if ForgeDataModel then
        local MaxProduceNum = ForgeDataModel:GetMaxProduceNumByDraftId(DraftId)
        if MaxProduceNum then
            AccessText = string.format(GText("MAIN_UI_FORGE02"), MaxProduceNum)
        end
    end
    return true, JumpToPage, AccessText
end

--region 梦魇残声跳转
function PageJumpUtils:CreateJumpToHardBoss(ItemId, CommonParam)
    local TargetDifficultyID = nil
    local bSystemUnlocked = false
    local bDifficultyUnlocked = false
    local bShowItem = false

    local Avatar = GWorld:GetAvatar()
    if Avatar then
        if CommonParam and CommonParam.UIUnlockRuleId then
            bSystemUnlocked = Avatar:CheckUIUnlocked(CommonParam.UIUnlockRuleId)
        end
        local HardBossDifficultyIds = {}
        for _,HardBossData in pairs(DataMgr.HardbossMain) do
            for _,DifficultyId in pairs(HardBossData.DifficultyId) do
                table.insert(HardBossDifficultyIds, DifficultyId)
            end
        end
        local HardBossDifficulty = DataMgr.HardBossDifficulty
        local HardBossDifficultySorted = {}
        for _,DifficultyId in pairs(HardBossDifficultyIds) do
            table.insert(HardBossDifficultySorted, HardBossDifficulty[DifficultyId])
        end
        table.sort(HardBossDifficultySorted, function (a, b)
            return a.DifficultyID < b.DifficultyID
        end)
        for _,HardBossDifficultyData in ipairs(HardBossDifficultySorted) do
            if bDifficultyUnlocked then
                break
            end
            local DynamicRewardId = HardBossDifficultyData.DifficultyReward
            local DynamicRewardInfo = UIUtils.GetDynamicRewardInfo(DynamicRewardId)
            if DynamicRewardInfo then
                local RewardInfo = DataMgr.RewardView[DynamicRewardInfo.RewardView]
                if RewardInfo then
                    local Ids = RewardInfo.Id or {}
                    for i = 1, #Ids do
                        local Id = Ids[i]
                        if ItemId == Id then
                            TargetDifficultyID = HardBossDifficultyData.DifficultyID
                            if Avatar:CheckHardBossCondition(HardBossDifficultyData.DifficultyID) then
                                bDifficultyUnlocked = true
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    if TargetDifficultyID then
        bShowItem = true
    else
        bShowItem = false
    end
    if not bShowItem then
        return false
    end

    local JumpToPage = function()
        local bIsUnLock = bSystemUnlocked and bDifficultyUnlocked
        if not bIsUnLock then
            local UIManager = GWorld.GameInstance:GetGameUIManager()
            UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("Toast_Access_HardBossUnlock"))
            return
        end
        local TargetHardBossId = nil
        if TargetDifficultyID then
            for _,HardBossData in pairs(DataMgr.HardbossMain) do
                for _,DifficultyId in pairs(HardBossData.DifficultyId) do
                    if DifficultyId == TargetDifficultyID then
                        TargetHardBossId = HardBossData.HardBossId
                    end
                end
            end
        end
        if TargetHardBossId then
            self:JumpToStyleOfPlaySubUI("HardBossMain", TargetHardBossId)
        end
    end
    local CustomCheckUnlock = function(AccessItem, UIName)
        AccessItem.IsUnLock = bSystemUnlocked and bDifficultyUnlocked
        if AccessItem.IsUnLock then
            AccessItem.IsInteractive = true
            AccessItem.Switch_Type:SetActiveWidgetIndex(0)
        else
            AccessItem.IsInteractive = false
            AccessItem.Switch_Type:SetActiveWidgetIndex(1)
        end
    end

    if CommonParam and CommonParam.AccessItem then
        self:ProcessAccessItem(CommonParam.AccessItem, CommonParam.AccessText, CommonParam.UIName, CommonParam.UIUnlockRuleId, JumpToPage, CustomCheckUnlock)
    end

    return true,JumpToPage
end

--region 大秘境跳转
function PageJumpUtils:CreateJumpToAbyss(ItemId, CommonParam)
    local bShowItem = false
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local AbyssSeasonId = Avatar.CurrentAbyssSeasonId
        if AbyssSeasonId and DataMgr.AbyssSeasonList[AbyssSeasonId] then
            local EventId = DataMgr.AbyssSeasonList[AbyssSeasonId].EventId
            if EventId and DataMgr.EventPortal[EventId] then
                local RewardPreviewId = DataMgr.EventPortal[EventId].RewardPreview
                if RewardPreviewId and DataMgr.RewardView[RewardPreviewId] then
                    local RewardInfo = DataMgr.RewardView[RewardPreviewId]
                    if RewardInfo then
                        local Ids = RewardInfo.Id or {}
                        for i = 1, #Ids do
                            local Id = Ids[i]
                            if ItemId == Id then
                                bShowItem = true
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    if not bShowItem then
        return false
    end

    local JumpToPage = function()
        -- if CommonParam and CommonParam.UIUnlockRuleId and Avatar then
        --     local bSystemUnlocked = Avatar:CheckUIUnlocked(CommonParam.UIUnlockRuleId)
        --     if not bSystemUnlocked then
        --         local UIManager = GWorld.GameInstance:GetGameUIManager()
        --         UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("UI_Locked_Des_Abyss"))
        --         return
        --     end
        -- end

        self:JumpToAbyssMainNormal()
    end

    if CommonParam then
        self:ProcessAccessItem(CommonParam.AccessItem, CommonParam.AccessText, CommonParam.UIName, CommonParam.UIUnlockRuleId, JumpToPage)
    end

    return true,JumpToPage
end

--------------------------------------------------------- 以上为创建跳转途径AccessItem相关逻辑---------------------------------------------------------


--------------------------------------------------------- 以下为各种系统跳转的接口---------------------------------------------------------

--region 第二部分 跳转方法
---请添加注释方便复用

-- 跳转到指定拼接关
---@param DungeonId number @拼接关Id
---@param DeputeType number @拼接关类型
---@param MonsterId number @怪物Id（对应DeputeType == 2）
function PageJumpUtils:JumpToDungeonPage(DungeonId, DeputeType, MonsterId, bFromPlay)
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()

    DungeonId = tonumber(DungeonId)
    DeputeType = tonumber(DeputeType)
    self:CloseFrontDialog()
    
    GameFlowUtils:AddFlow("OpenSystemUI", {
        GWorld.GameInstance, function(_, Flow)
            --- 首先创建玩法主页面
            ---@type WBP_StyleOfPlay_Entry_C
            local StyleOfPlay = UIManager:GetUIObj("StyleOfPlay")
            if (not StyleOfPlay) then
                StyleOfPlay = UIManager:LoadUINew("StyleOfPlay")
                UIManager:AddToJumpPageDeque(StyleOfPlay)
                UIManager:AddFlow("StyleOfPlay", Flow)
            else
                UIManager:PlaceJumpUIToTop(StyleOfPlay, "StyleOfPlay")
                GameFlowUtils:RemoveFlow(Flow)
            end
            StyleOfPlay.IsOpenSelectLevel = false

            --- 打开委托子页面
            local SelectLevel = StyleOfPlay:OpenSubUI("DungeonSelect")
            local Dungeon2Select = DataMgr.Dungeon2Select

            -- 如果当前所处关卡与跳转关卡相同，则直接返回
            if SelectLevel.CurSelectedDungeonId == DungeonId then
                return
            end

            -- 设置要跳转的拼接关id
            --- 如果是正常关卡，Dungeon2Select[DungeonId]
            --- 如果是子级关卡，Dungeon2Select[Dungeon2SubDungeon[DungeonId]]
            local ChapterId = Dungeon2Select[DungeonId] or (DataMgr.Dungeon2SubDungeon[DungeonId] and Dungeon2Select[DataMgr.Dungeon2SubDungeon[DungeonId]])

            SelectLevel.PlayEntry = StyleOfPlay
            --- 标记当前拼接关是否是从跳转进入
            if not bFromPlay then
                SelectLevel.IsFromJump = true
            end
            local DungeonList, DungeonTabName
            --- 根据不同委托类型传入对应参数
            if DeputeType == Const.DeputeType.NightFlightManualDepute then
                DungeonList = DataMgr.ModDungeonMonReward[MonsterId].DungeonList
                DungeonTabName = DataMgr.PlaySubTab["DeputeNightBook"].SubTabName
                SelectLevel:SetNightFlightManualRewardView(DataMgr.ModDungeonMonReward[MonsterId].DungeonRewardView)
            else
                DungeonList = DataMgr.SelectDungeon[ChapterId].DungeonList
                DungeonTabName = DataMgr.PlaySubTab["NewDeputeRoot"].SubTabName
            end
            --- 加载委托关卡子页面
            SelectLevel:InitLevelList(DungeonList,DungeonId,DeputeType)
            --- 初始化关卡子页面Tab栏
            StyleOfPlay:InitOtherPageTab({
                DynamicNode = {"Back", "ResourceBar", "BottomKey"},
                BottomKeyInfo = {
                    {
                        GamePadInfoList = {
                            { Type = "Add" },
                            GamePadSubKeyInfoList = {
                                { Type = "Img", ImgShortPath = "Up", Owner = SelectLevel },
                                { Type = "Img", ImgShortPath = "Y", Owner = SelectLevel }
                            }
                        },
                        Desc = GText("UI_CTL_DeputeInfo"),
                        bLongPress = false,
                    },
                    {
                        KeyInfoList = { { Type = "Text", Text = "Esc", ClickCallback = SelectLevel.OnReturnKeyDown, Owner = SelectLevel } },
                        GamePadInfoList = { { Type = "Img", ImgShortPath = "B", Owner = SelectLevel } },
                        Desc = GText("UI_BACK")
                    }
                },
                OwnerPanel = SelectLevel,
                BackCallback = SelectLevel.OnReturnKeyDown,
                StyleName = "Text",
                TitleName= GText(DungeonTabName),
                InfoCallback = SelectLevel.ShowIntro
            }, nil, true)
        end
    })
end

--跳转到核桃拼接关
function PageJumpUtils:JumpToWalnutDungeonPage(WalnutType, WalnutId)
    local PlayerAvatar = GWorld:GetAvatar()
    if PlayerAvatar == nil then
        return
    end

    local DungeonIds = nil
    self.ValidWalnutDungeons = PlayerAvatar.Walnuts.ValidWalnutDungeons

    for Type, Ids in pairs(self.ValidWalnutDungeons) do
        if Type == WalnutType then
            DungeonIds = Ids
            break
        end
    end

    if not DungeonIds then return end
    table.sort(DungeonIds, function(a, b)
        local DataA = DataMgr.Dungeon[a]
        local DataB = DataMgr.Dungeon[b]

        if not DataA or not DataB then
            return false
        end

        return DataA.DungeonLevel < DataB.DungeonLevel
    end)
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    ---@type WBP_StyleOfPlay_Entry_C
    local StyleOfPlay = UIManager:GetUIObj("StyleOfPlay")
    if (not StyleOfPlay) then
        StyleOfPlay = UIManager:LoadUINew("StyleOfPlay")
        UIManager:AddToJumpPageDeque(StyleOfPlay)
    else
        UIManager:PlaceJumpUIToTop(StyleOfPlay, "StyleOfPlay")
    end
    if (not StyleOfPlay) then
        DebugPrint("ShiLei: JumpToWalnutDungeonPage Failed to load StyleOfPlay UI")
        return
    end
    StyleOfPlay.IsOpenSelectLevel = false

    --- 打开委托子页面
    local SelectLevel = StyleOfPlay:OpenSubUI("DungeonSelect")
    SelectLevel.PlayEntry = StyleOfPlay

    local WalnutTypeData = DataMgr.WalnutType[WalnutType]
    local Data = DataMgr.Dungeon[DungeonIds[1]]
    SelectLevel:SetWalnutType(WalnutTypeData)
    SelectLevel:SetWalnutTitleMatColor(WalnutType)
    SelectLevel:InitLevelList(DungeonIds, Data.DungeonID, Const.DeputeType.WalnutDepute,WalnutId)

    StyleOfPlay:InitOtherPageTab({
        DynamicNode = { "Back", "ResourceBar", "BottomKey" },
        BottomKeyInfo = {
            {
                GamePadInfoList = {
                    { Type = "Add" },
                    GamePadSubKeyInfoList = {
                        { Type = "Img", ImgShortPath = "Up", Owner = SelectLevel },
                        { Type = "Img", ImgShortPath = "Y", Owner = SelectLevel }
                    }
                },
                Desc = GText("UI_CTL_DeputeInfo"),
                bLongPress = false,
            },
            {
                KeyInfoList = { { Type = "Text", Text = "Esc", ClickCallback = SelectLevel.OnReturnKeyDown, Owner = SelectLevel } },
                GamePadInfoList = { { Type = "Img", ImgShortPath = "B", Owner = SelectLevel } },
                Desc = GText("UI_BACK")
            }
        },
        OwnerPanel = SelectLevel,
        BackCallback = SelectLevel.OnReturnKeyDown,
        StyleName = "Text",
        TitleName = GText("UI_Dungeon_Tab_WalnutDungeon"),
        -- PopupInfoId = 100124,
        -- InfoCallback = SelectLevel.ShowIntro
    }, nil, true)
end

-- 跳转到肉鸽主界面
function PageJumpUtils:JumpToRougeMain(JumpType)
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()

    self:CloseFrontDialog()

    if not JumpType then
        JumpType = "NormalJump"
    end

    local StyleOfPlay = UIManager:GetUIObj("StyleOfPlay")
    if (not StyleOfPlay) then
        StyleOfPlay = UIManager:LoadUINew("StyleOfPlay", "RougeMain")
        if JumpType == "NormalJump" then
            UIManager:AddToJumpPageDeque(StyleOfPlay)
        end
    else
        UIManager:PlaceJumpUIToTop(StyleOfPlay, "StyleOfPlay")
        StyleOfPlay:OpenSubUI("RougeMain")
    end
    StyleOfPlay.IsOpenSelectLevel = false

    local WidgetUI = StyleOfPlay:GetCurSubUI()
    if WidgetUI then
        if WidgetUI.InDifficultySelect then
            WidgetUI:BackToRougeMain()
            WidgetUI:SetJumpType(JumpType)
        else
            WidgetUI:InitTable(JumpType)
        end
    end
end

function PageJumpUtils:JumpToAbyssLevelInfoPage(AbyssId, AbyssLevelId, AbyssDungeonIndex)
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    local AbyssMain = UIManager:LoadUINew("AbyssMain", AbyssId, true)
    UIManager:AddToJumpPageDeque(AbyssMain)
    AbyssMain:OpenSubUI({Idx = "AbyssSelect"}, false, AbyssId, AbyssLevelId, AbyssDungeonIndex)
end

function PageJumpUtils:JumpToTryOut(CurTabIndex, ActivityId, CurSelectIndex)
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()

    GameFlowUtils:AddFlow("OpenSystemUI", {
        GWorld.GameInstance, function(_, Flow)
            local ActivityMain = UIManager:LoadUINew("ActivityMain", nil, CurTabIndex, ActivityId, CurSelectIndex)
            UIManager:AddToJumpPageDeque(ActivityMain)
            UIManager:AddFlow("ActivityMain", Flow)
        end
    })
end

function PageJumpUtils:JumpToPaotai(CurTabIndex, CurSelectIndex)
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    
    GameFlowUtils:AddFlow("OpenSystemUI", {
        GWorld.GameInstance, function(_, Flow)
            local ActivityMain = UIManager:LoadUINew("ActivityMain", nil, CurTabIndex)
            UIManager:AddToJumpPageDeque(ActivityMain)
            local ActivityId = DataMgr.PaotaiEventConstant["PaotaiGameEventId"].ConstantValue
            local PageConfigData = DataMgr.EventPortal[ActivityId]
            if PageConfigData.JumpUIId then
                PageJumpUtils:JumpToTargetPageByJumpId(PageConfigData.JumpUIId, CurSelectIndex)
            end
            UIManager:AddFlow("ActivityMain", Flow)
        end
    })
end

function PageJumpUtils:JumpToFeinaEvent(CurTabIndex)
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()

    GameFlowUtils:AddFlow("OpenSystemUI", {
        GWorld.GameInstance, function(_, Flow)
            local ActivityMain = UIManager:LoadUINew("ActivityMain", nil, CurTabIndex)
            UIManager:AddToJumpPageDeque(ActivityMain)
            local ActivityId = DataMgr.EventConstant["FeinaEventId"].ConstantValue
            local PageConfigData = DataMgr.EventPortal[ActivityId]
            if PageConfigData.JumpUIId then
                PageJumpUtils:JumpToTargetPageByJumpId(PageConfigData.JumpUIId)
            end
            UIManager:AddFlow("ActivityMain", Flow)
        end
    })
end

function PageJumpUtils:JumpToTempleSolo(CurTabIndex)
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()

    GameFlowUtils:AddFlow("OpenSystemUI", {
        GWorld.GameInstance, function(_, Flow)
            local ActivityMain = UIManager:LoadUINew("ActivityMain", nil, CurTabIndex)
            UIManager:AddToJumpPageDeque(ActivityMain)
            local ActivityId = 108001
            local PageConfigData = DataMgr.EventPortal[ActivityId]
            if PageConfigData.JumpUIId then
                PageJumpUtils:JumpToTargetPageByJumpId(PageConfigData.JumpUIId)
            end
            UIManager:AddFlow("ActivityMain", Flow)
        end
    })
end

function PageJumpUtils:JumpToMonsterRush(CurTabIndex, EventId, DungeonId)
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()

    GameFlowUtils:AddFlow("OpenSystemUI", {
        GWorld.GameInstance, function(_, Flow)
            local ActivityMain = UIManager:LoadUINew("ActivityMain", nil, CurTabIndex)
            UIManager:AddToJumpPageDeque(ActivityMain)
            local PageConfigData = DataMgr.EventPortal[EventId]
            local IsOpen = ActivityUtils.CheckEventIsOpen(EventId,nil,false)
            if PageConfigData.JumpUIId and IsOpen then
                PageJumpUtils:JumpToTargetPageByJumpId(PageConfigData.JumpUIId, DungeonId)
            end
            UIManager:AddFlow("ActivityMain", Flow)
        end
    })
end

function PageJumpUtils:JumpToEventPage(CurTabIndex)
    local TabIndex = tonumber(CurTabIndex)
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    if not ActivityUtils.IsTabIdValid(TabIndex) then
        -- 弹出错误码36005提示活动未开启
        UIManager:ShowError(36005, 1.5, UIConst.Tip_CommonToast)
        return
    end

    GameFlowUtils:AddFlow("OpenSystemUI", {
        GWorld.GameInstance, function(_, Flow)
            local ActivityMain = UIManager:GetUIObj("ActivityMain")
            if (not ActivityMain) then
                ActivityMain = UIManager:LoadUINew("ActivityMain", nil, TabIndex)
                UIManager:AddToJumpPageDeque(ActivityMain)
            else
                -- 已经存在的界面
                UIManager:PlaceJumpUIToTop(ActivityMain, "ActivityMain")
                ActivityMain:JumpToTargetTab(TabIndex)
            end
        end
    })
end

---跳转到指定商店页面
---@param MainTabIdx number @商城主页面index
---@param SubTabIdx number @商城子页面index
---@param ShopItemId number @商城商品Id
---@param ShopType string @商城类型
function PageJumpUtils:JumpToShopPage(MainTabIdx, SubTabIdx, ShopItemId, ShopType, Callback, CallbackObj)
    assert(DataMgr.Shop[ShopType], "未找到对应类型的商店，", ShopType)
    local UIName = DataMgr.Shop[ShopType].ShopUIName
    if not UIName then
        DebugPrint("ZDX_未找到对应跳转商店的UIName", ShopType)
        return
    end
    MainTabIdx = tonumber(MainTabIdx)
    SubTabIdx = tonumber(SubTabIdx)
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()

        local ShopMainPage = UIManager:GetUIObj(UIName)
        if (not ShopMainPage) then
            ShopMainPage = UIManager:LoadUINew(UIName, MainTabIdx, SubTabIdx, ShopItemId, ShopType, Callback, CallbackObj)
            UIManager:AddToJumpPageDeque(ShopMainPage)
            -- 先在商城临时修一下动画穿帮问题
            if (ShopMainPage and ShopMainPage.In and ShopMainPage:IsAnimationPlaying(ShopMainPage.In)) then
                ShopMainPage:SetAnimationCurrentTime(ShopMainPage.In, ShopMainPage.In:GetEndTime() - 0.01)
                ShopMainPage:PlayAnimation(ShopMainPage.In)
            end        
        else
            -- 已经存在的界面
            UIManager:PlaceJumpUIToTop(ShopMainPage, UIName)
            ShopMainPage:InitShop(MainTabIdx, SubTabIdx, ShopItemId, ShopType, Callback, CallbackObj)
        end
end

---跳转到印象商店页面(Access用)
---@param MainTabIdx number @商城主页面index
---@param SubTabIdx number @商城子页面index
---@param ShopItemId number @商城商品Id
function PageJumpUtils:JumpToImprShop(MainTabIdx, SubTabIdx, ShopItemId)
    MainTabIdx = tonumber(MainTabIdx)
    SubTabIdx = tonumber(SubTabIdx)
    local UIManager = UIManager(GWorld.GameInstance)
    local ShopMainPage = UIManager:GetUIObj("ImpressionShop")
    if (not ShopMainPage) then
        ShopMainPage = UIManager:LoadUINew("ImpressionShop", MainTabIdx, SubTabIdx, ShopItemId)
        UIManager:AddToJumpPageDeque(ShopMainPage)
    else
        -- 已经存在的界面
        UIManager:PlaceJumpUIToTop(ShopMainPage, "ImpressionShop")
        ShopMainPage:InitImpressionShop(MainTabIdx, SubTabIdx, ShopItemId, true)
    end
end

-- 跳转到核桃包裹主界面
function PageJumpUtils:JumpToWalnutBagPage(ItemType, ItemId)
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    local WalnutBagMain = UIManager:GetUIObj("WalnutBagMain")
    if (ItemType == nil) then
        local WalnutConfigData = DataMgr.Walnut[ItemId]
        ItemType = WalnutConfigData.WalnutType
    end
    if (not WalnutBagMain) then
        WalnutBagMain = UIManager:LoadUINew("WalnutBagMain", ItemType, ItemId)
        UIManager:AddToJumpPageDeque(WalnutBagMain)
    else
        UIManager:PlaceJumpUIToTop(WalnutBagMain, "WalnutBagMain")
        WalnutBagMain:InitJumpParams(ItemType, ItemId)
    end
end

function PageJumpUtils:JumpToForgeCompendiumPathByDraftId(DraftId)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local UIUnlockRule = DataMgr.UIUnlockRule
        local UIUnlockRuleId = UIUnlockRule.Forging.UIUnlockRuleId
        local bUnlocked = Avatar:CheckUIUnlocked(UIUnlockRuleId)
        local bIsCanOpen, _ = Avatar:CheckSystemUICanOpen(UIUnlockRuleId)
        if not bUnlocked then
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(DataMgr.UIUnlockRule.Forging.UIUnlockDesc))
            return
        elseif not bIsCanOpen then
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(DataMgr.UIUnlockRule.Forging.OpenSystemDesc[1]))
            return
        end
    end
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    local ForgeMain = UIManager:GetUIObj("ForgeMain")
    if IsValid(ForgeMain) then
        UIManager:PlaceJumpUIToTop(ForgeMain, "ForgeMain")
    else
        ForgeMain = UIManager:LoadUINew("ForgeMain", {NotDelayAddListItem = true})
        UIManager:AddToJumpPageDeque(ForgeMain)
    end
    local ForgeCompenduimPage = UIManager:GetUIObj("ForgeCompenduim")
    if IsValid(ForgeCompenduimPage) then
        ForgeCompenduimPage:NavigateToTargetDraft(DraftId)
        UIManager:PlaceJumpUIToTop(ForgeCompenduimPage, "ForgeCompenduim")
    else
        ForgeCompenduimPage = UIManager:LoadUINew("ForgeCompenduim", "All")
        UIManager:AddToJumpPageDeque(ForgeCompenduimPage)
        ForgeCompenduimPage:NavigateToTargetDraft(DraftId)
    end
    -- 把重铸界面关掉，防止层级太多
    local ConvertPage = UIManager:GetUI("ForgeConvertMain")
    if ConvertPage then 
        ConvertPage:Close()
    end
end

-- 跳转到铸造界面指定设计稿
function PageJumpUtils:JumpToForgePageByDraftId(DraftId)
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    local PlayerAvatar = GWorld:GetAvatar()
    local AvatarDrafts = PlayerAvatar.Drafts
    if not (AvatarDrafts and AvatarDrafts[DraftId]) then
        -- 暂未获得该材料的铸造设计稿
        UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("Forge_InterfaceJump_Locked"))
        return
    end

    local ForgePage = UIManager:GetUIObj("ForgeMain")
    if ForgePage then 
        ForgePage:NavigateToTargetDraft(DraftId)
        UIManager:PlaceJumpUIToTop(ForgePage, "ForgeMain")
    else 
        -- 处理铸造界面没有打开的清空
        ForgePage = UIManager:LoadUINew("ForgeMain", {NotDelayAddListItem = true})
        UIManager:AddToJumpPageDeque(ForgePage)
        ForgePage:NavigateToTargetDraft(DraftId)
    end
end

-- 跳转到钓鱼图鉴
function PageJumpUtils:JumpToAnglingMap(Param)
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    local AnglingMap = UIManager:GetUIObj("AnglingMap")
    if AnglingMap then

    else
        AnglingMap = UIManager:LoadUINew("AnglingMap", Param)
        UIManager:AddToJumpPageDeque(AnglingMap)
    end
end

-- 跳转到印象商店(商店合集页用)
function PageJumpUtils:JumpToImprShopPage(Param)
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    self:CloseFrontDialog()
    local RegionId = Param
    local MainTabId = 1
    local MainTabDatas = DataMgr.ImpressionShopMainTab
    for _, MainTabData in pairs(MainTabDatas) do
        if MainTabData.RegionId == RegionId then
            MainTabId = MainTabData.MainTabId
        end
    end
    local ImprShop = UIManager:LoadUINew("ImpressionShop", MainTabId, nil, nil, true)
    UIManager:AddToJumpPageDeque(ImprShop)
end

-- 前往到某个特定地点（二次确认）
function PageJumpUtils:JumpToTargetPointWithConfirm(TargetSubRegionId, StartIndex, PopupUIId)
    local CancelDeliverTo = function()
    end

    local DoDeliverTo = function()
        local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
        if IsValid(GameMode) then
            GameMode:HandleLevelDeliver(UE4.EModeType.ModeRegion, math.tointeger(TargetSubRegionId), math.tointeger(StartIndex), false)
        end
    end

    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local Params =
    {
        LeftCallbackObj = self,
        LeftCallbackFunction = CancelDeliverTo,
        RightCallbackObj = self,
        RightCallbackFunction = DoDeliverTo,
        CloseBtnCallbackObj = self,
        CloseBtnCallbackFunction = CancelDeliverTo
    }
    UIManager:ShowCommonPopupUI(math.tointeger(PopupUIId), Params)
end

local JumpToPageCheck = function(JumpToPageUIName)
    local SystemUI = DataMgr.SystemUI[JumpToPageUIName]
    if (SystemUI and SystemUI.System) then
        local UIUnlockRuleInfo = DataMgr.UIUnlockRule[SystemUI.System]
        if (UIUnlockRuleInfo and UIUnlockRuleInfo.OpenConditionId) then
            local PlayerAvatar = GWorld:GetAvatar()
            local IsCanOpen, FailedIdIndex = PlayerAvatar:CheckSystemUICanOpen(UIUnlockRuleInfo.UIUnlockRuleId)
            if (not IsCanOpen) then
                local OpenConditionId = UIUnlockRuleInfo.OpenConditionId
                local OpenDescs = UIUnlockRuleInfo.OpenSystemDesc
                if #OpenConditionId == #OpenDescs then
                    for _, Value in pairs(FailedIdIndex) do
                        UIManager(GWorld.GameInstance):ShowUITip(UIConst.Tip_CommonToast, OpenDescs[Value])
                    end
                else
                    UIManager(GWorld.GameInstance):ShowUITip(UIConst.Tip_CommonToast, OpenDescs[1])
                end
                return false
            end
        end
    end
    return true
end

function PageJumpUtils:JumpToTargetPageByJumpId(JumpId, ...)
    local JumpSuccess = false
    local JumpConfig = DataMgr.InterfaceJump[JumpId]
    if (not JumpConfig) then
        DebugPrint("JumpToTargetPageByJumpId Error, Data not find in InterfaceJump, JumpId is", JumpId)
        return JumpSuccess
    end
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()

    local PlayerAvatar = GWorld:GetAvatar()
    -- 先判断是否满足解锁条件
    if (not ConditionUtils.CheckCondition(PlayerAvatar, JumpConfig.PortalUnlockCondition)) then
        UIManager:ShowUITip(UIConst.Tip_CommonToast, JumpConfig.PortalUnlockTips)
        return JumpSuccess
    end

    local JumpToPageUIName = JumpConfig.JumpParameter1
    -- 再判断是否满足开启条件
    if(not JumpToPageCheck(JumpToPageUIName))then
        return JumpSuccess
    end

    local Params = {}
    for i = 2, 10 do
        local ParamVar = JumpConfig["JumpParameter"..i]
        if (ParamVar ~= nil) then
            table.insert(Params, ParamVar)
        end
    end

    -- 把自定义的数据塞进去
    local ExtraParams = {...}
    for _, value in ipairs(ExtraParams) do
        table.insert(Params, value)
    end

    if (JumpConfig.JumpType == "SelfDefinedJump") then
        if (type(PageJumpFunctionLibrary[JumpToPageUIName]) == "function") then
            PageJumpFunctionLibrary[JumpToPageUIName](table.unpack(Params))
            JumpSuccess = true
        elseif (type(self[JumpToPageUIName]) == "function") then
            self[JumpToPageUIName](self, table.unpack(Params))
            JumpSuccess = true
        else
            DebugPrint("JumpToTargetPageByJumpId Error, SelfDefined funtion not find, Function Name is", JumpToPageUIName)
            return JumpSuccess
        end
    else
        self:CloseFrontDialog()
        local TargetUIPage = UIManager:GetUIObj(JumpToPageUIName)
        if (not TargetUIPage) then
            TargetUIPage = UIManager:LoadUINew(JumpToPageUIName, table.unpack(Params))
            UIManager:AddToJumpPageDeque(TargetUIPage)
        else
            -- 已经存在的界面
            UIManager:PlaceJumpUIToTop(TargetUIPage, JumpToPageUIName)
        end
        JumpSuccess = true
    end

    return  JumpSuccess
end

--- 跳转到某个页面
function PageJumpUtils:JumpToTargetPage(TargetUIName, ...)
    if (not TargetUIName) then
        DebugPrint("JumpToTargetPage Error, TargetUIName is nil")
        return
    end
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()

    local TargetUIPage = UIManager:GetUIObj(TargetUIName)
    if (not TargetUIPage) then
        TargetUIPage = UIManager:LoadUINew(TargetUIName, ...)
        UIManager:AddToJumpPageDeque(TargetUIPage)
    else
        -- 已经存在的界面
        UIManager:PlaceJumpUIToTop(TargetUIPage, TargetUIName)
    end
end

---跳转到指定抽卡页面
---@param GachaTabId number @抽卡卡池 index
function PageJumpUtils:JumpToGachaPage(GachaTabId)
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    local GachaMainPage = UIManager:GetUIObj("GachaMain")
    local Avatar = GWorld:GetAvatar()
    GachaTabId = tonumber(GachaTabId)
    local GachaTabInfo = GachaModel:GetEffectiveGachaInfo()
    if not Avatar or not GachaTabInfo or not GachaTabInfo[GachaTabId] or not next(GachaTabInfo[GachaTabId]) then
        UIManager:ShowUITip("CommonToastMain", GText("UI_CharTrial_GachaLocked"), 1.5)
        return
    end
    local GachaValid = false
    local GachaUnlock = false
    for key,value in pairs(GachaTabInfo[GachaTabId]) do
        local GachaPool = Avatar.SkinGachaPool[value]
        if GachaPool and GachaPool.Usable == 1 then
            GachaValid = true
        end
        local GachaInfo = DataMgr.SkinGacha[value]
        if GachaInfo then
            local ConditionId = GachaInfo.ConditionId
            local ConditionSucc = true
            if ConditionId then
                ConditionSucc = ConditionUtils.CheckCondition(Avatar,ConditionId)
            end
            if ConditionSucc then
                GachaUnlock = true
            end
        end
    end
    if not GachaValid then
        UIManager:ShowUITip("CommonToastMain", GText("UI_CharTrial_NotInGachaPeriod"), 1.5)
        return
    end
    if not GachaUnlock then
        UIManager:ShowUITip("CommonToastMain", GText("UI_CharTrial_GachaLocked"), 1.5)
        return
    end
    if (not GachaMainPage) then
        local Params = {
            InitGachaTabId = GachaTabId,
        }
        UIUtils.OpenSystem(CommonConst.GachaEnterId,false,Params)
        local GachaMainPage = UIManager:GetUI("GachaMain")
        UIManager:AddToJumpPageDeque(GachaMainPage)
    else
        -- 已经存在的界面
        UIManager:PlaceJumpUIToTop(GachaMainPage, "GachaMain")
        GachaMainPage:InitGachaUI(GachaTabId)
    end
end

---@param Params table 自定义参数，详情见Armory_Main_Base_C.lua的InitUIInfo方法
function PageJumpUtils:JumpToArmory(Params)
    local UIName = "ArmoryMain"
    if(not JumpToPageCheck(UIName))then
        return
    end

    GameFlowUtils:AddFlow("OpenSystemUI", {
        GWorld.GameInstance, function(_, Flow)
            local UIManager = GWorld.GameInstance:GetGameUIManager()
            local TargetUIPage = UIManager:GetUIObj(UIName)
            if (not TargetUIPage) then
                TargetUIPage = UIManager:LoadUINew(UIName, Params)
                UIManager:AddToJumpPageDeque(TargetUIPage)
                UIManager:AddFlow(UIName, Flow)
            else
                UIManager:PlaceJumpUIToTop(TargetUIPage, UIName)
                GameFlowUtils:RemoveFlow(Flow)
            end
        end
    })
end

function PageJumpUtils:JumpToAbyssMainNormal()
    return self:JumpToAbyssMain(false)
end

function PageJumpUtils:JumpToAbyssMainFromActivity()
    return self:JumpToAbyssMain(true)
end

function PageJumpUtils:JumpToAbyssMain(IsFromActivity)
    local UIName = "AbyssMain"
    if(not JumpToPageCheck(UIName))then
        return false
    end
    local TargetAbyssId = nil
    local Avatar = GWorld:GetAvatar()
    if Avatar and Avatar.Abysses then
        local AbyssIds = {}
        local Abysses = DataMgr.AbyssSeason
        for AbyssId,_ in pairs(Abysses) do
            if Avatar.Abysses[AbyssId] and (not Avatar.Abysses[AbyssId].AbyssSeasonId or Avatar.Abysses[AbyssId].AbyssSeasonId == Avatar.CurrentAbyssSeasonId)  then
                table.insert(AbyssIds, AbyssId)
            end
        end
        table.sort(AbyssIds, function(a,b)
            return Abysses[a].Order < Abysses[b].Order
        end)
        for _,AbyssId in ipairs(AbyssIds) do
            local IsLocked = Avatar.Abysses[AbyssId]:IsLocked()
            if not IsLocked then
                TargetAbyssId = AbyssId
            end
        end
    end
    if TargetAbyssId then
        self:CloseFrontDialog()
        local GameInstance = GWorld.GameInstance
        local UIManager = GameInstance:GetGameUIManager()
        local AbyssMain = UIManager:GetUIObj(UIName)
        if (not AbyssMain) then
            AbyssMain = UIManager:LoadUINew(UIName, TargetAbyssId, false, IsFromActivity)
            UIManager:AddToJumpPageDeque(AbyssMain)
        else
            AbyssMain:SelectAbyssModeSelectionCellByAbyssId(TargetAbyssId)
            UIManager:PlaceJumpUIToTop(AbyssMain, UIName)
        end
        return true
    end
    return false
end

function PageJumpUtils:JumpToAutoChessMain()
    local UIName = "AutoChessMain"
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    UIManager:LoadUINew(UIName, GameInstance.AutoChessMissionId)
    GameInstance.AutoChessMissionId = nil
    return true
end


-- 跳转到玩法界面的某个子界面
function PageJumpUtils:JumpToStyleOfPlaySubUI(SubUIName, ...)
    local UIName = "StyleOfPlay"
    local bSkipCheck = false
    local Params = table.pack(...)
    if #Params>1 and type(Params[1]) == "boolean" then
        bSkipCheck = Params[1]
        Params = table.slice(Params, 2, #Params)
    end
    if(not JumpToPageCheck(UIName)) and (not bSkipCheck) then
        return false
    end
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()

    self:CloseFrontDialog()

    local StyleOfPlay = UIManager:GetUIObj("StyleOfPlay")
    if (not StyleOfPlay) then
        StyleOfPlay = UIManager:LoadUINew("StyleOfPlay")
        UIManager:AddToJumpPageDeque(StyleOfPlay)
    else
        UIManager:PlaceJumpUIToTop(StyleOfPlay, "StyleOfPlay")
    end

    local WidgetUI = StyleOfPlay:OpenSubUI(SubUIName)
    if WidgetUI.SubUIJumpFunc then
        WidgetUI:SubUIJumpFunc(table.unpack(Params))
    end
    return true
end


function PageJumpUtils:SoloTreasureStoryLevel(...)
    local UIName = "ActivitySoloTreasureMain"
    local EventId, Mode = ... 
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    UIManager:LoadUINew(UIName, EventId, Mode)
    return true
end

function PageJumpUtils:SoloTreasureRepeatLevel(...)
    local UIName = "ActivitySoloTreasureMain"
    -- Mode: Repeat = 1, Story = 2 
    local EventId, Mode, bIsDifficult, EventDugeonId = ... 
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    UIManager:LoadUINew(UIName, EventId, Mode, bIsDifficult, EventDugeonId)
    return true
end

return PageJumpUtils