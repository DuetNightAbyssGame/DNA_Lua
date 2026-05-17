local ImpressionTypes = require"BluePrints.UI.UI_PC.Impression.ImpressionConst".ImpressionTypes

---@type BP_DimensionDrawArea_C
local BP_DimensionDrawArea_C = Class("BluePrints.UI.BP_EMUserWidget_C")

-- function BP_DimensionDrawArea_C:Initialize(Initializer)
-- end

-- function BP_DimensionDrawArea_C:PreConstruct(IsDesignTime)
-- end

-- function BP_DimensionDrawArea_C:Construct()
-- end

-- function BP_DimensionDrawArea_C:Tick(MyGeometry, InDeltaTime)
-- end

function BP_DimensionDrawArea_C:Init(ImpressionAreaId, UsingGM)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        local Message = "Avatar不存在，印象五维图读取数据失败"
        local Title = "Avatar不存在"
        if not UsingGM then
            UStoryLogUtils.PrintToFeiShu(self, UE.EStoryLogType.Impression, Title, Message)
        end
        return
    end
    local Impression = Avatar:GetRegionImpression(ImpressionAreaId)
    local ImpressionMaxValue = DataMgr.GlobalConstant.ImressionMax.ConstantValue
    for Index, ImpressionType in pairs(ImpressionTypes) do
        local PlayerValue = Impression:GetImpressionValueByType(ImpressionType)
        local CorrectionValue = (PlayerValue + 10) * 0.91
        local NormalizedValue = math.min(1, CorrectionValue / ImpressionMaxValue)
        self.RegularPolygonImage:SetPointRatio(Index - 1, NormalizedValue)

        local DimensionIcon = self:GetDimensionIcon(Index)
        local ImpressionConfigInfo = DataMgr.ImpressionConfig[ImpressionType]
        local IconTexture = LoadObject(ImpressionConfigInfo.StatusCommonIcon)
        DimensionIcon:SetIcon(IconTexture)

        local PlayerValue = Impression:GetImpressionValueByType(ImpressionType)
        self["BP_Group_DimensionIcon_" .. Index]:Init(ImpressionType, PlayerValue)
    end
end

function BP_DimensionDrawArea_C:GetDimensionIcon(Index)
    return self["BP_Group_DimensionIcon_" .. Index]
end

function BP_DimensionDrawArea_C:ForceDefault()
    self:PlayAnimation(self.In)
    self:StopAllAnimations()
end

function BP_DimensionDrawArea_C:SetGrowStyle(Index)
    local DimensionIcon = self:GetDimensionIcon(Index)
    DimensionIcon:PlayAddAnim()
end

function BP_DimensionDrawArea_C:SwitchActive(bActive)
    if bActive then
        self:SetVisibility(ESlateVisibility.Visble)
        self:StopAnimation(self.Out)
        self:PlayAnimation(self.In)
        self:StartLoop()
    else
        self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self:StopAnimation(self.In)
        self:PlayAnimation(self.Out)
        self:StopLoop()
    end
end

function BP_DimensionDrawArea_C:StartLoop()
    self:PlayAnimation(self.Loop, 0, 5)
    AudioManager(self):PlayUISound(self, "event:/ui/common/map_five_dimension_panel_show", "DimensionPanel", nil)
end

function BP_DimensionDrawArea_C:StopLoop()
    self:StopAnimation(self.Loop)
    AudioManager(self):SetEventSoundParam(self, "DimensionPanel", {ToEnd = 1})
end

function BP_DimensionDrawArea_C:Destruct()
    AudioManager(self):SetEventSoundParam(self, "DimensionPanel", {ToEnd = 1})
end

return BP_DimensionDrawArea_C
