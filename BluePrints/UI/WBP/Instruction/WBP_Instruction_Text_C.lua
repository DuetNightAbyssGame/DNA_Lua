--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Instruction_Text_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

function M:Construct()
    self.Overridden.Construct(self)
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnUpdateUIStyleByInputTypeChange)
    EventManager:AddEvent(EventID.OnChangeKeyBoardSet,self,self.OnChangeKeyBoardSet)
end

function M:Destruct()
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnUpdateUIStyleByInputTypeChange)
    EventManager:RemoveEvent(EventID.OnChangeKeyBoardSet, self) 
end

function M:OnChangeKeyBoardSet()
    self:RefreshText()
end

function M:ShowTextPC(PCMessage, GamePadMessage)
    self:OnUpdateUIStyleByInputTypeChange(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    local VisibleType = self:GetVisibility()
    self:SetVisibility(UE4.ESlateVisibility.Visible)
    self.PCMessage = PCMessage
    self.GamePadMessage = GamePadMessage
    if self.UsingGamepad then
        self:SetText(GText(self.GamePadMessage))
    else
        self:SetText(GText(self.PCMessage))
    end

    self:PlayAnimation(self.In)
    return VisibleType ~= UE4.ESlateVisibility.Visible
end

function M:HideTextPC()
    local VisibleType = self:GetVisibility()
    local End = function() self:SetVisibility(UE4.ESlateVisibility.Collapsed) end
    self:BindToAnimationFinished(self.Out, {self, End})
    self:PlayAnimation(self.Out)
    return VisibleType ~= UE4.ESlateVisibility.Collapsed
end

function M:RefreshText()
    if self.UsingGamepad then
        if self.GamePadMessage == nil then
            return
        end
        self:SetText(GText(self.GamePadMessage))
    else
        if self.PCMessage == nil then
            return
        end
        self:SetText(GText(self.PCMessage))
    end
    --self:SetText(GText(self.Message))
end

function M:SetText(MessageContent)
    local strs = self:AnalyzeText(MessageContent)
    for i = 1,7 do
        local ui_index = i - i//2
        if not strs[i] or strs[i] == "" then
            if i%2 == 1 then
                self["Text_Content_"..ui_index]:SetVisibility(UE4.ESlateVisibility.Collapsed)
            else
                self["Key_"..ui_index]:SetVisibility(UE4.ESlateVisibility.Collapsed)
            end
        else
            if string.find(strs[i], "&") then
                self:SetCommonKey(strs[i], i)
                self["Key_"..ui_index]:SetVisibility(UE4.ESlateVisibility.Visible)
            else
                self["Text_Content_"..ui_index]:SetText(strs[i])
                self["Text_Content_"..ui_index]:SetVisibility(UE4.ESlateVisibility.Visible)
            end
        end
    end
end

function M:SetCommonKey(KeyInfo, TableIndex)
    local KeyType = nil
    local ActionName = string.sub(KeyInfo, 2, -2)
    local bplayLoopAnim = false
    if string.match(ActionName, "#%w+#") then
        bplayLoopAnim = true
        ActionName = string.gsub(ActionName, "#", "")
    end
    local Key = nil
    local UIIndex = nil
    Key, KeyType = self:GetKeyName(ActionName)
    -- if self.UsingGamepad == false then
    --     local RealKey = CommonUtils:GetKeyText(CommonUtils:GetActionMappingKeyName(ActionName))
    --     Key = RealKey
    -- end
    UIIndex = TableIndex - TableIndex//2
    local Widget = nil
    if not Key or not KeyType then
        print(_G.LogTag, "Error: Wrong Action Name, cannot find this Action's Key")
        return
    end
    if KeyType == "KeyboardKey" then
        Widget = UE4.UWidgetBlueprintLibrary.Create(self, self:GetCommonKeyBlueprint(true))
        Widget:CreateCommonKey({
            KeyInfoList = {
                {
                    Type = "Text",
                    Text = Key,
                }
            },
        })
        self["Key_"..UIIndex]:ClearChildren()
        self["Key_"..UIIndex]:AddChild(Widget)
    elseif KeyType == "MouseButton" or KeyType == "GamepadKey" then
        -- if not self["Common_Key_"..UIIndex]:SetImgInfo(Key) then
        --     self:DeleteGuideMessage()
        -- end
        if KeyType  == "GamepadKey" then
             Widget = UE4.UWidgetBlueprintLibrary.Create(self, self:GetCommonKeyBlueprint(false))
            -- Widget:CreateCommonKey({
            --     KeyInfoList = {
            --         {
            --             Type = "Text",
            --             Text = Key,
            --         }
            --     },
            -- })
            Widget:CreateCommonKey({
                KeyInfoList = {
                    {
                        Type = "Img",
                        ImgShortPath = Key,
                    }
                },
            })
        else
            Widget = UE4.UWidgetBlueprintLibrary.Create(self, self:GetCommonKeyBlueprint(true))
            Widget:CreateCommonKey({
                KeyInfoList = {
                    {
                        Type = "Text",
                        Text = Key,
                    }
                },
            })
        end

        self["Key_"..UIIndex]:ClearChildren()
        self["Key_"..UIIndex]:AddChild(Widget)
    end

    if Widget and bplayLoopAnim then
        Widget:PlayAnimation(Widget.Remind)
    end
end

function M:GetKeyName(ActionName)
    local InputSetting = UE4.UInputSettings.GetInputSettings()
    local ActionKeys = UE4.TArray(UE4.FInputActionKeyMapping)
    InputSetting:GetActionMappingByName(ActionName, ActionKeys)
    local CurrentInputDevice = {"KeyboardKey","MouseButton"}
    for i,KeyMap in pairs(ActionKeys) do
        local key = KeyMap.Key
        for i,v in pairs(CurrentInputDevice) do
            if self.UsingGamepad then
                if string.find(KeyMap.Key.KeyName,'Gamepad') == nil then
                    local List = UIUtils.GetIconListByActionName(ActionName)
                    return List[#List], "GamepadKey"
                elseif string.find(KeyMap.Key.KeyName,'Gamepad') ~= nil then
                    local List = UIUtils.GetIconListByActionName(ActionName)
                    return List[#List], "GamepadKey"
                end
            elseif UE4.UKismetInputLibrary["Key_Is"..v](key) then
                local res = UE4.UFormulaFunctionLibrary.Key_GetFName(key)
                local res_TextMap_index = string.gsub(res," ","_")
                res = res_TextMap_index
                return res, v
            end
        end
    end
    return nil, nil
end

function M:GetCommonKeyBlueprint(bText) 
    if(bText) then
        return UE4.UClass.Load("WidgetBlueprint'/Game/UI/WBP/Common/Key/WBP_Com_KeyText.WBP_Com_KeyText_C'")
    else
        return UE4.UClass.Load("WidgetBlueprint'/Game/UI/WBP/Common/Key/WBP_Com_KeyImg.WBP_Com_KeyImg_C'")
    end
end

function M:AnalyzeText(MessageContent)
    local match_res = {}
    local match_word = string.gmatch(MessageContent, "&.[^&]*&")
    for word in match_word do
        local start_index, end_index = string.find(MessageContent, word)
        table.insert(match_res, string.sub(MessageContent, 1, start_index - 1))
        table.insert(match_res, word)
        MessageContent = string.sub(MessageContent, end_index + 1)
    end
    table.insert(match_res, MessageContent)
    return match_res
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    if (CurInputType == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end
    --- 切换手柄端相关图标显隐
    local IsUseKeyAndMouse = CurInputType == ECommonInputType.MouseAndKeyboard
    if (IsUseKeyAndMouse) then
        self.UsingGamepad = false
        self:RefreshText()
    else
        self.UsingGamepad = true
        self:RefreshText()
    end
end


return M
