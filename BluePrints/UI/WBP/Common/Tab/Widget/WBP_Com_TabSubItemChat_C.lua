--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_TabSubItem07_C
local M = Class({"BluePrints.UI.WBP.Common.Tab.Widget.WBP_Com_TabSubItem03_P_C"})

-- function M:Construct()
-- end

function M:Update(Idx, Info, PlatformDeviceName)
    if Info.HideText then
        self.Text_SubTab:SetVisibility(UE.ESlateVisibility.Collapsed)
    end

    self.Super.Update(self, Idx, Info, PlatformDeviceName)
end

function M:ShowText(bIsShow)
    if bIsShow then
        self.Text_SubTab:SetVisibility(UE.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Text_SubTab:SetVisibility(UE.ESlateVisibility.Collapsed)
    end
end

function M:Destruct()
    if self.DisturbUI then
        self.DisturbUI:RemoveFromParent()
    end
    ForceStopAsyncTask(self, "SetDisturbIconTask")
end

function M:SetDisturbIcon(bNotDisturb)
    RunAsyncTask(self, "SetDisturbIconTask", function(CoroutineObj)
        if bNotDisturb then
            if not self.DisturbUI then
                self.DisturbUI = UIManager():CreateWidgetAsync(nil, CoroutineObj, 
                    '/Game/UI/WBP/Chat/Widget/WBP_Chat_DontDisturb.WBP_Chat_DontDisturb', false)
                self.Group_ChatDontDisturb:AddChild(self.DisturbUI)
            end
            self.Group_ChatDontDisturb:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        else
            self.Group_ChatDontDisturb:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end)
end



return M
