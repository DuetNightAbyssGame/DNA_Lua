--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
require "DataMgr"

-- 挖掘本UI
local WBP_Prologue_Excavation_C = Class({"BluePrints.UI.Dungeon.WBP_DungeonUIBase_C", "BluePrints.Common.TimerMgr"})

function WBP_Prologue_Excavation_C:Construct()
    self.Eids = {}
end

function WBP_Prologue_Excavation_C:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    self.Eids = {}

    self:InitListenEvent()
    self:AddDispatcher(EventID.OnExcavationItemChange, self, self.OnExcavationItemChange)
    self:AddDispatcher(EventID.OnExcavationFinish, self, self.OnExcavationFinish)
    self:AddDispatcher(EventID.OnAttractBattery, self, self.OnAttractBattery)
    self:AddDispatcher(EventID.OnExcavationGetReward, self, self.OnExcavationGetReward)
    --self:AddDispatcher(EventID.OnRepDungeonProgress, self, self.UpdateDungeonProgressDisplay)

    -- 用于记录当前GameState得到的信物数量
    self.GetReward = 0

    -- 用于结算信物数量
    self.LastReward = 0
    self.Text_Number:SetText(0)
    self.List_EnergyProgress:ClearListItems()
	self:SetVisibility(UE4.ESlateVisibility.Collapsed)

    self.Text_Title:SetText(GText("DUNGEON_EXCAVATION_100"))
    self.Text_Progress:SetText(GText("DUNGEON_EXCAVATION_103"))

    self.GameState = UE4.UGameplayStatics.GetGameState(self,0)

    -- 交互迭代 不要这个了 直接折叠吧
    self.Panel_Wave_Now:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- self.Panel_Wave_Now:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- self.Text_Wave_Now:SetText(GText("TARGET_DUNGEON_ROUND"))
    -- self:UpdateDungeonProgressDisplay(self.GameState.DungeonProgress)
end

function WBP_Prologue_Excavation_C:UpdateDungeonProgressDisplay(DungeonProgress)
    self.Num_Wave_Now:SetText(DungeonProgress)
end

function WBP_Prologue_Excavation_C:Tick(MyGeometry, InDeltaTime)
    if self.GameState.ExcavationItemNum ~= self.GetReward then
        self.GetReward = self.GameState.ExcavationItemNum
        self:OnExcavationGetReward(self.GetReward)
    end

    -- local GameStateExcavations = self.GameState.DefBaseMap
    -- local RealExcavationNum = GameStateExcavations:Length()
    -- if RealExcavationNum == #self.Eids then
    --     return
    -- end
    -- GameStateExcavations = GameStateExcavations:ToTable()
    -- if RealExcavationNum > #self.Eids then
    --     local temp_record = {}
    --     for i, v in pairs(self.Eids) do
    --         if GameStateExcavations[v] then
    --             temp_record[v] = true
    --         end
    --     end
    --     for i, v in pairs(GameStateExcavations) do
    --         print(_G.LogTag, "List_EnergyProgress: HYY GameState record Excavation", i, v.Eid, RealExcavationNum, #self.Eids)
    --         if not temp_record[v.Eid] then
    --             self:OnExcavationItemChange("Add", v.Eid)
    --         end
    --     end
    -- elseif RealExcavationNum < #self.Eids then
    --     for i, v in pairs(self.Eids) do
    --         if not GameStateExcavations[v] then
    --             self:OnExcavationItemChange("Remove", v)
    --         end
    --     end
    -- end
end

function WBP_Prologue_Excavation_C:OnExcavationItemChange(Type, Eid)
    if Type == "Add" then
        if #self.Eids >= 6 then
            print(_G.LogTag, "Error: HYY Mech num > 6")
            return
        end
        table.insert(self.Eids, Eid)

        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
        if GameInstance == nil then
            DebugPrint("OnExcavationItemChange: GameInstance 不存在")
            return
        end

        local SceneManager = GameInstance:GetSceneManager()
        if SceneManager == nil then
            DebugPrint("OnExcavationItemChange: SceneManager 不存在")
            return
        end

        --SceneManager:GetABCText(SceneManager.ExcavationABCMap, Eid, 6)
        
        local NewEnergyBarData = NewObject(UE4.LoadClass(UIConst.DUNGEONEXCAVATIONENERGYBARDATA))
        NewEnergyBarData.TargetMachineEid = Eid

        --NewEnergyBarData.Order = SceneManager.ExcavationABCMap.Index[Eid]
        NewEnergyBarData.Owner = self
        
        self.List_EnergyProgress:AddItem(NewEnergyBarData)
		self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    if Type == "Remove" then
        for i = #self.Eids, 1, -1 do
            if self.Eids[i] == Eid then
                --table.remove(self.Eids, i)        -- 移到动效播完，要和Item保持一致
                local RemoveItem = self.List_EnergyProgress:GetItemAt(i-1)
                RemoveItem.PlayOutAnim:Broadcast()
            end
        end
    end
end

function WBP_Prologue_Excavation_C:OnExcavationFinish(Eid)
    DebugPrint("DiggingLogs OnExcavationFinish")

    for i = #self.Eids, 1, -1 do
        if self.Eids[i] == Eid then
            --table.remove(self.Eids, i)        -- 移到动效播完，要和Item保持一致
            local RemoveItem = self.List_EnergyProgress:GetItemAt(i-1)
            RemoveItem.OnDiggingFinish:Broadcast()
            RemoveItem.PlayFinishAnim:Broadcast()
        end
    end
end

function WBP_Prologue_Excavation_C:RemoveItemFromListViewCallback(RemoveItem)
    local Eid = RemoveItem.TargetMachineEid
    DebugPrint("DiggingLogs RemoveItemFromListViewCallback", Eid)
    for i = #self.Eids, 1, -1 do
        if self.Eids[i] == Eid then
            table.remove(self.Eids, i)
        end
    end
    self.List_EnergyProgress:RemoveItem(RemoveItem)
	if self.List_EnergyProgress:GetNumItems() == 0 then
		self:SetVisibility(UE4.ESlateVisibility.Collapsed)
	end
end

function WBP_Prologue_Excavation_C:OnAttractBattery(Eid, BatteryEnergy)
    for i = #self.Eids, 1, -1 do
        if self.Eids[i] == Eid then
            self.List_EnergyProgress:GetItemAt(i-1).OnAttractBattery:Broadcast(BatteryEnergy)
        end
    end
end

function WBP_Prologue_Excavation_C:StopWarning()
    for i = 1, #self.Eids do
        local ListItem = self.List_EnergyProgress:GetItemAt(i-1)
        ListItem.OnBarsHide:Broadcast()
    end
end

function WBP_Prologue_Excavation_C:Hide()
    self.Super.Hide(self)
    for i = 1, #self.Eids do
        local ListItem = self.List_EnergyProgress:GetItemAt(i-1)
        ListItem.OnBarsHide:Broadcast()
    end
end

function WBP_Prologue_Excavation_C:Show()
    self.Super.Show(self)
    for i = 1, #self.Eids do
        local ListItem = self.List_EnergyProgress:GetItemAt(i-1)
        ListItem.OnBarsShow:Broadcast()
    end
end

function WBP_Prologue_Excavation_C:OnExcavationGetReward(Num)
    self:RemoveTimer("TryToAddReward")
    local AddReward = Num - self.LastReward
    self.Text_Add:SetText("+"..AddReward)
    self:AddTimer(0.5, self.TryToAddReward, false, 0, "TryToAddReward", false, Num)
end

function WBP_Prologue_Excavation_C:TryToAddReward(Num)
    self:PlayAnimation(self.complete_Add)
    UE4.ULTweenBPLibrary.DelayFrameCall(self, 24, function() self:SetRewardNum(Num) end)
end

function WBP_Prologue_Excavation_C:SetRewardNum(Num)
    self.Text_Number:SetText(Num)
    self.LastReward = Num
end

function WBP_Prologue_Excavation_C:Close()
    self.Super.Close(self)
end

return WBP_Prologue_Excavation_C
