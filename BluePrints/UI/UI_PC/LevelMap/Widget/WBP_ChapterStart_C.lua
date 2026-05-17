--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local Utils = require "Utils"

---@type WBP_ChapterStart_PurgatorioIsland_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

--todo 先做净界岛的显示，后面出新的场景介绍样式动态改
function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    --local Text, WorldText = ...
    self.Text_Title:SetText(GText("ChapterIntro_PurgatorioIsland"))
    self:SetFontSize()
    self.Text_World:SetText(GText("ChapterIntroWd_PurgatorioIsland"))
    self:PlayAnimation(self.In)
    AudioManager(self):PlayUISound(self, "event:/ui/common/map_name_show", "", nil)
end

function M:SetFontSize()
    local Language = CommonConst.SystemLanguage
    if Language == CommonConst.SystemLanguages.CN or Language == CommonConst.SystemLanguages.TC then
        self.Text_Title.Font.Size = self.TextSize_ZH_CHS
    elseif Language == CommonConst.SystemLanguages.EN then
        self.Text_Title:SetVisibility(ESlateVisibility.Collapsed)
        self.Text_Title.Font.Size = self.TextSize_EN
    elseif Language == CommonConst.SystemLanguages.JP then
        self.Text_Title.Font.Size = self.TextSize_JA
    elseif Language == CommonConst.SystemLanguages.KR then  
        self.Text_Title.Font.Size = self.TextSize_KR
    end
end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M
