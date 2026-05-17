--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Play_DailyReward_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

--function M:Initialize(Initializer)
--end

function M:Construct()
    M.Super.Construct(self)
    self.Btn_Click.OnPressed:Add(self, self.OnPressed)
    self.Btn_Click.OnReleased:Add(self, self.OnReleased)
    self.Btn_Click.OnHovered:Add(self, self.OnHovered)
    self.Btn_Click.OnUnhovered:Add(self, self.OnUnhovered)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:Init(Data,Parent)
    self.RequiredActiveness = Data.RequiredActiveness
    self.Text_Point:SetText(self.RequiredActiveness)
    self.Parent = Parent
    self:RefreshView()
    self.Mobile = CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile"
 
end


function M:RefreshView()
    self.Btn_Click.OnClicked:Clear()
    self:StopAllAnimations()
    local PlayerAvatar = GWorld:GetAvatar()
    if not PlayerAvatar then return end

    self.State = PlayerAvatar.DailyTaskProgress[self.RequiredActiveness]
    -- DebugPrint("OnDailyProgressRewardChange  RequiredActiveness  ",self.RequiredActiveness)
    -- DebugPrint("OnDailyProgressRewardChange  State  ", State)
    if self.State == CommonConst.DailyTaskState.Doing then
        self:StopAllAnimations()
        self:PlayAnimation(self.Normal)
        self.Btn_Click.OnClicked:Add(self,self.ParentReceiveReward)
        self.Reddot:SetVisibility(UE4.ESlateVisibility.Collapsed)
    elseif self.State == CommonConst.DailyTaskState.Complete then
        self:StopAllAnimations()
        self:PlayAnimation(self.Reward)
        self.Btn_Click.OnClicked:Add(self,self.ReceiveReward)
        self.Reddot:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    elseif self.State == CommonConst.DailyTaskState.GetReward then
        self.Btn_Click.OnClicked:Add(self,self.ParentReceiveReward)
        self:StopAllAnimations()
        self:PlayAnimation(self.Recived)
        self.Reddot:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function M:ReceiveReward()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    local PlayerAvatar = GWorld:GetAvatar()
    if not PlayerAvatar then
        return
    end
    --PlayerAvatar:GetDailyProgressReward(self.RequiredActiveness)
    PlayerAvatar:GetAllDailyProgressReward()
end

function M:ParentReceiveReward()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    self.Parent:RewardView()
end

function M:OnPressed()
    self:StopAllAnimations()
    self:PlayAnimation(self.Press)
end

function M:OnReleased()
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
end

function M:OnHovered()
    self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
end

function M:OnUnhovered()
    self:StopAllAnimations()
    self:PlayAnimation(self.UnHover)
    if self.State == CommonConst.DailyTaskState.Doing then
        self:PlayAnimation(self.Normal)
    elseif self.State == CommonConst.DailyTaskState.Complete then
        self:PlayAnimation(self.Reward)
    elseif self.State == CommonConst.DailyTaskState.GetReward then
        self.Btn_Click.OnClicked:Add(self,self.ParentReceiveReward)
        self:PlayAnimation(self.Recived)
    end
end

return M
