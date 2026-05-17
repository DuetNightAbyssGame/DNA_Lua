--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local BattlePassUtils = require "BluePrints.UI.WBP.BattlePass.BattlePassUtils"

---@type WBP_BattlePass_LevelUp_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Super.Construct(self)
    self.Text_LevelUp:SetText(GText("UI_BattlePass_LevelUp"))
    self.Text_LevelUp_Loop:SetText(GText("UI_BattlePass_RewardHasExpand"))
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
    self:UnbindAllFromAnimationFinished(self.In)
    self:UnbindAllFromAnimationFinished(self.Loop_In)
    self:UnbindAllFromAnimationFinished(self.Out)
end

function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    self:SetFocus()
    self.Level, self.ExpandedMaxLevel = ...
    self.BattlePass_Level.Text_Level:SetText(self.Level)
    if self.ExpandedMaxLevel then
        self.BattlePass_Level.Text_Level_Loop:SetText(self.ExpandedMaxLevel)
    end
    self:PlayInAnim()
end

function M:PlayInAnim()
    self:UnbindAllFromAnimationFinished(self.In)
    self:UnbindAllFromAnimationFinished(self.Loop_In)
    self:UnbindAllFromAnimationFinished(self.Out)
    if self.ExpandedMaxLevel then
        AudioManager(self):PlayUISound(self, "event:/ui/common/battle_pass_level_upgrade_recycle", nil, nil)
        self.ExpandedMaxLevel = nil
        self:PlayAnimation(self.Loop_In)
        self:BindToAnimationFinished(self.Loop_In, {self,function()
            self:PlayAnimation(self.Out)
        end
        })
        self:BindToAnimationFinished(self.Out, {self,function()
            self:Close()
        end
        })
    else
        AudioManager(self):PlayUISound(self, "event:/ui/common/battle_pass_level_upgrade", nil, nil)
        self:PlayAnimation(self.In)
        self:BindToAnimationFinished(self.In, {self,function()
            self:PlayAnimation(self.Out)
        end
        })
        self:BindToAnimationFinished(self.Out, {self,function()
            self:Close()
        end
        })
    end
end

function M:Refresh(Level, ExpandedMaxLevel)
    local Flag = false
    if ExpandedMaxLevel then
        if self:IsAnimationPlaying(self.In) then
            Flag = true
            self:UnbindAllFromAnimationFinished(self.In)
            self:StopAnimation(self.In)
        end
        if self:IsAnimationPlaying(self.Out) then
            Flag = true
            self:UnbindAllFromAnimationFinished(self.Out)
            self:StopAnimation(self.Out)
        end
    else
        if self:IsAnimationPlaying(self.Loop_In) then
            Flag = true
            self:UnbindAllFromAnimationFinished(self.Loop_In)
            self:StopAnimation(self.Loop_In)
        end
        if self:IsAnimationPlaying(self.Out) then
            Flag = true
            self:UnbindAllFromAnimationFinished(self.Out)
            self:StopAnimation(self.Out)
        end
    end
    if Level > self.Level then
        self.Level = Level
        self.BattlePass_Level.Text_Level:SetText(self.Level)
    end
    if ExpandedMaxLevel then
        self.ExpandedMaxLevel = ExpandedMaxLevel
        self.BattlePass_Level.Text_Level_Loop:SetText(self.ExpandedMaxLevel)
    end
    if Flag then
        self.BattlePass_Level:StopAllAnimations()
        self:PlayInAnim()
    end
end

function M:Close()
    self:UnbindAllFromAnimationFinished(self.In)
    self:UnbindAllFromAnimationFinished(self.Loop_In)
    self:UnbindAllFromAnimationFinished(self.Out)
    self:StopAllAnimations()
    self.Super.Close(self)
    local UIState = UIManager(self):GetCurrentState()
    if UIState then
        UIState:SetFocus()
    end
end

return M
