---@class ClientMailComp
local Component = {}
local NormalMailName = DataMgr.ReddotNode.NormalMail.Name

local function PrintDictProp(Prop)
    for key, value in pairs(Prop._inner) do
        DebugPrint("key :",key)
        PrintTable(value.Props,2)
    end
end

function Component:EnterWorld()
    self:InitMailReddotNode()
    self._PendingDelMails = {}
end

function Component:LeaveWorld()
    self._PendingDelMails = nil
end

function Component:_OnPropChangeMailInbox( keys)
    if CommonUtils.Size(keys) > 0 then
        local Node = ReddotManager.GetTreeNode(NormalMailName)
        if not Node then return end
        local UniqueId = keys[1]
        local MailData = self.MailInbox[UniqueId] or self.StarMails[UniqueId]
        if CommonUtils.Size(keys) ==1 and MailData and (not self._DeletedStarMail) then
            self:_AddNormalMailReddotCount(MailData)
        end
        self._DeletedStarMail = nil

        if CommonUtils.Size(keys) ==1 and not MailData then
            local MailData = self._PendingDelMails[UniqueId]
            if MailData and MailData.MailReaded ==1 then
                if  MailData.RewardGot==0 then
                    local FakeMailData = {RewardGot=1, MailReaded = 1, UniqueId = UniqueId}
                    self:_SubNormalMailReddotCount(FakeMailData)
                end
            elseif not MailData then
                local FakeMailData = {RewardGot=1, MailReaded = 1, UniqueId = UniqueId}
                self:_SubNormalMailReddotCount(FakeMailData)
            end
            self._PendingDelMails[UniqueId] = nil
        end
    end
end

--region 邮件红点接入红点树 (邮件红点不需要缓存)
function Component:InitMailReddotNode()
    local Node = ReddotManager.GetTreeNode(NormalMailName)
    if not Node then
        Node = ReddotManager.AddNode(NormalMailName)
    end
    ReddotManager.ClearLeafNodeCount(NormalMailName)
    for Unique, MailData in pairs(self.MailInbox or {}) do
        DebugPrint(string.format("初始化邮件红点，UniqueId %s, 已领奖：%s, 已读%s", Unique,MailData.RewardGot, MailData.MailReaded))
        self:_AddNormalMailReddotCount(MailData)
    end 
    for Unique, MailData in pairs(self.StarMails or {}) do
        DebugPrint(string.format("初始化邮件红点，UniqueId %s, 已领奖：%s, 已读%s", Unique,MailData.RewardGot, MailData.MailReaded))
        self:_AddNormalMailReddotCount(MailData)
    end
end

function Component:_AddNormalMailReddotCount(MailData)
    if MailData.MailReaded==0 or MailData.RewardGot ==0 then
        
        local Detail = ReddotManager.GetLeafNodeCacheDetail(NormalMailName)
        if not Detail[MailData.UniqueId] then
            DebugPrint("_AddNormalMailReddotCount邮件")
            ReddotManager.IncreaseLeafNodeCount(NormalMailName)
            Detail[MailData.UniqueId] = 1
        end
    end
end

function Component:_SubNormalMailReddotCount(MailData)
    if (MailData.MailReaded==1 and MailData.RewardGot ==1) then
        local Detail = ReddotManager.GetLeafNodeCacheDetail(NormalMailName)
        if Detail[MailData.UniqueId] then
            DebugPrint("_SubNormalMailReddotCount邮件")
            ReddotManager.DecreaseLeafNodeCount(NormalMailName)
            Detail[MailData.UniqueId] = nil
        end
    end
end

function Component:_SubAllNormalMailReddotCount()
    ReddotManager.ClearLeafNodeCount(NormalMailName, true)
end
--endregion 邮件红点接入红点树

function Component:EchoMail()
    DebugPrint(("==========================="))
    self.logger.info("MailInbox : ")
    PrintDictProp(self.MailInbox)
    self.logger.info("StarMail : ")
    PrintDictProp(self.StarMails)
    DebugPrint(("==========================="))
end


function Component:GetMailRewards(UniqueID)
    local function cb(errCode,rewards)
        EventManager:FireEvent(EventID.OnGetMailRewards,errCode,UniqueID,rewards)
        self.logger.info("GetMailRewards Callback",UniqueID,ErrorCode:Name(errCode))
        PrintTable(rewards,10,"GetMailRewards Callback")
        if errCode == ErrorCode.RET_SUCCESS then
            self:_SubNormalMailReddotCount(self.MailInbox[UniqueID] or self.StarMails[UniqueID])
        end
    end
    self.logger.info("GetMailRewards Start UniqueID:",UniqueID)
    self:CallServer("GetMailRewards",cb,UniqueID)
end

function Component:MarkMailReaded(UniqueID)
    local function cb(errCode)
        EventManager:FireEvent(EventID.OnMarkMailReaded,errCode,UniqueID)
        self.logger.info("MarkMailReaded Callback",ErrorCode:Name(errCode))
        if errCode == ErrorCode.RET_SUCCESS then
            self:_SubNormalMailReddotCount(self.MailInbox[UniqueID] or self.StarMails[UniqueID])
        end
    end
    self.logger.info("MarkMailReaded Start UniqueID:",UniqueID)
    self:CallServer("MarkMailReaded",cb,UniqueID)
end

function Component:MarkMailStar(UniqueID)
    local MailData = self.MailInbox[UniqueID]
    if MailData then
        self._PendingDelMails[UniqueID] = {RewardGot =MailData.RewardGot, MailReaded=MailData.MailReaded}
    end
    local function cb(errCode,reward)
        if errCode == ErrorCode.RET_SUCCESS then
            self:_SubNormalMailReddotCount(self.StarMails[UniqueID])
        end
        EventManager:FireEvent(EventID.OnMarkMailStar,errCode,UniqueID,reward)
        self.logger.info("MarkMailStar Callback",ErrorCode:Name(errCode),reward)
    end
    self.logger.info("MarkMailStar Start UniqueID:",UniqueID)
    self:CallServer("MarkMailStar",cb,UniqueID)
end

function Component:DeleteReadedMails()
    local function cb(errCode)
        self.logger.info("DeleteReadedMails Callback",ErrorCode:Name(errCode))
        EventManager:FireEvent(EventID.OnDeleteMail)
        self:EchoMail()
    end
    for UniqueID,MailData in pairs(self.MailInbox) do
        self._PendingDelMails[UniqueID] = {RewardGot =MailData.RewardGot, MailReaded=MailData.MailReaded}
    end
    self.logger.info("DeleteReadedMails Start")
    self:CallServer("DeleteReadedMails",cb)
end

function Component:CancelMailStar(UniqueID)
    self._DeletedStarMail = self.StarMails[UniqueID]
    local function cb(errCode)
        EventManager:FireEvent(EventID.OnCancelMailStar,errCode,UniqueID)
        self.logger.info("CancelMailStar Callback",ErrorCode:Name(errCode))
    end
    self.logger.info("CancelMailStar Start UniqueID:",UniqueID)
    self:CallServer("CancelMailStar",cb,UniqueID)
end

function Component:DeleteMail(UniqueID)
    local MailData = self.MailInbox[UniqueID] or self.StarMails[UniqueID]
    if self.MailInbox[UniqueID] then
        self._PendingDelMails[UniqueID] = {RewardGot =MailData.RewardGot, MailReaded=MailData.MailReaded}
    end
    local function cb(errCode)
        self.logger.info("DeleteMail Callback",ErrorCode:Name(errCode))
        EventManager:FireEvent(EventID.OnDeleteMail)
        if errCode == ErrorCode.RET_SUCCESS then
            local FakeMailData = {RewardGot=1, MailReaded = 1, UniqueId = UniqueID}
            self:_SubNormalMailReddotCount(FakeMailData)
        end
    end
    self.logger.info("DeleteMail Start UniqueID:",UniqueID)
    self:CallServer("DeleteMail",cb,UniqueID)
end

function Component:GetAllMailReward()
    local function cb(errCode, UniqueIds)
        EventManager:FireEvent(EventID.OnGetAllMailReward, errCode, UniqueIds)
        self.logger.info("GetAllMailReward Callback", ErrorCode:Name(errCode))
        if errCode == ErrorCode.RET_SUCCESS then
            self:_SubAllNormalMailReddotCount()
        end
    end
    self.logger.info("GetAllMailReward Start ")
    self:CallServer("GetAllMailReward", cb)
end


return Component