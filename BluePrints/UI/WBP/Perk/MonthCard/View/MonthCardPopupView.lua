--
-- DESCRIPTION
-- 月卡界面弹窗拍脸View
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local MonthCardCommon = require "BluePrints.UI.WBP.Perk.MonthCard.MonthCardCommon"
--- @type MonthCardController
local MonthCardController = require "BluePrints.UI.WBP.Perk.MonthCard.MonthCardController"
local MonthCardModel = MonthCardController:GetModel()
local ItemUtil = require "Utils.ItemUtils"
--- @type WBP_MonthCard_PopUp_C
local M = {}

function M:PlayInAnim()
    AudioManager(self):PlayUISound(self, "event:/ui/common/shop_gift_pack_buying_show", MonthCardCommon.PopUpName, nil)
    self:StopAllAnimations()
    self:PlayAnimation(self.In)
    local Duration = self.In:GetEndTime() - self.In:GetStartTime()
    self:AddTimer(Duration, function()
        self.bAfterLoaded = true
        self:PlayAnimation(self.loop)
    end)
end

function M:TryPlayReceiveAnim()
    self:StopAllAnimations()
    self:PlayAnimation(self.Receive)
    AudioManager(self):PlayUISound(self, "event:/ui/common/get_award_items_gift_pack", nil, nil)
    self.bAfterReceive = true
    self.Text_Tip:SetText(GText(self:GetTipsTextMap()))
end

function M:PlayOutAnim()
    AudioManager(self):SetEventSoundParam(self, MonthCardCommon.PopUpName, {ToEnd=1})
    self:BindToAnimationFinished(self.out, {self, self.Close})

    self:StopAllAnimations()
    self:PlayAnimation(self.out)
end

function M:CheckIsCanCloseSelf()
    if (self:IsAnimationPlaying(self.In)) or (self:IsAnimationPlaying(self.out)) then
        return false
    end
    return true
end

--- @param MonthCardReward MonthCardReward
function M:SetDailyReward(MonthCardReward)
    if not MonthCardReward then return end

    local Reward1 = MonthCardReward[1]
    local Reward2 = MonthCardReward[2]
    if Reward1 then
        local ItemID = Reward1.ItemId
        local Icon = ItemUtil.GetItemIcon(ItemID, Reward1.ItemType)
        local Class = UIUtils.GetCommonItemContentClass()
        local Content = NewObject(Class)
        -- Content.Type = MonthCardReward.ItemType
        Content.Icon = Icon
        -- Content.Rarity = ItemUtil.GetItemRarity(ItemID, MonthCardReward.ItemType)
        -- Content.Count = MonthCardReward.Count
        -- Content.UnitId = MonthCardReward.ItemId
        self.Common_Item_Icon:Init(Content)
        self.Text_MonthCardReward:SetText("X" .. Reward1.Count)
        self.Common_Item_Icon:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Text_MonthCardReward:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Common_Item_Icon:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Text_MonthCardReward:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    if Reward2 then
        local ItemID = Reward2.ItemId
        local Icon = ItemUtil.GetItemIcon(ItemID, Reward2.ItemType)
        local Class = UIUtils.GetCommonItemContentClass()
        local Content = NewObject(Class)
        -- Content.Type = MonthCardReward.ItemType
        Content.Icon = Icon
        -- Content.Rarity = ItemUtil.GetItemRarity(ItemID, MonthCardReward.ItemType)
        -- Content.Count = MonthCardReward.Count
        -- Content.UnitId = MonthCardReward.ItemId
        self.Common_Item_Icon_Book:Init(Content)
        self.Text_MonthCardReward_Book:SetText("X" .. Reward2.Count)
        self.Common_Item_Icon_Book:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Text_MonthCardReward_Book:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Common_Item_Icon_Book:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Text_MonthCardReward_Book:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

end

function M:GetTipsTextMap()
    if self.bAfterReceive then
        return MonthCardCommon.TextMonthCardPopCloseTip
    end
    return MonthCardCommon.TextMonthCardPopCloseTip
end

function M:InitBaseView()
    local LeftTimes = MonthCardModel:GetMonthCardLeftTimes()
    self.Text_MonthCardTime:SetText(string.format(GText(MonthCardCommon.TextMonthCardPopTime), LeftTimes))
    self.Text_MonthCardTimeTitle:SetText(GText(MonthCardCommon.TextMonthCardPopTimeTitle))
    self.Text_MonthCardTitle:SetText(GText(MonthCardCommon.TextMonthCardPopTitle))
    self.Text_Tip:SetText(GText(self:GetTipsTextMap()))
    self.Key_Tips:CreateCommonKey({
            KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "A"
            }
        },
        --Desc = GText(MonthCardCommon.TextMonthCardPopCloseTipGamepad),
    })
    if (self.GameInputModeSubsystem) then
        self:SwitchInputType(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function M:SwitchInputType(CurInputDevice, CurGamepadName)
    if(CurInputDevice == ECommonInputType.Gamepad) then
        self.Text_Tip:SetText(GText(MonthCardCommon.TextMonthCardPopCloseTipGamepad))
        self.Key_Tips:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Text_Tip:SetText(GText(self:GetTipsTextMap()))
        self.Key_Tips:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

return M
