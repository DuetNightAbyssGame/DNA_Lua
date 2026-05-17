--
-- DESCRIPTION
-- 活动系统跳转View （PC、移动端公用）
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"
local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"

local M = {}

local NotNeedShowButtonActivityId = {
    [103011] = true,
    [103020] = true,
}

local NeedShowButtonActivityIdByTabName = {
    [103016] = true, -- Tab和右下角入口保持同步
}

function M:PlayFadeIn()
    -- 播放入场动画
    self:PlayAnimation(self.In)
    -- 播放标题动画
    local TitleWidget = self.Group_TitleAnchor:GetChildAt(0)
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

-- function M:ReceiveEnterState(StackAction)
--     ---大秘境奖励领完之后需要同步活动的红点状态
--     local AbyssRewardNode = ReddotManager.GetTreeNode("AbyssReward")
--     if AbyssRewardNode and AbyssRewardNode.Count == 0 and self.CurActivityId 
--         and ActivityUtils.Id2ReddotNodeName[self.CurActivityId] == "AbyssMain" then
--         ActivityUtils.TrySubActivityReddotCommon("Red", self.CurActivityId)
--     end
--     M.Super.ReceiveEnterState(self, StackAction)
-- end

function M:RefreshPageStaticView(ActivityConfigData, PageConfigData, InfoClickFunction, ShopClickFunction, GoToTargetPageFunction, StuffDetailOpenFunction, GoToTaskClickFunction, GoToMoreClickFunction)
    -- 支持其他活动选择是否接入按钮红点，不接入就加到这个列表里
    if not self.NotNeedShowButtonActivityId then
        self.NotNeedShowButtonActivityId = NotNeedShowButtonActivityId
    end
    -- 右上方标题相关
    local PlayerAvatar = GWorld:GetAvatar()
    local TitleWidget = UIManager(self):CreateWidget(ActivityConfigData.EventNameBPPath)

    self:UpdateEventTitleInfo(ActivityConfigData, TitleWidget, PlayerAvatar)
    self.Group_TitleAnchor:ClearChildren()
    self.Group_TitleAnchor:AddChildToOverlay(TitleWidget)
    self.Group_TitleAnchor:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])

    if (ActivityConfigData.EventRule) then
        self.Text_ActivityDescTitle:SetText(GText("UI_Common_Rule"))
        self.Com_BtnExplanation:SetVisibility(UIConst.VisibilityOp["VisibilityOp"])
        self.Group_ActivityQa:SetVisibility(UIConst.VisibilityOp["VisibilityOp"])
    else
        self.Com_BtnExplanation:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Group_ActivityQa:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end

    -- 中间活动信息
    self.Text_ActivityDesc:SetText(GText(ActivityConfigData.EventDes))
    self.Text_ActivityDesc_White:SetText(GText(ActivityConfigData.EventDes))
    self.Text_RewardTitle:SetText(GText("UI_GameEvent_EventPortal_RewardPreview"))

    -- 下方奖励相关
    self.List_Reward.OnCreateEmptyContent:Unbind()
    self.List_Reward.OnCreateEmptyContent:Bind(self, function(self)
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.Id = 0
        return Content
    end)
    self.List_Reward:ClearListItems()
    local PreViewReward, RewardContentList = PageConfigData.RewardPreview, {}
    if PreViewReward == nil then
        self.Group_RewardView:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    else
        local AllRewardList = RewardUtils:GetRewardViewInfoById(PreViewReward)
        for i, RewardInfo in ipairs(AllRewardList) do
            if RewardInfo then
                local RewardIcon = ItemUtils.GetItemIconPath(RewardInfo.Id, RewardInfo.Type)
                local RewardContent = self:NewItemContent(RewardInfo.Type, RewardInfo.Id, RewardIcon, RewardInfo.Rarity or 1, 
                                                            RewardInfo.Quantity, StuffDetailOpenFunction)
                if self:IsRewardShow(RewardContent) then
                    table.insert(RewardContentList, RewardContent)
                end
            end
        end
        for _, ItemContent in ipairs(RewardContentList) do
            self.List_Reward:AddItem(ItemContent)
        end
        self.List_Reward:RequestFillEmptyContent()
    end

    if (PageConfigData.EventShop) then
        self.Group_BtnBuy:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        if (CommonUtils.GetDeviceTypeByPlatformName(self) == CommonConst.CLIENT_DEVICE_TYPE.PC) then
            self.Btn_Buy.Key_Shop:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        end
        self.Group_BtnBuy:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end

    if (PageConfigData.TaskId) then
        self.Group_BtnTask:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self.Group_BtnTask:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end

    if (PageConfigData.ShowBtnMore) then
        self.Size_More:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self.Size_More:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end

    local IsLock = false
    local IsComplete = false
    if (PageConfigData.JumpFinishCondition) then
        if (ConditionUtils.CheckCondition(PlayerAvatar, PageConfigData.JumpFinishCondition)) then
            IsComplete = true
        end
    end
    if (PageConfigData.JumpUnlockCondition) then
        if (not ConditionUtils.CheckCondition(PlayerAvatar, PageConfigData.JumpUnlockCondition)) then
            IsLock = true
        end
    end

    self.WS:SetVisibility(UIConst.VisibilityOp["VisibilityOp"])
    self.Group_Reward:SetVisibility(UIConst.VisibilityOp["VisibilityOp"])
    if IsLock then
        self.WS:SetActiveWidgetIndex(1)
    else
        if IsComplete then
            self.WS:SetActiveWidgetIndex(2)
            self.Text_Complete:SetText(GText(PageConfigData.JumpFinishDes))
        else
            if (PageConfigData.JumpUIId == nil) then
                self.IsHideReward = true
                self.WS:SetVisibility(UIConst.VisibilityOp["Collapsed"])
                self.Group_Reward:SetVisibility(UIConst.VisibilityOp["Collapsed"])
            else
                if (PageConfigData.IsUseTabJumpBtn ~= nil and PageConfigData.IsUseTabJumpBtn == false) then
                    self.Btn_Confirm:SetVisibility(UIConst.VisibilityOp.Collapsed)
                end
            end
            self.WS:SetActiveWidgetIndex(0)
        end
    end

    -- 前置任务相关、以及特殊UI
    self.Group_Task:ClearChildren()
    self.Group_TaskProgress:ClearChildren()
    self.Group_Common_SubItem:ClearChildren()
    self.Group_LimitTimeReward:ClearChildren()
    if (ActivityConfigData.PretextTasks1 or ActivityConfigData.PretextTasks2) then
        local TaskWidget = UIManager(self):CreateWidget("/Game/UI/WBP/Activity/Widget/PreTask/WBP_Activity_PreTask_Item.WBP_Activity_PreTask_Item")
        TaskWidget:InitPage(ActivityConfigData.EventId)
        if (TaskWidget and TaskWidget:IsNeedShow()) then
            self.Group_Task:AddChildToOverlay(TaskWidget)
        else
            self.TaskProcessWidget = UIManager(self):CreateWidget(PageConfigData.SubBPPath2)
            if (self.TaskProcessWidget) then
                self.TaskProcessWidget.ParentWidget = self
                if (type(self.TaskProcessWidget.InitPage) == "function") then
                    self.TaskProcessWidget:InitPage(ActivityConfigData.EventId)
                else
                    self.TaskProcessWidget:Init(ActivityConfigData, PageConfigData, PlayerAvatar)
                end
                self.Group_TaskProgress:AddChildToOverlay(self.TaskProcessWidget)
            end
        end
    elseif (PageConfigData.SubBPPath2) then
        self.Group_Task:ClearChildren()
        self.Group_TaskProgress:ClearChildren()
        self.SpecialWidget = UIManager(self):CreateWidget(PageConfigData.SubBPPath2)
        if self.SpecialWidget.Init then
            self.SpecialWidget.ParentWidget = self
            self.SpecialWidget:Init(ActivityConfigData, PageConfigData, PlayerAvatar)
        end
        local Slot = self.Group_Common_SubItem:AddChildToOverlay(self.SpecialWidget)
        Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
        Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
    end

    local AbyssSeasonId = PlayerAvatar.CurrentAbyssSeasonId
    local AbyssSeasonConfig = DataMgr.AbyssSeasonList[AbyssSeasonId]
    if AbyssSeasonConfig then
        local AbyssActivityId = AbyssSeasonConfig.EventId
        -- 大秘境要特殊加载一个子widget，只能特殊写一个逻辑了
        if ActivityConfigData.EventId == AbyssActivityId then
            local AbyssWidget = UIManager(self):CreateWidget('/Game/UI/WBP/Activity/Widget/Abyss/WBP_Activity_Abyss_Character.WBP_Activity_Abyss_Character')
            if AbyssWidget.Init then
                AbyssWidget:Init(ActivityConfigData, PageConfigData, PlayerAvatar)
            end
            local Slot = self.Group_Common_SubItem:AddChildToOverlay(AbyssWidget)
            Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
            Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
        end
    end

    self.RewardWidget = UIManager(self):CreateWidget(PageConfigData.RewardBPPath)
    -- 常驻活动或者未解锁的活动不显示奖励
    if (PageConfigData.RewardBPPath and not ActivityUtils.CheckIsPermanentEvent(ActivityConfigData.EventId) and not IsLock) then
        if self.RewardWidget.Init then
            self.RewardWidget.ParentWidget = self
            self.RewardWidget:Init(ActivityConfigData, PageConfigData, PlayerAvatar)
        end
        local Slot = self.Group_LimitTimeReward:AddChildToOverlay(self.RewardWidget)
        Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
        Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
    end

    self.Text_Lock:SetText(GText(PageConfigData.JumpUnlockTips))
    self.Btn_Confirm:SetText(GText("UI_GameEvent_EventPortal_Goto"))
    if PageConfigData.GotoBtnTextmap then
        self.Btn_Confirm:SetText(GText(PageConfigData.GotoBtnTextmap))
    end
    self.Btn_Confirm:SetGamePadImg("A")
    self:BindAllClickFunction(InfoClickFunction, ShopClickFunction, GoToTargetPageFunction, GoToTaskClickFunction, GoToMoreClickFunction)

    -- 初始化平台相关UI
    self:InitUIInfoByPlatform()

    ---跳转按钮接红点
    local CallbackInfo = {Obj=self, Func = function(self, Count, RdType, RdName)
        local Node = ReddotManager.GetTreeNode(RdName)
        if RdType == EReddotType.Normal then
            local bShowRed = Node.bImplemented and (ActivityUtils.GetReddotCachInfoByKey("Red",self.CurActivityId) == 1) or Count >0
            self.Btn_Confirm:EMShowReddot(bShowRed, EReddotType.Normal)
        elseif RdType == EReddotType.New then
            local bShowNew = Node.bImplemented and (ActivityUtils.GetReddotCachInfoByKey("New",self.CurActivityId) == 1) or Count >0
            self.Btn_Confirm:EMShowReddot(bShowNew, EReddotType.New)
        end
    end}

    --有些跳转活动不需要接这个红点
    if NeedShowButtonActivityIdByTabName[self.CurActivityId] then
        ActivityReddotHelper.AddReddotListenByTabId(self.ParentTabId, CallbackInfo)
    elseif not self.NotNeedShowButtonActivityId[self.CurActivityId] then
        ActivityReddotHelper.RemoveReddotListenByEventId(self.CurActivityId, self)
        ActivityReddotHelper.AddReddotListenByEventId(self.CurActivityId, CallbackInfo)
    end

    if ActivityUtils.IsAccessoryDropActivity(self.CurActivityId) then
        self.Btn_Buy:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        self.Btn_Buy:TryOverrideSoundFunc(function()
            AudioManager(self):PlayUISound(self, "event:/ui/activity/shop_small_btn_click", nil, nil)
        end)
        self.Btn_Buy:SetVisibility(UIConst.VisibilityOp.Visible)
    end

    self.Btn_Confirm:TryOverrideSoundFunc(function()
        AudioManager(self):PlayUISound(self, "event:/ui/activity/confirm_click", nil, nil)
    end)

    if self.IsHideReward then
        self.Group_Task:ClearChildren()
    end
end

function M:IsRewardShow(RewardContent)
    if ActivityUtils.IsAccessoryDropActivity(self.CurActivityId) then
        if RewardContent.ItemType == "CharAccessory" then
            return true
        else
            return false
        end
    end
 
    return true
end

function M:UpdateEventTitleInfo(ActivityConfigData, TitleWidget, PlayerAvatar)
    if (not TitleWidget) then
        return
    end
    TitleWidget.Text_Title:SetText(GText(ActivityConfigData.EventName))
    if ActivityConfigData.EventSName and TitleWidget.Text_SubTitle then
        TitleWidget.Text_SubTitle:SetText(GText(ActivityConfigData.EventSName))
    end
end

function M:BindAllClickFunction(InfoClickFunction, ShopClickFunction, GoToTargetPageFunction, GoToTaskClickFunction, GoToMoreClickFunction)
    self.Btn_Buy:BindEventOnClicked(self, ShopClickFunction)
    self.Btn_Confirm:BindEventOnClicked(self, GoToTargetPageFunction)
    self.BtnTask:BindEventOnClicked(self, GoToTaskClickFunction)
    self.Com_BtnMore:BindEventOnClicked(self, GoToMoreClickFunction)
    local BtnExplanationConfigData = {}
    BtnExplanationConfigData.ClickCallback = InfoClickFunction
    BtnExplanationConfigData.OwnerWidget = self
    BtnExplanationConfigData.Desc = "UI_Common_Rule"
    BtnExplanationConfigData.SoundFunc = function()
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    end
    self.Com_BtnExplanation:Init(BtnExplanationConfigData)
end

function M:InitUIInfoByPlatform()
    if (CommonUtils.GetDeviceTypeByPlatformName(self) == CommonConst.CLIENT_DEVICE_TYPE.PC) then 
        -- PC端特殊UI
        self.Btn_Buy.Key_Shop:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "X",
                },
            },
        })

        self.Key_Task:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "X",
                },
            },
        })

        self.Key_More:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "RS",
                },
            },
        })

        self.Key_RewardTitle:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "LS",
                },
            },
        }) 

        self.Com_BtnExplanation.Com_KeyImg:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "Menu",
                },
            },
        }) 
    else
        -- 移动端特殊UI
    end
end

function M:RefreshPageDynamicView()
    -- 把列表滑动到第一个
    self.List_Reward:ScrollIndexIntoView(0)
end

-- 通用子控件可以在切换时做一些事情，如播动画
function M:UpdatePageDynamicView()
    if self.RewardWidget and self.RewardWidget.Update then
        self.RewardWidget:Update()
    end

    if self.SpecialWidget and self.SpecialWidget.Update then
        self.SpecialWidget:Update()
    end

    if self.TaskProcessWidget and self.TaskProcessWidget.Update then
        self.TaskProcessWidget:Update()
    end
end

function M:NewItemContent(ItemType, ItemId, Icon, Rarity, Quantity, OpenFunction)
    -- 新建一个列表数据对象
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    -- Obj.Id = ItemId
    Obj.ItemType = ItemType
    Obj.UnitId = ItemId
    Obj.Rarity = Rarity
    Obj.Icon = Icon
    Obj.IsShowDetails = true
    Obj.OnMenuOpenChangedEvents = {Obj=self, Callback=OpenFunction}
    Obj.UIName = "ActivityJumpPage"
    if Quantity then
        if #Quantity > 1 then
            Obj.Count = Quantity[1]
            Obj.MaxCount = Quantity[2]
        else
            Obj.Count = Quantity[1]
        end
    end
    return Obj
end

return M