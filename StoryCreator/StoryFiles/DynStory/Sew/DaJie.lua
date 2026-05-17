return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1732783210501461097",
			["startPort"] = "StoryStart",
			["endStory"] = "1732783210501461099",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1732783210501461099",
			["startPort"] = "Success",
			["endStory"] = "1732783210501461098",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1732783210501461097"] = {
			["isStoryNode"] = true,
			["key"] = "1732783210501461097",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 954,
				["y"] = 315.15384615384613
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
		["1732783210501461098"] = {
			["isStoryNode"] = true,
			["key"] = "1732783210501461098",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1872,
				["y"] = 326
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1732783210501461099"] = {
			["isStoryNode"] = true,
			["key"] = "1732783210501461099",
			["type"] = "StoryNode",
			["name"] = "打劫皎皎",
			["pos"] = {
				["x"] = 1450,
				["y"] = 322
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "DynQuest_DaJie_Des",
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
						["startQuest"] = "1732783210501461100",
						["startPort"] = "QuestStart",
						["endQuest"] = "1732783210501461105",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1732783210501461105",
						["startPort"] = "Out",
						["endQuest"] = "1732783210501461104",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1732783210501461103",
						["startPort"] = "Out",
						["endQuest"] = "1732783210501461107",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1732783210501461104",
						["startPort"] = "Out",
						["endQuest"] = "1732783210501461106",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1732783210501461105",
						["startPort"] = "Out",
						["endQuest"] = "1732783210501461103",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1732783210501461106",
						["startPort"] = "Out",
						["endQuest"] = "1732783210501461101",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1732783210501461100"] = {
						["key"] = "1732783210501461100",
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
					["1732783210501461101"] = {
						["key"] = "1732783210501461101",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2815,
							["y"] = 463.84615384615387
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1732783210501461102"] = {
						["key"] = "1732783210501461102",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1732783210501461103"] = {
						["key"] = "1732783210501461103",
						["type"] = "ListenActorDestroyNode",
						["name"] = "监听Actor销毁节点",
						["pos"] = {
							["x"] = 1672.5705037996056,
							["y"] = 274.3357725865465
						},
						["propsData"] = {
							["StaticCreatorId"] = 1720181,
							["DestroyReason"] = "MonsterInitiate"
						}
					},
					["1732783210501461104"] = {
						["key"] = "1732783210501461104",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1670.704475091472,
							["y"] = 489.0726146918097
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 1,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								1720181
							}
						}
					},
					["1732783210501461105"] = {
						["key"] = "1732783210501461105",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "打劫皎皎出现",
						["pos"] = {
							["x"] = 1217.11595834506,
							["y"] = 296.65634674922603
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1720181
							}
						}
					},
					["1732783210501461106"] = {
						["key"] = "1732783210501461106",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 2148.910216718266,
							["y"] = 479.8142414860681
						},
						["propsData"] = {
							["DialogueId"] = 0,
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0,
							["UseTalkFadeIn"] = false,
							["TalkFadeInTime"] = 0
						}
					},
					["1732783210501461107"] = {
						["key"] = "1732783210501461107",
						["type"] = "DynamicQuestFailNode",
						["name"] = "动态任务主动失败",
						["pos"] = {
							["x"] = 2147.7563705644197,
							["y"] = 275.7049297451773
						},
						["propsData"] = {
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}