local EventID={}
_G.EventID = EventID ---给智能提示插件识别跳转
--登录
EventID.OnLoginSuccess="OnLoginSuccess"
EventID.OnGetAllAvatars="OnGetAllAvatars"
EventID.OnRefreshWithNextDay = "OnRefreshWithNextDay"

--据点看板娘
EventID.UpdateSignBoardNpc="UpdateSignBoardNpc"

--自定义改键
EventID.OnUpdateActionMapping = "OnUpdateActionMapping"
EventID.OnChangeKeyBoardSet = "OnChangeKeyBoardSet"
EventID.OnSwitchGamepadSet = "OnSwitchGamepadSet"

-- 红点刷新
EventID.OnMainUIReddotUpdate = "OnMainUIReddotUpdate"
EventID.OnReceiveNewQuest = "OnReceiveNewQuest"
EventID.OnHardBossReddotUpdate = "OnHardBossReddotUpdate"
EventID.OnGotTopicReward= "OnGotTopicReward"

--数值刷新
EventID.OnChangeActionPoint = "OnChangeActionPoint"
EventID.OnCharCardLevelResourcesChanged = "OnCharCardLevelResourcesChanged"
EventID.OnNewCharObtained = "OnNewCharObtained"
EventID.OnCharDeleted = "OnCharDeleted"
EventID.OnNewWeaponObtained = "OnNewWeaponObtained"
EventID.OnWeaponDeleted = "OnWeaponDeleted"
EventID.OnNewPetObtained = "OnNewPetObtained"
EventID.OnPetDeleted = "OnPetDeleted"
EventID.OnPropChangePets = "OnPropChangePets"
EventID.OnNewCharSkinObtained = "OnNewCharSkinObtained"
EventID.OnNewCharHairObtained = "OnNewCharHairObtained"
EventID.OnNewCharAccessoryObtained = "OnNewCharAccessoryObtained"
EventID.OnNewWeaponSkinObtained = "OnNewWeaponSkinObtained"
EventID.OnNewWeaponAccessoryObtained = "OnNewWeaponAccessoryObtained"
EventID.OnResourcesChanged = "OnResourcesChanged"
EventID.OnCharRewardStateChanged = "OnCharRewardStateChanged"
EventID.OnWeaponRewardStateChanged = "OnWeaponRewardStateChanged"

--抽卡
EventID.OnDrawGacha = "OnDrawGacha"
EventID.OnGachaPoolUpdate = "OnGachaPoolUpdate"

--邮箱
EventID.OnGetMailRewards = "OnGetMailRewards"
EventID.OnMarkMailStar = "OnMarkMailStar"
EventID.OnCancelMailStar = "OnCancelMailStar"
EventID.OnDeleteMail = "OnDeleteMail"
EventID.OnMarkMailReaded = "OnMarkMailReaded"
EventID.OnGetAllMailReward = "OnGetAllMailReward"
EventID.OnChangePropMailUniqueID = "OnChangePropMailUniqueID" --邮件数量发生变化，新增/删除，用于邮箱红点

--教学手册
EventID.OnGetGuideBookReward = "OnGetGuideBookReward"
EventID.OnEnableGuideBookKey = "OnEnableGuideBookKey" -- 禁用/启用教学手册快捷键

--军械库
EventID.OnSwitchRole="OnSwitchRole"
EventID.OnSwitchCurrentChar="OnSwitchCurrentChar"
EventID.OnChangeWeapon="OnChangeWeapon"
EventID.OnSwitchWeapon="OnSwitchWeapon"
EventID.OnCloseSkillInfo="OnCloseSkillInfo"
EventID.OnSwitchSkin="OnSwitchSkin"
EventID.OnSwitchPet = "OnSwitchPet"
EventID.OnArmoryShowPet = "OnArmoryShowPet"
EventID.OnPetEffectCreatureCreated = "OnPetEffectCreatureCreated"
EventID.OnArmoryPreviewModeStateChanged = "OnArmoryPreviewModeStateChanged"
EventID.OnArmoryTargetStateChanged = "OnArmoryTargetStateChanged"
EventID.OnPetEntryUpReturn="OnPetEntryUpReturn"
EventID.OnUnlockCharUsePiece = "OnUnlockCharUsePiece"
EventID.OnAutoClaimWeaponBreakCollectReward = "OnAutoClaimWeaponBreakCollectReward"
EventID.OnPetReddotRead = "OnPetReddotRead"
EventID.OnMVPSequenceFinish = "OnMVPSequenceFinish"


--角色外观
EventID.OnCharShowPartMesh = "OnCharShowPartMesh"
EventID.OnCharCornerVisibilityChanged = "OnCharCornerVisibilityChanged"
EventID.OnCharAppearanceChanged = "OnCharAppearanceChanged"
EventID.OnCharAccessorySetted = "OnCharAccessorySetted"
EventID.OnCharAccessoryRemoved = "OnCharAccessoryRemoved"
EventID.OnCharSkinChanged = "OnCharSkinChanged"
EventID.OnCharHairChanged = "OnCharHairChanged"
EventID.OnCharColorsChanged = "OnCharColorsChanged"
EventID.OnCharHairColorsChanged = "OnCharHairColorsChanged"
EventID.OnCharAppearanSuitRenamed = "OnCharAppearanSuitRenamed"
EventID.OnCharSkinColorPlanChanged = "OnCharSkinColorPlanChanged"
EventID.OnCharHairColorPlanChanged = "OnCharHairColorPlanChanged"

--武器外观
EventID.OnWeaponColorsChanged = "OnWeaponColorsChanged"
EventID.OnWeaponSkinChanged = "OnWeaponSkinChanged"
EventID.OnWeaponAccessoryChanged = "OnWeaponAccessoryChanged"
EventID.OnWeaponAppearanSuitRenamed = "OnWeaponAppearanSuitRenamed"
EventID.OnShowWeaponLoadFinished = "OnShowWeaponLoadFinished"
EventID.OnWeaponSkinColorPlanChanged = "OnWeaponSkinColorPlanChanged"

--战斗轮盘
EventID.OnChangeWheel = "OnChangeWheel"
EventID.OnExchangeBattleWheel = "OnExchangeBattleWheel"
EventID.OnChangeBattleWheel = "OnChangeBattleWheel"
EventID.OnTakeOffBattleWheel = "OnTakeOffBattleWheel"
EventID.OnEquipAssisterWeapon = "OnEquipAssisterWeapon"
EventID.OnTakeOffAssisterWeapon = "OnTakeOffAssisterWeapon"
EventID.OnRefreshBattleWheelEnableState = "OnRefreshBattleWheelEnableState"
EventID.OnPropChangeWheels = "OnPropChangeWheels"
EventID.OnDisplayIndexChanged = "OnDisplayIndexChanged"
EventID.OnWheelNameChanged = "OnWheelNameChanged"
EventID.OnWheelItemCleared = "OnWheelItemCleared"


--升级突破
EventID.OnWeaponLevelUp="OnWeaponLevelUp"
EventID.OnWeaponBreakLevelUp = "OnWeaponBreakLevelUp"
EventID.OnCharLevelUp="OnCharLevelUp"
EventID.OnCharBreakLevelUp = "OnCharBreakLevelUp"
EventID.OnCharLevelUpInBattle="OnCharLevelUpInBattle"
EventID.OnCharGradeLevelUp = "OnCharGradeLevelUp"
EventID.OnCharExtraGradeLevelUp = "OnCharExtraGradeLevelUp"
EventID.OnCharExtraGradeItemClick = "OnCharExtraGradeItemClick"
EventID.OnCharSkillLevelUp = "OnCharSkillLevelUp"
EventID.OnCharSkillTreeNodeActivated = "OnCharSkillTreeNodeActivated"
EventID.OnPlayerLevelUp = "OnPlayerLevelUp" -- 和鸣等级提升
EventID.OnWeaponGradeLevelUp = "OnWeaponGradeLevelUp"
EventID.OnPetBreakLevelUp = "OnPetBreakLevelUp"
EventID.OnPetAddExp = "OnPetAddExp"
EventID.PetAddExpMulti = "PetAddExpMulti"
EventID.OnPetLocked = "OnPetLocked"
EventID.OnPetNameChanged = "OnPetNameChanged"
EventID.OnPetEntryReplace = "OnPetEntryReplace"
EventID.OnPetEntryUp = "OnPetEntryUp"

-- 副本
EventID.OnReceiveTask="OnReceiveTask"
EventID.OnDungeonTaskProgress = "OnDungeonTaskProgress"
EventID.OnMatchStateChanged="OnMatchStateChanged"
EventID.OnWaveStart = "OnWaveStart"
EventID.OnWaveEnd = "OnWaveEnd"
EventID.OnDungeonUIInfoUpdated = "OnDungeonUIInfoUpdated"
EventID.OnDungeonUIStateUpdated = "OnDungeonUIStateUpdated"
EventID.ShowDungeonUI = "ShowDungeonUI"
EventID.CloseDungeonUI = "CloseDungeonUI"
EventID.OnRepSabotageCountDownTime = "OnRepSabotageCountDownTime"
EventID.OnDungeonVoteBegin="OnDungeonVoteBegin"
EventID.OnRepDungeonVoteInterval="OnRepDungeonVoteInterval"
EventID.UpdateVotePlayerActiveState = "UpdateVotePlayerActiveState"
EventID.OnUpdateRewardProgress = "OnUpdateRewardProgress"
EventID.UpdateDungeonValues="UpdateDungeonValues"
EventID.OnExitDungeon = "OnExitDungeon"
EventID.OnDungeonOtherPlayerJoin = "OnDungeonOtherPlayerJoin"
EventID.OnDungeonOtherPlayerLeave = "OnDungeonOtherPlayerLeave"
EventID.OnRepDungeonProgress = "OnRepDungeonProgress"
EventID.OnNotifyClientToCloseLoading = "OnNotifyClientToCloseLoading"
EventID.OnEnableStory = "OnEnableStory"
EventID.OnDisableEscOnDungeonLoading = "OnDisableEscOnDungeonLoading"
EventID.OnRepBattleProgressNum = "OnRepBattleProgressNum"
EventID.OnRepBattleProgressInfo = "OnRepBattleProgressInfo"

EventID.TeamMatchStartEntering = "TeamMatchStartEntering"
EventID.TeamMatchStartMatching = "TeamMatchStartMatching"
EventID.TeamMatchOneRefused = "TeamMatchOneRefused"
EventID.TeamMatchCancel = "TeamMatchCancel"
EventID.TeamMatchTimingStart = "TeamMatchTimingStart"
EventID.TeamMatchTimingEnd = "TeamMatchTimingEnd"
EventID.OnMatchPrepareToBattle = "OnMatchPrepareToBattle"
EventID.OnRefreshDeputeBtn = "OnRefreshDeputeBtn"
EventID.TeamMatchSquadFold = "TeamMatchSquadFold"
EventID.TeamMatchSquadUnfold = "TeamMatchSquadUnfold"
EventID.OnRequestToMatch = "OnRequestToMatch"
EventID.OnAvatarLogout = "OnAvatarLogout"


-- 生存副本
EventID.OnReceiveSurvivalValue="OnReceiveSurvivalValue"
EventID.SetNpcShowHide="SetNpcShowHide"
EventID.SetNpcFlexibShowOrHideDynamic = "SetNpcFlexibShowOrHideDynamic"
EventID.SetCustomNpcFlexibShowOrHideDynamic = "SetCustomNpcFlexibShowOrHideDynamic"
EventID.SurvivalProBeginTutorial = "SurvivalProBeginTutorial"
EventID.SurvivalProFinishTutorial = "SurvivalProFinishTutorial"
EventID.SurvivalProSurpossedLeave = "SurvivalProSurpossedLeave"
EventID.OnRepSurvivalTime="OnRepSurvivalTime"
EventID.OnRepSurvivalValue="OnRepSurvivalValue"
EventID.OnRepEnergySupplyCount="OnRepEnergySupplyCount"
EventID.OnPoisonMonsterDead = "OnPoisonMonsterDead"

-- 生存Mini
EventID.OnRepSurvivalMiniValue = "OnRepSurvivalMiniValue"
EventID.OnSurvivalMiniValueMax = "OnSurvivalMiniValueMax"

-- 防御副本
EventID.OnDefenseWaveStart="OnDefenseWaveStart"
EventID.OnDefenceWaveEnd="OnDefenceWaveEnd"
EventID.DefenseTimerAdded="DefenseTimerAdded"
EventID.OnPoisonMonsterBorn = "OnPoisonMonsterBorn"

-- 挖掘副本
EventID.OnExcavationItemChange = "OnExcavationItemChange"
EventID.OnExcavationFinish = "OnExcavationFinish"
EventID.OnAttractBattery = "OnAttractBattery"
EventID.OnExcavationGetReward = "OnExcavationGetReward"

--歼灭副本
EventID.OnRepExterminateKilledNum = "OnRepExterminateKilledNum"

--角色试玩关卡
EventID.OnRepTrialKilledNum = "OnRepTrialKilledNum"

-- 捕获副本
EventID.OnRepCaptureRecoveryTime = "OnRepCaptureRecoveryTime"

-- 神庙副本
EventID.OnSetTempleLimit = "OnSetTempleLimit"
EventID.OnTempleTimeChanged = "OnTempleTimeChanged"
EventID.OnTempleScoreCollectChanged = "OnTempleScoreCollectChanged"
EventID.OnTempleDeathFallChanged = "OnTempleDeathFallChanged"
EventID.OnTempleEnter = "OnTempleEnter"
EventID.OnTempleDelayStart = "OnTempleDelayStart"
EventID.OnTempleDelayEnd = "OnTempleDelayEnd"
EventID.OnSpawnTempleBomb = "OnSpawnTempleBomb"
EventID.OnPlayerGetAttachBomb = "OnPlayerGetAttachBomb"
EventID.OnPlayerEndAttachBomb = "OnPlayerEndAttachBomb"
EventID.OnTempleRightUI = "OnTempleRightUI"
EventID.OnTempleSmeltChangeBlue = "OnTempleSmeltChangeBlue"
EventID.OnTempleCageEnterDown = "OnTempleCageEnterDown"
EventID.OnNoticeCageUp = "OnNoticeCageUp"
EventID.OnTempleTipButtonShow = "OnTempleTipButtonShow"

-- 派对副本
EventID.OnUpdatePartyLeftUI = "OnUpdatePartyLeftUI"
EventID.OnUpdatePartyRightUI = "OnUpdatePartyRightUI"
EventID.OnPartyProgressStart = "OnPartyProgressStart"  -- 多人派对竞速UI加载
EventID.OnPartyProgressUpdate = "OnPartyProgressUpdate"  -- 多人派对竞速UI进度更新
EventID.OnPartyPlayerGetBuff = "OnPartyPlayerGetBuff"  -- 多人派对竞速玩家获得buff
EventID.OnPlayerEnterToExit = "OnPlayerEnterToExit"    --多人派对有玩家到了撤离点
EventID.OnOnePlayerEnd = "OnOnePlayerEnd"              --多人派对有玩家到了撤离点，这个可以拿到那个玩家的Eid
EventID.OnPartyPlayerTriggerFallTrigger = "OnPartyPlayerTriggerFallTrigger" --派对有玩家触发FallTrigger
EventID.OnPlayerGetDeBuff = "OnPlayerGetDeBuff"        --多人派对有玩家吃到了buff，可以获得BuffId, 持续时间，Eid

-- 救援副本
EventID.OnRepRescueCountDownTime = "OnRepRescueCountDownTime"
EventID.UpdateHostageDyingCountDown = "UpdateHostageDyingCountDown"
EventID.NotifyClientChangeHostageInvincible = "NotifyClientChangeHostageInvincible"

-- 肉鸽副本
EventID.OnRepRougeBattleCount = "OnRepRougeBattleCount"
EventID.OnGetAwardUIClose = "OnGetAwardUIClose"
EventID.OnRougeDealEventReward = "OnRougeDealEventReward"

-- 大秘境
EventID.OnRepAbyssBattleCount = "OnRepAbyssBattleCount"
EventID.OnCurrentAbyssSeasonIdChange = "OnCurrentAbyssSeasonIdChange"
EventID.OnAbyssSeasonEnd = "OnAbyssSeasonEnd"

-- 多点破坏
EventID.OnRepHitSwitchTimer = "OnRepHitSwitchTimer"

-- 新周本
EventID.OnRepSynthesisRageValue = "OnRepSynthesisRageValue"
EventID.OnRepGuideSupervisorEids = "OnRepGuideSupervisorEids"
EventID.OnRepDeadSupervisorEids = "OnRepDeadSupervisorEids"
EventID.OnRepKeySubmitNum = "OnRepKeySubmitNum"
EventID.OnTeleportReady = "OnTeleportReady"

-- 周本Ⅱ
EventID.OnStartChargeGame = "OnStartChargeGame"
EventID.OnEndChargeGame = "OnEndChargeGame"
EventID.OnChargeTimeUp = "OnChargeTimeUp"
EventID.OnSynthesisEnergyValueChange = "OnSynthesisEnergyValueChange"

-- 菲娜活动
EventID.OnRepFeinaStar = "OnRepFeinaStar"

-- 积分UI
EventID.UpdateRankStarScore = "UpdateRankStarScore"

--血条、护盾、蓝量、韧性
EventID.ShowBossBlood="ShowBossBlood"
-- EventID.ShowMainPlayerBlood="ShowMainPlayerBlood"
EventID.RefreshMainPlayerBlood = "RefreshMainPlayerBlood" -- 不带扣血动效
EventID.UpdateMainPlayerSp="UpdateMainPlayerSp"
EventID.UpdateMainPlayerMaxSp="UpdateMainPlayerMaxSp"
EventID.UpdateSkillEfficiency="UpdateSkillEfficiency"
EventID.TriggerAddSpAnim="TriggerAddSpAnim"
EventID.UpdateBossToughness = "UpdateBossToughness"
EventID.RecoveryBossShield = "RecoveryBossShield"
EventID.OnUpdateCharExp = "OnUpdateCharExp"
EventID.OnUpdateMonsterDamages = "OnUpdateMonsterDamages"
EventID.OnShowMainPlayerHealEvent = "OnShowMainPlayerHealEvent"
EventID.ShowTeammateBloodUI = "ShowTeammateBloodUI"
EventID.CloseTeammateBloodUI = "CloseTeammateBloodUI"
EventID.OnUpdateSummonHp = "OnUpdateSummonHp"
EventID.MainPlayerLevelUp = "MainPlayerLevelUp"
-- EventID.PlayerRecoveryStateChange = "PlayerRecoveryStateChange"
EventID.ShowOrHideMainPlayerBloodUI = "ShowOrHideMainPlayerBloodUI"
EventID.UpdateMainPlayerSecondSp = "UpdateMainPlayerSecondSp"
EventID.UpdateMainPlayerMaxSecondSp = "UpdateMainPlayerMaxSecondSp"
EventID.OnBuffSpModify = "OnBuffSpModify"
EventID.OnBloodEnergyChanged = "OnBloodEnergyChanged"
EventID.UpdateDamageRate = "UpdateDamageRate"
EventID.DoubleBossChargeTextUpdate = "DoubleBossChargeTextUpdate"       --执律阁机关充能文字更新
EventID.OnMultiHpBarLayerChange = "OnMultiHpBarLayerChange"

--准星相关
EventID.ReloadStart="ReloadStart"
EventID.ReloadEnd="ReloadEnd"
EventID.ReloadStop="ReloadStop"
EventID.OnCharForbidWeapon="OnCharForbidWeapon"

--连击数&弹药数
EventID.OutOfBullet = "OutOfBullet"
EventID.FullOfMagazine = "FullOfMagazine"
EventID.UpdateCurLevelProcess = "UpdateCurLevelProcess"
EventID.OnRepBulletNum = "OnRepBulletNum"

--背包
EventID.OnUpdateBagItem = "OnUpdateBagItem"
EventID.OnAddBagItemToList = "OnAddBagItemToList"
EventID.OnRemoveBagItemInList = "OnRemoveBagItemInList"

--核桃背包
EventID.OnUpdateWalnutItem = "OnUpdateWalnutItem"
EventID.OnAddWalnutItemToList = "OnAddWalnutItemToList"
EventID.OnRemoveWalnutItemInList = "OnRemoveWalnutItemInList"

--活动相关
EventID.OnUpdateActivityEvent = "OnUpdateActivityEvent"
EventID.OnMidTermTaskComplete = "OnMidTermTaskComplete"
EventID.OnMidTermTaskProgressChange = "OnMidTermTaskProgressChange"
EventID.OnActivityTimeOpen = "OnActivityTimeOpen"    --活动开始
EventID.OnActivityTimeOpenClose = "OnActivityTimeOpenClose" --活动结束
EventID.OnActivityComplete = "OnActivityComplete" --活动完成

--锻造
EventID.OnStartProduce = "OnStartProduce"
EventID.OnCompleteProduce = "OnCompleteProduce"
EventID.OnCompleteBatchProduce = "OnCompleteBatchProduce"
EventID.OnAccerateProduce = "OnAccerateProduce"
EventID.OnCancelProduce = "OnCancelProduce"
EventID.OnBlueComplete = "OnBlueComplete"
EventID.OnGetNewDraft = "OnGetNewDraft"

--指令
EventID.SetDefaultWeapon="SetDefaultWeapon"
EventID.SupportSkillForChangeRole="SupportSkillForChangeRole"

--对话、剧情
EventID.StartTalk = "StartTalk"
EventID.EndTalk = "EndTalk"
EventID.PauseTalk = "PauseTalk"
EventID.ResumeTalk = "ResumeTalk"
EventID.PauseQTE="PauseQTE"
EventID.ResumeQTE = "ResumeQTEc"
EventID.TalkPauseGame = "TalkPauseGame"
EventID.TalkResumeGame = "TalkResumeGame"
EventID.TalkEnableMonsterSpawn = "TalkEnableMonsterSpawn"
EventID.TalkHiddenGameUI = "TalkHiddenGameUI"
EventID.OnNpcPoseChange = "OnNpcPoseChange"
EventID.OnImprTalkTriggerComplete = "OnImprTalkTriggerComplete"
EventID.OnTalkTriggerComplete = "OnTalkTriggerComplete"
EventID.EnterImmersiveTalk = "EnterImmersiveTalk"
EventID.LeaveImmersiveTalk = "LeaveImmersiveTalk"
EventID.TriggerFlexibleActive = "TriggerFlexibleActive"
EventID.OnStoryVarUpdated = "OnStoryVarUpdated"

--肉鸽对话
EventID.OnRougeDisplayDialogue = "OnRougeDisplayDialogue"
EventID.OnRougeDisplayOptions = "OnRougeDisplayOptions"
EventID.OnRougeIteratorDialogue = "OnRougeIteratorDialogue"
EventID.OnRougeChooseOption = "OnRougeChooseOption"
EventID.OnRougeEventGetToken = "OnRougeEventGetToken"
EventID.OnRougeLikeStoryEventEnd = "OnRougeLikeStoryEventEnd"
EventID.CloseFromRougeArchive = "CloseFromRougeArchive"
EventID.CloseFromArchiveStory = "CloseFromArchiveStory"

--肉鸽商城
EventID.OnRougeShopItemSelect = "OnRougeShopItemSelect"
EventID.OnRougeInfoUpdate = "OnRougeInfoUpdate"

--肉鸽结算
EventID.OnRougeSettlementBoxItemFocused = "OnRougeSettlementBoxItemFocused"
EventID.OnRougeSettlementBoxItemMenuChanged = "OnRougeSettlementBoxItemMenuChanged"

--相机
EventID.OnCameraSpringArmInput = "OnCameraSpringArmInput"
EventID.OnCurveCameraStartMove = "OnCurveCameraStartMove"
EventID.OnSelectWeapon = "OnSelectWeapon"
EventID.OnLockOnButtonShowChanged = "OnLockOnButtonShowChanged"
EventID.OnCameraLockOnChanged = "OnCameraLockOnChanged"
EventID.OnShootCameraDistanceOptionChanged = "OnShootCameraDistanceOptionChanged"

--拍照
EventID.OnScreenshotToken = "OnScreenshotToken"
EventID.OnInitScreenshotParams = "OnInitScreenshotParams"

-- GameState计时相关
EventID.OnGameStateTimerAdded = "OnGameStateTimerAdded"
EventID.OnGameStateTimerEnded = "OnGameStateTimerEnded"
       
-- 角色初始化
EventID.OnMainCharacterBeginPlay = "OnMainCharacterBeginPlay"
EventID.OnCharacterInitReady = "OnCharacterInitReady"
EventID.OnMainCharacterInitReady = "OnMainCharacterInitReady"
EventID.OnBattlePetInitReady = "OnBattlePetInitReady"
EventID.OnPhantomInitReady = "OnPhantomInitReady"

--成就进度
EventID.OnAchvHyperlinkClick = 'OnAchvHyperlinkClick'
EventID.OnGetAchvReward = 'OnGetAchvReward'
EventID.OnAchvRedPoint = 'OnAchvRedPoint'
EventID.OnAchvFinished = 'OnAchvFinished'
EventID.GetAchvRewardCallBack = 'GetAchvRewardCallBack'

-- Mod手册
EventID.OnModBookQuestFinished = "OnModBookQuestFinished"

-- 角色技能相关
EventID.OnCharCallSummoner = "OnCharCallSummoner"
EventID.OnCharRemoveSummoner = "OnCharRemoveSummoner"
EventID.OnSkillInActive = "OnSkillInActive"
EventID.OnSkillActive = "OnSkillActive"
EventID.OnSkillInfosRep = "OnSkillInfosRep"
EventID.OnSkill1InAirChanged= "OnSkill1InAirChanged"
EventID.OnSkill2InAirChanged= "OnSkill2InAirChanged"

-- 机关
EventID.OnItemPickedUp = "OnItemPickedUp"
EventID.OnResourceDeductSuccess = "OnResourceDeductSuccess"
EventID.OnMiniGameCreated = "OnMiniGameCreated"
EventID.OnMechanismEnterState = "OnMechanismEnterState"
EventID.OnOpenMechanism = "OnOpenMechanism"
EventID.OnMobileHookShow = "OnMobileHookShow"

EventID.OnPlayerGetResource = "OnPlayerGetResource"

-- 转圈圈小游戏
EventID.CircleAroundGameStart = "CircleAroundGameStart"
EventID.CircleAroundTryToTriggerPointer = "CircleAroundTryToTriggerPointer"
EventID.CircleAroundGameSuccess = "CircleAroundGameSuccess"
EventID.CircleAroundGameFailed = "CircleAroundGameFailed"

--钓鱼
EventID.OnFishHook = "OnFishHook"

-- 扶疏幻境机关
EventID.OnFlowerLanternActive = "OnFlowerLanternActive"
EventID.OnFlowerLanternDeActive = "OnFlowerLanternDeActive"
EventID.OnKongmingLanternBreak = "OnKongmingLanternBreak"
EventID.OnMonsterAlive = "OnMonsterAlive"
EventID.OnMonsterClear = "OnMonsterClear"

-- 东国机关
EventID.OnRingRockFinish = "OnRingRockFinish"

-- UI创建相关
EventID.LoadUI = "LoadUI"
EventID.UnLoadUI = "UnLoadUI"
EventID.OnAddWidgetComponent = "OnAddWidgetComponent"

-- 倒计时
EventID.OnNotifyShowLargeCountDown = "OnNotifyShowLargeCountDown"
EventID.OnNotifyCommonCountDown = "OnNotifyCommonCountDown"

-- EnergySupplyWidget创建
EventID.OnCreatedEnergySupplyWidget = "OnCreatedEnergySupplyWidget"

-- 技能特写
EventID.OnStartSkillFeature = "OnStartSkillFeature"
EventID.OnEndSkillFeature = "OnEndSkillFeature"

--通用
EventID.OnMenuClose = "OnMenuClose"

--探索组
EventID.OnExploreGroupDeactive = "OnExploreGroupDeactive"
EventID.OnExploreGroupActive = "OnExploreGroupActive"
EventID.OnExploreGroupSpecialActive = "OnExploreGroupSpecialActive"
EventID.OnExploreGroupComplete = "OnExploreGroupComplete"
EventID.OnExploreGroupReset = "OnExploreGroupReset"
EventID.OnExploreGroupLimitComplete = "OnExploreGroupLimitComplete"

--电梯
EventID.ElevatorMechanismCompleteNotify = "ElevatorMechanismCompleteNotify"

--序章选角色
EventID.OnSelectRole = "OnSelectRole"
EventID.OnSelectFinish = "OnSelectFinish"
EventID.OnSelectRoleUIOpen = "OnSelectRoleUIOpen"

--小地图
EventID.ShowDropInMinimap = "ShowDropInMinimap"
EventID.ShowRangedIconInMinimap = "ShowRangedIconInMinimap"
EventID.EnterOrExitFloor = "EnterOrExitFloor"
EventID.OnArtLevelLoadedStateChange = "OnArtLevelLoadedStateChange"
EventID.UpdateMapMark = "UpdateMapMark"
EventID.OnDeliveryMeshanismOpen = "OnDeliveryMeshanismOpen"
EventID.OnCommonTrack = "OnCommonTrack"
EventID.OnHostageDeadUpdateMiniMap = "OnHostageDeadUpdateMiniMap"
-- EventID.ChangePhantomMiniMapIcon = "ChangePhantomMiniMapIcon"
EventID.UpdateDoorIcon = 'UpdateDoorIcon'

-- 区域
EventID.OnCharacterInitSuitRecover = "OnCharacterInitSuitRecover"
EventID.OnLevelDeliverBlackCurtainStart = "OnLevelDeliverBlackCurtainStart"
EventID.OnLevelDeliverBlackCurtainEnd = "OnLevelDeliverBlackCurtainEnd"
EventID.OnSkipRegion = "OnSkipRegion"
EventID.OnRegionLoaded = "OnRegionLoaded"
EventID.OnArtLevelLoaded = "OnArtLevelLoaded"

--区域联机
EventID.ChangeRegionOnline = "ChangeRegionOnline"

-- CharacterTag
EventID.OnCharacterTagChanged = "OnCharacterTagChanged"

--系统解锁
EventID.OnSystemUnlockEnding = "OnSystemUnlockEnding"
EventID.OnSystemUnlockWorkingStart = "OnSystemUnlockWorkingStart"
EventID.OnSystemUnlockWorkingEnd = "OnSystemUnlockWorkingEnd"

--系统入口
EventID.OnHomeBaseBtnPlayAnim = "OnHomeBaseBtnPlayAnim"

EventID.EnterRegion = "EnterRegion"
EventID.ExitRegion = "ExitRegion"
--SystemGuide
EventID.SystemGuideEnterRegion = "SystemGuideEnterRegion"
EventID.SystemGuideExitRegion = "SystemGuideExitRegion"
EventID.SystemGuideEnterDungeon = "SystemGuideEnterDungeon"
EventID.SystemGuideExitDungeon = "SystemGuideExitDungeon"
EventID.QuestFinished = "QuestFinished"
EventID.QuestChainFinished = "QuestChainFinished"
EventID.SetInputMode = "SetInputMode"
EventID.ImpressionTalk = "ImpressionTalk"
EventID.TalkComp = "TalkComp"
EventID.FirstSeenTag = "FirstSeenTag"
EventID.QuestStart = "QuestStart"
EventID.FirstDynQuest="FirstDynQuest"
EventID.OnGuideStart = "OnGuideStart"
EventID.OnGuideEnd = "OnGuideEnd"
EventID.OnBecomeViewTarget = "OnBecomeViewTarget"
EventID.OnEndViewTarget = "OnEndViewTarget"

--Skill Toast Animation
EventID.ShowSkillAnim  = "ShowSkillAnim"
EventID.HideSkillAnim  = "HideSkillAnim"

--Resource同步
EventID.OnPropSetResources = "OnPropSetResources"

--Condition条件完成
EventID.ConditionComplete = "ConditionComplete"

--AvatarStatus改变
EventID.OnAvatarStatusUpdate = "OnAvatarStatusUpdate"

EventID.SetPlayerLocWithLoadLevel = "SetPlayerLocWithLoadLevel"

-- 指引UI相关
EventID.MoveAroundGesture = "MoveAroundGesture"
EventID.ZoomInOutGesture = "ZoomInOutGesture"
EventID.ChangePhantomGuideState = "ChangePhantomGuideState"
EventID.ChangePhantomRecoverCount = "ChangePhantomRecoverCount"
EventID.RecycleClassToCachePool = "RecycleClassToCachePool"
EventID.UpdateMiniMap = "UpdateMiniMap"
EventID.ResetNpcMiniMap = "ResetNpcMiniMap"
EventID.TriggerHostageVisibility = "TriggerHostageVisibility"
EventID.TriggerHostageGuideLoop = "TriggerHostageGuideLoop"
EventID.TriggerHostageBattleMapChangeStyle = "TriggerHostageBattleMapChangeStyle"
EventID.OnChangeTaskIndicator = "OnChangeTaskIndicator"
EventID.OnChangePointOrRangeTaskIndicator = "OnChangePointOrRangeTaskIndicator"
EventID.EdgeFalltrigerChangeOverlapState = "EdgeFalltrigerChangeOverlapState"
EventID.ChangeIndicatorFloorStyle = "ChangeIndicatorFloorStyle"
EventID.PlayLoopAnimAfterBarAnim = "PlayLoopAnimAfterBarAnim"
EventID.HideNpcSideIndicator = "HideNpcSideIndicator"
EventID.AddRegionIndicatorInfo = "AddRegionIndicatorInfo"
EventID.RemoveRegionIndicatorInfo = "RemoveRegionIndicatorInfo"
EventID.EnableNpcSideBubble = "EnableNpcSideBubble"
EventID.OnMissiongIndicatorFloorLevelChange = "OnMissiongIndicatorFloorLevelChange"

-- 主线任务追踪
EventID.OnSetQuestTracking = "OnSetQuestTracking"
EventID.OnCancelQuestTracking = "OnCancelQuestTracking"
EventID.OnSelectQuestSubItem = "OnSelectQuestSubItem"
EventID.OnChangeTaskSubRegion = "OnChangeTaskSubRegion"
EventID.OnUpdateQuestChain = "OnUpdateQuestChain"
EventID.OnCompleteQuestChain = "OnCompleteQuestChain"  -- 任务链完成
EventID.CheckShowMap = "CheckShowMap"
EventID.OnCalcVarChange = "OnCalcVarChange"

-- 特殊任务
EventID.OnSpecialQuestFail = "OnSpecialQuestFail"
EventID.OnNpcEnterOrQuitSpecialQuest = "OnNpcEnterOrQuitSpecialQuest"
EventID.SpecialQuestOpenRegionOnline = "SpecialQuestOpenRegionOnline"
EventID.SpecialQuestCloseRegionOnline = "SpecialQuestCloseRegionOnline"

-- 完成副本
EventID.OnGameModeComplete = "OnGameModeComplete"

-- UI事件
EventID.CloseLoading = "CloseLoading"
EventID.InLoading = "InLoading"
EventID.OnJumpToPage = "OnJumpToPage"
EventID.OnJumpBackToPage = "OnJumpBackToPage"
EventID.OnUIPauseGame = "OnUIPauseGame"
EventID.OnHudRewardClose = "OnHudRewardClose"
EventID.OnHideAllComponentUI = "OnHideAllComponentUI"
EventID.OnToggleDisconnectUI = "OnToggleDisconnectUI"

-- 肉鸽玩法相关
EventID.OnRougeLikeEnterRoom = "OnRougeLikeEnterRoom"
EventID.OnRougeLikeInfoUpdate = "OnRougeLikeInfoUpdate"
EventID.StartRougeCanonMiniGame = "StartRougeCanonMiniGame"
EventID.EndRougeCanonMiniGame = "EndRougeCanonMiniGame"

-- 炮台活动
EventID.CanonBegionCountFinish = "CanonBegionCountFinish"
EventID.StartCanonMiniGame = "StartCanonMiniGame"
EventID.EndCanonMiniGame = "EndCanonMiniGame"
EventID.OnCanonScoreAdd = "OnCanonScoreAdd"

-- 监听特定行为的按下
EventID.OnSkill1Pressed = "OnSkill1Pressed"
EventID.OnSkill2Pressed = "OnSkill2Pressed"
EventID.OnSkill3Pressed = "OnSkill3Pressed"
EventID.OnAttackPressed = "OnAttackPressed"
EventID.OnJumpPressed = "OnJumpPressed"
EventID.OnBulletJumpStarted = "OnBulletJumpStarted"
EventID.OnSlidePressed = "OnSlidePressed"
EventID.OnFirePressed = "OnFirePressed"
EventID.OnFireRelease = "OnFireRelease"
EventID.OnAvoidPressed = "OnAvoidPressed"
EventID.OnHeavyAttackPressed = "OnHeavyAttackPressed"
EventID.OnChargeBulletPressed = "OnChargeBulletPressed"
EventID.OnShowCursorPressed = "OnShowCursorPressed"
EventID.OnInteractivePressed = "OnInteractivePressed"
EventID.OnFallAttackPressed = "OnFallAttackPressed"
EventID.OnSlideAttackPressed = "OnSlideAttackPressed"

-- 触发盒
EventID.OnEnterTriggerBox = "OnEnterTriggerBox" -- 触发盒被激活
EventID.OnLeaveTriggerBox = "OnLeaveTriggerBox" -- 触发盒被激活

-- 平台游戏进程相关事件
EventID.ApplicationWillEnterBackground = "ApplicationWillEnterBackground" --游戏进程切后台
EventID.ApplicationHasEnteredForeground = "ApplicationHasEnteredForeground" --游戏进程切前台
EventID.ApplicationWillDeactivate = "ApplicationWillDeactivate" --游戏进程停用
EventID.ApplicationHasReactivated = "ApplicationHasReactivated" --游戏进程启用

-- 商城
EventID.OnPurchaseShopItemSuccess = "OnPurchaseShopItemSuccess"  --购买单件商品成功
EventID.OnPurchaseShopItem = "OnPurchaseShopItem" --购买通知，无论是否成功
EventID.OnRechargeFinished = "OnRechargeFinished"  --充值完成，无论是否成功
EventID.RefreshShop = "RefreshShop"                 -- 刷新商城

-- 分辨率设置
EventID.OnWindowResized = "OnWindowResized"
EventID.OnWindowMoved = "OnWindowMoved"

-- ChangeRole
EventID.ChangeRole = "ChangeRole"

-- BuffChange
EventID.OnBuffChange = "OnBuffChange"

-- PropEffect
EventID.OnPropEffectReplaceSkill = "OnPropEffectReplaceSkill"
EventID.OnPropEffectEndReplaceSkill = "OnPropEffectEndReplaceSkill"
EventID.OnSwitchOnCannonProp = "OnSwitchOnCannonProp"
EventID.OnSwitchOffCannonProp = "OnSwitchOffCannonProp"
EventID.OnSWSCannonFired = "OnSWSCannonFired"
EventID.OnSWSCannonInCD = "OnSWSCannonInCD"

-- 死亡复活相关
-- 角色死亡，IsDead为true
---@param Eid number 角色Eid
EventID.CharDie = "CharDie" 

--主控角色受击事件
EventID.MainPlayerBeAttacked = "MainPlayerBeAttacked" 


-- 角色复活，IsDead为false
---@param Eid number 角色Eid
EventID.CharRecover = "CharRecover" 

-- 玩家复活状态改变
---@param Eid number 角色Eid
---@param State ETeamRecoveryState 当前复活状态
---@param PrevState ETeamRecoveryState 上一个复活状态
EventID.OnTeamRecoveryStateChange = "OnTeamRecoveryStateChange" 

-- 玩家复活速度发生改变
---@param Eid number 角色Eid
---@param RecoverySpeed number 当前复活速度
---@param PrevSpeed number 上一个复活速度
EventID.OnTeamRecoverySpeedChanged = "OnTeamRecoverySpeedChanged" 

-- 魅影濒死倒计时发生改变
---@param DyingDuration number 当前濒死倒计时
EventID.OnRepPhantomDyingDuration = "OnRepPhantomDyingDuration"

-- 魅影复活进度发生改变
---@param RecoveryValue number 当前复活进度
EventID.OnRepPhantomRecoveryValue = "OnRepPhantomRecoveryValue"

-- 初始化
EventID.OnBattleReady = "OnBattleReady"

-- GM指令
EventID.ServerGMSucceed = "ServerGMSucceed"

-- 接了MVC的模块
EventID.TeamControllerEvent = "TeamControllerEvent"
EventID.ChatControllerEvent = "ChatControllerEvent"
EventID.ActivityControllerEvent = "ActivityControllerEvent"
EventID.FriendControllerEvent = "FriendControllerEvent"
EventID.WalnutBagControllerEvent = "WalnutBagControllerEvent"
EventID.WikiControllerEvent = "WikiControllerEvent"
EventID.BagGameControllerEvent = "BagGameControllerEvent"
EventID.ModControllerEvent = "ModControllerEvent"
EventID.PersonInfoControllerEvent = "PersonInfoControllerEvent"
EventID.MonthCardControllerEvent = "MonthCardControllerEvent"
EventID.GiftControllerEvent = "GiftControllerEvent"
EventID.DailyTalkControllerEvent = "DailyTalkControllerEvent"
EventID.GachaControllerEvent = "GachaControllerEvent"
EventID.RegionFameControllerEvent = "RegionFameControllerEvent"

-- 声望
EventID.GetReputationExp = "GetReputationExp"
EventID.RecurringQuestTimeOut = "RecurringQuestTimeOut"
EventID.RegionReputationsChange = "RegionReputationsChange"

--聊天
EventID.OpenChatView = "OpenChatView"
EventID.InterruptChatView = "InterruptChatView"
EventID.ComfirmDisturbClick="ComfirmDisturbClick"

---GameViewportInput
EventID.GameViewportInputKeyPressed = "GameViewportInputKeyPressed"
EventID.GameViewportInputKeyReleased = "GameViewportInputKeyReleased"
EventID.GameViewportInputKeyLongPressed = "GameViewportInputKeyLongPressed"
EventID.GameViewportSizeChanged = "GameViewportSizeChanged"

-- 委托密函AllDailyProgressRewardChange
EventID.OnSelectWalnut = "OnSelectWalnut"
EventID.OnSelectWalnutReward = "OnSelectWalnutReward"
EventID.SelectWalnut = "SelectWalnut"                       --开始选择核桃
EventID.SelectedWalnut = "SelectedWalnut"                   --选择核桃结束
EventID.TeamSelectWalnut = "TeamSelectWalnut"               --队伍中有人选择了核桃
EventID.WalnutSelectComplete = "WalnutSelectComplete"       --队伍中全部选择核桃完成
EventID.InterruptWalnutSelect = "InterruptWalnutSelect"     --中断选择核桃
EventID.OnDungeonWalnutChoiceUIOpen = "OnDungeonWalnutChoiceUIOpen" --局内核桃选择UI打开

EventID.SelectTicket = "SelectTicket"                       --开始选择门票
EventID.DungeonSelectTicketEnd = "DungeonSelectTicketEnd"   --所有人都选完门票
EventID.OnSelectTicketTimeout = "OnSelectTicketTimeout"     --轮次投票后选门票超时

EventID.SettlementSelectWalnut = "SettlementSelectWalnut"   --结算临时小队有人选择了核桃

--派遣 
EventID.StartDispatch = "StartDispatch"
EventID.CancelDispatch = "CancelDispatch"
EventID.CompleteDispatch = "CompleteDispatch"
EventID.GetAllDispatchReward = "GetAllDispatchReward"
EventID.ChangeDispatchItem = "ChangeDispatchItem"
EventID.OnDispatchOverdate = "OnDispatchOverdate"
EventID.GoToDispatch = "GoToDispatch"
EventID.OnDispatchExistingComplete = "OnDispatchExistingComplete"
EventID.OnDispatchComplete = "OnDispatchComplete"
EventID.OnDispatchListCoolingComplete = "OnDispatchListCoolingComplete"
EventID.OnActiveDynamicQuest = "OnActiveDynamicQuest"

--GameState
EventID.OnDelPlayerState = "OnDelPlayerState"
EventID.OnDelPhantomState = "OnDelPhantomState"
EventID.OnRepEidPlayerState = "OnRepEidPlayerState"
EventID.OnRepPlayerName = "OnRepPlayerName"
EventID.OnRepOwnerEidPhantomState = "OnRepOwnerEidPhantomState"

--定时刷新
EventID.OnHourlyRefresh = "OnHourlyRefresh"
EventID.OnDailyRefresh = "OnDailyRefresh"
EventID.OnWeeklyRefresh = "OnWeeklyRefresh"
EventID.OnMonthlyRefresh = "OnMonthlyRefresh"

--委托刷新通知
EventID.OnDungeonsUpdate = "OnDungeonsUpdate"

--切换门的状态
EventID.OnDoorStateChange = "OnDoorStateChange"

--剧情回顾
EventID.OnHoverVoice = "OnHoverVoice"
EventID.OnHoverOption = "OnHoverOption"

-- 网络中断
EventID.OnNetDisconnect = "OnNetDisconnect" -- 游戏中断线重连失败
EventID.OnConnectSuccess = "OnConnectSuccess"

-- 钢琴系统
EventID.ChangeSelectMusicScore = "ChangeSelectMusicScore"   -- 改变选中的MusicScore
EventID.ChangeStoredCustomBGM = "ChangeStoredCustomBGM"     -- 保存了新的CustomBGM
EventID.ChangePlayedMusicItem = "ChangePlayedMusicItem"     -- 改变钢琴系统播放的音乐
EventID.ChangeMusicItemNewState = "ChangeMusicItemNewState" -- MusicItem红点状态改变通知MusicScore

-- 战令系统
EventID.BattlePassTaskProgressChange = "BattlePassTaskProgressChange"   -- 战令任务进度改变
EventID.BattlePassLevelChange = "BattlePassLevelChange"   -- 战令等级改变
EventID.BattlePassRank2Unlock = "BattlePassRank2Unlock"   -- 战令Rank2解锁
EventID.BattlePassVersionChange = "BattlePassVersionChange"   -- 战令版本改变
EventID.BattlePassPetCanClaim = "BattlePassPetCanClaim"   -- 可领取魔灵
EventID.BattlePassPetClaimed = "BattlePassPetClaimed" -- 魔灵已领取
EventID.BattlePassBuySuccessNotify = "BattlePassBuySuccessNotify"   -- 战令支付成功
EventID.BattlePassAutoGetTaskReward = "BattlePassAutoGetTaskReward"   -- 已自动领取奖励
EventID.BattlePassPurchaseClose = "BattlePassPurchaseClose"   -- 战令购买关闭
EventID.BattlePassPetChange = "BattlePassPetChange"   -- 战令PET关闭
EventID.BattlePassSkinClose = "BattlePassSkinClose"   -- 战令模型预览关闭
EventID.BattlePassSkinPreviewClose = "BattlePassSkinPreviewClose"

--每日任务
EventID.DailyTaskRewardChange = "DailyTaskRewardChange"   -- 每日任务领取奖励状态改变
EventID.DailyProgressRewardChange = "DailyProgressRewardChange"   -- 每日任务总进度奖励领取状态改变

EventID.AllDailyTaskRewardChange = "AllDailyTaskRewardChange"   -- 每日任务全部领取奖励状态改变
EventID.AllDailyProgressRewardChange = "AllDailyProgressRewardChange"   -- 每日任务总进度奖励全部领取状态改变

EventID.DailyRefreshDailyTask = "DailyRefreshDailyTask"   -- 每日任务刷新

EventID.AllRewardDailyTask = "AllRewardDailyTask"   -- 每日任务一键领取所有奖励成功通知

EventID.AllDailyTaskRewardKey = "AllDailyTaskRewardKey"  --按键通知 空格键一键领取所有奖励
--委托阵容预设
EventID.CurrentSquadChange = "CurrentSquadChange"   --当前选中阵容变化

EventID.FoucsDungeonSelectLevel = "FoucsDungeonSelectLevel"   --聚焦到当前关卡item

EventID.EntryReceiveEnterState = "EntryReceiveEnterState" --Entry界面进入退出状态

EventID.DoubleModSwitchTab = "DoubleModSwitchTab"  --夜航手册活动tab切换

--夜航手册
EventID.NightBookSpecialRightUp = "NightBookSpecialRightUp"  --X键短按
--region 联机区域
EventID.OnlineRegionChange = "OnlineRegionChange" --联机区域进出状态变化，param1 OldState, Param2 NewState
--endregion
EventID.OnlineRegionNickNameChange = "OnlineRegionNickNameChange" --联机区域昵称变化，param1 Uid, ObjId
EventID.OnlineRegionTitleChange = "OnlineRegionTitleChange" --联机区域昵称变化，param1 Uid, ObjId
EventID.OnlineAddOtherPlayer = "OnlineAddOtherPlayer" -- 区域联机新增Player
EventID.OnlineRemoveOtherPlayer = "OnlineRemoveOtherPlayer" -- 区域联机删除Player

-- 支付相关
EventID.OnPayCallBack = "OnPayCallBack" -- 支付成功回调

-- 推理游戏
EventID.OnHomeBaseeBtnShowNewClue = "OnHomeBaseeBtnShowNewClue" -- 显示新线索
EventID.OnNewDetectiveQuestion = "OnNewDetectiveQuestion" -- 新推理问题
EventID.OnDetectiveRefreshProgress = "OnDetectiveRefreshProgress" -- 刷新进度

-- 剧院活动
EventID.OnTheaterJoinPerformGame = "OnTheaterJoinPerformGame" -- 报名剧院表演小游戏
EventID.OnTheaterJoinPerformGameFail = "OnTheaterJoinPerformGameFail" -- 报名剧院表演小游戏失败
EventID.OnTheaterPerformGameStart = "OnTheaterPerformGameStart" -- 剧院表演小游戏开始
EventID.OnTheaterPerformGameEnd = "OnTheaterPerformGameEnd" -- 剧院表演小游戏结束
EventID.OnTheaterLevelStart = "OnTheaterLevelStart" -- 剧院表演关卡开始
EventID.OnTheaterNPCPerform = "OnTheaterNPCPerform" -- 剧院NPC表演
EventID.OnTheaterPerform = "OnTheaterPerform" -- 剧院表演动作
EventID.OnTheaterPerformGameNotice = "OnTheaterPerformGameNotice" -- 剧院表演即将开始

--搜打撤活动
EventID.OnSoloTreasureScoreAndBagUI = "OnSoloTreasureScoreAndBagUI" --加载积分和背包UI
EventID.ShowCountDownTips = "ShowCountDownTips" --显示倒计时提示
EventID.OnUpdateGameScore = "OnUpdateGameScore" --更新游戏积分
EventID.OnSoloTreasureRefreshTickets = "OnSoloTreasureRefreshTickets" --刷新三选一彩票
EventID.OnSoloTreasureGetTicket = "OnSoloTreasureGetTicket" --获得三选一彩票
EventID.OnTreasureItemDragDetected = "OnTreasureItemDragDetected" -- 拼图背包拖动物品检测
EventID.OnTreasureItemDragCancelled = "OnTreasureItemDragCancelled" -- 拼图背包取消拖动物品
EventID.OnTreasureItemDrop = "OnTreasureItemDrop"   -- 拼图背包拖动物品放下
EventID.OnUpdateBagTreasureScore = "OnUpdateBagTreasureScore" --更新背包物资积分
EventID.OnPlayShowDamageEffect = "OnPlayShowDamageEffect" -- 收到攻击时UI界面播放受击动效
EventID.OnSoloTreasureTribute = "OnSoloTreasureTribute" -- 献祭物品成功

-- 社区活动
EventID.OnCommunityFollowActivityJJJFinish = "OnCommunityFollowActivityJJJFinish" -- 皎皎角关注回调

-- 回归活动
EventID.OnComeBackNewPhaseUnlocked = "OnCommunityFollowActivityJJJFinish" -- 回归活动解锁新阶段时

-- 词条文本解锁
EventID.OnEntryTextUnlocked = "OnEntryTextUnlocked"

--称号获得
EventID.OnGetTitle = "OnGetTitle"
--称号样式获得
EventID.OnGetTitleFrame = "OnGetTitleFrame"
--修改称号
EventID.OnChangeTitle = "OnChangeTitle"
--修改昵称
EventID.OnChangeNickName = "OnClickChangeName"

EventID.OnGetFeiNaReward = "OnGetFeiNaReward"

EventID.RefreshVoiceName = "RefreshVoiceName"

--自选道具
EventID.OnUpdateNumInputLimit = "OnUpdateNumInputLimit"

EventID.OnReturnToActivityEntry = "OnReturnToActivityEntry"
EventID.OnLeaveActivityEntry = "OnLeaveActivityEntry"
EventID.OnActivityEntryShowVisible = "OnActivityEntryShowVisible"

EventID.ForceUpdatePlayerCurrentLevelId = "ForceUpdatePlayerCurrentLevelId"

--手柄
EventID.OnGamepadUseSkillForceReleased = "OnGamepadUseSkillForceReleased"

--区域联机多人动作交互
EventID.AgreeOthersOnlineActionApplication = "AgreeOthersOnlineActionApplication" --同意他人加入自己的区域联机动作的申请
EventID.RejectOthersOnlineActionApplication = "RejectOthersOnlineActionApplication" --拒绝他人加入自己的区域联机动作的申请
EventID.AgreeOthersOnlineActionInvitation = "AgreeJoinOnlineAction" --同意加入他人的区域联机多人动作交互的邀请
EventID.RejectOthersOnlineActionInvitation = "RejectJoinOnlineAction" --拒绝加入他人的区域联机多人动作交互的邀请

EventID.ReceivedOthersOnlineActionApplication = "ReceivedOthersOnlineActionApplication" --收到他人加入自己的区域联机动作的申请
EventID.ReceivedOthersOnlineActionInvitation = "ReceivedOthersOnlineActionInvitation" --收到他人加入自己的区域联机多人动作交互的邀请

EventID.OnReceivedOnlineActionInvitationAgree = "OnReceivedOnlineActionInvitationAgree" --收到自己的邀请被同意的消息
EventID.OnReceivedOnlineActionInvitationReject = "OnReceivedOnlineActionInvitationReject" --收到自己的邀请被拒绝的消息

EventID.OnReceivedOnlineActionApplicationAgree = "OnReceivedOnlineActionApplicationAgree" --收到自己的申请被同意的消息
EventID.OnReceivedOnlineActionApplicationReject = "OnReceivedOnlineActionApplicationReject" --收到自己的申请被拒绝的消息

EventID.RequestDeadRegionOnlineItem = "RequestDeadRegionOnlineItem" -- 请求销毁区域联机物品 参数online_type, SenderEid, UniqueId
--梦魇联机开局相关事件
EventID.OnHardBossOpeningSequencePause = "OnHardBossOpeningSequencePause"
EventID.OnHardBossOpeningAllPlayerReady = "OnHardBossOpeningAllPlayerReady"

--单人工会战
EventID.OnPreRaidRankInfo = "OnPreRaidRankInfo"  --预算赛
EventID.OnRaidRankInfo = "OnRaidRankInfo"        --正式赛
EventID.OnRaidRankInfoTopN = "OnRaidRankInfoTopN"   --排行榜
EventID.OnRepRaidScore = "OnRepRaidScore"
EventID.OnRaidRankStart = "OnRaidRankStart"  --正式赛开始通知
EventID.GuilfWarLevelSelectReceiveEnterState = "GuilfWarLevelSelectReceiveEnterState" --单人工会选关页界面进入退出状态

EventID.OnVoiceResourceClicked = "OnVoiceResourceClicked"

-- 坐骑
EventID.MountsItemOnClick = "MountsItemOnClick"
EventID.OnEnableBattleMount = "OnEnableBattleMount"
EventID.OnDisableBattleMount = "OnDisableBattleMount"
EventID.OnStartMountFly = "OnStartMountFly"
EventID.OnStopMountFly = "OnStopMountFly"
EventID.OnGetLicense = "OnGetLicense"

-- 移动端HUD
EventID.OnMobileHudPlanChanged = "OnMobileHudPlanChanged"
EventID.OnSwitchMobileHUDLayout = "OnSwitchMobileHUDLayout"
EventID.OnUpdateMobileHudPlanName = "OnUpdateMobileHudPlanName"
EventID.OnSwitchLeftShoot = "OnSwitchLeftShoot"
EventID.OnSwitchLeftBulletJump = "OnSwitchLeftBulletJump"
EventID.OnSwitchBulletJumpCancel = "OnSwitchBulletJumpCancel"
EventID.OnSwitchExtraSlide = "OnSwitchExtraSlide"
EventID.OnSwitchExtraSlideAttack = "OnSwitchExtraSlideAttack"
EventID.OnEnterBulletJumpAim = "OnEnterBulletJumpAim"
EventID.OnQuitBulletJumpAim = "OnQuitBulletJumpAim"
EventID.OnExitMobileHudTrial = "OnExitMobileHudTrial"  -- 解除试用状态

EventID.OnSwitchAntiAliasing = "OnSwitchAntiAliasing"
EventID.OnSwitchUpscalingMethod = "OnSwitchUpscalingMethod"
EventID.OnSwitchRendering = "OnSwitchRendering"

-- 自走棋相关
EventID.OnAutoChessCreateMonster = "OnAutoChessCreateMonster"
EventID.OnAutoChessRemoveMonster = "OnAutoChessRemoveMonster"
EventID.OnCheckIsGameOver = "OnCheckIsGameOver"

EventID.OnBattleChessFight = "OnBattleChessFight"
EventID.OnBattleChessFightDamage = "OnBattleChessFightDamage"

EventID.OnAutoChessBattleStart = "OnAutoChessBattleStart"
EventID.OnAutoChessMotivateStart = "OnAutoChessMotivateStart"
EventID.OnAutoChessCubeChangeState = "OnAutoChessCubeChangeState"
EventID.OnInitRoleBattleInfo = "OnInitRoleBattleInfo"
EventID.OnAutoChessDisableCubeInteraction = "OnAutoChessDisableCubeInteraction"

EventID.OnAutoChessEquipChange = "OnAutoChessEquipChange"

EventID.OnDungeonEscClose = "OnDungeonEscClose"

-- 委托迁移副本
EventID.StopTrollyBoxLocationSync = "StopTrollyBoxLocationSync"

-- 无由生相关
EventID.OnWuyoushengLevelProgress = "OnWuyoushengLevelProgress"
EventID.OnWuyoushengLevelUp = "OnWuyoushengLevelUp"
EventID.OnRepWuyoushengTop = "OnRepWuyoushengTop"
EventID.OnShowWuyoushengTop = "OnShowWuyoushengTop"
EventID.RefreshWuyoushengLevelReddot = "RefreshWuyoushengLevelReddot"

-- 语言设置不重启
EventID.OnSettingSystemLanguageChanged = "OnSettingSystemLanguageChanged"

--送礼功能相关

--活动任务
EventID.RefreshAcvitityRewardPanel = "RefreshAcvitityRewardPanel"

-- 搜打撤局内守护任务相关
EventID.OnContainerBeAttacked = "OnContainerBeAttacked"
EventID.OnContainerBeRepaired = "OnContainerBeRepaired"
EventID.OnContainerDestroyed = "OnContainerDestroyed"
EventID.OnTaskEnded = "OnTaskEnded"
EventID.OnAllContainersRewardsClaimed = "OnAllContainersRewardsClaimed"

--Patch相关
EventID.OnOptionalPatchFinish = "OnOptionalPatchFinish" -- 可选补丁下载完成
EventID.DownloadTaskStart = "DownloadTaskStart"
EventID.DownloadTaskFinish = "DownloadTaskFinish"
local Event = {}
EventID.OnSendGiftFinished= "OnSendGiftFinished" --送礼完成 收到了服务端回调

Event.List=nil

function Event:New()
    local o = {}
    setmetatable(o,self)
    self.__index = self
    o.List = {}
    o.FuncMap = {}
    o.NowCount = 0
    o.LastCount = 0
    return o
end

function Event:Add(obj,funcion)
    ---@note 事件会按序执行，存储回调的是list
    -- table.insert(self.List,{obj=obj,funcion=funcion})
    if not self.List[obj] then
        self.List[obj] = {}
        self.FuncMap[obj] = {}
    end
    if not self.FuncMap[obj][funcion] then
        table.insert(self.List[obj], funcion)
        self.FuncMap[obj][funcion] = 1
        self.NowCount = self.NowCount + 1
    end
    
end

function Event:Remove(obj)
    -- for i , event in ipairs(self.List) do
    --     if event.obj==obj then
    --         event.obj = nil
    --         return
    --     end
    -- end
    if self.List[obj] then
        self.NowCount = self.NowCount - #self.List[obj]
    end
    self.List[obj] = nil
    self.FuncMap[obj] = nil
end


function Event:CheckIsLeak(eventName, bLog)
    --bLog = true
    --DebugPrint(string.format("EventManager事件，%s，LastCount:%s，NowCount:%s",eventName,self.LastCount, self.NowCount))
    local RealCount = 0
    if self.LastCount~=0 and self.LastCount < self.NowCount and bLog then
        local Visited = {}
        local Logger = {}
        for obj, List in pairs(self.List) do
            if obj.Overridden and not Visited[obj.Overridden] then
                --排除掉会误报的
                if string.startswith(tostring(obj.Overridden),"UWorldTravelSubsystem") then
                    self.NowCount = self.NowCount - #List
                    goto continue
                end
                Visited[obj.Overridden] = 1
                Logger[obj.Overridden] = #List
            elseif obj.__Name__ then  --这里是故意不加Visited，因为Entity可能有多个componment，但是他们类名都一样，如果贸然去重可能会漏掉一些检测
                Logger[obj.__Name__ ] = #List
            elseif not Visited[obj] then
                Visited[obj] = 1
                Logger[obj] = #List
            end
            RealCount = RealCount + #List
            ::continue::
        end
        if self.LastCount < self.NowCount then
            ScreenPrint(ErrorTag..string.format("EventManager事件 %s 发现内存泄漏，请检查该事件注册后是否正确清理，LastCount:%s，NowCount:%s",eventName,self.LastCount, self.NowCount))
            for Obj, Count in pairs(Logger) do
                DebugPrint(ErrorTag,string.format("该泄漏的事件绑定的函数数量:%s, 类名or对象:",Count), Obj) 
            end
        end
        self.NowCount = RealCount
    end
    self.LastCount = self.NowCount
end

function Event:Invoke(...)
    -- for i, event in ipairs(self.List)  do
    --     local obj = event.obj
    --     if obj then
    --         -- PrintTable({Obj = obj}, 10)
    --         local objType = type(obj)
    --         if ((objType == "userdata" or (objType=="table" and obj.Object)) and IsValid(obj)) or (objType == "table" and not obj.Object) then
    --             if(event.funcion) then
    --                 event.funcion(obj,...)
    --             end
    --         end
    --     end
    -- end

    -- for i = #self.List, 1, -1 do
    --     local Event = self.List[i]
    --     if Event.obj == nil then
    --         table.remove(self.List, i)
    --     end
    -- end
    local InvalidObjs = {}
    local TmpCalls = {}
    for obj, funcs in pairs(self.List) do
        if obj then
            local objType = type(obj)
            if ((objType == "userdata" or (objType=="table" and obj.Object)) and IsValid(obj)) or (objType == "table" and not obj.Object) then
                table.insert(TmpCalls, {obj, funcs})
                -- for _, func in ipairs(funcs) do
                --     func(obj, ...)
                -- end
            else
                table.insert(InvalidObjs, obj)
            end
        end
    end
    local args = {...}
    for _, call in ipairs(TmpCalls) do
        local obj = call[1]
        local funcs = call[2]
        for _, func in ipairs(funcs) do
        	try {
		        exec = function()
            		func(obj, table.unpack(args))
		        end,
		        catch = function(err)
		        	GWorld.logger.error(Traceback(ErrorTag, err,true))
		        end
	    	}
        end
    end
    for _, obj in ipairs(InvalidObjs) do
        self.List[obj] = nil
    end
end

function Event:RemoveAll()
    self.List={}
end

---@class EventManager
local EventManager={}

EventManager.EventDic={}

function EventManager:AddEvent(eventName, obj, func)
    if not obj then 
        Traceback(ErrorTag, "EventManager:AddEvent，事件的对象不能为空！！！")
        return
    end
    if not func then
        Traceback(ErrorTag, "EventManager:AddEvent，传入的函数回调不能为空！！")
        return
    end
    if self.EventDic[eventName] == nil then
        self.EventDic[eventName] = Event:New()
    end
    self.EventDic[eventName]:Add(obj,func)
end

function EventManager:RemoveEvent(eventName,obj)
    if not obj then 
        Traceback(ErrorTag, "EventManager:RemoveEvent，事件的对象不能为空！！！")
        return
    end
    if self.EventDic[eventName] ~= nil then
        self.EventDic[eventName]:Remove(obj)
    end
end

function EventManager:FireEvent(eventName,...)
    if self.EventDic[eventName] ~= nil then
        self.EventDic[eventName]:Invoke(...)
    end
end

function EventManager:CheckIsLeak()
    local bLog = true
    if not GWorld.IsDev then 
        return
    end
    DebugPrint(WarningTag, "检测EventMananger事件泄漏...")
    for eventName, Event in pairs(self.EventDic) do
        Event:CheckIsLeak(eventName, bLog)
    end
end

_G.EventID = EventID
_G.EventManager=EventManager 
return {EventManager,EventID}