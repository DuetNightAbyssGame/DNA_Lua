--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Armory_PetAscend_C
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
local SkillUtils = require "Utils.SkillUtils"
local PreConsumeCount = 5
local Extra_Opacity_Add = 0.5
local M = Class({"BluePrints.UI.BP_EMUserWidget_C","BluePrints.Common.TimerMgr"})

function M:Init(Params)
    self.CurrentContent = nil
    self.Parent = Params.Parent
    self.Target = Params.Target
    for i = 1, 5 do
        local Star = self["WBP_Armory_Star_"..i]
        if IsValid(Star) then
            Star:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        end
    end
    self.IsMobile = CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile"
    self.SuccessToast.Text_Success:SetText(GText("Pet_BreakLevelUp_Success"))
    self.ListView_Item.BP_OnEntryInitialized:Add(self,self.OnListItemInited)
    self.Text_Limit:SetText(GText("Pet_Break_LevelReset"))
    self:InitPreConsumeList()
    self:InitBreakLevelStars(self.Target.BreakNum + 1)
    self:InitDetails()
    self:RefreshEntryList(true)
    self:RefreshBreakHintText()
end

function M:InitBreakLevelStars(BreakLevel)
    for i = 1, 5 do
        local Star = self["WBP_Armory_Star_"..i]
        if IsValid(Star) then
            Star.Main:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            if i < BreakLevel then
                Star.Switcher_Star:SetActiveWidgetIndex(0)
                -- Star:PlayAnimation(Star.Golden_In)
            elseif i == BreakLevel then
                Star:PlayAnimation(Star.Loop)
            else
                -- Star.Switcher_Star:SetActiveWidgetIndex(0)
                Star:PlayAnimation(Star.In)
            end
        end
    end
end

function M:SetBreakLevelStars(BreakLevel)
    local Stars = BreakLevel
    for i = 1, 5 do
        local Star = self["WBP_Armory_Star_"..i]
        if IsValid(Star) then
            if i <= Stars then
                Star:PlayAnimation(Star.Golden_In)
            else
                Star:PlayAnimation(Star.In)
            end
        end
    end
end

function M:Construct()
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        self.SizeBox_Item:SetMaxDesiredHeight(self.Hight_M)
    else
        self.SizeBox_Item:SetMaxDesiredHeight(self.Hight_P)
    end
    self:BindToAnimationFinished(self.LevelUp_In,{self,self.OnLevelUpInAnimFinished})
    self:BindToAnimationFinished(self.LevelUp_Out,{self,self.OnLevelUpOutAnimFinished})
end

function M:Destruct()
    self:UnbindAllFromAnimationFinished(self.LevelUp_In)
    self:UnbindAllFromAnimationFinished(self.LevelUp_Out)
end

function M:IsFull()
    return self.SelectedCount == self.PreConsumeCount
end

function M:IsEmpty()
    return self.SelectedCount == 0
end

function M:OnListItemInited(Content, EntryUI)
    self:OnPreConsumeListGenerated(Content, EntryUI)
end

function M:OnPetIntensifyDone(CostPetUniqueId, bLevelUp)
    local PreConsumeArray = self.ListWidgets
    for i=1, self.SelectedCount do
        local DelContent = PreConsumeArray[i].Content
        self:OnItemMinusBtnClick(DelContent)
    end
    if self:IsEmpty() then
        if bLevelUp then
            self:HidePreConsumeList()
            self.Text_Limit:SetText(GText("Pet_Break_LevelReset_Over"))
            self.Panel_Hint:SetVisibility(UIConst.VisibilityOp.Hidden)
            self:RefreshEntryList(false)
            self:PlayAnimation(self.LevelUp_In)
            AudioManager(self):PlayUISound(self, "event:/ui/common/pet_star_add", nil, nil)
            local Player = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
            AudioManager(self):StopSound(Player, "PetBreakLevelUp")
            local PetData = self.Target:Data()
            local PetNameTag = PetData and PetData.PetNameTag
            AudioManager(self):PlayPetVoice(Player, PetNameTag, "vo_upgrade", "PetBreakLevelUp")

            self:SetBreakLevelStars(self.Target.BreakNum)
            self.Parent.WidgetSwitcher_Hint:SetVisibility(UIConst.VisibilityOp.Collapsed)
        else
            self:ReInitAfterIntensify()
        end
    end
end

function M:ReInitAfterIntensify()
    self:InitPreConsumeList()
    self:InitDetails()
end

function M:HidePreConsumeList()
    self.PreConsumeCount = 0
    self.PreConsumeList:Clear()
    for i= 1, PreConsumeCount do
        local EmptyContent = self:CreateSlotContent(i)
        self.PreConsumeList:Add(EmptyContent)
    end
    local PreConsumeArray = self.ListWidgets
    for i,Widget in pairs(PreConsumeArray) do
        local NewContent = self.PreConsumeList[i]
        NewContent.bAllUseAsyncLoadWidget = false
        Widget:Init(NewContent)
        self:OnPreConsumeListGenerated(NewContent, Widget)
    end
end

function M:UpdatePreConsumeList(PreConsumeList)
    local PreConsumeArray = self.ListWidgets
    for i,Widget in pairs(PreConsumeArray) do
        local NewContent = PreConsumeList[i]
        NewContent.bAllUseAsyncLoadWidget = false
        Widget:Init(NewContent)
        self:OnPreConsumeListGenerated(NewContent, Widget)
    end
    if self.CurrentWidget then
        self.CurrentWidget.Item:PlayAnimation(self.CurrentWidget.Item.Hover)
    end
end

function M:InitPreConsumeList(bSkipAnim)
    self.SelectedCount = 0
    self.PreConsumeCount = 1
    self.PreConsumeList:Clear()
    for i= 1, PreConsumeCount do
        local EmptyContent = self:CreateSlotContent(i)
        self.PreConsumeList:Add(EmptyContent)
    end
    self.ListView_Item:ClearListItems()
    for _,Content in pairs(self.PreConsumeList) do
        Content.bAllUseAsyncLoadWidget = false
        self.ListView_Item:AddItem(Content)
    end
    self.ListWidgets = {}
    -- if not bSkipAnim then
    --     self._ListAnimTimer = UIUtils.PlayListViewFramingInAnimation(self, self.ListView_Item, {bInteractableInAnim = false})
    -- end
end

function M:CreateSlotContent(i)
    local EmptyContent = NewObject(UIUtils.GetCommonItemContentClass())
    EmptyContent.Index = i
    self:ReInitSlotContent(EmptyContent)
    return EmptyContent
end

function M:ReInitSlotContent(Content)
    if Content.Index<=self.PreConsumeCount then
        Content.NotInteractive = false
        Content.OnMouseButtonUpEvents = {Obj = self, Callback = function()
            if self.IsMobile and Content.SelfWidget then
                Content.SelfWidget.Item:PlayAnimation(Content.SelfWidget.Item.UnHover)
            end
            if Content.Uuid then
                self:OnItemMinusBtnClick(Content)
            else
                if(self.IsPreviewLevelMax)then
                    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("Max_Level_Achieved"))
                elseif(not self:HasAnyChoiceOfContent())then
                    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Armory_Toast_NoMaterial"))
                else
                    if self.Parent and self.Parent.bListExpand then
                        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Armory_Toast_Material"))
                    end
                end
                self:OnExpandList(true, false)
                --播放未装配格子点击音效
                AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
            end
        end}
        Content.OnMouseEnterEvent = {Obj = self, Callback = function()
            self.CurrentContent = Content
        end}
        Content.OnMouseLeaveEvent = {Obj = self, Callback = function()
            self.CurrentContent = nil
        end}
    else
        Content.NotInteractive = true
        Content.OnMouseButtonUpEvents = nil
    end
end

function M:HasAnyChoiceOfContent()
    local AllParentContents = self.Parent:GetAllListContent()
    local Result = false
    for key, value in pairs(AllParentContents or {}) do
        if(not value.IsLocked)then
            Result = true
            break
        end
    end
    return Result
end

function M:OnPreConsumeListGenerated(Content ,Widget) 
    ---@type TArray<WBP_Com_item_Universal_L_C>
    local Index = Content.Index
    self.ListWidgets[Index] = Widget
    local LastWidget = Index>1 and self.ListWidgets[Index-1] or nil
    if Content.Index <= self.PreConsumeCount then
        if LastWidget then
            LastWidget:SetNavigationRuleExplicit(EUINavigation.Right, Widget)
            Widget:SetNavigationRuleExplicit(EUINavigation.Left, LastWidget)
        else
            Widget:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
        end
        Widget:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    else
        Widget:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
        Widget:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    end
    if not Content.UnitId then
        Widget:SetAdd(not Content.NotInteractive)
        Widget:SetItemMinus(false)
    else
        Widget:SetAdd(false)
        Widget:SetItemMinus(true)
        local MinusBtn = Widget.MinusWidget and Widget.MinusWidget.Btn_Minus
        if not MinusBtn then return end
        MinusBtn:BindEventOnClicked(self, self.OnItemMinusBtnClick, Content)
    end
end

function M:CopyItemToConsumeList(AddContent)
    self.SelectedCount = self.SelectedCount + 1
    self.PreConsumeList:Clear()
    local PreConsumeArray = self.ListWidgets
    local Target = nil
    for i, Widget in pairs(PreConsumeArray) do
        local Content = Widget.Content
        if i == self.SelectedCount then
            if self:IsCommonResource(AddContent.Uuid) then
                Target = self.Parent._Avatar.Resources[AddContent.UnitId]
                assert(Target and Target.Count>0, "通用宠物升级素材不存在或已耗尽")
                Content = ArmoryUtils:NewResourceItemContent(Target)
                Content.Count = 1
                Content.Uuid = AddContent.Uuid
                Content.Index = i 
            else
                Target = ArmoryUtils:GetPet(AddContent.Uuid)
                assert(Target, AddContent.Uuid.."，， 这个宠物数据已经失效了，请换新号去测")
                -- 隐式调用了ArmoryUtils的NewXXXItemContent方法
                Content = ArmoryUtils:NewPetItemContent(Target)
                Content.Index = i
            end
            self:ReInitSlotContent(Content)
        end
        self.PreConsumeList:Add(Content)
    end
    self:UpdatePreConsumeList(self.PreConsumeList)
    if self.Parent then
        self.Parent:SetContentSelected(AddContent, true)
    end
    -- self:UpdateAutoBtnState()
    self:UpdateDetails()
end 

function M:OnItemMinusBtnClick(DelContent)
    if not DelContent then
        return
    end
    self.PreConsumeList:Clear()
    local PreConsumeArray = self.ListWidgets
    for i, Widget in pairs(PreConsumeArray) do
        local Content = Widget.Content
        if Content.Index == DelContent.Index then
            goto continue
        end
        if Content.Index > DelContent.Index then
            Content.Index = Content.Index - 1
            self:ReInitSlotContent(Content)
        end
        self.PreConsumeList:Add(Content)
        ::continue::
    end
    for i = self.PreConsumeList:Num()+1, PreConsumeCount do
        local EmptyContent = self:CreateSlotContent(i)
        EmptyContent.bEmpty = true
        self.PreConsumeList:Add(EmptyContent)
    end
    self.SelectedCount = self.SelectedCount - 1
    self:UpdatePreConsumeList(self.PreConsumeList)
    if self.Parent then
        self.Parent:SetContentSelected(DelContent, false)
    end
    self:UpdateAutoBtnState()
    if self.SelectedCount ==0 then
        self:InitDetails(true)
    else
        self:UpdateDetails()
    end
end

function M:FindSelectedContent(Uuid)
    local PreConsumeArray = self.ListWidgets
    for i, Widget in pairs(PreConsumeArray) do
        local Content = Widget.Content
        if Content.Uuid and Content.Uuid == Uuid then
            return Content
        end
    end
    return nil
end

function M:GetCurrentContent()
    return self.CurrentContent
end

function M:RemoveCurrentContent()
    local Content = self:GetCurrentContent()
    if not Content or not Content.Uuid then
        return
    end
    self:OnItemMinusBtnClick(Content)
end

function M:UpdateAutoBtnState(bAutoSelect)
    self.Parent:SwitchAutoBtnState(bAutoSelect)
end

---@param Target Pet
function M:UpdateDetails()
    local Target = self.Target
    self.Parent.Btn_Enhance:ForbidBtn(self.SelectedCount == 0)
    self.Text_Num:SetText(self.SelectedCount)
    return true
end

function M:OnAutoSelectClick(SelectContents)
    if self.bAutoSelecting then
        return
    end
    self.bAutoSelecting = true
    self:ClearListItems()
    for i, Content in pairs(SelectContents) do
        if Content.Uuid and not Content.IsLocked then
            self:CopyItemToConsumeList(Content)
        end
    end
    if not self.Parent.bListExpand then
        self.ListView_Item:NavigateToIndex(0)
    end
    self:UpdateAutoBtnState(true)
    self.bAutoSelecting = false
end

function M:OnClearClick()
    if self.bClearing then
        return
    end
    self.bClearing = true
    self:ClearListItems()
    if not self.Parent.bListExpand then
        self.ListView_Item:NavigateToIndex(0)
    end
    self:UpdateAutoBtnState()
    self:InitDetails()
    self.bClearing = false
end

function M:ClearListItems()
    self.PreConsumeList:Clear()
    local PreConsumeArray = self.ListWidgets
    for i= PreConsumeCount, 1, -1 do 
        local Content = PreConsumeArray[i].Content
        if self.Parent then
            self.Parent:SetContentSelected(Content, false)
        end
        local EmptyContent = self:CreateSlotContent(PreConsumeCount-i+1)
        self.PreConsumeList:Add(EmptyContent)
    end
    self:UpdatePreConsumeList(self.PreConsumeList)
    self.SelectedCount = 0
end

function M:RevertLastSelect()
    local PreConsumeArray = self.ListWidgets
    local FinalContent = PreConsumeArray[self.SelectedCount].Content
    self:OnItemMinusBtnClick(FinalContent)
end

function M:InitDetails(CallFromUpgrade)
    local Target = self.Target
    self.Parent.Btn_Enhance:ForbidBtn(self.SelectedCount == 0)
    self.Text_Ascend:SetText(GText("Text_Ascend")..Target:GetNextMaxLevel())
    self.Text_Same:SetText(GText("Text_Same"))
    self.Text_Num:SetText(0)
    self.Text_Total:SetText(1)

    if Target:IsMaxBreak() then
        --已突破至满阶
        return
    end
    local BreakData = Target:BreakData()
    if Target.BreakNum < #BreakData-1 then
        self.Text_Limit:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    elseif Target.BreakNum == #BreakData-1 then
        --还差一阶突破至满阶
        if not CallFromUpgrade then
            if not self.HB_Limit then return end
            self.HB_Limit:SetVisibility(UIConst.VisibilityOp.Collapsed)
            self.Text_Limit:SetVisibility(UIConst.VisibilityOp.Hidden)
        end
    else
        self.HB_Limit:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Text_Limit:SetVisibility(UIConst.VisibilityOp.Hidden)
    end
end

function M:RefreshEntryList(bNotEnhanced)
    local Target = self.Target
    local BattleData = Target:BattleData()
    local BreakData = Target:BreakData()
    local SkillLevel = Target:GetSkillLevel()

    self.List_Item:ClearListItems()
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    -- 等级上限
    Content.bEnhanced = not bNotEnhanced
    Content.Name = GText("Attr_LevelLimit_Name")
    Content.Value = BreakData[Target.BreakNum].PetBreakLevel
    Content.CmpValue = BreakData[bNotEnhanced and Target.BreakNum+1 or Target.BreakNum].PetBreakLevel
    if not Content.CmpValue then
        Content.CmpValue = Content.Value
    end
    self.List_Item:AddItem(Content)
    -- 词条数量
    Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.bEnhanced = not bNotEnhanced
    Content.Name = GText("Pet_Affix_Activate_Num")
    Content.Value = BreakData[Target.BreakNum].EntryNum
    Content.CmpValue = BreakData[bNotEnhanced and Target.BreakNum+1 or Target.BreakNum].EntryNum
    self.List_Item:AddItem(Content)
    -- 被动技能
    local PassiveDesc = ArmoryUtils:GenPetPassiveEffectDesc(BattleData, SkillLevel, bNotEnhanced and SkillLevel+1 or nil)
    if PassiveDesc ~= "" then
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.bEnhanced = not bNotEnhanced
        Content.Desc = PassiveDesc
        Content.Name = GText("UI_Armory_Pet_Passive")
        Content.Value = "Lv."..SkillLevel
        Content.CmpValue = "Lv."..(bNotEnhanced and SkillLevel+1 or SkillLevel)
        self.List_Item:AddItem(Content)
    end
    -- 主动技能
    local SkillDesc = SkillUtils.GetSkillDesc(BattleData.SupportSkillId, SkillLevel, bNotEnhanced and SkillLevel+1 or nil)
    if SkillDesc ~= "" then
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.bEnhanced = not bNotEnhanced
        Content.Desc = SkillDesc
        Content.Name = GText("UI_Armory_Pet_Positive")
        Content.Value = "Lv."..SkillLevel
        Content.CmpValue = "Lv."..(bNotEnhanced and SkillLevel+1 or SkillLevel)
        self.List_Item:AddItem(Content)
    end
    -- 主动技能CD
    local SupportSkillId = BattleData.SupportSkillId
    local CDValue = DataMgr.Skill[SupportSkillId][bNotEnhanced and SkillLevel or SkillLevel-1][0].CD
    local CDCmpValue = DataMgr.Skill[SupportSkillId][bNotEnhanced and SkillLevel+1 or SkillLevel][0].CD
    if CDValue ~= CDCmpValue then
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.bEnhanced = not bNotEnhanced
        Content.Name = GText("UI_Armory_Pet_Positive").."CD"
        Content.Value = CDValue
        Content.CmpValue = CDCmpValue
        self.List_Item:AddItem(Content)
    end
end

function M:RefreshBreakHintText()
    local BreakNum = self.Target.BreakNum
    local PetId = self.Target["PetId"]
    local Avatar = GWorld:GetAvatar()
    local PetBrekId = "PetBreak." .. PetId .. "." .. BreakNum
    if not Avatar.CollectRewardExpRecord[PetBrekId] then
        local PetBreakData = DataMgr.PetBreak[PetId]
        local BreakNumData = PetBreakData and PetBreakData[BreakNum]
        local RewardExp = BreakNumData and BreakNumData.CollectRewardExp or 0
        if RewardExp <= 0 then
            return
        end
        local PetName = GText(DataMgr.Pet[PetId].Name)
        local BreakHintText = string.format(GText("UI_Armory_PetBreakExp"), PetName, BreakNum + 1, RewardExp)
        self.Parent.Text_ExpHint:SetText(BreakHintText)
        self.Parent.Text_ExpHint:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Parent.WidgetSwitcher_Hint:SetActiveWidgetIndex(1)
        self.Parent.WidgetSwitcher_Hint:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
        self.Parent.WidgetSwitcher_Hint:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:GetConsumeIds()
    local PreConsumeArray = self.ListWidgets
    local ConsumeIds = {}
    for i, Widget in pairs(PreConsumeArray) do
        local Content = Widget.Content
        table.insert(ConsumeIds,Content.Uuid)
    end
    return ConsumeIds
end

function M:GetConsumeContents()
    local PreConsumeArray = self.ListWidgets
    local ConsumeContents = {}
    for i, Widget in pairs(PreConsumeArray) do
        local Content = Widget.Content
        table.insert(ConsumeContents,Content)
    end
    return ConsumeContents
end

function M:IsCommonResource(Uuid)
    if not Uuid then
        return false
    end
    return type(Uuid) == "number" and Uuid < 0
end

function M:OnExpandList(bExpandList, bRefreshList)
    if self.Parent then
        if self.Parent.bItemDetailsShowed then
            self.Parent:ShowItemDetails(false)
        end
        self.Parent:OnExpandList(bExpandList, bRefreshList)
        self.Parent:ReNavigateToListItem(false, true)
    end
end

function M:OnLevelUpInAnimFinished()
    self:AddTimer(1.5, function()
            self:PlayAnimation(self.LevelUp_Out)
        -- end
    end,false,0,nil,true)
    -- 播槽位解锁动画
    self:AddTimer(0.5, function()
        if self.Parent then
            self.Parent:CheckAndPlayEntryItemLock()
        end
    end,false,0,nil,true)
end

function M:OnLevelUpOutAnimFinished()
    self.Panel_Hint:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)

    if self.Parent then
        self.Parent:OnBreakLevelUpAnimFinishedCallback()
    end
end


return M
