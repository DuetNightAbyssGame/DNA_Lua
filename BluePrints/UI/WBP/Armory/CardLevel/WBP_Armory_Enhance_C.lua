--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local SkillUtils = require "Utils.SkillUtils"
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"

---@type WBP_Armory_Weapon_CardLevelDialog_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C","BluePrints.Common.TimerMgr","BluePrints.Common.DelayFrameComponent"})

--function M:Initialize(Initializer)
--end

function M:Construct()
    local Platfrom = CommonUtils.GetDeviceTypeByPlatformName(self)
    self.SuccessToast:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.SuccessToast.Text_Success:SetText(GText("UI_WeaponStrength_UpGrade"))
    self.Text_Same:SetText(GText("Text_Same"))
    self.Text_Level:SetText(GText("UI_WeaponStrength_Level"))
    self:BindToAnimationFinished(self.In, {self, self.OnInAnimFinished})
    self:BindToAnimationFinished(self.Out, {self, self.OnOutAnimFinished})
    self:BindToAnimationFinished(self.LevelUp_In,{self,self.OnLevelUpAnimFinished})
	EventManager:AddEvent(EventID.OnWeaponGradeLevelUp, self, self.OnWeaponGradeLevelUp)
    EventManager:AddEvent(EventID.OnUpdateBagItem, self, self.OnBagItemLockedOrUnlocked)
    if Platfrom == "Mobile" and self.VB_Main then
        local Slot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.VB_Main)
        Slot:SetPosition(self.Offset_M)
    end
    self.IsFirstAddItem = true
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
end

function M:Destruct()
	EventManager:RemoveEvent(EventID.OnWeaponGradeLevelUp, self)
	EventManager:RemoveEvent(EventID.OnUpdateBagItem, self)
    self:UnbindAllFromAnimationFinished(self.In)
    self:UnbindAllFromAnimationFinished(self.Out)
    self:UnbindAllFromAnimationFinished(self.LevelUp_In)
end

---@param Parent WBP_Armory_CardLevel_P_C|WBP_Armory_CardLevel_M_C
function M:Init(Params)
    self.Parent = Params.Parent
    self.TargetWeapon = Params.Target
    self.Type = Params.Type
    self.Tag = Params.Tag
    self.IsPreviewMode = Params.IsPreviewMode or false
    local Data = DataMgr.WeaponCardLevel[self.TargetWeapon.WeaponId]
    self.MaxGradeLevel = Data and Data.CardLevelMax or 5
    self.MaxItemCount = self.MaxGradeLevel
    self:FillEmptyItems(self.MaxItemCount,true)
    self.AllWeapons = {}
    self:ClearItems()
    local Avatar = GWorld:GetAvatar()
    self.CurrentPlayerWeapon = Avatar.Weapons[Avatar[self.Tag..self.Type]]
    for Uuid, Weapon in pairs(Avatar.Weapons) do
        if(Weapon.WeaponId == self.TargetWeapon.WeaponId and Uuid ~= self.TargetWeapon.Uuid)then
            self.AllWeapons[Uuid] = Weapon
        end
    end
    self:UpdateWeaponGradeLevelInfo()
    self:InitUI()
end

function M:InitUI()
    if self.IsPreviewMode then
        self.Preview:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Preview:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:GetAllWeapons()
    return self.AllWeapons
end

function M:GetWeaponTag()
    return self.Tag
end

function M:GetChosenContents()
    return self.Parent.ConsumedContentsArray
end

function M:GetCurrentWeapon()
    return self.CurrentPlayerWeapon
end

function M:FillEmptyItems(ItemCount,bShowAddIcon)
    for i=self.MaxItemCount - ItemCount + 1,self.MaxItemCount do
        local Obj = {}
        Obj.Parent = self
        Obj.bAdd = bShowAddIcon
        Obj.OnMouseButtonDownEvent = {Obj = self, Callback = function()
            self:OnListItemMouseDown(Obj)
        end,Params = Obj}
        Obj.OnMouseButtonUpEvents = {Obj = self, Callback = function()
            self:OnListItemMouseUp(Obj)
        end,Params = Obj}
        local ItemWidgetName = "Item_" .. i
        if(self[ItemWidgetName])then
            -- self[ItemWidgetName]:OnListItemObjectSet(Obj)
            self[ItemWidgetName]:Init(Obj)
            self:OnListEntryInitialized(Obj,self[ItemWidgetName])
        end
    end
end

function M:OnListEntryInitialized(Content,Widget)
    if not Widget then return end
    if(Content.Uuid)then
        Widget:SetItemMinus(true)
        if Widget.MinusWidget and Widget.MinusWidget.Btn_Minus then
            Widget.MinusWidget.Btn_Minus:UnBindEventOnClicked(self, self.OnListItemClicked)
        end
        Widget.MinusWidget.Btn_Minus:BindSingleEventOnClicked(self, self.OnListItemClicked, Content)
    else
        Widget:SetAdd(not Content.NotInteractive)
        Widget:SetItemMinus(false)
    end
end

function M:UpdateWeaponGradeLevelInfo()
    local AddLevel = 0
    for _, value in pairs(self.Parent.ConsumedContentsMap) do
        if value.ItemType == "Resource" then
            -- 资源类型：使用ConsumedCount
            local ConsumedCount = value.ConsumedCount or 1
            AddLevel = AddLevel + ConsumedCount
        else
            -- 武器类型：使用原有逻辑
            AddLevel = AddLevel + value.GradeLevel + 1
        end
    end
    local CurrentGradeLevel = self.TargetWeapon.GradeLevel
    self.CurrentGradeLevel = CurrentGradeLevel
    local ComparedGradeLevel = CurrentGradeLevel + AddLevel
    self.ComparedGradeLevel = ComparedGradeLevel
    self.Text_Level_Now:SetText(CurrentGradeLevel)
    self.Text_Level_Preview:SetText(ComparedGradeLevel)

    local SkillDesc
    if(ComparedGradeLevel == CurrentGradeLevel)then
        self.Text_Level_Now:SetText(CurrentGradeLevel)
        if(CurrentGradeLevel >= self.MaxGradeLevel)then
            SkillDesc = SkillUtils.CalcWeaponPassiveEffectsDesc(self.TargetWeapon,CurrentGradeLevel)
        else
            if(self.IsPreviewMode)then
                self.Preview:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
                SkillDesc = SkillUtils.CalcWeaponPassiveEffectsDesc(self.TargetWeapon,CurrentGradeLevel)
            else
                self.Preview:SetVisibility(UIConst.VisibilityOp.Collapsed)
                SkillDesc = SkillUtils.CalcWeaponPassiveEffectsDesc(self.TargetWeapon,CurrentGradeLevel,CurrentGradeLevel + 1)
            end
        end
    else
        if(ComparedGradeLevel >= self.MaxGradeLevel)then
            ComparedGradeLevel = self.MaxGradeLevel
        end
        self.Text_Level_Now:SetText(CurrentGradeLevel)
        self.Text_Level_Preview:SetText(ComparedGradeLevel)
        SkillDesc = SkillUtils.CalcWeaponPassiveEffectsDesc(self.TargetWeapon,CurrentGradeLevel,ComparedGradeLevel)
    end
    local CurrentSkillDesc = SkillUtils.CalcWeaponPassiveEffectsDesc(self.TargetWeapon,CurrentGradeLevel)
    self.Parent.SubWidget.Text_Detail:SetText(CurrentSkillDesc)
    if(self.IsPlayLevelUpAnim)then
        if CurrentSkillDesc then
            self.Text_Detail:SetText(CurrentSkillDesc)
        else
            DebugPrint(ErrorTag, "::PassiveEffectsDesc is nil,请检查WeaponId", self.TargetWeapon.WeaponId)
        end
    else
        if SkillDesc then
            if AddLevel > 0 then
                self.Text_Detail:SetText(SkillDesc)
            else
                self.Text_Detail:SetText(GText("UI_Armory_NextStage")..": "..SkillDesc)
            end
        else
            DebugPrint(ErrorTag, "::PassiveEffectsDesc is nil,请检查WeaponId", self.TargetWeapon.WeaponId)
        end
    end
    if(self.IsPreviewMode)then
        self.Preview:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Preview:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if ComparedGradeLevel >= self.MaxGradeLevel then
        self:SetMaxLevelBgPreview(true)
    else
        self:SetMaxLevelBgPreview(false)
    end
    
    self:UpdateWeaponGradeLevelButtonState()
    self:UpdateWeaponGradeHintText(ComparedGradeLevel)
end

function M:UpdateWeaponGradeLevelButtonState()
    if(self.CurrentGradeLevel == self.ComparedGradeLevel)then
        self.Parent.Btn_Enhance:ForbidBtn(true)
        if(self.CurrentGradeLevel >= self.MaxGradeLevel)then
            self.Parent.Btn_Auto:ForbidBtn(true)
        else
            self.Parent.Btn_Auto:ForbidBtn(false)
        end
    else
        self.Parent.Btn_Auto:ForbidBtn(false)
        self.Parent.Btn_Enhance:ForbidBtn(false)
    end
    --满熔炼状态
    if self.CurrentGradeLevel >= self.MaxGradeLevel then
        self.Preview:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Parent.Panel_Limit:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Parent.SubWidget.WidgetSwitcher_State:SetActiveWidgetIndex(1)
        self.WB_Item:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Panel_Hint:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Text_Level:SetText(GText("UI_WeaponStrength_Level").."Max")
        self:SetMaxLevelBg(true)
        self.Parent.SubWidget:SetMaxLevelBg(true)
    else
        if self.IsPreviewMode then self.Preview:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible) end
        self.Parent.Panel_Limit:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Parent.SubWidget.WidgetSwitcher_State:SetActiveWidgetIndex(0)
        self.WB_Item:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Panel_Hint:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        -- self:SetMaxLevelBg(false)
        self.Parent.SubWidget:SetMaxLevelBg(false)
    end
    self.Parent.SubWidget.Num_EnhanceLevel:SetText(self.CurrentGradeLevel)
    self.Parent.SubWidget:EnhanceItem(self.CurrentGradeLevel)
end

function M:UpdateWeaponGradeHintText(ComparedGradeLevel)
    local Avatar = GWorld:GetAvatar()
    local ArchiveType = (self.Tag == "Melee") and 1002 or 1003
    local WeaponId= self.TargetWeapon.WeaponId
    local ArchiveInfo = Avatar.Archives[ArchiveType].ArchiveInfo[WeaponId]
    local ArchiveGradeLevel = ArchiveInfo and ArchiveInfo[2] or 0
    ComparedGradeLevel = math.clamp(ComparedGradeLevel, 0, self.MaxGradeLevel)
    if ComparedGradeLevel > ArchiveGradeLevel then    
        local RewardExp = (ComparedGradeLevel - ArchiveGradeLevel) * DataMgr.WeaponCardLevel[WeaponId].CollectRewardExp
        self.Parent.Text_ExpHint:SetText(string.format(GText("UI_Armory_WeaponCardUpExp"), ComparedGradeLevel, RewardExp))
        self.Parent.Text_ExpHint:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Parent.WidgetSwitcher_Hint:SetActiveWidgetIndex(1)
        self.Parent.WidgetSwitcher_Hint:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
        self.Parent.WidgetSwitcher_Hint:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:BindEvents(EventReceiver,Events)
    self.EventReceiver = EventReceiver
    Events = Events or {}
    self.Event_OnConsumedItemChanged = Events.OnConsumedItemChanged
    self.Event_OnWeaponGradeLevelUp = Events.OnWeaponGradeLevelUp
end

function M:OnListItemClicked(Content)
    if(Content.Uuid)then
        -- 检查是否为资源类型，使用减少逻辑
        if Content.ItemType == "Resource" then
            self:ReduceResourceCount(Content)
        else
            -- 武器类型直接移除
            self:RemoveItem(Content)
        end
    else
        if(self.ComparedGradeLevel >= self.MaxGradeLevel)then
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("Max_Level_Achieved"))
        else
            local CanAddItem = false
            
            -- 检查是否有可用的武器
            for Uuid, Weapon in pairs(self.AllWeapons) do
                if(not Weapon:IsLock() and not self.Parent.ConsumedContentsMap[Uuid])then
                    CanAddItem = true
                    break
                end
            end
            
            -- 如果没有可用武器，检查是否有可用的资源
            if not CanAddItem then
                for Uuid, Content in pairs(self.Parent.ContentsMap) do
                    if Content.ItemType == "Resource" and Content.Count > 0 then
                        local ExistingObj = self.Parent.ConsumedContentsMap[Uuid]
                        if not ExistingObj or ExistingObj.ConsumedCount < Content.Count then
                            CanAddItem = true
                            break
                        end
                    end
                end
            end
            if(not CanAddItem)then
                UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Armory_Toast_NoMaterial"))
            else
                if self.Parent.bListExpand then
                    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Armory_Toast_Material"))
                end
            end
        end
    end
    if not self.Parent.bListExpand then
        self.Parent:OnExpandList(true, true)
        self.Parent:ReNavigateToListItem()
        -- if self.Parent.IsAutoFilled then
            self.Parent:OnChosenItemChanged(self.Parent.ConsumedContentsArray)
        -- end
    end
    self.Parent:UpdateAutoButtonText()
end

function M:ClearItems()
    self.Parent.ConsumedContentsMap = {}
    self.Parent.ConsumedContentsArray = {}
    self:UpdateConsumedItems({})
end

function M:RemoveItem(Content)
    local RemoveIdx
    local RemovedItem
    for index, value in ipairs(self.Parent.ConsumedContentsArray) do
        if(value.Uuid == Content.Uuid)then
            RemoveIdx = index
            RemovedItem = value
            break
        end
    end
    if(RemoveIdx and RemovedItem)then
        -- 移除前触发选中状态更新（让父组件取消选中样式
        if self.Parent.OnChosenItemChanged then
            -- 创建一个临时数组，不包含即将移除的项
            local TempArray = {}
            for i, item in ipairs(self.Parent.ConsumedContentsArray) do
                if i ~= RemoveIdx then
                    table.insert(TempArray, item)
                end
            end
            self.Parent:OnChosenItemChanged(TempArray)
        end
        
        self.Parent.ConsumedContentsMap[self.Parent.ConsumedContentsArray[RemoveIdx].Uuid] = nil
        table.remove(self.Parent.ConsumedContentsArray,RemoveIdx)
        if(self.Parent.ConsumedContentsArray and #self.Parent.ConsumedContentsArray == 0)then
            self.IsPreviewMode = false
            self.Parent:UpdateAutoButtonText()
        end
        self:UpdateConsumedItems(self.Parent.ConsumedContentsArray)
    end
end

function M:AddItemToLast(Content)
    self.IsPreviewMode = true
    
    if Content.ItemType == "Resource" then
        if(self.ComparedGradeLevel >= self.MaxGradeLevel)then
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_WeaponStrength_CantAdd"))
        elseif Content.Count <= 0 then
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_WeaponStrength_NoResource"))
        else
            local Obj = ArmoryUtils:CopyCharOrWeaponItemContent(Content)
            Obj.Parent = self
            Obj.IsNew = false
            Obj.bAdd = false
            Obj.bMinus = true
            Obj.ConsumedCount = 1  -- 消耗的数量，从1开始
            Obj.Count = 1
            Obj.OnMouseButtonDownEvent = {Obj = self, Callback = function() self:OnListItemMouseDown(Obj) end, Params = Obj}
            Obj.OnMouseButtonUpEvents = {Obj = self, Callback = function() self:OnListItemMouseUp(Obj) end, Params = Obj}
            Obj.bSyncLoadIcon = true
            self.Parent.ConsumedContentsMap[Obj.Uuid] = Obj
            table.insert(self.Parent.ConsumedContentsArray,Obj)
            
            self:UpdateConsumedItems(self.Parent.ConsumedContentsArray)
        end
    else
        local Weapon = self.AllWeapons[Content.Uuid]
        if(self.ComparedGradeLevel >= self.MaxGradeLevel)then
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_WeaponStrength_CantAdd"))
        elseif(Weapon:IsLock())then
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_WeaponStrength_Locked"))
        elseif(self.CurrentPlayerWeapon.Uuid == Content.Uuid)then
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_WeaponCardLevel_Popup_PlayerEquiped"))
        else
            local Obj = ArmoryUtils:CopyCharOrWeaponItemContent(Content)
            Obj.Parent = self
            Obj.IsNew = false
            Obj.bAdd = false
            Obj.bMinus = true
            Obj.OnMouseButtonDownEvent = {Obj = self, Callback = function() self:OnListItemMouseDown(Obj) end, Params = Obj}
            Obj.OnMouseButtonUpEvents = {Obj = self, Callback = function() self:OnListItemMouseUp(Obj) end, Params = Obj}
            Obj.bSyncLoadIcon = true
            self.Parent.ConsumedContentsMap[Obj.Uuid] = Obj
            table.insert(self.Parent.ConsumedContentsArray,Obj)
            self:UpdateConsumedItems(self.Parent.ConsumedContentsArray)
        end
    end
    
    -- 第一次添加物品时，导航到当前选中的item
    if (self.IsFirstAddItem) then
        self.IsFirstAddItem = false
        self.Parent:ReNavigateToListItem()
    end
end

-- 资源类型增加数量
function M:AddResourceCount(Content)
    local ExistingObj = self.Parent.ConsumedContentsMap[Content.Uuid]
    if not ExistingObj then
        self:AddItemToLast(Content)
        return
    end
 
    if(self.ComparedGradeLevel >= self.MaxGradeLevel)then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_WeaponStrength_CantAdd"))
        return
    end
    if ExistingObj.ConsumedCount >= Content.Count then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_WeaponStrength_NoResource"))
        return
    end
    
    ExistingObj.ConsumedCount = ExistingObj.ConsumedCount + 1
    ExistingObj.Count = ExistingObj.Count + 1
    
    self:UpdateConsumedItems(self.Parent.ConsumedContentsArray)
end

-- 资源类型减少数量
function M:ReduceResourceCount(Content)
    local ExistingObj = self.Parent.ConsumedContentsMap[Content.Uuid]
    if not ExistingObj then
        return
    end
    
    if ExistingObj.ConsumedCount > 1 then
        -- 数量大于1，减少1个
        ExistingObj.ConsumedCount = ExistingObj.ConsumedCount - 1
        ExistingObj.Count = ExistingObj.Count - 1
        
        -- 更新消耗列表显示
        self:UpdateConsumedItems(self.Parent.ConsumedContentsArray)
    else
        -- 数量恰好为1，完全移除
        self:RemoveItem(Content)
    end
end

function M:OnListItemMouseDown(Content)
    Content.bIsMouseButtonDown = true
end

function M:OnListItemMouseUp(Content)
    if(Content.bIsMouseButtonDown)then
        self:OnListItemClicked(Content)
    end
end

function M:UpdateConsumedItems(Contents)
    for i, Content in ipairs(Contents) do
        local ItemWidgetName = "Item_" .. i
        if(self[ItemWidgetName])then
            -- self[ItemWidgetName]:OnListItemObjectSet(Content)
            self[ItemWidgetName]:Init(Content)
            self:OnListEntryInitialized(Content,self[ItemWidgetName])
        end
    end
    self:FillEmptyItems(self.MaxItemCount-#Contents,true)
    self:UpdateWeaponGradeLevelInfo()
    if(self.Event_OnConsumedItemChanged)then
        self.Event_OnConsumedItemChanged(self.EventReceiver,Contents)
    end
    self.Text_Num:SetText(#self.Parent.ConsumedContentsArray)
end

function M:OnForbiddenAutoFillBtnClicked()
end

---点击确认
-- function M:OnConfirmBtnClicked()
--     if(not self.Parent.ConsumedContentsMap or not next(self.Parent.ConsumedContentsMap))then
--         return
--     end
--     local Avatar = GWorld:GetAvatar()
--     local bChosenWeaponHasAssisterId = false
--     local bChosenWeaponHasLvup = false
--     local PreviewLevel = self.TargetWeapon.GradeLevel
--     local ConsumeWeaponUuids = {}
--     for _, value in pairs(self.Parent.ConsumedContentsMap) do
--         table.insert(ConsumeWeaponUuids,value.Uuid)
--         local Weapon = Avatar.Weapons[value.Uuid]
--         bChosenWeaponHasAssisterId = bChosenWeaponHasAssisterId or (Weapon.AssisterId and Weapon.AssisterId~=0)
--         bChosenWeaponHasLvup  = bChosenWeaponHasLvup or Weapon.Level > 1
--         PreviewLevel = PreviewLevel + Weapon.GradeLevel + 1
--     end

--     local Params = {RightCallbackFunction = function()
--         self.Parent:BlockAllUIInput(true)
--         Avatar:UpWeaponGradeLevel(self.TargetWeapon.Uuid,self.TargetWeapon.GradeLevel,ConsumeWeaponUuids)
--     end,}
--     local OverflowLevel = PreviewLevel - self.MaxGradeLevel
--     if( OverflowLevel > 0)then
--         Params.ShortText = string.format(GText("UI_WeaponCardLevel_Popup_Overflow"), OverflowLevel)
--     elseif(bChosenWeaponHasAssisterId)then
--         Params.ShortText = GText("UI_WeaponCardLevel_Popup_Equiped")
--     elseif(PreviewLevel > self.TargetWeapon.GradeLevel + #ConsumeWeaponUuids)then
--         Params.ShortText = string.format(GText("UI_WeaponCardLevel_Popup_HaveMax"), PreviewLevel)
--     elseif(bChosenWeaponHasLvup)then
--         Params.ShortText = GText("UI_WeaponCardLevel_Popup_HaveUpgraded")
--     else
--         Params.ShortText = GText("UI_WeaponCardLevel_Popup_Normal")
--     end
--     UIManager(self):ShowCommonPopupUI(100089,Params,self)
-- end

---武器同卡服务器回调
function M:OnWeaponGradeLevelUp(Ret)
    self.Parent:OnExpandList(false, true)
    self.Parent:RefreshListComp()
    if (not ErrorCode:Check(Ret)) then
        return
    end
    local Avatar = GWorld:GetAvatar()
    self.TargetWeapon = Avatar.Weapons[self.TargetWeapon.Uuid]
    self.IsPreviewMode = false
    self:Init({Parent = self.Parent, Target = self.TargetWeapon, Type = self.Type, Tag = self.Tag,IsPreviewMode = self.IsPreviewMode})
    if(self.Event_OnWeaponGradeLevelUp)then
        self.Event_OnWeaponGradeLevelUp(self.EventReceiver)
    end
    self.Parent:UpdateConsumedContents()
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
    self:PlayLevelUpAnim()
end

function M:OnForbiddenConfirmBtnClicked()
end

---武器锁定、解锁服务器回调
function M:OnBagItemLockedOrUnlocked(OpAction, Ret,Uuid)
    if(self.AllWeapons[Uuid])then
        local Avatar = GWorld:GetAvatar()
        self.AllWeapons[Uuid] = Avatar.Weapons[Uuid]
        if(self.Parent.ConsumedContentsMap[Uuid] and self.AllWeapons[Uuid]:IsLock())then
            self:RemoveItem(self.Parent.ConsumedContentsMap[Uuid])
        end
    end
end

--region 动效
function M:PlayLevelUpAnim()
    self.IsPlayLevelUpAnim = true
    local CurrentSkillDesc = SkillUtils.CalcWeaponPassiveEffectsDesc(self.TargetWeapon, self.TargetWeapon.GradeLevel)
    if CurrentSkillDesc then
        self.Text_Detail:SetText(CurrentSkillDesc)
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/same_card_strengthen_success", nil, nil)
    self.Preview:SetVisibility(UIConst.VisibilityOp.Collapsed)
    -- self:ShowEmptyItems(false)
    self:FillEmptyItems(self.MaxItemCount,false)
    self.Panel_Hint:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Parent:UpdateAutoButtonText()
    self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self:PlayAnimation(self.LevelUp_In)
    self.Parent.Btn_Auto:ForbidBtn(true)
    self.Parent.Btn_Enhance:ForbidBtn(true)
end

function M:OnLevelUpAnimFinished()
    self:AddTimer(1.5, function()
        -- self:ShowEmptyItems(true)
        self:FillEmptyItems(self.MaxItemCount,true)
        self.Panel_Hint:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self:PlayAnimation(self.LevelUp_Out)
        self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self:UpdateWeaponGradeLevelInfo()
        self.IsPlayLevelUpAnim = false
        if self.TargetWeapon.GradeLevel < self.MaxGradeLevel then
            local SkillDesc = SkillUtils.CalcWeaponPassiveEffectsDesc(self.TargetWeapon,self.TargetWeapon.GradeLevel,self.TargetWeapon.GradeLevel + 1)
            self.Text_Detail:SetText(GText("UI_Armory_NextStage")..": "..SkillDesc)
        end
        self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
        self.Parent:BlockAllUIInput(false)
    end,false,0,nil,true)
end

function M:ShowEmptyItems(bShow)
    for i = 1, self.MaxItemCount do
        local ItemWidgetName = "Item_" .. i
        -- self[ItemWidgetName].Panel_Add:SetVisibility(bShow and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Hidden)
        self[ItemWidgetName]:ShowAddIcon(bShow)
    end
end

function M:PlayInAnim()
    self:StopAnimation(self.Out)
    self:PlayAnimation(self.In)
    self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
end

function M:PlayOutAnim()
    self:StopAnimation(self.In)
    self:PlayAnimation(self.Out)
    self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
end

function M:OnInAnimFinished()
    self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:OnOutAnimFinished()
    self:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:FindSelectedContent(Uuid)
    local PreConsumeArray = self.Parent.ConsumedContentsArray
    for i, Content in pairs(PreConsumeArray) do
        if Content.Uuid and Content.Uuid == Uuid then
            return Content
        end
    end
    return nil
end

--endregion 动效

return M
