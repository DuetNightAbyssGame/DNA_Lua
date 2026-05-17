---@type WBP_LimitedPrizePool_Reward_Base_C
local M = Class({ "BluePrints.UI.BP_UIState_C" })

function M:Construct()
    M.Super.Construct(self)
    self.List = self.List_Item
    self.NormalInAnimation = self.Normal_In
    self.SpecialInAnimation = self.Special_In
    self.CloseOutAnimation = self.Out
    self.CloseCallback = nil
    self.bClosing = false
    if self.CloseOutAnimation then
        self:UnbindAllFromAnimationFinished(self.CloseOutAnimation)
        self:BindToAnimationFinished(self.CloseOutAnimation, { self, self.OnCloseFinished })
    end
    self.Text_GetItem:SetText(GText("UI_COMMONPOP_TITLE_100017"))
    self.Text_Tip:SetText(GText("UI_Armory_ClickEmpty"))
    self.Text_Tips:SetText(GText("UI_LimitedPrizePool_GetAllResult"))
    self.Btn_Close.OnClicked:Add(self, self.OnClose)
end

function M:Destruct()
    self.Btn_Close.OnClicked:Remove(self, self.OnClose)
    M.Super.Destruct(self)
end

function M:OnLoaded(...)
    M.Super.OnLoaded(self, ...)
    local ItemList, DrawCount, bIsBigPrize, CloseCallback, ConvertFlags = ...
    self.ConvertFlags = ConvertFlags
    self:PopulateList(ItemList)
    self.CloseCallback = CloseCallback
    self.bClosing = false
    self:InitRewardText(DrawCount, bIsBigPrize)
    self:StopAllAnimations()
    if bIsBigPrize then
        self:PlayAnimation(self.SpecialInAnimation)
    else
        self:PlayAnimation(self.NormalInAnimation)
    end
end

function M:InitRewardText(DrawCount, bIsBigPrize)
    local DrawCount = DrawCount or 0
    self.Panel_Title:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Text_Tips:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if not bIsBigPrize or not self.Text_Title then
        return
    end
    if DrawCount <= 3 then
        self.Panel_Title:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Text_Title:SetText(string.format(GText("UI_LimitedPrizePool_BestLuck"), DrawCount))
        self.Text_Tips:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    elseif DrawCount <= 5 then
        self.Panel_Title:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Text_Title:SetText(string.format(GText("UI_LimitedPrizePool_GoodLuck"), DrawCount))
        self.Text_Tips:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
end

function M:IsRewardConverted(ItemData)
    if not ItemData then
        return false
    end
    local Idx = ItemData[1]
    if self.ConvertFlags then
        if Idx and self.ConvertFlags[Idx] ~= nil then
            return self.ConvertFlags[Idx]
        end
    end
    return false
end

function M:ApplyRewardConvertContent(Content, bConvert)
    if not bConvert or not Content then
        return
    end
    Content.bConvert = true
    Content.bDisableCommonClick = true
    Content.IsShowDetails = false
    Content.NotInteractive = true
end

function M:PopulateList(ItemList)
    local DataList = ItemList or {}
    if not self.List then
        return
    end
    self.List:ClearListItems()
    for i, ItemData in ipairs(DataList) do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.Id = ItemData[3]
        Content.ItemType = ItemUtils.GetItemType(ItemData[2])
        Content.Icon = ItemUtils.GetItemIconPath(Content.Id, Content.ItemType)
        Content.Rarity = ItemUtils.GetItemRarity(Content.Id, Content.ItemType)
        Content.Count = ItemData[4]
        Content.UIName = self:GetUIConfigName()
        local bConvert = self:IsRewardConverted(ItemData)
        Content.IsShowDetails = not bConvert
        self:ApplyRewardConvertContent(Content, bConvert)
        if self.OnMenuOpenChange then
            Content.OnMenuOpenChangedEvents = { Obj = self, Callback = self.OnMenuOpenChange }
        end
        self.List:AddItem(Content)
    end
end

function M:OnClose()
    if self.bClosing then
        return
    end
    self.bClosing = true
    if self.CloseOutAnimation then
        self:PlayAnimation(self.CloseOutAnimation)
    else
        self:OnCloseFinished()
    end
end

function M:OnCloseFinished()
    self:UnbindAllFromAnimationFinished(self.CloseOutAnimation)
    if type(self.CloseCallback) == "function" then
        self.CloseCallback()
    elseif self.CloseCallback and self.CloseCallback[1] and self.CloseCallback[2] then
        self.CloseCallback[2](self.CloseCallback[1])
    end
    self:Close()
end

return M
