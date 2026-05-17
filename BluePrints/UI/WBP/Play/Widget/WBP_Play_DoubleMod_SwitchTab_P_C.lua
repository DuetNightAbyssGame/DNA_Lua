--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local EMCache = require "EMCache.EMCache"
---@type WBP_Play_DoubleMod_SwitchTab_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Btn_Click.OnClicked:Add(self, self.OnClicked)
    self.Btn_Click.OnHovered:Add(self, self.OnHovered)
    self.Btn_Click.OnUnhovered:Add(self, self.OnUnhovered)

    -- 初始化状态：读取是否为连战页签
    local IsEliteMode = self:GetCurrentTabState()
    self:UpdateSwitchVisual(IsEliteMode)
end

--- 点击切换页签
function M:OnClicked()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
    local CurrentState = self:GetCurrentTabState()
    local NewState = not CurrentState

    self:UpdateSwitchVisual(NewState)
    self:SetCurrentTabState(NewState)

    EventManager:FireEvent(EventID.DoubleModSwitchTab, NewState)
end

function M:OnHovered()
    self:PlayAnimation(self.Hover)
end

function M:OnUnhovered()
    self:PlayAnimation(self.UnHover)
end

--- 更新切换状态动画
---@param IsElite boolean 是否为连战挑战状态
function M:UpdateSwitchVisual(IsElite)
    self:StopAllAnimations()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    if IsElite then
        self:PlayAnimation(self.Switch)
        self.Text_TabTitleNormal:SetText(GText("UI_Event_ModDrop_Challenge"))
        if Avatar.DoubleModDropFirst then
            Avatar:SetDoubleModDropFirst()
            self:PlayAnimationReverse(self.Tips_In_Out)
        end
    else
        self:PlayAnimationReverse(self.Switch)
        self.Text_TabTitleNormal:SetText(GText("UI_Event_ModDrop_Normal"))
        if Avatar.DoubleModDropFirst then
            self.Text_Tips:SetText(GText("UI_Event_ModDrop_Bubble"))
            self:PlayAnimation(self.Tips_Loop,0,0)
        end
    end
end

--- 获取当前缓存的页签状态
---@return boolean
function M:GetCurrentTabState()
    return EMCache:Get("Is_DoubleMod_SwitchTab", true)
end

--- 设置当前页签状态
---@param state boolean
function M:SetCurrentTabState(state)
    EMCache:Set("Is_DoubleMod_SwitchTab", state, true)
end


--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

return M
