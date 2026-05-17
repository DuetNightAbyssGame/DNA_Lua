--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Dungeon_EscortMain_C
local M = Class({ "BluePrints.UI.BP_UIState_C"})

function M:OnLoaded(...)
    M.Super.OnLoaded(self,...)
    DebugPrint("zwkkk WBP_Dungeon_EscortMain_C OnLoaded", ...)
    self.YanQueEid = ...
    self.YanQue = Battle(self):GetEntity(self.YanQueEid)
    if self.YanQue then
        self.YanQue.UI = self
    end
    self.Text_SpeedUp:SetText(GText("UI_Explore_Yanque_Run_Loop"))
    self:PlayAnimation(self.Bird_Nor)
    self:PlayAnimation(self.In)
    self.InAddSpeed = false
    self.InReduceSpeed = false
    self.InLowEnergy = false
    self.AddingEnergy = 0
end

function M:Tick(MyGeometry,DeltaSeconds)
    self.Overridden.Tick(self, MyGeometry,DeltaSeconds)


end

function M:SetPercent(Percent)
    Percent = math.clamp(Percent, 0, 1)
    -- 进度条
    self.Bar_Percent:GetDynamicMaterial():SetScalarParameterValue("Percent", Percent)

    -- 进度头像
    local BarSize = UE4.USlateBlueprintLibrary.GetLocalSize(self.ProgressBar:GetCachedGeometry())
    local PointWidth = UE4.USlateBlueprintLibrary.GetLocalSize(self.Point_Group:GetCachedGeometry()).X

    local TargetX = BarSize.X * (Percent - 0.5)
    TargetX = TargetX + PointWidth * 0.5

    -- 获取CanvasPanel的Slot并设置位置
    local Slot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Point_Group)
    if Slot then
        local CurrentPos = Slot:GetPosition()
        Slot:SetPosition(UE4.FVector2D(TargetX, CurrentPos.Y))
    end

    -- 鸟头像上的能量值
    if self.YanQue then
        self.Fill:GetDynamicMaterial():SetScalarParameterValue("Percent", self.YanQue.BaseEnergy / self.YanQue.MaxEnergy)
    end

    -- 进度文字
    local IntPercent = math.floor(Percent * 100)
    self.Text_Progress:SetText(string.format("%d%%", IntPercent))

end

-- 能量低时
function M:OnLowEnergy(Percent)
    self:PlayAnimation(self.Slowest_In)
    self.InLowEnergy = true
    self.Text_Slowest:SetText(GText("UI_Explore_Yanque_Warning"))
    self.Text_Slowest_1:SetText(string.format("%d%%", math.floor(Percent * 100)))
    AudioManager(self):PlayUISound(self, "event:/ui/common/toast_warning", "",nil)
    -- 鸟头像动效变化
    if self.InAddSpeed then
        self:PlayAnimation(self.Bird_Up_Not)
    elseif self.InReduceSpeed then
        self:PlayAnimation(self.Bird_Down_Not)
    else
        self:PlayAnimation(self.Bird_Nor_Not)
    end
end

-- 能量恢复到较高时
function M:OnRecoverToNormalEnergy()
    self.InLowEnergy = false
    if self.InAddSpeed then
        self:OnAddSpeed(self.AddSpeedPercent)
    elseif self.InReduceSpeed then
        self:OnReduceSpeed(self.ReduceSpeedPercent)
    else
        self:PlayAnimation(self.Slowest_Out)
    end

    -- 鸟头像动效变化
    if self.InAddSpeed then
        self:PlayAnimation(self.Bird_Up_Have)
    elseif self.InReduceSpeed then
        self:PlayAnimation(self.Bird_Down_Have)
    else
        self:PlayAnimation(self.Bird_Nor)
    end
end

-- 加速时，传入了加速比例
function M:OnAddSpeed(Percent)
    self.AddSpeedPercent = Percent
    self.InAddSpeed = true
    self.InReduceSpeed = false
    self.Text_Fastest:SetText(GText("UI_Explore_Yanque_SpeedUp"))
    self.Text_Fastest_1:SetText(string.format("%d%%", math.floor(Percent * 100)))
    if not self.InLowEnergy then
        self:PlayAnimation(self.Fastest_In)
        self:PlayAnimation(self.Bird_Up_Have)
        AudioManager(self):PlayUISound(self, "event:/ui/common/week_level_target_finish", "",nil)
    else
        self:PlayAnimation(self.Bird_Up_Not)
    end
end

-- 减速时，传入了减速比例
function M:OnReduceSpeed(Percent)
    self.ReduceSpeedPercent = Percent
    self.InReduceSpeed = true
    self.InAddSpeed = false
    if not self.InLowEnergy then
        self.Text_Slowest:SetText(GText("UI_Explore_Yanque_SpeedDown"))
        self.Text_Slowest_1:SetText(string.format("%d%%", math.floor(Percent * 100)))
        self:PlayAnimation(self.Slowest_In)
        self:PlayAnimation(self.Bird_Down_Have)
        AudioManager(self):PlayUISound(self, "event:/ui/common/toast_warning", "",nil)
    else
        self:PlayAnimation(self.Bird_Down_Not)
    end
end

-- 速度恢复正常时
function M:OnSpeedNormal()
    if self.InLowEnergy then
        self.InAddSpeed = false
        self.InReduceSpeed = false
        self:PlayAnimation(self.Bird_Nor_Not)
        return
    end
    self:PlayAnimation(self.Bird_Nor)
    if self.InAddSpeed and not self.InLowEnergy then
        self:PlayAnimation(self.Fastest_Out)
    elseif self.InReduceSpeed and not self.InLowEnergy then
        self:PlayAnimation(self.Slowest_Out)
    end
    self.InAddSpeed = false
    self.InReduceSpeed = false
end

-- 增加能量时，传入了增加的能量值
function M:OnAddEnergy(DeltaEnergy)
    if self.IsAddingEnergy then
        self.AddingEnergy = self.AddingEnergy + DeltaEnergy
    else
        self.AddingEnergy = DeltaEnergy
        self:PlayAnimation(self.Recover_In)
        self:BindToAnimationFinished(self.Recover_In, {self, function()
            self:AddTimer(self.EnergyShowTime, self.OnShowTimeEnd, false, 0, "ShowTimeEndBindToTimer", false)
        end})
    end
    self.TextEnergyNum:SetText(string.format("+%d", math.floor(self.AddingEnergy)))
    self.IsAddingEnergy = true
    AudioManager(self):PlayUISound(self, "event:/ui/common/week_level_progress_add", "",nil)
end

function M:OnShowTimeEnd()
    self:PlayAnimation(self.Recover_Out)
    self:UnbindAllFromAnimationFinished(self.Recover_In)
    self:BindToAnimationFinished(self.Recover_Out, {self, function()
        self.IsAddingEnergy = false
        self.AddingEnergy = 0
        self:UnbindAllFromAnimationFinished(self.Recover_Out)
    end})
end


function M:OnReset()
    self:PlayAnimation(self.Out)
    self:BindToAnimationFinished(self.Out, {self, self.Close})
end


return M
