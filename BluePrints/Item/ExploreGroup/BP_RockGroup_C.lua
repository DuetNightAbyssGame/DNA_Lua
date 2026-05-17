--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
---@type BP_RockGroup_C
local M = Class({
    "BluePrints.Item.BP_CombatItemBase_C",
    "BluePrints.Common.TimerMgr"
})

function M:ReceiveBeginPlay()
    self.Super.ReceiveBeginPlay(self)
    -- self.RightNums 是总共的正确石块数量
    self.FinishNum = 0  -- 完成的石块数量
    self.CurRotate = 0
    self.HasWrongOne = false
    self.RotateHalf = false

    -- -- 要获取每个Group组件，旋转用
    -- self.Groups = {}
    -- local Components = self:K2_GetComponentsByClass(UE.USceneComponent)
    -- if Components then
    --     for _, Component in pairs(Components) do
    --         local Name = Component:GetName()
    --         if string.find(Name, "Group") then
    --             table.insert(self.Groups, Component)
    --         end
    --     end
    -- end
end

function M:OnActorReady(Info)
    M.Super.OnActorReady(self, Info)
    EventManager:AddEvent(EventID.OnRingRockFinish, self, self.OnRingRockFinish)
    self:GetAllRocks()
end

function M:ReceiveTick(DeltaSeconds)
    self.Overridden.ReceiveTick(self, DeltaSeconds)
    if self.IsActive then
        local Rotate = self.RotateSpeed * DeltaSeconds * self.RotateDir
        self.CurRotate = self.CurRotate + Rotate

        -- 改成石块自己转，适配异性的石块组
        for _, v in pairs(self.Rocks) do
            v:K2_AddActorWorldRotation(FRotator(0, Rotate, 0), false, nil, false)
        end

        if self.CurRotate >= self.RotateNum * 360.0 then
            self:RotateEnd()
            return
        end
        -- for _, v in pairs(self.Groups) do
        --     v:K2_AddWorldRotation(FRotator(0, Rotate, 0), false, nil, false)
        -- end
    end
end

function M:OnRingRockFinish(IsRightOne, Eid)
    if not self:CheckIsSelfRock(Eid) then return end
    if not IsRightOne then
        self.HasWrongOne = true
    end
    self.FinishNum = self.FinishNum + 1
    if self.FinishNum ~= self.RightNums then return end
    if not self.HasWrongOne then
        -- 解谜完成
        self:ChangeState("Manual", 0, self.FinishStateId)
    else
        -- 重置
        if self.Rocks:Num() <= 0 then
            self:GetAllRocks()
        end
        for _, v in pairs(self.Rocks) do
            v.Finish = false
            v.Energy = 0
            if v.AlreadyPull then
                v.IsInReset = true
                v:StartReset()
                v.AlreadyPull = false
            end
        end
        self.FinishNum = 0
        self.HasWrongOne = false
        self:OnWrong()
    end
end

function M:ActiveCombat()
    M.Super.ActiveCombat(self)
    -- 进入播放状态，等待石块归位，之后开始旋转
    for _, v in pairs(self.Rocks) do
        v.CanPull = false
        v.Finish = false
        v.Energy = 0
        if v.AlreadyPull then
            v.IsInReset = true
            v:StartReset()
            v.AlreadyPull = false
        end
    end
    self.FinishNum = 0
    self.HasWrongOne = false
    self:AddTimer(self.ResetRockTime, self.OnActive, false, 0)
end

function M:DeActiveCombat()
    M.Super.DeActiveCombat(self)
end

function M:OnActive()
    -- 开始旋转
    self.RotateHalf = not self.RotateHalf
    self.CurRotate = 0
    -- local CurRot = self.Group1:K2_GetComponentRotation()
    if self.Rocks:Num() <= 0 or not self.Rocks[1] then
        self:GetAllRocks()
    end
    local CurRot = self.Rocks[1]:K2_GetActorRotation()
    self.TargetRotation = FRotator(CurRot.Pitch, CurRot.Yaw + (tonumber(string.format("%.1f", self.RotateNum)) % 1) * 360.0, CurRot.Roll)
    self:SetActorTickEnabled(true)
end

function M:RotateEnd()
    self:SetActorTickEnabled(false)
    -- for _, v in pairs(self.Groups) do
    --     v:K2_SetWorldRotation(self.TargetRotation, false, nil, false)
    -- end
    for _, v in pairs(self.Rocks) do
        v:K2_SetActorRotation(self.TargetRotation, false, nil, false)
    end
    self:OnDeActive()
end

function M:OnDeActive()
    -- 旋转结束
    if self.RotateHalf then
        self:AddTimer(self.WaitTime, self.OnActive, false, 0)
        self:OnRotateEnd()
    else
        self:ChangeState("Manual", 0, self.InitStateId)
        -- 现在石块可以被拉动
        for _, v in pairs(self.Rocks) do
            v.CanPull = true
        end
    end
end

function M:OnEnterState(NowStateId)
    self.Overridden.OnEnterState(self, NowStateId)

    if NowStateId == self.FinishStateId then
        -- 完成后归位
        for _, v in pairs(self.Rocks) do
            v.CanPull = false
            v.Finish = false
            v.Energy = 0
            if v.AlreadyPull then
                v.IsInReset = true
                v:StartReset()
                v.AlreadyPull = false
            end
        end
    end
end

function M:CheckIsSelfRock(Eid)
    for _, v in pairs(self.Rocks) do
        if v.Eid == Eid then
            return true
        end
    end
    return false
end

return M
