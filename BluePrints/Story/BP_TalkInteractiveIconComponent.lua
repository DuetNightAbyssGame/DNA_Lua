local M = Class()

function M:ReceiveBeginPlay()
	UIManager(self):AddWidgetComponentToList(self:GetOwner(), "Guide", self)
end

function M:ReceiveEndPlay()
	UIManager(self):RemoveWidgetComponentToList(self:GetOwner(), "Guide")
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

function M:SetAccessibility(bNewAccessed)
	local Widget = self:GetUserWidgetObject()
	if (not IsValid(Widget)) then
		return
	end

	Widget:SetAccessibility(bNewAccessed)
end

return M
