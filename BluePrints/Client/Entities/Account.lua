local Class = _G.TypeClass
local AvatarEntity = require "BluePrints.Client.Wrapper.Entity".AvatarEntity
local Assemble = require "NetworkEngine.Common.Assemble"
local HeroUSDKUtils = require "Utils.HeroUSDKUtils"
local MiscUtils = require "Utils.MiscUtils"
local EMLuaConst = require "EMLuaConst"

local Account = Class("Account", AvatarEntity)
Account.__Component__ = {
	"BluePrints.Client.Entities.Components.EntityBase",
	"BluePrints.Client.Entities.Components.Login",
}

function Account:Init(eid)
	Account.Super.Init(self, eid)
end

function Account:OnBecomePlayer()
	Account.Super.OnBecomePlayer(self)
	self.logger.info("Account OnBecomePlayer")
	if HeroUSDKUtils.IsEnable() and not GWorld.NetworkMgr.IsQuickLogin then
		self:SdkLogin()
	else
		local account_name = GWorld.NetworkMgr:GetAccountName()
		self:QuickLogin(MiscUtils.Trim(account_name), MiscUtils.Trim(account_name))
	end
	self:EnterWorld()
end

function Account:SdkLogin()
	self.logger.debug("SdkLogin")
	local SdkUserInfo = HeroUSDKUtils.GetUserInfo()
	if not SdkUserInfo then
		error("SdkLogin, but SdkUserInfo is invalid!!!")
		return
	end
	local HeroUSDKSubsystem = HeroUSDKSubsystem()
    ---@type UHotUpdateSubsystem
    local HotUpdateSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UHotUpdateSubsystem)
	local PatchKey, PatchVersion, ClientVersion = HotUpdateSubsystem:GetClientVersion()
	local bIsPlayInEditor = URuntimeCommonFunctionLibrary.IsInUEEditor()
	local PatchIds = (not bIsPlayInEditor or EMLuaConst.bIsEditorEnableHotUpdate) and HotUpdateSubsystem:GetDownloadedPatchIds():ToTable() or nil
	local ClientInfo = {
		Hostnum = GWorld.NetworkMgr.hostnum,
		ConnectType = GWorld.NetworkMgr.ConnectType,
		HotfixIndex = GWorld.HotfixDataIndex or 0,
		ClientVersion = {
			["ForceUpdateCheck"] =  DataMgr.HotfixData.force_update_version
		},
		PatchVersion = {
			[PatchKey] = PatchVersion
		},
		PatchIds = PatchIds
	}

	local SdkInfo = {
		AccessToken = SdkUserInfo.accessToken,
		SdkUserId = SdkUserInfo.sdkUserId,
		UserName = SdkUserInfo.userName,
		IsGlobalSDK = HeroUSDKUtils.IsGlobalSDK(),
		DeviceId = HeroUSDKSubsystem:GetDeviceId(),
	}
	local BDC_Info = {
		appkey = HeroUSDKSubsystem:GetAppKey(),
		channel_id = HeroUSDKSubsystem:GetChannelId(),
		app_channel_id = HeroUSDKSubsystem:GetAppChannelId(),
		device_id = HeroUSDKSubsystem:GetBDCDeviceID(),
		img_channel_id = HeroUSDKSubsystem:GetMirrorChannelId(),
		click_id = HeroUSDKSubsystem.InstallClickID,
		-- oaid = HeroUSDKSubsystem.Oaid,
		os = HeroUSDKSubsystem:GetOS(),
		sdk_version = HeroUSDKSubsystem:GetBDCSdkVersion(),
		ads_json = HeroUSDKSubsystem:GetAdsJson(),
		user_agent = HeroUSDKSubsystem:GetUserAgent(),
		device_key = HeroUSDKSubsystem:GetDeviceKey(),
		wegame_distribute_id = HeroUSDKSubsystem.WeGameDistributionID,
		app_version = HeroUSDKSubsystem:GetBDCClientVersion(),
		system_version = HeroUSDKSubsystem:GetBDCSystemVersion(),
		manufacturer = HeroUSDKSubsystem:GetBDCManufacturer(),
		bundle_id = HeroUSDKSubsystem:GetBDCBundleId(),
		session_id = HeroUSDKSubsystem:GetBDCSessionId(),
		device_model = HeroUSDKSubsystem:GetBDCDeviceModel(),
		app_version_code = HeroUSDKSubsystem:GetBDCClientVersionCode(),
		brand = HeroUSDKSubsystem:GetBDCBrand(),
		cloud_app_msg = HeroUSDKSubsystem.CloudAppMsg,
		android_id = HeroUSDKSubsystem:GetAndroidID(),
		idfa = HeroUSDKSubsystem:GetIDFA(),
		idfv = HeroUSDKSubsystem:GetIDFV(),
		-- device_heroid = HeroUSDKSubsystem:GetDeviceId(),
	}
	
	local IsGlobalSDk = HeroUSDKUtils.IsGlobalSDK()
	 -- 当 不为海外包时，添加 oaid 字段
    if not IsGlobalSDk then
        BDC_Info.oaid = HeroUSDKSubsystem.Oaid
	else
		BDC_Info.gaid = HeroUSDKSubsystem:GetGaid()
    end
	PrintTable({ClientInfo=ClientInfo}, 2)
	PrintTable({SdkInfo=SdkInfo}, 2)
	self:CallServerMethod("SdkLogin", SdkInfo, ClientInfo, BDC_Info)
end

function Account:NotifyBindDevice()
	self.logger.debug("NotifyBindDevice")
	---@type Common_Dialog_Params
	local Params = {}
	Params.CloseBtnCallbackFunction = function()
		self:CallServerMethod("ConfirmBindDevice", false)
		-- HeroUSDKSubsystem(self):HeroSDKLogout()
	end
	 Params.LeftCallbackFunction = function()
		self:CallServerMethod("ConfirmBindDevice", false)
		-- HeroUSDKSubsystem(self):HeroSDKLogout()
	end
	Params.RightCallbackFunction = function()
		self:CallServerMethod("ConfirmBindDevice", true)
	end
	---@type BP_UIManagerComponent_C
	local UIManager = GWorld.GameInstance:GetGameUIManager()
	UIManager:ShowCommonPopupUI(100071, Params, UIManager:GetUIObj("LoginMainPage"))
end

function Account:QuickLogin(account_name, password)
	self.logger.debug("QuickLogin")
	local HeroUSDKSubsystem = HeroUSDKSubsystem()

	local ChannelId = GWorld.SdkChannel or 237
	local ImgChannelId = GWorld.SdkImgChannel or 0
	 ---@type UHotUpdateSubsystem
    local HotUpdateSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UHotUpdateSubsystem)
	local PatchKey, PatchVersion, ClientVersion = HotUpdateSubsystem:GetClientVersion()
	local bIsPlayInEditor = URuntimeCommonFunctionLibrary.IsInUEEditor()
	local PatchIds = (not bIsPlayInEditor or EMLuaConst.bIsEditorEnableHotUpdate) and HotUpdateSubsystem:GetDownloadedPatchIds():ToTable() or nil

	local ClientInfo = {
		Hostnum = GWorld.NetworkMgr.hostnum,
		Account = account_name,
		PassWord = password,
		ConnectType = GWorld.NetworkMgr.ConnectType,
		HotfixIndex = GWorld.HotfixDataIndex or 0,
		ClientVersion = {
			["ForceUpdateCheck"] =  DataMgr.HotfixData.force_update_version
		},
		PatchVersion = {
			[PatchKey] = PatchVersion
		},
		PatchIds = PatchIds
	}

	local BDC_Info = {
		appkey = HeroUSDKSubsystem:GetAppKey(),
		channel_id = ChannelId,
		app_channel_id = HeroUSDKSubsystem:GetAppChannelId(),
		img_channel_id = ImgChannelId,
		device_id = "123124342",
	}

	local IsGlobalSDk = HeroUSDKUtils.IsGlobalSDK()
	-- 当 不为海外包时，添加 oaid 字段
   if not IsGlobalSDk then
	   BDC_Info.oaid = HeroUSDKSubsystem.Oaid
   end
   
	local TestSdkInfo = {
		ChannelId = ChannelId,
	}
	PrintTable({ClientInfo=ClientInfo}, 2)
	PrintTable({BDC_Info=BDC_Info}, 2)
	self:CallServerMethod("QuickLogin", ClientInfo, BDC_Info,TestSdkInfo)
end

function Account:OnGetAllAvatars(avatars)
	self.logger.debug("OnGetAllAvatars")
	GWorld.NetworkMgr:Disconnect()
	-- GetAvatarInfos 为玩家的注册信息 [{},{},{}]
	GWorld.GetAvatarInfos = {}
	for i, v in ipairs(avatars) do
		GWorld.GetAvatarInfos[v.Hostnum] = v
	end
	PrintTable({avatars=avatars},5)
	EventManager:FireEvent(EventID.OnGetAllAvatars)
end

function Account:OnPatchForceUpdate()
	local LoginMainPage = GWorld.GameInstance:GetGameUIManager():GetUIObj("LoginMainPage");
	if LoginMainPage then
		LoginMainPage:ShowLoginUI(false)
	end
	local GameMode = UGameplayStatics.GetGameMode(GWorld.GameInstance)
	if GameMode then
		GameMode:StartUpdate()
	end
end

function Account:OnPatchResourceNotComplete()
	local HotUpdateUtils = require("Utils.HotUpdateUtils")
	local HotUpdateSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UHotUpdateSubsystem)
	local NecessoryPatchSigns = HotUpdateUtils.GetNecessoryPatchSigns()
	HotUpdateSubsystem:JumpToOptionalDownloadLevel("OptionPatch", NecessoryPatchSigns)
end

function Account:LoginResult(ret_code, info)
	GWorld.bShouldShowWaterMark = nil
	GWorld.WaterMarkContent = nil
	self.LoginQueuePopUI = nil
	info = info or {}
	local Reason = info.Reason or ""
	self.logger.debug("LoginResult", ret_code, Reason)
	if ret_code ~= ErrorCode.RET_SUCCESS and GWorld.NetworkMgr then
		GWorld.NetworkMgr:Disconnect()
		local bSimpleDisconnect = (ret_code == ErrorCode.RET_LOGIN_IN_DIFF_DEVICE or ret_code == ErrorCode.RET_LOGIN_REFUSE_BIND_DEVICE or ret_code == ErrorCode.RET_LOGIN_WHITE_LIST_CHECK_FAILED)
		--if bSimpleDisconnect then
		--	GWorld.NetworkMgr:Disconnect()
		--elseif ret_code == ErrorCode.RET_LOGIN_BY_CLIENT_VERSION_TOO_LOW then
		if ret_code == ErrorCode.RET_LOGIN_BY_CLIENT_VERSION_TOO_LOW then
			local Params = {}
			Params.CloseBtnCallbackFunction = self.OnPatchForceUpdate
			Params.LeftCallbackFunction = self.OnPatchForceUpdate
			Params.RightCallbackFunction = self.OnPatchForceUpdate
			local UIManager = GWorld.GameInstance:GetGameUIManager()
			UIManager:ShowCommonPopupUI(100151, Params, self)
		elseif ret_code == ErrorCode.RET_LOGIN_BY_PATCH_VERSION_TOO_LOW then
			local SplitsReason = string.split(Reason, " ")
			local ServerVersionStr = SplitsReason[#SplitsReason]
			local ServerVersion = tonumber(ServerVersionStr) or -1
			local HotupdateSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UHotUpdateSubsystem)
			HotupdateSubsystem.CacheServerPatchVersion = ServerVersion
			HotupdateSubsystem:SetServerPatchVersionVerifing()
			local Params = {}
			Params.CloseBtnCallbackFunction = self.OnPatchForceUpdate
			Params.LeftCallbackFunction = self.OnPatchForceUpdate
			Params.RightCallbackFunction = self.OnPatchForceUpdate
			local UIManager = GWorld.GameInstance:GetGameUIManager()
			UIManager:ShowCommonPopupUI(100151, Params, self)
		elseif ret_code == ErrorCode.RET_LOGIN_TO_TARGET_SERVER then
			local TargetHostnum = info.TargetHostnum
			if not TargetHostnum then
				self.logger.error("LoginResult RET_LOGIN_TO_TARGET_SERVER but TargetHostnum is nil")
				return
			end
			local UIManager = GWorld.GameInstance:GetGameUIManager()
			local LoginMainPage = UIManager:GetUIObj("LoginMainPage")
			if not LoginMainPage then
				self.logger.error("LoginResult RET_LOGIN_TO_TARGET_SERVER but LoginMainPage is nil")
				return
			end
			self.logger.debug("LoginResult RET_LOGIN_TO_TARGET_SERVER to ", TargetHostnum)
			LoginMainPage:LoginToTargetServer(TargetHostnum)
		elseif ret_code == ErrorCode.RET_LOGIN_QUIT_QUEUE then
			if GWorld.NetworkMgr then
				GWorld.NetworkMgr:Disconnect()
				GWorld.NetworkMgr:LogoutEvent()
			end
		elseif ret_code == ErrorCode.RET_LOGIN_AUTH_FAILED then
			HeroUSDKSubsystem():HeroSDKLogout()
		elseif ret_code == ErrorCode.RET_LOGIN_PATCH_RESOURCE_NOT_COMPLETE then
			local MissingPatchIds = string.split(Reason, ",")
			local HotUpdateUtils = require("Utils.HotUpdateUtils")
			HotUpdateUtils.MergeNecessoryPatchSigns(MissingPatchIds)
			local Params = {}
			Params.CloseBtnCallbackFunction = self.OnPatchResourceNotComplete
			Params.LeftCallbackFunction = self.OnPatchResourceNotComplete
			Params.RightCallbackFunction = self.OnPatchResourceNotComplete
			local UIManager = GWorld.GameInstance:GetGameUIManager()
			UIManager:ShowCommonPopupUI(100151, Params, self)
		elseif not bSimpleDisconnect then
			info.ErrorCode = ret_code
			GWorld.NetworkMgr:DisconnectAndShowUI(info)
		end
		HeroUSDKSubsystem():CloseLoadingReconnect()
		PrintTable(info, 2, "login_result code:"..tostring(ret_code))
		if ret_code == ErrorCode.RET_LOGIN_IN_DIFF_DEVICE then
			-- cbt1 跨设备登陆，弹出提示
			UIManager(GWorld.GameInstance):ShowUITip(UIConst.Tip_CommonToast, GText("UI_CBT1_WARNBINDING_TOAST"))
		elseif ret_code == ErrorCode.RET_LOGIN_WHITE_LIST_CHECK_FAILED then
			-- 白名单
			UIManager(GWorld.GameInstance):ShowCommonPopupUI(100121)
		end
	end
end

function Account:OnHotfixWhenLogin(HotfixScript, HotfixIndex)
	self.logger.debug("OnHotfixWhenLogin", HotfixScript, HotfixIndex)
	-- 执行热更
	if HotfixIndex then
		require("HotFix").ExecHotFix(HotfixIndex, HotfixScript)
		GWorld.HotfixDataIndex = HotfixIndex
	end
end

function Account:OnNoticeLoginQueue(QueueSite, QueueLength)
	self.logger.debug(string.format("Account:OnNoticeLoginQueue QueueSite:%s QueueLength:%s", QueueSite, QueueLength))
	if self.LoginQueuePopUI then
		return
	end
	local UIManager = GWorld.GameInstance:GetGameUIManager()
	local LoginMainPage = UIManager:GetUIObj("LoginMainPage")
	if LoginMainPage then
		LoginMainPage:CloseLoadingReconnect()
	end
	local Params = 
	{
		CloseBtnCallbackFunction = function()
			self:CallServerMethod("QuitLoginQueue")
		end,
		LeftCallbackFunction = function()
			self:CallServerMethod("QuitLoginQueue")
		end,
		RightCallbackFunction = function()
			self:CallServerMethod("QuitLoginQueue")
		end
	}
	self.LoginQueuePopUI = UIManager:ShowCommonPopupUI(100265, Params)
end

-- 取消复制账号二次弹窗
function Account:ShowCancelConfirmDialog()
	local Params = {}
	Params.RightCallbackFunction = function()
		print(_G.LogTag, "Account LoginWithoutPubAccountInfo")
		self:LoginWithoutPubAccountInfo()
	end
	Params.LeftCallbackFunction = function()
		self:ShowCopyAccountDialog()
	end
	UIManager(self):ShowCommonPopupUI(100282, Params)
end

-- 是否需要复制正式服账号弹窗
function Account:ShowCopyAccountDialog()
	local Params = {}
	Params.RightCallbackFunction = function()
		print(_G.LogTag, "Account LoginWithPubAccountInfo")
		self:LoginWithPubAccountInfo()
	end
	Params.LeftCallbackFunction = function()
		self:ShowCancelConfirmDialog()
	end
	UIManager(self):ShowCommonPopupUI(100272, Params)
end

-- 第一次登录体验服，弹出复制账号的提示
function Account:OnQueryPubAccountInfo(ret, docs)
	self.logger.debug("OnQueryPubAccountInfo", ret, docs)

	-- 判定是否是先遣包
	local bExperience = MiscUtils.GetGameCofingSettings("bExperience") or false
	if not bExperience then
		return
	end

	self:ShowCopyAccountDialog()
end

-- 复制账号
function Account:LoginWithPubAccountInfo()
	self.logger.debug("LoginWithPubAccountInfo")
	self:CallServerMethod("LoginWithPubAccountInfo")
end

-- 不复制账号
function Account:LoginWithoutPubAccountInfo()
	self.logger.debug("LoginWithoutPubAccountInfo")
	self:CallServerMethod("LoginWithoutPubAccountInfo")
end

Assemble.AssembleComponents(Account)
return Account