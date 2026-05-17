local M = Class()

function M:SetCameraTexture(CameraTexture)
	if not IsValid(CameraTexture) then
		self.CameraView:SetVisibility(ESlateVisibility.Collapsed)
		GWorld.logger.error("CameraTransitionUI:SetCameraTexture, CameraTexture is nil")
		return
	end
	self.CameraView:SetVisibility(ESlateVisibility.HitTestInvisible)

	local FormerMaterial = self.CameraView:GetDynamicMaterial()
	if IsValid(FormerMaterial) then
		FormerMaterial:SetTextureParameterValue("RenderTargetTexture", CameraTexture)
	end
end

function M:UpdateTransitionProgress(Progress)
	self.CameraView:SetRenderOpacity(Progress)
end

return M