--
-- DESCRIPTION
-- 止流委托，用于确认提交的按钮
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_ZhiliuEvent_TaskBtn_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:InitTaskBtn(Parent)
    self.ParentUI = Parent
    --self.CurState = "Normal"  -- "Forbid" "Normal" "Complete"
    --self:SetTaskBtnNormal()   -- 似乎播完normal之后播complete 会有效果残留 先注释掉

    self.Btn_Click.OnClicked:Add(self, self.OnClickedEvent)
end

function M:OnClickedEvent()
    if self.CurState == "Forbid" then
        return
    end
    if self.CurState == "Complete" then
        return
    end
    self.ParentUI:OnTaskMainBtnClicked()
end

function M:SetTaskBtnForbid()
    self.CurState = "Forbid"
    self:PlayAnimation(self.Foridden)
    if self.ParentUI.IsShowCombatPanel then
        self.Text_Btn:SetText(GText("UI_Entrust_Ongoing"))
    else
        self.Text_Btn:SetText(GText("UI_Entrust_Submit"))
    end
    self.Btn_Click:SetForbidden(true)
    self.Key_Controller:SetForbidKey(true)
end

function M:SetTaskBtnNormal()
    self.CurState = "Normal"
    self:PlayAnimation(self.Normal)
    if self.ParentUI.IsShowCombatPanel then
        self.Text_Btn:SetText(GText("UI_AcceptEntrust"))
    else
        self.Text_Btn:SetText(GText("UI_Entrust_Submit"))
    end
    self.Btn_Click:SetForbidden(false)
    self.Key_Controller:SetForbidKey(false)
end

function M:SetTaskBtnComplete()
    self.CurState = "Complete"
    self:PlayAnimation(self.Complete)
    if self.ParentUI.IsShowCombatPanel then
        self.Text_Btn:SetText(GText("UI_Entrust_Complete"))
    else
        self.Text_Btn:SetText(GText("UI_Entrust_Submitted"))
    end
    self.Btn_Click:SetForbidden(true)
    self.Key_Controller:SetForbidKey(true)
end

--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M
