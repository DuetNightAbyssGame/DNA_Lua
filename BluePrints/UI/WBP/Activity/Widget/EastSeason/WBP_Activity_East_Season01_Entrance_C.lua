--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_East_Season01_Entrance_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})
local EastSeasonQuestUtils = require "BluePrints.UI.WBP.Activity.Widget.EastSeason.EastSeasonQuestUtils"


function M:Construct()
    self.Btn_Click.OnClicked:Add(self, self.OnClick)
    self.Btn_Click.OnPressed:Add(self, self.OnPressed)
end

function M:InitUI()
    local QuestPhaseId = EastSeasonQuestUtils:GetQuestPhaseIdByTabId(self.EventId, self.TabId)
    local CompletedQuestCount, TotalQuestCount = EastSeasonQuestUtils:GetQuestPhaseInfo(self.EventId, QuestPhaseId)
    self.Text_Progress:SetText(CompletedQuestCount .. "/" .. TotalQuestCount)
    if EastSeasonQuestUtils:IsQuestPhaseCanGetReward(self.EventId, QuestPhaseId) then
        self.Reddot:SetVisibility(UIConst.VisibilityOp["Visible"])
        self:PlayAnimation(self.Able)
    else
        self.Reddot:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self:PlayAnimation(self.Normal)
    end

    for _, phaseData in pairs(DataMgr.CommonQuestPhase) do
        if phaseData.Index == self.TabId and phaseData.EventId == self.EventId then
            self.Text_Type:SetText(GText(phaseData.QuestPhaseName))
            local IconTexture = LoadObject(phaseData.Icon)
            self.Icon_Type:SetBrushFromTexture(IconTexture)
        end
    end
end

function M:AddSpline(IsLock)
    -- 创建背景组件
    for _, phaseData in pairs(DataMgr.CommonQuestPhase) do
        if phaseData.Index == self.TabId and phaseData.EventId == self.EventId then
            if phaseData.SplineBP and IsValid(self.Slot_Spine) then
                self.Slot_Spine:ClearChildren()
                local NewBgWidget = UIManager(self):CreateWidget(phaseData.SplineBP)
                if NewBgWidget then
                    local OverSlot = self.Slot_Spine:AddChildToOverlay(NewBgWidget)
                    OverSlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
                    OverSlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
                    if not IsLock then
                        NewBgWidget:PlayAnimation(NewBgWidget.In)
                    end
                end
            end
        end
    end
end

function M:OnClick()
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()

    local UIName = "ActivityEastTask"
    if DataMgr.SystemUIName[self.EventId] then
        UIName = DataMgr.SystemUIName[self.EventId].UIName
    end
    local TaskPage = UIManager:GetUIObj(UIName)
    if (not TaskPage) then
        TaskPage = UIManager:LoadUINew(UIName, self.EventId, self.TabId, self.ParentWidget)
        UIManager:AddToJumpPageDeque(TaskPage)
    end
end

function M:OnPressed()
    AudioManager(self):PlayUISound(nil,"event:/ui/activity/huaxu_sub_page_btn_click", nil, nil)
end

function M:BP_GetDesiredFocusTarget()
    return self.Btn_Click
end



return M
