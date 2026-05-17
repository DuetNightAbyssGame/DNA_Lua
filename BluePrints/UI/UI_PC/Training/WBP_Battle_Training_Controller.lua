require "UnLua"
local Model = require "BluePrints.UI.UI_PC.Training.WBP_Training_Model"
local UIUtils = require "Utils.UIUtils"
local Controller = {}

function Controller:RegisterView(View)
    self.View = View
    self.Model = Model
    self.Model:Init(GWorld:GetAvatar())
    self.GameMode = UE4.UGameplayStatics.GetGameMode(self.View)
	self.TrainingData = DataMgr.Training[self.GameMode.DungeonId]

    self.View:InitView()
    self:BindViewEvents()
    self:OnInit()
end

function Controller:BindViewEvents()
    self.View.OnDecreaseMonsterGalleryEntryNum = function(NewValue) self:IncreaseMonsterEntryNum(self.LastSelectedItemData.RuleId, false) end
    self.View.OnIncreaseMonsterGalleryEntryNum = function(NewValue) self:DecreaseMonsterEntryNum(self.LastSelectedItemData.RuleId, false) end
    self.View.OnMaxMonsterGalleryEntryNum = function() self:MaxMonsterEntryNum(self.LastSelectedItemData.RuleId, false) end
    self.View.OnChangeMonsterGalleryEntryNum = function(NewValue) self:UpdateCheckedEntryNum(self.LastSelectedItemData.RuleId, NewValue, false) end
    self.View.OnClearAllSelection = function() self:ClearAllSelection() end
    self.View.OnUncheckMonsterGalleryEntry = function(RuleId) self:ClearMonsterEntryCheckedNum(RuleId) end
    self.View.OnMonsterLevelChanged = function(Obj, CurNumber, PrevNumber) self:OnMonsterLevelChanged(CurNumber) end
    self.View.OnSpawnMonster = function() self:OnSpawnMonster() end
    self.View.OnKillAllMonsters = function() self:OnKillAllMonsters() end
    self.View.OnShowUnlockedMonstersCallback = function(Checked) self:OnShowUnlockedMonsters(Checked) end
    self.View.GamepadOnItemHovered = function(RuleId) self:SetMonsterGalleryEntrySelected(RuleId, true) end
end

function Controller:OnInit()
    self.MonsterChecked = {}
    self.MonsterCheckedNum = {}
    self.LastSelectedItemData = nil
    self.OnlyShowUnlockedMonsters = nil
    self.MonsterCheckedTotalNum = 0
    self.CurrentSelectedTabWidget = nil
    self.CurrentTabIdx = 1
    local TabConfigData = self.Model:GetTabData()
    self.View:InitTab(TabConfigData, self.OnMonsterCampTabSelected)
    self.View:UpdateViewBySelectedNum(0, self:GetMaxSpawnableNum(), 0, true)
    self:InitEnemyLevelSetting()
end

function Controller:OnMonsterCampTabSelected(TabWidget)
    DebugPrint("Tianyi@ OnMonsterCampTabSelected: " .. TabWidget.Idx)
    if self.CurrentSelectedTabWidget then
        self.CurrentSelectedTabWidget:ShowText(false)
    end
    self.CurrentSelectedTabWidget = TabWidget
    self.CurrentSelectedTabWidget:ShowText(true)
    self:SelectTab(TabWidget.Idx, self.OnlyShowUnlockedMonsters)
    self:ClearCurrentSelection()
end

function Controller:SelectMonsterCampTabByIdx(TabIdx)
    self:SelectTab(TabIdx, self.OnlyShowUnlockedMonsters)
    self:ClearCurrentSelection()
end

function Controller:SelectTab(TabIdx, OnlyUnlocked)
    self.CurrentTabIdx = TabIdx
    self.CurrentMonsterGallery = self.Model:FilterItemsForMonsterGallery(TabIdx, OnlyUnlocked)
    local ItemViewDatas = {}
    for Index, Data in ipairs(self.CurrentMonsterGallery) do
        local ItemViewData = NewObject(UIUtils.GetCommonItemContentClass())
        ItemViewData.Index = Index
        ItemViewData.RuleId = Data.Id
        ItemViewData.Locked = Data.IsLocked
        ItemViewData.PreferredMonsterId = Data.Info.PreferredMonsterId
        ItemViewData.OnClicked = {Func = self.OnMonsterGalleryEntryClicked, Inst = self}
        ItemViewData.IsChecked = self:IsMonsterItemChecked(Data.Id)
        ItemViewData.CheckedNum = self.MonsterCheckedNum[Data.Id] or 0
        ItemViewData.Selected = self:IsMonsterItemSelected(Data.Id)
        table.insert(ItemViewDatas, ItemViewData)
    end
    self.View:InitMonsterGalleryData(ItemViewDatas)
end


function Controller:OnMonsterGalleryEntryClicked(Item)
    DebugPrint("Tianyi@ OnMonsterGalleryEntryClicked: " .. Item.RuleId)
    if Item.Data.Locked then 
        self.View:ShowLockedInfo()
        self:SetMonsterGalleryEntrySelected(Item.RuleId, true)
        AudioManager(self.View):PlayUISound(self.View, "event:/ui/common/click_btn_disable", nil, nil)
        return 
    end

    AudioManager(self.View):PlayUISound(self.View, "event:/ui/common/click_btn_large", nil, nil)
    local CanCheck, ErrorMsg = self:CheckMonsterGalleryItemCanChecked(Item)
    if not CanCheck then
        self.View:ShowToast(ErrorMsg)
        self:SetMonsterGalleryEntrySelected(Item.RuleId, true)
        return
    end

    -- 待选列表：选择和取消选择某个怪物，更新对应的数量和总数
    if not Item.Data.IsChecked then 
        self:SetMonsterEntryChecked(Item.RuleId, true)
    else 
        self:IncreaseMonsterEntryNum(Item.RuleId, true)
    end
    self:SetMonsterGalleryEntrySelected(Item.RuleId, true)
end

function Controller:SetMonsterGalleryEntrySelected(RuleId, bSelected)
    local ItemData = self.View:GetMonsterGalleryItemData(RuleId)
    local ItemEntry = self.View:GetMonsterGalleryItemEntry(RuleId)
    local LastSelectedItemEntry = nil
    if self.LastSelectedItemData then
        LastSelectedItemEntry = self.View:GetMonsterGalleryItemEntry(self.LastSelectedItemData.RuleId)
    end

    if not ItemData then 
        DebugPrint("Tianyi@ ItemData is nil")
        return false
    end

    if bSelected then
        if ItemEntry then
            self.View:SelectEntry(ItemEntry, true)
        end

        if LastSelectedItemEntry and LastSelectedItemEntry ~= ItemEntry then
            self.View:SelectEntry(LastSelectedItemEntry, false)
        end

        if not ItemData.Locked then
            -- 更新滑动条
            local CurrentCheckedNum = self.MonsterCheckedNum[RuleId]
            if CurrentCheckedNum then
                local MaxSelectableNum = self:GetMaxSpawnableNum() - self.MonsterCheckedTotalNum + CurrentCheckedNum
                self.View:UpdateViewBySelectedNum(CurrentCheckedNum, MaxSelectableNum, self.MonsterCheckedTotalNum, true)
            else
                self.View:UpdateViewBySelectedNum(0, 0, self.MonsterCheckedTotalNum, true)
            end
        else
            self.View:ShowLockedInfo()
        end

        self.LastSelectedItemData = ItemData
    else

    end
end

function Controller:ClearMonsterEntryCheckedNum(RuleId)
    self:SetMonsterEntryChecked(RuleId, false)
    if self.LastSelectedItemData and self.LastSelectedItemData.RuleId == RuleId and not UIUtils.IsGamepadInput() then   --  手柄端不清空选择
        self:ClearCurrentSelection()
    else
        local CurrentSelectedRuleId = self.LastSelectedItemData and self.LastSelectedItemData.RuleId or nil
        local CurrentCheckedNum = CurrentSelectedRuleId and self.MonsterCheckedNum[CurrentSelectedRuleId] or 0
        self.View:UpdateViewBySelectedNum(CurrentCheckedNum, self:GetMaxSpawnableNum(), self.MonsterCheckedTotalNum, false)
    end
end

function Controller:SetMonsterEntryChecked(RuleId, bChecked, CheckNumber)
    local ItemData = self.View:GetMonsterGalleryItemData(RuleId)
    local ItemEntry = self.View:GetMonsterGalleryItemEntry(RuleId)
    CheckNumber = CheckNumber or 1
    local LastCheckedNum = self.MonsterCheckedNum[RuleId] or 0
    if bChecked then 
        self.MonsterChecked[RuleId] = true
        self.MonsterCheckedNum[RuleId] = CheckNumber

        if ItemData then 
            ItemData.IsChecked = true
            ItemData.CheckedNum = self.MonsterCheckedNum[RuleId]
        end

        if ItemEntry then 
            ItemEntry:OnItemChecked(true)
        end

        self.View:AddNewEntryToCountList(RuleId, CheckNumber)
    else 
        self.MonsterChecked[RuleId] = nil
        self.MonsterCheckedNum[RuleId] = 0

        if ItemData then
            ItemData.IsChecked = false
            ItemData.CheckedNum = nil
        end

        if ItemEntry then 
            ItemEntry:OnItemChecked(false)
        end
        
        self.View:RemoveEntryFromCountList(RuleId)
    end
    self.MonsterCheckedTotalNum = self.MonsterCheckedTotalNum + self.MonsterCheckedNum[RuleId] - LastCheckedNum
end

function Controller:ClearCurrentSelection()
    if self.LastSelectedItemData then
        local LastSelectedItemEntry = self.View:GetMonsterGalleryItemEntry(self.LastSelectedItemData.RuleId)
        if LastSelectedItemEntry then
            self.View:SelectEntry(LastSelectedItemEntry, false)
        end
        self.LastSelectedItemData = nil
    end
    self.View:ShowMonsterRuleInfoView(nil)
end

function Controller:ClearAllSelection()
    self.MonsterChecked = {}
    self.MonsterCheckedNum = {}
    self.MonsterCheckedTotalNum = 0
    self.View:ClearAllCheckedEntries()
    self:ClearCurrentSelection()
end

function Controller:IsMonsterItemChecked(RuleId)
    return self.MonsterChecked[RuleId] or false
end

function Controller:IsMonsterItemSelected(RuleId)
    return self.LastSelectedItemData and self.LastSelectedItemData.Id == RuleId
end

function Controller:CheckMonsterGalleryItemCanChecked(Item)
    local ItemData = Item.Data   
    if ItemData.Locked then 
        return false, GText("UI_DUNGEON_DES_TRAINING_9")
    end
    if self.MonsterCheckedTotalNum >= self:GetMaxSpawnableNum() then 
        return false, string.format(GText("UI_DUNGEON_DES_TRAINING_8"), self.TrainingData.MaxEnemyNum)
    end
    return true
end

function Controller:GetMaxSpawnableNum()
    local MonsterNum = self:GetTrainingComp():CheckAliveMonsterCount()
    return math.max(0, self.TrainingData.MaxEnemyNum - MonsterNum)
end

function Controller:IncreaseMonsterEntryNum(RuleId, bNotifySlider)
    local CurrentCheckedNum = self.MonsterCheckedNum[RuleId] or 0
    local MaxSelectableNum = self:GetMaxSpawnableNum() - self.MonsterCheckedTotalNum + CurrentCheckedNum
    if CurrentCheckedNum >= MaxSelectableNum then 
        self.View:ShowToast(string.format(GText("UI_DUNGEON_DES_TRAINING_8"), self.TrainingData.MaxEnemyNum))
        return
    end
    self:UpdateCheckedEntryNum(RuleId, CurrentCheckedNum + 1, bNotifySlider)
end

function Controller:DecreaseMonsterEntryNum(RuleId, bNotifySlider)
    local CurrentCheckedNum = self.MonsterCheckedNum[RuleId] or 0
    if CurrentCheckedNum <= 1 then return end
    self:UpdateCheckedEntryNum(RuleId, CurrentCheckedNum - 1, bNotifySlider)
end

function Controller:MaxMonsterEntryNum(RuleId, bNotifySlider)
    local CurrentCheckedNum = self.MonsterCheckedNum[RuleId] or 0
    local MaxSelectableNum = self:GetMaxSpawnableNum() - self.MonsterCheckedTotalNum + CurrentCheckedNum
    self:UpdateCheckedEntryNum(RuleId, MaxSelectableNum, bNotifySlider)
end

function Controller:UpdateCheckedEntryNum(RuleId, NewNum, bNotifySlider)
    local ItemData = self.View:GetMonsterGalleryItemData(RuleId)
    local ItemEntry = self.View:GetMonsterGalleryItemEntry(RuleId)
    local LastCheckedNum = self.MonsterCheckedNum[RuleId] or 0

    self.MonsterCheckedNum[RuleId] = NewNum
    self.MonsterCheckedTotalNum = self.MonsterCheckedTotalNum + NewNum - LastCheckedNum
    ItemData.CheckedNum = NewNum
    if ItemEntry then 
        ItemEntry:UpdateItemView(true)
    end

    if self.LastSelectedItemData and self.LastSelectedItemData.RuleId == RuleId then
        local CurrentSelectedNum = self.MonsterCheckedNum[RuleId]
        local MaxSelectableNum = self:GetMaxSpawnableNum() - self.MonsterCheckedTotalNum + CurrentSelectedNum
        self.View:UpdateViewBySelectedNum(CurrentSelectedNum, MaxSelectableNum, self.MonsterCheckedTotalNum, bNotifySlider)
    end

    self.View:UpdateCountListEntryNum(RuleId, NewNum)
end

function Controller:InitEnemyLevelSetting()
    local Avatar = GWorld:GetAvatar()
    local PlayerLevel = math.min(Avatar and Avatar.Level or 1, #(DataMgr.RegionLevel))
    self.EnemyLevelToSpawn = DataMgr.RegionLevel[PlayerLevel].RegionLevel -- 当前生成的敌人等级
    self.MaxEnemyLevelToSpawn = 180 -- 最大生成的敌人等级
    self.View:InitEnemyLevelSetting(self.EnemyLevelToSpawn, self.MaxEnemyLevelToSpawn)
end

function Controller:OnMonsterLevelChanged(Level)
    self.EnemyLevelToSpawn = Level
end

function Controller:GetTrainingComp()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self.View)
    if GameMode then 
        return GameMode:GetDungeonComponent()
    end

    return nil
end

-- 生成与击杀怪物
function Controller:OnSpawnMonster()
    if not self.MonsterChecked then return end 
    if self.View.IsClosing then return end

    local SpawnedNum = 0
    local MonstersToSpawn = {}
    for RuleId, _ in pairs(self.MonsterChecked) do 
        local RuleData = DataMgr.GalleryRule[RuleId]
        local MonsterId = RuleData.PreferredMonsterId
        if MonsterId and self.MonsterCheckedNum[RuleId] then 
            table.insert(MonstersToSpawn, {MonsterId, self.MonsterCheckedNum[RuleId], self.EnemyLevelToSpawn})
            SpawnedNum = SpawnedNum + self.MonsterCheckedNum[RuleId]
        end
    end

    if #MonstersToSpawn <= 0 then
        self.View:ShowToast(string.format(GText("UI_DUNGEON_DES_TRAINING_8"), self.TrainingData.MaxEnemyNum))
        return
    end

    self:GetTrainingComp():CreateMonster(MonstersToSpawn)
    self.View:OnSpawnedMonster(SpawnedNum)
end

function Controller:OnKillAllMonsters()
    if self.View.IsClosing then return end
    local GameState = UE4.UGameplayStatics.GetGameState(self.View)
    local Battle = Battle(self.View)
    for _, Target in pairs(GameState.MonsterMap) do
        Battle:BattleOnDead(Target:GetEid(), Target:GetEid(), 0, EDeathReason.GMKill)
    end
    self.View:OnKilledMonster()
end

function Controller:OnShowUnlockedMonsters(IsChecked)
    self.OnlyShowUnlockedMonsters = IsChecked
    self:SelectMonsterCampTabByIdx(self.CurrentTabIdx)
end

function Controller:GetSpawnedMonsterNum()
    local GameState = UE4.UGameplayStatics.GetGameState(self.View)
    local MonsterNum = GameState.MonsterNum
    return MonsterNum
end

return Controller