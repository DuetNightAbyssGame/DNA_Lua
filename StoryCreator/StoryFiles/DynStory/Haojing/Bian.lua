return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1760510005327351797",
			["startPort"] = "StoryStart",
			["endStory"] = "1760510005327351799",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1760510005327351799",
			["startPort"] = "Success",
			["endStory"] = "1760510005327351798",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1760510005327351797"] = {
			["isStoryNode"] = true,
			["key"] = "1760510005327351797",
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
		["1760510005327351798"] = {
			["isStoryNode"] = true,
			["key"] = "1760510005327351798",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1600,
				["y"] = 277.89473684210526
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1760510005327351799"] = {
			["isStoryNode"] = true,
			["key"] = "1760510005327351799",
			["type"] = "StoryNode",
			["name"] = "击杀狴犴",
			["pos"] = {
				["x"] = 1156.842105263158,
				["y"] = 282.6315789473684
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "DynQuest_BianFight_Des",
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
						["startQuest"] = "1760510005327351806",
						["startPort"] = "Out",
						["endQuest"] = "1760510005327351801",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1760510005327351811",
						["startPort"] = "Out",
						["endQuest"] = "1760510005327351810",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760510005327351810",
						["startPort"] = "Out",
						["endQuest"] = "1760510005327351806",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760510005327351800",
						["startPort"] = "QuestStart",
						["endQuest"] = "1760510005327351811",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1760510005327351811",
						["startPort"] = "Out",
						["endQuest"] = "1760510005327351803",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1760510005327351800"] = {
						["key"] = "1760510005327351800",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 532.6086956521738,
							["y"] = 300
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1760510005327351801"] = {
						["key"] = "1760510005327351801",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2131.4275749825624,
							["y"] = 315.2904640116916
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1760510005327351802"] = {
						["key"] = "1760510005327351802",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1760510005327351803"] = {
						["key"] = "1760510005327351803",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1319.9989039093898,
							["y"] = 54.94757033248075
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71006401,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1760510005327351806"] = {
						["key"] = "1760510005327351806",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 1731.541568406019,
							["y"] = 327.22104493971494
						},
						["propsData"] = {
							["DialogueId"] = 0,
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0,
							["UseTalkFadeIn"] = false,
							["TalkFadeInTime"] = 0
						}
					},
					["1760510005327351810"] = {
						["key"] = "1760510005327351810",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1393.3614165616314,
							["y"] = 312.8183678214368
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 2,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2420035,
								2420036
							}
						}
					},
					["1760510005327351811"] = {
						["key"] = "1760510005327351811",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成敌人",
						["pos"] = {
							["x"] = 948.3777383472635,
							["y"] = 327.98905680849384
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2420035,
								2420036
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