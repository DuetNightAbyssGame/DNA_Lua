--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_SoloTreasure_Prepare_P_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

local NullUUid = CommonConst.AbyssTeamNoChar
local NullUnitId = CommonConst.AbyssTeamNoPet

local SquadBuildComponent = require "BluePrints.UI.UI_PC.Common.SquadBuildComponent"
local SoloTreasureUtils = require "BluePrints.UI.WBP.SoloTreasure.Widget.SoloTreasureUtils"
local ActorController = require "BluePrints.UI.WBP.Armory.ActorController.Armory_ActorController"
local EMCache = require "EMCache.EMCache"
local TimeUtils = require "Utils.TimeUtils"
local CommonUtils = require "Utils.CommonUtils"
M._components = {
    "BluePrints.UI.UI_PC.Common.SquadBuildComponent",
    "BluePrints.UI.WBP.Activity.Widget.SoloTreasure.WBP_Activity_SoloTreasure_Prepare_GamepadComp",
}

-- 使用Component的枚举和映射（在AssembleComponents之后会自动混入方法）
M.ESlotName = SquadBuildComponent.ESlotName
M.SlotName2Type = SquadBuildComponent.SlotName2Type
M.SlotNameOrder = SquadBuildComponent.SlotNameOrder
M.SlotType2DataType = SquadBuildComponent.SlotType2DataType

-- UI类型枚举
M.EUIType = {
    Listing = 1,  -- 列表视图（选择角色/武器/宠物）
    Bag = 2,      -- 背包视图
}

-- 副本类型枚举
M.EDungeonType = {
    Repeat = 1, -- 复刷关卡
    Story = 2,   -- 剧情关卡
}

-- 缓存Key
local EnterDungeonDontRemindTimeStamp = "SoloTreasure_EnterDungeon_DontRemind_TimeStamp"

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
    self.Listing.TileView_Select_Role.OnCreateEmptyContent:Unbind()
    self.Listing.TileView_Select_Role.OnCreateEmptyContent:Bind(self, function(self)
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        Obj.IsEmpty = true
        return Obj
    end)

    self.Platform = CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance)
    
    -- 构建槽位映射表
    local Slots = {
        [self.ESlotName.Char] = self.Build.Character,
        [self.ESlotName.MeleeWeapon] = self.Build.Melee,
        [self.ESlotName.RangedWeapon] = self.Build.Ranged,
        [self.ESlotName.Pet] = self.Build.Pet,
        [self.ESlotName.Phantom1] = self.Build.Head_Phantom01,
        [self.ESlotName.PhantomWeapon1] = self.Build.Weapon_Phantom01,
        [self.ESlotName.Phantom2] = self.Build.Head_Phantom02,
        [self.ESlotName.PhantomWeapon2] = self.Build.Weapon_Phantom02,
    }
    
    -- 初始化SquadBuildComponent（试用数据在Enter时设置）
    self:InitSquadBuildWidget(Slots, self.Listing.TileView_Select_Role, self.Listing.Sort, self.Listing.EMListView_Filter, self.Pos_Tip, self.Listing.Tab_Primary, self.Listing.Empty, self.Listing.Text_Empty, self.Listing.Type_Range, self.Listing.Type_Melee, self, self.Listing.Panel_FilterTab)
    self:InitSquadBuildData(nil)
    self.Build.Bag.Btn_Click.OnClicked:Add(self, self.OnBagClicked)
    self:InitTextMap()
    self.Btn_Clear.Btn_Click.OnClicked:Add(self, self.OnClearClicked)
    self.Btn_Clear.Btn_Click.OnPressed:Add(self, self.OnClearPressed)
    self.Btn_Start.Btn_Click.OnClicked:Add(self, self.OnStartClicked)
    self.Btn_Start.Btn_Click.OnPressed:Add(self, self.OnStartPressed)
    self.Preview.Btn_Bag.Btn_Click.OnClicked:Add(self, self.OnPreviewBagClicked)
    self:InitGamePad()
    self:InitNavigation()


    self.List_Bag.OnCreateEmptyContent:Bind(self, function()
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        Obj.IsEmpty = true
        return Obj
    end)

    -- 积分ID
    self.SoloTreasureCurrentId = DataMgr.GlobalConstant["SoloTreasureCurrent"].ConstantValue
    self.SoloTreasureTicketResourceId = DataMgr.GlobalConstant["SoloTreasureTicketResourceId"].ConstantValue
    self.SoloTreasureTicketShopId = DataMgr.GlobalConstant["SoloTreasureTicketShopId"].ConstantValue
end

function M:Destruct()
    self.List_Bag.OnCreateEmptyContent:Unbind()
end

function M:InitTextMap()
    local BuildWidget = self.Build
    BuildWidget.Text_CostDesc:SetText(GText("UI_SoloTreasureEvent_EntryCost"))
    BuildWidget.Text_BagCostDesc:SetText(GText("UI_SoloTreasureEvent_BagCost"))
    BuildWidget.Text_Total:SetText(GText("UI_SoloTreasureEvent_TotalCost"))
    BuildWidget.Text_Tip:SetText(GText("UI_SoloTreasureEvent_NoReturnTips"))
    self.Btn_Clear.Text_Button:SetText(GText("UI_SoloTreasureEvent_CleanUpSet"))
    self.Btn_Start.Text_Button:SetText(GText("UI_SoloTreasureEvent_EntryDungeon"))
    self.Build.Text_Character:SetText(GText("UI_Armory_Char"))
    self.Build.Text_Phantom:SetText(GText("UI_Shadow_Name"))
    self.Preview.Text_Tips:SetText(GText("UI_SoloTreasure_BagLocked"))
end

function M:SwitchIn(...)
    self.Build.Bag:PlayAnimation(self.Build.Bag.Normal)
    self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self:PlayAnimation(self.In)
    self:InitTable()
    self.DungeonType, self.DungeonId, self.IsHardMode = ...
    if self.IsHardMode == nil then
        self.IsHardMode = false
    end
    self:CreateActorController()
    self:Enter(self.DungeonType,self.DungeonId,self.IsHardMode)
    self:SwitchUIType(self.EUIType.Listing)
    self:AddTimer(0.1, function()
        self:SetDefaultFocus()
    end)
    self:OnUpdateUIStyleByInputTypeChange(self.Root.GameInputModeSubsystem:GetCurrentInputType(), self.Root.GameInputModeSubsystem:GetCurrentGamepadName())
end

-- 支持回调的SwitchOut（用于等待异步操作完成）
function M:SwitchOutWithCallback(Callback, ...)
    -- 保存回调
    self.SwitchOutCallback = Callback
    
    -- 检查阵容是否改变
    local CurrentSquad = self:GetCurrentSquad()
    CurrentSquad.BagIndex = self.ChooseBagContent.Index
    local SquadChanged = not self:IsSquadEqual(self.TeamInfos, CurrentSquad)
    
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
        }
        local PopupUI = UIManager(self):ShowCommonPopupUI(100323, Params)
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
        DebugPrint("WBP_Activity_SoloTreasure_Prepare_C:SaveSquadToServer - EventId无效")
        if Callback then
            Callback(false)
        end
        return
    end
    
    local CurrentSquad = self:GetCurrentSquad()
    if not CurrentSquad then
        DebugPrint("WBP_Activity_SoloTreasure_Prepare_C:SaveSquadToServer - 阵容数据无效")
        if Callback then
            Callback(false)
        end
        return
    end
    CurrentSquad.BagIndex = self.ChooseBagContent.Index
    Avatar:SetTreasureHuntSquad(EventId, self.DungeonId, CurrentSquad, self.IsHardMode, Callback)
end

-- 执行关闭操作
function M:DoSwitchOut()
    if not self.BindOutAnimation then
        self:BindToAnimationFinished(self.Out, {self,function()
            self:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self:DestroyActorController()
            -- 如果有回调，执行回调
            if self.SwitchOutCallback then
                local Callback = self.SwitchOutCallback
                self.SwitchOutCallback = nil
                Callback()
            end
        end
        })
        self.BindOutAnimation = true
    end
    self:PlayAnimation(self.Out)
    -- 清空所有槽位
    self:ClearAllSlots()
    self.LastSelectedBagItemUIIndex = nil
end

function M:InitTable()
    self.TabConfigData = {
        OverridenTopResouces = {self.SoloTreasureCurrentId, self.SoloTreasureTicketResourceId},
        TitleName= GText("UI_SoloTreasureEvent_ArmorySet"),
        DynamicNode={"Back", "BottomKey", "ResourceBar"}, 
        StyleName="Text", OwnerPanel=self.Root, BackCallback=self.Root.OnReturnKeyDown,
        BottomKeyInfo = { { KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.Root.OnReturnKeyDown, Owner=self.Root,}}, GamePadInfoList = {{Type="Img", ImgShortPath="B"}}, Desc = GText("UI_BACK"), bLongPress = false}},
    }
    self.Root:InitOtherPageTab(self.TabConfigData, nil, true)
end

function M:OnBagClicked()
    local PreSlotName = self.CurSlotName
    if PreSlotName ~= self.ESlotName.Null and self.Slots[PreSlotName] then
        if self.Slots[PreSlotName].SetIsChecked then
            self.Slots[PreSlotName]:SetIsChecked(false)
        end
    end
    self:SwitchUIType(self.EUIType.Bag)
end

function M:UpdateListSelect(SlotName)
    self:SwitchUIType(self.EUIType.Listing)
    if self.IsUseGamePad then
        if self.bListEmpty then
            self:ChangeFocusMode(3)
            self.EMListView_Filter:SetFocus()
        else
            self:ChangeFocusMode(2)
            self:AddTimer(0.1, function()
                DebugPrint("jly@UpdateListSelect")
                self.Listing.TileView_Select_Role:SetFocus()
            end)
        end
    end
end

function M:OnClearClicked()
    if self.Btn_Clear.Btn_Click:GetForbidden() then
        UIManager():ShowUITip(UIConst.Tip_CommonToast, GText("UI_SoloTreasure_ArmoryEmptyComponent"))
        return
    end
    -- 显示清空确认弹窗
    local Params = {
        LeftCallbackObj = self,
        LeftCallbackFunction = function(Obj)
            -- 取消清空
        end,
        RightCallbackObj = self,
        RightCallbackFunction = function(Obj)
            -- 确认清空
            Obj:DoClearSlots()
        end,
        CloseBtnCallbackObj = self,
        CloseBtnCallbackFunction = function(Obj)
            -- 关闭按钮等同于取消
        end
    }
    local PopupUI = UIManager(self):ShowCommonPopupUI(100318, Params)
    if PopupUI then
        self:AddTimer(0.1, function()
            PopupUI:SetFocus()
        end)
    end
end

-- 执行清空操作
function M:DoClearSlots()
    self:ClearAllSlots()
    self:UpdateActionButtonsState()
end

function M:OnStartClicked()
    if self.Btn_Start.Btn_Click:GetForbidden() then
        local CanStart, ErrorMsg = self:CheckCanStart()
        if ErrorMsg == -1 then
            local Params = {}
            Params.RightCallbackFunction = function()
                local ShopItemId = self.SoloTreasureTicketShopId
                local SubTabId = DataMgr.ShopItem[ShopItemId].SubTabId
                local MainTabId = DataMgr.ShopTabSub[SubTabId].MainTabId
                self.List_Bag:ClearListItems()
                PageJumpUtils:JumpToShopPage(MainTabId, SubTabId, ShopItemId, "SoloTreasureShop",function()
                    self:UpdateActionButtonsState()
                    self:UpdateChooseBagUI()
                end, self)
            end
            UIManager(self):ShowCommonPopupUI(100339, Params)
            return
        end
        if not CanStart then
            UIManager():ShowUITip(UIConst.Tip_CommonToast, ErrorMsg)
            self:PlayFlashRedAnimForEmptySlots()
        end
        return
    end
    
    -- 检查今日是否不再提醒
    local LastRemindTimeStamp = EMCache:Get(EnterDungeonDontRemindTimeStamp, true)
    if (LastRemindTimeStamp and LastRemindTimeStamp > TimeUtils.TimestampLastClock(0)) then
        -- 处于当天不需要提示期间，直接进入副本
        self:EnterEventDungeon()
        return
    end
    
    -- 显示确认弹窗
    local Params = {
        LeftCallbackObj = self,
        LeftCallbackFunction = function(Obj)
            -- 取消
        end,
        RightCallbackObj = self,
        RightCallbackFunction = function(Obj, Data)
            -- 确认进入副本
            self:UpdatePopupSelectedInfo(Data, EnterDungeonDontRemindTimeStamp)
            Obj:EnterEventDungeon()
        end,
        CloseBtnCallbackObj = self,
        CloseBtnCallbackFunction = function(Obj)
            -- 关闭按钮等同于取消
        end
    }
    local PopupUI = UIManager(self):ShowCommonPopupUI(100317, Params)
    if PopupUI then
        self:AddTimer(0.1, function()
            PopupUI:SetFocus()
        end)
    end
end

-- 进入副本
function M:EnterEventDungeon()
    -- 先保存阵容，保存成功后再进入副本
    self:SaveSquadToServer(function(SaveRet)
        if SaveRet ~= ErrorCode.RET_SUCCESS then
            DebugPrint("WBP_Activity_SoloTreasure_Prepare_C:EnterEventDungeon - 保存阵容失败")
            return
        end
        
        -- 阵容保存成功，执行进入副本逻辑
        local Callback = function(Ret)
            if Ret == ErrorCode.RET_SUCCESS then
                -- 进副本前缓存相关信息，用于退出副本时弹出此界面
                local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
                local CurTabIndex = 1
                if ActivityMain then
                    CurTabIndex = ActivityMain.CurTabId
                end
                local ExitDungeonInfo = {
                    Type = "SoloTreasure",
                    EventId = self.Root.EventId,
                    CurTabIndex = CurTabIndex,
                    DungeonId = self.DungeonId,
                }
                GWorld.GameInstance:SetExitDungeonData(ExitDungeonInfo)
            end
        end
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            local IsStory = self.DungeonType == self.EDungeonType.Story
            local IsEasy = not self.IsHardMode
            Avatar:EnterSoloTreasure(self.DungeonId,self.Root.EventId,nil,IsStory,IsEasy,Callback)
        end
    end)
end

-- 更新弹窗选中信息
function M:UpdatePopupSelectedInfo(Data, CacheKey)
    local IsSelected = Data.SelectHint.IsSelected
    if (IsSelected) then
        local NowTime = TimeUtils.NowTime()
        EMCache:Set(CacheKey, NowTime, true)
    end
end

function M:OnClearPressed()
    if self.Btn_Clear.Btn_Click:GetForbidden() then
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/activity/wuyoudaguai_btn_click_common", nil, nil)
end

function M:OnStartPressed()
    if self.Btn_Start.Btn_Click:GetForbidden() then
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/activity/wuyoudaguai_btn_click_common", nil, nil)
end

function M:OnPreviewBagClicked()
    if self.Preview.Btn_Bag.Btn_Click:GetForbidden() then
        return
    end
    local ShopItemId = self.SelectBagContent.ShopItemId
    if self.SelectBagContent.IsLock then
        local SubTabId = DataMgr.ShopItem[ShopItemId].SubTabId
        local MainTabId = DataMgr.ShopTabSub[SubTabId].MainTabId
        PageJumpUtils:JumpToShopPage(MainTabId, SubTabId, ShopItemId, "SoloTreasureShop",function()
            -- todo返回要更新状态UI
        end, self)
    else
        self.LastSelectedBagItemUI:SetIsChosen(true)
        self.Preview.Btn_Bag.Btn_Click:SetForbidden(true)
        self.Preview.Btn_Bag.Text_Button:SetText(GText("UI_SoloTreasure_BagInUse"))
        self:OnChooseBag(self.SelectBagContent)
    end

end

function M:SwitchUIType(UIType)
    if self.IsUseGamePad and UIType == self.EUIType.Bag then
        self:ChangeFocusMode(6)
        if self.CurUIType == self.EUIType.Listing then
            self:AddTimer(0.2, function()
                self.List_Bag:SetFocus()
            end)
        else
            self.List_Bag:SetFocus()
        end
    end
    if self.CurUIType == UIType then
        return
    end
    self.CurUIType = UIType
    if UIType == self.EUIType.Listing then
        self:PlayAnimation(self.Left_Listing_In)
        self.Build.Bag:SetIsChecked(false)
        self.Build.Bag:SetVisibility(UE4.ESlateVisibility.Visible)
    elseif UIType == self.EUIType.Bag then
        self:PlayAnimation(self.Left_Bag_In)
        self.Build.Bag:SetIsChecked(true)
        self.CurSlotName = "Bag"
        self.Build.Bag:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
    end
end

function M:Enter(DungeonType,DungeonId,IsHardMode)
    self.DungeonType = DungeonType
    self.DungeonId = DungeonId
    self.IsHardMode = IsHardMode
    -- 获取EventId
    local EventId = self.Root and self.Root.EventId
    if not EventId then
        DebugPrint("WBP_Activity_Wuyousheng_TeamBuild_C:Enter - EventId无效")
    end

    if not self.DungeonId then
        DebugPrint("WBP_Activity_Wuyousheng_TeamBuild_C:Enter - DungeonId无效")
    end

    self:CalculateModeFee()
    self:UpdateModeUI()
    
    -- 获取保存的阵容数据
    local SavedSquad = nil
    if DungeonId and EventId then
        local Avatar = GWorld:GetAvatar()
        if Avatar and Avatar.TreasureHunts then
            local TreasureHuntData = Avatar.TreasureHunts[EventId]
            if TreasureHuntData then
                SavedSquad = TreasureHuntData:GetSquadInfo(DungeonId, self.IsHardMode)
            end
        end
    end
    
    if SavedSquad == nil then
        SavedSquad = {
            BagIndex = 1,
        }
    end

    -- 直接使用保存的阵容
    self.TeamInfos = SavedSquad
    
    self:InitWidget()
    
    -- 初始化关卡数据
    self:InitDungeonData(DungeonType, DungeonId)

    -- 初始化详情面板（如果TeamInfos为nil会自动清空槽位）
    self:InitDetailPanels()

    -- 默认选中角色配置槽
    local SelectedSlot = self.ESlotName.Char
    self:OnSlotClicked(SelectedSlot, true)
    self.FocusWidget = self.Build.Character
    
    -- 初始化按钮置灰状态
    self:UpdateActionButtonsState()
    
    -- 更新角色模型显示
    self:UpdateSquadModels()

    -- 如果是HardMode,要把魅影1和2都设置为Forbidden
    if IsHardMode then
        self.Slots[self.ESlotName.Phantom1]:SetLockState(true)
        self.Slots[self.ESlotName.Phantom2]:SetLockState(true)
        self.Slots[self.ESlotName.PhantomWeapon1]:SetLockState(true)
        self.Slots[self.ESlotName.PhantomWeapon2]:SetLockState(true)
    else
        self.Slots[self.ESlotName.Phantom1]:SetLockState(false)
        self.Slots[self.ESlotName.Phantom2]:SetLockState(false)
        self.Slots[self.ESlotName.PhantomWeapon1]:SetLockState(false)
        self.Slots[self.ESlotName.PhantomWeapon2]:SetLockState(false)
    end
end

-- 初始化关卡数据（试用数据、限制数据等）
function M:InitDungeonData(DungeonType, DungeonId)
    if not DungeonId then
        return
    end
    
    local TrialData = nil
    local LimitData = nil
    local LevelConfig = nil
    
    -- 根据关卡类型获取配置数据
    if DungeonType == self.EDungeonType.Story then
        LevelConfig = DataMgr.TreasureHuntStoryDungeon[DungeonId]
    elseif DungeonType == self.EDungeonType.Repeat then
        LevelConfig = DataMgr.TreasureHuntRepeatDungeon[DungeonId]
    end
    
    if not LevelConfig then
        return
    end
    
    -- 初始化背包列表
    self:InitBagList(LevelConfig.LevelBackPack)
    
    -- 构建试用数据
    local TrialMeleeWeapons, TrialRangedWeapons = self:GetWeaponTypeList(LevelConfig.TrialWeapon)
    TrialData = {
        TrialChars = LevelConfig.TrialCharacter or {},
        TrialMeleeWeapons = TrialMeleeWeapons,
        TrialRangedWeapons = TrialRangedWeapons,
        TrialPets = LevelConfig.TrialPet or {},
        -- 配置是否显示玩家拥有的物品
        ShowOwned = {
            Chars = true,      -- 显示玩家拥有的角色 + 试用角色
            Weapons = true,    -- 显示玩家拥有的武器 + 试用武器
            Pets = (DungeonType == self.EDungeonType.Repeat),  -- 复刷关显示玩家拥有的宠物，剧情关默认不显示
        }
    }
    
    -- 剧情关特殊处理：如果填的是-1，则显示玩家拥有的宠物，并且没有试用角色
    if DungeonType == self.EDungeonType.Story then
        if TrialData.TrialPets[1] == -1 then
            TrialData.ShowOwned.Pets = true
            TrialData.TrialPets = {}
        end
        
        -- 构建限制数据（仅剧情关有）
        local LimitMeleeWeapons, LimitRangedWeapons = self:GetWeaponTypeList(LevelConfig.LimitWeapon)
        LimitData = {
            LimitCharacters = LevelConfig.LimitCharacter or {},
            LimitMeleeWeapons = LimitMeleeWeapons,
            LimitRangedWeapons = LimitRangedWeapons,
            LimitPets = LevelConfig.LimitPet or {},
        }
    end
    
    -- 更新Component的试用数据（在InitWidget之后）
    if TrialData then
        self.TrialData = TrialData
        self.LimitData = LimitData
        self:CharMain_Init(true)
        self:MeleeMain_Init(true)
        self:RangedMain_Init(true)
        self:PetMain_Init(true)
    end
end

function M:InitDetailPanels()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        DebugPrint("M:InitDetailPanels, 配置面板初始化失败，Avatar无效")
        return
    end
    
    -- 如果TeamInfos为nil，清空所有槽位
    if not self.TeamInfos then
        self:ClearAllSlots()
        return
    end
    
    -- 新格式：{["Char"] = {Id = 123, bTrial = false, ModIndex = 1}, ...}
    local Squad = self.TeamInfos
    
    -- 处理槽位（按照 ESlotName 的值顺序 1-8）
    for _, SlotName in ipairs(self.SlotNameOrder) do
        local EName = self.ESlotName[SlotName]
        if not EName then
            goto continue
        end
        local SlotInfo = Squad[SlotName]
        if not SlotInfo or not SlotInfo.Id then
            goto continue
        end
        
        local Id = SlotInfo.Id
        local IsTryout = SlotInfo.bTrial or false
        
        local SlotType = self.SlotName2Type[EName]
        local DataType = self.SlotType2DataType[SlotType]
        local Content = nil
        
        -- 根据槽位类型查找Content
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
        
        -- 如果不是试用物品，验证物品是否存在
        if not IsTryout then
            local Unit = Avatar[DataType.."s"][Id]
            if not Unit then
                GWorld.logger.error("M:InitDetailPanels@该Id对应的物品已失效"..CommonUtils.ObjId2Str(Id))
                goto continue
            end
        end
        
        if SlotInfo.ModIndex then
            Content.ModSuitIndex = SlotInfo.ModIndex
        end
        -- 更新槽位
        if Content then
            self:UpdateSlot(EName, Content)
        end
        
        ::continue::
    end
end

function M:OnLeftItemContentChanged()
    self:UpdateActionButtonsState()
end

function M:InitBagList(LevelBackPack)
    self.List_Bag:ClearListItems()
    local Avatar = GWorld:GetAvatar()
    local ChooseBagIndex = self.TeamInfos and self.TeamInfos.BagIndex or 1
    local SelectBagIndex = self.LastSelectedBagItemUIIndex or ChooseBagIndex
    for i = 1, #LevelBackPack do
        local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
        local BagID = LevelBackPack[i]
        local BagData = DataMgr.ExtractionTreasureBag[BagID]
        ItemContent.Price = BagData.Price
        ItemContent.Shape = BagData.Shape
        ItemContent.Index = i
        ItemContent.ParentWidget = self
        ItemContent.Name = BagData.Name
        ItemContent.ShapeType = BagData.ShapeType
        ItemContent.ShopItemId = BagData.ShopItemId
        ItemContent.Condition = BagData.EventUnlockCondition
        ItemContent.IsSelected = i == SelectBagIndex
        ItemContent.IsChosen = i == ChooseBagIndex
        if ItemContent.Condition then
            if (ConditionUtils.CheckCondition(Avatar, ItemContent.Condition) == false) then
                ItemContent.IsLock = true
            else
                ItemContent.IsLock = false
            end
        else
            ItemContent.IsLock = false
        end
        self.List_Bag:AddItem(ItemContent)
        if i == SelectBagIndex then
            self:OnSelectBag(ItemContent)
        end
        if i == ChooseBagIndex then
            self:OnChooseBag(ItemContent)
        end
    end
    self.List_Bag:RequestFillEmptyContent()
end

function M:CalculateModeFee()
    if self.DungeonType == self.EDungeonType.Story then
        local LevelConfig = DataMgr.TreasureHuntStoryDungeon[self.DungeonId]
        local ModeFee = LevelConfig.Fee
        self.ModeFee = ModeFee
        self.ModeType = self.SoloTreasureCurrentId
    elseif self.DungeonType == self.EDungeonType.Repeat then
        local LevelConfig = DataMgr.TreasureHuntRepeatDungeon[self.DungeonId]
        local ModeFee = 0
        if self.IsHardMode then
            ModeFee = LevelConfig.HardModeFee
        else
            ModeFee = LevelConfig.EasyModeFee
        end
        self.ModeType = LevelConfig.FeeResource
        self.ModeFee = ModeFee
    end
end

function M:UpdateModeUI()
    local ResourceIcon = nil
    if self.ModeType == self.SoloTreasureCurrentId then
        self.Build.Panel_Bottom:SetVisibility(UE4.ESlateVisibility.Visible)
        ResourceIcon = DataMgr.Resource[self.SoloTreasureCurrentId].Icon
    elseif self.ModeType == self.SoloTreasureTicketResourceId then
        self.Build.Panel_Bottom:SetVisibility(UE4.ESlateVisibility.Collapsed)
        ResourceIcon = DataMgr.Resource[self.SoloTreasureTicketResourceId].Icon
    end
    self.Build.Icon_Cost:SetBrushFromTexture(LoadObject(ResourceIcon))
end

function M:OnSelectBag(Content)
    self.SelectBagContent = Content
    self:UpdatePreviewUI()
end

function M:OnChooseBag(Content)
    self.ChooseBagContent = Content
    self:UpdateChooseBagUI()
end

function M:UpdateChooseBagUI()
    local BuildWidget = self.Build
    if self.ModeFee == nil then self.ModeFee = 0 end
    BuildWidget.Bag.Text_Num:SetText(self.ChooseBagContent.Index)
    BuildWidget.Bag.Text_Cost:SetText(self.ChooseBagContent.Price)
    BuildWidget.Text_Cost:SetText(self.ModeFee)
    BuildWidget.Text_BagCost:SetText(self.ChooseBagContent.Price)
    -- 计算总费用
    self.TotalCost = self.ModeFee + self.ChooseBagContent.Price
    if self.ModeType == self.SoloTreasureTicketResourceId then
        self.TotalCost = self.ChooseBagContent.Price
    end
    BuildWidget.Text_TotalCost:SetText(self.TotalCost)
    -- 获取玩家持有的资源数量并设置颜色
    local Avatar = GWorld:GetAvatar()
    local PlayerResourceAmount = 0
    local PlayerTicketResourceAmount = 0
    if Avatar and self.SoloTreasureCurrentId then
        PlayerResourceAmount = Avatar:GetResourceNum(self.SoloTreasureCurrentId)
        PlayerTicketResourceAmount = Avatar:GetResourceNum(self.SoloTreasureTicketResourceId)
    end
    -- 如果总费用超过持有资源，设置为红色，否则设置为白色（默认）
    local ColorWhite = FSlateColor()
    local ColorRed = FSlateColor()
    ColorWhite.SpecifiedColor.R = 1.0
    ColorWhite.SpecifiedColor.G = 1.0
    ColorWhite.SpecifiedColor.B = 1.0
    ColorRed.SpecifiedColor.R = 1.0
    ColorRed.SpecifiedColor.G = 0.0
    ColorRed.SpecifiedColor.B = 0.0
    if self.TotalCost > PlayerResourceAmount then
        BuildWidget.Text_TotalCost:SetColorAndOpacity(ColorRed)
    else
        BuildWidget.Text_TotalCost:SetColorAndOpacity(ColorWhite)
    end
    if self.ModeType == self.SoloTreasureTicketResourceId and self.ModeFee > PlayerTicketResourceAmount then
        BuildWidget.Text_Cost:SetColorAndOpacity(ColorRed)
    else
        BuildWidget.Text_Cost:SetColorAndOpacity(ColorWhite)
    end
    BuildWidget.Bag.Text_Title:SetText(GText(self.ChooseBagContent.Name))
    local BagIconName = string.format("Texture2D'/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_BagSign0%s.T_Activity_SoloTreasure_BagSign0%s'", self.ChooseBagContent.Index, self.ChooseBagContent.Index)
    local BagIcon = LoadObject(BagIconName)
    if BagIcon then
        BuildWidget.Bag.Icon_Bag:SetBrushFromTexture(BagIcon)
    end
end

function M:UpdatePreviewUI()
    SoloTreasureUtils:InitBagUI(self.Preview, self.SelectBagContent.ShapeType)
    self.Preview:BindToAnimationFinished(self.Preview.In,{self, self.OnInAnimationFinished})
    self.Preview:PlayAnimation(self.Preview.In)


    local IsLock = self.SelectBagContent.IsLock
    local IsChosen = self.SelectBagContent.IsChosen
    self.Preview.Btn_Bag.Btn_Click:SetForbidden(false)
    if IsLock then
        self.Preview.Panel_Tips:SetVisibility(UE4.ESlateVisibility.Visible)
        self.Preview.Btn_Bag.Text_Button:SetText(GText("UI_SoloTreasure_GoToUnlockBag"))
    elseif IsChosen then
        self.Preview.Btn_Bag.Btn_Click:SetForbidden(true)
        self.Preview.Panel_Tips:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Preview.Btn_Bag.Text_Button:SetText(GText("UI_SoloTreasure_BagInUse"))
    else
        self.Preview.Panel_Tips:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Preview.Btn_Bag.Text_Button:SetText(GText("UI_SoloTreasure_UseBag"))
    end
end

function M:OnInAnimationFinished()
    if self.CurInputDeviceType ~= ECommonInputType.Gamepad or self.FocusMode ~= 6 then
        return
    end
    self.Preview:UnbindAllFromAnimationFinished(self.Preview.In)
    local BottomKeyInfo = {}
    DebugPrint("thy   OnInAnimationFinished JLy", self.Preview.EMScrollBox_1:GetScrollOffsetOfEnd())
    if self.Preview.EMScrollBox_1:GetScrollOffsetOfEnd() > 0 then
        BottomKeyInfo = { { GamePadInfoList = {{Type="Img", ImgShortPath="RV"}}, Desc = GText("UI_Controller_Slide"), bLongPress = false},
        { KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.Root.OnReturnKeyDown, Owner=self.Root}}, GamePadInfoList = {{Type="Img", ImgShortPath="B"}}, Desc = GText("UI_BACK"), bLongPress = false}}
        self.Preview.EMScrollBox_1:SetScrollBarVisibility(UE4.ESlateVisibility.Visible)
        self.Preview.EMScrollBox_1:SetAlwaysShowScrollbar(true)
    else
        BottomKeyInfo = {{ KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.Root.OnReturnKeyDown, Owner=self.Root}}, GamePadInfoList = {{Type="Img", ImgShortPath="B"}}, Desc = GText("UI_BACK"), bLongPress = false}}
        self.Preview.EMScrollBox_1:SetAlwaysShowScrollbar(false)
    end
    self.Root.Com_Tab:UpdateBottomKeyInfo(BottomKeyInfo)
end

-- 创建ActorController（用于显示角色模型）
function M:CreateActorController()
    if self.ActorController then
        return
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    
    -- 获取当前主角角色（如果有的话）
    local Char = nil
    if self.TeamInfos and self.TeamInfos.Char and Avatar.Chars[self.TeamInfos.Char] then
        Char = Avatar.Chars[self.TeamInfos.Char]
    elseif Avatar.CurrentChar and Avatar.Chars[Avatar.CurrentChar] then
        Char = Avatar.Chars[Avatar.CurrentChar]
    end
    
    local SoloTreasureSkyBoxColorIndex = DataMgr.GlobalConstant["SoloTreasureSkyBoxColorIndex"].ConstantValue or 0
    self.ActorController = ActorController:New({
        ViewUI = self.Root,
        IsPreviewMode = true,
        Char = Char,
        bNeedEndCamera = false,
        EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
        SkyBoxIndex = SoloTreasureSkyBoxColorIndex,
    })
    if self.ActorController then
        self.ActorController:OnOpened(0)
        -- 初次打开时，播放一次默认待机动作和镜头
        self.ActorController:FixedCameraTransTimeOnce(0)
        self.ActorController:SetMontageAndCamera(CommonConst.ArmoryType.Char, nil, nil)
    end
end

-- 销毁ActorController
function M:DestroyActorController()
    if self.ActorController then
        self.ActorController:OnClosed()
        self.ActorController:OnDestruct()
        self.ActorController = nil
    end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = true

    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsHandled = self:HandleGamepadInput(InKeyName)
    else
        if (InKeyName == "Escape") then
            self:OnReturnKeyDown()
        elseif InKeyName == "Q" and self.IsTabPrimaryVisible then
            self.Listing.Type_Melee:OnBtnClicked()
            IsHandled = true
        elseif InKeyName == "E" and self.IsTabPrimaryVisible then
            self.Listing.Type_Range:OnBtnClicked()
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

function M:OnReturnKeyDown()
    if self.IsTipsOpen then
        self:CloseTips()
        return
    end
    if self.Root then
        self.Root:OpenSubUI(self.PreWidgetInfo, self.DungeonType)
    end
end

function M:UpdateActionButtonsState()    
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
    
    -- Btn_Start: 使用CheckCanStart判断，置灰应该用SetForbidden
    local CanStart = self:CheckCanStart()
    self.Btn_Start.Btn_Click:SetForbidden(not CanStart)
end

function M:CheckCanStart()
    -- 判断阵容是否满足条件
    local CanStart = self:CheckTeamCondition()
    if not CanStart then
        return false, GText("UI_SoloTreasure_ArmoryLackNecessaryComponent")
    end
    -- 判断总费用是否足够
    local SoloTreasureCurrent = self.SoloTreasureCurrentId
    local Avatar = GWorld:GetAvatar()
    local PlayerResourceAmount = 0
    if Avatar and SoloTreasureCurrent then
        PlayerResourceAmount = Avatar:GetResourceNum(SoloTreasureCurrent)
    end
    if self.ModeType == self.SoloTreasureTicketResourceId then
        local PlayerTicketResourceAmount = Avatar:GetResourceNum(self.SoloTreasureTicketResourceId)
        if self.ModeFee > PlayerTicketResourceAmount then
            return false, -1
        end
    end
    if self.TotalCost > PlayerResourceAmount then
        return false, GText("UI_SoloTreasure_ArmoryLackEntryFee")
    end
    return true, nil
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

-- 为空的槽位播放闪烁红色动画
function M:PlayFlashRedAnimForEmptySlots()
    -- 检查四个必需的槽位
    local RequiredSlots = {
        {SlotName = self.ESlotName.Char, Name = "Char"},
        {SlotName = self.ESlotName.MeleeWeapon, Name = "MeleeWeapon"},
        {SlotName = self.ESlotName.RangedWeapon, Name = "RangedWeapon"},
        {SlotName = self.ESlotName.Pet, Name = "Pet"}
    }
    
    for _, SlotInfo in ipairs(RequiredSlots) do
        local SlotWidget = self.Slots[SlotInfo.SlotName]
        if SlotWidget and SlotWidget.IsEmpty then
            if SlotWidget.PlayFlashRedAnim then
                SlotWidget:PlayFlashRedAnim()
            end
        end
    end
    
    -- 检查魅影和魅影武器
    -- 魅影1
    local Phantom1Slot = self.Slots[self.ESlotName.Phantom1]
    if Phantom1Slot and not Phantom1Slot.IsEmpty then
        -- 如果放了魅影1，检查魅影武器1
        local PhantomWeapon1Slot = self.Slots[self.ESlotName.PhantomWeapon1]
        if PhantomWeapon1Slot and PhantomWeapon1Slot.IsEmpty then
            if PhantomWeapon1Slot.PlayFlashRedAnim then
                PhantomWeapon1Slot:PlayFlashRedAnim()
            end
        end
    end
    
    -- 魅影2
    local Phantom2Slot = self.Slots[self.ESlotName.Phantom2]
    if Phantom2Slot and not Phantom2Slot.IsEmpty then
        -- 如果放了魅影2，检查魅影武器2
        local PhantomWeapon2Slot = self.Slots[self.ESlotName.PhantomWeapon2]
        if PhantomWeapon2Slot and PhantomWeapon2Slot.IsEmpty then
            if PhantomWeapon2Slot.PlayFlashRedAnim then
                PhantomWeapon2Slot:PlayFlashRedAnim()
            end
        end
    end
end

---@param MouseEvent FPointerEvent
function M:OnMouseButtonDown(MyGeometry, MouseEvent)
    if UKismetInputLibrary.PointerEvent_IsMouseButtonDown(MouseEvent, EKeys.LeftMouseButton) then
        self:CloseTips()
    end
end

function M:ReceiveEnterStateSelf(StackAction)
    if (StackAction == 1) then
        self:RestoreFocusOnReturn()
        self:InitDungeonData(self.DungeonType,self.DungeonId)
        self:ReInitListItems()
        -- 这里进入的时候，需要判断一下现在装备的武器和宠物是不是还存在，如果不存在，则需要提示用户，并清空对应的槽位
        local HasItemRemoved = false
        
        -- 需要检查的槽位列表（武器和宠物）
        local SlotNamesToCheck = {
            "MeleeWeapon",
            "RangedWeapon",
            "PhantomWeapon1",
            "PhantomWeapon2",
            "Pet"
        }
        
        -- 遍历所有需要检查的槽位
        for _, SlotName in ipairs(SlotNamesToCheck) do
            local SlotEnumName = self.ESlotName[SlotName]
            if not SlotEnumName then
                goto continue
            end
            
            local SlotWidget = self.Slots[SlotEnumName]
            if not SlotWidget or SlotWidget.IsEmpty then
                goto continue
            end
            
            -- 从 slot 中获取当前装备的 Content
            local SlotContent = SlotWidget.Content
            if not SlotContent or not SlotContent.Uuid then
                goto continue
            end
            
            -- 如果是试用物品，不需要检查
            if SlotContent.IsTryout then
                goto continue
            end
            
            -- 检查物品是否还在 ItemContentsMap 中
            local ContentExists = false
            if SlotName == "MeleeWeapon" then
                ContentExists = self.MeleeItemContentsMap and self.MeleeItemContentsMap[SlotContent.Uuid] ~= nil
            elseif SlotName == "RangedWeapon" then
                ContentExists = self.RangedItemContentsMap and self.RangedItemContentsMap[SlotContent.Uuid] ~= nil
            elseif SlotName == "PhantomWeapon1" or SlotName == "PhantomWeapon2" then
                -- 魅影武器先尝试 Melee，找不到再尝试 Ranged
                ContentExists = (self.MeleeItemContentsMap and self.MeleeItemContentsMap[SlotContent.Uuid] ~= nil) or
                               (self.RangedItemContentsMap and self.RangedItemContentsMap[SlotContent.Uuid] ~= nil)
            elseif SlotName == "Pet" then
                ContentExists = self.PetItemContentsMap and self.PetItemContentsMap[SlotContent.Uuid] ~= nil
            end
            
            -- 如果物品不存在，清空槽位
            if not ContentExists then
                self:ClearSlot(SlotEnumName)
                -- 清空TeamInfos中的记录（如果存在）
                if self.TeamInfos then
                    self.TeamInfos[SlotName] = nil
                end
                HasItemRemoved = true
            end
            
            ::continue::
        end
        
        -- 如果有物品被移除，提示用户并更新按钮状态
        if HasItemRemoved then
            UIManager():ShowUITip(UIConst.Tip_CommonToast, GText("UI_SoloTreasure_WeaponNotExist"))
            self:UpdateActionButtonsState()
        end
    end
end

AssembleComponents(M)


return M
