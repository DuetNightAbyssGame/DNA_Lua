--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Map_Ability_L_C
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

function M:SetIcon(IconPath)
    self.Icon_Ability:SetBrushResourceObject(LoadObject(IconPath))
end

function M:SetDispathchColor(DispatchTag,bIsLocked)
    local AnimName = UIUtils.GetDispathchColorNameByType(DispatchTag)
    if(AnimName == "Special")then
        if(bIsLocked)then
            self:PlayAnimation(self.NoActive_Special)
        else
            self:PlayAnimation(self[AnimName])
        end
        return
    else
        if(bIsLocked)then
            self:PlayAnimation(self.No_Active)
        else
            self:PlayAnimation(self.Active)
        end
    end
    self:PlayAnimation(self[AnimName])
end


return M
