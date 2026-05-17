--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_ScreenEffects_C
-- local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
    
-- end

function M:OnLoaded()
    M.Super.OnLoaded(self)

    self:BindToAnimationFinished(self.In, function()
        --self:RemoveFromViewport()
        self:Close()
    end)
end

function M:ShowEffect()
    self:PlayAnimation(self.In)
    AudioManager(self):PlayUISound(self, "event:/sfx/common/scene/week/stage_finish", nil, nil)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M
