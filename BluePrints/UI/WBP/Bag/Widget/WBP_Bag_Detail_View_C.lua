--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local SkillUtils = require "Utils.SkillUtils"
local TimeUtils = require "Utils.TimeUtils"
local CommonUtils = require "Utils.CommonUtils"
local BagCommon = require "BluePrints.UI.WBP.Bag.BagCommon"
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
local WBP_Bag_Detail_View_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_Bag_Detail_View_C:Initialize(Initializer)
    self.Super.Initialize(self)
    --属性排序类型
    self.SortIndexes = {["Melee"] = 2, ["Ranged"] = 3,}
    self.StuffType = nil
    self.StuffId = nil
    self.StuffUuid = nil
    self.StuffCount = nil
    self.IsCanLocked = false
    self.OwnerContent = nil
    self.CurSingleBtnRTNodeName = nil
    self.ParentWidget = nil
end

function WBP_Bag_Detail_View_C:Construct()
    self.Super.Construct(self)
    self.Key_Lock:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "Menu",
            },
        },
    }) 
    self.Key_Method:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "View",
            },
        },
    }) 
end

function WBP_Bag_Detail_View_C:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    self.OwnerContent, self.CloseCallback, self.ParentWidget = ...
    self:InitCommonInfo()
    self:RefreshInfoById()
end

function WBP_Bag_Detail_View_C:InitCommonInfo()
    -- self.Btn01:BindEventOnClicked(self, self.OnClickGoToAmory)
    self.Btn01:SetText(GText("UI_BAG_Gotoarmory"))
    self.Btn01:SetGamePadImg("Y")
    self.Text_WeaponLevel01:SetText(GText("UI_LEVEL_NAME"))
end

function WBP_Bag_Detail_View_C:RefreshInfoById()
    local PlayerAvatar = GWorld:GetAvatar()
    if (PlayerAvatar == nil) then
        print(_G.LogTag, "Avatar is nil, Not Connect to Server")
        return
    end
    self.StuffType = self.OwnerContent.Type or self.OwnerContent.StuffType
    self.StuffId = self.OwnerContent.StuffId
    self.StuffUuid = self.OwnerContent.Uuid
    self.StuffCount = self.OwnerContent.Count
    local PlayerStuffs, StuffServerData = nil, nil
    if (self.StuffType == "Weapon") then
        PlayerStuffs = PlayerAvatar.Weapons
    elseif (self.StuffType == "Mod") then
        PlayerStuffs = PlayerAvatar.Mods
    elseif (self.StuffType == "Resource") then
        PlayerStuffs = PlayerAvatar.Resources
    else
        PlayerStuffs = PlayerAvatar.Resources
    end
    local StuffUnitId = self:GetStuffObjId(self.StuffUuid)
    StuffServerData = PlayerAvatar.Resources[StuffUnitId]
    if (StuffServerData ~= nil) then
        self:RefreshDetailInfo(StuffServerData, StuffServerData:Data()) 
    end
end

function WBP_Bag_Detail_View_C:RefreshInfoByData(StuffContent, StuffServerData, StuffConfigData, ParentWidget, Animation)
    -- 通用信息设置
    self.IsCanLocked = false
    self.StuffType = StuffContent.Type or StuffContent.StuffType
    self.StuffId = StuffContent.StuffId
    self.StuffUuid = StuffContent.Uuid
    self.OwnerContent = StuffContent
    self.ParentWidget = ParentWidget
    self:RefreshDetailInfo(StuffServerData, StuffConfigData, Animation)
end

function WBP_Bag_Detail_View_C:RefreshDetailInfo(StuffServerData, StuffConfigData, Animation)
    local PlayerAvatar = GWorld:GetAvatar()
    if (self.ParentWidget ~= nil) then
        if (self.StuffType == BagCommon.StuffType.Mod and StuffServerData ~= nil and StuffServerData.IsOriginal) then
            self.Btn_Locked:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.Key_Lock:SetVisibility(UIConst.VisibilityOp.Collapsed)
        elseif (self.StuffType == BagCommon.StuffType.Resource and StuffConfigData.Type == "Read") then
            self.Btn_Locked:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.Key_Lock:SetVisibility(UIConst.VisibilityOp.Collapsed)
        elseif (self.StuffType == BagCommon.StuffType.Draft) then
            self.Btn_Locked:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.Key_Lock:SetVisibility(UIConst.VisibilityOp.Collapsed)
        elseif (self.OwnerContent ~= nil and self.OwnerContent.Price == -1) then
            self.Btn_Locked:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.Key_Lock:SetVisibility(UIConst.VisibilityOp.Collapsed)
        else
            local IsLocked = false
            if BagCommon:IsFishResource(StuffServerData.ResourceId) then
                IsLocked = BagCommon:IsFishResourceLocked(StuffServerData.ResourceId, StuffServerData.FishInfo.Size)
            else
                IsLocked = (StuffServerData.IsLock and StuffServerData:IsLock())
            end
            self.Switcher_Lock:SetActiveWidgetIndex(IsLocked and 0 or 1)
            self.IsCanLocked = true
            if (self.ParentWidget.BagCurState == BagCommon.AllBagState.ChooseSaleState or 
                    self.ParentWidget.BagCurState == BagCommon.AllBagState.WeaponResolveState) then
                self.Btn_Locked:SetVisibility(UE4.ESlateVisibility.Collapsed)
                self.Key_Lock:SetVisibility(UIConst.VisibilityOp.Collapsed)
            else
                self.Btn_Locked:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible) 
                if (self.ParentWidget.GameInputModeSubsystem and self.ParentWidget.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad) then
                    self.Key_Lock:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
                else
                    self.Key_Lock:SetVisibility(UIConst.VisibilityOp.Collapsed)
                end
            end
        end 
    end

    -- local RarityLinearColor = UE4.UUIFunctionLibrary.StringToLinearColor(UIConst.RarityColor[self.OwnerContent.Rarity])
    -- local RaritySlateColor = UE4.UUIFunctionLibrary.StringToSlateColor(UIConst.RarityColor[self.OwnerContent.Rarity])
    -- self.Bg_Quality:SetColorAndOpacity(RarityLinearColor)
    -- self.Text_ItemName:SetColorAndOpacity(RaritySlateColor)

    local FontMaterial = self.Text_ItemName:GetDynamicFontMaterial()
    local StuffRarity = self.OwnerContent.Rarity
    if FontMaterial then
        if StuffRarity == 6 then
            FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_6)
        elseif StuffRarity == 5 then
            FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_5)
        elseif StuffRarity == 4 then
            FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_4)
        elseif StuffRarity == 3 then
            FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_3)
        elseif StuffRarity == 2 then
            FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_2)
        elseif StuffRarity == 1 then
            FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_1)
        else
            FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_0)
        end
    end
    -- 设置Icon内容(复用道具框)
    local ItemObject = {
        UnitId = self.OwnerContent.UnitId,
        ItemType = self.OwnerContent.ItemType,
        Rarity = self.OwnerContent.Rarity,
        Icon = self.OwnerContent.Icon,
    }
    self.Item:Init(ItemObject)
    self.Item:HideNotNeccessaryWidget(true)
    self.Item:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)

    if (self.StuffType == BagCommon.StuffType.Mod and self.OwnerContent ~= nil) then
        self:UpdateStarStyle(self.OwnerContent.Level)
        self.Star:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Star:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    -- 刷新前隐藏鱼类独有的尺寸控件
    self.Panel_Fish:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- 根据物品类型刷新面板
    if (type(self["RefreshInfoWith"..self.StuffType]) == "function") then
        self["RefreshInfoWith"..self.StuffType](self, PlayerAvatar, StuffServerData, StuffConfigData) 
    else
        self:RefreshInfoWithOther(StuffConfigData)
    end
    -- 获取途径
    self:RefreshAccessMethod(StuffConfigData)
    -- 刷新一下定制化需求
    self:RefreshDesignView()

    if (type(Animation) == "string") then
        Animation = self[Animation] 
    else
        Animation = self.Refresh
    end
    self:PlayAnimationForward(Animation) 
end

function WBP_Bag_Detail_View_C:RefreshDesignView()
    if (self.Panel_Equipped:IsVisible() and self.Panel_Equipped:IsVisible()) then
        self.Switch_Bg:SetActiveWidgetIndex(1)
    else
        self.Switch_Bg:SetActiveWidgetIndex(0) 
    end

    if (self.Panel_Button:IsVisible()) then
        self.Switch_LineBg:SetActiveWidgetIndex(0)
    else
        self.Switch_LineBg:SetActiveWidgetIndex(1)
    end
end

function WBP_Bag_Detail_View_C:RefreshInfoWithWeapon(PlayerAvatar, StuffServerData, StuffConfigData)
    -- 武器相关(从上到下设置数据)
    self.Text_Mod:SetText(GText("UI_Bag_MODSapacity"))
    self.Text_WeaponCardLevel:SetText(GText("UI_WeaponStrength_Name"))
    local GradeLevel = StuffServerData.GradeLevel
    self.Text_WeaponCardLevel_Num:SetText(GradeLevel)

    local WeaponCardLevelData = DataMgr.WeaponCardLevel[StuffServerData.WeaponId]
    local MaxGradeLevel = WeaponCardLevelData and WeaponCardLevelData.CardLevelMax or (GradeLevel + 1)
    if(GradeLevel >= MaxGradeLevel)then
        self:SetMaxGradeLevelColor()
    else
        self:SetNormalGradeLevelColor()
    end
    self.Polarity_1:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    local Cost = StuffServerData:GetModSuitCost()
    self.Text_Mod01:SetText(tostring(Cost))
    self.Text_Mod02:SetText(tostring(StuffServerData:LevelUpData().ModVolume))
    self.Swtich01:SetActiveWidgetIndex(0)
    self.Swtich01:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

    local StuffLevel = StuffServerData.Level or 1
    self.Text_ItemName:SetText(GText(StuffConfigData.WeaponName))
    self.Text_WeaponLevel02:SetText(tostring(StuffLevel))
    self.Text_WeaponLevel03:SetText(tostring(StuffServerData:GetCurrentMaxLevel()))
    self.Swtich02:SetActiveWidgetIndex(0)
    local WeaponBattleData = StuffServerData:BattleData()

    local WeaponTypeName = self:GetWeaponTypeName(WeaponBattleData.WeaponId)
    self.Text_SubTitle:SetText(WeaponTypeName)
    self.Text_SubTitle:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

    if (StuffConfigData.WeaponDescribe ~= nil) then
        self.Text_LongDescribe:SetText(GText(StuffConfigData.WeaponDescribe))
        self.Panel_LongDescribe:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Panel_LongDescribe:SetVisibility(UE4.ESlateVisibility.Collapsed) 
    end
    -- 描述介绍
    local WeaponTag = StuffServerData:HasTag("Melee") and "Melee" or "Ranged"
    self:UpdateAttrInfo("Weapon", StuffServerData,WeaponTag, self.SortIndexes[WeaponTag])
    local PassiveSkillDesc = SkillUtils.CalcWeaponPassiveEffectsDesc(StuffServerData)
    if (PassiveSkillDesc ~= nil and PassiveSkillDesc ~= "") then
        self.Text_SkillName:SetText(GText("UI_Bag_Passive"))
        self.Text_SkillEffect:SetText(PassiveSkillDesc)
        self.Panel_Skill:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Panel_Skill:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self.Panel_Property:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

    -- 隐藏不需要显示的模块
    self.Panel_Draft:SetVisibility(UE4.ESlateVisibility.Collapsed) 
    self.Panel_TimeLimit:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_Describe:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_Effect:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_Tag:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Panel_MountHint:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.List_ModStar:SetVisibility(UIConst.VisibilityOp.Collapsed)
    -- 武器属性图标去除
    self.Img_Attribute:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- 只在Mod上需要
    self.Img_Aura:SetVisibility(UE4.ESlateVisibility.Collapsed)

    local OwnerStuffUuid = self:GetStuffObjId(self.OwnerContent.Uuid)
    if (OwnerStuffUuid == PlayerAvatar.MeleeWeapon or OwnerStuffUuid == PlayerAvatar.RangedWeapon) then
        -- 已装备的武器
        self.Text_Equipped:SetText(GText("UI_Bag_Equipped"))
        self.Panel_Equipped:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Panel_Equipped:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function WBP_Bag_Detail_View_C:RefreshInfoWithMod(PlayerAvatar, StuffServerData, StuffConfigData)
    -- Mod相关
    self.Text_ItemName:SetText(StuffServerData:GetName(ModInfo))
    local StuffLevel = StuffServerData.Level or 1
    -- local ModLevelConfig = StuffServerData:LevelData()
    self.Text_Polarity01:SetText(GText(StuffConfigData.FunctionDes))
    self.Text_Polarity02:SetText(tostring(StuffServerData.Cost))
    if (StuffServerData.Polarity~=CommonConst.NonePolarity) then
        local PolarityText = ModController:GetModel():GetPolarityText(StuffServerData.Polarity)
        self.Text_Polarity:SetText(PolarityText)
        self.Text_Polarity:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Text_Polarity:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self.Text_Level:SetText(tostring(StuffLevel))
    self.Text_MaxLevel:SetText(tostring(StuffServerData.MaxLevel))
    self.Swtich01:SetActiveWidgetIndex(1)
    self.Swtich01:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    ---适用类型
    local AppTypeTexts = {}
    for i ,TagText in ipairs(DataMgr.ModTag[StuffServerData.ApplicationType].ModTagText) do
        table.insert(AppTypeTexts,GText(TagText))
    end
    if (#AppTypeTexts > 0) then
        local AppTypeTexts = {}
        for i ,TagText in ipairs(DataMgr.ModTag[StuffServerData.ApplicationType].ModTagText) do
            table.insert(AppTypeTexts,GText(TagText))
        end
        local AppTypeText = GText("UI_Tips_ModApplicationType")..table.concat(AppTypeTexts,", ")
        self.Text_Tag:SetText(AppTypeText)
        self.Panel_Tag:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Panel_Tag:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end

    -- Mod光环
    local ApplySlot = StuffServerData.ApplySlot
    if ApplySlot and #ApplySlot == 1 and table.findValue(ApplySlot, 9) then
        self.Img_Aura:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Img_Aura:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    self.EffectDetails:ClearChildren()
    local ModAttrs = StuffConfigData.AddAttrs
    if ModAttrs then
        self:UpdateAttrInfo("Mod", StuffServerData, ModAttrs,StuffConfigData.Id)
        self.Panel_Effect:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    if (StuffConfigData.PassiveEffectsDesc) then
        local PassiveEffectDesc = ArmoryUtils:GenModPassiveEffectDesc(StuffConfigData, StuffServerData.Level)
        local EffectDescribeObj = self:CreateEffectDescribeItem({IsAddAttr=false, ModAttrDescribe=PassiveEffectDesc}, "Effect")
        self.EffectDetails:AddChildToWrapBox(EffectDescribeObj)
    end
    if (StuffConfigData.ModDescribe ~= nil) then
        self.Text_LongDescribe:SetText(GText(StuffConfigData.ModDescribe)) 
        self.Panel_LongDescribe:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Panel_LongDescribe:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self.Text_Hold01:SetText(GText("UI_Bag_Sellconfirm_Hold"))
    self.Text_Hold02:SetText(Utils.FormatNumber(StuffServerData.Count, true))
    self.Swtich02:SetActiveWidgetIndex(1)

    -- 隐藏不需要显示的模块
    self.Panel_TimeLimit:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Text_SubTitle:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_Draft:SetVisibility(UE4.ESlateVisibility.Collapsed) 
    self.Panel_Describe:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_Skill:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_Property:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_MountHint:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Img_Attribute:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if ((StuffServerData.WeaponUuids:Length() > 0 or StuffServerData.CharUuids:Length() > 0)) then
        -- 已装备的Mod
        self.Text_Equipped:SetText(GText("UI_Bag_Equipped"))
        self.Panel_Equipped:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Panel_Equipped:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self.Polarity_1:SetVisibility(UIConst.VisibilityOp.Collapsed)

    --- Mod星级
    self.List_ModStar:SetVisibility(UIConst.VisibilityOp.Collapsed)
    if StuffServerData:HasCardLevel() then
        self.List_ModStar:SetVisibility(UIConst.VisibilityOp.Visible)
        self.List_ModStar:ClearListItems()
        for i=1, (StuffServerData.ModCardLevelMax) do
            local StarContent = NewObject(UIUtils.GetCommonItemContentClass())
            StarContent.Idx = i
            StarContent.bActivate = i<= StuffServerData.CurrentModCardLevel
            StarContent.bGolden = false
            self.List_ModStar:AddItem(StarContent)
        end
    end
end

function WBP_Bag_Detail_View_C:RefreshInfoWithResource(PlayerAvatar, StuffServerData, StuffConfigData)
    -- Items相关
    self.Text_ItemName:SetText(GText(StuffConfigData.ResourceName))
    if(StuffConfigData.MaterialClassify)then
        self.Text_SubTitle:SetText(GText(StuffConfigData.FunctionDes))
        self.Text_SubTitle:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    -- 描述介绍
    self.Text_Hold01:SetText(GText("UI_Bag_Sellconfirm_Hold"))

    -- 钓鱼相关道具
    if (StuffConfigData.Type == "Ordinary" and StuffConfigData.ResourceSType == "Fish") then
        self.Text_FishWeight:SetText(GText("UI_Bag_Fish_Weight"))
        local StuffUnitIdList = Split(self.StuffUuid, "_")
        local FishWeight = 1
        if (StuffUnitIdList[2]) then
            FishWeight = math.tointeger(StuffUnitIdList[2]) / CommonConst.FishSizeScale
        end
        self.Num_FishWeight:SetText(string.format("%.1f cm", FishWeight))
        self.Text_Hold02:SetText(Utils.FormatNumber(self.OwnerContent.Count, true))
        self.Panel_Fish:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Text_Hold02:SetText(Utils.FormatNumber(StuffServerData.Count, true))
    end

    self.Swtich02:SetActiveWidgetIndex(1)
    if (StuffConfigData.DetailDes ~= nil) then
        self.Text_Describe:SetText(GText(StuffConfigData.DetailDes))
        self.Panel_Describe:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible) 
    else
        self.Panel_Describe:SetVisibility(UE4.ESlateVisibility.Collapsed) 
    end
    if (StuffConfigData.IpDes and StuffConfigData.Type ~= "Read") then
        self.Text_LongDescribe:SetText(GText(StuffConfigData.IpDes))
        self.Panel_LongDescribe:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Panel_LongDescribe:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    if (DataMgr.LimitedTimeResource[StuffConfigData.ResourceId]) then
        local LimitedData = ItemUtils.GetItemLimitedInfo(StuffConfigData.ResourceId)
        if LimitedData then
            local diff = os.difftime(LimitedData.EndTime.GetTime(), TimeUtils.NowTime())
            if diff < (60 * 60 * 24)  then
                self.BG_TimeLimit:SetColorAndOpacity(self.Color_Red)
            else
                self.BG_TimeLimit:SetColorAndOpacity(self.Color_Orange)
            end
            self.Panel_TimeLimit:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(LimitedData.EndTime.GetTime(), TimeUtils.NowTime())
            self.Time_CountDown:SetTimeText(nil, RemainTimeDict)
            self.Text_Expiration:SetText(GText("UI_Date_End"))
            self.Time_Expiration:SetTimeText(LimitedData.EndTime.GetTime(), UIConst.EnumTimeStyleType.YMDAndHMS)
        else
            self.Panel_TimeLimit:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    else
        self.Panel_TimeLimit:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    -- 坐骑道具相关提示
    if (StuffConfigData.ResourceSType == "MountItem") then
        local MountItemVarData = StuffConfigData.FunctionVars
        if (MountItemVarData) then
            local MountInfo = DataMgr.Mount[MountItemVarData.Id]
            if (MountInfo and MountInfo.UseLimitDes) then
                self.Text_MountHint:SetText(GText(MountInfo.UseLimitDes))
                self.Panel_MountHint:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            else
                self.Panel_MountHint:SetVisibility(UE4.ESlateVisibility.Collapsed)
            end
        else
            self.Panel_MountHint:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    else
        self.Panel_MountHint:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    -- 隐藏不需要显示的模块
    self.List_ModStar:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Swtich01:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_Draft:SetVisibility(UE4.ESlateVisibility.Collapsed) 
    self.Panel_Skill:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_Effect:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_Tag:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Panel_Equipped:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_Property:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Img_Attribute:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- 只在Mod上需要
    self.Img_Aura:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Polarity_1:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function WBP_Bag_Detail_View_C:RefreshInfoWithDraft(PlayerAvatar, StuffServerData, StuffConfigData)
    -- 描述介绍
    self.Text_Hold01:SetText(GText("UI_Bag_Sellconfirm_Hold"))

    self.Swtich02:SetActiveWidgetIndex(1)
    if (StuffConfigData.DetailDes ~= nil) then
        self.Text_Describe:SetText(GText(StuffConfigData.DetailDes))
        self.Panel_Describe:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible) 
    else
        self.Panel_Describe:SetVisibility(UE4.ESlateVisibility.Collapsed) 
    end

    self.Panel_Draft:ClearChildren()
    local ItemInfoWidget = UIManager(self):CreateWidget("WidgetBlueprint'/Game/UI/WBP/Bag/Widget/WBP_Bag_Tips_Draft.WBP_Bag_Tips_Draft_C'", false)
    if ItemInfoWidget then
        local DraftSlot = self.Panel_Draft:AddChildToOverlay(ItemInfoWidget)
        if (DraftSlot) then
            DraftSlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
            DraftSlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
        end
        self.ItemInfoWidget = ItemInfoWidget
        ItemInfoWidget.ParentWidget = self
        ItemInfoWidget:InitItemInfo(BagCommon.StuffType.Draft, StuffConfigData.DraftId, self.OwnerContent.Uuid, self.OwnerContent)
    end
    self.Panel_Draft:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible) 
    -- 隐藏不需要显示的模块
    self.Panel_LongDescribe:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_TimeLimit:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Text_SubTitle:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_MountHint:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.List_ModStar:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Swtich01:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_Skill:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_Effect:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_Tag:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Panel_Equipped:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_Property:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Img_Attribute:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- 只在Mod上需要
    self.Img_Aura:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Polarity_1:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function WBP_Bag_Detail_View_C:RefreshInfoWithOther(PlayerAvatar, StuffServerData, StuffConfigData)
    -- 未知物品类型刷新
    self.Text_ItemName:SetText(GText(StuffConfigData.ResourceName))
    self.Text_SubTitle:SetText(GText(DataMgr.BagTab[StuffConfigData.MaterialClassify].TabName))
    self.Text_SubTitle:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Text_Hold01:SetText(GText("UI_Bag_Sellconfirm_Hold"))
    self.Text_Hold02:SetText(Utils.FormatNumber(self.OwnerContent.Count, true))
    self.Swtich02:SetActiveWidgetIndex(1)
    -- 描述介绍
    if (StuffConfigData.Description ~= nil) then
        self.Text_Describe:SetText(GText(StuffConfigData.Description))
        self.Panel_Describe:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Panel_Describe:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    -- 隐藏不需要显示的模块
    self.Swtich01:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.List_ModStar:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Panel_Draft:SetVisibility(UE4.ESlateVisibility.Collapsed) 
    self.Panel_Skill:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_TimeLimit:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_LongDescribe:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_Effect:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_Tag:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Panel_Equipped:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_Property:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Img_Attribute:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Panel_MountHint:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- 只在Mod上需要
    self.Img_Aura:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Polarity_1:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function WBP_Bag_Detail_View_C:RefreshAccessMethod(StuffConfigData)
    self.AllMethodSubWidgetList = {}
    if (not StuffConfigData.AccessKey or (self.ParentWidget and self.ParentWidget.BagCurState == BagCommon.AllBagState.ChooseSaleState)) then
        self.Panel_Method:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        self.Method:ClearChildren() 
        for _, Access in pairs(StuffConfigData.AccessKey) do
            PageJumpUtils:GetItemAccess(self, self.StuffId, self.StuffType, Access, BagCommon.MainUIName)
        end
        PageJumpUtils:SortAccessItem(self.Method)
        local AllMethodCount = self.Method:GetChildrenCount()

        for index = 1, AllMethodCount do
            local TestWidget = self.Method:GetChildAt(index - 1)
            if (TestWidget and not TestWidget.IsText) then
                table.insert(self.AllMethodSubWidgetList, TestWidget)
            end
        end

        local AllCanNavigateAccessCount = #self.AllMethodSubWidgetList
        for index, TargetWidget in ipairs(self.AllMethodSubWidgetList) do
            if (TargetWidget) then
                TargetWidget:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
                TargetWidget:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
                if (AllCanNavigateAccessCount == 1) then
                    -- 只有一个可以聚焦的并且跳转获取途径
                    TargetWidget:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
                    TargetWidget:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
                else
                    if (index == 1) then
                        TargetWidget:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
                        TargetWidget:SetNavigationRuleExplicit(EUINavigation.Down, self.AllMethodSubWidgetList[index + 1])
                    elseif (index == AllCanNavigateAccessCount) then
                        TargetWidget:SetNavigationRuleExplicit(EUINavigation.Up, self.AllMethodSubWidgetList[index - 1])
                        TargetWidget:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
                    else
                        TargetWidget:SetNavigationRuleExplicit(EUINavigation.Up, self.AllMethodSubWidgetList[index - 1])
                        TargetWidget:SetNavigationRuleExplicit(EUINavigation.Down, self.AllMethodSubWidgetList[index + 1])
                    end
                end
            end
        end

        if (AllMethodCount <= 0) then
            self.Panel_Method:SetVisibility(UE4.ESlateVisibility.Collapsed)
        else
            self.Text_Method:SetText(GText("UI_Tips_Obtining"))
            self.Panel_Method:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
    end
end

function WBP_Bag_Detail_View_C:UpdateAttrInfo(StuffType, TargetServerData, ...)
    --更新属性列表
    if (StuffType == BagCommon.StuffType.Weapon) then
        self.ItemAttrs = {}
        self.AttrCount = 0
        self.Index2AttrKey = {}
        -- 武器被动技能
        local StuffTypeTag, SortIndex = ...
        self.PassiveSkillWeaponId = nil
        local data =  DataMgr.BattleWeapon[TargetServerData.WeaponId]
        if data and data.PassiveEffectsDesc then
            self.PassiveSkillWeaponId = TargetServerData.WeaponId
        end

        local SortType ='SortIndex'..SortIndex
        local Avatar = GWorld:GetAvatar()
        self.ItemAttrs = TargetServerData:DumpDefaultBattleAttr(Avatar).TotalValues
        local DisplayAttrs = {}
        self.ItemAttrs = self.ItemAttrs or {}
        local WeaponAttrData = DataMgr.BattleWeaponAttr
        for id,Data in pairs(WeaponAttrData) do
            local value = self.ItemAttrs[id] or Data.DefaultValue
            if CommonUtils:ShouldDisplayAttr(id,value,StuffType,StuffTypeTag,TargetServerData.WeaponId) then
                self.AttrCount = self.AttrCount + 1
                self.Index2AttrKey[self.AttrCount] = id
                DisplayAttrs[id] = value
            end
        end
        self.ItemAttrs = DisplayAttrs
        table.sort(self.Index2AttrKey,function(x,y)
            return DataMgr.AttrConfig[x][SortType] < DataMgr.AttrConfig[y][SortType]
        end)
        self:UpdataWeaponAttrListView() 
    elseif (StuffType == BagCommon.StuffType.Mod) then
        local ModAttrs,ModId= ...
        local ModLevel = TargetServerData.Level
        for _, ModAttr in ipairs(ModAttrs) do
            local AttrConfig = DataMgr.AttrConfig[ModAttr.AttrName]
            if not AttrConfig then goto continue end
            local Value, ValueStr = ArmoryUtils:GenModAttrData(ModAttr, ModLevel, AttrConfig, ModId)
            local ModAttrText = GText(AttrConfig.Name)..ValueStr
            local EffectDescribeObj = self:CreateEffectDescribeItem({IsAddAttr=Value>=0, ModAttrDescribe=ModAttrText}, "AddValue")
            self.EffectDetails:AddChildToWrapBox(EffectDescribeObj)
            ::continue::
        end
    end
end

function WBP_Bag_Detail_View_C:UpdataWeaponAttrListView()
    self.VerticalBox_Property:ClearChildren()
    local PropertyDescribeData = {}
    for i, Key in ipairs(self.Index2AttrKey) do
        PropertyDescribeData.GridIndex = i
        local Data = DataMgr.AttrConfig[Key]
        local attr = self.ItemAttrs[Key] or 0
        PropertyDescribeData.AttrName = GText(Data.Name)
        PropertyDescribeData.AttrNum = CommonUtils.AttrValueToString(Data,attr)
        -- DescribeData.AttrDesc = GText(Data.AttrDesc)
        PropertyDescribeData.ParentWidget = self
        local PropertyDescribeObj = self:CreatePropertyDescribeItem(PropertyDescribeData)
        self.VerticalBox_Property:AddChildToVerticalBox(PropertyDescribeObj)
    end
end

function WBP_Bag_Detail_View_C:UpdateItemNumber()
    if (self.OwnerContent) then
        self.Text_Hold02:SetText(Utils.FormatNumber(self.OwnerContent.Count, true))
    end
end

-- 刷新底部按钮相关信息
function WBP_Bag_Detail_View_C:UpdateBottomSingleBtnInfo(FromStr, Callback, ParentWidget, ReddotTreeNode)
    if (FromStr == "WeaponAndMod") then
        self.Btn01:UnBindEventOnClickedByObj(ParentWidget)
        self.Btn01:SetText(GText("UI_BAG_Gotoarmory"))
        self.Btn01:SetReddot(false)
        -- 武器&&Mod
        self.Btn01:BindEventOnClicked(ParentWidget, Callback)
        self.Img_Yes:SetBrushResourceObject(LoadObject('/Game/UI/Texture/Static/Atlas/Common/T_Com_IconYes.T_Com_IconYes'))
        self.Img_Yes:SetBrushTintColor(UE4.UUIFunctionLibrary.StringToSlateColor("E1B453FF"))
        self.Panel_Button:SetVisibility(UE4.ESlateVisibility.Collapsed)
        -- self.Panel_Button:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    elseif (FromStr == "Mount") then
        self.Btn01:UnBindEventOnClickedByObj(ParentWidget)
        self.Btn01:SetText(GText("UI_JumpMount"))
        self.Btn01:SetReddot(false)
        -- 坐骑相关
        self.Btn01:BindEventOnClicked(ParentWidget, Callback)
        self.Img_Yes:SetBrushResourceObject(LoadObject('/Game/UI/Texture/Static/Atlas/Common/T_Com_IconYes.T_Com_IconYes'))
        self.Img_Yes:SetBrushTintColor(UE4.UUIFunctionLibrary.StringToSlateColor("E1B453FF"))
        self.Panel_Button:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    elseif (FromStr == "Read") then
        self.Btn01:UnBindEventOnClickedByObj(ParentWidget)
        self.Btn01:SetText(GText("UI_BAG_Read"))
        self.Btn01:SetReddot(false)
        -- 道具相关
        self.Btn01:BindEventOnClicked(ParentWidget, Callback)
        self.Img_Yes:SetBrushResourceObject(LoadObject('/Game/UI/Texture/Static/Atlas/Common/T_Com_IconYes.T_Com_IconYes'))
        self.Img_Yes:SetBrushTintColor(UE4.UUIFunctionLibrary.StringToSlateColor("E1B453FF"))
        self.Panel_Button:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    elseif (FromStr == "Fish") then
        self.Btn01:UnBindEventOnClickedByObj(ParentWidget)
        self.Btn01:SetText(GText("UI_Fishing_OpenFishBook"))
        -- 钓鱼相关
        self.Btn01:BindEventOnClicked(ParentWidget, Callback)
        if (ReddotTreeNode) then
            self:AddSingleBtnReddotListener(ReddotTreeNode)
        end

        self.Img_Yes:SetBrushResourceObject(LoadObject('/Game/UI/Texture/Dynamic/Atlas/Entrance/T_Entrance_Anglin.T_Entrance_Anglin'))
        self.Img_Yes:SetBrushTintColor(UE4.UUIFunctionLibrary.StringToSlateColor("C6BDACFF"))
        self.Panel_Button:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    elseif (FromStr == "ConsumableItem") then
        self.Btn01:UnBindEventOnClickedByObj(ParentWidget)
        self.Btn01:SetText(GText("UI_Consumable_Open"))
        self:SetConsumableItemButtonReddot(ReddotTreeNode)
        self.Btn01.AudioEventPath = "event:/ui/common/click_btn_confirm"
        -- 钓鱼相关
        self.Btn01:BindEventOnClicked(ParentWidget, Callback)
        self.Img_Yes:SetBrushResourceObject(LoadObject('/Game/UI/Texture/Static/Atlas/Common/T_Com_IconYes.T_Com_IconYes'))
        self.Img_Yes:SetBrushTintColor(UE4.UUIFunctionLibrary.StringToSlateColor("E1B453FF"))
        self.Panel_Button:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Panel_Button:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function WBP_Bag_Detail_View_C:SetConsumableItemButtonReddot(ReddotTreeNode)
    DebugPrint("Yihan@ SetConsumableItemButtonReddot", self.StuffId)
    local BagConsumeNodeDetails = ReddotManager.GetLeafNodeCacheDetail(ReddotTreeNode)
    self.Btn01:SetReddot(false, BagConsumeNodeDetails[self.StuffId].ShowReddot)
end

function WBP_Bag_Detail_View_C:AddSingleBtnReddotListener(ReddotTreeNode)
    if (self.CurListenReddotTreeNodeName == ReddotTreeNode) then
        return
    end
    self:RemoveSingleBtnReddotListener()
    self.CurListenReddotTreeNodeName = ReddotTreeNode
    ReddotManager.AddListener(ReddotTreeNode, self, self.OnSingleBtnReddotChange)
end

function WBP_Bag_Detail_View_C:RemoveSingleBtnReddotListener(ReddotTreeNode)
    if (self.CurListenReddotTreeNodeName) then
        ReddotManager.RemoveListener(ReddotTreeNode, self)
    end
end

function WBP_Bag_Detail_View_C:OnSingleBtnReddotChange(Count)
    -- local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(self.CurListenReddotTreeNodeName)
    if (self.CurListenReddotTreeNodeName == "AnglingMap") then
        -- 钓鱼
        self.Btn01:SetReddot(Count > 0)
    end
end

function WBP_Bag_Detail_View_C:CreatePropertyDescribeItem(Content)
    if(Content == nil)then
        return
    end
    local PropertyDescribeObj = UIManager(self):_CreateWidgetNew("WeaponItemDetailItems")
    if (PropertyDescribeObj == nil) then
        DebugPrint("WBP_Bag_Detail_View_C: CreatePropertyDescribeItem create fail")
        return
    end
    PropertyDescribeObj.Text_Property:SetText(Content.AttrName)
    PropertyDescribeObj.Text_Num:SetText(Content.AttrNum)
    if (Content.GridIndex % 2 == 1) then
        PropertyDescribeObj.Bg:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        PropertyDescribeObj.Bg:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    return PropertyDescribeObj
end

function WBP_Bag_Detail_View_C:CreateEffectDescribeItem(Content, Style)
    if(Content == nil)then
        return
    end
    local EffectDescribeObj = UIManager(self):_CreateWidgetNew("CommonItemDetailsEffect")
    if (EffectDescribeObj == nil) then
        DebugPrint("WBP_Bag_Detail_View_C: CreateEffectDescribeItem create fail")
        return
    end
    if (Style == "Effect") then
        EffectDescribeObj.Text_Effect01:SetText(GText("UI_MOD_Effect")..Content.ModAttrDescribe) 
        EffectDescribeObj.Text_Effect01.WrapTextAt = EffectDescribeObj.TipsWrappingValue
        EffectDescribeObj.Switch_Type:SetActiveWidgetIndex(1)
    else
        EffectDescribeObj.Text_Effect:SetText(Content.ModAttrDescribe) 
        EffectDescribeObj.Text_Effect.WrapTextAt = EffectDescribeObj.TipsWrappingValue
        EffectDescribeObj.Switch_Type:SetActiveWidgetIndex(0)
    end
    return EffectDescribeObj
end

function WBP_Bag_Detail_View_C:UpdateStarStyle(NowStarLevel)
    for i = 1, 6, 1 do
        local StarWidget = self["Switcher_Star_"..tostring(i)]
        if (StarWidget ~= nil) then
            if (i <= NowStarLevel) then
                StarWidget:SetActiveWidgetIndex(0)
            else
                StarWidget:SetActiveWidgetIndex(1) 
            end
        end
    end
end

-- 获取武器远程or近战
function WBP_Bag_Detail_View_C:GetWeaponType(WeaponId)
    local BattleWeaponData = DataMgr.BattleWeapon[WeaponId]
    for _, v in pairs(BattleWeaponData.WeaponTag) do
        local WeaponTagData = DataMgr.WeaponTag[v]
        if WeaponTagData and WeaponTagData.WeaponTagfilter then
            if WeaponTagData.WeaponTagfilter == "RangedType" then
                return false
            else
                return true
            end
        end
    end
    return false
end

-- 获取物品ObjId
function WBP_Bag_Detail_View_C:GetStuffObjId(StuffUuid)
    local FinalObjId = StuffUuid
    if (type(FinalObjId) =="string" and CommonUtils.IsObjIdStr(FinalObjId)) then
        FinalObjId = CommonUtils.Str2ObjId(FinalObjId)
    end
    return FinalObjId
end

-- 获取武器远程or近战
-- 规则：遍历BattleWeapon的WeaponTag，当 WeaponTagfilter 存在值的情况下生效(多个值生效取最后一个)
function WBP_Bag_Detail_View_C:GetWeaponTypeName(WeaponId)
    local WeaponType, WeaponName = nil, nil
    local BattleWeaponData = DataMgr.BattleWeapon[WeaponId]
    for _, v in pairs(BattleWeaponData.WeaponTag) do
        local WeaponTagData = DataMgr.WeaponTag[v]
        if WeaponTagData and WeaponTagData.WeaponTagfilter then
            if WeaponTagData.WeaponTagfilter == "RangedType" then
                WeaponType = GText("UI_BAG_Longrange")
            elseif WeaponTagData.WeaponTagfilter == "MeleeType" then
                WeaponType = GText("UI_BAG_Meleeweapon")
            end
            
            if v == "Bow" then
                --特殊处理，区分长短弓
                local BowTag = nil
                for _, tag in pairs(BattleWeaponData.WeaponTag) do
                    if tag == "Bow01" then
                        BowTag = tag
                    end
                end
                WeaponTagData = DataMgr.WeaponTag[BowTag or "Bow02"] or {}
            end

            if v == "Bow" then
                --特殊处理，区分长短弓
                local BowTag = nil
                for _, tag in pairs(BattleWeaponData.WeaponTag) do
                    if tag == "Bow01" then
                        BowTag = tag
                    end
                end
                WeaponTagData = DataMgr.WeaponTag[BowTag or "Bow02"] or {}
            end
            
            if WeaponTagData.WeaponTagTextmap then
                WeaponName = GText(WeaponTagData.WeaponTagTextmap)
            end
        end
    end
    if not WeaponType then
        ScreenPrint("WeaponId"..WeaponId.."的WeaponType为空，请检查WeaponTag中是否配置对应的WeaponTagfilter")
        return ""
    end
    if not WeaponName then
        ScreenPrint("WeaponId"..WeaponId.."的WeaponName为空，请检查WeaponTag中是否配置对应的WeaponTagTextmap")
        return WeaponType
    end
    return WeaponType.."："..WeaponName
end

function WBP_Bag_Detail_View_C:UpdateUIStyleInPlatform(IsUseGamePad)
    if (IsUseGamePad) then
        self.Key_Lock:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Key_Method:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Key_Lock:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Key_Method:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function WBP_Bag_Detail_View_C:IsHaveAccessKeyCanFocus()
    return self.AllMethodSubWidgetList and #self.AllMethodSubWidgetList > 0
end

--------------------手柄相关操作-------------------
-- 判断是否在手柄查看物品获取途径
function WBP_Bag_Detail_View_C:IsInGamePadViewAccessKey()
    local PlayerController = self:GetOwningPlayer()
    if (self.AllMethodSubWidgetList) then
        for _, TargetWidget in ipairs(self.AllMethodSubWidgetList) do
            if (TargetWidget and (TargetWidget:HasUserFocus(PlayerController) or TargetWidget:HasUserFocusedDescendants(PlayerController))) then
                return true
            end
        end
    end
    return false
end

-- 查看物品获取途径
function WBP_Bag_Detail_View_C:OnViewStuffAccessKey()
    local TargetNavigateWidget = nil
    if (self.AllMethodSubWidgetList and #self.AllMethodSubWidgetList > 0) then
        TargetNavigateWidget = self.AllMethodSubWidgetList[1]
    end
    if (TargetNavigateWidget) then
        TargetNavigateWidget:SetFocus()
        self.EMScrollBox_Detail:ScrollWidgetIntoView(TargetNavigateWidget)
    end
end

-- 模拟按钮按下处理
function WBP_Bag_Detail_View_C:OnBtnDownWithVirsualClick(BtnName)
    if (not self.Panel_Button:IsVisible()) then
        return
    end
    self:AddTimer(0.1, function()
        local BtnWidget = self[BtnName]
        if (BtnWidget) then
            BtnWidget:OnBtnClicked()
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", "UseOptionResource", nil)
        end
    end)
end

-- 手柄按下按键处理
function WBP_Bag_Detail_View_C:Handle_KeyDownOnGamePad(InKeyName)
    local IsEventHandled = false
    return IsEventHandled
end

return WBP_Bag_Detail_View_C



