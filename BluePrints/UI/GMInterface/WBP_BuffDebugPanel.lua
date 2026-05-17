--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

---@type WBP_BuffDebugPanel_C
local WBP_BuffDebugPanel = Class({"BluePrints.UI.BP_UIState_C", "BluePrints.Common.TimerMgr"})


function WBP_BuffDebugPanel:OnLoaded(...)
    self.Entity = ...
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local UIManager = GameInstance:GetGameUIManager()
    
    self.BtnClose.OnClicked:Clear()
    self.BtnClose.OnClicked:Add(self, function()
        self.Entity = nil
        self:Close()
    end)
    self.RepeatTimer = self:AddTimer(0.5, self.RefreshBuffDebugPanel, true, 0, "RefreshBuffDebugPanel")
end

function WBP_BuffDebugPanel:SetEntity(Entity)
    if not Entity.BuffManager then return end
    self.Entity = Entity

    self.TxtDescribe:SetText(string.format("Eid: %d, Name: %s, 呼出鼠标按左侧箭头可展开详细", Entity.Eid, Entity:GetName()))
end

function WBP_BuffDebugPanel:RefreshBuffDebugPanel()
    local Buffs = self.Entity.BuffManager.Buffs
    local BuffsNum = Buffs:Length()
    local CurrentItemNum = self.BuffItemList:GetNumItems()

    -- 调整列表项数量
    if BuffsNum > CurrentItemNum then
        for i = CurrentItemNum + 1, BuffsNum do
            local NewContent = NewObject(UIUtils.GetCommonItemContentClass())
            self.BuffItemList:AddItem(NewContent)
        end
    elseif BuffsNum < CurrentItemNum then
        for i = CurrentItemNum, BuffsNum + 1, -1 do
            self.BuffItemList:RemoveItem(self.BuffItemList:GetItemAt(i - 1))
        end
    end

    -- 更新Content
    for i = 1, BuffsNum do
        local BuffObj = Buffs:GetRef(i)
        local ItemContent = self.BuffItemList:GetItemAt(i - 1)
        ItemContent.Id = BuffObj.BuffId
        ItemContent.LeftTime = BuffObj.LeftTime
        ItemContent.Value = BuffObj.Value
        ItemContent.Layer = BuffObj:GetLayerNum()
        ItemContent.SourceEid = BuffObj.SourceEid

        -- 补充每一层的Layer信息
        ItemContent.Layers = {}
        local CurrentTime = UE4.UGameplayStatics.GetTimeSeconds(self)
        local Layers = BuffObj:GetFreeLayers()
        for i = 1, Layers:Length() do
            local Layer = Layers:GetRef(i)
            table.insert(ItemContent.Layers, {
                Uid = Layer.Uid,
                LeftTime = Layer.StartTime + Layer.LastTime - CurrentTime,
                Value = Layer.Value,
                SourceEid = Layer.SourceEid,
            })
        end
    end

    -- 更新可见项
    local DisplayedWidget = self.BuffItemList:GetDisplayedEntryWidgets()
    if DisplayedWidget then
        local Length = DisplayedWidget:Length()
        for i = 1, Length do 
            local Entry = DisplayedWidget:GetRef(i)
            Entry:RefreshView()
        end
    end
end

-- function WBP_BuffDebugPanel:AddBuff(BuffObj)
--     local BuffData = DataMgr.Buff[BuffObj.BuffId]
--     self:AppendStr(string.format("BuffId: %d  LeftTime:%.1f Value:%.1f Layer:%d FreeLayer:%dSourceEid:%d RootSourceEid:%d MergeRule: %s, %s", 
--         BuffObj.BuffId, BuffObj.LeftTime, BuffObj.Value, BuffObj.Layer, BuffObj.FreeLayer, BuffObj.SourceEid, BuffObj.RootSourceEid, BuffData.MergeRule1, BuffData.MergeRule2))
--     local Layers = BuffObj:GetFreeLayers()
--     for i = 1, Layers:Length() do 
--         local Layer = Layers:GetRef(i) 
--         self:AddLayer(Layer)
--     end

-- end

-- function WBP_BuffDebugPanel:AddLayer(Layer)
--     self:AppendTab() 
--     local CurrentTime = UE4.UGameplayStatics.GetTimeSeconds(self)
--     self:AppendStr(string.format("Layer Uid:%d, LeftTime:%.1f  Value:%.1f  Layer:%d  SourceEid:%d  RootSourceEid:%d  IsDirty:%s",
--         Layer.Uid, Layer.StartTime + Layer.LastTime - CurrentTime, Layer.Value, Layer.Layer, Layer.SourceEid, Layer.RootSourceEid, tostring(Layer.bIsDirty)))
--     self:RemoveTab()
-- end 

-- function WBP_BuffDebugPanel:AppendStr(InStr)
--     self.DebugStr = self.DebugStr .. self.Prefix .. InStr .. "\n"
-- end

-- function WBP_BuffDebugPanel:AppendTab()
--     self.Prefix = self.Prefix .. "    "
-- end

-- function WBP_BuffDebugPanel:RemoveTab()
--     self.Prefix = self.Prefix:sub(1, -5)
-- end


return WBP_BuffDebugPanel

