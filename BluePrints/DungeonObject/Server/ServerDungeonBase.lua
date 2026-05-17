
local RewardBox = require "BluePrints.Client.CustomTypes.SimpleRewardBox"
local ServerDungeonBase = DungeonClass.Class()

ServerDungeonBase.__Component__ = {
	"BluePrints.DungeonObject.DungeonBase",
	"BluePrints.DungeonObject.Server.DungeonReplicatedProperty",
    "BluePrints.DungeonObject.Server.PlayerManager",
}

function ServerDungeonBase:OnNotifyServerDungeonEvent_OnInit()
	print("ServerDungeonBase:OnNotifyServerDungeonEvent_OnInit")
    -- 获取所有的AutoAcitve点，进行激活
    self:ServerInitAutoActiveStaticCreator()
    self:ServerInitAutoActiveRandomCreator()
end

function ServerDungeonBase:DungeonMonsterDead(MonsterInfo)
	print("ServerDungeonBase:DungeonMonsterDead", MonsterInfo)
end


function ServerDungeonBase:DungeonRewardEvent(Info)
	    -- Info.UnitId = UnitId
        -- Info.Reason = Reason
        -- Info.Transform = Transform
        -- Info.ExtraInfo = ExtraInfo
	print("ServerDungeonBase:DungeonRewardEvent")
    if not Info or not Info.UnitId then
        print("ServerDungeonBase:DungeonRewardEvent Error: Invalid Info parameter in DungeonRewardEvent")
        return
    end 

    local ServerDungeonCallback = function (Drops, OtherParams)
        print("ServerDungeonBase:DungeonRewardEvent:ServerDungeonCallback", Drops)
        if not Drops or CommonUtils.IsEmpty(Drops) then
            return
        end
        local DropRes = {
            Reason = Info.Reason,
            Transform = Info.Transform,
            ExtraInfo = Info.ExtraInfo,
            DropInfos = {}
        }

        for Id, DropCountTable in pairs(Drops) do
            local DropId = tonumber(Id)
            local DropInfo = {
                DropId = DropId,
                DropCountTable = DropCountTable,
                UniqueIds = {}
            }
            local ExtraCount = RewardBox:FindCountByTag(DropCountTable, "Extra") or 0
            local OtherCount = RewardBox:FindCountByTag(DropCountTable, "Normal") or 0
            local TotalCount = ExtraCount + OtherCount
            for i = 1,TotalCount do 
                local _DropInfo = self:CreateDrop(DropId)
                table.insert(DropInfo.UniqueIds, _DropInfo.UniqueId)
            end
            table.insert(DropRes.DropInfos, DropInfo)
        end
        print("ServerDungeonBase:DungeonRewardEvent:ServerDungeonCallback", DropRes)
        self:NotifyGameModeCreatDrop(DropRes, OtherParams)
    end

	self:TriggerRewardEvent(Info.UnitId, Info.Reason, Info.ExtraInfo, ServerDungeonCallback)
end


DungeonClass.AssembleComponents(ServerDungeonBase)
return ServerDungeonBase