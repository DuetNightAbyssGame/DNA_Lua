--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
local UIUtils = require "Utils.UIUtils"
require "UnLua"
local CommonUtils = require "Utils.CommonUtils"

---@class WBP_GetRewardTips_C : Battle_Combat_Pickup_C
local M = Class({
    "BluePrints.Common.TimerMgr",
    "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
    self.Overridden.Construct(self)
    self:SetVisibility(ESlateVisibility.Collapsed)
    self.DropIgnoreMap = {
        ["GetResource"] = 1,
        ["GetWeapon"] = 1,
        ["GetMod"] = 1
    }

    self.UsingItemList = {}
    self.WaitingList = {}


    if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "PC" then
        self.VerticalBox_Bottom:RemoveChildAt(3)
        self.VerticalBox_Bottom:RemoveChildAt(2)
    end
end

function M:Destruct()
    self:StopAllAnimations()
    self:CleanTimer()
end

function M:OnUpdateTips(ItemId, ItemCount, TableName)
    self:SetVisibility(ESlateVisibility.Visible)
    if not self:AddValidTipsItem(ItemId, ItemCount, TableName) then
        if not self.WaitingList[TableName] then
            self.WaitingList[TableName] = {}
        end
        table.insert(self.WaitingList[TableName], { ItemId, ItemCount })
    end
-- local TipsItem, bChangeBackground = self:GetValidTips(ItemId, TableName)
    -- if not TipsItem then
    --     if not self.WaitingList[TableName] then
    --         self.WaitingList[TableName] = {}
    --     end
    --     table.insert(self.WaitingList[TableName], { ItemId, ItemCount })
    -- else    
    --     TipsItem:UpdateTips(ItemId, ItemCount, nil, TableName, bChangeBackground)
    --     self.UsingItemList[TipsItem] = 1
    -- end

end

---@return WBP_Special_Reward_C
function M:AddValidTipsItem(ItemId, ItemCount, TableName)
    local ItemData = DataMgr[TableName][ItemId]
    if not ItemData then
        return nil
    end

    local UIType
    if TableName == "Resource" or TableName == "Mod" then
        if ItemData.Type == "Ordinary" then
            UIType = "Ordinary"
        end
    else
        UIType = TableName
    end
    if not UIType then
        return false
    end
    if UIType == "Drop" or UIType == "Ordinary" then
        if not self.DropIgnoreMap[ItemData.UseEffectType] then

            ---@type WBP_Special_Reward_C
            local TipsItem = nil
            for i = 0, self.VerticalBox_Bottom:GetChildrenCount() - 1 do
                ---@type WBP_Special_Reward_C
                local ChildItem = self.VerticalBox_Bottom:GetChildAt(i)
                if ChildItem.ItemId == ItemId then
                    if ChildItem:IsAnimationPlaying(ChildItem.out) then
                        return false
                    end
                    ChildItem:AddItemCount(ItemCount)
                    return true
                end
            end
            for i = 0, self.VerticalBox_Bottom:GetChildrenCount() - 1 do
                if self.VerticalBox_Bottom:GetChildAt(i):IsTipsCanUse() then
                    TipsItem = self.VerticalBox_Bottom:GetChildAt(i)
                    break
                end
            end
            if not TipsItem then
                return false
            end
            TipsItem:RemoveFromParent()
            -- local OtherItems = {}
            -- for i = 0, self.VerticalBox_Bottom:GetChildrenCount() - 1 do
            --     table.insert(OtherItems, self.VerticalBox_Bottom:GetChildAt(i))
            -- end
            -- for i = 1, #OtherItems do
            --     OtherItems[i]:RemoveFromParent()
            -- end
            self.UsingItemList[TipsItem] = 1
            local Slot = self.VerticalBox_Bottom:AddChildToVerticalBox(TipsItem)
            TipsItem:UpdateTips(ItemId, ItemCount, nil, TableName)
            Slot:SetPadding(FMargin(0))

            return true
        elseif CommonUtils.TableLength(self.UsingItemList) == 0 then
            self:SetVisibility(ESlateVisibility.Collapsed)
        end
    end

    return false
end

function M:AddTopItem(ItemId, ItemCount, TableName)
    local ItemData = DataMgr[TableName][ItemId]
    if not ItemData then
        return nil
    end
    if self.VerticalBox_Top:GetChildrenCount() >= 3 then
        return false
    end

    local TipsItem = nil
    local bChangeBackground = false
    local Padding = UE4.FMargin(0, 0, 0, 0)
    if TableName == "Resource" then
        if ItemData.Type == "Rare" then
            TipsItem = self:LoadTipsItem(self.RareResourceRewardClass)
            bChangeBackground = true
        else
            TipsItem = self:LoadTipsItem(self.ResourceRewardClass)
        end
    elseif TableName == "Mod" then
        TipsItem = self:LoadTipsItem(self.ModRewardClass)
        bChangeBackground = true
        Padding.Left = 200
    end
    if not TipsItem then
        return nil
    end

    -- while self.VerticalBox_Top:GetChildrenCount() >= 3 do
    --     self.VerticalBox_Top:RemoveChildAt(1)
    -- end
    self.UsingItemList[TipsItem] = 1
    local Slot = self.VerticalBox_Top:AddChildToVerticalBox(TipsItem)
    Slot:SetPadding(Padding)
    TipsItem:UpdateTips(ItemId, ItemCount, nil, TableName, bChangeBackground)

    return true
end

---@return WBP_Special_Reward_C
function M:LoadTipsItem(UIClass)
    return UE4.UWidgetBlueprintLibrary.Create(self, UIClass)
end

-- function M:Tick(MyGeometry, InDeltaTime)
--     self.Overridden.Tick(self, MyGeometry, InDeltaTime)

--     -- for TableName, TipsInfoList in pairs(self.WaitingList) do
--     --     repeat 
--     --         if #TipsInfoList == 0 then
--     --             break
--     --         end
--     --         local TipsInfo = TipsInfoList[1]
--     --         if self:AddValidTipsItem(TipsInfo[1], TipsInfo[2], TableName) then
--     --             table.remove(TipsInfoList, 1)
--     --         end
--     --         -- local TipsItem, bChangeBackground = self:GetValidTips(TipsInfo[1], TableName)
--     --         -- if TipsItem then
--     --         --     TipsItem:UpdateTips(TipsInfo[1], TipsInfo[2], nil, TableName, bChangeBackground)
--     --         --     self.UsingItemList[TipsItem] = 1
           
--     --         -- end
--     --     until true
--     -- end
-- end

function M:OnTipsItemClose(InItem)
    if not InItem then
        return
    end
    self.UsingItemList[InItem] = nil
    UIUtils.ShowTopTips()
    for TableName, TipsInfoList in pairs(self.WaitingList) do
        repeat 
            if #TipsInfoList == 0 then
                break
            end
            local TipsInfo = TipsInfoList[1]
            if self:AddValidTipsItem(TipsInfo[1], TipsInfo[2], TableName) then
                table.remove(TipsInfoList, 1)
            end
        until true
    end
    if CommonUtils.TableLength(self.UsingItemList) == 0 then
        self:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:TryPlayOutAnimation()
    local OriItemCount = 0
    for i = 0, self.VerticalBox_Bottom:GetChildrenCount() - 1 do
        if self.VerticalBox_Bottom:GetChildAt(i).ItemId ~= nil then
            OriItemCount = OriItemCount + 1
            if OriItemCount > 1 then
                return
            end 
        end
    end
    --self:PlayAnimation(self.out, 0, 1, 0, 1, true)
end

function M:SpecialRewardIsCanUse()
    return self.WBP_Special_Reward:IsTipsCanUse()
end

return M
