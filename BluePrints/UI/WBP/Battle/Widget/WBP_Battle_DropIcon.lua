---@type WBP_Battle_DropIcon
local M = Class({ "BluePrints.UI.BP_UIState_C" })

function M:InitConfig(ImgPath)
	self.ImgPath = ImgPath

	local ImageResource = LoadObject(ImgPath)
	self.Img_Drop:SetBrushResourceObject(ImageResource)
end

return M
