--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local EMCache   = require "EMCache.EMCache"

---@type WBP_Shop_Recommend_Common_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C", "BluePrints.Common.TimerMgr", "BluePrints.Common.DelayFrameComponent"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType())
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:InitBannerPage(BannerId, ParentWidget)
    self.BannerId = BannerId
    self.BannerData = setmetatable({}, {__index = DataMgr.ShopBannerTab[BannerId]})
    self.Parent = ParentWidget
    self.Image_Hit:SetVisibility(UIConst.VisibilityOp["Visible"])
end

function M:SetBannerPageInfo()
    self.BannerData.ItemId = self:GetValidItemId(self.BannerData)

    --- 加载基础信息部分
    self:InitBaseInfo()


    --- 调用加载模型部分
    self.bHasVideo = not not (self.BannerData.BgVideoPath and self.BannerData.BgVideoPath ~= "" 
                                and self.BannerData.DisplayType and self.BannerData.DisplayId)
    -- 有视频要放的情况下跳过模型初始化，避免进入和退出商店时出现模型，同时降低消耗

    --- 有视频的轮盘动作不显示重播按钮
    self.Parent:SetReplayGestureVisible(self.BannerData and self.BannerData.DisplayType == "Resource" and self.BannerData.DisplayId and not self.bHasVideo)

    if self.bHasVideo then
        self.Parent:SetCameraToDefault()
        self.Parent:StopActorSound()
    else
        self:InitModelInfo()
    end
    
    --- 调用加载视频部分
    self:InitVideoInfo()

    --- 更新通用底部Tab按键提示
    self:AddDelayFrameFunc(function()
        self:UpdateCommonTabInfo()
    end, 1)
end

function M:GetValidItemId(BannerData)
    local LastItemId = nil
    if not BannerData.ItemIds or not next(BannerData.ItemIds) then
        return LastItemId
    end
    for _, ItemId in ipairs(BannerData.ItemIds) do
        local PurchaseLimit = ShopUtils:GetShopItemPurchaseLimit(ItemId)
        if PurchaseLimit and PurchaseLimit > 0 then
            return ItemId
        else
            LastItemId = ItemId
        end
    end
    return LastItemId
end

function M:PlayAnimationSwitch(bRight)
    self:StopAllAnimations()
    if bRight then
        self:PlayAnimation(self.Change_LToR)
    else
        self:PlayAnimation(self.Change_RToL)
    end
end

function M:PlayAnimationOut(bRight)
    self:StopAllAnimations()
    self:PlayAnimation(self.Out)
end

function M:PlayAnimationIn()
    self:StopAllAnimations()
    self:PlayAnimation(self.In)
    self:SetBannerPageInfo()
end

function M:OnAnimationFinished(InAnimation)

end
----------------------------------------------------------------------- 加载基础信息部分 -----------------------------------------------------------------------

function M:InitBaseInfo()
    local BannerData = self.BannerData
    if not BannerData then return end
    if BannerData.BannerType == UIConst.ShopBannerType.MonthCard then --不支持月卡
        self:SafeSetVisibility(self.Group_Detail, UE4.ESlateVisibility.Collapsed)
        self:SafeSetVisibility(self.WS_Top, UE4.ESlateVisibility.Collapsed)
        return
    else
        self:SafeSetVisibility(self.Group_Detail, UE4.ESlateVisibility.SelfHitTestInvisible)
        self:SafeSetVisibility(self.WS_Top, UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    self:InitTitleAndFont()   -- 初始化标题与稀有度展示（武器皮肤/4选1/头像皮肤等）
    self:InitTopInfo()        -- 初始化顶部按键信息（视频/动作）
    self:InitPreviewInfo()    -- 初始化预览按键信息（武器皮肤/4选1/头像皮肤等）
    self:InitRewardInfo()     -- 初始化奖励展示信息（武器皮肤/4选1/头像皮肤等）
    self:InitTimeInfo()       -- 初始化时间展示信息（剩余时间）
    self:InitMainBtnInfo()    -- 初始化购买按键信息（购买/查看详情等）

    -- 只有当 DisplayType 不为空时，当前商店界面才可以通过按键操作显隐UI
    self.Parent:SetAllowedToShowHideUI(BannerData.DisplayType and BannerData.DisplayType ~= "")
end

function M:SafeSetVisibility(Widget, Vis)
    if Widget and Widget.SetVisibility then
        Widget:SetVisibility(Vis)
    end
end

-- 初始化标题与稀有度（武器皮肤/4选1/头像皮肤等）
function M:InitTitleAndFont()
    local BannerData = self.BannerData
    if not BannerData then return nil end
    local TitleRoot = self.WBP_Shop_Recommend_Common_TItle_C_0
    local Rarity = self:GetDisplayRarity()
    if TitleRoot and TitleRoot.Text_MainTitle then
        local Fonts = { [3] = "Font_Blue", [4] = "Font_Purple", [5] = "Font_Gold", [6] = "Font_Red" }
        local FontKey = Rarity and Fonts[Rarity] or Fonts[5]
        if FontKey and TitleRoot[FontKey] then
            TitleRoot.Text_MainTitle:SetFont(TitleRoot[FontKey])
        end
    end
    TitleRoot:SetText(GText(BannerData.Text1))
    if self.Com_QualityTag then
        if Rarity then
            self.Com_QualityTag:Init(Rarity)
            self:SafeSetVisibility(self.Com_QualityTag, UE4.ESlateVisibility.SelfHitTestInvisible)
        else
            self:SafeSetVisibility(self.Com_QualityTag, UE4.ESlateVisibility.Collapsed)
        end
    end
    
    self:SafeSetVisibility(self.HB, UE4.ESlateVisibility.Collapsed)
    if self.Group_ActivityQa and self.Com_BtnExplanation and self.Com_BtnExplanation.Tex_Explanation then
        if BannerData.Text2EntryText and BannerData.Text2 then
            local BtnExplanationConfigData = {}
            BtnExplanationConfigData.OwnerWidget = self
            BtnExplanationConfigData.Desc = BannerData.Text2EntryText
            BtnExplanationConfigData.ClickCallback = self.OnBtnExplanationClick
            self:SafeSetVisibility(self.HB, UE4.ESlateVisibility.SelfHitTestInvisible)
            self:SafeSetVisibility(self.Group_ActivityQa, UE4.ESlateVisibility.SelfHitTestInvisible)
            self.Com_BtnExplanation:Init(BtnExplanationConfigData)
        end
    end
    if self.Text_Detail and BannerData.Text1Sub then
        self:SafeSetVisibility(self.Text_Detail, UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Text_Detail:SetText(GText(BannerData.Text1Sub))
    elseif self.Text_Detail then
        self:SafeSetVisibility(self.Text_Detail, UE4.ESlateVisibility.Collapsed)
    end
end

function M:GetDisplayRarity()
    local BannerData = self.BannerData
    if not BannerData then return nil end
    local FilterDisplayTypeWithDisplayId = {
        ["WeaponSkin"] = true, 
        ["Skin"] = true, 
        ["CharAccessory"] = true, 
        ["WeaponAccessory"] = true, 
        ["Resource"] = true,
        ["Mount"] = true,
    }
    local FilterDisplayTypeWithSkinSeries = {["GeneralSkin"] = true}
    local Rarity = nil
    local DisplayType = BannerData.DisplayType
    
    if BannerData.DisplayType and FilterDisplayTypeWithDisplayId[BannerData.DisplayType] then
        local DisplayId = BannerData.DisplayId
        if DisplayId and DataMgr[DisplayType] then
            local DataInfo = DataMgr[DisplayType][DisplayId]
            Rarity = DataInfo and (DataInfo.Rarity or DataInfo.MountRarity or 4) or nil
        end
    elseif BannerData.DisplayType and FilterDisplayTypeWithSkinSeries[BannerData.DisplayType] then
        local SkinSeries = BannerData.SkinSeries
        local SkinSeriesTables = {"Skin"}
        for _, SkinSeriesTable in ipairs(SkinSeriesTables) do
            if SkinSeriesTable and DataMgr[SkinSeriesTable] then
                for _, SkinInfo in pairs(DataMgr[SkinSeriesTable]) do
                    if SkinInfo and SkinInfo.SkinSeries == SkinSeries and SkinInfo.Rarity then
                        Rarity = SkinInfo.Rarity
                        break
                    end
                end
            end
            if Rarity then
                break
            end
        end
    end
    return Rarity
end

function M:OnBtnExplanationClick()
    if not self then return end
    local BannerData = self.BannerData
    if not BannerData then return end
    self.Parent.Shop_RecommendBanner:StopBannerTimer()
    UIManager(self):ShowCommonPopupUI(100269, {
            LongText = BannerData.Text2,
            Title = BannerData.Text2EntryText, 
            CloseBtnCallbackObj = self,
            CloseBtnCallbackFunction = function(self, Data, PopupWidget)
                -- PopupWidget:OnClose()
                self.Parent.Shop_RecommendBanner:StartBannerTimer()
            end
        }, self)
end

-- 初始化顶部按键信息（视频/动作）
function M:InitTopInfo()
    local BannerData = self.BannerData
    if not BannerData or not self.WS_Top then 
        return 
    end
    local ActivateWidget = nil

    -- local BgVideoDesc = (BannerData.BgVideoPath and BannerData.BgVideoPath ~= "") and "UI_Banner_ReplayVideo" or nil
    -- if BgVideoDesc then
    --     self.WS_Top:SetActiveWidgetIndex(1)
    --     self.Btn_Shop_Recommend_Video.Text_Btn:SetText(GText(BgVideoDesc))
    --     ActivateWidget = self.Btn_Shop_Recommend_Video
    --     self:SafeSetVisibility(self.Btn_Shop_Recommend_Video, UE4.ESlateVisibility.SelfHitTestInvisible)
    --     if ActivateWidget and ActivateWidget.Btn_Click then
    --         ActivateWidget.Btn_Click.OnClicked:Remove(self, self.OnBtnReplayClick)
    --         ActivateWidget.Btn_Click.OnClicked:Add(self, self.OnBtnReplayClick)
    --     end
    -- else
    --     self:SafeSetVisibility(self.Btn_Shop_Recommend_Video, UE4.ESlateVisibility.Collapsed)
    -- end
    self:SafeSetVisibility(self.Btn_Shop_Recommend_Video, UE4.ESlateVisibility.Collapsed)

    local SwitchDesc = (BannerData.DisplayType and BannerData.DisplayType == "WeaponAccessory") and "UI_Banner_SwitchWeapon" or nil
    if SwitchDesc then
        self.WS_Top:SetActiveWidgetIndex(0)
        self.Btn_Shop_Switch.Text_Btn:SetText(GText(SwitchDesc))
        self.Key_Recommond01.Text_Desc:SetText(GText(SwitchDesc))
        self.Key_Recommond01:CreateSubKeyDesc({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "LS",
                },
            },
            Type = "Img",
        })
        self.Btn_Shop_Switch_M.Text_Btn:SetText(GText(SwitchDesc))
        -- 根据当前环境，键鼠，手柄，和移动端，分别使self.WS_Key可见
        if UIUtils.IsKeyboardInput() then
            self.WS_Key:SetActiveWidgetIndex(0)
            ActivateWidget = self.Btn_Shop_Switch
        elseif UIUtils.IsGamepadInput() then
            self.WS_Key:SetActiveWidgetIndex(1)
            ActivateWidget = self.Key_Recommond01
        elseif UIUtils.IsMobileInput() then
            self.WS_Key:SetActiveWidgetIndex(2)
            ActivateWidget = self.Btn_Shop_Switch_M
        end
        self:SafeSetVisibility(self.WS_Key, UE4.ESlateVisibility.SelfHitTestInvisible)
        if ActivateWidget and ActivateWidget.Btn_Click then
            ActivateWidget.Btn_Click.OnClicked:Remove(self, self.OnBtnSwitchClick)
            ActivateWidget.Btn_Click.OnClicked:Add(self, self.OnBtnSwitchClick)
        end
    else
        self:SafeSetVisibility(self.WS_Key, UE4.ESlateVisibility.Collapsed)
    end

    if BannerData.DisplayType and BannerData.DisplayType == "Resource" then
        if self.Parent.Btn_Shop_Refresh and self.Parent.Btn_Shop_Refresh.Btn_Click and self.OnBtnReplayClick then
            self.Parent.Btn_Shop_Refresh.Btn_Click.OnClicked:Remove(self, self.OnReplayGesture)
            self.Parent.Btn_Shop_Refresh.Btn_Click.OnClicked:Add(self, self.OnReplayGesture)
        end
    end
end

-- 对于聚焦的组件，引擎把空格和回车视为点击
-- 为了避免点击播放视频使按钮获得聚焦，导致空格长按跳过视频后，松开空格触发对该按钮的点击
-- 在蓝图中将WBP_Shop_Recommend_VideoBtn的Btn_Click设置为不可聚焦
function M:OnBtnReplayClick()
    -- DebugPrint("lgc@WBP_Shop_Recommend_Common OnBtnReplayClick")
    -- AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    -- self.Parent:PlayVideoTop()
end

--- WeaponAccessory类型的Banner，切换预览武器配件
function M:OnBtnSwitchClick()
    DebugPrint("lgc@WBP_Shop_Recommend_Common OnBtnSwitchClick")
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    if self.TabIdx == nil or self.TabIdx == 1 then
        self.TabIdx = 2
    else
        self.TabIdx = 1
    end
    if self.Parent.SwitchWeaponAccessoryPreview then
        self.Parent:SwitchWeaponAccessoryPreview(self.TabIdx)
    end
end

function M:OnRKeyDown()
    if not self.BannerData then
        return
    end
    if self.BannerData.DisplayType ~= "Resource" and self.BannerData.DisplayType ~= "Mount" then
        return
    end
    if self.BannerData.DisplayType == "Resource" then
        self:OnReplayGesture()
    elseif self.BannerData.DisplayType == "Mount" then
        self:OnRideMount()
    end
end

--- 重播轮盘动作
function M:OnReplayGesture()
    if self.Parent and self.BannerData and self.BannerData.DisplayId then
        self.Parent:ReplayGesture(self.BannerData.DisplayId)
    end
end

--- 坐骑骑乘/离开
function M:OnRideMount()
    if self.Parent and self.Parent.RiderMount and self.BannerData.DisplayId then
        self.Parent:RiderMount(self.BannerData.DisplayId)
    end
end

-- 初始化奖励信息
function M:InitRewardInfo()
    local BannerData = self.BannerData
    if not BannerData then 
        self:ClearAndHideRewardView()
        return 
    end
    
    local bHasRewards = false
    local TypeId = nil
    local Rewards = nil
    
    local ShopItemData = self:GetShopItemInfo(BannerData.ItemId)
    if not ShopItemData or ShopItemData.ItemType ~= "Reward" then
        self:ClearAndHideRewardView()
        return
    end
    if ShopItemData and ShopItemData.TypeId and DataMgr.Reward and DataMgr.Reward[ShopItemData.TypeId] then
        TypeId = ShopItemData.TypeId 
        Rewards = DataMgr.Reward and DataMgr.Reward[TypeId]
        if Rewards and Rewards.Id and #Rewards.Id > 0 then
            bHasRewards = true
        end
    end
    
    if not bHasRewards then
        self:ClearAndHideRewardView()
        return
    end
    
    self:SafeSetVisibility(self.Group_RewardView, UE4.ESlateVisibility.SelfHitTestInvisible)
    self:SafeSetVisibility(self.SwitchTitleIcon, UE4.ESlateVisibility.SelfHitTestInvisible)

    if self.Text_RewardTitle and BannerData.DisplayText then
        self:SafeSetVisibility(self.Text_RewardTitle, UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Text_RewardTitle:SetText(GText(BannerData.DisplayText))
    end
    
    -- 初始化List_Reward展示逻辑
    if self.List_Reward then
        self.RewardList = {}
        local RewardIds = Rewards.Id
        local RewardCounts = Rewards.Count
        local RewardTypes = Rewards.Type
        for i = 1, #RewardIds do
            local ItemId = RewardIds[i]
            local Count = RewardUtils and RewardUtils.GetCount and RewardUtils:GetCount(RewardCounts[i]) or RewardCounts[i]
            local ItemData = DataMgr[RewardTypes[i]][ItemId]
            local bHasIcon = ItemData and ItemData.Icon
            local Icon = (bHasIcon and ItemUtils and ItemUtils.GetItemIcon) and ItemUtils.GetItemIcon(ItemId, RewardTypes[i]) or nil
            local Rarity = ItemUtils and ItemUtils.GetItemRarity and ItemUtils.GetItemRarity(ItemId, RewardTypes[i])
            local ItemType = RewardTypes[i]
            local RewardContent = {
                Id = ItemId,
                Type = ItemType,
                ItemCount = Count,
                Icon = Icon,
                Rarity = Rarity,
            }
            table.insert(self.RewardList, RewardContent)
        end

        self.List_Reward:ClearListItems()
        for _, ItemInfo in pairs(self.RewardList) do
            local Content = NewObject(UIUtils and UIUtils.GetCommonItemContentClass and UIUtils.GetCommonItemContentClass())
            if Content then
                Content.Id = ItemInfo.Id
                Content.Icon = ItemUtils and ItemUtils.GetItemIconPath and ItemUtils.GetItemIconPath(ItemInfo.Id, ItemInfo.Type)
                Content.ParentWidget = self
                Content.ItemType = ItemInfo.Type
                Content.Count = ItemInfo.ItemCount
                Content.Rarity = ItemInfo.Rarity or 1
                Content.IsShowDetails = true
                Content.AfterInitCallback = function(Widget)
                    if Widget and Widget.BindEvents then
                        Widget:BindEvents(self, {OnMenuOpenChanged = function(Obj, bIsOpen)
                            local bGamePad = UIUtils and UIUtils.UtilsGetCurrentInputType and UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
                            if bIsOpen and bGamePad then
                                if self.Owner and self.Owner.Common_Tab and self.Owner.Common_Tab.UpdateBottomKeyInfo then
                                    self.Owner.Common_Tab:UpdateBottomKeyInfo({})
                                end
                            elseif not bIsOpen and bGamePad then
                                if self.Owner and self.Owner.UpdateCommonTabInfoByReward then
                                    self.Owner:UpdateCommonTabInfoByReward()
                                end
                            end
                            if bIsOpen then
                                self.Parent.Shop_RecommendBanner:StopBannerTimer()
                            else
                                self.Parent.Shop_RecommendBanner:StartBannerTimer()
                            end
                        end})
                        Widget.OnMouseButtonDownEvent = {Obj = self, Callback = function()
                            self.Parent.Shop_RecommendBanner:StopBannerTimer()
                        end}
                    end
                end
                self.List_Reward:AddItem(Content)
            end
        end
    end
end

function M:ClearAndHideRewardView()
    self:SafeSetVisibility(self.Group_RewardView, UE4.ESlateVisibility.Collapsed)

    if self.List_Reward then
        self.List_Reward:ClearListItems()
    end
    
    if self.RewardList then
        self.RewardList = {}
    end
    
    self:SafeSetVisibility(self.SwitchTitleIcon, UE4.ESlateVisibility.Collapsed)
end

-- 初始化预览相关信息（预览按钮、预览文案）
function M:InitPreviewInfo()
    local PreviewBtn = (self.Btn_Qa and self.Btn_Qa.Button_Area) or self.Btn_Qa
    if PreviewBtn and PreviewBtn.OnClicked then
        PreviewBtn.OnClicked:Clear()
    end
    local BannerData = self.BannerData
    if not BannerData or not BannerData.PreviewType then 
        self:HidePreviewInfo()
        return 
    end
    local PreviewType = BannerData.PreviewType
    local PreviewIdList = BannerData.PreviewId
    local bHasPreview = (PreviewType == "SkinSeries") or (PreviewIdList and #PreviewIdList > 0)
    
    if not bHasPreview then
        self:HidePreviewInfo()
        return
    end
    self:SafeSetVisibility(self.HB_Desc, UE4.ESlateVisibility.SelfHitTestInvisible)
    self:SafeSetVisibility(self.Text_ActivityDesc_White, UE4.ESlateVisibility.SelfHitTestInvisible)
    self:SafeSetVisibility(self.Group_BtnQA, UE4.ESlateVisibility.SelfHitTestInvisible)
    self:SafeSetVisibility(self.Btn_Qa, UE4.ESlateVisibility.SelfHitTestInvisible)
    if self.Text_ActivityDesc_White and BannerData.PreviewEntryText then
        self.Text_ActivityDesc_White:SetText(GText(BannerData.PreviewEntryText))
    end
    
    if not PreviewBtn then
        local TitleRoot = self.WBP_Shop_Recommend_Common_TItle_C_0 or self.WBP_Shop_Recommend_Common_TItle
        if TitleRoot and TitleRoot.Button_Preview then
            PreviewBtn = TitleRoot.Button_Preview
        end
    end
    
    if PreviewBtn and PreviewBtn.OnClicked then
        PreviewBtn.OnClicked:Add(self, self.OnBtnPreviewClick)
    end
end

function M:OnBtnPreviewClick()
    local BannerData = self.BannerData
    local PreviewType = BannerData.PreviewType
    local PreviewIdList = BannerData.PreviewId

    if (PreviewType == "Char" or PreviewType == "Weapon") and PreviewIdList then
        if self.Parent and self.Parent.ActorController then
            self.Parent.ActorController:HidePlayerActor("ActorController_HidePlayerBeforeMount", false)
        end
        local Params = {}
        Params.IsPreviewMode = true
        if self.BannerData.PreviewType == "Char" then
            Params.PreviewCharIds = PreviewIdList
        elseif self.BannerData.PreviewType == "Weapon" then
            Params.PreviewWeaponIds = PreviewIdList
        end
        Params.EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon
        Params.bNoEndCamera = true
        UIManager(self):LoadUINew("ArmoryDetail", Params)
        self.Parent.Shop_RecommendBanner:StopBannerTimer()
    elseif PreviewIdList and UIUtils.CanOpenSkinPreview(PreviewType, PreviewIdList[1]) then
        if self.Parent and self.Parent.ActorController then
            self.Parent.ActorController:HidePlayerActor("ActorController_HidePlayerBeforeMount", false)
        end
        UIManager(self):LoadUINew("SkinPreview", {
            ItemType = PreviewType,
            SkinList = PreviewIdList,
            HidePurchase = true,
        })
        self.Parent.Shop_RecommendBanner:StopBannerTimer()
        return
    elseif PreviewType == "SkinSeries" then
        if self.Parent and self.Parent.ActorController then
            self.Parent.ActorController:HidePlayerActor("ActorController_HidePlayerBeforeMount", false)
        end
        UIManager(self):LoadUINew("CharSkinPreview", {Type = "ShopRecommend", SkinSeriesId = BannerData.SkinSeries})
        self.Parent.Shop_RecommendBanner:StopBannerTimer()
        return
    end
end

function M:HidePreviewInfo()
    self:SafeSetVisibility(self.HB_Desc, UE4.ESlateVisibility.Collapsed)
    self:SafeSetVisibility(self.Text_ActivityDesc_White, UE4.ESlateVisibility.Collapsed)
    self:SafeSetVisibility(self.Group_BtnQA, UE4.ESlateVisibility.Collapsed)
    if self.Btn_Qa then
        self:SafeSetVisibility(self.Btn_Qa, UE4.ESlateVisibility.Collapsed)
        local PreviewBtn = (self.Btn_Qa and self.Btn_Qa.Button_Area) or self.Btn_Qa
        if not PreviewBtn then
            local TitleRoot = self.WBP_Shop_Recommend_Common_TItle_C_0 or self.WBP_Shop_Recommend_Common_TItle
            if TitleRoot and TitleRoot.Button_Preview then
                PreviewBtn = TitleRoot.Button_Preview
            end
        end
        if PreviewBtn and PreviewBtn.OnClicked then
            PreviewBtn.OnClicked:Clear()
        end
    end
end

-- 倒计时（EndTime 合法则显示并刷新，否则折叠）
function M:InitTimeInfo()
    self:RemoveTimer("Recommend_Common_Timer")
    local BannerData = self.BannerData
    if not BannerData then return end
    local ActivityTime = self.Activity_Time
    local HBTime = self.HB_Time
    if BannerData.ShowRemainTime ~= true then
        self:SafeSetVisibility(HBTime or ActivityTime, UE4.ESlateVisibility.Collapsed)
        return
    end
    local EndTime = BannerData.EndTime
    if EndTime and ActivityTime then
        self:SafeSetVisibility(self.HB, UE4.ESlateVisibility.SelfHitTestInvisible)
        self:SafeSetVisibility(HBTime or ActivityTime, UE4.ESlateVisibility.SelfHitTestInvisible)
        local UpdateTimeInfo = function()
            local RemainTimeDict, _ = UIUtils.GetLeftTimeStrStyle2(EndTime)
            if RemainTimeDict and ActivityTime.SetTimeText then
                ActivityTime:SetTimeText(GText("UI_Banner_RemainTime"), RemainTimeDict)
            else
                if ActivityTime.SetForeverTimeText then
                    ActivityTime:SetForeverTimeText(GText("UI_GameEvent_EventTimeRemain"))
                end
                self:RemoveTimer("Recommend_Common_Timer")
            end
        end
        UpdateTimeInfo()
        self:AddTimer(1.0, UpdateTimeInfo, true, 0, "Recommend_Common_Timer", true)
    end
end

-- 初始化主要按钮信息（购买/获取按钮）
function M:InitMainBtnInfo()
    local BannerData = self.BannerData
    if not BannerData then return end
    if self.WS_Btn and BannerData.ItemId == nil and BannerData.InterfaceJumpId then
        self.WS_Btn:SetActiveWidgetIndex(1)
    elseif self.WS_Btn then
        self.WS_Btn:SetActiveWidgetIndex(0)
    end

    -- 清除之前的事件绑定
    if self.Btn_Pay.Btn_Buy and self.Btn_Pay.Btn_Buy.OnClicked then
        self.Btn_Pay.Btn_Buy.OnClicked:Clear()
    end
    if self.Btn_Get.Btn_Buy and self.Btn_Get.Btn_Buy.OnClicked then
        self.Btn_Get.Btn_Buy.OnClicked:Clear()
    end
    
    self.PurchaseLimit = nil
    self.ShopItemData = nil
    self.FinalPrice = nil
    self.PriceType = nil
    self.MainBtn = nil
    self.MainBtnClickFunc = nil
    self.PurchaseLimit = (ShopUtils and ShopUtils.GetShopItemPurchaseLimit and BannerData.ItemId) and ShopUtils:GetShopItemPurchaseLimit(BannerData.ItemId) or 0
    self.ShopItemData = self:GetShopItemInfo(BannerData.ItemId)
    self.FinalPrice, self.PriceType = self:ComputeFinalPrice(self.ShopItemData)
    self.MainBtn = self.WS_Btn:GetActiveWidgetIndex() == 0 and self.Btn_Pay or self.Btn_Get
    if not self.MainBtn or not self.MainBtn.Btn_Buy then return end
    if self.MainBtn.SetGamePadIconVisible then
        self.MainBtn:SetGamePadIconVisible(true)
    end
    if self.MainBtn.Key_ControllerBuy and self.MainBtn.Key_ControllerBuy.CreateCommonKey then
        self.MainBtn.Key_ControllerBuy:CreateCommonKey({
                KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "A"
                }
            },
        })
    end
    if self.WS_Btn:GetActiveWidgetIndex() == 1 then
        self:InitButtonGetInfo()
    else
        if self.PurchaseLimit == 0 then
            self:SetButtonPaySoldOut()
        else
            self:SetButtonPayAvailable()
        end
        self.MainBtn.Btn_Buy.OnClicked:Add(self, self.OnBtnPayClick)
        self.MainBtnClickFunc = self.OnBtnPayClick
    end
end

function M:GetShopItemInfo(ItemId)
    if not ItemId then return nil end
    for _, ShopItemData in pairs(DataMgr.ShopItem or {}) do
        if ShopItemData.ItemId and ShopItemData.ItemId == ItemId then
            return CommonUtils.DeepCopy(ShopItemData)
        end
    end
    return nil
end

function M:GetCutoffInfo(ItemId)
    if not ItemId then return nil end
    for _, CutoffData in pairs(DataMgr.Cutoff or {}) do
        if CutoffData.ItemId and CutoffData.ItemId == ItemId then
            return CommonUtils.DeepCopy(CutoffData)
        end
    end
    return nil
end

-- 计算商品最终价格（考虑折扣等因素）
function M:ComputeFinalPrice(ShopItemData, VoucherId)
    if not ShopItemData then return 0, nil end
    
    local OriginalPrice = ShopItemData.Price or 0
    local PriceType = ShopItemData.PriceType
    local FinalPrice = OriginalPrice
    
    -- 检查是否有折扣信息
    local BannerData = self.BannerData
    if BannerData and BannerData.ItemId then
        local CutoffInfo = self:GetCutoffInfo(BannerData.ItemId)
        local NowTime = TimeUtils and TimeUtils.NowTime() or 0
        local bInCutoffTime = false
        
        if CutoffInfo and CutoffInfo.CutoffStartTime and NowTime >= CutoffInfo.CutoffStartTime then
            if (not CutoffInfo.CutoffEndTime) or (CutoffInfo.CutoffEndTime and NowTime <= CutoffInfo.CutoffEndTime) then
                bInCutoffTime = true
            end
        end
        
        if CutoffInfo and CutoffInfo.CutoffPrice and bInCutoffTime then
            FinalPrice = CutoffInfo.CutoffPrice
        end
        FinalPrice = ShopUtils:GetPriceAfterDiscount(BannerData.ItemId, FinalPrice, VoucherId)
    end

    return FinalPrice, PriceType
end

-- 设置按钮为售罄状态(显示层)
function M:SetButtonPaySoldOut()
    if self.MainBtn.Text_BtnEmpty then
        self.MainBtn.Text_BtnEmpty:SetText(GText("UI_SHOP_SOLDOUT"))
        self:SafeSetVisibility(self.MainBtn.Text_BtnEmpty, UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    
    self:SafeSetVisibility(self.MainBtn.Text_BtnBuy, UE4.ESlateVisibility.Collapsed)
    if self.MainBtn.Btn_Buy then
        self.MainBtn:ForbidBtn(true)
    end
    self:SafeSetVisibility(self.MainBtn.Group_More, UE4.ESlateVisibility.Collapsed)
    self:SafeSetVisibility(self.MainBtn.Group_BuyNum, UE4.ESlateVisibility.Collapsed)
    self:SafeSetVisibility(self.MainBtn.WS_Detail, UE4.ESlateVisibility.Collapsed)
end

-- 设置按钮为可购买状态(显示层)
function M:SetButtonPayAvailable()
    -- 设置按钮文本
    if self.MainBtn.Text_BtnBuy then
        self:SafeSetVisibility(self.MainBtn.Text_BtnBuy, UE4.ESlateVisibility.SelfHitTestInvisible)
        self.MainBtn.Text_BtnBuy:SetText(GText("UI_SHOP_PURCHASE"))
        self.MainBtnTextStr = GText("UI_SHOP_PURCHASE")
    end
    
    self:SafeSetVisibility(self.MainBtn.Text_BtnEmpty, UE4.ESlateVisibility.Collapsed)
    
    -- 设置按钮可用
    if self.MainBtn.Btn_Buy then
        self.MainBtn:ForbidBtn(false)
    end

    if self.MainBtn.Group_BuyNum and self.MainBtn.Text_BuyNum and self.PurchaseLimit > 0 then
        self:SafeSetVisibility(self.MainBtn.Group_BuyNum, UE4.ESlateVisibility.SelfHitTestInvisible)
        self.MainBtn.Text_BuyNum:SetText(GText("UI_Banner_Remain_Buy")..tostring(self.PurchaseLimit))
    else
        self:SafeSetVisibility(self.MainBtn.Group_BuyNum, UE4.ESlateVisibility.Collapsed)
    end
    
    -- 设置价格显示
    if self.MainBtn.Text_Price and self.FinalPrice then
        self:SafeSetVisibility(self.MainBtn.Text_Price, UE4.ESlateVisibility.SelfHitTestInvisible)
        self.MainBtn.Text_Price:SetText(tostring(self.FinalPrice))
        self.MainBtn.Text_PriceMoneyNum:SetText(tostring(self.FinalPrice))
        self.MainBtn.Text_PriceMoneySymbol:SetText(GText(ShopUtils:GetCurrencyType()))
        local Avatar = GWorld:GetAvatar()
        if Avatar and self.PriceType then
            local CurrentCount = Avatar:GetResourceNum(self.PriceType)
            if CurrentCount < self.FinalPrice then
                self.MainBtn.Text_Price:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("DA2A4A"))
            else
                self.MainBtn.Text_Price:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("FFFFFF"))
            end
        end
    end
    
    -- 设置原价显示
    if self.MainBtn.Text_Undiscounted_Price and self.ShopItemData and self.ShopItemData.Price then
        self.MainBtn.Text_Undiscounted_Price:SetText(tostring(self.ShopItemData.Price))
    end
    
    -- 设置货币类型显示
    local bPayGoods = (self.ShopItemData and self.ShopItemData.ItemId) and (not not DataMgr.ShopItem2PayGoods[self.ShopItemData.ItemId]) or false
    if self.PriceType == 99 and self.MainBtn.WS_Detail and bPayGoods then
        self.MainBtn.WS_Detail:SetActiveWidgetIndex(0)
    elseif self.MainBtn.WS_Detail then
        self.MainBtn.WS_Detail:SetActiveWidgetIndex(1)
        self.MainBtn.Icon_Currency:Init({
            Id = self.ShopItemData.PriceType,
            Icon = LoadObject(DataMgr.Resource[self.ShopItemData.PriceType].Icon),
            ItemType = self.ShopItemData.ItemType,
        })
    end
    self:SafeSetVisibility(self.MainBtn.WS_Detail, UE4.ESlateVisibility.SelfHitTestInvisible)
    
    -- 设置折扣信息显示
    local BannerData = self.BannerData
    if not BannerData then return end
    local CutoffInfo = self:GetCutoffInfo(BannerData.ItemId)
    local NowTime = TimeUtils and TimeUtils.NowTime() or 0
    local bInCutoffTime = false
    if CutoffInfo and CutoffInfo.CutoffStartTime and NowTime >= CutoffInfo.CutoffStartTime then
        if (not CutoffInfo.CutoffEndTime) or (CutoffInfo.CutoffEndTime and NowTime <= CutoffInfo.CutoffEndTime) then
            bInCutoffTime = true
        end
    end
    if CutoffInfo and CutoffInfo.CutoffShow and CutoffInfo.CutoffPrice and bInCutoffTime then
        self:SafeSetVisibility(self.MainBtn.Group_More, UE4.ESlateVisibility.SelfHitTestInvisible)
        self:SafeSetVisibility(self.MainBtn.Text_Undiscounted_Price, UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self:SafeSetVisibility(self.MainBtn.Group_More, UE4.ESlateVisibility.Collapsed)
        self:SafeSetVisibility(self.MainBtn.Text_Undiscounted_Price, UE4.ESlateVisibility.Collapsed)
    end
end

function M:OnBtnPayClick()
    -- 播放点击音效
    if AudioManager then
        AudioManager(self):PlayUISound(self, "event:/ui/common/gacha_btn_click_normal", nil, nil)
    end

    if self.PurchaseLimit == 0 then
        UIManager(self):ShowUITip("CommonToastMain", GText("UI_SHOP_SOLDOUT"))
        return
    end

    local ShopItemData = setmetatable({}, {__index = self.ShopItemData})
    local ExecutePurchase = function(RightCallbackObj, PackageResult, DialogWidget)
        local Avatar = GWorld:GetAvatar()
        if not Avatar or not ShopItemData then return end
        if not DialogWidget or not DialogWidget.Params or not DialogWidget.Params.ShopItemData then return end
        
        local SelectCount = 1
        local SelectedDiscount = nil
        if PackageResult and PackageResult.Content_1 and PackageResult.Content_1.CallObj then
            if PackageResult.Content_1.CallObj.CurrentCount then
                SelectCount = PackageResult.Content_1.CallObj.CurrentCount
            end
            if PackageResult.Content_1.CallObj.SelectedDiscount then
                SelectedDiscount = PackageResult.Content_1.CallObj.SelectedDiscount
            end
        end
        local FinalPrice, PriceType = self:ComputeFinalPrice(ShopItemData, SelectedDiscount and SelectedDiscount.VoucherId or nil)
        local CurrentCount = Avatar:GetResourceNum(PriceType)
        FinalPrice = FinalPrice * SelectCount
        if CurrentCount < FinalPrice then
            local Params = {}
            Params.CostNum = FinalPrice
            Params.CostType = PriceType
            Params.RightCallbackObj = self
            UIManager(self):LoadUINew("ShopTargetPay", Params)
            return
        end

        Avatar:PurchaseShopItem(DialogWidget.Params.ShopItemData.ItemId, SelectCount, false, function(Ret)
            if self and self.Parent and self.Parent.Shop_RecommendBanner then
                self.Parent.Shop_RecommendBanner:StartBannerTimer()
            end
        end, SelectedDiscount and SelectedDiscount.VoucherId or nil)
    end
    local BannerData = self.BannerData
    if BannerData and BannerData.ItemId then
        self.Parent.Shop_RecommendBanner:StopBannerTimer()
        if ShopItemData.Bg == 1 and UIManager then
            UIManager(self):LoadUINew("PayGiftPopup_Yellow", ShopItemData, self, function()
                self.Parent.Shop_RecommendBanner:StartBannerTimer()
            end)
        elseif ShopItemData.Bg == 2 and UIManager then
            UIManager(self):LoadUINew("PayGiftPopup_Purple", ShopItemData, self, function()
                self.Parent.Shop_RecommendBanner:StartBannerTimer()
            end)
        else
            -- 显示购买确认弹窗
            local Funds = {{FundId = ShopItemData.PriceType, FundNeed = self.FinalPrice}}
            UIManager(self):ShowCommonPopupUI(100041, {
                ShopItemData = ShopItemData,
                ShopType = 0,
                Funds = Funds,
                ShowParentTabCoin = true,
                RightCallbackObj = self,
                RightCallbackFunction = ExecutePurchase,
                LeftCallbackObj = self,
                LeftCallbackFunction = function(self, Data, PopupWidget)
                    PopupWidget:OnClose()
                    self.Parent.Shop_RecommendBanner:StartBannerTimer()
                end,
                ForbidRightBtn = false,
            }, self)
        end
    end
end

function M:InitButtonGetInfo()
    if not self.MainBtn then return end
    
    if self.MainBtn.Text_BtnBuy then
        self.MainBtn.Text_BtnBuy:SetText(GText("UI_Banner_SkinGacha_Goto"))
        self.MainBtnTextStr = GText("UI_Banner_SkinGacha_Goto")
    end
    
    if self.MainBtn.Text_BtnDesc then
        self.MainBtn.Text_BtnDesc:SetText(GText("UI_Banner_SkinGacha_Get"))
    end
    
    self:SafeSetVisibility(self.MainBtn.Image_Get, UE4.ESlateVisibility.Collapsed)
    
    if self.MainBtn.Btn_Buy then
        self.MainBtn.Btn_Buy:SetForbidden(false)
    end

    -- 绑定前往抽卡界面的点击事件
    if self.MainBtn.Btn_Buy then
        self.MainBtn.Btn_Buy.OnClicked:Add(self, self.OnBtnGetClick)
        self.MainBtnClickFunc = self.OnBtnGetClick
    end
end

function M:OnBtnGetClick()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large_crystal", nil, nil)
    local BannerData = self.BannerData
    if BannerData and BannerData.InterfaceJumpId then
        local JumpUIId = BannerData.InterfaceJumpId
        if PageJumpUtils then
            PageJumpUtils:JumpToTargetPageByJumpId(JumpUIId)
            self.Parent.Shop_RecommendBanner:StopBannerTimer()
        end
    end
end

----------------------------------------------------------------------- 加载基础信息部分 -----------------------------------------------------------------------


----------------------------------------------------------------------- 加载模型部分 -----------------------------------------------------------------------

function M:InitModelInfo()
    local DisplayType = self.BannerData.DisplayType
    if not DisplayType or (self.BannerData.DisplayId == nil and self.BannerData.SkinSeries == nil) then
        if self.Parent then
            self.Parent.Group_BG:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            self.Parent:SetCameraToDefault()
        end
        return
    end

    self.Parent:SetShowModel(true)

    local ItemData = { ItemType = DisplayType }
    if DisplayType == "GeneralSkin" then
        ItemData.SkinSeries = self.BannerData.SkinSeries
    else
        ItemData.TypeId = self.BannerData.DisplayId
    end

    if self.Parent then
        self.Parent.Group_BG:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Parent:SetCameraToPreviewActor()
    end
    self.Image_Hit:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    
    self.Parent:UpdatePreviewActor(ItemData, FVector(0, 35, 0))
    self.TabIdx = 1
end

function M:OnOpenModelPreview()
    if self.BannerData.PreviewType == nil then
        return
    end

    if self.BannerData.PreviewType == "Char" or self.BannerData.PreviewType == "Weapon" then
        local Params = {}
        Params.IsPreviewMode = true
        if self.BannerData.PreviewType == "Char" then
            Params.PreviewCharIds = self.BannerData.PreviewId
        elseif self.BannerData.PreviewType == "Weapon" then
            Params.PreviewWeaponIds = self.BannerData.PreviewId
        end
        Params.EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon
        Params.bNoEndCamera = true
        UIManager(self):LoadUINew("ArmoryDetail", Params)
    else
        UIManager(self):LoadUINew("SkinPreview", {
            ItemType = self.BannerData.PreviewType,
            SkinList = self.BannerData.PreviewId,
            HidePurchase = true,
        })
    end
end

----------------------------------------------------------------------- 加载模型部分 -----------------------------------------------------------------------



----------------------------------------------------------------------- 加载视频部分 -----------------------------------------------------------------------

function M:InitVideoInfo()
    self.Parent:SetHasVideo(self.bHasVideo)
    if not self.bHasVideo then
        self.Parent:StopVideoBGWithDelay(0.5)
        return
    else
        self.Parent:StopVideoBG()
    end

    self.Parent:InitVideoPlayer(self.BannerData.BgVideoPath, self.BannerData.DisplayType, self.BannerData.DisplayId)

    -- 当首次进入商店遇到的banner是首次进入且带视频时，会在顶部播放视频，不需要走banner自己的逻辑
    if not self.Parent.bPlayVideoTop then
        self.Parent:PlayVideoBG()
    end
end

----------------------------------------------------------------------- 加载视频部分 -----------------------------------------------------------------------

-- 监听输入设备切换
function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if CurInputDevice == ECommonInputType.Gamepad then
        self:RefreshOpInfoByGamepad()
    else
        self:RefreshOpInfoByPC()
    end
end

function M:RefreshOpInfoByGamepad()
    if self.Btn_Shop_Recommend_Video and self.Btn_Shop_Recommend_Video.WS_Icon then
        self.Btn_Shop_Recommend_Video.WS_Icon:SetActiveWidget(self.Btn_Shop_Recommend_Video.Key_Icon)
            self.Btn_Shop_Recommend_Video.Key_Icon:CreateCommonKey({
                KeyInfoList=
                {
                    {
                        Type = "Img",
                        ImgShortPath = "View"
                    }
                },
            })
        end
    if self.Com_BtnExplanation and self.Com_BtnExplanation.Com_KeyImg then
        self.Com_BtnExplanation.WidgetSwitcher_0:SetActiveWidget(self.Com_BtnExplanation.Com_KeyImg)
        self.Com_BtnExplanation.Com_KeyImg:CreateCommonKey({
            KeyInfoList=
            {
                {
                    Type = "Img",
                    ImgShortPath = "Menu"
                }
            },
        })
    end
    if self.WS_Key then
        self.WS_Key:SetActiveWidgetIndex(1)
    end
    if self.MainBtn and self.MainBtn.Key_ControllerBuy then
        self.MainBtn.Key_ControllerBuy:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    end
end

function M:RefreshOpInfoByPC()
    if self.Btn_Shop_Recommend_Video and self.Btn_Shop_Recommend_Video.WS_Icon then
        self.Btn_Shop_Recommend_Video.WS_Icon:SetActiveWidget(self.Btn_Shop_Recommend_Video.Image_BtnIcon)
    end
    if self.Com_BtnExplanation and self.Com_BtnExplanation.WidgetSwitcher_0 then
        self.Com_BtnExplanation.WidgetSwitcher_0:SetActiveWidget(self.Com_BtnExplanation.Com_BtnQa)
    end
    if self.WS_Key then
        self.WS_Key:SetActiveWidgetIndex(0)
        if self.Btn_Shop_Switch and self.Btn_Shop_Switch.Btn_Click then
            self.Btn_Shop_Switch.Btn_Click.OnClicked:Remove(self, self.OnBtnSwitchClick)
            self.Btn_Shop_Switch.Btn_Click.OnClicked:Add(self, self.OnBtnSwitchClick)
        end
    end
    if self.MainBtn and self.MainBtn.Key_ControllerBuy then
        self.MainBtn.Key_ControllerBuy:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end
        
-- 更新通用底部Tab按键提示
function M:UpdateCommonTabInfo()
    local Params = {}
    -- 重播动作
    if self.BannerData.DisplayType and self.BannerData.DisplayType == "Resource" and self.BannerData.DisplayId and not self.bHasVideo then
        table.insert(Params, {
            KeyInfoList = {{Type = "Text", Text = "R", ClickCallback = self.OnRKeyDown, Owner = self}},
            GamePadInfoList = {{Type = "Img", ImgShortPath = "Y", ClickCallback = self.OnRKeyDown, Owner = self}}, Desc = GText("UI_Banner_ReplayGesture")
        })
    -- 坐骑骑乘/离开
    elseif self.BannerData.DisplayType and self.BannerData.DisplayType == "Mount" and self.BannerData.DisplayId and not self.bHasVideo then
        table.insert(Params, {
            KeyInfoList = {{Type = "Text", Text = "R", ClickCallback = self.OnRKeyDown, Owner = self}},
            GamePadInfoList = {{Type = "Img", ImgShortPath = "Y", ClickCallback = self.OnRKeyDown, Owner = self}}, Desc = GText("UI_CTL_Ride")
        })
    end
    -- 显示或隐藏UI
    table.insert(Params, {
        KeyInfoList = {{Type = "Text", Text = "U", ClickCallback = function()
                if self.Parent and self.Parent.HideUIExceptVideoAutoCallBack and self.Parent:IsAllowedToShowHideUI() then
                    self.Parent:HideUIExceptVideoAutoCallBack() 
                end
            end, Owner = self}},
        GamePadInfoList = {{Type = "Img", ImgShortPath = "X", ClickCallback = function()
                if self.Parent and self.Parent.HideUIExceptVideoAutoCallBack and self.Parent:IsAllowedToShowHideUI() then
                    self.Parent:HideUIExceptVideoAutoCallBack() 
                end
            end, Owner = self}}, Desc = GText("UI_CameraSystem_HideUI")
    })
    if self.BannerData.PreviewType and self.BannerData.PreviewId and next(self.BannerData.PreviewId) then
        table.insert(Params, {
            GamePadInfoList = {{Type = "Img", ImgShortPath = "View", ClickCallback = function()
                    self:OnBtnPreviewClick()
                end, Owner = self}}, Desc = GText("UI_Preview_Title")
        })
    end
    -- 拉远拉近 + 旋转预览
    if self.BannerData.DisplayType and (self.BannerData.DisplayId or self.BannerData.SkinSeries) and not self.bHasVideo then
        if (self.BannerData.DisplayType ~= "Weapon" and self.BannerData.DisplayType ~= "WeaponSkin" and self.BannerData.DisplayType ~= "WeaponAccessory" and self.Parent.EnableMouseWheel) then
            table.insert(Params, {
                KeyInfoList = { {Type="Text", Text = CommonUtils:GetKeyText("Mouse_Button"), Owner=self}, },
                GamePadInfoList =  { {Type="Or"}, GamePadSubKeyInfoList = { {Type="Img", ImgShortPath="LT", Owner=self}, {Type="Img", ImgShortPath="RT", Owner=self}}}, Desc = GText("UI_Dye_Zoom"), bLongPress = false
            })
        end
        if self.Parent.EnableDrag then
            table.insert(Params, {
                GamePadInfoList =  {{Type="Img", ImgShortPath="RH",}}, Desc = GText("UI_CTL_RotatePreview"),
            })
        end
    end
    -- 核心操作
    table.insert(Params, {
        KeyInfoList = {{Type = "Text", Text = "Space", ClickCallback = self.MainBtnClickFunc, Owner = self}},
        -- GamePadInfoList = {{Type = "Img", ImgShortPath = "A", ClickCallback = self.MainBtnClickFunc, Owner = self}}, 
        Desc = self.MainBtnTextStr or GText("UI_SHOP_PURCHASE")
    })
    -- B返回
    table.insert(Params, {
        KeyInfoList = {{Type = "Text", Text = "Esc", ClickCallback = self.CloseSelf, Owner = self}},
        GamePadInfoList = {{Type = "Img", ImgShortPath = "B", ClickCallback = self.CloseSelf, Owner = self}}, Desc = GText("UI_BACK")
    })

    if self.Parent and self.Parent.UpdateCommonTabInfo then
        self.Parent:UpdateCommonTabInfo(Params)
    end
end

function M:HandlePreviewKeyDown(InKey, InKeyName)
    print("lgc@WBP_Shop_Recommend_Common HandlePreviewKeyDown", InKeyName)
    if InKeyName == "SpaceBar" or InKeyName == Const.GamepadFaceButtonDown then
        if self.MainBtnClickFunc then
            self.MainBtnClickFunc(self)
            return true
        end
    end
    return false
end

function M:HandleKeyDown(InKey, InKeyName)
    print("lgc@WBP_Shop_Recommend_Common HandleKeyDown", InKeyName)
    if InKeyName == "R" or InKeyName == Const.GamepadFaceButtonUp then
        if self.BannerData.DisplayId and self.BannerData.DisplayType and (self.BannerData.DisplayType == "Resource" or self.BannerData.DisplayType == "Mount") then
            self:OnRKeyDown()
            return true
        end
    elseif InKeyName == Const.GamepadLeftThumbstick then
        if self.BannerData.DisplayType and self.BannerData.DisplayType == "WeaponAccessory" then
            self:OnBtnSwitchClick()
            return true
        end
    elseif InKeyName == "U" or InKeyName == Const.GamepadFaceButtonLeft then
        if self.Parent and self.Parent.HideUIExceptVideoAutoCallBack and self.Parent:IsAllowedToShowHideUI() then
            self.Parent:HideUIExceptVideoAutoCallBack() 
        end
        return true
    elseif InKeyName == Const.GamepadSpecialRight and self.BannerData.Text2EntryText and self.BannerData.Text2 then
        self:OnBtnExplanationClick()
        return true
    elseif InKeyName == Const.GamepadSpecialLeft then
        local bHasVideo = self.BannerData.BgVideoPath and self.BannerData.BgVideoPath ~= ""

        local BannerData = self.BannerData
        local bIsValidPreview = (BannerData.PreviewType == "SkinSeries") or (BannerData.PreviewType and BannerData.PreviewId and next(BannerData.PreviewId))
        if self.Parent and not self.Parent:SetHasVideo(bHasVideo) and bIsValidPreview then
            self:OnBtnPreviewClick()
            return true
        end
    end

    return false
end

function M:HandleRepeatKeyDown(InKey, InKeyName)
    local IsEventHandled = false
    if InKeyName == UIConst.GamePadKey.LeftTriggerThreshold then
        if self.Parent and self.Parent.OnCameraScrollBackwardKeyDown then
            self.Parent:OnCameraScrollBackwardKeyDown()
            IsEventHandled = true
        end
    elseif InKeyName == UIConst.GamePadKey.RightTriggerThreshold then
        if self.Parent and self.Parent.OnCameraScrollForwardKeyDown then
            self.Parent:OnCameraScrollForwardKeyDown()
            IsEventHandled = true
        end
    end
    return IsEventHandled
end

return M
