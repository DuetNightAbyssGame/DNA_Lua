--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Announcement_Main_P_C
local M = Class({"BluePrints.UI.WBP.Announcement.NewView.WBP_Announcement_Main_C"})


function M:Construct()
    M.Super.Construct(self)
    self.Key_Top:CreateCommonKey({
        KeyInfoList = {{
            Type="Img", ImgShortPath="Y",
        }},
    })
    self.Key_Bottom:CreateCommonKey({
        KeyInfoList = {{
            Type="Img", ImgShortPath="X",
        }},
    })
    self.WebContent:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    self.WebContent:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self.WebContent:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    self.WebContent:SetNavigationRuleCustom(EUINavigation.Left, {self, self.OnWebContentNavLeft})
    self.WebContent:SetNavigationRuleBase(EUINavigation.Next, EUINavigationRule.Stop)
    self.WebContent:SetNavigationRuleBase(EUINavigation.Previous, EUINavigationRule.Stop)
end

function M:OnWebContentNavLeft()
    if self.CurContent and self.CurContent.Widget then
        self.CurContent.Widget:SetFocus()
    end
end

function M:_CreateTabParams()
    local TabParams = {
        PlatformName = PlatformName,
        Tabs = {
            {
                Text = GText(DataMgr["NoticeTab"][1]["Text"]),
                TabId = 1,
                Icon = DataMgr["NoticeTab"][1]["IconPath"]
            },
            {
                Text = GText(DataMgr["NoticeTab"][2]["Text"]),
                TabId = 2,
                Icon = DataMgr["NoticeTab"][2]["IconPath"]
            },
            {
                Text = GText(DataMgr["NoticeTab"][3]["Text"]),
                TabId = 3,
                Icon = DataMgr["NoticeTab"][3]["IconPath"]
            }
        },
        LeftKey = "Q", RightKey = "E",
        LeftGamePadKey = "LeftShoulder",
        RightGamePadKey = "RightShoulder",
        ChildWidgetBPPath = "WidgetBlueprint'/Game/UI/WBP/Announcement/Widget/WBP_Announcement_TabCell.WBP_Announcement_TabCell'"
    }
    return TabParams
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    if CurInputType == ECommonInputType.Gamepad then
        self.Key_Back:CreateCommonKey({
            KeyInfoList = {{
                Type="Img", ImgShortPath="B",
                ClickCallback=self.Close, Owner=self,
            }},
            Desc = GText("UI_CTL_Quit"),
        })
        self.Panel_Key_Bottom:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Panel_Key_Top:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        if self.Panel_Catalog:IsVisible() then
            self.Key_Catalog:SetVisibility(UIConst.VisibilityOp.Visible)
        else
            self.Key_Catalog:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
        if self.Main:IsVisible() then
            if self.CurContent and self.CurContent.Widget then
                self.CurContent.Widget:SetFocus()
            else
                self.List_Announcement:SetFocus()
            end
        end
    else
        self.Key_Back:CreateCommonKey({
            KeyInfoList = {{
                Type="Text", Text = "Esc",
                ClickCallback=self.Close, Owner=self,
            }},
            Desc = GText("UI_CTL_Quit"),
        })
        self.Panel_Key_Bottom:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Panel_Key_Top:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Key_Catalog:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:OnKeyUp(MyGeo, InKeyEvent)
    local HandleRes = M.Super.OnKeyUp(self, MyGeo, InKeyEvent)
    local InKey = UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UFormulaFunctionLibrary.Key_GetFName(InKey)
    local bHandled = false
    if self.Tab_Announcement:Handle_KeyEventOnPC(InKeyName) then
        bHandled = true
    elseif self.Tab_Announcement:Handle_KeyEventOnGamePad(InKeyName) then
        bHandled = true
    elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
        if self.WebContent:HasAnyUserFocus() or self.WebContent:HasFocusedDescendants() then
            if self.CurContent and self.CurContent.Widget then
                self.CurContent.Widget:SetFocus()
            end
        else
            self:Close()    
        end
        bHandled = true
    elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
        self.Btn_Top:OnBtnClicked()
        bHandled = true
    elseif InKeyName == UIConst.GamePadKey.FaceButtonLeft then
        self.Btn_Bottom:OnBtnClicked()
        bHandled = true
    end
    if bHandled then
        return UIUtils.Handled
    end
    return HandleRes
end

function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == UIConst.GamePadKey.RightAnalogY) then
        if self.WebContent:HasAnyUserFocus() or self.WebContent:HasFocusedDescendants() then
            local a = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * -self.ScrollSpeed
            self.WebContent:ExecuteJavascript("window.scrollBy(0, " .. a .. ");")
        end
    end
    return UWidgetBlueprintLibrary.Unhandled()
end

function M:Destruct()
    M.Super.Destruct(self)
end


return M
