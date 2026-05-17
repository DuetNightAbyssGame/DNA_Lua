---@type WBP_LimitedPrizePool_Gacha_Base_C
local M = Class({ "BluePrints.Common.TimerMgr", "BluePrints.UI.BP_EMUserWidget_C" })

function M:Construct()
    self.List = self.List_Item
end

function M:Destruct()
    self:ClearTimers()
end

function M:Init(RewardPool, WonIndex, bIsBigPrize, AcquiredList, DrawCount, ConvertFlags, InCallback)
    self.TargetDisplayIndex = WonIndex
    self.bIsBigPrize = bIsBigPrize
    self.AcquiredList = AcquiredList
    self.DrawCount = DrawCount
    self.ConvertFlags = ConvertFlags
    self.InCallback = InCallback
    if self.Text_Title then
        self.Text_Title:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self:ClearTimers()
    self:PopulateList(RewardPool)
    self:StartDrawAnimation()
end

function M:PopulateList(DataList)
	local DataList = DataList or {}
    self.ItemCount = #DataList
    self.List:ClearListItems()
    for i, ItemData in ipairs(DataList) do
        local Content = UE4.NewObject(UIUtils.GetCommonItemContentClass())
        Content.Id = ItemData.Id
        Content.Ids = ItemData.Ids
        Content.Type = ItemData.Type
        Content.Count = ItemData.Count
        Content.bLocked = ItemData.bLocked
        Content.bGot = false
        Content.Number = i
        Content.IsPreviewMode = true
        self.List:AddItem(Content)
    end
end

function M:StartDrawAnimation()
    local Count = self.ItemCount or 0
    if Count == 0 then
        self:ShowResult()
        return
    end
    if Count == 1 then
        self:PlayItemAnimation(1)
        self:FinishDrawAnimation(1)
        return
    end

    local TotalSteps = Count + self.TargetDisplayIndex
    local X = math.floor(Count * 0.5)
    local SlowDownStartStep = TotalSteps - X
    self.CurrentDrawStep = 1
    self.CurrentInterval = 0.2
    self.LastDrawIndex = nil

    local function PlayNextStep()
        if not IsValid(self) then return end
        if self.CurrentDrawStep > TotalSteps then
            self:FinishDrawAnimation(Count)
            return
        end

        local ItemIndex = (self.CurrentDrawStep - 1) % Count + 1
        if self.CurrentDrawStep >= SlowDownStartStep then
            self.CurrentInterval = self.CurrentInterval * 1.5
        end

        self:PlayItemAnimation(ItemIndex)
        self.CurrentDrawStep = self.CurrentDrawStep + 1
        self.DrawTimerKey = self:AddTimer(self.CurrentInterval, PlayNextStep, nil, nil, nil, true)
    end

    PlayNextStep()
end

function M:FinishDrawAnimation(Count)
    self.DrawTimerKey = nil

    local function OnAllAnimationsFinished()
        self:ShowResult()
    end

    if self.bIsBigPrize then
        if self.Text_Title then
            if self.DrawCount <= 3 then
                self.Text_Title:SetText(string.format(GText("UI_LimitedPrizePool_BestLuck"), self.DrawCount))
                self.Text_Title:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            elseif self.DrawCount <= 5 then
                self.Text_Title:SetText(string.format(GText("UI_LimitedPrizePool_GoodLuck"), self.DrawCount))
                self.Text_Title:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            end
        end

        local TargetAnimCount = Count - 1
        if TargetAnimCount <= 0 then
            OnAllAnimationsFinished()
            return
        end

        local AnimCount = 0
        local function OnSingleAnimFinished()
            AnimCount = AnimCount + 1
            if AnimCount >= TargetAnimCount then
                OnAllAnimationsFinished()
            end
        end

        for i = 1, Count do
            if i ~= self.TargetDisplayIndex then
                self:PlayItemResultAnimation(i, OnSingleAnimFinished)
            end
        end
    else
        self:PlayItemResultAnimation(self.TargetDisplayIndex, OnAllAnimationsFinished)
    end
end

function M:PlayItemAnimation(Index)
    if self.LastDrawIndex and self.LastDrawIndex ~= Index then
         local LastWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List, self.LastDrawIndex - 1)
         if IsValid(LastWidget) and LastWidget.PlayGachaOutAnimation then
             LastWidget:PlayGachaOutAnimation()
         end
    end

    local ItemWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List, Index - 1)
    if IsValid(ItemWidget) and ItemWidget.PlayGachaInAnimation then
        ItemWidget:PlayGachaInAnimation()
    end

    self.LastDrawIndex = Index
end

function M:PlayItemResultAnimation(Index, CallbackFunc)
    local ItemWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List, Index - 1)
    if IsValid(ItemWidget) then
        if ItemWidget.PlayGachaGetAnimation then
             ItemWidget:PlayGachaGetAnimation(CallbackFunc)
        else
             if CallbackFunc then CallbackFunc() end
        end
    else
        if CallbackFunc then CallbackFunc() end
    end
end

function M:ShowResult()
    if self.AcquiredList and #self.AcquiredList > 0 then
        local ResultWidget = UIManager(self):LoadUINew("LimitedPrizePoolReward", self.AcquiredList, self.DrawCount, self.bIsBigPrize, self.InCallback, self.ConvertFlags)
    end
    self:RemoveFromParent()
end

function M:SkipToResult()
    self:ClearTimers()
    self:ShowResult()
end

function M:ClearTimers()
    if self.DrawTimerKey then
        self:RemoveTimer(self.DrawTimerKey)
        self.DrawTimerKey = nil
    end
end

return M
