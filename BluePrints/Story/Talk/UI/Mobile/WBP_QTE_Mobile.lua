require "UnLua"

local M = Class("BluePrints.Story.Talk.UI.Common.WBP_QTE_Common")

function M:SwitchBindButtonClickEvents(bBind)
    if bBind then
        self.Btn_Click.OnClicked:Add(self, self.OnInputPress)
    else
        self.Btn_Click.OnClicked:Clear()
    end
end

function M:InitButtonPerformance()
     --Todo
end

function M:AdaptPlatform()
    local ButtonIconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Story/T_Story_QTE01.T_Story_QTE01'"
    local Tex = LoadObject(ButtonIconPath)
    if Tex then
        self.Icon:SetBrushFromTexture(Tex)
    else
        Utils.ScreenPrint("QTE手机端按钮图标路径错误，请检查：", ButtonIconPath)
    end
end

function M:SwitchShowMouseCursorInPIE(bShow)
	if URuntimeCommonFunctionLibrary.IsPlayInEditor(self) then
        local PlayerController = UGameplayStatics.GetPlayerController(self, 0)
        PlayerController.bShowMouseCursor = bShow
    end
end

return M
