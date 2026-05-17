require "UnLua"

local function GetIndexText(Index)
	if (not Index) then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Invite, "获取邀约序号失败", "获取邀约序号失败，序号为空。")
		return nil
	end

	local IndexText = tostring(Index)
	if (Index < 10) then
		IndexText = "0" .. IndexText
	end
	return IndexText
end

---@type WBP_Entertainment_NumItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

-- public:

function M:SetIndex(Index)
	self.Index = Index
	local IndexText = GetIndexText(Index)
	self.Text_Num:SetText(IndexText)
end

function M:BindOnClicked(OnClicked)
	self.OnClicked = OnClicked
end

function M:ExecuteOnClicked()
	if (self.OnClicked) then
		self.OnClicked(self.Index)
	end
end

function M:SetSelected(bIsSelected)
	if (self.bIsSelected == bIsSelected) then
		return
	end

	self:StopAllAnimations()
	if (bIsSelected) then
		self:PlayAnimation(self.SelectAnimation)
	else
		self:PlayAnimation(self.UnselectAnimation)
	end

	self.bIsSelected = bIsSelected
end

function M:EnableReddot(bEnable)
	if (bEnable) then
		self.Reddot:SetVisibility(UE4.ESlateVisibility.Visible)
	else
		self.Reddot:SetVisibility(UE4.ESlateVisibility.Collapsed)
	end
end

-- protected:

function M:Initialize(Initializer)
	self.Index = 0
	self.OnClicked = nil
	self.bIsSelected = false
	self.ClickSound = "event:/ui/common/click_btn_sort_tab"
end

function M:Construct()
	self.SelectAnimation = self.Click
	self.UnselectAnimation = self.Normal

	self.Btn_Click.OnClicked:Add(self, self.HandleOnButtonClicked)
	self.Btn_Click.OnPressed:Add(self, self.HandleOnButtonPressed)
	self.Btn_Click.OnReleased:Add(self, self.HandleOnButtonReleased)
	self.Btn_Click.OnHovered:Add(self, self.HandleOnButtonHovered)
	self.Btn_Click.OnUnhovered:Add(self, self.HandleOnButtonUnhovered)
end

function M:Destruct()
	self.Btn_Click.OnClicked:Remove(self, self.HandleOnButtonClicked)
	self.Btn_Click.OnPressed:Remove(self, self.HandleOnButtonPressed)
	self.Btn_Click.OnReleased:Remove(self, self.HandleOnButtonReleased)
	self.Btn_Click.OnHovered:Remove(self, self.HandleOnButtonHovered)
	self.Btn_Click.OnUnhovered:Remove(self, self.HandleOnButtonUnhovered)
end

-- private:

function M:HandleOnButtonClicked()
	if (self.bIsSelected) then
		return
	end

	self:ExecuteOnClicked()
	AudioManager(self):PlayUISound(self, self.ClickSound, nil, nil)
end

function M:HandleOnButtonPressed()
	if (self.bIsSelected) then
		return
	end

	self:StopAllAnimations()
	self:PlayAnimation(self.Press)
end

function M:HandleOnButtonReleased()
	if (self.bIsSelected) then
		return
	end

	self:StopAllAnimations()
	self:PlayAnimation(self.Normal)
end

function M:HandleOnButtonHovered()
	if (self.bIsSelected) then
		return
	end

	self:StopAllAnimations()
	self:PlayAnimation(self.Hover)
end

function M:HandleOnButtonUnhovered()
	if (self.bIsSelected) then
		return
	end

	self:StopAllAnimations()
	self:PlayAnimation(self.Unhover)
end

return M
