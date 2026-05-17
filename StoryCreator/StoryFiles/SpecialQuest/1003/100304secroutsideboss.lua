return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17370121184391397895",
			["startPort"] = "StoryStart",
			["endStory"] = "17370121184391397897",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17370121184391397897",
			["startPort"] = "Success",
			["endStory"] = "17370121184391397896",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17370121184391397895"] = {
			["isStoryNode"] = true,
			["key"] = "17370121184391397895",
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
		["17370121184391397896"] = {
			["isStoryNode"] = true,
			["key"] = "17370121184391397896",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1766.4999999999998,
				["y"] = 303
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17370121184391397897"] = {
			["isStoryNode"] = true,
			["key"] = "17370121184391397897",
			["type"] = "StoryNode",
			["name"] = "秘密基地外托斯卡boss",
			["pos"] = {
				["x"] = 1271.7133200133198,
				["y"] = 283.8240426240422
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_1003plus20_1",
				["QuestDeatil"] = "QuestDesc_1003plus20_1",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = false,
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
						["startQuest"] = "17370121184391397901",
						["startPort"] = "QuestStart",
						["endQuest"] = "17375367257172916",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17375367257172916",
						["startPort"] = "Out",
						["endQuest"] = "17370121184391397904",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17370121184391397901",
						["startPort"] = "QuestStart",
						["endQuest"] = "17370121184391397905",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17370121184391397905",
						["startPort"] = "Out",
						["endQuest"] = "1745567009920555658",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1745567009920555658",
						["startPort"] = "Out",
						["endQuest"] = "17370121184391397903",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17370121184391397901",
						["startPort"] = "QuestStart",
						["endQuest"] = "1750150983705388",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17370121184391397901",
						["startPort"] = "QuestStart",
						["endQuest"] = "1758013775481962685",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17370121184391397901"] = {
						["key"] = "17370121184391397901",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -2944.4655843674846,
							["y"] = 304.2587136722017
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17370121184391397902"] = {
						["key"] = "17370121184391397902",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = -286.7442432249326,
							["y"] = 272.00458799303175
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17370121184391397903"] = {
						["key"] = "17370121184391397903",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = -844.318762345504,
							["y"] = 637.7808922771897
						},
						["propsData"] = {}
					},
					["17370121184391397904"] = {
						["key"] = "17370121184391397904",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = -1260.1635259401914,
							["y"] = 279.67846059651504
						},
						["propsData"] = {}
					},
					["17370121184391397905"] = {
						["key"] = "17370121184391397905",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = -2596.33393644539,
							["y"] = 863.3936043316846
						},
						["propsData"] = {}
					},
					["17375367257172916"] = {
						["key"] = "17375367257172916",
						["type"] = "BossBattleFinishNode",
						["name"] = "完成BOSS战阶段",
						["pos"] = {
							["x"] = -2129.4031377285637,
							["y"] = 273.3047672863868
						},
						["propsData"] = {
							["SendMessage"] = "cp2secoutsidebossbegin",
							["FinishCondition"] = "cp2secoutsidebossfinish"
						}
					},
					["1745567009920555658"] = {
						["key"] = "1745567009920555658",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = -1780,
							["y"] = 868
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "cp2secbossrecreate",
							["UnitId"] = -1
						}
					},
					["1750150983705388"] = {
						["key"] = "1750150983705388",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = -2106,
							["y"] = -54.00000000000003
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10035401,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1758013775481962685"] = {
						["key"] = "1758013775481962685",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = -2607.7142857142862,
							["y"] = -68.00000000000017
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/cbt02/0061_scene_ex01_escape",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {
								101103
							},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}