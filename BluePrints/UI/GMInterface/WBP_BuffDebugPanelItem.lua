--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local WBP_BuffDebugPanelItem_C = Class({
    "BluePrints.Common.TimerMgr",
})

function WBP_BuffDebugPanelItem_C:OnListItemObjectSet(Content)
    self.Content = Content
    self:Expand(false)
    self:RefreshView()
    self.BtnExpand.OnClicked:Clear()
    self.BtnExpand.OnClicked:Add(self, self.OnBtnExpandClicked)
end

function WBP_BuffDebugPanelItem_C:OnBtnExpandClicked()
    local ShouldExpand = self.ExpandedBuff == nil
    self:Expand(ShouldExpand)
end

function WBP_BuffDebugPanelItem_C:UpdateSimpleView()
    local BuffData = DataMgr.Buff[self.Content.Id]
    local Ret = string.format("Id:%d LeftTime:%.1f Value:%.1f Layer:%d SourceEid:%d Type:%s", 
        self.Content.Id,
        self.Content.LeftTime,
        self.Content.Value,
        self.Content.Layer,
        self.Content.SourceEid,
        BuffData.MergeRule2)
    self.TxtSimple:SetText(Ret)
end

function WBP_BuffDebugPanelItem_C:UpdateDetailsView()
    self:UpdateSimpleView()
    local Ret = ""
    for Index, LayerInfo in ipairs(self.Content.Layers) do
        local LayerStr = string.format("Layer Uid:%d LeftTime:%.1f Value:%.1f SourceEid:%d%s",
            LayerInfo.Uid, LayerInfo.LeftTime, LayerInfo.Value, LayerInfo.SourceEid, Index < #self.Content.Layers and "\n" or "")
        Ret = Ret .. LayerStr
    end
    self.TxtVerbose:SetText(Ret)
end

function WBP_BuffDebugPanelItem_C:RefreshView()
    if self.ExpandedBuff == self.Content.Id then
        self:UpdateDetailsView()
    else
        self:UpdateSimpleView()
        self:Expand(false)
    end
end

function WBP_BuffDebugPanelItem_C:Expand(bExpand)
    if bExpand then
        self.TxtVerbose:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self:UpdateDetailsView()
        self.ExpandedBuff = self.Content.Id
        self.TxtExpand:SetText("v")
    else
        self.TxtVerbose:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.ExpandedBuff = nil
        self.TxtExpand:SetText(">")
    end
end

return WBP_BuffDebugPanelItem_C