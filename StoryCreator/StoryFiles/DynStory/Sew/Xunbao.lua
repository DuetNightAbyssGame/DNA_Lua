return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17284431047721",
			["startPort"] = "StoryStart",
			["endStory"] = "1728443116188167",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1728443116188167",
			["startPort"] = "Success",
			["endStory"] = "17284431047735",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17284431047721"] = {
			["isStoryNode"] = true,
			["key"] = "17284431047721",
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
		["17284431047735"] = {
			["isStoryNode"] = true,
			["key"] = "17284431047735",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1481.2217194570135,
				["y"] = 282.82805429864254
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1728443116188167"] = {
			["isStoryNode"] = true,
			["key"] = "1728443116188167",
			["type"] = "StoryNode",
			["name"] = "下水道寻宝",
			["pos"] = {
				["x"] = 1130.9650349650349,
				["y"] = 285.3417832167832
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "DynQuest_SewXunbao_Des",
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
				["bIsDynamicEvent"] = true,
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
						["startQuest"] = "1728443116188168",
						["startPort"] = "QuestStart",
						["endQuest"] = "1728443152944815",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17284433215322064",
						["startPort"] = "Out",
						["endQuest"] = "17284433215322065",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17284433215322066",
						["startPort"] = "Out",
						["endQuest"] = "17284433215322067",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1728443116188168",
						["startPort"] = "QuestStart",
						["endQuest"] = "17284433215322064",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1728443116188168",
						["startPort"] = "QuestStart",
						["endQuest"] = "17284433215322066",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1728443116188168",
						["startPort"] = "QuestStart",
						["endQuest"] = "17284433215322068",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17284433215322068",
						["startPort"] = "Out",
						["endQuest"] = "17284433999733759",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17284433999733759",
						["startPort"] = "WeightBranch_1",
						["endQuest"] = "17284433215322069",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17284433999733759",
						["startPort"] = "WeightBranch_2",
						["endQuest"] = "17284434886795019",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17284434886795019",
						["startPort"] = "Out",
						["endQuest"] = "17284435039695382",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17284435039695382",
						["startPort"] = "Out",
						["endQuest"] = "17284435254505817",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17284433215322069",
						["startPort"] = "Out",
						["endQuest"] = "17284435389016157",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17284435389016157",
						["startPort"] = "Out",
						["endQuest"] = "1728443116188175",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17284435254505817",
						["startPort"] = "Out",
						["endQuest"] = "17284435389016157",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1728443116188168"] = {
						["key"] = "1728443116188168",
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
					["1728443116188175"] = {
						["key"] = "1728443116188175",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3592.6923076923076,
							["y"] = 511.1538461538462
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1728443116189182"] = {
						["key"] = "1728443116189182",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 3052.6923076923076,
							["y"] = 218.8461538461538
						},
						["propsData"] = {}
					},
					["1728443152944815"] = {
						["key"] = "1728443152944815",
						["type"] = "TalkNode",
						["name"] = "主角开车对话",
						["pos"] = {
							["x"] = 1128.4345262580557,
							["y"] = 107.2477204168382
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71002701,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17284433215322064"] = {
						["key"] = "17284433215322064",
						["type"] = "PickUpNode",
						["name"] = "翻找木桶1",
						["pos"] = {
							["x"] = 1437.06915941778,
							["y"] = 256.31598091413696
						},
						["propsData"] = {
							["bActiveEnable"] = false,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 80001,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuidePointName"] = "",
							["IsUseCount"] = false
						}
					},
					["17284433215322065"] = {
						["key"] = "17284433215322065",
						["type"] = "TalkNode",
						["name"] = "无事发生",
						["pos"] = {
							["x"] = 1769.8375566552172,
							["y"] = 250.5317465726272
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71002702,
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
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17284433215322066"] = {
						["key"] = "17284433215322066",
						["type"] = "PickUpNode",
						["name"] = "翻找木桶2",
						["pos"] = {
							["x"] = 1424.4784652911587,
							["y"] = 473.048714503964
						},
						["propsData"] = {
							["bActiveEnable"] = false,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 80001,
							["UnitCount"] = 2,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuidePointName"] = "",
							["IsUseCount"] = false
						}
					},
					["17284433215322067"] = {
						["key"] = "17284433215322067",
						["type"] = "TalkNode",
						["name"] = "无事发生",
						["pos"] = {
							["x"] = 1782.597064957746,
							["y"] = 461.52763805719127
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71002703,
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
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17284433215322068"] = {
						["key"] = "17284433215322068",
						["type"] = "PickUpNode",
						["name"] = "翻找木桶3",
						["pos"] = {
							["x"] = 1414.2719875583653,
							["y"] = 705.8867711841262
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {
								1720193,
								1720194,
								1720195
							},
							["QuestPickupId"] = -1,
							["UnitId"] = 80001,
							["UnitCount"] = 3,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "",
							["IsUseCount"] = false
						}
					},
					["17284433215322069"] = {
						["key"] = "17284433215322069",
						["type"] = "TalkNode",
						["name"] = "找到物资",
						["pos"] = {
							["x"] = 2089.3986843909443,
							["y"] = 520.8677190288511
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71002704,
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
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17284433999733759"] = {
						["key"] = "17284433999733759",
						["type"] = "WeightBranchNode",
						["name"] = "权重分支节点",
						["pos"] = {
							["x"] = 1753.8191416426714,
							["y"] = 698.016951186069
						},
						["propsData"] = {
							["RandomTriggerBranchCount"] = 1,
							["WeightBranchArray"] = {
								1,
								1
							}
						}
					},
					["17284434886795019"] = {
						["key"] = "17284434886795019",
						["type"] = "TalkNode",
						["name"] = "出现秽兽",
						["pos"] = {
							["x"] = 2088.4345262580564,
							["y"] = 834.1707973399152
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71002705,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
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
							["TalkActors"] = {},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17284435039695382"] = {
						["key"] = "17284435039695382",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成秽兽",
						["pos"] = {
							["x"] = 2424.2037570272873,
							["y"] = 835.3246434937613
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1720196,
								1720197,
								1720198,
								1720199,
								1720200
							}
						}
					},
					["17284435254505817"] = {
						["key"] = "17284435254505817",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 2740.357603181133,
							["y"] = 818.0169511860689
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 5,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								1720196,
								1720197,
								1720198,
								1720199,
								1720200
							}
						}
					},
					["17284435389016157"] = {
						["key"] = "17284435389016157",
						["type"] = "DynamicQuestSuccessNode",
						["name"] = "动态任务主动成功",
						["pos"] = {
							["x"] = 3268.6749108734416,
							["y"] = 510.2284896476074
						},
						["propsData"] = {
							["DialogueId"] = 0,
							["UseTalkFadeOut"] = false,
							["TalkFadeOutTime"] = 0,
							["UseTalkFadeIn"] = false,
							["TalkFadeInTime"] = 0
						}
					},
					["17284541623742048"] = {
						["key"] = "17284541623742048",
						["type"] = "TalkNode",
						["name"] = "击杀秽兽开车",
						["pos"] = {
							["x"] = 3027.9331103678924,
							["y"] = 1020.9110269525873
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 71002706,
							["FlowAssetPath"] = "",
							["TalkType"] = "UnimportGuide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17284541983993073"] = {
						["key"] = "17284541983993073",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 3328.6254180602004,
							["y"] = 1064.8956423372028
						},
						["propsData"] = {
							["WaitTime"] = 2
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}