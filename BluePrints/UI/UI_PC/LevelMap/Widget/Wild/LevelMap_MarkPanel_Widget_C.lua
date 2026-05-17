--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local HeroUSDKUtils = require "Utils.HeroUSDKUtils"

---@type LevelMap_Mark_Widget_PC_C
local M = Class({"BluePrints.Common.TimerMgr","BluePrints.UI.BP_EMUserWidget_C"})

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()
    self.Btn_Erase:BindEventOnClicked(self,self.OnMarkDelete)
    -- self.Btn_Cancel:BindEventOnClicked(self,self.OnMarkDelete)
    self.Btn_Confirm:BindEventOnClicked(self,self.OnMarkConfirm)
    self.Btn_Track:BindEventOnClicked(self,self.OnMarkTrack)
    self.Btn_Erase:SetIconPanelVisibility(ESlateVisibility.SelfHitTestInvisible)
    -- self.Btn_Cancel:SetIconPanelVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Btn_Confirm:SetIconPanelVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Btn_Track:SetIconPanelVisibility(ESlateVisibility.SelfHitTestInvisible)
    -- self.InputBox.Text_Input.OnTextChanged:Add(self,self.OnTextChanged)
    self.Text_Title:SetText(GText('UI_RegionMap_Mark'))
    self.Btn_Confirm:SetText(GText('UI_RegionMap_Mark'))
    self.Text_Max:SetText('/'..math.floor(DataMgr.GlobalConstant['MaxMapMarkIcon'].ConstantValue))
    self.Btn_Erase:SetText(GText('UI_RegionMap_Delete'))
    self.Btn_Erase:SetDefaultGamePadImg("Y")
    self.Btn_Confirm:TryOverrideSoundFunc(self.OnMarkDeleteSound)
    -- self.Btn_Cancel:SetText(GText('UI_RegionMap_Cancel'))
    self.MaxNum=12
    self.CurrentSensitive=0
    -- self.InputBox.Text_Max:SetText('/'..self.MaxNum)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(UGameplayStatics.GetPlayerController(self, 0))
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnUpdateUIStyleByInputTypeChange) 

    self.TypeTable={}
    self.TypeId2Image={}
    self.DefaultTypeId=nil
    local count=0
    for id,data in pairs(DataMgr.MapMarkIcon) do
        if data.MarkIconPath then
            local image=LoadObject(data.MarkIconPath.Panel)
            if image then
                if not self.DefaultTypeId then
                    self.DefaultTypeId=id
                end
                local markType=self:NewMarkType()
                self.TypeTable[id]=markType
                self.TypeId2Image[id]=data.MarkIconPath.Point
                markType.Img_Mark:SetBrushFromTexture(image)
                markType.Switch:SetActiveWidgetIndex(0)
                markType.Btn.OnClicked:Add(self,function()
                    AudioManager(self):PlayUISound(self, "event:/ui/common/click", "", nil)
                    self:OnTypeClicked(id)
                end)
                markType:SetNavigationRuleBase(EUINavigation.Up, count < 5 and EUINavigationRule.Stop or EUINavigationRule.Escape)
                markType.Parent = self
                count=count+1
            end
        end
    end
    for i=count+1,10 do
        local markType=self:NewMarkType()
        markType.Switch:SetActiveWidgetIndex(1)
        self.TypeTable[i*-100]=markType
    end
end

function M:Destruct()
    -- self.InputBox.Text_Input.OnTextChanged:Clear()
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnUpdateUIStyleByInputTypeChange) 
    for _,markType in pairs(self.TypeTable) do
        markType.Btn.OnClicked:Clear()
        markType:RemoveFromParent()
    end
    self.TypeId2Image={}
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Open(Id,Data,MarkHitName,TypeId,Tracking, RegionIcon)
    self.SaveSensitive = 0
    self.CurrentId = Id
    self.CurrentData = Data
    local MarkName = Data.Name and Data.Name or ''
    self.IsVisible=true
    -- self.Focused = false
    self:StopAllAnimations()
    self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self:PlayAnimation(self.Auto_In)

    self.Btn_Erase:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    local avatar=GWorld:GetAvatar()
    self.Text_MarkNum:SetText(GText('UI_RegionMap_MarkedNum')..avatar:GetCurrentMarkCount())
    self.Com_Input_Light:Init({Owner=self, TextLimit=self.MaxNum,HintText=MarkHitName,OnTextChanged=self.OnTextChanged})
    -- self.Com_Input_Light.Text_Input:SetHintText(MarkHitName)
    self.Com_Input_Light:SetText(MarkName)
    -- if MarkName~='' then
    --     local NameLength, RealName, IllegalRange, ErrorType = self:CheckNameLegal(MarkName)
    --     self:SetTextNum(NameLength)
    -- else
    --     self:SetTextNum(0)
    -- end
    -- self.Btn_Confirm:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.LastText=MarkName
    if MarkName=='' then
        self.Switch_Button:SetActiveWidgetIndex(0)
    else
        self.Switch_Button:SetActiveWidgetIndex(1)
    end
    -- if IsTempMark then

    -- else
    --     self.Btn_Confirm:SetVisibility(ESlateVisibility.Collapsed)
    -- end

    if TypeId then
        self:OnTypeClicked(TypeId)
        self.TypeTable[TypeId]:StopAllAnimations()
        self.TypeTable[TypeId]:PlayAnimation(self.TypeTable[TypeId].Click)
        self.TypeTable[TypeId]:SetFocus()
    else
        self:OnTypeClicked(self.DefaultTypeId)
        self.TypeTable[self.DefaultTypeId]:StopAllAnimations()
        self.TypeTable[self.DefaultTypeId]:PlayAnimation(self.TypeTable[self.DefaultTypeId].Click)
        self.TypeTable[self.DefaultTypeId]:SetFocus()
    end
    if Tracking then
        self.Btn_Track:SetText(GText('UI_RegionMap_Untrack'))
    else
        self.Btn_Track:SetText(GText('UI_RegionMap_Track'))
    end
    if RegionIcon then
        local Icon = LoadObject(RegionIcon)
        if Icon then
            self.Icon_Camp:SetBrushResourceObject(Icon)
        end
    end
end

function M:Close(NeedCheck)
    if not self.IsVisible then
        return
    end
    self.IsVisible=false
    self:StopAllAnimations()
    self:PlayAnimation(self.Auto_Out)
    self.IsNewMark=false
    self:OnMarkNameConfirm(NeedCheck)
end

function M:OnAnimationFinished(Animation)
    if Animation==self.Auto_Out then
        self:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:OnMarkDeleteSound()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_cancel", "", nil)
end

function M:OnMarkDelete()
    self.Parent:DeleteMark()
    -- self.Btn_Erase:SetVisibility(ESlateVisibility.Collapsed)
end

function M:OnMarkConfirm()
    -- AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", "", nil)
    -- local name=self.InputBox.Text_Input:GetText()
    -- if not name or name=='' then
    --     name=self.InputBox.Text_Input.HintText
    -- end
    -- self.Parent:OnMarkConfirm(name)
    -- local avatar=GWorld:GetAvatar()
    -- self.Text_MarkNum:SetText(GText('UI_RegionMap_MarkedNum')..avatar:GetCurrentMarkCount())
    self.IsNewMark=true
    self:OnMarkNameConfirm(true)
end

function M:OnMarkTrack()
    self.Parent:OnMarkTrack()
end

function M:OnMarkNameConfirm(NeedCheck)
    self.ConfirmName=self.Com_Input_Light:GetText()
    if not self.ConfirmName or self.ConfirmName=='' then
        self.ConfirmName=self.Com_Input_Light.Text_Input.HintText
    end
    if NeedCheck then
        self:CheckSensitive()
    else
        self.Parent:OnMarkNameConfirm(nil,nil)
    end
end

function M:OnTypeClicked(TypeId)
    self.TypeTable[TypeId].IsSelected=true
    if self.LastMarkType and self.LastMarkType~=self.TypeTable[TypeId] then
        self.LastMarkType.IsSelected=false
        self.LastMarkType:PlayAnimation(self.LastMarkType.Normal)
    end
    self.LastMarkType=self.TypeTable[TypeId]
    self.Parent:ChangeMarkType(TypeId,self.TypeId2Image[TypeId])
end

function M:SetDefaultType()
    if self.DefaultTypeId then
        self:OnTypeClicked(self.DefaultTypeId)
        -- self.Parent:ChangeMarkType(self.DefaultTypeId,self.TypeId2Image[self.DefaultTypeId])
    end
end

function M:CheckCharInAnyRange(NewName, i, AllRange)
    local CharByte1 = string.byte(NewName, i)
    local CharByte2 = string.byte(NewName, i + 1)
    local CharByte3 = string.byte(NewName, i + 2)
    for i, Range in pairs(AllRange) do
        if self:ContainsCJK(CharByte1, CharByte2, CharByte3, Range) then
            return true
        end
    end
    return false
end

function M:ContainsCJK(CharByte1, CharByte2, CharByte3, Range)
    local ByteNum = CharByte1*16^4 + CharByte2*16^2 + CharByte3
    -- 检查字符是否在范围内
    if ByteNum >= Range[1] and ByteNum <= Range[2] then
        return true
    end

    return false
end

function M:OnTextChanged(NewName)
    local SpaceNum = 0
    NewName, SpaceNum = string.gsub(NewName, "%s", "")
    if SpaceNum > 0 then
        self.Com_Input_Light:SetText(NewName)
        return
    end
    if NewName == "" then
        -- self:SetTextNum(0)
        return
    end
    --Length为为-2：含有不合法字符
    local NameLength, RealName, IllegalRange, ErrorType = self:CheckNameLegal(NewName)
    RealName = string.gsub(RealName, "%s", "")
    local subName=""
    if ErrorType == -2 then
        local lastIndex=1
        for _,temp in pairs(IllegalRange) do
            subName=subName..string.sub(RealName,lastIndex,temp[1]-1)
            lastIndex=temp[2]+1
        end
        subName=subName..string.sub(RealName,lastIndex)
        self.Com_Input_Light:SetText(subName)
    else
        subName=RealName
    end
    -- self:SetTextNum(NameLength-#IllegalRange)
    if NameLength >= self.MaxNum then
        self.Com_Input_Light:SetText(subName)
    end
end

function M:CheckSensitive()
    self.CurrentSensitive = self.CurrentSensitive + 1
    self.SaveSensitive = self.CurrentSensitive
    HeroUSDKUtils.CheckStringSensitive(self, self.ConfirmName, self.OnNameSensitive, self.OnNameNotSensitive)
end

function M:OnNameSensitive()
    -- self.Com_Input_Light:ShowTips(GText("UI_REGISTER_BANNEDINPUT"))
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_REGISTER_BANNEDINPUT"))
end

function M:OnNameNotSensitive()
    if self.SaveSensitive ~= self.CurrentSensitive then
        return
    end
    if self.IsNewMark then
        self.Parent:OnMarkConfirm(self.ConfirmName)
    else
        if self.CurrentData.Name ~= self.ConfirmName then
            self.CurrentData.Name = self.ConfirmName
            self.Parent:OnMarkNameConfirm(self.CurrentId,self.CurrentData)
        end
    end
end

local CjkUTFRanges = {
    {0xE280A6, 0xE280A6},  -- ……
    {0xE28093, 0xE2809D},  -- 一些标点符号
    {0xE38081, 0xE38095},  -- 一些标点符号
    {0xE4B880, 0xEFBC9F},  -- 中文字符范围
    {0xEAB080, 0xED9EAF},  -- 韩文字符范围
    {0xE38080, 0xE38FBF}   -- 日文字符范围
}

local DoubleByteRanges = {
    {0xC2B7, 0xC2B7},  -- ·
}

--返回值 ErrorType为-2：含有不合法字符
function M:CheckNameLegal(NewName)
    local IllegalRange = {}
    local SpaceRange = {}
    local RealName = NewName
    local NameLength = 0
    local ErrorType = 0
    local i = 1
    while true do
        local CurByte = string.byte(NewName, i)
        local ByteNum = 1
        if CurByte >= 240 then
            ByteNum = 4
            table.insert(IllegalRange, {i, i+3})
        elseif CurByte >= 224 then
            if not self:CheckCharInAnyRange(NewName, i, CjkUTFRanges) then
                table.insert(IllegalRange, {i, i+2})
            end
            ByteNum = 3
        elseif CurByte >= 192 then
            ByteNum = 2
            if not self:CheckDoubleCharInAnyRange(NewName, i, DoubleByteRanges) then
                table.insert(IllegalRange, {i, i+1})
            end
        else
            if CurByte < 32 or CurByte > 126 then
                table.insert(IllegalRange, {i, i})
            end
            ByteNum = 1
        end

        NameLength = NameLength + 1
        --字符串长度判断，最长12
        if NameLength > self.MaxNum then
            RealName = string.sub(NewName, 1, i - 1)
            break
        end
        i = i + ByteNum
        if i > #NewName then
            break
        end
    end
    if #IllegalRange > 0 then
        ErrorType = -2
    end

    -- PrintTable(IllegalRange, 10)
    return NameLength, RealName, IllegalRange, ErrorType
end

function M:CheckDoubleCharInAnyRange(NewName, i, AllRange)
    local CharByte1 = string.byte(NewName, i)
    local CharByte2 = string.byte(NewName, i + 1)
    for i, Range in pairs(AllRange) do
        if self:ContainsDoubleChar(CharByte1, CharByte2, Range) then
            return true
        end
    end
    return false
end

function M:ContainsDoubleChar(CharByte1, CharByte2, Range)
    local ByteNum = CharByte1*16^2 + CharByte2
    -- 检查字符是否在范围内
    if ByteNum >= Range[1] and ByteNum <= Range[2] then
        return true
    end

    return false
end

-- function M:SetTextNum(Num)
--     self.InputBox.Text_Num:SetText(Num)
--     local Color='FFFFFF4C'
--     if Num>=self.MaxNum then
--         Color='DD1C4599'
--     end
--     self.InputBox.Text_Num:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor(Color))
-- end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local SwitchIndex = self.Switch_Button:GetActiveWidgetIndex()
    if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
        if SwitchIndex == 0 then
            self:OnMarkConfirm()
        elseif SwitchIndex == 1 then
            self:OnMarkTrack()
        end
        return UWidgetBlueprintLibrary.Handled()
    elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
        if SwitchIndex == 1 then
            self:OnMarkDelete()
            UWidgetBlueprintLibrary.Handled()
        end
    elseif InKeyName == "Escape" or InKeyName == UIConst.GamePadKey.FaceButtonRight then
        -- if not self.Focused and self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
        --     self:SetFocus()
        -- else
            self.Parent:ClosePanel()
        -- end
    elseif InKeyName == UIConst.GamePadKey.FaceButtonLeft then
        self.Com_Input_Light:SetFocus()
    elseif InKeyName == UIConst.GamePadKey.LeftThumb then
        self.Com_Input_Light:SetText('')
        self.Com_Input_Light:SetFocus()
    end
    return UWidgetBlueprintLibrary.Handled()
end

-- function M:OnFocusReceived(MyGeometry, InFocusEvent)
--     self.Focused = true
-- end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    if CurInputDevice == ECommonInputType.Gamepad then
        self.LastMarkType:SetFocus()
    else
    end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if self.LastMarkType then
        self.LastMarkType:SetFocus()
    end
    return UWidgetBlueprintLibrary.Handled()
end

return M
