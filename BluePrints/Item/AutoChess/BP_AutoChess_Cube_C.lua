--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type AutoChess_Cube_C
local BP_AutoChess_Cube_C = Class("BluePrints.Common.TimerMgr")

local CubeStateSet = CommonConst.AutoChess.CubeState

function BP_AutoChess_Cube_C:ReceiveBeginPlay()
    -- 绑定鼠标移入
    if self.OnBeginCursorOver then
        self.OnBeginCursorOver:Add(self, self._OnBeginCursorOver)
    end

    -- 绑定鼠标移出
    if self.OnEndCursorOver then
        self.OnEndCursorOver:Add(self, self._OnEndCursorOver)
    end

    -- 绑定鼠标点击
    if self.OnClicked then
        self.OnClicked:Add(self, self._OnClicked)
    end

    -- 绑定鼠标释放
    if self.OnReleased then
        self.OnReleased:Add(self, self._OnReleased)
    end
    
    -- if CommonUtils.GetRuntimePlatform(self) == "Mobile" then
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        -- 绑定触摸（移动端）
        if self.OnInputTouchBegin then 
            self.OnInputTouchBegin:Add(self, self._OnInputTouchBegin)
        end

        if self.OnInputTouchEnd then
            self.OnInputTouchEnd:Add(self, self._OnInputTouchEnd)
        end
    end
    
    -- 支持鼠标悬停
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    PlayerController.bEnableMouseOverEvents = true
    PlayerController.bEnableClickEvents = true


    -- 方块去掉，特效常驻
    local NiagaraComp = self.NS_AutoChess_Cell_szh
    NiagaraComp:Activate()
    self:InitEffect()
    self.CurrentState = CubeStateSet.InitEffect

    -- 接收输入，调试用
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
    self:EnableInput(PlayerController)

    EventManager:AddEvent(EventID.OnAutoChessCubeChangeState, self, self.OnAutoChessCubeChangeState)
    EventManager:AddEvent(EventID.OnAutoChessDisableCubeInteraction, self, self.DisableCubeInteraction)
end

function BP_AutoChess_Cube_C:OnAutoChessCubeChangeState(State, ...)
    if self.Enemy == true and self.bBanned and State ~= CubeStateSet.BanEnemy then
        return
    end

    local fn = self[State .. "Proxy"] or self[State]
    if type(fn) == "function" then
        local ok, err = pcall(fn, self, ...)
        if not ok then
            DebugPrint("BP_AutoChess_Cube_C:OnAutoChessCubeChangeState 调用方法失败:", State, err)
        end
    else
        DebugPrint("BP_AutoChess_Cube_C:OnAutoChessCubeChangeState 未找到方法:", State)
    end
end

function BP_AutoChess_Cube_C:CanPutinProxy()
    -- 敌方格子和已经放置怪物的友方格子无法放置
    if self.Enemy or self.MonsterEid then
        return
    end
    self:CanPutin()
    self.CurrentState = CubeStateSet.CanPutin
end

function BP_AutoChess_Cube_C:ForbidProxy(CubeIndex)
    if self.Enemy or self.Index ~= CubeIndex then
        return
    end
    self:Forbid()
    self.CurrentState = CubeStateSet.Forbid
end

function BP_AutoChess_Cube_C:CanChangeProxy(CubeIndex)
    if self.Enemy or self.Index == CubeIndex then
        return
    end
    self:CanChange()
    self.CurrentState = CubeStateSet.CanChange
end

function BP_AutoChess_Cube_C:InitEffectProxy()
    self:InitEffect()
    self.CurrentState = CubeStateSet.InitEffect
end

function BP_AutoChess_Cube_C:HoverProxy(CubeIndex, bIsEnemy)
    if self.Enemy ~= bIsEnemy or self.Index ~= CubeIndex then
        return
    end
    self:Hover()
    self.CurrentState = CubeStateSet.Hover
end

function BP_AutoChess_Cube_C:UnHoverProxy(CubeIndex, bIsEnemy)
    if self.Enemy ~= bIsEnemy or self.Index ~= CubeIndex then
        return
    end
    self:UnHover()
    self.CurrentState = CubeStateSet.UnHover
end

-- 不指定CubeIndex和bIsEnemy即为全部格子放弃选中
function BP_AutoChess_Cube_C:XuanzhongProxy(CubeIndex, bIsEnemy)
    if self.Enemy ~= bIsEnemy or self.Index ~= CubeIndex then
        -- 同时只会有一个格子被选中
        self:UnHoverProxy(self.Index, self.Enemy)
        return
    end
    self:Xuanzhong()
    self.CurrentState = CubeStateSet.Xuanzhong
end

-- 禁用所有敌方格子的交互
function BP_AutoChess_Cube_C:BanEnemy(bFlag)
    if self.Enemy == true then
        self.bBanned = bFlag
    end
end

function BP_AutoChess_Cube_C:_OnBeginCursorOver(TouchedActor)
    if self.CurrentState == CubeStateSet.Xuanzhong then
        return
    end
    if self.Enemy == true and self.bBanned then
        return
    end
    self:HoverProxy(self.Index, self.Enemy)
    if self.Owner then
        self.Owner.CurrentHoverCubeIndex = self.Index
        self.Owner:OnCubeHovered(self.Index, self.Enemy, self)
    end
end

function BP_AutoChess_Cube_C:_OnEndCursorOver(TouchedActor)
    if self.CurrentState == CubeStateSet.Xuanzhong then
        return
    end
    if self.Enemy == true and self.bBanned then
        return
    end
    self:UnHoverProxy(self.Index, self.Enemy)
    if self.Owner then
        self.Owner.CurrentHoverCubeIndex = nil
        self.Owner:OnCubeUnhovered(self.Index, self.Enemy, self)
    end
end

function BP_AutoChess_Cube_C:_OnClicked(ClickedActor, ButtonPressed)
    if self.Enemy == true and self.bBanned then
        return
    end
    if self.Owner then
        self.Owner:OnCubeClicked(self.Index, self.Enemy, self, ButtonPressed)
        if self.Owner.CurrentSelectCubeIndex and self.Owner.CurrentSelectCubeIndex == self.Index then
            self.Owner.CurrentSelectCubeIndex = nil
        else
            self.Owner.CurrentSelectCubeIndex = self.Index
        end
    end
end

function BP_AutoChess_Cube_C:_OnReleased(ReleasedActor, ButtonReleased)
    if self.Enemy == true and self.bBanned then
        return
    end
    if self.Owner then
        -- self.Owner.CurrentSelectCubeIndex = nil
        self.Owner:OnCubeReleased(self.Index, self.Enemy, self, ButtonReleased)
    end
end

function BP_AutoChess_Cube_C:_OnInputTouchBegin(FingerIndex, TouchedActor)
    if self.Enemy == true and self.bBanned then
        return
    end
    if self._OnClicked then
        local ButtonPressed = UE.FKey("Touch")
        self:_OnClicked(TouchedActor, ButtonPressed)
    end
end

function BP_AutoChess_Cube_C:_OnInputTouchEnd(FingerIndex, TouchedActor)
    if self.Enemy == true and self.bBanned then
        return
    end
    if self._OnReleased then
        local ButtonReleased = UE.FKey("Touch")
        self:_OnReleased(TouchedActor, ButtonReleased)
    end
end

function BP_AutoChess_Cube_C:DisableMouseEvent()
    if self.OnBeginCursorOver then
        self.OnBeginCursorOver:Remove(self, self._OnBeginCursorOver)
    end

    if self.OnEndCursorOver then
        self.OnEndCursorOver:Remove(self, self._OnEndCursorOver)
    end

    if self.OnClicked then
        self.OnClicked:Remove(self, self._OnClicked)
    end

    if self.OnReleased then
        self.OnReleased:Remove(self, self._OnReleased)
    end
end

function BP_AutoChess_Cube_C:SetMonsterState(IsSelected)
    DebugPrint("ayff test set monster state at CubeIndex:",self.Index, " to IsSelected:", IsSelected)
    if self.MonsterEid then
        local Monster = Battle(self):GetEntity(self.MonsterEid)
        local Loc = Monster:K2_GetActorLocation()
        if not self.LocZ then
            self.LocZ = Loc.Z
        end

        if IsSelected then
            -- 选中状态，悬浮
            local NewLoc = FVector(Loc.X, Loc.Y, self.LocZ + 50)
            Monster:SetTickEnabled(ETickCtrlType.GamePlay,ETickObjectFlag.FLAG_CHARMOVEMENTCOMPONENT,false)
            Monster.EMAnimInstance.EnableFootIK = false
            Monster:K2_SetActorLocation(NewLoc, false, nil, true)
        else
            -- 非选中状态，落地
            Monster:SetTickEnabled(ETickCtrlType.GamePlay,ETickObjectFlag.FLAG_CHARMOVEMENTCOMPONENT,true)
            Monster:GetMovementComponent():LockMovementMode(false, EMovementMode.MOVE_Falling)

            -- 飞行怪物特殊处理
            if Monster:HasAnyTags_Table(Monster, {"Mon.Fly",}, false) then
                local NewLoc = FVector(Loc.X, Loc.Y, self.LocZ)
                Monster:K2_SetActorLocation(NewLoc, false, nil, true)
            end
        end
    end
end

function BP_AutoChess_Cube_C:DisableCubeInteraction()
    if CommonUtils.GetRuntimePlatform(self) == "Mobile" then
        if self.OnInputTouchBegin then
            self.OnInputTouchBegin:Clear()
        end

        if self.OnInputTouchEnd then
            self.OnInputTouchEnd:Clear()
        end
    end

    -- 禁用鼠标点击
    if self.OnClicked then
        self.OnClicked:Clear()
    end

    -- 禁用鼠标释放
    if self.OnReleased then
        self.OnReleased:Clear()
    end
end

return BP_AutoChess_Cube_C
