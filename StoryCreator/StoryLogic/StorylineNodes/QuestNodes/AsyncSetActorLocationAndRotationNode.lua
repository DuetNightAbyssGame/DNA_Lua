local AsyncSetActorLocationAndRotationNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')

function AsyncSetActorLocationAndRotationNode:Init()
    ---@type number
    self.UnitId = 0
    ---@type string
    self.NewTargetPointName = nil
    ---@type boolean
    self.IsForceIdle = nil
    ---@type boolean
    self.FadeIn = nil
    ---@type boolean
    self.FadeOut = nil
    ---@type boolean
    self.bResetCamera = nil
    ---@type BP_TalkContext_C
    self.TalkContext = nil
    -- self.Context = nil
    ---@type boolean 是否强制异步加载
    self.bForceAsyncLoading = nil
    ---@type boolean
    self.IsWhite = nil
end

function AsyncSetActorLocationAndRotationNode:Execute(Callback)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    if IsValid(Player) then
        Player:DisablePlayerInputInDeliver(true)
    end
    -- self.Context = Context
    local GameInstance = GWorld.GameInstance
    local SceneMgrComponent = GameInstance:GetSceneManager()
    ---@type BP_TalkContext_C
    self.TalkContext = GameInstance:GetTalkContext()
    local TargetActor = nil
    local EMGameState = UE4.UGameplayStatics.GetGameState(self.TalkContext)
    if(self.UnitId==0) then
        TargetActor = self.TalkContext.Player
    else
        TargetActor = EMGameState.NpcCharacterMap:FindRef(self.UnitId)
    end
    local TargetActorController = TargetActor:GetController()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self.TalkContext)
    local NewTargetPoint = EMGameState:GetTargetPoint(self.NewTargetPointName)
    local LevelLoader = GameMode:GetLevelLoader()

    local FadeOut = function()
        UIManager(self):HideCommonBlackScreen("AsyncSetActorLocAndRotNode")
    end

    local FadeInCallback=function()
        SceneMgrComponent:ShowOrHideAllSceneGuideIcon(false)
        local TaskIndicator = UIManager(self):GetUIObj("MainTaskIndicator")
        if IsValid(TaskIndicator) then
            TaskIndicator:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        if TargetActorController:IsA(APlayerController) then
            TargetActor:DisableInput(TargetActorController)
        end
        
        local SetActorTransform = function()
            if(IsValid(NewTargetPoint)) then
                GameMode:EMSetActorLocationAndRotation(self.UnitId, self.NewTargetPointName, true, true);
                if(self.UnitId==0) then
                    TargetActor:SetSafeLocation()
                end
                if self.bResetCamera then
                    TargetActor:GetController():SetControlRotation(TargetActor:K2_GetActorRotation())
                end
            end
        end

        if(IsValid(LevelLoader) and IsValid(NewTargetPoint)) then
			local TargetLevelId = GameMode:GetLevelLoader():GetLevelIdByLocation(NewTargetPoint:K2_GetActorLocation())
			local CurrentLevelId = GameMode:GetLevelLoader():GetLevelIdByLocation(TargetActor:K2_GetActorLocation())
			local WorldCompositionSubsystem = GameMode:GetWCSubSystem()
            -- WC存在
            if WorldCompositionSubsystem then
                -- 强制异步加载场景
                if self.bForceAsyncLoading  then
                    WorldCompositionSubsystem:RequestAsyncTravel(self.TalkContext.Player, NewTargetPoint:GetTransform(), {self.TalkContext, FadeOut}, self.bResetCamera)
                -- 非强制异步加载场景
                else
                    -- TargetLocation的地面场景已加载，直接设置玩家位置
                    if WorldCompositionSubsystem:IsBigObjectLevelLoadedByLocation(NewTargetPoint:K2_GetActorLocation()) then
                        SetActorTransform()
                        FadeOut()
                    else
                    -- 反之等场景加载后再设置玩家位置
                        WorldCompositionSubsystem:RequestAsyncTravel(self.TalkContext.Player, NewTargetPoint:GetTransform(), {self.TalkContext, FadeOut}, self.bResetCamera)
                    end
                end
                return
            -- WC不存在
            else
                --Do nothing
            end

            if LevelLoader:GetLevelLoaded(TargetLevelId) then
                SetActorTransform()
                FadeOut()
                return
            end

            if(TargetLevelId~=CurrentLevelId) then
                LevelLoader:BindArtLevelLoadedCompleteCallback(TargetLevelId, function()
                    SetActorTransform()
                    FadeOut()
                end)
                LevelLoader:LoadArtLevel(TargetLevelId)
            else
                SetActorTransform()
                FadeOut()
            end
        else
            SetActorTransform()
            FadeOut()
        end
    end

    local FadeOutCallback = function()
        local TaskIndicator = UIManager(self):GetUIObj("MainTaskIndicator")
        if IsValid(TaskIndicator) then
            TaskIndicator:SetVisibility(UE4.ESlateVisibility.Visible)
        end
        SceneMgrComponent = GameInstance:GetSceneManager()
        SceneMgrComponent:ShowOrHideAllSceneGuideIcon(true)
        if TargetActorController:IsA(APlayerController) then
            TargetActor:EnableInput(TargetActorController)
        end
        if(IsValid(LevelLoader) and IsValid(NewTargetPoint)) then
            local TargetLevelId = GameMode:GetLevelLoader():GetLevelIdByLocation(NewTargetPoint:K2_GetActorLocation())
            LevelLoader:RemoveArtLevelLoadedCompleteCallback(TargetLevelId)
        end
        local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
        if IsValid(Player) then
            Player:DisablePlayerInputInDeliver(false)
        end
        Callback()
    end

    UIManager(self):ShowCommonBlackScreen({
        BlackScreenHandle = "AsyncSetActorLocAndRotNode",
        InAnimationPlayTime = self.FadeIn and 1 or 0,
        InAnimationObj = self,
        InAnimationCallback = FadeInCallback,
        OutAnimationPlayTime = self.FadeOut and 1 or 0,
        OutAnimationObj = self,
        OutAnimationCallback = FadeOutCallback,
        ScreenColor = self.IsWhite and "White" or nil
    })
end


function AsyncSetActorLocationAndRotationNode:FinishAction(OutPortIndex)
    DebugPrint("TalkNode finished", "Option_", self, OutPortIndex)
    if (OutPortIndex) then
        self:Finish('Option_' .. OutPortIndex)
    else
        self:Finish()
    end
end



return AsyncSetActorLocationAndRotationNode
