local Component = {}
local NewGuideNoteName = DataMgr.ReddotNode.NewGuideNote.Name

function Component:EnterWorld()
    self:InitGuideBookReddotNode()
end

function Component:InitGuideBookReddotNode()
    ReddotManager.AddNode(NewGuideNoteName)
    ReddotManager.GetTreeNode(NewGuideNoteName).Count = 0
    for Id, Content in pairs(self.GuideBook) do
        self:AddGuideBookReddotCount(Id, Content)
    end
end

function Component:AddGuideBookReddotCount(Id, GuideBookData)
    if GuideBookData.Reward == 0 then return end
    if ReddotManager.GetTreeNode(NewGuideNoteName) then
        ReddotManager.IncreaseLeafNodeCount(NewGuideNoteName)
    end
end

function Component:SubGuideBookReddotCount(Id)
    if ReddotManager.GetTreeNode(NewGuideNoteName) and ReddotManager.GetTreeNode(NewGuideNoteName).Count > 0 then
        ReddotManager.DecreaseLeafNodeCount(NewGuideNoteName)
    end
end
function Component:GuideBookFinishSomething(Type,Id)
    if type(Id) == "string" then
        self:CallServerMethod("GuideBookFinishSomethingStr",Type, Id)
    end
    if type(Id) == "number" then
        self:CallServerMethod("GuideBookFinishSomethingInt",Type, Id)
    end
end
function Component:ClearGuideBookReddotCount()
    --重置数量到1再减一是为了能够触发红点事件
    local NewGuideBookNode = ReddotManager.GetTreeNode(NewGuideNoteName)
    if not NewGuideBookNode then return end
    NewGuideBookNode.Count = 1
    ReddotManager.DecreaseLeafNodeCount(NewGuideNoteName)
end


function Component:EchoGuideBook()
    PrintTable(self.GuideBook:all_dump(self.GuideBook),10,"GuideBook")
end

function Component:GMUnlockGuideBook(num)
    if not num then
        for key in pairs(DataMgr.GuideBook) do
            self:CallServerMethod("GMUnlockGuideBook", key)
        end
        return
    end
	self:CallServerMethod("GMUnlockGuideBook", num)
end

function Component:NotifyGuideBookUnlock(GuideNoteId)
    DebugPrint("解锁了" .. GuideNoteId .. "号教学")
    self:InitGuideBookReddotNode()
    -- 这里接一个弹出toast
    self:ShowGuideBookTips(GuideNoteId)
end

function Component:UpdateFirstMechanismTags(Tag)
	self:CallServerMethod("UpdateFirstMechanismTags", Tag)
end
function Component:TestUpdateFirstMechanismTags()
	self:CallServerMethod("UpdateFirstMechanismTags", "GameLine")
end
function Component:GuideBookGetReward(Id)
    local function callback(ErrCode)
        if ErrorCode:Check(ErrCode) then
            DebugPrint("服务器回调:奖励领取成功！！")
            EventManager:FireEvent(EventID.OnGetGuideBookReward, Id)
            self:SubGuideBookReddotCount(Id)
            self.GuideBook[Id].IsGettingReward = 0
        else
            DebugPrint("服务器回调:奖励领取失败！！")
        end
    end
	self:CallServer("GuideBookGetReward", callback,Id)
end

function Component:ShowGuideBookTips(GuideNoteId)
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    if not UIManager then
        return
    end
    if UIManager:GetUI("BattleMain") then -- 如果处于BattleMain界面才弹出
        UIManager:LoadUINew("GuideBook_Tips", GuideNoteId)
    end
end


return Component