--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_ToastOnline_P_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:OnLoaded(...)
    local Type, Time = ...
    if Type == "In" then
        self:RemoveTimer("OnlineLoop")
        self.Switch_Online:SetActiveWidgetIndex(0)
        self.WS_Icon:SetActiveWidgetIndex(0)
        self.Text_Toast_In:SetText(GText("UI_OnlineRegion_Enter"))
        if self.In then
            self:UnbindAllFromAnimationFinished(self.In)
            self:BindToAnimationFinished(self.In, {self, function()
                self:Close()
            end})
            AudioManager(self):PlayUISound(self, "event:/ui/common/toast_online", nil, nil)
            self:PlayAnimation(self.In)
        end
    elseif Type == "Out" then
        self.Switch_Online:SetActiveWidgetIndex(1)
        self.WS_Icon:SetActiveWidgetIndex(0)
        self:UnbindAllFromAnimationFinished(self.In)
        self:StopAnimation(self.In)
        AudioManager(self):PlayUISound(self, "event:/ui/common/toast_offline", nil, nil)
        self.Text_Toast_Out:SetText(GText("UI_REGION_EXITONLINE_TIP"))
        self:PlayAnimation(self.In_2)
        self:UpdateTime(Time)
    else
        self:RemoveTimer("OnlineLoop")
        self.Switch_Online:SetActiveWidgetIndex(0)
        self.Text_Toast_In:SetText(GText("SwitchOnlineRegion"))
        self.WS_Icon:SetActiveWidgetIndex(1)
        if self.In then
            self:UnbindAllFromAnimationFinished(self.In)
            self:BindToAnimationFinished(self.In, {self, function()
                self:Close()
            end})
            AudioManager(self):PlayUISound(self, "event:/ui/common/toast_online", nil, nil)
            self:PlayAnimation(self.In)
        end
    end
end

function M:UpdateTime(Time)
    self.CurTime = Time 
    self.Text_Toast_Out_Time:SetText(self.CurTime)
    self:RemoveTimer("OnlineLoop")
    self:PlayAnimation(self.Loop, 0)
    self:AddTimer(1,function()
        self.CurTime = self.CurTime - 1
        self.Text_Toast_Out_Time:SetText(self.CurTime)
        if self.CurTime <= 0 then
            self:RemoveTimer("OnlineLoop")
            self:PlayAnimation(self.Out_2)
            self:Close()
            return
        end 
    end, true, 0, "OnlineLoop")
end

return M
