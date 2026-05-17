--
-- DESCRIPTION
-- 活动系统七日签到View （PC、移动端公用）
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"

local M = {}

function M:PlayFadeIn()
    -- 播放入场动画
    self:PlayAnimation(self.In)
    -- 播放标题动画
    local TitleWidget = self.Group_Title:GetChildAt(0)
    if (TitleWidget.In ~= nil) then
        TitleWidget:PlayAnimationForward(TitleWidget.In)
    end
end

function M:PlayFadeOut(IsRemoveFromParent)
    -- 播放退场动画
    self:PlayAnimation(self.Out)
    if (IsRemoveFromParent) then
        self:BindToAnimationFinished(self.Out, {self, self.RemoveFromParent})
    end
end

function M:HidePage(IsNeedPlayOutAnim)
    if (IsNeedPlayOutAnim) then
        self:PlayFadeOut()
    end
    self:SetVisibility(UIConst.VisibilityOp["Collapsed"])
end

function M:ShowPage(IsNeedPlayInAnim)
    if (IsNeedPlayInAnim) then
        self:PlayFadeIn()
    end
    self:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
end

function M:IsPageInVisible()
    return self:IsVisible()
end

function M:RefreshPageStaticView(ActivityConfigData, PageConfigData, InfoClickFunction)
    -- 右上方标题相关
    -- self.ActivityTitle.Image_Title:SetBrushResourceObject(LoadObject(PageConfigData.EventIcon))

    -- 初始化标题
    local TitleBP = "/Game/UI/WBP/Activity/Widget/SevenDay/WBP_Activity_SevenDayTitle.WBP_Activity_SevenDayTitle"
    if (ActivityConfigData.EventNameBPPath ~= nil) then
        TitleBP = ActivityConfigData.EventNameBPPath
    end
    local TitleWidget = UIManager(self):CreateWidget(TitleBP)
    self.Group_Title:ClearChildren()
    self.Group_Title:AddChildToOverlay(TitleWidget)
    self.Group_Title:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])

    self.ActivityTitle = TitleWidget

    -- 初始化奖励Banner
    local RewardBannerBP = "/Game/UI/WBP/Activity/Widget/SevenDay/WBP_Activity_SevenDayItems.WBP_Activity_SevenDayItems'"
    if (PageConfigData.RewardBannerBP ~= nil) then
        RewardBannerBP = PageConfigData.RewardBannerBP
    end
    local SevenDayItems = UIManager(self):CreateWidget(RewardBannerBP)
    self.Group_Items:ClearChildren()
    self.SevenDayItems = SevenDayItems
    self.Group_Items:AddChildToOverlay(SevenDayItems)

    self.ActivityTitle.Text_Title:SetText(GText(ActivityConfigData.EventName))
    self.ActivityTitle.Text_ActivityDesc:SetText(GText(ActivityConfigData.EventDes))
    self.ActivityTitle.Text_ActivityDesc_White:SetText(GText(ActivityConfigData.EventDes))

    -- 角色铭牌相关
    local CharId = PageConfigData.CharInfo
    if (CharId ~= nil) then
        local BattleCharConfigInfo = DataMgr.BattleChar[CharId]
        if (BattleCharConfigInfo ~= nil) then
            if BattleCharConfigInfo.Attribute then
                local IconName = "Armory_" .. BattleCharConfigInfo.Attribute
                if IconName then
                    local AttrIcon = LoadObject("/Game/UI/Texture/Dynamic/Atlas/Armory/T_" .. IconName .. ".T_" .. IconName)
                    self.AvatarName.Image_AvatarType:SetBrushResourceObject(AttrIcon)
                end
            end
            self.AvatarName.Text_AvatarDesc:SetText(GText(PageConfigData.CharDes))
            self.AvatarName.Text_AvatarName:SetText(GText(BattleCharConfigInfo.CharName))
            local CharRarity = DataMgr.Char[CharId].CharRarity or 1
            for i = 1, CharRarity, 1 do
                self:PlayStarGoldenInAnim(i) 
            end
            self.AvatarName:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        else
            self.AvatarName:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        end
    else
        self.AvatarName:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end

    -- 右边奖励相关
    -- local AllDays = PageConfigData.LoginDuration
    -- for i = 1, AllDays, 1 do
    --     if (i == AllDays) then
    --         local SpRewardWidget = self.SevenDayItems.HighItem
    --         SpRewardWidget:InitSpecialReward(i, {ActivityId=PageConfigData.EventId, RewardId=PageConfigData.EventReward[i], CharId=PageConfigData.CharInfo}, self)
    --     else
    --         local NorRewardWidget = self.SevenDayItems["LowItem_"..i]
    --         NorRewardWidget:InitNormalReward(i, {ActivityId=PageConfigData.EventId, RewardId=PageConfigData.EventReward[i]}, self)
    --     end
    -- end
    self.SevenDayItems:InitRewardInfo(PageConfigData, self)

    self:BindAllClickFunction(InfoClickFunction)

    self:AdjustWidgetByPlatform()

    ActivityUtils.SetUpJustifyOfJap(TitleWidget.Text_ActivityDesc, TitleWidget.Text_ActivityDesc_White)
end

function M:AdjustWidgetByPlatform()
    -- 根据平台做差异化显示
    local PlatformName = CommonUtils.GetDeviceTypeByPlatformName(self)
    local SuffixStr = PlatformName == "Mobile" and "M" or "P"
    -- local ActivityTitleSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.ActivityTitle)
    -- ActivityTitleSlot:SetPosition(FVector2D(self["PositionX_Title_"..SuffixStr], self["PositionY_Title_"..SuffixStr]))
end

function M:RefreshPageDynamicView(PageConfigData, PageServerData)
    local AllSignDay = PageConfigData.LoginDuration
    for i = 1, AllSignDay, 1 do
        local RewardWidget = self.SevenDayItems["LowItem_"..i] or self.SevenDayItems.HighItem
        RewardWidget:RefreshRewardByState(PageServerData[i])
        if (PageServerData[i] == ActivityUtils.EnumPlayerSignRewardState.SignedNotRecv) then
            ActivityUtils.TryAddActivityReddotCommon("Red", self.CurActivityId)
        end
    end
end

function M:BindAllClickFunction(InfoClickFunction)
    self.ActivityTitle.Activity_Time.Btn_Detail:BindEventOnClicked(self, InfoClickFunction)
end

function M:UpdateParentActivityKeyTips(FocusWidgetName, FocusWidgetWidget, bIsFocusToParent)
end

function M:PlayStarGoldenInAnim(Idx)
    local Len = self.AvatarName.HB_Star:GetChildrenCount()
    local Stars = self.AvatarName.HB_Star:GetAllChildren()
    if(Idx <= Len)then
        Stars[Idx]:BindToAnimationFinished(Stars[Idx].Golden_In, {Stars[Idx], function()
                            Stars[Idx]:UnbindAllFromAnimationFinished(Stars[Idx].In)
                            Stars[Idx]:PlayAnimation(Stars[Idx].Loop, 1, 0)
                        end})
        Stars[Idx]:PlayAnimation(Stars[Idx].Golden_In)
    end
end

function M:RefreshItemStyleView(RewardIndex, RewardState)
    -- 刷新Item表现
    local TargetItem = self.SevenDayItems["LowItem_"..RewardIndex] or self.SevenDayItems.HighItem
    if (TargetItem ~= nil) then
        TargetItem:RefreshRewardByState(RewardState)
    end
end

return M
