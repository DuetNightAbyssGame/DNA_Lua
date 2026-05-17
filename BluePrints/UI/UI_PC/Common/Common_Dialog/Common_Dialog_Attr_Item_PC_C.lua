--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type Common_Dialog_Attr_Item_PC_C
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:OnListItemObjectSet(Obj)
    self.Content = Obj
    self.Text_Attribute:SetText(Obj.AttrName)
    self.Text_Num:SetText(Obj.AttrValue)
    self.Text_Num_New:SetText(Obj.CmpValue)
    if(Obj.Idx % 2 == 1)then
        self.Bg01:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self.Bg01:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
    local AttrValue = tonumber(Obj.AttrValue)
    local CmpValue = tonumber(Obj.CmpValue)
    if(not Obj.Delta and AttrValue and CmpValue) then 
        Obj.Delta = Obj.CmpValue - Obj.AttrValue
    end
    if(Obj.Delta<0) then
        self:PlayAnimation(self.Text_Num_New_Red)
    elseif(Obj.Delta == 0) then
        self:PlayAnimation(self.Text_Num_New_Normal)
    elseif(Obj.Delta>0) then
        self:PlayAnimation(self.Text_Num_New_Green)
    end
end

function M:OnAnimationFinished(InAnim)
    if InAnim == self.Text_Num_New_Red then
        if self.Content.Nagative then
            self.Text_Num_New:SetColorAndOpacity(self.Green)
            self.Image_3:SetColorAndOpacity(self.Green.SpecifiedColor)
        end
    elseif InAnim == self.Text_Num_New_Green then
        if self.Content.Nagative then
            self.Text_Num_New:SetColorAndOpacity(self.Red)
            self.Image_3:SetColorAndOpacity(self.Red.SpecifiedColor)
        end
    end
end

return M
