return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17677843353621",
			["startPort"] = "StoryStart",
			["endStory"] = "1767784462152186",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1767784462152186",
			["startPort"] = "Success",
			["endStory"] = "17677843353625",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17677843353621"] = {
			["isStoryNode"] = true,
			["key"] = "17677843353621",
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
		["17677843353625"] = {
			["isStoryNode"] = true,
			["key"] = "17677843353625",
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
		["1767784462152186"] = {
			["isStoryNode"] = true,
			["key"] = "1767784462152186",
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
						["startQuest"] = "1768649023962291",
						["startPort"] = "Out",
						["endQuest"] = "1768649023962292",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1767784462152187",
						["startPort"] = "QuestStart",
						["endQuest"] = "1768649042617718",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1767784462152187",
						["startPort"] = "QuestStart",
						["endQuest"] = "1770122989401379",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1768649042617718",
						["startPort"] = "Out",
						["endQuest"] = "1770122997154607",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770122997154607",
						["startPort"] = "Out",
						["endQuest"] = "1767784462152203",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "1768649023962292",
						["startPort"] = "Out",
						["endQuest"] = "17701230096281012",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17701230096281012",
						["startPort"] = "Out",
						["endQuest"] = "1768649032649451",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770122989401379",
						["startPort"] = "Out",
						["endQuest"] = "1768649023962291",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770122989401379",
						["startPort"] = "Out",
						["endQuest"] = "17719208557502808",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17719208557502808",
						["startPort"] = "Out",
						["endQuest"] = "17728817174284013",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17728817174284013",
						["startPort"] = "Out",
						["endQuest"] = "1767784462152203",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["1767784462152187"] = {
						["key"] = "1767784462152187",
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
					["1767784462152195"] = {
						["key"] = "1767784462152195",
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
					["1767784462152203"] = {
						["key"] = "1767784462152203",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1993.2727272727273,
							["y"] = 870.2727272727273
						},
						["propsData"] = {}
					},
					["1768649023962291"] = {
						["key"] = "1768649023962291",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成鸟",
						["pos"] = {
							["x"] = 1361.6997876522526,
							["y"] = 274.2945482020559
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2360007,
								162360047,
								162360048,
								162360049,
								162360050
							}
						}
					},
					["1768649023962292"] = {
						["key"] = "1768649023962292",
						["type"] = "KillMonsterNode",
						["name"] = "杀鸟",
						["pos"] = {
							["x"] = 1620.3190696514341,
							["y"] = 255.90750438931548
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 5,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2360007,
								162360047,
								162360048,
								162360049,
								162360050
							}
						}
					},
					["1768649032649451"] = {
						["key"] = "1768649032649451",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2184.981381918965,
							["y"] = 300.6398565018075
						},
						["propsData"] = {}
					},
					["1768649042617718"] = {
						["key"] = "1768649042617718",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1176.248934432733,
							["y"] = 883.0378090976218
						},
						["propsData"] = {}
					},
					["1770122989401379"] = {
						["key"] = "1770122989401379",
						["type"] = "ChangeRoleNode",
						["name"] = "切换角色",
						["pos"] = {
							["x"] = 1096.1393813623006,
							["y"] = 242.0740348245729
						},
						["propsData"] = {
							["QuestRoleId"] = 16010101,
							["IsPlayFX"] = false
						}
					},
					["1770122997154607"] = {
						["key"] = "1770122997154607",
						["type"] = "RestoreRoleNode",
						["name"] = "恢复角色",
						["pos"] = {
							["x"] = 1533.2818144499179,
							["y"] = 832.4363579019805
						},
						["propsData"] = {}
					},
					["17701230096281012"] = {
						["key"] = "17701230096281012",
						["type"] = "RestoreRoleNode",
						["name"] = "恢复角色",
						["pos"] = {
							["x"] = 1932.4197454844007,
							["y"] = 282.2325961464944
						},
						["propsData"] = {}
					},
					["17719208557502808"] = {
						["key"] = "17719208557502808",
						["type"] = "CountdownNode",
						["name"] = "倒计时节点",
						["pos"] = {
							["x"] = 1317.5855614973264,
							["y"] = 508.83088235294133
						},
						["propsData"] = {
							["CountdownSeconds"] = 60,
							["OpenUI"] = true,
							["Text"] = "Bird_Escaped",
							["RedCountdownSeconds"] = 15
						}
					},
					["17728817174284013"] = {
						["key"] = "17728817174284013",
						["type"] = "SpecialQuestFailNode",
						["name"] = "特殊任务主动失败",
						["pos"] = {
							["x"] = 1653.8311688311687,
							["y"] = 548.8901515151514
						},
						["propsData"] = {}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}