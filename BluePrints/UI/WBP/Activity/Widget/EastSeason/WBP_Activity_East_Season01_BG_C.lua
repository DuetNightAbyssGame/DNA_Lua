--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_East_Season01_BG_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})
local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"
local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"
local EastSeasonQuestUtils = require "BluePrints.UI.WBP.Activity.Widget.EastSeason.EastSeasonQuestUtils"

function M:InitUI(ActivityConfigData, PageConfigData)
    self.FocusWidgetName = "SelectView"
    self.IsLock = false
    local PlayerAvatar = GWorld:GetAvatar()
	if (PageConfigData.JumpUnlockCondition) then
		if (not ConditionUtils.CheckCondition(PlayerAvatar, PageConfigData.JumpUnlockCondition)) then
            self.IsLock = true
		end
	end


    self.EventId = ActivityConfigData.EventId
    -- 遍历Entrance01到Entrance04，设置他们的EventId和TabId
    for i = 1, 4 do
        local Entrance = self["Entrance0" .. i]
        if Entrance then
            Entrance.EventId = ActivityConfigData.EventId
            Entrance.TabId = i
            Entrance.ParentWidget = self
            Entrance:InitUI()
            if self.IsLock then
                Entrance:PlayAnimation(Entrance.Info_Forbidden)
                Entrance:SetVisibility(UIConst.VisibilityOp["HitTestInvisible"])
            else
                Entrance:PlayAnimation(Entrance.Info_Normal)
                Entrance:SetVisibility(UIConst.VisibilityOp["Visible"])
            end
        end
    end

    if self.Btn_Shop then
        self.Btn_Shop.Key_Controller:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "View"
                }
            }
        })
    end

    self.Entrance04:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
end

function M:PlaySplineAnimation()
    for i = 1, 4 do
        local Entrance = self["Entrance0" .. i]
        if Entrance then
            Entrance:AddSpline(self.IsLock)
        end
    end
end

function M:RefreshUI()
    self:PlayAnimation(self.In)
    for i = 1, 4 do
        local Entrance = self["Entrance0" .. i]
        if Entrance then
            Entrance:InitUI()
            Entrance:AddSpline()
        end
    end
    local bShowRedDot = false
    for _, phaseConfig in pairs(DataMgr.CommonQuestPhase) do
        if phaseConfig.EventId == self.EventId then
            if EastSeasonQuestUtils:IsQuestPhaseCanGetReward(self.EventId, phaseConfig.QuestPhaseId) then
                ActivityReddotHelper.TryAddReddotCount(ActivityUtils,self.EventId,"Red")
                bShowRedDot = true
                break
            end
        end
    end
    if not bShowRedDot then
        ActivityReddotHelper.TrySubReddotCount(ActivityUtils, self.EventId, "Red")
    end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == UIConst.GamePadKey.FaceButtonRight then
        local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
        if ActivityMain then
            self:SetActivityMainFocus()
            return UE4.UWidgetBlueprintLibrary.Handled()
        end
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:FocusUI()
    self.Entrance01:SetFocus()
end

function M:SetActivityMainFocus()
    local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
    if ActivityMain then
        ActivityMain.List_Tab:SetFocus()
    end
end

function M:UpdateUIStyleInPlatform(IsUseGamePad)
    if self.Btn_Shop then
        self.Btn_Shop.Key_Controller:SetVisibility(IsUseGamePad and UIConst.VisibilityOp["Visible"] or UIConst.VisibilityOp["Collapsed"])
    end
end

function M:HandleKeyDownOnGamePad(InKeyName)
    if InKeyName == UIConst.GamePadKey.SpecialLeft then
        if self.Btn_Shop then
            self.Btn_Shop:OnClickShop()
            return true
        end
    end
    return false
end

return M
