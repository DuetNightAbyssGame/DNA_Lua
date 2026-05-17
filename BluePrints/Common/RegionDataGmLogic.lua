require "UnLua"
require "Const"

local M = Class()

function M:OnRegionDataClaim_Log(WorldRegionEid, Eid, LevelName, Message)
    self.DataLibrary.LogHelper:OnRegionDataClaim(WorldRegionEid, Eid, LevelName, Message)
end

function M:OnRegionDataFill_Log(WorldRegionEid, Eid, LevelName)
    self.DataLibrary.LogHelper:OnRegionDataFill(WorldRegionEid, Eid, LevelName)
end

function M:OnRegionEntityCreated_Log(WorldRegionEid, Eid, LevelName)
	self.DataLibrary.LogHelper:OnEntityCreated(WorldRegionEid, Eid, LevelName)
end

function M:OnRegionEntityDeleted_Log(WorldRegionEid, Eid, LevelName)
	self.DataLibrary.LogHelper:OnEntityRemoved(WorldRegionEid, Eid, LevelName)
end

function M:PrintRegionLog(Id)
	self.DataLibrary.LogHelper:PrintRegionData(Id)
end

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------ GM 测试 ------------------------------------------------

function M:GMTest_PrintServerRegionData(PartRegionStoreData)
    local TempGMType = self.TestGMRegionDataType
    self.TestGMRegionDataType = Const.TestGMRegionType.NoneTest
    self.TestGMRegionServerData = {}

    for RegionDataType, SubRegionDatas in pairs(PartRegionStoreData) do
        for SubRegionId, LevelRegionDatas in pairs(SubRegionDatas) do   
           for LevelName, RegionDatas in pairs(LevelRegionDatas) do
                for WorldRegionEid, RegionBaseData in pairs(RegionDatas) do
                    self.TestGMRegionServerData[tonumber(RegionDataType)] = self.TestGMRegionServerData[tonumber(RegionDataType)] or {}
                    self.TestGMRegionServerData[tonumber(RegionDataType)][tonumber(SubRegionId)] = self.TestGMRegionServerData[tonumber(RegionDataType)][tonumber(SubRegionId)] or {}
                    self.TestGMRegionServerData[tonumber(RegionDataType)][tonumber(SubRegionId)][LevelName] = self.TestGMRegionServerData[tonumber(RegionDataType)][tonumber(SubRegionId)][LevelName] or {}
                    self.TestGMRegionServerData[tonumber(RegionDataType)][tonumber(SubRegionId)][LevelName][WorldRegionEid] = RegionBaseData
                end
            end 
        end
    end


    GWorld.logger.errorlog("======================打印区域服务器数据库======================")
    
    -- 打印服务器数据库当前区域的所有数据
    local function _PrintData(Type, TypeData)
        GWorld.logger.errorlog("======================"..Const.RegionDataTypeDebugText[tonumber(Type) + 1].. "======================")
        for SubRegionId, TempData in pairs(TypeData) do
            GWorld.logger.errorlog("======================区域Id: "..SubRegionId.. "======================")
            PrintTable(TempData, 10)
        end
    end

    for Type, TypeData in pairs(self.TestGMRegionServerData) do
        _PrintData(Type, TypeData)
    end
    GWorld.logger.errorlog("======================打印区域服务器数据库End===================")

    if TempGMType == Const.TestGMRegionType.CompareServer then
        GWorld.logger.errorlog("======================比较客户端缓存和服务器数据库======================")
        for RegionDataType, SubRegionDatas in pairs(self.DataLibrary.RegionCacheDatas) do
            for SubRegionId, LevelRegionDatas in pairs(SubRegionDatas) do   
               for LevelName, RegionDatas in pairs(LevelRegionDatas) do
                    for WorldRegionEid, RegionBaseData in pairs(RegionDatas) do
                        local _NotExist = false
                        if self.TestGMRegionServerData[RegionDataType] == nil
                            or self.TestGMRegionServerData[RegionDataType][SubRegionId] == nil
                            or self.TestGMRegionServerData[RegionDataType][SubRegionId][LevelName] == nil
                            or self.TestGMRegionServerData[RegionDataType][SubRegionId][LevelName][WorldRegionEid] == nil
                        then
                            _NotExist = true
                        end

                        if _NotExist then
                            GWorld.logger.errorlog("区域【客户端缓存】比【服务器】多了数据：" .. WorldRegionEid)
                            PrintTable(RegionBaseData)
                        else
                            self.TestGMRegionServerData[RegionDataType][SubRegionId][LevelName][WorldRegionEid].ClientExit = true
                        end
                    end
                end 
            end
        end

        for RegionDataType, SubRegionDatas in pairs(self.TestGMRegionServerData) do
            for SubRegionId, LevelRegionDatas in pairs(SubRegionDatas) do   
               for LevelName, RegionDatas in pairs(LevelRegionDatas) do
                    for WorldRegionEid, RegionBaseData in pairs(RegionDatas) do
                        if not self.TestGMRegionServerData[RegionDataType][SubRegionId][LevelName][WorldRegionEid].ClientExit then
                            GWorld.logger.errorlog("区域【服务器】比【客户端缓存】多了数据：" .. WorldRegionEid)
                            PrintTable(RegionBaseData)
                        end
                    end
                end 
            end
        end

        GWorld.logger.errorlog("======================比较客户端缓存和服务器数据库 End======================")
    end
end

function M:GMTest_PrintServerQuestChainData(ServerRegionDatas)
    local ServerQuestDatas = ServerRegionDatas[ERegionDataType.RDT_QuestData] or {}
    local Avatar = GWorld:GetAvatar()
    local DoingQuestChainIds = {}
    local DoingQuestIds = nil
    DoingQuestChainIds, DoingQuestIds = Avatar:GetCurrentDoingQuest()

    local TestServerQuestDatas = {}
    for _, ChainId in pairs(DoingQuestChainIds) do
        GWorld.logger.errorlog("======================打印正在执行的任务链 ".. ChainId.." 数据======================")
        GWorld.logger.errorlog("======================当前已经存储在服务器的数据======================")
        for SubRegionId, LevelRegionDatas in pairs(ServerQuestDatas) do   
            for LevelName, RegionDatas in pairs(LevelRegionDatas) do
                for WorldRegionEid, RegionBaseData in pairs(RegionDatas) do
                    if RegionBaseData.QuestChainId == ChainId then
                        PrintTable(RegionBaseData)
                    end
                    TestServerQuestDatas[ChainId] = TestServerQuestDatas[ChainId] or {}
                    TestServerQuestDatas[ChainId][WorldRegionEid] = 1
                end
            end 
        end

        GWorld.logger.errorlog("======================当前仅存储在客户端的数据======================")
        for LevelName, LevelData in pairs(self.DataLibrary.RegionSSDatas) do
            for WorldRegionEid, RegionBaseData in pairs(LevelData) do
                if RegionBaseData.QuestChainId == ChainId and RegionBaseData.WorldRegionEid 
                and (TestServerQuestDatas[ChainId] == nil or TestServerQuestDatas[ChainId][RegionBaseData.WorldRegionEid]~=1) then
                    PrintTable(RegionBaseData)
                end
            end
        end
        GWorld.logger.errorlog("======================打印正在执行的任务链 ".. ChainId.." 数据结束======================")
    end

end


return M