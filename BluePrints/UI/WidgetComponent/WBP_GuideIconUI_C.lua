require "UnLua"
local M = Class({ "BluePrints.UI.BP_UIState_C" })

function M:InitConfig(OwnerType, ImgPath, RenderSize)
	RenderSize = RenderSize or UE4.FVector2D(1, 1)
	self.OwnerType = OwnerType
	self.ImgPath = ImgPath

	local ImageResource = LoadObject(ImgPath)
	self.Image_Bg:SetBrushResourceObject(ImageResource)
end

return M
