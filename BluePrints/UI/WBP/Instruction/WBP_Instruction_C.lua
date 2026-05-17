--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Instruction_P_C
local M = Class({"BluePrints.UI.BP_UIState_C","BluePrints.Common.TimerMgr"})


function M:Construct()
    self:InitListenEvent()
    EventManager:AddEvent(EventID.OnChangeKeyBoardSet,self,self.OnChangeKeyBoardSet)
end

function M:Destruct()
    self:RemoveTimer("InstructionKeyAnim")
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self,self.RefreshOpInfoByInputDevice) 
    end
    EventManager:RemoveEvent(EventID.OnChangeKeyBoardSet,self)
end

function M:HideAllText()
    local Platform = CommonUtils:GetDeviceTypeByPlatformName(self)
    if Platform == "PC" then
        self:HideAllTextPC()
    else
        self:HideAllTextMobile()
    end
end

function M:Init(ActionName, IsByStl)
    self.SkillType = ActionName
    self.Key:SetVisibility(UE4.ESlateVisibility.Visible)
    self.IsByStl = IsByStl
    if not self.IsByStl then
        self.Key:PlayAnimation(self.Key.In)
    end
    self:RefreshBaseInfo()
    --self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    self:SetActionText(ActionName)

end

function M:HideAllTextPC()
    self.Text01:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Text02:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Text03:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Text04:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Text05:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Arrow:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Key.Main:SetRenderOpacity(0)
end

function M:HideAllTextMobile()
    self.One:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Two:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Three:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Four1:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Four2:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Arrow:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:ShowActionText(ActionName)
    local Platform = CommonUtils:GetDeviceTypeByPlatformName(self)
    if Platform == "PC" then
        self:ShowActionTextPC(ActionName)
    else
        self:ShowActionTextMobile(ActionName)
    end
end

function M:ShowActionTextPC(ActionName)
    if ActionName == "SpiralLeap" then
        self.RealSetSpiralLeap = self.Text01:ShowTextPC("Guide_UI_SpiralLeap_PC", "Guide_UI_SpiralLeap_PC")
    elseif ActionName == "Dodge" then
        self.RealSetDodge = self.Text02:ShowTextPC("Guide_UI_Dodge_PC", "Guide_UI_Dodge_PC")
    elseif ActionName == "Skill1" then
        self.RealSetSkill1 = self.Text03:ShowTextPC("Guide_UI_Skill1_PC", "Guide_UI_Skill1_Gamepad")
    elseif ActionName == "Skill2" then
        self.RealSetSkill2 = self.Text04:ShowTextPC("Guide_UI_Skill2_PC", "Guide_UI_Skill2_Gamepad")
    elseif ActionName == "Skill3" then
        --self.RealSetSkill3 = self.Text04:ShowTextPC("Guide_UI_Skill3_PC", "Guide_UI_Skill3_Gamepad")
    elseif ActionName == "Skill2Attack" then
        self.Arrow:SetVisibility(UE4.ESlateVisibility.Visible)
        self.RealSetSkill2Attack = self.Text05:ShowTextPC("Guide_UI_Skill2Attack_PC", "Guide_UI_Skill2Attack_PC")
    end
end

function M:ShowActionTextMobile(ActionName)
    if ActionName == "SpiralLeap" then
        self.RealSetSpiralLeap = self.One:GetVisibility() ~= UE4.ESlateVisibility.Visible
        self.One:SetVisibility(UE4.ESlateVisibility.Visible)
        self.Text01:SetText(GText("Guide_UI_SpiralLeap_Mobile"))
    elseif ActionName == "Dodge" then
        self.RealSetDodge = self.Two:GetVisibility() ~= UE4.ESlateVisibility.Visible
        self.Two:SetVisibility(UE4.ESlateVisibility.Visible)
        self.Text02:SetText(GText("Guide_UI_Dodge_Mobile"))
    elseif ActionName == "Skill1" then
        self.RealSetSkill1 = self.Three:GetVisibility() ~= UE4.ESlateVisibility.Visible
        self.Three:SetVisibility(UE4.ESlateVisibility.Visible)
        self.Text03:SetText(GText("Guide_UI_Skill1_Mobile"))
    elseif ActionName == "Skill2" then
        self.RealSetSkill2 = self.Four1:GetVisibility() ~= UE4.ESlateVisibility.Visible
        self.Four1:SetVisibility(UE4.ESlateVisibility.Visible)
        self.Text04:SetText(GText("Guide_UI_Skill2_Mobile"))
    elseif ActionName == "Skill3" then
        -- self.RealSetSkill3 = self.Four1:GetVisibility() ~= UE4.ESlateVisibility.Visible
        -- self.Four1:SetVisibility(UE4.ESlateVisibility.Visible)
        -- self.Text04:SetText(GText("Guide_UI_Skill3_Mobile"))
    elseif ActionName == "Skill2Attack" then
        self.RealSetSkill2Attack = self.Four2:GetVisibility() ~= UE4.ESlateVisibility.Visible
        self.Four2:SetVisibility(UE4.ESlateVisibility.Visible)
        self.Arrow:SetVisibility(UE4.ESlateVisibility.Visible)
        self.Text05:SetText(GText("Guide_UI_Skill2Attack_Mobile"))
    end
end

function M:HideActionText(ActionName)
    local Platform = CommonUtils:GetDeviceTypeByPlatformName(self)
    if Platform == "PC" then
        self:HideActionTextPC(ActionName)
    else
        self:HideActionTextMobile(ActionName)
    end
end

function M:HideActionTextPC(ActionName)
    if ActionName == "SpiralLeap" then
        self.RealSetSpiralLeap = self.Text01:HideTextPC()
    elseif ActionName == "Dodge" then
        self.RealSetDodge = self.Text02:HideTextPC()
    elseif ActionName == "Skill1" then
        self.RealSetSkill1 = self.Text03:HideTextPC()
    elseif ActionName == "Skill2" then
        self.RealSetSkill2 = self.Text04:HideTextPC()
    elseif ActionName == "Skill2Attack" then
        self.RealSetSkill2Attack = self.Text05:HideTextPC()
        self.Arrow:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function M:HideActionTextMobile(ActionName)
    if ActionName == "SpiralLeap" then
        self.RealSetSpiralLeap = self.One:GetVisibility() ~= UE4.ESlateVisibility.Collapsed
        self.One:SetVisibility(UE4.ESlateVisibility.Collapsed)
    elseif ActionName == "Dodge" then
        self.RealSetDodge = self.Two:GetVisibility() ~= UE4.ESlateVisibility.Collapsed
        self.Two:SetVisibility(UE4.ESlateVisibility.Collapsed)
    elseif ActionName == "Skill1" then
        self.RealSetSkill1 = self.Three:GetVisibility() ~= UE4.ESlateVisibility.Collapsed
        self.Three:SetVisibility(UE4.ESlateVisibility.Collapsed)
    elseif ActionName == "Skill2" then
        self.RealSetSkill2 = self.Four1:GetVisibility() ~= UE4.ESlateVisibility.Collapsed
        self.Four1:SetVisibility(UE4.ESlateVisibility.Collapsed)
    elseif ActionName == "Skill2Attack" then
        self.RealSetSkill2Attack = self.Four2:GetVisibility() ~= UE4.ESlateVisibility.Collapsed
        self.Four2:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Arrow:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function M:ShowActionKeyAndText(ActionName)
    if self.Key == nil then
        return
    end
    self.Key.Main:SetRenderOpacity(1)
    -- if ActionName == "Attack" or ActionName == "MoveCamera" then
    --     -- self.Key.Switch_Type:SetActiveWidgetIndex(1)
    --     -- self.key.Key_Plus:SetVisibility(ESlateVisibility.Collapsed)
    --     -- self.key.Key02_Img:SetVisibility(ESlateVisibility.Collapsed)
    --     if ActionName == "Attack" then
    --         self.Key.Switch_Type:SetActiveWidgetIndex(2)
    --         local KeyName = CommonUtils:GetActionMappingKeyName(ActionName)
    --         local Res = self.Key.Key_Img:SetImageByInstruction(KeyName)
    --         if not Res then
    --             local TextKey = CommonUtils:GetKeyText(KeyName)
    --             self.Key.Switch_Type:SetActiveWidgetIndex(0)
    --             self.Key.Key_Text.Text_Key:SetText(TextKey)
    --         end
    --     end
    -- else
    if ActionName == "MoveCamera" then
        self.Key.Switch_Type:SetActiveWidgetIndex(1)
        self.key.Key_Plus:SetVisibility(ESlateVisibility.Collapsed)
        self.key.Key02_Img:SetVisibility(ESlateVisibility.Collapsed)
        local Obj = LoadObject("Texture2D'/Game/UI/Texture/Dynamic/Atlas/Instruction/T_Key_Mouse_L.T_Key_Mouse_L'")
        self.Key.Key_Img.Img:SetBrushResourceObject(Obj)
        local Size = FVector2D(Obj:Blueprint_GetSizeX(), Obj:Blueprint_GetSizeY())
        self.Key.Key_Img.Img:SetBrushSize(Size)
    else
        local KeyName = CommonUtils:GetActionMappingKeyName(ActionName)
        local FixPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Instruction/T_Key_%s_L.T_Key_%s_L'"
        local ReplaceKey = string.gsub(KeyName, " ", "_")
        if DataMgr.KeyboardText[ReplaceKey] then
            ReplaceKey = DataMgr.KeyboardText[ReplaceKey].KeyText
        end
        local ImgPath = string.format(FixPath, ReplaceKey, ReplaceKey)
        local Img = LoadObject(ImgPath)
        if (not IsValid(Img)) then
            local TextKey = CommonUtils:GetKeyText(KeyName)
            self.Key.Switch_Type:SetActiveWidgetIndex(0)
            self.Key.Key_Text.Text_Key:SetText(TextKey)
        else
            self.Key.Switch_Type:SetActiveWidgetIndex(1)
            self.key.Key_Plus:SetVisibility(ESlateVisibility.Collapsed)
            self.key.Key02_Img:SetVisibility(ESlateVisibility.Collapsed)
            self.Key.Key_Img:SetImageByInstruction(KeyName)
        end
    end
        
        -- local TextKey = CommonUtils:GetKeyText(CommonUtils:GetActionMappingKeyName(ActionName))
        -- self.Key.Switch_Type:SetActiveWidgetIndex(0)
        -- self.Key.Key_Text.Text_Key:SetText(TextKey)
    --end
    self.Key.VX_guide_Sq1:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    if not self.IsByStl then
        self.key:PlayAnimation(self.Key.Loop, 0, 0)
    end
end

function M:ShowActionKeyAndTextByGamePad(ActionName)
    if self.Key == nil then
        return
    end
    self.Key.Main:SetRenderOpacity(1)
    if ActionName == "MoveCamera" then
        self.Key.Key_Img:SetImageByInstruction("R")
        --self.key:PlayAnimation(self.Key.Loop, 0, 0)
        return
    end
    local List = UIUtils.GetIconListByActionName(ActionName)
    self.Key.Switch_Type:SetActiveWidgetIndex(1)
    self.key.SizeBox_1:SetVisibility(ESlateVisibility.Visible)
    if List then
        if #List >= 2 then --组合键
            self.Key.Key_Img:SetImageByInstruction(List[1])
            self.key.Key_Plus:SetVisibility(ESlateVisibility.Visible)
            self.key.Key02_Img:SetVisibility(ESlateVisibility.Visible)
            self.key.Key02_Img:SetImageByInstruction(List[2])
        else
            self.Key.Key_Img:SetImageByInstruction(List[1])
            self.key.Key_Plus:SetVisibility(ESlateVisibility.Collapsed)
            self.key.Key02_Img:SetVisibility(ESlateVisibility.Collapsed)
        end

        self.key.VX_guide_Cirle1:SetVisibility(ESlateVisibility.Visible)
        self.key.VX_guide_Cirle2:SetVisibility(ESlateVisibility.Visible)
        if not self.IsByStl then
            self.key:PlayAnimation(self.Key.Loop, 0, 0)
        end

    end

end

function M:SetActionText(ActionName)
    if ActionName == "Attack" then
        self.Key.Text_Describe:SetText(GText("Guide_HighlightButton_Attack"))
    elseif ActionName == "MoveCamera" then
        self.Key.Text_Describe:SetText(GText("Guide_HighlightButton_MoveCamera"))
    elseif ActionName == "Skill1" then
        self.Key.Text_Describe:SetText(GText("Guide_HighlightButton_Skill1"))
    elseif ActionName == "Skill2" then
        self.Key.Text_Describe:SetText(GText("Guide_HighlightButton_Skill2"))
    elseif ActionName == "Skill3" then
        self.Key.Text_Describe:SetText(GText("Guide_HighlightButton_Skill3"))
    elseif self.SkillType == "Interactive" then
        self.Key.Text_Describe:SetText(GText("MESSAGE_TITLE_LOADING_21_PC"))
    elseif self.SkillType == "Slide" then
        self.Key.Text_Describe:SetText(GText("Guide_HighlightButton_Crouch"))           
    end
end


function M:OnChangeKeyBoardSet()
    local bIsGamepad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
    if bIsGamepad then
        self.UsingGamepad = true
        self:ShowActionKeyAndTextByGamePad(self.SkillType)
    else
        self.UsingGamepad = false
        self:ShowActionKeyAndText(self.SkillType)
    end
end

----------------------手柄-----------------------------
function M:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice) 
    end
end

function M:RefreshBaseInfo()
    -- 刷新一些基础信息
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end
    --- 切换手柄端相关图标显隐
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if (IsUseKeyAndMouse) then
        self.UsingGamepad = false
        self:ShowActionKeyAndText(self.SkillType)
    else
        self.UsingGamepad = true
        self:ShowActionKeyAndTextByGamePad(self.SkillType)
    end
end



return M
