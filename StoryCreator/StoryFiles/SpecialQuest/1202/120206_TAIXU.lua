return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17678537949091014656",
			["startPort"] = "StoryStart",
			["endStory"] = "17678537949091014658",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17678537949091014658",
			["startPort"] = "Success",
			["endStory"] = "17678537949091014657",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17678537949091014656"] = {
			["isStoryNode"] = true,
			["key"] = "17678537949091014656",
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
		["17678537949091014657"] = {
			["isStoryNode"] = true,
			["key"] = "17678537949091014657",
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
		["17678537949091014658"] = {
			["isStoryNode"] = true,
			["key"] = "17678537949091014658",
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
						["startQuest"] = "17678537949091014659",
						["startPort"] = "QuestStart",
						["endQuest"] = "17725494921981610823",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17725494921981610823",
						["startPort"] = "Out",
						["endQuest"] = "17678537949091014661",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17678537949091014659",
						["startPort"] = "QuestStart",
						["endQuest"] = "17725494996691611086",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17725495161381611486",
						["startPort"] = "Out",
						["endQuest"] = "17725495208101611613",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17725495208101611613",
						["startPort"] = "Out",
						["endQuest"] = "17679676399167265225",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17725494996691611086",
						["startPort"] = "Out",
						["endQuest"] = "17725495265861611808",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17725495265861611808",
						["startPort"] = "Out",
						["endQuest"] = "17725495161381611486",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17678537949091014659"] = {
						["key"] = "17678537949091014659",
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
					["17678537949091014660"] = {
						["key"] = "17678537949091014660",
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
					["17678537949091014661"] = {
						["key"] = "17678537949091014661",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17679676312767265010"] = {
						["key"] = "17679676312767265010",
						["type"] = "TalkNode",
						["name"] = "阴阳合一",
						["pos"] = {
							["x"] = 1164.170751633987,
							["y"] = -40.77777777777777
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/Ver01/Ver0102/Ver0102_SC019/Ver0102_SC019",
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
					["17679676399167265225"] = {
						["key"] = "17679676399167265225",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2402.260922574158,
							["y"] = 310.95000000000005
						},
						["propsData"] = {}
					},
					["17725494921981610823"] = {
						["key"] = "17725494921981610823",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1346.366544012963,
							["y"] = 633.7364004282163
						},
						["propsData"] = {}
					},
					["17725494996691611086"] = {
						["key"] = "17725494996691611086",
						["type"] = "ChangeRoleNode",
						["name"] = "切换角色",
						["pos"] = {
							["x"] = 1156.70937126244,
							["y"] = 292.5608700350056
						},
						["propsData"] = {
							["QuestRoleId"] = 24010102,
							["IsPlayFX"] = false
						}
					},
					["17725495161381611486"] = {
						["key"] = "17725495161381611486",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1718.3427444455028,
							["y"] = 293.6047595441581
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 242380003,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020622hezi_242380003"
						}
					},
					["17725495208101611613"] = {
						["key"] = "17725495208101611613",
						["type"] = "TalkNode",
						["name"] = "【East02_FixSimple_74】太虚幻境，矩和飏的最终对话",
						["pos"] = {
							["x"] = 2049.101013270274,
							["y"] = 294.73600514584706
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1202/12047901.12047901'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "East02_12020622",
							["BlendInTime"] = 0,
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
					["17725495265861611808"] = {
						["key"] = "17725495265861611808",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1407.9335255855447,
							["y"] = 300.30989677146283
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
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}