--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Rouge_EventChoice_C
local M = Class("BluePrints.UI.BP_UIState_C")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()
    self.BtnCD = 0.5 -- 发送rpc操作的内置CD
    self.IsCoinEnough = true
end

function M:BindChooseEvent()
    self.StartTime = UE4.UGameplayStatics.GetRealTimeSeconds(self)
    if self.Parent then
        self.Btn_Click.OnClicked:Add(self, self.OnBtnClicked)
    end
    local Avatar =GWorld:GetAvatar()
    assert(Avatar, "找不到Avatar")
    local Currency = Avatar.Resources:QueryResourceCount(self.Parent.CoinId)
    if self.SelectId then
        self.ChoicePrice = DataMgr.RougeLikeEventSelect[self.SelectId].Price
    end
    if self.ChoicePrice and self.ChoicePrice > Currency then
        self:PlayAnimationForward(self.Forbidden)
        self.IsCoinEnough = false
    end
end

function M:OnBtnClicked()
    self.CurrentTime = UE4.UGameplayStatics.GetRealTimeSeconds(self)
    if(self.CurrentTime - self.StartTime < self.BtnCD) then
        self:PlayAnimationForward(self.Normal)
        return
    end
    if not self.Parent.CanInteractChoices then
        self:PlayAnimationForward(self.Normal)
        return
    end
    local Avatar =GWorld:GetAvatar()
    assert(Avatar, "找不到Avatar")
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    assert(UIManager, "找不到UIManager")
    local Currency = Avatar.Resources:QueryResourceCount(self.Parent.CoinId)
    --DebugPrint("@zyh 信息", Currency, ChoicePrice, self.Parent.CoinId, self.SelectId)
    if self.ChoicePrice and self.ChoicePrice > Currency then
        UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("RL_Event_CantSelect"))
        return
    end
    self:PlayAnimation(self.Click)
    AudioManager(self):PlayUISound(self, "event:/ui/roguelike/level_event_select_btn_click", nil, nil)
    self.StartTime = UE4.UGameplayStatics.GetRealTimeSeconds(self)
    self.Parent:CloseChoiceExcept(self.OptionIndex)
    self:AddTimer(self.Click:GetEndTime(), function()
        self.Parent:ChooseItem(self.OptionIndex)
    end)
end

return M
