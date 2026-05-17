return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "1748329868066191",
			["startPort"] = "StoryStart",
			["endStory"] = "1748329908050403",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1748329908050403",
			["startPort"] = "Success",
			["endStory"] = "1748329868066194",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1748329868066191"] = {
			["isStoryNode"] = true,
			["key"] = "1748329868066191",
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
		["1748329868066194"] = {
			["isStoryNode"] = true,
			["key"] = "1748329868066194",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1564,
				["y"] = 296
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["1748329908050403"] = {
			["isStoryNode"] = true,
			["key"] = "1748329908050403",
			["type"] = "StoryNode",
			["name"] = "与士兵战斗",
			["pos"] = {
				["x"] = 1207.2258064119178,
				["y"] = 271.6129032059589
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_200230_5",
				["QuestDeatil"] = "Content_200230_5",
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
				["SubRegionId"] = 0,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "1748329908050404",
						["startPort"] = "QuestStart",
						["endQuest"] = "1748330576549591818",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1748329908050404",
						["startPort"] = "QuestStart",
						["endQuest"] = "1748330644445592187",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1748330644445592187",
						["startPort"] = "Out",
						["endQuest"] = "1748329908051418",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "1748330576549591818",
						["startPort"] = "Out",
						["endQuest"] = "1748330617414591977",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1748330617414591977",
						["startPort"] = "Out",
						["endQuest"] = "1748330708806592644",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1748329908050404"] = {
						["key"] = "1748329908050404",
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
					["1748329908051411"] = {
						["key"] = "1748329908051411",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2378,
							["y"] = 322
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1748329908051418"] = {
						["key"] = "1748329908051418",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2430,
							["y"] = 672
						},
						["propsData"] = {}
					},
					["1748330576549591818"] = {
						["key"] = "1748330576549591818",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成怪物",
						["pos"] = {
							["x"] = 1177.696969393382,
							["y"] = 128.18182098416693
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1191516
							}
						}
					},
					["1748330617414591977"] = {
						["key"] = "1748330617414591977",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 1493.405405293946,
							["y"] = 288
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 1,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								1191516
							}
						}
					},
					["1748330644445592187"] = {
						["key"] = "1748330644445592187",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 1332,
							["y"] = 542
						},
						["propsData"] = {}
					},
					["1748330708806592644"] = {
						["key"] = "1748330708806592644",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 2044.7878768028818,
							["y"] = 304.54545447539584
						},
						["propsData"] = {}
					},
					["17483439527072955785"] = {
						["key"] = "17483439527072955785",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁录音机",
						["pos"] = {
							["x"] = 1768.9698171750192,
							["y"] = 161.10060743370778
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1191860
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