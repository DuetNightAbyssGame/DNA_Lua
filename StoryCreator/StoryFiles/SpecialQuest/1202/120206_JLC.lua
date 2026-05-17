return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17678537949101014848",
			["startPort"] = "StoryStart",
			["endStory"] = "17678537949101014850",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17678537949101014850",
			["startPort"] = "Success",
			["endStory"] = "17678537949101014849",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17678537949101014848"] = {
			["isStoryNode"] = true,
			["key"] = "17678537949101014848",
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
		["17678537949101014849"] = {
			["isStoryNode"] = true,
			["key"] = "17678537949101014849",
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
		["17678537949101014850"] = {
			["isStoryNode"] = true,
			["key"] = "17678537949101014850",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1475.2,
				["y"] = 354
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
						["startQuest"] = "17678537949101014851",
						["startPort"] = "QuestStart",
						["endQuest"] = "1772540019743273",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17678537949101014851",
						["startPort"] = "QuestStart",
						["endQuest"] = "1772540040111776",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772540040111776",
						["startPort"] = "Out",
						["endQuest"] = "17678537949101014853",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "1772540019743273",
						["startPort"] = "Out",
						["endQuest"] = "17725400518231151",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17725400518231151",
						["startPort"] = "Out",
						["endQuest"] = "17725491899151581",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17725400518231151",
						["startPort"] = "Out",
						["endQuest"] = "17726294559481640142",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17726294559481640142",
						["startPort"] = "Out",
						["endQuest"] = "1772540026383439",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17678537949101014851"] = {
						["key"] = "17678537949101014851",
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
					["17678537949101014852"] = {
						["key"] = "17678537949101014852",
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
					["17678537949101014853"] = {
						["key"] = "17678537949101014853",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1781.875,
							["y"] = 692.5
						},
						["propsData"] = {}
					},
					["1772540019743273"] = {
						["key"] = "1772540019743273",
						["type"] = "ChangeRoleNode",
						["name"] = "切换角色",
						["pos"] = {
							["x"] = 1132.9686520376176,
							["y"] = 314.170062695925
						},
						["propsData"] = {
							["QuestRoleId"] = 24010102,
							["IsPlayFX"] = false
						}
					},
					["1772540026383439"] = {
						["key"] = "1772540026383439",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2482.73814229249,
							["y"] = 330.06867588932846
						},
						["propsData"] = {}
					},
					["1772540040111776"] = {
						["key"] = "1772540040111776",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1457.368489886073,
							["y"] = 672.9369913973497
						},
						["propsData"] = {}
					},
					["17725400518231151"] = {
						["key"] = "17725400518231151",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1434.3993340419172,
							["y"] = 321.5619913973498
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								242420163
							}
						}
					},
					["17725491899151581"] = {
						["key"] = "17725491899151581",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1774.2425994463933,
							["y"] = 116.32203475727982
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12049142,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17726294559481640142"] = {
						["key"] = "17726294559481640142",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2031.7759740259742,
							["y"] = 326.7840909090909
						},
						["propsData"] = {
							["GuideUIEnable"] = false,
							["StaticCreatorId"] = 242420161,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020628hezi_242420161"
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}