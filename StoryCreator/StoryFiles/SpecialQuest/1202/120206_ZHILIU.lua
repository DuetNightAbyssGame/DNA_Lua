return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17726294713612370731",
			["startPort"] = "StoryStart",
			["endStory"] = "17726294713622370733",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17726294713622370733",
			["startPort"] = "Success",
			["endStory"] = "17726294713622370732",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17726294713612370731"] = {
			["isStoryNode"] = true,
			["key"] = "17726294713612370731",
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
		["17726294713622370732"] = {
			["isStoryNode"] = true,
			["key"] = "17726294713622370732",
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
		["17726294713622370733"] = {
			["isStoryNode"] = true,
			["key"] = "17726294713622370733",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1475.2,
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
						["startQuest"] = "17726294713622370734",
						["startPort"] = "QuestStart",
						["endQuest"] = "17726294713622370737",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17726294713622370734",
						["startPort"] = "QuestStart",
						["endQuest"] = "17726294713622370739",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17726294713622370739",
						["startPort"] = "Out",
						["endQuest"] = "17726294713622370736",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17726294713622370737",
						["startPort"] = "Out",
						["endQuest"] = "17726294713622370740",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17726294713622370740",
						["startPort"] = "Out",
						["endQuest"] = "17726294713622370741",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17726294713622370740",
						["startPort"] = "Out",
						["endQuest"] = "17725493296112191",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17725493296112191",
						["startPort"] = "Out",
						["endQuest"] = "1772701294641870",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772701294641870",
						["startPort"] = "Out",
						["endQuest"] = "17726294713622370738",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17725493296112191"] = {
						["key"] = "17725493296112191",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1898.608918210728,
							["y"] = 320.71975725005893
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 100001,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_12020620nvzhu_242380002",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1202/12048304.12048304'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East02_12020621",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = false,
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
					["17726294713622370734"] = {
						["key"] = "17726294713622370734",
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
					["17726294713622370735"] = {
						["key"] = "17726294713622370735",
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
					["17726294713622370736"] = {
						["key"] = "17726294713622370736",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1781.875,
							["y"] = 692.5
						},
						["propsData"] = {}
					},
					["17726294713622370737"] = {
						["key"] = "17726294713622370737",
						["type"] = "ChangeRoleNode",
						["name"] = "切换角色",
						["pos"] = {
							["x"] = 1132.9686520376176,
							["y"] = 314.170062695925
						},
						["propsData"] = {
							["QuestRoleId"] = 41020101,
							["IsPlayFX"] = false
						}
					},
					["17726294713622370738"] = {
						["key"] = "17726294713622370738",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2487.73814229249,
							["y"] = 330.06867588932846
						},
						["propsData"] = {}
					},
					["17726294713622370739"] = {
						["key"] = "17726294713622370739",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1457.368489886073,
							["y"] = 672.9369913973497
						},
						["propsData"] = {}
					},
					["17726294713622370740"] = {
						["key"] = "17726294713622370740",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1434.3993340419172,
							["y"] = 321.5619913973498
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								242380002,
								242380004,
								242380005
							}
						}
					},
					["17726294713622370741"] = {
						["key"] = "17726294713622370741",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1774.2425994463933,
							["y"] = 116.32203475727982
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12049139,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1772701287129698"] = {
						["key"] = "1772701287129698",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1328.0862068965516,
							["y"] = -67.59913793103453
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								242380004,
								242380005
							}
						}
					},
					["1772701294641870"] = {
						["key"] = "1772701294641870",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2246.2573891625616,
							["y"] = 360.2456896551723
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								242380002,
								242380004,
								242380005
							}
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}