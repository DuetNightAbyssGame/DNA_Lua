--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
local ModModel = ModController:GetModel()

local OnItemMouseButtonUp = function(IntensifyPanel, Content, Event)
    local ModEnhanceWidget = Content.Parent
    if not IsValid(ModEnhanceWidget) then return end
    if Content.bShowAdd then
        if ModEnhanceWidget.OnItemAddClickCallback then
            ModEnhanceWidget.OnItemAddClickCallback(ModEnhanceWidget.Parent, Content)
        end
    else
        ModEnhanceWidget:OnItemMinusBtnClick(Content)
    end
end

local OnItemBtnAddClicked = function(Content)
    
end

---@type WBP_Armory_ModEnhance_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C","BluePrints.Common.TimerMgr"})
M._components = {
    "BluePrints.UI.WBP.Armory.CardLevel.IntensifySubWidgetCommon"
}

function M:Construct()
    self:BindToAnimationFinished(self.LevelUp_In,{ self,self.OnLevelUpAnimFinished})
    self.Text_Same:SetText(GText("Text_Same"))
    self.List_ModStar:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.List_Atrr:DisableScroll(true)
    EventManager:AddEvent(EventID.OnUpdateBagItem, self, self.OnBagItemLockedOrUnlocked)
end

function M:OnBagItemLockedOrUnlocked(OpAction, Ret,Uuid)
    if (Ret ~= ErrorCode.RET_SUCCESS) then
        return
    end
    for i, Content in pairs(self.ContentHolder) do
        if Content.Uuid == Uuid then
            self:OnItemMinusBtnClick(Content)
            break
        end
    end
end

function M:Init(Params)
    self:UpdateWidgetData(Params)
end

function M:UpdateWidgetData(Params)
    self.Parent = Params.Parent
    ---@type Mod
    self.Target = Params.Target
    self.Type = Params.Type
    self.NowLevel = Params.NowLevel
    self.MaxLevel = Params.MaxLevel
    if self.NowLevel then
        self:InitModStart()
        self.PreviewLevel = self.NowLevel
        self:InitConsumerList()
    end 
    self:UpdateCostBar(self.NowLevel)
end

function M:UpdateCostBar(InPreviewLevel)
    local Count = 1
    local TotalCost = {}
    if InPreviewLevel - self.Target.CurrentModCardLevel >0  then
        for i = self.Target.CurrentModCardLevel+1, InPreviewLevel do
            for Key, Val in pairs(DataMgr.ModLevel[self.Target.MaxLevel+i].ConsumeRarity[self.Target.Rarity]) do
                if not TotalCost[Key] then
                    TotalCost[Key] = 0
                end
                TotalCost[Key] = TotalCost[Key] + Val
            end
        end
        
    else
        for Key, Val in pairs(DataMgr.ModLevel[self.Target.Level].ConsumeRarity[self.Target.Rarity]) do
            if not TotalCost[Key] then
                TotalCost[Key] = 0
            end
        end
    end
    local Avatar = GWorld:GetAvatar()
    for Key, Val in pairs(TotalCost) do
        local Params= {
            ResourceId = Key,
            bShowDenominator = false,
            CostText = "",
            Owner = self,
            Numerator = Val,
        }
        local CostBar = self["Cost_"..Count] 
        if CostBar then 
            CostBar:InitContent(Params)
            CostBar:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
            CostBar.Key:SetVisibility(UIConst.VisibilityOp.Collapsed)
            CostBar:SetIsEnough(Avatar.Resources[Key].Count >= Val)
        end
        Count = Count+1
    end
end

function M:SetCallbacks(Callbacks)
    self.OnItemAddClickCallback = Callbacks.OnItemAddClickCallback
    self.OnPreviewLevelChangedCallback = Callbacks.OnPreviewLevelChangedCallback
    self.OnItemMinusBtnClickCallback = Callbacks.OnItemMinusBtnClickCallback
    self.OnLevelUpSuccessCallback = Callbacks.OnLevelUpSuccessCallback
    self.OnLevelUpSuccessFinishedCallback = Callbacks.OnLevelUpSuccessFinishedCallback
    self.OnModItemMoveCallback = Callbacks.OnModItemMoveCallback
    self.OnLevelUpFinalCallback = Callbacks.OnLevelUpFinalCallback
    self.OnComsumerCountChangeCb = Callbacks.OnComsumerCountChangeCb
end

function M:AddComsumerItem(InModContent)
    if self.ComsumerCount >= self.MaxComsumerCount then 
        return false
    end
    if InModContent.Count and InModContent.Count <= (self.Uuid2Count[InModContent.UnitId] or 0) then
        return false
    end
    self:_SetComsumerCount(self.ComsumerCount+1)
    ---@type Common_Item_subsize_PC_C
    local ItemUI = self["Item_"..self.ComsumerCount]
    self:_SetModItemUI(ItemUI, InModContent, self.ComsumerCount)
    self:_AddUuid2Count(ItemUI.Content)
    InModContent.IndexInEnhance = self.ComsumerCount
    if self.ComsumerCount>=self.MaxComsumerCount then
        self:CallOnPreviewLevelChangedCallback(self.PreviewLevel)
    end
    return true
end

function M:AddComsumerItems(InModContents)
    for _,ModContent in ipairs(InModContents) do
        self:AddComsumerItem(ModContent)
    end
end

function M:GetComsumersParam()
    local Comsumers = {}
    local bAnyLevelUp = false
    for i,Content in pairs(self.ContentHolder) do
        if Content.Uuid then
            local Uuid = Content.Uuid
            local UnitId = Content.UnitId
            if Content.ModId == 0 then
                Uuid = UnitId
                UnitId = "CardLevelNeedResourceId"
            end
            if not Comsumers[UnitId] then
                Comsumers[UnitId] = {}
            end
            if not Comsumers[UnitId][Uuid] then
                Comsumers[UnitId][Uuid] = 0
            end
            Comsumers[UnitId][Uuid] = Comsumers[UnitId][Uuid] + 1
            if Content.Level and Content.Level >0 then
                bAnyLevelUp = true
            end
        end
    end
    return Comsumers,bAnyLevelUp
end

function M:CallOnPreviewLevelChangedCallback(InPreviewLevel, bRemoveAll)
    if not self.OnPreviewLevelChangedCallback then return end
    local Attrs, ComparedAttrs,Desc = 
        self.OnPreviewLevelChangedCallback(self.Parent, InPreviewLevel+1)
    local bNotAnim = bRemoveAll and InPreviewLevel==self.PreviewLevel
    self:UpdateModEnhanceLevel(InPreviewLevel)
    if Attrs then
        self:UpdataAttrListView(Attrs, ComparedAttrs, false, true)
    end
    self:UpdateDesc(Desc)
end

function M:RemoveAllAddedComsumer()
    for _,Content in pairs(self.ContentHolder) do
        self:_SubUuid2Count(Content)
        if self.OnItemMinusBtnClickCallback and Content.IncId then
            self.OnItemMinusBtnClickCallback(self.Parent, Content)
        end
    end
    self:InitConsumerList(true)
end

function M:OnItemMinusBtnClick(DelContent)
    if self.ComsumerCount == 0 then return end
    ---@type Common_Item_subsize_PC_C
    local IndexInEnhance = DelContent.IndexInEnhance
    local bDeleted = false
    for i=IndexInEnhance, self.MaxComsumerCount do
        local ItemUI = self["Item_"..i]
        if i+1 <= self.MaxComsumerCount then
            local NextContent = self.ContentHolder:GetRef(i+1)
            local Content = self.ContentHolder:GetRef(i)
            if not NextContent.Uuid and not Content.Uuid then
                break
            end
            if NextContent.Uuid then
                self:_SetModItemUI(ItemUI, NextContent, i)
                if self.OnModItemMoveCallback then
                    self.OnModItemMoveCallback(self.Parent, ItemUI.Content)
                end
            elseif not bDeleted then
                self:_ResetItemUI(ItemUI, i, DelContent)
                bDeleted = true
            end
        elseif not bDeleted then
            self:_ResetItemUI(ItemUI, i, DelContent)
            bDeleted = true
        end
    end
    self:_SetComsumerCount(self.ComsumerCount -1)
    if self.OnItemMinusBtnClickCallback then
        self.OnItemMinusBtnClickCallback(self.Parent, DelContent)
    end
    if self.ComsumerCount<self.MaxComsumerCount and self.PreviewLevel>self.NowLevel then
        self:CallOnPreviewLevelChangedCallback(self.PreviewLevel-1)
    end
end

function M:InitConsumerList(bRemoveAll)
    self.Uuid2Count = {}
    self.MaxComsumerCount = self.Target.CardLevelNeedNum[self.NowLevel+1]
    for i, ItemUI in pairs(self.WB_Item:GetAllChildren()) do
        self:_ResetItemUI(ItemUI, i, ItemUI.Content, i<=self.MaxComsumerCount)
    end
    self:_SetComsumerCount(0)
    self.Text_Total:SetText("/"..self.MaxComsumerCount)
    self.Panel_Hint:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self:CallOnPreviewLevelChangedCallback(self.NowLevel, bRemoveAll)
end

function M:_SetComsumerCount(InComsumerCount)
    if self.OnComsumerCountChangeCb and InComsumerCount~=self.ComsumerCount then
        self.OnComsumerCountChangeCb(self.Parent,self.ComsumerCount, InComsumerCount)
    end
    self.ComsumerCount = InComsumerCount
    if self.ComsumerCount >0 then
        self.Text_NextLevel:SetText(GText("UI_Armory_ModAttrAfterEnchance"))
    else
        self.Text_NextLevel:SetText(GText("UI_Armory_ModNextLevelAttr"))
    end
    self.Text_Num:SetText(self.ComsumerCount)
end

function M:_SetModItemUI(ItemUI, InModContent, IndexInEnhance)
    ItemUI:BP_OnEntryReleased()
    local ModContent = nil
    if InModContent.ModId == 0 then
        local Res = ModModel:GetAvatar().Resources[InModContent.UnitId]
        ModContent = ArmoryUtils:NewResourceItemContent(Res)
        ModContent.UnitName = Res.ResourceName
        ModContent.CardLevel = 0
        ModContent.ModId = 0
        ModContent.Uuid = InModContent.UnitId
        ModContent.Level = nil
    else
        local Mod = ModModel:GetMod(InModContent.Uuid)
        ModContent = ModModel:CreateModContent(Mod, nil ,true)
    end
    ModContent.IncId = InModContent.IncId
    ModContent.Count = nil
    ModContent.bEnhance = true
    ModContent.Parent = self
    --ModContent.AdjustBackGroundHeightDelay = 0.1
    ModContent.MouseButtonUpEvent = OnItemMouseButtonUp
    ModContent.IndexInList = InModContent.IndexInList
    ModContent.IndexInEnhance = IndexInEnhance
    self:_AddOrSetContentHolder(ModContent, IndexInEnhance)
    ItemUI:OnListItemObjectSet(ModContent)
    ItemUI:ShowAddIcon(false)
    ItemUI:SetMinusBtn(true, self, self.OnItemMinusBtnClick)
    if ItemUI.PolarityWidget then 
        ItemUI.PolarityWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:_AddOrSetContentHolder(Content, Index)
    if self.ContentHolder:Length()<Index then
        self.ContentHolder:Add(Content)
    else
        self.ContentHolder:Set(Index, Content)
    end
end

function M:_SubUuid2Count(Content)
    local LastUuid= Content and Content.Uuid
    if LastUuid and self.Uuid2Count[LastUuid] then
        self.Uuid2Count[LastUuid] = self.Uuid2Count[LastUuid] -1
        if self.Uuid2Count[LastUuid] == 0 then
            self.Uuid2Count[LastUuid] = nil
        end
    end
end

function M:_AddUuid2Count(Content)
    local Uuid = Content.Uuid
    if not self.Uuid2Count[Uuid] then
        self.Uuid2Count[Uuid] = 0
    end
    self.Uuid2Count[Uuid] = self.Uuid2Count[Uuid] + 1
end

---@param ItemUI Common_Item_subsize_PC_C
function M:_ResetItemUI(ItemUI, IndexInEnhance, DelContent,bActivate)
    if bActivate == nil then bActivate = true end
    self:_SubUuid2Count(DelContent)
    ItemUI:SetMinusBtn(false)
    ItemUI:BP_OnEntryReleased()
    local EmptyContent = NewObject(UIUtils.GetCommonItemContentClass())
    EmptyContent.Parent = self
    EmptyContent.MouseButtonUpEvent = OnItemMouseButtonUp
    EmptyContent.IndexInEnhance = IndexInEnhance
    self:_AddOrSetContentHolder(EmptyContent, IndexInEnhance)
    ItemUI:OnListItemObjectSet(EmptyContent)
    ItemUI:ShowAddIcon(bActivate)
    if bActivate then
        ItemUI:SetVisibility(UIConst.VisibilityOp.Visible)
    else
        ItemUI:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end
end

function M:InitModStart()
    self.List_ModStar:ClearListItems()
    for i=1, (self.MaxLevel) do
        local StarContent = NewObject(UIUtils.GetCommonItemContentClass())
        StarContent.Idx = i
        StarContent.bActivate = i<=self.NowLevel
        StarContent.bGolden = (i==(self.NowLevel+1))
        self.List_ModStar:AddItem(StarContent)
    end
end

function M:UpdateModEnhanceLevel(InPreviewLevel)
    if InPreviewLevel > self.PreviewLevel then
        for i=self.PreviewLevel+1, InPreviewLevel do
            self:_SetGoldStar(i, true)
        end
    elseif InPreviewLevel < self.PreviewLevel then
        for i=InPreviewLevel+2, self.PreviewLevel do
            self:_SetActiveStar(i, false)
        end
    end
    self.PreviewLevel = InPreviewLevel
end

function M:_SetActiveStar(Index, bActivate)
    local StarContent = self.List_ModStar:GetItemAt(Index-1)
    StarContent.bActivate = bActivate
    if IsValid(StarContent.UI) then
        ---@type WBP_Armory_ModStar_C
        local StarUI = StarContent.UI
        StarUI:PlayAnimation(StarUI.Normal)
    end
end

function M:_SetGoldStar(Index,bGloden, bNoFlick)
    local StarContent = self.List_ModStar:GetItemAt(Index)
    StarContent.bGolden = bGloden
    if IsValid(StarContent.UI) then
        ---@type WBP_Armory_ModStar_C
        local StarUI = StarContent.UI
        StarUI:GoldStar()
        if bNoFlick then
            self:StopGoldStarTimer()
            local _,TimerKey = self:AddTimer(StarUI.Succeed:GetEndTime()+0.1,
                function() StarUI:PlayAnimation(StarUI.Activate) end,false,0,nil,true)
            self.GoldStarTimer = TimerKey
        end
    end
end

function M:StopGoldStarTimer()
    if self:IsExistTimer(self.GoldStarTimer) then
        self:RemoveTimer(self.GoldStarTimer)
        self.GoldStarTimer = nil
    end
end

function M:Destruct()
    self:UnbindAllFromAnimationFinished(self.LevelUp_In)
    self:StopLevelUpSuccessTimer()
    self:StopGoldStarTimer()
    EventManager:RemoveEvent(EventID.OnUpdateBagItem, self)
end

function M:OnLevelUpSuccess()
    self.Panel_Hint:SetVisibility(UIConst.VisibilityOp.Collapsed)
    for i, ItemUI in pairs(self.WB_Item:GetAllChildren()) do
        self:_ResetItemUI(ItemUI, i ,ItemUI.Content, false)
        self:_SubUuid2Count(ItemUI.Content)
    end
    self:_SetGoldStar(self.PreviewLevel, true, true)
    self:PlayAnimation(self.LevelUp_In)
    self.SuccessToast:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.SuccessToast:PlayAnimation(self.SuccessToast.In)
    if not self.OnLevelUpSuccessCallback then return end
    local Attr, Desc = self.OnLevelUpSuccessCallback(self.Parent)
    if Attr then
        self:UpdataAttrListView(Attr, nil ,true, true)
    end
    self:UpdateDesc(Desc)
    self:UpdateCostBar(self.NowLevel)
    self.bFinal= (self.PreviewLevel+1 == self.MaxLevel)
    if not self.bFinal then
        self.SuccessToast.Text_Success:SetText(GText("Mod_CardUp_Success"))
    else
        self.SuccessToast.Text_Success:SetText(GText("UI_ModEnhance_Max"))
    end
end

function M:OnLevelUpAnimFinished()
    self:StopLevelUpSuccessTimer()
    local _, TimerKey = self:AddTimer(1.5, function()
        if self.bFinal then
            --self:PlayAnimation(self.LevelUp_MaxOut)
            if self.OnLevelUpFinalCallback then
                self.OnLevelUpFinalCallback(self.Parent, self.bFinal) 
            end
            return 
        end
        self:PlayAnimation(self.LevelUp_Out)
        self.SuccessToast:PlayAnimation(self.SuccessToast.Out)
        if self.OnLevelUpSuccessFinishedCallback then
            self.OnLevelUpSuccessFinishedCallback(self.Parent)
        end
        self.Panel_Hint:SetVisibility(UIConst.VisibilityOp.Visible)
    end,false,0,nil,true)
    self.LevelUpSuccessTimer=TimerKey
    
end

function M:StopLevelUpSuccessTimer()
    if self:IsExistTimer(self.LevelUpSuccessTimer) then
        self:RemoveTimer(self.LevelUpSuccessTimer)
        self.LevelUpSuccessTimer = nil
    end
end

AssembleComponents(M)
return M
