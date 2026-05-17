--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_InnerWebBrowser_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

function M:Construct()
    M.Super.Construct(self)
    self.Browser:BindUObject("widget", self, true)
    self.Browser:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Browser.OnLoadError:Add(self,function()
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("Unknown_Error"))
        self:Close()
    end)
    self.Browser.OnLoadCompleted:Add(self,function()
        self:RemoveAutoCloseTimer()
    end)
end

function M:RemoveAutoCloseTimer()
    if self:IsExistTimer(self.AutoCloseTimer) then
        self:RemoveTimer(self.AutoCloseTimer)
        self.AutoCloseTimer = nil
    end
end

function M:OnLoaded(...)
    local Link, bCustomUrl, Param1, Param2, Param3 = ...
    local Url = GLink(Link)
    if bCustomUrl then
        Url = Url .. Param1 .. Param2 .. Param3
    end
    if Url then
        self.Browser:LoadUrl(Url)
    end
    local _, AutoCloseTimer = self:AddTimer(5, function()
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_SYSTEM_VOTEKICK"))
        self:Close()
    end)
    self:AddDispatcher(EventID.OnToggleDisconnectUI, self, function(_, HasConfirmUI)
        self:Close()
    end)
    self.AutoCloseTimer = AutoCloseTimer
end

function M:Close()
    self.Browser:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:RemoveAutoCloseTimer()
    M.Super.Close(self)
end

function M:NotifyClose()
    self:Close()
end

function M:NotifyLaunchUrl(Url)
    UE4.UKismetSystemLibrary.LaunchURL(Url)
end

function M:Destruct()
    self.Browser:UnbindUObject("widget", self, true)
    self.Browser.OnLoadError:Clear()
    self.Browser.OnLoadCompleted:Clear()
    M.Super.Destruct(self)
end

return M
