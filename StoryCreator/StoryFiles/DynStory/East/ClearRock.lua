return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1766041257771354386",
			["startPort"] = "StoryStart",
			["endStory"] = "1766041260859354493",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1766041260859354493",
			["startPort"] = "Success",
			["endStory"] = "1766041257771354389",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1766041257771354386"] = {
			["isStoryNode"] = true,
			["key"] = "1766041257771354386",
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
		["1766041257771354389"] = {
			["isStoryNode"] = true,
			["key"] = "1766041257771354389",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1812,
				["y"] = 292
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1766041260859354493"] = {
			["isStoryNode"] = true,
			["key"] = "1766041260859354493",
			["type"] = "StoryNode",
			["name"] = "清理岩石",
			["pos"] = {
				["x"] = 1272,
				["y"] = 282
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "DynQuest_ClearRock_Des",
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
						["startQuest"] = "1766041260859354498",
						["startPort"] = "QuestStart",
						["endQuest"] = "1766041260859354501",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1766041260859354503",
						["startPort"] = "Out",
						["endQuest"] = "1766041260859354499",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1766041260859354498",
						["startPort"] = "QuestStart",
						["endQuest"] = "1766041260859354515",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17660486892014599108",
						["startPort"] = "Out",
						["endQuest"] = "17660486970464599336",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17660486970464599336",
						["startPort"] = "Out",
						["endQuest"] = "1766041260859354503",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1766041260859354518",
						["startPort"] = "Out",
						["endQuest"] = "17660487241984600094",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "17660487241984600094",
						["startPort"] = "Out",
						["endQuest"] = "1766041260859354516",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17660487241984600094",
						["startPort"] = "Out",
						["endQuest"] = "17660486892014599108",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17660487795104600440",
						["startPort"] = "Out",
						["endQuest"] = "17660487241984600094",
						["endPort"] = "Input_2"
					},
					{
						["startQuest"] = "17660487804904600472",
						["startPort"] = "Out",
						["endQuest"] = "17660487241984600094",
						["endPort"] = "Input_3"
					},
					{
						["startQuest"] = "17660487241984600094",
						["startPort"] = "Out",
						["endQuest"] = "17684441471591094",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1766041260859354501",
						["startPort"] = "Out",
						["endQuest"] = "1768891740355686",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1766041260859354501",
						["startPort"] = "Out",
						["endQuest"] = "1768891740355687",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1766041260859354501",
						["startPort"] = "Out",
						["endQuest"] = "1768891740355688",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1768891740355686",
						["startPort"] = "Out",
						["endQuest"] = "1766041260859354518",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1768891740355687",
						["startPort"] = "Out",
						["endQuest"] = "17660487795104600440",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1768891740355688",
						["startPort"] = "Out",
						["endQuest"] = "17660487804904600472",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1766041260859354498"] = {
						["key"] = "1766041260859354498",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 552.8,
							["y"] = 248.4
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1766041260859354499"] = {
						["key"] = "1766041260859354499",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3427.785401002507,
							["y"] = 328.3638262322472
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1766041260859354500"] = {
						["key"] = "1766041260859354500",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3003.076923076923,
							["y"] = 1027.6923076923076
						},
						["propsData"] = {}
					},
					["1766041260859354501"] = {
						["key"] = "1766041260859354501",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成碎石",
						["pos"] = {
							["x"] = 910.6723684210529,
							["y"] = 245.23458646616544
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								292060362,
								292060363,
								292060364
							}
						}
					},
					["1766041260859354503"] = {
						["key"] = "1766041260859354503",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 3041.7100478751586,
							["y"] = 317.5233706352129
						},
						["propsData"] = {
							["DialogueId"] = 0,
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0,
							["UseTalkFadeIn"] = false,
							["TalkFadeInTime"] = 0
						}
					},
					["1766041260859354515"] = {
						["key"] = "1766041260859354515",
						["type"] = "TalkNode",
						["name"] = "开车",
						["pos"] = {
							["x"] = 889.1395865430409,
							["y"] = -35.358463343090854
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71008301,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1766041260859354516"] = {
						["key"] = "1766041260859354516",
						["type"] = "TalkNode",
						["name"] = "完成开车",
						["pos"] = {
							["x"] = 2298.45057555403,
							["y"] = -56.30351828814571
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71008302,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1766041260859354518"] = {
						["key"] = "1766041260859354518",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待落石被击毁",
						["pos"] = {
							["x"] = 1546.2868421052628,
							["y"] = 90.94473684210513
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 292060362,
							["StateId"] = 118025,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "Mechanism_Dyn_292060362"
						}
					},
					["17660486892014599108"] = {
						["key"] = "17660486892014599108",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2304.9210568842923,
							["y"] = 297.246900493727
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								292060365
							}
						}
					},
					["17660486970464599336"] = {
						["key"] = "17660486970464599336",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 2636.5000042527136,
							["y"] = 307.084957173889
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 1,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								292060365
							}
						}
					},
					["17660487241984600094"] = {
						["key"] = "17660487241984600094",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "等待任务完成",
						["pos"] = {
							["x"] = 1918.0789516211341,
							["y"] = 275.5060098054679
						},
						["propsData"] = {
							["ListenCount"] = 3,
							["NeedFinishCount"] = 3
						}
					},
					["17660487795104600440"] = {
						["key"] = "17660487795104600440",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待落石被击毁",
						["pos"] = {
							["x"] = 1540.184214779029,
							["y"] = 286.5586413844153
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 292060363,
							["StateId"] = 118025,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "Mechanism_Dyn_292060363"
						}
					},
					["17660487804904600472"] = {
						["key"] = "17660487804904600472",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待落石被击毁",
						["pos"] = {
							["x"] = 1546.1710568842923,
							["y"] = 469.3875887528364
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 292060364,
							["StateId"] = 118025,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "Mechanism_Dyn_292060364"
						}
					},
					["17684441471591094"] = {
						["key"] = "17684441471591094",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 2619.110294117647,
							["y"] = 65.76470588235293
						},
						["propsData"] = {
							["NewDescription"] = "DynQuest_ClearRock_Target1",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["1768891740355686"] = {
						["key"] = "1768891740355686",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待落石被击毁",
						["pos"] = {
							["x"] = 1261.0513136631168,
							["y"] = 80.77857404463433
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 292060362,
							["StateId"] = 118024,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "Mechanism_Dyn_292060362"
						}
					},
					["1768891740355687"] = {
						["key"] = "1768891740355687",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待落石被击毁",
						["pos"] = {
							["x"] = 1254.948686336883,
							["y"] = 276.3924785869445
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 292060363,
							["StateId"] = 118024,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "Mechanism_Dyn_292060363"
						}
					},
					["1768891740355688"] = {
						["key"] = "1768891740355688",
						["type"] = "WaitingMechanismEnterStateNode",
						["name"] = "等待落石被击毁",
						["pos"] = {
							["x"] = 1260.9355284421463,
							["y"] = 459.2214259553656
						},
						["propsData"] = {
							["CreateType"] = "StaticCreator",
							["CreateId"] = 292060364,
							["StateId"] = 118024,
							["IsGuideEnable"] = true,
							["GuidePointName"] = "Mechanism_Dyn_292060364"
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}