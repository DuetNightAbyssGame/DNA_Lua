--
-- DESCRIPTION
-- 活动跳转界面，前置任务组件，显示任务用list的Item
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_PreTask_SubItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})


function M:OnListItemObjectSet(Content)
    self.Content = Content
    Content.SelfWidget = self
    self.BtnName = Content.BtnName  -- "Main", "Side"

    self.ParentWidget = Content.ParentWidget
    self.OnClickedParams = Content.OnClickedParams  -- {Obj = , Callback = , Params = }

    self.Text_ItemTitle:SetText(GText(Content.DisplayText))
    self.IsShowLock = Content.IsShowLock            -- 只控制是否显示锁图标（策划存在需求，显示锁但是可点击
    self.IsForbidClick = Content.IsForbidClick      -- 只控制是否可点击
    self.IsShowFinish = Content.IsShowFinish        -- 控制是否显示完成图标, 注意，仅当IsShowLock为false时才有效（蓝图结构把jump和complete放到一起了
    self.IsShowTip = Content.IsShowTip              -- 点击后不触发回调，改为弹tip（先把text写死在里边吧，以后有需求了再改
    self:UpdateLockDisplay()
    self:UpdateClickAbility()
end

function M:UpdateLockDisplay()
    -- 如果有时间/我想把他整理成枚举/然而，然而
    -- 注意，已完成的判定顺序需要比锁定的顺序高，因为一些上级判断逻辑的原因（改成枚举就没这个问题了，先这样吧
    if self.IsShowFinish then
        self:PlayAnimation(self.State_Done)
    elseif self.IsShowLock then
        self:PlayAnimation(self.State_Lock)
    else
        self:PlayAnimation(self.State_Normal)
    end
end

function M:UpdateClickAbility()
    self.Btn_Click:SetForbidden(self.IsForbidClick)
end

--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Btn_Click.OnClicked:Add(self, self.OnClickedBtn)
end

function M:OnClickedBtn()
    if self.IsForbidClick then
        return
    end
    if self.IsShowTip then
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("Event_PretextTasks2_UnlockTips"))
        return
    end
    if not self.OnClickedParams then
        return
    end
    if self.OnClickedParams.Params then
        self.OnClickedParams.Callback(self.OnClickedParams.Obj, table.unpack(self.OnClickedParams.Params))
    else
        self.OnClickedParams.Callback(self.OnClickedParams.Obj)
    end
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M
