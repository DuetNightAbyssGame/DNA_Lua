--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Armory_Skin_M_C|WBP_Armory_Skin_Base_C
local M = Class("BluePrints.UI.WBP.Armory.Appearance.WBP_Armory_Skin_Base_C")

--function M:Initialize(Initializer)
--end

function M:Construct()
    M.Super.Construct(self)
    self.Btn_Hide.OnCheckStateChanged:Add(self,self.OnHideBtnCheckStateChanged)
    self.Btn_Hide:SetCheckedState(ECheckBoxState.Unchecked)
    self.Btn_Restore:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:OnTabConfigCreated(TabConfig)
    TabConfig.StyleName = "Armory"
end

function M:OnHideBtnCheckStateChanged(IsCheck)
    if(IsCheck)then
        if(not self.bSelfHidden)then
            self:OnHideUIKeyDown()
        end
    else
        if(self.bSelfHidden)then
            self:OnHideUIKeyDown()
        end
    end
end

function M:OnHideUIKeyDown()
    M.Super.OnHideUIKeyDown(self)
    if(self.bSelfHidden)then
        self.Btn_Hide:SetCheckedState(ECheckBoxState.Checked)
    else
        self.Btn_Hide:SetCheckedState(ECheckBoxState.Unchecked)
    end
end

function M:UpdateAccessoryDetails(Content)
    M.Super.UpdateAccessoryDetails(self,Content)
    if(CommonConst.ActionAccessoryTypes[Content.AccessoryType])then
        self.Btn_Restore:SetVisibility(UIConst.VisibilityOp.Visible)
    else
        self.Btn_Restore:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:OnReplayBtnClicked()
    if(self.ComparedContent)then
        self:Replay(self.ComparedContent)
    end
end

function M:OpenAccessoryCustom(Content)
    M.Super.OpenAccessoryCustom(self,Content)
    self.Tab_Skin.Panel_Tab:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M
