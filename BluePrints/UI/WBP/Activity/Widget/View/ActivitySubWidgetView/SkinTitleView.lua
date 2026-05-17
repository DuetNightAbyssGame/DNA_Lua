--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_TryOutSkin_Title_P_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:Init(SkinId)
    self.SkinId = SkinId
    local SkinInfo = DataMgr.Skin[SkinId]
    
    local Rarity = SkinInfo.Rarity
    if not Rarity or Rarity < 1 or Rarity > 6 then
        DebugPrint("No Rarity")
        return
    end
    self.Com_QualityTag:Init(Rarity)
    local Font = nil
    local ImageLight = nil
    if Rarity == 6 then
        Font = self.Font_Red
        ImageLight = self.Light_Red
    elseif Rarity == 5 then
        Font = self.Font_Gold
        ImageLight = self.Light_Gold
    elseif Rarity == 4 then
        Font = self.Font_Purple
        ImageLight = self.Light_Purple
    elseif Rarity == 3 then
        Font = self.Font_Blue
        ImageLight = self.Light_Blue
    end
    self.Text_CharName:SetFont(Font)
    self.Text_CharName:SetText(GText(SkinInfo.SkinName))
    self.Img_TryOutBG:SetColorAndOpacity(ImageLight)
    self.Btn_Detail.OnClicked:Clear()
    self.Btn_Detail.OnClicked:Add(self, self.BtnClicked)
end

function M:BtnClicked()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)

    UIManager(self):LoadUINew("SkinPreview", {
        ItemType = "Skin",
        TypeId = self.SkinId,
        SinglePreview = true,
        HidePurchase = true,
    })
end


return M
