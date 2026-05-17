--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Battle_SlidingSlash_M_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C", "BluePrints.UI.BP_EMUserWidgetUtils_C"})

M._components = {
    "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent",
}

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Button_Area.OnPressed:Add(self, self.OnBtnPressed)
    self.Button_Area.OnReleased:Add(self, self.OnBtnReleased)
    self.OwnerPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
end

function M:OnBtnPressed()
    if self.OwnerPlayer:CheckSkillInActive(ESkillName.Slide) then
        return
    end
    if self.OwnerPlayer:CheckSkillInActive(ESkillName.Attack) then
        return
    end
    self.OwnerPanel:TryToPlayTargetCommand("Slide", true)
    self.OwnerPanel:TryToPlayTargetCommand("Attack", false)
    self:AddTimer(0.03, function()
        self:StopAnimation(self.Press)
        self:PlayAnimation(self.Click)
        self.OwnerPanel:TryToStopTargetCommand("Attack", false)
        self.OwnerPanel:TryToStopTargetCommand("Slide", true)
    end, false)
    self:PlayAnimation(self.Press)
end

function M:OnBtnReleased()
    
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

AssembleComponents(M)

return M
