--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Settlement_Refund_C
local WBP_Settlement_Refund_C = Class({"BluePrints.UI.BP_EMUserWidget_C"})

--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


function WBP_Settlement_Refund_C:InitItemInfo(ItemId, ItemNum)
    local ItemInfo = {}

    local WalnutData = DataMgr.Walnut[ItemId]
    local WalnutTypeData = {}
    local WalnutRaity = nil
    local WalnutIconPath = nil
    ItemInfo.IsWalnut = WalnutData and true or false
    if ItemInfo.IsWalnut then
        WalnutTypeData = DataMgr.WalnutType[WalnutData.WalnutType]
        WalnutRaity = WalnutData.Rarity
        -- WalnutIconPath = WalnutTypeData.Icon
        WalnutIconPath = WalnutData.Icon
    end
    local ItemData = DataMgr.Resource[ItemId]
    if not ItemData and not WalnutData then 
        return 
    end

    ItemInfo.ParentWidget = self
    ItemInfo.CommonType = "Refund"
    ItemInfo.Id = ItemId
    ItemInfo.Count = ItemNum or 1
    ItemInfo.Icon = WalnutIconPath or ItemData.Icon
    ItemInfo.AfterInitCallback = function(Widget)
        if Widget.CanvasPanel_0 then 
            Widget.CanvasPanel_0:SetRenderOpacity(0.0)
        end
        if self.IsAllowPropInAnimation and (not Widget.Content.IsPlayedInAnimation) then
            Widget:PlayInAnimation()
            Widget.Content.IsPlayedInAnimation = true
        else 
            if Widget.Rarity == 5 then
                Widget:PlayAnimation(Widget.Orange_In, Widget.Orange_In:GetEndTime())
            elseif Widget.Rarity == 4 then
                Widget:PlayAnimation(Widget.purple_In, Widget.purple_In:GetEndTime())
            else
                Widget:PlayAnimation(Widget.Normal_In, Widget.Normal_In:GetEndTime())
            end
        end
        Widget.Bg03:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    ItemInfo.Rarity = WalnutRaity or ItemData.Rarity
    ItemInfo.OnMouseButtonUpEvents = {
        Obj = self,
        Callback = self.OpenWalnutDetail,
        Params = {ItemId}
    }
    ItemInfo.IsShowDetails = ItemInfo.IsWalnut and false or true
    ItemInfo.ItemType = ItemInfo.IsWalnut and "Walnut" or "Resource"
    ItemInfo.IsSpecial = false
    ItemInfo.IsBonus = false
    ItemInfo.IsWalnutBonus = false
    ItemInfo.UIName = "DungeonSettlement"
    return ItemInfo
end

function WBP_Settlement_Refund_C:OpenWalnutDetail(WalnutId)
    if not UIManager(self):GetUIObj("WalnutRewardDialog") then
        self.DialogWidget = UIManager(self):LoadUINew("WalnutRewardDialog", WalnutId, "DungeonSettlement")
    end
    self.DialogWidget:Show("DungeonSettlement")
end

function WBP_Settlement_Refund_C:AddRefundItem(ItemInfo)
    local DungeonSettlement = UIManager(self):GetUI("DungeonSettlement")
    if not DungeonSettlement then 
        return 
    end

    local Item = DungeonSettlement:NewPropContent(ItemInfo, self.TileView_Refund)
    Item.AfterInitCallback = nil -- 返还道具是小尺寸格子,小尺寸格子的动画播放重写过 不走AfterInitCallback里的逻辑
    self.TileView_Refund:AddItem(Item)
end

function WBP_Settlement_Refund_C:UpdateGamePadIcon(GamePadIcon)
    --电脑不传IconPath
    if GamePadIcon then
        DebugPrint("thy     UpdateGamePadIcon ", GamePadIcon)
        local KeyInfo = {
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = GamePadIcon,
                },
            },
        }
        DebugPrint("thy     self.Icon_Key_Refund is Visible")
        self.Icon_Key_Refund:SetVisibility(ESlateVisibility.Visible)
        self.Icon_Key_Refund:SetRenderOpacity(1)
        self.Icon_Key_Refund:CreateCommonKey(KeyInfo)
    else
        self.Controller_Refund:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function WBP_Settlement_Refund_C:GetShowState()
    return self.IsShow
end

function WBP_Settlement_Refund_C:GetFocusState()
    return self.IsFocus
end

--显示手柄图标
function WBP_Settlement_Refund_C:Show()
    self.IsShow = true
    self.Controller_Refund:SetVisibility(ESlateVisibility.Visible)
end

--隐藏手柄图标
function WBP_Settlement_Refund_C:Hide()
    self.IsShow = false
    self.Controller_Refund:SetVisibility(ESlateVisibility.Collapsed)
end

--聚焦到返还道具栏
function WBP_Settlement_Refund_C:SetItemListFocus()
    self.IsFocus = true
    self.TileView_Refund:SetFocus()
end

--取消聚焦
function WBP_Settlement_Refund_C:CancelItemListFocus()
    self.IsFocus = false
end

function WBP_Settlement_Refund_C:InitRefund(Content)
    if not Content then return end
    local AddItemNum = 0 -- 因为体力无论返不返还一定会在Content里，所以设置一个add的计数
    self.TileView_Refund:ClearListItems()
    for key, value in pairs(Content) do
        if key == 1 then
            --精力
            if value ~= 0 then
                AddItemNum = AddItemNum + 1
                self:AddRefundItem(self:InitItemInfo(103, value))
            end
            goto continue
        end
        AddItemNum = AddItemNum + 1
        self:AddRefundItem(self:InitItemInfo(value, nil))
        ::continue::
    end
    if AddItemNum == 0 then
        self:SetVisibility(ESlateVisibility.Collapsed)
        return
    end
    --refund的配置文本
    self.Text_Refund:SetText(GText("UI_Refund"))
    --当前返还道具栏的显隐状态
    self.IsShow = true
    --是否聚焦
    self.IsFocus = false
end

return WBP_Settlement_Refund_C
