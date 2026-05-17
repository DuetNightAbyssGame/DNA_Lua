local TeamController = require "BluePrints.UI.WBP.Team.TeamController"
local TeamModel = TeamController:GetModel()
local Component = {}

---@param DungeonId number @副本Id
function Component:InitComp(DungeonId)
    self.CurrentDungeonId = DungeonId
    self.SelectYes = false
    local Team = TeamModel:GetTeam()
    self:BindEvents()
    self:AddDispatcher(EventID.TeamSelectWalnut, self, self.ReceiveTeammateChoose)
    self:AddDispatcher(EventID.WalnutSelectComplete, self, self.WalnutSelectComplete)
    self:AddDispatcher(EventID.TeamMatchOneRefused, self, self.TeamMatchOneRefused)

    self:AddDispatcher(EventID.TeamMatchStartEntering, self, self.CloseSelf)
    self:AddDispatcher(EventID.TeamMatchStartMatching, self, self.OnStartMatching)
    if not Team then
        self:StandaloneConstruct()
        self.IsStandAlone = true
    else
        self:MultiConstruct()
        self.IsStandAlone = false
        self:StartDeputeSelectCountDown()
        self:InitTeamHeads(Team.Members)
    end
    self:InitWalnuts()
    self:InitGameInputMode()
    self:PlayAnimation(self.In)
    EventManager:FireEvent(EventID.OnRefreshDeputeBtn, true)
end


function Component:OnClickButtonYes()
    local WalnutId = self.CurrentSelectContent.Id
    -- 不选核桃
    if WalnutId == nil then
        WalnutId = -1
    end
    local Content = self.CurrentSelectContent
    -- 如果数量为0，根据ActionType执行相应操作
    if Content and Content.Count == 0 and Content.ActionType then
        if Content.ActionType == "Purchase" then
            -- 购买逻辑
            local ShopType = Content.ShopType or "Shop"
            ShopUtils:ShowPurchaseDialog("Walnut", WalnutId, ShopType, self.UIName)
            return
        elseif Content.ActionType == "Jump" then
            if self.Btn_Yes.IsForbidden then
                UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Walnut_Toast_CanNotGet"))
                return
            end
            -- 跳转逻辑：调用 PageJumpUtils 的跳转
            local WalnutData = DataMgr["Walnut"][WalnutId]
            if WalnutData and WalnutData.AccessKey then
                -- 找到第一个可用的 AccessKey 进行跳转
                for _, AccessKey in pairs(WalnutData.AccessKey) do
                    if PageJumpUtils:ExecuteJumpByAccessKey(WalnutId, "Walnut", AccessKey, self.UIName) then
                        return
                    end
                end
            end
            return
        end
    end
    -- self.SendServerSelectContent = self.CurrentSelectContent
    local Avatar = GWorld:GetAvatar()
    -- local GameState = UE.UGameplayStatics.GetGameState(self)
    -- local DungeonId = GameState.DungeonId
    Avatar:SelectWalnut(self:ShowChooseSuccessToast(self.CurrentSelectContent), self.CurrentDungeonId, WalnutId)
    self.SelectYes = true
    EventManager:FireEvent(EventID.OnDisableEscOnDungeonLoading, true)
    if not self.IsStandAlone then
        EventManager:FireEvent(EventID.SelectedWalnut)
    else
        self:CloseSelf()
    end
end

function Component:OnClickButtonNo()
    local Avatar = GWorld:GetAvatar()
    if Avatar == nil then
        return
    end
    if Avatar:IsInTeam() then
        Avatar:VoteStartBattle(false, self:GetSquadId())
    end
    EventManager:FireEvent(EventID.OnRefreshDeputeBtn, false)
    self:CloseSelf()
end

function Component:OnBtnGiveUpClicked()
    local Avatar = GWorld:GetAvatar()
    if Avatar == nil then
        return
    end
    local CommonDialog = UIManager(self):ShowCommonPopupUI(100141, {
        RightCallbackObj = self,
        RightCallbackFunction = function(Obj, PackageData)
            if Avatar:IsInTeam() then
                Avatar:VoteStartBattle(false, self:GetSquadId())
            end
            self:CloseSelf()
        end,
        ForbiddenRightCallbackObj = self}, self)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_cancel", nil, nil)
end

--- 更新核桃选择信息
function Component:InitTeamHeads(PlayerArray)
    self.TeamHeadUI = {self.State_Mine, self.WBP_Walnut_PlayerState_1, self.WBP_Walnut_PlayerState_2, self.WBP_Walnut_PlayerState}
    self.TeamHeadTable = {}
    self.Uid2WalnutMap = {}
    self.TeamCount = #PlayerArray
    self.CurrentSelectCount = 0
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    for i, PlayerData in pairs(PlayerArray) do
        local Uid = PlayerData.Uid
        local TeamHead = self.TeamHeadUI[i].Team_Head
        TeamHead.Eid = Uid
        TeamHead:Init("Walnut", PlayerData, i, true, Avatar.Uid == PlayerData.Uid, self, true, TeamModel:IsTeamLeader(PlayerData.Uid))
        self.TeamHeadTable[PlayerData.Uid] = self.TeamHeadUI[i]
        self.TeamHeadUI[i]:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        -- local WalnutIcon = '/Game/UI/Texture/Static/Atlas/Common/T_Com_IconTips.T_Com_IconTips'
        self:ChangeStateIcon(self.TeamHeadUI[i].Item_Walnut, true, nil)
        -- local WalnutImg = LoadObject(WalnutIcon)
        -- self.TeamHeadUI[i].Item_Walnut.Img_Item:GetDynamicMaterial():SetTextureParameterValue("IconMap", WalnutImg)
        self.Uid2WalnutMap[Uid] = -1
        self.TeamHeadUI[i].Item_Walnut.Button_Area.OnClicked:Clear()
        self.TeamHeadUI[i].Item_Walnut.Button_Area.OnClicked:Add(self, function() self:OnItemWalnutClicked(self.TeamHeadUI[i].Item_Walnut) end)
    end
    for i = self.TeamCount + 1, 4 do
        local TeamHead = self.TeamHeadUI[i]
        TeamHead:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end
function Component:SetDefaultSelect(TeamHead, AllTeamHead)
    -- 未装备
    TeamHead:SetIsChosenState(true)
    local WalnutIcon = '/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_Forbid.T_Armory_Forbid'
    -- local WalnutImg = LoadObject(WalnutIcon)
    -- AllTeamHead.Item_Walnut.Img_Item:GetDynamicMaterial():SetTextureParameterValue("IconMap", WalnutImg)
    self:ChangeStateIcon(AllTeamHead.Item_Walnut, false, WalnutIcon)
    AllTeamHead.Text_State:SetText(GText("UI_Walnut_Not_Select"))
end

--- 刷新队友核桃选择信息
---@param Uid number @玩家Uid
---@param WalnutId number @核桃id
function Component:ReceiveTeammateChoose(Uid, WalnutId)
    local AllTeamHead = self.TeamHeadTable[Uid]
    local TeamHead = AllTeamHead.Team_Head
    local ItemWalnut = AllTeamHead.Item_Walnut
    ItemWalnut.WalnutId = WalnutId
    if WalnutId == -1 then
        -- 未装备
        self:SetDefaultSelect(TeamHead, AllTeamHead)
        -- TeamHead:SetIsChosenState(true)
        -- local WalnutIcon = '/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_Forbid.T_Armory_Forbid'
        -- local WalnutImg = LoadObject(WalnutIcon)
        -- AllTeamHead.Item_Walnut.Img_Item:GetDynamicMaterial():SetTextureParameterValue("IconMap", WalnutImg)
        AllTeamHead.Text_State:SetText(GText("UI_Walnut_Not_Select"))
    else
        TeamHead:SetIsChosenState(true)
        --ItemWalnut.Item_Walnut:SetVisibility(UE4.ESlateVisibility.Visible)
        local WalnutData = DataMgr["Walnut"][WalnutId]
        local WalnutType = WalnutData.WalnutType
        local WalnutTypeData = DataMgr["WalnutType"][WalnutType]
        local WalnutIcon = WalnutData.Icon
        self:ChangeStateIcon(AllTeamHead.Item_Walnut, false, WalnutIcon)
        -- AllTeamHead.Item_Walnut.Img_Item:GetDynamicMaterial():SetTextureParameterValue("IconMap", LoadObject(WalnutIcon))
        local WalnutNumber = WalnutData.WalnutNumber
        local NumberString = tostring(WalnutNumber)
        local NumberStringLen = string.len(NumberString)
        for i = 1, 3 - NumberStringLen do
            NumberString = '0'..NumberString
        end
        AllTeamHead.Text_State:SetText(GText(WalnutData.Name))
    end
    self.Uid2WalnutMap[Uid] = WalnutId
end

-- 选择核桃准备完成
function Component:PlayWalnutReady()
    self:PlayAnimation(self.LayoutRefresh)
    self.WalnutChoiceFinish = 1
    self:StartDeputeWalnutReadyCountDown()
    self.Btn_No.Button_Area.OnClicked:Clear()
    self.Btn_No.Button_Area.OnClicked:Add(self, self.OnBtnGiveUpClicked)
end

--- 完成选择页面
function Component:WalnutSelectComplete()
    for Uid, WalnutId in pairs(self.Uid2WalnutMap) do
        if WalnutId == -1 then
            local AllTeamHead = self.TeamHeadTable[Uid]
            local TeamHead = AllTeamHead.Team_Head
            self:SetDefaultSelect(TeamHead, AllTeamHead)
        end
    end
    self.Panel_Yes:SetVisibility(ESlateVisibility.Collapsed)
    self:RemoveTimer("WalnutSelectCountDown")
    self:PlayWalnutReady()
end

--- 计算当前倒计时（委托页面）
function Component:GetDeputeWalnutCountDown(StartTime, CountDownTime)
    local GameState = UGameplayStatics.GetGameState(self)
    return CountDownTime - (GameState.ReplicatedRealTimeSeconds - StartTime)
end

--- 委托页面开始选择核桃倒计时
function Component:StartDeputeSelectCountDown()
    self.Text_CountDown:SetText(DataMgr.GlobalConstant.WalnutSelectTime.ConstantValue)
    self.Text_CountDown_1:SetText(DataMgr.GlobalConstant.WalnutSelectTime.ConstantValue)
    local GameState = UGameplayStatics.GetGameState(self)
    self.ReadyTime = GameState.ReplicatedRealTimeSeconds
    self.WalnutCountDownNumber = 0
    self:AddTimer(0.5, self.DeputeWalnutSelectCountDown, true, 0, "WalnutSelectCountDown")
end

--- 委托页面核桃选择完成后开启倒计时
function Component:StartDeputeWalnutReadyCountDown()
    self.Text_Choose_Multi:SetText(GText("UI_Walnut_Begin"))
    self.Text_CountDown:SetText(DataMgr.GlobalConstant.WalnutDungeonReadyTime.ConstantValue)
    self.Text_CountDown_1:SetText(DataMgr.GlobalConstant.WalnutDungeonReadyTime.ConstantValue)
    local GameState = UGameplayStatics.GetGameState(self)
    self.ReadyTime = GameState.ReplicatedRealTimeSeconds
    self.WalnutCountDownNumber = 0
    self:AddTimer(0.5, self.DeputeWalnutReadyCountDown, true, 0, "WalnutReadyCountDown")
end

--- 显示核桃选择倒计时（委托页面）
function Component:DeputeWalnutSelectCountDown()
    self:DisplayCountDown(self.ReadyTime, DataMgr.GlobalConstant.WalnutSelectTime.ConstantValue, "WalnutSelectCountDown")
end

--- 显示核桃选择完成等待倒计时（委托页面）
function Component:DeputeWalnutReadyCountDown()
    self:DisplayCountDown(self.ReadyTime, DataMgr.GlobalConstant.WalnutDungeonReadyTime.ConstantValue, "WalnutReadyCountDown")
end

--- 显示倒计时（通用函数）
function Component:DisplayCountDown(ReadyTime, CountDownTime, TimerName)
    local CurrentCountDown = self:GetDeputeWalnutCountDown(ReadyTime, CountDownTime)
    CurrentCountDown = math.floor(CurrentCountDown)
    if TimerName == "WalnutReadyCountDown" and self.WalnutCountDownNumber ~= CurrentCountDown then
        self.WalnutCountDownNumber = CurrentCountDown
        self:PlayAnimation(self.RefreshCountDown)
        AudioManager(self):PlayUISound(self, "event:/ui/common/mihan_level_before_choose_count_down", nil, nil)
    end
    if CurrentCountDown < 0 then
        CurrentCountDown = 0
    end
    local CurrentCountDownStr = string.format("%d", CurrentCountDown)

    self.Text_CountDown:SetText(CurrentCountDownStr)
    self.Text_CountDown_1:SetText(CurrentCountDownStr)

    -- 计时结束时移除定时器
    if CurrentCountDown < 1 then
        self:RemoveTimer(TimerName)
    end
end

--- 队友放弃
function Component:TeamMatchOneRefused(Uid)
    if not TeamModel:IsYourself(Uid) then
        UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Walnut_Giveup_Toast"), GText(TeamModel:GetTeamMember(Uid).Nickname)), 1.5)
    end
    self:CloseSelf()
end

function Component:CloseSelf()
    if self:IsAnimationPlaying(self.Auto_Out) then
        return
    end
    self:PlayAnimation(self.Auto_Out)
    self:Close()
end

function Component:OnStartMatching()
    DebugPrint("gmy@WBP_Depute_Walnut_ChoiceComp_C Component:OnStartMatching")
    -- 尝试打开或者切换到匹配状态
    if not UIManager(self):GetUIObj("DungeonMatchTimingBar") then
        DebugPrint("gmy@WBP_Depute_Walnut_ChoiceComp_C Component:OnStartMatching", 222)
        UIManager(self):LoadUINew("DungeonMatchTimingBar", self.CurrentDungeonId, Const.DUNGEON_MATCH_BAR_STATE.WAITING_MATCHING)
    end
    self:CloseSelf()
end


function Component:GetSquadId()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local DungeonInfo = Avatar.Dungeons[self.CurrentDungeonId]
        if DungeonInfo and DungeonInfo.Squad then
            return DungeonInfo.Squad
        end
    end

    return 1
end
function Component:CloseByEscape()
    local Avatar = GWorld:GetAvatar()
    if Avatar and not Avatar:IsInTeam() then
        EventManager:FireEvent(EventID.OnRefreshDeputeBtn, false)
        self:Close()
        return true
    end
end
return Component