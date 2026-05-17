
require "UnLua"
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
local SkillUtils = require "Utils.SkillUtils"

---@type WBP_Armory_Pet_InfoDialog_C
local M = Class({"BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"})

function M:PreInitContent(Params, PopupData, Owner)
    self.Owner = Owner
    self:BindDialogEvent(DialogEvent.OnTitleTabSelected, function(self, TabWidget)
        self.EMScrollBox:ScrollToStart()
        self:UpdateContent(TabWidget.Idx)
    end)
end

function M:InitContent(Params, PopupData, Owner)
    M.Super.InitContent(self, Params, PopupData, Owner)

    self.Pet = Params.Pet
    if not self.Pet then
        return
    end

    self:UpdateContent(1)
end

function M:UpdateContent(TabIndex)
    local Contents = {}
    if TabIndex == 1 then
        Contents = self:GetPetPositiveContents()
    else
        Contents = self:GetPetPassiveContents()
    end

    local Panel = self.WB_PetInfo
    local Widget = Panel:GetChildAt(0)
    if not Widget then
        return
    end

    local WidgetCount = 0
    local WidgetClass = UGameplayStatics.GetObjectClass(Widget)

    -- 初始化子控件
    for _, Content in ipairs(Contents) do
        Widget = Panel:GetChildAt(WidgetCount)
        if(not Widget)then
            Widget = UIManager(self):CreateWidget(WidgetClass)
            Panel:AddChild(Widget)
        end
        Widget:OnListItemObjectSet(Content)
        WidgetCount = WidgetCount + 1
    end

    -- 移除多余子控件
    if(WidgetCount > 0)then
        Panel:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        local Start,End = WidgetCount,Panel:GetChildrenCount() - 1
        for i = Start,End do
            Panel:RemoveChildAt(i)
        end
    else
        Panel:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

-- 魔灵支援
function M:GetPetPositiveContents()
    if self.PositiveContents then
        return self.PositiveContents
    end

    local Data = DataMgr.BattlePet[self.Pet:Data().BattlePetId]
    if not Data or not Data.SupportSkillId then
        return
    end

    local SkillData = DataMgr.Skill[Data.SupportSkillId]
    if not SkillData then
        return
    end

    self.PositiveContents = {}

    for Level, _ in ipairs(SkillData) do
        local Content = {}
        Content.Level = Level
        Content.Des = SkillUtils.GetSkillDesc(Data.SupportSkillId, Level)
        Content.IsCurLevel = (self.Pet.BreakNum == (Level - 1))
        table.insert(self.PositiveContents,Content)
    end

    return self.PositiveContents
end

-- 被动技能
function M:GetPetPassiveContents()
    if self.PassiveContents then
        return self.PassiveContents
    end

    local Data = DataMgr.BattlePet[self.Pet:Data().BattlePetId]
    if not Data or not Data.SupportSkillId then
        return
    end

    local SkillData = DataMgr.Skill[Data.SupportSkillId]
    if not SkillData then
        return
    end

    self.PassiveContents = {}

    for Level, _ in ipairs(SkillData) do
        local Content = {}
        Content.Level = Level
        Content.Des = ArmoryUtils:GenPetPassiveEffectDesc(Data, Level)
        Content.IsCurLevel = (self.Pet.BreakNum == (Level - 1))
        table.insert(self.PassiveContents,Content)
    end

    return self.PassiveContents
end

function M:OnContentAnalogValueChanged(MyGeometry, InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == UIConst.GamePadKey.RightAnalogY) then
        local DeltaOffset = (-1) * UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 5
        local CurrentOffset = self.EMScrollBox_48:GetScrollOffset()
        local NextOffset = math.clamp(CurrentOffset + DeltaOffset,0, self.EMScrollBox_48:GetScrollOffsetOfEnd())
        self.EMScrollBox_48:SetScrollOffset(NextOffset)
        return UIUtils.Handled
    end
    return UIUtils.Unhandled
end

return M
