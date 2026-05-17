require "UnLua"
local UIUtils = require "Utils.UIUtils"
local TimeUtils = require "Utils.TimeUtils"
local AutoChessConst = require "BluePrints.UI.AutoChess.AutoChessConst"
local View = Class({
    "BluePrints.UI.BP_UIState_C",
    "Blueprints.UI.AutoChess.AutoChessPageInterface",
    "BluePrints.Common.TimerMgr",
})

local LevelState = {
    Pass = 0, --已首通
    UnPass = 1, --解锁未首通
    UnLock = 2, --未解锁
}
local ActiveId = 103016
local Model = require  "BluePrints.UI.AutoChess.AutoChessDataModel"

function View:InitView(Type, MissionId, IsWin, First)
    DebugPrint("Tianyi@ AutoChessLevelSelectPage InitView, Type: "..tostring(Type))
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "SelectOpen", nil)
    self.Type = Type
    self.SelectedItem = nil
    self.LinearList = {}
    for Id, Info in pairs(DataMgr.AutoChessMission) do
        if Info.MissionType == 1 then
            table.insert(self.LinearList, Id)
        end
    end
    if Type == AutoChessConst.LevelSelectType.Linear then
        if MissionId and IsWin and First then
            local Rank = DataMgr.AutoChessMission[MissionId].UnlockRankID
            if Rank then
                UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_AutoChess_RankUpToast"))
            end
        end
        self.WS_Type:SetActiveWidgetIndex(0)
        self.BG:PlayAnimation(self.BG.BG01_In)
        self:AddTimer(0.01, function()  
            self:InitListView()
            self:LinearInit()
            self:InitLinearRank()
        end, false, 0, nil, true)
    elseif Type == AutoChessConst.LevelSelectType.Random then
        self.WS_Type:SetActiveWidgetIndex(1)
        self.BG:PlayAnimation(self.BG.BG02_In)
        self:RandomInit()
    end
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnUpdateUIStyleByInputTypeChange)
    self:OnUpdateUIStyleByInputTypeChange(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    self:InitGamePad()
end

function View:BindEvents()
    self.Details.Btn_Challenge.Button_Area.OnClicked:Add(self, self.OnClickEnter)
    self.Details.Btn_Refresh:BindEventOnClicked(self, self.OnClickRefresh)
    self.List_Linear.OnUserScrolled:Add(self, self.OnUserScrolled)
    self.List_Linear.OnMouseButtonUp:Add(self, self.ScrollBoxOnMouseButtonUp)
    self.Arrow_R.Btn_Click.OnClicked:Add(self, self.OnBtnRClicked)
    self.Arrow_L.Btn_Click.OnClicked:Add(self, self.OnBtnLClicked)
end


function View:LinearInit()
    self:AddEmptySlot()
    self.Length = #self.LinearList
    for Index, Id in pairs(self.LinearList) do
        local Obj = self:CreateWidgetNew("AutoChessLinearLevel")
        if not self.ItemSizeX then
            local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(Obj.BG)
            self.ItemSizeX = CanvasSlot:GetSize().X
        end
        if not self.SumDistance then
            self:CalculateSumDistance()
        end
        local Param = {}
        if Index < self.Length then
            Param.NextState = self:GetState(self.LinearList[Index + 1])
        end
        Param.Id = Id
        Param.Index = Index
        Param.bFinal = Index == self.Length 
        Param.State = self:GetState(Id)
        Param.Parent = self
        Obj:Init(Param, self)
        Obj:BindEventOnClicked(self,self.UpdateSelectedInfo,Obj)
        self.List_Linear:AddChild(Obj)
    end
    self:AddEmptySlot()
    self.List_Linear:SetScrollOffset(0)
    self.SelectedItem = self:FindFirstItem()
    if self.SelectedItem then
        self:UpdateSelectedInfo(self.SelectedItem,nil, false )
        --self.SelectedItem:OnCellClicked(nil, false)
    end
end


function View:FindFirstItem()
    local AllChildren = self.List_Linear:GetAllChildren()
    for i=1,AllChildren:Length() do
        local ChildItem = AllChildren:GetRef(i)
        if ChildItem.State and ChildItem.State == LevelState.UnPass then
            return ChildItem
        end
    end
    for i = AllChildren:Length(), 1, -1 do  
        local ChildItem = AllChildren:GetRef(i)
        if ChildItem.State and ChildItem.State == LevelState.Pass then
            return ChildItem
        end
    end
end

function View:OnBtnRClicked()
    local NextIndex = self.SelectedItem.Index+1
    if NextIndex <= self.Length then
        self:SelectItem(NextIndex)
    end
end

function View:OnBtnLClicked()
    local NextIndex = self.SelectedItem.Index-1
    if NextIndex >= 1 then
        self:SelectItem(NextIndex)
    end
end

function View:RandomInit()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    self.RandomId = Avatar.AutoChess.RandomMissionId
    local DungeonId = DataMgr.AutoChessMission[self.RandomId].DungeonId
    self.Level_Random.Text_Name:SetText(GText(DataMgr.Dungeon[DungeonId].DungeonName))
    self:UpdateRandomDetail()
end

function View:AddEmptySlot()
    local Obj = self:CreateWidgetNew("AutoChessLinearLevel")
    local Param = {}
    Param.Id = -1
    Param.Index = 0
    Param.Size = self.ListSizeX
    Obj:Init(Param)
    self.List_Linear:AddChild(Obj)
end

function View:InitListView()
    self.ChangeSpeedSlow = 5
    if not self.ListSizeX then
        local HpBarGeometry = self.Panel_List_Cut:GetTickSpaceGeometry()
        local Size = UE4.USlateBlueprintLibrary.GetLocalSize(HpBarGeometry)
        self.ListSizeX = Size.X
    end
end

function View:CalculateSumDistance()
    self.SumDistance = (self.Length-1)*self.ItemSizeX
end

function View:GetTargetIndex(Offset)
    local EndOffset = self.List_Linear:GetScrollOffsetOfEnd()
    local EachItemOffset = EndOffset/(self.Length-1)
    return math.floor((Offset+EachItemOffset/2)/EachItemOffset)+1
end

function View:GetTargetOffsetByIndex(Index)
    local EndOffset = self.List_Linear:GetScrollOffsetOfEnd()
    return (Index-1)*(EndOffset/(self.Length-1))
end

function View:OnUserScrolled(CurrentOffset)
    self:ScrolledTo(CurrentOffset, false)
    if not self.DragScrollBox then
        self:AddTimer(0.3, self.ScrollBoxOnMouseButtonUp, false, 0, "ScrollBoxUserScrolledEnd", true)
    end
end

function View:ScrolledTo(CurrentOffset, isAutoScroll)
    if isAutoScroll == false then
        local TargetIndex = self:GetTargetIndex(CurrentOffset)
        if self.SelectedItem.Index ~= TargetIndex then
            local Item = self.List_Linear:GetChildAt(TargetIndex)
            if Item then
                Item:OnCellClicked(nil, true)
            end
        end
    end
end

function View:ScrollBoxOnMouseButtonUp(Geometry, MouseEvent)
    self.DragScrollBox = false
    self.List_Linear:EndInertialScrolling()
    local CurrentOffset = self.List_Linear:GetScrollOffset()
    local TargetIndex = self:GetTargetIndex(CurrentOffset)
    if self.SelectedItem.Index ~= TargetIndex then
        self:SelectItem(TargetIndex)
    else
        local TargetOffset = self:GetTargetOffsetByIndex(TargetIndex)
        self:ScrollToTargetOffset(CurrentOffset, TargetOffset, self.ChangeSpeedSlow)
    end
end

function View:SelectItem(Index)
    local Item = self.List_Linear:GetChildAt(Index)
    if Item then
        Item:OnCellClicked()
    end
end

function View:ScrollToTargetOffset(CurrentOffset, TargetOffset, ChangeSpeed)
    self.List_Linear:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.LerpAlpha = 0
    self.ScrollTimer = self:AddTimer(0.033,function(_,DeltaTime)
        self.LerpAlpha = self.LerpAlpha + ChangeSpeed * DeltaTime
        if(self.LerpAlpha >= 1)then
            self.LerpAlpha = 1
            self.List_Linear:SetScrollOffset(TargetOffset)
            self:ScrolledTo(TargetOffset)
            self.List_Linear:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            self:RemoveTimer(self.ScrollTimer)
            self.ScrollTimer = nil
            return
        end
        local Offset = UE4.UKismetMathLibrary.Lerp(CurrentOffset,TargetOffset,self.LerpAlpha)
        self.List_Linear:SetScrollOffset(Offset)
        self:ScrolledTo(Offset)
    end, true, 0, "UpdateOffset", true, 0.033)
end

function View:Destruct()
    self.Super.Destruct(self)
    self:RemoveTimer("ScrollBoxUserScrolledEnd")
end

function View:UpdateSelectedInfo(ExperienceItem, Speed, isDragSelect)
    if not Speed then
        Speed = self.ChangeSpeedSlow
    end
    if self.SelectedItem and self.SelectedItem ~= ExperienceItem then
        self.SelectedItem:OnUnSelected()
    end
    self.SelectedItem = ExperienceItem
    self.SelectedItem:OnSelected()
    self:AddTimer(0.01, function()
        local CurrentOffset = self.List_Linear:GetScrollOffset()
        local TargetOffset = self:GetTargetOffsetByIndex(self.SelectedItem.Index)
        if isDragSelect ~= true then
            self:ScrollToTargetOffset(CurrentOffset, TargetOffset, Speed)
        end
    end,false, 0, nil, true)
    self:UpdateArrow()
    self:UpdateLinearDetail()
end

function View:UpdateArrow()
    if self.SelectedItem.Index == 1 then
        self.Arrow_L:PlayAnimation(self.Arrow_L.Foridden)
    else
        self.Arrow_L:PlayAnimation(self.Arrow_L.Normal)
    end
    if self.SelectedItem.Index == self.Length then
        self.Arrow_R:PlayAnimation(self.Arrow_R.Foridden)     
    else
        self.Arrow_R:PlayAnimation(self.Arrow_R.Normal)
    end
end

function View:UpdateLinearDetail()
    self.Details:PlayAnimation(self.Details.Change)
    local Info = DataMgr.AutoChessMission[self.SelectedItem.Id]
    self.Details.Text_Name:SetText(GText(DataMgr.Dungeon[Info.DungeonId].DungeonName))
    self.Details.WS_Type:SetActiveWidgetIndex(0)
    local State = self.SelectedItem.State
    self:InitRankInfo(Info, State)
    self.Details.List_Condition:ClearListItems()
    self.Details.List_Enemy:ClearListItems()
    self.Details.List_Buff:ClearListItems()
    self.Details.List_Reward:ClearListItems()
    self.Details.Text_Condition:SetText(GText("UI_AutoChess_UnlockInfo"))
    if State ~= LevelState.UnLock then
        self.Details.Panel_Enemy:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Details.Panel_Buff:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Details.Panel_Reward:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self:InitCondition(Info, State)
        self:InitEnemy(Info)
        self:InitBuff(Info)
        self:InitReward(Info)
        self:InitBtn()
    else
        self:InitCondition(Info, State)
        self.Details.Panel_Enemy:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Details.Panel_Buff:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Details.Panel_Reward:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Details.Btn_Refresh:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Details.WS_Btn:SetActiveWidgetIndex(1)
        self.Details.Btn_Lock.Text_Button:SetText(GText("UI_AutoChess_MissionEntryUnlock"))
    end
end

function View:InitRankInfo(Info, State)
    if Info.UnlockRankID then
        self.Details.Panel_RankUp:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Details.Text_RankUp:SetTexT(GText("UI_AutoChess_RankLimitUpAfter"))
        local RankInfo = DataMgr.AutoChessPoint[Info.UnlockRankID]
        self.Details.Icon_Rank:SetBrushResourceObject(LoadObject(RankInfo.RankIcon))
        if State == LevelState.Pass then
            self.Details:PlayAnimation(self.Details.Rank_Complete)
        else
            self.Details:PlayAnimation(self.Details.Rank_Normal)
        end
    else
        self.Details.Panel_RankUp:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function View:InitCondition(Info, State)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    if Info.UnlockMissionId then
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.State = State
        local PreDungeonId = DataMgr.AutoChessMission[Info.UnlockMissionId].DungeonId
        local Language = CommonConst.SystemLanguage
        Content.Text = nil
        if Language == CommonConst.SystemLanguages.KR then
            Content.Text = GText(DataMgr.Dungeon[PreDungeonId].DungeonName).." "..GText("UI_AutoChess_CompleteText")
        else
            Content.Text = GText("UI_AutoChess_CompleteText")..GText(DataMgr.Dungeon[PreDungeonId].DungeonName)
        end
        local bPrePass = false
        if Avatar.Dungeons[PreDungeonId] and Avatar.Dungeons[PreDungeonId].IsPass then
            bPrePass = true
        else
            bPrePass = false
        end
        if bPrePass then
            Content.Success = true
        else
            Content.Success = false
        end 
        self.Details.List_Condition:AddItem(Content)
    end
    if Info.UnlockDay then
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        local TimeUnlock = self:CheckUnlockDay(Info)
        if TimeUnlock then
            Content.Success = true
        else
            Content.Success = false
        end   
        Content.Text = GText(Info.UnlockText)
        self.Details.List_Condition:AddItem(Content)
    end
    if self.Details.List_Condition:GetNumItems() <= 0 then
        self.Details.WS_Type:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        self.Details.WS_Type:SetVisibility(UIConst.VisibilityOp.Visible)
    end
end

function View:InitEnemy(Info)
    if not Info then return end
    self.Details.Text_Enemy:SetText(GText("UI_AutoChess_EnemyInfo"))
    local MosterInfoData = Model:GetMonsterInfoByMissionId(Info.MissionId)
    for Index = 1, #MosterInfoData do
        local Row = MosterInfoData[Index]
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.AutoChessId = Row.MonsterId
        Content.EquipCount = #Row.EquipList
        Content.MissionId = nil
        if self.SelectedItem then
            Content.MissionId = self.SelectedItem.Id
        else   
            Content.MissionId = self.RandomId
        end
        self.Details.List_Enemy:AddItem(Content)
    end
end

function View:InitBuff(Info)
    if not Info then return end
    self.Details.Text_Buff:SetText(GText("UI_AutoChess_BuffInfo"))
    local MissionId = nil
    if self.SelectedItem then
        MissionId = self.SelectedItem.Id
    else   
        MissionId = self.RandomId
    end
    if Info.RegularBuffId then
        local BuffInfo = DataMgr.AutoChessBuff[Info.RegularBuffId]
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.Path = BuffInfo.BuffIcon
        Content.MissionId = MissionId
        self.Details.List_Buff:AddItem(Content)
    end
    if Info.SpecifyBuffId then
        for key, value in pairs(Info.SpecifyBuffId) do
            local BuffInfo = DataMgr.AutoChessBuff[value]
            local Content = NewObject(UIUtils.GetCommonItemContentClass())
            Content.Path = BuffInfo.BuffIcon
            Content.MissionId = MissionId
            self.Details.List_Buff:AddItem(Content)
        end
    end
    if self.Type == AutoChessConst.LevelSelectType.Random then
        local Avatar = GWorld:GetAvatar()
        if not Avatar then return end
        local Buff = Avatar.AutoChess.RandomBuffList
        for key, value in pairs(Buff) do
            local BuffInfo = DataMgr.AutoChessBuff[value]
            local Content = NewObject(UIUtils.GetCommonItemContentClass())
            Content.Path = BuffInfo.BuffIcon
            Content.MissionId = MissionId
            self.Details.List_Buff:AddItem(Content)
        end
    end
end

function View:OnClickBuff()
    local MissionId = nil
    if self.SelectedItem then
        MissionId = self.SelectedItem.Id
    else   
        MissionId = self.RandomId
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small_crystal", nil, nil)
    UIManager(self):LoadUINew("AutoChessBuffDetail",MissionId)
end

function View:OnClickMonster()
    local MissionId = nil
    if self.SelectedItem then
        MissionId = self.SelectedItem.Id
    else   
        MissionId = self.RandomId
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
    UIManager(self):LoadUINew("AutoChessDeputeMonsterInfoUI",MissionId)
end

function View:InitReward(Info)
    if not Info then return end
    self.Details.Text_Reward:SetText(GText("UI_AutoChess_RewardInfo"))
    local DungeonRewardView = DataMgr.Dungeon[Info.DungeonId].DungeonRewardView
    local RewardInfo = DataMgr.RewardView[DungeonRewardView]
    if RewardInfo then
        local Ids = RewardInfo.Id or {}
        local RewardCount = RewardInfo.Count or {}
        local TableName = RewardInfo.Type or {}
        for i = 1, #Ids do
            local ItemId = Ids[i]
            local Count = RewardUtils:GetCount(RewardCount[i])
            local Icon = ItemUtils.GetItemIconPath(ItemId, TableName[i])
            local Rarity = ItemUtils.GetItemRarity(ItemId, TableName[i])
            local ItemType = TableName[i]
            local RewardContent = NewObject(UIUtils.GetCommonItemContentClass())
            RewardContent.Id = ItemId
            if Count ~= 0 then
                RewardContent.Count = Count
            end
            RewardContent.Icon= Icon
            RewardContent.Rarity = Rarity
            RewardContent.ItemType = ItemType
            RewardContent.IsShowDetails = true
            RewardContent.MenuPlacement = EMenuPlacement.MenuPlacement_MenuLeft
            if self.Type == AutoChessConst.LevelSelectType.Linear then
                if self.SelectedItem.State == LevelState.Pass then
                    RewardContent.bHasGot = true
                else
                    RewardContent.bHasGot = false
                end
            else
                RewardContent.bHasGot = false
            end         
            self.Details.List_Reward:AddItem(RewardContent)
        end
    end
end

function View:InitBtn()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    self.Details.WS_Btn:SetActiveWidgetIndex(0)
    self.Details.Btn_Challenge.Text_Refresh:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Details.Btn_Challenge.Text_Button:SetText(GText("UI_AutoChess_MissionEntry"))
    if self.Type == AutoChessConst.LevelSelectType.Random then
        self.Details.Btn_Refresh:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Details.Btn_Refresh.Text_Refresh:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Details.Btn_Refresh.Text_Button:SetText(GText("UI_AutoChess_Refresh"))
        local Count = DataMgr.GlobalConstant.AUTO_CHESS_MAX_REFRESH.ConstantValue - Avatar.AutoChess.RefreshCount
        if Count == 0 then
            self.Details.Btn_Refresh:ForbidBtn(true)
        else
            self.Details.Btn_Refresh:ForbidBtn(false)
        end
        self.Details.Btn_Refresh.Text_Refresh:SetText(Count.."/"..DataMgr.GlobalConstant.AUTO_CHESS_MAX_REFRESH.ConstantValue)
    else
        self.Details.Btn_Refresh:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function View:UpdateRandomDetail()
    self.Details:PlayAnimation(self.Details.Change)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local Info = nil
    Info = DataMgr.AutoChessMission[self.RandomId]
    self.Details.Text_Name:SetText(GText(DataMgr.Dungeon[Info.DungeonId].DungeonName))
    self.Details.WS_Type:SetActiveWidgetIndex(1)
    self.Details.Panel_RankUp:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:InitRandomRank()
    self.Details.List_Enemy:ClearListItems()
    self.Details.List_Buff:ClearListItems()
    self.Details.List_Reward:ClearListItems()
    self.Details.Panel_Enemy:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Details.Panel_Buff:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Details.Panel_Reward:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self:InitEnemy(Info)
    self:InitBuff(Info)
    self:InitReward(Info)
    self:InitBtn()
end

function View:InitLinearRank()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local Rank = Avatar.AutoChess.RankLevel
    local Info = DataMgr.AutoChessPoint[Rank]
    self.Rank.Icon_Rank:SetBrushResourceObject(LoadObject(Info.RankIcon))
    self.Rank.Text_Rank:SetText(GText(Info.RankName))
    self.Rank.Text_Exp:SetText(Avatar.AutoChess.RankScore.."/"..Info.RankMaxPoint)
end

function View:InitRandomRank()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local Rank = Avatar.AutoChess.RankLevel
    local Info = DataMgr.AutoChessPoint[Rank]
    self.Details.Rank.Icon_Rank:SetBrushResourceObject(LoadObject(Info.RankIcon))
    self.Details.Rank.Text_Rank:SetText(GText(Info.RankName))
    self.Details.Rank.Text_Exp:SetText(Avatar.AutoChess.RankScore.."/"..Info.RankMaxPoint)
end

function View:OnClickEnter()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local Info = nil
    local ChessMissionId = nil
    if self.Type == AutoChessConst.LevelSelectType.Linear then
        if self.SelectedItem.State == LevelState.UnLock then
            return
        end
        if Model:CheckLinearIsNew(self.SelectedItem.Id) then
            Model:DecreaseLinearReddotById(self.SelectedItem.Id)
        end
        Info = DataMgr.AutoChessMission[self.SelectedItem.Id]
        ChessMissionId = self.SelectedItem.Id
    else
        Info = DataMgr.AutoChessMission[self.RandomId]
        ChessMissionId = self.RandomId
    end
    local CustomParams = {}
    CustomParams.MissionId = ChessMissionId
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
    Avatar:EnterEventDungeon(nil, Info.DungeonId, nil, ActiveId, CustomParams)
end

function View:OnClickRefresh()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    if Avatar.AutoChess.RefreshCount >= DataMgr.GlobalConstant.AUTO_CHESS_MAX_REFRESH.ConstantValue then
        return
    end
    local func = function()
        self:RandomInit()
    end
    Avatar:RefreshRandomMission(func)
end

function View:GetState(Id)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local Info = DataMgr.AutoChessMission[Id]
    if Avatar.Dungeons[Info.DungeonId] and Avatar.Dungeons[Info.DungeonId].IsPass then
        return LevelState.Pass
    end
    local TimeUnlock = self:CheckUnlockDay(Info)
    local bPrePass = false
    if Info.UnlockMissionId then
        local PreDungeonId = DataMgr.AutoChessMission[Info.UnlockMissionId].DungeonId
        if Avatar.Dungeons[PreDungeonId] and Avatar.Dungeons[PreDungeonId].IsPass then
            bPrePass = true
        else
            bPrePass = false
        end
    end 
    if not Info.UnlockDay and not Info.UnlockMissionId then
        return LevelState.UnPass
    end
    if Info.UnlockDay and not Info.UnlockMissionId then 
        if TimeUnlock then
            return LevelState.UnPass
        else
            return LevelState.UnLock
        end
    elseif not Info.UnlockDay and Info.UnlockMissionId then
        if bPrePass then
            return LevelState.UnPass
        else
            return LevelState.UnLock
        end
    elseif Info.UnlockDay and Info.UnlockMissionId then
        if TimeUnlock and bPrePass then
            return LevelState.UnPass
        else
            return LevelState.UnLock
        end
    end
end

function View:CheckUnlockDay(Info)
    local UnlockDay = Info.UnlockDay
    if not UnlockDay then return true end
    -- 计算解锁时间戳
    -- 活动开始时间
    local EventStartTime = DataMgr.EventMain[103016].EventStartTime
    local StartTimestamp = EventStartTime:GetTime()
    local CurrentTime = TimeUtils.NowTime()
    
    -- 获取活动开始时间的日期信息
    local StartDate = os.date("*t", StartTimestamp)
    
    -- 判断活动开始时间是否在5点之前
    -- 如果在5点之前，第一天从当天5点开始；否则从次日5点开始
    local RefreshHour = TimeUtils.RefreshHMS[1] or 5
    local RefreshMin = TimeUtils.RefreshHMS[2] or 0
    local RefreshSec = TimeUtils.RefreshHMS[3] or 0
    
    -- 获取活动开始时间当天的5点时间戳
    local FirstRefreshTime = os.time({
        year = StartDate.year,
        month = StartDate.month,
        day = StartDate.day,
        hour = RefreshHour,
        min = RefreshMin,
        sec = RefreshSec
    })
    
    if StartTimestamp >= FirstRefreshTime then
        FirstRefreshTime = FirstRefreshTime + 86400 -- 加一天
    end
    local UnlockTime = FirstRefreshTime + (UnlockDay - 2) * 86400
    if CurrentTime < UnlockTime then
        return false
    end
    return true
end


---------------手柄逻辑------------



function View:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    if (CurInputType == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end
    --- 切换手柄端相关图标显隐
    local IsUseKeyAndMouse = CurInputType == ECommonInputType.MouseAndKeyboard
    if (IsUseKeyAndMouse) then
        self.UsingGamepad = false
        self:ShowOrHideGamePad(false)
    else
        self.UsingGamepad = true
        self:ShowOrHideGamePad(true)
        self:SetFocus()
    end
end

function View:InitGamePad()
    if self.Controller_L then
        self.Controller_L:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "LB",
            }
        },
        }) 
    end
    if self.Controller_R then
        self.Controller_R:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "RB",
            }
        },
        })  
    end
    self.Details.Controller_Enemy:CreateCommonKey({
    KeyInfoList={
        {
            Type = "Img",
            ImgShortPath = "Up",
        }
    },
    })  
    self.Details.Controller_Buff:CreateCommonKey({
    KeyInfoList={
        {
            Type = "Img",
            ImgShortPath = "Down",
        }
    },
    }) 
    self.Details.Controller_Reward:CreateCommonKey({
    KeyInfoList={
        {
            Type = "Img",
            ImgShortPath = "LS",
        }
    },
    }) 
    self.Details.Btn_Challenge:SetGamePadImg("A")
    self.Details.Btn_Lock:SetGamePadImg("A")
    self.Details.Btn_Refresh:SetGamePadImg("Y")
end


function View:ShowOrHideGamePad(bShow)
    if bShow then
        if self.WS_L then
            self.WS_L:SetActiveWidgetIndex(1)
        end
        if self.WS_R then
            self.WS_R:SetActiveWidgetIndex(1)
        end
        self.Details.Controller_Enemy:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Details.Controller_Buff:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Details.Controller_Reward:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Details.Btn_Refresh:SetGamepadIconVisibility(true)
        self.Details.Btn_Challenge:SetGamepadIconVisibility(true)
        self.Details.Btn_Lock:SetGamepadIconVisibility(false)
    else
        if self.WS_L then
            self.WS_L:SetActiveWidgetIndex(0)
        end
        if self.WS_R then
            self.WS_R:SetActiveWidgetIndex(0)
        end
        self.Details.Controller_Enemy:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Details.Controller_Buff:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Details.Controller_Reward:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Details.Btn_Refresh:SetGamepadIconVisibility(false)
        self.Details.Btn_Challenge:SetGamepadIconVisibility(false)
        self.Details.Btn_Lock:SetGamepadIconVisibility(false)
    end
end

function View:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == "Gamepad_LeftShoulder" then
        if self.Type == AutoChessConst.LevelSelectType.Linear then
            self:OnBtnLClicked()
            return UE4.UWidgetBlueprintLibrary.Handled()
        end
    elseif InKeyName == "Gamepad_RightShoulder" then
        if self.Type == AutoChessConst.LevelSelectType.Linear then
            self:OnBtnRClicked()
            return UE4.UWidgetBlueprintLibrary.Handled()
        end
    elseif InKeyName == "Gamepad_DPad_Down" then
        self:OnClickBuff()
        return UE4.UWidgetBlueprintLibrary.Handled()
    elseif InKeyName == "Gamepad_DPad_Up" then
        self:OnClickMonster()
        return UE4.UWidgetBlueprintLibrary.Handled()
    elseif InKeyName == "Gamepad_LeftThumbstick" then
        self:ShowOrHideGamePad(false)
        self.Details.List_Reward:SetFocus()
        return UE4.UWidgetBlueprintLibrary.Handled()
    elseif InKeyName == "Gamepad_FaceButton_Top" then
        if self.Type == AutoChessConst.LevelSelectType.Random then
            self:OnClickRefresh()
            return UE4.UWidgetBlueprintLibrary.Handled()
        end
    elseif InKeyName == "Gamepad_FaceButton_Right" then
        if self.Details.List_Reward:HasFocusedDescendants() or self.Details.List_Reward:HasAnyUserFocus() then
            self:SetFocus()
            self:ShowOrHideGamePad(true)
            return UE4.UWidgetBlueprintLibrary.Handled()
        else
            return UE4.UWidgetBlueprintLibrary.Unhandled()
        end  
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end


function View:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == "Gamepad_FaceButton_Bottom" then
        self:OnClickEnter()
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function View:OnFocusReceived(MyGeometry, InFocusEvent)
    self:SetFocus()
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function View:OnPagePoped()
    if self.Type == AutoChessConst.LevelSelectType.Linear then
        Model:DecreaseLinearReddotById()
    end
    AudioManager(self):SetEventSoundParam(self, "SelectOpen", {ToEnd = 1}) 
end


return View