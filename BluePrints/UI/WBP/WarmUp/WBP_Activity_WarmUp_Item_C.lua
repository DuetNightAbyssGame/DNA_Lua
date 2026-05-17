--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_WarmUp_Item_C
local M = Class("BluePrints.UI.BP_UIState_C")

function M:Construct()
    self.GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
        self:AddTimer(0.1, function()
            self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
        end)
    end
    self.IsFocused = false
    self.Key_Item:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "LS"
            }
        },
    })
    self.Key_Item:SetVisibility(UIConst.VisibilityOp["Collapsed"])
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        return
    end
    --更新输入模式
    self.CurInputDeviceType = CurInputDevice
    self.CurGamepadName = CurGamepadName
    self:UpdateUIByInputDevice(self.CurInputDeviceType)
end

function M:UpdateUIByInputDevice(CurInputDeviceType)
    if(CurInputDeviceType ~= ECommonInputType.Gamepad and self.IsFocused) then
        self:PlayAnimation(self.UnHover)
        self.Key_Item:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end
function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if self.CurInputDeviceType ~= ECommonInputType.Gamepad then
        return
    end
    self.IsFocused = true
    self:PlayAnimation(self.Hover)
    self.Key_Item:SetVisibility(UE4.ESlateVisibility.Visible)
    return self
end

function M:OnFocusLost(InFocusEvent)
    if self.CurInputDeviceType ~= ECommonInputType.Gamepad then
        return
    end
    self.IsFocused = false
    self:PlayAnimation(self.UnHover)
    self.Key_Item:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

--- 设置日期文本（分割为三部分：前缀、数字、后缀）
---@param Index number 天数
function M:SetDateText(Index)
    -- 获取翻译文本模板
    local DateTemplate = GText("UI_Event_DailyLogin_Date")  -- "第%s天"
    
    -- 分割字符串
    local Prefix, Number, Suffix = self:SplitDateText(DateTemplate, Index)
    
    -- 设置到三个Text控件
    self.Text_Title01:SetText(Prefix)      -- 前缀："第"
    self.Text_LvNum:SetText(Number)        -- 数字："5"
    self.Text_Title02:SetText(Suffix)      -- 后缀："天"
end

--- 分割日期文本为三部分
---@param Template string 模板字符串（如："第%s天"）
---@param Index number 要填充的数字
---@return string, string, string 前缀、数字、后缀
function M:SplitDateText(Template, Index)
    local IndexStr = tostring(Index)
    
    -- 查找 %s 的位置
    local PercentSIndex = string.find(Template, "%%s")
    if not PercentSIndex then
        -- 如果没有 %s，返回原文本作为前缀
        return Template, IndexStr, ""
    end
    
    -- 分割字符串
    local Prefix = string.sub(Template, 1, PercentSIndex - 1)  -- %s 之前的部分
    local Suffix = string.sub(Template, PercentSIndex + 2)    -- %s 之后的部分
    
    return Prefix, IndexStr, Suffix
end
return M
