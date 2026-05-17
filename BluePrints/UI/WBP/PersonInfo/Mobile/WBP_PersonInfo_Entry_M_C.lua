--
-- DESCRIPTION
-- 个人主页通用背景以及Tab PC
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local PersonInfoController = require "BluePrints.UI.WBP.PersonInfo.PersonInfoController"
local M = Class("BluePrints.UI.BP_UIState_C")

M._components = {"BluePrints.UI.WBP.PersonInfo.Base.PersonInfoEntryBaseView"}

function M:InitTabInfo()
    self.Com_Tab_M:Init({
        Tabs = {},
        DynamicNode = {"Back", "Tip", "BottomKey"},
        BottomKeyInfo = {{
            KeyInfoList = {{
                Type = "Text",
                Text = "Esc",
                ClickCallback = self.OnReturnKeyDown,
                Owner = self
            }},
            Desc = GText("UI_BACK")
        }},
        StyleName = "Text",
        OwnerPanel = self,
        TitleName = GText("UI_PersonInfo_Name"),
        BackCallback = self.OnReturnKeyDown
    })
end

function M:Close()
    -- TODO 界面关闭逻辑
    M.Super.Close(self)
end

function M:InitListenEvent()
    -- TODO 监听相关事件
end

function M:OnLoaded(...)
    -- 界面初始化完成
    M.Super.OnLoaded(self, ...)
    self:InitListenEvent()

    -- self:RefreshBaseInfo()
    self.Com_BtnVisible.Button_Area.OnClicked:Add(self, self.OnBtnVisibleClick)

end

function M:RefreshBaseInfo()
    -- 刷新一些基础数据
    local PageData = {}

    self.PersonInfoMainPage = self:CreatePersonInfoMainPage({
        PCBluePrint = "WidgetBlueprint'/Game/UI/WBP/PersonalInfo/Mobile/WBP_PersonalInfo_Main_M.WBP_PersonalInfo_Main_M'"
    })
    if (self.PersonInfoMainPage) then
        -- self.PersonInfoMainPage:InitPage(PageData)
        self.PersonInfoMainPage:PlayAnimation(self.PersonInfoMainPage.In)
    end
    self:SetFocus()
end

function M:OnReturnKeyDown()
    -- 返回上一级
    if (not self:CheckIsCanCloseSelf()) then
        return
    end

    -- UIUtils.PlayCommonBtnSe(self)
    self:PlayOutAnim()
end

function M:OnReturnKeyDown()
    -- 返回上一级
    -- UIUtils.PlayCommonBtnSe(self)
    if (self:CheckIsCanCloseSelf()) then
        self:PlayOutAnim()
    end
end
function M:Hideui()
    self.bIsHide = true

    self.PersonInfoMainPage.MainPanel:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Com_Tab_M:SetVisibility(UIConst.VisibilityOp.Collapsed)

    self:PlayAnimation(self.HideUi)

end
function M:Recoverui()
    self.bIsHide = false

    self.PersonInfoMainPage.MainPanel:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Com_Tab_M:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)

    self:PlayAnimation(self.ShowUi)

end
function M:OnBtnVisibleClick()
    self.bIsHide = not self.bIsHide
    if (self.bIsHide == true) then
        self:Hideui()
    else
        self:Recoverui()
    end

end
--------------------------输入交互--------------------------------
function M:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == "Escape" or "Android_Back") then
        self:OnReturnKeyDown()
        IsEventHandled = true
    end
    
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:OnGamePadDown(InKeyName)
    local IsEventHandled = self.Com_Tab:Handle_KeyEventOnGamePad(InKeyName)
    return IsEventHandled
end

function M:Handle_KeyDownOnGamePad()
    -- 处理手柄相关的交互事件
    return true
end

AssembleComponents(M)
return M
