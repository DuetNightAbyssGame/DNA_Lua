return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17678537949081014512",
			["startPort"] = "StoryStart",
			["endStory"] = "17678537949081014514",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17678537949081014514",
			["startPort"] = "Success",
			["endStory"] = "17678537949081014513",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17678537949081014512"] = {
			["isStoryNode"] = true,
			["key"] = "17678537949081014512",
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
		["17678537949081014513"] = {
			["isStoryNode"] = true,
			["key"] = "17678537949081014513",
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
		["17678537949081014514"] = {
			["isStoryNode"] = true,
			["key"] = "17678537949081014514",
			["type"] = "StoryNode",
			["name"] = "任务节点",
			["pos"] = {
				["x"] = 1426.4444444444443,
				["y"] = 350.8888888888889
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
						["startQuest"] = "17678537949081014515",
						["startPort"] = "QuestStart",
						["endQuest"] = "1767962210862728205",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17678537949081014515",
						["startPort"] = "QuestStart",
						["endQuest"] = "1770192777622845",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770192777622845",
						["startPort"] = "Out",
						["endQuest"] = "1770192753871689",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770192753871689",
						["startPort"] = "Out",
						["endQuest"] = "1772442106668794921",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1772442106668794921",
						["startPort"] = "Out",
						["endQuest"] = "17725191337011137",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1770192777622845",
						["startPort"] = "Out",
						["endQuest"] = "177313190777819968417",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177313205953721657238",
						["startPort"] = "Out",
						["endQuest"] = "1767962203750727967",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "177313207349521657723",
						["startPort"] = "Out",
						["endQuest"] = "17678537949081014517",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17725191337011137",
						["startPort"] = "Out",
						["endQuest"] = "177313205953721657238",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1767962210862728205",
						["startPort"] = "Out",
						["endQuest"] = "177313207349521657723",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17678537949081014515",
						["startPort"] = "QuestStart",
						["endQuest"] = "17733008049981701563",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17678537949081014515"] = {
						["key"] = "17678537949081014515",
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
					["17678537949081014516"] = {
						["key"] = "17678537949081014516",
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
					["17678537949081014517"] = {
						["key"] = "17678537949081014517",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2006.4,
							["y"] = 679.6615384615384
						},
						["propsData"] = {}
					},
					["1767962203750727967"] = {
						["key"] = "1767962203750727967",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2733.0111505815935,
							["y"] = 725.9734572013662
						},
						["propsData"] = {}
					},
					["1767962210862728205"] = {
						["key"] = "1767962210862728205",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1675.2758483837913,
							["y"] = 592.5320431047103
						},
						["propsData"] = {}
					},
					["1770192753871689"] = {
						["key"] = "1770192753871689",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 1527.2212854136458,
							["y"] = 346.9489007949005
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								242360082
							}
						}
					},
					["1770192777622845"] = {
						["key"] = "1770192777622845",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1267.023916992593,
							["y"] = 305.3893912255226
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "12020402fangshou_Start",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17701927963481127"] = {
						["key"] = "17701927963481127",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 2022.5289479523453,
							["y"] = 185.00520884443608
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 1,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								162360055
							}
						}
					},
					["1772442106668794921"] = {
						["key"] = "1772442106668794921",
						["type"] = "BossBattleFinishNode",
						["name"] = "完成BOSS战阶段",
						["pos"] = {
							["x"] = 1816.5745241067248,
							["y"] = 358.07293412117474
						},
						["propsData"] = {
							["SendMessage"] = "",
							["FinishCondition"] = "Yuming_HalfHealth"
						}
					},
					["17725191337011137"] = {
						["key"] = "17725191337011137",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 2086.3422949408678,
							["y"] = 368.34903400351146
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								242360082
							}
						}
					},
					["177313190777819968417"] = {
						["key"] = "177313190777819968417",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成空气墙",
						["pos"] = {
							["x"] = 1584.258064516129,
							["y"] = 130.1290322580645
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								162360054,
								162360015,
								162360016,
								162360017,
								162360018,
								162360019,
								162360020,
								162360021,
								162360022
							}
						}
					},
					["177313202957421656802"] = {
						["key"] = "177313202957421656802",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成钩锁点",
						["pos"] = {
							["x"] = 1590.300321324702,
							["y"] = -23.866302880784048
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								162360008,
								162360009,
								162360011,
								162360012,
								162360013
							}
						}
					},
					["177313205953721657238"] = {
						["key"] = "177313205953721657238",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成空气墙",
						["pos"] = {
							["x"] = 2387.3561390006507,
							["y"] = 462.65117054068253
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								162360054,
								162360015,
								162360016,
								162360017,
								162360018,
								162360019,
								162360020,
								162360021,
								162360022
							}
						}
					},
					["177313205953721657239"] = {
						["key"] = "177313205953721657239",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成钩锁点",
						["pos"] = {
							["x"] = 2515.706088116916,
							["y"] = 270.5789123249109
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								162360008,
								162360009,
								162360011,
								162360012,
								162360013
							}
						}
					},
					["177313207349521657723"] = {
						["key"] = "177313207349521657723",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成空气墙",
						["pos"] = {
							["x"] = 1671.7506561214607,
							["y"] = 972.8905755322427
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								162360054,
								162360015,
								162360016,
								162360017,
								162360018,
								162360019,
								162360020,
								162360021,
								162360022
							}
						}
					},
					["177313207349521657724"] = {
						["key"] = "177313207349521657724",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成钩锁点",
						["pos"] = {
							["x"] = 1364.0566491937702,
							["y"] = 927.6864491846029
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								162360008,
								162360009,
								162360011,
								162360012,
								162360013
							}
						}
					},
					["17733008049981701563"] = {
						["key"] = "17733008049981701563",
						["type"] = "ChangeRoleNode",
						["name"] = "切换角色",
						["pos"] = {
							["x"] = 1271.2307692307693,
							["y"] = 128.00000000000003
						},
						["propsData"] = {
							["QuestRoleId"] = 24010102,
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