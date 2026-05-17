require "UnLua"

---@type BP_EMGameViewportClien_C
local M = Class()

---无视任何场合的键盘输入通知
---@param ControllerId number
---@param Key FKey
---@param EventType EInputEvent
function M:OnInputKey_Lua(ControllerId, Key, EventType)
    DebugPrint(LXYTag, "BP_EMGameViewportClient_C:: OnInputKey_Lua", Key.KeyName, EventType)
    local bNeedRecord = false
    if EventType == EInputEvent.IE_Pressed then
        bNeedRecord = true
        EventManager:FireEvent(EventID.GameViewportInputKeyPressed, Key, EventType)
    elseif EventType == EInputEvent.IE_Released then
        bNeedRecord = true
        EventManager:FireEvent(EventID.GameViewportInputKeyReleased, Key, EventType)
    elseif EventType == EInputEvent.IE_Repeat then
        EventManager:FireEvent(EventID.GameViewportInputKeyLongPressed, Key, EventType)
    end

    if not bNeedRecord then
        return
    end
    
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    if IsValid(GameInstance) then
        local SceneMgr = GameInstance:GetSceneManager()
        if IsValid(SceneMgr) then
            SceneMgr:ReceivedInputKey(Key, EventType)
        end
    end
end

---无视任何场合的轴输入通知
function M:OnInputAxis_Lua(ControllerId, Key, Delta, DeltaTime, NumSamples, bGamepad)
    --DebugPrint(LXYTag, "BP_EMGameViewportClient_C:: OnInputAixs_Lua", Key.KeyName)
end

---窗口尺寸变化结束通知
function M:OnViewportSizeChanged_Lua()
    DebugPrint(LXYTag, "BP_EMGameViewportClient_C:: OnViewportSizeChanged_Lua")
    EventManager:FireEvent(EventID.GameViewportSizeChanged)
end

return M

