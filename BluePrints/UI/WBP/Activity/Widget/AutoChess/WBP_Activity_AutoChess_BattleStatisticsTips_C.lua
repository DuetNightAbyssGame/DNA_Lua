--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_AutoChess_BattleStatisticsTips_C
local M = Class({
    "BluePrints.UI.BP_EMUserWidget_C",
    "BluePrints.Common.TimerMgr",
})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.SizeX = 175
    self.PerSizeY = 68
    self.MoveSpeed = 0.1
    self.AllDamageInfo = {}
    self.AllDamageValue = 0
    self.AutoChessItemTable = {}
    self:InitInfo()
    self:InitBtnEvent()
    self:InitDisplayUI()
    self:RegisterEvent()
end

function M:RegisterEvent()
    EventManager:AddEvent(EventID.OnBattleChessFightDamage, self, self.OnDamageValueUpdate)
    EventManager:AddEvent(EventID.OnInitRoleBattleInfo, self, self.OnInitRoleBattleInfo)
end

function M:OnInitRoleBattleInfo(AutoChessBattleInfo)
    if not AutoChessBattleInfo then
        return
    end
    local AllyDamageInfos = self:GetDamageInfosByCamp("Ally")
    for Eid, DamageInfo in pairs(AutoChessBattleInfo["Ally"]) do
        table.insert(AllyDamageInfos, {SourceEid = Eid, DamageValue = DamageInfo.Damage or 0, UnitId = DamageInfo.UnitId})
    end
    local EnemyDamageInfos = self:GetDamageInfosByCamp("Enemy")
    for Eid, DamageInfo in pairs(AutoChessBattleInfo["Enemy"]) do
        table.insert(EnemyDamageInfos, {SourceEid = Eid, DamageValue = DamageInfo.Damage or 0, UnitId = DamageInfo.UnitId})
    end
    self:CreateAutoChessItem()
end

function M:GetDamageInfosByCamp(Camp)
    if not self.AllDamageInfo[Camp] then
        self.AllDamageInfo[Camp] = {}
    end
    return self.AllDamageInfo[Camp]
end

function M:GetIconPath(UnitId, Camp)
    local ChessData = DataMgr.CombatChessInfo
    for ChessId, Data in pairs(ChessData) do
        if Data.FriendMonsterUnitId == UnitId or Data.EnemyMonsterUnitId == UnitId then
            return Data.MonsterIcon
        end
    end
end

function M:RefreshDamageWidget(Camp)
    self.GridPanelLayout:ClearChildren()
    self.AutoChessItemTable = {}
    local CurDisplayDamageInfos = self:GetDamageInfosByCamp(self.IsClickedCamp)
    for Index, ItemInfo in ipairs(CurDisplayDamageInfos) do
        local AutoChessItem = UIManager(self):_CreateWidgetNew("AutoChessItem")
        local MonsterDataConfig = DataMgr.Monster[ItemInfo.UnitId]
        if AutoChessItem then
            AutoChessItem.Text_Name:SetText(GText(MonsterDataConfig.UnitName))
            AutoChessItem.Icon_Head:SetBrushResourceObject(LoadObject(self:GetIconPath(ItemInfo.UnitId)))
            self.GridPanelLayout:AddChildToGrid(AutoChessItem, Index - 1)
            AutoChessItem.TargetRank = Index - 1
            AutoChessItem:PlayAnimation(AutoChessItem[Camp])
            self.AutoChessItemTable[ItemInfo.SourceEid] = AutoChessItem
        end
    end
end

function M:CreateAutoChessItem()
    self:RefreshDamageWidget("Ally")
    self:RefreshItemState("Ally")
    self:RefreshItemDamageBar()
    self:AddTimer(0.025, self.UpdateItemPos, true, 0, "RefreshBattlePassTime")
end

function M:RefreshItemDamageBar()
    local CurDisplayDamageInfos = self:GetDamageInfosByCamp(self.IsClickedCamp)
    for _, DamageInfo in ipairs(CurDisplayDamageInfos) do
        if self.AutoChessItemTable[DamageInfo.SourceEid] then
            local Percent = self.AllDamageValue ~= 0 and (DamageInfo.DamageValue / self.AllDamageValue) or 0
            local Length = self.SizeX * (1 - Percent)
            local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.AutoChessItemTable[DamageInfo.SourceEid].Bar)
            local Margin = FMargin()
            Margin.Right = Length
            CanvasSlot:SetOffsets(Margin)
        end
    end
end

function M:GetDamageInfoIndexByEid(Eid, Camp)
    local DamageInfo = self:GetDamageInfosByCamp(Camp)
    for i, v in ipairs(DamageInfo) do
        if v.SourceEid == Eid then
            return v, i
        end
    end
    return nil, 0
end

function M:AddDamageWidget(ItemInfo, Camp)
    local AutoChessItem = UIManager(self):_CreateWidgetNew("AutoChessItem")
    local MonsterDataConfig = DataMgr.Monster[ItemInfo.UnitId]
    if AutoChessItem then
        AutoChessItem.Text_Name:SetText(GText(MonsterDataConfig.UnitName))
        AutoChessItem.Icon_Head:SetBrushResourceObject(LoadObject(self:GetIconPath(ItemInfo.UnitId)))
        AutoChessItem:PlayAnimation(AutoChessItem[Camp])
        AutoChessItem.Camp = Camp
        local ChildCount = self.GridPanelLayout:GetChildrenCount()
        self.GridPanelLayout:AddChildToGrid(AutoChessItem, ChildCount)
        self.AutoChessItemTable[ItemInfo.SourceEid] = AutoChessItem
    end
    return AutoChessItem
end

function M:AddDamageInfo(Camp, SourceEid, DamageValue, UnitId)
    local DamageInfos = self:GetDamageInfosByCamp(Camp)
    local DamageInfoTemp
    for _, DamageInfo in ipairs(DamageInfos) do
        if DamageInfo.SourceEid == SourceEid then
            DamageInfo.DamageValue = DamageInfo.DamageValue + DamageValue
            DamageInfoTemp = DamageInfo
        end
    end
    if not DamageInfoTemp then
        DamageInfoTemp = {SourceEid = SourceEid, DamageValue = DamageValue, UnitId = UnitId}
        table.insert(DamageInfos, DamageInfoTemp)
    end
    return DamageInfoTemp
end

function M:OnDamageValueUpdate(SourceEid, DamageValeAdd)
    local Source = Battle(self):GetEntity(SourceEid)
    if not Source then
        return
    end
    Source = Source:GetRootSource()
    if not Source.UnitId or not DataMgr.Monster[Source.UnitId] then
        return
    end
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local Camp
    if Player:IsEnemy(Source) then
        Camp = "Enemy"
    else
        Camp = "Ally"
    end
    local ItemInfo, Index = self:GetDamageInfoIndexByEid(SourceEid, Camp)
    if Index == 0 then
        ItemInfo = self:AddDamageInfo(Camp, SourceEid, DamageValeAdd, Source.UnitId)
        if self.IsClickedCamp == Camp then
            self.AllDamageValue = self.AllDamageValue + DamageValeAdd
            self:AddDamageWidget(ItemInfo, Camp)
            self:RefreshItemDamageBar()
        end
    else
        ItemInfo.DamageValue = ItemInfo.DamageValue + DamageValeAdd
        if self.IsClickedCamp == Camp then
            self.AllDamageValue = self.AllDamageValue + DamageValeAdd
            self:RefreshItemDamageBar()
        end
    end
    local ItemInfos = self:GetDamageInfosByCamp(Camp)
    table.sort(ItemInfos, function(a, b)
        return a.DamageValue > b.DamageValue
    end)
end

function M:UpdateItemPos()
    local CurDisplayDamageInfos = self:GetDamageInfosByCamp(self.IsClickedCamp)
    for Index, DamageInfo in ipairs(CurDisplayDamageInfos) do
        local ItemWidget = self.AutoChessItemTable[DamageInfo.SourceEid]
        if ItemWidget then
            local TargetRank = Index - 1
            local GridSlot = UE4.UWidgetLayoutLibrary.SlotAsGridSlot(ItemWidget)
            local CurNudgeY = GridSlot.Nudge.Y
            local CurRow = GridSlot.Row
            local IntervalRow = TargetRank - CurRow
            local RealMoveSpeed = self.MoveSpeed
            if IntervalRow < 0 then
                RealMoveSpeed = RealMoveSpeed * -1
            end
            local TargetNudgeY = IntervalRow * self.PerSizeY
            local Interval = TargetNudgeY - CurNudgeY
            if math.abs(Interval) > 0.01 then
                CurNudgeY = CurNudgeY + Interval * self.MoveSpeed
                GridSlot:SetNudge(FVector2D(0, CurNudgeY))
            else
                GridSlot:SetNudge(FVector2D(0, CurNudgeY))
            end
        end
    end
end

function M:RefreshUIInfoOnUpdateDevice()
    if UIUtils.IsMobileInput() then
        self.WS_L:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.WS_R:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        self.WS_L:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.WS_R:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.WS_L:SetActiveWidgetIndex(UIUtils.IsGamepadInput() and 1 or 0)
        self.WS_R:SetActiveWidgetIndex(UIUtils.IsGamepadInput() and 1 or 0)
    end
end

function M:InitDisplayUI()
    self.Text_Buff:SetText(GText("UI_AutoChess_DamageView"))
    self.Key_L:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Text",
                Text = "Q"
            }
        }
    })
    self.Key_R:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Text",
                Text = "E"
            }
        }
    })
    if self.Controller_L then
        self.Controller_L:CreateCommonKey({ KeyInfoList = { { Type = "Img", ImgShortPath = "LB", Owner = self} }})
        self.Controller_R:CreateCommonKey({ KeyInfoList = { { Type = "Img", ImgShortPath = "RB", Owner = self} }}) 
    end
end

function M:InitInfo()
    self.IsClickedCamp = "Ally"
end

function M:InitBtnEvent()
    local BtnEventTable = {
        "OnClicked",
        "OnHovered",
        "OnUnhovered",
        "OnPressed",
    }
    for _, BtnEventName in ipairs(BtnEventTable) do
        self.Btn_Ally[BtnEventName]:Clear()
        self.Btn_Ally[BtnEventName]:Add(self, self["AllyFight_"..BtnEventName])
    end
    for _, BtnEventName in ipairs(BtnEventTable) do
        self.Btn_Enemy[BtnEventName]:Clear()
        self.Btn_Enemy[BtnEventName]:Add(self, self["EnemyFight_"..BtnEventName])
    end
    self:PlayAnimation(self.Ally_Click)
    self:PlayAnimation(self.Ally)
end

function M:RefreshItemState(State)
    for _, ItemWidget in ipairs(self.AutoChessItemTable) do
        ItemWidget:PlayAnimation(ItemWidget[State])
    end
end

function M:AllyFight_OnClicked()
    if self:GetVisibility() == UIConst.VisibilityOp.Collapsed then
        return
    end
    if self.IsClickedCamp == "Ally" then
        return
    end
    self.IsClickedCamp = "Ally"
    self:PlayAnimation(self.Ally_Click)
    self:PlayAnimation(self.Ally)
    self:PlayAnimation(self.Enemy_Normal)
    local CurDisplayDamageInfos = self:GetDamageInfosByCamp(self.IsClickedCamp)
    self.AllDamageValue = 0
    for i, v in ipairs(CurDisplayDamageInfos) do
        self.AllDamageValue = self.AllDamageValue + v.DamageValue
    end
    self:RefreshDamageWidget(self.IsClickedCamp)
    self:RefreshItemDamageBar()
    self:RefreshItemState(self.IsClickedCamp)
end

function M:AllyFight_OnHovered()
    if self.IsClickedCamp == "Ally" then
        return
    end
    self:PlayAnimation(self.Ally_Hover)
end

function M:AllyFight_OnUnhovered()
    if self.IsClickedCamp == "Ally" then
        return
    end
    self:PlayAnimation(self.Ally_UnHover)
end

function M:AllyFight_OnPressed()
    if self.IsClickedCamp == "Ally" then
        return
    end
    self:PlayAnimation(self.Ally_Press)
end

function M:EnemyFight_OnClicked()
    if self:GetVisibility() == UIConst.VisibilityOp.Collapsed then
        return
    end
    if self.IsClickedCamp == "Enemy" then
        return
    end
    self.IsClickedCamp = "Enemy"
    self:PlayAnimation(self.Enemy_Click)
    self:PlayAnimation(self.Enemy)
    self:PlayAnimation(self.Ally_Normal)
    local CurDisplayDamageInfos = self:GetDamageInfosByCamp(self.IsClickedCamp)
    self.AllDamageValue = 0
    for i, v in ipairs(CurDisplayDamageInfos) do
        self.AllDamageValue = self.AllDamageValue + v.DamageValue
    end
    self:RefreshDamageWidget(self.IsClickedCamp)
    self:RefreshItemDamageBar()
    self:RefreshItemState(self.IsClickedCamp)
end

function M:EnemyFight_OnHovered()
    if self.IsClickedCamp == "Enemy" then
        return
    end
    self:PlayAnimation(self.Enemy_Hover)
end

function M:EnemyFight_OnUnhovered()
    if self.IsClickedCamp == "Enemy" then
        return
    end
    self:PlayAnimation(self.Enemy_UnHover)
end

function M:EnemyFight_OnPressed()
    if self.IsClickedCamp == "Enemy" then
        return
    end
    self:PlayAnimation(self.Enemy_Press)
end

function M:Destruct()
    self:RemoveTimer("RefreshBattlePassTime")
    EventManager:RemoveEvent(EventID.OnBattleChessFight, self)
    EventManager:RemoveEvent(EventID.OnInitRoleBattleInfo, self)
end

return M
