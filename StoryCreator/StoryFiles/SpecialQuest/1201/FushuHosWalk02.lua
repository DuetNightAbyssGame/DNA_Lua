return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17636379316421",
			["startPort"] = "StoryStart",
			["endStory"] = "176363793557488",
			["endPort"] = "In"
		},
		{
			["startStory"] = "176363793557488",
			["startPort"] = "Success",
			["endStory"] = "17636379316435",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17636379316421"] = {
			["isStoryNode"] = true,
			["key"] = "17636379316421",
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
		["17636379316435"] = {
			["isStoryNode"] = true,
			["key"] = "17636379316435",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1800,
				["y"] = 302
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["176363793557488"] = {
			["isStoryNode"] = true,
			["key"] = "176363793557488",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1284,
				["y"] = 300
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
						["startQuest"] = "1763637947466448",
						["startPort"] = "Out",
						["endQuest"] = "1763637947466447",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763637947466447",
						["startPort"] = "Out",
						["endQuest"] = "1763637947466449",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176363793557489",
						["startPort"] = "QuestStart",
						["endQuest"] = "1763637947466448",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763637947466449",
						["startPort"] = "Out",
						["endQuest"] = "1763637964358698",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1763637972711929",
						["startPort"] = "Out",
						["endQuest"] = "1763637935574103",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "1763637969070769",
						["startPort"] = "Out",
						["endQuest"] = "1763637972711929",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176363793557489",
						["startPort"] = "QuestStart",
						["endQuest"] = "1763637969070769",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176363793557489",
						["startPort"] = "QuestStart",
						["endQuest"] = "176537194275455835729",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["176363793557489"] = {
						["key"] = "176363793557489",
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
					["176363793557496"] = {
						["key"] = "176363793557496",
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
					["1763637935574103"] = {
						["key"] = "1763637935574103",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2230,
							["y"] = 660
						},
						["propsData"] = {}
					},
					["1763637947466447"] = {
						["key"] = "1763637947466447",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1492.7754377543733,
							["y"] = 284.65582611832605
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1930095,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_1930095"
						}
					},
					["1763637947466448"] = {
						["key"] = "1763637947466448",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成扶疏魅影",
						["pos"] = {
							["x"] = 1216.5074675324672,
							["y"] = 286.58163829166244
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2070211
							}
						}
					},
					["1763637947466449"] = {
						["key"] = "1763637947466449",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁扶疏魅影",
						["pos"] = {
							["x"] = 1789.4925324675323,
							["y"] = 293.9186512786756
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2070211
							}
						}
					},
					["1763637964358698"] = {
						["key"] = "1763637964358698",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2106,
							["y"] = 278
						},
						["propsData"] = {}
					},
					["1763637969070769"] = {
						["key"] = "1763637969070769",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1592,
							["y"] = 632
						},
						["propsData"] = {}
					},
					["1763637972711929"] = {
						["key"] = "1763637972711929",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁扶疏魅影",
						["pos"] = {
							["x"] = 1898,
							["y"] = 648
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2070211
							}
						}
					},
					["176537194275455835729"] = {
						["key"] = "176537194275455835729",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成女孩",
						["pos"] = {
							["x"] = 1198.6297729618166,
							["y"] = 138.33307533539738
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2070207
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