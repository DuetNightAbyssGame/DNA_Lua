--
-- DESCRIPTION
-- 周本二护送人质血条/护盾 UI，按 EID 取目标，只做血条护盾更新逻辑（简化版，无扣血动效/LowHealth/Glow）
--
require "UnLua"

---@type WBP_Play_DeputeWeekly02_Hud_HealthBar_C
local M = Class("BluePrints.UI.BP_EMDungeonWidget_C")

local UpdateTickTime = 0.5
local LowHpPercent = 0.5

function M:InitDungeonWidget(HostageEid)
	M.Super.InitDungeonWidget(self)
	self.HostageEid = HostageEid
	self.LastHp = nil
	self.LastShield = nil
	self.LastHpPercent = 1.0
	self.LowHpPercent = LowHpPercent
	rawset(self, "NormalColor", FLinearColor(0.274677, 0.637597, 0.341915, 1.0))
	rawset(self, "CriticalColor", FLinearColor(0.63, 0, 0, 1.0))

	local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
	if not BattleMainUI then
		return false
	end
	BattleMainUI["Pos_Weekly"]:ClearChildren()
	self:AddToBattleMain("Pos_Weekly", "Overlay")

	if self.SizeBox_HP and self.SizeBox_Shield then
		self.SizeBox_HP:ClearChildren()
		self.SizeBox_Shield:ClearChildren()
		self:LoadHpBar()
		self:LoadShieldBar()
	end
	-- 名字只需要设置一次
	if self.DefenseCoreName then
		self.DefenseCoreName:SetText(GText("DUNGEON_SYNTHESIS2_115"))
	end
	self:AddTimer(UpdateTickTime, self.UpdateTargetInfo, true, 0, "UpdateHostageHealth", false)
end

function M:GetTargetActor()
	-- 已经有缓存的目标且仍然有效，直接复用
	if self.TargetActor and IsValid(self.TargetActor) then
		return self.TargetActor
	end

	-- 没有缓存，则尝试根据 Eid 查找一次
	if not self.HostageEid then
		self.HostageEid = self:GetHostageEid()
		if not self.HostageEid then
			return nil
		end
	end

	local Target = Battle(self):GetEntity(self.HostageEid)
	if IsValid(Target) then
		self.TargetActor = Target
		return Target
	end
	return nil
end

function M:GetHostageEid()
	local GameState = UE4.UGameplayStatics.GetGameState(self)
	if not GameState then
		return
	end
	for _,AI in pairs(GameState.MonsterMap) do
		if IsValid(AI) and AI.UnitId == CommonConst.SynthesisIIHostageUnitId then
			return AI.Eid
		end
	end
	return nil
end

function M:GetAttrFromTarget(CurTargetActor, AttrName)
	if CurTargetActor then
		return CurTargetActor:GetAttr(AttrName)
	end
	return 0
end

function M:UpdateTargetInfo()
	local CurTargetActor = self:GetTargetActor()
	if not CurTargetActor then
		return
	end

	local NewShield = self:GetAttrFromTarget(CurTargetActor, "ES")
	local MaxShield = self:GetAttrFromTarget(CurTargetActor, "MaxES")
	local NewHp = self:GetAttrFromTarget(CurTargetActor, "Hp")
	local MaxHp = self:GetAttrFromTarget(CurTargetActor, "MaxHp")
	if not self.LastHp then self.LastHp = NewHp end
	if not self.LastShield then self.LastShield = NewShield end

	if MaxHp and MaxHp <= 0 then return end
	local MaxShieldSafe = (MaxShield and MaxShield > 0) and MaxShield or 1

	local ShieldBar = self.ShieldBar
	local HpBar = self.HpBar
	local LastShield = self.LastShield
	local LastHp = self.LastHp

	-- 护盾
	if ShieldBar then
		local NewShieldPercent = NewShield / MaxShieldSafe
		if LastShield > NewShield then
			ShieldBar:SetBarPercent(NewShieldPercent)
			ShieldBar:PlayDeduct(true)
		elseif LastShield < NewShield then
			ShieldBar:SetBarPercent(NewShieldPercent, false)
			ShieldBar:PlayRecoveryShield()
		else
			ShieldBar:DirectSetBarPercent(NewShieldPercent, 0.0)
		end
	end

	-- 血量
	local NewHpPercent = NewHp / MaxHp
	if HpBar then
		HpBar:SetBarPercent(NewHpPercent)
		if LastHp > NewHp then
			HpBar:PlayDeduct(true)
		end
	end

	if HpBar and (self.LowHpPercent or LowHpPercent) then
		if NewHpPercent < (self.LowHpPercent or LowHpPercent) then
			HpBar:SetProgressBarColorInner(self.CriticalColor)
		else
			HpBar:SetProgressBarColorInner(self.NormalColor)
		end
	end

	self.LastShield = NewShield
	self.LastHp = NewHp
	self.LastHpPercent = NewHpPercent
	self:SetBloodAndShieldNum(NewHp, NewShield, NewHpPercent)
end

function M:SetBloodAndShieldNum(NewHp, NewShield, HpPercent)
	if self.Num_Shield then
		self.Num_Shield:SetText(math.floor(NewShield))
	end
	if self.Num_Blood then
		self.Num_Blood:SetText(math.floor(NewHp))
		local Color = FSlateColor()
		local bIsLowPercent = HpPercent < (self.LowHpPercent or LowHpPercent)
		if bIsLowPercent then
			Color.SpecifiedColor.R = 1.0
			Color.SpecifiedColor.G = 0.048
			Color.SpecifiedColor.B = 0.048
			self.Num_Blood:SetColorAndOpacity(Color)
		else
			Color.SpecifiedColor.R = 0.258183
			Color.SpecifiedColor.G = 0.590619
			Color.SpecifiedColor.B = 0.318547
			self.Num_Blood:SetColorAndOpacity(Color)
		end
	end
end

function M:LoadSubWidget(Container, WidgetName, ...)
	if not Container then return end
	local SubWidget = self:CreateWidgetNew(WidgetName)
	Container:AddChild(SubWidget)
	if SubWidget.Init then
		SubWidget:Init(...)
	end
	return Container:GetChildAt(0)
end

function M:LoadHpBar()
	if not self.SizeBox_HP then return end
	local BarLength = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.SizeBox_HP):GetSize().X
	self.HpBar = self:LoadSubWidget(self.SizeBox_HP, "HPBar", false, BarLength)
end

function M:LoadShieldBar()
	if not self.SizeBox_Shield then return end
	local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.SizeBox_Shield)
	local Size = CanvasSlot:GetSize()
	self.ShieldBar = self:LoadSubWidget(self.SizeBox_Shield, "ShieldBar", Size.X, Size.Y)
end

return M
