--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR 叶轲
-- @DATE ${date} ${time}
-- 通用商店跳转好友选择界面的弹窗
require "UnLua"
local GiftModel = GiftController:GetModel()

---@type WBP_Gift_ShopTarget_ChooseContent_C
local M = Class({"BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end
M._components = {
   "BluePrints.UI.WBP.Gift.Widget.WBP_Gift_ShopTarget_ChooseContent_GamePadConpoment",
}
function M:InitContent(Content)
    DebugPrintTable(Content)
    self.Content = Content
    self.ShopItemId = Content.ShopItemId
    -- 使用通用弹窗方法清理底部快捷键的残留内容，保证后续 ShowAll 只恢复本界面初始化的索引
    if self.Owner and self.Owner.ClearAllGamepadShortcutContent then
        self.Owner:ClearAllGamepadShortcutContent()
    end
    -- 重新生成并展示“B 关闭”快捷键，避免被清理后无法通过 ShowAll 恢复
    self:ShowGamepadCloseBtn(true)

    -- 初始化并展示礼包信息（图标、名称、奖励列表、价格等）
    self:InitGiftInfo()
    self:InitFriends()
    --self:AddInputMethodChangedListen()
    --self.Owner:InitGamepadShortcut(self.AdjustBtnIdx)
    self.Com_Qa:Init( {
                OwnerWidget = self,
                TextContent = self:GetQAText(),
                OnMenuOpenChangedCallBack = self.OnDescOpenChanged,
            })

    self:AddDispatcher(EventID.UnLoadUI, self, self.OnUIUnLoad)
end

function M:OnUIUnLoad(UIName)
    DebugPrint("yklua OnUIUnLoad" .. UIName)

    if UIName == "PersonInfoPageMain" then
        if not self.Owner:IsVisible() then
            self.Owner:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        end
        if self.IsGamePad then
            self:AddTimer(0.01, function()
                self:InitOriginFocus()
            end)
        end
    end
end


function M:GetQAText()
    local ConsumeGiftQuota, TotalGiftQuota = GiftModel:GetTotalGiftQuota()
    local CurrentMonthSendGiftCount, TotalGiftCount = GiftModel:GetTotalGiftCount()
    return string.format(GText("UI_SendGift_Desc"),  ConsumeGiftQuota, TotalGiftQuota,CurrentMonthSendGiftCount, TotalGiftCount)
end

function M:Construct()
    self.Text_Empty:SetText(GText("UI_SendGift_NoFriend"))
    self.Text_ChooseTargetTitle:SetText(GText("UI_SendGift_ChooseFriend"))
    -- 不足3个条目时走“居中平铺填满”策略
    self.MaxPerRow = 3
end

function M:InitFriends()
    local Friends = GiftModel:GetFriends()
    if not Friends or #Friends == 0 then
        self.WS_List:SetActiveWidgetIndex(1)
        -- 无合适好友：隐藏“查看玩家”和“确认”两个底部快捷键，仅隐藏指定索引，避免与其他函数冲突
        self:UpdateEmptyFriendsShortcuts(false)
        return
    end
    self.WS_List:SetActiveWidgetIndex(0)
    self.List_FriendContent:ClearListItems()
    for _,Friend in pairs(Friends) do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.HeadFrameId = Friend.Info.HeadFrameId
        Content.Nickname = Friend.Info.Nickname
        Content.HeadIconId = Friend.Info.HeadIconId
        Content.Uid = Friend.Uid
        Content.Parent = self
        Content.ShopItemId = self.ShopItemId
        self.List_FriendContent:AddItem(Content)
    end
    -- self:AddTimer(0.01, function()
    --     self.List_FriendContent:RequestFillEmptyContent()
    -- end)
    self.List_FriendContent.OnCreateEmptyContent:Bind(self, function(self)
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        Obj.IsEmpty = true
        return Obj
    end)
    self.List_FriendContent:RequestFillEmptyContent()

    -- 有好友：恢复显示两个底部快捷键（保持与手柄选择模式逻辑互不冲突）
    self:UpdateEmptyFriendsShortcuts(true)
end
-- 复制并简化自 WBP_Shop_Gift_PopUp_C.lua 的礼包信息展示逻辑
function M:InitGiftInfo()
    if not self.ShopItemId then
        return
    end

    -- 取商店条目与礼包条目
    local ShopItemData = DataMgr.ShopItem and DataMgr.ShopItem[self.ShopItemId]
    if not ShopItemData then
        return
    end

    local ItemType = ShopItemData.ItemType
    local TypeId = ShopItemData.TypeId
    local ItemData = DataMgr[ItemType] and DataMgr[ItemType][TypeId]
    if not ItemData then
        return
    end

    -- 图标/稀有度：改为使用材质参数与通用道具框一致（IconMap/Index）
    local Icon = ItemUtils.GetItemIcon(TypeId, ItemType)
    if self.ImageGiftItemBG then
        local DynamicMaterial = self.ImageGiftItemBG:GetDynamicMaterial()
        if IsValid(DynamicMaterial) then
            if Icon then
                DynamicMaterial:SetTextureParameterValue("IconMap", Icon)
            end
            -- 同步稀有度以驱动材质底色，与通用道具框一致
            local Rarity = ItemUtils.GetItemRarity(TypeId, ItemType) or 1
            DynamicMaterial:SetScalarParameterValue("Index", Rarity)
            -- 确保主图标可见
            DynamicMaterial:SetScalarParameterValue("IconOpacity", 1)
            -- 最高稀有的色彩/叠加效果（若材质支持这些参数）
            if Rarity == 6 then
                DynamicMaterial:SetScalarParameterValue("ColorfulSwitch", 1)
                DynamicMaterial:SetScalarParameterValue("AddOpacity", 1)
                DynamicMaterial:SetScalarParameterValue("IconAddOpacity", 1)
            else
                DynamicMaterial:SetScalarParameterValue("ColorfulSwitch", 0)
                DynamicMaterial:SetScalarParameterValue("AddOpacity", 0)
                DynamicMaterial:SetScalarParameterValue("IconAddOpacity", 0)
            end
        end
    end

    -- 名称（使用 Text_GiftPackName 显示礼包名称）
    local ItemName = ItemUtils:GetDropName(TypeId, ItemType)
    if self.Text_GiftPackName then
        self.Text_GiftPackName:SetText(GText(ItemName))
    end

    -- 奖励列表（礼包）或单独商品道具框
    local Rewards = ItemData.RewardId and DataMgr.Reward and DataMgr.Reward[ItemData.RewardId]
    if self.List_Item then
        self.List_Item:ClearListItems()
        if Rewards and Rewards.Id and Rewards.Count and Rewards.Type then
            -- 礼包：展开奖励列表
            for i = 1, #Rewards.Id do
                local RewardItemId = Rewards.Id[i]
                local RewardCount = RewardUtils:GetCount(Rewards.Count[i])
                local RewardType = Rewards.Type[i]

                local Content = NewObject(UIUtils.GetCommonItemContentClass())
                Content.Id = RewardItemId
                Content.Icon = ItemUtils.GetItemIconPath(RewardItemId, RewardType)
                Content.ParentWidget = self
                Content.ItemType = RewardType
                Content.Count = RewardCount
                Content.Rarity = ItemUtils.GetItemRarity(RewardItemId, RewardType) or 1
                Content.IsShowDetails = true
                Content.UIName = "ShopMain"
                Content.bNoJumpPreview = true
                self.List_Item:AddItem(Content)
            end

            -- 新版适配：礼包条目少于3个时，按 item 数量设置 Group_Item 的宽度覆盖为 self.ItemSize * count
            do
                local count = #Rewards.Id
                if self.Group_Item and count then
                    if count < 3 and self.ItemSize then
                        self.Group_Item:SetWidthOverride(self.ItemSize * count)
                    end
                end
            end
        else
            -- 非礼包（单独商品）：仅显示该道具的道具框
            local SingleContent = NewObject(UIUtils.GetCommonItemContentClass())
            SingleContent.Id = TypeId
            SingleContent.Icon = ItemUtils.GetItemIconPath(TypeId, ItemType)
            SingleContent.ParentWidget = self
            SingleContent.ItemType = ItemType
            SingleContent.Count = ShopItemData.TypeNum or 1
            SingleContent.Rarity = ItemUtils.GetItemRarity(TypeId, ItemType) or 1
            SingleContent.IsShowDetails = true
            SingleContent.UIName = "ShopMain"

            self.List_Item:AddItem(SingleContent)

            if self.VB_Item then
                self.VB_Item:SetVisibility(ESlateVisibility.Collapsed)
            end
        end
        -- 不调用 RequestFillEmptyContent：避免生成空Item与Widget
    end

    -- 价格与货币图标：区分充值（人民币/美元等）与资源（月石等）
    local Cost = ShopUtils:GetShopItemPrice(self.ShopItemId)
    local isPayGoods = DataMgr.ShopItem2PayGoods and DataMgr.ShopItem2PayGoods[self.ShopItemId] ~= nil
    if isPayGoods then
        -- 充值类商品：显示地区货币符号 + 金额，隐藏资源图标
        local moneySymbol = ShopUtils:GetCurrencyType()
        if self.Text_Price then
            self.Text_Price:SetText(GText(moneySymbol)..tostring(Cost))
        end
        if self.Img_Currency then
            self.Img_Currency:SetVisibility(ESlateVisibility.Collapsed)
        end
    else
        -- 资源类商品：显示资源图标 + 金额
        if self.Text_Price then
            self.Text_Price:SetText(Cost)
        end
        if self.Img_Currency and ShopItemData.PriceType then
            local currencyIcon = ItemUtils.GetItemIcon(ShopItemData.PriceType, "Resource")
            if currencyIcon then
                self.Img_Currency:SetBrushResourceObject(currencyIcon)
                self.Img_Currency:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            end
        end
    end

    -- 顶部资源栏币种记录：实际刷新放在 PostInitContent（通用弹窗完成后）
    if isPayGoods then
        self._TopResourceIdList = nil
    else
        local fundId = ShopItemData.PriceType
        if fundId then
            self._TopResourceIdList = { fundId }
        else
            self._TopResourceIdList = nil
        end
    end

    -- 折扣展示逻辑（参考 WBP_ShopItem_C）：显示划线原价与折扣百分比；无折扣则隐藏
    local CutoffData = ShopUtils:GetShopItemCutoffData(self.ShopItemId)
    self.CutoffData = CutoffData
    if self.Text_Undiscounted_Price then
        self.Text_Undiscounted_Price:SetVisibility(ESlateVisibility.Collapsed)
    end
    if self.Panel_Discount then
        self.Panel_Discount:SetVisibility(ESlateVisibility.Collapsed)
    end
    if CutoffData then
        -- 折扣百分比（Text_Discount 显示为 100 - CutoffShow）
        if self.Text_Discount and CutoffData.CutoffShow then
            self.Text_Discount:SetText(100 - CutoffData.CutoffShow)
        end
        -- 划线原价
        if self.Text_Undiscounted_Price then
            local originalPrice
            if isPayGoods and DataMgr.ShopItem2PayGoods and DataMgr.PayGoods then
                local payId = DataMgr.ShopItem2PayGoods[self.ShopItemId]
                local payData = payId and DataMgr.PayGoods[payId]
                local priceField = ShopUtils:GetCurrencyPrice()
                originalPrice = (payData and payData[priceField]) or Cost
            else
                originalPrice = ShopItemData.Price or Cost
            end
            self.Text_Undiscounted_Price:SetText(math.ceil(originalPrice))
            self.Text_Undiscounted_Price:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
        -- 折扣面板可见
        if self.Panel_Discount then
            self.Panel_Discount:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
    end

    -- 超值/折扣文案（如果有）
    if self.Group_More and self.Text_MoreNum then
        if ShopItemData.ShowBonus then
            self.Group_More:SetVisibility(ESlateVisibility.Visible)
            self.Text_MoreNum:SetText("+"..ShopItemData.ShowBonus)
        else
            self.Group_More:SetVisibility(ESlateVisibility.Collapsed)
        end
    end

    -- if self.Com_Qa then
    --     if ShopItemData.ItemDes then
    --         local ConfigData = {
    --             OwnerWidget = self,
    --             TextContent = GText(ShopItemData.ItemDes),
    --             OnMenuOpenChangedCallBack = self.OnDescOpenChanged,
    --         }
    --         if self.Com_Qa.Init then
    --             self.Com_Qa:Init(ConfigData)
    --         end
    --         self.Btn_Qa:SetVisibility(ESlateVisibility.Visible)
    --         self.Text_Qa:SetVisibility(ESlateVisibility.Visible)
    --     else
    --         self.Btn_Qa:SetVisibility(ESlateVisibility.Collapsed)
    --         self.Text_Qa:SetVisibility(ESlateVisibility.Collapsed)
    --     end
    -- end
end

-- 根据是否有合适好友，隐藏/显示指定的底部快捷键索引
function M:UpdateEmptyFriendsShortcuts(hasFriends)
    local Owner = self.Owner
    if not Owner then return end

    -- 组件通过 AssembleComponents 已合并到本实例，直接使用同名字段
    local idxCheckPlayer = self.CheckPlayerBtnIdx
    local idxConfirm = self.ConfirmBtnIdx

    if not hasFriends then
        if idxCheckPlayer and Owner.HideGamepadShortcut then Owner:HideGamepadShortcut(idxCheckPlayer) end
        if idxConfirm and Owner.HideGamepadShortcut then Owner:HideGamepadShortcut(idxConfirm) end
    else
        if idxCheckPlayer and Owner.ShowGamepadShortcut then Owner:ShowGamepadShortcut(idxCheckPlayer) end
        if idxConfirm then
            -- 确保 A 键文案为“选择”，并显示该快捷键
            local ConfirmKey = Owner.GetGamepadShortcutByIndex and Owner:GetGamepadShortcutByIndex(idxConfirm) or nil
            if ConfirmKey and ConfirmKey.SetDescription then
                ConfirmKey:SetDescription(GText("UI_CTL_Select"))
            end
            if Owner.ShowGamepadShortcut then Owner:ShowGamepadShortcut(idxConfirm) end
        end
    end
end

-- TileView 单行均分填满：条目不足 self.MaxPerRow（默认3）时，将每个格子宽度设为可用宽度的等分
function M:UpdateTileViewJustify()
    local tv = self.List_Item
    if not tv or not tv.GetNumItems or not tv.SetEntryWidth then return end

    local count = tv:GetNumItems()
    if not count or count <= 0 then return end

    -- 仅在不足列数时触发（默认3列），否则恢复原始宽度
    local limit = self.MaxPerRow or 3
    if not self._OriginalEntryWidth and tv.GetEntryWidth then
        self._OriginalEntryWidth = tv:GetEntryWidth()
    end
    if count >= limit then
        if self._OriginalEntryWidth then
            tv:SetEntryWidth(self._OriginalEntryWidth)
        end
        return
    end

    -- 可用宽度（Slate单位）：使用 UIManager 渲染尺寸，兼容 UnLua 几何调用
    local uiMgr = UIManager(tv)
    local parent = tv:GetParent()
    local size = uiMgr and uiMgr:GetWidgetRenderSize(tv) or nil
    if parent and parent:Cast(UScrollBox) then
        size = uiMgr and uiMgr:GetWidgetRenderSize(parent) or size
    end
    local availW = size and size.X or nil
    if not availW or availW <= 0 then return end

    -- 间距（本项目 EntrySpacing 为标量 number）
    local spacing = tv.EntrySpacing or 0
    local totalSpacing = spacing * (count - 1)
    local perWidth = (availW - totalSpacing) / count
    tv:SetEntryWidth(math.max(1, perWidth))
    
end

-- 根据条目数量动态设置 VB_Item 的宽度：
-- 1 个条目使用 self.SingleItemWidth；2 个条目使用 self.DoubleItemWidth；其他不变。
function M:UpdateItemContainerWidth()
    local tv = self.List_Item
    if not tv or not tv.GetNumItems then return end

    local count = tv:GetNumItems()
    if not count or count <= 0 then return end

    local width
    if count == 1 and self.SingleItemWidth then
        width = self.SingleItemWidth
    elseif count == 2 and self.DoubleItemWidth then
        width = self.DoubleItemWidth
    else
        -- 其他数量保持不变
        return
    end

    -- 直接对 VB_Item 的 CanvasPanelSlot 设置 Size
    if not self.VB_Item or not self.VB_Item.Slot then return end
    local slot = self.VB_Item.Slot
    local curSize = slot.GetSize and slot:GetSize() or nil
    local height = (curSize and curSize.Y) or 0
    slot:SetSize(FVector2D(width, height))
end

-- 通用弹窗完成初始化后统一刷新顶部资源栏，避免被默认流程覆盖
function M:PostInitContent(Params, PopupData, Owner)
    if self._TopResourceIdList and #self._TopResourceIdList > 0 then
        self:RefreshTopResourceBar(self._TopResourceIdList)
    else
        self:RefreshTopResourceBar(nil)
    end
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        -- self.PersonInfoMainPage:RotateActorForGamePad()
        self.IsGamePad = true
        IsEventHandled = self:OnGamePadDown(InKeyName)
    else
        self.IsGamePad = false
    end
    if (IsEventHandled) then
        return true
    else
        return false
    end
    
end
--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

-- 刷新弹窗顶部资源栏（传入资源ID数组；nil/空则隐藏）
function M:RefreshTopResourceBar(ResourceIdList)
    local Owner = self.Owner
    if not Owner or not Owner.TopResourcePanel or not Owner.WBP_Com_Tab_Node_ResourceBar then
        return
    end
    if ResourceIdList and #ResourceIdList > 0 then
        Owner.TopResourcePanel:SetVisibility(UE4.ESlateVisibility.Visible)
        Owner.WBP_Com_Tab_Node_ResourceBar:InitResourceBar(ResourceIdList)
        local ResourceBarIcon = UIUtils.UtilsGetKeyIconPathInGamepad("RS", "Generic")
        Owner.WBP_Com_Tab_Node_ResourceBar:SetGamePadKeyImgByPath(ResourceBarIcon)
        -- 按下 B 从资源栏返回到“好友列表”的第一个条目
        Owner.WBP_Com_Tab_Node_ResourceBar:SetGetReplyOnBack(function()
            self:InitOriginFocus()
            return nil
        end)
        -- 兜底：若无法获取首个条目，至少返回到好友列表控件
        if self.List_FriendContent then
            Owner.WBP_Com_Tab_Node_ResourceBar:SetLastFocusWidget(self.List_FriendContent)
        else
            Owner.WBP_Com_Tab_Node_ResourceBar:SetLastFocusWidget(Owner)
        end
    else
        Owner.TopResourcePanel:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end
AssembleComponents(M)
return M
