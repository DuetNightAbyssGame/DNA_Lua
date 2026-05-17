return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17678537949081014464",
			["startPort"] = "StoryStart",
			["endStory"] = "17678537949081014466",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17678537949081014466",
			["startPort"] = "Success",
			["endStory"] = "17678537949081014465",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17678537949081014464"] = {
			["isStoryNode"] = true,
			["key"] = "17678537949081014464",
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
		["17678537949081014465"] = {
			["isStoryNode"] = true,
			["key"] = "17678537949081014465",
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
		["17678537949081014466"] = {
			["isStoryNode"] = true,
			["key"] = "17678537949081014466",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1681.2307692307693,
				["y"] = 395.84615384615387
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
						["startQuest"] = "1769845067925760710",
						["startPort"] = "Out",
						["endQuest"] = "1769845067925760711",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17678537949081014467",
						["startPort"] = "QuestStart",
						["endQuest"] = "1769845067925760704",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769845067925760704",
						["startPort"] = "Out",
						["endQuest"] = "17678537949081014469",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17678537949081014467",
						["startPort"] = "QuestStart",
						["endQuest"] = "1769845067925760708",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769845067925760707",
						["startPort"] = "Out",
						["endQuest"] = "1769845067925760703",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769845067925760711",
						["startPort"] = "Out",
						["endQuest"] = "1772700040243820400",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772700040243820400",
						["startPort"] = "Out",
						["endQuest"] = "1769845067925760707",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769845067925760709",
						["startPort"] = "Out",
						["endQuest"] = "17727002314222454649",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17727002314222454649",
						["startPort"] = "Region_1",
						["endQuest"] = "17727002569852455259",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17727002314222454649",
						["startPort"] = "Region_2",
						["endQuest"] = "1769845067925760710",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17678537949081014467",
						["startPort"] = "QuestStart",
						["endQuest"] = "17733919443211683836",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17734948303383377794",
						["startPort"] = "Out",
						["endQuest"] = "17734948303383377795",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17678537949081014467",
						["startPort"] = "QuestStart",
						["endQuest"] = "17734948303383377794",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17734948303383377795",
						["startPort"] = "Out",
						["endQuest"] = "1769845067925760709",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17678537949081014467"] = {
						["key"] = "17678537949081014467",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 402.74509803921563,
							["y"] = 304.11764705882354
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17678537949081014468"] = {
						["key"] = "17678537949081014468",
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
					["17678537949081014469"] = {
						["key"] = "17678537949081014469",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1650.8695652173913,
							["y"] = 810.8695652173913
						},
						["propsData"] = {}
					},
					["1769845067925760703"] = {
						["key"] = "1769845067925760703",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 1747.4464323667207,
							["y"] = 512.178066337106
						},
						["propsData"] = {}
					},
					["1769845067925760704"] = {
						["key"] = "1769845067925760704",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1341.805518332465,
							["y"] = 806.3003975441943
						},
						["propsData"] = {}
					},
					["1769845067925760707"] = {
						["key"] = "1769845067925760707",
						["type"] = "TalkNode",
						["name"] = "【East02_FixSimple_50】进止流幻境，止流说自己要弑神",
						["pos"] = {
							["x"] = 1465.5585861404807,
							["y"] = 506.2141204855093
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 240001,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_12020101zhiliu_2010033",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = false,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1202/12045101.12045101'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East02_12020101",
							["BlendInTime"] = 2,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = true,
							["StartFadeOutTime"] = 0.5,
							["StartScreenEffectDuration"] = 1,
							["FinishFadeInTime"] = 0,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = true,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = false,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["1769845067925760708"] = {
						["key"] = "1769845067925760708",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1180.2027613492735,
							["y"] = -154.56658777010992
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12049116,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1769845067925760709"] = {
						["key"] = "1769845067925760709",
						["type"] = "SendMessageNode",
						["name"] = "开启小黑屋玩法",
						["pos"] = {
							["x"] = 1160.275495000718,
							["y"] = 295.70567372404076
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "StartBox2",
							["UnitId"] = -1
						}
					},
					["1769845067925760710"] = {
						["key"] = "1769845067925760710",
						["type"] = "BossBattleFinishNode",
						["name"] = "完成BOSS战阶段",
						["pos"] = {
							["x"] = 1777.0367443294333,
							["y"] = 233.93093813146416
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "OpenTheDoor2"
						}
					},
					["1769845067925760711"] = {
						["key"] = "1769845067925760711",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 2198.9420008042343,
							["y"] = 177.96870068744528
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 105602,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["1772700040243820400"] = {
						["key"] = "1772700040243820400",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2504.1760394748017,
							["y"] = 189.62724938460227
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2010033
							}
						}
					},
					["17727002314222454649"] = {
						["key"] = "17727002314222454649",
						["type"] = "JudgeRegionNode",
						["name"] = "判断位于区域",
						["pos"] = {
							["x"] = 1423.640735698119,
							["y"] = 224.85672393304236
						},
						["propsData"] = {
							["IsWaitingEnterRegion"] = false,
							["RegionIds"] = {
								105602,
								105601
							}
						}
					},
					["17727002569852455259"] = {
						["key"] = "17727002569852455259",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1790.1678292941779,
							["y"] = 35.54637910545625
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "XHWstart",
							["FadeIn"] = false,
							["FadeOut"] = true,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17733919443211683836"] = {
						["key"] = "17733919443211683836",
						["type"] = "StandAloneBlackScreenNode",
						["name"] = "独立黑屏节点",
						["pos"] = {
							["x"] = 1193.500989162751,
							["y"] = -295.1581435531547
						},
						["propsData"] = {
							["FadeInSeconds"] = 0,
							["FadeOutSeconds"] = 0.5,
							["DurationSeconds"] = 0.5,
							["IsStandAlone"] = false
						}
					},
					["17734948303383377794"] = {
						["key"] = "17734948303383377794",
						["type"] = "SendMessageNode",
						["name"] = "开启小黑屋玩法",
						["pos"] = {
							["x"] = 667.9185893655707,
							["y"] = 328.7371646026829
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "ReStartBox2",
							["UnitId"] = -1
						}
					},
					["17734948303383377795"] = {
						["key"] = "17734948303383377795",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 924.1685893655707,
							["y"] = 310.2174277605776
						},
						["propsData"] = {
							["WaitTime"] = 1.5
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}