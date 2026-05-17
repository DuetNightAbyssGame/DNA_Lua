--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local GachaCommon = require "BluePrints.UI.WBP.Gacha.GachaCommon"
local GachaController = require "BluePrints.UI.WBP.Gacha.GachaController"
local GachaModel = require "BluePrints.UI.WBP.Gacha.GachaModel"
---@type WBP_Gacha_NormalDraw_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self:AddInputMethodChangedListen()
    self.Group_Share:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Btn_Back:SetText(GText('UI_BACK'))
    self.Btn_Back:BindEventOnClicked(self,self.PlayOutAnim)
    self.Btn_Back.SoundFunc = function ()
        AudioManager(self):PlayUISound(self, "event:/ui/common/click", nil, nil)
    end
    self.Btn_Back:SetDefaultGamePadImg(UIConst.GamePadImgKey.FaceButtonRight)
    self.Btn_Again:SetDefaultGamePadImg(UIConst.GamePadImgKey.FaceButtonTop)
    self.Btn_Again:SetGamePadIconVisible(true)

    self.Btn_Again:BindEventOnClicked(self, self.OnClickGachaAgain)
    self.Btn_Again.SoundFunc = function ()
        AudioManager(self):PlayUISound(self, "event:/ui/common/gacha_btn_click_normal", nil, nil)
    end
    self.Btn_Again:SetGamePadImg(UIConst.GamePadImgKey.FaceButtonTop)

    self.Btn_Share:BindEventOnClicked(self,self.OnBtnShareClicked)
    self.Btn_Share.SoundFunc = function ()
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    end

    self.Text_ExtrasTitle:SetText(GText("GACHA_BONUS"))
    self.Text_ItemTitle:SetText(GText("UI_Gacha_GetItem_Title"))

    self.Key_GamePad03:CreateGamepadKey(DataMgr.KeyboardText[UIConst.GamePadKey.SpecialRight].KeyText)
    self.KeyImg_GamePad:CreateGamepadKey(DataMgr.KeyboardText[UIConst.GamePadKey.RightThumb].KeyText)
    self.Key_GamePad02:CreateCommonKey({
        KeyInfoList = {
            {
                ImgShortPath = UIConst.GamePadImgKey.LeftThumb,
                Type = "Img",
            }
        },
        Desc = GText("UI_Controller_Check")
    })
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:Init(...)
    self.RewardLst, self.RebateData, self.GachaId, self.Parent, self.OnClosedFun = ...

    self.Parent.CantClick = false
    self.CantClick = false
    self.bSharePage = false
    self.RewardMap = {}
    for i, RewardData in ipairs(self.RewardLst) do
        if not self.RewardMap[GachaCommon.GachaItemTypeMap[RewardData.Sign]] then
            self.RewardMap[GachaCommon.GachaItemTypeMap[RewardData.Sign]] = {}
        end
        if self.RewardMap[GachaCommon.GachaItemTypeMap[RewardData.Sign]][RewardData.ResultId] then
            self.RewardMap[GachaCommon.GachaItemTypeMap[RewardData.Sign]][RewardData.ResultId] = self.RewardMap[GachaCommon.GachaItemTypeMap[RewardData.Sign]][RewardData.ResultId] + RewardData.Count
        else
            self.RewardMap[GachaCommon.GachaItemTypeMap[RewardData.Sign]][RewardData.ResultId] = RewardData.Count
        end
        RewardData.Index = i
    end
    table.sort(self.RewardLst, function(a, b)
        local TypeA = GachaCommon.GachaItemTypeMap[a.Sign]
        local TypeB = GachaCommon.GachaItemTypeMap[b.Sign]
        local DataA = DataMgr[TypeA][a.ResultId]
        local DataB = DataMgr[TypeB][b.ResultId]
        local RarityA = DataA.Rarity or DataA[TypeA.."Rarity"] or 0
        local RarityB = DataB.Rarity or DataB[TypeB.."Rarity"] or 0
        if RarityA == RarityB then
            return a.Index < b.Index
        end
        return RarityA > RarityB
    end)
    self.bSingle = #self.RewardLst == GachaCommon.GachaOneResult
    self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

    self.WS_Icon:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

    self:SetIsDealWithVirtualAccept(false)
    self:BlockAllUIInput(true,"SP_DisplayOnly")
    local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem(self)
    GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
    self.bHasSkin = false
    self.bHasPrism = false
    self:InitRewardList()
    self:RefreshResourceBar()
    self:RefreshGachaResInfo()
    if self.bHasSkin then
        AudioManager(self):PlayUISound(self, "event:/ui/common/gacha_get_sp_item", nil, nil)
    elseif self.bHasPrism then
        AudioManager(self):PlayUISound(self, "event:/ui/common/gacha_get_sp_prism", nil, nil)
    else
        AudioManager(self):PlayUISound(self, "event:/ui/common/gacha_result_show", nil, nil)
    end
    self:PlayAnimation(self.In)
    self:OnUpdateUIStyleByInputTypeChange(GameInputModeSubsystem:GetCurrentInputType(), GameInputModeSubsystem:GetCurrentGamepadName())
end

function M:InitRewardList()
    self:CleanTimer()
    self.HasExtraReward = false
    if not next(self.RebateData) then
        self.HB_Extras:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.HasExtraReward = true
        self.HB_Item1:SetVisibility(ESlateVisibility.Collapsed)
        self.HB_Item2:SetVisibility(ESlateVisibility.Collapsed)
        self.HB_Extras:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        local index = 1
        for ItemId, Num in pairs(self.RebateData) do
            if index > 2 then
                break
            end
            self["Item"..index]:Init(
                {
                    Id = ItemId,
                    Icon = LoadObject(DataMgr.Resource[ItemId].Icon),
                    ItemType = "Resource",
                    UIName = "GachaMain",
                    IsShowDetails = true,
                    MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight,
                }
            )
            self["Text_ItemNum"..index]:SetText("×"..Num)
            self["HB_Item"..index]:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            index = index + 1
        end
    end
    if self.RewardLst then
        if self.bSingle then
            self.Single_Item:SetVisibility(ESlateVisibility.Visible)
            self.WS_Item:SetActiveWidgetIndex(1)
            local Data = self.RewardLst[1]
            local ItemType = GachaCommon.GachaItemTypeMap[Data.Sign]
            local ItemData = DataMgr[ItemType][Data.ResultId]
            local bNew, bConvert = self:IsNewOrConvertItem(ItemType, Data.ResultId)
            assert(ItemData, "未找到该次抽卡奖励的信息:Id:"..Data.ResultId.." Type:"..ItemType)
            local Content = self:CreateItemContent(Data, ItemType, ItemData, bNew, bConvert,{bNeedFocus = true, Start = Data.Star})
            self.Single_Item:Init(Content)
            self.Btn_Again:SetText(GText('UI_SkinGacha_Again_One'))
        else
            self.WS_Item:SetActiveWidgetIndex(0)
            for i = 1, 10, 1 do
                self:AddTimer(self.IntervalTime * (i // 6), function()
                    local Data = self.RewardLst[i]
                    local ItemWidget = self["Item_"..i]
                    local ItemType = GachaCommon.GachaItemTypeMap[Data.Sign]
                    local ItemData = DataMgr[ItemType][Data.ResultId]
                    local bNew, bConvert = self:IsNewOrConvertItem(ItemType, Data.ResultId)
                    
                    assert(ItemData, "未找到该次抽卡奖励的信息:Id:"..Data.ResultId.." Type:"..ItemType)
                    
                    local Content = self:CreateItemContent(
                        Data,
                        ItemType,
                        ItemData,
                        bNew,
                        bConvert,
                        {
                            bNeedFocus = (i == 1),
                            DelayTime = self.IntervalTime * (1 - (i // 6))
                        }
                    )
                    ItemWidget:Init(Content)
                end)
            end
            self.Btn_Again:SetText(GText('UI_SkinGacha_Again_Ten'))
        end
    end
    self:AddTimer(0.01, function()
        self:SetPageFocus()
    end)
    local GachaInfo = DataMgr.SkinGacha[self.GachaId]
    if DataMgr.GachaProbability[GachaInfo.ProbabilityId].ShowGetStar5Times == nil or GachaInfo.GachaLimitIsShow then
        self.Text_RemainTimes:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        self.Text_RemainTimes:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            local AdditionalCount = GachaModel:GetSkinGachaAlreadyTimes(GachaInfo.GachaType)
            if AdditionalCount < DataMgr.GachaProbability[GachaInfo.ProbabilityId].ShowGetStar5Times then
                local RemainGachaTimes = math.floor(DataMgr.GachaProbability[GachaInfo.ProbabilityId].ShowGetStar5Times - AdditionalCount)
                local GuaranteeText = DataMgr.SkinGachaType[GachaInfo.GachaType].GachaGuaranteeDes
                if GachaInfo.RewardUpId then
                    local ItemId, ItemType = GachaModel:GetSkinGachaUpInfo(self.GachaId)
                    if ItemId then
                        local Name = ItemUtils.GetItemName(ItemId, ItemType)
                        self.Text_RemainTimes:SetText(string.format(GText(GuaranteeText), RemainGachaTimes, GText(Name)))
                    end
                else
                    self.Text_RemainTimes:SetText(string.format(GText(GuaranteeText), RemainGachaTimes))
                end
            end
        end
    end
    self.Group_SkinInfo:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self:SetGachaResBG(GachaInfo.Star5ItemId)
end

--- 创建道具内容对象
-- @param Data 奖励数据
-- @param ItemType 道具类型
-- @param ItemData 道具配置数据
-- @param bNew 是否新获得
-- @param bConvert 是否已转换
-- @param Options 可选参数表 {bNeedFocus, DelayTime, Start}
-- @return Content 内容对象
function M:CreateItemContent(Data, ItemType, ItemData, bNew, bConvert, Options)
    Options = Options or {}
    
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Id = Data.ResultId
    Content.Icon = ItemUtils.GetItemIconPath(Data.ResultId, ItemType)
    Content.Count = Data.Count
    Content.ParentWidget = self
    Content.ItemType = ItemType
    Content.Rarity = ItemData.Rarity or ItemData[ItemType.."Rarity"] or 1
    Content.bNew = bNew
    Content.bDisableCommonClick = bConvert
    Content.IsShowDetails = not bConvert
    Content.bConvert = bConvert
    
    if bConvert then
        Content.NotInteractive = true
    end
    
    -- 可选参数
    Content.bNeedFocus = Options.bNeedFocus or false
    Content.DelayTime = Options.DelayTime
    Content.Start = Options.Start
    
    return Content
end

function M:IsNewOrConvertItem(Type, Id)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local Count = AvatarUtils:GetTargetDataStatistics(Avatar,Type,Id)
    local ItemData = DataMgr[Type][Id]
    assert(ItemData, "抽卡结果道具不存在：Type:"..Type.." Id:"..Id)
    if self.RewardMap[Type][Id] == Count then
        self.RewardMap[Type][Id] = -1
        return true, false
    elseif ItemData.RegainItemId then
        return false, true
    end
    return false, false
end

function M:RefreshResourceBar()
    local GachaData = DataMgr.SkinGacha[self.GachaId]
    local ItemIdLst = {}

    if GachaData.DisplayCostRes then
        for _,ResourceId in ipairs(GachaData.DisplayCostRes) do
            table.insert(ItemIdLst, ResourceId)
        end
    end
    self.HB_ResourceBar:ClearChildren()
    local ItemList = {}
    for i, CoinId in ipairs(ItemIdLst) do
        local ResourceBarWidget = self:CreateWidgetNew('ResourceBar', false)
        local CoinIcon = LoadObject(DataMgr.Resource[CoinId].Icon)
        ResourceBarWidget.Common_Item_Icon:Init({
            UIName = "GachaMain",
            IsShowDetails = true,
            IsCantItemSelection = true,
            MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight,
            Id = CoinId,
            Icon = CoinIcon,
            ItemType = "Resource",
            HandleMouseDown = true
        })
        ItemList[i] = ResourceBarWidget
        ResourceBarWidget:SetItemId(CoinId)
        self.HB_ResourceBar:AddChild(ResourceBarWidget)
        ResourceBarWidget:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
        ResourceBarWidget:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    end
    for Index, ItemUI in pairs(ItemList) do
        if Index + 1 <= #ItemList then
            ItemUI:SetNavigationRuleExplicit(EUINavigation.Right, ItemList[Index + 1])
        end
        if Index - 1 > 0 then
            ItemUI:SetNavigationRuleExplicit(EUINavigation.Left, ItemList[Index - 1])
        end
    end
end

function M:RefreshGachaResInfo()
    local GachaData = DataMgr.SkinGacha[self.GachaId]
    local GachaTimes = 0
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    local ShowResourceId --常规抽卡道具
    local ShowResourceCount = 0 --常规抽卡道具数量
    local TimeLimitResourceId --限时抽卡道具
    local TimeLimitResourceCount = 0 --限时抽卡道具数量
    for _, ResourceId in ipairs(GachaData.GachaCostRes) do
        if ItemUtils.GetItemLimitedInfo(ResourceId) then
            TimeLimitResourceId = ResourceId
            TimeLimitResourceCount = Avatar:GetResourceNum(TimeLimitResourceId)
        else
            ShowResourceId = ResourceId
            ShowResourceCount = Avatar:GetResourceNum(ShowResourceId)
        end
    end

    if self.bSingle then
        GachaModel:UpdateGachaBtnPrice(self.Btn_Again, GachaData.GachaTimes, TimeLimitResourceCount, ShowResourceId, TimeLimitResourceId)
    else
        if TimeLimitResourceCount >= GachaData.GachaCostNum10 then
            GachaModel:UpdateGachaBtnPrice(self.Btn_Again, GachaData.GachaCostNum10, TimeLimitResourceCount, ShowResourceId, TimeLimitResourceId)
        elseif (TimeLimitResourceCount > 0) and (TimeLimitResourceCount + ShowResourceCount >= GachaData.GachaCostNum10) then
            GachaModel:UpdateGachaBtnComplex(self.Btn_Again, GachaData.GachaCostNum10, TimeLimitResourceCount, ShowResourceCount, ShowResourceId, TimeLimitResourceId)
        else
            GachaModel:UpdateGachaBtnPrice(self.Btn_Again, GachaData.GachaCostNum10, TimeLimitResourceCount, ShowResourceId, TimeLimitResourceId)
        end
    end
end

function M:OnClickGachaAgain()
    if self.Parent.bGachaing or self.Parent.CantClick or self.CantClick then return end
    if self:IsAnimationPlaying(self.In) or self:IsAnimationPlaying(self.Out) then
        return
    end
    local Ret = GachaController:TryGacha(self.GachaId, self.bSingle)
    if Ret == 1 then
        self.Parent:PurchaseGachaResource(self.bSingle, true)
        return
    end
    self.Parent.bGachaing = true
    self:PlayOutAnim()
end

function M:OnBtnShareClicked()
    if self:IsAnimationPlaying(self.In) or self:IsAnimationPlaying(self.Out) or self.Parent.bGachaing or self.CantClick then
        return
    end
    self.Group_Top:SetVisibility(UE4.ESlateVisibility.Hidden)
    self.Down_Info:SetVisibility(UE4.ESlateVisibility.Hidden)
    local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem(self)
    GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
    self.bSharePage = true
    self.CantClick = true
    self:AddTimer(0.033, function() --折叠按钮后需要延迟一帧再截图
        self.Parent:TakeGachaScreenShot(self,self.OnShareCallback)
    end)
end

function M:OnShareCallback()
    self.bSharePage = false
    self:SetPageFocus()
    self.CantClick = false
    self.Group_Top:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Down_Info:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad and self.CanFocusChangeItem then
        -- self.Key_GamePad01:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- end
    local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem(self)
    GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    if not self:Isvisible() then
        return
    end
    if CurInputType == UE4.ECommonInputType.Gamepad then
        self.Key_GamePad03:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.KeyImg_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Key_GamePad02:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self:SetPageFocus()
    else
        self.Key_GamePad03:SetVisibility(ESlateVisibility.Collapsed)
        self.KeyImg_GamePad:SetVisibility(ESlateVisibility.Collapsed)
        self.Key_GamePad02:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:SetPageFocus()
    if self.Parent.bNeedUpdate then
        return
    end
    if self.bSharePage then
        self.Parent.GachaScreenShotWidget:SetFocus()
        return
    end
    if self.bSingle then
        self.Single_Item:SetFocus()
    else
        self.Item_1:SetFocus()
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    if self.Parent.bNeedUpdate then
        return
    end
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadDown(InKeyName)
    else
        if InKeyName == "Escape" then
            if not self.Parent.bGachaing and not self.Parent.CantClick then
                IsEventHandled = true
                self:PlayOutAnim()
            end
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

function M:OnGamePadDown(InKeyName)
    local IsEventHandled = false
    if InKeyName == UIConst.GamePadKey.FaceButtonTop then
        IsEventHandled = true
        self:OnClickGachaAgain()
    elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
        if self.bFocusOnExtraReward or self.bFocusOnResourceBar then
            self.bFocusOnExtraReward = false
            self.bFocusOnResourceBar = false
            self:SetPageFocus()
        else
            self:PlayOutAnim()
        end
        IsEventHandled = true
    elseif InKeyName == UIConst.GamePadKey.SpecialRight then
        IsEventHandled = true
        self:OnBtnShareClicked()
    elseif InKeyName == UIConst.GamePadKey.RightThumb then
        if self.HB_ResourceBar:GetChildAt(0) then
            self.bFocusOnResourceBar = true
            self.HB_ResourceBar:GetChildAt(0):SetFocus()
        end
    elseif InKeyName == UIConst.GamePadKey.LeftThumb then
        if self.HasExtraReward then
            self.bFocusOnExtraReward = true
            self.Item1:SetFocus()
        end
    end
    return IsEventHandled
end


function M:PlayOutAnim()
    if self:IsAnimationPlaying(self.Out) then
        return
    end
    self:BlockAllUIInput(true,"SP_DisplayOnly")
    if self.OnClosedFun then
        self.OnClosedFun(self.Parent)
    end
    if self.Parent then
        self.Parent.CantClick = false
        self.Parent.bGachaRes = false
    end
    AudioManager(self):SetEventSoundParam(self.Parent, "GachaAmb", {ToEnd=1})
    self:PlayAnimation(self.Out)
end

function M:OnAnimationFinished(InAnim)
    if InAnim == self.Out then
        self:CloseSelf()
    elseif InAnim == self.In then
        local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem(self)
        GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
        self:BlockAllUIInput(false)
    end
end

function M:CloseSelf()
    self:BlockAllUIInput(false)
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

--- 加载Avatar spine蓝图（抽卡专用）
function M:LoadAvatarSpineWidget()
    local ShowSkinData = DataMgr[self.ShowSkinType][self.ShowSkinId]
    local SkinName = ShowSkinData.Name or ShowSkinData.SkinName
    self.Text_SkinName:SetText(GText(SkinName))
    self.Com_QualityTag:Init(ShowSkinData.Rarity)
    self:UpdateSkinNameStyleByRarity(ShowSkinData.Rarity)
    self.Group_SkinInfo:SetVisibility(ESlateVisibility.SelfHitTestInvisible)

    if self.ShowSkinType == "WeaponSkin" then
        local IconObj = LoadObject(ShowSkinData.BigIcon)
        self.WS_Icon:SetActiveWidgetIndex(1)
        self.Image_WeaponIcon:SetBrushResourceObject(IconObj)
        return
    end
    -- 根据当前卡池配置加载对应的spine蓝图
    -- 目前有两个资产：WidgetShuimu01 和 WidgetSonglu01

    local AvatarWidgetPath = ShowSkinData and ShowSkinData.SkinSpine

    self.Avatar:ClearChildren()
    self.WS_Icon:SetActiveWidgetIndex(0)
    if AvatarWidgetPath then
        -- 加载新的spine蓝图
        local AvatarWidget = UIManager(self):CreateWidget(AvatarWidgetPath, false)
        if AvatarWidget and AvatarWidget.In then
            AvatarWidget:PlayAnimation(AvatarWidget.In)
        end
        if AvatarWidget and AvatarWidget.Loop then
            AvatarWidget:PlayAnimation(AvatarWidget.Loop, 0, 0)
        end
        local Slot = self.Avatar:AddChild(AvatarWidget)
        if Slot then
            Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
            Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
        end
    end
end

--- 根据品质更新皮肤名称样式（参考Com_QualityTag:SetRarity的实现方式）
function M:UpdateSkinNameStyleByRarity(Rarity)
    if not self.Text_SkinName then
        return
    end
    
    if not Rarity or Rarity < 1 or Rarity > 6 then
        DebugPrint("UpdateSkinNameStyleByRarity: Invalid Rarity")
        return
    end
    
    local FontColor = nil
    local Font = nil
    local ImageLight = nil
    if Rarity == 6 then
        FontColor = self.Com_QualityTag.FontColor_Red
        Font = self.Com_QualityTag.Font_Red
        ImageLight = self.Light_Red
    elseif Rarity == 5 then
        FontColor = self.Com_QualityTag.FontColor_Gold
        Font = self.Com_QualityTag.Font_Gold
        ImageLight = self.Light_Gold
    elseif Rarity == 4 then
        FontColor = self.Com_QualityTag.FontColor_Purple
        Font = self.Com_QualityTag.Font_Purple
        ImageLight = self.Light_Purple
    elseif Rarity == 3 then
        FontColor = self.Com_QualityTag.FontColor_Blue
        Font = self.Com_QualityTag.Font_Blue
        ImageLight = self.Light_Blue
    end
    
    -- 设置字体和颜色（与Com_QualityTag的Text_Tag设置方式一致）
    if Font then
        self.Text_SkinName:SetFont(Font)
    end
    if FontColor then
        self.Text_SkinName:SetColorAndOpacity(FontColor)
    end
    if ImageLight then
        self.Img_TryOutBG:SetColorAndOpacity(ImageLight)
    end
end

--- 更新Btn_Again按钮的货币图标（通过Common_Item_Subsize_Icon_C脚本的方式）
function M:UpdateBtnAgainIcon(ResourceId, CostNum)
    if not self.Btn_Again or not ResourceId then
        return
    end
    
    -- 如果Btn_Again有Icon_Currency子控件
    if self.Btn_Again.Icon_Currency then
        local IconPath = ItemUtils.GetItemIconPath(ResourceId, "Resource")
        if IconPath then
            self.Btn_Again.Icon_Currency.Icon = IconPath
            self.Btn_Again.Icon_Currency:SetIcon()
        end
    end

    if self.Btn_Again.Text_Price then
        self.Btn_Again.Text_Price:SetText(tostring(CostNum))
    end
end

function M:SetGachaResBG()
    local BgPath = GachaCommon.BgWidget[1]
    local Seq = 0
    for i, RewardData in ipairs(self.RewardLst) do
        if GachaCommon.GachaItemTypeMap[RewardData.Sign] == "Skin" or GachaCommon.GachaItemTypeMap[RewardData.Sign] == "WeaponSkin" then
            self.ShowSkinId = RewardData.ResultId
            self.ShowSkinType = GachaCommon.GachaItemTypeMap[RewardData.Sign]
            self:LoadAvatarSpineWidget()
            self.bHasSkin = true
            return
        elseif DataMgr.HighLightResult2Item[RewardData.Sign] and DataMgr.HighLightResult2Item[RewardData.Sign][RewardData.ResultId] and
        DataMgr.HighLightResult2Item[RewardData.Sign][RewardData.ResultId][RewardData.Count] then
            if DataMgr.HighLightResult2Item[RewardData.Sign][RewardData.ResultId][RewardData.Count].Seq > Seq then
                BgPath = DataMgr.HighLightResult2Item[RewardData.Sign][RewardData.ResultId][RewardData.Count].Path
                Seq = DataMgr.HighLightResult2Item[RewardData.Sign][RewardData.ResultId][RewardData.Count].Seq
                self.bHasPrism = true
            end
        end
    end
    self.WS_Icon:SetActiveWidgetIndex(2)
    self.Icon:ClearChildren()
    local SubWidget = UIManager(self):CreateWidget(BgPath, false)
    if SubWidget and SubWidget.In then
        SubWidget:PlayAnimation(SubWidget.In)
    end
    if SubWidget and SubWidget.Loop then
        SubWidget:PlayAnimation(SubWidget.Loop, 0, 0)
    end
    SubWidget:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    local Slot = self.Icon:AddChild(SubWidget)
    if Slot then
        Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
        Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
    end
end

return M
