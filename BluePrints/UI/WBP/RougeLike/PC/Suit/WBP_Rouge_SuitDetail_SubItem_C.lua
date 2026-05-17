--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Rouge_SuitDetail_SubItem_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

--function M:Initialize(Initializer)
--end

function M:Construct()
    UIUtils.InitDefinitionTextWidget(self, self.Text_SuitDesc, "ExplanationId")
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

--DetailInfo = {
--    TextGroupLevel = 套装显示第几层的数字(传阿拉伯，会转为罗马数字）,
--    TextCurrentNum = 套装当前有几个数字,
--    TextUnlockNum = 解锁效果所需的数字,
--    IsActive = 0代表没激活，1代表激活, 2代表预激活
--    TextSuitDesc = 套装描述,
--    IsUnlockFeedback = bool,用于解锁那个时候的技能弹窗,正常可以不传
--    ExplanationId = 套装描述中的超链接id的Table
--}

function M:InitUIInfo(DetailInfo)
    self:StopAllAnimations()
    self.IsActive = DetailInfo.IsActive
    local RomanNum = Const.RomanNum[DetailInfo.TextGroupLevel]
    self.Text_Lv:SetText(RomanNum)
    self.WS_IsActive:SetActiveWidgetIndex(self.IsActive)
    self.ExplanationId = DetailInfo.ExplanationId
    local DetailInfoWithLine = GText(DetailInfo.TextSuitDesc)
    if self.ExplanationId ~= nil and #self.ExplanationId > 0 and UIUtils.IsGamepadInput() then
        --DetailInfoWithLine = UIUtils.GenRougeCombatTermDesc(DetailInfoWithLine, self.ExplanationId)
        self.Btn_Click:SetForbidden(false)
    else
        self.Btn_Click:SetForbidden(true)
    end
    self.Text_SuitDesc:SetText(DetailInfoWithLine)

    local bPlayingAnim = false
    if DetailInfo.IsUnlockFeedback then
        self:PlayAnimation(self.Unlock_Feedback)
        bPlayingAnim = true
    else
        if self.IsActive == 0 then
            local RichText = "<Warning>" .. DetailInfo.TextCurrentNum .. "</>" .. "/" .. DetailInfo.TextUnlockNum
            self.Text_SuitNum:SetText(RichText)
            self:PlayAnimation(self.Lock)
            bPlayingAnim = true
        elseif self.IsActive == 1 then
            local RichText = "<G>" .. DetailInfo.TextCurrentNum .. "</>" .. "/" .. DetailInfo.TextUnlockNum
            self.Text_SuitNum:SetText(RichText)
            self:PlayAnimation(self.Unlocked)
            bPlayingAnim = true
        elseif self.IsActive == 2 then
            local RichText = "<G>" .. DetailInfo.TextCurrentNum .. "</>" .. "/" .. DetailInfo.TextUnlockNum
            self.Text_SuitNum:SetText(RichText)
            AudioManager(self):PlayUISound(self, "event:/ui/roguelike/suit_pre_active", nil, nil)
            self:PlayAnimation(self.Pre_Unlock)
            bPlayingAnim = true
        end
    end
    self.Parent = DetailInfo.Parent
    self.Btn_Click.OnClicked:Add(self, self.OnBtn_ClickClicked)
    self.Btn_Click.OnHovered:Add(self, self.OnBtn_ClickHover)
    if self.In and not bPlayingAnim then
        self:PlayAnimation(self.In)
    end
end

function M:OnBtn_ClickClicked()
    if not self.ExplanationId then
        return
    end

    if UIUtils.IsGamepadInput() then
        UIUtils.OnDefinitionLinkClicked(self, self.ExplanationId)
    end
end

function M:OnBtn_ClickHover()
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self:AddDelayFrameFunc(function()
            self:SelectItem()
        end, 1)
        if self.Parent and type(self.Parent.OnHoverItemChange) == "function" then
            self.Parent:OnHoverItemChange(self)
        end
        if self.Parent and self.Parent.ScrollBox_Suit then
            self.Parent.ScrollBox_Suit:ScrollWidgetIntoView(self.CurrentHoverItem,true, UE4.EDescendantScrollDestination.Center)
        end
    end
end

function M:SelectItem()
    DebugPrint("检测到被选中")
    self.IsSelected = true
    if self.Parent then
        self.Parent.CurrentSelectSuitItem = self
    end

    if self.Parent and self.Parent.SelectSuitItem then
        self.Parent:SelectSuitItem(self)
    end
end

--function M:OnLoaded(DetailInfo)
--    
--    
--end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    if CurInputType == ECommonInputType.Gamepad then
        if self.DefinitionWidget and IsValid(self.DefinitionWidget) then
            self.DefinitionWidget:SetFocus()
        end
        if self.ExplanationId ~= nil and #self.ExplanationId > 0 then
            self.Btn_Click:SetForbidden(false)
        end
    else
        self.Btn_Click:SetForbidden(true)
    end
end

return M
