--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local MonsterUtils = require "Utils.MonsterUtils"
local RewardModel = require "BluePrints.UI.WBP.Activity.Widget.Fort.WBP_Activity_Fort_Reward_Model"

---@type WBP_Activity_Fort_Task_P_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Super.Construct(self)
    self.Avatar = GWorld:GetAvatar()
    self.MonsterIdToItem = {}
    self.Buff_Item_3 = self.Buff_Weapon
    self.Buff_Normal = self.Buff_Item_1
    self.LIst_Tab.BP_OnEntryInitialized:Clear()
    self.LIst_Tab.BP_OnEntryInitialized:Add(self,self.OnObjectSetFinished)
    self.LIst_Tab.BP_OnItemSelectionChanged:Add(self, self.OnSelectItemChanged)

    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
    self:InitListenEvent()
    self:InitWidgetInfoInGamePad()
    -- self:SetNavigationRuleCustom(EUINavigation.Up,{self,self.OnUINavigation})
    -- self:SetNavigationRuleCustom(EUINavigation.Down,{self,self.OnUINavigation})
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
    self.LIst_Tab.BP_OnEntryInitialized:Remove(self,self.OnObjectSetFinished)
    self:ClearListenEvent()
    self.Super.Destruct(self)
end

function M:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function M:ClearListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
    end
end

function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    self:InitNormalInfo()
    self:InitBuffItem()
    self:HideWhenNoSelece()
	self:InitLevelList()
	self:InitTab()
	self:InitBtn()
    self:PlayInAnimation()
    self.CurSelectIndex = ...
end

function M:OpenReward()
    RewardModel:OpenReward(self, self.CurSelectContent.DungeonId)
end

function M:InitBtn()
    self.Btn_Start:SetText(GText("UI_HardBoss_Track"))
    self.Btn_Start:BindEventOnClicked(self,self.EnterPaotaiGame)
    self.Fort_TaskProgress:SetText(GText("Event_RewardTitle_103007"))
    self.Fort_TaskProgress:BindEventOnClicked(self,self.OpenReward)
end

function M:InitNormalInfo()
    self.CurEventId = DataMgr.PaotaiEventConstant.PaotaiGameEventId.ConstantValue
    self.Text_EnemyPre:SetText(GText("UI_DUNGEON_MonsterType"))
    self.Text_Item:SetText(GText("PaotaiGame_Prop"))
    self.Text_Weapon:SetText(GText("PaotaiGame_Weapon"))
    self.Text_Desc:SetText(GText("Event_Des_103007"))
    self.Btn_More.Btn_Click.OnClicked:Add(self, self.SelectFirstMonsterInfoItem)
end

function M:InitBuffItem()
    for i=1,3 do
        if i == 3 then
            local ClickEvent = {
                Obj = self,
                Func = self.ClickBuffItem,
                Params = {self["Buff_Item_"..i],"Weapon"}
            }
            self["Buff_Item_"..i]:Init(ClickEvent, false, "Weapon", true, i, nil, true)
        else
            local ClickEvent = {
                Obj = self,
                Func = self.ClickBuffItem,
                Params = {self["Buff_Item_"..i],"Normal"}
            }
            self["Buff_Item_"..i]:Init(ClickEvent, false, "Normal", true, i, nil, true)
        end
    end
    self:RefreshBuffItem()
end

function M:RefreshBuffItem()
    if self.Avatar.PaotaiBuffs then
        for i=1,3 do
            self["Buff_Item_"..i]:InitBuffInfo(self.Avatar.PaotaiBuffs[i])
            self["Buff_Item_"..i]:InitBuffReddotAndNew(self.Avatar.PaotaiBuffs[i])
        end
    end
end

function M:HideWhenNoSelece()
    self.SizeBox_Info:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Panel_Buff:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Start:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:ShowWhenSelece()
    self.SizeBox_Info:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Panel_Buff:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Btn_Start:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:InitLevelList()
    local PaotaiMiniGameInfo = DataMgr.PaotaiMiniGame
    self.LevelsInfo = {}
    for _,Info in pairs(PaotaiMiniGameInfo) do
        if self.CurEventId == Info.EventId then
            table.insert(self.LevelsInfo, Info)
        end
    end
    table.sort(self.LevelsInfo,function(A, B)
        return A.Id < B.Id
    end)
    local ClassPath = '/Game/UI/UI_PC/Common/Common_Item_subsize_PC_Content.Common_Item_subsize_PC_Content_C'
    self.LIst_Tab:ClearListItems()
    for Index,Info in ipairs(self.LevelsInfo) do
        local Content = NewObject(UE4.LoadClass(ClassPath))
        Content.ClickEvent = {
            Obj = self,
            Func = self.ClickListItem,
            Params = {Content},
        }
        Content.Index = Index
        Content.Id = Info.Id
        Content.DungeonId = Info.DungeonId
        Content.PreDungeon = Info.PreDungeon
        Content.DungeonName = Info.DungeonName
        Content.StartTime = Info.StartTime
        Content.Level = Info.Level
        Content.Reward = Info.Reward
        Content.IsSelect = false
        Content.EventId = Info.EventId
        self.LIst_Tab:AddItem(Content)
    end
end

function M:InitTab()
    self.TabConfigData = {
        TitleName= GText("Event_Title_103007"),
        DynamicNode={"Back", "BottomKey"},
        StyleName="Text", OwnerPanel=self, BackCallback=self.OnClickBack,
        BottomKeyInfo = { { KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.OnClickBack, Owner=self,}}, GamePadInfoList = {{Type="Img", ImgShortPath="B"}}, Desc = GText("UI_BACK"), bLongPress = false}},
		--PopupInfoId = DataMgr.SystemUI["ActivityFortTask"].PopupInfoId,
    }
    --self.TabConfigData.OverridenTopResouces = DataMgr.SystemUI["ActivityFortTask"].TabCoin
    self.Tab_Fort:Init(self.TabConfigData)
end

function M:PlayInAnimation()
    self:PlayAnimation(self.In)
    self.Fort_BG:PlayAnimation(self.Fort_BG.In)
end

function M:PlayOutAnimation()
    if self:IsAnimationPlaying(self.Out) then
        return
    end
    self:BindToAnimationFinished(self.Out, {self, self.Close})
    self:PlayAnimation(self.Out)
end

function M:OnReturnKeyDown()
    UIUtils.PlayCommonBtnSe(self)
    self:OnClickBack()
end

function M:OnClickBack()
    if self:IsAnimationPlaying(self.In) then
        return
    end
    self:PlayOutAnimation()
end

function M:Close()
    self.Super.Close(self)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if (InKeyName == UIConst.GamePadKey.FaceButtonRight) then
            IsEventHandled = true
            self:OnReturnKeyDown()
        elseif (InKeyName == UIConst.GamePadKey.FaceButtonTop) then
            IsEventHandled = true
            self.Fort_TaskProgress:OnBtnClicked()
        elseif (InKeyName == UIConst.GamePadKey.FaceButtonLeft) then
            IsEventHandled = true
            self.Btn_Start:OnBtnClicked()
        elseif (InKeyName == UIConst.GamePadKey.LeftThumb) then
            IsEventHandled = true
            self:SelectFirstMonsterInfoItem()
		end
        if not IsEventHandled then
            IsEventHandled = self.Tab_Fort:Handle_KeyEventOnGamePad(InKeyName)
        end
    else
        if (InKeyName == "Escape") then
            IsEventHandled = true
            self:OnReturnKeyDown()
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if InKeyName == "Gamepad_DPad_Up" then
            self:ClickBuffItem(self.Buff_Normal,"Normal")
            IsEventHandled = true
        elseif InKeyName == "Gamepad_DPad_Down" then
            self:ClickBuffItem(self.Buff_Weapon,"Weapon")
            IsEventHandled = true
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:ClickListItem(Content)
    if Content then
        self:ShowWhenSelece()
        if (IsValid(self.CurSelectContent)) then
            if (self.CurSelectContent.Entry) then
                self.CurSelectContent.Entry:SetSelected(false)
            else
                self.CurSelectContent.IsSelect = false
            end
        end
        self.CurSelectContent = Content
        self.CurSelectContent.Entry:SetSelected(true)
        self.LIst_Tab:BP_NavigateToItem(self.CurSelectContent)
        self:RefreshDetail()
    end
end

function M:RefreshDetail()
    self.Text_Num:SetText(self.CurSelectContent.Id)
    self.Text_FortTitle:SetText(GText(self.CurSelectContent.DungeonName))
    self:RefreshMonsterInfoList(self.CurSelectContent.DungeonId)
end

function M:OnObjectSetFinished(Content,Widget)
    if self.CurSelectIndex then
        if Content.Index == self.CurSelectIndex and not self.CurSelectContent and Content.Entry then
            Content.Entry:OnCellClickedWithoutSound()
        end
    else
        if Content.Index == 1 and not self.CurSelectContent and Content.Entry then
            Content.Entry:OnCellClickedWithoutSound()
        end
    end
end

function M:RefreshMonsterInfoList(DungeonId)
    -- 检查关卡是否有怪物信息
    local DungeonInfo = DataMgr.Dungeon[DungeonId]
    if not DungeonInfo or not DungeonInfo.DungeonMonsters or #DungeonInfo.DungeonMonsters == 0 then
        DebugPrint("DungeonMonster is nil", DungeonId)
        return
    end

    -- 复制怪物列表并进行排序
    local DisplayMonsters = CommonUtils.DeepCopy(DungeonInfo.DungeonMonsters)
    table.sort(DisplayMonsters, MonsterUtils.CompareMonsters)

    -- self.MonsterWeaknessIcon = {}
    -- self:InitMonsterWeakness(DungeonId)
    local MonsterItemContentClass = LoadClass('/Game/UI/WBP/Play/Widget/Depute/MonsterInfo_Tab_Item_Content.MonsterInfo_Tab_Item_Content')
    self.List_Monster:ClearListItems()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    for _, MonsterId in ipairs(DisplayMonsters) do
        -- 逐个实例化怪物列表
        local MonsterData = DataMgr.Monster[MonsterId]
        if MonsterData and GameState.IsUnitRelease(MonsterId) then
            local Content = NewObject(MonsterItemContentClass)
            Content.ParentWidget = self
            Content.MonsterId = MonsterId
            Content.DisableSelect = true
            Content.SoundEvent = "event:/ui/common/click_mid"
            -- 怪物图标
            -- Content.WeaknessIcon = self.MonsterWeaknessIcon[MonsterId]
            self.List_Monster:AddItem(Content)
        end
    end
end

function M:SelectMonsterInfoItem(MonsterId)
    UIManager(self):LoadUINew("MonsterDetailInfo", self.CurSelectContent.DungeonId, self, MonsterId)
end

function M:SelectFirstMonsterInfoItem()
    local Contents = self.List_Monster:GetListItems()
    if Contents:Length() > 0 then
        local MonsterId = Contents[1].MonsterId
        self:SelectMonsterInfoItem(MonsterId)
    end
end

function M:ClickBuffItem(Item,Type)
    if Item.IsUnlock then
        if Item.BuffId then
            AudioManager(self):PlayUISound(self, "event:/ui/common/combat_bag_cell_place_common", nil, nil)
        else
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
        end
        local UIManager = GWorld.GameInstance:GetGameUIManager()
        local Params = {
            Index = Index,
            Type = Type,
            AutoFocus = true,
            RightGamepadKey = UIConst.GamePadKey.FaceButtonLeft,
            RightGamepadImg = "X",
            Parent = self,
            --DontCloseWhenRightBtnClicked = true,
            RightCallbackObj = self,
            RightCallbackFunction = function(Obj, PackageData)
                self:SaveBuffs(PackageData.Content_1.Buffs)
            end,
        }
        if Type == "Normal" then
            Params.Title = "PaotaiGame_Prop"
        elseif Type == "Weapon" then
            Params.Title = "PaotaiGame_Weapon"
        end
        UIManager:ShowCommonPopupUI(100218,Params,self)
    else
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_disable", nil, nil)
        if Item.Type == "Weapon" then
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("PaotaiGame_PropLock_2"))
        elseif Item.Type == "Normal" then
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("PaotaiGame_PropLock_1"))
        end
    end
end

function M:EnterPaotaiGame()
    local CustomParams = {
        PaotaiId = self.CurSelectContent.Id
    }
    local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
    local CurTabIndex = 1
    if ActivityMain then
        CurTabIndex = ActivityMain.CurTabId
    end
    -- 进副本前缓存相关信息，用于退出副本时弹出此界面
    local ExitDungeonInfo = {
        Type = "Paotai",
        CurTabIndex = CurTabIndex,
        CurSelectIndex = self.CurSelectContent.Index,
    }
    GWorld.GameInstance:SetExitDungeonData(ExitDungeonInfo)
    self.Avatar:EnterEventDungeon(nil,self.CurSelectContent.DungeonId,nil,self.CurEventId,CustomParams)
end

function M:OnSelectItemChanged(SelectItem)
    if (not SelectItem) then
        return
    end
    if (self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad) then
        self:ClickListItemWhenSelectItemChanged(SelectItem)
    end
end

function M:ClickListItemWhenSelectItemChanged(Content)
    if Content and Content.Entry then
        if not self.CurSelectContent or self.CurSelectContent.Index ~= Content.Index then
            Content.Entry:SelectOnGamePad()
        end
    end
end

function M:BP_GetDesiredFocusTarget()
    return self:FocusOnSelectedItem()
end

function M:FocusOnSelectedItem()
    if self.CurSelectContent then
        self.List_Tab:BP_NavigateToItem(self.CurSelectContent)
        return self.CurSelectContent.Entry
    else
        return self.List_Tab
    end
end

-- function M:EnterSelectMode()
--     if (self.IsInSelectState) then
--         return
--     end
--     if (IsValid(self.GameInputModeSubsystem)) then
--         local EnterSuccess = false
--         self.List_Monster:NavigateToIndex(0)
--         EnterSuccess = true
--         if EnterSuccess then
--             -- self:InitKeyboardView()
--             -- self:InitSelectTab()
--             self.IsInSelectState = true
--         end
--     end
-- end

-- function M:LeaveSelectMode()
--     if (not self.IsInSelectState) then
--         return
--     end
--     if (IsValid(self.GameInputModeSubsystem)) then
--         self:FocusOnSelectedItem()
--         -- self:InitGamepadView()
--         -- self:InitNormalTab()
--         self.IsInSelectState = false
--     end
-- end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        return
    end
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    self:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
end

function M:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
    if IsUseKeyAndMouse then
		self:InitKeyboardView()
	else
		self:InitGamepadView()
	end
end

function M:InitGamepadView()
    if self.WS_MP then
        self.WS_MP:SetActiveWidgetIndex(1)
    end
    if self.Key_More then
        self.Key_More:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end
    if self.Key_Item then
        self.Key_Item:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end
    if self.Key_Weapon then
        self.Key_Weapon:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end
    self:SetFocus()
end

function M:InitKeyboardView()
    if self.WS_MP then
        self.WS_MP:SetActiveWidgetIndex(0)
    end
    if self.Key_More then
        self.Key_More:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.Key_Item then
        self.Key_Item:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.Key_Weapon then
        self.Key_Weapon:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:InitWidgetInfoInGamePad()
    -- self.WBP_Com_BtnLockCondition:SetDefaultGamePadImg("Y")
    -- self.WBP_Com_BtnLockCondition:SetGamepadIconVisibility(false)
    -- self.BtnReward:SetDefaultGamePadImg("Y")
    -- if self.KeyImg_L then
    --     self.KeyImg_L:CreateCommonKey(
    --         {
    --             KeyInfoList = {{Type = "Img",ImgShortPath = "LB"}},
    --         }
    --     )
    -- end
    -- if self.KeyImg_R then
    --     self.KeyImg_R:CreateCommonKey(
    --         {
    --             KeyInfoList = {{Type = "Img",ImgShortPath = "RB"}},
    --         }
    --     )
    -- end
    -- if self.KeyImg_EX then
    --     self.KeyImg_EX:CreateCommonKey(
    --         {
    --             KeyInfoList = {{Type = "Img",ImgShortPath = "X"}},
    --         }
    --     )
    -- end
    if self.Key_More then
        self.Key_More:CreateCommonKey(
            {
                KeyInfoList = {{Type = "Img",ImgShortPath = "LS"}},
            }
        )
    end
    if self.Key_Item then
        self.Key_Item:CreateCommonKey(
            {
                KeyInfoList = {{Type = "Img",ImgShortPath = "Up"}},
            }
        )
    end
    if self.Key_Weapon then
        self.Key_Weapon:CreateCommonKey(
            {
                KeyInfoList = {{Type = "Img",ImgShortPath = "Down"}},
            }
        )
    end
end

function M:OnUINavigation(NavigationDirection)
    if(NavigationDirection == EUINavigation.Up)then
        self:ClickBuffItem(self.Buff_Normal,"Normal")
    elseif(NavigationDirection == EUINavigation.Down) then
        self:ClickBuffItem(self.Buff_Weapon,"Weapon")
    end
    return nil
end

function M:SaveBuffs(Buffs)
    local PaotaiBuffs = self.Avatar.PaotaiBuffs or {}
    local HaveChange = false
    for i=1,3 do
        if Buffs[i] ~= PaotaiBuffs[i] then
            HaveChange = true
            break
        end
    end
    if HaveChange then
        AudioManager(self):PlayUISound(self, "event:/ui/common/combat_bag_hide_use_item", nil, nil)
        local Callback = function ()
            self:RefreshBuffItem()
        end
        self.Avatar:PaotaiUpdateBuffs(Buffs, Callback)
    end
end

return M
