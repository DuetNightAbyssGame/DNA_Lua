--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local RewardBox = require "BluePrints.Client.CustomTypes.SimpleRewardBox"
local Menu_Level_PC_C = Class({"Blueprints.UI.BP_UIState_C"})
local UIUtils = require "Utils.UIUtils"
Menu_Level_PC_C._components = {
    "BluePrints.UI.UI_PC.Menu.MenuLevelAbyssComponent"
}
function Menu_Level_PC_C:Initialize(Initializer)
    self.Super.Initialize(self)
    self.BtnName = {
        'UI_Esc_Continue',
        'UI_Esc_CommonSet',
       --TODO 一测不需要显示任务状态，先隐藏 --
        --'UI_Esc_Status',
        'UI_Esc_Skill',
    }
    self.ClickFunction = {
        "OnClickContinueGame",
        "OnClickCommonSet",
        --"OnClickShowStatistics",
        "OnClickSkill",
    }
    self.BtnIconPath={
        UI_Esc_Continue="/Game/UI/Texture/Dynamic/Atlas/Menu/T_Menu_Continue.T_Menu_Continue",
        UI_Rouge_ESC_HalfwayOut="/Game/UI/Texture/Dynamic/Atlas/Menu/T_Menu_Suspend.T_Menu_Suspend",
        UI_Rouge_ESC_EndOut="/Game/UI/Texture/Dynamic/Atlas/Menu/T_Menu_Exit.T_Menu_Exit",
        UI_HardBoss_TabName_2="/Game/UI/Texture/Dynamic/Atlas/Menu/T_Menu_Exit.T_Menu_Exit",
        UI_Esc_CommonSet="/Game/UI/Texture/Dynamic/Atlas/Menu/T_Menu_Setting.T_Menu_Setting",
        UI_Esc_Skill="/Game/UI/Texture/Dynamic/Atlas/Menu/T_Menu_Skill.T_Menu_Skill",
        UI_TEMPLE_RESTART="/Game/UI/Texture/Dynamic/Atlas/Menu/T_Menu_Restart.T_Menu_Restart",
        UI_DUNGEON_DES_TRAINING_27="/Game/UI/Texture/Dynamic/Atlas/Menu/T_Menu_Skill.T_Menu_Skill",
        UI_DUNGEON_DES_TRAINING_28="/Game/UI/Texture/Dynamic/Atlas/Menu/T_Menu_Exit.T_Menu_Exit",
        UI_SpecialQuest_GiveUp="/Game/UI/Texture/Dynamic/Atlas/Menu/T_Menu_Exit.T_Menu_Exit",
        UI_CharTrial_LeaveTitle="/Game/UI/Texture/Dynamic/Atlas/Menu/T_Menu_Exit.T_Menu_Exit",
        FeinaEvent_Exit_Title="/Game/UI/Texture/Dynamic/Atlas/Menu/T_Menu_Exit.T_Menu_Exit",
        UI_Esc_ExitTemple="/Game/UI/Texture/Dynamic/Atlas/Menu/T_Menu_Exit.T_Menu_Exit",
    }
    self.BtnIdx = 0
    self.CloseBySelf=false
    self.CloseByChild=false
    self.GamePadGiveUpKeyName="UI_Esc_Challenge"
end

function Menu_Level_PC_C:OnLoaded()
    self.Super.OnLoaded(self)
    AudioManager(self):PlayUISound(self, "event:/ui/common/esc_menu_open", "EscMenuOpen", nil)
    self:SetFocus()
    self:Init()
    self:PlayInAnim()
end

function  Menu_Level_PC_C:Init()
    self.MaxBtnNum=10
    self:InitCommonInfo()
    self:InitByType()

    --保证BtnList和ClickFunction的改动完成后再初始化
    self:InitSetupList()
    self:InitStageInfo()
    self:InitRoleItemInfos()
    self:InitCommonButton()
    --self:InitRewardsInfo()
    --self:InitAvatorList()
    --local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    --self:SetPlayerInfo(Player)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self:AddInputMethodChangedListen()
    end
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    local BattleMainUI = UIManager(self):GetUI('BattleMain')
    if (BattleMainUI ~= nil) then
        BattleMainUI:SetRenderOpacity(0)
    end
    local FeinaHud = UIManager(self):GetUI('FeinaEventHUD')
    if (FeinaHud ~= nil) then
        FeinaHud:PlayOutAnim()
    end
end

function Menu_Level_PC_C:InitCommonInfo()
    -- table.insert(self.BtnName, 'UI_HardBoss_TabName_2')
    -- table.insert(self.ClickFunction,  "OnClickExitGame")
    self.Text_Title:SetText(GText("UI_Dungeon_DetailTitle"))
end

function Menu_Level_PC_C:InitByType()
    local Avatar = GWorld:GetAvatar()

    self.InHardBoss=false
    self.InTemple=false
    self.InTraining=false
    self.InRougeLike=false
    self.IsInCommonDungeon=false
    if Avatar and Avatar:IsInHardBoss() then
        self.InHardBoss=true
        self:InitHardBoss()
        return
    end
    if Avatar and Avatar:IsInRougeLike() then
       self:InitRougeLike()
       self.InRougeLike=true
       return
    end
    if Avatar and Avatar.SpecialQuestId then
        self:InitSpecialQuest()
        self.InSpecialQuest=true
        return
     end
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if GameMode ~= nil and GameState ~= nil  then
        if GameState.GameModeType == "Training" then
            self:InitTraining()
            self.InTraining=true
            return
        elseif GameState.GameModeType == "Temple" then
            self:InitTemple()
            self.InTemple=true
            return
        elseif GameState.GameModeType=="Trial" then
            self:InitTrail()
            self.InTrail=true
            return
        elseif GameState.GameModeType=="Abyss" then
            self:InitAbyss()
            self.InAbyss=true
            return
        elseif GameState.GameModeType=="Party" then
            self:InitParty()
            self.InParty=true
            return
        elseif GameState.GameModeType=="FeinaEvent" then
            self:InitFeinaEvent()
            self.InFeinaEvent=true
            return
        elseif GameState.GameModeType=="Paotai" then
            self:InitPaotaiEvent()
            self.InPaotaiEvent=true
        elseif GameState.GameModeType=="SoloTreasure" then
            self:InitSoloTreasure()
            self.InSoloTreasure = true
        elseif GameState.GameModeType=="MonsterRush" then
            self:InitMonsterRush()
            self.InMonsterRush = true
        elseif GameState.GameModeType=="AutoChess" then
            self:InitAutoChess()
            self.IsInAutoChess=true
            return
        end
    end
    --其他类型
    self.IsInCommonDungeon=true
    table.insert(self.BtnName, 'UI_HardBoss_TabName_2')
    table.insert(self.ClickFunction,  "OnClickExitGame")
end

function Menu_Level_PC_C:InitSoloTreasure()
    self.WidgetSwitcher_Type:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WidgetSwitcher_Show:SetVisibility(UIConst.VisibilityOp.Collapsed)
    table.remove(self.BtnName, 3)
    table.remove(self.ClickFunction, 3)
end

function Menu_Level_PC_C:InitFeinaEvent()
    self.WidgetSwitcher_Type:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WidgetSwitcher_Show:SetVisibility(UIConst.VisibilityOp.Collapsed)
    table.remove(self.BtnName, 3)
    table.remove(self.ClickFunction, 3)
    table.insert(self.BtnName, 'FeinaEvent_Exit_Title')
    table.insert(self.ClickFunction,  "OnClickExitGame")
end

function Menu_Level_PC_C:InitMonsterRush()
    self.WidgetSwitcher_Type:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WidgetSwitcher_Show:SetVisibility(UIConst.VisibilityOp.Collapsed)
    table.remove(self.BtnName, 3)
    table.remove(self.ClickFunction, 3)
end

function Menu_Level_PC_C:InitAutoChess()
    self.WidgetSwitcher_Type:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WidgetSwitcher_Show:SetVisibility(UIConst.VisibilityOp.Collapsed)
    table.remove(self.BtnName, 3)
    table.remove(self.ClickFunction, 3)
    table.insert(self.BtnName, 'UI_HardBoss_TabName_2')
    table.insert(self.ClickFunction,  "OnClickExitGame")
end

function Menu_Level_PC_C:InitPaotaiEvent()
    self.WidgetSwitcher_Type:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WidgetSwitcher_Show:SetVisibility(UIConst.VisibilityOp.Collapsed)
    table.remove(self.BtnName, 3)
    table.remove(self.ClickFunction, 3)
    table.remove(self.BtnName, 2)
    table.remove(self.ClickFunction, 2)
end

function Menu_Level_PC_C:InitTemple()
    -- self.WidgetSwitcher_Type:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WidgetSwitcher_Type:SetActiveWidgetIndex(3)
    -- self.WidgetSwitcher_Type:SetVisibility(UIConst.VisibilityOp.Visable)
    table.insert(self.BtnName,'UI_TEMPLE_RESTART')
    table.insert(self.BtnName, 'UI_Esc_ExitTemple')
    table.insert(self.ClickFunction,  "TempleRestart")
    table.insert(self.ClickFunction, "OnClickExitGame")

    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local TempleInfo = DataMgr.Temple[GameState.DungeonId]
    local StarLevel = GameState.MaxTempleStar or 0
    local Ids = TempleInfo.RewardId
    
    local FailReason = "Quit"
    local IsEventTemple = DataMgr.TempleEventLevel[GameState.DungeonId] ~= nil

    if #Ids == 3 then
        self.IsStarLevel = true
        -- if self.CombatData.StarLevel then
        --     StarLevel = self.CombatData.StarLevel
        -- end
        if StarLevel < 0 or StarLevel > 3 then
            error("本关设置星级超出可获得的范围")
        end
    elseif #Ids == 1 then
        self.IsStarLevel = false
    else
        error("本关奖励配置有误，请正确配置星级奖励或无星级奖励")
    end

    -- 奖励栏
    self.SizeBox_Rewards:ClearChildren()
    self.WidgetRewards = self:CreateWidgetNew("TempleItem")
    self.WidgetRewards.ParentUI = self
    local RewardsInfo = {}

    if IsEventTemple then
        self.WidgetSwitcher_Type:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.IsStarLevel then
        -- 星级关卡奖励栏
        -- 当前神庙历史最高星级
        local MaxTempleStar = GameState.MaxTempleStar or 0
        for i = 1, #Ids do
            local ItemData = self:GetFirstRewardInfoById(Ids[i])
            local Info = self:NewTempleContent(ItemData, i)
            table.insert(RewardsInfo, Info)
            RewardsInfo[i].bAsyncLoadIcon = true
        end
        self.WidgetRewards:SetStarRewards(RewardsInfo, StarLevel, MaxTempleStar)
    else
        -- 非星级关卡奖励栏
        if Ids[1] ~= nil then
            local ItemDatas = RewardUtils:GetAllRewardByRewardId(Ids[1])
            local Rewards = {}
            self:RewardsAddToArray(Rewards, ItemDatas, false)
            self:SortRewardsArray(Rewards)
            RewardsInfo = Rewards
        end
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
            error("Avatar is nil")
        end
        if Avatar.Dungeons[GameState.DungeonId] then
            local IsPass = Avatar.Dungeons[GameState.DungeonId].IsPass
            self.WidgetRewards:SetNoStarRewards(RewardsInfo, IsPass, 0 , 0)
            self.WidgetRewards:StartShowNoStarRewards()
        end
    end
    self.WidgetRewards:SetVisibility(ESlateVisibility.Visable)
    self.SizeBox_Rewards:AddChild(self.WidgetRewards)

    -- 直接初始化奖励项目表
    self.RewardItems = {
        self.WidgetRewards.Item01,
        self.WidgetRewards.Item02,
        self.WidgetRewards.Item03,
        self.WidgetRewards.Item_Repeat
    }
    local ConfigData = {
        OwnerWidget = self.WidgetRewards,
        TextContent = GText("UI_Temple_RewardDetail"),
        OnMenuOpenChangedCallBack = self.OnMenuOpenChangedCallBack,
    }
    self.WidgetRewards.Btn_Qa:Init(ConfigData)
    self.WidgetRewards.Btn_Qa:SetVisibility(ESlateVisibility.Visible)
end

function Menu_Level_PC_C:InitParty()
    -- CBT3 派对暂时不支持重新开开始
    -- self.WidgetSwitcher_Type:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WidgetSwitcher_Type:SetActiveWidgetIndex(3)
    -- self.WidgetSwitcher_Type:SetVisibility(UIConst.VisibilityOp.Visable)
    -- table.insert(self.BtnName,'UI_TEMPLE_RESTART')
    table.insert(self.BtnName, 'UI_Esc_ExitTemple')
    -- table.insert(self.ClickFunction,  "PartyRestart")
    table.insert(self.ClickFunction, "OnClickExitGame")

    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local PartyInfo = DataMgr.Party[GameState.DungeonId]
    local StarLevel = GameState.MaxTempleStar or 0
    -- local Score = 0
    -- local Collection = 0
    local Ids = PartyInfo.RewardId
    
    local FailReason = "Quit"

    if #Ids == 3 then
        self.IsStarLevel = true
        if StarLevel < 0 or StarLevel > 3 then
            error("本关设置星级超出可获得的范围")
        end
    elseif #Ids == 1 then
        self.IsStarLevel = false
    else
        error("本关奖励配置有误，请正确配置星级奖励或无星级奖励")
    end

    -- 奖励栏
    self.SizeBox_Rewards:ClearChildren()
    self.WidgetRewards = self:CreateWidgetNew("TempleItem")
    local RewardsInfo = {}
    if self.IsStarLevel then
        -- 星级关卡奖励栏
        local Avatar = GWorld:GetAvatar()
        local MaxTempleStar = 0
        local MaxTempleStar = Avatar.Dungeons[GameState.DungeonId].MaxStar or 0
        for i = 1, #Ids do
            local ItemData = self:GetFirstRewardInfoById(Ids[i])
            local Info = self:NewTempleContent(ItemData, i)
            table.insert(RewardsInfo, Info)
            RewardsInfo[i].bAsyncLoadIcon = true
        end
        self.WidgetRewards:SetStarRewards(RewardsInfo, StarLevel, MaxTempleStar)
    else
        -- 非星级关卡奖励栏
        if Ids[1] ~= nil then
            local ItemDatas = RewardUtils:GetAllRewardByRewardId(Ids[1])
            local Rewards = {}
            self:RewardsAddToArray(Rewards, ItemDatas, false)
            self:SortRewardsArray(Rewards)
            RewardsInfo = Rewards
        end
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
            error("Avatar is nil")
        end
        if Avatar.Dungeons[GameState.DungeonId] then
            self.WidgetRewards:SetNoStarRewards(RewardsInfo, true)
        end
    end
    self.WidgetRewards:SetVisibility(ESlateVisibility.Visable)
    self.SizeBox_Rewards:AddChild(self.WidgetRewards)

    -- 直接初始化奖励项目表
    self.RewardItems = {
        self.WidgetRewards.Item01,
        self.WidgetRewards.Item02,
        self.WidgetRewards.Item03,
        self.WidgetRewards.Item_Repeat
    }
    local ConfigData = {
        OwnerWidget = self.WidgetRewards,
        TextContent = GText("UI_Party_RewardDetail"),
        OnMenuOpenChangedCallBack = self.OnMenuOpenChangedCallBack,
    }
    self.WidgetRewards.Btn_Qa:Init(ConfigData)
    self.WidgetRewards.Btn_Qa:SetVisibility(ESlateVisibility.Visible)
end

function Menu_Level_PC_C:InitTraining()
    self.WidgetSwitcher_Type:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.BtnName[3]="UI_DUNGEON_DES_TRAINING_27"
    table.insert(self.BtnName, 'UI_DUNGEON_DES_TRAINING_28')
    table.insert(self.ClickFunction,  "OnClickExitGame")
end

function Menu_Level_PC_C:InitTrail()
    self.WidgetSwitcher_Type:SetVisibility(UIConst.VisibilityOp.Collapsed)
    table.insert(self.BtnName, 'UI_CharTrial_LeaveTitle')
    table.insert(self.ClickFunction,  "OnClickExitGame")
end

function Menu_Level_PC_C:InitHardBoss()
    self.WidgetSwitcher_Type:SetVisibility(UIConst.VisibilityOp.Collapsed)
    table.insert(self.BtnName, 'UI_HardBoss_TabName_2')
    table.insert(self.ClickFunction,  "OnClickExitGame")
end

function Menu_Level_PC_C:InitSpecialQuest()
    self.WidgetSwitcher_Type:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Panel_ExpGain:SetVisibility(UIConst.VisibilityOp.Collapsed)
    table.remove(self.BtnName, 3)
    table.remove(self.ClickFunction, 3)
    table.insert(self.BtnName, 'UI_SpecialQuest_GiveUp')
    table.insert(self.ClickFunction,  "OnClickExitGame")
    self.GamePadGiveUpKeyName="UI_SpecialQuest_GiveUp"
end
function Menu_Level_PC_C:InitRougeLike()
    if true then
        table.insert(self.BtnName,'UI_Rouge_ESC_HalfwayOut')
        table.insert(self.BtnName, 'UI_Rouge_ESC_EndOut')
        table.insert(self.ClickFunction,  "OnClickHalfwayOut")
        table.insert(self.ClickFunction, "OnClickExitGame")
    end
    self.WidgetSwitcher_Type:SetActiveWidgetIndex(1)
    if GWorld.RougeLikeManager then
        local Rooms=DataMgr.RougeLikeDifficulty[GWorld.RougeLikeManager.DifficultyId].RoomRandom or 1
        local RoomIndex=GWorld.RougeLikeManager.RoomIndex
        local RoomId=GWorld.RougeLikeManager.RoomId
        local PassRooms= GWorld.RougeLikeManager.PassRooms
        local WildcardSubsystem = UWildcardGameInstanceSubsystem.GetSubsystem(GWorld.GameInstance)
        local CurrentText=WildcardSubsystem:ReplaceWildcard(string.format(GText("UI_Rou_RoomCurrent"),RoomIndex))
        local TotalText=  WildcardSubsystem:ReplaceWildcard(string.format(GText("UI_Rou_RoomTotal"),#Rooms))
        self.Text_Now:SetText(CurrentText)
        self.Text_Total:SetText(TotalText)
        self.List_Route:ClearChildren()
        for i = 0, RoomIndex - 1 do
            local Item=self:CreateWidgetNew("RougeRouteItem")
            self.List_Route:AddChild(Item)
            if i==RoomIndex - 1  then
                Item:InitRouteItem(i+1,RoomId)
                Item:PlayPresentAnim()
            else
                Item:InitRouteItem(i+1,PassRooms[i+1])
                Item:PlayPassAnim()
            end
        end
        self.List_Route:ScrollToEnd()
        self:InitContractHeatPanel()
    end
end

function Menu_Level_PC_C:InitContractHeatPanel()
    if GWorld.RougeLikeManager then
        self.Contracts = GWorld.RougeLikeManager.Contract
    end

    local Avatar = GWorld:GetAvatar()
    local ContractModel = require "BluePrints.UI.UI_PC.RougeLike.PC.Contract.WBP_Rouge_Contract_Model"
    ContractModel:InitModel(Avatar)
    local CurrentHeatValue = ContractModel:GetCurrentHeatValue()

    if self.Contracts:Length() > 0 and CurrentHeatValue > 0 then
        self.SizeBox_HeatBtn:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Btn_Heat:OnListItemObjectSet({
            ParentWidget = self,
            BtnName = GText("UI_Rougelike_Contract_Name"),
            OnClickFunction = "OpenContractHeatPanel",
        })

        self.Text_Heat:SetText(CurrentHeatValue)
    end
end

function Menu_Level_PC_C:OpenContractHeatPanel()
    UIManager(GWorld.GameInstance):LoadUINew("RougeLikeMenuContractPanel")
end

function Menu_Level_PC_C:ReceiveEnterState(EnteredState)
	self.Super.ReceiveEnterState(self, EnteredState)
	if EnteredState == 1 then
		self:SetFocus()
        if self.CloseByChild then
            self:AddTimer(0.01,self.CloseSelf,false,0,nil,true)
        end
	end
end

function Menu_Level_PC_C:InitSetupList()
    self.BtnNums = #self.BtnName
    --local ClassPath = UE4.LoadClass('/Game/UI/WBP/Menu/Widget/Menu_Btn_Cell_Content_PC.Menu_Btn_Cell_Content_PC_C')
    local ClassPath = UIUtils.GetCommonItemContentClass()
    for i=1,self.BtnNums do
        local MenuContent = NewObject(ClassPath)
        MenuContent.Id = i
        MenuContent.BtnName = GText(self.BtnName[i])

        MenuContent.BtnIconPath=self.BtnIconPath[self.BtnName[i]]
        MenuContent.ParentWidget = self
        MenuContent.IsInRougeLike=self.InRougeLike
        if self.ClickFunction[i] ~= nil then
            MenuContent.OnClickFunction = self.ClickFunction[i]
        end
        local ItemName='Btn_'..tostring(i)
        if(self[ItemName]) then
            self[ItemName]:OnListItemObjectSet(MenuContent)
        end
    end
    for i=self.BtnNums+1,self.MaxBtnNum do
        local ItemName='Btn_'..tostring(i)
        if self[ItemName] then
            self[ItemName]:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end
end

function Menu_Level_PC_C:InitRoleItemInfos()
    if self.InAbyss or self.InFeinaEvent or self.InTemple or self.InParty then
        return
    end
    self.RoleItemInfos = {
        Char = {
            Widget = self.Settlement_Role
        },
        MeleeWeapon = {
            Widget = self.Settlement_Melee
        },
        RangedWeapon = {
            Widget = self.Settlement_Ranged
        },
        Player = {
            Widget = self.Settlement_Account
        }
    }
    self:CalcRoleAndRewardsInfo()
end

function Menu_Level_PC_C:CalcRoleAndRewardsInfo()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    self:CalcRoleInfo(Avatar)
    if  self.WidgetSwitcher_Type:GetVisibility()== UIConst.VisibilityOp.Collapsed then
        return
    end
    self.ScrollBox_RewardDrop:SetControlScrollbarInside(true)
    self:PreInitPropInfo()
    self:CalcPropInfo(Avatar)
end

function Menu_Level_PC_C:CalcPropInfo(Avatar)
    self.Rewards=Avatar:GetCachedDungeonRewards()
    if self.IsTemple then
        return
    end
    self.SpRewardsArray = {}-- 委托
    self.RewardsArray = {} -- 掉落物
    self.SpRewards={}
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local DungeonInfo = DataMgr.Dungeon[GameState.DungeonId]
    if DungeonInfo then
        self.IsDungeonTypeEndless = DungeonInfo.DungeonWinMode == CommonConst.DungeonWinMode.Endless
    end
    if self.IsDungeonTypeEndless then
        --local DungeonRewardArray=DungeonInfo.DungeonReward
        local CachedDungeonProgressRewards = Avatar:GetCachedDungeonProgressRewards()
        if GameState.DungeonProgress>1 then
            for i=1,GameState.DungeonProgress-1 do
                if CachedDungeonProgressRewards[i] then
                    for ItemType, Rewards in pairs(CachedDungeonProgressRewards[i]) do
                        for ItemId, ItemTable in pairs(Rewards) do
                            for Tag, Count in pairs(ItemTable) do
                                self:FillSpRewards(Tag, ItemType, ItemId, Count)
                            end
                        end
                    end
                end
            end
        end
    end
    self:RewardsAddToArray(self.SpRewardsArray, self.SpRewards, true)
    self:RewardsAddToArray(self.RewardsArray, self.Rewards, false)
    self:SortRewardsArray(self.SpRewardsArray)
    self:SortRewardsArray(self.RewardsArray)

    if #self.SpRewardsArray > 0 then
        self.Panel_Reward:SetVisibility(ESlateVisibility.Visible)
        self.Text_RewardTitle:SetText(GText("UI_DUNGEON_ObtainType"))
    else
        self.Panel_Reward:SetVisibility(ESlateVisibility.Collapsed)
    end
    if #self.RewardsArray then
        if Avatar and Avatar:IsInHardBoss() then
            self.Panel_PropTitle:SetVisibility(ESlateVisibility.Collapsed)
        else
            self.Panel_PropTitle:SetVisibility(ESlateVisibility.Visible)
            self.Text_PropTitle:SetText(GText("UI_DUNGEON_Drops"))
        end
    end
    -- self.TileView_Reward:DisableScroll(true)
    -- self.TileView_Prop:DisableScroll(true)
    -- self:AddTimer(0.01,function()
    --     self:InitRewardsInfo(self.SpRewardsArray, self.TileView_Reward)   --委托奖励
    --     self:InitRewardsInfo(self.RewardsArray, self.TileView_Prop)  --掉落物
    --     --没赢开启返还道具UI
    -- end
    self:AddTimer(0.01,function ()
        self:InitRewardsInfo(self.SpRewardsArray, self.TileView_Reward)   --委托奖励
        self:InitRewardsInfo(self.RewardsArray, self.TileView_Prop)  --掉落物
    end,false,0,nil,true)
end

function Menu_Level_PC_C:FillSpRewards(Tag,ItemType,ItemId,Count)
    DebugPrint("@@@ ESC FillSpRewards",Tag,ItemType,ItemId,Count)
  if not self.SpRewards[ItemType] then
            self.SpRewards[ItemType] = {}
        end
        if not self.SpRewards[ItemType][ItemId] then
            self.SpRewards[ItemType][ItemId] = {}
            self.SpRewards[ItemType][ItemId][tostring(Tag)] = Count
        else
            if not self.SpRewards[ItemType][ItemId][tostring(Tag)] then
                self.SpRewards[ItemType][ItemId][tostring(Tag)] = 0
            end
            self.SpRewards[ItemType][ItemId][tostring(Tag)] = self.SpRewards[ItemType][ItemId][tostring(Tag)] + Count
        end
end

function Menu_Level_PC_C:SortRewardsArray(RewardsArray)
    -- 排序优先级：通关奖励（特殊显示）、稀有度、类型、Id、额外奖励、数量
    table.sort(RewardsArray, function(a, b)
        if a.IsFirst ~= b.IsFirst then
            return a.IsFirst
        end
        if a.IsSpecial ~= b.IsSpecial then
            return a.IsSpecial
        end
        if a.Rarity ~= b.Rarity then
            return a.Rarity > b.Rarity
        end
        if a.Priority ~= b.Priority then
            return a.Priority > b.Priority
        end
        if a.Id ~= b.Id then
            return a.Id > b.Id
        end
        if a.IsBonus ~= b.IsBonus then
            return not a.IsBonus
        end
        if a.IsWalnut ~= b.IsWalnut then
            return not a.IsWalnut
        end
        if a.Count ~= b.Count then
            return a.Count > b.Count
        end
        return false
    end)
end


function Menu_Level_PC_C:RewardsAddToArray(TotalRewards, Rewards, IsSpecial)
    if not Rewards then
        return
    end
    -- Rewards
    -- {
    -- Type:{
    --     Id:{
    --         Normal:  Count_Normal, 
    --         Extra:   Count_Extra, 
    --         Walnut:  Count_Walnut,
    --         First:   count_First
    --         }
    --     }
    -- }
    local RewardTypes = DataMgr.RewardType
    for RewardType, RewardTypeValue in pairs(RewardTypes) do
        if not RewardTypeValue.DungeonRewardType then
            goto continue
        end
        local Reward = Rewards[RewardType.. "s"]
        --PrintTable(Reward, "@@@ESC Add Rewards Rewards")
        if not Reward then
            DebugPrint("@@@ESC Add Reward not have ", RewardType)
            goto continue
        end
        -- Reward
        -- Id:{
        --     Normal:  Count_Normal, 
        --     Extra:   Count_Extra, 
        --     Walnut:  Count_Walnut
        --     First:   count_First
        -- }

        for Id, NumTable in pairs(Reward) do
            -- NumTable
            -- {
            --     Normal:  Count_Normal, 
            --     Extra:   Count_Extra, 
            --     Walnut:  Count_Walnut
            --     First:   count_First
            -- }
            local NormalNum = RewardBox:FindCountByTag(NumTable, "Normal")
            local ExtraNum = RewardBox:FindCountByTag(NumTable, "Extra")
            local WalnutNum = RewardBox:FindCountByTag(NumTable, "Walnut")
            local FirstNum = RewardBox:FindCountByTag(NumTable, "First")
            local ResourceData = self:CreateOneReward(RewardType, RewardTypeValue, Id, NormalNum, IsSpecial, false, false, false,"Normal")
            local ExtraResourceData = self:CreateOneReward(RewardType, RewardTypeValue, Id, ExtraNum, IsSpecial, true, false, false,"Extra")
            local WalnutResourceData = self:CreateOneReward(RewardType, RewardTypeValue, Id, WalnutNum, IsSpecial, false, true, false,"Walnut")
            local FirstRewardData = self:CreateOneReward(RewardType, RewardTypeValue, Id, FirstNum, IsSpecial, false, false, true,"First")
            if ResourceData then
                table.insert(TotalRewards, ResourceData)
                DebugPrint("@@@ESC Add Resource Data:RewardType, RewardTypeValue, Id, NormalNum, IsSpecial", RewardType, RewardTypeValue, Id, NormalNum, IsSpecial)
            end
            if ExtraResourceData then
                DebugPrint("@@@ESC Add ExtraResourceData:RewardType, RewardTypeValue, Id, ExtraNum, IsSpecial", RewardType, RewardTypeValue, Id, ExtraNum, IsSpecial)
                table.insert(TotalRewards, ExtraResourceData)
            end
            if WalnutResourceData then
                DebugPrint("@@@ESC Add WalnutResourceData:RewardType, RewardTypeValue, Id, WalnutNum, IsSpecial", RewardType, RewardTypeValue, Id, WalnutNum, IsSpecial)
                table.insert(TotalRewards, WalnutResourceData)
            end
            if FirstRewardData then
                DebugPrint("@@@ESC Add FirstRewardData:RewardType, RewardTypeValue, Id, FirstNum, IsSpecial", RewardType, RewardTypeValue, Id, FirstNum, IsSpecial)
                table.insert(TotalRewards, FirstRewardData)
            end
        end
        ::continue::
    end
end

function Menu_Level_PC_C:CreateOneReward(RewardType, RewardTypeValue, Id, Num, IsSpecial, IsExtra, IsWalnut, IsFirst,RewardTag)
    if Num == 0 then
        return
    end
     local BonusType = nil
    if RewardTag == "Walnut" then
        BonusType = 3
    elseif RewardTag == "Extra" then
        BonusType = 1
    elseif RewardTag == "First" then  
        BonusType = 2
    end
    local RewardInfo = DataMgr[RewardType][tonumber(Id)]
    if RewardInfo then
        local ResourceData = {}

        ResourceData.Priority = RewardTypeValue.DungeonRewardSeq or 0
        ResourceData.Id = Id
        ResourceData.Count = Num
        ResourceData.Icon = RewardInfo.Icon
        ResourceData.Rarity = RewardInfo.Rarity or RewardInfo[RewardType.."Rarity"] or 0
        ResourceData.ItemType = RewardType
        ResourceData.IsSpecial = IsSpecial
        ResourceData.IsBonus = IsExtra
        ResourceData.IsWalnutBonus = IsWalnut
        ResourceData.IsFirst = IsFirst
        ResourceData.BonusType=BonusType

        return ResourceData
    else
        return
    end
end


function Menu_Level_PC_C:CalcRoleInfo(Avatar)
    local NowExps = self:SetNowExps()
    local InitSuccess=false
    for RoleName, Widget in pairs(self.RoleItemInfos) do
        local OldBattleInfo = self.PlayerState:GetOldBattleInfo(RoleName)
        local IncrsExps=self:CalcIncrsExps(NowExps)
        InitSuccess=Widget.Widget:SetItem(OldBattleInfo, RoleName, IncrsExps[RoleName], true,nil,not self.IsInCommonDungeon)
        Widget.Widget:SetVisibility(ESlateVisibility.Visible)
        Widget.Widget:PlayInAnimation()
    end
    if not InitSuccess then
        DebugPrint("ljh@:关卡ESC RoleInfo初始化失败")
        self.Panel_ExpGain:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end


function Menu_Level_PC_C:SetNowExps()
    local NowExps = {}
    for k, _ in pairs(self.RoleItemInfos) do
        NowExps[k] = 0
    end
    if  self.Player then
        if  self.Player.RangedWeapon then
            NowExps.RangedWeapon= self.Player.RangedWeapon:GetAttr("Exp")
            DebugPrint("ljh Current Exp:"..tostring(NowExps.RangedWeapon))
        end
        if  self.Player.MeleeWeapon then
            NowExps.MeleeWeapon= self.Player.MeleeWeapon:GetAttr("Exp")
            DebugPrint("ljh Current "..tostring(NowExps.MeleeWeapon))
        end
        NowExps.Char=self.Player:GetAttr("Exp")
    end
    return NowExps
end


function Menu_Level_PC_C:CalcIncrsExps(NowExps,RoleName)
    local IncrsExps = {}
    for k, _ in pairs(self.RoleItemInfos) do
        local CurrentLevel=1
        if k=="Player" then
            goto continue
        end
        if k=="Char" then
            CurrentLevel=self.Player:GetAttr("Level")
        end
        if k=="MeleeWeapon" then
            if  self.Player.MeleeWeapon then
                CurrentLevel= self.Player.MeleeWeapon:GetAttr("Level")
            end
        end
        if k=="RangedWeapon" then
            if  self.Player.RangedWeapon then
                CurrentLevel= self.Player.RangedWeapon:GetAttr("Level")
            end
        end
        local OldBattleInfo=self.PlayerState:GetOldBattleInfo(k)
        local SumMaxExp=0
        if CurrentLevel>OldBattleInfo.Level then
            for I=OldBattleInfo.Level,CurrentLevel-1 do
                SumMaxExp=SumMaxExp+self:GetRoleLevelMaxExp(k,I)
            end
        end
        IncrsExps[k] = NowExps[k]+SumMaxExp-OldBattleInfo.Exp
        ::continue::
    end
    return IncrsExps
end

function Menu_Level_PC_C:GetRoleLevelMaxExp(RoleName,Level)
    if RoleName == "Char" then
        return DataMgr.LevelUp[Level].CharLevelMaxExp
    elseif RoleName == "Player" then
        return DataMgr.PlayerLevelUp[Level].PlayerLevelMaxExp
    else
        return DataMgr.WeaponLevelUp[Level].WeaponLevelMaxExp
    end
end


function Menu_Level_PC_C:InitTimeInfo()
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
	self.Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    ---@type BP_SinglePlayerController_C
    self.PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    ---@type EMPlayerState
    self.PlayerState = self.PlayerController.PlayerState
    if self.PlayerState then
        self.PlayerTime =self.PlayerState:GetPlayerEndTime()
    else
         DebugPrint("Ljh PlayerTime: Empty PlayerState") 
        self.PlayerTime = 0
    end
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    if GameMode then
	    self.GameTime = GameMode.EMGameState:GetGameEndTime()
    end
    DebugPrint("Ljh PlayerTime:"..tostring(self.PlayerTime).." player start time"..tostring(self.PlayerState.PlayerStartTime).." Replicated Time Seconds:"..tostring(GameState.ReplicatedTimeSeconds))
end

function Menu_Level_PC_C:InitStageInfo()
    self:InitTimeInfo()
    --初始化Stage相关控件(后面正式迭代应该可以直接删除)
    --self:InitStageWidgets()
    --获取副本通关时间
    self:InitDungeonClearanceTime()
    --获取任务名称
    self:InitDungeonName()
    --设置Stage信息
    self.Time:SetTimeText(self.Describe, self.TimeDict)
end

function Menu_Level_PC_C:InitDungeonLevelIndex(DungeonId)
    local DungeonInfo = self:GetDungeonInfo(DungeonId)
    if DungeonInfo.DungeonType and DungeonInfo.DungeonType == "Temple" then
        return
    end
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if not GameState then 
        return 
    end

    local Index = 1
    local ChapterId = DataMgr.Dungeon2Select[GameState.DungeonId]
    if not ChapterId then 
        -- 如果是周本，则需要根据DungeonId2ChapterId表获取ChapterId
        ChapterId = DataMgr.DungeonId2ChapterId[GameState.DungeonId]
        if not ChapterId then 
            return
        end
        
        local DungeonList = DataMgr.WeeklySelectDungeon[ChapterId].DungeonList
        if not DungeonList then
            return 
        end
        
        -- 查找匹配的DungeonId
        for key, value in pairs(DungeonList) do
            if value == GameState.DungeonId then
                Index = key
                break  -- 使用 break 而不是 goto
            end
        end
    else
        local DungeonList = DataMgr.SelectDungeon[ChapterId].DungeonList
        if not DungeonList then 
            return 
        end
        
        -- 查找匹配的DungeonId
        for key, value in pairs(DungeonList) do
            if value == GameState.DungeonId then
                Index = key
                break  -- 使用 break 而不是 goto
            end
        end
    end
    local RomanNum = Const.RomanNum
    self.DungeonLevelIndex = GText(RomanNum[Index])
end

function Menu_Level_PC_C:PreInitPropInfo()
    self.IntervalTime = 1 / 15
    self.FirstDelayTime = 1 / 3 - self.IntervalTime
    self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
    self.TileView_Reward:ClearListItems()
    self.TileView_Prop:ClearListItems()
    self.TileView_Prop:SetVisibility(UIConst.VisibilityOp.Visible)
    self.TileView_Reward:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Text_None:SetText(GText("UI_NONE"))
    self.TileView_Reward.OnCreateEmptyContent:Bind(self, function()
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.ParentWidget = self
    return Content
    end)
    self.TileView_Reward.OnCreateEmptyContent:Bind(self, function()
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.ParentWidget = self
    return Content
    end)
end


function Menu_Level_PC_C:GetDungeonInfo(DungeonId)
    return DataMgr.Dungeon[DungeonId]
end

function Menu_Level_PC_C:GetDungeonName(DungeonInfo)
    return GText(DungeonInfo.DungeonName)
end

function Menu_Level_PC_C:InitDungeonName()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self.Describe = ""
    if Avatar:IsInDungeon() then
        local DungeonId = GWorld.GameInstance:GetCurrentDungeonId()
        self.DungeonInfo = self:GetDungeonInfo(DungeonId)
        self.Describe = self:GetDungeonName(self.DungeonInfo)
        self:InitDungeonLevelIndex(DungeonId)
    elseif Avatar:IsInHardBoss() then
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
            return
        end
        local HardBossId = Avatar.HardBossInfo.HardBossId
        self.Describe = GText(DataMgr.HardBossMain[HardBossId].HardBossName)
        self.Describe = self.Describe.." "..GText("UI_LEVEL_NAME")
        local DifficultyId = Avatar.HardBossInfo.DifficultyId
        local DifficultyLevel = ""
        if DifficultyId and DataMgr.HardBossDifficulty[DifficultyId] then
            DifficultyLevel = DataMgr.HardBossDifficulty[DifficultyId].DifficultyLevel
        end
        self.Describe = self.Describe..DifficultyLevel
    end
    if self.DungeonLevelIndex then 
        self.Describe = self.Describe..self.DungeonLevelIndex
        self.DungeonLevelIndex = nil
    end
end


function Menu_Level_PC_C:InitDungeonClearanceTime()
    if not self.PlayerTime then
        return
    end
    local Minute = math.floor(self.PlayerTime / 60)
    local Second = math.floor(self.PlayerTime % 60)  -- 服务端有概率CostTime传浮点数，强制转换一下
    self.TimeDict = {}
    table.insert(self.TimeDict, 1, {TimeType="Min", TimeValue=Minute})
    table.insert(self.TimeDict, 2, {TimeType="Sec", TimeValue=Second})
end

function Menu_Level_PC_C:InitRewardsInfo(RewardArr, RewardViewWidget)
    local DropItemNumEachRow, DropRowNum = UIUtils.GetTileViewContentMaxCount(RewardViewWidget, "XY", true)
    local RewardTotalNum = #RewardArr
    --switcher切换器默认是开启有奖励的状态，所以当当前奖励列表为空且委托和掉落奖励列表均为空的时候 切换到1状态 也就是没有奖励状态
    if RewardTotalNum < 1 and #self.SpRewardsArray == 0 and #self.RewardsArray == 0 then
        self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
        if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
            self:ShowOrHideGamepadRewardKey(false)
        end
    else
        --self.Switcher:SetActiveWidgetIndex(0)
        if #self.SpRewardsArray == 0 then
            DropRowNum = math.max(DropRowNum,2)
        end
        local MaxItemNum = DropRowNum * DropItemNumEachRow
        if RewardTotalNum > MaxItemNum then
            -- 若实际需要显示数量大于ListView能显示的最大数量MaxItemNum，
            -- 无视MaxItemNum，显示所有的道具并用空状态补满末行
            local RealRowNum = RewardTotalNum // DropItemNumEachRow
            if (RewardTotalNum % DropItemNumEachRow) ~= 0 then
                RealRowNum = RealRowNum + 1
            end
            MaxItemNum = RealRowNum * DropItemNumEachRow
            DebugPrint("@@@Esc Init RewardsInfo,Show all Item and AddEmpty Content: Maxitemnum, Realrownum, Dropitemnumeachrow", MaxItemNum, RealRowNum, DropItemNumEachRow)
            --self:ActivateDropPanelScrolling(true, RewardViewWidget)
        end
        DebugPrint("@@@Esc Init RewardsInfo: RewardTotalNum, Maxitemnum", RewardTotalNum, MaxItemNum)
        for i=1,MaxItemNum do
            RewardViewWidget:AddItem(self:NewPropContent(RewardArr[i]))
        end
        RewardViewWidget:SetEmptyGridItemCount(math.max(0,MaxItemNum - RewardTotalNum))
        -- local EmptyNum=math.max(0,MaxItemNum - RewardTotalNum)
        -- for i=1,EmptyNum do
        --     RewardViewWidget:AddItem(self:NewPropContent())
        -- end
        RewardViewWidget:DisableScroll(true)
        RewardViewWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
end

function Menu_Level_PC_C:NewPropContent(Content)
    ---@type WBP_Common_Item_Subsize_Small_Content_PC_C
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    if Content ~= nil then
        Obj.ParentWidget = self
        Obj.Id = Content.Id
        Obj.Count = Content.Count
        Obj.IsShowDetails=true
        Obj.AfterInitCallback = function(Widget)
            if self.IsAllowPropInAnimation and (not Widget.Content.IsPlayedInAnimation) then
                Widget:PlayInAnimation()
                Widget.Content.IsPlayedInAnimation = true
            else 
                Widget:PlayAnimation(Widget.Normal_In, Widget.Normal_In:GetEndTime())
            end

            --打开tips窗口监听
            self:OpenTipsBindEvents(Widget)
        end

        if Content.Icon then
            Obj.Icon = Content.Icon
        end
        DebugPrint("thy     Content.Icon", Content.Icon)
        Obj.Rarity = Content.Rarity
        Obj.IsShowDetails = true
        Obj.ItemType = Content.ItemType
        Obj.IsSpecial = Content.IsSpecial
        if Content.IsWalnutBonus then
            Obj.BonusType = 3
        end
        if Content.IsBonus then
            Obj.BonusType = 1
        end
        if Content.IsFirst then
            Obj.BonusType = 2
        end
        Obj.UIName = "MenuLevel"
    end
    return Obj
end

function Menu_Level_PC_C:OpenTipsBindEvents(Widget)
    local Events = {}
    Events.OnMenuOpenChanged = self.ItemMenuAnchorChanged
    Widget:BindEvents(self, Events)
end

function Menu_Level_PC_C:ItemMenuAnchorChanged()
    if UIManager(self):IsHaveMenuAnchorOpen() then
        self.KeyTips:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        -- 检查当前输入设备类型
        if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
            self.KeyTips:SetVisibility(UIConst.VisibilityOp.Visible)
        end
    end
end
--手柄模式下点击部分按钮，其他图标临时切换会PC图标(专用)
function  Menu_Level_PC_C:UpdateMainUIInGamePadClick()
    self.KeyTips:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:ShowOrHideGamepadRewardKey(false)
end

function  Menu_Level_PC_C:SwitchMainUIPCToGamePad()
    self.KeyTips:SetVisibility(UIConst.VisibilityOp.Visible)
    self:ShowOrHideGamepadRewardKey(true)
end

function Menu_Level_PC_C:UpdateMainUIWithPCOrMoble()
end

function Menu_Level_PC_C:SetFocusInGamePad()
    -- self.WidgetRewards.List_Reward:SetFocus()
    if self.InParty or self.InTemple then
        if self.IsStarLevel then
            self.WidgetRewards.Item01:SetFocus()
        else
            self.WidgetRewards.List_Reward:SetFocus()
        end
    end
end

function Menu_Level_PC_C:UpdateBottomTabsInfo()
end

function Menu_Level_PC_C:SwitchSelectedMode()
    if self.IsInViewMode then
        self.IsInViewMode=false
        self.GameInputModeSubsystem:SetTargetUIFocusWidget(self.Btn_1.Button_Area)
        self.GameInputModeSubsystem:UpdateCurrentFocusWidgetPos()
        self.KeyTips:UpdateKeyInfo({
            {
                KeyInfoList = {{Type = "Img", ImgShortPath = "X"}},
                Desc = GText(self.GamePadGiveUpKeyName),
            },
            {
                KeyInfoList = {{Type = "Img", ImgShortPath = "A"}},
                Desc = GText("UI_Tips_Ensure")
            },
            {
                KeyInfoList = {{Type = "Img", ImgShortPath = "B"}},
                Desc = GText("UI_Tips_Close")
            },
        })
        self:ShowOrHideGamepadRewardKey(true)
    else
        self.IsInViewMode=true
        self.SelectedIndex = 0
        if self.WidgetSwitcher_State:GetActiveWidgetIndex()==0 then
            self.TileView_Prop:SetFocus()
            self.KeyTips:UpdateKeyInfo({
                {
                    KeyInfoList = {{Type = "Img", ImgShortPath = "A"}},
                    Desc = GText("UI_Controller_CheckDetails")
                },
                {
                    KeyInfoList = {{Type = "Img", ImgShortPath = "B"}},
                    Desc = GText("UI_Tips_Close")
                },
            })
        end
        self:ShowOrHideGamepadRewardKey(false)
    end
end

function Menu_Level_PC_C:OnKeyDown(MyGeometry, InKeyEvent)
    -- 判断是否有二级界面存在

    local DungenonBattleCount = UIManager(self):GetUI("DungenonBattleCount")
    local CommonConfirmPanel = UIManager(self):GetUI("CommonConfirmPanel")
    local CommonDialogTip = UIManager(self):GetUI(UIConst.CommonDialogTip)
    local SettingSkill = UIManager(self):GetUI(UIConst.SkillDetails)
    local IsEventHandled=false
    if (DungenonBattleCount ~= nil or CommonConfirmPanel ~= nil or CommonDialogTip or SettingSkill) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if  (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if InKeyName== UIConst.GamePadKey.FaceButtonRight then
            IsEventHandled=true
            if self.IsInViewMode then
                self:SwitchSelectedMode()
            else
                self:CloseSelf()
            end
        elseif InKeyName==UIConst.GamePadKey.FaceButtonLeft then
            IsEventHandled=true
            self.PressedLogOut=true
        elseif InKeyName==UIConst.GamePadKey.LeftThumb then
            IsEventHandled=true
            self:SwitchSelectedMode()
        end
    end
    if self.InAbyss and self:OnKeyDownAbyss(InKeyName) then
        return true
    end
    if (InKeyName == "Escape") then
        if  self.CanCloseByHotKey then
            IsEventHandled=true
            self:CloseSelf()
        end
    -- elseif (InKeyName == "A" or InKeyName == "Left") then
    --     IsEventHandled=true
    --     if self.BtnIdx == 0 then
    --         self:SetCurIndexContent()
    --         return
    --     end
    --     AudioManager(self):PlayUISound(self, "event:/ui/common/esc_menu_highlight", "", nil)
    --     self.BtnIdx = math.max(0, self.BtnIdx - 1)
    --     self.List_Btn:SetSelectedIndex(self.BtnIdx)
    --     self:SetCurIndexContent()
    -- elseif (InKeyName == "D" or InKeyName == "Right") then
    --     IsEventHandled=true
    --     if self.BtnIdx == self.BtnNums - 1 then
    --         return
    --     end
    --     AudioManager(self):PlayUISound(self, "event:/ui/common/esc_menu_highlight", "", nil)
    --     self.BtnIdx = math.min(self.BtnNums-1, self.BtnIdx + 1)
    --     self.List_Btn:SetSelectedIndex(self.BtnIdx)
    -- elseif (InKeyName == "Enter") then
    --     IsEventHandled=true
    --     self[self.ClickFunction[self.BtnIdx + 1]](self)
    end
    return  IsEventHandled
end

function Menu_Level_PC_C:OnKeyUp(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    self.CanCloseByHotKey=true
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if (InKeyName == UIConst.GamePadKey.FaceButtonLeft) then
            IsEventHandled = true
            if self.PressedLogOut then
                self:OnClickExitGame()
                self.PressedLogOut=false
            end
            --self.Btn_LogOut:OnButtonReleased()
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end


function Menu_Level_PC_C:OnListBtnClicked(Content)
    UIUtils.PlayCommonBtnSe(self)
    if not self:IsPlayingAnimation(self.Out) then
    local SetUpListUI=Content.SelfWidget
    local function PlayAnimFinished()
        if self[Content.OnClickFunction] == nil then
            return
        end
        self[Content.OnClickFunction](self)

        if Content.Id then 
            self.BtnIdx = Content.Id - 1
        end
    end
    PlayAnimFinished()
end
end

function Menu_Level_PC_C:SetFirstSelect()
    local CurContent = self.List_Btn:GetItemAt(0)
    CurContent.SelfWidget:PlayAnimation(CurContent.SelfWidget.Select)
end


function Menu_Level_PC_C:OnClickContinueGame()
    self:CloseSelf()
end

function Menu_Level_PC_C:OnClickShowStatistics()
    UIManager(self):LoadUI(UIConst.DUNGEONBATTLECOUNT, "DungenonBattleCount", UIConst.ZORDER_FOR_SECONDARY_POPUP,nil,true)
end

function Menu_Level_PC_C:OnClickCommonSet()
    -- local Setting = UIManager(self):LoadUINew("Setting")
    -- if Setting then
    --     self:PlayOutAnim()
    -- end
    UIUtils.OpenSystem(26)
end

function Menu_Level_PC_C:OnClickExitGame()
    local PopupId=100001
    local Params = {}
    Params.RightCallbackObj = self
    Params.RightCallbackFunction = self.ClickConfirmExitInBattle
    if self.InHardBoss then 
        Params.RightCallbackFunction = self.ExitHardBossBattle
        PopupId=100028
    end
    if self.InSpecialQuest then
        Params.RightCallbackFunction=self.ExitHardBattle
        PopupId=100120
	    local Avatar = GWorld:GetAvatar()
	    if Avatar and Avatar.SpecialQuestId then
            local TempPopupId = DataMgr.SpecialQuestConfig[Avatar.SpecialQuestId].PopupUIId
            if TempPopupId then
                PopupId=TempPopupId
            end
        end
    end
    if self.InFeinaEvent or self.InSoloTreasure then
        PopupId=100229
    end
    if self.InRougeLike then
        Params.RightCallbackFunction = self.ExitRougeLike
        PopupId=100058
    end
    if self.InTemple then
        PopupId=100128
    end
    if self.InTraining then
        PopupId=100102
    end
    if self.InTrail then
        PopupId=100161
    end
    if self.InPaotaiEvent then
        Params.RightCallbackFunction = self.ExitPaotaiEvent
        PopupId=100226
    end
    if self.InMonsterRush then
        PopupId=100096
    end

	local Avatar = GWorld:GetAvatar()
	if Avatar and Avatar:IsInTeam() then
		PopupId = 100105
	end
    if self.IsInAutoChess then
        PopupId = 100096
    end
    UIManager(self):ShowCommonPopupUI(PopupId, Params,self)
end

function Menu_Level_PC_C:OnClickHalfwayOut()
    if GWorld.RougeLikeManager then
        GWorld.RougeLikeManager:HalfWayOut()
    end

end

function Menu_Level_PC_C:ExitRougeLike()
    if self.HasRequestedExit then
        return
    end
    self.HasRequestedExit=true
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:ExitBattle(false)
    end
    self:CloseSelf()
end

function Menu_Level_PC_C:OnClickSkill()
    local AnimObj = self:GetAnimationByName("Out")
    if self:IsAnimationPlaying(self.Out) then
        return
    end
        self:PlayAnimation(AnimObj)
        self:BindToAnimationFinished(AnimObj, {self, function()
            self:UnbindAllFromAnimationFinished(AnimObj)
            UIUtils.LoadPreviewSkillDetails(self,{
                OnClosedCallback = function() 
                    self:PlayInAnim() 
                end})
        end})
end


function Menu_Level_PC_C:ClickConfirmExitInBattle()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    if GameInstance ~= nil then
        local UIManager = GameInstance:GetGameUIManager()
        if UIManager ~= nil then
            local ExcavationUI = UIManager:GetUIObj("DungenonExcavation")
            if ExcavationUI ~= nil then
                ExcavationUI:StopWarning()
            end
        end
    end
    if self.HasRequestedExit then
        return
    end
    self.HasRequestedExit=true
    self:CloseSelf()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:ExitBattle(false, true)
    end
end

function Menu_Level_PC_C:ExitHardBossBattle()
    local CommonDialog = UIManager(self):GetUIObj("CommonDialog")
    if CommonDialog then
        CommonDialog:Close()
    end
    if self.HasRequestedExit then
        return
    end
    self.HasRequestedExit=true
    self:CloseSelf()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:ExitBattle(false, true)
    end
end

function Menu_Level_PC_C:ExitHardBattle()
    local CommonDialog = UIManager(self):GetUIObj("CommonDialog")
    if CommonDialog then
        CommonDialog:Close()
    end
    self:SetInputUIOnly(false)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    -- if IsStandAlone(Player) then
    --     local GameMode=UE4.UGameplayStatics.GetGameMode(Player)
    --     GameMode:SetGamePaused(UIConst.CommonSetUP,false)
    -- end
    DebugPrint("gyy@SpecialQuestFail,ExitSpecialQuest")
    EventManager:FireEvent(EventID.OnSpecialQuestFail, "Exit")
    self:CloseSelf()
end

function Menu_Level_PC_C:ExitPaotaiEvent()
    local CommonDialog = UIManager(self):GetUIObj("CommonDialog")
    if CommonDialog then
        CommonDialog:Close()
    end
    EventManager:FireEvent(EventID.EndCanonMiniGame)
    self:CloseSelf()
end

function Menu_Level_PC_C:CloseSelf()
    EventManager:FireEvent(EventID.OnDungeonEscClose)

    if self:IsAnimationPlaying(self.In) then
        return
    end
    local BattleMainUI = UIManager(self):GetUI('BattleMain')
    if (BattleMainUI ~= nil) then
        BattleMainUI:SetRenderOpacity(1)
    end
    local FeinaHud = UIManager(self):GetUI('FeinaEventHUD')
    if (FeinaHud ~= nil) then
            FeinaHud:PlayInAnim()
    end
    AudioManager(self):SetEventSoundParam(self, "EscMenuOpen", {ToEnd = 1})
    local AnimObj = self:GetAnimationByName("Out")
    if self:IsAnimationPlaying(self.Out) and not self.CloseByChild then
        return
    end
    self.CloseBySelf=true
    local function PlayAnimFinished()
        local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
        if IsStandAlone(Player) then
            Player:SetCanInteractiveTrigger(true)
        end
        self:Close()
    end
    if self.CloseByChild then
        PlayAnimFinished()
    else
        self:PlayAnimation(AnimObj)
        self:BindToAnimationFinished(AnimObj, {self, PlayAnimFinished})
    end
    self:RemoveInputMethodChangedListen()
end

function  Menu_Level_PC_C:SetPlayerInfo(Player)
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            local PlayerName =Avatar.Nickname
            local CurrentLevel=Avatar.Level
            local CurrentExp=Avatar.Exp
            local HeadIconId=Avatar.HeadIconId
            local MaxExp=nil
            local LevelInfo=DataMgr.PlayerLevelUp[CurrentLevel]
            local LevelName=GText("UI_Player_Level")
            if(LevelInfo) then MaxExp=LevelInfo.PlayerLevelMaxExp end
            if PlayerName ==nil or CurrentLevel==nil or CurrentExp==nil or MaxExp==nil then
                DebugPrint("[Esc] PlayerInfo is nil")
            end
            if CurrentLevel then self.Text_Level:SetText(GText(CurrentLevel)) end
            if PlayerName then self.Text_Name:SetText(GText(PlayerName)) end
            if LevelName then self.Text_LevelName:SetText(GText(LevelName)) end
            if HeadIconId then
                local Path=DataMgr.HeadSculpture[HeadIconId].HeadPath
                local ImageResource = LoadObject(Path)
                if ImageResource ~= nil then
                    local NpcMaterial = self.Image_Player:GetDynamicMaterial()
                    NpcMaterial:SetTextureParameterValue("IconMap", ImageResource)
                end
            end
            if CurrentExp~=nil and MaxExp~=nil then
            local Progress=CurrentExp/MaxExp
            local ProgressMaterial = self.Progress_Exp:GetDynamicMaterial()
            ProgressMaterial:SetScalarParameterValue("Percent",Progress)
            end
        end
        self.PlayerCurrentTag = Player:GetCharacterTag()
        if IsStandAlone(Player) then
        Player:SetCanInteractiveTrigger(false)
        end
end

function Menu_Level_PC_C:TempleRestart()
    local PopupId=100097
    local Params = {}
    Params.RightCallbackObj = self
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local GameMode=UE4.UGameplayStatics.GetGameMode(Player)
    if GameMode then
        Params.RightCallbackFunction = function ()
        GameMode:TriggerDungeonComponentFun("ResetPlayerLocation")
        self:CloseSelf()
        end
    end
    UIManager(self):ShowCommonPopupUI(PopupId, Params,self)
end


function Menu_Level_PC_C:PlayInAnim()
    self:StopAnimation(self.Out)
    self:PlayAnimation(self.In)
end

function Menu_Level_PC_C:PlayOutAnim()
    self:StopAnimation(self.In)
    self:PlayAnimation(self.Out)
end


-----以下为手柄
---
function Menu_Level_PC_C:AddInputMethodChangedListen()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice) 
    end
end

function Menu_Level_PC_C:RemoveInputMethodChangedListen()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice) 
    end
end

function Menu_Level_PC_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if self.InAbyss then
        self:RefreshAbyssUiWhenInputChange(CurInputDevice)
        return
    end
    if (IsUseKeyAndMouse) then
        self:InitKeyBoardView()
    elseif CurInputDevice==ECommonInputType.Gamepad then
        self:InitGamepadView()
    end
    -- 更新当前输入设备类型
    self.CurInputDeviceType = CurInputDevice
end

function Menu_Level_PC_C:InitGamepadView()
    if self:HasFocusedDescendants() or self:HasAnyUserFocus() then
        self:AddTimer(0.01,function() 
            self.GameInputModeSubsystem:SetTargetUIFocusWidget(self.Btn_1.Button_Area)
            self.GameInputModeSubsystem:UpdateCurrentFocusWidgetPos()
        end,false,0,nil,true)
    end
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.KeyTips:SetVisibility(UIConst.VisibilityOp.Visible)
    end
    self:ShowOrHideGamepadRewardKey(true)
end

function Menu_Level_PC_C:ShowOrHideGamepadRewardKey(show)
    if show then
        if self.WidgetSwitcher_State:GetActiveWidgetIndex()==0 then
            self.Key_Reward:SetVisibility(UIConst.VisibilityOp.Visible)
        end
    else
        self.Key_Reward:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function Menu_Level_PC_C:InitKeyBoardView()
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.KeyTips:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self:ShowOrHideGamepadRewardKey(false)
    end
end

function Menu_Level_PC_C:InitCommonButton()
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Key_Reward:CreateCommonKey({
            KeyInfoList = {
                {
                    ImgShortPath = "LS",
                    Type = "Img",
                }
            },
        })
        self.KeyTips:UpdateKeyInfo({
            {
                KeyInfoList = {{Type = "Img", ImgShortPath = "X"}},
                Desc = GText(self.GamePadGiveUpKeyName),
            },
            {
                KeyInfoList = {{Type = "Img", ImgShortPath = "A"}},
                Desc = GText("UI_Tips_Ensure")
            },
            {
                KeyInfoList = {{Type = "Img", ImgShortPath = "B"}},
                Desc = GText("UI_Tips_Close")
            },
        })
        self.KeyTips:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function Menu_Level_PC_C:GetFirstRewardInfoById(RewardId)
	local RewardInfo = {}
	local RewardData = DataMgr.Reward[RewardId]
	if not RewardData then
		return RewardInfo
	end
	local RewardTypes = RewardData.Type
	local RewardIds = RewardData.Id
    local RewardCounts = RewardData.Count
	if not RewardTypes or not RewardIds or not RewardCounts then
		return RewardInfo
	end
    RewardInfo.Type = RewardTypes[1]
    RewardInfo.Id = RewardIds[1]
    RewardInfo.Count = RewardCounts[1][1]
    local ItemInfo = DataMgr[RewardInfo.Type][RewardInfo.Id]
    if ItemInfo then
        RewardInfo.Name = ItemInfo.Name or ItemInfo[RewardInfo.Type.."Name"]
        RewardInfo.Rarity = ItemInfo.Rarity or ItemInfo[RewardInfo.Type.."Rarity"]
    end
	return RewardInfo
end

function Menu_Level_PC_C:NewTempleContent(Content, index)
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    if Content ~= nil then
        Obj.ParentWidget = self
        Obj.Id = Content.Id
        Obj.ItemType = Content.Type
        Obj.Count = Content.Count
        Obj.Icon = ItemUtils.GetItemIconPath(Content.Id, Content.Type)
        Obj.Rarity = Content.Rarity or 1
        Obj.IsShowDetails = true
        Obj.bHasGot = Content.IsGot or false
        Obj.UIName = "DungeonSettlement"
        Obj.AfterInitCallback = function(Widget) 
            if self.IsAllowPropInAnimation and (not Widget.Content.IsPlayedInAnimation) then
                Widget:PlayInAnimation()
                Widget.Content.IsPlayedInAnimation = true
            else 
                -- Widget:PlayAnimation(Widget.Normal_In, Widget.Normal_In:GetEndTime())
            end
        end
        Obj.OnMouseButtonUpEvents = {Obj = self, Callback = function()
            self.TempleNeedFocusItemIndex = index
        end}
    end
    return Obj
end

function Menu_Level_PC_C:OnMenuOpenChangedCallBack()
    -- 菜单栏状态改变回调
end

function Menu_Level_PC_C:DoNavigateLeft()
    if self.InParty or self.InTemple then
        self.RewardItems[3]:SetFocus()
    end
    return true
end

AssembleComponents(Menu_Level_PC_C)
return Menu_Level_PC_C
