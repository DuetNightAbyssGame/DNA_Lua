
require "UnLua"

---@type WBP_Settlement_FailTips_C
local WBP_Settlement_FailTips_C = Class("BluePrints.UI.BP_EMUserWidget_C")

function WBP_Settlement_FailTips_C:InitialTips(DungeonId, IsInHardBoss)
    self.Text01:SetText(GText("UI_DungeonFail_Tips1"))
    self.Text02:SetText(GText("UI_DungeonFail_Tips2"))
    self.List_Tips:ClearListItems()

    -- 设置小白头像
    --local Material = self.Img_Avatar:GetDynamicMaterial()
    --Material:SetScalarParameterValue("XNum", 3.0)
    --Material:SetScalarParameterValue("YNum", 7.0)

    local GuideCombinationId = -1
    if IsInHardBoss then
        GuideCombinationId = DataMgr.HardBossMain[DungeonId].GuidanceTitle
    else
        local ChapterId = DataMgr.DungeonId2ChapterId[DungeonId]
        if ChapterId then
            GuideCombinationId = DataMgr.SelectDungeon[ChapterId].GuidanceTitle
        else
            ChapterId = DataMgr.WeeklyDungeonId2ChapterId[DungeonId]
            if ChapterId then
                GuideCombinationId = DataMgr.WeeklySelectDungeon[ChapterId].GuidanceTitle
            else
                DebugPrint("zwk 失败结算当前副本Id既没有出现在SelectDungeon表也没有出现在WeeklySelectDungeon表中，默认使用200001失败指引组合，当前副本ID:", DungeonId)
                GuideCombinationId = 200001
            end
        end
    end

    local GuideCombinationInfo = DataMgr.FailureGuidanceCombination[GuideCombinationId]

    for _, v in ipairs(GuideCombinationInfo.GuidanceModuleId) do
        local GuidanceInfo = DataMgr.FailureGuidance[v]
        local Tips = NewObject(UE4.LoadClass(UIConst.SETTLEMENTFAILURETIPS))
        Tips.Title = GuidanceInfo.GuidanceTitle
        Tips.Text = GuidanceInfo.GuidanceText
        Tips.Icon = LoadObject(GuidanceInfo.GuidanceIcon)
        self.List_Tips:AddItem(Tips)
    end

    local IsScrollDisable = self.List_Tips:IsDisableScroll()
    self.List_Tips:SetAllowOverscroll(IsScrollDisable)
end

function WBP_Settlement_FailTips_C:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == UIConst.GamePadKey.RightAnalogX) then
        local DeltaOffset = 1 * UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 5
        local CurrentOffset = self.List_Tips:GetScrollOffset()
        local NextOffset = math.clamp(CurrentOffset + DeltaOffset,0, self.List_Tips:GetScrollOffsetOfEnd())
        self.List_Tips:SetScrollOffset(NextOffset)
        return UIUtils.Handled
    end
    return UIUtils.Unhandled
end

return WBP_Settlement_FailTips_C
