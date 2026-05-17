local M = Class()

function M:ReceiveBeginPlay()
	self.Owner = nil
	-- 用来计算距离
	self.ActivePlayer = nil
	self.OwnerType = nil
end

function M:ReceiveEndPlay()
	UIManager(self):RemoveWidgetComponentToList(self:GetOwner(), "Guide")
end

function M:InitGuide(Owner, ActivePlayer, ImgPath, IconOffsetZ)
	self.Owner = Owner
	self.ActivePlayer = ActivePlayer
	self.DistanceUnit = GText("UI_SCALE_METER")

	if self.Owner == nil then
		return
	end

	local Height = 0
	if self.Owner.CapsuleComponent ~= nil then
		Height = self.Owner.CapsuleComponent:GetUnscaledCapsuleHalfHeight()
	elseif IconOffsetZ ~= nil then
		Height = IconOffsetZ
	end
	self:SetComponentHeight(Height)

	local CurrentWidget = self:GetUserWidgetObject()
	if IsValid(CurrentWidget) then
		CurrentWidget:InitConfig(ImgPath)
	end
end

function M:SetWidgetHiddenByTag(bHidden, Tag)
	local Widget = self:GetUserWidgetObject()
	if (not IsValid(Widget)) then
		return
	end

	if (bHidden) then
		Widget:Hide(Tag)
	else
		Widget:Show(Tag)
	end
end

return M
