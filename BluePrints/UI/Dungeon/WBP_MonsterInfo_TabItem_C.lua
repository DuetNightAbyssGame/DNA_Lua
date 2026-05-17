require "UnLua"
local MonsterUtils = require "Utils.MonsterUtils"

local MONSTER_BOSS_ICON = "/Game/UI/Texture/Static/Atlas/Play/T_Play_BossMonster.T_Play_BossMonster"
local MONSTER_ELITE_ICON = "/Game/UI/Texture/Static/Atlas/Play/T_Play_EliteMonster.T_Play_EliteMonster"
local MONSTER_INFO_WEAKNESS_ITEM = "/Game/UI/WBP/Play/Widget/Depute/MonsterInfo_Tab_Item_Content.MonsterInfo_Tab_Item_Content" 

local M = Class("BluePrints.UI.BP_EMUserWidget_C")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Construct()
    self.Button_Area.OnClicked:Add(self, self.onButtonAreaClicked)
    self.Button_Area.OnHovered:Add(self, self.OnButtonAreaHovered)
    self.Button_Area.OnUnhovered:Add(self, self.OnBtnUnhovered)
    self.Button_Area.OnPressed:Add(self, self.OnBtnPressed)
end

function M:Destruct()
    self.Button_Area.OnClicked:Clear()
    self.Button_Area.OnHovered:Clear()
    self.Button_Area.OnUnhovered:Clear()
end

function M:OnListItemObjectSet(Obj)
    DebugPrint("gmy@TabOnListItemObjectSet", Obj.MonsterId, Obj.bIsDefaultSelected)
    local MonsterId = Obj.MonsterId
    local MonsterInfo = DataMgr.Monster[MonsterId]
    if self.ParentWidget and self.MonsterId and self.ParentWidget.MonsterIdToItem then
        if self.ParentWidget.MonsterIdToItem[self.MonsterId] == self then
            self.ParentWidget.MonsterIdToItem[self.MonsterId] = nil
        end
    end
    local GallaryId = MonsterInfo.GalleryRuleId
    local ImagePath = nil
    if GallaryId then
        ImagePath = DataMgr.GalleryRule[GallaryId].MonsterIcon
    end
    self.MonsterId = MonsterId
    -- 保存父级与索引映射
    self.ParentWidget = Obj.ParentWidget
    self.ParentWidget.MonsterIdToItem[MonsterId] = self

    -- 确保 LevelChoose 的回调能拿到自身控件
    Obj.SelfWidget = self

    -- 保存聚焦路径委托（由 LevelChoose 侧注入）
    self.OnAddedToFocusPathEvent = Obj.OnAddedToFocusPathEvent
    self.OnRemovedFromFocusPathEvent = Obj.OnRemovedFromFocusPathEvent
    self.DisableSelect = Obj.DisableSelect
    self.SoundEvent = Obj.SoundEvent
    assert(MonsterInfo, string.format("MonsterInfo is nil, MonsterId = %s", MonsterId))
    local bIsBoss = MonsterUtils.IsBoss(MonsterId)
    local bIsElite = MonsterUtils.IsElite(MonsterId)
    local bIsNormal = not (bIsElite or bIsBoss)
    local MonsterIcon = LoadObject(string.format("Texture2D'%s'", ImagePath))
    if bIsNormal then
        self.Icon_Monster_Type:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        if self.Icon_Monster_Type then
            self.Icon_Monster_Type:SetVisibility(UE4.ESlateVisibility.Visible)
        end
        local MonsterTypeIcon = nil
        if bIsBoss then
            MonsterTypeIcon = LoadObject(string.format("%s", MONSTER_BOSS_ICON))
        else
            MonsterTypeIcon = LoadObject(string.format("%s", MONSTER_ELITE_ICON))
        end
        self.Icon_Monster_Type:SetBrushResourceObject(MonsterTypeIcon)
    end
    
    self:RefreshWeaknessIcon(Obj)
    local ImgMat = self.Monster_Head:GetDynamicMaterial()
    ImgMat:SetTextureParameterValue("IconMap", MonsterIcon)

    -- 根据父控件当前选择状态恢复/设置选中（解决滚动回来看不到选中状态的 bug）
    local ShouldSelect = false
    if self.ParentWidget then
        local SelectedMonsterId = nil
        if self.ParentWidget.DisplayMonsters and self.ParentWidget.NowSelectingIndex then
            SelectedMonsterId = self.ParentWidget.DisplayMonsters[self.ParentWidget.NowSelectingIndex]
        end
        if SelectedMonsterId and SelectedMonsterId == MonsterId then
            ShouldSelect = true
        elseif Obj.bIsDefaultSelected and not SelectedMonsterId then
            -- 初次创建时默认选中（只在还没有有效选择时）
            ShouldSelect = true
        end
    end

    if ShouldSelect then
        -- 如果该复用控件原本是旧的选中项但 MonsterId 已变更，需要校准父级 SelectingItem
        if self.ParentWidget.SelectingItem ~= self then
            self:ForceToSelection()
        else
            -- 仍然是同一个控件，刷新动画（避免被 CancelTabSelect 过）
            self.IsSelect = true
            self:PlayAnimation(self.Select)
        end
    else
        -- 如果当前控件曾是选中项但已不再对应选中 Monster，则清空父级引用
        local SelectedMonsterId = nil
        if self.ParentWidget and self.ParentWidget.DisplayMonsters and self.ParentWidget.NowSelectingIndex then
            SelectedMonsterId = self.ParentWidget.DisplayMonsters[self.ParentWidget.NowSelectingIndex]
        end
        if self.ParentWidget and self.ParentWidget.SelectingItem == self and SelectedMonsterId ~= MonsterId then
            self.ParentWidget.SelectingItem = nil
        end
        self:CancelTabSelect()
    end
    if Obj.NeedFocusable then
        self:SetVisibility(ESlateVisibility.Visible)
        self.bIsFocusable = true
    end
end

--设置一些基础数据 用于不使用ListView生成的怪物头像
function M:SetBasicData(MonsterId,Obj)
    local MonsterInfo = DataMgr.Monster[MonsterId]
    local bIsBoss = MonsterUtils.IsBoss(MonsterId)
    local bIsElite = MonsterUtils.IsElite(MonsterId)
    local bIsNormal = not (bIsElite or bIsBoss)
    local GallaryId = MonsterInfo.GalleryRuleId
    local MonsterIcon = LoadObject(string.format("Texture2D'%s'", DataMgr.GalleryRule[GallaryId].MonsterIcon))
    if bIsNormal then
        self.Icon_Monster_Type:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        self.Icon_Monster_Type:SetVisibility(UE4.ESlateVisibility.Visible)
        local MonsterTypeIcon = nil
        if bIsBoss then
            MonsterTypeIcon = LoadObject(string.format("Texture2D'%s'", MONSTER_BOSS_ICON))
        else
            MonsterTypeIcon = LoadObject(string.format("Texture2D'%s'", MONSTER_ELITE_ICON))
        end
        self.Icon_Monster_Type:SetBrushResourceObject(MonsterTypeIcon)
    end
    self:RefreshWeaknessIcon(Obj)
    local ImgMat = self.Monster_Head:GetDynamicMaterial()
    ImgMat:SetTextureParameterValue("IconMap", MonsterIcon)
end

function M:RefreshWeaknessIcon(Obj)
    if Obj.WeaknessIcon then
        self.Group_Weak:SetVisibility(ESlateVisibility.Visible)
        local IconSet = Obj.WeaknessIcon
        local IconList = {}
        for Icon, WeaknessType in pairs(IconSet) do
            table.insert(IconList, { Icon = Icon, WeaknessType = WeaknessType })
        end
        table.sort(IconList, MonsterUtils.SortWeaknessTypeIcon)
        self.List_Weak:ClearListItems()
        local Class = LoadClass(MONSTER_INFO_WEAKNESS_ITEM)
        for _, v in ipairs(IconList) do
            local Content = NewObject(Class)
            Content.WeaknessIcon = v.Icon
            self.List_Weak:AddItem(Content)
        end
    else
        self.Group_Weak:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:ForceToSelection()
    if not self.DisableSelect then
        self.IsSelect = true
        self:PlayAnimation(self.Select)
    end
    self.ParentWidget:SetTabItemSelection(self)
end

function M:onButtonAreaClicked()
    if not self.ParentWidget:IsAnimationPlaying(self.ParentWidget.Out)then
        AudioManager(self):PlayUISound(self, self.SoundEvent,nil,nil)
        self.ParentWidget:SelectMonsterInfoItem(self.MonsterId)
        if self.ParentWidget.TryMoveMonsterInfo then
            self.ParentWidget:TryMoveMonsterInfo(0)
        end
    end
end

function M:OnButtonAreaHovered()
    if not self.IsSelect then
        self:PlayAnimation(self.Hover)
    end
end

function M:OnBtnPressed()
	if not self.IsSelect then
		self:PlayAnimation(self.Press)
	end
end

function M:OnBtnUnhovered()
    if not self.IsSelect then
        self:PlayAnimation(self.Normal)
    end
end

function M:CancelTabSelect()
    self.IsSelect = false
    self:PlayAnimation(self.Normal)
end

function M:OnAddedToFocusPath(InFocusEvent)
    if self.OnAddedToFocusPathEvent then
        local Obj = self.OnAddedToFocusPathEvent.Obj
        local Callback = self.OnAddedToFocusPathEvent.Callback
        local Params = self.OnAddedToFocusPathEvent.Params
        if Callback then
            Callback(Obj, Params)
        end
    end
end

function M:OnRemovedFromFocusPath(InFocusEvent)
    if self.OnRemovedFromFocusPathEvent then
        local Obj = self.OnRemovedFromFocusPathEvent.Obj
        local Callback = self.OnRemovedFromFocusPathEvent.Callback
        local Params = self.OnRemovedFromFocusPathEvent.Params
        if Callback then
            Callback(Obj, Params)
        end
    end
end

return M
