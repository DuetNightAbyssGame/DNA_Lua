--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Experience_Main_EXItem02_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:OnListItemObjectSet(Content)
    self.Content = Content
    self.Content.Entry = self
    self.Text_Attribute01:SetText(GText(Content.SubSourceName))
    self.Text_Num:SetText(Content.CollectRewardExp)
    if Content.CanGetRewardExp then
        self.Text_Num_All:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Text_Num_All:SetText("/"..Content.CanGetRewardExp)
    else
        self.Text_Num_All:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if Content.CurNum and Content.TotalNum then
        self.Text_AttributeNum:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Text_AttributeNum:SetText("("..Content.CurNum.."/"..Content.TotalNum..")")
    else
        self.Text_AttributeNum:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

return M
