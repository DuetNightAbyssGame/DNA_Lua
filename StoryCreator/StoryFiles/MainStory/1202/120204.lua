return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1742891256142717351",
			["startPort"] = "StoryStart",
			["endStory"] = "17623977185535612",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17623977185535612",
			["startPort"] = "Success",
			["endStory"] = "17623978934852955",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17623978934852955",
			["startPort"] = "Success",
			["endStory"] = "17623979286543257",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17623979286543257",
			["startPort"] = "Success",
			["endStory"] = "17623979425273441",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17623979425273441",
			["startPort"] = "Success",
			["endStory"] = "17623979555743772",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17623979555743772",
			["startPort"] = "Success",
			["endStory"] = "17623979841474106",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17623979841474106",
			["startPort"] = "Success",
			["endStory"] = "17623980232414520",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17623980795315743",
			["startPort"] = "Success",
			["endStory"] = "17623980925425958",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17623980925425958",
			["startPort"] = "Success",
			["endStory"] = "17623981122296236",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17623981122296236",
			["startPort"] = "Success",
			["endStory"] = "17623981284856516",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17623981284856516",
			["startPort"] = "Success",
			["endStory"] = "17623981598467044",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17623981598467044",
			["startPort"] = "Success",
			["endStory"] = "17623981770557413",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17623981770557413",
			["startPort"] = "Success",
			["endStory"] = "1742891256142717352",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "17623980232414520",
			["startPort"] = "Success",
			["endStory"] = "17623980795315743",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["1742891256142717351"] = {
			["isStoryNode"] = true,
			["key"] = "1742891256142717351",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 3284.6551557554562,
				["y"] = 1067.6830798886272
			},
			["propsData"] = {
				["QuestChainId"] = 120204
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1742891256142717352"] = {
			["isStoryNode"] = true,
			["key"] = "1742891256142717352",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 4830.086627895417,
				["y"] = 1733.004927219401
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17623977185535612"] = {
			["isStoryNode"] = true,
			["key"] = "17623977185535612",
			["type"] = "StoryNode",
			["name"] = "回山外山的路上",
			["pos"] = {
				["x"] = 3619.9969360851746,
				["y"] = 1068.6664727705722
			},
			["propsData"] = {
				["QuestId"] = 12020401,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120204_1",
				["QuestDeatil"] = "Content_120204_1",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = true,
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
				["SubRegionId"] = 105201,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_12020401hezi_2360043",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17623977185535613",
						["startPort"] = "QuestStart",
						["endQuest"] = "17633700388766059503",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17633700388766059503",
						["startPort"] = "Out",
						["endQuest"] = "17633712387336060386",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17633700388766059503",
						["startPort"] = "Out",
						["endQuest"] = "17623977185535616",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17623977185535613"] = {
						["key"] = "17623977185535613",
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
					["17623977185535616"] = {
						["key"] = "17623977185535616",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1600.625,
							["y"] = 301.33620689655174
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17623977185535619"] = {
						["key"] = "17623977185535619",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17633700388766059503"] = {
						["key"] = "17633700388766059503",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1250.432450441446,
							["y"] = 290.8142595368982
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2360043,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020401hezi_2360043"
						}
					},
					["17633712387336060386"] = {
						["key"] = "17633712387336060386",
						["type"] = "TalkNode",
						["name"] = "开车",
						["pos"] = {
							["x"] = 1604.9250796428414,
							["y"] = 147.93067333722203
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12049069,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17730677505084955845"] = {
						["key"] = "17730677505084955845",
						["type"] = "SimplePostProcessNode",
						["name"] = "开启关闭屏幕后处理",
						["pos"] = {
							["x"] = 1234.393826051298,
							["y"] = 99.34230565649332
						},
						["propsData"] = {
							["bEnablePP"] = true,
							["PPEnum"] = 0
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17623978934852955"] = {
			["isStoryNode"] = true,
			["key"] = "17623978934852955",
			["type"] = "StoryNode",
			["name"] = "山外山防守战",
			["pos"] = {
				["x"] = 3901.0525767248473,
				["y"] = 1062.662234042553
			},
			["propsData"] = {
				["QuestId"] = 12020402,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120204_2",
				["QuestDeatil"] = "Content_120204_2",
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
				["SubRegionId"] = 105201,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_12020402fangshouzhan_2360046",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17623978934852960",
						["startPort"] = "QuestStart",
						["endQuest"] = "17633715028426060967",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17633715028426060967",
						["startPort"] = "Out",
						["endQuest"] = "17633715073036061081",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17633715073036061081",
						["startPort"] = "Fail",
						["endQuest"] = "17633715206166061475",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17633715073036061081",
						["startPort"] = "PassiveFail",
						["endQuest"] = "17633715206166061475",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17633715206166061475",
						["startPort"] = "Out",
						["endQuest"] = "17623978934852962",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17633715073036061081",
						["startPort"] = "Success",
						["endQuest"] = "17623978934852961",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17623978934852960"] = {
						["key"] = "17623978934852960",
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
					["17623978934852961"] = {
						["key"] = "17623978934852961",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2293.876923076923,
							["y"] = 335.7692307692308
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17623978934852962"] = {
						["key"] = "17623978934852962",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2287.013360323887,
							["y"] = 487.6807692307692
						},
						["propsData"] = {}
					},
					["17633715028426060967"] = {
						["key"] = "17633715028426060967",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1236.3862068965516,
							["y"] = 345.6
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2360046,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020402fangshouzhan_2360046"
						}
					},
					["17633715073036061081"] = {
						["key"] = "17633715073036061081",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 1575.8718567251462,
							["y"] = 345.47368421052624
						},
						["propsData"] = {
							["SpecialConfigId"] = 12020402,
							["BlackScreenImmediately"] = false
						}
					},
					["17633715206166061475"] = {
						["key"] = "17633715206166061475",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1955.2307682020496,
							["y"] = 473.7855722081123
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "12020402Backpoint",
							["FadeIn"] = false,
							["FadeOut"] = true,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17623979286543257"] = {
			["isStoryNode"] = true,
			["key"] = "17623979286543257",
			["type"] = "StoryNode",
			["name"] = "战后站桩",
			["pos"] = {
				["x"] = 4176.961622137796,
				["y"] = 1054.8540444770283
			},
			["propsData"] = {
				["QuestId"] = 12020403,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120204_3",
				["QuestDeatil"] = "Content_120204_3",
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
				["SubRegionId"] = 105201,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_12020402fangshouzhan_2360046",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17634525460926064061",
						["startPort"] = "Out",
						["endQuest"] = "17623979286543263",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17623979286543262",
						["startPort"] = "QuestStart",
						["endQuest"] = "17634525460926064061",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17623979286543262"] = {
						["key"] = "17623979286543262",
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
					["17623979286543263"] = {
						["key"] = "17623979286543263",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1856.6396033129902,
							["y"] = 315.21933817118827
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17623979286553264"] = {
						["key"] = "17623979286553264",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17634524025696063449"] = {
						["key"] = "17634524025696063449",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1177.7815736094801,
							["y"] = 153.85956015800147
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2360046,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020402fangshouzhan_2360046"
						}
					},
					["17634525460926064061"] = {
						["key"] = "17634525460926064061",
						["type"] = "TalkNode",
						["name"] = "【East02_FixSimple_44】大军入侵，煜明进来",
						["pos"] = {
							["x"] = 1510.1106363529211,
							["y"] = 317.48465463366097
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1202/12044401.12044401'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East02_12020403",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = true,
							["StartFadeOutTime"] = 0,
							["StartScreenEffectDuration"] = 1,
							["FinishFadeInTime"] = 0,
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
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = false,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17623979425273441"] = {
			["isStoryNode"] = true,
			["key"] = "17623979425273441",
			["type"] = "StoryNode",
			["name"] = "煜明精英战",
			["pos"] = {
				["x"] = 4480.391052922067,
				["y"] = 1040.6023338220919
			},
			["propsData"] = {
				["QuestId"] = 12020404,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120204_4",
				["QuestDeatil"] = "Content_120204_4",
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
				["SubRegionId"] = 105201,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_12020402fangshouzhan_2360046",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17634527557216065126",
						["startPort"] = "Out",
						["endQuest"] = "17634527607946065256",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17634527607946065256",
						["startPort"] = "Success",
						["endQuest"] = "17623979425273447",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17623979425273446",
						["startPort"] = "QuestStart",
						["endQuest"] = "17634527557216065126",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17634527607946065256",
						["startPort"] = "Fail",
						["endQuest"] = "17634527762676065797",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17634527607946065256",
						["startPort"] = "PassiveFail",
						["endQuest"] = "17634527762676065797",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17634527762676065797",
						["startPort"] = "Out",
						["endQuest"] = "17623979425273448",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["17623979425273446"] = {
						["key"] = "17623979425273446",
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
					["17623979425273447"] = {
						["key"] = "17623979425273447",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2800,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17623979425273448"] = {
						["key"] = "17623979425273448",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2599.4736842105262,
							["y"] = 567.3684210526316
						},
						["propsData"] = {}
					},
					["17634527557216065126"] = {
						["key"] = "17634527557216065126",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1344,
							["y"] = 336
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2360046,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020402fangshouzhan_2360046"
						}
					},
					["17634527607946065256"] = {
						["key"] = "17634527607946065256",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 1798.4457478005859,
							["y"] = 338.8563049853372
						},
						["propsData"] = {
							["SpecialConfigId"] = 12020404,
							["BlackScreenImmediately"] = false
						}
					},
					["17634527762676065797"] = {
						["key"] = "17634527762676065797",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 2262.0082023239916,
							["y"] = 552.338004101162
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "12020402Backpoint",
							["FadeIn"] = false,
							["FadeOut"] = true,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17623979555743772"] = {
			["isStoryNode"] = true,
			["key"] = "17623979555743772",
			["type"] = "StoryNode",
			["name"] = "战后动画进技巧迷宫",
			["pos"] = {
				["x"] = 4798.748839124554,
				["y"] = 1034.954688290019
			},
			["propsData"] = {
				["QuestId"] = 12020405,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120204_5",
				["QuestDeatil"] = "Content_120204_5",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = true,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 105201,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_12020402fangshouzhan_2360046",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17634543686367080008",
						["startPort"] = "Out",
						["endQuest"] = "17623979555743778",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17623979555743777",
						["startPort"] = "QuestStart",
						["endQuest"] = "17634543686367080008",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17623979555743777"] = {
						["key"] = "17623979555743777",
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
					["17623979555743778"] = {
						["key"] = "17623979555743778",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2310,
							["y"] = 311.6666666666667
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 104801,
							["StartIndex"] = 1,
							["LoadingId"] = 0,
							["IsWhite"] = false
						}
					},
					["17623979555743779"] = {
						["key"] = "17623979555743779",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17634543686367080008"] = {
						["key"] = "17634543686367080008",
						["type"] = "TalkNode",
						["name"] = "动画",
						["pos"] = {
							["x"] = 1727.2242571895872,
							["y"] = 306.0629744651484
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/Ver01/Ver0102/Ver0102_SC008/SQ_Ver0102_SC008",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = true,
							["StartFadeOutTime"] = 0.5,
							["StartScreenEffectDuration"] = 1,
							["FinishFadeInTime"] = 0,
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = true,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideEffectCreature"] = true,
							["HideMechanismsFX"] = true,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								}
							},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["176725070686724658592"] = {
						["key"] = "176725070686724658592",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1271.6581274895705,
							["y"] = 49.97540186673572
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2360046,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020402fangshouzhan_2360046"
						}
					}
				},
				["commentData"] = {
					["17634566874559107850"] = {
						["key"] = "17634566874559107850",
						["name"] = "传送进晏隐宫",
						["position"] = {
							["x"] = 2259.727399391225,
							["y"] = 224.3171849269875
						},
						["size"] = {
							["width"] = 344.5161290322582,
							["height"] = 228.38709677419362
						}
					}
				}
			}
		},
		["17623979841474106"] = {
			["isStoryNode"] = true,
			["key"] = "17623979841474106",
			["type"] = "StoryNode",
			["name"] = "机巧迷宫1",
			["pos"] = {
				["x"] = 3557.985852111568,
				["y"] = 1365.1017334862024
			},
			["propsData"] = {
				["QuestId"] = 12020406,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120204_6",
				["QuestDeatil"] = "Content_120204_6",
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
				["IsFairyLand"] = true,
				["IsBacktrack"] = false,
				["SubRegionId"] = 104801,
				["SubRegionIdList"] = {
					104801,
					105201
				},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "1202041006START",
				["JumpId"] = 0,
				["FairyLandStaticCreatorId"] = 0,
				["FairyLandDeliverIndex"] = 1
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "176725273499233239191",
						["startPort"] = "Region_2",
						["endQuest"] = "176725273499233239190",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176725273499233239191",
						["startPort"] = "Region_1",
						["endQuest"] = "17634566827819107688",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17623979841474111",
						["startPort"] = "QuestStart",
						["endQuest"] = "176725273499233239191",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17634566827819107688",
						["startPort"] = "Fail",
						["endQuest"] = "17690740098892387",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17634566827819107688",
						["startPort"] = "PassiveFail",
						["endQuest"] = "17690740098892387",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17690740098892387",
						["startPort"] = "Out",
						["endQuest"] = "17623979841474113",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17634566827819107688",
						["startPort"] = "Success",
						["endQuest"] = "17623979841474112",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "176725273499233239190",
						["startPort"] = "Out",
						["endQuest"] = "17736751588762566841",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17736751588762566841",
						["startPort"] = "Out",
						["endQuest"] = "17634566827819107688",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17623979841474111"] = {
						["key"] = "17623979841474111",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 775.25,
							["y"] = 341.25
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17623979841474112"] = {
						["key"] = "17623979841474112",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2044.782608695652,
							["y"] = 318.2608695652174
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17623979841474113"] = {
						["key"] = "17623979841474113",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2023.4910485933506,
							["y"] = 566.6112531969309
						},
						["propsData"] = {}
					},
					["17634566827819107688"] = {
						["key"] = "17634566827819107688",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 1438.20562046649,
							["y"] = 325.4354868277502
						},
						["propsData"] = {
							["SpecialConfigId"] = 12020406,
							["BlackScreenImmediately"] = false
						}
					},
					["176725273499233239190"] = {
						["key"] = "176725273499233239190",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 678.1745053181355,
							["y"] = 669.1652943346844
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "12020410Backpoint",
							["FadeIn"] = false,
							["FadeOut"] = true,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["176725273499233239191"] = {
						["key"] = "176725273499233239191",
						["type"] = "JudgeRegionNode",
						["name"] = "判断位于区域",
						["pos"] = {
							["x"] = 1045.2202266593013,
							["y"] = 336.92489552588546
						},
						["propsData"] = {
							["IsWaitingEnterRegion"] = false,
							["RegionIds"] = {
								104801,
								105201
							}
						}
					},
					["17690740098892387"] = {
						["key"] = "17690740098892387",
						["type"] = "SkipRegionNode",
						["name"] = "跨区域传送设置玩家位置",
						["pos"] = {
							["x"] = 1714.503658110083,
							["y"] = 466.79170196794803
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 105201,
							["StartIndex"] = 1,
							["IsWhite"] = false
						}
					},
					["17736751588762566841"] = {
						["key"] = "17736751588762566841",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 1042.4156526500794,
							["y"] = 679.454121320834
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {
								242360100
							},
							["QuestPickupId"] = -1,
							["UnitId"] = 11219,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "Drop_YYGback_242360100",
							["IsUseCount"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17623980232414520"] = {
			["isStoryNode"] = true,
			["key"] = "17623980232414520",
			["type"] = "StoryNode",
			["name"] = "机巧迷宫2",
			["pos"] = {
				["x"] = 3807.742927617835,
				["y"] = 1502.36556379348
			},
			["propsData"] = {
				["QuestId"] = 12020407,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120204_7",
				["QuestDeatil"] = "Content_120204_7",
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
				["IsFairyLand"] = true,
				["IsBacktrack"] = false,
				["SubRegionId"] = 104801,
				["SubRegionIdList"] = {
					104801,
					105201
				},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_12020406hezi5_242310251",
				["JumpId"] = 0,
				["FairyLandStaticCreatorId"] = 0,
				["FairyLandDeliverIndex"] = 1
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17623980232414525",
						["startPort"] = "QuestStart",
						["endQuest"] = "176725271232833238396",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176725271232833238396",
						["startPort"] = "Region_1",
						["endQuest"] = "176725132593830020002",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176725132593830020002",
						["startPort"] = "Success",
						["endQuest"] = "17623980232414526",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "176725132593830020002",
						["startPort"] = "Fail",
						["endQuest"] = "17695013061211118395",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176725132593830020002",
						["startPort"] = "PassiveFail",
						["endQuest"] = "17695013061211118395",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17695013061211118395",
						["startPort"] = "Out",
						["endQuest"] = "17623980232414527",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17736755936902568019",
						["startPort"] = "Out",
						["endQuest"] = "17736755936902568020",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176725271232833238396",
						["startPort"] = "Region_2",
						["endQuest"] = "17736755936902568019",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17736755936902568020",
						["startPort"] = "Out",
						["endQuest"] = "176725132593830020002",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17623980232414525"] = {
						["key"] = "17623980232414525",
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
					["17623980232414526"] = {
						["key"] = "17623980232414526",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2021.5,
							["y"] = 292.5
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 105201,
							["StartIndex"] = 1,
							["LoadingId"] = 0,
							["IsWhite"] = false
						}
					},
					["17623980232414527"] = {
						["key"] = "17623980232414527",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2077.8636363636365,
							["y"] = 458.77272727272725
						},
						["propsData"] = {}
					},
					["176346423290313170146"] = {
						["key"] = "176346423290313170146",
						["type"] = "TalkNode",
						["name"] = "【East02_FixSimple_45】拿到钥匙",
						["pos"] = {
							["x"] = 1198.431637328189,
							["y"] = -319.938509766096
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1202/12044601.12044601'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East02_12020407",
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
							["TalkActors"] = {},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = false,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["176346425451013170590"] = {
						["key"] = "176346425451013170590",
						["type"] = "TalkNode",
						["name"] = "【East02_FixSimple_46】迷宫中与石碑交互、看石碑",
						["pos"] = {
							["x"] = 1366.2494000252618,
							["y"] = -94.36926866237218
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1202/12044701.12044701'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East02_12020407",
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
							["TalkActors"] = {},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = false,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["176346425562513170632"] = {
						["key"] = "176346425562513170632",
						["type"] = "TalkNode",
						["name"] = "【East02_FixSimple_47】获得大炮遥控装置，和半块均天玉律",
						["pos"] = {
							["x"] = 1605.1864974106352,
							["y"] = 92.3093974990527
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1202/12044801.12044801'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East02_12020407",
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
							["TalkActors"] = {},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = false,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["176725132593830020002"] = {
						["key"] = "176725132593830020002",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 1402.0742258952644,
							["y"] = 305.8342835309342
						},
						["propsData"] = {
							["SpecialConfigId"] = 12020407,
							["BlackScreenImmediately"] = false
						}
					},
					["176725271232833238396"] = {
						["key"] = "176725271232833238396",
						["type"] = "JudgeRegionNode",
						["name"] = "判断位于区域",
						["pos"] = {
							["x"] = 1057.2441226530646,
							["y"] = 298.76028977911795
						},
						["propsData"] = {
							["IsWaitingEnterRegion"] = false,
							["RegionIds"] = {
								104801,
								105201
							}
						}
					},
					["17695013061211118395"] = {
						["key"] = "17695013061211118395",
						["type"] = "SkipRegionNode",
						["name"] = "跨区域传送设置玩家位置",
						["pos"] = {
							["x"] = 1778.4351989485604,
							["y"] = 456.6517828435934
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 105201,
							["StartIndex"] = 1,
							["IsWhite"] = false
						}
					},
					["17736755936902568019"] = {
						["key"] = "17736755936902568019",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 916.4248808794825,
							["y"] = 710.1283137796524
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "12020410Backpoint",
							["FadeIn"] = false,
							["FadeOut"] = true,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17736755936902568020"] = {
						["key"] = "17736755936902568020",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 1268.3933009386992,
							["y"] = 753.1444134930748
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {
								242360100
							},
							["QuestPickupId"] = -1,
							["UnitId"] = 11219,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "Drop_YYGback_242360100",
							["IsUseCount"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17623980795315743"] = {
			["isStoryNode"] = true,
			["key"] = "17623980795315743",
			["type"] = "StoryNode",
			["name"] = "出迷宫后动画",
			["pos"] = {
				["x"] = 4110.424342303084,
				["y"] = 1361.1880658998357
			},
			["propsData"] = {
				["QuestId"] = 12020409,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120204_9",
				["QuestDeatil"] = "Content_120204_9",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = true,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 105201,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_12020402fangshouzhan_2360046",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17623980795315748",
						["startPort"] = "QuestStart",
						["endQuest"] = "17634572976579108992",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17634572976579108992",
						["startPort"] = "Out",
						["endQuest"] = "177280507986310260060",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177280507986310260060",
						["startPort"] = "Out",
						["endQuest"] = "17623980795315749",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17623980795315748"] = {
						["key"] = "17623980795315748",
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
					["17623980795315749"] = {
						["key"] = "17623980795315749",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3115.714285714286,
							["y"] = 292.85714285714283
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17623980795315750"] = {
						["key"] = "17623980795315750",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17634572976579108992"] = {
						["key"] = "17634572976579108992",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2146.5,
							["y"] = 315.35714285714283
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/Ver01/Ver0102/Ver0102_SC009/Ver0102_SC009",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = true,
							["StartFadeOutTime"] = 0.5,
							["StartScreenEffectDuration"] = 1,
							["FinishFadeInTime"] = 0,
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = true,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideEffectCreature"] = true,
							["HideMechanismsFX"] = true,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								}
							},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["176725079735225731361"] = {
						["key"] = "176725079735225731361",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1452.3782886360282,
							["y"] = 414.4671320681383
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2360046,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020402fangshouzhan_2360046"
						}
					},
					["177280507986310260060"] = {
						["key"] = "177280507986310260060",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 2751.47012987013,
							["y"] = 347.5259740259738
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "12020402fangshou_Start",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					}
				},
				["commentData"] = {
					["17675831925673259216"] = {
						["key"] = "17675831925673259216",
						["name"] = "破迷宫炮火破局， 主角团英雄归来！",
						["position"] = {
							["x"] = 2038.2611518915865,
							["y"] = 220.4080789482427
						},
						["size"] = {
							["width"] = 600,
							["height"] = 400
						}
					}
				}
			}
		},
		["17623980925425958"] = {
			["isStoryNode"] = true,
			["key"] = "17623980925425958",
			["type"] = "StoryNode",
			["name"] = "大炮打蚊子",
			["pos"] = {
				["x"] = 4417.160985923449,
				["y"] = 1356.4321607073216
			},
			["propsData"] = {
				["QuestId"] = 12020410,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120204_10",
				["QuestDeatil"] = "Content_120204_10",
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
				["SubRegionId"] = 105201,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_12020410teshuzhan_2360047",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17623980925425963",
						["startPort"] = "QuestStart",
						["endQuest"] = "176725099569125732523",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176725099569125732523",
						["startPort"] = "Out",
						["endQuest"] = "176345741941310122765",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176345741941310122765",
						["startPort"] = "Fail",
						["endQuest"] = "176725103818225733561",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176345741941310122765",
						["startPort"] = "PassiveFail",
						["endQuest"] = "176725103818225733561",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176725103818225733561",
						["startPort"] = "Out",
						["endQuest"] = "17623980925425965",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "176345741941310122765",
						["startPort"] = "Success",
						["endQuest"] = "17623980925425964",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17623980925425963"] = {
						["key"] = "17623980925425963",
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
					["17623980925425964"] = {
						["key"] = "17623980925425964",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2401.1111111111113,
							["y"] = 334.44444444444446
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17623980925425965"] = {
						["key"] = "17623980925425965",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2419,
							["y"] = 494.5
						},
						["propsData"] = {}
					},
					["176345741941310122765"] = {
						["key"] = "176345741941310122765",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 1608.7532467532465,
							["y"] = 317.66233766233773
						},
						["propsData"] = {
							["SpecialConfigId"] = 12020410,
							["BlackScreenImmediately"] = false
						}
					},
					["176725099569125732523"] = {
						["key"] = "176725099569125732523",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1236.6620022489587,
							["y"] = 306.1037380493899
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2360047,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020410teshuzhan_2360047"
						}
					},
					["176725103818225733561"] = {
						["key"] = "176725103818225733561",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1952.4720734038576,
							["y"] = 463.4600598884704
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "12020410Backpoint",
							["FadeIn"] = false,
							["FadeOut"] = true,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17623981122296236"] = {
			["isStoryNode"] = true,
			["key"] = "17623981122296236",
			["type"] = "StoryNode",
			["name"] = "击退天人大军后站桩",
			["pos"] = {
				["x"] = 4738.043435161992,
				["y"] = 1354.7192429820916
			},
			["propsData"] = {
				["QuestId"] = 12020411,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120204_11",
				["QuestDeatil"] = "Content_120204_11",
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
				["SubRegionId"] = 105201,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_12020410teshuzhan_2360047",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "176345783831311136916",
						["startPort"] = "Out",
						["endQuest"] = "176725449115636456120",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176725449115636456120",
						["startPort"] = "Out",
						["endQuest"] = "17623981122296242",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17623981122296241",
						["startPort"] = "QuestStart",
						["endQuest"] = "176725699646446107365",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176725699646446107365",
						["startPort"] = "Out",
						["endQuest"] = "176345783831311136916",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17623981122296241"] = {
						["key"] = "17623981122296241",
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
					["17623981122296242"] = {
						["key"] = "17623981122296242",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2800,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17623981122296243"] = {
						["key"] = "17623981122296243",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["176345783831311136916"] = {
						["key"] = "176345783831311136916",
						["type"] = "TalkNode",
						["name"] = "【East02_FixSimple_48】击退天人大军后",
						["pos"] = {
							["x"] = 1874.6764705882354,
							["y"] = 361.4683257918552
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1202/12044901.12044901'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East02_12020411",
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
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = false,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["176725449115636456120"] = {
						["key"] = "176725449115636456120",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成苏乙刻舟",
						["pos"] = {
							["x"] = 2294.2401536454086,
							["y"] = 395.0125907247164
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								242360060,
								242360077
							}
						}
					},
					["176725699646446107365"] = {
						["key"] = "176725699646446107365",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1330.1355472574708,
							["y"] = 365.213850054948
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2360047,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020410teshuzhan_2360047"
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17623981284856516"] = {
			["isStoryNode"] = true,
			["key"] = "17623981284856516",
			["type"] = "StoryNode",
			["name"] = "与刻舟苏乙对话",
			["pos"] = {
				["x"] = 5013.71710462978,
				["y"] = 1356.7491859937788
			},
			["propsData"] = {
				["QuestId"] = 12020412,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120204_12",
				["QuestDeatil"] = "Content_120204_12",
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
				["SubRegionId"] = 105201,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_12020411suyi_242360061",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "176346431982413171794",
						["startPort"] = "Out",
						["endQuest"] = "17623981284856522",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17623981284856521",
						["startPort"] = "QuestStart",
						["endQuest"] = "17701932760634405",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17701932760634405",
						["startPort"] = "Out",
						["endQuest"] = "176725487408537528379",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176725487408537528379",
						["startPort"] = "Out",
						["endQuest"] = "17701932808014582",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17701932808014582",
						["startPort"] = "Out",
						["endQuest"] = "176346431982413171794",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17701932760634405",
						["startPort"] = "Out",
						["endQuest"] = "17701936902231151227",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17701932808014582",
						["startPort"] = "Out",
						["endQuest"] = "17701936973621151513",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17623981284856521"] = {
						["key"] = "17623981284856521",
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
					["17623981284856522"] = {
						["key"] = "17623981284856522",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1908.8967611336034,
							["y"] = 343.5425101214575
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 105601,
							["StartIndex"] = 1,
							["LoadingId"] = 0,
							["IsWhite"] = false
						}
					},
					["17623981284856523"] = {
						["key"] = "17623981284856523",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["176346431982413171794"] = {
						["key"] = "176346431982413171794",
						["type"] = "TalkNode",
						["name"] = "【East02_FixSimple_49】与刻舟+苏乙对话表示有点疲惫",
						["pos"] = {
							["x"] = 1448.1082836082835,
							["y"] = 308.9113724113724
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1202/12045001.12045001'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East02_12020412",
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
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = false,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["176725487408537528379"] = {
						["key"] = "176725487408537528379",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 1135.171889047396,
							["y"] = 308.11442605737733
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {
								0
							},
							["QuestPickupId"] = -1,
							["UnitId"] = 11215,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "Drop_12020412duihua_162360065",
							["IsUseCount"] = false
						}
					},
					["17701932760634405"] = {
						["key"] = "17701932760634405",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1128.0714285714284,
							["y"] = 155.52559708093762
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								162360065
							}
						}
					},
					["17701932808014582"] = {
						["key"] = "17701932808014582",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1136.2625482625485,
							["y"] = 487.06034611568657
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								162360065
							}
						}
					},
					["17701936902231151227"] = {
						["key"] = "17701936902231151227",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1450.7270615563298,
							["y"] = 144.14464469998526
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "Drop_12020412duihua_162360065"
						}
					},
					["17701936973621151513"] = {
						["key"] = "17701936973621151513",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1452.3461091753775,
							["y"] = 477.0970256523663
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "Drop_12020412duihua_162360065"
						}
					}
				},
				["commentData"] = {
					["176725661399843963400"] = {
						["key"] = "176725661399843963400",
						["name"] = "进小黑屋",
						["position"] = {
							["x"] = 1829.3629587340552,
							["y"] = 248.93181374665463
						},
						["size"] = {
							["width"] = 335.52631578947353,
							["height"] = 252.63157894736835
						}
					}
				}
			}
		},
		["17623981598467044"] = {
			["isStoryNode"] = true,
			["key"] = "17623981598467044",
			["type"] = "StoryNode",
			["name"] = "进小黑屋与止流对话",
			["pos"] = {
				["x"] = 4180.109411497742,
				["y"] = 1706.846298914082
			},
			["propsData"] = {
				["QuestId"] = 12020413,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120204_13",
				["QuestDeatil"] = "Content_120204_13",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = true,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = true,
				["IsBacktrack"] = false,
				["SubRegionId"] = 105601,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0,
				["FairyLandStaticCreatorId"] = 0,
				["FairyLandDeliverIndex"] = 1
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17623981598467049",
						["startPort"] = "QuestStart",
						["endQuest"] = "17701939764682297286",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17701939764682297286",
						["startPort"] = "Success",
						["endQuest"] = "17623981598467050",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17701939764682297286",
						["startPort"] = "Fail",
						["endQuest"] = "17701940355462298368",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17701939764682297286",
						["startPort"] = "PassiveFail",
						["endQuest"] = "17701940355462298368",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17701940355462298368",
						["startPort"] = "Out",
						["endQuest"] = "17623981598467051",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["17623981598467049"] = {
						["key"] = "17623981598467049",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 917,
							["y"] = 346.5
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17623981598467050"] = {
						["key"] = "17623981598467050",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2195.9285714285716,
							["y"] = 379.92857142857144
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 104506,
							["StartIndex"] = 1,
							["LoadingId"] = 0,
							["IsWhite"] = false
						}
					},
					["17623981598467051"] = {
						["key"] = "17623981598467051",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2210.3846153846152,
							["y"] = 575.3846153846155
						},
						["propsData"] = {}
					},
					["176346309107213168971"] = {
						["key"] = "176346309107213168971",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1608.4166666666667,
							["y"] = 1001.2916666666667
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1202/12045101.12045101'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East02_12020413",
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
							["TalkActors"] = {},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = false,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["176725631734141817486"] = {
						["key"] = "176725631734141817486",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1601.7745276144983,
							["y"] = 810.4333869768104
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12049116,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["176725712681647180275"] = {
						["key"] = "176725712681647180275",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 1577.08088030973,
							["y"] = -47.61527441331376
						},
						["propsData"] = {
							["SpecialConfigId"] = 0,
							["BlackScreenImmediately"] = false
						}
					},
					["17701939764682297286"] = {
						["key"] = "17701939764682297286",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "第三次小黑屋",
						["pos"] = {
							["x"] = 1432.928236351749,
							["y"] = 342.4711104662378
						},
						["propsData"] = {
							["SpecialConfigId"] = 12020413,
							["BlackScreenImmediately"] = true
						}
					},
					["17701940355462298368"] = {
						["key"] = "17701940355462298368",
						["type"] = "SkipRegionNode",
						["name"] = "跨区域传送设置玩家位置",
						["pos"] = {
							["x"] = 1787.9305481374643,
							["y"] = 515.4766290245999
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 105201,
							["StartIndex"] = 2,
							["IsWhite"] = false
						}
					}
				},
				["commentData"] = {
					["176725655318342890658"] = {
						["key"] = "176725655318342890658",
						["name"] = "到执律阁",
						["position"] = {
							["x"] = 2172.1803919092417,
							["y"] = 301.8324072909467
						},
						["size"] = {
							["width"] = 281.99999999999966,
							["height"] = 233.99999999999994
						}
					}
				}
			}
		},
		["17623981770557413"] = {
			["isStoryNode"] = true,
			["key"] = "17623981770557413",
			["type"] = "StoryNode",
			["name"] = "止流登阶",
			["pos"] = {
				["x"] = 4465.095130587802,
				["y"] = 1700.1366749262043
			},
			["propsData"] = {
				["QuestId"] = 12020414,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120204_14",
				["QuestDeatil"] = "Content_120204_14",
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
				["IsFairyLand"] = true,
				["IsBacktrack"] = false,
				["SubRegionId"] = 104506,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0,
				["FairyLandStaticCreatorId"] = 0,
				["FairyLandDeliverIndex"] = 1
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "176725712354347180164",
						["startPort"] = "Fail",
						["endQuest"] = "17701948110873445049",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176725712354347180164",
						["startPort"] = "PassiveFail",
						["endQuest"] = "17701948110873445049",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17701948110873445049",
						["startPort"] = "Out",
						["endQuest"] = "17623981770557420",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "176725712354347180164",
						["startPort"] = "Success",
						["endQuest"] = "17623981770557419",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17623981770557418",
						["startPort"] = "QuestStart",
						["endQuest"] = "176725712354347180164",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17623981770557418"] = {
						["key"] = "17623981770557418",
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
					["17623981770557419"] = {
						["key"] = "17623981770557419",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2146.5189189189186,
							["y"] = 311.481081081081
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 105201,
							["StartIndex"] = 1,
							["LoadingId"] = 0,
							["IsWhite"] = false
						}
					},
					["17623981770557420"] = {
						["key"] = "17623981770557420",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2168.4007352941176,
							["y"] = 598.3088235294117
						},
						["propsData"] = {}
					},
					["176725712354347180164"] = {
						["key"] = "176725712354347180164",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 1369.055546413315,
							["y"] = 336.13647217591176
						},
						["propsData"] = {
							["SpecialConfigId"] = 12020414,
							["BlackScreenImmediately"] = false
						}
					},
					["17701948110873445049"] = {
						["key"] = "17701948110873445049",
						["type"] = "SkipRegionNode",
						["name"] = "跨区域传送设置玩家位置",
						["pos"] = {
							["x"] = 1850.2527780997793,
							["y"] = 509.86854003322117
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 105201,
							["StartIndex"] = 2,
							["IsWhite"] = false
						}
					}
				},
				["commentData"] = {
					["176725656526442890998"] = {
						["key"] = "176725656526442890998",
						["name"] = "回山外山",
						["position"] = {
							["x"] = 2077.4095586339827,
							["y"] = 188.4443942445467
						},
						["size"] = {
							["width"] = 330.7306291681288,
							["height"] = 305.5249648999648
						}
					}
				}
			}
		}
	},
	["commentData"] = {
		["17623980456225103"] = {
			["key"] = "17623980456225103",
			["name"] = "机巧迷宫特殊任务",
			["position"] = {
				["x"] = 3523.8077657344907,
				["y"] = 1279.0296424684284
			},
			["size"] = {
				["width"] = 527.8125000000002,
				["height"] = 389.0625000000001
			}
		}
	}
}