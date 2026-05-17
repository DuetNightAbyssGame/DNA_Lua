
local DungeonObjectActor = Class()

function DungeonObjectActor:ReceiveBeginPlay()
    self.Super:ReceiveBeginPlay()

    -- 通过 ServerEntity 获取 DungeonObject
    local ServerEntity = GWorld:GetServerEntity()
    if ServerEntity then
        self.DungeonObject = ServerEntity:GetDungeonObject()
        if self.DungeonObject then
            -- 绑定成功
            print("DungeonObjectActor: Bind to DungeonObject success")
        else
            print("DungeonObjectActor: DungeonObject not found")
        end
    else
        print("DungeonObjectActor: ServerEntity not found")
    end
end

return DungeonObjectActor
