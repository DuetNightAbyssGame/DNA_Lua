--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR zhangdongxu
-- @DATE ${date} ${time}
--
require "UnLua"
local CommonUtils = require "Utils.CommonUtils"

---@type WBP_Battle_Drops_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C", "BluePrints.UI.BP_UIState_C"})

--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Overridden.Construct(self)
    self:SetVisibility(ESlateVisibility.Collapsed)

    self.UsingItemList = {}
    self.WaitingList = {}
    self.TickWaitingList = {}
    self.LastUpdateTime = 0
    self.UpdateInterval = 0.2
    self.DropItemMaxNum = 5
    if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "PC" then
        self.DropItemMaxNum = 3
    end
end

function M:Destruct()
    self:StopAllAnimations()
    self:CleanTimer()
end

function M:Tick(MyGeometry, InDeltaTime)
    local CurrentTime = os.clock()
    if CommonUtils.TableLength(self.UsingItemList) == 0 and CommonUtils.TableLength(self.TickWaitingList) == 0 and #self.WaitingList == 0  then
        self.ListView_Box:ClearListItems()
        self:SetVisibility(ESlateVisibility.Collapsed)
    end
    if CurrentTime - self.LastUpdateTime >= self.UpdateInterval then
        if #self.TickWaitingList > 0 then
            local Data = self.TickWaitingList[1]
            self:ShowDropItem(Data.ItemId, Data.ItemCount, Data.TableName)
            self.LastUpdateTime = CurrentTime
            table.remove(self.TickWaitingList, 1)
        end
    end
end

function M:ShowDropItem(ItemId, ItemCount, TableName)
    self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    if not self:OnUpdateTips(ItemId, ItemCount, TableName) then
        if not self.WaitingList[TableName] then
            self.WaitingList[TableName] = {}
        end
        table.insert(self.WaitingList[TableName], { ItemId, ItemCount })
    end
end

function M:OnUpdateTips(ItemId, ItemCount, TableName)
    local ItemData = DataMgr[TableName][ItemId]
    assert(ItemData, "掉落物不存在:"..TableName..ItemId)

    -- 获取当前显示的所有掉落物
    local ListItems = self.ListView_Box:GetListItems()

    -- 如果对应掉落物的UI已经存在，且没有在播out动画，则更新数字
    if ListItems:Length() > 0 then
        for _, Content in pairs(ListItems) do
            -- local Item = self.ListView_Box:GetItemAt(v)
            if Content and Content.SelfWidget and Content.ItemId == ItemId and Content.TableName == TableName then
                if Content.SelfWidget:IsAnimationPlaying(Content.SelfWidget.out) then
                    return false
                end
                Content.SelfWidget:AddItemCount(ItemCount)
                return true
            end
        end
    end

    if ListItems:Length() >= self.DropItemMaxNum then
        return false
    end
    -- 向容器中新增新的掉落物
    for _, Content in pairs(self.ContentList) do
        if not Content.ItemId then
            Content.ItemId = ItemId
            Content.ItemCount = ItemCount
            Content.TableName = TableName
            Content.Parent = self
            self.ListView_Box:AddItem(Content)
            self.ListView_Box:RequestRefresh()
            break;
        end
    end
    -- local Content = NewObject(self.DropItemContentClass)
    -- Content.ItemId = ItemId
    -- Content.ItemCount = ItemCount
    -- Content.TableName = TableName
    -- Content.Parent = self
    -- self.ListView_Box:AddItem(Content)

    return true
end

function M:OnTipsItemClose(InItem)
    if not InItem then
        return
    end
    -- self.ListView_Box:RemoveItem(InItem)
    self.ListView_Box:RequestRefresh()
    InItem.ItemId = nil
    self.UsingItemList[InItem] = nil
    self:AddDelayFrameFunc(function()
        for TableName, TipsInfoList in pairs(self.WaitingList) do
            repeat 
                if #TipsInfoList == 0 then
                    break
                end
                local TipsInfo = TipsInfoList[1]
                table.insert(self.TickWaitingList, {ItemId = TipsInfo[1], ItemCount = TipsInfo[2], TableName = TableName})
                table.remove(TipsInfoList, 1)
                -- if self:OnUpdateTips(TipsInfo[1], TipsInfo[2], TableName) then
                --     table.remove(TipsInfoList, 1)
                --     DebugPrint("Tianyi@ Drops")
                -- end
            until false
        end
        if CommonUtils.TableLength(self.UsingItemList) == 0 and CommonUtils.TableLength(self.TickWaitingList) == 0 then
            self:SetVisibility(ESlateVisibility.Collapsed)
        end
    end, 5, "ShowDropItem")

end
return M
