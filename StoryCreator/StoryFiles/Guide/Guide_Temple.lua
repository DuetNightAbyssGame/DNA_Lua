return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17230182491564426",
			["startPort"] = "StoryStart",
			["endStory"] = "17230182519904709",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17230182519904709",
			["startPort"] = "Success",
			["endStory"] = "17230182491564429",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17230182491564426"] = {
			["isStoryNode"] = true,
			["key"] = "17230182491564426",
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
		["17230182491564429"] = {
			["isStoryNode"] = true,
			["key"] = "17230182491564429",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2800,
				["y"] = 300
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17230182519904709"] = {
			["isStoryNode"] = true,
			["key"] = "17230182519904709",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1618.923076923077,
				["y"] = 356.61538461538464
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
						["startQuest"] = "17230182519904710",
						["startPort"] = "QuestStart",
						["endQuest"] = "17230182596885538",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17230182596885538",
						["startPort"] = "Out",
						["endQuest"] = "17230182519914713",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17230182519904710"] = {
						["key"] = "17230182519904710",
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
					["17230182519914713"] = {
						["key"] = "17230182519914713",
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
					["17230182519914716"] = {
						["key"] = "17230182519914716",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17230182596885538"] = {
						["key"] = "17230182596885538",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 1707.5384615384617,
							["y"] = 371.3846153846155
						},
						["propsData"] = {
							["GuideId"] = 43
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}