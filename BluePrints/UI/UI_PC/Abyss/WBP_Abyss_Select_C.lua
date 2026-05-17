local EMCache = require "EMCache.EMCache"

local WBP_Abyss_Select_C = Class({"BluePrints.UI.BP_EMUserWidget_C", "BluePrints.UI.BP_UIState_C"})

local NullUUid = CommonConst.AbyssTeamNoChar
local NullUnitId = CommonConst.AbyssTeamNoPet
local ESlotName = require 'BluePrints.UI.UI_PC.Abyss.WBP_Abyss_Lineup_C'.ESlotName
local SlotName2Type = require 'BluePrints.UI.UI_PC.Abyss.WBP_Abyss_Lineup_C'.SlotName2Type
local SlotType2DataType = require 'BluePrints.UI.UI_PC.Abyss.WBP_Abyss_Lineup_C'.SlotType2DataType

local DungeonName = {
    [1] = GText("Abyss_DungeonA"),
    [2] = GText("Abyss_DungeonB")
}

WBP_Abyss_Select_C.GamepadIcons = 
{
    "Controller_Reset",
    "Controller_Enter",
}

WBP_Abyss_Select_C.SwitchAttributeWidget_P = "WidgetBlueprint'/Game/UI/WBP/Abyss/PC/WBP_Abyss_ChangeAttribute_P.WBP_Abyss_ChangeAttribute_P'"
WBP_Abyss_Select_C.SwitchAttributeWidget_M = "WidgetBlueprint'/Game/UI/WBP/Abyss/Mobile/WBP_Abyss_ChangeAttribute_M.WBP_Abyss_ChangeAttribute_M'"

function WBP_Abyss_Select_C:InitGamepadKeys()
    if self:IsMobile() then
        return
    end
    self.Controller_Select_L:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "A",
            },
        },
        Desc = GText("UI_CTL_Abyss_EditTeam")
    })
    self.Controller_Select_R:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "A",
            },
        },
        Desc = GText("UI_CTL_Abyss_EditTeam")
    })
    self.Icon_Key_Reset:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "LS",
            },
        },
    })
    self.Icon_Key_Enter:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "X",
            },
        },
    })
    self.Controller_AttributeDesc:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "Down",
            },
        },
    })
end

function WBP_Abyss_Select_C:InitSoundFunc()
    self.Btn_Reset:TryOverrideSoundFunc(function()
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small",nil,nil)
    end)
end

function WBP_Abyss_Select_C:Construct()
    self.Platform = CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance)
    self.IsEndLess = false

    self.Text_Reset:SetText(GText("Abyss_ResetFight"))
    self.Text_Lock:SetText(GText("Abyss_PartyLock"))
    self.Text_AttributeDesc:SetText(GText("UI_ElementDes"))
    self.BtnStart:Init(self, self.OnStartButtonClicked, self.ShowTeamConditionNotMetToast)
    self.Btn_Reset:UnBindEventOnClickedByObj(self)
    self.Btn_Reset:BindEventOnClicked(self,self.ShowResetConfirmWindow)
    self.Btn_AttributeDesc:UnBindEventOnClickedByObj(self)
    self.Btn_AttributeDesc:BindEventOnClicked(self,self.ShowAttributeDesc)
    self:InitSoundFunc()
    self:InitGamepadKeys()
	self:RefreshBaseInfo()
    self:InitListenEvent()
    self.Item_L:BindSelectImg(self.Controller_Select_L)
    self.Item_R:BindSelectImg(self.Controller_Select_R)
end

function WBP_Abyss_Select_C:IsMobile()
    return self.Platform == CommonConst.CLIENT_DEVICE_TYPE.MOBILE
end

function WBP_Abyss_Select_C:RefreshWidget()
    self:Enter(self.AbyssId, self.LevelIndex, self.SelectedDungeon)
    self:HighlightEmptySlots()
end

function WBP_Abyss_Select_C:Destruct()
    self.Btn_Reset:UnBindEventOnClickedByObj(self)
    self.Btn_AttributeDesc:UnBindEventOnClickedByObj(self)

    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self,self.RefreshOpInfoByInputDevice) 
    end
end

function WBP_Abyss_Select_C:InitTable()
	self.IsClosing = false
    local AbyssTitle = self.AbyssInfo:Data().AbyssIdName
    self.TabConfigData = {
        TitleName= string.format(GText(AbyssTitle).."·"..string.format(GText("Abyss_LevelName"), self.LevelIndex)),
        DynamicNode={"Back", "BottomKey", "ResourceBar"}, 
        StyleName="Text", OwnerPanel=self.Root, BackCallback=self.Root.OnClickBack,
        BottomKeyInfo = { 
            { 
                GamePadInfoList =  {{
                    Type="Img", 
                    ImgShortPath="Menu", 
                    Owner=self
                }},
                Desc = GText("UI_Keyboard_Map_ShowMonsterInfo"), 
                bLongPress = false,
            },
            { 
                GamePadInfoList =  {{
                    Type="Img", 
                    ImgShortPath="Up", 
                    Owner=self
                }},
                Desc = GText("UI_Switch_Attribute"), 
                bLongPress = false,
            },
            { 
                GamePadInfoList =  {{
                    Type="Img", 
                    ImgShortPath="View", 
                    Owner=self
                }},
                Desc = GText("Abyss_Buff_1"), 
                bLongPress = false,
            },
            { 
                GamePadInfoList =  {{
                    Type="Img", 
                    ImgShortPath="Y", 
                    Owner=self
                }},
                Desc = GText("UI_Mail_Recieve"), 
                bLongPress = false,
            },
            { 
                KeyInfoList = {{
                    Type="Text", 
                    Text="Escape", 
                    ClickCallback=self.OnReturnKeyDown, 
                    Owner=self, 
                }}, 
                GamePadInfoList =  {{
                    Type="Img", 
                    ImgShortPath="B", 
                    ClickCallback=self.OnReturnKeyDown, 
                    Owner=self, 
                }},
                Desc = GText("UI_BACK"), 
                bLongPress = false
            },
        },
    }
    self.Root:InitOtherPageTab(self.TabConfigData, nil, true)
    if not self.Reward then
        self.Reward = UIManager(self):CreateWidget("WidgetBlueprint'/Game/UI/WBP/Abyss/Widget/WBP_Abyss_ResourceBar_Star.WBP_Abyss_ResourceBar_Star'", true)
        self.Root.Com_Tab.Pos_Abyss_Star:AddChildToOverlay(self.Reward)
    end
    self.Reward:Init(self, self.ShowRewardPanel, self:GetRewardProgress())
    self.Root.Com_Tab.Pos_Abyss_Star:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

--LevelIndex:关卡的层数下标,1或2或3；SelectedDungeon:副本下标,1或2
function WBP_Abyss_Select_C:Enter(AbyssId, LevelIndex, SelectedDungeon)
    self:SetFocus()
    self:InitLevelInfo(AbyssId, LevelIndex)
    if not self.TeamMetConditon then
        self.BtnStart:SetForbidden(true)
    else
        self.BtnStart:SetForbidden(false)
        self:PlayRemindAnim()
    end
    local AbyssProgress = self.LevelInfo.MaxLockedTeamProgress
    local AbyssLocked
    local CurrentProgressSum = 0
    for DungeonIndex, DungeonPanel in pairs(self.Dungeons) do
        if DungeonPanel then
            DungeonPanel:Init(DungeonIndex, self, self.DungeonIds[DungeonIndex])
            if self.IsEndLess then
                DungeonPanel:BindEventOnSwitchAttributeBtn(function(DungeonPanel, CurAttrIdx)
                    self:ShowSwitchAttributePanel(DungeonPanel, CurAttrIdx)
                end)
            end
            local Now = 0
            if self.IsTeamLocked and AbyssProgress then
                Now = AbyssProgress[DungeonIndex]
                CurrentProgressSum = CurrentProgressSum + Now
            end
        else
            DebugPrint("lhr@WBP_Abyss_Select_C:Enter, 关卡详情面板初始化失败")
        end
    end
    --当前层总进度是0时，隐藏重置按钮
    if CurrentProgressSum == 0 then
        self.Panel_Reset:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        self.Panel_Reset:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end

    self:InitDungeonAnims()
    self.SelectedDungeon = SelectedDungeon or 1
    self:SelectDungeon(self.SelectedDungeon)

    self.BtnStart:SetText(string.format(GText("Abyss_GoNextDungeon"),DungeonName[self.SelectedDungeon]))

    self:RefreshBaseInfo()
    self:InitDetailPanels()

    if self.IsEndLess then
        self:CheckAttributeSelected()
    end
end

function WBP_Abyss_Select_C:Data()
    return DataMgr.AbyssLevel[self.LevelId]
end

function WBP_Abyss_Select_C:SetRecLevel()
    local TextLv = GText("Abyss_RecLevel")
    local RecLevel = self:Data().RecLevel or ""
    self.Text_Level:SetText(TextLv.."<H>"..RecLevel.."</>")
end

function WBP_Abyss_Select_C:GetRewardProgress()
    local NowReward = self.LevelInfo.MaxAbyssLevelProgress
    local MaxReward = (self.LevelInfo.DungeonReward1 or 0) + (self.LevelInfo.DungeonReward2 or 0)
    return NowReward, MaxReward
end

function WBP_Abyss_Select_C:InitLevelInfo(AbyssId, LevelIndex)
    self.LevelId = nil
    self.AbyssInfo = {}
    self.LevelInfo = {}
    self.DungeonIds = {}
    self.TeamInfos = {}
    self.AbyssId = AbyssId
    self.TeamMetConditon = false
    self.LevelIndex = LevelIndex

    local Avatar = GWorld:GetAvatar()
    if(not Avatar)then
        DebugPrint("WBP_Abyss_Lineup_C:InitLevelInfo, 关卡详情初始化失败:Avatar无效")
        return
    end

    local AbyssInfo = Avatar.Abysses[AbyssId]
    if not AbyssInfo then
        DebugPrint("lhr@WBP_Abyss_Select_C:InitLevelInfo, AbyssId", AbyssId, "对应的赛季不存在")
        return
    end
    self.AbyssInfo = AbyssInfo
    self.IsEndLess = AbyssInfo:IsLoopAbyss()
    local LevelInfo = AbyssInfo.AbyssLevelList[LevelIndex]
    if not LevelInfo then
        DebugPrint("lhr@WBP_Abyss_Select_C:InitLevelInfo, LevelIndex", LevelIndex, "对应的关卡不存在")
        return
    end
    self.LevelInfo = LevelInfo

    self.LevelId = LevelInfo.AbyssLevelId

    if not LevelInfo.AbyssDungeon1 then
        DebugPrint("lhr@WBP_Abyss_Select_C:InitLevelInfo, LevelIndex", LevelIndex, "对应的关卡中未存储副本")
        return
    end
    table.insert(self.DungeonIds, LevelInfo.AbyssDungeon1)
    if LevelInfo.AbyssDungeon2 then
        table.insert(self.DungeonIds, LevelInfo.AbyssDungeon2)
    end

    if (#self.DungeonIds == 1) then
        if (self:IsMobile()) then
            self.Item_R:SetVisibility(UE4.ESlateVisibility.Collapsed)
        else
            self.Overlay_R:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        self.Spacer_42:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Dungeons = {
            [1] = self.Item_L,
        }
    else
        if (self:IsMobile()) then
            self.Item_R:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        else
            self.Overlay_R:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
        self.Item_R:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Spacer_42:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Dungeons = {
            [1] = self.Item_L,
            [2] = self.Item_R,
        }
    end

    self.IsTeamLocked = LevelInfo.IsTeamLocked
    if LevelInfo.IsTeamLocked then
        for i = 1, 2 do
            local TeamInfo = {}
            if LevelInfo.AbyssLockedTeamList[i] then
                self.TeamInfos[i] = TeamInfo
                local UnitIdList = LevelInfo.AbyssLockedTeamList[i].UnitIdList
                TeamInfo.Char = UnitIdList.CharId
                TeamInfo.MeleeWeapon = UnitIdList.MeleeWeaponId
                TeamInfo.RangedWeapon = UnitIdList.RangedWeaponId
                TeamInfo.Pet = UnitIdList.PetId
                TeamInfo.Phantom1 = UnitIdList.PhantomId1
                TeamInfo.Phantom2 = UnitIdList.PhantomId2
                TeamInfo.PhantomWeapon1 = UnitIdList.PhantomWeaponId1
                TeamInfo.PhantomWeapon2 = UnitIdList.PhantomWeaponId2
            end
        end
        self.Panel_Lock:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.TeamMetConditon = true
    else
        if not LevelInfo.AbyssCacheTeamList then
            DebugPrint("lhr@WBP_Abyss_Select_C:InitLevelInfo, LevelIndex", LevelIndex, "对应的关卡中未存储缓存的阵容")
            return
        end
        for _, CachedTeamInfo in ipairs(LevelInfo.AbyssCacheTeamList) do 
            local TeamInfo = {}
            if CachedTeamInfo then
                for SlotName, EName in pairs(ESlotName) do
                    if SlotName ~= "Null" then
                        TeamInfo[SlotName] = CachedTeamInfo[SlotName]
                    end
                end
            end
            table.insert(self.TeamInfos, TeamInfo)
        end
        self.Panel_Lock:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.TeamMetConditon = self:CheckTeamCondition(self.TeamInfos)
    end
    self:AddTimer(1,self.TryShowEntryTip,false,0,nil,true)
    self:SetRecLevel()
end

-- 当前为无尽关时，检查是否已选择弱点属性，否则弹出选择弹窗
function WBP_Abyss_Select_C:CheckAttributeSelected()
    if not self.IsEndLess then return end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local ChosenAttr = Avatar:GetAbyssAttrType(self.AbyssId)
    if not ChosenAttr then
        self:ShowSwitchAttributePanel(self.CurDungeonPanel, nil, function(AttrType)
            self.CurDungeonPanel:ShowMonsterInfo()
        end)
    end
end

function WBP_Abyss_Select_C:CheckTeamCondition(TeamInfos)
    local Avatar = GWorld:GetAvatar()
    if(not Avatar)then
        DebugPrint("WBP_Abyss_Lineup_C:CheckTeamCondition, 关卡详情初始化失败:Avatar无效")
        return
    end
    for _, Team in pairs(TeamInfos) do
        if not Team.Char or not Avatar.Chars[Team.Char] then
            return false
        end
        if not Team.MeleeWeapon or not Avatar.Weapons[Team.MeleeWeapon] then
            return false
        end
        if not Team.RangedWeapon or not Avatar.Weapons[Team.RangedWeapon] then
            return false
        end
        if Team.Phantom1 and Team.Phantom1 ~= CommonConst.AbyssTeamNoChar then
            if not Avatar.Chars[Team.Phantom1] then
                return false
            end
            if not Team.PhantomWeapon1 or not Avatar.Weapons[Team.PhantomWeapon1] then
                return false
            end
        end
        if Team.Phantom2 and Team.Phantom2 ~= CommonConst.AbyssTeamNoChar then
            if not Avatar.Chars[Team.Phantom2] then
                return false
            end
            if not Team.PhantomWeapon2 or not Avatar.Weapons[Team.PhantomWeapon2] then
                return false
            end
        end
        if not Team.Pet or not Avatar.Pets[Team.Pet] then
            return false
        end
    end
    return true
end

function WBP_Abyss_Select_C:InitDungeonAnims()
    if self.Dungeons then
        for _, DungeonPanel in pairs(self.Dungeons) do
            if self.IsTeamLocked then
                DungeonPanel:SetLocked(true)
            else
                DungeonPanel:SetLocked(false)
            end
        end
    end
end

function WBP_Abyss_Select_C:SelectDungeon(SelectedDungeon)
    local Dungeon = self.Dungeons[SelectedDungeon]
    if Dungeon then
        Dungeon:OnBtnClicked()
    end
end

function WBP_Abyss_Select_C:DungeonSelectionChanged(SelectedDungeon)
    for DungeonIndex, DungeonPanel in pairs(self.Dungeons) do
        if SelectedDungeon ~= DungeonIndex then
            DungeonPanel:SetIsChecked(false)
        end
    end
    self.SelectedDungeon = SelectedDungeon
    self.CurDungeonPanel = self.Dungeons[SelectedDungeon]
    self.BtnStart:SetText(string.format(GText("Abyss_GoNextDungeon"),DungeonName[self.SelectedDungeon]))
end

function WBP_Abyss_Select_C:InitDetailPanels()
    local Avatar = GWorld:GetAvatar()
    if(not Avatar)then
        DebugPrint("WBP_Abyss_Lineup_C:InitDetailPanels, 关卡详情初始化失败:Avatar无效")
        return
    end
    self.CurSlotName = ESlotName.Null
    self.DisableList = {}
    for SlotName, EName in pairs(ESlotName) do
        for DungeonIndex, DungeonPanel in pairs(self.Dungeons) do
            local UnitId = self.TeamInfos[DungeonIndex][SlotName]
            if UnitId and self:CheckUnit(UnitId) then
                local SlotType = SlotName2Type[EName]
                local DataType = SlotType2DataType[SlotType]
                local UnitData
                if self.LevelInfo.IsTeamLocked then
                    local DataTable = DataMgr[DataType]
                    UnitData = DataTable and DataTable[UnitId]
                else
                    local Unit = Avatar[DataType.."s"][UnitId]
                    if not Unit then
                        if not self.DisableList[DungeonIndex] then
                            self.DisableList[DungeonIndex] = {}
                        end
                        table.insert(self.DisableList[DungeonIndex], SlotName)
                        self.TeamInfos[DungeonIndex][SlotName] = SlotName == "Pet" and NullUnitId or NullUUid
                    end
                    UnitData = Unit and Unit:Data()
                end
                local Content = UnitData and {
                    Type = DataType,
                    Icon = UnitData.Icon,
                    Rarity = UnitData.Rarity or UnitData[DataType.."Rarity"],
                    GachaIcon = UnitData.GachaIcon
                }
                if Content and DataType == "Weapon" then
                    local Tags = {CommonConst.ArmoryTag.Melee,CommonConst.ArmoryTag.Ranged}
                    for _, WeaponTag in pairs(Tags) do
                        if SlotType == WeaponTag then
                            Content.Tag = WeaponTag
                            break
                        end
                    end
                end
                DungeonPanel:UpdateSlot(EName, Content)
            end
        end
    end
    self:AddTimer(self.In:GetEndTime(), function()
        self:ShowDisableItemPopUp()
    end)
end

function WBP_Abyss_Select_C:CheckUnit(UnitId)
    if type(UnitId) == "number" then
        return UnitId ~= NullUnitId
    else
        return UnitId ~= NullUUid
    end
end

function WBP_Abyss_Select_C:SlotSelectionChanged(SlotName, DungeonIndex)
    local bSlotChanged = false
    local PreDungeonIndex = self.SelectedDungeon
    if DungeonIndex ~= PreDungeonIndex then
        self:SelectDungeon(DungeonIndex)
        bSlotChanged = true
    end

    local PreSlotName = self.CurSlotName
    self.CurSlotName = SlotName

    --若与之前选中的配置槽不同，则重新初始化数据
    if(self.CurSlotName ~= PreSlotName) then
        bSlotChanged = true
    end

    if bSlotChanged then
        self.Dungeons[PreDungeonIndex]:UnSelectSlot(PreSlotName)
    end
    if self.IsTeamLocked then
        self:ShowUnLockConfirmWindow()
        return
    end
    local LevelParams = {
        AbyssId = self.AbyssId,
        LevelIndex = self.LevelIndex,
        DungeonIds = self.DungeonIds,
        TeamInfos = self.TeamInfos
    }
    self.Root:OpenSubUI({Idx = "AbyssLineup"}, LevelParams, DungeonIndex, SlotName)
end

function WBP_Abyss_Select_C:HighlightEmptySlots()
    for _, DungeonPanel in pairs(self.Dungeons) do
        DungeonPanel:HighlightEmptySlots()
    end
end

function WBP_Abyss_Select_C:InitListenEvent()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice) 
    end
end

function WBP_Abyss_Select_C:RefreshBaseInfo()
    -- 刷新一些基础信息
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function WBP_Abyss_Select_C:BP_GetDesiredFocusTarget()
    self:SetFocusTarget()
    return nil
end

function WBP_Abyss_Select_C:SetFocusTarget()
    if not self:HasFocusedDescendants() and not self:HasAnyUserFocus() then
        return
    end
    if self.SwitchAttrPanel then
        self.SwitchAttrPanel:SetFocus()
        return
    end
    if self.CurDungeonPanel ~= nil then
        self.CurDungeonPanel:SetFocus()
    end
    -- self.GameInputModeSubsystem:SetTargetUIFocusWidget(self.CurDungeonPanel)
    -- self.GameInputModeSubsystem:UpdateCurrentFocusWidgetPos()
end

function WBP_Abyss_Select_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    --- 切换手柄端相关图标显隐
    if (self:IsMobile()) then
        -- 触控模式即默认样式，不需要刷新
        return
    end

    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if (IsUseKeyAndMouse) then
        self.UsingGamepad = false
        self.Btn_Reset:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        for _, IconName in pairs(self.GamepadIcons) do
            if self[IconName] then
                self[IconName]:SetVisibility(UE4.ESlateVisibility.Hidden)
            end
        end
        self.WS_Controller:SetActiveWidgetIndex(0)
    else
        self.UsingGamepad = true
        self.Btn_Reset:SetVisibility(UE4.ESlateVisibility.Collapsed)
        for _, IconName in pairs(self.GamepadIcons) do
            if self[IconName] then
                self[IconName]:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            end
        end
        self.WS_Controller:SetActiveWidgetIndex(1)
        self:SetFocusTarget()
    end
    if self.CurDungeonPanel then
        self.CurDungeonPanel:UpdateUIStyle()
    end
end

function WBP_Abyss_Select_C:OnItemHovered(DungeonIndex)
    if self.UsingGamepad then
        self:SelectDungeon(DungeonIndex)
    end
end

function WBP_Abyss_Select_C:PlayRemindAnim()
    self:PlayAnimation(self.Remind)
end

function WBP_Abyss_Select_C:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if (InKeyName == "Gamepad_FaceButton_Bottom") then
            self:SlotSelectionChanged(nil, self.SelectedDungeon)
            IsHandled = true
        elseif (InKeyName == "Gamepad_DPad_Up") then
            if not self.CurDungeonPanel.Btn_ChangeAttribute.IsPressing then
                self.CurDungeonPanel.Btn_ChangeAttribute:OnBtnPressed()
            end
        end
    end
    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function WBP_Abyss_Select_C:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = true

    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if (InKeyName == "Gamepad_Special_Right") then
            if not self.CurDungeonPanel.Btn_Enemy.IsPressing then
                self.CurDungeonPanel.Btn_Enemy:OnBtnPressed()
            end
        elseif (InKeyName == "Gamepad_Special_Left") then
            if not self.CurDungeonPanel.Btn_Entry.IsPressing then
                self.CurDungeonPanel.Btn_Entry:OnBtnPressed()
            end
        elseif (InKeyName == "Gamepad_FaceButton_Right") then
            self:OnReturnKeyDown()
        elseif (InKeyName == "Gamepad_FaceButton_Top") then
            if self.Reward then
                if not self.Reward.IsPressing then
                    self.Reward:OnBtnPressed()
                end
            end
        elseif (InKeyName == "Gamepad_FaceButton_Left") then
            self.BtnStart:OnBtnPressed()
        elseif (InKeyName == "Gamepad_LeftThumbstick") then
            if self.Panel_Reset:IsVisible() then
                AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small",nil,nil)
                self:ShowResetConfirmWindow()
            end
        else
            IsHandled = false
        end
    else
        if (InKeyName == "Escape") then
            self:OnReturnKeyDown()
        else
            IsHandled = false
        end
    end
    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function WBP_Abyss_Select_C:OnKeyUp(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = true

    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if (InKeyName == "Gamepad_Special_Right") then
            self.CurDungeonPanel.Btn_Enemy:OnBtnReleased()
            self.CurDungeonPanel.Btn_Enemy:OnBtnClicked()
        elseif (InKeyName == "Gamepad_Special_Left") then
            self.CurDungeonPanel.Btn_Entry:OnBtnReleased()
            self.CurDungeonPanel.Btn_Entry:OnBtnClicked()
        elseif (InKeyName == "Gamepad_FaceButton_Top") then
            if self.Reward then
                self.Reward:OnBtnReleased()
                self.Reward:OnBtnClicked()
            end
        elseif (InKeyName == "Gamepad_FaceButton_Left") then
            self.BtnStart:OnBtnReleased()
            self.BtnStart:OnBtnClicked()
        elseif (InKeyName == "Gamepad_DPad_Up") then
            if self.CurDungeonPanel.Btn_ChangeAttribute.IsPressing then
                self.CurDungeonPanel.Btn_ChangeAttribute:OnBtnReleased()
                self.CurDungeonPanel.Btn_ChangeAttribute:OnBtnClicked()
            end
        elseif (InKeyName == "Gamepad_DPad_Down") then
            self:ShowAttributeDesc()
        else
            IsHandled = false
        end
    else
        IsHandled = false
    end
    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function WBP_Abyss_Select_C:OnReturnKeyDown()
	--AudioManager(self):SetEventSoundParam(self,"AbyssMainOpenSound",{ToEnd=1})
	-- self.IsClosing = true
	-- if self.IsFromJump then
	-- 	self.Root:Close()
	-- else
	-- 	self.Root:InitMainTab()
	-- 	self.Root:SelectTabByWidgetName("PlayCommon")
	-- end
    self.Root:OpenSubUI(self.PreWidgetInfo,false,self.AbyssId,true)
end

local AttributePopupId = 100241

function WBP_Abyss_Select_C:ShowAttributeDesc()
    local Params = {
        RightCallbackFunction = function()
            
        end
    }
    UIManager(self):ShowCommonPopupUI(AttributePopupId, Params)
end

function WBP_Abyss_Select_C:ShowRewardPanel()
    local Params={}
    local ConfigData={
        Items = {},
         ShowIcon=true,
         IconPath="PaperSprite'/Game/UI/Texture/Static/Atlas/Abyss/T_Abyss_Star02.T_Abyss_Star02'",
         Text_Total="Abyss_RewardProgress_Difficulty",
         ReceiveAllCallBack=self.GetAllRewards,
         ReceiveAllParam={SelectAbyssId=self.AbyssId},
         SortType=2,
         Rewards={},
         NowNum=0,
         NumMax=0,
         ReceiveButtonText="UI_Achievement_GetAllReward",
         OnlyShowNowProgress =true,
    }
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local Abyss = Avatar.Abysses[self.AbyssId]
        if DataMgr.AbyssSeason[self.AbyssId] then
            ConfigData.NowNum=Abyss:GetAllPassRoomCount()
            local RewardList=DataMgr.AbyssSeason[self.AbyssId].AbyssRewardList
            local Pre
            local Rewards={}
            local Item
            for _, RewardId in ipairs(RewardList) do
                local RewardItem=DataMgr.AbyssRewardList[RewardId]
                if RewardItem then
                    if Pre and Pre.RewardAddOn then
                        local Level=Pre.Level
                        while (Level<RewardItem.Level) do
                            local NewItem=CommonUtils.DeepCopy(Item)
                            NewItem.SourceNum= Level
                            NewItem.ItemId=Level
                            NewItem.CanReceive=Abyss:CheckRewardCanGet(Level)
                            NewItem.RewardsGot=Abyss:CheckRewardIsGot(Level)
                            table.insert(ConfigData.Items,NewItem)
                            Level=Level+Pre.RewardAddOn
                        end
                    end
                    Item={
                        Text = GText("UI_ModGuideBook_RewardView"),
                        ItemId = RewardId,
                        CanReceive=Abyss:CheckRewardCanGet(RewardItem.Level),
                        RewardsGot= Abyss:CheckRewardIsGot(RewardItem.Level),
                        InProgress=false,
                        ReWards={
                                },
                        Nums=1,
                        ShowIcon=true,
                        IconPath="PaperSprite'/Game/UI/Texture/Static/Atlas/Abyss/T_Abyss_Star02.T_Abyss_Star02'",
                        NotreachText="UI_GameEvent_ToBeFinished",
                        Hint="Abyss_RewardList_Content",
                        ReceiveCallBack=self.GetRewards,
                        LeftAligned=true,
                        SourceNum=RewardItem.Level,
                        ReceiveButtonText="UI_Achievement_GetReward",
                        ReceiveParm={
                            SelectAbyssId=self.AbyssId
                        }
                    }
                    Rewards={}
                    local RewardItemId=RewardItem.Reward
                    local RewardInfo = DataMgr.Reward[RewardItemId]
                    if RewardInfo then
                        local Ids = RewardInfo.Id or {}
                        local RewardCount = RewardInfo.Count or {}
                        local TableName = RewardInfo.Type or {}
                        for i = 1, #Ids do
                            local ItemId = Ids[i]
                            local Count = RewardUtils:GetCount(RewardCount[i])
                            local Rarity = ItemUtils.GetItemRarity(ItemId, TableName[i])
                            local ItemType = TableName[i]
                            local RewardContent = {
                                ItemType = ItemType,
                                ItemId = ItemId,
                                Count = Count,
                                Rarity = Rarity,
                            }
                            table.insert(Rewards, RewardContent)
                        end
                    end
                    Item.Rewards=Rewards
                    Pre=DataMgr.AbyssRewardList[RewardId]
                    if RewardItem.RewardAddOn==nil then
                        table.insert(ConfigData.Items,Item)
                    end
                end
            end
            ConfigData.NumMax=Pre.Level
            ConfigData.NumMax=tostring(ConfigData.NumMax)
            if Pre and Pre.RewardAddOn then
                table.insert(ConfigData.Items,Item)
                if ConfigData.NowNum >Pre.Level then
                    local Level=Pre.Level+Pre.RewardAddOn
                    --奖励无限循环，额外添加5个显示
                    local FinialLevel=ConfigData.NowNum+Pre.RewardAddOn*5
                        while (Level<=FinialLevel) do
                            local NewItem=CommonUtils.DeepCopy(Item)
                            NewItem.SourceNum= Level
                            NewItem.ItemId=Level
                            NewItem.CanReceive=Abyss:CheckRewardCanGet(Level)
                            NewItem.RewardsGot=Abyss:CheckRewardIsGot(Level)
                            table.insert(ConfigData.Items,NewItem)
                            Level=Level+Pre.RewardAddOn
                        end
                        ConfigData.NumMax=tostring(Level-Pre.RewardAddOn)
                end
                local NewItem={}
                NewItem.NeedSwitchType = true
                NewItem.EmptyHint = "Abyss_Infinite_ProgressReward_Lock"
                table.insert(ConfigData.Items,NewItem)
            end
            Params.ConfigData=ConfigData
        end
    end
    local TitleText=DataMgr.AbyssSeason[self.AbyssId].AbyssRewardListTitle
    Params.Title=GText(TitleText)
      local AbyssInfo = DataMgr.AbyssSeason[self.AbyssId]
    local AbyssSeasonId = AbyssInfo.AbyssSeasonId
    if AbyssSeasonId then
        local AbyssSeasonInfo = DataMgr.AbyssSeasonList[AbyssSeasonId]
        local AbyssEndTime = AbyssSeasonInfo.AbyssEndTime
        if AbyssEndTime then
            local RemainTime=AbyssEndTime-TimeUtils.NowTime()
            Params.TitleWidget = "DiaglogTitle_Time"
            Params.CountDownParams={Name=nil,RemainTime=RemainTime}
        end
    end
    UIManager(self):ShowCommonPopupUI(100158,Params,self)
end

local TeamErrorCodes = {
    [ErrorCode.RET_ABYSS_TEAM_NO_CHAR] = true,
    [ErrorCode.RET_ABYSS_TEAM_NO_MELEEWEAPON] = true,
    [ErrorCode.RET_ABYSS_TEAM_NO_RANGEDWEAPON] = true,
    [ErrorCode.RET_ABYSS_TEAM_PHANTOM_NO_WEAPON] = true,
    [ErrorCode.RET_ABYSS_TEAM_PET_NOT_OWNED] = true,
}

function WBP_Abyss_Select_C:EnterDungeon()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        DebugPrint("lhr@关卡详情界面进入关卡失败，Avatar获取失败")
        return
    end

    --处理进入副本服务器返回值
    local Callback = function(RetCode)
        if RetCode == ErrorCode.RET_SUCCESS then
            UIManager(self):ShowUITip(UIConst.Tip_CommonTop,"成功进入"..DungeonName[self.SelectedDungeon])
            self.IsTeamLocked = self:GetTeamLockState()

            -- 进副本前缓存相关信息，用于退出副本时弹出此界面
            local ExitDungeonInfo = {
                Type = "Abyss",
                AbyssId = self.AbyssId,
                AbyssLevelId = self.LevelIndex,
                AbyssDungeonIndex = self.SelectedDungeon,
            }
            GWorld.GameInstance:SetExitDungeonData(ExitDungeonInfo)

            DebugPrint("lhr@Locked",self.IsTeamLocked)
        else
            if DataMgr.ErrorCode[RetCode] then
                local ErrorContent = DataMgr.ErrorCode[RetCode].ErrorCodeContent
                if TeamErrorCodes[RetCode] then
                    UIManager(self):ShowUITip(UIConst.Tip_CommonTop,GText("Abyss_PartySetup_ConditionsAreNot"))
                else
                    UIManager(self):ShowUITip(UIConst.Tip_CommonTop,ErrorContent.."(Debug用)")
                end
            end
            self:HighlightEmptySlots()
        end
        self:InitDungeonAnims()
    end

    GWorld.GameInstance.PreAbyssLevelProgress = self.LevelInfo.MaxAbyssLevelProgress

    Avatar:TriggerEnterAbyss(Callback, self.AbyssId, self.LevelIndex, self.SelectedDungeon)
end

function WBP_Abyss_Select_C:ResetLineup()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        DebugPrint("lhr@关卡详情界面解锁失败：Avatar获取失败")
        return
    end

    --处理进入副本服务器返回值
    local Callback = function(RetCode)
        if RetCode == ErrorCode.RET_SUCCESS then
            UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("Abyss_PartyUnlock"))
            self.IsTeamLocked = self:GetTeamLockState()
            DebugPrint("lhr@Locked",self.IsTeamLocked)
            if self.Dungeons then
                for DungeonIndex, DungeonPanel in pairs(self.Dungeons) do
                    if not self.IsTeamLocked then
                        DungeonPanel:SetLocked(false)
                        DungeonPanel:ResetProgress()
                    end
                end
            end
            self:InitLevelInfo(self.AbyssId, self.LevelIndex)
            self:InitDetailPanels()
        else
            if DataMgr.ErrorCode[RetCode] then
                local ErrorContent = DataMgr.ErrorCode[RetCode].ErrorCodeContent
                UIManager(self):ShowUITip(UIConst.Tip_CommonTop,ErrorContent)
            end
        end
    end

    Avatar:UnLockAbyssTeam(Callback, self.AbyssId, self.LevelIndex)
end

function WBP_Abyss_Select_C:GetTeamLockState()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        DebugPrint("lhr@阵容配置界面获取锁定状态失败：Avatar获取失败")
        return
    end

    return Avatar.Abysses[self.AbyssId].AbyssLevelList[self.LevelIndex].IsTeamLocked
end

function WBP_Abyss_Select_C:ShowResetConfirmWindow()
    ---@type Common_Dialog_Params
    local CommonDialogParams = {}
    CommonDialogParams.RightCallbackFunction = function() 
        self:ResetLineup()
    end
    
    self:ShowConfirmWindow(100150, CommonDialogParams, self.Root)
end

function WBP_Abyss_Select_C:OnStartButtonClicked()
    if self.IsTeamLocked then
        self:EnterDungeon()
    else
        self:ShowLockConfirmWindow()
    end
end

function WBP_Abyss_Select_C:ShowLockConfirmWindow()
    ---@type Common_Dialog_Params
    local CommonDialogParams = {}
    CommonDialogParams.RightCallbackFunction = function() 
        self:EnterDungeon()
    end
    local PopupData = DataMgr.CommonPopupUIContext[100147]
    CommonDialogParams.ShortText = string.format(GText(PopupData.PopoverText), DungeonName[self.SelectedDungeon])
    
    self:ShowConfirmWindow(100147, CommonDialogParams, self.Root)
end

function WBP_Abyss_Select_C:ShowUnLockConfirmWindow()
    ---@type Common_Dialog_Params
    local CommonDialogParams = {}
    CommonDialogParams.RightCallbackFunction = function() 
        self:ResetLineup()
    end
    self:ShowConfirmWindow(100148, CommonDialogParams, self.Root)
end

function WBP_Abyss_Select_C:ShowConfirmWindow(PopupId, Params, ParentWidget)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    UIManager:ShowCommonPopupUI(PopupId, Params, ParentWidget)
end

function WBP_Abyss_Select_C:ShowTeamConditionNotMetToast()
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop,GText("Abyss_PartySetup_ConditionsAreNot"))
    self:HighlightEmptySlots()
end

function WBP_Abyss_Select_C:ShowSwitchAttributePanel(DungeonPanel, CurAttrIdx, CloseCallback)
    if not DungeonPanel then return end
    local WidgetPath = nil
    if (self:IsMobile()) then
        WidgetPath = self.SwitchAttributeWidget_M
    else
        WidgetPath = self.SwitchAttributeWidget_P
    end
    self.SwitchAttrPanel = UIManager(self):CreateWidget(WidgetPath,true,self.Root:GetZOrder())
    if not IsValid(self.SwitchAttrPanel) then
        return
    end
    local ConfrimFunc = function(Attribute)
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            Avatar:ChooseAbyssAttrType(self.AbyssId, Attribute)
        end
        DungeonPanel:SwitchAttribute(Attribute)
    end
    local CloseFunc = function(Attribute)
        self.SwitchAttrPanel = nil
        self:SetFocus()
        if CloseCallback then
            CloseCallback(Attribute)
        end
    end
    self.SwitchAttrPanel:Init(DungeonPanel.BossInfo, DungeonPanel.Attributes, CurAttrIdx, ConfrimFunc, CloseFunc)
end

function WBP_Abyss_Select_C:SwitchIn(...)
    local IsBack, AbyssId, LevelIndex, DungeonId = ...
    if IsBack then
        self:RefreshWidget()
    else
        self:Enter(AbyssId, LevelIndex, DungeonId)
    end
    self:InitTable()
    self:StopAnimation(self.In)
    self:StopAnimation(self.Out)
    self:PlayAnimation(self.In)
    self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

function WBP_Abyss_Select_C:SwitchOut()
    self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Root.Com_Tab.Pos_Abyss_Star:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if not self.BindOutAnimation then
        self:BindToAnimationFinished(self.Out, {self,function()
            self:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
        })
        self.BindOutAnimation = true
    end
    if self.SwitchAttrPanel then
        self.SwitchAttrPanel:Close()
        self.SwitchAttrPanel = nil
    end
    self:PlayAnimation(self.Out)
end

function WBP_Abyss_Select_C:GetRewards(Content)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local function CallBack(Ret,Reward)
            local Abyss = Avatar.Abysses[Content.ConfigData.ReceiveParm.SelectAbyssId]
            Content.ConfigData.CanReceive=Abyss:CheckRewardCanGet(Content.ConfigData.SourceNum)
            Content.ConfigData.RewardsGot=Abyss:CheckRewardIsGot(Content.ConfigData.SourceNum)
            Content.SelfWidget:RefreshBtn(Ret==0)
            Content.Owner:RefreshButton(Abyss:CheckHaveRewardToGet())
        end
        Avatar:GetAbyssReward(Content.ConfigData.ReceiveParm.SelectAbyssId,Content.ConfigData.SourceNum,CallBack)
    end

end

function WBP_Abyss_Select_C:GetAllRewards(ReceiveAllParm)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local function CallBack(Ret,Reward)
            local HaveReWardToGet=false
            for i = 0,ReceiveAllParm.SelfWidget.List_Item:GetNumItems() - 1 do
                local Item = ReceiveAllParm.SelfWidget.List_Item:GetItemAt(i)
                local Abyss = Avatar.Abysses[ReceiveAllParm.SelectAbyssId]
                local CanReceive=Abyss:CheckRewardCanGet(Item.ConfigData.SourceNum)
                local IsGot=Abyss:CheckRewardIsGot(Item.ConfigData.SourceNum)
                if CanReceive then
                    HaveReWardToGet=true
                end
                Item.ConfigData.CanReceive=CanReceive
                Item.ConfigData.IsGot=IsGot
                if Item.SelfWidget then
                    Item.SelfWidget:RefreshBtn(IsGot)
                end
            end
            ReceiveAllParm.SelfWidget:RefreshButton(HaveReWardToGet)
        end
        Avatar:GetAbyssAllReward(ReceiveAllParm.SelectAbyssId,CallBack)
    end
end

function WBP_Abyss_Select_C:OnFocusReceived(MyGeometry, InFocusEvent)
    self:SetFocusTarget()
    return UIUtils.Handle
end

---- 阵容改变相关 ----
function WBP_Abyss_Select_C:ShowDisableItemPopUp()
    local Avatar = GWorld:GetAvatar()
    local ItemInfo = {}
    for Index, Slots in pairs(self.DisableList) do
        local LevelList = Avatar.Abysses[self.AbyssId].AbyssLevelList[self.LevelIndex]
        local AbyssTeamData = LevelList.AbyssCacheTeamList[Index].UnitIdList
        for _, SlotName in ipairs(Slots) do
            local Id 
            local ItemType
            local Rarity
            local Icon
            if SlotName == "MeleeWeapon" then
                Id = AbyssTeamData.MeleeWeaponId
            elseif SlotName == "RangedWeapon" then
                Id = AbyssTeamData.RangedWeaponId
            elseif SlotName == "PhantomWeapon1" then
                Id = AbyssTeamData.PhantomWeaponId1
            elseif SlotName == "PhantomWeapon2" then
                Id = AbyssTeamData.PhantomWeaponId2
            elseif SlotName == "Pet" then
                Id = AbyssTeamData.PetId
            end
            if string.match(SlotName, "Weapon") then
                ItemType = "Weapon"
                Rarity = DataMgr.Weapon[Id].WeaponRarity
                Icon = DataMgr.Weapon[Id].Icon
            else
                ItemType = "Pet"
                Rarity = DataMgr.Pet[Id].Rarity
                Icon = DataMgr.Pet[Id].Icon
            end
            table.insert(ItemInfo, {Id = Id, ItemType = ItemType, Rarity = Rarity, Icon = Icon})
        end
    end
    if #ItemInfo > 0 then
        local Params = {
            Text = GText("Abyss_PartyDelete"),
            ItemList = ItemInfo,
        }
        UIManager(self):ShowCommonPopupUI(100187, Params, self)
        Avatar:SaveAbyssTeam(nil, self.AbyssId, self.LevelIndex, self.TeamInfos)
        self.BtnStart:SetForbidden(true)
    end
end

function WBP_Abyss_Select_C:TryShowEntryTip()
    local CacheDetail1 = ReddotManager.GetLeafNodeCacheDetail("AbyssEntry1")
    local CacheDetail2 = ReddotManager.GetLeafNodeCacheDetail("AbyssEntry2")
    if CacheDetail1[self.AbyssId] or  CacheDetail2[self.AbyssId] then
        local ConfigData={
            Type=4,
            AbyssId=self.AbyssId,
            LevelId=self.LevelId
        }
        if DataMgr.AbyssLevel[self.LevelId+1] then
            local New=UIManager(self):LoadUINew("AbyssEntry",ConfigData)
        else
            self:DecreaseReddotDetail("AbyssEntry2",self.LevelId+1)
            self:DecreaseReddotDetail("AbyssEntry1",self.LevelId+1)
        end
    end
end

function WBP_Abyss_Select_C:DecreaseReddotDetail(ReddotName,AbyssId)
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotName)
    if CacheDetail and CacheDetail[AbyssId] then
        CacheDetail[AbyssId] = nil
        ReddotManager.DecreaseLeafNodeCount(ReddotName)
    end
end
return WBP_Abyss_Select_C