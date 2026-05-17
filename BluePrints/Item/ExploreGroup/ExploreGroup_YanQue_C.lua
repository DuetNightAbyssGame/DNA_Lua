--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type Explore_YanQue_C
local M = Class("BluePrints.Item.ExploreGroup.ExploreStaticCreator_C")

function M:FireCube(YanQueCreator, CubeCreator)
    if YanQueCreator.ChildEids:Length() == 0 or CubeCreator.ChildEids:Length() == 0 then
        return
    end
    local YanQue = Battle(self):GetEntity(YanQueCreator.ChildEids[1])
    local Cube = Battle(self):GetEntity(CubeCreator.ChildEids[1])
    if not YanQue or not Cube or not YanQue.GetFirePos then
        return
    end
    local Position = YanQue:GetFirePos()
    if YanQue:CheckCanFireCube() then
        Cube:FireCube(Position, YanQue.Eid)
    end
end

function M:ReceiveOnExploreLimitStarted(Title, Des, TotalTargetNum)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if GameState.ActiveLimitTimeExploreGroup ~= 0 then
        --已有挑战类在进行时，理论上开启机关不能被交互，但防止以后有奇怪的入口，在这里额外隔离一次
        print(_G.LogTag,"LXZ TryActive LimitTimeExploreGroup", self.ExploreGroupId, "Failed,", GameState.ActiveLimitTimeExploreGroup, "Has Actived")
        return
    end
    GameState.ActiveLimitTimeExploreGroup = self.ExploreGroupId;
    self:UpdateExploreData("bGroupInLimit", true)
    -- 加载 挑战开始Toast
    UIManager(self):LoadUINew("ExploreToastTips", "UI_Explore_Yanque_Start")

    -- 加载 进度UI
    if self.YanQue and self.YanQue.ChildEids:Length() > 0 then
        self.ProgressUI = UIManager(self):LoadUINew("YanQueProgress", self.YanQue.ChildEids[1])
    end

    -- 加载 开始任务提示
    self.IsHideWorldTask = false
    if Title ~= "" or Des ~= "" then
        self.IsHideWorldTask = true

        local UIObjs = MissionIndicatorManager:GetIndicatorUIObjBySTLType("Dynamic")
        if not IsEmptyTable(UIObjs) then
            for _, UI in pairs(UIObjs) do
                if UI then
                    UI:Hide("ExploreLimit")
                end
            end
        end

        if not self:ShowExploreTaskPanel(Title, Des, TotalTargetNum) then
            self:AddTimer(0.1, self.ShowExploreTaskPanel, true, 0, "ShowExploreTaskPanelBindToTimer", false, Title, Des, TotalTargetNum)
        end
    end
    
    --玩家死亡探索组自动失败
    EventManager:AddEvent(EventID.CharDie, self, self.OnCharDie)

    self.bIsFar = false

    self.Overridden.ReceiveOnExploreLimitStarted(self, Title, Des, TotalTargetNum)
end

function M:ReceiveOnExploreGroupResetUI(bShowToast)
    M.Super.ReceiveOnExploreGroupResetUI(self, bShowToast)
    if self.ProgressUI and self.ProgressUI.OnReset then
        self.ProgressUI:OnReset()
    end
    self.bIsFar = false
end

function M:ShowWarningToast()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if GameState then
        GameState:ShowDungeonToast_Lua(GText("UI_Explore_Yanque_LimitDiatance"), 3, EToastType.Warning)
    end
end

return M
