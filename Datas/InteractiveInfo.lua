-- Source Excel file path: ..\datas\CommonUIConfirm.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("InteractiveInfo", {
	AbyssMain = {
		BPPath = "/Game/BluePrints/Story/Interactive/InteractiveComponent/InteractChild/BP_AbyssMainInteract",
		Id = "AbyssMain",
	},
	AbyssShop = {
		BPPath = "/Game/BluePrints/Story/Interactive/InteractiveComponent/InteractChild/BP_AbyssShopInteract",
		Id = "AbyssShop",
	},
	Biography = {
		BPPath = "/Game/BluePrints/Story/Interactive/InteractiveComponent/InteractChild/BP_BiographyInteract.BP_BiographyInteract",
		Id = "Biography",
	},
	ExploreBadgeShop = {
		BPPath = "/Game/BluePrints/Story/Interactive/InteractiveComponent/InteractChild/BP_ExploreBadgeShopInteract",
		Id = "ExploreBadgeShop",
	},
	FishingShop = {
		BPPath = "/Game/BluePrints/Story/Interactive/InteractiveComponent/InteractChild/BP_FishingShopInteract",
		Id = "FishingShop",
	},
	Forge = {
		BPPath = "/Game/BluePrints/Story/Interactive/InteractiveComponent/InteractChild/BP_ForgeInteract.BP_ForgeInteract",
		Id = "Forge",
	},
	Gacha = {
		BPPath = "/Game/BluePrints/Story/Interactive/InteractiveComponent/InteractChild/BP_GachaInteract.BP_GachaInteract",
		Id = "Gacha",
	},
	HuaxuExploreShop = {
		BPPath = "/Game/BluePrints/Story/Interactive/InteractiveComponent/InteractChild/BP_HuaxuExploreShopInteract.BP_HuaxuExploreShopInteract",
		Id = "HuaxuExploreShop",
	},
	ImpressionShop = {
		BPPath = "/Game/BluePrints/Story/Interactive/InteractiveComponent/InteractChild/BP_ImpressionShopInteract.BP_ImpressionShopInteract",
		Id = "ImpressionShop",
	},
	Map = {
		BPPath = "/Game/BluePrints/Story/Interactive/InteractiveComponent/InteractChild/BP_MapInteract.BP_MapInteract",
		Id = "Map",
	},
	NpcTalk = {
		BPPath = "/Game/BluePrints/Story/Interactive/InteractiveComponent/BP_NpcTalkInteractiveComponent.BP_NpcTalkInteractiveComponent",
		Id = "NpcTalk",
	},
	PetNpcGame = {
		BPPath = "/Game/BluePrints/Story/Interactive/InteractiveComponent/BP_PetNPCInteractiveComponent.BP_PetNPCInteractiveComponent",
		Id = "PetNpcGame",
	},
	Play = {
		BPPath = "/Game/BluePrints/Story/Interactive/InteractiveComponent/InteractChild/BP_PlayInteract",
		Id = "Play",
	},
	RLBShop = {
		BPPath = "/Game/BluePrints/Story/Interactive/InteractiveComponent/InteractChild/BP_RLBShopInteract.BP_RLBShopInteract",
		Id = "RLBShop",
	},
	RLShopNpc = {
		BPPath = "/Game/BluePrints/Story/Interactive/InteractiveComponent/InteractChild/BP_RLShopInteractTalk.BP_RLShopInteractTalk",
		Id = "RLShopNpc",
	},
	RLTShop = {
		BPPath = "/Game/BluePrints/Story/Interactive/InteractiveComponent/InteractChild/BP_RLTShopInteract.BP_RLTShopInteract",
		Id = "RLTShop",
	},
	Shop = {
		BPPath = "/Game/BluePrints/Story/Interactive/InteractiveComponent/InteractChild/BP_ShopInteract.BP_ShopInteract",
		Id = "Shop",
	},
	TheaDonate = {
		BPPath = "/Game/BluePrints/Story/Interactive/InteractiveComponent/InteractChild/BP_TheaDonateInteract.BP_TheaDonateInteract",
		Id = "TheaDonate",
	},
	TheaOnline = {
		BPPath = "/Game/BluePrints/Story/Interactive/InteractiveComponent/InteractChild/BP_TheaOnlineInteract.BP_TheaOnlineInteract",
		Id = "TheaOnline",
	},
	ZhiLiuEntrust = {
		BPPath = "/Game/BluePrints/Story/Interactive/InteractiveComponent/InteractChild/BP_ZhiLiuEntrustInteract",
		Id = "ZhiLiuEntrust",
	},
	ZhiliuEventTask = {
		BPPath = "/Game/BluePrints/Story/Interactive/InteractiveComponent/InteractChild/BP_ZhiliuEventTaskInteract",
		Id = "ZhiliuEventTask",
	},
})