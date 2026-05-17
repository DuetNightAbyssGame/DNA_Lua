return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1772421504261707228",
			["startPort"] = "StoryStart",
			["endStory"] = "1772421504261707230",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1772421504261707230",
			["startPort"] = "Success",
			["endStory"] = "1772421504261707229",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1772421504261707228"] = {
			["isStoryNode"] = true,
			["key"] = "1772421504261707228",
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
		["1772421504261707229"] = {
			["isStoryNode"] = true,
			["key"] = "1772421504261707229",
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
		["1772421504261707230"] = {
			["isStoryNode"] = true,
			["key"] = "1772421504261707230",
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
						["startQuest"] = "17724221886932378798",
						["startPort"] = "Out",
						["endQuest"] = "17724221886932378797",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17724221886932378797",
						["startPort"] = "Out",
						["endQuest"] = "17724221997952379143",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772421504261707231",
						["startPort"] = "QuestStart",
						["endQuest"] = "17724222048822379270",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17724222048822379270",
						["startPort"] = "Out",
						["endQuest"] = "1772421504261707233",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "1772421504261707231",
						["startPort"] = "QuestStart",
						["endQuest"] = "17724330206233961304",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17724330206233961304",
						["startPort"] = "Out",
						["endQuest"] = "17724221886932378798",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1772421504261707231"] = {
						["key"] = "1772421504261707231",
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
					["1772421504261707232"] = {
						["key"] = "1772421504261707232",
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
					["1772421504261707233"] = {
						["key"] = "1772421504261707233",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17724221886932378797"] = {
						["key"] = "17724221886932378797",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1797.1516561238095,
							["y"] = 402.78123786655186
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1202/12047201.12047201'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East02_12020606",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 1,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
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
					["17724221886932378798"] = {
						["key"] = "17724221886932378798",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1416.5301620580085,
							["y"] = 378.1051257698117
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 242010092,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020606hezi_242010092"
						}
					},
					["17724221997952379143"] = {
						["key"] = "17724221997952379143",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2120.1029411764707,
							["y"] = 464.22519701660576
						},
						["propsData"] = {}
					},
					["17724222048822379270"] = {
						["key"] = "17724222048822379270",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1336.5735294117649,
							["y"] = 668.931079369547
						},
						["propsData"] = {}
					},
					["17724330206233961304"] = {
						["key"] = "17724330206233961304",
						["type"] = "ChangeRoleNode",
						["name"] = "切换苏乙",
						["pos"] = {
							["x"] = 1139.7272727272725,
							["y"] = 328.27272727272725
						},
						["propsData"] = {
							["QuestRoleId"] = 15040101,
							["IsPlayFX"] = false
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}