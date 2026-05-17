-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
---@type
local M = Class("BluePrints.UI.BP_UIState_C")
M._components = {
    "BluePrints.UI.KeyInputComponent"
}

function M:Construct()
    self.Btn_FullClose.OnClicked:Add(self, self.OnBtnFullCloseClicked)
    -- self.Text_Tip:SetText(GText('UI_GACHA_NEXT'))
    if not UIUtils.IsMobileInput() then 
        local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
        self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
        if (IsValid(self.GameInputModeSubsystem)) then
            self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshInfoByInputTypeChange) 
        end
    else
        self.Btn_Skip:SetCurrentTextBlock(GText("UI_GACHA_SKIP"))
        self.Btn_Skip:BindEventOnClicked(self,self.OnBtnSkipClicked)
    end
    self.VideoPlayer:HideSkipButton(true)
    self.VideoPlayer:BindEventToMediaPlayEnd(self,self.OnVideoPlayEnd)
    
    local PlatformName = UE4.UGameplayStatics.GetPlatformName()
    if PlatformName == "Android" then
        -- 监听应用生命周期事件，处理Android平台视频播放问题
        EventManager:AddEvent(EventID.ApplicationWillEnterBackground, self, self.OnApplicationWillEnterBackground)
        EventManager:AddEvent(EventID.ApplicationHasEnteredForeground, self, self.OnApplicationHasEnteredForeground)
    end
end

-- Params = {
--     TargetIdList = {1101,5301},
--     CallbackFunc = Func,
--     CallbackObj = Obj,
--     TargetType = 
--     bGacha = true, --是抽卡调用，不需要播out_end
-- }
function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    local Params = ...
    self:Init(Params)
end

function M:Init(Params)
    self.Params = Params
    self.TextFonts = {
        [3] = self.Font_Blue,
        [4] = self.Font_Purple,
        [5] = self.Font_Gold,
        [6] = self.Font_Red,
    }
    self:SetFocus()
    self.CurShowIndex = 0
    self.TargetType = self.Params.TargetType
    self.ShowTimes = #self.Params.TargetIdList
    self:RefreshCommonShowUI()
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self:InitGamepadView()
    else
        self:InitKeyboardView()
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/gacha_amb", "GachaAmb", nil)
    -- self.Text_Tip:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

function M:IsSkin()
    return self.TargetType == CommonConst.DataType.Skin
end

function M:IsChar()
    return self.TargetType == CommonConst.DataType.Char
end

function M:IsResource()
    return self.TargetType == CommonConst.DataType.Resource
end

function M:RefreshCommonShowUI()
    self.CurShowIndex = self.CurShowIndex + 1
    if self.Params.TargetIdList[self.CurShowIndex] == nil then
        return
    end
    self.TargetId = self.Params.TargetIdList[self.CurShowIndex]
    DebugPrint("----jzn----RefreshCommonShowUI---",self.TargetType,self.TargetId)
    self.IsSpineAnimation = true
    self.WS_BG:SetActiveWidgetIndex(0)
    self.Btn_FullClose:SetVisibility(UE4.ESlateVisibility.Visible)
    self.bSpaceBarSkip = false
    self.bPlayVideo = false
    self:SetCharImgRole()
    self:SetTargetNew()
    if self.Group_Skip then 
        self.Group_Skip:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self.Group_Main:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    if self:IsSkin() then
        self:InitSkinDetails()
        self:SetCharAttributeIcon()
    elseif self:IsChar() then
        self:InitCharDetails()
        self:SetCharAttributeIcon()
    elseif self:IsResource() then
        self:InitResourceDetails()
        self:SetResourceAttributeIcon()
    end
    self:PlayInAnim()
end

function M:InitCharDetails()
    local CharInfo = DataMgr.Char[self.TargetId]
    if not CharInfo then return end
    self.Text_AvatarName:SetText(GText(CharInfo.CharName))
    self.Group_SkinInfo:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Group_Detail:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    if CharInfo and CharInfo.SpineBp then
        self:GetCharSpineUI(CharInfo.SpineBp)
        local IsPCPlatform = CommonUtils.GetDeviceTypeByPlatformName(self) == "PC"  --是否是PC端
        if IsPCPlatform then
            self:InitLongPressEvent()
        end
    else
        self:GetCharSpineUI("WBP_Get_Avatar_WidgetMaer")
        DebugPrint(ErrorTag,"----jzn---当前角色无Spine蓝图资源----",self.TargetId)
    end
end

function M:InitSkinDetails()
    local SkinInfo = DataMgr.Skin[self.TargetId]
    if not SkinInfo then return end
    self.Group_SkinInfo:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Group_Detail:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Image_AvatarIcon:SetVisibility(UE4.ESlateVisibility.Collapsed)
    local CharId = SkinInfo.CharId
    local CharInfo = DataMgr.Char[CharId]
    self.Text_CharName:SetText(GText(CharInfo.CharName)..GText("UI_SkinDisplay_Suffix"))
    self.Text_SkinName:SetText(GText(SkinInfo.SkinName))
    local SkinRarity = SkinInfo.Rarity
    self.Com_QualityTag:Init(SkinRarity)
    self.Text_SkinName:SetFont(self.TextFonts[SkinRarity])
    if SkinInfo.GetDisplayType and SkinInfo.DisplayPath then
        if SkinInfo.GetDisplayType == 1 then --播片
            if self.Group_Skip then 
                self.Group_Skip:SetVisibility(UE4.ESlateVisibility.Visible)
            end
            self:InitLongPressEvent()
            self.bPlayVideo = true
            self.Btn_FullClose:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.UIDisplayTime = SkinInfo.UIDisplayTime or 5
        elseif SkinInfo.GetDisplayType == 2 then --Spine
            self:GetCharSpineUI(nil,SkinInfo.DisplayPath)
        end
    else
        self:GetCharSpineUI("WBP_Get_Avatar_WidgetMaer")
        DebugPrint(ErrorTag,"----jzn---当前皮肤无Spine蓝图资源----",self.TargetId)
    end
end

function M:InitResourceDetails()
    local ResourceInfo = DataMgr.Resource[self.TargetId]
    if not ResourceInfo then return end
    self.Group_SkinInfo:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Group_Detail:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Image_AvatarIcon:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Text_SkinName:SetText(GText(ResourceInfo.ResourceName))
    self.Text_CharName:SetText(GText("UI_Preview_GestureItem"))
    local Rarity = ResourceInfo.Rarity
    self.Com_QualityTag:Init(Rarity)
    self.Text_SkinName:SetFont(self.TextFonts[Rarity])
    if ResourceInfo.DisplayPath then
        if self.Group_Skip then 
            self.Group_Skip:SetVisibility(UE4.ESlateVisibility.Visible)
        end
        self:InitLongPressEvent()
        self.UIDisplayTime = ResourceInfo.UIDisplayTime or 5
        self.bPlayVideo = true
        self.Btn_FullClose:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self:PlayResourceVideo(ResourceInfo.DisplayPath)
    else
        self:GetCharSpineUI("WBP_Get_Avatar_WidgetMaer")
        DebugPrint(ErrorTag,"----jzn---当前轮盘动作无Spine蓝图资源----",self.TargetId)
    end
end

function M:InitLongPressEvent()
    self.bSpaceBarSkip = true
    self.bCanSkip = false
    self:AddLongPressEvent("SpaceBar",1,
                                    self.OnSpaceBar_LongPressStart,
                                    self.OnSpaceBar_LongPressCancel,
                                    self.OnSpaceBar_LongPressEnd)
    self:AddLongPressEvent("Gamepad_FaceButton_Bottom",1,
                        self.OnGamepad_FaceButton_Bottom_LongPressStart,
                        self.OnGamepad_FaceButton_Bottom_LongPressCancel,
                        self.OnGamepad_FaceButton_Bottom_LongPressEnd)
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self:InitGamepadView()
    else
        self:InitKeyboardView()
    end
end

function M:PlaySkinVideo()
    if not self:IsSkin() then return end
    local SkinInfo = DataMgr.Skin[self.TargetId]
    if not SkinInfo then return end
    if SkinInfo.GetDisplayType and SkinInfo.DisplayPath then
        local VideoPath = SkinInfo.DisplayPath
        self.WS_BG:SetActiveWidgetIndex(1)
        self.VideoPlayer:Stop()
        self.VideoPlayer:SetUrlByMediaSource(LoadObject(VideoPath))
        self.VideoPlayer:SetLooping(false)
        self.VideoPlayer:Play()
        self:PlayCharUISound()
    end
end

function M:PlayResourceVideo(VideoPath)
    if not self:IsResource() then return end
    self.WS_BG:SetActiveWidgetIndex(1)
    self.VideoPlayer:Stop()
    self.VideoPlayer:SetUrlByMediaSource(LoadObject(VideoPath))
    self.VideoPlayer:SetLooping(false)
    self.VideoPlayer:Play()
    self:PlayCharUISound()
end

function M:OnVideoPlayEnd()
    self:OnBtnFullCloseClicked()
end

function M:PlayCharSpineSpecialIn()
    if self.IsSpineAnimation and self.CharSpineUI then
        self.CharSpineUI:PlayAnimation(self.CharSpineUI.Special_In)
    end
end

function M:PlayCharSpine()
    self.SpineContent:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if self.IsSpineAnimation and self.CharSpineUI then
        self.SpineContent:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        if self.CharSpineUI.Spine_Char then
            local IsPCPlatform = CommonUtils.GetDeviceTypeByPlatformName(self) == "PC"  --是否是PC端
            if self:IsSkin() or (not IsPCPlatform) then
                self.CharSpineUI.Spine_Char:SetAnimation(0,"In",false)
                self.CharSpineUI.Spine_Char:AddAnimation(0,"Loop",true,0)
            else
                self.CharSpineUI.Spine_Char:SetAnimation(0,"In_Gacha",false)
                self.CharSpineUI.Spine_Char:AddAnimation(0,"Loop",true,0)
            end
        end
        if self.CharSpineUI.CharTitle then
            self.CharSpineUI.CharTitle:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        self:PlayCharUISound()
    end
end

function M:GetCharSpineUI(SpineName,SpineResource)
    self.SpineContent:ClearChildren()
    local BgPath
    if not SpineName and SpineResource then
        BgPath = SpineResource
    else
        local IsPCPlatform = CommonUtils.GetDeviceTypeByPlatformName(self) == "PC"  --是否是PC端
        if IsPCPlatform then
            BgPath = CommonConst.GachaBackgroundAddrPC..SpineName..'.'..SpineName
        else
            BgPath = CommonConst.GachaBackgroundAddrMobile..SpineName..'.'..SpineName
        end
    end
    local CharSpineUI = UIManager(self):CreateWidget(BgPath,false)
    if not CharSpineUI then
        self.IsSpineAnimation = false
        DebugPrint(ErrorTag,"---jzn---Gacha---Spine---error---",self.TargetId,SpineName)
        return
    end
    self.SpineContent:AddChild(CharSpineUI)
    local OverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(CharSpineUI)
    OverlaySlot:SetPadding(FMargin(0,0,0,0))
    OverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
    OverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
    self.CharSpineUI = CharSpineUI
    return self.CharSpineUI
end

function M:SetCharImgRole()
    if self:IsResource() then return end
    local CharId = self.TargetId
    if self:IsSkin() then
        local SkinInfo = DataMgr.Skin[self.TargetId]
        CharId = SkinInfo.CharId
    end
    local CharInfo = DataMgr.Char[CharId]
    self.IsCampAnimation = false
    if CharInfo.Camp then
        local CampInfo = DataMgr.CharCamp[CharInfo.Camp]
        if CampInfo and CampInfo.CampSpineBp then
            self:GetCharCampUI(CampInfo.CampSpineBp)
        else
            self.Group_Camp:ClearChildren()
        end
    else
        self.Group_Camp:ClearChildren()
    end
    self.Text_AvatarDesc:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if CharInfo.CharSubtitle then
        self.Text_AvatarDesc:SetText(GText(CharInfo.CharSubtitle))
        self.Text_AvatarDesc:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
end

function M:GetCharCampUI(BpPath)
    self.IsCampAnimation = true
    self.Group_Camp:ClearChildren()
    local CharCampUI = UIManager(self):CreateWidget(BpPath,false)
    if not CharCampUI then
        self.IsCampAnimation = false
        DebugPrint(ErrorTag,"---jzn---Char---Camp---error---",BpPath)
        return
    end
    self.Group_Camp:AddChild(CharCampUI)
    local OverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(CharCampUI)
    OverlaySlot:SetPadding(FMargin(0,0,0,0))
    OverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
    OverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
    if self:IsSkin() and self.Skin_Icon_Color then
        CharCampUI:SetColorAndOpacity(self.Skin_Icon_Color)
    end
    self.CharCampUI = CharCampUI
    return self.CharCampUI
end

function M:SetTargetNew()
    local Avatar = GWorld:GetAvatar()
    self.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.New_Skin:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if not Avatar then return end
    if self:IsSkin() then
        if AvatarUtils:GetTargetDataStatistics(Avatar,"Skin",self.TargetId) == 1 then
            self.New_Skin:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
    elseif self:IsChar() then
        if AvatarUtils:GetTargetDataStatistics(Avatar,"Char",self.TargetId) == 1 then
            self.New:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
    elseif self:IsResource() then
        if AvatarUtils:GetTargetDataStatistics(Avatar,"Resource",self.TargetId) == 1 then
            self.New_Skin:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
    end
end

function M:SetCharAttributeIcon()
    local CharId = self.TargetId
    if self:IsSkin() then
        local SkinInfo = DataMgr.Skin[self.TargetId]
        CharId = SkinInfo.CharId
    end
    local Attribute = DataMgr.BattleChar[CharId].Attribute
    local IconName = "Armory_" .. Attribute
    local AttributeIcon = LoadObject('/Game/UI/Texture/Dynamic/Atlas/Armory/T_' .. IconName .. ".T_" ..IconName)
    self.Image_AvatarType:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if AttributeIcon then
        self.Image_AvatarType:SetBrushResourceObject(AttributeIcon)
        self.Image_AvatarType:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    local CharInfo = DataMgr.Char[CharId]
    self.Image_AvatarIcon:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if CharInfo.CharColorVar and self[CharInfo.CharColorVar]then
        self.Image_AvatarIcon:SetBrush(self[CharInfo.CharColorVar])
        if not CharInfo.Camp then return end
        local CampInfo = DataMgr.CharCamp[CharInfo.Camp]
        if not CampInfo.CampIcon then return end
        local CampIcon = LoadObject(CampInfo.CampIcon)
        if not CampIcon then return end
        local CampMaterial = self.Image_AvatarIcon:GetDynamicMaterial()
        CampMaterial:SetTextureParameterValue("IconTex", CampIcon)
        self.Image_AvatarIcon:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
end

function M:SetResourceAttributeIcon()
    if not self:IsResource() then return end
    local ResourceInfo = DataMgr.Resource[self.TargetId]
    if not ResourceInfo then return end
    if ResourceInfo.CharColorVar and self[ResourceInfo.CharColorVar]then
        self.Image_AvatarIcon:SetBrush(self[ResourceInfo.CharColorVar])
        local Icon = LoadObject(ResourceInfo.Icon)
        if not Icon then return end
        local Material = self.Image_AvatarIcon:GetDynamicMaterial()
        Material:SetTextureParameterValue("IconTex", Icon)
        self.Image_AvatarIcon:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
end


function M:PlayCharVoiceAndText()
    self.Text_VoiceText:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if not self.TargetId then return end
    local VoiceInfo = DataMgr.CharVoice2Gacha[self.TargetId]
    if not VoiceInfo then return end
    local GachaVoicePart = 0
    for PartId,Data in pairs(VoiceInfo) do
        for key,value in pairs(Data) do
            if value.GachaVoiceCondition then
                local Avatar = GWorld:GetAvatar()
                local ConditionSucc = ConditionUtils.CheckCondition(Avatar,value.GachaVoiceCondition)
                if ConditionSucc then
                    GachaVoicePart = math.max(GachaVoicePart,PartId)
                end
            else
                GachaVoicePart = math.max(GachaVoicePart,PartId)
            end
        end
    end
    local NeedPlayVoiceInfo = VoiceInfo[GachaVoicePart]
    if not NeedPlayVoiceInfo then return end
    local CharInfo = DataMgr.BattleChar[self.TargetId]
    local PlayerInfo = DataMgr.Model[CharInfo.ModelId].MontagePrefix
    local CharName = self:SplitPlayerInfo(PlayerInfo)
    self:PlayCharVoice(CharName,NeedPlayVoiceInfo[1].VoiceRes[1],"GachaVoice")
    self.Text_VoiceText:SetText(GText(NeedPlayVoiceInfo[1].VoiceText[1]))
    self.Text_VoiceText:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

function M:SplitPlayerInfo(PlayerInfo)
    if not PlayerInfo then
        return ""
    end
    if string.sub(PlayerInfo, -1) == "_" then
        return string.sub(PlayerInfo, 1, -2)
    end
    return PlayerInfo
end

function M:PlayCharVoice(CharName,Voice,VoiceName)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    self.VoiceEventInstance = AudioManager(self):PlayCharVoice(Player,CharName, Voice,nil,VoiceName)
end

function M:StopCharVoice(VoiceName)
    if self.VoiceEventInstance then
        self.VoiceEventInstance = nil
    end
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    AudioManager(self):StopSound(Player,VoiceName)
end

function M:PlayCharUISound()
    local SoundPath
    if self:IsSkin() then
        local SkinInfo = DataMgr.Skin[self.TargetId]
        if not SkinInfo then return end
        SoundPath = SkinInfo.GetSoundPath
    elseif self:IsResource() then
        local ResourceInfo = DataMgr.Resource[self.TargetId]
        if not ResourceInfo then return end
        SoundPath = ResourceInfo.GetSoundPath
    elseif self:IsChar() then
        local CharId = self.TargetId
        local CharInfo = DataMgr.Char[CharId]
        local TargetName = CharInfo.GUIPathVariable
        if not TargetName then return end
        SoundPath = "event:/ui/char/gacha_show_"..TargetName
    end
    if not SoundPath then return end
    AudioManager(self):PlayUISound(self, SoundPath , "ShowTarget", nil)
end

function M:PlayInAnim()
    self.CantClick = true
    self.bCanSkip = false
    local AnimTime = nil
    local SetClick = function()
        self:SetFocus()
        self.CantClick = false
        if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
            self:InitGamepadView()
        else
            self:InitKeyboardView()
        end
    end
    local function IconInFinish()
        if self.bSpaceBarSkip then
            self.bCanSkip = true
            self:SetFocus()
        end
        if self:IsChar() then
            self:PlayAnimation(self.In)
            AnimTime = self.In:GetEndTime()
        else
            if self.bSpaceBarSkip then
                if self:IsExistTimer("PlaySkinInfoIn") then
                    self:RemoveTimer("PlaySkinInfoIn")
                end
                self:PlayAnimation(self.Video_In)
                if self:IsSkin() then
                    self:PlaySkinVideo()
                end
                AnimTime = self.Video_In:GetEndTime()
                self:AddTimer(self.UIDisplayTime, self.PlaySkinInfoIn,false,0,"PlaySkinInfoIn")
            else
                self:PlayAnimation(self.Skin_In)
                AnimTime = self.Skin_In:GetEndTime()
            end
        end
        if AnimTime then
            self:AddTimer(AnimTime, SetClick,false,0,"SetClick")
        end
    end
    self.Icon_Group:SetVisibility(ESlateVisibility.HitTestInvisible)
    if self:IsSkin() then
        self:UnbindAllFromAnimationFinished(self.Icon_In)
        self:PlayAnimation(self.Skin_Icon_In)
        AudioManager(self):PlayUISound(self, "event:/ui/common/gacha_get_skin", nil, nil)
        self:BindToAnimationFinished(self.Skin_Icon_In, {self, IconInFinish})
    elseif self:IsResource() then
        self.Icon_Group:SetVisibility(ESlateVisibility.Collapsed)
        IconInFinish()
    elseif self:IsChar() then
        self:UnbindAllFromAnimationFinished(self.Icon_In)
        self:PlayAnimation(self.Icon_In)
        AudioManager(self):PlayUISound(self, "event:/ui/common/gacha_get_role_pre_icon", nil, nil)
        self:BindToAnimationFinished(self.Icon_In, {self, IconInFinish})
    end
end

function M:PlayCampIn()
    if self.IsCampAnimation and self.CharCampUI then
        self.CharCampUI:PlayAnimation(self.CharCampUI.In)
    end
end

function M:PlayCharInfoIn()
    AudioManager(self):PlayUISound(self, "event:/ui/common/gacha_get_role_show_name", nil, nil)
end

function M:PlaySkinInfoIn()
    self.Group_SkinInfo:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Image_AvatarIcon:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self:PlayAnimation(self.SkinInfo_In)
    AudioManager(self):PlayUISound(self, "event:/ui/common/gacha_get_skin_show_name", nil, nil)
end

function M:RefreshInfoByInputTypeChange(CurInputType, CurGamepadName)
    if UIUtils.IsMobileInput() then return end
    if CurInputType == ECommonInputType.Gamepad then
        self:InitGamepadView()
    else
        self:InitKeyboardView()
    end
end

function M:InitGamepadView()
    self:SetFocus()
    if self.bSpaceBarSkip then
        if self.CantClick or self.bPlayVideo then
            self.Key_Tips:UpdateKeyInfo({
                {
                    KeyInfoList = {{Type = "Img", ImgShortPath = UIConst.GamePadImgKey.FaceButtonBottom}},
                    Desc = GText("UI_TALK_SKIP"),
                    bLongPress = true,
                },
            })
        else
            self.Key_Tips:UpdateKeyInfo({
                {
                    KeyInfoList = {{Type = "Img", ImgShortPath = UIConst.GamePadImgKey.FaceButtonRight}},
                    Desc = GText("UI_BACK"),
                },
            })
        end
    else
        self.Key_Tips:UpdateKeyInfo({
            {
                KeyInfoList = {{Type = "Img", ImgShortPath = UIConst.GamePadImgKey.FaceButtonRight}},
                Desc = GText("UI_BACK"),
            },
        })
    end
    self.Key_Tips:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    -- self.Text_Tip:SetVisibility(ESlateVisibility.Collapsed)
end

function M:InitKeyboardView()
    if UIUtils.IsMobileInput() then return end
    if self.bSpaceBarSkip then
        if self.CantClick or self.bPlayVideo then
            self.Key_Tips:UpdateKeyInfo({
                {
                    KeyInfoList = {{Type = "Text", Text = "SpaceBar",ClickCallback = self.OnBtnSkipClicked,Owner = self,}},
                    bLongPress = true,
                    Desc = GText("UI_TALK_SKIP"),
                },
            })
        else
            self.Key_Tips:UpdateKeyInfo({
                {
                    KeyInfoList = {{Type = "Text", Text = "Esc",ClickCallback = self.OnBtnFullCloseClicked,Owner = self,}},
                    Desc = GText("UI_BACK"),
                },
            })
        end
    else
        self.Key_Tips:UpdateKeyInfo({
            {
                KeyInfoList = {{Type = "Text", Text = "Esc",ClickCallback = self.OnBtnFullCloseClicked,Owner = self,}},
                Desc = GText("UI_BACK"),
            },
        })
        self.Key_Tips:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
    self.Key_Tips:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    -- self.Text_Tip:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    -- if self.CantClick then
    --     return UE4.UWidgetBlueprintLibrary.Handled()
    -- end
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local Reply,IsHandled = self:ProcessOnKeyDown(MyGeometry, InKeyEvent)
    if(IsHandled)then
        return Reply
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    if self.CantClick then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == UIConst.GamePadKey.FaceButtonBottom or InKeyName == UIConst.GamePadKey.FaceButtonRight) and not self.bPlayVideo then
        self:OnBtnFullCloseClicked()
    elseif InKeyName == "Escape" and not self.bPlayVideo then
        self:OnBtnFullCloseClicked()
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
    local Reply,IsHandled = self:ProcessOnKeyUp(MyGeometry, InKeyEvent)
    if(IsHandled)then
        return Reply
    end
    return UIUtils.Unhandled ,false
end

function M:OnSpaceBar_LongPressStart()
    if not self.bSpaceBarSkip then return end
    if not self.bCanSkip then return end
    local SpaceBarBtn = self.Key_Tips:GetComKeyById(1)
    if(SpaceBarBtn)then
        SpaceBarBtn:OnButtonPressed(false, true, 0, self:GetLongPressAnimationTime("SpaceBar"))
    end
end

function M:OnSpaceBar_LongPressCancel()
    if not self.bSpaceBarSkip then return end
    if not self.bCanSkip then return end
    local SpaceBarBtn = self.Key_Tips:GetComKeyById(1)
    if(SpaceBarBtn)then
        SpaceBarBtn:OnButtonReleased()
        SpaceBarBtn:StopAllAnimations()
        SpaceBarBtn:PlayAnimation(SpaceBarBtn.Normal)
    end
end

function M:OnSpaceBar_LongPressEnd()
    if not self.bSpaceBarSkip then return end
    if not self.bCanSkip then return end
    self:OnBtnSkipClicked()
end

function M:OnGamepad_FaceButton_Bottom_LongPressStart()
    if not self.bSpaceBarSkip then return end
    if not self.bCanSkip then return end
    local FaceButtonBottomBtn = self.Key_Tips:GetComKeyById(1)
    if(FaceButtonBottomBtn)then
        FaceButtonBottomBtn:OnButtonPressed(false, true, 0, self:GetLongPressAnimationTime("Gamepad_FaceButton_Bottom"))
    end
end

function M:OnGamepad_FaceButton_Bottom_LongPressCancel()
    if not self.bSpaceBarSkip then return end
    local FaceButtonBottomBtn = self.Key_Tips:GetComKeyById(1)
    if(FaceButtonBottomBtn)then
        FaceButtonBottomBtn:OnButtonReleased()
        FaceButtonBottomBtn:StopAllAnimations()
        FaceButtonBottomBtn:PlayAnimation(FaceButtonBottomBtn.Normal)
    end
end

function M:OnGamepad_FaceButton_Bottom_LongPressEnd()
    if not self.bSpaceBarSkip then return end
    self:OnBtnSkipClicked()
end

function M:OnBtnSkipClicked()
    if self.CantClick then return end
    local CommonDialogParams = {}
    CommonDialogParams.RightCallbackFunction = function() self:OnBtnSkipClicked() end
    UIManager(self):ShowCommonPopupUI(100253,CommonDialogParams)
end

function M:OnBtnFullCloseClicked()
    if self.CantClick then return end
    CommonUtils:CloseGuideTouchIfExist(self)
    AudioManager(self):StopSound(self, "ShowTarget")
    if self.CurShowIndex < self.ShowTimes then
        self:RefreshCommonShowUI()
    else
        self:StopCharVoice("GachaVoice")
        self:PlayOutAnim()
    end
end

function M:OnBtnSkipClicked()
    if self.bPlayVideo then
        self:OnBtnFullCloseClicked()
    else
        if not self.CantClick then return end
        if self.CharSpineUI and self.CharSpineUI.Spine_Char then
            self.CharSpineUI.Spine_Char:SetAnimation(0,"In",false)
            self.CharSpineUI.Spine_Char:AddAnimation(0,"Loop",true,0)
            self.CantClick = false
            if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
                self:InitGamepadView()
            else
                self:InitKeyboardView()
            end
            self:StopAnimation(self.In)
            self:PlayAnimation(self.Info_In)
        end
    end
end

function M:PlayOutAnim()
    self.CantClick = true
    self:UnbindAllFromAnimationFinished(self.Out)
    self:PlayAnimation(self.Out)
    self:BindToAnimationFinished(self.Out,{self,self.OnCloseCallback})
end

-- function M:PlayOutEndAnim()
--     self:UnbindAllFromAnimationFinished(self.Out_End)
--     self:PlayAnimation(self.Out_End)
--     self:BindToAnimationFinished(self.Out_End,{self,self.OnCloseCallback})
-- end

function M:OnCloseCallback()
    self.CantClick = false
    AudioManager(self):SetEventSoundParam(self, "GachaAmb", {ToEnd=1})
    self:Close()
    if self.Params.CallbackFunc then
        self.Params.CallbackFunc(self.Params.CallbackObj)
    end
end

-- 处理应用切后台事件
function M:OnApplicationWillEnterBackground()
    DebugPrint("JLY OnApplicationWillEnterBackground")
    
    -- 移除PlaySkinInfoIn定时器
    if self:IsExistTimer("PlaySkinInfoIn") then
        self:RemoveTimer("PlaySkinInfoIn")
        DebugPrint("JLY Removed PlaySkinInfoIn timer")
    end
    
    -- 保存当前播放状态
    if self.VideoPlayer and self.VideoPlayer:IsPlaying() then
        self.bWasPlayingBeforeBackground = true
        self.VideoPlayer:Pause()
        DebugPrint("JLY Paused video playback")
    else
        self.bWasPlayingBeforeBackground = false
    end

    self.Group_SkinInfo:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Image_AvatarIcon:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

-- 处理应用切前台事件
function M:OnApplicationHasEnteredForeground()
    DebugPrint("JLY OnApplicationHasEnteredForeground")
    
    if self.bWasPlayingBeforeBackground and self.VideoPlayer then
        -- 延时重新播放，确保系统资源已恢复
        self:AddTimer(0.5, function()
            if self.VideoPlayer and self.TargetId then
                -- 复用现有的播放函数
                if self:IsSkin() then
                    self:PlaySkinVideo()
                elseif self:IsResource() then
                    local ResourceInfo = DataMgr.Resource[self.TargetId]
                    if ResourceInfo and ResourceInfo.DisplayPath then
                        self:PlayResourceVideo(ResourceInfo.DisplayPath)
                    end
                end
                
                -- 重新添加PlaySkinInfoIn定时器
                if self.UIDisplayTime then
                    self:AddTimer(self.UIDisplayTime, self.PlaySkinInfoIn, false, 0, "PlaySkinInfoIn")
                    DebugPrint("JLY Re-added PlaySkinInfoIn timer")
                end
            end
        end, false, 0, "ResumeVideoPlayback")
    end
end

-- 析构函数，清理事件监听
function M:Destruct()
    EventManager:RemoveEvent(EventID.ApplicationWillEnterBackground, self)
    EventManager:RemoveEvent(EventID.ApplicationHasEnteredForeground, self)
    
    -- 清理状态
    self.bWasPlayingBeforeBackground = false
    
    self.Super.Destruct(self)
end

AssembleComponents(M)
return M