return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1769501506889308",
			["startPort"] = "Success",
			["endStory"] = "1769501506889309",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17695014956161",
			["startPort"] = "StoryStart",
			["endStory"] = "17695041202233736736",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17695041202233736736",
			["startPort"] = "Success",
			["endStory"] = "1769501506889308",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1769501506889309",
			["startPort"] = "Success",
			["endStory"] = "17735828291484229783",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17735828291484229783",
			["startPort"] = "Success",
			["endStory"] = "17695014956165",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17695014956161"] = {
			["isStoryNode"] = true,
			["key"] = "17695014956161",
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
		["17695014956165"] = {
			["isStoryNode"] = true,
			["key"] = "17695014956165",
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
		["1769501506889308"] = {
			["isStoryNode"] = true,
			["key"] = "1769501506889308",
			["type"] = "StoryNode",
			["name"] = "旋转跳跃",
			["pos"] = {
				["x"] = 1683.8526515218718,
				["y"] = 280.94259912995557
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
						["startQuest"] = "1769501506890322",
						["startPort"] = "Out",
						["endQuest"] = "1769501506890323",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506891324",
						["startPort"] = "Out",
						["endQuest"] = "1769501506891325",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506891324",
						["startPort"] = "Out",
						["endQuest"] = "1769501506891326",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506892334",
						["startPort"] = "Out",
						["endQuest"] = "1769501506893335",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506892334",
						["startPort"] = "Out",
						["endQuest"] = "1769501506893336",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506893335",
						["startPort"] = "Out",
						["endQuest"] = "1769501506895338",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506895339",
						["startPort"] = "Out",
						["endQuest"] = "1769501506893337",
						["endPort"] = "Branch_1"
					},
					{
						["startQuest"] = "1769501506895340",
						["startPort"] = "Out",
						["endQuest"] = "1769501506895339",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506895340",
						["startPort"] = "Out",
						["endQuest"] = "1769501506895341",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506893336",
						["startPort"] = "Out",
						["endQuest"] = "1769501506895342",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506896346",
						["startPort"] = "Out",
						["endQuest"] = "1769501506896347",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506896349",
						["startPort"] = "Out",
						["endQuest"] = "1769501506896352",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506896350",
						["startPort"] = "Out",
						["endQuest"] = "1769501506897353",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506896350",
						["startPort"] = "Out",
						["endQuest"] = "1769501506897354",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506890319",
						["startPort"] = "QuestStart",
						["endQuest"] = "1769501506897359",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506897359",
						["startPort"] = "Out",
						["endQuest"] = "1769501506890321",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "1769501506890322",
						["startPort"] = "Out",
						["endQuest"] = "17695025949941401",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17695030738052238334",
						["startPort"] = "Out",
						["endQuest"] = "17695030738052238335",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506896349",
						["startPort"] = "Out",
						["endQuest"] = "17695030738052238334",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506897354",
						["startPort"] = "Out",
						["endQuest"] = "17695032681492240328",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506891326",
						["startPort"] = "Out",
						["endQuest"] = "1769501506891327",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506891327",
						["startPort"] = "Out",
						["endQuest"] = "1769501506891328",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506892332",
						["startPort"] = "Out",
						["endQuest"] = "1769501506892334",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506896347",
						["startPort"] = "Out",
						["endQuest"] = "176951943640737972685",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176951943640737972685",
						["startPort"] = "Out",
						["endQuest"] = "1769501506896348",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506896349",
						["startPort"] = "Out",
						["endQuest"] = "1769501506896351",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17695030738052238334",
						["startPort"] = "Out",
						["endQuest"] = "176952089326038721369",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506897354",
						["startPort"] = "Out",
						["endQuest"] = "176952099305539467405",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506897354",
						["startPort"] = "Out",
						["endQuest"] = "1769501506897355",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176952124856940213901",
						["startPort"] = "Out",
						["endQuest"] = "1769501506897357",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506890322",
						["startPort"] = "Out",
						["endQuest"] = "176960358579626934620",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176960358579626934620",
						["startPort"] = "Out",
						["endQuest"] = "1769501506891324",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506893335",
						["startPort"] = "Out",
						["endQuest"] = "176960535942927684616",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176960535942927684616",
						["startPort"] = "Out",
						["endQuest"] = "1769501506895340",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506895339",
						["startPort"] = "Out",
						["endQuest"] = "176960544460627685212",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506895340",
						["startPort"] = "Out",
						["endQuest"] = "176960545082027685337",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506893336",
						["startPort"] = "Out",
						["endQuest"] = "176960645376729180384",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176960645376729180384",
						["startPort"] = "Out",
						["endQuest"] = "1769501506895343",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506896350",
						["startPort"] = "Out",
						["endQuest"] = "176960686041733666286",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506892334",
						["startPort"] = "Out",
						["endQuest"] = "17698515651021820",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176951943640737972685",
						["startPort"] = "Out",
						["endQuest"] = "1769501506896349",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506890319",
						["startPort"] = "QuestStart",
						["endQuest"] = "17704614525198468293",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506895343",
						["startPort"] = "Out",
						["endQuest"] = "177046259801910008573",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17695032681492240328",
						["startPort"] = "Out",
						["endQuest"] = "177046419155512318171",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506898360",
						["startPort"] = "true",
						["endQuest"] = "1769501506890322",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506898360",
						["startPort"] = "false",
						["endQuest"] = "1769501506890320",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1769501506891327",
						["startPort"] = "Out",
						["endQuest"] = "1770468484156771991",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506891328",
						["startPort"] = "Out",
						["endQuest"] = "1769501506892330",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176960380954226936271",
						["startPort"] = "Out",
						["endQuest"] = "1769501506892331",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176960380954226936271",
						["startPort"] = "Out",
						["endQuest"] = "1769501506892332",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506892330",
						["startPort"] = "Out",
						["endQuest"] = "176960380954226936271",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506895343",
						["startPort"] = "Out",
						["endQuest"] = "1769501506893337",
						["endPort"] = "Branch_2"
					},
					{
						["startQuest"] = "1769501506893337",
						["startPort"] = "Out",
						["endQuest"] = "1769501506896345",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506896345",
						["startPort"] = "Out",
						["endQuest"] = "1769501506896346",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17695030738052238334",
						["startPort"] = "Out",
						["endQuest"] = "1769501506896350",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506890319",
						["startPort"] = "QuestStart",
						["endQuest"] = "1769501506898360",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506897358",
						["startPort"] = "Out",
						["endQuest"] = "1769501506890320",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "1769501506898360",
						["startPort"] = "true",
						["endQuest"] = "1769502686013747227",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177046286119810009143",
						["startPort"] = "Out",
						["endQuest"] = "176952124856940213901",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177046286119810009143",
						["startPort"] = "Out",
						["endQuest"] = "17706343140853087709",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506897354",
						["startPort"] = "Out",
						["endQuest"] = "177046286119810009143",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177046286119810009143",
						["startPort"] = "Out",
						["endQuest"] = "17695034018122241457",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506897357",
						["startPort"] = "Out",
						["endQuest"] = "17707146335686178709",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17707146335686178709",
						["startPort"] = "Out",
						["endQuest"] = "1769501506897358",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506891324",
						["startPort"] = "Out",
						["endQuest"] = "17732380194028615912",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506890319",
						["startPort"] = "QuestStart",
						["endQuest"] = "17734993474669285407",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177356980999418573243",
						["startPort"] = "Out",
						["endQuest"] = "17695030272122237678",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506890319",
						["startPort"] = "QuestStart",
						["endQuest"] = "177356980999418573243",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1769501506890319"] = {
						["key"] = "1769501506890319",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -340.00000000000205,
							["y"] = 321.42857142857144
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1769501506890320"] = {
						["key"] = "1769501506890320",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3734.6384118864917,
							["y"] = 3275.063987334067
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1769501506890321"] = {
						["key"] = "1769501506890321",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1488.7499999999973,
							["y"] = 3450.000000000002
						},
						["propsData"] = {}
					},
					["1769501506890322"] = {
						["key"] = "1769501506890322",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1206.7397456176611,
							["y"] = 371.15339752560664
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 242310254,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020406hezi8_242310254"
						}
					},
					["1769501506890323"] = {
						["key"] = "1769501506890323",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1493.3816106970264,
							["y"] = 193.54451000508124
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "XSB1"
						}
					},
					["1769501506891324"] = {
						["key"] = "1769501506891324",
						["type"] = "BossBattleFinishNode",
						["name"] = "敲了",
						["pos"] = {
							["x"] = 1753.5926892647412,
							["y"] = 382.80912124159795
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "YYG_1XSBover"
						}
					},
					["1769501506891325"] = {
						["key"] = "1769501506891325",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1941.1622302342819,
							["y"] = 54.53996863034
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "XSB1"
						}
					},
					["1769501506891326"] = {
						["key"] = "1769501506891326",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 2062.179132851184,
							["y"] = 377.1538682442395
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "pintu1"
						}
					},
					["1769501506891327"] = {
						["key"] = "1769501506891327",
						["type"] = "BossBattleFinishNode",
						["name"] = "拼图1",
						["pos"] = {
							["x"] = 2368.896983476931,
							["y"] = 373.5189193856065
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "YYG_1XSBswitch"
						}
					},
					["1769501506891328"] = {
						["key"] = "1769501506891328",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1172.3617409416877,
							["y"] = 815.0435429646418
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 242310255,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020406hezi9_242310255"
						}
					},
					["1769501506892330"] = {
						["key"] = "1769501506892330",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1457.3807272731942,
							["y"] = 825.3417078001614
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 242310256,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020406hezi10_242310256"
						}
					},
					["1769501506892331"] = {
						["key"] = "1769501506892331",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 2076.2066074918375,
							["y"] = 654.5861594011918
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "XSB2"
						}
					},
					["1769501506892332"] = {
						["key"] = "1769501506892332",
						["type"] = "BossBattleFinishNode",
						["name"] = "敲了2",
						["pos"] = {
							["x"] = 2104.9993800721104,
							["y"] = 810.7334089234414
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "YYG_2XSBover"
						}
					},
					["1769501506892334"] = {
						["key"] = "1769501506892334",
						["type"] = "BranchQuestStartNode",
						["name"] = "子任务开始节点",
						["pos"] = {
							["x"] = 1187.9808833857921,
							["y"] = 1265.839258348685
						},
						["propsData"] = {
							["AllQuestOptions"] = {
								{
									["IsNeedFinish"] = false,
									["BranchQuestName"] = "宝箱",
									["TargetBranchQuestKey"] = ""
								},
								{
									["IsNeedFinish"] = false,
									["BranchQuestName"] = "正路",
									["TargetBranchQuestKey"] = ""
								}
							},
							["IsSetCountInfo"] = false,
							["IsDifftation"] = true,
							["AllDiffGuideOptions"] = {
								{
									["OptionElements"] = {
										{
											["TargetIndicatorKey"] = "1769501506893335",
											["IsShowOptional"] = true
										}
									}
								},
								{
									["OptionElements"] = {
										{
											["TargetIndicatorKey"] = "1769501506893336",
											["IsShowOptional"] = false
										}
									}
								}
							}
						}
					},
					["1769501506893335"] = {
						["key"] = "1769501506893335",
						["type"] = "GoToNode",
						["name"] = "宝箱",
						["pos"] = {
							["x"] = 1465.402962498294,
							["y"] = 1269.3063809512932
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 242310257,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020406hezi11_242310257"
						}
					},
					["1769501506893336"] = {
						["key"] = "1769501506893336",
						["type"] = "GoToNode",
						["name"] = "正路",
						["pos"] = {
							["x"] = 1418.5033010023383,
							["y"] = 1665.0069788696517
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 242310258,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020406hezi12_242310258"
						}
					},
					["1769501506893337"] = {
						["key"] = "1769501506893337",
						["type"] = "CheckBranchQuestFinishedNode",
						["name"] = "子任务结束节点",
						["pos"] = {
							["x"] = 2750.2311814131526,
							["y"] = 1523.785216247847
						},
						["propsData"] = {
							["InputBranchQuestNumber"] = 2,
							["BranchQuestFinishOptions"] = {
								{
									["IsNeedFinish"] = false
								},
								{
									["IsNeedFinish"] = true
								}
							}
						}
					},
					["1769501506895338"] = {
						["key"] = "1769501506895338",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1769.3429736595283,
							["y"] = 1120.9855786491123
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "XSB3"
						}
					},
					["1769501506895339"] = {
						["key"] = "1769501506895339",
						["type"] = "BossBattleFinishNode",
						["name"] = "完成BOSS战阶段",
						["pos"] = {
							["x"] = 2283.116132429954,
							["y"] = 1296.0522318537203
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "YYGbaoxiang"
						}
					},
					["1769501506895340"] = {
						["key"] = "1769501506895340",
						["type"] = "BossBattleFinishNode",
						["name"] = "敲了3",
						["pos"] = {
							["x"] = 2008.1546550188868,
							["y"] = 1279.211082042987
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "YYG_3XSBover"
						}
					},
					["1769501506895341"] = {
						["key"] = "1769501506895341",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "宝箱解谜",
						["pos"] = {
							["x"] = 2265.540929725457,
							["y"] = 1116.6422030499066
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "YYGbaoxiang"
						}
					},
					["1769501506895342"] = {
						["key"] = "1769501506895342",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1701.366641049787,
							["y"] = 1526.6771172460471
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "XSB4"
						}
					},
					["1769501506895343"] = {
						["key"] = "1769501506895343",
						["type"] = "BossBattleFinishNode",
						["name"] = "敲了4",
						["pos"] = {
							["x"] = 1988.956810702246,
							["y"] = 1707.2633676901855
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "YYG_4XSBover"
						}
					},
					["1769501506895344"] = {
						["key"] = "1769501506895344",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2346.9961226488804,
							["y"] = 1496.8171848191625
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 242310259,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020406hezi13_242310259"
						}
					},
					["1769501506896345"] = {
						["key"] = "1769501506896345",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 846.1177912466862,
							["y"] = 2109.789669473561
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 242310260,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020406hezi14_242310260"
						}
					},
					["1769501506896346"] = {
						["key"] = "1769501506896346",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生怪",
						["pos"] = {
							["x"] = 1183.8643473772038,
							["y"] = 2130.7943865716666
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								162310197,
								162310198,
								162310199,
								162310200,
								162310201,
								162310202,
								162310203,
								162310204,
								162310205,
								162310206
							}
						}
					},
					["1769501506896347"] = {
						["key"] = "1769501506896347",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1153.9823519718605,
							["y"] = 2298.585890185058
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 10,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								162310197,
								162310198,
								162310199,
								162310200,
								162310201,
								162310202,
								162310203,
								162310204,
								162310205,
								162310206
							}
						}
					},
					["1769501506896348"] = {
						["key"] = "1769501506896348",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1437.4314394581927,
							["y"] = 2048.3056543631187
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "XSB5"
						}
					},
					["1769501506896349"] = {
						["key"] = "1769501506896349",
						["type"] = "BossBattleFinishNode",
						["name"] = "敲了5",
						["pos"] = {
							["x"] = 1722.0248103295673,
							["y"] = 2315.1242038661435
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "YYG_5XSBover"
						}
					},
					["1769501506896350"] = {
						["key"] = "1769501506896350",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2221.1822093005694,
							["y"] = 2276.8063526706724
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 242310261,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020406hezi15_242310261"
						}
					},
					["1769501506896351"] = {
						["key"] = "1769501506896351",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 2021.814306942225,
							["y"] = 2069.4532073568816
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "pintu5"
						}
					},
					["1769501506896352"] = {
						["key"] = "1769501506896352",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1697.4562164819608,
							["y"] = 2051.617718027371
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "XSB5"
						}
					},
					["1769501506897353"] = {
						["key"] = "1769501506897353",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 2521.543169190033,
							["y"] = 2042.2773410153798
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "XSB6"
						}
					},
					["1769501506897354"] = {
						["key"] = "1769501506897354",
						["type"] = "BossBattleFinishNode",
						["name"] = "敲了6",
						["pos"] = {
							["x"] = 2521.345370228551,
							["y"] = 2282.4645827236573
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "YYG_6XSBover"
						}
					},
					["1769501506897355"] = {
						["key"] = "1769501506897355",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 3095.4106321645913,
							["y"] = 2023.6428593279304
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "pintu6"
						}
					},
					["1769501506897357"] = {
						["key"] = "1769501506897357",
						["type"] = "TalkNode",
						["name"] = "鸟",
						["pos"] = {
							["x"] = 3732.5467176316943,
							["y"] = 2272.6056571336285
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "LevelSequence'/Game/AssetDesign/LD_Seq/East02/YYG01.YYG01'",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = false,
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
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								}
							},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["1769501506897358"] = {
						["key"] = "1769501506897358",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 4259.201090884394,
							["y"] = 2279.3945144230634
						},
						["propsData"] = {
							["VarName"] = "East02YYG2Phase",
							["VarValue"] = 2
						}
					},
					["1769501506897359"] = {
						["key"] = "1769501506897359",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 792.8418760090296,
							["y"] = 3370.0432062439577
						},
						["propsData"] = {}
					},
					["1769501506898360"] = {
						["key"] = "1769501506898360",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "变量=0",
						["pos"] = {
							["x"] = 437.90695502408596,
							["y"] = 462.49333944408545
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "East02YYG2Phase",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "1"
								}
							}
						}
					},
					["17695025818741128"] = {
						["key"] = "17695025818741128",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 516.9746498599438,
							["y"] = 153.45227909345593
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "TowerStart",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17695025949941401"] = {
						["key"] = "17695025949941401",
						["type"] = "TalkNode",
						["name"] = "好大",
						["pos"] = {
							["x"] = 1508.9625119978061,
							["y"] = 8.922109263285947
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12049096,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1769502686013747227"] = {
						["key"] = "1769502686013747227",
						["type"] = "TalkNode",
						["name"] = "重力",
						["pos"] = {
							["x"] = 907.0121020575812,
							["y"] = 173.16905408432683
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12048730,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17695030272122237678"] = {
						["key"] = "17695030272122237678",
						["type"] = "TalkNode",
						["name"] = "好大",
						["pos"] = {
							["x"] = 356.38417836836675,
							["y"] = -301.38765336592877
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12049098,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17695030738052238334"] = {
						["key"] = "17695030738052238334",
						["type"] = "BossBattleFinishNode",
						["name"] = "5号完成拼图",
						["pos"] = {
							["x"] = 1968.149893023618,
							["y"] = 2317.335194617848
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "YYG_5PintuOver"
						}
					},
					["17695030738052238335"] = {
						["key"] = "17695030738052238335",
						["type"] = "TalkNode",
						["name"] = "咦，飘浮的石块竟然复原成了画中的样子……！好神奇！",
						["pos"] = {
							["x"] = 2292.8641787379033,
							["y"] = 2512.3193216019754
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12049101,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17695031062182238778"] = {
						["key"] = "17695031062182238778",
						["type"] = "TalkNode",
						["name"] = "登上去吧",
						["pos"] = {
							["x"] = 3751.4589281913486,
							["y"] = 2059.2330430951324
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12049101,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17695032681492240328"] = {
						["key"] = "17695032681492240328",
						["type"] = "BossBattleFinishNode",
						["name"] = "拼好了",
						["pos"] = {
							["x"] = 3168.1775532154074,
							["y"] = 2182.211282292156
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "YYG_6PintuOver"
						}
					},
					["17695034018122241457"] = {
						["key"] = "17695034018122241457",
						["type"] = "TalkNode",
						["name"] = "这是牵机鸟的原型",
						["pos"] = {
							["x"] = 3456.167867775688,
							["y"] = 2677.933823077485
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12049104,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["176951943640737972685"] = {
						["key"] = "176951943640737972685",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 1416.0280477740978,
							["y"] = 2321.76005334401
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "YYG_Pintu_Kill",
							["UnitId"] = -1
						}
					},
					["176952089326038721369"] = {
						["key"] = "176952089326038721369",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 2303.6120823729766,
							["y"] = 2677.732270525232
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "pintu5"
						}
					},
					["176952099305539467405"] = {
						["key"] = "176952099305539467405",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 2799.1676379285327,
							["y"] = 2050.1767149696766
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "XSB6"
						}
					},
					["176952124856940213901"] = {
						["key"] = "176952124856940213901",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 3461.7758649017164,
							["y"] = 2293.754304301497
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 242310297,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_bird_242310297"
						}
					},
					["176960358579626934620"] = {
						["key"] = "176960358579626934620",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 1475.2049578086028,
							["y"] = 388.74776424200957
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "YYG_1XSB",
							["UnitId"] = -1
						}
					},
					["176960380954226936271"] = {
						["key"] = "176960380954226936271",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 1798.0129680216494,
							["y"] = 817.9580565026604
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "YYG_2XSB",
							["UnitId"] = -1
						}
					},
					["176960535942927684616"] = {
						["key"] = "176960535942927684616",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 1731.175955791241,
							["y"] = 1294.8465026522313
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "YYG_3XSB",
							["UnitId"] = -1
						}
					},
					["176960544460627685212"] = {
						["key"] = "176960544460627685212",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "宝箱解谜",
						["pos"] = {
							["x"] = 2561.6909204706108,
							["y"] = 1118.4809337661673
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "YYGbaoxiang"
						}
					},
					["176960545082027685337"] = {
						["key"] = "176960545082027685337",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 2005.2393075673847,
							["y"] = 1122.8035144113287
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "XSB3"
						}
					},
					["176960645376729180384"] = {
						["key"] = "176960645376729180384",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 1681.2380208474128,
							["y"] = 1711.7356992508358
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "YYG_4XSB",
							["UnitId"] = -1
						}
					},
					["176960686041733666286"] = {
						["key"] = "176960686041733666286",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 2605.6069841659287,
							["y"] = 2482.195591064619
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "YYG_6XSB",
							["UnitId"] = -1
						}
					},
					["17698515651021820"] = {
						["key"] = "17698515651021820",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1456.1979966415265,
							["y"] = 1104.911938364232
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12049084,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17704614525198468293"] = {
						["key"] = "17704614525198468293",
						["type"] = "ActivePlayerSkillsNode",
						["name"] = "激活/失效 玩家技能",
						["pos"] = {
							["x"] = 162.08078526668533,
							["y"] = 160.2948567550485
						},
						["propsData"] = {
							["PlayerId"] = 0,
							["bActiveEnable"] = false,
							["ActiveType"] = "Lock",
							["SkillNameList"] = {
								"SecondJump",
								"BulletJump",
								"Avoid",
								"Slide"
							}
						}
					},
					["177046259801910008573"] = {
						["key"] = "177046259801910008573",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1992.848102801109,
							["y"] = 1516.439200531651
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "XSB4"
						}
					},
					["177046286119810009143"] = {
						["key"] = "177046286119810009143",
						["type"] = "BossBattleFinishNode",
						["name"] = "完成BOSS战阶段",
						["pos"] = {
							["x"] = 3169.863538765394,
							["y"] = 2326.8607075268233
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "YYG_Bird_SeqSetPL"
						}
					},
					["177046419155512318171"] = {
						["key"] = "177046419155512318171",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 3464.351110724551,
							["y"] = 2047.5979486625831
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "pintu6"
						}
					},
					["1770468484156771991"] = {
						["key"] = "1770468484156771991",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 2546.578329361935,
							["y"] = -5.08502558053442
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "pintu1"
						}
					},
					["17706343140853087709"] = {
						["key"] = "17706343140853087709",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 3451.2756069163192,
							["y"] = 2490.659924363874
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "BirdOver_Point",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17707146335686178709"] = {
						["key"] = "17707146335686178709",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "塔",
						["pos"] = {
							["x"] = 4027.4285714285716,
							["y"] = 2298.6820276497697
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "TowerStart",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17732380194028615912"] = {
						["key"] = "17732380194028615912",
						["type"] = "ShowGuideMainNode",
						["name"] = "显示图文引导",
						["pos"] = {
							["x"] = 2060.983585858586,
							["y"] = 226.22090469916583
						},
						["propsData"] = {
							["GuideId"] = 121
						}
					},
					["17734993474669285407"] = {
						["key"] = "17734993474669285407",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 155.8058338720109,
							["y"] = -30.601963396081842
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "YYG_Restart4",
							["UnitId"] = -1
						}
					},
					["177356980999418573243"] = {
						["key"] = "177356980999418573243",
						["type"] = "BossBattleFinishNode",
						["name"] = "完成BOSS战阶段",
						["pos"] = {
							["x"] = 81.32167836836675,
							["y"] = -297.51265336592877
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "YYG_Platform03_Start"
						}
					}
				},
				["commentData"] = {
					["17694259401242977708"] = {
						["key"] = "17694259401242977708",
						["name"] = "拼图1",
						["position"] = {
							["x"] = 1138.482481312428,
							["y"] = -117.54217687107803
						},
						["size"] = {
							["width"] = 1632.4367622104605,
							["height"] = 659.3851792083257
						}
					},
					["17694261600582978766"] = {
						["key"] = "17694261600582978766",
						["name"] = "拼图2",
						["position"] = {
							["x"] = 1132.9081278880744,
							["y"] = 563.2963235174226
						},
						["size"] = {
							["width"] = 1219.0120730693307,
							["height"] = 396.77994906006666
						}
					},
					["17694303096545955053"] = {
						["key"] = "17694303096545955053",
						["name"] = "分支",
						["position"] = {
							["x"] = 1117.0657312388878,
							["y"] = 1043.3645520878438
						},
						["size"] = {
							["width"] = 2017.3788915703892,
							["height"] = 886.6698349612409
						}
					},
					["176943408034011157417"] = {
						["key"] = "176943408034011157417",
						["name"] = "XSB5",
						["position"] = {
							["x"] = 1118.3313063260748,
							["y"] = 1945.9280811170786
						},
						["size"] = {
							["width"] = 2847.1603512049005,
							["height"] = 525.3418766762584
						}
					}
				}
			}
		},
		["1769501506889309"] = {
			["isStoryNode"] = true,
			["key"] = "1769501506889309",
			["type"] = "StoryNode",
			["name"] = "塔内",
			["pos"] = {
				["x"] = 2057.0218073525866,
				["y"] = 294.22926731777284
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
						["startQuest"] = "1769501506928532",
						["startPort"] = "Out",
						["endQuest"] = "1769501506928533",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506928532",
						["startPort"] = "Out",
						["endQuest"] = "1769501506928534",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506928534",
						["startPort"] = "Out",
						["endQuest"] = "1769501506928536",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506928536",
						["startPort"] = "Out",
						["endQuest"] = "1769501506928537",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506928539",
						["startPort"] = "Out",
						["endQuest"] = "1769501506929541",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506928537",
						["startPort"] = "Out",
						["endQuest"] = "1769501506928539",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506928537",
						["startPort"] = "Out",
						["endQuest"] = "1769501506928538",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506929544",
						["startPort"] = "Out",
						["endQuest"] = "1769501506930546",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506929542",
						["startPort"] = "Out",
						["endQuest"] = "1769501506929544",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506929542",
						["startPort"] = "Out",
						["endQuest"] = "1769501506929543",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506930546",
						["startPort"] = "Out",
						["endQuest"] = "1769501506930547",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506930547",
						["startPort"] = "Out",
						["endQuest"] = "1769501506930548",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506930548",
						["startPort"] = "Out",
						["endQuest"] = "1769501506930549",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506927526",
						["startPort"] = "QuestStart",
						["endQuest"] = "1769501506931553",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506931553",
						["startPort"] = "Out",
						["endQuest"] = "1769501506927528",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17695034673352242791",
						["startPort"] = "Out",
						["endQuest"] = "17695034441312242252",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17695034673352242791",
						["startPort"] = "Out",
						["endQuest"] = "1769501506927531",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506930551",
						["startPort"] = "Out",
						["endQuest"] = "17695036077852244139",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506930546",
						["startPort"] = "Out",
						["endQuest"] = "17695036346892244501",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17695036730362990308",
						["startPort"] = "Out",
						["endQuest"] = "1769501506930550",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506928536",
						["startPort"] = "Out",
						["endQuest"] = "17695037659563736435",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17695037659563736435",
						["startPort"] = "Out",
						["endQuest"] = "17695035028582243413",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506927531",
						["startPort"] = "Out",
						["endQuest"] = "176952162246340961387",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506928534",
						["startPort"] = "Out",
						["endQuest"] = "176952164038640961735",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506928539",
						["startPort"] = "Out",
						["endQuest"] = "176952181679440962492",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506929544",
						["startPort"] = "Out",
						["endQuest"] = "176952185125940962754",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176952217411840963439",
						["startPort"] = "Out",
						["endQuest"] = "1769501506930551",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506931552",
						["startPort"] = "Out",
						["endQuest"] = "176952257314940963952",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176952257314940963952",
						["startPort"] = "Out",
						["endQuest"] = "17695036730362990308",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506927530",
						["startPort"] = "Out",
						["endQuest"] = "176960711048535909350",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176960711048535909350",
						["startPort"] = "Out",
						["endQuest"] = "17695034673352242791",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506927531",
						["startPort"] = "Out",
						["endQuest"] = "1769501506928532",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176952217411840963439",
						["startPort"] = "Out",
						["endQuest"] = "17706206471788456316",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506929541",
						["startPort"] = "Out",
						["endQuest"] = "17707064911483866420",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17707064911483866420",
						["startPort"] = "Out",
						["endQuest"] = "1769501506929542",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506928534",
						["startPort"] = "Out",
						["endQuest"] = "17707329883423858789",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506928539",
						["startPort"] = "Out",
						["endQuest"] = "17707330206023859183",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506929544",
						["startPort"] = "Out",
						["endQuest"] = "17707330417213859400",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506930551",
						["startPort"] = "Out",
						["endQuest"] = "1769501506931552",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506930551",
						["startPort"] = "Out",
						["endQuest"] = "17731311988922538324",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176952257314940963952",
						["startPort"] = "Out",
						["endQuest"] = "17731312250372538537",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506929541",
						["startPort"] = "Out",
						["endQuest"] = "177357063882720261477",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17735830349535924189",
						["startPort"] = "true",
						["endQuest"] = "17735830452895924447",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17735830349535924189",
						["startPort"] = "false",
						["endQuest"] = "1769501506927527",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17735830452895924447",
						["startPort"] = "Out",
						["endQuest"] = "17734993551279285571",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17735830452895924447",
						["startPort"] = "Out",
						["endQuest"] = "17704691504534614923",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17735830452895924447",
						["startPort"] = "Out",
						["endQuest"] = "1769501506927530",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17735830452895924447",
						["startPort"] = "Out",
						["endQuest"] = "17695034238712241810",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506927526",
						["startPort"] = "QuestStart",
						["endQuest"] = "17735830349535924189",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1769501506930549",
						["startPort"] = "Out",
						["endQuest"] = "17735831552276771241",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17735831552276771241",
						["startPort"] = "Out",
						["endQuest"] = "1769501506927527",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["1769501506927526"] = {
						["key"] = "1769501506927526",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 422.85714285714283,
							["y"] = 291.42857142857144
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1769501506927527"] = {
						["key"] = "1769501506927527",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 3064.396026986507,
							["y"] = 1886.322563718142
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1769501506927528"] = {
						["key"] = "1769501506927528",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 847.6770186335397,
							["y"] = -246.88819875776434
						},
						["propsData"] = {}
					},
					["1769501506927529"] = {
						["key"] = "1769501506927529",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "塔",
						["pos"] = {
							["x"] = 551.1945652173913,
							["y"] = -523.1547101449277
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "TowerStart",
							["FadeIn"] = true,
							["FadeOut"] = true,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["1769501506927530"] = {
						["key"] = "1769501506927530",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1456.8339655215425,
							["y"] = 276.2813743965094
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 162310241,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_TowerMonsterTrigger_162310241"
						}
					},
					["1769501506927531"] = {
						["key"] = "1769501506927531",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2315.3687108549193,
							["y"] = 268.41378400248107
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 242310263,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020406hezi17_242310263"
						}
					},
					["1769501506928532"] = {
						["key"] = "1769501506928532",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 838.957043225377,
							["y"] = 881.0599180142319
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 242310264,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020406hezi18_242310264"
						}
					},
					["1769501506928533"] = {
						["key"] = "1769501506928533",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 871.7839137804503,
							["y"] = 670.1339008512302
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "TXSB1"
						}
					},
					["1769501506928534"] = {
						["key"] = "1769501506928534",
						["type"] = "BossBattleFinishNode",
						["name"] = "敲了1",
						["pos"] = {
							["x"] = 1186.0703517285167,
							["y"] = 884.5742695547416
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "YYG_Tower1"
						}
					},
					["1769501506928535"] = {
						["key"] = "1769501506928535",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1874.473830121469,
							["y"] = 672.6073370720194
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "TPintu1"
						}
					},
					["1769501506928536"] = {
						["key"] = "1769501506928536",
						["type"] = "BossBattleFinishNode",
						["name"] = "塔1Over",
						["pos"] = {
							["x"] = 1534.8505977982365,
							["y"] = 871.1699633346459
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "YYG_Tower1over"
						}
					},
					["1769501506928537"] = {
						["key"] = "1769501506928537",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 830.0681663125545,
							["y"] = 1378.454702142599
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 242310265,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020406hezi19_242310265"
						}
					},
					["1769501506928538"] = {
						["key"] = "1769501506928538",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 980.850615466984,
							["y"] = 1192.553596874579
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "TXSB2"
						}
					},
					["1769501506928539"] = {
						["key"] = "1769501506928539",
						["type"] = "BossBattleFinishNode",
						["name"] = "敲了1",
						["pos"] = {
							["x"] = 1186.1049461699854,
							["y"] = 1388.2034963721462
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "YYG_Tower2"
						}
					},
					["1769501506928540"] = {
						["key"] = "1769501506928540",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1510.7761013306144,
							["y"] = 1206.0110478595604
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "TPintu2"
						}
					},
					["1769501506929541"] = {
						["key"] = "1769501506929541",
						["type"] = "BossBattleFinishNode",
						["name"] = "塔1Over",
						["pos"] = {
							["x"] = 1526.1342040974127,
							["y"] = 1389.7438541836714
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "YYG_Tower2over"
						}
					},
					["1769501506929542"] = {
						["key"] = "1769501506929542",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 847.8612621740853,
							["y"] = 1862.5005965180867
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 242310266,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020406hezi20_242310266"
						}
					},
					["1769501506929543"] = {
						["key"] = "1769501506929543",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 905.9402928700431,
							["y"] = 1704.688108949525
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "TXSB3"
						}
					},
					["1769501506929544"] = {
						["key"] = "1769501506929544",
						["type"] = "BossBattleFinishNode",
						["name"] = "敲了1",
						["pos"] = {
							["x"] = 1215.3098067373987,
							["y"] = 1880.6611554535161
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "YYG_Tower3"
						}
					},
					["1769501506930545"] = {
						["key"] = "1769501506930545",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 2013.315647496405,
							["y"] = 1552.4707353384963
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "TPintu3"
						}
					},
					["1769501506930546"] = {
						["key"] = "1769501506930546",
						["type"] = "BossBattleFinishNode",
						["name"] = "塔1Over",
						["pos"] = {
							["x"] = 1536.0188032269177,
							["y"] = 1880.4564152258256
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "YYG_Tower3over"
						}
					},
					["1769501506930547"] = {
						["key"] = "1769501506930547",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1904.2799664380748,
							["y"] = 1884.5838700268007
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 242310267,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020406TowerEnd_242310267"
						}
					},
					["1769501506930548"] = {
						["key"] = "1769501506930548",
						["type"] = "TalkNode",
						["name"] = "鸟",
						["pos"] = {
							["x"] = 2200.855872987666,
							["y"] = 1878.737216680146
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "LevelSequence'/Game/AssetDesign/LD_Seq/East02/YYG02.YYG02'",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = false,
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
					["1769501506930549"] = {
						["key"] = "1769501506930549",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "BOSS",
						["pos"] = {
							["x"] = 2460.9168606270287,
							["y"] = 1889.7740322673048
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "TBOSS",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["1769501506930550"] = {
						["key"] = "1769501506930550",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 4887.150705043671,
							["y"] = 1996.222513126288
						},
						["propsData"] = {}
					},
					["1769501506930551"] = {
						["key"] = "1769501506930551",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成黑白狴犴",
						["pos"] = {
							["x"] = 3707.051694147447,
							["y"] = 2043.6626404911826
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								162310178,
								162310179
							}
						}
					},
					["1769501506931552"] = {
						["key"] = "1769501506931552",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 3976.940621010058,
							["y"] = 2035.5889378780066
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 2,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								162310178,
								162310179
							}
						}
					},
					["1769501506931553"] = {
						["key"] = "1769501506931553",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 602.431042624117,
							["y"] = -255.99789296394647
						},
						["propsData"] = {}
					},
					["17695034238712241810"] = {
						["key"] = "17695034238712241810",
						["type"] = "TalkNode",
						["name"] = "重力好像恢复正常",
						["pos"] = {
							["x"] = 1474.7957866941244,
							["y"] = 125.78606719367588
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12048802,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17695034441312242252"] = {
						["key"] = "17695034441312242252",
						["type"] = "TalkNode",
						["name"] = "通体以榫卯结构打造的高塔",
						["pos"] = {
							["x"] = 2305.3990494799314,
							["y"] = 8.061912352353499
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12049106,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17695034673352242791"] = {
						["key"] = "17695034673352242791",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 2065.2318424329287,
							["y"] = 269.4381488077142
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 10,
							["IsShow"] = true,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								162310229,
								162310230,
								162310231,
								162310232,
								162310233,
								162310234,
								162310235,
								162310236,
								162310237,
								162310238
							}
						}
					},
					["17695034815742243135"] = {
						["key"] = "17695034815742243135",
						["type"] = "TalkNode",
						["name"] = "石碑",
						["pos"] = {
							["x"] = 2617.5774551828895,
							["y"] = 299.09144490448864
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1202/12044701.12044701'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "",
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
					["17695035028582243413"] = {
						["key"] = "17695035028582243413",
						["type"] = "TalkNode",
						["name"] = "说起来，为什么",
						["pos"] = {
							["x"] = 2200.414644832254,
							["y"] = 865.1376130123829
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10010101,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17695036077852244139"] = {
						["key"] = "17695036077852244139",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 4004.2877342569914,
							["y"] = 1864.5331137885908
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12049114,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17695036346892244501"] = {
						["key"] = "17695036346892244501",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1900.7321787014357,
							["y"] = 1722.6362883917654
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12049113,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17695036730362990308"] = {
						["key"] = "17695036730362990308",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 4513.981502655017,
							["y"] = 2027.2070784112354
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1202/12044801.12044801'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "",
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
					["17695037659563736435"] = {
						["key"] = "17695037659563736435",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1879.5827194486599,
							["y"] = 854.5308450068375
						},
						["propsData"] = {
							["GuideUIEnable"] = false,
							["StaticCreatorId"] = 242310268,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020406hezi21_242310268"
						}
					},
					["176952162246340961387"] = {
						["key"] = "176952162246340961387",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 2591.801023083816,
							["y"] = 142.77086179963283
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "YYG_Read",
							["UnitId"] = -1
						}
					},
					["176952164038640961735"] = {
						["key"] = "176952164038640961735",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1108.9653026451056,
							["y"] = 678.8084480119464
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "TXSB1"
						}
					},
					["176952181679440962492"] = {
						["key"] = "176952181679440962492",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1257.935667538451,
							["y"] = 1215.220854844367
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "TXSB2"
						}
					},
					["176952185125940962754"] = {
						["key"] = "176952185125940962754",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 1215.8845705627396,
							["y"] = 1699.0249489920768
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "TXSB3"
						}
					},
					["176952217411840963439"] = {
						["key"] = "176952217411840963439",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 3527.5669750850457,
							["y"] = 2024.773484829464
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 242310269,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020406hezi22_242310269"
						}
					},
					["176952257314940963952"] = {
						["key"] = "176952257314940963952",
						["type"] = "SendMessageNode",
						["name"] = "打完boss",
						["pos"] = {
							["x"] = 4225.098315583628,
							["y"] = 2058.3519418130936
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "YYG_BOSS",
							["UnitId"] = -1
						}
					},
					["176960711048535909350"] = {
						["key"] = "176960711048535909350",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1752.465553818666,
							["y"] = 291.8740550877292
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								162310229,
								162310230,
								162310231,
								162310232,
								162310233,
								162310234,
								162310235,
								162310236,
								162310237,
								162310238
							}
						}
					},
					["17704691504534614923"] = {
						["key"] = "17704691504534614923",
						["type"] = "ActivePlayerSkillsNode",
						["name"] = "激活/失效 玩家技能",
						["pos"] = {
							["x"] = 1483.8370326473528,
							["y"] = -15.664134174431169
						},
						["propsData"] = {
							["PlayerId"] = 0,
							["bActiveEnable"] = true,
							["ActiveType"] = "Lock",
							["SkillNameList"] = {
								"SecondJump",
								"BulletJump",
								"Avoid",
								"Slide"
							}
						}
					},
					["17706206471788456316"] = {
						["key"] = "17706206471788456316",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成空气墙",
						["pos"] = {
							["x"] = 3738.299752977629,
							["y"] = 1877.5537430337126
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								162310195
							}
						}
					},
					["17707064911483866420"] = {
						["key"] = "17707064911483866420",
						["type"] = "GoToNode",
						["name"] = "中途点",
						["pos"] = {
							["x"] = 1878.5447224847662,
							["y"] = 1380.7817157196832
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 242310298,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020406hezi_mid_242310298"
						}
					},
					["17707329883423858789"] = {
						["key"] = "17707329883423858789",
						["type"] = "CameraLookAtNode",
						["name"] = "CameraLookAt",
						["pos"] = {
							["x"] = 1451.0542308220818,
							["y"] = 682.8633589488345
						},
						["propsData"] = {
							["TargetType"] = "Point",
							["PointName"] = "TPintu1",
							["ActorId"] = 0,
							["Duration"] = 3,
							["EasingFunc"] = 4,
							["bDisableUserInput"] = true
						}
					},
					["17707330206023859183"] = {
						["key"] = "17707330206023859183",
						["type"] = "CameraLookAtNode",
						["name"] = "CameraLookAt",
						["pos"] = {
							["x"] = 1720.0058617628254,
							["y"] = 1069.9743362331992
						},
						["propsData"] = {
							["TargetType"] = "Point",
							["PointName"] = "TPintu2",
							["ActorId"] = 0,
							["Duration"] = 3,
							["EasingFunc"] = 4,
							["bDisableUserInput"] = true
						}
					},
					["17707330417213859400"] = {
						["key"] = "17707330417213859400",
						["type"] = "CameraLookAtNode",
						["name"] = "CameraLookAt",
						["pos"] = {
							["x"] = 1532.141543921746,
							["y"] = 1683.5440331612917
						},
						["propsData"] = {
							["TargetType"] = "Point",
							["PointName"] = "TPintu3",
							["ActorId"] = 0,
							["Duration"] = 3,
							["EasingFunc"] = 4,
							["bDisableUserInput"] = true
						}
					},
					["17731311988922538324"] = {
						["key"] = "17731311988922538324",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 3959.3424594832563,
							["y"] = 2259.204448223593
						},
						["propsData"] = {
							["NewDescription"] = "Description_120204_6_5",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17731312250372538537"] = {
						["key"] = "17731312250372538537",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 4516.342459483256,
							["y"] = 2265.204448223593
						},
						["propsData"] = {
							["NewDescription"] = "Description_120204_6_6",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17734993551279285571"] = {
						["key"] = "17734993551279285571",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 1482.4645140664961,
							["y"] = -173.42295396419442
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "YYG_Restart5",
							["UnitId"] = -1
						}
					},
					["177357063882720261477"] = {
						["key"] = "177357063882720261477",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1893.1796586428673,
							["y"] = 1223.380217820035
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12049108,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17735830349535924189"] = {
						["key"] = "17735830349535924189",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "变量=0",
						["pos"] = {
							["x"] = 711.9916086834555,
							["y"] = 291.5087311677552
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "East02YYG2Phase",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "2"
								}
							}
						}
					},
					["17735830452895924447"] = {
						["key"] = "17735830452895924447",
						["type"] = "WaitOfTimeNode",
						["name"] = "集线器",
						["pos"] = {
							["x"] = 1030.7493726586108,
							["y"] = 246.41556346589164
						},
						["propsData"] = {
							["WaitTime"] = 0.1
						}
					},
					["17735831552276771241"] = {
						["key"] = "17735831552276771241",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 2724.534446334057,
							["y"] = 1902.8233660609874
						},
						["propsData"] = {
							["VarName"] = "East02YYG2Phase",
							["VarValue"] = 3
						}
					}
				},
				["commentData"] = {
					["176943733514817104550"] = {
						["key"] = "176943733514817104550",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 781.3008370326864,
							["y"] = 539.167570990148
						},
						["size"] = {
							["width"] = 1016.8317061823261,
							["height"] = 494.6529141700334
						}
					},
					["176943819109417106922"] = {
						["key"] = "176943819109417106922",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 782.5183219872305,
							["y"] = 1079.3232432176835
						},
						["size"] = {
							["width"] = 993.913043478261,
							["height"] = 466.9565217391306
						}
					},
					["176943839048617107655"] = {
						["key"] = "176943839048617107655",
						["name"] = "Input Commment...",
						["position"] = {
							["x"] = 814.1295751841616,
							["y"] = 1584.182578256047
						},
						["size"] = {
							["width"] = 988.2352941176468,
							["height"] = 457.05882352941177
						}
					}
				}
			}
		},
		["17695041202233736736"] = {
			["isStoryNode"] = true,
			["key"] = "17695041202233736736",
			["type"] = "StoryNode",
			["name"] = "巨阙后半段",
			["pos"] = {
				["x"] = 1246.686744906399,
				["y"] = 282.871989735233
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
						["startQuest"] = "17695135948905229158",
						["startPort"] = "Out",
						["endQuest"] = "17695135948905229160",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17695135948905229160",
						["startPort"] = "Out",
						["endQuest"] = "17695135948905229159",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17695135948905229159",
						["startPort"] = "Out",
						["endQuest"] = "17695135948905229161",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17695136037865229476",
						["startPort"] = "Out",
						["endQuest"] = "17695041202233736743",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17695041202233736737",
						["startPort"] = "QuestStart",
						["endQuest"] = "17695136037865229476",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17695140416225976622",
						["startPort"] = "false",
						["endQuest"] = "17695140924695977918",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17695140924695977918",
						["startPort"] = "true",
						["endQuest"] = "17695141037095978164",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17695141179725978527",
						["startPort"] = "Out",
						["endQuest"] = "17695041202233736740",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17695141037095978164",
						["startPort"] = "Out",
						["endQuest"] = "17695041202233736740",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17695141335265979023",
						["startPort"] = "Out",
						["endQuest"] = "17695041202233736740",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17695135948905229160",
						["startPort"] = "Out",
						["endQuest"] = "176951839016337969616",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17695041202233736737",
						["startPort"] = "QuestStart",
						["endQuest"] = "17695140416225976622",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17695135948905229161",
						["startPort"] = "Out",
						["endQuest"] = "17695141179725978527",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17695041202233736737",
						["startPort"] = "QuestStart",
						["endQuest"] = "17706237883571544322",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17695041202233736737",
						["startPort"] = "QuestStart",
						["endQuest"] = "17731292171621693559",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17695041202233736737",
						["startPort"] = "QuestStart",
						["endQuest"] = "17734992221279284907",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17695140924695977918",
						["startPort"] = "false",
						["endQuest"] = "17735829499745077862",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17735829499745077862",
						["startPort"] = "true",
						["endQuest"] = "17695141335265979023",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17735829499745077862",
						["startPort"] = "false",
						["endQuest"] = "17735829634155078338",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17735829634155078338",
						["startPort"] = "Out",
						["endQuest"] = "17695041202233736740",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17695140416225976622",
						["startPort"] = "true",
						["endQuest"] = "17736583868315077933",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17736583868315077933",
						["startPort"] = "Out",
						["endQuest"] = "17695135948905229158",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17695041202233736737"] = {
						["key"] = "17695041202233736737",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 771.4285714285714,
							["y"] = 308.57142857142856
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17695041202233736740"] = {
						["key"] = "17695041202233736740",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2143.2864531319774,
							["y"] = 1147.0842461885945
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17695041202233736743"] = {
						["key"] = "17695041202233736743",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1651.4285714285713,
							["y"] = 1667.1428571428576
						},
						["propsData"] = {}
					},
					["17695135948905229158"] = {
						["key"] = "17695135948905229158",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1453.713231035964,
							["y"] = 336.3500786276368
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 242310251,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020406hezi5_242310251"
						}
					},
					["17695135948905229159"] = {
						["key"] = "17695135948905229159",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 2024.0665681122564,
							["y"] = 327.69409500626637
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 242310253,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020406hezi7_242310253"
						}
					},
					["17695135948905229160"] = {
						["key"] = "17695135948905229160",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1724.7541205207417,
							["y"] = 329.76608152570907
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 242310252,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020406hezi6_242310252"
						}
					},
					["17695135948905229161"] = {
						["key"] = "17695135948905229161",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2402.7822218846118,
							["y"] = 336.34922791377505
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/AssetDesign/Story/Sequence/East02/RegionUI/Show_YYG_RegionUI",
							["BlendInTime"] = 2,
							["BlendOutTime"] = 2,
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
					["17695136037865229476"] = {
						["key"] = "17695136037865229476",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1266.9173913805494,
							["y"] = 1660.1052473841953
						},
						["propsData"] = {}
					},
					["17695140416225976622"] = {
						["key"] = "17695140416225976622",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "变量=0",
						["pos"] = {
							["x"] = 1233.2039047215712,
							["y"] = 905.8253444120608
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "East02YYG2Phase",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "0"
								}
							}
						}
					},
					["17695140924695977918"] = {
						["key"] = "17695140924695977918",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "变量=0",
						["pos"] = {
							["x"] = 1245.1457061699416,
							["y"] = 1091.8257408760635
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "East02YYG2Phase",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "1"
								}
							}
						}
					},
					["17695141037095978164"] = {
						["key"] = "17695141037095978164",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1694.1955341929324,
							["y"] = 1018.5832305482272
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "Maze2SL1",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = false,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17695141179725978527"] = {
						["key"] = "17695141179725978527",
						["type"] = "SetVarNode",
						["name"] = "设置变量值",
						["pos"] = {
							["x"] = 2764.134331043036,
							["y"] = 347.15828466078113
						},
						["propsData"] = {
							["VarName"] = "East02YYG2Phase",
							["VarValue"] = 1
						}
					},
					["17695141335265979023"] = {
						["key"] = "17695141335265979023",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1706.167504573525,
							["y"] = 1166.7312554436446
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "TowerStart",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = false,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["176951839016337969616"] = {
						["key"] = "176951839016337969616",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2019.2993738376733,
							["y"] = 149.39067407688108
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12048724,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17706237883571544322"] = {
						["key"] = "17706237883571544322",
						["type"] = "ChangeRoleNode",
						["name"] = "切换角色",
						["pos"] = {
							["x"] = 1092.0010389357876,
							["y"] = 251.62273296392937
						},
						["propsData"] = {
							["QuestRoleId"] = 24010102,
							["IsPlayFX"] = false
						}
					},
					["17731292171621693559"] = {
						["key"] = "17731292171621693559",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1116.4889162561572,
							["y"] = 95.51573988230666
						},
						["propsData"] = {
							["NewDescription"] = "Description_120204_6_4",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17734992221279284907"] = {
						["key"] = "17734992221279284907",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 1134.511843129874,
							["y"] = -76.72813631381409
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "YYG_Restart3",
							["UnitId"] = -1
						}
					},
					["17735829499745077862"] = {
						["key"] = "17735829499745077862",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "变量=0",
						["pos"] = {
							["x"] = 1247.020869211484,
							["y"] = 1288.0114441858416
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "East02YYG2Phase",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "2"
								}
							}
						}
					},
					["17735829634155078338"] = {
						["key"] = "17735829634155078338",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1722.1374478269381,
							["y"] = 1318.536580043412
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "TBOSS",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = false,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17736583868315077933"] = {
						["key"] = "17736583868315077933",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1215.3036577858695,
							["y"] = 383.0938996166197
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "Maze2Start",
							["FadeIn"] = false,
							["FadeOut"] = true,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					}
				},
				["commentData"] = {
					["17695136096655229716"] = {
						["key"] = "17695136096655229716",
						["name"] = "区域介绍",
						["position"] = {
							["x"] = 2321.268040731199,
							["y"] = 238.04175532070278
						},
						["size"] = {
							["width"] = 356.6666666666666,
							["height"] = 275.5555555555556
						}
					},
					["17695141604525979949"] = {
						["key"] = "17695141604525979949",
						["name"] = "阶段判断",
						["position"] = {
							["x"] = 1181.3474268882048,
							["y"] = 694.4135293117131
						},
						["size"] = {
							["width"] = 1360.7130653688994,
							["height"] = 845.50624642264
						}
					}
				}
			}
		},
		["17735828291484229783"] = {
			["isStoryNode"] = true,
			["key"] = "17735828291484229783",
			["type"] = "StoryNode",
			["name"] = "塔内",
			["pos"] = {
				["x"] = 2454.4424423906835,
				["y"] = 303.68432790862016
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
						["startQuest"] = "17735828291524229813",
						["startPort"] = "Out",
						["endQuest"] = "17735828291564229821",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17735828291564229823",
						["startPort"] = "Out",
						["endQuest"] = "17735828291524229812",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17735828291574229829",
						["startPort"] = "Out",
						["endQuest"] = "17735828291524229813",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17735828291524229814",
						["startPort"] = "Out",
						["endQuest"] = "17735828291574229830",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17735828291574229830",
						["startPort"] = "Out",
						["endQuest"] = "17735828291564229823",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17735828291574229829",
						["startPort"] = "Out",
						["endQuest"] = "17735828291584229833",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17735828291524229813",
						["startPort"] = "Out",
						["endQuest"] = "17735828291524229814",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17735828291524229813",
						["startPort"] = "Out",
						["endQuest"] = "17735828291584229838",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17735828291574229830",
						["startPort"] = "Out",
						["endQuest"] = "17735828291584229839",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17735829171564232939",
						["startPort"] = "Out",
						["endQuest"] = "17735828291494229790",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17735828291494229788",
						["startPort"] = "QuestStart",
						["endQuest"] = "17735829171564232939",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17735828291494229788",
						["startPort"] = "QuestStart",
						["endQuest"] = "17735828291574229829",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17735828291494229788",
						["startPort"] = "QuestStart",
						["endQuest"] = "17735831876947615855",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17735828291494229788"] = {
						["key"] = "17735828291494229788",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 830.9090909090909,
							["y"] = 438.52272727272725
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17735828291494229789"] = {
						["key"] = "17735828291494229789",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2603.979750509361,
							["y"] = 1227.1983719678633
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17735828291494229790"] = {
						["key"] = "17735828291494229790",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1465.8726708074528,
							["y"] = -110.58385093167738
						},
						["propsData"] = {}
					},
					["17735828291524229812"] = {
						["key"] = "17735828291524229812",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2583.131097200534,
							["y"] = 421.4185915576609
						},
						["propsData"] = {}
					},
					["17735828291524229813"] = {
						["key"] = "17735828291524229813",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成黑白狴犴",
						["pos"] = {
							["x"] = 1461.5388736346267,
							["y"] = 465.3293071578496
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								162310178,
								162310179
							}
						}
					},
					["17735828291524229814"] = {
						["key"] = "17735828291524229814",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1715.2739543433913,
							["y"] = 457.2556045446736
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 2,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								162310178,
								162310179
							}
						}
					},
					["17735828291564229821"] = {
						["key"] = "17735828291564229821",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 1742.6210675903249,
							["y"] = 286.1997804552577
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12049114,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17735828291564229823"] = {
						["key"] = "17735828291564229823",
						["type"] = "TalkNode",
						["name"] = "对话节点",
						["pos"] = {
							["x"] = 2252.3148359883508,
							["y"] = 448.8737450779024
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["bUseFlowAssetActors"] = true,
							["FirstDialogueId"] = 0,
							["FlowAssetPath"] = "DialogueAsset'/Game/Dialogue/MainStory/1202/12044801.12044801'",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "",
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
					["17735828291574229829"] = {
						["key"] = "17735828291574229829",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 1220.383067039069,
							["y"] = 440.2332549444068
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 242310269,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_12020406hezi22_242310269"
						}
					},
					["17735828291574229830"] = {
						["key"] = "17735828291574229830",
						["type"] = "SendMessageNode",
						["name"] = "打完boss",
						["pos"] = {
							["x"] = 1963.4316489169619,
							["y"] = 480.01860847976036
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "YYG_BOSS",
							["UnitId"] = -1
						}
					},
					["17735828291584229833"] = {
						["key"] = "17735828291584229833",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成空气墙",
						["pos"] = {
							["x"] = 1476.6330863109624,
							["y"] = 299.2204097003796
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								162310195
							}
						}
					},
					["17735828291584229838"] = {
						["key"] = "17735828291584229838",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 1697.6757928165898,
							["y"] = 680.8711148902598
						},
						["propsData"] = {
							["NewDescription"] = "Description_120204_6_5",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17735828291584229839"] = {
						["key"] = "17735828291584229839",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标节点",
						["pos"] = {
							["x"] = 2254.67579281659,
							["y"] = 686.8711148902598
						},
						["propsData"] = {
							["NewDescription"] = "Description_120204_6_6",
							["NewDetail"] = "",
							["SubTaskTargetIndex"] = 0
						}
					},
					["17735829171564232939"] = {
						["key"] = "17735829171564232939",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1165.1189746297177,
							["y"] = -107.17325085306649
						},
						["propsData"] = {}
					},
					["17735831876947615855"] = {
						["key"] = "17735831876947615855",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 1203.888347419399,
							["y"] = 243.59420632743416
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "YYG_ReStart6",
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