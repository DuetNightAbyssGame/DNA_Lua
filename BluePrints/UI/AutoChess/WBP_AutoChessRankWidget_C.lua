require "UnLua"
local UIUtils = require "Utils.UIUtils"
local View = Class({
    "BluePrints.UI.BP_EMUserWidget_C",
})

function View:UpdateRankInfo(RankLevel, RankScore)
    local AutoChessPointData = DataMgr.AutoChessPoint
    if not AutoChessPointData[RankLevel] then
        DebugPrint("Tianyi@ UpdateRankInfo failed, invalid RankLevel: "..tostring(RankLevel))
        return
    end

    self.Text_Rank:SetText(GText(AutoChessPointData[RankLevel].RankName))
    self.Text_Exp:SetText(string.format("%d/%d", RankScore, AutoChessPointData[RankLevel].RankMaxPoint))
    self.Icon_Rank:SetBrushFromTexture(LoadObject(AutoChessPointData[RankLevel].RankIcon))
end

return View