
require "UnLua"

---@type WBP_ModArchive_HudTips_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

-- function M:InitInfo(Owner, QuestId)
--     self.Owner = Owner
--     self.QuestId = QuestId
--     local TaskInfo = DataMgr.ModGuideBookTask[self.QuestId]
--     if TaskInfo then
--         self.Text_Title:SetText(GText("UI_ModGuideBook_Task_Complete"))
--         local CompleteNum = TaskInfo.Target
--         self.Text_Desc:SetText(GText(TaskInfo.TaskName).." ".."("..CompleteNum.."/"..CompleteNum..")")
--     end

--     self:BindToAnimationFinished(self.In, {self, self.OnInFinished})
--     self:PlayAnimation(self.In)
--     -- self.ProgressBar_Mod:SetPercent(1.0)
--     DebugPrint("zwkkk WBP_ModArchive_HudTips_C:InitInfo", self.Owner, self.QuestId, self.ShowTime)
--     self:AddTimer(self.ShowTime, self.OnClose, false, 0)
-- end

function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    self.Owner, self.QuestId = ...
    if not self.Owner then
        self:Close()
        return
    end
    DebugPrint("zwkkk WBP_ModArchive_HudTips_C:OnLoaded", self.Owner:GetName(), self.QuestId, self.ShowTime)
    self.Owner.Pos_ModAchive:AddChildToOverlay(self)
    self.IsInit = true
    local TaskInfo = DataMgr.ModGuideBookTask[self.QuestId]
    if TaskInfo then
        self.Text_Title:SetText(GText("UI_ModGuideBook_Task_Complete"))
        local CompleteNum = TaskInfo.Target
        self.Text_Desc:SetText(GText(TaskInfo.TaskName).." ".."("..CompleteNum.."/"..CompleteNum..")")
    end

    self:BindToAnimationFinished(self.In, {self, self.OnInFinished})
    self:PlayAnimation(self.In)
    -- self.ProgressBar_Mod:SetPercent(1.0)
    DebugPrint("zwkkk WBP_ModArchive_HudTips_C:OnLoaded", self.Owner:GetName(), self.QuestId, self.ShowTime)
    self:AddTimer(self.ShowTime, self.TryClose, false, 0)
end

function M:OnInFinished()
    -- self:PlayAnimation(self.Progress_In)
end

function M:TryClose()
    if not self.Owner then
        self:Close()
        return
    end
    DebugPrint("zwkkk TryClose", self.Owner:GetName(), self.QuestId, self.ShowTime)
    self:BindToAnimationFinished(self.Out, {self, self.OnOutAnimationFinished})
    self:StopAllAnimations()
    self:PlayAnimation(self.Out)
end

function M:OnOutAnimationFinished()
    if not self.Owner then
        self:Close()
        return
    end
    self:RealClose()
    self.Owner.Pos_ModAchive:ClearChildren()
    self.Owner:OnPreModArchiveFinished(self.QuestId)
end

return M
