return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17671472305734285560",
			["startPort"] = "Success",
			["endStory"] = "17671472305734285561",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17671472305734285562",
			["startPort"] = "【分支2.1】（隐瞒在矿坑中得到的日记）",
			["endStory"] = "17671472305734285563",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17671472305734285562",
			["startPort"] = "【分支2.2】（交出在矿坑中得到的日记）",
			["endStory"] = "17671472305734285564",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17671472305734285561",
			["startPort"] = "Success",
			["endStory"] = "17671472305734285562",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17671472305734285565",
			["startPort"] = "Success",
			["endStory"] = "17671472305734285560",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17671472305724285558",
			["startPort"] = "StoryStart",
			["endStory"] = "17671047958101088349",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17671047958101088349",
			["startPort"] = "Success",
			["endStory"] = "17671621588518025",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17671621588518025",
			["startPort"] = "Success",
			["endStory"] = "17671631279671442769",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17671631279671442769",
			["startPort"] = "Success",
			["endStory"] = "17671648588372520608",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17674967697169510",
			["startPort"] = "Success",
			["endStory"] = "17671472305724285559",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "17671648588372520608",
			["startPort"] = "Success",
			["endStory"] = "17674967697169510",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["17671047958101088349"] = {
			["isStoryNode"] = true,
			["key"] = "17671047958101088349",
			["type"] = "PreStoryNode",
			["name"] = "任务前置节点",
			["pos"] = {
				["x"] = 882.1857131516574,
				["y"] = 807.9062971342385
			},
			["propsData"] = {
				["QuestId"] = 20031500,
				["QuestDescriptionComment"] = "接取条件",
				["SubRegionId"] = 104109,
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_Quest20001500_heishishangren_142100310",
				["bIsPlayBlackScreenOnComplete"] = false,
				["SubRegionIdList"] = {}
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17671047958101088350",
						["startPort"] = "QuestStart",
						["endQuest"] = "17675944614408541",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17675945008199150",
						["startPort"] = "Out",
						["endQuest"] = "17671060653022164803",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17675944614408541",
						["startPort"] = "Out",
						["endQuest"] = "17675945008199150",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17671060653022164803",
						["startPort"] = "Fail",
						["endQuest"] = "17671047958111088364",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17678540975793369",
						["startPort"] = "Out",
						["endQuest"] = "17671047958111088353",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17671060653022164803",
						["startPort"] = "Out",
						["endQuest"] = "17675946966691092536",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17675946966691092536",
						["startPort"] = "Out",
						["endQuest"] = "17678540975793369",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17671047958101088350"] = {
						["key"] = "17671047958101088350",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -60.75057208237996,
							["y"] = 294.5263157894737
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17671047958111088353"] = {
						["key"] = "17671047958111088353",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2796,
							["y"] = 250
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17671047958111088356"] = {
						["key"] = "17671047958111088356",
						["type"] = "ReceiveSideQuestNode",
						["name"] = "支线任务接取节点",
						["pos"] = {
							["x"] = 1684,
							["y"] = -315.57894736842104
						},
						["propsData"] = {
							["SideQuestChainId"] = 200315,
							["EnableSequence"] = true,
							["SequencePath"] = "/Game/UI/Sequence/SQ_Task_DepthField.SQ_Task_DepthField",
							["PauseMark"] = "QuestAccept"
						}
					},
					["17671047958111088364"] = {
						["key"] = "17671047958111088364",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17671052431951091743"] = {
						["key"] = "17671052431951091743",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2009.5789473684213,
							["y"] = -356
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51155101,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0.5,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
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
							["TalkActors"] = {},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "Player",
							["bNpcActionKeepIn"] = false,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17671060653022164803"] = {
						["key"] = "17671060653022164803",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1028.849924389112,
							["y"] = 265.48583855122735
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 51155001,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200315/20031501.20031501'",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "",
							["BlendInTime"] = 0.5,
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
					["17675944525898284"] = {
						["key"] = "17675944525898284",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 1384,
							["y"] = -176
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 11032,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "",
							["IsUseCount"] = false
						}
					},
					["17675944614408541"] = {
						["key"] = "17675944614408541",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 292,
							["y"] = 302
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								142100319
							}
						}
					},
					["17675945008199150"] = {
						["key"] = "17675945008199150",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 636,
							["y"] = 274
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 20031502,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "",
							["IsUseCount"] = false
						}
					},
					["17675946966691092536"] = {
						["key"] = "17675946966691092536",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1606,
							["y"] = 146
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								142100319
							}
						}
					},
					["17678540975793369"] = {
						["key"] = "17678540975793369",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2102,
							["y"] = 240
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								142100311
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17671472305724285558"] = {
			["isStoryNode"] = true,
			["key"] = "17671472305724285558",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 528.2990196078432,
				["y"] = 970.8382352941177
			},
			["propsData"] = {
				["QuestChainId"] = 200315
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17671472305724285559"] = {
			["isStoryNode"] = true,
			["key"] = "17671472305724285559",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2734.260549091431,
				["y"] = 934.9342365151186
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17671472305734285560"] = {
			["isStoryNode"] = true,
			["key"] = "17671472305734285560",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1040.76370458058,
				["y"] = 323.03813604393315
			},
			["propsData"] = {
				["QuestId"] = 20020102,
				["QuestDescriptionComment"] = "和希琳夫人交流",
				["QuestDescription"] = "Description_200201_2",
				["QuestDeatil"] = "Content_200201_2",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = true,
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
						["startQuest"] = "17671472305734285566",
						["startPort"] = "QuestStart",
						["endQuest"] = "17671472305734285569",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17671472305734285569",
						["startPort"] = "Out",
						["endQuest"] = "17671472305734285567",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17671472305734285566"] = {
						["key"] = "17671472305734285566",
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
					["17671472305734285567"] = {
						["key"] = "17671472305734285567",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1581.25,
							["y"] = 313.125
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17671472305734285568"] = {
						["key"] = "17671472305734285568",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1759.375,
							["y"] = 752.5
						},
						["propsData"] = {}
					},
					["17671472305734285569"] = {
						["key"] = "17671472305734285569",
						["type"] = "WaitImpressionTalkCompleteNode",
						["name"] = "等待印象对话完成",
						["pos"] = {
							["x"] = 1175.6944444444443,
							["y"] = 315.27777777777777
						},
						["propsData"] = {
							["ImpressionTalkTriggerId"] = 510002,
							["bShowGuide"] = true,
							["GuideType"] = "N",
							["NPCStaticCreaterName"] = "Npc_Xilin_1190094"
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17671472305734285561"] = {
			["isStoryNode"] = true,
			["key"] = "17671472305734285561",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1323.1298701298701,
				["y"] = 309.39610389610397
			},
			["propsData"] = {
				["QuestId"] = 20020104,
				["QuestDescriptionComment"] = "寻找日记",
				["QuestDescription"] = "Description_200201_4",
				["QuestDeatil"] = "Content_200201_4",
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
						["startQuest"] = "17671472305734285570",
						["startPort"] = "QuestStart",
						["endQuest"] = "17671472305734285575",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17671472305734285575",
						["startPort"] = "Out",
						["endQuest"] = "17671472305734285576",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17671472305734285576",
						["startPort"] = "Out",
						["endQuest"] = "17671472305734285571",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17671472305734285570",
						["startPort"] = "QuestStart",
						["endQuest"] = "17671472305734285577",
						["endPort"] = "Input"
					},
					{
						["startQuest"] = "17671472305734285577",
						["startPort"] = "Out",
						["endQuest"] = "17671472305734285571",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17671472305734285570"] = {
						["key"] = "17671472305734285570",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 607.1428571428571,
							["y"] = 285.65714285714284
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17671472305734285571"] = {
						["key"] = "17671472305734285571",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1382.7428571428588,
							["y"] = 282.2142857142859
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17671472305734285572"] = {
						["key"] = "17671472305734285572",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1602.6086956521758,
							["y"] = 393.8043478260872
						},
						["propsData"] = {}
					},
					["17671472305734285573"] = {
						["key"] = "17671472305734285573",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁 掉落物",
						["pos"] = {
							["x"] = 1406.2557639764154,
							["y"] = 41.35092974583563
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1440065
							}
						}
					},
					["17671472305734285574"] = {
						["key"] = "17671472305734285574",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 1105.382334024724,
							["y"] = 61.24934244424833
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {
								1440065
							},
							["QuestPickupId"] = -1,
							["UnitId"] = 2000018,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "QuestPoint_200201",
							["IsUseCount"] = false
						}
					},
					["17671472305734285575"] = {
						["key"] = "17671472305734285575",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 870.011904761904,
							["y"] = 277.9761904761908
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101304,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "QuestPoint_200201"
						}
					},
					["17671472305734285576"] = {
						["key"] = "17671472305734285576",
						["type"] = "ResourceCollectNode",
						["name"] = "获得Resource道具",
						["pos"] = {
							["x"] = 1118.3101148339415,
							["y"] = 282.66338663318277
						},
						["propsData"] = {
							["ResourceType"] = "Resource",
							["ResourceId"] = 2000019,
							["ResourceSType"] = "None",
							["NeedCount"] = 1,
							["bUseBagCount"] = true,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "QuestPoint_200201"
						}
					},
					["17671472305734285577"] = {
						["key"] = "17671472305734285577",
						["type"] = "ResourceCollectNode",
						["name"] = "获得Resource道具",
						["pos"] = {
							["x"] = 988.7545592783861,
							["y"] = 472.2348152046114
						},
						["propsData"] = {
							["ResourceType"] = "Resource",
							["ResourceId"] = 2000019,
							["ResourceSType"] = "None",
							["NeedCount"] = 1,
							["bUseBagCount"] = true,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuidePointName"] = ""
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17671472305734285562"] = {
			["isStoryNode"] = true,
			["key"] = "17671472305734285562",
			["type"] = "StoryNode",
			["name"] = "印象任务节点",
			["pos"] = {
				["x"] = 1608.0438163157667,
				["y"] = 280.2384696009849
			},
			["propsData"] = {
				["QuestId"] = 20020105,
				["QuestDescriptionComment"] = "返回希琳夫人处",
				["QuestDescription"] = "Description_200201_5",
				["QuestDeatil"] = "Content_200201_5",
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
						["startQuest"] = "17671472305734285578",
						["startPort"] = "QuestStart",
						["endQuest"] = "17671472305734285584",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17671472305734285584",
						["startPort"] = "Out",
						["endQuest"] = "17671472305734285581",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17671472305734285581",
						["startPort"] = "Option_1",
						["endQuest"] = "17671472305734285583",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17671472305734285581",
						["startPort"] = "Option_2",
						["endQuest"] = "17671472305734285582",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17671472305734285578"] = {
						["key"] = "17671472305734285578",
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
					["17671472305734285579"] = {
						["key"] = "17671472305734285579",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2156.175548589342,
							["y"] = 110.97178683385567
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17671472305734285580"] = {
						["key"] = "17671472305734285580",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1662.7272727272727,
							["y"] = 705.4545454545455
						},
						["propsData"] = {}
					},
					["17671472305734285581"] = {
						["key"] = "17671472305734285581",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1365.5253496543783,
							["y"] = 283.9445281824518
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700019,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Xilin_1190094",
							["DelayShowGuideTime"] = 0,
							["FirstDialogueId"] = 51002301,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0.5,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = true,
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
							["TalkActors"] = {},
							["OptionType"] = "branch",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "Player",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["BranchOptions"] = {
								"",
								""
							},
							["OverrideFailBlend"] = false
						}
					},
					["17671472305734285582"] = {
						["key"] = "17671472305734285582",
						["type"] = "QuestConditionNode",
						["name"] = "QuestCondition",
						["pos"] = {
							["x"] = 1732.511603703748,
							["y"] = 464.61943306983176
						},
						["propsData"] = {
							["PortName"] = "【分支2.1】（隐瞒在矿坑中得到的日记）"
						}
					},
					["17671472305734285583"] = {
						["key"] = "17671472305734285583",
						["type"] = "QuestConditionNode",
						["name"] = "QuestCondition",
						["pos"] = {
							["x"] = 1736.7836343550887,
							["y"] = 194.35602310814602
						},
						["propsData"] = {
							["PortName"] = "【分支2.2】（交出在矿坑中得到的日记）"
						}
					},
					["17671472305734285584"] = {
						["key"] = "17671472305734285584",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 1060.5067691474596,
							["y"] = 292.86489698873424
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101101,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "Xilin_51002301"
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17671472305734285563"] = {
			["isStoryNode"] = true,
			["key"] = "17671472305734285563",
			["type"] = "StoryNode",
			["name"] = "隐瞒日记",
			["pos"] = {
				["x"] = 1967.9130333520075,
				["y"] = 116.16441929206049
			},
			["propsData"] = {
				["QuestId"] = 20020106,
				["QuestDescriptionComment"] = "和莎莉交谈",
				["QuestDescription"] = "Description_200201_6",
				["QuestDeatil"] = "Content_200201_7",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = true,
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
						["startQuest"] = "17671472305734285585",
						["startPort"] = "QuestStart",
						["endQuest"] = "17671472305734285589",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17671472305734285589",
						["startPort"] = "Out",
						["endQuest"] = "17671472305734285588",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17671472305734285588",
						["startPort"] = "Out",
						["endQuest"] = "17671472305734285586",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17671472305734285585"] = {
						["key"] = "17671472305734285585",
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
					["17671472305734285586"] = {
						["key"] = "17671472305734285586",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1979.9999999999998,
							["y"] = 295
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17671472305734285587"] = {
						["key"] = "17671472305734285587",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1979.9999999999998,
							["y"] = 695
						},
						["propsData"] = {}
					},
					["17671472305734285588"] = {
						["key"] = "17671472305734285588",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1311.9121871436637,
							["y"] = 412.2593518619989
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700020,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Shali_1190095",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51002320,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = -1,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = true,
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700020,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "Player",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17671472305734285589"] = {
						["key"] = "17671472305734285589",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 998.1990768397675,
							["y"] = 463.2495123733498
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101101,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "Shali_51002320"
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17671472305734285564"] = {
			["isStoryNode"] = true,
			["key"] = "17671472305734285564",
			["type"] = "StoryNode",
			["name"] = "交出日记",
			["pos"] = {
				["x"] = 1973.789764623288,
				["y"] = 314.160543537007
			},
			["propsData"] = {
				["QuestId"] = 20020107,
				["QuestDescriptionComment"] = "和莎莉交谈",
				["QuestDescription"] = "Description_200201_6",
				["QuestDeatil"] = "Content_200201_6",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = true,
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
						["startQuest"] = "17671472305734285590",
						["startPort"] = "QuestStart",
						["endQuest"] = "17671472305734285594",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17671472305734285594",
						["startPort"] = "Out",
						["endQuest"] = "17671472305734285593",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17671472305734285593",
						["startPort"] = "Out",
						["endQuest"] = "17671472305734285591",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17671472305734285590"] = {
						["key"] = "17671472305734285590",
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
					["17671472305734285591"] = {
						["key"] = "17671472305734285591",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1979.9999999999998,
							["y"] = 295
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17671472305734285592"] = {
						["key"] = "17671472305734285592",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1979.9999999999998,
							["y"] = 695
						},
						["propsData"] = {}
					},
					["17671472305734285593"] = {
						["key"] = "17671472305734285593",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1088.5196803756571,
							["y"] = 284.4876419591624
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700020,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Shali_1190095",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51002401,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = -1,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = true,
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 700020,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "Player",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17671472305734285594"] = {
						["key"] = "17671472305734285594",
						["type"] = "GoToRegionNode",
						["name"] = "进入区域",
						["pos"] = {
							["x"] = 1012.217782099221,
							["y"] = 499.8462467547286
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101101,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "Shali_51002320"
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17671472305734285565"] = {
			["isStoryNode"] = true,
			["key"] = "17671472305734285565",
			["type"] = "PreStoryNode",
			["name"] = "任务前置节点",
			["pos"] = {
				["x"] = 995.1138107604904,
				["y"] = 124.68213324970935
			},
			["propsData"] = {
				["QuestId"] = 20020100,
				["QuestDescriptionComment"] = "",
				["SubRegionId"] = 101101,
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_Shali_1190095",
				["bIsPlayBlackScreenOnComplete"] = false,
				["SubRegionIdList"] = {}
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17671472305734285597",
						["startPort"] = "ApproveOut",
						["endQuest"] = "17671472305734285596",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17671472305734285597",
						["startPort"] = "CancelOut",
						["endQuest"] = "17671472305734285598",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17671472305734285595",
						["startPort"] = "QuestStart",
						["endQuest"] = "17671472305734285599",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17671472305734285599",
						["startPort"] = "Out",
						["endQuest"] = "17671472305734285597",
						["endPort"] = "Input"
					}
				},
				["nodeData"] = {
					["17671472305734285595"] = {
						["key"] = "17671472305734285595",
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
					["17671472305734285596"] = {
						["key"] = "17671472305734285596",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1763.5515873015877,
							["y"] = 276.68650793650795
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17671472305734285597"] = {
						["key"] = "17671472305734285597",
						["type"] = "ReceiveSideQuestNode",
						["name"] = "支线任务接取节点",
						["pos"] = {
							["x"] = 1463.5515873015877,
							["y"] = 276.68650793650795
						},
						["propsData"] = {
							["SideQuestChainId"] = 200201,
							["EnableSequence"] = true,
							["SequencePath"] = "/Game/UI/Sequence/SQ_Task_DepthField.SQ_Task_DepthField",
							["PauseMark"] = "QuestAccept"
						}
					},
					["17671472305734285598"] = {
						["key"] = "17671472305734285598",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1646.762801762802,
							["y"] = 476.231084981085
						},
						["propsData"] = {}
					},
					["17671472305734285599"] = {
						["key"] = "17671472305734285599",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1143.8973632002173,
							["y"] = 297.6443277519253
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 700020,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Shali_1190095",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 51000101,
							["FlowAssetPath"] = "",
							["TalkType"] = "Impression",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0.5,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = true,
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
							["TalkActors"] = {},
							["OptionType"] = "plus",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "Player",
							["PlayerSwitchEmoIdle"] = true,
							["PlusOptions"] = {},
							["OverrideFailBlend"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17671621588518025"] = {
			["isStoryNode"] = true,
			["key"] = "17671621588518025",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1172.1666749688898,
				["y"] = 965.0301623542096
			},
			["propsData"] = {
				["QuestId"] = 20031502,
				["QuestDescriptionComment"] = "和黑市商人交谈",
				["QuestDescription"] = "Description_200315_2",
				["QuestDeatil"] = "Content_200315_2",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = true,
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
				["SubRegionId"] = 104109,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_Quest20001500_heishishangren2_142100311",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17671621588518026",
						["startPort"] = "QuestStart",
						["endQuest"] = "176716280054212024",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176716280054212024",
						["startPort"] = "Out",
						["endQuest"] = "17671621588518029",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17671621588518026"] = {
						["key"] = "17671621588518026",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 410,
							["y"] = 290
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17671621588518029"] = {
						["key"] = "17671621588518029",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1776,
							["y"] = 276
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17671621588518032"] = {
						["key"] = "17671621588518032",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1700,
							["y"] = 470
						},
						["propsData"] = {}
					},
					["176716280054212024"] = {
						["key"] = "176716280054212024",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1040,
							["y"] = 292
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 701093,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Quest20001500_heishishangren2_142100311",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 51155201,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200315/20031502.20031502'",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0.5,
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
							["OptionType"] = "plus",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = false,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["PlusOptions"] = {},
							["OverrideFailBlend"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17671631279671442769"] = {
			["isStoryNode"] = true,
			["key"] = "17671631279671442769",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1480.3779049154139,
				["y"] = 777.3035580761347
			},
			["propsData"] = {
				["QuestId"] = 20031503,
				["QuestDescriptionComment"] = "和小白交谈",
				["QuestDescription"] = "Description_200315_3",
				["QuestDeatil"] = "Content_200315_3",
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
				["SubRegionId"] = 104109,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_Quest20015_chufa1_142100313",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17671631279671442770",
						["startPort"] = "QuestStart",
						["endQuest"] = "17671637102441446171",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17671637102441446171",
						["startPort"] = "Out",
						["endQuest"] = "17671644957071447491",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17671644957071447491",
						["startPort"] = "Out",
						["endQuest"] = "17678541610381092072",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17678541610381092072",
						["startPort"] = "Out",
						["endQuest"] = "17671631279671442773",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17671631279671442770"] = {
						["key"] = "17671631279671442770",
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
					["17671631279671442773"] = {
						["key"] = "17671631279671442773",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2254,
							["y"] = 324
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17671631279671442776"] = {
						["key"] = "17671631279671442776",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17671637102441446171"] = {
						["key"] = "17671637102441446171",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1148,
							["y"] = 294
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 142100313,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_Quest20015_chufa1_142100313"
						}
					},
					["17671644957071447491"] = {
						["key"] = "17671644957071447491",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1528,
							["y"] = 276
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 51155301,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200315/20031503.20031503'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "",
							["BlendInTime"] = 0.5,
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
					["17678541610381092072"] = {
						["key"] = "17678541610381092072",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1864,
							["y"] = 224
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "yanjinduweiji4",
							["FadeIn"] = false,
							["FadeOut"] = true,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17671648588372520608"] = {
			["isStoryNode"] = true,
			["key"] = "17671648588372520608",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1746.3396380481229,
				["y"] = 917.9160683470818
			},
			["propsData"] = {
				["QuestId"] = 20031504,
				["QuestDescriptionComment"] = "威慑黑市商人",
				["QuestDescription"] = "Description_200315_4",
				["QuestDeatil"] = "Content_200315_4",
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
				["ResurgencePoint"] = "yanjinduweiji3",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = true,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 104109,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_Quest20001500_heishishangren3_142100312",
				["JumpId"] = 0,
				["FailBlackScreenText"] = "FailBlackScreenHode_1",
				["FadeInTime"] = 1,
				["FadeOutTime"] = 1,
				["ContinueTime"] = 1
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17671648588372520609",
						["startPort"] = "QuestStart",
						["endQuest"] = "17671651496572522529",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176717404741016013",
						["startPort"] = "Out",
						["endQuest"] = "176717395005215285",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176717419226919693",
						["startPort"] = "Out",
						["endQuest"] = "176717420442620059",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176717395005215285",
						["startPort"] = "Out",
						["endQuest"] = "17671743063491092720",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17671651496572522529",
						["startPort"] = "Out",
						["endQuest"] = "176717404741016013",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176717395005215285",
						["startPort"] = "Out",
						["endQuest"] = "17671668579157884141",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176717395005215285",
						["startPort"] = "Out",
						["endQuest"] = "17674967222608513",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176717395005215285",
						["startPort"] = "Out",
						["endQuest"] = "176717419226919693",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176717419226919693",
						["startPort"] = "Out",
						["endQuest"] = "17671744292622166075",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17671648588372520609",
						["startPort"] = "QuestStart",
						["endQuest"] = "17671673647207888227",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176717420442620059",
						["startPort"] = "Out",
						["endQuest"] = "17678586902047621956",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17678586902047621956",
						["startPort"] = "Out",
						["endQuest"] = "17671648588372520612",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17671648588372520609"] = {
						["key"] = "17671648588372520609",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 671.9230769230769,
							["y"] = 316.15384615384613
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17671648588372520612"] = {
						["key"] = "17671648588372520612",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2925.3736263736264,
							["y"] = 58.42490842490844
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17671648588372520615"] = {
						["key"] = "17671648588372520615",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["17671651496572522529"] = {
						["key"] = "17671651496572522529",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 967.3598901098901,
							["y"] = 286.9230769230769
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 142100314,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_Quest20015_chufa2_142100314"
						}
					},
					["17671654362992523573"] = {
						["key"] = "17671654362992523573",
						["type"] = "JudgePlayerSkillUsedTimesNode",
						["name"] = "判断技能使用次数",
						["pos"] = {
							["x"] = 2860.4172353961826,
							["y"] = -861.0962791594374
						},
						["propsData"] = {
							["SkillId"] = "Attack",
							["CompareFunc"] = 2,
							["Times"] = 1
						}
					},
					["17671658242782525848"] = {
						["key"] = "17671658242782525848",
						["type"] = "JudgePlayerSkillUsedTimesNode",
						["name"] = "判断技能使用次数",
						["pos"] = {
							["x"] = 2860.2096651886122,
							["y"] = -703.6512242143822
						},
						["propsData"] = {
							["SkillId"] = "Skill1",
							["CompareFunc"] = 2,
							["Times"] = 1
						}
					},
					["17671658357242526031"] = {
						["key"] = "17671658357242526031",
						["type"] = "JudgePlayerSkillUsedTimesNode",
						["name"] = "判断技能使用次数",
						["pos"] = {
							["x"] = 2861.363511342459,
							["y"] = -559.420454983613
						},
						["propsData"] = {
							["SkillId"] = "Skill2",
							["CompareFunc"] = 2,
							["Times"] = 1
						}
					},
					["17671658541802526285"] = {
						["key"] = "17671658541802526285",
						["type"] = "JudgePlayerSkillUsedTimesNode",
						["name"] = "判断技能使用次数",
						["pos"] = {
							["x"] = 2868.0301780091254,
							["y"] = -409.292249855408
						},
						["propsData"] = {
							["SkillId"] = "Skill2",
							["CompareFunc"] = 2,
							["Times"] = 1
						}
					},
					["17671668579157884141"] = {
						["key"] = "17671668579157884141",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 2014.2028693528694,
							["y"] = 513.2027376132637
						},
						["propsData"] = {
							["NewDescription"] = "Description_200315_4_1",
							["NewDetail"] = "Content_200315_4",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17671670714047885329"] = {
						["key"] = "17671670714047885329",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 2855.02241822505,
							["y"] = -992.7352323115483
						},
						["propsData"] = {
							["WaitTime"] = 10
						}
					},
					["17671673647207888227"] = {
						["key"] = "17671673647207888227",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 970.0224182250504,
							["y"] = 488.7647676884524
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51155401,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["176717395005215285"] = {
						["key"] = "176717395005215285",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 1588.7176916650599,
							["y"] = -79.11393869288587
						},
						["propsData"] = {
							["bActiveEnable"] = false,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 20031501,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "yanjinduweiji5",
							["IsUseCount"] = false
						}
					},
					["176717404741016013"] = {
						["key"] = "176717404741016013",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1269.6488657541286,
							["y"] = -26.52284557547717
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								142100318
							}
						}
					},
					["176717419226919693"] = {
						["key"] = "176717419226919693",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1981.3604042156671,
							["y"] = -12.359282822440917
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = true,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								142100315,
								142100316,
								142100317
							}
						}
					},
					["176717420442620059"] = {
						["key"] = "176717420442620059",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 2301.265166120429,
							["y"] = 15.164526701368601
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 3,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								142100315,
								142100316,
								142100317
							}
						}
					},
					["17671743063491092720"] = {
						["key"] = "17671743063491092720",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1994.2287934373842,
							["y"] = 328.7518495092796
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								142100318
							}
						}
					},
					["17671744292622166075"] = {
						["key"] = "17671744292622166075",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2297.100973888512,
							["y"] = -144.17296252079583
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 51155501,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17674967222608513"] = {
						["key"] = "17674967222608513",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2000.7142857142858,
							["y"] = 167
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								142100311
							}
						}
					},
					["176770722110015188784"] = {
						["key"] = "176770722110015188784",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1978.857142857143,
							["y"] = -231.14285714285708
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17678586902047621956"] = {
						["key"] = "17678586902047621956",
						["type"] = "CommonBlackFadeInOutNode",
						["name"] = "通用黑屏淡入淡出节点",
						["pos"] = {
							["x"] = 2584,
							["y"] = 138
						},
						["propsData"] = {
							["FadeTime"] = 1,
							["FadeType"] = "FadeOut"
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17674967697169510"] = {
			["isStoryNode"] = true,
			["key"] = "17674967697169510",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 2225.823557508435,
				["y"] = 916.7107611374114
			},
			["propsData"] = {
				["QuestId"] = 20031505,
				["QuestDescriptionComment"] = "和黑市商人交谈",
				["QuestDescription"] = "Description_200315_5",
				["QuestDeatil"] = "Content_200315_5",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
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
				["SubRegionId"] = 104109,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Npc",
				["StoryGuidePointName"] = "Npc_Quest20001500_heishishangren3_142100312",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17674967697169511",
						["startPort"] = "QuestStart",
						["endQuest"] = "176749686446610692",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176749686446610692",
						["startPort"] = "Out",
						["endQuest"] = "176749689383411105",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176749689383411105",
						["startPort"] = "Out",
						["endQuest"] = "176770782376317358373",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176770782376317358373",
						["startPort"] = "Out",
						["endQuest"] = "176749702537412036",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176749702537412036",
						["startPort"] = "Out",
						["endQuest"] = "17674967697169514",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17674967697169511"] = {
						["key"] = "17674967697169511",
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
					["17674967697169514"] = {
						["key"] = "17674967697169514",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2794,
							["y"] = 322
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17674967697169517"] = {
						["key"] = "17674967697169517",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2800,
							["y"] = 700
						},
						["propsData"] = {}
					},
					["176749686446610692"] = {
						["key"] = "176749686446610692",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1190,
							["y"] = 312
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								142100312
							}
						}
					},
					["176749689383411105"] = {
						["key"] = "176749689383411105",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1610,
							["y"] = 310
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 701094,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_Quest20001500_heishishangren3_142100312",
							["DelayShowGuideTime"] = 0,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 51155601,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200315/20031504.20031504'",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
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
					["176749702537412036"] = {
						["key"] = "176749702537412036",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2152,
							["y"] = 300
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								142100312
							}
						}
					},
					["176770782376317358373"] = {
						["key"] = "176770782376317358373",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1876,
							["y"] = 288
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "yanjinduweiji2",
							["FadeIn"] = false,
							["FadeOut"] = true,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}