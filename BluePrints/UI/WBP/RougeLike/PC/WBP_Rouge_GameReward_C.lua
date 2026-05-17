--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Rouge_GameReward_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.EMScrollBox_138:SetControlScrollbarInside(false)
    self.Text_Target:SetText(GText("RougeMiniGamePointsReach"))
    --self.Text_Empty:SetText(GText("未达成（待配表）"))
end

function M:InitScoreInfo(Score)
    self.Text_Score:SetText(Score)
end

function M:SetIsEmpty(IsEmpty)
    self.IsEmpty = IsEmpty
end

function M:PlayInAnim()
    self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    if self.IsEmpty then
        self:PlayAnimation(self.Fail)
    else
        self:PlayAnimation(self.Get)
    end
end

function M:InitReward(EventId, CurIndex, Index, Rewards)
    if Index == 1 then
        local TokenAward = DataMgr.RougeLikeEventSelect[EventId].TokenAward
        if TokenAward and TokenAward[Index] and TokenAward[Index] > 0 then
            local TokenItem = self:CreateWidgetNew("RougeGameCurrency")
            local TokenId = nil
            local IconPath = nil
            local Avatar = GWorld:GetAvatar()
	        if Avatar and Avatar.RougeLike then
                local SeasonId = Avatar.RougeLike.ProgressingSeasonId
                if SeasonId and DataMgr.RougeLikeSeason[SeasonId] then
                    TokenId = DataMgr.RougeLikeSeason[SeasonId].TokenId
                end
            end
            if TokenId and DataMgr.Resource[TokenId] then
                IconPath = DataMgr.Resource[TokenId].Icon
            end
            TokenItem:InitInfo(IconPath , TokenAward[Index])
            self.WrapBox_Reward:AddChild(TokenItem)
        end
    elseif Index == 2 then
        if CurIndex >= Index then
            self:AddBlessing(Rewards)
        else
            self:AddBlessing_NotGot()
        end
    elseif Index == 3 then
        if CurIndex >= Index then
            self:AddTreasure(Rewards)
        else
            self:AddTreasure_NotGot()
        end
    end
end

function M:AddBlessing(Rewards)
    for k,Info in pairs(Rewards) do
        if Info.BlessingId then
            local BlessingData = self:GetBlessingData(Info.BlessingId)
            local BlessingItem = self:CreateWidgetNew("RougeSettlementBlessItem")
            BlessingItem:InitInfo(BlessingData)
            self.WrapBox_Reward:AddChild(BlessingItem)
            local Callback = function(bIsOpen)
                self.IsShowTips = bIsOpen
            end
            BlessingItem.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Add(self, Callback)
        end
    end
end

function M:AddBlessing_NotGot()
    local BlessingItem = self:CreateWidgetNew("RougeSettlementBlessItem")
    BlessingItem:SetDefault()
    self.WrapBox_Reward:AddChild(BlessingItem)
    local Callback = function(bIsOpen)
        self.IsShowTips = bIsOpen
    end
    BlessingItem.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Add(self, Callback)
end

function M:AddTreasure(Rewards)
    for k,Info in pairs(Rewards) do
        if Info.TreasureId then
            local TreasureData = self:GetTreasueData(Info.TreasureId)
            local TreasureItem = self:CreateWidgetNew("RougeSettlementTreasureItem")
            TreasureItem:InitInfo(TreasureData)
            self.WrapBox_Reward:AddChild(TreasureItem)
            local Callback = function(bIsOpen)
                self.IsShowTips = bIsOpen
            end
            TreasureItem.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Add(self, Callback)
        end
    end
end

function M:AddTreasure_NotGot()
    local TreasureItem = self:CreateWidgetNew("RougeSettlementTreasureItem")
    TreasureItem:SetDefault()
    self.WrapBox_Reward:AddChild(TreasureItem)
    local Callback = function(bIsOpen)
        self.IsShowTips = bIsOpen
    end
    TreasureItem.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Add(self, Callback)
end

function M:GetBlessingData(BlessingId)
    local BlessingData = {}
    local BlessingInfo = DataMgr.RougeLikeBlessing[BlessingId]
    if not BlessingInfo then
        DebugPrint("RougeSettlement: Error! 找不到对应Blessing表里的数据，BlessingId:", BlessingId)
        return BlessingData
    end

    for k,v in pairs(BlessingInfo) do
        BlessingData[k] = v
    end
    BlessingData.ItemType = "Blessing"
    return BlessingData
end

function M:GetTreasueData(TreasureId)
    local TreasureData = {}
    local TreasureInfo = DataMgr.RougeLikeTreasure[TreasureId]
    if not TreasureInfo then
        DebugPrint("RougeSettlement: Error! 找不到对应Treasue表里的数据，TreasureId:", TreasureId)
        return TreasureInfo
    end
    for k,v in pairs(TreasureInfo) do
        TreasureData[k] = v
    end
    TreasureData.ItemType = "Treasure"
    return TreasureData
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

return M
