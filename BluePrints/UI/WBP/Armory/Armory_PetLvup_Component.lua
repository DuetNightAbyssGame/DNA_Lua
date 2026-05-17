--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local RewardBox = require "BluePrints.Client.CustomTypes.SimpleRewardBox"
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
local UpgradeUtils = require "Utils.UpgradeUtils"
local ItemUtils = require "Utils.ItemUtils"
local EMCache = require "EMCache.EMCache"
local PreciousPopupId = 100174
local NormalPopupId = 100114
local Component = {}
Component.LevelUpWidget = "WidgetBlueprint'/Game/UI/WBP/Armory/Widget/Pet/WBP_Armory_PetUpgrade.WBP_Armory_PetUpgrade'"
function Component:InitLevelUpComp(...)
    local User,Target,SubWidget,Params = ...
    self.Target = Target
    self.TargetData = Target.Props
    self.Type = Params.Type
    self.Tag = Params.Tag
    self.CurrentMode = Params.BehaviourType
    self.FilterTagNames = {"Pet_Rarity_3_Below","Pet_Rarity_4_Below", "Pet_Rarity_5_Below"}
    self.FilterTagIdx = EMCache:Get("ArmoryPetFilterTag") or 1
    self:RefreshListComp()
    self.Selective_Listing:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    -- self.Bg:SetVisibility(UIConst.VisibilityOp.Hidden)
    -- self.Bg_Bottom:SetVisibility(UIConst.VisibilityOp.Hidden)
    self:InitTab(GText("UI_Pet_LevelUp"))
    self:OnExpandList(false, nil, true)
    self:ShowChooseBtn(true)
    self:ShowWarning(false)
    self.Btn_Enhance:UnBindEventOnClickedByObj(self)
    self.Btn_Enhance:BindEventOnClicked(self,self.OnUpgradeBtnClicked)
    self.Btn_Enhance:BindForbidStateExecuteEvent(self, self.OnUpgradeBtnForbiddenClicked)
    self.Btn_Auto:UnBindEventOnClickedByObj(self)
    self.Btn_Auto:BindEventOnClicked(self,self.OnAutoBtnClicked)
    self:AddDispatcher(EventID.PetAddExpMulti, self, self.OnPetIntensifyDone)
    self:AddDispatcher(EventID.OnPetLocked,self, self.OnPetLocked)
    local WidgetPath = Component.LevelUpWidget
    local SubWidgetParams = {
        Parent = self,
        Target = self.Target,
        Type = self.Type,
        Tag = self.Tag,
    }
    self.IntensifyWidget = nil
    self:InitLvUpIntensify(WidgetPath,SubWidgetParams)
    self:InitLvUpView()
    self.WidgetSwitcher_Mode:SetActiveWidgetIndex(1)
    self:InitLvUpPanelInfo()
    self:RefreshBaseInfo()
    self:BindToAnimationFinished(self.Selective_Listing.In,{self,self.RefreshBaseInfo})
    self.AutoPressed = false
    self.EnhancePressed = false
    -- if self.InitTimer then
    --     self:RemoveTimer(self.InitTimer)
    --     self.InitTimer = nil
    -- end
    -- self.InitTimer = self:AddTimer(0.2, function()
    --     local FirstItem = self.CurrentSubUI.ListView_Item:GetItemAt(0)
    --     if FirstItem and FirstItem.SelfWidget then
    --         FirstItem.SelfWidget:PlayAnimation(FirstItem.SelfWidget.Normal)
    --     end
    --     self:RefreshBaseInfo()
    -- end)
end

function Component:OnExpandListComp(bListExpand, bRefreshList)
    if self.CurrentMode == "LevelUp" then
        --self:ShowRemoveBtn(bListExpand)
    end
end

function Component:OnUpgradeBtnClicked()
    if self.CurrentMode == "LevelUp" then
        if self.IntensifyWidget then
            self.IntensifyWidget:OnPlusEnd()
            self.IntensifyWidget:OnMinusEnd()
        end
        self:TryToLevelUp()
    end
end

function Component:OnUpgradeBtnForbiddenClicked()
    if self.CurrentMode == "LevelUp" then
        UIManager(self):ShowUITip("CommonToastMain", GText("UI_Armory_SelectedConsumeIsEmpty"), 1.5)
    end
end

function Component:SwitchAutoBtnState(bClear)
    if self.CurrentMode == "LevelUp" then
        if self.bBtnClear == bClear then
            return
        end
        self.bBtnClear = bClear
        if self.bBtnClear then
            self.Btn_Auto:SetText(GText("UI_WeaponStrength_Clear"))
        else
            self.Btn_Auto:SetText(GText("UI_WeaponStrength_Auto"))
        end
    end
end

function Component:OnAutoBtnClicked()
    if self.CurrentMode == "LevelUp" then
        if self.Target:IsFinalMaxLevel() then
            return
        end
        if not self.bBtnClear then
            if self.bItemDetailsShowed then
                self:ShowItemDetails(false)
            end
            --self:ExpandListComp(true,false)
            --self:ReNavigateToListItem()
            if self.bListEmpty then
                UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Toast_WeaponStrength_NoAuto"), 1.5)
                return
            end
            local PreConsumeContents = {}
            local AllContent = self.Selective_Listing.TileView_Select_Role:GetListItems():ToTable()
            table.sort(AllContent, function(a, b)
                local aIsPet = a.ItemType == "Pet"
                local bIsPet = b.ItemType == "Pet"
                if aIsPet ~= bIsPet then
                    return (not aIsPet)
                end
                local aRarity = a.Rarity or 0
                local bRarity = b.Rarity or 0
                if a.IsResourcePet then
                    aRarity = DataMgr.PetEntry[a.PetEntry[1]].Rarity or aRarity
                end
                if b.IsResourcePet then
                    bRarity = DataMgr.PetEntry[b.PetEntry[1]].Rarity or bRarity
                end
                if aIsPet and bIsPet then
                    if aRarity ~= bRarity then --稀有度
                        return aRarity < bRarity
                    end
                    local aBreak = a.BreakNum or 0
                    local bBreak = b.BreakNum or 0
                    if aBreak ~= bBreak then --突破次数
                        return aBreak < bBreak
                    end
                    local aLevel = a.Level or 0
                    local bLevel = b.Level or 0
                    if aLevel ~= bLevel then --等级
                        return aLevel < bLevel
                    end
                    local aEntryID = a.PetEntry and a.PetEntry[1] or 0
                    local bEntryID = b.PetEntry and b.PetEntry[1] or 0
                    if aEntryID ~= bEntryID then --词条Id
                        return aEntryID < bEntryID
                    end
                    local aPriority = a.SortPriority or 0
                    local bPriority = b.SortPriority or 0
                    if aPriority ~= bPriority then --排序优先级
                        return aPriority < bPriority
                    end
                    local aUnitId = a.UnitId or 0
                    local bUnitId = b.UnitId or 0
                    if aUnitId ~= bUnitId then --UnitId
                        return aUnitId < bUnitId
                    end
                    return (a.Uuid or 0) < (b.Uuid or 0) --Uuid
                end
                return aRarity < bRarity
            end)
            local FilterTagIdx = self.FilterTagIdx
            local FilterMaxRarity = FilterTagIdx + 2
            local Count = 0
            for _, Content in ipairs(AllContent) do
                if (Content.Uuid and not self:IsContentLocked(Content)) and (Content.Rarity and Content.Rarity <= FilterMaxRarity) then
                    local bAddConsumeContent = false
                    if not Content.ItemType or Content.ItemType ~= "Resource" then
                        bAddConsumeContent = true
                    elseif Content.ItemType == "Resource" and Content.Count and Content.Count > 0 then
                        bAddConsumeContent = true
                    end
                    if bAddConsumeContent then
                        table.insert(PreConsumeContents, Content)
                        Count = Count + 1
                        if Count >= self.CurrentSubUI.PreConsumeCount then
                            break
                        end
                    end
                end
            end
            if Count == 0 then 
                UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Toast_WeaponStrength_NoAuto"))
                return
            end
            self.CurrentSubUI:OnAutoSelectClick(PreConsumeContents)
        else
            self.CurrentSubUI:OnClearClick()
        end
    end
end

function Component:InitLvUpIntensify(WidgetPath,Params)
    if(self.IntensifyWidget)then
        return
    end
    
    self.VB_Node:ClearChildren()
    self:CreateLvUpWidget(WidgetPath,Params)
end

function Component:CreateLvUpWidget(WidgetPath,Params)
    self.IntensifyWidget = UIManager(self):CreateWidget(WidgetPath,true)
    self.VB_Node:AddChild(self.IntensifyWidget)
    if self.IntensifyWidget then
        Params = Params or {}
        Params.Parent = self
        self.IntensifyWidget:Init(Params)
        if(self.IntensifyWidget:IsVisible())then
            self.IntensifyWidget:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        end
        self.CurrentSubUI = self.IntensifyWidget
    end
end

function Component:InitLvUpPanelInfo()
    self.Panel_Info:SetVisibility(UIConst.VisibilityOp.Visible)
    local TargetData = self.Target.Props
    local TargetName = DataMgr.Pet[TargetData.PetId].Name
    local TargetRarity = DataMgr.Pet[TargetData.PetId].Rarity
    self.Text_Max:SetText(GText("Pet_LevelUp_LevelMax"))
    self.TextBlock_Name:SetText(GText(TargetName))
    self.Panel_Element:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    self:SetStars(TargetRarity)
    self.Btn_Enhance:SetText(GText("UI_COMMONPOP_TITLE_100029"))
    self.Btn_Enhance:SetDefaultGamePadImg("Y")
    self.Btn_Auto:SetText(GText("UI_WeaponStrength_Auto"))
    self.Btn_Auto:SetDefaultGamePadImg("X")
    self.Btn_Enhance:ForbidBtn(self.CurrentSubUI:IsEmpty())
    self.Btn_Auto:ForbidBtn(false)
    self:UpdateBtnState(self.Target:IsFinalMaxLevel())
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
end

function Component:RefreshListComp()
    if self.CurrentMode == "LevelUp" then
        local PetContents = {}
        self.ContentMap = {}
        local ConsumeResourceIds = {3004,3005,3006}
        for _, value in ipairs(ConsumeResourceIds) do
            local ConsumeResourceId = value
            if not self._Avatar.Resources[ConsumeResourceId] then
                local ResourceInfo = DataMgr.Resource[ConsumeResourceId]
                local Obj = NewObject(UIUtils.GetCommonItemContentClass())
                Obj.Type = CommonConst.DataType.Resource
                Obj.ItemType = CommonConst.DataType.Resource
                Obj.UnitId = ConsumeResourceId
                Obj.ResourceSType = ResourceInfo.ResourceSType
                Obj.IsEquiped = false
                Obj.Rarity = ResourceInfo.Rarity or 0
                Obj.Icon = ResourceInfo.Icon
                Obj.CharId = ResourceInfo.UseParam
                Obj.Uuid = -ConsumeResourceId
                Obj.Parent = self
                Obj.Count = 0
                Obj.Exp = ResourceInfo.UseParam
                Obj.bShadow = true
                Obj.OnMouseButtonUpEvents = {Obj = self, Callback = function()
                    self:OnLvupListItemClicked(Obj)
                end}
                table.insert(PetContents, Obj) 
            end
        end
        if self._Avatar then
            if self._Avatar.Resources then
                for ResourceId, Resource in pairs(self._Avatar.Resources) do
                    if ItemUtils.CheckResourceObsolete(ResourceId) then goto continue1 end
                    if not Resource or not Resource.UseEffectType then goto continue1 end
                    if Resource.UseEffectType ~= "AddPetExpItem" then goto continue1 end
                    if Resource.Count<=0 then goto continue1 end
                    local Obj = ArmoryUtils:NewResourceItemContent(Resource)
                    Obj.Uuid = -ResourceId
                    Obj.Parent = self
                    Obj.Count = Resource.Count
                    Obj.Exp = Resource.UseParam
                    Obj.OnMouseButtonDownEvent = {Obj = self, Callback = function()
                        if not self.CurrentSubUI:PreviewLevelMax() then
                            self.CurrentSubUI:OnPlusStart(Obj)
                        else
                            UIManager(self):ShowUITip(UIConst.Tip_CommonToast,GText("Max_Level_Achieved"),1.5)
                        end
                    end,
                    Params = {bIgnoreRightMouseDown = true}}
                    Obj.OnMouseButtonUpEvents = {Obj = self, Callback = function()
                        self.CurrentSubUI:OnPlusEnd()
                        self:OnLvupListItemClicked(Obj)
                    end}
                    Obj.OnMouseLeaveEvent = {Obj = self, Callback = function()
                        self.CurrentSubUI:OnPlusEnd()
                    end}
                    table.insert(PetContents, Obj)
                    self.ContentMap[Obj.Uuid] = Obj
                    ::continue1::
                end
            else
                print("Lgc@ Avatar.Resources 不存在")
            end
            if self._Avatar.Pets then
                for UniqueId, Pet in pairs(self._Avatar.Pets) do
                    if self.Target.UniqueId == UniqueId then goto continue end
                    if self._Avatar.CurrentPet == UniqueId then goto continue end
                    --if not self:FilterLvupTarget(Pet) then goto continue end
                    local Obj = ArmoryUtils:NewPetItemContent(Pet)
                    Obj.Parent = self
                    Obj.OnMouseButtonUpEvents = {Obj = self, Callback = function()
                        self:OnLvupListItemClicked(Obj)
                    end}
                    table.insert(PetContents, Obj)
                    self.ContentMap[Obj.Uuid] = Obj
                    ::continue::
                end
            else
                print("Lgc@ Avatar.Pets 不存在")
            end
        else
            print("Lgc@ Avatar 不存在")
        end
        self:SortSelectiveList(PetContents, 1, CommonConst.ASC)
        self.Selective_Listing:Init(self,{
            ItemContents = PetContents, 
            SortType = CommonConst.ASC,
            OrderByDisplayNames = {"UI_SHOWNPC_LIST_CONT_1","UI_LEVEL_SELECT"},
        })
        self.Selective_Listing:SetEmptyStateText("")
        if #PetContents == 0 then
            self.Selective_Listing:SetEmptyStateText(GText("UI_Armory_PetListIsEmpty"))
        end
        self:SetListEmptyState(#PetContents == 0)
    end
end

function Component:IsLvupCommonResource(Uuid)
    return type(Uuid) == "number" and Uuid < 0
end

function Component:FilterLvupTarget(Target)
    if not Target then
        return false
    end
    local Data = Target:Data()
    local FilterTag = self.FilterTagNames[self.FilterTagIdx]
    if FilterTag == "Pet_ResourcePet" then
        if Data.PetType == 2 then
            return true
        end
    elseif FilterTag == "Pet_Rarity_3" then
        if Data.Rarity <= 3 then
            return true
        end
    elseif FilterTag == "Pet_Rarity_4_Below" then
        if Data.Rarity <= 4 then
            return true
        end
    elseif FilterTag == "Pet_Rarity_5_Below" then
        if Data.Rarity <= 5 then
            return true
        end
    end
    return false
end

function Component:OnFilterTagChanged(Idx)
    if self.FilterTagIdx == Idx then
        return
    end

    self.FilterTagIdx = Idx
    --self:RefreshListComp()--右侧分类不再影响左侧展示
end

function Component:SortSelectiveList(InOutContentArray, SortBy, SortType)
    if self.CurrentMode == "LevelUp" then
        self.SortType = SortType
        if not self.LvupSortFunc then
            self.LvupSortFunc = {}
            self.LvupSortFunc[1] =  function(P1, P2)
                if P1.Type == P2.Type then
                    if P1.Rarity ~= P2.Rarity then return CommonUtils:Compare(P1.Rarity, P2.Rarity, self.SortType) end
                    if P1.BreakNum and P2.BreakNum and P1.BreakNum ~= P2.BreakNum then 
                        return CommonUtils:Compare(P1.BreakNum, P2.BreakNum, self.SortType) 
                    end
                    if P1.Level ~= P2.Level then return self:ComparePetLevel(P1, P2, self.SortType) end
                    if P1.IsResourcePet and P2.IsResourcePet then -- 资源宠物排序：词条稀有度>词条Id>排序优先级>宠物id
                        if not P1.PetEntry or not P2.PetEntry or not P1.PetEntry[1] or not P2.PetEntry[1] then return false end
                        local Pet1EntryInfo = DataMgr.PetEntry[P1.PetEntry[1]]
                        local Pet2EntryInfo = DataMgr.PetEntry[P2.PetEntry[1]]
                        if not Pet1EntryInfo or not Pet2EntryInfo then return false end
                        if Pet1EntryInfo.Rarity ~= Pet2EntryInfo.Rarity then return CommonUtils:Compare(Pet1EntryInfo.Rarity, Pet2EntryInfo.Rarity, self.SortType) end
                        if Pet1EntryInfo.PetEntryID ~= Pet2EntryInfo.PetEntryID then return CommonUtils:Compare(Pet1EntryInfo.PetEntryID, Pet2EntryInfo.PetEntryID, self.SortType) end
                    end
                    if P1.SortPriority ~= P2.SortPriority then return CommonUtils:Compare(P1.SortPriority, P2.SortPriority, self.SortType) end
                else
                    if P1.Type == CommonConst.DataType.Resource then return true end
                    if P2.Type == CommonConst.DataType.Resource then return false end
                end
                if P1.UnitId ~= P2.UnitId then return CommonUtils:Compare(P1.UnitId, P2.UnitId, self.SortType) end
                return CommonUtils:Compare(P1.Uuid, P2.Uuid, self.SortType)
            end
            self.LvupSortFunc[2] =  function(P1, P2)
                if P1 == nil then return false end
                if P2 == nil then return true end
                if rawequal(P1, P2) then return false end
                if P1.Type and P2.Type and P1.Type == P2.Type then
                    if P1.Level and P2.Level and P1.Level ~= P2.Level then return CommonUtils:Compare(P1.Level, P2.Level, self.SortType) end
                    if P1.Rarity and P2.Rarity and P1.Rarity ~= P2.Rarity then return CommonUtils:Compare(P1.Rarity, P2.Rarity, self.SortType) end
                    if P1.BreakNum and P2.BreakNum and P1.BreakNum ~= P2.BreakNum then 
                        return CommonUtils:Compare(P1.BreakNum, P2.BreakNum, self.SortType) 
                    end
                    if P1.IsResourcePet and P2.IsResourcePet then -- 资源宠物排序：词条Id>词条稀有度>排序优先级>宠物id 
                        if not P1.PetEntry or not P2.PetEntry or not P1.PetEntry[1] or not P2.PetEntry[1] then return false end
                        local Pet1EntryInfo = DataMgr.PetEntry[P1.PetEntry[1]]
                        local Pet2EntryInfo = DataMgr.PetEntry[P2.PetEntry[1]]
                        if not Pet1EntryInfo or not Pet2EntryInfo then return false end
                        if Pet1EntryInfo.PetEntryID ~= Pet2EntryInfo.PetEntryID then return CommonUtils:Compare(Pet1EntryInfo.PetEntryID, Pet2EntryInfo.PetEntryID, self.SortType) end
                        if Pet1EntryInfo.Rarity ~= Pet2EntryInfo.Rarity then return CommonUtils:Compare(Pet1EntryInfo.Rarity, Pet2EntryInfo.Rarity, self.SortType) end
                    end
                    if P1.SortPriority ~= P2.SortPriority then return CommonUtils:Compare(P1.SortPriority, P2.SortPriority, self.SortType) end
                else
                    if P1.Type and P1.Type == CommonConst.DataType.Resource then return true end
                    if P2.Type and P2.Type == CommonConst.DataType.Resource then return false end
                end
                if P1.UnitId ~= P2.UnitId then return CommonUtils:Compare(P1.UnitId, P2.UnitId, self.SortType) end
                return CommonUtils:Compare(P1.Uuid, P2.Uuid, self.SortType)
            end
        end
        table.sort(InOutContentArray, self.LvupSortFunc[SortBy])
        self.SortType = nil
    end
end

function Component:OnLvupListItemClicked(Content)
    if self.CurrentSelected and self.CurrentSelected ~= Content and IsValid(self.CurrentSelected.SelfWidget) then
        self.CurrentSelected.SelfWidget:SetSelected(false)
    end
    if self.CurrentSelected ~= Content then
        self.CurrentSelected = Content
    end
    if IsValid(self.CurrentSelected.SelfWidget) then
        self.CurrentSelected.SelfWidget:SetSelected(true)
    end
    if self.CurrentSelected and self.CurrentSelected.Count and self.CurrentSelected.Count == 0 then
        return
    end
    if not Content.Uuid then return end
    ArmoryUtils:SetItemReddotRead(Content,true)
    self:ShowItemDetails(true, Content)
    if self:IsContentLocked(Content) then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Pet_Locked"))
        return
    end
    if Content.bSelectTag then
        if not self:IsLvupCommonResource(Content.Uuid) then
            local DelContent = self.CurrentSubUI:FindSelectedContent(Content.Uuid)
            if DelContent then
                self.CurrentSubUI:OnItemMinusBtnClick(DelContent)
            end
        end
        return
    end
    if self.CurrentSubUI:IsFull() then 
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("Pet_LevelUp_AddMax"))
        return 
    end
    if not self.CurrentSubUI:PreviewLevelMax() then
        if not self:IsLvupCommonResource(Content.Uuid) then
            self.CurrentSubUI:CopyItemToConsumeList(Content)
        end
    else
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast,GText("Max_Level_Achieved"),1.5)
    end
end

function Component:OnItemTypeChanged(Type)
    if self.ItemTypeChangeTimer then
        self:RemoveTimer(self.ItemTypeChangeTimer)
    end
    self.PendingItemType = Type
    self.ItemTypeChangeTimer = self:AddTimer(0.1, self.OnItemTypeChangedDelayed)
end

function Component:OnItemTypeChangedDelayed()
    local Type = self.PendingItemType
    if self.CurrentMode == "LevelUp" then
        if Type == CommonConst.DataType.Resource then
            self:ShowRemoveBtn(true)
            self:ShowChooseBtn(true)
            self:ShowAddAndRemoveBtn(false)
        else
            self:ShowRemoveBtn(false)
            self:ShowChooseBtn(false)
            self:ShowAddAndRemoveBtn(true)
        end
    end
    self.ItemTypeChangeTimer = nil
    self.PendingItemType = nil
end

function Component:SetListEmptyState(bListEmpty)
    self.bListEmpty = bListEmpty
end

function Component:SetContentSelected(Content, bSelect)
    if self.CurrentMode == "LevelUp" then
        local MyContent= self.ContentMap[Content.Uuid]
        if not MyContent then
            return
        end
        MyContent.bSelectTag = bSelect
        if MyContent.SelfWidget then
            MyContent.SelfWidget:SetItemSelect(bSelect)
        end
    end
end

function Component:OnChosenItemChanged(CardLevelWidgetContents)
end

function Component:CloseComp()
    if self.CurrentMode == "LevelUp" then
        if not self.bItemDetailsShowed then
            if self.CurrentSelected and self.CurrentSelected.SelfWidget then
                self.CurrentSelected.SelfWidget:SetSelected(false)
                self.CurrentSelected = nil
            end
            -- if self.InitTimer then
            --     self:RemoveTimer(self.InitTimer)
            --     self.InitTimer = nil
            -- end
            self:UnbindAllFromAnimationFinished(self.Selective_Listing.In)
            EMCache:Set("ArmoryPetFilterTag", self.FilterTagIdx)

        else
            if (self.CurInputDeviceType == ECommonInputType.Gamepad) then
                self:ReNavigateToListItem(true)
            end
        end
        -- 注销事件监听器
        self:RemoveDispatcher(EventID.PetAddExpMulti)
        self:RemoveDispatcher(EventID.OnPetLocked)
    end
end

function Component:RealCloseComp()
    if self.CurrentMode == "LevelUp" then
        -- self.Bg:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        -- self.Bg_Bottom:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Btn_Enhance:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Btn_Auto:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
        self:ShowRefundResource(true)
    end
end

function Component:OnBackgroundClickedComp()
    if self.CurrentMode == "LevelUp" then
        if self.CurrentSelected and self.CurrentSelected.SelfWidget then
            self.CurrentSelected.SelfWidget:SetSelected(false)
            self.CurrentSelected = nil
        end
        if self.bListExpand then
            if self.bItemDetailsShowed then
                self:ShowItemDetails(false)
            end
            self:OnExpandList(false, false)
        end
    end
end

--region 宠物锁定
function Component:OnDetailLockBtnClickComp()
    if self.CurrentMode == "LevelUp" then
        self:LockOrUnlockPet()
    end
end

function Component:LockOrUnlockPet()
    if self.CurrentMode == "LevelUp" then
        if self.LvupLockTimer then
            self:RemoveTimer(self.LvupLockTimer)
            self.LvupLockTimer = nil
        end
        if(not self.ItemDetailsContent)then
            return
        end
        if(self:IsContentLocked(self.ItemDetailsContent))then
            local CancelFunc = function()
                self:SetFocus()
                if(self.ItemDetailsWidget)then
                    self.ItemDetailsWidget.Btn_Locked.Switcher_Lock:SetActiveWidgetIndex(0)
                end
            end
            local ConfirmFunc = function()
                SecondaryPasswordController:Pet_OpenSeconderyPassword(self.ItemDetailsContent.UniqueId, self)
            end
            UIManager(self):ShowCommonPopupUI(100019,{
                LeftCallbackFunction = CancelFunc,
                RightCallbackFunction = ConfirmFunc, 
                CloseBtnCallbackFunction = CancelFunc,
            },self)
        else
            self.LvupLockTimer = self:AddTimer(5, function()
                UIManager(self):ShowUITip(UIConst.Tip_CommonToast,"锁定请求超时",1.5)
                self:BlockAllUIInput(false)
            end)
            self:BlockAllUIInput(true)
            local Avatar = GWorld:GetAvatar()
            Avatar:LockPet(self.ItemDetailsContent.UniqueId)
        end
    end
end

function Component:OnPetLocked(ErrCode, UniqueId, IsLocked)
    if self.CurrentMode == "LevelUp" then
        local CurrentContent = self.ItemDetailsContent
        self:BlockAllUIInput(false)
        if self.LvupLockTimer then
            self:RemoveTimer(self.LvupLockTimer)
            self.LvupLockTimer = nil
        end
        if (not ErrorCode:Check(ErrCode)) then
            return
        end
        CurrentContent.LockType = IsLocked and 1 or 0
        if(CurrentContent.SelfWidget)then
            CurrentContent.SelfWidget:SetLock(CurrentContent.LockType)
        end
        if(self.ItemDetailsWidget)then
            if (IsLocked) then
                self.ItemDetailsWidget.Switcher_Lock:SetActiveWidgetIndex(0)
            else
                self.ItemDetailsWidget.Switcher_Lock:SetActiveWidgetIndex(1)
            end
        end
        if(CurrentContent.bSelectTag and IsLocked)then
            local DelContent = self.CurrentSubUI:FindSelectedContent(CurrentContent.Uuid)
            if DelContent then
                self.CurrentSubUI:OnItemMinusBtnClick(DelContent)
            end
        end
        if self.SetTipLockAfterRPCBackFunc then
            self.SetTipLockAfterRPCBackFunc(IsLocked)
        end
    end
end
--endregion 宠物锁定

function Component:DestructComp()
    -- if(self.IntensifyWidget)then
    --     self.IntensifyWidget:BindEvents(nil,nil)
    -- end
end

function Component:Construct()
end

function Component:InitLvUpView()
    --初始化
    self.CurrentSelected= nil
    self.ItemDetailsContent= nil
    self.MaxLevel = 1
    self.CashId = CommonConst.Coins.Coin2
    self.TargetId = self.TargetData[self.Type.."Id"]
    self.Level = self.TargetData.Level
    self.BreakLevel = self.TargetData.BreakNum
    --减少等级的次数
    self.PreLevelTimes = 0
    --增加等级的次数
    self.NextLevelTimes = 0
    --初始化角色或武器的升级信息
    if(self.Target:IsFinalMaxLevel()) then
        --已经满级
        return
    else
        self.MaxLevel,self.RealMaxLevel = UpgradeUtils.GetMaxLevel(self.Target,self.Type)
    end
    self:SwitchAutoBtnState()
end

function Component:TryToLevelUp()
    --发送RPC请求升级
    local Avatar = GWorld:GetAvatar()
    if(Avatar == nil)then
        GWorld.logger.error("Armory_PetLvup_Component:TryToLevelUp@Avatar不存在")
        return
    end
    
    local PopupId = PreciousPopupId
    local CancelFunc = function()
        self:SetFocus()
    end
    local bShowCommonPopupUI = false
    if self.CurrentSubUI:IsPrecious() then
        bShowCommonPopupUI = true
    end
    local ConfirmFunc = function () 
        local ConsumeIds = self.CurrentSubUI:GetConsumeIds()
        local ConsumeResources = self.CurrentSubUI:GetConsumeResources()
        if next(ConsumeIds) == nil and next(ConsumeResources) == nil then
            UIManager(self):ShowUITip("CommonToastMain", GText("UI_Armory_SelectedConsumeIsEmpty"), 1.5)
            return
        end
        self:BlockAllUIInput(true)
        self:AddTimer(10.0, function()
            --弱网环境服务器无返回，手动解禁
            self:BlockAllUIInput(false)
        end)
        local Avatar = GWorld:GetAvatar()
        local CallBack = function(RefundResources)
            Avatar = GWorld:GetAvatar()
            if not Avatar then
                GWorld.logger.error("Armory_PetLvup_Component:TryToLevelUp@Avatar不存在")
                return
            end
            self._Avatar = Avatar
            self.RefundResources = RefundResources
        end
        Avatar:PetAddExpMulti(CallBack, self.Target.UniqueId, ConsumeIds, ConsumeResources)
        
        local ArmoryMain = UIManager(self):GetArmoryUIObj()
        ArmoryMain.ActorController:PetLvUpOrBreakUp()

        self.Btn_Enhance:ForbidBtn(true)
        self.Btn_Auto:ForbidBtn(true)
        self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
    end
    if bShowCommonPopupUI then
        UIManager():ShowCommonPopupUI(PopupId, {
            LeftCallbackFunction = CancelFunc,
            RightCallbackFunction = ConfirmFunc, 
            CloseBtnCallbackFunction = CancelFunc,
        }, self)
    else
        ConfirmFunc()
    end

end

function Component:OnPetIntensifyDone(ErrCode,UniqueId,bLevelUp)
    if self.CurrentMode == "LevelUp" then
        DebugPrint("lhr@OnPetIntensifyDone", bLevelUp)
        --服务端升级成功回调
        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
        local UIManager = GameInstance:GetGameUIManager()
        if not UIManager then
            return
        end
        try({
            exec = function()
                if not ErrorCode:Check(ErrCode, UIConst.Tip_CommonToast) then
                    UIManager:ShowError(ErrCode,1.5)
                    self:BlockAllUIInput(false)
                    return
                end
                self.CurrentSubUI:OnPetIntensifyDone(UniqueId, bLevelUp)
                if self.CurrentSubUI:IsEmpty() then
                    self:BlockAllUIInput(false)
                    if bLevelUp then
                        if self.bListExpand then
                            if self.bItemDetailsShowed then
                                self:ShowItemDetails(false)
                            end
                            self:OnExpandList(false, false)
                            return
                        end
                    else
                        self:RefreshListComp()
                    end
                end
                -- 调用主界面回调更新信息
                if self.Params and self.Params.LeftCallbackObj and self.Params.LeftCallbackFunction then
                    self.Params.LeftCallbackFunction(self.Params.LeftCallbackObj)
                end
            end,
            catch = function (err)
                DebugPrint("PetLvup_Component@Error", err)
                UIManager:ShowUITip("CommonToastMain", GText(err))
                self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
            end,
            final = function(ok)
                if not ok then
                    self:BlockAllUIInput(false)
                    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
                end
            end,
        })
    end
end

function Component:OnLevelUpAnimFinishedCallback()
    self:BlockAllUIInput(false)
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
    if(self.Target:IsFinalMaxLevel())then
        --满级状态
        self:UpdateBtnState(true)
        return
    end
    self.Level = self.Target.Level
    if(self.Level >= self.MaxLevel)then
        --切换突破面板
        self.VB_Node:ClearChildren()
        local Params = {
            Target = self.Target,
            Type = self.Type,
            Tag = self.Tag,
            BehaviourType = "BreakLevelUp",
            LeftCallbackObj = self.Params.LeftCallbackObj,
            LeftCallbackFunction = self.Params.LeftCallbackFunction,
            CloseBtnCallbackObj = self.Params.CloseBtnCallbackObj,
            CloseBtnCallbackFunction = self.Params.CloseBtnCallbackFunction,
            IsSwitch = true
        }
        local UIConfig = DataMgr.SystemUI.ArmoryCardLevelWeapon
        self:CloseComp()
        self:InitUIInfo(UIConfig.UIName,true,nil,self.Type,self.Target,self,Params)
        self:ShowRefundResource()
        return
    else
        --继续升级
        if self.CurrentSubUI then
            self:InitLvUpView()
            self:RefreshListComp()
            self.CurrentSubUI:ReInitAfterIntensify()
        end
    end
end

function Component:ShowRefundResource(bExit)
    local RefundResources = self.RefundResources
    if not RefundResources or next(RefundResources) == nil then
        return
    end
    local Rewards = RewardBox:New()
    Rewards:AddResource(RefundResources)
    self.ItemPageUI = UIManager(GWorld.GameInstance):LoadUINew("GetItemPage", nil, nil, nil, Rewards:DumpAll())
    self.ItemPageUI.Text_GetItem:SetText(GText("Pet_LevelUp_ExpResource_Refund"))
    if not bExit then
        self.ItemPageUI:BindActionOnClosed(function()
            self.ItemPageUI = nil
            self:ReNavigateToListItem()
            self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
        end)
    end
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
    self:AddTimer(0.3, function()
        if self.ItemPageUI then
            local DesiredFocusTarget = self.ItemPageUI:BP_GetDesiredFocusTarget()
            if DesiredFocusTarget and DesiredFocusTarget.SetFocus then
                DesiredFocusTarget:SetFocus()
            end
            self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
        end
    end,nil,nil,nil,true)
    self.RefundResources = nil
    -- local ItemPageUI = UIManager(GWorld.GameInstance):LoadUINew("GetItemPage", RewardData.Type[1], RewardData.Id[1], RewardData.Count[1][1], Rewards)
    -- if ItemPageUI and ItemPageUI.BindActionOnClosed then
    --     ItemPageUI:BindActionOnClosed(function() Callback() end, self)
    -- else
    --     Callback()
    -- end
end

function Component:UpdateBtnState(bIsMaxLevel)
    if self.CurrentMode == "LevelUp" then
        if(bIsMaxLevel)then
            self.Btn_Enhance:SetIsEnabled(false)
            self.Panel_Limit:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            self.CurrentSubUI.ListView_Item:SetVisibility(UIConst.VisibilityOp.Hidden)
            self.CurrentSubUI.Panel_Hint:SetVisibility(UIConst.VisibilityOp.Hidden)
            self.CurrentSubUI.Sort_Pet:SetVisibility(UIConst.VisibilityOp.Hidden)
            self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
        else
            self.Btn_Enhance:SetIsEnabled(true)
            self.Panel_Limit:SetVisibility(UIConst.VisibilityOp.Collapsed)
            self.CurrentSubUI.ListView_Item:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            --self.CurrentSubUI.Panel_Hint:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            self.CurrentSubUI.Sort_Pet:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        end
    end
end

--region 手柄相关
function Component:RefreshOpInfoByInputDeviceComp(CurInputDevice, CurGamepadName)
    if self.CurrentMode == "LevelUp" then
        self.CurInputDeviceType = CurInputDevice
        if (CurInputDevice == ECommonInputType.Gamepad) and self:HasAnyFocus() then
            self:ReNavigateToListItem()
        end
    end
end

function Component:OnFocusReceivedComp(MyGeometry, InFocusEvent)
    if self.CurrentMode == "LevelUp" then
        if (self.CurInputDeviceType == ECommonInputType.Gamepad) then
            self:ReNavigateToListItem()
        end
    end
end

--重新导航至子Tab栏
function Component:ReNavigateToListItem(bToList, bExpandingList)
    if self.CurrentMode == "LevelUp" then
        if(not bToList and self.bListExpand)then
            local TileView = self.Selective_Listing.TileView_Select_Role
            if TileView:GetNumItems() > 0 then
                if bExpandingList then
                    TileView:NavigateToIndex(0)
                else
                    TileView:SetFocus() 
                end
            end
        else
            self.CurrentSubUI.ListView_Item:NavigateToIndex(0)
        end
    end
end

function Component:OnKeyDownComp(MyGeometry, InKeyName)
    if self.CurrentMode == "LevelUp" then
        if InKeyName == UIConst.GamePadKey.FaceButtonLeft then
            if not self.AutoPressed then
                self.AutoPressed = true
                self.Btn_Auto:OnBtnPressed()
            end
        elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
            if not self.EnhancePressed then
                self.EnhancePressed = true
                self.Btn_Enhance:OnBtnPressed()
            end
        elseif InKeyName == UIConst.GamePadKey.RightThumb then
            if not self.bListExpand then
                return false
            end
            local SelectedContent = self.ItemDetailsContent and self.CurrentSubUI:FindSelectedContent(self.ItemDetailsContent.Uuid)
            self.CurrentSubUI:OnMinusStart(SelectedContent)
        end
    end
end

function Component:OnKeyUpComp(MyGeometry, InKeyName)
    if self.CurrentMode == "LevelUp" then
        if InKeyName == UIConst.GamePadKey.FaceButtonLeft then
            if self.AutoPressed then
                self.AutoPressed = false
                self.Btn_Auto:OnBtnClicked()
            end
        elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
            if self.EnhancePressed then
                self.EnhancePressed = false
                self.Btn_Enhance:OnBtnClicked()
            end
        elseif InKeyName == UIConst.GamePadKey.RightThumb then
            if not self.bListExpand then
                return false
            end
            self.CurrentSubUI:OnMinusEnd()
        end
    end
end
--endregion 手柄相关

return Component
