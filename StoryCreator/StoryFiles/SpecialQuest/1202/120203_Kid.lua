return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17678537949041014010",
			["startPort"] = "StoryStart",
			["endStory"] = "17678537949041014012",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17678537949041014012",
			["startPort"] = "Success",
			["endStory"] = "17678537949041014011",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17678537949041014010"] = {
			["isStoryNode"] = true,
			["key"] = "17678537949041014010",
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
		["17678537949041014011"] = {
			["isStoryNode"] = true,
			["key"] = "17678537949041014011",
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
		["17678537949041014012"] = {
			["isStoryNode"] = true,
			["key"] = "17678537949041014012",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1372,
				["y"] = 352
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
						["startQuest"] = "17678537949041014013",
						["startPort"] = "QuestStart",
						["endQuest"] = "1772440169397334",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772440169397334",
						["startPort"] = "Out",
						["endQuest"] = "17678537949041014015",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "1772440174918473",
						["startPort"] = "Out",
						["endQuest"] = "1772440174918474",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17678537949041014013",
						["startPort"] = "QuestStart",
						["endQuest"] = "1772440179501549",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772440174918474",
						["startPort"] = "Out",
						["endQuest"] = "1772440166174256",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772440179501549",
						["startPort"] = "Out",
						["endQuest"] = "1772631658064269",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772631658064269",
						["startPort"] = "Out",
						["endQuest"] = "1772440174918473",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17678537949041014013"] = {
						["key"] = "17678537949041014013",
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
					["17678537949041014014"] = {
						["key"] = "17678537949041014014",
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
					["17678537949041014015"] = {
						["key"] = "17678537949041014015",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1772440166174256"] = {
						["key"] = "1772440166174256",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2327.2388591800354,
							["y"] = 417.28475935828874
						},
						["propsData"] = {}
					},
					["1772440169397334"] = {
						["key"] = "1772440169397334",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1645.2388591800357,
							["y"] = 657.2847593582887
						},
						["propsData"] = {}
					},
					["1772440174918473"] = {
						["key"] = "1772440174918473",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1627.1905966317731,
							["y"] = 402.8021338756633
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								242360055
							}
						}
					},
					["1772440174918474"] = {
						["key"] = "1772440174918474",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1915.2871217282982,
							["y"] = 399.76738484091425
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 1,
							["IsShow"] = true,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								242360055
							}
						}
					},
					["1772440179501549"] = {
						["key"] = "1772440179501549",
						["type"] = "ChangeRoleNode",
						["name"] = "切换角色",
						["pos"] = {
							["x"] = 1190.667430608607,
							["y"] = 338.070473644003
						},
						["propsData"] = {
							["QuestRoleId"] = 24010102,
							["IsPlayFX"] = false
						}
					},
					["1772631658064269"] = {
						["key"] = "1772631658064269",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1668.8392151326934,
							["y"] = 274.9058441558442
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								242360056
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