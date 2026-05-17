--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
local TimeUtils = require "Utils.TimeUtils"
local EMCache = require "EMCache.EMCache"
local UIUtils = require "Utils.UIUtils"
local TeamSelectComponent = require "BluePrints.UI.UI_PC.Common.TeamSelectComponent"

---@type WBP_Activity_Wuyousheng_TeamBuild_P_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

local NullUUid = CommonConst.AbyssTeamNoChar
local NullUnitId = CommonConst.AbyssTeamNoPet

M._components = {
    "BluePrints.UI.UI_PC.Common.TeamSelectComponent",
    "BluePrints.UI.WBP.Activity.Widget.Wuyousheng.WBP_Activity_Wuyousheng_TeamBuild_GamepadComp",
}

-- 使用Component的枚举和映射（在AssembleComponents之后会自动混入方法）
M.ESlotName = TeamSelectComponent.ESlotName
M.SlotName2Type = TeamSelectComponent.SlotName2Type
M.SlotType2DataType = TeamSelectComponent.SlotType2DataType

-- 槽位顺序（用于Mod界面跳转）
local SlotOrder = {
    [1] = "Char", 
    [2] = "Melee", 
    [3] = "Ranged",
    [4] = "Phantom1", 
    [5] = "PhantomWeapon1", 
    [6] = "Phantom2", 
    [7] = "PhantomWeapon2"
}

function M:Construct()
    self.List_Select.OnCreateEmptyContent:Unbind()
    self.List_Select.OnCreateEmptyContent:Bind(self, function(self)
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        Obj.IsEmpty = true
        return Obj
    end)

    self.Platform = CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance)
    
    -- 初始化武器类型Tab
    self.TypeTabs = {
        [self.SlotName2Type[self.ESlotName.RangedWeapon]] = self.Type_Range,
        [self.SlotName2Type[self.ESlotName.MeleeWeapon]] = self.Type_Melee
    }
    self.Type_Range:Init(self.SlotName2Type[self.ESlotName.RangedWeapon], self)
    self.Type_Melee:Init(self.SlotName2Type[self.ESlotName.MeleeWeapon], self)
    self.Tab_Primary:SetVisibility(UE4.ESlateVisibility.Collapsed)

    -- 初始化物品详情Widget
    self:InitItemDetailWidget()
    
    -- 构建槽位映射表
    local Slots = {
        [self.ESlotName.Char] = self.Character,
        [self.ESlotName.MeleeWeapon] = self.Melee,
        [self.ESlotName.RangedWeapon] = self.Ranged,
        [self.ESlotName.Pet] = self.Pet,
        [self.ESlotName.Phantom1] = self.Head_Phantom01,
        [self.ESlotName.PhantomWeapon1] = self.Weapon_Phantom01,
        [self.ESlotName.Phantom2] = self.Head_Phantom02,
        [self.ESlotName.PhantomWeapon2] = self.Weapon_Phantom02,
    }
    
    -- 初始化TeamSelectComponent（试用数据在Enter时设置）
    self:InitTeamSelect(Slots, self.List_Select, self.Sort, self.EMListView_Filter, self.ItemDetailsWidget, self.Pos_Tip, nil)

    self.Btn_Clear.Text_Btn:SetText(GText("ModFilter_ClearAll"))
    self.Btn_Clear.Btn_Click.OnClicked:Add(self, self.OnClearClicked)
    self.Btn_Clear.Btn_Click.OnPressed:Add(self, self.OnClearPressed)

    self.Btn_SwitchMod.Text_Btn:SetText(GText("UI_SHOP_SUBTAB_NAME_MOD"))
    self.Btn_SwitchMod.Btn_Click.OnClicked:Add(self, self.OnSwitchModClicked)
    self.Btn_SwitchMod.Btn_Click.OnPressed:Add(self, self.OnSwitchModPressed)

    self.Btn_Save.Text_Btn:SetText(GText("UI_WuyoushengEvent_GoToDungeon"))
    self.Btn_Save.Btn_Click.OnClicked:Add(self, self.OnSaveClicked)
    self.Btn_Save.Btn_Click.OnPressed:Add(self, self.OnSavePressed)

    self.Btn_Click.OnClicked:Add(self, self.OnBackgroundClicked)
    self.Btn_Click:SetTouchMethod(UE4.EButtonTouchMethod.Down)

    self.Text_DescTitle:SetText(GText("UI_WuyoushengEvent_LevelBuff"))
    self.Text_BuildTitle:SetText(GText("UI_WuyoushengEvent_EditTeam"))
    self.Text_ActivitySign:SetText(GText("UI_Wuyousheng_ArmoryEventOnly"))
    self.Text_Phantom01:SetText(GText("UI_STAT_Sigil"))
    self.Text_Phantom02:SetText(GText("UI_STAT_Sigil"))

    self:InitGamePad()
    self:InitNavigation()
    self:InitItemDetailWidget()
    self:AddTimer(0.1, function()
        self:OnUpdateUIStyleByInputTypeChange(self.Root.CurInputDevice, self.Root.CurGamepadName)
    end)
    self.LastCanSave = false
end

function M:OnClearClicked()
    self:ClearAllSlots()
    self:OnLeftItemContentChanged()
end

function M:OnClearPressed()
    if self.Btn_Clear.Btn_Click:GetForbidden() then
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/activity/wuyoudaguai_btn_click_common", nil, nil)
end

function M:OnSwitchModPressed()
    if self.Btn_SwitchMod.Btn_Click:GetForbidden() then
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/activity/wuyoudaguai_btn_click_common", nil, nil)
end

-- 检查阵容状态（抽离的判断逻辑）
function M:CheckTeamStatus()
    local HasAnyItem = false
    local HasAnySelfItem = false
    local Uuids = {}
    local Type = "Null"
    local Tag = nil
    for _, SlotName in ipairs(SlotOrder) do
        local TempSlotName = SlotName
        if TempSlotName == "Melee" then
            TempSlotName = "MeleeWeapon"
        end
        if TempSlotName == "Ranged" then
            TempSlotName = "RangedWeapon"
        end
        local EName = self.ESlotName[TempSlotName]
        local Slot = self.Slots[EName]
        if Slot and not Slot.IsEmpty then
            HasAnyItem = true
            if not Slot.IsTryout then
                HasAnySelfItem = true
                table.insert(Uuids, Slot.Uuid)
                if Type == "Null" then
                    Type = Slot.Type
                    if Type == "Weapon" then
                        Type = Slot.Content.Tag
                    end
                end
                if not Tag then
                    Tag = SlotName
                    if Type == "Melee" or Type == "Ranged" then
                        Tag = Type
                    end
                    if Tag == "Phantom1" or Tag == "Phantom2" then
                        Tag = "Char"
                    end
                end
            end
        end
    end
    return HasAnyItem, HasAnySelfItem, Uuids, Type, Tag
end

function M:OnSwitchModClicked()
    local HasAnyItem, HasAnySelfItem, Uuids, Type, Tag = self:CheckTeamStatus()
    
    if not HasAnyItem then
        -- 阵容为空
        UIManager():ShowUITip(UIConst.Tip_CommonToast, GText("UI_Wuyousheng_Toast_EmptyTeam"))
        return
    end
    
    -- 检查是否有至少一个玩家自己的角色/武器
    if not HasAnySelfItem then
        -- 阵容中全部是试用角色/武器
        UIManager():ShowUITip(UIConst.Tip_CommonToast, GText("UI_Wuyousheng_Toast_BanTrialModEdit"))
        return
    end

    local FakeReplaceChar = {BattleData = function() return{} end}
    local ModUI = ModController:OpenView(ModCommon.WuyoushengMod, Type, Tag, Uuids, nil,
                            {Func=self.OnModClosed,Obj=self},
                            ModCommon.MainUICase.Normal, FakeReplaceChar)
end

-- 获取指定槽位的Mod类型
function M:GetModType(SlotName)
    return self.SlotType2DataType[self.SlotName2Type[SlotName]]
end

-- Mod界面关闭时的回调
function M:OnModClosed(...)
    -- Mod界面关闭后的处理逻辑（如果需要）
    -- 例如：恢复焦点、刷新UI等
end

function M:InitWidget()
    self.bInList = false

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        DebugPrint("jly@阵容配置界面Avatar获取失败")
        return
    end

    -- 调用Component的InitWidget（会自动初始化各个MainComponent的Widget）
    TeamSelectComponent.InitWidget(self)
end

-- 获取当前阵容数据（与 SquadBuildComponent 一致）
-- 返回：Squad[SlotName] = { Id, bTrial, ModIndex? }，SlotName 为 Char/MeleeWeapon/RangedWeapon/Phantom1/PhantomWeapon1/Phantom2/PhantomWeapon2/Pet
function M:GetCurrentSquad()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return nil
    end

    local Squad = {}

    -- ESlotName 枚举值到 SlotName 字符串的映射
    local ENameToSlotName = {}
    for SlotName, EName in pairs(self.ESlotName) do
        if type(EName) == "number" then
            ENameToSlotName[EName] = SlotName
        end
    end

    if self.Slots then
        for EName, Slot in pairs(self.Slots) do
            if not Slot or Slot.IsEmpty then
                goto continue
            end

            local SlotName = ENameToSlotName[EName]
            if not SlotName then
                goto continue
            end

            local SlotInfo = {}
            local IsTryout = Slot.IsTryout or false
            local SlotType = self.SlotName2Type[EName]
            local DataType = self.SlotType2DataType[SlotType]

            if IsTryout then
                SlotInfo.Id = Slot.UnitId
                SlotInfo.bTrial = true
            else
                if not Slot.Uuid then
                    goto continue
                end
                SlotInfo.Id = Slot.Uuid
                SlotInfo.bTrial = false

                -- 非试用：ModIndex 从 Avatar 上对应单位的 ModSuitIndex 读取，而不是 UI Content
                if DataType == "Char" then
                    local Char = Avatar.Chars[Slot.Uuid]
                    if Char and Char.ModSuitIndex then
                        SlotInfo.ModIndex = Char.ModSuitIndex
                    end
                elseif DataType == "Weapon" then
                    local Weapon = Avatar.Weapons[Slot.Uuid]
                    if Weapon and Weapon.ModSuitIndex then
                        SlotInfo.ModIndex = Weapon.ModSuitIndex
                    end
                elseif DataType == "Pet" then
                    local Pet = Avatar.Pets[Slot.Uuid]
                    if Pet and Pet.ModSuitIndex then
                        SlotInfo.ModIndex = Pet.ModSuitIndex
                    end
                end
            end

            Squad[SlotName] = SlotInfo
            ::continue::
        end
    end

    return Squad
end

-- 深度比较两个table是否相等（忽略键的顺序）
local function DeepEqualTable(t1, t2, visited)
    visited = visited or {}
    
    -- 如果两个引用相同，直接返回true
    if t1 == t2 then
        return true
    end
    
    -- 检查基本类型
    local type1 = type(t1)
    local type2 = type(t2)
    if type1 ~= type2 then
        return false
    end
    
    if type1 ~= "table" then
        return t1 == t2
    end
    
    -- 防止循环引用：使用组合键来标记已访问的table对
    local key1 = tostring(t1)
    local key2 = tostring(t2)
    local visitKey = key1 .. "|" .. key2
    if visited[visitKey] then
        return true
    end
    visited[visitKey] = true
    
    -- 统计两个table的键数量
    local count1 = 0
    local count2 = 0
    for _ in pairs(t1) do
        count1 = count1 + 1
    end
    for _ in pairs(t2) do
        count2 = count2 + 1
    end
    
    -- 键数量不同，肯定不相等
    if count1 ~= count2 then
        return false
    end
    
    -- 遍历t1的所有键值对，检查t2中是否有对应的值
    for k, v1 in pairs(t1) do
        local v2 = t2[k]
        if v2 == nil then
            return false
        end
        
        -- 递归比较值
        if type(v1) == "table" and type(v2) == "table" then
            if not DeepEqualTable(v1, v2, visited) then
                return false
            end
        else
            if v1 ~= v2 then
                return false
            end
        end
    end
    
    return true
end

-- 检查 Squad 是否为空（新格式：扁平表，无 key 即为空）
local function IsSquadEmpty(Squad)
    if not Squad then
        return true
    end
    for _ in pairs(Squad) do
        return false
    end
    return true
end

-- 比较两个Squad是否相等（忽略键的顺序）
function M:IsSquadEqual(Squad1, Squad2)
    -- 如果两个都是 nil，相等
    if not Squad1 and not Squad2 then
        return true
    end
    
    -- 如果一个是 nil，另一个是空 Squad，也认为相等
    if not Squad1 then
        return IsSquadEmpty(Squad2)
    end
    
    if not Squad2 then
        return IsSquadEmpty(Squad1)
    end
    
    -- 使用深度比较
    return DeepEqualTable(Squad1, Squad2)
end

-- 保存阵容到服务器
function M:SaveSquadToServer(Callback)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        if Callback then
            Callback(false)
        end
        return
    end
    
    local EventId = self.Root and self.Root.EventId
    if not EventId then
        DebugPrint("WBP_Activity_Wuyousheng_TeamBuild_C:SaveSquadToServer - EventId无效")
        if Callback then
            Callback(false)
        end
        return
    end
    
    local CurrentSquad = self:GetCurrentSquad()
    
    local function OnSaveCallback(ErrCode, Ret)
        if ErrCode == 0 then
            -- 保存成功，更新初始阵容
            self.InitialSquad = CurrentSquad
            DebugPrint("WBP_Activity_Wuyousheng_TeamBuild_C:SaveSquadToServer - 保存成功")
        else
            DebugPrint("WBP_Activity_Wuyousheng_TeamBuild_C:SaveSquadToServer - 保存失败", ErrorCode:Name(ErrCode))
        end
        
        if Callback then
            Callback(ErrCode == 0)
        end
    end
    
    Avatar:WuyoushengSetSquad(EventId, self.DungeonId, CurrentSquad, OnSaveCallback)
end

function M:InitDetailPanels()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        DebugPrint("M:InitDetailPanels, 配置面板初始化失败，Avatar无效")
        return
    end
    
    -- 如果 TeamInfos（新格式：Squad 扁平表）为 nil，清空所有槽位
    if not self.TeamInfos then
        self:ClearAllSlots()
        return
    end

    local Squad = self.TeamInfos

    -- 按新结构处理槽位：Squad[SlotName] = { Id, bTrial, ModIndex? }
    for SlotName, EName in pairs(self.ESlotName) do
        local SlotInfo = Squad[SlotName]
        if not SlotInfo or not SlotInfo.Id then
            goto continue
        end

        local Id = SlotInfo.Id
        local IsTryout = SlotInfo.bTrial or false

        local SlotType = self.SlotName2Type[EName]
        local DataType = self.SlotType2DataType[SlotType]
        local Content = nil
        if SlotName == "Char" or SlotName == "Phantom1" or SlotName == "Phantom2" then
            Content = self.CharItemContentsMap[Id]
        elseif SlotName == "MeleeWeapon" or SlotName == "RangedWeapon" or
                SlotName == "PhantomWeapon1" or SlotName == "PhantomWeapon2" then
            local WeaponTag = (SlotName == "RangedWeapon") and CommonConst.ArmoryTag.Ranged or CommonConst.ArmoryTag.Melee
            Content = self[WeaponTag.."ItemContentsMap"][Id]
            if Content == nil then
                Content = self.RangedItemContentsMap[Id]
            end
        elseif SlotName == "Pet" then
            Content = self.PetItemContentsMap[Id]
        end

        if not IsTryout then
            local Unit = Avatar[DataType.."s"][Id]
            if not Unit then
                GWorld.logger.error("M:InitDetailPanels@该Id对应的物品已失效"..CommonUtils.ObjId2Str(Id))
                goto continue
            end
        end

        if Content then
            if SlotInfo.ModIndex then
                Content.ModSuitIndex = SlotInfo.ModIndex
            end
            self:UpdateSlot(EName, Content)
        end

        ::continue::
    end
end

-- 当配置槽被点击时（由槽位Widget调用）
function M:SlotSelectionChanged(SlotName, DungeonIndex, bToList)
    -- 直接调用Component的OnSlotClicked方法
    self:OnSlotClicked(SlotName)
end

function M:OnReturnKeyDown()
    if self.Root then
        self.Root:OpenSubUI(self.PreWidgetInfo, true)
    end
end

function M:SwitchIn(...)
    self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self:PlayAnimation(self.In)
    self:InitTable()
    local DungeonId = ...
    self:AddTimer(0.1, function()
        self:Enter(DungeonId)
    end)
    self.Root.RewardText:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:Enter(DungeonId)
    self.DungeonId = DungeonId
    
    -- 获取EventId
    local EventId = self.Root and self.Root.EventId
    if not EventId then
        DebugPrint("WBP_Activity_Wuyousheng_TeamBuild_C:Enter - EventId无效")
    end

    if not self.DungeonId then
        DebugPrint("WBP_Activity_Wuyousheng_TeamBuild_C:Enter - DungeonId无效")
    end
    
    -- 获取保存的阵容数据
    local SavedSquad = nil
    if DungeonId and EventId then
        local Avatar = GWorld:GetAvatar()
        if Avatar and Avatar.WuyoushengActivity then
            local WuyoushengData = Avatar.WuyoushengActivity[EventId]
            if WuyoushengData then
                SavedSquad = WuyoushengData:GetSquadInfo(DungeonId)
            end
        end
    end
    
    -- 直接使用保存的阵容
    self.TeamInfos = SavedSquad
    
    -- 保存初始阵容用于对比
    self.InitialSquad = SavedSquad
    
    self:InitWidget()
    
    -- 获取试用数据（如果有DungeonId）
    local TrialData = nil
    local LevelConfig = DataMgr.WuyoushengEventLevel[DungeonId]
    if LevelConfig then
        TrialData = {
            TrialChars = LevelConfig.LevelTrialChar or {},
            TrialMeleeWeapons = LevelConfig.LevelTrialMeleeWeapon or {},
            TrialRangedWeapons = LevelConfig.LevelTriaRangedlWeapon or {},
            TrialPets = LevelConfig.LevelPet or {},
            -- 配置是否显示玩家拥有的物品
            ShowOwned = {
                Chars = true,      -- 显示玩家拥有的角色 + 试用角色
                Weapons = true,    -- 显示玩家拥有的武器 + 试用武器
                Pets = false,      -- 只显示试用宠物，不显示玩家拥有的宠物
            }
        }
        if LevelConfig.LevelBuffDes then
            self.Text_LevelDesc:SetText(GText(LevelConfig.LevelBuffDes))
        end
    end
    
    -- 更新Component的试用数据（在InitWidget之后）
    if TrialData then
        self.TrialData = TrialData
        self:CharMain_Init()
        self.WeaponTag = CommonConst.ArmoryTag.Melee
        self:WeaponMain_Init()
        self.WeaponTag = CommonConst.ArmoryTag.Ranged
        self:WeaponMain_Init()
        self:PetMain_Init()
    end
    
    -- 初始化详情面板（如果TeamInfos为nil会自动清空槽位）
    self:InitDetailPanels()

    -- 默认选中角色配置槽
    local SelectedSlot = self.ESlotName.Char
    self:OnSlotClicked(SelectedSlot)
    
    -- 初始化按钮置灰状态
    self:OnLeftItemContentChanged()
end

function M:SwitchOut()
    -- 检查阵容是否改变
    local CurrentSquad = self:GetCurrentSquad()
    local SquadChanged = not self:IsSquadEqual(self.InitialSquad, CurrentSquad)
    
    if SquadChanged then
        -- 阵容已改变，显示保存确认弹窗
        local Params = {
            ShortText = GText("UI_CommonPopup_SaveLayout_Content"),
            LeftCallbackObj = self,
            LeftCallbackFunction = function(Obj)
                -- 取消保存，直接关闭
                Obj:DoSwitchOut()
            end,
            RightCallbackObj = self,
            RightCallbackFunction = function(Obj)
                -- 确认保存
                Obj:SaveSquadToServer(function(Success)
                    Obj:DoSwitchOut()
                end)
            end,
            CloseBtnCallbackObj = self,
            CloseBtnCallbackFunction = function(Obj)
                -- 关闭按钮等同于取消
                Obj:DoSwitchOut()
            end
        }
        local PopupUI = UIManager(self):ShowCommonPopupUI(100160, Params)
        if PopupUI then
            self:AddTimer(0.1, function()
                PopupUI:SetFocus()
            end)
        end
    else
        -- 阵容未改变，直接关闭
        self:DoSwitchOut()
    end
end

-- 执行关闭操作
function M:DoSwitchOut()
    if not self.BindOutAnimation then
        self:BindToAnimationFinished(self.Out, {self,function()
            self:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        })
        self.BindOutAnimation = true
    end
    self:PlayAnimation(self.Out)
    -- 清空所有槽位
    self:ClearAllSlots()
end

function M:InitTable()
    self.TabConfigData = {
        TitleName= GText("UI_Title_WuyoushengEvent"),
        DynamicNode={"Back", "BottomKey", "ResourceBar"}, 
        StyleName="Text", OwnerPanel=self.Root, BackCallback=self.Root.OnReturnKeyDown,
        BottomKeyInfo = { { KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.Root.OnReturnKeyDown, Owner=self.Root,}}, GamePadInfoList = {{Type="Img", ImgShortPath="B"}}, Desc = GText("UI_BACK"), bLongPress = false}},
    }
    self.Root:InitOtherPageTab(self.TabConfigData, nil, true)
end

function M:UpdateListSelect(SlotName)
    if SlotName == 8 then
        self.Group_ActivitySign:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Tab_Sub:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        self.Group_ActivitySign:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Tab_Sub:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
end


function M:OnSaveClicked()
    if not self:CheckTeamCondition() then
        UIManager():ShowUITip(UIConst.Tip_CommonToast, GText("UI_Wuyousheng_Toast_NotMeetBattleRequirement"))
        return
    end
    local Callback = function(Ret)
        if Ret == ErrorCode.RET_SUCCESS then
            -- 进副本前缓存相关信息，用于退出副本时弹出此界面
            local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
            local CurTabIndex = 1
            if ActivityMain then
                CurTabIndex = ActivityMain.CurTabId
            end
            local ExitDungeonInfo = {
                Type = "MonsterRush",
                EventId = self.Root.EventId,
                CurTabIndex = CurTabIndex,
                DungeonId = self.DungeonId,
            }
            GWorld.GameInstance:SetExitDungeonData(ExitDungeonInfo)
        end
    end
    self:SaveSquadToServer(function(Success)
        if Success then
            local Avatar = GWorld:GetAvatar()
            if Avatar then
                Avatar:EnterEventDungeon(Callback,self.DungeonId,nil,self.Root.EventId,nil)
            end
        else
            UIManager():ShowUITip(UIConst.Tip_CommonToast, GText("UI_Wuyousheng_Toast_SaveFailed"))
        end
    end)
end

function M:OnSavePressed()
    if self.Btn_Save.Btn_Click:GetForbidden() then
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/activity/wuyoudaguai_btn_click_enter_game", nil, nil)
end

function M:CheckTeamCondition()
    if self.Slots[self.ESlotName.Char] and self.Slots[self.ESlotName.Char].IsEmpty then
        return false
    end
    if self.Slots[self.ESlotName.MeleeWeapon] and self.Slots[self.ESlotName.MeleeWeapon].IsEmpty then
        return false
    end
    if self.Slots[self.ESlotName.RangedWeapon] and self.Slots[self.ESlotName.RangedWeapon].IsEmpty then
        return false
    end
    if self.Slots[self.ESlotName.Pet] and self.Slots[self.ESlotName.Pet].IsEmpty then
        return false
    end
    local isEmptyPhantom1 = self.Slots[self.ESlotName.Phantom1].IsEmpty
    local isEmptyPhantomWeapon1 = self.Slots[self.ESlotName.PhantomWeapon1].IsEmpty
    local isEmptyPhantom2 = self.Slots[self.ESlotName.Phantom2].IsEmpty
    local isEmptyPhantomWeapon2 = self.Slots[self.ESlotName.PhantomWeapon2].IsEmpty
    if isEmptyPhantom1 ~= isEmptyPhantomWeapon1 or isEmptyPhantom2 ~= isEmptyPhantomWeapon2 then
        return false
    end
    return true
end

function M:GetZOrder()
    return self.Root:GetZOrder()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = true

    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsHandled = self:HandleGamepadInput(InKeyName)
    else
        if (InKeyName == "Escape") then
            self:OnReturnKeyDown()
        elseif InKeyName == "Q" and self.IsTabPrimaryVisible then
            self.Type_Melee:OnBtnClicked()
            IsHandled = true
        elseif InKeyName == "E"and self.IsTabPrimaryVisible then
            self.Type_Range:OnBtnClicked()
            IsHandled = true
        else
            IsHandled = false
        end
    end
    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnLeftItemContentChanged()
    -- 更新三个按钮的置灰状态
    
    -- Btn_Clear: 有东西就不置灰，否则置灰
    local HasAnyItem = false
    if self.Slots then
        for EName, Slot in pairs(self.Slots) do
            if Slot and not Slot.IsEmpty then
                HasAnyItem = true
                break
            end
        end
    end
    self.Btn_Clear.Btn_Click:SetForbidden(not HasAnyItem)
    
    -- Btn_SwitchMod: 使用抽离的判断逻辑
    local HasAnyItemForMod, HasAnySelfItem = self:CheckTeamStatus()
    self.Btn_SwitchMod.Btn_Click:SetForbidden(not HasAnyItemForMod or not HasAnySelfItem)
    
    -- Btn_Save: 使用CheckTeamCondition判断，置灰应该用SetForbidden
    local CanSave = self:CheckTeamCondition()
    self.Btn_Save.Btn_Click:SetForbidden(not CanSave)
    if self.LastCanSave ~= CanSave then
        self.LastCanSave = CanSave
        if CanSave then
            self.Btn_Save:PlayAnimation(self.Btn_Save.Remind)
        end
    end
end

function M:OnBackgroundClicked()
    if self.bItemDetailsShowed then
        self:ShowItemDetails(false)
    end
end

AssembleComponents(M)

return M
