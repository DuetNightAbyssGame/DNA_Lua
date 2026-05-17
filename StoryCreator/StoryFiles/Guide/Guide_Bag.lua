return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1700639764090127472",
			["startPort"] = "StoryStart",
			["endStory"] = "1700639766279127601",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1700639766279127601",
			["startPort"] = "Success",
			["endStory"] = "1700639764090127475",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1700639764090127472"] = {
			["isStoryNode"] = true,
			["key"] = "1700639764090127472",
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
		["1700639764090127475"] = {
			["isStoryNode"] = true,
			["key"] = "1700639764090127475",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1650.0000000000007,
				["y"] = 351.66666666666663
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1700639766279127601"] = {
			["isStoryNode"] = true,
			["key"] = "1700639766279127601",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1243.3959595959593,
				["y"] = 314.9621212121213
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
						["startQuest"] = "1700640792826143489",
						["startPort"] = "Out",
						["endQuest"] = "1700639766279127604",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1700639766279127602",
						["startPort"] = "QuestStart",
						["endQuest"] = "1719393591746407809",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1719393591746407809",
						["startPort"] = "Out",
						["endQuest"] = "1700640792826143489",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1700639766279127602"] = {
						["key"] = "1700639766279127602",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 421.6666666666666,
							["y"] = 300.8695652173913
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1700639766279127604"] = {
						["key"] = "1700639766279127604",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1521.4973847662636,
							["y"] = 330.8174239947695
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1700639766279127606"] = {
						["key"] = "1700639766279127606",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1700640792826143489"] = {
						["key"] = "1700640792826143489",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 1051.2831168187367,
							["y"] = 306.8204609019863
						},
						["propsData"] = {
							["MessageId"] = 300102,
							["MessageNote"] = "在近战武器配置界面中，可以查看近战武器的属性、为近战武器升级、替换其他近战武器等。",
							["IsTimePause"] = true,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = true,
							["IsForbidOutAnim"] = false,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					},
					["1719393591746407809"] = {
						["key"] = "1719393591746407809",
						["type"] = "ShowGuideTextNode",
						["name"] = "Text显示信息",
						["pos"] = {
							["x"] = 759.6011098236809,
							["y"] = 299.72519765535293
						},
						["propsData"] = {
							["MessageId"] = 300101,
							["MessageNote"] = "在近战武器配置界面中，可以查看近战武器的属性、为近战武器升级、替换其他近战武器等。",
							["IsTimePause"] = true,
							["IsResetPlayer"] = false,
							["IsForbidInAnim"] = false,
							["IsForbidOutAnim"] = true,
							["GuideManPosEnum"] = "DownLeft",
							["GuidemanHead"] = "Bai_Idle"
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}