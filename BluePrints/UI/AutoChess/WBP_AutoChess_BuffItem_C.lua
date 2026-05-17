require "UnLua"
local WBP_AutoChess_BuddItem = Class({"BluePrints.UI.BP_EMUserWidget_C","BluePrints.Common.TimerMgr"})

function WBP_AutoChess_BuddItem:OnListItemObjectSet(ListItemObject)
    self:PlayAnimation(self.In) 
    -- self:AddTimer(1, function() 
    --     self:PlayAnimation(self.In) 
    --     DebugPrint("-------------------------------------------------")
    -- end)

    self.Text_Name:SetText(ListItemObject.name)
    self.Text_Desc:SetText(ListItemObject.Desc)
    self.Text_Condition:SetText(ListItemObject.Condition)
end

return WBP_AutoChess_BuddItem


