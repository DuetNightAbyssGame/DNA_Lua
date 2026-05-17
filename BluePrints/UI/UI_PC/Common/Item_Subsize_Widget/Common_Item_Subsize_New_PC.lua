--[[
--
-- DESCRIPTION
-- 
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

--@type Common_Item_Subsize_New_PC_C
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()
    self.Text_New:SetText(GText("UI_NEW"))
end

function M:SetEnable(IsOn)
    local Visiblity = IsOn and ESlateVisibility.HitTestInvisible or ESlateVisibility.Collapsed
    self:SetVisibility(Visiblity)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

return M
]]



-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type Common_Item_Subsize_New_PC_C
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()
        self:UpdateLanguageBasedUI()
end

function M:SetEnable(IsOn)
    local Visibility = IsOn and ESlateVisibility.HitTestInvisible or ESlateVisibility.Collapsed
    self:SetVisibility(Visibility)
end

function M:UpdateLanguageBasedUI()
    local Language = self:GetCurrentLanguage()
    -- local IconPath
    -- if Language ==  CommonConst.SystemLanguages.CN then
    --     IconPath = "/Game/UI/Texture/Static/Atlas/Common/T_Com_New_CN"  -- 替换中文图像资源路径
    -- else
    --     IconPath = "/Game/UI/Texture/Static/Atlas/Common/T_Com_New_EN"  -- 替换英文图像资源路径
    -- end

    local text
    if Language == CommonConst.SystemLanguages.CN or Language == CommonConst.SystemLanguages.TC then
        text = DataMgr.TextMap_ContentEN["UI_NEW"].ContentEN
    else
        text = GText("UI_NEW")
    end

    self.Text_New:SetText(text)
    -- local Icon = LoadObject(IconPath)
    -- if IsValid(Icon) then
    --     self.Bg:SetBrushResourceObject(Icon)
    -- end
end

function M:GetCurrentLanguage()
    return CommonConst.SystemLanguage
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

return M


