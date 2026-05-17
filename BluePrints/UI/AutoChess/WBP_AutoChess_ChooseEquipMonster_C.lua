--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_AutoChess_ReplaceMonster_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})
local Model = require  "BluePrints.UI.AutoChess.AutoChessDataModel"

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Btn_Click.OnHovered:Add(self, self.OnHover)
    self.Btn_Click.OnUnhovered:Add(self, self.OnUnHover)
    self.Btn_Click.OnPressed:Add(self, self.OnPress)
    self.Btn_Click.OnReleased:Add(self, self.OnReleased)
    self.Btn_Click.OnClicked:Add(self, self.OnClick)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
    self.Btn_Click.OnHovered:Remove(self, self.OnHover)
    self.Btn_Click.OnUnhovered:Remove(self, self.OnUnHover)
    self.Btn_Click.OnPressed:Remove(self, self.OnPress)
    self.Btn_Click.OnReleased:Remove(self, self.OnReleased)
    self.Btn_Click.OnClicked:Remove(self, self.OnClick)
end

function M:OnListItemObjectSet(Content)
    self.Content = Content
    Content.UI = self
    if Content.Selected then
        self:PlayAnimation(self.Click)
    else
        self:PlayAnimation(self.Normal)
    end
    local Info = DataMgr.CombatChessInfo[Content.Id]
    self.CurCost = Info.DeployCost
    self.Chess.Image_Head:SetBrushResourceObject(LoadObject(Info.MonsterIcon))
    self.Chess.Icon_Type.Icon:SetBrushResourceObject(LoadObject(Info.PositionIcon))
    self.Chess.Text_Name:SetTexT(GText(Info.CombatChessName)) 
    self.Chess:SetLocked(false)
    --self.Chess.Text_Cost:SetTexT(self.BaseCost)
    local Equips = Model:GetMonsterEquipInfo(Content.Id)
    self:UpdateCost(Equips)
    self:UpdateEquipInfo(#Equips)
end

function M:UpdateCost(Equips)
    for key, value in pairs(Equips) do
        local DeployCost = DataMgr.RobotEquip[value].DeployCost
        self.CurCost = self.CurCost + DeployCost
    end
    self.Chess.Text_Cost:SetTexT(self.CurCost)
end


function M:OnClick()
    if self.Content.Parent.CurChess and self.Content.Parent.CurChess == self.Content then
        return
    end
    self.Content.Selected = true
    if self.Content.Parent.CurChess and self.Content.Parent.CurChess ~= self.Content then
        self.Content.Parent.CurChess.Selected = false
        if self.Content.Parent.CurChess.UI then
            self.Content.Parent.CurChess.UI:OnReleased()
        end
    end
    AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_icon_btn_click", nil, nil)
    self:PlayAnimation(self.Click)
    if self.Content.Parent then
        self.Content.Parent.CurChess = self.Content
        self.Content.Parent:OnClickChess()
    end
end

function M:UpdateEquipInfo(EquipItems)
    local EquipItemsNum = EquipItems
    self.Chess.Equipment_01.WS_Type:SetActiveWidgetIndex(1)
    self.Chess.Equipment_02.WS_Type:SetActiveWidgetIndex(1)
    if EquipItemsNum >= 1 then
        self.Chess.Equipment_01.WS_Type:SetActiveWidgetIndex(0)
    end
    if EquipItemsNum >= 2 then
        self.Chess.Equipment_02.WS_Type:SetActiveWidgetIndex(0)
    end
end


function M:AddEquip(Id)
    if self.Chess.Equipment_01.WS_Type:GetActiveWidgetIndex() == 1 then
        self.Chess.Equipment_01.WS_Type:SetActiveWidgetIndex(0)
        self.Chess.Equipment_01:PlayAnimation(self.Chess.Equipment_01.Add)
    elseif self.Chess.Equipment_02.WS_Type:GetActiveWidgetIndex() == 1 then
        self.Chess.Equipment_02.WS_Type:SetActiveWidgetIndex(0)
        self.Chess.Equipment_02:PlayAnimation(self.Chess.Equipment_02.Add)
    end
    local Info = DataMgr.RobotEquip[Id]
    if Info then
        local Cost = self.CurCost + Info.DeployCost
        self.CurCost = Cost
        self.Chess.Text_Cost:SetTexT(Cost)
    end
end


function M:RemoveEquip(Count, Id)
    if Count == 1 then
        self.Chess.Equipment_02.WS_Type:SetActiveWidgetIndex(1)
        self.Chess.Equipment_02:PlayAnimation(self.Chess.Equipment_02.Delect)
    else
        self.Chess.Equipment_01.WS_Type:SetActiveWidgetIndex(1)
        self.Chess.Equipment_02.WS_Type:SetActiveWidgetIndex(1)
        self.Chess.Equipment_01:PlayAnimation(self.Chess.Equipment_01.Delect)
    end
    local Info = DataMgr.RobotEquip[Id]
    if Info then
        local Cost = self.CurCost - Info.DeployCost
        self.CurCost = Cost
        self.Chess.Text_Cost:SetTexT(Cost)
    end
end

function M:OnHover()
    if self.Content.Selected then return end
    self:PlayAnimation(self.Hover)
end

function M:OnUnHover()
    if self.Content.Selected then return end
    self:StopAnimation(self.Hover)
    self:PlayAnimation(self.UnHover)
end
function M:OnPress()
    if self.Content.Selected then return end
    self:PlayAnimation(self.Press)
end

function M:OnReleased()
    if self.Content.Selected then return end
    self:PlayAnimation(self.Normal)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    self:OnClick()
    return UIUtils.Handled
end


return M
