--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local UIUtils = require "Utils.UIUtils"

---@type WBP_Map_DialogDispatchRewardItem_C
local M = Class({"BluePrints.UI.BP_UIState_C"})
local DispatchLevelEnum = {
    Perfect = 0,
    BigSuccess = 1,
    Success = 2,
    Fail = 3,
}

--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end
function M:OnListItemObjectSet(Content)
    Content.UI = self
    self.Index = Content.Index
    self.Owner = Content.Owner
    if Content.Level == DispatchLevelEnum.Perfect then
        local Path = LoadObject('/Game/UI/Texture/Dynamic/Atlas/Map/T_Map_Rank_SS.T_Map_Rank_SS')
        self.Icon_Rank:SetBrushResourceObject(Path)
        self.Text_Status:SetText(GText("UI_Disptach_Perfect"))
    elseif Content.Level == DispatchLevelEnum.BigSuccess then
        local Path = LoadObject('/Game/UI/Texture/Dynamic/Atlas/Map/T_Map_Rank_S.T_Map_Rank_S')
        self.Icon_Rank:SetBrushResourceObject(Path)
        self.Text_Status:SetText(GText("UI_Disptach_BigSuccess"))
    elseif Content.Level == DispatchLevelEnum.Success then
        local Path = LoadObject('/Game/UI/Texture/Dynamic/Atlas/Map/T_Map_Rank_A.T_Map_Rank_A')
        self.Icon_Rank:SetBrushResourceObject(Path)
        self.Text_Status:SetText(GText("UI_Disptach_Success"))
    else
        local Path = LoadObject('/Game/UI/Texture/Dynamic/Atlas/Map/T_Map_Rank_B.T_Map_Rank_B')
        self.Icon_Rank:SetBrushResourceObject(Path)
        self.Text_Status:SetText(GText("UI_Disptach_Fail"))
    end

    self:SetRewardList(Content.RewardId)
end



function M:SetRewardList(RewardId)
    if RewardId == nil then
        return
    end
    local RewardInfo = DataMgr.Reward[RewardId]
    local Id = RewardInfo.Id[1]
    local FinalReward = DataMgr.Reward[Id]
    if FinalReward.Name then
        self.WS_Type:SetActiveWidgetIndex(0)
        self.List_Reward:ClearListItems()
        local Icon = LoadObject(FinalReward.Icon)
        self.Icon_Package:SetBrushResourceObject(Icon)
        self.Text_Name:SetText(GText(FinalReward.Name))
        --self.Text_Percent:SetText(GText(RewardInfo.Name))
        self.Text_Describe:SetText(GText("UI_Dispatch_OpenPackObtain"))
        for key, value in pairs(FinalReward.Id) do
            local ItemId = value
            local Rate = FinalReward.Param[key]
            local Count = FinalReward.Count[key][1]
            local Icon = ItemUtils.GetItemIconPath(value, FinalReward.Type[key])
            local Rarity = ItemUtils.GetItemRarity(value, FinalReward.Type[key])
            local ItemType = FinalReward.Type[key]
            local RewardContent = NewObject(UIUtils.GetCommonItemContentClass())
            RewardContent.Id = value
            RewardContent.Count = Count
            RewardContent.Icon= Icon
            RewardContent.Rarity = Rarity
            RewardContent.ItemType = ItemType
            RewardContent.IsShowDetails = true
            RewardContent.BonusType = 1
            RewardContent.ExtraBonusText = math.floor((Rate / 10000) * 100).."%"
            RewardContent.AfterInitCallback = function(Widget)
                Widget:BindEvents(self,{
                    OnMenuOpenChanged = self.OnRewardMenuOpenChanged
                })
            end  
            self.List_Reward:AddItem(RewardContent)
        end
    else
        self.WS_Type:SetActiveWidgetIndex(1)
        self.List_Reward_02:ClearListItems()
        if RewardInfo then
            local Ids = RewardInfo.Id or {}
            local RewardCount = RewardInfo.Count or {}
            local TableName = RewardInfo.Type or {}
            for i = 1, #Ids do
                local ItemId = Ids[i]
                local Count = RewardUtils:GetCount(RewardCount[i])
                local Icon = ItemUtils.GetItemIconPath(ItemId, TableName[i])
                local Rarity = ItemUtils.GetItemRarity(ItemId, TableName[i])
                local ItemType = TableName[i]
                local RewardContent = NewObject(UIUtils.GetCommonItemContentClass())
                RewardContent.Id = ItemId
                RewardContent.Count = Count
                RewardContent.Icon= Icon
                RewardContent.Rarity = Rarity
                RewardContent.ItemType = ItemType
                RewardContent.IsShowDetails = true
                RewardContent.AfterInitCallback = function(Widget)
                    Widget:BindEvents(self,{
                        OnMenuOpenChanged = self.OnRewardMenuOpenChanged
                    })
                end  
                self.List_Reward_02:AddItem(RewardContent)
            end
        end
    end
    
    self:AddTimer(0.01, function()

        -- local ListItemUIs = self.List_Reward:GetDisplayedEntryWidgets()
        -- local CurCount = ListItemUIs:Length()
        -- local Count = UIUtils.GetTileViewContentMaxCount(self.List_Reward)
        -- if CurCount <= Count then
        --     self.List_Reward:DisableScroll(true)
        -- else
        --     self.List_Reward:DisableScroll(false)
        -- end
        -- self.List_Reward:SetEmptyGridItemCount(0)
        -- self.List_Reward:SetFocus()
        -- self.List_Reward:NavigateToIndex(0)
    end)
     
end

function M:OnRewardMenuOpenChanged(bIsOpen)
    if self.Owner == nil then
        return
    end
    if bIsOpen then
        self.Owner:HideAllGamepadShortcut()
    else
        self.Owner:ShowGamepadShortcut(4)
        self.Owner:ShowGamepadShortcut(5)
    end

end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    --self.List_Reward:SetFocus()
    local Focus = nil
    if self.WS_Type:GetActiveWidgetIndex() == 0 then
        Focus = self.List_Reward
        self.List_Reward:NavigateToIndex(0)
    else
        Focus = self.List_Reward_02
        self.List_Reward_02:NavigateToIndex(0)
    end  
    --self.List_Reward:NavigateToIndex(0)
    --return UE4.UWidgetBlueprintLibrary.Unhandled()
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),Focus)
end

-- function M:OnFocusReceived(MyGeometry, InFocusEvent)
--     return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self.List_Reward)
-- end

return M
