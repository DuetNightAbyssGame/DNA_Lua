local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
local ActorController = require "BluePrints.UI.WBP.Armory.ActorController.Armory_ActorController"
local TimeUtils = require "Utils.TimeUtils"
local EMCache = require "EMCache.EMCache"
local UIUtils = require "Utils.UIUtils"
--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_SquadBuild_Main_P_C
local WBP_SquadBuild_Main_P_C = Class("BluePrints.UI.BP_UIState_C")

--function M:Initialize(Initializer)
--end
local UnHandled = UE.UWidgetBlueprintLibrary.UnHandled()

function WBP_SquadBuild_Main_P_C:Construct()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return 
    end
    --获取到当前拥有的预设阵容 没有预设阵容的情况下会把当前的配置作为第一套预设阵容
    Avatar:TryCreateDefaultSquad()

    self.TypeTabs = {
        [self.SlotName2Type[self.ESlotName.RangedWeapon]] = self.List_Build.Type_Range,
        [self.SlotName2Type[self.ESlotName.MeleeWeapon]] = self.List_Build.Type_Melee
    }
    self.List_Build.Type_Range:Init(self.SlotName2Type[self.ESlotName.RangedWeapon], self)
    self.List_Build.Type_Melee:Init(self.SlotName2Type[self.ESlotName.MeleeWeapon], self)
    self.List_Build.Tab_Primary:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self:RegisterBtnIconInGampad()--按钮手柄图标初始化
    self:AddLSFocusTarget(self.List_Build.Sort.Controller, {self.List_Build.Sort})
end


--function M:Tick(MyGeometry, InDeltaTime)
--end

function WBP_SquadBuild_Main_P_C:Destruct()
    WBP_SquadBuild_Main_P_C.Super.Destruct(self)
    AudioManager(self):SetEventSoundParam(self, "OpenSquad", {ToEnd = 1})
    self:QuitSquadSetting()
end

WBP_SquadBuild_Main_P_C._components = {
    "BluePrints.UI.UI_PC.Common.LSFocusComp",
    "BluePrints.UI.WBP.Abyss.MainComponent.Abyss_CharMainComponent",
    "BluePrints.UI.WBP.Abyss.MainComponent.Abyss_PetMainComponent",
    "BluePrints.UI.WBP.Abyss.MainComponent.Abyss_WeaponMainComponent",
}

local SelectSoundPaths = {
    Char = "event:/ui/armory/click_select_role",
    Weapon = "event:/ui/armory/click_select_weapon",
    Pet = "event:/ui/common/click_select_pet",
    Default = "event:/ui/common/click_mid",
}

local EquipSoundPaths = {
    Char = "event:/ui/common/role_replace",
    Weapon = "event:/ui/common/weapon_replace",
    Pet = "event:/ui/common/role_replace",
}

WBP_SquadBuild_Main_P_C.ESlotName = {
    Char = 1,
    MeleeWeapon = 2,
    RangedWeapon = 3,
    Phantom1 = 4,
    PhantomWeapon1 = 5,
    Phantom2 = 6,
    PhantomWeapon2 = 7,
    Pet = 8,
    Null = 0,
}

WBP_SquadBuild_Main_P_C.SlotType2DataType = {
    ["Char"] = "Char",
    ["Pet"] = "Pet",
    ["Weapon"] = "Weapon",
    ["Ranged"] = "Weapon",
    ["Melee"] = "Weapon",
}

WBP_SquadBuild_Main_P_C.GamepadArea = {
    "SquadList",
    "RightDetatilInSquadList",
    "RightDetatilInSingleSquad",
}

WBP_SquadBuild_Main_P_C.SlotName2Type = {
    [WBP_SquadBuild_Main_P_C.ESlotName.Char] = "Char",
    [WBP_SquadBuild_Main_P_C.ESlotName.Pet] = "Pet",
    [WBP_SquadBuild_Main_P_C.ESlotName.RangedWeapon] = "Ranged",
    [WBP_SquadBuild_Main_P_C.ESlotName.MeleeWeapon] = "Melee",
    [WBP_SquadBuild_Main_P_C.ESlotName.Phantom1] = "Char",
    [WBP_SquadBuild_Main_P_C.ESlotName.PhantomWeapon1] = "Weapon",
    [WBP_SquadBuild_Main_P_C.ESlotName.Phantom2] = "Char",
    [WBP_SquadBuild_Main_P_C.ESlotName.PhantomWeapon2] = "Weapon",
}

WBP_SquadBuild_Main_P_C.SlotName2TextMap = {
    [WBP_SquadBuild_Main_P_C.ESlotName.Char] = GText("UI_Armory_Char"),
    [WBP_SquadBuild_Main_P_C.ESlotName.Pet] = GText("MAIN_UI_PET"),
    [WBP_SquadBuild_Main_P_C.ESlotName.RangedWeapon] = GText("Ranged")..GText("UI_SHOP_SUBTAB_NAME_WEAPON"),
    [WBP_SquadBuild_Main_P_C.ESlotName.MeleeWeapon] = GText("Melee")..GText("UI_SHOP_SUBTAB_NAME_WEAPON"),
    [WBP_SquadBuild_Main_P_C.ESlotName.Phantom1] = GText("UI_STAT_Sigil").."1",
    [WBP_SquadBuild_Main_P_C.ESlotName.PhantomWeapon1] = GText("UI_STAT_Sigil").."1"..GText("UI_SHOP_SUBTAB_NAME_WEAPON"),
    [WBP_SquadBuild_Main_P_C.ESlotName.Phantom2] = GText("UI_STAT_Sigil").."2",
    [WBP_SquadBuild_Main_P_C.ESlotName.PhantomWeapon2] = GText("UI_STAT_Sigil").."2"..GText("UI_SHOP_SUBTAB_NAME_WEAPON"),
}


function WBP_SquadBuild_Main_P_C:InitUIInfo(Name, IsInUIMode, EventList, ...)
    self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
    self.SelectIndex, self.IsOpenAddSquad = ...
    self.IsFromDungeonPage = self.SelectIndex or self.IsOpenAddSquad
    --获取预设阵容必要的数据
    self:InitSquadData()
    --初始化按钮的手柄图标
    self:UpdateGamepadIcon()
    --Tab控件内容更新
    self:InitTabUI()
    --初始化一些左边列表相关信息
    self:InitLeftListItemInfo()
    --左边信息栏初始化(默认是预设阵容列表)
    self:SwitchToSquadList(false)
    --按钮初始化
    self:InitTextAndBtn()
    --隐藏场景中的npc（委托进入时隐藏委托小白）
    self:HideNpc()
    AudioManager(self):PlayFMODSound(self, nil, "event:/ui/armory/open", "OpenSquad")
end

function WBP_SquadBuild_Main_P_C:OnLoaded(...)

end

--右边信息栏初始化 默认加载第一个预设阵容
function WBP_SquadBuild_Main_P_C:InitRightDetailPanel()
    --拖拽中暂时不需要更新右边信息
    if self.IsDraging then  
        return 
    end
    self.CurSelectSquadIndex = self.CurSelectSquadIndex > self.SquadListLen and 1 or self.CurSelectSquadIndex
    if self.CurSelectSquadIndex > self.SquadListLen then
        self.SquadInfo = self.CurSquadInfo
    else
        self.SquadInfo = self.SquadInfoList[self.CurSelectSquadIndex]
    end
    --初始化当前临时存储数据
    self:InitCurSquadInfo()
    self:UpdateRightDetailPanel()
end

--初始化一些左边列表相关信息
function WBP_SquadBuild_Main_P_C:InitLeftListItemInfo()
    self.TypeTabs = {
        [self.SlotName2Type[self.ESlotName.RangedWeapon]] = self.List_Build.Type_Range,
        [self.SlotName2Type[self.ESlotName.MeleeWeapon]] = self.List_Build.Type_Melee
    }
    self.List_Build.Type_Range:Init(self.SlotName2Type[self.ESlotName.RangedWeapon], self)
    self.List_Build.Type_Melee:Init(self.SlotName2Type[self.ESlotName.MeleeWeapon], self)
    self.List_Build.Tab_Primary:SetVisibility(UE4.ESlateVisibility.Collapsed)

    self:CharMain_InitWidget()
    self:WeaponMain_InitWidget()
    self:PetMain_InitWidget()
end

function WBP_SquadBuild_Main_P_C:HideNpc()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    UIManager:HideNpcActor(true, "StyleOfPlay")
end

--文本和按钮相关的初始化
function WBP_SquadBuild_Main_P_C:InitTextAndBtn()
    --文本初始化 左边
    self.Text_Default:SetText(GText("UI_Squad_ListName"))
    self.Text_Has:SetText(self.SquadListLen)
    self.Text_All:SetText(self.SquadMax)
    self.Text_SortTip:SetText(GText("UI_Squad_Adjust_Sort"))
    --文本初始化 右边
    self.Text_Character:SetText(GText("UI_Armory_Char"))
    self.Text_Phantom:SetText(GText("UI_Shadow_Name"))
    self.Text_Phantom01:SetText(GText("UI_Squad_Sigil1"))
    self.Text_Phantom02:SetText(GText("UI_Squad_Sigil2"))

    --轮盘列表的前往军械库轮盘界面  
    self:UpdateBtnInfo(self.Btn_Armory, GText("UI_BAG_Gotoarmory"), self.GoToArmory)
    --保存阵容按钮
    self:UpdateBtnInfo(self.Btn_Save, GText("UI_RegionMap_Save"), self.SaveSquad)
    --取消编辑阵容按钮
    self:UpdateBtnInfo(self.Btn_Cancel, GText("UI_RegionMap_Cancel"), self.CancelCreateSquadAndBackToSquadList)
    --删除阵容
    self:UpdateBtnInfo(self.Btn_Delete, nil, function()
        self:DeleteSquad()
        AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_small", nil, nil) 
    end)
    --初始化时 按钮应该是编辑阵容
    self:UpdateBtnInfo(self.Btn_Edit, GText("UI_Squad_Edit"), function()
        self:EditorSquad()
        AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_confirm", nil, nil)
    end)
    --修改队伍名字
    self:UpdateBtnInfo(self.Btn_EditName, nil, self.EditSquadName)
    --用于右边细节面板下方两个按钮的切换
    self:SwitchBtnPanel("SquadList")
end

--用于右边细节面板下方两个按钮的切换
function WBP_SquadBuild_Main_P_C:SwitchBtnPanel(PanelType)
    if PanelType == "SquadList" then
        self.HB_Detail:SetVisibility(ESlateVisibility.Collapsed)
        self.HB_Edit:SetVisibility(ESlateVisibility.Visible)
    else
        self.HB_Detail:SetVisibility(ESlateVisibility.Visible)
        self.HB_Edit:SetVisibility(ESlateVisibility.Collapsed)
    end
end

--编辑预设阵容名字
function WBP_SquadBuild_Main_P_C:EditSquadName()
    self.IsFocusList = self:CheckIsInItemList()
    self.IsEditSquadName = true
    self.NameEditDialog = UIManager(self):ShowCommonPopupUI(100133, {
        OnCloseCallbackObj = self,
        OnCloseCallbackFunction = self.OnCloseInputDialogCallback,
        EditTextConfig = {
            Owner = self,
            IsMultiLine = false,
            Text = self.Text_DefaultName:GetText(),
            HintText = GText("UI_Squad_InputHint"),
            TextLimit = DataMgr.GlobalConstant.NicknameMaxLen.ConstantValue,
            bNeedCheckStringSensitive = true,
            OnCheckStringSensitive = function(self, IsSensitive, Name)
                if IsSensitive then
                    self:TextCommitted()  
                end
            end,
            Events = {
                OnTextChanged = function(self, Text)
                    self.SquadNameTemp = Text
                    if (Text == self.CurSquadInfo.Name) then
                        self.NameEditDialog:GetButtonBar().Btn_Yes:UnBindEventOnClickedByObj(self)
                        self.NameEditDialog:GetButtonBar().Btn_Yes:ForbidBtn(true)
                    elseif Text == "" then
                        self.NameEditDialog:GetButtonBar().Btn_Yes:UnBindEventOnClickedByObj(self)
                        self.NameEditDialog:GetButtonBar().Btn_Yes:ForbidBtn(true)
                        self.NameEditDialog:GetButtonBar().Btn_Yes:BindForbidStateExecuteEvent(self, self.NoStrWarning)
                    else
                        self.NameEditDialog:GetButtonBar().Btn_Yes:ForbidBtn(false)
                    end
                end
            },
        },
        Owner = self,
        Title=GText("UI_SquadName_Change"),
    }, self)
end

function WBP_SquadBuild_Main_P_C:OnCloseInputDialogCallback()
    self.IsEditSquadName = false
    if self.IsFocusList then
        self:FocusOnItemList()
    else
        self:AddDelayFrameFunc(
            function()
                self:FocusOnRightDetailPanel()
            end, 2, "DelayFocusItem")
        return
    end
end

function WBP_SquadBuild_Main_P_C:TextCommitted()
    self.Text_DefaultName:SetText(self.SquadNameTemp)
    self:UpdateCurSquadInfo("Name", self.SquadNameTemp)
    if not self.IsInEditor then
        self:RealSaveSquad()
    end
end

function WBP_SquadBuild_Main_P_C:NoStrWarning()
    self.NameEditDialog.VB_Node:GetChildAt(1):ShowTips(GText("UI_REGISTER_EMPTY"), 2)
end

function WBP_SquadBuild_Main_P_C:AllSlotPlayAnimation(Animation, SlotIndex)
    SlotIndex = SlotIndex and SlotIndex or -1
    for key, value in pairs(self.RightSlots) do
        if value.Index ~= SlotIndex then
            value:StopAllAnimations()
            if Animation == "Normal" and value.PlayNormalAnimation then
                value:PlayNormalAnimation()
            else
                if value.Item then
                    value.Item:PlayAnimation(value.Item[Animation])
                else
                    value:PlayAnimation(value[Animation])
                end

            end
        end
    end
end

--取消编辑然后返回阵容列表
function WBP_SquadBuild_Main_P_C:CancelCreateSquadAndBackToSquadList()
    DebugPrint("thy   取消编辑然后返回阵容列表")
    AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_cancel", nil, nil)
    self.IsNeedSave = self:CheckChangeSquadInfo()
    self.IsNeedPlayRefreshAnimation = true
    --有设置过东西应该弹窗提示
    if self.IsNeedSave then
        if self.CancelPopUI and (not self.CancelPopUI.IsClosing) then
            return
        end
        self.CancelPopUI = self:ShowCommonPopupUI(100171, self.SwitchToSquadListWithAnimation)
        return
    end
    if self.IsOpenAddSquad then
        self.IsOpenAddSquad = false
        self.IsFromDungeonPage = false
        self:Close()
        return
    end
    self:SwitchToSquadList(true)
end

--供委托使用跳转预设阵容-增加预设阵容的接口
function WBP_SquadBuild_Main_P_C:JumpToAddSquad()
    self.IsOpenAddSquad = true
    self.IsFromDungeonPage = true
    self:AddSquad()
end

--供委托使用跳转预设阵容-编辑指定预设阵容的接口
function WBP_SquadBuild_Main_P_C:JumpToEditSquadByIndex(CurIndex)
    self.CurSelectSquadIndex = CurIndex
    self.IsFromDungeonPage = true
    self:SwitchToSquadList(true)
end

function WBP_SquadBuild_Main_P_C:SwitchToSquadListWithAnimation()
    if self.IsOpenAddSquad then
        self.IsOpenAddSquad = false
        self.IsFromDungeonPage = false
        self:Close()
        return
    end
    self:SwitchToSquadList(true)
end

function WBP_SquadBuild_Main_P_C:UpdateBtnInfo(BtnWidget, Text, Callback)
    BtnWidget.Button_Area.OnClicked:Clear()
    BtnWidget.Button_Area.OnClicked:Add(self, Callback)
    if Text then
        BtnWidget:SetText(Text)
    end
end

--删除阵容
function WBP_SquadBuild_Main_P_C:DeleteSquad()
    DebugPrint("thy   删除阵容")
    local Params = {
        RightCallbackObj = self,
        RightCallbackFunction = self.RealDeleteSquad,
        ShortText = string.format(GText("UI_Squad_DeleteReConfirm"), self.CurSquadInfo.Name),
    }
    self.DeleteSquadTips = UIManager(self):ShowCommonPopupUI(100170, Params, self)
end

--真正删除阵容
function WBP_SquadBuild_Main_P_C:RealDeleteSquad()
    local SquadWidget = self:GetSquadWidgetInSquadList(self.CurSelectSquadIndex)
    if not SquadWidget then
        return
    end
    self.Avatar:DeleteSquad(nil, SquadWidget.FakeIndex)
    self.CurSelectSquadIndex = 1
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_Squad_DeleteSuccess"))
    --self:SwitchToSquadList(false)
end

--编辑阵容回调
function WBP_SquadBuild_Main_P_C:EditorSquad()
    DebugPrint("thy   编辑阵容")
    self:UpdateBtnInfo(self.Btn_Save, GText("UI_RegionMap_Save"), self.SaveSquad)
    self:ResetAllSlotsClickState()
    self.Character:OnClickCallback()
end

--保存预设阵容
function WBP_SquadBuild_Main_P_C:SaveSquad()
    DebugPrint("thy   保存阵容")
    AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_confirm", nil, nil)
    local IsMainRoleSlotLack = false
    if self.Btn_Save.IsForbidden then
        if self:CheckForceSlotIsLack() then
            for key, value in pairs(self.PlayerForceSlot) do
                if value.Uuid == "" or value.Uuid == nil then
                    value.Item:PlayAnimation(value.Item.FlashRed)
                    IsMainRoleSlotLack = true
                end
            end
            if self.PhantomSlot.Head_Phantom01.Uuid and (not self.PhantomSlot.Weapon_Phantom01.Uuid) then
                self.PhantomSlot.Weapon_Phantom01.Item:PlayAnimation(self.PhantomSlot.Weapon_Phantom01.Item.FlashRed)
            end
            if self.PhantomSlot.Head_Phantom02.Uuid and (not self.PhantomSlot.Weapon_Phantom02.Uuid) then
                self.PhantomSlot.Weapon_Phantom02.Item:PlayAnimation(self.PhantomSlot.Weapon_Phantom02.Item.FlashRed)
            end
            if IsMainRoleSlotLack then
                UIManager(self):ShowUITip("CommonToastMain", GText("UI_Squad_Essential_Miss"))
            else
                UIManager(self):ShowUITip("CommonToastMain", GText("UI_Squad_Miss_SigilWeapon"))
            end
            
        elseif not self:CheckChangeSquadInfo() then
            UIManager(self):ShowUITip("CommonToastMain", GText("UI_Squad_NoEdit"))
        end
        return
    end
    --阵容没有完全配置 弹窗是否保存
    if not self:CheckIsFull() then
        self.SaveSquadTip = self:ShowCommonPopupUI(100172, self.RealSaveSquad)
        return
    end
    self:RealSaveSquad()
end

--检查必要槽位是否装备了内容
function WBP_SquadBuild_Main_P_C:CheckForceSlotIsLack()
    for key, value in pairs(self.PlayerForceSlot) do
        if value.Uuid == "" or value.Uuid == nil then
            return true
        end
    end
    if self.PhantomSlot.Head_Phantom01.Uuid and (not self.PhantomSlot.Weapon_Phantom01.Uuid) then
        return true
    end
    if self.PhantomSlot.Head_Phantom02.Uuid and (not self.PhantomSlot.Weapon_Phantom02.Uuid) then
        return true
    end
    return false
end

--检查是否装备满槽位
function WBP_SquadBuild_Main_P_C:CheckIsFull()
    for WidgetName, Widget in pairs(self.RightSlots) do
        if Widget.IsEmpty then
            return false
        end
    end
    return true
end

--真正保存阵容
function WBP_SquadBuild_Main_P_C:RealSaveSquad()
    local IsNeedSave, Info = self:CheckChangeSquadInfo()
    if self.IsOpenAddSquad then
        self.CurSelectSquadIndex = self.SquadListLen + 1
    end
    if IsNeedSave then
        if self.SquadListLen < self.CurSelectSquadIndex then
            self.Avatar:CreateSquad(nil, Info)
            --弹个toast
            if self:CheckAllSlotUuidVaild() then
                UIManager(self):ShowUITip("CommonToastMain", GText("UI_Squad_Save")..self.CurSquadInfo.Name)
            end
        else
            self.Avatar:UpdateSquad(nil, self.CurSelectSquadIndex, Info)
            --弹个toast
            if self:CheckAllSlotUuidVaild() then
                UIManager(self):ShowUITip("CommonToastMain", GText("UI_EditSuccess"))
            end
        end
    end
    if self.IsOpenAddSquad then
        self.IsOpenAddSquad = false
        self.IsFromDungeonPage = false
        self:Close()
        return
    end
    self.IsNeedPlayRefreshAnimation = true
    --self:PlayAnimation(self.Auto_In)

end

function WBP_SquadBuild_Main_P_C:CheckAllSlotUuidVaild()
    local IsValid = true
    for SlotName, Slot in pairs(self.RightSlots) do
        if Slot.CheckUuidIsVaild then
            IsValid = IsValid and Slot:CheckUuidIsVaild()
        end
    end
    return IsValid
end

function WBP_SquadBuild_Main_P_C:UpdateCurSquadInfo(Key, value)
    if self.CurSquadInfo then
        self.CurSquadInfo[Key] = value
        self.AddSquadAndEdit = true
        self.Btn_Save:ForbidBtn(self:CheckForceSlotIsLack() or (not self:CheckChangeSquadInfo()))
    end
end

function WBP_SquadBuild_Main_P_C:CheckChangeSquadInfo()
    --没有创建CurSquadInfo 意味着没有修改过
    if not self.CurSquadInfo then
        return false
    end
    if self.SquadListLen < self.CurSelectSquadIndex then
        if self.AddSquadAndEdit then
            return true, self.CurSquadInfo
        end
        return false
    end
    local Info = {}
    local IsNeedSave = false
    for key, value in pairs(self.CurSquadInfo) do
        if self.SquadInfo and self.SquadInfo[key] ~= value then
            if not (self.SquadInfo[key] == nil and (value == "" or value == 0)) then
                Info[key] = value
                IsNeedSave = true
            end
        elseif (not self.SquadInfo) and (not (value == "" or value == 0)) then
            Info[key] = value
            IsNeedSave = true
        end
    end
    return IsNeedSave, Info
end

--弹窗提示
function WBP_SquadBuild_Main_P_C:ShowCommonPopupUI(UIId, RightCallback)
    local Params = {}
    Params.RightCallbackObj = self
    Params.RightCallbackFunction = RightCallback
    return UIManager(self):ShowCommonPopupUI(UIId, Params, self)
end

--预设阵容数据 Squad.Lua
--阵容的数据结构  self.Avatar.Squad
function WBP_SquadBuild_Main_P_C:InitSquadData()
    self.Avatar = GWorld:GetAvatar()
    if not self.Avatar then
        return 
    end

    self.SquadList = self.Avatar.Squad
    --右方的所有槽位
    self.RightSlots = {
        ["Char"] = self.Character,
        ["MeleeWeapon"] = self.Melee,
        ["RangedWeapon"] = self.Ranged,
        ["Pet"] = self.Pet,
        ["Phantom1"] = self.Head_Phantom01,
        ["PhantomWeapon1"] = self.Weapon_Phantom01,
        ["Phantom2"] = self.Head_Phantom02,
        ["PhantomWeapon2"] = self.Weapon_Phantom02,
        ["WheelIndex"] = self.Roulette,
    }
    --玩家操作角色相关槽位
    self.PlayerAboutSlots = {
        ["Char"] = self.Character,
        ["Melee"] = self.Melee,
        ["Ranged"] = self.Ranged,
        ["Pet"] = self.Pet,
    }
    --玩家操作角色相关槽位
    self.PlayerForceSlot = {
        ["Char"] = self.Character,
        ["Melee"] = self.Melee,
        ["Ranged"] = self.Ranged,
    }

    --魅影角色和武器槽位
    self.PhantomSlot = {
        ["Head_Phantom01"] = self.Head_Phantom01,
        ["Weapon_Phantom01"] = self.Weapon_Phantom01,
        ["Head_Phantom02"] = self.Head_Phantom02,
        ["Weapon_Phantom02"] = self.Weapon_Phantom02,
    }
    
    --左边信息栏索引（切换控件用）
    self.LeftWidgetList = {
        [1] = self.Panel_Default,
        [2] = self.Panel_List,
        [3] = self.Panel_Roulette,
    }
    --当前选择的预设阵容索引
    self.CurSelectSquadIndex = self.SelectIndex or 1
    --预设阵容数量上限
    self.SquadMax = DataMgr.GlobalConstant.SquadMax.ConstantValue or 10
    --当前是否在拖拽排序
    self.IsDraging = false
    --魅影武器类型默认是近战
    self.CurPhantomWeaponType = "Melee"
    self.IsInClickCD = false
    self.ClickCD = 0.3
    self.FirstIn = true
end

function WBP_SquadBuild_Main_P_C:CreateActorController()
    if self.ActorController then
        return
    end
    self.ActorController = ActorController:New({
        ViewUI = self,
        IsPreviewMode = true,
        Char = self.Avatar.Chars[self.SquadInfoList[self.CurSelectSquadIndex].Char],
        bNeedEndCamera = false,
    })
    self.ActorController:OnOpened(0)
end

--更新Tab的UI
function WBP_SquadBuild_Main_P_C:InitTabUI(Text)
    --上方的Tab
    self.CurTitle = Text
    self.MainTab = {
        TitleName = self.CurTitle or GText("UI_Squad"),
        ShowSquadBuildBtn = true,
        Tabs = {    },
        DynamicNode={
            "Back",
            "BottomKey",
        },
        BottomKeyInfo = { 
            {   
                GamePadInfoList = {{Type="Img", ImgShortPath="A", ClickCallback=self.OnBackKeyDown, Owner=self}}, 
                Desc=GText("UI_CTL_Squad_Select")
            },
            {   
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.OnBackKeyDown, Owner=self}}, 
                GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.OnBackKeyDown, Owner=self}},
                Desc=GText("UI_BACK")
            },
        },
        BackCallback = self.OnBackKeyDown,
        OwnerPanel = self,
    }
    self.Com_Tab:Init(self.MainTab)
end

--更新下方Tab的UI（手柄用） IsSelect A键是选择还是确认 BtnNum几个提示 SelelctText当时选择时 是选择组件还是选择
function WBP_SquadBuild_Main_P_C:InitBottomTab(IsSelect, BtnNum, SelelctText)
    self.MainTab = {
        TitleName = self.CurTitle or GText("UI_Squad"),
        ShowSquadBuildBtn = true,
        Tabs = {    },
        DynamicNode={
            "Back",
            "BottomKey",
        },
        BackCallback = self.OnBackKeyDown,
        OwnerPanel = self,
    }
    local BottomKeyInfo
    if BtnNum == 2 then
        BottomKeyInfo = { 
            {   
                GamePadInfoList = {{Type="Img", ImgShortPath="A", Owner=self}}, 
                Desc= IsSelect and (SelelctText or GText("UI_CTL_Squad_Select")) or GText("UI_Tips_Ensure")
            },
            {   
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.OnBackKeyDown, Owner=self}}, 
                GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.OnBackKeyDown, Owner=self}},
                Desc=GText("UI_BACK")
            },
        }
    elseif BtnNum == 3 then
        if self.IsInEditor and (self.CurFocusSlot and self.CurFocusSlot.Uuid ~= nil and self.CurFocusSlot.Uuid ~= 0) then
            BottomKeyInfo = { 
                {   
                    GamePadInfoList = {{Type="Img", ImgShortPath="Y", ClickCallback=self.ClearCurSlot, Owner=self}},
                    Desc=GText("UI_CTL_Remove")
                },
                {   
                    GamePadInfoList = {{Type="Img", ImgShortPath="A", Owner=self}}, 
                    Desc= IsSelect and (SelelctText or GText("UI_CTL_Squad_Select")) or GText("UI_Tips_Ensure")
                },
                {   
                    KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.OnBackKeyDown, Owner=self}}, 
                    GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.OnBackKeyDown, Owner=self}},
                    Desc=GText("UI_BACK")
                },
            }
        else
            BottomKeyInfo = { 
                {   
                    GamePadInfoList = {{Type="Img", ImgShortPath="A", Owner=self}}, 
                    Desc= IsSelect and (SelelctText or GText("UI_CTL_Squad_Select")) or GText("UI_Tips_Ensure")
                },
                {   
                    KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.OnBackKeyDown, Owner=self}}, 
                    GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.OnBackKeyDown, Owner=self}},
                    Desc=GText("UI_BACK")
                },
            }
        end
    else
        BottomKeyInfo = { 
            {   
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.OnBackKeyDown, Owner=self}}, 
                GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.OnBackKeyDown, Owner=self}},
                Desc=GText("UI_BACK")
            },
        }
    end
    self.MainTab.BottomKeyInfo = BottomKeyInfo
    self.Com_Tab:Init(self.MainTab)
end

--手柄排序专用
function WBP_SquadBuild_Main_P_C:InitBottomTabOnSortStateInGamePad()
    self.MainTab = {
        TitleName = self.CurTitle or GText("UI_Squad"),
        ShowSquadBuildBtn = true,
        Tabs = {    },
        DynamicNode={
            "Back",
            "BottomKey",
        },
        BackCallback = self.OnBackKeyDown,
        OwnerPanel = self,
    }

    local BottomKeyInfo = { 
        {   
            GamePadInfoList = {{Type="Img", ImgShortPath="LV", Owner=self}}, 
            Desc= GText("UI_CTL_Squad_AdjustSorting")
        },
        {   
            GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.OnBackKeyDown, Owner=self}},
            Desc=GText("UI_CTL_Squad_ExitSorting")
        },
    }
    self.MainTab.BottomKeyInfo = BottomKeyInfo
    self.Com_Tab:Init(self.MainTab)
end

function WBP_SquadBuild_Main_P_C:OnBackKeyDown()
    --有提示栏则关闭提示栏
    if self.Panel_Tips:IsVisible() then
        self:CloseTips(true)
        return
    end
    
    --阵容编辑完没有保存弹窗提示
    if self.IsInEditor then
        self:CancelCreateSquadAndBackToSquadList()
        return
    end
    self.IsNeedPlayRefreshAnimation = true
    self.IsOpenAddSquad = false
    self.IsFromDungeonPage = false
    self:Close()
end

function WBP_SquadBuild_Main_P_C:SwitchGamePadIconVisibilityBySortState(bShow)
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        if bShow then
            self.Btn_Edit.Key_GamePad:SetVisibility(ESlateVisibility.Visible)
        else
            self.Btn_Edit.Key_GamePad:SetVisibility(ESlateVisibility.Collapsed)
        end
    end
end

-----------------------------------------通用Start-------------------------------------------

--切换左边的信息展示控件  1预设阵容 2角色/魅影/武器/宠物 3轮盘 不传Index默认1
function WBP_SquadBuild_Main_P_C:SwitchLeftWidgetByIndex(Index)
    self.CurLeftWidgetIndex = Index
    for key, value in pairs(self.LeftWidgetList) do
        if Index == key then
            self.LeftWidgetList[key]:SetVisibility(ESlateVisibility.Visible)
        else
            self.LeftWidgetList[key]:SetVisibility(ESlateVisibility.Collapsed)
        end
    end
end

function WBP_SquadBuild_Main_P_C:SelectCurSquad(Index)
    for i = 1, self.SquadListLen do
        local Item = self:GetSquadWidgetInSquadList(i)
        if Item then
            if Item.Index == Index then
                --有时候在拖拽时可能会触发到新增预设阵容的点击事件，理论上新增按钮是不参与其中的，所以加强判断
                if Item.IsAddSquad then
                    return
                end
                Item.IsSelect = true
                if not self.IsDraging then
                    Item:CheckSortIcon()
                    Item:PlayAnimation(Item.Click)
                    Item.Melee:PlayAnimation(Item.Melee.Click)
                    Item.Ranged:PlayAnimation(Item.Ranged.Click)
                end
            else
                Item.IsSelect = false
                Item:CheckSortIcon()
                Item:StopAnimation(Item.Click)
                Item:StopAnimation(Item.Select)
                Item:PlayAnimation(Item.Normal)
                Item.Melee:PlayAnimation(Item.Melee.Normal)
                Item.Ranged:PlayAnimation(Item.Ranged.Normal)
            end
        end  
    end
end

--创建一个列表中的item 
function WBP_SquadBuild_Main_P_C:NewItemContent(Target,Type,Tag)
    --新建一个列表数据对象
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.Uuid = Target.Uuid
    Obj.Type = Type
    Obj.Tag = Tag
    Obj.UnitId = Target[Type .. "Id"]
    Obj.UnitName = Target[Type .. "Name"]
    Obj.Rarity = Target[Type .. "Rarity"]
    Obj.Icon = Target:Data().Icon
    Obj.GachaIcon = Target:Data().GachaIcon
    Obj.Level = Target.Level
    Obj.GradeLevel = Target.GradeLevel
    Obj.AnimNameWithCreate = "In_OnlyOpacity"
    local Element = DataMgr["Battle"..Type][Obj.UnitId].Attribute
    if(Element)then
        local IconName = "Armory_" .. Element
        Obj.AttrIcon = "/Game/UI/Texture/Dynamic/Atlas/Armory/T_" .. IconName .. ".T_" .. IconName
    end
    Obj.SortPriority = Target:Data().SortPriority or 0
    return Obj
end

function WBP_SquadBuild_Main_P_C:NewPetItemContent(Target)
    --新建一个列表数据对象
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.Uuid = Target.UniqueId
    Obj.Type = CommonConst.ArmoryType.Pet
    Obj.Tag = CommonConst.ArmoryType.Pet
    Obj.UnitId = Target.PetId
    local Data = DataMgr.Pet[Obj.UnitId]
    Obj.UnitName = Data.Name
    Obj.Rarity = Data.Rarity
    Obj.Icon = Data.Icon
    Obj.Level = Target.Level
    Obj.BreakNum = Target.BreakNum
    Obj.SortPriority = Data.SortPriority or 0
    return Obj
end

function WBP_SquadBuild_Main_P_C:ResetSquadList()
    self:UpdateSquadListInfo()
    self:UpdateSquadList()
end

function WBP_SquadBuild_Main_P_C:PlayAllSlotRefreshAnimation()
    if not self.IsNeedPlayRefreshAnimation then
        return
    end
    for SlotName, Slot in pairs(self.RightSlots) do
        if Slot.PlayRefreshAnimation then
            Slot:PlayRefreshAnimation()
        end
    end
    self.IsNeedPlayRefreshAnimation = false
end

function WBP_SquadBuild_Main_P_C:ClearCurSlot()
    if self.CurFocusSlot then
        self.CurFocusSlot:ClearSlot()
    else
        self.CurSlot:ClearSlot()
    end
    self:InitBottomTab(false, 2)
end

--根据函数名字执行函数
function WBP_SquadBuild_Main_P_C:CallFunctionByName(FunctionName,...)
    if(self[FunctionName])then
        return self[FunctionName](self,...)
    end
end

--更改上方tab的标题名
function WBP_SquadBuild_Main_P_C:UpdateUpTabTitleName(Text)
    self:InitTabUI(Text)
end

--魅影武器选择显示tab
function WBP_SquadBuild_Main_P_C:PhantomWeaponTypeChanged(Type)
    if Type then
        self.CurPhantomWeaponType = Type
        self.List_Build.Tab_Primary:SetVisibility(ESlateVisibility.Visible)
        self:InitItemVarInfo(Type)
        self:ReInitListItems()
        if Type == "Melee" then
            self.List_Build.Type_Melee:SetIsChecked(true, true)
            self.List_Build.Type_Range:SetIsChecked(false)
        else
            self.List_Build.Type_Range:SetIsChecked(true, true)
            self.List_Build.Type_Melee:SetIsChecked(false)
        end
    else
        self.List_Build.Tab_Primary:SetVisibility(ESlateVisibility.Collapsed)
    end

end

function WBP_SquadBuild_Main_P_C:ReInitListItems()
    self:CallFunctionByName(self.CurSlotType.."Main_Init")
    self:FillSelectiveList()
end

--重置当前预设阵容信息
function WBP_SquadBuild_Main_P_C:InitCurSquadInfo(IsAddSquad)
    self.CurSquadInfo = {
        -- 阵容名称
        ["Name"] = GText("UI_Squad_ListName")..self.CurSelectSquadIndex,
        -- 角色
        ["Char"] = "",
        -- Mod方案
        ["ModSuit"] = 0,
        -- 近战武器
        ["MeleeWeapon"] = "",
        -- 近战武器Mod方案
        ["MeleeWeaponModSuit"] = 0,
        -- 远程武器
        ["RangedWeapon"] = "",
        -- 远程武器Mod方案
        ["RangedWeaponModSuit"] = 0,
        -- 宠物
        ["Pet"] = 0,
        -- 战斗轮盘
        ["WheelIndex"] = 1,
        -- 魅影1
        ["Phantom1"] = "",
        -- 魅影1武器
        ["PhantomWeapon1"] = "",
        -- 魅影2
        ["Phantom2"] = "",
        -- 魅影2武器
        ["PhantomWeapon2"] = "",
    }
    self.AddSquadAndEdit = false
    --读入现在的数据
    if not IsAddSquad and self.SquadInfo then
        for key, value in pairs(self.SquadInfo) do
            self.CurSquadInfo[key] = value
        end
        if self.SquadInfo.Name == "" then
            self.CurSquadInfo.Name = GText("Squad_DefaultName1")
        end
    end
end

function WBP_SquadBuild_Main_P_C:EnterSquadSetting()

end

function WBP_SquadBuild_Main_P_C:QuitSquadSetting()

    self.ActorController:OnClosed()
    self.ActorController:OnDestruct()
end

function WBP_SquadBuild_Main_P_C:CheckThisContentIsEquippedByOtherSlot(Uuid, SlotName)
    for Name, Widget in pairs(self.RightSlots) do
        if Widget.Uuid and (Widget.Uuid == Uuid) and Widget:GetName() ~= SlotName then
            return true, Name
        end
    end
    return false, nil
end

function WBP_SquadBuild_Main_P_C:CurSlotNameToRightSlotsKey(CurSlotName)
    for Name, Widget in pairs(self.RightSlots) do
        if Widget:GetName() == CurSlotName then
            return Name
        end
    end
end

function WBP_SquadBuild_Main_P_C:GetSquadWidgetInSquadList(CurIndex)
    local Item = self.List_Default:GetItemAt(CurIndex-1) or self.List_Default:GetItemAt(0)
    return Item.SelfWidget
end

function WBP_SquadBuild_Main_P_C:GetSquadContent(TargetIndex)
    for i = 1, self.SquadListLen do
        local Item = self.List_Default:GetItemAt(i-1)
        if Item and Item.SelfWidget and Item.SelfWidget.FakeIndex == TargetIndex then
            return Item.SelfWidget
        end
    end
end

function WBP_SquadBuild_Main_P_C:GetSquadContentListIndex(TargetIndex)
    for i = 1, self.SquadListLen do
        local Item = self.List_Default:GetItemAt(i-1)
        if Item.SelfWidget.FakeIndex == TargetIndex then
            return i
        end
    end
end

function WBP_SquadBuild_Main_P_C:HideOrShowItemInDraging(CurIndex)
    for i = 1, self.SquadListLen do
        local item = self:GetSquadWidgetInSquadList(i)
        if item then
            if i == CurIndex then
                item:HideOrShowItemUIInfo(false)
            else
                item:HideOrShowItemUIInfo(true)
            end
        end
    end
end

function WBP_SquadBuild_Main_P_C:PlaySelectSound(IsSelected, Type)
    if not IsSelected then
        AudioManager(self):PlayUISound(self, SelectSoundPaths.Default, nil, nil)
    else
        AudioManager(self):PlayUISound(self, SelectSoundPaths[Type], nil, nil)
        AudioManager(self):PlayUISound(self, EquipSoundPaths[Type], nil, nil)
    end
end

function WBP_SquadBuild_Main_P_C:SetContentIsChosen(Content, IsChosen)

end

function WBP_SquadBuild_Main_P_C:CloseAllTips()
    if self.Pos_Tips:GetChildAt(0) then
        self.SquadItemTip:CloseWidget()
    end

    if self.IsEditSquadName then
        self.NameEditDialog:Close()
    end

    if self.DeleteSquadTips then
        self.DeleteSquadTips:Close()
    end

    if self.SaveSquadTip then
        self.SaveSquadTip:Close()
    end

    if self.CancelPopUI then
        self.CancelPopUI:Close()
    end
end

-----------------------------------------通用End---------------------------------------------

-----------------------------------------预设阵容列表Start------------------------------------

--更新到阵容预设列表
function WBP_SquadBuild_Main_P_C:SwitchToSquadList(NeedAnimation)
    self:SwitchLeftWidgetByIndex(1)
    self.IsInEditor = false
    --更新预设阵容列表信息
    self:UpdateSquadListInfo()
    --更新预设阵容列表
    self:UpdateSquadList()
    --检查阵容数量
    self:CheckSquadListArr()
    self:SwitchBtnPanel("SquadList")
    --创建角色展示模型和摄像头 已有则跳过
    self:CreateActorController()
    --更新tabs名字
    self:UpdateUpTabTitleName(GText("UI_Squad"))
    --重置所有槽位点击状态
    self:ResetAllSlotsClickState()
    self:AllSlotPlayAnimation("Normal")
    --更新下UI
    self:InitSquadListUI()
    --更新右边的细节信息
    self:InitRightDetailPanel()
    --初始化当前临时存储数据
    self:InitCurSquadInfo()
    --self:HideOrShowItemInDraging()
    --第一次进默认选第一个队伍，后续进会按照当前记录页面索引选择
    self:SelectCurSquadInSquadList(nil, true)
    self.List_Default:DisableScroll(true)
    self.List_Default:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.EMScrollBox_0:SetVisibility(UIConst.VisibilityOp.Visible)
    self.EMScrollBox_0:SetScrollBarVisibility(ESlateVisibility.Collapsed)
    self.EMScrollBox_0:SetControlScrollbarInside(false)

    if self.IsInSortState then
        self:SwitchGamePadIconVisibilityBySortState(false)
    else
        self:SwitchGamePadIconVisibilityBySortState(true)
    end
    if NeedAnimation then
        self:PlayAnimation(self.Auto_In)
    end
    self.Text_Has:SetText(self.SquadListLen)

    self:AddDelayFrameFunc(function()
            --     self:AddDelayFrameFunc(
            -- function()
            --     self:PlayAllSlotRefreshAnimation()
            -- end, 5, "DelayPlayAnimation")
        self:PlayAllSlotRefreshAnimation()
        --在刷新预设阵容时出现当前索引大于当前长度时表示从委托任务进来去新增预设阵容入口的
        if self.CurSelectSquadIndex > self.SquadListLen then 
            self.CurSelectSquadIndex = self.SquadListLen
        end

        if self.IsInSortState then
            self:GetSquadWidgetInSquadList(self.CurSelectSquadIndex):CheckArrowState()
            self:SwitchAddSquadItemVisibility(false)
            self:InitBottomTabOnSortStateInGamePad()
            self:FocusOnSquadListInSortState()
            return
        end
        if self.IsDraging then
            self:HideOrShowItemInDraging(self.CurSelectSquadIndex)
            self:SwitchAddSquadItemVisibility(false)
            self:InitBottomTabOnSortStateInGamePad()
            return
        end
        self:FocusOnSquadList()
        self:SwitchAddSquadItemVisibility(true)
        self:HideOrShowItemInDraging()
    end, 2, "DelayShow")
end

function WBP_SquadBuild_Main_P_C:InitSquadListUI()
    if self.SquadListLen > 1 then
        self.Text_SortTip:SetVisibility(ESlateVisibility.Visible)
    else
        self.Text_SortTip:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.Btn_Delete:SetVisibility(ESlateVisibility.Visible)
end

--第一次进默认选第一个队伍，后续进会按照当前记录页面或是形参索引选择，可以仅用于播放Click动画，不会执行动画绑定的事件
function WBP_SquadBuild_Main_P_C:SelectCurSquadInSquadList(ParmaIndex, IsOnlyPlayAnimation)
    self.CurSelectSquadIndex = ParmaIndex or self.CurSelectSquadIndex or 1
    self.NeedRemove = false
    self:AddTimer(0.1, function()
        if self:GetSquadWidgetInSquadList(self.CurSelectSquadIndex) and (not self.NeedRemove) then
            self.IsOnlyPlayAnimation = IsOnlyPlayAnimation
            self:SelectCurSquad(self.CurSelectSquadIndex)
            self.NeedRemove = true -- 计时器太快了，只让进一次
            self:RemoveTimer("SelectCurSquad")
        end
    end, true, 0, "SelectCurSquad", true)
end

--更新预设阵容列表信息
function WBP_SquadBuild_Main_P_C:UpdateSquadListInfo()
    self.SquadInfoList = {}
    self.SquadListLen = 0
    self:UpdateSquadListFromAvatar()
    --初始化阵容信息item
    for key, value in pairs(self.SquadList) do
        local SquadInfo = {}
        self.SquadListLen = self.SquadListLen + 1
        SquadInfo.SquadName = value.Name --预设阵容名字
        for Name, Id in pairs(value.Props) do
            if Name == "Char" or Name == "Phantom1" or Name == "Phantom2" then
                if Id ~= "" and self.Avatar.Chars[Id] then
                    SquadInfo[Name.."Id"] = self.Avatar.Chars[Id].CharId
                    SquadInfo[Name] = Id
                end
            elseif self:IsSubstringContained(Name, "ModSuit") then
                SquadInfo[Name] = Id
            elseif self:IsSubstringContained(Name, "Weapon")  then
                if Id ~= "" and self.Avatar.Weapons[Id] and self.Avatar.Weapons[Id].WeaponId ~= 0 then
                    SquadInfo[Name.."Id"] = self.Avatar.Weapons[Id].WeaponId
                    SquadInfo[Name] = Id
                end
            else
                SquadInfo[Name] = Id
            end
        end
        table.insert(self.SquadInfoList, SquadInfo)
    end
end

--从avatar中获取到最新的预设阵容列表
function WBP_SquadBuild_Main_P_C:UpdateSquadListFromAvatar()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self.Avatar = Avatar
    self.SquadList = self.Avatar.Squad
end

--更新预设阵容列表
function WBP_SquadBuild_Main_P_C:UpdateSquadList()
    local IsScrollDisable = self.List_Default:IsDisableScroll()
    self.List_Default:SetAllowOverscroll(IsScrollDisable)
    self.List_Default:ClearListItems()
    for key, value in pairs(self.SquadInfoList) do
        local Content =  NewObject(UIUtils.GetCommonItemContentClass())
        Content.SquadInfo = value
        Content.ClickCallback = self.ClickSelectSquadItem
        Content.IsNeedSort = #self.SquadInfoList > 1
        Content.Owner = self
        Content.Index = key
        Content.IsAddSquad = false
        self.List_Default:AddItem(Content)
    end
    self.List_Default:SetSelectedIndex(self.CurSelectSquadIndex - 1)
    --如果没到上限 额外添加一个item显示添加状态
    if #self.SquadInfoList < 10 then
        local Content =  NewObject(UIUtils.GetCommonItemContentClass())
        Content.Owner = self
        Content.ClickCallback = self.AddSquad
        Content.IsAddSquad = true
        Content.Index = #self.SquadInfoList + 1
        self.List_Default:AddItem(Content)
    end
end

function WBP_SquadBuild_Main_P_C:AutoSetScrollBoxOffSet(ScrollBox, ScrollOffset)
    if not ScrollBox then
        return
    end
    --获取当前的滚动偏移
    self.CurScrollOffset = ScrollBox:GetScrollOffset()
    local TargetScrollOffset = self.CurScrollOffset + ScrollOffset
    local IsUp = ScrollOffset < 0
    local IsDone = false
    DebugPrint("thyScrollset", self.CurScrollOffset, TargetScrollOffset)

    self:AddTimer(0.01, function()
        DebugPrint("thyAutoScroll", self.CurScrollOffset, TargetScrollOffset)
        if IsDone then
            self:RemoveTimer("AutoScroll")
            return
        end
        self.CurScrollOffset = self.CurScrollOffset + ScrollOffset / 5
        if IsUp then
            self.CurScrollOffset = math.max(self.CurScrollOffset, 0)
        else
            self.CurScrollOffset = math.min(self.CurScrollOffset, TargetScrollOffset)
        end
        if self.CurScrollOffset == TargetScrollOffset or self.CurScrollOffset == 0 then
            IsDone = true
        end
        ScrollBox:SetScrollOffset(self.CurScrollOffset)
    end, true, 0, "AutoScroll", true)

end

--获取ListView和其item的高度
function WBP_SquadBuild_Main_P_C:GetListViewSize(TileView, Item)
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local ListSize = UIManager:GetWidgetRenderSize(TileView)
    local Parent = TileView:GetParent()
    if Parent:Cast(UScrollBox) then
        ListSize = UIManager:GetWidgetRenderSize(Parent)
    end
    local ListSizeX,ItemSizeX = ListSize.X,UIManager:GetWidgetRenderSize(Item.BG).X
    local ListSizeY,ItemSizeY = ListSize.Y,UIManager:GetWidgetRenderSize(Item.BG).Y

    --拖拽限制 计算偏移量
    self.Offset = (ListSizeX - ItemSizeX) / 2
    return ListSizeY, ItemSizeY
end

function WBP_SquadBuild_Main_P_C:CheckSquadListArr()
    if self.SquadListLen > 1 then
        self.CanvasPanel_1:SetVisibility(ESlateVisibility.Visible)
    else
        self.CanvasPanel_1:SetVisibility(ESlateVisibility.Collapsed)
    end
    if self.SquadListLen == self.SquadMax then
        self.Hint_Max:SetVisibility(ESlateVisibility.Visible)
        self.Hint_Max.WidgetSwitcher_State:SetActiveWidgetIndex(0)
        self.Hint_Max.Text_Hint_Normal:SetText(GText("UI_Squad_Max"))
    else
        self.Hint_Max:SetVisibility(ESlateVisibility.Collapsed)
    end
end

--点击预设阵容列表时的回调
function WBP_SquadBuild_Main_P_C:ClickSelectSquadItem(Index)
    DebugPrint("thy    点击预设阵容列表时的回调", self.CurSelectSquadIndex, Index, self.IsDraging)
    if self.IsInEditor then
        return
    end
    if self.FirstIn then
        self.FirstIn = false
        return
    end
    if self.CurInputDeviceType == ECommonInputType.Gamepad and self.IsOnlyPlayAnimation then
        self.IsOnlyPlayAnimation = false
        return
    end
    self.IsOnlyPlayAnimation = false
    if self.IsNeedPlayRefresh then
        self:PlayAnimation(self.Refresh)
        self.IsNeedPlayRefresh = false 
    end
    self.SquadInfo = self.SquadInfoList[Index]--服务器存储的阵容
    self:InitCurSquadInfo()--初始化当前阵容信息
    self.CurSelectSquadIndex = Index
    --右边更新细节信息
    self:InitRightDetailPanel()
    self:UpdateSlotIcon()
end

--新添加一个预设阵容的回调
function WBP_SquadBuild_Main_P_C:AddSquad()
    DebugPrint("thy    新添加一个预设阵容的回调")
    --置空当前服务器中对应的阵容信息
    self.SquadInfo = nil
    self.IsInEditor = true
    self:ClearAllSlots(true)
    self.CurSelectSquadIndex = self.SquadListLen + 1
    self:InitCurSquadInfo(true)
    self.Text_DefaultName:SetText(self.CurSquadInfo.Name)
    self:ResetAllSlotsClickState()
    self.Character:OnClickCallback()
    self:UpdateUpTabTitleName(GText("UI_Squad_Add"))
    self:PlayAnimation(self.Auto_In)
end

--重置所有槽位的点击状态
function WBP_SquadBuild_Main_P_C:ResetAllSlotsClickState()
    for key, value in pairs(self.RightSlots) do
        value.IsClicking = false
    end
end

--清空所有的槽位信息
function WBP_SquadBuild_Main_P_C:ClearAllSlots(IsAddSquad)
    for key, value in pairs(self.RightSlots) do
        value:ClearSlot(IsAddSquad)
    end
end

--所有的槽位的Uuid和Id信息
function WBP_SquadBuild_Main_P_C:WeakClearAllSlots()
    for key, value in pairs(self.RightSlots) do
        if value.WeakClearSlotInfo then
            value:WeakClearSlotInfo()
        end
    end
end

-----------------------------------------预设阵容列表End--------------------------------------

-----------------------------------------预设阵容角色/武器/宠物列表Start-----------------------

--更新到ItemType :角色/魅影/武器/宠物列表
function WBP_SquadBuild_Main_P_C:SwitchToSelectItemList(CurSlot, ItemType)
    if self.CurSlot then
        if self.CurSlot ~= CurSlot then
            if self.CurSlot.PlayNormalAnimation then
                self.CurSlot:PlayNormalAnimation()
            else
                self.CurSlot:PlayAnimation(self.CurSlot.Normal)
            end
            self.CurSlot.IsClicking = false
        end
    end
    self.CurSlot = CurSlot
    self.IsInEditor = true
    self.PreContent = self.CurSlot.ItemInfo
    self.CurClickItemInfo = nil
    self.CurType = ItemType
    if CurSlot.Type == "Roulette" then
        self.CurType = nil
    end
    self:ClearSlotCachedData()
    --切换到物品列表
    self:SwitchLeftWidgetByIndex(2)
    --切换两个按钮
    self:SwitchBtnPanel()
    --上方tab名称更新
    self:UpdateUpTabTitleName(GText("UI_Squad_Edit"))
    --初始化一些控制列表信息的相关变量 当前选择槽位类型
    self:InitItemVarInfo(ItemType)
    --初始化ItemType 的相关数据 ItemType -> Char/Weapon/Pet
    self:CallFunctionByName(ItemType.."Main_Init")
    --初始化过滤词条 最左边的元素类型过滤
    self:InitSelectiveList()
    --在列表添加当前类型的数据
    self:FillSelectiveList()
    --切换魅影武器界面相关的UI
    self:ShowOrHidePhantomWeaponUI()
    --更新槽位的删除图标
    self:UpdateSlotIcon()
    --检查必选槽位的状态和修改的状态来修改保存按钮的状态
    self.Btn_Save:ForbidBtn(self:CheckForceSlotIsLack() or (not self:CheckChangeSquadInfo()))
    self.Btn_Delete:SetVisibility(ESlateVisibility.Collapsed)
    self:AddDelayFrameFunc(
        function()
            --self:FocusOnItemList()
            self:FocusOnRightDetailPanel()
        end, 2, "DelayFocusItem")
    self:PlayAnimation(self.Left_In)
    return
end

function WBP_SquadBuild_Main_P_C:UpdateSlotIcon()
    for WidgetName, Widget in pairs(self.RightSlots) do
        if Widget.AddDelelteIcon then
            Widget:AddDelelteIcon()
        end
        if Widget.CheckIsNeedLackState then
            Widget:CheckIsNeedLackState()
        end
    end
end

--ListView绑定点击事件
function WBP_SquadBuild_Main_P_C:BindEventInListView()
    self.List_Build.List_Select.BP_OnItemClicked:Remove(self,self.ClickListItem)
    self.List_Build.List_Select.BP_OnItemClicked:Add(self,self.ClickListItem)
end

--切换魅影武器界面相关的UI
function WBP_SquadBuild_Main_P_C:ShowOrHidePhantomWeaponUI()
    --切换魅影武器界面相关的UI
    if self:IsSubstringContained(self:CurSlotNameToRightSlotsKey(self.CurSlot:GetName()), "PhantomWeapon") then
        self.List_Build.Image_WeaponBG:SetVisibility(ESlateVisibility.Visible)
        self.List_Build.Tab_Primary:SetVisibility(ESlateVisibility.Visible)
    else
        self.List_Build.Image_WeaponBG:SetVisibility(ESlateVisibility.Collapsed)
        self.List_Build.Tab_Primary:SetVisibility(ESlateVisibility.Collapsed)
    end
end

--仅用于点击预设阵容后 初始化右边细节面板信息
function WBP_SquadBuild_Main_P_C:UpdateRightDetailPanel()
    self:WeakClearAllSlots()
    self.Text_DefaultName:SetText(self.CurSquadInfo.Name)
    self.Avatar = GWorld:GetAvatar()
    --角色槽更新
    local RoleParams = {
        Uuid = self.SquadInfo.Char,
        Id = self.SquadInfo.CharId,
        ModSuit = self.SquadInfo.ModSuit,
        Type = "Char",
        Owner = self,
    }
    self.Character:InitSlot(RoleParams)
    --近战武器槽
    local MeleeWeaponParams = {
        Uuid = self.SquadInfo.MeleeWeapon,
        Id = self.SquadInfo.MeleeWeaponId,
        ModSuit = self.SquadInfo.MeleeWeaponModSuit,
        Type = "Melee",
        Owner = self,
    }
    self.Melee:InitSlot(MeleeWeaponParams)
    --远战武器槽
    local RangedWeaponParams = {
        Uuid = self.SquadInfo.RangedWeapon,
        Id = self.SquadInfo.RangedWeaponId,
        ModSuit = self.SquadInfo.RangedWeaponModSuit,
        Type = "Ranged",
        Owner = self,
    }
    self.Ranged:InitSlot(RangedWeaponParams)
    --宠物
    local PetParams = {
        Uuid = self.SquadInfo.Pet,
        Id = self.Avatar and self.SquadInfo.Pet and self.Avatar.Pets[self.SquadInfo.Pet] and self.Avatar.Pets[self.SquadInfo.Pet].PetId,
        Type = "Pet",
        Owner = self,
    }
    self.Pet:InitSlot(PetParams)
    --魅影1槽更新
    local Phantom1Params = {
        Uuid = self.SquadInfo.Phantom1,
        Id = self.SquadInfo.Phantom1Id,
        Type = "Char",
        Owner = self,
    }
    self.Head_Phantom01:InitSlot(Phantom1Params)
    --魅影1武器槽更新
    local Phantom1WeaponParams = {
        Uuid = self.SquadInfo.PhantomWeapon1,
        Id = self.SquadInfo.PhantomWeapon1Id,
        Type = self:GetWeaponTypeById(self.SquadInfo.PhantomWeapon1Id),
        Owner = self,
    }
    self.Weapon_Phantom01:InitSlot(Phantom1WeaponParams)
    --魅影2槽更新
    local Phantom2Params = {
        Uuid = self.SquadInfo.Phantom2,
        Id = self.SquadInfo.Phantom2Id,
        Type = "Char",
        Owner = self,
    }
    self.Head_Phantom02:InitSlot(Phantom2Params)
    --魅影2武器槽更新
    local Phantom2WeaponParams = {
        Uuid = self.SquadInfo.PhantomWeapon2,
        Id = self.SquadInfo.PhantomWeapon2Id,
        Type = self:GetWeaponTypeById(self.SquadInfo.PhantomWeapon2Id),
        Owner = self,
    }
    self.Weapon_Phantom02:InitSlot(Phantom2WeaponParams)
    --轮盘槽更新
    local RouletteParams = {
        Id = self.SquadInfo.WheelIndex or 1,
        Type = "Roulette",
        Owner = self,
    }
    self.Roulette:InitSlot(RouletteParams)
    self:AddDelayFrameFunc(
        function()
            if self.IsOpenAddSquad then
                self:AddSquad()
            end
        end, 1, "AddSquadDelay")
    return

end

function WBP_SquadBuild_Main_P_C:GetWeaponTypeById(WeaponId)
    if not WeaponId then
        DebugPrint("thy    GetWeaponTypeById 没有提供武器Id")
        return
    end
    local WeaponTypeList = DataMgr.BattleWeapon[WeaponId].WeaponTag
    if WeaponTypeList then
        for _, value in pairs(WeaponTypeList) do
            if value == "Melee" or value == "Ranged" then
                return value
            end
        end
    end--保底
    DebugPrint("thy    GetWeaponTypeById 没有找到武器类型", WeaponId)
    return "Melee"
end

--初始化一些控制列表信息的相关变量
function WBP_SquadBuild_Main_P_C:InitItemVarInfo(ItemType)
    --当前数据类型
    self.CurSlotType = ItemType
end

--在列表添加当前类型的数据
function WBP_SquadBuild_Main_P_C:FillSelectiveList()
    self.List_Build:BindEvents(self,{
        OnListItemClicked = self.ClickListItem,
        SortFuncion = self.SortItemContents,
        FilterFunction = self.FilterItemContents,
    })
    if(self[self.CurSlotType .. "FilterTags"])then
        self.Filters = self:CreateFilters(self[self.CurSlotType .. "FilterTags"],
                                        self[self.CurSlotType .. "FilterNames"],
                                        self[self.CurSlotType .. "FilterIcons"])
    else
        self.Filters = nil
    end

    self.List_Build:Init(self,{
        Filters = self.Filters,
        OrderByDisplayNames = self.CurSlotType == "Pet" and self.OrderByDisplayNamesOnPet or self.OrderByDisplayNames,
        SortType = CommonConst.DESC,
        ItemContents = self[self.CurSlotType .. "ItemContentsArray"],
    })
end

--初始化过滤
function WBP_SquadBuild_Main_P_C:CreateFilters(InTags,InTexts,InIcons)
    local Filters = {}
    for i, _ in ipairs(InTags) do
        table.insert(Filters,{
            Tag = InTags[i],
            Text = InTexts[i],
            Icon = InIcons[i],
        })
    end
    return Filters
end

--左侧列表需要显示的内容 角色/武器/宠物
function WBP_SquadBuild_Main_P_C:FilterItemContents(InContentArray, FilterIdxes)
    --过滤数据对象
    local SlotType = self.CurSlotType
    local DataType = self.SlotType2DataType[SlotType]
    local FilteredItems = {}
    local FilterFunc
    if(DataType == "Char")then
        FilterFunc = function(FilterTag,Content)
            local Data = DataMgr.BattleChar[Content.UnitId]
            return FilterTag == Data.Attribute
        end
    elseif(DataType == "Weapon")then
        local Avatar = ArmoryUtils:GetAvatar()
        FilterFunc = function(FilterTag,Content)
            local Weapon = Avatar.Weapons[Content.Uuid]
            return Weapon:HasTag(FilterTag)
        end
    elseif(DataType == "Pet")then
        FilterFunc = function()
            return true
        end
    end
    if(FilterFunc)then
        for _, Content in ipairs(InContentArray) do
            for _, Idx in ipairs(FilterIdxes) do
                if(FilterFunc(self[SlotType .. "FilterTags"][Idx],Content))then
                    table.insert(FilteredItems,Content)
                    break
                end
            end
        end
    end
    return FilteredItems
end

--对列表中的对象按规则排序
function WBP_SquadBuild_Main_P_C:SortItemContents(InOutContentArray,SortByIdx, SortType)
    local FirstContent = self[self.CurSlotType .. "Main_CurContent"] or self[self.CurSlotType .. "Main_CmpContent"]
    local SortByAttrNames = {self.OrderByAttrNames[SortByIdx]}
    for index, value in ipairs(self.OrderByAttrNames) do
        if(index ~= SortByIdx)then
            table.insert(SortByAttrNames,value)
        end
    end
    ArmoryUtils:SortItemContents(InOutContentArray,SortByAttrNames,SortType,FirstContent)
end

function WBP_SquadBuild_Main_P_C:SetItemSelectState(Content, IsSelected)
    if Content then
        Content.IsSelected = IsSelected
        if Content.SelfWidget then
            local IsPhantom, Pos = self:IsSubstringContained(self.CurSlot:GetName(), "Weapon_Phantom")
            if self.PhantomSlot[self.CurSlot:GetName()] and IsPhantom then
                if self["Head_Phantom0"..Pos].ItemInfo then
                    Content.SelfWidget:SetWeaponMiniPhantomIcon(IsSelected and self["Head_Phantom0"..Pos].ItemInfo.UnitId or nil)
                end
            else
                Content.SelfWidget:SetInGear(Content.IsSelected)
            end
            
        end
    end
end

function WBP_SquadBuild_Main_P_C:CheckCurSlotIsPhantomSlot()
    if not self.CurSlot then
        return false
    end
    for WidgetName, Widget in pairs(self.PhantomSlot) do
        if self.CurSlot == Widget then
            return true
        end
    end
    return false
end

--点击列表对象的回调
function WBP_SquadBuild_Main_P_C:ClickListItem(Content)
    --点到空格子直接返回,不然已经装备的物品会出现在奇怪的位置
    if Content.Uuid == nil or Content.Uuid == "" then
        return
    end
    if not self.CurClickItemInfo then
        self.CurClickItemInfo = self.CurSlot.ItemInfo
    end

    if self.CurSlot and not self.PlayerAboutSlots[self.CurSlot.Type] and self.CurClickItemInfo == Content then
        return
    end

    if self:CheckCurSlotIsPhantomSlot() and self.CurClickItemInfo == Content then
        return
    end

    if not self.PreContent then
        self.PreContent = self.CurSlot.ItemInfo
    end

    if self.CurClickItemInfo and self.CurClickItemInfo.SelfWidget then
        if self.CurSlot.ItemInfo then
            self.CurSlot.ItemInfo.SelfWidget:SetSelected(false)
        end
        self.CurClickItemInfo.SelfWidget:SetSelected(false)
    end

    Content.SelfWidget:SetSelected(true)

    if Content.Tag == "Pet" or Content.Tag == "Char" then
        AudioManager(self):PlayUISound(nil, EquipSoundPaths[Content.Tag], nil, nil)
    else
        AudioManager(self):PlayUISound(nil, EquipSoundPaths["Weapon"], nil, nil)
    end

    --self:RevertAllItemIcon()

    --处理仅选择时物体图标的情况
    --self:HandleOnlyChooseItemIcon(Content)

    self.CurClickItemInfo = Content

    --如果不是主要角色/武器/宠物，则直接走交换图标
    if not self:CheckSlotTypeIsAboutMainRole(self.CurSlot) then
        self:MakeSureCallback()
        return
    end
    --弹物品窗
    self:OpenTips()
end

--处理仅选择时物体图标的情况
function WBP_SquadBuild_Main_P_C:HandleOnlyChooseItemIcon(Content)
    if self.CurSlot.Type == "Char" then
        if not Content.IsSelected then
            if self.CurClickItemInfo then
                self:SetItemSelectState(self.CurClickItemInfo, false)
            else
                self:SetItemSelectState(self.CurSlot.ItemInfo, false)
            end
            self:SetItemSelectState(Content, true)
        end
    else
        --清除所有标记
        if self.CurClickItemInfo then
            self:SetItemSelectState(self.CurClickItemInfo, false)
            self.CurClickItemInfo.SelfWidget:SetWeaponMiniPhantomIcon()
        else
            self:SetItemSelectState(self.CurSlot.ItemInfo, false)
            if self.CurSlot.ItemInfo and self.CurSlot.ItemInfo.SelfWidget then
                self.CurSlot.ItemInfo.SelfWidget:SetWeaponMiniPhantomIcon()
            end
        end
        self:SetItemSelectState(Content, false)
        Content.SelfWidget:SetWeaponMiniPhantomIcon()
        --检查点击的内容是哪个槽位在用，直接调用它的更新图标方法
        local CachedWidget = self:CheckCachedOnlyShowItem(Content)
        if CachedWidget then
            if self.CurClickItemInfo then
                CachedWidget:ShowListItemStateOnce(self.CurClickItemInfo)
                self:CachedOnlyShowChooseItemInSlot(CachedWidget, self.CurClickItemInfo)
            else
                CachedWidget:ShowListItemStateOnce(self.CurSlot.ItemInfo)
                self:CachedOnlyShowChooseItemInSlot(CachedWidget, self.CurSlot.ItemInfo)
            end
        else
            local Widget = self:CheckContentIsSet(Content)
            if Widget then
                if self.CurClickItemInfo then
                    Widget:ShowListItemStateOnce(self.CurClickItemInfo)
                    self:CachedOnlyShowChooseItemInSlot(Widget, self.CurClickItemInfo)
                else
                    Widget:ShowListItemStateOnce(self.CurSlot.ItemInfo)
                    self:CachedOnlyShowChooseItemInSlot(Widget, self.CurSlot.ItemInfo)
                end
            end
        end
        --现在点击Content图标处理
        self.CurSlot:ShowListItemStateOnce(Content)
    end
end

function WBP_SquadBuild_Main_P_C:ClearSlotCachedData()
    for WidgetName, Widget in pairs(self.RightSlots) do
        Widget.CachedOnlyShowItem = nil
    end
end

function WBP_SquadBuild_Main_P_C:CachedOnlyShowChooseItemInSlot(TargetWidget, Content)
    self:ClearSlotCachedData()
    TargetWidget.CachedOnlyShowItem = Content
end

function WBP_SquadBuild_Main_P_C:CheckCachedOnlyShowItem(Content)
    for WidgetName, Widget in pairs(self.RightSlots) do
        if Widget.CachedOnlyShowItem and Widget.CachedOnlyShowItem == Content then
            return Widget
        end
    end
    return nil
end

function WBP_SquadBuild_Main_P_C:CheckContentIsSet(Content)
    for WidgetName, Widget in pairs(self.RightSlots) do
        if Widget.ItemInfo == Content then
            return Widget
        end
    end
    return nil
end

--检查当前选择的槽位是否为主要角色使用（玩家使用角色/双武器/宠物）
function WBP_SquadBuild_Main_P_C:CheckSlotTypeIsAboutMainRole(Slot)
    for key, value in pairs(self.PlayerAboutSlots) do
        if Slot == value then
            return true
        end
    end
    return false
end

function WBP_SquadBuild_Main_P_C:OnBGClick()
    self:CloseTips(true)
    return UIUtils.Unhandled
end

function WBP_SquadBuild_Main_P_C:CloseTips(IsChoose)
    if self.Pos_Tips:GetChildAt(0) then
        self.IsPetTipsOpen = false
        self:InitBottomTab(false, 2)
        self:UnbindFromAnimationFinished(self.Tips_Out, {self, function()
            self.Panel_Tips:SetVisibility(ESlateVisibility.Collapsed)
        end})
        self:BindToAnimationFinished(self.Tips_Out, {self, function()
            self.Panel_Tips:SetVisibility(ESlateVisibility.Collapsed)
        end})
        self:PlayAnimation(self.Tips_Out)
        self.SquadItemTip:CloseWidget()
        self.Pos_Tips:ClearChildren()

        if self.CurClickItemInfo and self.CurClickItemInfo.SelfWidget then
            self.CurClickItemInfo.SelfWidget:SetSelected(false)
        end

        if self.CurSlot.ItemInfo and self.CurSlot.ItemInfo.SelfWidget then
            self.CurSlot.ItemInfo.SelfWidget:SetSelected(true)
        end
        
        if self.CurInputDeviceType == ECommonInputType.Gamepad then
            self.List_Build.Sort.Controller:SetVisibility(ESlateVisibility.Visible)
        end
    end

    if not IsChoose then
        --点击的 / 缓存的 /各个槽位的ItemInfo
        self:RevertAllItemIcon()
    end
    self:FocusOnItemList()
end

function WBP_SquadBuild_Main_P_C:RevertAllItemIcon()
    self:SetItemSelectState(self.CurClickItemInfo, false)
    for WidgetName, Widget in pairs(self.RightSlots) do
        if Widget.CachedOnlyShowItem then
            Widget.CachedOnlyShowItem.SelfWidget:SetWeaponMiniPhantomIcon()
            self:SetItemSelectState(Widget.CachedOnlyShowItem, false)
        end
    end
    for WidgetName, Widget in pairs(self.RightSlots) do
        if Widget.UpdateListItemState then
            Widget:UpdateListItemState(Widget.ItemInfo)
        end
    end
    self.CurClickItemInfo = nil
    self.PreContent = nil
end

function WBP_SquadBuild_Main_P_C:OpenTips()

    self.Pos_Tips:ClearChildren()

    self.SquadItemTip = self:CreateWidgetNew("SquadItemTips")
    self.Pos_Tips:AddChild(self.SquadItemTip)
    self.IsPetTipsOpen = true
    self.Panel_Tips:SetVisibility(ESlateVisibility.Visible)
    self.Panel_Tips:SetRenderOpacity(0)
    self:PlayAnimation(self.Tips_In)
    self.List_Build.Sort.Controller:SetVisibility(ESlateVisibility.Collapsed)
    if self.CurClickItemInfo.Type ~= "Pet" then
        self:InitBottomTab(true, 2, GText("PROLOGUE_SELECTGUN_TIP_4"))
    else
        self:InitBottomTab(true, 1)
    end

    self.SquadItemTip:SetVisibility(ESlateVisibility.Visible)
    local Params = {
        ItemInfo = self.CurClickItemInfo,
        Owner = self,
        MakeSureCallback = self.MakeSureCallback,
        GoToArmory = self.GoToArmory
    }
    --初始化物品窗
    self.SquadItemTip:InitWidget(Params)

    self:SetCurFocusArea("Tip")
end

--前往军械库对应类型界面
function WBP_SquadBuild_Main_P_C:GoToArmory()
    AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_confirm", nil, nil)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    local bInSkillAndSafeToCancel = Player:CharacterInTag('Skill') and Player:IsSafeToCancelSkill()
    if Player:CanEnterInteractive()
        and (Player:CharacterInTag('Interactive') or Player:CharacterInTag('Idle') or bInSkillAndSafeToCancel)
        and Player.PlayerAnimInstance
        and ((Player.PlayerAnimInstance.IdletagName == "0" or Player.PlayerAnimInstance.IdletagName == "EmoIdle")) 
        and (not (self.IsFromDungeonPage and UIManager(self):GetArmoryUIObj())) then
        if bInSkillAndSafeToCancel then 
            Player:StopSkill(UE.ESkillStopReason.ArmoryCancel) 
        end 
    else
        UIManager(self):ShowUITip("CommonToastMain", GText("UI_Toast_Armory_Forbid"))
        return
    end

    local Params = {}
    if self.CurClickItemInfo then
        Params = {bNoEndCamera = true,
                    bHideSquadBuildBtn = true,
                    bHideBoxBtn = true,
                    bHideDeployBtn = true,
                    OnCloseDelegate = {self,function()
                        if not self.CurSquadInfo.Char or self.CurSquadInfo.Char == "" then
                            self:HideOrShowModel(true)
                        else
                            self:HideOrShowModel(false)
                        end
                    end}}
    else
        Params = {bNoEndCamera = true,
                    bHideSquadBuildBtn = true,
                    bHideBoxBtn = true,
                    bHideDeployBtn = true,
                    MainTabName = ArmoryUtils.ArmoryMainTabNames.BattleWheel,
                    BattleWheelIndex  = self.Roulette.Id
                }
    end

    --1角色 2近战 3远程 4同律武器 5宠物 6轮盘
    if self.CurSlotType == "Char" then--角色
        Params.MainTabName = ArmoryUtils.ArmoryMainTabNames.Char
        Params.CharUuids = {self.CurClickItemInfo.Uuid,}
        Params.bHideMeleeTab = true
        Params.bHideRangedTab = true
        Params.bHideWeaponTab = true
        Params.bHidePetTab = true
        Params.bHideBattleWheel = true
        Params.bHideUltraTab = true
    elseif self.CurSlotType == "Melee" then--近战武器
        Params.MainTabName = ArmoryUtils.ArmoryMainTabNames.Melee
        Params.WeaponUuids = {self.CurClickItemInfo.Uuid,}
        Params.bHideCharTab = true
        Params.bHideRangedTab = true
        Params.bHideWeaponTab = true
        Params.bHidePetTab = true
        Params.bHideBattleWheel = true
        Params.bHideUltraTab = true
    elseif self.CurSlotType == "Ranged" then--远程武器
        Params.MainTabName = ArmoryUtils.ArmoryMainTabNames.Ranged
        Params.WeaponUuids = {self.CurClickItemInfo.Uuid,}
        Params.bHideMeleeTab = true
        Params.bHideCharTab = true
        Params.bHideWeaponTab = true
        Params.bHidePetTab = true
        Params.bHideBattleWheel = true
        Params.bHideUltraTab = true
    elseif self.CurSlotType == "Pet" then--宠物
        Params.MainTabName = ArmoryUtils.ArmoryMainTabNames.Pet
        Params.PetUniqueIds = {self.CurClickItemInfo.Uuid,}
        Params.bHideCharTab = true
        Params.bHideMeleeTab = true
        Params.bHideRangedTab = true
        Params.bHideWeaponTab = true
        Params.bHideBattleWheel = true
        Params.bHideUltraTab = true
    else--轮盘
        Params.MainTabName = ArmoryUtils.ArmoryMainTabNames.BattleWheel
        Params.bHideCharTab = true
        Params.bHideMeleeTab = true
        Params.bHideRangedTab = true
        Params.bHideWeaponTab = true
        Params.bHidePetTab = true
        Params.bHideUltraTab = true
    end
    --关闭物品信息弹窗
    self:CloseTips()
    --打开军械库面板
    UIManager(self):LoadUINew("ArmoryDetail",Params)
    self.DontNeedPlayAnimation = true
    -- local ArmoryDetail = UIManager(self):GetUIObj("ArmoryDetail")
    -- if ArmoryDetail then
    --     UIManager(self):UnLoadUINew("ArmoryDetail")
    --     UIManager(self):LoadUINew("ArmoryDetail",Params)
    -- else
    --     UIManager(self):LoadUINew("ArmoryDetail",Params)
    -- end
end

function WBP_SquadBuild_Main_P_C:HideOrShowModel(bHide)
    self.ActorController:HidePlayerActor("SuqadRole", bHide)
end

--物品栏弹窗点击确定回调
function WBP_SquadBuild_Main_P_C:MakeSureCallback(ModIndex)
    local IsNeedPhantomIconTmp, NumTmp = self:IsNeedPhantomIcon()
    local Parmas = {
        ItemInfo = self.CurClickItemInfo,
        Uuid = self.CurClickItemInfo.Uuid,
        Id = self.CurClickItemInfo.UnitId,
        Rarity = self.CurClickItemInfo.Rarity,
        ModSuit = ModIndex or (self.PreSlot and self.PreSlot.ModSuit),
        Type = self.CurSlotType,
        IsNeedPhantomIcon = IsNeedPhantomIconTmp,
        Num = NumTmp,
        Owner = self,
    }
    --内部item标识清除
    if self.CurSlot.ItemInfo ~= self.CurClickItemInfo then
        self.CurSlot:ClearItemFlag()
    end

    --需要检查当前槽位是否有相同的武器或者角色，有则相互调换位置，没有则直接设置
    if self:CheckSelectItemIsRepeatInCurAllSlot() then
        --内部item标识清除
        self.PreSlot:ClearItemFlag()

        if self.CurSlot:GetIsEmpty() or (not self:WeaponIsValidForSlot()) then
            self.PreSlot:ClearSlot()
        else
            local PreParmas = self.CurSlot:GetParams()
            PreParmas.ItemInfo = self.CurSlot.ItemInfo
            PreParmas.ModSuit = (PreParmas.ModSuit and PreParmas.ModSuit > 0) and PreParmas.ModSuit or self.PreSlot.ModSuit
            self.PreSlot:InitSlot(PreParmas) 
        end
        self:PopChangeRoleToastByType(Parmas)
    end

    self.CurSlot:InitSlot(Parmas)
    self.PreContent = self.CurSlot.ItemInfo

    self:CloseTips(true)
end

--检查这个槽位是不是主要角色使用的槽位
function WBP_SquadBuild_Main_P_C:CheckIsMainRoleWeapon(Slot)
    for WidgetName, Widget in pairs(self.PlayerForceSlot) do
        if Widget == Slot then
            return true
        end
    end
    return false
end

--在交换武器时检查武器替换到主要角色槽位上时是否合法
function WBP_SquadBuild_Main_P_C:WeaponIsValidForSlot()
    if self:CheckSlotTypeIsAboutMainRole(self.PreSlot) then
        if self.PreSlot and self.CurSlot.Params.Type ~= self.PreSlot.Type then
           return false
        end
    end
    return true
end

function WBP_SquadBuild_Main_P_C:PopChangeRoleToastByType(Parmas)
    local WidgetName = self.CurSlot:GetName()
    local IsPhantom, PhantomNum = self:IsSubstringContained(WidgetName, "Head_Phantom0")
    local IsPhantomWeapon, PhantomWeaponNum = self:IsSubstringContained(WidgetName, "Weapon_Phantom0")
    if WidgetName == "Character" then
        UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Squad_SwitchChar_Toast"), GText(self:GetCharName(Parmas.Id))))
    elseif IsPhantom then
        UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Squad_SwitchSigil_Toast"), GText(self:GetCharName(Parmas.Id)), GText("UI_Squad_Sigil"..PhantomNum)))
    elseif IsPhantomWeapon then
        UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Squad_SwitchSigil_Toast"), GText(self:GetWeaponName(Parmas.Id)), GText("UI_Squad_Sigil"..PhantomWeaponNum)))
    elseif WidgetName == "Melee" or WidgetName == "Ranged" then
        UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Squad_SwitchChar_Toast"), GText(self:GetWeaponName(Parmas.Id))))
    end
end

function WBP_SquadBuild_Main_P_C:GetCharName(CharId)
    return DataMgr.Char[CharId] and DataMgr.Char[CharId].CharName
end

function WBP_SquadBuild_Main_P_C:GetWeaponName(WeaponId)
    return DataMgr.Weapon[WeaponId] and DataMgr.Weapon[WeaponId].WeaponName
end

function WBP_SquadBuild_Main_P_C:IsNeedPhantomIcon()
    local IsNeedPhantomIcon, Num = self:IsSubstringContained(self.CurSlot:GetName(), "Weapon_Phantom")
    return IsNeedPhantomIcon, Num
end

function WBP_SquadBuild_Main_P_C:IsSubstringContained(parentStr, subStr)
    local startPos, endPos = string.find(parentStr, subStr)
    if startPos ~= nil then
        return startPos ~= nil, string.sub(parentStr, -1) 
    end
    return nil, nil
end

function WBP_SquadBuild_Main_P_C:CheckSelectItemIsRepeatInCurAllSlot()
    for key, value in pairs(self.RightSlots) do
        if value:GetItemId() == self.CurClickItemInfo.Uuid and value:GetName() ~= self.CurSlot:GetName() and key ~= "WheelIndex" then
            self.PreSlot = value
            return true
        end
    end
    return false
end

--初始化过滤词条 最左边的元素类型过滤
function WBP_SquadBuild_Main_P_C:InitSelectiveList()
    --获取过滤词条 等级/稀有度
    self.OrderByDisplayNames = {"UI_LEVEL_SELECT"}
    self.OrderByDisplayNamesOnPet = {"UI_LEVEL_SELECT","UI_RARITY_NAME"}
    --按词条名称排序用
    self.OrderByAttrNames = {"Level","Rarity","SortPriority","UnitId"}
    --所有元素类型/名称
    self.CharFilterTags,self.CharFilterNames = UIUtils.GetAllElementTypes()
    --角色类型图标
    self.CharFilterIcons = {}
    for key, Tag in pairs(self.CharFilterTags) do
        local IconName = "Armory_" .. Tag
        table.insert(self.CharFilterIcons,"/Game/UI/Texture/Dynamic/Atlas/Armory/T_" .. IconName .. ".T_" .. IconName)
    end
    --武器tag、显示名称
    self.MeleeFilterTags,self.MeleeFilterNames,self.RangedFilterTags,self.RangedFilterNames = UIUtils.GetAllWeaponTags()
    self.MeleeFilterIcons = {}
    for _, Tag in ipairs(self.MeleeFilterTags) do
        local Data = DataMgr.WeaponTag[Tag]
        table.insert(self.MeleeFilterIcons,Data and Data.Icon)
    end
    self.RangedFilterIcons = {}
    for _, Tag in ipairs(self.RangedFilterTags) do
        local Data = DataMgr.WeaponTag[Tag]
        table.insert(self.RangedFilterIcons,Data and Data.Icon)
    end
end

-----------------------------------------预设阵容角色/武器/宠物列表End-------------------------

-----------------------------------------预设阵容轮盘编辑Start--------------------------------

--更新到轮盘
function WBP_SquadBuild_Main_P_C:SwitchToRouletteList()
    self:SwitchLeftWidgetByIndex(3)
    self.IsInEditor = true
    self:SwitchBtnPanel()
    self:GetWheelNum()
    self:UpdateRouletteUI()
    self:ResetAllSlotsClickState()
    if not self.DontNeedPlayAnimation then
        self:PlayAnimation(self.Left_In)
    else
        self.Roulette.IsClicking = true
    end
    --页面聚焦到List_Roulette
    self:FocusOnItemList()
    self:InitBottomTab(false, 2)
end

--获取玩家轮盘的数量
function WBP_SquadBuild_Main_P_C:GetWheelNum()
    self.Avatar = GWorld:GetAvatar()
    self.WheelNum = nil
    if self.Avatar then
        for key, value in pairs(self.Avatar.Wheels) do
            self.WheelNum = key
        end
    end
    self.WheelNum = self.WheelNum or 3
end

--更新轮盘UI
function WBP_SquadBuild_Main_P_C:UpdateRouletteUI()
    self.Text_Roulette:SetText(GText("UI_Squad_ChooseSuit"))
    local IsScrollDisable = self.List_Default:IsDisableScroll()
    self.List_Roulette:SetAllowOverscroll(IsScrollDisable)

    self.List_Roulette:ClearListItems()
    for i = 1, self.WheelNum do
        local Content =  NewObject(UIUtils.GetCommonItemContentClass())
        Content.ClickCallback = self.UpdateRouletteSlot
        Content.Owner = self
        Content.Index = i
        Content.IsSelect = (i == self.Roulette.Id)
        self.List_Roulette:AddItem(Content)
    end
end

--轮盘Arr
function WBP_SquadBuild_Main_P_C:UpdateWheelArr(Item)
    if not self.WheelArr or #self.WheelArr == 3 then
        self.WheelArr = {}
    end
    table.insert(self.WheelArr, Item)
end

--更新轮盘的索引
function WBP_SquadBuild_Main_P_C:UpdateRouletteSlot(Index)
    self.Roulette:ChangeWheelIndex(Index)
    for i = 1, self.WheelNum do
        if i ~= Index then
            local Item = self.WheelArr[i]
            Item.IsSelect = false
            Item:PlayAnimation(Item.Normal)
        end
    end
end
-----------------------------------------预设阵容轮盘编辑End-----------------------------------

-----------------------------------------手柄/监听相关Start-----------------------------------------



function WBP_SquadBuild_Main_P_C:Handle_OnPCDown(InKeyName)
    if (InKeyName == "Escape") then
        self:OnBackKeyDown()
        return true
    elseif (InKeyName == "Q") then
        if self.CurSlot.IsPhantomWeapon then
            if self.CurPhantomWeaponType ~= "Melee" then
                self:PhantomWeaponTypeChanged("Melee")
            end
            return true
        end
    elseif (InKeyName == "E") then
        if self.CurSlot.IsPhantomWeapon then
            if self.CurPhantomWeaponType ~= "Ranged" then
                self:PhantomWeaponTypeChanged("Ranged")
            end
            return true
        end
    end
    return false
end

--父类有设备切换监听，只需要重新刷新UI逻辑
function WBP_SquadBuild_Main_P_C:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    --更新输入模式
    self.CurInputDeviceType = CurInputType
    self.CurGamepadName = CurGamepadName
    --更新UI
    self:InitUI()
    self:SwitchSlotDeleteIconVisible()
end

function WBP_SquadBuild_Main_P_C:SwitchSlotDeleteIconVisible()
    for _, Wdiget in pairs(self.RightSlots) do
        if Wdiget.AddDelelteIcon then
            Wdiget:AddDelelteIcon()
        end
    end
end

function WBP_SquadBuild_Main_P_C:InitUI()
    --键鼠手机
    if self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard or self.CurInputDeviceType == ECommonInputType.Touch then
        self:UpdateGamepadIcon()
        self.IsInSortState = false
        --self.Com_Tab:SetFocus()
        self:AddDelayFrameFunc(
            function()
                --防止手柄排序时热切导致预设阵容添加item消失
                self:SwitchAddSquadItemVisibility(true)
                if self:GetSquadWidgetInSquadList(self.CurSelectSquadIndex) then
                    self:GetSquadWidgetInSquadList(self.CurSelectSquadIndex):HideAllArrow()
                end 
            end, 2, "HideAllArrow")
        return
    end
    --手柄
    self:AddDelayFrameFunc(
        function()
            self.CurGamepadArea = nil
            self.IsInSortState = false
            self:SwitchGamePadIconVisibilityBySortState(true)
            if self.IsInEditor then
                self:FocusOnRightDetailPanel()
            else
                self:FocusOnSquadList()
            end
        end, 
        2, "SwitchGamePad")
end

--按钮注册手柄图标
function WBP_SquadBuild_Main_P_C:RegisterBtnIconInGampad()
    self.Btn_Edit:SetDefaultGamePadImg("X")
    self.Btn_Save:SetDefaultGamePadImg("X")
    self.Btn_Cancel:SetDefaultGamePadImg("B")
    self.Btn_Armory:SetDefaultGamePadImg("View")
end

--一些图标显示手柄 排序/删除/编辑名称/编辑阵容
function WBP_SquadBuild_Main_P_C:UpdateGamepadIcon(bShowSort, bShowDelete,bShowEditName,bShowEditSquad)
    if self.Key_Controller_Sort then
        self.Key_Controller_Sort:CreateCommonKey({
                KeyInfoList = {{
                    Type = "Img",
                    ImgShortPath = "LS"}
                }}
            )
        if bShowSort and self.SquadListLen > 1 then
            self.Key_Controller_Sort:SetVisibility(ESlateVisibility.Visible)
        else
            self.Key_Controller_Sort:SetVisibility(ESlateVisibility.Collapsed)
        end
    end
    if self.Key_Controller_Delete then
        self.Key_Controller_Delete:CreateCommonKey({
                KeyInfoList = {{
                    Type = "Img",
                    ImgShortPath = "RS"}
                }}
            )
        if bShowDelete then
            self.Key_Controller_Delete:SetVisibility(ESlateVisibility.Visible)
        else
            self.Key_Controller_Delete:SetVisibility(ESlateVisibility.Collapsed)
        end
    end
    if self.Key_Controller_EditName then
        self.Key_Controller_EditName:CreateCommonKey({
                KeyInfoList = {{
                    Type = "Img",
                    ImgShortPath = "Menu"}
                }}
            )
        if bShowEditName then
            self.Key_Controller_EditName:SetVisibility(ESlateVisibility.Visible)
        else
            self.Key_Controller_EditName:SetVisibility(ESlateVisibility.Collapsed)
        end
    end
    if self.Btn_Edit and self.Btn_Edit.Key_GamePad then
        if bShowEditSquad then
            self.Btn_Edit.Key_GamePad:SetVisibility(ESlateVisibility.Visible)
        else
            self.Btn_Edit.Key_GamePad:SetVisibility(ESlateVisibility.Collapsed)
        end
    end
end
---------------------------------------手柄相关start--------------------------------------------------------
--预设阵容列表聚焦 非排序
function WBP_SquadBuild_Main_P_C:FocusOnSquadList()
    if self.CurInputDeviceType ~= ECommonInputType.Gamepad then
        return
    end

    if self:CheckHasTip() then
        return
    end
    self:SetCurFocusArea("SquadList")

    if self:GetSquadWidgetInSquadList(self.CurSelectSquadIndex) then
        self:GetSquadWidgetInSquadList(self.CurSelectSquadIndex):SetFocus()
    end

    --排序显示，删除和编辑名称 编辑按钮 显示
    self:UpdateGamepadIcon(true, true, true, true)

    --底部显示
    self:InitBottomTab(true, 2)

end

--预设阵容列表聚焦 排序
function WBP_SquadBuild_Main_P_C:FocusOnSquadListInSortState()
    if self.CurInputDeviceType ~= ECommonInputType.Gamepad then
        return
    end

    if self:CheckHasTip() then
        return
    end

    self:SetCurFocusArea("SquadListInSort")

    self:GetSquadWidgetInSquadList(self.CurSelectSquadIndex):SetFocus()

    --排序状态时全隐藏
    self:UpdateGamepadIcon()

end

--预设阵容右侧细节聚焦
function WBP_SquadBuild_Main_P_C:FocusOnRightDetailPanel()
    if self.CurInputDeviceType ~= ECommonInputType.Gamepad then
        return
    end

    if self:CheckHasTip() then
        return
    end

    if (not self.CurSlot) or (not self.IsInEditor) then
        self.Character:SetFocus()
    else
        self.CurSlot:SetFocus()
    end

    --左侧的图标恢复pc  
    --预设阵容（阵容编辑状态）
    if self.IsInEditor then
        self:SetCurFocusArea("SlotInEdit")
        --排序不显示 编辑和删除显示
        self:UpdateGamepadIcon(nil, nil, true)
        --显示保存和取消
        self.Btn_Save.Key_GamePad:SetRenderOpacity(1)
        self.Btn_Save.Key_GamePad:SetVisibility(ESlateVisibility.Visible)
        self.Btn_Cancel.Key_GamePad:SetVisibility(ESlateVisibility.Visible)
        --物品排序图标隐藏
        self.List_Build.Sort.Controller:SetVisibility(ESlateVisibility.Collapsed)
    else
        self:SetCurFocusArea("SlotInView")
        --排序不显示 删除显示 编辑显示
        self:UpdateGamepadIcon(false, true, true, true)
        --显示保存和取消
        self.Btn_Save.Key_GamePad:SetRenderOpacity(0)
        self.Btn_Save.Key_GamePad:SetVisibility(ESlateVisibility.Collapsed)
        self.Btn_Cancel.Key_GamePad:SetVisibility(ESlateVisibility.Collapsed)
    end
    self:InitBottomTab(false, 3)
end

--预设阵容角色/武器/宠物栏/轮盘
function WBP_SquadBuild_Main_P_C:FocusOnItemList()
    if self.CurInputDeviceType ~= ECommonInputType.Gamepad then
        return
    end

    if self:CheckHasTip() then
        return
    end

    self:SetCurFocusArea("ListItem")

    --角色/宠物/武器
    if self.Panel_List:IsVisible() then
        self.CurClickItemInfo = self.CurSlot and self.CurSlot.ItemInfo
        if self.CurClickItemInfo and self.CurClickItemInfo.UI then
            self.CurClickItemInfo.UI:SetFocus()
        else
            if self.List_Build.List_Select:GetNumItems() > 0 then
                self.List_Build.List_Select:SetFocus()
                self.List_Build.List_Select:SetSelectedIndex(0)
            else
                self.List_Build.EMListView_Filter:SetFocus()
            end
        end
        self.List_Build.Sort.Controller:SetVisibility(ESlateVisibility.Visible)
    else
        self.List_Roulette:SetFocus()
        self.List_Roulette:SetSelectedIndex(0)
    end
    self:InitBottomTab(false, 2)

    --右侧保存和取消恢复PC样式
    self.Btn_Save.Key_GamePad:SetRenderOpacity(0)
    self.Btn_Save.Key_GamePad:SetVisibility(ESlateVisibility.Collapsed)
    self.Btn_Cancel.Key_GamePad:SetVisibility(ESlateVisibility.Collapsed)
    --排序不显示 删除不显示 编辑不显示
    self:UpdateGamepadIcon()
end

--弹窗提示 有提示窗返回false，并聚焦到提示窗上
function WBP_SquadBuild_Main_P_C:CheckHasTip()
    if self.CurInputDeviceType ~= ECommonInputType.Gamepad then
        return
    end
    if self.Pos_Tips:GetChildAt(0) then
        if self.CurSlotType ~= "Pet" then
            self.SquadItemTip.Edit_Tips.ModType01:SetFocus()
        else
            self.SquadItemTip:SetFocus()
        end
        self:SetCurFocusArea("Tip")
        return true
    elseif self.IsEditSquadName then
        self.NameEditDialog:SetFocus()
        self:SetCurFocusArea("Tip")
        return true
    elseif self.DeleteSquadTips and (not self.DeleteSquadTips.IsClosing) then
        local UWidget =  UIUtils.GetRootUWidget(self.DeleteSquadTips)
        UWidget:SetFocus()
        self:SetCurFocusArea("Tip")
        return true
    elseif self.SaveSquadTip and (not self.SaveSquadTip.IsClosing) then
        local UWidget =  UIUtils.GetRootUWidget(self.SaveSquadTip)
        UWidget:SetFocus()
        self:SetCurFocusArea("Tip")
        return true
    elseif self.CancelPopUI and (not self.CancelPopUI.IsClosing) then
        local UWidget=  UIUtils.GetRootUWidget(self.CancelPopUI)
        UWidget:SetFocus()
        self:SetCurFocusArea("Tip")
        return true
    else
        return false
    end
end

--设置当前手柄聚焦的区域，不允许直接调用 区域目前分为 SquadList SquadListInSort SlotInEdit SlotInView ListItem Tip
function WBP_SquadBuild_Main_P_C:SetCurFocusArea(CurFocusArea)
    self.CurGamepadArea = CurFocusArea
    DebugPrint("thy   SetCurFocusArea", self.CurGamepadArea)
end
---------------------------------------手柄相关end--------------------------------------------------------

--左方向键上下
function WBP_SquadBuild_Main_P_C:SquadListMoveInGamePadWithDPad(IsUp)
    --DebugPrint("thy   SquadListMoveInGamePadWithDPad", self.CurGamepadArea, self.IsInSortState)
    if self.CurGamepadArea == "SquadListInSort" then
        if self.IsInSortState then
            local Index = IsUp and math.max(self.CurSelectSquadIndex - 1, 1) or math.min(self.CurSelectSquadIndex + 1, self.SquadListLen)
            if Index ~= self.CurSelectSquadIndex then
                self:GetSquadWidgetInSquadList(self.CurSelectSquadIndex):HideAllArrow()
                --self:GetSquadWidgetInSquadList(self.CurSelectSquadIndex):ChangeTwoItemInListView(self.List_Default, self.CurSelectSquadIndex, Index)
                self:PlayAnimation(self.UpdateList)
                self:AddDelayFrameFunc(
                    function()
                        self:GetSquadWidgetInSquadList(self.CurSelectSquadIndex):ChangeTwoItemInListView(self.List_Default, self.CurSelectSquadIndex, Index)
                    end, 5, "DelayChange")
            else
                self:FocusOnSquadListInSortState()
                self:GetSquadWidgetInSquadList(self.CurSelectSquadIndex):CheckArrowState()
            end
        end
    end
    return true
end

--检查聚焦是否在物品栏
function WBP_SquadBuild_Main_P_C:CheckIsInItemList()
    return self.List_Build.List_Select:HasFocusedDescendants() or self.List_Roulette:HasFocusedDescendants()
end

function WBP_SquadBuild_Main_P_C:SwitchAddSquadItemVisibility(bShow)
    if self.SquadListLen == self.SquadMax or self.SquadListLen == 1 then
        return
    end
    for i = 1, self.List_Default:GetNumItems() do
        local Item = self:GetSquadWidgetInSquadList(i)
        if Item then
            if Item.IsAddSquad then
                if bShow then
                    Item:SetVisibility(ESlateVisibility.Visible)
                else
                    Item:SetVisibility(ESlateVisibility.Collapsed)
                end
            else
                Item:SetVisibility(ESlateVisibility.Visible)
            end
        end
    end
end

--手柄监听
function WBP_SquadBuild_Main_P_C:Handle_OnGamePadDown(InKeyName)
    if InKeyName == "Gamepad_FaceButton_Right" then--B
        if self.Pos_Tips:GetChildAt(0) then
            self:CloseTips(true)
            return true
        end
        if self.CurGamepadArea == "ListItem" then--在角色/pet/武器item
            self:FocusOnRightDetailPanel()
            return true
        elseif self.CurGamepadArea == "SlotInView" then--在右边Slot 预览
            self:FocusOnSquadList()
            return true
        elseif self.CurGamepadArea == "SlotInEdit" then--在右边Slot 编辑
            self:CancelCreateSquadAndBackToSquadList()
            return true
        elseif self.CurGamepadArea == "SquadListInSort" and self.IsInSortState then--在预设阵容列表排序
            self.IsInSortState = false
            self:SwitchGamePadIconVisibilityBySortState(true)
            self:SwitchAddSquadItemVisibility(true)
            self:FocusOnSquadList()
            self:GetSquadWidgetInSquadList(self.CurSelectSquadIndex):HideAllArrow()
            return true
        else--在预设阵容列表
            --退出预设阵容
            self:OnBackKeyDown()
            return true
        end
    elseif InKeyName == "Gamepad_FaceButton_Top" then--Y
        --编辑模式下不能创建新增预设
        if self.CurGamepadArea == "SquadList" or self.CurGamepadArea == "SlotInView" then
            self:AddSquad()
        elseif self.CurGamepadArea == "SlotInEdit" then
            self:ClearCurSlot()
        end
        return true
    elseif InKeyName == "Gamepad_FaceButton_Bottom" then--A
        if self.FocusInAddSquad then
            self:AddSquad()
            self.FocusInAddSquad = false
            return true
        end
        if self.CurGamepadArea == "SquadList" then
            self:FocusOnRightDetailPanel()
            return true
        elseif self.CurGamepadArea == "SlotInView" then
            self:FocusOnRightDetailPanel()
            return true
        elseif self.CurGamepadArea == "SlotInEdit" then
            self:FocusOnItemList()
            return true
        end
    elseif InKeyName == "Gamepad_FaceButton_Left" then-- X
        if self.CurGamepadArea == "Tip" then
            if self.CurSlotType == "Pet" then
                self:MakeSureCallback()
            else
                if self.SquadItemTip then
                    self:MakeSureCallback(self.SquadItemTip.Edit_Tips.SelectModIndex)
                end
            end
            return true
        end
        if self.IsPetTipsOpen then
            self.IsPetTipsOpen =false
            return true
        end
        if self.CurGamepadArea == "SquadList" then
            self:EditorSquad()
        elseif self.CurGamepadArea == "SquadList" or self.CurGamepadArea == "SlotInView" then
            if not self.IsInEditor then
                self:EditorSquad()
                return true
            end
        elseif self.CurGamepadArea == "SlotInEdit" then
            self:SaveSquad()
            return true
        end
    elseif InKeyName == "Gamepad_DPad_Up" then --左边上方向键
        if self.IsInCd then
            DebugPrint("thy    IsInCD")
            return true
        else
            self:CreateCDTimer()
        end
        return self:SquadListMoveInGamePadWithDPad(true)
    elseif InKeyName == "Gamepad_DPad_Down" then --左边下方向键
        if self.IsInCd then
            DebugPrint("thy    IsInCD")
            return true
        else
            self:CreateCDTimer()
        end
        return self:SquadListMoveInGamePadWithDPad(false)
    elseif InKeyName == "Gamepad_DPad_Left" then --左边左方向键

        if self.CurGamepadArea == "SquadList" then
            return true
        end
        -- body
    elseif InKeyName == "Gamepad_DPad_Right" then --左边右方向键
        if self.CurGamepadArea == "SquadList" then
            return true
        end
        -- body
    elseif InKeyName == "Gamepad_LeftStick_Right" then --左摇杆右方向键
        if self.CurGamepadArea == "SquadList" then
            return true
        end
        -- body
    elseif InKeyName == "Gamepad_LeftStick_Left" then --左摇杆左方向键
        if self.CurGamepadArea == "SquadList" then
            return true
        end
        return true
    elseif InKeyName == "Gamepad_LeftStick_Up" then --左摇杆上方向键
        if self.IsInCd and self.IsInSortState then
            DebugPrint("thy    IsInCD")
            return true
        else
            self:CreateCDTimer()
        end
        return self:SquadListMoveInGamePadWithDPad(true)
    elseif InKeyName == "Gamepad_LeftStick_Down" then --左摇杆下方向键
        if self.IsInCd and self.IsInSortState then
            DebugPrint("thy    IsInCD")
            return true
        else
            self:CreateCDTimer()
        end
        return self:SquadListMoveInGamePadWithDPad(false)
    elseif InKeyName == "Gamepad_Special_Right" then --右边特殊按钮
        if self.Pos_Tips:GetChildAt(0) or UIManager(self):IsHaveMenuAnchorOpen() then
            return true
        end
        if self.CurGamepadArea == "SquadList" or self.CurGamepadArea == "SlotInEdit" or self.CurGamepadArea == "SlotInView" then
            self:EditSquadName()
        end
        return true
    elseif InKeyName == "Gamepad_Special_Left" then --左边特殊按钮
        if self.Panel_Roulette:IsVisible() or self.Panel_Tips:IsVisible() then
            self:GoToArmory()
        end
        return true
    elseif InKeyName == "Gamepad_RightThumbstick" then --右边摇杆按下
        if self.Pos_Tips:GetChildAt(0) or UIManager(self):IsHaveMenuAnchorOpen() then
            return
        end
        if self.CurGamepadArea == "SquadList" or self.CurGamepadArea == "SlotInView" then
            self:DeleteSquad()
        end
        return true
    elseif InKeyName == "Gamepad_LeftThumbstick" then --左边摇杆按下
        if self.Pos_Tips:GetChildAt(0) or UIManager(self):IsHaveMenuAnchorOpen() then
            return true
        end
        if self.CurGamepadArea == "SquadListInSort" then
            if self.IsInSortState then
                self.IsInSortState = false
                self:InitBottomTab(true, 2)
                self:SwitchGamePadIconVisibilityBySortState(true)
                self:SwitchAddSquadItemVisibility(true)
                self:GetSquadWidgetInSquadList(self.CurSelectSquadIndex):HideAllArrow()
                self:FocusOnSquadList()
            end
        elseif self.CurGamepadArea == "SquadList" and self.SquadListLen > 1 then
            self.IsInSortState = true
            self:InitBottomTabOnSortStateInGamePad()
            self:SwitchGamePadIconVisibilityBySortState(false)
            self:SwitchAddSquadItemVisibility(false)
            self:GetSquadWidgetInSquadList(self.CurSelectSquadIndex):CheckArrowState()
            self:FocusOnSquadListInSortState()
        end
        return true
    elseif (InKeyName == "Gamepad_LeftTrigger") then --左触发后键
        if self.CurSlot.IsPhantomWeapon then
            if self.CurPhantomWeaponType ~= "Melee" then
                self:PhantomWeaponTypeChanged("Melee")
            end
            return true
        end
    elseif (InKeyName == "Gamepad_RightTrigger") then -- 右触发后键
        if self.CurSlot.IsPhantomWeapon then
            if self.CurPhantomWeaponType ~= "Ranged" then
                self:PhantomWeaponTypeChanged("Ranged")
            end
            return true
        end
    end
    return false
end

--根据左摇杆的轴体偏移确定左摇杆的位置
function WBP_SquadBuild_Main_P_C:CheckLeftStickKeyName()
    local InKeyName = nil
    if self.MoveDeltaX and self.MoveDeltaX ~= 0 then
        if self.MoveDeltaX > 0.5 then
            InKeyName = "Gamepad_LeftStick_Right"
        elseif self.MoveDeltaX < -0.5 then
            InKeyName = "Gamepad_LeftStick_Left"
        end
    end
    if not InKeyName and self.MoveDeltaY and self.MoveDeltaY ~= 0 then
        if self.MoveDeltaY > 0.5 then
            InKeyName = "Gamepad_LeftStick_Up"
        elseif self.MoveDeltaY < -0.5 then
            InKeyName = "Gamepad_LeftStick_Down"
        end
    end
    return InKeyName
end

--监听左摇杆的轴体偏移
function WBP_SquadBuild_Main_P_C:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    self.MoveDeltaX = 0
    self.MoveDeltaY = 0
    if(InKeyName == "Gamepad_LeftX")then
        self.MoveDeltaX = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
    elseif(InKeyName == "Gamepad_LeftY")then
        self.MoveDeltaY = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
    end
    self:Handle_OnGamePadDown(self:CheckLeftStickKeyName())
    return self.Unhandle
end

--监听PC/手柄按键
function WBP_SquadBuild_Main_P_C:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:Handle_OnGamePadDown(InKeyName)
    else
        IsEventHandled = self:Handle_OnPCDown(InKeyName) 
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

function WBP_SquadBuild_Main_P_C:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if InKeyName == "Gamepad_DPad_Up" then --左边上方向键
            if self.IsInCd then
                return
            else
                self:CreateCDTimer()
            end

            return self:SquadListMoveInGamePadWithDPad(true)
        elseif InKeyName == "Gamepad_DPad_Down" then --左边下方向键
            if self.IsInCd then
                return
            else
                self:CreateCDTimer()
            end

            return self:SquadListMoveInGamePadWithDPad(false)
        end
    end
    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function WBP_SquadBuild_Main_P_C:CreateCDTimer()
    self.IsInCd = true
    self.CdTime = 1
    self:AddTimer(0.1, function()
        self.CdTime = self.CdTime - 0.1
        if self.CdTime < 0 then
            self.IsInCd = false
            self:RemoveTimer("CD")
        end
    end, true, 0, "CD", true)
end

function WBP_SquadBuild_Main_P_C:OnFocusReceived(MyGeometry, InFocusEvent)
    self:AddDelayFrameFunc(
        function()
            if self.IsInEditor then
                self:FocusOnRightDetailPanel()
            else
                self:FocusOnSquadList()
            end
        end, 3, "DelayFocusSquadList")
    return true
end

function WBP_SquadBuild_Main_P_C:ReceiveEnterState(StackAction)
    self.Super.ReceiveEnterState(self, StackAction)
    if self.IsInEditor then
        if self.CurSlot and self.CurSlot.Type ~= "Roulette" and self.CurType then
            self:InitLeftListItemInfo()
            self:SwitchToSelectItemList(self.CurSlot, self.CurType)
        else
            local RouletteParams = {
                Id = self.Roulette.Id or 1,
                Type = "Roulette",
                Owner = self,
            }
            self.Roulette:InitSlot(RouletteParams)
            self:SwitchToRouletteList()
        end
    end
end

--------------------------------------------手柄/监听相关End----------------------------------------

AssembleComponents(WBP_SquadBuild_Main_P_C)

return WBP_SquadBuild_Main_P_C
