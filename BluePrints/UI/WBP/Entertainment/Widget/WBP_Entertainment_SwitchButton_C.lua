require "UnLua"

local FEntertainmentUtils = require "BluePrints.UI.WBP.Entertainment.EntertainmentUtils"

---@type WBP_Entertainment_SwitchButton_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

-- public:

function M:OpenPanel()
	if self.bIsOpened then
		return
	end
	self.bIsOpened = true
	self:StopAllAnimations()
	self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	self:PlayAnimation(self.In)
end

function M:ClosePanel()
	if self.bIsOpened == false then
		return
	end
	self.bIsOpened = false
	self:StopAllAnimations()
	self:PlayAnimation(self.Out)
end

function M:OnOutAnimationFinished()
	self:SetVisibility(ESlateVisibility.Collapsed)
end

function M:SetAvatar(AvatarIconPath)
	self.Icon_Avatar:SetBrushFromTexture(LoadObject(AvatarIconPath))
end

function M:SetName(Name, WorldName)
	self.Text_Name:SetText(Name)
	self.WorldText_Name:SetText(WorldName)
end

function M:RefreshRedDot()
	if (FEntertainmentUtils:IsSystemShowRedDot()) then
		self.Reddot:SetVisibility(ESlateVisibility.Visible)
	else
		self.Reddot:SetVisibility(ESlateVisibility.Collapsed)
	end
end

function M:BindOnClicked(OnClicked)
	self.OnClicked = OnClicked
end

function M:ExecuteOnClicked()
	if (self.OnClicked) then
		self.OnClicked()
	end
end

-- protected:

function M:Initialize(Initializer)
	self.ClickSound = "event:/ui/common/click_mid"
end

function M:Construct()
	self.bIsOpened = false
	self:BindToAnimationFinished(self.Click, {self, self.HandleOnButtonClickAnimationFinished})
	self:BindToAnimationFinished(self.Out, {self, self.OnOutAnimationFinished})
-- 	self.Btn_Click.OnClicked:Add(self, self.HandleOnButtonClicked)
-- 	self.Btn_Click.OnPressed:Add(self, self.HandleOnButtonPressed)
-- 	self.Btn_Click.OnReleased:Add(self, self.HandleOnButtonReleased)
-- 	self.Btn_Click.OnHovered:Add(self, self.HandleOnButtonHovered)
-- 	self.Btn_Click.OnUnhovered:Add(self, self.HandleOnButtonUnhovered)
end

function M:Destruct()
	self.bIsOpened = false
	self:UnbindFromAnimationFinished(self.Click, {self, self.HandleOnButtonClickAnimationFinished})
	self:UnbindFromAnimationFinished(self.Out, {self, self.OnOutAnimationFinished})
	-- self.Btn_Click.OnClicked:Remove(self, self.HandleOnButtonClicked)
	-- self.Btn_Click.OnPressed:Remove(self, self.HandleOnButtonPressed)
	-- self.Btn_Click.OnReleased:Remove(self, self.HandleOnButtonReleased)
	-- self.Btn_Click.OnHovered:Remove(self, self.HandleOnButtonHovered)
	-- self.Btn_Click.OnUnhovered:Remove(self, self.HandleOnButtonUnhovered)
end

-- private:

-- function M:HandleOnButtonClicked()
-- 	self:PlayAnimation(self.Click)
-- 	AudioManager(self):PlayUISound(self, self.ClickSound, nil, nil)
-- end

-- function M:HandleOnButtonPressed()
-- 	self:PlayAnimation(self.Press)
-- end

-- function M:HandleOnButtonReleased()
-- 	self:PlayAnimation(self.Normal)
-- end

-- function M:HandleOnButtonHovered()
-- 	self:PlayAnimation(self.Hover)
-- end

-- function M:HandleOnButtonUnhovered()
-- 	self:PlayAnimation(self.Unhover)
-- end

-- function M:HandleOnButtonClickAnimationFinished()
-- 	self:ExecuteOnClicked()
-- end

return M
