require "UnLua"
require "DataMgr"

---@type UIUtils
local UIUtils = require "Utils.UIUtils"
local MonsterUtils = require "Utils.MonsterUtils"
local ControllerFSM = require("Blueprints.UI.ControllerFSM")
local FSMStates = {
    FocusTab = 0,           -- 聚焦左侧Tab
    FocusPanel = 1,         -- 聚焦中间怪物选择面板
    FocusBottom = 2,        -- 聚焦下方面板
    FocusRight = 3,         -- 聚焦右侧面板
    FocusNumInput = 4,      -- 聚焦数字输入框
}



---@class WBP_Battle_Training_Root : WBP_Battle_Training_Root_C
local WBP_Battle_Training_Root_C = Class({
    "BluePrints.UI.BP_UIState_C",
})

WBP_Battle_Training_Root_C._components = {
    "BluePrints.UI.UI_PC.Common.LSFocusComp",
}


local GamepadKeyTip = {
    Controller_Back = 0,
    Controller_Close = 1,
    Controller_Select = 2
}

function WBP_Battle_Training_Root_C:InitMonsterGallery(Owner)
    self.Owner = Owner
    self.Text_ChooseTitle:SetText(GText("UI_DUNGEON_DES_TRAINING_12"))
    self.Text_SelectedTitle:SetText(GText("UI_DUNGEON_DES_TRAINING_24"))
    self.Text_Delete:SetText(GText("UI_DUNGEON_DES_TRAINING_10"))
    self.Text_SettingTitle:SetText(GText("UI_DUNGEON_DES_TRAINING_14"))
    self.Btn_Confirm:SetText(GText("UI_DUNGEON_DES_TRAINING_12"))
    self.Text_SettingTitle_1:SetText(GText("UI_DUNGEON_DES_TRAINING_32"))
    self.InvincibleSetting.Text_SettingTitle:SetText(GText("UI_DUNGEON_DES_TRAINING_15"))
    self.AISetting.Text_SettingTitle:SetText(GText("UI_DUNGEON_DES_TRAINING_16"))
    self.Text_Filter:SetText(GText("UI_DUNGEON_DES_TRAINING_13"))
    self.Text_MidEmpty:SetText(GText("UI_DUNGEON_DES_TRAINING_26"))
    self.Text_MidLockTitle:SetText(GText("UI_DUNGEON_DES_TRAINING_9"))
    self.Text_MidLockDesc:SetText(GText("UI_DUNGEON_DES_TRAINING_34"))

    self:InitGamepadConfig()
    self.Text_SelectedChoosNum:SetColorAndOpacity(self.Text_SelectedChoosNumNormal)
    self.CurrentSelectedNumColor = self.Text_SelectedChoosNumNormal


    self.GameMode = UE4.UGameplayStatics.GetGameMode(self)
	self.TrainingData = DataMgr.Training[self.GameMode.DungeonId]

    -- 初始化数据
    self.MonsterGallery = {}
    self.MonsterChecked = {}
    self.MonsterCheckedNum = {}
    self.MonsterCheckedTotalNum = 0
    self.LastPressedRule = nil
    self.IsClosing = nil

    -- 待选敌人信息
    self.TabId2MonsterCampOption = {}

    self.WBP_Com_CheckBox_LeftText:BindEventOnClicked({
        Func = self.OnShowUnlockedMonstersPressed,
        Inst = self,
    })

    self.OnlyShowUnlockedMonsters = self.WBP_Com_CheckBox_LeftText.Checked

    -- 初始化数量选择器
    self.Com_Slider:Init(
        {
            MinValue = 1,
            MaxValue = 20,
            OwnerPanel = self,
            MinusBtnCallback = self.OnMinusSelectedMonsterNumClicked,
            MinusBtnForbidCallback = function() 
                AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_minus", nil, nil)
            end,

            AddBtnCallback = self.OnAddSelectedMonsterNumClicked,
            AddBtnForbidCallback = function()
                UIManager(self):ShowUITip(UIConst.Tip_CommonToast, string.format(GText("UI_DUNGEON_DES_TRAINING_8"), self.TrainingData.MaxEnemyNum))
            end,
            MaxBtnCallback = self.OnMaxSelectedMonsterNumClicked,
            SliderChangeCallback = self.OnMonsterCheckedNumChanged,
            EnableMaxBtn = true,
            bForbidPressAccelerate = true
        }
    )

    -- 初始化侧边栏
    self:InitTab()
    self.Tab:SelectTab(1)
    self:ClearSelectedNumView()

    -- 初始化按钮
    self.Btn_Delete:ForbidBtn(true)
    self.Btn_Delete.SoundFunc = function() 
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    end

    self.Btn_Show:ForbidBtn(true)
    self.Btn_Show_ButtonArea:SetIsEnabled(false)
    self.Key_BottomNum:SetForbidKey(true)
    self.Key_BottomDelete:SetForbidKey(true)
    self.Btn_Show.SoundFunc = function() end

    self.Btn_Confirm:ForbidBtn(true)
    self.Btn_Confirm.SoundFunc = function() 
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
    end



    -- 初始化右侧面板相关信息
    self:InitEnemyLevelSetting()

    local IsPlayerInvincible = self:GetPlayerInvincible()
    self.InvincibleSetting.Btn_Setting:SetChecked(IsPlayerInvincible)
    if IsPlayerInvincible then 
        self.InvincibleSetting.Text_SettingType:SetText(GText("UI_DUNGEON_DES_TRAINING_29"))
    else
        self.InvincibleSetting.Text_SettingType:SetText(GText("UI_DUNGEON_DES_TRAINING_30"))
    end

    local IsEnemyAIForbidden = self:GetIsEnemyAIForbidden()
    self.AISetting.Btn_Setting:SetChecked(IsEnemyAIForbidden)
    if IsEnemyAIForbidden then 
        self.AISetting.Text_SettingType:SetText(GText("UI_DUNGEON_DES_TRAINING_29"))
    else
        self.AISetting.Text_SettingType:SetText(GText("UI_DUNGEON_DES_TRAINING_30"))
    end

    self.InvincibleSetting.Btn_Setting:RemoveEventOnCheckStateChanged(self)
    self.InvincibleSetting.Btn_Setting:AddEventOnCheckStateChanged(self, self.OnInvincibleSettingChanged) 
    self.AISetting.Btn_Setting:RemoveEventOnCheckStateChanged(self)
    self.AISetting.Btn_Setting:AddEventOnCheckStateChanged(self, self.OnAISettingChanged)

    self.Blur_Choose:SetVisibility(UE4.ESlateVisibility.Collapsed)

    -- 已选敌人信息
    self.IsCheckedPreviewPanelDisplayed = false
    self.Btn_Show_ButtonArea.OnClicked:Clear()
    self.Btn_Show_ButtonArea.OnClicked:Add(self, self.OnShowSelectedMonstersButtonClicked)

    self.Btn_Show:UnBindEventOnClickedByObj(self)
    self.Btn_Show:BindEventOnClicked(self, self.OnShowSelectedMonstersButtonClicked)

    self.Btn_Delete:UnBindEventOnClicked(self, self.OnBtnDeleteClicked)
    self.Btn_Delete:BindEventOnClicked(self, self.OnBtnDeleteClicked)
    self.Btn_Confirm:UnBindEventOnClicked(self, self.TrainingCreateMonster)
    self.Btn_Confirm:BindEventOnClicked(self, self.TrainingCreateMonster)

    if not UIUtils.IsMobileInput() then
        self.ControllerFSM:Enter(FSMStates.FocusTab)
    end
end


function WBP_Battle_Training_Root_C:OnMonsterLvTextCommitted(CurNumber, PrevNumber)
    local Number = math.clamp(CurNumber, 1, self.MaxEnemyLevelToSpawn)
    self.EnemyLevelToSpawn = Number
end


function WBP_Battle_Training_Root_C:UnInitMonsterGallery()

    -- 待选敌人信息
    self.WBP_Com_CheckBox_LeftText:UnInitCommonCheckBox()
    self:RemoveItemsFromMonsterGallery()

    -- 已选敌人信息
    self:RemoveItemsFromMonsterChecked()
end

function WBP_Battle_Training_Root_C:InitTab()
    local MonsterCampData = DataMgr.MonsterCamp 
    local ConfigData = {
        Tabs = {},
        SoundFunc = function()
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_02", nil, nil)
        end
    }

    table.insert(ConfigData.Tabs, {
        Text = GText("UI_DUNGEON_DES_TRAINING_18"),
        TabId = #ConfigData.Tabs + 1, 
        IconPath = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_All.T_Tab_All",
    })
    self.TabId2MonsterCampOption[1] = "All"
    local TempDatas = {}
    for CampTag, CampData in pairs(MonsterCampData) do 
        local MonCampName = CampData.MonCampName 
        local MonCampIcon = CampData.MonCampIcon or "/Game/UI/UI_PNG/03Image/Monster_Head/Head_Empty.Head_Empty"
        local TempData = {
            Text = GText(MonCampName),
            IconPath = MonCampIcon,
            Priority = CampData.Priority,
            CampTag = CampTag,
        }
        table.insert(TempDatas, TempData)
    end
    
    table.sort(TempDatas, function(A, B)
        return A.Priority < B.Priority
    end)

    for _, Data in ipairs(TempDatas) do
        local TabData = {
            Text = Data.Text,
            TabId = #ConfigData.Tabs + 1, 
            IconPath = Data.IconPath,
        }
        self.TabId2MonsterCampOption[TabData.TabId] = Data.CampTag
        table.insert(ConfigData.Tabs, TabData)
    end

    table.insert(ConfigData.Tabs, {
        Text = GText("UI_DUNGEON_DES_TRAINING_23"),
        TabId = #ConfigData.Tabs + 1, 
        IconPath = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Monster.T_Tab_Monster",
    })
    self.TabId2MonsterCampOption[#ConfigData.Tabs] = "Other"
    self.Tab:BindEventOnTabSelected(self, self.OnMonsterCampTabSelected)
    self.Tab:Init(ConfigData)
end 

function WBP_Battle_Training_Root_C:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice) 
    end
end

function WBP_Battle_Training_Root_C:RefreshBaseInfo()
    -- 刷新一些基础信息
    self:AddLSFocusTarget(self.WBP_Com_CheckBox_LeftText.Com_KeyImg, self.WBP_Com_CheckBox_LeftText, nil, true)
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

-- 手柄端
-----------------------------------------------------------------------------------
function WBP_Battle_Training_Root_C:BP_GetDesiredFocusTarget()
    local CurrentState = self.ControllerFSM:Current()
    if CurrentState == FSMStates.FocusTab then
        return self.Tab
    elseif CurrentState == FSMStates.FocusPanel then
        return self.List_Item
    elseif CurrentState == FSMStates.FocusBottom then   
        return self.List_Select_Mod
    elseif CurrentState == FSMStates.FocusRight then
        return self.MaskLevelSetting
    end

    return nil
end

function WBP_Battle_Training_Root_C:InitGamepadConfig()
    if UIUtils.IsMobileInput() then return end
    self.GamepadKeyCofig = {
        [GamepadKeyTip.Controller_Close] = {
            GamePadInfoList = {
                {Type="Img", ImgShortPath=UIConst.GamePadImgKey.FaceButtonRight, Owner=self}
            }, 
            Desc=GText("UI_Controller_Close")
        },
        [GamepadKeyTip.Controller_Back] = {
            GamePadInfoList = {
                {Type="Img", ImgShortPath=UIConst.GamePadImgKey.FaceButtonRight, Owner=self}
            }, 
            Desc=GText("UI_Tips_Close")
        },
        [GamepadKeyTip.Controller_Select] = {
            GamePadInfoList = {
                {Type="Img",ImgShortPath=UIConst.GamePadImgKey.FaceButtonBottom, Owner=self}
            },
            Desc=GText("UI_CTL_Select")
        },
    }

    self.Key_BottomNum:CreateGamepadKey(UIConst.GamePadImgKey.DPadUp)
    self.Key_BottomDelete:CreateGamepadKey(UIConst.GamePadImgKey.DPadDown)
    self.Key_SettingTitle:CreateGamepadKey(UIConst.GamePadImgKey.SpecialLeft)
    self.Btn_Confirm:SetGamePadImg(UIConst.GamePadImgKey.FaceButtonTop)

    self.Tab:SetNavigationRuleCustom(UE4.EUINavigation.Right, {self, function()
        if #self.MonsterGallery > 0 then 
            self.ControllerFSM:Enter(FSMStates.FocusPanel)
            return self.List_Item
        else
            return nil
        end
    end})

    self.List_Item:SetNavigationRuleCustom(UE4.EUINavigation.Left, {self, function()
        self.ControllerFSM:Enter(FSMStates.FocusTab)
        return self.Tab
    end})

    self.MaskLevelSetting.OnHovered:Add(self, function()
        if UIUtils.IsMobileInput() then return end
        self.Imgae_Select:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.SelectingLevelSetting = true
        self.Owner.Tab:UpdateBottomKeyInfo_Quick{
            {UIConst.GamePadImgKey.FaceButtonRight, GText("UI_Tips_Close")},
        }
    end)
    self.MaskLevelSetting.OnUnhovered:Add(self, function()
        if UIUtils.IsMobileInput() then return end
        self.Imgae_Select:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.SelectingLevelSetting = false
    end)
    
    self.InvincibleSetting:BindEventOnHovered(self, function()
        if UIUtils.IsMobileInput() then return end
        self.Owner.Tab:UpdateBottomKeyInfo_Quick{
            {UIConst.GamePadImgKey.FaceButtonBottom, GText("UI_Tips_Ensure")},
            {UIConst.GamePadImgKey.FaceButtonRight, GText("UI_Tips_Close")},
        }
    end)
    
    self.AISetting:BindEventOnHovered(self, function()
        if UIUtils.IsMobileInput() then return end
        self.Owner.Tab:UpdateBottomKeyInfo_Quick{
            {UIConst.GamePadImgKey.FaceButtonBottom, GText("UI_Tips_Ensure")},
            {UIConst.GamePadImgKey.FaceButtonRight, GText("UI_Tips_Close")},
        }
    end)

    -- 初始化手柄状态机
    self.ControllerFSM = ControllerFSM.New(self, {
        [FSMStates.FocusTab] = {
            OnEnter = self.EnterState_FocusTab,
        },
        [FSMStates.FocusPanel] = {
            OnEnter = self.EnterState_FocusPanel,
        },
        [FSMStates.FocusBottom] = {
            OnEnter = self.EnterState_FocusBottom,
            OnLeave = self.LeaveState_FocusBottom,
        },
        [FSMStates.FocusRight] = {
            OnEnter = self.EnterState_FocusRight,
            OnLeave = self.LeaveState_FocusRight,
        },
        [FSMStates.FocusNumInput] = {}
    })
end

function WBP_Battle_Training_Root_C:EnterState_FocusTab()
    self.Owner.Tab:UpdateBottomKeyInfo_Quick{
        {UIConst.GamePadImgKey.FaceButtonRight, GText("UI_Controller_Close")},
    }
end

function WBP_Battle_Training_Root_C:EnterState_FocusPanel()
    self.Owner.Tab:UpdateBottomKeyInfo_Quick{
        {UIConst.GamePadImgKey.FaceButtonBottom, GText("UI_CTL_Select/Cancel")},
        {UIConst.GamePadImgKey.FaceButtonRight, GText("UI_Controller_Close")},
    }
end

function WBP_Battle_Training_Root_C:EnterState_FocusBottom()
    self.Owner.Tab:UpdateBottomKeyInfo_Quick{
        {UIConst.GamePadImgKey.FaceButtonBottom, GText("UI_CTL_Select/Cancel")},
        {UIConst.GamePadImgKey.FaceButtonRight, GText("UI_Tips_Close")},
    }
end

function WBP_Battle_Training_Root_C:LeaveState_FocusBottom()
end

function WBP_Battle_Training_Root_C:EnterState_FocusRight()
    self.Owner.Tab:UpdateBottomKeyInfo_Quick{
        {UIConst.GamePadImgKey.FaceButtonRight, GText("UI_Tips_Close")},
    }

    self.Key_SettingTitle:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Com_NumInput:UpdateUIStyleInPlatform(false)
end

function WBP_Battle_Training_Root_C:LeaveState_FocusRight(NewState)
    self.Com_NumInput:UpdateUIStyleInPlatform(true)
    if NewState ~= FSMStates.FocusNumInput then 
        self.Key_SettingTitle:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
end


function WBP_Battle_Training_Root_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
    self.CurGamepadName = UIUtils.UtilsGetCurrentGamepadName()
    if self.CurInputDeviceType == UE4.ECommonInputType.Gamepad then 
        self:InitGamepadView()
    else
        self:InitKeyboardView()
    end
end

function WBP_Battle_Training_Root_C:InitGamepadView()
    self.MaskLevelSetting:SetVisibility(UE4.ESlateVisibility.Visible)
    self.Key_BottomNum:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Key_BottomDelete:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Key_SettingTitle:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

    local Current = self.ControllerFSM:Current()
    if Current == FSMStates.FocusRight then
        self.Com_NumInput:UpdateUIStyleInPlatform(false)
    else 
        self.Com_NumInput:UpdateUIStyleInPlatform(true)
    end
end

function WBP_Battle_Training_Root_C:InitKeyboardView()
    self.MaskLevelSetting:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Key_BottomNum:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Key_BottomDelete:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Key_SettingTitle:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function WBP_Battle_Training_Root_C:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
       IsHandled = self:Handle_PreviewKeyDownOnGamePad(InKeyName)
    end

    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function WBP_Battle_Training_Root_C:Handle_PreviewKeyDownOnGamePad(InKeyName)
    local CurrentState = self.ControllerFSM:Current()
    if InKeyName == Const.GamepadDPadLeft then 
        if CurrentState == FSMStates.FocusRight then 
        elseif CurrentState == FSMStates.FocusBottom then 
        end
        return true
    elseif InKeyName == Const.GamepadDPadRight then 
        if CurrentState == FSMStates.FocusPanel or CurrentState == FSMStates.FocusBottom then
            self.Com_Slider:Handle_KeyDownEventOnGamePad(InKeyName)
        elseif CurrentState == FSMStates.FocusRight and self.SelectingLevelSetting then
            self.Com_NumInput:Handle_KeyEventOnGamePad(InKeyName)
        end
        return true
    elseif InKeyName == Const.GamepadDPadUp then 
        if CurrentState == FSMStates.FocusPanel then 
            -- 展开下方菜单
            if self.Btn_Show_ButtonArea:GetIsEnabled() == true then 
                self:OnShowSelectedMonstersButtonClicked()
                self.ControllerFSM:Enter(FSMStates.FocusBottom)
                self.List_Select_Mod:SetFocus()
            end
        elseif CurrentState == FSMStates.FocusBottom then 
            -- 折叠下方菜单
            self:OnShowSelectedMonstersButtonClicked()
            self.ControllerFSM:Enter(FSMStates.FocusPanel)
            self.List_Item:SetFocus()
        end
        return true
    elseif InKeyName == Const.GamepadDPadDown then 
        if CurrentState == FSMStates.FocusPanel or CurrentState == FSMStates.FocusBottom then 
            self:OnBtnDeleteClicked()
            self.Btn_Delete:SoundFunc()
        end
        return true
    elseif InKeyName == Const.RightStickLeft or InKeyName == Const.RightStickRight then 
        if CurrentState == FSMStates.FocusPanel or CurrentState == FSMStates.FocusBottom then 
            self.Com_Slider:Handle_KeyDownEventOnGamePad(InKeyName)
        end
    end
    return false
end

function WBP_Battle_Training_Root_C:Handle_KeyDownOnGamePad(InKeyName)
    local CurrentState = self.ControllerFSM:Current()
    if InKeyName == Const.GamepadLeftTrigger then
        if CurrentState == FSMStates.FocusPanel or CurrentState == FSMStates.FocusBottom then 
            self.Com_Slider:Handle_KeyDownEventOnGamePad(InKeyName)
        elseif CurrentState == FSMStates.FocusRight and self.SelectingLevelSetting then
            self.Com_NumInput:Handle_KeyEventOnGamePad(InKeyName)
        end
        return true
    elseif InKeyName == Const.GamepadRightTrigger then
        if CurrentState == FSMStates.FocusPanel or CurrentState == FSMStates.FocusBottom then
            self.Com_Slider:Handle_KeyDownEventOnGamePad(InKeyName)
        elseif CurrentState == FSMStates.FocusRight and self.SelectingLevelSetting then
            self.Com_NumInput:Handle_KeyEventOnGamePad(InKeyName)
        end
        return true
    elseif InKeyName == Const.GamepadFaceButtonUp then -- 手柄生成怪物
        self:TrainingCreateMonster()
        return true
    elseif InKeyName == Const.GamepadSpecialLeft then
        if CurrentState == FSMStates.FocusTab or CurrentState == FSMStates.FocusPanel then
            self.MaskLevelSetting:SetFocus()
            self.ControllerFSM:Enter(FSMStates.FocusRight)
        elseif CurrentState == FSMStates.FocusRight and self.SelectingLevelSetting then
            self.Com_NumInput:Handle_KeyEventOnGamePad(InKeyName)
            self.ControllerFSM:Enter(FSMStates.FocusNumInput)
        end
        return true
    elseif InKeyName == Const.GamepadFaceButtonRight then -- 关闭面板
        if CurrentState == FSMStates.FocusRight then
            self.ControllerFSM:Enter(FSMStates.FocusPanel)
            self.List_Item:SetFocus()
        elseif CurrentState == FSMStates.FocusNumInput then
            self.Com_NumInput:Handle_KeyEventOnGamePad(InKeyName)
            self.ControllerFSM:Enter(FSMStates.FocusRight)
        elseif CurrentState == FSMStates.FocusBottom then
            self:OnShowSelectedMonstersButtonClicked()
            self.ControllerFSM:Enter(FSMStates.FocusPanel)
            self.List_Item:SetFocus()
        else
            self:ClosePanel()
        end
        return true
    end
end

function WBP_Battle_Training_Root_C:Handle_KeyUpOnGamePad(InKeyName)
    local CurrentState = self.ControllerFSM:Current()
    if InKeyName == Const.GamepadLeftTrigger then
        if CurrentState == FSMStates.FocusPanel or CurrentState == FSMStates.FocusBottom then 
            self.Com_Slider:Handle_KeyUpEventOnGamePad(InKeyName)
            return true
        end
    elseif InKeyName == Const.GamepadRightTrigger then
        if CurrentState == FSMStates.FocusPanel or CurrentState == FSMStates.FocusBottom then
            self.Com_Slider:Handle_KeyUpEventOnGamePad(InKeyName)
            return true
        end
    elseif InKeyName == Const.RightStickLeft or InKeyName == Const.RightStickRight then 
        if CurrentState == FSMStates.FocusPanel or CurrentState == FSMStates.FocusBottom then 
            self.Com_Slider:Handle_KeyUpEventOnGamePad(InKeyName)
        end
    end
end

-----------------------------------------------------------------------------------

function WBP_Battle_Training_Root_C:OnKeyUp(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local CurrentState = self.ControllerFSM:Current()
    local IsHandled = nil
    if CurrentState == FSMStates.FocusPanel or CurrentState == FSMStates.FocusTab then 
        IsHandled = self:OnKeyDownForLSComp(MyGeometry, InKeyEvent)
        if IsHandled then 
            return UE4.UWidgetBlueprintLibrary.Handled()
        end
    end
    
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsHandled = self:Handle_KeyUpOnGamePad(InKeyName)
    end
    
    if not IsHandled then
        return self.Super.OnKeyUp(self, MyGeometry, InKeyEvent)
    else
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
end

function WBP_Battle_Training_Root_C:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = nil
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsHandled = self:Handle_KeyDownOnGamePad(InKeyName)
    end

     if not IsHandled then
         return self.Super.OnKeyDown(self, MyGeometry, InKeyEvent)
     else
         return UE4.UWidgetBlueprintLibrary.Handled()
     end
end

function WBP_Battle_Training_Root_C:OnInvincibleSettingChanged(IsChecked)
    if IsChecked then 
        self.InvincibleSetting.Text_SettingType:SetText(GText("UI_DUNGEON_DES_TRAINING_29"))
    else
        self.InvincibleSetting.Text_SettingType:SetText(GText("UI_DUNGEON_DES_TRAINING_30"))
    end
    self:SetPlayerInvincible(IsChecked)
end

function WBP_Battle_Training_Root_C:OnAISettingChanged(IsChecked)
    if IsChecked then 
        self.AISetting.Text_SettingType:SetText(GText("UI_DUNGEON_DES_TRAINING_29"))
    else
        self.AISetting.Text_SettingType:SetText(GText("UI_DUNGEON_DES_TRAINING_30"))
    end 
    self:SetEnemyAIForbidden(IsChecked)
end

function WBP_Battle_Training_Root_C:InitEnemyLevelSetting()
    local Avatar = GWorld:GetAvatar()
    local PlayerLevel = math.min(Avatar and Avatar.Level or 1, #(DataMgr.RegionLevel))
    self.EnemyLevelToSpawn = DataMgr.RegionLevel[PlayerLevel].RegionLevel -- 当前生成的敌人等级
    self.MaxEnemyLevelToSpawn = 180 -- 最大生成的敌人等级

    self.Com_NumInput:Init({
        InitValue = self.EnemyLevelToSpawn,
        MinValue = 1,
        MaxValue = self.MaxEnemyLevelToSpawn,
        MinusBtnCallback = self.OnMinusEnemyLevelClicked,
        AddBtnCallback = self.OnAddEnemyLevelClicked,
        MaxBtnCallback = self.OnMaxEnemyLevelClicked,
        InputCallback = self.OnMonsterLvTextCommitted,
        LeaveFocusWidget = self.MaskLevelSetting,
        OwnerPanel = self,
    })

end

function WBP_Battle_Training_Root_C:OnMinusEnemyLevelClicked(CurNumber, PrevNumber)
    self.EnemyLevelToSpawn = CurNumber
end

function WBP_Battle_Training_Root_C:OnAddEnemyLevelClicked(CurNumber, PrevNumber) 
    self.EnemyLevelToSpawn = CurNumber
end

function WBP_Battle_Training_Root_C:OnMaxEnemyLevelClicked(CurNumber, PrevNumber) 
    self.EnemyLevelToSpawn = CurNumber
end

-------------------------------- 待选敌人信息 --------------------------------
function WBP_Battle_Training_Root_C:OnMonsterCampTabSelected(TabWidget)
    DebugPrint("Tianyi@ OnMonsterCampTabSelected: " .. TabWidget.Idx)
    self.CachedRuleId2ItemData = {}
    self.CachedRuleId2ItemEntry = {}
    self.CachedRuleId2CheckedItemData = {}
    self.CachedRuleId2CheckedItemEntry = {}
    self.LastSelectedItemData = nil
    self.LastSelectedCheckedItemData = nil

    self.CurrentMonsterCampOption = self.TabId2MonsterCampOption[TabWidget.Idx]
    self:FilterItemsForMonsterGallery()
    self:AddItemsToMonsterGallery()
    
    if self.LastPressedRule and self:GetMonsterGalleryItemData(self.LastPressedRule) then 
        self:ShowMonsterRuleInfoView(self.LastPressedRule)
    else
        self.LastPressedRule = nil
        self:ClearMonsterRuleInfoView()
        self.WS:SetActiveWidgetIndex(0)
    end

    if self.IsCheckedPreviewPanelDisplayed then 
        self:OnShowSelectedMonstersButtonClicked()
    end
    -- self:ClearSelectedNumView()
end

function WBP_Battle_Training_Root_C:FilterItemsForMonsterGallery(MonsterCampOption)

    -- 待选列表：筛选已解锁 / 全部怪物加入待选列表
    self.MonsterGallery = {}
    local Avatar = GWorld:GetAvatar()
    for Id, Info in pairs(DataMgr.GalleryRule) do
        local MonsterId = Info.PreferredMonsterId
        if not self:CheckMonsterInCamp(MonsterId, self.CurrentMonsterCampOption) or not MonsterUtils.CheckGallerRuleByMonsterRelease(Info)  then 
            goto continue 
        end
 
        if Info.DisableTrainingGround ~= true  
            and ((not self.OnlyShowUnlockedMonsters)
                or (not (Avatar and Avatar:CheckFirstMonster(Info.PreferredMonsterId, false)))) then
            
                    local IsLocked = Avatar:CheckFirstMonster(Info.PreferredMonsterId, false)
                    table.insert(self.MonsterGallery, {
                        Id = Id,
                        Info = Info,
                        IsLocked = IsLocked,
                        Priority = Info.Priority or 99999
                    })
        end

        ::continue::
    end
    table.sort(self.MonsterGallery, function(RuleA, RuleB)
        if RuleA.IsLocked ~= RuleB.IsLocked then
            return not RuleA.IsLocked 
        end

        if RuleA.Info.Priority ~= RuleB.Info.Priority then
            local GetFirstDigit = function(InNumber)
                return tonumber(string.sub(tostring(InNumber), 1, 1))
            end 

            local FirstDigitA = GetFirstDigit(RuleA.Info.Priority)
            local FirstDigitB = GetFirstDigit(RuleB.Info.Priority)
            if FirstDigitA ~= FirstDigitB then
                return FirstDigitA < FirstDigitB
            else
                return RuleA.Info.Priority < RuleB.Info.Priority
            end
        end
    end)
end

function WBP_Battle_Training_Root_C:RemoveItemsFromMonsterGallery()

    -- 待选列表：将 Items 从待选列表删除
    UIUtils.StopListViewFramingInAnimation(self.List_Item, {TimerKeys = self._MonsterGalleryListInTimers, UIState = self})
    self.List_Item:ClearListItems()
end

function WBP_Battle_Training_Root_C:AddItemsToMonsterGallery()
    local Avatar = GWorld:GetAvatar()

    self.List_Item:ClearListItems()
    -- 待选列表：将 Items 添加到待选列表
    for Index, Rule in ipairs(self.MonsterGallery) do
        local ItemData = NewObject(UIUtils.GetCommonItemContentClass())
        ItemData.Owner = self
        ItemData.Index = Index
        ItemData.RuleId = Rule.Id
        ItemData.bCheckPreview = false
        ItemData.Locked = Rule.IsLocked
        ItemData.PreferredMonsterId = Rule.Info.PreferredMonsterId
        ItemData.OnClicked = {Func = self.OnMonsterGalleryEntryClicked, Inst = self}
        ItemData.IsChecked = self.MonsterChecked[Rule.Id] 
        ItemData.Selected = self.LastPressedRule == Rule.Id
        self.List_Item:AddItem(ItemData)
    end

    local Params = {
        Callback = function()
            local XCount, YCount = UIUtils.GetTileViewContentMaxCount(self.List_Item, "XY") 
            local MaxCount = XCount * YCount
            local CurCount = self.List_Item:GetNumItems()
            local RestCount = 0
            if MaxCount > CurCount then 
                RestCount = MaxCount - CurCount
            elseif CurCount % XCount ~= 0 then 
                RestCount = XCount - CurCount % XCount
            end
            for i = 1, RestCount do
                local ItemData = NewObject(UIUtils.GetCommonItemContentClass())
                ItemData.IsEmpty = true
                self.List_Item:AddItem(ItemData)
            end
            
        end
    }
    self.List_Item:RequestPlayEntriesAnim()
end

function WBP_Battle_Training_Root_C:OnShowUnlockedMonstersPressed(CheckBoxChecked)

    -- 待选列表：点击只显示已解锁 / 全部显示
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    self.OnlyShowUnlockedMonsters = CheckBoxChecked
    self:FilterItemsForMonsterGallery()
    self:RemoveItemsFromMonsterGallery()
    self:AddItemsToMonsterGallery()
    self.List_Item:ScrollToTop()
    if self.CurInputDeviceType == UE4.ECommonInputType.Gamepad then
        self:AddTimer(0.1, function()
            self.Tab:SetFocus()
            self.ControllerFSM:Enter(FSMStates.FocusTab)
            -- if not self:FocusLastSelectedEntry() then
            -- end
        end)
    end
end

-- 判断该Item是否可以Check
function WBP_Battle_Training_Root_C:CheckMonsterGalleryItemCanChecked(Item)
    local ItemData = Item.Data   
    if ItemData.Locked then return false end
    if self.MonsterCheckedTotalNum >= self:GetMaxSpawnableNum() then return false end
    return true
end

function WBP_Battle_Training_Root_C:FocusLastSelectedEntry()
    if self.LastSelectedItemData then 
        local LastSelectedItemEntry = self:GetMonsterGalleryItemEntry(self.LastSelectedItemData.RuleId)
        if LastSelectedItemEntry then 
            LastSelectedItemEntry:SetFocus()
            return true 
        end
    end
    return false
end

function WBP_Battle_Training_Root_C:UnSelectLastSelectedEntry()
    if self.LastSelectedItemData then 
        local LastSelectedItemEntry = self:GetMonsterGalleryItemEntry(self.LastSelectedItemData.RuleId)
        if LastSelectedItemEntry then 
            self.LastSelectedItemData.Selected = false 
            -- LastSelectedItemEntry:StopAllAnimations()
            LastSelectedItemEntry:SetSelected(false)
        end
        self.LastSelectedItemData = nil
    end

    if self.LastSelectedCheckedItemData then 
        local LastSelectedCheckedItemEntry = self:GetCheckedItemEntry(self.LastSelectedCheckedItemData.RuleId) 
        if LastSelectedCheckedItemEntry then 
            self.LastSelectedCheckedItemData.Selected = false 
            LastSelectedCheckedItemEntry:SetSelected(false)
        end
        self.LastSelectedCheckedItemData = nil
    end
end

-- 显示一个RuleId对应怪物的相关信息
function WBP_Battle_Training_Root_C:ShowMonsterRuleInfoView(RuleId)
    self.Text_Enemy_NameTitle:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Text_Desc:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    local MonsterGalleryInfo = DataMgr.GalleryRule[RuleId]
    local MonsterData = DataMgr.Monster[MonsterGalleryInfo.PreferredMonsterId]
    if MonsterData and MonsterGalleryInfo then 
        local MonsterName = GText(MonsterData.UnitName)
        local MonsterDescriptionDetail = GText(MonsterGalleryInfo.DescriptionDetail)
        self.Text_Enemy_NameTitle:SetText(MonsterName)
        self.Text_Desc:SetText(MonsterDescriptionDetail)
        self.ScrollTextDesc:ScrollToStart()
    end
end

function WBP_Battle_Training_Root_C:ClearMonsterRuleInfoView()
    self.Text_Enemy_NameTitle:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Text_Desc:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

-- 设置某个待选Entry的选中状态
function WBP_Battle_Training_Root_C:SetMonsterGalleryEntrySelected(RuleId, bSelected, bIgnoreChecked)
    local ItemData = self:GetMonsterGalleryItemData(RuleId)
    local ItemEntry = self:GetMonsterGalleryItemEntry(RuleId)

    if not ItemData then 
        DebugPrint("Tianyi@ ItemData is nil")
        return false
    end

    if bSelected then 
        self:UnSelectLastSelectedEntry()
        if bIgnoreChecked or not ItemData.IsChecked then 
            ItemData.Selected = true 
            if ItemEntry then 
                ItemEntry:SetSelected(true)
            end
            self.LastSelectedItemData = ItemData
            self.LastPressedRule = ItemData.RuleId 

            -- 显示怪物的相关信息 
            self:ShowMonsterRuleInfoView(ItemData.RuleId)
        else 
            self.LastPressedRule = nil
            self:ClearMonsterRuleInfoView()
        end
    else 
        if ItemEntry then 
            ItemEntry:SetSelected(false)
        end
        self:ClearMonsterRuleInfoView()
    end

    return true
end

-- 设置某个已选Entry的选中状态
function WBP_Battle_Training_Root_C:SetMonsterCheckedEntrySelected(RuleId, bSelected)
    local ItemData = self:GetCheckedItemData(RuleId)
    local ItemEntry = self:GetCheckedItemEntry(RuleId)

    if not ItemData then 
        DebugPrint("Tianyi@ ItemData is nil")
        return 
    end

    if bSelected then 
        self:UnSelectLastSelectedEntry()
        ItemData.Selected = bSelected  
        if ItemEntry then 
            ItemEntry:SetSelected(bSelected)
        end
        self.LastSelectedCheckedItemData = ItemData
        self.LastPressedRule = ItemData.RuleId 
        self:ShowMonsterRuleInfoView(ItemData.RuleId)
    else 
        self:ClearMonsterRuleInfoView()
    end
end

function WBP_Battle_Training_Root_C:SetMonsterEntryChecked(RuleId, bChecked, CheckNumber)
    local ItemData = self:GetMonsterGalleryItemData(RuleId)
    local ItemEntry = self:GetMonsterGalleryItemEntry(RuleId)
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
    end
    self.MonsterCheckedTotalNum = self.MonsterCheckedTotalNum + self.MonsterCheckedNum[RuleId] - LastCheckedNum
end

function WBP_Battle_Training_Root_C:OnMonsterGalleryEntryClicked(Item)
    -- 处理选择逻辑
    if Item.Data.Locked then 
        self:ShowLockedInfo()
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_disable", nil, nil)
        return 
    end

    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
    self:SetMonsterGalleryEntrySelected(Item.RuleId, true)
    local CanCheck = self:CheckMonsterGalleryItemCanChecked(Item)
    -- 待选列表：选择和取消选择某个怪物，更新对应的数量和总数
    if not Item.Data.IsChecked and CanCheck then 
        self:SetMonsterEntryChecked(Item.RuleId, true)
    elseif Item.Data.IsChecked then 
        self:SetMonsterEntryChecked(Item.RuleId, false)
    end
    
    self:UpdateSelectedNum(Item.RuleId)
end

-- 在底部显示当前怪物已被锁定的提示
function WBP_Battle_Training_Root_C:ShowLockedInfo()
    self.WS:SetActiveWidgetIndex(2)
end

-------------------------------- 已选敌人信息 --------------------------------
function WBP_Battle_Training_Root_C:OnCheckedMonsterEntryClicked(Item)
    DebugPrint("Tianyi@ OnCheckedMonsterEntryClicked, RuleId = " .. Item.RuleId)
    self:SetMonsterCheckedEntrySelected(Item.RuleId, true)
    self:UpdateSelectedNum(Item.RuleId)
end

function WBP_Battle_Training_Root_C:SelectCheckedItemData(ItemData)
    self:UnSelectLastSelectedEntry()
    ItemData.Selected = true 
    self.LastSelectedCheckedItemData = ItemData
    self.LastPressedRule = ItemData.RuleId
    self:UpdateSelectedNum(ItemData.RuleId)
    self.Text_ChooseNum:SetText(ItemData.CheckedNum)
end

-- 取消选择所有Items
function WBP_Battle_Training_Root_C:RemoveAllCheckedItems()
    if self.IsCheckedPreviewPanelDisplayed then 
        self:OnShowSelectedMonstersButtonClicked()
    end

    self:UnSelectLastSelectedEntry()

    for RuleId, _ in pairs(self.MonsterChecked) do 
        local MonsterGalleryItemData = self:GetMonsterGalleryItemData(RuleId)
        if MonsterGalleryItemData then 
            MonsterGalleryItemData.IsChecked = false
            MonsterGalleryItemData.CheckedNum = nil
            local MonsterGalleryItemEntry = self:GetMonsterGalleryItemEntry(RuleId)
            if MonsterGalleryItemEntry then  
                MonsterGalleryItemEntry:OnItemChecked(false)
            end
        end
    end

    self.MonsterChecked = {}
    self.MonsterCheckedNum = {}
    self.MonsterCheckedTotalNum = 0

    self:UpdateSelectedNumView(0, 0, self:GetMaxSpawnableNum(), self:GetMaxSpawnableNum())
    self:ClearMonsterRuleInfoView()

    local CurrentState = self.ControllerFSM:Current()
    if CurrentState == FSMStates.FocusBottom then 
        self.Tab:SetFocus()
        self.ControllerFSM:Enter(FSMStates.FocusTab)
    end
end

function WBP_Battle_Training_Root_C:RemoveItemsFromMonsterChecked()
    -- 已选列表：将 Items 从已选列表删除
    self:PlayAnimation(self.List_Out)
    UIUtils.StopListViewFramingInAnimation(self.List_Select_Mod, {TimerKeys = self._SelectedMonsterListInTimers, UIState = self})
    self.List_Select_Mod:ClearListItems()
end

function WBP_Battle_Training_Root_C:AddItemsToMonsterChecked()
    self.List_Select_Mod:ClearListItems()
    local FirstItemSelected = false
    for RuleId, Value in pairs(self.MonsterChecked) do 
        local Rule = DataMgr.GalleryRule[RuleId]
        if Rule and Value == true and MonsterUtils.CheckGallerRuleByMonsterRelease(Rule) then
            local ItemData = NewObject(UIUtils.GetCommonItemContentClass())
            ItemData.Owner = self
            -- ItemData.Index = Index
            ItemData.RuleId = RuleId
            ItemData.CheckedNum = self.MonsterCheckedNum[RuleId]
            ItemData.bCheckPreview = true
            ItemData.PreferredMonsterId = Rule.PreferredMonsterId

            ItemData.OnClicked = {Func = self.OnCheckedMonsterEntryClicked, Inst = self}
            ItemData.OnDeclineClicked = {Func = self.OnSelectedItemDeclineClicked, Inst = self}
            ItemData.IsChecked = false
            self.List_Select_Mod:AddItem(ItemData)

            if not FirstItemSelected then 
                self.WS:SetActiveWidgetIndex(1)
                self:UpdateSelectedNum(ItemData.RuleId)
                self:SetMonsterCheckedEntrySelected(ItemData.RuleId, true)
                self:ShowMonsterRuleInfoView(ItemData.RuleId)
                FirstItemSelected = true
            end

        end
    end
    
    local Params = {
        Callback = function()
            local RestCount = UIUtils.GetListViewContentMaxCount(self.List_Select_Mod) - self.List_Select_Mod:GetNumItems()
            for i = 1, RestCount do
                local ItemData = NewObject(UIUtils.GetCommonItemContentClass())
                ItemData.IsEmpty = true
                self.List_Select_Mod:AddItem(ItemData)
            end
        end
    }
    self._SelectedMonsterListInTimers = UIUtils.PlayListViewFramingInAnimation(self, self.List_Select_Mod, Params)
    self:PlayAnimation(self.List_In)
end

-- 已选列表：展开和收起已选列表
function WBP_Battle_Training_Root_C:OnShowSelectedMonstersButtonClicked()
    -- self.Image_Icon_1:SetawRenderScale(FVector2D(1, self.IsCheckedPreviewPanelDisplayed))

    if not self.IsCheckedPreviewPanelDisplayed then
        self.CachedRuleId2CheckedItemData = {}
        self.CachedRuleId2CheckedItemEntry = {}
        self:AddItemsToMonsterChecked()
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
        AudioManager(self):PlayUISound(self, "event:/ui/common/sub_panel_expand", "TrainingPanelExpand", nil)
    else 
        if self.LastSelectedCheckedItemData then
            local LastSelectedCheckedItemRuleId = self.LastSelectedCheckedItemData.RuleId 
            self:SetMonsterGalleryEntrySelected(LastSelectedCheckedItemRuleId, true, true)
        end
        self:RemoveItemsFromMonsterChecked() 
        AudioManager(self):SetEventSoundParam(self, "TrainingPanelExpand", {ToEnd = 1})
    end
    self.IsCheckedPreviewPanelDisplayed = not self.IsCheckedPreviewPanelDisplayed
end

function WBP_Battle_Training_Root_C:OnSelectedItemDeclineClicked(ItemData)
    DebugPrint("Tianyi@ OnSelectedItemDeclineClicked")
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_minus", nil, nil)
    self:RemoveFromSelectedList(ItemData)
    if self.MonsterCheckedTotalNum <= 0 then 
        self:RemoveAllCheckedItems()
        -- 回到聚焦Panel的状态
        self.ControllerFSM:Enter(FSMStates.FocusPanel)
        self.Tab:SetFocus()
    end
end

function WBP_Battle_Training_Root_C:RemoveFromSelectedList(ItemData)

    -- 已选列表：点击 Decline 按钮，减选当前怪物
    local RuleId = ItemData.RuleId
    local Index = self.List_Select_Mod:GetIndexForItem(ItemData)
    local LastCheckedNum = self.MonsterCheckedNum[RuleId]
    local MonsterTypesCheckedNum = self:GetCheckedMonsterTypesNum()

    self:SetMonsterGalleryEntrySelected(RuleId, false)
    self:SetMonsterEntryChecked(RuleId, false)

    -- 重新选中第一个
    DebugPrint("Tianyi@ MonsterTypesCheckedNum = " .. tostring(MonsterTypesCheckedNum))
    if ItemData == self.LastSelectedCheckedItemData and MonsterTypesCheckedNum > 1 then
        local NextItemData = self.List_Select_Mod:GetItemAt(Index == 0 and 1 or 0) 
        self:SetMonsterCheckedEntrySelected(NextItemData.RuleId, true)
        local NextItemEntry = self:GetCheckedItemEntry(NextItemData.RuleId)
        NextItemEntry:SetSelected(true)
        if self.CurInputDeviceType == UE4.ECommonInputType.Gamepad then 
            NextItemEntry:SetFocus()
        end
    end

    if ItemData.RuleId == self.LastSelectedCheckedItemData.RuleId then 
        self.LastSelectedCheckedItemData = nil 
    end
    if self.LastSelectedItemData and ItemData.RuleId == self.LastSelectedItemData.RuleId then 
        self.LastSelectedItemData = nil 
    end
        
    self.List_Select_Mod:RemoveItem(ItemData)

    -- 补充空态
    local ItemData = NewObject(UIUtils.GetCommonItemContentClass())
    ItemData.IsEmpty = true
    self.List_Select_Mod:AddItem(ItemData)
    self.List_Select_Mod:AddEmptyGridItemCount(1)

    -- 数量调整：更新滑动条范围
    if self.LastPressedRule ~= nil then
        self:UpdateSelectedNum(self.LastPressedRule)
    end
end

function WBP_Battle_Training_Root_C:OnMonsterCheckedNumChanged(Value)
    AudioManager(self):PlayUISound(self, "event:/ui/common/slider_value_change", nil, nil)
    if self.LastPressedRule == nil then
        self:ClearSelectedNumView()
        return
    end
    
    -- 数量调整：更新当前怪物选择的数量和所有怪物选择的数量，StepSize 是 1
    Value = math.floor(Value + 0.5)
    local LastCheckedNum = self.MonsterCheckedNum[self.LastPressedRule]
    self.MonsterCheckedNum[self.LastPressedRule] = Value
    self.MonsterCheckedTotalNum = self.MonsterCheckedTotalNum + self.MonsterCheckedNum[self.LastPressedRule] - LastCheckedNum

    -- 数量调整：更新数量滑动条
    self:UpdateSelectedNum(self.LastPressedRule)
end

function WBP_Battle_Training_Root_C:UpdateSelectedNum(RuleId)
    local SelectedItemData = self:GetMonsterGalleryItemData(RuleId)
    if SelectedItemData then 
        SelectedItemData.CheckedNum = self.MonsterCheckedNum[RuleId] 
    end
    local SelectedItemEntry = self:GetMonsterGalleryItemEntry(RuleId)
    if SelectedItemEntry then 
        SelectedItemEntry:UpdateItemView()
    end

    if self.IsCheckedPreviewPanelDisplayed then
        local CheckedSelectedItemData = self:GetCheckedItemData(RuleId)
        if CheckedSelectedItemData then 
            CheckedSelectedItemData.CheckedNum = self.MonsterCheckedNum[RuleId] 
        end
        local CheckedSelectedItemEntry = self:GetCheckedItemEntry(RuleId)
        if CheckedSelectedItemEntry then 
            CheckedSelectedItemEntry:UpdateItemView()
        end
    end
    local MaxSpawnableNum = self:GetMaxSpawnableNum()
    local SelectedNum = self.MonsterCheckedNum[RuleId] or 0
    local SelectableNum = MaxSpawnableNum - self.MonsterCheckedTotalNum + (self.MonsterCheckedNum[RuleId] or 0)
    self:UpdateSelectedNumView(SelectedNum, self.MonsterCheckedTotalNum, MaxSpawnableNum, SelectableNum)
end

-- 更新数量
function WBP_Battle_Training_Root_C:UpdateSelectedNumView(CurrentSelectedNum, TotalSelectedNum, MaxSelectedNum, CurrentSelectableNum)
    -- DebugPrint("Tianyi@ UpdateSelectedNumView: ", CurrentSelectedNum, TotalSelectedNum, MaxSelectedNum, CurrentSelectableNum)
    self.WS:SetActiveWidgetIndex(1)
    self.Text_SelectedChoosNum:SetText(TotalSelectedNum)
    self.Text_SelectedTotalNum:SetText(MaxSelectedNum)
    self.Text_ChooseNum:SetText(CurrentSelectedNum)

    self.Btn_Delete:ForbidBtn(false)
    self.Btn_Show:ForbidBtn(false)
    self.Btn_Confirm:ForbidBtn(false)
    self.Btn_Show_ButtonArea:SetIsEnabled(true)
    self.Key_BottomNum:SetForbidKey(false)
    self.Key_BottomDelete:SetForbidKey(false)

    local BtnMinEnabled = true 
    local BtnAddEnabled = true 
    local BtnMaxEnabled = true
    local SliderEnabled = true


    if not CurrentSelectedNum or CurrentSelectedNum <= 0 then 
        if MaxSelectedNum > 0 and ((not TotalSelectedNum) or (TotalSelectedNum <= 0)) then 
            self:ClearSelectedNumView()
            self:SetTextSelectColor(self.Text_SelectedChoosNumNormal)
            return 
        else
            if not self.LastPressedRule then 
                self.WS:SetActiveWidgetIndex(0)
            else 
                -- 普通选中模式，仅仅显示怪物信息
                self.WS:SetActiveWidgetIndex(1)
                self:ShowMonsterRuleInfoView(self.LastPressedRule)
                BtnMinEnabled = false 
                BtnAddEnabled = false
                BtnMaxEnabled = false 
                SliderEnabled = false

                -- self:SetButtonAndSliderEnabled(false, false, false, false)
                UIManager(self):ShowUITip(UIConst.Tip_CommonToast, string.format(GText("UI_DUNGEON_DES_TRAINING_8"), self.TrainingData.MaxEnemyNum))
                
            end
            -- return 
        end
    end


    local TextColor = self.Text_SelectedChoosNumNormal
    if CurrentSelectedNum <= 1 or TotalSelectedNum <= 1 then
        BtnMinEnabled = false 
    end

    if TotalSelectedNum >= MaxSelectedNum then
        BtnAddEnabled = false 
        BtnMaxEnabled = false 
        TextColor = self.Text_SelectedChoosNumRed
    end

    self:SetButtonAndSliderEnabled(BtnMinEnabled, BtnAddEnabled, BtnMaxEnabled, SliderEnabled)
    self:SetTextSelectColor(TextColor)

    self.Com_Slider:SetMinValue(1)
    self.Com_Slider:SetMaxValue(CurrentSelectableNum)
    self.Com_Slider:SetValue(CurrentSelectedNum)
    self.Com_Slider:RefreshBaseInfo()
    self.Com_Slider:UpdateSliderAndProgress()
    

    -- self.ProgressBar_Num:SetPercent((CurrentSelectedNum - 1) / (CurrentSelectableNum - 1))
end

function WBP_Battle_Training_Root_C:ClearSelectedNumView()
    self.LastPressedRule = nil 
    self:SetTextSelectColor(self.Text_SelectedChoosNumNormal)
    self.WS:SetActiveWidgetIndex(0)

    -- 数量调整：使滑动条失效
    local MaxSpawnableNum = self:GetMaxSpawnableNum()
    self.Text_ChooseNum:SetText("0")
    self.Text_SelectedChoosNum:SetText(self.MonsterCheckedTotalNum)
    self.Text_SelectedTotalNum:SetText(MaxSpawnableNum)

    if MaxSpawnableNum <= 0 then 
        self:SetTextSelectColor(self.Text_SelectedChoosNumRed)
    end

    self:SetButtonAndSliderEnabled(false, false, false, false)

    self.Btn_Delete:ForbidBtn(true)
    self.Btn_Show:ForbidBtn(true)
    self.Btn_Confirm:ForbidBtn(true)
    self.Btn_Show_ButtonArea:SetIsEnabled(false)
    self.Key_BottomNum:SetForbidKey(true)
    self.Key_BottomDelete:SetForbidKey(true)
    self.Com_Slider:SetMinValue(0)
    self.Com_Slider:SetMaxValue(1)
    self.Com_Slider:SetValue(0)
    self.Com_Slider:UpdateSliderAndProgress()

end

function WBP_Battle_Training_Root_C:SetTextSelectColor(TextColor)
    if not self.CurrentSelectedNumColor or self.CurrentSelectedNumColor ~= TextColor then 
        self.Text_SelectedChoosNum:SetColorAndOpacity(TextColor)
        self.CurrentSelectedNumColor = TextColor
    end
end

function WBP_Battle_Training_Root_C:SetButtonAndSliderEnabled(BtnMinEnabled, BtnAddEnabled, BtnMaxEnabled, SliderEnabled)
    self.Com_Slider:SetEnabled(SliderEnabled)
end

function WBP_Battle_Training_Root_C:OnBtnDeleteClicked()
    self:RemoveAllCheckedItems()
end

function WBP_Battle_Training_Root_C:OnMinusSelectedMonsterNumClicked(NewValue)
    -- 数量调整：更新滑动条显示
    if self.LastPressedRule ~= nil then
        self.MonsterCheckedTotalNum = self.MonsterCheckedTotalNum - self.MonsterCheckedNum[self.LastPressedRule] + NewValue
        self.MonsterCheckedNum[self.LastPressedRule] = NewValue
        self:UpdateSelectedNum(self.LastPressedRule)
    end
end

function WBP_Battle_Training_Root_C:OnAddSelectedMonsterNumClicked(NewValue)
    -- 数量调整：更新滑动条显示
    if self.LastPressedRule ~= nil then
        self.MonsterCheckedTotalNum = self.MonsterCheckedTotalNum - self.MonsterCheckedNum[self.LastPressedRule] + NewValue
        self.MonsterCheckedNum[self.LastPressedRule] = NewValue
        self:UpdateSelectedNum(self.LastPressedRule)
    end
end

function WBP_Battle_Training_Root_C:OnMaxSelectedMonsterNumClicked()
    -- 数量调整：更新滑动条显示
    if self.LastPressedRule ~= nil then
        local SelectableNum = self:GetMaxSpawnableNum() - self.MonsterCheckedTotalNum
        self.MonsterCheckedNum[self.LastPressedRule] = self.MonsterCheckedNum[self.LastPressedRule] + SelectableNum
        self.MonsterCheckedTotalNum = self.MonsterCheckedTotalNum + SelectableNum
        self:UpdateSelectedNum(self.LastPressedRule)
    end
end


---- Utils 
function WBP_Battle_Training_Root_C:GetMonsterGalleryItemData(RuleId)
    if self.CachedRuleId2ItemData[RuleId] and self.CachedRuleId2ItemData[RuleId].RuleId == RuleId then
        return self.CachedRuleId2ItemData[RuleId]
    end

    local AllListItems = self.List_Item:GetListItems()
    for _, Item in pairs(AllListItems) do 
        if Item.RuleId == RuleId then 
            self.CachedRuleId2ItemData[RuleId] = Item
            return Item 
        end
    end

    self.CachedRuleId2ItemData[RuleId] = nil
    return nil 
end

function WBP_Battle_Training_Root_C:GetMonsterGalleryItemEntry(RuleId)
    if self.CachedRuleId2ItemEntry[RuleId] and self.CachedRuleId2ItemEntry[RuleId].Data.RuleId == RuleId then
        return self.CachedRuleId2ItemEntry[RuleId]
    end

    local AllDisplayedEntries = self.List_Item:GetDisplayedEntryWidgets()
    for _, Item in pairs(AllDisplayedEntries) do 
        if Item.Data.RuleId == RuleId then 
            self.CachedRuleId2ItemEntry[RuleId] = Item
            return Item 
        end
    end

    self.CachedRuleId2ItemEntry[RuleId] = nil
    return nil
end

function WBP_Battle_Training_Root_C:GetCheckedItemData(RuleId)
    if self.CachedRuleId2CheckedItemData[RuleId] and self.CachedRuleId2CheckedItemData[RuleId].RuleId == RuleId then
        return self.CachedRuleId2CheckedItemData[RuleId]
    end

    local AllListItems = self.List_Select_Mod:GetListItems()
    for _, Item in pairs(AllListItems) do 
        if Item.RuleId == RuleId then 
            self.CachedRuleId2CheckedItemData[RuleId] = Item
            return Item 
        end
    end

    self.CachedRuleId2CheckedItemData[RuleId] = nil
    return nil 
end

function WBP_Battle_Training_Root_C:GetCheckedItemEntry(RuleId)
    if self.CachedRuleId2CheckedItemEntry[RuleId] and self.CachedRuleId2CheckedItemEntry[RuleId].Data.RuleId == RuleId then
        return self.CachedRuleId2CheckedItemEntry[RuleId]
    end

    local AllDisplayedEntries = self.List_Select_Mod:GetDisplayedEntryWidgets()
    for _, Item in pairs(AllDisplayedEntries) do 
        if Item.Data.RuleId == RuleId then 
            self.CachedRuleId2CheckedItemEntry[RuleId] = Item
            return Item 
        end
    end

    self.CachedRuleId2CheckedItemEntry[RuleId] = nil
    return nil
end


function WBP_Battle_Training_Root_C:CheckMonsterInCamp(MonsterId, CampOption) 
    -- self.TabId2MonsterCampOption[0] = "All"
    -- self.TabId2MonsterCampOption[#self.TabId2MonsterCampOption] = "Other"

    local MonsterData = DataMgr.Monster[MonsterId]
    if not MonsterData then return false end 
    if CampOption == self.TabId2MonsterCampOption[1] then return true end  
    local MonsterGamePlayTags = MonsterData.GamePlayTags or {}

    for _, Tag in ipairs(MonsterGamePlayTags) do 
        if CampOption == self.TabId2MonsterCampOption[#self.TabId2MonsterCampOption] then 
            for Index, Option in ipairs(self.TabId2MonsterCampOption) do 
                if Option == self.TabId2MonsterCampOption[0] or Option == self.TabId2MonsterCampOption[#self.TabId2MonsterCampOption] then goto continue end 
                if Tag == Option then return false end
                ::continue::
            end
        elseif Tag == CampOption then 
            return true 
        end 
    end

    return CampOption == self.TabId2MonsterCampOption[#self.TabId2MonsterCampOption]   
end

-- 当前最大可生成敌人数量 = 最大可选怪物数量 - 场上怪物数量
function WBP_Battle_Training_Root_C:GetMaxSpawnableNum()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local MonsterNum = GameState.MonsterNum
    return math.max(0, self.TrainingData.MaxEnemyNum - MonsterNum)
end

function WBP_Battle_Training_Root_C:GetCheckedMonsterTypesNum()
    local CheckedMonsterTypesNum = 0
    for _, Checked in pairs(self.MonsterChecked) do 
        CheckedMonsterTypesNum = CheckedMonsterTypesNum + 1
    end

    return CheckedMonsterTypesNum
end

----------- 训练场相关功能

function WBP_Battle_Training_Root_C:GetTrainingComp()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then 
        return GameMode:GetDungeonComponent()
    end

    return nil
end

-- 创建选中的怪物
function WBP_Battle_Training_Root_C:TrainingCreateMonster()
    if not self.MonsterChecked then return end 
    if self.IsClosing then return end

    local MonstersToSpawn = {}
    for RuleId, _ in pairs(self.MonsterChecked) do 
        local RuleData = DataMgr.GalleryRule[RuleId]
        local MonsterId = RuleData.PreferredMonsterId
        if MonsterId and self.MonsterCheckedNum[RuleId] then 
            table.insert(MonstersToSpawn, {MonsterId, self.MonsterCheckedNum[RuleId], self.EnemyLevelToSpawn})
        end
    end
    if #MonstersToSpawn <= 0 then
        return
    end

    self:GetTrainingComp():CreateMonster(MonstersToSpawn)
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, string.format(GText("UI_DUNGEON_DES_TRAINING_5"), self.MonsterCheckedTotalNum))

    self.Btn_Confirm:ForbidBtn(true)
    self:ClosePanel()
end

-- 当前训练场是否禁用怪物AI
function WBP_Battle_Training_Root_C:GetIsEnemyAIForbidden()
    local TrainingComp = self:GetTrainingComp()
    if TrainingComp then
        return TrainingComp.MonsterNeedToStartBT
    end
    
    return nil
end

-- 设置禁用训练场怪物AI 
function WBP_Battle_Training_Root_C:SetEnemyAIForbidden(IsForbidden)
    local TrainingComp = self:GetTrainingComp()
    if TrainingComp then 
        TrainingComp:SetMonsterAI(IsForbidden)
        self:GetIsEnemyAIForbidden()
    end
end

-- 获得玩家无敌状态
function WBP_Battle_Training_Root_C:GetPlayerInvincible()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    if PlayerController then
        local PlayerCharacter = PlayerController:GetMyPawn()
        return PlayerCharacter:IsInvincible()
    end
end


-- 设置玩家无敌状态
function WBP_Battle_Training_Root_C:SetPlayerInvincible(IsInvincible)
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    if PlayerController then
        local PlayerCharacter = PlayerController:GetMyPawn()
        PlayerCharacter:SetInvincible(IsInvincible, "Training")
    end
end

function WBP_Battle_Training_Root_C:ClosePanel()
    self.IsClosing = true
    self:SetPlayerEndInteractive()
    self.Owner:Close()
end

AssembleComponents(WBP_Battle_Training_Root_C)

return WBP_Battle_Training_Root_C