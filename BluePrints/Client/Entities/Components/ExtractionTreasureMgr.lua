local Component = {}



---@param EventDungeonId number TreasureHuntStoryDungeon.xlsx 或 TreasureHuntRepeatDungeon.xlsx的主键
function Component:TestEnterSoloTreasure(EventDungeonId, BagId, IsStory, IsEasy)
    local CustomParams = {
		EventDungeonId = EventDungeonId,
        BagId = BagId or 1, ---会被阵容覆盖
        IsStory = IsStory, ---是否剧情关口
        IsEasy = IsEasy, ---复刷关卡时，是否是简单模式

	}
    if IsStory then
        local tab = DataMgr.TreasureHuntStoryDungeon[EventDungeonId]
        if tab then
            self:EnterEventDungeon(function()
                print("*******************Component:TestEnterExtractionTreasure()****************")
            end, tab.DungeonId, 0, 103014, CustomParams) 
        end
    else
        local tab = DataMgr.TreasureHuntRepeatDungeon[EventDungeonId]
        if tab then
            local DungeonId = IsEasy and tab.EasyDungeonId or tab.HardDungeonId
            self:EnterEventDungeon(function()
                print("*******************Component:TestEnterExtractionTreasure()****************")
            end, DungeonId, 0, 103014, CustomParams)
        end
    end
end

---@param EventDungeonId number TreasureHuntStoryDungeon.xlsx 或 TreasureHuntRepeatDungeon.xlsx的主键
function Component:EnterSoloTreasure(EventDungeonId, EventId, BagId, IsStory, IsEasy, Callback)
    local CustomParams = {
		EventDungeonId = EventDungeonId,
        BagId = BagId or 1, ---会被阵容覆盖
        IsStory = IsStory, ---是否剧情关口
        IsEasy = IsEasy, ---复刷关卡时，是否是简单模式

	}
    if IsStory then
        local tab = DataMgr.TreasureHuntStoryDungeon[EventDungeonId]
        if tab then
            self:EnterEventDungeon(function()
                print("*******************Component:TestEnterExtractionTreasure()****************")
                if Callback then
                    Callback()
                end
            end, tab.DungeonId, 0, EventId, CustomParams) 
        end
    else
        local tab = DataMgr.TreasureHuntRepeatDungeon[EventDungeonId]
        if tab then
            local DungeonId = IsEasy and tab.EasyDungeonId or tab.HardDungeonId
            self:EnterEventDungeon(function()
                print("*******************Component:TestEnterExtractionTreasure()****************")
                if Callback then
                    Callback()
                end
            end, DungeonId, 0, EventId, CustomParams)
        end
    end
end


function Component:GM_AddSoloTreasure(id)
    self:CallServerMethod("GM_AddSoloTreasure", id)
end

function Component:GM_AddSoloTreasureScore(AddScore)
    self:CallServerMethod("GM_AddSoloTreasureScore", AddScore)
end

function Component:GM_TestSoloTreasureBox(UnitId)
   local SoloTreasureUtils = require "Utils.SoloTreasureUtils"
    local list = SoloTreasureUtils:GetExtractionTreasureMechanismItemList(UnitId)
    for i = 1, #list do
        local ItemID = list[i]
        print("***GM_TestSoloTreasureBox ItemId=", ItemID)
    end
end

return Component