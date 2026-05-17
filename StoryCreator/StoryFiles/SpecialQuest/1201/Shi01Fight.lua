return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17627907823105770709",
			["startPort"] = "StoryStart",
			["endStory"] = "17627907823105770711",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17627907823105770711",
			["startPort"] = "Success",
			["endStory"] = "17627907823105770710",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17627907823105770709"] = {
			["isStoryNode"] = true,
			["key"] = "17627907823105770709",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 940,
				["y"] = 310
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
		["17627907823105770710"] = {
			["isStoryNode"] = true,
			["key"] = "17627907823105770710",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1700,
				["y"] = 308
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17627907823105770711"] = {
			["isStoryNode"] = true,
			["key"] = "17627907823105770711",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1308,
				["y"] = 296
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
						["startQuest"] = "1762686293533700",
						["startPort"] = "Out",
						["endQuest"] = "17626863045651001",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1762686293533699",
						["startPort"] = "Out",
						["endQuest"] = "1762686293533700",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17627907823105770712",
						["startPort"] = "QuestStart",
						["endQuest"] = "1762686293533699",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17627907823105770712",
						["startPort"] = "QuestStart",
						["endQuest"] = "17627907823105770716",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1762686293533699",
						["startPort"] = "Out",
						["endQuest"] = "1762686287837535",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17627907823105770712",
						["startPort"] = "QuestStart",
						["endQuest"] = "1764035741860687954",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17627907823105770716",
						["startPort"] = "Out",
						["endQuest"] = "1764035797256688447",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1764035797256688447",
						["startPort"] = "Out",
						["endQuest"] = "17627907823105770714",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17626863045651001",
						["startPort"] = "Out",
						["endQuest"] = "17627907823105770715",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1762686287837535"] = {
						["key"] = "1762686287837535",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1690.6666666666665,
							["y"] = 146.33333333333334
						},
						["propsData"] = {
							["NewDescription"] = "Description_120103_4_1",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["1762686293533699"] = {
						["key"] = "1762686293533699",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1492.0814827730119,
							["y"] = 358.2418997613706
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2100011,
								2100012,
								2100013
							}
						}
					},
					["1762686293533700"] = {
						["key"] = "1762686293533700",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1832.017002075473,
							["y"] = 346.2730033598762
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 3,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2100011,
								2100012,
								2100013
							}
						}
					},
					["17626863045651001"] = {
						["key"] = "17626863045651001",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2098.0340909090905,
							["y"] = 338.45454545454555
						},
						["propsData"] = {
							["WaitTime"] = 3
						}
					},
					["17627907823105770712"] = {
						["key"] = "17627907823105770712",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 1023.3333333333334,
							["y"] = 340
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17627907823105770713"] = {
						["key"] = "17627907823105770713",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2804.5454545454545,
							["y"] = 364.2424242424243
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17627907823105770714"] = {
						["key"] = "17627907823105770714",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2051.6666666666665,
							["y"] = 716.6666666666666
						},
						["propsData"] = {}
					},
					["17627907823105770715"] = {
						["key"] = "17627907823105770715",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2473.5907097288678,
							["y"] = 339.0177717019824
						},
						["propsData"] = {}
					},
					["17627907823105770716"] = {
						["key"] = "17627907823105770716",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1516.0643939393938,
							["y"] = 628.8423331054913
						},
						["propsData"] = {}
					},
					["1764035741860687954"] = {
						["key"] = "1764035741860687954",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 1428,
							["y"] = 42
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/1_1/0131_story_bangfeibangjia",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {
								104109
							},
							["bStoreToServer"] = false
						}
					},
					["1764035797256688447"] = {
						["key"] = "1764035797256688447",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 1800,
							["y"] = 656
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}