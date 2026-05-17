
--require "UnLua"

local Component = Class()


-- GameModeEvent
-- OnInit  OnEnd  OnDead OnBattle OnPause OnCustomEvent 
-- OnDefenceVoteBegin
-- 通用的，可能多处用到的，委托绑定，如果只是单纯广播，无需注册

function Component:RegisterGameModeEvent(GameModeEvent, Owner, Func)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not IsValid(GameMode) then
        GameMode = GWorld.GameInstance:GetCurrentGameMode()
    end
    if not IsValid(GameMode) then
        return
    end

    local FunctionName = "RegisterGameMode"..GameModeEvent
    
    if self[FunctionName] ~= nil then
        DebugPrint ("GameModeInterface 注册事件：", GameModeEvent)
        self[FunctionName](self, GameMode, Owner, Func)
    end
end

function Component:RemoveGameModeEvent(GameModeEvent, Owner, Func)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not IsValid(GameMode) then
        GameMode = GWorld.GameInstance:GetCurrentGameMode()
    end
    if not IsValid(GameMode) then
        return
    end

    local FunctionName = "RemoveGameMode"..GameModeEvent
    if self[FunctionName] ~= nil then
        DebugPrint ("GameModeInterface 移除事件：", GameModeEvent)
        self[FunctionName](self, GameMode, Owner, Func)
    end
end

--------------------Register------------------------------------
function Component:RegisterGameModeOnEnd(GameMode, Owner, Func)
    GameMode.OnEndDelegates:Add(Owner, Func)
end

function Component:RegisterGameModeOnInit(GameMode, Owner, Func)
    GameMode.OnInitDelegates:Add(Owner, Func)
end

function Component:RegisterGameModeOnDestroy(GameMode, Owner, Func)
    GameMode.OnDestroyDelegates:Add(Owner, Func)
end

function Component:RegisterGameModeOnBattle(GameMode, Owner, Func)
    GameMode.OnBattleDelegates:Add(Owner, Func)
end

function Component:RegisterGameModeOnPause(GameMode, Owner, Func)
    GameMode.OnPauseDelegates:Add(Owner, Func)
end

function Component:RegisterGameModeOnAlert(GameMode, Owner, Func)
    GameMode.OnAlertDelegates:Add(Owner, Func)
end

function Component:RegisterGameModeOnEnterCommonAlert(GameMode, Owner, Func)
    GameMode.OnEnterCommonAlertDelegates:Add(Owner, Func)
end

function Component:RegisterGameModeOnExitCommonAlert(GameMode, Owner, Func)
    GameMode.OnExitCommonAlertDelegates:Add(Owner, Func)
end

function Component:RegisterGameModeOnCustomEvent(GameMode, Owner, Func)
    GameMode.OnCustomEventDelegates:Add(Owner, Func)
end

function Component:RegisterGameModeOnDead(GameMode, Owner, Func)
    GameMode.OnDeadDelegates:Add(Owner, Func)
end

function Component:RegisterGameModeOnDeadStaticUnit(GameMode, Owner, Func)
    GameMode.OnDeadStaticUnitDelegates:Add(Owner, Func)
end

function Component:RegisterGameModeOnDestroy(GameMode, Owner, Func)
    GameMode.OnUnitDestroyDelegates:Add(Owner, Func)
end

function Component:RegisterGameModeOnEnter(GameMode, Owner, Func)
    GameMode.OnEnterDelegates:Add(Owner, Func)
end

function Component:RegisterGameModeOnExit(GameMode, Owner, Func)
    GameMode.OnExitDelegates:Add(Owner, Func)
end

function Component:RegisterGameModeOnDisconnect(GameMode, Owner, Func)
    GameMode.OnDisconnectDelegates:Add(Owner, Func)
end

----------------------------------------------------------------


--------------------Remove------------------------------------
function Component:RemoveGameModeOnEnd(GameMode, Owner, Func)
    GameMode.OnEndDelegates:Remove(Owner, Func)
end

function Component:RemoveGameModeOnInit(GameMode, Owner, Func)
    GameMode.OnInitDelegates:Remove(Owner, Func)
end

function Component:RemoveGameModeOnCustomEvent(GameMode, Owner, Func)
    GameMode.OnCustomEventDelegates:Remove(Owner, Func)
end

function Component:RemoveGameModeOnDead(GameMode, Owner, Func)
    GameMode.OnDeadDelegates:Remove(Owner, Func)
end

function Component:RemoveGameModeOnDeadStaticUnit(GameMode, Owner, Func)
    GameMode.OnDeadStaticUnitDelegates:Remove(Owner, Func)
end

function Component:RemoveGameModeOnDestroy(GameMode, Owner, Func)
    GameMode.OnUnitDestroyDelegates:Remove(Owner, Func)
end
----------------------------------------------------------------

return Component
