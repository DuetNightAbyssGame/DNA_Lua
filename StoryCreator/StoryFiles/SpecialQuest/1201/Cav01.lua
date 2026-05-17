return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1753253151804594094",
			["startPort"] = "StoryStart",
			["endStory"] = "1753253151804594096",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1753253151804594096",
			["startPort"] = "Success",
			["endStory"] = "1753253151804594095",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1753253151804594094"] = {
			["isStoryNode"] = true,
			["key"] = "1753253151804594094",
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
		["1753253151804594095"] = {
			["isStoryNode"] = true,
			["key"] = "1753253151804594095",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1446.5384615384612,
				["y"] = 302.66578249336874
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1753253151804594096"] = {
			["isStoryNode"] = true,
			["key"] = "1753253151804594096",
			["type"] = "StoryNode",
			["name"] = "第一战",
			["pos"] = {
				["x"] = 1102.4137931034484,
				["y"] = 288.62068965517244
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120102_14",
				["QuestDeatil"] = "Content_120102_14",
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
						["startQuest"] = "1753253151805594097",
						["startPort"] = "QuestStart",
						["endQuest"] = "1753253151805594100",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753253151805594100",
						["startPort"] = "Out",
						["endQuest"] = "1753253151805594099",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17532526907392650",
						["startPort"] = "Out",
						["endQuest"] = "17532555191312941018",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17532555191312941018",
						["startPort"] = "Out",
						["endQuest"] = "17532561421092941368",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17532526907392649",
						["startPort"] = "Out",
						["endQuest"] = "17532526907392650",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17532526907392650",
						["startPort"] = "Out",
						["endQuest"] = "17536768431961375",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753253151805594097",
						["startPort"] = "QuestStart",
						["endQuest"] = "17623238822591729",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753253151805594097",
						["startPort"] = "QuestStart",
						["endQuest"] = "17623278100571371743",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17623278100571371743",
						["startPort"] = "Out",
						["endQuest"] = "17532526907392649",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17532561421092941368",
						["startPort"] = "Out",
						["endQuest"] = "17532562666033589816",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17623238822591729",
						["startPort"] = "Out",
						["endQuest"] = "17623341742962743854",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1753253151805594097",
						["startPort"] = "QuestStart",
						["endQuest"] = "17646823882822865567",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17532526907392649"] = {
						["key"] = "17532526907392649",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 4173.392008148507,
							["y"] = 464.7559309873182
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2040004,
								2040005,
								2040006,
								2040007,
								2040080,
								2040091,
								2040092
							}
						}
					},
					["17532526907392650"] = {
						["key"] = "17532526907392650",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 4176.598989372692,
							["y"] = 618.9563577792695
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 7,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2040004,
								2040005,
								2040006,
								2040007,
								2040080,
								2040091,
								2040092
							}
						}
					},
					["1753253151805594097"] = {
						["key"] = "1753253151805594097",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 3523.231005750356,
							["y"] = 826.1651978912043
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1753253151805594098"] = {
						["key"] = "1753253151805594098",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 4600.655286252576,
							["y"] = 962.6099258576946
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1753253151805594099"] = {
						["key"] = "1753253151805594099",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 4230.448137599383,
							["y"] = 953.6142837035122
						},
						["propsData"] = {}
					},
					["1753253151805594100"] = {
						["key"] = "1753253151805594100",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 3875.0289193026615,
							["y"] = 939.6948718082751
						},
						["propsData"] = {}
					},
					["17532555191312941018"] = {
						["key"] = "17532555191312941018",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 4513.491452892093,
							["y"] = 461.45796843111424
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2040078,
								2040079
							}
						}
					},
					["17532561421092941368"] = {
						["key"] = "17532561421092941368",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 4513.318088816554,
							["y"] = 611.8572786690432
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 2,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2040078,
								2040079
							}
						}
					},
					["17532562666033589816"] = {
						["key"] = "17532562666033589816",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 4912.461656480774,
							["y"] = 606.3659409218234
						},
						["propsData"] = {}
					},
					["17536768431961375"] = {
						["key"] = "17536768431961375",
						["type"] = "TalkNode",
						["name"] = "开车- 战斗前",
						["pos"] = {
							["x"] = 4492.5516546539575,
							["y"] = 274.1102327624067
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12011201,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17623238822591729"] = {
						["key"] = "17623238822591729",
						["type"] = "SendMessageNode",
						["name"] = "发送消息【怪物登场】",
						["pos"] = {
							["x"] = 3880.693679152544,
							["y"] = 462.8757089771626
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "ShowCavHeilang",
							["UnitId"] = -1
						}
					},
					["17623278100571371743"] = {
						["key"] = "17623278100571371743",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 3874.6287440876094,
							["y"] = 624.331120232574
						},
						["propsData"] = {
							["WaitTime"] = 2
						}
					},
					["17623341742962743854"] = {
						["key"] = "17623341742962743854",
						["type"] = "TalkNode",
						["name"] = "开车- 战斗前",
						["pos"] = {
							["x"] = 3880.170613088173,
							["y"] = 281.69726930089695
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12011104,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17646823882822865567"] = {
						["key"] = "17646823882822865567",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 3880,
							["y"] = 102
						},
						["propsData"] = {
							["NewDescription"] = "Description_120102_5",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}