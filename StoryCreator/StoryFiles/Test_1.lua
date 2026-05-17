return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1732783211067619161",
			["startPort"] = "StoryStart",
			["endStory"] = "1732783211067619163",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1732783211067619163",
			["startPort"] = "Success",
			["endStory"] = "1732783211067619162",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1732783211067619161"] = {
			["isStoryNode"] = true,
			["key"] = "1732783211067619161",
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
		["1732783211067619162"] = {
			["isStoryNode"] = true,
			["key"] = "1732783211067619162",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1583.3333333333333,
				["y"] = 301.6666666666667
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1732783211067619163"] = {
			["isStoryNode"] = true,
			["key"] = "1732783211067619163",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1218.0478192493704,
				["y"] = 289.0876656393516
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
						["startQuest"] = "1734678041247910339",
						["startPort"] = "Out",
						["endQuest"] = "1732783211067619165",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1732783211067619164",
						["startPort"] = "QuestStart",
						["endQuest"] = "1769419899354370746",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769419899354370746",
						["startPort"] = "Out",
						["endQuest"] = "1732783211067619165",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1732783211067619164"] = {
						["key"] = "1732783211067619164",
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
					["1732783211067619165"] = {
						["key"] = "1732783211067619165",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2261.2428129146397,
							["y"] = 299.1596638655462
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1732783211067619166"] = {
						["key"] = "1732783211067619166",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2233.949579831933,
							["y"] = 494.4537815126051
						},
						["propsData"] = {}
					},
					["1734678041247910339"] = {
						["key"] = "1734678041247910339",
						["type"] = "TalkNode",
						["name"] = "开车-达芙涅求助",
						["pos"] = {
							["x"] = 1433.2631578947367,
							["y"] = 425.2631578947368
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 11011001,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Communicator",
							["OverrideFailBlend"] = false
						}
					},
					["1734678052120910635"] = {
						["key"] = "1734678052120910635",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 1421.8947368421052,
							["y"] = 220.21052631578942
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 2,
							["SoundPath"] = "FMODEvent'/Game/Asset/Audio/FMOD/Events/snapshot/story/ex01_vo_behind_door.ex01_vo_behind_door'",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					},
					["1769419899354370746"] = {
						["key"] = "1769419899354370746",
						["type"] = "ShowOrHideUINode",
						["name"] = "显示或隐藏UI",
						["pos"] = {
							["x"] = 1676,
							["y"] = 6
						},
						["propsData"] = {
							["Function"] = "HideUIInScreen",
							["UIParam"] = "AimIndicator",
							["ActionParam"] = "None",
							["ShowOrHide"] = true
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}