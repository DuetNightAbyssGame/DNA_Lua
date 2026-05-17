--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Chapter_Transition03_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end
 
function M:Destruct()
    self:SetInputUIOnly(false)
    self.Super.Destruct(self)
end

function M:OnLoaded(...)
    self.QuestUIId, self.Type = ...
    self.Info = DataMgr.QuestUI[self.QuestUIId]
    self.Text_SubTitle:SetTexT(GText(self.Info.ChapterName))
    self.Text_Title:SetTexT(GText(self.Info.CantoName))
    local IconDynaMaterial = self.Image_TitleIcon:GetDynamicMaterial()
    if(IconDynaMaterial)then
        IconDynaMaterial:SetTextureParameterValue("Mask2",LoadObject(self.Info.IconPath))    
    end
    local VXIconDynaMaterial = self.TitleIcon_VX:GetDynamicMaterial()
    if(VXIconDynaMaterial)then
        VXIconDynaMaterial:SetTextureParameterValue("Mask2",LoadObject(self.Info.IconPath))    
    end
    self.Text_Tips:SetTexT(GText("UI_GACHA_NEXT"))
    self:SetInputUIOnly(true)
    if self.Type == "Start" then
        self.Text_Desc:SetTexT(GText("UI_Quest_ChapterStart"))
        self:PlayAnimation(self.In)
        AudioManager(self):PlayUISound(self,self.Info.AudioPath , "Open", nil)
        local EndTime = self.In:GetEndTime()
        self:AddTimer(EndTime, function()
            self.Out:BindToAnimationFinished(self, {self, function()
                AudioManager(self):SetEventSoundParam(self, "Open", {ToEnd = 1})
                self:OnClose()
            end})
            self:PlayAnimation(self.Out)
        end, false, 0, nil, true)
    else
        AudioManager(self):PlayUISound(self,self.Info.AudioPathFinal , "Close", nil)
        self.Text_Desc:SetTexT(GText("UI_Quest_ChapterFinish"))
        self.bClick = false
        local EndTime = self.End_In:GetEndTime()
        self.End_In:BindToAnimationFinished(self, {self, function()
            self.bClick = true
        end})
        self:PlayAnimation(self.End_In)
        self.Btn_FullClose.OnClicked:Add(self, self.OnClick)
    end
    self.Key_Tips:CreateCommonKey({
    KeyInfoList={
        {
            Type = "Img",
            ImgShortPath = "A",
        }
    },
    })  
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnUpdateUIStyleByInputTypeChange)
    self:OnUpdateUIStyleByInputTypeChange(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
end

function M:OnClick()
    if self:IsPlayingAnimation(self.Out) then
        return
    end
    if self.bClick then
        AudioManager(self):PlayUISound(self,"event:/ui/common/special_content_01_click" , nil, nil)     
        self.Out:BindToAnimationFinished(self, {self, function()
                AudioManager(self):SetEventSoundParam(self, "Close", {ToEnd = 1}) 
                self:OnClose()
            end})
        self:PlayAnimation(self.Out)
    end
end

function M:OnClose()
    self:Close()
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    if (CurInputType == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end
    --- 切换手柄端相关图标显隐
    local IsUseKeyAndMouse = CurInputType == ECommonInputType.MouseAndKeyboard
    if (IsUseKeyAndMouse) then
        self.Text_Tips:SetTexT(GText("UI_GACHA_NEXT"))
        self.Key_Tips:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        self.Text_Tips:SetTexT(GText("UI_CTL_Continue"))
        self.Key_Tips:SetVisibility(UE4.ESlateVisibility.visible)
        self:SetFocus()
    end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == "Gamepad_FaceButton_Bottom" and self.bClick then
        self:OnClose()
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end



return M
