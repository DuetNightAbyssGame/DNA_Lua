--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_AccessoryDrop_BG_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:InitData()
end

function M:Play_GetItem()
    --显示获取的道具
    UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, self.Rewards, false, function()
        self.PlayOpenAnimCallbackInfo.Func(self.PlayOpenAnimCallbackInfo.Obj)
    end, self, false)
end

function M:PlayAnimationIn()
    self:PlayAnimation(self.In)
end

function M:PlayOpenAnim(Rewards, CallbackInfo)
    self.Rewards = Rewards
    self.PlayOpenAnimCallbackInfo = CallbackInfo
    self:PlayAnimation(self.Open)
end

return M
