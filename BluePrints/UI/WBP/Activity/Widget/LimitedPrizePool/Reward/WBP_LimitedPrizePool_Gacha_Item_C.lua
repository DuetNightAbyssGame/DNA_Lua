require "UnLua"

---@type WBP_Gacha_Item_C
local M = Class({"BluePrints.UI.UI_PC.Common.Common_Item.WBP_Com_Item_Base_C"})

function M:OnListItemObjectSet(Content)
    self:InitData(Content)
    self.DelayTime = Content.DelayTime or 0

    self.Panel_Change:SetVisibility(ESlateVisibility.Collapsed)
    self.Text_ItemNum:SetText(Content.Count)
    self.bConvert = Content.bConvert
    self:StopAnimation(self.Convert)
    self:AddTimer(self.DelayTime, function()
        self:PlayConvertAnim()
    end, nil, nil, nil, true)
    M.Super.OnListItemObjectSet(self, Content)
end

function M:PlayConvertAnim()
    if self.bConvert then
        local ItemData = DataMgr[self.Content.ItemType][self.Content.Id]
        assert(ItemData, "抽卡结果道具不存在")
        if ItemData.RegainItemId then
            local ResourceData = DataMgr.Resource[ItemData.RegainItemId]
            self.ItemIcon:Init(
                {
                    Id = ItemData.RegainItemId,
                    Icon = LoadObject(ResourceData and ResourceData.Icon),
                    ItemType = "Resource",
                    UIName = self.UIName or "LimitedPrizePoolReward",
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

function M:IsInAnimationPlaying()
    if self:IsAnimationPlaying(self.Convert) then
        return true
    end
    return false
end

function M:OnAnimationFinished(InAnim)
    if InAnim == self.Convert then
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
