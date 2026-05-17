return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1757664296229559833",
			["startPort"] = "StoryStart",
			["endStory"] = "1757664296230559835",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1757664296230559835",
			["startPort"] = "Success",
			["endStory"] = "1757664296230559834",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1757664296229559833"] = {
			["isStoryNode"] = true,
			["key"] = "1757664296229559833",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 952,
				["y"] = 324
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
		["1757664296230559834"] = {
			["isStoryNode"] = true,
			["key"] = "1757664296230559834",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1724,
				["y"] = 328
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1757664296230559835"] = {
			["isStoryNode"] = true,
			["key"] = "1757664296230559835",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1308,
				["y"] = 322
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120114_12",
				["QuestDeatil"] = "Content_120114_12",
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
						["startQuest"] = "1757664296230559836",
						["startPort"] = "QuestStart",
						["endQuest"] = "1757664296230559839",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1757664296230559836",
						["startPort"] = "QuestStart",
						["endQuest"] = "1757664296230559841",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1757664296230559843",
						["startPort"] = "Out",
						["endQuest"] = "1757664296230559844",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1757664296230559842",
						["startPort"] = "Out",
						["endQuest"] = "1757664296230559845",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1757664296230559847",
						["startPort"] = "Out",
						["endQuest"] = "1757664296230559848",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1757664296230559849",
						["startPort"] = "Out",
						["endQuest"] = "1757664296230559846",
						["endPort"] = "Input_2"
					},
					{
						["startQuest"] = "1757664296230559848",
						["startPort"] = "Out",
						["endQuest"] = "1757664296230559846",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "1757664296230559850",
						["startPort"] = "Out",
						["endQuest"] = "1757664296230559851",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1757664296230559852",
						["startPort"] = "Out",
						["endQuest"] = "1757664296230559853",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1757664296230559851",
						["startPort"] = "Out",
						["endQuest"] = "1757664296230559852",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1757664296230559839",
						["startPort"] = "Out",
						["endQuest"] = "1757664296230559850",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1757664296230559853",
						["startPort"] = "Out",
						["endQuest"] = "1757664296230559838",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "1757664296230559846",
						["startPort"] = "Out",
						["endQuest"] = "1757664296230559840",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1757664296230559841",
						["startPort"] = "Out",
						["endQuest"] = "1757664296230559847",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1757664296230559841",
						["startPort"] = "Out",
						["endQuest"] = "1757664296230559849",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1757664296230559836",
						["startPort"] = "QuestStart",
						["endQuest"] = "1757664296230559843",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1757664296230559836",
						["startPort"] = "QuestStart",
						["endQuest"] = "1757664296230559842",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1757664296230559836"] = {
						["key"] = "1757664296230559836",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 709.5,
							["y"] = 210.25
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1757664296230559837"] = {
						["key"] = "1757664296230559837",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3974.854655148773,
							["y"] = 853.7466748937338
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1757664296230559838"] = {
						["key"] = "1757664296230559838",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1952.522727272727,
							["y"] = 1177.3214285714284
						},
						["propsData"] = {}
					},
					["1757664296230559839"] = {
						["key"] = "1757664296230559839",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1285.1648330384783,
							["y"] = 572.8036088544219
						},
						["propsData"] = {}
					},
					["1757664296230559840"] = {
						["key"] = "1757664296230559840",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2759.1220823809836,
							["y"] = 371.7974592486974
						},
						["propsData"] = {}
					},
					["1757664296230559841"] = {
						["key"] = "1757664296230559841",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1295.4721958348555,
							["y"] = 262.36015782743294
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1230049,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_Feina04_1230049"
						}
					},
					["1757664296230559842"] = {
						["key"] = "1757664296230559842",
						["type"] = "ChangeRoleNode",
						["name"] = "切换角色",
						["pos"] = {
							["x"] = 1234.5840378056232,
							["y"] = -89.4294609869581
						},
						["propsData"] = {
							["QuestRoleId"] = 10301002,
							["IsPlayFX"] = false
						}
					},
					["1757664296230559843"] = {
						["key"] = "1757664296230559843",
						["type"] = "ShowOrHideUINode",
						["name"] = "显示或隐藏UI",
						["pos"] = {
							["x"] = 1229.7799465574592,
							["y"] = -256.23131278890935
						},
						["propsData"] = {
							["Function"] = "HideUIInScreen",
							["UIParam"] = "EnergySkill",
							["ActionParam"] = "None",
							["ShowOrHide"] = true
						}
					},
					["1757664296230559844"] = {
						["key"] = "1757664296230559844",
						["type"] = "ShowOrHideUINode",
						["name"] = "显示或隐藏UI",
						["pos"] = {
							["x"] = 1538.2200534425408,
							["y"] = -270.57053901304187
						},
						["propsData"] = {
							["Function"] = "HideUIInScreen",
							["UIParam"] = "BloodBar",
							["ActionParam"] = "None",
							["ShowOrHide"] = true
						}
					},
					["1757664296230559845"] = {
						["key"] = "1757664296230559845",
						["type"] = "CameraControlNode",
						["name"] = "镜头控制节点",
						["pos"] = {
							["x"] = 1539.2767692651494,
							["y"] = -108.3096794127566
						},
						["propsData"] = {
							["Duration"] = 4,
							["CameraName"] = "StoryEast01Nai01",
							["LockRotate"] = false,
							["FocalLength"] = 0,
							["LensAperture"] = 0,
							["FOV"] = 80,
							["PPMaterialPath"] = ""
						}
					},
					["1757664296230559846"] = {
						["key"] = "1757664296230559846",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "等待任务完成",
						["pos"] = {
							["x"] = 2307.4906050623663,
							["y"] = 344.12582000167725
						},
						["propsData"] = {
							["ListenCount"] = 2,
							["NeedFinishCount"] = 2
						}
					},
					["1757664296230559847"] = {
						["key"] = "1757664296230559847",
						["type"] = "ShowOrHideUINode",
						["name"] = "显示或隐藏UI",
						["pos"] = {
							["x"] = 1716.5093949376337,
							["y"] = 191.44330065498497
						},
						["propsData"] = {
							["Function"] = "HideUIInScreen",
							["UIParam"] = "EnergySkill",
							["ActionParam"] = "None",
							["ShowOrHide"] = false
						}
					},
					["1757664296230559848"] = {
						["key"] = "1757664296230559848",
						["type"] = "ShowOrHideUINode",
						["name"] = "显示或隐藏UI",
						["pos"] = {
							["x"] = 1992.5205410775775,
							["y"] = 204.79153690443974
						},
						["propsData"] = {
							["Function"] = "HideUIInScreen",
							["UIParam"] = "BloodBar",
							["ActionParam"] = "None",
							["ShowOrHide"] = false
						}
					},
					["1757664296230559849"] = {
						["key"] = "1757664296230559849",
						["type"] = "CameraControlClearNode",
						["name"] = "镜头恢复",
						["pos"] = {
							["x"] = 1828.7421044267353,
							["y"] = 381.20846309556026
						},
						["propsData"] = {
							["Duration"] = 3
						}
					},
					["1757664296230559850"] = {
						["key"] = "1757664296230559850",
						["type"] = "RestoreRoleNode",
						["name"] = "恢复角色",
						["pos"] = {
							["x"] = 1354.4746945430174,
							["y"] = 845.5962796918501
						},
						["propsData"] = {}
					},
					["1757664296230559851"] = {
						["key"] = "1757664296230559851",
						["type"] = "CameraControlClearNode",
						["name"] = "镜头恢复",
						["pos"] = {
							["x"] = 1577.3705945666272,
							["y"] = 905.9211932973369
						},
						["propsData"] = {
							["Duration"] = 3
						}
					},
					["1757664296230559852"] = {
						["key"] = "1757664296230559852",
						["type"] = "ShowOrHideUINode",
						["name"] = "显示或隐藏UI",
						["pos"] = {
							["x"] = 1345.3859566373653,
							["y"] = 993.2227608356268
						},
						["propsData"] = {
							["Function"] = "HideUIInScreen",
							["UIParam"] = "EnergySkill",
							["ActionParam"] = "None",
							["ShowOrHide"] = false
						}
					},
					["1757664296230559853"] = {
						["key"] = "1757664296230559853",
						["type"] = "ShowOrHideUINode",
						["name"] = "显示或隐藏UI",
						["pos"] = {
							["x"] = 1592.5253054569826,
							["y"] = 1054.4037203081498
						},
						["propsData"] = {
							["Function"] = "HideUIInScreen",
							["UIParam"] = "BloodBar",
							["ActionParam"] = "None",
							["ShowOrHide"] = false
						}
					}
				},
				["commentData"] = {
					["175758395262543975728"] = {
						["key"] = "175758395262543975728",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 1309.5,
							["y"] = 754
						},
						["size"] = {
							["width"] = 534,
							["height"] = 480
						}
					},
					["175758398859843976150"] = {
						["key"] = "175758398859843976150",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 1204,
							["y"] = -358
						},
						["size"] = {
							["width"] = 600,
							["height"] = 400
						}
					},
					["175758399952643976535"] = {
						["key"] = "175758399952643976535",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 1652,
							["y"] = 96
						},
						["size"] = {
							["width"] = 924,
							["height"] = 454
						}
					}
				}
			}
		}
	},
	["commentData"] = {}
}