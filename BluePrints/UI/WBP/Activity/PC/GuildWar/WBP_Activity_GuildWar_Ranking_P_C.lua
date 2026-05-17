require "UnLua"

local M = Class{"BluePrints.UI.WBP.Activity.PC.GuildWar.WBP_Activity_GuildWar_RankingBase"}


function M:Construct()
    self.Super.Construct(self)
end

function M:Destruct()
    self.Super.Destruct(self)
end

function M:InitCommonTab()
    self.NormalBottomKeyInfo = {
        {
            GamePadInfoList =  {{Type="Img", ImgShortPath="LS"}}, 
            Desc = GText("UI_CTL_PositionPlayer"), bLongPress = false
        },
        {
            GamePadInfoList =  {{Type="Img", ImgShortPath="A"}}, 
            Desc = GText("UI_Controller_Check"), bLongPress = false
        },
        {
            GamePadInfoList =  {{Type="Img", ImgShortPath="RH",}},
            Desc = GText("UI_CTL_RotatePreview"),
        },
        {
            KeyInfoList = {{Type = "Text", Text = "Esc"}},
            GamePadInfoList = {{Type="Img", ImgShortPath="B"}},
            Desc = GText("UI_BACK"), bLongPress = false
        }
    }

    self.TabConfigData = {
        TitleName = GText("RaidDungeon_Rank"),
        LeftKey = "Q",
        RightKey = "E",
        DynamicNode = { "Back", "ResourceBar", "BottomKey" },
        StyleName = "TextImage",
        OwnerPanel = self,
        BackCallback = self.CloseSelf,
        BottomKeyInfo = self.NormalBottomKeyInfo
    }
    self.Tab:Init(self.TabConfigData, true)
end

function M:UpdateTapBottomKeyInfo(IsMenuOpened)
    if not self.MenuBottomKeyInfo then
        self.MenuBottomKeyInfo = {
            {
                GamePadInfoList =  {{Type="Img", ImgShortPath="A"}},
                Desc = GText("UI_Tips_Ensure"), bLongPress = false
            },
            {
                GamePadInfoList = {{Type="Img", ImgShortPath="B"}},
                Desc=GText("UI_BACK"), bLongPress = false
            }
        }
    end

    if IsMenuOpened then
        self.Tab:UpdateBottomKeyInfo(self.MenuBottomKeyInfo)
    else
        self.Tab:UpdateBottomKeyInfo(self.NormalBottomKeyInfo)
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if InKeyName == "Gamepad_FaceButton_Right" then  -- 关闭界面
            self:CloseSelf()
        elseif InKeyName == "Gamepad_LeftThumbstick" then  -- 定位玩家
            self:OnMyselfButtonClicked()
        end
    else
        if InKeyName == "Escape" then   -- 关闭界面
            self:CloseSelf()
        end
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if(InKeyName == "Gamepad_RightX")then
        if(self.ActorController)then
            local DeltaX = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 10
            self.ActorController:OnDragViewActor({X=DeltaX})
        end
        return UIUtils.Handled
    end
    return UIUtils.Unhandled
end

-- 接收输入时聚焦到Item
function M:OnFocusReceived()
    local LastItem = self.LastClickedItem
    if LastItem and LastItem.SelfWidget then
        self.List_Ranking:NavigateToIndex(LastItem.RankInfo.RankNum - 1)
    end
    return UIUtils.Handled
end

return M