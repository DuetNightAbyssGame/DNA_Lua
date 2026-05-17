require "Unlua"
local AutoChessConst = require "BluePrints.UI.AutoChess.AutoChessConst"
local ControllerFSM = require("Blueprints.UI.ControllerFSM")
local RewardModel = require "BluePrints.UI.AutoChess.WBP_AutoChess_Reward_Model"
local AutoChessUIController = {}

function AutoChessUIController:OnAutoChessMainRegistered(MainUI, JumpToLevelSelectPage, IsWin, First)
    self.MainUI = MainUI
    self.Model = require "BluePrints.UI.AutoChess.AutoChessDataModel"
    self:Init(JumpToLevelSelectPage, IsWin, First)
end

function AutoChessUIController:Init(MissionId, IsWin, First)
    self:InitControllerFSM()
    self.MainUI:InitView()    
    self.MainPageView = self.MainUI.MainPage
    self:BindViewEvents()
    self.MainPageView:InitEventTimeInfos(self.Model:GetEventInfo(), function() self:UpdateMainPageEventTimeInfo() end)

    if MissionId then
        -- 判断一下是随机还是线性关卡
        local SelectType = DataMgr.AutoChessMission[MissionId].MissionType
        self:ShowLevelSelectView(SelectType, MissionId, IsWin, First)
    end
end

function AutoChessUIController:BindViewEvents()
    local MainPageCallbacks = {
        OnBtnMonsterClicked = function() self:ShowMonsterView() end,
        OnBtnEquipmentClicked = function() self:ShowEquipmentView() end,
        OnBtnLinearLevelClicked = function() self:ShowLevelSelectView(AutoChessConst.LevelSelectType.Linear) end,
        OnBtnRandomLevelClicked = function() self:ShowLevelSelectView(AutoChessConst.LevelSelectType.Random) end,
        OnBtnOpenShopClicked = function() self:OpenAutoChessShop() end,
        OnBtnOpenQuestClicked = function() self:OpenAutoChessQuest() end,
    }
    self.MainPageView:BindEvents(MainPageCallbacks)
end


function AutoChessUIController:ShowMonsterView()
    AudioManager(self.MainUI):PlayUISound(self.MainUI, "event:/ui/activity/sub_btn_click", nil, nil)
    local MonstersPage = self.MainUI:PushSubPage("AutoChessMonstersPage", self.Model:GetChessData())
end

function AutoChessUIController:ShowEquipmentView()
    AudioManager(self.MainUI):PlayUISound(self.MainUI, "event:/ui/activity/sub_btn_click", nil, nil)
    local EquipsPage = self.MainUI:PushSubPage("AutoChessEquipsPage", self.Model:GetEquipsData())
    EquipsPage.OnEquipItemClickedCallback  = {self, self.OnEquipItemClicked}
end

function AutoChessUIController:ShowLevelSelectView(SelectType, MissionId, IsWin, First)
    DebugPrint("Tianyi@ ShowLevelSelectView, SelectType: "..tostring(SelectType))
    AudioManager(self.MainUI):PlayUISound(self.MainUI, "event:/ui/activity/auto_chess_main_level_btn_click", nil, nil)
    local LevelSelectPage = nil
    if SelectType == AutoChessConst.LevelSelectType.Linear then
        LevelSelectPage = self.MainUI:PushSubPage("AutoChessLevelSelectPage", SelectType, MissionId, IsWin, First)
    elseif SelectType == AutoChessConst.LevelSelectType.Random then
        LevelSelectPage = self.MainUI:PushSubPage("AutoChessLevelSelectPage", SelectType, MissionId, IsWin, First)
    end

    LevelSelectPage:BindEvents()
end

function AutoChessUIController:ShowMonsterDetails(AutoChessId)
    local AutoChessData = self.Model:GetMonsterInfoByCombatId(AutoChessId)
    local MonstersPage = self.MainUI:GetTopSubPage()
    if MonstersPage then
        MonstersPage:ShowChessDetails(AutoChessData)
    end
end

function AutoChessUIController:OpenAutoChessShop()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
    PageJumpUtils:JumpToTargetPageByJumpId(81)
end

function AutoChessUIController:OpenAutoChessQuest()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
    RewardModel:OpenReward(self)
end

function AutoChessUIController:UpdateMainPageEventTimeInfo()
    local EventTimeInfo = self.Model:GetEventInfo()
    self.MainPageView:InitEventTimeInfos(EventTimeInfo, function() self:UpdateMainPageEventTimeInfo() end)
end

function AutoChessUIController:OnEquipItemClicked(EquipId)
    self.Model:DecreaseEquipReddotById(EquipId)
end

function AutoChessUIController:OnMonsterItemClicked(CombatChessId)
    self.Model:DecreaseMonsterReddotById(CombatChessId)
end

-------------------------------------------------------------------
-- 手柄状态机
--------------------------------------------------------------------

function AutoChessUIController:InitControllerFSM()
    self.ControllerFSM = ControllerFSM.New(self, {
        [AutoChessConst.FSMStates.MainPage] = {
            OnEnter = self.OnEnterState_MainPage,
            OnLeave = self.OnLeaveState_MainPage,
        },
        [AutoChessConst.FSMStates.EquipsPage_Main] = {
            OnEnter = self.OnEnterState_EquipsPage_Main,
        },
        [AutoChessConst.FSMStates.MonsterPage_Main] = {
            OnEnter = self.OnEnterState_MonsterPage_Main,
        },
        [AutoChessConst.FSMStates.EquipsPage_FocusSort] = {
            OnEnter = self.OnEnterState_EquipsPage_FocusSort,
            OnLeave = self.OnLeaveState_EquipsPage_FocusSort,
        },
    })
end

function AutoChessUIController:UpdateTabKeyInfos(KeyInfos)
    if UIUtils.IsGamepadInput() then
        self.MainUI.Tab:UpdateBottomKeyInfo_Quick(KeyInfos)
    end
end

function AutoChessUIController:OnEnterState_MainPage()
end

function AutoChessUIController:OnEnterState_MonsterPage_Main()
end

function AutoChessUIController:OnEnterState_EquipsPage_Main()
end

function AutoChessUIController:OnEnterState_EquipsPage_FocusSort()
    local EquipsPage = self.MainUI:GetTopSubPage()
    if EquipsPage then
        EquipsPage:NavigateToSortFilter(true)
    end
end

function AutoChessUIController:OnLeaveState_EquipsPage_FocusSort()
    local EquipsPage = self.MainUI:GetTopSubPage()
    if EquipsPage then
        EquipsPage:NavigateToSortFilter(false)
    end
end



return AutoChessUIController