--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_SoloTreasure_Map_KeyLocation_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C","BluePrints.UI.BP_EMUserWidgetUtils_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.IsOpen = true
    self.Text_Search:SetText(GText('UI_Extraction_TM_1'))
    -- self.Btn_List:BindEventOnClicked(self, self.OnOpenClick)
    self.Btn_Top.OnClicked:Clear()
    self.Btn_Top.OnClicked:Add(self, self.OnOpenClick)
    self.Btn_Top.OnHovered:Add(self, self.OnBtnHovered)
    self.Btn_Top.OnUnhovered:Add(self, self.OnBtnUnhovered)
    self.Btn_Top.OnPressed:Add(self, self.OnBtnPressed)
    self.Btn_Top.OnReleased:Add(self, self.OnBtnReleased)
    self.Controller_List:CreateGamepadKey(UIConst.GamePadImgKey.FaceButtonLeft)
    for _, Data in pairs(DataMgr.SoloTreasureIcon) do
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        Obj.Data = Data
        self.List_Location:AddItem(Obj)
    end
    self:AddInputMethodChangedListen()
    if (self.GameInputModeSubsystem) then     --给第一次打开反界面刷一下
        self:OnUpdateUIStyleByInputTypeChange(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
    self.CanOpen = true
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
    self.List_Location:ClearListItems()
    self:RemoveInputMethodChangedListen()
end

function M:OnOpenClick()
    if not self.CanOpen then
        return
    end
    self.Btn_List:OnBtnClicked()
    self.CanOpen = false
    self.IsOpen = not self.IsOpen
    self.Arrow:SetRenderTransformAngle(self.IsOpen and -90 or 90)
    -- self.List_Location:SetVisibility(self.IsOpen and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
    self:PlayAnimation(self.IsOpen and self.List_In or self.List_Out)
end

function M:Show()
    if self:GetVisibility()==ESlateVisibility.Collapsed or self:IsAnimationPlaying(self.Auto_Out) then
        self:StopAllAnimations()
        self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self:PlayAnimation(self.Auto_In)
    end
end

function M:Close()
    if self:GetVisibility()==ESlateVisibility.SelfHitTestInvisible then
        self:StopAllAnimations()
        self:PlayAnimation(self.Auto_Out)
    end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    if CurInputDevice == ECommonInputType.Gamepad then
        self.Controller_List:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Controller_List:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:OnAnimationFinished(InAnimation) 
    if InAnimation == self.List_In or InAnimation == self.List_Out then
        self.CanOpen = true
    elseif InAnimation == self.Auto_Out then
        self:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:OnBtnHovered()
    self.Btn_List:OnBtnHovered()
end

function M:OnBtnUnhovered()
    self.Btn_List:OnBtnUnhovered()
end

function M:OnBtnPressed()
    self.Btn_List:OnBtnPressed()
end

function M:OnBtnReleased()
    self.Btn_List:OnBtnReleased()
end

return M
