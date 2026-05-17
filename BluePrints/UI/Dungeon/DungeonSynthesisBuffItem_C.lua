--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Play_DeputeWeekly_Hud_BuffItem_C
local M = Class("BluePrints.UI.BP_EMDungeonWidget_C")

function M:OnListItemObjectSet(Content)
    self.BuffId = Content.BuffId
    self.BuffIconPath = Content.BuffIconPath
    Content.SelfWidget = self

    self.TextBuff:SetText(GText("DUNGEON_SYNTHESIS_"..tostring(self.BuffId)))

    local Icon = LoadObject(self.BuffIconPath)
    self.Image_Icon:SetBrushResourceObject(Icon)
    self:UpdateDiplayPercent(1)

    self:PlayAnimation(self.In)

    self.CbObj = nil
    self.CbFun = nil
    self:BindToAnimationFinished(self.Out, {self, self.OnOutAnimFinished})

    AudioManager(self):PlayUISound(self, "event:/ui/common/week_level_buff_add", nil, nil)
end

function M:UpdateDiplayPercent(Percent)
    local Material = self.Progress_Bar:GetDynamicMaterial()
    if Material then
        Material:SetScalarParameterValue("Percent", 1 - Percent)
    end
end

function M:HideBuffItem(obj, cb)
    self.CbObj = obj
    self.CbFun = cb
    self:PlayAnimation(self.Out)
end

function M:OnOutAnimFinished()
    if self.CbObj and self.CbFun then
        self.CbFun(self.CbObj)
    end
end

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

-- function M:Destruct()
-- end


return M
