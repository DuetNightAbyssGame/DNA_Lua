--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local EMCache = require "EMCache.EMCache"
local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"

---@type WBP_Camera_Screenshot_C
local M = Class("BluePrints.UI.BP_UIState_C")

local Handle = UE4.UWidgetBlueprintLibrary.Handled()
local Unhandle = UE4.UWidgetBlueprintLibrary.Unhandled()

local FilePath = UKismetSystemLibrary.GetProjectSavedDirectory() .. "HighResScreenshots/"
local AlbumName = GText("ScreenShot_FolderName")
local DateTimeStr = ULowEntryExtendedStandardLibrary.DateTime_ToString(UKismetMathLibrary.Now("%Y.%m.%d-%H.%M.%S"))
local FileName = "Screenshot-" .. DateTimeStr .. ".png"

function M:Construct()
    local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(self)
    if PlatformName == "Android" then
        FilePath = UE4.URuntimeCommonFunctionLibrary.ConvertRelativePathToFull(UE4.UBlueprintPathsLibrary.ProjectSavedDir() .. "HighResScreenshots/")
    elseif PlatformName == "IOS" then
        FilePath = UE4.URuntimeCommonFunctionLibrary.GetProjectSavedPath() .. "HighResScreenshots/"
        FilePath = FilePath:gsub("%.%.%/", "")
    end

    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)

    self.Btn_Yes_1.IsFocusable = true
    self.Btn_Yes_1.bLimitNavigation = true

    self.Btn_Yes_1:UnBindEventOnClicked(self,self.TrySaveScreenshot)
    self.Btn_Yes_1:BindEventOnClicked(self,self.TrySaveScreenshot)
    self.Btn_Quit_1:UnBindEventOnClicked(self,self.HideWithAnim)
    self.Btn_Quit_1:BindEventOnClicked(self,self.HideWithAnim)
    self:UnbindAllFromAnimationFinished(self.Cheese)
    self:BindToAnimationFinished(self.Cheese,{self,self.OnCheeseFinished})
    self:UnbindAllFromAnimationFinished(self.Save)
    self:UnbindAllFromAnimationFinished(self.Auto_Out)
    self:BindToAnimationFinished(self.Save,{self,self.OnHideAnimFinished})
    self:BindToAnimationFinished(self.Auto_Out,{self,self.OnHideAnimFinished})
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        self.Role_UID:SetText("UID:"..tostring(Avatar.Uid))
        self.Role_ID:SetText(Avatar.Nickname)
    else
        self.Role_UID:SetText("")
        self.Role_ID:SetText("")
    end
    self.Btn_Quit_1:SetText(GText("UI_PATCH_CANCEL"))
    self.Btn_Yes_1:SetText(GText("UI_RegionMap_Save"))
    self.LanguageMap = {
		[CommonConst.SystemLanguages.CN] = "ZH_CHS",
		[CommonConst.SystemLanguages.EN] = "EN",
		[CommonConst.SystemLanguages.JP] = "JA",
		[CommonConst.SystemLanguages.KR] = "KR",
		[CommonConst.SystemLanguages.TC] = "ZH_CHT",
		[CommonConst.SystemLanguages.FR] = "EN",
    }
    self.CheckBox_Watermark:BindEventOnClicked({Inst = self,Func = self.OnWatermarkCheckStateChanged})
    self.Text_Watermark:SetText(GText("UI_CameraSystem_Watermark"))
    self.CheckBox_Information:BindEventOnClicked({Inst = self,Func = self.OnInformationCheckStateChanged})
    self.Text_Information:SetText(GText("UI_CameraSystem_PlayerPersonalInformation"))
    if self.Btn_Save then  -- 默认隐藏Save按钮
        self.Btn_Quit_1:SetGamePadImg("Y")
        self.Btn_Save:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.CheckBox_Watermark:SetKey("Img", "Left")
    self.CheckBox_Information:SetKey("Img", "Right")

    self.Btn_Yes_1:SetGamePadImg("A")
    self.Btn_Quit_1:SetGamePadImg("B")

    self.KeyDownEvent = {}
    self.KeyDownEvent[Const.GamepadDPadLeft] = {Func = self.CheckBox_Watermark.OnClicked, Self = self.CheckBox_Watermark}
    self.KeyDownEvent[Const.GamepadDPadRight] = {Func = self.CheckBox_Information.OnClicked, Self = self.CheckBox_Information}
    self.KeyDownEvent[Const.GamepadFaceButtonRight] = {Func = self.HideWithAnim, Self = self}
    self.KeyDownEvent[Const.GamepadFaceButtonDown] = {Func = self.TrySaveScreenshot, Self = self}
    self.KeyDownEvent["Escape"] = {Func = self.HideWithAnim, Self = self}

    if self.Btn_Upload then -- 上传到照片墙（愚人节）
        self.Btn_Upload:SetGamePadImg("Y")
        self.KeyDownEvent[Const.GamepadFaceButtonUp] = {Func = self.UploadToPhotoWall, Self = self}
    end
end

function M:Init(Params)
    self.Parent = Params.Parent
    self.OnHideCallback = Params.OnHiddenCallback
    if(not IsValid(Params.Image))then
        self:Hide()
        return
    end
    self.bSaved = false
    self.bSavedInLocal = false
    self.CheckBox_Watermark:SetIsChecked(true)
    self.CheckBox_Information:SetIsChecked(true)
    self:SetVisibility(UIConst.VisibilityOp.Visible)
    self.ScreenshotImage = Params.Image
    self.Parent:BlockAllUIInput(true,"SP_DisplayOnly")
    self.Screenshot:SetBrushResourceObject(self.ScreenshotImage)
    self.WaterMarkIcon = LoadObject('/Game/UI/Texture/Dynamic/Image/Lang/'..self.LanguageMap[CommonConst.SystemLanguage]..'/T_BG_GameNameIcon_Camera.T_BG_GameNameIcon_Camera')
    self.Img_Watermark:SetBrushResourceObject(self.WaterMarkIcon)
    self:PlayAnimation(self.Cheese)
    AudioManager(self):PlayUISound(self, "event:/ui/common/camera_take_photo", "Camera_Shot", nil)
    self:OnUpdateUIStyleByInputTypeChange(UIUtils.UtilsGetCurrentInputType())
    self.HeroUSDKSubsystem = Utils.HeroUSDKSubsystem()
    self.HeroUSDKSubsystem:SetHeroSDKEnable(true)
    self:SharedInit()
    self.Parent.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)

    DateTimeStr = ULowEntryExtendedStandardLibrary.DateTime_ToString(UKismetMathLibrary.Now("%Y.%m.%d-%H.%M.%S"))
    FileName = "Screenshot-" .. DateTimeStr .. ".png"

    self.bHasFoundTargets = Params.bHasFoundTargets
    if Params.bAprilFoolsDayActivity then -- 愚人节活动
        self.Btn_Upload:SetText(GText("AFDayEvent_PhotoWall_Upload"))
        self.Btn_Upload:UnBindEventOnClickedByObj(self)
        if not Params.bHasFoundTargets then
            self.Btn_Upload:ForbidBtn(true)
            self.Btn_Upload:BindForbidStateExecuteEvent(self,self.UploadToPhotoWall)
        else
            self.Btn_Upload:ForbidBtn(false)
            self.Btn_Upload:BindSingleEventOnClicked(self,self.UploadToPhotoWall)
        end
    end
end

function M:OnDestroy()
    self:ShareUninit()
end

function M:SharedInit()
    if UE.AHotUpdateGameMode.IsExamineDistribution() then
        self.VB_SNS:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.VB_SNS_Other:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.SNS_Link:SetVisibility(UIConst.VisibilityOp.Collapsed)
        return
    end

    if UUCloudGameInstanceSubsystem.IsCloudGame() then
        self.VB_SNS:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.VB_SNS_Other:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.SNS_Link:SetVisibility(UIConst.VisibilityOp.Collapsed)
        return
    end

    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC"then
        self.VB_SNS:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.VB_SNS_Other:SetVisibility(UIConst.VisibilityOp.Collapsed)
        return
    end

    self.HeroUSDKSubsystem.HeroSDKShareDelegate:Bind(self, self.ShareDelegateCallback)

    self.SharedLinkTable = {}
    self.SharedLinkTable["Btn_SNS_QQ"] = {
        SharePlatform = Const.HeroUsdkSharePlatform.QQ,
        ShareType = Const.HeroUsdkShareType.Image,
        ShareImage = self.ScreenshotImage,
    }
    self.SharedLinkTable["Btn_SNS_QQSpace"] = {
        SharePlatform = Const.HeroUsdkSharePlatform.QQZone,
        ShareType = Const.HeroUsdkShareType.Image,
        ShareImage = self.ScreenshotImage,
    }
    self.SharedLinkTable["Btn_SNS_Weixin"] = {
        SharePlatform = Const.HeroUsdkSharePlatform.Wechat,
        ShareType = Const.HeroUsdkShareType.Image,
        ShareImage = self.ScreenshotImage,
    }
    self.SharedLinkTable["Btn_SNS_Weixin_FriendCricle"] = {
        SharePlatform = Const.HeroUsdkSharePlatform.WechatMoments,
        ShareType = Const.HeroUsdkShareType.Image,
        ShareImage = self.ScreenshotImage,
    }
    self.SharedLinkTable["Btn_SNS_Weibo"] = {
        SharePlatform = Const.HeroUsdkSharePlatform.Weibo,
        ShareType = Const.HeroUsdkShareType.Image,
        ShareImage = self.ScreenshotImage,
    }
    self.SharedLinkTable["Btn_SNS_TAPTAP"] = {
        SharePlatform = Const.HeroUsdkSharePlatform.TapTap,
        ShareType = Const.HeroUsdkShareType.Image,
        ShareImage = self.ScreenshotImage,
    }
    self.SharedLinkTable["Btn_SNS_Xiaohongshu"] = {
        SharePlatform = Const.HeroUsdkSharePlatform.XHS,
        ShareType = Const.HeroUsdkShareType.Image,
        ShareImage = self.ScreenshotImage,
    }
    self.SharedLinkTable["Btn_SNS_Douyin"] = {
        SharePlatform = Const.HeroUsdkSharePlatform.DouyinContact,
        ShareType = Const.HeroUsdkShareType.Image,
        ShareImage = self.ScreenshotImage,
    }

    self.SharedLinkTable["Btn_SNS_Bilibili"] = {
        SharePlatform = Const.HeroUsdkSharePlatform.BiliBili,
        ShareType = Const.HeroUsdkShareType.Image,
        ShareImage = self.ScreenshotImage,
    }
    self.SharedLinkTable["Btn_SNS_Kuaishou"] = {
        SharePlatform = Const.HeroUsdkSharePlatform.KS,
        ShareType = Const.HeroUsdkShareType.Image,
        ShareImage = self.ScreenshotImage,
    }

    self.SNS_Weixin:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.SNS_Weixin_FriendCricle:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.SNS_Weibo:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.SNS_QQ:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.SNS_TAPTAP:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.SNS_Xiaohongshu:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.SNS_Douyin:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)

    local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(self)
    if PlatformName == "IOS" then
        self.SNS_TAPTAP:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end

    if ActivityUtils.IsBilibiliServer() then
        self.SNS_TAPTAP:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.SNS_Xiaohongshu:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.SNS_Douyin:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.SNS_Bilibili:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end

    if HeroUSDKSubsystem(self):GetChannelId() == 303 then -- Oppo
        self.SNS_TAPTAP:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.SNS_Xiaohongshu:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.SNS_Douyin:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end

    if self.HeroUSDKSubsystem:IsGlobalSDK() then
        self.VB_SNS:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.VB_SNS_Other:SetVisibility(UIConst.VisibilityOp.Visible)
        self.SharedLinkTable["Btn_SNS_Facebook"] = {
            SharePlatform = Const.HeroUsdkSharePlatform.Facebook,
            ShareType = Const.HeroUsdkShareType.Image,
            ShareImage = self.ScreenshotImage,
        }
        self.SharedLinkTable["Btn_SNS_X"] = {
            SharePlatform = Const.HeroUsdkSharePlatform.Twitter,
            ShareType = Const.HeroUsdkShareType.Image,
            ShareImage = self.ScreenshotImage,
        }

        --- 待实现 SDK
        self.SharedLinkTable["Btn_SNS_INS"] = {
            SharePlatform = Const.HeroUsdkSharePlatform.All,
            ShareType = Const.HeroUsdkShareType.Image,
            ShareImage = self.ScreenshotImage,
        }
    end

    for BtnName, ShareConfig in pairs(self.SharedLinkTable) do
        local Button = self[BtnName]
        if Button then
            Button:UnBindEventOnClicked(self, self.OnShareButtonClicked)
            Button:BindEventOnClicked(self, self.OnShareButtonClicked, ShareConfig)
        end
    end
end

function M:ShareUninit()
    self.HeroUSDKSubsystem.HeroSDKShareDelegate:Unbind()
end

function M:ShareDelegateCallback(Result, SharePlatform, msg)
    DebugPrint("LogEMHeroUsdk ShareDelegateCallback: ", Result, SharePlatform, msg)
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, string.format(msg), 2.5)
end

function M:OnShareButtonClicked(ShareConfig)
    if not ShareConfig then
        return
    end

    if not self.bSavedInLocal then
        self:SaveScreenshotToLocal()
    end

    local ShareInfo = UE4.FShareInfo()
    ShareInfo.sharePlatform = ShareConfig.SharePlatform
    ShareInfo.shareType = ShareConfig.ShareType
    ShareInfo.title = ShareConfig.ShareTitle or ""
    ShareInfo.text = ShareConfig.ShareText or ""
    ShareInfo.linkUrl = ShareConfig.ShareLink or ""
    ShareInfo.imagePath = FilePath..FileName

    self.HeroUSDKSubsystem:RequestShare(ShareInfo)
end

function M:OnCheeseFinished()
    self.Parent:BlockAllUIInput(false)
end

-- 跳转到对应活动页
function M:JumpToActivityPage()
    if not self.EventId then
        return
    end
    local PageConfigData = DataMgr.EventPortal[self.EventId]
    if PageConfigData and PageConfigData.JumpUIId then
        PageJumpUtils:JumpToTargetPageByJumpId(PageConfigData.JumpUIId, self.EventId, self.EventParams)
    end
end

function M:TrySaveScreenshot()
    -- Check if the dir is exist, if not exist, create it.
    if not UE4.UBlueprintFileUtilsBPLibrary.DirectoryExists(FilePath) then
        UE4.UBlueprintFileUtilsBPLibrary.MakeDirectory(FilePath)
    end

    --Check the storage usage state.
    local NumberOfFreeBytes = UE4.URuntimeCommonFunctionLibrary.GetDiskTotalAndFreeSpace(FilePath)
    NumberOfFreeBytes = NumberOfFreeBytes * 8.0 / 1024.0 / 1024.0
    if NumberOfFreeBytes < DataMgr.GlobalConstant.CameraMinMemory.ConstantValue and not UUCloudGameInstanceSubsystem.IsCloudGame() then
        UIManager(self):ShowUITip(UIConst.Tip_CommonWarning,string.format(GText("UI_CameraSystem_NoMemory")),1)
        return
    end

    self:SaveScreenshotImp()
end

-- 上传至照片墙（愚人节活动）
function M:UploadToPhotoWall()
    if not self.bHasFoundTargets then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast,string.format(GText("AFDayEvent_PhotoWall_UploadFailed")))
        return
    end

    AudioManager(self):PlayUISound(self, "event:/ui/activity/fools_day_btn_common", nil, nil)
    if(self.Parent)then
        self.Parent:OnExButtonClicked_CPP()
    end
    self:HideWithAnim()
end

function M:SaveScreenshotToLocal()
    local ImageWidth = self.ScreenshotImage:Blueprint_GetSizeX()
    local ImageHeight = self.ScreenshotImage:Blueprint_GetSizeY()
    if(self.RTWidth ~= ImageWidth or self.RTHeight ~= ImageHeight)then
        self.RTWidth = ImageWidth
        self.RTHeight = ImageHeight
        self.RenderTarget = nil
    end
    if(not IsValid(self.RenderTarget))then
        self.RenderTarget = UKismetRenderingLibrary.CreateRenderTarget2D(self,self.RTWidth,self.RTHeight,
                                                                    UE4.ETextureRenderTargetFormat.RTF_RGBA8_SRGB)
    end
    if(not IsValid(self.RenderTarget))then
        return
    end
    UKismetRenderingLibrary.ClearRenderTarget2D(self,self.RenderTarget)

    local Canvas,Size,Context = UKismetRenderingLibrary.BeginDrawCanvasToRenderTarget(self,self.RenderTarget)

    --绘制截屏
    Canvas:K2_DrawTexture(self.ScreenshotImage,FVector2D(0,0),Size)

    --测试服绘制水印
    if (GWorld and GWorld.bShouldShowWaterMark) or Const.bTakePhotoAddWatermark then
        local GameInstance = GWorld.GameInstance
        if GameInstance and GameInstance.GetGameUIManager then
            local TestServerWaterMarkUI = GameInstance:GetGameUIManager():GetUI("WaterMark")
            if TestServerWaterMarkUI then
                local WatermarkTexture2D = UKismetRenderingLibrary.CreateRenderTarget2D(self, self.RTWidth, self.RTHeight, UE4.ETextureRenderTargetFormat.RTF_RGBA8_SRGB)
                if (IsValid(WatermarkTexture2D)) then
                    local WatermarkTextureRes = UE4.URuntimeCommonFunctionLibrary.RenderWidgetToTexture(TestServerWaterMarkUI, WatermarkTexture2D, self.RTWidth, self.RTHeight, 16)
                    Canvas:K2_DrawTexture(WatermarkTextureRes, FVector2D(0,0), Size)
                end
            end
        end
    end

    local LocalCoordinate = FVector2D(0,0)
    local ScreenshotGeo = self.Screenshot:GetTickSpaceGeometry()
    local ScreenshotAbsSize = USlateBlueprintLibrary.GetAbsoluteSize(ScreenshotGeo)
    local ScreenshotPos = USlateBlueprintLibrary.LocalToAbsolute(ScreenshotGeo,LocalCoordinate) --截图控件左上角
    local CanvasScale = Size.X / ScreenshotAbsSize.X --实际截图相对于控件的缩放
    local Offset = ScreenshotPos

    --绘制水印
    if(self.CheckBox_Watermark:IsChecked())then
        local WatermarkGeo = self.Img_Watermark:GetTickSpaceGeometry()
        local WatermarkAbsSize = USlateBlueprintLibrary.GetAbsoluteSize(WatermarkGeo)
        local WatermarkPos = USlateBlueprintLibrary.LocalToAbsolute(WatermarkGeo,LocalCoordinate)  - Offset
        WatermarkPos = WatermarkPos * CanvasScale
        Canvas:K2_DrawTexture(self.WaterMarkIcon,WatermarkPos,WatermarkAbsSize * CanvasScale)
    end

    --绘制文本
    if(self.CheckBox_Information:IsChecked())then
        -- local Role_IDGeo = self.Role_ID:GetTickSpaceGeometry()
        -- local Role_UIDGeo = self.Role_UID:GetTickSpaceGeometry()
        local Scale
        if (Size.X / Size.Y) - (16/9) < 0 then
            Scale = Size.X / 1920
        else
            Scale = EMCache:Get('ScreenQuality') or 1
        end
        Scale = Scale * (self.Role_ID.Font.Size /self.FrontToDraw.LegacyFontSize) * 1.3 --需要乘1.3结果才正确，原因未知
        local TextDrawScale = FVector2D(Scale,Scale)
        -- local Role_IDGeoPos = USlateBlueprintLibrary.LocalToAbsolute(Role_IDGeo,LocalCoordinate) - Offset
        -- Role_IDGeoPos = Role_IDGeoPos * CanvasScale
        local RoleIdStr = UE4.UKismetTextLibrary.Conv_TextToString(self.Role_ID:GetText())
        local FontXY = UE4.UUIFunctionLibrary.MeasureFont(RoleIdStr, self.Role_ID.Font, 1 + Scale)
        -- local Role_IDGeoPos = Size - FVector2D(self.Role_ID.Font.Size * UE4.UKismetStringLibrary.Len(RoleIdStr), 4 * self.Role_ID.Font.Size)
        local SpaceBase = 10
        local Role_IDGeoPos = Size - FVector2D(FontXY.X, 2 * (FontXY.Y + SpaceBase))
        Canvas:K2_DrawText(self.FrontToDraw,self.Role_ID:GetText(),Role_IDGeoPos,TextDrawScale,
                        self.Role_ID.ColorAndOpacity.SpecifiedColor,0,self.Role_ID.ShadowColorAndOpacity, self.Role_ID.ShadowOffset)
        -- local Role_UIDGeoPos = USlateBlueprintLibrary.LocalToAbsolute(Role_UIDGeo,LocalCoordinate) - Offset
        -- Role_UIDGeoPos = Role_UIDGeoPos * CanvasScale
        local RoleUidStr = UE4.UKismetTextLibrary.Conv_TextToString(self.Role_UID:GetText())
        -- local Role_UIDGeoPos = Size - FVector2D(self.Role_ID.Font.Size * UE4.UKismetStringLibrary.Len(RoleUidStr), 2 * self.Role_ID.Font.Size)
        FontXY = UE4.UUIFunctionLibrary.MeasureFont(RoleUidStr, self.Role_ID.Font, 1 + Scale)
        local Role_UIDGeoPos = Size - FVector2D(FontXY.X, FontXY.Y + SpaceBase)
        Canvas:K2_DrawText(self.FrontToDraw,self.Role_UID:GetText(),Role_UIDGeoPos,TextDrawScale,
        self.Role_UID.ColorAndOpacity.SpecifiedColor,0,self.Role_UID.ShadowColorAndOpacity, self.Role_UID.ShadowOffset)

        DebugPrint("Current: ", UE4.UUIFunctionLibrary.GetFontHeight(self.Role_ID.Font),  FontXY, self.Role_ID.Font.Size, self.FrontToDraw.LegacyFontSize, Size, Scale, Role_IDGeoPos, Role_UIDGeoPos)
    end

    UKismetRenderingLibrary.EndDrawCanvasToRenderTarget(self,Context)

    --- Save to the temp path
    UKismetRenderingLibrary.ExportRenderTarget(self,self.RenderTarget,FilePath,FileName)

    self.bSavedInLocal = true
end

function M:SaveScreenshotImp()
    AudioManager(self):PlayUISound(self, "event:/ui/common/camera_photo_save", "Camera_Save", nil)
    self:PlayAnimation(self.Save)

    if not self.bSavedInLocal then
        self:SaveScreenshotToLocal()
    end

    --- Check platform and save to the album
    local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(self)
    if PlatformName == "Android" or PlatformName == "IOS" then
        self.HeroUSDKSubsystem:RequestSaveToAlbum(FilePath..FileName, AlbumName)
    end

    self.bSaved = true
    self.Parent:BlockAllUIInput(true,"SP_DisplayOnly")

    self:AddTimer(0.5,function()
        if not UUCloudGameInstanceSubsystem.IsCloudGame() then
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast,string.format(GText("UI_CameraSystem_PhotoSave"),FilePath),2.5)
        end
        local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(self)
        if PlatformName == "Android" then
            UE4.UBlueprintFileUtilsBPLibrary.DeleteFile(FilePath..FileName)
        end
    end,false,0,"ShowSavePathToast")
end

function M:HideWithAnim()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_cancel", "Camera_Cancel_Save", nil)
    self.Parent:BlockAllUIInput(true,"SP_DisplayOnly")
    self:PlayAnimation(self.Auto_Out)
end

function M:Hide()
    self:OnHideAnimFinished()
end

function M:OnHideAnimFinished()
    self.Parent:BlockAllUIInput(false)
    self:SetVisibility(UIConst.VisibilityOp.Collapsed)
    if(self.OnHideCallback)then
        self.OnHideCallback(self.Parent,self.bSaved)
    end
end

function M:OnWatermarkCheckStateChanged(IsChecked)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", "Camera_WatermarkClicked", nil)
    if(IsChecked)then
        self.Img_Watermark:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Img_Watermark:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:OnInformationCheckStateChanged(IsChecked)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", "Camera_WatermarkClicked", nil)
    if(IsChecked)then
        self.Role_ID:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Role_UID:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Role_ID:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Role_UID:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    self.CheckBox_Watermark.Com_KeyImg:SetVisibility(CurInputType == ECommonInputType.Gamepad and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
    self.CheckBox_Information.Com_KeyImg:SetVisibility(CurInputType == ECommonInputType.Gamepad and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)

    if CurInputType == ECommonInputType.Gamepad then
        -- self.GameInputModeSubsystem:SetTargetUIFocusWidget(self.Btn_Yes_1)
        self.Btn_Yes_1:StopAllAnimations()
        self.Btn_Yes_1:SetBtnHovered(false)
        self.Btn_Yes_1:PlayAnimation(self.Btn_Yes_1.Normal)
    end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    return self:OnKeyDown(MyGeometry, InKeyEvent)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if(self.KeyDownEvent[InKeyName])then
        local Callback = self.KeyDownEvent[InKeyName]
        Callback["Func"](Callback.Self)
        return Handle
    end

    return Unhandle
end

return M
