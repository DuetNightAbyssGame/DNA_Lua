--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local CircleAroundBlock = Class(
    {
        "BluePrints.UI.BP_UIState_C",
    }
)

function CircleAroundBlock:Construct()
    self.IsDestroied = false
    self.ActiveState = nil
    self.ConnectState = nil
    self.HoverState = nil
    self:ChangeActiveState("Base")
    self:ChangeHoverState("UnHover")

    self:AddDispatcher(EventID.CircleAroundGameSuccess, self, self.GameSuccess)
    self:AddDispatcher(EventID.CircleAroundGameFailed, self, self.GameFailed)
end

function CircleAroundBlock:GameFailed()
    self:PlayAnimation(self.Fail)
end

function CircleAroundBlock:GameSuccess()
    self:PlayAnimation(self.Success,0,1,UE4.EUMGSequencePlayMode.Reverse)
end

function CircleAroundBlock:ChangeActiveState(str)
    if str == self.ActiveState then
        return
    end
    if str == "Base" then
        self.Bg_Base:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Base:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Block:SetVisibility(UE4.ESlateVisibility.Collapsed)
    elseif str == "CanActive" then
        self.Bg_Base:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Base:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Block:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self:StopAllAnimations()
        self:PlayAnimation(self.OFF)
    elseif str == "IsActived" then
        self.Bg_Base:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Base:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Block:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self:StopAllAnimations()
        self:PlayAnimation(self.ON)
    end
    self.ActiveState = str
end

function CircleAroundBlock:ChangeHoverState(str)
    if str == self.HoverState then
        return
    end
    if self.ActiveState=="CanActive" and str == "Hover" then
        self:PlayAnimation(self.Hover)
        -- self.Base_Hover:SetVisibility(UE4.ESlateVisibility.Visible)
    elseif str == "UnHover" then
        -- self.Base_Hover:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function CircleAroundBlock:Trigger()
    if self.ActiveState == "CanActive" then
        AudioManager(self):PlayUISound(self, "event:/ui/minigame/mech_rotate_pointer_push","",nil)
        self:ChangeActiveState("IsActived")
    elseif self.ActiveState == "IsActived" then
        AudioManager(self):PlayUISound(self, "event:/ui/minigame/mech_rotate_pointer_pop","",nil)
        self:ChangeActiveState("CanActive")
    end
end


return CircleAroundBlock
