return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17571622124921867399",
			["startPort"] = "StoryStart",
			["endStory"] = "17571622124921867401",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17571622124921867401",
			["startPort"] = "Success",
			["endStory"] = "17571622124921867400",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17571622124921867399"] = {
			["isStoryNode"] = true,
			["key"] = "17571622124921867399",
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
		["17571622124921867400"] = {
			["isStoryNode"] = true,
			["key"] = "17571622124921867400",
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
		["17571622124921867401"] = {
			["isStoryNode"] = true,
			["key"] = "17571622124921867401",
			["type"] = "StoryNode",
			["name"] = "煜明Boss战",
			["pos"] = {
				["x"] = 1134.4137931034484,
				["y"] = 284.62068965517244
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "",
				["QuestDeatil"] = "Description_120105_14",
				["TaskRegionReName"] = "Content_120105_14",
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
						["startQuest"] = "17571622124921867402",
						["startPort"] = "QuestStart",
						["endQuest"] = "17571622124921867405",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17571622124921867402",
						["startPort"] = "QuestStart",
						["endQuest"] = "1757161939118646405",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17571622124921867405",
						["startPort"] = "Out",
						["endQuest"] = "1762842145674541",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1762842145674540",
						["startPort"] = "Out",
						["endQuest"] = "17628421733111435",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17628421772951562",
						["startPort"] = "Out",
						["endQuest"] = "17571622124921867406",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17571622124921867402",
						["startPort"] = "QuestStart",
						["endQuest"] = "176485663052812753084",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176485663052812753084",
						["startPort"] = "Out",
						["endQuest"] = "1762842145674540",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17628421733111435",
						["startPort"] = "Out",
						["endQuest"] = "176485677235812754050",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176485677235812754050",
						["startPort"] = "Out",
						["endQuest"] = "17628421772951562",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1762842145674541",
						["startPort"] = "Out",
						["endQuest"] = "176485690037412754918",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176485690037412754918",
						["startPort"] = "Out",
						["endQuest"] = "17571622124921867404",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["1757161939118646405"] = {
						["key"] = "1757161939118646405",
						["type"] = "TalkNode",
						["name"] = "开车- 黑龙战斗",
						["pos"] = {
							["x"] = 3875.3723344324126,
							["y"] = 480.3629890996072
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12020101,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17571622124921867402"] = {
						["key"] = "17571622124921867402",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 3281.8673693867195,
							["y"] = 824.801561527568
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17571622124921867403"] = {
						["key"] = "17571622124921867403",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 5400.655286252576,
							["y"] = 1038.3242115719804
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17571622124921867404"] = {
						["key"] = "17571622124921867404",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 4876.928657079901,
							["y"] = 1108.3220759113042
						},
						["propsData"] = {}
					},
					["17571622124921867405"] = {
						["key"] = "17571622124921867405",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 4022.4813002550422,
							["y"] = 1068.7901099035132
						},
						["propsData"] = {}
					},
					["17571622124921867406"] = {
						["key"] = "17571622124921867406",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 5221.7653220181355,
							["y"] = 841.8553301557779
						},
						["propsData"] = {}
					},
					["1762842145674540"] = {
						["key"] = "1762842145674540",
						["type"] = "BossBattleFinishNode",
						["name"] = "BOSS战3开始",
						["pos"] = {
							["x"] = 4022.849112864409,
							["y"] = 824.210354793051
						},
						["propsData"] = {
							["SendMessage"] = "BossBattle",
							["FinishCondition"] = "BossYuming_Create"
						}
					},
					["1762842145674541"] = {
						["key"] = "1762842145674541",
						["type"] = "SendMessageNode",
						["name"] = "发送消息【Boss战失败】",
						["pos"] = {
							["x"] = 4325.096539309504,
							["y"] = 1105.6918191199925
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "BossBattleFail",
							["UnitId"] = -1
						}
					},
					["17628421733111435"] = {
						["key"] = "17628421733111435",
						["type"] = "BossBattleFinishNode",
						["name"] = "BOSS战3成功",
						["pos"] = {
							["x"] = 4338.902173913043,
							["y"] = 823.5978260869565
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "BossYuming_StoryEnd"
						}
					},
					["17628421772951562"] = {
						["key"] = "17628421772951562",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 4871.920948616601,
							["y"] = 829.8023715415019
						},
						["propsData"] = {
							["WaitTime"] = 6
						}
					},
					["176485663052812753084"] = {
						["key"] = "176485663052812753084",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 3711.7990430622,
							["y"] = 824.0526315789475
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/1_1/0129_boss_yuming",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {
								104102
							},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = false
						}
					},
					["176485677235812754050"] = {
						["key"] = "176485677235812754050",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 4608.617224880382,
							["y"] = 839.0526315789474
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					},
					["176485690037412754918"] = {
						["key"] = "176485690037412754918",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 4594.980861244018,
							["y"] = 1099.5071770334928
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}