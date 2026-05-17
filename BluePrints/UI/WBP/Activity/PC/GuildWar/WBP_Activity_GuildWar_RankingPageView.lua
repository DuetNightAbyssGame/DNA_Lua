require "UnLua"

local ActorController = require "BluePrints.UI.WBP.Armory.ActorController.Armory_ActorController"
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
local GuildWarUtils = require "BluePrints.UI.WBP.Activity.Widget.GuildWar.GuildWarUtils"

local M = Class{}

function M:OnLoaded(...)
    self.SelfRankInfo, self.TopNInfo = ...
    self.IsFirstOpen = true

    PrintTable(self.SelfRankInfo,5, "工会战-玩家个人全数据")
    PrintTable(self.TopNInfo,5, "工会战-排行榜全部数据")

    self:InitOnGetTopN(self.TopNInfo)
    self:InitRankInfoSelf(self.SelfRankInfo)
    self:InitView()

    -- 客户端测试代码，与TopN初始化互斥
    -- self:TestTopN()
end

function M:Construct()
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    if (IsValid(self.GameInputModeSubsystem))then
        local CurInputDevice = self.GameInputModeSubsystem:GetCurrentInputType()
        self.IsGamePad = (CurInputDevice == ECommonInputType.Gamepad)
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice) 
    end
    self.Avatar = GWorld:GetAvatar()
end

function M:Destruct()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice) 
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    self.IsGamePad = (CurInputDevice == ECommonInputType.Gamepad)
    if self.IsGamePad and self.LastClickedItem and UIUtils.HasAnyFocus(self) then
        local LastItem = self.LastClickedItem
        self.List_Ranking:NavigateToIndex(LastItem.RankInfo.RankNum - 1)
    end
end

function M:InitView()
    self.Text_Title:SetText(GText("RaidDungeon_Raid_Rank"))
    self.Text_Ranking:SetText(GText("RaidDungeon_Rank"))
    self.Text_Name:SetText(GText("RaidDungeon_Rank_Name"))
    self.Text_Score:SetText(GText("RaidDungeon_Max_Point_Rank"))
    self.Text_Team:SetText(GText("RaidDungeon_Rank_CharList"))

    -- 初始化Tab
    self:InitCommonTab()
end

-- 初始化TopN信息
function M:InitOnGetTopN(TopNInfo)
    -- 初始化预览场景
    self:InitPreviewScene(TopNInfo)

    -- TOPN列表
    if not TopNInfo or GuildWarUtils.IsEmptyTable(TopNInfo) then
        -- 无数据时清空列表
        self.List_Ranking:ClearListItems()
        DebugPrint("公会战排行榜，无数据时清空列表 ", self:GetUIConfigName())
    else -- TopN的赛季数据
        self:InitRankInfoTopN(TopNInfo)
    end
end

-- 初始化预览场景
function M:InitPreviewScene(TopNInfo)
    local WeaponModel
    -- 如果没TopN数据，用玩家自己的
    if GuildWarUtils.IsEmptyTable(TopNInfo) 
    or (TopNInfo[1].MaxSquad == nil) or (TopNInfo[1].MaxSquad == "") then
        self.ActorController = ActorController:New({
            ViewUI = self,
            IsPreviewMode = true,
            Char = self.Avatar.Chars[self.Avatar.CurrentChar],
            EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
        })
        WeaponModel = self.Avatar.Weapons[self.Avatar.MeleeWeapon]
    else -- 第一名数据
        local DummyAvatar = self:CreateDummyAvatarByRankInfo(TopNInfo[1])
        local _, CharModel = next(DummyAvatar.Chars)
        self.ActorController = ActorController:New({
            ViewUI = self,
            IsPreviewMode = true,
            Char = CharModel,
            Avatar = DummyAvatar,
            EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
        })
        local _, Weapon = next(DummyAvatar.Weapons)
        WeaponModel = Weapon
    end

    self.ActorController:OnOpened()
    if WeaponModel then
        self.ActorController:ChangeWeaponModel(WeaponModel)
        local Tag = WeaponModel:IsMelee() and "Melee" or "Ranged"
        self.ActorController:SetMontageAndCamera("Weapon",Tag)
    end
end

function M:CreateDummyAvatarByRankInfo(RankInfo)
    if not RankInfo then
        return
    end

    local Squad = SerializeUtils:UnSerialize(RankInfo.MaxSquad)
    if not Squad or GuildWarUtils.IsEmptyTable(Squad) then
        return
    end

    local CharacterInfo = Squad.AvatarInfo and Squad.AvatarInfo.CharacterInfo
    if not CharacterInfo then
        return
    end

    if GuildWarUtils.IsEmptyTable(CharacterInfo.RoleInfo) 
    or GuildWarUtils.IsEmptyTable(CharacterInfo.MeleeWeapon) then
        return
    end

    local DummyAvatar = {}
    local Params = {
        CharInfos = {CharacterInfo.RoleInfo},
        WeaponInfos = {CharacterInfo.MeleeWeapon}
    }
    ArmoryUtils._CreateDummyAvatarCustom(DummyAvatar, Params)
    return DummyAvatar
end

-- 切换预览角色
function M:SetRankingPlayerPreview(RankInfo)
    if not self.ActorController or not RankInfo then
        return
    end

    local DummyAvatar = self:CreateDummyAvatarByRankInfo(RankInfo)
    if DummyAvatar then
        local _, CharModel = next(DummyAvatar.Chars)
        local _, WeaponModel = next(DummyAvatar.Weapons)
        local Tag = WeaponModel:IsMelee() and "Melee" or "Ranged"
        self.ActorController:SetAvatar(DummyAvatar)
        self.ActorController:ChangeCharModel(CharModel)
        self.ActorController:ChangeWeaponModel(WeaponModel)
        self.ActorController:SetMontageAndCamera("Weapon",Tag)
    end
end

-- TopN的赛季数据
function M:InitRankInfoTopN(TopNInfo)
    if not TopNInfo or GuildWarUtils.IsEmptyTable(TopNInfo) then
        self.WS_Type:SetActiveWidget(self.Com_Empty)
        self.Text_Empty:SetText(GText("RaidDungeon_Rank_Empty"))
        return
    end

    self.WS_Type:SetActiveWidget(self.List_Ranking)
    self.List_Ranking:ClearListItems()
    -- 排行数据
    local RankCount = 0
    for _, RankInfo in pairs(TopNInfo or {}) do
        RankCount = RankCount + 1
        local ItemObj = NewObject(UIUtils.GetCommonItemContentClass())
        ItemObj.RankInfo = RankInfo
        ItemObj.RoleInfo, ItemObj.PetInfo = self:GetMaxScoreSquad(RankInfo.MaxSquad)
        ItemObj.RankInfo.RankNum = RankCount
        ItemObj.ParentWidget = self
        ItemObj.SelfAvatar = self.Avatar
        self.List_Ranking:AddItem(ItemObj)
        -- 同步一下个人栏排名，以排行榜为准
        if (RankInfo.Uid == self.Avatar.Uid) then
            self.SelfRankInfo.Rank = RankCount
        end
        PrintTable((ItemObj.RoleInfo or RankInfo.MaxSquad or "该玩家阵容为空"), 2, string.format("看看排行榜第 %d 名的阵容数据：", _))
        DebugPrint("数据完成 Rank:", RankCount, RankInfo.Nickname, RankInfo.Uid)
    end
    -- 选中第一个
    self.List_Ranking:NavigateToIndex(0)
    -- 有效条目数量，用于处理最后一个的向下导航
    self.ValidItemNum = RankCount

    -- 空数据
    -- local MinListItemCount = 5
    -- for i = RankCount, MinListItemCount-1 do
    --     local ItemObj = NewObject(UIUtils.GetCommonItemContentClass())
    --     ItemObj.Empty = true
    --     self.List_Ranking:AddItem(ItemObj)
    -- end
    -- 事件绑定
    self.List_Ranking.BP_OnItemClicked:Clear()
    self.List_Ranking.BP_OnItemClicked:Add(self, self.OnListRankItemClicked)
    self.List_Ranking.BP_OnItemIsHoveredChanged:Clear()
    self.List_Ranking.BP_OnItemIsHoveredChanged:Add(self, self.OnListRankItemIsHoveredChanged)
    self.List_Ranking.OnListViewScrolled:Add(self, self.OnListRankScrolled)
end

-- 玩家个人的赛季数据
function M:InitRankInfoSelf(SelfRankInfo)
    local SeasonId = self.Avatar.CurrentRaidSeasonId
    local RaidSeasons = self.Avatar.RaidSeasons[SeasonId]
    local RankInfo = {}
    SelfRankInfo = SelfRankInfo or {}
    RankInfo.RankNum = (SelfRankInfo.Rank and SelfRankInfo.Rank > 0) and SelfRankInfo.Rank or -1 -- 排名
    RankInfo.BanState = RaidSeasons.BanState  -- 封禁状态
    RankInfo.HeadIconId = self.Avatar.HeadIconId  -- 头像
    RankInfo.HeadFrameId = self.Avatar.HeadFrameId  -- 头像框
    RankInfo.Level = self.Avatar.Level -- 等级
    RankInfo.Nickname = self.Avatar.Nickname -- 名字
    RankInfo.TitleBefore = self.Avatar.TitleBefore  -- 称号前
    RankInfo.TitleAfter = self.Avatar.TitleAfter  -- 称号后
    RankInfo.TitleFrame= self.Avatar.TitleFrame-- 称号框
    RankInfo.Score = RaidSeasons.MaxRaidScore  -- 积分
    local RoleInfo, PetInfo = self:GetMaxScoreSquad(SelfRankInfo.MaxSquad)
    local ItemData = {
        RankInfo = RankInfo,
        ParentWidget = self,
        RoleInfo = RoleInfo,
        PetInfo = PetInfo
    }
    self.SelfItemData = ItemData
    self.Ranking_Myself:OnListItemObjectSet(ItemData)
    self.Ranking_Myself.Button_Myself.OnPressed:Add(self, self.OnMyselfButtonPressed)
    self.Ranking_Myself.Button_Myself.OnClicked:Add(self, self.OnMyselfButtonClicked)
    self.Ranking_Myself.Button_Myself.OnHovered:Add(self, self.OnMyselfButtonHovered)
end

-- 获取最大积分阵容的角色信息和宠物信息
function M:GetMaxScoreSquad(SquadSnapShot)
    if not SquadSnapShot then
        return
    end

    -- 最大积分阵容快照
    local Squad = SerializeUtils:UnSerialize(SquadSnapShot)
    if not Squad or GuildWarUtils.IsEmptyTable(Squad) then
        return
    end

    local RoleInfo, PetInfo  = {}, {}
    if Squad.AvatarInfo then
        -- 主控角色
        local CharacterInfo = Squad.AvatarInfo.CharacterInfo
        if CharacterInfo and CharacterInfo.RoleInfo then
            RoleInfo[1] = {
                id = CharacterInfo.RoleInfo.RoleId,
                level = CharacterInfo.RoleInfo.Level
            }
        end
        -- 魅影1
        local PhantomIndex = 2
        local PhantomInfo1 = Squad.AvatarInfo.PhantomInfo1
        if PhantomInfo1 and PhantomInfo1.RoleInfo then
            RoleInfo[PhantomIndex] = {
                id = PhantomInfo1.RoleInfo.RoleId,
                level = PhantomInfo1.RoleInfo.Level
            }
            PhantomIndex = PhantomIndex + 1
        end
        -- 魅影2
        local PhantomInfo2 = Squad.AvatarInfo.PhantomInfo2
        if PhantomInfo2 and PhantomInfo2.RoleInfo then
            RoleInfo[PhantomIndex] = {
                id = PhantomInfo2.RoleInfo.RoleId,
                level = PhantomInfo2.RoleInfo.Level
            }
        end
    end

    if Squad.CommonCombatInfo then
        -- 宠物信息
        PetInfo = {id = Squad.CommonCombatInfo.pet_id, level =  Squad.CommonCombatInfo.pet_level}
    end

    return RoleInfo, PetInfo
end

-- 点击自己跳转到排行榜对应位置
function M:OnMyselfButtonClicked()
    if not self.IsGamePad then  -- 手柄不播放相关动画
        self.Ranking_Myself:PlayAnimation(self.Ranking_Myself.Click)
    end
    local SelfRankNum = self.SelfItemData.RankInfo.RankNum
    if SelfRankNum and SelfRankNum >= 1 then
        if self.LastClickedItem and (self.LastClickedItem.RankInfo.RankNum ~= SelfRankNum) then
            local LastItemWidget = self.LastClickedItem and self.LastClickedItem.SelfWidget or nil
            if LastItemWidget then
                LastItemWidget:PlayAnimation(LastItemWidget.Normal)
            end
            self.LastClickedItem = nil
        end
        self.List_Ranking:NavigateToIndex(SelfRankNum - 1)
    end
end

function M:OnMyselfButtonPressed()
    self.Ranking_Myself:PlayAnimation(self.Ranking_Myself.Press)
end

function M:OnMyselfButtonHovered()
    self.Ranking_Myself:StopAnimation(self.Ranking_Myself.UnHover)
    self.Ranking_Myself:PlayAnimation(self.Ranking_Myself.Hover)
end

function M:OnListRankItemIsHoveredChanged(Item, IsHovered)
    if self.IsGamePad then  -- 手柄不播放Hover相关动画
        return
    end
    if Item.IsSelected or Item.Empty then  -- 选中态和空态返回
        return
    end
    local ItemWidget = Item.SelfWidget
    if not ItemWidget then
        return
    end
    if self.LastClickedItem == Item then
        return
    end
    if IsHovered then
        ItemWidget:StopAnimation(ItemWidget.UnHover)
        ItemWidget:PlayAnimation(ItemWidget.Hover)
    else
        ItemWidget:StopAnimation(ItemWidget.Hover)
        ItemWidget:PlayAnimation(ItemWidget.UnHover)
    end
end

function M:OnListRankScrolled()
    if not self.LastClickedItem then
        return
    end

    local ItemWidget = self.LastClickedItem.SelfWidget
    if not ItemWidget then
        return
    end
    ItemWidget.Head_Anchor:Close()
end

function M:OnListRankItemClicked(Item)
    if Item.Empty then
        return
    end
    if self.LastClickedItem == Item then
        return
    end
    local ItemWidget = Item.SelfWidget
    if not ItemWidget then
        return
    end

    if not self.IsFirstOpen then  -- 第一次打开不走这里，防止重复切换角色
        self:SetRankingPlayerPreview(Item.RankInfo)
    end
    self.IsFirstOpen = nil

    ItemWidget:StopAnimation(ItemWidget.Normal)
    ItemWidget:PlayAnimation(ItemWidget.Click)

    if self.LastClickedItem then
        local LastItemWidget = self.LastClickedItem.SelfWidget
        if LastItemWidget then
            LastItemWidget:StopAnimation(LastItemWidget.Click)
            LastItemWidget:PlayAnimation(LastItemWidget.Normal)
        end
    end
    self.LastClickedItem = Item
end

--[[ 测试代码
function M:TestTopN()
    -- 背景初始化
    self:InitPreviewScene()

    -- 列表初始化
    self.WS_Type:SetActiveWidget(self.List_Ranking)
    self.List_Ranking:ClearListItems()
    local RankCount = 0
    local SeasonId = self.Avatar.CurrentRaidSeasonId
    local RaidSeasons = self.Avatar.RaidSeasons[SeasonId]
    local MinListItemCount = 10
    local CharIds = {1801, 1101, 2101, 2102, 2301}
    local WeaponIds = {10101, 10102, 10104, 10201, 10202}
    local Uids = {10131164862, 10131164864, 10131164867, 10131164860,10131164891}
    for i = 1, MinListItemCount do
        RankCount = RankCount + 1
        local ItemObj = NewObject(UIUtils.GetCommonItemContentClass())
        local RankInfo = {}
        RankInfo.RankNum = RankCount -- 排名
        RankInfo.HeadIconId = self.Avatar.HeadIconId  -- 头像
        RankInfo.HeadFrameId = self.Avatar.HeadFrameId  -- 头像框
        RankInfo.Level = self.Avatar.Level -- 等级
        RankInfo.Nickname = self.Avatar.Nickname -- 名字
        RankInfo.TitleBefore = self.Avatar.TitleBefore  -- 称号前
        RankInfo.TitleAfter = self.Avatar.TitleAfter  -- 称号后
        RankInfo.TitleFrame= self.Avatar.TitleFrame-- 称号框
        RankInfo.Score = i * 1000  -- 积分
        RankInfo.Squad = RaidSeasons.MaxSquad  -- 阵容
        ItemObj.SelfAvatar = self.Avatar
        ItemObj.Empty = false
        ItemObj.ParentWidget = self
        ItemObj.RankInfo = RankInfo

        local CharIndex = math.clamp(i % 6, 1, 5)
        RankInfo.Char = {CharId = CharIds[CharIndex]}
        RankInfo.Weapon = {WeaponId = WeaponIds[CharIndex]}
        RankInfo.Uid = Uids[CharIndex]

        self.List_Ranking:AddItem(ItemObj)
    end
    self.List_Ranking:NavigateToIndex(0)
    -- 有效条目数量，用于判断最后一个的向下导航
    self.ValidItemNum = RankCount
    for i = 1, 5 do
        local ItemObj = NewObject(UIUtils.GetCommonItemContentClass())
        ItemObj.Empty = true
        ItemObj.ParentWidget = self
        self.List_Ranking:AddItem(ItemObj)
    end
    self.List_Ranking.BP_OnItemClicked:Clear()
    self.List_Ranking.BP_OnItemClicked:Add(self, self.OnListRankItemClicked)
    self.List_Ranking.BP_OnItemIsHoveredChanged:Clear()
    self.List_Ranking.BP_OnItemIsHoveredChanged:Add(self, self.OnListRankItemIsHoveredChanged)
    self.List_Ranking.OnListViewScrolled:Add(self, self.OnListRankScrolled)
end--]]

return M