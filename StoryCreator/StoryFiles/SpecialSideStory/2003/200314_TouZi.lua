return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17670643660081",
			["startPort"] = "StoryStart",
			["endStory"] = "176706437648488",
			["endPort"] = "In"
		},
		{
			["startStory"] = "176706437648488",
			["startPort"] = "Success",
			["endStory"] = "17670643660095",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17670643660081"] = {
			["isStoryNode"] = true,
			["key"] = "17670643660081",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 796,
				["y"] = 300
			},
			["propsData"] = {
				["QuestChainId"] = 200314
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17670643660095"] = {
			["isStoryNode"] = true,
			["key"] = "17670643660095",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1848,
				["y"] = 310
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["176706437648488"] = {
			["isStoryNode"] = true,
			["key"] = "176706437648488",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1349.612903205959,
				["y"] = 294
			},
			["propsData"] = {
				["QuestId"] = 20031401,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200314_1",
				["QuestDeatil"] = "Content_200314_1",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = true,
				["bIsEndQuest"] = true,
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
						["startQuest"] = "176706437648489",
						["startPort"] = "QuestStart",
						["endQuest"] = "17678699663895800264",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17678699663895800264",
						["startPort"] = "Out",
						["endQuest"] = "1768814953691387",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1768814953691387",
						["startPort"] = "Out",
						["endQuest"] = "1767093768339479",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1767093768339479",
						["startPort"] = "Out",
						["endQuest"] = "17688149957261169",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17688149957261169",
						["startPort"] = "Out",
						["endQuest"] = "176706437648497",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["176706437648489"] = {
						["key"] = "176706437648489",
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
					["176706437648497"] = {
						["key"] = "176706437648497",
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
					["1767064376484105"] = {
						["key"] = "1767064376484105",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["1767093768339479"] = {
						["key"] = "1767093768339479",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2057.1428492020586,
							["y"] = 333.6277049763502
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 701096,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_MrQiu_2270015",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200314/20031401.20031401'",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_20031401",
							["BlendInTime"] = 1,
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
					["17678699663895800264"] = {
						["key"] = "17678699663895800264",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 1260.488697771154,
							["y"] = 424.9735422830056
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 104901,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "TargetPoint_EnterQiuOffice"
						}
					},
					["1768814953691387"] = {
						["key"] = "1768814953691387",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1662,
							["y"] = 442
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2270015
							}
						}
					},
					["17688149957261169"] = {
						["key"] = "17688149957261169",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2430,
							["y"] = 320
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2270015
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