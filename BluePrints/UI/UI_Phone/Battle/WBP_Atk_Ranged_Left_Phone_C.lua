--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Battle_AtkRangedLeft_M_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

M._components = {
    "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent",
}

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.OwnerPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
    self.CurButtonState = "Normal"
    self.OccupiedTag = "Left"
    self.ImageMat = self.Image_Main:GetDynamicMaterial()
    self.Btn_AtkRange.OnPressed:Add(self, self.OnBtnPressed)
    self.Btn_AtkRange.OnReleased:Add(self, self.OnBtnReleased)
end

function M:OnBtnPressed()
    -- 逻辑层
    if not self.OwnerPanel.FireOccupied then
        self.OwnerPanel.FireOccupied = self.OccupiedTag
    else
        return
    end
    self.OwnerPanel:TryToPlayTargetCommand("Fire", true)
    -- 表现层
    if self.CurButtonState == "Ban" then
        UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText("UI_RANGED_FORBIDDEN"))
        return
    elseif self.OwnerPlayer:CheckSkillInActive(ESkillName.Fire) or self.Cur then
        return
    end
    if self.CurButtonState ~= "Forbidden" then
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Press)
    end
end

function M:OnBtnReleased()
    -- 逻辑层
    if self.OwnerPanel.FireOccupied == self.OccupiedTag then
        self.OwnerPanel.FireOccupied = nil
    else
        return
    end
    self.OwnerPanel:TryToStopTargetCommand("Fire", true)

    -- 表现层
    if (self.CurButtonState ~= "Forbidden" and self.CurButtonState ~= "Ban" and self.CurButtonState ~= "Empty") then
        if EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.Press) then
            EMUIAnimationSubsystem:EMStopAnimation(self,self.Press)
        end
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
        
    end
end

-- 由AtkRanged_Phone调用
function M:OnWeaponHUDIconLoadFinish(Object)
    self:WeaponIcon() -- 这个函数是蓝图实现的
    self.ImageMat = self.Image_Main:GetDynamicMaterial()
    if self.ImageMat then
        self.ImageMat:SetTextureParameterValue("Icon_Ranged", Object)
    end
    self:UpdateRangeWeaponButtonByState(self.CurButtonState)
end

-- 由AtkRanged_Phone调用
function M:OnPropIconLoadFinish(Object)
    self:OrganIcon(Object) -- 这个函数是蓝图实现的
end

-- 由AtkRanged_Phone调用
function M:UpdateRangeWeaponButtonByState(CurButtonState)
    self.CurButtonState = CurButtonState
    DebugPrint("Left射击键当前状态", self.CurButtonState)
    if self.CurButtonState == "Forbidden" then
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Forbidden)
    elseif self.CurButtonState == "ChangeMagazine" then
        self.ImageMat:SetScalarParameterValue("IconState", 1)
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
    elseif self.CurButtonState == "Normal" then
        self.ImageMat:SetScalarParameterValue("IconState", 2)
        self:StopAllAnimations()
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
        self.Image_Main:SetRenderOpacity(1.0)
    elseif self.CurButtonState == "Empty" then
        self.ImageMat:SetScalarParameterValue("IconState", 0)
    end
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

AssembleComponents(M)

return M
