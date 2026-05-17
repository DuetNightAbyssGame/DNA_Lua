--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_SpawnBallPlatform_C
require "UnLua"
local M = Class({
    "BluePrints.Item.BP_CombatItemBase_C",
    "BluePrints.Common.TimerMgr"
})

function M:CommonInitInfo(Info)
    M.Super.CommonInitInfo(self,Info)
    self.Balls = {false, false, false} --三个位置是否有球
    self.Bombs = {nil, nil, nil} --三个位置的炸弹
    self.ElapsedTime = 0.0
    self.Loc1 = self.Point1:K2_GetComponentLocation()
    self.Loc2 = self.Point2:K2_GetComponentLocation()
    self.Loc3 = self.Point3:K2_GetComponentLocation()
    self.WaitBall = {} --等待生成的球，用于在移动中收到了新的生成指令，先屯着等移动完再生成  序号：UnitId
    self.WaitIndex = 0
end

function M:AuthorityInitInfo(Info)
    M.Super.AuthorityInitInfo(self,Info)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    GameMode:GetDungeonComponent():AddSpawnBallPlatform(self.ManualItemId)
end

function M:ResetInfo()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then
        local Array = TArray(0)
        for i = 1, 3 do
            Array:Add(self["Point"..i].StaticCreatorId)
        end
        DebugPrint("zwkk ResetInfo", Array)
        GameMode:TriggerInactiveStaticCreator(Array)
    end
    self.Balls = {false, false, false} --三个位置是否有球
    self.Bombs = {nil, nil, nil} --三个位置的炸弹
    self.ElapsedTime = 0.0
    self.WaitBall = {}
    self.WaitIndex = 0
end

function M:OnActorReady(Info)
    M.Super.OnActorReady(self, Info)

    EventManager:AddEvent(EventID.OnSpawnTempleBomb, self, self.OnSpawnTempleBomb)
end

function M:ActiveCombat(bFromGameMode)
    self.IsActive = true
end

function M:InactiveCombat(bFromGameMode)
    self.IsActive = false
    --self:RemoveTimer("ColorBackHandle")
end

function M:ReceiveTick(DeltaSeconds)
    self.Overridden.ReceiveTick(self, DeltaSeconds)

    self.ElapsedTime = self.ElapsedTime + DeltaSeconds
    local Alpha = math.min(self.ElapsedTime / self.MoveTime, 1.0)

    for i = 2, 3 do
        if self.Bombs[i] then
            -- 执行线性插值
            local NewLocation = UE4.UKismetMathLibrary.VLerp(
                self["Loc"..i],
                self["Loc"..(i-1)],
                Alpha
            )
            -- 应用新位置
            self.Bombs[i]:K2_SetActorLocation(NewLocation, false, nil, false)
        end
    end
end

function M:OnSpawnTempleBomb(Eid, CreatorId)
    -- 有球生成完成的时候触发
    for i = 1, 3 do
        if CreatorId == self["Point"..i].StaticCreatorId then
            -- self.Balls[i] = true
            local Bomb = Battle(self):GetEntity(Eid)
            Bomb.Owner = self
            self.Bombs[i] = Bomb
            Bomb.OwnerManualId = self.ManualItemId
            -- 只有1号位可以交互
            if i ~= 1 then
                Bomb.ChestInteractiveComponent.bCanUsed = false
            end
            if self.ForbidInteractive then
                Bomb:ChangeToForbiddenState()
            end
            break
        end
    end
end

function M:SpawnBall(UnitId)
    -- 在第一个空位刷一个指定UnitId的球
    -- DebugPrint("zwkk SpawnBall", self.Bombs[1], self.Bombs[2], self.Bombs[3])
    if not self.IsActive then return end
    if self:IsExistTimer("MoveEnd") then
        -- 如果正在移动中，先把这个球放到等待列表
        self.WaitIndex = self.WaitIndex + 1
        self.WaitBall[self.WaitIndex] = UnitId
        return
    end
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not GameMode then return end
    local Index = 0
    for i = 1, 3 do
        if not self.Balls[i] then
            Index = i
            break
        end
    end
    if Index <= 0 then return end
    self["Point"..Index].UnitId = UnitId
    local Array = TArray(0)
	Array:Add(self["Point"..Index].StaticCreatorId)
    GameMode:TriggerActiveStaticCreator(Array, "SpawnBall")
    self.Balls[Index] = true
end

function M:OnBombInteractived()
    -- 当一个炸弹被交互后，如果它的Owner是自己则触发
    local function MoveEnd()
        self:SetActorTickEnabled(false)
        self.ElapsedTime = 0
        if self.Bombs[2] then
            self.Bombs[1] = self.Bombs[2]
            self.Balls[1] = true
        end
        if self.Bombs[3] then
            self.Bombs[2] = self.Bombs[3]
            self.Balls[2] = true
        else
            self.Bombs[2] = nil
            self.Balls[2] = false
        end
        self.Bombs[3] = nil
        self.Balls[3] = false
        if self.Bombs[1] then
            self.Bombs[1].ChestInteractiveComponent.bCanUsed = true
        end
        if self.WaitIndex > 0 then
            for i = 1, self.WaitIndex do
                self:SpawnBall(self.WaitBall[i])
            end
            self.WaitIndex = 0
            self.WaitBall = {}
        end
    end
    self:OnGetBall()
    self:PlaySound("event:/sfx/common/scene/shenmiao/ball_get")
    self:SetActorTickEnabled(true)
    self.Bombs[1] = nil
    self.Balls[1] = false
    -- 如果台子上已经没有球了，那直接MoveEnd，否则要等移动结束
    if not self.Balls[2] and not self.Balls[3] then
        MoveEnd()
    else
        self:AddTimer(self.MoveTime, MoveEnd, false, 0, "MoveEnd")
    end
end

function M:AllBallNormal()
    for i, Ball in pairs(self.Bombs) do
        if Ball then
            Ball:ChangeToNormalState()
            if i ~= 1 then
                Ball.ChestInteractiveComponent.bCanUsed = false
            end
        end
    end
    self.ForbidInteractive = false
end

function M:AllBallForbid()
    for i, Ball in pairs(self.Bombs) do
        if Ball then
            Ball:ChangeToForbiddenState()
            if i ~= 1 then
                Ball.ChestInteractiveComponent.bCanUsed = false
            end
        end
    end
    self.ForbidInteractive = true
end

return M
