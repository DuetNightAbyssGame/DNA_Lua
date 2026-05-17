-- 局外Buff详情
require "UnLua"
local UIUtils = require "Utils.UIUtils"
local View =
    Class(
    {
        "BluePrints.UI.BP_UIState_C",
        "BluePrints.Common.TimerMgr"
    }
)
local Model = require "BluePrints.UI.AutoChess.AutoChessDataModel"

function View:OnLoaded(MissionId)
    self:BindBtnEvent()
    self:Init(MissionId)
end

function View:SequenceEvent_PlayListAnim()
    if self.MissionData and #self.MissionData > 0 then
        -- self.List_Buff:RequestPlayEntriesAnim()
        for index = 1, #self.MissionData do
            local Obj = NewObject(UIUtils.GetCommonItemContentClass())
            local Row = DataMgr.AutoChessBuff[self.MissionData[index]]
            if Row then
                Obj.BuffName = GText(Row.BuffName)
                Obj.BuffDes = GText(Row.BuffDes)
                Obj.BuffIcon = Row.BuffIcon
                self.List_Buff:AddItem(Obj)
            else
                DebugPrint(ErrorTag, "传入的AutoChessBuff主键非法")
            end
        end
    else
        DebugPrint(ErrorTag, "MissionData 无效或长度小于等于 0，无法执行循环。")
    end
end

function View:Init(MissionId)
    self.List_Buff:ClearListItems()

    self:OnUpdateUIStyleByInputTypeChange()

    local MissionData = Model:GetBuffsByMissionId(MissionId)
    if MissionData then
        self.MissionData = MissionData
    else
        DebugPrint("-----------------------MissionData nil--------------------------")
    end

    self.Text_Title:SetText(GText("UI_AutoChess_CurrentBuff"))
    self.Text_Tip:SetText(GText("UI_TRAIN_CLOSE"))
    if self.Key_Back then
        self.Key_Back:CreateCommonKey(
            {
                KeyInfoList = {
                    {
                        Type = "Text",
                        Text = "Esc"
                    }
                },
                Desc = GText("UI_Tips_Close")
            }
        )
    end
    self:PlayAnimation(self.In)
    AudioManager(self):PlayUISound(self, "event:/ui/roguelike/affix_info_panel_show", "BuffDetailPanelSfx", nil)
    self:SetFocus()
end

function View:OnAnimationFinished(Animation)
    if Animation == self.Out then
        self:Close()
    end
end

function View:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    if UIUtils.IsKeyboardInput() then
        self.WS_Type:SetActiveWidgetIndex(0)
        self.Key_Back:SetVisibility(UE4.ESlateVisibility.Visible)
        self:BindBtnEvent()
    elseif UIUtils.IsGamepadInput() then
        self.WS_Type:SetActiveWidgetIndex(1)
        self.List_Buff:SetFocus()
        self:ChangeKeyImg()
        self.Key_Back:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function View:ChangeKeyImg()
    self.Key01:CreateCommonKey(
        {
            KeyInfoList = {
                {
                    Type = "Img",
                    ImgShortPath = UIConst.GamePadImgKey.LeftTriggerAnalog
                }
            },
            Desc = GText("UI_Controller_Slide")
        }
    )

    self.Key02:CreateCommonKey(
        {
            KeyInfoList = {
                {
                    Type = "Img",
                    ImgShortPath = UIConst.GamePadImgKey.FaceButtonRight
                }
            },
            Desc = GText("UI_Tips_Close")
        }
    )
end

function View:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    --键盘
    if (InKeyName == "Escape") then
        self:OnClosedButtonClicked()
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    -- 手柄
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if InKeyName == Const.GamepadFaceButtonRight then
            self:Close()
        end
    end

    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function View:OnClosedButtonClicked()
    self:PlayAnimation(self.Out)
    AudioManager(self):SetEventSoundParam(self, "BuffDetailPanelSfx", {ToEnd = 1})
end

function View:BindBtnEvent()
    if self.Btn_Close then
        self.Btn_Close.OnPressed:Remove(self, self.OnClosedButtonClicked)
        self.Btn_Close.OnPressed:Add(self, self.OnClosedButtonClicked)
    end
    if self.Key_Back and self.Key_Back.Button_Key then
        self.Key_Back.Button_Key.OnClicked:Remove(self, self.OnClosedButtonClicked)
        self.Key_Back.Button_Key.OnClicked:Add(self, self.OnClosedButtonClicked)
    end
end

return View
