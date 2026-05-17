--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local CommonUtils = require "Utils.CommonUtils"
---@type WBP_Build_Select_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

--function M:Initialize(Initializer)
--end

function M:Construct()
    M.Super.Construct(self)
    self.IsExpand = false
    self.Btn_Show.OnClicked:Add(self, self.OnClicked)
    self.Btn_Show.OnPressed:Add(self, self.OnPressed)
    self.Btn_Show.OnHovered:Add(self, self.OnHovered)
    self.Btn_Show.OnUnhovered:Add(self, self.OnUnhovered)
    local DefaultConfigData = {
        OwnerWidget = self,
        TextContent = GText("UI_ArmourySquad_AutoSummonTips"),
        --ClickCallback=self.QaDefaultClickCallBack,
        OnMenuOpenChangedCallBack = self.OnMenuOpenChangedCallBack
    }
    self.Btn_Qa_Summon:Init(DefaultConfigData)
    self.Btn_Qa.OnClicked:Add(self,self.OpenDefaultMenuAnchor)
    self.Text_Summon:SetText(GText("UI_ArmourySquad_AutoSummon"))
    self.Switch_Summon:AddEventOnCheckStateChanged(self, self.OnCheckStateChanged)
    self.Avatar = GWorld:GetAvatar()
    if not self.Avatar then
        return
    end
    self.Switch_Summon:SetChecked(self.Avatar.bAutoPhantomForDefaultSquad)
    self.Key_Controller_Show:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:OnCheckStateChanged(IsChecked)
    self.Avatar:SwitchSquadAutoPhantom(IsChecked)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
    self.Super.Destruct(self)
    self.Switch_Summon:RemoveEventOnCheckStateChanged(self)
end
function M:OpenDefaultMenuAnchor()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_01", nil, nil)
    self.Btn_Qa_Summon:PlayAnimation(self.Btn_Qa_Summon.Click)
    self.Btn_Qa_Summon.Btn_Click:SetChecked(true)
    self.Btn_Qa_Summon:OpenMenuAnchor()
end

function M:CloseMenuAnchor()
    --self.Btn_Qa_Armory:CloseMenuAnchor()
    self.Btn_Qa_Summon:CloseMenuAnchor()
end

function M:OnMenuOpenChangedCallBack(bIsOpen)
    -- if UIUtils.UtilsGetCurrentInputType()==ECommonInputType.Gamepad then
    --     if(bIsOpen) then
    --         self.Key_Armory:SetVisibility(UE4.ESlateVisibility.Collapsed)
    --         self.Key_Default:SetVisibility(UE4.ESlateVisibility.Collapsed)
    --         self.Btn_Build:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
    --         self.Btn_Close:SetVisibility(UE4.ESlateVisibility.Visible)
    --         self:UpdatKeyDisplay("")
    --     else
    --         self.Key_Armory:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    --         self.Key_Default:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    --         self.Btn_Build:SetGamePadVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    --         self.Btn_Close:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
    --         self:UpdatKeyDisplay("Selected")
    --     end
    -- else
    --     if(bIsOpen) then
    --         self.Btn_Close:SetVisibility(UE4.ESlateVisibility.Collapsed)

    --     else
    --         self.Btn_Close:SetVisibility(UE4.ESlateVisibility.Visible)

    --     end
    -- end
end

function M:InitSquadData(Parent, bDisablePhantom, CurrentSquad)
    self.Avatar = GWorld:GetAvatar()
    if not self.Avatar then
        return
    end
    self.Parent = Parent
    self.SquadInfoList = Parent.SquadInfoList

    self.bDisablePhantom = bDisablePhantom
    -- self.Panel_BanPhantom:SetVisibility(bDisablePhantom and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
    -- self.Panel_BanPet:SetVisibility(bDisablePhantom and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
    self.WS_Type:SetActiveWidgetIndex(bDisablePhantom and 1 or 0)

    if self.Parent.Btn_Close:GetVisibility() == ESlateVisibility.Collapsed then
        self:PlayAnimationReverse(self.ArrowFlip, 5)
        self.IsExpand = false
        self.Parent.Panel_List:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.IsExpand = true
        self.Parent.Panel_List:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
    if not self or not self.Panel_Summon then return end

    local ShouldShow = (not bDisablePhantom) and (CurrentSquad == 0)
    
    -- 只在变化时才设置，避免重复刷新
    local NewVis = ShouldShow and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed
    if self.Panel_Summon:GetVisibility() ~= NewVis then
        self.Panel_Summon:SetVisibility(NewVis)
    end
    -- self.SquadList = self.Avatar.Squad
    -- self:UpdateSquadListInfo()
end

function M:OnClicked()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
    self:PlayAnimation(self.Click)
    if not self.IsExpand then
        AudioManager(self):PlayUISound(self, "event:/ui/common/preset_team_panel_expand", "Play_Build_Select", nil)
        self.Parent:PlayAnimation(self.Parent.In)
        self:PlayAnimation(self.ArrowFlip)
        self.IsExpand = true
        self.Parent.List_Default:ScrollToTop()
        self.Parent.IsShow = true
        self.Parent.Btn_Build:SetVisibility(UE4.ESlateVisibility.Visible)
        if self.IsMissing then
            self.Tips_Up:PlayAnimation(self.Tips_Up.Remind_Out)  --Remind_Out
        end
        if (UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad) then
            return
        end
        self.Panel_Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
        --self.Key_Controller_Show:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        if(CommonUtils:IfExistSystemGuideUI(self)) then
            return
        end
        AudioManager(self):SetEventSoundParam(self, "Play_Build_Select", {ToEnd = 1})     
        self.Parent:PlayAnimation(self.Parent.Out)
        self:PlayAnimationReverse(self.ArrowFlip)
        if self:IsAnimationPlaying(self.Click) then
            self:StopAnimation(self.Click)
            self:PlayAnimation(self.Normal)
        end

        self.IsExpand = false
        self.Parent.IsShow = false
        self.Parent.Btn_Build:SetVisibility(UE4.ESlateVisibility.Collapsed)
        if self.IsMissing then
            self.Tips_Up:PlayAnimation(self.Tips_Up.Remind_In)
        end
        if (UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad) then
            return
        end
        self.Panel_Controller:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        -- self.Key_Controller_Show:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
end

function M:OnPressed()
    self:PlayAnimation(self.Press)
end

function M:OnHovered()
    self:PlayAnimation(self.Hover)
end

function M:OnUnhovered()
    self:PlayAnimation(self.UnHover)
end

function M:UpdateView(SquadInfo,Index)
    self.SquadInfo = SquadInfo
    self.SquadIndex = Index
    self:SetIcon(SquadInfo)
    if self.bDisablePhantom then return end
    self.Panel_Summon:SetVisibility(Index == 0 and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
end

function M:SetIcon(SquadInfo)
    -- 设置预设阵容名字
    if SquadInfo.Name == "" or not SquadInfo.Name then
        self.Text_Name:SetText(GText("Squad_DefaultName1"))
    else
        self.Text_Name:SetText(self.SquadInfo.Name)
    end

    -- 通用设置图标
    local function SetIconComponent(Component, Category, Id, EmptyCategory)
        local Icon = nil
        if Id  and DataMgr[Category][Id] then
            Icon = DataMgr[Category][Id].Icon or ""
        end
        Component:InitIcon(Icon and Category or EmptyCategory, Icon)

        --Component.Img_Weapon:SetBrushFromTexture(LoadObject("Texture2D'/Game/UI/UI_PNG/Atlas/MiniHead/Normal_Mini_Heitao.Normal_Mini_Heitao'"))
        Component.Panel_Level:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    --DataTableName
    --DataMgr.BattleChar[Phantom1.CharId].GuideIconImg,
    -- 设置角色、武器、宠物图标
    SetIconComponent(self.Character, "Char", SquadInfo.CharId, "Empty")
    SetIconComponent(self.Melee, "Weapon", SquadInfo.MeleeWeaponId, "Empty")
    SetIconComponent(self.Range, "Weapon", SquadInfo.RangedWeaponId, "Empty")
    SetIconComponent(self.Pet, "Pet", SquadInfo.PetId, "EmptyPet")

    -- 设置魅影图标
    if not self.bDisablePhantom then 
        for i = 1, 2 do
            local PhantomId = SquadInfo["Phantom" .. i .. "Id"]
            local WeaponId = SquadInfo["PhantomWeapon" .. i .. "Id"]
            local SwitchWidget = self["Switch_Type0" .. i]
            local HeadWidget = self["Head_Phantom0" .. i]
            local HeadWidgetLack = self["Head_Phantom0" .. i.."_Lack"]
            if PhantomId then
                local MiniIconPath = "/Game/UI/Texture/Dynamic/Image/Head/Mini/"
                local PhantomGuideIconImg = DataMgr.BattleChar[PhantomId].GuideIconImg
                local NormalIconName = "T_Normal_" .. PhantomGuideIconImg
                local IconPath = MiniIconPath .. NormalIconName .. "." .. NormalIconName
                if WeaponId then
                    HeadWidget:SetBrushResourceObject(LoadObject(IconPath))
                    SwitchWidget:SetActiveWidgetIndex(0)
                else
                    --HeadWidgetLack:SetBrushResourceObject(LoadObject(IconPath))
                    local IconDynaMaterial = HeadWidgetLack:GetDynamicMaterial()
                    if IconDynaMaterial then
                        IconDynaMaterial:SetTextureParameterValue("MainTex", LoadObject(IconPath))
                    end
                    SwitchWidget:SetActiveWidgetIndex(2) -- 有魅影但武器缺失 显示叹号
                end
            else
                SwitchWidget:SetActiveWidgetIndex(1)
            end
        end
    else
        self.Switch_Type01:SetActiveWidgetIndex(3)
        self.Switch_Type02:SetActiveWidgetIndex(3)
    end

    -- 设置轮盘图标
    self.Roulette:SetWheelIcon(nil, SquadInfo.WheelIndex or 1)

    -- 显示缺失提示
    self.IsMissing = not SquadInfo.CharId or not SquadInfo.MeleeWeaponId or not SquadInfo.RangedWeaponId
    self.Tips_Up:SetVisibility(self.IsMissing and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)  --and not self.Parent.IsShow
    if self.IsMissing then
        self.Tips_Up.Text_InputTips:SetText(GText("UI_Squad_Miss"))
    end

    if self.SquadIndex == 0 then
        return
    end
 
    if not SquadInfo.PhantomWeapon1Id or not SquadInfo.PhantomWeapon2Id or not SquadInfo.PetId then
        local Info = {}
        if not SquadInfo.PhantomWeapon1Id then
            Info.PhantomWeapon1 = ""
            --Info.Phantom1 = ""
        end
        if not SquadInfo.PhantomWeapon2Id then
            Info.PhantomWeapon2 = ""
            --Info.Phantom2 = ""
        end
        if not SquadInfo.PetId then
            Info.Pet = 0
        end

        self.Avatar:UpdateSquad(nil, self.SquadIndex, Info)
    end
end

function M:PlayFlashRed()
    if not self.SquadInfo.CharId then
        self.Character:PlayAnimation(self.Character.FlashRed)
    end
    if not self.SquadInfo.MeleeWeaponId then
        self.Melee:PlayAnimation(self.Character.FlashRed)
    end
    if not self.SquadInfo.RangedWeaponId then
        self.Range:PlayAnimation(self.Character.FlashRed)
    end
end




return M
