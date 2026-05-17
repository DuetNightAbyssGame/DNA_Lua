--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_GuildWar_InsideBoard_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end


function M:Construct()
    self.Super.Construct(self)
    self:AddDispatcher(EventID.OnPreRaidRankInfo, self, self.OnPreRaidRankInfo)
    self:AddDispatcher(EventID.OnRaidRankInfo, self, self.OnRaidRankInfo)
    self.Btn_Check.Btn_Click.OnClicked:Add(self, self.OpenGuildWarRewardPop)
    self.UpdateInsideBoardTime = 60
end

function M:Destruct()
    self.Super.Destruct(self)
    self:ClearUpdateTimer()
end

-- 初始化
function M:Init()
    if not self.Avatar then
        self.Avatar = GWorld:GetAvatar()
        if not self.Avatar then
            return
        end
    end
    self.bAnimation = true
    self:UpdateSeasonData()
    self:ClearUpdateTimer()
    self:TryRaidSeasonRankInfo()

    self.Text_Highest:SetText(GText("RaidDungeon_Max_Point"))
    if self.RaidSeasons:IsPreRaidTime() then
        self.Text_Standard:SetText(GText("RaidDungeon_NextRank_Point"))
        self.Text_Type:SetText(GText("RaidDungeon_PreRaid_Rank"))
        self.Panel_RewardBtn:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Text_Reward:SetText(GText("UI_Event_MidTerm_GotoPreview"))
    elseif self.RaidSeasons:IsRaidTime() then
        self.Panel_RewardBtn:SetVisibility(ESlateVisibility.Collapsed)
        self.Text_Standard:SetText(GText("RaidDungeon_Raid_Rank_Title"))
        self.Text_Type:SetText(GText("RaidDungeon_Raid_Rank"))
    end

    self.UpdateInsideBoardTimer = self:AddTimer(
        self.UpdateInsideBoardTime,
        self.TryRaidSeasonRankInfo,
        true, 0, "UpdateGuildWar_InsideBoard", true
    )
end

function M:TryRaidSeasonRankInfo()
    -- DebugPrint("TryRaidSeasonRankInfo   1  ",self.RaidSeasons:IsPreRaidTime())
    -- DebugPrint("TryRaidSeasonRankInfo   2  ",self.RaidSeasons:IsRaidTime())
    if self.RaidSeasons:IsPreRaidTime() then
        self.Avatar:RaidSeasonGetPreRaidRankInfo()
    elseif self.RaidSeasons:IsRaidTime() then
        self.Avatar:RaidSeasonGetRaidRankInfo()
    end
end
 
-- 更新赛季数据
function M:UpdateSeasonData()
    if not self.Avatar then return end
    self.CurrentRaidSeasonId = self.Avatar.CurrentRaidSeasonId
    self.RaidSeasons = self.Avatar.RaidSeasons[self.CurrentRaidSeasonId]
    self.RaidSeasonData = DataMgr.RaidSeason[self.RaidSeasons.RaidSeasonId]
    self.PreRaidRankData = DataMgr.PreRaidRank[self.RaidSeasonData.PreRaidRank]
end

-- 清理计时器
function M:ClearUpdateTimer()
    if self:IsExistTimer(self.UpdateInsideBoardTimer) then
        self:RemoveTimer(self.UpdateInsideBoardTimer)
        self.UpdateInsideBoardTimer = nil
    end
end

-- 刷新UI显示
function M:UpdateShow()
    self:UpdateSeasonData()
    local Season = self.RaidSeasons
    if not Season then return end

    -- 默认显示
    self.WS_Rank:SetActiveWidgetIndex(0)

    --占位置判断是否被封禁 
    ---------------------------------
    local RankIcon = nil
    if Season:IsPreRaidTime() then     
        if Season.BanState == 1 then  ---预选赛期间  被封禁 隐藏晋级积分 面板显示Ban沙漏 显示封禁文本
            self.Panel_Tip01:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.Panel_Ban:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.WS_Rank:SetActiveWidgetIndex(2)
            self.Text_Ban:SetText(GText("RaidDungeon_Rank_Ban"))
            self.Text_Tip01:SetText(GText("RaidDungeon_Rank_Empty"))
            self.Panel_RewardBtn:SetVisibility(ESlateVisibility.Collapsed)
        else
            self.Panel_Tip01:SetVisibility(ESlateVisibility.Collapsed)
            self.Panel_Ban:SetVisibility(ESlateVisibility.Collapsed)
            self.Panel_RewardBtn:SetVisibility(ESlateVisibility.SelfHitTestInvisible)

            if Season.MaxPreRaidScore == 0 then   ---预选赛期间  没打过 隐藏晋级积分 面板显示沙漏
                self.WS_Rank:SetActiveWidgetIndex(1)
                self.WS_Row01:SetVisibility(ESlateVisibility.Collapsed)
            else
                self.WS_Rank:SetActiveWidgetIndex(0)
                if  self.RankInfo.PreRaidGroupId == 1 then    ---预选赛期间  最高积分 隐藏晋级积分
                    self.WS_Row01:SetVisibility(ESlateVisibility.Collapsed)
                else
                    self.WS_Row01:SetActiveWidgetIndex(0)     ---预选赛期间  显示晋级积分
                    self.Text_Num:SetText(self.RankInfo and self.RankInfo.NextScore or 0)
                    self.WS_Row01:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
                end
            end
        end

        RankIcon = self["Rank_" .. self.RankInfo.PreRaidGroupId]
        
    elseif Season:IsRaidTime() then
        if Season.BanState == 1 then   --预选赛被封禁 显示Ban沙漏 显示提示文本隐藏晋级积分 显示封禁文本
            self.Panel_Tip01:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.Panel_Ban:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.WS_Rank:SetActiveWidgetIndex(2)
            self.WS_Row01:SetActiveWidgetIndex(1)
            self.WS_Row02:SetActiveWidgetIndex(0)
            self.Text_Ban:SetText(GText("RaidDungeon_Rank_Ban"))
            self.Text_Tip01:SetText(GText("RaidDungeon_Rank_Empty"))
            self.Text_Tip02:SetText(GText("RaidDungeon_PreRaid_Reward"))
        else
            self.Panel_Ban:SetVisibility(ESlateVisibility.Collapsed)
            if Season.MaxPreRaidScore == 0 then  --正式赛 没参加预选赛or被封禁 显示沙漏 显示提示文本隐藏晋级积分
                self.Panel_Tip01:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
                self.WS_Rank:SetActiveWidgetIndex(1)
                self.WS_Row01:SetActiveWidgetIndex(1)
                self.WS_Row02:SetActiveWidgetIndex(0)
                self.Text_Tip01:SetText(GText("RaidDungeon_PreRaid_Abandon"))
                self.Text_Tip02:SetText(GText("RaidDungeon_PreRaid_Reward"))
            else
                self.Panel_Tip01:SetVisibility(ESlateVisibility.Collapsed)  --正式赛 参加了预选赛 显示晋级积分
                self.WS_Row01:SetActiveWidgetIndex(0)
                self.WS_Row02:SetActiveWidgetIndex(0)
                self.Text_Num:SetText(self.Rank or GText("UI_CHAR_FORCE_1101"))
                self.WS_Rank:SetActiveWidgetIndex(0)
                if self.bAnimation then
                    AudioManager(self):PlayUISound(self, "event:/ui/activity/gerengonghuizhan_add_rank", nil, nil)
                    self:PlayAnimation(self.Ranking_Up)
                end
    
            end
        end

        DebugPrint("Season.PreRaidGroupId  "..Season.PreRaidGroupId)
        RankIcon = self["Rank_" ..  Season.PreRaidGroupId]
    end
    -- 根据阶段刷新显示
    local ScoreText = (Season:IsPreRaidTime()) and Season.MaxPreRaidScore or Season.MaxRaidScore

    if RankIcon then
        --self.Icon_Rank:SetBrush(RankIcon)
        local IconDynaMaterial = self.Icon_Rank:GetDynamicMaterial()
        if IconDynaMaterial then
            IconDynaMaterial:SetTextureParameterValue("MainTex", RankIcon)
        end
        if self.bAnimation then
            AudioManager(self):PlayUISound(self, "event:/ui/activity/gerengonghuizhan_add_level", nil, nil)
            self:PlayAnimation(self.Rank_Up)
        end
    end
    self.Text_Score:SetText(ScoreText)
    self.bAnimation = false
end

-- 回调事件
function M:OnPreRaidRankInfo(RankInfo)
    self.RankInfo = RankInfo
    self:UpdateShow()
end

function M:OnRaidRankInfo(RankInfo)
    self.Rank = RankInfo.Rank or -1
    self:UpdateShow()
end

function M:OpenGuildWarRewardPop()
    local GuildWarRewardPop = UIManager(self):LoadUINew("GuildWarRewardPop")
    GuildWarRewardPop:Init()
end

return M
