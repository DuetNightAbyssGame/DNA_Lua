---背包
---@class SoloTreasureBag
---@field SizeX number  背包尺寸X
---@field SizeY number  背包尺寸Y
---@field SlotDict table<number, number> <已占用格子, 占用的物资uid>
local SoloTreasureBag = DungeonClass.Class()
function SoloTreasureBag:Init(sizeX, sizeY)
    self.SizeX = sizeX
    self.SizeY = sizeY
    self.SlotDict = {}
    --self.ItemPosMap = {}
end

function SoloTreasureBag:GetPos(x, y)
    return (y - 1) * self.SizeX + x
end
function SoloTreasureBag:GetXY(pos)
    if self.SizeX <= 0 then
        return -1, -1
    end
    local x = ((pos - 1) % self.SizeX) + 1
    local y = math.floor((pos - 1) / self.SizeX) + 1
    return x, y
end

function SoloTreasureBag:CanPlacementItem(uid, sizeX, sizeY, pos, conflictlist)
    if pos <= 0 or pos > self.SizeX * self.SizeY then
        return false
    end
    local targetX, targetY = self:GetXY(pos)
    if targetX + sizeX - 1 <= 0 or targetX + sizeX - 1 > self.SizeX or targetY + sizeY <= 0 or targetY + sizeY - 1 > self.SizeY then
        return false ---超出边界，不可放置
    end
    for _x = targetX, targetX + sizeX - 1 do
        for _y = targetY, targetY + sizeY - 1 do
            local ExistUniqueId = self.SlotDict[self:GetPos(_x, _y)]
            if ExistUniqueId and ExistUniqueId ~= uid then
                if conflictlist == nil then
                    return false                                ---如果不处理冲突，返回失败
                end
                if CommonUtils.HasValue(conflictlist, ExistUniqueId) == false then
                    table.insert(conflictlist, ExistUniqueId)   ---如果处理冲突吗，返回冲突
                end
            end
        end
    end
    return true
end

function SoloTreasureBag:PlacementItem(uid, sizeX, sizeY, pos)
    if self:CanPlacementItem(uid, sizeX, sizeY, pos, nil) == false then
        return -1
    end
    local targetX, targetY = self:GetXY(pos)
    for _x = targetX, targetX + sizeX - 1 do
        for _y = targetY, targetY + sizeY - 1 do
            self.SlotDict[self:GetPos(_x, _y)] = uid
        end
    end
    return pos
end

---将<sizeX, sizeY> 放置进来， 返回最终放置的坐标
function SoloTreasureBag:PushItem(uid, sizeX, sizeY, pos)
    pos = pos or 1
    for i = pos, self.SizeX * self.SizeY do
        local NewPos = self:PlacementItem(uid, sizeX, sizeY, i)
        if NewPos ~= -1 then
            return NewPos
        end
    end
    for i = 1, pos do
        local NewPos = self:PlacementItem(uid, sizeX, sizeY, i)
        if NewPos ~= -1 then
            return NewPos
        end
    end

    return -1
end

function SoloTreasureBag:PopItem(uid)
    for Pos = 1, self.SizeX * self.SizeY do
        if self.SlotDict[Pos] == uid then
            self.SlotDict[Pos] = nil
        end
    end
    return true
end



function SoloTreasureBag:RemoveItem(uid)
    for Pos = 1, self.SizeX * self.SizeY do
        if self.SlotDict[Pos] == uid then
            self.SlotDict[Pos] = nil
        end
    end
    return true
end

function SoloTreasureBag:MoveItem(uid, sizeX, sizeY, pos)
    if self:CanPlacementItem(uid, sizeX, sizeY, pos, nil) == false then
        return false
    end
    local targetX, targetY = self:GetXY(pos)
    for _x = targetX, targetX + sizeX - 1 do
        for _y = targetY, targetY + sizeY - 1 do
            self.SlotDict[self:GetPos(_x, _y)] = uid
        end
    end
    return true
end




return SoloTreasureBag