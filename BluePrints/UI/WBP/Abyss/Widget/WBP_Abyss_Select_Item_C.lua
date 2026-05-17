
local WBP_Abyss_Select_Item_C = Class("BluePrints.UI.BP_EMUserWidget_C")

local MonsterUtils = require "Utils.MonsterUtils"
local ESlotName = require 'BluePrints.UI.UI_PC.Abyss.WBP_Abyss_Lineup_C'.ESlotName

local DungeonName = {
    [1] = GText("Abyss_DungeonA"),
    [2] = GText("Abyss_DungeonB")
}

function WBP_Abyss_Select_Item_C:InitGamepadKeys()
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        return
    end
    self.Entry_Tip.Icon_Key_Entry:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "View",
            },
        },
    })
    self.Btn_Enemy.Key_Controller:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "Menu",
            },
        },
    })
end

function WBP_Abyss_Select_Item_C:Construct()
    self.IsForbidden = false
    self.Checked = false
    self.DungeonIndex = -1
    self.Slots = { 
        [ESlotName.Char] = self.Character, 
        [ESlotName.Pet] = self.Pet, 
        [ESlotName.RangedWeapon] = self.Ranged,
        [ESlotName.MeleeWeapon] = self.Melee,
        [ESlotName.Phantom1] = self.Head_Phantom01,
        [ESlotName.PhantomWeapon1] = self.Weapon_Phantom01,
        [ESlotName.Phantom2] = self.Head_Phantom02,
        [ESlotName.PhantomWeapon2] = self.Weapon_Phantom02,
    }
    --折叠状态下的角色槽
    self.Text_Phantom01:SetText(GText("UI_STAT_Sigil"))
    self.Text_Phantom02:SetText(GText("UI_STAT_Sigil"))
    self.Btn_Entry = self.Entry_Tip.Btn_Entry
    self.List_Entry = self.Entry_Tip.List_Entry
    self.Btn_Entry:UnBindEventOnClickedByObj(self)
    self.Btn_Entry:BindEventOnClicked(self,self.ShowEntryPanel)
    self.Btn_Enemy:Init(self, self.ShowMonsterInfo)
    self:BindButtonPerformances()
    self:InitGamepadKeys()
    self:InitListenEvent()
end

function WBP_Abyss_Select_Item_C:Destruct()
	self.Btn_Entry:UnBindEventOnClickedByObj(self)
    self:UnBindButtonPerformances()
    if self.DungeonIndex==1 then
        self:RemoveReddotListener("AbyssEntry1",self.OnEntryReddotChange)
    else
        self:RemoveReddotListener("AbyssEntry2",self.OnEntryReddotChange)
    end
end

function WBP_Abyss_Select_Item_C:Init(DungeonIndex, SelectPage, DungeonId)
    self.IsForbidden = false
    self.Checked = false
    self.Name = DungeonName[DungeonIndex]
    self.Text_LevelName:SetText(self.Name)
    self.DungeonIndex = DungeonIndex
    self.SelectPage = SelectPage
    self:InitReddot()
    self:InitSlots()
    self:InitDungeonInfo(DungeonId)
    self:InitListEntry()
    self:SetProgressAndAttribute()
    self:InitBossInfo()
end

function WBP_Abyss_Select_Item_C:InitDungeonInfo(DungeonId)
    local DungeonInfo = DataMgr.AbyssDungeon[DungeonId]
    if not DungeonInfo then
        DebugPrint("lhr@WBP_Abyss_Select_Item_C:InitDungeonInfo失败， DungeonIndex对应的大秘境副本信息不存在", DungeonId)
        return
    end

    self.DungeonInfo = DungeonInfo
end

function WBP_Abyss_Select_Item_C:InitBossInfo()
    if not self.DungeonInfo then
        return
    end
    self.BossInfo = {}

    local DungeonMonster = self.DungeonInfo.DungeonMonsters
    for _,MonsterId in pairs(DungeonMonster) do
        local MonsterInfo = DataMgr.Monster[MonsterId]
        if MonsterUtils.IsBoss(MonsterId) then
            local MonsterName = GText(MonsterInfo.UnitName)
            local MonsterIcon
            if MonsterInfo.GalleryRuleId then
                local GalleryData = DataMgr.GalleryRule[MonsterInfo.GalleryRuleId]
                local ImagePath = GalleryData and GalleryData.MonsterIcon
                MonsterIcon = LoadObject(string.format("Texture2D'%s'", ImagePath))
            end
            self.Btn_Enemy:SetBossInfo(nil, MonsterIcon)
            self.BossInfo = {
                BossName = MonsterName,
                BossIcon = MonsterIcon,
            }
            break
        end
    end
end

function WBP_Abyss_Select_Item_C:InitListEntry()
    self.List_Entry:ClearListItems()
    
    local AbyssBuffs = DataMgr.AbyssBuff
    local DungeonEntries = self.DungeonInfo.AbyssBuffID
    if not DungeonEntries then
        DebugPrint("lhr@WBP_Abyss_Lineup_Detail:InitListEntry 大秘境副本的词条列表不存在")
        return
    end

    for _, EntryId in pairs(DungeonEntries) do
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        Obj.IconPath = AbyssBuffs[EntryId].Icon
        self.List_Entry:AddItem(Obj)
    end
end

function WBP_Abyss_Select_Item_C:SetProgressAndAttribute()
    if not self.SelectPage then
        return
    end
    local AbyssId,LevelIndex = self.SelectPage.AbyssId,self.SelectPage.LevelIndex
    --设置奖励进度
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        DebugPrint("WBP_Abyss_Select_Item_C:SetProgressText, 配置面板初始化失败，Avatar无效")
        return
    end
    local AbyssInfo = Avatar.Abysses[AbyssId]
    if not AbyssInfo then
        DebugPrint("lhr@WBP_Abyss_Select_Item_C:InitLevelInfo, AbyssId", AbyssId, "对应的赛季不存在")
        return
    end
    self.IsEndLess = AbyssInfo:IsLoopAbyss()
    local LevelInfo = AbyssInfo.AbyssLevelList[LevelIndex]
    if not LevelInfo then
        DebugPrint("lhr@WBP_Abyss_Select_Item_C:InitLevelInfo, LevelIndex", LevelIndex, "对应的关卡不存在")
        return
    end
    self.AbyssId = AbyssId
    self.LevelId = LevelInfo.AbyssLevelId

    local Now, All = 0, LevelInfo["DungeonReward"..self.DungeonIndex]
    local AbyssProgress = LevelInfo.MaxLockedTeamProgress
    if LevelInfo.IsTeamLocked and AbyssProgress then
        Now = AbyssProgress[self.DungeonIndex]
    end
    self.Text_Get:SetText(Now)
    self.Text_All:SetText(All)

    local AttributeType = DataMgr.AbyssLevel[self.LevelId]["AttributeType"..self.DungeonIndex]
    local Attributes = {}
    if AttributeType then
        Attributes = string.split(AttributeType, ",")
    end
    self.Attributes = Attributes

    if not self.IsEndLess then
        self.WorldText:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Btn_ChangeAttribute:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self:FillAttributeList(Attributes)
    else
        self.WorldText:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Btn_ChangeAttribute:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Btn_ChangeAttribute:Init(Attributes)
        local ChosenAttr = Avatar:GetAbyssAttrType(self.AbyssId)
        local RecAttr = ChosenAttr and DataMgr.Attribute[ChosenAttr].CounterType
        self:FillAttributeList({RecAttr})
        self:SwitchAttribute(ChosenAttr)
    end
end

function WBP_Abyss_Select_Item_C:FillAttributeList(Attributes)
    if not Attributes or not next(Attributes) then
        self.Recommend_Attribute:SetVisibility(UE4.ESlateVisibility.Collapsed)
        return
    end
    self.Recommend_Attribute:FillAttrList(Attributes)
    self.Recommend_Attribute:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
end

function WBP_Abyss_Select_Item_C:SwitchAttribute(Attribute)
    if not Attribute then
        return
    end
    local NewIdx = self.Btn_ChangeAttribute:ChooseAttribute(Attribute)
    if NewIdx ~= -1 then
        local RecAttr = self.Attributes[NewIdx]
        self:FillAttributeList({RecAttr})
        self.Recommend_Attribute:PlayAnimation(self.Recommend_Attribute.Remind)
    end
end

function WBP_Abyss_Select_Item_C:BindEventOnSwitchAttributeBtn(Event)
    self.Btn_ChangeAttribute:BindEventOnClicked(Event, self)
end 

function WBP_Abyss_Select_Item_C:ResetProgress()
    self.Text_Get:SetText(0)
end

function WBP_Abyss_Select_Item_C:BindSelectImg(SelectImg)
    if SelectImg then
        self.SelectImg = SelectImg
    end
end

function WBP_Abyss_Select_Item_C:InitSlots()
    self:ClearAllSlots()
    for SlotName, Slot in pairs(self.Slots) do
        Slot:Init(SlotName, self.SelectPage, self.DungeonIndex, true)
        if SlotName == ESlotName.Phantom1 or SlotName == ESlotName.Phantom2 then
            Slot.WeaponSlot = self.Slots[SlotName+1]
        end
    end
    self.Slots[ESlotName.PhantomWeapon1]:SetForbidden(true)
    self.Slots[ESlotName.PhantomWeapon2]:SetForbidden(true)
end

function WBP_Abyss_Select_Item_C:UpdateSlot(SelectedSlot, Content)
    --默认更新配置面板当前被选中的槽位
    if not Content then
        self:ClearSlot(SelectedSlot)
    else
        self.Slots[SelectedSlot]:Update(Content)
    end
end

function WBP_Abyss_Select_Item_C:SelectSlot(SlotName)
    if self.Slots[SlotName] then
        self.Slots[SlotName]:OnBtnClicked()
    else
        DebugPrint("lhr@WBP_Abyss_Select_Item_C:SelectSlot, SlotName对应的槽位不存在")
    end
end

function WBP_Abyss_Select_Item_C:UnSelectSlot(SlotName)
    if self.Slots[SlotName] then
        self.Slots[SlotName]:SetIsChecked(false)
    end
end

function WBP_Abyss_Select_Item_C:ClearAllSlots()
    for _, Slot in pairs(self.Slots) do
        Slot:Clear()
    end
end

function WBP_Abyss_Select_Item_C:ClearSlot(SlotName)
    if self.Slots[SlotName] then
        self.Slots[SlotName]:Clear()
    end
end

function WBP_Abyss_Select_Item_C:GetCurrentUuid(SlotName)
    if self.Slots[SlotName] then
        return self.Slots[SlotName].Uuid
    end
end

function WBP_Abyss_Select_Item_C:ShowMonsterInfo()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManger = GameInstance:GetGameUIManager()
    if UIManger then
        local MonsterInfoPanel = UIManger:LoadUI(UIConst.LoadInConfig, "MonsterDetailInfo", self.SelectPage.Root:GetZOrder())
        if self.IsEndLess then
            local AttrIdx = self.Btn_ChangeAttribute.CurrentAttrIdx
            local AttrType = self.Attributes[AttrIdx]
            self.SubBtnCallback = function()
                MonsterInfoPanel:SetVisibility(ESlateVisibility.Collapsed)
                self.SelectPage:ShowSwitchAttributePanel(self, self.Btn_ChangeAttribute.CurrentAttrIdx, function()
                    AttrIdx = self.Btn_ChangeAttribute.CurrentAttrIdx
                    AttrType = self.Attributes[AttrIdx]
                    MonsterInfoPanel:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
                    MonsterInfoPanel:InitMonsterWeakness(AttrType)
                    MonsterInfoPanel:RefreshMonsterList()
                    MonsterInfoPanel:PlayOpenAnim()
                    MonsterInfoPanel:SetFocus()
                    MonsterInfoPanel:InitSubBtn(self.SubBtnCallback)
                end)
            end
            MonsterInfoPanel:InitPanel(nil, self.DungeonInfo, AttrType, self.SubBtnCallback)
        else
            MonsterInfoPanel:InitPanel(nil, self.DungeonInfo)
        end
        MonsterInfoPanel.Parent = self.SelectPage
    end
end

function WBP_Abyss_Select_Item_C:ShowEntryPanel()
        local ConfigData={
            Type=self.DungeonIndex,
            AbyssId=self.SelectPage.AbyssId,
            LevelId=self.SelectPage.LevelId
    }
    local New=UIManager(self):LoadUINew("AbyssEntry",ConfigData)
end

local IgnoreHighlightSlots = {
    [ESlotName.PhantomWeapon1] = true,
    [ESlotName.PhantomWeapon2] = true,
    [ESlotName.Phantom1] = true,
    [ESlotName.Phantom2] = true,
}

function WBP_Abyss_Select_Item_C:HighlightEmptySlots()
    for SlotName, Slot in pairs(self.Slots) do
        if not IgnoreHighlightSlots[SlotName] and Slot.IsEmpty then
            Slot:PlayRemindAnim()
        end
        --当魅影已配置，但魅影武器未配置时
        if SlotName == ESlotName.Phantom1 or SlotName == ESlotName.Phantom2 then
            if not Slot.IsEmpty then
                if Slot.WeaponSlot and Slot.WeaponSlot.IsEmpty then
                    Slot.WeaponSlot:PlayRemindAnim()
                end
            end
        end
    end
end


function WBP_Abyss_Select_Item_C:Find(Table,Check)
    for _, value in pairs(Table) do
        if value==Check then
            return true
        end
    end
    return false
end

function WBP_Abyss_Select_Item_C:OnClicked()
    if self.SelectPage then
        self.SelectPage:DungeonSelectionChanged(self.DungeonIndex)
    else
        DebugPrint("lhr@WBP_Abyss_Select_Item_C:OnClicked，阵容配置界面失效")
    end
end

function WBP_Abyss_Select_Item_C:OnForbiddenClicked()

end

function WBP_Abyss_Select_Item_C:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

-------------------------------- 按钮 绑定/解绑 相关 -----------------------------------
function WBP_Abyss_Select_Item_C:BindButtonPerformances()
    self.Btn.OnClicked:Add(self, self.OnBtnClicked)
    self.Btn.OnPressed:Add(self, self.OnBtnPressed)
    self.Btn.OnReleased:Add(self, self.OnBtnReleased)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Btn.OnHovered:Add(self, self.OnBtnHovered)
        self.Btn.OnUnhovered:Add(self, self.OnBtnUnhovered)
    end
end

function WBP_Abyss_Select_Item_C:UnBindButtonPerformances()
    if not self.Btn then
        return
    end
    self.Btn.OnClicked:Clear()
    self.Btn.OnPressed:Clear()
    self.Btn.OnReleased:Clear()
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Btn.OnHovered:Clear()
        self.Btn.OnUnhovered:Clear()
    end
end
-------------------------------- 按钮 Normal Click Press Release Hover UnHover 相关表现 -----------------------------------

----------------------------------------- 按钮 Normal -----------------------------------------------
function WBP_Abyss_Select_Item_C:SwitchNormalAnimation()
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
end

----------------------------------------- 按钮 Click -----------------------------------------------
function WBP_Abyss_Select_Item_C:PlayButtonClickSound()
    AudioManager(self):PlayUISound(self, "event:/ui/activity/drama_challenge_type_select_btn_click",nil,nil)
end

function WBP_Abyss_Select_Item_C:OnBtnClicked()
    self:SetIsChecked(true, true)
    self:OnClicked()
    --end
end
function WBP_Abyss_Select_Item_C:PlayButtonClickAnimation()
    self:StopAllAnimations()
    self:PlayAnimation(self.Click)
end
----------------------------------------- 按钮 Click -----------------------------------------------

----------------------------------------- 按钮 Press -----------------------------------------------
function WBP_Abyss_Select_Item_C:PlayButtonPressAnim()
    self:StopAllAnimations()
    self:PlayAnimation(self.Press)
end

function WBP_Abyss_Select_Item_C:PlayForbiddenButtonPressSound()
    UIUtils.PlayCommonForbiddenBtnSe(self)
end

function WBP_Abyss_Select_Item_C:OnBtnPressed()
    if self.Checked == true then
        return
    end

    self.IsPressing = true
    self:PlayButtonPressAnim()
end
----------------------------------------- 按钮 Press -----------------------------------------------

----------------------------------------- 按钮 Hover -----------------------------------------------
function WBP_Abyss_Select_Item_C:PlayButtonHoverAnim()
    if self.SelectPage then
        if self.SelectPage.UsingGamepad then
            self.SelectPage:SelectDungeon(self.DungeonIndex)
            return
        end
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
end

function WBP_Abyss_Select_Item_C:OnBtnHovered()
    if self.Checked == true then
        return
    end
    self.IsHovering = true
    self:PlayButtonHoverAnim()
end

function WBP_Abyss_Select_Item_C:SetBtnHovered(IsHovered)
    if IsHovered then 
        self:OnBtnHovered()
    else 
        self:OnBtnUnhovered()
    end
end 

----------------------------------------- 按钮 Hover -----------------------------------------------

----------------------------------------- 按钮 Release -----------------------------------------------
function WBP_Abyss_Select_Item_C:PlayButtonReleaseButHoverAnim()
    self:PlayButtonHoverAnim()
end

function WBP_Abyss_Select_Item_C:PlayButtonReleaseAndUnHoverAnim()
    self:PlayButtonUnHoverAnim()
end

function WBP_Abyss_Select_Item_C:OnBtnReleased()
    self.IsPressing = false
    if self.Checked == true then
        return
    end
    if not self.IsHovering then
        self:PlayButtonReleaseAndUnHoverAnim()
    else
        self:PlayButtonReleaseButHoverAnim()
    end
end
----------------------------------------- 按钮 Release -----------------------------------------------

----------------------------------------- 按钮 UnHover -----------------------------------------------
function WBP_Abyss_Select_Item_C:PlayButtonUnHoverAnim()
    self:StopAllAnimations()
    self:PlayAnimation(self.UnHover)
end

function WBP_Abyss_Select_Item_C:OnBtnUnhovered()
    self.IsHovering = false
    if self.Checked == true then
        return
    end
    if not self.IsPressing then
        self:PlayButtonUnHoverAnim()
    end
end
----------------------------------------- 按钮  UnHover -----------------------------------------------

----------------------------------------- 按钮 Locked -----------------------------------------------
function WBP_Abyss_Select_Item_C:PlayButtonUnLockedAnim()
    self:StopAllAnimations()
    self:PlayAnimation(self.UnLockNormal)
end

function WBP_Abyss_Select_Item_C:PlayButtonLockedAnim()
    self:StopAllAnimations()
    self:PlayAnimation(self.Locked)
end

function WBP_Abyss_Select_Item_C:SetLocked(bLocked)
    if bLocked == true then
        self.IsForbidden = true
    else
        self.IsForbidden = false
    end
end
----------------------------------------- 按钮 Checked -----------------------------------------------

function WBP_Abyss_Select_Item_C:SetIsChecked(IsChecked,IsPlaySound)
    if self.Checked == false and IsChecked == true then
        self.Checked = true
        if IsPlaySound then
            self:PlayCheckSound(true)
        end
        self:PlayButtonClickAnimation()
        self:UpdateUIStyle()
    elseif IsChecked == false then
        self.Checked = false
        if IsPlaySound then
            self:PlayCheckSound(false)
        end
        self:SwitchNormalAnimation()
        self:UpdateUIStyle(ECommonInputType.MouseAndKeyboard)
    end
end

function WBP_Abyss_Select_Item_C:PlayCheckSound(IsChecked)
    if IsChecked then
        self:PlayButtonClickSound()
    else
        -- AudioManager(self):PlayUISound(self, "event:/ui/common/click_checkbox_uncheck", nil, nil)
    end
end

function WBP_Abyss_Select_Item_C:InitListenEvent()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
end

function WBP_Abyss_Select_Item_C:UpdateUIStyle(CurInputDevice)
    -- 刷新一些基础信息
    if (IsValid(self.GameInputModeSubsystem)) then
        self:OnUpdateUIStyleByInputTypeChange(CurInputDevice or self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function WBP_Abyss_Select_Item_C:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    if self.SelectPage:IsMobile() then
        return
    end
    --- 切换手柄端相关图标显隐
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if (IsUseKeyAndMouse) then
        if self.SelectImg then
            self.SelectImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        self.Entry_Tip.Controller_Entry:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Btn_Enemy:SwitchUIType(false)
        self.Btn_ChangeAttribute:SwitchUIType(false)
    else
        if self.SelectImg then
            self.SelectImg:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
        self.Entry_Tip.Controller_Entry:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Btn_Enemy:SwitchUIType(true)
        self.Btn_ChangeAttribute:SwitchUIType(true)
    end
end

function WBP_Abyss_Select_Item_C:AddReddotListener(ReddotNodeName,func)
    if self.ListenedReddot then
        return
    end
    self:RemoveReddotListener(ReddotNodeName)
    ReddotManager.AddListener(ReddotNodeName,self, func)
    self.ListenedReddot = true
end

function WBP_Abyss_Select_Item_C:RemoveReddotListener(ReddotNodeName)
    if(self.ListenedReddot) then
        ReddotManager.RemoveListener(ReddotNodeName,self)
        self.Btn_Entry.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.ListenedReddot = false
    end
end

function WBP_Abyss_Select_Item_C:OnEntry1ReddotChange(Count)
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("AbyssEntry1")
    if not CacheDetail[self.SelectPage.AbyssId] then
        self.Btn_Entry.Reddot:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.Btn_Entry.Reddot:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end

function WBP_Abyss_Select_Item_C:OnEntry2ReddotChange(Count)
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("AbyssEntry2")
    if not CacheDetail[self.SelectPage.AbyssId] then
        self.Btn_Entry.Reddot:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.Btn_Entry.Reddot:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end


function WBP_Abyss_Select_Item_C:InitReddot()
    if self.DungeonIndex== 1 then
        if not ReddotManager.GetTreeNode("AbyssEntry1") then
            ReddotManager.AddNode("AbyssEntry1")
        end
        ReddotManager.RemoveListener("AbyssEntry1", self)
        ReddotManager.AddListener("AbyssEntry1",self,self.OnEntry1ReddotChange)
    else
        if not ReddotManager.GetTreeNode("AbyssEntry2") then
            ReddotManager.AddNode("AbyssEntry2")
        end
        ReddotManager.RemoveListener("AbyssEntry2", self)
        ReddotManager.AddListener("AbyssEntry2",self,self.OnEntry2ReddotChange)
    end
end



return WBP_Abyss_Select_Item_C