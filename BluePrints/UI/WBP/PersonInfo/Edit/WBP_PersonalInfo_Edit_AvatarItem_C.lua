-- DESCRIPTION 个人主页编辑界面的头像item
--
-- @COMPANY **
-- @AUTHOR 叶轲
-- @DATE 2025.3.26
--
require "UnLua"

---@type WBP_PersonalInfo_Edit_Item_P_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:Construct()
    self.Btn_Click.OnClicked:Add(self, self.OnItemClick)
    self.Btn_Click.OnHovered:Add(self, self.OnItemHover)
    self.Btn_Click.OnUnHovered:Add(self, self.OnItemUnHover)
    self.Btn_Click.OnPressed:Add(self, self.OnItemPress)

end
function M:OnItemClick()
    self:StopAllAnimations()
    self:PlayAnimation(self.Click)
end
function M:OnItemHover()
    AudioManager(self):PlayUISound(nil, "event:/ui/common/hover_btn_large_crystal", nil, nil)
    self:PlayAnimation(self.Hover)
end
function M:OnItemUnHover()
    if self:IsAnimationPlaying(self.Click) then
        return
    end
    self:PlayAnimation(self.UNHover)
end

function M:OnItemPress()
    self:PlayAnimation(self.Press)
end
-- 刷新界面数据，放入Uuid是为了和listitem同步勾选状态
function M:FreshView(image, name, lv, Rarity, Uuid)
    -- self.Image_Avatar:SetBrushFromTexture(image)
    self.bIsEmpty = false
    self.Uuid = Uuid
    local MaterialInstance = self.Image_Avatar:GetDynamicMaterial()
    MaterialInstance:SetTextureParameterValue("IconMap", image)
    self:StopAllAnimations()

    self.Text_Lv:SetText(GText("Lv." .. lv))
    self.Text_AvatarName:SetText(GText(name))
    self.Image_Avatar:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Text_Lv:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Text_AvatarName:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Btn_Removes:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Image_BottomBlack:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Group_Add:SetVisibility(UIConst.VisibilityOp.Collapsed)

    if Rarity == 2 then
        self:PlayAnimation(self.Green)
    elseif Rarity == 3 then
        self:PlayAnimation(self.Blue)
    elseif Rarity == 4 then
        self:PlayAnimation(self.Purple)
    else
        self:PlayAnimation(self.Yellow)
    end
end
-- 刷新成空白样式
function M:SetEmpty()
    self.bIsEmpty = true
    self.Uuid = nil
    -- self:Playanimation(self.Normal)
    self:StopAllAnimations()
    self:Playanimation(self.NormalColor)
    self.Image_BottomBlack:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Group_Add:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Image_Avatar:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Text_Lv:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Text_AvatarName:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Group_WeaponSign:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Removes:SetVisibility(UIConst.VisibilityOp.Collapsed)
end
--- 设置被聚焦时的回调
---@param func 传入的回调函数
function M:SetFocusCallback(func)
    -- 添加函数类型校验
    if type(func) == "function" then
        self.FocusCallback = func
    else
        ScreenPrint("传入的参数不是函数")
    end
end
---被聚焦时触发回调
function M:OnFocusReceived()
    -- 补充焦点回调逻辑
    if self.FocusCallback and type(self.FocusCallback) == "function" then
        self.FocusCallback()
        return true
    end
    return UIUtils.Handled
end
--- 设置被移除时的回调
---@param func 传入的回调函数
function M:SetFocusLostCallback(func)
    -- 添加函数类型校验
    if type(func) == "function" then
        self.RemoveCallback = func
    else
        ScreenPrint("传入的参数不是函数")
    end
end

---被移除时触发回调
function M:OnFocusLost()
    -- 补充移除回调逻辑
    if self.RemoveCallback and type(self.RemoveCallback) == "function" then
        self.RemoveCallback()
        return true
    end
    return UIUtils.Handled
end
return M
