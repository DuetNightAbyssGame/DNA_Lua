--WBP_Battle_Bar_Blood_Place_PC_C
--
-- DESCRIPTION
-- Boss部位血条
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local BloodBarUtils = require "BluePrints.UI.BloodBar.BloodBarUtils"
local WBP_Battle_Bar_Blood_Place_PC_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_Battle_Bar_Blood_Place_PC_C:Initialize(Initializer)
    self.Super.Initialize(self)
    self.Owner = nil
    self.PlaceTickTime = 0.033            -- 扣血的Tick时间
    self.PlaceAnimTime = 0.5              -- 扣血实际时间
    self.PlaceHideTime = 3.0              -- 血条隐藏时间
end

function WBP_Battle_Bar_Blood_Place_PC_C:Construct()
    self.Super.Construct(self)
    self.RootWidget:SetRenderOpacity(0.0)
    self.RootWidget:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if self.Owner then
        self.Hp = self.Owner:GetAttr("Hp")
        self.LastHp = self.Owner:GetAttr("Hp")
        self.MaxHp = self.Owner:GetAttr("MaxHp")
        if self.HpBar and self.HpBar.SetBarPercent then
            self.HpBar:SetBarPercent(self.Hp/self.MaxHp)
        end
    end
end

function WBP_Battle_Bar_Blood_Place_PC_C:InitBossPlaceBlood(OwnerActor)
    self.Owner = OwnerActor
    self.Hp = OwnerActor:GetAttr("Hp")
    self.LastHp = OwnerActor:GetAttr("Hp")
    self.MaxHp = OwnerActor:GetAttr("MaxHp")
    self.SizeBox_BossHP:ClearChildren()
    local Slot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.SizeBox_BossHP)
    self.HpBarLenght = Slot:GetSize().X
    self.HpBar = BloodBarUtils.LoadSubWidget(self,self.SizeBox_BossHP,"HPBar",true,self.HpBarLenght)
    self.RootWidget:SetVisibility(UE4.ESlateVisibility.Collapsed)
    local OwnerMonster = self.Owner:GetOwner()
    if OwnerMonster then
        self.bCanShowSelf = not OwnerActor.HideBloodUI
        -- local Data = DataMgr.DistructableBody[OwnerMonster:GetDistructableBodyId()]
        -- if Data then
        --     local BloodInfo = Data.BloodInfo or {}
        --     for _,v in pairs(BloodInfo) do
        --         if v.socket == OwnerActor.AttachmentName then
        --             self.bCanShowSelf = v.HideBloodUI == false or v.HideBloodUI == nil
        --         end
        --     end
        -- end
    end

end

function WBP_Battle_Bar_Blood_Place_PC_C:UpdateBossPlaceBlood()
    self.RootWidget:SetRenderOpacity(1.0)
    if self.bCanShowSelf ~= false then
        self.RootWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    self.NowTime = UE4.UGameplayStatics.GetTimeSeconds(self)

    self.LastHp = self.Hp
    self.Hp = self.Owner:GetAttr("Hp")
    local IsRealReduceBlood = self.Hp < self.LastHp
    
    --更新Boss部位血条
    local CurPercent = math.clamp(self.Hp/self.MaxHp, 0, 1)
    self.HpBar:SetBarPercent(CurPercent)

    if IsRealReduceBlood then
        self.HpBar:PlayDeduct(true)
        local CheckBossPlace = function()
            if self.Hp == self.Owner:GetCurrentBloodVolume() then
            self.RootWidget:SetRenderOpacity(0.0)
            self.RootWidget:SetVisibility(UE4.ESlateVisibility.Collapsed)
            end
        end
        self:AddTimer(self.PlaceTickTime, CheckBossPlace, false, self.PlaceHideTime, "CheckBossPlaceIsHit")
    
    -- if self.Hp < self.LastHp then
    --     IsRealReduceBlood = true
    --     if (self:IsExistTimer("CheckBossPlaceIsHit")) then
    --         self:RemoveTimer("CheckBossPlaceIsHit")
    --     end
    --     self.LastHp = self.Hp
    --     local CheckBossPlace = function()
    --         if self.Hp == self.Owner:GetCurrentBloodVolume() then
    --             self.RootWidget:SetRenderOpacity(0.0)
    --             self.RootWidget:SetVisibility(UE4.ESlateVisibility.Collapsed)
    --         end
    --     end
    --     self:AddTimer(self.PlaceTickTime, CheckBossPlace, false, self.PlaceHideTime, "CheckBossPlaceIsHit")
    else
        if (self:IsExistTimer("CheckBossPlaceIsHit")) then
            self:RemoveTimer("CheckBossPlaceIsHit")
        end
        self.RootWidget:SetRenderOpacity(0.0)
        self.RootWidget:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

function WBP_Battle_Bar_Blood_Place_PC_C:CheckIsShowByType()
    return self.RootWidget:GetRenderOpacity() >= 1.0 and self.Boss_Place_Blood:IsVisible()
end

-- function WBP_Battle_Bar_Blood_Place_PC_C:ShowOrHideSelf(bIsShow)
--     self.bCanShowSelf = bIsShow
--     if ( not bIsShow) then
--         self.RootWidget:SetVisibility(UE4.ESlateVisibility.Collapsed)
--     end
-- end


return WBP_Battle_Bar_Blood_Place_PC_C