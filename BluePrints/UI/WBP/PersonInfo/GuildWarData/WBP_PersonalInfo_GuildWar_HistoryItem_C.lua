require "UnLua"
local ChatController = require "BluePrints.UI.WBP.Chat.ChatController"
local FriendController = require "BluePrints.UI.WBP.Friend.FriendController"
local FriendModel = FriendController:GetModel()
local PersonInfoController = require "BluePrints.UI.WBP.PersonInfo.PersonInfoController"
local GuildWarUtils = require "BluePrints.UI.WBP.Activity.Widget.GuildWar.GuildWarUtils"

local M = Class("BluePrints.UI.BP_EMUserWidget_C")

local RankIconPath = {
    "Texture2D'/Game/UI/Texture/Static/Atlas/Activity/GuildWar/T_Activity_GuildWar_PatternRanking_1.T_Activity_GuildWar_PatternRanking_1'",
    "Texture2D'/Game/UI/Texture/Static/Atlas/Activity/GuildWar/T_Activity_GuildWar_PatternRanking_2.T_Activity_GuildWar_PatternRanking_2'",
    "Texture2D'/Game/UI/Texture/Static/Atlas/Activity/GuildWar/T_Activity_GuildWar_PatternRanking_3.T_Activity_GuildWar_PatternRanking_3'",
}
local RankPatternPath = {
    "Texture2D'/Game/UI/Texture/Static/Image/Activity/GuildWar/T_Activity_GuideWar_PatternRanking_L_1.T_Activity_GuideWar_PatternRanking_L_1'",
    "Texture2D'/Game/UI/Texture/Static/Image/Activity/GuildWar/T_Activity_GuideWar_PatternRanking_L_2.T_Activity_GuideWar_PatternRanking_L_2'",
    "Texture2D'/Game/UI/Texture/Static/Image/Activity/GuildWar/T_Activity_GuideWar_PatternRanking_L_3.T_Activity_GuideWar_PatternRanking_L_3'"
}

-- 分组赛等级图片映射
local GroupRankTexturePath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/GuildWar/T_Activity_GuildWar_Rank_%s.T_Activity_GuildWar_Rank_%s'"
local GroupRankMap = {
    [1] = "SSS",
    [2] = "SS",
    [3] = "S",
    [4] = "A",
    [5] = "B",
    -- 根据实际需求添加更多等级
}

function M:Construct()
    self.RankIconTexture = {}
    for Index, Path in ipairs(RankIconPath) do
        local Texture = LoadObject(RankIconPath[Index])
        table.insert(self.RankIconTexture, Texture)
    end
    self.RankPatternTexture = {}
    for Index, Path in ipairs(RankPatternPath) do
        local Texture = LoadObject(RankPatternPath[Index])
        table.insert(self.RankPatternTexture, Texture)
    end
    
    if self.Head_Player then
        self.Head_Player:BindOnClickEvent(function()
            if self.Head_Anchor then
                self.Head_Anchor:Open(true)
            end
            if self.ParentWidget and self.ParentWidget.OnListRankItemClicked then
                self.ParentWidget:OnListRankItemClicked(self.Content)
            end
        end)
    end
    
    if self.Head_Anchor then
        self.Head_Anchor.OnGetMenuContentEvent:Bind(self, self.OnAnchorGetUserMenuContent)
        self.Head_Anchor.OnMenuOpenChanged:Add(self, self.HeadMenuOpenChanged)
    end
    
    self:SetNavigationRuleBase(UE4.EUINavigation.Left, EUINavigationRule.Stop)
    self:SetNavigationRuleBase(UE4.EUINavigation.Right, EUINavigationRule.Stop)
end

function M:Destruct()
    if self.Head_Anchor then
        self.Head_Anchor.OnGetMenuContentEvent:Unbind()
        self.Head_Anchor.OnMenuOpenChanged:Remove(self, self.HeadMenuOpenChanged)
    end
end

function M:OnListItemObjectSet(Content)
    Content.SelfWidget = self
    self.Content = Content
    self.RankInfo = Content.RankInfo
    self.SelfAvatar = Content.SelfAvatar
    self.ParentWidget = self.Content.ParentWidget
    
    if not Content.Empty then
        if self.WS_Type then
            self.WS_Type:SetActiveWidgetIndex(0)
        end
        self:InitPlayerRank()
        self:InitPlayerInfo()
        self:InitPlayerPoint()
        self:InitPlayerSquad()
        self:InitGroupRank() -- 新增：初始化分组等级
        self:InitRecordTime() -- 新增：初始化记录时间
        
        -- 滑动时恢复动画
        if self.ParentWidget and self.ParentWidget.LastClickedItem == Content then
            if self.Click then self:PlayAnimation(self.Click) end
        else
            if self.Normal then self:PlayAnimation(self.Normal) end
        end
    else
        if self.WS_Type then
            self.WS_Type:SetActiveWidgetIndex(1)
        end
    end

    self:SetNavigationRuleCustom(EUINavigation.Up, {self, self.HandleNavigationUp})
    self:SetNavigationRuleCustom(EUINavigation.Down, {self, self.HandleNavigationDown})
end

function M:BP_OnEntryReleased()
    self.Content.SelfWidget = nil
    if self.Normal then
        self:PlayAnimation(self.Normal)
    end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if self.ParentWidget and self.ParentWidget.OnListRankItemClicked then
        self.ParentWidget:OnListRankItemClicked(self.Content)
    end
    return UIUtils.Handled
end

function M:HandleNavigationUp()
    if not self.RankInfo or not self.RankInfo.RankNum  then
        return
    end

    local CurIndex = self.RankInfo.RankNum - 1
    local MinIndex = 0
    if CurIndex  > MinIndex then
        self.ParentWidget.List_Ranking:NavigateToIndex(CurIndex - 1)
    end
end

function M:HandleNavigationDown()
    if not self.RankInfo or not self.RankInfo.RankNum  then
        return
    end

    local CurIndex = self.RankInfo.RankNum - 1
    local MaxIndex = self.ParentWidget.ValidItemNum - 1
    if CurIndex  < MaxIndex then
        self.ParentWidget.List_Ranking:NavigateToIndex(CurIndex + 1)
    end
end

-- 初始化排名
function M:InitPlayerRank()
    -- 封禁文本处理
    local BanState = self.RankInfo.BanState
    if BanState and BanState ~= 0 then
        if self.Text_Ranking then self.Text_Ranking:SetText(GText("RaidDungeon_Rank_Ban")) end
        if self.Image_RankIcon then self.Image_RankIcon:SetVisibility(UIConst.VisibilityOp.Collapsed) end
        if self.Image_RankPattern then self.Image_RankPattern:SetVisibility(UIConst.VisibilityOp.Collapsed) end
        return
    end

    local RankNum = self.RankInfo.RankNum
    local DisplayRank = self.RankInfo.DisplayRank or RankNum
    if not RankNum then
        return
    end
    
    -- 前三名特殊标志
    if DisplayRank and DisplayRank >= 1 and DisplayRank <= 3 then
        if self.Image_RankIcon then
            self.Image_RankIcon:SetVisibility(UIConst.VisibilityOp.Visible)
            self.Image_RankIcon:SetBrushFromTexture(self.RankIconTexture[DisplayRank])
        end
        if self.Image_RankPattern then
            self.Image_RankPattern:SetVisibility(UIConst.VisibilityOp.Visible)
            self.Image_RankPattern:SetBrushFromTexture(self.RankPatternTexture[DisplayRank])
        end
    else
        if self.Image_RankIcon then self.Image_RankIcon:SetVisibility(UIConst.VisibilityOp.Collapsed) end
        if self.Image_RankPattern then self.Image_RankPattern:SetVisibility(UIConst.VisibilityOp.Collapsed) end
    end
    
    if self.Text_Ranking then
        if DisplayRank and DisplayRank > 0 then
            self.Text_Ranking:SetText(DisplayRank)
        else
            self.Text_Ranking:SetText(GText("RaidDungeon_Rank_Empty"))
        end
    end
end

-- 初始化玩家个人信息
function M:InitPlayerInfo()
    if not self.RankInfo then
        return
    end

    -- 头像
    if self.Head_Player then
        if self.RankInfo.HeadIconId then
            self.Head_Player:SetHeadIconById(self.RankInfo.HeadIconId)
        end
        -- 头像框
        if self.RankInfo.HeadFrameId then
            self.Head_Player:SetHeadFrame(self.RankInfo.HeadFrameId)
        end
    end
    
    -- 等级
    if self.Text_Level then
        self.Text_Level:SetText(tostring(self.RankInfo.Level))
    end
    
    -- 名字
    if self.Text_Name then
        self.Text_Name:SetText(GText(self.RankInfo.Nickname or ""))
    end

    -- 称号
    if self.WS_Title then
        local IsNilFrame = (self.RankInfo.TitleBefore == nil) and (self.RankInfo.TitleAfter == nil)
        local IsEmptyFrame = (self.RankInfo.TitleBefore < 0) and (self.RankInfo.TitleAfter < 0) 
        if IsNilFrame or IsEmptyFrame then
            self.WS_Title:SetActiveWidgetIndex(1)
        else
            self.WS_Title:SetActiveWidgetIndex(0)
            local TitleFrame = self.RankInfo.TitleFrame
            if not TitleFrame or TitleFrame < 0 then
                TitleFrame = 10001
            end
            if self.Overlay_Title then
                self.Overlay_Title:ClearChildren()
                local TitleFrameWidget = UIManager(self):LoadTitleFrameWidget(TitleFrame)
                if TitleFrameWidget then
                    self.Overlay_Title:AddChildToOverlay(TitleFrameWidget)
                    TitleFrameWidget:SetTitleContent(self.RankInfo.TitleBefore, self.RankInfo.TitleAfter)
                end
            end
        end
    end
end

-- 初始化玩家分数
function M:InitPlayerPoint()
    if not self.Text_Score then return end
    local Score = self.RankInfo.Score
    if Score then
        self.Text_Score:SetText(Score)
    else
        self.Text_Score:SetText("--")
    end
end

-- 初始化角色阵容
function M:InitPlayerSquad()
    local RoleInfo = self.Content.RoleInfo
    local PetInfo = self.Content.PetInfo
    
    if not RoleInfo and not PetInfo then
        DebugPrint("WBP_PersonalInfo_GuildWar_HistoryItem_C: InitPlayerSquad No RoleInfo or PetInfo")
    end

    -- 设置角色
    for Index=1, 4 do
        local CharSlotWidget = self["Slot_0" .. Index]
        if CharSlotWidget then
            local Info = nil
            local IconPath = nil

            if Index <= 3 then  -- 1~3号角色数据
                Info = RoleInfo and RoleInfo[Index]
                local Char = Info and DataMgr.Char[Info.id]
                IconPath = Char and Char.Icon
                if Info and not Char then
                    DebugPrint("WBP_PersonalInfo_GuildWar_HistoryItem_C: Char not found for id:", Info.id)
                end
            else  -- 4号宠物
                Info = PetInfo
                local Pet = Info and DataMgr.Pet[Info.id]
                IconPath = Pet and Pet.GachaIcon
                if Info and not Pet then
                    DebugPrint("WBP_PersonalInfo_GuildWar_HistoryItem_C: Pet not found for id:", Info.id)
                end
            end

            if Info and IconPath then
                local ImageIcon = LoadObject(IconPath)
                local ImgMaterial = CharSlotWidget.Img_Avatar:GetDynamicMaterial()
                if ImageIcon and ImgMaterial then
                    ImgMaterial:SetTextureParameterValue("IconMap", ImageIcon)
                end
                CharSlotWidget.Text_Level:SetText(Info.level or 1)
                CharSlotWidget.Switch_Type:SetActiveWidget(CharSlotWidget.Img_Avatar)
                CharSlotWidget.Panel_Level:SetVisibility(UIConst.VisibilityOp.Visible)
            else
                CharSlotWidget.Switch_Type:SetActiveWidget(CharSlotWidget.Empty)
                CharSlotWidget.Panel_Level:SetVisibility(UIConst.VisibilityOp.Collapsed)
            end
        else
            DebugPrint("WBP_PersonalInfo_GuildWar_HistoryItem_C: Slot widget not found: Slot_0" .. Index)
        end
    end
end

-- 新增：初始化分组等级
function M:InitGroupRank()
    if not self.Image_Rank then return end
    
    -- 获取分组ID，这里假设字段为 PreRaidGroupId
    local GroupId = self.RankInfo.PreRaidGroupId
    local RankStr = GroupRankMap[GroupId]
    
    DebugPrint("WBP_PersonalInfo_GuildWar_HistoryItem_C: InitGroupRank GroupId:", GroupId, "RankStr:", RankStr)

    if RankStr then
        local Path = string.format(GroupRankTexturePath, RankStr, RankStr)
        local Texture = LoadObject(Path)
        if Texture then
            self.Image_Rank:SetBrushFromTexture(Texture)
            self.Image_Rank:SetVisibility(UIConst.VisibilityOp.Visible)
        else
            DebugPrint("WBP_PersonalInfo_GuildWar_HistoryItem_C: Failed to load texture:", Path)
            self.Image_Rank:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    else
        self.Image_Rank:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

-- 新增：初始化记录时间
function M:InitRecordTime()
    if not self.Text_Time then return end
    
    local UpdateTime = self.RankInfo.UpdateTime
    if UpdateTime and UpdateTime > 0 then
        -- 假设 UpdateTime 是秒级时间戳
        local DateStr = os.date("%Y-%m-%d", UpdateTime)
        self.Text_Time:SetText(DateStr)
    else
        self.Text_Time:SetText("--")
    end
end

function M:OnAnchorGetUserMenuContent()
    if not self.RankInfo then
        return nil
    end
    
    local Context = {
        Uid = self.RankInfo.Uid,
        Nickname = self.RankInfo.Nickname,
        Level = self.RankInfo.Level,
        HeadIconId = self.RankInfo.HeadIconId,
        HeadFrameId = self.RankInfo.HeadFrameId,
    }
    
    return PersonInfoController:GetAnchorUserMenuContent(Context)
end

function M:HeadMenuOpenChanged(bIsOpen)
    if self.Head_Anchor then
        if bIsOpen then
            self.Head_Anchor:Open(true)
        else
            self.Head_Anchor:Close()
        end
    end
end

return M
