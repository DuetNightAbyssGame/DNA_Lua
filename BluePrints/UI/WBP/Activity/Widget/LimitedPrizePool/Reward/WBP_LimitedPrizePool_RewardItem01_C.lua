---@type WBP_LimitedPrizePool_RewardItem01_C
local M = Class({ "BluePrints.UI.BP_EMUserWidget_C" })

function M:Construct()
    self.Item = self.Item

    self.GotAnimation = self.Get_Normal
    self.NormalAnimation = self.Normal

    self.Content = nil
    self.GachaGetCallbackFunc = nil
end

function M:Destruct()
end

function M:PlayGachaInAnimation()
    if (self.Choose_In) then
        self:PlayAnimation(self.Choose_In)
    end
end

function M:PlayGachaOutAnimation()
    if (self.Choose_Out) then
        self:PlayAnimation(self.Choose_Out)
    end
end

function M:PlayGachaGetAnimation(CallbackFunc)
    if (self.Get) then
        self.GachaGetCallbackFunc = CallbackFunc
        self:UnbindAllFromAnimationFinished(self.Get)
        self:BindToAnimationFinished(self.Get, { self, self.OnGachaGetAnimationFinished })
        self:PlayAnimation(self.Get)
    else
        if CallbackFunc then
            CallbackFunc()
        end
    end
end

function M:OnGachaGetAnimationFinished()
    if (self.Get) then
        self:UnbindAllFromAnimationFinished(self.Get)
    end
    if self.GachaGetCallbackFunc then
        local CallbackFunc = self.GachaGetCallbackFunc
        self.GachaGetCallbackFunc = nil
        CallbackFunc()
    end
end

function M:Init(Content)
    self.Content = Content

    self.Item:Init({
        Id = self.Content.Id,
        ItemType = self.Content.Type,
        Icon = ItemUtils.GetItemIconPath(self.Content.Id, self.Content.Type),
        Rarity = ItemUtils.GetItemRarity(self.Content.Id, self.Content.Type),
        Count = self.Content.Count,

        IsShowDetails = true,
        HandleMouseDown = true,

        OnMenuOpenChangedEvents = {Obj = self, Callback = self.ItemMenuAnchorChanged},
    })

    if (Content.bGot) then
        self:PlayAnimation(self.GotAnimation)
    else
        self:PlayAnimation(self.Normal)
    end
end

function M:TryPromptSelectableReward()
end

function M:ItemMenuAnchorChanged(IsOpen)
    if (self.Content.OnMenuOpenChangedEvent and self.Content.OnMenuOpenChangedEvent[1] and self.Content.OnMenuOpenChangedEvent[2]) then
        self.Content.OnMenuOpenChangedEvent[2](self.Content.OnMenuOpenChangedEvent[1], IsOpen)
    end
end

return M
