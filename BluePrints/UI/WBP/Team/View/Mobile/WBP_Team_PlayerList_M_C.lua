--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local TeamModel = TeamController:GetModel()


---@type WBP_Team_PlayerList_M_C|WBP_Team_PlayerList_Base
local M = Class({"BluePrints.UI.WBP.Team.View.WBP_Team_PlayerList_Base"})

function M:Construct()
    M.Super.Construct(self)
    self.CanvasPanel_2:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:InitUIInfo(Name, bInUIMode, EventList, ...)
    M.Super.InitUIInfo(self, Name, bInUIMode, EventList, ...)
    self.Block:SetVisibility(UIConst.VisibilityOp.Collapsed)
    if not GWorld:IsStandAlone() then
        self.CanvasPanel_2:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:AddTeammateUI(Member,ItemUI, Index, bAnim)
    M.Super.AddTeammateUI(self, Member, ItemUI, Index, bAnim)
    self.Teammate2UI[Member.Uid]:SetOnMenuOpenChangeCb(function(bOpen)
        if bOpen then
            self.Block:SetVisibility(UIConst.VisibilityOp.Visibility)
        else
            self.Block:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end)
end

function M:Close()
    local BattleMainUI = UIManager(self):GetUIObj(DataMgr.SystemUI.BattleMain.UIName)
    if (IsValid(BattleMainUI) and BattleMainUI.IsInit) then
        BattleMainUI.Team:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        -- 手机上暂时不需要Team_In动画
        -- BattleMainUI:PlayAnimation(BattleMainUI.Team_In)
    end

    M.Super.Close(self)
end

function M:_UpdateMemberTag(Uid)
    if TeamModel:IsYourself(Uid) then
        self.Teammate2UI[Uid]:UpdateTag()
    elseif self.Teammate2UI[Uid] then
        self.Teammate2UI[Uid]:UpdateTag()
    end
end

return M
