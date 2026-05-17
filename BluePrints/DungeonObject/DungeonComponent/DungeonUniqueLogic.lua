
local DungeonUniqueLogic = DungeonClass.Class()

DungeonUniqueLogic.__Component__ = {
}

function DungeonUniqueLogic:BeginPlay()
	self.chars = "0123456789abcdefghijklmnopqrstuvwxyz"
	math.randomseed(os.time())
end

function DungeonUniqueLogic:GenUniqueId()
    -- 获取时间戳并添加随机扰动
    local timestamp = os.time()
    local random_perturb = math.random(0, 1295)  -- 36^2-1，增加更多随机性
    
    -- 将时间和随机数混合
    local mixed = timestamp * 1000 + random_perturb
    
    -- 生成4位时间戳相关的base36字符串
    local time_part = ""
    for i = 1, 4 do
        local remainder = mixed % 36 + 1
        time_part = self.chars:sub(remainder, remainder) .. time_part
        mixed = math.floor(mixed / 36)
    end
    
    -- 生成6位纯随机字符串
    local random_part = ""
    for i = 1, 6 do
        local random_index = math.random(1, #self.chars)
        random_part = random_part .. self.chars:sub(random_index, random_index)
    end
    
    -- 返回10位字符串
    return time_part .. random_part
end

DungeonClass.AssembleComponents(DungeonUniqueLogic)
return DungeonUniqueLogic