--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Shop_Recommend_Common_TItle_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C","BluePrints.UI.BP_EMUserWidgetUtils_C"})
local OrigFontSize = nil
local OrigWrapTextAt = nil
---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    if not OrigFontSize then
        OrigFontSize = self.Text_MainTitle.Font.Size
    end
    if not OrigWrapTextAt then
        OrigWrapTextAt = self.Text_MainTitle.WrapTextAt
    end
    self.OrigFontSize = OrigFontSize
    self.OrigWrapTextAt = OrigWrapTextAt
end

function M:TryWarpTextInJap()
    local bAutoSize = CommonConst.SystemLanguage == CommonConst.SystemLanguages.JP
    if bAutoSize then
        self.Text_MainTitle:SetWrapTextAt(0)
        self.Text_MainTitle:ForceLayoutPrepass()
        self.Text_MainTitle.Font.bOpenFontAutoSize = true
        self.Text_MainTitle.Font.FontSizeMax = self.OrigFontSize
        
    else
        self.Text_MainTitle:SetWrapTextAt(self.OrigWrapTextAt)
        self.Text_MainTitle:ForceLayoutPrepass()
        self.Text_MainTitle.Font.bOpenFontAutoSize = false
        self.Text_MainTitle.Font.Size = self.OrigFontSize
    end
    self.Text_MainTitle:SetFont(self.Text_MainTitle.Font)
    self.Text_MainTitle:SetAutoFontSize()
    self:InvalidateLayoutAndVolatility()
end

function M:SetText(Text)
    self:TryWarpTextInJap()
    local bAutoSize = CommonConst.SystemLanguage == CommonConst.SystemLanguages.JP
    self.Text_MainTitle:SetText(Text,bAutoSize)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M
