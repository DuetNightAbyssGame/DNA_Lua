local SoloTreasureDataModel = require "BluePrints.UI.WBP.Activity.Widget.SoloTreasure.SoloTreasureDataModel"
local Component = {}

--设置寻宝阵容
--@Squad = {["Char","MeleeWeapon","RangedWeapon","Phantom1","PhantomWeapon1","Phantom2","PhantomWeapon2","Pet"] = {Id = **,bTrial = false/true}}
function Component:SetTreasureHuntSquad(EventId, EventDungeonId, Squad, IsHard, Callback)
    self.logger.debug("SetTreasureHuntSquad Begin", EventId, EventDungeonId, Squad, IsHard)
    PrintTable(Squad, 3)
    local function CallbackFunc(Ret)
        self.logger.debug("SetTreasureHuntSquad Callback", Ret, EventId, EventDungeonId, Squad, IsHard)
        if Callback then
            Callback(Ret)
        end
    end
    self:CallServer("SetTreasureHuntSquad", CallbackFunc, EventId, EventDungeonId, Squad, IsHard)
end

function Component:EnterWorld()
    EventManager:AddEvent(EventID.OnLoginSuccess, self, self.OnLoginSuccess)
end

function Component:OnLoginSuccess()
    -- 缓存选关界面进度版数据
    SoloTreasureDataModel:InitBoardSnapshotOnLogin()
    -- 活动主界面红点初始化
    SoloTreasureDataModel:Init()
    -- Debug测试
    -- SoloTreasureDataModel:SoloTreasureDataModelDebugReset(self.EventId)
    ReddotManager.PrintNodeTree("SoloTreasure_LevelListView")
end

return Component
