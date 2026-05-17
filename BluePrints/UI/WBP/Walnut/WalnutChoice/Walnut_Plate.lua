--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Walnut_Plate_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:Construct()
    self.Text_None:SetText(GText("UI_Walnut_Not_Select"))
    self.Text_Hint:SetText(GText("UI_Reward_Walnut_Preview"))
    -- self.Text_Hint:SetText(GText("不会获得密函奖励"))
    self.RewardUIList = {self.Reward_1st, self.Reward_2nd, self.Reward_2nd_2, self.Reward_3rd_1, self.Reward_3rd_2, self.Reward_3rd_3}
    self:BindEvents()
    self.WalnutRewardList = {}
    -- self.ItemDetail_MenuAnchor.ParentWidget = self
end

function M:SetNoWalnut(bPlayAnimation)
    DebugPrint("SetNoWalnut")
    self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
    self.Text_Hint:SetText(GText("UI_Walnut_NoReward"))
    self.Panel_Reward:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_Ordinal:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Icon_Walnut:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_Bg:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_Hint:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Text_Name:SetText(GText("UI_Walnut_NoWalnutReward"))
    if bPlayAnimation then
        self:PlayAnimation(self.Refresh)
    end
    self.WalnutId = -1
end

function M:SetWalnutContent(WalnutId, bPlayAnimation)
    if not WalnutId or WalnutId < 0 then
        self:SetNoWalnut(bPlayAnimation)
        return
    end
    DebugPrint("SetWalnutContent", WalnutId)
    self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
    self.Text_Hint:SetText(GText("UI_Reward_Walnut_Preview"))
    self.Panel_Reward:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Panel_Ordinal:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Icon_Walnut:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Panel_Bg:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Panel_Hint:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    if bPlayAnimation then
        self:PlayAnimation(self.Refresh)
    end

    -- 更新核桃信息
    self.WalnutId = WalnutId
    local WalnutData = DataMgr["Walnut"][WalnutId]
    local WalnutType = WalnutData.WalnutType
    local WalnutTypeData = DataMgr["WalnutType"][WalnutType]
    local WalnutIcon = WalnutData.Icon
    local WalnutImg = LoadObject(WalnutIcon)
    local WalnutNumber = WalnutData.WalnutNumber
    self.Icon_Walnut:SetBrushResourceObject(WalnutImg)
    -- if WalnutNumber then
    --     self.Walnut_Number:InitWalnutNumber(WalnutId)
    --     self.Walnut_Number:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- else
    --     self.Walnut_Number:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- end
    self.Walnut_Number:SetVisibility(UE4.ESlateVisibility.Collapsed)
    
    local Avatar = GWorld:GetAvatar()
    self.Text_Total:SetText(GText("UI_Walnut_CompleteCount"))
    self.Num_Total:SetText(Avatar.Walnuts.ConsumeRecord[WalnutId] or 0)
    self.Text_Name:SetText(GText(WalnutData.Name))


    -- 更新核桃奖励信息
    self.WalnutRewardList = {}
    for i = 1, 6 do
        local RewardUI = self.RewardUIList[i]
        local CurrentType = WalnutData["Type"][i]
        local CurrentId = WalnutData["Id"][i]
        local ItemData = DataMgr[CurrentType][CurrentId]
        local RewardCount = WalnutData["Count"][i][1]
        if ItemData then
            local Img = LoadObject(ItemData.Icon)
            local Rarity = ItemData.Rarity or ItemData[CurrentType.."Rarity"] or 0
            RewardUI.Icon_Reward:SetBrushResourceObject(Img)
            RewardUI.Num_Item:SetText(RewardCount)
            if Rarity == 1 then
                RewardUI.Bg:SetColorAndOpacity(RewardUI.Grey)
            elseif Rarity == 2 then
                RewardUI.Bg:SetColorAndOpacity(RewardUI.Green)
            elseif Rarity == 3 then
                RewardUI.Bg:SetColorAndOpacity(RewardUI.Blue)
            elseif Rarity == 4 then
                RewardUI.Bg:SetColorAndOpacity(RewardUI.Purple)
            elseif Rarity == 5 then
                RewardUI.Bg:SetColorAndOpacity(RewardUI.Yellow)
            end
            table.insert(self.WalnutRewardList, {ItemType = CurrentType, ItemId = CurrentId})
        else
            DebugPrint("ERROR::", "Draft的Id:"..CurrentId.."不存在, 请检查核桃奖励配置")
        end
    end

    -- 更新奖励百分比信息
    local PerCentGold, PerCentSilver, PerCentBronze = ItemUtils.GetWalnutItemPercent(WalnutId)
    self.Ordinal_1st:SetPercent(PerCentGold)
    self.Ordinal_2nd:SetPercent(PerCentSilver)
    self.Ordinal_3rd:SetPercent(PerCentBronze)
    self.Ordinal_1st.ProgressBar:GetDynamicMaterial():SetScalarParameterValue("Percent", 1 - PerCentGold)
    self.Ordinal_2nd.ProgressBar:GetDynamicMaterial():SetScalarParameterValue("Percent", 1 - PerCentSilver)
    self.Ordinal_3rd.ProgressBar:GetDynamicMaterial():SetScalarParameterValue("Percent", 1 - PerCentBronze)
end

function M:BindEvents()
    self.Reward_1st.Button_Area.OnClicked:Add(self, self.OnClickReward1st)
    self.Reward_2nd.Button_Area.OnClicked:Add(self, self.OnClickReward2nd)
    self.Reward_2nd_2.Button_Area.OnClicked:Add(self, self.OnClickReward2nd2)
    self.Reward_3rd_1.Button_Area.OnClicked:Add(self, self.OnClickReward3rd1)
    self.Reward_3rd_2.Button_Area.OnClicked:Add(self, self.OnClickReward3rd2)
    self.Reward_3rd_3.Button_Area.OnClicked:Add(self, self.OnClickReward3rd3)

    self.Reward_1st.Button_Area.OnPressed:Add(self, self.OnPressReward1st)
    self.Reward_2nd.Button_Area.OnPressed:Add(self, self.OnPressReward2nd)
    self.Reward_2nd_2.Button_Area.OnPressed:Add(self, self.OnPressReward2nd2)
    self.Reward_3rd_1.Button_Area.OnPressed:Add(self, self.OnPressReward3rd1)
    self.Reward_3rd_2.Button_Area.OnPressed:Add(self, self.OnPressReward3rd2)
    self.Reward_3rd_3.Button_Area.OnPressed:Add(self, self.OnPressReward3rd3)

    self.Reward_1st.Button_Area.OnHovered:Add(self, self.OnHoverReward1st)
    self.Reward_2nd.Button_Area.OnHovered:Add(self, self.OnHoverReward2nd)
    self.Reward_2nd_2.Button_Area.OnHovered:Add(self, self.OnHoverReward2nd2)
    self.Reward_3rd_1.Button_Area.OnHovered:Add(self, self.OnHoverReward3rd1)
    self.Reward_3rd_2.Button_Area.OnHovered:Add(self, self.OnHoverReward3rd2)
    self.Reward_3rd_3.Button_Area.OnHovered:Add(self, self.OnHoverReward3rd3)

    self.Reward_1st.Button_Area.OnUnhovered:Add(self, self.OnUnhoverReward1st)
    self.Reward_2nd.Button_Area.OnUnhovered:Add(self, self.OnUnhoverReward2nd)
    self.Reward_2nd_2.Button_Area.OnUnhovered:Add(self, self.OnUnhoverReward2nd2)
    self.Reward_3rd_1.Button_Area.OnUnhovered:Add(self, self.OnUnhoverReward3rd1)
    self.Reward_3rd_2.Button_Area.OnUnhovered:Add(self, self.OnUnhoverReward3rd2)
    self.Reward_3rd_3.Button_Area.OnUnhovered:Add(self, self.OnUnhoverReward3rd3)
end

--------------- Click -----------------
function M:OnClickReward1st()
    self.Reward_1st:PlayAnimation(self.Reward_1st.Click)
    if (not self.Reward_1st.ItemDetail_MenuAnchor.ItemDetailsMenuAnchor:IsOpen()) then
        local ItemType = self.WalnutRewardList[1].ItemType
        local ItemId = self.WalnutRewardList[1].ItemId
        self.Reward_1st:OpenDetailWidget(ItemType, ItemId)
    end
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then 
        if self.MainUI then
            self.MainUI.State = 3
            self.MainUI:UpdateCommonKeys()
            if self.MainUI.Btn_No and self.MainUI.Btn_Yes then
                self.MainUI.Btn_No:SetGamePadVisibility(UE4.ESlateVisibility.Collapsed)
                self.MainUI.Btn_Yes:SetGamePadVisibility(UE4.ESlateVisibility.Collapsed)
            end
        end
    end
    AudioManager(self):PlayItemSound(self,self.WalnutRewardList[1].ItemId,"Click",self.WalnutRewardList[1].ItemType)
end

function M:OnClickReward2nd()
    self.Reward_2nd:PlayAnimation(self.Reward_2nd.Click)
    if (not self.Reward_2nd.ItemDetail_MenuAnchor.ItemDetailsMenuAnchor:IsOpen()) then
        local ItemType = self.WalnutRewardList[2].ItemType
        local ItemId = self.WalnutRewardList[2].ItemId
        self.Reward_2nd:OpenDetailWidget(ItemType, ItemId)
    end
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then 
        if self.MainUI then
            self.MainUI.State = 3
            self.MainUI:UpdateCommonKeys()
            if self.MainUI.Btn_No and self.MainUI.Btn_Yes then
                self.MainUI.Btn_No:SetGamePadVisibility(UE4.ESlateVisibility.Collapsed)
                self.MainUI.Btn_Yes:SetGamePadVisibility(UE4.ESlateVisibility.Collapsed)
            end
        end
    end
    AudioManager(self):PlayItemSound(self,self.WalnutRewardList[2].ItemId,"Click",self.WalnutRewardList[2].ItemType)
end

function M:OnClickReward2nd2()
    self.Reward_2nd_2:PlayAnimation(self.Reward_2nd_2.Click)
    if (not self.Reward_2nd_2.ItemDetail_MenuAnchor.ItemDetailsMenuAnchor:IsOpen()) then
        local ItemType = self.WalnutRewardList[3].ItemType
        local ItemId = self.WalnutRewardList[3].ItemId
        self.Reward_2nd_2:OpenDetailWidget(ItemType, ItemId)
    end
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then 
        if self.MainUI then
            self.MainUI.State = 3
            self.MainUI:UpdateCommonKeys()
            if self.MainUI.Btn_No and self.MainUI.Btn_Yes then
                self.MainUI.Btn_No:SetGamePadVisibility(UE4.ESlateVisibility.Collapsed)
                self.MainUI.Btn_Yes:SetGamePadVisibility(UE4.ESlateVisibility.Collapsed)
            end
        end
    end
    AudioManager(self):PlayItemSound(self,self.WalnutRewardList[3].ItemId,"Click",self.WalnutRewardList[3].ItemType)
end

function M:OnClickReward3rd1()
    self.Reward_3rd_1:PlayAnimation(self.Reward_3rd_1.Click)
    if (not self.Reward_3rd_1.ItemDetail_MenuAnchor.ItemDetailsMenuAnchor:IsOpen()) then
        local ItemType = self.WalnutRewardList[4].ItemType
        local ItemId = self.WalnutRewardList[4].ItemId
        local Placement = EMenuPlacement.MenuPlacement_AboveAnchor
        self.Reward_3rd_1:OpenDetailWidget(ItemType, ItemId, Placement)
    end
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then 
        if self.MainUI then
            self.MainUI.State = 3
            self.MainUI:UpdateCommonKeys()
            if self.MainUI.Btn_No and self.MainUI.Btn_Yes then
                self.MainUI.Btn_No:SetGamePadVisibility(UE4.ESlateVisibility.Collapsed)
                self.MainUI.Btn_Yes:SetGamePadVisibility(UE4.ESlateVisibility.Collapsed)
            end
        end
    end
    AudioManager(self):PlayItemSound(self,self.WalnutRewardList[4].ItemId,"Click",self.WalnutRewardList[4].ItemType)
end

function M:OnClickReward3rd2()
    self.Reward_3rd_2:PlayAnimation(self.Reward_3rd_2.Click)
    if (not self.Reward_3rd_2.ItemDetail_MenuAnchor.ItemDetailsMenuAnchor:IsOpen()) then
        local ItemType = self.WalnutRewardList[5].ItemType
        local ItemId = self.WalnutRewardList[5].ItemId
        self.Reward_3rd_2:OpenDetailWidget(ItemType, ItemId)
    end
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then 
        if self.MainUI then
            self.MainUI.State = 3
            self.MainUI:UpdateCommonKeys()
            if self.MainUI.Btn_No and self.MainUI.Btn_Yes then
                self.MainUI.Btn_No:SetGamePadVisibility(UE4.ESlateVisibility.Collapsed)
                self.MainUI.Btn_Yes:SetGamePadVisibility(UE4.ESlateVisibility.Collapsed)
            end
        end
    end
    AudioManager(self):PlayItemSound(self,self.WalnutRewardList[5].ItemId,"Click",self.WalnutRewardList[5].ItemType)
end

function M:OnClickReward3rd3()
    self.Reward_3rd_3:PlayAnimation(self.Reward_3rd_3.Click)
    if (not self.Reward_3rd_3.ItemDetail_MenuAnchor.ItemDetailsMenuAnchor:IsOpen()) then
        local ItemType = self.WalnutRewardList[6].ItemType
        local ItemId = self.WalnutRewardList[6].ItemId
        self.Reward_3rd_3:OpenDetailWidget(ItemType, ItemId)
    end
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then 
        if self.MainUI then
            self.MainUI.State = 3
            self.MainUI:UpdateCommonKeys()
            if self.MainUI.Btn_No and self.MainUI.Btn_Yes then
                self.MainUI.Btn_No:SetGamePadVisibility(UE4.ESlateVisibility.Collapsed)
                self.MainUI.Btn_Yes:SetGamePadVisibility(UE4.ESlateVisibility.Collapsed)
            end
        end
    end
    AudioManager(self):PlayItemSound(self,self.WalnutRewardList[6].ItemId,"Click",self.WalnutRewardList[6].ItemType)
end

--------------- Press -----------------
function M:OnPressReward1st()
    self.Reward_1st:PlayAnimation(self.Reward_1st.Presss)
end

function M:OnPressReward2nd()
    self.Reward_2nd:PlayAnimation(self.Reward_2nd.Presss)
end

function M:OnPressReward2nd2()
    self.Reward_2nd_2:PlayAnimation(self.Reward_2nd_2.Presss)
end

function M:OnPressReward3rd1()
    self.Reward_3rd_1:PlayAnimation(self.Reward_3rd_1.Presss)
end

function M:OnPressReward3rd2()
    self.Reward_3rd_2:PlayAnimation(self.Reward_3rd_2.Presss)
end

function M:OnPressReward3rd3()
    self.Reward_3rd_3:PlayAnimation(self.Reward_3rd_3.Presss)
end

--------------- Hover -----------------
function M:OnHoverReward1st()
    if self.Reward_1st:IsMenuOpen() then
        return
    end
    self.Reward_1st:PlayAnimation(self.Reward_1st.Hover)
    self.Reward_1st.Bg_Glow_1:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:OnHoverReward2nd()
    if self.Reward_2nd:IsMenuOpen() then
        return
    end
    self.Reward_2nd:PlayAnimation(self.Reward_2nd.Hover)
    self.Reward_2nd.Bg_Glow_1:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:OnHoverReward2nd2()
    if self.Reward_2nd_2:IsMenuOpen() then
        return
    end
    self.Reward_2nd_2:PlayAnimation(self.Reward_2nd_2.Hover)
    self.Reward_2nd_2.Bg_Glow_1:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:OnHoverReward3rd1()
    if self.Reward_3rd_1:IsMenuOpen() then
        return
    end
    self.Reward_3rd_1:PlayAnimation(self.Reward_3rd_1.Hover)
    self.Reward_3rd_1.Bg_Glow_1:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:OnHoverReward3rd2()
    if self.Reward_3rd_2:IsMenuOpen() then
        return
    end
    self.Reward_3rd_2:PlayAnimation(self.Reward_3rd_2.Hover)
    self.Reward_3rd_2.Bg_Glow_1:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:OnHoverReward3rd3()
    if self.Reward_3rd_3:IsMenuOpen() then
        return
    end
    self.Reward_3rd_3:PlayAnimation(self.Reward_3rd_3.Hover)
    self.Reward_3rd_3.Bg_Glow_1:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

--------------- Unhover -----------------
function M:OnUnhoverReward1st()
    if self.Reward_1st:IsMenuOpen() then
        return
    end
    self.Reward_1st:PlayAnimation(self.Reward_1st.Unhover)
    self.Reward_1st.Bg_Glow_1:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:OnUnhoverReward2nd()
    if self.Reward_2nd:IsMenuOpen() then
        return
    end
    self.Reward_2nd:PlayAnimation(self.Reward_2nd.Unhover)
    self.Reward_2nd.Bg_Glow_1:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:OnUnhoverReward2nd2()
    if self.Reward_2nd_2:IsMenuOpen() then
        return
    end
    self.Reward_2nd_2:PlayAnimation(self.Reward_2nd_2.Unhover)
    self.Reward_2nd_2.Bg_Glow_1:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:OnUnhoverReward3rd1()
    if self.Reward_3rd_1:IsMenuOpen() then
        return
    end
    self.Reward_3rd_1:PlayAnimation(self.Reward_3rd_1.Unhover)
    self.Reward_3rd_1.Bg_Glow_1:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:OnUnhoverReward3rd2()
    if self.Reward_3rd_2:IsMenuOpen() then
        return
    end
    self.Reward_3rd_2:PlayAnimation(self.Reward_3rd_2.Unhover)
    self.Reward_3rd_2.Bg_Glow_1:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:OnUnhoverReward3rd3()
    if self.Reward_3rd_3:IsMenuOpen() then
        return
    end
    self.Reward_3rd_3:PlayAnimation(self.Reward_3rd_3.Unhover)
    self.Reward_3rd_3.Bg_Glow_1:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

return M
