
local FEntertainmentUtils = require "BluePrints.UI.WBP.Entertainment.EntertainmentUtils"
local EEntertainmentState = FEntertainmentUtils.EEntertainmentState
local EntertainmentModel = require ("BluePrints.UI.WBP.Entertainment.EntertainmentModel")



--- @class Entertainment_ShowModelComponent
local Component = Class()

function Component:OnInitialize()
    self.CharacterStaticCreatorId = 777
	self.CharacterStaticCreator = nil
end

function Component:OnConstruct()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
	assert(GameState)
	self.CharacterStaticCreator = GameState.StaticCreatorMap:Find(self.CharacterStaticCreatorId)
    self.WaitProcess = EntertainmentModel:TryGetWaitQueue()
    self.BlackScreenList = {}
end

function Component:OnDestruct()
    local BlackScreenList = self.BlackScreenList
    self.BlackScreenList = nil
    local UIManager = UIManager(self)
    if not (IsValid(UIManager)) then return end
    for Key, BlackScreen in pairs(BlackScreenList) do
        UIManager:HideCommonBlackScreen(BlackScreen)
    end
end

function Component:ActiveStaticCreator(StaticCreator)
	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	if (IsValid(GameMode) == false) then
		return
	end

	local StaticIds = TArray(0)
	StaticIds:Add(StaticCreator.StaticCreatorId)
	GameMode:TriggerActiveStaticCreator(StaticIds)
end

function Component:DactiveStaticCreator(StaticCreator)
	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	if (IsValid(GameMode) == false) then
		return
	end

	local StaticIds = TArray(0)
	StaticIds:Add(StaticCreator.StaticCreatorId)
	GameMode:TriggerInactiveStaticCreator(StaticIds)
end


function Component:LoadNpcAsync(NpcId, Callback)
    self.WaitProcess:AddProcess(function(OnFinished)
        self:SetInteractionEnabled(false)
        local OnFinal = function(Character)
            self:SetInteractionEnabled(true)
            if IsValid(self) then
                Callback(Character)
            end
            OnFinished()
        end
        local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
        if (not GameState) then
            UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Invite, "GameState无效", "获取 NPC 失败，game state 为空。")
            OnFinal(nil)
            return
        end
        if (not GameState.GetNpcInfoAsync) then
            UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Invite, "未找到GetNpcInfoAsync方法", string.format(
                            "获取 NPC 失败，game state：%s未实现 GetNpcInfoAsync 方法。", GameState:GetClass().Name))
            OnFinal(nil)
            return
        end

        GameState:GetNpcInfoAsync(NpcId, function(Res)
            if Res then
                OnFinal(Res)
                return 
            end
            self.CharacterStaticCreator.UnitId = NpcId
            self:ActiveStaticCreator(self.CharacterStaticCreator)
            GameState:GetNpcInfoAsync(NpcId, OnFinal)
        end)
    end)
    self.WaitProcess:ApplyTask()
end

function Component:DestoryNpc(NpcId, Callback)
    self.WaitProcess:AddProcess(function(OnFinished)
        self:DactiveStaticCreator(self.CharacterStaticCreator)  
        if IsValid(self) then
            Callback()
        end
        OnFinished()  
    end)
    self.WaitProcess:ApplyTask()
end

function Component:StartFadeIn(FadeInTime, FadeOutTime, Callback)
    local UIManager = UIManager(self)
	if not (IsValid(UIManager)) then
        Callback()
		return
	end
    local Key = self.BlackScreenList.LastKey or 0
    Key = Key + 1
    self.BlackScreenList.LastKey = Key
    self.WaitProcess:AddProcess(function(OnFinished)
        local BlackScreen 
        -- local ViewTarget = self.ViewTarget
        -- local Camera = self:GetEntertainmentCamera()
        -- self:PlayCameraSound(ViewTarget, Camera)
        self:SetInteractionEnabled(false)
        BlackScreen = UIManager:ShowCommonBlackScreen({
            InAnimationObj = self,
            InAnimationCallback = function(obj)
                self:SetInteractionEnabled(false)
                if IsValid(obj) then
                    Callback()
                end
                OnFinished()
            end,
            InAnimationPlayTime = FadeInTime,
            OutAnimationPlayTime = FadeOutTime
        })
        self.BlackScreenList[Key] = BlackScreen
    end)
    self.WaitProcess:ApplyTask()
    return Key
end

function Component:WaitTime(Duration, Callback)
    self.WaitProcess:AddProcess(function(OnFinished)
        self:AddTimer(0.001, function()-- 比较抽象的写法，双层定时器，保证能在下一帧执行（有时候下面可能会被卡掉导致同帧执行），修复Npc的动画不渲染的时候不更新
            self:AddTimer(Duration + 0.001, function()
                if IsValid(self) then
                    Callback()
                end
                OnFinished()
            end)
        end)
    end)
    self.WaitProcess:ApplyTask()
end


function Component:StartFadeOut(Key, Callback)
    local UIManager = UIManager(self)
	if not (IsValid(UIManager)) then
        Callback()
		return
    end
    local BlackScreenList = self.BlackScreenList
    self.WaitProcess:AddProcess(function(OnFinished)
        local BlackScreen = BlackScreenList[Key]
        BlackScreenList[Key] = nil
        if BlackScreen then
            UIManager:HideCommonBlackScreen(BlackScreen)
        end
        if IsValid(self) then
            Callback()
        end
        OnFinished()
    end)
    self.WaitProcess:ApplyTask()
end

function Component:EnterInvitation(CharacterId, TopicLevel, bIsReview, CallBack)
    self.WaitProcess:AddProcess(
        function(OnFinished)
            self:SetInteractionEnabled(false)
            self:SetShowCharacterActionWithState(EEntertainmentState.Invitation)
            self:AddTimer(self.EnterInvitationDelaySeconds, function()
                if IsValid(self.GameInputModeSubsystem) then
                    -- 进入前会有一段黑屏，聚焦可能不在黑屏上，此时先隐藏
                    self.GameInputModeSubsystem:SetNavigateWidgetVisibility(false)
                end
                local SojournsGameInstanceSubsystem = UE4.USojournsGameInstanceSubsystem.GetSubsystem(self)
                if not SojournsGameInstanceSubsystem then
                    if IsValid(self) then
                        CallBack(false)
                    end
                    OnFinished()
                    return
                end
                SojournsGameInstanceSubsystem:BeginInvitation(CharacterId, TopicLevel, bIsReview, function()
                    if IsValid(self) then
                        CallBack(false)
                    end
                    OnFinished()
                end, function ()
                    if IsValid(self) then
                        CallBack(true)
                    end
                    OnFinished()
                end)
            end)
        end)
    self.WaitProcess:ApplyTask()
end

function Component:RealEnterInvitation()
    self.WaitProcess:AddProcess(
        function(OnFinished)
            local SojournsGameInstanceSubsystem = UE4.USojournsGameInstanceSubsystem.GetSubsystem(self)
            if not SojournsGameInstanceSubsystem then
                OnFinished()
                return
            end
            SojournsGameInstanceSubsystem:RealBeginInvitation()
        end)
    self.WaitProcess:ApplyTask()
end
return Component