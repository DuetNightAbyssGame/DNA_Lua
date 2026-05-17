--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_ToastWarning02_P_C
local M = Class("BluePrints.UI.BP_UIState_C")

function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    local ShowMessage, LastTime = ...
    self:ShowToast(ShowMessage, LastTime)
end

function M:PlayOutAnim()
    if (self:IsAnimationPlaying(self.Out)) then
        -- 正在播放Out动画
        return
    end
    self:UnbindAllFromAnimationFinished(self.Out)
    self:BindToAnimationFinished(self.Out, {self, self.Close})
    self:PlayAnimation(self.Out)
end

function M:UpdateContent(ShowMessage)
    self.Text_Toast:SetText(GText(ShowMessage))
end

function M:ShowToast(ShowMessage, LastTime)
    self:UpdateContent(ShowMessage)
    self:UnbindAllFromAnimationFinished(self.In)
    if(LastTime > 0) then
        self:BindToAnimationFinished(self.In, {self, function()
            self:AddTimer(LastTime, self.PlayOutAnim,false,0,'TipShowTimer',true)
        end})
        -- self:AddTimer(LastTime, self.PlayOutAnim,false,0,'TipShowTimer',true)
    end
    self:PlayAnimation(self.In)
end

function M:Close()
    self.Super.Close(self)
    self.IsClose = true
end


return M
