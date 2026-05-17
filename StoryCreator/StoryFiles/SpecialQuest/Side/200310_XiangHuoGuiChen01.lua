return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17675160632701",
			["startPort"] = "StoryStart",
			["endStory"] = "1767516098569745",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1767516098569745",
			["startPort"] = "Success",
			["endStory"] = "17675160632715",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17675160632701"] = {
			["isStoryNode"] = true,
			["key"] = "17675160632701",
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
		["17675160632715"] = {
			["isStoryNode"] = true,
			["key"] = "17675160632715",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1537.6923076923076,
				["y"] = 330
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1767516098569745"] = {
			["isStoryNode"] = true,
			["key"] = "1767516098569745",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1178.964558661153,
				["y"] = 299.93706293706293
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200310_3",
				["QuestDeatil"] = "Content_200310_3",
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
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "Point_20031001",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1767516098569746",
						["startPort"] = "QuestStart",
						["endQuest"] = "17675161342491630",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17675161342491630",
						["startPort"] = "Out",
						["endQuest"] = "17675161435321828",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1767516098569746",
						["startPort"] = "QuestStart",
						["endQuest"] = "17675161695852362",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17675161695852362",
						["startPort"] = "Out",
						["endQuest"] = "17675162214452565",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17675162214452565",
						["startPort"] = "Out",
						["endQuest"] = "1767516098570762",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17675161574462188",
						["startPort"] = "Out",
						["endQuest"] = "1767755510882488",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17675161435321828",
						["startPort"] = "Out",
						["endQuest"] = "17675161574462188",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17675161342491630",
						["startPort"] = "Out",
						["endQuest"] = "17677822037203811",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17677822037203811",
						["startPort"] = "Out",
						["endQuest"] = "1767517051360423",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1767516098569746"] = {
						["key"] = "1767516098569746",
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
					["1767516098570754"] = {
						["key"] = "1767516098570754",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2388.5714285714284,
							["y"] = 250.85714285714286
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1767516098570762"] = {
						["key"] = "1767516098570762",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1808.857142857143,
							["y"] = 536.2857142857143
						},
						["propsData"] = {}
					},
					["17675161342491630"] = {
						["key"] = "17675161342491630",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 1221.215193155302,
							["y"] = 285.8905885403163
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "PlaiQuest01Start",
							["UnitId"] = -1
						}
					},
					["17675161435321828"] = {
						["key"] = "17675161435321828",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1523.4319419237747,
							["y"] = 80.42260824474974
						},
						["propsData"] = {
							["KillMonsterType"] = "Nums",
							["MonsterNeedNums"] = 30,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "Point_20031001"
						}
					},
					["17675161574462188"] = {
						["key"] = "17675161574462188",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 1913.8260305937256,
							["y"] = 97.17137671765624
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "PlaiQuest01End",
							["UnitId"] = -1
						}
					},
					["17675161695852362"] = {
						["key"] = "17675161695852362",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1147.766917293233,
							["y"] = 494.5112781954888
						},
						["propsData"] = {}
					},
					["17675162214452565"] = {
						["key"] = "17675162214452565",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 1452.0526315789473,
							["y"] = 523.0827067669173
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "PlaiQuest01End",
							["UnitId"] = -1
						}
					},
					["1767517051360423"] = {
						["key"] = "1767517051360423",
						["type"] = "TalkNode",
						["name"] = "小白开车02",
						["pos"] = {
							["x"] = 1790.8689655172411,
							["y"] = 362.4697768762679
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200310/20031004.20031004'",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1767755510882488"] = {
						["key"] = "1767755510882488",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2214.6206896551726,
							["y"] = 89.58620689655172
						},
						["propsData"] = {}
					},
					["17677822037203811"] = {
						["key"] = "17677822037203811",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1528.6558825850236,
							["y"] = 343.4585601935876
						},
						["propsData"] = {
							["KillMonsterType"] = "Nums",
							["MonsterNeedNums"] = 20,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "Point_20031001"
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}