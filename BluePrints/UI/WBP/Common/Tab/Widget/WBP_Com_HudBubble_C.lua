--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
--背景和文字颜色
local Enum_Type = {
    WhiteBGAndBlackText = 0,
    WhiteBGAndOrangeText = 1,
    WhiteBGAndRedText = 2,
    BlackBGAndWhiteText = 3,
    BlackBGAndOrangeText = 4,
    BlackBGAndRedText = 5,
    OrangeBGAndWhiteText = 6,
    RedBGAndWhiteText = 7,
}
--方位
local Enum_Arrow = {
    Down_Left = 0,
    Down_Center = 1,
    Down_Right = 2,
    Left_Down = 3,
    Left_Center = 4,
    Left_Up = 5,
    Up_Left = 6,
    Up_Center = 7,
    Up_Right = 8,
    Right_Up = 9,
    Right_Center = 10,
    Right_Down = 11,
}
---@type WBP_Com_HudBubble_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.SizeIcon:SetVisibility(UIConst.VisibilityOp.Collapsed)
    if self.Enum_Type == nil then
        self.Enum_Type = Enum_Type.WhiteBGAndBlackText
    end
    if self.Enum_Arrow == nil then
        self.Enum_Arrow = Enum_Arrow.Down_Center
    end
    if self.ConfigData and self.ConfigData.ColorType then
        self.Enum_Type = self.ConfigData.ColorType
    end
    if self.ConfigData and self.ConfigData.Arrow then
        self.Enum_Arrow = self.ConfigData.Arrow
    end
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
end

--ConfigData({
--    IconPath = "/Game/UI/UI_PNG/Atlas/Tab/T_Tab_All.T_Tab_All", 图片路径
--    Text = "Text",文本
--    ColorType = 0,文本颜色 Enum_Type[]
--    Arrow = 0,方位 Enum_Arrow[]
--})
function M:Init(ConfigData)
    self.ConfigData = ConfigData
    self:SetIcon(ConfigData.IconPath)
    self.Text_Bubble:SetText(GText(ConfigData.Text))
    self:SetBgAndTextColor(ConfigData.ColorType)
    self:SetArrowDirection(ConfigData.Arrow)
end

function M:SetIcon(IconPath)
    if not IconPath then return end
    
    local Img = LoadObject(IconPath)
    if (not IsValid(Img)) then
        DebugPrint("缺少图片资源: IconPath = " .. IconPath)
        return
    end
    self.Icon:SetBrushResourceObject(Img)
    self.SizeIcon:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:SetBgAndTextColor(ColorType)
    if ColorType ~= nil then 
        self.Enum_Type = ColorType
    end
    self:SetBgText()
end

function M:SetArrowDirection(Arrow)
    if Arrow ~= nil then 
        self.Enum_Arrow = Arrow
    end
    self:SetArrow()
end

function M:PlayInAnimation()
    self:StopAnimation(self.Out)
    self:PlayAnimation(self.In)
end

function M:PlayOutAnimation()
    self:StopAnimation(self.In)
    self:PlayAnimation(self.Out)
end

function M:PlayInAndLoopAnimation()
    self:StopAnimation(self.Out)
    self:StopAnimation(self.Loop)
    self:UnbindAllFromAnimationFinished(self.In)
    local function OnInFinished()
        self:PlayAnimation(self.Loop, 0, 0)
    end
    self:BindToAnimationFinished(self.In, OnInFinished)
    self:PlayAnimation(self.In)
end

function M:PlayHorizontalLoopAnimation()
    self:StopAnimation(self.Out)
    self:StopAnimation(self.Loop2)
    self:UnbindAllFromAnimationFinished(self.In)
    local function OnInFinished()
        self:PlayAnimation(self.Loop2, 0, 0)
    end
    self:BindToAnimationFinished(self.In, OnInFinished)
    self:PlayAnimation(self.In)
end

return M
