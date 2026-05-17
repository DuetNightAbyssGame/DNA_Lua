--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_GuildWar_GroupConfirm_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Super.Construct(self)
    self.List_Reward.OnCreateEmptyContent:Bind(self, self.CreateAndAddEmptyItem)
    self.Btn_Click.OnClicked:Add(self,function ()
        self:PlayAnimation(self.Out)
    end)
    self:AddInputMethodChangedListen()
end

function M:Init()

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local CurrentRaidSeasonId = Avatar.CurrentRaidSeasonId
    local RaidSeasons = Avatar.RaidSeasons[CurrentRaidSeasonId]
    local RaidSeasonData = DataMgr.RaidSeason[RaidSeasons.RaidSeasonId]

    local PreRaidRankData = DataMgr.PreRaidRank[RaidSeasonData.PreRaidRank]
    if not PreRaidRankData then
        DebugPrint("[WBP_Activity_GuildWar_GroupConfirm_C] 找不到对应的 PreRaidRankData:", RaidSeasonData.PreRaidRank)
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/activity/gerengonghuizhan_rank_group_panel", "GuildWar_GroupConfirm", nil)
    local RankReward = PreRaidRankData.RankReward[RaidSeasons.PreRaidGroupId]
    self:RefreshRewardInfoList(RankReward)
    local RankIcon = self["Rank_" .. RaidSeasons.PreRaidGroupId]
    if RankIcon then
        local IconDynaMaterial = self.Icon_Rank:GetDynamicMaterial()
        if IconDynaMaterial then
            IconDynaMaterial:SetTextureParameterValue("MainTex", RankIcon)
        end
        --self.Icon_Rank:SetBrush(RankIcon)
    end
    self.Text_Confirm:SetText(GText("RaidDungeon_PreRaid_Comfim"))
    self.Text_Tip:SetText(GText("UI_Armory_ClickEmpty"))
    self.List_Reward:NavigateToIndex(0)
    self:PlayAnimation(self.In)

    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self.WS_Type:SetActiveWidgetIndex(1)
        self:UpdatKeyDisplay()
    else
        self.WS_Type:SetActiveWidgetIndex(0)
    end

    self.Text_GetReward:SetText(GText("RaidDungeon_PreRaid_RewardTips"))
end

-- 更新奖励信息列表
---@param RankReward number[] @奖励Id列表[Reward]
function M:RefreshRewardInfoList(RankRewardID)

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    local Rewards = DataMgr.Reward[RankRewardID]
    if Rewards then
        self.RewardList = {}
        local RewardIds = Rewards.Id
        local RewardCounts = Rewards.Count
        local RewardTypes = Rewards.Type
        for i = 1, #RewardIds do
            local ItemId = RewardIds[i]
            local Count = RewardUtils:GetCount(RewardCounts[i])
            local Icon = ItemUtils.GetItemIcon(ItemId, RewardTypes[i])
            local Rarity = ItemUtils.GetItemRarity(ItemId, RewardTypes[i])
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
            local Content = NewObject(UIUtils.GetCommonItemContentClass())
            Content.Id = ItemInfo.Id
            Content.Icon = ItemUtils.GetItemIconPath(ItemInfo.Id, ItemInfo.Type)
            Content.ParentWidget = self
            Content.ItemType = ItemInfo.Type
            Content.Count = ItemInfo.ItemCount
            Content.Rarity = ItemInfo.Rarity or 1
            Content.IsShowDetails = true
            -- 处理数量信息
            if ItemInfo.Quantity then
                Content.Count = ItemInfo.Quantity[1]
                Content.MaxCount = ItemInfo.Quantity[2] or nil
            end
            self.List_Reward:AddItem(Content)
        end
    end
    
    if self:IsExistTimer(self.NextFrameListEmpty) then
        self:RemoveTimer(self.NextFrameListEmpty)
    end
    
    --- 用空Item补全ListView, 加定时器是因为隔一帧才能拿到已生成的Entry
    self.NextFrameListEmpty = self:AddTimer(0.01, function()

        local len = self.List_Reward:GetNumItems()
        for i = 1, len do
            local entryWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Reward, i - 1)
            if entryWidget then
                entryWidget:BindEvents(self, {
                    OnMenuOpenChanged = self.OnStuffMenuOpenChanged,
                })
            end
        end

        self.List_Reward:RequestFillEmptyContent()
    end, false, 0, "GuildWar_RewardItem")
end

function M:OnStuffMenuOpenChanged(bIsOpen)
    if (UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad) then
        return
    end
    if (bIsOpen) then
        self.WS_Type:SetActiveWidgetIndex(0)
    else
        self.WS_Type:SetActiveWidgetIndex(1)
    end
end


function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadDown(InKeyName)
    end
    if (IsEventHandled) then
        return UWidgetBlueprintLibrary.Handled()
    else
        return UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:OnGamePadDown(InKeyName)
    local IsEventHandled = false
    if InKeyName == "Gamepad_FaceButton_Right" then
        self:PlayAnimation(self.Out)
        IsEventHandled = true
    end
    return IsEventHandled
end

-- 更新按键显示
function M:UpdatKeyDisplay(FocusTypeName)
    if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
        return
    end
    self.Key_Close:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Key_Close:CreateCommonKey({
        KeyInfoList = {
            { Type = "Img", ImgShortPath = "B" }
        }
        ,
        Desc = GText("UI_BACK")
    })

    self.Key_Check:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Key_Check:CreateCommonKey({
        KeyInfoList = {
            { Type = "Img", ImgShortPath = "A" }
        }
        ,
        Desc = GText("UI_Controller_CheckDetails")
    })

end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end
    -- if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
    --     self.Parent.WBox_Controller:SetVisibility(ESlateVisibility.Collapsed)
    -- else
    --     self.Parent.WBox_Controller:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    -- end
    --- 输入设备切换通知
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if not IsUseKeyAndMouse and (self:HasFocusedDescendants() or self:HasAnyUserFocus()) then
        self.WS_Type:SetActiveWidgetIndex(1)
        self:UpdatKeyDisplay()
    else
        self.WS_Type:SetActiveWidgetIndex(0)
        -- if self.Image_Select and self.Image_Select:GetRenderOpacity() > 0 then
        --     self:PlayAnimation(self.UnHover)
        -- end
    end
end

function M:CreateAndAddEmptyItem()
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Id = 0
    return Content
end

function M:OnReturnKeyDown()
    AudioManager(self):SetEventSoundParam(self, "GuildWar_GroupConfirm", {ToEnd = 1})
    self.Super.Close(self)
    local Item = UIManager(self):GetUIObj("GuildWarLevel")
    if Item then
        Item:SelectCellFocus()
    end
    -- if not self:IsAnimationPlaying(self.Out) then
    --     self:SetVisibility(ESlateVisibility.HitTestInvisible)
    --     self:PlayAnimation(self.Out) 
    -- end
end

function M:OnAnimationFinished(InAnimation)
    -- self:PlayAnimation(self.Out)
    if InAnimation == self.Out then
        self:OnReturnKeyDown()
    end
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M
