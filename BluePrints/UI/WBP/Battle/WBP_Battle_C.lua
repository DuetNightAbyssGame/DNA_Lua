--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local UIUtils = require "Utils.UIUtils"
local ChatCommon = require "BluePrints.UI.WBP.Chat.ChatCommon"
local ClientEventUtils = require "BluePrints.Common.ClientEvent.ClientEventUtils"
local BattleHUDCommonConst = require "BluePrints.UI.UI_Phone.Battle.BattleHUDCommonConst"
local TaskUtils = require "BluePrints.UI.TaskPanel.TaskUtils"
local AllPlayerBloodState = require "BluePrints.UI.BloodBar.BloodBarUtils".AllBloodState
local EMCache = require "EMCache.EMCache"

---@type WBP_Battle_P_C|WBP_Battle_M
local WBP_Battle_C = Class("BluePrints.UI.BP_UIState_C")
WBP_Battle_C._components = {
    "BluePrints.UI.WBP.Chat.View.WBP_Battle_C_ChatComp",
    "BluePrints.UI.WBP.Team.View.WBP_Battle_C_TeamComp",
    "BluePrints.UI.WBP.Common.WBP_Battle_C_WaterMarkComp",
    "BluePrints.UI.HotUpdate.WBP_Battle_C_HotUpdateComp",
}

function WBP_Battle_C:Construct()
    WBP_Battle_C.Super.Construct(self) 
    if (self.Platform == nil) then
        self.Platform = CommonUtils.GetDeviceTypeByPlatformName(self)
    end
    self.OnVisibilityChanged:Add(self, function(self, Visibility)
        if self:IsVisible() then
            --尝试恢复暂停的AfterLoading状态机
            UIManager():TryResumeAfterLoadingMgr({"TriggerGuide","MainLineQuest","DynamicQuest"})
            --恢复esc红点
            self:_RefreshEscReddot()
        end
    end)
    self.ColorAndOpacityDelegate:Bind(self,function(self)
        if self.ColorAndOpacity.SpecifiedColor.A == 1 then
            --尝试恢复暂停的AfterLoading状态机
            UIManager():TryResumeAfterLoadingMgr({"TriggerGuide","MainLineQuest","DynamicQuest"})
            --恢复esc红点
            self:_RefreshEscReddot()
        end
    end)
    self.PlayInOutSystems = {} --播放了in和out动画的系统w
end

function WBP_Battle_C:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    self:TryRecoverUI()
    self:InitUID()
    self:InitChat()
    self:InitTeam()
    self:ListenForInputAction("OpenArmory", EInputEvent.IE_Pressed, false, {self, self.OpenArmory})
    self:ListenForInputAction("OpenBag", EInputEvent.IE_Pressed, false, {self, self.OpenBag})
    self:ListenForInputAction("OpenPlay", EInputEvent.IE_Pressed, false, {self, self.OpenPlay})
    self:ListenForInputAction("OpenTask", EInputEvent.IE_Pressed, false, {self, self.OpenTaskPanel})
    self:ListenForInputAction("OpenMenu", EInputEvent.IE_Pressed, false, {self, self.OpenCommonSetup})
    --self:ListenForInputAction("GamepadOpenSystem", EInputEvent.IE_Pressed, false, {self, self.OnPressGamePadRightSpecial})
    --self:ListenForInputAction("GamepadOpenSystem", EInputEvent.IE_Released, false, {self, self.OnReleaseGmaePadRightSpecial})
    self:ListenForInputAction("OpenGuideBook", EInputEvent.IE_Pressed, false, {self, self.OpenGuideBook})
    self:ListenForInputAction("OpenEvent", EInputEvent.IE_Pressed, false, {self, self.OpenEvent})
    self:ListenForInputAction("OpenForge", EInputEvent.IE_Pressed, false, {self, self.OpenForge})
    self:ListenForInputAction("OpenGacha", EInputEvent.IE_Pressed, false, {self, self.OpenGacha})
    self:ListenForInputAction("OpenBattlePass", EInputEvent.IE_Pressed, false, {self, self.OpenBattlePass})
    self:ListenForInputAction("OpenCamera", EInputEvent.IE_Pressed, false, {self, self.OpenCamera})
    self:ListenForInputAction("GamepadOpenSystem", EInputEvent.IE_Pressed, false, {self, self.ShowSystemEntrance})
    self:ListenForInputAction("GamepadOpenSystem", EInputEvent.IE_Released, false, {self, self.CloseSystemEntrance})
    
    -- ShowTeammateBloodUI
    self:AddDispatcher(EventID.ShowTeammateBloodUI,self,self.AddTeammateUI)
    self:AddDispatcher(EventID.CloseTeammateBloodUI,self,self.RemoveTeammateUI)
    self:AddDispatcher(EventID.OnMainUIReddotUpdate, self, self.UpdateRedDotStates)
    self:AddDispatcher(EventID.OnCompleteProduce, self, self.UpdateRedDotStates)
    self:AddDispatcher(EventID.OnBlueComplete, self, self.UpdateRedDotStates)
    self:AddDispatcher(EventID.OnReceiveNewQuest, self, self.UpdateRedDotStates)
    self:AddDispatcher(EventID.OnAchvRedPoint, self, self.UpdateRedDotStates)
    self:AddDispatcher(EventID.CharDie,self,self.OnTeammateDie)
    self:AddDispatcher(EventID.CharRecover,self,self.OnTeammateRecovery)

    -- self:AddDispatcher(EventID.OnChangePropMailUniqueID, self, self.UpdateRedDotStates)
    -- self:AddDispatcher(EventID.OnGetMailRewards, self, self.UpdateRedDotStates)
    -- self:AddDispatcher(EventID.OnMarkMailStar, self, self.UpdateRedDotStates)
    -- self:AddDispatcher(EventID.OnMarkMailReaded, self, self.UpdateRedDotStates)
    -- self:AddDispatcher(EventID.OnGetAllMailReward, self, self.UpdateRedDotStates)
    self:AddDispatcher(EventID.OnGotTopicReward, self, self.UpdateRedDotStates)
    self:AddDispatcher(EventID.OnReceiveNewQuest, self, self.UpdateRedDotStates)
    self:AddDispatcher(EventID.UnLoadUI, self, self.OnSystemUIUnLoad)
    self:AddDispatcher(EventID.OnChangeKeyBoardSet,self,self.InitBtnList)
    self:AddDispatcher(EventID.OnSwitchRole, self, self.OnSwitchRole)
    self:AddDispatcher(EventID.OnHomeBaseBtnPlayAnim, self, self.OnHomeBaseBtnPlayAnim)
    self:AddDispatcher(EventID.ShowOrHideMainPlayerBloodUI, self, self.ShowOrHideMainPlayerBloodUI)
    self:AddDispatcher(EventID.OnTempleRightUI,self,self.OnTempleRightUI)
    self:AddDispatcher(EventID.OnSoloTreasureScoreAndBagUI,self,self.OnSoloTreasureScoreAndBagUI)
    self:AddDispatcher(EventID.OnPartyProgressStart,self,self.OnPartyProgressStart)
    self:AddDispatcher(EventID.OnModBookQuestFinished,self,self.OnModBookQuestFinished)
    self:AddDispatcher(EventID.OnNotifyShowLargeCountDown,self,self.OnNotifyShowLargeCountDown)
    self:AddDispatcher(EventID.OnNotifyCommonCountDown, self, self.OnNotifyCommonCountDown)

    self:AddDispatcher(EventID.OnNewDetectiveQuestion,self,self.OnNewDetectiveQuestion)
    self:AddDispatcher(EventID.OnHomeBaseeBtnShowNewClue,self,self.OnHomeBaseeBtnShowNewClue)
    self:AddDispatcher(EventID.OnEnableGuideBookKey,self,self.EnableGuideBookKey)

    self:AddDispatcher(EventID.OnTheaterJoinPerformGame, self, self.TheaterJoinPerformGame)
    self:AddDispatcher(EventID.OnTheaterJoinPerformGameFail, self, self.TheaterJoinPerformGameFail)
    self:AddDispatcher(EventID.OnTheaterPerformGameStart, self, self.TheaterPerformGameStart)
    self:AddDispatcher(EventID.OnTheaterPerformGameNotice, self, self.OnTheaterPerformGameNotice)
    self:AddDispatcher(EventID.OnSettingSystemLanguageChanged, self, self.OnGameLanguageChanged)
    self:AddDispatcher(EventID.OnMobileHudPlanChanged, self, self.UpdateMobileLayoutInfoByServerData)
    

    self:AddDispatcher(EventID.OnTeleportReady, self, self.TeleportReady)
    
    local NodeName = DataMgr.ReddotNode["Quest"].Name
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        ReddotManager.AddListenerEx(NodeName, self, function(self, Count, RdType, RdName)
            if Count > 0 then
                self.Btn_Task.Common_Item_Subsize_New_PC:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
            else
                self.Btn_Task.Common_Item_Subsize_New_PC:SetVisibility(UE4.ESlateVisibility.Collapsed)
            end
        end)
    end

    if not self:InitWithMainCharacter() then
        self:AddDispatcher(EventID.CloseLoading, self, self.InitWithMainCharacter)
    end
    self.SystemHideTags = {}
    self.IsPlayOutAnim = false --是否播放了Out动画
    if Avatar and Avatar.Suits and Avatar.Suits.PlayerCharacterSuit and Avatar.Suits.PlayerCharacterSuit.HideUIInScreen and Avatar.Suits.PlayerCharacterSuit.HideUIInScreen.GuideBook then
        self.HideGuideBookBtn = true
    else
        self.HideGuideBookBtn = false
    end
    self.HideSystemEntrance = false
    self:InitConditionMapSystem()
    self.VB_Teammate_Phantom:ClearChildren()
    self.VB_Teammate_Phantom:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if self.Battle_Char_PC_0 then
        self.Battle_Char_PC_0:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        --self.Pos_CustomSkill:ClearChildren()
        --self.Char_Skill_Old:SetVisibility(ESlateVisibility.Collapsed)
        --self.Char_Skill = self:CreateWidgetNew("BattleCustomBtnPhone")
        --self.Pos_CustomSkill:AddChild(self.Char_Skill)
        --self.Char_Skill:InitCustomButtons()
        self.Char_Skill:InitSkillAfterCharInitReady()
        
    else
        self.Char_Skill:InitSkillAfterCharInitReady()
    end
    self.PlayerBloodBar = self.HUD_MainBar
    self.Battle_Map.Battle=self
    self.Map_Img:SetVisibility(ESlateVisibility.Collapsed)
    self:PlayAnimation(self.CollapsedMap)
    self.Battle_Map:SetVisibility(0)
    if self.Btn_Close then
        self.Btn_Close.OnClicked:Clear()
        self.Btn_Close.OnClicked:Add(self,self.OnBattleMapClose)
    end

    -- 有些副本会覆写属性，初始重置
    -- self:SetOverrideInfo(self.SizeMap_Original, self.Task_Normal)
    self.SizeBox_Map:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

    -- 清空关卡UI
    self.Task:ClearChildren()
    self.Pos_Weekly:ClearChildren()
    self.Pos_Abyss_CountDown:ClearChildren()
    self.Pos_Abyss_CountDown_1:ClearChildren()
    self.Pos_ModAchive:ClearChildren()
    self.Pos_TempleProgress:ClearChildren()
    self.Pos_Weekly_Buff:ClearChildren()
    self.Pos_GuildWarScore:ClearChildren()
    self.Pos_LowHealth:ClearChildren()
    self.Pos_Rouge_CountDown:ClearChildren()
    self.Pos_TempleRight:ClearChildren()
    self.Pos_SoloTreasure_Score:ClearChildren()
    self.TeammateEidSet = {}
    -- 如果有复活UI，隐藏
    self:HidePlayerDeadUI()

    self:InitKeyTip()

    self:HideDynamicEventUI()

    self:CreatTakeAimIndicator()

    -- local ModGuide=self:GetOrAddModGuideWidget()
    -- ModGuide:InitView()

    self.Btn_Task.IsBtnTask = true
    self:InitGameJumpWord() --初始化跳字设置

    -- local OnlineActionController = require "BluePrints.UI.WBP.BattleOnlineAction.OnlineActionController"
    -- OnlineActionController:ShowBtn(1)

    self:CheckTheaterEventState()

    -- 根据服务器记录的布局信息更新UI布局（只在移动端生效）
    self:UpdateMobileLayoutInfoByServerData("Update")
end

function WBP_Battle_C:CloseOpenBagListening()
    self:StopListeningForInputAction("OpenBag", EInputEvent.IE_Pressed)
end

function WBP_Battle_C:CloseOpenGuideMainListening()
    self:StopListeningForInputAction("OpenGuideBook", EInputEvent.IE_Pressed)
end

function WBP_Battle_C:OnGameLanguageChanged()
    --系统入口按钮重置
    self:InitMainUIInBigWorld()

    self:RefreshTeamWhenEnterGame(not GWorld:IsStandAlone())

    --任务面板重置
    local Avatar = GWorld:GetAvatar()
    local QuestChainId = Avatar.TrackingQuestChainId
    if QuestChainId then
        local QuestId = nil
        if Avatar.QuestChains[QuestChainId] and Avatar.QuestChains[QuestChainId].DoingQuestId then
            QuestId = Avatar.QuestChains[QuestChainId].DoingQuestId
        end
        if QuestId then
            local TaskDetailInfo = TaskUtils:GetQuestDetail(QuestChainId,QuestId)
            local STLTaskInfo = TaskUtils:TaskDetailInfo2STLTaskInfo(TaskDetailInfo)
            local TaskBar = TaskUtils.GetTaskBarWidget()
            TaskBar:UpdateTaskInfo(STLTaskInfo,"Add")
        end
    end
end

function WBP_Battle_C:GetOrAddWidget(WidgetName, NodeToAdd)
    local Widget = NodeToAdd:GetChildAt(0)
    if Widget then return Widget end 
    local Widget = self:CreateWidgetNew(WidgetName)
    if Widget then 
        NodeToAdd:AddChild(Widget)
        NodeToAdd:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        DebugPrint("CreateWidget failed! Widget name: ", WidgetName) 
    end

    return Widget 
end

function WBP_Battle_C:GetWidget(WidgetName, NodeToAdd)
    local Widget = NodeToAdd:GetChildAt(0)
    return Widget 
end


function WBP_Battle_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
    self.CurGamepadName = UIUtils.UtilsGetCurrentGamepadName()
    self:InitKeyTip()
end

---需要依赖Character的初始化的，请写在这里面
function WBP_Battle_C:InitWithMainCharacter()
    local Player =  UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if not Player then return false end
    self.HUD_MainBar:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.HUD_MainBar:InitConfig(Player)
    -- self.HUD_MainBar:OnMainCharacterInitReady()
    self:AddTimer(0.5,function ()
        if not Player:CheckCanChangeToMaster() then
            self:ShowOrHideMainPlayerBloodUI(true,"ChangeRoleToMaster")
        end
    end,false)


    self:InitDataPhone()
    return true
end

function WBP_Battle_C:GetOrAddDynamicEventWidget()
    self.Pos_DynamicEvent:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  return self:GetOrAddWidget("DynamicEvent",self.Pos_DynamicEvent)
end

function WBP_Battle_C:GetDynamicEventWidget()
    return self:GetWidget("DynamicEvent",self.Pos_DynamicEvent)
end


-- function WBP_Battle_C:AddTrainingRightKeyTextDesc()
--     for i = 1, 3 do
--         local RightKeyTextDescData = NewObject(UE4.LoadClass(UIConst.DUNGEONCOMRIGHTKEYTEXTDESCDATA))
--         RightKeyTextDescData.Owner = self
--         RightKeyTextDescData.Index = i
--         self.List_TrainingSetting:AddItem(RightKeyTextDescData)
--     end
-- end

function WBP_Battle_C:AddTempleRightKeyTextDesc()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local TempleData = DataMgr.Temple[GameState.DungeonId]
    local FbdRule = TempleData.FbdRule
    self.ForbidInfo = self:TempleForbidSkills(FbdRule)
    if not self.ForbidInfo then
        return
    end
    for i = 1, #self.ForbidInfo do
        local RightKeyTextDescData = NewObject(UE4.LoadClass(UIConst.DUNGEONCOMRIGHTKEYTEXTDESCDATA))
        RightKeyTextDescData.Owner = self
        RightKeyTextDescData.Index = i
        self.List_TrainingSetting:AddItem(RightKeyTextDescData)
    end
end



function WBP_Battle_C:InitTrainingKeyTip()
    local Player =  UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local GameState = UE4.UGameplayStatics.GetGameState(self)

    if Player.UIModePlatform == "PC" then
        local KeyDescWidget = self:GetOrAddWidget("TrainingSetting_P", self.Task)
        KeyDescWidget:InitView() 
        self:AddTrainingRightKeyListeners()
    else
        --TODO: 看看移动端情况
        local TrainingSetting = self:GetOrAddWidget("TrainingSetting_M", self.Task)
        TrainingSetting.Parent = self
        TrainingSetting:InitView()
    end

    -- 屏蔽任务栏
    local TaskBar = TaskUtils:GetTaskBarWidget()
    if TaskBar then 
        TaskBar:SetUIVisibilityTag("Training", true)
    end

end

function WBP_Battle_C:InitTrailKeyTip()

    local Player =  UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local GameState = UE4.UGameplayStatics.GetGameState(self)

    if Player.UIModePlatform == "PC" then
        local CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
        if CurInputDeviceType == UE4.ECommonInputType.Gamepad then 
            local KeyDescWidget = self:GetOrAddWidget("BattleKeyDescList", self.Pos_KeyTip)
            local CommonKeyDatas = {
                {
                            Type = "Img",
                            DescText = GText("UI_Keyboard_Map_OpenArmory"),
                            ImgShortPath = UIUtils.GetIconListByActionName("OpenArmory"),
                },
                {
                    Type = "Img",
                    DescText = GText("UI_DUNGEON_DES_TRAINING_2"),
                    ImgShortPath = UIUtils.GetIconListByActionName("TrainingCharacterSkills"),
                },
            }
                KeyDescWidget:InitKey(CommonKeyDatas)
                self:AddTrialRightKeyListeners()
        else 
            local KeyDescWidget = self:GetOrAddWidget("BattleKeyDescList", self.Pos_KeyTip)
            if KeyDescWidget then 
                KeyDescWidget:SetVisibility(UE4.ESlateVisibility.Visible)
                ---@type CommonKeyData
                local CommonKeyDatas = {}
                self:AddTrialRightKeyListeners()
                local Data = DataMgr.KeyboardMap["TrainingCharacterSkills"]
                local KeyText = "F2"
                if Data then
                    local KeyText = Data.Key
                end
                table.insert(CommonKeyDatas, {
                    Type = "Text",
                    Text = KeyText,
                    DescText = GText("UI_DUNGEON_DES_TRAINING_2"),
                    CallbackObj = self, 
                    CallbackFunc = self.TrialCharacterSkills
                })
           
                KeyDescWidget:InitKey(CommonKeyDatas)
            end
        end
    else
        --TODO: 看看移动端情况
        -- local TrainingSetting = self:GetOrAddWidget("TrainingSetting_M", self.Pos_Training)
        -- TrainingSetting.Parent = self
    end
end

function WBP_Battle_C:UnInitTrainingKeyTip()
    local Player =  UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    self.Pos_KeyTip:ClearChildren()
    if Player.UIModePlatform == "Mobile" then
        self.Pos_Training:ClearChildren()
    end

    -- 屏蔽任务栏
    local TaskBar = TaskUtils:GetTaskBarWidget()
    if TaskBar then 
        TaskBar:SetUIVisibilityTag("Training", false)
    end
end

function WBP_Battle_C:UnInitTrialKeyTip()
    local Player =  UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    self.Pos_KeyTip:ClearChildren()
    if Player.UIModePlatform == "Mobile" then
        self.Pos_Training:ClearChildren()
    end
end

function WBP_Battle_C:UnInitTemple()
    local TaskBar = TaskUtils:GetTaskBarWidget()
    if TaskBar then 
        TaskBar:SetUIVisibilityTag("Temple", false)
        TaskBar:SetUIVisibilityTag("Party", false)
    end
end

function WBP_Battle_C:InitKeyTip()
    local Player =  UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if GameMode ~= nil and GameState ~= nil and GameState.GameModeType == "Training" then
        self:InitTrainingKeyTip()
    elseif GameMode ~= nil and GameState ~= nil and GameState.GameModeType == "Temple" then
        self:AddDispatcher(EventID.OnTempleEnter, self, self.OnTempleEnter)
        self:AddDispatcher(EventID.OnTempleDelayStart, self, self.OnTempleDelayStart)
        self:AddDispatcher(EventID.OnTempleDelayEnd, self, self.OnTempleDelayEnd)
    elseif GameState ~= nil and GameState.GameModeType == "Party" then
        self:OnPartyEnter()
    elseif GameMode ~= nil and GameState ~= nil and GameState.GameModeType == "Rouge" then
        self:AddRougeKeyListeners()
    elseif  GameState.GameModeType == "Trial" then
        self:InitTrailKeyTip()
        self.bInTrial=true
    else
        self:UnInitTrainingKeyTip()
        self:UnInitTrialKeyTip()
        self:UnInitTemple()
    end
    self:InitChatKeyTip()
    -- self.Btn_Esc.Key_GamePad:CreateCommonKey({
    --     KeyInfoList={{
    --                      Type = "Img",
    --                      ImgShortPath="Menu"
    --                  }}
    -- })
end

function WBP_Battle_C:InitCommonKey(CommonKey, Index)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if GameMode ~= nil and GameState ~= nil and GameState.GameModeType == "Training" then
        local DescTest = ""
        if Index == 1 then
            DescTest = "F4"
        elseif Index == 2 then
            DescTest = "F1"
        elseif Index == 3 then
            DescTest = "F5"
        end
        CommonKey:CreateCommonKey({
            KeyInfoList={{
                             Type = "Text",
                             Text = DescTest,
                         }},
            bLongPress = false,
            Desc = GText("UI_DUNGEON_DES_TRAINING_"..Index)
        })
        CommonKey:AddExecuteLogic(self, function() self:OnTrainingRightKeyClicked(Index) end)
    end
    if GameMode ~= nil and GameState ~= nil and GameState.GameModeType == "Temple" then
        CommonKey:CreateCommonKey({
            KeyInfoList={{
                             Type = self.ForbidInfo[Index][2],
                             Text = self.ForbidInfo[Index][3],
                             ImgShortPath = self.ForbidInfo[Index][3],
                         }},
            bLongPress = false,
            Desc = GText(self.ForbidInfo[Index][1])
        })
        CommonKey:ShowBanImg()
        CommonKey:DisableKey()
        local Player = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
        if Player.UIModePlatform == "Mobile" then
            CommonKey:MobileBanTextImg()
        end
    end
end

function WBP_Battle_C:SetOverrideInfo(MapWidth, PaddingTop)
    if self.SizeBox_Map then
        self.SizeBox_Map:SetWidthOverride(MapWidth)
    end
    if not self.Task then return end
    self.Task:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    local Slot = UE4.UWidgetLayoutLibrary.SlotAsVerticalBoxSlot(self.Task)
    if Slot then
        local Padding = Slot.Padding
        Padding.Top = PaddingTop
        Slot:SetPadding(Padding)
    end
end

function WBP_Battle_C:TempleForbidSkills(FbdRule)
    if not FbdRule then
        return
    end
    local KeyboardMap = DataMgr.KeyboardMap
    local ForbidInfo = {}
    if FbdRule.NoSkill and FbdRule.NoSkill ~= 0 then
        table.insert(ForbidInfo, {KeyboardMap["Skill1"].ActionNameText, "Text", KeyboardMap["Skill1"].Key})
        table.insert(ForbidInfo, {KeyboardMap["Skill2"].ActionNameText, "Text", KeyboardMap["Skill2"].Key})
        table.insert(ForbidInfo, {KeyboardMap["Skill3"].ActionNameText, "Text", KeyboardMap["Skill3"].Key})
    end
    if FbdRule.NoMelee and FbdRule.NoMelee ~= 0 then
        table.insert(ForbidInfo, {KeyboardMap["Attack"].ActionNameText, "Img", KeyboardMap["Attack"].Key})
    end
    if FbdRule.NoRanged and FbdRule.NoRanged ~= 0 then
        table.insert(ForbidInfo, {KeyboardMap["Fire"].ActionNameText, "Img", KeyboardMap["Fire"].Key})
    end
    if FbdRule.NoBattleWheel and FbdRule.NoBattleWheel ~= 0 then
        table.insert(ForbidInfo, {KeyboardMap["OpenBattleWheel"].ActionNameText, "Text", KeyboardMap["OpenBattleWheel"].Key})
    end
    return ForbidInfo
end

function WBP_Battle_C:AddTrainingRightKeyListeners()
    if self.IsInTraining then
        return
    end
    -- PC端
    self:ListenForInputAction("TrainingOpenSetup", EInputEvent.IE_Pressed, true, {self, self.TrainingOpenSetup})
    self:ListenForInputAction("TrainingCharacterSkills", EInputEvent.IE_Pressed, true, {self, self.TrainingCharacterSkills})
    self:ListenForInputAction("TrainingKillMonsters", EInputEvent.IE_Pressed, true, {self, self.TrainingKillMonsters})
    self:ListenForInputAction("TrainingInvincible", EInputEvent.IE_Pressed, true, {self, self.TrainingSetPlayerInvincible})
    self:ListenForInputAction("TrainingMonstersActive", EInputEvent.IE_Pressed, true, {self, self.TrainingDisableMonsterAI})

    -- 屏蔽掉冲突的输入
    self:StopListeningForInputAction("OpenEvent", EInputEvent.IE_Pressed)
    self:StopListeningForInputAction("OpenCamera", EInputEvent.IE_Pressed)
    self:StopListeningForInputAction("OpenBattlePass", EInputEvent.IE_Pressed)
    self:StopListeningForInputAction("OpenGacha", EInputEvent.IE_Pressed)
    self:StopListeningForInputAction("OpenBag", EInputEvent.IE_Pressed)
    self:StopListeningForInputAction("OpenPlay", EInputEvent.IE_Pressed)
    
    self.IsInTraining = true
end

function WBP_Battle_C:RemoveTrainingRightKeyListeners()
    self:StopListeningForInputAction("TrainingOpenSetup", EInputEvent.IE_Pressed)
    self:StopListeningForInputAction("TrainingCharacterSkills", EInputEvent.IE_Pressed)
    self:StopListeningForInputAction("TrainingKillMonsters", EInputEvent.IE_Pressed)
    self:StopListeningForInputAction("TrainingInvincible", EInputEvent.IE_Pressed)
    self:StopListeningForInputAction("TrainingMonstersActive", EInputEvent.IE_Pressed)

    -- 恢复冲突的输入
    self:ListenForInputAction("OpenCamera", EInputEvent.IE_Pressed, false, {self, self.OpenCamera})
    self:ListenForInputAction("OpenBattlePass", EInputEvent.IE_Pressed, false, {self, self.OpenBattlePass})
    self:ListenForInputAction("OpenGacha", EInputEvent.IE_Pressed, false, {self, self.OpenGacha})
    self:ListenForInputAction("OpenEvent", EInputEvent.IE_Pressed, false, {self, self.OpenEvent})
    self:ListenForInputAction("OpenBag", EInputEvent.IE_Pressed, false, {self, self.OpenBag})
    self:ListenForInputAction("OpenPlay", EInputEvent.IE_Pressed, false, {self, self.OpenPlay})
end

function WBP_Battle_C:AddRougeKeyListeners()
    self:RemoveRougeKeyListeners()
    -- 手柄端
    self:ListenForInputAction("RougeOpenBag", EInputEvent.IE_Pressed, false, {self, self.OpenRogueShop})
end

function WBP_Battle_C:RemoveRougeKeyListeners()
    self:StopListeningForInputAction("RougeOpenBag", EInputEvent.IE_Pressed)
end

function WBP_Battle_C:OnTrainingRightKeyClicked(Index)
    if Index == 1 then
        self:TrainingOpenSetup()
    elseif Index == 2 then
        self:TrainingCharacterSkills()
    elseif Index == 3 then
        self:TrainingKillMonsters()
    end
end

function WBP_Battle_C:AddTrialRightKeyListeners()

    self:RemoveTrialRightKeyListeners()
    self:ListenForInputAction("TrainingCharacterSkills", EInputEvent.IE_Pressed, false, {self, self.TrialCharacterSkills})

    --手柄端
    self:ListenForInputAction("OpenTask", EInputEvent.IE_Pressed, false, {self, self.TrialCharacterSkills})
end

function WBP_Battle_C:RemoveTrialRightKeyListeners()
    self:StopListeningForInputAction("TrainingCharacterSkills", EInputEvent.IE_Pressed)
    --手柄
    self:StopListeningForInputAction("OpenTask", EInputEvent.IE_Pressed)
end

function WBP_Battle_C:OnTrialRightKeyClicked(Index)
    if Index == 2 then
        self:TrialCharacterSkills()
    end
end

function WBP_Battle_C:TrialCharacterSkills()
     UIUtils.LoadPreviewSkillDetails(self,{OnClosedCallback = function() self:PlayInAnim() end,})
end

function WBP_Battle_C:OnTempleEnter()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if UIManager == nil then
        return
    end
    local UIManager = GameInstance:GetGameUIManager()
    local GuideCountDownFloat = UIManager:GetUIObj("GuideCountDown")
    if GuideCountDownFloat then
        GuideCountDownFloat:OnCountDownEnd()
        GuideCountDownFloat:Close()
    end
    GuideCountDownFloat = UIManager:LoadUINew("GuideCountDown")
    GuideCountDownFloat:SetVisibility(ESlateVisibility.Collapsed)
    self:AddTimer(1, self.ShowCountDown, false, 0, "ShowCountDown", nil, GuideCountDownFloat, 4)
    self.Pos_TaskBar:SetVisibility(ESlateVisibility.Collapsed)
    self.Pos_DynamicEvent:SetVisibility(ESlateVisibility.Collapsed)
end

function WBP_Battle_C:ShowCommonCountDown(Widget, Count, bShowZeroText, CountDownSound, LastCountDownSound)
    Widget:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    Widget:InitCommonCountDown(Count,bShowZeroText, CountDownSound, LastCountDownSound)
end

function WBP_Battle_C:ShowCountDown(Widget, Count,bShowZeroText)
    Widget:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    Widget:InitTempleCountDown(Count,bShowZeroText)
end

function WBP_Battle_C:OnTempleDelayStart(Duration, Title, RedCountdownTime)
    DebugPrint("zwk OnTempleDelayStart", Duration, Title, RedCountdownTime)

    self.Pos_TempleTime:ClearChildren()
    self.CurDelayUI = self:CreateWidgetNew("DungeonTempleTime")
    self.Pos_TempleTime:AddChild(self.CurDelayUI)
    self.Pos_TempleTime:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.CurDelayUI:InitTempleDelayTimeUI(Title, Duration, RedCountdownTime)
end

function WBP_Battle_C:OnTempleDelayEnd()
    DebugPrint("zwk OnTempleDelayEnd")
    if self.CurDelayUI then
        self.CurDelayUI:CloseDungeonUI()
    end
end

function WBP_Battle_C:GetTrainingComp()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then 
        return GameMode:GetDungeonComponent()
    end

    return nil
end

function WBP_Battle_C:TrainingOpenSetup()
    self:GetTrainingComp():TrainingOpenSetup()
end

function WBP_Battle_C:TrainingCharacterSkills()
    self:GetTrainingComp():TrainingCharacterSkills()
end

function WBP_Battle_C:TrainingKillMonsters()
    AudioManager(self):PlayUISound(self, "event:/ui/common/btn_killer_all", nil, nil)
    self:GetTrainingComp():TrainingKillMonsters()
end

function WBP_Battle_C:TrainingSetPlayerInvincible()
    self:GetTrainingComp():TrainingSetPlayerInvincible()
end

function WBP_Battle_C:TrainingDisableMonsterAI()
    self:GetTrainingComp():TrainingDisableMonsterAI()
end

function WBP_Battle_C:InitUID()
    self.Text_BottomTips:SetText(GText('UI_Loading_Testing'))
    local Avatar = GWorld:GetAvatar()
    if Avatar and Avatar.Uid ~= 0 then
        self.UID:SetUid()
        self.UID:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.UID:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function WBP_Battle_C:InitEsc()
    self.Btn_Esc.bForceInvisible = nil
    self.Btn_Esc.Btn_top.OnClicked:Add(self,self.OpenCommonSetup)
    --TODO:ESC参数整理
    self.Btn_Esc:LoadImage(11)
    self:_RefreshEscReddot()
end

function WBP_Battle_C:Destruct()
    for Eid, TeammateUI in pairs(self.TeammateEidSet or {}) do
        self:RemoveTeammateUI(Eid, TeammateUI)
    end
    self.TeammateEidSet = {}
    self:EndAim()
    self:EndChat()
    self:EndTeam()
    self:RemoveTrainingRightKeyListeners()
    self:RemoveTrialRightKeyListeners()
    self:RemoveRougeKeyListeners()
    local NodeName = DataMgr.ReddotNode["Quest"].NodeName
    ReddotManager.RemoveListener(NodeName, self)
    WBP_Battle_C.Super.Destruct(self)
end

function WBP_Battle_C:InitDataPhone()
    if self.Battery then
        self.Battery.HB_Battery:SetVisibility(not UUCloudGameInstanceSubsystem.IsCloudGame() and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
    end
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    if Player.UIModePlatform ~= "Mobile" then
        return
    end
    self.WifiImage = {self.Battery.Wifi_1, self.Battery.Wifi_2, self.Battery.Wifi_3}
    self.DataImage = {self.Battery.Image_Net_1, self.Battery.Image_Net_2, self.Battery.Image_Net_3, self.Battery.Image_Net_4}
    if (not GWorld.IsDev) then
        -- Pub包隐藏GM按钮
        self.Btn_GM:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        self.Btn_GM:SetVisibility(UIConst.VisibilityOp.Visible)
    end
    self:SetBattery(UE4.UUIFunctionLibrary.GetBatteryLevel())
    self:UpdateSignalStrength()
    self:AddTimer(5, self.UpdateDataPhone, true)
end

function WBP_Battle_C:UpdateDataPhone()
    self:SetBattery(UE4.UUIFunctionLibrary.GetBatteryLevel(), self.BatteryLevel)
    self:UpdateSignalStrength(self.SignalStrength)
end

function WBP_Battle_C:SetBattery(BatteryLevel, LastBatteryLevel)
    if BatteryLevel and not LastBatteryLevel then
        if BatteryLevel <= 20 then
            self.Battery:PlayAnimation(self.Battery.Low_Battery)
        else
            self.Battery:PlayAnimationReverse(self.Battery.Low_Battery)
        end
    elseif BatteryLevel <= 20 and LastBatteryLevel > 20 then
        self.Battery:PlayAnimation(self.Battery.Low_Battery)
    elseif BatteryLevel > 20 and LastBatteryLevel <= 20 then
        self.Battery:PlayAnimationReverse(self.Battery.Low_Battery)
    end
    if not self.BatteryLevel or BatteryLevel ~= self.BatteryLevel then
        self.Battery.Num_Battery:SetText(BatteryLevel.."%")
        self.Battery.ProgressBar_Battery:SetPercent(BatteryLevel / 100)
        self.BatteryLevel = BatteryLevel
    end
end

function WBP_Battle_C:UpdateSignalStrength(LastSignalStrength)
    local IsConnectWifi = UE4.UMobilePatchingLibrary.HasActiveWiFiConnection()
    self.Battery.Switcher_Net:SetActiveWidgetIndex(IsConnectWifi and 1 or 0)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    if not Player then
        DebugPrint(ErrorTag, "拿不到Player")
        return
    end
    if not Player:GetController() then
        DebugPrint(ErrorTag, "拿不到PlayerController")
        return
    end
    local PlayerState = Player:GetController().PlayerState
    if not PlayerState then 
        DebugPrint(ErrorTag, "xuxiangnan::PlayerState获取失败，拿不到正确ping值")
        return 
    end
    local Ping = PlayerState:GetPlayerPing()
    self.Battery.Num_Net:SetText(Ping)
    local Strength = 5
    for i = 1, #Const.SignalStrength do
        if Const.SignalStrength[i] >= Ping then
            Strength = Strength - i
            break
        end
    end
    for i = 2, #self.WifiImage do
        self.WifiImage[i]:SetVisibility(IsConnectWifi and Strength >= i and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
    end
    for i = 2, #self.DataImage do
        self.DataImage[i]:SetVisibility(not IsConnectWifi and Strength >= i and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
    end
    if not LastSignalStrength then
        if Strength <= 2 then
            self.Battery:PlayAnimation(self.Battery.Low_Net)
        else
            self.Battery:PlayAnimationReverse(self.Battery.Low_Net)
        end
    elseif Strength <= 2 and self.SignalStrength > 2 then
        self.Battery:PlayAnimation(self.Battery.Low_Net)
    elseif Strength > 2 and self.SignalStrength <= 2 then
        self.Battery:PlayAnimationReverse(self.Battery.Low_Net)
    end
    self.SignalStrength = Strength
end

function WBP_Battle_C:ExitHardBossBattle()
    local CommonDialog = UIManager(self):GetUIObj("CommonDialog")
    if CommonDialog then
        CommonDialog:Close()
    end
    self:SetInputUIOnly(false)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if IsStandAlone(Player) then
        local GameMode=UE4.UGameplayStatics.GetGameMode(Player)
        GameMode:SetGamePaused(UIConst.CommonSetUP,false)
    end
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:ExitBattle(false, true)
    end
end

function WBP_Battle_C:ExitHardBattle()
    local CommonDialog = UIManager(self):GetUIObj("CommonDialog")
    if CommonDialog then
        CommonDialog:Close()
    end
    self:SetInputUIOnly(false)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if IsStandAlone(Player) then
        local GameMode=UE4.UGameplayStatics.GetGameMode(Player)
        GameMode:SetGamePaused(UIConst.CommonSetUP,false)
    end
    DebugPrint("gyy@SpecialQuestFail,ExitSpecialQuest")
    EventManager:FireEvent(EventID.OnSpecialQuestFail, "Exit")
end

function WBP_Battle_C:ContinueBattle()
    self:SetInputUIOnly(false)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if IsStandAlone(Player) then
        local GameMode=UE4.UGameplayStatics.GetGameMode(Player)
        GameMode:SetGamePaused(UIConst.CommonSetUP,false)
    end
end

--
function WBP_Battle_C:OpenCommonSetup()
    --组队相关弹窗打开时且手柄模式需要屏蔽esc打开..
    if TeamController:IsTeamPopupBarOpenInGamepad() then
        return
    end
    if  UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad and self:GetOnlineActionBtn() then
        self:OnPressGamePadRightSpecial()
        return
    end
    --放到OpenSystemByAction统一处理
    self:OpenSystemByAction("OpenCommonSetup")
end
function WBP_Battle_C:OnPressGamePadRightSpecial()
    DebugPrint ("正在打开多人动作界面")
    local OnlineActionBtn=self:GetOnlineActionBtn()
    if OnlineActionBtn then
        UIUtils:LongPressKey(OnlineActionBtn.Key_OnlineAction_GamePad, function()
            local OnlineActionController = require "BluePrints.UI.WBP.BattleOnlineAction.OnlineActionController"
            OnlineActionController:OpenView()
        end, 1)
        -- DebugPrint("Yk@OpenCommonSetup,OnlineActionBtn存在")
        -- OnlineActionBtn.Key_OnlineAction_GamePad:AddExecuteLogic(self, function()
        --     ScreenPrint("asdadadsas")
        --     local OnlineActionController = require "BluePrints.UI.WBP.BattleOnlineAction.OnlineActionController"
        --     --OnlineActionBtn.Key_OnlineAction_GamePad:SetLongPressProgress(0.5)
        --     self:AddTimer(1, function()
        --     --OnlineActionController:OpenView()
        --     ScreenPrint("asdadadsas88888")
        --     --OnlineActionBtn.Key_OnlineAction_GamePad:SetLongPressProgress(0)
        --     end)
        -- end)
        -- OnlineActionBtn.Key_OnlineAction_GamePad:OnButtonPressed(nil, true, 0,0.5)
        return
    end
    --放到OpenSystemByAction统一处理
    --self:OpenSystemByAction("OpenCommonSetup")
end

function WBP_Battle_C:OnReleaseGmaePadRightSpecial()
    local OnlineActionController = require "BluePrints.UI.WBP.BattleOnlineAction.OnlineActionController"
    if OnlineActionController.MainPage and OnlineActionController.MainPage:IsVisible() then
    else
        local OnlineActionBtn=self:GetOnlineActionBtn()
        if OnlineActionBtn then
            UIUtils:StopLongPressKey(OnlineActionBtn.Key_OnlineAction_GamePad)
            -- OnlineActionBtn.Key_OnlineAction_GamePad:RemoveExecuteLogic()
            -- OnlineActionBtn.Key_OnlineAction_GamePad:OnButtonReleased()
           --OnlineActionBtn.Key_OnlineAction_GamePad:PlayAnimation(OnlineActionBtn.Key_OnlineAction_GamePad.Normal)

        end
        self:OpenSystemByAction("OpenCommonSetup")
    end
end

function WBP_Battle_C:GetOnlineActionBtn()
    local OnlineActionController = require "BluePrints.UI.WBP.BattleOnlineAction.OnlineActionController"
    local OnlineActionBtn = OnlineActionController.OnlineActionBtn or self.OnlineActionBtn
    if IsValid(OnlineActionBtn) and OnlineActionBtn:IsVisible() then
        return OnlineActionBtn
    end

    return false
end
function WBP_Battle_C:OpenSystemEntrance()
    self:OpenSystemByAction("OpenSystemEntrance")
end

function WBP_Battle_C:CloseSystemEntrance()
    self:OpenSystemByAction("CloseSystemEntrance")
end

function WBP_Battle_C:ShowSystemEntrance()
    self.IsShowSystemEntrance = true

    for i = 0, self.ListView:GetNumItems() - 1 do
        local Item = self.ListView:GetItemAt(i)
        if Item then
            Item.SelfWidget:ShowSystemEntranceOnGamePadInput(self.IsShowSystemEntrance)
        end
    end
    self.Btn_Task:ShowSystemEntranceOnGamePadInput(self.IsShowSystemEntrance)
end

function WBP_Battle_C:CloseSystemEntrance()
    self.IsShowSystemEntrance = false

    for i = 0, self.ListView:GetNumItems() - 1 do
        local Item = self.ListView:GetItemAt(i)
        if Item then
            Item.SelfWidget:ShowSystemEntranceOnGamePadInput(self.IsShowSystemEntrance)
        end
    end
    self.Btn_Task:ShowSystemEntranceOnGamePadInput(self.IsShowSystemEntrance)
end

function WBP_Battle_C:OpenArmory()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if GameState and GameState.GameModeType == "Trial" then
        local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        if GameMode then
            GameMode:TriggerDungeonComponentFun("ShowArmory")
        end
    else
        self:OpenSystemByAction("OpenArmory")
    end
    
end

function WBP_Battle_C:OpenBag()
    self:OpenSystemByAction("OpenBag")
end

function WBP_Battle_C:OpenPlay()
    self:OpenSystemByAction("OpenPlay")
end

function WBP_Battle_C:OpenTaskPanel()
    self:OpenSystemByAction("OpenTask")
end

function WBP_Battle_C:OpenGuideBook()
    self:OpenSystemByAction("OpenGuideBook")
end

function WBP_Battle_C:OpenBattlePass()
    self:OpenSystemByAction("OpenBattlePass")
end

function WBP_Battle_C:OpenCamera()
    self:OpenSystemByAction("OpenCamera")
end

function WBP_Battle_C:OpenEvent()
    self:OpenSystemByAction("OpenEvent")
end

function WBP_Battle_C:OpenForge()
    self:OpenSystemByAction("OpenForge")
end

function WBP_Battle_C:OpenGacha()
    self:OpenSystemByAction("OpenGacha")
end

function WBP_Battle_C:OpenRogueShop()
    local UIManager = self:GetGameInstance():GetGameUIManager()
    UIManager:LoadUINew('RougeBag')
end

---@param ActionName String:操作映射名称
-- 通过快捷键操作映射打开系统
function WBP_Battle_C:OpenSystemByAction(ActionName, bEscMenu, ...)
    --防止键盘监听到同一帧打开多个系统
    if not UIManager(self):TryOpenSystem("BattleHUD") then return end
    local FrameCount = UKismetSystemLibrary.GetFrameCount()
    if self.FrameCount == FrameCount then
        return
    end
    self.FrameCount = FrameCount
    if ActionName == "OpenCommonSetup" then
        UIUtils.OpenEsc()
        return
    elseif ActionName == "OpenSystemEntrance" then
        self:ShowSystemEntrance()
        return
    elseif ActionName == "CloseSystemEntrance" then
        self:CloseSystemEntrance()
        return
    end
    local Avatar = GWorld:GetAvatar()
    if Avatar and Avatar:IsInHardBoss() and ActionName~="OpenChat" then  --boss站打不开聊天
        return
    end

    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if GameState and GameState.GameModeType == "SoloTreasure" and ActionName=="OpenChat" then
        return
    end

    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if Player:CheckForbidTags(ActionName) then
        return
    end
    if( self:IsPlayingAnimation(self.Out) or self:IsPlayingAnimation(self.In)) and (not Player.IsImmersionModel) then
        return
    end
    local SystemId
    for EnterId,SystemData in pairs(DataMgr.MainUI) do
        local SystemAction = SystemData.ActionName
        if SystemAction and SystemAction == ActionName then
            SystemId = EnterId
        end
    end
    if SystemId ~= nil then
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_system_entrance", nil, nil)
        UIUtils.OpenSystem(SystemId,bEscMenu,...)
    end
end


-- 魅影血条, 队友血条另外显示
function WBP_Battle_C:AddTeammateUI(Eid, bIsPlayer, Entity)
    if GameState(self).GameModeType == "Party" then
        DebugPrint("TeamSyncDebug  Party模式不创建队友血条UI",Eid)
        return
    end

    DebugPrint(DebugTag, LXYTag, "TeamSyncDebug 有角色产生，魅影或玩家",bIsPlayer, Eid)
    if GameState(self):GetPhantomState(Eid) then
        DebugPrint("TeamSyncDebug  PhantomArray存在该魅影，看一下OwnerEid,", GameState(self):GetPhantomState(Eid).OwnerEid )
    end
    if not Entity then Entity = Battle(self):GetEntity(Eid) end
    if self.TeammateEidSet[Eid] then
        if Entity and Entity.TeammateUI then
            Entity.TeammateUI:ReInit()
            self.TeammateEidSet[Eid] = Entity.TeammateUI
        end
        return
    end
    ---组队流程如果能成功创建血条，就不走单机流程的血条创建
    if self:AddBattleTeamBloodBar(Eid, bIsPlayer,Entity) then
        if bIsPlayer then
            return
        end
        if not bIsPlayer then
            ---魅影Entity看归属信息，不是归属玩家自身的就不走单机流程
            local MainPlayer = GWorld:GetMainPlayer()
            local PhantomState = Entity and Entity.PhantomState or GameState(self):GetPhantomState(Eid)
            if not PhantomState then
                Utils.Traceback(WarningTag, LXYTag.."TeamSyncDebug  AddTeammateUI  拿不到PhantomState直接返回")
                return
            end
            local OwnerEid = PhantomState.OwnerEid
            if not OwnerEid then
                Utils.Traceback(WarningTag, LXYTag.."TeamSyncDebug非常怀疑魅影的初始化流程有时序问题..")
                return
            end
            if OwnerEid ~= MainPlayer.Eid then
                return
            end
        end
    end
    if not IsValid(Entity) or Entity.IsSimplePlayer or Entity.IsHostage or Entity.FromOtherWorld then
        return
    end
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    if Entity.Eid == Player.Eid then
        DebugPrint(DebugTag, LXYTag, "TeamSyncDebug 自身不应该产生血条",Player.Eid)
        return
    end
    
    local TeammateUI = self:CreateWidgetNew("TeammateBloodBar")
    TeammateUI:InitConfig(Entity)
    Entity.TeammateUI = TeammateUI
    Entity:SetTeammateUI(TeammateUI)
    self.VB_Teammate_Phantom:AddChildToVerticalBox(TeammateUI)
    local VBSlot = UE4.UWidgetLayoutLibrary.SlotAsVerticalBoxSlot(TeammateUI)
    if VBSlot then
        local Margin = FMargin(0,0,0,0)
        local Platform = CommonUtils:GetDeviceTypeByPlatformName(self)
        if (Platform == "PC") then
            Margin.Top = 10 
        end
        VBSlot:SetPadding(Margin)
    end
    if not next(self.TeammateEidSet) then
        self:Show1PTagBar(true)
        self.VB_Teammate_Phantom:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    self.TeammateEidSet[Eid] = TeammateUI
end

function WBP_Battle_C:RemoveTeammateUI(Eid, TeammateBloodBarUI)
    if self:RemoveBattleTeamBloodBar(Eid) then
        return
    end
    if not TeammateBloodBarUI then
        return
    end

    TeammateBloodBarUI:BindToAnimationFinished(TeammateBloodBarUI.Out,{TeammateBloodBarUI,function ()
        TeammateBloodBarUI:UnbindAllFromAnimationFinished(TeammateBloodBarUI.Out)
        self.VB_Teammate_Phantom:RemoveChild(TeammateBloodBarUI)
    end})
    TeammateBloodBarUI:PlayAnimation(TeammateBloodBarUI.Out)

    self.TeammateEidSet[TeammateBloodBarUI.Eid] = nil
    if not next(self.TeammateEidSet) then
        self:Show1PTagBar(false)
        self.VB_Teammate_Phantom:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

-- 更新红点状态
function WBP_Battle_C:UpdateRedDotStates()
    DebugPrint("Tianyi@ UpdateRedDotStates")
    local EntryList = self.ListView:GetDisplayedEntryWidgets():ToTable()
    for _, v in ipairs(EntryList) do
        v:UpdateRedDot()
    end
    --self.Btn_Task:UpdateTaskBtnRedDot()
    self.Btn_Task:RefreshNewClueUI()
end

-----------------主界面右上角系统入口相关---------@jiangzening----------------
function WBP_Battle_C:InitConditionMapSystem()
    self.BattleEntry = self:CreateWidgetNew("BattleEntry")
    self.Pos_Entry:ClearChildren()
    self.Pos_Entry:AddChild(self.BattleEntry)
    self.ListView = self.BattleEntry.List_Entry
    self.ListView:DisableScroll(true)
    self.ConditionMapping = {}  --系统入口相关条件ID的映射
    self.SignBoardNpcLoadComplete = false --据点看板娘首次初始化完成
    for SystemId,Data in pairs(DataMgr.MainUI) do
        local ConditionId = Data.ShowCondition
        if ConditionId then
            self.ConditionMapping[ConditionId] = true
        end
    end
    self:AddDispatcher(EventID.ConditionComplete, self, self.OnConditionComplete)
    self:AddDispatcher(EventID.OnAvatarStatusUpdate, self, self.OnAvatarStatusUpdate)
end

function WBP_Battle_C:OnConditionComplete(ConditionId)
    if #self.ConditionMapping == 0 then
        return
    end
    if self.ConditionMapping[ConditionId] then
        self:InitMainUIInBigWorld()
    end
end

function WBP_Battle_C:OnAvatarStatusUpdate(OldStatus, NewStatus)
    self:InitMainUIInBigWorld()
end

function WBP_Battle_C:InitMainUIInBigWorld()
    self.IsInHomebase = false
    local Avatar = GWorld:GetAvatar()
    if Avatar and Avatar:CheckSubRegionType(Avatar:GetCurrentRegionId(),CommonConst.SubRegionType.Home) and Avatar:IsInBigWorld() then 
        self.IsInHomebase = true
        self:InitHomeBaseMain()
    else
        self:InitBtnList()
    end
end

function WBP_Battle_C:InitHomeBaseMain()
    self:InitBtnList()
    if not self.SignBoardNpcLoadComplete then
        self:TriggerSignBoardNpc()
        self:AddDispatcher(EventID.OnCharAppearanceChanged, self, self.OnCharAccessoryChange)
        self:AddDispatcher(EventID.OnCharAccessorySetted, self, self.OnCharAccessoryChange)
        self:AddDispatcher(EventID.OnCharAccessoryRemoved, self, self.OnCharAccessoryChange)
        self:AddDispatcher(EventID.OnCharShowPartMesh, self, self.OnCharAccessoryChange)
        self:AddDispatcher(EventID.OnCharCornerVisibilityChanged, self, self.OnCharAccessoryChange)
        self:AddDispatcher(EventID.OnCharSkinChanged, self, self.OnCharSkinChange)
        self:AddDispatcher(EventID.OnCharSkinColorPlanChanged, self, self.OnCharSkinChange)
        self:AddDispatcher(EventID.OnCharColorsChanged, self, self.OnCharColorsChanged)
        self:AddDispatcher(EventID.OnCharHairChanged, self, self.OnCharAccessoryChange)
        self:AddDispatcher(EventID.OnCharHairColorPlanChanged, self, self.OnCharHairChanged)
        self:AddDispatcher(EventID.OnCharHairColorsChanged, self, self.RefreshAllSignBoardNpcSkin)
        self:AddDispatcher(EventID.OnWindowResized, self, function(self)
            self.bRebuildChatSimple = true
        end)
    end
end

function WBP_Battle_C:InitBtnList()
    local SystemData = DataMgr.MainUI
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self.SystemUnlockList = {} --系统是否已解锁结果列表
    self.SystemSortList = {}
    self.SystemUnlockNums = 0 --系统显示且已解锁的数量
    for index,Data in pairs(SystemData) do
        table.insert(self.SystemSortList,{Id = index,Sequence = Data.Sequence or 0})
        if Data.ShowCondition ~= nil then
            --系统显示条件判断
            local ConditionSucc = ConditionUtils.CheckCondition(Avatar,Data.ShowCondition)
            if ConditionSucc then
                self.SystemUnlockList[index] = false
                local RuleName = Data.UIUnlockRuleName
                if RuleName == nil then
                    self.SystemUnlockList[index] = true
                else
                    self.SystemUnlockList[index] = self:CheckUIUnlock(RuleName)
                end
            end
        end
        ---解决当系统按钮不显示时，红点也不显示的问题 lxy
        local Node = ReddotManager.GetTreeNode(Data.ReddotNode)
        if Node and Node.OnCheckEscShowCondition then
            Node:OnCheckEscShowCondition(Data.EnterId)
        end
    end
    self:InitSystemEntrance()
    if self.Btn_GuideBook then
        self:InitGuideBookBtn()
    end
    if self.Btn_Task then
        self:InitTaskPanelBtn()
    end

    --!!!!!Esc按钮应该放最后初始化，否则红点会爆炸!!!!!!!
    self:InitEsc()
end

function WBP_Battle_C:InitGuideBookBtn()
    local SystemData = DataMgr.MainUI[13]
    if self:CheckUIUnlock(SystemData.UIUnlockRuleName) then
        self.Btn_GuideBook:LoadImage(13)
        self.Btn_GuideBook.Btn_top.OnClicked:Add(self,self.OpenGuideBook)
        if not self.HideGuideBookBtn then
            self.Btn_GuideBook:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
    else
        self.Btn_GuideBook:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function WBP_Battle_C:InitTaskPanelBtn()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    --local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local GameState = UE4.URuntimeCommonFunctionLibrary.GetCurrentGameState(self)
    local IsHide = false
    local IsInRouge = Avatar:IsInRougeLike()
    local IsInDG = false
    if GameState then
        IsInDG = GameState:IsInDungeon()
    end
    local IsInHB = Avatar:IsInHardBoss()
    local IsInSQ = Avatar:IsInSpecialQuest()
    IsHide = IsInRouge or IsInDG or IsInHB or IsInSQ

    local SystemData = DataMgr.MainUI[9]

    if not IsHide then
        if SystemData.ShowCondition then
            local ConditionSucc = ConditionUtils.CheckCondition(Avatar,SystemData.ShowCondition)
            if not ConditionSucc then
                self.Btn_Task:SetVisibility(ESlateVisibility.Collapsed)
                return
            end
        end
        if self:CheckUIUnlock(SystemData.UIUnlockRuleName) then
            self.Btn_Task:LoadImage(9)
            self.Btn_Task.Btn_top.OnClicked:Add(self,self.OpenTaskPanel)
            self.Btn_Task:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        else
            self.Btn_Task:SetVisibility(ESlateVisibility.Collapsed)
        end
    else
        self.Btn_Task:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function WBP_Battle_C:CheckUIUnlock(RuleName)
    local UIUnlockRule = DataMgr.UIUnlockRule
    local UIUnlockRuleId = UIUnlockRule[RuleName].UIUnlockRuleId
    local Avatar = GWorld:GetAvatar()
    if Avatar and  UIUnlockRuleId then
        return Avatar:CheckUIUnlocked(UIUnlockRuleId)
    else
        return true
    end
end

function WBP_Battle_C:InitSystemEntrance()
    local ClassPath = UE4.LoadClass('/Game/UI/WBP/Battle/Widget/WBP_Main_Btnlist_Content.WBP_Main_Btnlist_Content_C')
    self.ListView:ClearListItems()
    table.sort(self.SystemSortList,function (Data1, Data2)
        return Data1.Sequence > Data2.Sequence
    end)
    local Avatar = GWorld:GetAvatar()
    for Key,Value in pairs(self.SystemSortList) do
        local MainUIConfig=DataMgr.MainUI[Value.Id]
        if  MainUIConfig and UIUtils.CheckCdnHide(MainUIConfig.SystemUIName) then
            goto continue
        end
        if self.SystemUnlockList[Value.Id] then
            self.SystemUnlockNums = self.SystemUnlockNums + 1
            local Content = NewObject(ClassPath)
            Content.BtnId = Value.Id
            local GameState = UE4.UGameplayStatics.GetGameState(self)
            if  self.bInTrial then
                Content.bForbidReddot=true
                DebugPrint("yeke::trial模式不显示红点")
            end
            self.ListView:AddItem(Content)

        end
        ::continue::
    end
    if not self.HideSystemEntrance then
        if self.SystemUnlockNums == 0 then
            self.Pos_Entry:SetVisibility(UE4.ESlateVisibility.Collapsed)
        else
            self.Pos_Entry:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
    end
end

function WBP_Battle_C:TriggerSignBoardNpc()
    local Avatar = GWorld:GetAvatar()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local CreatorMap = GameState.StaticCreatorMap:ToTable()
    local DisplayName = {"ShowNpc"..string.sub(DataMgr.TextMap.UI_SHOWNPC_NAME_SCENE1.TextMapId,-7),
                        "ShowNpc"..string.sub(DataMgr.TextMap.UI_SHOWNPC_NAME_SCENE2.TextMapId,-7),
                        "ShowNpc"..string.sub(DataMgr.TextMap.UI_SHOWNPC_NAME_SCENE3.TextMapId,-7),}
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    self.NpcStaticCreator = {}
    for i = 1 ,#DisplayName do
        for _, StaticCreator in pairs(CreatorMap) do
            if StaticCreator.UnitType == "Npc" and string.lower(StaticCreator.DisplayName)== string.lower(DisplayName[i]) then
                self.NpcStaticCreator[i] = StaticCreator
                if Avatar.SignBoardNpc[i] ~= CommonConst.SignBoardUnset then
                    StaticCreator.UnitId = Avatar.SignBoardNpc[i]
                    local StaticIds = TArray(0)
                    StaticIds:Add(StaticCreator.StaticCreatorId)
                    GameMode:TriggerActiveStaticCreator(StaticIds)
                end
                break
            end
        end
    end
    self:SetSignBoardNpcIdle()
end
local NpcLogType = UE.EStoryLogType.NPC
function WBP_Battle_C:SetSignBoardNpcIdle()
    local Avatar = GWorld:GetAvatar()
    if(Avatar == nil)then
        return
    end
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    for key ,value in pairs(Avatar.SignBoardNpc) do
        if value ~= CommonConst.SignBoardUnset then
            local NpcInfo = DataMgr.Npc[value]
            if NpcInfo and NpcInfo.ShowAnimationId then
                local ShowAnimation = NpcInfo.ShowAnimationId
                local ShowAnimationId = ShowAnimation[key]
                GameState:GetNpcInfoAsync(value, function(Npc) 
                    if not IsValid(Npc) then
                        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, 
                            NpcLogType, "看板娘Npc加载失败", string.format("NpcId: %d 加载失败，确认下是该看板娘被删除或者其他原因", value or -1))
                        return
                    end
                    Npc:InitNpcAccessories(NpcInfo.CharId)
                    if ShowAnimationId == 'Sit' and key ~= CommonConst.SignBoardThird then
                        Npc:SetSitPoseInteractive()
                    else
                        Npc:SetIdlePose(false)
                    end
                    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
                    if IsValid(GameInstance) then
                        local Tag = GameInstance:GetGlobalGameUITag()
                        if (not Tag) or Tag == "" then
                            Tag = "None"
                        end
                        GameInstance:TriggerAllNpcPauseAndHide(Tag)
                    end
                end)
            end
        end
    end
    local SignBoardController = require "BluePrints.UI.WBP.SignBoardBubble.SignBoardBubbleTalkController"
    self.SignBoardNpcLoadComplete = true
    if SignBoardController then
        SignBoardController:StartHomeBase()
    end
end

function WBP_Battle_C:OnCharAccessoryChange(Ret,CharUuid)
    if Ret == ErrorCode.RET_SUCCESS then
        local Avatar = GWorld:GetAvatar()
        if not Avatar then return end
        local Char = Avatar.Chars[CharUuid]
        if not Char then return end
        local CharId = Char.CharId
        for key ,NpcId in pairs(Avatar.SignBoardNpc) do
            if NpcId ~= CommonConst.SignBoardUnset then
                local NpcInfo = DataMgr.Npc[NpcId]
                if NpcInfo and NpcInfo.CharId and NpcInfo.CharId == CharId then
                    local GameInstance = GWorld.GameInstance
                    local GameState = UE4.UGameplayStatics.GetGameState(GameInstance)
                    local ShowAnimation = NpcInfo.ShowAnimationId
                    local ShowAnimationId = ShowAnimation and ShowAnimation[key]
                    GameState:GetNpcInfoAsync(NpcId, function(Npc) 
                        if not IsValid(Npc) then
                            return
                        end
                        Npc:SetIdlePose(false)
                        Npc:RefreshNpcAccessories(Char)
                        if ShowAnimationId == 'Sit' and key ~= CommonConst.SignBoardThird then
                            Npc:SetSitPoseInteractive()
                        end
                    end)
                    break
                end
            end
        end
    end
end

function WBP_Battle_C:OnCharColorsChanged(Ret,SkinId)
    if Ret == ErrorCode.RET_SUCCESS then
        local SkinInfo = DataMgr.Skin[SkinId]
        if not SkinInfo then return end
        local CharId = SkinInfo.CharId
        self:UpdateSignBoardNpcSkin(CharId)
    end
end

function WBP_Battle_C:RefreshAllSignBoardNpcSkin()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    for key ,NpcId in pairs(Avatar.SignBoardNpc) do
        if NpcId ~= CommonConst.SignBoardUnset then
            local NpcInfo = DataMgr.Npc[NpcId]
            if NpcInfo and NpcInfo.CharId then
                self:UpdateSignBoardNpcSkin(NpcInfo.CharId)
            end
        end
    end
end

function WBP_Battle_C:OnCharHairChanged(Ret, HairId)
    if not Ret == ErrorCode.RET_SUCCESS then
        return
    end
    local HairInfo = DataMgr.Hair[HairId]
    if not HairInfo then return end
    local CharId = HairInfo.CharId
    self:UpdateSignBoardNpcSkin(CharId)
end

function WBP_Battle_C:OnCharSkinChange(Ret,CharUuid)
    if Ret == ErrorCode.RET_SUCCESS then
        local Avatar = GWorld:GetAvatar()
        if not Avatar then return end
        local Char = Avatar.Chars[CharUuid]
        if not Char then return end
        local CharId = Char.CharId
        self:UpdateSignBoardNpcSkin(CharId)
    end
end

function WBP_Battle_C:UpdateSignBoardNpcSkin(CharId)
    local Avatar = GWorld:GetAvatar()
    local CharAvatar
    for key,Char in pairs(Avatar.Chars) do
        if Char.CharId == CharId then
            CharAvatar = Char
            break
        end
    end
    for key ,NpcId in pairs(Avatar.SignBoardNpc) do
        if NpcId ~= CommonConst.SignBoardUnset then
            local NpcInfo = DataMgr.Npc[NpcId]
            if NpcInfo and NpcInfo.CharId and NpcInfo.CharId == CharId then
                local GameInstance = GWorld.GameInstance
                local GameState = UE4.UGameplayStatics.GetGameState(GameInstance)
                if NpcInfo.ShowAnimationId then
                    local ShowAnimation = NpcInfo.ShowAnimationId
                    local ShowAnimationId = ShowAnimation[key]
                    GameState:GetNpcInfoAsync(NpcId, function(Npc)
                        if not IsValid(Npc) then
                            return
                        end
                        Npc:SetIdlePose(false)
                        Npc:RefreshNpcAccessories(CharAvatar)
                        if ShowAnimationId == 'Sit' and key ~= CommonConst.SignBoardThird then
                            Npc:SetSitPoseInteractive()
                        end
                    end)
                end
                break
            end
        end
    end
end

--播放入口的动效
function WBP_Battle_C:OnHomeBaseBtnPlayAnim(UIName,AnimationName)
    self:AddTimer(0.01, function()
        local EntryList = self.ListView:GetDisplayedEntryWidgets():ToTable()
        for _, v in ipairs(EntryList) do
            v:OnHomeBaseBtnPlayAnim(UIName,AnimationName)
        end
    end, nil, nil, nil, false)
end
function WBP_Battle_C:OnSwitchRole()
    for i = 0,self.ListView:GetNumItems() - 1 do
        local Item = self.ListView:GetItemAt(i)
        if Item and Item.BtnId == CommonConst.ArmoryEnterId then
            if Item.SelfWidget then
                Item.SelfWidget:UpdateArmoryIcon()
            end
        end
    end
end

function WBP_Battle_C:OnSystemUIUnLoad(UIName)
    self:RemovePlayInOutSystems(UIName)
    local SystemUIConfig = DataMgr.SystemUI[UIName]
    if (SystemUIConfig and SystemUIConfig.IsHideBattleUnit) then
        if (SystemUIConfig.IsHideBattleUnit ~= UIConst.EnumHideBattleUnitStyle.NormalShowAndHideAll and 
            SystemUIConfig.IsHideBattleUnit ~= UIConst.EnumHideBattleUnitStyle.NormalShowAndHideAllExceptSelf) then
            return
        end
    end
    if UIManager(self).States:Num() ~= 0 then
        return
    end
    self:UnLoadSystem(UIName)
end

function WBP_Battle_C:UnLoadSystem(UIName)
    local SystemInfo, IsPlayInAnim = DataMgr.MainUI, false
    self:RemovePlayInOutSystems(UIName)
    if (UIName == UIConst.MenuLevel) then
        IsPlayInAnim = self:TryRecoverUI()
    else
        for SystemId,Info in pairs(SystemInfo) do
            if (self:CheckNeedPlayInOutAnim(SystemId)) then -- 判断有些东西是否不需要播放In/Out
                local SystemName = Info.SystemUIName
                if SystemName and SystemName == UIName then
                    local MenuWorld = UIManager(self):GetUIObj(UIConst.MenuWorld)
                    if MenuWorld then
                        -- 如果有Esc界面打开，则不播放In动画，Esc关闭的时候再去播放
                        return false
                    end
                    IsPlayInAnim = self:TryRecoverUI()
                    break
                end
            end
        end
    end
    ---@note 如果分辨率在最近发生更改，在UnloadSystem尝试触发战斗聊天悬浮UI的重建
    self:InitChatSimple()
    return IsPlayInAnim
end

function WBP_Battle_C:CheckNeedPlayInOutAnim(SystemId)
    -- 判断是否需要跳过渐隐渐显的动画
    if (SystemId == CommonConst.ArmoryEnterId) then
        return false
    elseif (SystemId == ChatCommon.MainUIId) then
        return false
    end
    return true
end

function WBP_Battle_C:TryRecoverUI()
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if IsValid(Player) and Player.IsImmersionModel  then
        self:SetVisibility(UIConst.VisibilityOp.Collapsed)
        return false
    end

    if self:CheckPlayInOutSystems() then return false end
    self:PlayInAnim()
    self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    return true
end

function WBP_Battle_C:PlayInAnim()
    ---@note 战斗界面不打开可以往这里断点去查
    if self:CheckPlayInOutSystems() then return end
    DebugPrint("-----Jzn---主界面 in-------")
    self:SetUIVisibilityTag("PlayBattleAni", false)
    self:UnbindAllFromAnimationFinished(self.In)
    local ShowSelf = function()
        self:UnbindAllFromAnimationFinished(self.In)
        --SystemGuideManager:ShowUIEvent(self.WidgetName)
    end
    self:BindToAnimationFinished(self.In,{self,ShowSelf})

    self:StopAnimation(self.Out)
    self:PlayAnimation(self.In)
    self.IsPlayOutAnim = false

    --显示的时候领Mod教程奖励
    local Widget =self.Pos_Instruction_Mod:GetChildAt(0)
    if Widget and Widget:GetVisibility()~=UE4.ESlateVisibility.Collapsed then
        Widget:TryGetReward()
    end
    -- self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

function WBP_Battle_C:_RefreshEscReddot()
    --esc红点保底恢复
    local Node = ReddotManager.GetTreeNode("BattleMainMenu")
    if Node then
        Node:TryFireOnCountChange(Node.Count, true)
    end
    --活动红点保底刷新
    local ActiNode = ReddotManager.GetTreeNode("ActivityHub")
    if ActiNode then
        local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils" 
        ActivityUtils.RefreshActivityReddotNode()
    end
end

function WBP_Battle_C:AddPlayInOutSystems(UIName)
    if (UIName == nil) then
        return
    end
    if self.PlayInOutSystems == nil then
        self.PlayInOutSystems = {}
    end
    self.PlayInOutSystems[UIName] = true
end

--移除标志，用于UnLoadUI之前的操作，比如ESC菜单栏和军械库的Close
function WBP_Battle_C:RemovePlayInOutSystems(UIName)
    if (UIName == nil) then
        return
    end
    if self.PlayInOutSystems[UIName] then
        self.PlayInOutSystems[UIName] = false
    end
    return true
end

function WBP_Battle_C:CheckPlayInOutSystems()
    for SystemUI,bDontPlayIn in pairs(self.PlayInOutSystems) do
        if bDontPlayIn then 
            DebugPrint("--jzn---系统"..SystemUI.."还未关闭,无需播放主界面的In")
            return true
        end
    end
    self.PlayInOutSystems = {}
    return false
end

function WBP_Battle_C:PlayOutAnim(Obj,Func,SystemUIName)
    DebugPrint("-----Jzn---主界面 out-------")
    self:SetUIVisibilityTag("PlayBattleAni", true)
    self:StopAnimation(self.In)
    self:PlayAnimation(self.Out)
    self.IsPlayOutAnim = true
    self:UnbindAllFromAnimationFinished(self.Out)
    self:AddPlayInOutSystems(SystemUIName)
    -- self:SetInputUIOnly(true)
    if Obj and Func then
        Func(Obj)
    end
    local HideSelf = function()
        self.IsPlayOutAnim = false
        self:SetVisibility(UE4.ESlateVisibility.Collapsed)
        --SystemGuideManager:HideUIEvent(self.WidgetName)
    end
    self:BindToAnimationFinished(self.Out,{self,HideSelf})
end

------------------------end-------------------------------------
function WBP_Battle_C:PlayDeathMaskIn()
    local Mask_Death = self:GetOrAddWidget("DeathMask", self.Pos_Death)
    if Mask_Death then 
        Mask_Death:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        Mask_Death:PlayAnimation(Mask_Death.Mask_Death_In)
    end
end

function WBP_Battle_C:PlayDeathMaskOut()
    ---@type UWidget
    local Mask_Death = self:GetOrAddWidget("DeathMask", self.Pos_Death)
    if Mask_Death then 
        local Visibility = Mask_Death.Panel_Death:GetVisibility()
        if Visibility == UE4.ESlateVisibility.Visible then
            Mask_Death.Panel_Death:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            Mask_Death:PlayAnimation(Mask_Death.Mask_Death_Out)
        else
            Mask_Death:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end
end

-- 当玩家死亡时，隐藏一些不必要的UI
function WBP_Battle_C:ShowPlayerDeadUI()
    local Player =  UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local ResurgenceUIName = Player:GetCurRecoveryUIName()
    local BattleResurgenceUI = UIManager(self):GetUI(ResurgenceUIName)
    if BattleResurgenceUI then
        self:ShowOrHideMainPlayerBloodUI(false,"Dead")
        self:HideSubSystem("Char_Skill", "Dead", true)
        if self.TakeAimIndicator then
            self.TakeAimIndicator:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        self:ShowOrHideTeamDataTag(false)
    end
    -- self:PlayDeathMaskIn()

    if self.HBox then 
        self.HBox:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    -- 周本传送隐藏
    if self.IsShowingTeleportUI == true then
        self:StopTeleportInDungeon(true)
    end
end

-- 当玩家复活时，恢复一些不必要的UI
function WBP_Battle_C:HidePlayerDeadUI()
    self:ShowOrHideMainPlayerBloodUI(true,"Dead")
    self:HideSubSystem("Char_Skill", "Dead", false)
    local OwnerPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    self.Char_Skill:OnUpdateCharSp(nil, OwnerPlayer)

    if self.HBox then 
        self.HBox:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end

    if self.TakeAimIndicator then
        self.TakeAimIndicator:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        self.TakeAimIndicator:RefreshUIShowPage()
    end
    local PlayerAvatar, IsNeedShowTeamTag = GWorld:GetAvatar(), false
    if (PlayerAvatar ~= nil) then
        if (not GWorld:IsStandAlone()) then
            -- 位于副本之中
            IsNeedShowTeamTag = GameState(self).PlayerArray:Num() > 1
        else
            local TeamModelData = TeamController:GetModel()
            local TeamAvatarData = TeamModelData:GetTeam()
            local TeamNumber = TeamAvatarData == nil and 0 or #TeamAvatarData.Members
            IsNeedShowTeamTag = TeamNumber > 1
        end 
    end
    self:ShowOrHideTeamDataTag(IsNeedShowTeamTag)

    local Player =  UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local ResurgenceUIName = Player:GetCurRecoveryUIName()
    local BattleResurgenceUI = UIManager(self):GetUI(ResurgenceUIName)
    if BattleResurgenceUI then
        BattleResurgenceUI:Close()
    end
    -- self:PlayDeathMaskOut()

    -- 周本传送恢复显示
    if self.IsShowingTeleportUI == true then
        self:TeleportReady()
    end
end

-- 进入炮台时，隐藏一些不必要的UI
function WBP_Battle_C:ShowBattleFortUI()
    local BattleFortUI = UIManager(self):GetUI("BattleFort") or UIManager(self):GetUI("BattleFort02")
    if BattleFortUI then
        if BattleFortUI.HideUITable then
            for Name,_ in pairs(BattleFortUI.HideUITable) do
                self:HideSubSystem(Name, "BattleFort", true)
                if Name == "Pos_Entry" then
                    self.HideSystemEntrance = true
                elseif Name == "Btn_GuideBook" then
                    self.HideGuideBookBtn = true
                end
            end
        end
        self:ShowOrHideMainPlayerBloodUI(false,"BattleFort")
        if self.TakeAimIndicator then
            self.TakeAimIndicator:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        if IsValid(self.Joystick) then
            self.Joystick:SetTouchVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end
end

-- 离开炮台时，恢复一些不必要的UI
function WBP_Battle_C:HideBattleFortUI()
    local BattleFortUI = UIManager(self):GetUI("BattleFort") or UIManager(self):GetUI("BattleFort02")
    if BattleFortUI then
        if BattleFortUI.HideUITable then
            for Name,VisibleState in pairs(BattleFortUI.HideUITable) do
                self:HideSubSystem(Name, "BattleFort", false)
                if Name == "Pos_Entry" then
                    self.HideSystemEntrance = false
                elseif Name == "Btn_GuideBook" then
                    self.HideGuideBookBtn = false
                end
            end
        end
        self:ShowOrHideMainPlayerBloodUI(true,"BattleFort")
        if self.TakeAimIndicator then
            self.TakeAimIndicator:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
            self.TakeAimIndicator:RefreshUIShowPage()
        end
        if IsValid(self.Joystick) then
            self.Joystick:SetTouchVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
        self:InitBtnList()
    end
end

function WBP_Battle_C:ShowFeinaEventHUD()
    local FeinaEventHUD = UIManager(self):LoadUINew("FeinaEventHUD")
    if FeinaEventHUD then
        if FeinaEventHUD.HideUITable then
            for Name,_ in pairs(FeinaEventHUD.HideUITable) do
                self:HideSubSystem(Name, "FeinaEvent", true)
                if Name == "Pos_Entry" then
                    self.HideSystemEntrance = true
                elseif Name == "Btn_GuideBook" then
                    self.HideGuideBookBtn = true
                end
            end
        end
        -- 隐藏血条
        self:ShowOrHideMainPlayerBloodUI(false,"FeinaEvent")
        -- 屏蔽任务栏
        local TaskBar = TaskUtils:GetTaskBarWidget()
        if TaskBar then
            TaskBar:SetUIVisibilityTag("FeinaEvent", true)
        end
    end
end

function WBP_Battle_C:HideFeinaEventHUD()
    local FeinaEventHUD = UIManager(self):GetUI("FeinaEventHUD")
    if FeinaEventHUD then
        if FeinaEventHUD.HideUITable then
            for Name,_ in pairs(FeinaEventHUD.HideUITable) do
                self:HideSubSystem(Name, "FeinaEvent", false)
                if Name == "Pos_Entry" then
                    self.HideSystemEntrance = false
                elseif Name == "Btn_GuideBook" then
                    self.HideGuideBookBtn = false
                end
            end
        end
        -- 显示血条
        self:ShowOrHideMainPlayerBloodUI(false,"FeinaEvent")
        -- 显示任务栏
        local TaskBar = TaskUtils:GetTaskBarWidget()
        if TaskBar then
            TaskBar:SetUIVisibilityTag("FeinaEvent", false)
        end
        self:InitBtnList()
    end
end

function WBP_Battle_C:ShowOrHideMainPlayerBloodUI(bIsShow,Tag)
    DebugPrint("WBP_Battle_C:ShowOrHideMainPlayerBloodUI",bIsShow,Tag)
    if self.HUD_MainBar then
        self.HUD_MainBar:SetUIVisibilityTag(Tag,not bIsShow)
    end
end

function WBP_Battle_C:ShowOrHideTeamDataTag(bIsShowTag)
    local TargetWidgetNode = nil
    if (CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile") then
        TargetWidgetNode = nil
    else
        TargetWidgetNode = self.VB_Tag
    end
    if not TargetWidgetNode then return end
    if (bIsShowTag) then
        if (not TargetWidgetNode:IsVisible()) then
            TargetWidgetNode:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
    else
        if (TargetWidgetNode:IsVisible()) then
            TargetWidgetNode:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end
end

-- function WBP_Battle_C:LoadSystem(UIName)
--     DebugPrint("----jzn----LoadSystem(UIName)----",UIName)
--     for SystemId,_ in pairs(self.SystemUnlockList) do
--         local SystemInfo = DataMgr.MainUI[SystemId]
--         local SystemName = SystemInfo.SystemUIName
--         if SystemName and SystemName == UIName then
--             self:BindOutAnim(Obj,Func)
--         end
--     end
-- end

function WBP_Battle_C:SetUIVisibilityTag(HideTag, Invisible)
    if (not IsValid(self)) then
        return
    end
    if self.HideTags == nil then
        self.HideTags = {}
    end
    if Invisible then
        self.HideTags[HideTag] = 1
    else
        self.HideTags[HideTag] = nil
    end
    local IsHide = not IsEmptyTable(self.HideTags)
    local IsShippingPackage = UE4.UKismetSystemLibrary.IsPackagedForDistribution()
    if (IsHide) then
        if (IsShippingPackage and CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile") then
            self:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.Panel_Content:SetVisibility(UE4.ESlateVisibility.Collapsed)
            SystemGuideManager:HideUIEvent(self.WidgetName)
        else
            SystemGuideManager:HideUIEvent(self.WidgetName)
            if(self:GetVisibility() ~= ESlateVisibility.Collapsed) then
                self:SetVisibility(UE4.ESlateVisibility.Collapsed)
                -- SystemGuideManager:HideUIEvent(self.WidgetName)
            end
        end
    else
        if (IsShippingPackage and CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile") then
            self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.Panel_Content:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            SystemGuideManager:ShowUIEvent(self.WidgetName)
        else
            if(self:GetVisibility() == UE4.ESlateVisibility.Visibie or self:GetVisibility() == UE4.ESlateVisibility.SelfHitTestInvisible) then
                SystemGuideManager:ShowUIEvent(self.WidgetName)
            end
            if(self:GetVisibility() ~=UE4.ESlateVisibility.SelfHitTestInvisible) then
                self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                SystemGuideManager:ShowUIEvent(self.WidgetName)
            end

        end
    end
end

function WBP_Battle_C:OnBattleMapClose()
    self.Battle_Map:OnClickClose()
end

function WBP_Battle_C:SetVisibility(InVisibility)
    self.Overridden.SetVisibility(self,InVisibility)
    if IsValid(self.Joystick) then
        self.Joystick:SetTouchVisibilityFromBattle(InVisibility)
    elseif (CommonUtils:GetDeviceTypeByPlatformName(self) == CommonConst.CLIENT_DEVICE_TYPE.MOBILE) then
        UIManager(self):ShowUIError(UIConst.ErrorCategory.HUD, "Hy@== 主界面虚拟摇杆无效了Joystick 不存在, 摇杆表现可能受影响")
    end
end

function WBP_Battle_C:ShowInstructionInfo(ActionName, IsHide)
    local Platform = CommonUtils:GetDeviceTypeByPlatformName(self)
    self.Pos_Instruction:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    local Instruction = self.Pos_Instruction:GetChildAt(0)
    if Platform == "PC" then
        if Instruction == nil then
            Instruction = self:GetOrAddWidget("InstructionPC", self.Pos_Instruction)
            if Instruction then 
                Instruction:HideAllText()
            end
        end
    else
        if Instruction == nil then
            Instruction = self:GetOrAddWidget("InstructionMobile", self.Pos_Instruction)
            if Instruction then 
                Instruction:HideAllText()
            end
        end
    end
    if Instruction then 
        DebugPrint(ActionName, "===ShowInstructionInfo=============================")
        if IsHide then
            Instruction:HideActionText(ActionName)
        else
            Instruction:ShowActionText(ActionName)
        end
    end
end

function WBP_Battle_C:HideDynamicEventUI()
   
    local DynWidget=self:GetOrAddDynamicEventWidget()
    if DynWidget then
        DynWidget:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function WBP_Battle_C:OnTeammateDie(TargetEid)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    local Teammate = Battle(self):GetEntity(TargetEid)
    if Player.Eid ~= TargetEid then 
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, string.format(GText("BATTLE_RECOVERY_TEAMMATEDEAD"), UIUtils.GetCharName(Teammate)))
    end
end

function WBP_Battle_C:OnTeammateRecovery(TargetEid)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    local Teammate = Battle(self):GetEntity(TargetEid)
    if Player.Eid ~= TargetEid then 
        if Teammate:IsPhantom() then 
            UIManager(self):ShowUITip(UIConst.Tip_CommonTop, string.format(GText("BATTLE_RECOVERY_TEAMMATERECOVERY"), UIUtils.GetCharName(Teammate)))
        elseif Teammate:IsPlayer() then
            local GameState = UE4.UGameplayStatics.GetGameState(self)
            for key,value in pairs(GameState.PlayerArray) do
                if value == Teammate.PlayerState then
                    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, string.format(GText("BATTLE_RECOVERY_TEAMMATERECOVERY"), UIUtils.GetCharName(Teammate)))
                end
            end
        end
    end
end

function WBP_Battle_C:CreatTakeAimIndicator()
    self.TakeAimIndicator = self:CreateWidgetNew("TakeAimIndicator")
    if self.TakeAimIndicator then
        local Slot = self.Pos_Aim:AddChildToOverlay(self.TakeAimIndicator)
        Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
        Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
        local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
        self.TakeAimIndicator:Init(Player)
        self.Pos_Aim:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
    end
end

function WBP_Battle_C:EndAim()
    self.Pos_Aim:ClearChildren()
end

function WBP_Battle_C:GetTakeAimIndicator()
    return self.TakeAimIndicator 
end

function WBP_Battle_C:OnKeyDown(MyGeometry, InKeyEvent)
    return UIUtils.Unhandled
end

function WBP_Battle_C:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    ---战斗Hud需要禁用十字键导航，如果有十字键相关的交互，需要在这段代码前面的时序去做
    if InKeyName == UIConst.GamePadKey.DPadDown or 
        InKeyName == UIConst.GamePadKey.DPadUp or
        InKeyName == UIConst.GamePadKey.DPadRight or 
        InKeyName == UIConst.GamePadKey.DPadLeft then
        return UIUtils.Handled
    end
    return UIUtils.Unhandled
end

function WBP_Battle_C:HideSubSystem(Name, HideTag, IsHide)
    if not HideTag or not Name then
        return
    end
    if self[Name] then
        if not self.SystemHideTags[Name] then
            self.SystemHideTags[Name] = {}
        end
        local Tags = self.SystemHideTags[Name]
        if IsHide then
            Tags[HideTag] = 1
        else
            Tags[HideTag] = nil
        end
        if IsEmptyTable(Tags) then
            self[Name]:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        else
            self[Name]:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end
end

function WBP_Battle_C:SetSubSystemVisibility(Name, Visibility)
    if self[Name] then
        if not self:IsSubSystemHide(Name) then
            self[Name]:SetVisibility(Visibility)
        end
    end
end

function WBP_Battle_C:IsSubSystemHide(Name)
    if not Name or not self[Name] then
        DebugPrint("System Does Not Exist. Name: ", Name)
        return
    end
    local Tags = self.SystemHideTags[Name]
    if not Tags or IsEmptyTable(Tags) then
        return false
    else
        return true
    end
end

function WBP_Battle_C:OnTempleRightUI()
    self.Group_Temple:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Pos_TempleRight:ClearChildren()
    self.TempleRightUI = self:CreateWidgetNew("DungeonTempleRight")
    self.TempleRightUI:ConstructInfo()
    self.Pos_TempleRight:AddChild(self.TempleRightUI)
    self.Pos_TempleRight:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    
    -- 屏蔽任务栏
    local TaskBar = TaskUtils:GetTaskBarWidget()
    if TaskBar then
        TaskBar:SetUIVisibilityTag("Temple", true)
    end

end

function WBP_Battle_C:OnSoloTreasureScoreAndBagUI()
    self.Pos_SoloTreasure_Score:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Pos_SoloTreasure_Score:ClearChildren()
    self.SoloTreasureScoreAndBagUI = self:CreateWidgetNew("SoloTreasureScoreAndBag")
    self.SoloTreasureScoreAndBagUI:InitWidgetUI()
    self.Pos_SoloTreasure_Score:AddChild(self.SoloTreasureScoreAndBagUI)
end

function WBP_Battle_C:OnPartyEnter()
    local TaskBar = TaskUtils:GetTaskBarWidget()
    if TaskBar then
        TaskBar:SetUIVisibilityTag("Party", true)
    end
end

function WBP_Battle_C:OnPartyProgressStart()
    self.PartyProgress = self:CreateWidgetNew("PartyProgress")
    self.PartyProgress:ConstructInfo()
    self.Pos_TempleProgress:AddChild(self.PartyProgress)
end

-- Mod手册任务完成
function WBP_Battle_C:OnModBookQuestFinished(QuestId)
    DebugPrint("zwk OnModBookQuestFinished", QuestId)
    if not self.ModArchives then
        self.ModArchives = TArray(0)
    end
    self.ModArchives:Add(QuestId)
    if self.ModArchives:Length() > 0 and self.ModArchives:GetRef(1) == QuestId then
        self:ShowModBookTips(QuestId)
    end
end

-- 显示Mod手册任务完成进度
function WBP_Battle_C:ShowModBookTips(QuestId)
    UIManager(self):LoadUINew("ModArchiveTaskTips", self, QuestId)
    -- QuestInfo:InitInfo(self, QuestId)
end

-- 前一个Mod手册任务完成，接下一个
function WBP_Battle_C:OnPreModArchiveFinished(QuestId)
    if self.ModArchives then
        self.ModArchives:RemoveItem(QuestId)
    end
    if self.ModArchives:Length() > 0 then
        local QuestId = self.ModArchives:GetRef(1)
        self:ShowModBookTips(QuestId)
    end
end

function WBP_Battle_C:OnNotifyCommonCountDown(Count, bShowZeroText, CountDownSound, LastCountDownSound)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if UIManager == nil then
        return
    end
    local UIManager = GameInstance:GetGameUIManager()
    local GuideCountDownFloat = UIManager:GetUIObj("GuideCountDown")
    if GuideCountDownFloat then
        GuideCountDownFloat:OnCountDownEnd()
        GuideCountDownFloat:Close()
    end
    GuideCountDownFloat = UIManager:LoadUINew("GuideCountDown")
    GuideCountDownFloat:SetVisibility(ESlateVisibility.Collapsed)
    self:ShowCommonCountDown(GuideCountDownFloat, Count + 1, bShowZeroText, CountDownSound, LastCountDownSound)
end

function WBP_Battle_C:OnNotifyShowLargeCountDown(Count,bShowZeroText)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if UIManager == nil then
        return
    end
    local UIManager = GameInstance:GetGameUIManager()
    local GuideCountDownFloat = UIManager:GetUIObj("GuideCountDown")
    if GuideCountDownFloat then
        GuideCountDownFloat:OnCountDownEnd()
        GuideCountDownFloat:Close()
    end
    GuideCountDownFloat = UIManager:LoadUINew("GuideCountDown")
    GuideCountDownFloat:SetVisibility(ESlateVisibility.Collapsed)
    self:ShowCountDown(GuideCountDownFloat, Count + 1,bShowZeroText)
end

---#region 优化相关

function WBP_Battle_C:EMAfterInitialize()
    WBP_Battle_C.Super.EMAfterInitialize(self)
    self.Platform = CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance)
    if (self.Platform == CommonConst.CLIENT_DEVICE_TYPE.MOBILE) then
        -- 手机端优化相关
        if (UIConst.OptimizeSwitch[CommonConst.CLIENT_DEVICE_TYPE.MOBILE].UI_WRAPPING_WITH_INVALIDBOX) then
            -- self.InvalidationBox_Battery = self:ArrangeSingleWidgetWithInvalidBox(self.Battery, "InvalidationBox_Battery")
            -- self.InvalidationBox_AllEntry = self:ArrangeSingleWidgetWithInvalidBox(self.Pos_Entry, "InvalidationBox_AllEntry")
        end
    
        if (UIConst.OptimizeSwitch[CommonConst.CLIENT_DEVICE_TYPE.MOBILE].UI_WRAPPING_WITH_RETAINERBOX) then
            -- local IsShippingPackage = UE4.UKismetSystemLibrary.IsPackagedForDistribution()
            if (self:CheckOptimizeSwitch_ForTaskBar()) then
                self:ArrangeSingleWidgetWithRetainerBox(self.Pos_TaskBar, "CustomRetainerBox_TaskBar", 1, 10)
            end
            -- self:ArrangeSingleWidgetWithRetainerBox(self.HUD_MainBar, "CustomRetainerBox_HUDMainBar", 9, 15)
            self:ArrangeSingleWidgetWithRetainerBox(self.Pos_Drops, "CustomRetainerBox_CommonDrops", 2, 10)
            -- self:ArrangeSingleWidgetWithRetainerBox(self.Pos_SpecialDrops, "CustomRetainerBox_SpecialDrops", 7, 15)
            self:ArrangeSingleWidgetWithRetainerBox(self.Char_Skill, "CustomRetainerBox_Skill", 1, 3)
            self:ArrangeSingleWidgetWithRetainerBox(self.Pos_Entry, "CustomRetainerBox_Entry", 3, 15)
            -- self:ArrangeSingleWidgetWithRetainerBox(self.Battery, "CustomRetainerBox_Battery", 3, 15)
        end
    elseif (self.Platform == CommonConst.CLIENT_DEVICE_TYPE.PC) then
        -- PC端优化相关
        if (UIConst.OptimizeSwitch[CommonConst.CLIENT_DEVICE_TYPE.PC].UI_WRAPPING_WITH_RETAINERBOX) then
            self:ArrangeSingleWidgetWithRetainerBox(self.Pos_Drops, "CustomRetainerBox_CommonDrops", 1, 10)
            self:ArrangeSingleWidgetWithRetainerBox(self.Pos_SpecialDrops, "CustomRetainerBox_SpecialDrops", 5, 10)
            self:ArrangeSingleWidgetWithRetainerBox(self.Char_Skill, "CustomRetainerBox_Skill", 2, 10)
        end
    end
end

function WBP_Battle_C:CheckOptimizeSwitch_ForTaskBar()
    local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(self)
    if PlatformName == "Android" then
        -- 安卓暂时不做处理
        return false
    end
    local IsShippingPackage = UE4.UKismetSystemLibrary.IsPackagedForDistribution()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if GameState and GameState.GameModeType == "Synthesis" then
        return false
    elseif (IsShippingPackage) then
        return true
    end
    return false
end

---#endregion

-- 推理相关
function WBP_Battle_C:OnHomeBaseeBtnShowNewClue(UIName)
    self:AddTimer(5, function()
        self.Btn_Task:OnHomeBaseeBtnShowNewClue(UIName)
    end, nil, nil, nil, false)
end

function WBP_Battle_C:OnNewDetectiveQuestion(Question, IsFinished)
    local QuestionData = DataMgr["DetectiveQuestion"][Question]
    if not QuestionData then
        return
    end
    -- 子问题不显示这个
    if QuestionData.ParentQuestionID then
        return
    end
    local ReasoningToast = nil
    self:AddTimer(1, function()
        ReasoningToast = UIManager(self):CreateWidget("WidgetBlueprint'/Game/UI/WBP/Reasoning/Widget/WBP_Reasoning_Toast.WBP_Reasoning_Toast'", true)
        -- ReasoningToast:SetVisibility(UE4.ESlateVisibility.Collapsed)
        ReasoningToast.Text_Title:SetText(GText(QuestionData.Tips))
        ReasoningToast.Text_Status:SetText(GText("Minigame_Textmap_100301"))
        if IsFinished then
            ReasoningToast.Text_Status:SetText(GText("Minigame_Textmap_100302"))
        end
        ReasoningToast:PlayAnimation(ReasoningToast.In)
        AudioManager(self):PlayUISound(self, "event:/ui/common/tuili_clue_toast", nil, nil)
    end, nil, nil, nil, false)
    self:AddTimer(3, function()
        ReasoningToast:PlayAnimation(ReasoningToast.Out)
    end, nil, nil, nil, false)
end

--退出炮台按键提示
function WBP_Battle_C:CreateFortBack()
    self.Pos_FortBack:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Pos_FortBack:ClearChildren()
    local FortBackEntry = self:GetOrAddWidget("BattleEntryItem", self.Pos_FortBack)
    return FortBackEntry
end

function WBP_Battle_C:DestoryFortBack()
    self.Pos_FortBack:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Pos_FortBack:ClearChildren()
end

-- 出现组队邀请时屏蔽教学系统
function WBP_Battle_C:EnableGuideBookKey(bEnable)
    if bEnable then
        self:ListenForInputAction("OpenGuideBook", EInputEvent.IE_Pressed, false, {self, self.OpenGuideBook})
    else
        self:StopListeningForInputAction("OpenGuideBook", EInputEvent.IE_Pressed)
    end
end

function WBP_Battle_C:InitGameJumpWord()
	local JumpWordManager = USubsystemBlueprintLibrary.GetWorldSubsystem(self, UJumpWordManager)
    if JumpWordManager then
		local OptionName1 = "DamageTextAmount"
		local GameDamageTextAmount = EMCache:Get(OptionName1)
		if GameDamageTextAmount == nil then
			local OptionInfo = DataMgr.Option[OptionName1]
			local DefaultSize = OptionInfo.DefaultValue
			if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" and OptionInfo.DefaultValueM then
				DefaultSize = OptionInfo.DefaultValueM
			end
			GameDamageTextAmount =  DefaultSize / OptionInfo.ScrollMappingScale
			EMCache:Set(OptionName1,GameDamageTextAmount)
		end
		JumpWordManager:SetMaxJumpWordCountRatio(GameDamageTextAmount)
		local OptionName2 = "DamageTextScale"
		local GameDamageTextScale = EMCache:Get(OptionName2)
		if GameDamageTextScale == nil then
			local OptionInfo = DataMgr.Option[OptionName2]
			local DefaultSize = OptionInfo.DefaultValue
			if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" and OptionInfo.DefaultValueM then
				DefaultSize = OptionInfo.DefaultValueM
			end
			GameDamageTextScale =  DefaultSize / OptionInfo.ScrollMappingScale
			EMCache:Set(OptionName2,GameDamageTextScale)
		end
		JumpWordManager:SetJumpWordSize(tonumber(GameDamageTextScale))
	end
end

function WBP_Battle_C:CheckTheaterEventState()
    local Avatar = GWorld:GetAvatar()
    if not Avatar or Avatar.CurrentRegionId ~= 101901 then 
        return 
    end
    local Cb = function(ErrCode,Ret)
        if Ret and Ret.IsJoin == true and ErrCode == 0 then
            if (Ret.State == 0 or Ret.State == 1) then
                self:TheaterJoinPerformGame()
            elseif Ret.State == 2 then
                -- 从大世界返回，重新加入游戏
                self:TheaterPerformGameStart(CommonConst.TheaterEventId, Ret.PerformList, true)
            end
        end
    end
    Avatar:TheaterPerformStateGet(Cb)
end

function WBP_Battle_C:TheaterJoinPerformGame()
    if self.TheaterCheckTimer then
        self:RemoveTimer(self.TheaterCheckTimer)
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end

    local Cb = function(ErrCode,Ret)
        if Ret.State == 1 then
            -- 游戏已开始，但可中途加入
            self:TheaterPerformGameStart(CommonConst.TheaterEventId, Ret.PerformList)
            return
        end
    end
    Avatar:TheaterPerformStateGet(Cb)

    self.TheaterTaskTime = UIManager(self):LoadUINew("TheaterTaskTime")
    self.Task:AddChild(self.TheaterTaskTime)
    self.TheaterTaskTime.IsInit = true
    self.TheaterTaskTime:InitUI()
    self.JoinTheaterGame = true
end

function WBP_Battle_C:TheaterJoinPerformGameFail()
    if self.TheaterTaskTime then return end
    DebugPrint("ayff test 加入剧院表演失败，显示失败UI time")
    self.TheaterTaskTime = UIManager(self):LoadUINew("TheaterTaskTime")
    self.Task:AddChild(self.TheaterTaskTime)
    self.TheaterTaskTime.IsInit = true
    self.TheaterTaskTime:InitFailUI()
end

function WBP_Battle_C:OnTheaterPerformGameNotice(EventId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
    if not Avatar:IsInHardBoss() and GameState:IsInRegion() and Avatar.CurrentRegionId ~= 101901 then 
        for i = 0,self.ListView:GetNumItems() - 1 do
            local Item = self.ListView:GetItemAt(i)
            if Item and Item.BtnId == 19 then
                if Item.SelfWidget then 
                    Item.SelfWidget:RefreshNewTheaterUI()
                end
            end
        end
    end
end

function WBP_Battle_C:TheaterPerformGameStart(EventId, PerformList, ReStart)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    if self.TheaterTaskTime then
        self.Task:RemoveChild(self.TheaterTaskTime)
        self.TheaterTaskTime:Close() 
    end
    self.TheaterToast = nil
    self.Pos_Rouge_CountDown:ClearChildren()

    local Cb = function(ErrCode, Ret)
        if ErrCode == 0 and Ret.IsJoin == true then
            local Avatar = GWorld:GetAvatar()
            if not Avatar then return end
            local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
            local RegionId = Avatar.CurrentRegionId
            if not GameState:IsInRegion() or RegionId ~= 101901 or Avatar:IsInHardBoss() then 
                DebugPrint("ayff test 当前不在剧院区域 RegionId:", RegionId)
                return
            end
            self.TheaterToast = UIManager(self):LoadUINew("TheaterToast")
            self.TheaterToast.ParentWidget = self
            self.Pos_Rouge_CountDown:AddChild(self.TheaterToast)
            self.Pos_Rouge_CountDown:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.TheaterToast.IsInit = true
            self.TheaterToast:UpdatePerformList(PerformList)

            if ReStart then
                self.TheaterToast.ReStartPerform = true
            end
        end
    end
    Avatar:TheaterPerformStateGet(Cb)
end

function WBP_Battle_C:TeleportReady(IsEnd)
    local TaskBar = TaskUtils:GetTaskBarWidget()
    if TaskBar then
        if IsEnd and IsEnd == true then
            self:StopTeleportInDungeon(true)
            return
        end

        TaskBar:SetTeleportBubble(true)
        self.IsShowingTeleportUI = true


        if TaskBar.Platform == "Mobile" then
            TaskBar.WBP_Btn_Tips3:SetVisibility(UE4.ESlateVisibility.Visable)
            TaskBar.WBP_Btn_Tips3.Text_Button:SetText(GText("DUNGEON_TELEPORT"))
            TaskBar.WBP_Btn_Tips3.Button_Area.OnClicked:Clear()
            local function OnTaskBarClicked()
                -- 传送
                local CommonDialogParams = {
                    RightCallbackFunction = function()
                        TaskBar:PlayAnimation(TaskBar.Transmit_Out)
                        local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
                        if Player then
                            Player.RPCComponent:NotifyServerStartDelivery()
                        end
                    end,
                    LeftCallbackFunction = nil,
                    CloseBtnCallbackFunction = nil,
                    AutoFocus = true,
                }
                TaskBar:RefreshTeleportBubble(true)
                UIManager(self):ShowCommonPopupUI(100267, CommonDialogParams, self)
            end
            TaskBar.WBP_Btn_Tips3.Button_Area.OnClicked:Add(self, OnTaskBarClicked)
        elseif TaskBar.Platform == "PC" then
            TaskBar.Text_Tips04:SetText(GText("DUNGEON_TELEPORT_LONGPRESS"))
            self:ListenForInputAction("Recovery", EInputEvent.IE_Pressed, false, {self, self.StartTeleportInDungeon})
            self:ListenForInputAction("Recovery", EInputEvent.IE_Released, false, {self, self.TeleportRelease})
        end
    end
end

function WBP_Battle_C:StartTeleportInDungeon()
    local TaskBar = TaskUtils:GetTaskBarWidget()
    if TaskBar then
        TaskBar.Key_Tips03:AddExecuteLogic(self, self.StopTeleportInDungeon)
        local PressTime = DataMgr.GlobalConstant.TeleportPressTime.ConstantValue or 1
        TaskBar.Key_Tips03:OnButtonPressed(nil, true, 0, PressTime)
        TaskBar.Key_Controller_Tips03:OnButtonPressed(nil, true, 0, PressTime)
        TaskBar:RefreshTeleportBubble(true)

        local GameState = UE4.UGameplayStatics.GetGameState(self)
        GameState.ShouldStopHookInDungeonDelivery = true
    end
    DebugPrint("ayff test press teleport button")
end

function WBP_Battle_C:StopTeleportInDungeon(ForceHide)
    local TaskBar = TaskUtils:GetTaskBarWidget()
    if TaskBar then
        self.IsShowingTeleportUI = false
        if ForceHide == true then
            TaskBar:PlayAnimation(TaskBar.Transmit_Out)
            self:StopListeningForInputAction("Recovery", EInputEvent.IE_Pressed)
            self:StopListeningForInputAction("Recovery", EInputEvent.IE_Released)
            return
        end
        TaskBar:PlayAnimation(TaskBar.Transmit_Out)
        self:StopListeningForInputAction("Recovery", EInputEvent.IE_Pressed)
        self:StopListeningForInputAction("Recovery", EInputEvent.IE_Released)
        local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
        local Tag = Player:GetCharacterTag()
        if Tag == "Hook" or Tag == "HitFly" then
            DebugPrint("ayff test 传送中断，角色处于钩锁或被击飞状态，无法传送")
        else
            Player.RPCComponent:NotifyServerStartDelivery()
        end
    end
    self:AddTimer(1, function()
        -- 防止传送意外中断导致无法钩锁
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        if GameState then
            GameState.ShouldStopHookInDungeonDelivery = false
            DebugPrint("ayff test 传送中断，恢复钩锁状态")
        else
            DebugPrint("ayff test 传送中断，恢复钩锁状态失败，GameState无效")
        end
    end)
    DebugPrint("ayff test release teleport button")
end

function WBP_Battle_C:TeleportRelease()
    local TaskBar = TaskUtils:GetTaskBarWidget()
    if TaskBar then
        TaskBar.Key_Tips03:OnButtonReleased()
        TaskBar.Key_Controller_Tips03:OnButtonReleased()
    end
end

----------------------- 手机端分包下载动效相关 -----------------------------------------------
--- 添加分包下载动效
function WBP_Battle_C:AddDownloadSignEffect()
    if not self.DownloadSign_EffectWidget then
        self.DownloadSign_EffectWidget = UIManager(self):CreateWidget("WidgetBlueprint'/Game/UI/WBP/Battle/Widget/WBP_Battle_EntryDownloadSign.WBP_Battle_EntryDownloadSign'", false)
        self.Pos_DownloadSign:AddChild(self.DownloadSign_EffectWidget)
    end
    if not self.Pos_DownloadSign:IsVisible() then
        self.Pos_DownloadSign:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
end

--- 移除分包下载动效
---@param bIsNeedRealRemove boolean 是否需要子节点，true表示需要移除动效节点，false表示只隐藏
function WBP_Battle_C:RemoveDownloadSignEffect(bIsNeedRealRemove)
    if (bIsNeedRealRemove) then
        if self.DownloadSign_EffectWidget then
            self.Pos_DownloadSign:RemoveChild(self.DownloadSign_EffectWidget)
            self.DownloadSign_EffectWidget = nil
        end
    end
    self.Pos_DownloadSign:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

--------------------------------------手机端主界面自定义布局相关----------------------------------------------
---手机端主界面自定义布局相关接口，更新数据相关
---@param OpType string 操作类型，Update表示更新布局，Reset表示重置布局
---@param LayoutPlan number 布局方案
function WBP_Battle_C:UpdateMobileLayoutInfoByServerData(OpType, LayoutPlan)
    -- 手机端更新布局
    local Platform = CommonUtils:GetDeviceTypeByPlatformName(self)
    if (Platform == CommonConst.CLIENT_DEVICE_TYPE.PC) then
        return
    end
    local PlayerAvatar = GWorld:GetAvatar()
    if not PlayerAvatar then
        return
    end

    if (LayoutPlan == nil) then
        LayoutPlan = PlayerAvatar:GetCurrentMobileHudPlanIndex() or 2
    end
    if (OpType == "Update") then
        for NodeName, WidgetConfig in pairs(BattleHUDCommonConst.ExtraNodeConfigInHUD) do
            local WidgetPlanData = PlayerAvatar:GetMobileHudPlan(LayoutPlan) or {}
            local TargetNodeWidget, TargetNodeSlot = self[NodeName], nil
            local SaveDataInHUD = WidgetPlanData[WidgetConfig.SettingNodeName]
            if (not SaveDataInHUD) then
                -- 如果服务器没有数据记录，使用定义在蓝图里面的默认数据
                SaveDataInHUD = self:GetDefaultLayoutInfoFromDesign(LayoutPlan, WidgetConfig.DefaultLayoutIndex)
            end
            if (TargetNodeWidget) then
                if (WidgetConfig.bUseParentSlot) then
                    TargetNodeSlot = TargetNodeWidget:GetParent().Slot
                else
                    TargetNodeSlot = TargetNodeWidget.Slot 
                end
                -- DebugPrint("UpdateMobileLayoutInfoByServerData The Layout Data Is ", NodeName, FVector2D(SaveDataInHUD.PosX, SaveDataInHUD.PosY), 
                --                 FVector2D(SaveDataInHUD.ScaleX, SaveDataInHUD.ScaleY))
                if (TargetNodeSlot) then
                    TargetNodeSlot:SetPosition(FVector2D(SaveDataInHUD.PosX, SaveDataInHUD.PosY))
                end
                if (WidgetConfig.bUseParentSlot) then
                    TargetNodeWidget:GetParent():SetRenderScale(FVector2D(SaveDataInHUD.ScaleX, SaveDataInHUD.ScaleY))
                else
                    TargetNodeWidget:SetRenderScale(FVector2D(SaveDataInHUD.ScaleX, SaveDataInHUD.ScaleY))
                end
            end
        end
    end
end

-- 根据蓝图中定义的默认数据，获取默认的布局信息
function WBP_Battle_C:GetDefaultLayoutInfoFromDesign(LayoutPlan, LayoutIndex)
    local ResultDesignData = {}
    local DefaultPositionPlan = self["DefaultPosition0"..tostring(LayoutPlan)]
    local DefaultScalePlan = self["DefaultPosScale0"..tostring(LayoutPlan)]
    -- local ChildIndex = math.max(0, LayoutIndex - 1)
    local ChildIndex = math.max(0, LayoutIndex)
    if (DefaultPositionPlan and DefaultPositionPlan:Get(ChildIndex)) then
        ResultDesignData.PosX = DefaultPositionPlan:Get(ChildIndex).X
        ResultDesignData.PosY = DefaultPositionPlan:Get(ChildIndex).Y
    else
        DebugPrint("WBP_Battle_C: GetDefaultLayoutInfoFromDesign Error Cannot find DefaultPositionPlan for this ChildIndex!", LayoutIndex)
    end
    if (DefaultScalePlan and DefaultScalePlan:Get(ChildIndex)) then
        ResultDesignData.ScaleX = DefaultScalePlan:Get(ChildIndex).X
        ResultDesignData.ScaleY = DefaultScalePlan:Get(ChildIndex).Y
    else
        DebugPrint("WBP_Battle_C: GetDefaultLayoutInfoFromDesign Error Cannot find ResultDesignData for this ChildIndex!", LayoutIndex)
    end
    return ResultDesignData
end

-- 根据服务器返回的布局数据，更新布局信息
---@param LayoutWidgetName string 布局节点名称
---@param EditPlanIndex number 布局方案索引
function WBP_Battle_C:GetLayoutInfoFromServer(LayoutWidgetName, EditPlanIndex)
    local PlayerAvatar = GWorld:GetAvatar()
    if not PlayerAvatar then
        return
    end
    if (EditPlanIndex == nil) then
        EditPlanIndex = PlayerAvatar:GetCurrentMobileHudPlanIndex()
    end
    local WidgetPlanData = PlayerAvatar:GetMobileHudPlan(EditPlanIndex) or {}
    return WidgetPlanData[LayoutWidgetName]
end

AssembleComponents(WBP_Battle_C)
return WBP_Battle_C