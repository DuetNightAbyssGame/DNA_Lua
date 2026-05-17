--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local RougeConst = require "BluePrints.UI.UI_PC.RougeLike.RougeAchive.RougeConst"

---@type WBP_RougeBlessingItemPart_C
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()
    self.Rarity2Color = {
        "Blue",
        "Purple",
        "Yellow",
    }
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:OnLoaded(AwardInfo)
    local Avatar = GWorld:GetAvatar()
    assert(Avatar, "当前肉鸽内拿不到Avatar")
    
    self.AwardType = AwardInfo.AwardType
    self.AwardId = AwardInfo.AwardId
    local AwardData
    local IsUnlocked
    if self.AwardType == "Blessing" then
        AwardData = DataMgr.RougeLikeBlessing
        IsUnlocked = Avatar.RougeLike:IsManualUnlocked(RougeConst.ArchiveType.Blessing, self.AwardId)
    elseif self.AwardType == "Treasure" then
        AwardData = DataMgr.RougeLikeTreasure
        IsUnlocked = Avatar.RougeLike:IsManualUnlocked(RougeConst.ArchiveType.Treasure, self.AwardId)
    end
    if not IsUnlocked then
        self.Group_ArchiveSign:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Text_ArchiveSign:SetText(GText("RLArchive_ArchiveUnlock"))
    end
    self.Text_Title:SetText(GText(AwardData[self.AwardId].Name))
    self.Rarity = AwardData[self.AwardId][self.AwardType.."Rarity"]
    assert(self.Rarity, "Rarity的获取有问题")
    
    if self.Rarity > 2 then
        self.WidgetSwitcher_Glow:SetActiveWidgetIndex(0)
    elseif self.Rarity > 1 then
        self.WidgetSwitcher_Glow:SetActiveWidgetIndex(1)    
    else
        self.WidgetSwitcher_Glow:SetActiveWidgetIndex(2)
    end
    
    self.Image_ItemBG:SetBrushResourceObject(self["BGQuality_"..self.Rarity2Color[self.Rarity]])
    self.Image_TitleQuality:SetBrushResourceObject(self["TitleQuality_"..self.Rarity2Color[self.Rarity]])
    
    -- local ItemImgIcon = LoadObject(AwardData[self.AwardId].Icon)
    UE.UResourceLibrary.LoadObjectAsync(self,AwardData[self.AwardId].Icon,{self,M.OnAwardTypeIconLoadFinish})
    if self.AwardType == "Blessing" then
        self.Image_Icon:PlayAnimation(self.Image_Icon[self.Rarity2Color[self.Rarity]])
    end
    
end

function M:OnAwardTypeIconLoadFinish(Object)
    if Object and IsValid(self) then
        if self.AwardType == "Treasure" then
            self.Image_Icon:SetBrushResourceObject(Object)
        else
            local Material = self.Image_Icon.Image_Icon:GetDynamicMaterial()
            if(Material) then
                Material:SetTextureParameterValue("MainTex", Object)
            end
        end
    end
end



return M
