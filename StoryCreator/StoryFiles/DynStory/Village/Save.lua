return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17159285687791",
			["startPort"] = "StoryStart",
			["endStory"] = "1715931069544447",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1715931069544447",
			["startPort"] = "Success",
			["endStory"] = "17159285687805",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17159285687791"] = {
			["isStoryNode"] = true,
			["key"] = "17159285687791",
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
		["17159285687805"] = {
			["isStoryNode"] = true,
			["key"] = "17159285687805",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2325.2941176470586,
				["y"] = 298.2352941176471
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1715931069544447"] = {
			["isStoryNode"] = true,
			["key"] = "1715931069544447",
			["type"] = "StoryNode",
			["name"] = "救皎皎",
			["pos"] = {
				["x"] = 1552,
				["y"] = 299.409090909091
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "DynQuest_VillageSave_Des",
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
				["bIsDynamicEvent"] = true,
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
						["startQuest"] = "1715931069544448",
						["startPort"] = "QuestStart",
						["endQuest"] = "17159311071121515",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17159311071121515",
						["startPort"] = "Out",
						["endQuest"] = "17159310962711082",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17159311071121515",
						["startPort"] = "Out",
						["endQuest"] = "17159311417892530",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17169518415012526",
						["startPort"] = "Out",
						["endQuest"] = "1716898164412135073",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17159311417892530",
						["startPort"] = "Out",
						["endQuest"] = "1720944862106891",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1720944862106891",
						["startPort"] = "Out",
						["endQuest"] = "17169518415012526",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17159311686453265",
						["startPort"] = "Out",
						["endQuest"] = "1715931069544454",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1720944862106891",
						["startPort"] = "Out",
						["endQuest"] = "17218172676278323",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17218172676278323",
						["startPort"] = "Out",
						["endQuest"] = "17159311478612743",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17159311478612743",
						["startPort"] = "Out",
						["endQuest"] = "17159311686453265",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1715931069544448"] = {
						["key"] = "1715931069544448",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 800,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1715931069544454"] = {
						["key"] = "1715931069544454",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2905.657894736842,
							["y"] = 269.6390977443609
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1715931069544460"] = {
						["key"] = "1715931069544460",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2708.996240601504,
							["y"] = 570.0714285714286
						},
						["propsData"] = {}
					},
					["17159310962711082"] = {
						["key"] = "17159310962711082",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1437.734133126935,
							["y"] = 140.24461722488047
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71000501,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17159311071121515"] = {
						["key"] = "17159311071121515",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "创建皎皎和怪物",
						["pos"] = {
							["x"] = 1109.7867647058822,
							["y"] = 311.284090909091
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1590148,
								1590149,
								1590150,
								1590151
							}
						}
					},
					["17159311417892530"] = {
						["key"] = "17159311417892530",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1439.9860128261832,
							["y"] = 371.9213089542038
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 3,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								1590149,
								1590150,
								1590151
							}
						}
					},
					["17159311478612743"] = {
						["key"] = "17159311478612743",
						["type"] = "TalkNode",
						["name"] = "皎皎感谢",
						["pos"] = {
							["x"] = 2296.879682422169,
							["y"] = 271.1575789770871
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71000511,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_Dyn71000601",
							["BlendInTime"] = 0.2,
							["BlendOutTime"] = 2,
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
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 800005,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
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
					["17159311686453265"] = {
						["key"] = "17159311686453265",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 2617.6702233524993,
							["y"] = 278.58860218728654
						},
						["propsData"] = {
							["DialogueId"] = 0,
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0,
							["UseTalkFadeIn"] = false,
							["TalkFadeInTime"] = 0
						}
					},
					["1716898164412135073"] = {
						["key"] = "1716898164412135073",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 2348.6233766233763,
							["y"] = 588.779220779221
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "Dyn_TargetPoint2",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17169518415012526"] = {
						["key"] = "17169518415012526",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2040.7840909090912,
							["y"] = 583.2613636363635
						},
						["propsData"] = {
							["WaitTime"] = 0.5
						}
					},
					["1720944862106891"] = {
						["key"] = "1720944862106891",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 1706.8133971291868,
							["y"] = 370.57607655502386
						},
						["propsData"] = {
							["WaitTime"] = 2
						}
					},
					["17218172676278323"] = {
						["key"] = "17218172676278323",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "移除皎皎",
						["pos"] = {
							["x"] = 1992.1102756892226,
							["y"] = 295.5388471177945
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1590148
							}
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}