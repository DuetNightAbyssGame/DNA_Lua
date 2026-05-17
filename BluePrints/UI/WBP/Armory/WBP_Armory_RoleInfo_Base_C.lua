--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local SkillUtils = require "Utils.SkillUtils"
local UpgradeUtils = require "Utils.UpgradeUtils"
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
local ModModel = ModController:GetModel()
---@type WBP_Armory_Panel_RoleInfo_Base_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C",})
M._components = {
    "BluePrints.UI.BP_EMUserWidgetUtils_C",
    "BluePrints.UI.WBP.Armory.Armory_List_Attr_Compoment",
    "BluePrints.UI.WBP.Armory.MainComponent.Armory_ReddotTree_Component",
}
--function M:Initialize(Initializer)
--end

function M:Construct()
    --属性列表排序类型
    self.AttrSortIndexes = {["Char"] = 1, ["Melee"] = 2, ["Ranged"] = 3, ["UWeapon"] = 4}
    self.Text_Capacity:SetText(GText("UI_COST_NAME"))
    self.Text_Mod:SetText(GText("UI_Armory_Mod"))
    self.Btn_Mod.OnClicked:Add(self,self.OnModBtnClicked)
    self.Btn_Mod.OnPressed:Add(self,self.OnModBtnPressed)
    self.Btn_Mod.OnReleased:Add(self,self.OnModBtnReleased)
    -- 移动端不走hover
    if self.GameInputModeSubsystem:GetCurrentInputType() ~= ECommonInputType.Touch then
        self.Btn_Mod.OnHovered:Add(self,self.OnModBtnHovered)
        self.Btn_Mod.OnUnhovered:Add(self,self.OnModBtnUnhovered)
    end
    -- self.Stats_ListView.BP_OnEntryInitialized:Add(self,self.OnElementEntryInitialized)
    -- self.Stats:SetRenderOpacity(0)
    self.Button_More:Init({
        ClickCallback = self.OnBtn_MoreClicked,
        SoundFunc = function()
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
        end,
        SoundFuncReceiver = self,
        OwnerWidget = self
    })
    self.Btn_Intensify:BindEventOnClicked(self,self.OnIntensifyBtnClicked)
    self.Btn_Intensify:BindForbidStateExecuteEvent(self,self.OnForbiddenIntensifyBtnClicked)
    self.Btn_Replace:BindEventOnClicked(self,self.OnReplaceBtnClicked)
    self.Btn_Replace:BindForbidStateExecuteEvent(self,self.OnForbiddenReplaceBtnClicked)
    self.ConfirmBtns = {
        self.Btn_Intensify,
        self.Btn_Replace,
    }
    self:AddDispatcher(EventID.OnResourcesChanged, self, self.OnResourcesChanged)
    self:AddDispatcher(EventID.OnCharRewardStateChanged, self, self.UpdateCharRewardReddot)
    self:AddDispatcher(EventID.OnWeaponRewardStateChanged, self, self.UpdateWeaponRewardReddot)

end

function M:UpdateCharRewardReddot(CharId)
    if(self.IsPreviewMode or self.Type ~= "Char")then
        return
    end
    if(not self.Target or self.Target.CharId ~= CharId)then
        return
    end
    local Avatar = GWorld:GetAvatar()
    self.LevelInfo:ShowRewardReddot(Avatar:IsCharHasReward(CharId))
end

function M:UpdateWeaponRewardReddot(WeaponId)
    if(self.IsPreviewMode or self.Type ~= "Weapon")then
        return
    end
    if(not self.Target or self.Target.WeaponId ~= WeaponId)then
        return
    end
    local Avatar = GWorld:GetAvatar()
    self.LevelInfo:ShowRewardReddot(Avatar:IsWeaponHasReward(WeaponId))
end

function M:BindEvents(EventReceiver,Events)
    self.EventReceiver = EventReceiver
    self.Event_OnBtnIntensifyClicked = Events.OnBtnIntensifyClicked
    self.Event_OnBtnReplaceClicked = Events.OnBtnReplaceClicked
    self.Event_OnForbiddenBtnIntensifyClickedd = Events.OnForbiddenBtnIntensifyClicked
    self.Event_OnForbiddenBtnReplaceClicked = Events.OnForbiddenBtnReplaceClicked
end

function M:OnIntensifyBtnClicked()
    if(self.Event_OnBtnIntensifyClicked)then
        self.Event_OnBtnIntensifyClicked(self.EventReceiver)
    end
end

function M:OnReplaceBtnClicked()
    if(self.Event_OnBtnReplaceClicked)then
        self.Event_OnBtnReplaceClicked(self.EventReceiver)
    end
end

function M:OnForbiddenIntensifyBtnClicked()
    if(self.Event_OnForbiddenBtnIntensifyClickedd)then
        self.Event_OnForbiddenBtnIntensifyClickedd(self.EventReceiver)
    end
end

function M:OnForbiddenReplaceBtnClicked()
    if(self.Event_OnForbiddenBtnReplaceClicked)then
        self.Event_OnForbiddenBtnReplaceClicked(self.EventReceiver)
    end
end

function M:UpdateButtonStyle(StyleParams)
    local bShowUltraHint = true
    for i, Param in ipairs(StyleParams) do
        self.ConfirmBtns[i]:SetVisibility(Param.Visibility)
        self.ConfirmBtns[i]:SetText(Param.Text)
        self.ConfirmBtns[i]:ForbidBtn(Param.ForbidBtn)
        if(self.ConfirmBtns[i]:IsVisible())then
            bShowUltraHint = false
        end
    end
    if(bShowUltraHint and not self.IsPreviewMode)then
        self.Text_Ultra_Hint:SetText(GText("UI_Armory_Signature_Cant"))
        self.Panel_Hint:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    elseif(self.UnlockHintText)then
        self.Text_Ultra_Hint:SetText(self.UnlockHintText)
        self.Panel_Hint:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
        self.Panel_Hint:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    --更新升级按钮状态
    if StyleParams[1].ForbidBtn then
        self.Btn_Intensify:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        self.Btn_Intensify:SetVisibility(StyleParams[1].Visibility)
    end
    self:UpdateLevelUpBtn(self.Target,self.Type,self.Tag)
end


function M:Init(Params)
    --显隐Mod按钮
    local Avatar = ArmoryUtils:GetAvatar()
    if(Avatar:CheckUIUnlocked('Mod'))then
        self.IsShowModButton = true
        self.Panel_Mod:SetRenderOpacity(1)
        self.Panel_Mod:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self.IsShowModButton = false
        self.Panel_Mod:SetRenderOpacity(0)
        self.Panel_Mod:SetVisibility(UIConst.VisibilityOp["HitTestInvisible"])
    end

    self.Parent = Params.Parent
    self.Type = Params.Type
    self.IsUltra = false
    if(Params.Tag and string.find(Params.Tag,CommonConst.ArmoryTag.UWeapon))then
        self.Tag = CommonConst.ArmoryTag.UWeapon
        self.IsUltra = true
        self:CheckShowUWeaponTitleUI()
    else
        self:HideUWeaponTitleUI()
        self.Tag = Params.Tag
    end
    self.Target = Params.Target
    self.Char = Params.Char
    self.IsPreviewMode = Params.IsPreviewMode
    self.IsTargetUnowned = Params.IsTargetUnowned
    self.bNeedPreviewSwitcher = Params.bNeedPreviewSwitcher
    self.bHideUWeaponMod = Params.bHideUWeaponMod
    self.EscapeArmoryCharID = Params.EscapeArmoryCharID
    if(self.IsPreviewMode and self.bNeedPreviewSwitcher or self.IsTargetUnowned)then
        local SwitchParams = {KeyInfo = { KeyInfoList = {{Type="Img", ImgShortPath="X"}}, },}
        if(self.IsTargetUnowned)then
            SwitchParams.Avatars = {Params.AvatarPrime,Params.AvatarMax}
            SwitchParams.CurrentAvatar = Params.CurrentAvatar
            self.Btn_MaxSwitch:Init(SwitchParams)
        else
            self.Btn_MaxSwitch:Init(SwitchParams)
        end
        self.Btn_MaxSwitch:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Btn_MaxSwitch:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end

    self:SetOpenModParams(self.OpenModParams)
    self:UpdateTargetInfo(self.Target, self.Type, self.Tag)
    self:UpdateAttrInfo(self.Target,self.Type)
end

function M:UpdateTargetInfo(Target, Type, Tag)
    self.Target = Target or self.Target
    --更新属性列表以外的信息
    Type = Type or self.Type
    Tag = Tag or self.Tag

    local TargetId = Target[Type.."Id"]
    local BreakLevelUpData = DataMgr[Type.."Break"][TargetId]
    local MaxLevel = UpgradeUtils.GetMaxLevel(Target,Type)
    local LevelUpData
    if(Type == "Char")then
        LevelUpData = DataMgr.LevelUp[Target.Level]
        self.Describe:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.PosItem:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self:UpdateCharRewardReddot(TargetId)
    elseif(Type == "Weapon")then
        self.Describe:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.PosItem:SetVisibility(UIConst.VisibilityOp.Collapsed)
        LevelUpData = DataMgr.WeaponLevelUp[Target.Level]
        self:UpdateWeaponRewardReddot(TargetId)
    end
    local Percent = math.clamp(Target.Exp / LevelUpData[Type.."LevelMaxExp"],0,1)
    if(self.IsUltra)then
        MaxLevel = nil --同律武器不显示等级上限

        --ArmoryUtils:SetReddotRead({Uuid = self.Target.Uuid, Type = Type, Tag = Tag},true,false)
    end
    self.LevelInfo:Init(Target.Level,MaxLevel,Percent,(Target.EnhanceLevel or 0),BreakLevelUpData,Type,Tag,self.IsPreviewMode)
    self:UpdateSkillPanel(Target,Type)
    self:UpdateModPanel(Target)
    if(self.IsPreviewMode)then
        self.WidgetSwitcher_State:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        self.WidgetSwitcher_State:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        if(Type == "Char" and self.IsTargetUnowned)then
            self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
            self:UpdateUnlockBtn(Target,Type,Tag)
        elseif(Type == "Weapon" and self.IsTargetUnowned)then
            self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
            self:UpdateUnlockBtn(Target,Type,Tag)
        else
            self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
            self.UnlockHintText = nil
            self.Panel_Hint:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end
end

function M:UpdateUnlockBtn(Target,Type,Tag)
    self.UnlockHintText = nil
    if(self.IsUltra)then
        self.Btn_Unlock:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Text_Ultra_Hint:SetText(GText("UI_Armory_Signature_Cant"))
        return
    end
    self.Btn_Unlock:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    local Avatar = GWorld:GetAvatar()
    local Resources = {}
    local ResourcesData = DataMgr.Resource

    local Text
    local ShowReddot = false
    local Id
    if(Type == "Char")then
        Text = GText("UI_Char_Unlock")
        Id = Target.CharId
        local Data = DataMgr.Char[Target.CharId]
        local Rid = Data.CharPieceId
        local Resource = Avatar.Resources[Rid] or {Count = 0}
        local ShopItemId,ShopItemData = ShopUtils:GetShopItemDataById(Rid,CommonConst.DataType.Resource,true)
        Resources[1] = {Id = Rid,
                        Icon = ResourcesData[Rid] and ResourcesData[Rid].Icon,
                        ItemType = CommonConst.DataType.Resource,
                        Count = Resource.Count,
                        NeedCount = Data.CharUnlockRequiredPiece or 0,
                        ShopItemId = ShopItemId,
                        IsShowDetails = true,}
        if(ShopItemData)then
            local Resource2 = Avatar.Resources[ShopItemData.PriceType] or {Count = 0}
            Resources[2] = {
                Id = ShopItemData.PriceType,
                ItemType = CommonConst.DataType.Resource,
                Count = Resource2.Count,
                NeedCount = ShopItemData.Price * (Resources[1].NeedCount - Resources[1].Count),
                Price = ShopItemData.Price,
                IsShowDetails = true,
            }
            if(Resources[2].NeedCount <= 0)then
                Resources[2].NeedCount = 0
            end
        end
        ShowReddot = ArmoryUtils:TryAddUnlockableCharReddot(Target.CharId)
    elseif(Type == "Weapon")then
        Id = Target.WeaponId
        Text = GText("UI_Weapon_Unlock")
        local ShopItemId,ShopItemData = ShopUtils:GetShopItemDataById(Target.WeaponId,CommonConst.DataType.Weapon,true)
        if(ShopItemData)then
            local Rid = ShopItemData.PriceType
            local Resource = Avatar.Resources[Rid] or {Count = 0}
            Resources[1] = {Id = ShopItemData.PriceType,
                            Icon = ResourcesData[Rid] and ResourcesData[Rid].Icon,
                            ItemType = CommonConst.DataType.Resource,
                            Count = Resource.Count,
                            NeedCount = ShopItemData.Price,
                            bShowNeedCount = true,
                            ShopItemId = ShopItemId,
                            IsShowDetails = true,}
        else
            self.UnlockHintText = GText("UI_Weapon_Locked")
            self.Text_Ultra_Hint:SetText(GText("UI_Weapon_Locked"))
            self.Panel_Hint:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
            self.Btn_Unlock:SetVisibility(UIConst.VisibilityOp.Collapsed)
            return
        end
    end

    if(Resources[1] and Resources[1].Count > Resources[1].NeedCount)then
        Resources[1].Count = Resources[1].NeedCount
    end

    rawset(self,"UnlockBtnParams",{
                    bShowCoin = Type == "Char",
                    Type = Type,
                    Id = Id,
                    Owner = self,
                    ShowReddot = ShowReddot,
                    Resources = Resources,
                    Text = Text,
                    ResourceKeyInfos = {
                        KeyInfoList = {{Type="Img", ImgShortPath="Y"}},
                        --Desc = "",
                        bLongPress = true,
                    },
                    KeyInfos = {
                        KeyInfoList = {{Type="Img", ImgShortPath="Y"}},
                    },
                    OnClicked = self.OnUnlockBtnClicked,})
    self:UpdateUnlockBtnByParams(self.UnlockBtnParams)
end

function M:UpdateUnlockBtnByParams(Params)
    self:OnUnlockBtnParamsCreated(Params)
    self.Btn_Unlock:Init(Params)
end

function M:OnUnlockBtnParamsCreated()
    --在子类实现
end

function M:UpdateModPanel(Target)
    local ModVolume = ModModel:GetTargetMaxCost(Target)
    local Cost=ModModel:CalcModSuitTotalCost(Target, Target.ModSuitIndex ,true)
    self.Text_Capacity_Num:SetText(Cost)
    self.Text_Capacity_NumMax:SetText("/"..ModVolume)
    if(self.IsTargetUnowned)then
        self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
        return
    end
    self:RemoveModReddotListen()
    self:AddModReddotListen(function(self, Count)
        local VisibilityKey = Count>0 and "SelfHitTestInvisible" or "Collapsed"
        self.New:SetVisibility(UIConst.VisibilityOp[VisibilityKey])
    end, Target)
end

function M:UpdateLevelUpBtn(Target,Type,Tag)
    if(self.IsPreviewMode or self.IsTargetUnowned)then return end
    if(self.IsUltra)then
        return
    end
    if(not self.bHideReddot)then
        if(self.Btn_Intensify:GetVisibility() == UIConst.VisibilityOp["SelfHitTestInvisible"])then
            local Res = UpgradeUtils.CalcCharOrWeaponLevelUp(Target,Type,Target.Level,Target.Level + 1)
            --根据能否升级红点提示
            if(Res.CanUpgrade)then
                self.Btn_Intensify:SetReddotVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            else
                Res = UpgradeUtils.CalcBreakLevelUp(Target,Type,Target.EnhanceLevel + 1)
                if(Res.CanUpgrade)then
                    self.Btn_Intensify:SetReddotVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
                else
                    self.Btn_Intensify:SetReddotVisibility(UIConst.VisibilityOp["Collapsed"])
                end
            end
        end
    else
        self.Btn_Intensify:SetReddotVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

function M:UpdateAttrInfo(Target,Type)
    Type = Type or self.Type
    -----------------     更新属性列表
    self.Attrs = nil
    local DisplayAttrs = {}
    self.AttrCount = 0
    self.Index2AttrKey = {}
    local sortType='SortIndex'..self.AttrSortIndexes[self.Tag]
    local Avatar=ArmoryUtils:GetAvatar()
    local MeleeWeapon, RangedWeapon = nil, nil
    if Avatar.MeleeWeapon then
        MeleeWeapon = Avatar.Weapons[Avatar.MeleeWeapon]
    end
    if Avatar.RangedWeapon then
        RangedWeapon = Avatar.Weapons[Avatar.RangedWeapon]
    end
    self.Attrs= Target:DumpDefaultBattleAttr(Avatar,{Char = self.Char, MeleeWeapon = MeleeWeapon, RangedWeapon = RangedWeapon}).TotalValues
    local Tag = (Type == "Char" and "Char") or (Target:HasTag("Melee") and "Melee") or "Ranged"
    self.Attrs = self.Attrs or {}
    local TargetId = Target[Type .. "Id"]
    if(self.Type == "Weapon")then
        self:InsertWeaponType(Target.WeaponId,self.Attrs)
        local WeaponTypeKey = "WeaponType"
        if(self.Attrs[WeaponTypeKey])then
            self.AttrCount = self.AttrCount + 1
            self.Index2AttrKey[self.AttrCount] = WeaponTypeKey
            DisplayAttrs[WeaponTypeKey] = self.Attrs[WeaponTypeKey]
        end
        local WeaponAttrData = DataMgr.BattleWeaponAttr
        for id,Data in pairs(WeaponAttrData) do
            local value = self.Attrs[id] or Data.DefaultValue
            if CommonUtils:ShouldDisplayAttr(id,value,self.Type,Tag,TargetId) then
                self.AttrCount = self.AttrCount + 1
                self.Index2AttrKey[self.AttrCount] = id
                DisplayAttrs[id] = value
            end
        end
    else
        self:InsertExcelWeaponTag(Target.CharId,self.Attrs)
        self.PosItem:Init({Owner = self,CharId = Target.CharId})
        for id,value in pairs(self.Attrs) do
            if CommonUtils:ShouldDisplayAttr(id,value,self.Type,Tag,TargetId) then
                self.AttrCount = self.AttrCount + 1
                self.Index2AttrKey[self.AttrCount] = id
                DisplayAttrs[id] = value
            end
        end
    end
    self.Attrs = DisplayAttrs

    table.sort(self.Index2AttrKey,function(x,y)
        return DataMgr.AttrConfig[x][sortType] < DataMgr.AttrConfig[y][sortType]
    end)
    self:UpdateAttrListView(false)
end

function M:IsRecommendAttr(AttrKey)
    for _, Key in ipairs(self.Target:BattleData().RecommendAttr or {}) do
        if AttrKey == Key then return true end
    end
    return false
end

function M:OnModBtnClicked()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
    self.bModBtnPressed = false
    if(not self.IsShowModButton)then
        return
    end
    if(self.IsTargetUnowned)then
        --TODO:依赖控件获取数据不太好
        ArmoryUtils:SetTemporaryAvatar(self.Btn_MaxSwitch:GetCurrentAvatar())
    end
    local Uuids = {}
    if self.OpenModParams.CharUuid then
        table.insert(Uuids, self.OpenModParams.CharUuid)
    end
    if self.OpenModParams.MeleeUuid then
        table.insert(Uuids, self.OpenModParams. MeleeUuid)
    end
    if self.OpenModParams.RangedUuid then
        table.insert(Uuids, self.OpenModParams.RangedUuid)
    end
    if self.OpenModParams.CharUuid and not self.bHideUWeaponMod then
        local MainChar = ArmoryUtils:GetAvatar().Chars[self.OpenModParams.CharUuid]
        if MainChar then
            for _, Uuid in ipairs(MainChar.UWeaponEids or {}) do
                table.insert(Uuids, Uuid)
            end
        end
    end
    local ModUICase= (self.IsPreviewMode or self.IsTargetUnowned) and ModCommon.MainUICase.Preview or ModCommon.MainUICase.Normal
    ModController:OpenView(ModCommon.ArmoryMod,self.Type,self.Tag,Uuids,nil,
                            {Func = function ()
                                ArmoryUtils:SetTemporaryAvatar(nil)
                                if(self.Parent and self.Parent.OnArmoryModClosed)then
                                    self.Parent:OnArmoryModClosed()
                                end
                            end, Obj = nil,},
                            ModUICase)       
    self:UnRegisterListAttrBtn()
end

function M:SetOpenModParams(Params)
    if(Params == nil)then
        local Avatar = ArmoryUtils:GetAvatar()
        self.OpenModParams = {CharUuid = Avatar.CurrentChar,MeleeUuid = Avatar.MeleeWeapon,RangedUuid = Avatar.RangedWeapon}
    else
        self.OpenModParams = Params
    end
end

function M:OnModBtnPressed()
    self.bModBtnPressed = true
    self:PlayAnimation(self.Press)
end

function M:OnModBtnReleased()
    self.bModBtnPressed = false
    self:PlayAnimation(self.Normal)
    if(self.bModBtnHovered)then
        self:PlayAnimation(self.Hover)
    end
end

function M:OnModBtnHovered()
    self.bModBtnHovered = true
    self:PlayAnimation(self.Hover)
end

function M:OnModBtnUnhovered()
    self.bModBtnHovered = false
    if(not self.bModBtnPressed)then
        self:PlayAnimation(self.Normal)
    end
end

function M:PlayInAnim()
    if self:IsAnimationPlaying(self.In) then
        self:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        return
    end
    --设置Collapsed，会导致聚焦失败，因此设置不透明度为0
    self:SetVisibility(UIConst.VisibilityOp["HitTestInvisible"])
    self:SetRenderOpacity(0)
    self:AddTimer(0.01,function()
        self.LevelInfo:PlayStarsInAnim()
        self:PlayAnimation(self.In)
        self:SetRenderOpacity(1)
        self:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self:RegisterListAttrBtn()
    end,false,0,"RoleInfoInAnim",true)
end


function M:PlayOutAnim()
    self:RemoveTimer("RoleInfoInAnim")
    self:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    --DebugPrint("Armory_Panel_RoleInfo_PC......UnRegisterListAttrBtn")
    ---没有Out动画，直接触发回调
    --self:OnAnimationFinished(nil)
    self:RemoveModReddotListen()
    self:UnRegisterListAttrBtn()
end

--region 武器技能详情按钮

function M:ShowMoreSkillDetails()
    if(not self.Target)then
        return
    end
    local Avatar = ArmoryUtils:GetAvatar()
    local ModSuit = AvatarUtils:GetTargetModSuit(self.Target, self.Target.ModSuitIndex) or {}
    local ExtraInfo = {ModData = {}}
    for key, ModUuid in pairs(ModSuit) do
        local Mod = Avatar.Mods[ModUuid]
        if(Mod)then
            table.insert(ExtraInfo.ModData, Mod)
        end
    end
    local SkillInfo = self.Target:DumpSkillInfos(Avatar,ExtraInfo)
    if(not SkillInfo)then
        return
    end
    local AttrsList = {}
    local SortedSkills = {}
    local SkillData = DataMgr.Skill
    local SkillPriority = {Attack = 1,HeavyAttack = 2,FallAttack = 3,SlideAttack = 4,Others = 5}
    local Data
    for SkillId, _SkillInfo in pairs(SkillInfo) do
        Data = SkillData[SkillId] and SkillData[SkillId][1] and SkillData[SkillId][1][0]
        if(Data)then
            table.insert(SortedSkills,{SkillId = SkillId,Priority = SkillPriority[Data.SkillType] or SkillPriority.Others,Level = _SkillInfo.Level})
        end
    end
    table.sort(SortedSkills,function(a,b)
        return a.Priority<b.Priority
    end)
    for _, value in ipairs(SortedSkills) do
        local Attrs = SkillUtils.GetSkillAllDesc(value.SkillId, value.Level or 1, math.min(DataMgr.DataConst.MaxSkillLevel, (self.Target.GradeLevel or 0) + 1), Avatar, self.Target)
        Attrs = Attrs or {}
        for _, Item in pairs(Attrs) do
            table.insert(AttrsList,{AttrName = Item.Desc,AttrValue = Item.Value,AttrDesc = Item.Hint})
        end
    end
    local Params = {
        Attrs = AttrsList,
        DontFocusParentWidget = true,
    }
    UIManager(self):ShowCommonPopupUI(100104,Params,self)
end

function M:OnBtn_MoreClicked()
    self:ShowMoreSkillDetails()
end

--endregion 武器技能详情按钮

function M:OnBtnAttrClicked()
end

function M:OnResourcesChanged(ResourceId)
    if(self.IsUltra or rawget(self,"UnlockBtnParams") == nil)then
        return
    end
    self:UpdateUnlockBtn(self.Target,self.Type)
    local Resource1 = self.UnlockBtnParams.Resources[1]
    local Resource2 = self.UnlockBtnParams.Resources[2]
    local NeedUpdate = false
    if(Resource1 and ResourceId == Resource1.Id)then
        NeedUpdate = true
    end
    if(Resource2 and ResourceId == Resource2.Id)then
        NeedUpdate = true
    end
    if(NeedUpdate)then
        self:UpdateUnlockBtn(self.Target,self.Type)
    end
end

function M:OnUnlockBtnClicked()
    if(rawget(self,"UnlockBtnParams") == nil)then
        return
    end
    if(self.Type == "Char")then
        local Resource1 = self.UnlockBtnParams.Resources[1] or {}
        if(Resource1.Count < Resource1.NeedCount)then
            if(not self.UnlockBtnParams.Resources[2])then
                --不可购买角色碎片时弹toast
                local TypeName = Resource1.ItemType or ""
                local Data = DataMgr[TypeName]
                local Resource1Data = Data and Data[Resource1.Id]
                local Resource1Name = Resource1Data and Resource1Data[TypeName .. "Name"]
                Resource1Name = GText(Resource1Name) or ""
                UIManager(self):ShowUITip(UIConst.Tip_CommonToast, string.format( GText("UI_Armory_LackUnlcokResource"), Resource1Name))
                return
            end
            self:LoadUnlockDialog()
        else
            self:OnUnlockBtnConfirm()
        end
    elseif(self.Type == "Weapon")then
        self:LoadUnlockDialog()
    end
end

function M:LoadUnlockDialog()
    local Widget = UIManager(self):_CreateWidgetNew("ArmoryUnlockDialog")
    rawset(self,"UnlockDialog",Widget)
    if(Widget)then
        Widget:AddToViewport(self.Parent:GetZOrder())
        Widget:Init({
            Type = self.Type,
            TargetId = self.Target.CharId or self.Target.WeaponId,
            EscapeArmoryCharID = self.EscapeArmoryCharID,
            Parent = self.Parent,
            OnClose = function()
                rawset(self,"UnlockDialog",nil)
                if(IsValid(self.Parent))then
                    self.Parent:SetFocus()
                end
            end
        })
        Widget:SetFocus()
    end
end

function M:OnUnlockBtnConfirm()
    if(not self.IsTargetUnowned)then
        return
    end
    if(self.Type ~= "Char")then
        return
    end
    local Avatar = GWorld:GetAvatar()
    self.Parent:BlockAllUIInput(true)
    Avatar:UnlockCharUsePiece(self.Target.CharId,function(Ret,CharId)
        ArmoryUtils:OnUnlockCharUsePiece(Ret,CharId,self.EscapeArmoryCharID,function()
            self.Parent:BlockAllUIInput(false)
        end)
    end)
end

function M:CheckShowUWeaponTitleUI()
    local Father = self.Parent
    local WeaponID = Father[Father.ComparedWeaponName].WeaponId
    if WeaponID then
        local Data = DataMgr.UWeapon[WeaponID]
        if Data and Data.ArmoryTitleUIPath then
            self:FrestUWeaponTitleUI(Data)
        else
            if self.Parent and self.Parent.TextBlock_Name then
                self.Parent.Panel_SubTab:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            end
            self:HideUWeaponTitleUI()
        end
    else
        self:HideUWeaponTitleUI()
    end
end

function M:FrestUWeaponTitleUI(Data)
    if not Data or not Data.WeaponName or not Data.ArmoryTitleUIPath then
        return
    end
    local WeaponName=Data.WeaponName
    local TitleUIPath=Data.ArmoryTitleUIPath
    local UWeaponTitle = UIManager(self):CreateWidget(Data.ArmoryTitleUIPath)

    if UWeaponTitle then
        self.Node_Consonance:ClearChildren()
        self.Node_Consonance:AddChild(UWeaponTitle)
        UWeaponTitle.Text_Name:SetText(GText(WeaponName))
        UWeaponTitle:PlayAnimation(UWeaponTitle.In)
        UWeaponTitle:PlayAnimation(UWeaponTitle.Loop)
        --self.Parent.Panel_SubTab:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        ScreenPrint("创建UWeaponTitle UI失败，请检查路径是否正确"..(Data.ArmoryTitleUIPath or "空"))
        self:HideUWeaponTitleUI()
    end
    local AudioPath=Data.WeaponSound
    if not AudioPath  then
        ScreenPrint("武器标题音效路径为空,请填写Uweapon 的 WeaponSound字段 当前ID为"..tostring(Data.WeaponId))
        return
    end
    local AudioManager = AudioManager(self)
    AudioManager:PlayUISound(self, AudioPath, "UWeaponTitleShow", nil)
end
function M:HideUWeaponTitleUI()
    if  self.Parent and self.Parent.TextBlock_Name then
        --self.Parent.Panel_SubTab:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    self.Node_Consonance:ClearChildren()
end
AssembleComponents(M)
return M
