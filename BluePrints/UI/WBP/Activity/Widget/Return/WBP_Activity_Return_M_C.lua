--
-- DESCRIPTION
-- 新手任务主界面
-- @COMPANY **
-- @AUTHOR ** hy
-- @DATE ${date} ${time}
--
require "UnLua"

local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"
local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"

local M = Class({
    "BluePrints.UI.WBP.Activity.Widget.Return.ActivityReturnBase",
    "BluePrints.Common.TimerMgr",
    "BluePrints.UI.BP_EMUserWidget_C",
})


function M:Initialize(Initializer)
    self.OwnerPlayer = nil               -- 所属的Player
    self.CurActivityId = nil             -- 当前活动的EventId
    self.ParentTabId = nil               -- 父页面上的TabId
end

function M:InitPage(ActivityId, ParentTabId, AllActivityId, ParentWidget)
    self.Super.InitPage(self, ActivityId, ParentTabId, AllActivityId, ParentWidget)
    
end

function M:UpdatePage(OperateSrc)
    self.Super.UpdatePage(self, OperateSrc)

end

---------------------------------各种输入事件相关----------------------------------
function M:Destruct()
    
end

return M
