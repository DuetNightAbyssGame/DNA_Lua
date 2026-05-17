-- DESCRIPTION
-- 个人主页编辑组件Widget
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
---@type WBP_PersonalInfo_Edit_Tips_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})
local ModController = require "BluePrints.UI.WBP.Armory.Mod.Utils.ModController"

local index2abc = {
    [1] = "UI_Squad_Appearance_TITLE1",
    [2] = "UI_Squad_Appearance_TITLE2",
    [3] = "UI_Squad_Appearance_TITLE3"
    -- "UI_Squad_Appearance_TITLE1"
}
local OriginPlanname = {
    [1] = "UI_Squad_Appearance_TITLE1",
    [2] = "UI_Squad_Appearance_TITLE2",
    [3] = "UI_Squad_Appearance_TITLE3"

}
local TipsEnum = {
    Weapon = 1,
    Char = 0
}
-- function M:Initialize(Initializer)
-- end

function M:Initialize(Initializer)
    self.TipsType = nil
end
function M:Construct()
    self.SelectAppearanceIndex = nil
    self.SelectModIndex = nil

    self.Btn_Confirm.Button_Area.OnClicked:Add(self, self.OnComfirmClicked)
    self.Btn_Confirm.Button_Area.OnClicked:Add(self, self.GetPlan)
    ModController:SyncTarget(self.Uuid)
    for i = 1, 3 do
        self["FashionType0" .. i].Text_Item:SetText(GText(index2abc[i]))
        self["ModType0" .. i].Text_Item:SetText(GText(index2abc[i]))
        local ButtonNames = {
            [1] = "FashionType0",
            [2] = "ModType0"
        }
        for index, Name in ipairs(ButtonNames) do
            self[Name .. i].Btn_Check.OnPressed:Add(self, function()
                self[Name .. i]:PlayAnimation(self[Name .. i].Press)
            end)
            self[Name .. i].Btn_Check.OnHovered:Add(self, function()
                self[Name .. i]:PlayAnimation(self[Name .. i].Hover)
            end)
            self[Name .. i].Btn_Check.OnUnhovered:Add(self, function()
                self[Name .. i]:StopAnimation(self[Name .. i].Hover)
                self[Name .. i]:PlayAnimation(self[Name .. i].UnHover)
            end)

        end
        self["FashionType0" .. i].Btn_Check.OnClicked:Add(self, function()

            self:OnFashionSelected(i)
        end)
        self["ModType0" .. i].Btn_Check.OnClicked:Add(self, function()

            if self.OnModSelected then
                self:OnModSelected(i)
            end
        end)

    end
    self.Text_FashionTypeTitle:SetText(GText("UI_PersonInfo_Select_Appearance"))
    self.Btn_Confirm:SetText(GText("UI_PATCH_ENSURE"))
    self.Text_ModTypeTitle:SetText(GText("UI_PersonInfo_Select_Mod"))

    self.Btn_Confirm:SetGamePadImg("X")
    for i = 1, 3 do
        self["FashionType0" .. i]:SetFocusCallback(function(ItemWidget)
            if self.SelectAppearanceIndex == i then
                self:OnFocusSelectedItem(ItemWidget)
            else
                self:OnFocusNotSelectedItem(ItemWidget)
            end
        end)
        self["ModType0" .. i]:SetFocusCallback(function(ItemWidget)
            if self.SelectModIndex == i then
                self:OnFocusSelectedItem(ItemWidget)
            else
                self:OnFocusNotSelectedItem(ItemWidget)
            end
        end)
    end
    -- self.WBP_PersonalInfo_Edit_Tips.Btn_Confirm.Button_Area.OnClicked:Add(self,self.ChanegeShowPlan)
end

-- 外部传入回调函数，可用两个参数，第一个是选择的mod，第二个是选择的外观
function M:SetComfirmCallball(Callback, obj)
    self.ComfirmCallback = Callback
    self.ComfirmCallbackobj = obj
end

function M:OnComfirmClicked()
    if (self.ComfirmCallback) then
        self.ComfirmCallback(self.ComfirmCallbackobj, self.SelectModIndex, self.SelectAppearanceIndex)
    end
    if self.TipsType == TipsEnum.Weapon then
        AudioManager(self):PlayUISound(nil, "event:/ui/common/weapon_replace", nil, nil)
    elseif self.TipsType == TipsEnum.Char then
        AudioManager(self):PlayUISound(nil, "event:/ui/common/role_replace", nil, nil)
    end
    UIUtils.PlayCommonBtnSe(self)
end

function M:GetPlan()
    return self.SelectAppearanceIndex, self.SelectModIndex
end

function M:OnFashionSelected(index)

    if index == self.SelectAppearanceIndex then
        return
    end
    if self.SelectAppearanceIndex then
        self["FashionType0" .. self.SelectAppearanceIndex]:PlayAnimation(self["FashionType0" ..
                                                                             self.SelectAppearanceIndex].Normal)
        self["FashionType0" .. self.SelectAppearanceIndex].Btn_Check:SetChecked(false)
        self["FashionType0" .. self.SelectAppearanceIndex]:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    self.SelectAppearanceIndex = index

    self["FashionType0" .. self.SelectAppearanceIndex]:PlayAnimation(
        self["FashionType0" .. self.SelectAppearanceIndex].Click)
    self["FashionType0" .. self.SelectAppearanceIndex]:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self:SetIsDealWithVirtualAccept(true)

end
function M:OnModSelected(index)
    if index == self.SelectModIndex then
        return
    end
    if self.SelectModIndex then
        self["ModType0" .. self.SelectModIndex]:PlayAnimation(self["ModType0" .. self.SelectModIndex].Normal)
        self["ModType0" .. self.SelectModIndex].Btn_Check:SetChecked(false)
        self["ModType0" .. self.SelectModIndex]:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    self.SelectModIndex = index
    -- self["ModType0" .. self.SelectModIndex]:StopAllAnimations()
    self["ModType0" .. self.SelectModIndex]:PlayAnimation(self["ModType0" .. self.SelectModIndex].Click)

    self["ModType0" .. self.SelectModIndex]:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self:SetIsDealWithVirtualAccept(true)

end

function M:SetTitle(NameId)
    self.Text_Title:SetText(GText(NameId))
end

function M:FreshModText(uuid)
    ModController:SyncTarget(self.Uuid)
    for i = 1, 3 do
        local ModName = ModController:GetModel():GetModName(i)
        self["ModType0" .. i].Text_Item:SetText(GText(ModName))
    end

end
--- 根据角色Uuid刷新外观方案名字
---@param Uuid 角色Uuid
function M:FreshSuitText(Uuid)
    local Avatar = GWorld:GetAvatar()
    local Char = Avatar.Chars[Uuid]
    for i = 1, 3 do
        local SuitName = Char.AppearanceSuits[i].AppearanceName
        if SuitName == "" then
            SuitName = OriginPlanname[i]
        end
        self["FashionType0" .. i].Text_Item:SetText(GText(SuitName))
    end
end
--- 根据角色Uuid刷新mod方案名字
---@param Uuid 角色或武器Uuid
function M:FreshModText(Uuid)
    ModController:SyncTarget(Uuid)
    for i = 1, 3 do
        local SuitName = ModController:GetModel():GetSuitName(i)
        if SuitName then
            self["ModType0" .. i].Text_Item:SetText(SuitName)
        end
    end
end

-- 刷新tip成为武器样式，传入武器名字,稀有度和uuid.SelectModId可选，不选默认1,IsCharSound
function M:FreahWeaponView(Name, Rarity, Uuid, SelectModId, IsCharSound)
    if IsCharSound then
        self.TipsType = TipsEnum.Char
    else
        self.TipsType = TipsEnum.Weapon
    end

    if SelectModId then
        self:OnModSelected(SelectModId)
    else
        self:OnModSelected(1)
    end
    UIUtils:SetTextColorInMaterialByRarity(self,self.Text_Title, Rarity)
    self.Text_Title:SetText(GText(Name))
    self.Panel_Fashion:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.HB_FashionType:SetVisibility(UIConst.VisibilityOp.Collapsed)
    local currentSize = self.Group_Tips.Slot:GetSize()
    self.Group_Tips.Slot:SetSize(FVector2D(currentSize.X, self.Group_TipsSize_Weapon))
    self:FreshModText(Uuid)

end
---刷新角色tip详情
---@param Name 角色名字
---@param Rarity 角色稀有度
---@param SelectFashionId 选择的外观
---@param SelectModId 选择的mod
---@param Uuid 用于刷新外观方案名字的Uuid
function M:FreahCharView(Name, Rarity, SelectFashionId, SelectModId, Uuid)
    self.TipsType = TipsEnum.Char
    if Uuid then
        self:FreshSuitText(Uuid)
    end
    UIUtils:SetTextColorInMaterialByRarity(self,self.Text_Title, Rarity)
    self.Text_Title:SetText(GText(Name))
    if SelectModId then
        self:OnModSelected(SelectModId)
    else
        self:OnModSelected(1)
    end
    if SelectFashionId then
        self:OnFashionSelected(SelectFashionId)
    else
        self:OnFashionSelected(1)
    end
    local currentSize = self.Group_Tips.Slot:GetSize()
    self.Group_Tips.Slot:SetSize(FVector2D(currentSize.X, self.Group_TipsSize_Avatar))
    self.Panel_Fashion:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.HB_FashionType:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self:FreshModText(Uuid)
end
--- 聚焦第一个item
function M:FocuesFirstItem()
    if self.Text_FashionTypeTitle.Visibility == UIConst.VisibilityOp.Visible then
        self["FashionType01"]:SetFocus()
    else
        self["ModType01"]:SetFocus()
    end
end

function M:SetOnFocusSelectedItemCallback(Callback)
    self.OnFocusSelectedItem = Callback
end

function M:SetOnFocusNotSelectedItemCallback(Callback)
    self.OnFocusNotSelectedItem = Callback
end
function M:OnFocusSelectedItem(ItemWidget)
    if self.OnFocusSelectedItem and self.ComfirmCallbackobj then
        self.OnFocusSelectedItem(self.ComfirmCallbackobj, ItemWidget)
    end
    self:SetIsDealWithVirtualAccept(true)
end
function M:OnFocusNotSelectedItem(ItemWidget)
    if self.OnFocusNotSelectedItem and self.ComfirmCallbackobj then
        self.OnFocusNotSelectedItem(self.ComfirmCallbackobj, ItemWidget)
    end
end

return M
