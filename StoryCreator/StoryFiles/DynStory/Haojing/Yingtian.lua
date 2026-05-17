return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17580915851121286084",
			["startPort"] = "StoryStart",
			["endStory"] = "17580915868561286151",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17580915868561286151",
			["startPort"] = "Success",
			["endStory"] = "17580915851121286087",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17580915851121286084"] = {
			["isStoryNode"] = true,
			["key"] = "17580915851121286084",
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
		["17580915851121286087"] = {
			["isStoryNode"] = true,
			["key"] = "17580915851121286087",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1594,
				["y"] = 302
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17580915868561286151"] = {
			["isStoryNode"] = true,
			["key"] = "17580915868561286151",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1164,
				["y"] = 292
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "DynQuest_Yingtian_Des",
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
						["startQuest"] = "17580915868561286152",
						["startPort"] = "QuestStart",
						["endQuest"] = "17580916023071286627",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17580916023071286627",
						["startPort"] = "Out",
						["endQuest"] = "17580934578691547",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17580916023071286627",
						["startPort"] = "Out",
						["endQuest"] = "17580934629571683",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17580934578691547",
						["startPort"] = "Out",
						["endQuest"] = "17580934851582146",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17580934851582146",
						["startPort"] = "Out",
						["endQuest"] = "17580934990482790",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17580934851582146",
						["startPort"] = "Out",
						["endQuest"] = "17580935055653042",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17580936972004702",
						["startPort"] = "Out",
						["endQuest"] = "17580915868561286155",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17580936804174163",
						["startPort"] = "Out",
						["endQuest"] = "17580936972004702",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17580934990482790",
						["startPort"] = "Out",
						["endQuest"] = "17580936588683535",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17580936588683535",
						["startPort"] = "Out",
						["endQuest"] = "17580936804174163",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "17580935055653042",
						["startPort"] = "Out",
						["endQuest"] = "17580960415191744",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17580960415191744",
						["startPort"] = "Out",
						["endQuest"] = "17580936804174163",
						["endPort"] = "Input_2"
					}
				},
				["nodeData"] = {
					["17580915868561286152"] = {
						["key"] = "17580915868561286152",
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
					["17580915868561286155"] = {
						["key"] = "17580915868561286155",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3756.0555234239446,
							["y"] = 360.16483516483515
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17580915868561286158"] = {
						["key"] = "17580915868561286158",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 4068.9126662810877,
							["y"] = 691.5934065934066
						},
						["propsData"] = {}
					},
					["17580916023071286627"] = {
						["key"] = "17580916023071286627",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成应天侍",
						["pos"] = {
							["x"] = 1180.1774193548388,
							["y"] = 304.7096774193548
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2430007,
								2430008,
								2430009,
								2430010,
								2430011,
								2430012,
								2430013,
								2430014
							}
						}
					},
					["17580934578691547"] = {
						["key"] = "17580934578691547",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1637.495710740872,
							["y"] = 310.44665012406944
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 8,
							["IsShow"] = true,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2430007,
								2430008,
								2430009,
								2430010,
								2430011,
								2430012,
								2430013,
								2430014
							}
						}
					},
					["17580934629571683"] = {
						["key"] = "17580934629571683",
						["type"] = "TalkNode",
						["name"] = "开车对话",
						["pos"] = {
							["x"] = 1647.1731300957103,
							["y"] = 55.93052109181135
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71007401,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17580934851582146"] = {
						["key"] = "17580934851582146",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2013.9473236440979,
							["y"] = 324.96277915632743
						},
						["propsData"] = {
							["WaitTime"] = 3
						}
					},
					["17580934990482790"] = {
						["key"] = "17580934990482790",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成应天侍",
						["pos"] = {
							["x"] = 2335.859545802739,
							["y"] = 263.4905204462028
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2430015,
								2430016,
								2430017,
								2430018,
								2430019
							}
						}
					},
					["17580935055653042"] = {
						["key"] = "17580935055653042",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成应天尉",
						["pos"] = {
							["x"] = 2325.888340537416,
							["y"] = 429.0523850521852
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2430020,
								2430021
							}
						}
					},
					["17580936588683535"] = {
						["key"] = "17580936588683535",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 2704.5946342437096,
							["y"] = 232.933503933304
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 5,
							["IsShow"] = true,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2430015,
								2430016,
								2430017,
								2430018,
								2430019
							}
						}
					},
					["17580936804174163"] = {
						["key"] = "17580936804174163",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "等待任务完成",
						["pos"] = {
							["x"] = 3072.190788089864,
							["y"] = 347.7411962409964
						},
						["propsData"] = {
							["ListenCount"] = 2,
							["NeedFinishCount"] = 2
						}
					},
					["17580936972004702"] = {
						["key"] = "17580936972004702",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 3400.1990298481055,
							["y"] = 365.3098775596777
						},
						["propsData"] = {
							["DialogueId"] = 0,
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0,
							["UseTalkFadeIn"] = false,
							["TalkFadeInTime"] = 0
						}
					},
					["17580960415191744"] = {
						["key"] = "17580960415191744",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 2734.25,
							["y"] = 422.51470588235304
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 2,
							["IsShow"] = true,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2430020,
								2430021
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