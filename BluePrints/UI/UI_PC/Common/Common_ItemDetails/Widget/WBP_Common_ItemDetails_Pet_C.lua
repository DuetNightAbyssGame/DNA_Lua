--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR zhangdongxu
-- @DATE ${date} ${time}
--
require "UnLua"
local SkillUtils = require "Utils.SkillUtils"
local CommonUtils = require "Utils.CommonUtils"
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
---@type Common_ItemDetails_Pet_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

function M:Construct()
    self.Pet_AttTips_List01.SkillName:SetText(GText("UI_Armory_Pet_Positive"))
    self.Pet_AttTips_List02.SkillName:SetText(GText("UI_Armory_Pet_Passive"))
    self.Pet_AttTips_List01.SkillCD:SetText(GText("UI_CD"))
    self.Pet_AttTips_List02.SkillCD:SetText(GText("UI_CD"))
    self.Pet_AttTips_List02.Skill_Key:SetVisibility(ESlateVisibility.Collapsed)
    self.ParentWidget.Text_PetAlive:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
end

function M:InitItemInfo(ItemType, ItemId, UnitId, Content)
    self:AddInputMethodChangedListen()
    local PetData = DataMgr.Pet[ItemId]
    local BattlePetData = DataMgr.BattlePet[PetData.BattlePetId]
    local Avatar = GWorld:GetAvatar()
    local PetServerData
    local Level = 1
    local MaxLevel = 1
    local EnhanceLevel, MaxEnhanceLevel = 0, 0
    PetServerData = Avatar.Pets[UnitId]
    if PetServerData then
        Level = PetServerData.Level
        EnhanceLevel = PetServerData.BreakNum
        if PetServerData.Name ~= "" then
            self.ParentWidget.Text_ItemName:SetText(PetServerData.Name)
        end
    end

    local SkillBtnDesc
    local SkillData = DataMgr.Skill[DataMgr.BattlePet[PetData.BattlePetId].SupportSkillId]
    if SkillData and SkillData[1] and SkillData[1][0]then
        self.SkillBtnDesc = GText(SkillData[1][0].SkillBtnDesc)
    end


    -- 初始化控件状态
    self.Pet_AttTips_List01:SetVisibility(ESlateVisibility.Collapsed)
    self.Pet_AttTips_List02:SetVisibility(ESlateVisibility.Collapsed)
    self.ParentWidget.Star:SetVisibility(ESlateVisibility.Collapsed)
    self.ParentWidget.Text_Split:SetVisibility(ESlateVisibility.Collapsed)
    self.ParentWidget.Text_WeaponLevel03:SetVisibility(ESlateVisibility.Collapsed)
    self.Pet_AttTips_List01.TextItem:ClearChildren()
    self.Pet_AttTips_List02.TextItem:ClearChildren()

    -- 宠物当前等级
    self.ParentWidget.Text_WeaponLevel02:SetText(Level)
    -- 宠物当前类型
    self.ParentWidget.Text_PetAlive:SetText(GText("Pet_ResourcePet"))

    -- 活力魔灵信息
    if PetData.PetType == 1 or PetData.PetType == 3 then
        self.ParentWidget.Text_PetAlive:SetText(GText("Pet_BattlePet"))
        self.ParentWidget.Star:SetVisibility(ESlateVisibility.Visible)
        -- 宠物突破等级
        for _, v in pairs(DataMgr.PetBreak[ItemId]) do
            if v.PetBreakNum <= EnhanceLevel and v.PetBreakLevel then
                MaxLevel = v.PetBreakLevel
            end
            MaxEnhanceLevel = v.PetBreakNum
        end
        self:SetPetEnhanceLevel(EnhanceLevel, MaxEnhanceLevel)
        -- 宠物最大等级
        self.ParentWidget.Text_Split:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.ParentWidget.Text_WeaponLevel03:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.ParentWidget.Text_WeaponLevel03:SetText(MaxLevel)
        local SkillId = BattlePetData.SupportSkillId
        local SkillLevel = ArmoryUtils:GetPetSkillLevel(EnhanceLevel)
        self.Pet_AttTips_List01.Num_Level:SetText(SkillLevel)
        self.Pet_AttTips_List02.Num_Level:SetText(SkillLevel)
        
        local AdditionalLevel = 0
        if PetServerData then
            AdditionalLevel = PetServerData:GetSkillLevelUp()
        end

        SkillLevel = SkillLevel + AdditionalLevel
        local SkillDesc = SkillUtils.GetSkillDesc(SkillId, SkillLevel) or ""
        -- 主动技能
        if SkillDesc ~= "" then
            local TextItem = UIManager(self):_CreateWidgetNew("ItemDetailPetTextItem")
            TextItem.Text_PetSkill_Describe:SetText(GText(SkillDesc))
            self.Pet_AttTips_List01.TextItem:AddChild(TextItem)
            self.Pet_AttTips_List01:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        else
            DebugPrint("ZDX_宠物Tips主动技能描述为空")
        end
        -- 被动技能
        local PassiveEffectDesc = ArmoryUtils:GenPetPassiveEffectDesc(BattlePetData, SkillLevel)
        if PassiveEffectDesc == "" then
            DebugPrint("ZDX_宠物Tips被动技能描述为空")
        else
            local TextItem = UIManager(self):_CreateWidgetNew("ItemDetailPetTextItem")
            TextItem.Text_PetSkill_Describe:SetText(GText(PassiveEffectDesc))
            self.Pet_AttTips_List02.TextItem:AddChild(TextItem)
            self.Pet_AttTips_List02:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end

        if AdditionalLevel and AdditionalLevel ~= 0 then
            self.Pet_AttTips_List01.Text_Extra:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.Pet_AttTips_List02.Text_Extra:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.Pet_AttTips_List01.Text_Extra:SetText(string.format(GText("Pet_Affix_LevelAdd"), AdditionalLevel))
            self.Pet_AttTips_List02.Text_Extra:SetText(string.format(GText("Pet_Affix_LevelAdd"), AdditionalLevel))
        else
            self.Pet_AttTips_List01.Text_Extra:SetVisibility(ESlateVisibility.Collapsed)
            self.Pet_AttTips_List02.Text_Extra:SetVisibility(ESlateVisibility.Collapsed)
        end

        -- CD
        local CD = ""
        if DataMgr.Skill[SkillId] and DataMgr.Skill[SkillId][SkillLevel] then
            CD = DataMgr.Skill[SkillId][SkillLevel][0].CD
        end

        if CD == "" then
            DebugPrint("ZDX_宠物TipsCD为空")
            self.Pet_AttTips_List01.SkillCD:SetVisibility(ESlateVisibility.Collapsed)
            self.Pet_AttTips_List01.SkillCD_Num:SetVisibility(ESlateVisibility.Collapsed)
        else
            self.Pet_AttTips_List01.SkillCD_Num:SetText(CD.."s")
            self.Pet_AttTips_List01.SkillCD_Num:SetVisibility(ESlateVisibility.Visible)
        end

        self.Pet_AttTips_List02.SkillCD:SetVisibility(ESlateVisibility.Collapsed)
        self.Pet_AttTips_List02.SkillCD_Num:SetVisibility(ESlateVisibility.Collapsed)
    end

    -- 宠物词条
    self.HB_Tag:ClearChildren()
    if PetServerData then
        for _, v in pairs(PetServerData.Entry) do
            local Widget = UIManager(self):_CreateWidgetNew("PetEntryItemDetails")
            if DataMgr.PetEntry[v] then
                assert(DataMgr.PetEntry[v].IconS, "未配置宠物天赋IconS", v)
                Widget.Icon_Entry:SetBrushResourceObject(LoadObject(DataMgr.PetEntry[v].IconS))
                Widget.Text_Entry:SetText(GText(DataMgr.PetEntry[v].PetEntryName))
                if DataMgr.PetEntry[v].Rarity == 3 then
                    Widget.Icon_Entry:SetColorAndOpacity(Widget.Blue)
                elseif DataMgr.PetEntry[v].Rarity == 4 then
                    Widget.Icon_Entry:SetColorAndOpacity(Widget.Purple)
                elseif DataMgr.PetEntry[v].Rarity == 5 then
                    Widget.Icon_Entry:SetColorAndOpacity(Widget.Yellow)
                end
                self.HB_Tag:AddChild(Widget)
            end
        end
    end

    -- 描述
    self.Text_Pet_Describe:SetText(GText(PetData.IpDes))

    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(GWorld.GameInstance)
    self:OnUpdateUIStyleByInputTypeChange(GameInputModeSubsystem:GetCurrentInputType(), GameInputModeSubsystem:GetCurrentGamepadName())
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

-- 设置武器突破等级
function M:SetPetEnhanceLevel(EnhanceLevel, MaxEnhanceLevel)
    for i = 1, 6 do
        local str = "Switch_Star0"..i
        local StarWidget = self.ParentWidget[str]
        if StarWidget then
            if i <= EnhanceLevel then
                StarWidget:SetActiveWidgetIndex(0)
            elseif i <= MaxEnhanceLevel then
                StarWidget:SetActiveWidgetIndex(1)
            else
                StarWidget:SetVisibility(ESlateVisibility.Collapsed)
            end
        end
    end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    local KeyInfo = {Desc = self.SkillBtnDesc}

    local Key = CommonUtils:GetActionMappingKeyName("Skill3")
    if CurInputDevice == UE4.ECommonInputType.Gamepad then
        if (Key and Key ~= "")then
            local IconList = UIUtils.GetIconListByActionName("Skill3")
            if(IconList)then
                if(#IconList > 1)then
                    KeyInfo.Type = "Add"
                    KeyInfo.KeyInfoList = {}
                    for _, value in ipairs(IconList) do
                        table.insert(KeyInfo.KeyInfoList,{Type="Img", ImgShortPath=value})
                    end
                    self.Pet_AttTips_List01.Skill_Key:CreateSubKeyDesc(KeyInfo)
                else
                    KeyInfo.KeyInfoList = {
                        {Type = "Img",ImgShortPath=IconList[1]},
                    }
                    self.Pet_AttTips_List01.Skill_Key:CreateCommonKey(KeyInfo)
                end
            end
            self.Pet_AttTips_List01.Panel_Key:SetVisibility(ESlateVisibility.Visible)
        else
            self.Pet_AttTips_List01.Panel_Key:SetVisibility(ESlateVisibility.Collapsed)
        end
    else
        local Text
        if(UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Touch)then
            self.Pet_AttTips_List01.Skill_Key.Key:SetVisibility(ESlateVisibility.Collapsed)
        else
            Text = CommonUtils:GetKeyText(Key)
        end
        KeyInfo.KeyInfoList = {
            {Type = "Text",Text = Text},
        }
        self.Pet_AttTips_List01.Panel_Key:SetVisibility(ESlateVisibility.Visible)
        self.Pet_AttTips_List01.Skill_Key:SetVisibility(ESlateVisibility.Visible)
        self.Pet_AttTips_List01.Skill_Key:CreateCommonKey(KeyInfo)
    end
end

return M
