return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17678537949091014704",
			["startPort"] = "StoryStart",
			["endStory"] = "17678537949091014706",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17678537949091014706",
			["startPort"] = "Success",
			["endStory"] = "17678537949091014705",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17678537949091014704"] = {
			["isStoryNode"] = true,
			["key"] = "17678537949091014704",
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
		["17678537949091014705"] = {
			["isStoryNode"] = true,
			["key"] = "17678537949091014705",
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
		["17678537949091014706"] = {
			["isStoryNode"] = true,
			["key"] = "17678537949091014706",
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
						["startQuest"] = "17678537949091014707",
						["startPort"] = "QuestStart",
						["endQuest"] = "17725503454564025006",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17725503771274025636",
						["startPort"] = "Out",
						["endQuest"] = "17725503431604024950",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17725503637254025359",
						["startPort"] = "Out",
						["endQuest"] = "17725503771274025636",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17678537949091014707",
						["startPort"] = "QuestStart",
						["endQuest"] = "17725504518664027091",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17725504518664027091",
						["startPort"] = "Out",
						["endQuest"] = "17725503637254025359",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17725503454564025006",
						["startPort"] = "Out",
						["endQuest"] = "17727253261141277",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17727253261141277",
						["startPort"] = "Out",
						["endQuest"] = "17678537949091014709",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["17678537949091014707"] = {
						["key"] = "17678537949091014707",
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
					["17678537949091014708"] = {
						["key"] = "17678537949091014708",
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
					["17678537949091014709"] = {
						["key"] = "17678537949091014709",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2141.764705882353,
							["y"] = 934.7058823529412
						},
						["propsData"] = {}
					},
					["17679674645806538632"] = {
						["key"] = "17679674645806538632",
						["type"] = "TalkNode",
						["name"] = "VS双龙（上） 激战",
						["pos"] = {
							["x"] = 2270,
							["y"] = 318
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/Ver01/Ver0102/Ver0102_SC016/SQ_Ver0102_SC016",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = true,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideEffectCreature"] = true,
							["HideMechanismsFX"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["17725503431604024950"] = {
						["key"] = "17725503431604024950",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 1906.881413020882,
							["y"] = 196.81524136837214
						},
						["propsData"] = {}
					},
					["17725503454564025006"] = {
						["key"] = "17725503454564025006",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1377.3814616755794,
							["y"] = 922.2709447415328
						},
						["propsData"] = {}
					},
					["17725503637254025359"] = {
						["key"] = "17725503637254025359",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 1336.8170680143498,
							["y"] = 167.49934294649717
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "BossBattle",
							["UnitId"] = -1
						}
					},
					["17725503771274025636"] = {
						["key"] = "17725503771274025636",
						["type"] = "BossBattleFinishNode",
						["name"] = "成功",
						["pos"] = {
							["x"] = 1596.0316983660775,
							["y"] = 179.97154547515137
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "BossBailong_StoryEnd"
						}
					},
					["17725504518664027091"] = {
						["key"] = "17725504518664027091",
						["type"] = "ChangeRoleNode",
						["name"] = "切换角色",
						["pos"] = {
							["x"] = 1058.5262038605827,
							["y"] = 171.59791910152484
						},
						["propsData"] = {
							["QuestRoleId"] = 16010102,
							["IsPlayFX"] = false
						}
					},
					["17727253261141277"] = {
						["key"] = "17727253261141277",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 1771.4481826260926,
							["y"] = 920.936993185147
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "BossBattleFail",
							["UnitId"] = -1
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}