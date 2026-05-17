require "UnLua"
local PersonInfoController = require "BluePrints.UI.WBP.PersonInfo.PersonInfoController"
-- local GuildWarUtils = require "BluePrints.UI.WBP.Activity.Widget.GuildWar.GuildWarUtils"

local M = Class{"BluePrints.UI.WBP.PersonInfo.GuildWarData.WBP_PersonalInfo_GuildWar_Ranking_Base"}

function M:Construct()
    self.Super.Construct(self)
end

function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
end

-- 初始化Tab
function M:InitCommonTab()
  local CloseFunc = function()
        self:OnReturnKeyDown()
    end
    self.CloseCallback = CloseFunc
    local TabInfo = {
        DynamicNode = {"Back", "Tip", "BottomKey"},
        BottomKeyInfo = {        {
            GamePadInfoList = {{
                Type = "Img",
                ImgShortPath = "RH",
            }},
            Desc = GText("UI_CTL_RotatePreview")
        },{
            KeyInfoList = {{
                Type = "Text",
                Text = "Esc",
                ClickCallback = CloseFunc,
                Owner = self
            }},
            GamePadInfoList = {{
                Type = "Img",
                ImgShortPath = "B",
                ClickCallback = CloseFunc,
                Owner = self
            }},
            Desc = GText("UI_BACK")
        },
        },
        StyleName = "Text",
        OwnerPanel = self,
        TitleName = GText("RaidDungeon_Rank_History"),
        BackCallback = CloseFunc
    }
    if self.Tab then
        self.Tab:Init(TabInfo)
    end
end



function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if InKeyName == "Gamepad_FaceButton_Right" then
            if self.CloseCallback then
                self.CloseCallback()
            else
                self:CloseSelf()
            end
        elseif InKeyName == "Gamepad_LeftThumbstick" then
            self:OnMyselfButtonClicked()
        end
    else
        if InKeyName == "Escape" then
            if self.CloseCallback then
                self.CloseCallback()
            else
                self:CloseSelf()
            end
        end
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if(InKeyName == "Gamepad_RightX")then
        if(self.ActorController)then
            local DeltaX = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 10
            self.ActorController:OnDragViewActor({X=DeltaX})
        end
        return UIUtils.Handled
    end
    return UIUtils.Unhandled
end

function M:OnFocusReceived()
    local LastItem = self.LastClickedItem
    if LastItem and LastItem.SelfWidget then
        self.List_Ranking:NavigateToIndex(LastItem.RankInfo.RankNum - 1)
    end
    return UIUtils.Handled
end

return M