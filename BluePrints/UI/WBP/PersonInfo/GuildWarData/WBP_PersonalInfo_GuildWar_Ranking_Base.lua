require "UnLua"
local ActorController = require "BluePrints.UI.WBP.Armory.ActorController.Armory_ActorController"
local GuildWarUtils = require "BluePrints.UI.WBP.Activity.Widget.GuildWar.GuildWarUtils"
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
local SerializeUtils = require "Utils.SerializeUtils"
local UIUtils = require "Utils.UIUtils"

local function NormalizeSlotData(Info)
    if type(Info) ~= "table" then
        return Info
    end
    local SlotData = Info.SlotData
    if type(SlotData) ~= "table" then
        return Info
    end
    local needConvert = false
    for _, value in pairs(SlotData) do
        if type(value) ~= "table" then
            needConvert = true
            break
        end
    end
    if not needConvert then
        return Info
    end
    local NewInfo = {}
    for key, value in pairs(Info) do
        NewInfo[key] = value
    end
    local NewSlotData = {}
    for key, value in pairs(SlotData) do
        if type(value) == "table" then
            NewSlotData[key] = value
        elseif type(value) == "number" then
            NewSlotData[key] = {SlotId = key, Polarity = value, ModEid = -1}
        end
    end
    NewInfo.SlotData = NewSlotData
    return NewInfo
end

local M = Class{"BluePrints.UI.WBP.Activity.PC.GuildWar.WBP_Activity_GuildWar_RankingBase"}

function M:Construct()
    M.Super.Construct(self)
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "GuildWarHistoryRankOpen", nil)
    if self.List_Ranking.OnCreateEmptyContent then
        self.List_Ranking.OnCreateEmptyContent:Bind(self, function(self)
            local ItemObj = NewObject(UIUtils.GetCommonItemContentClass())
            ItemObj.Empty = true
            return ItemObj
        end)
    end

end

function M:InitView()
    self.Text_Time:SetText(GText("RaidDungeon_Rank_Time"))
    self.Text_Name:SetText(GText("RaidDungeon_Rank_Tier"))
    self.Text_Title:SetText(GText("RaidDungeon_Raid_Rank"))
    self.Text_Ranking:SetText(GText("RaidDungeon_Rank"))
    self.Text_Score:SetText(GText("RaidDungeon_Max_Point_Rank"))
    self.Text_Team:SetText(GText("RaidDungeon_Rank_CharList"))
    -- 初始化Tab
    self:InitCommonTab()
end
function M:Destruct()
    if self.List_Ranking.OnCreateEmptyContent then
        self.List_Ranking.OnCreateEmptyContent:Unbind()
    end
    M.Super.Destruct(self)
end

function M:InitPreviewScene(TopNInfo)
    local WeaponModel
    -- 如果没TopN数据，用玩家自己的
    if GuildWarUtils.IsEmptyTable(TopNInfo) 
    or (TopNInfo[1].MaxSquad == nil) or (TopNInfo[1].MaxSquad == "") then
        self.ActorController = ActorController:New({
            ViewUI = self,
            IsPreviewMode = true,
            Char = nil, -- 个人主页模式下，无数据不显示角色
            EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
        })
        -- WeaponModel = self.Avatar.Weapons[self.Avatar.MeleeWeapon]
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

    local RoleInfo = NormalizeSlotData(CharacterInfo.RoleInfo)
    local WeaponInfo = NormalizeSlotData(CharacterInfo.MeleeWeapon)
    local DummyAvatar = {}
    local Params = {
        CharInfos = {RoleInfo},
        WeaponInfos = {WeaponInfo}
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
        self.ActorController:ChangeCharModel(CharModel, true)
        self.ActorController:ChangeWeaponModel(WeaponModel)
        self.ActorController:SetMontageAndCamera("Weapon",Tag)
    end
end

-- TopN的赛季数据
function M:InitOnGetTopN(TopNInfo)
    -- 初始化预览场景
    self:InitPreviewScene(TopNInfo)
    -- 直接调用InitRankInfoTopN，由它内部处理空态
    self:InitRankInfoTopN(TopNInfo)
end

-- 初始化TopN列表（复用PC/Mobile通用逻辑）
function M:InitRankInfoTopN(TopNInfo)
    if not TopNInfo or GuildWarUtils.IsEmptyTable(TopNInfo) then
        if self.WS_Type then
            self.WS_Type:SetActiveWidgetIndex(1)
        end
        if self.Text_Empty then
            self.Text_Empty:SetText(GText("RaidDungeon_Rank_Empty"))
        end
        return
    end

    if self.WS_Type then
        self.WS_Type:SetActiveWidgetIndex(0)
    end
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
    end
    -- 填充空态
    self.List_Ranking:RequestFillEmptyContent()
    self.List_Ranking:NavigateToIndex(0)
    -- 有效条目数量，用于处理最后一个的向下导航
    self.ValidItemNum = RankCount

    -- 事件绑定
    self.List_Ranking.BP_OnItemClicked:Clear()
    self.List_Ranking.BP_OnItemClicked:Add(self, self.OnListRankItemClicked)
    self.List_Ranking.BP_OnItemIsHoveredChanged:Clear()
    self.List_Ranking.BP_OnItemIsHoveredChanged:Add(self, self.OnListRankItemIsHoveredChanged)
    self.List_Ranking.OnListViewScrolled:Add(self, self.OnListRankScrolled)
end

function M:OnListRankScrolled()
    if not self.LastClickedItem then
        return
    end
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

    AudioManager(self):PlayUISound(self, "event:/ui/common/click", nil, nil)

    -- Personal Homepage specific: Preview on click
    self:SetRankingPlayerPreview(Item.RankInfo)

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

-- Override to do nothing in Personal Page mode (avoid accessing current season data)
function M:InitRankInfoSelf(SelfRankInfo)
    -- Do nothing
    if self.Ranking_Myself then
        self.Ranking_Myself:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function M:OnReturnKeyDown()
    if self:IsAnimationPlaying(self.In) or self.IsClosing then
        return
    end
    AudioManager(self):SetEventSoundParam(self, "GuildWarHistoryRankOpen", {ToEnd = 1})
    self:CloseSelf()
end


return M