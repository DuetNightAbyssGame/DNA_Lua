return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17683908908941",
			["startPort"] = "StoryStart",
			["endStory"] = "1768390898746188",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1768390898746188",
			["startPort"] = "Success",
			["endStory"] = "17683908908945",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17683908908941"] = {
			["isStoryNode"] = true,
			["key"] = "17683908908941",
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
		["17683908908945"] = {
			["isStoryNode"] = true,
			["key"] = "17683908908945",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1508.7826086956522,
				["y"] = 294.4347826086956
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1768390898746188"] = {
			["isStoryNode"] = true,
			["key"] = "1768390898746188",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1131.1304347826087,
				["y"] = 272.0869565217391
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200313_7",
				["QuestDeatil"] = "Content_200313_7",
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
				["SubRegionId"] = 104107,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_ChenBaiSha_2080432",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1768390929351913",
						["startPort"] = "Out",
						["endQuest"] = "1768390929351914",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1768390929351914",
						["startPort"] = "Out",
						["endQuest"] = "1768390929351916",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1768390929351916",
						["startPort"] = "Out",
						["endQuest"] = "1768390929351918",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1768390929351913",
						["startPort"] = "Out",
						["endQuest"] = "1768390929351915",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1768390929351914",
						["startPort"] = "Out",
						["endQuest"] = "1768390929351917",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1768390929351916",
						["startPort"] = "Out",
						["endQuest"] = "1768390929351919",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1768390929351923",
						["startPort"] = "Out",
						["endQuest"] = "1768390929351921",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1768390929351918",
						["startPort"] = "Out",
						["endQuest"] = "1768390929351923",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "1768390898746189",
						["startPort"] = "QuestStart",
						["endQuest"] = "1768390929351912",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1768390898746189",
						["startPort"] = "QuestStart",
						["endQuest"] = "1768390929351913",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1768390898746189",
						["startPort"] = "QuestStart",
						["endQuest"] = "1768390929351923",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1768390929351918",
						["startPort"] = "Out",
						["endQuest"] = "17683909782932499",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1768390898746189",
						["startPort"] = "QuestStart",
						["endQuest"] = "17683909945562852",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17683909945562852",
						["startPort"] = "Out",
						["endQuest"] = "1768390898747205",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "1768390929351921",
						["startPort"] = "Out",
						["endQuest"] = "17683948106101247",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17683948106101247",
						["startPort"] = "Out",
						["endQuest"] = "1768390898747205",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["1768390898746189"] = {
						["key"] = "1768390898746189",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 629,
							["y"] = 313
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1768390898747197"] = {
						["key"] = "1768390898747197",
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
					["1768390898747205"] = {
						["key"] = "1768390898747205",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2404.666121826305,
							["y"] = 645.7321564781521
						},
						["propsData"] = {}
					},
					["1768390929351912"] = {
						["key"] = "1768390929351912",
						["type"] = "SendMessageNode",
						["name"] = "发送消息给行为树-开始跑步",
						["pos"] = {
							["x"] = 999.0879638087115,
							["y"] = -37.753592685414134
						},
						["propsData"] = {
							["MessageType"] = "BehaviorTree",
							["MessageContent"] = "Goto",
							["UnitId"] = 701091
						}
					},
					["1768390929351913"] = {
						["key"] = "1768390929351913",
						["type"] = "GoToNode",
						["name"] = "前往第一个目标点",
						["pos"] = {
							["x"] = 995.754630475378,
							["y"] = 157.24640731458584
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2080435,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestMechanism_SSS_Huachapaoku1_2080435"
						}
					},
					["1768390929351914"] = {
						["key"] = "1768390929351914",
						["type"] = "GoToNode",
						["name"] = "前往第二个目标点",
						["pos"] = {
							["x"] = 1352.4212971420443,
							["y"] = 160.5797406479192
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2080436,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestMechanism_SSS_Huachapaoku2_2080436"
						}
					},
					["1768390929351915"] = {
						["key"] = "1768390929351915",
						["type"] = "TalkNode",
						["name"] = "开车对话节点",
						["pos"] = {
							["x"] = 1360.7546304753782,
							["y"] = -50.9114874222563
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51153067,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1768390929351916"] = {
						["key"] = "1768390929351916",
						["type"] = "GoToNode",
						["name"] = "前往第三个目标点",
						["pos"] = {
							["x"] = 1691.5879638087108,
							["y"] = 166.41307398125258
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2080437,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestMechanism_SSS_Huachapaoku3_2080437"
						}
					},
					["1768390929351917"] = {
						["key"] = "1768390929351917",
						["type"] = "TalkNode",
						["name"] = "开车对话节点",
						["pos"] = {
							["x"] = 1699.9212971420448,
							["y"] = -41.92025935208079
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51153068,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1768390929351918"] = {
						["key"] = "1768390929351918",
						["type"] = "GoToNode",
						["name"] = "前往终点",
						["pos"] = {
							["x"] = 2012.3061010636134,
							["y"] = 177.7464073145859
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2080438,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestMechanism_SSS_Huachapaoku4_2080438"
						}
					},
					["1768390929351919"] = {
						["key"] = "1768390929351919",
						["type"] = "TalkNode",
						["name"] = "开车对话节点",
						["pos"] = {
							["x"] = 2021.9437822230343,
							["y"] = -30.586926018747477
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51153069,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1768390929351921"] = {
						["key"] = "1768390929351921",
						["type"] = "TalkNode",
						["name"] = "开车对话节点",
						["pos"] = {
							["x"] = 1312.1776509238432,
							["y"] = 626.2979290698532
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51153094,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1768390929351922"] = {
						["key"] = "1768390929351922",
						["type"] = "FailBlackScreenNode",
						["name"] = "失败黑屏节点",
						["pos"] = {
							["x"] = 1679.5241421519136,
							["y"] = 1008.8413119836598
						},
						["propsData"] = {
							["Text"] = "Quest_Tips_20031306",
							["FadeInTime"] = 0,
							["FadeOutTime"] = 0,
							["ContinueTime"] = 1
						}
					},
					["1768390929351923"] = {
						["key"] = "1768390929351923",
						["type"] = "CountdownNode",
						["name"] = "倒计时节点",
						["pos"] = {
							["x"] = 992.7228844436321,
							["y"] = 620.9130739812525
						},
						["propsData"] = {
							["CountdownSeconds"] = 45,
							["OpenUI"] = true,
							["Text"] = "Quest_Tips_20031306",
							["RedCountdownSeconds"] = 5
						}
					},
					["17683909782932499"] = {
						["key"] = "17683909782932499",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2362.921052631579,
							["y"] = 189.33333333333334
						},
						["propsData"] = {}
					},
					["17683909945562852"] = {
						["key"] = "17683909945562852",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 962.6070611310886,
							["y"] = 935.3437942682796
						},
						["propsData"] = {}
					},
					["17683948106101247"] = {
						["key"] = "17683948106101247",
						["type"] = "SpecialQuestFailNode",
						["name"] = "特殊任务主动失败",
						["pos"] = {
							["x"] = 1626.923076923077,
							["y"] = 632.6153846153846
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