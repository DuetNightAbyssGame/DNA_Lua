return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1772421504262707508",
			["startPort"] = "StoryStart",
			["endStory"] = "1772421504262707510",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1772421504262707510",
			["startPort"] = "Success",
			["endStory"] = "1772421504262707509",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1772421504262707508"] = {
			["isStoryNode"] = true,
			["key"] = "1772421504262707508",
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
		["1772421504262707509"] = {
			["isStoryNode"] = true,
			["key"] = "1772421504262707509",
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
		["1772421504262707510"] = {
			["isStoryNode"] = true,
			["key"] = "1772421504262707510",
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
						["startQuest"] = "17724338985675546978",
						["startPort"] = "Out",
						["endQuest"] = "17724338985675546977",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772421504262707511",
						["startPort"] = "QuestStart",
						["endQuest"] = "1772421504262707516",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772421504262707516",
						["startPort"] = "Out",
						["endQuest"] = "17724338985675546978",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17724338985675546977",
						["startPort"] = "Out",
						["endQuest"] = "17724339133915547433",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772421504262707511",
						["startPort"] = "QuestStart",
						["endQuest"] = "17724339183595547575",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17724339183595547575",
						["startPort"] = "Out",
						["endQuest"] = "1772421504262707513",
						["endPort"] = "Fail"
					}
				},
				["nodeData"] = {
					["1772421504262707511"] = {
						["key"] = "1772421504262707511",
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
					["1772421504262707512"] = {
						["key"] = "1772421504262707512",
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
					["1772421504262707513"] = {
						["key"] = "1772421504262707513",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1471.4285714285713,
							["y"] = 620
						},
						["propsData"] = {}
					},
					["1772421504262707516"] = {
						["key"] = "1772421504262707516",
						["type"] = "ChangeRoleNode",
						["name"] = "切换苏乙",
						["pos"] = {
							["x"] = 1139.2599333598187,
							["y"] = 287.4808786096661
						},
						["propsData"] = {
							["QuestRoleId"] = 15040101,
							["IsPlayFX"] = false
						}
					},
					["17724338985675546977"] = {
						["key"] = "17724338985675546977",
						["type"] = "TalkNode",
						["name"] = "与朱朴对话",
						["pos"] = {
							["x"] = 1799.678442715039,
							["y"] = 282.96345856210803
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 240034,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_12020608zhupu_242410149",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1202/12047301.12047301'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East02_12020608",
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
					["17724338985675546978"] = {
						["key"] = "17724338985675546978",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1454.3658659175048,
							["y"] = 287.2229432713526
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								242410149
							}
						}
					},
					["17724339133915547433"] = {
						["key"] = "17724339133915547433",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2153.6489686783807,
							["y"] = 270.664629488159
						},
						["propsData"] = {}
					},
					["17724339183595547575"] = {
						["key"] = "17724339183595547575",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1141.7203972498091,
							["y"] = 585.0932009167304
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