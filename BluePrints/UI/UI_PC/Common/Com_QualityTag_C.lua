--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_QualityTag_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:Init(Rarity)
    self:SetRarity(Rarity)
end

function M:SetRarity(Rarity)
    if not Rarity or Rarity < 1 or Rarity > 6 then
        DebugPrint("No Rarity")
        return
    end
    -- local BgTexture = nil
    -- local ImageLight = nil
    local FontColor = nil
    local Font = nil
    local Text = nil
    local InAnimation = nil
    if Rarity == 6 then
        -- BgTexture = self.Bg_Red
        -- ImageLight = self.Light_Red
        FontColor = self.FontColor_Red
        Font = self.Font_Red
        Text = GText("UI_SkinGacha_Skin_Red")
        InAnimation = self.Red_In
    elseif Rarity == 5 then
        -- BgTexture = self.Bg_Gold
        -- ImageLight = self.Light_Gold
        FontColor = self.FontColor_Gold
        Font = self.Font_Gold
        Text = GText("UI_SkinGacha_Skin_Gold")
        InAnimation = self.Gold_In
    elseif Rarity == 4 then
        -- BgTexture = self.Bg_Purple
        -- ImageLight = self.Light_Purple
        FontColor = self.FontColor_Purple
        Font = self.Font_Purple
        Text = GText("UI_SkinGacha_Skin_Purple")
        InAnimation = self.Purple_In
    elseif Rarity == 3 then
        -- BgTexture = self.Bg_Blue
        -- ImageLight = self.Light_Blue
        FontColor = self.FontColor_Blue
        Font = self.Font_Blue
        Text = GText("UI_SkinGacha_Skin_Blue")
        InAnimation = self.Blue_In
    end
    -- local BgDynamicMaterial = self.Bg_ShowTag:GetDynamicMaterial()
    -- BgDynamicMaterial:SetTextureParameterValue("MainTex", BgTexture)
    -- self.Image_Lighet:SetColorAndOpacity(ImageLight)
    self.Text_Tag:SetFont(Font)
    self.Text_Tag:SetColorAndOpacity(FontColor)
    self.Text_Tag:SetText(Text)
    self:PlayAnimation(InAnimation)
end

--自定义品质文本
function M:SetCustomizedTextTag(Text)
    self.Text_Tag:SetText(Text)
end

return M
