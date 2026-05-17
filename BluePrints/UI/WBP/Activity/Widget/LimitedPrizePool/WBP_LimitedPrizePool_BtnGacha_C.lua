---@type WBP_LimitedPrizePool_BtnGacha_C
local M = Class({ "BluePrints.UI.BP_EMUserWidget_C" })

local IsNoMorePrompts = false

function M:Construct()
    self.CostIcon = self.Icon_Cost
    self.CostCountText = self.Text_Cost
    self.PrizeText = self.Text_Button
    self.PrizeGamePadKey = self.Key_GamePad
    self.PrizeButton = self.Button_Area

    self.PrizeText:SetText(GText("UI_LimitedPrizePool_Once"))

    self.EventId = nil
    self.CostResourceId = nil
    self.CostCount = nil
    self.OnForbiddenPrizeDraw = nil

    self.PrizeButton.OnClicked:Add(self, self.PrizeDraw)

    self:SetInputType(UIUtils.UtilsGetCurrentInputType(), UIUtils.UtilsGetCurrentGamepadName())
    self:ListenInputTypeChanged()
end

function M:Destruct()
    self.PrizeButton.OnClicked:Remove(self, self.PrizeDraw)
end

function M:ListenInputTypeChanged()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local GameInputModeSubsystem = UE4.UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(GameInputModeSubsystem)) then
        GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.SetInputType)
    end
end

function M:UnlistenInputTypeChanged()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local GameInputModeSubsystem = UE4.UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(GameInputModeSubsystem)) then
        GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.SetInputType)
    end
end

function M:SetInputType(NewInputType, NewGamepadName)
    if (NewInputType == ECommonInputType.Touch) then
        return
    end
    if NewInputType == ECommonInputType.Gamepad then
        self.PrizeGamePadKey:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.PrizeGamePadKey:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

-- { self, self.Function }
function M:BindForbiddenPrizeDraw(OnForbiddenPrizeDraw)
    self.OnForbiddenPrizeDraw = OnForbiddenPrizeDraw
end

function M:UnbindForbiddenPrizeDraw()
    self.OnForbiddenPrizeDraw = nil
end

function M:BindUpdateReward(OnNeedUpdateReward)
    self.OnNeedUpdateReward = OnNeedUpdateReward
end

function M:UnbindUpdateReward()
    self.OnNeedUpdateReward = nil
end

function M:SetGamePadVisibility(Op)
    self.PrizeGamePadKey:SetVisibility(Op)
end

function M:SetGamePadImg(ImgShortPath, ImgLongPath)
    self.PrizeGamePadKey:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = ImgShortPath,
                ImgLongPath = ImgLongPath,
            }
        },
    })
end

function M:SetEventId(EventId)
    self.EventId = EventId
end

function M:SetCost(CostRuleId, Round, NextDrawCount)
    local CostRuleData = DataMgr.LimitedPrizeCostRule[CostRuleId]
    if (not CostRuleData) then
        return
    end

    self.CostResourceId = CostRuleData.CostResourceId

    local CostIcon = ItemUtils.GetItemIcon(CostRuleData.CostResourceId, "Resource")
    self.CostIcon:SetBrushResourceObject(CostIcon)

    self.CostCount = CostRuleData.CostResCount[NextDrawCount] or 0
    self.CostCountText:SetText(tostring(self.CostCount))
end

function M:SetForbidden(bForbidden)
    self.PrizeButton:SetForbidden(bForbidden)
end

function M:PrizeDraw()
    if self.CantClick then
        return
    end
    if (self.PrizeButton:GetForbidden()) then
        if (self.OnForbiddenPrizeDraw and self.OnForbiddenPrizeDraw[1] and self.OnForbiddenPrizeDraw[2]) then
            self.OnForbiddenPrizeDraw[2](self.OnForbiddenPrizeDraw[1])
        end
        return
    end

    local Avatar = GWorld:GetAvatar()
    if (not Avatar) then
        return
    end

    local ResourceCount = Avatar:GetResourceNum(self.CostResourceId)
    if (ResourceCount < self.CostCount) then
        self:BuyResource(self.CostResourceId, self.CostCount - ResourceCount, { self, function(_, bSuccess)
            if (bSuccess) then
                self:PrizeDraw()
            end
        end })
        return
    end

    if self:CheckNeedShowConfirmPopup() then
        self:ShowPrizeDrawConfirmPopup()
    else
        self:RealPrizeDraw()
    end
end

function M:BuyResource(Id, Count, OnBought)
    local OnBoughtFunc = function(bSuccess)
        if (OnBought and OnBought[1] and OnBought[2]) then
            OnBought[2](OnBought[1], bSuccess)
        end
    end

    local Avatar = GWorld:GetAvatar()
    if (not Avatar) then
        OnBoughtFunc(false)
        return
    end

    local _, ShopItemData = ShopUtils:GetShopItemDataById(Id, CommonConst.DataType.Resource)
    if (not ShopItemData) then
        OnBoughtFunc(false)
        return
    end

    local NeedShopCount = math.ceil(Count / ShopItemData.TypeNum)
    local NeedCoinCount = NeedShopCount * ShopItemData.Price
    local CoinId = ShopItemData.PriceType

    local HasCoinCount = Avatar:GetResourceNum(CoinId)
    if (HasCoinCount < NeedCoinCount) then
        if CoinId == CommonConst.Coins.Coin1 then
            local Coin4 = CommonConst.Coins.Coin4
            local Coin4OwnedCount = Avatar:GetResourceNum(Coin4)
            local Coin1NeededCount = NeedCoinCount - HasCoinCount
            if Coin4OwnedCount >= Coin1NeededCount then
                local Confirm = function()
                    self.CantClick = true
                    local OnPurchaseShopItemUseCoin1 = function(Ret)
                        self.CantClick = false
                        if ErrorCode:Check(Ret) then
                            OnBoughtFunc(true)
                        else
                            OnBoughtFunc(false)
                        end
                    end
                    Avatar:PurchaseShopItemUseCoin1(ShopItemData.ItemId,NeedShopCount,OnPurchaseShopItemUseCoin1)
                end
                local ItemList = {}
                table.insert(ItemList,{ItemId = Coin4,
                    ItemType = CommonConst.ItemType.Resource,
                    ItemNum = Coin4OwnedCount,
                    ItemNeed = Coin1NeededCount})
                local PopUpId =  100337
                local PopoverText = string.format(GText(DataMgr.CommonPopupUIContext[PopUpId].PopoverText), Coin1NeededCount, Coin1NeededCount)
                local Params = {
                    RightCallbackFunction = Confirm,
                    ItemList = ItemList,
                    ShortText = PopoverText
                }
                UIManager(self):ShowCommonPopupUI(PopUpId,Params)
                return
            end
            local Params = {}
            Params.CostType = CoinId
            Params.CostNum = NeedCoinCount
            UIManager(self):LoadUINew("ShopTargetPay", Params)
        end
    else
        local Confirm = function()
            self.CantClick = true
            self.IsPurchaseForGacha = true
            Avatar:PurchaseShopItem(ShopItemData.ItemId,NeedShopCount,true,function(Ret)
                self.CantClick = false
                if ErrorCode:Check(Ret) then
                    OnBoughtFunc(true)
                else
                    OnBoughtFunc(false)
                end
            end)
        end
        local LeftItems = {}
        table.insert(LeftItems,{ItemId = CoinId,
            ItemType = CommonConst.ItemType.Resource,
            Count = NeedCoinCount})
        local RightItems = {}
        table.insert(RightItems,{ItemId = Id,
            ItemType = CommonConst.ItemType.Resource,
            Count = NeedShopCount})
        local PopUpId =  100336
        local PopoverText = string.format(GText(DataMgr.CommonPopupUIContext[PopUpId].PopoverText), NeedCoinCount, NeedShopCount)
        local Params = {
            RightCallbackFunction = Confirm,
            LeftItems = LeftItems,
            RightItems = RightItems,
            ShortText = PopoverText
        }
        UIManager(self):ShowCommonPopupUI(PopUpId,Params)
    end
end

function M:CheckNeedShowConfirmPopup()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return not IsNoMorePrompts
    end
    local IsFirst = true
    local LimitPrizeData = Avatar.LimitPrize[self.EventId]
    if LimitPrizeData then
        IsFirst = LimitPrizeData.DrawCounts <= 0
    end
    return IsFirst and not IsNoMorePrompts
end

function M:UpdateSelectedInfo(Data)
    IsNoMorePrompts = Data.SelectHint.IsSelected
end

function M:ShowPrizeDrawConfirmPopup()
    local CommonDialogParams = {}
    CommonDialogParams.RightCallbackFunction = function(_, Data, PopupUI)
        self:UpdateSelectedInfo(Data)
        self:RealPrizeDraw()
    end
    UIManager(self):ShowCommonPopupUI(100338, CommonDialogParams, self)
end

function M:RealPrizeDraw()
    local RewardPool = self:BuildRoundRewardPool()
    self.RewardPoolForShow = RewardPool
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local CurrentRound = self:GetCurrentRound()
    local CallbackFunction = function (Ret, ...)
        if not ErrorCode:Check(Ret) then
            return
        end
        local ReturnCost, PrizeResult = ...
        self:ShowReward(PrizeResult, function()
            local CurrentRoundAfterDraw = self:GetCurrentRound()
            local RoundNum = 0
            local PoolData = DataMgr.LimitedPrizePool[self.EventId]
            if PoolData then
                RoundNum = #(PoolData.LimitedPrizePoolId or {})
            end
            if self.bIsBigPrize and CurrentRound ~= RoundNum then
                local RoundSwitch = UIManager(GWorld.GameInstance):_CreateWidgetNew("LimitedPoolRoundSwitch")
                RoundSwitch:AddToViewport(UIConst.ZORDER_ABOVE_SystemGuide)
                RoundSwitch:Init(CurrentRoundAfterDraw, RoundNum, {
                    RoundSwitch, function()
                        self:UpdateReward()
                        Avatar:RefreshLimitedPrizeRewardSelectReddot()
                    end
                })
            else
                self:UpdateReward()
                Avatar:RefreshLimitedPrizeRewardSelectReddot()
            end
            self.bIsBigPrize = nil
        end)
    end
    Avatar:DrawLimitPrizeForSingle(CallbackFunction, self.EventId)
end

function M:UpdateReward(PrizeResult)
    if (self.OnNeedUpdateReward and self.OnNeedUpdateReward[1] and self.OnNeedUpdateReward[2]) then
        self.OnNeedUpdateReward[2](self.OnNeedUpdateReward[1], PrizeResult)
    end
end

function M:ShowReward(PrizeResult, Callback)
    if not PrizeResult or #PrizeResult == 0 then
        return
    end
    local RewardPool = self.RewardPoolForShow or self:BuildRoundRewardPool()
    local ConvertFlags = self:BuildConvertFlags(PrizeResult)
    local WonPrizeIdx = PrizeResult[1] and PrizeResult[1][1] or 1
    local WonIndex = self.RewardPoolDisplayIndexMap and self.RewardPoolDisplayIndexMap[WonPrizeIdx] or nil
    local bIsBigPrize = false
    for _, ItemData in ipairs(PrizeResult) do
        if ItemData[1] == 1 then
            bIsBigPrize = true
            break
        end
    end
    self.bIsBigPrize = bIsBigPrize
    local DrawCount = self:GetCurrentRoundDrawCount()
    if not WonIndex then
        DebugPrint("WBP_LimitedPrizePool_BtnGacha_C:ShowReward, WonIndex is nil")
        return
    end
    local Widget = UIManager(GWorld.GameInstance):_CreateWidgetNew("LimitedPrizePoolGacha")
    if not IsValid(Widget) then
        return
    end
    local Parent = self.OnNeedUpdateReward and self.OnNeedUpdateReward[1]
    local ZOrder = Parent and Parent.GetZOrder and Parent:GetZOrder()
    Widget:AddToViewport(ZOrder or UIConst.ZORDER_ABOVE_SystemGuide)
    Widget:Init(RewardPool, WonIndex, bIsBigPrize, PrizeResult, DrawCount, ConvertFlags, Callback)
end

function M:GetCurrentRoundDrawCount()
    local Avatar = GWorld:GetAvatar()
    if not Avatar or not self.EventId then
        return 1
    end
    local LimitPrizeData = Avatar.LimitPrize and Avatar.LimitPrize[self.EventId]
    if not LimitPrizeData then
        return 1
    end
    return math.max(LimitPrizeData.DrawCounts or 1, 1)
end

function M:BuildRoundRewardPool()
    local Data = {}
    self.RewardPoolDisplayIndexMap = {}
    if not self.EventId then
        return Data
    end
    local PoolData = DataMgr.LimitedPrizePool[self.EventId]
    if not PoolData then
        return Data
    end
    local Avatar = GWorld:GetAvatar()
    local LimitPrizeData = Avatar and Avatar.LimitPrize and Avatar.LimitPrize[self.EventId] or nil
    local CurrentRound = 1
    if LimitPrizeData then
        local Round = LimitPrizeData.Round
        if Round > #PoolData.LimitedPrizePoolId then
            Round = #PoolData.LimitedPrizePoolId
        end
        CurrentRound = Round
    end
    local RoundId = PoolData.LimitedPrizePoolId[CurrentRound]
    local RoundData = DataMgr.LimitedPrizeItem[RoundId]
    if not RoundData then
        return Data
    end
    local DrawnPrizeMap = {}
    if LimitPrizeData and LimitPrizeData.HasDrawPrizes then
        for _, DrawnIdx in pairs(LimitPrizeData.HasDrawPrizes) do
            DrawnPrizeMap[DrawnIdx] = true
        end
    end
    for idx, Ids in ipairs(RoundData.Id) do
        local SelectedIndex = 1
        if LimitPrizeData and LimitPrizeData.SelfSelect and LimitPrizeData.SelfSelect[idx] then
            SelectedIndex = LimitPrizeData.SelfSelect[idx]
        end
        if not DrawnPrizeMap[idx] then
            local DisplayIndex = #Data + 1
            self.RewardPoolDisplayIndexMap[idx] = DisplayIndex
            Data[DisplayIndex] = {
                Type = ItemUtils.GetItemType(RoundData.Type[idx]),
                Ids = Ids,
                Id = Ids[SelectedIndex] or Ids[1],
                Number = idx,
                Count = RoundData.Count[idx],
                Probability = RoundData.Probability[idx],
            }
        end
    end
    return Data
end

function M:BuildConvertFlags(PrizeResult)
    local ConvertFlags = {}
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return ConvertFlags
    end
    local RewardMap = {}
    for _, ItemData in ipairs(PrizeResult or {}) do
        local ItemType = ItemUtils.GetItemType(ItemData[2])
        local Id = ItemData[3]
        local Count = ItemData[4] or 0
        RewardMap[ItemType] = RewardMap[ItemType] or {}
        RewardMap[ItemType][Id] = (RewardMap[ItemType][Id] or 0) + Count
    end
    for _, ItemData in ipairs(PrizeResult or {}) do
        local Idx = ItemData[1]
        local ItemType = ItemUtils.GetItemType(ItemData[2])
        local Id = ItemData[3]
        local Count = AvatarUtils:GetTargetDataStatistics(Avatar, ItemType, Id)
        local ItemConfig = DataMgr[ItemType] and DataMgr[ItemType][Id]
        local CurrentRewardCount = RewardMap[ItemType] and RewardMap[ItemType][Id] or nil
        if CurrentRewardCount and CurrentRewardCount == Count then
            RewardMap[ItemType][Id] = -1
        elseif ItemConfig and ItemConfig.RegainItemId then
            ConvertFlags[Idx] = true
        end
    end
    return ConvertFlags
end

function M:GetCurrentRound()
    local Avatar = GWorld:GetAvatar()
    local LimitPrizeData = Avatar and Avatar.LimitPrize and Avatar.LimitPrize[self.EventId] or nil
    local CurrentRound = 1
    if LimitPrizeData then
        CurrentRound = LimitPrizeData.Round
    end
    return CurrentRound
end

return M
