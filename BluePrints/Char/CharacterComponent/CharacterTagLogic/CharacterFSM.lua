local BaseTagRule = require('BluePrints.Char.CharacterComponent.CharacterTagLogic.BaseCharacterTagRule')

---@class CharacterFSM
local FSM = {}
FSM.__index = FSM

function FSM:CreateFSM(Owner, TagRule)
    local CharFSM = {}
    setmetatable(CharFSM, FSM)
    CharFSM.Owner = Owner

    ---@type BaseTagRule
    CharFSM.TagRule = TagRule   -- 状态机搭载的Tag转移规则
    CharFSM.CurrentTag = nil    -- 当前Tag
    CharFSM.CustomCheckers = {} -- Tag跳转的检查器， 详见: BaseCharacterTagRule.CheckCanEnterTag
    
    CharFSM:SetDefaultTag()
    CharFSM.Enable = false  -- 开关
    return CharFSM
end

function FSM:SetTag(NewTag)
    if not self.TagRule or self.IsLeavingTag == true then 
        -- DebugPrint("Tianyi@ =============禁止在LeaveTag时设置角色的Tag==============")
        return false
    end 

    local CanSetTag = self.TagRule:CheckCanEnterTag(self.Owner, self.CurrentTag, NewTag, self.CustomCheckers)
    if not CanSetTag then 
        return false
    end

    -- 调用进入老Tag的逻辑
    local CurTagInfo = self.TagRule:GetTagInfo(self.CurrentTag)
    if self.Enable and CurTagInfo and CurTagInfo.LeaveTag ~= nil then 
        self.IsLeavingTag = true
        CurTagInfo.OnLeaveTag(self.Owner)
        self.IsLeavingTag = false
    end

    -- 将当前Tag设为新Tag
    self.CurrentTag = NewTag  
    self.Owner.AutoSyncProp.FSMCharacterTag = NewTag

    -- 尝试调用进入新Tag逻辑
    local NewTagInfo = self.TagRule:GetTagInfo(NewTag)
    if self.Enable and NewTagInfo and NewTagInfo.EnterTag ~= nil then 
        NewTagInfo.OnEnterTag(self.Owner)
    end

    -- EventManager:FireEvent(EventID.OnCharacterTagChanged, self.Owner, CurTagInfo.Name, NewTagInfo.Name)
    return true
end

-- 增加一个自定义跳转条件，需要传入一个function，它接收两个参数: CurTagInfo, NewTagInfo
function FSM:AddCustomChecker(CheckerName, Checker)
    if not CheckerName or not Checker then 
        return 
    end

    if self.CustomCheckers[CheckerName] then 
        DebugPrint("Tianyi@ 该CustomChecker已注册")
        return 
    end

    Checker.Name = CheckerName
    self.CustomCheckers[CheckerName] = Checker
end

-- 将角色状态恢复为默认状态
function FSM:SetDefaultTag()
    if not self.TagRule then return end
    local DefaultTag = self.TagRule:GetDefaultTag(self.Owner)
    if DefaultTag then 
        self:SetTag(DefaultTag)
    end
 end

return FSM