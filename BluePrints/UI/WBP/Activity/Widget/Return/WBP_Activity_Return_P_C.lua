--
-- DESCRIPTION
-- 新手任务主界面
-- @COMPANY **
-- @AUTHOR ** hy
-- @DATE ${date} ${time}
--
require "UnLua"

local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"

local M = Class({
    "BluePrints.UI.WBP.Activity.Widget.Return.ActivityReturnBase",
    "BluePrints.Common.TimerMgr",
    "BluePrints.UI.BP_EMUserWidget_C",
})

function M:Initialize(Initializer)
    self.OwnerPlayer = nil               -- 所属的Player
    self.ParentWidget = nil              -- 父页面对象
    self.CurActivityId = nil             -- 当前活动的EventId
    self.ParentTabId = nil               -- 父页面上的TabId
    self.FocusWidgetName = nil           -- 当前Focus的Widget对象
end

-- 第一次进入页面时会走一次
function M:InitPage(ActivityId, ParentTabId, AllActivityId, ParentWidget)
    self.Super.InitPage(self, ActivityId, ParentTabId, AllActivityId, ParentWidget)
    self.Com_BtnExplanation.Com_KeyImg:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "Menu",
            },
        },
    }) 
end

-- 每次切回页面都会走
function M:UpdatePage(OperateSrc)
    self.Super.UpdatePage(self, OperateSrc)

end

function M:GetDefaultBottomTips()
    local ResultKeyInfo = {
        {
            KeyInfoList = { { Type = "Img", ImgShortPath = "A" } },
            Desc = GText("UI_CTL_Select")
        },
        {
            KeyInfoList = { { Type = "Img", ImgShortPath = "B", ClickCallback=self.OnReturnKeyDown, Owner=self} },
            Desc = GText("UI_Tips_Close")
        },
    }
    return ResultKeyInfo
end

---------------------------------各种输入事件相关----------------------------------
function M:HandleKeyDownInPage(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadButtonDown(InKeyName)
    else
        IsEventHandled = false
    end
    return IsEventHandled
end

function M:OnGamePadButtonDown(InKeyName)
    local IsEventHandled = self:Handle_KeyDownOnGamePad(InKeyName)
    return IsEventHandled
end

function M:Handle_KeyDownOnGamePad(InKeyName)
    -- 处理手柄相关的交互事件
    local IsEventHandled = false
    if (InKeyName == Const.GamepadLeftThumbstick) then  
        IsEventHandled = true
        self.Return_Reward:OnBtnClicked()
    elseif (InKeyName == UIConst.GamePadKey.FaceButtonRight) then
         if (self.ParentWidget and (self:HasAnyUserFocus() or self:HasFocusedDescendants())) then
            IsEventHandled = true
            self.ParentWidget:UpdateActivityKeyTips()
            self.ParentWidget:SetFocus()
        end   
    elseif (InKeyName == UIConst.GamePadKey.SpecialRight) then
        -- 按下右边菜单键打开弹窗
        IsEventHandled = true
        self:OnBtnExplanationClick()
    elseif (InKeyName == UIConst.GamePadKey.FaceButtonBottom) then
        IsEventHandled = true
        self:OnSubTabNavigationRight()
    end

    return IsEventHandled
end

function M:Destruct()
    
end

function M:OnSubTabNavigationRight()
    if self.EntryItem_3 then
        self.EntryItem_3.Btn_Click:SetFocus()
        self.ParentWidget:UpdateActivityKeyTips("SelectView")
    end
end

return M
