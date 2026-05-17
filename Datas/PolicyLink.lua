-- Source Excel file path: ..\datas\PolicyLink.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("PolicyLink", {
	ChildPrivacy = {
		Cache = "ChildPrivacy",
		ChinaCN = "https://www.yingxiong.com/p/per_child_pan.html?productId=17337&cid=56",
	},
	CloudGame = {
		Cache = "CloudGame",
		ChinaCN = "https://dna.yingxiong.com/cloud/download?source=game",
	},
	InviteCode = {
		AbroadCN = "https://duetnightabyss.dna-panstudio.com/atlasiacalling/?source=game",
		AbroadEN = "https://duetnightabyss.dna-panstudio.com/atlasiacalling/en?source=game",
		AbroadJP = "https://duetnightabyss.dna-panstudio.com/atlasiacalling/ja?source=game",
		AbroadKR = "https://duetnightabyss.dna-panstudio.com/atlasiacalling/ko?source=game",
		AbroadTC = "https://duetnightabyss.dna-panstudio.com/atlasiacalling/zh-tw?source=game",
		Cache = "InviteCode",
		ChinaCN = "https://dna.yingxiong.com/atlasiacalling?source=game",
	},
	PaymentPolicyJP = {
		AbroadCN = "https://duetnightabyss.dna-panstudio.com/ja/#/news/content?id=8567",
		AbroadEN = "https://duetnightabyss.dna-panstudio.com/ja/#/news/content?id=8567",
		AbroadJP = "https://duetnightabyss.dna-panstudio.com/ja/#/news/content?id=8567",
		AbroadKR = "https://duetnightabyss.dna-panstudio.com/ja/#/news/content?id=8567",
		AbroadTC = "https://duetnightabyss.dna-panstudio.com/ja/#/news/content?id=8567",
		Cache = "PaymentPolicyJP",
		ChinaCN = "https://duetnightabyss.dna-panstudio.com/ja/#/news/content?id=8567",
	},
	PaymentPolicyKR = {
		AbroadCN = "https://duetnightabyss.dna-panstudio.com/ko/#/news/content?id=8564",
		AbroadEN = "https://duetnightabyss.dna-panstudio.com/ko/#/news/content?id=8564",
		AbroadJP = "https://duetnightabyss.dna-panstudio.com/ko/#/news/content?id=8564",
		AbroadKR = "https://duetnightabyss.dna-panstudio.com/ko/#/news/content?id=8564",
		AbroadTC = "https://duetnightabyss.dna-panstudio.com/ko/#/news/content?id=8564",
		Cache = "PaymentPolicyKR",
		ChinaCN = "https://duetnightabyss.dna-panstudio.com/ko/#/news/content?id=8564",
	},
	PrivacyPolicy = {
		AbroadCN = "https://duetnightabyss.herogame.com/zh-tw/#/news/content?id=6259",
		AbroadEN = "http://duetnightabyss.herogame.com/en/#/news/content?id=6266",
		AbroadJP = "http://duetnightabyss.herogame.com/ja/#/news/content?id=6254",
		AbroadKR = "http://duetnightabyss.herogame.com/ko/#/news/content?id=6267",
		AbroadTC = "https://duetnightabyss.herogame.com/zh-tw/#/news/content?id=6259",
		Cache = "PrivacyPolicy",
		ChinaCN = "https://www.yingxiong.com/p/per_adu_pan.html?productId=17337&cid=56",
	},
	RelatedProduct = {
		Cache = "RelatedProduct",
		ChinaCN = "https://erchongluoxuan.tmall.com",
	},
	TermsOfService = {
		AbroadCN = "https://duetnightabyss.herogame.com/zh-tw/#/news/content?id=6260",
		AbroadEN = "http://duetnightabyss.herogame.com/en/#/news/content?id=6268",
		AbroadJP = "https://duetnightabyss.herogame.com/ja/#/news/content?id=6256",
		AbroadKR = "http://duetnightabyss.herogame.com/ko/#/news/content?id=6265",
		AbroadTC = "https://duetnightabyss.herogame.com/zh-tw/#/news/content?id=6260",
		Cache = "TermsOfService",
		ChinaCN = "https://www.yingxiong.com/p/shhero_yhxy.html",
	},
	ThirdPartySDK = {
		Cache = "ThirdPartySDK",
		ChinaCN = "https://www.yingxiong.com/p/all_sdk_pan.html?productId=17337&cid=56",
	},
	UserPolicy = {
		Cache = "UserPolicy",
		ChinaCN = "https://www.yingxiong.com/p/agreement_global_pan.html",
	},
})