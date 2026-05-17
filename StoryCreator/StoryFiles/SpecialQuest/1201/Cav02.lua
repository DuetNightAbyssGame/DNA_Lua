return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17396068168221",
			["startPort"] = "StoryStart",
			["endStory"] = "173960682489147",
			["endPort"] = "In"
		},
		{
			["startStory"] = "173960682489147",
			["startPort"] = "Success",
			["endStory"] = "17396068168225",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["17396068168221"] = {
			["isStoryNode"] = true,
			["key"] = "17396068168221",
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
		["17396068168225"] = {
			["isStoryNode"] = true,
			["key"] = "17396068168225",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1411.6666666666665,
				["y"] = 306.89655172413796
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["173960682489147"] = {
			["isStoryNode"] = true,
			["key"] = "173960682489147",
			["type"] = "StoryNode",
			["name"] = "第一波狼灵",
			["pos"] = {
				["x"] = 1100.4137931034484,
				["y"] = 288.62068965517244
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120102_14",
				["QuestDeatil"] = "Content_120102_14",
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
						["startQuest"] = "173960682489152",
						["startPort"] = "QuestStart",
						["endQuest"] = "173960682489255",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173960682489255",
						["startPort"] = "Out",
						["endQuest"] = "17508545760191765",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1750854042718845",
						["startPort"] = "Out",
						["endQuest"] = "173960682489258",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17623552240231373486",
						["startPort"] = "Out",
						["endQuest"] = "17623552240231373487",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17508545760191765",
						["startPort"] = "Out",
						["endQuest"] = "17623552240231373489",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17623552240231373487",
						["startPort"] = "Out",
						["endQuest"] = "17626084750601320645",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173960682489152",
						["startPort"] = "QuestStart",
						["endQuest"] = "173968224552714631398",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173960682489152",
						["startPort"] = "QuestStart",
						["endQuest"] = "1750854042718845",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17623552240231373489",
						["startPort"] = "Out",
						["endQuest"] = "1764002604153790",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1764002604153790",
						["startPort"] = "Out",
						["endQuest"] = "173960682489254",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17626084750601320645",
						["startPort"] = "Out",
						["endQuest"] = "1764002599879632",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1764002599879632",
						["startPort"] = "Out",
						["endQuest"] = "17623552240231373488",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173960682489258",
						["startPort"] = "Out",
						["endQuest"] = "17649229472131041",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17649229472131041",
						["startPort"] = "Out",
						["endQuest"] = "17623552240231373486",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "173960682489152",
						["startPort"] = "QuestStart",
						["endQuest"] = "17654451375861481",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["173960682489152"] = {
						["key"] = "173960682489152",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 3523.231005750356,
							["y"] = 826.1651978912043
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["173960682489253"] = {
						["key"] = "173960682489253",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 6413.661703364875,
							["y"] = 519.0536233366864
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["173960682489254"] = {
						["key"] = "173960682489254",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 4730.07928096582,
							["y"] = 1242.127557194727
						},
						["propsData"] = {}
					},
					["173960682489255"] = {
						["key"] = "173960682489255",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = 3913.9858251419196,
							["y"] = 944.6317388627892
						},
						["propsData"] = {}
					},
					["173960682489257"] = {
						["key"] = "173960682489257",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 4642.718677033806,
							["y"] = 331.09201985399585
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2040023
							}
						}
					},
					["173960682489258"] = {
						["key"] = "173960682489258",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 4583.90692851265,
							["y"] = 809.6678608528487
						},
						["propsData"] = {
							["KillMonsterType"] = "Nums",
							["MonsterNeedNums"] = 30,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "SpecialQuestPoint_SQ02Start"
						}
					},
					["173960682489260"] = {
						["key"] = "173960682489260",
						["type"] = "GoToRegionNode",
						["name"] = "进入东国区域检测",
						["pos"] = {
							["x"] = 3238.1948923881637,
							["y"] = 229.2338095719877
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 104103,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "QuestPoint_CavSpecialQuest"
						}
					},
					["173968224552714631398"] = {
						["key"] = "173968224552714631398",
						["type"] = "TalkNode",
						["name"] = "开车 -和煜明交谈",
						["pos"] = {
							["x"] = 4218.595473830583,
							["y"] = 586.4775108792135
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 12011901,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1750854042718845"] = {
						["key"] = "1750854042718845",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 4337.923739495797,
							["y"] = 811.0109384423628
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "East01CavSQCreateMonster",
							["UnitId"] = -1
						}
					},
					["17508545760191765"] = {
						["key"] = "17508545760191765",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 4309.457176028305,
							["y"] = 1055.29567970729
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "East01CavSQDestoryMonster",
							["UnitId"] = -1
						}
					},
					["175101606958112567064"] = {
						["key"] = "175101606958112567064",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 2996.919117647057,
							["y"] = 389.766253869969
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "SpecialQuestPoint_SQ02Start",
							["FadeIn"] = false,
							["FadeOut"] = true,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17512753791521417"] = {
						["key"] = "17512753791521417",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 3245.787409700722,
							["y"] = 48.9280185758513
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2040044,
							["GuideType"] = "M",
							["GuidePointName"] = "QuestPoint_CavSpecialQuest"
						}
					},
					["17623552240231373486"] = {
						["key"] = "17623552240231373486",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 5089.254867719362,
							["y"] = 791.6880049624795
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2040024,
								2040023
							}
						}
					},
					["17623552240231373487"] = {
						["key"] = "17623552240231373487",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物",
						["pos"] = {
							["x"] = 5411.278621322436,
							["y"] = 785.637333151105
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 2,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								2040024,
								2040023
							}
						}
					},
					["17623552240231373488"] = {
						["key"] = "17623552240231373488",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = 6267.7209673064,
							["y"] = 776.6454388784117
						},
						["propsData"] = {}
					},
					["17623552240231373489"] = {
						["key"] = "17623552240231373489",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = 4308.501015418125,
							["y"] = 1221.926392339091
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								2040024,
								2040025,
								2040023
							}
						}
					},
					["17626084750601320645"] = {
						["key"] = "17626084750601320645",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = 5670.481990622336,
							["y"] = 788.2260566698075
						},
						["propsData"] = {
							["WaitTime"] = 3
						}
					},
					["1764002599879632"] = {
						["key"] = "1764002599879632",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 5980,
							["y"] = 796.5
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					},
					["1764002604153790"] = {
						["key"] = "1764002604153790",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 4302,
							["y"] = 1374.5
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					},
					["17649229472131041"] = {
						["key"] = "17649229472131041",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 4834.70588235294,
							["y"] = 819.0588235294119
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "East01CavSQDestoryMonster",
							["UnitId"] = -1
						}
					},
					["17654451375861481"] = {
						["key"] = "17654451375861481",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 3849.686182367684,
							["y"] = 555.2027679492851
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/1_1/0107_story_zhuyinzhizai_full",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {
								104103
							},
							["bStoreToServer"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["1739606840055474"] = {
			["isStoryNode"] = true,
			["key"] = "1739606840055474",
			["type"] = "StoryNode",
			["name"] = "第二波狼灵",
			["pos"] = {
				["x"] = 1366.1541047657988,
				["y"] = 27.060184193617488
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "Description_120102_14",
				["QuestDeatil"] = "Content_120102_14",
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
				["lineData"] = {},
				["nodeData"] = {
					["1739606840056479"] = {
						["key"] = "1739606840056479",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 3184.2054465142705,
							["y"] = 493.6654228124818
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1739606840056480"] = {
						["key"] = "1739606840056480",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 4605.443902238675,
							["y"] = 435.3126933673273
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1739606840056481"] = {
						["key"] = "1739606840056481",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 4827.718432463141,
							["y"] = 815.230241341945
						},
						["propsData"] = {}
					},
					["173960984147919983850"] = {
						["key"] = "173960984147919983850",
						["type"] = "GoToRegionNode",
						["name"] = "进入东国区域检测",
						["pos"] = {
							["x"] = 3495.530075187969,
							["y"] = 64.67395762132605
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 104103,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "QuestPoint_CavSpecialQuest"
						}
					},
					["1751275662722660980"] = {
						["key"] = "1751275662722660980",
						["type"] = "GoToNode",
						["name"] = "前往",
						["pos"] = {
							["x"] = 3060.8421052631575,
							["y"] = 148.00000000000006
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 2040044,
							["GuideType"] = "M",
							["GuidePointName"] = "QuestPoint_CavSpecialQuest"
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}