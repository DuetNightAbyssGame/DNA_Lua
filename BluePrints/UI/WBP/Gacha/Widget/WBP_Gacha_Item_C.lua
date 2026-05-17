--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Gacha_Item_C
local M = Class({"BluePrints.UI.UI_PC.Common.Common_Item.WBP_Com_Item_Base_C"})

function M:Init(Content)
    self:InitData(Content)
    self.DelayTime = Content.DelayTime or 0

    self.Panel_Change:SetVisibility(ESlateVisibility.Collapsed)
    self.Text_GetNum:SetText(Content.Count)
    if Content.bNew then
        self.New:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.New:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.bConvert = Content.bConvert
    -- if not self.bConvert then
        self:StopAnimation(self.Convert)
    -- end
    if Content.Rarity == 6 then
        self:PlayAnimation(self.In_Red)
    elseif Content.Rarity == 5 then
        self:PlayAnimation(self.In_Yellow)
    elseif Content.Rarity == 4 then
        self:PlayAnimation(self.In_Purple)
    elseif Content.Rarity == 3 then
        self:PlayAnimation(self.In_Blue)
    end
    self:OnListItemObjectSet(Content)
end

-- function M:OnListItemObjectSet(Content)
--     self.Text_GetNum:SetText(Content.Count)
--     self.Content = Content
--     local ItemContent = {}
--     ItemContent.ShopItemId = Content.Id
--     ItemContent.Icon = ItemUtils.GetItemIconPath(ItemContent.ShopItemId, Content.ItemType)
--     ItemContent.ItemType = Content.ItemType
--     ItemContent.Rarity = Content.Rarity
--     ItemContent.Count = Content.Count
--     ItemContent.IsShowDetails = not Content.bConvert
--     ItemContent.bDisableCommonClick = Content.bConvert
--     ItemContent.Parent = Content.Parent
--     self.bConvert = Content.bConvert

-- end

function M:PlayConvertAnim()
    if self.bConvert then
        local ItemData = DataMgr[self.Content.ItemType][self.Content.Id]
        assert(ItemData, "抽卡结果道具不存在")
        if ItemData.RegainItemId then
            self.ItemIcon:Init(
                {
                    Id = ItemData.RegainItemId,
                    Icon = LoadObject(DataMgr.Resource[ItemData.RegainItemId].Icon),
                    ItemType = "Resource",
                    UIName = "GahcaMain",
                    IsShowDetails = true,
                    MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight,
                }
            )
            self.Text_ItemNum:SetText("×"..ItemData.RegainItemNum)
        end
        AudioManager(self):PlayUISound(self, "event:/ui/common/gacha_trans_to_coin", nil, nil)
        self:PlayAnimation(self.Convert)
    end
end
--- 是否正在播放In动画
function M:IsInAnimationPlaying()
    if self:IsAnimationPlaying(self.In_Red) or
    self:IsAnimationPlaying(self.In_Yellow) or
    self:IsAnimationPlaying(self.In_Purple) or
    self:IsAnimationPlaying(self.In_Blue) or 
    self:IsAnimationPlaying(self.Convert) then
        return true
    end
    return false
end

function M:OnAnimationFinished(InAnim)
    if InAnim == self.In_Red or InAnim == self.In_Yellow or InAnim == self.In_Purple or InAnim == self.In_Blue then
        if self.DelayTime then
            self:AddTimer(self.DelayTime, function()
                self:PlayConvertAnim()
            end)
        end
    elseif InAnim == self.Convert then
        self.Panel_Change:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        if self:HasAnyUserFocus() or self:HasFocusedDescendants() then
            self.ItemIcon:SetFocus()
        end
    end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if self.bConvert then
        self.ItemIcon:SetFocus()
    end
    return UWidgetBlueprintLibrary.Handled()
end

return M
