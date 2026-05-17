return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17439931090241637",
			["startPort"] = "StoryStart",
			["endStory"] = "17439932284851928",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17439932284851928",
			["startPort"] = "Success",
			["endStory"] = "17439931090241640",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17439931090241637"] = {
			["isStoryNode"] = true,
			["key"] = "17439931090241637",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 800,
				["y"] = 300
			},
			["propsData"] = {
				["QuestChainId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17439931090241640"] = {
			["isStoryNode"] = true,
			["key"] = "17439931090241640",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1570,
				["y"] = 278
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17439932284851928"] = {
			["isStoryNode"] = true,
			["key"] = "17439932284851928",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1280,
				["y"] = 274
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "",
				["QuestDeatil"] = "",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = false,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 0,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17439933030682535",
						["startPort"] = "Out",
						["endQuest"] = "17439932300602022",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17439932300602022",
						["startPort"] = "Out",
						["endQuest"] = "17439932996902433",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17439932284851929",
						["startPort"] = "QuestStart",
						["endQuest"] = "17446224536513936",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17446224536513936",
						["startPort"] = "Out",
						["endQuest"] = "17439932284851935",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17439932284851929",
						["startPort"] = "QuestStart",
						["endQuest"] = "17485244536888708005",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17485244536888708005",
						["startPort"] = "Out",
						["endQuest"] = "17439933030682535",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17439932996902433",
						["startPort"] = "Out",
						["endQuest"] = "17446224443803695",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17439932284851929"] = {
						["key"] = "17439932284851929",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 516.3636363636363,
							["y"] = 294.54545454545456
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17439932284851932"] = {
						["key"] = "17439932284851932",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2237.4848484848485,
							["y"] = 307.3636363636364
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17439932284851935"] = {
						["key"] = "17439932284851935",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1570.6363636363637,
							["y"] = 703.3636363636364
						},
						["propsData"] = {}
					},
					["17439932300602022"] = {
						["key"] = "17439932300602022",
						["type"] = "TalkNode",
						["name"] = "海尔法审判",
						["pos"] = {
							["x"] = 1316,
							["y"] = 264
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 11015301,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "EX01_FixSimple_24",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 110039,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 110022,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 110021,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17439932996902433"] = {
						["key"] = "17439932996902433",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1596,
							["y"] = 272.6666666666667
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1660170
							}
						}
					},
					["17439933030682535"] = {
						["key"] = "17439933030682535",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1061.0476190476195,
							["y"] = 286.00000000000006
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1660170
							}
						}
					},
					["17446224443803695"] = {
						["key"] = "17446224443803695",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 1960.3450923431571,
							["y"] = 311.1286605551311
						},
						["propsData"] = {}
					},
					["17446224536513936"] = {
						["key"] = "17446224536513936",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1102.6178196158844,
							["y"] = 676.5832060096766
						},
						["propsData"] = {}
					},
					["17485244536888708005"] = {
						["key"] = "17485244536888708005",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 796.2424242424244,
							["y"] = 279.6969696969697
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "TargetPoint_JailFin",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = false,
							["bForceAsyncLoading"] = true,
							["IsWhite"] = false
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}