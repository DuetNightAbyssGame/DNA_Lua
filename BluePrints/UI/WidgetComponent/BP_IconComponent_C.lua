local M = Class({ "BluePrints.Common.TimerMgr" })

function M:ReceiveBeginPlay()
	self.Owner = nil
	self.TypeStr = nil
	self.ActivePlayer = nil
	self.bHiddenTagList = TArray("")

	self.bHasShow = false
	self.OwnerType = nil

	UIManager(self):AddWidgetComponentToList(self:GetOwner(), "Guide", self)
end

function M:ReceiveEndPlay()
	UIManager(self):RemoveWidgetComponentToList(self:GetOwner(), "Guide")
end

function M:InitGuide(Owner, TypeStr, ActivePlayer, ImgPath, RenderSize, IconOffsetZ, OwnerType, IconStyle, IconColor)
	self.Owner = Owner
	self.TypeStr = TypeStr
	self.OwnerType = OwnerType
	self.ActivePlayer = ActivePlayer
	self.IconStyle = IconStyle or "Guide"
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
		CurrentWidget:InitConfig(OwnerType, ImgPath, RenderSize)
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
